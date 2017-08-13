program Showcase1;

uses
  Forms,
  Showcase1Unit in 'Showcase1Unit.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
