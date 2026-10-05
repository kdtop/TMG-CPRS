# CPRSChart Delphi Build Handoff

Last updated: 2026-10-04
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

- Topic metadata migration is in progress. `PARSESCT2^TMGTIUP1` emits `TOPIC META` for every parsed topic, including a group list and all table names; `FILE1B^TMGTIUT5` synchronizes the metadata without creating a thread entry when there is no current-visit text. `GROUP=A,B,...` replaces only the existing `GROUP=` token in topic User Data; other space-delimited tokens remain intact. `FIXALL2^TMGTOPIC` invokes metadata-only `FIXALL`, which resumes from `^TMG("TMP","FIXALL^TMGTOPIC",DFN)`.
- `FIXALL2` is running correctly but is not yet complete. It is safe to resume because `FIXALL` skips patients already recorded in its resume store. Preserve the user's correction for child-only `QUIET(TIUIEN)` entries: test `$DATA(QUIET(TIUIEN))`, then display it with `ZWR QUIET(TIUIEN,*)` rather than reading a possibly undefined scalar value. Recompile changed M routines before resuming because YottaDB executes their `.o` objects.
- Future design direction: add a Topics-to-active-note macro. The Notes context menu gets its macro list through `TMG CPRS GET MACRO LIST`; selected macros run through `TMG CPRS MACRO RESOLVE`, replacing the returned note/editor text. See `fNotes.pas`, `rTIU.pas`, and `TMGRPC1I.m` before implementing.
- Completed Topics/UI milestones, the historical thread rebuild, report aggregation, note-performance work, and the PNG transparency repair are recorded in [changelog.md](changelog.md), not here.

## Build and Verification

- Compilation must run in the licensed Windows Delphi IDE. The installed edition reports: `This version of the product does not support command line compiling.`
- For a new compile failure, the user saves fresh IDE output to `CPRS-Chart\build_errors.txt`; inspect it and fix the reported blockers incrementally. Do not treat an older log as an active failure.
- If compiler output disagrees with disk contents, suspect stale Delphi editor buffers and have the IDE reload them.

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

This is a copied Delphi 12 porting tree. The production/source tree exists elsewhere. Its GitHub remote is `git@github.com:kdtop/TMG-CPRS.git`; this port uses the `delphi12` branch, which tracks `origin/delphi12`. The older compiler version remains on GitHub `master`; do not move `master` as part of Delphi 12 checkpoint work.

Latest source checkpoint: `1b4a643` (Reports browser zoom and current Topics work), published to `origin/delphi12`. Check live Git status and log rather than assuming the tree is clean. Earlier checkpoints and dated status are in [changelog.md](changelog.md).

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
2. Let the current metadata migration finish. If it must be restarted, re-read live `TMGTIUP1.m`, `TMGTIUT5.m`, and `TMGTOPIC.m`; compile their `.o` files; then use the `FIXALL` resume store to continue and validate groups/tables on representative KST and MDT notes.
3. If implementing Topics-to-note insertion, begin with the existing macro RPC contracts and decide whether the macro inserts all selected Topics data or a user-chosen subset.
4. Follow the user's current request; consult [changelog.md](changelog.md) for completed history and deferred work rather than treating it as an active plan.

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
