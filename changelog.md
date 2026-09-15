# CPRSChart Changelog

Dated status updates, milestones, compile history, and local checkpoints belong here. Keep [HANDOFF.md](HANDOFF.md) focused on current context and standing instructions. Add new dated entries above the archived history.

## 2026-09-14 — Topics tab foundation and patient-topic list

- Added `CT_TOPICS` and a `Topics` chart tab. It follows the Pop. Health tab's frame lifecycle, is available on either tab side like Labs/Reports, and is owned/freed with the other frame pages.
- Added `TMG_Extra\fTopics.pas` / `.dfm` with three columns. The left column includes `lvTopics: TCaptionListView`, automatic hover open/collapse, and a timed splitter-handle button. The center and right columns retain their initial placeholder browser controls for later topic-entry and related-data work.
- Added `rTopics.pas`, registered it in the DPR/DPROJ, and used its `TopicList` RPC wrapper to load `lvTopics` from `TMG RPC THREAD/TOPIC CMD`.
- `RefreshTopicList` displays Topic, Hidden, and User Data. Each list item's private data object retains the returned topic sub-IEN/property ID for later selection/edit operations.
- `TfrmFrame.ClearPatient` clears Topics data, and `SetupPatient` calls `RefreshTopicList` after `ProcessPatientChangeEventHook`, once the selected patient context is valid. The form does not query Topics during creation.
- User compiled and ran the completed state successfully. The local 2026-09-14 interval snapshot captures this state.

## 2026-09-10 — Wine modal-dialog investigation and remote-debugger experiment

### Confirmed Modal Behavior

- The standalone Delphi 12 test project is `CPRS-Chart\TMG_Extra\killlater\Project1.dproj`. Its launcher is `/home/kdt0p/Desktop/CPRS KillLater Test.desktop`, which starts `Win32\Debug\Project1.exe` in `WINEPREFIX=/home/kdt0p/.wine-cprs-ie8`.
- The test program creates `TForm2` from `TForm1` and calls `ShowModal`; it behaves normally under the same Wine prefix. This rules out a general Wine/Delphi 12 VCL `ShowModal` failure.
- X11 inspection of the working demo showed `Form2` transient for the visible `Form1` client window.
- CPRS dialogs differ: both the visible CPRS main window and modal-looking dialogs are transient for Wine's hidden 1x1 group-leader window titled `CPRS - Patient Chart`, rather than the visible main CPRS window. The X11 window IDs are ephemeral; re-query every run.
- In the dev2006 CPRS instance, a hidden `Confirm?` timer dialog was active and viewable but behind the main CPRS window. `xdotool windowactivate <Confirm-window-id>` brought it forward. This confirms a real Wine/X11 stacking/ownership issue.
- In the Delphi 12 instance, after selecting a patient and pressing OK, X11 still reported `Patient Selection` as `IsViewable`, focused, and `_NET_ACTIVE_WINDOW`. The main CPRS window was not active. `Image Transfer Progress` was `IsUnMapped` at that moment. Therefore the selector had not completed its normal native hide/close path; it was not merely hidden behind the main form in that snapshot.

### Interpretation and Source Status

- `ModalResult := mrOK` is a VCL-level signal that should end `ShowModal`; Windows/Wine/X11 implement the native hide/activation resulting from that VCL path. X11 cannot reveal the Delphi `ModalResult` value.
- Do not conflate Delphi component ownership (`TForm.Create(AOwner)`), control parenting, and native top-level window ownership/transience. `Create(AOwner)` establishes `TComponent.Owner`; it does not directly establish a visual parent.
- A possible, untested, narrow source experiment is to override `TfrmPtSel.CreateParams` and set `Params.WndParent` to the intended visible form handle. For a top-level Win32 form this establishes the native owner even though the field is named `WndParent`. Do not apply this broadly or assume it fixes the failure without retesting X11 properties.
- No Confirm Timer ownership/source change was made in this session. `TMG_Extra\fConfirmTimer.pas` currently creates its dialog with `TfrmConfirmTimer.Create(nil)`; that observation is not proof that component ownership alone caused the X11 relationship.

### Existing Temporary Runtime Diagnostics

- `CPRS-Chart\TMG_Extra\uDebugTools.pas` was added as a nonvisual diagnostic helper. `DebugMsg(Msg)` appends to `cprs_debug.log`; `DebugMsg(LogFileName, Msg)` appends to the named log in Wine's temp directory.
- `fPtSel.pas` sends its temporary selector diagnostics through `uDebugTools` to `cprs_ptsel_diag.log`; `BA\UBACore.pas` writes BA diagnostics to `cprs_ba_diag.log`.
- Wine log paths:
  - `/home/kdt0p/.wine-cprs-ie8/drive_c/users/kdt0p/Temp/cprs_ptsel_diag.log`
  - `/home/kdt0p/.wine-cprs-ie8/drive_c/users/kdt0p/Temp/cprs_ba_diag.log`
  - `/home/kdt0p/.wine-cprs-ie8/drive_c/users/kdt0p/Temp/cprs_debug.log`
- Earlier removal of three `Application.ProcessMessages` calls in `TfrmFrame.SetBADxList` eliminated a BA re-entrancy path. The explicit `ModalResult := mrOK` / `mrCancel` changes in `fPtSel.pas` were compiled but did not make patient selection complete normally under Wine.

### Delphi Remote Debugger Under Wine

- The Delphi 12 PAServer directory was copied to `/mnt/WinPublic/vista/temp/PAServer`.
- Installed the minimal Win32 remote-debugger files in the CPRS Wine prefix at `C:\CPRSRemoteDebug`: `rmtdbg290.exe`, `bordbk290.dll`, `dcc32290.dll`, `comp32x.dll`, and `bcc.msg`. `bordbk290.dll` was registered successfully with Wine `regsvr32`.
- Start the server only with the console-preserving command:

  ```bash
  DISPLAY=:1 WINEPREFIX=/home/kdt0p/.wine-cprs-ie8 \
    wine start /unix '/home/kdt0p/.wine-cprs-ie8/drive_c/CPRSRemoteDebug/rmtdbg290.exe'
  ```

  The black Wine console is expected and must remain open. The server listens on `192.168.3.57:64447`.
- Delphi 12's `Attach to Process` reached the server: it spawned a per-connection `rmtdbg290.exe -socket ...` process and loaded the `BORDBK290` bridge. However, the Delphi remote-connection dialog became unresponsive and the server sometimes exited. This is beyond a firewall, port, or basic registration failure and likely reflects an unsupported Wine/Embarcadero remote-debugger interaction.
- Do not keep collecting guessed DLLs or run `setup_paserver.exe` inside the CPRS Wine prefix. The copied PAServer installation already lacked `DCCIL290.dll`; its string reference in `bordbk290.dll` is dynamic/possibly optional, not proof of the observed hang.
- Treat source-level remote debugging from the Windows Delphi IDE into Wine as currently nonviable. Prefer targeted Delphi logging plus `xwininfo`/`xprop`/`xdotool` evidence, or debug the same executable in real Windows/VM when full stepping is needed.

### Related Environment Fix

- `/home/kdt0p/.local/share/applications/cprs-wine.desktop` launches the dev2006 CPRS shortcut `TMGCPRS v30A - GOOD\CPRS-Chart\CPRSChart.exe - Shortcut.lnk`.
- Its stored UTF-16LE argument was corrected from `s=192.168.3.18 p=9260` to `s=192.168.3.99 p=9260`. Original retained as the adjacent `.lnk.bak`. User confirmed the launcher works.

## 2026-09-08 — Health factors available before note signature

- Traced reminder-dialog health-factor persistence through `TPCEData.Save` and `ORWPCE SAVE`.
- The reminder dialog already requested `ForceForegroundSave = true`, and the RPC wrapper already accepted and transmitted it, but `TPCEData.Save` discarded the parameter when calling the wrapper.
- Forwarded the parameter to `SavePCEData`, allowing reminder PCE data—including health factors—to complete server-side before the Encounter dialog reloads the note encounter.
- User verified the fix works before signature.

## 2026-09-08 — Removed experimental note components

- Removed the unused note-component creation workflow, its menus/buttons, template parser, quick-console `ADD COMPONENT` command, component tree behavior, and its project units/forms.
- Normal addendum creation is now self-contained and cannot send the component-triggering `1701` field. `LoadDocumentText` again makes the standard one-argument call; `VIEW;A` is no longer used.
- Template insertion now leaves any legacy component markup as ordinary literal text, as requested.
- Replaced `uNoteComponents.IndexOfPiece` in `fProbAutoAdd` with a local generic piece-search helper so its unrelated problem/topic lookup continues to work.
- Requires a fresh Delphi IDE build and targeted runtime check; command-line compilation is unavailable in this environment.

## 2026-09-08 — Notes selection, formatting, and checkpoint

- Updated `fNotes.LoadNotes` to accept a preferred note IEN and optional activation, restoring the requested note before document activation. If it is absent from the returned list, the display stays blank with an explanation.
- Signature paths preserve the note IEN, suppress intermediate tree-selection callbacks, and no longer fall back to the first tree node.
- Renamed `FindPieceNode` parameter `StartNode` to `AfterNode` in both copies of `ORCtrls.pas`, documenting its exclusive behavior and whole-tree search with `nil`. Updated 65 whole-tree callers; reminder iteration and parent-based searches retain their behavior.
- User reported that the selection/search changes work well and made substantial formatting/comment cleanup in `fNotes.pas`. Moved 54 `begin` statements onto their preceding `then` lines; at the user's one-time request, removed the tags added solely for that formatting pass.
- Updated `ReloadNotes` to preserve an `Int64` editing IEN, defer view activation when resuming editing, synchronize the selected note model, and call `AutoEditCurrent` directly. User reviewed and accepted the result; no separate compile/runtime result was recorded for this final adjustment.
- Created local checkpoint `db7fb43`, "Checkpoint Delphi 12 work and note selection reload improvements": 183 changed files, including accumulated source/form/project changes and two project icons. Working tree was clean immediately afterward; nothing was pushed.
- Moved historical status material out of `HANDOFF.md` into this file.

## Archived handoff history (through 2026-08-25)

The following material is preserved verbatim from the previous handoff, in its original order. Dates and references to "current," "next session," HEAD, or build logs describe the state when those notes were written; they are not current instructions.

## Goal

Primary current goal as of 2026-08-18:

- Keep CPRSChart working under Delphi 12 while continuing the `fNotes` refactor away from hidden-control note-selection architecture and into performance cleanup.
- Preserve successful Delphi IDE compile/runtime behavior while centralizing note-list reads/writes behind helper methods and `uTRecStrList`.

Secondary goal when needed:

- If the user reports a new compile regression, return temporarily to compile-blocker triage using a fresh Delphi IDE compile log.

Next planned feature goal for the next session:

- Extend the server-side logic behind the Reports tab `Imaging (local only)` report so it can also include TIU documents that are effectively radiology studies, especially scanned outside reports that are currently only discoverable through specific note titles on the Notes tab.
- On the CPRS client side, when one of those TIU-backed imaging entries is selected in the report list/tree flow, switch the display area to a browser/document view and render the TIU document similarly to the current Notes-tab document display path.

Compile-log workflow, only when the user reports a new compile failure:

1. User compiles in the Delphi IDE.
2. User saves compiler output to `CPRS-Chart\build_errors.txt`.
3. Agent reads `CPRS-Chart\build_errors.txt`.
4. Agent patches the next compile blocker, if any.
5. Repeat.

Command-line build is not currently useful because the installed Delphi edition reports:

`This version of the product does not support command line compiling.`

When there is an active compile problem, use the fresh IDE compile log as the source of truth. Otherwise, assume `fNotes` refactoring plus normal runtime verification is the active work.

Substantive local baseline commits, newest first:

- `e564182 Checkpoint HTML editor streamlining milestone`
- `2d6ed84 Checkpoint current Delphi 12 HTML editor/debugging state`
- `f08ed49 Document local git baseline`
- `497962a Create Delphi 12 working tree baseline`
- `54f1dc1 Ignore Delphi compiled unit artifacts`
- `12afbc9 Port CPRS Broker source for Delphi 12`

These commits are local checkpoints in the copied Delphi 12 working tree. As of 2026-08-14, `HEAD` is `e564182` on `master`, and it is a real source checkpoint, not just a `HANDOFF.md`-only documentation commit. `origin/master` still points at the older source history (`c58ce2b` at the time this handoff was updated), so this branch is intentionally ahead of `origin/master`. That does not mean the real source tree elsewhere has been changed.

`git status --short` was clean immediately after the 2026-07-30 handoff-only update. That is no longer a safe assumption for later sessions. As of 2026-07-31, the user reports the local git view has not been updated in a few days and the working tree may contain intentional uncommitted edits plus generated artifacts and backup files.

`.dcu` files were removed from Git tracking and ignored. `.gitignore` contains `*.dcu` and `*.DCU`.

## Current State

As of 2026-08-15, the current local baseline still includes the `e564182` HTML streamlining checkpoint, but the active source work has shifted to `CPRS-Chart\fNotes.pas`. The user has repeatedly confirmed successful Delphi IDE compile and normal runtime startup after each `fNotes` refactor step.

Important:

- Do not assume older `CPRS-Chart\build_errors.txt` notes below are current.
- If the user reports a new compile problem, ask for a fresh IDE compile log.
- Otherwise, assume the main active work is `fNotes` refactoring under a currently working Delphi 12 runtime.

Recommended working assumption for the next session:

- Start from `fNotes`/`uTRecStrList` refactoring unless the user explicitly says the build is failing again.
- Treat `CPRS-Chart\build_errors.txt` as historical context unless the user has just saved a fresh compile log from the Delphi IDE.

### Runtime / Debugging Status As Of 2026-08-18

- The application compiles and can start, log in, and communicate with the RPC Broker.
- Several Delphi 12 runtime/designer compatibility issues have been found and fixed incrementally.
- Current work has shifted to runtime AV/debugger cleanup in chart tabs and older helper units.
- The user is reviewing the `HTMLEdit` area cautiously. The `EmbeddedED` implementation has already been cut out of the active source tree; do not assume older `EmbeddedED`-specific cleanup notes still apply without re-checking the current files.
- Active source refactor as of 2026-08-18: `CPRS-Chart\fNotes.pas` has been converted so `FNoteData: TRecStrList` is the live note-list model.
- The hidden `lstNotes: TORListBox` compatibility control has now been removed from the live form/runtime path and deleted from `CPRS-Chart\fNotes.dfm`.
- Brief runtime testing after the removal was reported good by the user, and the project compiles again in the Delphi IDE.
- A recent runtime bug involving corrupted downloaded images was fixed by restoring byte-oriented handling in the image transfer path. Do not casually reintroduce Unicode/string changes in RPC/image payload code.
- A new runtime/editor crash in the single-note HTML path was also fixed:
  - `CPRS-Chart\TMG_Extra\HTMLEdit\TMGHTML2.pas`
  - `CPRS-Chart\TMG_Extra\fSingleNote.pas`
  - The fix hardens `createRange` / selection handling and avoids an early warmup insert before the editor is ready.

### Reports / `TDataStr` Status As Of 2026-08-18

- The Reports tab had a runtime regression during default-report restore and initial click/load.
- `CPRS-Chart\fReports.pas` was updated to make the startup path more tolerant and less re-entrant:
  - `SelectUserDefaultReport()` now restores selection only and no longer directly drives report-load logic.
  - Default-report persistence now stores and restores both:
    - visible report caption via `TMG_LAST_REPORT_KEY`
    - stable report ID via new `TMG_LAST_REPORT_ID_KEY`
  - `tvReportsClick()` now exits safely when selection/data is missing or the form is destroying.
- A runtime `List index out of bounds(1)` exception in `Vcl.ComCtrls.TListItem.SetSubItemImage` was fixed in the Imaging report path:
  - the code was using `SubItemImages[1]` when only one subitem existed
  - this was corrected to use the first subitem slot and to guard nearby `Columns[1]` accesses
- `CPRS-Chart\fReports.pas` also received a small readability/perf cleanup:
  - `LoadTreeView()` now avoids repeated `Piece(...)`/`Pieces(...)`/`MakeReportTreeObject(...)` calls on the same source line
  - `tvReportsClick()` now dereferences `PReportTreeObject(tvReports.Selected.Data)` once into a local pointer instead of repeating the same cast/dereference many times
- `CPRS-Lib\ORFn.pas` `TDataStr` was upgraded while preserving its public API:
  - fixed `AssignViaMap(...)` bug where `<local>=<source>` mistakenly read both names from piece 1
  - added cached field-name lookup via a sorted index list
  - changed `DataStr` to a setter so cache invalidation happens on direct assignment too
  - replaced cached copied-piece strings with cached piece spans (`StartPos`/`Len`) so the source string remains the single truth and values are materialized only on demand
  - `StaticValue(...)` was simplified to avoid allocating a temporary `TStringList` on every call
- User report after rebuild:
  - compiles OK
  - runs OK
  - Reports tab regression appears resolved in current testing

Recommended next session start:

1. Runtime-test the new `fReports` list-view HTML detection path with:
   - one plain-text report
   - one HTML-backed report
   - one multi-select text append case
2. If the single-select HTML/text switching works, continue the Reports tab / imaging work from a product-design angle rather than low-level debugging.
3. Review the server-side RPC contract for `Imaging (local only)` and define how TIU-scanned radiology studies should be represented in the returned dataset.
4. Reuse existing Notes-tab TIU HTML/web-display behavior where possible instead of inventing a second document-rendering path.

### Reports HTML Display Status As Of 2026-08-22

- Active source work this session was in `CPRS-Chart\fReports.pas`.
- A new Reports-side display mode helper now exists:
  - `TReportDisplayMode = (rdmText, rdmHTML)`
  - `FReportDisplayMode`
  - `SetDisplayToHTMLvsText(...)`
- This helper explicitly reasserts text-vs-browser UI state each time, similar in spirit to `fNotes`, instead of relying on the prior control state.
- `WebBrowser1DocumentComplete()` no longer gates only on `uReportType = 'H'`; it now respects `FReportDisplayMode = rdmHTML`.
- `lvReportsSelectItem()` now checks single-report content with `uHTMLTools.TextIsHTML(uLocalReportData.Text)` in these list-view branches:
  - imaging
  - nutrition
  - procedures
  - surgery
- Current behavior:
  - single selected HTML report switches to `WebBrowser1`
  - single selected plain-text report switches to `memText`
  - multi-select plain-text append now goes through `SetDisplayToHTMLvsText(..., Append=True)` instead of manual `memText.Lines.Add(...)` loops
- `SetDisplayToHTMLvsText(..., Append=True)` now inserts the legacy `===============================================================================` separator before appended text, centralizing that behavior.
- The old per-branch separator lines and the old `Facility: ...` lines were removed from active code but preserved in place as `//kt //codex original --> ...` comments.
- The old `Freeze Text` / `uFrozen` feature was reviewed:
  - it is separate from the new HTML/text mode work
  - it pins selected `memText` text into `Memo1`
  - HTML mode currently hides `Memo1`; this is acceptable for now because the feature is low priority
- Important limitation not yet implemented:
  - multi-select HTML aggregation is not solved
  - do not assume concatenating multiple full HTML documents will be reliable in `TWebBrowser`
  - if needed later, combine body fragments into one wrapper document instead
- No Delphi IDE compile or runtime verification was performed after these `fReports` changes in this session.

### Reports Imaging TIU Merge Status As Of 2026-08-24

- Active source work this session was in:
  - `CPRS-Chart\fReports.pas`
  - `CPRS-Chart\rReports.pas`
- The local `Imaging (local only)` report is now working toward a mixed row model where returned items may represent either:
  - traditional radiology studies (`RAD`)
  - TIU-backed scanned radiology documents (`TIU`)
- `CPRS-Chart\rReports.pas`
  - `ListImagingExamsForDFN()` now calls `TMG TIU RAD EXAMS`
  - piece 20 is being used as the row mode discriminator
  - `RAD` rows are still reshaped into the legacy client-facing imaging row format
  - the user has restored `RAD` into piece 20 after reshaping so downstream code can still test row mode
- `CPRS-Chart\fReports.pas`
  - imaging list population now has explicit `TIU` handling in the `QT_IMAGING` branch
  - `TIU` rows are displayed in the existing imaging columns with:
    - date/time in the Date/Time column
    - TIU title in the Procedure Name column
    - `Scanned Doc` in Report Status
    - `TIU` in the Exam Status column as the current client-side branch signal
    - IEN8925 duplicated into the hidden row ID slot and the visible Case# column
  - `TIU` rows are no longer sent through `LoadProceduresTreeView()`; that remains RAD-only
  - `lvReportsSelectItem()` in the imaging branch now checks `Item.SubItems[4] = 'TIU'`
  - when the row is `TIU`, the client now:
    - skips RAD procedure-tree synchronization
    - loads the document via `rTIU.LoadDocumentText(...)` instead of `LoadReportText(...)`
    - reuses the normal TIU HTML/text detection path, including `ScanForSubs(...)` preprocessing for embedded images/downloaded local references
    - displays the document via the Reports-side `SetDisplayToHTMLvsText(...)`
    - sends `NotifyOtherApps(NAE_REPORT, 'TIU^<IEN8925>')`
  - invalid TIU row IDs now clear the current display/title before exiting so stale report text is not left on screen
- Current open design/implementation limitations:
  - the branch signal currently depends on `Item.SubItems[4] = 'TIU'`; it is not yet driven from a preserved raw row model object
  - TIU multi-select aggregation is not designed yet
  - only the single-select TIU display path was updated in this session
  - RAD shared-report / procedures-tree flows should be rechecked after runtime testing to ensure the new TIU branch did not disturb them
- Recommended next session start:
  1. Delphi IDE compile and runtime-test one `RAD` imaging row and one `TIU` imaging row
  2. confirm scanned-image HTML actually renders through the reused TIU `ScanForSubs(...)` path in Reports
  3. decide whether `Item.SubItems[4] = 'TIU'` is sufficient long-term or whether imaging rows should retain a cleaner per-row raw mode payload
  4. only after runtime validation, consider cleanup/refactor of duplicated TIU identifiers in the imaging row layout

### Frame / Tab Cleanup Status As Of 2026-08-25

- Active source work this session was primarily in:
  - `CPRS-Chart\fFrame.pas`
  - `CPRS-Chart\fFrame.dfm`
  - `CPRS-Chart\uConst.pas`
- The application was reported by the user to compile and run after substantial local tab-removal work.
- Banner/header cleanup completed:
  - the stray `pnlRemoteData` caption bleed-through was removed
  - `lblCIRN` was hidden to avoid overlap with local site-specific banner content
  - the unused top-banner zoom buttons were removed from the form/class definition
  - the green ghost demographics text behind the patient name was fixed by clearing `pnlPatient.Caption` instead of duplicating patient text into that panel
- Tab-removal hardening completed for omitted tabs such as `CT_MEDS`, `CT_DCSUMM`, and local web tabs:
  - key page-form variables are explicitly initialized to `nil` in `FormCreate()`
  - `AllowContextChangeAll(...)` now checks `Assigned(...)` before calling into tab forms that may not exist
  - many remaining `frmMeds` and `frmDCSumm` references in `fFrame.pas` were guarded with `Assigned(...)` to avoid immediate startup/runtime AVs when those tabs are not created
  - `SelectChartTab(...)` now exits cleanly if `PageIDToTabIndex(...)` returns `-1`
- A runtime selector bug was then fixed in `tabPagesChange()`:
  - symptom: clicking `Dashboard` displayed the dashboard page, but the selector highlight snapped to `Cover Sheet`
  - cause: duplicate-tab avoidance still considered the remembered right-side tab even when the right panel was collapsed
  - fix: when the other side is `tpsRight` and `FTabPageOpenMode = tpoClosed`, the other side is treated as `CT_NOPAGE` for duplicate-page arbitration
- User report after runtime test:
  - the dashboard-tab selection issue now appears fixed
- Recommended next session start:
  1. continue removing/retaining tabs cautiously, assuming `fFrame` still has many historical references to optional pages
  2. if another selector anomaly appears, re-check `tabPagesChange()` first before changing page-ID constants
  3. if the user wants another checkpoint after more runtime testing, commit the current `fFrame`/form cleanup separately from unrelated feature work when practical

### HTML / HTMLEdit Status As Of 2026-08-13

- The current `HEAD` checkpoint is `e564182 Checkpoint HTML editor streamlining milestone`.
- `THtmlObj` in `TMGHTML2.pas` now descends from `TWebBrowser`, not `TEmbeddedED`.
- The active HTMLEdit implementation is now centered in `CPRS-Chart\TMG_Extra\HTMLEdit\TMGHTML2.pas`, including the merged `//kt //codex From EmbeddedED` block.
- The old `EmbeddedED` source folder was removed from the tracked source tree in this checkpoint, along with old `IE*.pas`, `Ewb*.pas`, `EWB*.pas`, `IEdispConst.pas`, and `MSHTML_EWB.pas`.
- `MSHTMLEvents.pas` is still present in the tree and remains part of the current HTML stack.
- Some Delphi IDE/session artifacts may still mention deleted `EmbeddedED` paths. Treat those as historical/editor state unless a fresh compile proves they are still relevant.
- For the next HTML cleanup pass, start with:
  - `CPRS-Chart\TMG_Extra\HTMLEdit\TMGHTML2.pas`
  - `CPRS-Chart\TMG_Extra\uHTMLDlgObjs.pas`
  - `CPRS-Chart\TMG_Extra\uHTMLTemplateFields.pas`
  - `docs\EMBEDDEDED_CUT_PLAN.md`
  - `docs\EMBEDDEDED_DEPENDENCY_MAP.md`

### Notes / `uTRecStrList` Status As Of 2026-08-18

- A new non-visual record-string helper unit now exists:
  - `CPRS-Chart\TMG_Extra\uTRecStrList.pas`
- This unit is intended to become the replacement backing store for the hidden `lstNotes` role in `fNotes`.
- Current `TRecStrList` capabilities include:
  - `Add`, `Insert`, `Delete`, `Exchange`, `Clear`
  - `GetID`, `GetIEN`, `IndexOfID`, `IndexOfIEN`, `SelectByID`, `SelectByIEN`
  - `SelectedIndex`, `SelectedID`, `SelectedRecord`, `DeleteSelected`
  - indexed record access via `Items[Index]`
  - piece access via `ItemPiece[Index, PieceNum]`
  - optional field-name schema lookup via `SelectedData['fieldname']` after `SetSchema(...)`
- The numeric identifier from piece 1 is cached in `TStringList.Objects[]`; non-numeric piece-1 values are stored as `-1`.
- `uTRecStrList` is now partially wired into `fNotes` through `FNoteData` and a growing helper layer.
- `uTRecStrList` now also includes:
  - `SaveToSL`
  - `AppendFromSL`
- Current `fNotes` helper/model surface includes:
  - `NoteRecordAt`, `NoteIDAt`, `NoteIENAt`
  - `NoteCount`
  - `UpdateNoteRecordAt`
  - `SelectedNoteIndex`, `SelectedNoteRecord`, `SelectedNoteID`, `SelectedNoteIEN`
  - `SetSelectedNoteIndex`
  - `ClearNoteRecords`, `AddNoteRecord`, `InsertNoteRecord`
  - `SelectNoteIDViaModel`
  - `GetCurrentNoteID`, `GetCurrentNoteIEN`
- Many former direct `lstNotes` reads now route through those helpers, including much of:
  - note display loading
  - sign/cosign flows
  - addendum/component flows
  - delete flow entry
  - image/reminder external integrations
  - print path
- External direct `frmNotes.lstNotes` dependencies were reduced:
  - reminders now use callback getter(s) rather than `NoteList := lstNotes`
  - image support now uses active TIU-IEN getter callbacks rather than `SetActiveListBoxForImages`
  - upload-images uses `frmNotes.GetCurrentNoteID`
- `lstNotes` is no longer present as a live control in `fNotes`.
- Remaining `lstNotes` mentions in `fNotes.pas` are now historical comments or commented-out legacy blocks, not active runtime code.
- For the next `fNotes` refactor session, read:
  - `CPRS-Chart\TMG_Extra\uTRecStrList.pas`
  - `CPRS-Chart\fNotes.pas`
  - `CPRS-Chart\uDocTree.pas`
- Recommended next step:
  1. performance review of note loading in `CPRS-Chart\fNotes.pas` and `CPRS-Chart\uDocTree.pas`
  2. review `PDocTreeObject` eager parsing/allocation and consider lazy hydration from `TORTreeNode.StringData`
  3. investigate progress-bar churn / repeated `Application.ProcessMessages` / recursive tree-build cost before making deeper model changes

### 2026-08-18 `lstNotes` Removal Milestone

- `CPRS-Chart\fNotes.dfm`
  - removed hidden `lstNotes: TORListBox`
  - adjusted `tvNotes.TabOrder`
  - removed stale status entry referencing `lstNotes`
- `CPRS-Chart\fNotes.pas`
  - removed `lstNotes` field and `lstNotesClick` handler
  - removed `SyncNoteDataToListBox`
  - removed mirror writes from:
    - `UpdateTreeView`
    - `UpdateNoteRecordAt`
    - `ClearNoteRecords`
    - `AddNoteRecord`
    - `InsertNoteRecord`
    - `SetSelectedNoteIndex`
  - added `NoteCount`
- User report after rebuild:
  - compiles OK
  - brief runtime testing looks good

### 2026-08-18 Note-Loading Performance Findings

- Slow loading of large note sets is not primarily caused by fetching the full text of every note during a normal load.
- The likely hot path is mostly client-side work in:
  - `CPRS-Chart\fNotes.pas`
  - `CPRS-Chart\uDocTree.pas`
- Major likely costs:
  - repeated `ListNotesForTree(...)` / grouping passes
  - `CreateListItemsForDocumentTree(...)`
  - `BuildDocumentTree(...)`
  - per-item progress-bar updates and `Application.ProcessMessages`
  - eager `PDocTreeObject` allocation/parsing for every node
- Important exception:
  - when `FCurrentContext.SearchString <> ''`, the code really does fetch each note's text with `TIU GET RECORD TEXT`
  - that slower path is expected only for explicit text-search mode

### 2026-08-18 Note-Tree Performance Milestone

- Final performance work completed in:
  - `VA\VAUtils.pas`
  - `CPRS-Lib\ORFn.pas`
  - `CPRS-Lib\ORCtrls.pas`
  - `CPRS-Chart\uDocTree.pas`
  - `CPRS-Chart\fNotes.pas`
  - `CPRS-Chart\fDCSumm.pas`
  - `CPRS-Chart\Consults\fConsults.pas`
- `Piece`/`Pieces` hot helpers were centralized and optimized in `VAUtils`, with compatibility wrappers preserved through `ORFn`/`ORCtrls`.
- Added optimized helper surface:
  - `PieceEquals`
  - `PieceAsIntDef`
  - `PieceAsInt64Def`
  - `ParsePiecesMax`
- Important runtime fix:
  - Delphi `[Ref]` on the public string helpers caused runtime instability in `PieceEquals`
  - this was fixed by reverting those public helper signatures back to normal `const string`
- `uDocTree` now uses span-based parsing in the hot note-tree preparation/build paths instead of repeated `Piece(...)` rescans.
- `BuildDocumentTree(...)` was structurally optimized:
  - builds a parent-to-children index once
  - then walks only actual child rows
  - avoids the old recursive full-list rescanning behavior
- Initial tree-node creation is now lazy with respect to `PDocTreeObject`:
  - nodes are created with `Data = nil`
  - `TORTreeNode.StringData` remains the source of truth
  - `DocTreeData(ANode)` in `uDocTree` materializes and attaches `PDocTreeObject` on first demand
- `SetTreeNodeImagesAndFormatting(...)` was updated so initial formatting derives from `StringData`, preserving lazy object creation during initial load.
- Direct `PDocTreeObject(...Data)^` accesses in the main tree-interaction paths were converted to `DocTreeData(...)^` in:
  - `CPRS-Chart\uDocTree.pas`
  - `CPRS-Chart\fNotes.pas`
  - `CPRS-Chart\fDCSumm.pas`
  - `CPRS-Chart\Consults\fConsults.pas`
- Progress-bar / `Application.ProcessMessages` churn was reduced substantially:
  - updates are throttled by `TREE_PROGRESS_UPDATE_INTERVAL`
  - current value is `100`
- User-reported timing result for the same patient and `"1000"` notes:
  - old CPRS: about `37 seconds`
  - intermediate new CPRS: about `20 seconds`, then about `7 seconds`
  - final new CPRS after lazy `PDocTreeObject` load: about `5 seconds`
- The user explicitly agreed this is a good stopping point for the note-tree performance work.
- Recommended next step only if future performance work resumes:
  1. add instrumentation around remaining phases
  2. measure UI costs such as custom draw / expand sorting / per-node formatting
  3. avoid further speculative parsing rewrites until measurement shows a clear next bottleneck

### Current Compile Workflow Status

- On 2026-08-18 the user saved a fresh compile log to `CPRS-Chart\build_errors.txt`.
- A compile blocker at `CPRS-Chart\fNotes.pas(5222)` was fixed.
- After that fix, the user reported the project compiles again.
- As always, treat `CPRS-Chart\build_errors.txt` as current only when the user has just saved a fresh IDE compile log.

### Important 2026-08-03 Cleanup Warning

- A broad automated pass that commented out all `H2164 Variable ... declared but never used` locals caused widespread Delphi declaration-block damage.
- Failure modes included:
  - commenting out the first declaration line in a local `var` block and accidentally removing the only live `var` keyword
  - leaving stray `var` lines with no following live declarations
  - breaking mixed declaration/type lines
- The user manually repaired this and reports the project compiles again.
- Do not repeat a broad mechanical unused-local cleanup pass across the tree.
- If this cleanup is revisited later, do it only in tiny, hand-reviewed scopes.

### RPC Broker String Concern For Future Work

- This is not today's task, but it should be considered in a future session.
- The local Delphi 12 port still produces many warnings about possible data loss when assigning Delphi `string` values into Broker parameter storage.
- This is expected because `RPCBroker.Params` / related Broker payload paths still fundamentally use single-byte storage at the wire boundary.
- The user does not want a broad encoding rewrite attempted casually.
- Future work item:
  - review Broker call sites and decide whether warning reduction is worth a larger deliberate pass
  - if touched, preserve Broker wire semantics as single-byte/ANSI unless there is a deliberate protocol change
  - prefer targeted marshaling at the Broker boundary over changing broad application text handling

Recent confirmed fixes from earlier sessions that still matter conceptually:

- The old `EmbeddedED.pas` `LoadFromString` Unicode `Char` sizing bug was fixed before the later HTML streamlining work removed that file from the tracked source tree.
- That older fix matters as history because it explains why HTML/document byte-vs-character sizing had to be handled carefully during the later merge into `TMGHTML2.pas`.
- `CPRS-Lib\ORClasses.pas`
  - `TORStringList.SortByPieces` quicksort loop now bounds-checks `I` and `J` before indexing, preventing out-of-range access during sort.
- `CPRS-Lib\ORFn.pas`
  - `MixedCase` now passes its transformed `Result` into `ConvertSpecialStrings` instead of the original input.
  - `ConvertSpecialStrings` was fixed to initialize `Result := x`; previously it could return `''` for non-empty input.
  - `CharInSet` helper now uses `TSysCharSet` / `SysUtils.CharInSet`.
  - `FastAssign` / `FastAddStrings` were under active investigation because of a runtime AV in `System.Classes.LoadFromStream`; the user subsequently rewrote these functions manually to the desired logic. Do not overwrite those user edits casually.
- `CPRS-Lib\ORCtrls.pas`
  - `TCaptionListView` republishes `AutoSize` so older DFM state can load.
- `VA\VA508Accessibility\VA508AccessibilityManager.pas`
  - `TVA508StaticText` now republishes/implements properties needed by older DFM state: `AutoSize`, `WordWrap`, `LabelAlignment`, `LabelLayout`.
- `CPRS-Chart\fFrame.pas` and `CPRS-Chart\fFrame_SidexSide.pas`
  - Added fallback for empty `FILE_VER_INTERNALNAME` by trying `FILE_VER_FILEVERSION`.
- `CPRS-Chart\TMG_Extra\rFileTransferU.pas` and `CPRS-Chart\TMG_Extra\uImages.pas`
  - Byte-oriented upload/base64 helper locals were moved back to `AnsiString`/`AnsiChar` where needed.
  - Deprecated `MidStr` trimming was replaced with `Delete(...)`.
- `CPRS-Chart\fLabs.pas`
  - The “empty image list” pattern was corrected: `uEmptyImageList` now remains `nil`, and list views use `SmallImages := uEmptyImageList` / `nil` rather than a zero-width `TImageList`.
- `CPRS-Chart\fReports.pas`
  - The old `OnBeforeNavigate2` signature mismatch was investigated. The user used the Delphi designer to regenerate the handler signature and manually repaired the event hookup. Do not revert that blindly.
- `CPRS-Chart\TMG_Extra\uHTMLTools.pas`
  - `GetIPAddress` was rewritten into a cleaner Delphi-style Winsock helper and the old code was preserved as `//kt //codex original --> ...` comments.
### Encoding / Editing Notes

- The user converted `CPRS-Chart\TMG_Extra\uHTMLTools.pas` to UTF-8 using Windows Notepad so it is easier to edit safely.
- A root script now exists: `convert_ansi_to_utf8.sh`
  - Recurses through the tree
  - Detects non-UTF-8 Delphi source files
  - Converts them from Windows-1252 to UTF-8
  - Creates `.bak` backups
- The script can introduce follow-up compile fixes in old third-party units; use it cautiously and expect Unicode/set-expression cleanup afterward.
- Delphi IDE state matters: on 2026-07-31, compile errors persisted until the user closed and reopened Delphi so the IDE reloaded the current source from disk. If compile output does not match the current file contents, suspect a stale in-memory editor buffer before assuming the source is still broken.

### User Editing Conventions

- Add `//kt //codex <date>` to modified Delphi/Pascal source lines.
- If removing Delphi/Pascal code, leave the old line behind as:
  - `//kt //codex original --> <old code>`
- The user may manually revise Codex patches after review. Read the current file contents before making follow-up edits.

Current compile state:

- CPRS currently compiles in the Delphi 12 IDE.
- Active work is now runtime/debugging cleanup after compile success.
- `CPRS-Chart\build_errors.txt` may currently contain stale historical failures from before the later HTML streamlining checkpoint. Do not treat that file as current unless the user saves a fresh compile log after reopening Delphi.
- Do not treat the older `BDK50\Rpcnet.pas` compile-failure notes below as the current blocker; they are historical context for how the tree reached the present compileable state.

Older milestone:

- A successful IDE build existed on 2026-07-09 before later runtime/debugger fixes.
- Since then, the user hit runtime startup issues and the Broker source has been unpacked and modified, so do not treat the old successful build as current.

The user then ran the compiled app and hit a startup/debugger exception:

- File: `CPRS-Chart\uEventHooks.pas`
- Location: around line 530
- Exception: `EOleSysError`
- Message: `Error accessing the OLE registry`

Patched `uEventHooks.pas` so normal startup no longer attempts to register the CPRSChart type library. `/REGSERVER` and `/UNREGSERVER` still perform explicit registration/unregistration and halt afterward. Also changed `TCPRSBroker` and `TCPRSState` to load CPRSChart's embedded type library from the running module instead of requiring the type library to already be registered. While touching this code, changed `GetModuleFileName` buffer counts from `SizeOf(Buffer)` to `Length(Buffer)` for Delphi 12 `Char` sizing.

The next run then hit:

- File: `CPRS-Lib\ORNet.pas`
- Location: `SetParams`, old line around 357
- Exception: `Unable to pass parameter type to Broker.`

The Broker source was found in `BDK50\BDK32_P50T4.zip` and `BDK50\XWB1_1P50T1.zip`. Use `BDK32_P50T4.zip` as the baseline; it is newer than T1 and includes later Broker patch 50 fixes. The T4 `Source\*.pas`, `Source\*.dfm`, and `Source\*.inc` files were extracted flat into `BDK50`, which is already on the CPRSChart search path.

Patched the local T4 Broker source in `BDK50\Trpcb.pas` so outbound parameter payload storage is single-byte:

- `TParamRecord.FValue` / `Value` is now `AnsiString`.
- `TMult` stored values and default `MultArray[...]` values are now `AnsiString`.
- Subscript keys remain normal `string`.

Patched `CPRS-Lib\ORNet.pas` so `SetParams` handles Delphi 12 text `TVarRec` cases that old Delphi did not pass for ordinary strings/chars:

- `vtWideChar`
- `vtPWideChar`
- `vtWideString`
- `vtUnicodeString`

Important: this does not mean RPC payloads should become Unicode. All `SetParams` scalar cases now pass through a local `AnsiString` helper before assigning `RPCBrokerV.Param[i].Value`. The helper preserves the existing leading `#1` convention that converts a literal into a Broker `reference` parameter. `SetList` also assigns `AnsiString(Strings[i])` into `Mult[...]`.

If the next IDE compile errors inside `BDK50` units, prefer patching the local extracted source rather than installed Delphi/package files. Continue tagging every modified Pascal source line with `//kt //codex 7/30/26`.

Additional standing instruction from the user as of 2026-07-30:

- Codex should mark Delphi/Pascal code changes inline with `//kt //codex <date>`.
- If a prior Codex patch omitted that marker, add it when revisiting the line.
- When removing Delphi/Pascal code, preserve the old line as a commented reference using `//kt //codex original --> <old code>`.

After the first compile with local Broker source, `CPRS-Chart\build_errors.txt` showed many `BDK50\wsockc.pas` errors where old Winsock code used `PChar`/`Char` assuming ANSI but Delphi 12 treats `PChar` as UTF-16. Patched `BDK50\wsockc.pas` and `BDK50\Trpcb.pas` so the Broker's raw socket buffers and low-level `NetCall`/`tCall`/`pchCall` pointer path use `PAnsiChar`, `AnsiChar`, and `AnsiString` at the Winsock/RPC wire boundary.

The next compile reached the edited `NetCall` code and showed that unqualified `StrAlloc`/`StrNew`/`StrCopy` still resolved to Unicode `SysUtils` helpers returning `PWideChar`. Patched active ANSI buffer helper calls in `BDK50\wsockc.pas` and `BDK50\Trpcb.pas` to use `AnsiStrings.StrNew`, `AnsiStrings.StrCopy`, `AnsiStrings.StrDispose`, etc.

Follow-up compile showed Delphi's `AnsiStrings` unit does not expose `StrAlloc`, and unqualified `StrLen` became ambiguous after adding `AnsiStrings`. Patched `BDK50\wsockc.pas` so temporary receive/server-packet buffers use `AllocMem` / `FreeMem`, returned RPC strings use `AnsiStrings.StrNew`, and old `cLeft`/`cRight` helpers call `AnsiStrings.StrLen`. Patched `BDK50\Trpcb.pas` so `Sec` / `App` scratch buffers use `AllocMem` / `FreeMem`.

Next compile cleared `wsockc.pas` errors and moved to `BDK50\Rpcnet.pas`. Patched `Rpcnet.pas` host/IP lookup buffers so `libGetHostIP1`, `libGetLocalIP`, and the async result record use `PAnsiChar`, with `AllocMem` / `FreeMem` for scratch buffers and `AnsiStrings.StrCopy` / `StrCat` / `StrPCopy` / `StrPas` for ANSI text. `inet_ntoa` results are copied into the existing ANSI buffer instead of assigning the static Winsock pointer. This was the last compile-blocking wave in the saved notes; the user has since reported that CPRS compiles successfully as of 2026-07-31.

## Resolved Conflict Notes

The prior `Ieconst`/`SHDocVw` conflict is resolved.

- Renamed local HTMLEdit unit:
  - from `CPRS-Chart\TMG_Extra\HTMLEdit\EmbeddedED\Ieconst.pas`
  - to `CPRS-Chart\TMG_Extra\HTMLEdit\EmbeddedED\EmbeddedIEConst.pas`
- Changed unit declaration to `unit EmbeddedIEConst;`
- Updated HTMLEdit uses/references from `Ieconst` to `EmbeddedIEConst`.
- Updated `EmbeddedED\DHMLEditor.dpk`.

If Delphi prompts to recover old files, discard recovery for stale `Ieconst.pas`. Do not delete `__recovery` folders unless the user explicitly asks.

Only if a new `Ieconst`/recovery-related error appears, inspect stale artifacts without deleting them:

```powershell
Get-ChildItem -Path . -Recurse -Force -Directory -Filter '__recovery' | Select-Object FullName,LastWriteTime
Get-ChildItem -Path . -Recurse -Force -Include 'Ieconst*','IEConst*' | Select-Object FullName,Length,LastWriteTime
```

The missing `uHTMLDlgParse.pas` project-reference problem is also resolved:

- No active source uses `uHTMLDlgParse`.
- Removed stale `uHTMLDlgParse` references from `CPRS-Chart\CPRSChart.dpr` and `CPRS-Chart\CPRSChart.dproj`.
- User confirmed the found backup was an empty unit.

## Major Changes Made

### Build Script

Added:

- `build-cprschart.cmd`

Purpose: try command-line build via Delphi tools and detect the Community Edition command-line compiler limitation.

### Project File Cleanup

Updated:

- `CPRS-Chart\CPRSChart.dproj`
- `CPRS-Chart\CPRSChart.dpr`

Key points:

- Removed explicit local `XuDigSig\Wcrypt2.pas` reference.
- Adjusted paths so package resource path can win where needed.
- Removed stale `TMG_Extra\uHTMLDlgParse.pas` references.

### Delphi 12 / Unicode Compatibility Fixes

Updated:

- `CPRS-Lib\ORFn.pas`
  - Reworked old `#128..#159` char range checks using `Ord(...)` to avoid `Low bound exceeds high bound`.

- `CPRS-Lib\ORSystem.pas`
  - Qualified `Windows` calls as `Winapi.Windows`.

- `CPRS-Lib\ORNet.pas`
  - Fixed Winsock local host buffer handling with `AnsiChar`.
  - This was only a Winsock buffer fix, not an RPC payload encoding change.
  - `SetParams` now accepts Delphi 12 text `TVarRec` cases: `vtWideChar`, `vtPWideChar`, `vtWideString`, and `vtUnicodeString`.
  - All scalar values now pass through a local `AnsiString` helper before assigning Broker parameter values; do not change Broker/RPC wire data to Unicode semantics.
  - `SetList` now assigns `AnsiString(Strings[i])` into Broker `Mult[...]` values.
  - New `SetParams` lines are tagged with `//kt //codex 7/24/26`.

- `BDK50\Trpcb.pas`
  - Extracted from `BDK50\BDK32_P50T4.zip`.
  - `TParamRecord.Value` and `TMult` value storage changed from Delphi `string` to `AnsiString`.
  - This is intentional because the Broker/MUMPS boundary is single-byte.
  - `pchCall` now returns `PAnsiChar`, and raw result buffers are handled as ANSI before converting back to Delphi `string` for public `strCall`/`lstCall` results.
  - Active low-level ANSI pointer allocation/free/copy calls are qualified through `AnsiStrings`.

- `BDK50\wsockc.pas`
  - Extracted from `BDK50\BDK32_P50T4.zip`.
  - `NetCall` / `tCall` and socket send/receive buffers now use `PAnsiChar`.
  - Hostname buffers, linger option byte overlays, `inet_addr`, `gethostbyname`, and server packet reads were updated to use ANSI pointers/buffers.
  - Active low-level ANSI pointer allocation/free/copy calls are qualified through `AnsiStrings`.
  - This follows the original Broker assumption that the wire protocol is single-byte data, not Unicode.

- `BDK50\Rpcnet.pas`
  - Extracted from `BDK50\BDK32_P50T4.zip`.
  - Host/IP lookup helper buffers changed to `PAnsiChar` where they call Winsock APIs.
  - Scratch buffers use `AllocMem` / `FreeMem`; ANSI text copies use `AnsiStrings`.

- `CPRS-Lib\ORDtTm.pas`
  - Uses `FormatSettings.LongMonthNames` / `FormatSettings.ShortMonthNames`.
  - `TORDateCombo.YearUDChange` uses `NewValue: Integer` to match the Delphi 12 `TUpDown.OnChangingEx` signature.

- `CPRS-Chart\uReports.pas`
  - Uses `FormatSettings.ThousandSeparator` and `FormatSettings.DecimalSeparator` in `IsValidNumber`.

- `CPRS-Chart\Encounter\fPCELex.pas`
  - Uses local `decimalSep: Char` initialized from `FormatSettings.DecimalSeparator`.

- `CPRS-Chart\TMG_Extra\AnticoagMgmtTool\fAnticoagulator.pas`
  - Replaced remaining active old global `DecimalSeparator` usage.

- `CPRS-Chart\TMG_Extra\AnticoagMgmtTool\uTMGMods.pas`
  - Uses `FormatSettings.LongDayNames[...]`.

- `CPRS-Chart\TMG_Extra\HTMLEdit\EWBTools.pas`
  - Replaced remaining active old global `DecimalSeparator` usage.

- `VA\VA508Accessibility\VA508Classes.pas`
  - Changed token compare from `EQUALS` to `'='`.

- `CPRS-Chart\fBase508Form.pas`
  - Updated `OnHelp` handler signatures from old `Integer` data parameter to `THelpEventData`.

### WebBrowser Event Signature Fixes

Updated `OnBeforeNavigate2` handler signatures to match newer Delphi `SHDocVw` signatures using `const` parameters:

- `CPRS-Chart\fFrame.pas`
- `CPRS-Chart\fNotes.pas`
- `CPRS-Chart\fReports.pas`
- `CPRS-Chart\Orders\fOMHTML.pas`
- `CPRS-Chart\TMG_Extra\fDashboard.pas`
- `CPRS-Chart\TMG_Extra\fNoteTOC.pas`
- `CPRS-Chart\TMG_Extra\fPopHealth.pas`

This addressed IDE popups such as incompatible `OnBeforeNavigate2` parameter lists.

### Package Source Alignment

Updated local copies from installed package sources:

- `CPRS-Chart\XuDigSig\Wcrypt2.pas`
  - Replaced with package version from `D:\Embarcadero\packages\VA\Source\wcrypt2.pas`.
  - Old local copy saved as `Wcrypt2_legacy.pas`.

- `CPRS-Chart\VERGENCECONTEXTORLib_TLB.pas`
  - Replaced with package version from `D:\Embarcadero\packages\Broker\Source\VERGENCECONTEXTORLib_TLB.pas`.
  - Old local copy saved as `VERGENCECONTEXTORLib_TLB_legacy.pas`.

### HTMLEdit / Embedded Editor Fixes

- `CPRS-Chart\TMG_Extra\HTMLEdit\EmbeddedED\KS_procs.pas`
  - Added local compatibility variables for old global date/time settings.
  - Initialized them from `FormatSettings` where applicable.
  - Replaced deprecated/incompatible `AppendStr(Result, Search[Index])` with `Result := Result + Search[Index]`.
  - Replaced ambiguous `StrPas(@res)` with `string(PChar(@res[1]))`.

- `CPRS-Chart\TMG_Extra\HTMLEdit\EmbeddedED\KS_Lib.pas`
  - Cast `HTMLElement.OuterHTML` to `string` in the doctype check:
    - `Pos('<!DOCTYPE', string(HTMLElement.OuterHTML))`

- `CPRS-Chart\TMG_Extra\HTMLEdit\EmbeddedED\EmbeddedED.pas`
  - In `TEmbeddedED.EDMessageHandler`, bridged newer message types to the old exact `LongWord/SYSINT` var parameter types expected by `FMessageHandler`.

- `CPRS-Chart\TMG_Extra\uHTMLTools.pas`
  - Patched nested `GetBetween` to use local `ResultPart: AnsiString` for `CutInThree` calls, then assign back to `Result`.
  - This file is ANSI encoded; prior patch used a narrow PowerShell text edit.

- `CPRS-Chart\TMG_Extra\HTMLEdit\TMGHTML2.pas`
  - Patched ambiguous `Pos` calls against `IHTMLTxtRange.htmlText` by casting search literals to `WideString`.
  - Patched `THtmlObj.InsertHTMLAtCaret` so `SanitizeHTML(var string)` receives a local `SanitizedHTML: string` instead of the `AnsiString` parameter, then passes sanitized text to `Range.pasteHTML`.

### Byte/String-Sensitive Fixes

- `CPRS-Chart\TMG_Extra\rFileTransferU.pas`
  - Explicitly uses `AnsiChar` when converting file bytes into the base64 input string and when reading base64 input chars.
  - Intentional because file-transfer/RPC payload handling is byte-oriented and must remain single-byte.

- `CPRS-Chart\TMG_Extra\fUploadImages.pas`
  - `TfrmImageUpload.CopyFileToTemp` local path pointers changed from `PAnsiChar` to `PChar`.
  - This is a Windows filesystem API path call, not RPC byte-payload handling.

- `CPRS-Chart\TMG_Extra\fImagePatientPhotoID.pas`
  - `SplitLinuxFilePath` is declared in `uImages.pas` with `AnsiString` var parameters.
  - Patched local `FPath/FName` variables in `EnsureDownloaded` and `ParseOneRec` from `string` to `AnsiString`.

- `CPRS-Chart\TMG_Extra\uImages.pas`
  - `TImageInfo.AbsType` / `Accessibility` assignments cast `AnsiString` indexed chars to `Char`.
  - Barcode upload byte-buffer conversion changed from `char(Buffer[j-1])` to `AnsiChar(Buffer[j-1])` to preserve byte-oriented RPC payload construction.

- `CPRS-Chart\XuDigSig\XuDsigS.pas`
  - Compares `HCERTSTORE` handles with `nil`.
  - Compares `CertGetNameString` results with `<> 0`.
  - Passes the CRL OID as `PAnsiChar(AnsiString(...))`.
  - Keeps `SCardListReadersA` / `SCardConnectA` buffers as `AnsiString` / `PAnsiChar`.

### Other Compile Blockers Fixed

- `CPRS-Chart\TMG_Extra\png_Graphics\pngimage.pas`
  - Old left-side byte casts converted from `Byte(Dest^) := ...` style to assignable pointer form `pByte(Dest)^ := ...`.

- `CPRS-Chart\fGraphs.pas`
  - Old `Legend.Clicked` call replaced with `ClickedLegend := -1` after Delphi 12 TeeChart compatibility issue.

- `Show508Message` unresolved-call blockers
  - Replaced executable call sites with `ShowMsg` in:
    - `CPRS-Chart\BA\fBALocalDiagnoses.pas`
    - `CPRS-Chart\BA\UBACore.pas`
    - `CPRS-Chart\fReview.pas`
    - `CPRS-Chart\Orders\fOrdersSign.pas`
    - `CPRS-Chart\uSignItems.pas`
    - `CPRS-Chart\fFrame.pas`
    - `CPRS-Chart\Encounter\fSkinTest.pas`
  - Added `VAUtils` where needed.
  - Remaining `Show508Message` text found in the active project should be comments, backup `.pas` variants, or type names such as `TShow508MessageIcon` in `VAUtils`/`uSpell`.

- `CPRS-Chart\Templates\uTemplates.pas`
  - Delphi 12 `WordXP.pas` no longer exposes Word's `Range` interface as bare `Range`; it is renamed to `WordRange`.
  - Patched local variables `ffRange, textRange: Range` to `WordRange`.

- `CPRS-Chart\uEventHooks.pas`
  - Normal startup no longer performs type-library registration, avoiding `EOleSysError: Error accessing the OLE registry` on `RegisterTypeLib`.
  - `/REGSERVER` and `/UNREGSERVER` still do explicit type-library registration/unregistration.
  - `TCPRSBroker` and `TCPRSState` now load the embedded CPRSChart type library from the running EXE rather than using `LoadRegTypeLib`.
  - `GetModuleFileName` buffer counts now use `Length(Buffer)` instead of `SizeOf(Buffer)`.

## Useful Notes

- `F:\Shares\Public\vista\TMGCPRS_v30A_Delphi12` in Delphi logs is the same project as `P:\vista\TMGCPRS_v30A_Delphi12` here.
- Warnings about `WideChar reduced to byte char` are common in this old codebase. Focus first on fatal/errors.
- The warning `W1030 Invalid compiler directive: 'true'` comes from the generated dcc32 command line (`-$J+ true`) and has not been addressed because it is not currently blocking compilation.
- Current saved log is from before the latest `BDK50\Rpcnet.pas` patch. It still shows `Rpcnet.pas` errors at lines 108, 134, 216, 232, and 339; those lines have since been patched and require a fresh IDE compile to verify.
