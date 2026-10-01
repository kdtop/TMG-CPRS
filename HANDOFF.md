# CPRSChart Delphi Build Handoff

Last updated: 2026-10-01
Workspace: `P:\vista\TMGCPRS_v30A_Delphi12`
Project: `CPRS-Chart\CPRSChart.dproj`

<!-- Put dated status updates and session history in changelog.md, not HANDOFF.md. -->
Status updates and historical milestones belong in [changelog.md](changelog.md). Keep this handoff focused on current context, standing instructions, and next steps.

## Environment

- Delphi 12 compilation must be run from inside the Windows Server session where Delphi is installed and licensed.
- The source tree is in the `vista` directory as `TMGCPRS_v30A_Delphi12`.
- In the Windows Server/Delphi session, the project is normally opened from `P:\vista\TMGCPRS_v30A_Delphi12`.
- From this Codex/Linux workspace, the same tree is mounted at `/mnt/WinPublic/vista/TMGCPRS_v30A_Delphi12`.
- Delphi logs may also refer to `F:\Shares\Public\vista\TMGCPRS_v30A_Delphi12`; treat that as the same source tree unless the user says otherwise.

## Current Focus

- The topic post-signature pipeline and historic rebuild are complete. `PARSESCT2^TMGTIUP1` records table associations below each parsed thread; `FILE1B^TMGTIUT5` reconciles those links and supports `OPTION("REMOVE OLD")=1`; and the provider-aware `EXTRACTHREAD^TMGTIUP2` retains only text belonging to the current visit while preserving `EXTRACTHREAD0` as fallback. `TMGTOPIC` has resumable `REBUILD1PT`/`TEST1REBUILD`/`REBUILDALL`; the all-patient rebuild was run to completion successfully. The rebuild marker is `^TMG("TMP","REBUILDALL^TMGTOPIC",DFN)`. `REBUILDALL` derives progress maximum from `^DPT("@")`, not the `^DPT` root, and deliberately has no `USRABORT` handling. For malformed note markup, `PROCESS^TMGHTM2` escapes raw `<--` only when its existing HTML detection passes, while `parseElement^TMGEWD02` exits safely on an unterminated tag.
- The Topics tab foundation is complete and compiled successfully in the Delphi 12 IDE. `CT_TOPICS` is registered in the project/frame, can be placed on either tab side, and owns `TfrmTopics`.
- `TfrmTopics.RefreshTopicList` calls `rTopics.TopicList` after patient selection. It displays a report-style `TCaptionListView` with Topic, Last Used, User Data, and Hidden columns; each item retains its topic sub-IEN/property ID in its data object.
- Topics data is cleared in `TfrmFrame.ClearPatient` and refreshed after `ProcessPatientChangeEventHook` in `SetupPatient`. Do not move this RPC call into form creation, where no patient is selected.
- Topics list behavior uses `TopicListItemAt`, backed by `LVM_SUBITEMHITTEST`, rather than `TCaptionListView.GetItemAt`, which only recognizes column zero. Topic-column clicks select/load; User Data opens its editor; Hidden toggles the live model. The `lvTopicsWindowProc` fallback selection/load path also covers Last Used clicks and is considered complete.
- `TTopicChanges` (in `rTopics.pas`) is an owning typed dictionary keyed by topic property ID. Its `TTopicChange` objects coalesce independent topic-level Hidden/User Data changes and owning dated-entry changes keyed by raw FileMan date. `timSaveTopicChanges` waits two seconds after the latest model update before calling `rTopics.SaveTopicChanges`.
- `rTopics.SaveTopicChanges` now serializes a batch for the `SET TOPIC MULTI` RPC. Each submitted row begins with `IEN=<topic-sub-IEN>` and can carry topic-level `HIDDEN`/`USER DATA` changes or dated-entry `FMDT`, `HIDDEN`, and `USER DATA` changes. A successful RPC result clears the queue; a failure leaves it queued for retry.
- The center topic HTML displays a Hide/Show link on every dated-entry header. It uses the dated entry's raw FileMan date as the local link ID; toggling hides text as `(Hidden...)`, updates the local model, and queues the appropriate dated-entry RPC change. This is intentionally IE/TWebBrowser-compatible HTML without HTML5 or JavaScript.
- 2026-09-25 Topics entry deletion/editing work is complete. `DEL TOPIC`, `DEL 1 TOPIC ENTRY`, and `SET 1 TOPIC ENTRY TEXT` exist in `/opt/worldvista/EHR/p/TMGTOPIC.m`; `rTopics` wraps these RPCs. `fTopics` has Delete/Edit entry links, Delete Topic, editor Save/Cancel, a fixed center-page header, entry/title state handling, even action-link spacing, and topic-level Hidden-display suppression. `fTopics` is intentionally untagged; preserve its explicit-block formatting.
- **Topic Edit correction complete:** `GET1` normalizes Word-Processing text on CRLF, LFCR, or bare CR before adding it to `OUT()`, prefixing every resulting line—including blank lines—with `2^`. This prevents Broker-split continuation fragments from truncating `EditCurrentTopicEntry`; the edit/reload and save path is considered working.
- `rTopics.Set1TopicEntryText` uses `SplitHTMLToArray(Text.Text, WrappedText)` without `WrapHTML`, because `GetWebBrowserHTML` returns a body fragment and wrapping it had stored a visible `<!DOCTYPE ...>` prefix. Before the save RPC, it explicitly splits embedded CRLF/LFCR/CR/LF characters into individual payload items and verifies that no item still contains a line break. Existing affected entries can be repaired by a successful Edit/Save after the edit-loading issue is fixed.
- `lvTopics` supports multi-key sorting. A normal header click makes that column the sole primary key (and reverses it on repeat); Ctrl+click adds a key or reverses an existing one. Captions display priority/direction (for example `1▲ Hidden`, `2▼ Last Used`) and every participating column receives the cream sort highlight. To show visible topics first and newest-used first within each group, click Hidden, Ctrl+click Last Used, then Ctrl+click Last Used again.
- Topics list preferences persist through `uTMGOptions`: Show Hidden, all ListView column widths, and ordered sort keys. `cbShowHidden` controls visibility of the Hidden column and of hidden records. The ListView supports multi-selection, User Data editing, a 200 ms debounced AND filter over space-delimited User Data words, and right-click Hide actions when hidden records are not shown. A Hidden-cell click applies its target state to all selected rows.
- `fTopics.pas` now has an untagged compact explicit-block formatting pass. Preserve its style: every `if`, `else`, `for ... do`, and `while ... do` has a `begin`/`end`, and alternatives use `end else begin` on one line.
- The client multi-select merge workflow is complete. When more than one ListView row is selected, the context menu exposes Merge Topics even when Show Hidden is checked. The dialog chooses one destination and sends all other selected topic sub-IENs to rTopics.MergeTopics; one source uses the two-string overload and multiple sources use the TStringList overload. It saves any pending topic changes before merging, then refreshes the list on success. The public multi-source overload declaration in rTopics.pas matches its implementation: MergeTopics(SrcSubIENs: TStringList; DestSubIEN: string).
- Server-side topic merging is complete in /opt/worldvista/EHR/p/TMGTOPIC.m. MERGE2TOPICS uses FileMan to create a distinct destination dated entry for every source entry, including matching FMDTs, then copies its WP text; it merges User Data, makes the destination visible, and deletes the source only after success. The user reported the server merge worked at runtime. The Linux M routine uses LF line endings.
- GET1 now iterates the DATETIME "B" index, returning topic entries in FMDT order after merges. Same-FMDT entries remain separate and are emitted by subentry IEN order.
- Topic rename is complete. Server-side RENAME:<topic-sub-IEN>^<new-name> files 22719.21,.01 through FileMan. rTopics.RenameTopic wraps the RPC. fTopics.pas exposes Rename topic for exactly one selected row; right-clicking an unselected row selects it first. The client validates nonempty, no-^, <=180-character names, updates its retained model/current heading, and re-sorts after success.
- Related data in the right Topics column is client-backed by `FTopicDataTables` and is now persisted per topic. `LIST TABLES` returns `<table name>^<IEN22708>`; the picker retains the IEN to call `rTopics.SetTopicLinkedTables`, while `GET TABLES AS DATA` intentionally still receives the table name (for example, `CHF`). File `22719.212` stores the pointer association. `GET1` returns it as `0.5^<IEN22708>;<table name>` records; `fTopics` supports individual or packed records, reloads all table names through the existing table-data RPC after selecting a topic, and renders them in the right column. The user runtime-confirmed add, persistence, reload, and deletion. Each persisted table has a right-aligned Delete link that confirms removal, sends `@<IEN22708>` through `SetTopicLinkedTables`, removes the model entry after success, and rerenders the column.
- Topics participates in `TfrmFrame.AllowContextChangeAll`. `TfrmTopics.AllowContextChange` prompts to discard an active Topic-entry edit before a patient/context change; declining blocks the change. `ClearPatient` already invokes `TfrmTopics.ClearPtData` (guarded for optional creation) to clear all patient-specific Topics state. The user runtime-tested this successfully.
- `TMG_Extra\fTopicTablePicker.pas` / `.dfm` is a separate VCL form (not a runtime-created `TForm` subclass), because the original dynamic picker failed at runtime with `Resource TfrmTopicTablePicker not found`. It is registered in both `CPRSChart.dpr` and `.dproj`. The user compiled and successfully used the picker. It focuses the filter on open; the filter performs a case-insensitive AND match for space/tab-delimited terms, so `a fib` finds `ATRIAL FIBRILLATION`. Tables containing `INLINE` are intentionally excluded. Re-selecting an already displayed table refreshes its data rather than adding a duplicate.
- Right-column data renders as compact HTML tables with a blue header, raw line HTML inserted into cells, no horizontal row rules, and single-spaced-like line height/padding. The user removed `pnlRightHeader` and its label from `fTopics.dfm`; matching stale code references were removed.
- The persisted-table flow was runtime-tested using CHF. The picker still excludes `INLINE` titles and enables OK when a list row is clicked; retain these behaviors while working on the deferred deletion UI.
- Continue later with remaining topic-entry document navigation and topic-related data in the right column. Preserve the completed left-column hover/splitter behavior while extending it.
- Deferred Topics UI issue: `TMG_Extra\fTopics.dfm` has a 32x32 `ImageList1` populated from PNGs. Its serialized pixels retain real alpha, but the active left/right handle and left-pin controls paint transparent pixels black at runtime. This persisted after compiling and testing both `TBitBtn` and the current `TButton` image-list renderers, and after trying `DrawingStyle = dsTransparent`; do not claim the PNG transparency is fixed. The original-style hidden fallback controls remain `btnTopicsLeftHandleLegacy` and `btnTopicsRightHandleLegacy` (`TBitBtn`). When resuming, consider a `TVirtualImageList`/`TImageCollection` or custom alpha-aware button renderer; first inspect the current `.pas`/`.dfm` pair and preserve the user's loaded images. Do not change an existing image list's color depth after it is populated, because Delphi clears its contents.
- Delphi 12 CPRS under Wine has an unresolved Patient Selection modal-close failure. Read the 2026-09-10 entry in `changelog.md` before editing or repeating diagnostics.
- The standalone `TMG_Extra\killlater` Delphi 12 modal test works under the same Wine prefix. Do not frame this as a general Delphi 12/Wine `ShowModal` incompatibility.
- The Windows Delphi remote-debugger experiment reaches Wine's server but hangs after the remote connection is accepted. Do not rely on it for the next debugging step; use local instrumentation and X11 inspection, or real Windows/VM source debugging.
- Keep CPRSChart working under Delphi 12. Read live `fNotes` source before editing; the user frequently reformats and revises it.
- `FNoteData: TRecStrList` is the live note-list model; the hidden `lstNotes` control has been removed. Use the existing model helpers.
- `LoadNotes` accepts a preferred IEN and optional activation. Preserve IEN-based restoration and avoid intermediate document activation when resuming editing.
- `FindPieceNode` searches after `AfterNode`, exclusively; pass `nil` for the whole tree. Reminder iteration depends on the exclusive behavior. The search is not limited to descendants.
- Reminder PCE saves can request foreground completion. `TPCEData.Save` must forward `ForceForegroundSave` to `SavePCEData`; this keeps health factors visible in the Encounter dialog before signature.
- Note-tree performance work reached an accepted stopping point. Measure remaining bottlenecks before further speculative optimization.
- Reports imaging has mixed RAD/TIU rows and TIU document rendering support. Multi-select HTML aggregation remains unfinished; consult the changelog and current source before resuming that work.
- Reports browser zoom is complete and runtime-confirmed. `WebBrowser1` is a child of `pnlWebHolder`; `SetDisplayToHTMLvsText` must show/hide and raise the holder, rather than the browser, so `pnlWebTop` remains visible. Its buttons use the IE optical-zoom `ExecWB` command with 20% increments and a 100% reset.
- Optional tabs may not be created. Preserve guards around tab-form references and missing page IDs.

## Build and Verification

- Compilation must run in the licensed Windows Delphi IDE. The installed edition reports: `This version of the product does not support command line compiling.`
- For a new compile failure, the user saves fresh IDE output to `CPRS-Chart\build_errors.txt`; inspect it and fix the reported blockers incrementally. Do not treat an older log as an active failure.
- If compiler output disagrees with disk contents, suspect stale Delphi editor buffers and have the IDE reload them.
- User confirmed the note-selection/reload and pre-signature health-factor fixes work at runtime. A fresh Delphi build result for the health-factor change has not been recorded.
- The `LVM_SUBITEMHITTEST` compile error was corrected (`ListView_SubItemHitTest(..., @HitTest)`). The user confirmed Hidden-cell toggling, dated-entry Hide/Show saving, and multi-key sorting at runtime. No fresh compiler output was retained in the workspace.
- The 2026-09-23 client merge workflow, 2026-09-24 GET1 chronological ordering and rename UI/RPC code, and related client Topics refinements are considered complete based on the user's report that Topics is working well.
- The URL `%5E` normalization for IE link callbacks, hiding topic-level `Hidden: Y`, direct Last Used fallback selection, the doctype-save correction, and the 2026-09-27 client save-line guard are considered complete based on the user's report that Topics is working well.
- On 2026-09-29, the user compiled the updated `TMGTOPIC` routine and rebuilt/tested CPRS. Persisted Topics related-data tables reload correctly after changing topics, and the active Topic-entry patient-change discard prompt works at runtime.

## Important Constraints

- Do not edit files under `D:\Embarcadero\...`. Those paths are installed Delphi/package sources and should only be read for comparison or copied from intentionally.
- Keep edits in this workspace: `P:\vista\TMGCPRS_v30A_Delphi12`.
- The active topic server routine is /opt/worldvista/EHR/p/TMGTOPIC.m. Edit it only when the user explicitly requests server work; keep it LF-terminated because it is a Linux M source file.
- Native VistA M routines under `/opt/worldvista/EHR/r/` are read-only: they may be inspected for behavior and RPC contracts, but must not be modified. The user may explicitly authorize an edit there under special circumstances.
- The RPCBroker talks to a server expecting single-byte character strings. Be careful around Broker/RPC payload paths; do not casually convert wire data to Unicode/multibyte behavior.
- Windows filesystem/API path fixes may use `string`/`PChar`; byte-oriented RPC/file-transfer payloads should stay `AnsiString`/`AnsiChar` unless deliberately changed.
- Leave Delphi `__recovery` folders alone and ignore them unless the user explicitly asks to clean them.
- Many Delphi source files are ANSI encoded. `apply_patch` may fail on them with invalid UTF-8; use encoding-preserving PowerShell edits only when necessary.
- The git tree was intentionally baselined locally on 2026-07-24. In this Linux-mounted workspace, plain `git ...` may fail with a dubious ownership error. Prefer `git -c safe.directory=/mnt/WinPublic/vista/TMGCPRS_v30A_Delphi12 ...` for status/log commands. Do not assume the tree is clean; the user may have several days of local changes that are not yet committed.
- For future Delphi/Pascal source edits, append `//kt //codex <date>` at the end of every modified source line, e.g. `//kt //codex 7/30/26`.
- If adding an entirely new Delphi/Pascal function or procedure, do not tag every line inside it. Instead, put `//kt //codex added entire function <date>` or `//kt //codex added entire procedure <date>` on the line immediately below the declaration.
- For future Delphi/Pascal source edits, when removing a line, leave the old line in place as a comment using this pattern: `//kt //codex original --> <old code>`.
- Use compact explicit-block Pascal formatting for all control flow. Every `if`, `else`, `for ... do`, and `while ... do` body must have `begin`/`end`, including a one-statement body. Put the opening keyword on the control-flow line, such as `if Condition then begin` and `for Index := 0 to Count - 1 do begin`. Write alternatives as `end else begin`, with all three keywords on the same line.

## Git Workflow

This is a copied Delphi 12 porting tree. Git is used for local checkpoints; the production/source tree exists elsewhere. Do not assume commits have been pushed.

Latest source checkpoint: the 2026-09-22 Topics batch-save, dated-entry Hide/Show, and multi-key-sort snapshot. Check live Git status and log rather than assuming the tree is clean. Earlier checkpoints and dated status are in [changelog.md](changelog.md).

Important Git workflow:

1. Before a new work session, run `git -c safe.directory=/mnt/WinPublic/vista/TMGCPRS_v30A_Delphi12 status --short`.
2. Review the current modified/untracked files before assuming anything is accidental.
3. Commit intentional source/checkpoint changes locally with `git add ...` and `git commit -m "..."` when the user wants a new checkpoint.
4. Expect normal future edits to show as `M`/modified until they are committed; do not assume a dirty tree means a bad state.
5. Do not use `git reset --hard` or revert broad generated-file changes unless the user explicitly asks.
6. Do not assume commits have been pushed; local commits remain local until `git push`.

## Editing and Compatibility Notes

- Preserve existing file encodings and byte-oriented Broker/image-transfer behavior. Avoid broad Unicode or encoding rewrites.
- `convert_ansi_to_utf8.sh` converts Windows-1252 Delphi source to UTF-8 and creates `.bak` backups. Use cautiously; conversion can expose character-set compatibility issues.
- Never repeat the broad automated unused-local cleanup that damaged Pascal declaration blocks. Work in small, manually reviewed scopes.
- Preserve the user's manual `FastAssign`/`FastAddStrings` rewrites and designer-generated event signatures; read current code before changing them.
- Do not reintroduce Delphi `[Ref]` on public string helpers casually; it previously caused runtime instability.
- `THtmlObj` now descends from `TWebBrowser`; the active EmbeddedED implementation has been removed. Historical references do not establish a current dependency.
- Prefer `then begin` on one line in `fNotes.pas`. The user's tag-removal exception applied only to the completed formatting pass; normal change-marker conventions remain in effect.
- `TMG_Extra\fTopics.pas` is also a user-designated clean, untagged source file. Do not reintroduce `//kt`/`//codex` markers there unless the user specifically requests them.
- If an earlier Codex change lacks its marker, add it when revisiting that line.

## Next Session Start

1. Read the current source and inspect Git status before editing.
2. If continuing Topics related-data work, the persisted related-data save/reload/delete loop is complete: associations use file 22708 IENs for `SET TOPIC LINKED TABLES`, while data retrieval remains name-based. Reload current `fTopics.pas`/`.dfm`, `fTopicTablePicker.pas`/`.dfm`, and `rTopics.pas` from disk in the IDE before compiling further work. GET1/Edit, merge, and rename are complete; do not trigger TopicList before a patient exists.
   - If the user resumes the deferred PNG issue, read the `Deferred Topics UI issue` note above before changing `ImageList1` or the active handle classes.
3. For the Wine patient-selection issue, first reproduce the post-OK state and capture `xwininfo -root -tree`, `xprop -root _NET_ACTIVE_WINDOW`, and detailed `xprop`/`xwininfo` data for Patient Selection, visible CPRS main, and the hidden `CPRS - Patient Chart` group-leader window.
4. Use the existing `uDebugTools` selector log to determine whether `ModalResult` remains nonzero and whether `FormClose`/`FormHide` actually fire. Do not infer those Delphi states from X11 alone.
5. Follow the user's current request; use [changelog.md](changelog.md) for relevant history rather than treating old next-step recommendations as active tasks.
6. If testing `ReloadNotes`, check return to editing after template insertion, the no-active-edit refresh, and a note absent from the current view.
7. For runtime/designer problems, inspect the active unit/DFM pair. For compile problems, use fresh IDE output.
8. For further HTML-stack cleanup, read the current files and the orientation documents below before removing dependencies.

## HTMLEdit Streamlining Idea

The HTMLEdit area is now a smaller post-cut stack centered on a local wrapper plus a few supporting units:

- Main local wrapper: `CPRS-Chart\TMG_Extra\HTMLEdit\TMGHTML2.pas`
- `THtmlObj` is currently declared as `class(TWebBrowser)`.
- The merged `//kt //codex From EmbeddedED` section inside `TMGHTML2.pas` is the main place where inherited `EmbeddedED` behavior was inlined.
- Supporting current units include `MSHTMLEvents.pas`, `uHTMLDlgObjs.pas`, and `uHTMLTemplateFields.pas`.
- The best orientation docs for this area are `docs\EMBEDDEDED_CUT_PLAN.md` and `docs\EMBEDDEDED_DEPENDENCY_MAP.md`.

CPRS still mostly depends on `THtmlObj` as an abstraction. Common call sites use:

- creation: `THtmlObj.Create(...)`
- text/html load/save: `Text`, `Clear`
- edit state: `KeyStruck`
- selection/caret: `SelText`, `InsertHTMLAtCaret`, `MoveCaretToPos`
- simple formatting/edit commands: `ToggleBold`, `ToggleItalic`, colors, paste, send keys
- DOM helpers: `GetElementById`, class/tag searches, style/script helpers

Possible next-phase strategy:

1. Keep the public `THtmlObj` API stable.
2. Treat `TMGHTML2.pas` as the primary implementation surface and avoid resurrecting deleted `EmbeddedED` units unless a fresh compile/runtime failure proves something was cut incorrectly.
3. Use `docs\EMBEDDEDED_CUT_PLAN.md` and `docs\EMBEDDEDED_DEPENDENCY_MAP.md` before making further large removals.
4. Migrate or simplify remaining helpers gradually while preserving `THtmlObj` method names.
