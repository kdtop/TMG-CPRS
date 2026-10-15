unit uMumpsData;

(*
  A JSON representation of MUMPS nodes.  A node which has both a value and
  descendants stores its value in the reserved "$value" property.  Values are
  stored as JSON strings because MUMPS node values are strings.

  TMumpsDataObject examples
  =========================

  Basic value
  -----------

  var
    Data: TMumpsDataObject;
  begin
    Data := TMumpsDataObject.Create;
    try
      Data[['patient', 'name']] := 'SMITH,JOHN';
      Memo1.Lines.Text := Data.ToJSON;
    finally
      Data.Free;
    end;
  end;

  Produces:

  {"patient":{"name":"SMITH,JOHN"}}


  Uniform path syntax
  -------------------

  Data[['name']] := 'SMITH,JOHN';
  Data[['patient', 'name', 'length']] := '10';
  PatientName := Data[['patient', 'name']];

  Produces:

  {"name":"SMITH,JOHN","patient":{"name":{"length":"10"}}}


  Node with both a value and descendants
  --------------------------------------

  Data[['patient', 'name']] := 'SMITH,JOHN';
  Data[['patient', 'name', 'length']] := '10';

  Produces:

  {"patient":{"name":{"$value":"SMITH,JOHN","length":"10"}}}


  Branch without its own value
  ----------------------------

  Data[['patient', 'address', 'city']] := 'Nashville';
  Data[['patient', 'address', 'state']] := 'TN';

  Produces:

  {"patient":{"address":{"city":"Nashville","state":"TN"}}}


  Read a node value
  -----------------

  PatientName := Data[['patient', 'name']];


  Distinguish an undefined node from an empty value
  --------------------------------------------------

  if Data.TryGetMumpsValue(['patient', 'name'], PatientName) then begin
    // The node is defined.  PatientName may still be an empty string.
  end;


  MUMPS variable with its own value and child nodes
  -------------------------------------------------

  Data[[]] := 'root value';
  Data[['status']] := 'active';

  Produces:

  {"$value":"root value","status":"active"}


  Notes
  -----

  * Use Data[['subscript']] for a one-level path and Data[['a', 'b', 'c']] for a
    deeper path.  The outer brackets access the default property; the inner
    brackets are Delphi's open-array constructor.
  * $value is reserved for this representation and cannot be used as a normal
    MUMPS subscript through SetMumpsValue.
  * MUMPS values are stored as JSON strings.


  Order child subscripts in MUMPS collation order
  ------------------------------------------------

  Data[['patient', 'name']] := 'SMITH,JOHN';
  Data[['patient', 'name', 'length']] := '10';
  Data[['patient', 'name', 'source']] := 'imported';

  Current := Data.Order(['patient', 'name'], '');
  while Current <> '' do begin
    // Current is 'length', then 'source'.
    Current := Data.Order(['patient', 'name'], Current);
  end;

  Order returns an empty string when no next subscript exists. Empty subscripts
  are not supported by TMumpsDataObject.


  Check whether a node has a value, descendants, or both
  --------------------------------------------------------

  Status := Data.DataStatus(['patient', 'name']);

  // Status is compatible with MUMPS $DATA:
  //   0  = node is undefined
  //   1  = node has a value only
  //  10  = node has descendants only
  //  11  = node has both a value and descendants


  Delete a node and all of its descendants
  -----------------------------------------

  Data[['patient', 'address', 'city']] := 'Nashville';
  Data[['patient', 'address', 'state']] := 'TN';
  Data.Kill(['patient', 'address']);

  // The address node and both descendants are gone.
  // Data.Kill([]) clears the entire TMumpsDataObject.


  Merge a source branch into a destination branch
  ------------------------------------------------

  Source := TMumpsDataObject.Create;
  Destination := TMumpsDataObject.Create;
  try
    Source[['name']] := 'SMITH,JOHN';
    Source[['contact', 'phone']] := '555-0100';

    Destination[['patient', 'id']] := '123';
    Destination.Merge(['patient'], Source.Node([]));

    // Existing destination descendants are retained.  Produces:
    // {"patient":{"id":"123","name":"SMITH,JOHN",
    //              "contact":{"phone":"555-0100"}}}
  finally
    Destination.Free;
    Source.Free;
  end;

  Merge overlays values and descendants from the source, while retaining
  destination descendants that are not present in the source.  Node([]) means
  the root node.  To merge only a source branch, use for example:

  Destination.Merge(['patient', 'contact'], Source.Node(['contact']));

  The source is read before the merge begins, so a source and destination may be
  different branches of the same TMumpsDataObject.

 *)


interface

uses
  System.SysUtils, System.JSON;

const
  MUMPS_DATA_VALUE_PROPERTY = '$value';

type
  EMumpsDataObject = class(Exception);

  TMumpsDataObject = class;

  TMumpsSubscripts = array of string;

  IMumpsDataNode = interface
    function GetDataObject: TMumpsDataObject;
    function GetSubscripts: TMumpsSubscripts;
    property DataObject: TMumpsDataObject read GetDataObject;
    property Subscripts: TMumpsSubscripts read GetSubscripts;
  end;

  TMumpsDataNode = class(TInterfacedObject, IMumpsDataNode)
  strict private
    FDataObject: TMumpsDataObject;
    FSubscripts: TMumpsSubscripts;
  public
    constructor Create(ADataObject: TMumpsDataObject;
      const ASubscripts: array of string);
    function GetDataObject: TMumpsDataObject;
    function GetSubscripts: TMumpsSubscripts;
  end;

  //TMumpsDataObject = class(TJSONObject)    //<--- can't use due to class being 'sealed'
  TMumpsDataObject = class
  strict private
    FJSONObject: TJSONObject;
    procedure CheckSubscript(const ASubscript: string);
    function GetOrCreateChild(AParent: TJSONObject;
      const ASubscript: string): TJSONObject;
    function GetChild(AParent: TJSONObject;
      const ASubscript: string): TJSONObject;
    function GetObject(const ASubscripts: array of string): TJSONObject;
    function GetNodeJSONValue(const ASubscripts: array of string): TJSONValue;
    function GetJSONValueAsMumpsValue(AJSONValue: TJSONValue): string;
    function IsCanonicalMNumber(const ASubscript: string): Boolean;
    procedure GetCanonicalMNumberParts(const ASubscript: string; out ANegative: Boolean; out AExponent: Integer; out ADigits: string);
    function CompareCanonicalMNumbers(const ALeft, ARight: string): Integer;
    function CompareMSubscripts(const ALeft, ARight: string): Integer;
    function TryGetNodeValue(const ASubscripts: array of string; out AValue: string): Boolean;
    function NodeDataStatus(ANode: TJSONValue): Integer;
    procedure MergeJSONObject(ADestination, ASource: TJSONObject);
    procedure MergeNodeIntoParent(ADestinationParent: TJSONObject; const ADestinationSubscript: string; ASourceNode: TJSONValue);
    procedure ClearJSONObject(AJSONObject: TJSONObject);
    procedure MergeFrom(const ADestinationSubscripts: array of string;
      const ASource: TMumpsDataObject;
      const ASourceSubscripts: array of string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetMumpsValue(const ASubscripts: array of string; const AValue: string);
    function TryGetMumpsValue(const ASubscripts: array of string; out AValue: string): Boolean;
    function GetMumpsValue(const ASubscripts: array of string): string;
    function HasMumpsValue(const ASubscripts: array of string): Boolean;
    function DataStatus(const ASubscripts: array of string): Integer;
    procedure Kill(const ASubscripts: array of string);
    function Node(const ASubscripts: array of string): IMumpsDataNode;
    procedure Merge(const ADestinationSubscripts: array of string; const ASource: IMumpsDataNode);
    function Order(const AParentSubscripts: array of string; const AAfter: string; ADirection: Integer = 1): string;
    function ToJSON: string;
    property JSONObject: TJSONObject read FJSONObject;
    property Items[const ASubscripts: array of string]: string read GetMumpsValue write SetMumpsValue; default;
  end;

implementation

constructor TMumpsDataNode.Create(ADataObject: TMumpsDataObject;
  const ASubscripts: array of string);
var
  Index: Integer;
begin
  inherited Create;
  FDataObject := ADataObject;
  SetLength(FSubscripts, Length(ASubscripts));
  for Index := Low(ASubscripts) to High(ASubscripts) do begin
    FSubscripts[Index] := ASubscripts[Index];
  end;
end;

function TMumpsDataNode.GetDataObject: TMumpsDataObject;
begin
  Result := FDataObject;
end;

function TMumpsDataNode.GetSubscripts: TMumpsSubscripts;
begin
  Result := Copy(FSubscripts);
end;

constructor TMumpsDataObject.Create;
begin
  inherited Create;
  FJSONObject := TJSONObject.Create;
end;

destructor TMumpsDataObject.Destroy;
begin
  FJSONObject.Free;
  inherited Destroy;
end;

procedure TMumpsDataObject.CheckSubscript(const ASubscript: string);
begin
  if ASubscript = '' then begin
    raise EMumpsDataObject.Create('Empty subscripts are not supported.');
  end;
  if ASubscript = MUMPS_DATA_VALUE_PROPERTY then begin
    raise EMumpsDataObject.CreateFmt('"%s" is reserved for a node value.',
      [MUMPS_DATA_VALUE_PROPERTY]);
  end;
end;

function TMumpsDataObject.GetChild(AParent: TJSONObject;
  const ASubscript: string): TJSONObject;
var
  JSONValue: TJSONValue;
begin
  CheckSubscript(ASubscript);
  Result := nil;
  JSONValue := AParent.GetValue(ASubscript);
  if JSONValue is TJSONObject then begin
    Result := TJSONObject(JSONValue);
  end;
end;

function TMumpsDataObject.GetObject(
  const ASubscripts: array of string): TJSONObject;
var
  Index: Integer;
begin
  Result := FJSONObject;
  for Index := Low(ASubscripts) to High(ASubscripts) do begin
    Result := GetChild(Result, ASubscripts[Index]);
    if Result = nil then begin
      Exit;
    end;
  end;
end;

function TMumpsDataObject.GetNodeJSONValue(
  const ASubscripts: array of string): TJSONValue;
var
  CurrentObject: TJSONObject;
  Index: Integer;
begin
  Result := FJSONObject;
  CurrentObject := FJSONObject;
  for Index := Low(ASubscripts) to High(ASubscripts) do begin
    CheckSubscript(ASubscripts[Index]);
    Result := CurrentObject.GetValue(ASubscripts[Index]);
    if Result = nil then begin
      Exit;
    end;
    if Index < High(ASubscripts) then begin
      if not (Result is TJSONObject) then begin
        Result := nil;
        Exit;
      end;
      CurrentObject := TJSONObject(Result);
    end;
  end;
end;

function TMumpsDataObject.GetOrCreateChild(AParent: TJSONObject;
  const ASubscript: string): TJSONObject;
var
  ExistingPair: TJSONPair;
  ExistingValue: TJSONValue;
begin
  CheckSubscript(ASubscript);
  ExistingValue := AParent.GetValue(ASubscript);
  if ExistingValue is TJSONObject then begin
    Result := TJSONObject(ExistingValue);
    Exit;
  end;

  Result := TJSONObject.Create;
  if ExistingValue = nil then begin
    AParent.AddPair(ASubscript, Result);
    Exit;
  end;

  ExistingPair := AParent.RemovePair(ASubscript);
  try
    Result.AddPair(MUMPS_DATA_VALUE_PROPERTY,
      TJSONValue(ExistingPair.JsonValue.Clone));
  finally
    ExistingPair.Free;
  end;
  AParent.AddPair(ASubscript, Result);
end;

function TMumpsDataObject.GetJSONValueAsMumpsValue(
  AJSONValue: TJSONValue): string;
begin
  if AJSONValue is TJSONString then begin
    Result := TJSONString(AJSONValue).Value;
  end else begin
    Result := AJSONValue.ToJSON;
  end;
end;

function TMumpsDataObject.NodeDataStatus(ANode: TJSONValue): Integer;
var
  NodeObject: TJSONObject;
  Pair: TJSONPair;
  HasValue: Boolean;
  HasDescendants: Boolean;
  Index: Integer;
begin
  if ANode = nil then begin
    Result := 0;
    Exit;
  end;
  if not (ANode is TJSONObject) then begin
    Result := 1;
    Exit;
  end;

  NodeObject := TJSONObject(ANode);
  HasValue := NodeObject.GetValue(MUMPS_DATA_VALUE_PROPERTY) <> nil;
  HasDescendants := False;
  for Index := 0 to NodeObject.Count - 1 do begin
    Pair := NodeObject.Pairs[Index];
    if Pair.JsonString.Value <> MUMPS_DATA_VALUE_PROPERTY then begin
      HasDescendants := True;
      Break;
    end;
  end;

  Result := 0;
  if HasValue then begin
    Inc(Result);
  end;
  if HasDescendants then begin
    Inc(Result, 10);
  end;
end;

procedure TMumpsDataObject.ClearJSONObject(AJSONObject: TJSONObject);
var
  Pair: TJSONPair;
begin
  while AJSONObject.Count > 0 do begin
    Pair := AJSONObject.RemovePair(AJSONObject.Pairs[0].JsonString.Value);
    Pair.Free;
  end;
end;

procedure TMumpsDataObject.MergeJSONObject(ADestination, ASource: TJSONObject);
var
  Pair: TJSONPair;
  Index: Integer;
begin
  for Index := 0 to ASource.Count - 1 do begin
    Pair := ASource.Pairs[Index];
    if Pair.JsonString.Value = MUMPS_DATA_VALUE_PROPERTY then begin
      MergeNodeIntoParent(ADestination, MUMPS_DATA_VALUE_PROPERTY,
        Pair.JsonValue);
    end else begin
      MergeNodeIntoParent(ADestination, Pair.JsonString.Value, Pair.JsonValue);
    end;
  end;
end;

procedure TMumpsDataObject.MergeNodeIntoParent(ADestinationParent: TJSONObject;
  const ADestinationSubscript: string; ASourceNode: TJSONValue);
var
  DestinationNode: TJSONValue;
  DestinationPair: TJSONPair;
  DestinationObject: TJSONObject;
begin
  DestinationNode := ADestinationParent.GetValue(ADestinationSubscript);
  if not (ASourceNode is TJSONObject) then begin
    if DestinationNode is TJSONObject then begin
      DestinationObject := TJSONObject(DestinationNode);
      DestinationPair := DestinationObject.RemovePair(MUMPS_DATA_VALUE_PROPERTY);
      DestinationPair.Free;
      DestinationObject.AddPair(MUMPS_DATA_VALUE_PROPERTY,
        TJSONValue(ASourceNode.Clone));
    end else begin
      DestinationPair := ADestinationParent.RemovePair(ADestinationSubscript);
      DestinationPair.Free;
      ADestinationParent.AddPair(ADestinationSubscript,
        TJSONValue(ASourceNode.Clone));
    end;
    Exit;
  end;

  if DestinationNode = nil then begin
    ADestinationParent.AddPair(ADestinationSubscript,
      TJSONValue(ASourceNode.Clone));
    Exit;
  end;
  if not (DestinationNode is TJSONObject) then begin
    DestinationPair := ADestinationParent.RemovePair(ADestinationSubscript);
    try
      DestinationObject := TJSONObject.Create;
      DestinationObject.AddPair(MUMPS_DATA_VALUE_PROPERTY,
        TJSONValue(DestinationPair.JsonValue.Clone));
    finally
      DestinationPair.Free;
    end;
    ADestinationParent.AddPair(ADestinationSubscript, DestinationObject);
  end else begin
    DestinationObject := TJSONObject(DestinationNode);
  end;
  MergeJSONObject(DestinationObject, TJSONObject(ASourceNode));
end;

function TMumpsDataObject.IsCanonicalMNumber(const ASubscript: string): Boolean;
var
  DecimalPointPos: Integer;
  FirstDigitPos: Integer;
  Index: Integer;
  SignificantDigits: Integer;
begin
  Result := False;
  if ASubscript = '' then begin
    Exit;
  end;

  FirstDigitPos := 1;
  if ASubscript[1] = '-' then begin
    FirstDigitPos := 2;
  end;
  if FirstDigitPos > Length(ASubscript) then begin
    Exit;
  end;

  DecimalPointPos := 0;
  for Index := FirstDigitPos to Length(ASubscript) do begin
    if ASubscript[Index] = '.' then begin
      if DecimalPointPos <> 0 then begin
        Exit;
      end;
      DecimalPointPos := Index;
    end else if not CharInSet(ASubscript[Index], ['0'..'9']) then begin
      Exit;
    end;
  end;
  if DecimalPointPos = Length(ASubscript) then begin
    Exit;
  end;

  if (ASubscript = '0') then begin
    Result := True;
    Exit;
  end;
  if ASubscript[FirstDigitPos] = '0' then begin
    Exit;
  end;
  if (DecimalPointPos <> 0) and (ASubscript[Length(ASubscript)] = '0') then begin
    Exit;
  end;

  SignificantDigits := 0;
  for Index := FirstDigitPos to Length(ASubscript) do begin
    if ASubscript[Index] <> '.' then begin
      Inc(SignificantDigits);
    end;
  end;
  if DecimalPointPos = 0 then begin
    while (SignificantDigits > 1) and
          (ASubscript[FirstDigitPos + SignificantDigits - 1] = '0') do begin
      Dec(SignificantDigits);
    end;
  end;
  Result := SignificantDigits <= 18;
end;

procedure TMumpsDataObject.GetCanonicalMNumberParts(const ASubscript: string;
  out ANegative: Boolean; out AExponent: Integer; out ADigits: string);
var
  DecimalPointPos: Integer;
  FirstDigitPos: Integer;
begin
  ANegative := ASubscript[1] = '-';
  FirstDigitPos := 1;
  if ANegative then begin
    FirstDigitPos := 2;
  end;
  DecimalPointPos := Pos('.', ASubscript);
  if DecimalPointPos = 0 then begin
    AExponent := Length(ASubscript) - FirstDigitPos;
  end else begin
    AExponent := DecimalPointPos - FirstDigitPos - 1;
  end;
  ADigits := StringReplace(Copy(ASubscript, FirstDigitPos, MaxInt), '.', '',
    [rfReplaceAll]);
end;

function TMumpsDataObject.CompareCanonicalMNumbers(const ALeft,
  ARight: string): Integer;
var
  LeftNegative: Boolean;
  RightNegative: Boolean;
  LeftExponent: Integer;
  RightExponent: Integer;
  LeftDigits: string;
  RightDigits: string;
  Index: Integer;
  LeftDigit: Char;
  RightDigit: Char;
  MaxLength: Integer;
begin
  if ALeft = ARight then begin
    Result := 0;
    Exit;
  end;
  if ALeft = '0' then begin
    if ARight[1] = '-' then begin
      Result := 1;
    end else begin
      Result := -1;
    end;
    Exit;
  end;
  if ARight = '0' then begin
    if ALeft[1] = '-' then begin
      Result := -1;
    end else begin
      Result := 1;
    end;
    Exit;
  end;

  GetCanonicalMNumberParts(ALeft, LeftNegative, LeftExponent, LeftDigits);
  GetCanonicalMNumberParts(ARight, RightNegative, RightExponent, RightDigits);
  if LeftNegative <> RightNegative then begin
    if LeftNegative then begin
      Result := -1;
    end else begin
      Result := 1;
    end;
    Exit;
  end;
  if LeftExponent <> RightExponent then begin
    if LeftExponent < RightExponent then begin
      Result := -1;
    end else begin
      Result := 1;
    end;
  end else begin
    Result := 0;
    MaxLength := Length(LeftDigits);
    if Length(RightDigits) > MaxLength then begin
      MaxLength := Length(RightDigits);
    end;
    for Index := 1 to MaxLength do begin
      if Index <= Length(LeftDigits) then begin
        LeftDigit := LeftDigits[Index];
      end else begin
        LeftDigit := '0';
      end;
      if Index <= Length(RightDigits) then begin
        RightDigit := RightDigits[Index];
      end else begin
        RightDigit := '0';
      end;
      if LeftDigit < RightDigit then begin
        Result := -1;
        Break;
      end;
      if LeftDigit > RightDigit then begin
        Result := 1;
        Break;
      end;
    end;
  end;
  if LeftNegative then begin
    Result := -Result;
  end;
end;

function TMumpsDataObject.CompareMSubscripts(const ALeft, ARight: string): Integer;
var
  LeftIsNumber: Boolean;
  RightIsNumber: Boolean;
begin
  if ALeft = ARight then begin
    Result := 0;
    Exit;
  end;
  if ALeft = '' then begin
    Result := -1;
    Exit;
  end;
  if ARight = '' then begin
    Result := 1;
    Exit;
  end;

  LeftIsNumber := IsCanonicalMNumber(ALeft);
  RightIsNumber := IsCanonicalMNumber(ARight);
  if LeftIsNumber and RightIsNumber then begin
    Result := CompareCanonicalMNumbers(ALeft, ARight);
  end else if LeftIsNumber then begin
    Result := -1;
  end else if RightIsNumber then begin
    Result := 1;
  end else begin
    Result := CompareStr(ALeft, ARight);
  end;
end;

function TMumpsDataObject.TryGetNodeValue(const ASubscripts: array of string; out AValue: string): Boolean;
var
  CurrentObject: TJSONObject;
  JSONValue: TJSONValue;
  Index: Integer;
begin
  Result := False;
  AValue := '';
  if Length(ASubscripts) = 0 then begin
    JSONValue := FJSONObject.GetValue(MUMPS_DATA_VALUE_PROPERTY);
    if JSONValue <> nil then begin
      AValue := GetJSONValueAsMumpsValue(JSONValue);
      Result := True;
    end;
    Exit;
  end;

  CurrentObject := FJSONObject;
  for Index := Low(ASubscripts) to High(ASubscripts) - 1 do begin
    CurrentObject := GetChild(CurrentObject, ASubscripts[Index]);
    if CurrentObject = nil then begin
      Exit;
    end;
  end;

  CheckSubscript(ASubscripts[High(ASubscripts)]);
  JSONValue := CurrentObject.GetValue(ASubscripts[High(ASubscripts)]);
  if JSONValue = nil then begin
    Exit;
  end;
  if JSONValue is TJSONObject then begin
    JSONValue := TJSONObject(JSONValue).GetValue(MUMPS_DATA_VALUE_PROPERTY);
    if JSONValue = nil then begin
      Exit;
    end;
  end;
  AValue := GetJSONValueAsMumpsValue(JSONValue);
  Result := True;
end;

procedure TMumpsDataObject.SetMumpsValue(const ASubscripts: array of string;
  const AValue: string);
var
  CurrentObject: TJSONObject;
  ExistingPair: TJSONPair;
  Index: Integer;
begin
  if Length(ASubscripts) = 0 then begin
    ExistingPair := FJSONObject.RemovePair(MUMPS_DATA_VALUE_PROPERTY);
    ExistingPair.Free;
    FJSONObject.AddPair(MUMPS_DATA_VALUE_PROPERTY, TJSONString.Create(AValue));
    Exit;
  end;

  CurrentObject := FJSONObject;
  for Index := Low(ASubscripts) to High(ASubscripts) - 1 do begin
    CurrentObject := GetOrCreateChild(CurrentObject, ASubscripts[Index]);
  end;

  CheckSubscript(ASubscripts[High(ASubscripts)]);
  if CurrentObject.GetValue(ASubscripts[High(ASubscripts)]) is TJSONObject then begin
    CurrentObject := TJSONObject(CurrentObject.GetValue(ASubscripts[High(ASubscripts)]));
    ExistingPair := CurrentObject.RemovePair(MUMPS_DATA_VALUE_PROPERTY);
    ExistingPair.Free;
    CurrentObject.AddPair(MUMPS_DATA_VALUE_PROPERTY, TJSONString.Create(AValue));
  end else begin
    ExistingPair := CurrentObject.RemovePair(ASubscripts[High(ASubscripts)]);
    ExistingPair.Free;
    CurrentObject.AddPair(ASubscripts[High(ASubscripts)], TJSONString.Create(AValue));
  end;
end;

function TMumpsDataObject.TryGetMumpsValue(const ASubscripts: array of string;
  out AValue: string): Boolean;
begin
  Result := TryGetNodeValue(ASubscripts, AValue);
end;

function TMumpsDataObject.GetMumpsValue(const ASubscripts: array of string): string;
begin
  if not TryGetMumpsValue(ASubscripts, Result) then begin
    Result := '';
  end;
end;

function TMumpsDataObject.HasMumpsValue(const ASubscripts: array of string): Boolean;
var
  Value: string;
begin
  Result := TryGetMumpsValue(ASubscripts, Value);
end;

function TMumpsDataObject.DataStatus(
  const ASubscripts: array of string): Integer;
begin
  Result := NodeDataStatus(GetNodeJSONValue(ASubscripts));
end;

procedure TMumpsDataObject.Kill(const ASubscripts: array of string);
var
  Objects: array of TJSONObject;
  CurrentObject: TJSONObject;
  ChildObject: TJSONObject;
  Pair: TJSONPair;
  Index: Integer;
begin
  if Length(ASubscripts) = 0 then begin
    ClearJSONObject(FJSONObject);
    Exit;
  end;

  SetLength(Objects, Length(ASubscripts));
  CurrentObject := FJSONObject;
  Objects[0] := CurrentObject;
  for Index := Low(ASubscripts) to High(ASubscripts) - 1 do begin
    CheckSubscript(ASubscripts[Index]);
    ChildObject := GetChild(CurrentObject, ASubscripts[Index]);
    if ChildObject = nil then begin
      Exit;
    end;
    CurrentObject := ChildObject;
    Objects[Index + 1] := CurrentObject;
  end;

  CheckSubscript(ASubscripts[High(ASubscripts)]);
  Pair := CurrentObject.RemovePair(ASubscripts[High(ASubscripts)]);
  if Pair = nil then begin
    Exit;
  end;
  Pair.Free;

  for Index := High(ASubscripts) - 1 downto Low(ASubscripts) do begin
    ChildObject := Objects[Index + 1];
    if ChildObject.Count <> 0 then begin
      Break;
    end;
    Pair := Objects[Index].RemovePair(ASubscripts[Index]);
    Pair.Free;
  end;
end;

function TMumpsDataObject.Node(
  const ASubscripts: array of string): IMumpsDataNode;
var
  Index: Integer;
begin
  for Index := Low(ASubscripts) to High(ASubscripts) do begin
    CheckSubscript(ASubscripts[Index]);
  end;
  Result := TMumpsDataNode.Create(Self, ASubscripts);
end;

procedure TMumpsDataObject.Merge(const ADestinationSubscripts: array of string;
  const ASource: IMumpsDataNode);
var
  SourceObject: TMumpsDataObject;
  SourceSubscripts: TMumpsSubscripts;
begin
  if ASource = nil then begin
    raise EMumpsDataObject.Create('A source node is required for Merge.');
  end;
  SourceObject := ASource.DataObject;
  SourceSubscripts := ASource.Subscripts;
  MergeFrom(ADestinationSubscripts, SourceObject, SourceSubscripts);
end;

procedure TMumpsDataObject.MergeFrom(const ADestinationSubscripts: array of string;
  const ASource: TMumpsDataObject; const ASourceSubscripts: array of string);
var
  SourceNode: TJSONValue;
  SourceCopy: TJSONValue;
  DestinationParent: TJSONObject;
  Index: Integer;
begin
  if ASource = nil then begin
    raise EMumpsDataObject.Create('A source object is required for Merge.');
  end;

  SourceNode := ASource.GetNodeJSONValue(ASourceSubscripts);
  if SourceNode = nil then begin
    Exit;
  end;
  SourceCopy := TJSONValue(SourceNode.Clone);
  try
    if Length(ADestinationSubscripts) = 0 then begin
      if SourceCopy is TJSONObject then begin
        MergeJSONObject(FJSONObject, TJSONObject(SourceCopy));
      end else begin
        MergeNodeIntoParent(FJSONObject, MUMPS_DATA_VALUE_PROPERTY, SourceCopy);
      end;
      Exit;
    end;

    DestinationParent := FJSONObject;
    for Index := Low(ADestinationSubscripts) to High(ADestinationSubscripts) - 1 do begin
      DestinationParent := GetOrCreateChild(DestinationParent,
        ADestinationSubscripts[Index]);
    end;
    CheckSubscript(ADestinationSubscripts[High(ADestinationSubscripts)]);
    MergeNodeIntoParent(DestinationParent,
      ADestinationSubscripts[High(ADestinationSubscripts)], SourceCopy);
  finally
    SourceCopy.Free;
  end;
end;

function TMumpsDataObject.Order(const AParentSubscripts: array of string;
  const AAfter: string; ADirection: Integer): string;
var
  ParentObject: TJSONObject;
  Pair: TJSONPair;
  Candidate: string;
  Comparison: Integer;
  BestComparison: Integer;
  Index: Integer;
begin
  if (ADirection <> 1) and (ADirection <> -1) then begin
    raise EMumpsDataObject.Create('Order direction must be 1 or -1.');
  end;

  Result := '';
  ParentObject := GetObject(AParentSubscripts);
  if ParentObject = nil then begin
    Exit;
  end;

  for Index := 0 to ParentObject.Count - 1 do begin
    Pair := ParentObject.Pairs[Index];
    Candidate := Pair.JsonString.Value;
    if Candidate = MUMPS_DATA_VALUE_PROPERTY then begin
      Continue;
    end;
    Comparison := CompareMSubscripts(Candidate, AAfter);
    if (ADirection = 1) and (Comparison <= 0) then begin
      Continue;
    end;
    if (ADirection = -1) and (Comparison >= 0) and (AAfter <> '') then begin
      Continue;
    end;
    if Result = '' then begin
      Result := Candidate;
    end else begin
      BestComparison := CompareMSubscripts(Candidate, Result);
      if ((ADirection = 1) and (BestComparison < 0)) or
         ((ADirection = -1) and (BestComparison > 0)) then begin
        Result := Candidate;
      end;
    end;
  end;
end;

function TMumpsDataObject.ToJSON: string;
begin
  Result := FJSONObject.ToJSON;
end;

end.
