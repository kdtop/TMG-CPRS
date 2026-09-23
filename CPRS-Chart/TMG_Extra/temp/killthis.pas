unit killthis;

interface

uses
        Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
        System.Classes, Vcl.Graphics,
        uPngGlyphButton,
        Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.BaseImageCollection, Vcl.ImageCollection;

type
        TForm1 = class(TForm)
                Panel1: TPanel;
                btnLoadGlyph: TButton;
    ImageCollection1: TImageCollection;
                procedure FormCreate(Sender: TObject);
                procedure FormDestroy(Sender: TObject);
                procedure btnLoadGlyphClick(Sender: TObject);
                procedure Panel1Click(Sender: TObject);
        private
                { Private declarations }
                button: TPngGlyphButton;
        public
                { Public declarations }
        end;

var
        Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  button := nil;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  button.Free;
end;

procedure TForm1.btnLoadGlyphClick(Sender: TObject);
begin
  if button = nil then
  begin
    button := TPngGlyphButton.Create(Self);
    button.Parent := Panel1;
    button.Left := 8;
    button.Top := 8;
  end;

  button.LoadGlyph(ImageCollection1, 'TestGlyph');
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
  Panel1.Color := RGB(Random(256), Random(256), Random(256));
end;

end.
