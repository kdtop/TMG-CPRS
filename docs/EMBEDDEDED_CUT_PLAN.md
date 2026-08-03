# EmbeddedED Cut Plan

Last updated: 2026-08-02

## Goal

Reduce `CPRS-Chart/TMG_Extra/HTMLEdit/EmbeddedED/EmbeddedED.pas` to only the code needed by:

- `CPRS-Chart/TMG_Extra/HTMLEdit/TMGHTML2.pas`
- callers of `THtmlObj` throughout CPRS

Everything else should either:

- move into `TMGHTML2.pas`, or
- be commented out and retired from `EmbeddedED.pas`

## High-Level Call Graph

### External app code

Most CPRS units do **not** talk to `TEmbeddedED` directly.
They talk to `THtmlObj` from `TMGHTML2.pas`.

So the practical graph is:

`CPRS forms/helpers -> THtmlObj -> small subset of TEmbeddedED -> MSHTML/IE host`

### What `THtmlObj` mostly does itself

`THtmlObj` already owns most of the application-facing behavior:

- text/html getters and setters
- selection/range helpers
- edit commands
- style/script document helpers
- DOM search helpers
- paste handling
- keyboard/message handling

Most of that code works directly through:

- `DOC`
- `DocumentHTML`
- `NewDocument`
- `DoCommand`
- `SetFocusToDoc`
- `Loaded`
- inherited message/focus plumbing

That means a large amount of old DHTMLEdit-compatible surface in `EmbeddedED.pas` is not part of CPRS's real runtime path.

## Current Known Keep Set

These areas are still likely part of the active runtime base for `THtmlObj`:

- browser hosting / subclassing / message routing
- document assignment and initialization
- `DOC` access
- `DocumentHTML`
- `NewDocument`
- `DoCommand` / `CmdSet` / `CmdGet`
- selection state used by inherited helpers still reached from `THtmlObj`
- focus helpers including `SetFocusToDoc`
- `Loaded`
- base URL / generator handling until proven otherwise

These should be treated as the current core.

## Current Known Dead / Legacy Zones

These have already been shown to have no CPRS call sites and are good examples of removable compatibility surface:

- old DHTMLEdit document wrappers
  - `LoadDocument`
  - `SaveDocument`
- old custom context-menu wrapper path
  - `SetContextMenu`
  - `FContextMenuClicked`
- legacy diagnostic hook
  - `KSTest`
  - `KS_TEST` dispatch branch
- legacy print-wrapper overloads
  - `Print(TPrintSetup...)`
  - `PrintEx(...)`
  - `PrintPreview(...)` overloads
  - helper methods used only by those wrappers
- legacy `LoadURL(...)` compatibility wrapper
- undo changelog popup hook
  - `OpenChangeLog`

## Practical Cut Strategy

Instead of deleting isolated members one by one, cut in larger zones:

### Zone A: Old DHTMLEdit compatibility API

This is the best next target.

Includes old published/public surface such as:

- compatibility wrappers not used by CPRS
- compatibility properties that only exist for DHTMLEdit-style hosting
- callback/event glue only supporting those wrappers

This zone should be removable in larger groups once internal references are severed.

### Zone B: Print / save / file-dialog legacy surface

Keep only what CPRS actually uses.

Likely keep:

- `PrintDocument(var withUI)`
- file/document loading pieces still needed by current startup/document assignment

Likely remove:

- older wrapper overloads and UI compatibility entry points

### Zone C: Style/font helper surface exposed by `EmbeddedED`

Many of these methods appear unused outside `EmbeddedED` itself:

- `GetFonts`
- `GetFontNameIndex`
- `GetFontSizeIndex`
- `GetStylesIndex`
- some style-query helpers

Before cutting, confirm whether `TMGHTML2` actually depends on them indirectly.

### Zone D: Published component-designer property surface

This includes old component properties that CPRS does not set from code or DFM.

Examples to evaluate:

- `Generator`
- `BrowseMode`
- `ShowDetails`
- `SnapToGridX`
- `SnapToGridY`
- `SnapToGrid`
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

Some of these may still be used internally even if nothing external sets them, so this zone should be cut after confirming internal-only dependencies.

## Recommended Next Phase

Build two concrete inventories:

1. `THtmlObj` external surface actually called by CPRS.
2. `TEmbeddedED` members actually touched by `TMGHTML2`.

Then classify `EmbeddedED` into:

- core host layer to keep for now
- app-facing helpers to move into `TMGHTML2`
- dead compatibility surface to comment out in batches

## Expected Outcome

This should allow larger edits such as:

- removing whole published/property blocks together
- removing whole compatibility wrapper sections together
- eventually shrinking `THtmlObj`'s inherited dependency on `TEmbeddedED` to a much smaller core

That is a better path than continuing one method at a time for weeks.
