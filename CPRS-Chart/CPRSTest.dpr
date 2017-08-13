program CPRSTest;

uses
  Forms, TestFramework, GUITestRunner,
  CPRSLibTestCases in 'CPRSLibTestCases.pas';

{$R *.res}

begin
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.
