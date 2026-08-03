# EmbeddedED Dependency Map

Last updated: 2026-08-02

## Summary

The important architecture is:

`CPRS code -> THtmlObj (TMGHTML2) -> small host subset of TEmbeddedED -> MSHTML`

This means the real porting/cutting target is **not** "everything in `EmbeddedED.pas`".
It is:

1. keep the small `TEmbeddedED` host layer that `THtmlObj` truly needs
2. move any remaining app-facing helpers up into `TMGHTML2.pas`
3. retire the rest of the old DHTMLEdit compatibility surface in batches

## Inventory A: What CPRS Uses From THtmlObj

The CPRS tree mostly uses `THtmlObj`, not `TEmbeddedED`.

Common direct usages found across CPRS:

- construction and embedding
  - `THtmlObj.Create(...)`
- document content
  - `HTMLText`
  - `Text`
  - `Clear`
  - `GetFullHTMLText`
- editor state
  - `Editable`
  - `GetTextLen`
- caret / selection
  - `MoveCaretToEnd`
  - `MoveCaretToPos`
  - `SelText`
  - `SelStart`
  - `SelEnd`
  - `SelLength`
  - `Selection`
  - `SelectionInfo`
  - `SetSelectionByPos`
  - `SetSelectionByRange`
  - `SetSelectionByRangeInfo`
  - `GetTextRange`
  - `ClearSelection`
  - `ReplaceSelection`
- content insertion
  - `InsertHTMLAtCaret`
  - `InsertTextAtCaret`
- find/navigation
  - `Find`
  - `FindFirst`
  - `FindNext`
  - `FindNextExtendingSelection`
- DOM helpers
  - `GetElementById`
  - `GetElementsArrayById`
  - `GetElementByClass`
  - `GetElementsArrayByClass`
  - `GetElementByTagName`
  - `GetElementsArrayByTagName`
  - `IterateElements`
  - `SearchElements`
  - `AppendBodyNode`
  - `SetInnerHTMLByID`
- style/script helpers
  - `GetDocStyles`
  - `AddStyles`
  - `AddStylesToExistingStyleSheet`
  - `EnsureStyles`
  - `GetDocScripts`
  - `SetDocScripts`
  - `EnsureScripts`
- keyboard/input helpers
  - `Paste`
  - `SendKeys`
- formatting commands
  - `ToggleBold`
  - `ToggleItalic`
  - `ToggleUnderline`
  - `ToggleBullet`
  - `ToggleNumbering`
  - `Indent`
  - `Outdent`
  - alignment helpers

Conclusion:

- CPRS is already consuming a **`THtmlObj` API**, not a `TEmbeddedED` API.
- That is good news, because it means we can aggressively reduce `EmbeddedED` as long as `THtmlObj` stays stable.

## Inventory B: What TMGHTML2 Actually Uses From TEmbeddedED

The dominant inherited dependency is not dozens of helper methods.
It is the host/browser/document base.

### Heavy dependencies

These are the main inherited/base facilities actually used by `TMGHTML2.pas`:

- `DOC`
  - by far the most common dependency
  - used for direct MSHTML access, selection, body, execCommand, styles, scripts, DOM traversal
- `DocumentHTML`
  - used in `SetHTMLText`
- `NewDocument`
  - used to initialize an empty document
- `DoCommand`
  - used at least for font dialog command routing
- `WaitForDocComplete`
  - used by background-color and selection paths
- `SetFocusToDoc`
  - used by focus/caret handling
- inherited `Create`
- inherited `Destroy`
- inherited `Loaded`

### Light dependencies

These appear in `TMGHTML2`, but far less often:

- `SetFocusToDoc`
- `DoCommand`
- `WaitForDocComplete`

### Notably absent

`TMGHTML2` does **not** appear to rely heavily on most of the old `EmbeddedED` public helper surface such as:

- old DHTMLEdit wrapper methods
- old file/document compatibility entry points
- old print wrapper overloads
- most published compatibility properties
- many style/font query helpers exposed directly by `EmbeddedED`

## Current Practical Keep Set In TEmbeddedED

Keep for now:

- browser hosting / OLE / message routing / subclassing
- document assignment / initialization
- `DOC` and related core document access
- `DocumentHTML`
- `NewDocument`
- `Loaded`
- `Create` / `Destroy`
- `DoCommand`
- `WaitForDocComplete`
- `SetFocusToDoc`
- the minimum focus/selection plumbing still required by `THtmlObj`
- base URL / generator behavior until proven removable

This is the current "host core".

## Current Practical Remove/Move Set

### Already proven removable

- legacy DHTMLEdit document wrappers
- legacy custom context-menu wrapper path
- diagnostic `KSTest` path
- legacy print-wrapper overloads
- legacy `LoadURL`
- undo changelog popup hook

### Likely next large removals

1. Published compatibility/property surface in `TEmbeddedED`
   - especially properties never set from CPRS code or DFM
2. Style/font query helpers exposed by `TEmbeddedED`
   - if `TMGHTML2` can own or replace them
3. Remaining old DHTMLEdit compatibility API
4. File/save/print compatibility surface beyond what CPRS actually uses

## Best Next Engineering Move

Do not keep trimming random individual methods.

Instead:

1. Define a **minimal host interface** that `THtmlObj` truly needs from `TEmbeddedED`.
2. Mark everything outside that interface as either:
   - move to `TMGHTML2`
   - retire from `EmbeddedED`
3. Cut by zones, not symbols.

## Recommended Cut Zones

### Zone 1: Published compatibility properties

Good next batch candidate because much of it looks unused by CPRS:

- `OnShowContextMenu`
- `OnShowContextMenuEx`
- `OnQueryService`
- `OnTranslateURL`
- `OnBeforeSaveFile`
- `OnAfterSaveFile`
- `OnAfterSaveFileAs`
- `OnAfterLoadFile`
- `OnBeforePrint`
- `OnAfterPrint`
- `OnUnloadDoc`
- `OnRefreshBegin`
- `OnRefreshEnd`
- `ShowDetails`
- `SnapToGridX`
- `SnapToGridY`
- `SnapToGrid`
- `UseDivOnCarriageReturn`

These still need final internal-reference review, but they are much better candidates than core document/selection code.

### Zone 2: Embedded style/font helper API

Candidate methods:

- `GetFonts`
- `GetFontNameIndex`
- `GetFontSizeIndex`
- `GetStylesIndex`
- possibly `GetStyles` / `SetStyle` related surface

If any of this still matters to CPRS, it likely belongs in `TMGHTML2`, not `EmbeddedED`.

### Zone 3: Generator/base-url/designer surface

Review carefully before cutting:

- `Generator`
- `BrowseMode`
- `BaseURL`
- `ShowDetails`

These still have internal references, so they are not "free" removals, but they are compatibility/designer flavored rather than core app behavior.

## Bottom Line

The dependency map strongly suggests that `EmbeddedED.pas` can be shrunk much faster by treating it as:

- a small browser host core to preserve
- plus large removable compatibility zones

rather than continuing one method at a time.
