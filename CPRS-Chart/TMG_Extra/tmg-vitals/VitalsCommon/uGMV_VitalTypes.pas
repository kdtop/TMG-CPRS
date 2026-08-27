unit uGMV_VitalTypes;

interface

uses
  Classes;

type
  //kt make changes here.  Add wound vitals type
  TVitalType = (
    vtUnknown,
    vtTemp,
    vtPulse,
    vtResp,
    vtBP,
    vtHeight,
    vtWeight,
    vtPain,
    vtPO2,
    vtCVP,
    vtCircum,
    {$IFDEF TMG_WOUNDS}
    vtWoundMeas1,    //kst  wound Length/Width/Depth
    //vtWoundAreaVol1, //kst  wound Area/Volume
    //vtWoundHFPct1,    //kst  wound Healing Factor %
    vtWoundMeas2,
    //vtWoundAreaVol2,
    //vtWoundHFPct2,
    vtWoundMeas3,
    //vtWoundAreaVol3,
    //vtWoundHFPct3,
    vtWoundMeas4,
    //vtWoundAreaVol4,
    //vtWoundHFPct4,
    vtWoundMeas5,
    //vtWoundAreaVol5,
    //vtWoundHFPct5,
    vtWoundMeas6,
    //vtWoundAreaVol6,
    //vtWoundHFPct6,
    vtWoundMeas7,
    //vtWoundAreaVol7,
    //vtWoundHFPct7,
    vtWoundMeas8,
    //vtWoundAreaVol8,
    //vtWoundHFPct8,
    vtWoundMeas9,
    //vtWoundAreaVol9,
    //vtWoundHFPct9,
    vtWoundMeas10,
    //vtWoundAreaVol10,
    //vtWoundHFPct10,
    vtWoundMeas11,
    //vtWoundAreaVol11,
    //vtWoundHFPct11,
    vtWoundMeas12,
    //vtWoundAreaVol12,
    //vtWoundHFPct12,
    vtWoundMeas13,
    //vtWoundAreaVol13,
    //vtWoundHFPct13,
    vtWoundMeas14,
    //vtWoundAreaVol14,
    //vtWoundHFPct14,
    vtWoundMeas15,
    //vtWoundAreaVol15,
    //vtWoundHFPct15,
    {$ENDIF}
    vtLAST_ENTRY
  );

  TGMV_ImageIndex = (
    iiFolderOpen,
    iiFolderClosed,
    iiTemplate,
    iiDefaultTemplate,
    iiSave,
    iiDelete,
    iiVital,
    iiAbnormal);

function VitalTypeByString(aType:String): TVitalType;
function VitalTypeByABBR(aType:String): TVitalType;
function ErrorAbbByString(aCode:String):String;
function VitalAbbByString(aType:String): String;

var
  GMVVitalTypeIEN: array[TVItalType] of string = (   //kst added wound stuff
    '-1',      //vtUnknown,
    '2',       //vtTemp,
    '5',       //vtPulse,
    '3',       //vtResp,
    '1',       //vtBP,
    '8',       //vtHeight,
    '9',       //vtWeight,
    '22',      //vtPain,
    '21',      //vtPO2,
    '19',      //vtCVP,
    '20',      //vtCircum,
    {$IFDEF TMG_WOUNDS}
    '23',      //vtWoundMeas1,    //kst  wound Length/Width/Depth
    '24',      //vtWoundMeas2,
    '25',      //vtWoundMeas3,
    '26',      //vtWoundMeas4,
    '27',      //vtWoundMeas5,
    '28',      //vtWoundMeas6,
    '29',      //vtWoundMeas7,
    '30',      //vtWoundMeas8,
    '31',      //vtWoundMeas9,
    '32',      //vtWoundMeas10,
    '33',      //vtWoundMeas11,
    '34',      //vtWoundMeas12,
    '35',      //vtWoundMeas13,
    '36',      //vtWoundMeas14,
    '37',      //vtWoundMeas15,
    {$ENDIF}
    '-1'       //vtLAST_ENTRY
   );
  GMVVitalHiRange: array[TVitalType] of Double;
  GMVVitalLoRange: array[TVitalType] of Double;
  GMVVitalTypeAbbv: array[TVItalType] of string = (  //kst added wound stuff
    'xx',      //vtUnknown,
    'T',       //vtTemp,
    'P',       //vtPulse,
    'R',       //vtResp,
    'BP',      //vtBP,
    'HT',      //vtHeight,
    'WT',      //vtWeight,
    'PN',      //vtPain,
    'PO2',     //vtPO2,
    'CVP',     //vtCVP,
    'CG',      //vtCircum,
    {$IFDEF TMG_WOUNDS}
    'WM1',     //vtWoundMeas1,    //kst  wound Length/Width/Depth
    'WM2',     //vtWoundMeas2,
    'WM3',     //vtWoundMeas3,
    'WM4',     //vtWoundMeas4,
    'WM5',     //vtWoundMeas5,
    'WM6',     //vtWoundMeas6,
    'WM7',     //vtWoundMeas7,
    'WM8',     //vtWoundMeas8,
    'WM9',     //vtWoundMeas9,
    'WM10',    //vtWoundMeas10,
    'WM11',    //vtWoundMeas11,
    'WM12',    //vtWoundMeas12,
    'WM13',    //vtWoundMeas13,
    'WM14',    //vtWoundMeas14,
    'WM15',    //vtWoundMeas15,
    {$ENDIF}
    'xx'       //vtLAST_ENTRY
   );

const
  MAX_COMBINED_VALUES = 8;   //kt e.g. 120/4 has 2 values;  32x54x12 has 3 values
type
  TVitalsData = class;        //kt forward declaration
  TVitalRow = class;          //kt forward declaration
  TVitalRowList = class;      //kt forward declaration
  TVitalEntryList = class;    //kt forward declaration

  //===========================================
  //===========================================

  TLabelVitalRowList = class (TStringList) //kt added class
  private
    function GetList(Index : integer) : TVitalRowList;
    procedure PutList (Index: integer; Value : TVitalRowList);
  public
    property Objects[Index : integer] : TVitalRowList read GetList write PutList;
  end;

  //===========================================
  //===========================================

  TGraphCombos = class  //kt added class
  //Class will hold selectable graph combos.
  private
    FComboList : TLabelVitalRowList;  //Does own objects (TLists), but items held in TLists are NOT owned.
    FTempList : TList;  //does NOT own objects
    FVisibleLabelsList : TLabelVitalRowList; // doesn't own objects
  public
    procedure AddCombo(GraphLabel,DataPieces : string; VitalsData : TVitalsData);
    procedure Clear;
    constructor Create;
    destructor Destroy; override;
    function DataList(GraphLabel : String) : TVitalRowList;  //returns TList containing TVitalRow objects.  List owned by this object. Users should NOT free it

    function VisibleComboLabels(VitalsData : TVitalsData) : TLabelVitalRowList; //list owned by object.  Don't delete/free etc.
    //Note: resulting TStringList.Objects[] is pointer to TVitalRow object for corresponding label.
  end;

  //===========================================
  //===========================================

  TVitalEntryStamp = record
    Date,Time   : String;
//    User,Location: string;
  end;

  //===========================================
  //===========================================

  TVitalEntry = class  //kt added class
  private
    FOwner : TVitalRow;
    FValueStr : string;                    //e.g.  '120/75'
    FNumericValue : Array[0..MAX_COMBINED_VALUES] of Real;   //e.g.  [120][75]...
    procedure SetValueStr(Value : string);
    function GetEntryStampStr: String;  //returns yymmddhhmmss
    function GetDateTimeStr: string;    //returns Date Time
  public
    HasNumericValue : boolean;
    EntryStamp: TVitalEntryStamp;
    function AssembleEntryStampStr(EntryStamp : TVitalEntryStamp): String;  //returns yymmddhhmmss
    constructor Create(Owner : TVitalRow);
    property EntryStampStr:string read GetEntryStampStr;
    function GetValue(Index:integer=0) : Real;
    procedure SetValue(Value: Real; Index: integer=0);
    property ValueStr : string read FValueStr write SetValueStr;
    property DateTimeStr : string read GetDateTimeStr;
  end;

  //===========================================
  //===========================================

  TVitalRow = class   //kt added class
  //This class will hold the equivalent of one row on the display grid
  //One row will contain multiple entries, off of the same type.  E.g. multiple
  //    entries for BP (all will be BP), or multiple temps (and all would be temps)
  //Including format info (type, display seq etc.) and all values (multiple DateTime entries)
  private
    FVitalsEntries : TVitalEntryList;    //WILL own objects in list.
    FSortedVitalsEntries : TStringList;  //will NOT own objects in list.
    FAbbrevLabel : TStringList;          //Abbreviated labe;
    MaxDispSeqValue : Integer;
    function GetNumVitalEntries : integer;
    function GetAbbrevLabel(SubDataIndex: integer=0) : string;
    procedure SetAbbrevLabel(SubDataIndex:integer=0; Value: string='');
  public
    NumSubDataValues : integer;//e.g. 2 if value is '120/78', 3 if value is '123x12x56'.  Default value is 0, will be interpreted same as 1
    DataDelim : string[MAX_COMBINED_VALUES];     //e.g. '/' if value is '120/78', 'x' if value is '123x12x56'
    DesiredSubPieces : string; //e.g. if have ..^104*-^... and only 104* is wanted, set to 1, or '1,3'
    DataPiece : Integer;       //piece in data string obtained from server by RPC
    RowLabel : String;         //Label to display in grid for vital
    DisplaySeq : integer;      //e.g. 0 for first to display in grid, 1 for second... Must be integer, but could be 10,20,30 etc.
    HideIfEmpty: boolean;      //If no data for vital type, then don't show?
    HeaderColor: boolean;      //If true, then vital displayed with header color in grid
    Graphable : boolean;       //If false, value not numeric (e.g. Hospital location)
    MaxEnterable : String;     //A value (or value/value etc if delim used) for max range of enterable values
    MinEnterable : String;     //A value (or value/value etc if delim used) for min range of enterable values
    MaxNormal : String;        //A value (or value/value etc if delim used) for max range of normal
    MinNormal : String;        //A value (or value/value etc if delim used) for min range of normal
    AxisMinorTickCount : integer; //used in graphing, on the axis.
    constructor Create(FormatString: string; var MaxDispSeqValue : word);
    destructor Destroy;  override;
    procedure Clear;
    procedure AddValue(EntryStamp: TVitalEntryStamp; Value : string);  //Value may be in form of 'Value-Modifier'
    function VitalItem(EntryStamp: TVitalEntryStamp): TVitalEntry; overload;
    function VitalItem(EntryStampStr: String): TVitalEntry;        overload;
    function VitalItem(Index : integer): TVitalEntry;             overload;
    function VitalValue(EntryStamp: TVitalEntryStamp): Real;
    function VitalValueStr(EntryStamp: TVitalEntryStamp): String; overload;
    function VitalValueStr(EntryStampStr: string): String;  overload;
    function SortedVitalEntry(Index: integer): TVitalEntry;
    function RowIsEmpty : boolean;
    function HasData : boolean;
    function ShouldHide : boolean;
    function EntryStampStrList : TStringList;  //list is owned by this object. Users should NOT delete it
    property NumVitalEntries : integer read GetNumVitalEntries;
    property AbbrevLabel[Index: integer] : String read GetAbbrevLabel write SetAbbrevLabel;      //Abbreviated labe;
  end;

  //===========================================
  //===========================================

  TVitalRowList = class (TList)   //kt added class
  private
    function GetVitalRow(Index : integer) : TVitalRow;
    procedure SetVitalRow(Index : integer; Value : TVitalRow);
  public
    property Items[Index : integer] : TVitalRow read GetVitalRow write SetVitalRow;
  end;

  //===========================================
  //===========================================

  TVitalEntryList = class (TList)   //kt added class
  private
    function GetVitalEntry(Index : integer) : TVitalEntry;
    procedure SetVitalEntry(Index : integer; Value : TVitalEntry);
  public
    property Items[Index : integer] : TVitalEntry read GetVitalEntry write SetVitalEntry;
  end;

  //===========================================
  //===========================================

  TVitalsData = class(TObject)  //kt added class
  //This class will own multiple rows of vitals
  //Each row is a TVitalRow, and holds ONE TYPE of vitals (i.e. all BP's)
  {
   FVitalsRows -- holds list of all rows as below
   +------+------+------+------+------+------+
   |      |      |      |      |      |      |  <--- one TVitalRow
   +------+------+------+------+------+------+
   |      |      |      |      |      |      |
   +------+------+------+------+------+------+
   |      |      |      |      |      |      |
   +------+------+------+------+------+------+
   ...
   +------+------+------+------+------+------+
   |      |      |      |      |      |      |
   +------+------+------+------+------+------+
         (Multiple TVitalsEntry objects in each row.)
  }
  private
    FVitalsRows : TVitalRowList;   //this will own pointers and delete on destruction
    FSortedVitalsRows : TStringList;  //Will NOT own pointers
    //FColumnsList : TStringList;    //Holds EntryStampStr for colums.  Will not store any pointers
    FLabelsList : TStringList;     //will not store any pointers
    procedure Add(OneRow: TVitalRow); //Row is assumed to not hold any vitals entries.
    //procedure GatherColumnsInfo;
    function GetNumVisibleRows : integer;
    procedure DeleteRows; //remove all rows from this object
  public
    TimeLastReload : TDateTime;
    DateFrom,DateTo : String;  //stores the date range used to request data from server.
    constructor Create;
    destructor Destroy;  override;
    procedure Clear;     //clear data in rows, but keep rows themselves (i.e. row label etc) intact;
    procedure AddRowFromStr(FormatString : string; var MaxDispSeqValue : word);
    function Item(Index: integer): TVitalRow; //order will be order added to list, not order of display.
    function VisibleItem(Index: integer; IncludeEmpty : boolean=false): TVitalRow;
    function SortedItem(Index: integer; IncludeEmpty : boolean=false): TVitalRow; //return row matching display sequence number (use 0..count-1 to display all)
    function RowForPiece(PieceS : string) : TVitalRow; //return row matching data piece from RPC data
   //NOTICE: this PiecesList will create list, but won't delete it.  Users MUST FREE IT
    function PiecesList(DataPieces: string) : TVitalRowList; //returns list of rows matching data pieces.  Doesn't own pointers
    procedure AddVitalSet(InputString : string);
    function NumRows : Integer;   //returns number of visible and invisible rows.
    function NumColumns : integer;
    property NumVisibleRows : integer read GetNumVisibleRows; //returns number of visible rows.
    function RowLabelsList(IncludeEmpty : boolean=false) : TStringList; //list is owned by this object. Users should NOT delete it
    function GetVisibleVital(Col,Row:Word; Var OutVital : TVitalEntry) : Boolean;  //object returned should NOT be deleated by user
    function GetVital(Col,Row:Word; Var OutVital : TVitalEntry) : Boolean;  //object returned should NOT be deleated by user
  end;

  //===========================================
  //===========================================

implementation

uses
  uGMV_Common  //kt
  , SysUtils  //kt
  , StrUtils  //kt
  , Dialogs   //kt
  ;

function VitalTypeByABBR(aType:String): TVitalType;
var t : TVitalType;
begin  //kt make changes here.  Add support for wounds
  result := vtUnknown;  //default
  for t := vtUnknown to vtLAST_ENTRY do begin
    if aType=GMVVitalTypeAbbv[t] then begin
      result := t;
      break;
    end;
  end;
  (*
  if      aType = GMVVitalTypeAbbv[vtTemp] then result := vtTemp
  else if aType = GMVVitalTypeAbbv[vtPulse] then result := vtPulse
  else if aType = GMVVitalTypeAbbv[vtResp] then result := vtResp
  else if aType = GMVVitalTypeAbbv[vtBP] then result := vtBP
  else if aType = GMVVitalTypeAbbv[vtHeight] then result := vtHeight
  else if aType = GMVVitalTypeAbbv[vtWeight] then result := vtWeight
  else if aType = GMVVitalTypeAbbv[vtPain] then result := vtPain
  else if aType = GMVVitalTypeAbbv[vtPO2] then result := vtPO2
  else if aType = GMVVitalTypeAbbv[vtCVP] then result := vtCVP
  else if aType = GMVVitalTypeAbbv[vtCircum] then result := vtCircum
  else result := vtUnknown;
  *)
end;

function VitalTypeByString(aType:String): TVitalType;
var t : TVitalType;
begin  //kt make changes here.  Add support for wounds
  result := vtUnknown;  //default
  for t := vtUnknown to vtLAST_ENTRY do begin
    if aType=GMVVitalTypeIEN[t] then begin
      result := t;
      break;
    end;
  end;
  (*
  if      aType = GMVVitalTypeIEN[vtTemp] then result := vtTemp
  else if aType = GMVVitalTypeIEN[vtPulse] then result := vtPulse
  else if aType = GMVVitalTypeIEN[vtResp] then result := vtResp
  else if aType = GMVVitalTypeIEN[vtBP] then result := vtBP
  else if aType = GMVVitalTypeIEN[vtHeight] then result := vtHeight
  else if aType = GMVVitalTypeIEN[vtWeight] then result := vtWeight
  else if aType = GMVVitalTypeIEN[vtPain] then result := vtPain
  else if aType = GMVVitalTypeIEN[vtPO2] then result := vtPO2
  else if aType = GMVVitalTypeIEN[vtCVP] then result := vtCVP
  else if aType = GMVVitalTypeIEN[vtCircum] then result := vtCircum
  else result := vtUnknown;
  *)
end;

function VitalAbbByString(aType:String): String;
var t : TVitalType;
begin  //kt make changes here.  Add support for wounds
  result := 'Unk';   //default
  for t := vtUnknown to vtLAST_ENTRY do begin
    if aType=GMVVitalTypeIEN[t] then begin
      result := GMVVitalTypeAbbv[t];
      break;
    end;
  end;
  (*
  if      aType = GMVVitalTypeIEN[vtTemp] then result := 'T'
  else if aType = GMVVitalTypeIEN[vtPulse] then result := 'P'
  else if aType = GMVVitalTypeIEN[vtResp] then result := 'R'
  else if aType = GMVVitalTypeIEN[vtBP] then result := 'BP'
  else if aType = GMVVitalTypeIEN[vtHeight] then result := 'HT'
  else if aType = GMVVitalTypeIEN[vtWeight] then result := 'WT'
  else if aType = GMVVitalTypeIEN[vtPain] then result := 'PN'
  else if aType = GMVVitalTypeIEN[vtPO2] then result := 'PO2'
  else if aType = GMVVitalTypeIEN[vtCVP] then result := 'CVP'
  else if aType = GMVVitalTypeIEN[vtCircum] then result := 'CG'
  else result := 'Unk';
  *)
end;

function ErrorAbbByString(aCode:String):String;
begin
  if aCode = '1' then result := 'Date/Time'
  else if aCode = '2' then result := 'Reading'
  else if aCode = '3' then result := 'Patient'
  else if aCode = '4' then result := 'Record'
  else
    result := '';
end;

////////////////////////////////////////////////////////////////////////////////
//TVitalEntryList class code
////////////////////////////////////////////////////////////////////////////////
function TVitalEntryList.GetVitalEntry(Index : integer) : TVitalEntry;
begin
  Result := TVitalEntry(Get(Index));
end;

procedure TVitalEntryList.SetVitalEntry (Index: integer; Value : TVitalEntry);
begin
  Put(Index, Value);
end;

////////////////////////////////////////////////////////////////////////////////
//TLabelVitalRowList class code
////////////////////////////////////////////////////////////////////////////////
function TLabelVitalRowList.GetList(Index : integer) : TVitalRowList;
begin
  Result := TVitalRowList(GetObject(Index));
end;

procedure TLabelVitalRowList.PutList (Index: integer; Value : TVitalRowList);
begin
  PutObject(Index, Value);
end;

////////////////////////////////////////////////////////////////////////////////
//TGraphCombos class code
////////////////////////////////////////////////////////////////////////////////
constructor TGraphCombos.Create;
begin
  FComboList := TLabelVitalRowList.Create;
  FTempList := TList.Create;
  FVisibleLabelsList := TLabelVitalRowList.Create;
end;

destructor TGraphCombos.Destroy;
begin
  Clear;
  FComboList.Free;  //does own objects
  FTempList.Free;  //does NOT own objects
  FVisibleLabelsList.Free;  //does NOT own objects
  inherited Destroy;
end;

procedure TGraphCombos.Clear;
var i : integer;
    List : TVitalRowList;
begin
  for i := 0 to FComboList.Count-1 do begin
    List := FComboList.Objects[i];
    if List <> nil then List.Free;  //object held in list are not owned by FComboList
  end;
  FComboList.Clear;
end;


function TGraphCombos.DataList(GraphLabel : String) : TVitalRowList;
//returns TList containing TVitalRow objects
var i : integer;
begin
  Result := nil;
  i := FComboList.IndexOf(GraphLabel);
  if i > -1 then Result := TVitalRowList(FComboList.Objects[i]);
end;

procedure TGraphCombos.AddCombo(GraphLabel,DataPieces : string; VitalsData : TVitalsData);
var List : TVitalRowList;
begin
  List := VitalsData.PiecesList(DataPieces);
  FComboList.AddObject(GraphLabel,List);  //FCombo owns TList object, but not items held in List
end;

function TGraphCombos.VisibleComboLabels(VitalsData : TVitalsData) : TLabelVitalRowList;
//List owned by object.  Don't delete/free etc. any of it.
//Returns list of string labels for graph combos, but excludes those that reference
// only rows that are empty.
//Pointers stored in Objects are pointers to TVitalRow objects.
var  i,j : integer;
     List : TVitalRowList;
     OneRow : TVitalRow;
     Visible : boolean;
begin
  if not Assigned(FVisibleLabelsList) then FVisibleLabelsList := TLabelVitalRowList.Create;
  FVisibleLabelsList.Clear;
  FVisibleLabelsList.Sorted := false;
  for i := 0 to FComboList.Count-1 do begin
    List := FComboList.Objects[i]; //List holds list of rows matching pieces for given graph combo
    if List = nil then continue;
    Visible := false; //default value
    for j := 0 to List.Count-1 do begin
      OneRow := List.Items[j];
      if OneRow = nil then continue;
      if OneRow.ShouldHide = false then begin
        Visible := true;
        break;  //as long as one part of graph combo is visible, then use it.
      end;
    end;
    if Visible then begin
      FVisibleLabelsList.AddObject(FComboList.Strings[i],List);
    end;
  end;
  Result := FVisibleLabelsList;
end;



////////////////////////////////////////////////////////////////////////////////
//TVitalEntry class code
////////////////////////////////////////////////////////////////////////////////
constructor TVitalEntry.Create(Owner : TVitalRow);
begin
  FOwner := Owner;
end;

function TVitalEntry.AssembleEntryStampStr(EntryStamp : TVitalEntryStamp): String;  //returns yymmddhhmmss
var yy,mtmt,dd,hh,mm,ss : string;
begin
  yy := Piece(EntryStamp.Date,'-',3);
  mtmt := Piece(EntryStamp.Date,'-',1);
  dd := Piece(EntryStamp.Date,'-',2);
  hh := Piece(EntryStamp.Time,':',1);
  mm := Piece(EntryStamp.Time,':',2);
  ss := Piece(EntryStamp.Time,':',3);
  Result := yy+mtmt+dd+hh+mm+ss;
end;

function TVitalEntry.GetEntryStampStr: String;  //returns yymmddhhmmss
begin
  Result := AssembleEntryStampStr(EntryStamp);
end;

function TVitalEntry.GetDateTimeStr: string;    //returns Date Time
begin
  Result := EntryStamp.Date + ' ' + EntryStamp.Time;
end;

function TVitalEntry.GetValue(Index:integer) : Real;
begin
  if (Index >= 0) and (Index <= MAX_COMBINED_VALUES) then begin
    Result := FNumericValue[Index];
  end else Result := 0;
end;

procedure TVitalEntry.SetValue(Value : Real; Index : integer);
var i : integer;
begin
  if (Index >= 0) and (Index <= MAX_COMBINED_VALUES) then begin
    FNumericValue[Index] := Value;
    HasNumericValue := true;
    FValueStr := '';
    for i := 1 to FOwner.NumSubDataValues do begin
      if FValueStr<>'' then FValueStr := FValueStr + FOwner.DataDelim;
      FValueStr := FValueStr + FloatToStr(FNumericValue[i]);
    end;
  end;
end;

procedure TVitalEntry.SetValueStr(Value : string);
var s,subS,Delim : string;
    i : integer;

begin
  HasNumericValue := true;
  s := Piece(Value,'-',1);
  FValueStr := s;  //Trim(AnsiReplaceStr(Value,'-',' '));
  if Pos('*',s)>0 then s := Piece(s,'*',1);  //check this.  Is data sent 104* or *104?
  if s='' then s :='0';
  for i := 0 to MAX_COMBINED_VALUES do FNumericValue[i] := 0;
  s := UpperCase(s);
  Delim := UpperCase(FOwner.DataDelim);
  for i := 1 to FOwner.NumSubDataValues do begin
    if i > MAX_COMBINED_VALUES then continue;  //prob won't happen
    if Delim<>'' then subS := Piece(s,Delim,i)
    else subS := s;
    if (subS<>'') and (subS[1] in ['0'..'9','-']) then begin
      try
        FNumericValue[i-1] := StrToFloat(subS);
      except
        on EConvertError do begin
          FNumericValue[i-1] := -1;
          HasNumericValue := false;
        end;
      end;
    end else begin
      FNumericValue[i-1] := -1;
      HasNumericValue := false;
    end;
  end;
end;


////////////////////////////////////////////////////////////////////////////////
//TVitalRow class code
////////////////////////////////////////////////////////////////////////////////
constructor TVitalRow.Create(FormatString: string; var MaxDispSeqValue : word);
//Following is the input values, by datapiece (delimiter is ^)
//1: DataPiece
//2: DisplaySeq
//3: NumDataValues       e.g. Weight has 1 (default), BP has 2 (i.e. 1 for systolic, 1 for diastolic)
//4: DataDelim           e.g. '/' for BP (e.g. 120/80)
//5: DesiredSubPieces
//6: RowLabel
//7: AbbrevLabel          e.g. 'B/P;Sys.;Dias'.  Note: Delim is ';'.1st piece is combined Abbriev, then Abbriev for eac sub pice
//8: HideIfEmpty
//9: HeaderColor
//10: Graphable
//11: MinEnterableRange
//12: MaxEnterableRange
//13: MinNormalRange
//14: MaxNormalRange
//15: AxisMinorTickCount
//
//If DisplaySeq not provided, then row is added at after last entry
//If DesiredSubPiece is not provided, then default is to show all subpieces
//if HideIfEmpty not provided, default is 0 (NO/FALSE)
//if HeaderColor not provided, default is 0 (NO/FALSE)
//If Graphable not provided, deafult is 1 (YES/TRUE)
var s,tempS : string;
    i : integer;
begin
//  FOwner := Owner;
  FSortedVitalsEntries := TStringList.Create;  //will NOT own objects in list.
  FSortedVitalsEntries.Sorted := true;
  FVitalsEntries := TVitalEntryList.Create;
  FAbbrevLabel := TStringList.Create;
  FAbbrevLabel.Sorted := false;
  //MaxDispSeqValue := 0;

  s := Piece(FormatString,'^',1);  //piece in data string obtained from server by RPC
  if s='' then begin
    s := '0';
    //display error .. COMPLETE....
  end;
  DataPiece := StrToInt(s);

  s := Piece(FormatString,'^',2);  //e.g. 0 for first to display in grid, 1 for second...
  if s='' then begin
    Inc(MaxDispSeqValue);
    s := IntToStr(MaxDispSeqValue);
  end;
  DisplaySeq := StrToInt(s);
  if DisplaySeq > MaxDispSeqValue then MaxDispSeqValue := DisplaySeq;

  s := Piece(FormatString,'^',3);  //e.g. 2 if value is '120/78', 3 if value is '123x12x56'.  Default value is 1
  if s='' then s := '1';
  NumSubDataValues := StrToInt(s);

  s := Piece(FormatString,'^',4);  //e.g. '/' if value is '120/78', 'x' if value is '123x12x56'
  if s='' then DataDelim := '' //was ' '
  else DataDelim := s;

  s := Piece(FormatString,'^',5);  //e.g. if have ..^104*-^... and only 104* is wanted, set to 1
  if s='' then s := '';   //'' ==> use ALL pieces
  DesiredSubPieces := s;

  s := Piece(FormatString,'^',6);  //Label to display in grid for vital
  if s='' then s:= '<unknown>';
  RowLabel := s;

  s := Piece(FormatString,'^',7);  //Abbreviated label
  if s='' then s:= '<?>';
  for i := 1 to NumSubDataValues do begin
    tempS := piece(s,';',i);
    AbbrevLabel[i-1] := tempS;
  end;

  s := Piece(FormatString,'^',8);  //If no data for vital type, then don't show?
  if s='' then s:='0';
  HideIfEmpty := (s='1');

  s := Piece(FormatString,'^',9);  //If true, then vital displayed with header color in grid
  if s='' then s:='0';
  HeaderColor := (s='1');

  s := Piece(FormatString,'^',10);  //If false, value not numeric (e.g. Hospital location)
  if s='' then s:='1';
  Graphable := (s='1');

  s := Piece(FormatString,'^',11);  //Min value of enterable range
  MinEnterable := s;

  s := Piece(FormatString,'^',12);  //Max value of Enterable range
  MaxEnterable := s;

  s := Piece(FormatString,'^',13);  //Min value of normal range
  MinNormal := s;

  s := Piece(FormatString,'^',14);  //Max value of normal range
  MaxNormal := s;

  s := Piece(FormatString,'^',15);  //e.g. 2 if value is '120/78', 3 if value is '123x12x56'.  Default value is 1
  if s='' then s := '4';   //default value is 4
  AxisMinorTickCount := StrToInt(s);

end;

destructor TVitalRow.Destroy;
begin
  Clear;
  FVitalsEntries.Free;
  FSortedVitalsEntries.Free;
  FAbbrevLabel.Free;
  Inherited Destroy;
end;

procedure TVitalRow.Clear;
var i : integer;
    Entry : TVitalEntry;
begin
  for i := 0 to FVitalsEntries.Count-1 do begin
    Entry := FVitalsEntries.Items[i];
    if Entry <> nil then Entry.Destroy;
  end;
  FVitalsEntries.Clear;
end;

function TVitalRow.GetNumVitalEntries : integer;
begin
  Result := FVitalsEntries.Count;
end;

function TVitalRow.GetAbbrevLabel(SubDataIndex:integer=0) : string;
begin
  if SubDataIndex<FAbbrevLabel.Count then begin
    Result := FAbbrevLabel.Strings[SubDataIndex];
  end else begin
    Result := '';
  end;
end;

procedure TVitalRow.SetAbbrevLabel(SubDataIndex:integer=0; Value: string='');
begin
  while SubDataIndex>=FAbbrevLabel.Count do begin
    FAbbrevLabel.Add('');
  end;
  FAbbrevLabel.Strings[SubDataIndex]:=Value;
end;

function TVitalRow.VitalValueStr(EntryStamp: TVitalEntryStamp): String;
var Entry : TVitalEntry;
begin
  Entry := VitalItem(EntryStamp);
  if Entry <> nil then Result := Entry.ValueStr
  else Result := '';
end;

function TVitalRow.VitalValueStr(EntryStampStr: string): String;
var Entry : TVitalEntry;
begin
  Entry := VitalItem(EntryStampStr);
  if Entry <> nil then Result := Entry.ValueStr
  else Result := '';
end;

function TVitalRow.VitalValue(EntryStamp: TVitalEntryStamp): Real;
var Entry : TVitalEntry;
begin
  Entry := VitalItem(EntryStamp);
  if Entry <> nil then Result := Entry.GetValue(0)
  else Result := 0;
end;

procedure TVitalRow.AddValue(EntryStamp: TVitalEntryStamp; Value : string);
var Entry : TVitalEntry;
begin
  Entry := TVitalEntry.Create(self);
  Entry.EntryStamp := EntryStamp;
  Entry.ValueStr := Value;
  FVitalsEntries.Add(Entry);
  FSortedVitalsEntries.AddObject(Entry.EntryStampStr,Entry);  //will sort items by datetime
end;

function TVitalRow.VitalItem(EntryStamp: TVitalEntryStamp): TVitalEntry;
var i : integer;
    Entry : TVitalEntry;
begin
  Result := nil;
  for i := 0 to FVitalsEntries.Count-1 do begin
    Entry := FVitalsEntries.Items[i];
    if (EntryStamp.Date = Entry.EntryStamp.Date) and
//  (EntryStamp.User = Entry.EntryStamp.User) and
    (EntryStamp.Time = Entry.EntryStamp.Time) then begin
      Result := Entry;
      Break;
    end;
  end;
end;

function TVitalRow.VitalItem(EntryStampStr: String): TVitalEntry;
//compates on just date and time, not on user and location
var i : integer;
    Entry : TVitalEntry;
begin
  Result := nil;
  for i := 0 to FVitalsEntries.Count-1 do begin
    Entry := FVitalsEntries.Items[i];
    if Entry.EntryStampStr = EntryStampStr then begin
      Result := Entry;
      Break;
    end;
  end;
end;

function TVitalRow.VitalItem(Index : integer): TVitalEntry;
begin
  Result := nil;
  if (Index >= 0) and (Index < FVitalsEntries.Count) then begin
    Result := FVitalsEntries.Items[Index];
  end;
end;

function TVitalRow.SortedVitalEntry(Index: integer): TVitalEntry;
begin
  if Index<FSortedVitalsEntries.Count then Result := TVitalEntry(FSortedVitalsEntries.Objects[Index])  //index now = DateTime order
  else Result := nil;
end;

function TVitalRow.RowIsEmpty : boolean;
begin
  Result := (FVitalsEntries.Count = 0);
end;

function TVitalRow.HasData : boolean;
var i : integer;
begin
  Result := false;
  for i := 0 to FVitalsEntries.Count-1 do begin
    if FVitalsEntries.Items[i].ValueStr = '' then continue;
    Result := true;
    break;
  end;
end;

function TVitalRow.ShouldHide : boolean;
begin
  Result := (HasData = false) and (HideIfEmpty = true);
end;


function TVitalRow.EntryStampStrList : TStringList;
//list is owned by this object. Users should NOT delete it
Begin
  Result := FSortedVitalsEntries;
End;

////////////////////////////////////////////////////////////////////////////////
//TVitalRowList class code
////////////////////////////////////////////////////////////////////////////////

function TVitalRowList.GetVitalRow(Index : integer) : TVitalRow;
begin
  Result := TVitalRow(Get(Index));
end;

procedure TVitalRowList.SetVitalRow(Index : integer; Value : TVitalRow);
begin
  Put(Index,Value);
end;

////////////////////////////////////////////////////////////////////////////////
//TVitalsData class code
////////////////////////////////////////////////////////////////////////////////
constructor TVitalsData.Create;
begin
  FVitalsRows := TVitalRowList.Create;   //this will own pointers and delete on destruction
  FSortedVitalsRows := TStringList.Create; //this will NOT own pointers
  FSortedVitalsRows.Sorted := true;
  //FColumnsList := TStringList.Create;  //will not store any pointers
  FLabelsList := TStringList.Create;  //will not store any pointers

end;

destructor TVitalsData.Destroy;
begin
  DeleteRows;
  FVitalsRows.Free;
  FSortedVitalsRows.Free;
  //FColumnsList.Free;
  FLabelsList.Free;
  inherited Destroy;
//  messageDlg('Starting TVitalsData.Destroy',mtInformation,[mbOK],0);
end;

function TVitalsData.Item(Index: integer): TVitalRow;
begin
  if (Index>= 0) and (Index<FVitalsRows.Count) then begin
    Result := FVitalsRows.Items[Index];
  end else Result := nil;
end;

function TVitalsData.NumRows : Integer;
begin
  Result := FVitalsRows.Count;
end;

function TVitalsData.VisibleItem(Index: integer; IncludeEmpty : boolean=false): TVitalRow;
//Not all items in the data grid will always visible.  For example the user may not
//want to see an empty row for central venous pressure monitoring.  So many rows
//are specified to be hidden if empty.  This is set in the template that created
//the row.
//To get the number of not-hidden row, use NumVisibleRows.
//Then, to get the Index'th visible row, use this function.
//If IncludeEmpty=True, then this function should return a result the SAME as
//  function SortedItem(Index: integer)

var i,count : integer;
    OneRow : TVitalRow;
begin
  count := -1;
  Result := nil;
  for i := 0 to FSortedVitalsRows.Count-1 do begin
    OneRow := TVitalRow(FSortedVitalsRows.Objects[i]);
    if OneRow = nil then continue;
    if (OneRow.ShouldHide=true) and (IncludeEmpty=false) then continue;
    inc(count);
    if (count <> Index) then continue;
    Result := OneRow;
    break;
  end;
end;


function TVitalsData.SortedItem(Index : integer; IncludeEmpty : boolean): TVitalRow;
//Return TVitalRow matching index from a Sorted Vitals Row List
//User can cycle through rows via 0 to TVitalsData.count.
//If Row is Empty, and HideIfEmpty=TRUE, then nil will be returned.
begin
  if (Index >= 0) and (Index < FSortedVitalsRows.Count) then begin
    Result := TVitalRow(FSortedVitalsRows.Objects[Index]);
    if (Result.ShouldHide=true) and (IncludeEmpty=false) then result:= nil
  end else Result := nil;
end;

function TVitalsData.RowForPiece(PieceS : string) : TVitalRow;
//return row matching data piece from RPC data
//Note: this supports input format of 12;2
//      This will mean piece 12, but subpiece 2
//Note: this supports input format of 12;2
//      This will mean piece 12, but subpiece 2
//Note: or 12;2,3,4
//      This will mean piece 12, but subpieces 2,3,4


var i : integer;
    OneRow : TVitalRow;
    PieceNum : integer;
    subPieces : string;
    s : string;
begin
  Result := nil;
  PieceNum := StrToInt(Piece(PieceS,';',1));
  s := Piece(PieceS,';',1);
  if s<>'' then subPieces := Piece(s,';',2)
  else subPieces := '';
  for i := 0 to FVitalsRows.count-1 do begin
    OneRow := FVitalsRows.Items[i];
    if OneRow.DataPiece = PieceNum then begin
      if (subPieces<>'') and (OneRow.DesiredSubPieces <> subPieces) then continue;
      Result := OneRow;
      break;
    end;
  end;
end;

function TVitalsData.PiecesList(DataPieces: string) : TVitalRowList;
//returns list of rows patching data pieces.  Doesn't own pointers
//NOTICE: this function will create list, but won't delete it.  Users MUST FREE IT
//Format of DataPieces: 12^4^8^... for example of pieces 12,4,8...
//Note: this also supports input format of 12;2^4^8..., or 12;2,3,4^4^8...
//      This will mean piece 12, but subpiece 2
//Note: or 12;2,3,4^4^8...
//      This will mean piece 12, but subpieces 2,3,4

var p : integer;
    s : string;
    OneRow : TVitalRow;
    List : TVitalRowList;
begin
  List := TVitalRowList.Create;
  repeat
    p := Pos('^',DataPieces);
    if p>0 then begin
      s := piece(DataPieces,'^',1);
      DataPieces := piece(DataPieces,'^',2,999);
    end else begin
      s := DataPieces;
    end;
    OneRow := RowForPiece(s);
    if OneRow <> nil then List.Add(OneRow);
  until p=0;
  Result := List;
end;


procedure TVitalsData.Clear;
var i : integer;
    OneRow : TVitalRow;
begin
  //FColumnsList.Clear;   //Doesn't hold any pointers
  FLabelsList.Clear;    //Doesn't hold any pointers
  //FSortedVitalsRows.Clear; //Doesn't own any pointers
  for i := 0 to FVitalsRows.count-1 do begin
    OneRow := FVitalsRows.Items[i];
    if OneRow <> nil then begin
      OneRow.Clear;
    end;
  end;
end;

procedure TVitalsData.DeleteRows;
//Delete members of FVitalsRows
var i : integer;
    OneRow : TVitalRow;
begin
  for i := 0 to FVitalsRows.count-1 do begin
    OneRow := FVitalsRows.Items[i];
    if OneRow <> nil then begin
      OneRow.Clear;
      OneRow.Free;
    end;
  end;
  FVitalsRows.Clear;
end;

procedure TVitalsData.Add(OneRow: TVitalRow);
var DispSeqStr : string;
begin
  if OneRow <> nil then begin
    FVitalsRows.Add(OneRow);  //FVitalsRows owns objects
    DispSeqStr := IntToStr(OneRow.DisplaySeq);
    while Length(DispSeqStr)<3 do DispSeqStr := '0'+DispSeqStr;
    FSortedVitalsRows.AddObject(DispSeqStr+'^'+OneRow.RowLabel,OneRow);  //will sort items in display seq
  end;
end;

procedure TVitalsData.AddRowFromStr(FormatString : string; var MaxDispSeqValue : word);
var
  OneRow : TVitalRow;
  DispSeqStr : string;
begin
  //MessageDlg('In TVitalsData.AddRowFromStr, adding from: '+#13+#10+
  //            FormatString, mtInformation, [mbOK], 0);
  OneRow := TVitalRow.Create(FormatString, MaxDispSeqValue);
  FVitalsRows.Add(OneRow);
  DispSeqStr := IntToStr(OneRow.DisplaySeq);
  while Length(DispSeqStr)<3 do DispSeqStr := '0'+DispSeqStr;
  FSortedVitalsRows.AddObject(DispSeqStr+'^'+OneRow.RowLabel,OneRow);  //will sort items in display seq
end;


procedure TVitalsData.AddVitalSet(InputString : string);
//A vitals set is a column of entries into multiple rows
var i : integer;
    Value : string;
    OneRow : TVitalRow;
    EntryStamp : TVitalEntryStamp;
    subI : integer;
    tempValue : string;
    PieceIndex : integer;
begin
  //This hard codes in the following data from 4 set pieces:
  EntryStamp.Date := Piece(InputString,'^',1);
  EntryStamp.Time := Piece(InputString,'^',2);
  //EntryStamp.Location := Piece(InputString,'^',22);
  //EntryStamp.User := Piece(InputString,'^',23);

  for i := 0 to FVitalsRows.Count - 1 do begin
    OneRow := FVitalsRows.Items[i];
    PieceIndex := OneRow.DataPiece;
    Value := Piece(InputString,'^',PieceIndex);
    if OneRow.DesiredSubPieces <> '' then begin
      tempValue := '';
      for subI := 1 to PieceLen(Value,',') do begin
        tempValue := tempValue + Piece(Value,OneRow.DataDelim,subI); // <-- why no delimiter separating concatenated values?
      end;
      Value := tempValue;
    end;
    //add even if empty, to make "empty square" in grid
    //So every row will have the same number of entries.
    OneRow.AddValue(EntryStamp,Value);
  end;

  {
  for i := 1 to PieceLen(InputString,'^') do begin
    Value := Piece(InputString,'^',i);
    OneRow := RowForPiece(IntToStr(i));
    if OneRow = nil then continue;
    if OneRow.DesiredSubPieces <> '' then begin
      tempValue := ''; //kt 12/7/09
      for subI := 1 to PieceLen(Value,',') do begin
        tempValue := tempValue + Piece(Value,OneRow.DataDelim,subI);
      end;
      Value := tempValue;
    end;
    if Value<>'' then begin
      OneRow.AddValue(EntryStamp,Value);
    end;
  end;
  GatherColumnsInfo;
  }
end;

{
procedure TVitalsData.GatherColumnsInfo;
//Note: This is called automatically after every set of vitals it added, so it
//      should not need to be recalled before reading information from FColumnsList
var i,j : integer;
    OneRow : TVitalRow;
    EntryStampStr : String;
    ColumnsEntriesInOneRow : TStringList;
begin
  if FColumnsList = nil then FColumnsList := TStringList.Create //in case user did wrongly delete it!
  else FColumnsList.Clear;
  for i := 0 to FVitalsRows.Count-1 do begin
    OneRow := FVitalsRows.Items[i];
    if OneRow=nil then continue;
    ColumnsEntriesInOneRow := OneRow.EntryStampStrList;
    for j := 0 to ColumnsEntriesInOneRow.Count-1 do begin
      EntryStampStr := ColumnsEntriesInOneRow.Strings[j];
      if FColumnsList.IndexOf(EntryStampStr)>=0 then continue;
      FColumnsList.Add(EntryStampStr);
    end;
  end;
end;
}

function TVitalsData.NumColumns : integer;
begin
  Result := 0;
  if FVitalsRows.Count = 0 then exit;
  Result := FVitalsRows.Items[0].NumVitalEntries;
  {
  if FColumnsList = nil then begin
    FColumnsList := TStringList.Create; //in case user did wrongly delete it!
    GatherColumnsInfo;
  end;
  Result := FColumnsList.Count;
  }
end;

function TVitalsData.RowLabelsList(IncludeEmpty : boolean=false) : TStringList;
//list is owned by this object. Users should NOT delete it
//NOTE: list is only valid until another additon has been made.  Then
//      this function should be called again to refresh list.
var i : integer;
    OneRow : TVitalRow;
begin
  if FLabelsList = nil then FLabelsList := TStringList.Create;
  FLabelsList.Clear;
  FLabelsList.Sorted := false;
  for i := 0 to FSortedVitalsRows.Count-1 do begin
    OneRow := TVitalRow(FSortedVitalsRows.Objects[i]);
    if (OneRow=nil) or OneRow.ShouldHide then continue;
    FLabelsList.Add(OneRow.RowLabel);
  end;
  Result := FLabelsList;
end;

function TVitalsData.GetNumVisibleRows : integer;
var SL : TStringList;
begin
  SL := RowLabelsList(false);
  Result := SL.Count;
end;

function TVitalsData.GetVisibleVital(Col,Row:Word; Var OutVital : TVitalEntry) : Boolean;  //object returned should NOT be deleated by user
//Note: Row is the index amoung VISIBLE rows.  Does NOT count hidden (empty) rows.
//Result: TRUE= value is valid
//        FALSE= invalid value (i.e. nil)
//Col and Row counting starts at 0.
var  OneRow : TVitalRow;
begin
  OutVital := nil;
  Result := false;  //default to invalid data.
  OneRow := VisibleItem(Row);
  if OneRow = nil then exit;
  OutVital := OneRow.VitalItem(Col);
  Result := (OutVital <> nil);
end;


function TVitalsData.GetVital(Col,Row:Word; Var OutVital : TVitalEntry) : Boolean;  //object returned should NOT be deleated by user
//Note: Row is the index amoung ALL rows.  DOES count hidden (empty) rows.
//Result: TRUE= value is valid
//        FALSE= invalid value, or should be hidden.
//Col and Row counting starts at 0.
var  OneRow : TVitalRow;
begin
  OutVital := nil;
  Result := false;  //default to invalid data.
  OneRow := SortedItem(Row, true);
  if (OneRow <> nil) and (Col < NumColumns) then begin
    OutVital := OneRow.VitalItem(Col);
    Result := not (OneRow.ShouldHide or (OutVital=nil))
  end;
end;


initialization
begin
//elh This seems to be the area where the Hi and Lo Ranges are set  3/14/08
  {GMVVitalHiRange[Vital] all values are US Standard}
  GMVVitalHiRange[vtUnknown] := 0;
  GMVVitalHiRange[vtTemp] := 120;
  GMVVitalHiRange[vtPulse] := 300;
  GMVVitalHiRange[vtResp] := 100;
  GMVVitalHiRange[vtBP] := 300;
  GMVVitalHiRange[vtHeight] := 100;//AAN 07/03/2002 was 300
  GMVVitalHiRange[vtWeight] := 1500;//AAN 07/03/2002 was 500
  GMVVitalHiRange[vtPain] := 10;
  GMVVitalHiRange[vtPO2] := 100;
  GMVVitalHiRange[vtCVP] := 136;//AAN 07/03/2002
  GMVVitalHiRange[vtCircum] := 200;//AAN 07/03/2002 was 300;
  {$IFDEF TMG_WOUNDS}
  GMVVitalHiRange[vtWoundMeas1] := 300;//elh TEST RANGE;
  //GMVVitalHiRange[vtWoundAreaVol1] := 500;//elh TEST RANGE;
  //GMVVitalHiRange[vtWoundHFPct1] := 100;//elh TEST RANGE;
  {$ENDIF}
  GMVVitalLoRange[vtUnknown] := 0;
  GMVVitalLoRange[vtTemp] := 45;
  GMVVitalLoRange[vtPulse] := 0;
  GMVVitalLoRange[vtResp] := 0;
  GMVVitalLoRange[vtBP] := 0;
  GMVVitalLoRange[vtHeight] := 10; // vhaishandria 050321. was 0. See Remedy HD0000000068371
  GMVVitalLoRange[vtWeight] := 0;
  GMVVitalLoRange[vtPain] := 0;
  GMVVitalLoRange[vtPO2] := 0;
  GMVVitalLoRange[vtCVP] := -13.6;//AAN 07/03/2002    was -10;
  GMVVitalLoRange[vtCircum] := 1;// vhaishandria 050706 was 0
  {$IFDEF TMG_WOUNDS}
  GMVVitalLoRange[vtWoundMeas1] := 0;//elh TEST RANGE;
  //GMVVitalLoRange[vtWoundAreaVol1] := 0;//elh TEST RANGE;
  //GMVVitalLoRange[vtWoundHFPct1] := 0;//elh TEST RANGE;
  {$ENDIF}
end;


end.

