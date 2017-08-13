unit fTMG_DirectX_GetImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Frame_Video, StdCtrls, Buttons, ExtCtrls;

type
  TfrmGetDXImage = class(TForm)
    pnlBottom: TPanel;
    btnTakePicture: TBitBtn;
    btnCancel: TBitBtn;
    pnlTop: TPanel;
    frameGetDXImage1: TframeGetDXImage;
    btnDevSettings: TBitBtn;
    procedure btnDevSettingsClick(Sender: TObject);
    procedure frameGetDXImage1btnSettingsClick(Sender: TObject);
    procedure btnTakePictureClick(Sender: TObject);
    procedure frameGetDXImage1btnTakePictureClick(Sender: TObject);
    procedure frameGetDXImage1SpeedButton1Click(Sender: TObject);
    procedure frameGetDXImage1BitBtn1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure HandleSettingsToggled(Sender : TObject);
  public
    { Public declarations }
  end;

var
  frmGetDXImage: TfrmGetDXImage;

implementation

{$R *.dfm}



procedure TfrmGetDXImage.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  frameGetDXImage1.Stop;
  Screen.Cursor := crdefault;
end;




procedure TfrmGetDXImage.btnDevSettingsClick(Sender: TObject);
begin
  frameGetDXImage1.btnDevSettingsClick(Sender);
end;

procedure TfrmGetDXImage.btnTakePictureClick(Sender: TObject);
begin
//kt
  frameGetDXImage1.btnTakePictureClick(Sender);
end;

procedure TfrmGetDXImage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frameGetDXImage1.Close;
end;

procedure TfrmGetDXImage.FormShow(Sender: TObject);
begin
  frameGetDXImage1.InitFrame;
  frameGetDXImage1.CollapseBottom;
  btnTakePicture.Enabled := frameGetDXImage1.CamCapture_Enabled;
end;


procedure TfrmGetDXImage.frameGetDXImage1BitBtn1Click(Sender: TObject);
begin
  inherited;
  self.ModalResult := mrOK;
end;

procedure TfrmGetDXImage.frameGetDXImage1btnSettingsClick(Sender: TObject);
begin
  frameGetDXImage1.SpeedButton1Click(Sender);

end;

procedure TfrmGetDXImage.frameGetDXImage1btnTakePictureClick(Sender: TObject);
begin
  frameGetDXImage1.btnTakePictureClick(Sender);

end;

procedure TfrmGetDXImage.frameGetDXImage1SpeedButton1Click(Sender: TObject);
begin
  frameGetDXImage1.SpeedButton1Click(Sender);

end;

//procedure TfrmGetDXImage.Splitter1Moved(Sender: TObject);
//begin
  //SplitterRatio := (Panel_Left.Width+Splitter1.Width div 2) / Width;
//end;

procedure TfrmGetDXImage.FormCreate(Sender: TObject);
begin
  //SplitterRatio := 0.5;
  frameGetDXImage1.OnSettingsToggle := HandleSettingsToggled;
end;



procedure TfrmGetDXImage.FormResize(Sender: TObject);
begin
  //Panel_Left.Width := round(SplitterRatio * (Width-Splitter1.Width div 2));
end;

procedure TfrmGetDXImage.HandleSettingsToggled(Sender : TObject);
begin
  btnDevSettings.Visible := frameGetDXImage1.SettingsPanelOpen;
end;


end.

