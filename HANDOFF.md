# CPRSChart Delphi Build Handoff

Last updated: 2026-09-10
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
- Optional tabs may not be created. Preserve guards around tab-form references and missing page IDs.

## Build and Verification

- Compilation must run in the licensed Windows Delphi IDE. The installed edition reports: `This version of the product does not support command line compiling.`
- For a new compile failure, the user saves fresh IDE output to `CPRS-Chart\build_errors.txt`; inspect it and fix the reported blockers incrementally. Do not treat an older log as an active failure.
- If compiler output disagrees with disk contents, suspect stale Delphi editor buffers and have the IDE reload them.
- User confirmed the note-selection/reload and pre-signature health-factor fixes work at runtime. A fresh Delphi build result for the health-factor change has not been recorded.

## Important Constraints

- Do not edit files under `D:\Embarcadero\...`. Those paths are installed Delphi/package sources and should only be read for comparison or copied from intentionally.
- Keep edits in this workspace: `P:\vista\TMGCPRS_v30A_Delphi12`.
- The RPCBroker talks to a server expecting single-byte character strings. Be careful around Broker/RPC payload paths; do not casually convert wire data to Unicode/multibyte behavior.
- Windows filesystem/API path fixes may use `string`/`PChar`; byte-oriented RPC/file-transfer payloads should stay `AnsiString`/`AnsiChar` unless deliberately changed.
- Leave Delphi `__recovery` folders alone and ignore them unless the user explicitly asks to clean them.
- Many Delphi source files are ANSI encoded. `apply_patch` may fail on them with invalid UTF-8; use encoding-preserving PowerShell edits only when necessary.
- The git tree was intentionally baselined locally on 2026-07-24. In this Linux-mounted workspace, plain `git ...` may fail with a dubious ownership error. Prefer `git -c safe.directory=/mnt/WinPublic/vista/TMGCPRS_v30A_Delphi12 ...` for status/log commands. Do not assume the tree is clean; the user may have several days of local changes that are not yet committed.
- For future Delphi/Pascal source edits, append `//kt //codex <date>` at the end of every modified source line, e.g. `//kt //codex 7/30/26`.
- If adding an entirely new Delphi/Pascal function or procedure, do not tag every line inside it. Instead, put `//kt //codex added entire function <date>` or `//kt //codex added entire procedure <date>` on the line immediately below the declaration.
- For future Delphi/Pascal source edits, when removing a line, leave the old line in place as a comment using this pattern: `//kt //codex original --> <old code>`.

## Git Workflow

This is a copied Delphi 12 porting tree. Git is used for local checkpoints; the production/source tree exists elsewhere. Do not assume commits have been pushed.

Latest source checkpoint: `db7fb43` — `Checkpoint Delphi 12 work and note selection reload improvements`. Check live Git status rather than assuming the tree is clean. Earlier checkpoints and dated status are in [changelog.md](changelog.md).

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
- If an earlier Codex change lacks its marker, add it when revisiting that line.

## Next Session Start

1. Read the current source and inspect Git status before editing.
2. For the Wine patient-selection issue, first reproduce the post-OK state and capture `xwininfo -root -tree`, `xprop -root _NET_ACTIVE_WINDOW`, and detailed `xprop`/`xwininfo` data for Patient Selection, visible CPRS main, and the hidden `CPRS - Patient Chart` group-leader window.
3. Use the existing `uDebugTools` selector log to determine whether `ModalResult` remains nonzero and whether `FormClose`/`FormHide` actually fire. Do not infer those Delphi states from X11 alone.
4. Follow the user's current request; use [changelog.md](changelog.md) for relevant history rather than treating old next-step recommendations as active tasks.
5. If testing `ReloadNotes`, check return to editing after template insertion, the no-active-edit refresh, and a note absent from the current view.
6. For runtime/designer problems, inspect the active unit/DFM pair. For compile problems, use fresh IDE output.
7. For further HTML-stack cleanup, read the current files and the orientation documents below before removing dependencies.

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
