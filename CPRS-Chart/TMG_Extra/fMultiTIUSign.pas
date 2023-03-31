unit fMultiTIUSign;

//kt Added entire form 9/2020

interface

uses
  Windows, Messages, SysUtils, DateUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, rCore, fFrame, fAddlSigners, Math,fImagePatientPhotoID, fNotes, uCore,
  TMGHTML2, StdCtrls, Buttons, ORCtrls, ORNet, ExtCtrls, OleCtrls, SHDocVw, rMisc,
  rReports;

type
  TItemInfoType = (tiitUnassigned, tiitTIU, tiitLab, tiitRadRpt);
  TItemInfo = class(TObject)
  public
    ItemType : TItemInfoType;
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
    DeferredMoveToLoose : boolean;
    DeferredMoveToLooseTitle : String;
    DeferredConsultItemIEN : integer;
    DeferredConsultCompletionDesired : boolean;
    DeferredToDelete : boolean;
    ProcessDeferredConsultAfterSignature : boolean;
    PromptForAdditionalSigners : boolean;
    ProcessDeferredAdditonalSigners : boolean;
    DeferredAdditionalSignersList : TSignerList; //<-- this is a RECORD
    DeferredSigAction : integer;
    FailMsg : TStringList; //note: default is to be nil.  Only instantiated if problem encountered.
    RptType : string;
    RptQualifier  : string;
    RptRPC : string;
    RptHSTAg : string;
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
    btnMoveToLoose: TBitBtn;
    lvUnSelected: TCaptionListView;
    lblNextAppt: TLabel;
    btnDelete: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteClick(Sender: TObject);
    procedure lvUnSelectedChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure lvUnSelectedResize(Sender: TObject);
    procedure lvUnSelectedClick(Sender: TObject);
    procedure lvUnSelectedCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lvUnSelectedColumnClick(Sender: TObject; Column: TListColumn);
    procedure pnlRightCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure pnlCenterBottomResize(Sender: TObject);
    procedure btnMoveToLooseClick(Sender: TObject);
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
    FInitZoomValue : integer;
    SelectedDFN : string;
    //ColLeftWidth, ColCenterWidth, ColRightWidth : integer;
    frmPatientPhotoID : TfrmPatientPhotoID;
    FsortCol: integer;
    FsortDirection: string;
    FsortAscending: boolean;
    Procedure Initialize(Items : TListItems);
    procedure SetupInfoList(Items : TListItems);
    procedure LoadNoteForView(ItemInfo : TItemInfo);
    function PatientDisplayName(ItemInfo : TItemInfo) : string;
    procedure UpdateButtonEnableStates;
    procedure MoveItemBetweenLists(j : integer; CurLB:TListBox; TargetLB : TListView);overload;
    procedure MoveItemBetweenLists(j : integer; CurLB:TListView; TargetLB : TListBox); overload;
    procedure DisplayFromList(LB : TListBox);
    procedure DisplayFromListView(LV : TListView);
    function UniqueFilename(FolderPath : string; FileSuffix : string) : string;
    function ProcessOne(ItemInfo : TItemInfo; ESCode : string) : boolean;  //result TRUE if successful sign.
    function SignOneTIU(ItemInfo : TItemInfo; ESCode : string) : boolean;  //result TRUE if successful sign.
    function DeleteOneTIU(ItemInfo : TItemInfo): boolean;  //result TRUE if note deleted
    function AllowSignature(ItemInfo : TItemInfo): Boolean;
    function SelectedItemInfoFromLB(LB : TListBox) : TItemInfo;
    function SelectedItemInfoFromLV(LV : TListView) : TItemInfo;
    procedure IdentifyAdditionalSigners(ItemInfo : TItemInfo);
    procedure SetZoom(Pct : integer);
    procedure ZoomReset;
    procedure ZoomIn;
    procedure ZoomOut;
    function ProcessMoveToLoose(ItemInfo : TItemInfo):boolean;
    procedure TransferCurrentFromUnselectedToActionList();
  public
    { Public declarations }

  end;


function ShowMultiAlertsSign(Items : TListItems) : boolean;


implementation

{$R *.dfm}

uses VAUtils, ORFn, uConst, StrUtils, fSignItem, fImages, uImages,
     uTIU, rTIU, uHTMLTools, fConsultLink;

const
  BlankWebPage = 'about:blank';

//===========================================================
//===========================================================


function ShowMultiAlertsSign(Items : TListItems) : boolean;
//Result: True if some documents were signed (i.e. refresh of alerts will be needed)
//NOTE: AllItems contents should NOT BE MODIFIED!  They are owned and managed by sender.
//Input: Items is really lstvAlerts.Items
var
  frmMultiTIUSign: TfrmMultiTIUSign;
  InitialBounds:string;
  InitPnlLeft,InitPnlCenter,InitZoom : string;
  InitLeftWidth,InitCenterWidth : integer;
begin
  result := false;
  InitialBounds := sCallV('ORWCH LOADSIZ',['frmMultiTIUSign']);
  InitPnlLeft := sCallV('ORWCH LOADSIZ',['frmMultiTIUSign.pnlLeft']);
  InitPnlCenter := sCallV('ORWCH LOADSIZ',['frmMultiTIUSign.pnlCenter']);
  InitZoom := sCallV('ORWCH LOADSIZ',['frmMultiTIUSign.ZoomValue']);
  frmMultiTIUSign := TfrmMultiTIUSign.Create(Application);
  try
    frmMultiTIUSign.Initialize(Items);
    if InitialBounds<>'' then begin
      frmMultiTIUSign.Left := strtoint(piece(InitialBounds,',',1));
      frmMultiTIUSign.Top := strtoint(piece(InitialBounds,',',2));
      frmMultiTIUSign.Width := strtoint(piece(InitialBounds,',',3));
      frmMultiTIUSign.Height := strtoint(piece(InitialBounds,',',4));
    end;
    if InitPnlLeft<>'' then begin
      InitLeftWidth := strtoint(piece(InitPnlLeft,',',1));
      if InitLeftWidth > 1 then frmMultiTIUSign.pnlLeft.Width := InitLeftWidth;
    end;
    if InitPnlCenter<>'' then begin
      InitCenterWidth := strtoint(piece(InitPnlCenter,',',1));
      if (frmMultiTIUSign.pnlLeft.Width+InitCenterWidth+20)<frmMultiTIUSign.width then
        frmMultiTIUSign.pnlCenter.Width := strtoint(piece(InitPnlCenter,',',1));
    end;
    if InitZoom<>'' then begin
      //frmMultiTIUSign.FZoomValue := strtoint(piece(InitZoom,',',1));
      //frmMultiTIUSign.SetZoom(strtoint(piece(InitZoom,',',1)));
      frmMultiTIUSign.FInitZoomValue := strtoint(piece(InitZoom,',',1));
    end else begin
      frmMultiTIUSign.FInitZoomValue := -1;
    end;
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
  ItemType := tiitUnassigned;
  DFN := '';
  PtName := '';
  AlertMsg := '';
  IEN8925 := '';
  intIEN8925 := 0;
  XQAID := '';
  FollowupNum := '';
  PtRecLoaded := false;
  //PtRec: TPtIDInfo;
  LocalHTMLFile := '';
  Signed := false;
  PromptToLinkToConsult := false;
  DeferredMoveToLoose := false;
  DeferredMoveToLooseTitle := '';
  DeferredConsultItemIEN := 0;
  DeferredConsultCompletionDesired := false;
  DeferredToDelete := false;
  ProcessDeferredConsultAfterSignature := false;
  PromptForAdditionalSigners := false;
  ProcessDeferredConsultAfterSignature := false;
  //DeferredAdditionalSignersList : TSignerList;
  DeferredSigAction := 0;
  FailMsg := nil;
  RptType := '';
  RptQualifier  := '';
  RptRPC := '';
  RptHSTAg := '';
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

procedure TfrmMultiTIUSign.FormClose(Sender: TObject; var Action: TCloseAction);
var Bounds,SaveResults:string;
begin
   Bounds := inttostr(Self.Left)+','+inttostr(Self.Top);
   Bounds := Bounds+','+inttostr(Self.Width)+','+ inttostr(Self.Height);
   SaveResults := sCallV('ORWCH SAVESIZ',['frmMultiTIUSign',Bounds]);
   Bounds := inttostr(pnlLeft.Width)+',0,0,0';
   SaveResults := sCallV('ORWCH SAVESIZ',['frmMultiTIUSign.pnlLeft',Bounds]);
   Bounds := inttostr(pnlCenter.Width)+',0,0,0';
   SaveResults := sCallV('ORWCH SAVESIZ',['frmMultiTIUSign.pnlCenter',Bounds]);
   Bounds := inttostr(FZoomValue)+',0,0,0';
   SaveResults := sCallV('ORWCH SAVESIZ',['frmMultiTIUSign.ZoomValue',Bounds]);
end;

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
  if lvUnSelected.Items.Count > 0 then begin
    lvUnSelected.ItemIndex := 0;
    lvUnSelectedClick(self);
    Application.ProcessMessages;
    if FInitZoomValue<>-1 then SetZoom(FInitZoomValue);
  end;
  UpdateButtonEnableStates;
  FsortDirection := 'F';
  FsortAscending := true;
  //if FInitZoomValue<>-1 then SetZoom(FInitZoomValue);
  
end;

procedure TfrmMultiTIUSign.Initialize(Items : TListItems);
//NOTE: Items contents should NOT BE MODIFIED!  They are owned and managed by sender.
//Input: Items is really lstvAlerts.Items
var
  i : integer;
  ItemInfo : TItemInfo;
  Date:string;
  NewItem: TListItem;
begin
  SetupInfoList(Items);
  NewItem := nil;
  for i := 0 to ItemInfoList.Count - 1 do begin
    ItemInfo := TItemInfo(ItemInfoList[i]);
    //lbUnselected.Items.AddObject(ItemInfo.PtName + '  ' + ItemInfo.AlertMsg, Pointer(i));
    //AddItem(
    NewItem := lvUnSelected.Items.Add;
    //NewItem.Caption := ItemInfo.XQAID;
    //for J := 2 to DelimCount(List[I], U) + 1 do
    Date := piece(ItemInfo.XQAID,';',3);
    Date := FormatFMDateTime('mmm dd,yyyy', strtofloat(Date));
    NewItem.Caption := Date;

    NewItem.SubItems.Add(ItemInfo.PtName);
    NewItem.SubItems.Add(ItemInfo.AlertMsg);
    NewItem.Data := Pointer(i);

  end;
end;

procedure TfrmMultiTIUSign.SetupInfoList(Items : TListItems);
//NOTE: Items contents should NOT BE MODIFIED!  They are owned and managed by sender.
var
  i,j : integer;
  XQAID, XQData, x : string;
  AlertType: string;
  tempS : string;
  ADFN : string;
  ItemInfo : TItemInfo;
  AFollowUp : integer;
  OneStudy, CaseNum : string;
  SelectID : string;
  RecordID : string;
  Data  : TStringList;
  OrderIFN : string;
  DT,SDT,EDT : string;

begin
  Data := TStringList.Create;
  try
    ItemInfo := nil;
    ADFN := '0'; //default
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
      AlertType := Copy(XQAID, 1, 3);
      if AlertType = 'TIU' then begin  //e.g. TIU6028;1423;3021203.09
        x := GetTIUAlertInfo(XQAID);    //658502^11514^903
        if (Piece(x, U, 2) <> '') and (Piece(x, U, 4) <> 'Y') then begin   //11/19/20
          ItemInfo := TItemInfo.Create; //owned by ItemInfoList
          ItemInfo.ItemType := tiitTIU;
          tempS := piece(XQAID,';',1);
          ItemInfo.IEN8925 := MidStr(tempS, 4, length(tempS));
          ItemInfo.intIEN8925 := StrToIntDef(ItemInfo.IEN8925, 0);
          ADFN := Piece(x, U, 2);  //*DFN*
          ItemInfo.FollowupNum := Piece(Piece(x, U, 3), ';', 1);  //Matches Notification types in uConst, e.g. NF_NOTES_UNSIGNED_NOTE
          ItemInfo.PromptToLinkToConsult := (GetTMGPSCode(ItemInfo.intIEN8925) = 'C');
          ItemInfo.PromptForAdditionalSigners := DisplayCosignerDialog(ItemInfo.intIEN8925);
        end;
      end else if AlertType = 'OR,' then begin       // e.g. 'OR,75730,22;168;3211101.162004'
        ADFN := Piece(XQAID, ',', 2);  //*DFN*
        AFollowUp := StrToIntDef(Piece(Piece(XQAID, ';', 1), ',', 3), 0);  //kt Matches Notification types in uConst, e.g. NF_NOTES_UNSIGNED_NOTE
        XQData := GetXQAData(XQAID); //in rCore    //e.g. '6788898.858362~1'
        if AFollowUp in [NF_IMAGING_RESULTS, NF_ABNORMAL_IMAGING_RESULTS, NF_IMAGING_RESULTS_AMENDED] then begin
          SelectID := 'i' + Piece(XQData, '~', 1) + '-' + Piece(XQData, '~', 2); //From fReports.ProcessNotifications  //e.g. i6788898.858362-1
          Data.Clear;
          ListImagingExamsForDFN(Data, ADFN);
          for j := 0 to Data.Count - 1 do begin
            OneStudy := Data[j];  //e.g. 'Family Phys of Greeneville;777^i6788898.858362-1^11/01/2021 14:15^CT CHEST WITH CONTRAST^Electronically Filed^Complete^7^[+]^N^^'
            x := Piece(OneStudy, ';',2);
            x := Piece(x, '^',2);
            if x <> SelectID then continue;
            ItemInfo := TItemInfo.Create; //owned by ItemInfoList
            ItemInfo.ItemType := tiitRadRpt;
            // Save enough info to call: rReports.LoadReportTextForDFN()
            ItemInfo.RptType := '18:IMAGING (LOCAL ONLY)';  //note: only the '18' part is used on server. --> points to ORPP IMAGING entry ('6) in OE/RR REPORT file.
            CaseNum := Piece(OneStudy, '^', 7);
            ItemInfo.RptQualifier  := SelectID+'#'+CaseNum;
            break; //note: should only match against 1 study, and thus create only 1 ItemInfo.
          end;
        end else if AFollowup in [NF_LAB_RESULTS, NF_ABNORMAL_LAB_RESULTS] then begin //from TfrmLabs.ProcessNotifications;
          OrderIFN := Piece(XQData, '@', 1);
          if OrderIFN = '0'  then begin
            ItemInfo := TItemInfo.Create; //owned by ItemInfoList
            ItemInfo.ItemType := tiitLab;
            // Save enough info to call: rReports.LoadReportTextForDFN()
            ItemInfo.RptType := '612:LAB RESULTS REPORT';  //Note: Only 612 part is used on server.
            DT := piece(piece(XQData,'|',2),';',2);
            SDT := piece(DT,'.',1)+'.000000';
            EDT := piece(DT,'.',1)+'.999999';
            ItemInfo.RptQualifier := 'TMG'+SDT+';'+EDT;
          end;
        end;
        if assigned(ItemInfo) then begin
          ItemInfo.RptRPC := 'ORWRP REPORT TEXT';
          ItemInfo.RptHSTag := '';
        end;
      end;
      if assigned(ItemInfo) then begin
        ItemInfo.DFN := ADFN;
        ItemInfo.XQAID := XQAID;
        ItemInfo.PtName := Items[i].SubItems[0];
        ItemInfo.AlertMsg := Items[i].SubItems[4];
        ItemInfoList.Add(ItemInfo);
        ItemInfo := nil;
      end;
    end;
  finally
    Data.Free;
  end;
end;


procedure TfrmMultiTIUSign.btnAddToSignClick(Sender: TObject);
var ItemInfo : TItemInfo;
    Success : boolean;
begin
  //ItemInfo := SelectedItemInfoFromLB(lvUnSelected);
  ItemInfo := SelectedItemInfoFromLV(lvUnSelected);
  if not assigned(ItemInfo) then exit;

  if ItemInfo.PromptToLinkToConsult then begin
    Success := DeferLinkConsult(ItemInfo.intIEN8925, ItemInfo.DFN,
                                ItemInfo.DeferredConsultItemIEN,
                                ItemInfo.DeferredConsultCompletionDesired);
    ItemInfo.ProcessDeferredConsultAfterSignature := Success;
  end;

  if ItemInfo.PromptForAdditionalSigners then
    IdentifyAdditionalSigners(ItemInfo);

  TransferCurrentFromUnselectedToActionList();
end;

procedure TfrmMultiTIUSign.TransferCurrentFromUnselectedToActionList();
var j : integer;
begin
  WebBrowser.Navigate('about:blank');
  j := lvUnSelected.ItemIndex;
  MoveItemBetweenLists(j, lvUnSelected, lbSelected);
  while j >= lvUnSelected.Items.Count do dec(j);
  lvUnSelected.ItemIndex := j;
  lvUnselected.SetFocus;
  lbUnSelectedClick(nil);
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
  ItemInfo.DeferredMoveToLoose := false;
  ItemInfo.DeferredMoveToLooseTitle := '';
  ItemInfo.DeferredToDelete := false;
  j := lbSelected.ItemIndex;
  MoveItemBetweenLists(j, lbSelected, lvUnSelected);
  lvUnSelected.AlphaSort;
  lvUnSelected.ItemIndex := lvUnSelected.Items.Count-1;
  lvUnSelected.SetFocus;
end;


procedure TfrmMultiTIUSign.MoveItemBetweenLists(j : integer; CurLB:TListBox; TargetLB : TListView);
var s,Date : string;
    i : integer;
    NewItem : TListItem;
begin
  if j < 0 then exit;
  s := CurLB.Items.Strings[j];
  i := Integer(curLB.Items.Objects[j]);
  CurLB.Items.Delete(j);
  //TargetLB.AddItem(s, pointer(i));
  NewItem := TargetLB.Items.Add;
  NewItem.Caption := piece(s,'^',1);
  NewItem.SubItems.Add(piece(s,'^',2));
  NewItem.SubItems.Add(piece(s,'^',3));
  NewItem.Data := Pointer(i);
end;

procedure TfrmMultiTIUSign.MoveItemBetweenLists(j : integer; CurLB:TListView; TargetLB : TListBox);
var s : string;
    Item : TListItem;
    i : integer;
begin
  if j < 0 then exit;
  Item := CurLB.Items.Item[j];
  s := Item.Caption+'^'+Item.SubItems[0]+'^'+Item.SubItems[1];
  i := Integer(curLB.Items[j].Data);
  CurLB.Items.Delete(j);
  TargetLB.AddItem(s, pointer(i));
end;


procedure TfrmMultiTIUSign.btnCancelClick(Sender: TObject);
begin
 //TO DO, confirm if items are in selected list.
  Self.ModalResult := mrCancel;
  Close;
end;

procedure TfrmMultiTIUSign.btnDeleteClick(Sender: TObject);
var ItemInfo : TItemInfo;
    Title : string;
    Suggestion : string;
begin
  if messagedlg('Are you sure you want to delete this note?',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  ItemInfo := SelectedItemInfoFromLV(lvUnSelected);
  if not assigned(ItemInfo) then exit;

  ItemInfo.DeferredToDelete := true;

  TransferCurrentFromUnselectedToActionList();
end;

procedure TfrmMultiTIUSign.btnEditNormalZoomClick(Sender: TObject);
begin
  ZoomReset;  //handle restore size
end;

procedure TfrmMultiTIUSign.btnEditZoomInClick(Sender: TObject);
begin
  ZoomIn;  //handle enlarge size
end;

procedure TfrmMultiTIUSign.btnEditZoomOutClick(Sender: TObject);
begin
  ZoomOut;  //handle shrink size
end;

procedure TfrmMultiTIUSign.btnMoveToLooseClick(Sender: TObject);
var //j : integer;
    ItemInfo : TItemInfo;
    //Success : boolean;
    //ActionSts,DeleteSts : TActionRec;
    //ImageList:TList;
    //i : integer;
    //RPCResult,Reason : string;
    //Result : boolean;
    //ImageInfo : TImageInfo;
    Answered : boolean;
    Title : string;
    Suggestion : string;
begin
  ItemInfo := SelectedItemInfoFromLV(lvUnSelected);
  if not assigned(ItemInfo) then exit;

  Title := Trim(pieces(ItemInfo.AlertMsg,' ',2,999));
  Title := piece2(Title,'available',1);
  Answered := InputQuery('Move to Loose Documents','What would you like to call this file?',Title);
  //Title := InputBox('Move to Loose Documents','What would you like to call this file?',Suggestion);
  if (Title = '')or(Answered<>True) then exit;
  ItemInfo.DeferredMoveToLoose := true;
  ItemInfo.DeferredMoveToLooseTitle := Title;

  TransferCurrentFromUnselectedToActionList();
{
  ItemInfo := SelectedItemInfoFromLB(lbUnSelected);
  if not assigned(ItemInfo) then exit;

  Suggestion := pieces(ItemInfo.AlertMsg,' ',2,999);
  Suggestion := piece2(Suggestion,'available',1);
  Success := frmNotes.MoveTIUToLoose(ItemInfo.DFN,ItemInfo.IEN8925, Suggestion);
  if Success=False then exit;

  ActOnDocument(ActionSts, StrToInt(ItemInfo.IEN8925), 'DELETE RECORD');
  if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then begin
    ImageList := TList.Create;
    FillImageList(ItemInfo.IEN8925, ImageList);
    Reason := 'DeleteAll';
    //DeleteAllAttachedImages(ItemInfo., idmDelete, HtmlEditor, false); // frmImages.DeleteAll(idmDelete);  //kt 9/11,  11/29/20
    for i := 0 to ImageList.Count - 1 do begin
       ImageInfo := GetImageInfo(ImageList, i);
       RPCResult := sCallV('TMG IMAGE DELETE', [inttostr(ImageInfo.IEN),'1',Reason]);
       Result := Piece(RPCResult,'^',1)= '1';
       if Result = false then begin
           MessageDlg(Piece(RPCResult,'^',2),mtError,[mbOK],0);
       end;
    end;
    ImageList.Free;
  end;

  DeleteDocument(DeleteSts, strtoint(ItemInfo.IEN8925),'');
  if DeleteSts.Success=False then begin
    messagedlg(DeleteSts.Reason,mtError,[mbOk],0);
    exit;
  end;
  j := lbUnSelected.ItemIndex;
  lbUnSelected.Items.Delete(j);
  while j >= lbUnSelected.Count do dec(j);
  lbUnSelected.ItemIndex := j;
  lbUnSelectedClick(Sender);
  UpdateButtonEnableStates;
}
end;


function TfrmMultiTIUSign.ProcessMoveToLoose(ItemInfo : TItemInfo):boolean;
var Success : boolean;
    ActionSts,DeleteSts : TActionRec;
    ImageList:TList;
    i : integer;
    RPCResult,Reason : string;
    Results : boolean;
    ImageInfo : TImageInfo;
    Title : string;
begin
  //ItemInfo := SelectedItemInfoFromLB(lbUnSelected);
  Result := False;
  if not assigned(ItemInfo) then exit;

  Title := ItemInfo.DeferredMoveToLooseTitle;
  Success := frmNotes.MoveTIUToLoose(ItemInfo.DFN,ItemInfo.IEN8925, Title, False);
  if Success=False then exit;

  ActOnDocument(ActionSts, StrToInt(ItemInfo.IEN8925), 'DELETE RECORD');
  if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then begin
    ImageList := TList.Create;
    FillImageList(ItemInfo.IEN8925, ImageList);
    Reason := 'DeleteAll';
    //DeleteAllAttachedImages(ItemInfo., idmDelete, HtmlEditor, false); // frmImages.DeleteAll(idmDelete);  //kt 9/11,  11/29/20
    for i := 0 to ImageList.Count - 1 do begin
       ImageInfo := GetImageInfo(ImageList, i);
       RPCResult := sCallV('TMG IMAGE DELETE', [inttostr(ImageInfo.IEN),'1',Reason]);
       Results := Piece(RPCResult,'^',1)= '1';
       if Results = false then begin
         MessageDlg(Piece(RPCResult,'^',2),mtError,[mbOK],0);
       end;
    end;
    ImageList.Free;
  end;

  DeleteDocument(DeleteSts, strtoint(ItemInfo.IEN8925),'');
  if DeleteSts.Success=False then begin
    MessageDlg(DeleteSts.Reason,mtError,[mbOk],0);
    exit;
  end;
  Result := True;
end;


procedure TfrmMultiTIUSign.btnNextClick(Sender: TObject);
//NOTE: disabled unless next is possible.
begin
  WebBrowser.Navigate('about:blank');
  lvUnSelected.ItemIndex := lvUnSelected.ItemIndex + 1;
  lvUnSelected.SetFocus;
  lbUnSelectedClick(Sender);
end;

procedure TfrmMultiTIUSign.btnPrevClick(Sender: TObject);
//NOTE: disabled unless prev is possible.
begin
  WebBrowser.Navigate('about:blank');
  lvUnSelected.ItemIndex := lvUnSelected.ItemIndex - 1;
  lvUnSelected.SetFocus;
  lvUnSelectedClick(Sender);
end;


procedure TfrmMultiTIUSign.lbSelectedClick(Sender: TObject);
begin
  DisplayFromList(lbSelected);
  lvUnSelected.ItemIndex := -1;
  UpdateButtonEnableStates;
end;

procedure TfrmMultiTIUSign.lbUnSelectedClick(Sender : TObject);
begin
  DisplayFromListView(lvUnSelected);
  lbSelected.ItemIndex := -1;
  UpdateButtonEnableStates;
end;

procedure TfrmMultiTIUSign.DisplayFromList(LB : TListBox);
var
  ItemInfo : TItemInfo;
begin
  SelectedDFN := '';
  ItemInfo := SelectedItemInfoFromLB(LB);
  if not assigned(ItemInfo) then exit;
  LoadNoteForView(ItemInfo);
  if not ItemInfo.PtRecLoaded then ItemInfo.PtRec  := GetPtIDInfo(ItemInfo.DFN);  //RPC call
  lblPatientInfo.Caption := PatientDisplayName(ItemInfo);
  PatientImage.Visible := true;
  LoadMostRecentPhotoIDThumbNail(ItemInfo.DFN,PatientImage.Picture.Bitmap);
  pnlPatientID.Color := ItemInfo.PtRec.DueColor;
  UpdateButtonEnableStates;
  SelectedDFN := ItemInfo.DFN;
end;

procedure TfrmMultiTIUSign.DisplayFromListView(LV : TListView);
var
  ItemInfo : TItemInfo;
begin
  SelectedDFN := '';
  ItemInfo := SelectedItemInfoFromLV(LV);
  if not assigned(ItemInfo) then exit;
  LoadNoteForView(ItemInfo);
  if not ItemInfo.PtRecLoaded then ItemInfo.PtRec  := GetPtIDInfo(ItemInfo.DFN);  //RPC call
  lblPatientInfo.Caption := PatientDisplayName(ItemInfo);
  PatientImage.Visible := true;
  LoadMostRecentPhotoIDThumbNail(ItemInfo.DFN,PatientImage.Picture.Bitmap);
  pnlPatientID.Color := ItemInfo.PtRec.DueColor;
  UpdateButtonEnableStates;
  SelectedDFN := ItemInfo.DFN;
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

function TfrmMultiTIUSign.SelectedItemInfoFromLV(LV : TListView) : TItemInfo;
var
  i, DataIndex : integer;
begin
  Result := nil;  //default
  i := LV.ItemIndex;
  if i=-1 then exit;
  DataIndex := Integer(LV.Items[i].Data);
  if (DataIndex < 0) or (DataIndex >= ItemInfoList.Count) then exit;
  Result := TItemInfo(ItemInfoList[DataIndex]);
end;

function TfrmMultiTIUSign.PatientDisplayName(ItemInfo : TItemInfo) : string;
begin
  //Could enhance later
  lblNextAppt.Caption := piece(sCallV('TMG CPRS GET NEXT APPOINTMENT',[ItemInfo.DFN,'0']),';',1);
  Result := ItemInfo.PtRec.Name + ' (' + ItemInfo.PtRec.DOB + ') ';
end;



procedure TfrmMultiTIUSign.PatientImageMouseEnter(Sender: TObject);
//var //refresh : boolean;
    //ItemInfo : TItemInfo;
begin
  //if not assigned(ItemInfo) then exit;
  if SelectedDFN = '' then exit;
  try
    if not assigned(frmPatientPhotoID) then frmPatientPhotoID:= TfrmPatientPhotoID.Create(Self);
    frmPatientPhotoID.ShowPreviewMode(SelectedDFN,Self.PatientImage,ltLeft);
  except
    //On E : exception do messagedlg('Error on Mouse Enter'+#13#10+E.Message,mtError,[mbok],0);
  end;
end;


procedure TfrmMultiTIUSign.PatientImageMouseLeave(Sender: TObject);
begin
  inherited;
  //if assigned(frmPatientPhotoID) then FreeAndNil(frmPatientPhotoID);
  try
    if assigned(frmPatientPhotoID) then frmPatientPhotoID.hide;
  except
    //On E : exception do messagedlg('Error on Mouse Leave'+#13#10+E.Message,mtError,[mbok],0);
  end;
end;

procedure TfrmMultiTIUSign.pnlCenterBottomResize(Sender: TObject);
var btnWidth:integer;
begin
   btnWidth := round((pnlCenterBottom.Width-11-btnPrev.Width-btnNext.Width-24)/3);
   //btnPrev.width := btnWidth;
   //btnNext.width := btnWidth;
   btnPrev.left := 5;
   btnAddToSign.width := btnWidth;
   btnMoveToLoose.width := btnWidth;
   btnDelete.width := btnWidth;
   btnDelete.Left := 5+6+btnPrev.width;
   btnAddToSign.Left := btnDelete.Left+btnWidth+6;  //5+12+btnWidth+btnPrev.width;
   btnMoveToLoose.Left := btnAddToSign.Left+btnWidth+6;//5+18+(btnWidth*2)+btnPrev.width;
   btnNext.Left := pnlCenterBottom.Width-6-btnNext.Width;
{   btnWidth := round((pnlCenterBottom.Width-23)/4);
   btnPrev.width := btnWidth;
   btnAddToSign.width := btnWidth;
   btnMoveToLoose.width := btnWidth;
   btnNext.width := btnWidth;
   btnPrev.left := 5;
   btnAddToSign.Left := 5+6+btnWidth;
   btnMoveToLoose.Left := 5+12+(btnWidth*2);
   btnNext.Left := 5+18+(btnWidth*3);}
end;

procedure TfrmMultiTIUSign.pnlRightCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  if NewWidth<158 then begin
      pnlCenter.Width := pnlCenter.Width-(158-NewWidth);
      //pnlCenter.Width := self.width-(pnlLeft.Width+Splitter1.Width+Splitter2.width+(158-NewWidth));
      NewWidth := 158;
  end;
end;

procedure TfrmMultiTIUSign.LoadNoteForView(ItemInfo : TItemInfo);
//NOTE: code modified from TfrmNotes.lstNotesClick(Sender: TObject);
var
  Lines : TStringList;
  Temp : string;
begin
  Lines := TStringList.Create;
  try
    case ItemInfo.ItemType of
      tiitTIU: begin
        if ItemInfo.LocalHTMLFile = '' then begin
          StatusText('Retrieving selected progress note...');
          Screen.Cursor := crAppStart;
          LoadDocumentText(Lines, ItemInfo.intIEN8925);
          Screen.Cursor := crDefault;
          StatusText('');
          //kt 8/19/21 -- line below not needed, as is called at time of loading document.
          //uHTMLTools.ScanForSubs(Lines);      //Ensure download of any media encountered
          //SetDisplayToHTMLvsText(Mode,FViewNote);         NOTE: I am only supporting HTML for now...
          uHTMLTools.FixHTML(Lines);
          ItemInfo.LocalHTMLFile := UniqueFilename(CPRSCacheDir, '.html');
          Lines.SaveToFile(ItemInfo.LocalHTMLFile);
        end;
        WebBrowser.Navigate(ItemInfo.LocalHTMLFile);
      end;
      tiitRadRpt: begin
        if ItemInfo.LocalHTMLFile = '' then begin
          StatusText('Retrieving selected report...');
          with ItemInfo do rReports.LoadReportTextForDFN(Lines, DFN, RptType, RptQualifier, RptRpc, RptHSTag);
          Lines.Insert(0,'<PRE>');
          Lines.Append('</PRE>');
          temp := uHTMLTools.WrapHTML(Lines.Text);
          Screen.Cursor := crDefault;
          StatusText('');
          ItemInfo.LocalHTMLFile := UniqueFilename(CPRSCacheDir, '.html');
          Lines.Text := Temp;
          Lines.SaveToFile(ItemInfo.LocalHTMLFile);
        end;
        WebBrowser.Navigate(ItemInfo.LocalHTMLFile);
      end;
      tiitLab: begin
        if ItemInfo.LocalHTMLFile = '' then begin
          StatusText('Retrieving selected report...');
          with ItemInfo do rReports.LoadReportTextForDFN(Lines, DFN, RptType, RptQualifier, RptRpc, RptHSTag);
          Screen.Cursor := crDefault;
          StatusText('');
          ItemInfo.LocalHTMLFile := UniqueFilename(CPRSCacheDir, '.html');
          Lines.SaveToFile(ItemInfo.LocalHTMLFile);
        end;
        WebBrowser.Navigate(ItemInfo.LocalHTMLFile);
      end;
    end; {case}
  finally
    Lines.Free;
  end;
end;

procedure TfrmMultiTIUSign.lvUnSelectedChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  lvUnSelectedClick(Sender);
end;

procedure TfrmMultiTIUSign.lvUnSelectedClick(Sender: TObject);
begin
  DisplayFromListView(lvUnSelected);
  UpdateButtonEnableStates;
end;

procedure TfrmMultiTIUSign.lvUnSelectedColumnClick(Sender: TObject; Column: TListColumn);
begin

  if (FsortCol = Column.Index) then
     FsortAscending := not FsortAscending;

  if FsortAscending then
     FsortDirection := 'F'
  else
     FsortDirection := 'R';

  FsortCol := Column.Index;
  lvUnSelected.AlphaSort;
end;

procedure TfrmMultiTIUSign.lvUnSelectedCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer;
  var Compare: Integer);
begin
  if not(Sender is TListView) then Exit;
  if FsortAscending then
    begin
      if FsortCol = 0 then Compare := CompareStr(Item1.Caption, Item2.Caption)
      else Compare := CompareStr(Item1.SubItems[FsortCol - 1], Item2.SubItems[FsortCol - 1]);
    end
  else
    begin
      if FsortCol = 0 then Compare := CompareStr(Item2.Caption, Item1.Caption)
      else Compare := CompareStr(Item2.SubItems[FsortCol - 1], Item1.SubItems[FsortCol - 1]);
    end;
end;

procedure TfrmMultiTIUSign.lvUnSelectedResize(Sender: TObject);
begin
  //lvUnSelected.Column[2].width := lvUnSelected.Width - 175;
end;

procedure TfrmMultiTIUSign.UpdateButtonEnableStates;
begin
  btnPrev.Enabled := (lvUnSelected.ItemIndex > 0);
  btnNext.Enabled := (lvUnSelected.ItemIndex < lvUnSelected.Items.Count-1);
  btnRemove.Enabled := (lbSelected.ItemIndex > -1);
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
  MessageStr:string;
  Index: integer;
  ItemInfo : TItemInfo;
  AllOK : boolean;
  Success : boolean;
  SuccessCt : integer;
  OkToDelete:boolean;
  DeleteCount:integer;
begin
  //Deletion verification
  DeleteCount:=0;OkToDelete:=False;count:=0;MessageStr:='';
  for i := lbSelected.Items.Count - 1 downto 0 do begin
    Index := Integer(lbSelected.Items.Objects[i]);
    ItemInfo := TItemInfo(ItemInfoList[Index]);
    if ItemInfo.DeferredToDelete=True then DeleteCount := DeleteCount+1
    else count:=count+1;
  end;
  if DeleteCount>0 then begin
    OkToDelete := (messagedlg('You have '+inttostr(DeleteCount)+' marked to delete.'+#13#10+#13#10+'Are you sure you want to delete these?',mtconfirmation,[mbYes,mbNo],0)=mrYes);
  end;
  //
  //Get count above now count := lbSelected.Items.Count;
  if count>0 then MessageStr := 'Sign '+IntToStr(count)+' Notes';
  if DeleteCount>0 then begin
     if MessageStr<>'' then MessageStr := MessageStr+' and'+#13#10;
     MessageStr := MessageStr+'Delete '+IntToStr(DeleteCount)+' Notes';
  end;
  SignatureForItem(Font.Size, 'Enter Signature Code to: '+MessageStr, 'Handle Multiple Documents', ESCode);
  if length(ESCode)=0 then exit;
  AllOK := true;
  SuccessCt := 0;
  for i := lbSelected.Items.Count - 1 downto 0 do begin
    Index := Integer(lbSelected.Items.Objects[i]);
    ItemInfo := TItemInfo(ItemInfoList[Index]);
    if (ItemInfo.DeferredToDelete=True)and(OkToDelete=False) then continue;
    Success := ProcessOne(ItemInfo, ESCode);
    AllOK := AllOK or Success;
    if Success then begin
      inc(SuccessCt);
      lbSelected.Items.Delete(i);
    end;
  end;
  MessageDlg('Successfully signed ' + IntToStr(SuccessCt) + ' items.', mtInformation, [mbOK], 0);
  //TO DO ... show problems.
  if SuccessCt = (count+DeleteCount) then self.ModalResult := mrOK;
end;


function TfrmMultiTIUSign.ProcessOne(ItemInfo : TItemInfo; ESCode : string) : boolean;  //result TRUE if successful sign.
var DFN,Day,Results:string;
begin
  Result := False;
  case ItemInfo.ItemType of
    tiitTIU: begin
      if ItemInfo.DeferredMoveToLoose then begin
        Result := ProcessMoveToLoose(ItemInfo);
      end else if ItemInfo.DeferredToDelete then begin
        Result := DeleteOneTIU(ItemInfo);
      end else begin
        Result := SignOneTIU(ItemInfo, ESCode);
      end;
    end;
    tiitRadRpt: begin
      DeleteAlert(ItemInfo.XQAID);
      Result := True;
    end;
    tiitLab: begin
      DFN := piece(ItemInfo.XQAID,',',2);
      Day := piece(piece(ItemInfo.RptQualifier,';',2),'.',1);
      Results := sCallV('TMG CPRS LABS SEEN SET 1 DAY',[DFN,Day,inttostr(User.DUZ)]);
      DeleteAlert(ItemInfo.XQAID);
      Result := True;  //Why is this needed?
    end;
  end; {case}

end;

function TfrmMultiTIUSign.DeleteOneTIU(ItemInfo : TItemInfo): boolean;  //result TRUE if note deleted
var ActionSts:TActionRec;
    x : String;
begin
    if ItemInfo.DeferredToDelete <> True then begin
        ShowMsg('NOTE: A note not set for deletion got to the Delete Function!');
        exit;
    end;
    ActOnDocument(ActionSts, ItemInfo.intIEN8925, 'DELETE RECORD');
    if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then begin
        ExtDeleteAllAttachedImages(ItemInfo.IEN8925, idmDelete, nil, False);
        ActOnDocument(ActionSts, ItemInfo.intIEN8925, 'DELETE RECORD');
    end;
    if ActionSts.Success <>True then begin
        ShowMsg(ActionSts.Reason);
        exit;
    end;
    x := sCallV('TIU DELETE RECORD', [ItemInfo.intIEN8925, 'Deleted via MultiTIUSign']);
    result := Piece(x, U, 1) = '0';
end;

function TfrmMultiTIUSign.SignOneTIU(ItemInfo : TItemInfo; ESCode : string) : boolean;  //result TRUE if successful sign.
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
  try
    WebBrowser.ControlInterface.ExecWB(OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, pvaIn, pvaOut);
  except
    On E : exception do messagedlg('Error on setting Zoom.'+#13#10+E.Message,mtError,[mbok],0);
    //
  end;
end;





end.
