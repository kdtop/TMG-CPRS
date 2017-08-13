unit rCarePlans;
//VEFA-261 added entire unit.  Derived from rTemplates

interface

  uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, TRPCB, uTIU;

  { CarePlans }
  procedure GetCarePlanLinkedDx(NeededDxs : TStringList);  //VEFA-261
  procedure GetCarePlanChildren(ID: string; FilteringICDCode : string);
  function UpdateCarePlanTemplateLinkedDxs(CarePlanIEN : string; FLinkedDxs : TStringList; NoDel : string) : string;  //VEFA-261
  function GetOneCarePlanTemplate(IEN8927 : string) : string;
  function GetProblemICD(ProbIEN : string) : string;  //VEFA-261
  function SaveNewCarePlan(DFN, Goal, IEN8927, ICDCode: String) : string;
  function SetCarePlanActiveStatus(VEFA19008 : String; Active : boolean) : string;
  procedure ReadCarePlans(DFN, ICDCode : string; HideInactive : boolean; DestSL : TStringList);
  function UpdateCarePlan(IEN19008, IEN8925 : string) : string;
  function UpdateCarePlanTemplate(ID: string; Fields: TStrings): string;
  function GetCarePlanResults(PatientDFN, CPTemplateIEN : string; StartDateS : string = ''; EndDateS : String=''): TStrings;
  function GetProbListInfo(PatientDFN: String; ICDList: TStringList): TStrings;
  procedure PatientHasLinkedDx(RPCResults: TStringList; DFN, IEN8927 : String);
  function FindOrCreateCarePlan(DFN, Goal, IEN8927, ICDCode: String) : string;
  function DeleteCarePlan(DFN: string) : string;
  procedure CheckLinkedCPsForTIU (TIUIEN : string; Dest:TStrings);
  {Template math, object}
  function GetRPCTIUObj(TIUObjName : string) : string;


implementation

  uses StrUtils;

  var
    uUserCarePlanDefaults: string = '';
    uCanEditDlgFldChecked: boolean = FALSE;
    //uCanEditDlgFlds: boolean;

  { CarePlan RPCs -------------------------------------------------------------- }

  procedure GetCarePlanChildren(ID: string; FilteringICDCode : string);
  begin
  //NOTE: Here we need to access the value of cbShowLinkedPlans.checked and the Dx to determine the proper RPC call to return.  //VEFA-261
    if(ID = '') or (ID = '0') then begin
      RPCBrokerV.Results.Clear
    end else begin
      CallV('VEFA CAREPLAN GET ITEMS', [ID,FilteringICDCode]);  //--> GETITEMS^VEFARPC1
    end;
  end;

  function GetOneCarePlanTemplate(IEN8927 : string) : string;  //VEFA-261
  begin
    Result := '';
    if(IEN8927 = '') or (IEN8927 = '0') then begin
      RPCBrokerV.Results.Clear
    end else begin
      CallV('VEFA CAREPLAN GET 1 ITEM', [IEN8927]);     // --> GET1ITEM^VEFACP
    end;
    if (RPCBrokerV.Results.Count = 0) then exit;
    Result := RPCBrokerV.Results.Strings[0];
    if piece(Result,'^',1)='-1' then begin
      Result := '';
      exit; //ignore errors, return ''
    end;
    RPCBrokerV.Results.Delete(0);  //Delete success message
    if (RPCBrokerV.Results.Count = 0) then exit;
    Result := RPCBrokerV.Results.Strings[0];
  end;


  function UpdateCarePlanTemplateLinkedDxs(CarePlanIEN : string; FLinkedDxs : TStringList; NoDel : string) : string;  //VEFA-261
  //Store Array of linked diagnoses to Care Plan IEN=ID
  //Result: '' if OK, or '-1^Message' if error
  //Expected format of FLinkedDxs: 'ICDcode^ICDName'

  var
    i : integer;
    s : string;
  begin
    Result := '';
    RPCBrokerV.ClearParameters := True;
    RPCBrokerV.RemoteProcedure := 'VEFA CAREPLAN SET LINKED DX';  // -->  SETCPDX^VEFACP1
    RPCBrokerV.Param[0].PType := literal;
    RPCBrokerV.Param[0].Value := CarePlanIEN;
    RPCBrokerV.Param[1].PType := list;
    for i := 0 to FLinkedDxs.Count - 1 do begin
      s:= FLinkedDxs.Strings[i];
      RPCBrokerV.Param[1].Mult[IntToStr(i+1)] := s;  //Format: 'ICDcode^ICDName'
    end;
    RPCBrokerV.Param[2].PType := literal;
    RPCBrokerV.Param[2].Value := NoDel;
    CallBroker;
    if (RPCBrokerV.Results.Count > 0) then begin
      Result := RPCBrokerV.Results.Strings[0];
      //if piece(Result,U,1) <> '-1' then Result := '';
    end else begin
      Result := '-1^No result returnd from RPC: VEFA CAREPLAN SET LINKED DX';
    end;
  end;

  procedure GetCarePlanLinkedDx(NeededDxs : TStringList);  //VEFA-261 added
  //Purpose: to batch return all linked diagnoses for a group of CarePlan IEN's
  //NOTE: NeededDxs -- used for input, and replaced with output
  //Input format: NeededDxs.strings[i]=<IEN of careplan>
  //              NeededDxs.Objects[i]=TCarePlan corresponding to .strings[i]
  //Output format:NeededDxs.strings[i]=<IEN of careplan>^ICD Code~ICD Name^ICD Code~ICD Name^ICD Code~ICD Name^.. (repeat as many times as needed.
  //NOTE: the 1 <--> 1 relationship between the .strings[i] and .objects[i] must remain intact.
  var
    i, j: integer;
    Result,IENStr : string;
  begin
    RPCBrokerV.ClearParameters := True;
    RPCBrokerV.RemoteProcedure := 'VEFA CAREPLAN GET LINKED DX';  // -->  GETCPDX^VEFACP1
    RPCBrokerV.Param[0].PType := list;
    for i := 0 to NeededDxs.Count - 1 do begin
      RPCBrokerV.Param[0].Mult[IntToStr(i+1)] := NeededDxs.Strings[i];
    end;
    CallBroker;
    if (RPCBrokerV.Results.Count > 0) then begin
      Result := RPCBrokerV.Results.Strings[0];
      if piece(Result,'^',1)<>'-1' then begin
        RPCBrokerV.Results.Delete(0);
        for i := 0 to RPCBrokerV.Results.Count - 1 do begin
          Result := RPCBrokerV.Results.Strings[i];
          IENStr := piece(Result,'^',1);
          j := NeededDxs.IndexOf(IENStr);
          if j<0 then continue;
          NeededDxs.Strings[j] := Result;  //Should keep the string and object appropriately linked.
        end;
      end else begin
        NeededDxs.Clear;
      end;
    end else begin
      NeededDxs.Clear;
    end;
  end;

  function GetProblemICD(ProbIEN : string) : string;
  //Purpose: Get ICD code associated with a give problem.
  //Input: ProbIEN = IEN in file 9000011
  begin
    Result := '';
    RPCBrokerV.ClearParameters := True;
    RPCBrokerV.RemoteProcedure := 'VEFA CAREPLAN GET PROB ICD';  // -->  GETPRICD^VEFACP1
    RPCBrokerV.Param[0].PType := literal;
    RPCBrokerV.Param[0].Value := ProbIEN;
    CallBroker;
    if (RPCBrokerV.Results.Count > 0) then begin
      Result := RPCBrokerV.Results.Strings[0];
    end else begin
      Result := '-1^No result returnd from RPC: VEFA CAREPLAN GET PROB ICD';
    end;

  end;

  function DeleteCarePlan(DFN: string) : string;
  //This saves a new care plan (not a care plan template)
  //Result is VEFA19008^SUCCESSFUL, or -1^Message
  begin
    Result := sCallV('VEFA CAREPLAN DELETE',[DFN]);  // --> SETPTCP^VEFACP1
  end;

  function SaveNewCarePlan(DFN, Goal, IEN8927, ICDCode: String) : string;
  //This saves a new care plan (not a care plan template)
  //Result is VEFA19008^SUCCESSFUL, or -1^Message
  begin
    Result := sCallV('VEFA CAREPLAN SET CAREPLAN',[DFN,Goal,IEN8927,ICDCode]);  // --> SETPTCP^VEFACP1
  end;

  function FindOrCreateCarePlan(DFN, Goal, IEN8927, ICDCode: String) : string;
  //This saves a new care plan (not a care plan template)
  //Result is VEFA19008IEN^GoalName^SUCCESSFUL, or -1^Message
  begin
    Result := sCallV('VEFA CAREPLAN GET OR CREATE',[DFN,Goal,IEN8927,ICDCode]);
  end;

  function SetCarePlanActiveStatus(VEFA19008 : String; Active : boolean) : string;
  //Result is 0^SUCCESSFUL, or -1^Message
  var ActiveS : string;
  begin
    if Active then ActiveS := 'Y' else ActiveS := 'N';
    Result := sCallV('VEFA CAREPLAN SET ACTIVE STAT',[VEFA19008,ActiveS]);  // --> SETCPACT^VEFACP1
  end;

  procedure ReadCarePlans(DFN, ICDCode : string; HideInactive : boolean; DestSL : TStringList);
  //Output format in DestSL:  VEFA19008^IEN8927^GoalName^InactiveStatus
  //  InactiveStatus=1 if inactive template
  var Hide : string;
  begin
    if not assigned(DestSL) then exit;
    DestSL.Clear;
    if HideInactive then Hide:='0' else Hide:='1';
    tCallV(DestSL, 'VEFA CAREPLAN GET CAREPLANS', [DFN, ICDCode, Hide]);   // --> GETPTCP^VEFACP1
  end;

  function UpdateCarePlan(IEN19008, IEN8925: string) : string;
  begin
    Result := sCallV('VEFA CAREPLAN ADD UPDATE',[IEN19008, IEN8925]);     // --> CPUPDATE^VEFACP1
  end;


  function UpdateTIURec(RPC, ID: string; Fields: TStrings): string;
  var
    i, j: integer;

  begin
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := RPC;
      Param[0].PType := literal;
      Param[0].Value := ID;
      Param[1].PType := list;
      for i := 0 to Fields.Count-1 do
      begin
        j := pos('=',Fields[i]);
        if(j > 0) then Param[1].Mult[Fields.Names[i]] := copy(Fields[i],j+1,MaxInt);
      end;
      CallBroker;
      Result := RPCBrokerV.Results[0];
    end;
  end;

  function UpdateCarePlanTemplate(ID: string; Fields: TStrings): string;
  begin
    Result := UpdateTIURec('TIU TEMPLATE CREATE/MODIFY', ID, Fields);
  end;

  function GetCarePlanResults(PatientDFN, CPTemplateIEN : string; StartDateS : string = ''; EndDateS : String=''): TStrings;
  //Note: StartDateS, EndDateS can be format like 'T-10Y', or 'NOW', or FM date format, e.g. '3060401.113422'
  begin
    CallV('VEFA CAREPLAN GET RESULTS', [PatientDFN, CPTemplateIEN,StartDateS,EndDateS]);     // -->  GETCDATA^VEFACP3
    Result := RPCBrokerV.Results;
  end;

  function GetProbListInfo(PatientDFN: String; ICDList: TStringList): TStrings;
  var i:integer;
  begin
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'VEFA CAREPLAN GET PROB INFO';
      Param[0].PType := literal;
      Param[0].Value := PatientDFN;
      Param[1].PType := list;
      for i := 0 to ICDList.Count-1 do
        Param[1].Mult[IntToStr(i+1)+',0'] := ICDList[i];
      CallBroker;
    end;
    Result := RPCBrokerV.Results;
  end;

  procedure PatientHasLinkedDx(RPCResults: TStringList; DFN, IEN8927 : String);
  //Returns RPCResults
  begin
    tCallV(RPCResults,'VEFA CAREPLAN TP MATCH PL',[DFN,IEN8927]);  // WAS VEFA TEMPLATE MATCH PROBLIST
  end;

  procedure CheckLinkedCPsForTIU (TIUIEN : string; Dest:TStrings);    //VEFA-261  10/18/11  added entire function
  { returns message detailing missing CPs or fields}
  begin
    CallV('VEFA VERIFY CP IN TIU', [TIUIEN, Patient.DFN]);
    FastAssign(RPCBrokerV.Results, Dest);
    //Result := RPCBrokerV.Results;
  end;


  //Template Math call.
  function GetRPCTIUObj(TIUObjName : string) : string;
  //VEFA-261 added entire function 3/28/10
  //Based on rTemplates.GetTemplateText(BoilerPlate: TStrings);
  begin
    TIUObjName := AnsiReplaceText(TIUObjName,'|','');
    with RPCBrokerV do begin
      ClearParameters := True;
      RemoteProcedure := 'TIU TEMPLATE GETTEXT';
      Param[0].PType := literal;
      Param[0].Value := Patient.DFN;
      Param[1].PType := literal;
      Param[1].Value := Encounter.VisitStr;
      Param[2].PType := list;
      Param[2].Mult[IntToStr(1)+',0'] := '|' + TIUObjName + '|';
      CallBroker;
      RPCBrokerV.Results.Delete(0);
      if RPCBrokerV.Results.count > 0 then begin
        Result := RPCBrokerV.Results.Strings[0];
      end else Result := '';
      RPCBrokerV.Results.Clear;
    end;
  end;




end.
