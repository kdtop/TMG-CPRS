unit WinMsgLog;
//kt added entire unit 8/2016
// For debugging windows messages

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

const
  MESSAGES_LOGGED = 1000;
type
  TfrmWinMessageLog = class(TForm)
    Label1: TLabel;
    lblNumLogged: TLabel;
    Label2: TLabel;
    lblLastIndex: TLabel;
    Label3: TLabel;
    edtViewIndex: TEdit;
    UpDown: TUpDown;
    Memo: TMemo;
    btnDone: TButton;
    btnClear: TButton;
    procedure btnClearClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpDownChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    MessageNames : TStringList;
    FilteredMsgs : TStringList;
    procedure SetupMsgNames();
    procedure SetupFilteredMsgs();
    function IsFiltered(MsgNum : integer) : boolean;
  public
    { Public declarations }
    LastLogIndex : integer;
    NumLogged : integer;
    MessageLog : array[0..MESSAGES_LOGGED-1] of TMessage;  //rotating cache
    procedure GetMessageNames(Num : integer; SL : TStringList);
    procedure SaveMsg(Msg : TMessage);
    procedure DisplayMsg(Index: integer);
  end;

//var
//  not auto-created
//  frmWinMessageLog: TfrmWinMessageLog;

implementation

{$R *.dfm}

procedure TfrmWinMessageLog.btnClearClick(Sender: TObject);
var
  ClearMsg : TMessage;
  i : integer;
begin
  LastLogIndex := -1;
  NumLogged := 0;
  UpDown.Position := 0;
  edtViewIndex.Text := IntToStr(0);
  Memo.Lines.Clear();
  lbllastIndex.Caption := IntToStr(LastLogIndex);
  lblNumLogged.Caption := IntToStr(NumLogged);
  ClearMsg.Msg := 0;
  ClearMsg.LParam := 0;
  ClearMsg.WParam := 0;
  for i := 0 to MESSAGES_LOGGED-1 do begin
    MessageLog[i] := ClearMsg;
  end;
end;

procedure TfrmWinMessageLog.btnDoneClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmWinMessageLog.FormCreate(Sender: TObject);
begin
  LastLogIndex := -1;
  UpDown.Min := 0;
  UpDown.Max := MESSAGES_LOGGED-1;
  MessageNames := TStringList.Create;
  SetupMsgNames();
  FilteredMsgs := TStringList.Create;
  SetupFilteredMsgs();
end;

procedure TfrmWinMessageLog.FormDestroy(Sender: TObject);
begin
  MessageNames.Free;
  FilteredMsgs.Free;
end;

procedure TfrmWinMessageLog.SaveMsg(Msg : TMessage);
begin
  if IsFiltered(Msg.Msg) then exit;
  inc(LastLogIndex);
  if LastLogIndex >= MESSAGES_LOGGED then LastLogIndex := 0;
  MessageLog[LastLogIndex] := Msg;
  lbllastIndex.Caption := IntToStr(LastLogIndex);
  if (LastLogIndex+1) > NumLogged then begin
    NumLogged := LastLogIndex+1;
    lblNumLogged.Caption := IntToStr(NumLogged);
  end;
end;

procedure TfrmWinMessageLog.UpDownChangingEx(Sender: TObject;
                                             var AllowChange: Boolean;
                                             NewValue: Smallint;
                                             Direction: TUpDownDirection);
begin
  AllowChange := true;
  if (Direction = updUp) then begin
    if (UpDown.Position = NumLogged) then begin
      AllowChange := false;
    end else if (UpDown.Position = UpDown.Max) then begin
      NewValue := 0;
    end;
  end else if (UpDown.Position = 0) and (Direction = updDown) then begin
    NewValue := UpDown.Max;
  end;
end;

procedure TfrmWinMessageLog.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  DisplayMsg(UpDown.Position);
end;

procedure TfrmWinMessageLog.DisplayMsg(Index: integer);
var
  AMsg : TMessage;
  SL : TStringList;
  i : integer;
begin
  SL := TStringList.Create();
  edtViewIndex.Text := IntToStr(Index);
  Memo.Lines.Clear();
  AMsg := MessageLog[Index];
  Memo.Lines.Add('Message log index: #' + IntToStr(Index));;
  Memo.Lines.Add('-------------------------------------');
  Memo.Lines.Add('Msg: ' + IntTostr(AMsg.Msg));
  GetMessageNames(AMsg.Msg, SL);
  for i := 0 to SL.Count-1 do begin
    Memo.Lines.Add('  name: ' + SL[i]);
  end;
  Memo.Lines.Add('WParam: ' + IntTostr(AMsg.WParam));
  Memo.Lines.Add('  WParamLo: ' + IntTostr(AMsg.WParamLo));
  Memo.Lines.Add('  WParamHi: ' + IntTostr(AMsg.WParamHi));
  Memo.Lines.Add('LParam: ' + IntTostr(AMsg.LParam));
  Memo.Lines.Add('  LParamLo: ' + IntTostr(AMsg.LParamLo));
  Memo.Lines.Add('  LParamHi: ' + IntTostr(AMsg.LParamHi));
  Memo.Lines.Add('Result: ' + IntTostr(AMsg.Result));
  Memo.Lines.Add('  ResultLo: ' + IntTostr(AMsg.ResultLo));
  Memo.Lines.Add('  ResultHi: ' + IntTostr(AMsg.ResultHi));
  SL.Free;

end;


procedure TfrmWinMessageLog.GetMessageNames(Num : integer; SL : TStringList);
var i : integer;
begin
  SL.Clear();
  for i := 0 to MessageNames.count-1 do begin
    if integer(MessageNames.Objects[i]) = Num then begin
      SL.Add(MessageNames.Strings[i]);
    end;
  end;
end;

procedure TfrmWinMessageLog.SetupFilteredMsgs();
begin
  FilteredMsgs.Add('132'); //WM_NCHITTEST
  FilteredMsgs.Add('512'); //WM_MOUSEMOVE
  FilteredMsgs.Add('32'); //WM_SETCURSOR
  FilteredMsgs.Add('275'); //WM_TIMER
end;

function TfrmWinMessageLog.IsFiltered(MsgNum  : integer) : boolean;
var idx : integer;
begin
  idx := FilteredMsgs.IndexOf(IntToStr(MsgNum));
  Result := (idx <> -1);
end;

procedure TfrmWinMessageLog.SetupMsgNames();
begin
  MessageNames.Clear();
  MessageNames.AddObject('WM_NULL',pointer($0000));
  MessageNames.AddObject('WM_CREATE', pointer($0001));
  MessageNames.AddObject('WM_DESTROY', pointer($0002));
  MessageNames.AddObject('WM_MOVE', pointer($0003));
  MessageNames.AddObject('WM_SIZE', pointer($0005));
  MessageNames.AddObject('WM_ACTIVATE', pointer($0006));
  MessageNames.AddObject('WM_SETFOCUS', pointer($0007));
  MessageNames.AddObject('WM_KILLFOCUS', pointer($0008));
  MessageNames.AddObject('WM_ENABLE', pointer($000A));
  MessageNames.AddObject('WM_SETREDRAW', pointer($000B));
  MessageNames.AddObject('WM_SETTEXT', pointer($000C));
  MessageNames.AddObject('WM_GETTEXT', pointer($000D));
  MessageNames.AddObject('WM_GETTEXTLENGTH', pointer($000E));
  MessageNames.AddObject('WM_PAINT', pointer($000F));
  MessageNames.AddObject('WM_CLOSE', pointer($0010));
  MessageNames.AddObject('WM_QUERYENDSESSION', pointer($0011));
  MessageNames.AddObject('WM_QUIT', pointer($0012));
  MessageNames.AddObject('WM_QUERYOPEN', pointer($0013));
  MessageNames.AddObject('WM_ERASEBKGND', pointer($0014));
  MessageNames.AddObject('WM_SYSCOLORCHANGE', pointer($0015));
  MessageNames.AddObject('WM_ENDSESSION', pointer($0016));
  MessageNames.AddObject('WM_SYSTEMERROR', pointer($0017));
  MessageNames.AddObject('WM_SHOWWINDOW', pointer($0018));
  MessageNames.AddObject('WM_CTLCOLOR', pointer($0019));
  MessageNames.AddObject('WM_WININICHANGE', pointer($001A));
  MessageNames.AddObject('WM_SETTINGCHANGE', pointer($001A));
  MessageNames.AddObject('WM_DEVMODECHANGE', pointer($001B));
  MessageNames.AddObject('WM_ACTIVATEAPP', pointer($001C));
  MessageNames.AddObject('WM_FONTCHANGE', pointer($001D));
  MessageNames.AddObject('WM_TIMECHANGE', pointer($001E));
  MessageNames.AddObject('WM_CANCELMODE', pointer($001F));
  MessageNames.AddObject('WM_SETCURSOR', pointer($0020));
  MessageNames.AddObject('WM_MOUSEACTIVATE', pointer($0021));
  MessageNames.AddObject('WM_CHILDACTIVATE', pointer($0022));
  MessageNames.AddObject('WM_QUEUESYNC', pointer($0023));
  MessageNames.AddObject('WM_GETMINMAXINFO', pointer($0024));
  MessageNames.AddObject('WM_PAINTICON', pointer($0026));
  MessageNames.AddObject('WM_ICONERASEBKGND', pointer($0027));
  MessageNames.AddObject('WM_NEXTDLGCTL', pointer($0028));
  MessageNames.AddObject('WM_SPOOLERSTATUS', pointer($002A));
  MessageNames.AddObject('WM_DRAWITEM', pointer($002B));
  MessageNames.AddObject('WM_MEASUREITEM', pointer($002C));
  MessageNames.AddObject('WM_DELETEITEM', pointer($002D));
  MessageNames.AddObject('WM_VKEYTOITEM', pointer($002E));
  MessageNames.AddObject('WM_CHARTOITEM', pointer($002F));
  MessageNames.AddObject('WM_SETFONT', pointer($0030));
  MessageNames.AddObject('WM_GETFONT', pointer($0031));
  MessageNames.AddObject('WM_SETHOTKEY', pointer($0032));
  MessageNames.AddObject('WM_GETHOTKEY', pointer($0033));
  MessageNames.AddObject('WM_QUERYDRAGICON', pointer($0037));
  MessageNames.AddObject('WM_COMPAREITEM', pointer($0039));
  MessageNames.AddObject('WM_GETOBJECT', pointer($003D));
  MessageNames.AddObject('WM_COMPACTING', pointer($0041));
  MessageNames.AddObject('WM_COMMNOTIFY', pointer($0044));
  MessageNames.AddObject('WM_WINDOWPOSCHANGING', pointer($0046));
  MessageNames.AddObject('WM_WINDOWPOSCHANGED', pointer($0047));
  MessageNames.AddObject('WM_POWER', pointer($0048));
  MessageNames.AddObject('WM_COPYDATA', pointer($004A));
  MessageNames.AddObject('WM_CANCELJOURNAL', pointer($004B));
  MessageNames.AddObject('WM_NOTIFY', pointer($004E));
  MessageNames.AddObject('WM_INPUTLANGCHANGEREQUEST', pointer($0050));
  MessageNames.AddObject('WM_INPUTLANGCHANGE', pointer($0051));
  MessageNames.AddObject('WM_TCARD', pointer($0052));
  MessageNames.AddObject('WM_HELP', pointer($0053));
  MessageNames.AddObject('WM_USERCHANGED', pointer($0054));
  MessageNames.AddObject('WM_NOTIFYFORMAT', pointer($0055));
  MessageNames.AddObject('WM_CONTEXTMENU', pointer($007B));
  MessageNames.AddObject('WM_STYLECHANGING', pointer($007C));
  MessageNames.AddObject('WM_STYLECHANGED', pointer($007D));
  MessageNames.AddObject('WM_DISPLAYCHANGE', pointer($007E));
  MessageNames.AddObject('WM_GETICON', pointer($007F));
  MessageNames.AddObject('WM_SETICON', pointer($0080));
  MessageNames.AddObject('WM_NCCREATE', pointer($0081));
  MessageNames.AddObject('WM_NCDESTROY', pointer($0082));
  MessageNames.AddObject('WM_NCCALCSIZE', pointer($0083));
  MessageNames.AddObject('WM_NCHITTEST', pointer($0084));
  MessageNames.AddObject('WM_NCPAINT', pointer($0085));
  MessageNames.AddObject('WM_NCACTIVATE', pointer($0086));
  MessageNames.AddObject('WM_GETDLGCODE', pointer($0087));
  MessageNames.AddObject('WM_NCMOUSEMOVE', pointer($00A0));
  MessageNames.AddObject('WM_NCLBUTTONDOWN', pointer($00A1));
  MessageNames.AddObject('WM_NCLBUTTONUP', pointer($00A2));
  MessageNames.AddObject('WM_NCLBUTTONDBLCLK', pointer($00A3));
  MessageNames.AddObject('WM_NCRBUTTONDOWN', pointer($00A4));
  MessageNames.AddObject('WM_NCRBUTTONUP', pointer($00A5));
  MessageNames.AddObject('WM_NCRBUTTONDBLCLK', pointer($00A6));
  MessageNames.AddObject('WM_NCMBUTTONDOWN', pointer($00A7));
  MessageNames.AddObject('WM_NCMBUTTONUP', pointer($00A8));
  MessageNames.AddObject('WM_NCMBUTTONDBLCLK', pointer($00A9));
  MessageNames.AddObject('WM_NCXBUTTONDOWN', pointer($00AB));
  MessageNames.AddObject('WM_NCXBUTTONUP', pointer($00AC));
  MessageNames.AddObject('WM_NCXBUTTONDBLCLK', pointer($00AD));
  MessageNames.AddObject('WM_INPUT', pointer($00FF));
  MessageNames.AddObject('WM_KEYFIRST', pointer($0100));
  MessageNames.AddObject('WM_KEYDOWN', pointer($0100));
  MessageNames.AddObject('WM_KEYUP', pointer($0101));
  MessageNames.AddObject('WM_CHAR', pointer($0102));
  MessageNames.AddObject('WM_DEADCHAR', pointer($0103));
  MessageNames.AddObject('WM_SYSKEYDOWN', pointer($0104));
  MessageNames.AddObject('WM_SYSKEYUP', pointer($0105));
  MessageNames.AddObject('WM_SYSCHAR', pointer($0106));
  MessageNames.AddObject('WM_SYSDEADCHAR', pointer($0107));
  MessageNames.AddObject('WM_UNICHAR', pointer($0109));
  MessageNames.AddObject('WM_KEYLAST', pointer($0109));
  MessageNames.AddObject('WM_INITDIALOG', pointer($0110));
  MessageNames.AddObject('WM_COMMAND', pointer($0111));
  MessageNames.AddObject('WM_SYSCOMMAND', pointer($0112));
  MessageNames.AddObject('WM_TIMER', pointer($0113));
  MessageNames.AddObject('WM_HSCROLL', pointer($0114));
  MessageNames.AddObject('WM_VSCROLL', pointer($0115));
  MessageNames.AddObject('WM_INITMENU', pointer($0116));
  MessageNames.AddObject('WM_INITMENUPOPUP', pointer($0117));
  MessageNames.AddObject('WM_MENUSELECT', pointer($011F));
  MessageNames.AddObject('WM_MENUCHAR', pointer($0120));
  MessageNames.AddObject('WM_ENTERIDLE', pointer($0121));
  MessageNames.AddObject('WM_MENURBUTTONUP', pointer($0122));
  MessageNames.AddObject('WM_MENUDRAG', pointer($0123));
  MessageNames.AddObject('WM_MENUGETOBJECT', pointer($0124));
  MessageNames.AddObject('WM_UNINITMENUPOPUP', pointer($0125));
  MessageNames.AddObject('WM_MENUCOMMAND', pointer($0126));
  MessageNames.AddObject('WM_CHANGEUISTATE', pointer($0127));
  MessageNames.AddObject('WM_UPDATEUISTATE', pointer($0128));
  MessageNames.AddObject('WM_QUERYUISTATE', pointer($0129));
  MessageNames.AddObject('WM_CTLCOLORMSGBOX', pointer($0132));
  MessageNames.AddObject('WM_CTLCOLOREDIT', pointer($0133));
  MessageNames.AddObject('WM_CTLCOLORLISTBOX', pointer($0134));
  MessageNames.AddObject('WM_CTLCOLORBTN', pointer($0135));
  MessageNames.AddObject('WM_CTLCOLORDLG', pointer($0136));
  MessageNames.AddObject('WM_CTLCOLORSCROLLBAR', pointer($0137));
  MessageNames.AddObject('WM_CTLCOLORSTATIC', pointer($0138));
  MessageNames.AddObject('WM_MOUSEFIRST', pointer($0200));
  MessageNames.AddObject('WM_MOUSEMOVE', pointer($0200));
  MessageNames.AddObject('WM_LBUTTONDOWN', pointer($0201));
  MessageNames.AddObject('WM_LBUTTONUP', pointer($0202));
  MessageNames.AddObject('WM_LBUTTONDBLCLK', pointer($0203));
  MessageNames.AddObject('WM_RBUTTONDOWN', pointer($0204));
  MessageNames.AddObject('WM_RBUTTONUP', pointer($0205));
  MessageNames.AddObject('WM_RBUTTONDBLCLK', pointer($0206));
  MessageNames.AddObject('WM_MBUTTONDOWN', pointer($0207));
  MessageNames.AddObject('WM_MBUTTONUP', pointer($0208));
  MessageNames.AddObject('WM_MBUTTONDBLCLK', pointer($0209));
  MessageNames.AddObject('WM_MOUSEWHEEL', pointer($020A));
  MessageNames.AddObject('WM_MOUSELAST', pointer($020A));
  MessageNames.AddObject('WM_PARENTNOTIFY', pointer($0210));
  MessageNames.AddObject('WM_ENTERMENULOOP', pointer($0211));
  MessageNames.AddObject('WM_EXITMENULOOP', pointer($0212));
  MessageNames.AddObject('WM_NEXTMENU', pointer($0213));
  MessageNames.AddObject('WM_SIZING', pointer( 532));
  MessageNames.AddObject('WM_CAPTURECHANGED', pointer( 533));
  MessageNames.AddObject('WM_MOVING', pointer( 534));
  MessageNames.AddObject('WM_POWERBROADCAST', pointer( 536));
  MessageNames.AddObject('WM_DEVICECHANGE', pointer( 537));
  MessageNames.AddObject('WM_IME_STARTCOMPOSITION', pointer($010D));
  MessageNames.AddObject('WM_IME_ENDCOMPOSITION', pointer($010E));
  MessageNames.AddObject('WM_IME_COMPOSITION', pointer($010F));
  MessageNames.AddObject('WM_IME_KEYLAST', pointer($010F));
  MessageNames.AddObject('WM_IME_SETCONTEXT', pointer($0281));
  MessageNames.AddObject('WM_IME_NOTIFY', pointer($0282));
  MessageNames.AddObject('WM_IME_CONTROL', pointer($0283));
  MessageNames.AddObject('WM_IME_COMPOSITIONFULL', pointer($0284));
  MessageNames.AddObject('WM_IME_SELECT', pointer($0285));
  MessageNames.AddObject('WM_IME_CHAR', pointer($0286));
  MessageNames.AddObject('WM_IME_REQUEST', pointer($0288));
  MessageNames.AddObject('WM_IME_KEYDOWN', pointer($0290));
  MessageNames.AddObject('WM_IME_KEYUP', pointer($0291));
  MessageNames.AddObject('WM_MDICREATE', pointer($0220));
  MessageNames.AddObject('WM_MDIDESTROY', pointer($0221));
  MessageNames.AddObject('WM_MDIACTIVATE', pointer($0222));
  MessageNames.AddObject('WM_MDIRESTORE', pointer($0223));
  MessageNames.AddObject('WM_MDINEXT', pointer($0224));
  MessageNames.AddObject('WM_MDIMAXIMIZE', pointer($0225));
  MessageNames.AddObject('WM_MDITILE', pointer($0226));
  MessageNames.AddObject('WM_MDICASCADE', pointer($0227));
  MessageNames.AddObject('WM_MDIICONARRANGE', pointer($0228));
  MessageNames.AddObject('WM_MDIGETACTIVE', pointer($0229));
  MessageNames.AddObject('WM_MDISETMENU', pointer($0230));
  MessageNames.AddObject('WM_ENTERSIZEMOVE', pointer($0231));
  MessageNames.AddObject('WM_EXITSIZEMOVE', pointer($0232));
  MessageNames.AddObject('WM_DROPFILES', pointer($0233));
  MessageNames.AddObject('WM_MDIREFRESHMENU', pointer($0234));
  MessageNames.AddObject('WM_MOUSEHOVER', pointer($02A1));
  MessageNames.AddObject('WM_MOUSELEAVE', pointer($02A3));
  MessageNames.AddObject('WM_NCMOUSEHOVER', pointer($02A0));
  MessageNames.AddObject('WM_NCMOUSELEAVE', pointer($02A2));
  MessageNames.AddObject('WM_WTSSESSION_CHANGE', pointer($02B1));
  MessageNames.AddObject('WM_TABLET_FIRST', pointer($02C0));
  MessageNames.AddObject('WM_TABLET_LAST', pointer($02DF));
  MessageNames.AddObject('WM_CUT', pointer($0300));
  MessageNames.AddObject('WM_COPY', pointer($0301));
  MessageNames.AddObject('WM_PASTE', pointer($0302));
  MessageNames.AddObject('WM_CLEAR', pointer($0303));
  MessageNames.AddObject('WM_UNDO', pointer($0304));
  MessageNames.AddObject('WM_RENDERFORMAT', pointer($0305));
  MessageNames.AddObject('WM_RENDERALLFORMATS', pointer($0306));
  MessageNames.AddObject('WM_DESTROYCLIPBOARD', pointer($0307));
  MessageNames.AddObject('WM_DRAWCLIPBOARD', pointer($0308));
  MessageNames.AddObject('WM_PAINTCLIPBOARD', pointer($0309));
  MessageNames.AddObject('WM_VSCROLLCLIPBOARD', pointer($030A));
  MessageNames.AddObject('WM_SIZECLIPBOARD', pointer($030B));
  MessageNames.AddObject('WM_ASKCBFORMATNAME', pointer($030C));
  MessageNames.AddObject('WM_CHANGECBCHAIN', pointer($030D));
  MessageNames.AddObject('WM_HSCROLLCLIPBOARD', pointer($030E));
  MessageNames.AddObject('WM_QUERYNEWPALETTE', pointer($030F));
  MessageNames.AddObject('WM_PALETTEISCHANGING', pointer($0310));
  MessageNames.AddObject('WM_PALETTECHANGED', pointer($0311));
  MessageNames.AddObject('WM_HOTKEY', pointer($0312));
  MessageNames.AddObject('WM_PRINT', pointer( 791));
  MessageNames.AddObject('WM_PRINTCLIENT', pointer( 792));
  MessageNames.AddObject('WM_APPCOMMAND', pointer($0319));
  MessageNames.AddObject('WM_THEMECHANGED', pointer($031A));
  MessageNames.AddObject('WM_HANDHELDFIRST', pointer( 856));
  MessageNames.AddObject('WM_HANDHELDLAST', pointer( 863));
  MessageNames.AddObject('WM_PENWINFIRST', pointer($0380));
  MessageNames.AddObject('WM_PENWINLAST', pointer($038F));
  MessageNames.AddObject('WM_COALESCE_FIRST', pointer($0390));
  MessageNames.AddObject('WM_COALESCE_LAST', pointer($039F));
  MessageNames.AddObject('WM_DDE_FIRST', pointer($03E0));
  MessageNames.AddObject('WM_DDE_INITIATE', pointer($03E0));
  MessageNames.AddObject('WM_DDE_TERMINATE', pointer($03E1));
  MessageNames.AddObject('WM_DDE_ADVISE', pointer($03E2));
  MessageNames.AddObject('WM_DDE_UNADVISE', pointer($03E3));
  MessageNames.AddObject('WM_DDE_ACK', pointer($03E4));
  MessageNames.AddObject('WM_DDE_DATA', pointer($03E5));
  MessageNames.AddObject('WM_DDE_REQUEST', pointer($03E6));
  MessageNames.AddObject('WM_DDE_POKE', pointer($03E7));
  MessageNames.AddObject('WM_DDE_EXECUTE', pointer($03E8));
  MessageNames.AddObject('WM_DDE_LAST', pointer($03E8));
  MessageNames.AddObject('WM_APP', pointer($8000));
  MessageNames.AddObject('WM_USER', pointer($0400));
end;

end.
