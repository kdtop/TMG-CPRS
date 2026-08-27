unit uGMV_DeafultTemplates;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 3/08/04 4:42p $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Main user interface window.  (Application.MainForm)
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry/uGMV_DeafultTemplates.pas $
*
* $History: uGMV_DeafultTemplates.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:35p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:20p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
 *
*
================================================================================
}

interface

uses
  SysUtils,
  Classes,
  TRPCB;

type
  TGMV_DefaultTemplates = class(TObject)
  private
    FTemplates: TStringList;
    FBroker: TRPCBroker;
  public
    constructor Create(Broker: TRPCBroker);
    destructor Destroy; override;
    function DefaultTemplate(Entity: string): string;
    function IsDefault(Entity: string; Name: string): boolean;
  end;

var
  GMVDefaultTemplates: TGMV_DefaultTemplates;

implementation

uses u_PCall, uGMV_Const, u_Common;

{ TGMV_DefaultTemplates }

constructor TGMV_DefaultTemplates.Create(Broker: TRPCBroker);
begin
  inherited Create;
  FTemplates := TStringList.Create;
  FBroker := Broker;
  CallRemoteProc(Broker, RPC_MANAGER, ['GETDEF'], nil, [], FTemplates);
end;

function TGMV_DefaultTemplates.DefaultTemplate(Entity: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to FTemplates.Count - 1 do
    if Piece(FTemplates[i], '^', 1) = Entity then
      begin
        Result := Piece(FTemplates[i], '^', 2);
        Exit;
      end
end;

destructor TGMV_DefaultTemplates.Destroy;
begin
  FreeAndNil(FTemplates);
  FBroker := nil;
  inherited;
end;


function TGMV_DefaultTemplates.IsDefault(Entity, Name: string): boolean;
begin
  result := False;
  try
    Result := (FTemplates.IndexOf(Entity + '^' + Name) > -1);
  except
  end;
end;

end.
