unit fGMV_Splash;
{
================================================================================
*
*       Application:  Vitals Manager
*       Revision:     $Revision: 1 $  $Modtime: 2/27/04 5:41p $
*       Developer:    dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Generic splash form
*
*       Notes:
*
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon/fGMV_Splash.pas $
*
* $History: fGMV_Splash.pas $
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

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComCtrls, jpeg;

type
  TfrmGMV_Splash = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Panel1: TPanel;
    lblVersion: TLabel;
    lblDevelopedAt: TLabel;
    lblReleaseDate: TLabel;
    lblMessage: TLabel;
    pnlPatch: TPanel;
    lblpatch: TLabel;
    lblSecurity: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure UpdateMessage(NewMessage: string; Step: integer = 0);
    { Public declarations }
  end;

var
  GMVSplash: TfrmGMV_Splash;

implementation

uses fGMV_AboutDlg, uGMV_VersionInfo;

{$R *.DFM}

procedure TfrmGMV_Splash.FormCreate(Sender: TObject);
var
  version: string;
  patch: string;
  releasedate: string;
  testversion: Boolean;
  sproductname: string;
begin
  with TVersionInfo.Create(Self) do
    try
      version := VAServerVersion;
      patch := VAPatchNumber;
      releasedate := VAReleaseDate;
      testversion := VATestVersion;
      sproductname := ProductName;
    finally
      free;
    end;

  lblVersion.Caption := 'Version: ' + version;

  lblPatch.Caption := '';
  pnlPatch.Visible := (testversion or (patch <> ''));
  if patch <> '' then
    lblPatch.Caption := 'Patch ' + patch + ' ';

  if testversion then
    lblPatch.Caption := 'Test Release ' + lblPatch.Caption;

  lblReleaseDate.Caption := releasedate;
//  lblInset.Caption := sproductname;
//  lblShadow.Caption := sproductname;
//  lblInset.Font.Color := clActiveCaption;
//  lblShadow.Font.Color := clbtnHighlight;
//  lblShadow.Left := lblInset.Left + 1;
//  lblShadow.Top := lblInset.Top + 1;
  Position := poDesktopCenter;
//  pbStatus.Visible := False;
  Show;
  Application.ProcessMessages;
end;

procedure TfrmGMV_Splash.UpdateMessage(NewMessage: string; Step: integer = 0);
begin
  lblMessage.Caption := NewMessage;
//  pbStatus.Position := Step;
//  pbStatus.Visible := (Step > 0);
  Refresh;
end;

end.

