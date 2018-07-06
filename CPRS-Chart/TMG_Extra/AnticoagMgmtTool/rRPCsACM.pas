unit rRPCsACM;
//kt added this entire unit, moving stuff out of fAnticoagulator
//  to make more modular

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, grids,
  StdCtrls, StrUtils, Math, DateUtils, ComCtrls, ExtCtrls,
  ORCtrls, ORFn, ORNet, Trpcb, uTypesACM, uFlowsheet, uPastINRs, Hash,
  uHTMLTools, TMGHTML2;

//FORWARD DECLARATIONS
//--------------------
  //kt function MakeNote(DFN, Title, Clinic, VisitDate, SvcCat : string; Lines : TStrings) : string;
  function  MakeNote(AppState : TAppState; TitleIEN : String; Lines : TStrings) : string;
  function  CompleteConsultRPC(ConsultNumber, NoteNumber, DUZ : string) : string;
  function  ValidESCode(const ACode: string): Boolean;
  procedure GetConsultList(DFN, ConsultService : string; OutSL : TStrings);
  function SignRecord(NoteNumber, EncSig : string) : boolean;
  function  SignNote(NoteNumber, Clinic, UnencryptedSig : string) : boolean;
  function  GetPatientInfo(DFN : string; var Patient : TPatient) : boolean;
  procedure GetPercentInGoal(var Patient :TPatient; PctInGoalMode: tPctInGoalMode);
  function  PatientCheck(DFN : string) : tPtCheck;
  procedure AddNewPatient(DFN : string);
  function  GetParametersByRPC(DUZ, ClinicLoc: string; Parameters: TParameters) : boolean;
  function  FillIndicationsFromRPC(Parameters : TParameters; cbo : TComboBox) : boolean;
  procedure GetProviderInfo(var Provider : TProvider);
  function  GetClinicsList(cbo : TComboBox; Patient : TPatient) : boolean;
  function  GetHctOrHgbStr(DFN: string; var HgbFlag : boolean) : string;
  procedure GetPastINRValues(DFN : string; AppState : TAppState);
  procedure LockPatient(DFN, DUZ : string);
  function  UnlockPatient(DFN : string) : string;
  procedure FormatINRValues(InputStr : string; OutSL : TStringList);
  function  NoteTitleRequiresCoSignature(ATitle : string; Provider : TProvider) : boolean;
  function  HasKey(KeyName : string) : boolean;
  procedure GetTemplateText(TemplateIEN, DFN, VSTR: string; SL : TStringList);
  function  GetDefaultCosignerForCurrentUser : string;
  procedure GetEligibleCosignersList(FromName : string; OutSL : TStrings);
  function  AddTIUCosigner(TIUIEN, CosignerDUZ : string) : string;
  function  DeleteTIUNote(TIUIEN : string) : string;
  function  OrderIt(AppState : TAppState; code: string): string;
  procedure RPCGetFlowsheetRawData(DFN : string; OutSL : TStringList);
  function  GetClinicPercentActivity(OutSL : TStrings; NumDays, ClinicIEN : string): string;
  procedure GetClinicLoad(OutSL : TStrings; ClinicP : string);
  function  GetClinicNoActivity(OutSL : TStrings; NumDays, ClinicP : string) : boolean;
  procedure GetLockedPatients(OutSL : TStrings);
  procedure FilePCEData(AppState : TAppState);
  procedure SaveTopLevelPatientData(AppState : TAppState);
  procedure SaveExistingFlowsheetEntry(SL : TStrings; ComplicationCode : tComplication);
  function  SaveFlowsheetToServer(Flowsheet : TOneFlowsheet; AppState :TAppState; var ErrStr : string) : boolean;

  function  SaveINRToLabPackage(Flowsheet : TOneFlowsheet; AppState : TAppState; var ErrStr : string) : boolean;
  procedure ManageTeamLists(AppState : TAppState);

implementation

uses
  uUtility
  , fPCE_ACM
  ;

  {
//function MakeNote(DFN, Title, Clinic, VisitDate, SvcCat : string; Lines : TStrings) : string;
function MakeNote(AppState : TAppState; TitleIEN : String; Lines : TStrings) : string;
//Result is IEN of note
var i : integer;
begin
  with RPCBrokerV do begin
    ClearParameters := True;
    RemoteProcedure := 'TIU CREATE RECORD';
    Param[0].PType := literal;
    Param[0].Value := AppState.Patient.DFN;
    Param[1].PType := literal;
    Param[1].Value := TitleIEN;
    Param[2].PType := literal;
    Param[2].Value := '';    //[VDT]   = Date(/Time) of Visit
    Param[3].PType := literal;
    Param[3].Value := '';    //[VLOC]  = Visit Location (HOSPITAL LOCATION)
    Param[4].PType := literal;
    Param[4].Value := '';    //[VSIT]  = Visit file ien (#9000010)
    Param[5].PType := list;
    for i := 0 to Lines.Count - 1 do begin
      Param[5].Mult['"TEXT",' + IntToStr(i+1) + ',0'] := FilteredString(Lines[i]);
    end;
    Param[6].PType := literal;
    Param[6].Value := AppState.EClinic + ';' + AppState.Patient.VisitDate + ';' + AppState.SvcCat;
  end;
  Result := RPCBrokerV.strCall;
end;         }

procedure InitParams( NoteIEN: Int64; Suppress: Integer );
//This is split out from SetText because it has to be called more than once.
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU SET DOCUMENT TEXT';
    Param[0].PType := literal;
    Param[0].Value := IntToStr(NoteIEN);
    Param[1].PType := list;
    Param[2].PType := literal;
    Param[2].Value := IntToStr(Suppress);
  end;
end;

procedure SetText(var ErrMsg: string; NoteText: TStrings; NoteIEN: Int64; Suppress: Integer);
//kt documentation.  If Suppress=1, then save is put into TEMP node on server, instead of TEXT node.
const
  DOCUMENT_PAGE_SIZE = 300;
  TX_SERVER_ERROR = 'An error occurred on the server.' ;
var
  i, j, page, pages: Integer;
begin
  // Compute pages, initialize Params
  pages := ( NoteText.Count div DOCUMENT_PAGE_SIZE );
  if (NoteText.Count mod DOCUMENT_PAGE_SIZE) > 0 then pages := pages + 1;
  page := 1;

  InitParams( NoteIEN, Suppress );  //This is called again below if page > 1
  for i := 0 to NoteText.Count - 1 do begin   // Loop through NoteRec.Lines
    j := i + 1;   //Add each successive line to Param[1].Mult...
    RPCBrokerV.Param[1].Mult['"TEXT",' + IntToStr(j) + ',0'] := FilteredString(NoteText[i]);
    // When current page is filled, call broker, increment page, itialize params, and continue...
    if (j mod DOCUMENT_PAGE_SIZE) = 0 then begin
      RPCBrokerV.Param[1].Mult['"HDR"'] := IntToStr(page) + U + IntToStr(pages);
      CallBroker;
      if RPCBrokerV.Results.Count > 0 then begin
        ErrMsg := Piece(RPCBrokerV.Results[0], U, 4)
      end else begin
        ErrMsg := TX_SERVER_ERROR;
      end;
      if ErrMsg <> '' then Exit;
      page := page + 1;
      InitParams( NoteIEN, Suppress );
    end; // if
  end; // for
  // finally, file any remaining partial page
  if ( NoteText.Count mod DOCUMENT_PAGE_SIZE ) <> 0 then begin
    RPCBrokerV.Param[1].Mult['"HDR"'] := IntToStr(page) + U + IntToStr(pages);
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then begin
      ErrMsg := Piece(RPCBrokerV.Results[0], U, 4)
    end else begin
      ErrMsg := TX_SERVER_ERROR;
    end;
  end;
end;

function MakeNote(AppState : TAppState; TitleIEN : String; Lines : TStrings) : string;

{

[03/27/2018 15:04:50] - In the RPC TIU CREATE RECORD, parameter 9 is "NOASF".
   It must be currently set to 0. If you set it to 1, it doesn't set the "ASAVE"...
   which is what causes that message.

PREVIOUS MESSAGE:
Office:[03/27/2018 13:55:11] - TIU WAS THIS SAVED?
Called at: 1:53:57 PM

Params ------------------------------------------------------------------
literal	585631

Results -----------------------------------------------------------------
0^The author appears to have been disconnected...

Elapsed Time: 1 ms

}

var
  ErrMsg: string;
  NewNoteIEN : int64;
begin
  //kt AppState.EClinic := '17';   //elh this is temp but value should probably already be filled
  with RPCBrokerV do begin
    ClearParameters := True;
    RemoteProcedure := 'TIU CREATE RECORD';
    Param[0].PType := literal;
    Param[0].Value := AppState.Patient.DFN;  //*DFN*
    Param[1].PType := literal;
    Param[1].Value := TitleIEN;
    Param[2].PType := literal;
    Param[2].Value := AppState.Patient.VisitDate; //FloatToStr(Encounter.DateTime);
    Param[3].PType := literal;
    Param[3].Value := AppState.EClinic; //IntToStr(Encounter.Location);
    Param[4].PType := literal;
    Param[4].Value := '';
    Param[5].PType := list;
    with Param[5] do begin
      Mult['1202'] := AppState.Provider.DUZ;  //IntToStr(NoteRec.Author);
      Mult['1301'] := AppState.Patient.VisitDate;
      Mult['1205'] := AppState.EClinic;
    end;
    Param[6].PType := literal;
    Param[6].Value := AppState.EClinic + ';' + AppState.Patient.VisitDate + ';' + AppState.SvcCat;
    Param[7].PType := literal;
    Param[7].Value := '1';  // suppress commit logic
    Param[8].PType := literal;
    Param[8].Value := '1';   //NOASF
    CallBroker;
    NewNoteIEN := StrToIntDef(Piece(Results[0], U, 1), 0);
  end;
  if NewNoteIEN <> 0 then begin
    SetText(ErrMsg, Lines, NewNoteIEN, 1);
    if ErrMsg <> '' then begin
      NewNoteIEN := 0;
    end;
  end;
  result := inttostr(NewNoteIEN);
end;


function AddTIUCosigner(TIUIEN, CosignerDUZ : string) : string;
begin
  with RPCBrokerV do begin
    ClearParameters := True;
    RemoteProcedure := 'TIU UPDATE ADDITIONAL SIGNERS';
    Param[0].PType := literal;
    Param[0].Value := TIUIEN;
    Param[1].PType := list;
    with Param[1] do begin
      Mult['(1)'] := CosignerDUZ;
    end;
  end;
  Result := RPCBrokerV.strCall;
end;

function DeleteTIUNote(TIUIEN : string) : string;
begin
  if TIUIEN='' then exit;
  result := sCallV('TIU DELETE RECORD', [TIUIEN]);
end;

function CompleteConsultRPC(ConsultNumber, NoteNumber, DUZ : string) : string;
begin
  RPCBrokerV.Results.Clear;
  RPCBrokerV.ClearParameters := true;
  RPCBrokerV.ClearResults := true;
  RPCBrokerV.RemoteProcedure := 'ORAM CONCOMP';
  RPCBrokerV.Param[0].Value := ConsultNumber;
  RPCBrokerV.Param[0].PType := literal;
  RPCBrokerV.Param[1].Value := NoteNumber;
  RPCBrokerV.Param[1].PType := literal;
  RPCBrokerV.Param[2].Value := DUZ;
  RPCBrokerV.Param[2].PType := literal;
  Result := RPCBrokerV.strCall;
end;

procedure GetConsultList(DFN, ConsultService : string; OutSL : TStrings);
begin
  OutSL.Clear;
  CallV('ORAMX CONSULT',[DFN, ConsultService]);
  OutSL.Assign(RPCBrokerV.Results);
end;


function SignNote(NoteNumber, Clinic, UnencryptedSig : string) : boolean;
//kt moved from global scope into class and removed frmAnticoagulate
//Returns TRUE for success
var
    EncSig :string;
    RPCResult,RPCMessage : string; //kt mod 12/17
begin
  Result := true; //default
  with RPCBrokerV do begin
    ClearParameters := True;
    RemoteProcedure := 'TIU UPDATE RECORD';
    Param[0].PType := literal;
    Param[0].Value := NoteNumber;
    Param[1].PType := list;
    with Param[1] do begin
      Mult['(1205)'] := Clinic;
      Mult['(1211)'] := Clinic;
    end;
  end;
  RPCResult := RPCBrokerV.strCall;
  RPCResult := piece(RPCResult,'^',1);
  RPCMessage := piece(RPCResult,'^',2);
  if StrToInt(RPCResult) < 1 then begin//kt
    InfoBox('Problem encountered saving note. Server replied:' + CRLF +
            '"'+RPCMessage+'"',
            'Problem saving note.', MB_OK or MB_ICONEXCLAMATION);
    Result := false;
  end else begin
    EncSig := Encrypt(UnencryptedSig);
    CallV('TIU SIGN RECORD',[Notenumber, EncSig]);
    //kt to do, put elsewhere!! --> if FTitle = IntakeNote then CompleteConsult ();
  end;
end;


function ValidESCode(const ACode: string): Boolean;
{ returns true if the electronic signature code in ACode is valid }
begin
  Result := sCallV('ORWU VALIDSIG', [Encrypt(ACode)]) = '1';
end;


function SignRecord(NoteNumber, EncSig: string) : boolean;
//Result : true if OK, false if problem.
var Temp : string;
begin
  Temp := sCallV('TIU SIGN RECORD',[NoteNumber,EncSig]);
  Result := (StrToIntDef(Temp,-1) = 0);
end;

procedure GetPercentInGoal(var Patient :TPatient; PctInGoalMode: tPctInGoalMode);
var tempS : string;
    NonComplex : string;
begin
  NonComplex := BOOL_0or1[PctInGoalMode = igmNonComplex];   //'1' means only calculate on non-complex patients
  TempS := sCallV('ORAM1 PCGOAL', [Patient.DFN, NonComplex]);
  Patient.PctINRInGoal := Piece(TempS, '^', 1);
  Patient.TotalINRValues := Piece(TempS, '^', 2);
end;


function GetPatientInfo(DFN : string; var Patient : TPatient) : boolean;
//Result: true if OK, or false if fatal problem.

  function InvalidPatient(var Patient : TPatient) : boolean;
  //Result : true = Invalid (problem), false = OK
  var
    PtCheck : tPtCheck;
  begin
    Result := false;
    PtCheck := PatientCheck(Patient.DFN);
    case PtCheck of
      tpcNotPatient: begin
            Patient.NewPatient := true;
            {
            if InfoBox('Patient is NOT in Anticoagulation database.' + CRLF +
                       'Add patient to file and continue?',
                       'New Anticoagulation Patient', MB_YESNO or MB_ICONQUESTION) <> mrYes then begin
              result := true;
            end;
            }
          end;
      tpcConfigNeeded: begin
            InfoBox('Anticoagulation Management parameters must be set' + CRLF +
                    'before patient data can be added', 'Configuration Required',
                    MB_OK or MB_ICONSTOP);
            result := true;
          end;
      tpcInvalid: begin
            InfoBox('Error determining patient registration status' + CRLF +
                    'before patient data can be added', 'Server Configuration Problem',
                    MB_OK or MB_ICONSTOP);
            result := true;
          end;
    end; //case

    if Patient.Locked then begin
      Infobox('Chart for ' + Patient.Name +' not accessible; in use by ' + Patient.LockUserName +
              '.', 'Chart Unavailable', MB_OK or MB_ICONSTOP);
      result := true;
    end;
  end;

var PtStr, TempS : string;
    s0, s1, s2, s3, s4, s5 : string;
begin
  Patient.Clear;
  Result := true;
  PtStr := sCallV('ORAM PATIENT',[DFN]);
  //Result:  ;DFN^NAME^GENDER^ADMISSION^CURRENT DT/TIME (internal)^SSN^CURRENT DT/TIME (external)^CLINIC LOCATION^DTIME^APPTDT^DOB
	Patient.DFN  := piece(PtStr, '^', 1);
  if (Patient.DFN = '0') or (Patient.DFN = '') then begin
    InfoBox('No patient selected in your name.' + CRLF +
            'Please sign into CPRS and then activate this tool.',
            'No Patient Selected', MB_OK or MB_ICONSTOP);
    Result := false;
    exit;
  end;
  Patient.Name                := piece(PtStr, '^', 2);                     //NAME
  Patient.Gender              := piece(PtStr, '^', 3);                     //GENDER
  Patient.Admission           := piece(PtStr, '^', 4);                     //ADMISSION
  Patient.CurrentFMDT         := piece(PtStr, '^', 5);                     //CURRENT DT/TIME (internal)
  Patient.SSN                 := piece(PtStr, '^', 6);                     //SSN
  Patient.CurrentExtDT        := piece(PtStr, '^', 7);                     //CURRENT DT/TIME (external)
  Patient.ClinicIEN           := piece(PtStr, '^', 8);                     //CLINIC LOCATION
  Patient.TimeoutSeconds      := StrToIntDef(piece(PtStr, '^', 9), 300);   //DTIME
  Patient.VisitDate           := piece(PtStr, '^', 10);                    //APPTDT, as returned from $$GETAPPT^ORAM(DFN,+PLOC)
  Patient.DOB                 := FMDTStrToDateTime(piece(PtStr, '^', 10)); //Patient DOB (FM format)
  Patient.NewPatient          := (StrToIntDef(Patient.DFN,0) <= 0);

  //format SSN
  TempS := ReplaceStr(Patient.SSN, '-', ''); //first ensure doesn't already have '-'
  //Insert('-', TempS, 4);
  //Insert('-', TempS, 7);
  Patient.SSN := TempS;

  if Patient.Gender = 'M' then Patient.Greeting := 'Mr. ';
  if Patient.Gender = 'F' then Patient.Greeting := 'Ms. ';

  Patient.NiceName := Piece(Patient.Name, ',', 2) + ' ' + Piece(Patient.Name, ',', 1);
  TempS := Patient.CurrentExtDT;
  while Length(TempS) < 8 do TempS := TempS + ' ';
  Patient.PaddedNowDateStr := TempS;

  //Patient.ClinicIEN := piece(Patient.ClinicLoc, ';', 1);

  //======================================================================

  PtStr := sCallV('ORAM3 PTADR', [DFN]);
  Patient.Addr_Street_Line1   := Trim(piece(PtStr, '^', 1));
  Patient.Addr_Street_Line2   := Trim(piece(PtStr, '^', 2));
  Patient.Addr_Street_Line3   := Trim(piece(PtStr, '^', 3));
  Patient.Addr_City           := piece(PtStr, '^', 4);
  Patient.Addr_State          := piece(PtStr, '^', 5);
  Patient.Addr_ZIP            := piece(PtStr, '^', 6);
  Patient.Addr_Bad_Code       := piece(PtStr, '^', 7);
  Patient.Addr_Is_Temp        := (piece(PtStr, '^', 8) = '.121');
  if (Patient.Addr_Street_Line2 = '') and (Patient.Addr_Street_Line3 <> '') then begin
    Patient.Addr_Street_Line2 := Patient.Addr_Street_Line3;
    Patient.Addr_Street_Line3 := '';
  end;

  //======================================================================

  TempS := sCallV('ORAM3 PTFONE',[Patient.DFN]);
  Patient.HomePhone := Piece(TempS, '^', 1);
  Patient.WorkPhone := Piece(TempS, '^', 2);

  //======================================================================

  if not Patient.NewPatient then begin
    CallV('ORAM1 ACDATA', [Patient.DFN]);
    if RPCBrokerV.Results.Count > 0 then s0 := RPCBrokerV.Results[0] else s0 := '';
    if RPCBrokerV.Results.Count > 1 then s1 := RPCBrokerV.Results[1] else s1 := '';
    if RPCBrokerV.Results.Count > 2 then s2 := RPCBrokerV.Results[2] else s2 := '';
    if RPCBrokerV.Results.Count > 3 then s3 := RPCBrokerV.Results[3] else s3 := '';
    if RPCBrokerV.Results.Count > 4 then s4 := RPCBrokerV.Results[4] else s4 := '';
    if RPCBrokerV.Results.Count > 5 then s5 := RPCBrokerV.Results[5] else s5 := '';

    //RESULT(0) = 0 <-- if new patient
    //            line1^line2^line3^...  <-- SPECIAL INSTRUCTIONS text
    if S0 <> '0' then PiecesToList(S0, '^', Patient.SpecialInstructionsSL);

    //RESULT(1) = line1^line2^line3^...  <-- RISK FACTORS text
    PiecesToList(S1, '^', Patient.RiskFactorsSL);

    //RESULT(2) = line1^line2^line3^...  <-- MSG WITH text
    PiecesToList(S2, '^', Patient.PersonsOKForMsgSL);

    //RESULT(3) = <zero node>^<six node>    Pieces 1-20 are ZeroNode
    //                                      Pieces 21-25 map to pieces 1-5 in <Six node>
    //Patient.PatientIEN :=                    piece(s3, '^', 1 );  //<--- not needed. This is just DFN being returned
    Patient.GoalINR :=                         piece(s3, '^', 2 );
    TempS :=                                   piece(s3, '^', 3 );
    Patient.Indication_Text :=                 piece(TempS,'=',1);
    Patient.Indication_ICDCode :=              piece(TempS,'=',2);
    Patient.ScheduledLabDateStr :=             piece(s3, '^', 4 );
    Patient.NextScheduledINRCheckDate :=       StrToDateTimeDef(Patient.ScheduledLabDateStr, 0);
    Patient.StartDate :=                       piece(s3, '^', 5 );
    Patient.StopDate :=                        piece(s3, '^', 6 );
    Patient.ExpectedTreatmentDuration :=       piece(s3, '^', 7 );
    Patient.SignedAgreement :=                (piece(s3, '^', 8 ) = 'Y');
    Patient.Orientation :=                     piece(s3, '^', 9 );
    Patient.Complexity :=                      tPatientComplexity(StrToIntDef(piece(s3, '^', 10), 0));
    Patient.MsgPhone :=                        tMessagePhone(StrToIntDef(piece(s3, '^', 11), 0));
    Patient.AM_Meds :=                         tAMMeds(StrToIntDef(piece(s3, '^', 12), 0));
    Patient.SaveMode :=                        tSaveMode(IfThen(piece(s3, '^', 13) = 'TEMPSAVE', ord(tsmTempSave), ord(tsmSave)));
    Patient.FeeBasis :=                        tFeeBasis(StrToIntDef(piece(s3, '^', 14), 0));
    Patient.FeeBasisExpiration :=              StrToDateDef(piece(s3, '^', 15), 0);
    Patient.FeeBasisEvaluatedBy :=             piece(s3, '^', 16);
    Patient.StandingLabOrderExpirationDate :=  StrToDateDef(piece(s3, '^', 17), 0);   //expiration date for outside lab agreement.
    Patient.ReminderDate :=                    StrToDateDef(piece(s3, '^', 18), 0);
    Patient.Locked :=                         (piece(piece(s3, '^', 19), '|', 1) = '1');
    Patient.LockUserName :=                    piece(piece(s3, '^', 19), '|', 2);
    TempS :=                                   piece(s3, '^', 21);
    Patient.DrawRestrictionsArray[dayMon] :=  (Pos('1', TempS) > 0);
    Patient.DrawRestrictionsArray[dayTue] :=  (Pos('2', TempS) > 0);
    Patient.DrawRestrictionsArray[dayWed] :=  (Pos('3', TempS) > 0);
    Patient.DrawRestrictionsArray[dayThur]:=  (Pos('4', TempS) > 0);
    Patient.DrawRestrictionsArray[dayFri] :=  (Pos('5', TempS) > 0);
    Patient.NextDayCallback :=                 piece(s3, '^', 20);
    //Begining of SixNode pieces
    Patient.RestrictLabDraws :=                piece(s3, '^', 22);        //6;1
    Patient.ClinicIEN :=                       piece(s3, '^', 23);        //6;2   //this is a pointer
    Patient.Complex :=                         piece(s3, '^', 24);        //6;3
    Patient.OutsideHctOrHgb :=                 piece(s3, '^', 25);        //6;4
    Patient.Needs_LMWH_Bridging :=            (piece(s3, '^', 26) = '1'); //6;5

    //RESULT(4) = line1^line2^line3^...  <-- REMINDER
    PiecesToList(S4, '^', Patient.ReminderTextSL);

    //RESULT(5) = <0 or 1>^line1^line2^line3^...  <-- BRIDGING COMMENTS text
    //            0/1 is ELIGIBLE FOR LMWH BRIDGING field  (could also be "")
    s5 := pieces(s5, '^', 2, NumPieces(s5, '^'));
    PiecesToList(S5, '^', Patient.BridgingCommentsSL);

    //======================================================================

    TempS := sCallV('ORAM2 SHOWRATE', [Patient.DFN]);
    Patient.PctNoShow := piece(TempS, '^', 1);
    Patient.TotalVisits := Piece(TempS, '^', 2);

    TempS  := GetHctOrHgbStr(Patient.DFN, Patient.HgbFlag);
    Patient.HctOrHgbValue := Piece(TempS, '^', 1);
    Patient.HctOrHgbDate  := Piece(TempS, '^', 2);

    //To Do TEMP!! RESTORE WHEN DONE DEBUGGING!! --> Patient.Lock(Provider.DUZ);

  end; //not Patient.NewPatient

  Result := not InvalidPatient(Patient);  //Will set Patient.NewPatient if patient not already in database.  Also checks if patient locked.
end;

function PatientCheck(DFN : string) : tPtCheck;
var PtChk : string;
    Num : integer;
begin
  Result := tpcInvalid;
  PtChk := sCallV('ORAM1 PTCHECK', [DFN]);
  Num := StrToIntDef(PtChk, 0);
  case Num of
    0:   Result := tpcIsPatient;
    1:   Result := tpcNotPatient;
    99:  Result := tpcConfigNeeded;
  end;
end;


function GetParametersByRPC(DUZ, ClinicLoc: string; Parameters: TParameters) : boolean;
//Result: true if OK, or false if problem.
//Input: ClinicLoc  e.g. '17;SC('
var   ClinicParams: TStrings;
      s0,s1,s2  : string;
      TMG       : string;
      ResultStr : string;
      temp      : string;
begin
  Result := false; //default to failure
  Parameters.Clear;

  CallV('ORAMSET GET',[ClinicLoc]);
  {  //BELOW IS LISTING OF THE PXRM PARAMETER NAMES USED TO RETURN EACH DATA POINT.

	S0    piece  1      from param "ORAM CLINIC NAME"
        piece  2      from param "ORAM TEAM LIST (ALL)"
        piece  3      from param "ORAM TEAM LIST (COMPLEX)"
        piece  4      from param "ORAM INITIAL NOTE"
        piece  5      from param "ORAM INTERIM NOTE"
        piece  6      from param "ORAM DISCHARGE NOTE"  (NOTE: see #15 for missed appt note)
        piece  7      from param "ORAM CPT FOR SIMPLE PHONE"
        piece  8      from param "ORAM CPT FOR SUBSEQUENT VISIT"
        piece  9      from param "ORAM CPT FOR COMPLEX PHONE"
        piece 10      from param "ORAM CPT FOR ORIENTATION"
        piece 11      from param "ORAM CPT FOR INITIAL VISIT"
        piece 12      from param "ORAM CONSULT LINK ENABLED"
        piece 13      from param "ORAM PCE LINK ENABLED"
        piece 14      from param "ORAM CPT FOR LETTER TO PT"
        piece 15      from param "ORAM MISSED APPT NOTE"  //kt mod.  Was unused before.
        piece 16      from param "ORAM ADDRESS LINE 1"
        piece 17      from param "ORAM ADDRESS LINE 2"
        piece 18      from param "ORAM ADDRESS LINE 3"

	S1    piece  1      from param "ORAM SIGNATURE BLOCK NAME"
        piece  2      from param "ORAM SIGNATURE BLOCK TITLE"
        piece  3      from param "ORAM POINT OF CONTACT NAME"
        piece  4      from param "ORAM CLINIC PHONE NUMBER" | "ORAM CLINIC FAX NUMBER"
        piece  5      from param "ORAM MEDICAL CENTER NAME"
        piece  6      from param "ORAM DEFAULT PILL STRENGTH"
        piece  7      from param "ORAM INCL TIME W/NEXT INR DATE"
        piece  8      from param "ORAM TOLL FREE PHONE"

	S2    piece  1
          subpiece 1  from param "ORAM VISIT LOCATION"
          subpiece 2  from param "ORAM PHONE CLINIC"
          subpiece 3  from param "ORAM NON-COUNT LOCATION"
        piece  2
          subpiece 1  from param "ORAM INR QUICK ORDER"
          subpiece 2  from param "ORAM CBC QUICK ORDER"
        piece  3      (USER'S INSTITUTION)
        piece  4      from param "ORAM DSS UNIT"
        piece  5      from param "ORAM DSS ID"
        piece  6      from param "ORAM CONSULT REQUEST SERVICE"
        piece  7
          subpiece  1 from param "ORAM HCT/HGB REFERENCE"  <-- piece 1 of this
          subpiece  2 from param "ORAM HCT/HGB REFERENCE"  <-- piece 1 of this
        piece  8      from param "ORAM RAV FILE PATH"
        piece  9      from param "ORAM AUTO PRIMARY INDICATION"   <-- icd code
        piece 10      (ICD description) <-- from piece 9
  }


  if RPCBrokerV.Results[0] = '0' then begin
    InfoBox('Anticoagulation Management Parameters must be set prior to using this program.',
            'Configuration Required', MB_OK or MB_ICONSTOP);
    exit;
  end else with Parameters do begin
    ClinicParams := RPCBrokerV.Results;
    if ClinicParams.count > 0 then s0 := ClinicParams[0]; //kt converted to shorter string
    if ClinicParams.count > 1 then s1 := ClinicParams[1]; //kt converted to shorter string
    if ClinicParams.count > 2 then s2 := ClinicParams[2]; //kt converted to shorter string
    if ClinicParams.count > 4 then TMG:= ClinicParams[4]; //kt added. Left [3] for possible future VA expansion
    RawData0                            := s0;
    RawData1                            := s1;
    RawData2                            := s2;
    ConsultCtrl                         := StrToIntDef(Piece(s0, '^', 12),999);
    if ConsultCtrl = 1 then
      ConsultService                    := Piece(s2, '^', 6);
    SiteHead                            := Piece(s1, '^', 5);
    SiteName                            := Piece(s0, '^', 1);
    DefaultPillStrength                 := StrToFloatDef(Piece(s1, '^', 6), 5);
    LetterINRTime                       := Piece(s1, '^', 7);
    if LetterINRTime = '' then
      LetterINRTime                     := '0';
    InclINRTime                         := (LetterINRTime = '1');
    ListName                            := SiteName;  ///in case site name is changed, this is the original site
    SiteAddA                            := Piece(s0, '^', 16);
    SiteAddB                            := Piece(s0, '^', 17);
    SiteAddC                            := Piece(s0, '^', 18);
    ClinicName                          := Piece(s1, '^', 3);
    ClinicPhone                         := Piece(Piece(s1, '^', 4), '|', 1);
    ClinicFAX                           := Piece(Piece(s1, '^', 4), '|', 2);
    TollFreePhone                       := Piece(s1,'^', 8);
    SigName                             := Piece(s1, '^', 1);
    SigTitle                            := Piece(s1, '^', 2);
    IntakeNoteIEN                       := Piece(s0, '^', 4);   //IEN of note TITLE
    InterimNoteIEN                      := Piece(s0, '^', 5);   //IEN of note TITLE
    DischargeNoteIEN                    := Piece(s0, '^', 6);   //IEN of note TITLE
    MissedApptNoteIEN                   := Piece(s0, '^', 15);  //IEN of note TITLE
    SimplePhoneCPT                      := Piece(s0, '^', 7);
    SubsequentVisitCPT                  := Piece(s0, '^', 8);
    ComplexPhoneCPT                     := Piece(s0, '^', 9);
    InitialVisitCPT                     := Piece(s0, '^', 11);
    OrientationClassCPT                 := Piece(s0, '^', 10);
    PatientLetterCPT                    := Piece(s0, '^', 14);
    INRQuickOrder                       := '';
    CBCQuickOrder                       := '';
    VisitClinic                         := Piece(Piece(s2, '^', 1), '|', 1);
    PhoneClinic                         := Piece(Piece(s2, '^', 1), '|', 2);
    NonCountClinic                      := Piece(Piece(s2, '^', 1), '|', 3);
    StationNumber                       := Piece(s2, '^', 3);
    DSSUnit                             := Piece(s2, '^', 4);
    DSSId                               := Piece(s2, '^', 5);
    NetworkPath                         := Piece(s2, '^', 8);
    AutoPrimaryIndicationCode           := Piece(s2, '^', 9);
    AutoPrimaryIndicationText           := Piece(s2, '^', 10);
    Str0Pce13                           := Piece(s0, '^', 13);
    Str2Pce2                            := Piece(s2, '^', 2);

    INRQuickOrder                       := Piece(Piece(s2, '^', 2), '|', 1);
    if INRQuickOrder = '0' then
      INRQuickOrder                     := '';
    CBCQuickOrder                       := Piece(Piece(s2, '^', 2), '|', 2);
    if CBCQuickOrder = '0' then
      CBCQuickOrder                     := '';

    if Piece(TMG,'^',1)='TMG' then begin
      Temp                       := Piece(TMG,'^',2);
      TMGSaveINRIntoLabPackage   := (Temp='1') or (Temp = 'Y') or (Temp = 'YES') or
                                    (Temp = 'T') or (Temp = 'TRUE') ;         //From Param TMG ORAM SAVE INR TO LAB PAK
      TMGSaveINRLabSpecimenIEN61 := Piece(TMG,'^',3);                         //From Param TMG ORAM SAVE INR SPEC IEN61
      TMGSaveINRLabIEN60         := Piece(TMG,'^',4);                         //From Param TMG ORAM SAVE INR LAB IEN60
      TMGSaveHgbLabIEN60         := Piece(TMG,'^',5);                         //From Param TMG ORAM SAVE HGB LAB IEN60
      TMGSaveHctLabIEN60         := Piece(TMG,'^',6);                         //From Param TMG ORAM SAVE HCT LAB IEN60
    end else begin
      TMGSaveINRIntoLabPackage   := False;
      TMGSaveINRLabSpecimenIEN61 := '';
      TMGSaveINRLabIEN60         := '';
      TMGSaveHgbLabIEN60         := '';
      TMGSaveHctLabIEN60         := '';
    end;

  end; //else

  //kt added part below.
  with Parameters do begin
    ResultStr := '-1^Unknown Error';
    CallV('TMG ORAM GET TEMPL ENTRIES',[DUZ]);
    //Result:  1^OK^<IEN>;<TemplateName>^<IEN>;<TemplateName>^<IEN>;<TemplateName>^<IEN>;<TemplateName>^<IEN>;<TemplateName>
    //         or -1^Error message
    //   piece#:    3 -- IEN for Intake Note Template (TIU TEMPLATE #8927);<TemplateName>
    //              4 -- IEN for Interim Note Template (TIU TEMPLATE #8927);<TemplateName>
    //              5 -- IEN for DC Note Template (TIU TEMPLATE #8927);<TemplateName>
    //              6 -- IEN for Missed Appt Template (TIU TEMPLATE #8927);<TemplateName>
    //              7 -- IEN for Note for Patient Template (TIU TEMPLATE #8927);<TemplateName>


    if RPCBrokerV.Results.Count >= 1 then ResultStr := RPCBrokerV.Results[0];
    if piece(ResultStr,'^',1) <> '1' then begin
      InfoBox('Error getting note templates.' + CRLF +
              'Message:' + piece(ResultStr,'^',2) + CRLF +
              'Application will exit now.',
              'RPC Error', MB_OK or MB_ICONSTOP);
      exit;
    end;
    temp := piece(ResultStr,'^',3);
    IENIntakeNoteTemplate :=          piece(temp,';',1);
    NameIntakeNoteTemplate :=         piece(temp,';',2);
    temp := piece(ResultStr,'^',4);
    IENInterimNoteTemplate :=         piece(temp,';',1);
    NameInterimNoteTemplate :=        piece(temp,';',2);
    temp := piece(ResultStr,'^',5);
    IENDCNoteTemplate :=              piece(temp,';',1);
    NameDCNoteTemplate :=             piece(temp,';',2);
    temp := piece(ResultStr,'^',6);
    IENMissedApptNoteTemplate :=      piece(temp,';',1);
    NameMissedApptNoteTemplate :=     piece(temp,';',2);
    temp := piece(ResultStr,'^',7);
    IENNoteForPatientNoteTemplate :=  piece(temp,';',1);
    NameNoteForPatientNoteTemplate := piece(temp,';',2);
  end;
  result := true; //OK if we got this far
end;


//procedure SetIndicatorsRPC(Parameters : TParameters; OutStrings : TStrings);
function FillIndicationsFromRPC(Parameters : TParameters; cbo : TComboBox) : boolean;
//Result : True = success, False = problem.
var i: Integer;
    SL : TStringList;
begin
  Result := true;
  //Populate Indicators Combo Box
  CallV('ORAMSET INDICS', []);
  if RPCBrokerV.Results[0] <> '0' then begin
    SL := TStringList(cbo.Tag); if not Assigned(SL) then exit;
    SL.Clear;

    for i := 0 to RPCBrokerV.Results.Count - 1 do begin
      if (Parameters.AutoPrimaryIndicationCode = '') or
         (Parameters.AutoPrimaryIndicationCode <> Piece(RPCBrokerV.Results[i], '^', 2)) then begin
        SL.Add(RPCBrokerV.Results[i]);
      end;
    end;
    SL.Add('Other');
    cboLoadFromTagItems(cbo,[1]);
  end else if RPCBrokerV.Results[0] = '0' then begin
    InfoBox('ORAM INDICATIONS FOR CARE Parameter is corrupt.' + CRLF + 'Contact IRM.', 'Configuration Required', MB_OK or MB_ICONSTOP);
    Result := false;
    exit;
  end;
end;

procedure GetProviderInfo(var Provider : TProvider);
var y : string;
begin
  y := sCallV('ORAM PROVIDER',[]);
  Provider.DUZ := Piece(y, '^', 1);
  Provider.Name := Piece(y, '^', 2);
  Provider.Initials := Piece(y, '^', 3);
  Provider.DefaultCosigner := GetDefaultCosignerForCurrentUser(); //format: IEN^Name

  Provider.HasOrESKey := HasKey('ORES');
  Provider.HaOrElseKey := HasKey('ORELSE');
  Provider.HasOrProviderKey := HasKey('PROVIDER');

  if Provider.HasOrESKey or (Provider.HaOrElseKey and Provider.HasOrProviderKey) then begin
    Provider.CosignNeeded := false;
  end else begin
    Provider.CosignNeeded := true;
  end;
end;

function GetClinicsList(cbo : TComboBox; Patient : TPatient) : boolean;
//Result: true if OK, or false if parameters need to be set up.
var RPCResult : string;
    SL : TStringList;
begin
  Result := false;    //default to failure
  SL := TStringList(cbo.Tag); if not Assigned(SL) then exit;
  SL.Clear;
  //get list of established AC Clinics
  CallV('ORAMSET GETCLINS',[]);
  //Resulting format:
  //  OUT(0)=1     <--- list count
  //  OUT(1)="Family Physicians^17;SC("
  //  ...
  RPCResult := '0';  //default to RPC error state
  Result := true;    //default to success
  if RPCBrokerV.Results.count > 0 then begin
    RPCResult := RPCBrokerV.Results[0];
    RPCBrokerV.Results.Delete(0);
  end;
  if RPCResult = '0' then exit;

  SL.Assign(RPCBrokerV.Results);
  cboLoadFromTagItems(cbo, [1]);
  if SL.Count > 0 then begin
    Patient.ClinicLoc := Piece(SL[0], '^', 2);
    Patient.ClinicIEN := Piece(Patient.ClinicLoc, ';', 1);
    Patient.ClinicName := Piece(SL[0], '^', 1);
  end else begin
    InfoBox('Anticoagulation Management Parameters must be set' + CRLF +
            'prior to using this program.',
            'Configuration Required', MB_OK or MB_ICONSTOP);
    Result := false;
  end;
end;

procedure GetEligibleCosignersList(FromName : string; OutSL : TStrings);
begin
  CallV('ORWTPP GETCOS',[UpperCase(FromName),1,'']);
  OutSL.Assign(RPCBrokerV.Results);
end;


function GetHctOrHgbStr(DFN: string; var HgbFlag : boolean) : string;
//To Do: check server code to see if it is getting Hgb/Hct data out of flowsheets and/or lab data.
var s : string;
begin
  Result := sCallV('ORAM HCT', [DFN]);
  s := UpperCase(Piece(Result, '^', 3));
  HgbFlag := (Contains(s, 'HGB') or Contains(s, 'HEMOGLOBIN'));
end;


procedure GetPastINRValues(DFN : string; AppState : TAppState);
//NOTE: I think this gets INR values from LAB package, not from prior
//  INR entries from flow sheets.
begin
  CallV('ORAM INR', [DFN]);
	//   RESULT(0)=<INR VALUE>^^<external date>^<$H date>
	//   RESULT(1)=<INR VALUE>^^<external date>^<$H date>
	//   RESULT(#) ...
  AppState.PastINRValues.ParseFromRPCData(RPCBrokerV.Results);
  AppState.PastINRValues.Sort();
end;


procedure FormatINRValues(InputStr : string; OutSL : TStringList);
//Expected format of InputStr: '<INR VALUE>^<DATE>^<INR VALUE>^<DATE>' (may repeat as many times as needed)
var s : string;
    i : integer;
    INR : string;
    //tempDate: string;
    //DTH : string; //$H format date
begin
  //INRARR := TStringList.Create;
  CallV('ORAM1 OUTINR',[InputStr]);
  //   RESULT(#)= <INR VALUE>^<$H DATE>^<EXTERNAL DATE>
  //   RESULT(#)= <INR VALUE>^<$H DATE>^<EXTERNAL DATE>
  try
    OutSL.Clear;
    for i := 0 to RPCBrokerV.Results.Count - 1 do begin
      s := RPCBrokerV.Results[i];
      INR := Piece(s, '^', 1);
      //DTH := Piece(s, '^', 2);
      //TempDate := Piece(s, '^', 3);
      if Pos('>', INR) > 0 then INR := Piece(INR, '>', 2);
      if Pos('<', INR) > 0 then INR := Piece(INR, '<', 2);
      if StrToFloatDef(INR, -1) = -1 then INR := '-1';
      SetPiece(s, '^', 1, INR);
      OutSL.Add(s);
    end;// end i for
  except
    on EBrokerError do begin
      InfoBox('A problem was encountered communicating with the servers.',
              'Connection Error', MB_OK or MB_ICONERROR);
    end;
  end; {try}
end;

function NoteTitleRequiresCoSignature(ATitle : string; Provider : TProvider): boolean;
begin
  //RPC retuns '1' or '0'
  Result := (sCallV('TIU REQUIRES COSIGNATURE', [ATitle, 0, Provider.DUZ]) = '1');
end;

function HasKey(KeyName : string) : boolean;
begin
  Result := (sCallV('ORWU HASKEY', [KeyName]) = '1');
end;

procedure LockPatient(DFN, DUZ : string);
begin
  CallV('ORAM1 LOCK',[DFN + '^' + DUZ]);
end;

function UnlockPatient(DFN : string) : string;
begin
  Result := sCallV('ORAM1 UNLOCK',[DFN]); //OK if not previously locked, or if new patient.
end;

procedure GetTemplateText(TemplateIEN, DFN, VSTR: string; SL : TStringList);
begin
  //GetUnprocessedTemplateText(TemplateIEN, SL);
  //ProcessTemplateText(SL);
  CallV('TMG ORAM GET TEMPLATE TEXT', [TemplateIEN, DFN, VSTR]);
  if RPCBrokerV.Results.Count > 0 then RPCBrokerV.Results.Delete(0);
  SL.Assign(RPCBrokerV.Results);
end;

function GetDefaultCosignerForCurrentUser : string;
//Result:  IEN^Name
begin
  result := sCallV('ORWTPP GETDCOS',[]);
end;

function OrderIt(AppState : TAppState; code: string): string;
begin
  with RPCBrokerV do begin
    ClearParameters := True;
    RemoteProcedure := 'ORAM ORDER';
    Param[0].PType := literal;
    Param[0].Value := AppState.Patient.DFN;
    Param[1].PType := literal;
    Param[1].Value := AppState.Provider.DUZ;        //Provider ID
    Param[2].PType := literal;
    Param[2].Value := AppState.EClinic;   //Location Anticoag clinic
    Param[3].PType := literal;
    //Quick Order Dialog
    if code = 'INR' then
      Param[3].Value := AppState.Parameters.INRQuickOrder
    else if code = 'CBC' then
      Param[3].Value := AppState.Parameters.CBCQuickOrder;
    Param[4].PType := literal;
    Param[4].Value := AppState.Patient.NextScheduledINRCheckDateTimeStr; //Collection Date/time
    Call;
    if Piece(Result, '^', 1) = '0' then begin
      InfoBox(Piece(Result, '^', 2), 'Order Failed!', MB_OKCANCEL or MB_ICONERROR);
    end;
  end;
end;


procedure SetPatientCareEncounterInfo(AppState : TAppState; CosignerDUZ : string);
//kt NOTE: doesn't seem to be used....
var ECHzero : string;
    ProvDUZ : string;
begin
  ProvDUZ := IfThenStr(CosignerDUZ <> '', CosignerDUZ + '~', '')
             + AppState.Provider.DUZ;
  ECHzero := ProvDUZ + '|' +
             AppState.Parameters.DSSId + '|' +
             AppState.PCEProcedureStr +'|' +
             Trim(AppState.Patient.Indication_ICDCode) + '|' +
             AppState.PCEData.GetSCString;

  CallV('ORAMX PCESET', [AppState.Patient.DFN,
                         ECHzero,
                         AppState.EClinic,
                         AppState.Patient.VisitDate,
                         AppState.SvcCat,
                         AppState.Patient.Indication_Text,
                         AppState.Parameters.AutoPrimaryIndicationCode + '^'
                           + AppState.Parameters.AutoPrimaryIndicationText]);
end;


function GetClinicPercentActivity(OutSL : TStrings; NumDays, ClinicIEN : string) : string;
begin
  Result := '0'; //default to none
  CallV('ORAM2 ALLGOAL',[NumDays, ClinicIEN]);
  if RPCBrokerV.Results.Count < 1 then exit;
  Result := RPCBrokerV.Results[0];
  RPCBrokerV.Results.Delete(0);
  OutSL.Assign(RPCBrokerV.Results);
end;

procedure GetClinicLoad(OutSL : TStrings; ClinicP : string);
//gets 45 days of info
begin
  CallV('ORAM2 PTAPPT',[ClinicP]);
  OutSL.Assign(RPCBrokerV.Results);
end;

procedure GetLockedPatients(OutSL : TStrings);
begin
  CallV('ORAM1 GETPT',['1']);  //'1' means only return locked records
  OutSL.Assign(RPCBrokerV.Results);
end;


function GetClinicNoActivity(OutSL : TStrings; NumDays, ClinicP : string) : boolean;
//Result: true if some found, false if none.
begin
  CallV('ORAM2 NOACT',[NumDays, ClinicP]);
  Result := (RPCBrokerV.Results.Count > 0);
  OutSL.Assign(RPCBrokerV.Results);
end;


procedure FilePCEData(AppState : TAppState);
var echzero : string;
begin
  //echzero = duz^dssid^Proced^ICD9new
  with AppState do begin
    ECHzero := Provider.Initials + '|' +
               Parameters.DSSId + '|' +
               PCEProcedureStr +'|' +
               Trim(Patient.Indication_ICDCode) + '|' +
               uPCEData.GetSCString;
    CallV('ORAMX PCESET', [Patient.DFN,
                           ECHzero,
                           EClinic,
                           Patient.VisitDate,
                           SvcCat,
                           Patient.Indication_Text,
                           Parameters.AutoPrimaryIndicationCode + '^' +
                           Parameters.AutoPrimaryIndicationText]);
  end;
end;

procedure SaveTopLevelPatientData(AppState : TAppState);
var
  SpInNew, RiskNew, PeepNew, ReminderStr, Zero  : string;
  FeeDate, Indication, Bridging, BridgeComment: String;
  RemindDate : string;
  ReturnDate : string;
  LabExp: string;
  i: Integer;
  StandArr: TStrings;

begin
  //SpInNew := ''; RiskNew := ''; PeepNew := ''; RemindDate := '';
  with AppState do begin
    SpInNew       := IfThenStr(SpecialInstructionsEdited, ListToPieces(Patient.SpecialInstructionsSL), '');
    RiskNew       := IfThenStr(RisksEdited, ListToPieces(Patient.RiskFactorsSL), '');
    PeepNew       := IfThenStr(PeopleOKForMessageChanged, ListToPieces(Patient.PersonsOKForMsgSL), '');
    ReminderStr   := ListToPieces(Patient.ReminderTextSL);
    RemindDate    := IfThenStr(ReminderStr<>'', DateToStr(Patient.ReminderDate), '');
    Bridging      := BOOL_0or1[Patient.Needs_LMWH_Bridging]; //'0' OR '1'
    BridgeComment := ListToPieces(Patient.BridgingCommentsSL);
    Indication    := Patient.Indication_Text + '=' + Patient.Indication_ICDCode;
    ReturnDate    := IfThenStr(not Patient.DischargedFromClinic, Patient.NextScheduledINRCheckDateTimeStr, '');
    LabExp        := ''; //DateToStr(Patient.StandingLabOrderExpirationDate); 3/13/09 JER
    FeeDate       := ''; //DateToStr(Patient.FEE_BASIS_EXPIRATION); 3/13/09 JER

    Zero :=
      Patient.DFN + '^' +                                            //0;1       .01  PATIENT
      Patient.GoalINR + '^' +                                        //0;2         1  GOAL INR
      Indication + '^'+                                              //0;3         2  INDICATION
      ReturnDate + '^' +                                             //0;4         3  NEXT LAB
      Patient.StartDate + '^' +                                      //0;5         4  START DATE
      Patient.StopDate + '^' +                                       //0;6         5  STOP DATE
      Patient.ExpectedTreatmentDuration + '^' +                      //0;7         6  DURATION
      BOOL_YN[Patient.SignedAgreement]+'^'+                          //0;8         9  SIGNED AGREEMENT  (Y/N)
      Patient.Orientation + '^' +                                    //0;9        10  ORIENTATION
      Patient.ComplexityNumberStr+'^'+                               //0;10       15  COMPLEXITY
      Patient.MsgPhoneNumberStr +'^'+                                //0;11       25  MSG-PHONE
      Patient.AMMedsNumberStr+'^'+                                   //0;12       45  AM MEDS
      SAVE_MODE[Patient.SaveMode] + '^' +                            //0;13       55  SAVE STATUS
      Patient.FeeBasisNumberStr+'^'+                                 //0;14       60  FEE BASIS
      FeeDate + '^' +                                                //0;15       65  FEE BASIS EXPIRATION
      Provider.DUZ + '^' +                                           //0;16       70  FEE BASIS EVALUATED BY
      LabExp + '^' +                                                 //0;17       75  OUTSIDE LAB
      RemindDate + '^' +                                             //0;18       80  Reminder Date
      '0' + '^' +                                                    //0;19       90  LOCK
      BOOL_0or1[AppState.NextDayCallback];                           //0;20       91  NEXT DAY CALLBACK

    //NOTE: SixNode is filed with flowsheet instead of here, where it should be.  But
    //  if I fix it, that would break backwards compatibility

    StandArr := TStringList.Create;
    try
      StandArr.Add(Patient.DFN);
      StandArr.Add(Zero);
      StandArr.Add(SpInNew);      //only send if it has been changed (avoid database churn), else send ''
      StandArr.Add(RiskNew);      //only send if it has been changed (avoid database churn), else send ''
      StandArr.Add(PeepNew);      //only send if it has been changed (avoid database churn), else send ''
      StandArr.Add(ReminderStr);  //only send if it has been changed (avoid database churn), else send ''
      StandArr.Add(Bridging);     // 0 or 1
      StandArr.Add(BridgeComment);//only send if it has been changed (avoid database churn), else send ''
      StandArr.Add(Patient.ClinicIEN); //a pointer.  Only filed if > 0
      with RPCBrokerV do begin
        ClearParameters := True;
        RemoteProcedure := 'ORAM1 ADDTOP';
        for i := 0 to StandArr.Count - 1 do
          Param[0].Mult[IntToStr(i)] := StandArr[i];
        Param[0].PType := list;
      end;
      RPCBrokerV.Call;     //no result returned
    finally
      StandArr.Free;
    end;

    sCallV('ORAM2 REMIND',[Patient.DFN,
                           DateToStr(Patient.ReminderDate),
                           ListToPieces(Patient.ReminderTextSL)]);
  end;
end;


procedure ManageTeamLists(AppState : TAppState);
var ListIdentified : string;
begin
  with AppState do begin
    if Patient.SaveMode <> tsmSave then exit;
    if Patient.NewPatient then exit;
    if not (IsFutureDate(Patient.NextScheduledINRCheckDate) or Patient.DischargedFromClinic) then exit;

    ListIdentified := sCallV('ORAM1 TERASE', [Patient.DFN, Parameters.ListName]);
    if Piece(ListIdentified, '^', 1) = '0' then begin
      InfoBox(Piece(ListIdentified, '^', 2) + CRLF + 'Please notify your CAC.',
        'Clinic Parameter Undefined', MB_OK or MB_ICONWARNING);
    end;
  end;
end;

procedure AddNewPatient(DFN : string);
begin
  CallV('ORAM1 PTENTER',[DFN]); //result is always '1'
end;

procedure SaveExistingFlowsheetEntry(SL : TStrings; ComplicationCode : tComplication);
//kt DEPRECIATED.  use SaveFlowsheetToServer()
var j : integer;
    //Count : integer;
    CompCodeStr : string;
    Result : string;
//Expected input:
//  SL[0] = DFN
//  SL[1] = IEN
//  SL[2] = Date (as string)
//  SL[3] = INR value
//  SL[4] = PatientNotifiedText
//  SL[5] = TWD
//  SL[6] = DUZ   <--- Free text name, not an IEN
//  SL[7] = <count of following comment lines>
//  SL[8...] = <lines of text of comments>
//  SL[#] = <count of following complications lines>
//  SL[#+1...] = <lines of text of complications>
//
// ComplicationCode =  1  <- MAJOR BLEED
//                     2  <- CLOT
//                     3  <- MINOR BLEED

begin
  RPCBrokerV.Results.Clear;
  RPCBrokerV.ClearParameters := TRUE;
  RPCBrokerV.ClearResults := True;
  RPCBrokerV.RemoteProcedure := 'ORAM1 LOG';
  RPCBrokerV.Param[0].PType := list;
  for j := 0 to SL.Count-1 do RPCBrokerV.Param[0].Mult[IntToStr(j)] := SL[j];
  RPCBrokerV.Param[1].PType := literal;
  CompCodeStr := IfThenStr(ComplicationCode<>tcmpUndefined, IntToStr(Ord(ComplicationCode)), '');
  RPCBrokerV.Param[1].Value := CompCodeStr;
  RPCBrokerV.Call;
  if RPCBrokerV.Results.Count > 0 then begin
    Result := RPCBrokerV.Results[0];
    if piece(Result,'^',1) = '-1' then begin
      InfoBox(Piece(Result, '^', 2), 'Save Failed!', MB_OKCANCEL or MB_ICONERROR);
    end;
  end;
end;


function SaveFlowsheetToServer(Flowsheet : TOneFlowsheet; AppState :TAppState; var ErrStr : string) : boolean;
var
  ZeroNode, TempLabDrawLoc, SixNode, TMGNode: String;
  Patient : TPatient;
  i,j : Integer;

begin
  Result := true; //default to success
  Patient := AppState.Patient;  //for local convenience
  with Flowsheet do begin
    TempLabDrawLoc := IfThenStr(AppState.Historical or AppState.OutsideLabDataEntered, LabInfoStr, 'VAMC');  //stores VAMC in the file for INR values from lab file
    ZeroNode :=
      DateStr + '^' +                                              //1   FlowSheet DATE
      '^' +                                                        //2   COMPLICATION
      INR + '^' +                                                  //3   INR
      TempLabDrawLoc + '^' +                                       //4   LAB DRAW LOC    [Location|PhoneNum|FaxNum]
      PillStrength1 + '^' +                                        //5   PILL STRENGTH
      TotalWeeklyDose + '^' +                                      //6   TOTAL WEEKLY DOSE
      DailyTotalMgsStr + '^' +                                     //7   DAILY DOSING
      PatientNotice + '^' +                                        //8   PATIENT NOTICE
      '^' +                                                        //9   D/T STAMP    <-- server puts NOW in here.
      AppState.Provider.DUZ + '^' +                                //10  PROVIDER
      Patient.Indication_Text  + '^' +                             //11  CURRENT INDICATION
      CurrentINRGoal + '^' +                                       //12  CURRENT GOAL
      AppState.AppointmentShowStatusStr + '^' +                    //13  SHOW VALUE
      '^' +                                                        //14  (unusued)
      '^' +                                                        //15  (unusued)
      '^' +                                                        //16  (unusued)
      '^' +                                                        //17  (unusued)
      '^' +                                                        //18  (unusued)
      '^' +                                                        //19  (unusued)
      DateTimeToFMDTStr(TMGRetractionDate) + '^' +                 //20  TMG retraction date
      IfThenStr(UsingTwoPills, PillStrength2,'')+'^'+              //21  TMG PILL STRENGTH #2
      Flowsheet.DailyNumTabs1Str + '^' +                           //22  TMG DAILY NUM TABS #1
      IfThenStr(UsingTwoPills, DailyNumTabs2Str,'')+'^'+           //23  TMG DAILY NUM TABS #2
      DateTimeToFMDTStr(INRLabDateTime);                           //24  TMG INR/LAB DATE

    //I  could move this to be filed with top level patient information (other RPC call)
    //  but that would break backwards compatibility, so will leave here
    SixNode :=                                                     //NOTE: this is Node 6 of **PARENT** record
      Patient.DrawRestrictionsStr + '^' +                          //6;1     95  RESTRICT LAB DRAWS
      Patient.ClinicIEN + '^' +                                    //6;2    101  CLINIC     (pointer)
      '^' +                                                        //6;3    102  CMPLX   -- "THIS FIELD IS NOT IN USE AT THIS TIME."
      HgbOrHctInfoStr + '^' +                                      //6;4    110  OUTSIDE HCT
      BOOL_0or1[Patient.Needs_LMWH_Bridging];                      //6;5    111  ELIGIBLE FOR LMWH BRIDGING

    //Below are duplicates of data found in TPatient and TAppSate
    //But they are also used for creating documentation for a single flowsheet event, and are
    //  stored in flowsheet.  So copy here.
    Flowsheet.DocsAppointmentNoShowDate := AppState.AppointmentNoShowDate;
    Flowsheet.DocsViolatedAgreement     := Patient.ViolatedAgreement;
    Flowsheet.DocsDischargedReason      := Patient.DischargedReason;
    Flowsheet.DocsDischargedDate        := Patient.DischargedDate;

    TMGNode :=
      BOOL_YN[Flowsheet.DosingEdited] + '^' +                      //TMG;1
      DoseHoldNumOfDays + '^' +                                    //TMG;2
      DoseTakeNumMgToday + '^' +                                   //TMG;3
      DateTimeToFMDTStr(DocsAppointmentNoShowDate) + '^' +         //TMG;4
      BOOL_YN[DocsPtMoved] + '^' +                                 //TMG;5
      DocsPtTransferTo + '^' +                                     //TMG;6
      BOOL_YN[DocsViolatedAgreement] + '^' +                       //TMG;7
      Patient.DischargedReason + '^' +                             //TMG;8
      DateTimeToFMDTStr(DocsDischargedDate) + '^';                 //TMG;9

    if AppState.AppointmentShowStatus = tsvNoShow then Comments.Add('Missed Appt');
    Comments.Add('Next Appt: ' + Patient.NextScheduledINRCheckDateStr);

  end;

  RPCBrokerV.Results.Clear;
  RPCBrokerV.ClearParameters := TRUE;
  RPCBrokerV.ClearResults := True;
  RPCBrokerV.ClearParameters := True;
  RPCBrokerV.RemoteProcedure := 'ORAM1 COMPTEST';

  //-- 1st parameter ---------------
  i := -1;
  inc(i); RPCBrokerV.Param[0].Mult[IntToStr(i)] := Patient.DFN;
  inc(i); RPCBrokerV.Param[0].Mult[IntToStr(i)] := ZeroNode;
  inc(i); RPCBrokerV.Param[0].Mult[IntToStr(i)] := SAVE_MODE[PATIENT.SaveMode];
  inc(i); RPCBrokerV.Param[0].Mult[IntToStr(i)] := SixNode;
  inc(i); RPCBrokerV.Param[0].Mult[IntToStr(i)] := Flowsheet.ComplicationsEncodedStr;
  inc(i); RPCBrokerV.Param[0].Mult[IntToStr(i)] := IntToStr(Flowsheet.Comments.Count);
  for j := 0 to (Flowsheet.Comments.Count - 1) do begin
    inc(i); RPCBrokerV.Param[0].Mult[IntToStr(i)] := Flowsheet.Comments[j];
  end;
  inc(i); RPCBrokerV.Param[0].Mult[IntToStr(i)] := IntToStr(Flowsheet.PatientInstructions.Count);
  for j := 0 to Flowsheet.PatientInstructions.Count - 1 do begin
    inc(i); RPCBrokerV.Param[0].Mult[IntToStr(i)] := Flowsheet.PatientInstructions[j];
  end;
  inc(i); RPCBrokerV.Param[0].Mult[IntToStr(i)] := TMGNode;

  RPCBrokerV.Param[0].PType := list;

  //-- 2nd parameter ---------------
  RPCBrokerV.Param[1].PType := literal;
  RPCBrokerV.Param[1].Value := Flowsheet.subIEN;

  //-- Now call ---------------
  RPCBrokerV.Call;  //result is always 1 and doesn't reflect any possible error state

  //next,
  Result := SaveINRToLabPackage(Flowsheet, AppState, ErrStr);
end;

function SaveINRToLabPackage(Flowsheet : TOneFlowsheet; AppState : TAppState; var ErrStr : string) : boolean;
//Result: true if OK, or false if error string set.

var INRValue, HgbValue, HctValue : string;
    INR_IEN60, Hgb_IEN60, Hct_IEN60, IEN61, Flag, INR_Lo, INR_Hi, LabDT : string;
    Temp: string;
    Patient : TPatient;
    Provider: TProvider;
    i : integer;
    CurParam : TParamRecord;

  procedure AddParamLine(S : String);
  begin
    inc(i); CurParam.Mult[IntToStr(i)] := S;
  end;

begin

//      TMGSaveHgbLabIEN60         := Piece(TMG,'^',5);                         //From Param TMG ORAM SAVE HGB LAB IEN60
//      TMGSaveHctRLabIEN60        := Piece(TMG,'^',6);                         //From Param TMG ORAM SAVE HCT LAB IEN60

//    HctOrHgbValue            : string;  //will be 'Hgb: # on <date>'  or 'Hct: # on <date>'
//Patient.HGBFlag

  Result := true; //default to success
  ErrStr := '';
  if not AppState.Parameters.TMGSaveINRIntoLabPackage then exit;
  INRValue := Trim(Flowsheet.INR);
  HgbValue := IfThen(Patient.HGBFlag, Trim(Flowsheet.HctOrHgbValue), '');
  HctValue := IfThen(not Patient.HGBFlag, Trim(Flowsheet.HctOrHgbValue), '');
  if (INRValue = '') and (HgbValue = '') and (HctValue = '') then exit;
  INR_IEN60 := AppState.Parameters.TMGSaveINRLabIEN60;
  if (INR_IEN60 = '') and (INRValue <> '') then begin
    ErrStr := 'Parameter [TMG ORAM SAVE INR LAB IEN60] not initialized. Unable to save INR value to lab package.';
    Result := False;
  end;
  Hgb_IEN60 := AppState.Parameters.TMGSaveHgbLabIEN60;
  if (Hgb_IEN60 = '') and (HgbValue <> '') then begin
    ErrStr := 'Parameter [TMG ORAM SAVE HGB LAB IEN60] not initialized. Unable to save Hgb value to lab package.';
    Result := False;
  end;
  Hct_IEN60 := AppState.Parameters.TMGSaveHctLabIEN60;
  if (Hct_IEN60 = '') and (HctValue <> '') then begin
    ErrStr := 'Parameter [TMG ORAM SAVE HCT LAB IEN60] not initialized. Unable to save Hct value to lab package.';
    Result := False;
  end;
  IEN61 := AppState.Parameters.TMGSaveINRLabSpecimenIEN61;
  if IEN61 = '' then begin
    ErrStr := 'Parameter [TMG ORAM SAVE INR SPEC IEN61] not initialized. Unable to save INR value to lab package.';
    Result := False;
  end;
  Flag := Flowsheet.INRGoalStatusLabel;
  INR_Hi := Flowsheet.strINRGoalHigh;
  INR_Lo := Flowsheet.strINRGoalLow;
  LabDT := DateTimeToFMDTStr(Flowsheet.INRLabDateTime); // FMDateTimeStr;

  //========================================================
  Patient := AppState.Patient;
  Provider := AppState.Provider;

  RPCBrokerV.Results.Clear;
  RPCBrokerV.ClearParameters := TRUE;
  RPCBrokerV.ClearResults := True;
  RPCBrokerV.ClearParameters := True;
  RPCBrokerV.RemoteProcedure := 'TMG CPRS POST LAB VALUES';

  //-- 1st parameter ---------------
  i := -1;
  CurParam := RPCBrokerV.Param[0];
  CurParam.PType := list;

  AddParamLine('<METADATA>');
  AddParamLine('PATIENT='+Patient.DFN);
  AddParamLine('PROVIDER='+Provider.DUZ);
  AddParamLine('LOCATION='+Patient.ClinicIEN);
  AddParamLine('SPECIMEN='+IEN61);
  AddParamLine('<VALUES>');
  if INRValue <> '' then begin
    AddParamLine(INR_IEN60+'^'+INRValue+'^'+Flag+'^'+INR_Lo+'^'+INR_Hi+'^'+LabDT);    //IEN60^LabValue^Flag^RefLo^RefHi^[LabDate]^[SpecimenName]^[SpecimenIEN61]^
  end;
  if HgbValue <> '' then begin
    AddParamLine(Hgb_IEN60+'^'+HgbValue+'^^^^'+LabDT);    //IEN60^LabValue^Flag^RefLo^RefHi^[LabDate]^[SpecimenName]^[SpecimenIEN61]^
  end;
  if HctValue <> '' then begin
    AddParamLine(Hct_IEN60+'^'+HctValue+'^^^^'+LabDT);    //IEN60^LabValue^Flag^RefLo^RefHi^[LabDate]^[SpecimenName]^[SpecimenIEN61]^
  end;
  AddParamLine('<COMMENTS>');
  AddParamLine('Labs performed at: ' + IfThen(Patient.ClinicName <> '', Patient.ClinicName, 'Anticoagulation Clinic')+'.');
  AddParamLine('Lab values entered manually; human error may have occurred.');
  //AddParamLine('Given INR normal range relates to target INR goal set for patient. ');

  //-- Now call ---------------
  RPCBrokerV.Call;

  if RPCBrokerV.Results.Count > 0 then begin
    Temp := RPCBrokerV.Results[0];
    if piece(Temp,'^',1) = '-1' then begin
      Result := false;
      ErrStr := Piece(Temp, '^', 2);
    end;
  end;

end;

procedure RPCGetFlowsheetRawData(DFN : string; OutSL : TStringList);
  //Each patient has 1 ORAM FLOWSHEET record with common data, then
  //      multiple subfile records for each anticoagulation encounter.
  //      This RPC gets the subfile records.
  //  RESULT(0) = <#A>[,<#B>]|<ZERO NODE>^@^<TMG NODE> <-- first flowsheet entry
  //           #A = number of comments lines
  //           #B = number of complications lines (optional)
  //           <ZERO NODE> is the 0 node, but date is made external, and piece #2 is subIEN
  //               -0;1   =   .01   -FS DATE          <--- made external date
  //               -0;2   =   104   -COMPLICATION     <--- overwritten with subIEN before delivery by RPC
  //               -0;3   =    20   -INR
  //               -0;4   =    30   -LAB DRAW LOC
  //               -0;5   =    40   -PILL STRENGTH
  //               -0;6   =    50   -TOTAL WEEKLY DOSE
  //               -0;7   =    60   -DAILY DOSING
  //               -0;8   =    70   -PATIENT NOTICE
  //               -0;9   =    80   -D/T STAMP
  //               -0;10  =    90   -PROVIDER
  //               -0;11  =    92   -CURRENT INDICATION
  //               -0;12  =    95   -CURRENT GOAL
  //               -0;13  =   100   -SHOW VALUE
  //               -0;21  = 22701   -TMG PILL STRENGTH #2
  //               -0;22  = 22702   -TMG DAILY NUM TABS #1
  //               -0;23  = 22703   -TMG DAILY NUM TABS #2
  //          <TMG NODE> is the "TMG" node
  //               -TMG;1 = 22714   -DOSING EDITED
  //               -TMG;2 = 22715   -HOLD RX NUMBER OF DAYS
  //               -TMG;3 = 22716   -TAKE NUMBER OF TABS TODAY
  //               -TMG;4 = 22717   -APPOINTMENT NOSHOW DATE
  //               -TMG;5 = 22718   -PATIENT MOVED AWAY
  //               -TMG;6 = 22719   -PATIENT CARE TRANSFERRED TO
  //               -TMG;7 = 22720   -PATIENT VIOLATED AGREEMENT
  //               -TMG;8 = 22721   -DISCHARGE REASON
  //               -TMG;9 = 22722   -DISCHARGE DATE

  //  RESULT(1..x1) = <line of comments> <--- only if comments #A > 0
  //  RESULT(x1+1) = "-= PATIENT INSTRUNCTIONS =-"  <-- tagged text marker dividing comments from patient instructions.  Only if instructions present
  //  RESULT(x1+2..y) <line of patient instructions> <-- only if patient instructions present.
  //  RESULT(y+1) = "Complications noted:" <-- only if complications #B > 0
  //  RESULT(y+2..z) = <line of complication) <-- only if complications #B > 0
  //                   NOTE: I think this is a formated group of text, with tags
  //                   'MB:', 'C:', 'Minor bleed', 'Thrombotic Event'
  //  ...
  //  <repeat of above pattern for each flowsheet entry.
begin
  RPCBrokerV.Results.Clear;
  RPCBrokerV.ClearParameters := true;
  RPCBrokerV.ClearResults := true;
  CallV('ORAM1 FLOWTT', [DFN]);
  //To Do -- change server code so that patient instructions and TMG node are also returned.
  OutSL.Assign(RPCBrokerV.Results);
end;


end.
