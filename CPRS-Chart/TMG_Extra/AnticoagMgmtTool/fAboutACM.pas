unit fAboutACM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, {VA508AccessibilityManager,} jpeg;

type
  TfrmAboutACM = class(TForm)
    Panel1: TPanel;
    Logo: TImage;
    cmdOK: TButton;
    lblProductName: TStaticText;
    lblFileVersion: TStaticText;
    lblCompanyName: TStaticText;
    lblComments: TStaticText;
    lblCRC: TStaticText;
    lblLegalCopyright: TMemo;
    bvlBottom: TBevel;
    lblFileDescription: TStaticText;
    lblInternalName: TStaticText;
    lblOriginalFileName: TStaticText;
    bvl508Disclaimer: TBevel;
    lbl508Notice: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAboutACM;

implementation

{$R *.DFM}

uses VAUtils, ORFn;

procedure ShowAboutACM;
var frmAboutACM: TfrmAboutACM;
begin
  frmAboutACM := TfrmAboutACM.Create(Application);
  try
    frmAboutACM.lblLegalCopyright.SelStart := 0;
    frmAboutACM.lblLegalCopyright.SelLength := 0;
    frmAboutACM.lbl508Notice.SelStart := 0;
    frmAboutACM.lbl508Notice.SelLength := 0;
    frmAboutACM.ShowModal;
  finally
    frmAboutACM.Release;
  end;
end;

procedure TfrmAboutACM.FormCreate(Sender: TObject);
begin
  inherited;
  lblCompanyName.Caption        := 'Developed by the ' + FileVersionValue(Application.ExeName, FILE_VER_COMPANYNAME);
  lblFileDescription.Caption    := 'Compiled ' + FileVersionValue(Application.ExeName, FILE_VER_FILEDESCRIPTION);  //date
  lblFileVersion.Caption        := FileVersionValue(Application.ExeName, FILE_VER_FILEVERSION);
  lblInternalName.Caption       := FileVersionValue(Application.ExeName, FILE_VER_INTERNALNAME);
  lblLegalCopyright.Text        := FileVersionValue(Application.ExeName, FILE_VER_LEGALCOPYRIGHT);
  lblOriginalFileName.Caption   := FileVersionValue(Application.ExeName, FILE_VER_ORIGINALFILENAME);  //patch
  lblProductName.Caption        := FileVersionValue(Application.ExeName, FILE_VER_PRODUCTNAME);
  lblComments.Caption           := FileVersionValue(Application.ExeName, FILE_VER_COMMENTS);  // version comment
  lblCRC.Caption                := 'CRC: ' + IntToHex(CRCForFile(Application.ExeName), 8);
end;

end.
