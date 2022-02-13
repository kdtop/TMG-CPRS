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
  Windows, Messages, SysUtils, Classes, StdCtrls, ExtCtrls, ComCtrls, Dialogs,
  Forms, AxCtrls, Graphics, Controls, StrUtils,
  TMGHTML2, rFileTransferU, fImageTransferProgress,
  ORCtrls, ORFn, uConst, uCore, ORClasses, VAUtils, ORNet, TRPCB, uTIU;

type
  TImageWhichDownload = (twdImageAndThumb, twdImgeOnly, twdThumbOnly, twdNone);
  TImageInfo = class(TObject)
    private
    public
      IEN :                int64;    //IEN in file# 2005
      ServerPathName :     AnsiString;
      ServerFName :        AnsiString;
      ServerThumbPathName: AnsiString;
      ServerThumbFName :   AnsiString;
      //Note: if there is no thumbnail to download, CacheThumbFName will still
      //      contain a file name and path, but a test for FileExists() will fail.
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
      SucessfullyDownloadedThumb : boolean;
      NumDownloadAttempts: integer;
      LinkedTIUIEN :       string;  //optional.  Can be used to store if this image is linked to by a 8925 TIU note.
      Tag :                Integer;
      RefCount :           integer;  //initialized to 1.
      //--------------------------------
      DesiredDownloadMode : TImageWhichDownload;
      function ShouldDownloadImage: boolean;
      function ShouldDownloadThumb: boolean;
      function NeedsDownloadImage: boolean;
      function NeedsDownloadThumb: boolean;
      procedure CheckFilesExist;
      procedure Assign(Source : TImageInfo);
      procedure Clear;
      constructor Create(); overload;
      constructor Create(Source : TImageInfo); overload;
      destructor Destroy;
    published
  end;

  TImgDelMode = (idmNone, idmDelete, idmRetract); //NOTE: DO NOT change order
  TImgTransferMethod = (itmDropbox,itmDirect,itmRPC);
  TBoolUnknown = (tbuUnknown, tbuFalse, tbuTrue);

procedure ImageDownloadInitialize();
function  GetImagesForIEN(IEN: AnsiString; AImageInfoList : TList): integer;
function  GetAllImages(AImageInfoList : TList; SDT : TFMDateTime = 0; EDT : TFMDateTime= 9999999.999999; ExcludeSL : TStringList=nil): integer;
function  ParseOneImageListLine(s : string) : TImageInfo;
procedure SplitLinuxFilePath(FullPathName : AnsiString; var Path : AnsiString; var FName : AnsiString);
procedure AddNoteImagesToList(ImagesInHTMLNote: TStringList; AImageInfoList: TList);
function  FillImageList(TIUIEN : string; AImageInfoList : TList) : integer;
procedure EmptyCache();
procedure DeleteAllAttachedImages(TIUIEN : string; DeleteMode: TImgDelMode; HtmlEditor : THtmlObj; EditIsActive : boolean);
procedure DeleteImage(var DeleteSts: TActionRec; ImageFileName: String;
                      ImageIEN, DocIEN: Integer; DeleteMode : TImgDelMode;
                      HtmlEditor : THtmlObj; EditActive: Boolean; var RefreshNeeded : boolean;
                      DelUser : TUser; const Reason: string);  //Reason should be 10-60 chars;
procedure DeleteImageIndex(ImageIndex : integer; DeleteMode : TImgDelMode; boolPromptUser: boolean; HtmlEditor : THtmlObj; EditIsActive : boolean);
function  DoDecodeBarcode(LocalFNamePath,ImageType: AnsiString): AnsiString;
function  DoCreateBarcode(MsgStr: AnsiString; ImageType: AnsiString): AnsiString;
function  IndexOfIEN(AImageInfoList : TList; IEN : Int64) : integer;
function  IndexOfServerFName(Name : string; AImageInfoList: TList): integer;
function  DownloadFile(FPath,FName,LocalSaveFNamePath: AnsiString;
                      CurrentImage,TotalImages: Integer; HideProgress : boolean = false): TDownloadResult;
function  DownloadFileViaDropbox(FPath,FName,LocalSaveFNamePath: AnsiString;CurrentImage,TotalImages: Integer): TDownloadResult;
function  UploadFileViaDropBox(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
function  UploadFile(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
procedure ClearImageList(AImageInfoList : TList);
procedure RemoveSuccessfullyDownloadedRecs(AImageInfoList: TList);
function  ProcessDownloadCue(HideProgress : boolean = false) : TDownloadResult;
function  EnsureRecDownloaded(Rec : TImageInfo; HideProgress : boolean = false) : TDownloadResult;
procedure EnsureSLImagesDownloaded(ImagesInHTMLNote : TStringList; HideProgress : boolean = false);
procedure EnsureLinkedImagesDownloaded;
procedure EnsureImageListLoaded(AImageInfoList : TList; ForceReload : boolean = false);
function  GetImagesCount : integer;
function  GetImageInfo(Index : integer) : TImageInfo; overload;
function  GetImageInfo(AImageInfoList : TList; Index : integer) : TImageInfo; overload;
procedure HandlePatientChanged();
function  LoadAnyImageFormatToBMP(FPath : string; BMP : TBitmap) : boolean;
procedure ForceServerImageReQuery();
procedure SetActiveListBoxForImages(ListBox : TORListBox);
function  ActiveTIUIENForImages: string;
function  ActiveTIUIENForImagesInt: int64;


const
  BOOLU2BOOL : Array[false..true] of TBoolUnknown  = (tbuFalse, tbuTrue);

var  //globally-scoped vars
  TransferMethod : TImgTransferMethod;
  DropBoxDir : string;


implementation

uses
  fFrame, fImages, uTMGOptions, fNoteDR;

procedure DeleteImageIndexCommon(AImageInfoList : TList; ImageIndex : integer; DeleteMode : TImgDelMode; boolPromptUser: boolean; HtmlEditor : THtmlObj; EditIsActive : boolean); forward;
procedure FileTransferProgressInitialize(CurrentValue, TotalValue : integer; Msg : string); forward;
procedure FileTransferProgressDone(); forward;
function FileTransferProgressCallback(CurrentValue, TotalValue : integer; Msg : string = '') : boolean; forward; //result: TRUE = CONTINUE, FALSE = USER ABORTED.


var  //locally scoped (within unit) vars
  InsideProcessDownloadCue : boolean;
  NumImagesAvailableOnServer : integer;  //<-- this name probably needs to be changed...
  DownloadQueInfoList : TList;  //contains TImageInfo items, and owns them.  This is download cue
  ActiveListBox : TORListBox; //will be set as pointer to frmNotes.lstNotes OR frmConsults.lstNotes

//------------------------------------------------------------------------------

procedure TImageInfo.Assign(Source : TImageInfo);
begin
  IEN := Source.IEN;
  ServerPathName := Source.ServerPathName;
  ServerFName := Source.ServerFName;
  ServerThumbPathName := Source.ServerThumbPathName;
  ServerThumbFName := Source.ServerThumbFName;
  CacheThumbFName := Source.CacheThumbFName;
  CacheFName := Source.CacheFName;
  ShortDesc := Source.ShortDesc;
  if assigned(Source.LongDesc) then LongDesc.Assign(Source.LongDesc);
  DateTime := Source.DateTime;
  ImageType := Source.ImageType;
  ProcName := Source.ProcName;
  DisplayDate := Source.DisplayDate;
  ParentDataFileIEN := Source.ParentDataFileIEN;
  AbsType := Source.AbsType;
  Accessibility := Source.Accessibility;
  DicomSeriesNum := Source.DicomSeriesNum;
  DicomImageNum := Source.DicomImageNum;
  GroupCount := Source.GroupCount;
  TabIndex := Source.TabIndex;
  TabImageIndex := Source.TabImageIndex;
  DownloadStatus := Source.DownloadStatus;
  SucessfullyDownloaded := Source.SucessfullyDownloaded;
  SucessfullyDownloadedThumb := Source.SucessfullyDownloadedThumb;
  NumDownloadAttempts := Source.NumDownloadAttempts;
  LinkedTIUIEN := Source.LinkedTIUIEN;
  Tag := Source.Tag;
  DesiredDownloadMode := Source.DesiredDownloadMode;
  //don't copy RefCount
end;

function TImageInfo.ShouldDownloadImage: boolean;
begin
  Result := DesiredDownloadMode in [twdImageAndThumb,twdImgeOnly];
end;

function TImageInfo.ShouldDownloadThumb: boolean;
begin
  Result := DesiredDownloadMode in [twdImageAndThumb,twdThumbOnly];
end;

function TImageInfo.NeedsDownloadImage: boolean;
begin
  Result := Self.ShouldDownloadImage and not Self.SucessfullyDownloaded;
end;

function TImageInfo.NeedsDownloadThumb: boolean;
begin
  Result := Self.ShouldDownloadThumb and not Self.SucessfullyDownloadedThumb;
end;

procedure TImageInfo.CheckFilesExist;
begin
  SucessfullyDownloaded := FileExists(CacheFName);
  SucessfullyDownloadedThumb := FileExists(CacheThumbFName);
end;


procedure TImageInfo.Clear;
begin
  IEN := 0;
  ServerPathName := '';
  ServerFName := '';
  ServerThumbPathName := '';
  ServerThumbFName := '';
  CacheThumbFName := '';
  CacheFName := '';
  ShortDesc := '';
  if assigned(LongDesc) then LongDesc.clear;
  DateTime := '';
  ImageType := 0;
  ProcName := '';
  DisplayDate := '';
  ParentDataFileIEN := 0;
  AbsType := #0;
  Accessibility := #0;
  DicomSeriesNum := 0;
  DicomImageNum := 0;
  GroupCount := 0;
  TabIndex := 0;
  TabImageIndex := 0;
  DownloadStatus := drSuccess;
  SucessfullyDownloaded := false;
  SucessfullyDownloadedThumb := false;
  NumDownloadAttempts := 0;
  LinkedTIUIEN := '';
  Tag := 0;
  DesiredDownloadMode := twdImageAndThumb;
  RefCount := 1;
end;

constructor TImageInfo.Create();
begin
  inherited;
  Clear();
end;

constructor TImageInfo.Create(Source : TImageInfo);
begin
  inherited Create();
  Assign(Source);
end;

destructor TImageInfo.Destroy;
begin
  if assigned(LongDesc) then LongDesc.Free;
  inherited;
end;


//------------------------------------------------------------------------------



procedure ImageDownloadInitialize();
begin
  //DownloadThumbnails := tbuUnknown;
  DownloadQueInfoList := TList.Create;
  ClearImageList(DownloadQueInfoList); //sets up other needed variables.
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


function GetAllImages(AImageInfoList : TList; SDT : TFMDateTime = 0; EDT : TFMDateTime= 9999999.999999; ExcludeSL : TStringList=nil): integer;
//NOTE: This will ignore records found matching those already in AImageInfoList.
//Input: AImageInfoList -- an OUT parameter
//       SDT, EDT -- optional start and end of search range
//       ExcludeSL.  Format  ExcludeSL[#] = '<8925.1>'
var
  i  : integer;
  s : string;
  Rec  : TImageInfo;
  BrokerResults: TStringList;
  TIUIEN : string;
begin
  BrokerResults := TStringList.Create;
  tCallV(BrokerResults,'TMG CPRS IMAGE LIST ALL', [Patient.DFN, SDT, EDT, ExcludeSL]);
  for i:=0 to (BrokerResults.Count-1) do begin
    s := BrokerResults.Strings[i];
    if i=0 then begin
      if piece(s,'^',1)='0' then break //i.e. abort due to error signal
      else continue;   //ignore rest of header (record #0)
    end;
    TIUIEN := piece(s, '^', 1);
    s := MidStr(s, length(TIUIEN)+2, length(s));  //trim off first piece.
    Rec := ParseOneImageListLine(s);
    if Rec = nil then continue;
    if IndexOfIEN(AImageInfoList, Rec.IEN) > -1 then begin
      FreeAndNil(Rec);
      continue;  //ensure not added twice.
    end;
    Rec.LinkedTIUIEN := TIUIEN;
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
  Rec.SucessfullyDownloadedThumb := false;
  Rec.NumDownloadAttempts := 0;
  Result := Rec;
  Rec.LinkedTIUIEN := '';
  Rec.Tag := 0;
  Rec.DesiredDownloadMode := twdImageAndThumb;
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

procedure DeleteAllAttachedImages(TIUIEN : string; DeleteMode: TImgDelMode;
                                  HtmlEditor : THtmlObj; EditIsActive : boolean);
var TempImageInfoList : TList;
    i : integer;

begin
  TempImageInfoList := TList.Create();
  EnsureImageListLoaded(TempImageInfoList, true);
  for i := TempImageInfoList.Count-1 downto 0 do begin
    DeleteImageIndexCommon(TempImageInfoList, i, DeleteMode, false, HtmlEditor, EditIsActive);
  end;
  ClearImageList(TempImageInfoList);
  TempImageInfoList.Free;
  //to do -- force reload of displayed images...
end;

procedure DeleteImageIndex(ImageIndex : integer;  DeleteMode : TImgDelMode;
                           boolPromptUser: boolean; HtmlEditor : THtmlObj;
                           EditIsActive : boolean );
//NOTE: This function needs to be sanity checked after refactoring...                           
begin
  DeleteImageIndexCommon(DownloadQueInfoList, ImageIndex, DeleteMode,
                         boolPromptUser, HtmlEditor, EditIsActive);
end;

procedure DeleteImageIndexCommon(AImageInfoList : TList;
                                 ImageIndex : integer;
                                 DeleteMode : TImgDelMode;
                                 boolPromptUser: boolean;
                                 HtmlEditor : THtmlObj;
                                 EditIsActive : boolean
                                 );
//Note: permissions must be checked before running this function
var
  ImageInfo : TImageInfo;
  ReasonForDelete : string;
  DeleteSts : TActionRec;
  RefreshNeeded : boolean;

CONST
  TMG_PRIVACY  = 'FOR PRIVACY';  //Server message (don't translate)
  TMG_ADMIN    = 'ADMINISTRATIVE'; //Server message (don't translate)

begin
  if (ImageIndex<0) or (ImageIndex>=GetImagesCount) then begin
    MessageDlg('Invalid image index to delete: '+IntToStr(ImageIndex), mtError,[mbOK],0);
    exit;
  end;
  ImageInfo := GetImageInfo(AImageInfoList, ImageIndex);
  if boolPromptUser then begin
    //ReasonForDelete := SelectDeleteReason(frmNotes.lstNotes.ItemIEN);
    ReasonForDelete := SelectDeleteReason(ActiveTIUIENForImagesInt);
    if ReasonForDelete = DR_CANCEL then Exit;
    if ReasonForDelete = DR_PRIVACY then begin
      ReasonForDelete := TMG_PRIVACY;
    end else if ReasonForDelete = DR_ADMIN then begin
      ReasonForDelete := TMG_ADMIN;
    end;
  end else begin
    ReasonForDelete := 'DeleteAll';
  end;

  //DeleteImage(DeleteSts, ImageInfo.ServerFName, ImageInfo.IEN, ListBox.ItemIEN, DeleteMode, ReasonForDelete);
  DeleteImage(DeleteSts, ImageInfo.ServerFName, ImageInfo.IEN,
              ActiveTIUIENForImagesInt, DeleteMode, HtmlEditor, EditIsActive,
              RefreshNeeded, User, ReasonForDelete);

  //Delete the cached image and thumbnail     10/22/21
  DeleteFile(ImageInfo.CacheThumbFName);
  DeleteFile(ImageInfo.CacheFName);
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
  //SavedCursor                   : TCursor;
  totalReadCount                : integer;
  //Abort                         : Boolean;
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
                      CurrentImage,TotalImages: Integer; HideProgress : boolean = false): TDownloadResult;
var
  ErrMsg            : string;
  AProgressCallback :   TProgressCallback;
begin
  if TransferMethod = itmDropbox then begin
    Result := DownloadFileViaDropBox(FPath, FName, LocalSaveFNamePath, CurrentImage, TotalImages);
    exit;
  end else begin
    if not HideProgress then begin
      FileTransferProgressInitialize(CurrentImage, TotalImages, 'Downloading Image');
      AProgressCallback := FileTransferProgressCallback;
    end else begin
      AProgressCallback := nil;
    end;
    ErrMsg := '';
    StatusText('Retrieving image...');
    //AProgressCallback := FileTransferProgressCallback;
    Result := rFileTransferU.DownloadFile(FPath,FName,LocalSaveFNamePath, ErrMsg, AProgressCallback);
    StatusText('');
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
var i    : integer;
    Rec  : TImageInfo;
begin
  if not assigned(AImageInfoList) then exit;
  for i := AImageInfoList.Count-1 downto 0 do begin
    Rec := TImageInfo(AImageInfoList[i]);
    Dec(Rec.RefCount);
    if Rec.RefCount <= 0 then Rec.Free;
    AImageInfoList.Delete(i);
  end;
  NumImagesAvailableOnServer := NOT_YET_CHECKED_SERVER;
end;

procedure EnsureSLImagesDownloaded(ImagesInHTMLNote : TStringList; HideProgress : boolean = false);

begin
  AddNoteImagesToList(ImagesInHTMLNote, DownloadQueInfoList);
  EnsureImageListLoaded(DownloadQueInfoList);  //<-- this will also get Linked images.
  ProcessDownloadCue(HideProgress); //ignore TDownloadResult result
end;

procedure RemoveSuccessfullyDownloadedRecs(AImageInfoList: TList);
var i : integer;
    Rec : TImageInfo;
begin
  for i := AImageInfoList.Count-1 downto 0 do begin
    Rec := TImageInfo(AImageInfoList[i]);
    if (Rec.DesiredDownloadMode in [twdImageAndThumb,twdImgeOnly])  and not Rec.SucessfullyDownloaded      then continue;
    if (Rec.DesiredDownloadMode in [twdImageAndThumb,twdThumbOnly]) and not Rec.SucessfullyDownloadedThumb then continue;
    if Rec.RefCount > 0 then Dec(Rec.RefCount);
    if Rec.RefCount = 0 then FreeAndNil(Rec);
    AImageInfoList.Delete(i);
  end;
end;

function EnsureRecDownloaded(Rec : TImageInfo; HideProgress : boolean = false) : TDownloadResult;
begin
  result := drSuccess; //default
  if IndexOfIEN(DownloadQueInfoList, Rec.IEN)< 0 then begin  //ensure not added twice.
    DownloadQueInfoList.Add(Rec);  // AImageInfoList will own and delete GiveAwayRec if Rec.RefCount = 1
  end;
  Result := ProcessDownloadCue(HideProgress);
end;

procedure EnsureLinkedImagesDownloaded;
begin
  EnsureImageListLoaded(DownloadQueInfoList);
  ProcessDownloadCue(); //ignore TDownloadResult result
end;

procedure EnsureImageListLoaded(AImageInfoList : TList; ForceReload : boolean = false);
begin
  if (NumImagesAvailableOnServer = NOT_YET_CHECKED_SERVER) or ForceReload then begin
    NumImagesAvailableOnServer := FillImageList(ActiveTIUIENForImages, AImageInfoList);
  end;
end;


function ProcessDownloadCue(HideProgress : boolean = false) : TDownloadResult;
//NOTES: 1) This works off globally scoped ImageInfoList.
//       2) This function is sometimes called recursively via asyncronous mouse clicks etc
//       3) If this cycle was processing, and user selected another note, then those
//          images would be added to the download cue.
//       4) Thus the length of the ImageInfoList may be in constant flux, so I
//          can't simply cyle through it with a for loop.

  Function DownloadRecToCache(Rec:TImageInfo; CurrentImage:integer=1; TotalImages:Integer=2; HideProgress:boolean=false) : TDownloadResult;
  //Loads image specified in Rec to Cache (unless already present)
  //NOTE: I am making this a sub-function so it won't get called directly.
  var
    ServerFName : AnsiString;
    ServerPathName : AnsiString;
    R1,R2 : TDownloadResult;

  begin
    ServerFName := Rec.ServerFName;
    ServerPathName := Rec.ServerPathName;
    R1 := drSuccess;  //default
    R2 := drSuccess;  //default
    Rec.CheckFilesExist;  //updates   SucessfullyDownloaded,  SucessfullyDownloadedThumb
    if Rec.NeedsDownloadImage then begin
      R1 := DownloadFile(ServerPathName,ServerFName,Rec.CacheFName,CurrentImage,TotalImages, HideProgress);
      Rec.SucessfullyDownloaded := (R1 = drSuccess);
    end;
    ServerFName := Rec.ServerThumbFName;
    ServerPathName := Rec.ServerThumbPathName;
    if  Rec.NeedsDownloadThumb then begin
      //if DownloadThumbnails = tbuUnknown then DownloadThumbnails := BOOLU2BOOL[uTMGOptions.ReadBool('CPRS Download Thumbnails',False)];
      //if (DownloadThumbnails = tbuTrue) then
      R2 := DownloadFile(ServerPathName,ServerFName,Rec.CacheThumbFName,CurrentImage+1,TotalImages, HideProgress);
      Rec.SucessfullyDownloadedThumb := (R2 = drSuccess);
    end;
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
  end; //DownloadRecToCache

var
  i : integer;
  Done : boolean;
  Rec : TImageInfo;
  ActionPerformed : boolean;
  DownloadResult : TDownloadResult;

begin  //ProcessDownloadCue
  Result := drSuccess;  //default
  if InsideProcessDownloadCue then begin
    Result := drTryAgain;
    Exit;
  end;
  if DownloadQueInfoList.Count = 0 then exit;
  InsideProcessDownloadCue := true;
  Done := false;
  i := 0;
  try
    repeat
      ActionPerformed := false;
      Rec := TImageInfo(DownloadQueInfoList[i]);
      if (Rec.NeedsDownloadImage or Rec.NeedsDownloadThumb) and (Rec.NumDownloadAttempts < DOWNLOAD_RETRY_LIMIT) then begin
        inc(Rec.NumDownloadAttempts);
        DownloadResult := DownloadRecToCache(Rec, i, DownloadQueInfoList.Count, HideProgress); //Note: this can lead to re-entrant call of this function
        ActionPerformed := true;
        if assigned(frmImageTransfer) and frmImageTransfer.UserCanceled then break;
      end;
      inc(i);
      if (i >= DownloadQueInfoList.Count) and (ActionPerformed = true) then i := 0;  //start loop over for retries etc.
      Done := (i >= DownloadQueInfoList.Count) and (ActionPerformed = false);
    until Done;
    RemoveSuccessfullyDownloadedRecs(DownloadQueInfoList); //will leave in unsuccessful tries...
  finally
    InsideProcessDownloadCue := false;
  end;
end;

function GetImagesCount : integer;
//Returns number of images possible, not just those already downloaded.
//NOTE: If a 2nd note is selected before all images from first note is downloaded,
//      then this would return count of both I think.

//TO DO.  This function needs sanity check after refactoring...

begin
  EnsureImageListLoaded(DownloadQueInfoList);
  Result := NumImagesAvailableOnServer;
end;


function GetImageInfo(Index : integer) : TImageInfo;
//TO DO.  This function needs sanity check after refactoring...
begin
  Result := GetImageInfo(DownloadQueInfoList, Index);
end;

function GetImageInfo(AImageInfoList : TList; Index : integer) : TImageInfo; overload;
begin
  if (Index > -1) and (Index < AImageInfoList.Count) then begin
    Result := TImageInfo(AImageInfoList[Index]);
  end else begin
    Result := nil;
  end;
end;

function LoadAnyImageFormatToBMP(FPath : string; BMP : TBitmap) : boolean;
//Taken from here:  http://stackoverflow.com/questions/959160/load-jpg-gif-bitmap-and-convert-to-bitmap
//Returns TRUE if OK, or FALSE if problem.
Var
  OleGraphic  : TOleGraphic;
  fs          : TFileStream;
  Source      : TImage;
  //BMP         : TBitmap;
Begin
  Result := false;  //default to failure.
  Try
    OleGraphic := TOleGraphic.Create; {The magic class!}
    Source := Timage.Create(Nil);
    fs := TFileStream.Create(FPath, fmOpenRead Or fmSharedenyNone);
    OleGraphic.LoadFromStream(fs);
    Source.Picture.Assign(OleGraphic);
    bmp.Width := Source.Picture.Width;
    bmp.Height := source.Picture.Height;
    //For some reason, this seems to make bmp's that look stretched too wide.
    bmp.Canvas.Draw(0, 0, source.Picture.Graphic);
    Result := true;
  Finally
    fs.Free;
    OleGraphic.Free;
    Source.Free;
  End;
End;


procedure ForceServerImageReQuery();
begin
  NumImagesAvailableOnServer := NOT_YET_CHECKED_SERVER;   //Forces re-query of server
end;

procedure HandlePatientChanged();
begin
  ClearImageList(DownloadQueInfoList);
end;

procedure SetActiveListBoxForImages(ListBox : TORListBox);
begin
  ActiveListBox := ListBox
end;

function ActiveTIUIENForImagesInt: int64;
begin
  Result := StrToIntDef(ActiveTIUIENForImages, 0);
end;


function ActiveTIUIENForImages: string;
begin
  Result := '0';
  if not assigned(ActiveListBox) then exit;
  if ActiveListBox.ItemID <> '' then begin
    try
      Result := IntToStr(ActiveListBox.ItemID);
    except
      //Error occurs after note is signed, and frmNotes.lstNotes.ItemID is "inaccessible"
      on E: Exception do exit;
    end;
  end;
end;

initialization
  InsideProcessDownloadCue := false;
  ActiveListBox := nil;


finalization
  ClearImageList(DownloadQueInfoList);
  DownloadQueInfoList.Free;
  EmptyCache;


end.
