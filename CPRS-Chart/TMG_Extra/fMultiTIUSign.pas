unit fMultiTIUSign;

//kt Added entire form 9/2020

interface

uses
  Windows, Messages, SysUtils, DateUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, rCore, fFrame, fAddlSigners, Math,fImagePatientPhotoID,
  TMGHTML2, StdCtrls, Buttons, ORCtrls, ORNet, ExtCtrls, OleCtrls, SHDocVw;

type
  TItemInfo = class(TObject)
  public
    DFN : string;
    PtName : string;
    AlertMsg : string;
    IEN8925 : string;
    intIEN8925 : int64;
    XQAID : string;
    FollowupNum : string;
    PtRecLoaded : boolean;
    PtRec: TPtIDInfo;
    LocalHTMLFile : string;
    Signed : boolean;
    PromptToLinkToConsult : boolean;
    DeferredConsultItemIEN : integer;
    DeferredConsultCompletionDesired : boolean;
    ProcessDeferredConsultAfterSignature : boolean;
    PromptForAdditionalSigners : boolean;
    ProcessDeferredAdditonalSigners : boolean;
    DeferredAdditionalSignersList : TSignerList;
    DeferredSigAction : integer;
    FailMsg : TStringList; //note: default is to be nil.  Only instantiated if problem encountered.
    procedure AddErrMsg(msg : string);
    constructor Create();
    destructor Destroy();
  end;

  TfrmMultiTIUSign = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlLeft: TPanel;
    Splitter1: TSplitter;
    pnlCenter: TPanel;
    Splitter2: TSplitter;
    pnlRight: TPanel;
    pnlRightCenter: TPanel;
    pnlRightBottom: TPanel;
    pnlHTMLEdit: TPanel;
    pnlCenterBottom: TPanel;
    btnPrev: TBitBtn;
    btnAddToSign: TBitBtn;
    btnNext: TBitBtn;
    btnRemove: TBitBtn;
    btnSignAll: TBitBtn;
    pnlRightTop: TPanel;
    lblSignList: TLabel;
    btnCancel: TBitBtn;
    lbUnSelected: TListBox;
    pnlCenterTop: TPanel;
    lblPatientInfo: TLabel;
    lbSelected: TListBox;
    pnlLeftTop: TPanel;
    lblAlerts: TLabel;
    WebBrowser: TWebBrowser;
    pnlPatientID: TPanel;
    btnEditZoomOut: TSpeedButton;
    btnEditNormalZoom: TSpeedButton;
    btnEditZoomIn: TSpeedButton;
    PatientImage: TImage;
    procedure PatientImageMouseLeave(Sender: TObject);
    procedure PatientImageMouseEnter(Sender: TObject);
    procedure btnEditZoomInClick(Sender: TObject);
    procedure btnEditNormalZoomClick(Sender: TObject);
    procedure btnEditZoomOutClick(Sender: TObject);
    procedure btnSignAllClick(Sender: TObject);
    procedure lbSelectedClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure lbUnSelectedClick(Sender: TObject);
    procedure btnAddToSignClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ItemInfoList : TList; //will own objects.  Will hold TItemInfo objects
    ESCode : string;
    FZoomValue : integer;
    FZoomStep : integer;  //e.g. 5% change with each zoom in
    ColLeftWidth, ColCenterWidth, ColRightWidth : integer;
    frmPatientPhotoID : TfrmPatientPhotoID;
    Procedure Initialize(Items : TListItems);
    procedure SetupInfoList(Items : TListItems);
    procedure LoadNoteForView(ItemInfo : TItemInfo);
    function PatientDisplayName(ItemInfo : TItemInfo) : string;
    procedure UpdateButtonEnableStates;
    procedure MoveItemBetweenLists(j : integer; CurLB, TargetLB : TListBox);
    procedure DisplayFromList(LB : TListBox);
    function UniqueFilename(FolderPath : string; FileSuffix : string) : string;
    function SignOne(ItemInfo : TItemInfo; ESCode : string) : boolean;  //result TRUE if successful sign.
    function AllowSignature(ItemInfo : TItemInfo): Boolean;
    function SelectedItemInfoFromLB(LB : TListBox) : TItemInfo;
    procedure IdentifyAdditionalSigners(ItemInfo : TItemInfo);
    procedure SetZoom(Pct : integer);
    procedure ZoomReset;
    procedure ZoomIn;
    procedure ZoomOut;

  public
    { Public declarations }

  end;


function ShowMultiAlertsSign(Items : TListItems) : boolean;


implementation

{$R *.dfm}

uses VAUtils, ORFn, uConst, StrUtils, fSignItem,
     uTIU, rTIU, uHTMLTools, fConsultLink;

//===========================================================
//===========================================================


function ShowMultiAlertsSign(Items : TListItems) : boolean;
//Result: True if some documents were signed (i.e. refresh of alerts will be needed)
//NOTE: AllItems contents should NOT BE MODIFIED!  They are owned and managed by sender.
var
  frmMultiTIUSign: TfrmMultiTIUSign;
begin
  result := false;
  frmMultiTIUSign := TfrmMultiTIUSign.Create(Application);
  try
    frmMultiTIUSign.Initialize(Items);
    if frmMultiTIUSign.ShowModal = mrOK then begin
      result := true;
    end;
  finally
    frmMultiTIUSign.Free;
  end;
end;

//===========================================================
//===========================================================

//=======================================

constructor TItemInfo.Create();
begin
  inherited;
  Signed := false;
  PromptToLinkToConsult := false;
  PromptForAdditionalSigners := false;
  ProcessDeferredConsultAfterSignature := false;
  FailMsg := nil;
end;

destructor TItemInfo.Destroy();
begin
  DeleteFile(self.LocalHTMLFile);
  DeferredAdditionalSignersList.Signers.Free;
  if assigned(self.FailMsg) then FailMsg.Free;
  inherited;
end;

procedure TItemInfo.AddErrMsg(msg : string);
begin
  if not assigned(FailMsg) then FailMsg := TStringList.Create;
  FailMsg.Add(msg);
end;


//===========================================================

procedure TfrmMultiTIUSign.FormCreate(Sender: TObject);
begin
  ItemInfoList := TList.create();
  FZoomValue := 100;  //100%
  FZoomStep := 20;  //e.g. 5% change with each zoom in
end;

procedure TfrmMultiTIUSign.FormDestroy(Sender: TObject);
var i : integer;
begin
  for i := 0 to ItemInfoList.Count - 1 do begin
    TItemInfo(ItemInfoList[i]).Free;  //destructor will free up files, objects etc.
  end;
  ItemInfoList.Free;
end;

procedure TfrmMultiTIUSign.FormShow(Sender: TObject);
begin
  if lbUnSelected.Items.Count > 0 then begin
    lbUnSelected.ItemIndex := 0;
    lbUnSelectedClick(self);
  end;
  UpdateButtonEnableStates;
end;

procedure TfrmMultiTIUSign.Initialize(Items : TListItems);
//NOTE: Items contents should NOT BE MODIFIED!  They are owned and managed by sender.
var
  i : integer;
  ItemInfo : TItemInfo;
begin
  SetupInfoList(Items);
  for i := 0 to ItemInfoList.Count - 1 do begin
    ItemInfo := TItemInfo(ItemInfoList[i]);
    lbUnselected.Items.AddObject(ItemInfo.PtName + '  ' + ItemInfo.AlertMsg, Pointer(i));
  end;
end;

procedure TfrmMultiTIUSign.SetupInfoList(Items : TListItems);
//NOTE: Items contents should NOT BE MODIFIED!  They are owned and managed by sender.
var
  i : integer;
  XQAID, x : string;
  tempS : string;
  ItemInfo : TItemInfo;

begin
  //Filter out entries that are not documents to be signed
  for i := 0 to Items.Count - 1 do begin
    { Items[i].Selected    =  Boolean TRUE if item is selected
          "   .Caption     =  Info flag ('I')
          "   .SubItems[0] =  Patient ('ABC,PATIE (A4321)')
          "   .    "   [1] =  Patient location ('[2B]')
          "   .    "   [2] =  Alert urgency level ('HIGH, Moderate, low')
          "   .    "   [3] =  Alert date/time ('2002/12/31@12:10')
          "   .    "   [4] =  Alert message ('New order(s) placed.')
          "   .    "   [5] =  Forwarded by/when
          "   .    "   [6] =  XQAID ('OR,66,50;1416;3021231.121024')
                                     'TIU6028;1423;3021203.09')
          "   .    "   [7] =  Remove without processing flag ('YES')
          "   .    "   [8] =  Forwarding comments (if applicable) }
    if Items[i].Caption = 'I' then continue;   //information only alert.
    XQAID := Items[i].SubItems[6];
    if Copy(XQAID, 1, 3) <> 'TIU' then continue;   //e.g. TIU6028;1423;3021203.09
    x := GetTIUAlertInfo(XQAID);    //658502^11514^903
    if Piece(x, U, 2) = '' then continue;

    ItemInfo := TItemInfo.Create; //owned by ItemInfoList
    tempS := piece(XQAID,';',1);
    ItemInfo.IEN8925 := MidStr(tempS, 4, length(tempS));
    ItemInfo.intIEN8925 := StrToIntDef(ItemInfo.IEN8925, 0);
    ItemInfo.XQAID := XQAID;
    ItemInfo.DFN := Piece(x, U, 2);  //*DFN*
    ItemInfo.FollowupNum := Piece(Piece(x, U, 3), ';', 1);  //Matches Notification types in uConst, e.g. NF_NOTES_UNSIGNED_NOTE
    ItemInfo.AlertMsg := Items[i].SubItems[4];
    ItemInfo.PtName := Items[i].SubItems[0];
    ItemInfo.PromptToLinkToConsult := (GetTMGPSCode(ItemInfo.intIEN8925) = 'C');
    ItemInfo.PromptForAdditionalSigners := DisplayCosignerDialog(ItemInfo.intIEN8925);
    ItemInfoList.Add(ItemInfo);
  end;
end;


procedure TfrmMultiTIUSign.btnAddToSignClick(Sender: TObject);
var j : integer;
    ItemInfo : TItemInfo;
    Success : boolean;
begin
  ItemInfo := SelectedItemInfoFromLB(lbUnSelected);
  if not assigned(ItemInfo) then exit;

  if ItemInfo.PromptToLinkToConsult then begin
    Success := DeferLinkConsult(ItemInfo.intIEN8925, ItemInfo.DFN,
                                ItemInfo.DeferredConsultItemIEN,
                                ItemInfo.DeferredConsultCompletionDesired);
    ItemInfo.ProcessDeferredConsultAfterSignature := Success;
  end;

  if ItemInfo.PromptForAdditionalSigners then
    IdentifyAdditionalSigners(ItemInfo);

  j := lbUnSelected.ItemIndex;
  MoveItemBetweenLists(j, lbUnSelected, lbSelected);
  while j >= lbUnSelected.Count do dec(j);
  lbUnSelected.ItemIndex := j;
  lbUnSelectedClick(Sender);
  UpdateButtonEnableStates;  
end;


procedure TfrmMultiTIUSign.IdentifyAdditionalSigners(ItemInfo : TItemInfo);
//Copied and modified from TfrmNotes.IdentifyAddlSigners(NoteIEN : int64; ARefDate: TFMDateTime);
var
  Exclusions: TStrings;   //this will be mirror of RPCBrokerV.Results
  x, y: boolean;
  ActionSts: TActionRec;
  ARefDate: TFMDateTime;
  Success : boolean;
  SignerList : TSignerList;  //alias

begin
  x := CanChangeCosigner(ItemInfo.intIEN8925);
  ActOnDocument(ActionSts, ItemInfo.intIEN8925, 'IDENTIFY SIGNERS');
  y := ActionSts.Success;
  if x and not y then begin
    ItemInfo.AddErrMsg('Changing cosigner not supported');
    exit;
  end else if y and not x then begin
    ItemInfo.DeferredSigAction := SG_ADDITIONAL
  end else if x and y then begin
    ItemInfo.DeferredSigAction := SG_BOTH
  end else begin
    ItemInfo.AddErrMsg(ActionSts.Reason);
    ItemInfo.DeferredSigAction := 0;
    Exit;
  end;

  Exclusions := GetCurrentSigners(ItemInfo.intIEN8925);  //Exclusions is mirror of RPCBrokerV.Results
  ARefDate := 0;  //not used in this case...
  SignerList := ItemInfo.DeferredAdditionalSignersList;
  SelectAdditionalSigners(Font.Size, ItemInfo.intIEN8925, ItemInfo.DeferredSigAction, Exclusions, SignerList, CT_NOTES, ARefDate);
  if assigned(SignerList.Signers) then Success := (SignerList.Signers.Count > 0) else Success := false;
  ItemInfo.ProcessDeferredAdditonalSigners := Success;

end;

procedure TfrmMultiTIUSign.btnRemoveClick(Sender: TObject);
var j : integer;
    ItemInfo : TItemInfo;
begin
  ItemInfo := SelectedItemInfoFromLB(lbSelected);
  if not assigned(ItemInfo) then exit;
  if ItemInfo.PromptToLinkToConsult then begin //clear any prior choice for linking to consult.
    ItemInfo.DeferredConsultItemIEN := 0;
    ItemInfo.DeferredConsultCompletionDesired := false;
    ItemInfo.ProcessDeferredConsultAfterSignature := false;
  end;
  j := lbSelected.ItemIndex;
  MoveItemBetweenLists(j, lbSelected, lbUnSelected);
  lbUnSelected.ItemIndex := lbUnSelected.Items.Count-1;
end;


procedure TfrmMultiTIUSign.MoveItemBetweenLists(j : integer; CurLB, TargetLB : TListBox);
var s : string;
    i : integer;
begin
  if j < 0 then exit;
  s := CurLB.Items.Strings[j];
  i := Integer(curLB.Items.Objects[j]);
  CurLB.Items.Delete(j);
  TargetLB.AddItem(s, pointer(i));
end;


procedure TfrmMultiTIUSign.btnCancelClick(Sender: TObject);
begin
 //TO DO, confirm if items are in selected list.
  Self.ModalResult := mrCancel;
  Close;
end;

procedure TfrmMultiTIUSign.btnEditNormalZoomClick(Sender: TObject);
begin
  //handle restore size
  ZoomReset;
end;

procedure TfrmMultiTIUSign.btnEditZoomInClick(Sender: TObject);
begin
  //handle enlarge size
  ZoomIn;
end;

procedure TfrmMultiTIUSign.btnEditZoomOutClick(Sender: TObject);
begin
  //handle shrink size
  ZoomOut;
end;

procedure TfrmMultiTIUSign.btnNextClick(Sender: TObject);
//NOTE: disabled unless next is possible.
begin
  lbUnSelected.ItemIndex := lbUnSelected.ItemIndex + 1;
  lbUnSelectedClick(Sender);
end;

procedure TfrmMultiTIUSign.btnPrevClick(Sender: TObject);
//NOTE: disabled unless prev is possible.
begin
  lbUnSelected.ItemIndex := lbUnSelected.ItemIndex - 1;
  lbUnSelectedClick(Sender);
end;


procedure TfrmMultiTIUSign.lbSelectedClick(Sender: TObject);
begin
  DisplayFromList(lbSelected);
  lbUnSelected.ItemIndex := -1;
  UpdateButtonEnableStates;
end;

procedure TfrmMultiTIUSign.lbUnSelectedClick(Sender : TObject);
begin
  DisplayFromList(lbUnSelected);
  lbSelected.ItemIndex := -1;
  UpdateButtonEnableStates;
end;

procedure TfrmMultiTIUSign.DisplayFromList(LB : TListBox);
var
  ItemInfo : TItemInfo;
begin
  ItemInfo := SelectedItemInfoFromLB(LB);
  if not assigned(ItemInfo) then exit;
  LoadNoteForView(ItemInfo);
  if not ItemInfo.PtRecLoaded then ItemInfo.PtRec  := GetPtIDInfo(ItemInfo.DFN);  //RPC call
  lblPatientInfo.Caption := PatientDisplayName(ItemInfo);
  PatientImage.Visible := true;
  LoadMostRecentPhotoIDThumbNail(ItemInfo.DFN,PatientImage.Picture.Bitmap);
  pnlPatientID.Color := ItemInfo.PtRec.DueColor;
  UpdateButtonEnableStates;
end;

function TfrmMultiTIUSign.SelectedItemInfoFromLB(LB : TListBox) : TItemInfo;
var
  i, DataIndex : integer;
begin
  Result := nil;  //default
  i := LB.ItemIndex;
  if i=-1 then exit;
  DataIndex := Integer(LB.Items.Objects[i]);
  if (DataIndex < 0) or (DataIndex >= ItemInfoList.Count) then exit;
  Result := TItemInfo(ItemInfoList[DataIndex]);
end;

function TfrmMultiTIUSign.PatientDisplayName(ItemInfo : TItemInfo) : string;
begin
  //Could enhance later
  Result := ItemInfo.PtRec.Name + ' (' + ItemInfo.PtRec.DOB + ')';
end;



procedure TfrmMultiTIUSign.PatientImageMouseEnter(Sender: TObject);
var refresh : boolean;
  ItemInfo : TItemInfo;
begin
  inherited;
  ItemInfo := SelectedItemInfoFromLB(lbUnSelected);
  if not assigned(ItemInfo) then exit;
  frmPatientPhotoID:= TfrmPatientPhotoID.Create(Self);
  frmPatientPhotoID.ShowPreviewMode(ItemInfo.DFN,Self.PatientImage,ltLeft);
end;


procedure TfrmMultiTIUSign.PatientImageMouseLeave(Sender: TObject);
begin
  inherited;
  if assigned(frmPatientPhotoID) then FreeAndNil(frmPatientPhotoID);

end;

procedure TfrmMultiTIUSign.LoadNoteForView(ItemInfo : TItemInfo);
//NOTE: code modified from TfrmNotes.lstNotesClick(Sender: TObject);
var
  Lines : TStringList;
begin
  Lines := TStringList.Create;
  try
    if ItemInfo.LocalHTMLFile = '' then begin

      StatusText('Retrieving selected progress note...');
      Screen.Cursor := crAppStart;
      LoadDocumentText(Lines, ItemInfo.intIEN8925);
      Screen.Cursor := crDefault;
      StatusText('');
      uHTMLTools.ScanForSubs(Lines);      //Ensure download of any media encountered
      //SetDisplayToHTMLvsText(Mode,FViewNote);         NOTE: I am only supporting HTML for now...
      uHTMLTools.FixHTML(Lines);
      ItemInfo.LocalHTMLFile := UniqueFilename(CPRSCacheDir, '.html');
      Lines.SaveToFile(ItemInfo.LocalHTMLFile);
    end;
    WebBrowser.Navigate(ItemInfo.LocalHTMLFile);
  finally
    Lines.Free;
  end;
end;

procedure TfrmMultiTIUSign.UpdateButtonEnableStates;
begin
  btnPrev.Enabled := (lbUnSelected.ItemIndex > 0);
  btnNext.Enabled := (lbUnSelected.ItemIndex < lbUnSelected.Items.Count-1);
  btnRemove.Enabled := (lbSelected.ItemIndex > 0);
  btnSignAll.Enabled := (lbSelected.Items.Count > 0);
end;


function TfrmMultiTIUSign.UniqueFilename(FolderPath : string; FileSuffix : string) : string;
//NOTE: FolderPath must end with "\"      e.g. 'c:\myfolder\dir1\'
//NOTE: FileSuffix must begin with "."    e.g. '.html'

const SECONDS_PER_DAY = 86400;
var MyThreadID, MyProcessID : cardinal;
    index : integer;
    SecsSinceMidnight: double;
    intSecSinceMN : int64;
    IndexStr : string;
begin
  MyThreadID := windows.GetCurrentThreadID;
  MyProcessID := windows.GetCurrentProcessID;
  SecsSinceMidnight := TimeOf(Now) * SecsPerDay;
  intSecSinceMN := round(SecsSinceMidnight);
  index := 0;
  IndexStr := '';
  repeat
    Result := FolderPath + IntToHex(MyThreadID,1) + '_' + IntToHex(MyProcessID,1) + '_' + IntToHex(intSecSinceMN, 1) + IndexStr + FileSuffix;
    inc(index);
    IndexStr := '_' + IntToStr(index);
  until not FileExists(Result);
end;

procedure TfrmMultiTIUSign.btnSignAllClick(Sender: TObject);
//handle the actual signing of the documents here...
var
  count, i : integer;
  Index: integer;
  ItemInfo : TItemInfo;
  AllOK : boolean;
  Success : boolean;
  SuccessCt : integer;

begin
  count := lbSelected.Items.Count;
  SignatureForItem(Font.Size, 'Enter Signature Code to Sign ' + IntToStr(count) + ' Notes', 'Sign Multiple Documents', ESCode);
  if length(ESCode)=0 then exit;
  AllOK := true;
  SuccessCt := 0;
  for i := lbSelected.Items.Count - 1 downto 0 do begin
    Index := Integer(lbSelected.Items.Objects[i]);
    ItemInfo := TItemInfo(ItemInfoList[Index]);
    Success := SignOne(ItemInfo, ESCode);
    AllOK := AllOK or Success;
    if Success then begin
      inc(SuccessCt);
      lbSelected.Items.Delete(i);
    end;
  end;
  MessageDlg('Successfully signed ' + IntToStr(SuccessCt) + ' items.', mtInformation, [mbOK], 0);
  //TO DO ... show problems.
  if SuccessCt = count then self.ModalResult := mrOK;
end;



function TfrmMultiTIUSign.SignOne(ItemInfo : TItemInfo; ESCode : string) : boolean;  //result TRUE if successful sign.
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';

var
  ActionType, SignTitle: string;
  ActionSts, SignSts: TActionRec;
  NoteLocked: Boolean;
  Msg, ErrMsg : string;
  SignerList : TSignerList;
  Signers : TStringList;

begin
  Result := false;
  if not AllowSignature(ItemInfo) then exit;

  SignTitle := TX_SIGN;
  ActionType := SIG_SIGN;
  LockDocument(ItemInfo.intIEN8925, ErrMsg);
  if ErrMsg <> '' then begin
    ItemInfo.AddErrMsg('Unable to get lock on TIU note record (#' + ItemInfo.IEN8925 + ') for signature.  ' + ErrMsg);
    Exit;
  end;
  NoteLocked := true;

  try
    ActOnDocument(ActionSts, ItemInfo.intIEN8925, ActionType);
    if not ActionSts.Success then begin
      ItemInfo.AddErrMsg(ActionSts.Reason);
      exit;
    end;
    if not AuthorSignedDocument(ItemInfo.intIEN8925) then begin
      ItemInfo.AddErrMsg('Can''t sign document because AUTHOR has not signed.');
      exit;
    end;
    SignDocument(SignSts, ItemInfo.intIEN8925, ESCode);
    if not ActionSts.Success then begin
      ItemInfo.AddErrMsg(ActionSts.Reason);
      exit;
    end;
    ItemInfo.Signed := true;
    Result := true;

    if ItemInfo.ProcessDeferredConsultAfterSignature then begin
      Msg := DoInternalLinkConsult(ItemInfo.intIEN8925, ItemInfo.DeferredConsultItemIEN,
                                   ItemInfo.DeferredConsultCompletionDesired);
      if Piece(Msg,'^',1)='-1' then begin
        ItemInfo.AddErrMsg(Piece(Msg,'^',2));
      end;
    end;

    if ItemInfo.ProcessDeferredAdditonalSigners then begin
      SignerList := ItemInfo.DeferredAdditionalSignersList;
      Signers := SignerList.Signers;
      if ItemInfo.DeferredSigAction in [SG_ADDITIONAL, SG_BOTH] then begin
        if assigned(Signers) and (Signers.Count > 0) then UpdateAdditionalSigners(ItemInfo.intIEN8925, Signers);
      end;
      if ItemInfo.DeferredSigAction in [SG_COSIGNER, SG_BOTH] then begin
        ChangeCosigner(ItemInfo.intIEN8925, SignerList.Cosigner);
      end;
    end;
  finally
    if NoteLocked then UnlockDocument(ItemInfo.intIEN8925);
  end;
end;

function TfrmMultiTIUSign.AllowSignature(ItemInfo : TItemInfo): Boolean;
//copied and modified from fNotes.
var
   RPCExists: boolean;
   RPCResult: string;
   RPCResultStr: TStringList;
begin
  Result := true;
  RPCExists := frmFrame.CheckForRPC('TMG TIU NOTE CAN BE SIGNED');
  if RPCExists=False then exit;
  RPCResultStr := TStringList.create();
  tCallV(RPCResultStr,'TMG TIU NOTE CAN BE SIGNED',[ItemInfo.DFN, ItemInfo.intIEN8925]);
  RPCResult := RPCResultStr.text;
  RPCResultStr.free;
  if piece(RPCResult,'^',1)='1' then exit;
  Result := False;
  ItemInfo.AddErrMsg(piece(RPCResult,'^',2));
end;

procedure TfrmMultiTIUSign.ZoomReset;
//copied and modified from TMGHTML2
begin
  SetZoom(100);
end;

procedure TfrmMultiTIUSign.ZoomIn;
//copied and modified from TMGHTML2
begin
  SetZoom(FZoomValue + FZoomStep);
end;

procedure TfrmMultiTIUSign.ZoomOut;
//copied and modified from TMGHTML2
begin
  SetZoom(FZoomValue - FZoomStep);
end;


procedure TfrmMultiTIUSign.SetZoom(Pct : integer);
//copied and modified from TMGHTML2
var
  pvaIn, pvaOut: OleVariant;
const
  OLECMDID_OPTICAL_ZOOM = $0000003F;
  MinZoom = 10;
  MaxZoom = 1000;
begin
  if Pct = FZoomValue then exit;
  FZoomValue := Pct;
  if FZoomValue < MinZoom then FZoomValue := MinZoom;
  if FZoomValue > MaxZoom then FZoomValue := MaxZoom;
  pvaIn := FZoomValue;
  pvaOut := #0;
  WebBrowser.ControlInterface.ExecWB(OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, pvaIn, pvaOut);
end;





end.
