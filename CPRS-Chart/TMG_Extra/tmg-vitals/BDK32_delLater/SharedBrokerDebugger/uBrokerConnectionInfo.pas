unit uBrokerConnectionInfo;

interface

uses Windows, Classes, SysUtils, uRpcLogEntry, fClientRPCLogger, Forms;

Type
{
  TRPCLogEntry = class
  end;
}
  TClientRPCLogger = class
  private
    FText: String;
    FVisible: Boolean;
  public
    procedure AddRpcLogEntry(entry: TRpcLogEntry; overrideCheckBox: Boolean);
    property Text: String read FText write FText;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TBrokerConnectionInfo = class(TPersistent)
  private
    FRpcLogger: TfrmRPCClientLogger;
    FConnectionIndex: Integer;
    FConnectedServerIp: String;
    FConnectedServerPort: Integer;
    FLastContext: String;
  protected
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
  public
    Constructor Create(); overload; virtual;
    Constructor Create(index: Integer; ip: String; port: Integer; lastContext: String); overload; virtual;
    function MakeListItemString: String; virtual;
    function ToString: String;
    procedure AddRpcLogEntry(entry: TRpcLogEntry; overrideCheckBox: bool);
    property ConnectionIndex: Integer read FConnectionIndex write FConnectionIndex;
    property ConnectedServerIp: String read FConnectedServerIP write FConnectedServerIP;
    property ConnectedServerPort: Integer read FConnectedServerPort write FConnectedServerPort;
    property LastContext: String read FLastContext write FLastContext;
    property Visible: Boolean read GetVisible write SetVisible;
  end;


const
  kNoConnectionIndex = -1;
  kNoServerIp: String = '0.0.0.0';
  kNoConnectedServerPort: Integer = 0;
  kNoLastContext: String =   'NO CONTEXT';

implementation

Constructor TBrokerConnectionInfo.Create;
begin
  ConnectionIndex := kNoConnectionIndex;
  ConnectedServerIp := kNoServerIp;
  ConnectedServerPort := kNoConnectedServerPort;
  LastContext := kNoLastContext;
end;

{
/// <summary>
/// BrokerConnectionInfo is the parameterized constructor
/// </summary>
/// <param name="index"></param>
/// <param name="ip"></param>
/// <param name="port'></param>
/// <param name='lastContext'></param>
}
Constructor TBrokerConnectionInfo.Create(index: Integer; ip: String; port: Integer; lastContext: String);
begin
  FConnectionIndex := index;
  FConnectedServerIp := ip;
  FConnectedServerPort := port;
  FLastContext := lastContext;
end;

{
 /// <summary>
 /// MakeListItemString makes a string from its members intended
 /// to be used for list items in a list box
 /// </summary>
 /// <param name='listItemString'></param>
}
function TBrokerConnectionInfo.MakeListItemString: String;
begin
  Result := ToString;
end;

{
 /// <summary>
 /// ToString returns a readable string format of the member data
 /// </summary>
 /// <returns></returns>
}
function TBrokerConnectionInfo.ToString: String;
begin
  Result := IntToStr(ConnectionIndex)+' server IP='+ConnectedServerIp+' server port='+IntToStr(ConnectedServerPort)+' last context='+LastContext;
end;

{
 /// <summary>
 /// AddRpcLogEntry adds a single log entry to the broker connection
 /// visual log box
 /// </summary>
 /// <param name='entry'></param>
 /// <param name='overrideCheckBox'></param>
}

procedure TBrokerConnectionInfo.AddRpcLogEntry(entry: TRpcLogEntry; overrideCheckBox: bool);
begin
  if(FRpcLogger <> nil) then
    FRpcLogger.AddRpcLogEntry(entry,overrideCheckBox);
end;

procedure TBrokerConnectionInfo.SetVisible(Value: Boolean);
begin
  if (value) then
  begin
    if(FRpcLogger = nil) then
    begin
      FRpcLogger := TfrmRpcClientLogger.Create(Application);
// ??      FRpcLogger.OnRpcLoggerClose += new EventHandler(OnRpcLoggerClosedEventHandler);
      FRpcLogger.Caption := 'RPC Log for connection '+IntToStr(ConnectionIndex);
    end;
    FRpcLogger.Visible := true;
  end
  else
    if(FRpcLogger <> nil) then
    begin
      FRpcLogger.Visible := false;
      FRpcLogger := nil;
    end;
end;

function TBrokerConnectionInfo.GetVisible: Boolean;
begin
  result := false;
  if(FRpcLogger <> nil) then
    result := FRpcLogger.Visible;
end;

{
/// <summary>
/// OnLogClosed is called when the ClientRpcLogger window is called
/// Any event handlers by owners of this object should assign
/// an event handler to this event
/// </summary>
}
{ // TODO
procedure EventHandler OnLogClosed;
private void OnRpcLoggerClosedEventHandler(object sender, EventArgs e)
begin
  // Pass the message on to my owner
  Visible := false;
  OnLogClosed(Self,nil);
end;
}

procedure TClientRPCLogger.AddRpcLogEntry(entry: TRPCLogEntry; overrideCheckBox: Boolean);
begin
//    TODO
end;

end.
