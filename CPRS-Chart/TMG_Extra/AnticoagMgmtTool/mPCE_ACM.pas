unit mPCE_ACM;
// ** Model for PCE in Anticoagulator

interface

uses
  Classes, ORNet, ORFn, SysUtils;
const
  SCC_YES =  1;
  SCC_NO  =  0;
  SCC_NA  = -1;

type
  TSCConditions = record
    SCAllow:  Boolean;        // prompt for service connected
    SCDflt:   Boolean;        // default if prompting service connected
    AOAllow:  Boolean;        // prompt for agent orange exposure
    AODflt:   Boolean;        // default if prompting agent orange exposure
    IRAllow:  Boolean;        // prompt for ionizing radiation exposure
    IRDflt:   Boolean;        // default if prompting ionizing radiation
    ECAllow:  Boolean;        // prompt for environmental conditions
    ECDflt:   Boolean;        // default if prompting environmental cond.
    MSTAllow: Boolean;        // prompt for military sexual trauma
    MSTDflt:  Boolean;        // default if prompting military sexual trauma
    HNCAllow: Boolean;        // prompt for Head or Neck Cancer
    HNCDflt:  Boolean;        // default if prompting Head or Neck Cancer
    CVAllow:  Boolean;        // prompt for Combat Veteran Related
    CVDflt:   Boolean;        // default if prompting Comabt Veteran
    SHDAllow: Boolean;        // prompt for Shipboard Hazard and Defense
    SHDDflt:  Boolean;        // default if prompting Shipboard Hazard and Defense
    AskAny:   Boolean;        // flag indicating whether ANY are to be asked
  end;

  TPCEData = class
  {class for data to be passed to and from broker}
  private
    FUpdated:      boolean;
    FSCChanged:    Boolean;                        //
    FSCRelated:    Integer;                        //service con. related?
    FAORelated:    Integer;                        //
    FIRRelated:    Integer;                        //
    FECRelated:    Integer;                        //
    FMSTRelated:   Integer;                        //
    FHNCRelated:   Integer;                        //
    FCVRelated:    Integer;                        //
    FSHADRelated:   Integer;                        //

    procedure SetSCRelated(Value: Integer);
    procedure SetAORelated(Value: Integer);
    procedure SetIRRelated(Value: Integer);
    procedure SetECRelated(Value: Integer);
    procedure SetMSTRelated(Value: Integer);
    procedure SetHNCRelated(Value: Integer);
    procedure SetCVRelated(Value: Integer);
    procedure SetSHADRelated(Value: Integer);
  public
    constructor Create;
    procedure Clear;
    procedure Assign(Source : TPCEData);  //kt added
    property SCRelated:    Integer  read FSCRelated   write SetSCRelated;
    property AORelated:    Integer  read FAORelated   write SetAORelated;
    property IRRelated:    Integer  read FIRRelated   write SetIRRelated;
    property ECRelated:    Integer  read FECRelated   write SetECRelated;
    property MSTRelated:   Integer  read FMSTRelated  write SetMSTRelated;
    property HNCRelated:   Integer  read FHNCRelated  write SetHNCRelated;
    property CVRelated:    Integer  read FCVRelated  write SetCVRelated;
    property SHADRelated:   Integer  read FSHADRelated write SetSHADRelated;
    property Updated: boolean read FUpdated write FUpdated;
    function GetSCString: string;
  end;

function EligibleConditions(PtId: string; EncDt: string; EncLoc: string): TSCConditions;
procedure Disabilities(Dest: TStrings; PtId: String);

implementation

{ TPCEData methods ------------------------------------------------------------------------- }

constructor TPCEData.Create;
begin
  FSCRelated   := SCC_NA;
  FAORelated   := SCC_NA;
  FIRRelated   := SCC_NA;
  FECRelated   := SCC_NA;
  FMSTRelated  := SCC_NA;
  FHNCRelated  := SCC_NA;
  FCVRelated   := SCC_NA;
  FSHADRelated := SCC_NA;
  FSCChanged   := False;
end;

function TPCEData.GetSCString: string;
var
  SCString: string;
begin
  SCString := '^SC~';
  if FSCRelated <> SCC_NA then
    SCString := SCString + IntToStr(FSCRelated);
  SCString := SCString + '^AO~';
  if FAORelated <> SCC_NA then
    SCString := SCString + IntToStr(FAORelated);
  SCString := SCString + '^IR~';
  if FIRRelated <> SCC_NA then
    SCString := SCString + IntToStr(FIRRelated);
  SCString := SCString + '^EC~';
  if FECRelated <> SCC_NA then
    SCString := SCString + IntToStr(FECRelated);
  SCString := SCString + '^MST~';
  if FMSTRelated <> SCC_NA then
    SCString := SCString + IntToStr(FMSTRelated);
  SCString := SCString + '^HNC~';
  if FHNCRelated <> SCC_NA then
    SCString := SCString + IntToStr(FHNCRelated);
  SCString := SCString + '^CV~';
  if FCVRelated <> SCC_NA then
    SCString := SCString + IntToStr(FCVRelated);
  SCString := SCString + '^SHAD~';
  if FSHADRelated <> SCC_NA then
    SCString := SCString + IntToStr(FSHADRelated);
  Result := SCString;
end;

procedure TPCEData.Clear;
begin
  FSCRelated  := SCC_NA;
  FAORelated  := SCC_NA;
  FIRRelated  := SCC_NA;
  FECRelated  := SCC_NA;
  FMSTRelated := SCC_NA;
  FHNCRelated := SCC_NA;
  FCVRelated  := SCC_NA;
  FSHADRelated := SCC_NA;
end;

procedure TPCEData.Assign(Source : TPCEData);
//kt added
begin
  FUpdated       := Source.FUpdated;
  FSCChanged     := Source.FSCChanged;
  FSCRelated     := Source.FSCRelated;
  FAORelated     := Source.FAORelated;
  FIRRelated     := Source.FIRRelated;
  FECRelated     := Source.FECRelated;
  FMSTRelated    := Source.FMSTRelated;
  FHNCRelated    := Source.FHNCRelated;
  FCVRelated     := Source.FCVRelated;
  FSHADRelated   := Source.FSHADRelated;
end;


procedure TPCEData.SetSCRelated(Value: Integer);
begin
  if Value <> FSCRelated then
  begin
    FSCRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetAORelated(Value: Integer);
begin
  if Value <> FAORelated then
  begin
    FAORelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetIRRelated(Value: Integer);
begin
  if Value <> FIRRelated then
  begin
    FIRRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetECRelated(Value: Integer);
begin
  if Value <> FECRelated then
  begin
    FECRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetMSTRelated(Value: Integer);
begin
  if Value <> FMSTRelated then
  begin
    FMSTRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetHNCRelated(Value: Integer);
begin
//  if HNCOK and (Value <> FHNCRelated) then
  if Value <> FHNCRelated then
  begin
    FHNCRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetCVRelated(Value: Integer);
begin
  if (Value <> FCVRelated) then
  begin
    FCVRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetSHADRelated(Value: Integer);
begin
  if (Value <> FSHADRelated) then
  begin
    FSHADRelated := Value;
    FSCChanged   := True;
  end;
end;

function EligibleConditions(PtId: string; EncDt: string; EncLoc: string): TSCConditions;
{ return a record listing the conditions for which a patient is eligible }
var
  x: string;
begin
  x := sCallV('ORWPCE SCSEL', [PtId, EncDt, EncLoc]);
  with Result do
  begin
    SCAllow  := Piece(Piece(x, ';', 1), U, 1) = '1';
    SCDflt   := Piece(Piece(x, ';', 1), U, 2) = '1';
    AOAllow  := Piece(Piece(x, ';', 2), U, 1) = '1';
    AODflt   := Piece(Piece(x, ';', 2), U, 2) = '1';
    IRAllow  := Piece(Piece(x, ';', 3), U, 1) = '1';
    IRDflt   := Piece(Piece(x, ';', 3), U, 2) = '1';
    ECAllow  := Piece(Piece(x, ';', 4), U, 1) = '1';
    ECDflt   := Piece(Piece(x, ';', 4), U, 2) = '1';
    MSTAllow := Piece(Piece(x, ';', 5), U, 1) = '1';
    MSTDflt  := Piece(Piece(x, ';', 5), U, 2) = '1';
    HNCAllow := Piece(Piece(x, ';', 6), U, 1) = '1';
    HNCDflt  := Piece(Piece(x, ';', 6), U, 2) = '1';
    CVAllow  := Piece(Piece(x, ';', 7), U, 1) = '1';
    CVDflt   := Piece(Piece(x, ';', 7), U, 2) = '1';
    SHDAllow := Piece(Piece(x, ';', 8), U, 1) = '1';
    SHDDflt  := Piece(Piece(x, ';', 8), U, 2) = '1';
    AskAny   := (SCAllow or AOAllow or IRAllow or ECAllow or MSTAllow or HNCAllow or
                 CVAllow or SHDallow); 
  end;
end;

procedure Disabilities(Dest: TStrings; PtId: String);
begin
  CallV('ORWPCE SCDIS', [PtId]);
  FastAssign(RPCBrokerV.Results, Dest);
end;
end.
