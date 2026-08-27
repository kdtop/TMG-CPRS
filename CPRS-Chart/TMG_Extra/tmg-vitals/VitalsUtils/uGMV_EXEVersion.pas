unit uGMV_EXEVersion;

interface
uses
  uGMV_VersionInfo
  ;
function IsThisExeCompatibleVersion: Boolean;

implementation

uses uGMV_Const
  , uGMV_Engine;


function IsThisExeCompatibleVersion: Boolean;
begin
//  CallRemoteProc(RPCBroker, RPC_PARAMETER, ['GETPAR', 'SYS', 'GMV GUI VERSION', CurrentExeNameAndVersion], nil);
//  Result := (Pos('Y', RPCBroker.Results[0]) > 0);

  Result := (Pos('Y',getEXEInfo(CurrentExeNameAndVersion))>0);
end;


end.
