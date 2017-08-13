unit VSampleDemo_MainForm;

interface

uses
  Windows, Classes, Controls, Forms, ExtCtrls, FormAbout, Frame_Video, Menus,
  StdCtrls;


type
  TForm_Main = class(TForm)
    Panel_Left: TPanel;
    Frame_Video1: TFrame1;
    Splitter1: TSplitter;
    Panel_Right: TPanel;
    Frame_Video2: TFrame1;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Quit1: TMenuItem;
    About1: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    SplitterRatio : double;
  public
    { Public declarations }
  end;


var
  Form_Main: TForm_Main;


implementation

{$R *.dfm}







procedure TForm_Main.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Frame_Video1.Stop;
  Frame_Video2.Stop;
  Screen.Cursor := crdefault;
end;



procedure TForm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Frame_Video1.Close;
  Frame_Video2.Close;
end;

procedure TForm_Main.FormShow(Sender: TObject);
begin
  Frame_Video1.InitFrame;
  Frame_Video2.InitFrame;
  Frame_Video2.Label_Cameras.Caption := 'Camera #2';
end;

procedure TForm_Main.Quit1Click(Sender: TObject);
begin
  close;
end;

procedure TForm_Main.About1Click(Sender: TObject);
begin
  AboutBox.Show;
end;

procedure TForm_Main.Splitter1Moved(Sender: TObject);
begin
  SplitterRatio := (Panel_Left.Width+Splitter1.Width div 2) / Width;
end;

procedure TForm_Main.FormCreate(Sender: TObject);
begin
  SplitterRatio := 0.5;
end;

procedure TForm_Main.FormResize(Sender: TObject);
begin
  Panel_Left.Width := round(SplitterRatio * (Width-Splitter1.Width div 2));
end;

end.
