unit fPatientVitals;  //kt //codex 8/26/26

interface

uses
  System.UITypes, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, //kt //codex 8/30/26
  Dialogs, mGMV_GridGraph, ExtCtrls, StdCtrls, ComCtrls
  , ImgList
  , mGMV_MDateTime, Menus
  , ShellAPI, AppEvnts
  ;

type
  TfrmPatientVitals = class(TForm)  //kt //codex 8/26/26
    TfraGMV_GridGraph1: TfraGMV_GridGraph;
    MainMenu1: TMainMenu;
    E1: TMenuItem;
    EnterVitals1: TMenuItem;
    N1: TMenuItem;
    Allergies1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    Index1: TMenuItem;
    About1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    EnteredinError1: TMenuItem;
    PrintGraph1: TMenuItem;
    ShowHideGraphOptions1: TMenuItem;
    SelectGraphColor1: TMenuItem;
    VitalsWe1: TMenuItem;
    AppEv: TApplicationEvents;
    N4: TMenuItem;
    PatientInformation1: TMenuItem;
    VitalsReport1: TMenuItem;
    procedure TfraGMV_GridGraph1acEnterVitalsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TfraGMV_GridGraph1acEnteredInErrorExecute(Sender: TObject);
    procedure TfraGMV_GridGraph1acPatientAllergiesExecute(Sender: TObject);
    procedure TfraGMV_GridGraph1sbGraphColorClick(Sender: TObject);
    procedure TfraGMV_GridGraph1SpeedButton1Click(Sender: TObject);
    procedure TfraGMV_GridGraph1SelectGraphColor1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Index1Click(Sender: TObject);
    procedure SelectGraphColor1Click(Sender: TObject);
    procedure VitalsWe1Click(Sender: TObject);
    function AppEvHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure VitalsReport1Click(Sender: TObject);
  private
    { Private declarations }
    fFileVersion,
    fFileComments,
    ptName,
    ptInfo: String;
    FMDateTimeRange: TMDateTimeRange;
    fIgnoreCount: Integer;
  public
    { Public declarations }
    property FileVersion:String read fFileVersion;
    property FileComments:String read fFileComments;
  protected
  end;

var
  frmPatientVitals: TfrmPatientVitals;  //kt //codex 8/26/26

// the next function is used by CPRS ///////////////////////////////////////
function ProcessInPatientVitals(
  aDFN,
  aLocation,
  DateStart,
  DateStop,
  aSignature,
  aName,
  anInfo,
  aHospitalName:String):Integer;

////////////////////////////////////////////////////////////////////////////////

function getVitalsForm(
  aDFN,
  aLocation,
  DateStart,
  DateStop,
  aSignature,
  aName,
  anInfo,
  aHospitalName:String):TfrmPatientVitals;  //kt //codex 8/26/26


implementation

uses
   uGMV_Engine, uGMV_VersionInfo, uGMV_User, uGMV_Common, fGMV_AboutDlg,
  fGMV_PtInfo;

var
  PrevApp: TApplication;
  PrevScreen: TScreen;

{$R *.dfm}

function getFrmVitals(aDFN, aLocation, DateStart, DateStop,aSignature,aName,anInfo,aHospitalName:String): TfrmPatientVitals;  //kt //codex 8/26/26
var
  aForm: TfrmPatientVitals;  //kt //codex 8/26/26
  aDT: TDateTime;
  sHospitalName, sVitalABB:String;

  function EditHospitalName:String;
  var
    i: Integer;
  begin
    i := pos('^',aHospitalName);
    if i > 0 then
      Result := copy(aHospitalName,1,i-1)
    else
      Result := aHospitalName;
  end;

begin
  try
    Application.CreateForm(TfrmPatientVitals,aForm);  //kt //codex 8/26/26

    aForm.TfraGMV_GridGraph1.FrameStyle := 'CPRS';
    aForm.TfraGMV_GridGraph1.UpdateGridColors1.Visible := False;

    if not aForm.TfraGMV_GridGraph1.FrameInitialized then aForm.TfraGMV_GridGraph1.SetupFrame;

    aForm.FMDateTimeRange.Start.setSWDateTime(DateStart);
    aForm.FMDateTimeRange.Stop.setSWDateTime(DateStop);

    if Trunc(aForm.FMDateTimeRange.Stop.WDate) = trunc (Now) then
      begin
        aDT := Now;
        aForm.FMDateTimeRange.Stop.WDate := aDT;
        aForm.FMDateTimeRange.Stop.WTime := aDT;
      end;
    aForm.TfraGMV_GridGraph1.MDateTimeRange := aForm.FMDateTimeRange; // property updates labels only

    aForm.TfraGMV_GridGraph1.PatientLocation := aLocation;

    aForm.TfraGMV_GridGraph1.IgnoreCount := aForm.TfraGMV_GridGraph1.IgnoreCount + 1;
    aForm.TfraGMV_GridGraph1.PatientDFN := aDFN;                   // property
    aForm.TfraGMV_GridGraph1.lbDateRange.Items.Add(aForm.TfraGMV_GridGraph1.lblDateFromTitle.Caption); //vhaishandria 051221
    aForm.TfraGMV_GridGraph1.lbDateRange.ItemIndex :=     aForm.TfraGMV_GridGraph1.lbDateRange.Items.Count -1;
    aForm.TfraGMV_GridGraph1.IgnoreCount := aForm.TfraGMV_GridGraph1.IgnoreCount - 1;

    aForm.TfraGMV_GridGraph1.SetGraphTitle(aName,anInfo);
    
    aForm.ptName := aName;
    aForm.ptInfo := anInfo;

//    aForm.TfraGMV_GridGraph1.lblPatientName.Caption := aName;   // vaishandria 050322
//    aForm.TfraGMV_GridGraph1.lblPatientInfo.Caption := anInfo;  // vaishandria 050322
    aForm.TfraGMV_GridGraph1.edPatientName.Text := aName;   // vaishandria 050322
    aForm.TfraGMV_GridGraph1.edPatientInfo.Text := anInfo;  // vaishandria 050322

//    aForm.Caption := 'Vitals Lite View ('+aForm.FileComments+')'; // vhaishandria 050415
    aForm.Caption := 'Vitals Lite: Vitals for '+aName + ' ' +anInfo;

    with aForm do
      begin
        TfraGMV_GridGraph1.RestoreUserPreferences;

        // GraphIndex as Parameter update
        // ('xx', 'T', 'P', 'R', 'BP', 'HT', 'WT', 'PN', 'PO2', 'CVP', 'CG');
        sVitalABB := piece(aHospitalName,'^',2);
        if sVitalABB <> '' then
          try
            if Uppercase(sVitalABB) = 'POX' then sVitalABB := 'PO2'; // vhaishandria 060228
            TfraGMV_GridGraph1.setGraphByABBR(sVitalABB);
          except
          end;
      end;

    sHospitalName := EditHospitalName;

    if sHospitalName = '' then
      begin
        try
          aForm.TfraGMV_GridGraph1.lblHospital.Caption := getFileField('44','.01',aLocation); //vhaishandria 050210
        except
          aForm.TfraGMV_GridGraph1.lblHospital.Caption := 'Unknown Location';
        end;
      end
    else
      aForm.TfraGMV_GridGraph1.lblHospital.Caption := sHospitalName;
  except
    on E: Exception do
      begin
        aForm := nil;
        MessageDLG('Cannot create a window'+#10#13+E.Message,mtError,[mbOK],0);
      end;
  end;

  aForm.TfraGMV_GridGraph1.UpdateFrame; // vhaishandria 051203
  aForm.TfraGMV_GridGraph1.scbHGraphChange(aForm.TfraGMV_GridGraph1.trbHGraph);
  Result := aForm;
end;

//==============================================================================
function ProcessInPatientVitals( aDFN, aLocation,
  DateStart, DateStop,aSignature,aName,anInfo,aHospitalName:String):Integer;
var
  Vitals: TfrmPatientVitals;  //kt //codex 8/26/26

  function getIOption(aName:String;aDefault:Integer):Integer;
  var
    ss: String;
    ii: Integer;
    begin
      try
        ss := getUserSettings(aName);
        ii := StrToIntDef(ss,aDefault);
        Result := ii;
      except
        Result := aDefault;
      end;
    end;

  procedure setIOption(aName:String;aValue: Integer);
  begin
    try
      setUserSettings(aName,IntToStr(aValue));
    except
    end;
  end;

begin
  Vitals := getFrmVitals(aDFN, aLocation, DateStart, DateStop,aSignature,aName,anInfo,aHospitalName);
  if Vitals <> nil then
    begin
      Vitals.Height := getIOption('VIEW-HEIGHT',600);
      Vitals.Width := getIOption('VIEW-WIDTH',600);
      Vitals.Left := getIOption('VIEW-LEFT',600);
      Vitals.Top := getIOption('VIEW-TOP',600);
      PositionForm(Vitals);

      Application.BringToFront;   // vhaishandria 051107
      Application.ProcessMessages;

      Vitals.TfraGMV_GridGraph1.UpdateFrame;
      Vitals.TfraGMV_GridGraph1.scbHGraphChange(nil);

      Result := Vitals.ShowModal;
      with Vitals do
        begin
          setIOption('VIEW-HEIGHT',Vitals.Height);
          setIOption('VIEW-WIDTH',Vitals.Width);
          setIOption('VIEW-LEFT',Vitals.Left);
          setIOption('VIEW-TOP',Vitals.Top);

          TfraGMV_GridGraph1.SaveStatus;
        end;
    end
  else
    Result := -1;
end;

////////////////////////////////////////////////////////////////////////////////

function getVitalsForm(
  aDFN, aLocation,
  DateStart, DateStop,aSignature,aName,anInfo,aHospitalName:String):TfrmPatientVitals;  //kt //codex 8/26/26
begin
  Result := getFrmVitals(aDFN, aLocation, DateStart, DateStop,aSignature,aName,anInfo,aHospitalName);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TfrmPatientVitals.TfraGMV_GridGraph1acEnterVitalsExecute(Sender: TObject);  //kt //codex 8/26/26
begin
  TfraGMV_GridGraph1.acEnterVitalsExecute(Sender);
end;

procedure TfrmPatientVitals.FormCreate(Sender: TObject);  //kt //codex 8/26/26
var
  s: String;
begin
  inherited;
  FMDateTimeRange := TMDateTimeRange.Create;
  fIgnoreCount := 0;

  with TVersionInfo.Create(self) do
  try
    fFileVersion := FileVersion;
    fFileComments := Comments;
  finally
    free;
  end;

  try
    s := getUserSettings('GRAPH OPTIONS VISIBLE');
    TfraGMV_GridGraph1.pnlGraphOptions.Visible := s='1';
    TfraGMV_GridGraph1.pnlGridTop.Visible := True;
  except
  end;
end;

procedure TfrmPatientVitals.FormDestroy(Sender: TObject);  //kt //codex 8/26/26
begin
  FMDateTimeRange.Free;
  inherited;
end;

procedure TfrmPatientVitals.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);  //kt //codex 8/26/26
begin
  if Key = VK_ESCAPE then
    try
      Close;
    except
    end;
  if Key = VK_F1 then
    begin
      Application.HelpCommand(HelpContext,0);
    end;
  if Key = VK_RETURN then
    begin
      if TfraGMV_GridGraph1.pnlPtInfo.BevelOuter = bvRaised then
          TfraGMV_GridGraph1.acPatientInfo.Execute; // vhaishandria 060309
    end;
end;

procedure TfrmPatientVitals.FormClose(Sender: TObject; var Action: TCloseAction);  //kt //codex 8/26/26
begin
  if TfraGMV_GridGraph1.pnlGraphOptions.Visible then
    setUserSettings('GRAPH OPTIONS VISIBLE','1')
  else
    setUserSettings('GRAPH OPTIONS VISIBLE','0');

{$IFDEF DLL}
  Action := caFree;
{$ENDIF}
end;

procedure TfrmPatientVitals.TfraGMV_GridGraph1acEnteredInErrorExecute(Sender: TObject);  //kt //codex 8/26/26
begin
  TfraGMV_GridGraph1.acEnteredInErrorExecute(Sender);
end;

procedure TfrmPatientVitals.TfraGMV_GridGraph1acPatientAllergiesExecute(
  Sender: TObject);  //kt //codex 8/26/26
begin
  TfraGMV_GridGraph1.acPatientAllergiesExecute(Sender);
end;

procedure TfrmPatientVitals.TfraGMV_GridGraph1sbGraphColorClick(Sender: TObject);  //kt //codex 8/26/26
begin
  TfraGMV_GridGraph1.sbGraphColorClick(sender);
end;

procedure TfrmPatientVitals.TfraGMV_GridGraph1SpeedButton1Click(Sender: TObject);  //kt //codex 8/26/26
begin
  TfraGMV_GridGraph1.sbGraphColorClick(Sender);

end;

procedure TfrmPatientVitals.TfraGMV_GridGraph1SelectGraphColor1Click(
  Sender: TObject);  //kt //codex 8/26/26
begin
  TfraGMV_GridGraph1.sbGraphColorClick(Sender);
end;

procedure TfrmPatientVitals.FormResize(Sender: TObject);  //kt //codex 8/26/26
var
  wd: Integer;
begin
  Inc(fIgnoreCount);
  if fIgnoreCount < 2 then
    with TfraGMV_GridGraph1 do
      begin
        wd := grdVitals.Width - grdVitals.ColWidths[0];
        wd := wd mod (grdVitals.DefaultColWidth+1);
        if wd > 1 then Self.Width := Self.Width - wd;
        pnlRight.Width := grdVitals.DefaultColWidth div 4;

        chrtVitalsResize(nil); //vhaishandria 060106
      end;
  dec(fIgnoreCount);
end;

procedure TfrmPatientVitals.Exit1Click(Sender: TObject);  //kt //codex 8/26/26
begin
  Close;
end;

procedure TfrmPatientVitals.About1Click(Sender: TObject);  //kt //codex 8/26/26
begin
  gmvaBOUTdlg.eXECUTE;
end;

procedure TfrmPatientVitals.Index1Click(Sender: TObject);  //kt //codex 8/26/26
begin
  Application.HelpCommand(0,0);
end;

procedure TfrmPatientVitals.SelectGraphColor1Click(Sender: TObject);  //kt //codex 8/26/26
begin
    TfraGMV_GridGraph1.sbGraphColorClick(nil);
end;

procedure TfrmPatientVitals.VitalsWe1Click(Sender: TObject);  //kt //codex 8/26/26
begin
  ShellExecute(0, nil, PChar('http://vista.med.va.gov/ClinicalSpecialties/vitals/'), nil, nil, SW_NORMAL)
end;

function TfrmPatientVitals.AppEvHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;  //kt //codex 8/26/26
var
  s: String;
//  iHelp: Integer;
begin
  Result := false; //kt providing a default. 8/30/26
  AppEv.CancelDispatch;
  s := GetProgramFilesPath+'\Vista\Common Files\GMV_VitalsViewEnter.hlp';

//  iHelp := ActiveControl.HelpContext;
//  if iHelp = 0 then iHelp := 1;

  try
//    Application.HelpSystem.ShowContextHelp(iHelp,s);
    Application.HelpSystem.ShowTopicHelp('Introduction',s);
  except
  end;

  CallHelp := False;
end;

procedure TfrmPatientVitals.VitalsReport1Click(Sender: TObject);  //kt //codex 8/26/26
begin
  TfraGMV_GridGraph1.acVitalsReportExecute(Sender);

end;

initialization
  PrevApp := Application;
  PrevScreen := Screen;

finalization
  Application := PrevApp;
  Screen := PrevScreen;
end.

