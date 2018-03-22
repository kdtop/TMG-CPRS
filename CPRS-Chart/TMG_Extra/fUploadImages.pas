unit fUploadImages;
//kt 9/11 added
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, pngimage, ExtDlgs, OleCtrls,
  uCore, iniFiles, ShellAPI, fTMG_WIA_GetImage, registry, jpeg,
  SHDocVw;

type

  PHICON = ^HICON;

  TImageInfo = class
    private
    public
      TIUIEN :             int64;      //IEN in file# 8925
      DFN :                AnsiString; //IEN in Patient File (#2)
      IMAGEIEN :           int64;      //IEN in file# 2005 (IMAGE)
      UploadDUZ :          int64;      //IEN in NEW PERSON file
      ThumbFPathName :     AnsiString; // local file path name
      ImageFPathName :     AnsiString; // local file path name
      ServerPath :         AnsiString;
      ServerFName :        AnsiString;
      ServerThumbFName:    AnsiString;
      ShortDesc :          String[60];
      Extension :          String[16];
      ImageDateTime :      AnsiString;
      UploadDateTime:      AnsiString;
      ObjectType :         int64;      //pointer to file 2005.02
      ProcName :           String[10]; //server limit is 10 chars.
      pLongDesc :          TStrings;  //Won't be owned by this list
      procedure Assign(Source : TImageInfo);
      procedure Clear;
  end;

  TAutoUploadNote = class
    private
    public
      TIUIEN :       int64;      //IEN in file# 8925
      ErrMsg :       AnsiString;
      NoteTitle :    AnsiString; //Title of note to be associated with image
      Patient :      TPatient;
      ImageInfo :    TImageInfo;
      Location :     AnsiString; //Location that image if from
      DOS :          AnsiString; //Date of service
      Provider :     AnsiString;
      CurNoteImages: TStringList;
      UploadError :  Boolean;
      procedure SetDFN(var ChartNum,Location,FName,LName,MName,DOB,Sex : string);
      Procedure SetInfo(var DOS,Provider,Location,Title : string);
      function SameAs(OtherNote: TAutoUploadNote): boolean;
      function MakeNewBlankNote(DFN,DOS,Provider,Location,Title : string): string;
      procedure InitFrom(OtherNote: TAutoUploadNote; UploadedDocs: TStringList);
      function IsValid : boolean;
      procedure Clear;
      constructor Create();
      destructor Destroy;  override;
  end;

  //NOTE: If changes are made to tImageUploadMode, also change THUMBNAIL_SIZE constant.
  tImageUploadMode = (umAnyFile, umImagesOnly, umUniversal, umPatientID, umSigImage);

  TfrmImageUpload = class(TForm)
    OpenFileDialog: TOpenDialog;
    imgUploadIcon: TImage;
    PickImagesButton: TBitBtn;
    Label1: TLabel;
    CancelButton: TBitBtn;
    UploadButton: TBitBtn;
    lblAttachNote: TLabel;
    lblShortDescript: TLabel;
    ShortDescEdit: TEdit;
    LongDescMemo: TMemo;
    lblLongDescript: TLabel;
    lblDateTime: TLabel;
    DateTimeEdit: TEdit;
    ClearImagesButton: TBitBtn;
    OpenPicDialog: TOpenPictureDialog;
    FilesToUploadList: TListBox;
    NoteEdit: TEdit;
    btnPickOther: TBitBtn;
    pnlIEHolder: TPanel;
    WebBrowser: TWebBrowser;
    Label6: TLabel;
    MoveCheckBox: TCheckBox;
    PolTimer: TTimer;
    btnPickPDF: TBitBtn;
    btnEditImage: TBitBtn;
    btnConfigEditor: TBitBtn;
    btnPickStock: TBitBtn;
    btnCamera: TBitBtn;
    cmbWidth: TComboBox;
    lblImageScale: TLabel;
    procedure UploadButtonClick(Sender: TObject);
    procedure PickImagesButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShortDescEditChange(Sender: TObject);
    procedure ClearImagesButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FilesToUploadListClick(Sender: TObject);
    procedure btnPickOtherClick(Sender: TObject);
    procedure FormRefresh(Sender: TObject);
    procedure PolTimerTimer(Sender: TObject);
    procedure btnPickPDFClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnEditImageClick(Sender: TObject);
    procedure btnConfigEditorClick(Sender: TObject);
    procedure btnPickStockClick(Sender: TObject);
    procedure btnCameraClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure MoveCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
    Bitmap : TBitmap;
    SavedMoveFilesValue : Boolean;
    FUploadMode : tImageUploadMode;
    //FCallingForm : string;
    FUploadedImagesList : TStringList; //List of strings of images succesfully uploaded.
    FUploadedImagesIENList : TStringList; //List of strings of IMAGE file IEN's succesfully uploaded.
                                          //Note: 1:1 relationship with FUploadedImagesList
    function MakeThumbNail(Info: TImageInfo; Size : integer = 64): boolean;
    procedure GetAssociatedIcon(FileName: TFilename; PLargeIcon, PSmallIcon: PHICON);
    procedure LoadNotesEdit();
    //procedure LoadNotesList();
    function UploadFile(Info: TImageInfo; DelOrig : boolean): boolean;
    procedure RunModal(ExecuteFile, ParamString:string);
    function GetWindowsFolder: string;
    function CopyFileToTemp(FNamePath : string;TempBrowseable : boolean=false) : string;
    procedure UploadChosenFiles();
    function ProcessOneLine(Line : string) : string;
    function ProcessOneFile(FileName : string) : boolean;
    procedure ScanAndHandleImgTxt;
    procedure ScanAndHandleImages;
    procedure DecodeImgTxt(Line : string; out ChartNum, Location,
                           FName, LName, MName, Sex, DOB, DOS, Provider,
                           Title : string; FilePaths : TStrings);
    function EncodeImgTxt(ChartNum, Location, FName, LName, MName, Sex, DOB,
                           DOS, Provider, Title : string; FilePaths : TStrings) : AnsiString;
    procedure FinishDocument(UploadNote : TAutoUploadNote);
    procedure SetPatientPhotoID(Value : boolean);
    procedure SetAllowNonImages(Value : boolean);
    procedure SetUniversalImages(Value : boolean);
    procedure SetUploadMode(Value : tImageUploadMode);
    procedure VerifyDocuments(TIUIENList: TStringList);
    //procedure SetCallingForm(form : string);
    procedure LinkSignatureImage(var Info: TImageInfo);
  public
    { Public declarations }
    FScanDir : String;
    PolInterval : integer;
    FileExt : string;
    Picture : TPicture;
    UploadedDocs : TStringList;
    procedure SetScanDir(NewDir : string);
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
  published
    DragAndDropFNames : TStringList;
    property ScanDir : String read FScanDir write SetScanDir;
    property UploadedImages : TStringList read FUploadedImagesList;
    property UploadedImageIENs : TStringList read FUploadedImagesIENList;
    property Mode : tImageUploadMode read FUploadMode write SetUploadMode;
    //property CallingForm : string read FCallingForm write SetCallingForm;
  end;

const
  IMAGES : string = '.JPG,.JPEG,.PNG,.TIF,.PDF,.BMP';
  EXTERNALFILES : string = '.GIF,.DCM,.DCM30,.MOV,.AVI,.MP4';
  THUMBNAIL_SIZE : array[umAnyFile .. umSigImage] of integer = (64, 64, 64, 32, 0);


  function SaveCanvasToFile(Canvas : TCanvas; Rect: TRect; FilePath : String) : boolean; //forward.  Returns success of save
  function UploadFromCanvas(Canvas : TCanvas; Rect: TRect) : string;  //Forward.  Returns VistA name of image, or '' if abort
  function UniqueTempSaveFilePath (RootName : string = 'temp_file'; FileType : string = 'jpg') : string;

var
  //frmImageUpload: TfrmImageUpload;
  PLargeIcon, PSmallIcon: phicon;



implementation

{$R *.dfm}

  uses  fNotes,
        StrUtils, //for MidStr etc.
        ORFn,    //for PIECE etc.
        Trpcb,   //for .PType enum
        fImages, //for upload/download files etc.
        ORNet,   //for RPCBrokerV
        rTIU,
        uHTMLTools,
        fImagePickPDF, //for PDF picker dialog
        uTMGOptions,
        Math,
        fTMG_DirectX_GetImage,  //for camera - DirectX
        fFrame,
        fOptions, fDCSumm;

  const
    DefShortDesc = '(Short Image Description)';

  type
    TFileInfo = class
    private
    public
      SrcRec : TSearchRec;
      STimeStamp : String;
      SBarCode : String;
      FPath : String;
      MetaFileName : String;
      MetaFileExists : boolean;
      BatchCount : integer;
      procedure Assign(Source: TFileInfo);
      procedure Clear;
    end;

  var
    AutoUploadNote : TAutoUploadNote;

  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  function SaveCanvasToFile(Canvas : TCanvas; Rect: TRect; FilePath : String) : boolean;
  //result is success of save
  var Bmp: TBitmap;
      JPG: TJPEGImage;
    function Width(Rect: TRect) : integer; begin Result := Rect.Right-Rect.Left;  end;
    function Height(Rect: TRect) : integer; begin Result := Rect.Bottom-Rect.Top;  end;
  begin
    Bmp := TBitmap.Create;
    try
      Bmp.SetSize(Width(Rect), Height(Rect));
      BitBlt(Bmp.Canvas.Handle, 0, 0, Width(Rect), Height(Rect), Canvas.Handle, Rect.Left, Rect.Top, SRCCOPY);
      JPG := TJPEGImage.Create;
      try
        JPG.Assign(Bmp);
        JPG.SaveToFile(FilePath);
      finally
        JPG.Free;
      end;
    finally
      Bmp.Free;
    end;
    Result := FileExists(FilePath);
  end;

  function UniqueTempSaveFilePath (RootName : string = 'temp_file'; FileType : string = 'jpg') : string;
  var  CacheDir : AnsiString;  //kt 9/11
       i : integer;
  begin
    CacheDir := GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache';
    i := 0;
    repeat
      inc(i);
      Result := CacheDir + '\' + RootName + IntToStr(i) + '.' + FileType;
    until not FileExists(Result);
  end;

  function UploadFromCanvas(Canvas : TCanvas; Rect: TRect) : string;  //returns a modal type result Returns VistA name of image, or '' if abort
  var FilePath : string;
      ModalResult : integer;
      frmImageUpload :  TfrmImageUpload;
  begin
    Result := '';
    FilePath := UniqueTempSaveFilePath ('Screenshot', 'jpg');
    if not SaveCanvasToFile(Canvas, Rect, FilePath) then begin
      MessageDlg('Unable to save screenshot to file.', mtError, [mbOK], 0);
      exit;
    end;
    frmImageUpload := TfrmImageUpload.Create(Application);
    try
      frmImageUpload.Mode := umImagesOnly;
      frmImageUpload.DragAndDropFNames.Add(FilePath);
      ModalResult := frmImageUpload.ShowModal;
      if IsAbortResult(ModalResult) then begin
        if FileExists(FilePath) then DeleteFile(FilePath);
        exit;
      end;
      if frmImageUpload.UploadedImages.Count > 0 then begin
        Result := frmImageUpload.UploadedImages.Strings[0]
      end;
    finally
      frmImageUpload.Free;
    end;
  end;

  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------

  function NumPieces(const s: string; ADelim : Char) : integer;
  var List : TStringList;
  begin
    List := TStringList.Create;
    PiecesToList(S, ADelim, List);
    Result := List.Count;
    List.Free;
  end;

  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  procedure TFileInfo.Assign(Source: TFileInfo);
  begin
    SrcRec := Source.SrcRec;
    STimeStamp := Source.STimeStamp;
    SBarCode := Source.SBarCode;
    FPath := Source.FPath;
    BatchCount := Source.BatchCount;
    MetaFileName := Source.MetaFileName;
    MetaFileExists := Source.MetaFileExists;
  end;

  procedure TFileInfo.Clear;
  begin
    //SrcRec := ...   //Note sure how to clear this.  Will leave as is...
    STimeStamp := '';
    SBarCode := '';
    FPath := '';
    BatchCount := 0;
    MetaFileName := '';
    MetaFileExists := false;
  end;

  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  procedure TImageInfo.Assign(Source : TImageInfo);
  begin
    TIUIEN := Source.TIUIEN;
    DFN := Source.DFN;
    UploadDUZ := Source.UploadDUZ;
    ThumbFPathName := Source.ThumbFPathName;
    ImageFPathName := Source.ImageFPathName;
    ServerPath := Source.ServerPath;
    ServerFName := Source.ServerFName;
    ServerThumbFName := Source.ServerThumbFName;
    ShortDesc := Source.ShortDesc;
    Extension := Source.Extension;
    ImageDateTime := Source.ImageDateTime;
    UploadDateTime := Source.UploadDateTime;
    ObjectType := Source.ObjectType;
    ProcName := Source.ProcName;
    pLongDesc := Source.pLongDesc;  //this is only a pointer to object owned elsewhere
  end;

  procedure TImageInfo.Clear;
  begin
    TIUIEN := 0;
    DFN := '';
    UploadDUZ := 0;
    ThumbFPathName := '';
    ImageFPathName := '';
    ServerPath := '';
    ServerFName := '';
    ServerThumbFName := '';
    ShortDesc := '';
    Extension := '';
    ImageDateTime := '';
    UploadDateTime:= '';
    ObjectType :=0;
    ProcName := '';
    pLongDesc := nil
  end;

  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  procedure TAutoUploadNote.SetDFN(var ChartNum,Location,FName,LName,MName,DOB,Sex : string);
  var RPCResult : AnsiString;
      PMS : AnsiString;
  begin
    //Notice: ChartNum, and PMS are optional.  If PMS is 1,2,or 3, then ChartNum
    //        is used to look up patient.  Otherwise a lookup is based on just
    //        Name, DOB, Sex.
    //        To NOT use ChartNum, just set the values to ''
    //
    //Note: If LName is in form: `12345, then LName is used for DFN, and call
    //      to server for lookup is bypassed, and the values for FName,DOB etc
    //      are ignored

    if MidStr(LName,1,1)='`' then begin
      Self.Patient.DFN := MidStr(LName,2,999);
    end else begin
      //**NOTE**: site-specific code
      if Location ='Laughlin_Office' then PMS :='2'
      else if Location ='Peds_Office' then PMS :='3'
      else PMS := ''; //default

      RPCBrokerV.ClearParameters := true;
      RPCBrokerV.remoteprocedure := 'TMG GET DFN';
      RPCBrokerV.param[0].value := ChartNum;  RPCBrokerV.param[0].ptype := literal;
      RPCBrokerV.param[1].value := PMS;       RPCBrokerV.Param[1].ptype := literal;
      RPCBrokerV.param[2].value := FName;     RPCBrokerV.Param[2].ptype := literal;
      RPCBrokerV.param[3].value := LName;     RPCBrokerV.Param[3].ptype := literal;
      RPCBrokerV.param[4].value := MName;     RPCBrokerV.Param[4].ptype := literal;
      RPCBrokerV.param[5].value := DOB;       RPCBrokerV.Param[5].ptype := literal;
      RPCBrokerV.param[6].value := Sex;       RPCBrokerV.Param[6].ptype := literal;
      //RPCBrokerV.Call;
      CallBroker;
      RPCResult := RPCBrokerV.Results[0]; //returns: success: DFN;  or  error: -1^ErrMsg
      if piece(RPCResult,'^',1) <> '-1' then begin
        self.Patient.DFN := RPCResult;
      end else begin
        self.Patient.DFN := '';
      end;
    end;
  end;

  Procedure TAutoUploadNote.SetInfo(var DOS,Provider,Location,Title : string);
  //Just loads values into structure.  No validation done.
  begin
    Self.DOS := DOS;
    Self.Provider := Provider;
    Self.Location := Location;
    Self.NoteTitle := Title;
  end;

  procedure TAutoUploadNote.InitFrom(OtherNote: TAutoUploadNote; UploadedDocs: TStringList);
  //Will create a blank note for itself.
  var TIUIEN: string;
  begin
    Patient.Assign(OtherNote.Patient);
    ImageInfo.Assign(OtherNote.ImageInfo);
    Location := OtherNote.Location;
    DOS := OtherNote.DOS;
    Provider := OtherNote.Provider;
    NoteTitle := OtherNote.NoteTitle;
    CurNoteImages.Assign(OtherNote.CurNoteImages);
    TIUIEN := MakeNewBlankNote(Patient.DFN,DOS,Provider,Location,NoteTitle);
    if TIUIEN <> '-1' then UploadedDocs.Add(TIUIEN);

  end;
                                         
  function TAutoUploadNote.MakeNewBlankNote(DFN,DOS,Provider,Location,Title : string): string;
  var RPCResult : string;
  begin
    RPCResult := '';
    Result := '-1';
    Self.ErrMsg := '';    //default to no error messages

    RPCBrokerV.ClearParameters := true;
    RPCBrokerV.remoteprocedure := 'TMG GET BLANK TIU DOCUMENT';
    RPCBrokerV.param[0].value := '`'+DFN;   RPCBrokerV.param[0].ptype := literal;
    RPCBrokerV.param[1].value := Provider;  RPCBrokerV.Param[1].ptype := literal;
    RPCBrokerV.param[2].value := Location;  RPCBrokerV.Param[2].ptype := literal;
    RPCBrokerV.param[3].value := DOS;       RPCBrokerV.Param[3].ptype := literal;
    RPCBrokerV.param[4].value := Title;     RPCBrokerV.Param[4].ptype := literal;
    //RPCBrokerV.Call;
    CallBroker;
    RPCResult := RPCBrokerV.Results[0];
    try
      Result := Piece(RPCResult,'^',1);
      TIUIEN := StrToInt64(Result);    //returns:  success: TIU IEN;  or  error: -1
    except
      on E: EConvertError do begin
        Self.ErrMsg := 'WHILE CREATING BLANK NOTE FOR UPLOAD, ' + 
                       'ERROR CONVERTING: ' + RPCBrokerV.Results[0] + ' to document record #.';
        TIUIEN := -1;
      end  
    end;  
    If TIUIEN <> -1 then begin
      Self.Patient.DFN := DFN;
      Self.Provider := Provider;
      Self.Location := Location;
      Self.DOS := DOS;
    end else begin
      Self.ErrMsg := 'FAILED TO CREATE A BLANK NOTE FOR UPLOAD' +
                     '  ' + Piece(RPCResult,'^',2);
      Self.UploadError := true;      
    end;
  end;

  function TAutoUploadNote.IsValid : boolean;      
  begin
    Result := true;  //default to success.
    if (Patient.DFN='') {or (TIUIEN < 1)} or (ErrMsg <> '') or (NoteTitle = '')
    or (Location = '') or (DOS = '') or (Provider = '') then begin
      Result := false
    end;
  end;

  procedure TAutoUploadNote.Clear;
  begin
    TIUIEN := 0;
    if Patient <> nil then begin
      Patient.ClearWithoutWebsync;
    end;
    if ImageInfo <> nil then ImageInfo.Clear;
    Location := '';
    DOS := '';
    Provider := '';
    NoteTitle := '';
    UploadError := False;
    if CurNoteImages <> nil then CurNoteImages.Clear;
  end;  

  function TAutoUploadNote.SameAs(OtherNote: TAutoUploadNote): boolean;
  begin
    Result := true;
    if (OtherNote = nil) or (OtherNote.Patient = nil)
    or (Patient.DFN <> OtherNote.Patient.DFN)
    or (DOS <> OtherNote.DOS)
    or (Provider <> OtherNote.Provider)
    or (Location <> OtherNote.Location)
    or (NoteTitle <> OtherNote.NoteTitle) then begin
      Result := false;
    end;      
  end;

  constructor TAutoUploadNote.Create;
  begin
    Self.TIUIEN := 0;
    Self.Patient := TPatient.Create;
    Self.CurNoteImages := TStringList.Create;
    Self.ImageInfo := TImageInfo.Create;
    Self.Clear;
  end;

  destructor TAutoUploadNote.Destroy;
  begin
    self.patient.free;
    Self.CurNoteImages.Free;
    Self.ImageInfo.Free;
  end;

  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  function TfrmImageUpload.MakeThumbNail(Info: TImageInfo; Size : integer = 64) : boolean;
  //This takes Info.ImageFPathName and creates a 64x64 .bmp file with
  //this same name, and saves in cache directory.
  //saves name of this thumbnail in info.ThumbFPathName
  //NOTE: If Size is supplied, then thumbnail will be Size x Size in dimensions.  Min allowed is 8 pixels.
  //      Only applies to pictures, not PDF's etc.

  var
    FullRect, Rect : TRect;
    ThumbFName : AnsiString;
    //IconNumber : integer;
    //SmallIcon, LargeIcon: HIcon;
    PicH, PicW : integer;
    RectW,RectH,RecDelta : integer;
    Icon: TIcon;
    ClearPriorBMP : boolean;
  begin
    Icon := TIcon.Create;
    Bitmap.Height := size;
    Bitmap.Width := size;
    Rect.Top := 0; Rect.Left:=0; Rect.Right:=Size-1; Rect.Bottom:=Size-1;
    FullRect := Rect;
    result := false; //default of failure
    if Size < 8 then exit; //don't allow image size < 8x8 pixels.
    ClearPriorBMP := false;
    try
      //if (Pos(ExtractFileExt(Info.ImageFPathName),IMAGES)=0) or (ExtractFileExt(Info.ImageFPathName)='.pdf') then Picture.LoadFromFile(Info.ImageFPathName);
      //if the file is not in images, or if it is a pdf, use temp image
      if (Pos(UpperCase(ExtractFileExt(Info.ImageFPathName)),IMAGES)=0) or (UpperCase(ExtractFileExt(Info.ImageFPathName))='.PDF') then begin
        //LargeIcon := ExtractIcon(Application.Handle,PChar(Info.ImageFPathName),0);
        //IconImage.Handle := LargeIcon;
        //GetAssociatedIcon(Info.ImageFPathName, @LargeIcon, @SmallIcon);
        //if LargeIcon <> 0 then
        //begin
          //Icon.Handle := LargeIcon;
        //end;
        //if SmallIcon <> 0 then
        //begin
          //Icon.Handle := SmallIcon;
        //end;
        //IconNumber := frmImages.ThumbnailIndexForFName(Info.ImageFPathName);
        //frmImages.ThumbsImageList[IconNumber].
        frmImages.GetThumbnailBitmapForFName(Info.ImageFPathName,Bitmap);
        //Bitmap.Canvas.StretchDraw(Rect,frmImages.);
      end else begin
        Picture.LoadFromFile(Info.ImageFPathName);
        PicH := Picture.Graphic.Height;
        PicW := Picture.Graphic.Width;
        if PicH > PicW then begin //Target rectangle needs to be narrower.
          //Rect Wdt = PicW / PicH * Size(Ht);
          RectW := floor((PicW / PicH) * Size);
          RecDelta := Size - RectW;
          Rect.Left := RecDelta div 2;
          Rect.Right := Size - (RecDelta div 2);
          ClearPriorBMP := true;
        end else if PicW > PicH then begin //Target rectangle needs to be shorter
          //Rec H = PicH / PicW * Size(Wdt)
          RectH := floor((PicH / PicW) * Size);
          RecDelta := Size - RectH;
          Rect.Top := RecDelta div 2;
          Rect.Bottom := Size - (RecDelta div 2);
          ClearPriorBMP := true;
        end;
        if ClearPriorBMP then begin
          Bitmap.Canvas.Brush.Color := clBtnFace;
          Bitmap.Canvas.Brush.Style := bsSolid; 
          Bitmap.Canvas.FillRect(FullRect);  //ensure anything prior on canvas is cleared out.
        end;
        Bitmap.Canvas.StretchDraw(Rect, Picture.Graphic);
      end;
      ThumbFName := frmImages.CacheDir + '\Thumb-' + ExtractFileName(Info.ImageFPathName);
      ThumbFName := ChangeFileExt(ThumbFName,'.bmp');
      Bitmap.SaveToFile(ThumbFName);  //save to local cache (for upload)
      Info.ThumbFPathName := ThumbFName;  //pass info back out.
      Info.ServerThumbFName := ChangeFileExt(Info.ServerFName,'.ABS'); //format is .bmp
      result := true;
    except
      on E: Exception do exit;
   end;
   Icon.Free;
  end;

  procedure TfrmImageUpload.GetAssociatedIcon(FileName: TFilename; PLargeIcon, PSmallIcon: PHICON);
  var
    IconIndex: SmallInt;  // Position of the icon in the file
    Icono: PHICON;       // The LargeIcon parameter of ExtractIconEx
    FileExt, FileType: string;
    Reg: TRegistry;
    p: Integer;
    p1, p2: PChar;
    buffer: array [0..255] of Char;

  Label
    noassoc, NoSHELL; // ugly! but I use it, to not modify to much the original code :(
  begin
    IconIndex := 0;
    Icono := nil;
    // ;Get the extension of the file
    FileExt := UpperCase(ExtractFileExt(FileName));
    if ((FileExt = '.EXE') and (FileExt = '.ICO')) or not FileExists(FileName) then
    begin
      // If the file is an EXE or ICO and exists, then we can
      // extract the icon from that file. Otherwise here we try
      // to find the icon in the Windows Registry.
      Reg := nil;
      try
        Reg := TRegistry.Create;
        Reg.RootKey := HKEY_CLASSES_ROOT;
        if FileExt = '.EXE' then FileExt := '.COM';
        if Reg.OpenKeyReadOnly(FileExt) then
          try
            FileType := Reg.ReadString('');
          finally
            Reg.CloseKey;
          end;
        if (FileType <> '') and Reg.OpenKeyReadOnly(FileType + '\DefaultIcon') then
          try
            FileName := Reg.ReadString('');
          finally
            Reg.CloseKey;
          end;
      finally
        Reg.Free;
      end;

      // If there is not association then lets try to
      // get the default icon
      if FileName = '' then goto noassoc;

      // Get file name and icon index from the association
      // ('"File\Name",IconIndex')
      p1 := PChar(FileName);
      p2 := StrRScan(p1, ',');
      if p2 = nil then
      begin
        p         := p2 - p1 + 1; // Position de la coma
        IconIndex := StrToInt(Copy(FileName, p + 1, Length(FileName) - p));
        SetLength(FileName, p - 1);
      end;
    end; //if ((FileExt  '.EX ...

    // Try to extract the small icon
    if ExtractIconEx(PChar(FileName), IconIndex, Icono^, PSmallIcon^, 1) <> 1 then
    begin
      noassoc:
      // That code is executed only if the ExtractIconEx return a value but 1
      // There is not associated icon
      // try to get the default icon from SHELL32.DLL

      FileName := 'C:\Windows\System32\SHELL32.DLL';
      if not FileExists(FileName) then
      begin  //If SHELL32.DLL is not in Windows\System then
        GetWindowsDirectory(buffer, SizeOf(buffer));
        //Search in the current directory and in the windows directory
        FileName := FileSearch('SHELL32.DLL', GetCurrentDir + ';' + buffer);
        if FileName = '' then
          goto NoSHELL; //the file SHELL32.DLL is not in the system
      end;

      // Determine the default icon for the file extension
      if (FileExt = '.DOC') then IconIndex := 1
      else if (FileExt = '.EXE') or (FileExt = '.COM') then IconIndex := 2
      else if (FileExt = '.HLP') then IconIndex := 23
      else if (FileExt = '.INI') or (FileExt = '.INF') then IconIndex := 63
      else if (FileExt = '.TXT') then IconIndex := 64
      else if (FileExt = '.BAT') then IconIndex := 65
      else if (FileExt = '.DLL') or (FileExt = '.SYS') or (FileExt = '.VBX') or
        (FileExt = '.OCX') or (FileExt = '.VXD') then IconIndex := 66
      else if (FileExt = '.FON') then IconIndex := 67
      else if (FileExt = '.TTF') then IconIndex := 68
      else if (FileExt = '.FOT') then IconIndex := 69
      else
        IconIndex := 0;
      // Try to extract the small icon
      if ExtractIconEx(PChar(FileName), IconIndex, Icono^, PSmallIcon^, 1) <> 1 then
      begin
        //That code is executed only if the ExtractIconEx return a value but 1
        // Fallo encontrar el icono. Solo "regresar" ceros.
        NoSHELL:
        if PLargeIcon = nil then PLargeIcon^ := 0;
        if PSmallIcon = nil then PSmallIcon^ := 0;
      end;
    end; //if ExtractIconEx

    if PSmallIcon^ = 0 then
    begin //If there is an small icon then extract the large icon.
      PLargeIcon^ := ExtractIcon(Application.Handle, PChar(FileName), IconIndex);
      if PLargeIcon^ = Null then
        PLargeIcon^ := 0;
    end;
  end;

  function TfrmImageUpload.UploadFile(Info: TImageInfo; DelOrig : boolean): boolean;
  //result: true if success, false if failure
  var
    RPCResult,index              : AnsiString;
    ImageIEN                     : AnsiString;
    MsgNum                       : AnsiString;
    ErrorMsg                     : AnsiString;
    i                            : integer;
    CacheFPathName, tempFName    : string;

  begin
    //Create a record with metadata about image (required for images)
    frmFrame.timSchedule.Enabled := false;      //11/14/17 added timSchedule enabler to keep it from crashing the RPC upload
    RPCBrokerV.remoteprocedure := 'MAGGADDIMAGE';
    RPCBrokerV.Param[0].Value := '.X';
    RPCBrokerV.Param[0].PType := list;
    RPCBrokerV.Param[0].Mult['"NETLOCABS"'] := 'ABS^STUFFONLY';
    if Info.DFN <> '' then
      RPCBrokerV.Param[0].Mult['"magDFN"'] := '5^' + Info.DFN; {patient dfn}
    RPCBrokerV.Param[0].Mult['"DATETIME"'] := '7^NOW'; {date/time image collected}
    RPCBrokerV.Param[0].Mult['"DATETIMEPROC"'] := '15^' +  Info.ImageDateTime; {Date/Time of Procedure}
    if Info.ProcName <> '' then
      RPCBrokerV.Param[0].Mult['"PROC"'] := '6^' + Info.ProcName; {procedure}
    RPCBrokerV.Param[0].Mult['"DESC"'] := '10^(Hard coded Short Description)'; {image description}
    if Info.ShortDesc <> '' then
      RPCBrokerV.Param[0].Mult['"DESC"'] := '10^' + Info.ShortDesc; {image description}
    RPCBrokerV.Param[0].Mult['"DUZ"'] := '8^' + IntToStr(Info.UploadDUZ); {Duz}
    //The field (#14) below is used for images that are part of a group,
    //for example a CT exam might contain 30 images.  This field
    //contains a pointer back to the Image file (2005), to the
    //object whose type is "GROUP" that points to this object as
    //a member of its group.  A pointer to this object will be
    //found in the Object Group multiple of the parent GROUP
    //object.
    //RPCBrokerV.Param[0].Mult['"GROUP"'] := '14^' + group;
    RPCBrokerV.Param[0].Mult['"OBJTYPE"'] := '3^' + IntToStr(Info.ObjectType);
    RPCBrokerV.Param[0].Mult['"FileExt"'] := 'EXT^' + Info.Extension;
    if assigned(Info.pLongDesc) then begin
      for i := 0 to Info.pLongDesc.Count - 1 do begin
        index := IntToStr(i);
        while length(index) < 3 do index := '0' + index;
        index :='"LongDescr' + index + '"';
        RPCBrokerV.Param[0].Mult[index] := '11^' + Info.pLongDesc.Strings[i];
      end;
    end;
    CallBroker;   //MAGGADDIMAGE   returns ImageIEN^directory/filename
    if RPCBrokerV.Results.Count>0 then RPCResult := RPCBrokerV.Results.Strings[0];

    ImageIEN := Piece(RPCResult,'^',1);
    Info.IMAGEIEN := StrToIntDef(ImageIEN,0);
    result := ((ImageIEN <> '0') and (ImageIEN <> ''));  // function result.
    if result=false then begin
      ErrorMsg := 'Server Error: Couldn''t store image information.'+ #13 + Piece(RPCResult,'^',2);
      MessageDlg(ErrorMsg,mtWarning,[mbOK],0);
      frmFrame.timSchedule.Enabled := True;
      exit; //returns FALSE
    end;

    //Now actually send image up to server
    Info.ServerPath := Piece(RPCResult,'^',2);
    Info.ServerFName := Piece(RPCResult,'^',3);
    result := frmImages.UploadFile(Info.ImageFPathName,Info.ServerPath,Info.ServerFName,1,1);
    if result=false then begin
      ErrorMsg := 'Error uploading image to server.'+ #13 + Piece(RPCResult,'^',2);
      MessageDlg(ErrorMsg,mtWarning,[mbCancel],0);
      frmFrame.timSchedule.Enabled := true;
      exit;  //Returns FALSE
    end;

    if Info.TIUIEN > 0 then begin
      //Now Associate Image with a TIU Note
      //NOTE: Universal images don't get linked to TIU note for now, so TIUIEN set to 0 elsewhere
      RPCBrokerV.remoteprocedure := 'MAG3 TIU IMAGE';
      RPCBrokerV.param[0].ptype := literal;
      RPCBrokerV.param[0].value := ImageIEN;
      RPCBrokerV.Param[1].ptype := literal;
      RPCBrokerV.param[1].value := IntToStr(Info.TIUIEN);
      CallBroker;  //MAG3 TIU IMAGE
      RPCResult := RPCBrokerV.Results[0];
      //returns:  success:  1^message;  or  error:  0^error message
      MsgNum := Piece(RPCResult,'^',1);
      result := (MsgNum = '1');
      if result=false then begin
        ErrorMsg := 'Error associating image with note.' + #13 + Piece(RPCResult,'^',2);
        MessageDlg(ErrorMsg,mtWarning,[mbCancel],0);
        frmFrame.timSchedule.Enabled := True;
        exit;  //Returns FALSE
      end;
    end;

    //Copy the file into the cache directory, so that we don't have to turn around and download it again.
    CacheFPathName := uHTMLTools.CPRSDir + '\cache\' + ExtractFileName (Info.ServerFName);
    if not FileExists(CacheFPathName) then begin
      tempFName := Info.ImageFPathName;
      CopyFile(PChar(tempFName),PChar(CacheFPathName),FALSE);
    end;
    if MakeThumbNail(Info, THUMBNAIL_SIZE[FUploadMode]) then begin;
      result := frmImages.UploadFile(Info.ThumbFPathName,Info.ServerPath,Info.ServerThumbFName,1,1);
      if result=false then begin
        ErrorMsg :='Error sending thumbnail image to server.'+ #13 + Piece(RPCResult,'^',2);
        MessageDlg(ErrorMsg,mtWarning,[mbOK],0);
      end;
      CacheFPathName := uHTMLTools.CPRSDir + '\cache\' + ExtractFileName (Info.ServerFName);
      if not FileExists(CacheFPathName) then begin
        CopyFile(PChar(Info.ImageFPathName),PChar(CacheFPathName),FALSE);
      end;
      if DelOrig=true then begin
        DeleteFile(Info.ImageFPathName);
      end;
    end;
    if (MoveCheckBox.Visible) and (MoveCheckBox.Checked) then begin
      DeleteFile(Info.ImageFPathName);
    end;
    frmFrame.timSchedule.Enabled := True;
    //returns: result
  end;


  procedure TfrmImageUpload.UploadChosenFiles();
  var i : integer;
      Info: TImageInfo;

  begin
    Info := TImageInfo.Create();
    Info.pLongDesc := nil;

    //Load up info class/record
    Info.ShortDesc := MidStr(ShortDescEdit.Text,1,60);
    if Info.ShortDesc = DefShortDesc then Info.ShortDesc := ' ';
    Info.UploadDUZ := User.DUZ;
    if LongDescMemo.Lines.Count>0 then begin
      Info.pLongDesc := LongDescMemo.Lines;
    end;
    Info.ObjectType := 1; //type 1 is Still Image (jpg).  OK to use with .bmp??
    if FUploadMode = umPatientID then begin
      Info.ProcName := 'PHOTO ID'; //max length is 10 characters
    end else if FUploadMode = umSigImage then begin
      Info.ProcName := 'SIGNATURE'; //max length is 10 characters
    end else begin
      Info.ProcName := 'Picture'; //max length is 10 characters
    end;
    Info.ImageDateTime := DateTimeEdit.Text;
    if FUploadMode in [umUniversal, umPatientID, umSigImage] then begin
      Info.TIUIEN := 0;
    end else begin
      //if CallingForm = 'frmDCSumm' then
        //Info.TIUIEN := frmDCSumm.lstSumms.ItemID
      //else
      Info.TIUIEN := frmNotes.lstNotes.ItemID;
    end;
    Info.UploadDateTime := 'NOW';
    Info.DFN := Patient.DFN;

    for i:= 0 to FilesToUploadList.Items.Count-1 do begin
      Info.ImageFPathName := FilesToUploadList.Items.Strings[i];
      Info.Extension := ExtractFileExt(Info.ImageFPathName); //includes '.'
      Info.Extension := MidStr(Info.Extension,2,99); //remove '.'  //changed 17 --> 99
      if UploadFile(Info,MoveCheckBox.Checked) then begin   //Upload function passes back filename info in Info class
        FUploadedImagesList.Add(Info.ServerFName);
        FUploadedImagesIENList.Add(IntToStr(Info.IMAGEIEN)); //1:1 relief between two lists
        if (FUploadMode = umSigImage) then LinkSignatureImage(Info);
      end else begin
        //Application.MessageBox('Error uploading image file!','Error');
      end;
    end;
    Info.Free;
    frmImages.NumImagesAvailableOnServer := NOT_YET_CHECKED_SERVER;   //Forces re-query of server
  end;

  procedure TfrmImageUpload.LinkSignatureImage(var Info: TImageInfo);
  begin
    //Set up link in file TMG IMAGE ESIG
    CallV('TMG CPRS STORE ESIG IMAGE',[User.DUZ, Info.IMAGEIEN]);
  end;

  procedure TfrmImageUpload.LoadNotesEdit();
  begin
    if FUploadMode in [umUniversal, umPatientID, umSigImage] then begin
      NoteEdit.Text := '';
    end else begin
      //if CallingForm = 'frmDCSumm' then
        //NoteEdit.Text := frmDCSumm.tvSumms.Selected.Text
      //else
      NoteEdit.Text := frmNotes.tvNotes.Selected.Text;
    end;
  end;

  {
  procedure TImageUploadForm.LoadNotesList();
  var
    NoteInfo,s,dateS : AnsiString;
    i : integer;
  const
    U='^';
  begin
    NoteComboBox.Items.Clear;

    for i := 0 to frmNotes.lstNotes.Count-1 do with frmNotes.lstNotes do begin
      NoteInfo := Items[i];
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
      dateS := Piece(Piece(NoteInfo, U, 8), ';', 2);
      s := FormatFMDateTime('mmm dd,yy@hh:nn', MakeFMDateTime(dateS)) + ' -- ';
  //    s := Piece(Piece(NoteInfo, U, 8), ';', 1) + ' -- ';
      s := s + Piece(NoteInfo, U, 2) + '; ';
      s := s + 'Author: ' + Piece(Piece(NoteInfo, U, 5), ';', 2) + ', ';
      s := s + Piece(NoteInfo, U, 6);
      NoteComboBox.Items.Add(s);
    end;
    NoteComboBox.ItemIndex := frmNotes.lstNotes.ItemIndex;
  end;
  }
  //Delphi events etc.------------------------------------------------

  procedure TfrmImageUpload.UploadButtonClick(Sender: TObject);
  begin
    try
      WebBrowser.Navigate(frmImages.NullImageName);
      sleep(500); //Give Webbrowser time to release any browsed document.
    except
      on E: Exception do exit;
    end;
    UploadChosenFiles();
    Self.Mode := umAnyFile;
    //note This UploadButton has .ModalResult = mrOK, so form is closed after this.
  end;

  procedure TfrmImageUpload.PickImagesButtonClick(Sender: TObject);
  var i : integer;
  begin
    If OpenPicDialog.Execute then begin
      if FUploadMode in [umUniversal, umPatientID, umSigImage] then begin
        FilesToUploadList.Clear;  //only allow one file at a time.
        OpenPicDialog.Options := OpenPicDialog.Options - [ofAllowMultiSelect];
      end else begin
        OpenPicDialog.Options := OpenPicDialog.Options + [ofAllowMultiSelect];
      end;
      for i := 0 to OpenPicDialog.Files.Count-1 do begin
        FilesToUploadList.Items.Add(OpenPicDialog.Files.Strings[i]);
      end;
      FilesToUploadList.ItemIndex := FilesToUploadList.Count-1;
      FilesToUploadListClick(self);
    end;
  end;

  procedure TfrmImageUpload.btnPickOtherClick(Sender: TObject);
  var i : integer;
  begin
    If OpenFileDialog.Execute then begin
      for i := 0 to OpenFileDialog.Files.Count-1 do begin
        if (UpperCase(ExtractFileExt(OpenFileDialog.Files.Strings[i])) = '.EXE') or
           (UpperCase(ExtractFileExt(OpenFileDialog.Files.Strings[i])) = '.BAT') then begin
          messagedlg('.exe and .bat files are not allowed',mtError,[mbOK],0);
          continue;
        end;
        FilesToUploadList.Items.Add(OpenFileDialog.Files.Strings[i]);
      end;
    end;
  end;

  procedure TfrmImageUpload.btnPickPDFClick(Sender: TObject);
  var i : integer;
      frmImagePickPDF: TfrmImagePickPDF;
  begin
    //if not Assigned(frmImagePickPDF) then begin
      frmImagePickPDF := TfrmImagePickPDF.Create(Self);   //free'd in OnHide  <-- no longer true
    //end;
    if frmImagePickPDF.Execute then begin
      for i := 0 to frmImagePickPDF.Files.Count-1 do begin
        FilesToUploadList.Items.Add(frmImagePickPDF.Files.Strings[i]);
      end;
    end;
    frmImagePickPDF.Free;
  end;

  procedure TfrmImageUpload.btnPickStockClick(Sender: TObject);
  var  FName : string;
       i : integer;
  begin
    //Set OpenPicDialog default directory to the specified Stock Images Folder
    OpenPicDialog.InitialDir := uTMGOptions.ReadString('Stock Directory','P:\vista\vista-art\stock_images');
    If OpenPicDialog.Execute then begin
      for i := 0 to OpenPicDialog.Files.Count-1 do begin
        FName := OpenPicDialog.Files.Strings[i];
        FName := CopyFileToTemp(FName);
        if FName = '' then begin
          MessageDlg('Unable to copy stock image for use.',mtError,[mbOK],0);
          continue;
        end;
        FilesToUploadList.Items.Add(FName);
      end;
      FilesToUploadList.ItemIndex := FilesToUploadList.Count-1;
      FilesToUploadListClick(self);
    end;
  end;

  procedure TfrmImageUpload.FormShow(Sender: TObject);
  var i : integer;
  begin
    FormRefresh(self);
    FilesToUploadList.Items.Clear;
    FUploadedImagesList.Clear;
    FUploadedImagesIENList.Clear;
    LoadNotesEdit();
    ShortDescEdit.Text := DefShortDesc;
    btnConfigEditor.Enabled := false;
    btnEditImage.Enabled := false;
    //MoveCheckbox.Checked := true;
    if DragAndDropFNames.Count > 0 then begin
     for i := 0 to DragAndDropFNames.Count - 1 do begin
       FilesToUploadList.Items.Add(DragAndDropFNames.Strings[i]);
     end;
     DragAndDropFNames.clear;
     FilesToUploadList.ItemIndex := FilesToUploadList.Count-1;
     FilesToUploadListClick(self);
    end;
  end;

  procedure TfrmImageUpload.ShortDescEditChange(Sender: TObject);
  begin
    if Length(ShortDescEdit.Text)> 60 then begin
      ShortDescEdit.Text := MidStr(ShortDescEdit.Text,1,60);
    end;
  end;

  procedure TfrmImageUpload.ClearImagesButtonClick(Sender: TObject);
  var FName : string;
  begin
    if FilesToUploadList.ItemIndex > -1 then begin
      FName := FilesToUploadList.Items.Strings[FilesToUploadList.ItemIndex];
      if MessageDlg('Clear: '+FName+'?'+#13#10+
                 '(Any editing changes will be lost.)',
                 mtConfirmation,mbOKCancel,0) <> mrOK then exit;
      FilesToUploadList.Items.Delete(FilesToUploadList.ItemIndex);
      FilesToUploadList.ItemIndex := -1;
      FilesToUploadListClick(self);
    end else begin
      if MessageDlg('Clear ALL files?'+#13#10+
                 '(Any editing changes will be lost.)',
                 mtConfirmation,mbOKCancel,0) <> mrOK then exit;
      FilesToUploadList.Items.Clear;
      FilesToUploadListClick(self);
    end;
  end;

  procedure TfrmImageUpload.FormCreate(Sender: TObject);
  begin
    DragAndDropFNames := TStringList.Create;
    Bitmap := TBitmap.Create;
    Bitmap.Height := 64;
    Bitmap.Width := 64;
    Picture := TPicture.Create;
    SavedMoveFilesValue := true;
    FUploadMode := umAnyFile;
    FUploadedImagesList := TStringList.Create;
    FUploadedImagesIENList := TStringList.Create;
    //CallingForm := 'frmNotes';

    AutoUploadNote := TAutoUploadNote.Create;
    FScanDir := uTMGOptions.ReadString('Pol Directory','??');
    if FScanDir='??' then begin
      FScanDir := ExtractFileDir(Application.ExeName);
      uTMGOptions.WriteString('Pol Directory',FScanDir);
    end;
    PolInterval := uTMGOptions.ReadInteger('Pol Interval (milliseconds)',0);
    if PolInterval=0 then begin
      PolInterval := 60000;
      uTMGOptions.WriteInteger('Pol Interval (milliseconds)',PolInterval);
    end;
    //DragAcceptFiles(Handle, True); //kt 4/15/14
    DragAcceptFiles(FilesToUploadList.Handle, True); //kt 4/15/14
    UploadedDocs := TStringList.Create;
  end;

  procedure TfrmImageUpload.SetScanDir(NewDir : string);
  begin
    if DirectoryExists(NewDir) then begin
      FScanDir := NewDir;
      uTMGOptions.WriteString('Pol Directory',FScanDir);
    end;
  end;

  procedure TfrmImageUpload.FormDestroy(Sender: TObject);
  begin
    DragAndDropFNames.Free;
    Bitmap.Free;
    Picture.Free;
    FUploadedImagesList.Free;
    FUploadedImagesIENList.Free;
    DragAcceptFiles(FilesToUploadList.Handle, False); //kt 4/15/14
    UploadedDocs.free;
  end;

  procedure TfrmImageUpload.FilesToUploadListClick(Sender: TObject);
  var
    FileName:  AnsiString;
    SelectedItem: integer;
  begin
    SelectedItem := FilesToUploadList.ItemIndex;
    if SelectedItem > -1 then begin
      FileName := FilesToUploadList.Items[SelectedItem];
      if UpperCase(ExtractFileExt(FileName))='.PDF' then begin
        FileName := CopyFileToTemp(FileName,True);  //returns '' if copy fails
        if FileName = '' then FileName := frmImages.NullImageName;
      end;
      btnEditImage.Enabled := True;
      btnConfigEditor.Enabled := True;
    end else begin
      FileName := frmImages.NullImageName;
      btnEditImage.Enabled := False;
      btnConfigEditor.Enabled := False;
    end;
    try
      WebBrowser.Navigate(FileName);
    except
      on E: Exception do exit;
    end;
  end;

  function TfrmImageUpload.CopyFileToTemp(FNamePath : string;TempBrowseable : boolean) : string;
  var DestFile : string;
      lpDestFile : PAnsiChar;
      lpSourceFile : PAnsiChar;
  begin
    if TempBrowseable then begin
      DestFile := frmImages.CacheDir + '\tempbrowseable' + ExtractFileExt(FNamePath);
    end else begin
      DestFile := frmImages.CacheDir + '\' + ExtractFileName(FNamePath);
    end;
    lpDestFile := PAnsiChar(DestFile);
    lpSourceFile := PAnsiChar(FNamePath);
    if CopyFile(lpSourcefile,lpDestFile,LongBool(FALSE)) = TRUE then begin  //0=success
      Result := DestFile;
    end else begin
      Result := '';
    end;
  end;

  procedure TfrmImageUpload.FormRefresh(Sender: TObject);
  begin
    try
      WebBrowser.Navigate(frmImages.NullImageName);
    except
      on E: Exception do exit;
    end;
  end;

  procedure TfrmImageUpload.FormHide(Sender: TObject);
  begin
    FormRefresh(Sender);
    //frmImagePickPDF.Free;
    //frmImagePickPDF := nil;
    FUploadMode := umAnyFile;
  end;

  procedure TfrmImageUpload.DecodeImgTxt(Line : string; out ChartNum, Location,
                           FName, LName, MName, Sex, DOB, DOS, Provider,
                           Title : string; FilePaths : TStrings);
  //format of line is as follows:
  //ChartNum^Location^FName^LName^MName^Sex^DOB^DOS^Provider^Title^FilePath(s)
  //NOTE: To provide patient IEN instead of FName etc, use this format:
  //      ^Location^^`1234567^^^^DOS^Provider^Title^FilePath(s)
  //      i.e. `IEN  (note ` is not an appostrophy ('))
  //      `IEN in place of LName, and leave blank: ChartNum,FName,FName,Sex,DOB
                           
  var Files: String;                           
      FileName : String;
      num,i : integer;
  begin
    if Pos('}',Line)>0 then begin
      Line := Piece(Line,'}',2);  //If error message is present, still allow parse.
    end;
    ChartNum := Piece(Line,'^',1);
    Location := Piece(Line,'^',2);
    FName := Piece(Line,'^',3);
    LName := Piece(Line,'^',4);
    MName := Piece(Line,'^',5);
    Sex := Piece(Line,'^',6);
    DOB := Piece(Line,'^',7);
    DOS := Piece(Line,'^',8);
    Provider := Piece(Line,'^',9);
    Title := Piece(Line,'^',10);
    Files := Piece(Line,'^',11); //may be list of multiple files separated by ;
    if Pos(';',Files)>0  then begin
      num := NumPieces(Files,';');
      for i := 1 to num do begin
        FileName := piece(files,';',i);
        if FileName <> '' then FilePaths.Add(FileName);
      end;  
    end else begin
      FilePaths.Add(Files);
    end;
      
  end;  

  function TfrmImageUpload.EncodeImgTxt(ChartNum, Location, FName, LName, MName, Sex, DOB,
                           DOS, Provider, Title : string; FilePaths : TStrings) : AnsiString;
  //format of line is as follows:
  //ChartNum^Location^FName^LName^MName^Sex^DOB^DOS^Provider^Title^FilePath(s)
  //NOTE: To provide patient IEN instead of FName etc, use this format:
  //      ^Location^^`1234567^^^^DOS^Provider^Title^FilePath(s)
  //      i.e. `IEN  (note ` is not an appostrophy ('))
  //      `IEN in place of LName, and leave blank: ChartNum,FName,FName,Sex,DOB
  var i : integer;
  begin
    Result := ChartNum + '^' + Location + '^' + FName + '^' + LName + '^' +
              MName + '^' + Sex + '^' + DOB + '^' + DOS + '@01:00' + '^' + Provider + '^' +
              Title + '^';    //added time of 1:00    elh   7/8/08
    for i:= 0 to FilePaths.Count-1 do begin
      Result := Result + FilePaths.Strings[i];
      if i <> FilePaths.Count-1 then Result := Result + ';';
    end;
  end;                           

  
  procedure TfrmImageUpload.FinishDocument(UploadNote : TAutoUploadNote);
  var Text : TStringList;
      ErrMsg : String;
      RPCResult : String;
      i : integer;
      oneImage: string;
      //TIUIEN : int64;
        
  begin
    if (UploadNote.TIUIEN>0) and (UploadNote.CurNoteImages.Count>0) 
    and (UploadNote.UploadError = False) then begin
      //Add text for note: "See scanned image" --
      //   or later, some HTML code to show note in CPRS directly....
      Text := TStringList.Create;
      Text.Add('<!DOCTYPE HTML PUBLIC>');
      Text.Add('<html>');
      Text.Add('<head>');
      Text.Add('<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
      Text.Add('<title>VistA HTML Note</title>');
      Text.Add('</head>');
      Text.Add('<body>');
      Text.Add('<p>');
      Text.Add('Note created automatically from imported media.');
      Text.Add('<p>');
      for i := 0 to UploadNote.CurNoteImages.Count-1 do begin
        // note: CPRS_DIR_SIGNAL ('$CPRSDIR$') will be replaced at runtime with directory of CPRS
        // This will be done as page is passed to TWebBrowser (in uHTMLTools)
        oneImage := CPRS_CACHE_DIR_SIGNAL + UploadNote.CurNoteImages.Strings[i];
        Text.Add('<img WIDTH=640 HEIGHT=836 src="'+oneImage+'">');
        Text.Add('<p>');
      end;
      //Text.Add('<small>');
      //Text.Add('If images don''t display, first view them in IMAGES tab.<br>');
      //Text.Add('Then return here, click on note and press [F5] key to refresh.');
      //Text.Add('</small>');
      //Text.Add('<p>');
      Text.Add('</body>');
      Text.Add('</html>');
      Text.Add(' ');
      rTIU.SetText(ErrMsg,Text,UploadNote.TIUIEN,0);  //elh changed from 1 to 0 //1=commit data, do actual save.
      Text.Free;
      //Here I autosign 
      //To exclude a document title from autosign, RPC will check TMG CPRS EXCLUDE AUTOSIGN
      //field in File 8925.1
      RPCBrokerV.ClearParameters := true;
      RPCBrokerV.remoteprocedure := 'TMG AUTOSIGN TIU DOCUMENT';
      RPCBrokerV.param[0].value := IntToStr(UploadNote.TIUIEN);
      RPCBrokerV.param[0].ptype := literal;
      //RPCBrokerV.Call;
      CallBroker;
      if RPCBrokerV.Results.Count > 0 then begin
        RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
      end else begin
        RPCResult := '-1';
      end;
      if RPCResult='-1' then begin
        MessageDlg('Unable to set status for scanned document to SIGNED',mtError,[mbOK],0);
      end;
      UploadNote.TIUIEN := 0;
    end;
    UploadNote.Clear;
  end;


  function TfrmImageUpload.ProcessOneLine(Line : string) : string;
  //Returns: if success, '';  if failure, returns reason

  //format of line is as follows:
  //ChartNum^Location^FName^LName^MName^Sex^DOB^DOS^Provider^Title^FilePath(s)
  //NOTE: To provide patient IEN instead of FName etc, use this format:
  //      ^Location^^`1234567^^^^DOS^Provider^Title^FilePath(s)
  //      i.e. `IEN  (note ` is not an appostrophy ('))
  //      `IEN in place of LName, and leave blank: ChartNum,FName,FName,Sex,DOB
    
  var
    ChartNum,FName,LName,MName,Sex,DOB  : String;
    DOS,Provider,Title : String;
    ThisNote : TAutoUploadNote;
    FilePaths : TStringList;
    i : integer;
    Location : string;

  begin
    Result := '';  //default to success for function
    ThisNote := TAutoUploadNote.Create;
    FilePaths := TStringList.Create();
    DecodeImgTxt(Line, ChartNum, Location, FName, LName, MName, Sex, DOB, DOS, Provider, Title, FilePaths);
      
    ThisNote.SetDFN(ChartNum,Location,FName,LName,MName,DOB,Sex);
    ThisNote.SetInfo(DOS,Provider,Location,Title);
    if Pos('//Failed',Line)>0 then ThisNote.UploadError := true;
    if ThisNote.IsValid then begin  //A note can be 'Valid' and still have an 'UploadError'
      if ThisNote.SameAs(AutoUploadNote)= false then begin
        ThisNote.TIUIEN := AutoUploadNote.TIUIEN;
        FinishDocument(AutoUploadNote);  // Close and clear any existing note
        AutoUploadNote.InitFrom(ThisNote,UploadedDocs);
        Result := AutoUploadNote.ErrMsg; //'' if no error
      end;
      if ThisNote.UploadError then AutoUploadNote.UploadError := true;
      if (AutoUploadNote.UploadError=false) then for i := 0 to FilePaths.Count-1 do begin
        AutoUploadNote.ImageInfo.pLongDesc := nil;
        //Load up info record with data for upload
        AutoUploadNote.ImageInfo.ShortDesc := 'Scanned document';
        AutoUploadNote.ImageInfo.UploadDUZ := User.DUZ;
        AutoUploadNote.ImageInfo.ObjectType := 1; //type 1 is Still Image (jpg).  OK to use with .bmp??
        AutoUploadNote.ImageInfo.ProcName := 'Scanned'; //max length is 10 characters
        AutoUploadNote.ImageInfo.ImageDateTime := DOS;
        AutoUploadNote.ImageInfo.TIUIEN := AutoUploadNote.TIUIEN;
        AutoUploadNote.ImageInfo.UploadDateTime := 'NOW';
        AutoUploadNote.ImageInfo.DFN := AutoUploadNote.Patient.DFN;
        AutoUploadNote.ImageInfo.ImageFPathName := FilePaths.Strings[i];
        AutoUploadNote.ImageInfo.Extension := ExtractFileExt(AutoUploadNote.ImageInfo.ImageFPathName); //includes '.'
        AutoUploadNote.ImageInfo.Extension := MidStr(AutoUploadNote.ImageInfo.Extension,2,17); //remove '.'
        if not UploadFile(AutoUploadNote.ImageInfo,true) then begin   //Upload function passes back filename info in Info class
          Result := 'ERROR UPLOADING IMAGE FILE';
        end;    
        AutoUploadNote.CurNoteImages.Add(AutoUploadNote.ImageInfo.ServerFName);
      end else begin
        If Result='' then Result := '(Error found in earlier file entry in batch)';
      end;
    end else begin
      Result := 'NOTE INFO INVALID (Probably: PATIENT NOT FOUND)';
    end;
    FilePaths.Free;
    ThisNote.Free;
  end;

  
  function TfrmImageUpload.ProcessOneFile(FileName : string) : boolean;
  //This will process image(s) indicated in textfile FileName
  //After uploading image to server, textfile and specified images are deleted
  //Returns Success
  //Note: To upload multiple images into one document, one may add multiple
  //      lines to the ImgTxt text file.  As long as the info is the same
  //      (i.e. same provider, patient, note type, DOS etc) then they
  //      will be appended to current note.
  //      OR, add multiple image file names to one line.
  //        -- the problem with multiple images on one line is that errors
  //        can not be reported for just one image.  It will be ONE for any/all
  //      OR, if the next file in process-order is still has the same info as
  //        the prior file, then it will be appended.
  var
    Lines : TStringList;
    i : integer;
    ResultStr : string;
    OneLine : string;
  begin 
    Result := true;  //default is Success=true
    Lines := TStringList.Create;
    Lines.LoadFromFile(FileName);
    //FinishDocument(AutoUploadNote);  //will save and clear any old data.
    for i := 0 to Lines.Count-1 do begin
      OneLine := Lines.Strings[i];
      ResultStr := ProcessOneLine(OneLine);  //Even process with //failed markeers (to preserve batches)
      if Pos('//Failed',OneLine)> 0 then begin  //If we already have //Failed, don't duplicate another Error Msg
        Result := false;  //prevent deletion of file containing //Failed//      
      end else begin
        if ResultStr <> '' then begin
          Lines.Strings[i] := '//Failed: '+ResultStr+'}'+Lines.Strings[i];
          Lines.SaveToFile(FileName);
          Result := false;
        end;  
      end;
    end;
    //Temp, for debugging
    //Lines.SaveToFile(ChangeFileExt(FileName,'.imgtxt-bak'));
    //end temp    
    Lines.free;
  end;

  
  procedure TfrmImageUpload.ScanAndHandleImgTxt;
  var
    FoundFile : string;
    tempFileName : string;
    Found : TSearchRec;
    FilesList : TStringList;
    i         : integer;
    //result : boolean;
  begin
    //NOTE: Later I may make this spawn a separate thread, so that
    //  user doesn't encounter sudden unresponsiveness of CPRS
    //I can use BeginThread, then EndTread
    //Issues: ProcessOneFile would probably have to be a function
    //  not in a class/object...
      
    FilesList := TStringList.Create;

    //scan for new *.ImgTxt file
    //FindFirst may not have correct order, so collect all names and then sort.
    if FindFirst(FScanDir+'*.imgtxt',faAnyFile,Found)=0 then repeat
      //Ensure that the corresponding image file exists for each imgtxt file
      //If it doesn't delete the imgtxt file (to ensure no residual imgtxt files
      //create blank notes).       elh    10/28/10
      tempFileName:=FScanDir+Found.Name;
      if FileExists(ChangeFileExt(tempFileName,'.png')) then begin
        FilesList.Add(FScanDir+Found.Name);
      end else begin
        DeleteFile(tempFileName);
      end;
    until FindNext(Found) <> 0;   
    FindClose(Found);  
    FilesList.Sort;  //puts filenames in alphanumeric order

    //Now process images in correct order.
    for i := 0 to FilesList.Count-1 do begin
      FoundFile := FilesList.Strings[i];
      if ProcessOneFile(FoundFile) = true then begin  {process *.imgtxt file}
        DeleteFile(FoundFile); 
        FoundFile := ChangeFileExt(FoundFile,'.barcode.txt');
        DeleteFile(FoundFile);
      end; //Note: it is OK to continue, to get other non-error notes afterwards.
    end;
    FinishDocument(AutoUploadNote);  // Close and clear any existing note
    FilesList.Free
  end;


  procedure TfrmImageUpload.ScanAndHandleImages;
  (*  Overview of mechanism of action of automatically uploading images.
      =================================================================
    -- For an image to be uploaded, it must first be positively identified.
       This can occur 1 of two ways:
         -- the image contains a datamatrix barcode.
         -- the image is part of a batch, and the first image of the batch
            contains a barcode for the entire batch.
    -- At our site, the scanner program automatically names the files numerically
       so that sorting on the name will put them in proper order when working
       with batches.
    -- The decoding of the barcode requires a special program.  I was not
       able to find a way to run this on the Windows client.  I found the
       libdmtx that does this automatically.  It currently is on unix only.
       It was too complicated for me to compile it for windows.  I initially
       wanted everything to run through the RPC broker.  This involved
       uploading the image to the linux server, running the decoder on the
       server, then passing the result back.  The code for this is still avail
       in this CPRS code.  However, the process was too slow and I had to
       come up with something faster.  So the following arrangement was setup
        -- scanned images are stored in a folder that was shared by both the
           windows network (and thus is available to CPRS), and the linux server.
        -- At our site, we used a copier/scanner unit that created only TIFF
           files.  These are not the needed format for the barcode decoder, so...
        -- a cron job runs on the linux server that converts the .tif files
           to .png.  Here is that script:
             <removed due to frequent changes...>
           ---------------------------------
        -- Next the .png files must be checked for a barcode.  Another cron
           task scans a directory for .png files and creates a metafile for
           the file giving its barcode reading, or a marker that there is
           no barcode available for that image.  The file name format is:
           *.barcode.txt, with the * coorelating to filename of the image.
           -- The decoding process can take some time (up to several minutes
              per image.
           -- A flag file named barcodeRead.working.txt is created when the
              script is run, and deleted when done.  So if this file is present
              then the decoding process is not complete.
           -- if a *.barcode.txt file is present, then no attempts will be made
              to decode the image a second time.
           -- CPRS still contains code to upload an image to look for a barcode.
              At this site, only png's will contain barcodes, so I have commented
              out support for automatically uploading other file formats.
           -- Here is the unix bash script that decodes the barcodes.  It is 
              launched by cron:
           ---------------------------------
             <removed due to frequent changes...>
           ---------------------------------
    -- After the *.png images are available, and no flag files are present
       to indicate that the server is working with the files, then the images
       are processed, using the barcode metafiles.  This is triggered by a
       timer in CPRS.  It essentially converts imagename + barcode data -->
       --> *.imgtxt.
    -- For each *.png image, there will be a *.imgtxt metafile created.  This
       will contain information needed by the server, in a special format for
       the RPC calls.  When an *.imgtxt file is present, this is a flag that
       the image is ready to be uploaded.
    -- A timer in CPRS scans for *.imgtxt files.  When found, it uploads the
       image to the server and creates a container progress note for displaying
       it in CPRS.
 *)
  
    procedure ScanOneImageType(ImageType : string);
    //Scan directory for all instances of images of type ImageType
    //For each one, create a metadata file (if not already present)

    //Note: Batch mode only works for a batch of file ALL OF THE SAME TYPE.
    //I.e. There can't be a batch of .jpg, then .gif, then .bmp.  This is
    //because a scanner, if it is scanning a stack of documents for a given
    //patient will produce all files in the same ImageType

      function DeltaMins(CurrentTime,PriorTime : TDateTime) : integer;
        //Return ABSOLUTE difference in minutes between Current <--> Prior.
        //NOTE: if value is > 1440, then 1440 is returned
      var DeltaDays,FracDays : double;  
      begin
        DeltaDays := abs(CurrentTime-PriorTime);
        FracDays := DeltaDays - Round(DeltaDays);
        if DeltaDays>1 then FracDays := 1;
        Result := Round((60*24)*FracDays);
      end;

    var
      FoundFile : string;
      MetaFilename : string;
      Found : TSearchRec;
      //BarCodeData : AnsiString;
      DFN,DOS,AuthIEN,LocIEN,NoteTypeIEN : string;
      OneLine : string;
      FilePaths : TStringList;
      AllFiles : TStringList;
      OutFileLines : TStringList;
      BatchS : string;
      //tempCount : integer;
      BatchFInfo : TFileInfo;
      LastFileTimeStamp,CurFileTimeStamp : TDateTime;
      DeltaMinutes : integer;
      pFInfo : TFileInfo;
      i : integer;
    Label AbortPoint;      

    const
      ALLOWED_TIME_GAP = 2;  //time in minutes

    begin    
      FilePaths := TStringList.Create;
      OutFileLines := TStringList.Create;
      AllFiles := TStringList.Create;
      BatchFInfo := TFileInfo.Create;
      
      //NOTE: Later I may make this spawn a separate thread, so that
      //  user doesn't encounter sudden unresponsiveness of CPRS
      //I can use BeginThread, then EndTread
      //Issues: ProcessOneFile would probably have to be a function
      //  not in a class/object...

      //scan for all instances *.ImageType Image file
      //Store info for processesing after loop
      //Do this as a separate step, so files can be processed in proper order
      if FindFirst(FScanDir+'*.'+ImageType,faAnyFile,Found)=0 then repeat
        FoundFile := FScanDir+Found.Name;
        if FileExists(ChangeFileExt(FoundFile,'.imgtxt')) then continue;
        MetaFilename := ChangeFileExt(FoundFile,'.barcode.txt');
        pFInfo := TFileInfo.Create;  //will be owned by AllFiles
        pFInfo.MetaFileName := MetaFilename;
        pFInfo.FPath := FoundFile;
        pFInfo.SrcRec := Found;
        pFInfo.STimeStamp := FloatToStr(FileDateToDateTime(Found.Time));
        pFInfo.MetaFileExists := FileExists(MetaFilename);
        pFInfo.SBarCode := '';  //default to empty.
        pFInfo.BatchCount := 0;        
        if pFInfo.MetaFileExists = false then begin
          //Call server via RPC to decode Barcode
          //This is too slow and buggy.  Will remove for now...
          //BarCodeData := frmImages.DecodeBarcode(FoundFile,ImageType);
          //pFInfo.SBarCode := BarCodeData;
          pFInfo.SBarCode := '';
          //Here I could optionally create a Metafile for processing below.
        end;
        if pFInfo.MetaFileExists then begin  //Retest in case RPC changed status.
          if FileExists(FScanDir+'barcodeRead.working.txt') then goto AbortPoint;
          OutFileLines.LoadFromFile(pFInfo.MetaFileName);
          if OutFileLines.Count>0 then begin
            pFInfo.SBarCode := OutFileLines.Strings[0];
            //convert 'No Barcode message into an empty string, to match existing code.            
            if Pos('//',pFInfo.SBarCode)=1 then pFInfo.SBarCode := '';
            if NumPieces(pFInfo.SBarCode,'-') <> 8 then pFInfo.SBarCode := '';  
          end else begin
            pFInfo.MetaFileExists := false;  //set empty file to Non-existence status
          end;
        end;
        AllFiles.AddObject(pFInfo.FPath,pFInfo);  //Store filename, to allow sorting on this.
      until FindNext(Found) <> 0;
      AllFiles.Sort; // Sort on timestamp --> put in ascending alpha filename order

      //-------- Now, process files in name order ------------
      LastFileTimeStamp := 0;
      BatchFInfo.BatchCount := 0;
      for i := 0 to AllFiles.Count-1 do begin
        pFInfo := TFileInfo(AllFiles.Objects[i]);
        if pFInfo.MetaFileExists = false then continue;
        CurFileTimeStamp := FileDateToDateTime(pFInfo.SrcRec.Time);
        DeltaMinutes := DeltaMins(CurFileTimeStamp,LastFileTimeStamp);
        // *.barcode.txt file exists at this point
        if pFInfo.SBarCode <> '' then begin  //Found a new barcode
          LastFileTimeStamp := CurFileTimeStamp;
          //Note: The expected format of barcode must be same as that
          //      created by TfrmPtLabelPrint.PrintButtonClick:
          //      70685-12-31-2008-73-6-1302-0
          //      PtIEN-DateOfService-AuthorIEN-LocIEN-NoteTypeIEN-BatchFlag
          //      THUS there should be 8 pieces in the string.
          DFN := piece(pFInfo.SBarCode,'-',1);
          DOS := pieces(pFInfo.SBarCode,'-',2,4);
          AuthIEN := piece(pFInfo.SBarCode,'-',5);
          LocIEN := piece(pFInfo.SBarCode,'-',6);
          NoteTypeIEN := piece(pFInfo.SBarCode,'-',7);
          BatchS := piece(pFInfo.SBarCode,'-',8);
          if BatchS = '*' then begin
            pFInfo.BatchCount := 9999
          end else begin
            try
              pFInfo.BatchCount := StrToInt(BatchS);
            except
              on E:EConvertError do begin
                pFInfo.BatchCount := 1;
              end;
            end;
          end;
          //BatchFInfo.SBarCode := pFInfo.SBarCode;
        end else if (BatchFInfo.BatchCount > 0) then begin
          if (DeltaMinutes > ALLOWED_TIME_GAP) then begin
            pFInfo.Clear;
            BatchFInfo.Clear;
          end else begin
            //Apply barcode from last image onto this one (from same batch)
            pFInfo.SBarCode := BatchFInfo.SBarCode;
          end;
        end;
        if pFInfo.SBarCode <> '' then begin
          //Success --> write out ImgTxt file...
          FilePaths.Add(pFInfo.FPath);
          OneLine := EncodeImgTxt('', '`'+LocIEN,'', '`'+DFN, '', '', '',
                                  DOS,'`'+AuthIEN, '`'+NoteTypeIEN, FilePaths);
          if pFInfo.BatchCount>0 then begin
            //A BATCH marker has been found on current barcode.  This means that
            //Batchmode should be turned on.  This will apply current barcode
            //data to any subsequent images, providing there is not a gap in
            //time > ALLOWED_TIME_GAP
            BatchFInfo.Assign(pFInfo);  //reset Batch info to current
          end;
          //Decrease use count of Batch Info
          Dec(BatchFInfo.BatchCount);
        end else begin
          OneLine := '';
        end;
        OutFileLines.Clear;
        if OneLine <> '' then begin
          OutFileLines.Add(OneLine);
          OutFileLines.SaveToFile(ChangeFileExt(pFInfo.FPath,'.imgtxt'));
        end;
        FilePaths.Clear;
        OutFileLines.Clear;
        LastFileTimeStamp := CurFileTimeStamp;
      end;
AbortPoint:
      FindClose(Found);
      BatchFInfo.Free;
      FilePaths.Free;
      for i := 0 to AllFiles.Count-1 do begin  //free owned objects
        pFInfo := TFileInfo(AllFiles.Objects[i]);
        pFInfo.Free;
      end;
      AllFiles.Free;
      OutFileLines.Free;
    end;

  var flag1Filename,flag2Filename : string;
  begin
    flag1Filename := FScanDir+'barcodeRead.working.txt';
    flag2Filename := FScanDir+'convertTif2Png.working.txt';
    //if linux server is in middle of a conversion or barcode decode, then skip.
    if (FileExists(flag1Filename)=false) and (FileExists(flag2Filename)=false) then begin
      (* Remove {}'s to be able to have jpg's etc that contain barcodes
        In our site, only png's will have barcodes, and thus these are the
        only images that can be uploaded automatically.  Uploading jpg's, bmp's
        etc to look for (nonexistent) barcodes will just waste time and bandwidth. *)
      {
      ScanOneImageType('jpg');
      ScanOneImageType('jpeg');
      ScanOneImageType('gif');
      ScanOneImageType('bmp');
      }
      //ScanOneImageType('tif');   {Tiff was not showing up in IE for some reason}
      //ScanOneImageType('tiff');  {Tiff was not showing up in IE for some reason}
      ScanOneImageType('png');
    end;
  end;

  procedure TfrmImageUpload.PolTimerTimer(Sender: TObject);
  begin
    PolTimer.Enabled := false;
    UploadedDocs.clear;
    try
      if Assigned(frmImages) and frmImages.AutoScanUpload.Checked then begin
        ScanAndHandleImages;  //create metadata for images (if not done already)
        ScanAndHandleImgTxt;  //process upload file, based on metadata
        VerifyDocuments(UploadedDocs);
      end;
    finally
      PolTimer.Enabled := true;
      PolTimer.Interval := PolInterval;
    end;
  end;

  procedure TfrmImageUpload.VerifyDocuments(TIUIENList: TStringList);
  var  i: integer;
  begin
     //
     //Here pass list into RPC call that checks for lack of report text, buffer, unsigned state, and lack of images attached.
     //If all true, delete note
    if TIUIENList.Count = 0 then exit;

    with RPCBrokerV do begin
      ClearParameters := True;
      RemoteProcedure := 'TMG VERIFY PN FOR IMAGES';
      Param[0].PType := list;
      for i := 0 to TIUIENList.Count-1 do
        Param[0].Mult[TIUIENList[i]] := '';
      CallBroker;
      if piece(results[0],'^',1)='-1' then
        messagedlg(piece(results[0],'^',2),mtwarning,[mbOK],0);
      //if Piece(Results[0], U, 1) = '0' then ErrMsg := Piece(Results[0], U, 2) else ErrMsg := '';
  end;
  end;

  procedure TfrmImageUpload.SetPatientPhotoID(Value : boolean);
  begin
    lblAttachNote.Visible := not Value;
    NoteEdit.Visible := not Value;
    lblShortDescript.Visible := not Value;
    ShortDescEdit.Visible := not Value;
    lblLongDescript.Visible := not Value;
    LongDescMemo.Visible := not Value;
    btnPickStock.Visible := not Value;
  end;

  procedure TfrmImageUpload.SetAllowNonImages(Value : boolean);
  begin
    btnPickPDF.Visible := Value;
    btnPickOther.Visible := Value;
  end;

  procedure TfrmImageUpload.SetUniversalImages(Value : boolean);
  begin
    btnPickStock.Visible := not Value;
    NoteEdit.Visible := not Value;
    lblAttachNote.Visible := not Value;
    lblShortDescript.Visible := not Value;
    ShortDescEdit.Visible := not Value;
    lblLongDescript.Visible := not Value;
    LongDescMemo.Visible := not Value;
    lblDateTime.Visible := not Value;
    DateTimeEdit.Visible := not Value;
    if Value=true then begin
      OpenPicDialog.Options := OpenPicDialog.Options - [ofAllowMultiSelect];
      SavedMoveFilesValue := MoveCheckBox.Checked;
      MoveCheckBox.Checked := false;
      MoveCheckBox.Visible := false;
    end else begin
      OpenPicDialog.Options := OpenPicDialog.Options + [ofAllowMultiSelect];
      MoveCheckBox.Checked := SavedMoveFilesValue;
      MoveCheckBox.Visible := true;
    end;
  end;

  procedure TfrmImageUpload.SetUploadMode(Value : tImageUploadMode);
  begin
    if Value = FUploadMode then exit;
    FUploadMode := Value;
    case FUploadMode of
      umAnyFile :    begin
                       SetPatientPhotoID(false); //keep before others
                       SetAllowNonImages(true);
                       SetUniversalImages(false);
                     end;
      umImagesOnly : begin
                       SetPatientPhotoID(false); //keep before others
                       SetAllowNonImages(false);
                       SetUniversalImages(false);
                     end;
      umUniversal :  begin
                       SetPatientPhotoID(false); //keep before others
                       SetAllowNonImages(false);
                       SetUniversalImages(true);
                     end;
      umPatientID :  begin
                       SetAllowNonImages(false);
                       SetUniversalImages(false);
                       SetPatientPhotoID(true); //keep AFTER others
                     end;
      umSigImage :   begin
                       SetPatientPhotoID(false); //keep before others
                       SetAllowNonImages(false);
                       SetUniversalImages(true);
                     end;
    end; {case}
  end;

  {procedure TImageUploadForm.SetCallingForm(Form : string);
  begin
    FCallingForm := Form;
  end;   }

  procedure TfrmImageUpload.btnEditImageClick(Sender: TObject);
  var
    OptionsIniFile: TIniFile;
    ImageName: string;
    ProgramName: string;
  begin
    FileExt := ExtractFileExt(FilesToUploadList.Items[FilesToUploadList.ItemIndex]);
    OptionsIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));  //elh
    ProgramName := OptionsIniFile.ReadString('IMAGE_EDIT',FileExt,'');

    //if program name doesn't exist, default to mspaint
    if ProgramName = '' then begin
       ProgramName := GetWindowsFolder + '\System32\mspaint.exe';
    end;

    //if the file is not being moved, then we want to retain the original
    //so we will move it to the cache folder prior to editing it
    if not movecheckbox.Checked then begin
      ImageName := ExtractFileName(FilesToUploadList.Items[FilesToUploadList.ItemIndex]);
      CopyFile(PChar(FilesToUploadList.Items[FilesToUploadList.ItemIndex]),PChar(frmImages.CacheDir + '\' + ImageName),False);
      FilesToUploadList.Items[FilesToUploadList.ItemIndex] := frmImages.CacheDir + '\' + ImageName;
    end;

    //Run the selected program then refresh the preview
    messagedlg(ExtractFileName(ProgramName) + ' is now going to be opened for you to edit. Please save and close it when you finish editing.',mtInformation,[mbOK],0);
    RunModal(ProgramName,FilesToUploadList.Items[FilesToUploadList.ItemIndex]);
    WebBrowser.Navigate(FilesToUploadList.Items[FilesToUploadList.ItemIndex]);
  end;

  function TfrmImageUpload.GetWindowsFolder: string;
  begin
    SetLength(Result, 255);
    SetLength(Result, GetWindowsDirectory(PChar(Result), Length(Result)));
  end;

  procedure TfrmImageUpload.btnConfigEditorClick(Sender: TObject);
    var
      frmOptions: TfrmOptions;
    begin
      frmOptions := TfrmOptions.Create(Application);
      frmOptions.tsImages.TabVisible := true;
      FileExt := ExtractFileExt(FilesToUploadList.Items[FilesToUploadList.ItemIndex]);
      frmOptions.ShowModal;
      frmOptions.Release;
  end;

  procedure TfrmImageUpload.RunModal(ExecuteFile, ParamString:string);
  //This procedure is designed to run an external program modally, and will
  //return control when the program has been closed
  var
    SEInfo: TShellExecuteInfo;
    ExitCode: DWORD;
    //StartInString: string;
  begin
    FillChar(SEInfo, SizeOf(SEInfo), 0) ;
    SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
    with SEInfo do begin
      fMask := SEE_MASK_NOCLOSEPROCESS;
      Wnd := Application.Handle;
      lpFile := PChar(ExecuteFile) ;
      lpParameters := PChar('"' + ParamString + '"') ;
         {
         StartInString specifies the
         name of the working directory.
         If ommited, the current directory is used.
         }
     // lpDirectory := PChar(StartInString) ;
      nShow := SW_SHOWNORMAL;
    end;
   if ShellExecuteEx(@SEInfo) then begin
      repeat
        //Application.ProcessMessages;   Don't process messages until editing is done 
        GetExitCodeProcess(SEInfo.hProcess, ExitCode) ;
      until (ExitCode <> STILL_ACTIVE) or
      Application.Terminated;
      //ShowMessage('Done') ;
    end else ShowMessage('Error starting ' + ExecuteFile + '. Please check the file path and try again.') ;
  end;

  procedure TfrmImageUpload.btnCameraClick(Sender: TObject);
  var frmGetImage:TfrmGetImage;
  begin
    //The following lines are test lines with images imported from the camera using Direct X
    //
    {  This was used under Win XP... does not work with Vista/7}
    //frmGetImage.CacheDirectory := ExtractFilePath(ParamStr(0));
    frmGetImage := TfrmGetImage.Create(self);
    frmGetImage.CacheDirectory := '%userprofile%/.CPRS/Cache';
    frmGetImage.PhotoIDMode := (FUploadMode = umPatientID);
    if frmGetImage.ShowModal = mrOK then begin
      if FUploadMode = umUniversal then begin
        FilesToUploadList.Clear;  //only allow one file at a time.
      end;
      FilesToUploadList.Items.Add(frmGetImage.Filename);
      FilesToUploadList.ItemIndex := FilesToUploadList.Count-1;
      FilesToUploadListClick(self);
    end;
    frmGetImage.PhotoIDMode := false;
    frmGetImage.Free;
  end;

  procedure TfrmImageUpload.CancelButtonClick(Sender: TObject);
  begin
    Self.Mode := umAnyFile;
  end;

  procedure TfrmImageUpload.MoveCheckBoxClick(Sender: TObject);
  begin
    SavedMoveFilesValue := MoveCheckBox.Checked;
  end;

  procedure TfrmImageUpload.WMDropFiles(var Msg: TMessage);
  //from here: http://www.delphipages.com/forum/showthread.php?t=8535
  var
    N: Integer;
    NumFiles: Word;
    TheFile: array[0..512] of Char;
    s : string;
    Where: TPoint;
    OKToAccept : boolean;
  begin
    // gets position of mouse when file(s) dropped
    DragQueryPoint(THandle(Msg.WParam), Where);

    // gets the number of dropped files
    NumFiles := DragQueryFile(THandle(Msg.WParam), $FFFFFFFF, nil, 0);
    OKToAccept := true;

    if (FUploadMode in [umUniversal, umPatientID, umSigImage]) then begin
      if (NumFiles > 1) then begin
        MessageDlg('Please drag-and-drop only ONE file!', mtError, [mbOK],0);
        OKToAccept := false;
      end else begin
        FilesToUploadList.Clear;  //only allow one file at a time.
      end;
    end;

    If OKToAccept then begin
      // gets dropped filenames
      for N := 0 to NumFiles-1 do begin
        DragQueryFile(THandle(Msg.WParam), N, TheFile, SizeOf(TheFile));
        s := TheFile;
        FilesToUploadList.Items.Add(s);
      end;
      FilesToUploadList.ItemIndex := FilesToUploadList.Count-1;
      FilesToUploadListClick(self);
    end;
    DragFinish(THandle(Msg.WParam));
  end;


end.
