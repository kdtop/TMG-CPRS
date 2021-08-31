program MDMGrid;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  MDMHelper in 'MDMHelper.pas' {frmMDMGrid},
  CollapsablePanelU in 'CollapsablePanelU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
