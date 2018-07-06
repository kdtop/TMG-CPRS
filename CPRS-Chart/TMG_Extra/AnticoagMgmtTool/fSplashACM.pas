unit fSplashACM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, {VA508AccessibilityManager, VA508AccessibilityRouter,} jpeg;

type
  TfrmSplashACM = class(TForm)
    pnlMain: TPanel;
    lblVersion: TStaticText;
    lblCopyright: TStaticText;
    pnlImage: TPanel;
    imgSplash: TImage;
    lblSplash: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplashACM: TfrmSplashACM;

  procedure ACMSplashOpen;
  procedure ACMSplashClose;

implementation

{$R *.DFM}

uses VAUtils;

procedure TfrmSplashACM.FormCreate(Sender: TObject);
var
  ver: String;
begin
  ver := FileVersionValue(Application.ExeName, FILE_VER_FILEVERSION);
  lblVersion.Caption := 'version ' + ver;
  lblVersion.Invalidate;
  //amSplash.AccessText[lblSplash] := amSplash.AccessText[lblSplash] + ' version ' + ver;
  lblSplash.Invalidate;
end;

procedure ACMSplashOpen;
begin
  frmSplashACM := nil;
  frmSplashACM := TfrmSplashACM.Create(Application);
  frmSplashACM.Show;
  frmSplashACM.Invalidate;
end;

procedure ACMSplashClose;
begin
  if assigned(frmSplashACM) then frmSplashACM.Release;
  frmSplashACM := nil;
  //frmSplash.Free;
end;

procedure TfrmSplashACM.FormShow(Sender: TObject);
begin
  lblSplash.SetFocus;
end;

initialization
  //SpecifyFormIsNotADialog(TfrmSplashACM);

end.
