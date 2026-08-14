# fNotes Review Handoff

Last updated: 2026-08-14
Workspace: `P:\vista\TMGCPRS_v30A_Delphi12`
Primary files:

- `CPRS-Chart\fNotes.pas`
- `CPRS-Chart\fNotes.dfm`
- `CPRS-Chart\uDocTree.pas`
- `CPRS-Lib\ORCtrls.pas`

## Goal Of This Review

Review the `fNotes` note-selection architecture with focus on:

- redundant note selectors
- duplicated note-data storage
- event cascades and display churn
- practical plan to make the left tree the primary controller

Follow-up work on 2026-08-14 added a new non-visual record-string list model:

- `CPRS-Chart\TMG_Extra\uTRecStrList.pas`

That unit should now be considered the preferred replacement target for the hidden `lstNotes` data-store role.

## Important Clarification

The visibly redundant selector at the top-right of the Notes tab is **not** `lstNotes`.

- `lstNotes` is a hidden `TORListBox` in `fNotes.dfm`.
- the visible secondary selector is `lvNotes`.
- `tvNotes` is the visible left tree.

Current architecture:

- `tvNotes` = visible hierarchy
- `lvNotes` = visible secondary selector for group/container nodes
- `lstNotes` = hidden master list/control holding raw TIU data strings
- `lstNotesClick` = the real controller for loading and displaying a note

## Current Data Flow

### Load path

`LoadNotes` builds multiple note representations from the same TIU data:

1. TIU RPC returns `^`-delimited note strings.
2. `lstNotes.Items` is filled with those raw strings.
3. `BuildDocumentTree` creates `tvNotes` nodes.
4. each tree node also stores:
   - full raw note string in `TORTreeNode.StringData`
   - parsed fields in `PDocTreeObject(Node.Data)^`
5. for some tree selections, `TraverseTree` also populates `lvNotes` with note data again.

This means the same note is often stored in several forms:

- raw string in `lstNotes`
- raw string again in tree node `StringData`
- parsed duplicate fields in `PDocTreeObject`
- selected fields again in `lvNotes` subitems

## Key Controls

### `TORListBox`

`TORListBox` is not just a visual list box. It is a VA/CPRS data-aware control built around delimited strings, usually `^` pieces.

Useful behavior from `ORCtrls.pas`:

- `Delimiter` defaults to `^`
- `ItemIEN` = piece 1 of selected item as integer
- `ItemID` = piece 1 of selected item as string/variant
- `GetIEN`, `SelectByIEN`, `SelectByID` parse item strings directly
- `DisplayText` and other helper logic are control-aware

So replacing `lstNotes` with a plain `TStringList` would lose convenience behavior unless a wrapper class is added.

### `PDocTreeObject`

`PDocTreeObject` in `uDocTree.pas` is a parsed record form of the same raw note data, not a separate source of truth.

It stores fields like:

- `DocID`
- `DocTitle`
- `DocFMDate`
- `DocParent`
- `Author`
- `Location`
- `Status`
- `Subject`
- `ImageCount`

`MakeNoteTreeObject(x)` builds that record by parsing the same `^`-delimited note string `x`.

So `PDocTreeObject` is effectively another storage projection of data already present in `lstNotes.Items` and often also in `TORTreeNode.StringData`.

## Current Event Flow

### For a leaf note node

Current path:

1. user selects note in `tvNotes`
2. `tvNotesChange`
3. `lstNotes.SelectByID(...)`
4. `lstNotesClick`
5. note text/view/edit state loads

### For a group/container node such as "All Notes"

Current path:

1. user selects group node in `tvNotes`
2. `tvNotesChange`
3. `lvNotes` is rebuilt from matching tree children
4. first `lvNotes` row is auto-selected
5. `lvNotesSelectItem`
6. `lstNotes.SelectByID(...)`
7. `lstNotesClick`
8. note text/view/edit state loads

This is likely a major source of:

- slow interaction
- multiple visible screen transitions
- apparent "double" or "triple" updates before settling

It behaves like an event cascade rather than a single selection action.

## Main Findings

### 1. The real redundancy is `lvNotes` + `tvNotes`, with `lstNotes` acting as hidden controller

The awkward UX the user described is caused by:

- left tree already showing notes/categories
- right-side `lvNotes` appearing as another selector when a group node is chosen

This is redundant at the UI level even before considering data duplication.

### 2. There is real duplicated note-data storage

The same note payload is stored multiple times in memory and reparsed multiple times.

This likely contributes to:

- load slowness on large note sets
- extra memory use
- extra CPU in build/sort/traverse phases

### 3. `lstNotesClick` is the true display controller

`lstNotesClick` currently owns the real work:

- switching read vs edit panels
- loading note text
- loading note details
- notifying images
- updating PCE/reminders
- updating display mode HTML/text

So even though the tree looks primary in the UI, the real logic still routes through the hidden list.

### 4. `EditingIndex` creates strong coupling to list position

Many `fNotes` behaviors depend on:

- `lstNotes.ItemIndex`
- `EditingIndex`
- `lstNotes.Items[EditingIndex]`
- `EditingNoteSelected := (lstNotes.ItemIndex = FEditingIndex)`

This is one of the biggest blockers to removing or demoting `lstNotes`.

### 5. External units depend directly on `frmNotes.lstNotes`

Direct external dependencies found:

- `CPRS-Chart\TMG_Extra\fUploadImages.pas`
- `CPRS-Chart\TMG_Extra\fSingleNote.pas`
- `CPRS-Chart\TMG_Extra\uImages.pas`

These files currently assume a real `TORListBox` on the form.

## Related Similar Patterns

The same hidden-list / note-list pattern appears elsewhere and may be worth comparing before major refactoring:

- `CPRS-Chart\Consults\fConsults.pas`
- `CPRS-Chart\fSurgery.pas`

Those units also use `lstNotes`-style controls heavily.

## Recommended Direction

### Best near-term direction

Keep the **`lstNotes` semantics** as the master note model for now, but move those semantics into the new non-visual `TRecStrList` class and stop making the tree and list views carry full duplicate note payloads where possible.

This means:

- do **not** rush to replace `TORListBox` with plain `TStringList`
- do **not** keep relying on hidden UI controls as long-term architecture
- first reduce duplication and event chaining in `fNotes`

### Why this direction

Pros:

- preserves CPRS/VA-style delimited-string helper behavior
- avoids breaking code that expects `ItemIEN`, `ItemID`, `SelectByID`, etc.
- provides a concrete non-visual migration target in `uTRecStrList.pas`
- lower risk than a total model rewrite
- allows staged performance work

Cons:

- still leaves a hidden-control-as-model smell temporarily
- does not fully solve architectural cleanliness

## Possible Fix Strategies

### Strategy A: Use `uTRecStrList` as master, make `tvNotes` lighter

This is the preferred first-phase approach.

Possible changes:

1. instantiate `TRecStrList` from `CPRS-Chart\TMG_Extra\uTRecStrList.pas` inside `fNotes`
2. move the canonical raw note list from hidden `lstNotes` into that `TRecStrList`
3. keep compatibility semantics through the new helper surface already started there:
   - `SelectedIndex`
   - `SelectedID`
   - `Item[...]`
   - `ItemPiece[...]`
   - `SelectedRecord`
   - `DeleteSelected`
   - `SelectedData['fieldname']` with schema support
4. make `tvNotes` nodes store only:
   - note IEN / ID
   - parent/group key
   - minimal visual metadata
5. reduce or eliminate full raw-string duplication in:
   - `TORTreeNode.StringData`
   - `PDocTreeObject`
6. stop using `lvNotes` as a second master selector
7. make `tvNotes` directly trigger display logic for leaf notes

Expected benefits:

- less duplicated data
- less parsing work
- fewer event cascades
- smaller conceptual gap between UI and actual controller

### Strategy B: Keep raw-string semantics, replace hidden control with `uTRecStrList`

Longer-term cleanup option:

1. finish `uTRecStrList` as the non-visual note-record model
2. move note storage out of the hidden form control
3. preserve helper methods such as:
   - `GetID`
   - `GetIEN`
   - `SelectByID`
   - `SelectByIEN`
   - `ItemPiece[...]`
   - `SelectedData[...]`

This would be cleaner, but is a larger refactor and should probably happen after `fNotes` selection flow is simplified.

### Strategy C: Remove `lvNotes` as an active selector

The visible redundancy is mostly `lvNotes`.

Possible options:

1. remove/hide `lvNotes` for note selection entirely
2. keep `lvNotes` only as a passive summary pane
3. for group-node selection in `tvNotes`:
   - expand/select first child directly, or
   - show summary without letting summary list own selection state

This will likely reduce user confusion more than any pure internal cleanup.

## Recommended Implementation Order

### Phase 1: reduce event churn while introducing `uTRecStrList`

1. instantiate `TRecStrList` in `fNotes`
2. populate it where `lstNotes.Items` is currently populated
3. extract note-display logic out of `lstNotesClick` into a shared routine
4. make `tvNotes` call that routine directly for leaf note nodes
5. reduce `tvNotes -> lvNotes -> lstNotes -> lstNotesClick` chaining
6. keep hidden `lstNotes` only as a temporary compatibility shim if needed during transition

### Phase 2: slim the tree

1. review all `tvNotes` uses of:
   - `StringData`
   - `PDocTreeObject`
2. determine which fields are actually needed for:
   - drawing/icons
   - grouping
   - attach/detach
   - PDF/loose-doc handling
3. remove full-record duplication where feasible

### Phase 3: rework editing state

1. move away from `EditingIndex` as primary edit-state identity
2. prefer note-IEN-based edit tracking
3. keep positional lookup only where unavoidable

This is likely necessary before `lstNotes` can be replaced or demoted further.

### Phase 4: external dependency cleanup

Review and adapt:

- `TMG_Extra\fUploadImages.pas`
- `TMG_Extra\fSingleNote.pas`
- `TMG_Extra\uImages.pas`

Likely these need either:

- a note-provider abstraction, or
- a transition layer that exposes `TRecStrList` data through helper methods instead of a hard dependency on `frmNotes.lstNotes`.

## Main Risks

### High risk

- breaking edit/save/sign flows tied to `EditingIndex`
- breaking image workflows that assume a live `TORListBox`
- breaking reminder/PCE code that expects `NoteList := lstNotes`

### Medium risk

- synthetic tree nodes such as `NEW`, `EDIT`, `ADDENDUM`, `ALERT`
- special handling for unsigned/addendum/component nodes
- loose documents / scanned records / PDF special cases

### Lower risk

- removing the visible `lvNotes` selector once direct tree selection is stable

## Suggested First Future Session

Do not start by deleting controls.

Instead:

1. map every place in `fNotes.pas` that reads:
   - `lstNotes.ItemIEN`
   - `lstNotes.ItemID`
   - `lstNotes.ItemIndex`
   - `lstNotes.Items[...]`
2. classify each usage as:
   - display loading
   - edit-state tracking
   - action command
   - image integration
   - reminder/PCE integration
   - external handoff dependency
3. extract a single shared routine from `lstNotesClick` for "display note by IEN / data string"
4. refactor `tvNotesChange` leaf-node path to call that routine directly
5. leave group-node / `lvNotes` behavior for a second pass

That should produce immediate clarity and may reduce the visible multiple-refresh behavior without yet redesigning the whole page.

## Bottom Line

The problem is real and has two parts:

- UI redundancy: `tvNotes` plus right-side `lvNotes`
- data/control redundancy: hidden `lstNotes` still acting as controller while tree and list views duplicate note data

Best practical next step:

- use `uTRecStrList` as the planned master store replacement for hidden `lstNotes`
- reduce duplicated data in `tvNotes`
- make the tree drive note display directly
- then decide whether `lvNotes` should be passive or removed
- finally remove hidden `lstNotes` once remaining cross-unit dependencies are adapted
