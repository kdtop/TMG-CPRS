{ ******************************************** }
{       RegFuncs ver 1.1 (Jan. 16, 2004)         }
{                                              }
{       For Delphi 4, 5 and 6                  }
{                                              }
{       Copyright (C) 1999-2003, Kurt Senfer.  }
{       All Rights Reserved.                   }
{                                              }
{       Support@ks.helpware.net                }
{                                              }
{       Documentation and updated versions:    }
{                                              }
{       http://KS.helpware.net                 }
{                                              }
{ ******************************************** }
{
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

Unit RegFuncs;



Interface

Uses Windows;

Function ReadRegString(MainKey: HKey; SubKey, ValName: String): String;
Procedure WriteRegString(MainKey: HKey; SubKey, ValName: String; const Data: String);
function GetExeOpen(Ext: string; var Exefil, Params: string; sielent: boolean = true): Boolean;
procedure ExecuteDefaultOpen(ext, aFile: String);

Implementation

uses
  Sysutils, KS_procs, ShellAPI;


//------------------------------------------------------------------------------
function GetMainKeyAsString(Key: HKey):string;
begin 
  //asm int 3 end; //trap
  case Key of
     $80000000 : result := 'HKEY_CLASSES_ROOT';
     $80000001 : result := 'HKEY_CURRENT_USER';
     $80000002 : result := 'HKEY_LOCAL_MACHINE';
     $80000003 : result := 'HKEY_USERS';
     $80000004 : result := 'HKEY_PERFORMANCE_DATA';
     $80000005 : result := 'HKEY_CURRENT_CONFIG';
     $80000006 : result := 'HKEY_DYN_DATA';
  else result := 'Unknown key';
  end;
end;

//------------------------------------------------------------------------------
Function ReadRegString(MainKey: HKey; SubKey, ValName: String): String;
  // NB default value is read if subkey isent ended with a backslash
Var
  Key: HKey;
  C: Array[0..1023] of Char;
  D: Cardinal;  //value type
  D2: Cardinal; //buffer size
Begin 
  //asm int 3 end; //trap
  result := '';

  if RegOpenKeyEx(MainKey, Pchar(NoEndBackSlash(SubKey)), 0, KEY_READ, Key) = ERROR_SUCCESS
     then begin
        try
           C := '';
           D2 := SizeOf(C);
           if (RegQueryValueEx(Key, Pchar(ValName), Nil, @D, @C, @D2) = ERROR_SUCCESS) and
              ((D = REG_EXPAND_SZ) or (D = REG_SZ))
              then result := C
              else result := '';
        finally
           RegCloseKey(Key);
        end;
     end
     else DeveloperMessage('Failed to open registry key for reading string'+CrLf+ GetMainKeyAsString(MainKey) + ', '+ SubKey);
End;
//------------------------------------------------------------------------------
const
  KeyVal: Integer = KEY_WRITE  or  KEY_EXECUTE or KEY_QUERY_VALUE;
//------------------------------------------------------------------------------
Procedure WriteRegString(MainKey: HKey; SubKey, ValName: String; const Data: String);
Var
  Key: HKey;
  D: Cardinal;
Begin
  //asm int 3 end; //trap
  if RegCreateKeyEx(MainKey, Pchar(NoEndBackSlash(SubKey)), 0, Nil, REG_OPTION_NON_VOLATILE, KeyVal, Nil, Key, @D) = ERROR_SUCCESS
     then begin
        try
           RegSetValueEx(Key, Pchar(ValName), 0, REG_SZ, PChar(Data), Length(Data));
        finally
           RegCloseKey(Key);
        end;
     end
     else KSMessageW('Failed to open registry key for writing string'+CrLf+ GetMainKeyAsString(MainKey) + ', '+ SubKey);
End;
//------------------------------------------------------------------------------
function GetExe_(Ext, Actiontype: string; var Exefil, Params: string; sielent: boolean = true): Boolean;
{ the best way to find an exe is trugh the registry entries - ther we get any
  command line param that might be neded, but if it fails we can try FindExecutable
  (witch is in the center og the _GetExeOpen function), but it only returns the
  exe file }
var
  S: string;
  I: integer;

  //------------------------------------------
  procedure LastTry;
  begin
     Params :='';
     Result :=_GetExeOpen(ext, ExeFil, sielent);
     if not result
        then DeveloperMessage('_GetExeOpen failed');
  end;
  //------------------------------------------
  procedure HandleRegInfo(RegData: String);
  begin
     if length(RegData) = 0
        then begin
           //somthings missing in the registry
           DeveloperMessage('GetExeOpen: read exe from registry failed');
           LastTry;
           exit;
        end;

     { there might be several traling "%x" params - we remove them all
       our caling procedure expect that the string we return can be used
       to start a program and open a file just by using the file as a
       trailing param }

     I := pos('"%', RegData);
     while I > 0 do
        begin
           delete(RegData, I, length('"%1"')); //we expect max 9 params
           I := pos('"%', RegData);
        end;

     Exefil := Trim(RegData);

     { now we have an exefile and it can have some params starting with
       " /" or " -" }
     I := Pos(' /', Exefil);
     if I > 0
        then begin
           //we have params
           Params := Exefil;
           Exefil := Copy(Exefil, 1, I - 1);
           Delete(Params, 1, I);
        end
        else begin
           I := Pos(' -', Exefil);
           if I > 0
              then begin
                 //we have params
                 Params := Exefil;
                 Exefil := Copy(Exefil, 1, I - 1);
                 Delete(Params, 1, I);
              end
              else Params := '';
        end;

     //params is now in Params - if any

     // Remove sourounding " from the file path
     if (Copy(Exefil, 1, 1) = #34) and //leading "
        (Exefil[Length(Exefil)] = #34)  //trailing "
        then Exefil := Copy(Exefil, 2 , length(Exefil) -2);

     //we migt have an exe without a path - try the windows folder
     if pos('\', ExeFil) = 0
        then ExeFil := GetWinDir+ExeFil;

     result := FileExists(Exefil);

     if not result
        then LastTry;
  end;
  //------------------------------------------
begin
  //asm int 3 end; //trap
  Result := false;

  if length(ext) = 0
     then begin
        S := 'Call to GetExeOpen with an empty extension param';
        if not Sielent
           then KSMessageE(S)
           else DeveloperMessage(S);

        exit;
     end;

  if ext[1] = '.'
     then delete(ext, 1, 1);

  S := ReadRegString(HKEY_CLASSES_ROOT, '.' + ext, '');
  if length(s) > 0
     then HandleRegInfo(ReadRegString(HKEY_CLASSES_ROOT, s + '\shell\'+Actiontype+'\command', ''))

          //try The open command - a wery exotic way, maybe an oldish way ?
     else HandleRegInfo(ReadRegString(HKEY_CLASSES_ROOT, '.' + ext + '\shell\'+Actiontype+'\command', ''));

  if (not result) and (not Sielent)
     then KSMessageE('No default '+Actiontype+' program for "'+Ext+'"');
end;

//------------------------------------------------------------------------------
function GetExeOpen(Ext: string; var Exefil, Params: string; sielent: boolean = true): Boolean;
begin
  //asm int 3 end; //trap
  result := GetExe_(Ext, 'Open', Exefil, Params, sielent);
end;
//------------------------------------------------------------------------------
procedure ExecuteDefaultOpen(ext, aFile: String);
var
  ExeFil: string;
  Params: string;
begin
  //asm int 3 end; //trap
  DeveloperMessage('Findeing default EXE for: '+ext);

  if GetExeOpen(ext, ExeFil, Params, cNotSilent)
     then DeveloperMessage('Default EXE for: '+ext+CrLf+ExeFil)
     else exit;

  DeveloperMessage('Starting: '+ExeFil);

  if length(Params) > 0
     then Params := ' ' + Params + ' "'+ aFile + '"'
     else Params := ' "' + aFile + '"';

  if not fileExec('"' + ExeFil + '"' + Params, '', false)
     then begin
        KSMessageE('Could not run "'+ExtractFileName(ExeFil)+'"');
     end;
end;
//------------------------------------------------------------------------------
end.
