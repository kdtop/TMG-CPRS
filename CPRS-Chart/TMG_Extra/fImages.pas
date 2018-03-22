unit fImages;
//kt Entire unit and form added 9/11
{$O-}
 (*
 Copyright 6/23/2015 Kevin S. Toppenberg, MD
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPage, StdCtrls, ExtCtrls, Menus, ComCtrls, ORCtrls, ORFn, uConst, ORDtTm,
  uPCE, ORClasses, fDrawers, ImgList, rTIU, uTIU, uDocTree, fRptBox, fPrintList,
  OleCtrls, SHDocVw, ShellAPI,
  VAUtils,  TMGHTML2, ActiveX,
  fImageTransferProgress, fUploadImages,
  ORNet, TRPCB, fHSplit, Buttons, ExtDlgs, VA508AccessibilityManager;

type
  TImgDelMode = (idmNone,idmDelete,idmRetract); //NOTE: DO NOT change order
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
    published
  end;

  TImgTransferMethod = (itmDropbox,itmDirect,itmRPC);
  TDownloadResult = (drSuccess, drTryAgain, drFailure, drGiveUp);

  TfrmImages = class(TfrmPage)
    mnuNotes: TMainMenu;
    mnuView: TMenuItem;
    mnuViewChart: TMenuItem;
    mnuChartReports: TMenuItem;
    mnuChartLabs: TMenuItem;
    mnuChartDCSumm: TMenuItem;
    mnuChartCslts: TMenuItem;
    mnuChartNotes: TMenuItem;
    mnuChartOrders: TMenuItem;
    mnuChartMeds: TMenuItem;
    mnuChartProbs: TMenuItem;
    mnuChartCover: TMenuItem;
    mnuAct: TMenuItem;
    Z3: TMenuItem;
    mnuOptions: TMenuItem;
    timLoadImages: TTimer;
    N3: TMenuItem;
    mnuIconLegend: TMenuItem;
    mnuChartSurgery: TMenuItem;
    ThumbsImageList: TImageList;
    CurrentNoteMemo: TMemo;
    pnlTop: TPanel;
    HorizSplitter: TSplitter;
    Splitter2: TSplitter;
    UploadImagesButton: TBitBtn;
    OpenPictureDialog: TOpenPictureDialog;
    ButtonPanel: TPanel;
    CurrentImageMemo: TMemo;
    MemosPanel: TPanel;
    UploadImagesMnuAction: TMenuItem;
    pnlBottom: TPanel;
    TabControl: TTabControl;
    WebBrowser: TWebBrowser;
    AutoScanUpload: TMenuItem;
    PickScanFolder: TMenuItem;
    OpenDialog: TOpenDialog;
    mnuPopup: TPopupMenu;
    mnuPopDeleteImage: TMenuItem;
    mnuDeleteImage: TMenuItem;
    AddUniversalImage1: TMenuItem;
    lblTextForObject: TLabel;
    AddSignatureImage: TMenuItem;
    procedure AddSignatureImageClick(Sender: TObject);
    procedure TabControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure mnuChartTabClick(Sender: TObject);
    procedure mnuActNewClick(Sender: TObject);
    procedure timLoadImagesTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuActClick(Sender: TObject);
    procedure UploadImagesButtonClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure TabControlGetImageIndex(Sender: TObject; TabIndex: Integer;
      var ImageIndex: Integer);
    procedure TabControlResize(Sender: TObject);
    procedure EnableAutoScanUploadClick(Sender: TObject);
    procedure PickScanFolderClick(Sender: TObject);
    procedure TabControlMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuPopupPopup(Sender: TObject);
    procedure mnuPopDeleteImageClick(Sender: TObject);
    procedure mnuDeleteImageClick(Sender: TObject);
    procedure AddUniversalImage1Click(Sender: TObject);
  private
    ImageInfoList : TList;
    LastDisplayedTIUIEN : AnsiString;
    ImageIndexLastDownloaded : integer;
    FDeleteImageIndex : integer;
    FEditIsActive : boolean;
    FImageDeleteMode : TImgDelMode;
    FInsideDownload : boolean;
    frmImageTransfer: TfrmImageTransfer;
    frmImageUpload: TfrmImageUpload;
    DownloadRetryCount : integer;
    procedure ExecuteFileIfNeeded(Selected: integer);
    procedure EnsureImageListLoaded();
    procedure ClearImageList();
    procedure ClearTabPages();
    procedure SetupTab(i : integer);
    procedure UpdateNoteInfoMemo();
    procedure UpdateImageInfoMemo(Rec: TImageInfo);
    function FileSize(fileName : wideString) : Int64;
    function GetImagesCount : integer;
    function GetImageInfo(Index : integer) : TImageInfo;
    procedure SetupTimer;
    function CanDeleteImages : boolean;
    function TestExtenstion(FileName: string): integer;
    procedure DeleteImageIndex(ImageIndex : integer; DeleteMode : TImgDelMode; boolPromptUser: boolean);
    procedure DeleteImage(var DeleteSts: TActionRec; ImageFileName: string; ImageIEN, DocIEN: Integer;
                          DeleteMode : TImgDelMode; const Reason: string);
    procedure GetUnlinkedImagesList(ImageInfoList: TList; ImagesInHTMLNote: TStringList);
    procedure DisplayMediaInBrowser(MediaName : string);
  public
    CacheDir : AnsiString;
    TransferMethod : TImgTransferMethod;
    DropBoxDir : string;
    NullImageName : AnsiString;
    NumImagesAvailableOnServer : integer;
    DownloadImagesInBackground : boolean;
    function GetImageForIEN(IEN: AnsiString): integer;
    function Decode(input: AnsiString) : AnsiString;
    function Encode(input: AnsiString) : AnsiString;
    function DownloadFileViaDropbox(FPath,FName,LocalSaveFNamePath: AnsiString;CurrentImage,TotalImages: Integer): TDownloadResult;
    function DownloadFile(FPath,FName,LocalSaveFNamePath: AnsiString;CurrentImage,TotalImages: Integer): TDownloadResult;
    function UploadFileViaDropBox(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
    function UploadFile(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
    procedure SplitLinuxFilePath(FullPathName : AnsiString;
                                 var Path : AnsiString;
                                 var FName : AnsiString);
    function HandleOneImageListLine(s : string) : TImageInfo;
    procedure GetImageList();
    procedure NewNoteSelected(EditIsActive : boolean);
    function CreateBarcode(MsgStr: AnsiString; ImageType: AnsiString): AnsiString;
    function DecodeBarcode(LocalFNamePath,ImageType: AnsiString): AnsiString;
    procedure EnsureImagesDownloaded(ImagesInHTMLNote : TStringList; HideProgress : boolean = false);
    procedure EnsureALLImagesDownloaded;
    function DownloadToCache(ImageIndex : integer) : TDownloadResult; overload;
    function DownloadToCache(Rec : TImageInfo; CurrentImage : integer = 1;TotalImages: Integer=2) : TDownloadResult;     overload;
    procedure DeleteAll(DeleteMode: TImgDelMode);
    property ImagesCount : integer read GetImagesCount;
    property ImageInfo[index : integer] : TImageInfo read GetImageInfo;
    procedure GetThumbnailBitmapForFName (FName : string; Bitmap : TBitmap);
    function ThumbnailIndexForFName (FName : string) : integer;
    function AllowContextChange(var WhyNot: string): Boolean;
    procedure EmptyCache();
  published
  end;

Const
  IMAGE_TRANSFER_METHODS : Array[itmDropbox..itmRPC] of string[32] = (
    'Dropbox Transfer', 'Direct Access', 'Embedded in RPCs');
  IMAGE_DOWNLOAD_DELAY_BACKGROUND = 30000;
  IMAGE_DOWNLOAD_DELAY_FOREGROUND = 100;
  NOT_YET_CHECKED_SERVER = -2;

  TX_ATTACHED_IMAGES_SERVER_REPLY = 'You must "delete" the Images using the Imaging package before proceeding.';
  DOWNLOAD_RETRY_LIMIT = 5;

  //NOTE: If order is changed in ThumbsImageList, these numbers should be changed
  IMAGE_INDEX_IMAGE = 0;
  IMAGE_INDEX_ADOBE  = 1;
  IMAGE_INDEX_VIDEO  = 2;
  IMAGE_INDEX_SOUND  = 3;
  IMAGE_INDEX_MISC   = 4;
  IMAGE_INDEX_XRAY1  = 7;
  IMAGE_INDEX_PDF    = 8;
  IMAGE_INDEX_XRAY2  = 9;
  IMAGE_INDEX_EXCEL  = 10;
  IMAGE_INDEX_WORD   = 11;
  IMAGE_INDEX_AUDIO  = 12;
  IMAGE_INDEX_MOVIE  = 13;
  IMAGE_INDEX_DCM    = 14;
  IMAGE_INDEX_MISC2  = 15;

  INSIDE_BROWSER : string = '.JPG,.JPEG,.GIF,.PNG,.TIF,.PDF';
  OUTSIDE_BROWSER : string = '.DCM,.DCM30,.AVI,.MOV,.MP4,.BMP';


var
  frmImages: TfrmImages;
  ListBox: TORListBox;
  HTMLEditor: TWebBrowser;


function LoadAnyImageFormatToBMP(FPath : string; BMP : TBitmap) : boolean;  forward;


implementation

{$R *.DFM}

uses fFrame, fVisit, fEncnt, rCore, uCore, fNoteBA, fNoteBD, fSignItem, fEncounterFrame,
     rPCE, Clipbrd, fNoteCslt, fNotePrt, rVitals, fAddlSigners, fNoteDR, fConsults, uSpell,
     fTIUView, fTemplateEditor, uReminders, fReminderDialog, uOrders, rConsults, fReminderTree,
     fNoteProps, fNotesBP, fTemplateFieldEditor, dShared, rTemplates,
     FIconLegend, fPCEEdit, fNoteIDParents, rSurgery, uSurgery, uTemplates,
     {uAccessibleTreeView, uAccessibleTreeNode,} fTemplateDialog, DateUtils,
     StrUtils, mshtml,
     uTMGOptions,  //kt 3/10/10
     AxCtrls, //kt 4/15/14
     uHTMLTools, fNotes, fImagePickExisting,
     fImagesMultiUse;  {//kt added 5-27-05 for IsHTMLDocument}


procedure TfrmImages.FormCreate(Sender: TObject);
//var i : integer;
begin
  inherited;
  frmImageUpload := TfrmImageUpload.Create(Self);
  LastDisplayedTIUIEN := '0';
  FDeleteImageIndex := -1;
  FInsideDownload := false;
  DownloadRetryCount := 0;
  ImageInfoList := TList.Create;
  ClearImageList(); //sets up other needed variables.
  DownloadImagesInBackground := true;
  //CacheDir := ExtractFilePath(ParamStr(0))+ 'Cache';
  CacheDir := GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache';
  NullImageName := 'about:blank';
  if not DirectoryExists(CacheDir) then ForceDirectories(CacheDir);

  TransferMethod := TImgTransferMethod(uTMGOptions.ReadInteger('ImageTransferMethod',2));
  DropBoxDir := uTMGOptions.ReadString('Dropbox directory','??');
  if DropBoxDir='??' then begin  //just on first run.
    uTMGOptions.WriteBool('Use dropbox directory for transfers',false);
    uTMGOptions.WriteString('Dropbox directory','');
  end;
  AutoScanUpload.Checked := uTMGOptions.ReadBool('Scan Enabled',false);
  ListBox := frmNotes.lstNotes;
end;

procedure TfrmImages.FormDestroy(Sender: TObject);
begin
  inherited;
  ClearImageList;
  ImageInfoList.Free;
  EmptyCache;
  frmImageUpload.Free;
end;

procedure TfrmImages.FormShow(Sender: TObject);
var  TIUIEN : AnsiString;
begin
  inherited;
  mnuDeleteImage.Enabled := CanDeleteImages;
  //if frmNotes.lstNotes.ItemID = '' then begin
  if ListBox.ItemID = '' then begin
    TIUIEN := '0';
  end else begin
    try
      //TIUIEN := IntToStr(frmNotes.lstNotes.ItemID);
      TIUIEN := IntToStr(ListBox.ItemID);
    except
      on E:Exception do begin
        TIUIEN := '0';
      end;
    end;
  end;
  DownloadImagesInBackground := false;
  SetupTimer;
  if LastDisplayedTIUIEN <> TIUIEN then begin
    UpdateNoteInfoMemo();
    LastDisplayedTIUIEN := TIUIEN;
  end;
end;


procedure TfrmImages.timLoadImagesTimer(Sender: TObject);
//This function's goal is to download images in the background,
// with one image to be downloaded each time the timer fires
var  Result : TDownloadResult;
begin
  inherited;
  timLoadImages.Enabled := false;
  EnsureImageListLoaded();
  if NumImagesAvailableOnServer = 0 then begin
    FreeAndNil(frmImageTransfer);
    exit;
  end;
  if (ImageIndexLastDownloaded >= (ImageInfoList.Count-1)) then exit;
  if not assigned(frmImageTransfer) then frmImageTransfer := TfrmImageTransfer.Create(Self);
  frmImageTransfer.ProgressMsg.Caption := 'Downloading Images';
  if FInsideDownload = false then begin
    Result := DownloadToCache(ImageIndexLastDownloaded+1); //Only load 1 image per timer firing.
    if Result = drTryAgain then begin
      inc (DownloadRetryCount);
      if DownloadRetryCount > DOWNLOAD_RETRY_LIMIT then begin
        Result := drGiveUp;
      end;
    end;
  end else begin
    Result := drTryAgain;
  end;
  if Result = drSuccess then SetupTab(ImageIndexLastDownloaded+1);
  if Result <> drTryAgain then Inc(ImageIndexLastDownloaded);
  if Result = drSuccess then begin
    if TabControl.TabIndex < 0 then TabControl.TabIndex := 0;
    TabControlChange(self);
  end;
  if not frmImageTransfer.UserCanceled then begin
    SetupTimer;
  end;
  DownloadRetryCount := 0;
end;

procedure TfrmImages.SetupTimer;
begin
  if DownloadImagesInBackground then begin
    timLoadImages.Interval := IMAGE_DOWNLOAD_DELAY_BACKGROUND;
  end else begin
    timLoadImages.Interval := IMAGE_DOWNLOAD_DELAY_FOREGROUND;
  end;
  timLoadImages.Enabled := true;
end;

procedure TfrmImages.GetUnlinkedImagesList(ImageInfoList: TList; ImagesInHTMLNote: TStringList);

  function FileNameInList(FileName : string):boolean;
  var i : integer;
      Rec : TImageInfo;
  begin
    result := False;
    for i := 0 to ImageInfoList.Count - 1 do begin
      Rec := TImageInfo(ImageInfoList[i]);
      if FileName = Rec.ServerFName then begin
        result := true;
        break;
      end;
    end;
  end;

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
    ImageInfo : TImageInfo;
begin
  for i  := 0 to ImagesInHTMLNote.Count - 1 do begin
    FileName := ImagesInHTMLNote[i];
    if FileNameInList(FileName) then continue;
    HashedFileName := HashFileName(FileName);   //Note: server must be set for hashed file use
    SetPiece(s,'^',3,HashedFileName);
    SetPiece(s,'^',11,'M');
    ImageInfo := HandleOneImageListLine(s);
    if ImageInfo <> nil then ImageInfoList.Add(ImageInfo);
  end;
end;

procedure TfrmImages.EnsureImagesDownloaded(ImagesInHTMLNote : TStringList; HideProgress : boolean = false);
//This function's goal is to download SOME images in the FOREground,
// But only images matching those passed in ImagesList will be downloaded;
// The intent is to only download images that have links to them in HTML source
//Thus, if note has a large amount of images attached to it, but not referenced
//  in HTML code, then they will not be downloaded here. (But will be downloaded
//  later via timLoadImagesTimer
var i : integer;
    Rec : TImageInfo;
    DownloadResult : TDownloadResult;

begin
  if ImagesInHTMLNote.Count = 0 then exit;
  GetImageList();
  GetUnlinkedImagesList(ImageInfoList,ImagesInHTMLNote);
  if ImageInfoList.Count = 0 then exit;
  if ImageInfoList.Count > 0 then begin
    if not assigned(frmImageTransfer) then frmImageTransfer := TfrmImageTransfer.Create(Self);
    frmImageTransfer.ProgressMsg.Caption := 'Downloading Images';
    frmImageTransfer.ProgressBar.Min := 0;
    frmImageTransfer.ProgressBar.Position := 0;
    frmImageTransfer.ProgressBar.Max := ImageInfoList.Count; //elh was -1
    if not HideProgress then frmImageTransfer.Show;
  end;
  timLoadImages.enabled := False;
  for i := 0 to ImageInfoList.Count-1 do begin
    frmImageTransfer.ProgressBar.Position := i;
    Rec := TImageInfo(ImageInfoList[i]);
    if ImagesInHTMLNote.IndexOf(Rec.ServerFName)>-1 then begin
      DownloadRetryCount := 0;
      Repeat
        DownloadResult := DownloadToCache(i);
        Application.ProcessMessages;
        if DownloadResult = drTryAgain then begin
          inc(DownloadRetryCount);
          if DownloadRetryCount > DOWNLOAD_RETRY_LIMIT then DownloadResult := drGiveUp;
        end;
        if frmImageTransfer.UserCanceled then break;
      until  DownloadResult <> drTryAgain;
    end;
    if frmImageTransfer.UserCanceled then break;
  end;
  SetupTimer;
  DownloadRetryCount := 0;
  FreeAndNil(frmImageTransfer);
end;

procedure TfrmImages.EnsureALLImagesDownloaded;
//This function's goal is to download ALL images in the FOREground.
var
  DownloadResult : TDownloadResult;
begin
  EnsureImageListLoaded();
  if NumImagesAvailableOnServer = 0 then exit;
  if not assigned(frmImageTransfer) then frmImageTransfer := TfrmImageTransfer.Create(Self);
  frmImageTransfer.ProgressMsg.Caption := 'Downloading Images';
  while (ImageIndexLastDownloaded < (ImageInfoList.Count-1)) do begin
    DownloadRetryCount := 0;
    Repeat
      DownloadResult := DownloadToCache(ImageIndexLastDownloaded+1);
      Application.ProcessMessages;
      if DownloadResult = drTryAgain then begin
        inc(DownloadRetryCount);
        if DownloadRetryCount > DOWNLOAD_RETRY_LIMIT then DownloadResult := drGiveUp;
      end;
      if frmImageTransfer.UserCanceled then DownloadResult := drGiveUp;
    until DownloadResult <> drTryAgain;
    if DownloadResult <> drGiveUp then begin
      SetupTab(ImageIndexLastDownloaded+1);
      if TabControl.TabIndex < 0 then TabControl.TabIndex := 0;
      TabControlChange(self);
    end;
    Inc(ImageIndexLastDownloaded);
  end;
end;

{ TPage common methods --------------------------------------------------------------------- }
procedure TfrmImages.mnuChartTabClick(Sender: TObject);
{ reroute to Chart Tab menu of the parent form: frmFrame }
begin
  inherited;
  frmFrame.mnuChartTabClick(Sender);
end;


procedure TfrmImages.mnuActNewClick(Sender: TObject);
const
  IS_ID_CHILD = False;
{ switches to current new note or creates a new note if none is being edited already }
begin
  inherited;
end;

procedure TfrmImages.mnuActClick(Sender: TObject);
begin
  inherited;

end;

{ General procedures ----------------------------------------------------------------------- }

procedure TfrmImages.UpdateImageInfoMemo(Rec : TImageInfo);
var s : AnsiString;
    i : integer;
begin
  CurrentImageMemo.Lines.Clear;
  if Rec=nil then exit;
  s := Trim(Rec.ShortDesc);
  if s <> '' then CurrentImageMemo.Lines.Add('Description: ' + s);
  s := Rec.ProcName;
  if s <> '' then CurrentImageMemo.Lines.Add('Procedure: ' + s);
  s := Rec.DisplayDate;
  if s <> '' then CurrentImageMemo.Lines.Add('Upload Date: ' + s);
  //s := Rec.DateTime;
  //if s <> '' then CurrentImageMemo.Lines.Add('Date/Time: ' + s);
  if Rec.LongDesc <> nil then begin
    CurrentImageMemo.Lines.Add('Long Description:');
    for i := 0 to Rec.LongDesc.Count-1 do begin
      CurrentImageMemo.Lines.Add('  ' + Rec.LongDesc.Strings[i]);
    end;
  end;
end;


procedure TfrmImages.UpdateNoteInfoMemo();
var
  NoteInfo,s : AnsiString;
  //dateS      : AnsiString;
const
  U='^';
begin
  CurrentNoteMemo.Lines.Clear;
  //with frmNotes.lstNotes do begin
  with ListBox do begin
    if ItemIndex > -1 then begin
      NoteInfo := Items[ItemIndex]
      (* example NoteInfo:
        piece# 1:  14321^                        //TIU IEN
        piece# 2:  PRESCRIPTION CALL IN^         //Document Title
        piece# 3:  3050713.0947^                 //Date/Time
        piece# 4:  TEST, KILLME D (T0101)^       //Patient
        piece# 5:  133;JANE A DOE;DOE,JANE A^    //Author
        piece# 6:  Main_Office^                  //Location of Visit
        piece# 7:  completed^                    //Status of Document
        piece# 8:  Visit: 07/13/05;3050713.094721^ //Date/Time
        piece# 9...:          ;^^1^^^1^'         //?
      *)
    end else NoteInfo := '';
  end;
  if NoteInfo <>'' then begin
    s := Piece(NoteInfo, U, 2) + ' -- ';
    s := s + Piece(Piece(NoteInfo, U, 8), ';', 1);
    CurrentNoteMemo.Lines.Add(s);
    s := 'Location: ' + Piece(NoteInfo, U, 6) + ' -- ';
    s := s + 'Note Author: ' + Piece(Piece(NoteInfo, U, 5), ';', 2);
    CurrentNoteMemo.Lines.Add(s);
  end;
end;

procedure TfrmImages.SetupTab(i : integer);
//i is index in ImageInfoList (array of TImageInfo's)
var
  Rec  : TImageInfo; //this will be a copy of record, not pointer (I think)
  Bitmap : TBitmap;
  index : integer;
  //Ext : AnsiString;

  (*Notice: A TabControl doesn't directly support specifying which
           images in an ImageList to show for a given tab.  To get
          around this, the help documentation recommends setting up
         a TabControlGetImageIndex event handler.
        I am doing this.  When the event is called, then RecInfo.TabImageIndex
       is returned.
  *)

begin
  if i < ImageInfoList.Count then begin
    Rec := TImageInfo(ImageInfoList[i]);
    if (Rec.TabImageIndex < 1) then begin
      if FileExists(Rec.CacheThumbFName) then begin
        Bitmap := TBitmap.Create;
        Bitmap.Width := 1024;    //something big enough to hold any thumbnail.
        Bitmap.Height := 768;
        Bitmap.LoadFromFile(Rec.CacheThumbFName);
        Bitmap.Width := ThumbsImageList.Width;  //shrinkage crops image
        Bitmap.Height := ThumbsImageList.Height;
        index := ThumbsImageList.Add(Bitmap,nil);
        //TImageInfo(ImageInfoList[i]).TabImageIndex := index;
        Rec.TabImageIndex := index;
        Bitmap.Free;
      end else begin
        Rec.TabImageIndex := ThumbnailIndexForFName(Rec.CacheFName);
      end;
    end;
    TabControl.Tabs.Add(' ');  //add the tab.  Thumbnail should exist before this
  end;
end;

function TfrmImages.ThumbnailIndexForFName (FName : string) : integer;
var
  //index : integer;
  Ext : AnsiString;
begin
  Result := 4; //default
  Ext := LowerCase(ExtractFileExt(FName));
  Ext := MidStr(Ext,2,99);
  if   (Ext='jpg')
    or (Ext='jpeg')
    or (Ext='png')
    or (Ext='tif')
    or (Ext='tiff')
    or (Ext='gif')
    or (Ext='bmp') then begin
      Result := IMAGE_INDEX_IMAGE; //camera image
  end else
  if   (Ext='pdf') then begin
      Result := IMAGE_INDEX_PDF; //adobe icon
  end else
  if   (Ext='avi')
    or (Ext='qt')
    or (Ext='mpg')
    or (Ext='mp4')
    or (Ext='mpeg') then begin
      Result := IMAGE_INDEX_MOVIE; //video icon
  end else
  if   (Ext='mp3')
    or (Ext='wma')
    or (Ext='au')
    or (Ext='wav') then begin
      Result := IMAGE_INDEX_AUDIO; //sound icon
  end else
  if   (Ext='doc')
    or (Ext='docx')
    or (Ext='rtf') then begin
      Result := IMAGE_INDEX_WORD; //word icon
  end else
  if   (Ext='xls')
    or (Ext='csv') then begin
      Result := IMAGE_INDEX_EXCEL; //excel icon
  end else
  if   (Ext='dcm')
    or (Ext='dcm30') then begin
      Result := IMAGE_INDEX_XRAY1; //dicon icon
  end else
  begin
    Result := IMAGE_INDEX_MISC2; // misc icon
  end;
end;


procedure TfrmImages.GetThumbnailBitmapForFName (FName : string; Bitmap : TBitmap);
var index: integer;
begin
  index := ThumbnailIndexForFName(FName);
  Bitmap.Canvas.FillRect(Rect(0,0,Bitmap.Height,Bitmap.Width));
  ThumbsImageList.GetBitmap(index,Bitmap);
end;


procedure TfrmImages.ClearTabPages();
begin
  TabControl.Tabs.Clear;
  ClearImageList();
end;


procedure TfrmImages.ClearImageList();
//Note: !! This should also clear any visible images/thumbnails etc.
//Note: Need to remove thumbnail image from image list.
var i    : integer;
begin
  for i := ImageInfoList.Count-1 downto 0 do begin
    if TImageInfo(ImageInfoList[i]).LongDesc <> nil then begin
      TImageInfo(ImageInfoList[i]).LongDesc.Free;
    end;
    try
      TImageInfo(ImageInfoList[i]).Free;
    except
      On E: Exception do begin
      end;
    end;
    ImageInfoList.Delete(i);
  end;
  NumImagesAvailableOnServer := NOT_YET_CHECKED_SERVER;
  ImageIndexLastDownloaded := -1;
end;


procedure TfrmImages.EnsureImageListLoaded();
begin
  if NumImagesAvailableOnServer = NOT_YET_CHECKED_SERVER then begin
    GetImageList();
  end;
end;

function TfrmImages.HandleOneImageListLine(s : string) : TImageInfo;
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
  //ImageInfoList.Add(Rec);  // ImageInfoList will own Rec.
  //Result := Rec;
  //exit;

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
  Result := Rec;

end;

function TfrmImages.GetImageForIEN(IEN: AnsiString): integer;
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
    s :=BrokerResults.Strings[i];
    if i=0 then begin
      if piece(s,'^',1)='0' then break //i.e. abort due to error signal
      else continue;   //ignore rest of header (record #0)
    end;
    Rec := HandleOneImageListLine(s);
    if Rec = nil then continue;

    ImageInfoList.Add(Rec);  // ImageInfoList will own Rec.
  end;
  Result := ImageInfoList.Count;
  BrokerResults.Free;
end;

procedure TfrmImages.GetImageList();
//Sets up ImageInfoList
var
  TIUIEN : AnsiString;
  i  : integer;
  //j : integer;
  //s2 : AnsiString;
  //ImageIEN : integer;
  //ServerFName : AnsiString;
  //ServerPathName : AnsiString;
  //ImageFPathName :     AnsiString;  //path on server of image  -- original data provided by server
  //ThumbnailFPathName : AnsiString;  //path on server of thumbnail -- original data provided by server
  AddendumList: TStringList;

begin
  inherited;
  AddendumList := TStringList.Create;
  ClearImageList;
  //if frmNotes.lstNotes.ItemID = '' then begin
  if ListBox.ItemID = '' then begin
    TIUIEN := '0';
  end else begin
    try
      //TIUIEN := IntToStr(frmNotes.lstNotes.ItemID);
      TIUIEN := IntToStr(ListBox.ItemID);
    except
      //Error occurs after note is signed, and frmNotes.lstNotes.ItemID is "inaccessible"
      on E: Exception do exit;
    end;
  end;
  StatusText('Retrieving images information...');
  NumImagesAvailableOnServer := GetImageForIEN(TIUIEN);
  //Get all images for addendums now
  CallV('TMG GET NOTE ADDENDUMS', [TIUIEN]);
  AddendumList.Assign(RPCBrokerV.Results);
  for i:=1 to AddendumList.count-1 do begin
    NumImagesAvailableOnServer := GetImageForIEN(AddendumList[i]);
  end;
  StatusText('');
  AddendumList.Free;
end;

//OLD GetImagesList below   6/19/13
//procedure TfrmImages.GetImageList();
//Sets up ImageInfoList
//var
//  i  : integer;
//  Rec  : TImageInfo;
//  s : string;
//  TIUIEN : AnsiString;
//  BrokerResults: TStringList;
  //elh{
//  j : integer;
//  s2 : AnsiString;
//  ImageIEN : integer;
//  ServerFName : AnsiString;
//  ServerPathName : AnsiString;
//  ImageFPathName :     AnsiString;  //path on server of image  -- original data provided by server
//  ThumbnailFPathName : AnsiString;  //path on server of thumbnail -- original data provided by server
  //elh}

//begin
//  inherited;
//  ClearImageList;
//  if frmNotes.lstNotes.ItemID = '' then begin
//    TIUIEN := '0';
//  end else begin
//    try
//      TIUIEN := IntToStr(frmNotes.lstNotes.ItemID);
//    except
      //Error occurs after note is signed, and frmNotes.lstNotes.ItemID is "inaccessible"
//      on E: Exception do exit;
//    end;
//  end;
//  StatusText('Retrieving images information...');
//  CallV('MAG3 CPRS TIU NOTE', [TIUIEN]);
//  BrokerResults := TStringList.Create;
//  BrokerResults.Assign(RPCBrokerV.Results);
//  for i:=0 to (BrokerResults.Count-1) do begin
//    s :=BrokerResults.Strings[i];
//    if i=0 then begin
//      if piece(s,'^',1)='0' then break //i.e. abort due to error signal
//      else continue;   //ignore rest of header (record #0)
//    end;
//    Rec := HandleOneImageListLine(s);
//    if Rec = nil then continue;
    {
    if Pos('-1~',s)>0 then continue;  //abort if error signal.
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
    //elh}
//    ImageInfoList.Add(Rec);  // ImageInfoList will own Rec.
//  end;
  {
  for i:= 0 to ImageInfoList.Count-1 do begin
    Rec := TImageInfo(ImageInfoList.Items[i]);
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
  end;
  }
//  StatusText('');
// NumImagesAvailableOnServer := ImageInfoList.Count;
//  BrokerResults.Free;
//end;

Function TfrmImages.DownloadToCache(Rec : TImageInfo; CurrentImage : integer = 1;TotalImages: Integer=2) : TDownloadResult;
//Loads image specified in Rec to Cache (unless already present)
var
  ServerFName : AnsiString;
  ServerPathName : AnsiString;
  R1,R2 : TDownloadResult;

begin
  if FInsideDownload then begin
    Result := drTryAgain;
    Exit;
  end;
  try
    FInsideDownload := true;
    //timLoadImages.enabled := False;
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
      R2 := DownloadFile(ServerPathName,ServerFName,Rec.CacheThumbFName,CurrentImage+1,TotalImages);
    end;
    Application.ProcessMessages;
    if (R1 = drFailure) or (R2 = drFailure) then begin
      Result := drFailure;
    end else if (R1 = drTryAgain) or (R2 = drTryAgain) then begin
      Result := drTryAgain;
    end else begin
      Result := drSuccess;
    end;
    //SetupTimer;
  finally
    FInsideDownload := false;
  end;
end;

Function TfrmImages.DownloadToCache(ImageIndex : integer) : TDownloadResult;
//Loads image specified in ImageInfoList to Cache (unless already present)
var
  Rec : TImageInfo;
begin
  Rec := TImageInfo(ImageInfoList[ImageIndex]);
  Result := DownloadToCache(Rec,(ImageIndex*2)-1,ImageInfoList.Count*2);
end;


procedure TfrmImages.SplitLinuxFilePath(FullPathName : AnsiString;
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


function TfrmImages.UploadFileViaDropBox(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
var
  DropboxFile : AnsiString;
begin
  //First copy LocalFileNamePath --> DropBox\FileName
  DropboxFile := ExcludeTrailingBackslash(DropboxDir) + '\' + FName;
  if CopyFile(pchar(LocalFNamePath),pchar(DropboxFile),false)=false then begin
    MessageDlg('Dropbox file transfer failed.  Code='+InttoStr(GetLastError),
               mtError,[mbOK],0);
    result := false;
    exit;
  end;

  CallV('TMG UPLOAD FILE DROPBOX', [FPath,FName]);     //Move file into dropbox.
  {
  RPCBrokerV.ClearParameters := true;
  RPCBrokerV.remoteprocedure := 'TMG UPLOAD FILE DROPBOX';
  RPCBrokerV.param[0].PType := literal;
  RPCBrokerV.param[0].Value := FPath;
  RPCBrokerV.Param[1].PType := literal;
  RPCBrokerV.Param[1].Value := FName;
  RPCBrokerV.Param[2].PType := literal;
  RPCBrokerV.Param[2].Value := '1'; //see comments in UploadFile re '1' hardcoding

  CallBroker; //Move file into dropbox.
  }
  if RPCBrokerV.Results.Count>0 then begin
    Result := (Piece(RPCBrokerV.Results[0],'^',1)='1');  //1=success, 0=failure
  end else Result := false;
end;


function TfrmImages.UploadFile(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
const
  RefreshInterval = 500;
  BlockSize = 512;

var
  ReadCount                     : Word;
  totalReadCount                : Integer;
  ParamIndex                    : LongWord;
  j                             : word;
  InFile                        : TFileStream;
  LocalOutFile                  : TFileStream;
  Buffer                        : array[0..1024] of byte;
  RefreshCountdown              : integer;
  OneLine                       : AnsiString;
  RPCResult                     : AnsiString;
  SavedCursor                   : TCursor;
  ErrorMsg                      : string;
  Aborted                       : boolean;

begin
  result := false;  //default of failure
  if not FileExists(LocalFNamePath) then exit;
  if TransferMethod = itmDropbox then begin
    Result := UploadFileViaDropBox(LocalFNamePath,FPath,FName,CurrentImage,TotalImages);
    exit;
  end;
  if not assigned(frmImageTransfer) then frmImageTransfer := TfrmImageTransfer.Create(Self);
  //LATER add support for itmDirect mode
  try
    InFile := TFileStream.Create(LocalFNamePath,fmOpenRead or fmShareCompat);
    LocalOutFile := TFileStream.Create(CacheDir+'\'+FName,fmCreate or fmOpenWrite); //for local copy
    //Note: I may well cut this out.  Most of the delay occurs during
    // the RPC call, and I can't make a progress bar change during that...
    // (or I could, but I'm not going to change the RPC broker...)
    frmImageTransfer.setMax(InFile.Size);
    frmImageTransfer.ProgressMsg.Caption := 'Preparing to upload...';
    frmImageTransfer.Show;
    totalReadCount := 0;
  except
    // catch failure here...  on eError...
    FreeAndNil(frmImageTransfer);
    exit;
  end;

  StatusText('Uploading full image...');
  Application.ProcessMessages;
  Aborted := false;
  try
    RPCBrokerV.remoteprocedure := 'TMG UPLOAD FILE';
    RPCBrokerV.ClearParameters := true;
    RPCBrokerV.Param[0].PType := literal;
    RPCBrokerV.Param[0].Value := FPath;
    RPCBrokerV.Param[1].PType := literal;
    RPCBrokerV.Param[1].Value := FName;
    RPCBrokerV.Param[2].PType := literal;
    RPCBrokerV.Param[2].Value := ''; //kt 7/11/10  was '1'; //Specifying a NETWORK LOCATION is now depreciated.

    RPCBrokerV.Param[3].PType := list;
    ParamIndex := 0;
    RefreshCountdown := RefreshInterval;
    repeat
      ReadCount := InFile.Read(Buffer,BlockSize);
      LocalOutFile.Write(Buffer,ReadCount); //for local copy
      totalReadCount := totalReadCount + ReadCount;
      frmImageTransfer.updateProgress(totalReadCount);
      OneLine := '';
      if ReadCount > 0 then begin
        SetLength(OneLine,ReadCount);
        for j := 1 to ReadCount do OneLine[j] := char(Buffer[j-1]);
        RPCBrokerV.Param[3].Mult[IntToStr(ParamIndex)] := Encode(OneLine);
        Inc(ParamIndex);

        Dec(RefreshCountdown);
        if RefreshCountdown < 1 then begin
          Application.ProcessMessages;
          RefreshCountdown := RefreshInterval;
        end;
      end;
      Aborted := frmImageTransfer.UserCanceled;
      if Aborted then break;
    until (ReadCount < BlockSize);

    SavedCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    frmImageTransfer.ProgressMsg.Caption := 'Uploading file to server...';
    Application.ProcessMessages;

    if not Aborted then CallBroker;
  finally
    //
  end;
  Screen.Cursor := SavedCursor;
  //elh  NOTE TO SELF
  //Why aren't there any results here? The UPLOAD^TMGRPC1C clearly returns RESLTMSG.
  //Recheck all variables and the RPC call itself to ensure that the Result is set
  //properly
  if Aborted then RPCBrokerV.Results.Clear;
  if RPCBrokerV.Results.Count > 0 then begin
    RPCResult := RPCBrokerV.Results[0];
  end else RPCResult := '';
  result := (Piece(RPCResult,'^',1)='1');
  FreeAndNil(frmImageTransfer);
  //frmImageTransfer.Hide;
  if (result=false) and not Aborted then begin
    ErrorMsg := 'Error uploading file.' + #13 + Piece(RPCResult,'^',2);
    MessageDlg(ErrorMsg,mtWarning,[mbOK],0);
  end;

  InFile.Free;
  LocalOutFile.Free;
  StatusText('');
end;


function TfrmImages.DownloadFileViaDropbox(FPath,FName,LocalSaveFNamePath: AnsiString;
                                           CurrentImage,TotalImages: Integer): TDownloadResult;
var
  DropboxFile : AnsiString;
  CurrentFileSize : Integer;
  ErrMsg          : string;
  bResult         : boolean;
begin
  CallV('TMG DOWNLOAD FILE DROPBOX', [FPath,FName]);  //Move file into dropbox.
  if RPCBrokerV.Results.Count > 0 then begin
    bResult := (Piece(RPCBrokerV.Results[0],'^',1)='1');  //1=success, 0=failure
    if bResult = false then ErrMsg := Piece(RPCBrokerV.Results[0],'^',2);
  end else begin
    bResult := false;
    ErrMsg := 'Error communicating with server to retrieve image.';
  end;

  if not assigned(frmImageTransfer) then frmImageTransfer := TfrmImageTransfer.Create(Self);
  if bResult=true then begin
    if DirectoryExists(DropboxDir) then begin
      CurrentFileSize := strtoint(Piece(RPCBrokerV.Results[0],'^',3));  //Piece 3 = file size
      DropboxFile := ExcludeTrailingBackslash(DropboxDir) + '\' + FName;
      if frmImageTransfer.visible = False then frmImageTransfer.show;
      while FileSize(DropboxFile) <> CurrentFileSize do begin
        sleep(1000);
        //CHANGE: If file never transfers, this will hang for ever.  Needs timeout code added.
      end;
      frmImageTransfer.ProgressBar.Max := TotalImages;
      frmImageTransfer.ProgressBar.Position := CurrentImage+2;
      if TotalImages = (CurrentImage+2) then begin
        Sleep(1000);
        frmImageTransfer.hide;
      end;
      //Now move DropBox\FileName --> LocalFileNamePath
      if MoveFile(pchar(DropboxFile),pchar(LocalSaveFNamePath))=false then begin
        MessageDlg('Dropbox file transfer failed.  Code='+InttoStr(GetLastError),
                   mtError,[mbOK],0);
      end;
    end else begin
      MessageDlg('Invalid Dropbox Directory. Please check your settings and try again.',mtError,[mbOK],0);
      //frmImageTransfer.hide;
      Result := drFailure;
    end;
  end else begin
    MessageDlg('ERROR: '+ErrMsg,mtError,[mbOK],0);
  end;
  if bResult = false then Result := drFailure
  else Result := drSuccess;
  FreeAndNil(frmImageTransfer);
end;


function TfrmImages.DownloadFile(FPath,FName,LocalSaveFNamePath: AnsiString;
                                 CurrentImage,TotalImages: Integer): TDownloadResult;
var
  i,count                       : integer;
  j                             : word;
  OutFile                       : TFileStream;
  s                             : AnsiString;
  Buffer                        : array[0..1024] of byte;
  RefreshCountdown              : integer;
  bResult                       : boolean;
  BrokerResult                  : string;
  ErrMsg                        : string;

const
  RefreshInterval = 500;

begin
  frmFrame.timSchedule.Enabled := false;      //12/1/17 added timSchedule enabler to keep it from crashing the RPC download
  if FileExists(LocalSaveFNamePath) then begin
    DeleteFile(LocalSaveFNamePath);
  end;
  if TransferMethod = itmDropbox then begin
    Result := DownloadFileViaDropBox(FPath,FName,LocalSaveFNamePath,CurrentImage,TotalImages);
    exit;
  end;
  //LATER add support for itmDirect mode
  //kt   Result := drTryAgain;
  //kt   exit;
  //kt end;
  bResult := true; //default to success;
  ErrMsg := '';
  StatusText('Retrieving full image...');
  //Application.ProcessMessages;      //elh moved up a line because it was throwing the Broker out of sync
  CallV('TMG DOWNLOAD FILE', [FPath,FName]);
  RefreshCountdown := RefreshInterval;
  //Note:RPCBrokerV.Results[0]=1 if successful load, =0 if failure
  if RPCBrokerV.Results.Count=0 then RPCBrokerV.Results.Add('-1^Unknown download error.');
  BrokerResult := RPCBrokerV.Results[0];
  if Piece(BrokerResult,'^',1)='1' then begin
    OutFile := TFileStream.Create(LocalSaveFNamePath,fmCreate);
    for i:=1 to (RPCBrokerV.Results.Count-1) do begin
      s :=Decode(RPCBrokerV.Results[i]);
      count := Length(s);
      if count>1024 then begin
        bResult := false; //failure of load.
        break;
      end;
      for j := 1 to count do Buffer[j-1] := ord(s[j]);
      OutFile.Write(Buffer,count);
      Dec(RefreshCountdown);
      if RefreshCountdown < 1 then begin
        Application.ProcessMessages;
        RefreshCountdown := RefreshInterval;
      end;
    end;
    OutFile.Free;
  end else begin
    ErrMsg := Piece(BrokerResult,'^',2);
    bresult := false;
  end;
  StatusText('');
  if ErrMsg <> '' then begin
    MessageDlg('ERROR: '+ErrMsg,mtError,[mbOK],0);
  end;
  if bResult = false then Result := drFailure
  else Result := drSuccess;
  frmFrame.timSchedule.Enabled := true;      //12/1/17 added timSchedule enabler to keep it from crashing the RPC download
end;


function TfrmImages.Encode(Input: AnsiString) : AnsiString;
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


function TfrmImages.Decode(Input: AnsiString) : AnsiString;
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

procedure TfrmImages.NewNoteSelected(EditIsActive : boolean);
//Will be called by  fNotes when a new note has been selected.
//var
begin
  ClearTabPages();
  DownloadImagesInBackground := true;
  SetupTimer;
  //This will start downloading images after few second delay (so that if
  //user is just browsing past note, this won't waste effort.
  //If user selects images tab, then load will occur without delay.
  //Note: OnTimer calls timLoadImagesTimer()
  FEditIsActive := EditIsActive;
  UploadImagesButton.Enabled := EditIsActive;
  UploadImagesMnuAction.Enabled := EditIsActive;
  DisplayMediaInBrowser(NullImageName);
end;


procedure TfrmImages.EmptyCache();
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

procedure TfrmImages.UploadImagesButtonClick(Sender: TObject);
var
  Node: TORTreeNode;
  AddResult : TModalResult;

begin
  inherited;
  AddResult := frmImageUpload.ShowModal;
  if not IsAbortResult(AddResult) then begin
    NewNoteSelected(true);  //force a reload to show recently added image.
    timLoadImages.Interval := IMAGE_DOWNLOAD_DELAY_FOREGROUND;
    DownloadImagesInBackground := false;
    SetupTimer;
    Node := TORTreeNode(frmNotes.tvNotes.Selected);
    case Node.StateIndex of
      IMG_NO_IMAGES         :  Node.StateIndex := IMG_1_IMAGE;
      IMG_1_IMAGE           :  Node.StateIndex := IMG_2_IMAGES;
      IMG_2_IMAGES          :  Node.StateIndex := IMG_MANY_IMAGES;
      IMG_MANY_IMAGES       :  Node.StateIndex := IMG_MANY_IMAGES;
    end;
  end;
end;

procedure TfrmImages.FormHide(Sender: TObject);
begin
  inherited;
  DownloadImagesInBackground := true;

//  Application.MessageBox('Here I can hide images.','title');
end;

procedure TfrmImages.TabControlChange(Sender: TObject);
var
  FileName : AnsiString;
  Rec  : TImageInfo;
  Selected : integer;
  FileAction : integer;
  //ExecuteFile : string;
  //ParamString: string;
begin
  inherited;
  //here tab has been changed.
  Selected := TabControl.TabIndex;
  if Selected > -1 then begin
    Rec := TImageInfo(ImageInfoList[Selected]);
    FileName := Rec.CacheFName;
    UpdateImageInfoMemo(Rec);
  end else begin
    FileName := NullImageName;
    UpdateImageInfoMemo(nil);
  end;
  //Test File Type, if ext is web based(1), pass to WebBrowser
  FileAction := TestExtenstion(FileName);
  if FileAction = 1 then begin
    DisplayMediaInBrowser(FileName);
  end else if FileAction = 2 then begin
    DisplayMediaInBrowser(NullImageName);
  end else begin
    DisplayMediaInBrowser(NullImageName);
  end;
end;

procedure TfrmImages.DisplayMediaInBrowser(MediaName : string);

    {procedure WBLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string) ;
    var
       sl: TStringList;
       ms: TMemoryStream;
    begin
       WebBrowser.Navigate('about:blank') ;
       while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
        Application.ProcessMessages;

       if Assigned(WebBrowser.Document) then
       begin
         sl := TStringList.Create;
         try
           ms := TMemoryStream.Create;
           try
             sl.Text := HTMLCode;
             sl.SaveToStream(ms) ;
             ms.Seek(0, 0) ;
             (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms)) ;
           finally
             ms.Free;
           end;
         finally
           sl.Free;
         end;
       end;
    end;    }
    procedure WBLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string) ;
    var
       MyHTML: TStringList;
       TempFile: string;
    begin
       MyHTML := TStringList.create;
       //TempFile := ExtractFilePath(ParamStr(0))+ 'Cache'+'\Temp.html';
       TempFile := GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache\Temp.html';
       try
         MyHTML.add(HTMLCode);
         MyHTML.SaveToFile(TempFile);
        finally
         MyHTML.Free;
        end;
       WebBrowser.Navigate(TempFile) ;

       while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
        Application.ProcessMessages;
    end;  {WBLoadHTML}




    function GetHTMLText(TextArray : TStrings) : string;
    var i : integer;
    begin
      for i := 1 to TextArray.Count - 1 do begin
        result := result + TextArray[i];
      end;
    end;

var  HTMLWrapper : TStringList;
begin
  HTMLWrapper := TStringList.Create;
  if MediaName = NullImageName then begin
    WebBrowser.Navigate(NullImageName);
  end else begin
    //CallV('TMG CPRS IMAGES TAB HTML',[MediaName]);

    with RPCBrokerV do begin
      ClearParameters := True;
      RemoteProcedure := 'TMG CPRS IMAGES TAB HTML';
      Param[0].PType := list;
      with Param[0] do begin
        Mult['0'] := MediaName; //add loop when ready for multiple images
      end;
      CallBroker;
    end;

    if RPCBrokerV.Results[0]='0' then begin
      WebBrowser.Navigate(MediaName);
    end else if RPCBrokerV.Results[0]='1' then begin
      RPCBrokerV.Results.Delete(0);
      WBLoadHTML(WebBrowser,GetHTMLText(RPCBrokerV.Results));
    end else begin
      ShowMessage(Piece(RPCBrokerV.Results[0],'^',2));
    end;
  end;
  HTMLWrapper.free;
end;


function TfrmImages.TestExtenstion(FileName: string): integer;

var
   FileExt : string;
begin
//Eddie Finish Here
   FileExt := UpperCase(ExtractFileExt(FileName));
   if Pos(FileExt,INSIDE_BROWSER)>0 then
     Result := 1
   else if Pos(FileExt,OUTSIDE_BROWSER)>0 then
     Result := 2
   else
     Result := 3;
end;

procedure TfrmImages.TabControlGetImageIndex(Sender: TObject;
                                             TabIndex: Integer;
                                             var ImageIndex: Integer);
//specify which image to display, from ThumbsImageList
begin
  inherited;
  if (ImageInfoList <> nil) and (TabIndex < ImageInfoList.Count) then begin
    ImageIndex := TImageInfo(ImageInfoList[TabIndex]).TabImageIndex;
  end else ImageIndex := 0;
end;

procedure TfrmImages.TabControlResize(Sender: TObject);
begin
  inherited;
  if TabControl.Width < 80 then begin
    TabControl.Width := 80;
  end;
end;

function TfrmImages.CreateBarcode(MsgStr: AnsiString; ImageType: AnsiString): AnsiString;
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

begin
  StatusText('Getting Barcode...');
  LocalSaveFNamePath := UniqueFName;
  Result := LocalSaveFNamePath;  //default to success;

  // CallV('TMG BARCODE ENCODE', [MsgStr]);
  RPCBrokerV.ClearParameters := true;
  RPCBrokerV.remoteprocedure := 'TMG BARCODE ENCODE';
  RPCBrokerV.param[0].Value := MsgStr;
  RPCBrokerV.param[0].PType := literal;
  RPCBrokerV.Param[1].Value := '.X';  //<-- is this needed or used?
  RPCBrokerV.Param[1].PType := list;
  RPCBrokerV.Param[1].Mult['"IMAGE TYPE"'] := ImageType;
  //RPCBrokerV.Call;
  CallBroker;

  Application.ProcessMessages;
  //Note:RPCBrokerV.Results[0]=1 if successful load, =0 if failure
  if (RPCBrokerV.Results.Count>0) and (RPCBrokerV.Results[0]='1') then begin
    OutFile := TFileStream.Create(LocalSaveFNamePath,fmCreate);
    for i:=1 to (RPCBrokerV.Results.Count-1) do begin
      s :=Decode(RPCBrokerV.Results[i]);
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
  StatusText('');
end;


function TfrmImages.DecodeBarcode(LocalFNamePath,ImageType: AnsiString): AnsiString;
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
  if not assigned(frmImageTransfer) then frmImageTransfer := TfrmImageTransfer.Create(Self);
  Abort := false;
  RPCResult := '';
  try
    InFile := TFileStream.Create(LocalFNamePath,fmOpenRead or fmShareCompat);
    //Note: I may well cut this out.  Most of the delay occurs during
    // the RPC call, and I can't make a progress bar change during that...
    // (or I could, but I'm not going to change the RPC broker...)
    frmImageTransfer.setMax(InFile.Size);
    //frmImageTransfer.ResetStartTime;
    frmImageTransfer.ProgressMsg.Caption := 'Preparing to upload...';
    frmImageTransfer.Show;
    totalReadCount := 0;
  except
    // catch failure here...  on eError...
    exit;
  end;

  StatusText('Checking image for barcodes...');
  Application.ProcessMessages;

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
    frmImageTransfer.updateProgress(totalReadCount);
    if ReadCount > 0 then begin
      SetLength(OneLine,ReadCount);
      for j := 1 to ReadCount do OneLine[j] := char(Buffer[j-1]);
      RPCBrokerV.Param[0].Mult[IntToStr(ParamIndex)] := Encode(OneLine);
      Inc(ParamIndex);
      Dec(RefreshCountdown);
      if RefreshCountdown < 1 then begin
        Application.ProcessMessages;
        RefreshCountdown := RefreshInterval;
      end;
    end;
    Abort := frmImageTransfer.UserCanceled;
    if Abort then break;
  until (ReadCount < BlockSize);
  RPCBrokerV.Param[1].PType := literal;
  RPCBrokerV.Param[1].Value := ImageType;

  RPCBrokerV.remoteprocedure := 'TMG BARCODE DECODE';

  SavedCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  frmImageTransfer.ProgressMsg.Caption := 'Uploading file to server...';
  Application.ProcessMessages;

  if not Abort then begin
    CallBroker;  //this is the slow step, pass to server and get response.
  end else begin
    RPCBrokerV.Results.Clear;
  end;
  Screen.Cursor := SavedCursor;
  frmImageTransfer.Hide;
  //Get result: 1^DecodedMessage, or 0^Error Message
  if RPCBrokerV.Results.Count > 0 then RPCResult := RPCBrokerV.Results[0];
  if Piece(RPCResult,'^',1)='0' then begin
    MessageDlg(Piece(RPCResult,'^',2),mtError,[mbOK],0);
  end else begin
    result := Piece(RPCResult,'^',2);
  end;
  InFile.Free;
  StatusText('');
end;


procedure TfrmImages.EnableAutoScanUploadClick(Sender: TObject);
begin
  inherited;
  AutoScanUpload.Checked := not AutoScanUpload.Checked;
  uTMGOptions.WriteBool('Scan Enabled',AutoScanUpload.Checked);
end;


procedure TfrmImages.PickScanFolderClick(Sender: TObject);
var
  CurScanDir : string;

begin
  inherited;
  CurScanDir := frmImageUpload.ScanDir;
  OpenDialog.InitialDir := CurScanDir;
  MessageDlg('Please pick ANY file in the desired directory.',mtInformation,[mbOK],0);
  if OpenDialog.Execute then begin
    frmImageUpload.SetScanDir(ExtractFilePath(OpenDialog.FileName));
  end;
  AutoScanUpload.Checked := true;
end;

function TfrmImages.FileSize(fileName : wideString) : Int64;
var
  sr : TSearchRec;
begin
  if FindFirst(fileName, faAnyFile, sr ) = 0 then
     result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) +  Int64(sr.FindData.nFileSizeLow)
  else
     result := -1;

  FindClose(sr) ;
end;

function TfrmImages.GetImagesCount : integer;
//Returns number of images possible, not just those already downloaded.
begin
  EnsureImageListLoaded();
  Result := NumImagesAvailableOnServer;
end;

function TfrmImages.GetImageInfo(Index : integer) : TImageInfo;
begin
  if (Index > -1) and (Index < ImageInfoList.Count) then begin
    Result := TImageInfo(ImageInfoList[Index]);
  end else begin
    Result := nil;
  end;
end;

procedure TfrmImages.ExecuteFileIfNeeded(Selected: integer);
var
  FileName : AnsiString;
  Rec  : TImageInfo;
  //FileAction : integer;
  //SEInfo: TShellExecuteInfo;
  //ExitCode: DWord;
  //ExecuteFile, ParamString: string;
begin
  inherited;
  if Selected > -1 then begin
    Rec := TImageInfo(ImageInfoList[Selected]);
    FileName := Rec.CacheFName;
    UpdateImageInfoMemo(Rec);
  end else begin
    FileName := NullImageName;
    UpdateImageInfoMemo(nil);
  end;
  if TestExtenstion(FileName) > 1 then begin
    DisplayMediaInBrowser(FileName);
    {
    ExecuteFile := FileName;

    FillChar(SEInfo,Sizeof(SEInfo),0);
    SEInfo.cbSize := Sizeof(TShellExecuteInfo);
    with SEInfo do begin
      fMask := SEE_MASK_NOCLOSEPROCESS;
      Wnd := Application.Handle;
      lpFile := PChar(ExecuteFile);
      ParamString := '';
      lpParameters := PChar(ParamString);
      nShow := SW_SHOWNORMAL;
    end;
    if ShellExecuteEx(@SEInfo) then begin
      repeat
        Application.ProcessMessages;
        GetExitCodeProcess(SEInfo.hProcess, ExitCode);
      until (Exitcode <> STILL_ACTIVE) or Application.Terminated;
    end;}
  end;
end;

procedure TfrmImages.TabControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  iPos : integer;
  Rec : TImageInfo;
begin
  inherited;
  iPos := TabControl.IndexOfTabAt(X,Y);

  if iPos > -1  then begin
    Rec := TImageInfo(ImageInfoList[iPos]);
    TabControl.Hint := Rec.ShortDesc;
  end else
    TabControl.Hint := '';
end;

procedure TfrmImages.TabControlMouseUp(Sender: TObject; Button: TMouseButton;
                                       Shift: TShiftState; X, Y: Integer);
//kt add 7/6/10
var TabIndex : integer;
    P : TPoint;
begin
  inherited;
  TabIndex := TabControl.IndexOfTabAt(X,Y);
  if TabIndex < 0 then exit;
  FDeleteImageIndex := TabIndex;
  P.X := X; P.Y := Y;
  P := TabControl.ClientToScreen(P);
  if Button = mbRight then begin
    TabControl.PopupMenu := mnuPopup;
    mnuPopup.Popup(P.X, P.Y);
    TabControl.PopupMenu := nil;
  end;
  if Button = mbLeft then ExecuteFileIfNeeded(TabIndex);
end;

procedure TfrmImages.mnuPopupPopup(Sender: TObject);
//Determine here if delete option should be enabled.
begin
  inherited;
  mnuPopDeleteImage.Enabled := CanDeleteImages;
end;

function TfrmImages.CanDeleteImages : boolean;
//Determine here if image can be deleted.
var
  ActionSts: TActionRec;
begin
  FImageDeleteMode := idmNone;
  if FEditIsActive then begin
    Result := true;
    FImageDeleteMode := idmDelete;
    exit;
  end;
  //Will use same user class managment rules for images as for notes.
  //So if user can delete a note, then they can also delete images.
  //ActOnDocument(ActionSts, frmNotes.lstNotes.ItemIEN, 'DELETE RECORD');
  ActOnDocument(ActionSts, ListBox.ItemIEN, 'DELETE RECORD');
  if (ActionSts.Success = false) then begin
    if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then ActionSts.Success := true;
  end;
  Result := ActionSts.Success;
  if Result then begin
    //if AuthorSignedDocument(frmNotes.lstNotes.ItemIEN) then FImageDeleteMode := idmRetract
    if AuthorSignedDocument(ListBox.ItemIEN) then FImageDeleteMode := idmRetract
    else FImageDeleteMode := idmDelete;
  end;
end;

procedure TfrmImages.mnuPopDeleteImageClick(Sender: TObject);
begin
  inherited;
  DeleteImageIndex(FDeleteImageIndex, FImageDeleteMode, True);
end;

procedure TfrmImages.DeleteAll(DeleteMode: TImgDelMode);
begin
  EnsureALLImagesDownloaded;
  while TabControl.Tabs.Count > 0 do begin
    DeleteImageIndex(0,DeleteMode,False);
    NewNoteSelected(False);
    EnsureALLImagesDownloaded;
    frmImages.Formshow(self);
  end;
end;


procedure TfrmImages.DeleteImageIndex(ImageIndex : integer; DeleteMode : TImgDelMode; boolPromptUser: boolean);
//Note: permissions must be checked before running this function
var
  ImageInfo : TImageInfo;
  ReasonForDelete : string;
  DeleteSts : TActionRec;

CONST
  TMG_PRIVACY  = 'FOR PRIVACY';  //Server message (don't translate)
  TMG_ADMIN    = 'ADMINISTRATIVE'; //Server message (don't translate)

begin
  if (ImageIndex<0) or (ImageIndex>=ImagesCount) then begin
    MessageDlg('Invalid image index to delete: '+IntToStr(ImageIndex), mtError,[mbOK],0);
    exit;
  end;
  ImageInfo := Self.ImageInfo[ImageIndex];
  if boolPromptUser then begin
    //ReasonForDelete := SelectDeleteReason(frmNotes.lstNotes.ItemIEN);
    ReasonForDelete := SelectDeleteReason(ListBox.ItemIEN);
    if ReasonForDelete = DR_CANCEL then Exit;
    if ReasonForDelete = DR_PRIVACY then begin
      ReasonForDelete := TMG_PRIVACY;
    end else if ReasonForDelete = DR_ADMIN then begin
      ReasonForDelete := TMG_ADMIN;
    end;
  end else begin
    ReasonForDelete := 'DeleteAll';
  end;

  //DeleteImage(DeleteSts, ImageInfo.ServerFName, ImageInfo.IEN, frmNotes.lstNotes.ItemIEN, DeleteMode, ReasonForDelete);
  DeleteImage(DeleteSts, ImageInfo.ServerFName, ImageInfo.IEN, ListBox.ItemIEN, DeleteMode, ReasonForDelete);
end;

procedure TfrmImages.DeleteImage(var DeleteSts: TActionRec;
                                 ImageFileName: String;
                                 ImageIEN, DocIEN: Integer;
                                 DeleteMode : TImgDelMode;
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
  var
     NoteText, tempString: string;
     Beginning, Ending: integer;
     boolFound: boolean;
  // <!-- Retracted By: UserName on Date  ...;..   -->
  // FEditIsActive
  begin
     if FEditIsActive then begin
       Ending := 1;
       Beginning := 1;
       boolFound := False;
       While (boolFound = False) AND (Beginning > 0) Do Begin
         NoteText := frmNotes.HtmlEditor.HTMLText;
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
           NoteText := frmNotes.HtmlEditor.HTMLText;
           Beginning := PosEx('<embed',NoteText, Ending);
           Ending :=  PosEx('>', NoteText, Beginning) + 1;
           tempString := MidStr(NoteText, Beginning, Ending-Beginning);
           if pos(FileName,tempString) > 0 then boolFound := True;
         end;
       end;
       if boolFound = False then exit;
       if DeleteMode = idmDelete then begin
         frmnotes.HtmlEditor.HTMLText := AnsiReplaceStr(frmNotes.HtmlEditor.HTMLText, tempString, '');
       end else if DeleteMode = idmRetract then begin
         frmnotes.HtmlEditor.HTMLText := AnsiReplaceStr(frmNotes.HtmlEditor.HTMLText, tempString, ' <!-- ' + tempString + ' Retracted By: ' + User.Name + ' on ' +  DateToStr(Now));
       end;
       //ClearImageList;
       //EmptyCache;
       //frmImages.FormHide(self);
       //LastDisplayedTIUIEN := '0';
       //frmImages.Formshow(self);
       NewNoteSelected(True);
       frmImages.Formshow(self);
     end else begin
       //NewNoteSelected(True);
       //frmImages.Formshow(self);
     end;
  end;

begin
  //'Permanently delete attached image or file?'
  //Create dialog that gives option to export before deleting?
  //"You are about to permanently delete this image. Would you like to export before deletion? Yes/No/Cancel
  //Yes = export dialog then delete (if export is later cancelled assume cancel was pressed here), No=Only Delete, Cancel = No deletion
  if Reason <> 'DeleteAll' then begin
    if MessageDlg('Permanently delete attached image or file?',mtConfirmation,mbOKCancel,0) <> mrOK then exit;
  end;
  if ServerImageDelete(ImageIEN,DeleteMode,Reason) = false then exit;
  NoteImageDelete(DocIEN,ImageFileName,DeleteMode,Reason);
  if DeleteMode = idmRetract then begin
    InfoBox('NOTICE','This image or file will now be RETRACTED.  As such, it has been'+CRLF +
            'removed from public view, and from typical Releases of Information,'+CRLF +
            'but will remain indefinitely discoverable to HIMS.'+CRLF+CRLF,MB_OK);
  end;
end;


procedure TfrmImages.mnuDeleteImageClick(Sender: TObject);
var
   SelectedImageTab,i : integer;
   ImageInfo : TImageInfo;
   frmImagePickExisting: TfrmImagePickExisting;

begin
  inherited;
  If TabControl.Tabs.Count < 1 then exit;
  frmImagePickExisting := TfrmImagePickExisting.Create(Self);
  if frmImagePickExisting.ShowModal = mrOK then begin
    //ImageFName := frmImagePickExisting.SelectedImageFName;
    if not assigned(frmImagePickExisting.SelectedImageInfo) then exit;
    SelectedImageTab := -1;
    for i := 0 to TabControl.Tabs.Count - 1 do begin
      ImageInfo := Self.ImageInfo[i];
      if frmImagePickExisting.SelectedImageInfo.ServerFName = ImageInfo.ServerFName then begin
        SelectedImageTab := i;
      end;
    end;
    if frmNotes.HTMLEditor.Active then begin
      FEditIsActive := true;
      DeleteImageIndex(SelectedImageTab,idmDelete,True);
    end else begin
      FEditIsActive := false;
      DeleteImageIndex(SelectedImageTab,idmRetract,True);
    end;
    NewNoteSelected(False);
    EnsureALLImagesDownloaded;
    frmImages.Formshow(self);
  end;
  FreeAndNil(frmImagePickExisting);
end;


function TfrmImages.AllowContextChange(var WhyNot: string): Boolean;
//This is called when the application is shutting down.  It may also
//be called under other circumstances.
//Return: TRUE if OK to exit or change.
begin
  Result := true; //default
  //kt -- used for TMGConsole--> if not TMGApplicationShutdownInitiated then exit;
  //From here down, we are shutting down...
  timLoadImages.Enabled := false;
  exit; //later could deny quit if doing something important...
  {
  WhyNot := 'Images busy';
  Result := False;
  }
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


procedure TfrmImages.AddSignatureImageClick(Sender: TObject);
var AddResult: integer;
begin
  inherited;
  frmImageUpload.Mode := umSigImage;
  AddResult := frmImageUpload.ShowModal;
  frmImageUpload.Mode := umAnyFile;
  if IsAbortResult(AddResult) then exit;
end;

procedure TfrmImages.AddUniversalImage1Click(Sender: TObject);
var
  frmImagesMultiUse: TfrmImagesMultiUse;

begin
  inherited;
  frmImagesMultiUse := TfrmImagesMultiUse.Create(Self);
  frmImagesMultiUse.Mode := imuAddImage;
  frmImagesMultiUse.ShowModal;
  frmImagesMultiUse.Free;
end;

initialization
  //put init code here

finalization
  //put finalization code here

end.

