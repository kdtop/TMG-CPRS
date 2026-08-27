unit uVHA_ATE740X;

interface
uses
  RS232, Classes, SysUtils, Dialogs;

const
  iLimit = 100000;

type
  TATE740X = class(TObject)
  private
    ComPort: TComPort;
    fBootVersion,
    fPICVersion,
    fNBPVersion,
    fTempVersion,
    fSoftwareVersion,
    fSoftwaredate,
    fComPortName,
    fModel,
    fSerial,
    fStatus,
    fReadings:String;
    fMeasurements: TStringList;
    function getActionResult(anAction,aResultCode:String;
      aResultLength:Integer;aTimeout:Integer = iLimit):String;

    function getDateTime:String;
    function getNumeric:String;
    function getBatteryVoltage:String;
    function getBatteryCharge:String;

    function getPneumaticTestResults:TStringList;
    function getMeasurements:TStringList;

    function getSystolic:Integer;
    function getDiastolic:Integer;
    function getTemp: Real;
    function getMAP: Integer;
    function getSpo2:Integer;
    function getPulse:Integer;
    function getTempUnits:String;

    function getSBP:String;
    function getSTemp:String;
    function getSPulse:String;
    function getSSpO2:String;

    function getStatus:String;

    function getModel:String;
    function getSerial:String;
    function getDescription:String;
    procedure getSoftwareVersion;
  public
    property SoftwareVersion:String read fSoftwareVersion;
    property BootVersion:String read fBootVersion;
    property PICVersion:String read fPICVersion;
    property NBPVersion:String read fNBPVersion;
    property TempVersion:String read fTempVersion;

    property ComPortname:String read fComPortName;

    property SoftwareDate:String read fSoftwareDate;
    property Model:String read getModel;
    property SerialNumber:String read getSerial;

    property Status:String read getStatus;

    property iSystolic:Integer read getSystolic;
    property iDiastolic:Integer read getDiastolic;
    property fTemp: Real read getTemp;
    property TempUnit: String read getTempUnits;
    property iMAP: Integer read getMap;
    property iSpo2:Integer read getSpO2;
    property iPulse:Integer read getPulse;

    property sBP: String read getSBP;
    property sTemp: String read getSTemp;
    property sPulse:String read getsPulse;
    property sSpO2:String read getSSpO2;

    property DateTime:String read getDateTime;
    property Numerics: String read getNumeric;
    property BatteryVoltage:String read getbatteryVoltage;
    property BatteryCharge: String read getBatteryCharge;

    property PneumaticTest:TStringList read getPneumaticTestResults;
    property NIBP:TStringList read getMeasurements;

    property Measurements: TStringList read fMeasurements;

    property Description:String read getDescription;

    constructor Create;
    destructor Destroy;override;

    procedure NewPatient;
  end;

const
  cmsCreated = 'Created';
  cmsError = 'Error';
  cmsReady = 'Ready';

const
//  errCheckStatus = 'Verify CASMED Unit Status.';
//  errCheckStatus = 'Verify Vitals Sign Monitor Status.';
  errCheckStatus = 'Please verify that the monitor is connected and turned on.';

implementation

const

  cUnknown = 'Unknown';
  arError = 'ERROR';

  acDateTime = 'X08'+#13;
  acNumericValues = 'X09'+#13;

// Requests ====================================================================
(*
X031     “X032.0 “            Boot Version 2.0
X032     “X03 2.0”            PIC Version 2.0
X033     “X02 1.1”            NIBP Module Version 1.1
X034     “X02  14”            Temp Module Version 14
*)

  cmGetBatteryVoltage = 'X20';

  cmGetSoftwareVersion = 'X030';
  cmGetBootVersion = 'X031';
  cmGetPICVersion = 'X032';
  cmGetNBPVersion = 'X033';
  cmGetTempVersion = 'X034';

  cmGetModel = 'X04';
  cmGetSerial = 'X05';
  cmGetDateTime = 'X08';
  cmGetNumericValues = 'X09';

  cmStopMeasurement = 'X130';
  cmStartMeasurement = 'X131';
  cmStartSTATMeasurement = 'X132';

  cmExitmanometerMode = 'X140';
  cmEnterManometerMode = 'X141';

  cmStartPneumaticTest = 'X151';
  cmStopPneumaticTest = 'X150';

  cmGetBatteryCharge = 'X18';
  cmNewPatient = 'X37';

// Responses ===================================================================
  rspGetSoftwareVersion = 'X03';
  rspGetBootVersion = 'X031';
  rspGetPICVersion = 'X032';
  rspGetNBPVersion = 'X033';
  rspGetTempVersion = 'X034';

  rspGetModel = 'X04';
  rspGetSerial = 'X05';

  rspDateTime = 'X08';
  rspNumericValues = 'X09';

  rspNIBPMeasurement = 'X13';

  rspNIBPManometerMode = 'X14';//response is sent while in the manometer mode

  rspNIBPPneumaticTest = 'X15';

  rspBatteryCharge = 'X18';
  rspBatteryVoltage = 'X20';

  rspUnknown = 'X??';
  rspATEDisabled = 'X**';

function StripFirstChar(aChar:Char;aValue:String):String;
var
  s: String;
begin
  Result := aValue;
  s := aValue;
  while pos(aChar,s) = 1 do
    s := copy(s,2,Length(s));
  Result := s;
end;

constructor TATE740X.Create;
var
  s: String;
begin
  inherited;
  ComPort := TComPort.Create;

  fStatus := cmsCreated;
  fMeasurements := TStringList.Create;
  s := DateTime;
  if Length(s) < 8 then
    begin
//      ShowMessage('CASMED Date/Time: '+S);
      fStatus := cmsError;
    end;
  getSoftwareVersion;
end;

destructor TATE740X.Destroy;
begin
  ComPort.Free;
  fMeasurements.Free;
  inherited;
end;

function TATE740X.getStatus:String;
begin
  Result := fStatus;
end;

function TATE740X.getActionResult(anAction,aResultCode:String;
  aResultLength:Integer;aTimeout:Integer = iLimit):String;
var
  i: Integer;
begin
  i := 0;
  result := arError;
  if ComPort.Open then ComPort.Config;

  if ComPort.Write(anAction+#13) then
    while (pos(aResultCode, ComPort.CommandResults) = 0) and (i<aTimeout) do
      begin
        inc(i);
        Comport.Read(aResultLength);
      end;
  if (i<aTimeout) and (pos(aResultCode, ComPort.CommandResults) <> 0) then
    result := ComPort.CommandResults;

  ComPort.Purge;
  ComPort.Close;
end;

function TATE740X.getModel:String;
begin
  fModel := copy(GetActionResult(cmGetModel,rspGetModel,12),4,8);
  Result := fModel;
end;

procedure TATE740X.getSoftwareVersion;
var
//  sDate,sVersion,
  s: String;
  i: Integer;

  function SetValue(aValue:String;aPos,aLen:Integer):String;
    begin
      if aValue = arError then Result := 'Unknown'
      else
        Result := copy(aValue,aPos,aLen);
    end;

begin
  fBootVersion := cUnknown;
  fPICVersion := cUnknown;
  fNBPVersion := cUnknown;
  fTempVersion := cUnknown;
  s := GetActionResult(cmGetSoftwareVersion,rspGetSoftwareVersion,80,1000);
  if s = arError then fSoftwareversion := 'Unknown'
  else
    begin
      s := copy(s,5,80);
      for i := 0 to length(s) do
        if s[i] = #13 then break;
      if i < Length(s) then
        begin
          fSoftwareVersion := copy(s,1,i-1);
          s := copy(s,i+1,Length(s));
          for i := 0 to length(s) do
            if s[i] = #13 then break;
          if i <= Length(s) then
            begin
              s := copy(s,1,i-1);
              fSoftwareDate := copy(s,3,2)+'/'+copy(s,1,2)+'/'+copy(s,5,2);
            end
          else
            fSoftwareDate := 'Unknown';
        end;
      comPort.Purge;
      comPort.Close;
      comPort.Free;
      ComPort := TComPort.Create;
      fBootVersion :=SetValue(GetActionResult(cmGetBootVersion,rspGetBootVersion,8),5,4);
      comPort.Purge;
      comPort.Close;
      comPort.Free;
      ComPort := TComPort.Create;
      fPICVersion := SetValue(GetActionResult(cmGetPICVersion,rspGetPICVersion,8),5,4);
      comPort.Purge;
      comPort.Close;
      comPort.Free;
      ComPort := TComPort.Create;
      fNBPVersion := Setvalue(GetActionResult(cmGetNBPVersion,rspGetNBPVersion,8),5,4);
      comPort.Purge;
      comPort.Close;
      comPort.Free;
      ComPort := TComPort.Create;
      fTempVersion := Setvalue(GetActionResult(cmGetTempVersion,rspGetTempVersion,8),5,4);
      fComPortName := ComPort.ComPortname;
    end;
end;

function TATE740X.getSerial:String;
begin
  fSerial := copy(GetActionResult(cmGetSerial,rspGetSerial,12),4,8);
  Result := fSerial;
end;

function TATE740X.getDescription:String;
begin
  Result := Model + #13+#10+  SerialNumber;
end;

function TATE740X.getDateTime:String;
begin
  Result := GetActionResult(cmGetDateTime,rspDateTime,16);
end;

function TATE740X.getNumeric:String;
begin
  fReadings := GetActionResult(cmGetNumericValues,rspNumericValues,24);
  Result := fReadings;
end;

function TATE740X.getBatteryVoltage:String;
begin
  Result := GetActionResult(cmGetBatteryVoltage,rspBatteryVoltage,9);
end;

function TATE740X.getBatteryCharge:String;
begin
  Result := GetActionResult(cmGetBatteryCharge,rspBatteryCharge,7);
end;

function TATE740X.getPneumaticTestResults:TStringList;
var
  i: Integer;
begin
//  Result := nil;
  i := 0;
  fMeasurements.Clear;
  ComPort.CommandResults := '';
  if ComPort.Open then ComPort.Config;
  ComPort.Write(cmStartPneumaticTest+#13);
  while i < iLimit do
    begin
      inc(i);
      if ComPort.Read(8) then
        if (pos('X15', ComPort.CommandResults) = 1) then
          begin
            fMeasurements.Add(ComPort.CommandResults);
            i := 0;
            if (ComPort.CommandResults = 'X15PASS') or
               (ComPort.CommandResults = 'X15FAIL') then break;
          end;
    end;
  ComPort.Write(cmStopPneumaticTest);
  ComPort.Purge;
  ComPort.Close;
  Result := fMeasurements;
end;

function TATE740X.getMeasurements:TStringList;
var
  i: Integer;
begin
//  Result := nil;
  i := 0;
  fMeasurements.Clear;
  ComPort.CommandResults := '';
  if ComPort.Open then ComPort.Config;
  ComPort.Write(cmStartMeasurement+#13);
  while i < iLimit do
    begin
      inc(i);
      if ComPort.Read(7) then
        if (pos('X13', ComPort.CommandResults) = 1) then
          begin
            fMeasurements.Add(ComPort.CommandResults);
            i := 0;
          end;
    end;
  ComPort.Write(cmStopMeasurement);
  ComPort.Purge;
  ComPort.Close;
  Result := fMeasurements;
end;

function TATE740X.getSystolic:Integer;
begin
  try
    Result := StrToIntDef(copy(fReadings,4,3),-1);
  except
    Result := -1;
  end;
end;

function TATE740X.getDiastolic:Integer;
begin
  try
    Result := StrToIntDef(copy(fReadings,7,3),-1);
  except
    Result := -1;
  end;
end;

function TATE740X.getTemp: Real;
var
  s,ss: String;
begin
  try
    s := copy(fReadings,19,3);
    ss := copy(fReadings,22,1);
    if pos(ss,'0123456789') > 0 then
      s := s + ss;
    Result := StrToIntDef(s,-1) / 10.0;
  except
    Result := -1;
  end;
end;

function TATE740X.getMAP: Integer;
begin
  try
    Result := StrToIntDef(copy(fReadings,10,3),-1);
  except
    Result := -1;
  end;
end;

function TATE740X.getSpo2:Integer;
begin
  try
    Result := StrToIntDef(copy(fReadings,16,3),-1);
  except
    Result := -1;
  end;
end;

function TATE740X.getPulse:Integer;
begin
  try
    Result := StrToIntDef(copy(fReadings,13,3),-1);
  except
    Result := -1;
  end;
end;

function TATE740X.getTempUnits:String;
var
  s : String;
begin
  try
    s := copy(fReadings,22,1);
    if pos(s,'0123456789') > 0 then
      s := copy(fReadings,23,1);
    if (s<>'C') and (s<>'F') then s := '';
    Result := s;
  except
    Result := '';
  end;
end;

function TATE740X.getSBP:String;
var
  i: Integer;
  s: String;
begin
  Result := '';
  try
    s := copy(fReadings,4,3);
    while copy(s,1,1) = '0' do  s := Copy(s,2,length(s));
    i := StrToIntDef(s,-1);
    if i < 0 then Exit;
    Result := s + '/';
    s := copy(fReadings,7,3);
    while copy(s,1,1) = '0' do  s := Copy(s,2,length(s));
    i := StrToIntDef(s,-1);
    if i < 0 then
      begin
        Result := '';
        Exit;
      end;
    Result := Result + s;
  except
    Result := '';
  end;
end;

function TATE740X.getSTemp:String;
begin
  try
    if fTemp > 0 then
      Result := Format('%5.1f',[fTemp])
    else
      Result := '';
  except
    Result := '';
  end;
end;

function TATE740X.getSPulse:String;
begin
  try
    if iPulse < 0 then
      Result := ''
    else
      begin
        Result := copy(fReadings,13,3);
        Result := StripFirstChar('-',Result);
        Result := StripFirstChar(' ',Result);
        Result := StripFirstChar('0',Result);
      end;
  except
    Result := '';
  end;
end;

function TATE740X.getSSpO2:String;
begin
  try
    if iSpO2 < 0 then
      Result := ''
    else
      begin
        Result := copy(fReadings,16,3);
        Result := StripFirstChar('-',Result);
        Result := StripFirstChar('0',Result);
      end;
  except
    Result := '';
  end;
end;

procedure TATE740X.NewPatient;
begin
  getActionResult(cmNewPatient+#13,cmNewPatient+#13,Length(cmNewPatient+#13));
end;
(*
Initialization
  ComPort := TComPort.Create;

finalization
  ComPort.Free;
*)
end.

