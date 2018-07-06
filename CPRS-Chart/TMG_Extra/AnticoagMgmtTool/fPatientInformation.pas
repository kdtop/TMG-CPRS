unit fPatientInformation;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics,
  uTypesACM, ORFn, StrUtils, uFlowsheet,
  Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, Controls, Classes;

type
  TfrmPatientInformation = class(TForm)
    gbxUpdate: TGroupBox;
    lblRisks: TLabel;
    lblDuration: TLabel;
    lblStartDate: TLabel;
    lblOrientationDate: TLabel;
    lblSpecialInstructions: TLabel;
    lblStop: TLabel;
    lblAllowedPersons: TLabel;
    ckbBridging: TCheckBox;
    ckbMsg: TCheckBox;
    ckbPmsg: TCheckBox;
    memPeople: TMemo;
    ckbAMmeds: TCheckBox;
    memRisk: TMemo;
    memSpecialInstructions: TMemo;
    pnlLevelOfComplexity: TPanel;
    lblLevelOfComplexity: TLabel;
    rbComplex: TRadioButton;
    rbStand: TRadioButton;
    ckbSA: TCheckBox;
    ckbNoStop: TCheckBox;
    btnSExit: TButton;
    pnlRestrict: TPanel;
    lblRstrctDrawDays: TLabel;
    ckbRM: TCheckBox;
    ckbRF: TCheckBox;
    ckbRT: TCheckBox;
    ckbRTh: TCheckBox;
    ckbRW: TCheckBox;
    edtDur: TEdit;
    edtStop: TEdit;
    edtSDate: TEdit;
    edtODate: TEdit;
    ckbIncludeRisksInNote: TCheckBox;
    btnEditBridgingComments: TButton;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnDischargeFromClinic: TBitBtn;
    procedure ckbAMmedsClick(Sender: TObject);
    procedure ckbBridgingClick(Sender: TObject);
    procedure btnEditBridgingCommentsClick(Sender: TObject);
    procedure ckbMsgClick(Sender: TObject);
    procedure ckbPmsgClick(Sender: TObject);
    procedure ckbSAClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure memSpecialInstructionsChange(Sender: TObject);
    procedure memSpecialInstructionsExit(Sender: TObject);
    procedure memPeopleChange(Sender: TObject);
    procedure memPeopleExit(Sender: TObject);
    procedure memRiskChange(Sender: TObject);
    procedure memRiskExit(Sender: TObject);
    procedure ckbRestrictDayClick(Sender: TObject);
    procedure edtSDateChange(Sender: TObject);
    procedure edtSDateExit(Sender: TObject);
    procedure edtStopChange(Sender: TObject);
    procedure ckbNoStopClick(Sender: TObject);
    procedure edtODateChange(Sender: TObject);
    procedure edtODateExit(Sender: TObject);
    procedure edtDurChange(Sender: TObject);
    procedure edtDurExit(Sender: TObject);
    procedure edtDurKeyPress(Sender: TObject; var Key: Char);
    procedure ckbIncludeRisksInNoteClick(Sender: TObject);
    procedure rbStandClick(Sender: TObject);
    procedure rbComplexClick(Sender: TObject);
    procedure btnSExitClick(Sender: TObject);
    procedure edtODateEnter(Sender: TObject);
    procedure edtDurEnter(Sender: TObject);
    procedure btnDischargeFromClinicClick(Sender: TObject);
  private
    { Private declarations }
    FPatient : TPatient;  //convience pointer.  Owned by FAppState;
    FAppState : TAppState;  //owned here
    FFlowsheet : TOneFlowsheet;
    RestrictDayCheckboxArray : TWeekCheckBoxArray;
    FPushingOutData : boolean;
    //function GetRestrictedDrawDaysStr : string;
    procedure SetDischargeEnableStatus(Discharged : boolean);
    procedure DataToGUI;
  public
    { Public declarations }
    function ShowModal(AppState : TAppState; AFlowsheet : TOneFlowsheet) : integer; overload;
    //property RestrictedDrawDaysStr : string read GetRestrictedDrawDaysStr;
    property ModifiedAppState : TAppState read FAppState;
  end;

//var
//  frmPatientInformation: TfrmPatientInformation;

implementation

{$R *.dfm}

uses
  fBridgeCommentsDialog, uUtility, fDischargeInfo;


function HasDrawDayRestrictions(WeekArray : TWeekBoolArray) : boolean;
var
  AWeekDay : tDaysOfWeek;
begin
  Result := false;
  for AWeekDay := dayMon to dayFri do begin
    Result := Result or WeekArray[AWeekDay];
    if Result = true then break;
  end;
end;

procedure TfrmPatientInformation.DataToGUI;
var
  AWeekDay : tDaysOfWeek;
begin
  FPushingOutData := true;

  memSpecialInstructions.lines.Assign(FPatient.SpecialInstructionsSL);
  memPeople.Lines.Assign(FPatient.PersonsOKForMsgSL);
  memRisk.Lines.Assign(FPatient.RiskFactorsSL);

  ckbAMmeds.Checked := (FPatient.AM_Meds = tammAMMeds);
  ckbBridging.Checked := FPatient.Needs_LMWH_Bridging;
  ckbMsg.Checked := (FPatient.MsgPhone = tmpMsgOK);
  ckbPmsg.Checked := (memPeople.Lines.Count > 0) and (memPeople.Lines[0] <> '');
  ckbSA.Checked := FPatient.SignedAgreement;
  btnEditBridgingComments.Visible := (FPatient.BridgingCommentsSL.Count > 0);
  edtStop.Text := FPatient.StopDate;
  SetDischargeEnableStatus(FPatient.DischargedFromClinic);
  case FPatient.Complexity of
    tpcStandard : rbStand.checked := true;
    tpcComplex  : rbComplex.Checked := true;
    tpcInactive : begin
                    rbStand.checked := false;
                    rbComplex.Checked := false;
                  end;
  end;  //case
  ckbNoStop.Checked := (FPatient.StopDate = 'Indefinite');
  edtDur.Text := FPatient.ExpectedTreatmentDuration;

  if FPatient.NewPatient then begin
    FPatient.StartDate         := piece(FPatient.PaddedNowDateStr,'@',1);
    FPatient.Orientation       := piece(FPatient.PaddedNowDateStr,'@',1);
    edtODate.Color             := clNeedsData;
    edtDur.Color               := clNeedsData;
    rbStand.Color              := clNeedsData;
    rbStand.Caption            := '* Standard';
    rbComplex.Color            := clNeedsData;
    rbComplex.Caption          := '* Complex';
    lblOrientationDate.Caption := '* ' + lblOrientationDate.Caption;
    lblOrientationDate.Left    := lblOrientationDate.Left - 7;
    lblDuration.Caption        := '* ' + lblDuration.Caption;
    lblDuration.Left           := lblDuration.Left - 7;
    btnSExit.Enabled           := false;
  end;

  rbComplex.Checked :=  (FPatient.Complexity = tpcComplex);
  rbStand.Checked := (FPatient.Complexity = tpcStandard);
  edtSDate.Text := FPatient.StartDate;
  edtODate.Text := FPatient.Orientation;

  for AWeekDay := dayMon to dayFri do begin
    RestrictDayCheckboxArray[AWeekDay].Checked := FPatient.DrawRestrictionsArray[AWeekDay];
  end;
  FPushingOutData := false;
end;

procedure TfrmPatientInformation.memPeopleChange(Sender: TObject);
begin
  FAppState.PeopleOKForMessageChanged := true;
end;

procedure TfrmPatientInformation.memPeopleExit(Sender: TObject);
begin
  FPatient.PersonsOKForMsgSL.Assign(memPeople.Lines);
end;

procedure TfrmPatientInformation.memRiskChange(Sender: TObject);
begin
  FAppState.RisksEdited := true;
end;

procedure TfrmPatientInformation.memRiskExit(Sender: TObject);
begin
  FPatient.RiskFactorsSL.Assign(memRisk.Lines);
end;

procedure TfrmPatientInformation.memSpecialInstructionsChange(Sender: TObject);
begin
  FAppState.SpecialInstructionsEdited := true;
end;

procedure TfrmPatientInformation.memSpecialInstructionsExit(Sender: TObject);
begin
  FPatient.SpecialInstructionsSL.Assign(memSpecialInstructions.lines);
end;

procedure TfrmPatientInformation.rbComplexClick(Sender: TObject);
begin
  if FPushingOutData then exit;
  if rbComplex.Checked then begin
    FPatient.Complexity := tpcComplex;
  end;
end;

procedure TfrmPatientInformation.rbStandClick(Sender: TObject);
begin
  if FPushingOutData then exit;
  if rbStand.Checked then begin
    FPatient.Complexity := tpcStandard;
  end;
end;

procedure TfrmPatientInformation.SetDischargeEnableStatus(Discharged : boolean);
const BUTTON_TEXT : array[false..true] of string = ('&Discharge from Clinic','&Undo Discharge');
begin
  edtStop.enabled               := Discharged;
  lblStop.Enabled               := Discharged;
  edtDur.enabled                := not Discharged;
  rbComplex.Enabled             := not Discharged; //will trigger event ?
  rbStand.Enabled               := not Discharged; //will trigger event ?
  rbStand.Checked               := not Discharged;
  edtStop.Enabled               := Discharged;
  edtStop.Color                 := IfThenColor(Discharged, clWindow, cl3dLight);
  edtStop.text                  := IfThenStr(Discharged, DateToStr(FPatient.DischargedDate), '');
  if Discharged then begin
    ckbNoStop.checked := false;
    rbComplex.Checked := false;
    FPatient.Complexity := tpcInactive;
  end else begin
    FPatient.Complexity := IfThenCpx(rbComplex.Checked, tpcComplex, tpcStandard);
  end;
  btnDischargeFromClinic.Caption := BUTTON_TEXT[Discharged];
end;


procedure TfrmPatientInformation.btnDischargeFromClinicClick(Sender: TObject);
var Discharged : boolean;
    frmDischargeInfo: TfrmDischargeInfo;
    TempAppState : TAppState;
    TempFlowsheet : TOneFlowsheet;

begin
  if not FPatient.DischargedFromClinic then begin
    frmDischargeInfo := TfrmDischargeInfo.Create(Self);
    TempAppState := TAppState.Create;
    TempFlowsheet := TOneFlowsheet.Create;
    try
      TempAppState.Assign(FAppState);
      TempFlowsheet.Assign(FFlowsheet);
      if frmDischargeInfo.ShowModal(TempAppState, FFlowsheet) = mrOK then begin
        Discharged := true;
        FAppState.Assign(TempAppState);
        FFlowsheet.Assign(TempFlowsheet);
      end;
    finally
      frmDischargeInfo.Free;
      TempFlowsheet.Free;
      TempAppState.Free;
    end;
  end else begin
    Discharged := false;
  end;
  FPatient.DischargedFromClinic := Discharged;
  SetDischargeEnableStatus(Discharged);
end;

procedure TfrmPatientInformation.btnEditBridgingCommentsClick(Sender: TObject);
var frmBridgeCommentDlg : TfrmBridgeCommentDlg;
begin
  frmBridgeCommentDlg := TfrmBridgeCommentDlg.Create(Self);
  try
    frmBridgeCommentDlg.memBridgeComments.Lines.Assign(FPatient.BridgingCommentsSL);
    if frmBridgeCommentDlg.ShowModal = mrOK then begin
      FPatient.BridgingCommentsSL.Assign(frmBridgeCommentDlg.memBridgeComments.Lines);
    end;
  finally
    frmBridgeCommentDlg.Free;
  end;
end;


procedure TfrmPatientInformation.btnSExitClick(Sender: TObject);
//kt note
{
 This functionality was to support button click from patient entry tab such
 that patient could be saved and the application exited immediately
 I don't know that I want to have multiple exit points from the application
 so I am going to leave out for right now.
}
//var
//  ListIdentified: String;
begin
  {
  if InfoBox('This will update heading information in the file and exit the program. No flow sheet entry will be made. OK?',
             'Update Preferences & Exit', MB_YESNO or MB_ICONQUESTION) = mrNo then begin
    exit;
  end else begin
    Patient.SaveToServer(AppState);

    //if pt. is being discharged from the clinic, remove pt. from current list
    if Patient.DischargedFromClinic then begin
      try
        ListIdentified := sCallV('ORAM1 TERASE', [Patient.DFN, Parameters.ListName]);
        if Piece(ListIdentified, '^', 1) = '0' then
        InfoBox(Piece(ListIdentified, '^', 2) + CRLF + 'Please notify your CAC.',
          'Clinic Parameter Undefined', MB_OK or MB_ICONWARNING);
      except
        Application.HandleException(Self)
      end;
    end;
    AbortExecution;
  end;
  }
end;

procedure TfrmPatientInformation.ckbAMmedsClick(Sender: TObject);
const
  AmPmLabel : array[false .. true] of tAMMeds = (tammPMMeds, tammAMMeds);
begin
  if FPushingOutData then exit;
  FPatient.AM_Meds := AmPmLabel[ckbAMmeds.Checked];
end;


procedure TfrmPatientInformation.ckbBridgingClick(Sender: TObject);
begin
  if not FPushingOutData then begin
    FPatient.Needs_LMWH_Bridging := ckbBridging.Checked;
  end;
  btnEditBridgingComments.Visible := FPatient.Needs_LMWH_Bridging or (FPatient.BridgingCommentsSL.Count > 0);
  if FPatient.Needs_LMWH_Bridging then begin
    if not FPushingOutData then
      btnEditBridgingCommentsClick(Sender);
  end else begin
    FPatient.BridgingCommentsSL.Clear;
  end;
end;

procedure TfrmPatientInformation.ckbIncludeRisksInNoteClick(Sender: TObject);
begin
  if FPushingOutData then exit;
  FAppState.IncludeRisksInNote := ckbIncludeRisksInNote.Checked;
end;

procedure TfrmPatientInformation.ckbMsgClick(Sender: TObject);
begin
  if FPushingOutData then exit;
  FPatient.MsgPhone := MSG_PHONE_VAL[ckbMsg.Checked];
end;

procedure TfrmPatientInformation.ckbNoStopClick(Sender: TObject);
const DATE_TEXT : array[false..true] of string = ('', 'Indefinite');
begin
  if FPushingOutData then exit;
  FPatient.StopDate := DATE_TEXT[ckbNoStop.Checked];
  edtStop.Text := FPatient.StopDate;
end;

procedure TfrmPatientInformation.ckbPmsgClick(Sender: TObject);
const
  SELECTED_COLOR : array [false..true] of TColor = (clMenu, clWindow);

begin
  if FPushingOutData then exit;
  memPeople.Enabled := ckbPmsg.checked;
  lblAllowedPersons.Enabled := ckbPmsg.checked;
  memPeople.ReadOnly := not ckbPmsg.checked;;
  memPeople.color := SELECTED_COLOR[ckbPmsg.checked];
  //if not ckbPmsg.checked then memPeople.Clear;
  if ckbPmsg.checked then begin
    if FPatient.PersonsOKForMsgSL.Count = 0 then begin
      InfoBox('Please enter person(s) allowed to take message',
              'Identify Person(s)', MB_OK or MB_ICONEXCLAMATION);
    end;
  end else begin
    FAppState.PeopleOKForMessageChanged := false;
  end;
end;

procedure TfrmPatientInformation.ckbRestrictDayClick(Sender: TObject);
var  AWeekDay : tDaysOfWeek;
begin
  if FPushingOutData then exit;
  for AWeekDay := dayMon to dayFri do begin
    FPatient.DrawRestrictionsArray[AWeekDay] := RestrictDayCheckboxArray[AWeekDay].Checked;
  end;
end;

procedure TfrmPatientInformation.ckbSAClick(Sender: TObject);
begin
  if FPushingOutData then exit;
  FPatient.SignedAgreement := ckbSA.Checked;
end;

procedure TfrmPatientInformation.edtDurChange(Sender: TObject);
begin
  if FPushingOutData then exit;
  FPatient.ExpectedTreatmentDuration := edtDur.Text;
end;

procedure TfrmPatientInformation.edtDurEnter(Sender: TObject);
begin
  edtDur.Color := clWindow;
end;

procedure TfrmPatientInformation.edtDurExit(Sender: TObject);
begin
  if FPatient.NewPatient and (edtDur.Text = '') then begin
    InfoBox('Duration is required for New Patients.' + CRLF +
            'Please enter valid number of days (or indefinite)...', 'Duration Required',
             MB_OK or MB_ICONEXCLAMATION);
    edtDur.SetFocus;
  end;
end;

procedure TfrmPatientInformation.edtDurKeyPress(Sender: TObject; var Key: Char);
var tl: string;
begin
  tl := IntToStr(Length(edtDur.Text) + 1);
  if StrToInt(tl) >= 30 then begin
    InfoBox('Reached character limit', 'Long Duration', MB_OK or MB_ICONEXCLAMATION);
    edtDur.Text := LeftStr(edtDur.text, 30);
  end;
end;

procedure TfrmPatientInformation.edtODateChange(Sender: TObject);
begin
  FPatient.Orientation := edtODate.Text;
end;

procedure TfrmPatientInformation.edtODateEnter(Sender: TObject);
begin
  edtODate.Color := clWindow;
end;

procedure TfrmPatientInformation.edtODateExit(Sender: TObject);
begin
  if (FPatient.NewPatient and (edtOdate.Text = '')) then begin
    InfoBox('Orientation Date is required for New Patients.' + CRLF +
            'Please choose a valid date...', 'Orientation Date Required',
             MB_OK or MB_ICONEXCLAMATION);
    edtOdate.SetFocus;
  end;
end;

procedure TfrmPatientInformation.edtSDateChange(Sender: TObject);
begin
  if FPushingOutData then exit;
  FPatient.StartDate := edtSDate.Text;
end;

procedure TfrmPatientInformation.edtSDateExit(Sender: TObject);
var tempDate : TDateTime;
begin
  edtSDate.Text := Trim(edtSDate.Text);
  tempDate := StrToDateTimeDef(edtSDate.Text, 0);
  if tempDate = 0 then begin
    InfoBox('You must supply a Start Date.' + CRLF +
            'Please enter valid date (or cancel)',
            'Invalid Date',
             MB_OK or MB_ICONEXCLAMATION);
    edtSDate.SetFocus;
  end else begin
    FPatient.StartDate := edtSDate.Text;
  end;
end;

procedure TfrmPatientInformation.edtStopChange(Sender: TObject);
begin
  FPatient.StopDate := edtStop.Text;
end;


procedure TfrmPatientInformation.FormCreate(Sender: TObject);
begin
  FAppState := TAppState.Create;  //owned here
  //FPatient := TPatient.Create ;  //owned by
  FPatient := FAppState.Patient;  //owned by FAppState, provided for convenience

  RestrictDayCheckboxArray[dayMon]  := ckbRM;
  RestrictDayCheckboxArray[dayTue]  := ckbRT;
  RestrictDayCheckboxArray[dayWed]  := ckbRW;
  RestrictDayCheckboxArray[dayThur] := ckbRTh;
  RestrictDayCheckboxArray[dayFri]  := ckbRF;
end;

procedure TfrmPatientInformation.FormDestroy(Sender: TObject);
begin
  FAppState.Free;
end;

function TfrmPatientInformation.ShowModal(AppState : TAppState; AFlowsheet : TOneFlowsheet) : integer;
// It might be that AFlowsheet is not the same as AppState.CurrentNewFlowsheet
begin
  FAppState.Assign(AppState);
  FPatient := FAppState.Patient;
  FFlowsheet := AFlowsheet;
  DataToGUI;
  Result := Self.ShowModal;
end;


end.
