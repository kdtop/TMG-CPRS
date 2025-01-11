unit ORNet;

 (*
 NOTE: The original version of this file may be obtained freely from the VA.

 This modified version of the file is Copyright 6/23/2015 Kevin S. Toppenberg, MD
 --------------------------------------------------------------------

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 == Alternatively, at user's choice, GPL license below may be used ===

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may view details of the GNU General Public License at this URL:
 http://www.gnu.org/licenses/
 *)



{$DEFINE CCOWBROKER}

interface

uses SysUtils, Windows, Classes, Forms, Controls, ORFn, TRPCB, RPCConf1, Dialogs
{$IFDEF CCOWBROKER}, CCOWRPCBroker {$ENDIF} ;  //, SharedRPCBroker;
        //, SharedRPCBroker;


procedure SetBrokerServer(const AName: string; APort: Integer; WantDebug: Boolean);
function AuthorizedOption(const OptionName: string): Boolean;
function ConnectToServer(const OptionName: string): Boolean;
function MRef(glvn: string): string;
procedure CallV(const RPCName: string; const AParam: array of const);
function sCallV(const RPCName: string; const AParam: array of const): string;
procedure tCallV(ReturnData: TStrings; const RPCName: string; const AParam: array of const);
function UpdateContext(NewContext: string): boolean;
function IsBaseContext: boolean;
procedure CallBrokerInContext;
procedure CallBroker;
function RetainedRPCCount: Integer;
function IndexOfRPCID(ID : integer) : integer;
function IDOfRPCIndex(Index : integer) : integer;
procedure SetRetainedRPCMax(Value: Integer);
function GetRPCMax: integer;
procedure LoadRPCData(Dest: TStrings; ID: Integer);
function AccessRPCDataByIndex(Index : integer; var ID: Integer) : TStringList; //kt 9/9/23 added  -- Caller DOESN'T own object
function AccessRPCData(ID: Integer) : TStringList; //kt 9/11 added  -- Caller DOESN'T own object
function RPCDataChanged : boolean; //kt 9/23
procedure SetRPCDataAsReviewed; //kt 9/23
function PrevRPCDataID(CurrentID : integer) : integer; //kt
function NextRPCDataID(CurrentID : integer) : integer; //kt
function DottedIPStr: string;
procedure CallRPCWhenIdle(CallProc: TORIdleCallProc; Msg: String);
function ShowRPCList: Boolean;
procedure RPCCallsClear;  //kt 9/11 added
function RPCBrokerBusy : boolean; //kt added 11/4/21
procedure EnsureBroker;

(*
function pCallV(const RPCName: string; const AParam: array of const): PChar;
procedure wCallV(AControl: TControl; const RPCName: string; const AParam: array of const);
procedure WrapWP(Buf: pChar);
*)

var
{$IFDEF CCOWBROKER}
  RPCBrokerV: TCCOWRPCBroker;
{$ELSE}
  RPCBrokerV: TRPCBroker;
  //RPCBrokerV: TSharedRPCBroker;
{$ENDIF}
  RPCLastCall: string;

  AppStartedCursorForm: TForm = nil;
  FilteredRPCCalls : TStringList;  //kt 9/11 Any RPC calls with names held in this list held will not be logged

implementation

uses
  DateUtils, //kt 9/11
  Winsock;

type
  TRPCCallList = class(TStringList)  //kt added class 9/9/23
    //The purpose of this class is to all each RPC call data record to have an ID
    //   that doesn't change when the list fills up and old records start getting
    //   deleted.
    //NOTE: obj.strings[i] will hold ID value
    //      obj.objects[i] will hold pointer to TStringList for 1 RPC call
    private
      FLastID : integer;
      FReviewedID : integer;
      function GetNextID : integer;
      function GetSL(ID : integer) : TStringList;
      function GetSLByIndex(Index : integer) : TStringList;
    public
      constructor Create();
      destructor Destroy();
      function Add(AStringList : TStringList) : integer;  //returns ID
      procedure DeleteAndFree(ID : Integer);  //this will delete entry and free contained TStringList, if ID is valid;
      procedure DeleteAndFreeIndex(Index : integer);
      procedure ClearAndFree;
      procedure SetAsReviewed;
      function ModifiedSinceLastReview : boolean;
      function IndexOfID(ID : integer): integer;
      function IDofIndex(index : integer) : integer;
      property ItemsByIndex[AnIndex : Integer]: TStringList read GetSLByIndex;
      property Items[ID: Integer]: TStringList read GetSL;
      property LastID : integer read FLastID;
  end;

const
  // *** these are constants from RPCBErr.pas, will broker document them????
  XWB_M_REJECT =  20000 + 2;  // M error
  XWB_BadSignOn = 20000 + 4;  // SignOn 'Error' (happens when cancel pressed)

var
  //kt uCallList: TList;
  TMGCallList : TRPCCallList; //kt 9/9/23
  uMaxCalls: Integer;
  uShowRPCs: Boolean;
  uBaseContext: string = '';
  uCurrentContext: string = '';
  TMGRPCCallInProcess : boolean; //kt 7/2018 //Variable to signal busy status.  Access via RPCBrokerBusy

  //=====================================================================================
  //=====================================================================================

  constructor TRPCCallList.Create();
  //kt added 9/2023
  begin
    inherited Create;
    FLastID := -1;
    SetAsReviewed;
  end;

  destructor TRPCCallList.Destroy();
  begin
    ClearAndFree;
    inherited Destroy;
  end;

  function TRPCCallList.GetNextID : integer;
  //kt added 9/2023
  begin
    inc(FLastID);
    result := FLastID;
  end;

  function TRPCCallList.Add(AStringList : TStringList) : integer;  //returns ID
  //kt added 9/2023
  var ID : integer;
  begin
    ID := GetNextID;
    Self.AddObject(IntToStr(ID), AStringList);
    result := ID;
  end;

  function TRPCCallList.IndexOfID(ID : integer): integer;
  begin
    result := Self.IndexOf(IntToStr(ID));
  end;

  function TRPCCallList.IDofIndex(index : integer) : integer;
  var s : string;
  begin
    if (index >= 0) and (index < self.Count) then begin
      s := self.Strings[index];
      result := StrToIntDef(s, -1);
    end else begin
      result := -1;
    end;
  end;

  function TRPCCallList.GetSLByIndex(Index : integer) : TStringList;
  begin
    if (index >= 0) and (index < self.Count) then begin
      result := TStringList(self.Objects[index]);
    end else begin
      result := nil;
    end;
  end;

  function TRPCCallList.GetSL(ID : integer) : TStringList;
  //kt added 9/2023
  var index : integer;
  begin
    index := IndexOfID(ID);
    if index >= 0 then begin
      result := TStringList(Self.Objects[index]);
    end else begin
      result := nil;
    end;
  end;

  procedure TRPCCallList.SetAsReviewed;
  begin
    FReviewedID := FLastID;
  end;

  function TRPCCallList.ModifiedSinceLastReview : boolean;
  begin
    result := (FReviewedID <> FLastID);
  end;

  procedure TRPCCallList.DeleteAndFreeIndex(Index : integer);
  //kt added 9/2023
  var SL : TStringList;
  begin
    if (Index < 0) or (Index >= Self.Count) then exit;
    SL := TStringList(Self.Objects[Index]);
    SL.Free;
    Self.Delete(Index);
  end;

  procedure TRPCCallList.DeleteAndFree(ID : Integer);  //this will delete entry and free contained TStringList;
  //kt added 9/2023
  var index : integer;
  begin
    index := Self.IndexOf(IntToStr(ID));
    if index < 0 then exit;
    DeleteAndFreeIndex(index);
  end;

  procedure TRPCCallList.ClearAndFree;
  //kt added 9/2023
  var index : integer;
      SL : TStringList;
  begin
    for index := self.Count-1 downto 0 do begin
      SL := TStringList(self.objects[index]);
      SL.Free;
    end;
    inherited Clear;
    FLastID := -1;
  end;

  //=====================================================================================
  //=====================================================================================

function RPCBrokerBusy : boolean;
//kt added 11/4/21
begin
  Result := TMGRPCCallInProcess;
end;

{ private procedures and functions ---------------------------------------------------------- }

procedure EnsureBroker;
{ ensures that a broker object has been created - creates & initializes it if necessary }
begin
  if RPCBrokerV = nil then
  begin
{$IFDEF CCOWBROKER}
    RPCBrokerV := TCCOWRPCBroker.Create(Application);
{$ELSE}
    RPCBrokerV := TRPCBroker.Create(Application);
    //RPCBrokerV := TSharedRPCBroker.Create(Application);
{$ENDIF}
    with RPCBrokerV do
    begin
      KernelLogIn := True;
      Login.Mode  := lmAppHandle;
      ClearParameters := True;
      ClearResults := True;
      DebugMode := False;
    end;
  end;
end;

procedure SetList(AStringList: TStrings; ParamIndex: Integer);
{ places TStrings into RPCBrokerV.Mult[n], where n is a 1-based (not 0-based) index }
var
  i: Integer;
begin
  with RPCBrokerV.Param[ParamIndex] do
  begin
    PType := list;
    with AStringList do for i := 0 to Count - 1 do Mult[IntToStr(i+1)] := Strings[i];
  end;
end;

procedure SetParams(const RPCName: string; const AParam: array of const);
{ takes the params (array of const) passed to xCallV and sets them into RPCBrokerV.Param[i] }
const
  BoolChar: array[boolean] of char = ('0', '1');
var
  i: integer;
  TmpExt: Extended;
begin
  RPCLastCall := RPCName + ' (SetParam begin)';
  if Length(RPCName) = 0 then raise Exception.Create('No RPC Name');
  EnsureBroker;
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := RPCName;
    for i := 0 to High(AParam) do with AParam[i] do
    begin
      Param[i].PType := literal;
      case VType of
      vtInteger:    Param[i].Value := IntToStr(VInteger);
      vtBoolean:    Param[i].Value := BoolChar[VBoolean];
      vtChar:       if VChar = #0 then
                      Param[i].Value := ''
                    else
                      Param[i].Value := VChar;
      //vtExtended:   Param[i].Value := FloatToStr(VExtended^);
      vtExtended:   begin
                      TmpExt := VExtended^;
                      if(abs(TmpExt) < 0.0000000000001) then TmpExt := 0;
                      Param[i].Value := FloatToStr(TmpExt);
                    end;
      vtString:     with Param[i] do
                    begin
                      Value := VString^;
                      if (Length(Value) > 0) and (Value[1] = #1) then
                      begin
                        Value := Copy(Value, 2, Length(Value));
                        PType := reference;
                      end;
                    end;
      vtPChar:      Param[i].Value := StrPas(VPChar);
      vtPointer:    if VPointer = nil
                      then ClearParameters := True {Param[i].PType := null}
                      else raise Exception.Create('Pointer type must be nil.');
      vtObject:     if VObject is TStrings then SetList(TStrings(VObject), i);
      vtAnsiString: with Param[i] do
                    begin
                      Value := string(VAnsiString);
                      if (Length(Value) > 0) and (Value[1] = #1) then
                      begin
                        Value := Copy(Value, 2, Length(Value));
                        PType := reference;
                      end;
                    end;
      vtInt64:      Param[i].Value := IntToStr(VInt64^);
        else raise Exception.Create('Unable to pass parameter type to Broker.');
      end; {case}
    end; {for}
  end; {with}
  RPCLastCall := RPCName + ' (SetParam end)';
end;

{ public procedures and functions ----------------------------------------------------------- }

function UpdateContext(NewContext: string): boolean;
begin
  if NewContext = uCurrentContext then
    Result := TRUE
  else
  begin
    Result := RPCBrokerV.CreateContext(NewContext);
    if Result then
      uCurrentContext := NewContext
    else
    if (NewContext <> uBaseContext) and RPCBrokerV.CreateContext(uBaseContext) then
      uCurrentContext := uBaseContext
    else
      uCurrentContext := '';
  end;
end;

function IsBaseContext: boolean;
begin
  Result := ((uCurrentContext = uBaseContext) or (uCurrentContext = ''));
end;

procedure CallBrokerInContext;
var
  AStringList: TStringList;
  i, j: Integer;
  x, y: string;
  Time1,Time2 : TDateTime; //kt 9/11
  TMGFiltered : boolean; //kt 9/11

begin
  if TMGRPCCallInProcess then begin  //kt 7/10/18
    ShowMessage('Warning: RPC "'+RPCBrokerV.RemoteProcedure+'"'+CRLF+
                'being called in midst of another RPC call.');
  end;
  TMGRPCCallInProcess := true; //kt
  try
    RPCLastCall := RPCBrokerV.RemoteProcedure + ' (CallBroker begin)';
    if uShowRPCs then StatusText(RPCBrokerV.RemoteProcedure);
    with RPCBrokerV do if not Connected then begin  // happens if broker connection is lost
      ClearResults := True;
      Exit;
    end;
    {//kt 
    if uCallList.Count = uMaxCalls then begin
      AStringList := uCallList.Items[0];
      AStringList.Free;
      uCallList.Delete(0);
    end;
    }
    if TMGCallList.Count = uMaxCalls then begin  //kt added
      TMGCallList.DeleteAndFreeIndex(0);
    end;
    AStringList := TStringList.Create;
    TMGFiltered := (FilteredRPCCalls.IndexOf(RPCBrokerV.RemoteProcedure) >= 0); //kt 9/11
    AStringList.Add(RPCBrokerV.RemoteProcedure);
    if uCurrentContext <> uBaseContext then
      AStringList.Add('Context: ' + uCurrentContext);
    Time1 := GetTime;                                  //kt 9/11
    AStringList.Add('Called at: '+ TimeToStr(Time1));  //kt 9/11
    AStringList.Add(' ');
    AStringList.Add('Params ------------------------------------------------------------------');
    with RPCBrokerV do for i := 0 to Param.Count - 1 do
    begin
      case Param[i].PType of
      //global:    x := 'global';
      list:      x := 'list';
      literal:   x := 'literal';
      //null:      x := 'null';
      reference: x := 'reference';
      undefined: x := 'undefined';
      //wordproc:  x := 'wordproc';
      end;
      AStringList.Add(x + #9 + Param[i].Value);
      if Param[i].PType = list then begin
        for j := 0 to Param[i].Mult.Count - 1 do begin
          x := Param[i].Mult.Subscript(j);
          y := Param[i].Mult[x];
          AStringList.Add(#9 + '(' + x + ')=' + y);
        end;
      end;
    end; {with...for}
    //RPCBrokerV.Call;
    try
      RPCBrokerV.Call;
    except
      // The broker erroneously sets connected to false if there is any error (including an
      // error on the M side). It should only set connection to false if there is no connection.
      on E:EBrokerError do begin
        if E.Code = XWB_M_REJECT then begin
          x := 'An error occurred on the server.' + CRLF + CRLF + E.Action;
          Application.MessageBox(PChar(x), 'Server Error', MB_OK);
        end else begin
          raise;
        end;
      (*
        case E.Code of
        XWB_M_REJECT:  begin
                         x := 'An error occurred on the server.' + CRLF + CRLF + E.Action;
                         Application.MessageBox(PChar(x), 'Server Error', MB_OK);
                       end;
        else           begin
                         x := 'An error occurred with the network connection.' + CRLF +
                              'Action was: ' + E.Action + CRLF + 'Code was: ' + E.Mnemonic +
                              CRLF + CRLF + 'Application cannot continue.';
                         Application.MessageBox(PChar(x), 'Network Error', MB_OK);
                       end;
        end;
        *)
        // make optional later...
        if not RPCBrokerV.Connected then begin
          Application.Terminate;
        end;
      end;
    end;
    AStringList.Add(' ');
    AStringList.Add('Results -----------------------------------------------------------------');
    FastAddStrings(RPCBrokerV.Results, AStringList);
    AStringList.Add(' ');  //kt 9/11
    Time2 := GetTime;      //kt 9/11
    AStringList.Add('Elapsed Time: ' + IntToStr(Round(MilliSecondSpan(Time2,Time1))) + ' ms');  //kt 9/11
    if not TMGFiltered then begin //kt 9/11
      //kt uCallList.Add(AStringList);
      TMGCallList.Add(AStringList); //kt
    end;                         //kt 9/11
    if uShowRPCs then StatusText('');
    RPCLastCall := RPCBrokerV.RemoteProcedure + ' (completed)';
  finally
    TMGRPCCallInProcess := false; //kt
  end;
end;

procedure CallBroker;
begin
  UpdateContext(uBaseContext);
  CallBrokerInContext;
end;

procedure SetBrokerServer(const AName: string; APort: Integer; WantDebug: Boolean);
{ makes the initial connection to a server }
begin
  EnsureBroker;
  with RPCBrokerV do
  begin
    Server := AName;
    if APort > 0 then ListenerPort := APort;
    DebugMode := WantDebug;
    Connected := True;
  end;
end;

function AuthorizedOption(const OptionName: string): Boolean;
{ checks to see if the user is authorized to use this application }
begin
  EnsureBroker;
  Result := RPCBrokerV.CreateContext(OptionName);
  if Result then
  begin
    if (uBaseContext = '') then
      uBaseContext := OptionName;
    uCurrentContext := OptionName;
  end;
end;

function ConnectToServer(const OptionName: string): Boolean;
{ establish initial connection to server using optional command line parameters and check that
  this application (option) is allowed for this user }
var
  WantDebug: Boolean;
  AServer, APort, x: string;
  i, ModalResult: Integer;
begin
  Result := False;
  WantDebug := False;
  AServer := '';
  APort := '';
  for i := 1 to ParamCount do            // params may be: S[ERVER]=hostname P[ORT]=port DEBUG
  begin
    if UpperCase(ParamStr(i)) = 'DEBUG' then WantDebug := True;
    if UpperCase(ParamStr(i)) = 'SHOWRPCS' then uShowRPCs := True;
    x := UpperCase(Piece(ParamStr(i), '=', 1));
    if (x = 'S') or (x = 'SERVER') then AServer := Piece(ParamStr(i), '=', 2);
    if (x = 'P') or (x = 'PORT') then APort := Piece(ParamStr(i), '=', 2);
  end;
  if (AServer = '') or (APort = '') then
  begin
    ModalResult := GetServerInfo(AServer, APort);
    if ModalResult = mrCancel then Exit;
  end;
  // use try..except to work around errors in the Broker SignOn screen
  try
    SetBrokerServer(AServer, StrToIntDef(APort, 9200), WantDebug);
    Result := AuthorizedOption(OptionName);
    if Result then Result := RPCBrokerV.Connected;
    RPCBrokerV.RPCTimeLimit := 300;
  except
    on E:EBrokerError do
    begin
      if E.Code <> XWB_BadSignOn then InfoBox(E.Message, 'Error', MB_OK or MB_ICONERROR);
      Result := False;
    end;
  end;
end;

function MRef(glvn: string): string;
{ prepends ASCII 1 to string, allows SetParams to interpret as an M reference }
begin
  Result := #1 + glvn;
end;

function GetRPCCursor: TCursor;
var
  pt: TPoint;
begin
  Result := crHourGlass;
  if assigned(AppStartedCursorForm) and (AppStartedCursorForm.Visible) then
  begin
    pt := Mouse.CursorPos;
    if PtInRect(AppStartedCursorForm.BoundsRect, pt) then
      Result := crAppStart;    
  end;
end;

procedure CallV(const RPCName: string; const AParam: array of const);
{ calls the broker leaving results in results property which must be read by caller }
var
  SavedCursor: TCursor;
begin
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, AParam);
  CallBroker;  //RPCBrokerV.Call;
  Screen.Cursor := SavedCursor;
end;

function sCallV(const RPCName: string; const AParam: array of const): string;
{ calls the broker and returns a scalar value. }
var
  SavedCursor: TCursor;
begin
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, AParam);
  CallBroker;  //RPCBrokerV.Call;
  if RPCBrokerV.Results.Count > 0 then Result := RPCBrokerV.Results[0] else Result := '';
  Screen.Cursor := SavedCursor;
end;

procedure tCallV(ReturnData: TStrings; const RPCName: string; const AParam: array of const);
{ calls the broker and returns TStrings data }
var
  SavedCursor: TCursor;
begin
  if ReturnData = nil then raise Exception.Create('TString not created');
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, AParam);
  CallBroker;  //RPCBrokerV.Call;
  FastAssign(RPCBrokerV.Results, ReturnData);
  Screen.Cursor := SavedCursor;
end;

(*  uncomment if these are needed -

function pCallV(const RPCName: string; const AParam: array of const): PChar;
{ Calls the Broker.  Result is a PChar containing raw Broker data. }
{ -- Caller must dispose the string that is returned -- }
var
  SavedCursor: TCursor;
begin
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, AParam);
  RPCBrokerV.Call;
  pCallV := StrNew(RPCBrokerV.Results.GetText);
  Screen.Cursor := SavedCursor;
end;

procedure wCallV(AControl: TControl; const RPCName: string; const AParam: array of const);
{ Calls the Broker.  Places data into control (wrapped). }
var
  BufPtr: PChar;
begin
  BufPtr := pCallV(RPCName, AParam);
  WrapWP(BufPtr);
  AControl.SetTextBuf(BufPtr);
  StrDispose(BufPtr);
end;

procedure WrapWP(Buf: pChar);
{ Iterates through Buf and wraps text in the same way that FM wraps text. }
var
  PSub: PChar;
begin
  PSub := StrScan(Buf, #13);
  while PSub <> nil do
  begin
    if Ord(PSub[2]) > 32 then
    begin
      StrMove(PSub, PSub + SizeOf(Char), StrLen(PSub));
      PSub[0] := #32;
    end
    else repeat Inc(PSub, SizeOf(Char)) until (Ord(PSub[0]) > 32) or (PSub = StrEnd(PSub));
    PSub := StrScan(PSub, #13);
  end;
end;

*)

function RetainedRPCCount: Integer;
begin
  //kt Result := uCallList.Count;
  Result := TMGCallList.Count;  //kt
end;

procedure SetRetainedRPCMax(Value: Integer);
begin
  if Value > 0 then uMaxCalls := Value;
end;

function GetRPCMax: integer;
begin
  Result := uMaxCalls;
end;

procedure LoadRPCData(Dest: TStrings; ID: Integer);
var SL : TStringList;  //kt
begin
  //kt if (ID > -1) and (ID < uCallList.Count) then FastAssign(TStringList(uCallList.Items[ID]), Dest);
  SL := TMGCallList.GetSL(ID);  //kt
  if Assigned(SL) then FastAssign(SL, Dest) else Dest.Clear; //kt
end;

function AccessRPCDataByIndex(Index : integer; var ID: Integer) : TStringList; //kt 9/9/23 added  -- Caller DOESN'T own object
begin
  Result := TMGCallList.GetSLByIndex(Index);
  ID := TMGCallList.IDofIndex(Index);
end;


function AccessRPCData(ID: Integer) : TStringList;
//kt 9/11 added  -- Caller DOESN'T own object
begin
  result := TMGCallList.GetSL(ID);  //kt
  {  //kt 9/9/23
  Result := nil;
  if (ID > -1) and (ID < uCallList.Count) then begin
    Result := TStringList(uCallList.Items[ID]);
  end;
  }
end;

function RPCDataChanged : boolean; //kt 9/23
begin
  result := TMGCallList.ModifiedSinceLastReview;
end;

procedure SetRPCDataAsReviewed; //kt 9/23
begin
  TMGCallList.SetAsReviewed;
end;

function PrevRPCDataID(CurrentID : integer) : integer; //kt
var index: integer;
begin
  index := TMGCallList.IndexOfID(CurrentID);
  if index > 0 then begin
    Result := TMGCallList.IDofIndex(index-1);
  end else begin
    Result := CurrentID;
  end;
end;

function NextRPCDataID(CurrentID : integer) : integer; //kt
var index: integer;
begin
  index := TMGCallList.IndexOfID(CurrentID);
  if index < TMGCallList.Count-1 then begin
    Result := TMGCallList.IDofIndex(index+1);
  end else begin
    Result := CurrentID;
  end;
end;

function IndexOfRPCID(ID : integer) : integer;
begin
  Result := TMGCallList.IndexOfID(ID);
end;

function IDOfRPCIndex(Index : integer) : integer;
begin
  Result := TMGCallList.IDofIndex(Index);
end;

function DottedIPStr: string;
{ return the IP address of the local machine as a string in dotted form: nnn.nnn.nnn.nnn }
const
  WINSOCK1_1 = $0101;      // minimum required version of WinSock
  SUCCESS = 0;             // value returned by WinSock functions if no error
var
  //WSAData: TWSAData;       // structure to hold startup information
  HostEnt: PHostEnt;       // pointer to Host Info structure (see WinSock 1.1, page 60)
  IPAddr: PInAddr;         // pointer to IP address in network order (4 bytes)
  LocalName: array[0..255] of Char;  // buffer for the name of the client machine
begin
  Result := 'No IP Address';
  // ensure the Winsock DLL has been loaded (should be if there is a broker connection)
  //if WSAStartup(WINSOCK1_1, WSAData) <> SUCCESS then Exit;
  //try
    // get the name of the client machine
    if gethostname(LocalName, SizeOf(LocalName) - 1) <> SUCCESS then Exit;
    // get information about the client machine (contained in a record of type THostEnt)
    HostEnt := gethostbyname(LocalName);
    if HostEnt = nil then Exit;
    // get a pointer to the four bytes that contain the IP address
    // Dereference HostEnt to get the THostEnt record.  In turn, dereference the h_addr_list
    // field to get a pointer to the IP address.  The pointer to the IP address is type PChar,
    // so it needs to be typecast as PInAddr in order to make the call to inet_ntoa.
    IPAddr := PInAddr(HostEnt^.h_addr_list^);
    // Dereference IPAddr (which is a PChar typecast as PInAddr) to get the 4 bytes that need
    // to be passed to inet_ntoa.  A string with the IP address in dotted format is returned.
    Result := inet_ntoa(IPAddr^);
  //finally
    // causes the reference counter in Winsock (set by WSAStartup, above) to be decremented
    //WSACleanup;
  //end;
end;

procedure RPCIdleCallDone(Msg: string);
begin
  RPCBrokerV.ClearResults := True; 
end;

procedure CallRPCWhenIdle(CallProc: TORIdleCallProc; Msg: String);
begin
  CallWhenIdleNotifyWhenDone(CallProc, RPCIdleCallDone, Msg);
end;

procedure RPCCallsClear;
//kt 9/11 -- Added entire fuction.
begin
  TMGCallList.ClearAndFree;
  {//kt 9/9/23
  while uCallList.Count > 0 do begin
    TStringList(uCallList.Items[0]).Free;
    uCallList.Delete(0);
  end;
  }
end;

function ShowRPCList: Boolean;
begin
  if uShowRPCS then Result := True
  else Result := False;
end;


initialization
  RPCBrokerV := nil;
  RPCLastCall := 'No RPCs called';
  //kt uCallList := TList.Create;
  TMGCallList := TRPCCallList.Create;
  uMaxCalls := 500;  //kt -- was 100
  uShowRPCs := False;
  FilteredRPCCalls := TStringList.Create;  //kt 9/11

finalization
  { //kt 9/9/23
  while uCallList.Count > 0 do
  begin
    TStringList(uCallList.Items[0]).Free;
    uCallList.Delete(0);
  end;
  uCallList.Free;
  }
  TMGCallList.Destroy; //kt  -- frees all owned TStringLists
  FilteredRPCCalls.Free;  //kt 9/11
end.
