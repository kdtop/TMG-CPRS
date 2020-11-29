unit uImages;

//kt Entire unit added 11/24/20
 (*
 Copyright 11/24/20 Kevin S. Toppenberg, MD
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
  Windows, Messages, SysUtils, Classes, StdCtrls, ExtCtrls, ComCtrls, Dialogs, Forms,
  StrUtils, TMGHTML2, Controls, rFileTransferU, fImageTransferProgress,
  ORCtrls, ORFn, uConst, uCore, ORClasses, VAUtils, ORNet, TRPCB, uTIU;

type
  TImageInfo = class
    private
    public
      IEN :                int64;    //IEN in file# 2005
      ServerPathName :     AnsiString;
      ServerFName :        AnsiString;
      ServerThumbPathName: AnsiString;
      ServerThumbFName :   AnsiString;
      //Note: if there is no thumbnail to download, CacheThumbFName will still
      //      contain a file name and path, but a test for FileExists() will wail.
      CacheThumbFName :    AnsiString; // local cache path and File name of thumbnail image
      CacheFName :         AnsiString; // local cache path and File name of image
      ShortDesc :          AnsiString;
      LongDesc :           TStringList; //will be nil unless holds data.
      DateTime :           AnsiString;  //fileman format
      ImageType :          Integer;
      ProcName :           AnsiString;
      DisplayDate :        AnsiString;
      ParentDataFileIEN:   int64;
      AbsType :            char;      //'M' magnetic 'W' worm  'O' offline
      Accessibility :      char;      //'A' accessable  or  'O' offline
      DicomSeriesNum :     int64;
      DicomImageNum :      int64;
      GroupCount :         integer;
      TabIndex :           integer;
      TabImageIndex :      integer;
      //--------------------------------
      DownloadStatus:      TDownloadResult;
      SucessfullyDownloaded : boolean;
      NumDownloadAttempts:  integer;
    published
  end;

  TImgDelMode = (idmNone,idmDelete,idmRetract); //NOTE: DO NOT change order
  TImgTransferMethod = (itmDropbox,itmDirect,itmRPC);
  TBoolUnknown = (tbuUnknown, tbuFalse, tbuTrue);

procedure ImageDownloadInitialize();
function GetImagesForIEN(IEN: AnsiString; AImageInfoList : TList): integer;
function ParseOneImageListLine(s : string) : TImageInfo;
procedure SplitLinuxFilePath(FullPathName : AnsiString; var Path : AnsiString; var FName : AnsiString);
procedure AddNoteImagesToList(ImagesInHTMLNote: TStringList; AImageInfoList: TList);
function FillImageList(TIUIEN : string; AImageInfoList : TList) : integer;
procedure EmptyCache();
procedure DeleteImage(var DeleteSts: TActionRec; ImageFileName: String;
                      ImageIEN, DocIEN: Integer; DeleteMode : TImgDelMode;
                      HtmlEditor : THtmlObj; EditActive: Boolean; var RefreshNeeded : boolean;
                      DelUser : TUser; const Reason: string);  //Reason should be 10-60 chars;
function DoDecodeBarcode(LocalFNamePath,ImageType: AnsiString): AnsiString;
function DoCreateBarcode(MsgStr: AnsiString; ImageType: AnsiString): AnsiString;
function IndexOfIEN(AImageInfoList : TList; IEN : Int64) : integer;
function IndexOfServerFName(Name : string; AImageInfoList: TList): integer;
function DownloadFile(FPath,FName,LocalSaveFNamePath: AnsiString;
                      CurrentImage,TotalImages: Integer): TDownloadResult;
function DownloadFileViaDropbox(FPath,FName,LocalSaveFNamePath: AnsiString;CurrentImage,TotalImages: Integer): TDownloadResult;
function UploadFileViaDropBox(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
function UploadFile(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
procedure FileTransferProgressInitialize(CurrentValue, TotalValue : integer; Msg : string);
function FileTransferProgressCallback(CurrentValue, TotalValue : integer; Msg : string = '') : boolean;  //result: TRUE = CONTINUE, FALSE = USER ABORTED.
procedure FileTransferProgressDone();
procedure ClearImageList(AImageInfoList : TList);
procedure RemoveSuccessfullyDownloadedRecs(AImageInfoList: TList);
function ProcessDownloadCue(HideProgress : boolean = false) : TDownloadResult;
function EnsureRecDownloaded(Rec : TImageInfo) : TDownloadResult;
procedure EnsureSLImagesDownloaded(ImagesInHTMLNote : TStringList; HideProgress : boolean = false);
procedure EnsureLinkedImagesDownloaded;
procedure EnsureImageListLoaded(AImageInfoList : TList);
function GetImagesCount : integer;
function GetImageInfo(Index : integer) : TImageInfo;


var  //globally-scoped vars
  InsideImageDownload : boolean = false;
  InsideProcessDownloadCue : boolean = false;
  TransferMethod : TImgTransferMethod;
  DownloadThumbnails : tBoolUnknown;
  DropBoxDir : string;
  ImageInfoList : TList;  //contains TImageInfo items, and owns them.  This is download cue
  NumImagesAvailableOnServer : integer;
  ImageIndexLastDownloaded : integer;
  DownloadRetryCount : integer;

const
  BOOLU2BOOL : Array[false..true] of TBoolUnknown  = (tbuFalse, tbuTrue);

implementation

uses
  fFrame, fImages, uTMGOptions;


procedure ImageDownloadInitialize();
begin
  DownloadThumbnails := tbuUnknown;
  ImageInfoList := TList.Create;
  ClearImageList(ImageInfoList); //sets up other needed variables.
  DownloadRetryCount := 0;


  DropBoxDir := uTMGOptions.ReadString('Dropbox directory','??');
  if DropBoxDir='??' then begin  //just on first run.
    uTMGOptions.WriteBool('Use dropbox directory for transfers',false);
    uTMGOptions.WriteString('Dropbox directory','');
  end;
end;

function GetImagesForIEN(IEN: AnsiString; AImageInfoList : TList): integer;
//NOTE: This will ignore records found matching those already in AImageInfoList.
var
  i  : integer;
  s : string;
  Rec  : TImageInfo;
  BrokerResults: TStringList;
begin
  CallV('MAG3 CPRS TIU NOTE', [IEN]);
  BrokerResults := TStringList.Create;
  BrokerResults.Assign(RPCBrokerV.Results);
  for i:=0 to (BrokerResults.Count-1) do begin
    s := BrokerResults.Strings[i];
    if i=0 then begin
      if piece(s,'^',1)='0' then break //i.e. abort due to error signal
      else continue;   //ignore rest of header (record #0)
    end;
    Rec := ParseOneImageListLine(s);
    if Rec = nil then continue;
    if IndexOfIEN(AImageInfoList, Rec.IEN) > -1 then begin
      FreeAndNil(Rec);
      continue;  //ensure not added twice.
    end;
    AImageInfoList.Add(Rec);  // AImageInfoList will own Rec.
  end;
  Result := AImageInfoList.Count;
  BrokerResults.Free;
end;


function ParseOneImageListLine(s : string) : TImageInfo;
//Note: This function create TImageInfo objects but does NOT own them.
//      So caller must be responsible for them.
var
  j : integer;
  s2 : AnsiString;
  Rec  : TImageInfo;
  ImageIEN : integer;
  //TIUIEN : AnsiString;
  ServerFName : AnsiString;
  ServerPathName : AnsiString;
  ImageFPathName :     AnsiString;  //path on server of image  -- original data provided by server
  ThumbnailFPathName : AnsiString;  //path on server of thumbnail -- original data provided by server

begin
  Result := nil;
  if Pos('-1~',s)>0 then exit;  //abort if error signal.
  Rec := TImageInfo.Create; // ImageInfoList will own this.
  Rec.LongDesc := nil;
  Rec.TabIndex := -1;
  Rec.TabImageIndex := 0;
  s2 := piece(s,'^',2); if s2='' then s2 := '0'; //IEN
  Rec.IEN := StrToInt(s2);
  ImageFPathName := piece(s,'^',3);       //Image FullPath and name
  ThumbnailFPathName := piece(s,'^',4);   //Abstract FullPath and Name
  Rec.ShortDesc := piece(s,'^',5);            //SHORT DESCRIPTION field
  s2 := piece(s,'^',6); if s2='' then s2 := '0'; //PROCEDURE/ EXAM DATE/TIME field
  Rec.DateTime := s2;
  s2 := piece(s,'^',7); if s2='' then s2 := '0';  //OBJECT TYPE
  Rec.ImageType := StrToInt(s2);
  Rec.ProcName := piece(s,'^',8);                 //PROCEDURE field
  Rec.DisplayDate := piece(s,'^',9);              //Procedure Date in Display format
  s2 := piece(s,'^',10); if s2='' then s2 := '0'; //PARENT DATA FILE image pointer
  Rec.ParentDataFileIEN := StrToInt(s2);
  Rec.AbsType := piece(s,'^',11)[1];              //the ABSTYPE :  'M' magnetic 'W' worm  'O' offline
  s2 := piece(s,'^',12); if s2='' then s2 :='O';
  Rec.Accessibility := s2[1];                     //Image accessibility   'A' accessable  or  'O' offline
  s2 := piece(s,'^',13); if s2='' then s2 := '0'; //Dicom Series number
  Rec.DicomSeriesNum := StrToInt(s2);
  s2 := piece(s,'^',14); if s2='' then s2 := '0'; //Dicom Image Number
  Rec.DicomImageNum := StrToInt(s2);
  s2 := piece(s,'^',15); if s2='' then s2 := '0'; //Count of images in the group, or 1 if a single image
  Rec.GroupCount := StrToInt(s2);

  SplitLinuxFilePath(ImageFPathName,ServerPathName,ServerFName);
  Rec.ServerPathName := ServerPathName;
  Rec.ServerFName := ServerFName;
  Rec.CacheFName := CacheDir + '\' + ServerFName;
  SplitLinuxFilePath(ThumbnailFPathName,ServerPathName,ServerFName);
  Rec.ServerThumbPathName := ServerPathName;
  Rec.ServerThumbFName := ServerFName;
  Rec.CacheThumbFName := CacheDir + '\' + ServerFName;

  ImageIEN := Rec.IEN;
  CallV('TMG GET IMAGE LONG DESCRIPTION', [ImageIEN]);
  for j:=0 to (RPCBrokerV.Results.Count-1) do begin
    if (j>0) then begin
      if Rec.LongDesc = nil then Rec.LongDesc := TStringList.Create;
      Rec.LongDesc.Add(RPCBrokerV.Results.Strings[j]);
    end else begin
      if RPCBrokerV.Results[j]='' then break;
    end;
  end;
  Rec.SucessfullyDownloaded := false;
  Rec.NumDownloadAttempts := 0;
  Result := Rec;
end;


procedure SplitLinuxFilePath(FullPathName : AnsiString;
                             var Path     : AnsiString;
                             var FName    : AnsiString);
var  p : integer;
     n : integer;
begin
  Path := '';  FName := '';
  FullPathName := StringReplace(FullPathName,'/','\',[rfReplaceAll]);
  repeat
    p := Pos('\',FullPathName);
    if p > 0 then begin
      n := NumPieces(FullPathName, '\');
      FName := Piece(FullPathName, '\', n);
      Path := Pieces(FullPathName, '\', 1, n-1);
      FullPathName := '';
      //Path := Path + MidStr(FullPathName,1,p);
      //FullPathName := MidStr(FullPathName,p+1,1000);
    end else begin   //kt mod 11/23/12
      FName := FullPathName;
      FullPathName := '';
    end;
  until (FullPathName = '');
end;


procedure AddNoteImagesToList(ImagesInHTMLNote: TStringList; AImageInfoList: TList);

  function HashFileName(FileName: string): string;
  var i : integer;
      frag : string;
      tempFileName : string;
      HashLen : integer;
  begin
    tempFileName := piece(FileName,'.',1);
    HashLen := Length(tempFileName)-2;
    result :='/'+Midstr(FileName,1,4);
    i := 5;
    repeat
      frag := MidStr(FileName,i,2);
      result := result + '\' + frag;
      inc(i,2);
    until (i >= HashLen);
    result := result + '\' + FileName;
  end;

var i : integer;
    s :string;
    FileName,HashedFileName: string;
    Rec : TImageInfo;
begin
  for i  := 0 to ImagesInHTMLNote.Count - 1 do begin
    FileName := ImagesInHTMLNote[i];
    if (IndexOfServerFName(FileName, AImageInfoList) > -1) then continue;
    HashedFileName := HashFileName(FileName);   //Note: server must be set for hashed file use
    SetPiece(s,'^',3,HashedFileName);
    SetPiece(s,'^',11,'M');
    Rec := ParseOneImageListLine(s);
    if Rec <> nil then AImageInfoList.Add(Rec);
  end;
end;


function FillImageList(TIUIEN : string; AImageInfoList : TList) : integer;
//Note: This will ignore records found matching those already in AImageInfoList
var
  i  : integer;
  AddendumList: TStringList;

begin
  //inherited;
  AddendumList := TStringList.Create;
  //NOTE: This sometimes get called recursively, and clearing list causes crashes! //kt 11/24/20 -->  ClearImageList(AImageInfoList);
  StatusText('Retrieving images information...');
  Result := GetImagesForIEN(TIUIEN, AImageInfoList);
  //Get all images for addendums now
  CallV('TMG GET NOTE ADDENDUMS', [TIUIEN]);
  AddendumList.Assign(RPCBrokerV.Results);
  for i:=1 to AddendumList.count-1 do begin
    Result := Result + GetImagesForIEN(AddendumList[i], AImageInfoList);
  end;
  StatusText('');
  AddendumList.Free;
end;



procedure EmptyCache();
//This will delete ALL files in the Cache directory
//Note: This will include the html_note file created by
// the notes tab.
var
  //CacheDir : AnsiString;
  FoundFile : boolean;
  FSearch : TSearchRec;
  Files : TStringList;
  i : integer;
  FName : AnsiString;
  FExt : string;
  SkipFile, Crashing, IsNoteBackup : boolean;

begin
  Crashing := (ExceptObject <> nil) or TMGShuttingDownDueToCrash;
  Files := TStringList.Create;
//  CacheDir := ExtractFilePath(ParamStr(0))+ 'Cache';
  FoundFile := (FindFirst(CacheDir+'\*.*',faAnyFile,FSearch)=0);
  while FoundFile do Begin
    FName := FSearch.Name;
    FExt := UpperCase(ExtractFileExt(FName));
    IsNoteBackup := (FExt = '.TXT') and (Pos('BACKUP',FName)>0); //FYI BACKUP files are made in rTIU.TMGLocalBackup();
    SkipFile := (FName = '.') or (FName = '..');
    SkipFile := SkipFile or (Crashing and IsNoteBackup);
    if not SkipFile then begin
      FName := CacheDir + '\' + FName;
      Files.Add(FName);
    end;
    FoundFile := (FindNext(FSearch)=0);
  end;

  for i := 0 to Files.Count-1 do begin
    FName := Files.Strings[i];
    if DeleteFile(FName) = false then begin
      //kt raise Exception.Create('Unable to delete file: '+FSearch.Name+#13+'Will try again later...');
    end;
  end;
  Files.Free;
end;


procedure DeleteImage(var DeleteSts: TActionRec;
                      ImageFileName: String;
                      ImageIEN, DocIEN: Integer;
                      DeleteMode : TImgDelMode;
                      HtmlEditor : THtmlObj;
                      EditActive: Boolean;
                      var RefreshNeeded : boolean;
                      DelUser : TUser;
                      const Reason: string);  //Reason should be 10-60 chars;

  function ServerImageDelete(ImageIEN:integer; DeleteMode:tImgDelMode; Reason:String) : boolean;
  //Returns success
  var RPCResult,IEN,Mode : string;
  begin
    IEN := IntToStr(ImageIEN);
    Mode := IntToStr(Ord(DeleteMode));
    RPCResult := sCallV('TMG IMAGE DELETE', [IEN,Mode,Reason]);
    Result := Piece(RPCResult,'^',1)= '1';
    if Result = false then begin
      MessageDlg(Piece(RPCResult,'^',2),mtError,[mbOK],0);
    end;
  end;

  procedure NoteImageDelete(DocIEN:integer; FileName: string; DeleteMode:tImgDelMode; Reason:String);
  // <!-- Retracted By: UserName on Date  ...;..   -->
  var
     NoteText, tempString: string;
     Beginning, Ending: integer;
     boolFound: boolean;
  begin
     Ending := 1;
     Beginning := 1;
     boolFound := False;
     While (boolFound = False) AND (Beginning > 0) Do Begin
       NoteText := HtmlEditor.HTMLText;
       Beginning := PosEx('<IMG',NoteText, Ending);
       Ending :=  PosEx('>', NoteText, Beginning) + 1;
       tempString := MidStr(NoteText, Beginning, Ending-Beginning);
       if pos(FileName,tempString) > 0 then boolFound := True;
     end;
     if boolFound = false then  begin
       Ending := 1;
       Beginning := 1;
       boolFound := False;
       While (boolFound = False) AND (Beginning > 0) Do Begin
         NoteText := HtmlEditor.HTMLText;
         Beginning := PosEx('<embed',NoteText, Ending);
         Ending :=  PosEx('>', NoteText, Beginning) + 1;
         tempString := MidStr(NoteText, Beginning, Ending-Beginning);
         if pos(FileName,tempString) > 0 then boolFound := True;
       end;
     end;
     if boolFound = False then exit;
     if DeleteMode = idmDelete then begin
       HtmlEditor.HTMLText := AnsiReplaceStr(HtmlEditor.HTMLText, tempString, '');
     end else if DeleteMode = idmRetract then begin
       HtmlEditor.HTMLText := AnsiReplaceStr(HtmlEditor.HTMLText, tempString, ' <!-- ' + tempString + ' Retracted By: ' + DelUser.Name + ' on ' +  DateToStr(Now));
     end;
     RefreshNeeded := true;
  end;

begin
  RefreshNeeded := false;
  if Reason <> 'DeleteAll' then begin
    if MessageDlg('Permanently delete attached image or file?',mtConfirmation,mbOKCancel,0) <> mrOK then exit;
  end;
  if ServerImageDelete(ImageIEN,DeleteMode,Reason) = false then exit;
  if EditActive then NoteImageDelete(DocIEN,ImageFileName,DeleteMode,Reason);
  if DeleteMode = idmRetract then begin
    InfoBox('NOTICE','This image or file will now be RETRACTED.  As such, it has been'+CRLF +
            'removed from public view, and from typical Releases of Information,'+CRLF +
            'but will remain indefinitely discoverable to HIMS.'+CRLF+CRLF,MB_OK);
  end;
end;


function DoDecodeBarcode(LocalFNamePath,ImageType: AnsiString): AnsiString;
//Decode data from barcode on image, or return '' if none
//Note: if I could find a cost-effective way of decoding this on client side,
//      then that code be done here in the function, instead of uploading image
//      to the server for decoding.
const
  RefreshInterval = 500;
  BlockSize = 512;

var
  ReadCount                     : Word;
  ParamIndex                    : LongWord;
  j                             : word;
  InFile                        : TFileStream;
  Buffer                        : array[0..1024] of byte;
  RefreshCountdown              : integer;
  OneLine                       : AnsiString;
  RPCResult                     : AnsiString;
  SavedCursor                   : TCursor;
  totalReadCount                : integer;
  Abort                         : Boolean;
begin
  result := '';  //default of failure
  if not FileExists(LocalFNamePath) then exit;
  RPCResult := '';
  try
    InFile := TFileStream.Create(LocalFNamePath,fmOpenRead or fmShareCompat);
    RPCBrokerV.ClearParameters := true;
    RPCBrokerV.Param.Clear;
    RPCBrokerV.Param[0].PType := list;
    ParamIndex := 0;
    RefreshCountdown := RefreshInterval;
    //Put image data into parameter 0 (ARRAY parameter of RPC on server side)
    repeat
      ReadCount := InFile.Read(Buffer,BlockSize);
      OneLine := '';
      totalReadCount := totalReadCount + ReadCount;
      if ReadCount > 0 then begin
        SetLength(OneLine,ReadCount);
        for j := 1 to ReadCount do OneLine[j] := char(Buffer[j-1]);
        RPCBrokerV.Param[0].Mult[IntToStr(ParamIndex)] := Encode64(OneLine);
        Inc(ParamIndex);
      end;
    until (ReadCount < BlockSize);
    RPCBrokerV.Param[1].PType := literal;
    RPCBrokerV.Param[1].Value := ImageType;
    RPCBrokerV.remoteprocedure := 'TMG BARCODE DECODE';
    CallBroker;  //this is the slow step, pass to server and get response.
    //Get result: 1^DecodedMessage, or 0^Error Message
    if RPCBrokerV.Results.Count > 0 then RPCResult := RPCBrokerV.Results[0];
    if Piece(RPCResult,'^',1)='0' then begin
      MessageDlg(Piece(RPCResult,'^',2),mtError,[mbOK],0);
    end else begin
      result := Piece(RPCResult,'^',2);
    end;
  finally
    InFile.Free;
  end;
end;


function DoCreateBarcode(MsgStr: AnsiString; ImageType: AnsiString): AnsiString;
//Create a local barcode file, in .png format, from MsgStr
//ImageType is optional, default ='png'.  It should NOT contain '.'
//Returns file path on local client of new barcode image.
//Note: this function is not related to uploading or downloading images
//      to the server for attaching to progress notes.  It is included
//      in this unit because the functionality used is nearly identical to
//      the other code.
  function UniqueFName : AnsiString;
    var  FName,tempFName : AnsiString;
         count : integer;
  begin
    FName := 'Barcode-Image';
    count := 0;
    repeat
      tempFName := CacheDir + '\' + FName + '.' + ImageType;
      FName := FName + '1';
      count := count+1;
    until (fileExists(tempFName)=false) or (count> 32);
    result := tempFName;
  end;

var
  i,count                       : integer;
  j                             : word;
  OutFile                       : TFileStream;
  s                             : AnsiString;
  Buffer                        : array[0..1024] of byte;
  LocalSaveFNamePath            : AnsiString;
  SavedResult                   : TStringList;

begin
  LocalSaveFNamePath := UniqueFName;
  Result := LocalSaveFNamePath;  //default to success;
  RPCBrokerV.ClearParameters := true;
  RPCBrokerV.remoteprocedure := 'TMG BARCODE ENCODE';
  RPCBrokerV.param[0].Value := MsgStr;
  RPCBrokerV.param[0].PType := literal;
  RPCBrokerV.Param[1].Value := '.X';  //<-- is this needed or used?
  RPCBrokerV.Param[1].PType := list;
  RPCBrokerV.Param[1].Mult['"IMAGE TYPE"'] := ImageType;
  CallBroker;
  SavedResult := TStringList.Create;
  SavedResult.Assign(RPCBrokerV);
  //Note:SavedResult.Results[0]=1 if successful load, =0 if failure
  if (SavedResult.Count>0) and (SavedResult[0]='1') then begin
    OutFile := TFileStream.Create(LocalSaveFNamePath,fmCreate);
    for i:=1 to (SavedResult.Count-1) do begin
      s :=Decode64(SavedResult[i]);
      count := Length(s);
      if count>1024 then begin
        Result := ''; //failure of load.
        break;
      end;
      for j := 1 to count do Buffer[j-1] := ord(s[j]);
      OutFile.Write(Buffer,count);
    end;
    OutFile.Free;
  end else begin
    result := '';
  end;
  SavedResult.Free;
end;

function IndexOfIEN(AImageInfoList : TList; IEN : Int64) : integer;
var i : integer;
    Rec : TImageInfo;
begin
  result := -1;
  for i := 0 to AImageInfoList.Count - 1 do begin
    Rec := TImageInfo(AImageInfoList[i]);
    if IEN = Rec.IEN then begin
      result := i;
      break;
    end;
  end;
end;

function IndexOfServerFName(Name : string; AImageInfoList: TList): integer;
var i : integer;
    Rec : TImageInfo;
begin
  result := -1;
  for i := 0 to AImageInfoList.Count - 1 do begin
    Rec := TImageInfo(AImageInfoList[i]);
    if UpperCase(Name) = UpperCase(Rec.ServerFName) then begin
      result := i;
      break;
    end;
  end;
end;

function DownloadFile(FPath,FName,LocalSaveFNamePath: AnsiString;
                      CurrentImage,TotalImages: Integer): TDownloadResult;
var
  ErrMsg            : string;
  AProgressCallback :   TProgressCallback;
begin
  //frmFrame.timSchedule.Enabled := false;      //12/1/17 added timSchedule enabler to keep it from crashing the RPC download
  if TransferMethod = itmDropbox then begin
    Result := DownloadFileViaDropBox(FPath, FName, LocalSaveFNamePath, CurrentImage, TotalImages);
    exit;
  end else begin
    FileTransferProgressInitialize(CurrentImage, TotalImages, 'Downloading Image');
    ErrMsg := '';
    StatusText('Retrieving full image...');
    AProgressCallback := FileTransferProgressCallback;
    Result := rFileTransferU.DownloadFile(FPath,FName,LocalSaveFNamePath, ErrMsg, AProgressCallback);
    StatusText('');
    //FileTransferProgressDone();
    If ErrMsg <> '' then MessageDlg('ERROR: '+ErrMsg,mtError,[mbOK],0);
  end;
  //frmFrame.timSchedule.Enabled := true;      //12/1/17 added timSchedule enabler to keep it from crashing the RPC download
end;

function DownloadFileViaDropbox(FPath,FName,LocalSaveFNamePath: AnsiString;
                                CurrentImage,TotalImages: Integer): TDownloadResult;
var
  ErrMsg          : string;
begin
  StatusText('Retrieving full image...');
  ErrMsg := '';
  FileTransferProgressInitialize(CurrentImage, TotalImages, 'Downloading images via a drop box');
  Result := rFileTransferU.DownloadFileViaDropbox(FPath, FName, LocalSaveFNamePath, DropboxDir, ErrMsg, FileTransferProgressCallback);
  FileTransferProgressDone();
  If ErrMsg <> '' then MessageDlg('ERROR: '+ErrMsg,mtError,[mbOK],0);
  StatusText('');
end;

function UploadFileViaDropBox(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
var
  ErrMsg : string;
begin
  Result := false; //default to failure.
  if not FileExists(LocalFNamePath) then exit;

  StatusText('Uploading full image...');
  Application.ProcessMessages;
  Result := rFileTransferU.UploadFileViaDropBox(LocalFNamePath, FPath, FName, DropboxDir, ErrMsg);
  If ErrMsg <> '' then MessageDlg('ERROR: '+ErrMsg,mtError,[mbOK],0);
  StatusText('');
end;

function UploadFile(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
var
  ErrMsg : string;
begin
  Result := false; //default to failure.
  if not FileExists(LocalFNamePath) then exit;
  if TransferMethod = itmDropbox then begin
    Result := UploadFileViaDropBox(LocalFNamePath,FPath,FName, CurrentImage,TotalImages);
    exit;
  end;

  FileTransferProgressInitialize(CurrentImage, TotalImages, 'Uploading full image...');
  StatusText('Uploading full image...');
  Application.ProcessMessages;
  Result := rFileTransferU.UploadFile(LocalFNamePath,FPath,FName, ErrMsg, FileTransferProgressCallback);
  StatusText('');
  FileTransferProgressDone();
  If ErrMsg <> '' then MessageDlg('ERROR: '+ErrMsg,mtError,[mbOK],0);
end;

procedure FileTransferProgressInitialize(CurrentValue, TotalValue : integer; Msg : string);
begin
  if not assigned(frmImageTransfer) then frmImageTransfer := TfrmImageTransfer.Create(Application);
  frmImageTransfer.UpdateProgress(CurrentValue, TotalValue, Msg);
end;

function FileTransferProgressCallback(CurrentValue, TotalValue : integer; Msg : string): boolean;  //result: TRUE = CONTINUE, FALSE = USER ABORTED.
begin
  if not assigned(frmImageTransfer) then begin
    Result := false;
    exit;
  end;
  frmImageTransfer.UpdateProgress(CurrentValue, TotalValue, Msg);
  Result := not frmImageTransfer.UserCanceled;
end;

procedure FileTransferProgressDone();
begin
  FreeAndNil(frmImageTransfer);
end;

procedure ClearImageList(AImageInfoList : TList);
//Note: !! This should also clear any visible images/thumbnails etc.
//Note: Need to remove thumbnail image from image list.
var i    : integer;
begin
  if assigned(AImageInfoList) then for i := AImageInfoList.Count-1 downto 0 do begin
    if TImageInfo(AImageInfoList[i]).LongDesc <> nil then begin
      TImageInfo(AImageInfoList[i]).LongDesc.Free;
    end;
    try
      TImageInfo(AImageInfoList[i]).Free;
    except
      On E: Exception do begin
      end;
    end;
    AImageInfoList.Delete(i);
  end;
  NumImagesAvailableOnServer := NOT_YET_CHECKED_SERVER;
  ImageIndexLastDownloaded := -1;
end;

procedure EnsureSLImagesDownloaded(ImagesInHTMLNote : TStringList; HideProgress : boolean = false);
var i : integer;
    Rec : TImageInfo;
    DownloadResult : TDownloadResult;

begin
  AddNoteImagesToList(ImagesInHTMLNote, ImageInfoList);
  EnsureImageListLoaded(ImageInfoList);  //<-- this will also get Linked images.
  ProcessDownloadCue(HideProgress); //ignore TDownloadResult result
end;

procedure RemoveSuccessfullyDownloadedRecs(AImageInfoList: TList);
var i : integer;
    Rec : TImageInfo;
begin
  for i := AImageInfoList.Count-1 downto 0 do begin
    Rec := TImageInfo(AImageInfoList[i]);
    if not Rec.SucessfullyDownloaded then continue;
    FreeAndNil(Rec);
    AImageInfoList.Delete(i);
  end;
end;

function EnsureRecDownloaded(Rec : TImageInfo) : TDownloadResult;
begin
  result := drSuccess; //default
  if IndexOfIEN(ImageInfoList, Rec.IEN) > -1 then exit;  //ensure not added twice.
  ImageInfoList.Add(Rec);  // AImageInfoList will own Rec.
  Result := ProcessDownloadCue();
end;

procedure EnsureLinkedImagesDownloaded;
begin
  EnsureImageListLoaded(ImageInfoList);
  ProcessDownloadCue(); //ignore TDownloadResult result
end;

procedure EnsureImageListLoaded(AImageInfoList : TList);
begin
  if NumImagesAvailableOnServer = NOT_YET_CHECKED_SERVER then begin
    NumImagesAvailableOnServer := FillImageList(NotesTIUIEN, AImageInfoList);
  end;
end;


function ProcessDownloadCue(HideProgress : boolean = false) : TDownloadResult;
//NOTES: 1) This works off globally scoped ImageInfoList.
//       2) This function is sometimes called recursively via asyncronous mouse clicks etc
//       3) If this cycle was processing, and user selected another note, then those
//          images would be added to the download cue.
//       4) Thus the length of the ImageInfoList may be in constant flux, so I
//          can't simply cyle through it with a for loop.

  Function DownloadRecToCache(Rec : TImageInfo; CurrentImage : integer = 1;TotalImages: Integer=2) : TDownloadResult;
  //Loads image specified in Rec to Cache (unless already present)
  //NOTE: I am making this a sub-function so it won't get called directly.
  var
    ServerFName : AnsiString;
    ServerPathName : AnsiString;
    R1,R2 : TDownloadResult;

  begin
    if InsideImageDownload then begin
      Result := drTryAgain;
      Exit;
    end;
    try
      InsideImageDownload := true;
      ServerFName := Rec.ServerFName;
      ServerPathName := Rec.ServerPathName;
      R1 := drSuccess;  //default
      R2 := drSuccess;  //default
      if not FileExists(Rec.CacheFName) then begin
        R1 := DownloadFile(ServerPathName,ServerFName,Rec.CacheFName,CurrentImage,TotalImages);
      end;
      ServerFName := Rec.ServerThumbFName;
      ServerPathName := Rec.ServerThumbPathName;
      if not FileExists(Rec.CacheThumbFName) then begin
        if DownloadThumbnails = tbuUnknown then DownloadThumbnails := BOOLU2BOOL[uTMGOptions.ReadBool('CPRS Download Thumbnails',False)];
        if (DownloadThumbnails = tbuTrue) then
          R2 := DownloadFile(ServerPathName,ServerFName,Rec.CacheThumbFName,CurrentImage+1,TotalImages);
      end;
      Application.ProcessMessages;
      if (R1 = drFailure) or (R2 = drFailure) then begin
        Result := drFailure;
      end else if (R1 = drTryAgain) or (R2 = drTryAgain) then begin
        Result := drTryAgain;
      end else if (R1 = drUserAborted) or (R2 = drUserAborted) then begin
        Result := drUserAborted;
      end else begin
        Result := drSuccess;
      end;
      Rec.DownloadStatus := Result;
      Rec.SucessfullyDownloaded := (Result = drSuccess);
      //SetupTimer;
    finally
      InsideImageDownload := false;
    end;
  end;

var
  i : integer;
  Done : boolean;
  Rec : TImageInfo;
  ActionPerformed : boolean;
  DownloadResult : TDownloadResult;

begin
  Result := drSuccess;  //default
  if InsideProcessDownloadCue then begin
    Result := drTryAgain;
    Exit;
  end;
  if ImageInfoList.Count = 0 then exit;
  InsideProcessDownloadCue := true;
  Done := false;
  i := 0;
  try
    if not assigned(frmImageTransfer) then frmImageTransfer := TfrmImageTransfer.Create(Application);
    frmImageTransfer.ProgressMsg.Caption := 'Downloading Images';
    frmImageTransfer.ProgressBar.Min := 0;
    frmImageTransfer.ProgressBar.Position := 0;
    frmImageTransfer.ProgressBar.Max := ImageInfoList.Count;
    if not HideProgress then frmImageTransfer.Show;
    repeat
      ActionPerformed := false;
      Rec := TImageInfo(ImageInfoList[i]);
      if not Rec.SucessfullyDownloaded
      and (Rec.NumDownloadAttempts < DOWNLOAD_RETRY_LIMIT) then begin
        inc(Rec.NumDownloadAttempts);
        DownloadResult := DownloadRecToCache(Rec, i, ImageInfoList.Count); //Note: this can lead to re-entrant call of this function
        ActionPerformed := true;
        if frmImageTransfer.UserCanceled then break;
      end;
      inc(i);
      if (i >= ImageInfoList.Count) and (ActionPerformed = true) then i := 0;  //start loop over for retries etc.
      Done := (i >= ImageInfoList.Count) and (ActionPerformed = false);
    until Done;
    RemoveSuccessfullyDownloadedRecs(ImageInfoList); //will leave in unsuccessful tries...
  finally
    InsideProcessDownloadCue := false;
    FreeAndNil(frmImageTransfer);
  end;
end;

function GetImagesCount : integer;
//Returns number of images possible, not just those already downloaded.
//NOTE: If a 2nd note is selected before all images from first note is downloaded,
//      then this would return count of both I think.
begin
  EnsureImageListLoaded(ImageInfoList);
  Result := NumImagesAvailableOnServer;
end;


function GetImageInfo(Index : integer) : TImageInfo;
begin
  if (Index > -1) and (Index < ImageInfoList.Count) then begin
    Result := TImageInfo(ImageInfoList[Index]);
  end else begin
    Result := nil;
  end;
end;



initialization

finalization
  ClearImageList(ImageInfoList);
  ImageInfoList.Free;


end.
