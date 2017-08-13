unit rTemplates;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, TRPCB, uTIU;

{ Templates }
procedure GetTemplateRoots;
function IsUserTemplateEditor(TemplateID: string; UserID :Int64): boolean;
procedure GetTemplateChildren(ID: string);
procedure GetTemplateBoilerplate(ID: string);
procedure GetTemplateText(BoilerPlate: TStrings);
function IsTemplateEditor(ID: string): boolean;
//function SubSetOfTemplateOwners(const StartFrom: string; Direction: Integer): TStrings;
function UpdateTemplate(ID: string; Fields: TStrings): string;
procedure UpdateChildren(ID: string; Children: TStrings);
procedure DeleteTemplates(DelList: TStrings);
procedure GetObjectList;
procedure GetAllowedPersonalObjects;
procedure TestBoilerplate(BoilerPlate: TStrings);
function GetTemplateAccess(ID: string): integer;
function SubSetOfBoilerplatedTitles(const StartFrom: string; Direction: Integer): TStrings;
function GetTitleBoilerplate(TitleIEN: string): string;
function GetUserTemplateDefaults(LoadFromServer: boolean = FALSE): string;
procedure SetUserTemplateDefaults(Value: string; PieceNum: integer);
procedure SaveUserTemplateDefaults;
procedure LoadTemplateDescription(TemplateIEN: string);
function GetTemplateAllowedReminderDialogs: TStrings;
function IsRemDlgAllowed(RemDlgIEN: string): integer;
function LockTemplate(const ID: string): boolean; // returns true if successful
procedure UnlockTemplate(const ID: string);
function GetLinkedTemplateData(const Link: string): string;
function SubSetOfAllTitles(const StartFrom: string; Direction: Integer): TStrings;

{ Template Fields }
function SubSetOfTemplateFields(const StartFrom: string; Direction: Integer): TStrings;
function LoadTemplateField(const DlgFld: string): TStrings;
function LoadTemplateFieldByIEN(const DlgFld: string): TStrings;
function CanEditTemplateFields: boolean;
function UpdateTemplateField(const ID: string; Fields: TStrings): string;
function LockTemplateField(const ID: string): boolean;
procedure UnlockTemplateField(const ID: string);
procedure DeleteTemplateField(const ID: string);
function ExportTemplateFields(FldList: TStrings): TStrings;
function ImportTemplateFields(FldList: TStrings): TStrings;
function IsTemplateFieldNameUnique(const FldName, IEN: string): boolean;
procedure Convert2LMText(Text: TStringList);
procedure CheckTemplateFields(ResultString: TStrings);
function BuildTemplateFields(XMLString: TStrings): boolean;
function ImportLoadedFields(ResultSet: TStrings): boolean;
function DBDialogFieldValuesGet(DFN, AVisitStr : string; Data : TStrings; var ErrStr : string) : boolean;  //kt added 5/16
function DBDialogFieldValuesSet(DFN, IEN8925, AVisitStr : string; Data : TStrings; var ErrStr : string) : boolean;  //kt added 5/16
procedure DBDialogFieldValuesDelete(DFN, IEN8925, AVistStr : string; var ErrStr : string);                      //kt added 5/16
function Get1DBFldValue(DFN, TemplateFldIEN: string; var ErrStr : string) : string;                             //kt added 5/16
procedure GetDBFieldsList(DFN, AVistStr : string; OutSL : TStringList);                                         //kt added 6/16
function HasDBFieldsData(DFN, AVistStr : string) : boolean;                                                     //kt added 6/16

implementation
uses
  StrUtils, uHTMLTools;  //kt added

var
  uUserTemplateDefaults: string = '';
  uCanEditDlgFldChecked: boolean = FALSE;
  uCanEditDlgFlds: boolean;

{ Template RPCs -------------------------------------------------------------- }

procedure GetTemplateRoots;
begin
  CallV('TIU TEMPLATE GETROOTS', [User.DUZ]);
end;

function IsUserTemplateEditor(TemplateID: string; UserID :Int64): boolean;
begin
  if StrToIntDef(TemplateID,0) > 0 then
    Result := (Piece(sCallV('TIU TEMPLATE ISEDITOR', [TemplateID, UserID]),U,1) = '1')
  else
    Result := FALSE;
end;

procedure GetTemplateChildren(ID: string);
begin
  if(ID = '') or (ID = '0') then
    RPCBrokerV.Results.Clear
  else
    CallV('TIU TEMPLATE GETITEMS', [ID]);
end;

procedure GetTemplateBoilerplate(ID: string);
begin
  if(ID = '') or (ID = '0') then
    RPCBrokerV.Results.Clear
  else
    CallV('TIU TEMPLATE GETBOIL', [ID]);
end;

procedure GetTemplateText(BoilerPlate: TStrings);
var
  i: integer;
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU TEMPLATE GETTEXT';
    Param[0].PType := literal;
    Param[0].Value := Patient.DFN;
    Param[1].PType := literal;
    Param[1].Value := Encounter.VisitStr;
    Param[2].PType := list;
    //kt HTML lines can be >1,000 chars in length.  So wrap, but add '{{NO-BR}}' so wrapping can be undone later.
    for i := 0 to BoilerPlate.Count-1 do if length(BoilerPlate[i])>=255 then begin  //kt added block 11/24/15
      WrapLongHTMLLines(BoilerPlate,255, NO_BR_TAG);
      break;
    end;
    for i := 0 to BoilerPlate.Count-1 do
      Param[2].Mult[IntToStr(i+1)+',0'] := BoilerPlate[i];
    CallBroker;
    RPCBrokerV.Results.Delete(0);
    FastAssign(RPCBrokerV.Results, BoilerPlate);
    RPCBrokerV.Results.Clear;
  end;
end;



function IsTemplateEditor(ID: string): boolean;
begin
  Result := (sCallV('TIU TEMPLATE ISEDITOR', [ID, User.DUZ]) = '1');
end;

//function SubSetOfTemplateOwners(const StartFrom: string; Direction: Integer): TStrings;
//begin
//  CallV('TIU TEMPLATE LISTOWNR', [StartFrom, Direction]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;
//end;

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
      if(j > 0) then
        Param[1].Mult[Fields.Names[i]] := copy(Fields[i],j+1,MaxInt);
    end;
    CallBroker;
    Result := RPCBrokerV.Results[0];
  end;
end;

function UpdateTemplate(ID: string; Fields: TStrings): string;
begin
  Result := UpdateTIURec('TIU TEMPLATE CREATE/MODIFY', ID, Fields);
end;

procedure UpdateChildren(ID: string; Children: TStrings);
var
  i: integer;

begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU TEMPLATE SET ITEMS';
    Param[0].PType := literal;
    Param[0].Value := ID;
    Param[1].PType := list;
    for i := 0 to Children.Count-1 do
      Param[1].Mult[IntToStr(i+1)] := Children[i];
    CallBroker;
  end;
end;

procedure DeleteTemplates(DelList: TStrings);
var
  i: integer;

begin
  if(DelList.Count > 0) then
  begin
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'TIU TEMPLATE DELETE';
      Param[0].PType := list;
      for i := 0 to DelList.Count-1 do
        Param[0].Mult[IntToStr(i+1)] := DelList[i];
      CallBroker;
    end;
  end;
end;

procedure GetObjectList;
begin
  CallV('TIU GET LIST OF OBJECTS', []);
end;

procedure GetAllowedPersonalObjects;
begin
  CallV('TIU TEMPLATE PERSONAL OBJECTS', []);
end;

procedure TestBoilerplate(BoilerPlate: TStrings);
var
  i: integer;

begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU TEMPLATE CHECK BOILERPLATE';
    Param[0].PType := list;
    for i := 0 to BoilerPlate.Count-1 do
      Param[0].Mult['2,'+IntToStr(i+1)+',0'] := BoilerPlate[i];
    CallBroker;
  end;
end;

function GetTemplateAccess(ID: string): integer;
begin
  Result := StrToIntDef(sCallV('TIU TEMPLATE ACCESS LEVEL', [ID, User.DUZ, Encounter.Location]), 0);
end;

function SubSetOfBoilerplatedTitles(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('TIU LONG LIST BOILERPLATED', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function GetTitleBoilerplate(TitleIEN: string): string;
begin
  CallV('TIU GET BOILERPLATE', [TitleIEN]);
  Result := RPCBrokerV.Results.Text;
end;

function GetUserTemplateDefaults(LoadFromServer: boolean = FALSE): string;
begin
  if(LoadFromServer) then
  uUserTemplateDefaults := sCallV('TIU TEMPLATE GET DEFAULTS', []);
  Result := uUserTemplateDefaults;
end;

procedure SetUserTemplateDefaults(Value: string; PieceNum: integer);
begin
  SetPiece(uUserTemplateDefaults, '/', PieceNum, Value);
end;

procedure SaveUserTemplateDefaults;
begin
  CallV('TIU TEMPLATE SET DEFAULTS', [uUserTemplateDefaults]);
end;

procedure LoadTemplateDescription(TemplateIEN: string);
begin
  CallV('TIU TEMPLATE GET DESCRIPTION', [TemplateIEN]);
end;

function GetTemplateAllowedReminderDialogs: TStrings;
var
  TmpList: TStringList;

begin
  CallV('TIU REMINDER DIALOGS', []);
  TmpList := TStringList.Create;
  try
    FastAssign(RPCBrokerV.Results, TmpList);
    SortByPiece(TmpList, U, 2);
    MixedCaseList(TmpList);
    FastAssign(TmpList, RPCBrokerV.Results);
  finally
    TmpList.Free;
  end;
  Result := RPCBrokerV.Results;
end;

function IsRemDlgAllowed(RemDlgIEN: string): integer;
// -1 = inactive or deleted, 0 = not in Param, 1 = allowed
begin
  Result := StrToIntDef(sCallV('TIU REM DLG OK AS TEMPLATE', [RemDlgIEN]),-1);
end;

function LockTemplate(const ID: string): boolean; // returns true if successful
begin
  Result := (sCallV('TIU TEMPLATE LOCK', [ID]) = '1')
end;

procedure UnlockTemplate(const ID: string);
begin
  CallV('TIU TEMPLATE UNLOCK', [ID]);
end;

function GetLinkedTemplateData(const Link: string): string;
begin
  Result := sCallV('TIU TEMPLATE GETLINK', [Link]);
end;

function SubSetOfAllTitles(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('TIU TEMPLATE ALL TITLES', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

{ Template Fields }

function SubSetOfTemplateFields(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('TIU FIELD LIST', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function LoadTemplateField(const DlgFld: string): TStrings;
begin
  CallV('TIU FIELD LOAD', [DlgFld]);
  Result := RPCBrokerV.Results;
end;

function LoadTemplateFieldByIEN(const DlgFld: string): TStrings;
begin
  CallV('TIU FIELD LOAD BY IEN', [DlgFld]);
  Result := RPCBrokerV.Results;
end;

function CanEditTemplateFields: boolean;
begin
  if(not uCanEditDlgFldChecked) then
  begin
    uCanEditDlgFldChecked := TRUE;
    uCanEditDlgFlds := sCallV('TIU FIELD CAN EDIT', []) = '1';
  end;
  Result := uCanEditDlgFlds;
end;

function UpdateTemplateField(const ID: string; Fields: TStrings): string;
begin
  Result := UpdateTIURec('TIU FIELD SAVE', ID, Fields);
end;

function LockTemplateField(const ID: string): boolean; // returns true if successful
begin
  Result := (sCallV('TIU FIELD LOCK', [ID]) = '1')
end;

procedure UnlockTemplateField(const ID: string);
begin
  CallV('TIU FIELD UNLOCK', [ID]);
end;

procedure DeleteTemplateField(const ID: string);
begin
  CallV('TIU FIELD DELETE', [ID]);
end;

function CallImportExportTemplateFields(FldList: TStrings; RPCName: string): TStrings;
var
  i: integer;

begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := RPCName;
    Param[0].PType := list;
    for i := 0 to FldList.Count-1 do
      Param[0].Mult[IntToStr(i+1)] := FldList[i];
    CallBroker;
  end;
  Result := RPCBrokerV.Results;
end;

function ExportTemplateFields(FldList: TStrings): TStrings;
begin
  Result := CallImportExportTemplateFields(FldList, 'TIU FIELD EXPORT');
end;

function ImportTemplateFields(FldList: TStrings): TStrings;
begin
  Result := CallImportExportTemplateFields(FldList, 'TIU FIELD IMPORT');
end;

procedure CheckTemplateFields(ResultString: TStrings);
begin
  CallV('TIU FIELD CHECK',[nil]);
  FastAssign(RPCBrokerV.Results, ResultString);
end;

function IsTemplateFieldNameUnique(const FldName, IEN: string): boolean;
begin
  Result := sCallV('TIU FIELD NAME IS UNIQUE', [FldName, IEN]) = '1';
end;

procedure Convert2LMText(Text: TStringList);
var
  i: integer;
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU FIELD DOLMTEXT';
    Param[0].PType := list;
    for i := 0 to Text.Count-1 do
      Param[0].Mult[IntToStr(i+1)+',0'] := Text[i];
    CallBroker;
  end;
  FastAssign(RPCBrokerV.Results, Text);
end;

function BuildTemplateFields(XMLString: TStrings): boolean;   //Simply builds XML fields on the server
var                                                           //in chunks.
  i,j,p1: integer;
  ok: boolean;

  procedure reset_broker;
  begin
    with RPCBrokerV do begin
      ClearParameters := True;
      RemoteProcedure := 'TIU FIELD LIST ADD';
      Param[0].PType := list;
    end;
  end;

begin
  ok := TRUE;
  with RPCBrokerV do
  begin
    reset_broker;
    j := 1;
    for i := 0 to XMLString.Count-1 do begin
      p1 := pos('<FIELD NAME="',XMLString[i]);
      if (p1 > 0) and (pos('">',copy(XMLString[i],p1+13,maxint)) > 0) then begin
        j := j + 1;
        if (j > 50) then begin
          j := 1;
          CallBroker;
          if pos('1',Results[0]) = 0 then begin
            ok := FALSE;
            break;
          end;//if
          reset_broker;
        end;//if
      end;//if
      Param[0].Mult[IntToStr(i+1)] := XMLString[i];
    end;//for
    if ok then begin
      CallBroker;
      if pos('1',Results[0]) = 0 then ok := FALSE;
    end;//if
  end;
  Result := ok;
end;

function ImportLoadedFields(ResultSet: TStrings): boolean;
begin
  Result := TRUE;
  CallV('TIU FIELD LIST IMPORT',[nil]);
  FastAssign(RPCBrokerV.Results, ResultSet);
  if ResultSet.Count < 1 then
    Result := FALSE;
end;

function DBDialgFldChannel(DFN, IEN8925, DT : string; Data : TStrings; var ErrStr : string) : boolean;
//kt added function 5/16
  //Format sending to server:
  //    DATA[0] = 'INFO^<DFN>^<IEN8925>^<DT>
  //                IEN8925 is only used when SET'ing a DB value
  //                DT is string in FilemanDT format
  // when reading
  //    DATA[#] = 'GET^<TEMPLATE FIELD IEN>^<any tag value>'
  // or when writing
  //    DATA[#] = 'SET^<TEMPLATE FIELD IEN>^<value of db control>^<any tag value>'
  // or when deleting
  //    DATA[#] = 'KILL    <-- kill all values with DFN and DT and IEN8925
  //
  //Expected format back from server:
  //     RESULT[0] = 1^OK  or -1^Error message
  //after reading
  //     RESULT[#]'VALUE^<TEMPLATE FIELD IEN>^<value of db control>^<any tag value>
  //        NOTE: any #13#0 (CRLF) characters in <value> will be come from server replaced as {{LF}}
  //or after writing
  //     RESULT[#]'STATUS^<TEMPLATE FIELD IEN>^<server message, if any>^<any tag value>
  // or when deleting
  //     RESULT[#]'STATUS^<TEMPLATE FIELD IEN>^<server message, if any>^<any tag value>
  //Function result: TRUE if success, FALSE if error.
  //Server code:  DBVALS^TMGDAT01
var  i: integer;
     ResultStr : string;
begin
  Result := false; //default to failure
  ErrStr := '';
  with RPCBrokerV do begin
    ClearParameters := True;
    RemoteProcedure := 'TMG DB CONTROL VALUES';
    Param[0].PType := list;
    Param[0].Mult['0'] := 'INFO^'+DFN+'^'+IEN8925+'^'+DT;
    for i := 0 to Data.Count-1 do
      Param[0].Mult[IntToStr(i+1)] := Data[i];
    ORNet.CallBroker;
    //RPCBrokerV.Call;
    Data.Assign(Results);
    if Data.Count = 0 then exit;
    ResultStr := Data.Strings[0]; Data.Delete(0);
    if ResultStr[1] <> '1' then begin
      ErrStr := piece(ResultStr,'^',2);
    end else begin
      if Data.Count < 1 then begin
        ErrStr := '(No data returned from server for DB controls)';
      end else begin
        Result := true;
      end;
    end;
  end;
end;

function DBDialogFieldValuesGet(DFN, AVisitStr : string; Data : TStrings; var ErrStr : string) : boolean;
//kt added function 5/16
  //Expected format back from server:
  //    RESULT[0] = '1^OK'  or '-1^Error message'
  //    RESULT[#] = 'VALUE^<TEMPLATE FIELD IEN>^<value of db control>^<any tag value>'
  //Function result: TRUE if success, FALSE if error.
  //Server code:  DBVALS^TMGDAT01
//e.g. of AVistStr: '6;3160523.175448;A'
var DT : string;
begin
  DT := piece(AVisitStr, ';', 2);
  Result := DBDialgFldChannel(DFN, '0', DT, Data, ErrStr);
end;

function DBDialogFieldValuesSet(DFN, IEN8925, AVisitStr : string; Data : TStrings; var ErrStr : string) : boolean;
  //Expected format of Data:
  //    Data.Strings[i]= 'SET^TemplateIEN^ControlValue'
  //           ControlValue should not contain '^' character.
  //Expected format back from server:
  //    RESULT[0] = '1^OK'  or '-1^Error message'
  //    RESULT[#] = 'STATUS^<TEMPLATE FIELD IEN>^<server message, if any>^<any tag value>'
  //Function result: TRUE if success, FALSE if error.
  //Server code:  DBVALS^TMGDAT01
//e.g. of AVistStr: '6;3160523.175448;A'
var DT : string;
begin
  DT := piece(AVisitStr, ';', 2);
  Result := DBDialgFldChannel(DFN, IEN8925, DT, Data, ErrStr);
end;

function Get1DBFldValue(DFN, TemplateFldIEN: string; var ErrStr : string) : string;
//kt added 5/19/16
var SL : TStringList;
    s, s0 : string;
begin
  Result := '';
  SL := TStringList.Create;
  SL.Add('GET^'+TemplateFldIEN);
  DBDialgFldChannel(DFN,'0', FloatToStr(DateTimeToFMDateTime(Now)), SL, ErrStr);
  if (SL.Count > 0) and (ErrStr = '') then begin
    s0 := SL.Strings[0];
    s := 'VALUE^'+TemplateFldIEN+'^';
    if LeftStr(s0, Length(s)) = s then begin
      Result := Piece(SL.Strings[0],'^',3)
    end;
  end;
  SL.Free;
end;

procedure GetDBFieldsList(DFN, AVistStr : string; OutSL : TStringList);
//kt added 6/16
//Get a list of fields that contain data for input data
var SL : TStringList;
    DT,ErrStr : string;
begin
  DT := piece(AVistStr, ';', 2);
  SL := TStringList.Create;
  SL.Add('GET^ALL');
  DBDialgFldChannel(DFN,'0', DT, SL, ErrStr);
  OutSL.Assign(SL);
  SL.Free;
end;

function HasDBFieldsData(DFN, AVistStr : string) : boolean;
//kt added 6/16
var SL : TStringList;
begin
  SL := TStringList.Create;
  GetDBFieldsList(DFN, AVistStr, SL);
  Result := (SL.Count > 0);
  SL.Free;
end;


procedure DBDialogFieldValuesDelete(DFN, IEN8925, AVistStr : string; var ErrStr : string);  //kt 5/16
//kt added 5/19/16
//e.g. of AVistStr: '6;3160523.175448;A'
var DT : string;
    SL : TStringList;
begin
  DT := piece(AVistStr, ';', 2);
  SL := TStringList.Create;
  SL.Add('KILL');
  DBDialgFldChannel(DFN, IEN8925, DT, SL, ErrStr);
  SL.Free;
end;

end.
