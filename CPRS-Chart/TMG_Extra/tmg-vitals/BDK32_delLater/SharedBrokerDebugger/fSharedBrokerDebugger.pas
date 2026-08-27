unit fSharedBrokerDebugger;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleServer, CheckLst, ComCtrls,
  Menus, RPCSharedBrokerSessionMgr1_TLB;

type

  TfrmSharedBrokerDebugger = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnExit: TButton;
    EnableRpcCallLogForAllClientsCheckBox: TCheckBox;
    mVistaSession: TSharedBroker;
    CurrentClientsCheckedListBox: TCheckListBox;
    actualBrokerConnectionsCheckedListBox: TCheckListBox;
    RpcCallLogListBox: TListBox;
    maxAllClientRpcLogEntriesNumericUpDown: TEdit;
    UpDown1: TUpDown;
    lblMaxRPCEntries: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    CopyConnectionsLogToClipboard1: TMenuItem;
    clientConnectionsLogRichTextBox: TRichEdit;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure actualBrokerConnectionsCheckedListBoxClickCheck(
      Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure CopyConnectionsLogToClipboard1Click(Sender: TObject);
    procedure CurrentClientsCheckedListBoxClickCheck(Sender: TObject);
  private
    { Private declarations }
    mClients: TList;    // List of broker type clients of the server that are connected.
                        // debugger type clients are not included
    mConnections: TList;
    mDoingAForcedLogoutOfClients: Boolean;
    mOnLogoutPending: Boolean;

  protected
    procedure OnClientConnectEventHandler(Sender: TObject; uniqueClientId: Integer;
                    connection: ISharedBrokerConnection);
    procedure OnRpcCallRecordedEventHandler(Sender: TObject; uniqueRpcId: Integer);
    procedure OnClientDisconnectEventHandler(Sender: TObject; uniqueClientId: Integer);
    procedure OnContextChangedEventHandler(Sender: TObject; connectionIndex: Integer; var newContext: OleVariant);
  public
    { Public declarations }
    procedure RebuildClientList(uniqueClientId: Integer);
    procedure RebuildConnectionList;
  end;

const
  kNoUniqueClientId: integer = -1;
  KInvalidConnectionIndex: Integer = -1;

var
  frmSharedBrokerDebugger: TfrmSharedBrokerDebugger;
  mClients: TList;
  mConnections: TList;

implementation

uses
  uClientInfo, uBrokerConnectionInfo, uRpcLogEntry, frmVistAAbout;

{$R *.DFM}

{
    /// <summary>
    /// The main entry point for the application.
    /// </summary>
    [STAThread]

    static void Main()

      Application.Run(new Form1());
}
{
function TfrmSharedBrokerDebugger.OnLogoutEventHandler; integer;
begin
      mOnLogoutPending := true;
      return 1;
end;

procedure TfrmSharedBrokerDebugger.OnIdleEventHandler(object sender, EventArgs e)
begin
  if (mOnLogoutPending) then
  begin
    CloseDownVistaSession();
    if (mDoingAForcedLogoutOfClients <> true) then
    begin
    // Don't do an Application Exit here.
    // Should really send a close event on the main window
    // Exiting here causes the server to loose its connection and blow up since
    // control doesn't return till after this application is gone, and then
    // the pointer references on the server are bogus
      Application.Exit();
    end;
  mDoingAForcedLogoutOfClients := false;
  mOnLogoutPending := false;
  end;
end;
}
procedure TfrmSharedBrokerDebugger.OnClientConnectEventHandler(Sender: TObject; uniqueClientId: Integer;
                                                            connection: ISharedBrokerConnection);
var
  connectionTypeName: string;
  outString: String;
  ClientName: WideString;
  ErrorCode: ISharedBrokerErrorCode;
begin
      case (connection) of
        New:
          connectionTypeName := 'New';
        Shared:
          connectionTypeName := 'Shared';
        Debug:
          connectionTypeName := 'Debug';
        else
          connectionTypeName := 'Failed';
        end;

      Assert(mVistaSession <> nil);

      errorCode := mVistaSession.GetClientNameFromUniqueClientId(uniqueClientId, clientName);
      if (errorCode = Success) then
      begin
        outString := 'connect ['+connectionTypeName+'] >  '+clientName+'  id:='+IntToStr(uniqueClientId)+FormatDateTime('   hh:nn:ss mm/dd/yy',Now);
        clientConnectionsLogRichTextBox.Lines.Add(outString);
      end
      else
      begin
        // need to throw a debugger exception here
        Assert(false);
      end;

      RebuildClientList(uniqueClientId);
      RebuildConnectionList();
end;

procedure TfrmSharedBrokerDebugger.OnClientDisconnectEventHandler(Sender: TObject; uniqueClientId: Integer);
var
  outString: String;
  clientName: WideString;
  foundOne: Boolean;
  CInfo: TClientInfo;
  ErrorCode: ISharedBrokerErrorCode;
  i: Integer;
begin
  clientName := 'ERROR';
  foundOne := false;

  Assert(mVistaSession <> nil);
      
  errorCode := mVistaSession.GetClientNameFromUniqueClientId(uniqueClientId, clientName);
  if (errorCode = UniqueClientIdDoesNotExist) then
  begin
    // General the client should be disconnected and not available any more
    // so lets look in our local client list for the name to print dialog.
    for i:=0 to Pred(mClients.Count) do
    begin
      cInfo := TClientInfo(mClients[i]);
      if (cInfo.UniqueId = uniqueClientId) then
      begin
        clientName := cInfo.Name;
        foundOne := true;
        break;
      end;
    end;
  end;

  if (foundOne) then
  begin
    outString := 'disconnect > '+clientName+'   id:='+ IntToStr(uniqueClientId) + FormatDateTime('   hh:nn:ss mm/dd/yy',Now);
        clientConnectionsLogRichTextBox.Lines.Add(outString);

        RebuildClientList(uniqueClientId);
        RebuildConnectionList();
      end;
end;

    /// <summary>
    /// OnRpcCallRecordedEventHandler handles the OnRpcCallRecorded event
    /// from the COM interface
    /// </summary>
    /// <param name:='uniqueRpcId'></param>
    /// <returns></returns>
procedure TfrmSharedBrokerDebugger.OnRpcCallRecordedEventHandler(Sender: TObject; uniqueRpcId: Integer);
var
  UniqueClientId: Integer;
  Context: WideString;
  RpcName: WideString;
  RpcParams: WideString;
  ClientName: WideString;
  RpcEndDateTime: Double;
  RpcDuration: Integer;
  RpcResults: WideString;
  CInfo, TempCInfo: TClientInfo;
  LogEntry: TRpcLogEntry;
  I: Integer;
  ErrorCode: ISharedBrokerErrorCode;
begin
  cInfo:=nil;

      Assert(mVistaSession <> nil);

  errorCode := mVistaSession.GetRpcCallFromHistory(uniqueRpcId, uniqueClientId, context, rpcName, rpcParams, rpcResults, rpcEndDateTime, rpcDuration);
  if (errorCode = Success) then
  begin
    errorCode := mVistaSession.GetClientNameFromUniqueClientId(uniqueClientId, clientName);
    if (errorCode = Success) then
    begin
      for i:=0 to Pred(mClients.Count) do
      begin
        tempCInfo := (TClientInfo(mClients[i]));
        if (tempCInfo.UniqueId = uniqueClientId) then
        begin
          cInfo := tempCInfo;
          break;
        end;
      end;
          Assert(cInfo <> nil);

      logEntry := TRpcLogEntry.Create(uniqueClientId,clientName,cInfo.BrokerConnectionIndex,uniqueRpcId,rpcEndDateTime,rpcDuration,context,rpcName,rpcParams,rpcResults);
      if (enableRpcCallLogForAllClientsCheckBox.Checked) then
      begin
            // If the list is full we need to delete the 0th item till we have room for one.
        while (rpcCallLogListBox.Items.Count >= StrToInt(maxAllClientRpcLogEntriesNumericUpDown.Text)) do
              rpcCallLogListBox.Items.Delete(0);

        rpcCallLogListBox.Items.AddObject(IntToStr(logEntry.UniqueClientId),logEntry);
      end;

      cInfo.AddRpcLogEntry(LogEntry, false);
  //    (TBrokerConnectionInfo(mConnections[cInfo.BrokerConnectionIndex])).AddRpcLogEntry(logEntry,false);
      (TClientInfo(mConnections[cInfo.BrokerConnectionIndex])).AddRpcLogEntry(logEntry,false);
    end
    else
    begin
          // Need to throw and exception here
//          Assert(false);
    end;
  end
  else
  begin
        // Need to throw a debugger exception here
//        Assert(false);
  end;
end;

procedure TfrmSharedBrokerDebugger.OnContextChangedEventHandler(Sender: TObject; connectionIndex: Integer; var newContext: OleVariant);
var
  bInfo: TBrokerConnectionInfo;
begin
  if (connectionIndex >=0) and (connectionIndex < mConnections.Count) then
  begin
    bInfo := TBrokerConnectionInfo(mConnections[connectionIndex]);
    if (bInfo.LastContext <> newContext) then
    begin
      bInfo.LastContext := newContext;
      RebuildConnectionList();
    end;
  end
  else
    Assert(false);
end;
{
procedure TfrmSharedBrokerDebugger.OnClientRpcLogClosedEventHandler(object sender, EventArgs e)
var
  CInfo: TClientInfo;
begin
  cInfo := (ClientInfo)sender;
  for i:=0 to Pred(mClients.Count) do
  begin
    if (cInfo.UniqueId=((ClientInfo)mClients[i]).UniqueId) then
    begin
      currentClientsCheckedListBox.SetItemChecked(i,false);
      break;
    end;
  end;
end;


procedure TfrmSharedBrokerDebugger.OnConnectionRpcLogClosedEventHandler(object sender, EventArgs e)
var
  BInfo: TBrokerConnectionInfo;
begin
  bInfo := (TBrokerConnectionInfo)sender;
  for i:=0 to Pred(mConnections.Count) do
  begin
    if (bInfo.ConnectionIndex = ((BrokerConnectionInfo)mConnections[i]).ConnectionIndex) then
    begin
      actualBrokerConnectionsCheckedListBox.SetItemChecked(i,false);
      break;
    end;
  end;
end;


procedure TfrmSharedBrokerDebugger.SetupVistaSession;
begin
  if (mVistaSession = nil) then
  begin
    mVistaSession := TSharedBroker.Create;

        ISharedBrokerEvents_OnLogoutEventHandler OnLogoutEH := new ISharedBrokerEvents_OnLogoutEventHandler(this.OnLogoutEventHandler);
        ISharedBrokerEvents_OnClientConnectEventHandler OnClientConnectEH := new ISharedBrokerEvents_OnClientConnectEventHandler(this.OnClientConnectEventHandler);
        ISharedBrokerEvents_OnClientDisconnectEventHandler OnClientDisconnectEH := new ISharedBrokerEvents_OnClientDisconnectEventHandler(this.OnClientDisconnectEventHandler);
        ISharedBrokerEvents_OnRpcCallRecordedEventHandler OnRpcCallRecorededEH := new ISharedBrokerEvents_OnRpcCallRecordedEventHandler(this.OnRpcCallRecordedEventHandler);
        ISharedBrokerEvents_OnContextChangedEventHandler OnContextChangedEH := new ISharedBrokerEvents_OnContextChangedEventHandler(this.OnContextChangedEventHandler);
        // Set up the event handlers here.
        mVistaSession.OnClientConnect +:= OnClientConnectEH;
        mVistaSession.OnClientDisconnect +:= OnClientDisconnectEH;
        mVistaSession.OnRpcCallRecorded +:= OnRpcCallRecorededEH;
        mVistaSession.OnLogout +:= OnLogoutEH;
        mVistaSession.OnContextChanged +:= OnContextChangedEH;

        int uniqueClientId;

        // string listenerPort := ListenerPort.ToString();
        ISharedBrokerErrorCode brokerError := mVistaSession.BrokerConnect(
          Application.ExecutablePath, 
          ISharedBrokerClient.DebuggerClient,
          '',      // server/port pair is of no meaning in the debugger
          false,   // debug mode is of no meaning in debugger
          false,   // AllowShared connection is of no meaning in debugger
          30,      // Connection time out limit
          out uniqueClientId);

        Debug.Assert(brokerError = ISharedBrokerErrorCode.Success);
        RebuildClientList(kNoUniqueClientId);
    RebuildConnectionList();
  end;
end;

procedure TfrmSharedBrokerDebugger.CloseDownVistaSession;
begin
  if (mVistaSession <> nil) then
  begin
    mVistaSession.BrokerDisconnect();
    mVistaSession.Dispose();
    mVistaSession.Finalize();
    mVistaSession := nil;
  end;
end;
}
procedure TfrmSharedBrokerDebugger.RebuildClientList(uniqueClientId: Integer);
var
  ErrorCode: ISharedBrokerErrorCode;
  Count: Integer;
  id: Integer;
  Name: WideString;
  ConnectIndex: Integer;
  CInfo: TClientInfo;
  i: Integer;
  FoundIndex: Integer;
begin
  count := 0;
  Assert(mVistaSession <> nil);

  errorCode := mVistaSession.GetConnectedClientCount(count);
  if (errorCode = Success) then
  begin
    id        := kNoUniqueClientId;
    name      := '';
    connectIndex  := kInvalidConnectionIndex;

    if (uniqueClientId = kNoUniqueClientId) or (count = mClients.Count) then
    begin
      // Hide any open RPC logger windows
      for i:=0 to Pred(mClients.Count) do
        (TClientInfo(mClients[i])).Visible := false;

      // Scrap the current list
      mClients.Clear();

      // Scrap the listbox list
      currentClientsCheckedListBox.Items.Clear();

      for i:=0 to Pred(count) do
      begin
        errorCode := mVistaSession.GetClientIdAndNameFromIndex(i, id, name);
        if (errorCode = Success) then
        begin
          errorCode := mVistaSession.GetActiveBrokerConnectionIndexFromUniqueClientId(id, connectIndex);
          if (errorCode = Success) then
          begin
            cInfo := TClientInfo.Create(id,name,connectIndex,kRpcHistoryEnabledDefault);
//            cInfo.OnLogClosed +:= new EventHandler(OnClientRpcLogClosedEventHandler);
            mClients.Add(cInfo);
            currentClientsCheckedListBox.Items.Add(cInfo.Name+'   connection = '+IntToStr(cInfo.BrokerConnectionIndex)+'  Id = '+IntToStr(cInfo.UniqueId));
          end;
        end;
      end;
    end
    else
    begin
      if (count > mClients.Count) then
      begin
        // We need to add a client to the list
        errorCode := mVistaSession.GetClientNameFromUniqueClientId(uniqueClientId, name);
        if (errorCode = Success) then
        begin
          errorCode := mVistaSession.GetActiveBrokerConnectionIndexFromUniqueClientId(uniqueClientId, connectIndex);
          if (errorCode = Success) then
          begin
            cInfo := TClientInfo.Create(uniqueClientId,name,connectIndex,kRpcHistoryEnabledDefault);
//            cInfo.OnLogClosed +:= new EventHandler(OnClientRpcLogClosedEventHandler);
            mClients.Add(cInfo);
            currentClientsCheckedListBox.Items.Add(cInfo.Name+'   connection = '+IntToStr(cInfo.BrokerConnectionIndex)+'  Id = '+IntToStr(cInfo.UniqueId));
          end;
        end;
      end
      else if (count < mClients.Count) then
      begin
        // We need to delete a client from the list
        foundIndex := -1;

        for i:=0 to Pred(mClients.Count) do
        begin
          cInfo := TClientInfo(mClients[i]);
         if (cInfo.UniqueId = uniqueClientId) then
          begin
            foundIndex := i;
            break;
          end;
        end;
        if (foundIndex <> -1) then
        begin
          (TClientInfo(mClients[foundIndex])).Visible := false;
          mClients.Delete(foundIndex);
          currentClientsCheckedListBox.Items.Delete(foundIndex);
        end;
      end;
    end;
  end;
end;


procedure TfrmSharedBrokerDebugger.RebuildConnectionList;
var
  ErrorCode: ISharedBrokerErrorCode;
  I, IndexCount: integer;
  BInfo: TBrokerConnectionInfo;
  ServerIP: WideString;
  ServerPort: Integer;
  LastContext: WideString;
begin
  IndexCount := 0;

  for i:=0 to Pred(mConnections.Count) do
    (TBrokerConnectionInfo(mConnections[i])).Visible := false;

  mConnections.Clear();
  actualBrokerConnectionsCheckedListBox.Items.Clear();

     Assert(mVistaSession <> nil);

  errorCode := mVistaSession.GetActiveBrokerConnectionIndexCount(indexCount);
  if (errorCode = Success) and (indexCount > 0) then
  begin
    serverIp := '';
    serverPort := 0;
    lastContext := '';

    for i:=0 to Pred(indexCount) do
    begin
      errorCode := mVistaSession.GetActiveBrokerConnectionInfo(i, serverIp, serverPort, lastContext);
      if (errorCode = Success) then
      begin
        bInfo := TBrokerConnectionInfo.Create(i,serverIp,serverPort,lastContext);
//            bInfo.OnLogClosed +:= new EventHandler(OnConnectionRpcLogClosedEventHandler);
        mConnections.Add(bInfo);
        actualBrokerConnectionsCheckedListBox.Items.AddObject(IntToStr(bInfo.ConnectionIndex) + '  server: '+bInfo.ConnectedServerIP+'  server port: '+IntToStr(bInfo.ConnectedServerPort) + '   Last Context = ' + bInfo.LastContext, bInfo);
      end;
    end;
  end;
end;
{
    private void MaxAllClientRpcLogEntriesNumericUpDown_ValueChanged(object sender, System.EventArgs e)
    begin
      // In case the max entry value is less than the rpc log entries delete the entries
      while (maxAllClientRpcLogEntriesNumericUpDown.Value < rpcCallLogListBox.Items.Count)
        rpcCallLogListBox.Items.RemoveAt(0);
    end;

    private void CurrentClientsCheckedListBox_ItemCheck(object sender, System.Windows.Forms.ItemCheckEventArgs e)
    begin
      ClientInfo cInfo := (ClientInfo)mClients[e.Index];

      if (e.NewValue = CheckState.Checked) then
      begin
        cInfo.Visible := true;
        // Transfer the current list of rpc call entries from the all rpc log
        // that correspond to this client
        RpcLogEntry entry;
        for i:=0 to Pred(rpcCallLogListBox.Items.Count) do
        begin
          entry := (RpcLogEntry)rpcCallLogListBox.Items[i];
          if (entry.UniqueClientId = cInfo.UniqueId) then
            cInfo.AddRpcLogEntry(entry,true);
        end;
      end;
      else 
        cInfo.Visible := false;
    end;

    private void ActualBrokerConnectionsCheckedListBox_ItemCheck(object sender, System.Windows.Forms.ItemCheckEventArgs e)

    private void RpcCallLogListBox_SelectedIndexChanged(object sender, System.EventArgs e)
    begin
      DisplayRpcEntry((RpcLogEntry)rpcCallLogListBox.Items[rpcCallLogListBox.SelectedIndex]);
      copySelectedRpcToClipboardMenuItem.Enabled := true;
    end;

procedure TfrmSharedBrokerDebugger.DisplayRpcEntry(entry: TRpcLogEntry)
  List: TStringList;
begin
  list := entry.CreateParamsDisplayString().Split('\n');
      paramsListBox.Items.Clear();
      foreach(string s in list)
        paramsListBox.Items.Add(s);

      resultsRichTextBox.Text      := entry.CreateResultsDisplayString();
      rpcNameOutputLabel.Text      := entry.Name;
      rpcDebugIdOutputLabel.Text    := entry.UniqueId.ToString();
      contextOutputLabel.Text      := entry.Context;
      string duration  ;
      if (entry.Duration < 1) then
        duration := '<1ms'
      else
        duration := entry.Duration.ToString() + 'ms';
      durationOutputLabel.Text    := duration;
      clientNameOutputLabel.Text    := entry.ClientName;
      clientDebugIdOutputLabel.Text  := entry.UniqueClientId.ToString();
    end;

procedure TfrmSharedBrokerDebugger.copySelectedRpcToClipboardMenuItem_Click(object sender, System.EventArgs e)
    begin
      // Build a string and put it on the clipboard here.
      Clipboard.SetDataObject(((RpcLogEntry)rpcCallLogListBox.SelectedItem).CreateClipboardString());
    end;
  end;
end;
}
procedure TfrmSharedBrokerDebugger.FormCreate(Sender: TObject);
var
 UniqueClientId: Integer;
 ErrMsg: WideString;
 LoginStr: WideString;
begin
  LoginStr := '';
  mClients := TList.Create;
  mConnections := TList.Create;
  mVistaSession.BrokerConnect(ParamStr(0),DebuggerClient,'',False,True,True,isemRaise,0,LoginStr,UniqueClientId,ErrMsg);
  mVistaSession.OnRpcCallRecorded := OnRpcCallRecordedEventHandler;
  mVistaSession.OnClientConnect := OnClientConnectEventHandler;
  mVistaSession.OnClientDisconnect := OnClientDisconnectEventHandler;
  mVistaSession.OnContextChanged := OnContextChangedEventHandler;
  mDoingAForcedLogoutOfClients := false;
  mOnLogoutPending := false;
  RebuildClientList(kNoUniqueClientId);
  RebuildConnectionList;
end;

procedure TfrmSharedBrokerDebugger.FormDestroy(Sender: TObject);
begin
  mClients.Free;
  mConnections.Free;
  mVistaSession.BrokerDisconnect;
end;

procedure TfrmSharedBrokerDebugger.btnExitClick(Sender: TObject);
begin
  Halt;
end;

procedure TfrmSharedBrokerDebugger.actualBrokerConnectionsCheckedListBoxClickCheck(
  Sender: TObject);
var
  BInfo, BInfo2: TBrokerConnectionInfo;
  Entry: TRpcLogEntry;
  CurrVal: Integer;
  i: Integer;
begin
  CurrVal := actualBrokerConnectionsCheckedListBox.ItemIndex;
  bInfo := (TBrokerConnectionInfo(mConnections[CurrVal]));
  bInfo2 := TBrokerConnectionInfo(actualBrokerConnectionsCheckedListBox.Items.Objects[CurrVal]);

      if (actualBrokerConnectionsCheckedListBox.Checked[CurrVal]) then
      begin
        bInfo.Visible := true;
        // Transfer the current list of rpc call entries from the all rpc log
        // That correspond to this connection
        for i:=0 to Pred(rpcCallLogListBox.Items.Count) do
        begin
          entry := (TRpcLogEntry(rpcCallLogListBox.Items.Objects[i]));
          if (entry.ConnectionIndex = bInfo2.ConnectionIndex) then
//          if (entry.ConnectionIndex = ActualBrokerConnectionsCheckedListBox.Items[CurrVal]) then
            TBrokerConnectionInfo(mConnections[CurrVal]).AddRpcLogEntry(entry,true);
        end;
      end
      else
        bInfo.Visible := false;
end;

procedure TfrmSharedBrokerDebugger.Exit1Click(Sender: TObject);
begin
  Halt;
end;

procedure TfrmSharedBrokerDebugger.About1Click(Sender: TObject);
begin
  ShowAboutBox;
end;

procedure TfrmSharedBrokerDebugger.CopyConnectionsLogToClipboard1Click(
  Sender: TObject);
begin
  clientConnectionsLogRichTextBox.SelectAll;
  clientConnectionsLogRichTextBox.CopyToClipboard;
end;

procedure TfrmSharedBrokerDebugger.CurrentClientsCheckedListBoxClickCheck(
  Sender: TObject);
var
  CInfo: TClientInfo;
  Entry: TRpcLogEntry;
  CurrVal: Integer;
  i: Integer;
  listobjUniqueClientID: Integer;
begin
  CurrVal := CurrentClientsCheckedListBox.ItemIndex;
  CInfo := (TClientInfo(mclients[CurrVal]));
  listobjUniqueClientId := CInfo.UniqueId;

  if (CurrentClientsCheckedListBox.Checked[CurrVal]) then
  begin
    CInfo.Visible := true;
    // Transfer the current list of rpc call entries from the all rpc log
    // That correspond to this connection
    for i:=0 to Pred(rpcCallLogListBox.Items.Count) do
    begin
      entry := (TRpcLogEntry(rpcCallLogListBox.Items.Objects[i]));
      if (entry.UniqueClientId = listobjUniqueClientId) then
//          if (entry.ConnectionIndex = ActualBrokerConnectionsCheckedListBox.Items[CurrVal]) then
        TClientInfo(mClients[CurrVal]).AddRpcLogEntry(entry,true);
    end;
  end
  else
    CInfo.Visible := false;
end;

end.
