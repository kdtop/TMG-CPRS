unit fClientInfo;

interface

uses   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBrokerConnectionInfo;


type
  TForm2 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{
/// <summary>
/// Summary description for ClientInfo.
/// </summary>
}
  TClientInfo = class(TPersistent)
  private
    FUniqueId: Integer;
    FName: String;
    FBrokerConnectionIndex: Integer;
    FRpcHistoryEnabled: Boolean;
    FRpcLogger: TClientRpcLogger;
    FVisible: Boolean;
  protected
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    procedure Initialize;
  public
    Constructor Create; overload; virtual;
    Constructor Create(uniqueId: Integer; name: String; connectionIndex: Integer; historyEnabled: Boolean); overload; virtual;
    procedure AddRpcLogEntry(entry: TRpcLogEntry; overrideCheckBox: Boolean);
    function MakeCheckBoxString: String;
    function ToString: String;
    property Visible: Boolean read GetVisible write SetVisible;
    property Name: String read FName write FName;
    property RpcHistoryEnabled: Boolean read FRpcHistoryEnabled write FRPCHistoryEnabled;
    property UniqueId: Integer read FUniqueId write FUniqueId;
    property BrokerConnectionIndex: Integer read FBrokerConnectionIndex write FBrokerConnectionIndex;
  end;

const
  kRpcHistoryEnabledDefault: Boolean = true;
  kBrokerConnectionIndexDefault: Integer = -1;

var
  Form2: TForm2;

implementation

{$R *.DFM}

Constructor TClientInfo.Create;
begin
  inherited;
  Initialize;
end;
{
    /// <summary>
    /// ClientInfo parameterized constructor
    /// </summary>
    /// <param name="uniqueId"></param>
    /// <param name="name"></param>
    /// <param name="connectionIndex"></param>
    /// <param name="historyEnabled"></param>
}
Constructor TClientInfo.Create(uniqueId: Integer; name: String; connectionIndex: Integer; historyEnabled: Boolean);
begin
  Create;

      FUniqueId := uniqueId;
      FName := name;
      FBrokerConnectionIndex := connectionIndex;
      FRpcHistoryEnabled := historyEnabled;
end;

procedure TClientInfo.AddRpcLogEntry(entry: TRpcLogEntry; overrideCheckBox: Boolean);
begin
      if(FRpcLogger <> nil) then
        FRpcLogger.AddRpcLogEntry(entry,overrideCheckBox);
end;

procedure TClientInfo.SetVisible(Value: Boolean);
begin
  if(value) then
  begin
    if(FRpcLogger = nil) then
    begin
      FRpcLogger := TClientRpcLogger.Create;
// TODO      FRpcLogger.OnRpcLoggerClose += new EventHandler(OnRpcLoggerClosedEventHandler);
      FRpcLogger.Text := 'RPC Log for  '+Name+' ID='+IntToStr(UniqueId);
    end;
    FRpcLogger.Visible := true;
  end
  else
  begin
    if(FRpcLogger <> nil) then
    begin
            FRpcLogger.Visible := false;
            FRpcLogger := nil;
    end;
  end;
end;

function TClientInfo.GetVisible: Boolean;
begin
  result := false;
  if (FRpcLogger <> nil) then
    result := FRpcLogger.Visible;
end;
{
    /// <summary>
    /// OnLogClosed is called when the ClientRpcLogger window is called
    /// Any event handlers by owners of this object should assign 
    /// an event handler to this event
    /// </summary>
}
// TODO
//    public EventHandler OnLogClosed;
{
    /// <summary>
    /// MakeCheckBoxString creates a string based on the internal members
    /// This string is intended to be used for check box list entries.
    /// </summary>
    /// <param name="checkBoxString"></param>
}
function TClientInfo.MakeCheckBoxString: String;
begin
  Result := ToString;
end;

{
    /// <summary>
    /// ToString returns a readable string representation of the member
    /// </summary>
    /// <returns></returns>
}
function TClientInfo.ToString: String;
begin
  result := FName+' connection='+IntToStr(FBrokerConnectionIndex)+' id='+IntToStr(FUniqueId);
end;

procedure TClientInfo.Initialize;
begin
      FBrokerConnectionIndex := kBrokerConnectionIndexDefault;
      FRpcHistoryEnabled := kRpcHistoryEnabledDefault;
      FRpcLogger := nil;
end;

// TODO
{
procedure TClientInfo.OnRpcLoggerClosedEventHandler(object sender, EventArgs e)
begin
  // Pass the message on to my owner
  Visible := false;
  OnLogClosed(Self,nil);
end;
}

end.
 
