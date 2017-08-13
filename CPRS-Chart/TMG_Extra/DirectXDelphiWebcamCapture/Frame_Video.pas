unit Frame_Video;
//TMG added entire unit.  Original source found on the web.
{******************************************************************************
About
  This frame opens the selected webcam using DirectX. It has been modified
  by Kevin Toppenberg, MD and Eddie Hagood for TMG-CPRS.

Contact:
  michael@grizzlymotion.com

Copyright
  Portions created by Microsoft are Copyright (C) Microsoft Corporation.
  Original file names: PlayCap.cpp, PlayCapMoniker.cpp.
  For copyrights of the DirectX Header ports see the original source files.
  Other code (unless stated otherwise, see comments): Copyright (C) M. Braun

Licence:
  The lion share of this project lies within the ports of the DirectX header
  files (which are under the Mozilla Public License Version 1.1), and the
  original SDK sample files from Microsoft (END-USER LICENSE AGREEMENT FOR
  MICROSOFT SOFTWARE DirectX 9.0 Software Development Kit Update (Summer 2003))

  My own contribution compared to that work is very small (although it cost me
  lots of time), but still is "significant enough" to fulfill Microsofts licence
  agreement ;)
  So I think, the ZLib licence (http://www.zlib.net/zlib_license.html)
  should be sufficient for my code contributions.

Please note:
  There exist much more complete alternatives (incl. sound, AVI etc.):
  - DSPack (http://www.progdigy.com/)
  - TVideoCapture by Egor Averchenkov (can be found at http://www.torry.net)


******************************************************************************}


interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  Buttons, MMSystem, Menus, ComCtrls, JPEG,
  VFrames;

type
  TPropertyControl  = RECORD
                        PCLabel    : TLabel;
                        PCTrackbar : TTrackBar;
                        PCCheckbox : TCheckBox;
                      end;

  TframeGetDXImage = class(TFrame)
    Panel_Bottom: TPanel;
    Label_Cameras: TLabel;
    ComboBox_Cams: TComboBox;
    PopupMenu1: TPopupMenu;
    Updatelistofcameras1: TMenuItem;
    Label1: TLabel;
    ComboBox_DisplayMode: TComboBox;
    ComboBox1: TComboBox;
    Panel_Main: TPanel;
    Label2: TLabel;
    PaintBox_Video: TPaintBox;
    Bevel1: TBevel;
    Label_fps: TLabel;
    Label_VideoSize: TLabel;
    btnSettings: TBitBtn;
    Label5: TLabel;
    procedure btnDevSettingsClick(Sender: TObject);
    procedure btnTakePictureClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Updatelistofcameras1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton_PauseClick(Sender: TObject);
    procedure SpeedButton_StopClick(Sender: TObject);
    procedure SpeedButton_VidSettingsClick(Sender: TObject);
    procedure SpeedButton_VidSizeClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton_RunVideoClick(Sender: TObject);
  private
    { Private declarations }
    Initialized  : boolean;
    OnNewFrameBusy: boolean;
    fFrameCnt    : integer;
    fSkipCnt     : integer;
    f30FrameTick : integer;
    VideoImage   : TVideoImage;
    VideoBMPIndex: integer;
    VideoBMP     : array[0..1] of TBitmap;  // Used below in case we want to paint the image by ourselfs....
    CopyBMP      : TBitmap;
    ModeBMP      : TBitmap;
    DiffCol      : array[-255..255] of byte;
    DiffRatio    : double;
    AppPath      : string;
    SpyIndex     : integer;
    LocalJPG     : TJPEGImage;
    PropCtrl     : array[TVideoProperty] of TPropertyControl;
    Stop_Enabled : boolean;   //kt
    RunVideo_Enabled : boolean; //kt
    Open_Panel_Height : integer;  //kt
    Closed_Panel_Height : integer;  //kt
    procedure CleanPaintBoxVideo;
    procedure CalcInvertedImage(BM1, Inv: TBitmap);
    procedure CalcGrayScaleImage(BM1, Gray: TBitmap);
    procedure CalcDiffImage(BM1, BM2, Diff: TBitmap; var DiffRatio: double);
    procedure CalcDiffImage2(BM1, BM2, Diff: TBitmap;  var DiffRatio: double);
    procedure OnNewFrame(Sender : TObject; Width, Height: integer; DataPtr: pointer);
    procedure PropertyTrackBarChange(Sender: TObject);
    procedure PropertyCheckBoxClick(Sender: TObject);
    constructor Create(AOwner: TComponent); override;  //kt
  public
    { Public declarations }
    Filename : string;
    SettingsPanelOpen : boolean; //kt
    OnSettingsToggle : TNotifyEvent; //kt
    CamCapture_Enabled : boolean;
    procedure UpdateCamList;
    procedure InitFrame;
    procedure Stop;
    procedure Close;
    procedure ExpandBottom;
    procedure CollapseBottom;
  end;

implementation

{$R *.dfm}

constructor TframeGetDXImage.Create(AOwner: TComponent);
const
  DEF_PANEL_OPEN_SIZE = 80;
  DEF_PANEL_CLOSED_SIZE = 70;
begin
  Inherited Create(AOwner);
  Open_Panel_Height := DEF_PANEL_OPEN_SIZE;
  Closed_Panel_Height := DEF_PANEL_CLOSED_SIZE;
  SettingsPanelOpen := false;
  OnSettingsToggle := nil;
end;


procedure TframeGetDXImage.UpdateCamList;
var
  SL : TStringList;
begin
  // Load ComboBox_Cams with list of available video interfaces (WebCams...)
  SL := TStringList.Create;
  VideoImage.GetListOfDevices(SL);
  ComboBox_Cams.Items.Assign(SL);
  SL.Free;

  // At least one WebCam found: enable "Run video" button
  //SpeedButton_RunVideo.Enabled := false;
  RunVideo_Enabled := false;
  if ComboBox_Cams.Items.Count > 0 then begin
    if (ComboBox_Cams.ItemIndex < 0) or (ComboBox_Cams.ItemIndex >= ComboBox_Cams.Items.Count) then begin
      ComboBox_Cams.ItemIndex := 0;
    end;
    //SpeedButton_RunVideo.Enabled := true;
    RunVideo_Enabled := true;
  end else begin
    ComboBox_Cams.items.add('No cameras found.');
    //SpeedButton_RunVideo.Enabled := false;
    RunVideo_Enabled := false;
  end;
end;

type
  tbytearray = array[0..16383] of byte;
  pbytearray = ^tbytearray;


procedure TframeGetDXImage.CalcInvertedImage(BM1, Inv: TBitmap);
var
  X, Y  : integer;
  p1, d : pbytearray;
begin
  Inv.Width := BM1.Width;
  Inv.Height := BM1.Height;
  Inv.PixelFormat := pf24bit;

  for Y := BM1.Height-1 downto 0 DO begin
    p1 := BM1.ScanLine[Y];
    d  := Inv.ScanLine[Y];
    for X := 0 TO BM1.Width*3-1 do begin  // "*3" because we have pf24bit images
        d^[X] := 255-p1^[X];
    end;
  end;
end;


procedure TframeGetDXImage.CalcGrayScaleImage(BM1, Gray: TBitmap);
var
  X, Y, i : integer;
  p1, d   : pbytearray;
  g       : byte;
begin
  Gray.Width := BM1.Width;
  Gray.Height := BM1.Height;
  Gray.PixelFormat := pf24bit; // Not really necessary. pf8bit together with a suitable color palette would be better.

  for Y := BM1.Height-1 downto 0 do begin
    p1 := BM1.ScanLine[Y];
    d  := Gray.ScanLine[Y];
    i  := 0;
    for X := 0 TO BM1.Width-1 do begin
      g := ((p1^[i]*100) + (p1^[i+1]*128) + (p1^[i+2]*28)) shr 8;
      d^[i] := g;
      Inc(i);
      d^[i] := g;
      Inc(i);
      d^[i] := g;
      Inc(i);
    end;
  end;
end;



procedure TframeGetDXImage.Button1Click(Sender: TObject);
var
  i, x, y, j,
  T1 : integer;
  d  : double;
  s  : string;
  hour, min, sec, msec: word;
begin
  CopyBMP.Width := VideoBMP[VideoBMPIndex].Width;
  CopyBMP.Height := VideoBMP[VideoBMPIndex].Height;
  CopyBMP.Canvas.Draw(0, 0, VideoBMP[VideoBMPIndex]);
  with CopyBMP do begin
    DecodeTime(Now, hour, min, sec, msec);
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut(4, Height-4-Canvas.TextHeight('W'), DateTimetoStr(Now));
    Canvas.Brush.Style := bsSolid;
    Canvas.ellipse(4, 4, 36, 36);
    Canvas.Pen.Color := clBlack;
    for i := 0 TO 11 do begin
      Canvas.Pen.Color := clGray;
      Canvas.Brush.Color := clBlack;
      X := round(20 + 12*Sin(i*30*Pi/180));
      Y := round(20 - 12*cos(i*30*Pi/180));
      Canvas.ellipse(X-2, Y-2, X+2, Y+2);
    end;
    Canvas.Pen.Color := clBlack;
    d := (Hour + min/60) *30 *Pi/180;
    X := round(20 + 7*Sin(d));
    Y := round(20 - 7*cos(d));
    Canvas.Pen.Width := 3;
    Canvas.moveto(20, 20);
    Canvas.LineTo(X, Y);
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := clBlue;
    d := (Min + Sec/60) *6 *Pi/180;
    X := round(20 + 10*Sin(d));
    Y := round(20 - 10*cos(d));
    Canvas.moveto(20, 20);
    Canvas.LineTo(X, Y);
    Canvas.Pen.Color := clRed;
    d := (sec) *6 *Pi/180;
    X := round(20 + 10*Sin(d));
    Y := round(20 - 10*cos(d));
    Canvas.moveto(20, 20);
    Canvas.LineTo(X, Y);
  end;

//ForceDirectories(AppPath + 'Spy\');
//Inc(SpyIndex);
//if SpyIndex <= 4000 then
 //begin
   //s := IntToStr(SpyIndex);
   //while length(s) < 4 do
   //s := '0' + s;
 LocalJPG.Assign(CopyBMP);
 Filename := AppPath + 'cache\Capture.jpg';
 j := 1;
 while FileExists(Filename)=true do begin
   Filename := AppPath + 'cache\Capture'+inttostr(j)+'.jpg';
   j := j+1;
 end;
 LocalJPG.SaveToFile(Filename);

 //VideoBMP[VideoBMPIndex].SaveToFile(AppPath + 'Spy\Spy_'+s+'.bmp');
end;

procedure TframeGetDXImage.btnDevSettingsClick(Sender: TObject);
begin
  VideoImage.ShowProperty;
  CleanPaintBoxVideo;
end;

procedure TframeGetDXImage.btnTakePictureClick(Sender: TObject);
var
  i, x, y, j,
  T1 : integer;
  d  : double;
  s  : string;
  hour, min, sec, msec: word;
begin
  CopyBMP.Width := VideoBMP[VideoBMPIndex].Width;
  CopyBMP.Height := VideoBMP[VideoBMPIndex].Height;
  CopyBMP.Canvas.Draw(0, 0, VideoBMP[VideoBMPIndex]);
  with CopyBMP do begin
    DecodeTime(Now, hour, min, sec, msec);
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut(4, Height-4-Canvas.TextHeight('W'), DateTimetoStr(Now));
    Canvas.Brush.Style := bsSolid;
    Canvas.ellipse(4, 4, 36, 36);
    Canvas.Pen.Color := clBlack;
    for i := 0 TO 11 do begin
      Canvas.Pen.Color := clGray;
      Canvas.Brush.Color := clBlack;
      X := round(20 + 12*Sin(i*30*Pi/180));
      Y := round(20 - 12*cos(i*30*Pi/180));
      Canvas.ellipse(X-2, Y-2, X+2, Y+2);
    end;
    Canvas.Pen.Color := clBlack;
    d := (Hour + min/60) *30 *Pi/180;
    X := round(20 + 7*Sin(d));
    Y := round(20 - 7*cos(d));
    Canvas.Pen.Width := 3;
    Canvas.moveto(20, 20);
    Canvas.LineTo(X, Y);
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := clBlue;
    d := (Min + Sec/60) *6 *Pi/180;
    X := round(20 + 10*Sin(d));
    Y := round(20 - 10*cos(d));
    Canvas.moveto(20, 20);
    Canvas.LineTo(X, Y);
    Canvas.Pen.Color := clRed;
    d := (sec) *6 *Pi/180;
    X := round(20 + 10*Sin(d));
    Y := round(20 - 10*cos(d));
    Canvas.moveto(20, 20);
    Canvas.LineTo(X, Y);
  end;

  //ForceDirectories(AppPath + 'Spy\');
  //Inc(SpyIndex);
  //if SpyIndex <= 4000 then
   //begin
     //s := IntToStr(SpyIndex);
     //while length(s) < 4 do
     //s := '0' + s;
  LocalJPG.Assign(CopyBMP);
  Filename := AppPath + 'cache\Capture.jpg';
  j := 1;
  while FileExists(Filename)=true do begin
    Filename := AppPath + 'cache\Capture'+inttostr(j)+'.jpg';
    j := j+1;
  end;
  LocalJPG.SaveToFile(Filename);

  //VideoBMP[VideoBMPIndex].SaveToFile(AppPath + 'Spy\Spy_'+s+'.bmp');
end;

procedure TframeGetDXImage.CalcDiffImage(BM1, BM2, Diff: TBitmap; var DiffRatio: double);
var
  X, Y      : integer;
  p1, p2, d : pbytearray;
  TotalDiff : integer;
begin
  DiffRatio := 0;
  if (BM1.width <> BM2.width) or (BM1.Height <> BM2.Height) or
     (BM1.pixelformat <> pf24bit) or (BM2.pixelformat <> pf24bit) then begin
    Diff.Width := 1;
    Diff.Height := 1;
    Diff.PixelFormat := pf24bit;
    exit;
  end;

  Diff.Width := BM1.Width;
  Diff.Height := BM1.Height;
  Diff.PixelFormat := pf24bit;  // Not really necessary. pf8bit together with a suitable color palette would be better.

  TotalDiff := 0;
  for Y := BM1.Height-1 downto 0 do begin
    p1 := BM1.ScanLine[Y];
    p2 := BM2.ScanLine[Y];
    d  := Diff.ScanLine[Y];
    for X := 0+3 TO BM1.Width*3-1-3 do begin  // "*3" because we have pf24bit images
      //d^[X] := DiffCol[p1^[X]-p2^[X]];  // Without averaging
      d^[X] := DiffCol[((p1^[X-3]+2*p1^[X]+p1^[X+3])-(p2^[X-3]+2*p2^[X]+p2^[X+3])) div 4];
      Inc(TotalDiff, d^[X]);
    end;
  end;
  DiffRatio := TotalDiff / (3*Diff.Width*Diff.Height*255);
end;


procedure TframeGetDXImage.CalcDiffImage2(BM1, BM2, Diff: TBitmap; var DiffRatio: double);
begin
  CalcDiffImage(BM1, BM2, Diff, DiffRatio);
  if (Diff.width = BM1.width) then begin
    Diff.Canvas.CopyMode := cmSrcPaint;
    Diff.Canvas.Draw(0, 0, BM1);
    Diff.Canvas.CopyMode := cmSrcCopy;
  end;
end;




procedure TframeGetDXImage.OnNewFrame(Sender : TObject; Width, Height: integer; DataPtr: pointer);
var
  i, x, y,
  T1 : integer;
  d  : double;
  s  : string;
  hour, min, sec, msec: word;
begin
  Inc(fFrameCnt);
  if OnNewFrameBusy then begin
    Inc(fSkipCnt);
    exit;
  end;

  OnNewFrameBusy := true;
  // Calculate "Frames per second"...
  if fFrameCnt mod 30 = 0 then begin
    T1 := TimeGetTime;
    if f30FrameTick > 0 then begin
      Label_fps.Caption := 'fps: ' + FloatToStrf(30000 / (T1-f30FrameTick), ffFixed, 16, 1) +
                           ' [' + FloatToStrf(VideoImage.FramesPerSecond, ffFixed, 16, 1) +
                           '] (' + IntToStr(fSkipCnt)+' [' + IntToStr(VideoImage.FramesSkipped) + '] skipped)';
    end;
    f30FrameTick := T1;
  end;

  // In the following part the actual video frame is retreived from VideoImage and than
  // painted to the Paintbox_Video. This is usefull, if the image is to be modified
  // before painting. Otherwise we could have set "VideoImage.SetDisplayCanvas(PaintBox_Video.Canvas);"
  // in routine InitFrame below, and the painting would have been done by VideoImage.

  VideoBMPIndex := 1-VideoBMPIndex;
  VideoImage.GetBitmap(VideoBMP[VideoBMPIndex]);

  if ComboBox_DisplayMode.ItemIndex <= 0 then begin
    PaintBox_Video.Canvas.Draw(0, 0, VideoBMP[VideoBMPIndex]);
  end else begin
    DiffRatio := 0;
    CASE ComboBox_DisplayMode.ItemIndex of
      1    : CalcInvertedImage(VideoBMP[VideoBMPIndex], ModeBMP);
      2    : CalcGrayScaleImage(VideoBMP[VideoBMPIndex], ModeBMP);
      3    : CalcDiffImage(VideoBMP[VideoBMPIndex], VideoBMP[1-VideoBMPIndex], ModeBMP, DiffRatio);
      4, 5 : CalcDiffImage2(VideoBMP[VideoBMPIndex], VideoBMP[1-VideoBMPIndex], ModeBMP, DiffRatio);
      else ModeBMP.assign(VideoBMP[VideoBMPIndex]);
    end; {case}
    PaintBox_Video.Canvas.Draw(0, 0, ModeBMP);
    Label2.Caption := 'Diff-Ratio: ' + FloatToStrF(DiffRatio*100, ffFixed, 16, 3) + '%';
    // Surveillance
    if (DiffRatio > 0.03/100) and (ComboBox_DisplayMode.ItemIndex = 5) THEN begin
      CopyBMP.Width := VideoBMP[VideoBMPIndex].Width;
      CopyBMP.Height := VideoBMP[VideoBMPIndex].Height;
      CopyBMP.Canvas.Draw(0, 0, VideoBMP[VideoBMPIndex]);
      with CopyBMP do begin
        DecodeTime(Now, hour, min, sec, msec);
        Canvas.Brush.Style := bsClear;
        Canvas.TextOut(4, Height-4-Canvas.TextHeight('W'), DateTimetoStr(Now));
        Canvas.Brush.Style := bsSolid;
        Canvas.ellipse(4, 4, 36, 36);
        Canvas.Pen.Color := clBlack;
        for i := 0 TO 11 do begin
          Canvas.Pen.Color := clGray;
          Canvas.Brush.Color := clBlack;
          X := round(20 + 12*Sin(i*30*Pi/180));
          Y := round(20 - 12*cos(i*30*Pi/180));
          Canvas.ellipse(X-2, Y-2, X+2, Y+2);
        end;
        Canvas.Pen.Color := clBlack;
        d := (Hour + min/60) *30 *Pi/180;
        X := round(20 + 7*Sin(d));
        Y := round(20 - 7*cos(d));
        Canvas.Pen.Width := 3;
        Canvas.moveto(20, 20);
        Canvas.LineTo(X, Y);
        Canvas.Pen.Width := 1;
        Canvas.Pen.Color := clBlue;
        d := (Min + Sec/60) *6 *Pi/180;
        X := round(20 + 10*Sin(d));
        Y := round(20 - 10*cos(d));
        Canvas.moveto(20, 20);
        Canvas.LineTo(X, Y);
        Canvas.Pen.Color := clRed;
        d := (sec) *6 *Pi/180;
        X := round(20 + 10*Sin(d));
        Y := round(20 - 10*cos(d));
        Canvas.moveto(20, 20);
        Canvas.LineTo(X, Y);
      end;

      ForceDirectories(AppPath + 'Spy\');
      Inc(SpyIndex);
      if SpyIndex <= 4000 then begin
        s := IntToStr(SpyIndex);
        while length(s) < 4 do
           s := '0' + s;
        LocalJPG.Assign(CopyBMP);
        LocalJPG.SaveToFile(AppPath + 'Spy\Spy_'+s+'.jpg');
        //VideoBMP[VideoBMPIndex].SaveToFile(AppPath + 'Spy\Spy_'+s+'.bmp');
      end;
    end;
  end;
  OnNewFrameBusy := false;
end;


procedure TframeGetDXImage.InitFrame;
var
  i  : integer;
  VP : TVideoProperty;
  TopOffset : integer;
  TrackBarWidth : integer;

const
  DEF_PANEL_OPEN_SIZE = 80;
  DEF_PANEL_CLOSED_SIZE = 70;
  TRACKBAR_LEFT_OFFSET = 100;

begin
  if Initialized then
    EXIT;
  Open_Panel_Height := DEF_PANEL_OPEN_SIZE;
  Closed_Panel_Height := DEF_PANEL_CLOSED_SIZE;

  fSkipCnt := 0;
  Initialized := true;
  LocalJPG := TJPEGImage.create;
  //AppPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  AppPath := GetEnvironmentVariable('USERPROFILE')+'\.CPRS\';
  //SpeedButton_Stop.Enabled := false;
  Stop_Enabled := false;

  // --- Instantiate TVideoImage
  VideoImage := TVideoImage.Create;
  //VideoImage.SetDisplayCanvas(PaintBox_Video.Canvas); // For automatically drawing video frames on paintbox
  VideoImage.SetDisplayCanvas(nil); // For drawing video by ourself
  VideoImage.OnNewVideoFrame := OnNewFrame;

  // --- Load ComboBox_Cams with list of available video interfaces (WebCams...)
  UpdateCamList;

  VideoBMP[0] := TBitmap.Create;
  VideoBMP[1] := TBitmap.Create;
  ModeBMP     := TBitmap.Create;
  CopyBMP     := TBitmap.Create;
  VideoBMP[0].PixelFormat := pf24bit;
  VideoBMP[1].PixelFormat := pf24bit;

  CopyBMP.PixelFormat := pf24bit;
  CopyBMP.Canvas.Font.Name := 'Arial';
  CopyBMP.Canvas.Font.Size := 10;
  CopyBMP.Canvas.Brush.Style := bsclear;

  for i := -255 TO 255 do begin
    if Abs(i) < 48 then begin        // Differences between images must be larger than 24 to be displayed
      DiffCol[i] := 0;
    end else if Abs(i) < 48+64 then begin
      DiffCol[i] := (Abs(i)-48)*4
    end else DiffCol[i] := 255;
  end;

  CamCapture_Enabled := RunVideo_Enabled;
  //MessageDlg('CameraStatus: ' + BoolToStr(CamCapture_Enabled), mtInformation, [mbOK], 0);
  if RunVideo_Enabled then begin
    //MessageDlg('Setting Up Properties', mtInformation, [mbOK], 0);
    //CamCapture_Enabled := true;
    TopOffset := btnSettings.Top + btnSettings.Height + 10;
    TrackBarWidth := Panel_Bottom.Width - TRACKBAR_LEFT_OFFSET - 30;
    for VP := Low(TVideoProperty) TO High(TVideoProperty) do begin
      with PropCtrl[VP] do begin
        PCLabel           := TLabel.Create(Panel_Bottom);
        PCLabel.Parent    := Panel_Bottom;
        PCLabel.Left      := 8;
        PCLabel.Top       := TopOffset  + Integer(VP)*26;
        PCLabel.Caption   := GetVideoPropertyName(VP);
        Open_Panel_Height := PCLabel.Top + 25;

        PCTrackbar        := TTrackBar.Create(Panel_Bottom);
        PCTrackbar.Parent := Panel_Bottom;
        PCTrackbar.Left   := TRACKBAR_LEFT_OFFSET;
        PCTrackbar.Top    := PCLabel.Top-8;
        PCTrackbar.Width  := TrackBarWidth;  //218;
        PCTrackbar.Tag    := integer(VP);
        PCTrackbar.Enabled:= false;
        PCTrackbar.ThumbLength := 9;
        PCTrackbar.Height := 25;
        PCTrackbar.TickMarks := tmTopLeft; //kt tmBoth;
        PCTrackbar.Frequency := 5; //kt
        PCTrackBar.OnChange := PropertyTrackBarChange;
        PCTrackBar.Anchors := [akLeft, akTop, akRight];

        PCCheckbox        := TCheckBox.Create(Panel_Bottom);
        PCCheckbox.Parent := Panel_Bottom;
        PCCheckbox.Left   := PCTrackbar.Left + PCTrackbar.Width + 8;
        PCCheckbox.Top    := PCLabel.Top-3;
        PCCheckbox.Tag    := integer(VP);
        PCCheckbox.Enabled:= false;
        PCCheckbox.Caption:= '';
        PCCheckbox.Width  := PCCheckbox.Height+4;
        PCCheckbox.OnClick:= PropertyCheckBoxClick;
        PCCheckbox.Anchors := [akTop, akRight];
      end;
    end;
    SpeedButton_RunVideoClick(self);  //kt
  end else begin
    btnSettings.Enabled := false;
  end;
  Filename := '';  //kt
end;

procedure TframeGetDXImage.CleanPaintBoxVideo;
begin
  PaintBox_Video.Canvas.Brush.Color := Color;
  PaintBox_Video.Canvas.rectangle(-1, -1, PaintBox_Video.Width+1, PaintBox_Video.Height+1);
end;



procedure TframeGetDXImage.Stop;
begin
  //if SpeedButton_Stop.Enabled then
  if Stop_Enabled then
    SpeedButton_StopClick(nil);
end;



procedure TframeGetDXImage.Close;
begin
  if assigned(VideoImage) then
    begin
      VideoImage.Free;
      VideoImage := nil;
      Initialized := false;
    end;
end;

procedure TframeGetDXImage.Updatelistofcameras1Click(Sender: TObject);
begin
  UpdateCamList;
end;

procedure TframeGetDXImage.ComboBox1Change(Sender: TObject);
begin
  VideoImage.SetResolutionByIndex(Combobox1.itemIndex);
  Label_VideoSize.Caption := 'Video size ' + intToStr(VideoImage.VideoWidth) + ' x ' + IntToStr(VideoImage.VideoHeight);
end;

procedure TframeGetDXImage.SpeedButton_RunVideoClick(Sender: TObject);
{ - Start live video }
var
  i         : integer;
  SL        : TStringList;
  VP        : TVideoProperty;
  MinVal,
  MaxVal,
  StepSize,
  Default,
  Actual    : integer;
  AutoMode  : boolean;
begin
  // Video already initialized, but paused?
  if assigned(VideoImage) then begin
    if VideoImage.IsPaused then begin
      VideoImage.VideoResume;
      //SpeedButton_VidSettings.Enabled   := true;
      //SpeedButton_VidSize.Enabled       := true;
      //SpeedButton_Stop.Enabled     := true;
      Stop_Enabled     := true;
      //SpeedButton_Pause.Enabled    := true;
      //SpeedButton_RunVideo.enabled := false;
      RunVideo_Enabled := false;
      exit;
    end;
  end;

  // Initialize Video
  Screen.Cursor := crHourGlass;
  CleanPaintBoxVideo;
  Application.ProcessMessages;
  // Starting video using name of device
  // i := VideoImage.VideoStart(ComboBox_Cams.Items[ComboBox_Cams.itemIndex]);
  // Starting video using index number of device within list of devices.
  // This helps in case two cameras have the same name.
  i := VideoImage.VideoStart('#' + IntToStr(ComboBox_Cams.itemIndex+1));
  Screen.Cursor := crDefault;
  Application.ProcessMessages;

  if i <> 0 then begin
    MessageDlg('Could not start video (Error '+IntToStr(i)+')', mtError, [mbOK], 0);
    exit;
  end;
  Label_VideoSize.Caption := 'Video size ' + intToStr(VideoImage.VideoWidth) + ' x ' + IntToStr(VideoImage.VideoHeight);
  fFrameCnt := 0;

  //SpeedButton_VidSettings.Enabled   := true;
  //SpeedButton_VidSize.Enabled       := true;
  //SpeedButton_Stop.Enabled     := true;
  Stop_Enabled     := true;
  //SpeedButton_Pause.Enabled    := true;
  //SpeedButton_RunVideo.enabled := false;
  RunVideo_Enabled := false;
  ComboBox_Cams.Enabled        := false;

  SL := TStringList.Create;
  VideoImage.GetListOfSupportedVideoSizes(SL);
  ComboBox1.Items.Assign(SL);
  SL.Free;

  for VP := Low(TVideoProperty) TO High(TVideoProperty) do begin
    if Succeeded(VideoImage.GetVideoPropertySettings(VP, MinVal, MaxVal, StepSize, Default, Actual, AutoMode)) then begin
      with PropCtrl[VP] do begin
          PCLabel.Enabled     := true;
          PCTrackbar.Enabled  := true;
          PCTrackbar.Min      := MinVal;
          PCTrackbar.Max      := MaxVal;
          PCTrackbar.Frequency:= StepSize;
          PCTrackbar.Position := Actual;
          PCCheckbox.Enabled  := true;
          PCCheckbox.Checked  := AutoMode;
      end;
    end else begin
      with PropCtrl[VP] do begin
        PCLabel.Enabled := false;
      end;
    end;
  end;
end;

procedure TframeGetDXImage.SpeedButton_PauseClick(Sender: TObject);
begin
  if assigned(VideoImage) then
    VideoImage.VideoPause;
  //SpeedButton_VidSettings.Enabled := false;
  //SpeedButton_VidSize.Enabled     := false;
  //SpeedButton_Stop.Enabled        := true;
  Stop_Enabled        := true;
  //SpeedButton_Pause.Enabled       := false;
  //SpeedButton_RunVideo.enabled    := true;
  RunVideo_Enabled := true;
end;

procedure TframeGetDXImage.SpeedButton_StopClick(Sender: TObject);
begin
  //SpeedButton_VidSettings.Enabled := false;
  //SpeedButton_VidSize.Enabled := false;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  VideoImage.VideoStop;
  Screen.Cursor := crDefault;
  //SpeedButton_Stop.Enabled := false;
  Stop_Enabled := false;
  //SpeedButton_RunVideo.Enabled := true;
  RunVideo_Enabled := true;
  //SpeedButton_Pause.Enabled    := false;
  ComboBox_Cams.Enabled   := true;
  UpdateCamList;
end;

procedure TframeGetDXImage.SpeedButton_VidSettingsClick(Sender: TObject);
begin
  VideoImage.ShowProperty;
  CleanPaintBoxVideo;
end;

procedure TframeGetDXImage.SpeedButton_VidSizeClick(Sender: TObject);
begin
  if assigned(VideoImage) then begin
    CleanPaintBoxVideo;
    VideoImage.ShowProperty_Stream;
    Label_VideoSize.Caption := 'Video size ' + intToStr(VideoImage.VideoWidth) + ' x ' + IntToStr(VideoImage.VideoHeight);
  end;
end;


procedure TframeGetDXImage.PropertyTrackBarChange(Sender: TObject);
var
  VP : TVideoProperty;
begin
  with Sender as TTrackBar do begin
    VP := TVideoProperty(Tag);
    VideoImage.SetVideoPropertySettings(VP, PropCtrl[VP].PCTrackbar.Position, PropCtrl[VP].PCCheckbox.Checked);
  end;
end;


procedure TframeGetDXImage.PropertyCheckBoxClick(Sender: TObject);
var
  VP : TVideoProperty;
begin
  with Sender as TCheckBox do begin
    VP := TVideoProperty(Tag);
    VideoImage.SetVideoPropertySettings(VP, PropCtrl[VP].PCTrackbar.Position, PropCtrl[VP].PCCheckbox.Checked);
  end;
end;


procedure TframeGetDXImage.ExpandBottom;
begin
  while Panel_Bottom.Height < Open_Panel_Height do begin
    Panel_Bottom.Height := Panel_Bottom.Height + 10;
    if Panel_Bottom.Height > Open_Panel_Height then Panel_Bottom.Height := Open_Panel_Height;
    Application.ProcessMessages;
  end;

  Panel_Bottom.Height := Open_Panel_Height;
  SettingsPanelOpen := true;
  btnSettings.Caption := 'Close &Settings';
  if Assigned(OnSettingsToggle) then OnSettingsToggle(Self);
end;

procedure TframeGetDXImage.CollapseBottom;
begin
  Panel_Bottom.Height := Closed_Panel_Height; //104;
  SettingsPanelOpen := false;
  btnSettings.Caption := 'Open &Settings';
  if Assigned(OnSettingsToggle) then OnSettingsToggle(Self);
end;


procedure TframeGetDXImage.SpeedButton1Click(Sender: TObject);
begin
  if not SettingsPanelOpen then begin
    ExpandBottom;
  end else begin
    CollapseBottom;
  end;
end;

end.
