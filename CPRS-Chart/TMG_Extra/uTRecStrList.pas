unit uTRecStrList;

{
//kt added form 8/13/26
//kt created using codex 8/13/26
}

interface

uses
  SysUtils, Classes, ORFn;

type
  TRecStrList = class
  private
    FItems: TStringList;
    FSchema: TStringList;
    FSelIndex: Integer;
    FDelimiter: Char;
    function EncodeIDAsObject(const S: string): TObject;
    function GetCount: Integer;
    function GetItem(Index: Integer): string;
    function GetSelectedData(const FieldName: string): string;
    function GetSelectedID: Int64;
    function GetDisplayText(Index: Integer): string;
    function GetItemPiece(Index, PieceNum: Integer): string;
    procedure RebuildIDObjectCache;
    procedure SetDelimiter(const Value: Char);
    procedure SetItem(Index: Integer; const Value: string);
    procedure SetSelIndex(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    function Add(const S: string): Integer;
    procedure Insert(Index: Integer; const S: string);
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    procedure Clear;
    procedure SetSchema(FieldNames: TStringList);

    function GetID(Index: Integer): Int64;
    function SelectByID(AnID: Int64): Integer;
    function IndexOfID(AnID: Int64): Integer;
    function GetIEN(Index: Integer): Int64;       //<-- included for legacy consistency
    function SelectByIEN(AnIEN: Int64): Integer;  //<-- included for legacy consistency
    function IndexOfIEN(AnIEN: Int64): Integer;   //<-- included for legacy consistency
    function SelectedRecord: string;
    procedure DeleteSelected;

    property Count: Integer read GetCount;
    property Delimiter: Char read FDelimiter write SetDelimiter;
    property DisplayText[Index: Integer]: string read GetDisplayText;
    property Items[Index: Integer]: string read GetItem write SetItem; default;
    property SelectedData[const FieldName: string]: string read GetSelectedData;
    property SelectedID: Int64 read GetSelectedID;
    property ItemIEN: Int64 read GetSelectedID;  //<-- included for legacy consistency
    property SelectedIndex: Integer read FSelIndex write SetSelIndex;
    property ItemIndex: Integer read FSelIndex write SetSelIndex;  //<-- included for legacy consistency
    property ItemPiece[Index, PieceNum: Integer]: string read GetItemPiece;
  end;

implementation

constructor TRecStrList.Create;
begin
  inherited Create;
  FItems := TStringList.Create;
  FSchema := TStringList.Create;
  FSchema.CaseSensitive := False;
  FSelIndex := -1;
  FDelimiter := '^';
end;

destructor TRecStrList.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FSchema);
  inherited Destroy;
end;

function TRecStrList.Add(const S: string): Integer;
begin
  Result := FItems.AddObject(S, EncodeIDAsObject(S));
end;

procedure TRecStrList.Insert(Index: Integer; const S: string);
begin
  FItems.InsertObject(Index, S, EncodeIDAsObject(S));
  if (FSelIndex >= Index) then
    Inc(FSelIndex);
end;

procedure TRecStrList.Delete(Index: Integer);
begin
  FItems.Delete(Index);
  if FItems.Count = 0 then
    FSelIndex := -1
  else if FSelIndex > Index then
    Dec(FSelIndex)
  else if FSelIndex = Index then
  begin
    if FSelIndex >= FItems.Count then
      FSelIndex := FItems.Count - 1;
  end;
end;

procedure TRecStrList.Exchange(Index1, Index2: Integer);
begin
  FItems.Exchange(Index1, Index2);
  if FSelIndex = Index1 then
    FSelIndex := Index2
  else if FSelIndex = Index2 then
    FSelIndex := Index1;
end;

procedure TRecStrList.Clear;
begin
  FItems.Clear;
  FSelIndex := -1;
end;

function TRecStrList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TRecStrList.GetDisplayText(Index: Integer): string;
begin
  if (Index < 0) or (Index >= FItems.Count) then
    Result := ''
  else
    Result := Piece(FItems[Index], FDelimiter, 2);
end;

function TRecStrList.GetItemPiece(Index, PieceNum: Integer): string;
begin
  if (Index < 0) or (Index >= FItems.Count) or (PieceNum < 1) then
    Result := ''
  else
    Result := Piece(FItems[Index], FDelimiter, PieceNum);
end;

function TRecStrList.EncodeIDAsObject(const S: string): TObject;
var
  AValue: Int64;
begin
  AValue := StrToInt64Def(Piece(S, FDelimiter, 1), -1);
  Result := TObject(NativeInt(AValue));
end;

function TRecStrList.GetID(Index: Integer): Int64;
begin
  if (Index >= 0) and (Index < FItems.Count) then
    Result := NativeInt(FItems.Objects[Index])
  else
    Result := -1;
end;

function TRecStrList.GetIEN(Index: Integer): Int64;
//Included for legacy consistency
begin
  Result := GetID(Index);
end;


function TRecStrList.GetItem(Index: Integer): string;
begin
  if (Index >= 0) and (Index < FItems.Count) then
    Result := FItems[Index]
  else
    Result := '';
end;

function TRecStrList.GetSelectedData(const FieldName: string): string;
var
  PieceNum: Integer;
begin
  Result := '';
  if Trim(FieldName) = '' then
    Exit;
  PieceNum := FSchema.IndexOf(FieldName) + 1;
  if PieceNum <= 0 then
    Exit;
  Result := GetItemPiece(FSelIndex, PieceNum);
end;

function TRecStrList.GetSelectedID: Int64;
begin
  Result := GetID(FSelIndex);
end;

function TRecStrList.IndexOfID(AnID: Int64): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FItems.Count - 1 do
    if NativeInt(FItems.Objects[I]) = AnID then
    begin
      Result := I;
      Exit;
    end;
end;

function TRecStrList.IndexOfIEN(AnIEN: Int64): Integer;
//included for legacy consistency
begin
  Result := IndexOfID(AnIEN);
end;



procedure TRecStrList.RebuildIDObjectCache;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    FItems.Objects[I] := EncodeIDAsObject(FItems[I]);
end;

function TRecStrList.SelectByID(AnID: Int64): Integer;
begin
  Result := IndexOfID(AnID);
  FSelIndex := Result;
end;

function TRecStrList.SelectByIEN(AnIEN: Int64): Integer;
//Included for legacy consistency
begin
  Result := SelectByID(AnIEN);
end;

function TRecStrList.SelectedRecord: string;
begin
  Result := GetItem(FSelIndex);
end;

procedure TRecStrList.DeleteSelected;
begin
  if FSelIndex < 0 then
    Exit;
  Delete(FSelIndex);
end;


procedure TRecStrList.SetSchema(FieldNames: TStringList);
begin
  if Assigned(FieldNames) then
    FSchema.Assign(FieldNames)
  else
    FSchema.Clear;
end;

procedure TRecStrList.SetDelimiter(const Value: Char);
begin
  FDelimiter := Value;
  RebuildIDObjectCache;
end;

procedure TRecStrList.SetItem(Index: Integer; const Value: string);
begin
  if Index < 0 then
    Exit;
  while FItems.Count <= Index do
    FItems.AddObject('', EncodeIDAsObject(''));
  FItems[Index] := Value;
  FItems.Objects[Index] := EncodeIDAsObject(Value);
end;

procedure TRecStrList.SetSelIndex(const Value: Integer);
begin
  if (Value < -1) then
    FSelIndex := -1
  else if (Value >= FItems.Count) then
    FSelIndex := FItems.Count - 1
  else
    FSelIndex := Value;
end;

end.
