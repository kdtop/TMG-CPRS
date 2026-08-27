program Vitals;

uses
  SysUtils,
  Forms,
  fGMV_UserMain in 'fGMV_UserMain.pas' {frmGMV_UserMain},
  fGMV_PtSelect in '..\VitalsPatient\fGMV_PtSelect.pas' {frmGMV_PtSelect},
  uGMV_Utils in '..\VitalsUtils\uGMV_Utils.pas',
  uGMV_FileEntry in '..\VitalsCommon\uGMV_FileEntry.pas',
  uGMV_Const in '..\VitalsUtils\uGMV_Const.pas',
  uGMV_GlobalVars in '..\VitalsUtils\uGMV_GlobalVars.pas',
  fGMV_Splash in '..\VitalsCommon\fGMV_Splash.pas' {frmGMV_Splash},
  fGMV_AboutDlg in '..\VitalsCommon\fGMV_AboutDlg.pas' {frmGMV_AboutDlg},
  uGMV_User in '..\VitalsCommon\uGMV_User.pas',
  fGMV_TimeOutManager in '..\VitalsCommon\fGMV_TimeOutManager.pas' {frmGMV_TimeOutManager},
  fGMV_PtInfo in '..\VitalsPatient\fGMV_PtInfo.pas' {fraGMV_PatientInfo},
  fGMV_ReportOptions in '..\VitalsPatient\fGMV_ReportOptions.pas' {frmGMV_ReportOptions},
  fGMV_EnteredInError in '..\VitalsDataEntry\fGMV_EnteredInError.pas' {frmGMV_EnteredInError},
  uGMV_QualifyBox in '..\VitalsDataEntry\uGMV_QualifyBox.pas',
  fGMV_UserSettings in '..\VitalsCommon\fGMV_UserSettings.pas' {frmGMV_UserSettings},
  fGMV_SelectColor in '..\VitalsCommon\fGMV_SelectColor.pas' {frmGMV_SelectColor},
  uGMV_SaveRestore in '..\VitalsCommon\uGMV_SaveRestore.pas',
  fGMV_DateRange in '..\VitalsCommon\fGMV_DateRange.pas' {frmGMV_DateRange},
  fGMV_ShowSingleVital in '..\VitalsView\fGMV_ShowSingleVital.pas' {frmGMV_ShowSingleVital},
  mGMV_InputOne2 in '..\VitalsDataEntry\mGMV_InputOne2.pas' {fraGMV_InputOne2: TFrame},
  fGMV_SupO2 in '..\VitalsDataEntry\fGMV_SupO2.pas' {frmGMV_SupO2},
  fGMV_Qualifiers in '..\VitalsDataEntry\fGMV_Qualifiers.pas' {frmGMV_Qualifiers},
  frmGMV_DateTime in '..\VitalsDateTime\frmGMV_DateTime.pas' {fGMV_DateTime},
  mGMV_GridGraph in '..\VitalsView\mGMV_GridGraph.pas' {fraGMV_GridGraph: TFrame},
  uGMV_Patient in '..\VitalsCommon\uGMV_Patient.pas',
  fGMV_InputLite in '..\VitalsDataEntry\fGMV_InputLite.pas' {frmGMV_InputLite},
  mGMV_MDateTime in '..\VitalsCommon\mGMV_MDateTime.pas',
  fGMV_EditUserTemplates in '..\VitalsCommon\fGMV_EditUserTemplates.pas',
  mGMV_EditTemplate in '..\VitalsCommon\mGMV_EditTemplate.pas' {fraGMV_EditTemplate: TFrame},
  fGMV_AddVCQ in '..\VitalsCommon\fGMV_AddVCQ.pas' {frmGMV_AddVCQ},
  uGMV_Common in '..\VitalsUtils\uGMV_Common.pas',
  uGMV_CRC32 in '..\VitalsUtils\uGMV_CRC32.pas',
  uGMV_VersionInfo in '..\VitalsUtils\uGMV_VersionInfo.pas',
  uGMV_VitalTypes in '..\VitalsCommon\uGMV_VitalTypes.pas',
  RS232 in '..\CASMED\RS232.pas',
  uVHA_ATE740X in '..\CASMED\uVHA_ATE740X.pas',
  uROR_RPCBroker in '..\ROR\uROR_RPCBroker.pas',
  fROR_PCall in '..\ROR\fROR_PCall.pas' {RPCErrorForm},
  uGMV_EXEVersion in '..\VitalsUtils\uGMV_EXEVersion.pas',
  uGMV_Engine in '..\VitalsUtils\uGMV_Engine.pas',
  uGMV_Template in '..\VitalsDataEntry\uGMV_Template.pas',
  uGMV_Setup in '..\VitalsCommon\uGMV_Setup.pas',
  fGMV_PatientSelector in '..\VitalsPatient\fGMV_PatientSelector.pas' {frmGMV_PatientSelector},
  uGMV_DLLCommon in '..\VitalsUtils\uGMV_DLLCommon.pas',
  uGMV_Monitor in '..\VSMonitors\uGMV_Monitor.pas',
  uXML in '..\VitalsUtils\uXML.pas',
  fGMV_HospitalSelector2 in '..\VitalsDataEntry\fGMV_HospitalSelector2.pas' {frmGMV_HospitalSelector2},
  uROR_Contextor in '..\..\..\CCR_Components\Components\uROR_Contextor.pas',
  uROR_CustomControls in '..\..\..\CCR_Components\Components\uROR_CustomControls.pas',
  uROR_CustomListView in '..\..\..\CCR_Components\Components\uROR_CustomListView.pas',
  uROR_CustomSelector in '..\..\..\CCR_Components\Components\uROR_CustomSelector.pas',
  uROR_SelectorTree in '..\..\..\CCR_Components\Components\uROR_SelectorTree.pas',
  uROR_SearchEdit in '..\..\..\CCR_Components\Components\uROR_SearchEdit.pas',
  uROR_Selector in '..\..\..\CCR_Components\Components\uROR_Selector.pas',
  uROR_SelectorGrid in '..\..\..\CCR_Components\Components\uROR_SelectorGrid.pas',
  uROR_VistAStore in '..\..\..\CCR_Components\Components\uROR_VistAStore.pas',
  uROR_State in '..\..\..\CCR_Components\Components\uROR_State.pas',
  uROR_TreeGrid in '..\..\..\CCR_Components\Components\uROR_TreeGrid.pas',
  uROR_Utilities in '..\..\..\CCR_Components\Components\uROR_Utilities.pas';

{$R *.res}

begin

  Application.Initialize;

  GMVSplash := TfrmGMV_Splash.Create(application);
  GMVSplash.Show;
  GMVSplash.UpdateMessage('Establishing VistA Connection...');

  Application.CreateForm(TfrmGMV_UserMain, frmGMV_UserMain);
  Application.CreateForm(TfrmGMV_SelectColor, frmGMV_SelectColor);
  frmGMV_UserMain.fraGMV_GridGraph1.SetUpFrame; // vhaishandria 051202
  if not frmGMV_UserMain.RestoreConnection then // will create Broker
      begin
        FreeAndNil(frmGMV_UserMain);
        FreeAndNil(GMVSplash);
        Exit;
      end;

  GMVSplash.Hide;

  Application.Title := 'Vitals 5.0.3.19';
  Application.HelpFile := '';

  frmGMV_UserMain.RestoreSettings;

  InitTimeOut(nil);
  UpdateTimeOutInterval(GMVUser.DTime);
  Application.Run;
  ShutDownTimeOut;

  FreeAndNil(GMVDefaultTemplates);
  FreeAndNil(GMVClinics);
  FreeAndNil(GMVTeams);
  FreeAndNil(GMVWardLocations);
  FreeAndNil(GMVNursingUnits);
  FreeAndNil(GMVCats);
  FreeAndNil(GMVQuals);
  FreeAndNil(GMVTypes);

  FreeAndNil(GMVUser);
  FreeAndNil(RPCBroker);
  FreeAndNil(GMVSplash);

end.
