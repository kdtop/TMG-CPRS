unit rFileTransferU;

//kt Entire unit added 10/2020
 (*
 Copyright 10/27/20 Kevin S. Toppenberg, MD
 --------------------------------------------------------------------

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 == Alternatively, at user's choice, GPL license below may be used ===

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may view details of the GNU General Public License at this URL:
 http://www.gnu.org/licenses/
 *)

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,
  StdCtrls, ExtCtrls, Menus, ComCtrls, ORCtrls, ORFn, uConst, ORDtTm,
  TRPCB,
  uPCE, ORClasses, ImgList, rTIU, uTIU, uDocTree, Dialogs, StrUtils,
  ORNet, OleCtrls ;

type
  TPDFInfo = class(TObject)
    IEN, FName, RelPath : string;
    LocalSaveFNamePath : string;
    LabDate: TFMDateTime;
  end;
  TDownloadResult = (drSuccess, drTryAgain, drFailure, drGiveUp, drUserAborted);
  TProgressCallback = function(CurrentValue, TotalValue : integer; Msg : string=''): boolean;  //result: TRUE = CONTINUE, FALSE = USER ABORTED.

procedure GetAvailLabPDFs(OutList : TStringList; DFN : string; StartDate: TFMDateTime = 0; EndDate : TFMDateTime = 9999999);

function DownloadFileCommon(FPath,FName,LocalSaveFNamePath: AnsiString;
                            RPCName : string;
                            var ErrMsg : string;
                            ProgressCallback :   TProgressCallback = nil): TDownloadResult;
function DownloadLabPDF(FPath,FName,LocalSaveFNamePath: AnsiString;
                        CurrentFileNum, TotalFileNum: Integer;
                        var ErrMsg : string;
                        ProgressCallback : TProgressCallback = nil) : TDownloadResult;
function DownloadFile(FPath,FName,LocalSaveFNamePath: AnsiString;
                      var ErrMsg : string;
                      ProgressCallback : TProgressCallback = nil): TDownloadResult;
function DownloadFileViaDropbox(FPath,FName,LocalSaveFNamePath, DropboxDir: AnsiString;
                                var ErrMsg : string;
                                ProgressCallback : TProgressCallback = nil): TDownloadResult;
function UploadFile(LocalFNamePath,FPath,FName: AnsiString;
                    var ErrMsg : string;
                    ProgressCallback : TProgressCallback = nil): boolean;
function UploadFileViaDropBox(LocalFNamePath, FPath, FName, DropboxDir: AnsiString; var ErrMsg : string): boolean;

function Encode64(Input: AnsiString) : AnsiString;
function Decode64(Input: AnsiString) : AnsiString;
function FileSize(fileName : wideString) : Int64;

var
  CacheDir : AnsiString;


implementation


procedure GetAvailLabPDFs(OutList : TStringList; DFN : string; StartDate: TFMDateTime = 0; EndDate : TFMDateTime = 9999999);
begin
  if not Assigned(OutList) then exit;
  tCallV(OutList,'TMG CPRS LAB PDF LIST',[DFN, StartDate, EndDate]);
end;


function DownloadFileCommon(FPath,FName,LocalSaveFNamePath: AnsiString;
                            RPCName : string;
                            var ErrMsg : string;
                            ProgressCallback :   TProgressCallback = nil): TDownloadResult;
var
  i,count                       : integer;
  j                             : word;
  OutFile                       : TFileStream;
  s                             : AnsiString;
  Buffer                        : array[0..1024] of byte;
  RefreshCountdown              : integer;
  BrokerResult                  : string;
  LocalBrokerResults            : TStringList;

const
  RefreshInterval = 250;
begin
  Result := drFailure; //default to failure
  ErrMsg := '';
  if FileExists(LocalSaveFNamePath) then DeleteFile(LocalSaveFNamePath);
  LocalBrokerResults := TStringList.Create;
  try
    CallV(RPCName, [FPath,FName]);
    RefreshCountdown := RefreshInterval;
    LocalBrokerResults.Assign(RPCBrokerV.Results);
    //Note:LocalBrokerResults[0]=1 if successful load, =0 if failure
    if LocalBrokerResults.Count=0 then LocalBrokerResults.Add('-1^Unknown download error.');
    BrokerResult := LocalBrokerResults[0];
    if Piece(BrokerResult,'^',1)<>'1' then begin
      ErrMsg := Piece(BrokerResult,'^',2);
      exit;
    end;

    OutFile := TFileStream.Create(LocalSaveFNamePath,fmCreate);
    for i:=1 to (LocalBrokerResults.Count-1) do begin
      s := Decode64(LocalBrokerResults[i]);
      count := Length(s);
      if count>1024 then begin
        ErrMsg := 'During download, server sent line that was too long.';
        break;
      end;
      for j := 1 to count do Buffer[j-1] := ord(s[j]);
      OutFile.Write(Buffer,count);
      Dec(RefreshCountdown);
      if RefreshCountdown < 1 then begin
        RefreshCountdown := RefreshInterval;
        if assigned(ProgressCallback) then begin
          if not ProgressCallback(i, LocalBrokerResults.Count-1) then begin
            Result := drUserAborted;
            exit;
          end;
        end;
      end;
    end;
    if ErrMsg <> '' then exit;
    Result := drSuccess;  //if we got this far, all is good.
  finally
    OutFile.Free;
    LocalBrokerResults.Free;
  end;
end;


function DownloadLabPDF(FPath,FName,LocalSaveFNamePath: AnsiString;
                        CurrentFileNum, TotalFileNum: Integer;
                        var ErrMsg : string;
                        ProgressCallback : TProgressCallback = nil) : TDownloadResult;
begin
  Result := DownloadFileCommon(FPath,FName,LocalSaveFNamePath,
                               'TMG CPRS LAB PDF DOWNLOAD',
                               ErrMsg, ProgressCallback);
end;


function DownloadFile(FPath,FName,LocalSaveFNamePath: AnsiString;
                      var ErrMsg : string;
                      ProgressCallback :   TProgressCallback = nil): TDownloadResult;
begin
  Result := DownloadFileCommon(FPath,FName,LocalSaveFNamePath,
                               'TMG DOWNLOAD FILE', ErrMsg, ProgressCallback);
end;

function DownloadFileViaDropbox(FPath,FName,LocalSaveFNamePath, DropboxDir: AnsiString;
                                var ErrMsg : string;
                                ProgressCallback :   TProgressCallback = nil): TDownloadResult;
var
  DropboxFile : AnsiString;
  DownloadFileSize : Integer;
  LastLocalFileSize, LocalFileSize    : integer;
  bResult          : boolean;
  TimeoutTime      : integer;
  Abort            : boolean;
const
  SleepPerCycle = 500;
  MaxTimeoutTime = 1000 * 15; //15 seconds of no change.

begin
  if FileExists(LocalSaveFNamePath) then DeleteFile(LocalSaveFNamePath);
  Abort := False;
  Result := drFailure;  //default to failure
  ErrMsg := '';
  CallV('TMG DOWNLOAD FILE DROPBOX', [FPath,FName]);  //Move file into dropbox.
  if RPCBrokerV.Results.Count > 0 then begin
    bResult := (Piece(RPCBrokerV.Results[0],'^',1)='1');  //1=success, 0=failure
    if bResult = false then begin
      ErrMsg := Piece(RPCBrokerV.Results[0],'^',2);
      exit;
    end;
  end else begin
    ErrMsg := 'Error communicating with server to retrieve image.';
    exit;
  end;
  if not DirectoryExists(DropboxDir) then begin
    ErrMsg := 'Invalid Dropbox Directory. Please check your settings and try again.';
    exit;
  end;
  DropboxFile := ExcludeTrailingBackslash(DropboxDir) + '\' + FName;
  TimeoutTime := MaxTimeoutTime;
  DownloadFileSize := StrToInt(Piece(RPCBrokerV.Results[0],'^',3));  //Piece 3 = file size
  LastLocalFileSize := 0;
  repeat
    sleep(SleepPerCycle);
    LocalFileSize := FileSize(DropboxFile);
    if assigned(ProgressCallback) then begin
      Abort := not ProgressCallback(LocalFileSize, DownloadFileSize);
    end;
    if LocalFileSize = LastLocalFileSize then begin
      TimeoutTime := TimeoutTime - SleepPerCycle;
      if TimeoutTime <= 0 then begin
        ErrMsg := 'Timeout waiting for file to download via dropbox.';
        exit;
      end;
    end else begin
      TimeoutTime := MaxTimeoutTime;  //reset timeout, as progress is being made.
    end;
  until (LocalFileSize >= DownloadFileSize) or Abort;

  //Now move DropBox\FileName --> LocalFileNamePath
  if MoveFile(pchar(DropboxFile),pchar(LocalSaveFNamePath))=false then begin
    ErrMsg := 'Dropbox file transfer failed.  Code='+InttoStr(GetLastError);
    exit;
  end;

  Result := drSuccess;  //if we got this far, all is good.
end;


function UploadFile(LocalFNamePath,FPath,FName: AnsiString;
                    var ErrMsg : string;
                    ProgressCallback : TProgressCallback = nil): boolean;
const
  RefreshInterval = 250;
  BlockSize = 512;

var
  ReadCount                     : Word;
  totalReadCount                : Integer;
  LocalFileSize                 : integer;
  ParamIndex                    : LongWord;
  j                             : word;
  InFile                        : TFileStream;
  LocalOutFile                  : TFileStream;
  Buffer                        : array[0..1024] of byte;
  RefreshCountdown              : integer;
  OneLine                       : AnsiString;
  RPCResult                     : AnsiString;
  Abort                         : boolean;

begin
  result := false;  //default of failure
  if not FileExists(LocalFNamePath) then exit;
  LocalFileSize := FileSize(LocalFNamePath);
  try
    InFile := TFileStream.Create(LocalFNamePath,fmOpenRead or fmShareCompat);
    LocalOutFile := TFileStream.Create(CacheDir+'\'+FName,fmCreate or fmOpenWrite); //for local copy
  except
    InFile.Free;
    LocalOutFile.Free;
    exit;
  end;

  Abort := false;

  RPCBrokerV.remoteprocedure := 'TMG UPLOAD FILE';
  RPCBrokerV.ClearParameters := true;
  RPCBrokerV.Param[0].PType := literal;
  RPCBrokerV.Param[0].Value := FPath;
  RPCBrokerV.Param[1].PType := literal;
  RPCBrokerV.Param[1].Value := FName;
  RPCBrokerV.Param[2].PType := literal;
  RPCBrokerV.Param[2].Value := '';

  RPCBrokerV.Param[3].PType := list;
  ParamIndex := 0;
  RefreshCountdown := RefreshInterval;
  repeat
    ReadCount := InFile.Read(Buffer,BlockSize);
    LocalOutFile.Write(Buffer,ReadCount); //for local copy
    totalReadCount := totalReadCount + ReadCount;
    OneLine := '';
    if ReadCount > 0 then begin
      SetLength(OneLine,ReadCount);
      for j := 1 to ReadCount do OneLine[j] := char(Buffer[j-1]);
      RPCBrokerV.Param[3].Mult[IntToStr(ParamIndex)] := Encode64(OneLine);
      Inc(ParamIndex);

      Dec(RefreshCountdown);
      if RefreshCountdown < 1 then begin
        RefreshCountdown := RefreshInterval;
        //Note: I could probably cut progress updates out.  Most of the delay occurs during
        // the RPC call, and I can't make a progress bar change during that without changing the RPC broker...
        if assigned(ProgressCallback) then begin
          if not ProgressCallback(totalReadCount, LocalFileSize, 'Prepping for upload') then begin
             Abort := true;
             break;
          end;
        end;
      end;
    end;
  until (ReadCount < BlockSize);

  if assigned(ProgressCallback) then begin
    if not ProgressCallback(totalReadCount, LocalFileSize, 'Uploading file.') then begin
      Abort := true;
    end;
  end;

  if not Abort then begin
    CallBroker;  //<-- most time will be spent here....
    if RPCBrokerV.Results.Count > 0 then begin
      RPCResult := RPCBrokerV.Results[0];
    end else RPCResult := '';
    result := (Piece(RPCResult,'^',1)='1');
    if (result=false) then begin
      ErrMsg := 'Error uploading file.' + #13 + Piece(RPCResult,'^',2);
    end;
  end;

  InFile.Free;
  LocalOutFile.Free;
end;


function UploadFileViaDropBox(LocalFNamePath,FPath,FName, DropboxDir: AnsiString; var ErrMsg : string): boolean;
//NOTE: Callback progress function not used because I can't give it a meaningful result.
var
  DropboxFile : AnsiString;
begin
  Result := false; //default to failure
  //First copy LocalFileNamePath --> DropBox\FileName
  DropboxFile := ExcludeTrailingBackslash(DropboxDir) + '\' + FName;
  if CopyFile(pchar(LocalFNamePath),pchar(DropboxFile),false)=false then begin
    ErrMsg :='Dropbox file transfer failed.  Code='+InttoStr(GetLastError);
    exit;
  end;
  CallV('TMG UPLOAD FILE DROPBOX', [FPath,FName]);     //Move file into dropbox.
  if RPCBrokerV.Results.Count>0 then begin
    Result := (Piece(RPCBrokerV.Results[0],'^',1)='1');  //1=success, 0=failure
  end else Result := false;
end;


function Encode64(Input: AnsiString) : AnsiString;
//This function is based on ENCODE^RGUTUU, which is match for
//DECODE^RGUTUU that is used to decode (ascii armouring) on the
//server side.  This is a base64 encoder.
const
  //FYI character set is 64 characters (starting as 'A')
  //  (65 characters if intro '=' is counted)
  CharSet  = '=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var
  //Result : AnsiString;  // RGZ1  //'Result' is implicitly declared by Pascal

  i : integer;            //RGZ2
  j : integer;            //RGZ4
  PlainTrio : longword;   //RGZ3   //unsigned 32-bit
  EncodedByte : Byte;
  PlainByte : byte;       //RGZ5
  EncodedQuad : string[4];//RGZ6

begin
  //e.g. input (10 bytes):
  // 174 231 193   16 29 251   93 138 4    57
  // AE  E7  C1    10 1D FB    5D 8A  04   39
  Result := '';
  i := 1;
  while i<= Length(Input) do begin  //cycle in groups of 3
    PlainTrio := 0;
    EncodedQuad := '';
    //Get 3 bytes, to be converted into 4 characters eventually.
    //Fill with 0's if needed to make an even 3-byte group.
    For j:=0 to 2 do begin
      //e.g. '174'->PlainByte=174
      if (i+j) <= Length(Input) then PlainByte := ord(Input[i+j])
      else PlainByte := 0;
      PlainTrio := (PlainTrio shl 8) or PlainByte;
    end;
    //e.g. first 3 bytes--> PlainTrio= $AEE7C1 (10101110 11100111 11000001)
    //e.g. last  3 bytes--> PlainTrio= $390000 (00111001 00000000 00000000) (note padded 0's)

    //Take each 6 bits and convert into a character.
    //e.g. first 3 bytes--> (101011 101110 011111 000001)
    //                       43      46     31     1

    //e.g. last 3 bytes-->(001110 010000 000000 000000)  (after redivision)
    //                        14     16     0     0  <-- last 2 bytes are padded 0
    //                               ^ last 4 bits of '16' are padded 0's
    For j := 1 to 4 do begin
      //e.g. $AEE7C1 --> (43+2)=45 (46+2)=48 (31+2)=33 (1+2)=3
      //                         r        u         f        b

      //e.g. $39AF00 --> (14+2)=16 (16+2)=18 (0+2)=2 (0+2)=2
      //                         O        Q        A       A <-- 2 padded bytes
      EncodedByte := (PlainTrio and 63)+2;  //63=$3F=b0111111;  0->A 1->B etc
      EncodedQuad := CharSet[EncodedByte]+ EncodedQuad;  //string Concat, not math add
      PlainTrio := PlainTrio shr 6
    end;

    //Append result with latest quad
    Result := Result + EncodedQuad;
    Inc(i,3);
  end;

  // e.g. result: rufb .... .... OQAA <-- 2 padded bytes (and part of Q is padded also)
  i := 3-(Length(Input) mod 3);  //returns 1,2,or 3 (3 needs to be set to 0)
  if (i=3) then i:=0;   //e.g. input=10 -> i=2
  j := Length(Result);
  //i is the number of padded characters that need to be replaced with '='
  if i>=1 then Result[j] := '=';  //replace 1st paddeded char
  if i>=2 then Result[Length(Result)-1] := '=';//replace 2nd paddeded char
  // e.g. result: rufb .... .... OQ==

  //results passed out in Result
end;


function Decode64(Input: AnsiString) : AnsiString;
//This function is based on DECODE^RGUTUU, which is match for
//ENCODE^RGUTUU that is used to encode (ascii armouring) on the
//server side.  This is a Base64 decoder
const
  //FYI character set is 64 characters (starting as 'A')
  //  (65 characters if intro '=' is counted)
  CharSet  = '=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

var
  //Result : AnsiString;  //RGZ1  //'Result' is implicitly declared by Pascal
  i : integer;            //RGZ2
  PlainTrio : longword;   //RGZ3  //unsigned 32-bit
  j : integer;            //RGZ4
  EncodedChar : char;
  PlainInt : integer;
  PlainByte : byte;       //RGZ5
  DecodedTrio : string[3];//RGZ6

begin
  Result:='';
  i := 1;
  //e.g. input: rufb .... .... OQ==

  while i <= Length(Input) Do begin  //cycle in groups of 4
    PlainTrio :=0;
    DecodedTrio :='';
    //Get 4 characters, to be converted into 3 bytes.
    For j :=0 to 3 do begin
      //e.g. last 4 chars --> 0A==
      if (i+j) <= Length(Input) then begin
        EncodedChar := Input[i+j];
        PlainInt := Pos(EncodedChar,CharSet)-2; //A=0, B=1 etc.
        if (PlainInt>=0) then PlainByte := (PlainInt and $FF) else PlainByte := 0;
      end else PlainByte := 0;
      //e.g. with last 4 characters:
      //e.g. '0'->14=(b001110) 'Q'->16=(b010000) '='-> -1 -> 0=(b000000) '=' -> 0=(b000000)
      //e.g.-- So last PlainTrio = 001110 010000 000000 000000 = 00111001 00000000 00000000
      //Each encoded character contributes 6 bytes to final 3 bytes.
      //4 chars * 6 bits/char=24 bits -->  24 bits / 8 bits/byte = 3 bytes
      PlainTrio := (PlainTrio shl 6) or PlainByte;  //PlainTrio := PlainTrio*64 + PlainByte;
    end;
    //Now take 3 bytes, and add to cumulative output (in same order)
    For j :=0 to 2 do begin
      DecodedTrio := Chr(PlainTrio and $FF) + DecodedTrio;  //string concat (not math addition)
      PlainTrio := PlainTrio shr 8;  // PlainTrio := PlainTrio div 256
    end;
    //e.g. final DecodedTrio = 'chr($39) + chr(0) + chr(0)'
    Result := Result + DecodedTrio;
    Inc(i,4);
  end;

  //Now remove 1 byte from the output for each '=' in input string
  //(each '=' represents 1 padded 0 added to allow for even groups of 3)
  for j :=0 to 1 do begin
    if (Input[Length(Input)-j] = '=') then begin
      Result := MidStr(Result,1,Length(Result)-1);
    end;
  end;
end;


function FileSize(fileName : wideString) : Int64;
var
  sr : TSearchRec;
begin
  if FindFirst(fileName, faAnyFile, sr ) = 0 then
     result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) +  Int64(sr.FindData.nFileSizeLow)
  else
     result := -1;

  FindClose(sr) ;
end;



end.
