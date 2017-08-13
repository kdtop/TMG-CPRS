unit rLetters;
//VEFA-261 added entire unit.

interface

  uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, TRPCB, uTIU;

  procedure GetLetterList(LetterList : TStringList);
  procedure GetLetterText(BoilerPlate, OutputLines: TStrings; DFN : string);
  procedure GetLetterPath(LetterIEN : string; var ExpandStr, SelectStr : string);
  function GetListTypes: TStrings;
  function GetPatientList(IEN19008d2, ListIEN: int64): TStrings;
  function GetListOfPatientLists(IEN19008d2: int64): TStrings;
  function CreateTIUDocument(DFN,NoteType,Visit: string; MemoText: TStrings): string;

implementation

  uses StrUtils, uCarePlan, uTemplates, Dialogs;

  procedure ShowFMError(ErrStr : string);
  begin
    MessageDlg(ErrStr,mtError,[mbOK],0);
  end;

  procedure GetLetterList(LetterList : TStringList);
  var i : integer;
  begin
    LetterList.Clear;
    CallV('VEFA LETTERS GET',[nil]);

    //finish ... needs error state handling.
    RPCBrokerV.Results.Delete(0);

    for i:=0 to RPCBrokerV.Results.Count-1 do begin
      RPCBrokerV.Results.Strings[i] := AnsiReplaceText(RPCBrokerV.Results.Strings[i], NAMESPACE_TAG_FOR_MODE[cptemLetter]+'-','');
    end;
    LetterList.Assign(RPCBrokerV.Results);
  end;


  procedure GetLetterText(BoilerPlate, OutputLines: TStrings; DFN : string);
  var
    i: integer;
  begin
    with RPCBrokerV do begin
      ClearParameters := True;
      RemoteProcedure := 'TIU TEMPLATE GETTEXT';
      Param[0].PType := literal;
      Param[0].Value := DFN;
      Param[1].PType := literal;
      Param[1].Value := ''; //Encounter.VisitStr;
      Param[2].PType := list;
      for i := 0 to BoilerPlate.Count-1 do begin
        Param[2].Mult[IntToStr(i+1)+',0'] := BoilerPlate[i];
      end;
      CallBroker;
      RPCBrokerV.Results.Delete(0);
      FastAssign(RPCBrokerV.Results, OutputLines);
      RPCBrokerV.Results.Clear;
    end;
  end;

  procedure GetLetterPath(LetterIEN : string; var ExpandStr, SelectStr : string);
  begin
    CallV('VEFA GET XP STRING',[LetterIEN]);

    //finish ... needs error state handling.
    //Will crash if [0] doesn't exist

    if piece(RPCBrokerV.Results.Strings[0],'^',1)='1' then begin
      SelectStr := RPCBrokerV.Results.Strings[1];
      ExpandStr := RPCBrokerV.Results.Strings[2];
    end else begin
      SelectStr := '';   //'-1^'+piece(RPCBrokerV.Results.Strings[0],'^',2);
      ExpandStr := '';   //'-1^'+piece(RPCBrokerV.Results.Strings[0],'^',2);
    end;

  end;

  function GetListTypes: TStrings;
  var ResultStr : string;
  begin
    CallV('VEFA GET LIST TYPES',[]);
    Result := RPCBrokerV.Results;
    if RPCBrokerV.Results.Count > 0 then begin
      ResultStr := RPCBrokerV.Results.Strings[0];
      Result.Delete(0);
      if piece(ResultStr,'^',1)='-1' then begin
        ShowFMError(piece(ResultStr,'^',2));
        Result.Clear;
        Result.Add('0^No data -- Contact IRM');
      end;
    end;
  end;



  function GetPatientList(IEN19008d2, ListIEN: int64): TStrings;
  var ResultStr : string;
  begin
    CallV('VEFA GET PATIENT LIST',[ListIEN,IEN19008d2]);

    Result := RPCBrokerV.Results;
    if RPCBrokerV.Results.Count > 0 then begin
      ResultStr := RPCBrokerV.Results.Strings[0];
      RPCBrokerV.Results.Delete(0);
      if piece(ResultStr,'^',1)='-1' then begin
        ShowFMError(piece(ResultStr,'^',2));
        Result.Clear;
        //Result.Add('0^No data -- Contact IRM');
      end else if piece(ResultStr,'^',2) <> '[PATIENT LIST]' then BEGIN
        ShowFMError('Record #'+IntToStr(IEN19008d2)+ ', field 1, in file 19008.2 incorrectly configured.'+#13#10+
                    'List header does not have "[PATIENT LIST]".  Contact IRM');
        Result.Clear;
        //Result.Add('0^No data -- Contact IRM');
      end;
    end;
  end;


  function GetListOfPatientLists(IEN19008d2: int64): TStrings;
  var ResultStr : string;
  begin
    CallV('VEFA GET LIST OF PATIENT LISTS', [IEN19008d2]);

    Result := RPCBrokerV.Results;
    if RPCBrokerV.Results.Count > 0 then begin
      ResultStr := RPCBrokerV.Results.Strings[0];
      RPCBrokerV.Results.Delete(0);
      if piece(ResultStr,'^',1)='-1' then begin
        ShowFMError(piece(ResultStr,'^',2));
        Result.Clear;
        Result.Add('0^No data -- Contact IRM');
      end else if piece(ResultStr,'^',2) <> '[LIST OF LISTS]' then BEGIN
        ShowFMError('Record #'+IntToStr(IEN19008d2)+ ', field 2, in file 19008.2 incorrectly configured.'+#13#10+
                    'List header does not have "[LIST OF LISTS]".  Contact IRM');
        Result.Clear;
        Result.Add('0^No data -- Contact IRM');
      end;
    end;
  end;

function CreateTIUDocument(DFN,NoteType,Visit: string; MemoText: TStrings): string;
var
  i: integer;
begin
//the following is a temporary test
  with RPCBrokerV do begin
    ClearParameters := True;
    RemoteProcedure := 'TIU CREATE RECORD';
    Param[0].PType := literal;
    Param[0].Value := DFN; //Patient.DFN;  //*DFN*
    Param[1].PType := literal;
    Param[1].Value := NoteType; //IntToStr(NoteRec.Title);
    Param[2].PType := literal;
    Param[2].Value := ''; //FloatToStr(Encounter.DateTime);
    Param[3].PType := literal;
    Param[3].Value := ''; //IntToStr(Encounter.Location);
    Param[4].PType := literal;
    Param[4].Value := '';
    Param[5].PType := list;
    with Param[5] do
    begin
      if MemoText.Count <> 0 then
        for i := 0 to MemoText.Count - 1 do
          Mult['"TEXT",' + IntToStr(i+1) + ',0'] := FilteredString(MemoText[i]);
    end;
    Param[6].PType := literal;
    Param[6].Value := '';
    Param[7].PType := literal;
    Param[7].Value := '1';  // suppress commit logic
    CallBroker;
  end;
    Result := RPCBrokerV.Results.Strings[0];
end;

end.

