unit fTMG_WIA_GetImage;
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
  Dialogs, StdCtrls, TMG_WIA_TLB, OleCtrls, Grids, ExtDlgs, ComObj, StrUtils,
  ExtCtrls, jpeg, Buttons, Menus
  //sdJpegFormat,  //elh  12/28/10
  //sdBitmap,sdPlatform     //elh   12/28/10
  ,DelphiTwain, DelphiTwain_VCL   //Added to fetch images from scanner     //6/4/14
  ;

type
  TfrmGetImage = class(TForm)
    btnGetImageFromCamera: TBitBtn;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnRotateCCW: TBitBtn;
    btnRotateCW: TBitBtn;
    btnCrop: TBitBtn;
    ScrollBox: TScrollBox;
    ImageContainer: TImage;
    btnTakePicture: TBitBtn;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Action1: TMenuItem;
    UsePicture1: TMenuItem;
    Cancel1: TMenuItem;
    GetPicture1: TMenuItem;
    akePicture1: TMenuItem;
    RotateImageLeft1: TMenuItem;
    RotateImageRight1: TMenuItem;
    CropImage1: TMenuItem;
    btnResize: TBitBtn;
    ResizePicture1: TMenuItem;
    ResizePopup: TPopupMenu;
    puLargeSize: TMenuItem;
    puNormalSize: TMenuItem;
    puSmallSize: TMenuItem;
    puCustomSize: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BitBtn1: TBitBtn;
    Label7: TLabel;
    btnGetFromScanner: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure btnGetFromScannerClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnGetImageFromCameraClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnTakePictureClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
                            NewHeight: Integer; var Resize: Boolean);
    procedure btnRotateCCWClick(Sender: TObject);
    procedure btnRotateCWClick(Sender: TObject);
    procedure ImageContainerMouseMove(Sender: TObject; Shift: TShiftState;
                                      X, Y: Integer);
    procedure ImageContainerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageContainerMouseUp(Sender: TObject; Button: TMouseButton;
                                    Shift: TShiftState; X, Y: Integer);
    procedure btnCropClick(Sender: TObject);
    procedure btnResizeClick(Sender: TObject);
    procedure puLargeSizeClick(Sender: TObject);
    procedure puNormalSizeClick(Sender: TObject);
    procedure puSmallSizeClick(Sender: TObject);
    procedure puCustomSizeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    LastImageNum : integer;
    LastSavedImageFName : string;
    DraggingSizeBox : boolean;
    NullRect, SelectRect : TRect;
    LastCropSize : TPoint;
    FPhotoIDMode : boolean;
    Twain : TDelphiTwain;  //scanner image  6/4/14
    procedure TwainTwainAcquire(Sender: TObject; const Index: Integer;
      Image: TBitmap; var Cancel: Boolean);   //scanner image   6/4/14
    function NextImageFNPath : string;
    function RegisterWIA_Dll : boolean;
    procedure RotateImage(Degrees: integer);
    procedure AddFilter(IP : IImageProcess; Name : string; Index : integer=0);
    procedure ConvertToJPG(IP : IImageProcess; Image : IImageFile; Quality : Integer=100);
    //procedure ConvertToBMP(IP : IImageProcess; Image : IImageFile);
    procedure SetProperty(IP : IImageProcess; Name, Value : string; Index : integer=1); overload;
    procedure SetProperty(IP : IImageProcess; Name: String; Value : Integer; Index : integer=1); overload;
    //procedure CopyToBMP(var FName : string);
    procedure CopyToJPG(var FName : string);
    procedure JPEGtoBMP(var FileName: string);   //elh
    procedure BMPtoJPEG(var FileName: string);   //elh  TEST FUNCTION
    procedure DrawRectangle(Canvas : TCanvas; Rect : TRect);
    function EqualRects(R1,R2 : TRect) : boolean;
    procedure ClearSelectRect;
    procedure CropImage(LMargin,RMargin,TMargin,BMargin : Integer);
    procedure ResizeImage(MaxWidth,MaxHeight : integer);
    function ValidImage : boolean;
    function CropOK : boolean;
    procedure Initialize;
    procedure EnableButtons;
    procedure DisableButtons;
    procedure SetButtons(Enabled : boolean);
    procedure SetPhotoIDMode(Value : boolean);
  public
    { Public declarations }
    CacheDirectory : String;
    FileName : string;
    property PhotoIDMode : boolean read FPhotoIDMode write SetPhotoIDMode;
  end;

var
  frmGetImage: TfrmGetImage; //auto-created by application

implementation

  uses fTMG_DirectX_GetImage, fImages;

{$R *.dfm}

const
  BASE_FILE_NAME = 'imported_image_';

  procedure TfrmGetImage.FormCreate(Sender: TObject);
  begin
    Initialize;
    LastImageNum := 0;
    FPhotoIDMode := false;
    Twain := TDelphiTwain.Create;      //scanner image 6/4/14
    Twain.OnTwainAcquire := TwainTwainAcquire;    //scanner image 6/4/14
  end;

  procedure TfrmGetImage.FormDestroy(Sender: TObject);
begin
  Twain.Free;  //Scanner image    6/4/14
end;

procedure TfrmGetImage.FormShow(Sender: TObject);
  begin
    Initialize;
    DisableButtons;
  end;

  procedure TfrmGetImage.Initialize;
  begin
    DraggingSizeBox := false;
    NullRect.Left :=0;
    NullRect.Top := 0;
    NullRect.Right := 0;
    NullRect.Bottom := 0;
    LastCropSize := NullRect.TopLeft;
    ImageContainer.Picture := nil;
    LastSavedImageFName := '';
  end;


  function TfrmGetImage.RegisterWIA_Dll : boolean;
  //Returns if successful.

    function RegisterADll(const aDllFileName: string; aRegister: boolean=true): boolean;
    //Thanks to: http://www.geocities.com/izenkov/howto-regcomdll.htm
    type
      TRegProc = function: HResult; stdcall;
    const
      cRegFuncNameArr: array [boolean] of PChar =
        ('DllUnregisterServer', 'DllRegisterServer');
    var
      vLibHandle: THandle;
      vRegProc: TRegProc;
    begin
      Result := False;

      vLibHandle := LoadLibrary(PChar(aDllFileName));
      if vLibHandle = 0 then Exit;

      @vRegProc := GetProcAddress(vLibHandle, cRegFuncNameArr[aRegister]);
      if @vRegProc <> nil then begin
        Result := (vRegProc = S_OK);
      end;
      FreeLibrary(vLibHandle);
    end;

    function GetWinDir: string;
    var
      dir: array [0..512] of Char;
    begin
      GetWindowsDirectory(dir, MAX_PATH);
      Result := StrPas(dir);
      if RightStr(Result,1)<>'\' then Result := Result + '\';
    end;

  var  WinS32DLLFPath : string;
       LocalDLLFPath : string;
       OpenFileDialog: TOpenDialog;
  const DLL_NAME = 'wiaaut.dll';

  begin
    Result := false; //default to failure
    LocalDLLFPath := ExtractFilePath(ParamStr(0)) + DLL_NAME;
    WinS32DLLFPath := GetWinDir + 'System32\' + DLL_NAME;
    if not FileExists(WinS32DLLFPath) then begin
      //messageDlg('Copy it now',mtInformation,[mbOK],0);
      if FileExists(LocalDLLFPath) then begin
        if CopyFile(PChar(LocalDLLFPath), PChar(WinS32DLLFPath), False) = FALSE then begin
          MessageDlg('Unable to copy ("'+DLL_NAME+'") to provide functionality'+#13#10 +
                     'Source: '+ LocalDLLFPath + #13#10 +
                     'Destination: ' + WinS32DLLFPath + #13#10 +
                     'Solution: Manually copy file and try again.',
                     mtError, [mbOK],0);
          //error on copy
          exit;
        end;
      end else begin
        if MessageDlg('Needed .dll ("'+DLL_NAME+'") is not registered, and cannot found'+#13#10+
                   'found in application folder to register.  Would you like to manually'+#13#10+
                   'search for this file?.',mtError,[mbYes,mbNo],0) = mrYes then begin
          OpenFileDialog := TOpenDialog.Create(self);
          OpenFileDialog.Filter := DLL_NAME+'|'+DLL_NAME;
          If OpenFileDialog.Execute then begin
            if OpenFileDialog.FileName <> '' then begin
              if CopyFile(PChar(OpenFileDialog.FileName), PChar(WinS32DLLFPath), False) = false then begin
                MessageDlg('Unable to copy ("'+DLL_NAME+'") to provide functionality'+#13#10 +
                     'Source: '+ OpenFileDialog.FileName + #13#10 +
                     'Destination: ' + WinS32DLLFPath + #13#10 +
                     'Solution: Manually copy file and try again.',
                     mtError, [mbOK],0);
                exit;
              end;
            end;
            OpenFileDialog.Free;
          end else begin
            OpenFileDialog.Free;
            exit;
          end;
        end else begin;
          MessageDlg('Needed .dll ("'+DLL_NAME+'") not registered, and not found'+#13#10+
                   'found in application folder to register.  You can not use'+#13#10+
                   'this functionality until the file is located.',mtError,[mbOK],0);
          exit;
        end;
      end;
    end;
    Result := RegisterADll(WinS32DLLFPath);
  end;


  procedure TfrmGetImage.btnGetFromScannerClick(Sender: TObject);
begin
  //Get Image From Scanner
  //Load Twain Library dynamically
  //if (Twain.LoadLibrary) AND (Twain.SourceCount>0) then begin
  if Twain.LoadLibrary then begin
    //Load source manager
    Twain.SourceManagerLoaded := TRUE;

    //Allow user to select source -> only the first time
    if not Assigned(Twain.SelectedSource) then
      Twain.SelectSource;

    if Assigned(Twain.SelectedSource) then begin
      //Load source, select transference method and enable (display interface)}
      Twain.SelectedSource.Loaded := TRUE;
      Twain.SelectedSource.ShowUI := TRUE;//display interface
      Twain.SelectedSource.Enabled := True;
    end;
  end else if Twain.SourceCount=0 then begin
    ShowMessage('No twain devices detected');
  end else begin
    ShowMessage('Twain is not installed.');
  end;
end;

procedure TfrmGetImage.btnGetImageFromCameraClick(Sender: TObject);
  var  Device : IDevice;
       Item : IItem;
       CommonDialog : TWIACommonDialog;
       Image : IImageFile;
       DeviceMan: TWIADeviceManager;
  begin
    ClearSelectRect;
    try
      CommonDialog := nil;
      DeviceMan:= TWIADeviceManager.Create(self);
      if DeviceMan.DeviceInfos.Count = 0 then begin
        MessageDlg('No device found to get images from.'+#13#10+'If using a webcam, try the webcam button',mtError,[mbOK],0);
      end else begin
        CommonDialog := TWIACommonDialog.Create(Self);
        Image := CommonDialog.ShowAcquireImage(UnspecifiedDeviceType,
                                               UnspecifiedIntent,
                                               MinimizeSize,
                                               wiaFormatJPEG,
                                               FALSE,            //Always show SelectDevice GUI
                                               TRUE,             //Use Common GUI
                                               FALSE             //Cancel causes Error
                                               );
        if Image = nil then exit;
        LastSavedImageFName := NextImageFNPath;
        Image.SaveFile(LastSavedImageFName);
        //CopyToBMP(LastSavedImageFName); //Changes LastSavedImageFName;
        JPEGtoBMP(LastSavedImageFName);  //elh
        ImageContainer.Picture.LoadFromFile(LastSavedImageFName);
        //  RotateImage(180);
        EnableButtons;
      end;
    except
      on E: EOLEError {Exception} do begin
        if E.Message = 'Class not registered' then begin
          MessageDlg('Here I can try to register .dll.',mtInformation,[mbOK],0);
          if RegisterWIA_Dll then btnGetImageFromCameraClick(self)
          else Messagedlg('Windows WIA Object not registered.', mtError,[mbOK],0);
        end else begin
          MessageDlg(E.Message, mtError,[mbOK],0);
        end;
      end;
    end;
    If Assigned (CommonDialog) then CommonDialog.Free;
    DeviceMan.Free;
  end;

  procedure TfrmGetImage.btnTakePictureClick(Sender: TObject);
  var  Device : IDevice;
       Item : IItem;
       CommonDialog : TWIACommonDialog;
       //Image : IImageFile;
       DeviceMan: TWIADeviceManager;
       frmGetDXImage : TfrmGetDXImage;
  begin
    frmGetDXImage := TfrmGetDXImage.create(self);
    if frmGetDXImage.ShowModal = mrOK then begin
      //messagedlg(frmGetDXImage.frameGetDXImage1.Filename,mtInformation,[mbOK],1);
      LastSavedImageFName := frmGetDXImage.frameGetDXImage1.Filename;
      //Image.SaveFile(LastSavedImageFName);
        //CopyToBMP(LastSavedImageFName); //Changes LastSavedImageFName;
      JPEGtoBMP(LastSavedImageFName);  //elh
      ImageContainer.Picture.LoadFromFile(LastSavedImageFName);
      //ImageContainer.Picture.LoadFromFile(frmGetDXImage.frameGetDXImage1.Filename);
      EnableButtons;
      //FilesToUploadList.Items.Add(frmGetDXImage.frameGetDXImage1.Filename);
      //FilesToUploadList.ItemIndex := FilesToUploadList.Count-1;
      //FilesToUploadListClick(self);
    end;
    frmGetDXImage.free;
    {
    try
      CommonDialog := nil;
      DeviceMan:= TWIADeviceManager.Create(self);
      if DeviceMan.DeviceInfos.Count = 0 then begin
        MessageDlg('No device found to get images from.',mtError,[mbOK],0);
      end else begin
        CommonDialog := TWIACommonDialog.Create(Self);
        Device := CommonDialog.ShowSelectDevice(UnspecifiedDeviceType,FALSE,FALSE);
        Item := Device.ExecuteCommand(wiaCommandTakePicture);
        btnGetImageFromCameraClick(self)
      end;
    except
      on E: EOLEError {Exception}{ do begin
        if E.Message = 'Class not registered' then begin
          MessageDlg('Here I can try to register .dll.',mtInformation,[mbOK],0);
          if RegisterWIA_Dll then btnTakePictureClick(self)
          else Messagedlg('Windows WIA Object not registered.', mtError,[mbOK],0);
        end else begin
          MessageDlg(E.Message, mtError,[mbOK],0);
        end;
      end;
    end;
    If Assigned (CommonDialog) then CommonDialog.Free;
    DeviceMan.Free;               }
  end;

  procedure TfrmGetImage.AddFilter(IP : IImageProcess; Name : string; Index : integer=0);
  var  FilterID : WideString;
       v : OleVariant;
  begin
    v := Name;
    FilterID := IP.FilterInfos[v].FilterID;  //v has to be an OleVariant
    IP.Filters.Add(FilterID,Index);
  end;


  procedure TfrmGetImage.SetProperty(IP : IImageProcess; Name, Value : string; Index : integer=1);
  var  AProperty : IProperty;
       v : OleVariant;
  begin
    v := Name;
    AProperty := IP.Filters.Item[Index].Properties.Item[v]; //v has to be an OleVariant
    v := Value;
    AProperty.Value := v;  //v has to be an OleVariant
  end;

  procedure TfrmGetImage.SetProperty(IP : IImageProcess; Name : String; Value : Integer; Index : integer=1);
  var ValueStr : string;
  begin
    ValueStr :=IntToStr(Value);
    SetProperty(IP, Name, ValueStr, Index);
  end;


  procedure TfrmGetImage.ConvertToJPG(IP : IImageProcess; Image : IImageFile; Quality : Integer);
  //Image should contain a valid IImageFile
  //Quality: 1-100 (100-default)
  begin
    AddFilter(IP, 'Convert');
    SetProperty(IP, 'FormatID', wiaFormatJPEG);
    SetProperty(IP, 'Quality', 80);
    Image := IP.Apply(Image);
  end;


  procedure TfrmGetImage.JPEGtoBMP(var FileName: string);   //elh  TEST FUNCTION
  var
    jpeg: TJPEGImage;
    bmp:  TBitmap;
    OrigFName : string;
  begin
    OrigFName := FileName;
    jpeg := TJPEGImage.Create;
    try
      jpeg.CompressionQuality := 100; {Default Value}
      jpeg.LoadFromFile(FileName);
      bmp := TBitmap.Create;
      try
        bmp.Assign(jpeg);
        FileName := ChangeFileExt(FileName, '.bmp');
        bmp.SaveTofile(FileName);
        if FileExists(OrigFName) then DeleteFile(OrigFName);
      finally
        bmp.Free
      end;
    finally
      jpeg.Free
    end;
  end;  
  {//Altered code to utilize TsdJpgFormat
  var
    bmp:  TBitmap;
    OrigFName : string;
    FJpg : TsdJpegFormat;
  begin
    OrigFName := FileName;
    FJpg := TsdJpegFormat.Create(self);
    bmp := TBitmap.Create;
    FileName := ChangeFileExt(FileName, '.bmp');
    try
      FJpg.LoadFromFile(OrigFName);
      bmp := SdBitmapToWinBitmap(FJpg.Bitmap);
      bmp.SaveTofile(FileName);
      if FileExists(OrigFName) then DeleteFile(OrigFName);
    finally
      FJpg.Free;
      bmp.free;
    end;
  end;}

  procedure TfrmGetImage.BitBtn1Click(Sender: TObject);
  //Debugging function
  var  BMP : TBitmap;
      OpenPictureDialog: TOpenPictureDialog;

  begin
    SetButtons(true);
    BMP := TBitmap.Create;
    OpenPictureDialog := TOpenPictureDialog.Create(Self);
    if OpenPictureDialog.Execute then begin
      if fImages.LoadAnyImageFormatToBMP(OpenPictureDialog.FileName, BMP) then begin
        ImageContainer.Picture.Bitmap := BMP;
      end;
    end;
    BMP.Free;
    OpenPictureDialog.Free;
  end;

  procedure TfrmGetImage.BMPtoJPEG(var FileName: string);   //elh  TEST FUNCTION
  var
    jpeg: TJPEGImage;
    bmp:  TBitmap;
    OrigFName : string;
  begin
    OrigFName := FileName;
    bmp := TBitmap.Create;
    try
      //jpeg.CompressionQuality := 100; {Default Value}
      bmp.LoadFromFile(FileName);
      jpeg := TJPEGImage.Create;
      try
        jpeg.Assign(bmp);
        FileName := ChangeFileExt(FileName, '.jpg');
        jpeg.SaveTofile(FileName);
        if FileExists(OrigFName) then DeleteFile(OrigFName);
      finally
        jpeg.Free
      end;
    finally
      bmp.Free
    end;
  end;
  {
  procedure TfrmGetImage.ConvertToBMP(IP : IImageProcess; Image : IImageFile);
  //Image should contain a valid IImageFile
  begin
    AddFilter(IP, 'Convert');
    SetProperty(IP, 'FormatID', wiaFormatBMP);
    Image := IP.Apply(Image);
  end;

  procedure TfrmGetImage.CopyToBMP(var FName : string);
  var Image : IImageFile;
      ImageProcess : IImageProcess;
      OrigFName : string;
  begin
    OrigFName := FName;
    Image := CoImageFile.Create;
    ImageProcess := CoImageProcess.Create;
    Image.LoadFile(FName);
    ConvertToBMP(ImageProcess, Image);
    Fname := ChangeFileExt(FName,'.bmp');
    if FileExists(FName) then DeleteFile(FName);
    Image.SaveFile(FName);
    if FileExists(OrigFName) then DeleteFile(OrigFName);
    //Is Image, ImageProcess supposed to be released somehow?
  end;
  }

  procedure TfrmGetImage.CopyToJPG(var FName : string);
  var Image : IImageFile;
      ImageProcess : IImageProcess;
      OrigFName : string;
  begin
    OrigFName := FName;
    Image := CoImageFile.Create;
    ImageProcess := CoImageProcess.Create;
    Image.LoadFile(FName);
    ConvertToJPG(ImageProcess, Image);
    FName := ChangeFileExt(FName,'.jpg');
    if FileExists(FName) then DeleteFile(FName);
    Image.SaveFile(FName);
    if FileExists(OrigFName) then DeleteFile(OrigFName);
    //Is Image, ImageProcess supposed to be released somehow?
  end;


  procedure TfrmGetImage.RotateImage(Degrees: integer);
  var
    Image : IImageFile;
    ImageProcess : IImageProcess;
    AProperty : IProperty;
    FilterID : WideString;
    v : OleVariant;

  begin
    While Degrees < 0 do Degrees := Degrees + 360;
    if LastSavedImageFName = '' then begin
      MessageDlg('Please import an image first.',mtError,[mbOK],0);
      exit
    end;
    Image := CoImageFile.Create;
    ImageProcess := CoImageProcess.Create;
    Image.LoadFile(LastSavedImageFName);

    AddFilter(ImageProcess, 'RotateFlip');
    SetProperty(ImageProcess, 'RotationAngle', Degrees);

    Image := ImageProcess.Apply(Image);

    DeleteFile(LastSavedImageFName);
    Image.SaveFile(LastSavedImageFName);
    ImageContainer.Picture.LoadFromFile(LastSavedImageFName);

    //Is Image supposed to be released somehow?
  end;


  procedure TfrmGetImage.CropImage(LMargin,RMargin,TMargin,BMargin : Integer);
  var
    Image : IImageFile;
    ImageProcess : IImageProcess;
    AProperty : IProperty;
    FilterID : WideString;
    v : OleVariant;

  begin
    Image := CoImageFile.Create;
    ImageProcess := CoImageProcess.Create;
    Image.LoadFile(LastSavedImageFName);

    AddFilter(ImageProcess, 'Crop');
    SetProperty(ImageProcess, 'Left', LMargin);
    SetProperty(ImageProcess, 'Right', RMargin);
    SetProperty(ImageProcess, 'Top', TMargin);
    SetProperty(ImageProcess, 'Bottom', BMargin);

    Image := ImageProcess.Apply(Image);

    DeleteFile(LastSavedImageFName);
    Image.SaveFile(LastSavedImageFName);
    ImageContainer.Picture.LoadFromFile(LastSavedImageFName);

    //Is Image supposed to be released somehow?
  end;


  procedure TfrmGetImage.ResizeImage(MaxWidth, MaxHeight : integer);
  var
    Image : IImageFile;
    ImageProcess : IImageProcess;
    AProperty : IProperty;
    FilterID : WideString;
    v : OleVariant;

  begin
    Image := CoImageFile.Create;
    ImageProcess := CoImageProcess.Create;
    Image.LoadFile(LastSavedImageFName);

    AddFilter(ImageProcess, 'Scale');
    SetProperty(ImageProcess, 'MaximumWidth', MaxWidth);
    SetProperty(ImageProcess, 'MaximumHeight', MaxHeight);

    Image := ImageProcess.Apply(Image);

    DeleteFile(LastSavedImageFName);
    Image.SaveFile(LastSavedImageFName);
    ImageContainer.Picture.LoadFromFile(LastSavedImageFName);

    //Is Image supposed to be released somehow?  <-- doesn't have free or destroy methods
  end;


  function TfrmGetImage.NextImageFNPath : string;
  begin
    Repeat
      Inc(LastImageNum);
      Result := CacheDirectory + BASE_FILE_NAME + IntToStr(LastImageNum) + '.jpg';
    until not FileExists(Result);
  end;

  procedure TfrmGetImage.btnCancelClick(Sender: TObject);
  begin
    if FileExists(LastSavedImageFName) then DeleteFile(LastSavedImageFName);
    Self.ModalResult := mrCancel;
  end;

  procedure TfrmGetImage.btnOKClick(Sender: TObject);
  begin
    if not ValidImage then exit;
    if FPhotoIDMode and not CropOK then exit;
    //CopyToJPG(LastSavedImageFName);
    BMPToJPEG(LastSavedImageFName);
    FileName := LastSavedImageFName;
    Self.ModalResult := mrOK;
  end;

  procedure TfrmGetImage.FormCanResize(Sender: TObject; var NewWidth,
    NewHeight: Integer; var Resize: Boolean);
  begin

    if Assigned(ImageContainer.Picture) then begin
      if ImageContainer.Picture.Height > 0 then begin
        ScrollBox.VertScrollBar.Range := ImageContainer.Picture.Height;
      end;
      if Assigned(ImageContainer.Picture) and (ImageContainer.Picture.Width > 0) then begin
        ScrollBox.HorzScrollBar.Range := ImageContainer.Picture.Width;
      end;
    end;
    Resize := true;
  end;

  procedure TfrmGetImage.btnRotateCCWClick(Sender: TObject);
  begin
    ClearSelectRect;
    RotateImage(-90);
  end;


  procedure TfrmGetImage.btnRotateCWClick(Sender: TObject);
  begin
    ClearSelectRect;
    RotateImage(90);
  end;

  procedure TfrmGetImage.ImageContainerMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    if not EqualRects(SelectRect,NullRect) then begin
      DrawRectangle(ImageContainer.Canvas, SelectRect);
      SelectRect := NullRect;
    end;
    SelectRect.TopLeft := ImageContainer.ScreenToClient(Mouse.CursorPos);
    SelectRect.BottomRight := SelectRect.TopLeft;
    DraggingSizeBox := true;
  end;

  procedure TfrmGetImage.ImageContainerMouseUp(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  begin
    DraggingSizeBox := false;
  end;

  procedure TfrmGetImage.DrawRectangle(Canvas : TCanvas; Rect : TRect);
  begin
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Color := clRed;
    Canvas.Pen.Mode := pmNotXor;

    Canvas.PenPos := Rect.TopLeft;
    Canvas.LineTo(Rect.Left,Rect.Bottom);
    Canvas.LineTo(Rect.Right,Rect.Bottom);
    Canvas.LineTo(Rect.Right,Rect.Top);
    Canvas.LineTo(Rect.Left,Rect.Top);
  end;

  function TfrmGetImage.EqualRects(R1,R2 : TRect) : boolean;
  begin
    Result := (R1.Top = R2.Top) and
              (R1.Left = R2.Left) and
              (R1.Bottom = R2.Bottom) and
              (R1.Right = R2.Right);
  end;


  procedure TfrmGetImage.ClearSelectRect;
  begin
    if not EqualRects(SelectRect,NullRect) then begin
      DrawRectangle(ImageContainer.Canvas, SelectRect);
      SelectRect := NullRect;
    end;
  end;


  procedure TfrmGetImage.ImageContainerMouseMove(Sender: TObject; Shift: TShiftState;
                                                 X, Y: Integer);
  var MousePt, Pt2 : TPoint;
      RectSize : integer;
  begin
    if not DraggingSizeBox then exit;

    if not EqualRects(SelectRect,NullRect) then begin
      DrawRectangle(ImageContainer.Canvas, SelectRect);
    end;
    MousePt := ImageContainer.ScreenToClient(Mouse.CursorPos);
    SelectRect.BottomRight := MousePt;
    if FPhotoIDMode then begin  //force aspect ratio to be 1:1 (square), by setting y based on mouse x
      RectSize := SelectRect.Right - SelectRect.Left;
      if (SelectRect.Bottom - SelectRect.Top) > RectSize then begin
        RectSize := SelectRect.Bottom - SelectRect.Top;
      end;
      SelectRect.Bottom := SelectRect.Top + RectSize;
      SelectRect.Right := SelectRect.Left + RectSize;
    end;
    DrawRectangle(ImageContainer.Canvas, SelectRect);
  end;

  procedure TfrmGetImage.btnCropClick(Sender: TObject);
  var LMargin,RMargin,TMargin,BMargin,temp : integer;
  begin
    if EqualRects(SelectRect,NullRect) then begin
      MessageDlg('Please click and drag on image first to ' + #13#10 +
                 'Define an area to crop to first',mtError,[mbOK],0);
      exit;
    end;
    //Test section to ensure that left vs right and top vs bottom are correct
    //ShowMessage('Left: '+inttostr(SelectRect.Left)+' Right:'+inttostr(SelectRect.Right)+' Top:'+inttostr(SelectRect.Top)+' Bottom:'+inttostr(SelectRect.Bottom));
    if SelectRect.Left > SelectRect.Right then begin
      LMargin := SelectRect.Right;
      RMargin := ImageContainer.Picture.Width - SelectRect.Left;
    end else begin
      LMargin := SelectRect.Left;
      RMargin := ImageContainer.Picture.Width - SelectRect.Right;
    end;
    if SelectRect.Top > SelectRect.Bottom then begin
      TMargin := SelectRect.Bottom;
      BMargin := ImageContainer.Picture.Height - SelectRect.Top;
    end else begin
      TMargin := SelectRect.Top;
      BMargin := ImageContainer.Picture.Height - SelectRect.Bottom;
    end;
    LastCropSize.X := SelectRect.Right - SelectRect.Left;
    LastCropSize.Y := SelectRect.Bottom - SelectRect.Top;
    //end test section
    ClearSelectRect;
    if LMargin<0 then LMargin:=0;
    if RMargin<0 then RMargin:=0;
    if TMargin<0 then TMargin:=0;
    if BMargin<0 then BMargin:=0;
    //showmessage('LMargin: '+inttostr(LMargin)+' RMargin: '+inttostr(RMargin)+' TMargin: '+inttostr(TMargin)+' BMargin: '+inttostr(BMargin));
    CropImage(LMargin,RMargin,TMargin,BMargin);
  end;

  procedure TfrmGetImage.btnResizeClick(Sender: TObject);
  var Height, Width : integer;
      PopPoint : TPoint;
  begin
    if EqualRects(SelectRect,NullRect) then begin
      if not ValidImage then exit;
      PopPoint.Y := btnResize.Top;
      PopPoint.X := btnResize.Left + btnResize.Width;
      PopPoint := frmGetImage.ClientToScreen(PopPoint);
      ResizePopup.Popup(PopPoint.X,PopPoint.Y);
      exit;
    end;
    Height := SelectRect.Bottom-SelectRect.Top;
    if Height < 0 then Height := -1 * Height;
    Width := SelectRect.Right - SelectRect.Left;
    if Width <0 then Width := -1 * Width;
    ClearSelectRect;
    ResizeImage(Width, Height);
  end;

  function TfrmGetImage.ValidImage : boolean;
  begin
    Result := true;
    if ImageContainer.Picture.Width = 0 then begin
      MessageDlg('No image present',mtError,[mbOK],0);
      Result := false;
    end;
  end;

  function TfrmGetImage.CropOK : boolean;
  var NeedsCrop : boolean;
  begin
    Result := true;
    if not FPhotoIDMode then exit;
    NeedsCrop := ((LastCropSize.x = 0) and (LastCropSize.y = 0)) or
                 ((LastCropSize.x <> LastCropSize.y));

    if NeedsCrop then begin
      if MessageDlg('Selecting a Patient Photo ID, so' + #13#10 +
                    'Photo best if cropped into exact square.' + #13#10 +
                    'Want to crop before continuing?', mtWarning, [mbYes, mbNo], 0) <> mrNo then begin
        Result := false;
      end;
    end;
  end;

  procedure TfrmGetImage.puLargeSizeClick(Sender: TObject);
  begin
    ResizeImage(800, 600);
  end;

  procedure TfrmGetImage.puNormalSizeClick(Sender: TObject);
  begin
    ResizeImage(500, 500);
  end;

  procedure TfrmGetImage.puSmallSizeClick(Sender: TObject);
  begin
    ResizeImage(250, 250);
  end;

  procedure TfrmGetImage.puCustomSizeClick(Sender: TObject);
  begin
    MessageDlg('Please first click and drag on image to create' + #13#10 +
               'a box that is the size of the image you want.' + #13#10 +
               'Then press the resize button again.', mtInformation,
               [mbOK],0);
  end;

  procedure TfrmGetImage.EnableButtons;
  begin
    SetButtons(True);
  end;

  procedure TfrmGetImage.DisableButtons;
  begin
    SetButtons(False);
  end;

  procedure TfrmGetImage.SetButtons(Enabled : boolean);
  begin
    btnRotateCCW.Visible := Enabled;
    btnRotateCW.Visible := Enabled;
    btnCrop.Visible := Enabled;
    btnResize.Visible := Enabled;
    btnOK.Visible := Enabled;
    Label2.Visible := Enabled;
    Label3.Visible := Enabled;
    Label4.Visible := Enabled;
    Label5.Visible := Enabled;
  end;

  procedure TfrmGetImage.SetPhotoIDMode(Value : boolean);
  begin
    FPhotoIDMode := Value;
  end;

  procedure TfrmGetImage.TwainTwainAcquire(Sender: TObject; const Index: Integer; Image: TBitmap; var Cancel: Boolean);
  begin
    LastSavedImageFName := ChangeFileExt(NextImageFNPath,'.bmp');
    Image.SaveToFile(LastSavedImageFName);
    //JPEGtoBMP(LastSavedImageFName);  //elh
    ImageContainer.Picture.LoadFromFile(LastSavedImageFName);
    //ImageContainer.Picture.Assign(Image);
    Cancel := True;//Only want one image
    EnableButtons;
  end;

end.

