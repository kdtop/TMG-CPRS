unit fClientRPCLogger;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Clipbrd, Menus, uRpcLogEntry;

type
  TfrmRpcClientLogger = class(TForm)
    cbxEnableRPCLogging: TCheckBox;
    lblMaxRPCEntries: TLabel;
    UpDown1: TUpDown;
    maxRpcLogEntriesNumericUpDown: TEdit;
    rpcLogListBox: TListBox;
    Panel1: TPanel;
    lblRPCName: TLabel;
    lblRPCDebugID: TLabel;
    lblClientName: TLabel;
    lblClientDebugID: TLabel;
    lblContext: TLabel;
    lblDuration: TLabel;
    edtRPCName: TEdit;
    edtRPCDebugID: TEdit;
    edtClientName: TEdit;
    edtClientDebugID: TEdit;
    edtContext: TEdit;
    edtDuration1: TEdit;
    lblParams: TLabel;
    lblResults: TLabel;
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    File1: TMenuItem;
    mnuFileClose: TMenuItem;
    Edit1: TMenuItem;
    HGelp1: TMenuItem;
    mnuHelpAbout: TMenuItem;
    mnuEditCopyToClipboard: TMenuItem;
    mnuPopupCopyToClipboard: TMenuItem;
    ParamsMemoBox: TRichEdit;
    ResultsMemoBox: TRichEdit;
    Edit2: TEdit;
    btnClose: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure mnuEditCopyToClipboardClick(Sender: TObject);
    procedure rpcLogListBoxClick(Sender: TObject);
    procedure mnuPopupCopyToClipboardClick(Sender: TObject);
    procedure mnuFileCloseClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DisplayRpcEntry(entry: TRpcLogEntry);
    procedure AddRpcLogEntry(entry: TRPCLogEntry; overrideCheckBox: Boolean);
  end;

var
  frmRpcClientLogger: TfrmRpcClientLogger;

implementation

{$R *.DFM}

procedure TfrmRpcClientLogger.AddRpcLogEntry(entry: TRPCLogEntry; overrideCheckBox: Boolean);
var
  Str, Str1: String;
  Max: Integer;
begin
  if (cbxEnableRPCLogging.Checked or overrideCheckBox) then
  begin
    // If the list is full we need to delete the 0th item till we have room for one.
    while (rpcLogListBox.Items.Count >= StrToInt(maxRpcLogEntriesNumericUpDown.Text)) do
      rpcLogListBox.Items.Delete(0);
    with entry do
    begin
      Max := 30;
      if Length(Name) > 30 then
        Max := Length(Name);
      Str := Copy(Name+'                                                   ',1,Max);
      Str1 := '      '+IntToStr(Duration);
      Str := Str + '   cId: '+IntToStr(UniqueClientId)+'  time ='+Copy(Str1,Length(Str1)-5,Length(Str1))+' ms   rpcId: '+IntToStr(UniqueId)+'   '+ClientName;
    end;    // with
    rpcLogListBox.Items.AddObject(Str, entry);
  end;
end;

    procedure TfrmRpcClientLogger.FormClose(Sender: TObject; var Action: TCloseAction);
    begin
      //
    end;
    procedure TfrmRpcClientLogger.UpDown1Click(Sender: TObject; Button: TUDBtnType);
    begin
      //
    end;

procedure TfrmRpcClientLogger.mnuEditCopyToClipboardClick(Sender: TObject);
begin
  if RpcLogListBox.ItemIndex > -1 then
    mnuPopupCopyToClipboardClick(Self);
end;
procedure TfrmRpcClientLogger.rpcLogListBoxClick(Sender: TObject);
begin
  DisplayRpcEntry(TRpcLogEntry(rpcLogListBox.Items.Objects[rpcLogListBox.ItemIndex]));
  mnuEditCopyToClipboard.Enabled := True;
end;

procedure TfrmRpcClientLogger.mnuPopupCopyToClipboardClick(Sender: TObject);
var
  RPCEntry: TRpcLogEntry;
begin
  RPCEntry := TRpcLogEntry(RpcLogListBox.Items.Objects[RpcLogListBox.ItemIndex]);
  Edit2.Text := RPCEntry.CreateClipBoardString;
  Edit2.SelectAll;
  Edit2.CopyToClipBoard;
end;
    


//    private void rpcLogListBox_SelectedIndexChanged(object sender, System.EventArgs e)

procedure TfrmRpcClientLogger.DisplayRpcEntry(entry: TRpcLogEntry);
var
  Str : String;
begin
  Str := entry.CreateParamsDisplayString; //.Split('\n');
  ParamsMemoBox.Lines.Clear;
  ParamsMemoBox.Lines.Add(Str);

  resultsMemoBox.Text      := entry.CreateResultsDisplayString();
  edtRpcName.Text      := entry.Name;
  edtRPCDebugId.Text    := IntToStr(entry.UniqueId);
  edtContext.Text      := entry.Context;
  if(entry.Duration < 1) then
    edtDuration1.Text := '<1ms'
  else
    edtDuration1.Text := IntToStr(entry.Duration) + ' ms';
  edtClientName.Text    := entry.ClientName;
  edtClientDebugId.Text  := IntToStr(entry.UniqueClientId);
end;

{
procedure TfrmRpcClientLogger.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
      OnRpcLoggerClose(Self,nil);
end;

procedure TfrmRpcClientLogger.UpDown1Click(Sender: TObject;
  Button: TUDBtnType);
begin
      // In case the max entry value is less than the rpc log entries delete the entries
      while (StrToInt(maxRpcLogEntriesNumericUpDown.Text) < rpcLogListBox.Items.Count)
        rpcLogListBox.Items.Delete(0);
end;

procedure TfrmRpcClientLogger.mnuEditCopyToClipboardClick(Sender: TObject);
var
  Clip: TClipBoard;
begin
      // Build a string and put it on the clipboard here.
//      Clipboard.SetDataObject(((RpcLogEntry)rpcLogListBox.SelectedItem).CreateClipboardString());
  Clip ::= ClipBoard;
  Clip.SetTextBuf(PChar((RpcLogEntry)(rpcLogListBox.Items[rpcLogListBox.ItemIndex]).CreateClipboardString));
end;

procedure TfrmRpcClientLogger.rpcLogListBoxClick(Sender: TObject);
begin
  DisplayRpcEntry((RpcLogEntry)rpcLogListBox.Items[rpcLogListBox.SelectedIndex]);
  mnuEditCopyToClipboard.Enabled := True;
end;

procedure TfrmRpcClientLogger.mnuPopupCopyToClipboardClick(
  Sender: TObject);
begin
  mnuEditCopyToClipboardClick(Sender);
end;
}
procedure TfrmRpcClientLogger.mnuFileCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

procedure TfrmRpcClientLogger.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

end.
