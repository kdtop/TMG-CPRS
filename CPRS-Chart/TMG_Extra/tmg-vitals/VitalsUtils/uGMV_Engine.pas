unit uGMV_Engine;

interface

uses
{$IFDEF REDIRECTOR}
  uHEVDR_PCall
{$ELSE}
  fROR_PCall
{$ENDIF}
  , Classes
  , Dialogs  //kt added for debug dialogs
  , SysUtils
  , Trpcb
  ;
function getsTATIONInfo:String;
function getEXEInfo(anEXEName:String):String;
function getDLLInfo(anEXEName:String):String;
function getALLPatientData(aPatient,aFrom,aTo:String):TStringList;

// Date and Time
function getCurrentDateTime:String;          // uGMV_DateTime
function convertMDate(aValue:String):String; // uGMVMDateTime
function getServerWDateTime:TDateTime;
function getServerWDelay:TDateTime;
function getServerWDateTimeString:String;

function getUserParameter:String; // uGMV_User
function getUserSignOnInfo:TStringList;
function getUserSettings(aName:String):String;
function setUserSettings(aName,aValue:String):String;
function getUserDUZString:String;

// System parameters
function getSystemParameterByName(aName:String):String; // fGMV_Manager
function getWebLinkAddress:String;

// Qualifiers
function getVitalQualifierList(aVital:String):TStringList;  // fGMV_Qualifiers
function getQualifiers(aVital,aCategory:String):TStringList; // uGMV_QualifyBox
function getCategoryQualifiers(aVital:String):TStringList; // mGMV_EditTemplate

function addQualifier(aVitalID,aCategoryID,aQualifierID:String):String;
function delQualifier(aVitalID,aCategoryID,aQualifierID:String):String;
function addNewQualifier(aName:String):String;

function validateQualifierName(aFDD,aIEN,aField,aName:String):String;
function setQualifierName(aFDD,aIEN,aField,aName:String):String;

//Patients
{$IFNDEF DLL}
function getPatientList(aTarget:String): TStringList;
{$ENDIF}
// Files and Fields
function getFileEntries(aFile:String):TStringList;  // uGMV_FileEntry
function getFileField(aFile,aField,anIEN:String): String;

// Vitals
function getVitalsIDList:TStringList;

function getVitalTypeIEN(aVital:String):String; // fGMV_SupO2
function getVitalCategoryIEN(aCategory:String):String;

function getTemplateList:TStringList; // fGMV_InputTemp
function addVM(aValue:String):String;

function getPatientInfo(aPatient:String):TStringList;
function getPatientHeader(aPatient:String):TStringList;
procedure logPatientAccess(aPatient:String);// fGMV_PtSelect

function getNursingUnitPatients(aUnit:String):TStringList; // mGMV_PtLookup
function getWardPatients(aWard:String):TStringList;
function getTeamPatients(aTeam:String):TStringList;
function getClinicPatients(aClinic,aDate:String):TStringList;

function getLookupEntries(aFile,aTarget:String):TStringList;// mGMV_Lookup

function newTemplate(aCategory,aName,aValue:String):String;

procedure setTemplate(anID,aName,aValue:String);
function renameTemplate(anID,aName,aNewName:String):String;
function getTemplateValue(anID,aName:String):String;
function setDefaultTemplate(anID,aName:String):String;
function getDefaultTemplateByID(anID:String):String;
function getDefaultTemplateList:TStringList;
function getTemplateListByID(anID:String):TStringList;
function createUserTemplateByName(aName:String):String;
function deleteUserTemplate(aName:String):String;

function deleteTemplate(aCategory,aName:String):String;

function createContext(aContext:String):Boolean;  // uGMV_User
function EngineReady:Boolean;

function getLatestVitalsByDFN(aDFN:String;aSilent:Boolean):TStringList;
function getHospitalLocationByID(anID:String):String;
function getWardLocations:TStringList;
function getRoomBedByWard(aWard:String):TStringList;

function getProcedureResult(aProc,aParam:String):String;
function getGMVRecord(aParam:String):TStringList;
function setGMVErrorRecord(aParam:String):TStringList;

function getPatientINQInfo(aINQ,aDFN:String):TStringList;         // ?????
function getPatientAllergies(aDFN:String):TStringList;

//// Manager ///////////////////////////////////////////////////////////////////
//
// Manager calls are not used in the DLL
// so we will include them in this module later some time...
//
function printQualifierTable(aX,aY:String):String;
function getGUIVersionList:TStringList;
function setSystemParameter(aName,aValue,anOption:String):String;

function getVitalHiLo(aVitalType:String):String;
function setVitalHiLo(aVitalType,aValue:String):String;

function getDeviceList(aTarget,aMargin:String;Direction:Integer=1):String;

function getLocationsByName(aTarget:String):String;
function getLocationsByAppt(aDFN,aFrom,aTo,aFlag:String):String;
function getLocationsByAdmit(aDFN:String):String;

function SubSetOfFile(const StartFrom: string; Direction: Integer): TStrings;
const
//  RPC_ICN_TO_DFN = 'VAFCTFU CONVERT ICN TO DFN';
//  RPC_DFN_TO_ICN = 'VAFCTFU CONVERT DFN TO ICN';

  RPC_PATIENT_ALLERGIES =       'GMV ALLERGY';
  RPC_CLINIC_PATIENTS =         'GMV CLINIC PT';
  RPC_DATE_CONVERT =            'GMV CONVERT DATE';
  RPC_CurrentTime =             'GMV GET CURRENT TIME';  // 1
  RPC_PARAMETER =               'GMV PARAMETER';
  RPC_MANAGER =                 'GMV MANAGER';
  RPC_CREATECONTEXT =           'GMV V/M GUI';
  RPC_PATIENT_VITALS_ALL =      'GMV V/M ALLDATA';
  RPC_VITALS_QUALIFIERS =       'GMV VITALS/CAT/QUAL';   // 2
  RPC_PATIENT_LATEST_VITALS =   'GMV LATEST VM';         // ?

  RPC_PATIENT_SELECT =          'GMV PTSELECT';

  RPC_VITAL_TYPE_IEN =          'GMV GET VITAL TYPE IEN';   // 3
  RPC_VITAL_CATEGORY_IEN =      'GMV GET CATEGORY IEN';
  RPC_VITAL_ADD_VALUE =         'GMV ADD VM';
  RPC_NUR_UNIT_PATIENTS =       'GMV NUR UNIT PT';
  RPC_TEAM_PATIENTS =           'GMV TEAM PATIENTS';
  RPC_WARD_LOCATION =           'GMV WARD LOCATION';
  RPC_ROOM_BED =                'GMV ROOM/BED';

  RPC_GMV_RECORD =              'GMV EXTRACT REC';// entered in error
  RPC_GMV_MARK_ERROR =          'GMV MARK ERROR';

  RPC_USER =                    'GMV USER';         // 4
  RPC_WARD_PATIENTS =           'GMV WARD PT';

  RPC_QUALIFIER_TABLE =         'GMV QUALIFIER TABLE';

  RPC_PATIENTINFO =             'ORWPT PTINQ';

  RPC_DLL_VERSION =             'GMV DLL VERSION';

  RPC_CHECK_DEVICE =            'GMV CHECK DEVICE';

  RPC_LOCATION_SELECT =         'GMV LOCATION SELECT';

var
  ServerDelay:TDateTime;
  CheckBrokerFlag: Boolean;

implementation

uses uGMV_Common, uGMV_Const;


function  CallRPC(RemoteProcedure: String;
            Parameters: array of String; MultList: TStringList = nil;
            RPCMode: TRPCMode = []; RetList: TStrings = nil ): Boolean;
begin
   Result :=
    CallRemoteProc(
      RPCBroker,
      RemoteProcedure,Parameters,MultList,RPCMode,RetList);
end;

////////////////////////////////////////////////////////////////////////////////

function SubSetOfFile(const StartFrom: string;Direction: Integer): TStrings;

  { returns a pointer to a list of file entries (for use in a long list box) -
    The return value is a pointer to RPCBrokerV.Results, so the data must
    be used BEFORE the next broker call! }
  var
    RPCResult : Tstrings;
  begin
    //RPCResult := TStringList.Create;
    //CallRPC('ORWU1 NEWLOC', [StartFrom, '1'], nil, [rpcSilent],RPCResult);
    //Result := RPCBroker.Results;
     // NewLoc in ORWU1 only has C and Z     HOSPLOC IS SUPPOSED TO BE ALL
    RPCBroker.remoteprocedure := 'ORWU HOSPLOC';
    RPCBroker.Param[0].Value := StartFrom;
    RPCBroker.param[0].ptype := literal;
    RPCBroker.Param[1].Value := inttostr(Direction);
    RPCBroker.param[1].ptype := literal;
    //cmd := 'FILE ENTRY SUBSET';
    //cmd := cmd + '^' + FileNum + '^' + StartFrom + '^' + IntToStr(Direction);
    //RPCBroker.Param[0].Mult['"REQUEST"'] := cmd;
    RPCBroker.Call;
    //RPCResult := RPCBroker.Results[0];    //returns:  error: -1;  success=1
    //if piece(RPCResult,'^',1)='-1' then begin
     // handle error...
    //end else begin
    //  RPCBroker.Results.Delete(0);
    //end;
    //messagedlg(RPCBROKER.Results[0],mtInformation ,mbOKCancel,0);
    //messagedlg(RPCBROKER.Results[1],mtInformation ,mbOKCancel,0);
    Result := RPCBroker.Results;         
  end;

function getRPCResultStringList(aProcedure:String;ParamLST: array of String;
            RPCMode: TRPCMode = []):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(aProcedure,ParamLST,nil,RPCMode,SL);
  Result := SL;
end;

function getRPCResultString(aProcedure:String;ParamLST: array of String;
            RPCMode: TRPCMode = []):String;
var
  SL : TStringList;
begin
  try
    SL := getRPCResultStringList(aProcedure,ParamLST,RPCMode);
    Result := SL.Text;
  except
    Result := '-1^Error';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//  The next RPC is used to retrieve Patient information.
//  It is used only once in module fGMV_PtInfo (see line 51).
//  By default aINQ is equal to RPC_PATIENTINFO = 'ORWPT PTINQ';
//  the user settings could overwrite the default value.
////////////////////////////////////////////////////////////////////////////////

function getPatientINQInfo(aINQ,aDFN:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(aINQ, [aDFN], nil, [rpcSilent,rpcNoResChk], SL);
  Result := SL;
end;

(*
function getProcedureResultList(aProc,aParam:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(aProc, [aParam], nil,[rpcNoResChk,rpcSilent],SL);
  Result := SL;
end;
*)

function getGMVRecord(aParam:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_GMV_RECORD, [aParam], nil,[rpcNoResChk,rpcSilent],SL);
  Result := SL;
end;

function setGMVErrorRecord(aParam:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_GMV_MARK_ERROR, [aParam], nil,[rpcNoResChk,rpcSilent],SL);
  Result := SL;
end;

//==============================================================================

function getGUIVersionList:TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//    CallRemoteProc(Broker, RPC_PARAMETER, ['GETLST', 'SYS', 'GMV GUI VERSION'], nil,[rpcSilent,rpcNoResChk], lstVersions);
  CallRPC(RPC_PARAMETER, ['GETLST', 'SYS', 'GMV GUI VERSION'], nil,[rpcSilent,rpcNoResChk], SL);
  Result := SL;
end;

function getEXEInfo(anEXEName:String):String;
begin
//  CallRemoteProc(RPCBroker, RPC_PARAMETER, ['GETPAR', 'SYS', 'GMV GUI VERSION', CurrentExeNameAndVersion], nil);
//  Result := (Pos('Y', RPCBroker.Results[0]) > 0);

  CallRPC(RPC_PARAMETER, ['GETPAR', 'SYS', 'GMV GUI VERSION', anExeName], nil);
  Result := RPCBroker.Results[0];
end;

function getDLLInfo(anEXEName:String):String;
begin
  CallRPC(RPC_DLL_VERSION, [anExeName], nil);
  Result := RPCBroker.Results[0];
end;

function getALLPatientData(aPatient,aFrom,aTo:String):TStringList;
var
  i: Integer;
  SL: TStringList;
begin
  SL := TStringList.Create;

  CallRPC(RPC_PATIENT_VITALS_ALL,  [aPatient + '^' + aFrom + '^' + aTo + '^0'], nil, []);
  if RPCBroker.Results.Count > 4 then
    for i := RPCBroker.Results.Count - 1 downto 4 do
    begin
      SL.Add(RPCBroker.Results[i]);
      //messagedlg('Here are the RPC Results ' + RPCBroker.Results[i],mtInformation ,mbOKCancel,0);
    end;
  Result := SL;
end;

function getCurrentDateTime:String;
begin
   // TEST FOR PARAMETERS
//  if CallRPC(RPC_CurrentTime, [], nil,[rpcSilent,rpcNoResChk]) then
  if CallRPC(RPC_CurrentTime, ['1'], nil,[rpcSilent,rpcNoResChk]) then // dummy parameter
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;

function convertMDate(aValue:String):String;
begin
  if CallRPC(RPC_DATE_CONVERT, [aValue], nil, []) and
    (RPCBroker.Results.Count > 0) then
    Result := Piece(RPCBroker.Results[0], '^', 1)
  else
    Result := '';
end;

function getsTATIONInfo:String;
var
  s:String;
begin
  s := '';
  if CallRPC(RPC_PATIENT_SELECT,['CCOW'],nil,[]) then
    s := RPCBroker.Results[0];
  Result := s;
end;

function getPatientList(aTarget:String): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//  CallRPC('GMV PTSELECT', ['PTLKUP', '', aTarget], nil, [rpcSilent,rpcNoResChk], SL);
  CallRPC(RPC_PATIENT_SELECT, ['PTLKUP', '', aTarget], nil, [rpcSilent,rpcNoResChk], SL);
  Result := SL;
end;

procedure logPatientAccess(aPatient:String);
begin
//  CallRPC('GMV PTSELECT', ['LOGSECURITY', aPatient, 'RPCCALL^Clinical Procedure GUI v1'],
  CallRPC(RPC_PATIENT_SELECT, ['LOGSECURITY', aPatient, 'RPCCALL^Clinical Procedure GUI v1'],
   nil,[rpcSilent,rpcNoResChk]);
end;

function getPatientInfo(aPatient:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//  CallRPC('GMV PTSELECT', ['SELECT', aPatient], nil,[],SL);
  CallRPC(RPC_PATIENT_SELECT, ['SELECT', aPatient], nil,[rpcSilent,rpcNoresChk],SL);
  Result := SL;
end;

function getPatientHeader(aPatient:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//  CallRPC('GMV PTSELECT', ['PTHDR', aPatient], nil,[],SL);
  CallRPC(RPC_PATIENT_SELECT, ['PTHDR', aPatient], nil,[rpcSilent,rpcNoresChk],SL);
  Result := SL;
end;

function getServerWDateTime:TDateTime;
begin
  try
    Result := FMDateTimeToWindowsDateTime(StrToFloat(getCurrentDateTime));
  except
  on E: Exception do
    Result := 0;
  end;
end;

function getServerWDateTimeString:String;
begin
  try
    Result := FormatDateTime(GMV_DateTimeFormat,FMDateTimeToWindowsDateTime(StrToFloat(getCurrentDateTime)));
  except
  on E: Exception do
    Result := '';
  end;
end;

function getServerWDelay:TDateTime;
begin
  Result := getServerWDateTime - Now;
end;
////////////////////////////////////////////////////////////////////////////////
// System Parameters
////////////////////////////////////////////////////////////////////////////////
function getSystemParameterByName(aName:String):String; // fGMV_Manager
begin
  if CallRPC(RPC_PARAMETER, ['GETPAR', 'SYS', aName], nil,[rpcSilent,rpcNoResChk]) then
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;

function getWebLinkAddress:String;
begin
  Result := getSystemParameterByName('GMV WEBLINK');
end;

function setSystemParameter(aName,aValue,anOption:String):String;
begin
//      CallRemoteProc(Broker, RPC_PARAMETER, ['SETPAR', 'SYS', 'GMV GUI VERSION', clbxVersions.Items[i], '1'], nil)
  CallRPC(RPC_PARAMETER,['SETPAR','SYS',aName,aValue,anOption],nil,[]);
  Result := RPCBroker.Results[0];
end;

function getUserParameter:String; // uGMV_User
begin
  if CallRPC(RPC_PARAMETER, ['GETPAR', 'SYS', 'GMV ALLOW USER TEMPLATES'], nil, [], nil) then
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;

function getUserSignOnInfo:TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_USER, ['SIGNON', ''], nil,[rpcSilent,rpcNoResChk],SL);
  Result := SL;
end;

function getUserDUZString:String;
var
  SL: TStringList;
begin
  SL := getUserSignOnInfo;
  if SL.Count > 0 then
    Result := SL[0]
  else
    Result := '';
  SL.Free;
end;

function getUserSettings(aName:String):String;
begin
  try
    if CallRPC(RPC_USER, ['GETPAR', aName],nil,[rpcSilent,rpcNoResChk]) then
      Result := RPCBroker.Results[0]
    else
      Result := '';
  except
    on E: Exception do
      Result := '';
  end;
end;

function setUserSettings(aName,aValue:String):String;
begin
  if CallRPC(RPC_USER, ['SETPAR', aName + '^' + aValue],nil,[rpcSilent,rpcNoResChk]) then
    Result := RPCBroker.Results[0]
  else
    Result := '-1^Unknown Error';
end;

function getVitalQualifierList(aVital:String):TStringList;
var
  SL: TStringList;
begin
  // ?
  SL := TStringList.Create;
  CallRPC(RPC_VITALS_QUALIFIERS, [aVital], nil,[rpcSilent,rpcNoResChk],SL);
  Result := SL
end;

function getQualifiers(aVital,aCategory:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['GETQUAL', aVital + ';' + aCategory], nil,[], SL);
  Result := SL;
end;

function getCategoryQualifiers(aVital:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['GETCATS', aVital], nil,[rpcSilent,rpcNoResChk], SL);
  Result := SL;
end;

function getFileEntries(aFile:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['GETLIST', aFile], nil,[], SL);
  Result := SL;
end;

function getFileField(aFile,aField,anIEN:String): String;
begin
  if CallRPC(RPC_MANAGER, ['GETDATA', aFile + '^' + anIEN + '^' + aField], nil,[rpcSilent,rpcNoResChk],nil) then
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;

function getLookupEntries(aFile,aTarget:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['LOOKUP', aFile + '^' + aTarget], nil,[rpcSilent,rpcNoResChk], SL);
  Result := SL;
end;

function getVitalsIDList:TStringList;
var
  SL: TStringList;
  i : integer; //kt
begin
  SL := TStringList.Create;
  //messagedlg('In getVitalsIDList.uGMV_Engine, Calling RPC '+ RPC_MANAGER,mtInformation,[mbOK],0);  //kt
  CallRPC(RPC_MANAGER, ['VT', ''],nil,[rpcNoResChk],SL);
  Result := SL;
  //for i := 0 to SL.Count-1 do begin  //kt
    //messagedlg(IntToStr(i)+'/'+InttoStr(SL.Count)+': '+SL.Strings[i],mtInformation,[mbOK],0);  //kt
  //end;
end;


function getVitalTypeIEN(aVital:String):String;
begin
 // ?
//  if CallRPC('GMV GET VITAL TYPE IEN',[aVital], nil,[],nil) then
  if CallRPC(RPC_VITAL_TYPE_IEN,[aVital], nil,[rpcSilent,rpcNoResChk],nil) then
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;

function getVitalCategoryIEN(aCategory:String):String;
begin
//  if CallRPC('GMV GET CATEGORY IEN',[aCategory], nil,[],nil) then
  if CallRPC(RPC_VITAL_CATEGORY_IEN,[aCategory], nil,[],nil) then
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;


function getTemplateList:TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['GETTEMP'], nil, [rpcSilent,rpcNoresChk],SL);
  Result := SL;
end;

function addVM(aValue:String):String;
begin
//  if CallRPC('GMV ADD VM', [aValue], nil,[rpcSilent,rpcNoresChk]) then
  //messagedlg('Going to Server ' + aValue,mtWarning ,mbOKCancel ,0);
  if CallRPC(RPC_VITAL_ADD_VALUE, [aValue], nil,[rpcSilent,rpcNoresChk]) then
    Result := ''
  else
    Result := RPCBroker.Results.Text;
  //messagedlg('Result ' + Result,mtWarning ,mbOKCancel ,0);
end;

function getNursingUnitPatients(aUnit:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//  CallRPC('GMV NUR UNIT PT', [aUnit], nil, [rpcNoResChk,rpcSilent],SL);
  CallRPC(RPC_NUR_UNIT_PATIENTS, [aUnit], nil, [rpcNoResChk,rpcSilent],SL);
  Result := SL;
end;

function getWardPatients(aWard:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//  CallRPC('GMV WARD PT', [aWard], nil, [rpcNoResChk,rpcSilent], SL);
  CallRPC(RPC_WARD_PATIENTS, [aWard], nil, [rpcNoResChk,rpcSilent], SL);
  Result := SL;
end;

function getTeamPatients(aTeam:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//  CallRPC('GMV TEAM PATIENTS', [aTeam], nil, [rpcNoResChk,rpcSilent],SL);
  CallRPC(RPC_TEAM_PATIENTS, [aTeam], nil, [rpcNoResChk,rpcSilent],SL);
  Result := SL;
end;

function getClinicPatients(aClinic,aDate:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//  CallRPC('GMV CLINIC PT', [aClinic,aDate], nil, [rpcNoResChk,rpcSilent], SL);
  CallRPC(RPC_CLINIC_PATIENTS, [aClinic,aDate], nil, [rpcNoResChk,rpcSilent], SL);
  Result := SL;
end;

//==============================================================================

function newTemplate(aCategory,aName,aValue:String):String;
begin
(*  CallREMOTEProc(Broker,
          RPC_MANAGER,
          ['NEWTEMP', Entity + '^' + edtTemplateName.Text + '^' + edtTemplateDescription.Text],
          nil);
*)
  CallRPC(RPC_MANAGER, ['NEWTEMP', aCategory + '^' + aName + '^' + aValue], nil, []);
  Result := RPCBroker.Results[0]
end;

procedure setTemplate(anID,aName,aValue:String);
begin
  CallRPC(RPC_MANAGER, ['SETTEMP', anID + '^' + aName + '^' + aValue], nil, []);
end;

function renameTemplate(anID,aName,aNewName:String):String;
begin
  CallRPC(RPC_MANAGER, ['RENTEMP', anID + '^' + aName + '^' + aNewname], nil,[rpcNoResChk,rpcSilent]);  //vhaishandria 051229
  Result := RPCBroker.Results[0];
end;

function getTemplateValue(anID,aName:String):String;
begin
  try
//    if CallREmoteProc(RPCBroker, RPC_MANAGER, ['GETTEMP', anID + '^' + aName], nil,[]) then
    if CallRPC(RPC_MANAGER, ['GETTEMP', anID + '^' + aName], nil,[]) then begin
      Result := RPCBroker.Results[1];
      //messagedlg('In TfrmGMV_Engine.GetTemplateValue.  RPC result='+Result,mtInformation,[mbOK],0);  //kt
    end else begin
      Result := '';
    end;
  except
      Result := '';
  end;
end;

function setDefaultTemplate(anID,aName:String):String;
begin
  if CallRPC(RPC_MANAGER, ['SETDEF', anID + '^' + aName], nil,[]) then
    Result :=RPCBroker.Results[0]
  else
    Result := '-1';
end;

function getDefaultTemplateByID(anID:String):String;
begin
  try
    if CallRPC(RPC_MANAGER, ['GETDEF', anID], nil,[]) then
      Result := RPCBroker.Results[0]
    else
      Result := '-1';
  except
    Result := '-1';
  end;
end;

function getDefaultTemplateList:TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['GETDEF'], nil,[rpcNoResChk,rpcSilent], SL);
  Result := SL;
end;

function getTemplateListByID(anID:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  if anID <> '' then
    CallRPC(RPC_MANAGER, ['GETTEMP', anID], nil,[],SL)
  else
    CallRPC(RPC_MANAGER, ['GETTEMP'], nil, [],SL);
  Result := SL;
end;



function createUserTemplateByName(aName:String):String;
begin
  try
    if CallRPC(RPC_MANAGER, ['NEWTEMP', 'USR^' + aName + '^No Description'], nil,[]) then
      Result := RPCBroker.Results[0]
    else
      Result := '-1';
  except
      Result := '-1';
  end;
end;

function deleteTemplate(aCategory,aName:String):String;
begin
  try
    if CallRPC(RPC_MANAGER, ['DELTEMP', aCategory+'^' + aName], nil,[]) then
      Result := RPCBroker.Results[0]
    else
      Result := '-1^Unknown Error';
  except
      Result := '-1^Unknown Error';
  end;
end;

function deleteUserTemplate(aName:String):String;
begin
{
  try
    if CallRPC(RPC_MANAGER, ['DELTEMP', 'USR^' + aName], nil,[]) then
      Result := RPCBroker.Results[0]
    else
      Result := '-1^Unknown Error';
  except
      Result := '-1^Unknown Error';
  end;
}
  Result := deleteTemplate('USR',aName);
end;

////////////////////////////////////////////////////////////////////////////////

function createContext(aContext:String):Boolean;
begin
  Result := RPCBroker.CreateContext(aContext);
end;

function EngineReady:Boolean;
begin
  Result := Assigned(RPCBroker);
end;

function getLatestVitalsByDFN(aDFN:String;aSilent:Boolean):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    if aSilent then
      CallRPC(RPC_PATIENT_LATEST_VITALS, [aDFN], nil, [rpcNoResChk,rpcSilent], SL)
    else
//      CallRPC('GMV LATEST VM', [aDFN], nil, [], SL);
      CallRPC(RPC_PATIENT_LATEST_VITALS, [aDFN], nil, [], SL);
  except
  end;
  Result := SL;
end;

function getHospitalLocationByID(anID:String):String;
begin
  try
    if CallRPC(RPC_PATIENT_SELECT, ['HOSPLOC', anID],nil,[rpcNoResChk,rpcSilent]) then
      Result := RPCBroker.Results[0]
    else
      Result := '';
  except
      Result := '';
  end;
end;

function getWardLocations:TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//  CallRPC('GMV WARD LOCATION', [], nil,[],SL);
  CallRPC(RPC_WARD_LOCATION, [], nil,[],SL);
  Result := SL;
end;

function getRoomBedByWard(aWard:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//  CallRPC('GMV ROOM/BED', [aWard], nil, [], SL);
  CallRPC(RPC_ROOM_BED, [aWard], nil, [], SL);
  Result := SL;
end;

function getProcedureResult(aProc,aParam:String):String;
begin
  try
    if CallRPC(aProc, [aParam], nil,[rpcNoResChk,rpcSilent]) then
      Result := RPCBroker.Results[0]
    else
      Result := 'Procedure '+aProc+'('+aParam+') Failed';
  except
      Result := 'Procedure '+aProc+'('+aParam+') Failed';
  end;
end;

function getPatientAllergies(aDFN:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
//  CallRPC('GMV ALLERGY', [aDFN], nil, [], SL);
  CallRPC(RPC_PATIENT_ALLERGIES, [aDFN], nil, [], SL);
  Result := SL;
end;


////////////////////////////////////////////////////////////////////////////////

//      CallRemoteProc(RPCBroker, 'GMV QUALIFIER TABLE', ['^^^^' + x + '^^' + FloatToStr(y)], nil);
function printQualifierTable(aX,aY:String):String;
begin
  CallRPC(RPC_QUALIFIER_TABLE, ['^^^^' + aX + '^^' + aY], nil);
  Result := RPCBroker.Results[0]
end;


function addQualifier(aVitalID,aCategoryID,aQualifierID:String):String;
begin
//    CallREmoteProc(RPCBroker,
//      RPC_MANAGER,['ADDQUAL', VitalIEN + ';' + CategoryIEN + ';' + QualifierIEN], nil)
  CallRPC(RPC_MANAGER,['ADDQUAL', aVitalID + ';' + aCategoryID + ';' + aQualifierID], nil);
  Result := RPCBroker.Results[0]
end;

function delQualifier(aVitalID,aCategoryID,aQualifierID:String):String;
begin
//    CallRemoteProc(RPCBroker,
//      RPC_MANAGER, ['DELQUAL', VitalIEN + ';' + CategoryIEN + ';' + QualifierIEN], nil);
  CallRPC(RPC_MANAGER,['DELQUAL', aVitalID + ';' + aCategoryID + ';' + aQualifierID], nil);
  Result := RPCBroker.Results[0]
end;

function AddNewQualifier(aName:String):String;
begin
//  CallRemoteProc(Broker, RPC_MANAGER, ['NEWQUAL', NewQualifier], nil);
  CallRPC(RPC_MANAGER, ['NEWQUAL', aName], nil);
  Result := RPCBroker.Results[0]
end;

function validateQualifierName(aFDD,aIEN,aField,aName:String):String;
begin
//      CallREmoteProc(RPCBroker,RPC_MANAGER,['VALID', FDD + '^' + FIENS + '^.01^' + edtName.text],    nil);
  CallRPC(RPC_MANAGER,['VALID', aFDD + '^' + aIEN + '^'+ aField + '^' + aName], nil,[]);
  Result := RPCBroker.Results[0];
end;


function setQualifierName(aFDD,aIEN,aField,aName:String):String;
begin
//  CallREmoteProc(RPCBroker,RPC_MANAGER,['SETDATA', FDD + '^' + FIENS + '^.01^' + edtName.text], nil);
  CallRPC(RPC_MANAGER,['SETDATA', aFDD + '^' + aIEN + '^'+ aField + '^' + aName], nil,[]);
  Result := RPCBroker.Results[0];
end;

function getVitalHiLo(aVitalType:String):String;
begin
//  CallRemoteProc(RPCBroker,RPC_MANAGER,['GETHILO', GMVVitalHiLoFields[FVitalType, FHighLow]],nil);
  CallRPC(RPC_MANAGER,['GETHILO', aVitalType],nil,[]);
  Result := RPCBroker.Results[0];
end;

function setVitalHiLo(aVitalType,aValue:String):String;
begin
//CallRemoteProc(RPCBroker, RPC_MANAGER,['SETHILO', GMVVitalHiLoFields[FVitalType, FHighLow] + '^' + edtValue.Text],nil);
  CallRPC(RPC_MANAGER,['SETHILO', aVitalType+'^'+aValue],nil,[]);
  Result := RPCBroker.Results[0];
end;

function getDeviceList(aTarget,aMargin:String;Direction:Integer=1):String;
begin
  CallRPC(RPC_CHECK_DEVICE,[aTarget, IntToStr(Direction),aMargin],nil,[rpcNoResChk,rpcSilent]);
  Result := RPCBroker.Results.Text;
end;

function getLocationsByName(aTarget:String):String;
{
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['LOOKUP', aFile + '^' + aTarget], nil,[rpcSilent,rpcNoResChk], SL);
  Result := SL;
}
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_LOCATION_SELECT,['NAME',aTarget],nil,[rpcNoResChk,rpcSilent],SL);
  Result := SL.Text;
  SL.Free;
end;

function getLocationsByAppt(aDFN,aFrom,aTo,aFlag:String):String;
begin
  CallRPC(RPC_LOCATION_SELECT,['APPT',aDFN+'^'+aFrom+'^'+aTo+'^'+aFlag],nil,[rpcNoResChk,rpcSilent]);
  Result := RPCBroker.Results.Text;
end;

function getLocationsByAdmit(aDFN:String):String;
begin
  CallRPC(RPC_LOCATION_SELECT,['ADMIT',aDFN],nil,[rpcNoResChk,rpcSilent]);
  Result := RPCBroker.Results.Text;
end;

begin
  CheckBrokerFlag := False;
end.


