unit uGMV_DLLCommon;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 1/25/06 8:54a $
*       Developer:    andrey.andriyevskiy@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Common DLL handling functions.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals 5.0.3/DLL-Common/DLLCommon.pas $
*
* $History: DLLCommon.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 1/25/06    Time: 8:57a
 * Created in $/Vitals/Vitals 5.0.3/DLL-Common
 * 060125 test
 *

 ================================================================================
}
interface

uses
  Forms,Windows,Dialogs;

  procedure FindModule(const aLibrary: String; const aModule:String;var H:THandle;var P: Pointer);
  function RunDLLDialog(aLibrary,aFunction:String): Integer;

implementation

// Note: Don't forget to free memory if H is not 0!
procedure FindModule(const aLibrary: String; const aModule:String;var H:THandle;var P: Pointer);
var
  DLLHandle: THandle;
begin
  P := nil;
  DLLHandle:= 0;
  try
    DLLHandle := LoadLibrary(PChar(aLibrary));
    if DLLHandle <> 0 then
      begin
        H := DLLHandle;
        P := nil;
        P := GetProcAddress(DLLHandle,PChar(aModule));
{$IFNDEF USEVSMONITOR}
        if not Assigned(P) then
         ShowMessage('Error: Failure loaging function <'+aModule+'>');
      end
    else
      ShowMessage('Error: Failure loaging library <'+PChar(aLibrary)+'>');
{$ELSE}
      end
{$ENDIF}
  except
    H := 0;
    P := nil;
  end;
end;

function RunDLLDialog(aLibrary,aFunction:String): Integer;
type
  TFuncSign = function:Integer;
var
  FuncSign : TFuncSign;
  DLLHandle : THandle;
  P: Pointer;
  i: Integer;
begin
  i := -1;
  FindModule(aLibrary,aFunction,DLLHandle,P);
  if Assigned(P) then
    begin
      @FuncSign := P;
      i := FuncSign;
    end;
  @FuncSign := nil;
  FreeLibrary(DLLHandle);
  Result := i;
end;

end.
