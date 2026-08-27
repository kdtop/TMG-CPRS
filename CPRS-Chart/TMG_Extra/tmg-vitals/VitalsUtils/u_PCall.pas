unit u_PCall;
{
================================================================================
*
*       Package:
*       Date Created:   $Revision: 2 $  $Modtime: 5/25/05 2:20p $
*       Site:           Hines OIFO
*       Developers:     Sergey.Gavrilov@med.va.gov
*                       Andrey.Andriyevskiy@med.va.gov
*       Description:    RPC call
*
*       Notes:
*
================================================================================
*
* $History: u_PCall.pas $
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 5/25/05    Time: 6:10p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsUtils
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 5:04p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsUtils
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:24p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSUTILS
 *
*
================================================================================
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls
  , RpcConf1
  , SharedRPCBroker
  , TRPCB;

type

  TRPCMode = set of (

    rpcSilent,          // Do not show any error messages
                        // (only return the error codes)

    rpcNoResChk         // Do not check the Results array for the errors
                        // returned by the remote procedure. This flag must be
                        // used for the remote procedures that do not conform
                        // to the error reporting format supported by the
                        // CheckRPCError function.
  );

  TRPCBrokerParams = record
    Server: String; //BROKERSERVER;
    ListenerPort: Integer;//9200;
    ClearResults: Boolean; //True;
    ClearParameters: Boolean; //True;
    AccessVerifyCodes: String; //
    DebugMode: Boolean;
    SharedMode: Boolean;
  end;

function  CallRemoteProc( Broker: TRPCBroker; RemoteProcedure: String;
            Parameters: array of String; MultList: TStringList = nil;
            RPCMode: TRPCMode = []; RetList: TStrings = nil ): Boolean;
function  SelectBroker( Context: String ): TRPCBroker;
function GetBrokerParameterValues(var ParamRecord: TRPCBrokerParams):Boolean;
{
procedure LogString( ll: String );
procedure LogTimeString( ll: String );
function  SelectCCOWBroker( Context: String ): TRPCBroker;
function  CallRemoteProcLog( Broker: TRPCBroker; RemoteProcedure: String;
            Parameters: array of String; MultList: TStringList = nil;
            RPCMode: TRPCMode = []; RetList: TStrings = nil ): Boolean;
function  CheckRPCError( RPCName: String; Results: TStrings;
            RPCMode: TRPCMode = [] ): Integer;
}

var
  Log: TStrings;
  BrokerParams: TRPCBrokerParams;
  RPCBroker: TRPCBroker = nil;     // backward compatibility


implementation

uses u_Common
  ;

function CheckRPCError(RPCName: String; Results: TStrings;
           RPCMode: TRPCMode = [] ): Integer;
var
  i, n: Integer;
  s,
  buf, rc: String;

  procedure Add(anS:String);
  begin
    s := s + anS + #10#13;
  end;

begin
  if Results.Count = 0 then
    begin
      Result := mrOK;
      buf := 'The ''' + RPCName + ''' remote procedure returned nothing!';
      if Not (rpcSilent in RPCMode) then
        MessageDialog('RPC Error', buf, mtError, [mbOK], mrOK, 0);
      Results.Add('-1001^1');
      Results.Add('-1001^' + buf);
      Exit;
    end;

  Result := 0;
  s := '';
  rc := Piece(Results[0], '^');

  if StrToIntDef(rc, 0) < 0 then
    begin
      Result := mrOK;
      if Not (rpcSilent in RPCMode) then
        begin
          n := StrToIntDef(Piece(Results[0], '^', 2), 0);
            begin
              buf := 'The error code ''' + rc + ''' was returned by the '''
                + RPCName + ''' remote procedure!';
              if n > 0 then
                begin
                  buf := buf + ' The problem had been caused by the following ';
                  if n > 1 then
                    buf := buf + 'errors (in reverse chronological order):'
                  else
                    buf := buf + 'error: ';
                  Add(buf);
                  for i := 1 to n do
                    begin
                      buf := Results[i];
                      Add('');  Add(' ' + Piece(buf,'^',2));
                      Add(' Error Code: ' + Piece(buf,'^',1) + ';' + #9 +
                        'Place: ' + StringReplace(Piece(buf,'^',3),'~','^',[]));
                    end;
                end
              else
                Add(buf);
            end;
            MessageDialog('RPC Error',s, mtError, [mbOK], mrOK,0);
        end;
    end;

end;

function CallRemoteProc(Broker: TRPCBroker; RemoteProcedure: String;
           Parameters: array of String; MultList: TStringList = nil;
           RPCMode: TRPCMode = []; RetList: TStrings = nil): Boolean;
var
  i, j: Integer;
begin
  Broker.RemoteProcedure := RemoteProcedure;
  i := 0;
  while i <= High(Parameters) do
    begin
      if (Copy(Parameters[i], 1, 1) = '@') and (Parameters[i] <> '@') then
        begin
          Broker.Param[i].Value := Copy(Parameters[i], 2, Length(Parameters[i]));
          Broker.Param[i].PType := Reference;
        end
      else
        begin
          Broker.Param[i].Value := Parameters[i];
          Broker.Param[i].PType := Literal;
        end;
      Inc(i);
    end;

  if MultList <> nil then
    if MultList.Count > 0 then
      begin
        for j := 1 to MultList.Count do
          Broker.Param[i].Mult[IntToStr(j)] := MultList[j-1];
        Broker.Param[i].PType := List;
      end;

  try
    Result := True;
    if RetList <> nil then
      begin
        RetList.Clear;
        Broker.lstCall(RetList);
      end
    else
      begin
        Broker.Call;
        RetList := Broker.Results;
      end;

    if Not (rpcNoResChk in RPCMode) then
      if CheckRPCError(RemoteProcedure, RetList, RPCMode) <> 0 then
        Result := False;

  except
    on e: EBrokerError do
    begin
      if Not (rpcSilent in RPCMode) then
        MessageDialog('RPC Error',
          'Error encountered retrieving VistA data.' + #13 +
          'Server: ' + Broker.Server + #13 +
          'Listener port: ' + IntToStr(Broker.ListenerPort) + #13 +
          'Remote procedure: ' + Broker.RemoteProcedure + #13 +
          'Error is: ' + #13 +
          e.Message, mtError, [mbOK], mrOK, e.HelpContext);
      with Broker do
      begin
        Results.Clear;
        Results.Add('-1000^1');
        Results.Add('-1000^' + e.Message);
      end;
      Result := False;
    end;
  else
    raise;
  end;
end;

procedure LogString(ll: String);
begin
  try
    Log.Text := Log.Text + ll;
  except
  end;
end;

procedure LogTimeString(ll: String);
begin
  LogString(#13 +
    Format('%s : %s',[FormatDateTime('dd/mm/yyyy hh:mm:ss.zzz',Now),ll]));
end;

function CallRemoteProcLog(Broker: TRPCBroker; RemoteProcedure: String;
           Parameters: array of String; MultList: TStringList = nil;
           RPCMode: TRPCMode = []; RetList: TStrings = nil): Boolean;
var
  i: integer;
begin
  LogTimeString('Start -- ' +RemoteProcedure);

  for i := 0 to High(Parameters) do
    LogString(#13+  '                                   ['+IntTosTr(i)+'] ' +Parameters[i]);
  if MultList <> nil then
    for I := 0 to MultList.Count - 1 do
      LogString(#13+  '                                   ['+IntTosTr(i)+'] ' +MultList[i]);

  if CallRemoteProc(Broker, RemoteProcedure, Parameters, MultList, RPCMode, RetList) then
    begin
      if RetList <> nil then
      for I := 0 to RetList.Count - 1 do
        LogString(#13+  '                                   ['+IntTosTr(i)+'] ' +RetList[i]);
      LogTimeString('Stop  -- 1 ' +RemoteProcedure);
      Result := True;
    end
  else
    begin
      LogTimeString('Stop  -- 0 ' +RemoteProcedure);
      Result := False;
    end;
end;

function GetBrokerParameters(var ParamRecord: TRPCBrokerParams): boolean;
var
  UseServerList : Boolean;
  i: Integer;
  SLServer, SLPort: string;
begin
  ParamRecord.Server := 'BROKERSERVER';
  ParamRecord.ListenerPort := 9200;
  ParamRecord.ClearParameters := True;
  ParamRecord.ClearResults := True;
  ParamRecord.SharedMode := False;

  UseServerList := True;
  for i := 1 to ParamCount do
    begin
      {
      if InString(ParamStr(i), ['/av=', '-av='], False) then
        begin
          ParamRecord.AccessVerifyCodes := Piece(ParamStr(i), '=', 2);
          UseServerList := False;
        end;
      }
      if InString(ParamStr(i), ['/s=', '-s='], False) or
         InString(ParamStr(i), ['/server=', '-server='], False)
      then
        begin
          ParamRecord.Server := Piece(ParamStr(i), '=', 2);
          UseServerList := False;
        end;

      if InString(ParamStr(i), ['/p=', '-p='], False) or
         InString(ParamStr(i), ['/port=', '-port='], False)
      then
        begin
          ParamRecord.ListenerPort := StrToIntDef(Piece(ParamStr(i), '=', 2), 9200);
          UseServerList := False;
        end;

      if InString(ParamStr(i), ['/debug=', '-debug='], False) then
        begin
          ParamRecord.DebugMode := (LowerCase(Piece(ParamStr(i), '=', 2)) = 'on');
        end;
      if InString(ParamStr(i), ['/nonsharedbroker', '-nonsharedbroker'], False) then
        ParamRecord.SharedMode := True;

      if InString(ParamStr(i), ['/demo', '-demo'], False) then
        begin
          UseServerList := False;
{$IFNDEF AANTEST}
          if MessageDlg(
            'This is a demo version of the' + #13 +
            ExtractFileName(Application.Exename) + ' program.' + #13#13 +
            'It will attempt connection to the' + #13 +
            'Hines OIFO Development server at' + #13#13 +
            'IP Address: 10.3.29.201' + #13 +
            'Listener Port: 9100' + #13 + #13 +
            'Do you wish to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
{$ENDIF}
            begin
              ParamRecord.Server := '10.3.29.201';
              ParamRecord.ListenerPort := 9100;
              ParamRecord.AccessVerifyCodes := 'ANDREY_1;)october1(';
            end
{$IFNDEF AANTEST}
          else
            begin
              Result := False;
              Exit;
            end;
{$ENDIF}
        end;
   end;
   if UseServerList then
     begin
      if GetServerInfo(SLServer, SLPort) <> 1 then
        begin
          MessageDlg('Sign-On Cancelled while setting connection parameters', mtInformation, [mbok], 0);
          Result := False;
          Exit;
        end
      else
        begin
          ParamRecord.Server := SLServer;
          ParamRecord.ListenerPort := StrToIntDef(SLPort, 9200);
          Application.ProcessMessages; {Refresh screen prior to connecting}
        end;
     end;
  Result := True;
end;

function GetBrokerParameterValues(var ParamRecord: TRPCBrokerParams):Boolean;
var
  SLServer, SLPort: string;
begin
  if ParamRecord.Server = '' then
    begin
      BrokerParams.ListenerPort := 0;
      BrokerParams.AccessVerifyCodes := '';
      BrokerParams.SharedMode := True;
      
      Result := GetBrokerParameters(ParamRecord);
    end
  else
      if GetServerInfo(SLServer, SLPort) <> 1 then
        begin
          MessageDlg('Sign-On Cancelled while setting connection parameters', mtInformation, [mbok], 0);
          Result := False;
          Exit;
        end
      else
        begin
          ParamRecord.Server := SLServer;
          ParamRecord.ListenerPort := StrToIntDef(SLPort, 9200);
          Application.ProcessMessages; {Refresh screen prior to connecting}
          Result := True;
        end;
end;

function SetBrokerParameters(ParamRecord: TRPCBrokerParams; var RPCB: TRPCBroker; var ErrorString:String): boolean;
begin
  RPCB.Server := ParamRecord.Server;
  RPCB.ListenerPort := ParamRecord.ListenerPort;
  RPCB.ClearParameters := ParamRecord.ClearParameters;
  RPCB.ClearResults := ParamRecord.ClearResults;
  RPCB.AccessVerifyCodes := ParamRecord.AccessVerifyCodes;
  RPCB.DebugMode := ParamRecord.DebugMode;

  ErrorString := '';

  if RPCB.Socket > 0 then // ???
    begin
      Result := True;
      exit;
    end;

  try
    RPCB.Connected := True;
    Application.ProcessMessages;
    Result := True;
  except
    on E: EBrokerError do
      begin
        ErrorString := E.Message;
        Result := False;
        Exit;
      end;
  else
    raise;
  end;

end;

function SelectBroker(Context:String):TRPCBroker;
var
  s: String;
  RPCB:TRPCBroker;
  NewAttempt:Boolean;
  AttemptCount: Integer;

const
  AttemptLimit = 3;

  procedure ErrorReport;
  begin
    MessageDlg('Error Encountered' + #13 + #13 +
      'User Sign-on is not complete.' + #13 +
      'Attempted connection using the following:' + #13 +
      'VistA Server: ' + RPCB.Server + #13 +
      'Listener Port: ' + IntToStr(RPCB.ListenerPort) + #13 +
      'Error Message: ' + #13 + s,
      mtError,
      [mbok],
      0);
  end;

begin
{ Prepare BrokerParams first ==================================================}
{
  if not GetBrokerParameters(BrokerParams) then// process parameter string
    begin
      Result := nil;
      exit;
    end;
}
{
  for i := 1 to ParamCount do
    if InString(ParamStr(i), ['/nonsharedbroker', '-nonsharedbroker'], False) then
      break;
}
//==============================================================================

  AttemptCount := 0;
  repeat
    NewAttempt := False;
    if BrokerParams.SharedMode then
      begin
        RPCB := TRPCBroker.Create(Application);
        if not SetBrokerParameters(BrokerParams,RPCB,s) then
          begin
            ErrorReport;
            FreeAndNil(RPCB);
          end;
      end
    else //try shared broker first
      begin
          RPCB := TSharedRPCBroker.Create(Application);
          TSharedRPCBroker(RPCB).AllowShared := True;
          if not SetBrokerParameters(BrokerParams,RPCB,s) then
            if (pos('Class not registered',s)<>0) then // shared broker is not available
              begin
               FreeAndNil(RPCB);
               RPCB := TRPCBroker.Create(Application); // try nonshared broker
               if not SetBrokerParameters(BrokerParams,RPCB,s) then
                 begin
                   ErrorReport;
                   FreeAndNil(RPCB);
                 end;
              end
            else // unknown error type - just report and stop
              begin
                ErrorReport;
                FreeAndNil(RPCB);
              end;
      end;

    if RPCB <> nil then
      try
        if not RPCB.CreateContext(Context) then
            FreeAndNil(RPCB);
      except
        on E: Exception do
          begin
            FreeAndNil(RPCB);
            Inc(AttemptCount);
            if AttemptCount > AttemptLimit then
              MessageDlg('You exceeded the limit of connection attempts.' +
                #13+#13+ 'Try again later.', mtError, [mbok], 0)
            else
              NewAttempt := MessageDlg('User Sign-on is not complete.' + #13 + #13+
                'Error Message: ' + #13 + E.Message+#13+#13+'Do you want to repeat the attempt?',
                mtError, [mbok,mbCancel], 0) = mrOK;
          end;
      end;

    until (RPCB <> nil) or (AttemptCount > AttemptLimit) or not NewAttempt;

  Result := RPCB;
end;

end.


