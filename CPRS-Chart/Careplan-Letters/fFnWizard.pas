unit fFnWizard;
//VEFA-261 Added entire unit

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, StrUtils,
  fTemplateEditor, dShared, fInsertFldEtc,
  fTemplateObjects, uTemplates, ORFn,
  fInsertComparator, fPickTemplateField, fPickTemplateVar, Grids,fBase508Form,
  VA508AccessibilityManager;

const
  MAX_NUM_EDITS = 4;
type
  TEditsRec = record
     Edit : Array[1..MAX_NUM_EDITS] of TEdit;
     Prefix : string;
  end;
  //**NOTE: the order in this enum must match the order shown in lbCommands
  TWizPage = (twzNone, twzAll, tzWelcome, twzABS, twzAVG, twzBOOL, twzCASE, twzCEIL, twzDIGITS, twzDIV, twzEXP, twzFLOOR, twzIN,
              twzMAX, twzMIN, twzMOD, twzNUM, twzNUMPIECES, twzPIECE, twzPOWER, twzROUND, twzSQRT, twzTEXT);
  TWizPagesSet = set of TWizPage;
const
  FIRST_WZ_PAGE = twzABS;
  LAST_WZ_PAGE = twzTEXT;
  ALL_WIZ_PAGES : TWizPagesSet = [twzABS, twzAVG, twzBOOL, twzCASE, twzCEIL, twzDIGITS, twzDIV, twzEXP, twzFLOOR,
                                  twzIN, twzMAX, twzMIN, twzMOD, twzNUM, twzNUMPIECES, twzPIECE, twzPOWER, twzROUND,
                                  twzSQRT, twzTEXT ];

function GetExcludedWizPagesSet(ExcludedPages : TWizPagesSet) : TWizPagesSet; forward;

type
  TfrmFnWizard = class(TfrmBase508Form)
    pnlBottom: TPanel;
    lbCommands: TListBox;
    Splitter1: TSplitter;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    lblFnTitle: TLabel;
    lblFnResult: TLabel;
    pcCommandsDetail: TPageControl;
    tsWelcome: TTabSheet;
    memWelcome: TMemo;
    tempRE: TRichEdit;
    tsABS: TTabSheet;
    lblTagABS: TLabel;
    lblCloseParenABS: TLabel;
    btnAddABS: TBitBtn;
    memABS: TMemo;
    ABSEdit: TEdit;
    tsAVG: TTabSheet;
    lblTagAVG: TLabel;
    lblCloseParenAVG: TLabel;
    SpeedButton2: TBitBtn;
    memAVG: TMemo;
    sgAVGArgs: TStringGrid;
    btnAVGAddRow: TBitBtn;
    btnAVGDelRow: TBitBtn;
    tsBOOL: TTabSheet;
    lblTagBOOL: TLabel;
    lblCloseParenBOOL: TLabel;
    btnAddBOOL1: TBitBtn;
    btnAddBOOL3: TBitBtn;
    memBOOL: TMemo;
    BOOLEdit1: TEdit;
    BOOLEdit2: TEdit;
    BOOLEdit3: TEdit;
    tsCASE: TTabSheet;
    lblTagCASE: TLabel;
    lblCloseParenCASE: TLabel;
    SpeedButton3: TBitBtn;
    memCASE: TMemo;
    sgCASEArgs: TStringGrid;
    btnCASEDelRow: TBitBtn;
    btnCASEAddRow: TBitBtn;
    tsCEIL: TTabSheet;
    lblTagCEIL: TLabel;
    lblCloseParenCEIL: TLabel;
    btnAddCEIL: TBitBtn;
    memCEIL: TMemo;
    CEILEdit: TEdit;
    tsDIGITS: TTabSheet;
    lblTagDIGITS: TLabel;
    lblCloseParenDIGITS: TLabel;
    btnAddDIGITS1: TBitBtn;
    btnAddDIGITS2: TBitBtn;
    memDIGITS: TMemo;
    DIGITSEdit1: TEdit;
    DIGITSEdit2: TEdit;
    tsDIV: TTabSheet;
    lblTagDIV: TLabel;
    lblCloseParenDIV: TLabel;
    btnAddDIV1: TBitBtn;
    btnAddDIV2: TBitBtn;
    memDIV: TMemo;
    DIVEdit1: TEdit;
    DIVEdit2: TEdit;
    tsEXP: TTabSheet;
    lblTagEXP: TLabel;
    lblCloseParenEXP: TLabel;
    btnAddEXP: TBitBtn;
    memEXP: TMemo;
    EXPEdit: TEdit;
    tsFLOOR: TTabSheet;
    lblTagFLOOR: TLabel;
    lblCloseParenFLOOR: TLabel;
    btnADDFLOOR: TBitBtn;
    memFLOOR: TMemo;
    FLOOREdit: TEdit;
    tsIN: TTabSheet;
    lblTagIN: TLabel;
    lblCloseParenIN: TLabel;
    btnADDIN1: TBitBtn;
    btnADDIN2: TBitBtn;
    btnADDIN3: TBitBtn;
    memIN: TMemo;
    INEdit1: TEdit;
    INEdit2: TEdit;
    INEdit3: TEdit;
    tsMAX: TTabSheet;
    lblTagMAX: TLabel;
    lblCloseParenMAX: TLabel;
    SpeedButton4: TBitBtn;
    memMAX: TMemo;
    sgMAXArgs: TStringGrid;
    btnMAXDelRow: TBitBtn;
    btnMAXAddRow: TBitBtn;
    tsMIN: TTabSheet;
    lblTagMIN: TLabel;
    lblCloseParenMIN: TLabel;
    SpeedButton5: TBitBtn;
    memMIN: TMemo;
    sgMINArgs: TStringGrid;
    btnMINAddRow: TBitBtn;
    btnMINDelRow: TBitBtn;
    tsMOD: TTabSheet;
    lblTagMOD: TLabel;
    lblCloseParenMOD: TLabel;
    btnAddMOD1: TBitBtn;
    btnAddMOD2: TBitBtn;
    memMOD: TMemo;
    MODEdit1: TEdit;
    MODEdit2: TEdit;
    tsNUM: TTabSheet;
    lblTagNUM: TLabel;
    lblCloseParenNUM: TLabel;
    SpeedButton1: TBitBtn;
    memNUM: TMemo;
    NUMEdit: TEdit;
    tsPIECE: TTabSheet;
    lblTagPIECE: TLabel;
    lblCloseParenPIECE: TLabel;
    btnAddPIECE1: TBitBtn;
    btnAddPIECE2: TBitBtn;
    btnAddPIECE3: TBitBtn;
    btnAddPIECE4: TBitBtn;
    memPIECE: TMemo;
    PIECEEdit1: TEdit;
    PIECEEdit4: TEdit;
    PIECEEdit2: TEdit;
    PIECEEdit3: TEdit;
    tsSQRT: TTabSheet;
    lblTagSQRT: TLabel;
    lblCloseParenSQRT: TLabel;
    btnAddSQRT: TBitBtn;
    memSQRT: TMemo;
    SQRTEdit: TEdit;
    tsROUND: TTabSheet;
    lblTagROUND: TLabel;
    lblCloseParenROUND: TLabel;
    btnAddROUND: TBitBtn;
    memROUND: TMemo;
    ROUNDEdit: TEdit;
    tsTEXT: TTabSheet;
    lblTagTEXT: TLabel;
    lblCloseParenTEXT: TLabel;
    btnAddTEXT: TBitBtn;
    memTEXT: TMemo;
    TEXTEdit: TEdit;
    tsNUMPIECES: TTabSheet;
    Memo1: TMemo;
    NumPiecesEdit1: TEdit;
    NumPiecesEdit2: TEdit;
    btnAddNUMPIECES1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    btnAddNUMPIECES2: TBitBtn;
    tsPOWER: TTabSheet;
    Memo2: TMemo;
    Label3: TLabel;
    POWEREdit1: TEdit;
    POWEREdit2: TEdit;
    Label4: TLabel;
    btnAddPOWER1: TBitBtn;
    btnAddPOWER2: TBitBtn;
    btnAddBOOL2: TBitBtn;
    tsSETPIECE: TTabSheet;
    Memo3: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    lblTagSETPIECE: TLabel;
    lblCloseParenSETPIECE: TLabel;
    btnAddSETPIECE4: TBitBtn;
    btnAddSETPIECE3: TBitBtn;
    btnAddSETPIECE2: TBitBtn;
    btnAddSETPIECE1: TBitBtn;
    tsLOG: TTabSheet;
    Memo4: TMemo;
    lblTagLOG: TLabel;
    LOGEdit1: TEdit;
    LOGEdit2: TEdit;
    lblCloseParenLOG: TLabel;
    btnAddLOG2: TBitBtn;
    btnAddLOG1: TBitBtn;
    tsLN: TTabSheet;
    Memo5: TMemo;
    lblTagLN: TLabel;
    LNEdit: TEdit;
    Label8: TLabel;
    btnADDLN: TBitBtn;
    procedure HandleNumEditExit(Sender: TObject);
    procedure HandleStringEditExit(Sender: TObject);
    procedure sgCASEArgsExit(Sender: TObject);
    procedure btnAddBOOL2Click(Sender: TObject);
    procedure pcCommandsDetailChange(Sender: TObject);
    procedure btnAddToEditClickTEXT(Sender: TObject);
    procedure btnAddToEditClickNUM(Sender: TObject);
    procedure btnAddToGridClick(Sender: TObject);
    procedure GridSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure btnGridDelRowClick(Sender: TObject);
    procedure btnGridAddRowClick(Sender: TObject);
    procedure BOOLEdit2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AnEditChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbCommandsClick(Sender: TObject);
  private
    { Private declarations }
    RE: TRichEdit;
    lbCommandsStore : TStringList;
    PickTemplateFieldForm: TfrmPickTemplateField;
    PickTemplateObjectForm: TfrmTemplateObjects;
    PickFldFnObj : TfrmPickFldFnObj;
    PickTemplateVarForm: TfrmPickTemplateVar;
    PickComparator : TfrmPickComparator;
    procedure btnAddToEditClickAllowedPages(Sender: TObject;AllowedPages : TWizPagesSet = [twzAll]);
    procedure HandleAnEditChange(AEdit: TEdit);
    procedure HandleAddFieldToEdit(AEdit : TEdit);
    procedure HandleAddFunctionToEdit(AEdit : TEdit; AllowedPages : TWizPagesSet = [twzAll]);
    procedure HandleAddObjToEdit(AEdit : TEdit);
    procedure HandleAddVarToEdit(AEdit : TEdit);
    procedure HandleAddComparatorToEdit(AEdit : TEdit);
    function IsFn(S : string) : boolean;
    function TextWrap(S : string) : string;
    function TextWrapFnIfNeeded(FnStr : string) : string;
    function NumWrapFnIfNeeded(FnStr : string) : string;
    function GetUserSelectedObject: string;
    procedure HandleAddTextToEdit(UserText : string; AEdit : TEdit);
    procedure SetDisplay;
    function GetFNPrefixForEdit(AEdit : TEdit) : TEditsRec;
    function GetNameNum(AName : string): integer;
    procedure LoadEditsRecFromTabPage (OneTabSheet : TTabSheet; var ARec : TEditsRec);
    procedure ClearEditsRec (var ARec : TEditsRec);
    function GetEditForButton(AButton: TButton) : TEdit;
    function GetGridForButton(AButton: TButton; var Prefix : string) : TStringGrid;
    function GetPageHoldingControl(AControl : TControl) : TTabSheet;
    function LaunchFnWizard(var UserFunction : string; AllowedPages : TWizPagesSet = [twzAll]) : integer;
    function CheckSelection(Grid: TStringGrid; var SelCol, SelRow : integer) : boolean; //returns if OK
    procedure HandleAGridChange(Prefix: String; Grid : TStringGrid);
    procedure HandleAddFunctionToGrid(AButton : TButton);
    procedure HandleAddFieldToGrid(AButton : TButton);
    procedure HandleAddObjectToGrid(AButton : TButton);
    procedure HandleAddVarToGrid(AButton : TButton);
    procedure HandleGridAddALL(Grid : TStringGrid; Text, Prefix : string);
    procedure HandleAddRowClick(Grid : TStringGrid);
    procedure HandleDelRowClick(Grid : TStringGrid);
    function RowEmpty(Grid : TStringGrid; ARow : integer) : boolean;
    function RowValue(Grid : TStringGrid; ARow : integer) : string;
    procedure ClearGrid(Grid: TStringGrid);
    procedure ClearAllEdits;
    procedure SetupAllowedPages(frmFnWizard : TfrmFnWizard; AllowedPages : TWizPagesSet = [twzAll]);
  public
    { Public declarations }
    UserFunction : string;
    constructor Create(AOwner: TComponent; ARichEdit : TRichEdit);
    destructor Destroy;
  end;

var
  frmFnWizard: TfrmFnWizard;

implementation

uses  fFormulaHelper, uEvaluateExpr;

{$R *.dfm}

function GetExcludedWizPagesSet(ExcludedPages : TWizPagesSet) : TWizPagesSet;
//Return set of all wizard web pages, with ExcludedPages removed
begin
  if twzNone in ExcludedPages then begin
    Result := ALL_WIZ_PAGES;
    exit;
  end else if twzAll in ExcludedPages then begin
    Result := [];
    exit;
  end;
  Result := ALL_WIZ_PAGES - ExcludedPages;
end;

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

procedure TfrmFnWizard.lbCommandsClick(Sender: TObject);
var SelNum, i : integer;
    //PageIndex : word;
    SelPage : TTabSheet;
begin
  SelNum := 0;
  SelPage := nil;
  for i  := 0 to lbCommands.Items.Count - 1 do begin
    if lbCommands.Selected[i] then begin
      //SelNum := i;
      //PageIndex := Word(lbCommands.Items.Objects[i]);
      SelPage := TTabSheet(lbCommands.Items.Objects[i]);
      break;
    end;
  end;
//  pcCommandsDetail.ActivePageIndex := SelNum + 1;
//  pcCommandsDetail.ActivePageIndex := PageIndex;
  if assigned(SelPage) then begin
    pcCommandsDetail.ActivePage := SelPage;
  end else begin
    pcCommandsDetail.ActivePageIndex := 0;
  end;
end;

procedure TfrmFnWizard.SetDisplay;
var IsGood : boolean;
begin
  lblFnResult.Caption := UserFunction;
  IsGood := UserFunction <> '';
  lblFnTitle.Visible := IsGood;
  lblFnResult.Visible := IsGood;
  BtnOK.Enabled := IsGood;
end;

function TfrmFnWizard.GetNameNum(AName : string): integer;  //Return trailing number in name xxxxx1234
var NumS : string;
    i : integer;
begin
  NumS := '';
  for i := Length(AName) downto 1 do begin
    if AName[i] in ['0'..'9'] then begin
      NumS := AName[i] + NumS;
    end else begin
      break;
    end;
  end;
  Result := StrToIntDef(NumS,0);
end;


function TfrmFnWizard.GetPageHoldingControl(AControl : TControl) : TTabSheet;
var i, j : integer;
    OneTabSheet : TTabSheet;
    OneControl : TControl;

begin
  Result := nil;
  for i := 0 to pcCommandsDetail.PageCount - 1 do begin
    if assigned(Result) then break;
    OneTabSheet := pcCommandsDetail.Pages[i];
    for j := 0 to OneTabSheet.ControlCount - 1 do begin
      OneControl := OneTabSheet.Controls[j];
      if OneControl <> AControl then continue;
      Result := OneTabSheet;
    end;
  end;
end;

procedure TfrmFnWizard.ClearEditsRec (var ARec : TEditsRec);
var i : integer;
begin
  for i := 1 to MAX_NUM_EDITS do ARec.Edit[i] := nil;
  ARec.Prefix := '';
end;

procedure TfrmFnWizard.LoadEditsRecFromTabPage (OneTabSheet : TTabSheet; var ARec : TEditsRec);
var i, j : integer;
    OneControl : TControl;
    OneEdit : TEdit;
    SL : TStringList;
    AName : string;

begin
  SL := TStringList.Create;
  ClearEditsRec(ARec);

  AName := OneTabSheet.Caption;
  AName := MidStr(AName, 1, Length(AName)-2);
  ARec.Prefix := AName;
  for j := 0 to OneTabSheet.ControlCount - 1 do begin
    OneControl := OneTabSheet.Controls[j];
    if not (OneControl is TEdit) then continue;
    SL.AddObject(OneControl.Name, OneControl);
  end;
  for i := 0 to SL.Count - 1 do begin
    OneEdit := TEdit(SL.Objects[i]);
    j := GetNameNum(OneEdit.Name);
    if j = 0 then j := 1;
    if j > MAX_NUM_EDITS then continue;
    ARec.Edit[j] := OneEdit;
  end;
  SL.Free;
end;


procedure TfrmFnWizard.pcCommandsDetailChange(Sender: TObject);
var PageIndex : integer;
    i : integer;
begin
  PageIndex := pcCommandsDetail.ActivePageIndex;
  for i := 0 to lbCommands.Count - 1 do begin
    lbCommands.Selected[i] := false;
  end;
  if PageIndex > 0 then begin
    lbCommands.Selected[PageIndex-1] := true;
  end;  
end;

function TfrmFnWizard.GetFNPrefixForEdit(AEdit : TEdit) : TEditsRec;
var OneTabSheet : TTabSheet;
begin
  ClearEditsRec(Result);
  OneTabSheet := GetPageHoldingControl(AEdit);
  if not assigned(OneTabSheet) then exit;
  LoadEditsRecFromTabPage (OneTabSheet, Result);
end;

function TfrmFnWizard.GetEditForButton(AButton: TButton) : TEdit;
var OneTabSheet : TTabSheet;
    ARec : TEditsRec;
    AName : string;
    i : integer;
begin
  Result := nil;
  ClearEditsRec(ARec);
  OneTabSheet := GetPageHoldingControl(AButton);
  if not assigned(OneTabSheet) then exit;
  LoadEditsRecFromTabPage (OneTabSheet, ARec);
  AName := AButton.Name;
  i := GetNameNum(AName);
  if i=0 then i := 1;
  if (i > MAX_NUM_EDITS) then exit;
  Result := ARec.Edit[i];
end;

function TfrmFnWizard.GetGridForButton(AButton: TButton; Var Prefix : string) : TStringGrid;
var OneTabSheet : TTabSheet;
    j : integer;
    OneControl : TControl;
begin
  Result := nil;
  Prefix := '';
  OneTabSheet := GetPageHoldingControl(AButton);
  if assigned(OneTabSheet) then begin
    Prefix := OneTabSheet.Caption;
    Prefix := MidStr(Prefix, 1, Length(Prefix)-2);
    for j := 0 to OneTabSheet.ControlCount - 1 do begin
      OneControl := OneTabSheet.Controls[j];
      if not (OneControl is TStringGrid) then continue;
      Result := TStringGrid(OneControl);
      break;
    end;
  end;
end;


procedure TfrmFnWizard.AnEditChange(Sender: TObject);
begin
  HandleAnEditChange(TEdit(Sender));
end;

procedure TfrmFnWizard.BOOLEdit2Change(Sender: TObject);
var  IsOK : boolean;
     s : string;
begin
  s := UpperCase(BoolEdit2.Text);
  IsOK :=  (s='&')   or (s='AND') or
           (s='!')   or (s='OR') or
           (s='''')  or (s='NOT') or
           (s='>')   or
           (s='>=')  or (s='''<') or
           (s='''=') or (s='<>')  or
           (s='<')   or
           (s='<=')  or (s='''>') or
           (s='=');
  if IsOK then begin
    BOOLEdit2.Color := clWindow;
  end else begin
    BOOLEdit2.Color := $008080FF;
  end;
  HandleAnEditChange(TEdit(Sender));
end;

procedure TfrmFnWizard.HandleAnEditChange(AEdit: TEdit);
var temp            : TEditsRec;
    OneArg,Args, s  : string;
    OneEdit         : TEdit;
    i               : integer;
    OptionalArg     : boolean;
begin
  temp := GetFNPrefixForEdit(AEdit);
  s := temp.Prefix;
  if s <> '' then begin
    Args := '';
    for i := 1 to MAX_NUM_EDITS do begin
      if temp.Edit[i] = nil then break;
      OneEdit := temp.Edit[i];
      OptionalArg := (((i=4) and (temp.Prefix = 'PIECE')) or
                      ((i=2) and (temp.Prefix = 'LOG')));
      OneArg := OneEdit.Text;
      if (OneArg='') and not OptionalArg then OneArg := '???';
      if (Args <> '') and (OneArg <> '') then Args := Args + ', ';
      Args := Args + OneArg;
    end;
    s := s + '(' + Args + ')';
  end;
  UserFunction := s;
  SetDisplay;
end;


//----------------------

function TfrmFnWizard.LaunchFnWizard(var UserFunction : string; AllowedPages : TWizPagesSet) : integer;
//Creates a sub-instances of FnWizard and launches to display on top of current one.
//UserFunction is really output parameter.
var tempFnWizard: TfrmFnWizard;
begin
  Result := mrCancel;
  tempFnWizard := TfrmFnWizard.Create(Self, RE);
  tempFnWizard.Top := Self.Top + 20;
  tempFnWizard.Left := Self.Left + 20;
  SetupAllowedPages(tempFnWizard, AllowedPages);
  Result := tempFnWizard.ShowModal;
  UserFunction := tempFnWizard.UserFunction;
  FreeAndNil(tempFnWizard);
end;

procedure TfrmFnWizard.SetupAllowedPages(frmFnWizard : TfrmFnWizard; AllowedPages : TWizPagesSet = [twzAll]);
//NOTE: this function can only be called once for a given instance of the frmWizard.  It perminently removes
//      pages that are not to be shown.
  function IndexOfTabSheet(PC : TPageControl; P : TTabSheet) : integer;
  var i : integer;
  begin
    Result := -1;
    for i := 0 to PC.PageCount - 1 do begin
      if PC.Pages[i] = P then begin
        Result := i;
        exit;
      end;
    end;
  end;

var i : integer;
    //PageIndex : Word;
    APageEnum : TWizPage;
    OneTabSheet : TTabSheet;
    Show : boolean;
begin
  if twzAll in AllowedPages then begin
    AllowedPages := ALL_WIZ_PAGES;
  end else if twzNone in AllowedPages then begin
    AllowedPages := [];
  end;
  frmFnWizard.lbCommands.Items.Assign(frmFnWizard.lbCommandsStore);  //reset to all allowed
  for i := 0 to frmFnWizard.lbCommands.Items.Count - 1 do begin
    //PageIndex := Word(frmFnWizard.lbCommands.Items.Objects[i]);
    OneTabSheet := TTabSheet(frmFnWizard.lbCommands.Items.Objects[i]);
    //PageIndex := IndexOfTabSheet(frmFnWizard.pcCommandsDetail, OneTabSheet);
    //if PageIndex < 1 then continue;
    APageEnum := TWizPage(OneTabSheet.Tag);
    Show := (APageEnum in AllowedPages);
    if not Show then begin
      OneTabSheet.PageControl := nil;
    end;
  end;
  //Remove all disallowed items from list.
  for i := frmFnWizard.lbCommands.Items.Count - 1 downto 0 do begin
    OneTabSheet := TTabSheet(frmFnWizard.lbCommands.Items.Objects[i]);
    if OneTabSheet.PageControl = nil then frmFnWizard.lbCommands.Items.Delete(i);
    //PageIndex := Word(frmFnWizard.lbCommands.Items.Objects[i]);
    //if PageIndex = 0 then frmFnWizard.lbCommands.Items.Delete(i);
  end;
end;


procedure TfrmFnWizard.sgCASEArgsExit(Sender: TObject);
var ARow : integer;
    S : string;
begin
  for ARow := 1 to sgCASEArgs.RowCount-1 do begin
    s := sgCASEArgs.Cells[1,ARow];
    if s='' then continue;
    sgCASEArgs.Cells[1,ARow] := TextWrapFnIfNeeded(s);
  end;
  HandleAGridChange('CASE', sgCASEArgs);
end;

function TfrmFnWizard.GetUserSelectedObject: string;
begin
  PickTemplateObjectForm.ShowModal;
  Result := tempRE.Text;
end;

function TfrmFnWizard.IsFn(S : string) : boolean;
var FnName : string;
begin
  FnName := Piece(S, '(',1);
  Result := uEvaluateExpr.FunctionNameOK(FnName);
end;

function TfrmFnWizard.TextWrap(S : string) : string;
begin
  Result := 'TEXT(' + S + ')';
end;

function TfrmFnWizard.TextWrapFnIfNeeded(FnStr : string) : string;
var FnName : string;
begin
  Result := FnStr;
  FnName := UpperCase(Piece(FnStr,'(',1));
  if (not IsFn(FnName)) or
     (FnName = 'CASE') or
     (FnName = 'SETPIECE') or
     (FnName = 'PIECE') then begin
    Result := TextWrap(FnStr);
  end;
end;

function TfrmFnWizard.NUMWrapFnIfNeeded(FnStr : string) : string;
//If input is not already a function, then wrap with NUM()
var FnName : string;
begin
  Result := FnStr;
  FnName := UpperCase(Piece(FnStr,'(',1));
  if IsFn(FnName) then exit;
  Result := 'NUM(' + FnStr + ')';
end;

procedure TfrmFnWizard.HandleAddObjToEdit(AEdit : TEdit);
var UserPick : string;
begin
  UserPick := GetUserSelectedObject;
  if UserPick = '' then exit;
  HandleAddTextToEdit(TextWrap(UserPick), AEdit);
end;

procedure TfrmFnWizard.HandleAddFunctionToEdit(AEdit : TEdit; AllowedPages : TWizPagesSet = [twzAll]);
var UserFn : string;
begin
  if LaunchFnWizard(UserFn, AllowedPages) = mrOK then begin
    UserFn := TextWrapFnIfNeeded(UserFn);
    HandleAddTextToEdit(UserFn, AEdit);
  end;
end;

procedure TfrmFnWizard.HandleAddFieldToEdit(AEdit : TEdit);
begin
  if PickTemplateFieldForm.ShowModal <> mrOK then exit;
  HandleAddTextToEdit(TextWrap(PickTemplateFieldForm.FieldName), AEdit);
end;

procedure TfrmFnWizard.HandleAddVarToEdit(AEdit : TEdit);
begin
  if PickTemplateVarForm.ShowModal <> mrOK then exit;
  HandleAddTextToEdit(PickTemplateVarForm.VarName, AEdit);
end;

procedure TfrmFnWizard.HandleAddComparatorToEdit(AEdit : TEdit);
begin
  if PickComparator.ShowModal <> mrOK then exit;
  HandleAddTextToEdit(PickComparator.GetSelected, AEdit);
end;


procedure TfrmFnWizard.HandleAddTextToEdit(UserText : string; AEdit : TEdit);
var s : string;
begin
  if not assigned(AEdit) then exit;
  s := AEdit.Text;
  if s <> '' then s := s + ' ';
  s := s + UserText;
  AEdit.Text := s;
  HandleAnEditChange(AEdit);
end;


//--------------------------
procedure TfrmFnWizard.HandleAddFieldToGrid(AButton : TButton);
var //SelCol, SelRow: integer;
    UserFld, Prefix : string;
    Grid : TStringGrid;
begin
  Grid := GetGridForButton(AButton, Prefix);
  if not assigned(Grid) then exit;
  if PickTemplateFieldForm.ShowModal <> mrOK then exit;
  UserFld := PickTemplateFieldForm.FieldName;
  HandleGridAddALL(Grid, UserFld, Prefix);
end;

procedure TfrmFnWizard.HandleAddFunctionToGrid(AButton : TButton);
var UserFn, Prefix : string;
    Grid : TStringGrid;
    AllowedPages : TWizPagesSet;
    SelCol, SelRow: integer;
begin
  Grid := GetGridForButton(AButton, Prefix);
  if not assigned(Grid) then exit;
  AllowedPages := ALL_WIZ_PAGES;
  if Grid = sgCASEArgs then begin
    if not CheckSelection(Grid, SelCol, SelRow) then exit;
    if SelCol = 0 then AllowedPages := [twzBOOL];
  end;
  if LaunchFnWizard(UserFn, AllowedPages) <> mrOK then exit;
  HandleGridAddALL(Grid, UserFn, Prefix);
end;

procedure TfrmFnWizard.HandleAddObjectToGrid(AButton : TButton);
var Prefix, UserObj : string;
    Grid : TStringGrid;
begin
  Grid := GetGridForButton(AButton, Prefix);
  if not assigned(Grid) then exit;
  UserObj := GetUserSelectedObject;
  if UserObj = '' then exit;
  HandleGridAddALL(Grid, UserObj, Prefix);
end;

procedure TfrmFnWizard.HandleAddVarToGrid(AButton : TButton);
var Prefix : string;
    Grid : TStringGrid;
begin
  Grid := GetGridForButton(AButton, Prefix);
  if not assigned(Grid) then exit;
  if PickTemplateVarForm.ShowModal <> mrOK then exit;
  HandleGridAddALL(Grid, PickTemplateVarForm.VarName, Prefix);
end;

procedure TfrmFnWizard.HandleGridAddALL(Grid : TStringGrid; Text, Prefix : string);
var SelCol, SelRow: integer;
begin
  if not assigned(Grid) then exit;
  if not CheckSelection(Grid, SelCol, SelRow) then exit;
  if (Grid = sgCASEArgs) and (SelCol = 1) then begin
    if not IsFn(Text) then Text := 'TEXT(' + Text + ')';
  end;
  Grid.Cells[SelCol,SelRow] := Grid.Cells[SelCol,SelRow] + Text;
  HandleAGridChange(Prefix,Grid);
end;


procedure TfrmFnWizard.HandleStringEditExit(Sender: TObject);
//Ensure edit field, designed only to hold strings, has TEXT(..) wrapping.
//The reason for this is that any text with commas will be parsed into
//  different parameters.
//Note: Everything needs to be wrapped in TEXT(), because
//   -- data object etc could **resolve to** something with a comma
var s : string;
begin
  s := TEdit(Sender).Text;
  TEdit(Sender).Text := TextWrapFnIfNeeded(s);
  HandleAnEditChange(TEdit(Sender));
end;


procedure TfrmFnWizard.HandleNumEditExit(Sender: TObject);
//Ensure field does not contain invalid commas
var s : string;
begin
  s := TEdit(Sender).Text;
  if Pos(',',s) = 0 then exit;
  TEdit(Sender).Text := NumWrapFnIfNeeded(s);
  HandleAnEditChange(TEdit(Sender));
end;


//----------------------------------------
procedure TfrmFnWizard.btnGridAddRowClick(Sender: TObject);
var Prefix : string;
    Grid : TStringGrid;
begin
  Grid := GetGridForButton(TButton(Sender), Prefix);
  if not assigned(Grid) then exit;
  HandleAddRowClick(Grid);
end;

procedure TfrmFnWizard.btnGridDelRowClick(Sender: TObject);
var Prefix : string;
    Grid : TStringGrid;
begin
  Grid := GetGridForButton(TButton(Sender), Prefix);
  if not assigned(Grid) then exit;
  HandleDelRowClick(Grid);
end;

procedure TfrmFnWizard.btnAddToEditClickTEXT(Sender: TObject);
begin
  btnAddToEditClickAllowedPages(Sender, [twzTEXT,twzCase]);
end;

procedure TfrmFnWizard.btnAddToEditClickNUM(Sender: TObject);  //Sender it TButton
begin
  btnAddToEditClickAllowedPages(Sender, GetExcludedWizPagesSet([twzTEXT]));
end;

procedure TfrmFnWizard.btnAddBOOL2Click(Sender: TObject);
var OneEdit : TEdit;
begin
  OneEdit := GetEditForButton(TButton(Sender));
  if not assigned(OneEdit) then exit;
  HandleAddComparatorToEdit(OneEdit);
end;

procedure TfrmFnWizard.btnAddToEditClickAllowedPages(Sender: TObject; AllowedPages : TWizPagesSet);
var //ModalResult : integer;
    OneEdit : TEdit;

begin
  //PickFldFnObj.rgInsertType.ItemIndex := -1;
  PickFldFnObj := TfrmPickFldFnObj.Create(Self);
  PickFldFnObj.Top := Mouse.CursorPos.Y;
  PickFldFnObj.Left := Mouse.CursorPos.X;
  if PickFldFnObj.ShowModal = mrCancel then begin
    FreeAndNil(PickFldFnObj);
    exit;
  end;
  OneEdit := GetEditForButton(TButton(Sender));
  case PickFldFnObj.UserSelection of
    ifrtField:    HandleAddFieldToEdit(OneEdit);
    ifrtObject:   HandleAddObjToEdit(OneEdit);
    ifrtFunction: HandleAddFunctionToEdit(OneEdit, AllowedPages);
    ifrtVar:      HandleAddVarToEdit(OneEdit);
  end; //case
  FreeAndNil(PickFldFnObj);
end;


procedure TfrmFnWizard.btnAddToGridClick(Sender: TObject);   //Sender it TButton
//var ModalResult : integer;
begin
  PickFldFnObj := TfrmPickFldFnObj.Create(Self);
  PickFldFnObj.Top := Mouse.CursorPos.Y;
  PickFldFnObj.Left := Mouse.CursorPos.X;
  if PickFldFnObj.ShowModal = mrCancel then begin
    FreeAndNil(PickFldFnObj);
    exit;
  end;
  case PickFldFnObj.UserSelection of
    ifrtField:    HandleAddFieldToGrid(TButton(Sender));
    ifrtObject:   HandleAddObjectToGrid(TButton(Sender));
    ifrtFunction: HandleAddFunctionToGrid(TButton(Sender));
    ifrtVar:      HandleAddVarToGrid(TButton(Sender));
  end; //case
  FreeAndNil(PickFldFnObj);
end;


procedure TfrmFnWizard.HandleAddRowClick(Grid : TStringGrid);
var ACol : integer;
begin
  Grid.RowCount := Grid.RowCount + 1;
  for ACol := 0 to Grid.ColCount -1 do Grid.Cells[ACol, Grid.RowCount-1] := '';
end;

procedure TfrmFnWizard.HandleDelRowClick(Grid : TStringGrid);
var DelRow : integer;
    DelText : string;
    ARow, ACol : integer;
begin
  DelRow := Grid.Selection.Top;
  if not RowEmpty(Grid,DelRow) then begin
    DelText := RowValue(Grid,DelRow);
    if MessageDlg('Are you sure you want to delete row with: ' + #13#10+ #13#10+
                  '"'+DelText+'"?',mtConfirmation, mbOKCancel,0) <> mrOK then exit;
  end;
  for ARow := DelRow to Grid.RowCount - 1 do begin
    for ACol := 0 to Grid.ColCount -1 do begin
      Grid.Cells[ACol,ARow] := Grid.Cells[ACol,ARow+1];
    end;
  end;
  if Grid.RowCount= 1 then begin
    for ACol := 0 to Grid.ColCount -1 do Grid.Cells[ACol,0] := '';
  end else begin
    Grid.RowCount := Grid.RowCount - 1;
  end;
end;

procedure TfrmFnWizard.ClearGrid(Grid: TStringGrid);
var ARow, ACol : integer;
begin
  for ARow := Grid.FixedRows to Grid.RowCount - 1 do begin
    for ACol := 0 to Grid.ColCount -1 do begin
      Grid.Cells[ACol,ARow] := '';
    end;
  end;
end;

function TfrmFnWizard.CheckSelection(Grid: TStringGrid; var SelCol, SelRow : integer) : boolean; //returns if OK
begin
  Result := true;
  SelRow := Grid.Selection.Top;
  SelCol := Grid.Selection.Left;
  if (SelRow < 0) or (SelRow >= Grid.RowCount)
    or (SelCol < 0) or (SelCol >= Grid.ColCount) then begin
    MessageDlg('Please Select Cell First',mtError,[mbOK],0);
    Result := false;
  end;
end;

procedure TfrmFnWizard.GridSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
var Prefix : string;
begin
  Prefix := TStringGrid(Sender).Parent.Name;
  //Prefix := MidStr(Prefix, 1, Length(Prefix)-2);  //'Name()' --> 'Name'
  Prefix := MidStr(Prefix, 3, Length(Prefix));  //'Name()' --> 'Name'
  HandleAGridChange(Prefix, TStringGrid(Sender));
end;

function TfrmFnWizard.RowEmpty(Grid : TStringGrid; ARow : integer) : boolean;
var ACol : integer;
begin
  Result := true;
  for ACol := 0 to Grid.ColCount-1 do begin
    if Grid.Cells[ACol,ARow] <> '' then begin
      Result := false;
      break;
    end;
  end;
end;

function TfrmFnWizard.RowValue(Grid : TStringGrid; ARow : integer) : string;
var Args   : string;
    AValue : string;
    ACol : integer;

begin
  Args := '';
  for ACol := 0 to Grid.ColCount-1 do begin
    AValue := Grid.Cells[ACol,ARow];
    if AValue = '' then AValue := '???';
    if Args <> '' then Args := Args + ', ';
    Args := Args + AValue;
  end;
  Result := Args;
end;

procedure TfrmFnWizard.HandleAGridChange(Prefix: String; Grid : TStringGrid);

  function LastNonEmptyRow(Grid : TStringGrid) : integer;
  var ARow : integer;
  begin
    Result := Grid.RowCount-1;
    for ARow := Grid.RowCount-1 downto Grid.FixedRows do begin
      if RowEmpty(Grid, ARow) then begin
        Result := ARow-1;
      end else begin
        break;
      end;
    end;
  end;

var Args : string;
    MaxRow : integer;
    ARow : integer;
begin
  Args := '';
  MaxRow := LastNonEmptyRow(Grid);
  for ARow := Grid.FixedRows to MaxRow do begin
    if Args <> '' then Args := Args + ', ';

    Args := Args + RowValue(Grid, ARow);
  end;
  UserFunction := Prefix + '(' + Args + ')';
  SetDisplay;
end;


procedure TfrmFnWizard.ClearAllEdits;
var i, j : integer;
    OneTabSheet : TTabSheet;
    OneControl : TControl;
begin
  for i := 0 to pcCommandsDetail.PageCount - 1 do begin
    OneTabSheet := pcCommandsDetail.Pages[i];
    for j := 0 to OneTabSheet.ControlCount - 1 do begin
      OneControl := OneTabSheet.Controls[j];
      if not (OneControl is TEdit) then continue;
      TEdit(OneControl).Text := '';
    end;
  end;
end;

//----------------------------------------


constructor TfrmFnWizard.Create(AOwner: TComponent; ARichEdit : TRichEdit);
var i : integer;
    OneTabPage : TTabSheet;
    APageEnum : TWizPage;
begin
  inherited Create(AOwner);
  RE := ARichEdit;
  lbCommandsStore := TStringList.Create;
  for i := 0 to lbCommands.Items.Count - 1 do begin
    OneTabPage := pcCommandsDetail.Pages[i+1];
    lbCommands.Items.Objects[i] := OneTabPage;
    APageEnum := TWizPage(ord(FIRST_WZ_PAGE) + i);
    OneTabPage.Tag := Ord(APageEnum);
  end;
  lbCommandsStore.Assign(lbCommands.Items);
end;

destructor TfrmFnWizard.Destroy;
begin
  lbCommandsStore.Free;
  inherited Destroy;
end;

procedure TfrmFnWizard.FormCreate(Sender: TObject);
var
  i: integer;
  DoIt: boolean;
  //s : string;

begin
  PickTemplateFieldForm := TfrmPickTemplateField.Create(Self,RE);
  //PickFldFnObj := TfrmPickFldFnObj.Create(Self);
  PickTemplateVarForm := TfrmPickTemplateVar.Create(Self, RE);
  PickComparator := TfrmPickComparator.Create(Self);

  dmodShared.LoadTIUObjects;
  PickTemplateObjectForm := TfrmTemplateObjects.Create(Self);
  DoIt := TRUE;
  if (UserTemplateAccessLevel <> taEditor) then begin
    UpdatePersonalObjects;
    if uPersonalObjects.Count > 0 then begin
      DoIt := FALSE;
      for i := 0 to dmodShared.TIUObjects.Count-1 do begin
        if uPersonalObjects.IndexOf(Piece(dmodShared.TIUObjects[i],U,2)) >= 0 then begin
          PickTemplateObjectForm.cboObjects.Items.Add(dmodShared.TIUObjects[i]);
        end;
      end;
    end;
  end;
  if DoIt then begin
    FastAssign(dmodShared.TIUObjects, PickTemplateObjectForm.cboObjects.Items);
  end;
  tempRE.Text := '';
  PickTemplateObjectForm.Font := Font;
  PickTemplateObjectForm.RE := tempRE;
end;

procedure TfrmFnWizard.FormDestroy(Sender: TObject);
begin
  FreeAndNil(PickTemplateFieldForm);
  FreeAndNil(PickTemplateObjectForm);
  //FreeAndNil(PickFldFnObj);
  FreeAndNil(PickTemplateVarForm);
  FreeAndNil(PickComparator);
end;

procedure TfrmFnWizard.FormShow(Sender: TObject);
var i : integer;
begin
  ABSEdit.Text := '';
  pcCommandsDetail.ActivePageIndex := 0;
  for i := 0 to lbCommands.Items.Count - 1 do begin
    lbCommands.Selected[i] := false;
  end;
  SetDisplay;
  sgCASEArgs.Cells[0,0] := 'BOOL test';
  sgCASEArgs.Cells[1,0] := 'Result if test TRUE';
  ClearGrid(sgAVGArgs);
  ClearGrid(sgCASEArgs);
  ClearGrid(sgMAXArgs);
  ClearGrid(sgMINArgs);
  ClearAllEdits;
  UserFunction := '';
  SetDisplay;
end;

end.

