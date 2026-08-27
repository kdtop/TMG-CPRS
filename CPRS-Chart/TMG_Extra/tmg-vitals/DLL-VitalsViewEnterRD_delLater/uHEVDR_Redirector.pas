unit uHEVDR_Redirector;

interface

uses
  ShareMem,
  SysUtils,
  Classes,
  JNI;

type

TParamType = (literal, reference, list, undefined);
TRemoteProc = string[100];
TRpcVersion = string[255];         //to use TRpcVersionProperty editor use this type
TServer = string[255];             //to use TServerProperty editor use this type
TShowErrorMsgs = (semRaise, semQuiet);  // p13

EBrokerError = class(Exception)
public
  Action: string;
  Code: integer;
  Mnemonic: string;
end;

TString = class(TObject)
  Str: string;
end;

TVistaUser = class(TObject)
private
  FDUZ: string;
  FName: string;
  FStandardName: string;
  FDivision: String;
  FVerifyCodeChngd: Boolean;
  FTitle: string;
  FServiceSection: string;
  FLanguage: string;
  FDtime: string;
  procedure SetDivision(const Value: String);
  procedure SetDUZ(const Value: String);
  procedure SetName(const Value: String);
  procedure SetVerifyCodeChngd(const Value: Boolean);
  procedure SetStandardName(const Value: String);
  procedure SetTitle(const Value: string);
  procedure SetDTime(const Value: string);
  procedure SetLanguage(const Value: string);
  procedure SetServiceSection(const Value: string);
public
  property DUZ: String read FDUZ write SetDUZ;
  property Name: String read FName write SetName;
  property StandardName: String read FStandardName write SetStandardName;
  property Division: String read FDivision write SetDivision;
  property VerifyCodeChngd: Boolean read FVerifyCodeChngd write SetVerifyCodeChngd;
  property Title: string read FTitle write SetTitle;
  property ServiceSection: string read FServiceSection write SetServiceSection;
  property Language: string read FLanguage write SetLanguage;
  property DTime: string read FDTime write SetDTime;
end;

TMult = class(TComponent)
private
  FMultiple: TStringList;
  procedure ClearAll;
  function  GetCount: Word;
  function  GetFirst: string;
  function  GetLast: string;
  function  GetFMultiple(Index: string): string;
  function  GetSorted: boolean;
  procedure SetFMultiple(Index: string; value: string);
  procedure SetSorted(Value: boolean);
protected
public
  constructor Create(AOwner: TComponent); override;      {1.1T8}
  destructor Destroy; override;
  procedure Assign(Source: TPersistent); override;
  function Order(const StartSubscript: string; Direction: integer): string;
  function Position(const Subscript: string): longint;
  function Subscript(const Position: longint): string;
  property Count: Word read GetCount;
  property First: string read GetFirst;
  property Last: string read GetLast;
  property MultArray[I: string]: string
           read GetFMultiple write SetFMultiple; default;
  property Sorted: boolean read GetSorted write SetSorted;
end;

  TParamRecord = class(TComponent)
  private
    FMult: TMult;
    FValue: string;
    FPType: TParamType;

{
  *** DO NOT REMOVE SEEMINGLY USELESS SET METHODS ***  - JM
The syncronization of User, Patient and Encounter data with the
HealteVet Desktop data would sometimes requile RPC calls to be made
in the middle of when parameters were being set up for another RPC
call, such as when one of the parameters was a User, Patient or
Encounter property.  For example:

    Param[0].PType := literal;
    Param[0].Value := Patient.DFN;
    Param[1].PType := literal;
    Param[1].Value := Encounter.VisitStr;

Although the methods used to update the User, Patient and Encounter
data saved off the prior parameter values before making RPC calls,
the restoration of those values in the middle of the assignment
mechanism shown above, combined with a Delphi compile optimization,
prevented the Value property from receiving the new data.  The set
methods below prevent the Delphi compile optimization from making
this error.
}
    procedure SetMult(const Value: TMult);
    procedure SetPType(const Value: TParamType);
    procedure SetValue(const Value: string);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property Value: string read FValue write SetValue;
    property PType: TParamType read FPType write SetPType;
    property Mult: TMult read FMult write SetMult;
end;

TParams = class(TComponent)
private
  FParameters: TList;
  function GetCount: Word;
  function GetParameter(Index: integer): TParamRecord;
  procedure SetParameter(Index: integer; Parameter: TParamRecord);
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Assign(Source: TPersistent); override;
  procedure Clear;
  property Count: Word read GetCount;
  property ParamArray[I: integer]: TParamRecord
                      read GetParameter write SetParameter; default;
end;

THEVDRedirector = class(TComponent)
private
  procedure assertNotNull(javaObject: JObject; msg: String; code:integer);
  procedure assertNoException(msg: String; code:integer);
  function CallVistalink(optionContext: String; rpcName: string; params: TParams; timeout: integer): PChar;
protected
  FClearParameters: Boolean;
  FClearResults: Boolean;
  FConnected: Boolean;
  FConnecting: Boolean;
  FCurrentContext: String;
  FDebugMode: Boolean;
  FListenerPort: integer;
  FParams: TParams;
  FResults: TStrings;
  FRemoteProcedure: TRemoteProc;
  FRpcVersion: TRpcVersion;
  FServer: TServer;
  FSocket: integer;
  FRPCTimeLimit : integer;
  FKernelLogIn  : Boolean;
  FUser: TVistaUser;
  FShowErrorMsgs: TShowErrorMsgs;
  FRPCBError:     String;
  FOptionContext: String;
  FJVM: TJNIEnv;
  FCallingObjGRef: JObject;
protected
  procedure   SetClearParameters(Value: Boolean); virtual;
  procedure   SetClearResults(Value: Boolean); virtual;
  procedure   SetConnected(NewConnected: Boolean); virtual;
  procedure   SetResults(Value: TStrings); virtual;
  procedure   SetServer(Value: TServer); virtual;
  procedure   SetRPCTimeLimit(Value: integer); virtual;  //Screen changes to timeout.
  procedure   SetKernelLogIn(const Value: Boolean); virtual;
  procedure   SetUser(const Value: TVistaUser); virtual;
public
  property    Param: TParams read FParams write FParams;
  property    Socket: integer read FSocket;
  property    RPCTimeLimit : integer read FRPCTimeLimit write SetRPCTimeLimit;
  constructor Create(AOwner: TComponent); override;
  destructor  Destroy; override;
  procedure   Call; virtual;
  procedure   Loaded; override;
  procedure   lstCall(OutputBuffer: TStrings); virtual;
  function    CreateContext(context: string):boolean; virtual;
  function    pchCall: PChar; virtual;
  function    strCall: string; virtual;
  property    CurrentContext: String read FCurrentContext;
  property    User: TVistaUser read FUser write SetUser;
  property    RPCBError: String read FRPCBError write FRPCBError;
  property    OptionContext: String read FOptionContext write FOptionContext;
  property    JVM: TJNIEnv read FJVM write FJVM;
  property    CallingObj: JObject read FCallingObjGRef write FCallingObjGRef;
published
  property    ClearParameters: boolean read FClearParameters
              write SetClearParameters;
  property    ClearResults: boolean read FClearResults write SetClearResults;
  property    Connected: boolean read FConnected write SetConnected;
  property    DebugMode: boolean read FDebugMode write FDebugMode default False;
  property    ListenerPort: integer read FListenerPort write FListenerPort;
  property    Results: TStrings read FResults write SetResults;
  property    RemoteProcedure: TRemoteProc read FRemoteProcedure
              write FRemoteProcedure;
  property    RpcVersion: TRpcVersion read FRpcVersion write FRpcVersion;
  property    Server: TServer read FServer write SetServer;
  property    KernelLogIn: Boolean read FKernelLogIn write SetKernelLogIn;
  property    ShowErrorMsgs: TShowErrorMsgs read FShowErrorMsgs write FShowErrorMsgs default semRaise;
end;

implementation

uses
  Forms,
  ArrayListWrapper,
  OrderedMapWrapper,
  Controls;
  
const
  MIN_RPCTIMELIMIT: integer = 30;

function Iff(Condition: boolean; strTrue, strFalse: string): string;
begin
  if Condition then Result := strTrue else Result := strFalse;
end;

procedure TVistaUser.SetDivision(const Value: String);       // p13
begin
  FDivision := Value;
end;

procedure TVistaUser.SetDTime(const Value: string);          // p13
begin
  FDTime := Value;
end;

procedure TVistaUser.SetDUZ(const Value: String);             // p13
begin
  FDUZ := Value;
end;

procedure TVistaUser.SetLanguage(const Value: string);       // p13
begin
  FLanguage := Value;
end;

procedure TVistaUser.SetName(const Value: String);           // p13
begin
  FName := Value;
end;

procedure TVistaUser.SetServiceSection(const Value: string);  // p13
begin
  FServiceSection := Value;
end;

procedure TVistaUser.SetStandardName(const Value: String);    // p13
begin
  FStandardName := Value;
end;

procedure TVistaUser.SetTitle(const Value: string);           // p13
begin
  FTitle := Value;
end;

procedure TVistaUser.SetVerifyCodeChngd(const Value: Boolean);   // p13
begin
  FVerifyCodeChngd := Value;
end;

{---------------------- TParamRecord.Create -----------------------
Creates TParamRecord instance and automatically creates TMult.  The
name of Mult is also set in case it may be need if exception will be raised.
------------------------------------------------------------------}
constructor TParamRecord.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMult := TMult.Create(Self);
  FMult.Name := 'Mult';
  {note: FMult is destroyed in the SetClearParameters method}
end;

{-------------------------- TMult.Create --------------------------
------------------------------------------------------------------}
constructor TMult.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMultiple := TStringList.Create;
end;

{------------------------- TMult.Destroy --------------------------
------------------------------------------------------------------}
destructor TMult.Destroy;
begin
  ClearAll;
  FMultiple.Free;
  FMultiple := nil;
  inherited Destroy;
end;

{-------------------------- TMult.Assign --------------------------
All of the items from source object are copied one by one into the
target.  So if the source is later destroyed, target object will continue
to hold the copy of all elements, completely unaffected.
------------------------------------------------------------------}
procedure TMult.Assign(Source: TPersistent);
var
  I: integer;
  SourceStrings: TStrings;
  S: TString;
  SourceMult: TMult;
begin
  ClearAll;
  if Source is TMult then begin
    SourceMult := Source as TMult;
     try
      for I := 0 to SourceMult.FMultiple.Count - 1 do begin
        S := TString.Create;
        S.Str := (SourceMult.FMultiple.Objects[I] as TString).Str;
        Self.FMultiple.AddObject(SourceMult.FMultiple[I], S);
      end;
    except
    end;
  end

  else begin
    SourceStrings := Source as TStrings;
    for I := 0 to SourceStrings.Count - 1 do
      Self[IntToStr(I)] := SourceStrings[I];
  end;
end;

{------------------------- TMult.ClearAll -------------------------
One by one, all Mult items are freed.
------------------------------------------------------------------}
procedure TMult.ClearAll;
var
  I: integer;
begin
     for I := 0 to FMultiple.Count - 1 do begin
        FMultiple.Objects[I].Free;
        FMultiple.Objects[I] := nil;
     end;
     FMultiple.Clear;
end;

{------------------------- TMult.GetCount -------------------------
Returns the number of elements in the multiple
------------------------------------------------------------------}
function TMult.GetCount: Word;
begin
  Result := FMultiple.Count;
end;

{------------------------- TMult.GetFirst -------------------------
Returns the subscript of the first element in the multiple
------------------------------------------------------------------}
function TMult.GetFirst: string;
begin
  if FMultiple.Count > 0 then Result := FMultiple[0]
  else Result := '';
end;

{------------------------- TMult.GetLast --------------------------
Returns the subscript of the last element in the multiple
------------------------------------------------------------------}
function TMult.GetLast: string;
begin
  if FMultiple.Count > 0 then Result := FMultiple[FMultiple.Count - 1]
  else Result := '';
end;

{---------------------- TMult.GetFMultiple ------------------------
Returns the VALUE of the element whose subscript is passed.
------------------------------------------------------------------}
function TMult.GetFMultiple(Index: string): string;
var
  S: TString;
  BrokerComponent,ParamRecord: TComponent;
  I: integer;
  strError: string;
begin
  try
    S := TString(FMultiple.Objects[FMultiple.IndexOf(Index)]);
  except
    on EListError do begin
       {build appropriate error message}
       strError := iff(Self.Name <> '', Self.Name, 'TMult_instance');
       strError := strError + '[' + Index + ']' + #13#10 + 'is undefined';
       try
         ParamRecord := Self.Owner;
         BrokerComponent := Self.Owner.Owner.Owner;
         if (ParamRecord is TParamRecord) and (BrokerComponent is THEVDRedirector) then begin
           I := 0;
           {if there is an easier way to figure out which array element points
           to this instance of a multiple, use it}   // p13
           while THEVDRedirector(BrokerComponent).Param[I] <> ParamRecord do inc(I);
           strError := '.Param[' + IntToStr(I) + '].' + strError;
           strError := iff(BrokerComponent.Name <> '', BrokerComponent.Name,
                           'THEVDRedirector_instance') + strError;
         end;
       except
       end;
       raise Exception.Create(strError);
    end;
  end;
  Result := S.Str;
end;

{---------------------- TMult.SetGetSorted ------------------------
------------------------------------------------------------------}
function  TMult.GetSorted: boolean;
begin
  Result := FMultiple.Sorted;
end;

{---------------------- TMult.SetFMultiple ------------------------
Stores a new element in the multiple.  FMultiple (TStringList) is the
structure, which is used to hold the subscript and value pair.  Subscript
is stored as the String, value is stored as an object of the string.
------------------------------------------------------------------}
procedure TMult.SetFMultiple(Index: string; Value: string);
var
  S: TString;
  Pos: integer;
begin
  Pos := FMultiple.IndexOf(Index);       {see if this subscript already exists}
  if Pos = -1 then begin                 {if subscript is new}
     S := TString.Create;                {create string object}
     S.Str := Value;                     {put value in it}
     FMultiple.AddObject(Index, S);      {add it}
   end
  else
     TString(FMultiple.Objects[Pos]).Str := Value; { otherwise replace the value}
end;

{---------------------- TMult.SetSorted ------------------------
------------------------------------------------------------------}
procedure TMult.SetSorted(Value: boolean);
begin
  FMultiple.Sorted := Value;
end;

{-------------------------- TMult.Order --------------------------
Returns the subscript string of the next or previous element from the
StartSubscript.  This is very similar to the $O function available in M.
Null string ('') is returned when reaching beyong the first or last
element, or when list is empty.
Note: A major difference between the M $O and this function is that
      in this function StartSubscript must identify a valid subscript
      in the list.
------------------------------------------------------------------}
function TMult.Order(const StartSubscript: string; Direction: integer): string;
var
  Index: longint;
begin
  Result := '';
  if StartSubscript = '' then
     if Direction > 0 then Result := First
     else Result := Last
  else begin
     Index := Position(StartSubscript);
     if Index > -1 then
        if (Index < (Count - 1)) and (Direction > 0) then
           Result := FMultiple[Index + 1]
        else if (Index > 0) and (Direction < 0) then
           Result := FMultiple[Index - 1];
  end
end;

{------------------------- TMult.Position -------------------------
Returns the long integer value which is the index position of the
element in the list.  Opposite of TMult.Subscript().  Remember that
the list is 0 based!
------------------------------------------------------------------}
function TMult.Position(const Subscript: string): longint;
begin
  Result := FMultiple.IndexOf(Subscript);
end;

{------------------------ TMult.Subscript -------------------------
Returns the string subscript of the element whose position in the list
is passed in.  Opposite of TMult.Position().  Remember that the list is 0 based!
------------------------------------------------------------------}
function TMult.Subscript(const Position: longint): string;
begin
  Result := '';
  if (Position > -1) and (Position < Count) then
     Result := FMultiple[Position];
end;

{------------------------- TParams.Create -------------------------
------------------------------------------------------------------}
constructor TParams.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParameters := TList.Create;   {for now, empty list}
end;

{------------------------ TParams.Destroy -------------------------
------------------------------------------------------------------}
destructor TParams.Destroy;
begin
  Clear;                         {clear the Multiple first!}
  FParameters.Free;
  FParameters := nil;
  inherited Destroy;
end;

{------------------------- TParams.Assign -------------------------
------------------------------------------------------------------}
procedure TParams.Assign(Source: TPersistent);
var
  I: integer;
  SourceParams: TParams;
begin
  Self.Clear;
  SourceParams := Source as TParams;
  for I := 0 to SourceParams.Count - 1 do begin
    Self[I].Value := SourceParams[I].Value;
    Self[I].PType := SourceParams[I].PType;
    Self[I].Mult.Assign(SourceParams[I].Mult);
  end
end;

{------------------------- TParams.Clear --------------------------
------------------------------------------------------------------}
procedure TParams.Clear;
var
  ParamRecord: TParamRecord;
  I: integer;
begin
  if FParameters <> nil then begin
    for I := 0 to FParameters.Count - 1 do begin
      ParamRecord := TParamRecord(FParameters.Items[I]);
      if ParamRecord <> nil then begin  //could be nil if params were skipped by developer
        ParamRecord.FMult.Free;
        ParamRecord.FMult := nil;
        ParamRecord.Free;
      end;
    end;
    FParameters.Clear;             {release FParameters TList}
  end;
end;

{------------------------ TParams.GetCount ------------------------
------------------------------------------------------------------}
function TParams.GetCount: Word;
begin
  if FParameters = nil then Result := 0
  else Result := FParameters.Count;
end;

{---------------------- TParams.GetParameter ----------------------
------------------------------------------------------------------}
function TParams.GetParameter(Index: integer): TParamRecord;
begin
  if Index >= FParameters.Count then             {if element out of bounds,}
     while FParameters.Count <= Index do
       FParameters.Add(nil);                     {setup place holders}
  if FParameters.Items[Index] = nil then begin   {if just a place holder,}
     {point it to new memory block}
     FParameters.Items[Index] := TParamRecord.Create(Self);
     TParamRecord(FParameters.Items[Index]).PType := undefined; {initialize}
  end;
  Result := FParameters.Items[Index];            {return requested parameter}
end;

{---------------------- TParams.SetParameter ----------------------
------------------------------------------------------------------}
procedure TParams.SetParameter(Index: integer; Parameter: TParamRecord);
begin
  if Index >= FParameters.Count then             {if element out of bounds,}
     while FParameters.Count <= Index do
       FParameters.Add(nil);                     {setup place holders}
  if FParameters.Items[Index] = nil then         {if just a place holder,}
     FParameters.Items[Index] := Parameter;      {point it to passed parameter}
end;

{----------------- THEVDRedirector.SetClearParameters ------------------
------------------------------------------------------------------}
procedure THEVDRedirector.SetClearParameters(Value: Boolean);
begin
  if Value then FParams.Clear;
  FClearParameters := Value;
end;

{------------------- THEVDRedirector.SetClearResults -------------------
------------------------------------------------------------------}
procedure THEVDRedirector.SetClearResults(Value: Boolean);
begin
  if Value then begin   {if True}
     FResults.Clear;
  end;
  FClearResults := Value;
end;

{---------------------- THEVDRedirector.SetResults ---------------------
------------------------------------------------------------------}
procedure THEVDRedirector.SetResults(Value: TStrings);
begin
  FResults.Assign(Value);
end;

{----------------------- THEVDRedirector.SetRPCTimeLimit -----------------
------------------------------------------------------------------}
procedure   THEVDRedirector.SetRPCTimeLimit(Value: integer);
begin
  if Value <> FRPCTimeLimit then
    if Value > MIN_RPCTIMELIMIT then
      FRPCTimeLimit := Value
    else
      FRPCTimeLimit := MIN_RPCTIMELIMIT;
end;

{--------------------- THEVDRedirector.SetConnected --------------------
------------------------------------------------------------------}
procedure THEVDRedirector.SetConnected(NewConnected: Boolean);
begin
end;

procedure THEVDRedirector.SetServer(Value: TServer);
begin
end;

procedure THEVDRedirector.SetKernelLogIn(const Value: Boolean);
begin
end;

procedure THEVDRedirector.SetUser(const Value: TVistaUser);
begin
  FUser := Value;
end;

constructor THEVDRedirector.Create(AOwner: TComponent);
begin
  FComponentStyle := [csInheritable];
  if AOwner <> nil then AOwner.InsertComponent(Self);

  FClearParameters := true;
  FClearResults := true;
  FConnected := true;
  FDebugMode := False;
  FParams := TParams.Create(Self);
  FResults := TStringList.Create;
  FServer := 'Vistalink-via-HEVD';
  FListenerPort := -1;
  FRpcVersion := '0';
  FRPCTimeLimit := MIN_RPCTIMELIMIT;
  FKernelLogin := True;
  FUser := TVistaUser.Create;
  FShowErrorMsgs := semRaise;
  Application.ProcessMessages;
end;

{----------------------- THEVDRedirector.Destroy -----------------------
------------------------------------------------------------------}
destructor THEVDRedirector.Destroy;
begin
  Connected := False;
  FParams.Free;
  FParams := nil;
  FResults.Free;
  FResults := nil;
  inherited Destroy;
end;

{------------------------- THEVDRedirector.Call ------------------------
------------------------------------------------------------------}
procedure THEVDRedirector.Call;
var
  ResultBuffer: TStrings;
begin
  ResultBuffer := nil;
  try
    ResultBuffer := TStringList.Create;
    if ClearResults then ClearResults := True;
    lstCall(ResultBuffer);
    Self.Results.AddStrings(ResultBuffer);
  finally
    ResultBuffer.Free;
  end;
end;

{------------------------ THEVDRedirector.Loaded -----------------------
------------------------------------------------------------------}
procedure THEVDRedirector.Loaded;
begin
  inherited Loaded;
end;

function getException(msg: String; code:integer; mneumonic:String):EBrokerError;
var
  ex: EBrokerError;
begin
  ex := EBrokerError.Create(msg);
  ex.Action := msg;
  ex.Code := code;
  ex.Mnemonic := mneumonic;
  Result := ex;
end;

procedure THEVDRedirector.assertNotNull(javaObject: JObject; msg: String; code:integer);
begin
  if (not Assigned(javaObject)) then begin
    JVM.ExceptionDescribe;
    JVM.ExceptionClear;
    raise getException(msg,code,'J');
  end;
end;

procedure THEVDRedirector.assertNoException(msg: String; code:integer);
begin
   if JVM.ExceptionCheck then begin
     JVM.ExceptionDescribe;
     JVM.ExceptionClear;
     raise getException(msg, code, 'J');
  end;
end;

function THEVDRedirector.CallVistalink(optionContext: String; rpcName: string; params: TParams; timeout: integer): PChar;
  var
    i,j:integer;
    methodID:JMethodID;
    jRpcName: JString;
    jOptionName: JString;
    jTimeout: JInt;
    jResult: JString;
    jCopy: JBoolean;
    paramRecord: TParamRecord;
    jParamObject: JObject;
    jClazz: JClass;
    javaParamArray: TArrayListWrapper;
    javaItemArray: TOrderedMapWrapper;
    jArrayLst: JObject;

  begin
    if not assigned(JVM) then
      raise getException('Java:JVM link not available.',9000,'J');
    methodID := JVM.GetMethodID(JVM.GetObjectClass(CallingObj), 'callRpc', '(Ljava/lang/String;Ljava/util/List;Ljava/lang/String;I)Ljava/lang/String;');
    if not Assigned(methodID) then begin
      JVM.ExceptionClear;
      raise getException('Java:Cannot get reference to function "getRpc".',9010,'J');
    end;
    jRpcName := JVM.StringToJString(PChar(rpcName));
    assertNotNull(jRpcName, 'Java:Cannot convert RPC name.',9020);
    jOptionName := JVM.StringToJString(PChar(optionContext));
    assertNotNull(jOptionName, 'Java:Cannot convert option name.', 9030);
    jTimeout := timeout;

    javaParamArray := TArrayListWrapper.Create(JVM);
    for i := 0 to params.Count-1 do begin
      paramRecord := params.ParamArray[i];
      jParamObject := nil;
      case paramRecord.PType of
        literal: begin
                   jParamObject := JVM.StringToJString(PChar(paramRecord.Value));
                   assertNotNull(jParamObject,'Java:Could not get parameter value string.',9045);
                 end;
        reference: begin
                     jClazz := JVM.FindClass('gov/va/med/foundations/rpc/RpcReferenceType');
                     assertNotNull(jClazz,'Java:Could not get RpcReferenceType class',9045);
                     jParamObject := JVM.NewObject(jClazz,JVM.GetMethodID(jClazz,'<init>','(Ljava/lang/String;)V'),[JVM.StringToJString(PChar(paramRecord.Value))]);
                     assertNotNull(jParamObject,'Java:Could not create RpcReferenceType',9045);
                   end;
        list: begin
                javaItemArray := TOrderedMapWrapper.Create(JVM);
                for j := 0 to paramRecord.Mult.Count-1 do begin
                  javaItemArray.Put(JVM.StringToJString(PChar(paramRecord.Mult.Subscript(j))),JVM.StringToJString(PChar(paramRecord.Mult.MultArray[paramRecord.Mult.Subscript(j)])));
                end;
                jParamObject := javaItemArray.JavaReference;
                javaItemArray.Free;
              end;
      end;

      if Assigned(jParamObject) then begin
        javaParamArray.Add(jParamObject);
      end;

    end;

    jArrayLst := javaParamArray.JavaReference;
    javaParamArray.Free;
    jResult := JVM.CallObjectMethod(CallingObj,methodID,[jRpcName,jArrayLst,jOptionName,jTimeout]);
    if not Assigned(jResult) or (JVM.ExceptionCheck) then begin
      if JVM.ExceptionCheck then begin
        JVM.ExceptionDescribe;
        JVM.ExceptionClear;
      end;
      raise getException('Java:There was an error processing the "' + rpcName + '" M call.',9100,'J');
    end;
    jCopy := JNI_True;
    Result := StrNew(JVM.GetStringUTFChars(jResult,jCopy));
end;

function tCall(rpcBroker: THEVDRedirector;
               hSocket: integer; {unused}
               rpcName, rpcVersion: String;
               Parameters: TParams;
               TimeOut: integer): PChar;
  var
    ChangeCursor: boolean;
  begin
    if Screen.Cursor = crDefault then
      ChangeCursor  := True
    else
      ChangeCursor := False;

    if ChangeCursor then
      Screen.Cursor := crHourGlass;

    Result := rpcBroker.CallVistalink(rpcBroker.OptionContext, rpcName, Parameters, TimeOut);
    if ChangeCursor then
      Screen.Cursor := crDefault;

  end;
  
{----------------------- THEVDRedirector.lstCall -----------------------
------------------------------------------------------------------}
procedure THEVDRedirector.lstCall(OutputBuffer: TStrings);
var
  ManyStrings: PChar;
begin
  ManyStrings := pchCall;            {make the call}
  OutputBuffer.SetText(ManyStrings); {parse result of call, format as list}
  StrDispose(ManyStrings);           {raw result no longer needed, get back mem}
end;

function THEVDRedirector.pchCall: PChar;
var
  pchRemoteProc: PChar;
  BrokerError: EBrokerError;
begin
  RPCBError := '';
  Connected := True;
  pchRemoteProc := nil;
  BrokerError := nil;
  try
    pchRemoteProc := StrAlloc(Length(RemoteProcedure)+1);
    StrPCopy(pchRemoteProc, Self.RemoteProcedure);

    Result := nil;

    try
      Result := tCall(Self, Socket, RemoteProcedure, RpcVersion, Param, FRPCTimeLimit);
    except
      on Etemp: EBrokerError do
        with Etemp do begin                             //save copy of error
          BrokerError := EBrokerError.Create(message);  //field by field
          BrokerError.Action := Action;
          BrokerError.Code := Code;
          BrokerError.Mnemonic := Mnemonic;
          Result := StrNew('');
          if ((Code >= 10050)and(Code <=10058))or(Action = 'connection lost') then
          begin
            Connected := False;
          end;
        end;
    end;

  finally
    StrDispose(pchRemoteProc);
    if ClearParameters then ClearParameters := True;
  end;
  if Result = nil then Result := StrNew('');
  if BrokerError <> nil then
  begin
    FRPCBError := BrokerError.Message;
      Raise BrokerError;
  end;

end;

{----------------------- THEVDRedirector.strCall -----------------------
------------------------------------------------------------------}
function THEVDRedirector.strCall: string;
var
  ResultString: PChar;
begin
  ResultString := pchCall;           {make the call}
  Result := StrPas(ResultString);    {convert and present as Pascal string}
  StrDispose(ResultString);          {raw result no longer needed, get back mem}
end;

function THEVDRedirector.CreateContext(context: string): boolean;
begin
  Result := true;
end;

//  *** DO NOT REMOVE SEEMINGLY USELESS SET METHODS ***  - JM
// See description in class definition.

procedure TParamRecord.SetMult(const Value: TMult);
begin
  FMult := Value;
end;

procedure TParamRecord.SetPType(const Value: TParamType);
begin
  FPType := Value;
end;

procedure TParamRecord.SetValue(const Value: string);
begin
  FValue := Value;
end;

end.
