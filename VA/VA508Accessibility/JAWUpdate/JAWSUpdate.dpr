program JAWSUpdate;

uses
  Forms,
  Message in 'Message.pas' {frmMessage},
  VAClasses in '..\..\VAClasses.pas',
  FSAPILib_TLB in '..\JAWS\FSAPILib_TLB.pas',
  VAUtils in '..\..\VAUtils.pas',
  VA508AccessibilityConst in '..\VA508AccessibilityConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMessage, frmMessage);
  Application.Run;
end.
