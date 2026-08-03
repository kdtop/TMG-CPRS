# CPRSChart Delphi Build Handoff

Last updated: 2026-08-03
Workspace: `P:\vista\TMGCPRS_v30A_Delphi12`
Project: `CPRS-Chart\CPRSChart.dproj`

## Environment

- Delphi 12 compilation must be run from inside the Windows Server session where Delphi is installed and licensed.
- The source tree is in the `vista` directory as `TMGCPRS_v30A_Delphi12`.
- In the Windows Server/Delphi session, the project is normally opened from `P:\vista\TMGCPRS_v30A_Delphi12`.
- From this Codex/Linux workspace, the same tree is mounted at `/mnt/WinPublic/vista/TMGCPRS_v30A_Delphi12`.
- Delphi logs may also refer to `F:\Shares\Public\vista\TMGCPRS_v30A_Delphi12`; treat that as the same source tree unless the user says otherwise.

## Goal

Primary current goal as of 2026-08-03:

- Keep CPRSChart working under Delphi 12 at runtime/debug time now that the project compiles successfully again in the Delphi IDE.
- Continue cautiously simplifying the old HTML editor/browser wrapper area without breaking the current successful Delphi IDE build.

Secondary goal when needed:

- If the user reports a new compile regression, return temporarily to compile-blocker triage using a fresh Delphi IDE compile log.

Compile-log workflow, only when the user reports a new compile failure:

1. User compiles in the Delphi IDE.
2. User saves compiler output to `CPRS-Chart\build_errors.txt`.
3. Agent reads `CPRS-Chart\build_errors.txt`.
4. Agent patches the next compile blocker, if any.
5. Repeat.

Command-line build is not currently useful because the installed Delphi edition reports:

`This version of the product does not support command line compiling.`

When there is an active compile problem, use the fresh IDE compile log as the source of truth. Otherwise, assume runtime/debugging cleanup is the active work.

## Important Constraints

- Do not edit files under `D:\Embarcadero\...`. Those paths are installed Delphi/package sources and should only be read for comparison or copied from intentionally.
- Keep edits in this workspace: `P:\vista\TMGCPRS_v30A_Delphi12`.
- The RPCBroker talks to a server expecting single-byte character strings. Be careful around Broker/RPC payload paths; do not casually convert wire data to Unicode/multibyte behavior.
- Windows filesystem/API path fixes may use `string`/`PChar`; byte-oriented RPC/file-transfer payloads should stay `AnsiString`/`AnsiChar` unless deliberately changed.
- Leave Delphi `__recovery` folders alone and ignore them unless the user explicitly asks to clean them.
- Many Delphi source files are ANSI encoded. `apply_patch` may fail on them with invalid UTF-8; use encoding-preserving PowerShell edits only when necessary.
- The git tree was intentionally baselined locally on 2026-07-24. In this Linux-mounted workspace, plain `git ...` may fail with a dubious ownership error. Prefer `git -c safe.directory=/mnt/WinPublic/vista/TMGCPRS_v30A_Delphi12 ...` for status/log commands. Do not assume the tree is clean; the user may have several days of local changes that are not yet committed.
- For future Delphi/Pascal source edits, append `//kt //codex <date>` at the end of every modified source line, e.g. `//kt //codex 7/30/26`.
- For future Delphi/Pascal source edits, when removing a line, leave the old line in place as a comment using this pattern: `//kt //codex original --> <old code>`.

## Git Baseline

This is a copied Delphi 12 porting tree. The real production/source tree exists elsewhere and is safe. Git in this folder is being used for local version control/checkpoints, not necessarily for pushing to GitHub.

Substantive local baseline commits, newest first:

- `2d6ed84 Checkpoint current Delphi 12 HTML editor/debugging state`
- `f08ed49 Document local git baseline`
- `497962a Create Delphi 12 working tree baseline`
- `54f1dc1 Ignore Delphi compiled unit artifacts`
- `12afbc9 Port CPRS Broker source for Delphi 12`

These commits are local checkpoints in the copied Delphi 12 working tree. There may also be a later `HANDOFF.md`-only documentation commit at `HEAD`; that does not change source behavior. `origin/master` still points at the older source history (`c58ce2b` at the time this handoff was updated), so this branch is intentionally ahead of `origin/master`. That does not mean the real source tree elsewhere has been changed.

`git status --short` was clean immediately after the 2026-07-30 handoff-only update. That is no longer a safe assumption for later sessions. As of 2026-07-31, the user reports the local git view has not been updated in a few days and the working tree may contain intentional uncommitted edits plus generated artifacts and backup files.

`.dcu` files were removed from Git tracking and ignored. `.gitignore` contains `*.dcu` and `*.DCU`.

Important Git workflow:

1. Before a new work session, run `git -c safe.directory=/mnt/WinPublic/vista/TMGCPRS_v30A_Delphi12 status --short`.
2. Review the current modified/untracked files before assuming anything is accidental.
3. Commit intentional source/checkpoint changes locally with `git add ...` and `git commit -m "..."` when the user wants a new checkpoint.
4. Expect normal future edits to show as `M`/modified until they are committed; do not assume a dirty tree means a bad state.
5. Do not use `git reset --hard` or revert broad generated-file changes unless the user explicitly asks.
6. Do not assume commits have been pushed; local commits remain local until `git push`.

## Current State

As of 2026-08-03, the user has confirmed a successful Delphi IDE compile. Active work is runtime/debugging cleanup and cautious HTML-stack simplification rather than basic compile blocking.

Important:

- Do not assume older `CPRS-Chart\build_errors.txt` notes below are current.
- If the user reports a new compile problem, ask for a fresh IDE compile log.
- Otherwise, assume the main active work is runtime behavior under Delphi 12.

Recommended working assumption for the next session:

- Start from runtime/designer/debugging investigation unless the user explicitly says the build is failing again.
- Treat `CPRS-Chart\build_errors.txt` as historical context unless the user has just saved a fresh compile log from the Delphi IDE.

### Runtime / Debugging Status As Of 2026-08-01

- The application compiles and can start, log in, and communicate with the RPC Broker.
- Several Delphi 12 runtime/designer compatibility issues have been found and fixed incrementally.
- Current work has shifted to runtime AV/debugger cleanup in chart tabs and older helper units.
- The user is reviewing the `HTMLEdit` / `EmbeddedED` area cautiously. Do not assume broad code-pruning work is already complete or safe to resume without re-checking actual call sites.

### HTML / HTMLEdit Status As Of 2026-08-03

- The user reports that CPRS currently compiles after substantial HTMLEdit streamlining work.
- `EmbeddedED` has effectively been cut out of the active CPRS build path:
  - `THtmlObj` in `TMGHTML2.pas` was changed to descend from `TWebBrowser`.
  - Code previously relied on from `EmbeddedED` was copied into `TMGHTML2.pas` inside the user-created `//kt //codex From EmbeddedED` section as needed during compile-fix passes.
  - The user then removed the `EmbeddedED` folder from the tree and reported a full build still succeeded.
- The user also removed old `IE*.pas` files and old `Ewb*/EWB*` helper files after compile testing, and reported builds still succeeded.
- `MSHTML_EWB.pas` is a local modified type-library import, not a stock Delphi unit. The user has been gradually moving usages from `MSHTML_EWB` to plain `MSHTML`.
- During that migration, plain `MSHTML` often does not expose `Elem.className` the same way the old local import did. Current practical compatibility workaround:
  - use `VarToStr(Elem.getAttribute('className', 0))`
  - use `Elem.setAttribute('className', ..., 0)` for writes
- Do not assume every remaining `MSHTML_EWB` reference is gone. Re-check actual current source before making more replacements.

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

Recent confirmed fixes from this session:

- `CPRS-Chart\TMG_Extra\HTMLEdit\EmbeddedED\EmbeddedED.pas`
  - `LoadFromString` was fixed for Delphi 12 Unicode `Char` sizing when copying HTML into global memory before handing it to the embedded browser.
  - The prior code allocated and copied as if `Char` were single-byte; that truncated HTML and caused the browser "View Source" output to stop around `&nbsp;&amp;n`.
  - The fix now allocates `(Length(aString)+1) * SizeOf(Char)`, copies with `Move(PChar(aString)^, ...)` using `Length(aString) * SizeOf(Char)`, and writes an explicit null terminator.
  - The user confirmed on 2026-07-31 that this resolved the missing/truncated HTML display issue.
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
- `CPRS-Chart\TMG_Extra\HTMLEdit\EmbeddedED\KS_procs.pas`
  - `IsAlNum()` was fixed after UTF-8 conversion by replacing the old `'À'..'ÿ'` set range with an `Ord(C)` range test.

### Encoding / Editing Notes

- The user converted `CPRS-Chart\TMG_Extra\uHTMLTools.pas` to UTF-8 using Windows Notepad so it is easier to edit safely.
- A root script now exists: `convert_ansi_to_utf8.sh`
  - Recurses through the tree
  - Detects non-UTF-8 Delphi source files
  - Converts them from Windows-1252 to UTF-8
  - Creates `.bak` backups
- The script can introduce follow-up compile fixes in old third-party units; use it cautiously and expect Unicode/set-expression cleanup afterward.
- Delphi IDE state matters: on 2026-07-31, compile errors persisted until the user closed and reopened Delphi so the IDE reloaded `EmbeddedED.pas` from disk. If compile output does not match the current file contents, suspect a stale in-memory editor buffer before assuming the source is still broken.

### User Editing Conventions

- Add `//kt //codex <date>` to modified Delphi/Pascal source lines.
- If removing Delphi/Pascal code, leave the old line behind as:
  - `//kt //codex original --> <old code>`
- The user may manually revise Codex patches after review. Read the current file contents before making follow-up edits.

Current compile state:

- CPRS currently compiles in the Delphi 12 IDE.
- Active work is now runtime/debugging cleanup after compile success.
- `CPRS-Chart\build_errors.txt` may currently contain stale `EmbeddedED.pas` forward-declaration failures from before the Delphi IDE reload on 2026-07-31. Do not treat that file as current unless the user saves a fresh compile log after reopening Delphi.
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

## Next Session Start

Recommended first step:

1. Read the current source before editing; the user manually adjusted some recent patches, especially `CPRS-Lib\ORFn.pas` and event-handler fixes.
2. Run `git -c safe.directory=/mnt/WinPublic/vista/TMGCPRS_v30A_Delphi12 status --short`, but treat the result as informational only unless the user asks to clean or checkpoint it.
3. If the user reports a compile issue, ask for a fresh Delphi IDE compile log and ignore stale compile guidance, especially if Delphi may still have an old in-memory copy of `EmbeddedED.pas`.
4. If the user reports a runtime/designer issue, inspect the active unit/DFM pair first; many current failures are old-component/Delphi-12 compatibility problems rather than broker/compile failures.
5. If returning to `HTMLEdit` / browser-stack cleanup, start by reading the current `TMGHTML2.pas`, `uHTMLDlgObjs.pas`, `uHTMLTemplateFields.pas`, and current `uses` lists before assuming older `EmbeddedED` assumptions still apply.
6. Do not run another broad automated unused-variable cleanup pass. If removing unused locals, do it manually and in very small scopes.
7. Be careful with files converted from ANSI to UTF-8; conversion can surface warnings/errors in old character-set code.

Historical compile-porting notes follow below. They are preserved for context, not as the default current task. Do not resume that older Broker/compile sequence unless the user reports a new compile regression that points back into the same area.

Useful error filter:

```powershell
Select-String -Path .\CPRS-Chart\build_errors.txt -Pattern '\[dcc32 (Error|Fatal Error)\]| error [A-Z][0-9]+|Fatal Error'
```

Do not assume the saved compile log is fresh. If `CPRS-Chart\build_errors.txt` is empty, stale, or inconsistent with the current runtime/debugging work, ask the user for a fresh IDE compile log before treating it as an active blocker.

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

## HTMLEdit Streamlining Idea

The HTMLEdit area appears to be a large imported third-party stack plus a local wrapper:

- Main local wrapper: `CPRS-Chart\TMG_Extra\HTMLEdit\TMGHTML2.pas`
- `THtmlObj` is currently declared as `class(TEmbeddedED)`.
- Imported embedded editor package files live under `CPRS-Chart\TMG_Extra\HTMLEdit\EmbeddedED`.
- Very large generated/browser support units include `MSHTML_EWB.pas`, `MSHTMLEvents.pas`, `EmbeddedED.pas`, `IEdispConst.pas`, and numerous `Ewb*/IE*` helper units.

Initial scan suggests CPRS mostly depends on `THtmlObj` as an abstraction, not directly on most of the imported package. Common call sites use:

- creation: `THtmlObj.Create(...)`
- text/html load/save: `Text`, `Clear`
- edit state: `KeyStruck`
- selection/caret: `SelText`, `InsertHTMLAtCaret`, `MoveCaretToPos`
- simple formatting/edit commands: `ToggleBold`, `ToggleItalic`, colors, paste, send keys
- DOM helpers: `GetElementById`, class/tag searches, style/script helpers

Possible second-phase strategy after the Delphi 12 compile pass is stable:

1. Keep the public `THtmlObj` API stable.
2. Introduce a smaller implementation behind that API, probably based directly on `TWebBrowser`/IE COM (`IHTMLDocument2`, `IHTMLTxtRange`, `execCommand`, `designMode`/`contentEditable`).
3. Migrate call sites gradually by preserving `THtmlObj` method names.
4. Remove unused imported units only after compile references prove they are no longer needed.
