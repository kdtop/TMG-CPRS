# CPRSChart Delphi Build Handoff

Last updated: 2026-07-25
Workspace: `P:\vista\TMGCPRS_v30A_Delphi12`
Project: `CPRS-Chart\CPRSChart.dproj`

## Environment

- Delphi 12 compilation must be run from inside the Windows Server session where Delphi is installed and licensed.
- The source tree is in the `vista` directory as `TMGCPRS_v30A_Delphi12`.
- In the Windows Server/Delphi session, the project is normally opened from `P:\vista\TMGCPRS_v30A_Delphi12`.
- From this Codex/Linux workspace, the same tree is mounted at `/mnt/WinPublic/vista/TMGCPRS_v30A_Delphi12`.
- Delphi logs may also refer to `F:\Shares\Public\vista\TMGCPRS_v30A_Delphi12`; treat that as the same source tree unless the user says otherwise.

## Goal

Keep CPRSChart compiling with the installed Delphi 12 IDE/compiler.

The user compiles from the Delphi IDE and saves compiler output to:

`CPRS-Chart\build_errors.txt`

The working loop is:

1. User compiles in Delphi IDE.
2. Agent reads `CPRS-Chart\build_errors.txt`.
3. Agent patches the next compile blocker, if any.
4. Repeat.

Command-line build is not currently useful because the installed Delphi edition reports:

`This version of the product does not support command line compiling.`

Use the IDE compile log as the source of truth.

## Important Constraints

- Do not edit files under `D:\Embarcadero\...`. Those paths are installed Delphi/package sources and should only be read for comparison or copied from intentionally.
- Keep edits in this workspace: `P:\vista\TMGCPRS_v30A_Delphi12`.
- The RPCBroker talks to a server expecting single-byte character strings. Be careful around Broker/RPC payload paths; do not casually convert wire data to Unicode/multibyte behavior.
- Windows filesystem/API path fixes may use `string`/`PChar`; byte-oriented RPC/file-transfer payloads should stay `AnsiString`/`AnsiChar` unless deliberately changed.
- Leave Delphi `__recovery` folders alone and ignore them unless the user explicitly asks to clean them.
- Many Delphi source files are ANSI encoded. `apply_patch` may fail on them with invalid UTF-8; use encoding-preserving PowerShell edits only when necessary.
- The git tree was intentionally baselined locally on 2026-07-24. Use `git status --short` before edits; it should be clean at session start unless the user has changed files.
- For future Delphi/Pascal source edits, append `//kt //codex <date>` at the end of every modified source line, e.g. `//kt //codex 7/24/26`.

## Git Baseline

This is a copied Delphi 12 porting tree. The real production/source tree exists elsewhere and is safe. Git in this folder is being used for local version control/checkpoints, not necessarily for pushing to GitHub.

Substantive local baseline commits, newest first:

- `f08ed49 Document local git baseline`
- `497962a Create Delphi 12 working tree baseline`
- `54f1dc1 Ignore Delphi compiled unit artifacts`
- `12afbc9 Port CPRS Broker source for Delphi 12`

These commits are local checkpoints in the copied Delphi 12 working tree. There may also be a later `HANDOFF.md`-only documentation commit at `HEAD`; that does not change source behavior. `origin/master` still points at the older source history (`c58ce2b` at the time this handoff was updated), so this branch is intentionally ahead of `origin/master`. That does not mean the real source tree elsewhere has been changed.

After the latest local handoff update, `git status --short` was clean. "Clean" means there are no uncommitted changes relative to this copied tree's new local baseline. Ignored Delphi build artifacts still exist on disk, especially `.dcu`, `__history`, shortcut, and backup files, but they should not dirty normal status.

`.dcu` files were removed from Git tracking and ignored. `.gitignore` contains `*.dcu` and `*.DCU`.

Important Git workflow:

1. Before a new work session, run `git status --short`.
2. If clean, start editing normally.
3. Commit intentional source/checkpoint changes locally with `git add ...` and `git commit -m "..."`.
4. Expect normal future edits to show as `M`/modified until they are committed; after a commit, `git status --short` should return to clean.
5. Do not use `git reset --hard` or revert broad generated-file changes unless the user explicitly asks.
6. Do not assume commits have been pushed; local commits remain local until `git push`.

## Current State

`CPRS-Chart\build_errors.txt` currently reflects the last IDE compile before the latest `BDK50\Rpcnet.pas` patch. It is not a fresh compile after that patch.

Latest saved compile state:

- `BDK50\wsockc.pas` no longer has fatal/errors; it still has many string-cast warnings.
- Compile then failed in `BDK50\Rpcnet.pas` with `PAnsiChar` / `PWideChar` mismatches at old host/IP lookup calls.
- `BDK50\Rpcnet.pas` has now been patched for that failing compile wave.
- The next required action is another IDE compile from the Windows Server Delphi session, then save the refreshed output to `CPRS-Chart\build_errors.txt`.

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

If the next IDE compile errors inside `BDK50` units, prefer patching the local extracted source rather than installed Delphi/package files. Continue tagging every modified Pascal source line with `//kt //codex 7/24/26`.

After the first compile with local Broker source, `CPRS-Chart\build_errors.txt` showed many `BDK50\wsockc.pas` errors where old Winsock code used `PChar`/`Char` assuming ANSI but Delphi 12 treats `PChar` as UTF-16. Patched `BDK50\wsockc.pas` and `BDK50\Trpcb.pas` so the Broker's raw socket buffers and low-level `NetCall`/`tCall`/`pchCall` pointer path use `PAnsiChar`, `AnsiChar`, and `AnsiString` at the Winsock/RPC wire boundary.

The next compile reached the edited `NetCall` code and showed that unqualified `StrAlloc`/`StrNew`/`StrCopy` still resolved to Unicode `SysUtils` helpers returning `PWideChar`. Patched active ANSI buffer helper calls in `BDK50\wsockc.pas` and `BDK50\Trpcb.pas` to use `AnsiStrings.StrNew`, `AnsiStrings.StrCopy`, `AnsiStrings.StrDispose`, etc.

Follow-up compile showed Delphi's `AnsiStrings` unit does not expose `StrAlloc`, and unqualified `StrLen` became ambiguous after adding `AnsiStrings`. Patched `BDK50\wsockc.pas` so temporary receive/server-packet buffers use `AllocMem` / `FreeMem`, returned RPC strings use `AnsiStrings.StrNew`, and old `cLeft`/`cRight` helpers call `AnsiStrings.StrLen`. Patched `BDK50\Trpcb.pas` so `Sec` / `App` scratch buffers use `AllocMem` / `FreeMem`.

Next compile cleared `wsockc.pas` errors and moved to `BDK50\Rpcnet.pas`. Patched `Rpcnet.pas` host/IP lookup buffers so `libGetHostIP1`, `libGetLocalIP`, and the async result record use `PAnsiChar`, with `AllocMem` / `FreeMem` for scratch buffers and `AnsiStrings.StrCopy` / `StrCat` / `StrPCopy` / `StrPas` for ANSI text. `inet_ntoa` results are copied into the existing ANSI buffer instead of assigning the static Winsock pointer. The user has not yet recompiled after this `Rpcnet.pas` pass.

## Next Session Start

Recommended first step:

1. Have the user compile once in the Delphi 12 IDE inside the Windows Server session.
2. Read the refreshed `CPRS-Chart\build_errors.txt`.
3. If errors remain, expect the next blocker after the latest `BDK50\Rpcnet.pas` patch; patch only the next concrete blocker and preserve byte-oriented RPC behavior.
4. If there are no errors/fatal errors, ask the user to run CPRSChart again and verify startup no longer breaks on `Error accessing the OLE registry` or `Unable to pass parameter type to Broker`.

Useful error filter:

```powershell
Select-String -Path .\CPRS-Chart\build_errors.txt -Pattern '\[dcc32 (Error|Fatal Error)\]| error [A-Z][0-9]+|Fatal Error'
```

Do not assume the saved compile log is fresh. At session start, compare `CPRS-Chart\build_errors.txt` against the latest handoff state and ask the user for a new IDE compile if it still shows the pre-`Rpcnet.pas` patch errors.

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
