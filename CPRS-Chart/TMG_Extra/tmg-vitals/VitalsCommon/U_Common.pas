unit U_Common;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{Original code by Shane A. Holmes.  Modified by Gary Darby with permission }
interface

uses Windows, Classes, SysUtils, Contnrs;

type

 TOperatingSystem = (osUnknown, osWin95, osWin98, osWinNT, osWin2K, osWinXP);

 TIntObj = class(TObject)
 private
  fValue: Integer;
 public
  property Value: Integer read fValue write fValue;
  constructor Create(AValue: Integer);overload;
 end;

 TScore = class(TObject)
 private
  fName: String;
  fScore: Integer;
 public
  property Name: String read fName write fName;
  property Score: Integer read fScore write fScore;
  constructor Create(AName: String; AScore: Integer);
 end;

 TScores = class(TObjectList)
 private
  fMaxScores: Integer;
  function ReadStreamStr(Stream : TStream) : string;
  function ReadStreamInt(Stream : TStream) : integer;
  procedure WriteStreamStr(Stream : TStream; Str : string);
  procedure WriteStreamInt(Stream : TStream; Num : integer);
 public
  property MaxScores: Integer read fMaxScores write fMaxScores default 5;
  function isHighScore(AScore: Integer): Boolean;
  procedure SaveScoresToFile(FileName: String);
  procedure LoadScoresFromFile(FileName: String);
  procedure GetScores(List: TStrings);
  procedure AddScore(Score: TScore);
  constructor Create;
 end;

 function CompareScores(Item1, Item2: Pointer): Integer;
 function WinOpSys : TOperatingSystem;

var
 Lights: TObjectList;
 Scores: TScores;

implementation

function WinOpSys : TOperatingSystem;
var
 Win95, Win98, WinNT, Win2K, WinXP : boolean;
begin
  Win95 := (Win32MajorVersion = 4) and (Win32MinorVersion = 0)
            and (Win32Platform = VER_PLATFORM_WIN32_WINDOWS);
  Win98 := (Win32MajorVersion = 4) and (Win32MinorVersion = 10)
            and (Win32Platform = VER_PLATFORM_WIN32_WINDOWS);
  WinNT := (Win32MajorVersion = 4) and (Win32MinorVersion = 0)
            and (Win32Platform = VER_PLATFORM_WIN32_NT);
  WinXP := (Win32MajorVersion = 5) and (Win32MinorVersion = 1)
            and (Win32Platform = VER_PLATFORM_WIN32_NT);
  Win2K := (Win32MajorVersion = 5) and (Win32MinorVersion = 0)
            and (Win32Platform = VER_PLATFORM_WIN32_NT);
  Result := osUnknown;
  if Win95 then
    Result := osWin95
  else
    if Win98 then
      Result := osWin98
    else
      if WinNT then
        Result := osWinNT
      else
        if WinXP then
          Result := osWinXP
        else
          if Win2k then
            Result := osWin2K;
end;

function CompareScores(Item1, Item2: Pointer): Integer;
{Sort compare exit}
begin
 result := Integer(TScore(Item2).Score) - Integer(TScore(Item1).Score);
end;

constructor TIntObj.Create(AValue: Integer);
begin
 fValue:= AValue;
end;

constructor TScore.Create(AName: String; AScore: Integer);
begin
 fName:= AName;
 fScore:= AScore;
end;

constructor TScores.Create;
begin
 inherited Create;
 fMaxScores:= 5;
end;

procedure TScores.WriteStreamInt(Stream : TStream; Num : integer);
begin
 Stream.Write(Num, SizeOf(Integer));
end;

procedure TScores.WriteStreamStr(Stream : TStream; Str : string);
var
 StrLen : integer;
begin
 StrLen := Length(Str);
 WriteStreamInt(Stream, StrLen);
 Stream.Write(Str[1], StrLen);
end;

function TScores.ReadStreamInt(Stream : TStream) : integer;
begin
 Stream.Read(Result, SizeOf(Integer));
end;

function TScores.ReadStreamStr(Stream : TStream) : string;
var
 StrLen : integer;
begin
 StrLen := ReadStreamInt(Stream);
 if StrLen > -1 then
 begin
  SetLength(Result, StrLen);
  Stream.Read(Result[1], StrLen);
 end
 else
 Result := '';
end;

function TScores.isHighScore(AScore: Integer): Boolean;
begin
 if Scores.Count < MaxScores then result:= True
 else
 result:= (AScore > TScore(Scores[scores.count-1]).Score);
end;

procedure TScores.SaveScoresToFile(FileName: String);
var
 MemStr: TMemoryStream;
 I: Integer;
begin
 MemStr:= TMemoryStream.Create;
 WriteStreamInt(MemStr, Scores.Count);
 for I:= 0 to Scores.Count - 1 do
 begin
  WriteStreamStr(MemStr, TScore(Scores[I]).Name);
  WriteStreamInt(MemStr, TScore(Scores[I]).Score);
 end;
 MemStr.SaveToFile(FileName);
 MemStr.Free;
end;

procedure TScores.LoadScoresFromFile(FileName: String);
var
 MemStr: TMemoryStream;
 AScore, I, SCount :Integer;
 AName: String;
 AScoreObj: TScore;
begin
 MemStr:= TMemoryStream.Create;
 MemStr.LoadFromFile(FileName);
 SCount:= ReadStreamInt(MemStr);
 for I:= 0 to SCount - 1 do
 begin
  AName:= ReadStreamStr(MemStr);
  AScore:= ReadStreamInt(MemStr);
  AScoreObj:= TScore.Create(AName, AScore);
  Scores.Add(AScoreObj);
 end;
 MemStr.Free;
end;

procedure TScores.GetScores(List: TStrings);
var
 I: Integer;
begin
 List.Clear;
 for I:= 0 to Scores.Count - 1 do
  List.Add(TScore(Scores[I]).Name + ' : ' + IntToStr(TScore(Scores[I]).Score));
end;

procedure TScores.AddScore(Score: TScore);
begin
 Scores.Add(Score);
 Scores.Sort(@CompareScores);
 if Scores.Count > Scores.MaxScores then
  Scores.Delete(scores.count-1);
end;

initialization

 Lights:= TObjectList.Create;
 Lights.OwnsObjects:= True;

 Scores:= TScores.Create;
 Scores.OwnsObjects:= True;

finalization
 Lights.Free;
 Scores.Free;
end.
