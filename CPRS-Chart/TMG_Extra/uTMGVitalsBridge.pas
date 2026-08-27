unit uTMGVitalsBridge;  //kt //codex 8/26/26

interface

uses
  System.UITypes,  //kt //codex 8/26/26
  Classes,  //kt //codex 8/26/26
  TRPCB;  //kt //codex 8/26/26

function TMG_VitalsViewDLG(const AVitalType: string): Integer;  //kt //codex 8/26/26
//kt //codex added entire function 8/26/26

function TMG_VitalsEnterDLG(
  const ABroker: TRPCBroker;
  const APatient,
  ALocation,
  ATemplate,
  ASignature: string;
  const ADateTime: TDateTime;
  const APatientName,
  APatientInfo: string): Integer;
//kt //codex added entire function 8/26/26

function TMG_LatestVitalsList(
  const ABroker: TRPCBroker;
  const APatient,
  ADelim: string;
  const ASilent: Boolean): TStringList;
//kt //codex added entire function 8/26/26

implementation

uses
  SysUtils,
  Dialogs,
  Forms,
  ORFn,  //kt //codex 8/26/26
  ORNet,  //kt //codex 8/26/26
  CCOWRPCBroker,
  uCore,  //kt //codex 8/26/26
  fFrame,  //kt //codex 8/26/26
  uVitals,  //kt //codex 8/26/26
  fPatientVitals,  //kt //codex 8/26/26
  fGMV_InputLite,
  fROR_PCall,
  uGMV_Engine;

procedure InitVitalsBroker(const ABroker: TRPCBroker);
//kt //codex added entire procedure 8/26/26
begin
  if not Assigned(ABroker) then
    raise Exception.Create('Vitals bridge requires a broker instance.');
  if not (ABroker is TCCOWRPCBroker) then
    raise Exception.Create('Vitals bridge requires a TCCOWRPCBroker instance.');

  RPCBroker := TCCOWRPCBroker(ABroker);
  RPCBroker.ClearParameters := True;
  RPCBroker.ClearResults := True;
end;

function TMG_VitalsViewDLG(const AVitalType: string): Integer;
//kt //codex added entire function 8/26/26
var
  ADFN,
  ALocation,
  ADateStart,
  ADateStop,
  AInfo,
  AName,
  AHospitalName: string;  //kt //codex 8/26/26
begin
  Result := -1;
  InitVitalsBroker(RPCBrokerV);  //kt //codex 8/26/26
  CheckBrokerFlag := getSystemParameterByName('CHECKBROKERSTATUS') = 'TRUE';  //kt //codex 8/26/26

  if not CreateContext(GMV_CONTEXT) then
  begin
    MessageDLG('You do not have the <' + GMV_CONTEXT + '> options' + sLineBreak +
      'Please contact IRMS', mtError, [mbOK], 0);
    Exit;
  end;

  if (Patient = nil) or (Encounter = nil) then
    Exit;

  ADFN := Patient.DFN;
  ALocation := IntToStr(Encounter.Location);
  if Patient.Inpatient then
    ADateStart := FormatDateTime('mm/dd/yy', Now - 7)
  else
    ADateStart := FormatDateTime('mm/dd/yy', IncMonth(Now, -6));
  ADateStop := FormatDateTime('mm/dd/yy', Now);
  AName := Patient.Name;
  AInfo := frmFrame.lblPtSSN.Caption + '    ' + frmFrame.lblPtAge.Caption;
  AHospitalName := Encounter.LocationName + U + AVitalType;

  Result := ProcessInPatientVitals(
    ADFN,
    ALocation,
    ADateStart,
    ADateStop,
    GMV_APP_SIGNATURE,
    AName,
    AInfo,
    AHospitalName);

  if not RPCBrokerV.CreateContext(GMV_CONTEXT) then
  begin
    MessageDLG('You do not have the <' + GMV_CONTEXT + '> options' + sLineBreak +
      'Please contact IRMS', mtError, [mbOK], 0);
    Result := -2;
  end;
end;

function TMG_VitalsEnterDLG(
  const ABroker: TRPCBroker;
  const APatient,
  ALocation,
  ATemplate,
  ASignature: string;
  const ADateTime: TDateTime;
  const APatientName,
  APatientInfo: string): Integer;
//kt //codex added entire function 8/26/26
begin
  Result := -1;
  CheckBrokerFlag := getSystemParameterByName('CHECKBROKERSTATUS') = 'TRUE';  //kt //codex 8/26/26

  if ALocation = '' then
  begin
    MessageDLG('Unknown patient location.' + sLineBreak +
      'Please select location prior to entering Vitals', mtError, [mbOK], 0);
    Exit;
  end;

  InitVitalsBroker(ABroker);

  try
    Result := VitalsInputDLG(
      APatient,
      ALocation,
      ATemplate,
      ASignature,
      ADateTime,
      APatientName,
      APatientInfo);
  except
    on E: Exception do
      MessageDlg('Unable to open the vitals entry dialog.' + sLineBreak +
        E.Message, mtError, [mbOK], 0);
  end;
end;

function TMG_LatestVitalsList(
  const ABroker: TRPCBroker;
  const APatient,
  ADelim: string;
  const ASilent: Boolean): TStringList;
//kt //codex added entire function 8/26/26
var
  BParams: Boolean;
  BResults: Boolean;
begin
  if not Assigned(ABroker) then
    raise Exception.Create('Vitals bridge requires a broker instance.');

  BParams := ABroker.ClearParameters;
  BResults := ABroker.ClearResults;
  try
    InitVitalsBroker(ABroker);
    CheckBrokerFlag := getSystemParameterByName('CHECKBROKERSTATUS') = 'TRUE';  //kt //codex 8/26/26
    Result := GetLatestVitals(APatient, ADelim, ASilent);  //kt //codex 8/26/26
  finally
    ABroker.ClearParameters := BParams;
    ABroker.ClearResults := BResults;
  end;
end;

end.
