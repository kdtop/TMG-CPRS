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
  fImageTransferProgress, fUploadImages, rFileTransferU, uImages,
  ORNet, TRPCB, fHSplit, Buttons, ExtDlgs, VA508AccessibilityManager;


type
  //TImgTransferMethod = (itmDropbox,itmDirect,itmRPC);

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
    procedure TabControlGetImageIndex(Sender: TObject; TabIndex: Integer; var ImageIndex: Integer);
    procedure TabControlResize(Sender: TObject);
    procedure EnableAutoScanUploadClick(Sender: TObject);
    procedure PickScanFolderClick(Sender: TObject);
    procedure TabControlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure mnuPopupPopup(Sender: TObject);
    procedure mnuPopDeleteImageClick(Sender: TObject);
    procedure mnuDeleteImageClick(Sender: TObject);
    procedure AddUniversalImage1Click(Sender: TObject);
  private
    //ImageInfoList : TList;
    LastDisplayedTIUIEN : AnsiString;
    //ImageIndexLastDownloaded : integer;
    FDeleteImageIndex : integer;
    FEditIsActive : boolean;
    FImageDeleteMode : TImgDelMode;
    //InsideImageDownload : boolean;
    //frmImageTransfer: TfrmImageTransfer;
    //DownloadRetryCount : integer;
    //DownloadThumbnails : tBoolUnknown;
    procedure ExecuteFileIfNeeded(Selected: integer);
    //procedure EnsureImageListLoaded(AImageInfoList : TList);
    //procedure ClearImageList(AImageInfoList : TList);
    procedure ClearTabPages();
    procedure SetupTab(i : integer; AImageInfoList : TList);
    procedure UpdateNoteInfoMemo();
    procedure UpdateImageInfoMemo(Rec: TImageInfo);
    //function FileSize(fileName : wideString) : Int64;
    //function GetImagesCount : integer;
    //function GetImageInfo(Index : integer) : TImageInfo;
    procedure SetupTimer;
    function CanDeleteImages : boolean;
    function TestExtenstion(FileName: string): integer;
    procedure DeleteImageIndex(ImageIndex : integer; DeleteMode : TImgDelMode; boolPromptUser: boolean);
    procedure DeleteImage(var DeleteSts: TActionRec; ImageFileName: string; ImageIEN, DocIEN: Integer;
                          DeleteMode : TImgDelMode; const Reason: string);
    //procedure GetUnlinkedImagesList(AImageInfoList: TList; ImagesInHTMLNote: TStringList);
    procedure DisplayMediaInBrowser(MediaName : string);
    //procedure FileTransferProgressInitialize(CurrentValue, TotalValue : integer; Msg : string);
    //function FileTransferProgressCallback(CurrentValue, TotalValue : integer; Msg : string = '') : boolean;  //result: TRUE = CONTINUE, FALSE = USER ABORTED.
    //procedure FileTransferProgressDone();
  public
    //CacheDir : AnsiString;
    //TransferMethod : TImgTransferMethod;
    //DropBoxDir : string;
    //frmImageUpload: TfrmImageUpload;  //kt 8/4/20.  Moved from private to public
    NullImageName : AnsiString;
    //NumImagesAvailableOnServer : integer;
    DownloadImagesInBackground : boolean;
    //function GetImagesForIEN(IEN: AnsiString; AImageInfoList : TList): integer;
    //function DownloadFileViaDropbox(FPath,FName,LocalSaveFNamePath: AnsiString;CurrentImage,TotalImages: Integer): TDownloadResult;
    //function DownloadFile(FPath,FName,LocalSaveFNamePath: AnsiString;CurrentImage,TotalImages: Integer): TDownloadResult;
    //function UploadFileViaDropBox(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
    //function UploadFile(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
    //procedure SplitLinuxFilePath(FullPathName : AnsiString; var Path : AnsiString; var FName : AnsiString);
    //function ParseOneImageListLine(s : string) : TImageInfo;
    //procedure FillImageList(TIUIEN : string; AImageInfoList : TList);
    procedure NewNoteSelected(EditIsActive : boolean);
    //function CreateBarcode(MsgStr: AnsiString; ImageType: AnsiString): AnsiString;
    function DecodeBarcode(LocalFNamePath,ImageType: AnsiString): AnsiString;
    //procedure EnsureSLImagesDownloaded(ImagesInHTMLNote : TStringList; HideProgress : boolean = false);
    //procedure EnsureLinkedImagesDownloaded;
    //function DownloadToCache(AImageInfoList: TList; ImageIndex : integer) : TDownloadResult;
    //function DownloadRecToCache(Rec : TImageInfo; CurrentImage : integer = 1;TotalImages: Integer=2) : TDownloadResult;
    procedure DeleteAll(DeleteMode: TImgDelMode);
    //property ImagesCount : integer read GetImagesCount;
    //property ImageInfo[index : integer] : TImageInfo read GetImageInfo;
    procedure GetThumbnailBitmapForFName (FName : string; Bitmap : TBitmap);
    function ThumbnailIndexForFName (FName : string) : integer;
    function AllowContextChange(var WhyNot: string): Boolean;
    //procedure RemoveSuccessfullyDownloadedRecs(AImageInfoList: TList);
    //procedure EmptyCache();
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
  ListBox: TORListBox;  //will be set as pointer to frmNotes.lstNotes
  HTMLEditor: TWebBrowser;


function LoadAnyImageFormatToBMP(FPath : string; BMP : TBitmap) : boolean;  forward;
function NotesTIUIEN : string;

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


function NotesTIUIEN : string;
begin
  Result := '0';
  if ListBox.ItemID <> '' then begin
    try
      Result := IntToStr(ListBox.ItemID);
    except
      //Error occurs after note is signed, and frmNotes.lstNotes.ItemID is "inaccessible"
      on E: Exception do exit;
    end;
  end;
end;

procedure TfrmImages.FormCreate(Sender: TObject);
begin
  inherited;
  ImageDownloadInitialize();
  frmImageUpload := TfrmImageUpload.Create(Self);
  LastDisplayedTIUIEN := '0';
  FDeleteImageIndex := -1;
  DownloadRetryCount := 0;
  //ImageInfoList := TList.Create;
  //ClearImageList(ImageInfoList); //sets up other needed variables.
  DownloadImagesInBackground := true;
  //CacheDir := ExtractFilePath(ParamStr(0))+ 'Cache';
  CacheDir := GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache';
  NullImageName := 'about:blank';
  if not DirectoryExists(CacheDir) then ForceDirectories(CacheDir);

  TransferMethod := TImgTransferMethod(uTMGOptions.ReadInteger('ImageTransferMethod',2));
  //DropBoxDir := uTMGOptions.ReadString('Dropbox directory','??');
  //if DropBoxDir='??' then begin  //just on first run.
  //  uTMGOptions.WriteBool('Use dropbox directory for transfers',false);
  //  uTMGOptions.WriteString('Dropbox directory','');
  //end;
  AutoScanUpload.Checked := uTMGOptions.ReadBool('Scan Enabled',false);
  if assigned(frmNotes) then ListBox := frmNotes.lstNotes;  //kt 8/10/20 added if Assigned() ...
end;

procedure TfrmImages.FormDestroy(Sender: TObject);
begin
  inherited;
  //ClearImageList(ImageInfoList);
  //ImageInfoList.Free;
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
//UPDATE 11/24/20 -- To simplify code flow, and handling some problems, I am DISABLING the timer functionality
var  Result : TDownloadResult;
begin
  inherited;
  {
  timLoadImages.Enabled := false;
  exit; //kt 11/24/20 disabling timer downloads.
  EnsureImageListLoaded(ImageInfoList);
  if NumImagesAvailableOnServer = 0 then exit;
  if (ImageIndexLastDownloaded >= (ImageInfoList.Count-1)) then exit;
  if InsideImageDownload = false then begin
    Result := DownloadToCache(ImageInfoList, ImageIndexLastDownloaded+1); //Only load 1 image per timer firing.
    if Result = drTryAgain then begin
      inc (DownloadRetryCount);
      if DownloadRetryCount > DOWNLOAD_RETRY_LIMIT then begin
        Result := drGiveUp;
      end;
    end;
  end else begin
    Result := drTryAgain;
  end;
  if Result = drSuccess then SetupTab(ImageIndexLastDownloaded+1, ImageInfoList);
  if Result <> drTryAgain then Inc(ImageIndexLastDownloaded);
  if Result = drSuccess then begin
    if TabControl.TabIndex < 0 then TabControl.TabIndex := 0;
    TabControlChange(self);
  end;
  if Result <> drUserAborted then begin
    SetupTimer;
  end;
  DownloadRetryCount := 0;
  }
end;

procedure TfrmImages.SetupTimer;
//UPDATE 11/24/20 -- To simplify code flow, and handling some problems, I am DISABLING the timer functionality

const
  BACKGROUND_DELAY : ARRAY[FALSE..TRUE] of integer = (IMAGE_DOWNLOAD_DELAY_FOREGROUND, IMAGE_DOWNLOAD_DELAY_BACKGROUND);
begin
  timLoadImages.Enabled := false;  //kt disabling timer downloads
  exit;
  //kt ------------------------
  timLoadImages.Interval := BACKGROUND_DELAY[DownloadImagesInBackground];
  timLoadImages.Enabled := true;
end;

{
procedure TfrmImages.GetUnlinkedImagesList(AImageInfoList: TList; ImagesInHTMLNote: TStringList);

  function FileNameInList(FileName : string):boolean;
  var i : integer;
      Rec : TImageInfo;
  begin
    result := False;
    for i := 0 to AImageInfoList.Count - 1 do begin
      Rec := TImageInfo(AImageInfoList[i]);
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
    ImageInfo := ParseOneImageListLine(s);
    if ImageInfo <> nil then AImageInfoList.Add(ImageInfo);
  end;
end;
}

{
procedure TfrmImages.EnsureSLImagesDownloaded(ImagesInHTMLNote : TStringList; HideProgress : boolean = false);
//This function's goal is to download SOME images in the FOREground,
// But only images matching those passed in ImagesList will be downloaded;
// The intent is to only download images that have links to them in HTML source
//Thus, if note has a large amount of images attached to it, but not referenced
//  in HTML code, then they will not be downloaded here. (But will be downloaded
//  later via timLoadImagesTimer
//-------------
//UPDATE 11/24/20 -- To simplify code flow, and handling some problems, I am DISABLING the timer functionality
//                   So will plan for all downloads to be in FOREGROUND
//NOTE: I encountered problem when this function is called recursively via user selecting a different note
//      while download is in process.  Onclick evoked via Application.ProcessMessages.  I will therefore
//      rewrite this to handle the situation.  
//Called by: uHTMLTools.ScanForSubs() <-- uHTMLTools.IsHTML (and others)
//       by:
var i : integer;
    Rec : TImageInfo;
    DownloadResult : TDownloadResult;
    TIUIEN : string;

begin
  if ImagesInHTMLNote.Count = 0 then exit;
  TIUIEN := NotesTIUIEN();
  NumImagesAvailableOnServer := FillImageList(TIUIEN, ImageInfoList);
  AddNoteImagesToList(ImagesInHTMLNote, ImageInfoList);
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
        DownloadResult := DownloadToCache(ImageInfoList, i);
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
  //remove successful records
  RemoveSuccessfullyDownloadedRecs(ImageInfoList);    //to do,.... this may need to be repositioned....
  FreeAndNil(frmImageTransfer);
end;

procedure TfrmImages.RemoveSuccessfullyDownloadedRecs(AImageInfoList: TList);
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

procedure TfrmImages.EnsureLinkedImagesDownloaded;
//This function's goal is to download ALL images in the FOREground.
var
  DownloadResult : TDownloadResult;
begin
  EnsureImageListLoaded(ImageInfoList);
  if NumImagesAvailableOnServer = 0 then exit;
  if not assigned(frmImageTransfer) then frmImageTransfer := TfrmImageTransfer.Create(Self);
  frmImageTransfer.ProgressMsg.Caption := 'Downloading Images';
  while (ImageIndexLastDownloaded < (ImageInfoList.Count-1)) do begin
    DownloadRetryCount := 0;
    Repeat
      DownloadResult := DownloadToCache(ImageInfoList, ImageIndexLastDownloaded+1);
      Application.ProcessMessages;
      if DownloadResult = drTryAgain then begin
        inc(DownloadRetryCount);
        if DownloadRetryCount > DOWNLOAD_RETRY_LIMIT then DownloadResult := drGiveUp;
      end;
      if frmImageTransfer.UserCanceled then DownloadResult := drGiveUp;
    until DownloadResult <> drTryAgain;
    if DownloadResult <> drGiveUp then begin
      SetupTab(ImageIndexLastDownloaded+1, ImageInfoList);
      if TabControl.TabIndex < 0 then TabControl.TabIndex := 0;
      TabControlChange(self);
    end;
    Inc(ImageIndexLastDownloaded);
  end;
end;
}

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

procedure TfrmImages.SetupTab(i : integer; AImageInfoList : TList);
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
  if i < AImageInfoList.Count then begin
    Rec := TImageInfo(AImageInfoList[i]);
    if (Rec.TabImageIndex < 1) then begin
      if FileExists(Rec.CacheThumbFName) then begin
        Bitmap := TBitmap.Create;
        Bitmap.Width := 1024;    //something big enough to hold any thumbnail.
        Bitmap.Height := 768;
        Bitmap.LoadFromFile(Rec.CacheThumbFName);
        Bitmap.Width := ThumbsImageList.Width;  //shrinkage crops image
        Bitmap.Height := ThumbsImageList.Height;
        index := ThumbsImageList.Add(Bitmap,nil);
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
  ClearImageList(nil);
end;

{
procedure TfrmImages.ClearImageList(AImageInfoList : TList);
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
}

{
procedure TfrmImages.EnsureImageListLoaded(AImageInfoList : TList);
begin
  if NumImagesAvailableOnServer = NOT_YET_CHECKED_SERVER then begin
    NumImagesAvailableOnServer := FillImageList(NotesTIUIEN, AImageInfoList);
  end;
end;
}

{
Function TfrmImages.DownloadRecToCache(Rec : TImageInfo; CurrentImage : integer = 1;TotalImages: Integer=2) : TDownloadResult;
//Loads image specified in Rec to Cache (unless already present)
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
}

{
Function TfrmImages.DownloadToCache(AImageInfoList: TList; ImageIndex : integer) : TDownloadResult;
//Loads image specified in ImageInfoList to Cache (unless already present)
var
  Rec : TImageInfo;
begin
  Rec := TImageInfo(AImageInfoList[ImageIndex]);
  Result := DownloadRecToCache(Rec,(ImageIndex*2)-1, AImageInfoList.Count*2);
end;
}

{
function TfrmImages.UploadFileViaDropBox(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
//NOTICE!:  I made a backup of this function, see in comments below this function
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
}

{
function TfrmImages.UploadFile(LocalFNamePath,FPath,FName: AnsiString;CurrentImage,TotalImages: Integer): boolean;
//NOTICE!:  I made a backup of this function, see in comments below this function
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
}

{
    procedure TfrmImages.FileTransferProgressInitialize(CurrentValue, TotalValue : integer; Msg : string);
begin
  if not assigned(frmImageTransfer) then frmImageTransfer := TfrmImageTransfer.Create(Self);
  frmImageTransfer.UpdateProgress(CurrentValue, TotalValue, Msg);
end;

function TfrmImages.FileTransferProgressCallback(CurrentValue, TotalValue : integer; Msg : string): boolean;  //result: TRUE = CONTINUE, FALSE = USER ABORTED.
begin
  if not assigned(frmImageTransfer) then begin
    Result := false;
    exit;
  end;
  frmImageTransfer.UpdateProgress(CurrentValue, TotalValue, Msg);
  Result := not frmImageTransfer.UserCanceled;
end;

procedure TfrmImages.FileTransferProgressDone();
begin
  FreeAndNil(frmImageTransfer);
end;
 }

{
function TfrmImages.DownloadFileViaDropbox(FPath,FName,LocalSaveFNamePath: AnsiString;
                                           CurrentImage,TotalImages: Integer): TDownloadResult;
//NOTE: There is a backup of this function below this one.
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
}

{
function TfrmImages.DownloadFile(FPath,FName,LocalSaveFNamePath: AnsiString;
                                 CurrentImage,TotalImages: Integer): TDownloadResult;
//NOTE: There is a backup of this function below this one.
var
  ErrMsg            : string;
  AProgressCallback :   TProgressCallback;
begin
  frmFrame.timSchedule.Enabled := false;      //12/1/17 added timSchedule enabler to keep it from crashing the RPC download
  if TransferMethod = itmDropbox then begin
    Result := DownloadFileViaDropBox(FPath, FName, LocalSaveFNamePath, CurrentImage, TotalImages);
    exit;
  end else begin
    FileTransferProgressInitialize(CurrentImage, TotalImages, 'Downloading Image');
    ErrMsg := '';
    StatusText('Retrieving full image...');
    AProgressCallback := self.FileTransferProgressCallback;
    Result := rFileTransferU.DownloadFile(FPath,FName,LocalSaveFNamePath, ErrMsg, AProgressCallback);
    StatusText('');
    //FileTransferProgressDone();
    If ErrMsg <> '' then MessageDlg('ERROR: '+ErrMsg,mtError,[mbOK],0);
  end;
  frmFrame.timSchedule.Enabled := true;      //12/1/17 added timSchedule enabler to keep it from crashing the RPC download
end;

}

procedure TfrmImages.NewNoteSelected(EditIsActive : boolean);
//Will be called by  fNotes when a new note has been selected.
//var
begin
  ClearTabPages();
  DownloadImagesInBackground := true;
  //kt SetupTimer; //UPDATE 11/24/20 -- To simplify code flow, and handling some problems, I am DISABLING the timer functionality
  //This will start downloading images after few second delay (so that if
  //user is just browsing past note, this won't waste effort.
  //If user selects images tab, then load will occur without delay.
  //Note: OnTimer calls timLoadImagesTimer()
  FEditIsActive := EditIsActive;
  UploadImagesButton.Enabled := EditIsActive;
  UploadImagesMnuAction.Enabled := EditIsActive;
  DisplayMediaInBrowser(NullImageName);
end;


{
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
}

procedure TfrmImages.UploadImagesButtonClick(Sender: TObject);
var
  Node: TORTreeNode;
  AddResult : TModalResult;

begin
  inherited;
  AddResult := frmImageUpload.ShowModal;
  if not IsAbortResult(AddResult) then begin
    NewNoteSelected(true);  //force a reload to show recently added image.
    //kt timLoadImages.Interval := IMAGE_DOWNLOAD_DELAY_FOREGROUND;
    //kt DownloadImagesInBackground := false;
    //kt SetupTimer;  //UPDATE 11/24/20 -- To simplify code flow, and handling some problems, I am DISABLING the timer functionality
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


{ //backup of function
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
      //s :=Decode(RPCBrokerV.Results[i]);
      s :=Decode64(RPCBrokerV.Results[i]);
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
}

function TfrmImages.DecodeBarcode(LocalFNamePath,ImageType: AnsiString): AnsiString;
//Decode data from barcode on image, or return '' if none
//Note: if I could find a cost-effective way of decoding this on client side,
//      then that code be done here in the function, instead of uploading image
//      to the server for decoding.
begin
  StatusText('Checking image for barcodes...');
  Application.ProcessMessages;
  Result := DoDecodeBarcode(LocalFNamePath,ImageType);
  StatusText('');
end;


{ //backup of function
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
      //RPCBrokerV.Param[0].Mult[IntToStr(ParamIndex)] := Encode(OneLine);
      RPCBrokerV.Param[0].Mult[IntToStr(ParamIndex)] := Encode64(OneLine);
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
}

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

{
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
}

{
function TfrmImages.GetImagesCount : integer;
//Returns number of images possible, not just those already downloaded.
begin
  EnsureImageListLoaded(ImageInfoList);
  Result := NumImagesAvailableOnServer;
end;
}

{
function TfrmImages.GetImageInfo(Index : integer) : TImageInfo;
begin
  if (Index > -1) and (Index < ImageInfoList.Count) then begin
    Result := TImageInfo(ImageInfoList[Index]);
  end else begin
    Result := nil;
  end;
end;
}

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
  EnsureLinkedImagesDownloaded;
  while TabControl.Tabs.Count > 0 do begin
    DeleteImageIndex(0,DeleteMode,False);
    NewNoteSelected(False);
    EnsureLinkedImagesDownloaded;
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
  if (ImageIndex<0) or (ImageIndex>=GetImagesCount) then begin
    MessageDlg('Invalid image index to delete: '+IntToStr(ImageIndex), mtError,[mbOK],0);
    exit;
  end;
  ImageInfo := GetImageInfo(ImageIndex);
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

  DeleteImage(DeleteSts, ImageInfo.ServerFName, ImageInfo.IEN, ListBox.ItemIEN, DeleteMode, ReasonForDelete);
end;


procedure TfrmImages.DeleteImage(var DeleteSts: TActionRec; ImageFileName: String;
                                 ImageIEN, DocIEN: Integer; DeleteMode : TImgDelMode;
                                 const Reason: string);  //Reason should be 10-60 chars;
var
  RefreshNeeded : boolean;
begin
  uImages.DeleteImage(DeleteSts, ImageFileName, ImageIEN, DocIEN, DeleteMode,
                      frmnotes.HtmlEditor, FEditIsActive, RefreshNeeded, User, Reason);
  if RefreshNeeded then begin
    NewNoteSelected(True);
    frmImages.Formshow(self);
  end;
end;

{   //backup of procedure.

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

}



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
      ImageInfo := GetImageInfo(i);
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
    EnsureLinkedImagesDownloaded;
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

