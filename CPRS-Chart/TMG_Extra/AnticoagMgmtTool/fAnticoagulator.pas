unit fAnticoagulator;

(* ----
NOTE: From K. Toppenberg.  1/28/18
When working with this code, my Delphi 2006 became unstable.  I wanted to
transition the code to Delphi 10.  But I could not seem to get the VA controls
installed.  At this time, I don't think the VA supports Delphi 10.

As a result, I am cutting out dependency on installed VA controls.  This includes
the 508 accessibility stuff and screen reader stuff.
My intent is to use this only in my office. But if there is a future desire to
use it elsewhere, this functionality would need to be ported back in.

I appologize to anyone needing this functionality.  I don't have resources to
support 508 stuff right now, outside the VA.

------*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, {RpRender, RpRenderCanvas,RPCConf1, RpRenderPrinter, RpDefine, RpCon,
  RpRave, RpBase, RpSystem,} Trpcb, ORNet,ORFn, {ORDtTm,} TeEngine,
  Series, ExtCtrls, TeeProcs, Chart, ComCtrls, Grids, Hash, DateUtils,StrUtils,
  ORCtrls, fCosign, ExtDlgs, fSplash, {VA508AccessibilityManager,} fTimeout, uInit,
  uTMGMods, rRPCsACM, uFlowsheet, uTypesACM, uPastINRs,   //kt
  uHTMLTools, TMGHTML2, Math, fActivityDetail, uTMGOptions, //kt
  Menus, Mask, Buttons, {VA508AccessibilityManager,} {VclTee.TeeGDIPlus,}
  ValEdit;

type
  TfrmAnticoagulate = class(TForm)
    pnlTop: TPanel;
    lblIndication: TLabel;
    lblINRGoal: TLabel;
    gbxContactInfo: TGroupBox;
    cbxINRGoal: TComboBox;
    pnlINR: TPanel;
    pcMain: TPageControl;
    tsOverview: TTabSheet;
    gbxPctInGoal: TGroupBox;
    btnSwitch: TButton;
    gbxShow: TGroupBox;
    gbxLastHctOrHgb: TGroupBox;
    chrtINR: TChart;
    serINR: TLineSeries;
    serUpperGoal: TLineSeries;
    serLowerGoal: TLineSeries;
    tsEnterInfo: TTabSheet;
    tsExit: TTabSheet;
    pnlNoDraw: TPanel;
    tsSTAT: TTabSheet;
    lblPercentInGoal: TLabel;
    lblDays: TLabel;
    lbl45DayLoad: TLabel;
    lblLTFDays: TLabel;
    lblLTFQuery: TLabel;
    lblUnlock: TLabel;
    btnUnlock: TButton;
    btnLost: TButton;
    edtLTF: TEdit;
    btnTWeek: TButton;
    btnPctInGoalReport: TButton;
    edtXDays: TEdit;
    pnlXPC: TPanel;
    lblXPct: TLabel;
    pnlCount: TPanel;
    lblCount: TLabel;
    pnlLTF: TPanel;
    lblLTF: TLabel;
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    mnuEdit: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuView: TMenuItem;
    mnuDemographics: TMenuItem;
    mnuPtPreferences: TMenuItem;
    mnuEnterInformation: TMenuItem;
    mnuExitTab: TMenuItem;
    mnuUtilities: TMenuItem;
    mnuHelp: TMenuItem;
    mnuAnticoagulationManagementHelp: TMenuItem;
    N1: TMenuItem;
    mnuAbout: TMenuItem;
    mnuUndo: TMenuItem;
    splEdit: TMenuItem;
    lblGoalDenominator: TStaticText;
    lblPCgoal: TStaticText;
    lblPctNoShowDenominator: TStaticText;
    lblPctNoShow: TStaticText;
    lblHctOrHgbValue: TStaticText;
    lblHctOrHgbDate: TStaticText;
    mnuEnterOutsideLab: TMenuItem;
    Complications1: TMenuItem;
    lblLastINR: TLabel;
    lblINRval: TLabel;
    lblINRdt: TLabel;
    lblComplex: TLabel;
    lblPname: TLabel;
    lblCSZ: TLabel;
    lblHfone: TLabel;
    lblSadr1: TLabel;
    lblSadr2: TLabel;
    lblSadr3: TLabel;
    lblWfone: TLabel;
    lblMSG: TLabel;
    lblSign: TLabel;
    lblTemp: TLabel;
    lblNoDraw: TLabel;
    sbxPMsg: TScrollBox;
    lblPMsg: TStaticText;
    mnuHelpBroker: TMenuItem;
    lblAutoPrimIndicCap: TLabel;
    lblAutoPrimIndic: TLabel;
    lblSiteName: TLabel;
    btnDemoNext: TBitBtn;
    cboIndication: TComboBox;
    cboSite: TComboBox;
    RPCBrokerV: TRPCBroker;
    pnlTabExit: TPanel;
    gbxReturnForINR: TGroupBox;
    lblPlus14: TLabel;
    lblPlus28: TLabel;
    dtpNextApp: TDateTimePicker;
    ckbPlusDay: TCheckBox;
    btnPlus14: TButton;
    btnPlus28: TButton;
    dtpAppTime: TDateTimePicker;
    gbxLabs: TGroupBox;
    ckbINROrder: TCheckBox;
    ckbCBCOrder: TCheckBox;
    gbxPCE: TGroupBox;
    lblPhoneVisit: TLabel;
    lblLettVisit: TLabel;
    lblICDPrim: TLabel;
    lblVisit: TLabel;
    ckbPCENone: TCheckBox;
    ckbCBOC: TCheckBox;
    edtICDCode: TEdit;
    rbPhoneS: TRadioButton;
    rbPhoneC: TRadioButton;
    rbOVisit: TRadioButton;
    rbPharm: TRadioButton;
    rbOclass: TRadioButton;
    rbSoffice: TRadioButton;
    ckbAddt: TCheckBox;
    rbLetter: TRadioButton;
    lblDrawRestr: TLabel;
    btnTempSave: TButton;
    btnCompleteVisit: TBitBtn;
    pnlTabDemographics: TPanel;
    pnlTabUtilities: TPanel;
    pnlTabEnter: TPanel;
    lblFSVDt: TLabel;
    lblPtNotice: TLabel;
    lblComments: TLabel;
    lblAM: TLabel;
    lblRecommendedChange: TLabel;
    Label1: TLabel;
    lblFSDate: TLabel;
    gbxDailyDosing: TGroupBox;
    lblSun: TLabel;
    lblThu: TLabel;
    lblWed: TLabel;
    lblMon: TLabel;
    lblSat: TLabel;
    lblFri: TLabel;
    lblTue: TLabel;
    lblTotals: TLabel;
    lblTablets2: TLabel;
    lblMilligrams: TLabel;
    lblStrength2: TLabel;
    lblPillStrength: TLabel;
    lblMg: TLabel;
    lblPillStrength2: TLabel;
    lblMg2: TLabel;
    lblPriorTotalName: TLabel;
    lblPctChangeName: TLabel;
    lblStrength1: TLabel;
    lblTablets1: TLabel;
    lblCM1Sun: TLabel;
    lblCM1Mon: TLabel;
    lblCM1Tue: TLabel;
    lblCM1Wed: TLabel;
    lblCM1Thur: TLabel;
    lblCM1Fri: TLabel;
    lblCM1Sat: TLabel;
    lblCM2Sun: TLabel;
    lblCM2Mon: TLabel;
    lblCM2Tue: TLabel;
    lblCM2Wed: TLabel;
    lblCM2Thur: TLabel;
    lblCM2Fri: TLabel;
    lblCM2Sat: TLabel;
    lblCMSun: TLabel;
    lblCMMon: TLabel;
    lblCMTue: TLabel;
    lblCMWed: TLabel;
    lblCMThur: TLabel;
    lblCMFri: TLabel;
    lblCMSat: TLabel;
    lblTotM: TLabel;
    lblTotT1: TLabel;
    lblTotT2: TLabel;
    lblPriorTotal: TLabel;
    lblChangePct: TLabel;
    edtCT2Sat: TEdit;
    edtCT2Fri: TEdit;
    edtCT2Sun: TEdit;
    edtCT2Mon: TEdit;
    edtCT2Tue: TEdit;
    edtCT2Wed: TEdit;
    edtCT2Thur: TEdit;
    cbUse2Pills: TCheckBox;
    edtCT1Sun: TEdit;
    edtCT1Mon: TEdit;
    edtCT1Tue: TEdit;
    edtCT1Wed: TEdit;
    edtCT1Thur: TEdit;
    edtCT1Fri: TEdit;
    edtCT1Sat: TEdit;
    cboPS: TComboBox;
    cboPS2: TComboBox;
    edtPtNote: TEdit;
    btnEditDailyDose: TBitBtn;
    memComments: TMemo;
    btnEditDoseNext: TBitBtn;
    btnCancelDose: TBitBtn;
    btnComplications: TBitBtn;
    btnNewINR: TBitBtn;
    btnRemind: TBitBtn;
    lblPtInfo: TLabel;
    btnViewFlowsheetGrid: TBitBtn;
    btnUnzoomGraph: TBitBtn;
    btnMissedAppt: TBitBtn;
    lblMissedAppt: TLabel;
    btnSwapSun: TBitBtn;
    btnSwapMon: TBitBtn;
    btnSwapTue: TBitBtn;
    btnSwapWed: TBitBtn;
    btnSwapThur: TBitBtn;
    btnSwapFri: TBitBtn;
    btnSwapSat: TBitBtn;
    pnlHighlightEditPref: TPanel;
    btnEditPatient: TBitBtn;
    gbxInstructions: TGroupBox;
    lblHoldDays: TLabel;
    lblExtraMgsToday: TLabel;
    ckbHold: TCheckBox;
    edtNumHoldDays: TEdit;
    ckbTake: TCheckBox;
    edtTakeNumMgToday: TEdit;
    memPatientInstructions: TMemo;
    lblMissedApptDate: TLabel;
    dtpMissedAppt: TDateTimePicker;
    gbxNoteGiven: TGroupBox;
    radNoCopyGiven: TRadioButton;
    radCopyGiven: TRadioButton;
    procedure radCopyGivenClick(Sender: TObject);
    procedure radNoCopyGivenClick(Sender: TObject);
    procedure cbxINRGoalClick(Sender: TObject);
    procedure btnDemoNextClick(Sender: TObject);
    procedure rbPhoneCClick(Sender: TObject);
    procedure rbSofficeClick(Sender: TObject);
    procedure rbLetterClick(Sender: TObject);
    procedure rbOclassClick(Sender: TObject);
    procedure rbOVisitClick(Sender: TObject);
    procedure rbPhoneSClick(Sender: TObject);
    procedure edtICDCodeChange(Sender: TObject);
    procedure ckbCBCOrderClick(Sender: TObject);
    procedure ckbINROrderClick(Sender: TObject);
    procedure cbUse2PillsClick(Sender: TObject);
    procedure cboPS2Change(Sender: TObject);
    procedure cboPSChange(Sender: TObject);          //kt added 12/17
    procedure btnCompletedVisitLetterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEditDailyDoseClick(Sender: TObject);
    procedure btnCompleteVisitClick(Sender: TObject);
    procedure cboIndicationChange(Sender: TObject);
    procedure btnEditDoseNextClick(Sender: TObject);
    procedure HandleDosingGridEditChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTempSaveClick(Sender: TObject);
    procedure btnCancelDoseClick(Sender: TObject);
    procedure rbNoMCClick(Sender: TObject);
    procedure SetEClinic(AnAppState : TAppState);
    procedure cboPSExit(Sender: TObject);
    procedure edtPtNoteKeyPress(Sender: TObject; var Key: Char);
    procedure btnXPCEnter(Sender: TObject);
    procedure btnXPCExit(Sender: TObject);
    procedure lblPercentInGoalMouseEnter(Sender: TObject);
    procedure lblPercentInGoalMouseLeave(Sender: TObject);
    procedure btnPctInGoalReportClick(Sender: TObject);
    procedure btnTWeekClick(Sender: TObject);
    procedure btnLostClick(Sender: TObject);
    procedure ckbHoldClick(Sender: TObject);
    procedure ckbTakeClick(Sender: TObject);
    procedure lblLTFQueryMouseEnter(Sender: TObject);
    procedure lblLTFQueryMouseLeave(Sender: TObject);
    procedure btnRemindClick(Sender: TObject);
    procedure btnUnlockClick(Sender: TObject);
    procedure btnSwitchClick(Sender: TObject);
    procedure btnMissedApptClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure btnPlusXClick(Sender: TObject);
    procedure cboSiteSelect(Sender: TObject);
    procedure btnFileCClick(Sender: TObject);
    procedure tsExitShow(Sender: TObject);
    procedure mnuDemographicsClick(Sender: TObject);
    procedure mnuPtPreferencesClick(Sender: TObject);
    procedure mnuEnterInformationClick(Sender: TObject);
    procedure mnuExitTabClick(Sender: TObject);
    procedure mnuUtilitiesClick(Sender: TObject);
    procedure mnuCutClick(Sender: TObject);
    procedure mnuEditClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuUndoClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure chrtINREnter(Sender: TObject);
    procedure pnlRemindEnter(Sender: TObject);
    procedure cboIndicationExit(Sender: TObject);
    procedure cbxINRGoalExit(Sender: TObject);
    procedure mnuAnticoagulationManagementHelpClick(Sender: TObject);
    procedure cboSiteExit(Sender: TObject);
    procedure dtpNextApptChange(Sender: TObject);
    procedure dtpNextAppExit(Sender: TObject);
    procedure mnuHelpBrokerClick(Sender: TObject);
    function TimeoutCondition: boolean;
    function GetTimedOut: boolean;
    procedure TimeOutAction;
    procedure dtpAppTimeChange(Sender: TObject);
    procedure edtDosingGridKeyPress(Sender: TObject; var Key: Char);
    procedure DosingGridEditExit(Sender: TObject);
    procedure btnPctInGoalReportMouseEnter(Sender: TObject);
    procedure btnPctInGoalReportMouseLeave(Sender: TObject);
    procedure btnTWeekMouseEnter(Sender: TObject);
    procedure btnTWeekMouseLeave(Sender: TObject);
    procedure btnLostMouseEnter(Sender: TObject);
    procedure btnLostMouseLeave(Sender: TObject);
    procedure btnComplicationsClick(Sender: TObject);
    procedure btnNewINRClick(Sender: TObject);
    procedure memCommentsExit(Sender: TObject);
    procedure ckbPCENoneClick(Sender: TObject);
    procedure ckbPlusDayClick(Sender: TObject);
    procedure btnEditPatientClick(Sender: TObject);
    procedure cboPS2Exit(Sender: TObject);
    procedure edtPtNoteChange(Sender: TObject);
    procedure chrtINRMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure chrtINRZoom(Sender: TObject);
    procedure btnUnzoomGraphClick(Sender: TObject);
    procedure Complications1Click(Sender: TObject);
    procedure mnuEnterOutsideLabClick(Sender: TObject);
    procedure btnViewFlowsheetGridClick(Sender: TObject);
    procedure btnDocumentationNextClick(Sender: TObject);
    procedure btnSwapClick(Sender: TObject);
    procedure edtNumHoldDaysChange(Sender: TObject);
    procedure edtTakeNumMgTodayChange(Sender: TObject);
    procedure memPatientInstructionsEnter(Sender: TObject);
    procedure memPatientInstructionsChange(Sender: TObject);
    procedure memPatientInstructionsClick(Sender: TObject);
    procedure dtpMissedApptChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FEditCtrl:                        TCustomEdit;
    FCreationStep:                    Integer;
    FTabCutWarn:                      Boolean;
    FDosageWarn:                      Boolean;
    FEditingDoses :                   boolean;
    PreviousDisplayedApptTime:        TDateTime;
    InitialReturnApptDateTime:        TDateTime;
    procedure SetDosingGridEnable(Enabled: boolean);
    procedure SetDosingGridColors;
    function  CheckDrawDay: Boolean;
    //procedure SetDebugMenu;
    function  InitForPatient(ADFN : string) : boolean;
    function  ApplyParameters(Parameters : TParameters) : boolean;
    procedure SetIfUsingTwoPills(Value : boolean);
    procedure RefreshDosingGrid;
    procedure SetHctOrHgbInfo(HctOrHgb,DateStr : string);
    function  PatientDataToGUI() : boolean;
    procedure DosingDataToScreen(Data : TOneFlowsheet);
    procedure SetWeeklyDoseComparisonControlVisibility(VisibleVal : boolean);
    procedure SetPillStrengthLabels(Row : integer);
    function  FindEdit(AEdit : TEdit; var OutRow, OutCol : Integer) : boolean;
    function  GetINRRecommendedChange(INRValue : string; INRDateTime: TDateTime) : string;
    procedure RefreshDisplayedINR;
    procedure SetNextApptDateTime;
    procedure AbortExecution;
    procedure CheckInputForNumeric(Sender: TObject; var Key: Char);
    function  OKToExit : boolean;
    function  DoExitingPrep() : boolean;
    procedure ActivityReport(NumNays : string; Mode : tActivityMode);
    procedure RefreshModifiableData;
    procedure RefreshGraphTitle;
    procedure RefreshFlowsheetDateDisplay;
    procedure RefreshLastHgbOrHct;
    procedure RefreshPercentInGoal;
    procedure RefreshNoShowStatus;
    procedure RefreshGraph;
    procedure RefreshDemographics;
    procedure cboSitePullData;
    procedure PullExtraInstructionsData;
    function  DocumentationOK : boolean;
  protected
    AppState         : TAppState;
    Patient          : TPatient;       //This is an alias for convenience.  Real object owned by AppState.
    Provider         : TProvider;      //This is an alias for convenience.  Real object owned by AppState
    Parameters       : TParameters;    //This is an alias for convenience.  Real object owned by AppState
    CurrentFlowsheet : TOneFlowsheet;  //This is an alias for convenience.  Real object owned by AppState
  public
    sgDosingData : TStringGrid;  //doesn't own items.
    DosingLabelsList : TList;    //doesn't own items.
    SwapButtonsList : TList;     //doesn't own items
    function Initialize(ADFN : string = '') : boolean;
  end;

var
  //frmAnticoagulate: TfrmAnticoagulate;
  AbortingExecution : boolean;


const
  MAXDOSE: Extended = 30.0; //max daily dosage

  //form create process markers
  FCP_SETHOOK = 10;         // form create about to set timeout hooks
  FCP_SERVER  = 30;         // form create about to connect to server
  FCP_CHKPT   = 40;         // form create about to check version
  FCP_PARAMS  = 50;         // form create about to create core objects
  FCP_FORMS   = 60;         // form create about to create child forms
  FCP_PTLOAD  = 70;         // form create about to select patient
  FCP_FINISH  = 99;         // form create finished successfully

implementation

uses
  fCompletedVisitNote, fCompleteConsult, fSignItem, fEditFlowsheet, uUtility,//kt
  fCustomINRGoal, fNewPatientInstructions, fNewIndication,   //kt
  fUnlockPatient, fEditComplications, fOutsideLab, fPatientInformation, //kt
  Clipbrd, fAboutACM, {VA508AccessibilityRouter,} VAUtils, fPCE_ACM, fxBroker,
  fBridgeCommentsDialog,
  fStartAnticoagMgmt, fReminder, fMissedAppt, fEndAnticoagMgmt, fViewFlowsheetGrid,
  fSplashACM,
  fAMTEditMemo;

{$R *.DFM}


function TfrmAnticoagulate.TimeoutCondition: boolean;
begin
  Result := (FCreationStep < FCP_PTLOAD);
end;

function TfrmAnticoagulate.GetTimedOut: boolean;
begin
  Result := uInit.TimedOut;
end;

procedure TfrmAnticoagulate.TimeOutAction;
var ClosingACM: boolean;

  procedure CloseACM;
  begin
    if ClosingACM then halt;
    try
      ClosingACM := TRUE;
      Close;
    except
      halt;
    end;
  end;

begin
  ClosingACM := FALSE;
  try
    CloseACM;
  except
    CloseACM;
  end;
end;



function TfrmAnticoagulate.ApplyParameters(Parameters : TParameters) : boolean;
// result: True = success, false = error.
var SavePCEData : boolean;
begin
  with Parameters do begin
    if SiteName <> '' then begin
      cboSelectByID(cboSite, SiteName);  //doesn't seem to trigger event.  If did, would have endless loop.
      cboSitePullData;
    end;
    SavePCEData := (Str0Pce13 = '1');
    AppState.FilePCEData := SavePCEData;
    gbxPCE.Visible := SavePCEData;
    ckbPCENone.Checked := not SavePCEData;  //will trigger event (?)
    if not SavePCEData then NonCountClinic := Parameters.VisitClinic;

    gbxLabs.Visible := (INRQuickOrder <> '') or (CBCQuickOrder <> '');
    ckbINROrder.Enabled := (INRQuickOrder <> '');
    ckbINROrder.Checked := false;
    ckbCBCOrder.Enabled := (CBCQuickOrder <> '');
    ckbCBCOrder.Checked := false;

    dtpAppTime.Visible := InclINRTime;
    dtpAppTime.Enabled := InclINRTime;
    gbxReturnForINR.Width := IfThen(InclINRTime, dtpAppTime.Left+dtpAppTime.Width+10, 220);
    lblDrawRestr.Left := gbxReturnForINR.Left + gbxReturnForINR.Width + 10;

    if Parameters.AutoPrimaryIndicationCode <> '' then begin
      //kt NOTE: I am not planning on using this for right now.  If I do later, I would
      //        instead have it autopopulate that combobox rather than showing a label...
      lblAutoPrimIndicCap.Visible := true;    //this is "Primary Indication" caption in top
      lblAutoPrimIndic.Caption := Parameters.AutoPrimaryIndicationText;  //this is indication value beside "Primary Indication" caption
      lblAutoPrimIndic.Visible := true;
      lblIndication.Caption := 'Add''l Indication:';  //this is title caption for combobox indication selector
      lblICDPrim.Caption := lblIndication.Caption;    //this is in gbxPCE on Exit tab
    end else begin
      lblAutoPrimIndicCap.Visible := false;   //this is "Primary Indication" caption in top
      lblAutoPrimIndic.Visible := false;      //this is indication value beside "Primary Indication" caption
      lblIndication.Caption := 'Primary Indication:';   //this is title caption for combobox indication selector
      lblICDPrim.Caption := 'Primary ICD-Code:'; //this is in gbxPCE on Exit tab
    end;
    if Patient.NewPatient then begin
      lblIndication.Caption := '* ' + lblIndication.Caption;
    end;
    //SetIndicatorsRPC(Parameters, cbxIndic.Items);
    Result := FillIndicationsFromRPC(Parameters, cboIndication); if Result = false then exit;
  end; //else
end;

{
procedure TfrmAnticoagulate.SetDebugMenu;
var  IsProgrammer: Boolean;
begin
  IsProgrammer := HasSecurityKey('XUPROGMODE');
  mnuHelpBroker.Visible  := IsProgrammer;
  mnuHelpBroker.Enabled  := IsProgrammer;
end;
}

procedure TfrmAnticoagulate.RefreshDosingGrid;
begin
  CurrentFlowsheet.PullDosingInfoFromScreen(sgDosingData, cboPS, cboPS2);
  CurrentFlowsheet.OutputCalculatedFields(sgDosingData);
  SetWeeklyDoseComparisonControlVisibility(true);
  lblPriorTotal.Caption := CurrentFlowsheet.PriorTWD;
  lblChangePct.Caption := CurrentFlowsheet.PctChange;
end;

procedure TfrmAnticoagulate.ckbPCENoneClick(Sender: TObject);
begin
  if AppState.PushingDataToScreen then Exit;
  AppState.FilePCEData := not ckbPCENone.Checked;
end;

procedure TfrmAnticoagulate.ckbPlusDayClick(Sender: TObject);
begin
  AppState.NextDayCallback := ckbPlusDay.Checked;
end;

procedure TfrmAnticoagulate.rbPhoneSClick(Sender: TObject);
begin
  if rbPhoneS.Checked then begin
    AppState.PCEProcedureStr := Parameters.SimplePhoneCPT;
    AppState.SvcCat := 'T';
  end;
  if not AppState.FilePCEData then AppState.PCEProcedureStr := '0';
end;

procedure TfrmAnticoagulate.rbPhoneCClick(Sender: TObject);
begin
  if rbPhoneC.Checked then begin
    AppState.PCEProcedureStr := Parameters.ComplexPhoneCPT;
    AppState.SvcCat := 'T';
  end;
  if not AppState.FilePCEData then AppState.PCEProcedureStr := '0';
end;

procedure TfrmAnticoagulate.rbOclassClick(Sender: TObject);
begin
  if rbOClass.Checked then begin
    AppState.PCEProcedureStr := Parameters.OrientationClassCPT;
  end;
  if not AppState.FilePCEData then AppState.PCEProcedureStr := '0';
end;

procedure TfrmAnticoagulate.rbOVisitClick(Sender: TObject);
begin
  if rbOVisit.Checked then begin
    AppState.PCEProcedureStr := Parameters.InitialVisitCPT;
  end;
  if not AppState.FilePCEData then AppState.PCEProcedureStr := '0';
end;

procedure TfrmAnticoagulate.radCopyGivenClick(Sender: TObject);
begin
  CurrentFlowsheet.NoteGivenString := radCopyGiven.Caption;
end;

procedure TfrmAnticoagulate.radNoCopyGivenClick(Sender: TObject);
begin
  CurrentFlowsheet.NoteGivenString := radNoCopyGiven.Caption;
end;

procedure TfrmAnticoagulate.rbLetterClick(Sender: TObject);
begin
  if rbLetter.Checked then begin
    AppState.PCEProcedureStr := Parameters.PatientLetterCPT;
  end;
  if not AppState.FilePCEData then AppState.PCEProcedureStr := '0';
end;

procedure TfrmAnticoagulate.rbSofficeClick(Sender: TObject);
begin
  if rbSoffice.Checked = true then begin
    AppState.PCEProcedureStr := Parameters.SubsequentVisitCPT;
  end;
  if not AppState.FilePCEData then AppState.PCEProcedureStr := '0';
end;


function TfrmAnticoagulate.Initialize(ADFN : string = '') : boolean;
//Results: TRUE if OK, or FALSE if problem with connection.
var
  i : integer;
  DFN :  string;

begin
  Result := false;
  DFN := ADFN;
  {
  if DFN = '' then begin
    for i := 1 to ParamCount do begin
      if UpperCase(Piece(ParamStr(i), '=', 1)) = 'D' then begin
        DFN := Piece(ParamStr(i), '=', 2);
        break;
      end;
    end;
  end;
  if DFN = '' then begin
    InfoBox('Application not called with patient DFN specified in parameters.' + CRLF +
            'Should be launched from CPRS, where this will occur automatically.' +  CRLF +
            'Will now abort.', 'Error', MB_OK or MB_ICONSTOP);
    AbortExecution;
    exit;
  end;
  }

  {//kt --- removing when adding into CPRS
  // connect to the server and create an option context
  FCreationStep := FCP_SERVER;
  if not ConnectToServer('ORAM ANTICOAGULATION CONTEXT') then begin
    if Assigned(RPCBrokerV) and (RPCBrokerV.RPCBError <> '') then begin
      InfoBox(RPCBrokerV.RPCBError, 'Error', MB_OK or MB_ICONSTOP);
    end;
    AbortExecution;
    exit;
  end;
  }

  ACMSplashOpen;
  if InitForPatient(DFN) then begin
    PopupReminderBoxIfAppropriate(Patient);
    Result := true;  //If we got this far, all is OK
  end;
  ACMSplashClose;
end;


procedure TfrmAnticoagulate.FormCreate(Sender: TObject);
var
  i : integer;

begin
  cboSite.Tag := integer(pointer(TStringList.Create));        //kt This will have a 1:1 relationship between RPC source and .Items display
  cboIndication.Tag := integer(pointer(TStringList.Create));  //kt This will have a 1:1 relationship between RPC source and .Items display

  AppState := TAppState.Create();
  //AppState.AccessibilityManager := AccessibilityManager;
  AppState.PCEData := uPCEData;
  Patient          := AppState.Patient;             //alias pointer for programming convenience
  Provider         := AppState.Provider;            //alias pointer for programming convenience
  Parameters       := AppState.Parameters;          //alias pointer for programming convenience
  CurrentFlowsheet := AppState.CurrentNewFlowsheet; //alias pointer for programming convenience

  sbxPMsg.DoubleBuffered := True;
  PreviousDisplayedApptTime := -1;

  FCreationStep := FCP_SETHOOK;

  SetRetainedRPCMax(50);

  InitTimeOut(TimeoutCondition, TimeOutAction);

  sgDosingData := TStringGrid.Create(Application);   //doesn't own held objects
  sgDosingData.visible := false;
  sgDosingData.RowCount := 5;
  sgDosingData.ColCount := 8;
  sgDosingData.Objects[COL_SUN   ,ROW_STRENGTH_1] := lblCM1Sun;
  sgDosingData.Objects[COL_MON   ,ROW_STRENGTH_1] := lblCM1Mon;
  sgDosingData.Objects[COL_TUE   ,ROW_STRENGTH_1] := lblCM1Tue;
  sgDosingData.Objects[COL_WED   ,ROW_STRENGTH_1] := lblCM1Wed;
  sgDosingData.Objects[COL_THUR  ,ROW_STRENGTH_1] := lblCM1Thur;
  sgDosingData.Objects[COL_FRI   ,ROW_STRENGTH_1] := lblCM1Fri;
  sgDosingData.Objects[COL_SAT   ,ROW_STRENGTH_1] := lblCM1Sat;
  sgDosingData.Objects[COL_TOTAL ,ROW_STRENGTH_1] := nil;

  sgDosingData.Objects[COL_SUN   ,ROW_NUM_TABS_1] := edtCT1Sun;
  sgDosingData.Objects[COL_MON   ,ROW_NUM_TABS_1] := edtCT1Mon;
  sgDosingData.Objects[COL_TUE   ,ROW_NUM_TABS_1] := edtCT1Tue;
  sgDosingData.Objects[COL_WED   ,ROW_NUM_TABS_1] := edtCT1Wed;
  sgDosingData.Objects[COL_THUR  ,ROW_NUM_TABS_1] := edtCT1Thur;
  sgDosingData.Objects[COL_FRI   ,ROW_NUM_TABS_1] := edtCT1Fri;
  sgDosingData.Objects[COL_SAT   ,ROW_NUM_TABS_1] := edtCT1Sat;
  sgDosingData.Objects[COL_TOTAL ,ROW_NUM_TABS_1] := lblTotT1;

  sgDosingData.Objects[COL_SUN   ,ROW_STRENGTH_2] := lblCM2Sun;
  sgDosingData.Objects[COL_MON   ,ROW_STRENGTH_2] := lblCM2Mon;
  sgDosingData.Objects[COL_TUE   ,ROW_STRENGTH_2] := lblCM2Tue;
  sgDosingData.Objects[COL_WED   ,ROW_STRENGTH_2] := lblCM2Wed;
  sgDosingData.Objects[COL_THUR  ,ROW_STRENGTH_2] := lblCM2Thur;
  sgDosingData.Objects[COL_FRI   ,ROW_STRENGTH_2] := lblCM2Fri;
  sgDosingData.Objects[COL_SAT   ,ROW_STRENGTH_2] := lblCM2Sat;
  sgDosingData.Objects[COL_TOTAL ,ROW_STRENGTH_2] := nil;

  sgDosingData.Objects[COL_SUN   ,ROW_NUM_TABS_2] := edtCT2Sun;
  sgDosingData.Objects[COL_MON   ,ROW_NUM_TABS_2] := edtCT2Mon;
  sgDosingData.Objects[COL_TUE   ,ROW_NUM_TABS_2] := edtCT2Tue;
  sgDosingData.Objects[COL_WED   ,ROW_NUM_TABS_2] := edtCT2Wed;
  sgDosingData.Objects[COL_THUR  ,ROW_NUM_TABS_2] := edtCT2Thur;
  sgDosingData.Objects[COL_FRI   ,ROW_NUM_TABS_2] := edtCT2Fri;
  sgDosingData.Objects[COL_SAT   ,ROW_NUM_TABS_2] := edtCT2Sat;
  sgDosingData.Objects[COL_TOTAL ,ROW_NUM_TABS_2] := lblTotT2;

  sgDosingData.Objects[COL_SUN   ,ROW_TOTAL_MGS]  := lblCMSun;
  sgDosingData.Objects[COL_MON   ,ROW_TOTAL_MGS]  := lblCMMon;
  sgDosingData.Objects[COL_TUE   ,ROW_TOTAL_MGS]  := lblCMTue;
  sgDosingData.Objects[COL_WED   ,ROW_TOTAL_MGS]  := lblCMWed;
  sgDosingData.Objects[COL_THUR  ,ROW_TOTAL_MGS]  := lblCMThur;
  sgDosingData.Objects[COL_FRI   ,ROW_TOTAL_MGS]  := lblCMFri;
  sgDosingData.Objects[COL_SAT   ,ROW_TOTAL_MGS]  := lblCMSat;
  sgDosingData.Objects[COL_TOTAL ,ROW_TOTAL_MGS]  := lblTotM;

  for i := 0 to 7 do begin  //change to nicer color that can't be selected at design time
    TLabel(sgDosingData.Objects[i,ROW_TOTAL_MGS]).Color := clTotalRow;
  end;
  lblPriorTotal.Color := clTotalRow;
  lblChangePct.Color := clTotalRow;

  DosingLabelsList := TList.Create(); //doesn't own objects
  DosingLabelsList.Add(lblPillStrength);
  DosingLabelsList.Add(lblMg);
  DosingLabelsList.Add(lblPillStrength2);
  DosingLabelsList.Add(lblMg2);
  DosingLabelsList.Add(lblSun);
  DosingLabelsList.Add(lblMon);
  DosingLabelsList.Add(lblTue);
  DosingLabelsList.Add(lblWed);
  DosingLabelsList.Add(lblThu);
  DosingLabelsList.Add(lblFri);
  DosingLabelsList.Add(lblSat);
  DosingLabelsList.Add(lblTotals);
  DosingLabelsList.Add(lblStrength1);
  DosingLabelsList.Add(lblTablets1);
  DosingLabelsList.Add(lblStrength2);
  DosingLabelsList.Add(lblTablets2);
  DosingLabelsList.Add(lblMilligrams);
  DosingLabelsList.Add(lblPriorTotalName);
  DosingLabelsList.Add(lblPctChangeName);

  SwapButtonsList := TList.Create();
  SwapButtonsList.Add(btnSwapSun);  //index = 0 = COL_SUN
  SwapButtonsList.Add(btnSwapMon);  //etc
  SwapButtonsList.Add(btnSwapTue);
  SwapButtonsList.Add(btnSwapWed);
  SwapButtonsList.Add(btnSwapThur);
  SwapButtonsList.Add(btnSwapFri);
  SwapButtonsList.Add(btnSwapSat);

  radNoCopyGiven.Caption := uTMGOptions.ReadString('ORAM NOTE COPY NOT GIVEN','No copy of note given.');  //8/27/18
  radCopyGiven.Caption := uTMGOptions.ReadString('ORAM NOTE COPY GIVEN','Copy of note given to patient.');  //8/27/18
end;

procedure TfrmAnticoagulate.FormDestroy(Sender: TObject);
begin
  sgDosingData.Free;
  DosingLabelsList.Free;
  SwapButtonsList.Free;
  AppState.Free;
  TStringList(cboSite.Tag).Free;
  TStringList(cboIndication.Tag).Free;
end;

procedure TfrmAnticoagulate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Patient.Unlock;
  {
  if AppState.NoteIEN <> '' then begin
    if InfoBox('You have a progress note, do you want to file it?',
               'File Progress Note?', MB_YESNO or MB_ICONQUESTION) = mrYes then begin
      SignNote();
    end else begin
      DeleteTIUNote(AppState.NoteIEN);
    end;
  end; //notenumber
  }
end;

procedure TfrmAnticoagulate.SetHctOrHgbInfo(HctOrHgb, DateStr : string);
begin
  lblHctOrHgbValue.Caption := HctOrHgb;
  lblHctOrHgbDate.Caption := DateStr;
end;

function TfrmAnticoagulate.InitForPatient(ADFN : string) : boolean;
//Result : true if OK, or False if problem with initialization
var
  TempOnePastINR : TOnePastINRValue;  //not owned here
  MostRecentFlowsheet: TOneFlowsheet; //not owned here

begin
  Result := false; //default to failure
  try
    FTabCutWarn := False;
    FDosageWarn := False;
    if not GetPatientInfo(ADFN, Patient) then exit;  //initialize pt info
    UpdateTimeOutInterval(Patient.TimeoutSeconds * 1000);  // TimeoutSeconds * 1000 mSec/sec
    FCreationStep := FCP_CHKPT;  //Check Pt
    //SetDebugMenu;
    GetProviderInfo(Provider);
    if not GetClinicsList(cboSite, Patient) then exit;
    FCreationStep := FCP_PARAMS;
    if not GetParametersByRPC(Provider.DUZ, Patient.ClinicLoc, Parameters) then exit;
    FCreationStep := FCP_FORMS;
    GetPastINRValues(Patient.DFN, AppState);
    Patient.FlowsheetData.LoadFromServer(Patient.DFN);
    Patient.FlowsheetData.ExtractINRData(AppState);

    MostRecentFlowsheet := Patient.FlowsheetData.MostRecent;   //might return nil
    if Patient.SaveMode = tsmTempSave then begin
      //Edit last flowsheet which was saved in temp mode.
      CurrentFlowsheet.Assign(MostRecentFlowsheet);  //OK if MostRecentFlowsheet is nil
    end else begin
      TempOnePastINR := AppState.PastINRValues.MostRecent;  //might return nil
      //Make a new flowsheet, with just a little bit of prior data carried forward
      CurrentFlowsheet.LimitedAssign(MostRecentFlowsheet);  //OK if MostRecentFlowsheet is nil
      CurrentFlowsheet.DateTime := Now;
      //CurrentFlowsheet.PriorTWD := IfThen(Assigned(MostRecentFlowsheet), MostRecentFlowsheet.TotalWeeklyDose, '0');
      if Assigned(MostRecentFlowsheet) then begin
        CurrentFlowsheet.PriorTWD := MostRecentFlowsheet.TotalWeeklyDose
      end else begin
        CurrentFlowsheet.PriorTWD :='0';
      end;
      CurrentFlowsheet.CurrentINRGoal :=  Patient.GoalINR;
      CurrentFlowsheet.LoadINRInfo(TempOnePastINR);      //OK if nil
      if Patient.NewPatient then begin
        CurrentFlowsheet.fPillStrength1 := Parameters.DefaultPillStrength;
        CurrentFlowsheet.fPillStrength2 := 0;
      end;
    end;
    CurrentFlowsheet.Provider := AppState.Provider.Name;
    //---------------------
    if not PatientDataToGUI() then exit;  //Put all the information into the form.
    FCreationStep := FCP_FINISH;   //FormCreate Process Complete
    //---------------------
    result := true; //success if we got this far.
  finally
    if result = false then AbortExecution;
  end;
end;


function TfrmAnticoagulate.PatientDataToGUI() : boolean;
//result: True = success, false = problem.
var
  frmNewPatientInstructions: TfrmNewPatientInstructions;
  PushingState : boolean;

begin
  PushingState := AppState.PushingDataToScreen;
  AppState.PushingDataToScreen := true;
  try
    if cboSite.items.Count = 1 then cboSite.ItemIndex := 0;
    Result := ApplyParameters(Parameters); if Result = false then exit;
    SetDosingGridEnable(False);
    RefreshGraph;
    RefreshDemographics;
    FCreationStep := FCP_PTLOAD;
    cboIndication.Text := Patient.Indication_Text;
    edtICDCode.Text := Patient.Indication_ICDCode;

    cbxINRGoal.Text := CurrentFlowsheet.CurrentINRGoal;
    {
    Case Patient.FEE_BASIS of
      tfbNo :          rbFeeNo.Checked := true;
      tfbPrimary :     rbFeePrim.Checked := true;
      tfbSecondary :   rbFeeSec.Checked := true;
    end;
    }
    btnRemind.Caption := CaptionForReminderButton(Patient);

    //Daily draw restrictions.
    lblNoDraw.Caption := '';
    pnlNoDraw.Visible := (Patient.DrawRestrictionsStr <> '');

    DosingDataToScreen(CurrentFlowsheet);
    if not Patient.NewPatient then begin
      RefreshGraphTitle;
      memComments.Lines.Assign(CurrentFlowsheet.Comments);
      edtPtNote.Text := CurrentFlowsheet.PatientNotice;
      if Patient.SaveMode = tsmTempSave then begin
        pcMain.ActivePage := tsEnterInfo;
        AppState.AppointmentShowStatus := CurrentFlowsheet.AppointmentShowStatus;
        //lblFSentry.Caption := 'Flow Sheet Entry in Progress:';
        lblTemp.Visible := true;
      end;
    end else begin  //is new patient
      pcMain.ActivePage := tsOverview;
      cboIndication.Color := clNeedsData;
      pnlHighlightEditPref.Color := clNeedsData;
      if pos('*', lblIndication.Caption) = 0 then begin
        lblIndication.Caption := '* ' + lblIndication.Caption;
      end;
      cbxINRGoal.Color := clNeedsData;
      lblINRGoal.Caption := '* ' + lblINRGoal.Caption;
      lblINRGoal.Left := lblINRGoal.Left - 7;
      if cboSite.Items.Count > 1 then begin
        cboSite.Color := clNeedsData;
      end;
      lblSiteName.Caption := '* ' + lblSiteName.Caption;
      lblSiteName.Left := lblSiteName.Left - 7;
      cboPS.Color := clNeedsData;
      lblPillStrength.Caption := '* ' + lblPillStrength.Caption;
      frmNewPatientInstructions := TfrmNewPatientInstructions.Create(self);
      //frmNewPatientInstructions.Show; //should free itself when user closed form.
      frmNewPatientInstructions.Showmodal; //should free itself when user closed form.
      {
      try
        frmNewPatientInstructions.ShowModal;
      finally
        frmNewPatientInstructions.Free;
      end;
      }
      dtpNextApp.Color := clNeedsData;
      gbxReturnForINR.Caption := '* ' + gbxReturnForINR.Caption;
      //dtpNextApp.DateTime := StrToDate(Patient.PaddedNowDateStr); //should trigger dtpNextAppChange();

      cboSelectByID(cboPS, CurrentFlowsheet.PillStrength1);
      if cboPS.Text = '' then cboPS.Text := CurrentFlowsheet.PillStrength1;
      RefreshDosingGrid;
      gbxDailyDosing.Caption := 'Suggested Daily Dosing';
      //Patient.SpecialInstructionsSL.Insert(0,TrimRight(lblHfone.Caption) + ';  ' + TrimRight(lblWfone.Caption));
    end;

    if not (Patient.NextScheduledINRCheckDate >0) then Patient.NextScheduledINRCheckDate := Now; //should trigger dtpNextAppChange()  ??;
    dtpNextApp.DateTime := Patient.NextScheduledINRCheckDate;  //should trigger dtpNextAppChange();
    InitialReturnApptDateTime := Patient.NextScheduledINRCheckDate;
    if Parameters.InclINRTime and (TimeOf(Patient.NextScheduledINRCheckDate) <> 0) then begin
      dtpAppTime.Time := TimeOf(Patient.NextScheduledINRCheckDate);
    end;

    SetDosingGridEnable(false);
    RefreshModifiableData;
    pcMain.ActivePage := tsOverview;
    //btnDemoNext.SetFocus;

    //I am not going to carry over extra instructions from last time.
    ckbHold.Checked := false;
    ckbTake.Checked := false;
    edtTakeNumMgToday.Text := '';
    edtNumHoldDays.Text := '';
    memPatientInstructions.Lines.Clear;
    ckbHold.Checked := false;
    ckbTake.Checked := false;
  finally
    AppState.PushingDataToScreen := PushingState;
  end;
end;

procedure TfrmAnticoagulate.RefreshFlowsheetDateDisplay;
var IsToday : boolean;
begin
  lblFSDate.Caption := CurrentFlowsheet.DateStr;
  IsToday := IsCurrentDate(CurrentFlowsheet.DateTime);
  lblFSVDt.Visible := not IsToday;
  lblFSDate.Visible := not IsToday;
end;

procedure TfrmAnticoagulate.RefreshDemographics;
var SL : TStringList;
    tempS : string;
    i : integer;
begin
  //Pt Address / demographics
  SL := TStringList.Create;
  try
    SL.Add(Patient.ADDR_STREET_LINE1);
    SL.Add(Patient.ADDR_STREET_LINE2);
    SL.Add(Patient.Addr_Street_Line2);
    tempS := Patient.ADDR_CITY; if tempS <> '' then tempS := tempS + ', ';
    tempS := tempS + Patient.ADDR_STATE + ' ' + Patient.ADDR_ZIP;
    SL.Add(tempS);
    for i := SL.Count - 1 downto 0 do if Trim(SL[i]) = '' then SL.Delete(i);  //Pack display lines
    while SL.Count < 4 do SL.Add('');  //ensure 4 lines in SL
    lblSadr1.Caption := SL[0];
    lblSadr2.Caption := SL[1];
    lblSadr3.Caption := SL[2];
    lblCSZ.Caption   := SL[3];
    if Patient.ADDR_BAD_CODE = '1' then begin
      InfoBox('Patient has a ''Bad Address Indicator'' flag.' + CRLF +
              'Please confirm his/her contact information and' + CRLF +
              'correct it if necessary.', 'Bad Address Indicator',
              MB_OK or MB_ICONEXCLAMATION);
    end;
    if Patient.ADDR_IS_TEMP then gbxContactInfo.Caption := 'TEMPORARY address:';
    lblHfone.Caption := lblHfone.Caption + ' ' + Patient.HomePhone;
    lblWfone.Caption := lblWfone.Caption + ' ' + Patient.WorkPhone;
    //lblPname.Caption := Patient.Name + ' ';
    lblPname.Caption := Patient.Name + ' ';
    lblPtInfo.Caption := Patient.SSN + '  ' + DateToStr(Patient.DOB);
  finally
    SL.Free;
  end;
end;


procedure TfrmAnticoagulate.RefreshLastHgbOrHct;
const
  HGB_OR_HCT : array[false..true] of string = ('Last Hct', 'Last Hgb');
begin
  SetHctOrHgbInfo(Patient.HctOrHgbValue, Patient.HctOrHgbDate);
  gbxLastHctOrHgb.Caption := HGB_OR_HCT[Patient.HGBFlag];
end;

procedure TfrmAnticoagulate.RefreshPercentInGoal;
const
  CAPTION : array[igmAll..igmNonComplex] of string = ('(all)', '(non-complex)');
begin
  gbxPctInGoal.Visible := not Patient.NewPatient;
  gbxPctInGoal.Caption := 'Percent in Goal ' + CAPTION[AppState.PctInGoalMode];
  GetPercentInGoal(Patient, AppState.PctInGoalMode);
  lblPCgoal.Caption := Patient.PctINRInGoal  + '%';
  lblGoalDenominator.Caption := 'of ' + Patient.TotalINRValues + ' INR values:';
end;

procedure TfrmAnticoagulate.RefreshNoShowStatus;
const
  CAPTION : array[false..true] of string = (
    'Flag as &Missed Appt',
    'Unflag &Missed Appt'   );
var
  NoShow : boolean;
begin
  NoShow := (AppState.AppointmentShowStatus = tsvNoShow);
  btnMissedAppt.Caption := CAPTION[NoShow];
  lblMissedAppt.Visible := NoShow;
  lblMissedApptDate.Visible := NoShow;
  dtpMissedAppt.Visible := NoShow;
  AppState.AppointmentNoShowDate := IfThenDT(NoShow, Now, 0);
  dtpMissedAppt.DateTime := AppState.AppointmentNoShowDate;

  gbxShow.Visible := not Patient.NewPatient;
  if Patient.PctNoShow = '' then begin
    lblPctNoShow.Caption := 'None';
    lblPctNoShowDenominator.Caption := '';
  end else begin
    lblPctNoShow.Caption := Patient.PctNoShow + '%';
    lblPctNoShowDenominator.Caption := 'of '+ Patient.TotalVisits + ' visits:';
  end;

end;

procedure TfrmAnticoagulate.RefreshGraphTitle;
begin
  chrtINR.Title.Text[0] := 'INR  (Goal: ' + Patient.GoalINR + ')';
end;

procedure TfrmAnticoagulate.RefreshGraph;
var i :                    integer;
    INR :                  string;
    fINR, fDollarH :       single;
    OnePastINR :           TOnePastINRValue;
    SourceFlowsheet :      TOneFlowsheet;
    fLowGoal, fHighGoal:   single;
    AlreadyAdded:          TStringList;
    tempS:                 string;
    Count :                integer;

begin
  serINR.Clear;
  AlreadyAdded := TStringList.Create;
  Count := 0;
  try
    //Load past INR values into graph.
    for i := 0 to AppState.PastINRValues.Count - 1 do begin
      OnePastINR := AppState.PastINRValues[i];
      SourceFlowsheet := TOneFlowsheet(OnePastINR.SourceFlowsheet);
      if not Assigned(SourceFlowsheet) then continue;
      if SourceFlowsheet.Retracted and not AppState.ShowRetractedFlowsheets then continue;
      Inc(Count);
      fLowGoal := SourceFlowsheet.fINRGoalLow;
      fHighGoal := SourceFlowsheet.fINRGoalHigh;
      INR := OnePastINR.INR;
      fINR := OnePastINR.fINR; if fINR <= 0 then continue;
      fDollarH := OnePastINR.Horolog; if fDollarH <= 0 then continue;
      tempS := TMGFloatToStr(fDollarH)+'^'+TMGFloatToStr(fINR)+'^'+TMGFloatToStr(fHighGoal)+'^'+TMGFloatToStr(fLowGoal);
      if AlreadyAdded.IndexOf(tempS) >= 0 then continue;  //prevent duplicate data points.
      AlreadyAdded.Add(tempS);
      serINR.AddXY(fDollarH, fINR, OnePastINR.DateStr);
      if (fLowGoal > 0) and (fHighGoal > 0) then begin
        serUpperGoal.AddXY(fDollarH, fHighGoal, OnePastINR.DateStr);
        serLowerGoal.AddXY(fDollarH, fLowGoal, OnePastINR.DateStr);
      end;
    end;
  finally
    AlreadyAdded.Free;
  end;
  btnViewFlowsheetGrid.Visible := (Count > 0);
end;



procedure TfrmAnticoagulate.RefreshModifiableData;
var Discharged : boolean;
    HasContacts : boolean;
const
  MSG_TEXT : array [false .. true] of string = (
    'Pt has not given permission to leave anticoag messages on answering machine. ',
    'OK to leave anticoag information on answering machine. '  );
  SIGNED_AGREEMENT_CAPTION: array [false .. true] of string = (
    'NO signed agreement',
    'Pt has a signed agreement.'  );

begin
  RefreshDisplayedINR;
  RefreshFlowsheetDateDisplay;
  RefreshLastHgbOrHct;
  RefreshPercentInGoal;
  RefreshNoShowStatus;
  if Patient.NextScheduledINRCheckDate = 0 then Patient.NextScheduledINRCheckDate := Today;
  Discharged                 := Patient.DischargedFromClinic;
  lblDrawRestr.Caption       := Patient.DrawDaysRestrictionStr;
  lblComplex.Visible         := (Patient.COMPLEXITY = tpcComplex);
  lblComplex.Caption         := IfThenStr(Discharged, 'Inactive Patient', 'Complex Patient');
  if Patient.DischargedFromClinic then lblComplex.visible := false;
  lblAM.Visible              := (Patient.AM_MEDS = tammAMMeds);
  dtpNextApp.visible         := not Discharged;
  gbxReturnForINR.visible    := not Discharged;
  ckbCBCOrder.Enabled        := not Discharged and (Parameters.CBCQuickOrder <> '');
  ckbINROrder.Enabled        := not Discharged and (Parameters.INRQuickOrder <> '');
  if Discharged then begin
    ckbINROrder.Checked      := false; //will trigger ckbINROrderClick()
    ckbCBCOrder.Checked      := false; //will trigger ckbCBCOrderClick()
  end else begin
    ckbINROrder.Checked      := (Parameters.INRQuickOrder <> ''); //will trigger ckbINROrderClick()
    ckbCBCOrder.Checked      := false;  //will trigger ckbCBCOrderClick()
    dtpNextApp.DateTime      := Patient.NextScheduledINRCheckDate//should trigger dtpNextAppChange();  ??
  end;
  lblMSG.Caption := MSG_TEXT[Patient.MsgPhone = tmpMsgOK];
  lblSign.Caption := SIGNED_AGREEMENT_CAPTION[Patient.SignedAgreement];

  HasContacts := (Patient.PersonsOKForMessageStr <> '');
  lblPMsg.Caption := IfThenStr(HasContacts, 'OK to leave anticoag message with ' + Patient.PersonsOKForMessageStr, '');
  lblPMsg.Visible := HasContacts;
end;


procedure TfrmAnticoagulate.cbxINRGoalClick(Sender: TObject);
var
  frmCustomINRGoal: TfrmCustomINRGoal;
  GoalStr : string;
begin
  cbxINRGoal.Color := clWindow;
  GoalStr := cbxINRGoal.Text; //default value
  if cbxINRGoal.ItemIndex = 3 then begin  //3 = 'Other'
    frmCustomINRGoal := TfrmCustomINRGoal.Create(Self);
    try
      frmCustomINRGoal.GoalStr := GoalStr;
      if frmCustomINRGoal.ShowModal = mrOK then begin
        application.ProcessMessages;
        GoalStr := frmCustomINRGoal.GoalStr;
        //changes the goal % to cooincide with new goals
        //kt lblPCgoal.Enabled := false;
      end else begin
        InfoBox('No specific INR Goal Range entered.' + CRLF +
                'Please reselect range...', 'INR Goal Range Required',
                 MB_OK or MB_ICONEXCLAMATION);
        cbxINRGoal.SetFocus;
        exit;
      end;
    finally
      frmCustomINRGoal.Free;
    end;
  end;
  Patient.GoalINR := GoalStr;
  cbxINRGoal.Text := GoalStr;
  CurrentFlowsheet.CurrentINRGoal := GoalStr;
  RefreshDisplayedINR;
  RefreshGraphTitle;
end;

procedure TfrmAnticoagulate.SetDosingGridEnable(Enabled: boolean);
//kt added function 12/17
var ARow, ACol, i : integer;
    AControl      : TControl;
    ALabel        : TLabel;
    ABtn          : TBitBtn;
    //NonZero       : boolean;
    //AColor        : TColor;
    RowEnabled    : boolean;
    Row2Enabled   : boolean;

begin
  for ARow := 0 to self.sgDosingData.RowCount - 1 do begin
    RowEnabled := Enabled;
    if ARow in [ROW_STRENGTH_2, ROW_NUM_TABS_2] then begin
      RowEnabled := Enabled and CurrentFlowsheet.UsingTwoPills;
    end;
    for ACol := 0 to self.sgDosingData.ColCount - 1 do begin
      AControl := TControl(self.sgDosingData.Objects[ACol,ARow]);
      if not assigned(AControl) then continue;
      AControl.Enabled := RowEnabled;
    end;
  end;

  Row2Enabled := Enabled and CurrentFlowsheet.UsingTwoPills;
  cboPS.Enabled := Enabled;
  cboPS2.Enabled := Row2Enabled;
  cbUse2Pills.Enabled := Enabled;
  for i := 0 to DosingLabelsList.Count - 1 do begin
    ALabel := TLabel(DosingLabelsList[i]);
    if not assigned(ALabel) then continue;
    ALabel.Enabled := Enabled;
  end;
  for i := 0 to SwapButtonsList.Count - 1 do begin
    ABtn := TBitBtn(SwapButtonsList[i]);
    if not assigned(ABtn) then continue;
    ABtn.Visible := Row2Enabled;
  end;
  lblMg2.Enabled := Row2Enabled;
  lblPillStrength2.Enabled := Row2Enabled;
  SetWeeklyDoseComparisonControlVisibility(Enabled);
  SetDosingGridColors;

  gbxInstructions.Enabled := Enabled;
  ckbHold.Enabled := Enabled;
  ckbTake.Enabled := Enabled;
  memPatientInstructions.Enabled := Enabled;

end;

procedure TfrmAnticoagulate.SetDosingGridColors;
//kt added function 12/17
var ARow, ACol      : integer;
    AControl        : TControl;
    AColor          : TColor;
    Enabled         : boolean;
    OtherRow        : integer;
    Zero, OtherZero : boolean;
    OtherEdit       : TEdit;

const
  GRID_BK_COLOR  : array[False..True] of TColor = (cl3DLight, clBtnFace);
  CBO_TEXT_COLOR : array[False..True] of TColor = (clGrayText, clWindowText);
  PS_COLORS      : array[False..True] of TColor =(clBtnFace, clSkyBlue);
  PS2_COLORS     : array[False..True] of TColor =(clBtnFace, clMoneyGreen);
  OPPOSITE_ROW   : array[ROW_NUM_TABS_1..ROW_NUM_TABS_2] of integer = (ROW_NUM_TABS_2, -1, ROW_NUM_TABS_1);

begin
  for ARow := 0 to self.sgDosingData.RowCount - 1 do begin
    for ACol := 0 to self.sgDosingData.ColCount - 1 do begin
      AControl := TControl(self.sgDosingData.Objects[ACol,ARow]);
      if not assigned(AControl) then continue;
      Enabled := AControl.Enabled;
      AColor := clBtnFace; //default
      if Enabled then begin
        Zero := false;
        OtherZero := false;
        if AControl is TEdit then begin //should only be true on rows 2 & 4
          OtherRow := OPPOSITE_ROW[ARow];
          OtherEdit := TEdit(sgDosingData.Objects[ACol,OtherRow]);
          if (OtherEdit is TEdit) then OtherZero := (StrToFloatDef(OtherEdit.Text,0) = 0);
          Zero := (StrToFloatDef(TEdit(AControl).Text,0) = 0);
        end;
        if Zero and OtherZero then begin
          AColor := clDoseColEmpty;
        end else if (ARow = ROW_TOTAL_MGS) then begin
          AColor := clTotalRow;
        end else begin
          AColor := DOSE_GRID_DISPLAY_COLORS[(ARow=ROW_NUM_TABS_1), not Zero];
        end;
      end;
      TExposedControl(AControl).Color := AColor;
    end;
  end;

  cboPS.Font.Color       := CBO_TEXT_COLOR[cboPS.Enabled];
  cboPS.Color            := PS_COLORS[cboPS.Enabled];
  cboPS2.Font.Color      := CBO_TEXT_COLOR[cboPS2.Enabled];
  cboPS2.Color           := PS2_COLORS[cboPS2.Enabled];
  gbxDailyDosing.color   := GRID_BK_COLOR[gbxDailyDosing.Enabled];
  cbUse2Pills.Font.Color := CBO_TEXT_COLOR[cbUse2Pills.Enabled];
end;


procedure TfrmAnticoagulate.btnEditDailyDoseClick(Sender: TObject);
begin
  FEditingDoses := true;
  btnCancelDose.Top := btnEditDailyDose.Top;  //not aligned at design time, so that button would not be hidden
  btnCancelDose.Left := btnEditDailyDose.Left;
  btnCancelDose.Visible := true;
  btnEditDailyDose.Visible := false;
  SetDosingGridEnable(true); //kt 12/17
  edtCT1Sun.SetFocus;
  gbxDailyDosing.Caption := 'New Daily Dosing';
  CurrentFlowsheet.DosingEdited := true;
end;

function TfrmAnticoagulate.OKToExit : boolean;
begin
  result := false; //default to NOT OK to exit
  if (not radNoCopyGiven.Checked) and (not radCopyGiven.Checked) then begin
    InfoBox('Please check is note copy was given to patient or not','Incomplete', MB_OK or MB_ICONEXCLAMATION);
    exit;
  end;
  
  if Patient.DischargedFromClinic then begin
    Result := true;
    exit;
  end;
  if PATIENT.SaveMode = tsmTempSave then begin
    Result := true;
    exit;
  end;

  if (AppState.PCEProcedureStr = '') and AppState.FilePCEData then begin
    InfoBox('Please complete PCE Data before exiting.',
            'Incomplete Encounter Information', MB_OK or MB_ICONEXCLAMATION);
    exit;
  end;

  if IsPastDate(Patient.NextScheduledINRCheckDate) then begin
    InfoBox('The next lab draw date of ' + DateToStr(Patient.NextScheduledINRCheckDate) + ' is NOT a future date.' + CRLF +
            'Please adjust it to complete the update.', 'Invalid Date', MB_OK or MB_ICONEXCLAMATION);
    exit;
  end;     //past date

  //if future call back date has not been changed, ask if that is OK
  if DateCompare(Patient.NextScheduledINRCheckDate, InitialReturnApptDateTime) = tdcSame then begin
    if InfoBox('The next lab draw date of ' + DateToStr(Patient.NextScheduledINRCheckDate) + ' has not been changed.' + CRLF +
               'If it is incorrect, click CANCEL and change the date' + CRLF + 'before completing the visit.',
               'Date unchanged', MB_OKCANCEL or MB_ICONEXCLAMATION) <> mrOK then begin
      exit;
    end;
  end;

  {
  if CurrentFlowsheet.Comments.Count = 0 then begin
    if InfoBox('There are no comments listed.  Enter now?',
      'No Comments Listed', MB_YESNO or MB_ICONQUESTION) = mrYes then begin
      pcMain.ActivePage := tsEnterInfo;
      memComments.SetFocus;
      exit;
    end;
  end;
  }

  if not StrToIntDef(Patient.ClinicIEN, 0) > 0  then begin
    InfoBox('Must indicate the Clinic which is following this patient.',
            'No Clinic Selected', MB_OK or MB_ICONEXCLAMATION);
    pcMain.ActivePage := tsOverview;
    cboSite.SetFocus;
    exit;
  end;

  if (AppState.PCEProcedureStr = '') and AppState.FilePCEData then begin
    InfoBox('Please complete PCE Data before proceeding', 'Incomplete Encounter Information', MB_OK or MB_ICONEXCLAMATION);
    exit;
  end;

  result := true; //OK to exit if we got this far.
end;

function TfrmAnticoagulate.DoExitingPrep() : boolean;
//result True if OK to continue, False if should abort
var frmPCE_ACM : TfrmPCE_ACM;
    ModalResult : integer;
begin
  SetEClinic(AppState);
  result := true;
  if IsPastDate(Patient.NextScheduledINRCheckDate) then begin
    if AppState.AppointmentShowStatus = tsvUnDef then begin
      if InfoBox('Record as missed appointment?',
                 'Possible No Show', MB_YESNO or MB_ICONQUESTION) = mrYes then begin
        AppState.AppointmentShowStatus := tsvNoShow;
      end else begin
        AppState.AppointmentShowStatus := tsvKeptAppt;
      end;
    end;
  end;
  if (PATIENT.SaveMode = tsmTempSave) and (CompareDate(Patient.NextScheduledINRCheckDate, today)>0) then begin
    Patient.NextScheduledINRCheckDate := Today;
    dtpNextApp.Date := TODAY;  //should trigger dtpNextAppChange()  ??
    InfoBox('Next appointment date is set to TODAY on a temporary save.',
            'Next Appointment Date', MB_OK or MB_ICONEXCLAMATION);
  end;
  //Commented this section. Only consider missed is manually entered as such  elh    9/18/18
  {
  if CurrentFlowsheet.INRLabDateStr <> '' then begin
    case DaysBetween(CurrentFlowsheet.INRLabDateTime, Patient.NextScheduledINRCheckDate) of
      0 :   AppState.AppointmentShowStatus := tsvKeptAppt;
      1 :   AppState.AppointmentShowStatus := tsvWithin1Day;
      else  AppState.AppointmentShowStatus := tsvNoShow;
    end;
  end;
  }
  AppState.Cofactor := tcfUndef;
  // ** begin ordering section
  if PATIENT.SaveMode = tsmSave then begin
    if (AppState.INROrderSelected or AppState.CBCOrderSelected) and not Patient.DischargedFromClinic then begin  //orders labs
      if not CosignerNeeded(tcfOrder, AppState, AppState.NoteInfo.CosignerDUZ) then begin
        if AppState.INROrderSelected then OrderIt(AppState, 'INR');
        if AppState.CBCOrderSelected then OrderIt(AppState, 'CBC');
      end;
    end;  //OrderIt
  end;  // ** ordering section

  if (AppState.EClinic = '') then SetEClinic(AppState);  //Encounter location needed for ordering
  if AppState.FilePCEData then begin
    if (AppState.PCEProcedureStr = Parameters.SimplePhoneCPT) or
       (AppState.PCEProcedureStr = Parameters.ComplexPhoneCPT) or
       (AppState.PCEProcedureStr = Parameters.PatientLetterCPT) then begin
      AppState.EClinic := Parameters.PhoneClinic
    end else begin
      AppState.EClinic := Parameters.VisitClinic;
    end;
  end else begin
    AppState.EClinic := Parameters.NonCountClinic;
  end;

  if AppState.FilePCEData then begin
    frmPCE_ACM := TfrmPCE_ACM.Create(self);
    frmPCE_ACM.initialize(Patient.DFN, Patient.VisitDate, AppState.EClinic);
    if uSCCond.AskAny then begin
      ModalResult := frmPCE_ACM.ShowModal;
    end else begin
      ModalResult := -1;
    end;
    frmPCE_ACM.Free;
    if ModalResult = mrCancel then begin
      InfoBox('Unable to complete visit due to missing information.',
              'Required information', MB_OK or MB_ICONEXCLAMATION);
      result := false;
      exit;
    end;
  end;
end;

function TfrmAnticoagulate.DocumentationOK : boolean;
var
  frmCompletedVisitNote: TfrmCompletedVisitNote;
  ErrMsg : string;
begin
  Result := false; //default to failure
  frmCompletedVisitNote := TfrmCompletedVisitNote.Create(Self);
  Try
    if frmCompletedVisitNote.ShowModal(AppState, AppState.CurrentNewFlowsheet) = mrOK then begin
      if not frmCompletedVisitNote.NoNoteSave then begin
        if not frmCompletedVisitNote.MakeAndSaveTIUNote(ErrMsg) then begin
          MessageDlg('Aborting Exit because: "'+ErrMsg+'"', mtError, [mbOK], 0);
        end;
      end;
      AppState.Assign(frmCompletedVisitNote.ModifiedAppState);
      //NOTE: frmCompletedVisitLetter copies and modifies the AppState and the flowsheet.
      //     So even though we are passing in a pointer the flowsheet contained in AppState, the
      //     *modified* flowsheet in frmCompletedVisitLetter is NOT the same object as
      //     AppState.CurrentNewFlowsheet.  So I need to copy is separately.
      AppState.CurrentNewFlowsheet.Assign(frmCompletedVisitNote.ModifiedFlowsheet);  //In form, flowsheet is modified separately from AppState.CurrentNewFlowsheet
      Result := true;
    end;
  Finally
    frmCompletedVisitNote.Free;
  End;
end;

procedure TfrmAnticoagulate.btnCompleteVisitClick(Sender: TObject);      //PREPARES AND SENDS DATA; CLOSES FORM
begin
  if not OKToExit() then exit;
  if not DoExitingPrep then exit;
  if not DocumentationOK then exit;
  if AppState.FilePCEData then FilePCEData(AppState);
  ManageTeamLists(AppState);  //if SAVE mode and not NewPt, remove pt. from current list
  if Patient.NewPatient then begin
    AddNewPatient(Patient.DFN);  //this adds a new patient to the database file
    Patient.NewPatient := false;
  end;

  Patient.SaveToServer(AppState);
  CurrentFlowsheet.SaveToServer(AppState);

  {//To Do -- restore later!  Will need to be instantiated first...
  if frmCompleteConsult.lbxConsult.Count > 0 then begin
    exit;
  end;
  }
  self.ModalResult := mrOk;
  //Application.Terminate;
end;

procedure TfrmAnticoagulate.cboIndicationChange(Sender: TObject);
var SL : TStringList;
    Data : string;
    Index : integer;
    frmNewIndication: TfrmNewIndication;

begin
  if csLoading in ComponentState then Exit;
  cboIndication.Color := clWindow;
  Index := cboIndication.ItemIndex;
  if Index > -1 then begin
    SL := TStringList(cboIndication.Tag); if not assigned(SL) then Exit;
    Data := SL[Index];
    if Piece(Data, '^', 1) = 'Other' then begin
      frmNewIndication := TfrmNewIndication.Create(Self);
      try
        if frmNewIndication.ShowModal = mrOK then begin
          Patient.Indication_Text     := frmNewIndication.NewIndication_Text;
          Patient.Indication_ICDCode  := frmNewIndication.NewIndication_Code;
          cboIndication.Text := Patient.Indication_Text;
          edtICDCode.Text := Patient.Indication_Text;
          Patient.UserSelectedIndication := true;
        end;
      finally
        FreeAndNil(frmNewIndication);
      end;
    end else begin
      Patient.Indication_Text     := Piece(Data, '^', 1);
      Patient.Indication_ICDCode  := Piece(Data, '^', 2);
      edtICDCode.Text := Patient.Indication_ICDCode;
      Patient.UserSelectedIndication := true;
    end;
  end;
  //Patient.Indication_Text := cboIndication.Text;
end;

procedure TfrmAnticoagulate.cboIndicationExit(Sender: TObject);
begin
  if (Patient.NewPatient and (cboIndication.Text = '')) then begin
    InfoBox('Indication is required for New Patients.' + CRLF +
            'Please choose a valid indication...', 'Indication Required',
             MB_OK or MB_ICONEXCLAMATION);
    cboIndication.SetFocus;
  end else if cboIndication.Text = 'Other' then begin
    InfoBox('No specific indication entered.' + CRLF +
            'Please choose a valid indication...', 'Indication Required',
             MB_OK or MB_ICONEXCLAMATION);
    cboIndication.SetFocus;
  end;
end;

procedure TfrmAnticoagulate.mnuAboutClick(Sender: TObject);
begin
  ShowAboutACM;
end;

procedure TfrmAnticoagulate.mnuAnticoagulationManagementHelpClick(Sender: TObject);
begin
  WinHelp( Application.Handle, PChar(Application.HelpFile), HELP_FINDER, 0);
end;

procedure TfrmAnticoagulate.mnuCopyClick(Sender: TObject);
begin
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmAnticoagulate.mnuCutClick(Sender: TObject);
begin
  FEditCtrl.CutToClipboard;
end;

procedure TfrmAnticoagulate.mnuDemographicsClick(Sender: TObject);
begin
  pcMain.ActivePage := tsOverview;
  tsOverview.SetFocus;
  tsOverview.Invalidate;
end;

procedure TfrmAnticoagulate.mnuEditClick(Sender: TObject);
var IsReadOnly: Boolean;
begin
  FEditCtrl := nil;
  if Screen.ActiveControl is TCustomEdit then FEditCtrl := TCustomEdit(Screen.ActiveControl);
  if FEditCtrl <> nil then begin
    if      FEditCtrl is TMemo     then IsReadOnly := TMemo(FEditCtrl).ReadOnly
    else if FEditCtrl is TEdit     then IsReadOnly := TEdit(FEditCtrl).ReadOnly
    else if FEditCtrl is TRichEdit then IsReadOnly := TRichEdit(FEditCtrl).ReadOnly
    else IsReadOnly := True;
    mnuUndo.Enabled := FEditCtrl.Perform(EM_CANUNDO, 0, 0) <> 0;
    mnuCut.Enabled := FEditCtrl.SelLength > 0;
    mnuCopy.Enabled := mnuCut.Enabled;
    mnuPaste.Enabled := (IsReadOnly = False) and Clipboard.HasFormat(CF_TEXT);
  end else begin
    mnuUndo.Enabled := False;
    mnuCut.Enabled  := False;
    mnuCopy.Enabled := False;
    mnuPaste.Enabled := False;
  end;
end;

procedure TfrmAnticoagulate.mnuEnterInformationClick(Sender: TObject);
begin
  pcMain.ActivePage := tsEnterInfo;
  tsEnterInfo.SetFocus;
end;

procedure TfrmAnticoagulate.mnuEnterOutsideLabClick(Sender: TObject);
begin
  btnNewINRClick(Sender);
end;

procedure TfrmAnticoagulate.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAnticoagulate.mnuExitTabClick(Sender: TObject);
begin
  pcMain.ActivePage := tsExit;
  if not Patient.NewPatient then
    tsExit.SetFocus;
end;

procedure TfrmAnticoagulate.mnuHelpBrokerClick(Sender: TObject);
begin
  ShowBroker;
end;

procedure TfrmAnticoagulate.mnuPasteClick(Sender: TObject);
begin
  FEditCtrl.SelText := Clipboard.AsText;
end;

procedure TfrmAnticoagulate.mnuPtPreferencesClick(Sender: TObject);
begin
  btnEditPatientClick(Sender);
end;

procedure TfrmAnticoagulate.mnuUndoClick(Sender: TObject);
begin
  FEditCtrl.Perform(EM_UNDO, 0, 0);
end;

procedure TfrmAnticoagulate.mnuUtilitiesClick(Sender: TObject);
begin
  pcMain.ActivePage := tsSTAT;
  tsSTAT.SetFocus;
end;

procedure TfrmAnticoagulate.memCommentsExit(Sender: TObject);
begin
 CurrentFlowsheet.Comments.Assign(memComments.Lines);
end;

procedure TfrmAnticoagulate.memPatientInstructionsChange(Sender: TObject);
begin
  if AppState.PushingDataToScreen then exit;
  CurrentFlowsheet.PatientInstructions.Assign(memPatientInstructions.Lines);
end;

procedure TfrmAnticoagulate.memPatientInstructionsClick(Sender: TObject);
begin
  memPatientInstructionsEnter(Sender);
end;

procedure TfrmAnticoagulate.memPatientInstructionsEnter(Sender: TObject);
var
  frmAMTEditMemo: TfrmAMTEditMemo;
  temp : boolean;
begin
  frmAMTEditMemo := TfrmAMTEditMemo.Create(Self);
  try
    if frmAMTEditMemo.ShowModal(CurrentFlowsheet.PatientInstructions) = mrOK then begin
      CurrentFlowsheet.PatientInstructions.Assign(frmAMTEditMemo.memMemo.Lines);
      temp := AppState.PushingDataToScreen;
      AppState.PushingDataToScreen := true;
      memPatientInstructions.Lines.Assign(CurrentFlowsheet.PatientInstructions);
      AppState.PushingDataToScreen := temp;
    end;
  finally
    frmAMTEditMemo.Free;
  end;
  ckbHold.SetFocus;
end;

procedure TfrmAnticoagulate.btnEditDoseNextClick(Sender: TObject);
begin
  if Length(memComments.Lines.Text) < 1 then memComments.Lines[0] := 'None';
  pcMain.ActivePage := tsExit;
end;


procedure TfrmAnticoagulate.HandleDosingGridEditChange(Sender: TObject);
var
  Tablets:               Single;
  DecPart:               String;
  Edit:                  TEdit;

const
  OPPOSITE_ROW : array[ROW_NUM_TABS_1..ROW_NUM_TABS_2] of integer = (ROW_NUM_TABS_2, -1, ROW_NUM_TABS_1);


begin
  if AppState.PushingDataToScreen then exit;
  Edit := Sender as TEdit;
  with Edit do begin
    if Length(Text) = 0 then begin
      Text := '0';
      SelectAll;
    end else begin
      Tablets := StrToFloat(Text);
      DecPart := Piece(Text, '.', 2);
      if (Length(DecPart) >= 2) then begin
        if (Copy(DecPart, 0, 1) = '0') then begin
          Text := FloatToStrF(Tablets, ffNumber, 6, 0)
        end else begin
          Text := FloatToStrF(Tablets, ffNumber, 6, 2);
        end;
      end else begin
        SelStart := Length(Text);
      end;

      if Edit.Focused and (not FTabCutWarn) and (FCreationStep = FCP_FINISH)
         and (Length(DecPart) > 0) and (StrToFloat(('0.' + DecPart)) <> 0.0)
         and (StrToFloat(('0.' + DecPart)) <> 0.5) then begin
        FTabCutWarn := True;
        InfoBox('Fractions of tablets other than one half are not reliable.' + CRLF + 'You may wish to reconsider.',
          'Unreliable Partial Tablet', MB_OK or MB_ICONWARNING);
        //kt SelStart := pos(DecimalSeparator, Text);
        SelStart := pos(DecimalSeparator, Text);
        SelLength := Length(DecPart);
      end else begin
        SelStart := Length(Text);
      end;
    end;
    SetDosingGridColors;
    {
    if FindEdit(Edit, Row, Col) then begin
      OtherRow := OPPOSITE_ROW[Row];
      OtherEdit := TEdit(sgDosingData.Objects[Col,OtherRow]);
      Zero := (StrToFloatDef(Edit.Text,0) = 0);
      OtherZero := (StrToFloatDef(OtherEdit.Text,0) = 0);
      if Zero and OtherZero then begin
        Edit.Color := clDoseColEmpty;
        OtherEdit.Color := clDoseColEmpty;
      end else begin
        Edit.Color := DOSE_GRID_DISPLAY_COLORS[(Row=ROW_NUM_TABS_1), not Zero];
      end;
    end;
    }
  end;
  RefreshDosingGrid; //kt added
end;

procedure TfrmAnticoagulate.CheckInputForNumeric(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8, DecimalSeparator]) then
    Key := #0
  else begin
    with Sender as TEdit do begin
      if (Key = DecimalSeparator) and (pos(DecimalSeparator, Text) >0) then
        Key := #0;
    end;
  end;
end;

procedure TfrmAnticoagulate.edtDosingGridKeyPress(Sender: TObject; var Key: Char);
begin
  CheckInputForNumeric(Sender, Key);
end;

procedure TfrmAnticoagulate.DosingGridEditExit(Sender: TObject);
begin
  FTabCutWarn := False;
end;

procedure TfrmAnticoagulate.dtpNextApptChange(Sender: TObject);
begin
  SetNextApptDateTime;
end;

procedure TfrmAnticoagulate.dtpAppTimeChange(Sender: TObject);
var tmCurrent, HoD: Extended;
begin
  tmCurrent := dtpAppTime.Time;
  if tmCurrent = PreviousDisplayedApptTime then exit;
  HoD := HourOf(tmCurrent);
  if (HoD < 7) or (HoD > 17) then begin
    dtpAppTime.Time := PreviousDisplayedApptTime
  end else begin
    PreviousDisplayedApptTime := tmCurrent;
  end;
  SetNextApptDateTime;
end;

procedure TfrmAnticoagulate.SetNextApptDateTime;
begin
  Patient.NextScheduledINRCheckDate := dtpNextApp.Date;
  Patient.NextScheduledINRCheckTime := IfThenDT(dtpAppTime.Visible, dtpAppTime.Time, 0);
end;

procedure TfrmAnticoagulate.dtpNextAppExit(Sender: TObject);
begin
  with Sender as TDateTimePicker do begin
    if not CheckDrawDay then begin
      if Patient.NextScheduledINRCheckDate <> 0 then
        Date := Patient.NextScheduledINRCheckDate
      else
        Date := today;
      SetFocus;
      Invalidate;
    end;
  end;
end;

procedure TfrmAnticoagulate.btnComplicationsClick(Sender: TObject);
var
  frmEditComplications: TfrmEditComplications;
begin
  frmEditComplications := TfrmEditComplications.Create(Self);
  try
    if frmEditComplications.ShowModal(CurrentFlowsheet.Complications, CurrentFlowsheet.DateStr) = mrOK then begin
      CurrentFlowsheet.Complications.Assign(frmEditComplications.Complications);  //this is an encoded SL
      CurrentFlowsheet.ComplicationScore := frmEditComplications.ComplicationScore;
    end;
  finally
    frmEditComplications.Free;
  end;
end;

procedure TfrmAnticoagulate.btnNewINRClick(Sender: TObject);
var
  frmOutsideLab: TfrmOutsideLab;
  Historical : boolean;
  SavePCEData : boolean;

const
  HISTORICAL_INR_LABEL : array[false..true] of string = ('Last INR:', 'Old INR:');
  INR_BUTTON_CAPTION : array[false..true] of string= ('&New INR', 'Edit &New INR');
begin
  frmOutsideLab := TfrmOutsideLab.Create(Self);
  try
    if frmOutsideLab.ShowModal(CurrentFlowsheet, AppState, Patient)= mrOK then begin
      CurrentFlowsheet.Assign(frmOutsideLab.FlowSheet);
      Patient.Assign(frmOutsideLab.Patient);
      AppState.OutsideLabDataEntered := (CurrentFlowsheet.INR <> '');
      SetHctOrHgbInfo(CurrentFlowsheet.HctOrHgbValue, CurrentFlowsheet.INRLabDateStr);

      //if Patient.SAVE_MODE = 'TEMPSAVE' then begin
      //  SetDisplayedINRValue(edtNewInr.Text, DateToStr(dtpINR.DateTime));
      //  ckbINROrder.Checked := false; //will trigger ckbINROrderClick()
      //end;

      Historical := frmOutsideLab.Historical;
      AppState.Historical := Historical;
      if AppState.Historical then CurrentFlowsheet.DateStr := CurrentFlowsheet.INRLabDateStr;

      gbxPCE.Visible := AppState.FilePCEData and not AppState.Historical;

      //kt lblLastINR.Caption := HISTORICAL_INR_LABEL[Historical];
      SavePCEData := (AppState.Parameters.Str0Pce13= '1');
      AppState.FilePCEData := SavePCEData;
      if AppState.FilePCEData and Historical then AppState.FilePCEData := false;
      //AppState.FilePCEData := not Historical;

      btnTempSave.Enabled := not Historical;
      CurrentFlowsheet.DateTime := IfThenDT(Historical, CurrentFlowsheet.INRLabDateTime, Now);
      RefreshFlowsheetDateDisplay;
      RefreshModifiableData;
      btnNewINR.Caption := INR_BUTTON_CAPTION[AppState.OutsideLabDataEntered];
    end;
  finally
    frmOutsideLab.Free;
  end;

end;

procedure TfrmAnticoagulate.dtpMissedApptChange(Sender: TObject);
begin
  AppState.AppointmentNoShowDate := dtpMissedAppt.DateTime;
end;

procedure TfrmAnticoagulate.btnTempSaveClick(Sender: TObject);
begin
  PATIENT.SaveMode := tsmTempSave;
  AppState.FilePCEData := false;
  btnCompleteVisit.Click;
end;

procedure TfrmAnticoagulate.btnCancelDoseClick(Sender: TObject);
//var index : integer;
const DOSING_CAPTION : array[false..true] of string = (
       'Current Daily Dosing',
       'Suggested Daily Dosing');
begin
  FEditingDoses := false;
  CurrentFlowsheet.AssignJustDosing(Patient.FlowsheetData.MostRecent);
  DosingDataToScreen(CurrentFlowsheet);
  SetWeeklyDoseComparisonControlVisibility(false);
  SetDosingGridEnable(false); //kt 12/17
  gbxDailyDosing.Caption := DOSING_CAPTION[Patient.NewPatient];
  btnCancelDose.Visible := false;
  btnEditDailyDose.Visible := true;
  CurrentFlowsheet.DosingEdited := false;
end;

procedure TfrmAnticoagulate.rbNoMCClick(Sender: TObject);
begin
  {
  if rbNoMC.Checked = true then
  begin
    memCL.Clear;
    pnlMChange.Visible := false;
    MNote := 'Please do not make any changes in your weekly dosages.  Continue weekly schedule as below.';
    MNoteCl := 'Please contact us if you are taking a different dosage of warfarin or if you have any questions, ' +
               'concerns, signs of bleeding, or if you need to reschedule this appointment. ' + #13#10;
    memCL.Lines[0] := MNote;
    memCL.Visible := true;
    lblCL.Visible := true;
    btnCVL.Enabled := true;
    if not (memDCnote.Lines.Count > 0) then
      ckbCAInclInst.Enabled := true;
    btnCVL.Width := 90;
    btnCVL.Left := 125;
    btnCVL.Caption := '&Preview/Print';
  end;
  }
end;


procedure TfrmAnticoagulate.SetEClinic(AnAppState : TAppState);
begin
  if (rbPhoneS.Checked = true) or (rbPhoneC.Checked = true) or
     (rbLetter.Checked = true) then begin
    AnAppState.EClinic := Parameters.PhoneClinic;
    AnAppState.SvcCat := 'T';
  end else begin
    AnAppState.EClinic := Parameters.VisitClinic;
    AnAppState.SvcCat := 'A';
  end;
  if not AppState.FilePCEData then begin
    AnAppState.EClinic := Parameters.NonCountClinic;
  end;
end;

procedure TfrmAnticoagulate.ckbCBCOrderClick(Sender: TObject);
begin
  AppState.CBCOrderSelected := ckbCBCOrder.checked;
end;


procedure TfrmAnticoagulate.btnCompletedVisitLetterClick(Sender: TObject);
var
  frmCompletedVisitLetter: TfrmCompletedVisitNote;
  TempAppState : TAppState;

begin
  if not IsFutureDate(Patient.NextScheduledINRCheckDate) then begin
    InfoBox('You must select a future Return Date to send a Letter.',
            'Invalid Return Date for Letter', MB_OK or MB_ICONEXCLAMATION);
    dtpNextApp.SetFocus;
    exit;
  end;
  frmCompletedVisitLetter := TfrmCompletedVisitNote.Create(Self);
  TempAppState := TAppState.Create;
  try
    TempAppState.Assign(AppState);
    if frmCompletedVisitLetter.ShowModal(TempAppState, TempAppState.CurrentNewFlowsheet) = mrOK then begin
      AppState.Assign(TempAppState);
    end;
  finally
    frmCompletedVisitLetter.Free;
    TempAppState.Free;
  end;

end;

procedure TfrmAnticoagulate.cboPSChange(Sender: TObject);
begin
 SetPillStrengthLabels(1);
 RefreshDosingGrid;
end;

procedure TfrmAnticoagulate.cboPS2Change(Sender: TObject);
begin
 SetPillStrengthLabels(2);
 RefreshDosingGrid;
end;

procedure TfrmAnticoagulate.cboPS2Exit(Sender: TObject);
var fNewStrength : single;
begin
  fNewStrength := StrToFloatDef(cboPS2.text, -1);
  if (fNewStrength >= 1) then begin
    CurrentFlowsheet.fPillStrength2 := fNewStrength; //will trigger internal recalculation
    AppState.UserSelectedPillStrength := true;
  end;
end;

procedure TfrmAnticoagulate.cboPSExit(Sender: TObject);
var fNewStrength : single;
begin
  fNewStrength := StrToFloatDef(cboPS.text, -1);
  if (fNewStrength >= 1) then begin
    CurrentFlowsheet.fPillStrength1 := fNewStrength;  //will trigger internal recalculation
    AppState.UserSelectedPillStrength := true;
  end else begin
    InfoBox('Pill Strength is required.' + CRLF +
            'Please enter a valid strenght in milligrams (e.g., 5)...',
            'Pill Strength Required',
             MB_OK or MB_ICONEXCLAMATION);
    cboPS.SetFocus;
  end;
end;

procedure TfrmAnticoagulate.cbUse2PillsClick(Sender: TObject);
begin
  SetIfUsingTwoPills(cbUse2Pills.Checked);
end;

procedure TfrmAnticoagulate.edtPtNoteChange(Sender: TObject);
begin
  CurrentFlowsheet.PatientNotice := edtPtNote.Text;
end;

procedure TfrmAnticoagulate.edtPtNoteKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(13) then memComments.SetFocus;
end;

procedure TfrmAnticoagulate.edtTakeNumMgTodayChange(Sender: TObject);
var Valid : boolean;
begin
  Valid := (StrToIntDef(edtTakeNumMgToday.Text,-1) <> -1) or (ckbTake.Checked = false);
  edtTakeNumMgToday.Color := VALID_COLOR[Valid];
  if AppState.PushingDataToScreen then exit;
  PullExtraInstructionsData;
end;

procedure TfrmAnticoagulate.btnXPCEnter(Sender: TObject);
begin
  pnlXPC.Visible := true;
end;

procedure TfrmAnticoagulate.btnXPCExit(Sender: TObject);
begin
  pnlXPC.Visible := false;
end;

procedure TfrmAnticoagulate.btnPctInGoalReportMouseEnter(Sender: TObject);
begin
  pnlXPC.Visible := true;
  pnlCount.Visible := false;
  pnlLTF.Visible := false;
end;

procedure TfrmAnticoagulate.btnPctInGoalReportMouseLeave(Sender: TObject);
begin
  pnlXPC.Visible := false;
end;

procedure TfrmAnticoagulate.lblPercentInGoalMouseEnter(Sender: TObject);
begin
  pnlXPC.Visible := true;
  pnlCount.Visible := false;
end;

procedure TfrmAnticoagulate.lblPercentInGoalMouseLeave(Sender: TObject);
begin
      pnlXPC.Visible := false;
end;

procedure TfrmAnticoagulate.ActivityReport(NumNays : string; Mode : tActivityMode);
var frmActivityDetail: TfrmActivityDetail;
begin
  frmActivityDetail := TfrmActivityDetail.Create(Self);
  try
    frmActivityDetail.Initialize(Parameters.SiteName, Patient.ClinicIEN);
    frmActivityDetail.NumDays := NumNays;
    frmActivityDetail.Mode := Mode;
    frmActivityDetail.ShowModal;
  finally
    frmActivityDetail.Free;
  end;
end;

procedure TfrmAnticoagulate.btnPctInGoalReportClick(Sender: TObject);
begin
  ActivityReport(edtXDays.Text, tPct);
end;

procedure TfrmAnticoagulate.btnTWeekClick(Sender: TObject);
begin
  ActivityReport(edtXDays.Text, tFind);
end;

procedure TfrmAnticoagulate.btnLostClick(Sender: TObject);
begin
  ActivityReport(edtLTF.Text, tLost);
end;

procedure TfrmAnticoagulate.btnTWeekMouseEnter(Sender: TObject);
begin
  pnlXPC.Visible := false;
  pnlCount.Visible := true;
  pnlLTF.Visible := false;
end;

procedure TfrmAnticoagulate.btnTWeekMouseLeave(Sender: TObject);
begin
  pnlCount.Visible := false;
end;

procedure TfrmAnticoagulate.btnLostMouseEnter(Sender: TObject);
begin
  pnlXPC.Visible := false;
  pnlCount.Visible := false;
  pnlLTF.Visible := true;
end;

procedure TfrmAnticoagulate.btnLostMouseLeave(Sender: TObject);
begin
  pnlLTF.Visible := false;
end;

procedure TfrmAnticoagulate.btnFileCClick(Sender: TObject);
//var mcomp:string;
begin
  //kt note: I think it is confusing to allow exiting application from
  // this point.  So I want all exiting to be done from Exit Tab.  So will comment this out

  {
  if CurrentNewFlowsheet.ComplicationScore < 1 then begin
    InfoBox('Nothing to file.', 'No Changes Made', MB_OK or MB_ICONINFORMATION);
    exit;
  end;
  mcomp := '';
  if InfoBox('This will file JUST the complications report and exit.' + CRLF +
             'No other information will be saved.',
             'File Complications Only', MB_OKCANCEL or MB_ICONINFORMATION) = mrCancel then
    exit;
  if CurrentNewFlowsheet.ComplicationScore > 0 then begin
    mcomp := Complications();
    mcomp := mcomp + '^         entered: '+datetostr(today)+' -'+ Provider.Initials;
    CallV('ORAM3 COMPENT',[Patient.DFN, Provider.DUZ, IntToStr(CurrentNewFlowsheet.ComplicationScore), mcomp, DATETOSTR(dtpComp.Date)]);
  end;
  CallV('ORAM1 UNLOCK',[Patient.DFN]);
  AbortExecution;
  }
end;

procedure TfrmAnticoagulate.ckbHoldClick(Sender: TObject);
begin
  if AppState.PushingDataToScreen then exit;
  AppState.PushingDataToScreen := true;
  edtNumHoldDays.Enabled := ckbHold.Checked;
  if not ckbHold.Checked then edtNumHoldDays.Text := '';
  lblHoldDays.Enabled := ckbHold.Checked;
  ckbTake.Checked := false;
  edtTakeNumMgToday.Text := '';
  edtNumHoldDaysChange(Self);
  edtTakeNumMgTodayChange(Self);
  AppState.PushingDataToScreen := false;
  PullExtraInstructionsData;
end;

procedure TfrmAnticoagulate.PullExtraInstructionsData;
begin
  CurrentFlowsheet.DoseTakeNumMgToday := IfThenStr(ckbTake.Checked, edtTakeNumMgToday.Text, '');
  CurrentFlowsheet.DoseHoldNumOfDays := edtNumHoldDays.Text;
end;

procedure TfrmAnticoagulate.ckbINROrderClick(Sender: TObject);
begin
  AppState.INROrderSelected := ckbINROrder.Checked;
end;

procedure TfrmAnticoagulate.ckbTakeClick(Sender: TObject);
begin
  if AppState.PushingDataToScreen then exit;
  AppState.PushingDataToScreen := true;

  edtTakeNumMgToday.Enabled := ckbTake.Checked;
  if not ckbTake.Checked then edtTakeNumMgToday.Text := '';
  lblExtraMgsToday.Enabled := ckbTake.Checked;
  ckbHold.Checked := false;
  edtNumHoldDays.Text := '';
  edtNumHoldDaysChange(Self);
  edtTakeNumMgTodayChange(Self);
  AppState.PushingDataToScreen := false;
  PullExtraInstructionsData;
end;

procedure TfrmAnticoagulate.Complications1Click(Sender: TObject);
begin
  btnComplicationsClick(Sender);
end;

procedure TfrmAnticoagulate.cboSiteExit(Sender: TObject);
begin
  if cboSite.Text = '' then begin
    InfoBox('Must have a Clinic selected to proceed.', 'Clinic Required', MB_OK or MB_ICONEXCLAMATION);
    cboSite.SetFocus;
  end;
end;

procedure TfrmAnticoagulate.cboSitePullData;
begin
  Patient.ClinicLoc := cboItemPiece(cboSite, 2);
  Patient.ClinicIEN := Piece(Patient.ClinicLoc, ';', 1);
  Patient.ClinicName := cboItemPiece(cboSite, 1);
end;

procedure TfrmAnticoagulate.cboSiteSelect(Sender: TObject);
var Result : boolean;
begin
  if csLoading in ComponentState then Exit;
  cboSite.Color := clWindow;
  if cboSite.ItemIndex > -1 then begin
    cboSitePullData;

    Result := GetParametersByRPC(Provider.DUZ, Patient.ClinicLoc, Parameters);
    if Result = false then Application.Terminate; //Info box explaining problem already shown in GetParametersByRPC
    Result := ApplyParameters(Parameters);
    if Result = false then Application.Terminate; //Info box explaining problem already shown in ApplyParameters

    Patient.VisitDate := SCallV('ORAM APPTMTCH', [Patient.DFN, Patient.ClinicIEN]);
    if Patient.NewPatient then begin
      if not AppState.UserSelectedPillStrength then begin
        CurrentFlowsheet.fPillStrength1 := Parameters.DefaultPillStrength;
        cboSelectByID(cboPS,CurrentFlowsheet.PillStrength1); //should trigger event
      end;
    end;
  end;
end;

procedure TfrmAnticoagulate.chrtINREnter(Sender: TObject);
begin
  {
  if ScreenReaderSystemActive then begin
    GetScreenReader.Speak('This chart plots INR as a function of time.');
    if serINR.Count = 0 then
      GetScreenReader.Speak('There are no INR values to report.');
    with serINR do begin
      for i := 0 to Count - 1 do begin
        GetScreenReader.Speak('The INR value was ' + YValueToText(YValue[i]));
        GetScreenReader.Speak('on ' + XLabel[i]);
      end;
    end;
  end;
  }
end;

procedure TfrmAnticoagulate.chrtINRMouseWheel(Sender: TObject; Shift: TShiftState;
                                              WheelDelta: Integer; MousePos: TPoint;
                                              var Handled: Boolean);
begin
  if WheelDelta > 0 then begin
    chrtINR.ZoomPercent(110);
  end else if WheelDelta < 0 then begin
    chrtINR.ZoomPercent(90);
  end;
  Handled := true;
end;

procedure TfrmAnticoagulate.btnUnzoomGraphClick(Sender: TObject);
begin
  chrtINR.UndoZoom;
  btnUnzoomGraph.Visible := false;
end;

procedure TfrmAnticoagulate.btnViewFlowsheetGridClick(Sender: TObject);
var
  frmViewFlowsheetGrid: TfrmViewFlowsheetGrid;

begin
  frmViewFlowsheetGrid := TfrmViewFlowsheetGrid.Create(Self);
  try
    if frmViewFlowsheetGrid.ShowModal(AppState) = mrOK then begin
      RefreshGraph;
      RefreshPercentInGoal;
    end;
  finally
    frmViewFlowsheetGrid.Free;
  end;
end;

procedure TfrmAnticoagulate.chrtINRZoom(Sender: TObject);
begin
  btnUnzoomGraph.Visible := true;
end;

procedure TfrmAnticoagulate.lblLTFQueryMouseEnter(Sender: TObject);
begin
  pnlLTF.Visible := true;
  pnlCount.Visible := false;
end;

procedure TfrmAnticoagulate.lblLTFQueryMouseLeave(Sender: TObject);
begin
  pnlLTF.Visible := false;
end;

procedure TfrmAnticoagulate.btnDemoNextClick(Sender: TObject);
begin
  pcMain.ActivePage := tsEnterInfo;
end;

procedure TfrmAnticoagulate.btnDocumentationNextClick(Sender: TObject);
begin
  pcMain.ActivePage := tsExit;
end;

function TfrmAnticoagulate.CheckDrawDay: Boolean;
var
  DrawDay : tDaysOfWeek;
  weekend: Integer;
begin
  Result := false; //default to failure
  DrawDay := TMGDayOfTheWeek(Patient.NextScheduledINRCheckDate);
  //these statements check for return date of Sat or Sun and change to Monday
  if DrawDay = daySat then begin
    weekend := InfoBox('You''ve selected a Saturday. Are you sure?' + CRLF + CRLF
                + '(If not, we''ll increment the draw date to Monday).', 'Saturday Draw Date', MB_YESNO or MB_ICONQUESTION);
    if (weekend = IDNO) then begin
      dtpNextApp.Date := IncDay(Patient.NextScheduledINRCheckDate, 2);  //doesn't seem to trigger dtpNextAppChange()
      dtpNextApptChange(self);
    end;
  end;
  if DrawDay = daySun then begin
    weekend := InfoBox('You''ve selected a Sunday. Are you sure?' + CRLF + CRLF
                + '(If not, we''ll increment the draw date to Monday).', 'Sunday Draw Date', MB_YESNO or MB_ICONQUESTION);
    if (weekend = IDNO) then begin
      dtpNextApp.Date := IncDay(Patient.NextScheduledINRCheckDate, 1);  //doesn't seem to trigger dtpNextAppChange()
      dtpNextApptChange(self);
    end;
  end;
  //checks for do not draw days
  if Patient.DrawRestrictionsArray[DrawDay] then begin
    InfoBox('This is a "no draw" day, please use calender to adjust it.',
            'No Draw Day', MB_OK or MB_ICONEXCLAMATION);
    exit;
  end;

  result := true;
end;

procedure TfrmAnticoagulate.btnEditPatientClick(Sender: TObject);
var PtInfo : TfrmPatientInformation;
begin
  pnlHighlightEditPref.Color := clBtnFace;
  PtInfo := TfrmPatientInformation.Create(Self);
  try
    if PtInfo.ShowModal(AppState, CurrentFlowSheet) = mrOK then begin
      AppState.Assign(PtInfo.ModifiedAppState);  //this also copies (assigns) all contained objects, including Patient.
      //CurrentNewFlowsheet.Comments
      if Patient.DischargedFromClinic = true then begin
        CurrentFlowsheet.Comments.Add('Patient d/c''d from clinic - ' + Provider.Initials);
      end else if PATIENT.SaveMode = tsmTempSave then begin
        CurrentFlowsheet.Comments.Add('ENTRY IN PROGRESS' + ' - ' + LowerCase(Provider.Initials));
      end else if Patient.COMPLEXITY = tpcComplex then begin
        //CurrentNewFlowsheet.Comments.Add('COMPLEX PATIENT' + #13#10 + DTEXT +
        //    AppState.NextApptDateTimeStr + plusday + ' -' + Provider.Initials;
      end else begin
        //CommNew := DTEXT + AppState.NextApptDateTimeStr + plusday + ' -' + Provider.Initials;
      end;
      RefreshModifiableData;
    end;
  finally
    PtInfo.Free;
  end;
end;

procedure TfrmAnticoagulate.btnRemindClick(Sender: TObject);
var frmReminder: TfrmReminder;
begin
  frmReminder := TfrmReminder.Create(Self);
  try
    frmReminder.Initialize(Patient);
    if frmReminder.ShowModal = mrOK then begin
      Patient.ReminderTextSL.Assign(frmReminder.ReminderText);
      Patient.ReminderDate := frmReminder.dtpRemind.Date;
      btnRemind.Caption := frmReminder.CaptionForButton;
    end;
  finally
    frmReminder.Free;
  end;
end;

procedure TfrmAnticoagulate.edtICDCodeChange(Sender: TObject);
begin
  Patient.Indication_ICDCode := Trim(edtICDCode.Text);
end;

procedure TfrmAnticoagulate.edtNumHoldDaysChange(Sender: TObject);
var Valid : boolean;
begin
  Valid := (StrToIntDef(edtNumHoldDays.Text ,-1) <> -1) or (ckbHold.Checked = false);
  edtNumHoldDays.Color := VALID_COLOR[Valid];
  if AppState.PushingDataToScreen then exit;
  PullExtraInstructionsData;
end;

procedure TfrmAnticoagulate.btnUnlockClick(Sender: TObject);
var frmUnlockPatient: TfrmUnlockPatient;
begin
  frmUnlockPatient:= TfrmUnlockPatient.Create(Self);
  try
    frmUnlockPatient.ShowModal;
  finally
    frmUnlockPatient.Free;
  end;
end;

procedure TfrmAnticoagulate.AbortExecution;
begin
  Application.Terminate;
  AbortingExecution := true;
end;

procedure TfrmAnticoagulate.btnSwapClick(Sender: TObject);
var i : integer;
    ABtn : TBitBtn;
    TopEdit, BottomEdit : TEdit;
    TempS : string;
begin
  if not (Sender is TBitBtn) then exit;
  ABtn := TBitBtn(Sender);
  i := SwapButtonsList.indexOf(ABtn);
  if (i < COL_SUN) or (i > COL_SAT) then exit;
  TopEdit := TEdit(sgDosingData.Objects[i, ROW_NUM_TABS_1]);
  BottomEdit := TEdit(sgDosingData.Objects[i, ROW_NUM_TABS_2]);
  TempS := BottomEdit.Text;
  BottomEdit.Text := TopEdit.Text;  //should trigger event
  TopEdit.Text := TempS;            //should trigger event
end;

procedure TfrmAnticoagulate.btnSwitchClick(Sender: TObject);
const  OPPOSITE : array[igmAll..igmNonComplex] of tPctInGoalMode = (igmNonComplex, IgmALL);
begin
  AppState.PctInGoalMode := OPPOSITE[AppState.PctInGoalMode];
  RefreshPercentInGoal;
end;

procedure TfrmAnticoagulate.btnMissedApptClick(Sender: TObject);
begin
  If AppState.AppointmentShowStatus = tsvNoShow then begin
    AppState.AppointmentShowStatus := tsvKeptAppt ;
    AppState.AppointmentNoShowDate := 0;
  end else begin
    AppState.AppointmentShowStatus := tsvNoShow;
    //InfoBox('Missed appointment flag set.', 'Flag Set', MB_OK or MB_ICONINFORMATION);
    AppState.AppointmentNoShowDate := Now;
  end;
  RefreshNoShowStatus;

end;

procedure TfrmAnticoagulate.cbxINRGoalExit(Sender: TObject);
begin
  if (Patient.NewPatient and (cbxINRGoal.Text = '')) then begin
    InfoBox('INR Goal Range is required for New Patients.' + CRLF +
            'Please choose a valid range...', 'INR Goal Range Required',
             MB_OK or MB_ICONEXCLAMATION);
    cbxINRGoal.SetFocus;
  end else if cbxINRGoal.Text = 'Other' then begin
    InfoBox('No specific INR Goal Range entered.' + CRLF +
            'Please specify a valid range...', 'INR Goal Range Required',
             MB_OK or MB_ICONEXCLAMATION);
    cbxINRGoal.SetFocus;
  end;
end;

procedure TfrmAnticoagulate.tsExitShow(Sender: TObject);
begin
  if (AppState.NoteInfo.NoteIEN = '') then begin
    if Patient.NewPatient then begin
      //kt Fix later.
      {
      if gbxDC.Visible = false then begin
        btnIntakeNote.Click
      end else if memDCnote.Lines.Text = GeneratedNoteText then begin
        memDCnote.Lines.Clear;
        SyncMemoToHTML(memDCnote, HTMlDCNote); //kt 12/17
        //kt GenerateIntakeNote(AppState);
      end;
      }
    end else begin
      //kt Fix later.
      {
      if gbxDC.Visible and (memDCnote.Lines.Text = GeneratedNoteText) then begin
        memDCnote.Lines.Clear;
        SyncMemoToHTML(memDCnote, HTMlDCNote); //kt 12/17
        if AppState.FTitle = Parameters.InterimNote then
          //kt GenerateInterimNote
        else if AppState.FTitle = Parameters.IntakeNote then
          //kt GenerateIntakeNote(AppState);
      end;
      }
    end;
  end;
end;

procedure TfrmAnticoagulate.pcMainChange(Sender: TObject);
begin
  //if cbxSite.text = '' then begin
  if not StrToIntDef(Patient.ClinicIEN, 0) > 0 then begin
    InfoBox('Must have a Clinic selected to proceed.', 'Clinic Required', MB_OK or MB_ICONEXCLAMATION);
    pcmain.ActivePage := tsOverview;
    cboSite.SetFocus;
    exit; //kt added 12/17
  end;
end;

procedure TfrmAnticoagulate.pnlRemindEnter(Sender: TObject);
begin
  //kt if ScreenReaderSystemActive then
  //kt   GetScreenReader.Speak('Enter the date of the Reminder.');
end;

procedure TfrmAnticoagulate.btnPlusXClick(Sender: TObject);
var XDATE: TDate;
    NumDaysToAdd : integer;
begin
  NumDaysToAdd := TButton(Sender).Tag;
  XDATE := IfThenDT(CurrentFlowsheet.INRLabDateStr <> '', CurrentFlowsheet.INRLabDateTime, Today);
  dtpNextApp.Date := IncDay(XDATE, NumDaysToAdd);  //should trigger dtpNextAppChange() later, not immediate
  if (CurrentFlowsheet.INRLabDateStr <> '') and (CurrentFlowsheet.INRLabDateTime <> Today) and not IsPastDate(dtpNextApp.Date) then begin
    InfoBox('Setting return date ' + IntToStr(NumDaysToAdd) + ' from last INR (' + CurrentFlowsheet.INRLabDateStr + ')',
    'Return date relative to last INR', MB_OK or MB_ICONEXCLAMATION);
  end;
  if IsPastDate(dtpNextApp.Date) then dtpNextApp.Date := IncDay(today, NumDaysToAdd); //Doesn't trigger change event
  dtpNextApptChange(self);
  CheckDrawDay;
  dtpNextApp.SetFocus;
  dtpNextApp.InitiateAction;
end;

procedure TFrmAnticoagulate.SetIfUsingTwoPills(Value : boolean);
begin
  CurrentFlowsheet.UsingTwoPills := Value;
  SetDosingGridEnable(FEditingDoses);
  RefreshDosingGrid;
end;

procedure TFrmAnticoagulate.DosingDataToScreen(Data : TOneFlowsheet);
var i : integer;
    PillStr1, PillStr2, tempS : string;
    PushingState : boolean;
begin
  PushingState := AppState.PushingDataToScreen;
  AppState.PushingDataToScreen := true;

  PillStr1 := Data.PillStrength1;
  if (PillStr1 = '') or (PillStr1 = '0') then PillStr1 := TMGFloatToStr(Parameters.DefaultPillStrength);
  cboSelectByID(cboPS,PillStr1);
  if (cboPS.Text <> PillStr1) then cboPS.Text := PillStr1;
  SetPillStrengthLabels(1);
  for i := 1 to 7 do begin
    SetControlText(sgDosingData.Objects[i-1, ROW_NUM_TABS_1], Data.NumTabs1ForDay[tDaysOfWeek(i)]);
  end;

  CurrentFlowsheet.UsingTwoPills := (StrToFloatDef(Data.PillStrength2,0) > 0);
  cbUse2Pills.Checked := CurrentFlowsheet.UsingTwoPills;
  PillStr2 := IfThenStr(CurrentFlowsheet.UsingTwoPills, Data.PillStrength2, '');
  cboSelectByID(cboPS2, PillStr2);
  if (cboPS2.Text <> PillStr2) then cboPS2.Text := PillStr2;
  for i := 1 to 7 do begin
    tempS := IfThenStr(CurrentFlowsheet.UsingTwoPills, Data.NumTabs2ForDay[tDaysOfWeek(i)], '');
    SetControlText(sgDosingData.Objects[i-1, ROW_NUM_TABS_2], tempS);
  end;
  SetPillStrengthLabels(2);

  RefreshDosingGrid;
  AppState.PushingDataToScreen := PushingState;

  if Data.DosingSuggested then gbxDailyDosing.Caption := 'Suggested Daily Dosing';
end;


procedure TFrmAnticoagulate.SetWeeklyDoseComparisonControlVisibility(VisibleVal : boolean);
begin
  lblPriorTotalName.Visible := VisibleVal;
  lblPctChangeName.Visible := VisibleVal;
  lblPriorTotal.Visible := VisibleVal;
  lblChangePct.Visible := VisibleVal;
end;


procedure TFrmAnticoagulate.SetPillStrengthLabels(Row : integer);
var
  PillStrength : string;
  RowIdx : integer;
  ALabel : TLabel;
  cboPSx : TComboBox;
  i : integer;
const
  INDEX : array[1..2] of integer = (ROW_STRENGTH_1, ROW_STRENGTH_2);
begin
  if Row <= 1 then Row := 1;
  if Row >= 2 then Row := 2;
  RowIdx := INDEX[Row];

  if Row = 1 then cboPSx := cboPS else cboPSx := cboPS2;
  PillStrength := Trim(cboPSx.Text);
  //load edits with pill strengths.
  for i := 0 to 6 do begin
    ALabel := TLabel(sgDosingData.Objects[i, RowIdx]);
    ALabel.Caption := IfThenStr(PillStrength<>'', PillStrength+' mg', '');
  end;
end;


function TFrmAnticoagulate.FindEdit(AEdit : TEdit; var OutRow, OutCol : Integer) : boolean;
var Index, Row,Col : integer;
    Found : boolean;
const
  EDIT_ROWS : array [1..2] of integer = (ROW_NUM_TABS_1, ROW_NUM_TABS_2);
begin
  OutRow := -1;
  OutCol := -1;
  Found := false;
  for Index := 1 to 2 do begin
    Row := EDIT_ROWS[Index];
    for Col := 0 to sgDosingData.ColCount - 1 do begin
      if AEdit <> sgDosingData.Objects[Col,Row] then continue;
      Found := true;
      OutRow := Row;
      OutCol := Col;
      Break;
    end;
    if Found then break;
  end;
  Result := Found;
end;


function TFrmAnticoagulate.GetINRRecommendedChange(INRValue : string; INRDateTime: TDateTime) : string;
//TO DO -- later consider making this part of parameters.
var INRGoal : string;
    fINR, fLowINR, fHighINR : single;
    Recommendation : string;
    NumDays : integer;
begin
  Result := '';
  NumDays := DaysBetween(Now, INRDateTime);
  if NumDays > 3 then begin
    Recommendation := 'INR is too old for recommendation (over 3 days old).';
  end else begin
    fINR := StrToFloatDef(INRValue,0);
    INRGoal := cbxINRGoal.Text;
    fLowINR := StrToFloatDef(Piece(INRGoal, '-', 1),0);
    fHighINR := StrToFloatDef(Piece(INRGoal, '-', 2),0);
    //NOTE: recommendations from here: http://excellence.acforum.org/sites/default/files/Ambulatory%20Warfarin%20Protocol%202012.pdf
    if (fLowINR = 1.5) and (fHighINR = 2.5) then begin  //GOAL: 1.5 - 2.0
      if fINR <= 1.2 then begin
        //inc 10%
        Recommendation := 'Increase weekly dose 10%';
      end else if (fINR > 1.2) and (fINR <= 1.4) then begin
        //inc 5%
        Recommendation := 'Increase weekly dose 5%';
      end else if (fINR >1.4) and (fINR <= 2.0) then begin
        //no change
        Recommendation := 'No change';
      end else if (fINR >2.0) and (fINR <= 3.0) then begin
        //dec 5%
        Recommendation := 'Change weekly dose -5%';
      end else if (fINR >3.0) and (fINR <= 4.0) then begin
        ////consider half dose x 1 and dec 10% weekly
        Recommendation := 'Consider half dose x 1 and change weekly dose -10%';
      end else if (fINR >4.0) and (fINR <= 5.0) then begin
        //hold 1 dose and dec 10-20% weekly
        Recommendation := 'Hold 1 dose and change weekly dose -10 to -20%';
      end else if (fINR >5.0) and (fINR <= 9.0) then begin
        //MD order required.  Consider holding 2 doses and dec 10-20%, check HGB/Hct
        Recommendation := 'DOCTOR ORDER REQUIRED. Consider: hold 2 dose and change weekly dose -10 to -20%. Check Hgb or Hct.';
      end else if (fINR >9.0)then begin
        //contact doctor for urgent patient evaluation
        Recommendation := 'CONTACT DOCTOR FOR URGENT PATIENT EVALUATION.';
      end;
    end else if (fLowINR = 2) and (fHighINR = 3) then begin  //GOAL: 2 - 3
      if fINR < 1.5 then begin
        //extra dose, inc 10-20%
        Recommendation := 'Extra Dose.  Increase weekly dose 10-20%';
      end else if (fINR >= 1.5) and (fINR <= 1.9) then begin
        //inc 5-10%
        Recommendation := 'Increase weekly dose 5-10%';
      end else if (fINR >= 2.0) and (fINR <= 3.0) then begin
        //no change
        Recommendation := 'No change';
      end else if (fINR > 3.0) and (fINR <= 4.0) then begin
        //dec 5 - 10%
        Recommendation := 'Change weekly dose -5 to -10%';
      end else if (fINR >4.0) and (fINR <= 5.0) then begin
        //hold 1 dose and dec 10-20% weekly
        Recommendation := 'Hold 1 dose.  Change weekly dose -5 to -10%';
      end else if (fINR > 5.0) and (fINR < 9.0) then begin
        //MD order required.  Consider holding 2 doses and dec 10-20%, check HGB/Hct
        Recommendation := 'DOCTOR ORDER REQUIRED. Consider: hold 2 dose and change weekly dose -10 to -20%. Check Hgb or Hct.';
      end else if (fINR >9.0)then begin
        //contact doctor for urgent patient evaluation
        Recommendation := 'CONTACT DOCTOR FOR URGENT PATIENT EVALUATION.';
      end;
    end else if (fLowINR = 2.5) and (fHighINR = 3.5) then begin  //GOAL: 2.5 - 3.5
      if fINR < 1.9 then begin
        //extra dose, inc 10-20%
        Recommendation := 'Extra Dose.  Increase weekly dose 10-20%';
      end else if (fINR >= 1.9) and (fINR <= 2.4) then begin
        //inc 5-10%
        Recommendation := 'Increase weekly dose 5-10%';
      end else if (fINR >= 2.5) and (fINR <= 3.5) then begin
        //no change
        Recommendation := 'No change';
      end else if (fINR > 3.5) and (fINR <= 4.5) then begin
        //dec 5 - 10%
        Recommendation := 'Change weekly dose -5 to -10%';
      end else if (fINR > 4.5) and (fINR <= 5.0) then begin
        //hold 1 dose and dec 10% weekly
        Recommendation := 'Hold 1 dose.  Change weekly dose -10%';
      end else if (fINR > 5.0) and (fINR < 9.0) then begin
        //MD order required.  Consider holding 2 doses and dec 10-20%, check HGB/Hct
        Recommendation := 'DOCTOR ORDER REQUIRED. Consider: hold 2 dose and change weekly dose -10 to -20%. Check Hgb or Hct.';
      end else if (fINR >9.0)then begin
        //contct doctor for urgent patient evaluation
        Recommendation := 'CONTACT DOCTOR FOR URGENT PATIENT EVALUATION.';
      end;
    end else begin
      Recommendation := 'No recommendation for custom INR range.';
    end;
  end;
  Result := Recommendation;
end;

procedure TFrmAnticoagulate.RefreshDisplayedINR;
var
  INR: string;
  GoalINR : string;
  DT : TDateTime;
  DTStr : string;

  procedure SetColors(AnINRColor, FontsColor : TColor);
  begin
    pnlINR.Color := AnINRColor;
    lblINRdt.Font.Color := FontsColor;
    lblINRval.Font.Color := FontsColor;
    lblLastINR.Font.Color := FontsColor;
  end;

  procedure INRColor();
  var cINR:single;
      lowINR: single;
      highINR: single;
      Foreground, Background : TColor;

  begin
    Foreground := clBlack;   //default
    if DT = 0 then begin  //don't colorize if invalid data (e.g. when new patient)
      Background := clBtnFace;
      SetColors(Background, Foreground);
      exit;
    end;
    if LeftStr(INR, 2) = '  ' then exit;
    if (Pos('>', INR) > 0) or (Pos('<', INR) > 0) then begin
      Background := clRed;  Foreground := clWhite;
    end else if (length(INR) > 0) and (GoalINR <>'') then begin
      if StrToFloatDef(INR, -1) = -1 then begin
       Background := clInvalid;
      end else begin
        lowINR := StrToFloat(Piece(GoalINR, '-', 1));
        highINR := StrToFloat(Piece(GoalINR, '-', 2));
        cINR := StrToFloat(INR);
        if (cINR > highINR) OR (cINR < lowINR) then begin
          Background := clRed;  Foreground := clWhite;
        end else begin
          Background := clMoneyGreen;
        end;
      end;
    end else begin
      Background := clInvalid;
    end;
    SetColors(Background, Foreground);
  end;

begin
  INR := CurrentFlowsheet.INR;
  DT := CurrentFlowsheet.INRLabDateTime;
  DTStr := IfThenStr(CurrentFlowsheet.INRLabDateTime>0, CurrentFlowsheet.INRLabDateStr, '');
  GoalINR := CurrentFlowsheet.CurrentINRGoal;

  lblINRval.Caption := INR;
  lblINRdt.Caption := DtSTR;
  lblRecommendedChange.Caption := GetINRRecommendedChange(INR, DT);
  INRColor();
end;



initialization
  //kt SpecifyFormIsNotADialog(TfrmAnticoagulate);
  AbortingExecution := false;
end.



