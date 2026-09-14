unit uDebugTools;
//kt //codex 9/9/26 Added entire unit.

interface


function DebugMsg(const Msg: string): Boolean; overload;
function DebugMsg(const LogFileName, Msg: string): Boolean; overload;
procedure DebugMsgFormReport(const Msg: string);

implementation

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Tabs, ComCtrls,
  ExtCtrls, Menus, StdCtrls, Buttons, ORFn, fPage, uConst, ORCtrls, Trpcb,
  OleCtrls, fBase508Form,
  StrUtils, Variants, Types;


function DebugLogPath(const LogFileName: string): string;
var
  PathBuf: array[0..MAX_PATH] of Char;
begin
  FillChar(PathBuf, SizeOf(PathBuf), 0);
  if GetTempPath(MAX_PATH, PathBuf) > 0 then begin
    Result := IncludeTrailingPathDelimiter(StrPas(PathBuf));
  end else begin
    Result := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP'));
    if Result = '' then Result := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TMP'));
    if Result = '\' then Result := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TMP'));
    if Result = '' then Result := 'C:\';
    if Result = '\' then Result := 'C:\';
  end;
  Result := Result + LogFileName;
end;

function DebugMsg(const Msg: string): Boolean; overload;
begin
  Result := DebugMsg('cprs_debug.log', Msg);
end;

function DebugMsg(const LogFileName, Msg: string): Boolean; overload;
var
  F: TextFile;
  LogPath: string;
begin
  Result := False;
  try
    LogPath := DebugLogPath(LogFileName);
    AssignFile(F, LogPath);
    if FileExists(LogPath) then Append(F) else Rewrite(F);
    try
      Writeln(F, FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' ' + Msg);
      Result := True;
    finally
      CloseFile(F);
    end;
  except
    Result := False;
  end;
end;

procedure DebugMsgFormReport(const Msg: string);
var
  ActiveFormName: string;
  I: Integer;
  Form: TForm;
begin
  try
    DebugMsg('cprs_ptsel_diag.log', Msg);
    if Assigned(Screen.ActiveForm) then ActiveFormName := Screen.ActiveForm.Name else ActiveFormName := '<nil>';
    DebugMsg('cprs_ptsel_diag.log', Format('  Screen.FormCount=%d ActiveForm=%s', [Screen.FormCount, ActiveFormName]));
    for I := 0 to Screen.FormCount - 1 do begin
      Form := TForm(Screen.Forms[I]);
      DebugMsg('cprs_ptsel_diag.log', Format('  Form[%d] name="%s" class=%s caption="%s" visible=%s enabled=%s active=%s handle=%d bounds=%d,%d %dx%d border=%d formstyle=%d',
        [I, Form.Name, Form.ClassName, Form.Caption, BoolToStr(Form.Visible, True), BoolToStr(Form.Enabled, True),
         BoolToStr(Form.Active, True), Form.Handle, Form.Left, Form.Top, Form.Width, Form.Height, Ord(Form.BorderStyle), Ord(Form.FormStyle)]));
    end;
  except
  end;
end;


end.
