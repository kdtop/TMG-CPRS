unit fFormulaHelper;
//VEFA-261 Added entire unit

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, Buttons, Menus,
  fPickTemplateField, fPickTemplateVar, uTemplates, OrFn,
  fFnWizard, fInsertOperator, fBase508Form, VA508AccessibilityManager;

type
  TfrmFormulaHelper = class(TfrmBase508Form)
    pnlBottom: TPanel;
    pnlTop: TPanel;
    pnlExpanded: TPanel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    btnInsertDataObject: TBitBtn;
    cbUseExpanded: TCheckBox;
    reUserInput: TRichEdit;
    Panel3: TPanel;
    btnInsertFn: TBitBtn;
    btnInsertFld: TBitBtn;
    btnInsertOperator: TBitBtn;
    reExpanded: TRichEdit;
    lblEditBelow: TLabel;
    Image1: TImage;
    pnlHolder: TPanel;
    Splitter1: TSplitter;
    edtStoreVarName: TEdit;
    lblOutputVar: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    btnInsertVar: TBitBtn;
    cbSilentFunction: TCheckBox;
    btnClear: TBitBtn;
    edtMessage: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure btnClearMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edtStoreVarNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure cbSilentFunctionClick(Sender: TObject);
    procedure btnInsertVarClick(Sender: TObject);
    procedure edtStoreVarNameChange(Sender: TObject);
    procedure reExpandedKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure reUserInputKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure reExpandedKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure reUserInputKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure reExpandedChange(Sender: TObject);
    procedure reUserInputEnter(Sender: TObject);
    procedure reExpandedEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure reUserInputChange(Sender: TObject);
    procedure btnInsertFldClick(Sender: TObject);
    procedure btnInsertFnClick(Sender: TObject);
    procedure btnInsertOperatorClick(Sender: TObject);
    procedure btnInsertDataObjectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FnWizardForm: TfrmFnWizard;
    PickOperatorForm: TfrmPickOperator;
    PickTemplateFieldForm: TfrmPickTemplateField;
    PickTemplateVarForm: TfrmPickTemplateVar;
    FieldsList : TStringList;  //Will store as: string=Field_NAME, Integer(object)=char pos.
    RE : TRichEdit;
    ActiveRE : TRichEdit;
    NonActiveRE : TRichEdit;
    UpdatingRE : boolean;
    UpdatingOutputVarName : boolean;
    LastKeyPress : word;
    FormDirty : boolean;
    procedure ExpandAndCheckFunction(Expr : String; OutSL : TStrings; var ErrStr : string);
    procedure InsertAtCursor(Text : string);
    procedure SetActiveRichEdit(ARichEdit : TRichEdit);
    function CollapseFormula(RE: TRichEdit) : string;
    procedure SetMessage(Text : string);
    function CheckCursorPos(var Key: Word;RichEdit:TRichEdit):Word;
    function GetOutputStoreName : string;
    function GetOutputStoreVarName(Text : string) : string;
    function SetOutputStoreVarName(Text, VarName : string) : string;
    function CheckOutputVarName(RE : TRichEdit; var ErrStr : string) : Boolean;
    function InsideTags(Text, TagStart, TagEnd : string; CurPos : integer) : boolean;
    //function GetCurrentField(RE : TRichEdit; TagHeader, TagFooter:string; CurPos:integer):string;
    function InsideFunctionName(var Text : string; Pos : integer; FnName : string) : boolean;
    function InsideRestricted(Text : string; Pos : integer; var TagStart, TagEnd : string) : boolean; overload;
    function InsideRestricted(RE: TRichEdit; var TagStart, TagEnd : string) : boolean; overload;
    procedure MoveOutsideRestricted(RE: TRichEdit; TagStart, TagEnd : string; BackupMode : boolean);
    procedure EnsureNotInsideRestricted(RE: TRichEdit);
    procedure HighlightJustTags(RichEdit: TRichEdit;TagHeader: string;color: tcolor);
    //procedure HighlightTags(RichEdit: TRichEdit;TagHeader,TagFooter: string; color: tcolor);
    procedure HighlightARichEdit(RE: TRichEdit; IsActiveRE : boolean);
    function TrimFormula(Formula : string) : string;
    Function ValidStoreName(Name : string): boolean;
    procedure TrimEndofREText(RE : TRichEdit);
    function HandleTags(OrigFormula : string; RemoveTag: boolean): string;
    function GetStoreVarName(OriginalFormula: string):string;
    function RemoveStoreVar(OrigText: string):string;
    Function ValidStoreChar(Key : Char): boolean;
  public
    { Public declarations }
    InitialFormula : string;
    constructor Create(AOwner: TComponent; ARichEdit : TRichEdit);
    function GetFormula : string;
  end;

  function GetCurrentField(RE : TRichEdit; TagHeader,TagFooter:string;CurPos:integer):string;            forward;
  procedure HighlightTags(RichEdit: TRichEdit;TagHeader,TagFooter: string;color: tcolor);                forward;


var
  frmFormulaHelper: TfrmFormulaHelper;
  mnuInsertFormula : TMenuItem;  //will be inserted into fTemplateEditor main menu.
  mnuBPInsertFormula : TMenuItem;  //will be inserted into fTemplateEditor main menu.


const
  clPaleYellow = $0080FFFF;
  clPaleBlue = $00ECE2D5;
  clPaleGreen = $0084FF84;
  clPaleRed = $009D9DFF;
  clPaleOrange = $0066B3FF;


implementation

{$R *.dfm}

uses
  StrUtils, RichEdit,fTemplateObjects, dShared, uEvaluateExpr;


const
    FN_OPEN_TAG = '{FN:';         FN_CLOSE_TAG = '}';
    FLD_OPEN_TAG = '[FLD:';       FLD_CLOSE_TAG = ']';
    FN_VAR_OPEN_TAG = '[FN:';     FN_VAR_CLOSE_TAG = ']';
    DATAOBJ_OPEN_TAG = '|';       DATAOBJ_CLOSE_TAG = '|';
    NEEDS_TRIM = 'Trim';

    OBJ_COLORS      : array[False .. True] of TColor = (clPaleYellow, clWebYellow);
    FN_COLORS       : array[False .. True] of TColor = (clPaleYellow, clWebYellow);
    FLD_COLORS      : array[False .. True] of TColor = (clPaleYellow, clWebYellow);
    FN_VAR_COLORS   : array[False .. True] of TColor = (clPaleOrange, clPaleOrange);
    NUM_FN__COLORS  : array[False .. True] of TColor = (clPaleGreen,  clPaleGreen);

    NUM_OPERATORS = 5;
    //Note: the operators are in order of evaluation.
    ALLOWED_OPERATORS : array[1..NUM_OPERATORS] of char = (
      '^',
      '*',
      '/',
      '+',
      '-'
    );

//var
//     frmTemplateObjects: TfrmTemplateObjects = nil;

type
    SingleArgFn = function(X: Real) : Real;
    SLArgFn = function(SL : TStringList; var ErrStr : string) : real;
    SLArgStrFn = function(SL : TStringList; var ErrStr : string) : string;
    FnRec = record
      Name : string;
      case integer of
        0 : (Fn : SingleArgFn);
        1 : (SLFn : SlArgFn);
        2 : (SLStrFn : SLArgStrFn);
    end;

const
    NUM_FNS = 20;
    MAX_SINGLE_VAL_FNS = 6;
    {
    FUNCTIONS : array [1..NUM_FNS] of string = (
      //-- Single parameter functions ----
      'ROUND',
      'FLOOR',
      'CEIL',
      'EXP',
      'SQRT',
      'ABS',
      //-- single-valued SL parameter functions --
      'TEXT',
      'NUM',
      //-- multi-value parameter functions --
      'AVG',
      'MAX',
      'MIN',
      'MOD',
      'DIV',
      'DIGITS',
      'BOOL',
      'PIECE',
      'IN',
      'CASE',
      'POWER',
      'NUMPIECES'
    );
    }
//---------------------------------------------------------------------------
//Functions / procedures not in class TfrmFormulaHelper
//---------------------------------------------------------------------------

function TfrmFormulaHelper.InsideTags(Text, TagStart, TagEnd : string; CurPos : integer) : boolean;
//NOTE: CurPos is a RichEdit.SelStart type number.

//NOTE: Richedit.Selstart positioning:
//  0 = cursor before first character
//  1 = cursor between 1st and 2nd characters.
//  e.g.  R O U N D
//        1 2 3 4 5   <-- e.g. Text[i]
//       0 1 2 3 4 5  <-- SelStart
//      Note that SelStart is INSIDE for positions 1..4 (not 1..5)

  procedure GetNextTagsPositions(var Text, TagStart, TagEnd : string; StartPos : integer; var P1, P2 : integer);
  begin
    P2 := 0;
    P1 := PosEx(TagStart, Text, StartPos);
    if P1 =0 then exit;
    P2 := PosEx(TagEnd, Text, P1 + Length(TagStart));
    if P2 = 0 then P1 := 0;
  end;

  function InRange(Value, StartNum, EndNum : integer) : boolean;
  begin
    Result := (Value >= StartNum) and (Value < EndNum);
  end;

var P, P1, P2: integer;
begin
  Result := false;
  if Text = '' then exit;
  P := 1;
  repeat
    GetNextTagsPositions(Text, TagStart, TagEnd, P, P1, P2);
    Result := InRange(CurPos, P1, P2);
    if (P1=0) or (P2=0) then exit;
    if Result = true then exit;
    P := P2 + Length(TagEnd);
  until false;
end;



function GetCurrentField(RE : TRichEdit; TagHeader, TagFooter:string; CurPos:integer):string;
var
   BegPos,EndPos: integer;
   Position, i: integer;
   tempField: string;
   FieldNum : integer;
   FieldNames: TStringList;
begin
   Result := '-1';
   Position := RE.Selstart;
   FieldNames := TStringList.Create;
   BegPos := RE.FindText(TagHeader,0, Length(RE.Text),[]);

   while BegPos <> -1 do begin   //Loop until we run out of headers
     EndPos :=BegPos + Length(TagHeader);
     EndPos := RE.FindText(TagFooter,EndPos,Length(RE.Text),[]);

     //Get the field name
     RE.SelStart := BegPos;
     RE.SelLength := EndPos-BegPos;
     tempField := RE.SelText;
     tempField := RightStr(tempField, Length(tempField)-Length(TagHeader));
     //messagedlg(tempField,mtInformation,[mbOK],0);

     //Search through previously found fields and count
     FieldNum := 1;
     for i := 0 to FieldNames.Count-1 do begin
       if tempField=FieldNames[i] then FieldNum := FieldNum + 1;
     end;

     //If the cursor position is inside this field, process and exit
     if (CurPos > BegPos) and (CurPos < EndPos) then begin  //we've found the field
       //messagedlg('FOUND IT ',mtInformation,[mbOK],0);
       Result := FLD_OPEN_TAG+inttostr(FieldNum)+':'+tempField+FLD_CLOSE_TAG;
       BegPos := -1;
     end else begin  //keep searching
       FieldNames.Add(tempField);
       BegPos := RE.FindText(TagHeader,EndPos, Length(RE.Text),[]);
     end;
   end;

   //Reset cursor position
   RE.SelStart := Position;
   RE.SelLength := 0;
   FieldNames.Free;
end;

function TfrmFormulaHelper.InsideFunctionName(var Text : string; Pos : integer; FnName : string) : boolean;
//NOTE: Pos is a RichEdit.SelStart type number.

//NOTE: Richedit.Selstart positioning:
//  0 = cursor before first character
//  1 = cursor between 1st and 2nd characters.
//  e.g.  R O U N D
//        1 2 3 4 5   <-- e.g. Text[i], or result of Pos() or PosEx()
//       0 1 2 3 4 5  <-- SelStart
//      Note that SelStart is INSIDE for positions 1..4 (not 1..5)

var p : integer;
begin
  p := 1;
  Result := false;
  repeat
    p := PosEx(FnName, Text, p);
    if p > 0 then begin
      Result := (Pos >= p) and (Pos < (P + Length(FnName)-1));
      if Result = true then break;
      p := p + length(FnName);
    end;
  until p = 0;
end;

function TfrmFormulaHelper.InsideRestricted(Text : string; Pos : integer; var TagStart, TagEnd : string) : boolean;
//NOTE: Pos is a RichEdit.SelStart type number.
//      (See InsideTags function)

var i : integer;
begin
  TagStart := DATAOBJ_OPEN_TAG; TagEnd := DATAOBJ_CLOSE_TAG;
  Result := InsideTags(Text, TagStart, TagEnd, Pos);
  if Result = true then exit;
  //----------
  TagStart := FLD_OPEN_TAG;  TagEnd := FLD_CLOSE_TAG;
  Result := InsideTags(Text, TagStart, TagEnd, Pos);
  if Result = true then exit;
  //----------
  TagStart := FN_VAR_OPEN_TAG;  TagEnd := FN_VAR_CLOSE_TAG;
  Result := InsideTags(Text, TagStart, TagEnd, Pos);
  if Result = true then exit;
  //----------
  TagEnd := '';
  for i := 1 to NumberOfFunctionNames {NUM_FNS} do begin
    //TagStart := FUNCTIONS[i];
    TagStart := GetFunctionName(i);
    if InsideFunctionName(Text, Pos, TagStart) then begin
      Result := true;
      exit;
    end;
  end;
  //----------
  TagStart := FN_OPEN_TAG;   //should always be the first characters in the string;
  if (Pos+1) <= Length(TagStart) then begin
    Result := true;
    exit;
  end;
  //----------
  TagStart := FN_CLOSE_TAG;  //should always be last character in the string;
  TagEnd := '';
  while (Ord(Text[Length(Text)]) < 33) do Text := MidStr(Text, 1, Length(Text)-1);  //trim off control characters and spaces
  //TagEnd := Text[Pos];
  if Text[Length(Text)] <> FN_CLOSE_TAG then TagEnd := NEEDS_TRIM;
  if Pos >= Length(Text) then begin
    Result := true;
    exit;
  end;
end;


function TfrmFormulaHelper.InsideRestricted(RE: TRichEdit; var TagStart, TagEnd : string) : boolean;
var
  //Inside : boolean;
  NewStartSel : integer;
  Text : string;
begin
  NewStartSel := RE.SelStart;
  Text := RE.Text;
  Result := InsideRestricted(Text, NewStartSel, TagStart, TagEnd);
end;


procedure TfrmFormulaHelper.MoveOutsideRestricted(RE: TRichEdit; TagStart, TagEnd : string; BackupMode : boolean);
//Assumes that InsideFunctionOrObject has been called and RE.SelTart is, in fact, inside Tags
var
  InsideField : boolean;
  NewStartSel : integer;
  IncAmount : integer;
  Text : string;
begin
  NewStartSel := RE.SelStart;
  Text := RE.Text;
  if (RE.FindText(FN_OPEN_TAG, 0, Length(RE.Text), []) = -1) or (RE.FindText(FN_CLOSE_TAG, 0, Length(RE.Text), []) = -1) then begin
     BackupMode := False;
     exit;
  end;   
  Repeat
    if BackupMode then IncAmount := -1 else IncAmount := 1;
    NewStartSel := NewStartSel + IncAmount;
    InsideField := InsideRestricted(Text, NewStartSel, TagStart, TagEnd);
    if TagStart = FN_OPEN_TAG  then begin
      BackupMode := False;
    end;
    if TagStart = FN_CLOSE_TAG then begin
      BackupMode := True;
    end;
  until not InsideField;
  if TagEnd = NEEDS_TRIM then TrimEndofREText(RE);
  if NewStartSel = RE.SelStart then exit;
  RE.SelStart := NewStartSel;
  RE.SelLength := 0;
end;

procedure TfrmFormulaHelper.TrimEndofREText(RE : TRichEdit);
var
  EndPos,i: integer;
begin
  EndPos := 0;
  i := 0;
  while i > -1 do begin
    EndPos := i;
    i := RE.FindText(FN_CLOSE_TAG,i+1,Length(RE.Text),[]);
  end;
  RE.Text := LeftStr(RE.Text,EndPos+1);
end;

procedure TfrmFormulaHelper.EnsureNotInsideRestricted(RE: TRichEdit);
var TagStart, TagEnd : string;
begin
  if InsideRestricted(RE, TagStart, TagEnd) then begin
    MoveOutsideRestricted(RE, TagStart, TagEnd, (LastKeyPress <> vk_Right));
  end;
end;


procedure TfrmFormulaHelper.HighlightJustTags(RichEdit: TRichEdit;TagHeader: string;color: tcolor);
var
    Format: CHARFORMAT2;
    BegPos, EndPos : integer;
    //LineNo : integer;
    SelStartSave, SelEndSave : integer;
begin
  if not assigned(RichEdit) then exit;

  FillChar(Format, sizeof(Format), 0);
  Format.cbsize := Sizeof(Format);
  Format.dwMask := CFM_BACKCOLOR;
  SelStartSave := RichEdit.SelStart;
  SelEndSave := RichEdit.SelLength;
  BegPos := RichEdit.FindText(TagHeader, 0, Length (RichEdit.Text),[]);

  while BegPos <> -1 do begin
    EndPos := BegPos + Length(TagHeader) - 1;
    //Highlight Header to Footer
    RichEdit.SelStart := BegPos;
    RichEdit.SelLength := Endpos-BegPos+1;
    Format.crBackColor := color;
    RichEdit.Perform(EM_SETCHARFORMAT, SCF_SELECTION, LongInt(@Format));
    BegPos := RichEdit.FindText(TagHeader, EndPos, Length(RichEdit.Text),[]);
  end;
  RichEdit.SelStart := SelStartSave;
  RichEdit.SelLength := SelEndSave;
end;


procedure HighlightTags(RichEdit: TRichEdit;TagHeader,TagFooter: string; color: tcolor);
var
    Format: CHARFORMAT2;
    BegPos, EndPos : integer;
    //LineNo : integer;
    SelStartSave, SelEndSave : integer;
begin
  if not assigned(RichEdit) then exit;

  FillChar(Format, sizeof(Format), 0);
  Format.cbsize := Sizeof(Format);
  Format.dwMask := CFM_BACKCOLOR;
  SelStartSave := RichEdit.SelStart;
  SelEndSave := RichEdit.SelLength;

  //BegPos := RichEdit.FindText(TagHeader,0,Length(RichEdit.Text),[]);
  BegPos := RichEdit.FindText(TagHeader, 0, Length(RichEdit.Text),[]);

  while BegPos <> -1 do begin
    EndPos := BegPos + Length(TagHeader);
    //EndPos := RichEdit.FindText(TagFooter,EndPos,Length(RichEdit.Text),[]);
    EndPos := RichEdit.FindText(TagFooter, EndPos, Length(RichEdit.Text),[]);
    if EndPos = -1 then break;

    //Highlight Header to Footer
    RichEdit.SelStart := BegPos;
    RichEdit.SelLength := Endpos-BegPos+1;
    Format.crBackColor := color;
    RichEdit.Perform(EM_SETCHARFORMAT, SCF_SELECTION, LongInt(@Format));
    //BegPos := RichEdit.FindText(TagHeader,EndPos,Length(RichEdit.Text),[]);
    BegPos := RichEdit.FindText(TagHeader, EndPos+1, Length(RichEdit.Text),[]);
  end;
  RichEdit.SelStart := SelStartSave;
  RichEdit.SelLength := SelEndSave;
end;


procedure TfrmFormulaHelper.HighlightARichEdit(RE: TRichEdit; IsActiveRE : boolean);
var i : integer;
    OneFn : string;
begin
  HighlightJustTags(RE, FN_OPEN_TAG, FN_COLORS[IsActiveRE]);
  //HighlightTags(RE, FN_OPEN_TAG,      FN_CLOSE_TAG,      FN_COLORS[IsActiveRE]);
  HighlightTags(RE, FLD_OPEN_TAG,     FLD_CLOSE_TAG,     FLD_COLORS[IsActiveRE]);
  HighlightTags(RE, DATAOBJ_OPEN_TAG, DATAOBJ_CLOSE_TAG, OBJ_COLORS[IsActiveRE]);
  HighlightTags(RE, FN_VAR_OPEN_TAG,  FN_VAR_CLOSE_TAG,   FN_VAR_COLORS[IsActiveRE]);

  for i := 1 to NumberOfFunctionNames {NUM_FNS} do begin
    //OneFn := FUNCTIONS[i] + '(';
    OneFn := GetFunctionName(i) + '(';
    HighlightJustTags(RE, OneFn, NUM_FN__COLORS[IsActiveRE]);
  end;
end;

function TfrmFormulaHelper.GetOutputStoreVarName(Text : string) : string;
//var Text : string;
begin
  Result := '';
  //Text := reUserInput.Lines.Text;
  Text := Midstr(Text,Length(FN_OPEN_TAG)+1, Length(TEXT));
  if Pos(':',Text)=0 then exit;
  Text := MidStr(Text,1, Pos(':',Text)-1);
  if Pos('[',Text)>0 then exit;  //Ignore [FLD:SomeName]
  AnsiReplaceStr(Text,#13,'');
  AnsiReplaceStr(Text,#10,'');
  Result := Trim(Text);
end;

function TfrmFormulaHelper.SetOutputStoreVarName(Text, VarName : string) : string;
var p : integer;
    StrB : string;
begin
  Result := Text;
  if GetOutputStoreVarName(Text)='' then begin
    StrB := MidStr(Text,Length(FN_OPEN_TAG)+1, Length(Text));
  end else begin
    p := PosEx(':',Text,length(FN_OPEN_TAG)+1);
    if p=0 then exit;  //shouldn't happen
    StrB := MidStr(Text,p+1,Length(Text));
  end;
  if VarName <> '' then VarName := VarName + ':';
  Result := FN_OPEN_TAG + VarName + StrB;
end;


Function TfrmFormulaHelper.ValidStoreName(Name : string): boolean;
var i : integer;
begin
  Result := true;
  for i  := 1 to Length(Name) do begin
    if not (Name[i] in ['a'..'z','A'..'Z','0'..'9']) then begin
      Result := false;
      exit;
    end;
  end;
end;

Function TfrmFormulaHelper.ValidStoreChar(Key : Char): boolean;
//var i : integer;
begin
  Result := true;
  if not (Key in ['a'..'z','A'..'Z','0'..'9']) then Result := false;
end;



function TfrmFormulaHelper.CheckOutputVarName(RE : TRichEdit; var ErrStr : string) : Boolean;
//Returns True if error
var OutputVarName : string;
    FlagsStr : string;

begin
  OutputVarName := GetOutputStoreVarName(RE.Lines.Text);
  FlagsStr := Piece(OutputVarName,'^',2);
  OutputVarName := Piece(OutputVarName,'^',1);
  if not ValidStoreName(OutputVarName) then begin
    ErrStr := '"' + OutputVarName + '" is not valid Output Storage Variable Name (only alpha and numeric characters allowed).';
    //OutputVarName := '<Invalid Name>';
    edtStoreVarName.Color := clPaleRed;
  end else begin
    ErrStr := '';
    edtStoreVarName.Color := clWindow;
  end;
  //VEFA-261  edtStoreVarName.OnChange := nil;
  //VEFA-261  edtStoreVarName.Text := OutputVarName;
  //VEFA-261  edtStoreVarName.OnChange := edtStoreVarNameChange;

  //VEFA-261  cbSilentFunction.OnClick := nil;
  //VEFA-261  cbSilentFunction.Checked := (Pos('H',FlagsStr)>0);
  //VEFA-261  cbSilentFunction.OnClick := cbSilentFunctionClick;
  Result := (ErrStr <> '');
end;

procedure TfrmFormulaHelper.edtStoreVarNameChange(Sender: TObject);
var Text : string;
    NewName : string;
begin
  if not UpdatingOutputVarName then begin
    UpdatingOutputVarName := true;
    Text := HandleTags(reUserInput.Lines.Text,False);
    NewName := edtStoreVarName.Text;
    edtStoreVarName.Text := NewName;
    if not ValidStoreName(NewName) then begin
      SetMessage('"' + NewName + '" is not valid Output Storage Variable Name.');
      //edtStoreVarName.Text := '<Invalid Name>';
      edtStoreVarName.Color := clPaleRed;
    end else begin
      SetMessage('');
      edtStoreVarName.Color := clWindow;
      if cbSilentFunction.Checked then NewName := NewName + '^H';
      Text := SetOutputStoreVarName(Text, NewName);
      reUserInput.Lines.Text := HandleTags(Text,True);
    end;
    UpdatingOutputVarName := false;
  end;
end;

procedure TfrmFormulaHelper.edtStoreVarNameKeyPress(Sender: TObject; var Key: Char);
begin
  if (not ValidStoreChar(Key)) AND (Key <> #8) then Key := #0;
end;

function TfrmFormulaHelper.GetStoreVarName(OriginalFormula: string):string;
var  NewName, Text: string;
begin
  Text := HandleTags(OriginalFormula,False);
  NewName := edtStoreVarName.Text;
  if (ValidStoreName(NewName)) and (NewName <> '') then begin
    if cbSilentFunction.Checked then NewName := NewName + '^H';
    Text := SetOutputStoreVarName(Text, NewName);
    //Result := HandleTags(Text,False);
  end;
  Result := HandleTags(Text,True);
end;

procedure TfrmFormulaHelper.cbSilentFunctionClick(Sender: TObject);
begin
  edtStoreVarNameChange(Sender);
end;




//---------------------------------------------------------------------------
//---------------------------------------------------------------------------


procedure TfrmFormulaHelper.btnCancelClick(Sender: TObject);
begin
  if (FormDirty) and (ActiveRE.Text <> '') then begin
    if messagedlg('You have not yet saved this formula' + #13#10 + 'Are you sure?',mtWarning,[mbYes,mbNo],0) = mrYes then begin
      ModalResult := mrCancel;
    end;
  end else ModalResult := mrCancel;
end;


procedure TfrmFormulaHelper.btnClearMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if [ssAlt,ssCtrl,ssShift] <= Shift then begin
    MessageDlg('Formula authors: Kevin Toppenberg and Eddie Hagood. Feb, 2012',mtInformation, [mbOK],0);
  end;
end;


procedure TfrmFormulaHelper.btnClearClick(Sender: TObject);
begin
  if (FormDirty) and (ActiveRE.Text <> '') then begin
    if messagedlg('You are about to delete this formula' + #13#10 + 'Are you sure?',mtWarning,[mbYes,mbNo],0) = mrYes then begin
      ActiveRE.Clear;
    end;
  end;
end;

procedure TfrmFormulaHelper.btnInsertDataObjectClick(Sender: TObject);
var
  frmTemplateObjects: TfrmTemplateObjects;
  i: integer;
  DoIt: boolean;
begin
  EnsureNotInsideRestricted(ActiveRE);
  dmodShared.LoadTIUObjects;
  frmTemplateObjects := TfrmTemplateObjects.Create(Self);
  DoIt := TRUE;
  if (UserTemplateAccessLevel <> taEditor) then begin
    UpdatePersonalObjects;
    if uPersonalObjects.Count > 0 then begin
      DoIt := FALSE;
      for i := 0 to dmodShared.TIUObjects.Count-1 do begin
        if uPersonalObjects.IndexOf(Piece(dmodShared.TIUObjects[i],U,2)) >= 0 then begin
          frmTemplateObjects.cboObjects.Items.Add(dmodShared.TIUObjects[i]);
        end;
      end;
    end;
  end;
  if DoIt then begin
    FastAssign(dmodShared.TIUObjects, frmTemplateObjects.cboObjects.Items);
  end;
  frmTemplateObjects.Font := Font;
  frmTemplateObjects.re := ActiveRE;

  frmTemplateObjects.ShowModal;
  ActiveRE.OnChange(self);
  //if ActiveRE.Name = 'reUserInput' then reUserInputChange(self) else reExpandedChange(self);
  frmTemplateObjects.Free;
end;

procedure TfrmFormulaHelper.InsertAtCursor(Text : string);
begin
  ActiveRE.SelText := Text;
end;

procedure TfrmFormulaHelper.btnInsertFnClick(Sender: TObject);
begin
  FnWizardForm.Top := Self.Top + 10;
  FnWizardForm.Left := Self.Left + 10;
  if FnWizardForm.ShowModal <> mrOK then exit;
  InsertAtCursor(FnWizardForm.UserFunction);
end;

procedure TfrmFormulaHelper.btnInsertFldClick(Sender: TObject);
begin
  if PickTemplateFieldForm.ShowModal <> mrOK then exit;
  EnsureNotInsideRestricted(ActiveRE);
  InsertAtCursor(PickTemplateFieldForm.FieldName);
end;

procedure TfrmFormulaHelper.btnInsertOperatorClick(Sender: TObject);
begin
  PickOperatorForm.Top := Mouse.CursorPos.Y;
  PickOperatorForm.Left := Mouse.CursorPos.X;
  if PickOperatorForm.ShowModal <> mrOK then exit;
  InsertAtCursor(PickOperatorForm.GetSelected);
  PickOperatorForm.rgOperators.ItemIndex := -1;
end;

procedure TfrmFormulaHelper.btnInsertVarClick(Sender: TObject);
begin
  if PickTemplateVarForm.ShowModal <> mrOK then exit;
  InsertAtCursor(PickTemplateVarForm.VarName);
end;

procedure TfrmFormulaHelper.btnOKClick(Sender: TObject);
begin
  InitialFormula := '';
end;

function TfrmFormulaHelper.GetFormula : string;
begin
  if cbUseExpanded.Checked then begin
    Result := HandleTags(GetStoreVarName(Trim(reExpanded.Lines.Text)),False);
  end else begin
    Result := HandleTags(GetStoreVarName(Trim(reUserInput.Lines.Text)),False);
  end;
end;

procedure TfrmFormulaHelper.SetMessage(Text : string);
begin
  if Text <> '' then begin
    edtMessage.Enabled := true;
    edtMessage.Color := clWhite;
    edtMessage.Text := Text;
    reUserInput.Color := clPaleRed;
    reExpanded.Color := clPaleRed;
  end else begin
    edtMessage.Enabled := false;
    edtMessage.Color := clBtnFace;
    edtMessage.Text := '';
    ActiveRE.Color := clPaleYellow;
    NonActiveRE.Color := clPaleBlue;
    //reUserInput.Color := clPaleRed;
  end;
end;

procedure TfrmFormulaHelper.reUserInputChange(Sender: TObject);
//Later I could put a 1 second delay on parsing.
var Expr, ErrStr : string;
    ExpandedSave : string;
begin
  Expr := HandleTags(reUserInput.Lines.Text,False);
  ExpandedSave := HandleTags(reExpanded.Lines.Text,False);
  if CheckOutputVarName(reUserInput, ErrStr) then begin
    edtMessage.Text := ErrStr;
  end;
  ExpandAndCheckFunction(Expr, reExpanded.Lines, ErrStr);
  if UpdatingRE and (ErrStr<> '') then begin
    reExpanded.Lines.Text := HandleTags(ExpandedSave,True);
  end;
  SetMessage(ErrStr);
  HighlightARichEdit(ActiveRE, True);
  HighlightARichEdit(NonActiveRE, False);
  FormDirty := True;
end;

function TfrmFormulaHelper.CollapseFormula(RE: TRichEdit) : string;
var i : integer;
begin
  Result := '';
  for i := 0 to RE.Lines.Count - 1 do begin
    Result := Result + ' ' + Trim(RE.Lines.Strings[i]);
  end;
end;


procedure TfrmFormulaHelper.reExpandedChange(Sender: TObject);
var FormulaText : string;
    //SavedText : string;
    ErrStr : string;
    SelStartSave, SelEndSave : integer;
begin
  if not UpdatingRE then begin
    UpdatingRE := true;
    if CheckOutputVarName(reExpanded, ErrStr) then begin
      edtMessage.Text := ErrStr;
    end;
    FormulaText := CollapseFormula(reExpanded);
    SelStartSave := reExpanded.SelStart;
    SelEndSave := reExpanded.SelLength;
    reUserInput.Lines.Text := FormulaText;
    reUserInputChange(Sender);
    if edtMessage.Text <> '' then begin
      //??restore text??
    end;
    reExpanded.SelStart := SelStartSave;
    reExpanded.SelLength := SelEndSave;
    //SetActiveRichEdit(reExpanded);
    UpdatingRE := false;
    FormDirty := True;
  end;
end;


function TfrmFormulaHelper.GetOutputStoreName : string;
begin

end;

procedure TfrmFormulaHelper.reUserInputEnter(Sender: TObject);
begin
  SetActiveRichEdit(reUserInput);
  EnsureNotInsideRestricted(ActiveRE);
end;

procedure TfrmFormulaHelper.reUserInputKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //Key := CheckCursorPos(Key,TRichEdit(Sender));
  LastKeyPress := Key;
end;

procedure TfrmFormulaHelper.reUserInputKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //InsideFunctionOrObject(ActiveRE);
  EnsureNotInsideRestricted(reUserInput);
end;

procedure TfrmFormulaHelper.reExpandedEnter(Sender: TObject);
//var Key : word;
begin
  SetActiveRichEdit(reExpanded);
  EnsureNotInsideRestricted(reExpanded);
end;

procedure TfrmFormulaHelper.reExpandedKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //Key := CheckCursorPos(Key,TRichEdit(Sender));
  LastKeyPress := Key;
end;

procedure TfrmFormulaHelper.reExpandedKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //InsideFunctionOrObject(ActiveRE);
  EnsureNotInsideRestricted(reExpanded);
end;

function TfrmFormulaHelper.CheckCursorPos(var Key: Word; RichEdit:TRichEdit):Word;
var BegPos: integer;
    LastPos: integer;
    LineNo : integer;
    //NewStartSel: integer;
    //Inside: boolean;
    //Text : String;
    //TagStart, TagEnd : String;
    //IncAmount : integer;
begin
  Result := Key;
   if (RichEdit.FindText('{', 0, Length(RichEdit.Text), []) = -1) or (RichEdit.FindText('}', 0, Length(RichEdit.Text), []) = -1) then begin
      messagedlg ('Tags have been removed',mtError,[mbOK],0);
      exit;
    end;

  //Find first '{'. If cursor is before, place it directly after
  BegPos := RichEdit.FindText('{', 0, Length(RichEdit.Text), []);
  if ((RichEdit.SelStart-1 <= BegPos) and (Key = vk_Left)) or (RichEdit.SelStart <= BegPos) then begin
    RichEdit.SelStart := BegPos+1;
    if Key = vk_Left then Result := 0;
  end;

  //Determine if cursor is on same line as '{'. If so, don't allow "UP" key
  LineNo := RichEdit.Perform(EM_LINEFROMCHAR,BegPos,0);
  if (LineNo = RichEdit.Perform(EM_LINEFROMCHAR,RichEdit.SelStart,0)) and (Key=vk_Up) then Result := 0;

  //Find final '}'. If cursor is beyond, place it directly before '}'
  BegPos := RichEdit.FindText('}',0,Length(RichEdit.Text),[]);

  LastPos := 0;
  while BegPos <> -1 do begin
    LastPos := BegPos;
    BegPos := RichEdit.FindText('}',BegPos+1,Length(RichEdit.Text),[]);
  end;
  LineNo := RichEdit.Perform(EM_LINEFROMCHAR,LastPos,0);
  if RichEdit.SelStart >= LastPos then begin
    RichEdit.SelStart := LastPos;
    if Key = vk_Right then Result := 0;
  end;
  if (LineNo = RichEdit.Perform(EM_LINEFROMCHAR,RichEdit.SelStart,0)) and (Key=vk_Down) then Result := 0;

  if Result = 0 then exit;  //Key negated, no further testing

  (*
  //NOTE: Richedit.Selstart positioning:
  //  0 = cursor before first character
  //  1 = cursor between 1st and 2nd characters.
  //  e.g.  R O U N D
  //        1 2 3 4 5   <-- e.g. Text[i]
  //       0 1 2 3 4 5  <-- SelStart
  //      Note that SelStart is INSIDE for positions 1..4 (not 1..5)

  //Test for Object or Field
  NewStartSel := RichEdit.SelStart;
  if Key=vk_Right then begin
    NewStartSel := NewStartSel + 1;
    IncAmount := 1;
  end else if Key=vk_left then begin
    NewStartSel := NewStartSel - 1;
    IncAmount := -1;
  end else begin
    IncAmount := -1;
  end;
  Text := RichEdit.Text;
  Inside := InsideRestricted(Text, NewStartSel, TagStart, TagEnd);
  if ((Key = vk_Right) or (Key = vk_Left)) and (Inside) then begin
  //if Inside then begin
    Repeat
      NewStartSel := NewStartSel + IncAmount;
      Inside := InsideRestricted(Text, NewStartSel, TagStart, TagEnd);
    until Not Inside;
    //NewStartSel := NewStartSel - IncAmount;
    RichEdit.SelStart := NewStartSel - 1;  //-1 to return to 0-based indexing
    RichEdit.SelLength := 0;
    if (Key = vk_Right) or (Key = vk_Left) then Key := 0;
  end;
  *)
end;

procedure TfrmFormulaHelper.SetActiveRichEdit(ARichEdit : TRichEdit);
begin
  ActiveRE := ARichEdit;
  if ActiveRE = reUserInput then begin
    NonActiveRE := reExpanded;
    reUserInput.OnChange := reUserInputChange;
    reExpanded.OnChange := nil;
  end else begin //ActiveRE = reExpanded
    NonActiveRE := reUserInput;
    reUserInput.OnChange := nil;
    reExpanded.OnChange := reExpandedChange;
  end;
  ActiveRE.Color := clPaleYellow;
  ActiveRE.ReadOnly := false;

  NonActiveRE.Color := clPaleBlue;
  NonActiveRE.ReadOnly := true;
end;




//---------------------------------------
//---------------------------------------
//code taken and modified from UEvaluateExpr
//---------------------------------------
//---------------------------------------

  function IsValidFn(Name: string) : boolean;
  //var i : integer;
  begin
    Result := uEvaluateExpr.FunctionNameOK(Name);
    {
    Result := false;
    for i := 1 to NUM_FNS do begin
      if FUNCTIONS[i] = Name then begin
        Result := true;
        break;
      end;
    end;
    }
  end;


  function IsFn(Expr : string) : boolean;
  begin
    Result := false;
    if Expr='' then exit;
    if Pos('(',Expr) = 0 then exit;
    if Expr[1] in ['[','|'] then exit;
    Result := true;
  end;


  function IndentStrNum(Count : integer) : string;
  begin
    Result := '';
    while Count>0 do begin
      Dec(Count);
      Result := Result + ' ';
    end;
  end;

  function FindPairedChars(Expr: string; var ErrStr : string; var P1,P2 : integer;
                           OpenChar : char = '(') : string;
  //Note: changed function such that search starts at P1
  var NestLevel : integer;
      i         : integer;
      EndIndex  : integer;
      CloseChar : char;
  begin
    if OpenChar = '(' then CloseChar := ')'
    else if OpenChar = '[' then CloseChar := ']'
    else if OpenChar = '{' then CloseChar := '}'
    else if OpenChar = '''' then CloseChar := ''''
    else if OpenChar = '"' then CloseChar := '"'
    else if OpenChar = '|' then CloseChar := '|'
    else begin
      ErrStr := '"'+OpenChar+'" not supported.';
      exit;
    end;
    P1 := PosEx(OpenChar,Expr,P1);
    if P1 < 1 then begin
      ErrStr := '"'+OpenChar+'" not found.';
      exit;
    end;
    NestLevel := 1;  //0
    EndIndex := 0;
    Result := '';
    //for i := P1 to length(Expr) do begin
    for i := P1+1 to length(Expr) do begin
      if Expr[i] = CloseChar then begin
        Dec(NestLevel);
        if NestLevel > 0 then continue;
        EndIndex := i;
        break;
      end;
      if Expr[i] = OpenChar then begin
        inc(NestLevel);
        continue;
      end;
    end;
    if (NestLevel > 0) or (EndIndex = 0) then begin
      ErrStr := 'Unmatched parentheses or other paired characters';
      exit;
    end;
    P2 := EndIndex;
  end;


  function GetPairedParentheses(var Expr: string; var ErrStr : string; OpenChar : char = '(') : string;
  //Expr must begin with '('
  //Result is the text in the matching parentheses.
  //Expr is modified to leave behind the rest of the string, following after removed result
  var P1, P2 : integer;
  begin
    P1 := 1;
    FindPairedChars(Expr, ErrStr, P1,P2, OpenChar);
    Result := MidStr(Expr,P1, P2);
    Expr := Trim(MidStr(Expr, P2+1,length(Expr)));
  end;


  function IsOperator(c : char) : boolean;
  var i : integer;
  begin
    Result := false;
    for i := 1 to NUM_OPERATORS do begin
      if ALLOWED_OPERATORS[i] <> c then continue;
      Result := true;
      break;
    end;
  end;


  procedure GetNextTermAndOperator(var Expr, Term, Operator, ErrStr : string);
  var i,P2 : integer;
      OperIdx : integer;
      OperatorOK : boolean;
  begin
    Expr := Trim(Expr);
    if Expr = '' then begin
      ErrStr := 'Expression term is empty';
      exit;
    end;
    Term := '';
    if (Expr[1]='+') then begin
      Expr := '0' + Expr;
    end;
    OperIdx := 0;
    i := 1;
    while i <= length(Expr) do begin
      if MidStr(Expr,i,5) =FLD_OPEN_TAG then begin
        FindPairedChars(Expr, ErrStr, i, P2,'[');
        if P2<= i then begin
          ErrStr := 'Unmatched brackets';
          exit;
        end;
        i := P2;
      end else if Expr[i]='|' then begin
        FindPairedChars(Expr, ErrStr, i, P2,'|');
        if P2<= i then begin
          ErrStr := 'Unmatched bars ("|")';
          exit;
        end;
        i := P2;
      end else if Expr[i]='(' then begin
        FindPairedChars(Expr, ErrStr, i, P2);
        if P2<= i then begin
          ErrStr := 'Unmatched parentheses';
          exit;
        end;
        i := P2;
      end else if IsOperator(Expr[i]) then begin
        if (i <> 1) or (Length(Expr)<2) or (Expr[2]=' ') then begin  //if '-25' don't take '-' as operator
          OperIdx := i;
          break;
        end;
      end;
      inc (i);
    end;
    if OperIdx > 0 then begin
      Term := Trim(MidStr(Expr,1,OperIdx-1));
      Expr := MidStr(Expr,OperIdx,length(Expr));
    end else begin
      Term := Expr;
      Expr := '';
    end;

    if ErrStr <> '' then exit;
    //Expr should have first term trimmed off now.
    //--- Now get operator ---
    Expr := Trim(Expr);
    if length(Expr)>0 then begin
      OperatorOK := IsOperator(Expr[1]);
      if not OperatorOK then begin
        ErrStr := 'Invalid operator ''' + Operator + '''';
        exit;
      end;
      Operator := Expr[1];
      Expr := Trim(MidStr(Expr,2,Length(Expr)));
    end else begin
      Operator := '';
    end;
  end;

  procedure ExprToParamSL(Expr : string; ParamSL : TStringList; var ErrStr : string);
  //Purpose: to break up comma delimited` parameter list into list.
  //  Examples of parameters:    a, b, c
  //                             a, ABS(-7.5), c
  //                             a, CASE( i>7, "too low", AVG(1, 2, 3)>5, "OK"), c
  //                             CASE( i>7, "too low", AVG(1, 2, 3)>5, "OK"), b, c
  var //i : integer;
      CommaPos, ParenPos : integer;
      SavedExpr : string;
      StrA,StrB : string;
  begin
    SavedExpr := Expr;
    ParamSL.Clear;
    Repeat
      CommaPos := Pos(',', Expr);
      ParenPos := Pos('(', Expr);
      if (CommaPos>0) and (CommaPos<ParenPos) then begin  //Both ','  and '(' present  and Comma FIRST
        StrA := MidStr(Expr, 1, CommaPos-1);
        ParamSL.Add(StrA);
        Expr := MidStr(Expr, CommaPos+1, Length(Expr));
      end else if (ParenPos > 0) and (ParenPos < CommaPos) then begin   //'(' present  +/- ',', but PARENTHESIS FIRST
        StrA := MidStr(Expr, 1, ParenPos-1);
        Expr := MidStr(Expr, ParenPos, Length(Expr));
        StrB := GetPairedParentheses(Expr, ErrStr);
        ParamSL.Add(StrA+StrB);
      end else begin
      //end else if ParenPos = 0 then begin  //No parenthesis
        if CommaPos = 0 then begin
          ParamSL.Add(Expr);
          Expr := '';
        end else begin
          StrA := MidStr(Expr,1, CommaPos-1);
          Expr := MidStr(Expr, CommaPos+1, Length(Expr));
          ParamSL.Add(StrA);
        end;
      end;
      Expr := Trim(Expr);
      if (Length(Expr)> 1) and (Expr[1] = ',') then begin
        Expr := Trim(MidStr(Expr, 2, Length(Expr)))
      end;
    until Expr = '';
  end;


  procedure ExpressionToSL(var Expr : string; ExprSL : TStringList; var ErrStr : string; StartIndex : integer = 0);
  //Returns StringList with format:
  //   term  -- e.g. 5, or (12 * 25 + 17)  (Any such compound term with start with '('
  //   operator
  //   term
  //   operator
  //   term ...
  var Term, Operator : string;
      SavedExpr : string;
  begin
    SavedExpr := Expr;
    while Expr <> '' do begin
      GetNextTermAndOperator(Expr, Term, Operator, ErrStr);
      if ErrStr <> '' then exit;
      ExprSL.Add(Term);
      if (Expr = '') and (Operator <> '') then begin
        //ErrStr := 'Invalid trailing operator in ''' + SavedExpr + '''';
        //exit;
        Expr := '0';
      end;
      if Operator <> '' then ExprSL.Add(Operator);
      Expr := Trim(Expr);
    end;
  end;

  function FunctionName(Expr : string) : string;
  var p : integer;
  begin
    Result := '';
    p := Pos('(', Expr);
    if p = 0 then exit;
    Result := MidStr(Expr,1,p-1);
  end;

  function HasNestedFunction(Expr : string) : boolean;
  var p : integer;
  begin
    Result := false;
    p := Pos('(', Expr);
    if p = 0 then exit;
    if PosEx('(', Expr, p+1) = 0  then exit;
    Result := true;
  end;

  function HasMath(Expr : string) : boolean;
  var
    ExprSL : TStringList;
    ErrStr : string;
  begin
    ExprSL := TStringList.Create;
    ExpressionToSL(Expr, ExprSL, ErrStr);
    Result := (ExprSL.Count >= 2);
    ExprSL.Free;
  end;


  function EvalExpression (var Expr : string; var ErrStr : string; OutSL : TStrings; IndentAmount : integer) : string;
  var SubExprSL, ExprSL, ParamSL : TStringList;
      tempS : string;
      FNName : string;
      SubExpr, SubExprSaved : string;
      SubSubExpr : string;
      //OperatorOrder : integer;
      i, j, p : integer;
      OneParam : string;
      //OneExpr  : string;
      //Operator : char;
      Val  : string;
      //Term1,Term2 : string;
      FirstLine : boolean;
      tempIndentVal : integer;
      CurLine, IndentS : string;

  begin
    ErrStr := '';
    Result := '';
    CurLine := '';
    Expr := AnsiReplaceStr(Expr,#10,'');
    Expr := AnsiReplaceStr(Expr,#13,'');
    ExprSL := TStringList.Create;
    ParamSL := TStringList.Create;
    SubExprSL := TStringList.Create;
    try
      ExpressionToSL(Expr, ExprSL, ErrStr);
      if ErrStr <> '' then exit;
      i := 0;
      while (i < ExprSL.Count) do begin
        SubExpr := ExprSL.Strings[i];
        SubExprSaved := SubExpr;
        if (i mod 2) = 1 then begin  //every other line, should be Operator lines.
          CurLine := CurLine + '  ' + SubExpr;
          OutSL.Add(CurLine);
          CurLine := '';
        end else begin
          if ErrStr <> '' then exit;
          IndentS := IndentStrNum(IndentAmount);
          if SubExpr='' then begin
            ErrStr := 'Missing expression';
            exit;
          end;
          if SubExpr[1] = '(' then begin
            SubExpr := MidStr(SubExpr,2,Length(SubExpr)-2); //trim leading and trailing parentheses -- syntax already inforced.
            OutSL.Add(IndentS +'(');
            Val := EvalExpression(SubExpr, ErrStr, OutSL, IndentAmount+2);  //Val not used here
            OutSL.Add(IndentS +')');
          end else if IsFn(SubExpr) then begin
            p := Pos('(',SubExpr);
            FNName := UpperCase(MidStr(SubExpr,1,p-1));
            if IsValidFn(FNName) then begin
              SubExpr := MidStr(SubExpr,p,Length(SubExpr));
              //SubExprSaved := SubExpr;
              SubSubExpr := GetPairedParentheses(SubExpr, ErrStr);
              SubExpr := Trim(SubExpr);
              SubSubExpr := MidStr(SubSubExpr,2, Length(SubSubExpr)-2);
              if FNNAME <> 'TEXT' then begin

                tempS := SubSubExpr;
                ExpressionToSL(SubSubExpr, SubExprSL, ErrStr);  if ErrStr <> '' then exit;
                SubSubExpr := tempS;
                ExprToParamSL(SubSubExpr, ParamSL, ErrStr);     if ErrStr <> '' then exit;
                SubSubExpr := tempS;
              end else begin
                SubExprSL.Clear;
                ParamSL.Clear;
              end;
              if (ParamSL.Count > 1) then begin
                CurLine := IndentS + FNName + '(';
                //OutSL.Add(IndentS + FNName + '(');
                FirstLine := true;
                j := 0;
                repeat
                  OneParam := ParamSL.Strings[j];
                  if HasNestedFunction(OneParam) or HasMath(OneParam) then begin
                    Val := EvalExpression(OneParam, ErrStr, OutSL, IndentAmount+Length(FNName)+1);  //Val not used here
                    if CurLine = '' then CurLine := IndentS;
                    CurLine := CurLine + ')';
                  end else begin
                    if (j <> (ParamSL.Count - 1)) then OneParam := OneParam + ',';
                    if CurLine = '' then CurLine := IndentS;
                    CurLine := CurLine + OneParam;
                  end;
                  if not FirstLine then CurLine := IndentStrNum(Length(FNName)+1) + CurLine;
                  OutSL.Add(CurLine);
                  CurLine := '';
                  FirstLine := false;
                  Inc (j);
                until (j > ParamSL.Count-1);
                CurLine := IndentS + ')';

              end else if (SubExprSL.Count > 1) then begin
                OutSL.Add(IndentS + FNName+'(');
                tempIndentVal := IndentAmount+Length(FNName)+1;
                Val := EvalExpression(SubSubExpr, ErrStr, OutSL, tempIndentVal);  //Val not used here
                if CurLine = '' then CurLine := IndentS;
                CurLine := CurLine + ')';

              end else begin
                OutSL.Add(IndentS + SubExprSaved);
              end;
            end else begin
              ErrStr := FNName + ' is not a valid function name.';
              //ErrStr := 'Missing expression or operator';
              exit;
            end;
          end else begin
            CurLine := IndentS + SubExpr;
          end;
        end;
        inc(i);
      end;
      if CurLine <> '' then begin
        OutSL.Add(CurLine);
        CurLine := '';
      end;
    finally
      ExprSL.Free;
      ParamSL.Free;
      SubExprSL.Free;
    end;
  end;



  procedure TfrmFormulaHelper.ExpandAndCheckFunction(Expr : String; OutSL : TStrings; var ErrStr: string);
  //Input: Expr: is the Lines.Text of the user's input -- e.g. from the RichEdit control
  //       OutSL: This is the TStrings that the output will be put into.
  //Result: Error message (if any), or '' if OK.
  var P : integer;
      OutVarName : string;
  begin
    ErrStr := '';
    OutSL.Clear;
    //Handle initial {FN: xxxx }
    Expr := Trim(Expr);
    P := Pos(FN_OPEN_TAG,Expr);
    if P<>1 then begin
      ErrStr := '"' + FN_OPEN_TAG + '" not found at beginning of forumla';
      exit;
    end;
    if ErrStr <> '' then exit;
    Expr := GetPairedParentheses(Expr, ErrStr, '{');
    OutVarName := GetOutputStoreVarName(Expr);
    Expr := Trim(MidStr(Expr, Length(FN_OPEN_TAG) + 1, Length(Expr) - Length(FN_OPEN_TAG) - 1));
    if OutVarName <> '' then begin
      Expr := MidStr(Expr, Length(OutVarName)+2, Length(Expr));
      OutVarName := OutVarName + ':'
    end;
    //VEFA-261  OutSL.Add(FN_OPEN_TAG + OutVarName);
    //VEFA-261  OutSL.Add(OutVarName);
    EvalExpression (Expr, ErrStr, OutSL, 2);
    if ErrStr <> '' then exit;
    //VEFA-261 OutSL.Add('}');
    //HighlightTags(reExpanded,FLD_OPEN_TAG,FLD_CLOSE_TAG,clPaleYellow);

  end;

constructor TfrmFormulaHelper.Create(AOwner: TComponent; ARichEdit : TRichEdit);
begin
  inherited Create(AOwner);
  RE := ARichEdit;
  FieldsList := TStringList.Create;
  PickOperatorForm := TfrmPickOperator.Create(Self);
  FnWizardForm := TfrmFnWizard.Create(Self, RE);
  PickTemplateFieldForm := TfrmPickTemplateField.Create(Self, RE);
  PickTemplateVarForm := TfrmPickTemplateVar.Create(Self, RE);
  FormDirty := False;
  SetActiveRichEdit(reUserInput);
end;

procedure TfrmFormulaHelper.FormDestroy(Sender: TObject);
begin
  FieldsList.Free;
  FreeAndNil(PickOperatorForm);
  FreeAndNil(FnWizardForm);
  FreeAndNil(PickTemplateFieldForm);
  FreeAndNil(PickTemplateVarForm);
end;

function TfrmFormulaHelper.TrimFormula(Formula : string) : string;
var p : integer;
    ErrStr, Text : string;
begin
  Result := '';
  p := Pos(FN_OPEN_TAG, Formula);
  if p = 0 then exit;
  Text := MidStr(Formula, p, Length(Formula));
  Result := GetPairedParentheses(Text, ErrStr, '{');
  if ErrStr <> '' then begin
    Result := '';
    exit;
  end;
  //Result := '{' + Result + '}';
end;


procedure TfrmFormulaHelper.FormShow(Sender: TObject);
begin
  UpdatingRE := false;
  SetActiveRichEdit(reUserInput);
  //InitialFormula := '';
  if InitialFormula <> '' then begin
    InitialFormula := TrimFormula(InitialFormula);
  end;
  //if InitialFormula = '' then begin
    //InitialFormula := '{FN: 5 * 2 + TEXT(1 -- Example) }';
  //end;
  reUserInput.Lines.Text := Trim(RemoveStoreVar(HandleTags(InitialFormula,True)));
  HighlightARichEdit(reUserInput, True);
  HighlightARichEdit(reExpanded, false);
  FormDirty := False;
  //HighlightTags(reExpanded,FLD_OPEN_TAG,FLD_CLOSE_TAG,clPaleYellow);
end;

function TfrmFormulaHelper.RemoveStoreVar(OrigText: string):string;
var OutputVarName : string;
    FlagsStr : string;

begin
  Result := OrigText;
  OutputVarName := GetOutputStoreVarName(HandleTags(OrigText,False));
  FlagsStr := Piece(OutputVarName,'^',2);
  OutputVarName := Piece(OutputVarName,'^',1);
  if not ValidStoreName(OutputVarName) then begin
    edtStoreVarName.Color := clPaleRed;
  end else begin
    edtStoreVarName.Color := clWindow;
  end;
  edtStoreVarName.Text := OutputVarName;
  cbSilentFunction.Checked := (Pos('H',FlagsStr)>0);
  if OutputVarName <> '' then Result := RightStr(Result,Length(Result)-(Length(OutputVarName)+1));
  if FlagsStr <> '' then Result := RightStr(Result,Length(Result)-(Length(FlagsStr)+1));
end; 

function TfrmFormulaHelper.HandleTags(OrigFormula : string; RemoveTag: boolean): string;
begin
  if RemoveTag then begin
    Result := MidStr(Trim(OrigFormula),Length(FN_OPEN_TAG)+1,Length(OrigFormula));
    Result := LeftStr(Result,Length(Result)-1);
  end else begin
    Result := FN_OPEN_TAG + OrigFormula + FN_CLOSE_TAG;
  end;
end;

end.


