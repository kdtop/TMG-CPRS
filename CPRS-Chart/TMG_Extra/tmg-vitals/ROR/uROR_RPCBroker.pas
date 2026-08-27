unit uROR_RPCBroker;
{
================================================================================
*
*       Package:        ROR - Clinical Case Registries
*       Date Created:   $Revision: 2 $  $Modtime: 6/06/05 4:38p $
*       Site:           Hines OIFO
*       Developers:     Sergey.Gavrilov@med.va.gov
*
*       Description:    RPC call and RPC Error Window
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/ROR/uROR_RPCBroker.pas $
*
* $History: uROR_RPCBroker.pas $
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 7/05/05    Time: 9:38a
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/ROR
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:32p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/ROR
 * 
 * *****************  Version 10  *****************
 * User: Vhaishgavris Date: 10/14/04   Time: 3:50p
 * Updated in $/CCR v1.0/Current
 * 
 * *****************  Version 9  *****************
 * User: Vhaishgavris Date: 9/15/04    Time: 3:56p
 * Updated in $/CCR v1.0/Current
 * 
 * *****************  Version 8  *****************
 * User: Vhaishgavris Date: 8/20/04    Time: 12:11p
 * Updated in $/CCR v1.0/CCRCompSample
 * 
 * *****************  Version 7  *****************
 * User: Vhaishgavris Date: 8/06/04    Time: 4:09p
 * Updated in $/CCR v1.0/Current
 *
 * *****************  Version 6  *****************
 * User: Vhaishgavris Date: 8/02/04    Time: 12:59p
 * Updated in $/CCR v1.0/Current
 *
 * *****************  Version 5  *****************
 * User: Vhaishgavris Date: 3/26/04    Time: 3:48p
 * Updated in $/ICR v3.0/Current
*
================================================================================
}
interface

uses
  SysUtils, Classes
  , Controls
  , TRPCB
  , CCOWRPCBroker
  , RpcConf1
  , VERGENCECONTEXTORLib_TLB
  , Dialogs
  , Forms
  ;

function SelectBroker(Context: String; aContextor: TContextorControl = nil): TCCOWRPCBroker;

implementation

uses uGMV_Common;

type
  TRPCBrokerParams = record
    Server: String; //BROKERSERVER;
    ListenerPort: Integer;//9200;
    ClearResults: Boolean; //True;
    ClearParameters: Boolean; //True;
    AccessVerifyCodes: String; //
    DebugMode: Boolean;
  end;

var
  BrokerParams: TRPCBrokerParams;

function GetBrokerParameters(var ParamRecord: TRPCBrokerParams): boolean;
var
  sUser:String;
  UseServerList : Boolean;
  i: Integer;
  SLServer, SLPort: string;
begin
  ParamRecord.Server := 'BROKERSERVER';
  ParamRecord.ListenerPort := 9200;
  ParamRecord.ClearParameters := True;
  ParamRecord.ClearResults := True;

  sUser := '';
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
      if InString(ParamStr(i), ['s='], False) or
         InString(ParamStr(i), ['/server=', '-server='], False)
      then
        begin
          ParamRecord.Server := Piece(ParamStr(i), '=', 2);
          UseServerList := False;
        end;

      if InString(ParamStr(i), ['p='], False) or
         InString(ParamStr(i), ['/port=', '-port='], False)
      then
        begin
          ParamRecord.ListenerPort := StrToIntDef(Piece(ParamStr(i), '=', 2), 9200);
          UseServerList := False;
        end;

      if InString(ParamStr(i), ['/debug', '-debug'], False) then
        ParamRecord.DebugMode := True;
{$IFDEF AANTEST}
      if InString(ParamStr(i), ['/user', '/USER'], False) then
        begin
          sUser := Piece(ParamStr(i), '=', 2);
          ParamRecord.AccessVerifyCodes := sUser;
        end;
{$ENDIF}
(* *)
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
              //ParamRecord.Server := '127.0.0.1';
//              ParamRecord.ListenerPort := 9100;
              ParamRecord.ListenerPort := 9100;

{$IFDEF AANTEST}
              ParamRecord.AccessVerifyCodes := 'andrey_1;)octoberl1(';
{$ELSE}
//              ParamRecord.AccessVerifyCodes := 'renal12#;12#renal';
//              ParamRecord.AccessVerifyCodes := 'qwert12#;12#qwerty';
{$ENDIF}
            end
{$IFNDEF AANTEST}
          else
            begin
              Result := False;
              Exit;
            end;
{$ENDIF}
        end;
(**)
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

function SetBrokerParameters(ParamRecord: TRPCBrokerParams; var RPCB: TCCOWRPCBroker; var ErrorString:String): boolean;
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

function SelectBroker(Context:String; aContextor: TContextorControl): TCCOWRPCBroker;
var
  s: String;
  RPCB:TCCOWRPCBroker;
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
  if not GetBrokerParameters(BrokerParams) then// process parameter string
    begin
      Result := nil;
      Exit;
    end;
  {
  for i := 1 to ParamCount do
    if InString(ParamStr(i), ['/nonsharedbroker', '-nonsharedbroker'], False) then
      break;
  }

  AttemptCount := 0;
  repeat
    NewAttempt := False;
    {
    if i <= ParamCount then // force use of nonshared broker
      begin
        RPCB := TCCOWRPCBroker.Create(Application);
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
      }

      RPCB := TCCOWRPCBroker.Create(Application);
      RPCB.Contextor := aContextor;
      if not SetBrokerParameters(BrokerParams, RPCB, s) then
        begin
          ErrorReport;
          FreeAndNil(RPCB);
        end;

      if RPCB <> nil then
        try
          if not RPCB.CreateContext(Context) then
            begin
              MessageDlg('Sorry, but you need the "'+Context+'" option.'+#13#10+
                'Please contact your IRM.',mtInformation,[mbOK],0);
              FreeAndNil(RPCB);
            end;
        except
          on E: Exception do
            begin
              FreeAndNil(RPCB);
              Inc(AttemptCount);
              if AttemptCount > AttemptLimit then
                MessageDlg(
                  'You exceeded the limit of connection attempts.' +
                  #13+#13+ 'Try again later.',
                  mtError, [mbok], 0)
              else
                NewAttempt := MessageDlg(
                  'User Sign-on is not complete.' + #13 + #13+
                  'Error Message: ' + #13 + E.Message+#13+#13+
                  'Do you want to repeat the attempt?',
                  mtError, [mbok,mbCancel], 0) = mrOK;
            end;
        end

    until (RPCB <> nil) or (AttemptCount > AttemptLimit) or not NewAttempt;

  Result := RPCB;
end;

end.
