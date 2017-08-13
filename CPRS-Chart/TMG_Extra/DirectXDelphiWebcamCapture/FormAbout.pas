unit FormAbout;

interface

uses Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  hide;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  Comments.Width := Panel1.Width - 2*Comments.Left;
  Comments.Caption :=    'How to use VSample.pas to access video '+
                         'sources like Web-Cams via DirectShow. '+
                         'Based on Microsoft DirectX samples. '+
                         'Uses DirectX headers from '+
                         'http://www.clootie.ru/delphi.';
  Comments.Width := Panel1.Width - 2*Comments.Left;
end;

end.

