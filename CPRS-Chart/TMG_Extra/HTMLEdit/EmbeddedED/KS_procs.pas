{ ******************************************** }
{       KS_Procs ver 1.2 (Jan. 16, 2004)       }
{                                              }
{       For Delphi 4, 5 and 6                  }
{                                              }
{       Copyright (C) 1999-2004, Kurt Senfer.  }
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
  
unit KS_Procs;

interface

uses
  Windows, ShellAPI, Messages, SysUtils, math, classes ;

Var
  ActualAppName: string = '';
  ShowDeveloperMessages: boolean = false;
  DeveloperMessagesCanceled: boolean = false;
  DeveloperMessagesLog: string = '';
  ActualWinDir: string = '';

const
  NoShowError: Boolean = False; // NoShowError, NoCache, NoHtmlFile
  ShowError: Boolean = true;
  NoCache: Boolean = true;
  NoHtmlFile: Boolean = true;

const
  { several important ASCII codes }
//  NULL = #0;
  BACKSPACE = #8;
  TAB = #9;
  LF = #10;
  CR = #13;
  EOF_ = #26;
  ESC = #27;
  Space = #32;
  BlackSpace = [#33..#255];
  CrLf: String = #13+#10;
  DblCrLf: String = #13+#10+#13+#10;

const
  { digits as chars }
  ZERO = '0';
  ONE = '1';
  TWO = '2';
  THREE = '3';
  FOUR = '4';
  FIVE = '5';
  SIX = '6';
  SEVEN = '7';
  EIGHT = '8';
  NINE = '9';
  DIGITS: set of Char = [ZERO..NINE];

  cSilent: boolean = true;
  cNotSilent: boolean = false;


type
  TMonth = (NoneMonth, January, February, March, April, May, June, July,
    August, September, October, November, December);

type
  TDayOfWeek = (Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday);

type
  TBit = 0..31;

type
  TFileTimeComparision = (ftError, ftFileOneIsOlder, ftFileTimesAreEqual, ftFileTwoIsOlder);

type
  TTimeOfWhat = (ftCreationTime, ftLastAccessTime, ftLastWriteTime);

type
  TDriveType = (dtUnknown, dtNoDrive, dtFloppy, dtFixed, dtNetwork, dtCDROM, dtRAM);


type
  TVolumeInfo = record
    Name: string;
    SerialNumber: DWORD;
    MaxComponentLength: DWORD;
    FileSystemFlags: DWORD;
    FileSystemName: string;
  end;                        // TVolumeInfo

type
  PFixedFileInfo = ^TFixedFileInfo;
  TFixedFileInfo = record
    dwSignature: Cardinal;
    dwStrucVersion: Cardinal;
    wFileVersionMS: WORD;     // Minor Version
    wFileVersionLS: WORD;     // Major Version
    wProductVersionMS: WORD;  // Build Number
    wProductVersionLS: WORD;  // Release Version
    dwFileFlagsMask: Cardinal;
    dwFileFlags: Cardinal;
    dwFileOS: Cardinal;
    dwFileType: Cardinal;
    dwFileSubtype: Cardinal;
    dwFileDateMS: Cardinal;
    dwFileDateLS: Cardinal;
  end;                        // TFixedFileInfo

procedure KSProcessMessages;
procedure KSWait(aTime: Cardinal);

function CopyCursor(cur: HCURSOR): HCURSOR;
function _GetExeOpen(const Ext: string; var Exefil: string; sielent: boolean = true): Boolean;
Function GetModuleName(aFile: string = ''): String;
Function GetFileDateTime(aFile: string): String;
Function GetShortDateTime(aTime: TDateTime; Seconds: boolean = false): String;
function GetAbsolutePath(ActualPath: string; var RelativePath: string): boolean;
function KSMessage(aMessage: string; aBoxHead: string; Params: integer): integer;
function KSQuestion(aMessage: string; aBoxHead: string = ''; Params: integer = MB_ICONQUESTION or MB_YESNO): integer;
Procedure KSMessageW(aMessage: string; aBoxHead: string = '');
Procedure KSMessageE(aMessage: string; aBoxHead: string = '');
Procedure KSMessageQ(aMessage: string; aBoxHead: string = '');
Procedure KSMessageI(aMessage: string; aBoxHead: string = '');
Procedure KSMessageT(aMessage: string; aBoxHead: string = '');
procedure DeveloperMessage(aMessage: string);
function CloseDeveloperMessagesLog(afile: string): boolean;
function SaveDeveloperMessagesLog(afile: string): boolean;
procedure OpenDeveloperMessagesLog;
          
function IsAlNum(C: char): bool;
function RegisterAxLib(FileName: string; Unreg: Boolean = False): boolean;
procedure SearchForFiles(path, mask: AnsiString; var Value: TStringList; Recurse: Boolean = False);

function StringIsInteger(Const S: String): boolean;
function _StringIsInteger(Const S: String; var I: Integer): boolean;
function KSDelete(var S: String; DeleteString: String; All: Boolean = False): boolean;
{Deletes one or more instances of S}

function GetFileDateAsString(aFile: string): String;
function DosLocalTimeToDosUTCTime(aDosFileTime: Integer): Integer;
function GetUTCFileDateAsString(aFile: string): String;
function UTCFileAge(const FileName: string): Integer;
function KSSetCurrentDir(const Dir: string): Boolean;
function KSEmptyDir( aDir: string): Boolean;
function DelDir(aDir: string): boolean;
function Squish(const Search: string): string;
{squish() returns a string with all whitespace not inside single
quotes deleted.}
function Before(const Search, Find: string): string;
{before() returns everything before the first occurance of Find
in Search. If Find does not occur in Search, Search is returned.}
function beforeX(const Search, Find: string): string;
{before() returns everything before the first occurance of Find
in Search. If Find does not occur in Search, An empty string is returned.}
function After(const Search, Find: string): string;
{after() returns everything after the first occurance of Find
in Search. If Find does not occur in Search, a null string is returned.}
function RPos(const Find, Search: string): Integer;
{RPos() returns the index of the first character of the last occurance
of Find in Search. Returns 0 if Find does not occur in Search.
Like Pos() but searches in reverse.}

function LastChar(const Search: string; const Find: char): Integer;
{LastChar() returns the index of the last character of Find in Search.
 Returns 0 if Find does not occur in Search.}

function AfterLastToken(const StrInd, Token: string): string;

function KsSameText(S1, S2: string; MaxLen: Cardinal): boolean;
//same as AnsiSameText but the string are only compared up to MaxLen

function BeforLastToken(const StrIn, Token: string): string;
function BeforeFirstToken(const S: string; Token: Char): string;
//Returnerer alt før Token som Result

function strMake(C: Char; Len: Integer): string;
//Returns a string with a specified number of a specified Char
function strPadChL(const S: string; C: Char; Len: Integer): string;
//Fills leading Char's into a string up to a specified length

//Fills leading Zeroes into a string up to a specified length
function strPosAfter(const aSubstr, S: string; aOfs: Integer): Integer;
//Returns the posision of the first occurence of a substring in a string after a specified offset
function strChange(var S: string; const Src, Dest: string): boolean;
//Changes every ocuranc of a text in a string with new text
function strEndSlash(const S: string): string;
//Returns a string with a trailing slash (\)
function strEndSlashX(const S: string): string;
//returns a string with a trailing slash (/)
function NoEndBackSlash(const S: string): string;
//Returns a string without a traling slash (\)

function NoStartSlash(const S: string): string;
//Returns a string without a leading slash (/)

function SplitAtToken(var S: string; Token: Char): string;
function SplitAtTokenStr(var S: string; Token: string): string;
//returnerer alt før Token som Result, og alt efter Token i S
function strTokenCount(S: string; Token: Char): Integer;
//Returnerer antal token i S
function AfterTokenNr(const S: string; Token: Char; Nr: Integer): string;
//Returns the right part of an string after token (Char) Nr.
function BeforeTokenNr(const S: string; Token: Char; Nr: Integer): string;
//Returns the left part of an string before token (Char) Nr.

function strLastCh(const S: string): string;
//Returns the last char in a string

type                          { Search and Replace options }
  TSROption = (srWord, srCase, srAll);
  TSROptions = set of TsrOption;

function DropLastDir(path: string): string;
//fjerner sidste directory fra stien i path

type
  TCharSet = set of Char;


{ Integer functions }
function intMax(a, b: Integer): Integer;
//Returns the highest value
function intMin(a, b: Integer): Integer;
//Returns the lowest value

{ date functions }
Function DateStrToDateTime(aDate: string): TDateTime;
Function TimeStrToDateTime(aDateTime: string): TDateTime;
//function dateYear(D: TDateTime): Integer;

function fileSizeEx(const Filename: string): Longint;
//returns the size of a file in bytes

function KSForceDirectories(Dir: string): Boolean;

function GetShareFromURN(const URN: string; var Share: string; aPath: string = ''): boolean;

function ExecuteFile(handle: HWND; const FileName, Params, DefaultDir: string; ShowCmd: Integer; Silent: boolean = true): THandle;
//run an exefile

function fileCopy(const SourceFile, TargetFile: string): Boolean;
//copy a file (with date info)
function fileMove(const SourceFile, TargetFile: string): Boolean;
function fileTemp(const aExt: string = ''): string;
//Returns a unique temparary filename
function fileTempEx(const aName: string): string;
//Returns a unique temparary filename based on the suplied filename

function KSGetCurrentDirectory: string;
//Returns the current directory for the current process

function DirExists(const Name: string): Boolean;
function GetLogicalPathFromUNC(var aUNC :string): Boolean;
//returns a normal filepath fore a UNC-filepath
Function GetFirstNetworkDrive: string;
//returns the UNC-filepath fore the first network-drive
function KSGetTempPath: string;
//Returns the path of the directory designated for temporary files
function KSGetLogicalDrives: string;
//Returns a string that contains the currently available disk drives
function GetFirstAviableDriveLetter: string;

function KSGetFileTime(const FileName: string; ComparisonType: TTimeOfWhat): TFileTime;
// Returns the date and time that a file was created, last accessed, or last modified

function KSCompareFileTime(const FileNameOne, FileNameTwo: string; ComparisonType: TTimeOfWhat): TFileTimeComparision;
//Compares two files timestamps
function FileDifferent(const Sourcefile: string; TargetPath: string): Boolean;
//Returnere true hvis de to filer har forskellig dato eller størrelse
function KSFileGetDateTime(const aFile: string): TDateTime;
//Returnere TdateTime for en fils dato
function GetFileTimeEx(const FileName: string; ComparisonType: TTimeOfWhat): TDateTime;
// Returns the date and time that a file was created, last accessed, or last modified as TDateTime

Function GetFreeDiskSize(TheDrive: String):Int64;
//Returns the amount of free space on the specified disk
function ShortFileNameToLFN(ShortName: String): String;
function GetFullPathNameEx(const Path: string): string;
//Returns the full path and filename of a specified file
function fileExec(const aCmdLine: string; const aAppName: string = ''; aHide: Boolean = True;
           aWait: Boolean = False; bWait: Boolean = False): Boolean;
//Executes a file and wait as specified

{ system functions }
function GetWindir: string;
//Returns the windows directory
procedure WinExecError(iErr: Word; const sCmdLine: string);
//Returns a dialogbox with the explanation of an WinExecError

procedure PrintWordDoc(const fil: string; handle: HWND);

{System Information }
function KSGetUserName(Uppercase: boolean = true): string;
function GetNetUserName(const aResource: string = ''): string;
function KSGetNetUserName(const aResource: string = '?'): string;
function GetUserCookie: string;
//returns current username
Function GetFileAsText(const afile: String): String;
function SaveTextAsFile(const afile, Text: String): Boolean;

function KSGetSystemDirectory: string;
//Returns system directory

// Time Functions
function KSGetSystemTime: string;
//returns date and time

function GetWindowFromText(const WindowText: string): Hwnd;
{returnere en handle til vinduet hvis det findes}


function CtrlDown: Boolean;


function GetSystemErrorMessage(var aFmtStr: String; ErrorAccept: Integer = ERROR_SUCCESS): boolean;
function GetErrorString(var aFmtStr: String; ErrorCode: Integer): boolean;

function GetLastErrorStr: string;
function ShowLastErrorIfAny(anError: Integer; Handle: Hwnd = 0): Boolean;

implementation

uses RegFuncs;

//------------------------------------------------------------------------------
function CopyCursor(cur: HCURSOR): HCURSOR;
begin
   result := HCURSOR(CopyIcon(HICON(cur)));
   { The typecasts are actually not necessary in Delphi since all handle type
     are compatible with each other, since they all are aliases for DWORD }
end;
//------------------------------------------------------------------------------
function _StringIsInteger(Const S: String; var I: Integer): boolean;
{
var
  Err: Integer;
begin
  Val(S, I, Err);
  Result := (Err = 0);   This raises an error i debugging
end;
}

var a: Integer;
begin
  //asm int 3 end; //trap
  result := FALSE;
  I := 0;

  if (length(s) > 0) and (s[1] in ['+','-','0'..'9'])
     then begin
        for a := 2 to length(s) do
           if not (s[a] in ['0'..'9'])
              then begin
                 if (a > 3) or //min two good numbers before the trird that is bad
                    ((a = 2) and (not (s[1] in ['+','-']))) //first number is good
                    then I := StrToInt(Copy(S, 1, a -1));
                 exit;
              end;

        result := true;
        I := StrToInt(S);
     end;
end;
//------------------------------------------------------------------------------
function StringIsInteger(Const S: String): boolean;
var
  I: Integer;
begin
  //asm int 3 end; //trap
  result := _StringIsInteger(S, I);
end;
//------------------------------------------------------------------------------
{ bit manipulating }

//------------------------------------------------------------------------------
function strMake(C: Char; Len: Integer): string;
//Returns a string with a specified number of a specified Char
begin
  //asm int 3 end; //KS trap
  Result := strPadChL('', C, Len);
end;
//------------------------------------------------------------------------------
function strPadChL(const S: string; C: Char; Len: Integer): string;
//Fills leading Char's into a string up to a specified length
begin
  //asm int 3 end; //KS trap
  Result := S;
  while Length(Result) < Len
    do Result := C + Result;
end;
//------------------------------------------------------------------------------
function strEndSlash(const S: string): string;
//returns a string with a trailing slash (\)
begin
  //asm int 3 end; //trap
  Result := S;
  if strLastCh(Result) <> '\'
    then Result := Result + '\';
end;
//------------------------------------------------------------------------------
function strEndSlashX(const S: string): string;
//returns a string with a trailing slash (/)
begin
  //asm int 3 end; //trap
  Result := S;
  if strLastCh(Result) <> '/'
    then Result := Result + '/';
end;
//------------------------------------------------------------------------------
function NoEndBackSlash(const S: string): string;
//Returns a string without a traling slash (\)
begin 
  //asm int 3 end; //trap
  Result := S;
  if strLastCh(Result) = '\'
    then Delete(Result, Length(Result), 1);
end;
//------------------------------------------------------------------------------
function NoStartSlash(const S: string): string;
//Returns a string without a leading slash (/)
begin
  //asm int 3 end; //KS trap
  Result := S;
  if (length(Result) > 0) and  (Result[1] = '/')
    then Delete(Result, 1, 1);
end;
//------------------------------------------------------------------------------
function SplitAtToken(var S: string; Token: Char): string;
//Splits up a string at a specified substring
//Returnerer alt før Token som Result, og alt efter Token i S
var
  I: Word;
begin
  //asm int 3 end; //trap
  I := Pos(Token, S);
  if I <> 0
    then begin
      Result := System.Copy(S, 1, I - 1);
      System.Delete(S, 1, I);
    end
  else begin                  //der er ingen token
      Result := S;
      S := '';
    end;
end;
//------------------------------------------------------------------------------
function BeforeFirstToken(const S: string; Token: Char): string;
//Returnerer alt før Token som Result
var
  I: Word;
begin
  //asm int 3 end; //trap
  I := Pos(Token, S);
  if I <> 0
    then Result := System.Copy(S, 1, I - 1)
     else Result := S;                 //der er ingen token
end;
//------------------------------------------------------------------------------
function SplitAtTokenStr(var S: string; Token: string): string;
//Splits up a string at a specified substring
//Returnerer alt før Token som Result, og alt efter Token i S
var
  I: Word;
begin
  //asm int 3 end; //trap
  I := Pos(Token, S);
  if I <> 0
    then begin
      Result := System.Copy(S, 1, I - 1);
      System.Delete(S, 1, I + length(Token)-1);
    end
  else begin                  //der er ingen token
      Result := S;
      S := '';
    end;
end;
//------------------------------------------------------------------------------
function strTokenCount(S: string; Token: Char): Integer;
//Returns the number of Char in S
var
  //s1: string;
  i: Integer;
begin
  //asm int 3 end; //trap
  Result := 0;
  I := pos(Token, S);
  if i = 0
    then exit;

  repeat
    Inc(Result);
    s := copy(S, i + 1, length(s));
    I := pos(Token, S);
    if i = 0
      then break;
  until false;

end;
//------------------------------------------------------------------------------
function AfterTokenNr(const S: string; Token: Char; Nr: Integer): string;
//Returns the right part of an string after token (Char) Nr.
var
  j, i: Integer;
begin
  //asm int 3 end; //KS trap
  Result := '';
  j := 1;
  i := 0;

  while (i <= Nr) and (j <= Length(S))
    do begin
      if S[j] = Token
        then begin
          Inc(i);
          if i = Nr
            then break;
        end;
      Inc(j);
    end;                      //while

  Result := copy(s, j + 1, length(S));
end;
//------------------------------------------------------------------------------
function BeforeTokenNr(const S: string; Token: Char; Nr: Integer): string;
//Returns the left part of an string before token (Char) Nr.
var
  j, i: Integer;
begin
  //asm int 3 end; //KS trap
  Result := '';
  j := 1;
  i := 0;

  while (i <= Nr) and (j <= Length(S))
    do begin
      if S[j] = Token
        then begin
          Inc(i);
          if i = Nr
            then break;
        end;
      Inc(j);
    end;                      //while

  Result := copy(s, 0, j - 1);

end;
//------------------------------------------------------------------------------
function strPosAfter(const aSubstr, S: string; aOfs: Integer): Integer;
//Returns the posision of the first occurence of a substring in a string
//after a specified offset
begin
  //asm int 3 end; //trap
  Result := Pos(aSubStr, Copy(S, aOfs, (Length(S) - aOfs) + 1));
  if (Result > 0) and (aOfs > 1)
    then Inc(Result, aOfs - 1);
end;
//------------------------------------------------------------------------------
function strChange(var S: string; const Src, Dest: string): boolean;
//Changes every ocuranc of a text in a string with new text
var
  Org: String;
begin
  //asm int 3 end; //trap
  Org := S;
  S := StringReplace(S, Src, Dest,  [rfReplaceAll]);
  result := not AnsiSameText(Org,  S);
end;
//------------------------------------------------------------------------------
function strLastCh(const S: string): string;
//Returns the last char in a string
var
  i: integer;
begin
  //asm int 3 end; //trap
  i := Length(S);
  if i > 0
    then Result := S[Length(S)]
  else Result := '';
end;
//------------------------------------------------------------------------------
{ Integer stuff }
//------------------------------------------------------------------------------
function IntMax(a, b: Integer): Integer;
//Returns the highest value
begin
  //asm int 3 end; //trap
  if a > b
    then Result := a
  else Result := b;
end;
//------------------------------------------------------------------------------
function IntMin(a, b: Integer): Integer;
//Returns the lowest value
begin
  //asm int 3 end; //KS trap
  if a < b
    then Result := a
  else Result := b;
end;
//------------------------------------------------------------------------------
function ExecuteFile(handle: HWND; const FileName, Params, DefaultDir: string; ShowCmd: Integer; Silent: boolean = true): THandle;
begin
  //asm int 3 end; //trap
  {a caling procedure can normally get a hanle like this: Application.MainForm.Handle }
  Result := ShellExecute(handle, nil,
    Pchar(FileName), Pchar(Params), Pchar(DefaultDir), ShowCmd);

  if (Result < 32) and (ShowDeveloperMessages or (not silent))
     then WinExecError(Result, Filename);
end;
//------------------------------------------------------------------------------
function fileCopy(const SourceFile, TargetFile: string): Boolean;
begin
  //asm int 3 end; //trap
  Result := CopyFile(Pchar(SourceFile), Pchar(TargetFile), False);
  //                       Existing file      Copy of file
end;
//------------------------------------------------------------------------------
function fileMove(const SourceFile, TargetFile: string): Boolean;
begin 
  //asm int 3 end; //KS trap
  Result := MoveFile(Pchar(SourceFile), Pchar(TargetFile));
  //                       Existing file      New file
end;
//------------------------------------------------------------------------------
function fileTemp(const aExt: string = ''): string;
//Returns a unique temparary filename
var
  Buffer: array[0..1023] of Char;
  aFile: string;
begin

  //asm int 3 end; //KS trap
  GetTempPath(Sizeof(Buffer) - 1, Buffer);
  GetTempFileName(Buffer, 'TMP', 0, Buffer);
  SetString(aFile, Buffer, StrLen(Buffer));

  if length(aExt) > 0
     then begin
        Result := ChangeFileExt(aFile, aExt);
        RenameFile(aFile, Result);
     end
     else result := aFile;
end;
//------------------------------------------------------------------------------
function fileTempEx(const aName: string): string;
//Returns a unique temparary filename based on the suplied filename
var
  Buffer: array[0..1023] of Char;
  aFile: string;
  aPath: string;
  aExt: string;
begin 
  //asm int 3 end; //KS trap
  aPath := ExtractFilePath(aName);
  if length(aPath) = 0
     then begin
        GetTempPath(Sizeof(Buffer) - 1, Buffer);
        aPath := Buffer;
     end;

  aExt := ExtractFileName(aName);
  aFile := SplitAtToken(aExt, '.');

  while true do
     begin
        GetTempFileName(Pchar(aPath), '_', 0, Buffer);
        result := aPath + aFile + ChangeFileExt(ExtractFileName(Buffer), '.'+aExt);
        if not FileExists(result)
           then break;
     end;
end;
//------------------------------------------------------------------------------
function fileExec(const aCmdLine: string; const aAppName: string = ''; aHide: Boolean = True;
           aWait: Boolean = False; bWait: Boolean = False): Boolean;
//Executes a file and wait as specified
//aWait = vent på inputidle, bWait = vent på at programmet stopper igen
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  dwI : Cardinal;
  dwCreationFlags: Cardinal;
  S, S1: string;
  //lpExitCode: DWORD;
  //Msg: TMsg;
begin 
  //asm int 3 end; //trap
  result := false;

  //dont try to start a non existing program - can cause troubles
  if (Length(aCmdLine) = 0) and (Length(aAppName) = 0)
     then exit;

  if not (fileExists(aCmdLine) or fileExists(aAppName))
     then begin
        //try to get rid og params in aCmdLine
        if Length(aCmdLine) > 0
           then begin
              S1 := aCmdLine;
              if S1[1] = '"'
                 then begin
                    S := SplitAtTokenStr(S1, '" ');
                    delete(S, 1, 1);//drop leading "
                 end
                 else S := SplitAtToken(S1, ' ');

              if not fileExists(S)
                 then exit;
           end
           else exit;
     end;

  {setup the startup information for the application }
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo
    do begin
      cb := SizeOf(TStartupInfo);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;

      if aHide
        then wShowWindow := SW_HIDE
      else wShowWindow := SW_SHOWNORMAL;
    end;
  //prevents delphi from locking the app but also from starting the app
  //dwCreationFlags := DEBUG_ONLY_THIS_PROCESS or NORMAL_PRIORITY_CLASS or CREATE_NEW_PROCESS_GROUP;
  //dwCreationFlags := NORMAL_PRIORITY_CLASS or CREATE_NEW_PROCESS_GROUP;
  //dwCreationFlags := CREATE_DEFAULT_ERROR_MODE + NORMAL_PRIORITY_CLASS;
  dwCreationFlags := CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS;
  //dwCreationFlags := NORMAL_PRIORITY_CLASS;
  try
     if aAppName = ''
        then Result := CreateProcess(nil,             PChar(aCmdLine), nil, nil, False, dwCreationFlags, nil, nil, StartupInfo, ProcessInfo)
        else Result := CreateProcess(PChar(aAppName), PChar(aCmdLine), nil, nil, False, dwCreationFlags, nil, nil, StartupInfo, ProcessInfo);

     if not result
        then exit;

     if aWait
        then begin
           dwI := WaitForInputIdle(ProcessInfo.hProcess, INFINITE);
           if dwI = $FFFFFFFF
              then GetExitCodeProcess(ProcessInfo.hProcess, dwI)
              else begin
                 if bWait
                    then while WaitForSingleObject(ProcessInfo.hProcess,100) = WAIT_TIMEOUT do
                       KSProcessMessages;
              end;
       end;
  finally
     CloseHandle(ProcessInfo.hProcess); //close handles or we get a mem-leak !
     CloseHandle(ProcessInfo.hThread);
  end;
end;
//------------------------------------------------------------------------------
{ date calculations }

type
  TDateOrder = (doMDY, doDMY, doYMD);

function CurrentYear: Word;
var
  SystemTime: TSystemTime;
begin
  //asm int 3 end; //KS trap
  GetLocalTime(SystemTime);
  Result := SystemTime.wYear;
end;
//------------------------------------------------------------------------------
function GetDateOrder(const DateFormat: string): TDateOrder;
var
  I: Integer;
begin 
  //asm int 3 end; //KS trap
  Result := doMDY;
  I := 1;
  while I <= Length(DateFormat) do
  begin
    case Chr(Ord(DateFormat[I]) and $DF) of
      'E': Result := doYMD;
      'Y': Result := doYMD;
      'M': Result := doMDY;
      'D': Result := doDMY;
    else
      Inc(I);
      Continue;
    end;
    Exit;
  end;
  Result := doMDY;
end;
//------------------------------------------------------------------------------
procedure ScanToNumber(const S: string; var Pos: Integer);
begin
  //asm int 3 end; //KS trap
  while (Pos <= Length(S)) and not (S[Pos] in ['0'..'9']) do
  begin
    if S[Pos] in LeadBytes then Inc(Pos);
    Inc(Pos);
  end;
end;
//------------------------------------------------------------------------------
function GetEraYearOffset(const Name: string): Integer;
var
  I: Integer;
begin
  //asm int 3 end; //KS trap
  Result := 0;
  for I := Low(EraNames) to High(EraNames) do
  begin
    if EraNames[I] = '' then Break;
    if AnsiStrPos(PChar(EraNames[I]), PChar(Name)) <> nil then
    begin
      Result := EraYearOffsets[I];
      Exit;
    end;
  end;
end;
//------------------------------------------------------------------------------
procedure ScanBlanks(const S: string; var Pos: Integer);
var
  I: Integer;
begin
  //asm int 3 end; //KS trap
  I := Pos;
  while (I <= Length(S)) and (S[I] = ' ') do Inc(I);
  Pos := I;
end;
//------------------------------------------------------------------------------
function ScanNumber(const S: string; var Pos: Integer;
  var Number: Word; var CharCount: Byte): Boolean;
var
  I: Integer;
  N: Word;
begin 
  //asm int 3 end; //KS trap
  Result := False;
  CharCount := 0;
  ScanBlanks(S, Pos);
  I := Pos;
  N := 0;
  while (I <= Length(S)) and (S[I] in ['0'..'9']) and (N < 1000) do
  begin
    N := N * 10 + (Ord(S[I]) - Ord('0'));
    Inc(I);
  end;
  if I > Pos then
  begin
    CharCount := I - Pos;
    Pos := I;
    Number := N;
    Result := True;
  end;
end;
//------------------------------------------------------------------------------
function ScanString(const S: string; var Pos: Integer;
  const Symbol: string): Boolean;
begin
  //asm int 3 end; //KS trap
  Result := False;
  if Symbol <> '' then
  begin
    ScanBlanks(S, Pos);
    if AnsiCompareText(Symbol, Copy(S, Pos, Length(Symbol))) = 0 then
    begin
      Inc(Pos, Length(Symbol));
      Result := True;
    end;
  end;
end;
//------------------------------------------------------------------------------
function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;
begin 
  //asm int 3 end; //KS trap
  Result := False;
  ScanBlanks(S, Pos);
  if (Pos <= Length(S)) and (S[Pos] = Ch) then
  begin
    Inc(Pos);
    Result := True;
  end;
end;
//------------------------------------------------------------------------------
function DoEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
var
  I: Integer;
  DayTable: PDayTable;
begin 
  //asm int 3 end; //KS trap
  Result := False;
  DayTable := @MonthDays[IsLeapYear(Year)];
  if (Year >= 1) and (Year <= 9999) and (Month >= 1) and (Month <= 12) and
    (Day >= 1) and (Day <= DayTable^[Month]) then
  begin
    for I := 1 to Month - 1 do Inc(Day, DayTable^[I]);
    I := Year - 1;
    Date := I * 365 + I div 4 - I div 100 + I div 400 + Day - DateDelta;
    Result := True;
  end;
end;
//------------------------------------------------------------------------------
function ScanDate(const S: string; var Pos: Integer;
  var Date: TDateTime): Boolean;
var
  DateOrder: TDateOrder;
  N1, N2, N3, Y, M, D: Word;
  L1, L2, L3, YearLen: Byte;
  EraName : string;
  EraYearOffset: Integer;
  CenturyBase: Integer;

  function EraToYear(Year: Integer): Integer;
  begin
    if SysLocale.PriLangID = LANG_KOREAN then
    begin
      if Year <= 99 then
        Inc(Year, (CurrentYear + Abs(EraYearOffset)) div 100 * 100);
      if EraYearOffset > 0 then
        EraYearOffset := -EraYearOffset;
    end
    else
      Dec(EraYearOffset);
    Result := Year + EraYearOffset;
  end;

begin  
  //asm int 3 end; //KS trap
  Y := 0;
  M := 0;
  D := 0;
  YearLen := 0;
  Result := False;
  DateOrder := GetDateOrder(ShortDateFormat);
  EraYearOffset := 0;
  if ShortDateFormat[1] = 'g' then  // skip over prefix text
  begin
    ScanToNumber(S, Pos);
    EraName := Trim(Copy(S, 1, Pos-1));
    EraYearOffset := GetEraYearOffset(EraName);
  end
  else
    if AnsiPos('e', ShortDateFormat) > 0 then
      EraYearOffset := EraYearOffsets[1];
  if not (ScanNumber(S, Pos, N1, L1) and ScanChar(S, Pos, DateSeparator) and
    ScanNumber(S, Pos, N2, L2)) then Exit;
  if ScanChar(S, Pos, DateSeparator) then
  begin
    if not ScanNumber(S, Pos, N3, L3) then Exit;
    case DateOrder of
      doMDY: begin Y := N3; YearLen := L3; M := N1; D := N2; end;
      doDMY: begin Y := N3; YearLen := L3; M := N2; D := N1; end;
      doYMD: begin Y := N1; YearLen := L1; M := N2; D := N3; end;
    end;
    if EraYearOffset > 0 then
      Y := EraToYear(Y)
    else if (YearLen <= 2) then
    begin
      CenturyBase := CurrentYear - TwoDigitYearCenturyWindow;
      Inc(Y, CenturyBase div 100 * 100);
      if (TwoDigitYearCenturyWindow > 0) and (Y < CenturyBase) then
        Inc(Y, 100);
    end;
  end else
  begin
    Y := CurrentYear;
    if DateOrder = doDMY then
    begin
      D := N1; M := N2;
    end else
    begin
      M := N1; D := N2;
    end;
  end;
  ScanChar(S, Pos, DateSeparator);
  ScanBlanks(S, Pos);
  if SysLocale.FarEast and (System.Pos('ddd', ShortDateFormat) <> 0) then
  begin     // ignore trailing text
    if ShortTimeFormat[1] in ['0'..'9'] then  // stop at time digit
      ScanToNumber(S, Pos)
    else  // stop at time prefix
      repeat
        while (Pos <= Length(S)) and (S[Pos] <> ' ') do Inc(Pos);
        ScanBlanks(S, Pos);
      until (Pos > Length(S)) or
        (AnsiCompareText(TimeAMString, Copy(S, Pos, Length(TimeAMString))) = 0) or
        (AnsiCompareText(TimePMString, Copy(S, Pos, Length(TimePMString))) = 0);
  end;
  Result := DoEncodeDate(Y, M, D, Date);
end;
//------------------------------------------------------------------------------
function DoEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;
begin  
  //asm int 3 end; //KS trap
  Result := False;
  if (Hour < 24) and (Min < 60) and (Sec < 60) and (MSec < 1000) then
  begin
    Time := (Hour * 3600000 + Min * 60000 + Sec * 1000 + MSec) / MSecsPerDay;
    Result := True;
  end;
end;
//------------------------------------------------------------------------------
function ScanTime(const S: string; var Pos: Integer;
  var Time: TDateTime): Boolean;
var
  BaseHour: Integer;
  Hour, Min, Sec, MSec: Word;
  Junk: Byte;
begin
  //asm int 3 end; //KS trap
  Result := False;
  BaseHour := -1;
  if ScanString(S, Pos, TimeAMString) or ScanString(S, Pos, 'AM') then
    BaseHour := 0
  else if ScanString(S, Pos, TimePMString) or ScanString(S, Pos, 'PM') then
    BaseHour := 12;
  if BaseHour >= 0 then ScanBlanks(S, Pos);
  if not ScanNumber(S, Pos, Hour, Junk) then Exit;
  Min := 0;
  if ScanChar(S, Pos, TimeSeparator) then
    if not ScanNumber(S, Pos, Min, Junk) then Exit;
  Sec := 0;
  if ScanChar(S, Pos, TimeSeparator) then
    if not ScanNumber(S, Pos, Sec, Junk) then Exit;
  MSec := 0;
  if ScanChar(S, Pos, DecimalSeparator) then
    if not ScanNumber(S, Pos, MSec, Junk) then Exit;
  if BaseHour < 0 then
    if ScanString(S, Pos, TimeAMString) or ScanString(S, Pos, 'AM') then
      BaseHour := 0
    else
      if ScanString(S, Pos, TimePMString) or ScanString(S, Pos, 'PM') then
        BaseHour := 12;
  if BaseHour >= 0 then
  begin
    if (Hour = 0) or (Hour > 12) then Exit;
    if Hour = 12 then Hour := 0;
    Inc(Hour, BaseHour);
  end;
  ScanBlanks(S, Pos);
  Result := DoEncodeTime(Hour, Min, Sec, MSec, Time);
end;
//------------------------------------------------------------------------------

Function DateStrToDateTime(aDate: string): TDateTime;
var
  OldDateSeparator: Char;
  OldShortDateFormat: string;
  Pos: Integer;
  //S: string;
begin
  //asm int 3 end; //KS trap
  OldDateSeparator := DateSeparator;
  OldShortDateFormat := ShortDateFormat;
  DateSeparator := '.';
  ShortDateFormat := 'dd.mm.yy';

  try
     Pos := 1;
     if not ScanDate(aDate, Pos, Result) or (Pos <= Length(aDate))
        then result := 0;
  finally
     DateSeparator := OldDateSeparator;
     ShortDateFormat := OldShortDateFormat;
  end;
end;

//------------------------------------------------------------------------------
Function TimeStrToDateTime(aDateTime: string): TDateTime;
var
  OldDateSeparator: Char;
  OldTimeSeparator: Char;
  OldShortDateFormat: string;
  Pos: Integer;
  Date, Time: TDateTime;
begin 
  //asm int 3 end; //KS trap
  OldDateSeparator := DateSeparator;
  OldShortDateFormat := ShortDateFormat;
  OldTimeSeparator := TimeSeparator;
  DateSeparator := '.';
  ShortDateFormat := 'dd.mm.yy';
  TimeSeparator := ':';
  Result := 0;

  try             
     try
        Pos := 1;
        Time := 0;
        if not ScanDate(aDateTime, Pos, Date) or
           not ((Pos > Length(aDateTime)) or
           ScanTime(aDateTime, Pos, Time))
           then begin   // Try time only
              Pos := 1;
              if not ScanTime(aDateTime, Pos, Result) or (Pos <= Length(aDateTime))
                 then result := 0;
           end
           else begin
              if Date >= 0
                 then Result := Date + Time
                 else Result := Date - Time;
           end;
     except
        Result := 0;
     end;
  finally
     DateSeparator := OldDateSeparator;
     ShortDateFormat := OldShortDateFormat;
     TimeSeparator := OldTimeSeparator;
  end;
end;
//------------------------------------------------------------------------------
function DirExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  //asm int 3 end; //trap
  {$RANGECHECKS OFF}
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;
//------------------------------------------------------------------------------
function KSGetTempPath: string;
//Returns the path of the directory designated for temporary files
var
  Buffer: array[0..1023] of Char;
begin
  //asm int 3 end; //trap
  SetString(Result, Buffer, GetTempPath(Sizeof(Buffer) - 1, Buffer));
  //Fixes a bug in Windows 2000
  //Strg.MakeLongName(result);
  //problems
  (*
  if (result = '') or (not DirExists(result))
     then begin
        result := GetWinDir + '\TEMP\';
        MkDir(result);
     end;
  *)
end;
//------------------------------------------------------------------------------
procedure WinExecError(iErr: Word; const sCmdLine: string);
//Returns a dialogbox with the explanation of an WinExecError
var
  S: string;
begin
  //asm int 3 end; //KS trap
  case iErr of
    (* nye ting og sager fra win32
    SE_ERR_ACCESSDENIED	Windows 95 only: The operating system denied access to the specified file.
    SE_ERR_ASSOCINCOMPLETE	The filename association is incomplete or invalid.
    SE_ERR_DDEBUSY	The DDE transaction could not be completed because other DDE transactions were being processed.
    SE_ERR_DDEFAIL	The DDE transaction failed.
    SE_ERR_DDETIMEOUT	The DDE transaction could not be completed because the request timed out.
    SE_ERR_DLLNOTFOUND	Windows 95 only: The specified dynamic-link library was not found.
    SE_ERR_FNF	Windows 95 only: The specified file was not found.
    SE_ERR_NOASSOC	There is no application associated with the given filename extension.
    SE_ERR_OOM	Windows 95 only: There was not enough memory to complete the operation.
    SE_ERR_PNF	Windows 95 only: The specified path was not found.
    SE_ERR_SHARE	A sharing violation occurred.
    *)

     0:
        S := 'The operating system is out of memory or resources,'+CrLf+
             'the executable file was corrupt, or'+CrLf+
             'relocations were invalid';
     ERROR_FILE_NOT_FOUND:
        S := 'The specified file was not found' + CrLf + sCmdLine;
     ERROR_PATH_NOT_FOUND:
        S := 'The specified path was not found' + CrLf + sCmdLine;
     //ERROR_TOO_MANY_OPEN_FILES:
     5:
        S := 'Attempt was made to dynamically link to a task, or there'
             + ' was a sharing or network-protection error.';
     6:
        S := 'Library required separate data segments for each task.';
     8:
        S := 'There was insufficient memory to start the application.';
     10:
        S := 'Windows version was incorrect.';
     ERROR_BAD_FORMAT:
        S := 'The .EXE file is invalid (non-Win32 .EXE or error in .EXE image)';
     12:
        S := 'Application was designed for a different operating system.';
     13:
        S := 'Application was designed for MS-DOS 4.0.';
     14:
        S := 'Type of executable file was unknown.';
     15:
        S := 'Attempt was made to load a real-mode application'
             + ' (developed for an earlier version of Windows).';
     16:
        S := 'Attempt was made to load a second instance of an'
             + ' executable file containing multiple data segments'
             + ' that were not marked read-only.';
     19:
        S := 'Attempt was made to load a compressed executable file.'
             + ' The file must be decompressed before it can be loaded.';
     20:
        S := 'Dynamic-link library (DLL) file was invalid.  One of the'
             + ' DLLs required to run this application was corrupt.';
     21:
        S := 'Application requires 32-bit extensions.';
  end;

  KSMessageE(S, 'Win Exe Error');
end;
//------------------------------------------------------------------------------
procedure PrintWordDoc(const fil: string; handle: HWND);
var
  Hwnd: Thandle;
begin
  //asm int 3 end; //KS trap
  Hwnd := GetWindowFromText('Microsoft Word');
  // Hvis word er aktiv så minimer > så kan der printes i baggrunden
  if hwnd > 0
    then ShowWindow(hwnd, SW_HIDE); //hvis word ikke er aktiv må vi finde os i forgrunds-print

  Hwnd := ShellExecute(handle, 'Print', Pchar(Fil), nil, nil, SW_HIDE);
  if Hwnd < 32
    then WinExecError(Hwnd, ExtractFileName(fil)); {vis fejlen}

end;
//------------------------------------------------------------------------------
Function GetFileAsText(const afile: String): String;
var
  iFileHandle: Integer;
  iFileLength: Integer;
begin
  //asm int 3 end; //trap
  result := '';
  if FileExists(afile)
     then begin
        iFileHandle := FileOpen(afile, fmOpenRead);
        try
           iFileLength := FileSeek(iFileHandle, 0, 2);
           FileSeek(iFileHandle, 0, 0);
           SetLength(Result, iFileLength);
           FileRead(iFileHandle, Result[1], iFileLength);
          finally
            FileClose(iFileHandle);
          end;

          if length(Trim(Result)) > 500
              then DeveloperMessage('Reading file: ' +afile+ DblCrLf + Trim(Copy(Result, 1, 500) + DblCrLf +'{ Snip }'))
              else DeveloperMessage('Reading file: ' +afile+ DblCrLf + Trim(Result));
     end
     else DeveloperMessage('Failed to read file: ' +afile);
end;
//------------------------------------------------------------------------------
function SaveTextAsFile(const afile, Text: String): Boolean;
var
  //F: TextFile;
  aHandle: THandle;
  dwRead: DWORD;
begin 
  //asm int 3 end; //KS trap
  result := false;

  aHandle := CreateFile(Pchar(afile), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, 0,0);

  if aHandle = INVALID_HANDLE_VALUE
     then begin
        KSMessageE('Failed to create file: '+CrLf+afile);
        exit;
     end;
  try
     result := WriteFile(aHandle, PChar(Text)^, Length(Text), dwRead, nil);
     if not result
        then begin
           KSMessageE('Failed to write to file: '+CrLf+afile);
           exit;
        end;
  finally
     if not CloseHandle(aHandle)
        then KSMessageE('Failed to close file handle: '+CrLf+afile);
  end;

(*
  AssignFile(F, afile);
  try
     Rewrite(F);
     Write(F, Text);
  finally
     CloseFile(F);
  end;
  *)
end;
//------------------------------------------------------------------------------
function GetUserCookie: string;
begin 
  //asm int 3 end; //KS trap
  Result := Trim(GetFileAsText(GetWinDir + 'KSUserCookie'));
end;
//------------------------------------------------------------------------------
var
  NetUserName: string = '';

//------------------------------------------------------------------------------
function KSGetNetUserName(const aResource: string = '?'): string;
begin
  //asm int 3 end; //trap
  if Length(NetUserName) = 0  //not initialized
     then GetNetUserName(aResource);

  Result := NetUserName;
end;
//------------------------------------------------------------------------------
function KSGetUserName(Uppercase: boolean = true): string;
var
  pcUser: PChar;
  dwUSize: Cardinal;

  //-----------------------------------------------
  function GetCaseUserName: string;
  begin
     if Uppercase
        then Result := AnsiUpperCase(NetUserName)
        else result := NetUserName;

     //if Pos('\', result) > 0     //a win 95 returns NetUserName without "domain\"
        //then SplitAtToken(result, '\');
  end;
  //-----------------------------------------------
begin 
  //asm int 3 end; //KS trap
  if Length(NetUserName) > 0  //already initialized
     then begin
        result := GetCaseUserName;
        exit;
     end;

  //first try NetUser
  NetUserName := GetNetUserName('?');   //this returns Domaine\user for users
  if length(NetUserName) > 0            //from a forign domaine
     then begin
        result := GetCaseUserName;
        exit;
     end;

  //then try PC-user
  dwUSize := 21;              // user name can be up to 20 characters
  GetMem(pcUser, dwUSize);
  try
     if GetUserName(pcUser, dwUSize)
        then begin
           NetUserName := Trim(pcUser);
           if length(NetUserName) > 0
              then begin
                 result := GetCaseUserName;
                 exit;
              end;
        end;
  finally
    FreeMem(pcUser);
  end;

  //we only come heir if NetUser and PC-user is not getting any result
  //get User from "Cookie"
  NetUserName := GetUserCookie;

  if Length(NetUserName) > 0
     then Result := GetCaseUserName
     else KSMessageE('This computer dos''ent return any'+ CrLf +
                     'NetUser- or PC-user name.'+ DblCrLf +
                     'You must put a user name in:'+ CrLf +
                     GetWinDir+'KSUserCookie');
end;
//------------------------------------------------------------------------------
Function GetFirstNetworkDrive: string;
var
  dtDrive: TDriveType;
  AllDrives: string;
  I: Integer;
begin
  //asm int 3 end; //trap
  Result := '';

  AllDrives := KSGetLogicalDrives;

  for I := 1 to Length(AllDrives) do
     begin
        dtDrive := TDriveType(GetDriveType(PChar(AllDrives[i]+':\')));

        if dtDrive = dtNetwork  // it's a connected network drive
           then begin
               Result := AllDrives[i]+':';
               break;
           end;
     end;
end;
//------------------------------------------------------------------------------
function GetNetUserName(const aResource: string = ''): string;
// aResource = drive to get Log In Name from - if blank we use the first net-drive
var
  pcUser: PChar;
  dwUSize: Cardinal;
  _aResource: String;
begin 
  //asm int 3 end; //trap
  if ((length(aResource) = 0) or (aResource = '?'))and
     (length(NetUserName) > 0)    //no need to call net more than once
     then begin
        result := NetUserName;
        exit;
     end;


  Result := '';
  dwUSize := 21;              // user name can be up to 20 characters
  GetMem(pcUser, dwUSize);    // allocate memory for the string
  try
     if aResource = '?'
        then _aResource := GetFirstNetworkDrive
        else _aResource := aResource;

     if NO_ERROR = WNetGetUser(Pchar(_aResource), pcUser, dwUSize)
        then begin
           Result := Trim(pcUser);

           if (aResource = '?')  //if no drive letter used then save default NetUserName
              then begin
                 NetUserName := Result;

                 //at siemens the network-user is returned like this SIEDK\KS
                 //if (Pos('\', Result) > 0)
                    //then Result := afterLastToken(Result, '\');
              end;
        end;
  finally
    FreeMem(pcUser);
  end;
end;
//------------------------------------------------------------------------------
function GetWinDir: string;
//Returns the windows directory
var
  pcWindowsDirectory: PChar;
  dwWDSize: Cardinal;
begin
  //asm int 3 end; //trap
  if length(ActualWinDir)= 0
     then begin
        dwWDSize := MAX_PATH + 1;
        GetMem(pcWindowsDirectory, dwWDSize); // allocate memory for the string
        try
          if Windows.GetWindowsDirectory(pcWindowsDirectory, dwWDSize) <> 0
            then ActualWinDir := strEndSlash(pcWindowsDirectory);
        finally
          FreeMem(pcWindowsDirectory); // now free the memory allocated for the string
        end;
     end;

  result := ActualWinDir;
end;
//------------------------------------------------------------------------------
function KSGetSystemDirectory: string;
//Returns system directory
var
  pcSystemDirectory: PChar;
  dwSDSize: Cardinal;
begin
  //asm int 3 end; //KS trap
  dwSDSize := MAX_PATH + 1;
  GetMem(pcSystemDirectory, dwSDSize); // allocate memory for the string
  try
    if Windows.GetSystemDirectory(pcSystemDirectory, dwSDSize) <> 0
      then Result := strEndSlash(pcSystemDirectory);
  finally
    FreeMem(pcSystemDirectory); // now free the memory allocated for the string
  end;
end;
//------------------------------------------------------------------------------
function KSGetSystemTime: string;
//returns date and time
var
  stSystemTime: TSystemTime;
begin
  //asm int 3 end; //trap
  Windows.GetSystemTime(stSystemTime);
  Result := DateTimeToStr(SystemTimeToDateTime(stSystemTime));
end;
//------------------------------------------------------------------------------
function KSFileGetDateTime(const aFile: string): TDateTime;
begin 
  //asm int 3 end; //KS trap
  Result := FileDateToDateTime(FileAge(aFile));
end;
//------------------------------------------------------------------------------
function KSCompareFileTime(const FileNameOne, FileNameTwo: string; ComparisonType:
  TTimeOfWhat): TFileTimeComparision;
//Compares two files timestamps
// NB der er vistnok vrøvl med alt andet end ftLastWriteTime
var
  FileOneFileTime: TFileTime;
  FileTwoFileTime: TFileTime;
begin
  //asm int 3 end; //trap
  Result := ftError;

  if FileExists(FileNameOne) and FileExists(FileNameTwo)
     then begin
        FileOneFileTime := KSGetFileTime(FileNameOne, ComparisonType);
        FileTwoFileTime := KSGetFileTime(FileNameTwo, ComparisonType);

        case Windows.CompareFileTime(FileOneFileTime, FileTwoFileTime) of
          - 1: Result := ftFileOneIsOlder;
          0: Result := ftFileTimesAreEqual;
          1: Result := ftFileTwoIsOlder;
        end;
     end
     else Result := ftError;
end;
//------------------------------------------------------------------------------
function GetFileTimeEx(const FileName: string; ComparisonType: TTimeOfWhat): TDateTime;
// Returns the date and time that a file was created, last accessed, or last modified as TDateTime
// NB der er vistnok vrøvl med alt andet end ftLastWriteTime
var
  SystemTime: TSystemTime;
  FileTime: TFileTime;
begin  
  //asm int 3 end; //KS trap
  Result := StrToDate('31' + DateSeparator + '12' + DateSeparator + '9999');

  FileTime := KSGetFileTime(FileName, ComparisonType);
  if FileTimeToSystemTime(FileTime, SystemTime)
    then Result := SystemTimeToDateTime(SystemTime); // Convert to TDateTime and return

end;
//------------------------------------------------------------------------------
function GetLogicalPathFromUNC(var aUNC :string): Boolean;
var
  S,S1: string;
  I: Integer;
  UNC: string;
begin
  //asm int 3 end; //KS trap
  Result := False;

  UNC := Lowercase(aUNC);

  S := KSGetLogicalDrives;

  for I := 1 to Length(S) do
     begin
        S1 := Lowercase(ExpandUNCFileName(S[i]+':\'));
        if pos(s1, UNC) = 1
           then begin
              Delete(aUNC, 1, Length(S1)-1);
              Insert(S[i]+':', aUNC, 1);
              result := True;
              break;
           end;
     end;
end;
//------------------------------------------------------------------------------
function KSGetFileTime(const FileName: string; ComparisonType: TTimeOfWhat): TFileTime;
// Returns the date and time that a file was created, last accessed, or last modified
// NB der er vistnok vrøvl med alt andet end ftLastWriteTime
var
  FileTime, LocalFileTime: TFileTime;
  hFile: THandle;
  //AFileName: string;
begin 
  //asm int 3 end; //trap
  // initialize TFileTime record in case of error
  Result.dwLowDateTime := 0;
  Result.dwHighDateTime := 0;

  hFile := FileOpen(FileName, fmOpenRead{fmShareDenyNone});
  try
    if hFile <> 0
      then begin
        case ComparisonType of
          ftCreationTime: Windows.GetFileTime(hFile, @FileTime, nil, nil);
          ftLastAccessTime: Windows.GetFileTime(hFile, nil, @FileTime, nil);
          ftLastWriteTime: Windows.GetFileTime(hFile, nil, nil, @FileTime);
        end;                  // case FileTimeOf

        // Change the file time to local time
        FileTimeToLocalFileTime(FileTime, LocalFileTime);
        Result := LocalFileTime;
      end;                    // if hFile <> 0
  finally
    FileClose(hFile);
  end;                        // try
end;
//------------------------------------------------------------------------------
Function GetFreeDiskSize(TheDrive: String):Int64;
//NB husk C:\
var
  TheSize : int64;
begin
  //asm int 3 end; //KS trap
  GetDiskFreeSpaceEx(Pchar(TheDrive), Result, TheSize, nil);
end;
//------------------------------------------------------------------------------
function KSGetCurrentDirectory: string;
//Returns the current directory for the current process
var
  nBufferLength: Cardinal;       // size, in characters, of directory buffer
  lpBuffer: PChar;            // address of buffer for current directory
begin
  //asm int 3 end; //KS trap
  GetMem(lpBuffer, MAX_PATH + 1);
  nBufferLength := 100;
  try
    if Windows.GetCurrentDirectory(nBufferLength, lpBuffer) > 0
      then Result := strEndSlash(lpBuffer);
  finally
    FreeMem(lpBuffer);
  end;                        // try
end;
//------------------------------------------------------------------------------
function FileSizeEx(const FileName: string): LongInt;
//returns the size of a file in bytes
var
 (*
  hFile: THandle;             // handle of file to get size of
  lpFileSizeHigh: Cardinal;      // address of high-order word for file size

  f: file of Byte;
  fileSize: Integer;
  *)
  //ret: Integer;
  sResult: TSearchRec;
begin
  //asm int 3 end; //KS trap
  if 0 = SysUtils.FindFirst(filename, faAnyFile, sResult)
     then result := sResult.Size
     else result := -1;

  SysUtils.FindClose(sResult);

 (*
  Result := -1;
  hFile := FileOpen(FileName, fmOpenRead);
  try
    if hFile <> 0
      then begin
        Result := Windows.GetFileSize(hFile, @lpFileSizeHigh);
        //if result = -1
           //then KSMessageE(GetLastErrorStr);

      end;
  finally
    FileClose(hFile);
  end;
 *)
end;
//------------------------------------------------------------------------------
function ShortFileNameToLFN(ShortName: String):String;
var
  temp: TWIN32FindData;
  searchHandle: THandle;
begin
  //asm int 3 end; //KS trap
  searchHandle := FindFirstFile(PChar(ShortName), temp);

  if searchHandle <> ERROR_INVALID_HANDLE
     then result := String(temp.cFileName)
     else result := '';

  Windows.FindClose(searchHandle);
end;
//------------------------------------------------------------------------------
function GetFullPathNameEx(const Path: string): string;
//Returns the full path and filename of a specified file
var
  nBufferLength: Cardinal;       // size, in characters, of path buffer
  lpBuffer: PChar;            // address of path buffer
  lpFilePart: PChar;          // address of filename in path
begin
  //asm int 3 end; //KS trap
  Result := '';
  nBufferLength := MAX_PATH + 1;
  GetMem(lpBuffer, MAX_PATH + 1);
  GetMem(lpFilePart, MAX_PATH + 1);
  try
    if Windows.GetFullPathName(PChar(Path), nBufferLength, lpBuffer, lpFilePart) <> 0
      then Result := lpBuffer;
  finally
    FreeMem(lpBuffer);
    FreeMem(lpFilePart);
  end;
end;
//------------------------------------------------------------------------------
function GetFirstAviableDriveLetter: string;
//Returns the first available disk drives letter
var
  S: string;
  I: Integer;
begin 
  //asm int 3 end; //KS trap
  Result := '';
  S := UpperCase(KSGetLogicalDrives); //this is used letters

  while (Length(S) > 0) and (S[1] in ['A'..'C']) do
     Delete(S, 1, 1); //skip A, B and C

  for I := 1 to Length(S) do   
     if (Ord(S[I]) - 67) <> I  //first posible char = D ~ 68
        then begin
           Result := Succ(S[I -1]); //first letter after last letter "in sync"
           break;
        end;
end;
//------------------------------------------------------------------------------
function KSGetLogicalDrives: string;
//Returns a string that contains the currently available disk drives
var
  drives: set of 0..25;
  drive: integer;
begin 
  //asm int 3 end; //trap
  Result := '';
  Cardinal(drives) := Windows.GetLogicalDrives;
  for drive := 0 to 25
    do
    if drive in drives
      then Result := Result + Chr(drive + Ord('A'));
end;
//------------------------------------------------------------------------------
function KSDelete(var S: String; DeleteString: String; All: Boolean = False): boolean;
var
  I: Integer;
begin 
  //asm int 3 end; //trap
  i := Pos(DeleteString, S);
  if I > 0
     then begin
        delete(S, i, length(DeleteString));
        Result := True;
     end
     else Result := False;

  if all and result  //se if there is more to delete
     then begin
        i := Pos(DeleteString, S);
        while I > 0 do
           begin
              delete(S, i, length(DeleteString));
              i := Pos(DeleteString, S);
           end;
     end;
end;
//------------------------------------------------------------------------------
function squish(const Search: string): string;
{squish() returns a string with all whitespace not inside single
quotes deleted.}
var
  Index: byte;
  InString: boolean;
begin
  //asm int 3 end; //trap
  InString := False;
  Result := '';
  for Index := 1 to Length(Search)
    do begin
      if InString or (Search[Index] in BlackSpace)
        then AppendStr(Result, Search[Index]);
      InString := ((Search[Index] = '''') and (Search[Index - 1] <> '\')) xor InString;
    end;
end;
//------------------------------------------------------------------------------
function before(const Search, Find: string): string;
{before() returns everything before the first occurance of Find
in Search. If Find does not occur in Search, Search is returned.}
var
  index: byte;
begin
  //asm int 3 end; //trap
  index := Pos(Find, Search);
  if index = 0
    then Result := Search
  else Result := Copy(Search, 1, index - 1);
end;
//------------------------------------------------------------------------------
function beforeX(const Search, Find: string): string;
{before() returns everything before the first occurance of Find
in Search. If Find does not occur in Search, An empty string is returned.}
var
  index: byte;
begin
  //asm int 3 end; //trap
  index := Pos(Find, Search);
  if index = 0
    then Result := ''
  else Result := Copy(Search, 1, index - 1);
end;
//------------------------------------------------------------------------------
function after(const Search, Find: string): string;
{after() returns everything after the first occurance of Find
in Search. If Find does not occur in Search, a null string is returned.}
var
  index: byte;
begin 
  //asm int 3 end; //trap
  index := Pos(Find, Search);
  if index = 0
    then Result := ''
  else Result := Copy(Search, index + Length(Find), Length(Search));
end;
//------------------------------------------------------------------------------
function LastChar(const Search: string; const Find: char): Integer;
begin 
  //asm int 3 end; //KS trap
  Result := Length(Search);

  while (Result > 0) and (Search[Result] <> Find) do
     Dec(Result);
end;
//------------------------------------------------------------------------------
function RPos(const Find, Search: string): Integer;
{RPos() returns the index of the first character of the last occurance
of Find in Search. Returns 0 if Find does not occur in Search.
Like Pos() but searches in reverse.}
var
 Quit    : Boolean;
 Pos,Len : Integer;
begin
  //asm int 3 end; //trap
   result := 0;
   Len := Length(Find);
   if (Len = 0) or (length(Search) = 0)  
     then exit;

   Quit:= False;
   
   Pos := Length(Search)+ 1 - Len;
   while not Quit do
     begin
        if (Search[pos] = Find[1]) and //speed it up
           (Copy(Search,Pos,Len) = Find)
           then begin
              result := Pos;
              Quit:= True;
           end;

        if Pos = 1     //not found
           then Quit:= True;

        Dec(Pos,1);
   end;

end;
//------------------------------------------------------------------------------
function AfterLastToken(const StrInd, Token: string): string;
//Returns the right part of StrInd that comes after Token
begin
  //asm int 3 end; //trap
  result := copy(StrInd, RPos(Token, StrInd) + 1, length(StrInd));
end;
//------------------------------------------------------------------------------
function KSSameText(S1, S2: string; MaxLen: Cardinal): boolean;
begin
  Result := 2 = CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE,
                              PChar(S1), MaxLen, PChar(S2), MaxLen);
end;
//------------------------------------------------------------------------------
function BeforLastToken(const StrIn, Token: string): string;
//Returns the left part of StrInd that comes before last Token
//if no token found then StrInd is returned
var
  I: Integer;
begin  
  //asm int 3 end; //trap
  i := Rpos(Token, StrIn);//LastDelimiter(Token, StrIn);
  if I = 0
     then result := StrIn
     else result := copy(StrIn, 1, I-1);
end;
//------------------------------------------------------------------------------
type
  TFindHwndRec = record
    FoundWnd: HWND;
    WindowTekst: array[0..50] of Char;
    LenWindowTekst: Word;
  end;

  PFindHwndRec = ^TFindHwndRec;
//------------------------------------------------------------------------------
function EnumWindowsProc(WndBeingChecked: HWND; rec: PFindHwndRec): Bool; export; stdcall;
{callback funktionen som window kalder tilbage til efter EnumWindows}
var
  p: array[0..100] of Char;
begin
  //asm int 3 end; //KS trap
  Result := True;

  if (GetWindowText(WndBeingChecked, p, 99) >= rec^.LenWindowTekst)
    and (pos(rec^.WindowTekst, p) > 0)
    then begin                //(strCompLeft(rec^.WindowTekst, p)
      rec^.FoundWnd := WndBeingChecked;
      Result := False;
    end;                      {afbryd, windows-handle er nu fundet}

end;
//------------------------------------------------------------------------------
function GetWindowFromText(const WindowText: string): Hwnd;
{returnere en handle til vinduet hvis WindowText findes i caption}
var
  rec: TFindHwndRec;
begin
  //asm int 3 end; //KS trap
  {gem søgestrengen så callback-funktionen kan læse den}
  StrPcopy(rec.WindowTekst, WindowText);
  rec.LenWindowTekst := word(Length(WindowText));
  if rec.LenWindowTekst > 48
    then KSMessageE('It is maximum posible to search for 49 characters [function GetWindowFromText])');
  rec.FoundWnd := 0;          {rturværdi hvis window ikke findes}

  EnumWindows(@EnumWindowsProc, Longint(@rec));

  Result := rec.FoundWnd
end;
//------------------------------------------------------------------------------
function DropLastDir(path: string): string;
//fjerner sidste directory fra stien i path
begin
  //asm int 3 end; //KS trap
  if path[Length(path)] = '\'
    then Delete(path, Length(path), 1);

  Result := Copy(path, 1, RPos('\', path));
end;
//------------------------------------------------------------------------------
function CtrlDown: Boolean;
var
  State: TKeyboardState;
begin
  //asm int 3 end; //KS trap
  GetKeyboardState(State);
  Result := ((State[vk_Control] and 128) <> 0);
end;
//------------------------------------------------------------------------------
function FileDifferent(const Sourcefile: string; TargetPath: string): Boolean;
var
  TargetFil: string;
begin
  //asm int 3 end; //KS trap
  Result := True;

  if not Fileexists(Sourcefile)
    then exit;

  TargetPath := strEndSlash(TargetPath);
  TargetFil := TargetPath + ExtractFileName(Sourcefile);

  if not Fileexists(TargetFil)
    then exit;

  if ftFileTimesAreEqual <> KSCompareFileTime(TargetFil, Sourcefile, ftLastWriteTime)
    then exit;

  //hvis de er ens skifter Result til False og funktionen returnere med false
  Result := fileSizeEx(Sourcefile) <> fileSizeEx(TargetFil);
end;
//------------------------------------------------------------------------------
function GetErrorString(var aFmtStr: String; ErrorCode: Integer): boolean;
var
  Buf: array [Byte] of Char;
begin
  //asm int 3 end; //KS trap
  Result := (0 = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, ErrorCode,
                             LOCALE_USER_DEFAULT, Buf, sizeof(Buf), nil));
  if result
     then aFmtStr := 'Call to FormatMessage failed in:'+CrLf+'function GetErrorString'
     else aFmtStr := Buf;

end;
//------------------------------------------------------------------------------
function GetSystemErrorMessage(var aFmtStr: String; ErrorAccept: Integer = ERROR_SUCCESS): boolean;
//returns true if an error is found
var
  ErrorCode: Integer;
begin
  //asm int 3 end; //KS trap
  aFmtStr := '';
  ErrorCode := GetLastError;
  result := (ErrorCode <> ERROR_SUCCESS) and (ErrorCode <> ErrorAccept);

  if result
     then GetErrorString(aFmtStr, ErrorCode);
end;
//------------------------------------------------------------------------------
function GetLastErrorStr: string;
var
  S: string;
begin 
  //asm int 3 end; //KS trap
  GetSystemErrorMessage(S);
  result := S;
end;
//------------------------------------------------------------------------------
function ShowLastErrorIfAny(anError: Integer; Handle: Hwnd = 0): Boolean;
begin 
  //asm int 3 end; //KS trap
  Result := True;
  if anError > 32
     then exit
     else Result := False;

  KSMessageE(GetLastErrorStr);
end;
//------------------------------------------------------------------------------
function KSSetCurrentDir(const Dir: string): Boolean;
begin
  //asm int 3 end; //trap
  result := DirExists(Dir);
  if result
     then Result := SetCurrentDirectory(PChar(Dir));
end;
//------------------------------------------------------------------------------
function DelDir(aDir: string): boolean;
//Remove a directory including all content
var
  SHFileOpStruct: TSHFileOpStruct;
begin
  fillchar(SHFileOpStruct, sizeof(TSHFileOpStruct), 0);
  with SHFileOpStruct do
     begin
        Wnd := 0; {form1.handle}
        wFunc := FO_DELETE;
        pFrom := pchar(NoEndBackSlash(aDir) + #0#0);
        pTo := nil;
        fFlags := FOF_NOCONFIRMATION or FOF_SILENT;
        lpszProgressTitle := nil; {'Deleting '+path;}
     end;

  result := SHFileOperation(SHFileOpStruct) = 0;
end;
//------------------------------------------------------------------------------
function KSEmptyDir(aDir: string): Boolean;
//Clears all files and subdirectories from directory
var
  SearchRec : TSearchRec;
begin
  //asm int 3 end; //trap

  result := (0 = findfirst(aDir + '\*.*', faAnyFile, SearchRec)); {first always '.' }

  While (findnext(SearchRec) = 0) Do
     if not(SearchRec.Name = '..')                 {skip '..' to}
        then begin
           if (SearchRec.Attr and faDirectory) > 0
              then result := result and DelDir(aDir + '\' + Searchrec.name)
              else result := result and Deletefile(aDir + '\' + SearchRec.name);
        end;

  FindClose(SearchRec);
end;
//------------------------------------------------------------------------------
function KSForceDirectories(Dir: string): Boolean;
begin
  //asm int 3 end; //trap
  if Length(Dir) = 0
     then begin
        KSMessageE('Cant create directory');
        Result := False;
     end
     else begin
        Result := True;

        Dir := ExcludeTrailingBackslash(Dir);
        if (Length(Dir) < 3) or DirExists(Dir) or (ExtractFilePath(Dir) = Dir)
           then Exit; // avoid 'xyz:\' problem.

        Result := KSForceDirectories(ExtractFilePath(Dir)) and CreateDir(Dir);
     end;
end;
//------------------------------------------------------------------------------
function GetShareFromURN(const URN: string; var Share: string; aPath: string = ''): boolean;
begin
  //asm int 3 end; //KS trap
    if pos('\\', URN) = 1
     then begin { \\bupb0f4a\program\.....  }
        result := true;
        Share := BeforeTokenNr(URN, '\', 4) + '\'+ aPath;
     end
     else result := False;
end;
//------------------------------------------------------------------------------
function GetFileDateAsString(aFile: string): String;
begin
  //asm int 3 end; //KS trap
  result := IntToStr(FileAge(aFile))
end;
//------------------------------------------------------------------------------
function GetUTCFileDateAsString(aFile: string): String;
begin
  //asm int 3 end; //KS trap
  result := IntToStr(UTCFileAge(aFile))
end;
//------------------------------------------------------------------------------
function UTCFileAge(const FileName: string): Integer;
//get UTC-based file time (no conversion to local time)
var
  Handle: THandle;
  FindData: TWin32FindData;
  //LocalFileTime: TFileTime;
  //S, S1: String;
begin
    //asm int 3 end; //KS trap

  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE
     then begin
        Windows.FindClose(Handle);
        if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0
           then begin
             (*
              FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
              FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi, LongRec(Result).Lo);
              S := DateTimeToStr(FileDateToDateTime(Result));  //local time
              //exit;

              FileTimeToDosDateTime(FindData.ftLastWriteTime, LongRec(Result).Hi, LongRec(Result).Lo);
              S1 := DateTimeToStr(FileDateToDateTime(Result));  //UTC time
              *)
              if FileTimeToDosDateTime(FindData.ftLastWriteTime, LongRec(Result).Hi, LongRec(Result).Lo)
                 then Exit;
           end;
     end;

  Result := -1;
end;
//------------------------------------------------------------------------------
function DosLocalTimeToDosUTCTime(aDosFileTime: Integer): Integer;
var
  aFileTime: TFileTime;
  aLocalFileTime: TFileTime;
begin
  //asm int 3 end; //KS trap

  //convert to UTC time
  //S := DateTimeToStr(FileDateToDateTime(aDosFileTime));
  DosDateTimeToFileTime(LongRec(aDosFileTime).Hi, LongRec(aDosFileTime).Lo, aLocalFileTime);
  LocalFileTimeToFileTime(aLocalFileTime, aFileTime);
  FileTimeToDosDateTime(aFileTime, LongRec(result).Hi, LongRec(result).Lo);
  //S := DateTimeToStr(FileDateToDateTime(result));

  //result is now UTC filetime

end;
//------------------------------------------------------------------------------
Function GetShortDateTime(aTime: TDateTime; Seconds: boolean = false): String;
var
  OldShortDateFormat: string;
begin
  //asm int 3 end; //KS trap

  OldShortDateFormat := ShortDateFormat;
  ShortDateFormat := 'dd.mm.yy';
  try
     result := DateTimeToStr(aTime);
     if not Seconds
        then result := BeforLastToken(result, TimeSeparator); //drop seconds
  finally
     ShortDateFormat := OldShortDateFormat;
  end;
end;
//------------------------------------------------------------------------------
Function GetFileDateTime(aFile: string): String;
//var
  //OldShortDateFormat: string;
begin
  //asm int 3 end; //KS trap
  if Not FileExists(aFile)
     then result := 'Error'
     else result := GetShortDateTime(FileDateToDateTime(FileAge(aFile)));
end;
//------------------------------------------------------------------------------
Function GetModuleName(aFile: string = ''): String;
var
  ModuleName: array[0..255] of Char;
begin
  //asm int 3 end; //trap
  if length(aFile) = 0
     then GetModuleFileName(GetModuleHandle(Nil), ModuleName, SizeOf(ModuleName))
     else GetModuleFileName(GetModuleHandle(Pchar(aFile)), ModuleName, SizeOf(ModuleName));
  result := ModuleName;
end;
//------------------------------------------------------------------------------
function GetBoxHead(aBoxHead, aDefault: string): string;
begin
  //asm int 3 end; //trap
  if length(ActualAppName) = 0 //only set default one time
     then ActualAppName := LowerCase(ExtractFileName(GetModuleName));

  if length(aBoxHead) = 0
     then result := ActualAppName + ': ' + aDefault
     else result := ActualAppName + ': ' + aBoxHead;
end;
//------------------------------------------------------------------------------
function KSMessage(aMessage: string; aBoxHead: string; Params: integer): integer;
begin 
  //asm int 3 end; //trap
result := MessageBox(0, Pchar(aMessage), Pchar(aBoxHead), Params or
                       MB_TASKMODAL or MB_TOPMOST or MB_SETFOREGROUND);

  { posible button flags:
    MB_ABORTRETRYIGNORE, MB_OK, MB_OKCANCEL, MB_RETRYCANCEL, MB_YESNO, MB_YESNOCANCEL
    MB_DEFBUTTON2, MB_DEFBUTTON3, MB_DEFBUTTON4 - MB_DEFBUTTON1 is default

    MB_ICONWARNING, MB_ICONINFORMATION, MB_ICONQUESTION, MB_ICONERROR.

    posible resulte:
    IDABORT, IDCANCEL, IDIGNORE, IDNO, IDOK, IDRETRY, IDYES }
end;

//------------------------------------------------------------------------------
function KSQuestion(aMessage: string; aBoxHead: string = ''; Params: integer = MB_ICONQUESTION or MB_YESNO): integer;
begin 
  //asm int 3 end; //trap
  result := KSMessage(aMessage, GetBoxHead(aBoxHead, 'Question'), Params);
end;
//------------------------------------------------------------------------------
Procedure KSMessageI(aMessage: string; aBoxHead: string = '');
begin
  KSMessage(aMessage, GetBoxHead(aBoxHead, 'Information'), MB_ICONINFORMATION or MB_OK)
end;
//------------------------------------------------------------------------------
Procedure KSMessageQ(aMessage: string; aBoxHead: string = '');
begin
  KSMessage(aMessage, GetBoxHead(aBoxHead, 'Question'), MB_ICONQUESTION or MB_OK);
end;
//------------------------------------------------------------------------------
Procedure KSMessageE(aMessage: string; aBoxHead: string = '');
begin
  KSMessage(aMessage, GetBoxHead(aBoxHead, 'Error'), MB_ICONERROR or MB_OK);
end;
//------------------------------------------------------------------------------
Procedure KSMessageW(aMessage: string; aBoxHead: string = '');
begin
  KSMessage(aMessage, GetBoxHead(aBoxHead, 'Warning'), MB_ICONWARNING or MB_OK);
end;
//------------------------------------------------------------------------------
Procedure KSMessageT(aMessage: string; aBoxHead: string = '');
begin
  KSMessageI(aMessage, aBoxHead);
end;
//------------------------------------------------------------------------------
const
  NewBlock: string = '-----------------------------------------'+ #13+#10+#13+#10;

//------------------------------------------------------------------------------
function SaveDeveloperMessagesLog(afile: string): boolean;
begin
  //asm int 3 end; //KS trap
  result := SaveTextAsFile(afile, DeveloperMessagesLog);
  if result
     then DeveloperMessagesLog := '';
end;
//------------------------------------------------------------------------------
function CloseDeveloperMessagesLog(afile: string): boolean;
begin
  //asm int 3 end; //KS trap
  if ShowDeveloperMessages
     then begin
        DeveloperMessagesLog := DeveloperMessagesLog+ 'Log ended at: '+ DateTimeToStr(now)+ DblCrLf+ NewBlock;

        result := SaveTextAsFile(afile, DeveloperMessagesLog);
        if result
           then DeveloperMessagesLog := ''
           else KsMessageE('"Developer messages log" could not be saved to:'+CrLf+ afile);
     end
     else result := false;
end;
//------------------------------------------------------------------------------
procedure DeveloperMessage(aMessage: string);

begin
  //asm int 3 end; //trap
  if ShowDeveloperMessages
     then begin
        if length(DeveloperMessagesLog) = 0
           then begin
              DeveloperMessagesLog := 'Developer messages log for:'+CrLf+
                                      'Appe name: '+ActualAppName+ CrLf+
                                      'User: '+ KSGetUserName+CrLf+
                                      'Log started at: '+ GetShortDateTime(now) + DblCrLf+
                                      //DateTimeToStr(now)
                                       NewBlock;

           end;

        DeveloperMessagesLog := DeveloperMessagesLog + aMessage + DblCrLf + NewBlock;

        //by instalation DeveloperMessagesCanceled := True; is set at program start
        //i.e. in the beginning of KnowHow.dpr

        if DeveloperMessagesCanceled
           then exit;

        DeveloperMessagesCanceled := (IDCANCEL = KSQuestion('Developer message' + DblCrLf+ aMessage, 'Information',
                                      MB_ICONINFORMATION or MB_OKCANCEL));
     end;
end;
//------------------------------------------------------------------------------
procedure OpenDeveloperMessagesLog;
const
  Stars: string = '*****************************************'+ #13+#10;
var
  tmpFile: String;
begin
  //asm int 3 end; //KS trap
  if ShowDeveloperMessages
     then begin
        tmpFile := fileTemp('.txt');
        DeveloperMessagesLog := DeveloperMessagesLog + 'Log opened at: '+
                                DateTimeToStr(now)+ DblCrLf+ Stars + Stars+ NewBlock;

        if SaveTextAsFile(tmpFile, DeveloperMessagesLog)
           then ExecuteDefaultOpen('txt', tmpFile)
           else KSMessageE('Creation of '+tmpFile+' failed');
     end
     else KSMessageI('Developer messages log is not open');
end;
//------------------------------------------------------------------------------
function IsAlNum(C: char): bool;
begin
  //asm int 3 end; //trap
  result := C in ['0'..'9', 'A'..'Z', 'a'..'z', 'À'..'ÿ'];
end;
//------------------------------------------------------------------------------
procedure SearchForFiles(path, mask: AnsiString; var Value: TStringList; Recurse: Boolean = False);
//path = rootdir
//fileMask = *.db, *.*, ....osv
//value = stringlist til at modtage resultate af søgningen
//Recurse = True -> recursering af foldere under path
var
srRes : TSearchRec;
iFound : Integer;
begin
  //asm int 3 end; //KS trap
if (Recurse) // First, we must search the directories
	then begin
  	if path[Length(path)] <> '\' then path := path +'\';
    	iFound := FindFirst(path + '*.*', faAnyfile, srRes);
    	while iFound = 0 
     	do begin
      		if (srRes.Name <> '.') and (srRes.Name <> '..')
           	then if srRes.Attr and faDirectory > 0
              	then SearchForFiles(path + srRes.Name, mask, Value, Recurse);//recurse folder
      		iFound := FindNext(srRes);
      	end;
    FindClose(srRes);
  end;

// Now, we don't treat the directories anymore

if path[Length(path)] <> '\' then path := path +'\';

iFound := FindFirst(path + mask, faAnyFile-faDirectory {any file but not folders}, srRes);
while iFound = 0 {0 ~ true}
	do begin
  	if (srRes.Name <> '.') and (srRes.Name <> '..') and (srRes.Name <> '')
     	then Value.Add(path + srRes.Name);
    	iFound := FindNext(srRes);
  end;

FindClose(srRes);

end;
//------------------------------------------------------------------------------
type
  TRegProc = function : HResult; stdcall;
//------------------------------------------------------------------------------
function RegisterAxLib(FileName: string; Unreg: Boolean = False): boolean;
var
  LibHandle: THandle;
  RegProc: TRegProc;
  DllProc: String;
begin
  //asm int 3 end; //KS trap
  Result := False;

  LibHandle := LoadLibrary(PChar(FileName));
  if LibHandle = 0
     then begin
        KSMessageE('Failed to load:'+DblCrLf+FileName);
        exit;
     end;
  try
     if Unreg
        then DllProc := 'DllUnregisterServer'
        else DllProc := 'DllRegisterServer';

     @RegProc := GetProcAddress(LibHandle, Pchar(DllProc));
     if @RegProc = Nil
        then KSMessageE(DllProc+' procedure not found in:'+DblCrLf+FileName)
        else if RegProc <> 0    //run register process
           then KSMessageE('Call to '+DllProc+' failed in:'+DblCrLf+FileName)
           else Result := True; //success - the dll is Reg- / Unregistered
  finally
    FreeLibrary(LibHandle);
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure KSWait(aTime: Cardinal);
//waits unthil aTime (in miliseconds) is elapsed
var
  T: Cardinal;
begin
  //asm int 3 end; //trap
  T := GetTickCount + aTime;
  while T > GetTickCount do
     KSProcessMessages;
end;
//------------------------------------------------------------------------------
procedure KSProcessMessages;
var
  Msg: TMsg;

  //-----------------------
  function ProcessMessage(var Msg: TMsg): Boolean;
  begin
     Result := False;
     if PeekMessage(Msg, 0, 0, 0, PM_REMOVE)
        then begin
           Result := True;
           if Msg.Message = WM_QUIT
              then begin
                 {Re-post quit message so main message loop will terminate}
                 PostQuitMessage(Msg.WParam)
              end
              else begin
                 TranslateMessage(Msg);
                 DispatchMessage(Msg);
              end;
        end;
  end;
  //-----------------------
begin
  //asm int 3 end; //trap
  while ProcessMessage(Msg) do
     {loop};
end;
//------------------------------------------------------------------------------
function _GetExeOpen(const Ext: string; var Exefil: string; sielent: boolean = true): Boolean;
{ find app associated with the extension of filename.
  Since file must exist we create a dummy file}
var
	Dir, Name: string;
  res: array[1..250] of char;
  err: integer;
  F: TFileStream;
  //dummyFileCreated: boolean;
  filename: string;
begin
  //asm int 3 end; //KS trap

  filename := KSGetTempPath + '~~~~~~~~.'+Ext;
  F:= TFileStream.create (filename, fmCreate);
  F.free;

	Dir:= extractFilePath(FileName) + #0;
  Name:= extractFileName(FileName) +  #0;
  fillchar(res,SizeOf(res),' ');
  res[250]:= #0;
  err:= FindExecutable(@Name[1],@Dir[1],@res);
  if err >= 32
     then begin
        Exefil := strPas(@res);
        result := true;
     end
	   else begin
        if not Sielent
           then KSMessageE('No default program for "'+Ext+'"');
  	   result:= false;
        Exefil := '';
     end;

  deletefile(filename);
end;
//------------------------------------------------------------------------------
function GetAbsolutePath(ActualPath: string; var RelativePath: string): boolean;
var
  S: string;
  ActualForSlashes: Boolean;
  ActualP: String;
  RelativeP: String;
  NewPath: String;
begin 
  //asm int 3 end; //KS trap
  result := false;

  if pos('/', ActualPath) > 0
     then begin
        ActualForSlashes := true;
        ActualP := StringReplace(ActualPath, '/', '\',  [rfReplaceAll]);
                    //ChangeAllToken(ActualPath, '/', '\');
     end
     else begin
        ActualForSlashes := False;
        ActualP := ActualPath;
     end;

  ActualP := NoEndBackSlash(ActualP);

  if pos('/', RelativePath) > 0
     then RelativeP := StringReplace(ActualPath, '/', '\',  [rfReplaceAll])
     else RelativeP := RelativePath;

  RelativeP := NoEndBackSlash(RelativeP);

  if pos('..\', RelativeP) = 1
     then begin
        result := true;
        S := BeforLastToken(NoEndBackSlash(ActualP), '\');  //go up one level
        NewPath := after(RelativeP, '\');    //go up one level

        While pos('..\', NewPath) > 0  do
           begin
              S := BeforLastToken(S, '\');     //go up one level
              NewPath := after(NewPath, '\');    //go up one level
           end;

       NewPath := S +'\'+ NewPath;
     end
     else begin
        if RelativeP[1] = '\'
           then begin
              NewPath := ActualP + RelativeP;
              result := true;
           end
           else NewPath := RelativeP;
     end;

  if result
     then begin
        if ActualForSlashes
           then RelativePath := StringReplace(NewPath, '\', '/',  [rfReplaceAll])
                                   //ChangeAllToken(NewPath, '\', '/')
           else RelativePath := NewPath;
    end;
end;
//------------------------------------------------------------------------------

end.









