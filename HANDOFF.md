# CPRSChart Delphi Build Handoff

Last updated: 2026-11-01
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
- For authorized YottaDB/FileMan direct-mode work, use the user's approved FileMan context IEN: `DUZ=168`.
- Use the executable project-root wrapper `./codex_direct_ydb` for authorized direct-mode YottaDB work; it establishes the VistA environment and accepts quoted M commands. Do not use `runAV` for this work.
- `TMGAI001` is the user-maintained direct-mode interface. Its compiled entry points include `DUMPREC`, `LIST`, `DDFLDS`, and `ZWR`; the `fileman` skill documents their read-only use. `DDFLDS` accepts a FileMan file number or name and emits the VPE-style field layout. `ZWR` displays a requested raw global node/subtree; confirm before a top-level global because output can be extensive.

## Current Focus

- Current curated Topic display and related-table ergonomics are complete and
  user runtime-tested.  `rTopics.GetCuratedTopic` obtains the cached composite
  text for `fTopics.wbShowCurated`; the pane state persists under
  `frmTopics.CenterMiddleOpen`.  The right-browser linked tables use separate
  horizontal-scroll containers, no per-table vertical scrollbar, a bottom
  spacer row, and inline left-aligned Edit/Remove links.  Preserve this IE
  compatible HTML structure when revisiting `BuildTopicDataHTML`.
- Topic metadata migration is in progress. `PARSESCT2^TMGTIUP1` emits `TOPIC META` for every parsed topic, including a group list and all table names; `FILE1B^TMGTIUT5` synchronizes groups without creating a thread entry when there is no current-visit text.  Curated-cache acceptance separately controls ASSOCIATED TABLES synchronization, so an older note cannot replace a newer curated source's table links. `GROUP=A,B,...` replaces only the existing `GROUP=` token in topic User Data; other space-delimited tokens remain intact. `FIXALL2^TMGTOPIC` invokes metadata-only `FIXALL`, which resumes from `^TMG("TMP","FIXALL^TMGTOPIC",DFN)`.
- Dr. Dee thread parsing repair is complete and spot-checked after rebuilding all notes whose provider is Dr. Dee (`PROVIEN=83`). `HASPREDT^TMGTIUP3` now handles topic names longer than 30 characters by seeking the truncated FileMan B-index key and confirming the full name in the topic `.01` field. This lets `EXTRACTHREAD` reject a Dee carried-forward paragraph with no current-note date rather than filing it as a thread. Preserve Kevin (`PROVIEN=168`) behavior: an undated paragraph remains valid for a genuinely new topic.
- `FIXALL2` is running correctly but is not yet complete. It is safe to resume because `FIXALL` skips patients already recorded in its resume store. Preserve the user's correction for child-only `QUIET(TIUIEN)` entries: test `$DATA(QUIET(TIUIEN))`, then display it with `ZWR QUIET(TIUIEN,*)` rather than reading a possibly undefined scalar value. Recompile changed M routines before resuming because YottaDB executes their `.o` objects.
- Current Topics table work: `SET TABLE DATA` persists an independently edited table in file 22729 (using `.05` DATE WITHOUT DOCUMENT); `GETLASTTEXT^TMGTIUO5` can return that cache when there is no linked TIU document. The user compiled both changed M routines and runtime-confirmed that an edited table remains present after restarting CPRS. The FileMan `E`-flag rule for pointer values (leading backtick) is essential here.
- Topics push/carry-forward remains only partially wired. `fTopics` tracks pending new FMDT topic entries and edited tables, and labels its action **Push to New Note** without an edited note or **Sync to Current Note** with one. The new-note branch currently carries only the newly created entry; do not expand that temporary builder. The next carry-forward step is to reuse/expose PastHPI server data so the generated note contains the curated threaded history. See [plans.md](plans.md).
- Current-note Topic sync is implemented and runtime-tested for Kevin-style `<LI>` topics, including insertion before the blank-line separator ahead of a table. `uHTMLNoteAnalysis` recognizes topic styles and `fNotes.InsertHTMLAtTopicEnds` modifies the live MSHTML DOM and attempts to preserve selection and scroll position. It finds all `<U>` elements, limits matches to HPI, and recognizes Dee's `* ` paragraph style; Dee-style runtime verification remains useful.
- New topic entries created while editing a note use the active note date rather than the selected visit; modified entries are selected for sync when their entry date matches the active note date. Pending new entries are collected without an additional same-date filter. Existing edits are appended as text, not used to replace historical text. Table changes are not yet synchronized to the active note.
- The DOM insertion routine searches for the end of the visible topic narrative before its table or terminal breaks, preserving existing separator breaks rather than adding a second pair. It falls back to the earlier topic-end behavior when the text anchor cannot be found. Date-prefix detection examines visible text, including dates split by HTML markup. The user confirmed the result works for Kevin-style notes; verify Dee-style and edge cases when convenient.
- `GLOBAL_HTMLTemplateDialogsMgr.SyncFromHTMLDocument` remains post-insertion embedded-dialog bookkeeping. Pending topics have a blue text bullet; successfully pushed entries have a session-only green bullet, unless another change remains pending. Deleting a topic entry removes its own pending/pushed status. The right pane open/closed state is saved, New/Edit focus the editor, successful current-note sync displays confirmation, and Prev/Next navigate visible topics. The user confirmed the temporary **Show only selected** topic sublist works; **Show all** restores the list, and patient changes clear the sublist. `lblFMDT` was removed after that verification and still needs a fresh build/runtime check.
- `CPRS-Chart\TMG_Extra\uMumpsData.pas` is a newly added JSON-backed MUMPS-tree wrapper; `TJSONObject` cannot be inherited because Delphi 12 seals it. It uses reserved `$value` keys for nodes having both a value and descendants. Public operations now include default value access (`Data[['a', 'b']]`), `Order`, `DataStatus` (M `$DATA` values), `Kill`, `Node`, and deep `Merge`, e.g. `Destination.Merge(['patient'], Source.Node(['contact']))`. See project-root [examples.txt](examples.txt). This new unit is exempt from the normal `//kt` / `//codex` source-marker convention per the user's instruction. It has not yet been compiled in the Windows IDE after the latest changes.
- Completed Topics/UI milestones, the historical thread rebuild, report aggregation, note-performance work, and the PNG transparency repair are recorded in [changelog.md](changelog.md), not here.

## Build and Verification

- Compilation must run in the licensed Windows Delphi IDE. The installed edition reports: `This version of the product does not support command line compiling.`
- For a new compile failure, the user saves fresh IDE output to `CPRS-Chart\build_errors.txt`; inspect it and fix the reported blockers incrementally. Do not treat an older log as an active failure.
- If compiler output disagrees with disk contents, suspect stale Delphi editor buffers and have the IDE reload them.

## Important Constraints

- Do not edit files under `D:\Embarcadero\...`. Those paths are installed Delphi/package sources and should only be read for comparison or copied from intentionally.
- Keep edits in this workspace: `P:\vista\TMGCPRS_v30A_Delphi12`.
- The active topic server routine is /opt/worldvista/EHR/p/TMGTOPIC.m. Edit it only when the user explicitly requests server work; keep it LF-terminated because it is a Linux M source file.
- After any M-routine source edit, ask the user to compile the routine; do not attempt M compilation from Codex. YottaDB executes the routine's `.o` object, so do not call a newly added or changed entry point until the user confirms compilation.
- For FileMan FDA writes made with the external-input `E` flag, pass pointer IENs in external form with a leading backtick (for example, `` `74592 ``); do not pass a bare internal IEN. Non-pointer external values such as `NOW` remain appropriate.
- Native VistA M routines under `/opt/worldvista/EHR/r/` are read-only: they may be inspected for behavior and RPC contracts, but must not be modified. The user may explicitly authorize an edit there under special circumstances.
- Never run `MUPIP RUNDOWN` or any database-maintenance, repair, or manipulation command. Do not invoke live M routines/RPCs for testing when they could write or otherwise mutate database globals; keep database work read-only unless the user explicitly directs a specific database operation.
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

This is a copied Delphi 12 porting tree. The production/source tree exists elsewhere. Its GitHub remote is `git@github.com:kdtop/TMG-CPRS.git`; this port uses the `delphi12` branch, which tracks `origin/delphi12`. The older compiler version remains on GitHub `master`; do not move `master` as part of Delphi 12 checkpoint work.

Check live Git status and log for the latest checkpoint rather than assuming the tree is clean. Earlier checkpoints and dated status are in [changelog.md](changelog.md).

Important Git workflow:

1. Before a new work session, run `git -c safe.directory=/mnt/WinPublic/vista/TMGCPRS_v30A_Delphi12 status --short`.
2. Review the current modified/untracked files before assuming anything is accidental.
3. When the user asks for a Git snapshot, review the current branch/upstream, stage intentional source/checkpoint changes, commit them locally, then push the active branch to GitHub. A requested snapshot explicitly means both the local commit and remote push; preserve `master` and use `delphi12` for this port.
4. Expect normal future edits to show as `M`/modified until they are committed; do not assume a dirty tree means a bad state.
5. Do not use `git reset --hard` or revert broad generated-file changes unless the user explicitly asks.
6. For commits made outside a requested snapshot, do not assume they have been pushed; local commits remain local until `git push`.

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
2. The current-note Topic sync is a good baseline. If revisiting it, test Dee's `* ` paragraph style, a topic without a terminal `<BR>`, and date/separator handling. Existing edits are appended rather than replaced; inspect the separate handling of new and edited entry dates before changing it.
3. Let the current metadata migration finish. If it must be restarted, re-read live `TMGTIUP1.m`, `TMGTIUT5.m`, and `TMGTOPIC.m`; compile their `.o` files; then use the `FIXALL` resume store to continue and validate groups/tables on representative KST and MDT notes.
4. If resuming Topics carry-forward work, begin with [plans.md](plans.md)'s PastHPI research/integration for carry-forward notes. Do not extend the temporary single-entry payload. Preserve pending state on failures and do not add a server macro action.
5. Before expanding `TMumpsDataObject`, build CPRS in the Windows Delphi IDE and save any fresh compiler output to `CPRS-Chart\build_errors.txt`. The new `Node`-based merge syntax and open-array default property have only had source-level review.
6. Reversible topic linking is deferred by the user; the motivation, design considerations, and rebuild concerns are in [plans.md](plans.md). Follow the user's current request and consult [changelog.md](changelog.md) for completed history.

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
