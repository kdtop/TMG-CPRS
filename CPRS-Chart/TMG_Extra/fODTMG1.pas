unit fODTMG1;
//kt added 12/8/22

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fODGen, VA508AccessibilityManager, StdCtrls, ComCtrls, ExtCtrls,
  ORCtrls, CheckLst, Buttons, uCore, ORNet, VAUtils;

type
  TfrmODTMG1 = class;  //forward declaration
  TNotifyODTMGClosing = procedure(Dlg : TfrmODTMG1; Data : TStringList) of object;
  tTMGDataType = (ttdtNone=1,
                  ttdtDialog,
                  ttdtDx,
                  ttdtProc,
                  ttdtBundle,
                  ttdtPageGroup,
                  ttdtOrderingProvider,
                  ttdtLabTiming,
                  ttdtOrderFlags,
                  ttdtOrderOptions,
                  ttdtItemData,
                  ttdtTextFld,
                  ttdtWPFld,
                  ttdtPriorICD,     //added custom for this form.
                  ttdtEncounterICD  //added custom for this form.
                  );
  TTMGDataList = class;
  TTMGData = class(TObject)
  private
    FAllowedLinkedDxList : TTMGDataList; //Doesn't own objects
  public
    SourceIndex       : integer; // index in FDialogItemList that was source of this data
    ID                : string;
    Instance          : integer;
    IEN               : string;  //IEN22751
    ICD               : string;
    Name              : string;
    NeedsLinkedDx     : boolean;
    LinkedDxStr       : string;  //comma separated list of IEN's 22751.  E.g. PSA might needs Dx of H/O Prostate CA, or ScreeningPSA
    DataType          : tTMGDataType;
    Items             : TStringList; //doesn't own objects
    Fasting           : boolean;
    Checked           : boolean;
    Index             : integer; //for TCheckListBox entries, this will store items index
                                 //for TRadioGroup entries, this will store items index
                                 //for TRadioGroup parents (those with child entries), this will store selecte ItemIndex
    SavedValue        : string;
    InternalValue     : string;
    ExternalValue     : string;
    LinkedControl     : TControl;
    function Modified : boolean;  //Is InternalValue different from SavedInternalValue?
    procedure SetCheckedEtc(Value : boolean);  //kt 12/3/23
    procedure SetCheckedIVEV(Value : boolean; InternalValue, ExternalValue : string);  //kt 12/3/23
    function AllowedLinkedDxList(ListOfAllData : TTMGDataList) : TTMGDataList;
    function IsLinkedDxChecked(ListOfAllData : TTMGDataList) : boolean;
    constructor Create; overload;
    constructor Create(IEN : string; DataType : tTMGDataType); overload;
    destructor Destroy; override;
  end;

  TTMGDataList = class(TList)
  private
    function GetItem(Index : integer): TTMGData;
    procedure PutItem(Index: Integer; Value: TTMGData);
  public
    //constructor Create;
    //destructor Destroy;
    function DataByType(DataType : tTMGDataType; IndexByType : integer) : TTMGData;
    function DataByIDInstance(ID : string; Instance : integer) : TTMGData;
    function CountOfType(DataType : tTMGDataType) : integer;
    function CountOfID(ID : string) : integer;
    function CountOfIEN(IEN : string) : integer;
    function CreateAndAdd(IEN : string; DataType : tTMGDataType) : integer; //create TTMGData object and add to list
    function IndexOfIEN(IEN : string; StartingIndex : integer = 0) : integer;
    function IndexOfNameType(Name : string; DataType : tTMGDataType) : integer;
    function IndexOfIDInstance(ID : string; Instance : integer) : integer;
    function SublistByType(Arr : array of tTMGDataType) : TTMGDataList; overload; //returned list is created, but not considered owner of objects
    function SublistByType(DataType : tTMGDataType)     : TTMGDataList; overload; //returned list is created, but not considered owner of objects

    function SublistByID(ID: string) : TTMGDataList;  //returned list is created, but not considered owner of objects
    property Data[Index: Integer]: TTMGData read GetItem write PutItem; default;  //list does NOT own items
  end;

  TfrmODTMG1 = class(TfrmODGen)
    gbBundles: TGroupBox;
    cboBundles: TComboBox;
    edtOtherOrder: TEdit;
    edtOtherTime: TEdit;
    rgGetLabsTiming: TRadioGroup;
    btnClear: TButton;
    cklbOther: TCheckListBox;
    pnlBottom: TPanel;
    memOrderComment: TMemo;
    lblOtherProc: TLabel;
    pnlFlags: TPanel;
    cklbFlags: TCheckListBox;
    btnToggleSpecialProc: TSpeedButton;
    tcProcTabs: TTabControl;
    pnlProcedures: TPanel;
    pnlProcCaption: TPanel;
    cklbProcedures: TCheckListBox;
    Label1: TLabel;
    lblComments: TLabel;
    rgProvider: TRadioGroup;
    lblWhen: TLabel;
    pnlOrderAreaMain: TPanel;
    pnlOrderAreaLeft: TPanel;
    splitterleft: TSplitter;
    pnlOrderAreaRight: TPanel;
    pnlRightTop: TPanel;
    tcDxSelect: TTabControl;
    cklbDisplayedDxs: TCheckListBox;
    pnlRightBottom: TPanel;
    pnlCustomDx: TPanel;
    splitterRight: TSplitter;
    btnToggleSpecialDx: TSpeedButton;
    edtDx0: TEdit;
    edtDx1: TEdit;
    edtDx2: TEdit;
    edtDx3: TEdit;  //This will be used to store 'PriorICD' type entries.
    pnlLeftTop: TPanel;
    splitterLeftPanel: TSplitter;
    pnlRightTopHeading: TPanel;
    memDxInstructions: TMemo;
    btnSrchICD: TBitBtn;
    memProcInfo: TMemo;
    tmrDelayProcInfo: TTimer;
    procedure tmrDelayProcInfoTimer(Sender: TObject);
    procedure btnSrchICDClick(Sender: TObject);
    procedure tcDxSelectChange(Sender: TObject);
    procedure cmdQuitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmdAcceptClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure memChange(Sender: TObject);
    procedure rgClick(Sender: TObject);
    procedure edtEditChange(Sender: TObject);
    procedure cboBundlesChange(Sender: TObject);
    procedure btnToggleSpecialProcClick(Sender: TObject);
    procedure tcProcTabsChange(Sender: TObject);
    procedure cklbCommonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FTMGOrderData : TTMGDataList;  //This is the repository of ALL the lab data info, including which objects are checked/selected.
    FAllDxList    : TTMGDataList;  //will NOT own objects.  Will have pointers to objects owned by FTMGOrderData
    FPriorDxList  : TTMGDataList;  //will NOT own objects.  Will have pointers to objects owned by FTMGOrderData
    FEnctrDxList  : TTMGDataList;  //will NOT own objects.  Will have pointers to objects owned by FTMGOrderData
    FEditsList    : TList; //doesn't own objects
    FCklbList     : TList; //doesn't own objects
    FRgList       : TList; //doesn't own objects
    FPromptToPrint: boolean;
    FObjToStoreDxLinks : TTMGData; //doesn't own object.  The edit field of this object will hold link between LabProc and needed Dx object.
    FProcAndDxLinksList : TTMGDataList; //will NOT own objects.  List[x]=Ptr to LabProc TTMGData object, List[x+1]=Ptr to Dx TTMGData object
    FFasting      : boolean;
    FLabTimingStr : string;
    //kt FLabTimingStrOther : string;   //used to hold text for Other
    FCustomProcOpen : boolean;
    FOrderFlagFastingIndex : integer;
    FOnClosing : TNotifyODTMGClosing;
    FLastSelectedProc : TTMGData; //doesn't own data.  NOTE: A checkbox item can be selected, but not checked.  Two separate states.
    procedure SetCustomProcArea(Open : boolean; Sender: TSpeedButton);
    procedure ToggleCustomProcArea(Sender:TSpeedButton);
    procedure GetChangedObjsList(ListBox : TCheckListBox; ChangedDataObjs : TTMGDataList);
    procedure CheckedGUI2Data(ListBox : TCheckListBox; ChangedDataObjs : TTMGDataList);
    procedure TriggerDelayedProcInfo();
    procedure HandleCheckListBoxChange(Sender : TObject);
    procedure CheckForFastingLabs();
    procedure CheckForPromptToPrint();
    procedure InitData();
    procedure Responses2Data();
    procedure Data2Responses(Arr : array of TTMGData);         overload;
    procedure Data2Responses(ChangedDataObjs : TTMGDataList);  overload;
    function UpdateOrderMemoDisplay : string;
    procedure Data2GUI();
    procedure ClearData(ChangedDataObjs : TTMGDataList);
    function rgExternalValue(DataObj : TTMGData) : string;
    procedure SetupLabOrderMsg(SL : TStringList);
    function OkToClose:boolean;
    procedure SetOtherTimeEnable(Enable : boolean);
    procedure PopulateCkLb(CkLb : TCheckListBox; Source : TTMGDataList); overload;
    procedure PopulateCkLb(CkLb : TCheckListBox; Source : TStringList);  overload;
    procedure Items2DataList(Items : TStringList; DL : TTMGDataList);
    procedure ChangeDxSelect4Mode(ShowSpecificDx : Boolean);
    function AddOrRemovePriorDx(EditCtrl: TEdit; Checked : boolean; Str : string; DivChar : char = '^') : boolean;
  protected
    procedure PlaceControls; override;
    procedure ControlChange(Sender: TObject); override;
    procedure StoreLinkedDxs;
  public
    { Public declarations }
    LaunchedFromEncounter : boolean;
    procedure   SetupDialog(OrderAction: Integer; const ID: string); override;
    function    SelectOrder(OrderName : string; var ErrMsg : string) : boolean;
    function    SelectDx(DxName : string; var ErrMsg : string) : boolean;
    function    SelectName(Name : string; DataType: tTMGDataType; var ErrMsg : string) : boolean;
    function    SelectIEN(IEN22751 : string; var ErrMsg : string) : boolean;
    procedure   AutoCheckPerOrderedLabs();
    procedure   LoadUserDxList(DxInfoList : TStringList);
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    property    OnClosing : TNotifyODTMGClosing read FOnClosing write FOnClosing;  //kt
  end;

  procedure TMGLabOrderAutoPopulateIfActive();
  procedure SendLabOrderMsg(MessageArr : TStringList);

implementation

{$R *.dfm}

uses
  rODBase, ORFn, rCore, rOrders, uConst, ORDtTm, fFrame, fOrders,
  fPage, uOrders, fTMGEncounterICDPicker, 
  fNetworkMessengerClient, uTMG_WM_API, StrUtils;

const
  HT_FRAME  = 8;
  HT_LBLOFF = 3;
  HT_SPACE  = 6;
  WD_MARGIN = 6;
  TX_STOPSTART   = 'The stop date must be after the start date.';

  N_Y : array[false..true] of char = ('0','1');

  FREE_TEXT_DX              = 'FREE TEXT DX ';
  FREE_TEXT_DX_SPECIAL      = 'FREE TEXT DX 4';
  FREE_TEXT_LAB             = 'FREE TEXT LAB';
  FREE_TEXT_OTHER_TIME      = 'FREE TEXT OTHER TIME';
  FREE_TEXT_LINK_LABPROC2DX = 'FREE TEXT LINK TEST TO DX';

type tDxTCTabs = (tDxTCAll, tDxTCSpecific, tDxTCPrior, tDxTCEncounter);  //NOTE: Must be 1:1 with the actual tab order in Dx Tab control

//=================================================================
//=================================================================

  procedure TMGLabOrderAutoPopulateIfActive();
  var
     frmODTMG1: TfrmODTMG1;
  begin
    if not assigned(uOrderDialog) then exit;
    if not (uOrderDialog is TfrmODTMG1) then exit;
    frmODTMG1 := TfrmODTMG1(uOrderDialog);
    frmODTMG1.AutoCheckPerOrderedLabs();
  end;

//=================================================================
//=================================================================

  procedure SendLabOrderMsg(MessageArr : TStringList);
  var MyName : string;
      //LabTimingMsg:string;
      PromptToPrint                     : boolean;
      Recipients : string;
      AUser : string;
      i : integer;
  begin
    if not Assigned(MessageArr) then exit;
    if MessageArr.Count<3 then exit;
    Recipients := MessageArr[0];
    PromptToPrint := (MessageArr[1] = 'T');
    MyName := MessageArr[2];
    for i := 2 downto 0 do MessageArr.Delete(i);

    //LabTimingMsg := FLabTimingStr;
    uTMG_WM_API.PromptForPrint := PromptToPrint;  //This sets the Prompt For Print when the order is signed
    //
    for i := 1 to NumPieces(Recipients,'^') do begin
      AUser := Piece(Recipients,'^',i);
      if AUser='' then continue;
      //Send message to User, and send to lab user if appropriate
      SendOneMessage(AUser,MyName,MessageArr);
    end;

    {
    //LabTimingMsg := FLabTimingStr;
    FastingMsg := IfThen(FFasting, 'FASTING', 'NON-FASTING');
    uTMG_WM_API.PromptForPrint := FPromptToPrint;  //This sets the Prompt For Print when the order is signed
    //
    //GET USERS AND PREPARE MESSAGE
    MessageArr := TStringList.create();
    try
      User := LabOrderMsgRecip('1');
      if piece(User,'^',1)='-1' then begin
        ShowMessage('Error getting User Name: '+piece(User,'^',2));
        exit;
      end;
      LabUser := LabOrderMsgRecip('2');
      if piece(LabUser,'^',1)='-1' then begin
        ShowMessage('Error getting Lab User Name: '+piece(LabUser,'^',2));
        exit;
      end;
      MyName :=  GetMyName;
      if MyName='' then begin
        ShowMessage('Error getting Current User Name');
        exit;
      end;
      MessageArr.Add(MyName+' ORDERED LABS');
      MessageArr.Add('');
      MessageArr.Add(Patient.Name);
      MessageArr.Add('');
      MessageArr.Add(FastingMsg);
      MessageArr.Add('');
      //MessageArr.Add(uppercase(LabTimingMsg));
      MessageArr.Add(UpperCase(FLabTimingStr));

      //Send message to User, and send to lab user if appropriate
      SendOneMessage(User,MyName,MessageArr);
      //if (LabTimingMsg='Today') or (LabTimingMsg='Use lab blood if possible') then begin
      if (FLabTimingStr='Today') or (FLabTimingStr='Use lab blood if possible') then begin
        SendOneMessage(LabUser, MyName, MessageArr);
      end;
    finally
      MessageArr.Free;
    end;
    }
  end;



//=================================================================
//=================================================================

constructor TTMGData.Create;
begin
  inherited Create;
  SourceIndex        := -1;
  ID                 := '';
  Instance           := 0;
  IEN                := '';
  Name               := '';
  NeedsLinkedDx      := false;
  LinkedDxStr        := '';
  DataType           := ttdtNone;
  Items              := TStringList.Create;   //doesn't own objects
  Fasting            := false;
  Checked            := false;
  Index              := -1;
  SavedValue         := '';
  InternalValue      := '';
  ExternalValue      := '';
  LinkedControl      := nil;
  FAllowedLinkedDxList:= nil; //only instantiated if needed.  //Doesn't own objects

end;

constructor TTMGData.Create(IEN : string; DataType : tTMGDataType);
begin
  Self.Create;
  Self.IEN := IEN;
  Self.DataType := DataType;
end;


destructor TTMGData.Destroy;
begin
 Items.Free;
 FAllowedLinkedDxList.Free;  //Doesn't own objects
 inherited;
end;

function TTMGData.AllowedLinkedDxList(ListOfAllData : TTMGDataList) : TTMGDataList;
var SL : TStringList;
    IEN : string;
    TempObj: TTMGData;
    i, k : integer;
begin
  Result := FAllowedLinkedDxList;
  if Assigned(FAllowedLinkedDxList) then exit;
  FAllowedLinkedDxList := TTMGDataList.Create;
  SL := TStringList.Create;
  try
    PiecesToList(LinkedDxStr,',', SL);
    for i := 0 to SL.Count-1 do begin
      IEN := SL.Strings[i];
      k := ListOfAllData.IndexOfIEN(IEN);
      if k < 0 then continue;
      TempObj := ListOfAllData.Data[k];
      FAllowedLinkedDxList.Add(TempObj);
    end;
  finally
    SL.Free;
  end;
  Result := FAllowedLinkedDxList;
end;

function TTMGData.IsLinkedDxChecked(ListOfAllData : TTMGDataList) : boolean;
var
  LinkedDxList: TTMGDataList;
  TempObj : TTMGData;
  i : integer;
begin
  Result := false; //default
  LinkedDxList := AllowedLinkedDxList(ListOfAllData);
  for i := 0 to LinkedDxList.Count - 1 do begin
    TempObj := LinkedDxList[i];
    if not TempObj.Checked then continue;
    Result := true;
    break;
  end;
end;

procedure TTMGData.SetCheckedEtc(Value : boolean);  //kt 12/3/23
begin
  Checked := Value;
  InternalValue := N_Y[Value];
  ExternalValue := IfThen(Checked, Name, '');
end;

procedure TTMGData.SetCheckedIVEV(Value : boolean; InternalValue, ExternalValue : string);  //kt 12/3/23
begin
  Checked := Value;
  Self.InternalValue := InternalValue;
  Self.ExternalValue := ExternalValue;
end;


function TTMGData.Modified : boolean;
var Saved : string;
    fix : boolean;
begin
  fix := (Self.DataType in [ttdtDx, ttdtProc, ttdtOrderFlags, ttdtOrderOptions]) and (Self.SavedValue = '');
  Saved := IfThen(fix, N_Y[false], Self.SavedValue);
  Result := (Saved <> Self.InternalValue);
end;


//=================================================================
//=================================================================

{
constructor TTMGDataList.Create;
begin
  inherited Create;
  //more here

end;

destructor TTMGDataList.Destroy;
begin
  //more here
  inherited;
end;
}

function TTMGDataList.CreateAndAdd(IEN : string; DataType : tTMGDataType) : integer; //create TTMGData object and add to list
var
  Data : TTMGData;
begin
  Data := TTMGData.Create(IEN, DataType);
  Result := Self.Add(Data);
end;

function TTMGDataList.CountOfType(DataType : tTMGDataType) : integer;
var i : integer;
begin
  Result := 0;
  for i := 0 to Self.Count - 1 do begin
    if Self.Data[i].DataType = DataType then inc(Result);
  end;
end;

function TTMGDataList.SublistByType(Arr : array of tTMGDataType) : TTMGDataList;  //returned list is created, but not considered owner of objects
//returned list is created, but not considered owner of objects
var i,j : integer;
begin
  Result := TTMGDataList.Create;
  for i := 0 to Self.Count - 1 do begin
    for j := 0 to High(Arr) do begin
      if Self.Data[i].DataType <> Arr[j] then continue;
      Result.Add(Self.Data[i]);
      break; //inner loop
    end;
  end;
end;


function TTMGDataList.SublistByType(DataType : tTMGDataType) : TTMGDataList;
//returned list is created, but not considered owner of objects
var i : integer;
begin
  Result := TTMGDataList.Create;
  for i := 0 to Self.Count - 1 do begin
    if Self.Data[i].DataType <> DataType then continue;
    Result.Add(Self.Data[i]);
  end;
end;

function TTMGDataList.SublistByID(ID: string) : TTMGDataList;
//returned list is created, but not considered owner of objects
var i : integer;
begin
  Result := TTMGDataList.Create;
  for i := 0 to Self.Count - 1 do begin
    if Self.Data[i].ID  <> ID then continue;
    Result.Add(Self.Data[i]);
  end;
end;

function TTMGDataList.CountOfID(ID : string) : integer;
var i : integer;
begin
  Result := 0;
  for i := 0 to Self.Count - 1 do begin
    if Self.Data[i].ID = ID then inc(Result);
  end;
end;

function TTMGDataList.CountOfIEN(IEN : string) : integer;
var i : integer;
begin
  Result := 0;
  for i := 0 to Self.Count - 1 do begin
    if Self.Data[i].IEN = IEN then inc(Result);
  end;
end;

function TTMGDataList.DataByType(DataType : tTMGDataType; IndexByType : integer) : TTMGData;
var
  i,Index : integer;
  DataObj : TTMGData;
begin
  Result := nil;
  Index := -1;
  for i := 0 to Self.Count - 1 do begin
    DataObj := Self.Data[i];
    if DataObj.DataType <> DataType then continue;
    inc(Index);
    if Index <> IndexByType then continue;
    Result := DataObj;
    break;
  end;
end;

function TTMGDataList.DataByIDInstance(ID : string; Instance : integer) : TTMGData;
var index : integer;
begin
  Index := Self.IndexOfIDInstance(ID, Instance);
  Result := Self.Data[Index];
end;

function TTMGDataList.GetItem(Index : integer): TTMGData;
begin
  if (Index >= 0) and (Index < Self.Count) then begin
    Result := TTMGData(Self.Items[Index]);
  end else begin
    Result := nil;
  end;
end;

procedure TTMGDataList.PutItem(Index: Integer; Value: TTMGData);
begin
  Self.Items[Index] := Value;
end;

function TTMGDataList.IndexOfIEN(IEN : string; StartingIndex : integer = 0) : integer;
var i : integer;
begin
  Result := -1;
  for i := StartingIndex to Self.Count-1 do begin
    if Self.Data[i].IEN <> IEN then continue;
    Result := i;
    break;
  end;
end;

function TTMGDataList.IndexOfNameType(Name : string; DataType : tTMGDataType) : integer;
var i : integer;
begin
  Result := -1;
  for i := 0 to Self.Count-1 do begin
    if Self.Data[i].Name <> Name then continue;
    if Self.Data[i].DataType <> DataType then continue;
    Result := i;
    break;
  end;
end;


function TTMGDataList.IndexOfIDInstance(ID : string; Instance : integer) : integer;
var i : integer;
begin
  Result := -1;
  for i := 0 to Self.Count-1 do begin
    if Self.Data[i].ID <> ID then continue;
    if Self.Data[i].Instance <> Instance then continue;
    Result := i;
    break;
  end;
end;

//==============================================================================
//==============================================================================
{ NOTE: All user selection (e.g. clicking a checkbox) must ultimately generate a RESPONSE.
        These Responses will be sent back to the server and saved, and used on the server
        to compile the ouput display text of the order. And if the order is later
        edited, these Responses will be used to repopulate the dialog with the
        saved state of the order.

        So the following data relations are needed.

       DialogItemList (based on PROMPTS dialog definition from server)
          |
          | Accomplished via InitData();
          |
          v                                               Data2GUI()
       DataObj's, stored in CPRS in FTMGOrderData list  --------------->  GUI Elements on form
                   |  ^                                 <---------------
                   |  |                                   GUI2Data()
  Data2Responses() |  | Responses2Data()
                   |  |
                   v  |
       Responses (sync'ed with backend VistA server)

}
//==============================================================================
//==============================================================================

//-------------------------------------------------------------------------
// Server Definition --> Data
//-------------------------------------------------------------------------

procedure TfrmODTMG1.PlaceControls;   //call as part of standard VA order dialog handling.
var i : integer;
begin
  FCharHt := MainFontHeight;
  FCharWd := MainFontWidth;
  FEditorTop := HT_SPACE;
  FLabelWd := 0;
  //I'm not sure what this block does.  Needed??
  with FDialogItemList do begin
    for i := 0 to Count - 1 do with TDialogItem(Items[i]) do begin
      if not Hidden then FLabelWd := HigherOf(FLabelWd, Canvas.TextWidth(Prompt));
    end;
  end;
  FEditorLeft := FLabelWd + (WD_MARGIN * 2);

  Changing := true;

  cklbProcedures.Items.Clear;
  cklbDisplayedDxs.Items.Clear;
  cboBundles.Items.Clear;
  tcProcTabs.Tabs.Clear;

  InitData();  //load it all in

  //kt 12/3/23 -- AutoCheckPerOrderedLabs();     //duplicate.  Done in SetupDialog

  FFirstCtrl := cklbProcedures;
  tcProcTabs.TabIndex :=0;
  Changing := false;

  tcProcTabsChange(nil);    //trigger population of cklbProcedures
end;

procedure TfrmODTMG1.InitData();
{ NOTE: This procedure will load the data for dialog, which are mostly lists of
       procedures, diagnoses, bundles, etc.

  NOTE: The .ID property is mostly not unique between items (i.e. it IS duplicated)
        The DISPLAY TEXT (.Prompt property) will contain display name
        NOTE: Due to fileman configuration, the following chars are not allowed:  -,;^=
             These have been substituted in the text as below.  Need to substituted back here
               SET SPEC("-")="[!DS]"
               SET SPEC(";")="[!SC]"
               SET SPEC(",")="[!CM]"
               SET SPEC("^")="[!/\]"
               SET SPEC("=")="[!EQ]"

  NOTE: To avoid rewriting rpc ORWDXM PROMPTS, I am using the HELP MESSAGE (put into .HelpText)
          as a free text field to store structured text for additional data elements.  Format:
        -- First character must be '~' to be processed as data text
        -- Elements are delimited by ';'
        -- Defined Element terms as follows:
           - IEN      e.g. IEN=123              -- This is IEN from file #22751
           - TYPE     e.g. TYPE=P               -- Allowed types are:
                                                    D for DIALOG
                                                    L for LAB/PROCEDURE
                                                    B for BUNDLE;
                                                    I for ICD DX;
                                                    P for PAGE GROUP
                                                    O for ORDERING PROVIDER
                                                    T for LAB TIME
                                                    F for ORDER FLAGS
                                                    N for ORDER OPTIONS
                                                    X for ITEM DATA
                                                    E for Text fields
                                                    W for WP fields
           - ITEMS    e.g. ITEMS=54,28,194,73   -- Used by [B/BUNDLE],[P/GROUP], a way of defining elements in list
           - FASTING  e.g. FASTING=1            -- Used by lab/proc elements to show that default for labs should be fasting
           - LINKDX   e.g. LINKDX=1             -- Used by elements that need a specific linked Dx to be attached to them when ordering.
           - DX       e.g. DX=56,21,19,103      -- List of known Dx's that can be used when LINKDX=1

        Handling of types:
        [P]  -- Item should be added to cklbProcedures
        [I]  -- Item should be added to cklbDisplayedDxs
        [B]  -- Item should be added to cboBundles
        [P]  -- Item describes the name of a display groups.  E.g.: Basic, Rheum, Cardio, Renal, GI, Metab
        [O]  -- Item should be added to rgProvider, for ORDERING PROVIDER
        [T]  -- Item should be added to rgGetLabsTiming, for LAB TIME
        [F]  -- Item should be added to cklbFlags, for ORDER FLAGS
        [N]  -- Item should be added to cklbOther, for ORDER OPTIONS
}

  function {TfrmODTMG1.InitData.}GetValue(DataStr, KeyName : string; default : string='') : string; //extract data from special string
  //default is used if KeyName is found, but no value found.
  //If KeyName not found, then '' returned
  var SL : TStringList;
      index : integer;
  begin
    Result := '';
    if length(DataStr)<1 then exit;
    if DataStr[1] <> '~' then exit;
    SL := TStringList.Create;
    try
      DataStr := MidStr(DataStr, 2, Length(DataStr));
      PiecesToList(DataStr,';', SL);
      index := FindPiece(SL , '=', 1, KeyName); //find element containing KeyName
      if index > -1 then begin
        Result := piece(SL[index],'=',2);
        if Result='' then Result := default;
      end;
    finally
      SL.Free;
    end;
  end; //{TfrmODTMG1.InitData.}GetValue

  function {TfrmODTMG1.InitData.}GetDataType(DataTypeCh : string): tTMGDataType;
  const DATA_CH = '?DILBPOTFNXEW';  //NOTE: MUST BE 1:1 WITH tTMGDataType order
  var p : integer;
  begin
    p := Pos(DataTypeCh, DATA_CH); if p < 1 then p := 1;
    if (p >= ord(ttdtNone)) and (p <= ord(ttdtWPFld)) then Result := tTMGDataType(p)
    else Result := ttdtNone;
  end; //GetDataType

  function {TfrmODTMG1.InitData.}DecodeName(Name : string) : string;
  begin
    Result := Name;
    Result := StringReplace(Result,'[!DS]','-',[rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result,'[!SC]',';',[rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result,'[!CM]',',',[rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result,'[!/\]','^',[rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result,'[!EQ]','=',[rfReplaceAll, rfIgnoreCase]);
  end; //DecodeName

  procedure {TfrmODTMG1.InitData.}LoadRadioGroup(rg : TRadioGroup; DataType : tTMGDataType);
  var DataObj      : TTMGData;
      ChildDataObj : TTMGData;
      j, index     : integer;
  begin
    rg.Items.Clear;
    DataObj := FTMGOrderData.DataByType(DataType, 0);  //there should be only 1 of these....
    rg.Tag := integer(pointer(DataObj));  //this is object that will link to response storage
    DataObj.LinkedControl := rg;
    if Assigned(DataObj) then begin
      for j := 0 to DataObj.Items.Count-1 do begin
        ChildDataObj := TTMGData(DataObj.Items.Objects[j]);
        if not Assigned(ChildDataObj) then continue;
        index := rg.Items.AddObject(ChildDataObj.Name, ChildDataObj);
        ChildDataObj.Index := index;
      end;
      if rg.Items.count > 0 then begin
        rg.ItemIndex := 0;
        DataObj.Index := 0;
      end;
      DataObj.SavedValue := '-1'; //will ensure that value gets saved even if user leaves value at default initial value.
    end;
  end; //{TfrmODTMG1.InitData.}LoadRadioGroup

  procedure {TfrmODTMG1.InitData.}LoadCKListbox(lb : TCheckListbox; DataType : tTMGDataType);
  var
    i, index : integer;
    DataObj      : TTMGData;
    TempSubTMGDataList : TTMGDataList;
  begin
    TempSubTMGDataList := FTMGOrderData.SublistByType(DataType);  //TempSubTMGDataList doesn't own objects, but does need to be freed, not reused.
    lb.Items.Clear;
    try
      for i:= 0 to TempSubTMGDataList.Count - 1 do begin
        DataObj := TempSubTMGDataList.Data[i];
        if not Assigned(DataObj) then continue;
        if DataObj.Items.Count > 0 then continue;  //don't use any object with children.  Should be using only child objects themselves.
        index := lb.Items.AddObject(DataObj.Name,DataObj); //this is DataObj that will link to response storage
        DataObj.Index := index;
        DataObj.LinkedControl := lb;
      end;
    finally
      TempSubTMGDataList.Free;
    end;
  end; //{TfrmODTMG1.InitData.}LoadCKListbox

  procedure {TfrmODTMG1.InitData.}LoadEdits();
  var  DataObj : TTMGData;
       i,index : integer;
       edit : TEdit;
       TempSubTMGDataList : TTMGDataList;

  begin
    TempSubTMGDataList := FTMGOrderData.SublistByType(ttdtTextFld);
    try
      for i := 0 to TempSubTMGDataList.Count - 1 do begin
        index := -1;
        DataObj := TempSubTMGDataList.Data[i];
        if Pos(FREE_TEXT_LINK_LABPROC2DX, DataObj.Name)>0 then begin
          //This Text edit field obj is different.  It is not shown on GUI, and exists only to store linkage between a LabProc and any required Dx.
          continue;
        end else if Pos(FREE_TEXT_LAB, DataObj.Name)>0 then begin
          index := 5;  //NOTE: this number is determined by load sequence in TfrmODTMG1.InitData.  See details there
        end else if Pos(FREE_TEXT_DX, DataObj.Name)>0 then begin
          index := StrToIntDef(Piece2(DataObj.Name, FREE_TEXT_DX, 2),0);
          if (Index < 1) or (Index > 4) then continue;  //NOTE: these numbers are determined by load sequence in TfrmODTMG1.InitData.  See details there
        end else if DataObj.Name = FREE_TEXT_OTHER_TIME then begin
          index := 6;  //NOTE: this number is determined by load sequence in TfrmODTMG1.InitData.  See details there
        end;
        if (Index < 1) or (Index > 6) then continue; //NOTE: these numbers are determined by load sequence in TfrmODTMG1.InitData.  See details there
        edit := TEdit(FEditsList[index]);
        edit.tag := Integer(pointer(DataObj));  //this is DataObj that will link to response storage
        DataObj.LinkedControl := edit;
      end;
    finally
      TempSubTMGDataList.Free;   //doesn't own objects
    end;
  end; //{TfrmODTMG1.InitData.}LoadDxEdits()

  procedure {TfrmODTMG1.InitData.}LoadMemo(memo : TMemo);
  var  DataObj : TTMGData;
  begin
    DataObj := FTMGOrderData.DataByType(ttdtWPFld, 0);  //there should be only 1 of these....
    DataObj.LinkedControl := memo;
    memo.Tag := integer(pointer(DataObj));  //this is object that will link to response storage
  end;

  procedure {TfrmODTMG1.InitData.}LoadItems(AControl : TControl; SL : TStrings; DataObj : TTMGData; OnlyChildren : boolean);
  var Index : integer;
  begin
    if OnlyChildren and (DataObj.Items.Count > 0) then exit;  //don't add items that are just parents for the important children.
    Index := SL.AddObject(DataObj.Name,DataObj);
    DataObj.Index := Index;
    DataObj.LinkedControl := AControl;
  end;

  procedure {TfrmODTMG1.InitData.}LoadPriorICDs;
  var
    TempSL : TStringList;
    SortSL : TStringList;
    PartA,PartB : string;
    i,mode : integer;
    S,Name,ICD : string;
    DataStr : TDataStr;
    DataObj : TTMGData;

  CONST
    PROB_FORMAT        = 'ifn^status^LongName^ICD^onset^last modified^SC^SpExp^Condition^Loc^loc.type^prov^service^priority^has comment^date recorded^SC condition(s)^inactive flag^ICD long description^ICD coding system';
    PRIOR_CODE_FORMAT  = 'ICD^LongName^FMDT_LastUsed^ICDCODESYS';
    FORMATS : ARRAY[2..3] of string = (PROB_FORMAT, PRIOR_CODE_FORMAT);

  begin
    TempSL := TStringList.Create;
    SortSL := TStringList.Create;
    DataStr := TDataStr.Create;
    try
      CallV('TMG CPRS LAB ORDER GET DX LIST', [Patient.DFN]);
      FastAssign(RPCBrokerV.Results, TempSL);
      for i := 0 to TempSL.Count - 1 do begin
        s := TempSL[i];
        mode := StrToIntDef(piece(s,'^',1),0);
        if not (mode in [2,3]) then continue;
        s := pieces(s,'^',2,9999);
        DataStr.FormatStr := FORMATS[mode];
        DataStr.DataStr := s;
        DataObj := TTMGData.Create('-1', ttdtPriorICD);  //will be owned by FTMGOrderData
        Name := DataStr['LongName'];
        if Pos('<INACTIVE>', Name)>0 then continue;
        IF Pos('(SCT ',Name) > 0 then begin
          PartA := piece2(Name,'(SCT ',1);
          PartB := piece2(Name,'(SCT ',2);
          PartB := pieces2(PartB, ')',2,999);
          Name := Trim(PartA + PartB);
        end;
        ICD := DataStr['ICD'];
        DataObj.Name := Name + ' - ' + ICD;
        DataObj.ICD := ICD;
        SortSL.AddObject(DataObj.Name, DataObj); //won't ultimately own objects.
      end;
      SortSL.Sort;  //sort alphabetically by name.
      for i := 0 to SortSL.Count - 1 do begin
        DataObj := TTMGData(SortSL.Objects[i]);
        FTMGOrderData.Add(DataObj);  //owns objects
        FPriorDxList.Add(DataObj);  //Doesn't own objects
      end;
    finally
      TempSL.Free;
      SortSL.Free;
      DataStr.Free;
    end;
  end;


var
  i,j,k                             : Integer;
  IEN, DataStr, ItemsStr, DxLstStr  : string;
  DialogItem                        : TDialogItem;
  AllProcsDataObj, DataObj, TempObj : TTMGData;
  TempSL                            : TStringList;

begin //TfrmODTMG1.InitData
  FObjToStoreDxLinks := nil;
  //first load all items before potentially interlinking objects
  for i := 0 to FDialogItemList.Count - 1 do begin
    DialogItem := TDialogItem(FDialogItemList.Items[i]);
    DataObj := TTMGData.Create;   //will be owned by FTMGOrderData
    DataObj.ID := DialogItem.ID;
    DataObj.Instance := FTMGOrderData.CountOfID(DialogItem.ID)+1;
    DataObj.SourceIndex := i;
    DataObj.Name := DecodeName(DialogItem.Prompt);  //check and fix encoded chars
    DataStr := DialogItem.HelpText;
    DataObj.IEN := GetValue(DataStr, 'IEN', '0');
    DataObj.DataType := GetDataType(GetValue(DataStr, 'TYPE', '?'));
    if DataObj.DataType in [ttdtDx, ttdtProc, ttdtOrderFlags, ttdtOrderOptions] then begin
      DataObj.SetCheckedEtc(false);  //kt 12/3/23
      DataObj.ExternalValue := DataObj.Name;
    end;
    ItemsStr := GetValue(DataStr, 'ITEMS');
    PiecesToList(ItemsStr,',', DataObj.Items); //doesn't do anything if ItemsStr = ''
    if DataObj.DataType = ttdtProc then begin
      DataObj.Fasting := (GetValue(DataStr, 'FASTING') = '1');
      DataObj.NeedsLinkedDx := (GetValue(DataStr, 'LINKDX') = '1');
      DxLstStr := GetValue(DataStr, 'DX');  //csv list
      DataObj.LinkedDxStr := DxLstStr;
      //this causes problems --> if DxLstStr <> '' then PiecesToList(DxLstStr,',', DataObj.Items);
      //Normal Dx entries should not have 'ITEMS' data in DataStr.  Top level PROCS does.
    end;
    if (DataObj.DataType = ttdtDx) and (DataObj.Items.Count = 0) then FAllDxList.Add(DataObj);
    FTMGOrderData.Add(DataObj);
    if DataObj.Name = FREE_TEXT_LINK_LABPROC2DX then begin
      //NOTE: This data object is not shown on GUI.  It exists just as DATA to store linkage
      //      between LabProcs and needed linked Dx's
      FObjToStoreDxLinks := DataObj;
    end;
  end; //for loop
  LoadPriorICDs;

  //Make Entry to contain ALL labs/procedures
  AllProcsDataObj := TTMGData.Create;   //will be owned by FTMGOrderData
  AllProcsDataObj.Name := 'All';
  AllProcsDataObj.IEN := '0';
  AllProcsDataObj.DataType := ttdtPageGroup;
  FTMGOrderData.Insert(0,AllProcsDataObj);
  //added later .... tcProcTabs.Tabs.AddObject('All',AllProcsDataObj);

  //NOTE: Below is putting data into the GUI.  Really this could be done by Data2GUI(), I think;
  for i := 0 to FTMGOrderData.Count-1 do begin
    DataObj := FTMGOrderData.Data[i];
    case DataObj.DataType of
      ttdtDx:        LoadItems(cklbDisplayedDxs, cklbDisplayedDxs.Items, DataObj, true);
      ttdtProc:      LoadItems(cklbProcedures,   AllProcsDataObj.Items,  DataObj, true);
      ttdtBundle:    LoadItems(cboBundles,       cboBundles.Items,       DataObj, false);
      ttdtPageGroup: LoadItems(tcProcTabs,       tcProcTabs.Tabs,        DataObj, false);
      else           //do nothing....
    end; //case

    //If DataObj contains Items elements, then link Items.Objects[] to actual data objects
    for j := 0 to DataObj.Items.Count-1 do begin
      IEN := DataObj.Items.Strings[j];
      k := FTMGOrderData.IndexOfIEN(IEN);
      if k >= 0 then TempObj := FTMGOrderData.Data[k] else TempObj := nil;
      DataObj.Items.Objects[j] := tempObj;
    end;
  end; //for

  FCklbList.Add(cklbDisplayedDxs);
  FCklbList.Add(cklbProcedures);
  FCklbList.Add(cklbFlags);
  FCklbList.Add(cklbOther);
  FRgList.Add(rgProvider);
  FRgList.Add(rgGetLabsTiming);
  FEditsList.Add(nil);
  FEditsList.Add(edtDx0);        edtDx0.tag := 0;        //index 1 <-- used in LoadEdits
  FEditsList.Add(edtDx1);        edtDx1.tag := 0;        //index 2 <-- used in LoadEdits
  FEditsList.Add(edtDx2);        edtDx2.tag := 0;        //index 3 <-- used in LoadEdits
  FEditsList.Add(edtDx3);        edtDx3.tag := 0;        //index 4 <-- used in LoadEdits
  FEditsList.Add(edtOtherOrder); edtOtherOrder.tag := 0; //index 5 <-- used in LoadEdits
  FEditsList.Add(edtOtherTime);  edtOtherTime.tag := 0;  //index 6 <-- used in LoadEdits

  LoadRadioGroup(rgProvider, ttdtOrderingProvider);
  LoadRadioGroup(rgGetLabsTiming, ttdtLabTiming);
  LoadCKListbox(cklbFlags, ttdtOrderFlags);
  LoadCKListbox(cklbOther, ttdtOrderOptions);
  LoadEdits();
  LoadMemo(memOrderComment);

  for i := 0 to cklbFlags.Items.Count-1 do begin
    if cklbFlags.Items.Strings[i] <> 'Fasting' then continue;
    FOrderFlagFastingIndex := i;
    break;
  end;
end; //{TfrmODTMG1.InitData}

//-------------------------------------------------------------------------
// Manipulate Data
//-------------------------------------------------------------------------

procedure TfrmODTMG1.AutoCheckPerOrderedLabs();
var
   LabList : string;
   i,j : integer;
   LabName,DfltICD,OneTest : string;
   SubList, IEN22751 : string;
   NetErr, AnErr : string;
   CheckedTest:boolean;
begin
  //Call RPC to get list of items to auto-check.
  LabList := sCallV('TMG GET ORDERED LABS',[Patient.DFN]);
  CheckedTest := False;
  if LabList = 'NONE' then exit;
  NetErr := '';
  for i := 1 to NumPieces(LabList,'^') do begin
    OneTest := piece(LabList,'^',i);
    LabName := piece(OneTest,':',1);
    DfltICD := piece(OneTest,':',2);
    SubList := piece(OneTest,':',3);
    if LabName <> '' then begin
      SelectOrder(LabName, AnErr);
      CheckedTest := True;
      if NetErr <> '' then NetErr := NetErr + ';';
      NetErr := NetErr + AnErr; AnErr := '';
    end;
    if DfltICD <> '' then begin
      SelectDx(DfltICD, AnErr);
      if NetErr <> '' then NetErr := NetErr + ';';
      NetErr := NetErr + AnErr; AnErr := '';
    end;
    for j := 1 to NumPieces(SubList, ',') do begin
      IEN22751 := piece(SubList, ',', j);
      SelectIEN(IEN22751, AnErr);
      if NetErr <> '' then NetErr := NetErr + ';';
      NetErr := NetErr + AnErr; AnErr := '';
    end;
  end;
  //if CheckedTest then begin       //added if 11/28/23
  //   HandleCheckListBoxChange(cklbProcedures);
  //   UpdateOrderMemoDisplay;  //11/28/23 added in case
  //end;
  if NetErr <> '' then begin
    ShowMsg(NetErr);
  end;
end;

procedure TfrmODTMG1.LoadUserDxList(DxInfoList : TStringList);
//DxInfoList.Strings[x] should hold 1 selected Dx, in format: STD_ICD_DATA_FORMAT = 'ICDCode^ProblemText^ICDCode2^CodeStatus^ProblemIEN^ICDCodeSys';
var i : integer;
    S,Name,ICD : string;
    SortSL : TStringList;
    DataStr : TDataStr;
    DataObj : TTMGData;
begin
  if not assigned(DxInfoList) then exit;
  SortSL := TStringList.Create;
  DataStr := TDataStr.Create;
  DataStr.FormatStr := STD_ICD_DATA_FORMAT;
  try
    for i:= 0 to DxInfoList.Count - 1 do begin
      DataStr.DataStr := DxInfoList[i];  //STD_ICD_DATA_FORMAT
      DataObj := TTMGData.Create('-1', ttdtEncounterICD);  //will be owned by FTMGOrderData
      Name := DataStr['ProblemText'];
      if Pos('<INACTIVE>', Name)>0 then continue;
      ICD := DataStr['ICDCode'];
      DataObj.Name := Name + ' - ' + ICD;
      DataObj.ICD := ICD;
      SortSL.AddObject(DataObj.Name, DataObj);  //won't ultimately own objects.
    end;
    SortSL.Sort;  //sort alphabetically by name.
    for i := 0 to SortSL.Count - 1 do begin
      DataObj := TTMGData(SortSL.Objects[i]);
      FTMGOrderData.Add(DataObj);  //owns objects
      FEnctrDxList.Add(DataObj);   //Doesn't own objects
    end;
  finally
    SortSL.Free;
    DataStr.Free;
  end;
  //type tDxTCTabs = (tDxTCAll, tDxTCSpecific, tDxTCPrior, tDxTCEncounter);
  if tcDxSelect.Tabs.Count<4 then begin  //Ensure TabControl has code.
    tcDxSelect.Tabs.Add('Encounter Dx''s');
  end;
end;


function TfrmODTMG1.SelectOrder(OrderName : string; var ErrMsg : string) : boolean;
//Result is true if successful, false if failure (details in ErrMsg)
begin
  Result := SelectName(OrderName, ttdtProc, ErrMsg);
end;

function TfrmODTMG1.SelectDx(DxName : string; var ErrMsg : string) : boolean;
//Result is true if successful, false if failure (details in ErrMsg)
begin
  Result := SelectName(DxName, ttdtDx, ErrMsg);
end;

function TfrmODTMG1.SelectIEN(IEN22751 : string; var ErrMsg : string) : boolean;
//Result is true if successful, false if failure (details in ErrMsg)
var
  i : integer;
  DataObj : TTMGData;

begin
  Result := true; //default to success
  i := FTMGOrderData.IndexOfIEN(IEN22751);
  if i >= 0 then begin
    DataObj := FTMGOrderData.Data[i];
    //DataObj.Checked := true;
    DataObj.SetCheckedEtc(true);  //kt 12/3/23
    Data2Responses([DataObj]); //kt 12/3/23
    Data2GUI();
  end else begin
    Result := false;
    ErrMsg := 'Unable to find order matching IEN "' + IEN22751 + '" in file 22751.';
  end;
end;


function TfrmODTMG1.SelectName(Name : string; DataType: tTMGDataType; var ErrMsg : string) : boolean;
//Result is true if successful, false if failure (details in ErrMsg)
var
  i : integer;
  DataObj : TTMGData;

begin
  Result := true; //default to success
  i := FTMGOrderData.IndexOfNameType(Name, DataType);
  if i >= 0 then begin
    DataObj := FTMGOrderData.Data[i];
    //DataObj.Checked := true;
    DataObj.SetCheckedEtc(true); //kt 12/3/23
    Data2GUI();
    Data2Responses([DataObj]);  //kt 12/3/23
  end else begin
    Result := false;
    if Name='FUCPE' then exit;    //Don't show error for FUCPE   5/17/24
    ErrMsg := 'Unable to find order matching "' + Name + '"';
  end;
end;

procedure TfrmODTMG1.ClearData(ChangedDataObjs : TTMGDataList);
var
  i : integer;
  DataObj : TTMGData;

begin
  for i := 0 to FTMGOrderData.Count-1 do begin
    DataObj := FTMGOrderData.Data[i];
    if not DataObj.Checked and not (DataObj.LinkedControl is TRadioGroup) then continue;
    DataObj.Checked := false;
    ChangedDataObjs.Add(DataObj);
    case DataObj.DataType of
      ttdtWPFld,
      ttdtTextFld:           begin
                               DataObj.ExternalValue := '';
                             end;
      ttdtOrderingProvider,
      ttdtLabTiming:         begin
                               DataObj.Index := 0;
                               DataObj.ExternalValue := rgExternalValue(DataObj);
                             end;
      ttdtDx,
      ttdtProc,
      ttdtOrderFlags,
      ttdtOrderOptions,
      ttdtDialog,
      ttdtBundle,
      ttdtPageGroup,
      ttdtNone,
      ttdtItemData:          //do nothing
    end; //case
  end;
end;


//-------------------------------------------------------------------------
// Responses --> Data
//-------------------------------------------------------------------------

procedure TfrmODTMG1.Responses2Data();
var i : integer;
    IValue : string;
    DataObj : TTMGData;
    rg      : TRadioGroup;
    AResponse: TResponse;

begin
  for i := 0 to Responses.TheList.count -1 do begin
    AResponse := Responses.ResponseByIndex(i);
    DataObj := FTMGOrderData.DataByIDInstance(AResponse.PromptID, AResponse.Instance);
    if not Assigned(DataObj) then continue;
    DataObj.InternalValue := AResponse.IValue;
    DataObj.SavedValue    := AResponse.IValue;
    //DataObj.ExternalValue := AResponse.EValue;
    IValue := AResponse.IValue;
    case DataObj.DataType of
      ttdtDx,
      ttdtProc,
      ttdtOrderFlags,
      ttdtOrderOptions:      begin
                               DataObj.Checked := (IValue = 'Y') or (IValue = 'YES') or (IValue = '1');
                               DataObj.ExternalValue := DataObj.Name;
                             end;
      ttdtWPFld,
      ttdtTextFld:           begin
                               DataObj.ExternalValue := AResponse.EValue;
                               DataObj.Checked := (DataObj.ExternalValue <> '');
                             end;
      ttdtOrderingProvider,
      ttdtLabTiming:         begin
                               DataObj.Index := StrToIntDef(DataObj.InternalValue,-1);
                               DataObj.ExternalValue := rgExternalValue(DataObj);
                             end;
      ttdtDialog,
      ttdtBundle,
      ttdtPageGroup,
      ttdtNone,
      ttdtItemData:          //do nothing
    end; //case
  end; //for
end;


procedure TfrmODTMG1.SetupDialog(OrderAction: Integer; const ID: string);  //call as part of standard VA order dialog handling.
//Implement based on TfrmODGen.SetupDialog()
//var
  //theEvtInfo: string;
  //thePromptIen: integer;
  //AResponse: TResponse;
  //AnEvtResponse: TResponse;
  //DialogControl : TDialogCtrl; //kt
  //IValue : string;
  //DataObj  : TTMGData;

begin
  inherited;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then {with Responses do} begin
    Changing := True;
    if (Length(ID) > 0) and (DialogIEN = 0) then SetDialogIEN(DialogForOrder(ID));  // for copy & edit, SetDialogIEN hasn't been called yet

    Changing := false;

    if OrderAction<>ORDER_EDIT then begin //Only should autoclick during creation but not editing   4/5/24
        //kt 9/10/23 NOTE: Calls below set Gui->Data->Responses, thus saved responses from server are NOT getting put into GUI.
      rgClick(rgProvider);      //this will ensure value is saved, even is user leaves initial (default) value unchanged.
      rgClick(rgGetLabsTiming); //this will ensure value is saved, even is user leaves initial (default) value unchanged.
    end;
    Changing := True;
    Responses2Data();
    Data2GUI();

    {  //original VA code
    for i := 0 to FDialogCtrlList.Count -1 do begin
      DialogControl := TDialogCtrl(FDialogCtrlList.Items[i]); //kt   I added all 'DialogControl.' additions below. Purpose is easier debugging.
      if (DialogControl.ID = 'EVENT') and (Responses.EventIFN > 0) then begin
        thePromptIen := Responses.GetIENForPrompt(DialogControl.ID);
        if thePromptIen = 0 then begin
          thePromptIen := GetEventPromptID;
        end;
        AResponse := Responses.FindResponseByName('EVENT', 1);
        if AResponse <> nil then begin
          theEvtInfo := EventInfo1(AResponse.IValue);
          AResponse.EValue := Piece(theEvtInfo,'^',4);
        end;
        if AResponse = nil then begin
          AnEvtResponse := TResponse.Create;
          AnEvtResponse.PromptID  := 'EVENT';
          AnEvtResponse.PromptIEN := thePromptIen;
          AnEvtResponse.Instance  := 1;
          AnEvtResponse.IValue    := IntToStr(Responses.EventIFN);
          theEvtInfo := EventInfo1(AnEvtResponse.IValue);
          AnEvtResponse.EValue := Piece(theEvtInfo,'^',4);
          Responses.TheList.Add(AnEvtResponse);
        end;
      end;
      if DialogControl.Editor <> nil then Responses.SetControl(DialogControl.Editor, DialogControl.ID, 1);
      if DialogControl.DataType = 'H' then begin
        AResponse := Responses.FindResponseByName(DialogControl.ID, 1);
        if AResponse <> nil then begin
          DialogControl.IHidden := AResponse.IValue;
          DialogControl.EHidden := AResponse.EValue;
        end; //if AResponse
      end; //if DataType
    end; //for loop  //kt original --> with TDialogCtrl
    Changing := False;
  end; //if OrderAction
  }
  end;
  AutoCheckPerOrderedLabs;
  Changing := false;
  UpdateColorsFor508Compliance(Self);
  ControlChange(Self);
  //if (FFirstCtrl <> nil) and (FFirstCtrl.Enabled) then SetFocusedControl(FFirstCtrl);
end;

//-------------------------------------------------------------------------
// GUI --> Data  ( --> will call Responses )
//-------------------------------------------------------------------------

procedure TfrmODTMG1.memChange(Sender: TObject);   //GUI Change handler
//GUI2Data
var DataObj : TTMGData;
    memo    : TMemo;
begin
  if Changing then Exit;
  inherited;
  if not (Sender is TMemo) then exit;
  memo := TMemo(Sender);
  DataObj := TTMGData(memo.Tag);
  if not Assigned(DataObj) then exit;
  //DataObj.InternalValue := memo.Text;
  //DataObj.ExternalValue := memo.Text;
  //DataObj.Checked := (DataObj.ExternalValue <> '');
  DataObj.SetCheckedIVEV(DataObj.ExternalValue <> '', memo.Text, memo.Text);
  Data2Responses([DataObj]);
  UpdateOrderMemoDisplay;
end;

procedure TfrmODTMG1.cboBundlesChange(Sender: TObject);   //GUI Change handler
//GUI2Data
var
  i : integer;
  DataObj, ProcObj  : TTMGData;
  ChangedDataObjs : TTMGDataList;

begin
  if Changing then Exit;
  inherited;
  i := cboBundles.ItemIndex;
  if i < 0 then exit;
  DataObj := TTMGData(cboBundles.Items.Objects[i]);
  if not Assigned(DataObj) then exit;
  ChangedDataObjs := TTMGDataList.Create;  //doesn't own objects
  try
    for i := 0 to DataObj.Items.Count - 1 do begin
      ProcObj := TTMGData(DataObj.Items.Objects[i]);
      if not Assigned(ProcObj) then continue;
      //ProcObj.Checked := true;
      //ProcObj.InternalValue := '1';
      //ProcObj.ExternalValue := ProcObj.Name;
      ProcObj.SetCheckedIVEV(true, '1', ProcObj.Name);
    end;
    GetChangedObjsList(cklbProcedures, ChangedDataObjs);
    Data2Responses(ChangedDataObjs);
  finally
    ChangedDataObjs.Free; //doesn't own objects
  end;
  Data2GUI();
  UpdateOrderMemoDisplay;
end;

procedure TfrmODTMG1.cklbCommonClick(Sender: TObject);   //GUI Change handler
//GUI2Data
begin
  inherited;
  HandleCheckListBoxChange(Sender);
  UpdateOrderMemoDisplay;
end;

procedure TfrmODTMG1.CheckForFastingLabs();   //Called by a GUI Change handler
var i : integer;
    ProcList, ChangedDataObjs : TTMGDataList;
    DataObj : TTMGData;
    FastingOptionChanged : boolean;

begin
  if Changing then Exit;
  if FOrderFlagFastingIndex = -1 then exit;  //'Fasting' option wasn't found
  FastingOptionChanged := false;
  //See if any selected order is marked as Fasting.  If so, then check Fasting box....
  ChangedDataObjs := TTMGDataList.Create;  //doesn't own objects
  ProcList := FTMGOrderData.SublistByType(ttdtProc);  //doesn't own objects.  ProcList must be free'd
  try
    for i := 0 to ProcList.Count-1 do begin
      DataObj := ProcList.Data[i];
      if not Assigned(DataObj) or not DataObj.Checked or not DataObj.Fasting then continue;
      //Change DataObj to object for Fasting checkbox
      if cklbFlags.Checked[FOrderFlagFastingIndex] = true then break;  //already set true;
      DataObj := TTMGData(cklbFlags.Items.Objects[FOrderFlagFastingIndex]);
      if not Assigned(DataObj) then continue;
      cklbFlags.Checked[FOrderFlagFastingIndex] := true;
      FastingOptionChanged := true;
      break;
    end;
    if FastingOptionChanged then HandleCheckListBoxChange(cklbFlags);
  finally
    ChangedDataObjs.Free; //doesn't own objects
    ProcList.Free;  //doesn't own objects.
  end;
end;

procedure TfrmODTMG1.CheckForPromptToPrint();  //Called by a GUI Change Handler
begin
end;

procedure TfrmODTMG1.StoreLinkedDxs;  //Called (indirectly) by a GUI Change handler <-- HandleCheckListBoxChange
  //Store the linkage state of all linked LabProcs.
  //NOTE: This linkage is about a test, such as PSA, being linked to 1 specific Diagnosis.  E.g. 'Personal History of Prostate Cancer'
  //Items stored into FObjToStoreDxLinks
var
  i, j : integer;
  TempObj  : TTMGData;    //doesn't own object
  LinkedObj : TTMGData;  //doesn't own object
  LinkStr : string;
  LinkedDxList : TTMGDataList;
begin
  if not assigned(FObjToStoreDxLinks) then exit;
  if not assigned(FProcAndDxLinksList) then exit;
  FProcAndDxLinksList.Clear;        //EDDIE Added this. Duplicates were being added with each run
  LinkStr := '';
  //Scan through all Procs, and see if they have linked Dx's that have been selected.
  for i := 0 to FTMGOrderData.Count - 1 do begin
    TempObj := FTMGOrderData[i];
    if TempObj.DataType <> ttdtProc then continue;
    if TempObj.LinkedDxStr = '' then continue;
    if TempObj.Checked=False then continue;   //ELH added 4/2/24
    LinkedDxList := TempObj.AllowedLinkedDxList(FTMGOrderData);
    for j := 0 to LinkedDxList.Count - 1 do begin
      LinkedObj := LinkedDxList[j];
      if not LinkedObj.Checked then continue;
      FProcAndDxLinksList.Add(TempObj); FProcAndDxLinksList.Add(LinkedObj);  //always added in pairs 
      if LinkStr <>'' then LinkStr := LinkStr + ',';
      LinkStr := LinkStr + TempObj.IEN + ':' + LinkedObj.IEN;  // IEN1:IEN2,.....  IEN1 LabProc is linked to IEN2 Dx
    end;
  end;
  FObjToStoreDxLinks.SetCheckedIVEV(LinkStr <> '', LinkStr, LinkStr);
  Data2Responses([FObjToStoreDxLinks]);
end;

function TfrmODTMG1.AddOrRemovePriorDx(EditCtrl: TEdit; Checked : boolean; Str : string; DivChar : char = '^') : boolean;
//Returns TRUE if EditCtrl was changed.
var StartPos : integer;
    PartA,PartB : string;
begin
  Result := false;
  StartPos := Pos(Str, EditCtrl.Text);
  if Checked then begin
    if StartPos = 0 then begin
      EditCtrl.Text := EditCtrl.Text + Str + DivChar;
      Result := true;
    end;
  end else begin
    if StartPos > 0 then begin
      PartA := LeftStr(EditCtrl.Text, StartPos-1);
      PartB := MidStr(EditCtrl.Text, StartPos + Length(Str) + 1, 9999999);
      EditCtrl.Text := PartA + PartB;
      Result := true;
    end;
  end;
end;

procedure TfrmODTMG1.TriggerDelayedProcInfo();
begin
  tmrDelayProcInfo.Enabled := true;
end;

procedure TfrmODTMG1.tmrDelayProcInfoTimer(Sender: TObject);
var
    LabDataMemo:TStringList;
begin
  inherited;
  tmrDelayProcInfo.Enabled := false;
  //finish.
  memProcInfo.Text := ''; //clear prior.
  if not assigned(FLastSelectedProc) then exit;
  LabDataMemo := TStringList.create();
  tCallV(LabDataMemo,'TMG CPRS ENC LAB DATA',[Patient.DFN,FLastSelectedProc.IEN,FLastSelectedProc.Name]);
  memProcInfo.Lines.Assign(LabDataMemo);
  LabDataMemo.Free;
  //call RPC to get info about FLastSelectedProc, and put output into memProcInfo
  //NOTE: FLastSelectedProc is TTMGData
end;

procedure TfrmODTMG1.HandleCheckListBoxChange(Sender : TObject);  //Called by a GUI Change handler

//GUI2Data
var ChangedDataObjs : TTMGDataList;
    CkLb            : TCheckListBox;
    i, num          : integer;
    DataObj         : TTMGData;
    ShowSpecificDx  : Boolean;
begin
  if Changing then Exit;
  inherited;
  if not (Sender is TCheckListBox) then exit;
  CkLb := TCheckListBox(Sender);

  //If user selected a Test / Proc, then adjust Dx control tabs so that relevant Dx panel is shown.
  if CkLb = cklbProcedures then begin
    //remember last selected entry if Lab/Proc selected.
    //NOTE: If a checkbox is toggled, then .Checked[i] and .Selected[i] will be modified
    //      But if just the name of the item is selected then just .Selected[i] will be changed, regardless of its checked status
    FLastSelectedProc := nil;
    for i := 0 to CkLb.Items.Count - 1 do begin
      if not CkLb.Selected[i] then continue;
      FLastSelectedProc := TTMGData(CkLb.Items.Objects[i]);
      Break;
    end;
    if Assigned(FLastSelectedProc) then begin
      ShowSpecificDx := FLastSelectedProc.NeedsLinkedDx or (FLastSelectedProc.LinkedDxStr <> '');
      TriggerDelayedProcInfo();
    end else begin
      ShowSpecificDx := False;
    end;
    ChangeDxSelect4Mode(ShowSpecificDx);
  end;

  ChangedDataObjs := TTMGDataList.Create;  //doesn't own objects
  try
    CheckedGUI2Data(TCheckListBox(Sender),ChangedDataObjs);
    Data2Responses(ChangedDataObjs);
    if CkLb = cklbDisplayedDxs then begin
      for i := 0 to CkLb.Items.Count - 1 do begin
        if not CkLb.Selected[i] then continue;
        DataObj := TTMGData(CkLb.Items.Objects[i]);
        if not (DataObj.DataType in [ttdtPriorICD, ttdtEncounterICD]) then break; //Types are not mixed.  If one is not present, then none are.
        //if AddOrRemovePriorDx(edtDx3, DataObj.Checked, DataObj.Name) then begin
        if AddOrRemovePriorDx(edtDx3, DataObj.Checked, DataObj.ICD) then begin
          Data2Responses([TTMGData(edtDx3.Tag)]);
        end;
      end;
    end;
    if CkLb = cklbProcedures then begin
      CheckForFastingLabs();
    end;
  finally
    ChangedDataObjs.Free; //doesn't own objects
  end;
  StoreLinkedDxs;
  //ControlChange(Sender);
end;

procedure TfrmODTMG1.edtEditChange(Sender: TObject);   //GUI Change handler
//GUI2Data
var Edit    : TEdit;
    DataObj : TTMGData;
begin
  if Changing then Exit;
  inherited;
  if not (Sender is TEdit) then exit;
  Edit:= TEdit(Sender);
  DataObj := TTMGData(Edit.Tag);
  //DataObj.InternalValue := Edit.Text;
  //DataObj.ExternalValue := Edit.Text;
  //DataObj.Checked := (Edit.Text <> '');
  DataObj.SetCheckedIVEV(Edit.Text <> '', Edit.Text, Edit.Text);
  Data2Responses([DataObj]);
  UpdateOrderMemoDisplay;
end;

function TfrmODTMG1.rgExternalValue(DataObj : TTMGData) : string;
var rg : TRadioGroup;
begin
  Result := '';
  if not (DataObj.LinkedControl is TRadioGroup) then exit;
  rg := TRadioGroup(DataObj.LinkedControl);
  Result := IfThen(rg.ItemIndex>=0, rg.Items.Strings[rg.ItemIndex], '');
end;

procedure TfrmODTMG1.rgClick(Sender: TObject);   //GUI Change handler
//GUI2Data
var DataObj : TTMGData;
    rg : TRadioGroup;
    tempS : string;
begin
  if Changing then Exit;
  inherited;
  if not (Sender is TRadioGroup) then exit;
  rg := TRadioGroup(Sender);
  DataObj := TTMGData(rg.Tag);
  if not Assigned(DataObj) then exit;
  DataObj.Index := rg.ItemIndex;
  DataObj.InternalValue := IntToStr(rg.ItemIndex);
  DataObj.ExternalValue := rgExternalValue(DataObj);
  if DataObj.ExternalValue='Other Time' then begin         //elh    8/22/23
    tempS := InputBox('Lab Order','What is the timeframe for these labs.','');
    SetOtherTimeEnable(true);
    edtOtherTime.Text := tempS; //NOTE: this will fire edtEditChange() putting GUI->data
  end else begin
    SetOtherTimeEnable(false);
    edtOtherTime.Text := '';   //NOTE: this will fire edtEditChange() putting GUI->data
  end;
  if DataObj.ExternalValue='Today' then cklbOther.Checked[3] := True;  //ELH added 10/13/23
  Data2Responses([DataObj]);
  UpdateOrderMemoDisplay;
end;

procedure TfrmODTMG1.SetOtherTimeEnable(Enable : boolean);
begin
  lblWhen.Enabled := Enable;
  edtOtherTime.Enabled := Enable;
  edtOtherTime.Visible := Enable;
end;

procedure TfrmODTMG1.GetChangedObjsList(ListBox : TCheckListBox; ChangedDataObjs : TTMGDataList);  //Called by a GUI Change handler
var i : integer;
  DataObj  : TTMGData;
begin
  for i := 0 to ListBox.Items.Count-1 do begin
    DataObj := TTMGData(ListBox.Items.Objects[i]);
    if not Assigned(DataObj) then continue;
    ListBox.Checked[i] := DataObj.Checked;
    ChangedDataObjs.Add(DataObj);
  end;
end;

procedure TfrmODTMG1.CheckedGUI2Data(ListBox : TCheckListBox; ChangedDataObjs : TTMGDataList);  //Called by a GUI Change handler
var i : integer;
  DataObj  : TTMGData;
begin
  for i := 0 to ListBox.Items.Count-1 do begin
    DataObj := TTMGData(ListBox.Items.Objects[i]);
    if not Assigned(DataObj) then continue;
    DataObj.SetCheckedEtc(ListBox.Checked[i]);  //kt 12/3/23
    //DataObj.Checked := ListBox.Checked[i];
    //DataObj.InternalValue := N_Y[DataObj.Checked];
    //DataObj.ExternalValue := IfThen(DataObj.Checked, DataObj.Name, '');
    if DataObj.Modified then begin
      ChangedDataObjs.Add(DataObj);
    end;
  end;
end;

//-------------------------------------------------------------------------
// Data --> GUI
//-------------------------------------------------------------------------

procedure TfrmODTMG1.Data2GUI();
//Data2GUI
var i : integer;
    DataObj  : TTMGData;
    AControl : TControl;
    rg       : TRadioGroup;
    lb       : TCheckListBox;
    edit     : TEdit;
    memo     : TMemo;
    index     : integer;

  procedure UncheckLB(lb : TCheckListBox);
  var i : integer;
  begin
    if not Assigned(lb) then exit;
    for i := 0 to lb.Items.Count-1 do lb.checked[i] := false;
  end;

  procedure BubbleUpCheckedItems(lb : TCheckListBox);
  var i : integer;
      LastChecked : integer;
  begin
    LastChecked := -1;
    if not Assigned(lb) then exit;
    for i := 0 to lb.Items.Count-1 do begin
      if not lb.Checked[i] then continue;
      lb.Items.Move(i, LastChecked+1);
      LastChecked := LastChecked+1;
    end;
  end;

begin //TfrmODTMG1.Data2GUI()
  Changing := true;
  //Clear all prior GUI selections or user input
  for i := 0 to FCklbList.Count - 1  do UncheckLB(TCheckListBox(FCklbList[i]));
  for i := 0 to FRgList.Count - 1    do TRadioGroup(FRgList[i]).ItemIndex := -1;
  for i := 0 to FEditsList.Count - 1 do TEdit(FEditsList[i]).Text := '';
  memOrderComment.Text := '';

  for i := 0 to FTMGOrderData.Count-1 do begin
    DataObj := FTMGOrderData.Data[i];
    AControl := DataObj.LinkedControl;
    if not assigned(AControl) then continue;
    if AControl is TCheckListBox then begin
      lb := TCheckListBox(AControl);
      if lb = cklbProcedures then continue;    //this will be handled separately by triggering a pseudo tab page change: tcProcTabsChange()
      if lb = cklbDisplayedDxs then continue;  //this will be handled separately by triggering a pseudo tab page change: tcDxSelectChange()   //kt add 7/2/24
      if DataObj.Items.Count > 0 then continue; //Parent object isn't part of GUI -- only child objects have separate data stores.  So skip.
      index := DataObj.Index;
      lb.Checked[Index] := DataObj.Checked;
    end else if AControl is TRadioGroup then begin
      rg := TRadioGroup(AControl);
      if DataObj.Items.Count = 0 then continue;  //this is a child object, and it doesn't have a separate data store -- only parent does.  So skip.
      index := DataObj.Index;
      rg.ItemIndex := index;
    end else if AControl is TEdit then begin
      edit := TEdit(AControl);
      edit.Text := DataObj.ExternalValue;
      if DataObj.Name = FREE_TEXT_OTHER_TIME then begin
        SetOtherTimeEnable(edit.Text <> '');
      end;
    end else if AControl is TMemo then begin
      memo := TMemo(AControl);
      memo.Text := DataObj.ExternalValue;
    end;
  end;
  tcProcTabsChange(self);  //handle cklbProcedures for currently displayed tab page.
  tcDxSelectChange(tcDxSelect); //kt add 7/2/24
  BubbleUpCheckedItems(cklbDisplayedDxs);
  Changing := false;
  UpdateOrderMemoDisplay;
end;

procedure TfrmODTMG1.ChangeDxSelect4Mode(ShowSpecificDx : Boolean);
var NewIndex : integer;
const  TAB_INDEX : array[false..true] of integer = (ord(tDxTCAll), ord(tDxTCSpecific));
begin
  NewIndex := TAB_INDEX[ShowSpecificDx];
  if (tcDxSelect.TabIndex = NewIndex) and not ShowSpecificDx then exit; //avoid trigger event if no actual change.
  tcDxSelect.TabIndex := NewIndex; //doesn't seem to triggers event.
  tcDxSelectChange(tcDxSelect);    //so manually trigger event now.
end;

procedure TfrmODTMG1.tcDxSelectChange(Sender: TObject);
var  TC : TTabControl;
     SelTab : tDxTCTabs;
     Source : TTMGDataList;  //doesn't own objects
begin
  inherited;
  if not (Sender is TTabControl) then exit;
  TC := TTabControl(Sender);
  SelTab := tDxTCTabs(TC.TabIndex);
  memDxInstructions.Lines.Clear;
  case SelTab of
    tDxTCAll:       begin
                      PopulateCkLb(cklbDisplayedDxs, FAllDxList);
                      memDxInstructions.Lines.Add('Select Diagnosis');
                    end;
    tDxTCSpecific:  begin
                      if assigned(FLastSelectedProc) then begin
                        Source := FLastSelectedProc.AllowedLinkedDxList(FTMGOrderData);
                        PopulateCkLb(cklbDisplayedDxs, Source);
                        if Source.Count > 0 then begin
                          memDxInstructions.Lines.Add('Select SPECIFIC Diagnosis');
                        end else begin
                          memDxInstructions.Lines.Add('No SPECIFIC Diagnosis defined');
                          memDxInstructions.Lines.Add('for this selected test.');
                        end;
                      end;
                    end;
    tDxTCPrior:     begin
                      cklbDisplayedDxs.Items.Clear;   //<-- shouldn't be needed.  Remove later?
                      PopulateCkLb(cklbDisplayedDxs, FPriorDxList);
                      memDxInstructions.Lines.Add('Select Custom prior Dx');
                    end;
    tDxTCEncounter: begin
                      PopulateCkLb(cklbDisplayedDxs, FEnctrDxList);
                      memDxInstructions.Lines.Add('Select Dx from Encounter');
                    end;
  end;
end;

procedure TfrmODTMG1.PopulateCkLb(CkLb : TCheckListBox; Source : TTMGDataList);
//Data2GUI
  procedure PopulateByCheckedState(State : boolean);
  var
    i,j      : integer;
    DataObj  : TTMGData;
  begin
    for i := 0 to Source.Count-1 do begin
      DataObj := Source.Data[i];
      if not Assigned(DataObj) then continue;
      if DataObj.Checked <> State then continue;
      j := CkLb.Items.AddObject(DataObj.Name, DataObj);  // CkLb does not own objects
      DataObj.Index := j;
      CkLb.Checked[j] := DataObj.Checked;
    end;
  end;

begin
  CkLb.Items.Clear;  //doesn't own objects
  if not Assigned(Source) then exit;
  PopulateByCheckedState(true);    //First, just add checked items
  PopulateByCheckedState(false);   //Next, add just NON-checked items
end;

procedure TfrmODTMG1.PopulateCkLb(CkLb : TCheckListBox; Source : TStringList);
//Data2GUI
var
  DL : TTMGDataList;
begin
  DL := TTMGDataList.Create; //won't own objects
  try
    Items2DataList(Source, DL);
    PopulateCkLb(CkLb, DL);
  finally
    DL.Free;
  end;
end;

procedure TfrmODTMG1.Items2DataList(Items : TStringList; DL : TTMGDataList);
//NOTE:  This is for a Items that is populated with TTMGData objects.
var
  i          : integer;
  DataObj    : TTMGData;
  Obj        : TObject;
begin
  for i := 0 to Items.Count-1 do begin
    Obj := Items.Objects[i];
    if not (Obj is TTMGData) then continue;
    DataObj := TTMGData(Items.Objects[i]);
    DL.Add(DataObj);
  end;
end;

procedure TfrmODTMG1.tcProcTabsChange(Sender: TObject);
//Data2GUI
var
  i        : integer;
  DataObj  : TTMGData;
begin
  inherited;
  //Handle loading / showing labs
  cklbProcedures.Items.Clear;  //doesn't own objects
  i := tcProcTabs.TabIndex;
  if i < 0  then exit;
  DataObj := TTMGData(tcProcTabs.Tabs.Objects[i]);
  if not Assigned(DataObj) then exit;
  PopulateCkLb(cklbProcedures, DataObj.Items);
end;


//-------------------------------------------------------------------------
// Data -> Responses
//-------------------------------------------------------------------------

procedure TfrmODTMG1.ControlChange(Sender: TObject);
begin
  //inherited;
end;

procedure TfrmODTMG1.Data2Responses(Arr : array of TTMGData);  //version accepting dynamic array parameter
var  ChangedDataObjs : TTMGDataList;
     i : integer;
begin
  if Changing then Exit;
  ChangedDataObjs := TTMGDataList.Create;  //doesn't own objects
  try
    for i := 0 to High(Arr) do ChangedDataObjs.Add(Arr[i]);
    Data2Responses(ChangedDataObjs);
  finally
    ChangedDataObjs.Free; //doesn't own objects
  end;
end;

procedure TfrmODTMG1.Data2Responses(ChangedDataObjs : TTMGDataList);
//NOTE: Responses is a key:value1,value2 storage that is synced with the ORDER on the server.
var
  i         : Integer;
  IV        : string;
  DataObj   : TTMGData;
begin
  if Changing then Exit;
  for i := 0 to ChangedDataObjs.Count-1 do begin
    DataObj := ChangedDataObjs.Data[i];
    if not DataObj.Modified then continue;
    if not (DataObj.Datatype in [ttdtDx,
                                 ttdtProc,
                                 ttdtTextFld,
                                 ttdtOrderFlags,
                                 ttdtOrderOptions,
                                 ttdtOrderingProvider,
                                 ttdtLabTiming,
                                 ttdtWPFld
                                ]                      ) then continue;
    IV := IfThen(DataObj.Datatype = ttdtWPFld, TX_WPTYPE, DataObj.InternalValue);
    Responses.Update(DataObj.ID, DataObj.Instance, IV, DataObj.ExternalValue);
    DataObj.SavedValue := DataObj.InternalValue;
  end;  //for

  //TO DO  12/19/23  cycle through all objects and get any linked diagnoses, and output them to storage responses element.

  { -- Below is copied VA code ... Delete later after getting the Responses stuff working.
  for i := 0 to FDialogCtrlList.Count - 1 do begin
    DialogCtrl := TDialogCtrl(FDialogCtrlList.Items[i]);
    Editor := DialogCtrl.Editor;
    case DialogCtrl.DataType of
      'D': Responses.Update(DialogCtrl.ID, 1, FloatToStr(TORDateBox(DialogCtrl.Editor).FMDateTime), TORDateBox(Editor).Text);
      'F': Responses.Update(DialogCtrl.ID, 1, TEdit(Editor).Text,                                   TEdit(Editor).Text);
      'H': Responses.Update(DialogCtrl.ID, 1, DialogCtrl.IHidden,                                   DialogCtrl.EHidden);
      'N': Responses.Update(DialogCtrl.ID, 1, TEdit(Editor).Text,                                   TEdit(Editor).Text);
      'P': Responses.Update(DialogCtrl.ID, 1, TORComboBox(Editor).ItemID,                           TORComboBox(Editor).Text);
      'R': Responses.Update(DialogCtrl.ID, 1, TORDateBox(Editor).Text,                              TORDateBox(Editor).Text);
      'S': Responses.Update(DialogCtrl.ID, 1, TORComboBox(Editor).ItemID,                           TORComboBox(Editor).Text);
      'W': Responses.Update(DialogCtrl.ID, 1, TX_WPTYPE,                                            TMemo(Editor).Text);
      'Y': Responses.Update(DialogCtrl.ID, 1, TORComboBox(Editor).ItemID,                           TORComboBox(Editor).Text);
    end;
  end;
  memOrder.Text := Responses.OrderText;  //<--- key part here!
  }

end;

//-------------------------------------------------------------------------
// Misc stuff
//-------------------------------------------------------------------------
function TfrmODTMG1.UpdateOrderMemoDisplay : string;

var OrderProvider, LabTiming, LabTimingOther, ProcString, DxStr : string;
    SickPt, StandingOrder, Fasting : boolean;
    BalladOrder, OutsideOrder, PrintPrompt, AutoSign, ForHospital : boolean;
    DataObj, DxObj : TTMGData;
    i,j,k : integer;
    SelectedDxList, SelectedProcList, CommentSL : TStringList;
    Str : string;
    TempSubTMGDataList : TTMGDataList;
    WorkingProcAndDxLinksList : TTMGDataList; //doesn't own objects

  function GetBool(ListBox : TCheckListBox; Index: integer) : boolean;  //default is false
  begin
    Result := false;
    if (Index < 0 ) or (Index >= ListBox.Items.Count) then exit;
    Result := ListBox.Checked[Index];
  end;

  function GetRGValue(AType: tTMGDataType) : string;
  var
    DataObj, ChildObj : TTMGData;
    i : integer;
  begin
    Result := '';  //default
    DataObj := FTMGOrderData.DataByType(AType, 0);
    if not Assigned(DataObj) then exit;
    i := DataObj.Index;
    if (i <0 ) or (i >= DataObj.Items.Count) then exit;
    ChildObj := TTMGData(DataObj.Items.Objects[i]);
    if not assigned(ChildObj) then exit;
    Result := ChildObj.Name;
  end;

  function SearchEditText(SrchStr : string) : string;
  var  TempSubTMGDataList : TTMGDataList;
       DataObj            : TTMGData;
       i                  : integer;
  begin
    Result := ''; //default
    TempSubTMGDataList := FTMGOrderData.SublistByType(ttdtTextFld);
    for i := 0 to TempSubTMGDataList.Count - 1 do begin
      DataObj := TempSubTMGDataList.Data[i];
      if DataObj.Name <> SrchStr then continue;
      Result := DataObj.ExternalValue;
      break;
    end;
    TempSubTMGDataList.Free;
  end;


  function SearchCKLBbool(AType: tTMGDataType; SrchStr : string) : bool;
  var  TempSubTMGDataList : TTMGDataList;
       DataObj            : TTMGData;
       i                  : integer;
  begin
    Result := false; //default
    TempSubTMGDataList := FTMGOrderData.SublistByType(AType);
    for i := 0 to TempSubTMGDataList.Count - 1 do begin
      DataObj := TempSubTMGDataList.Data[i];
      if DataObj.Name <> SrchStr then continue;
      Result := DataObj.Checked;
      break;
    end;
    TempSubTMGDataList.Free;
  end;

begin //TfrmODTMG1.UpdateOrderMemoDisplay
  OrderProvider  := GetRGValue(ttdtOrderingProvider);
  LabTiming      := GetRGValue(ttdtLabTiming);
  SickPt         := SearchCKLBbool(ttdtOrderFlags,   'Sick Patient');
  StandingOrder  := SearchCKLBbool(ttdtOrderFlags,   'Standing Order');
  Fasting        := SearchCKLBbool(ttdtOrderFlags,   'Fasting');
  BalladOrder    := SearchCKLBbool(ttdtOrderOptions, 'Ballad Order');
  OutsideOrder   := SearchCKLBbool(ttdtOrderOptions, 'Outside Order');
  PrintPrompt    := SearchCKLBbool(ttdtOrderOptions, 'Prompt To Print');
  AutoSign       := SearchCKLBbool(ttdtOrderOptions, 'AutoSign Order');
  FPromptToPrint := PrintPrompt;  //used during form close out
  FFasting       := Fasting;      //used during form close out
  if LabTiming='Other Time' then begin
    //LabTiming := FLabTimingStrOther;  //elh    8/22/23
    LabTimingOther := SearchEditText(FREE_TEXT_OTHER_TIME);
    if LabTimingOther <> '' then LabTiming := LabTiming + ': ' + LabTimingOther;
  end;
  FLabTimingStr  := LabTiming;    //used during form close out

  SelectedDxList   := TStringList.Create;
  SelectedProcList := TStringList.Create;
  CommentSL        := TStringList.Create;
  WorkingProcAndDxLinksList := TTMGDataList.Create;

  TempSubTMGDataList := FTMGOrderData.SublistByType(ttdtDx);  //TempSubTMGDataList doesn't own objects, but does need to be freed, not reused.
  try
    for i := 0 to TempSubTMGDataList.Count-1 do begin
      DataObj := TempSubTMGDataList.Data[i];
      if not DataObj.Checked then continue;
      Str := DataObj.ExternalValue;
      //NOTE: if Str is data from edit field, then perhaps it contains multiple items, comma-separated.  Might need to split out...
      SelectedDxList.Add(Str);
    end;
    TempSubTMGDataList.Free; //TempSubTMGDataList doesn't own objects, but does need to be freed, not reused.

    for i := 0 to FTMGOrderData.CountOfType(ttdtProc)-1 do begin
      DataObj := FTMGOrderData.DataByType(ttdtProc, i);
      if not DataObj.Checked then continue;
      if FProcAndDxLinksList.IndexOf(DataObj) > -1 then continue;  //These selected LabProcs will be handled separately.
      Str := DataObj.ExternalValue;
      SelectedProcList.Add(Str);
    end;

    TempSubTMGDataList := FTMGOrderData.SublistByType(ttdtTextFld);  //TempSubTMGDataList doesn't own objects, but does need to be freed, not reused.
    for i := 0 to TempSubTMGDataList.Count-1 do begin   //This is list of edit boxes.  This includes both Dx and Procedure edit boxes.
      DataObj := TempSubTMGDataList.Data[i];
      if not DataObj.Checked then continue;
      Str := DataObj.ExternalValue;
      //NOTE: if Str is data from edit field, then perhaps it contains multiple items, comma-separated.  Might need to split out...
      if DataObj.Name = FREE_TEXT_DX_SPECIAL then begin
        //kt NOTE: Below is a bit hacky.  But the output of this function, into the TMemo field, is NOT the real order.
        //           It is just something for the user to see while choosing tests.  The real text of the order is
        //           determined by the server later.
        //         The reason for the changes is because the single text field ultimately gets stored into
        //           a data field on the server, and I think it is not long enough to store both
        //           the ICD codes AND their names. The names can be quite long.  So I will cheat and
        //           store only the ICD codes in the text field, but still show the ICD names for the user, and get
        //           the the names directly from FEnctrDxList for the purposes of output to TMemoField.
        for j := 0 to FEnctrDxList.Count - 1 do begin
          DxObj := FEnctrDxList[j];
          if not DxObj.Checked then continue;
          if not (DxObj.DataType in [ttdtPriorICD, ttdtEncounterICD]) then break; //Types are not mixed.  If one is not present, then none are.
          SelectedDxList.Add(DxObj.Name);
        end;
      end else if Contains(DataObj.Name, FREE_TEXT_DX) then begin
        SelectedDxList.Add(Str);
      end else if DataObj.Name = FREE_TEXT_LAB then begin
        SelectedProcList.Add(Str);
      end;
    end;

    DataObj := FTMGOrderData.DataByType(ttdtWPFld, 0);
    if Assigned(DataObj) then begin
      CommentSL.Text := DataObj.ExternalValue ;  //may be multiple lined
    end;

    ForHospital := (BalladOrder or OutsideOrder);

    //Assemble beginning section
    Result := IfThen(Fasting, 'FASTING', 'NON-FASTING') + ' LABS ' + Uppercase(LabTiming);
    if StandingOrder then Result := Result + ' - STANDING ORDER';
    if SickPt then Result := 'SICK PATIENT'+ CRLF + '.'+CRLF+Result;
    Result := Result+ CRLF + '.'+CRLF;

    //Check for GHP components... if so remove TSH, CBC, and CMP... then add GHP
    i := SelectedProcList.IndexOf('TSH');
    j := SelectedProcList.IndexOf('CMP');
    k := SelectedProcList.IndexOf('CBC-Platelet With Diff.');
    if (i>-1) and (j>-1) and (k>-1) then begin
      SelectedProcList.Delete(i);
      SelectedProcList.Delete(j);
      SelectedProcList.Delete(k);
      SelectedProcList.Add('General Health 80050 (CBC w/ diff & CMP & TSH)');
    end;

    //Handle tests that have a linked Dx.  E.g. 'PSA' with 'Personal Hx of Prostate CA'
    WorkingProcAndDxLinksList.Assign(FProcAndDxLinksList);
    //FProcAndDxLinksList holds linked Test->Dx items.  List[x]=Ptr to LabProc TTMGData object, List[x+1]=Ptr to Dx TTMGData object
    i := 0; while i < WorkingProcAndDxLinksList.Count do begin
      Str := '';
      DataObj := WorkingProcAndDxLinksList[i]; inc(i);  //LabProc object.
      if i >= WorkingProcAndDxLinksList.Count then break;
      DxObj := WorkingProcAndDxLinksList[i]; inc(i);
      j := WorkingProcAndDxLinksList.IndexOfIEN(DataObj.IEN, i);
      if (j > -1) and (j+1 < WorkingProcAndDxLinksList.count) then begin
        //In this situation a given Lab/procedure is linked to more than one Dx.  Will combine them here.
        Str := DataObj.ExternalValue +' (Dx: '+DxObj.ExternalValue;   //out first match
        repeat
          Str := Str + ', ';
          DxObj := WorkingProcAndDxLinksList[j+1];
          Str := Str + DxObj.ExternalValue;
          WorkingProcAndDxLinksList.Delete(j+1);
          WorkingProcAndDxLinksList.Delete(j);
          j := WorkingProcAndDxLinksList.IndexOfIEN(DataObj.IEN, i);
        until (j = -1) or (j+1 >= WorkingProcAndDxLinksList.count);
        Str := Str + ') '
      end else begin
        Str := DataObj.ExternalValue;
        Str := Str+' (Dx: '+DxObj.ExternalValue+')';
      end;
      SelectedProcList.Add(Str);
    end;

    //Add tests ordered
    ProcString := '';
    if SelectedProcList.Count > 0 then begin
      //Result := 'Selected Labs/Tests/Procedures:' + CRLF;
      for i := 0 to SelectedProcList.Count -1 do begin
        if ProcString <> '' then ProcString := ProcString + ', ';
        ProcString := ProcString + SelectedProcList.Strings[i];
      end;
    end;
    Result := Result + 'TESTS ORDERED: ' + IfThen(ProcString <> '', ProcString, '(NONE)')+CRLF;;

    //Add diagnoses
    DxStr := '';
    for i := 0 to SelectedDxList.Count -1 do begin
      if DxStr <> '' then DxStr := DxStr + ', ';
      DxStr := DxStr + SelectedDxList.Strings[i];
    end;
    Result := Result + '.'+CRLF +
              'DIAG:' + IfThen(DxStr <> '', DxStr, '(NONE)')+CRLF;

    //Add Comments
    if CommentSL.Text<>''  then begin
      Result := Result + '.'+CRLF + CommentSL.Text + CRLF;
    end;

    //Add Ordering Provider
    if OrderProvider <> 'As Ordered' then begin
      Result := Result + '.'+CRLF +
                '!! ORDERING PROVIDER IS '+UPPERCASE(OrderProvider)+' TOPPENBERG. !!';
    end;

  finally
    SelectedDxList.Free;
    SelectedProcList.Free;
    CommentSL.Free;
    TempSubTMGDataList.Free;
    WorkingProcAndDxLinksList.Free;
  end;

  memOrder.Text := Result;
end;

procedure TfrmODTMG1.cmdAcceptClick(Sender: TObject);
var MessageArr : TStringList;
begin
  if OkToClose() = False then exit;
  MessageArr := TStringList.Create;
  try
    SetupLabOrderMsg(MessageArr);
    //if dialog launched from Encounter, then delay sending until Encounter form is closed.
    if LaunchedFromEncounter then begin
      if assigned(FOnClosing) then FOnClosing(Self,MessageArr);    // --> TfrmEnounterLabs.HandleLabDlgClosing(Dlg : TfrmODTMG1; Data : TStringList);
    end else begin
      SendLabOrderMsg(MessageArr);
    end;
  finally
    MessageArr.Free;
  end;
  inherited;
end;

procedure TfrmODTMG1.cmdQuitClick(Sender: TObject);
//kt added
begin
  inherited;
  if LaunchedFromEncounter then begin
    //NOTE: inherited will have set Self.FFromQuit := true;
    if assigned(FOnClosing) then FOnClosing(Self,nil);
  end;
end;

procedure TfrmODTMG1.SetupLabOrderMsg(SL : TStringList);
//FORMAT:  SL[0] = Recipient^Recipient^.....
//         SL[1] = 'T' or 'F' for boolean for FPromptToPrint
//         SL[2] = MyName
//         SL[3...] = the usual content of the message.
//
var s, MyName, User, LabUser, FastingMsg : string;
begin
  if not assigned(SL) then exit;
  SL.Clear;
  FastingMsg := IfThen(FFasting, 'FASTING', 'NON-FASTING');
  //
  //GET USERS AND PREPARE MESSAGE
  User := LabOrderMsgRecip('1');
  if piece(User,'^',1)='-1' then begin
    ShowMessage('Error getting User Name: '+piece(User,'^',2));
    exit;
  end;
  LabUser := LabOrderMsgRecip('2');
  if piece(LabUser,'^',1)='-1' then begin
    ShowMessage('Error getting Lab User Name: '+piece(LabUser,'^',2));
    exit;
  end;
  MyName :=  GetMyName;
  if MyName='' then begin
    ShowMessage('Error getting Current User Name');
    exit;
  end;

  s := User + '^';
  if (FLabTimingStr='Today') or (FLabTimingStr='Use lab blood if possible') then begin
    s := s + LabUser + '^';
  end;
  SL.Add(s);       // index 0
  s := IfThen(FPromptToPrint, 'T','F');
  SL.Add(s);       // index 1
  SL.Add(MyName);  // index 2

  SL.Add(MyName+' ORDERED LABS');
  SL.Add('');
  SL.Add(Patient.TMGMsgString);
  SL.Add('');
  SL.Add(FastingMsg);
  SL.Add('');
  SL.Add(UpperCase(FLabTimingStr));
end;

constructor TfrmODTMG1.Create(AOwner: TComponent);
begin
  AutoSizeDisabled := true;  //<--- this turns off crazy form resizing from parent forms.

  FTMGOrderData := TTMGDataList.Create;
  FAllDxList    := TTMGDataList.Create;  //doesn't own objects
  FPriorDxList  := TTMGDataList.Create;  //doesn't own objects
  FEnctrDxList  := TTMGDataList.Create;  //doesn't own objects

  FEditsList    := TList.Create; //doesn't own objects
  FCklbList     := TList.Create; //doesn't own objects
  FRgList       := TList.Create; //doesn't own objects
  FProcAndDxLinksList := TTMGDataList.Create; //doesn't own objects
  FPromptToPrint:= false;
  FFasting      := false;
  FLabTimingStr := '';
  FOnClosing    := nil;
  FLastSelectedProc := nil;

  inherited;  //<-- I think this may trigger a call to init data etc, so above needs to be done BEFORE inherited
  FOrderFlagFastingIndex := -1;;
end;

destructor TfrmODTMG1.Destroy;
var i : integer;
begin
  for i := 0 to FTMGOrderData.Count-1 do FTMGOrderData.Data[i].Free;
  FTMGOrderData.Free;
  FEditsList.Free;   //doesn't own objects
  FCklbList.Free;    //doesn't own objects
  FRgList.Free;      //doesn't own objects
  FAllDxList.Free;   //doesn't own objects
  FPriorDxList.Free; //doesn't own objects
  FEnctrDxList.Free; //doesn't own objects
  FProcAndDxLinksList.Free; //doesn't own objects
  inherited;
end;

procedure TfrmODTMG1.FormCreate(Sender: TObject);
var  w : integer;
begin
  w := tcProcTabs.Width;  //DoSetFontSize(MainFontSize) in inherited messes up width
  inherited;
  tcProcTabs.Width := w;  //restore width
  LaunchedFromEncounter := false;
  SetCustomProcArea(false,btnToggleSpecialProc);
  SetCustomProcArea(false,btnToggleSpecialDx);
end;


procedure TfrmODTMG1.FormShow(Sender: TObject);
var APage : TFrmPage;
    //TopLeft, ScrnPt : TPoint;
begin
  inherited;
  //consider positioning if (R) tab open.
  if frmFrame.TabPageOpenMode <> tpoOpen then exit;
  APage := frmFrame.LastPages[tpsRight];
  if APage <> frmOrders then exit;
  //position form here.

  //NOTE: Below is not working, and it seems this is already managed elsewhere...
  {
  TopLeft.X := APage.Left;
  TopLeft.Y := APage.Top;
  ScrnPt := APage.ClientToScreen(TopLeft);
  Self.Top := ScrnPt.Y;
  Self.Left := ScrnPt.X;
  }
end;

procedure TfrmODTMG1.SetCustomProcArea(Open : boolean; Sender: TSpeedButton);
const
  CUST_AREA_HT = 90;
  BOTTOM_HT = 150;
  LABEL_STR : array[false..true] of string = ('OPEN','CLOSE');
  BTN_BOTTOM_SPACE = 5;
begin

  //EDDIE - Look here for calculations to be wrong
     //             btnToggleSpecialProc);
//  SetCustomProcArea(false,btnToggleSpecialDx
  FCustomProcOpen := Open;
  if Open then begin
    if Sender=btnToggleSpecialProc then begin
      pnlBottom.Height := 117;
      pnlLeftTop.Height := pnlOrderAreaLeft.height - btnToggleSpecialProc.Height - pnlBottom.Height - splitterleftpanel.height;
      pnlBottom.Visible := true;
    end else begin
      pnlRightBottom.Height := 130; // 117;
      pnlRightTop.Height := pnlOrderAreaRight.height - btnToggleSpecialDx.Height - pnlRightBottom.Height - splitterright.height;
      pnlRightBottom.Visible := true;
    end;
  end else begin
    if Sender=btnToggleSpecialProc then begin
      pnlLeftTop.Height := pnlOrderAreaLeft.height - btnToggleSpecialProc.Height - splitterleftpanel.height;
      pnlBottom.Visible := false;
      pnlBottom.Height := 0;
    end else begin
      pnlRightBottom.Height := 0;
      pnlRightTop.Height := pnlOrderAreaRight.height - btnToggleSpecialDx.Height - splitterright.height;
      pnlRightBottom.Visible := false;
    end;
  end;
  //btnToggleSpecialProc.Caption := LABEL_STR[Open] + ' Custom Lab / Procedure / Comments';
  Sender.Caption := StringReplace(Sender.Caption,LABEL_STR[Not Open],LABEL_STR[Open],[rfReplaceAll]);
end;


function TfrmODTMG1.OkToClose : boolean;

  {
    TempSubTMGDataList : TTMGDataList;
    DataObj : TTMGData;

  begin  //TfrmODTMG1.OkToClose
   TempSubTMGDataList := FTMGOrderData.SublistByType(ttdtDx);  //TempSubTMGDataList doesn't own objects, but does need to be freed, not reused.
   try
     for i := 0 to TempSubTMGDataList.Count-1 do begin
       DataObj := TempSubTMGDataList.Data[i];
       if not DataObj.Checked then continue;
       dxpicked := true;
     end;
   finally
     TempSubTMGDataList.Free;
   end;
  }

  function GetDiagStr:string;
  var i:integer;
      TempSubTMGDataList : TTMGDataList;
      DataObj : TTMGData;
      AnEdit : TEdit;

      procedure AddToResult(var result: string; S : string);
      begin
        result:= result + IfThen(result='','','^') + S;
      end;

  begin
     result := '';
     TempSubTMGDataList := FTMGOrderData.SublistByType(ttdtDx);  //TempSubTMGDataList doesn't own objects, but does need to be freed, not reused.
     try
       for i := 0 to TempSubTMGDataList.Count-1 do begin
         DataObj := TempSubTMGDataList.Data[i];
         if not DataObj.Checked then continue;
         AddToResult(result, DataObj.Name);
       end;
     finally
       TempSubTMGDataList.Free;
     end;

     {for i := 0 to cklbDisplayedDxs.Items.Count - 1 do begin
       if not cklbDisplayedDxs.Checked[i] then continue;
       AddToResult(result, cklbDisplayedDxs.Items[i]);
     end; }

     for i := 0 to 3 do begin   //edtDx0 ..edtDx3
       AnEdit := TEdit(FEditsList[i]);  //get custom diagnosis edit boxes.
       if AnEdit.text = '' then continue;
       AddToResult(result, AnEdit.text);
     end;
  end;

  function GetTestStr:string;
  var i:integer;
  begin
     result := '';
     for i := 0 to cklbProcedures.Items.Count - 1 do begin
       if not cklbProcedures.Checked[i] then continue;
       if result<>'' then result := result+'^';
       result:=result+cklbProcedures.Items[i];
     end;
     if edtOtherOrder.text<>'' then result := result+'^'+StringReplace(edtOtherOrder.text,',','^',[rfReplaceAll,rfIgnoreCase]);
  end;

  function RequiredLinkedDxsSatisfied : boolean;
  var
    i, j : integer;
    TempObj  : TTMGData;    //doesn't own object
    LinkedObj : TTMGData;  //doesn't own object
    Msg : string;
    LinkedDxList : TTMGDataList;
  begin
    Result := true; //default to success
    //Scan through all Procs, and see if they have linked Dx's are required
    for i := 0 to FTMGOrderData.Count - 1 do begin
      TempObj := FTMGOrderData[i];
      if TempObj.DataType <> ttdtProc then continue;
      if TempObj.NeedsLinkedDx = false then continue;
      if TempObj.Checked = false then continue;
      if TempObj.LinkedDxStr = '' then continue;
      if TempObj.IsLinkedDxChecked(FTMGOrderData) then continue;
      //Object has a list of linked Dx's, and one is required, but none are checked.
      Msg := 'Text "'+TempObj.Name+'" has 1 or more required diagnosis' +  CRLF;
      LinkedDxList := TempObj.AllowedLinkedDxList(FTMGOrderData);
      for j := 0 to LinkedDxList.Count - 1 do begin
        LinkedObj := LinkedDxList[j];
        Msg := Msg + '  '+LinkedObj.Name + CRLF;
      end;
      Msg := Msg + 'Please select Dx, or unselect '+TempObj.Name;
      Result := false;
      ShowMsg(Msg);
    end;
  end;

var i:integer;
    dxpicked:boolean;
    TestStr,DiagStr:string;
    PretestResult:string;
    TempSubTMGDataList : TTMGDataList;
    DataObj : TTMGData;

begin  //TfrmODTMG1.OkToClose
   result := True;
   if not RequiredLinkedDxsSatisfied then begin
     result := false;    //added 9/9/24
     exit;
   end;
   dxpicked := false;
   TempSubTMGDataList := FTMGOrderData.SublistByType(ttdtDx);  //TempSubTMGDataList doesn't own objects, but does need to be freed, not reused.
   try
     for i := 0 to TempSubTMGDataList.Count-1 do begin
       DataObj := TempSubTMGDataList.Data[i];
       if not DataObj.Checked then continue;
       dxpicked := true;
     end;
   finally
     TempSubTMGDataList.Free;
   end;
   //ELH end addition
   if (edtDx0.text<>'') or (edtDx1.text<>'') or (edtDx2.text<>'') or (edtDx3.text<>'') then dxpicked := True;  //tmg 7/25/23
   if dxpicked=false then begin
     Showmsg('You must select at least one diagnosis');
     result := false;
     exit;
   end;
   //Added 12/4/23
   TestStr := GetTestStr;
   DiagStr := GetDiagStr;
   PretestResult := sCallV('TMG LAB SAVE PRETEST',[Patient.DFN,TestStr,DiagStr]);
   if piece(PretestResult,'^',1)='-1' then begin
     PretestResult := piece(PretestResult,'^',2);
     PretestResult := StringReplace(PretestResult,'@@BR@@',#13#10,[rfReplaceAll]);
     if messagedlg(PretestResult,mtConfirmation,[mbYes,mbNo,mbCancel],0) <> mrNo then begin
        result := false;
     end;
   end;
   //end 12/4/23 addition
end;

procedure TfrmODTMG1.ToggleCustomProcArea(Sender:TSpeedButton);
begin
  SetCustomProcArea(not FCustomProcOpen,Sender);
end;

procedure TfrmODTMG1.btnClearClick(Sender: TObject);
var
  ChangedDataObjs : TTMGDataList;
begin
  inherited;
  ChangedDataObjs := TTMGDataList.Create; //Doesn't own objects
  try
    ClearData(ChangedDataObjs);
    Data2Responses(ChangedDataObjs);
    Data2GUI;
  finally
    ChangedDataObjs.Free; //Doesn't own objects
  end;
end;

procedure TfrmODTMG1.btnSrchICDClick(Sender: TObject);
var
  EntryType : tDxNodeType;
  ItemDataStr : TDataStr;
  frmICDPicker : TfrmEncounterICDPicker;
  ModalResult : integer;
  EditCtrl : TEdit;
  EditIndex, MaxLen : integer;
  Str : string;
  i, L : integer;

CONST
  tNODE_FIRST = ord(TopicsDiscussed);
  tNODE_LAST = ord(EncounterICDs);

  //copied from fTMGDiagnoses                                                                                                                    // 1     2             3                4               5                 6                      7                  8
  //TOPIC_PROBLEM_FORMAT       = 'Code^TopicName^ThreadText^ProblemIEN^ICDCode^ICDLongName^SnowmedName^ICDCodeSys';   // 1^<TOPIC NAME>^<THREAD TEXT >^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>
  //SECTION_DATA_FORMAT        = 'Type^Index^DisplayText';  //'Type^Index^DisplayText';
  //PROB_LIST_DATA_FORMAT      = 'Type^ifn^status^description^ICDCode^onset^LastModified^SC^SpExp^Cond^Loc^LocType^prov^service^priority^HasComment^DateRecorded^SCCond^InactiveFlag^ICDLongName^ICDCodeSys';  //fmt: 3^ifn^status^description^ICD^onset^last modified^SC^SpExp^Condition^Loc^loc.type^prov^service^priority^has comment^date recorded^SC condition(s)^inactive flag^ICD long description^ICD coding system
  //PRIOR_ICDS_DATA_FORMAT     = 'Type^ICDCode^ICDLongName^FMDTLastUsed^ICDCodeSys';   //fmt: 4^<PRIOR ICD>^<ICD LONG NAME>^<FMDT LAST USED>^<ICD_CODE_SYS>
  //ENCOUNTER_ICDS_DATA_FORMAT = 'Type^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys';  //fmt 5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"

begin
  //Result := true;
  frmICDPicker := TfrmEncounterICDPicker.Create(nil);;
  ItemDataStr := TDataStr.Create(STD_ICD_DATA_FORMAT);
  try
    frmICDPicker.Initialize(Self, 'TestMessage');
    ModalResult := frmICDPicker.ShowModal;
    if ModalResult = mrOK then begin
      ItemDataStr.Assign(frmICDPicker.ResultDataStr); //format: STD_ICD_DATA_FORMAT = 'ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys';
      EditIndex := 0; MaxLen := 99999999;
      for i := 1 to 3 do begin
        EditCtrl := TEdit(FEditsList[i]);
        L := Length(EditCtrl.Text);
        if L >= MaxLen then continue;
        MaxLen := L;
        EditIndex := i;
      end;
      EditCtrl := TEdit(FEditsList[EditIndex]);  //the one with the shortest amount of text
      Str := ItemDataStr.Value['ProblemText'] + ' - ' + ItemDataStr.Value['ICDCode'];
      if AddOrRemovePriorDx(EditCtrl, true, Str, ';') then begin  //true --> store (but -- can't automatically removed....)
        Data2Responses([TTMGData(EditCtrl.Tag)]);
      end;
    end;
  finally
    FreeAndNil(frmICDPicker);
    ItemDataStr.Free;
    //if Result <> true  then lbxSection.Checked[Index] := false;
  end;

end;

procedure TfrmODTMG1.btnToggleSpecialProcClick(Sender: TObject);
begin
  inherited;
  ToggleCustomProcArea(TSpeedButton(Sender));
end;


end.

