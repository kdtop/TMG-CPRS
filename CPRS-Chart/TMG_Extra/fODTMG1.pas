unit fODTMG1;
//kt added 12/8/22

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fODGen, VA508AccessibilityManager, StdCtrls, ComCtrls, ExtCtrls,
  ORCtrls, CheckLst, Buttons, uCore, ORNet, VAUtils;

type
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
                  ttdtWPFld
                  );
  TTMGDataList = class;
  TTMGData = class(TObject)
  private
  public
    SourceIndex : integer; // index in FDialogItemList that was source of this data
    ID : string;
    Instance : integer;
    IEN : string;  //IEN22751
    Name : string;
    DataType : tTMGDataType;
    Items : TStringList; //doesn't own objects
    Fasting : boolean;
    Checked : boolean;
    Index : integer; //for TCheckListBox entries, this will store items index
                     //for TRadioGroup entries, this will store items index
                     //for TRadioGroup parents (those with child entries), this will store selecte ItemIndex
    SavedValue : string;
    InternalValue : string;
    ExternalValue : string;
    LinkedControl : TControl;
    function Modified : boolean;  //Is InternalValue different from SavedInternalValue?
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
    function CreateAndAdd(IEN : string; DataType : tTMGDataType) : integer; //create TTMGData object and add to list
    function IndexOfIEN(IEN : string) : integer;
    function IndexOfNameType(Name : string; DataType : tTMGDataType) : integer;
    function IndexOfIDInstance(ID : string; Instance : integer) : integer;
    function SublistByType(Arr : array of tTMGDataType) : TTMGDataList; overload; //returned list is created, but not considered owner of objects
    function SublistByType(DataType : tTMGDataType)     : TTMGDataList; overload; //returned list is created, but not considered owner of objects

    function SublistByID(ID: string) : TTMGDataList;  //returned list is created, but not considered owner of objects
    property Data[Index: Integer]: TTMGData read GetItem write PutItem; default;  //list does NOT own items
  end;

  TfrmODTMG1 = class(TfrmODGen)
    gbICDCodes: TGroupBox;
    gbBundles: TGroupBox;
    cboBundles: TComboBox;
    edtDx0: TEdit;
    edtDx1: TEdit;
    edtDx2: TEdit;
    rgGetLabsTiming: TRadioGroup;
    btnClear: TButton;
    cklbOther: TCheckListBox;
    pnlBottom: TPanel;
    memOrderComment: TMemo;
    lblOtherProc: TLabel;
    pnlFlags: TPanel;
    cklbFlags: TCheckListBox;
    btnToggleSpecialProc: TSpeedButton;
    cklbCommonDxs: TCheckListBox;
    edtDx3: TEdit;
    tcProcTabs: TTabControl;
    pnlProcedures: TPanel;
    pnlProcCaption: TPanel;
    cklbProcedures: TCheckListBox;
    edtOtherOrder: TEdit;
    Label1: TLabel;
    lblComments: TLabel;
    rgProvider: TRadioGroup;
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
    FTMGOrderData : TTMGDataList;
    FEditsList    : TList; //doesn't own objects
    FCklbList     : TList; //doesn't own objects
    FRgList       : TList; //doesn't own objects
    FPromptToPrint: boolean;
    FFasting      : boolean;
    FLabTimingStr : string;
    FCustomProcOpen : boolean;
    FOrderFlagFastingIndex : integer;
    procedure SetCustomProcArea(Open : boolean);
    procedure ToggleCustomProcArea;
    procedure GetChangedObjsList(ListBox : TCheckListBox; ChangedDataObjs : TTMGDataList);
    procedure CheckedGUI2Data(ListBox : TCheckListBox; ChangedDataObjs : TTMGDataList);
    procedure HandleCheckListBoxChange(Sender : TObject);
    procedure CheckForFastingLabs();
    procedure InitData();
    procedure Responses2Data();
    procedure Data2Responses(Arr : array of TTMGData);         overload;
    procedure Data2Responses(ChangedDataObjs : TTMGDataList);  overload;
    function UpdateOrderMemoDisplay : string;
    procedure Data2GUI();
    procedure ClearData(ChangedDataObjs : TTMGDataList);
    function rgExternalValue(DataObj : TTMGData) : string;
    procedure SendLabOrderMsg;
  protected
    procedure PlaceControls; override;
    procedure ControlChange(Sender: TObject); override;
  public
    { Public declarations }
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
    function SelectOrder(OrderName : string; var ErrMsg : string) : boolean;
    function SelectDx(DxName : string; var ErrMsg : string) : boolean;
    function SelectName(Name : string; DataType: tTMGDataType; var ErrMsg : string) : boolean;
    function SelectIEN(IEN22751 : string; var ErrMsg : string) : boolean;
    procedure AutoCheckPerOrderedLabs();
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  procedure TMGLabOrderAutoPopulateIfActive();

implementation

{$R *.dfm}

uses
  rODBase, ORFn, rCore, rOrders, uConst, ORDtTm, fFrame, fOrders,
  fPage, uOrders,
  fNetworkMessengerClient, uTMG_WM_API, StrUtils;

const
  HT_FRAME  = 8;
  HT_LBLOFF = 3;
  HT_SPACE  = 6;
  WD_MARGIN = 6;
  TX_STOPSTART   = 'The stop date must be after the start date.';

  N_Y : array[false..true] of char = ('0','1');

  FREE_TEXT_DX  = 'FREE TEXT DX ';
  FREE_TEXT_LAB = 'FREE TEXT LAB';

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

constructor TTMGData.Create;
begin
  inherited Create;
  SourceIndex        := -1;
  ID                 := '';
  Instance           := 0;
  IEN                := '';
  Name               := '';
  DataType           := ttdtNone;
  Items              := TStringList.Create;   //doesn't own objects
  Fasting            := false;
  Checked            := false;
  Index              := -1;
  SavedValue         := '';
  InternalValue      := '';
  ExternalValue      := '';
  LinkedControl      := nil;
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
 inherited;
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

function TTMGDataList.IndexOfIEN(IEN : string) : integer;
var i : integer;
begin
  Result := -1;
  for i := 0 to Self.Count-1 do begin
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
{ NOTE: All user selection (i.e. clicking a checkbox) must ultimately generates a RESPONSE.
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
  cklbCommonDxs.Items.Clear;
  cboBundles.Items.Clear;
  tcProcTabs.Tabs.Clear;

  InitData();  //load it all in

  AutoCheckPerOrderedLabs();

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

        Handling of types:
        [P]  -- Item should be added to cklbProcedures
        [I]  -- Item should be added to cklbCommonDxs
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
        if Pos(FREE_TEXT_LAB, DataObj.Name)>0 then begin
          index := 5;
        end else if Pos(FREE_TEXT_DX, DataObj.Name)>0 then begin
          index := StrToIntDef(Piece2(DataObj.Name, FREE_TEXT_DX, 2),0);
          if (Index < 1) or (Index > 4) then continue;
        end;
        if (Index < 1) or (Index > 5) then continue;
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

var
  i,j,k                             : Integer;
  IEN, DataStr, ItemsStr            : string;
  DialogItem                        : TDialogItem;
  AllProcsDataObj, DataObj, TempObj : TTMGData;

begin //TfrmODTMG1.InitData
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
      DataObj.Checked := false;
      DataObj.InternalValue := N_Y[DataObj.Checked];
      DataObj.ExternalValue := DataObj.Name;
    end;
    DataObj.Fasting := (GetValue(DataStr, 'FASTING') = '1');
    ItemsStr := GetValue(DataStr, 'ITEMS');
    if ItemsStr <> '' then begin
      PiecesToList(ItemsStr,',', DataObj.Items);
    end;
    FTMGOrderData.Add(DataObj);
  end; //for loop

  //Make Entry to contain ALL labs/procedures
  AllProcsDataObj := TTMGData.Create;   //will be owned by FTMGDataFTMGOrderData
  AllProcsDataObj.Name := 'All';
  AllProcsDataObj.IEN := '0';
  AllProcsDataObj.DataType := ttdtPageGroup;
  FTMGOrderData.Insert(0,AllProcsDataObj);
  //added later .... tcProcTabs.Tabs.AddObject('All',AllProcsDataObj);

  for i := 0 to FTMGOrderData.Count-1 do begin
    DataObj := FTMGOrderData.Data[i];
    case DataObj.DataType of
      ttdtDx:        LoadItems(cklbCommonDxs,   cklbCommonDxs.Items,   DataObj, true);
      ttdtProc:      LoadItems(cklbProcedures,  AllProcsDataObj.Items, DataObj, true);
      ttdtBundle:    LoadItems(cboBundles,      cboBundles.Items,      DataObj, false);
      ttdtPageGroup: LoadItems(tcProcTabs,      tcProcTabs.Tabs,       DataObj, false);
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

  FCklbList.Add(cklbCommonDxs);
  FCklbList.Add(cklbProcedures);
  FCklbList.Add(cklbFlags);
  FCklbList.Add(cklbOther);
  FRgList.Add(rgProvider);
  FRgList.Add(rgGetLabsTiming);
  FEditsList.Add(nil);
  FEditsList.Add(edtDx0);        edtDx0.tag := 0;        //index 1
  FEditsList.Add(edtDx1);        edtDx1.tag := 0;        //index 2
  FEditsList.Add(edtDx2);        edtDx2.tag := 0;        //index 3
  FEditsList.Add(edtDx3);        edtDx3.tag := 0;        //index 4
  FEditsList.Add(edtOtherOrder); edtOtherOrder.tag := 0; //index 5

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
begin
  //Call RPC to get list of items to auto-check.
  LabList := sCallV('TMG GET ORDERED LABS',[Patient.DFN]);
  if LabList = 'NONE' then exit;
  NetErr := '';
  for i := 1 to NumPieces(LabList,'^') do begin
    OneTest := piece(LabList,'^',i);
    LabName := piece(OneTest,':',1);
    DfltICD := piece(OneTest,':',2);
    SubList := piece(OneTest,':',3);
    if LabName <> '' then begin
      SelectOrder(LabName, AnErr);
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
  if NetErr <> '' then ShowMsg(NetErr);
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
    DataObj.Checked := true;
    Data2GUI();
  end else begin
    Result := false;
    ErrMsg := 'Unable to find order matching "' + Name + '"';
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
    DataObj.Checked := true;
    Data2GUI();
  end else begin
    Result := false;
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
    rgClick(rgProvider);      //this will ensure value is saved, even is user leaves initial (default) value unchanged.
    rgClick(rgGetLabsTiming); //this will ensure value is saved, even is user leaves initial (default) value unchanged.

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
  DataObj.InternalValue := memo.Text;
  DataObj.ExternalValue := memo.Text;
  DataObj.Checked := (DataObj.ExternalValue <> '');
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
      ProcObj.Checked := true;
      ProcObj.InternalValue := '1';
      ProcObj.ExternalValue := ProcObj.Name;
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

procedure TfrmODTMG1.HandleCheckListBoxChange(Sender : TObject);  //Called by a GUI Change handler
//GUI2Data
var ChangedDataObjs : TTMGDataList;
begin
  if Changing then Exit;
  inherited;
  if not (Sender is TCheckListBox) then exit;
  ChangedDataObjs := TTMGDataList.Create;  //doesn't own objects
  try
    CheckedGUI2Data(TCheckListBox(Sender),ChangedDataObjs);
    Data2Responses(ChangedDataObjs);
    if Sender = cklbProcedures then CheckForFastingLabs();
  finally
    ChangedDataObjs.Free; //doesn't own objects
  end;
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
  DataObj.InternalValue := Edit.Text;
  DataObj.ExternalValue := Edit.Text;
  DataObj.Checked := (Edit.Text <> '');
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
  Data2Responses([DataObj]);
  UpdateOrderMemoDisplay;
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
  ProcObj  : TTMGData;
begin
  for i := 0 to ListBox.Items.Count-1 do begin
    ProcObj := TTMGData(ListBox.Items.Objects[i]);
    if not Assigned(ProcObj) then continue;
    ProcObj.Checked := ListBox.Checked[i];
    ProcObj.InternalValue := N_Y[ProcObj.Checked];
    ProcObj.ExternalValue := IfThen(ProcObj.Checked, ProcObj.Name, '');
    if ProcObj.Modified then begin
      ChangedDataObjs.Add(ProcObj);
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

begin
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
      if lb = cklbProcedures then continue;  //this will be handled separately by triggering a pseudo tab page change: tcProcTabsChange()
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
    end else if AControl is TMemo then begin
      memo := TMemo(AControl);
      memo.Text := DataObj.ExternalValue;
    end;
  end;
  BubbleUpCheckedItems(cklbCommonDxs);
  tcProcTabsChange(self);  //handle cklbProcedures for currently displayed tab page.
  Changing := false;
  UpdateOrderMemoDisplay;
end;

procedure TfrmODTMG1.tcProcTabsChange(Sender: TObject);
//Data2GUI
var
  i,j        : integer;
  DataObj, ProcObj  : TTMGData;

begin
  inherited;
  //Handle loading / showing labs
  cklbProcedures.Items.Clear;  //doesn't own objects
  i := tcProcTabs.TabIndex;
  if i < 0  then exit;
  DataObj := TTMGData(tcProcTabs.Tabs.Objects[i]);
  if not Assigned(DataObj) then exit;
  //First, just add checked items
  for i := 0 to DataObj.Items.Count-1 do begin
    ProcObj := TTMGData(DataObj.Items.Objects[i]);
    if not Assigned(ProcObj) then continue;
    if ProcObj.Checked = false then continue;
    j := cklbProcedures.Items.AddObject(ProcObj.Name, ProcObj);
    ProcObj.Index := j;
    cklbProcedures.Checked[j] := ProcObj.Checked;
  end;
  //next, add just NON-checked items
  for i := 0 to DataObj.Items.Count-1 do begin
    ProcObj := TTMGData(DataObj.Items.Objects[i]);
    if not Assigned(ProcObj) then continue;
    if ProcObj.Checked = true then continue;
    j := cklbProcedures.Items.AddObject(ProcObj.Name, ProcObj);
    ProcObj.Index := j;
    cklbProcedures.Checked[j] := ProcObj.Checked;
  end;
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
    if not (DataObj.Datatype in [ttdtDx, ttdtProc, ttdtTextFld,
                                 ttdtOrderFlags, ttdtOrderOptions,
                                ttdtOrderingProvider, ttdtLabTiming,
                                ttdtWPFld]) then continue;
    IV := IfThen(DataObj.Datatype = ttdtWPFld, TX_WPTYPE, DataObj.InternalValue);
    Responses.Update(DataObj.ID, DataObj.Instance, IV, DataObj.ExternalValue);
    DataObj.SavedValue := DataObj.InternalValue;
  end;  //for

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

var OrderProvider, LabTiming, ProcString, DxStr : string;
    SickPt, StandingOrder, Fasting : boolean;
    BalladOrder, OutsideOrder, PrintPrompt, AutoSign, ForHospital : boolean;
    DataObj : TTMGData;
    i,j,k : integer;
    SelectedDxList, SelectedProcList, CommentSL : TStringList;
    Str : string;
    TempSubTMGDataList : TTMGDataList;

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

begin
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
  FLabTimingStr  := LabTiming;    //used during form close out

  SelectedDxList   := TStringList.Create;
  SelectedProcList := TStringList.Create;
  CommentSL        := TStringList.Create;
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
      Str := DataObj.ExternalValue;
      SelectedProcList.Add(Str);
    end;

    TempSubTMGDataList := FTMGOrderData.SublistByType(ttdtTextFld);  //TempSubTMGDataList doesn't own objects, but does need to be freed, not reused.
    for i := 0 to TempSubTMGDataList.Count-1 do begin   //This is list of edit boxes.  This includes both Dx and Procedure edit boxes.
      DataObj := TempSubTMGDataList.Data[i];
      if not DataObj.Checked then continue;
      Str := DataObj.ExternalValue;
      //NOTE: if Str is data from edit field, then perhaps it contains multiple items, comma-separated.  Might need to split out...
      if Contains(DataObj.Name, FREE_TEXT_DX) then begin
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
    if (i>0) and (j>0) and (k > 0) then begin
      SelectedProcList.Delete(i);
      SelectedProcList.Delete(j);
      SelectedProcList.Delete(k);
      SelectedProcList.Add('General Health 80050 (CBC w/ diff & CMP & TSH)');
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
  end;

  memOrder.Text := Result;
end;

procedure TfrmODTMG1.cmdAcceptClick(Sender: TObject);
begin
  inherited;
  SendLabOrderMsg;
end;

procedure TfrmODTMG1.SendLabOrderMsg;
var MyName, User, LabUser, FastingMsg : string;
    //LabTimingMsg:string;
    PromptToPrint                     : boolean;
    MessageArr                        : TStringList;
begin
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
end;


constructor TfrmODTMG1.Create(AOwner: TComponent);
begin
  AutoSizeDisabled := true;  //<--- this turns off crazy form resizing from parent forms.

  FTMGOrderData := TTMGDataList.Create;
  FEditsList    := TList.Create; //doesn't own objects
  FCklbList     := TList.Create; //doesn't own objects
  FRgList       := TList.Create; //doesn't own objects
  FPromptToPrint:= false;
  FFasting      := false;
  FLabTimingStr := '';

  inherited;  //<-- I think this may trigger a call to init data etc, so above needs to be done BEFORE inherited
  FOrderFlagFastingIndex := -1;;
end;

destructor TfrmODTMG1.Destroy;
var i : integer;
begin
  for i := 0 to FTMGOrderData.Count-1 do FTMGOrderData.Data[i].Free;
  FTMGOrderData.Free;
  FEditsList.Free; //doesn't own objects
  FCklbList.Free;  //doesn't own objects
  FRgList.Free;    //doesn't own objects
  inherited;
end;

procedure TfrmODTMG1.FormCreate(Sender: TObject);
var  w : integer;
begin
  w := tcProcTabs.Width;  //DoSetFontSize(MainFontSize) in inherited messes up width
  inherited;
  tcProcTabs.Width := w;  //restore width

  SetCustomProcArea(false);
end;


procedure TfrmODTMG1.FormShow(Sender: TObject);
var APage : TFrmPage;
    TopLeft, ScrnPt : TPoint;
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

procedure TfrmODTMG1.SetCustomProcArea(Open : boolean);
const
  CUST_AREA_HT = 90;
  BOTTOM_HT = 150;
  LABEL_STR : array[false..true] of string = ('OPEN','CLOSE');
  BTN_BOTTOM_SPACE = 5;
begin
  FCustomProcOpen := Open;
  if Open then begin
    sbxMain.Height := Self.Height - BOTTOM_HT - CUST_AREA_HT;
    pnlBottom.Height := CUST_AREA_HT;
    pnlBottom.Visible := true;
    tcProcTabs.Height := btnToggleSpecialProc.Top - tcProcTabs.Top - BTN_BOTTOM_SPACE;
    btnToggleSpecialProc.Top := sbxMain.Height - BTN_BOTTOM_SPACE - btnToggleSpecialProc.Height;
  end else begin
    pnlBottom.Visible := false;
    pnlBottom.Height := 0;
    sbxMain.Height := Self.Height - BOTTOM_HT;
    btnToggleSpecialProc.Top := sbxMain.Height - BTN_BOTTOM_SPACE - btnToggleSpecialProc.Height;
    tcProcTabs.Height := btnToggleSpecialProc.Top - tcProcTabs.Top - BTN_BOTTOM_SPACE;
  end;
  btnToggleSpecialProc.Caption := LABEL_STR[Open] + ' Custom Lab / Procedure / Comments';
end;


procedure TfrmODTMG1.ToggleCustomProcArea;
begin
  SetCustomProcArea(not FCustomProcOpen);
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

procedure TfrmODTMG1.btnToggleSpecialProcClick(Sender: TObject);
begin
  inherited;
  ToggleCustomProcArea;
end;


end.

