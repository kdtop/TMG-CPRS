unit rLabs;

interface

uses SysUtils, Classes, ORNet, ORFn,
      TRPCB  //kt 2/17
      ,Dialogs   //kt   4/20/17
      ;

type

  TLabPatchInstalled = record
    PatchInstalled: boolean;
    PatchChecked: boolean;
  end;


function AtomicTests(const StartFrom: string; Direction: Integer): TStrings;
function Specimens(const StartFrom: string; Direction: Integer): TStrings;
function AllTests(const StartFrom: string; Direction: Integer): TStrings;
function ChemTest(const StartFrom: string; Direction: Integer): TStrings;
function Users(const StartFrom: string; Direction: Integer): TStrings;
function TestGroups(user: int64): TStrings;
function ATest(test: integer): TStrings;
function ATestGroup(testgroup: Integer; user: int64): TStrings;
procedure UTGAdd(tests: TStrings);
procedure UTGReplace(tests: TStrings; testgroup: integer);
procedure UTGDelete(testgroup: integer);
procedure SpecimenDefaults(var blood, urine, serum, plasma: string);
procedure Cumulative(Dest: TStrings; const PatientDFN: string;
  daysback: integer; ADate1, ADate2: TFMDateTime; ARpc: string);
procedure RemoteLabCumulative(Dest: TStrings; const PatientDFN: string;
  daysback: integer; ADate1, ADate2: TFMDateTime; ASite, ARemoteRPC: String);
procedure Interim(Dest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime; ARpc: string);  //*DFN*
procedure RemoteLabInterim(Dest: TStrings; const PatientDFN: string; ADate1,
  ADate2: TFMDateTime; ASite, ARemoteRPC: String);
procedure Micro(Dest: TStrings; const PatientDFN: string; ADate1,
  ADate2: TFMDateTime; ARpc: string);  //*DFN*
procedure RemoteLabMicro(Dest: TStrings; const PatientDFN: string; ADate1,
  ADate2: TFMDateTime; ASite, ARemoteRPC: String);
function InterimSelect(const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  tests: TStrings): TStrings;  //*DFN*
function InterimGrid(const PatientDFN: string; ADate1: TFMDateTime;
  direction, format: integer): TStrings;  //*DFN*
function Worksheet(const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  spec: string; tests: TStrings): TStrings;  //*DFN*
procedure Reports(Dest: TStrings; const PatientDFN: string; reportid, hstype,
  ADate, section: string; Adate1, Adate2: TFMDateTime; ARpc: string);  //*DFN*
procedure RemoteLabReports(Dest: TStrings; const PatientDFN: string; reportid, hstype,
  ADate, section: string; Adate1, Adate2: TFMDateTime; ASite, ARemoteRPC: String);
procedure RemoteLab(Dest: TStrings; const PatientDFN: string; reportid, hstype,
  ADate, section: string; Adate1, Adate2: TFMDateTime; ASite, ARemoteRPC: String);
procedure GetNewestOldest(const PatientDFN: string; var newest, oldest: string);  //*DFN*
function GetChart(const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  spec, test: string): TStrings;  //*DFN*
procedure PrintLabsToDevice(AReport: string; ADaysBack: Integer;
  const PatientDFN, ADevice: string; ATests: TStrings;
  var ErrMsg: string; ADate1, ADate2: TFMDateTime; ARemoteSiteID, ARemoteQuery: string);
function GetFormattedLabReport(AReport: string; ADaysBack: Integer; const PatientDFN: string;
  ATests: TStrings; ADate1, ADate2: TFMDateTime; ARemoteSiteID, ARemoteQuery: string): TStrings;
function TestInfo(Test: String): TStrings;
function LabPatchInstalled: boolean;
function GetLabGridColor(DFN,Date,User:string; var DateSeen:string):integer; //kt  added 4/20/17

function TMGSendLabAlert(Recipients : TStringList; Info1 : string; Info2 : string = ''; Level : string = '') : string;  ////kt 2/17
function TMGHasLabReport(DFN,DisplayDate:string):boolean;  //kt 10/23/20
///

implementation

uses rCore, uCore, graphics, rMisc
     ,uTMGOptions;    //kt   4/20/17

const
  PSI_05_118 = 'LR*5.2*364';
var
  uLabPatchInstalled: TLabPatchInstalled;

function AtomicTests(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('ORWLRR ATOMICS', [StartFrom, Direction]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function Specimens(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('ORWLRR SPEC', [StartFrom, Direction]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function AllTests(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('ORWLRR ALLTESTS', [StartFrom, Direction]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function ChemTest(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('ORWLRR CHEMTEST', [StartFrom, Direction]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function Users(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('ORWLRR USERS', [StartFrom, Direction]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function TestGroups(user: int64): TStrings;
begin
  CallV('ORWLRR TG', [user]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function ATest(test: integer): TStrings;
begin
  CallV('ORWLRR ATESTS', [test]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function ATestGroup(testgroup: Integer; user: int64): TStrings;
begin
  CallV('ORWLRR ATG', [testgroup, user]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

procedure UTGAdd(tests: TStrings);
begin
  CallV('ORWLRR UTGA', [tests]);
end;

procedure UTGReplace(tests: TStrings; testgroup: integer);
begin
  CallV('ORWLRR UTGR', [tests, testgroup]);
end;

procedure UTGDelete(testgroup: integer);
begin
  CallV('ORWLRR UTGD', [testgroup]);
end;

procedure SpecimenDefaults(var blood, urine, serum, plasma: string);
begin
  CallV('ORWLRR PARAM', [nil]);
  blood := Piece(RPCBrokerV.Results[0], '^', 1);
  urine := Piece(RPCBrokerV.Results[0], '^', 2);
  serum := Piece(RPCBrokerV.Results[0], '^', 3);
  plasma := Piece(RPCBrokerV.Results[0], '^', 4);
end;

procedure Cumulative(Dest: TStrings; const PatientDFN: string; daysback: integer; ADate1, ADate2: TFMDateTime; ARpc: string);  //*DFN*
begin
  if Length(ARpc) > 0 then
    begin
      CallV(ARpc, [PatientDFN, daysback, ADate1, ADate2]);
      QuickCopy(RPCBrokerV.Results,Dest);
    end
  else
    begin
      Dest.Add('RPC is missing from report definition (file 101.24).');
      Dest.Add('Please contact Technical Support.');
    end;
end;

procedure RemoteLabCumulative(Dest: TStrings; const PatientDFN: string;
  daysback: integer; ADate1, ADate2: TFMDateTime; ASite, ARemoteRPC: String);
begin
  CallV('XWB REMOTE RPC', [ASite, ARemoteRPC, 0, PatientDFN, daysback, Adate1, Adate2]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure Interim(Dest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime; ARpc: string);  //*DFN*
begin
  if Length(ARpc) > 0 then
    begin
      CallV(ARpc, [PatientDFN, ADate1, ADate2]);
      QuickCopy(RPCBrokerV.Results,Dest);
    end
  else
    begin
      Dest.Add('RPC is missing from report definition (file 101.24).');
      Dest.Add('Please contact Technical Support.');
    end;
end;

procedure RemoteLabInterim(Dest: TStrings; const PatientDFN: string; ADate1,
  ADate2: TFMDateTime; ASite, ARemoteRPC: String);
begin
  CallV('XWB REMOTE RPC',[ASite, ARemoteRPC, 0, PatientDFN, Adate1, Adate2]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure Micro(Dest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime; ARpc: string);  //*DFN*
begin
  if Length(ARpc) > 0 then
    begin
      CallV(ARpc, [PatientDFN, ADate1, ADate2]);
      QuickCopy(RPCBrokerV.Results,Dest);
    end
  else
    begin
      Dest.Add('RPC is missing from report definition (file 101.24).');
      Dest.Add('Please contact Technical Support.');
    end;
end;

procedure RemoteLabMicro(Dest: TStrings; const PatientDFN: string; ADate1,
  ADate2: TFMDateTime; ASite, ARemoteRPC: String);
begin
  CallV('XWB REMOTE RPC',[ASite, ARemoteRPC, 0, PatientDFN, Adate1, Adate2]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

function InterimSelect(const PatientDFN: string; ADate1, ADate2: TFMDateTime; tests: TStrings): TStrings;  //*DFN*
begin
  CallV('ORWLRR INTERIMS', [PatientDFN, ADate1, ADate2, tests]);
  Result := RPCBrokerV.Results;
end;

function InterimGrid(const PatientDFN: string; ADate1: TFMDateTime; direction, format: integer): TStrings;  //*DFN*
begin
  CallV('ORWLRR INTERIMG', [PatientDFN, ADate1, direction, format]);
  Result := RPCBrokerV.Results;
end;

function TMGSendLabAlert(Recipients : TStringList; Info1 : string; Info2 : string = ''; Level : string = '') : string;
//kt added 2/17
//Expected format:
//    -- Recipients.Strings[i] = '<IEN200>'
//    -- Info1:  PatientDFN^LabDate^[Node]'   <-- level and node are optional
//                   PatientDFN = IEN2
//                   LabDate is type TFMDateTime, converted to string
//                   Level: Optional.  Default=1.  1->normal 2->abnormal, 3->Critical
//                   Node:  Optional.  Default is "CH".  Should be "CH" or "MI" only.
//    -- Info2:  Not used here.
//Result:  1^OK or -1^Error Message
//Note: this is similar to rLabs.TMGSendImagingAlert
var i : integer;
    Recip : string;
begin
  //RPC NAME -- 'TMG CPRS LAB ALERT' --> RPCALERT^TMGLRWU2(OUT,RECIP,DFN,IDT,LEVEL,NODE)
  with RPCBrokerV do begin
    ClearParameters := True;
    RemoteProcedure := 'TMG CPRS LAB ALERT';
    Param[0].PType := list;
    Param[0].Value :='';
    for i := 0 to Recipients.Count-1 do begin
      Recip := Recipients.Strings[i];
      Param[0].Mult[Recip] := '';
    end;
    Param[1].PType := literal;
    Param[1].Value := piece(Info1,'^',1);  //PatientDFN;
    Param[2].PType := literal;
    Param[2].Value := piece(Info1,'^',2);  //LabDate;
    Param[3].PType := literal;
    Param[3].Value := Level;               //Level;
    Param[4].PType := literal;
    Param[4].Value := piece(Info1,'^',3);  //Node;
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then begin
      Result := RPCBrokerV.Results.Strings[0];
    end else begin
      Result := '-1^No result returned';
    end;
  end;
end;

function TMGHasLabReport(DFN,DisplayDate:string):boolean;  //kt 10/23/20
var Results:TStringList;
    SDT:integer;
begin
  Results := TStringList.create();
  //SDT := strtoint(piece(DisplayDate,'.',1))-1;  //Back up a day
  tCallV(Results,'TMG CPRS LAB PDF LIST',[DFN,piece(DisplayDate,'.',1)+'.0001',piece(DisplayDate,'.',1)+'.9999']);
  result := (Results.Count>1);  //the [0] is "1^OK" etc.
  Results.Free;
end;


function Worksheet(const PatientDFN: string; ADate1, ADate2: TFMDateTime; spec: string; tests: TStrings): TStrings;  //*DFN*
begin
  CallV('ORWLRR GRID', [PatientDFN, ADate1, ADate2, spec, tests]);
  Result := RPCBrokerV.Results;
end;

procedure Reports(Dest: TStrings; const PatientDFN: string; reportid, hstype, ADate, section: string; Adate1, Adate2: TFMDateTime; ARpc: string);  //*DFN*
begin
  if Length(ARpc) > 0 then
    begin
      CallV(ARpc, [PatientDFN, reportid, hstype, ADate, section, Adate2, Adate1]);
      QuickCopy(RPCBrokerV.Results,Dest);
    end
  else
    begin
      Dest.Add('RPC is missing from report definition (file 101.24).');
      Dest.Add('Please contact Technical Support.');
    end;
end;

procedure RemoteLabReports(Dest: TStrings; const PatientDFN: string; reportid, hstype,
  ADate, section: string; Adate1, Adate2: TFMDateTime; ASite, ARemoteRPC: String);
begin
  CallV('XWB REMOTE RPC',[ASite, ARemoteRPC, 0, PatientDFN,
        reportid + ';1', hstype, ADate, section, Adate2, Adate1]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure RemoteLab(Dest: TStrings; const PatientDFN: string; reportid, hstype,
  ADate, section: string; Adate1, Adate2: TFMDateTime; ASite, ARemoteRPC: String);
begin
  CallV('XWB REMOTE RPC',[ASite, ARemoteRPC, 0, PatientDFN,
        reportid + ';1', hstype, ADate, section, Adate2, Adate1]);
  QuickCopy(RPCBrokerV.Results,Dest);
end;

procedure GetNewestOldest(const PatientDFN: string; var newest, oldest: string);  //*DFN*
begin
  CallV('ORWLRR NEWOLD', [PatientDFN]);
  newest := Piece(RPCBrokerV.Results[0], '^', 1);
  oldest := Piece(RPCBrokerV.Results[0], '^', 2);
end;

function GetChart(const PatientDFN: string; ADate1, ADate2: TFMDateTime; spec, test: string): TStrings;  //*DFN*
begin
  CallV('ORWLRR CHART', [PatientDFN, ADate1, ADate2, spec, test]);
  Result := RPCBrokerV.Results;
end;

procedure PrintLabsToDevice(AReport: string; ADaysBack: Integer;
 const PatientDFN, ADevice: string; ATests: TStrings; var ErrMsg: string;
 ADate1, ADate2: TFMDateTime; ARemoteSiteID, ARemoteQuery: string);
{ prints a report on the selected device }
var
  j: integer;
  RemoteHandle,Report: string;
  aHandles: TStringlist;
begin
  aHandles := TStringList.Create;
  if Length(ARemoteSiteID) > 0 then
    begin
      RemoteHandle := '';
      for j := 0 to RemoteReports.Count - 1 do
        begin
          Report := TRemoteReport(RemoteReports.ReportList.Items[j]).Report;
          if Report = ARemoteQuery then
            begin
              RemoteHandle := TRemoteReport(RemoteReports.ReportList.Items[j]).Handle
                + '^' + Pieces(Report,'^',9,10);
              break;
            end;
        end;
      if Length(RemoteHandle) > 1 then
        with RemoteSites.SiteList do
            aHandles.Add(ARemoteSiteID + '^' + RemoteHandle);
    end;
  if aHandles.Count > 0 then
    begin
      ErrMsg := sCallV('ORWRP PRINT LAB REMOTE',[ADevice, PatientDFN, AReport, aHandles]);
      if Piece(ErrMsg, U, 1) = '0' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
    end
  else
    begin
      ErrMsg := sCallV('ORWRP PRINT LAB REPORTS',[ADevice, PatientDFN, AReport,
        ADaysBack, ATests, ADate2, ADate1]);
      if Piece(ErrMsg, U, 1) = '0' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
    end;
  aHandles.Clear;
  aHandles.Free;
end;

function GetFormattedLabReport(AReport: String; ADaysBack: Integer;
  const PatientDFN: string; ATests: TStrings; ADate1, ADate2: TFMDateTime;
  ARemoteSiteID, ARemoteQuery: string): TStrings;
{ prints a report on the selected Windows device }
var
  j: integer;
  RemoteHandle,Report: string;
  aHandles: TStringlist;
begin
  aHandles := TStringList.Create;
  if Length(ARemoteSiteID) > 0 then
    begin
      RemoteHandle := '';
      for j := 0 to RemoteReports.Count - 1 do
        begin
          Report := TRemoteReport(RemoteReports.ReportList.Items[j]).Report;
          if Report = ARemoteQuery then
            begin
              RemoteHandle := TRemoteReport(RemoteReports.ReportList.Items[j]).Handle
                + '^' + Pieces(Report,'^',9,10);
              break;
            end;
        end;
      if Length(RemoteHandle) > 1 then
        with RemoteSites.SiteList do
            aHandles.Add(ARemoteSiteID + '^' + RemoteHandle);
    end;
  if aHandles.Count > 0 then
    begin
      CallV('ORWRP PRINT WINDOWS LAB REMOTE',[PatientDFN, AReport, aHandles]);
      Result := RPCBrokerV.Results;
    end
  else
    begin
      CallV('ORWRP WINPRINT LAB REPORTS',[PatientDFN, AReport, ADaysBack, ATests,
        ADate2, ADate1]);
      Result := RPCBrokerV.Results;
    end;
  aHandles.Clear;
  aHandles.Free;
end;

function TestInfo(Test: String): TStrings;
begin
  CallV('ORWLRR INFO',[Test]);
  Result := RPCBrokerV.Results;
end;

function LabPatchInstalled: boolean;
begin
  with uLabPatchInstalled do
    if not PatchChecked then
      begin
        PatchInstalled := ServerHasPatch(PSI_05_118);
        PatchChecked := True;
      end;
  Result := uLabPatchInstalled.PatchInstalled;
end;

function GetLabGridColor(DFN,Date,User:string; var DateSeen:string):integer; //kt  added 4/20/17
var
  RPCResult:string;
  color:string;
begin
  DateSeen := '';
  RPCResult := sCallV('TMG CPRS LABS SEEN',[DFN,Date,User]);
  if piece(RPCResult,'^',1)='1' then begin
    color := uTMGOptions.ReadString('color for seen lab results','$F0FBFF');   //seen
    DateSeen := piece(RPCResult,'^',2);
  end else begin
    color := uTMGOptions.ReadString('color for unseen lab results','$C0C0C0');   //unseen
    if piece(RPCResult,'^',2)<>'ENTRY CREATED' then showmessage(piece(RPCResult,'^',2))
    else DateSeen := 'Previously unreviewed';
  end;
  result := TColor(StringToColor(color));
end;

end.
