program killthisProject;

uses
  Vcl.Forms,
  killthis in 'killthis.pas' {Form1} ,
  uPngGlyphButton in '..\uPngGlyphButton.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
