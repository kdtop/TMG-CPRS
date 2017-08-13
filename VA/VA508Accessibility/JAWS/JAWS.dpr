library JAWS;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  JAWSImplementation in 'JAWSImplementation.pas',
  VAUtils in '..\..\VAUtils.pas',
  VAClasses in '..\..\VAClasses.pas',
  fVA508HiddenJawsMainWindow in 'fVA508HiddenJawsMainWindow.pas' {frmVA508HiddenJawsMainWindow},
  fVA508HiddenJawsDataWindow in 'fVA508HiddenJawsDataWindow.pas' {frmVA508HiddenJawsDataWindow},
  JAWSCommon in 'JAWSCommon.pas',
  VA508AccessibilityConst in '..\VA508AccessibilityConst.pas',
  FSAPILib_TLB in 'FSAPILib_TLB.pas';

{$E SR}

{$R *.res}

begin
end.
