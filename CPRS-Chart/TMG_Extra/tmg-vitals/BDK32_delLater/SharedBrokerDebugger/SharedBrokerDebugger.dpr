program SharedBrokerDebugger;

uses
  Forms,
  uBrokerConnectionInfo in 'uBrokerConnectionInfo.pas',
  uClientInfo in 'uClientInfo.pas',
  fSharedBrokerDebugger in 'fSharedBrokerDebugger.pas' {frmSharedBrokerDebugger},
  fClientRPCLogger in 'fClientRPCLogger.pas' {frmRpcClientLogger},
  uRpcLogEntry in 'uRpcLogEntry.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSharedBrokerDebugger, frmSharedBrokerDebugger);
  Application.Run;
end.
