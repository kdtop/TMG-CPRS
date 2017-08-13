unit fAlertSender;
//kt added entire form, copied and modified from fAlertForward

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Forms, Controls,
  Dialogs, StdCtrls, Buttons, ORCtrls, ORfn, ExtCtrls, fAutoSz, ComCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TAlertSendingFn = function(Recipients : TStringList; Info1 : string; Info2 : string = ''; Level : string = '') : string;
  TfrmAlertSender = class(TfrmBase508Form)
    cmdOK: TButton;
    cmdCancel: TButton;
    cboSrcList: TORComboBox;
    DstList: TORListBox;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    pnlBase: TORAutoPanel;
    btnAddAlert: TButton;
    btnRemoveAlertFwrd: TButton;
    btnRemoveAllAlertFwrd: TButton;
    cboAlertLevel: TORComboBox;
    procedure btnRemoveAlertFwrdClick(Sender: TObject);
    procedure btnAddAlertClick(Sender: TObject);
    procedure cboSrcListNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboSrcListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboSrcListMouseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboSrcListChange(Sender: TObject);
    procedure DstListChange(Sender: TObject);
    procedure btnRemoveAllAlertFwrdClick(Sender: TObject);
  private
    RemovingAll: boolean;
    FAlertSendingFn : TAlertSendingFn;
    FInfo1, FInfo2 : string;
    procedure SetOKEnable;
  public
    AlertResult : string;
    procedure Initialize(AlertSendingFn : TAlertSendingFn; Info1 : string = ''; Info2 : string = ''; AlertLevels : TStringList = nil);
  end;


//function ForwardAlertTo(Alert: String): Boolean;


implementation

{$R *.DFM}

uses rCore, uCore, VA508AccessibilityRouter;

const
    TX_DUP_RECIP = 'You have already selected that recipient.';
    TX_RECIP_CAP = 'Error adding recipient';

procedure TfrmAlertSender.FormCreate(Sender: TObject);
begin
  inherited;
  FAlertSendingFn := nil;
  AlertResult := '-1^Alerts not sent';
  //cboSrcList.InitLongList('');  //moved to initialize
end;

procedure TfrmAlertSender.Initialize(AlertSendingFn : TAlertSendingFn; Info1 : string = ''; Info2 : string = ''; AlertLevels : TStringList = nil);
begin
  FAlertSendingFn := AlertSendingFn;
  FInfo1 := Info1;
  FInfo2 := Info2;
  cboSrcList.InitLongList('');
  cboAlertLevel.Visible := Assigned(AlertLevels) and (AlertLevels.Count > 0);
  if cboAlertLevel.Visible then begin
    cboAlertLevel.Items.Assign(AlertLevels);
    if cboAlertLevel.Items.Count > 0 then cboAlertLevel.ItemIndex := 0;
  end;
  SetOKEnable;
end;

procedure TfrmAlertSender.SetOKEnable;
begin
  cmdOK.Enabled := (DstList.Items.Count > 0)
end;


procedure TfrmAlertSender.cmdOKClick(Sender: TObject);
var
  i: integer ;
  Recip: string;
  Recipients : TStringList;
  Level : string;
begin
  Recipients := TStringList.Create;
  try
    for i := 0 to DstList.Items.Count-1 do begin
      Recip := Piece(DstList.Items[i], U, 1);
      Recipients.Add(Recip);
    end;
    Level := cboAlertLevel.ItemID;
    if assigned(FAlertSendingFn) then begin
      AlertResult := FAlertSendingFn(Recipients, FInfo1, FInfo2, Level);
    end;
  finally
    Recipients.Free;
  end;
  Self.ModalResult := mrOK;  //<-- closes form
end;

procedure TfrmAlertSender.cboSrcListNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmAlertSender.cmdCancelClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;    //<-- closes form
end;

procedure TfrmAlertSender.DstListChange(Sender: TObject);
var
  HasFocus: boolean;
begin
  inherited;
  if DstList.SelCount = 1 then
    if Piece(DstList.Items[0], '^', 1) = '' then
    begin
      btnRemoveAlertFwrd.Enabled := false;
      btnRemoveAllAlertFwrd.Enabled := false;
      exit;
    end;
  HasFocus := btnRemoveAlertFwrd.Focused;
  if Not HasFocus then
    HasFocus := btnRemoveAllAlertFwrd.Focused;
  btnRemoveAlertFwrd.Enabled := DstList.SelCount > 0;
  btnRemoveAllAlertFwrd.Enabled := DstList.Items.Count > 0;
  if HasFocus and (DstList.SelCount = 0) then
    btnAddAlert.SetFocus;
end;

procedure TfrmAlertSender.btnAddAlertClick(Sender: TObject);
begin
  inherited;
  cboSrcListMouseClick(btnAddAlert);
end;

procedure TfrmAlertSender.btnRemoveAlertFwrdClick(Sender: TObject);
var
  i: integer;
begin
  with DstList do begin
    if ItemIndex = -1 then exit ;
    for i := Items.Count-1 downto 0 do begin
      if Selected[i] then begin
        if ScreenReaderSystemActive and (not RemovingAll) then begin
          GetScreenReader.Speak(Piece(DstList.Items[i],U,2) +
          ' Removed from ' + DstLabel.Caption);
        end;
        Items.Delete(i) ;
      end;
    end;
  end;
  SetOKEnable;
end;

procedure TfrmAlertSender.btnRemoveAllAlertFwrdClick(Sender: TObject);
begin
  inherited;
  DstList.SelectAll;
  RemovingAll := TRUE;
  try
    btnRemoveAlertFwrdClick(self);
    if ScreenReaderSystemActive then
      GetScreenReader.Speak(DstLabel.Caption + ' Cleared');
  finally
    RemovingAll := FALSE;
    SetOKEnable;
  end;
end;

procedure TfrmAlertSender.cboSrcListChange(Sender: TObject);
begin
  inherited;
  btnAddAlert.Enabled := CboSrcList.ItemIndex > -1;
end;

procedure TfrmAlertSender.cboSrcListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    cboSrcListMouseClick(Self);
  end;
end;

procedure TfrmAlertSender.cboSrcListMouseClick(Sender: TObject);
begin
  SetOKEnable;
  if cboSrcList.ItemIndex = -1 then exit;
  if (DstList.SelectByID(cboSrcList.ItemID) <> -1) then begin
    InfoBox(TX_DUP_RECIP, TX_RECIP_CAP, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  DstList.Items.Add(cboSrcList.Items[cboSrcList.Itemindex]);
  if ScreenReaderSystemActive then begin
    GetScreenReader.Speak(Piece(cboSrcList.Items[cboSrcList.Itemindex],U,2) +
      ' Added to ' + DstLabel.Caption);
  end;
  btnRemoveAlertFwrd.Enabled := DstList.SelCount > 0;
  btnRemoveAllAlertFwrd.Enabled := DstList.Items.Count > 0;
  SetOKEnable;
end;

end.
