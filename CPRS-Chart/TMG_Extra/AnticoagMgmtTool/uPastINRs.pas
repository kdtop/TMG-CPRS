unit uPastINRs;
//kt 1/22/18

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, grids,
  StdCtrls, StrUtils, Math, DateUtils, ComCtrls, ExtCtrls, graphics,
  ORCtrls, ORFn, ORNet, Trpcb, {VA508AccessibilityManager,} mPCE_ACM,
  uHTMLTools, TMGHTML2;

type
  //RESULT=<INR VALUE>^^<external date>^<$H date>  <-- this is to match format from rRPCsACM.GetPastINRValues

  TOnePastINRValue = class(TObject)
  public
    RawData         : string;
    INR             : string;
    fINR            : single;
    DateStr         : string;
    DateTime        : TDateTime;//from DateStr
    Horolog         : single;
    SourceFlowsheet : TObject;   //must be TOneFlowsheet; //might be null, not always present.   Not owned here
    LabDrawLoc      : string;    //may be empty
    LabDrawPhone    : string;    //may be empty
    LabDrawFax      : string;    //may be empty
    procedure ParseFromData(s : string);
    procedure LoadFrom(INR, DateString : string); overload;
    procedure LoadFrom(UntypedFlowsheet : TObject); overload;
    procedure Assign(Source : TOnePastINRValue);
  end;

  TPastINRValues = class(TObject)
  private
    FList : TList; //owns objects
    function GetEntry(index : integer) : TOnePastINRValue;
    //procedure SetEntry(Index : integer; Value : TOnePastINRValue);
  public
    constructor Create;
    destructor Destroy; override;
    //function Add(Value : TOnePastINRValue) : integer;  overload;//returns index of added object, 0 based
    function Add(INR, DateStr : string) : integer; overload; //returns index of added object, 0 based
    function AddOneBlank : TOnePastINRValue;
    function AddFrom(UntypedFlowsheet : TObject) : TOnePastINRValue;
    procedure UpdateLinkedData(UntypedFlowsheet : TObject);
    function MostRecent : TOnePastINRValue; //returns nil if none available.
    procedure ParseFromRPCData(SL : TStrings);
    procedure Sort();
    function Count : integer;
    procedure Clear();
    function IndexOf(One : TOnePastINRValue) : integer;
    procedure Assign(Source : TPastINRValues);
    property Entry[index : integer] : TOnePastINRValue read GetEntry {write SetEntry}; default;
  end;

implementation
  uses uFlowsheet;

//====================================================

procedure TOnePastINRValue.ParseFromData(s : string);
// s=<INR VALUE>^^<external date>^<$H date>
var temp : string;
    strHorolog : string;
begin
  RawData := s;

  INR := Piece(s, '^', 1);

  temp := INR;
  if Pos('>', temp) > 0 then temp := Piece(temp, '>', 2);
  if Pos('<', temp) > 0 then temp := Piece(temp, '<', 2);
  if StrToFloatDef(temp, -1) = -1 then temp := '-1';
  fINR := StrToFloatDef(temp, 0);

  DateStr  := Piece(s, '^', 3);
  DateTime := StrToDateDef(DateStr, 0);
  strHorolog := Piece(s, '^', 4);
  strHorolog := Piece(strHorolog, ',', 1);  //drop time
  Horolog  := StrToFloatDef(strHorolog, 0);
end;

procedure TOnePastINRValue.LoadFrom(INR, DateString : string);
var  tempDate : TDateTime;
     Horolog : string;
begin
  tempDate := StrToDateDef(DateString, 0);
  Horolog := DateTimeToHorolog(tempDate);
  ParseFromData(INR+'^^'+DateString+'^'+Horolog);
end;

procedure TOnePastINRValue.LoadFrom(UntypedFlowsheet : TObject);
var OneFlowsheet : TOneFlowsheet;
begin
  if not (UntypedFlowsheet is TOneFlowsheet) then exit;
  OneFlowsheet := TOneFlowsheet(UntypedFlowsheet);
  LoadFrom(OneFlowsheet.INR, OneFlowsheet.INRLabDateStr);
  LabDrawLoc   := OneFlowsheet.LabDrawLoc;
  LabDrawPhone := OneFlowsheet.LabDrawPhone;
  LabDrawFax   := OneFlowsheet.LabDrawFax;
  SourceFlowsheet := OneFlowsheet;
end;


procedure TOnePastINRValue.Assign(Source : TOnePastINRValue);
begin
  RawData         := Source.RawData;
  INR             := Source.INR;
  fINR            := Source.fINR;
  DateStr         := Source.DateStr;
  DateTime        := Source.DateTime;
  Horolog         := Source.Horolog;
  SourceFlowsheet := Source.SourceFlowsheet; //copied instead of assigned, because not owned here.
end;

//----------------------------------------------

constructor TPastINRValues.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TPastINRValues.Destroy;
begin
  Clear();
  FList.Free;
  inherited Destroy;
end;

procedure TPastINRValues.Clear();
var i : integer;
begin
  for i := 0 to FList.Count - 1 do begin
    TOnePastINRValue(FList[i]).Free;
  end;
  FList.Clear;
end;


procedure TPastINRValues.Assign(Source : TPastINRValues);
var
  i : integer;
  One: TOnePastINRValue;
begin
  Clear();
  for i := 0 to Source.Count - 1 do begin
//  function TPastINRValues.AddOneBlank : TOnePastINRValue;

    One := AddOneBlank;
    One.Assign(Source.Entry[i]);
    //Add(One);
  end;
end;


function TPastINRValues.GetEntry(index : integer) : TOnePastINRValue;
begin
  Result := nil;
  if (index < FList.Count) and (index >= 0) then begin
    Result := TOnePastINRValue(FList[index]);
  end;
end;

{
//NOTE: The reason I am commenting this out is because I would need to figure
        out who owns the objects when they are set into this list.  At this time
        I am not using this functionality.  So if needed in the future, then
        figure it out then and code approprately...

procedure TPastINRValues.SetEntry(Index : integer; Value : TOnePastINRValue);
begin
  if index < FList.Count then begin
    if Assigned(FList[index]) then TOnePastINRValue(FList[index]).Free;
    FList[Index] := Value;
  end else if index = FList.Count then begin
    Add(Value);
  end else begin
    FList.Count := index + 1;
    FList[Index] := Value;
  end;
end;
}
{
function TPastINRValues.Add(Value : TOnePastINRValue) : integer;  //returns index of added object, 0 based
begin
  Result := FList.Add(Value);
end;
}

function TPastINRValues.Add(INR, DateStr : string) : integer; //returns index of added object, 0 based
var
  OneBlank : TOnePastINRValue;
begin
  OneBlank := AddOneBlank;
  Result := FList.Count - 1;  //add puts at end.
  OneBlank.LoadFrom(INR, DateStr);
end;


function TPastINRValues.AddOneBlank : TOnePastINRValue;
begin
  Result := TOnePastINRValue.Create();
  FList.Add(Result); //Add(Result);
end;

function TPastINRValues.AddFrom(UntypedFlowsheet : TObject) : TOnePastINRValue;
begin
  Result := AddOneBlank;
  Result.LoadFrom(UntypedFlowsheet);
end;

procedure TPastINRValues.UpdateLinkedData(UntypedFlowsheet : TObject);
var  i : integer;
     One: TOnePastINRValue;
     OneFlowsheet : TOneFlowsheet;
begin
  if not (UntypedFlowsheet is TOneFlowsheet) then exit;
  OneFlowsheet := TOneFlowsheet(UntypedFlowsheet);
  for i := 0 to FList.Count - 1 do begin
    One := Entry[i];
    if One.SourceFlowsheet = OneFlowsheet then begin
      One.LoadFrom(OneFlowsheet);
    end;
  end;
end;

function TPastINRValues.MostRecent : TOnePastINRValue; //returns nil if none available.
begin
  Sort;
  Result := GetEntry(FList.Count - 1);
end;

function TPastINRValues.Count : integer;
begin
  Result := FList.Count;
end;

function TPastINRValues.IndexOf(One : TOnePastINRValue) : integer;
begin
  Result := FList.IndexOf(One);
end;


function HandleINRSortCallback(Item1, Item2 : pointer) : integer;
//Result: 1 if Item1 > Item2
//        0 if Item1 = Item2
//       -1 if Item1 < Item2
var A, B : TOnePastINRValue;
begin
  Result := 0; //default to make compiler stop warning
  A := TOnePastINRValue(Item1); if not assigned(A) then exit;
  B := TOnePastINRValue(Item2); if not assigned(B) then exit;
  if A.DateTime > B.DateTime then Result := 1
  else if A.DateTime < B.DateTime then Result := -1
  else Result := 0;
end;

procedure TPastINRValues.Sort();
begin
  FList.Sort(HandleINRSortCallback)
end;

procedure TPastINRValues.ParseFromRPCData(SL : TStrings);
var i : integer;
    One : TOnePastINRValue;
begin
  for i := 0 to SL.Count - 1 do begin
    One := Self.AddOneBlank;
    One.ParseFromData(SL[i]);
  end;
end;


//====================================================


end.
