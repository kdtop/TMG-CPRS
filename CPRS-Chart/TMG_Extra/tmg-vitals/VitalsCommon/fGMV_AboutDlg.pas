unit fGMV_AboutDlg;
{
================================================================================
*
*	Application:  Vitals
*	Revision:     $Revision: 2 $  $Modtime: 7/06/05 8:49a $
*	Developer:    dan.petit@med.va.gov
*                     modified from BCMA Application by BKurtze@Dallas CIOFO
*	Site:         Hines OIFO
*
*	Description:  This is an About Dialog which displays data from the project
*                     VersionInfo block for the application.
*
*	Notes:        Delphi developer must add Keys VAReleaseDate and VANamespace
*                     Under Project|Options on the Version Info tab for the version,
*                     patch, and release date information to show up on the form.
*
*
================================================================================
*	$Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsCommon/fGMV_AboutDlg.pas $
*
* $History: fGMV_AboutDlg.pas $
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 7/06/05    Time: 12:11p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:33p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:17p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSCOMMON
 *
*
================================================================================
}

interface

uses Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  Buttons,
  ExtCtrls,
  Filectrl,
  uGMV_Common
  , uGMV_VersionInfo, jpeg
  ;

type
  TfrmGMV_AboutDlg = class(TForm)
    pnlImage: TPanel;
    Panel1: TPanel;
    lblProductNameShadow: TLabel;
    lblProductNameInset: TLabel;
    lblClientVersion: TLabel;
    lblCopyright: TLabel;
    lblReleaseDate: TLabel;
    Label2: TLabel;
    lblReleaseDateLabel: TLabel;
    Label4: TLabel;
    lblPatchLabel: TLabel;
    lblPatch: TLabel;
    Label1: TLabel;
    lblHelpFile: TLabel;
    lblSecurity: TLabel;
    Label3: TLabel;
    lblServerVersion: TLabel;
    lblCompileDate: TLabel;
    lblCRCValue: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblSourceInfo: TLabel;
    OKButton: TButton;
    Panel3: TPanel;
    pnlComments: TPanel;
    Image: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure lblCommentsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    (*
      Uses TVersionInfo to read the Version Info for application.ExeName into
      the form's display fields.
    *)
  private
  public
    procedure Execute;
  end;

var
  GMVAboutDlg: TfrmGMV_AboutDlg;

implementation

{$R *.DFM}
uses
  Dialogs
  , Math
  ,  uGMV_CRC32
  ;

(*=== AboutDlg Methods ======================================================*)

procedure TfrmGMV_AboutDlg.Execute;
begin
  with TfrmGMV_AboutDlg.Create(self) do
  try
    pnlComments.Align := alClient;
    Image.Align := alClient;
    showModal;
  finally
    free;
  end;
end;

procedure TfrmGMV_AboutDlg.FormCreate(Sender: TObject);
var
  s: String;
begin
{$IFDEF DLL}
  s := GetProgramFilesPath+'\Vista\Common Files\GMV_VitalsViewEnter.hlp';
  lblCRCValue.Caption := GetFileCRC32(GetProgramFilesPath + '\Vista\Common Files\GMV_VitalsViewEnter.Dll');
{$ELSE}
  s := ExtractFileDir(Application.ExeName) + '\Help\'+
       ChangeFileExt(ExtractFileName(Application.ExeName),'.hlp');
  lblCRCValue.Caption := GetFileCRC32(Application.Exename);
{$ENDIF}

  lblProductNameInset.Font.Color := clActiveCaption;
  lblProductNameShadow.Font.Color := clBtnHighlight;

  lblProductNameShadow.Top := lblProductNameInset.Top + 1;
  lblProductNameShadow.Left := lblProductNameInset.Left + 1;

  lblHelpFile.Caption := MinimizeName(s, lblHelpFile.Canvas, lblHelpFile.Width);
  lblHelpFile.Hint := 'Help file name: ' + s;
  lblHelpFile.ShowHint := (Pos('...', lblHelpFile.Caption) > 0);

  with TVersionInfo.Create(self) do
  try
    lblProductNameInset.Caption := ProductName;
    lblProductNameShadow.Caption := ProductName;

    Self.Caption := 'About ' + ProductName;// {$IFDEF DLL} + ' ('+Comments+')'{$ENDIF} ;

    lblSourceInfo.Caption := VASourceInformation;
    lblClientVersion.Caption := FileVersion;
    lblServerVersion.Caption := VAServerVersion;
    lblPatch.Caption := VAPatchNumber;
    lblPatchLabel.Visible := (VAPatchNumber <> '');
    lblCompileDate.Caption := FormatDateTime('mm/dd/yy hh:mm:ss',CompileDateTime);
    lblReleaseDate.Caption := VAReleaseDate;
    lblCopyright.Caption := LegalCopyRight;
  finally
    free;
  end;
end;

procedure TfrmGMV_AboutDlg.lblCommentsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Delay,
  iStep,
  i: Integer;
const
  clText = clNavy;

  procedure GrowRightCentered(aCanvas:TCanvas;aWait:Integer;
    aXMargin,Y,aWidth:Integer;aFColor:TColor;aText:String);
  var
    ii,i: integer;
  begin
    with aCanvas do
      begin
        Font.Style := [fsBold];
        ii := TextWidth(aText);
        ii := (aWidth - ii) div 2;
        aXMargin := ii;
        ii := TextHeight(aText);
        Font.Color := aFColor;
        for i := aXMargin to aWidth - aXMargin do
          begin
            FillRect(Rect(aXMargin,y,i,y+ii));
            TextRect(Rect(aXMargin,y,i,y+ii),aXMargin,y,aText);
            sleep(aWait);
          end;
      end;
    Application.ProcessMessages;
  end;

  procedure GrowRight(aCanvas:TCanvas;aWait:Integer;
    aXMargin,Y,aWidth:Integer;aFColor:TColor;aText:String);
  var
    iLen,iWidth, iHeight,
    i: integer;
  begin
    with aCanvas do
      begin
        Font.Style := [fsBold];
        iWidth := TextWidth(aText);
        iHeight := TextHeight(aText);
        Font.Color := aFColor;
        iLen := Min(iWidth, aWidth - aXMargin);
        for i := aXMargin to iLen do
          begin
            FillRect(Rect(aXMargin,y,i,y+iHeight));
            TextRect(Rect(aXMargin,y,i,y+iHeight),aXMargin,y,aText);
            sleep(aWait);
          end;
      end;
  end;

  procedure SlideRight(aCanvas:TCanvas;aWait:Integer;
    aXMargin,Y,AwIDTH:Integer;aFColor:TColor;aText:String);
  var
    iWidth, iHeight,
    i: integer;
  begin
    with aCanvas do
      begin
//        Font.Style := [fsBold];
        Font.Style := [];
        iWidth := TextWidth(aText);
        iHeight := TextHeight(aText);
        Font.Color := aFColor;
        for i := aXMargin to aXMargin+iWidth do
          begin
            TextRect(Rect(aXMargin,y,i,y+iHeight),aXMargin,y,aText);
            sleep(aWait);
          end;
      end;
    Application.ProcessMessages;
  end;

  procedure SlideLeft(aCanvas:TCanvas;aWait:Integer;
    aXMargin,Y,aWidth:Integer;aFColor:TColor;aText:String);
  var
    iX,
    iLen,iWidth, iHeight,
    i: integer;
  begin
    with aCanvas do
      begin
        iLen := 0;
        Font.Style := [];
        iWidth := TextWidth(aText);
        iHeight := TextHeight(aText);
        Font.Color := aFColor;
        iX := Max(aXMargin,aWidth-iWidth-aXMargin);
        for i := aWidth - aXMargin downto iX do
          begin
            iLen := Min(iWidth,aWidth - aXMargin - i);
            FillRect(Rect(i,y,i+iLen+2,y+iHeight));
            TextRect(Rect(i,y,i+iLen,y+iHeight),i,y,aText);
            if  (aWidth-aXMargin-i)> 0 then
              begin
//                iT := aWait*(aWidth-aXMargin-i) div (aWidth-aXMargin);
//                sleep(iT*iT);
                  Sleep(aWait);
              end;
          end;
        FillRect(Rect(i,y,i+iLen+2,y+iHeight));
        Font.Style := [];
        TextRect(Rect(i,y,i+iLen,y+iHeight),i,y,aText);
      end;
    Application.ProcessMessages;
  end;

begin
  Delay := 70;
  if (Button = mbRight) and (ssShift in Shift) and (ssCtrl in Shift) then
    begin
      pnlComments.Visible := True;
      Image.Canvas.Brush.Color := clSilver;
      Image.Canvas.FillRect(Rect(0,0,Image.Width, Image.Height));
      i := 10;
      GrowRightCentered(Image.Canvas,0, Delay, i,Image.Width,clText,'Introducing the Vitals V5.0.3 Development Team:');
      SlideRight(Image.Canvas, 10, Delay, i+20,Image.Width,clText,'Julius Chou:');
      SlideLeft(Image.Canvas, 0, Delay, i+20,Image.Width,clText,  'Program Director');

      SlideRight(Image.Canvas, 10, Delay, i+35,Image.Width,clText,'Barbara Lang:');
      SlideLeft(Image.Canvas, 0, Delay, i+35,Image.Width,clText,  'Project Manager');

      SlideRight(Image.Canvas,10, Delay, i+50,Image.Width,clText, 'Dan Petit:');
      SlideLeft(Image.Canvas, 0, Delay, i+50,Image.Width,clText,  'GUI Development');
      SlideLeft(Image.Canvas, 0, Delay, i+65,Image.Width,clText,  'M Development');

      SlideRight(Image.Canvas,10, Delay, i+80,Image.Width,clText, 'Andrey Andriyevskiy:');
      SlideLeft(Image.Canvas, 0, Delay, i+80,Image.Width,clText,  'GUI Development' );

      SlideRight(Image.Canvas,10, Delay, i+95,Image.Width,clText, 'Frank Traxler:');
      SlideLeft(Image.Canvas, 0, Delay, i+95,Image.Width,clText,  'M Development' );

      SlideRight(Image.Canvas,10, Delay, i+110,Image.Width,clText,'Marlie Gaddie:');
      SlideLeft(Image.Canvas, 0, Delay, i+110,Image.Width,clText, 'Technical Writer');

      SlideRight(Image.Canvas,10, Delay, i+125,Image.Width,clText,'Christine Long:');
      SlideLeft(Image.Canvas, 0, Delay, i+125,Image.Width,clText, 'Technical Writer');

      SlideRight(Image.Canvas,0, Delay, i+140,Image.Width,clText, 'Charmaine Reznik:');
      SlideLeft(Image.Canvas, 0, Delay, i+140,Image.Width,clText, 'SQA Analyst');

      SlideRight(Image.Canvas, 10, Delay, i+155,Image.Width,clText,'Nancy Thornton:');
      SlideLeft(Image.Canvas, 0, Delay, i+155,Image.Width,clText,  'NVS Release Manager');

      sleep(7000);
      pnlComments.Visible := False;
    end;
end;

procedure TfrmGMV_AboutDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then close;
end;

end.

