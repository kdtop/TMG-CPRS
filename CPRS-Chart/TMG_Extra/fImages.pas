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
  OleCtrls, SHDocVw, ShellAPI,Variants,
  VAUtils,  TMGHTML2, ActiveX,
  fImageTransferProgress, fUploadImages, rFileTransferU, uImages,
  ORNet, TRPCB, fHSplit, Buttons, ExtDlgs, VA508AccessibilityManager;


type
  TIconDispMode = (tGenericImage, tThumbnail);

  TNoteInfo = record
    IEN : string;
    DisplayTitle : string;
    RefDate : string;
    PatientName : string;
    AuthorIEN : string;
    AuthorSigName : string;
    AuthorName  : string;
    LocationName : string;
    Status  : string;
    VisitLabel  : string;
    VisitDate : string;
    ImageCount : integer;
    Subject  : string;
    Prefix : string;
    ParentIEN : string;
    IDSortIndicator : string;
    HighlightNote : string;
    HospitalNote : string;
  end;


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
    N3: TMenuItem;
    mnuIconLegend: TMenuItem;
    mnuChartSurgery: TMenuItem;
    FileTypeIconsImageList: TImageList;
    CurrentNoteMemo: TMemo;
    pnlTop: TPanel;
    Splitter2: TSplitter;
    OpenPictureDialog: TOpenPictureDialog;
    CurrentImageMemo: TMemo;
    mnuUploadImages: TMenuItem;
    pnlMiddle: TPanel;
    WebBrowser: TWebBrowser;
    mnuAutoScanUpload: TMenuItem;
    mnuPickScanFolder: TMenuItem;
    OpenDialog: TOpenDialog;
    mnuPopup: TPopupMenu;
    mnuPopDeleteImage: TMenuItem;
    mnuDeleteImage: TMenuItem;
    mnuAddUniversalImage: TMenuItem;
    mnuAddSignatureImage: TMenuItem;
    pnlBottom: TPanel;
    lvThumbnails: TListView;
    Splitter1: TSplitter;
    ThumbnailsImageList: TImageList;
    btnOpenLinkedDoc: TBitBtn;
    btnEditZoomOut: TSpeedButton;
    btnEditNormalZoom: TSpeedButton;
    btnEditZoomIn: TSpeedButton;
    btnSort: TBitBtn;
    procedure btnSortClick(Sender: TObject);
    procedure btnEditZoomInClick(Sender: TObject);
    procedure btnEditNormalZoomClick(Sender: TObject);
    procedure btnEditZoomOutClick(Sender: TObject);
    procedure btnOpenLinkedDocClick(Sender: TObject);
    procedure lvThumbnailsClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure lvThumbnailsData(Sender: TObject; Item: TListItem);
    procedure FormDestroy(Sender: TObject);
    procedure mnuAddSignatureImageClick(Sender: TObject);
    procedure mnuChartTabClick(Sender: TObject);
    procedure mnuActNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UploadImagesClick(Sender: TObject);
    procedure EnableAutoScanUploadClick(Sender: TObject);
    procedure mnuPickScanFolderClick(Sender: TObject);
    procedure mnuPopupPopup(Sender: TObject);
    procedure mnuPopDeleteImageClick(Sender: TObject);
    procedure mnuAddUniversalImageClick(Sender: TObject);
  private
    LastDisplayedTIUIEN : AnsiString;
    FDeleteImageIndex : integer;
    FEditIsActive : boolean;  //note: I suspect this is not kept in sync with actual editing in the various other forms.
    FImageDeleteMode : TImgDelMode;
    AllPatientImagesInfoList : TList; //contains TImageInfo items, and owns them.  This is different from uImages.DownloadQueInfoList
    ThumbnailDisplayMode: TIconDispMode;
    FZoom : integer;
    //FZoomStep : integer;  //e.g. 5% change with each zoom in
    FInitZoomValue : integer;
    Descending:boolean;    //elh
    procedure ExecuteFileIfNeeded(Selected: integer);
    procedure UpdateNoteInfoMemo(IEN : string);
    procedure UpdateImageInfoMemo(Rec: TImageInfo);
    function CanDeleteImages : boolean;
    function TestExtenstion(FileName: string): integer;
    procedure DeleteImage(var DeleteSts: TActionRec; ImageFileName: string; ImageIEN, DocIEN: Integer;
                          DeleteMode : TImgDelMode; const Reason: string);
    procedure DisplayMediaInBrowser(MediaName : string);
    procedure ReloadForPatient();
    procedure Clear();
    procedure LoadAllPatientImagesInfoList();
    procedure AddThumbToImageList(Rec: TImageInfo);
    function ParseNoteInfo(s : string) : TNoteInfo;
    procedure ApplyZoom(Zoom:integer;WB: TWebBrowser);
    //procedure SetZoom(Pct : integer);
    //procedure ZoomReset;
    //procedure ZoomIn;
    //procedure ZoomOut;
  public
    NullImageName : AnsiString;
    procedure NewNoteSelected(EditIsActive : boolean);
    function DecodeBarcode(LocalFNamePath,ImageType: AnsiString): AnsiString;
    procedure GetThumbnailBitmapForFName (FName : string; Bitmap : TBitmap);
    function ThumbnailIndexForFName (FName : string) : integer;
    function AllowContextChange(var WhyNot: string): Boolean;
    procedure HandlePatientChanged();
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

  //Zoom Constants
  OLECMDID_OPTICAL_ZOOM = $0000003F;
  MIN_ZOOM = 10;
  MAX_ZOOM = 1000;
  ZOOM_FACTOR = 40;
  DEFAULT_ZOOM = 100;


var
  frmImages: TfrmImages;
  HTMLEditor: TWebBrowser;


//function NotesTIUIEN : string;

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
begin
  inherited;
  ThumbnailDisplayMode := tGenericImage;  //don't download thumbnails initially.
  ImageDownloadInitialize();
  AllPatientImagesInfoList := TList.Create; //contains TImageInfo items, and owns them.
  frmImageUpload := TfrmImageUpload.Create(Self);
  LastDisplayedTIUIEN := '0';
  FDeleteImageIndex := -1;
  //DownloadImagesInBackground := true;
  CacheDir := GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache';
  NullImageName := 'about:blank';
  if not DirectoryExists(CacheDir) then ForceDirectories(CacheDir);

  TransferMethod := TImgTransferMethod(uTMGOptions.ReadInteger('ImageTransferMethod',2));
  //DropBoxDir := uTMGOptions.ReadString('Dropbox directory','??');
  //if DropBoxDir='??' then begin  //just on first run.
  //  uTMGOptions.WriteBool('Use dropbox directory for transfers',false);
  //  uTMGOptions.WriteString('Dropbox directory','');
  //end;
  mnuAutoScanUpload.Checked := uTMGOptions.ReadBool('Scan Enabled',false);
  //FZoomValue := 100;  //100%
  //FZoomStep := 20;  //e.g. 5% change with each zoom in
end;

procedure TfrmImages.FormDestroy(Sender: TObject);
begin
  inherited;
  ClearImageList(AllPatientImagesInfoList);
  FreeAndNil(AllPatientImagesInfoList);
end;

procedure TfrmImages.FormHide(Sender: TObject);
begin
  inherited;
  ThumbnailDisplayMode := tGenericImage;
end;

procedure TfrmImages.FormShow(Sender: TObject);
var  TIUIEN : AnsiString;
begin
  inherited;
  mnuDeleteImage.Enabled := CanDeleteImages;
  TIUIEN := ActiveTIUIENForImages;
  ThumbnailDisplayMode := tThumbnail;
  if AllPatientImagesInfoList.Count = 0 then LoadAllPatientImagesInfoList();
  FZoom := DEFAULT_ZOOM;
  //ZoomReset;
  Descending := False;
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


{
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
}

function TfrmImages.ParseNoteInfo(s : string) : TNoteInfo;
//s: IEN^ExDateOfNote^Title, Location, Author^ImageCount^Visit
var temp : string;
begin
 { Return: Pieces as below
   piece 1:  TIU IEN
         2:  DisplayTitle         e.g. Addendum to LAB/XRAYS/STUDIES RESULTS
         3:  FMReferenceDate(#1301)   e.g. 3150422.174108
         4:  PatientName   e.g. ZZTEST, BABY  (Z0103)
         5:  AuthorIEN;AuthorSigName;AuthorName   e.g. 168;KEVIN S TOPPENBERG, MD;TOPPENBERG,KEVIN S
         6:  LocationName   e.g. Laughlin_Office
         7:  Status  e.g. unsigned
         8:  Adm[or Visit]: DateStr;FMDT   e.g. Visit: 04/21/15;3150421.083119
         9:  Dis: DateStr;FMDT   e.g. "        ;"
        10:  REQUESTING PACKAGE REFERENCE IEN(var ptr)  e.g. ""
        11:  Image Count   e.g. 0
        12:  Subject(#1701)  e.g. ""
        13:  Prefix (child indicator)   e.g. "+"
        14:  ParentIEN (#.06), or IDParentien (#2101), or Context, or 1  e.g. 361381
        15:  ID Sort indicator  e.g.  ""
        16:  Highlight Note  ELH   8/4/16
        17:  Hospital Note   ELH   4/30/19
 }
  Result.IEN := piece(s,'^',1);
  Result.DisplayTitle := piece(s,'^',2);
  Result.RefDate := FormatFMDateTime('mmm dd,yy', FMDTStrToFMDT(piece(s,'^',3)));
  Result.PatientName  := piece(s,'^',4);
  temp := piece(s,'^',5);
  Result.AuthorIEN := piece(temp,';',1);
  Result.AuthorSigName := piece(temp,';',2);
  Result.AuthorName := piece(temp,';',3);
  Result.LocationName := piece(s,'^',6);
  Result.Status := piece(s,'^',7);
  temp := piece(s,'^',8);
  Result.VisitLabel := piece(temp,':', 1);
  temp := piece(temp,':',2);
  Result.VisitDate := piece(temp,';',1);
  Result.ImageCount := StrToIntDef(piece(s, '^', 11), 0);
  Result.Subject := piece(s, '^', 12);
  Result.Prefix := piece(s, '^', 13);
  Result.ParentIEN := piece(s, '^', 14);
  Result.IDSortIndicator := piece(s, '^', 15);
  Result.HighlightNote := piece(s, '^', 16);
  Result.HospitalNote := piece(s, '^', 17);
end;


procedure TfrmImages.UpdateNoteInfoMemo(IEN : string);
var Info : TStringList;
    Result : string;
    NoteInfo : TNoteInfo;
begin
  CurrentNoteMemo.Lines.Clear;
  Info := TStringList.Create;
  try
    GetNoteInfo(Info, IEN);
    if Info.Count > 0 then Result := Info[0];
    if piece(Result,'^',1)='-1' then begin
      MessageDlg('Error: '+piece(Result,'^',2), mtError, [mbOK], 0);
      exit;
    end;
    if Info.Count > 1 then begin
      NoteInfo := ParseNoteInfo(Info[1]);
      With CurrentNoteMemo do begin
        Lines.add(NoteInfo.RefDate + ' - ' + NoteInfo.DisplayTitle + ' - ' + NoteInfo.AuthorSigName);
        Lines.Add(NoteInfo.LocationName + ',  IEN:' + NoteInfo.IEN);
      end;
    end;
  finally
    Info.Free;
  end;
end;

//procedure GetNoteInfo(Dest : TStrings; IEN : string);   //kt added 12/9/2020


procedure TfrmImages.UploadImagesClick(Sender: TObject);
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

procedure TfrmImages.DisplayMediaInBrowser(MediaName : string);

    procedure LoadMedia(MediaName:string);
      var   HTMLFile: textfile;
        HTMLText: string;
        SR: TSearchRec;
        FileList:TStringList;
        i : integer;
      begin
        FileList := TStringList.Create();
        HTMLText := '<html><head><title>'+Medianame+'</title></head><body>';
        for i := 0 to FileList.Count - 1 do begin
          HTMLText := HTMLText+'<img width=800 height=1200 src="'+MediaName+'">';
        end;
        HTMLText := HTMLText+'</body></html>';

        AssignFile(HTMLFile,GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache\temp.html');
        Rewrite(HTMLFile);
        Write(HTMLFile,HTMLText);
        CloseFile(HTMLFile);

        if FZoom <> DEFAULT_ZOOM then begin
          FZoom := DEFAULT_ZOOM;
          ApplyZoom(FZoom,WebBrowser);
        end;

        WebBrowser.Navigate(GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache\temp.html');
        end;

    function GetHTMLText(TextArray : TStrings) : string;
    var i : integer;
    begin
      for i := 0 to TextArray.Count - 1 do begin
        result := result + TextArray[i];
      end;
    end;

var  HTMLWrapper, MyRPCResults : TStringList;
     Result, P1Result : string;
begin
  HTMLWrapper := TStringList.Create;
  MyRPCResults := TStringList.Create;
  if MediaName = NullImageName then begin
    WebBrowser.Navigate(NullImageName);
  end else begin
    with RPCBrokerV do begin
      ClearParameters := True;
      RemoteProcedure := 'TMG CPRS IMAGES TAB HTML';
      Param[0].PType := list;
      with Param[0] do begin
        Mult['1'] := MediaName; //add loop when ready for multiple images
      end;
      CallBroker;
    end;
    MyRPCResults.Assign(RPCBrokerV.Results);
    if MyRPCResults.Count = 0 then MyRPCResults.Add('0');
    Result := MyRPCResults[0];
    P1Result := piece(Result,'^',1);
    if P1Result ='0' then begin
      //WebBrowser.Navigate(MediaName);
      LoadMedia(MediaName);
    end else if P1Result='1' then begin
      MyRPCResults.Delete(0);
      WBLoadHTML(WebBrowser,GetHTMLText(MyRPCResults));
    end else begin
      ShowMessage(Piece(Result,'^',2));
    end;
  end;
  HTMLWrapper.free;
  MyRPCResults.Free;
end;


function TfrmImages.TestExtenstion(FileName: string): integer;
var  FileExt : string;
begin
  FileExt := UpperCase(ExtractFileExt(FileName));
  if Pos(FileExt,INSIDE_BROWSER)>0 then begin
    Result := 1
  end else if Pos(FileExt, OUTSIDE_BROWSER)>0 then begin
    Result := 2
  end else begin
    Result := 3;
  end;
end;


function TfrmImages.AllowContextChange(var WhyNot: string): Boolean;
//This is called when the application is shutting down.  It may also
//be called under other circumstances.
//Return: TRUE if OK to exit or change.
begin
  Result := true; //default
  exit; //later could deny quit if doing something important...
  {
  WhyNot := 'Images busy';
  Result := False;
  }
end;


procedure TfrmImages.btnEditNormalZoomClick(Sender: TObject);
begin
  inherited;
  if FZoom <> DEFAULT_ZOOM then begin
    FZoom := DEFAULT_ZOOM;
    ApplyZoom(FZoom,WebBrowser);
  end;
end;

procedure TfrmImages.ApplyZoom(Zoom:integer;WB: TWebBrowser);
var
  pvaIn, pvaOut: OleVariant;
begin
  pvaIn := Zoom;
  pvaOut := null;
  //pnlData.Caption := piece(pnlData.Caption,'@',1)+'@'+inttostr(Zoom)+'%';
  //lblZoom.Caption := 'Zoom: '+inttostr(Zoom)+' %';
  WB.ControlInterface.ExecWB(OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, pvaIn, pvaOut);
  Application.ProcessMessages;
end;

procedure TfrmImages.btnEditZoomInClick(Sender: TObject);
begin
  inherited;
  //ZoomIn;
  System.Dec(FZoom, ZOOM_FACTOR);
  if FZoom < MIN_ZOOM then
    FZoom := MIN_ZOOM;
  ApplyZoom(FZoom,WebBrowser);
end;

procedure TfrmImages.btnEditZoomOutClick(Sender: TObject);
begin
  inherited;
  //Zoomout;
  System.Inc(FZoom, ZOOM_FACTOR);
  if FZoom > MAX_ZOOM then
    FZoom := MAX_ZOOM;
  ApplyZoom(FZoom,WebBrowser);
end;

procedure TfrmImages.btnOpenLinkedDocClick(Sender: TObject);
var Item : TListItem;
    Rec  : TImageInfo; //not owned here
    TreeNode : TORTreeNode;

begin
  inherited;
  if lvThumbnails.ItemIndex < 0 then exit;
  Item := lvThumbnails.Items[lvThumbnails.ItemIndex];
  if not assigned(Item) then exit;
  Rec := GetImageInfo(AllPatientImagesInfoList, Item.Index);
  if not assigned(Rec) then exit;
  TreeNode := frmNotes.GetNodeByIEN(frmNotes.tvNotes, Rec.LinkedTIUIEN);
  if not assigned(TreeNode) then begin
    MessageDlg('Unable to automatically open that note.' + CRLF +
               'Perhaps note is not shown on Notes tab?' + CRLF +
               'Try increasing number of notes to show.' + CRLF +
               'To try opening note manually, use info:' + CRLF +
               CurrentNoteMemo.Lines.Text, mtError, [mbOK], 0);
    exit;
  end;
  frmNotes.tvNotes.Selected := TreeNode;
  frmFrame.SelectChartTab(CT_NOTES);
end;

procedure TfrmImages.btnSortClick(Sender: TObject);
var
  SDT, EDT : TFMDateTime;
  ExcludeSL : TStringList; //Implement later....
  i : integer;
  Rec  : TImageInfo;

begin
  Clear;
  SDT := 0;   //Later allow user to change
  EDT := 9999999.999999;   //Later allow user to change
  ExcludeSL := nil; //implement later.
  Descending := (Descending<>True);
  GetAllImages(AllPatientImagesInfoList, SDT, EDT, ExcludeSL,Descending);
  //Data is returned in ascending chronological order.  I want to display in decending chronological order.
  for i := 0 to AllPatientImagesInfoList.Count - 1 do begin
    Rec := GetImageInfo(AllPatientImagesInfoList, i);
    if not assigned(Rec) then continue;
    Rec.Tag := -1;
  end;
  lvThumbnails.Items.Count := AllPatientImagesInfoList.Count;
  btnSort.Caption := IfThen(Descending=False,'Currently In Ascending Order','Currently In Descending Order');
  if Descending then  
    btnSort.Glyph.LoadFromFile('\\server1\public\vista\vista-art\icons\arrows\down-arrow-glyph-2.bmp')
  else
    btnSort.Glyph.LoadFromFile('\\server1\public\vista\vista-art\icons\arrows\up-arrow-glyph-2.bmp');
  WebBrowser.Navigate(NullImageName);
end;

procedure TfrmImages.mnuAddSignatureImageClick(Sender: TObject);
var AddResult: integer;
begin
  inherited;
  frmImageUpload.Mode := umSigImage;
  AddResult := frmImageUpload.ShowModal;
  frmImageUpload.Mode := umAnyFile;
  if IsAbortResult(AddResult) then exit;
end;

procedure TfrmImages.mnuAddUniversalImageClick(Sender: TObject);
var
  frmImagesMultiUse: TfrmImagesMultiUse;
begin
  inherited;
  frmImagesMultiUse := TfrmImagesMultiUse.Create(Self);
  frmImagesMultiUse.Mode := imuAddImage;
  frmImagesMultiUse.ShowModal;
  frmImagesMultiUse.Free;
end;

procedure TfrmImages.Clear();
begin
  ClearImageList(AllPatientImagesInfoList);
  ThumbnailsImageList.Clear;
  ThumbnailsImageList.AddImage(FileTypeIconsImageList, 0);  //keep generic image as index 0
  lvThumbnails.Items.Count := 0;
end;

procedure TfrmImages.LoadAllPatientImagesInfoList();
var
  SDT, EDT : TFMDateTime;
  ExcludeSL : TStringList; //Implement later....
  i : integer;
  Rec  : TImageInfo;

begin
  SDT := 0;   //Later allow user to change
  EDT := 9999999.999999;   //Later allow user to change
  ExcludeSL := nil; //implement later.
  GetAllImages(AllPatientImagesInfoList, SDT, EDT, ExcludeSL);
  //Data is returned in ascending chronological order.  I want to display in decending chronological order.
  for i := 0 to AllPatientImagesInfoList.Count - 1 do begin
    Rec := GetImageInfo(AllPatientImagesInfoList, i);
    if not assigned(Rec) then continue;
    Rec.Tag := -1;
  end;
  lvThumbnails.Items.Count := AllPatientImagesInfoList.Count;
  //NOTE: Actual downloading will occur in the OnData event from the lvThumbnails TListView --> calls lvThumbsData() procedure
end;

procedure TfrmImages.lvThumbnailsClick(Sender: TObject);
//Handle showing full image.
var Item : TListItem;
    Rec  : TImageInfo; //not owned here
    DownloadResult : TDownloadResult;
    TryNum : integer;
    HideProgress : boolean;

begin
  inherited;
  if lvThumbnails.ItemIndex < 0 then exit;
  Item := lvThumbnails.Items[lvThumbnails.ItemIndex];
  if not assigned(Item) then exit;
  btnOpenLinkedDoc.Enabled := true;
  Rec := GetImageInfo(AllPatientImagesInfoList, Item.Index);
  HideProgress := false; //Later could make a parameter etc.
  TryNum := 0;
  if not Rec.SucessfullyDownloaded and (Rec.NumDownloadAttempts < DOWNLOAD_RETRY_LIMIT) then begin
    repeat
      Rec.DesiredDownloadMode := twdImgeOnly;
      //FYI: Increasing RefCount is a signal that we will own these recs, otherwise they would be deleted during processing download cue.
      inc(Rec.RefCount); //RefCount gets decreased during RemoveSuccessfullyDownloadedRecs when processing DownloadQue
      DownloadResult := EnsureRecDownloaded(Rec, HideProgress);
      Inc(TryNum);
      if DownloadResult = drTryAgain then Application.ProcessMessages;
    until (DownloadResult <> drTryAgain) or (TryNum >= DOWNLOAD_RETRY_LIMIT);
  end;
  if Rec.SucessfullyDownloaded then begin
    DisplayMediaInBrowser(Rec.CacheFName);
  end;
  UpdateImageInfoMemo(Rec);
  UpdateNoteInfoMemo(Rec.LinkedTIUIEN);
end;

procedure TfrmImages.lvThumbnailsData(Sender: TObject; Item: TListItem);
var
  Rec  : TImageInfo; //not owned here
  DownloadResult : TDownloadResult;
  TryNum : integer;
  HideProgress : boolean;

begin
  inherited;
  Item.ImageIndex := 0;  //default to generic image.
  if ThumbnailDisplayMode = tGenericImage then exit;
  if (Item.Index >= AllPatientImagesInfoList.Count) then exit;
  Rec := GetImageInfo(AllPatientImagesInfoList, Item.Index);
  if not assigned(Rec) then exit;
  HideProgress := true; //Later could make a parameter etc.
  Item.Caption := Rec.DisplayDate;
  TryNum := 0;
  if (Rec.Tag = -1) then begin
    if not Rec.SucessfullyDownloadedThumb and (Rec.NumDownloadAttempts < DOWNLOAD_RETRY_LIMIT) then begin
      repeat
        Rec.DesiredDownloadMode := twdThumbOnly;
        //FYI: Increasing RefCount is a signal that we will own these recs, otherwise they would be deleted during processing download cue.
        inc(Rec.RefCount); //RefCount gets decreased during RemoveSuccessfullyDownloadedRecs when processing DownloadQue
        DownloadResult := EnsureRecDownloaded(Rec, HideProgress);
        Inc(TryNum);
        if DownloadResult = drTryAgain then Application.ProcessMessages;
      until (DownloadResult <> drTryAgain) or (TryNum >= DOWNLOAD_RETRY_LIMIT);
    end;
    if Rec.SucessfullyDownloadedThumb then begin
      AddThumbToImageList(Rec);
      Item.ImageIndex := Rec.Tag;
    end;
  end else begin
    Item.ImageIndex := Rec.Tag;
  end;
end;


procedure TfrmImages.AddThumbToImageList(Rec: TImageInfo);
var
  TempBitmap : TBitmap;
begin
  TempBitmap := TBitmap.Create;
  try
    TempBitmap.LoadFromFile(Rec.CacheThumbFName);
    TempBitmap.SetSize(64, 64);
    Rec.Tag :=  ThumbnailsImageList.Add(TempBitmap, nil);
  finally
    TempBitmap.Free;
  end;
end;

procedure TfrmImages.ReloadForPatient();
begin
  Clear();
  if ThumbnailDisplayMode = tThumbnail then begin
    LoadAllPatientImagesInfoList();
  end;
  btnOpenLinkedDoc.Enabled := false;
end;

procedure TfrmImages.HandlePatientChanged();
begin
  uImages.HandlePatientChanged();
  ReloadForPatient();
end;

//===========================================================================
//Code below may be eligible for deletion after reconstruction done.
//===========================================================================

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
  ActOnDocument(ActionSts, ActiveTIUIENForImagesInt, 'DELETE RECORD');
  if (ActionSts.Success = false) then begin
    if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then ActionSts.Success := true;
  end;
  Result := ActionSts.Success;
  if Result then begin
    //if AuthorSignedDocument(frmNotes.lstNotes.ItemIEN) then FImageDeleteMode := idmRetract
    if AuthorSignedDocument(ActiveTIUIENForImagesInt) then FImageDeleteMode := idmRetract
    else FImageDeleteMode := idmDelete;
  end;
end;

procedure TfrmImages.mnuPopDeleteImageClick(Sender: TObject);
begin
  inherited;
  DeleteImageIndex(FDeleteImageIndex, FImageDeleteMode, True, frmNotes.HtmlEditor, FEditIsActive);
end;


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


procedure TfrmImages.EnableAutoScanUploadClick(Sender: TObject);
begin
  inherited;
  mnuAutoScanUpload.Checked := not mnuAutoScanUpload.Checked;
  uTMGOptions.WriteBool('Scan Enabled',mnuAutoScanUpload.Checked);
end;


procedure TfrmImages.mnuPickScanFolderClick(Sender: TObject);
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
  mnuAutoScanUpload.Checked := true;
end;


procedure TfrmImages.ExecuteFileIfNeeded(Selected: integer);
var
  FileName : AnsiString;
  Rec  : TImageInfo;
begin
  inherited;
  if Selected > -1 then begin
    Rec := GetImageInfo(Selected); // TImageInfo(ImageInfoList[Selected]);
    if assigned(Rec) then FileName := Rec.CacheFName else FileName := '';
    UpdateImageInfoMemo(Rec); //OK if rec is nil
  end else begin
    FileName := NullImageName;
    UpdateImageInfoMemo(nil);
  end;
  if TestExtenstion(FileName) > 1 then begin
    DisplayMediaInBrowser(FileName);
  end;
end;

procedure TfrmImages.NewNoteSelected(EditIsActive : boolean);
//Will be called by  fNotes when a new note has been selected.
begin
  FEditIsActive := EditIsActive;
  mnuUploadImages.Enabled := EditIsActive;
  DisplayMediaInBrowser(NullImageName);
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


procedure TfrmImages.GetThumbnailBitmapForFName(FName : string; Bitmap : TBitmap);
var index: integer;
begin
  index := ThumbnailIndexForFName(FName);
  Bitmap.Canvas.FillRect(Rect(0,0,Bitmap.Height,Bitmap.Width));
  FileTypeIconsImageList.GetBitmap(index,Bitmap);
end;

{procedure TfrmImages.SetZoom(Pct : integer);
//copied and modified from TMGHTML2
var
  pvaIn, pvaOut: OleVariant;
const
  OLECMDID_OPTICAL_ZOOM = $0000003F;
  MinZoom = 10;
  MaxZoom = 1000;
begin
  if Pct = FZoomValue then exit;
  Showmessage('Step 2:'+inttostr(FZoomValue)+'->'+inttostr(Pct));
  FZoomValue := Pct;
  if FZoomValue < MinZoom then FZoomValue := MinZoom;
  if FZoomValue > MaxZoom then FZoomValue := MaxZoom;
  Showmessage('Step 3: FZoomValue is-'+inttostr(FZoomValue));
  pvaIn := FZoomValue;
  Showmessage('Step 4: pvaIn is-'+inttostr(pvaIn));
  pvaOut := #0;
  try
    WebBrowser.ControlInterface.ExecWB(OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, pvaIn, pvaOut);
  except
    On E : exception do messagedlg('Error on setting Zoom.'+#13#10+E.Message,mtError,[mbok],0);
    //
  end;
end;

procedure TfrmImages.ZoomReset;
//copied and modified from TMGHTML2
begin
  SetZoom(100);
end;

procedure TfrmImages.ZoomIn;
//copied and modified from TMGHTML2
begin
  Showmessage('Step 1:'+inttostr(FZoomValue)+'+'+inttostr(FZoomStep));
  SetZoom(FZoomValue + FZoomStep);
end;

procedure TfrmImages.ZoomOut;
//copied and modified from TMGHTML2
begin
  Showmessage('Step 1:'+inttostr(FZoomValue)+'-'+inttostr(FZoomStep));
  SetZoom(FZoomValue - FZoomStep);
end;}

end.

