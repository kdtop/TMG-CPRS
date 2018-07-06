unit fOutsideLab;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics,
  uTypesACM, uUtility, uFlowsheet, ORFn, uPastINRs,
  Forms, Dialogs,   
  ComCtrls, StdCtrls, Buttons, ExtCtrls, Controls, Classes;

type
  TfrmOutsideLab = class(TForm)
    gbxINREnter: TGroupBox;
    lblNewINR: TLabel;
    lblLabLoc: TLabel;
    lblStandingOrderExp: TLabel;
    lblLabPhone: TLabel;
    lblLabFax: TLabel;
    lblNewHCT: TLabel;
    lblOptionalLabPhone: TLabel;
    lblOptionalLabFax: TLabel;
    Label2: TLabel;
    edtNewInr: TEdit;
    edtLoc: TEdit;
    btnClearOutsideLab: TButton;
    dtpLabOrderExpiration: TDateTimePicker;
    edtLFax: TEdit;
    edtLPhone: TEdit;
    edtNewHctOrHgb: TEdit;
    pnlFee: TPanel;
    lblFeeBasis: TLabel;
    lblexp: TLabel;
    rbFeeNo: TRadioButton;
    rbFeePrim: TRadioButton;
    rbFeeSec: TRadioButton;
    dtpExp: TDateTimePicker;
    btnOK: TBitBtn;
    ckbHistorical: TCheckBox;
    btnCancel: TBitBtn;
    pnlDatePanel: TPanel;
    lblINRDate: TLabel;
    dtpINR: TDateTimePicker;
    procedure OutsideLabDataChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ckbHistoricalClick(Sender: TObject);
    procedure dtpChange(Sender: TObject);
    procedure btnClearOutsideLabClick(Sender: TObject);
    procedure edtNewInrChange(Sender: TObject);
    procedure edtNewHctOrHgbChange(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
    procedure edtLPhoneChange(Sender: TObject);
    procedure edtLFaxChange(Sender: TObject);
    procedure rbFeeNoClick(Sender: TObject);
    procedure rbFeePrimClick(Sender: TObject);
    procedure rbFeeSecClick(Sender: TObject);
    procedure dtpLabOrderExpirationChange(Sender: TObject);
    procedure dtpExpChange(Sender: TObject);
  private
    { Private declarations }
    FLocalFlowsheet: TOneFlowsheet;
    FLocalPatient : TPatient;
    FHistorical : boolean;
    FMostRecentINR : TOnePastINRValue; //not owned here
    //FFeeBasis : tFeeBasis;
    FWantOldINR : boolean;
    FPushingDataToForm : boolean;
    function CheckSetdtpINRValidity : boolean;
    function CheckSetINRValueValidity : boolean;
    function CheckSetHgbHctValueValidity : boolean;
    function CheckEdtLocValidity : boolean;
    procedure EnableChildControls(Control: TWinControl; Enable: Boolean);
    procedure SetDefaultOutsideLabInfo(Flowsheet : TOneFlowsheet); //kt
    procedure InitGUI2Default;
    procedure FeeBasisChanged();
    procedure LoadLabInfo();
    //function GetStandingLabOrderExpirationDate : TDateTime;
    //function GetFeeBasisExpiration : TDateTime;
  public
    { Public declarations }
    function ShowModal(AFlowsheet : TOneFlowsheet;
                       AppState : TAppState;
                       Patient : TPatient) : integer; overload;
    property Flowsheet : TOneFlowsheet read FLocalFlowsheet;
    property Patient : TPatient read FLocalPatient;
    property Historical : boolean read FHistorical;
    //property FeeBasis : tFeeBasis read FFeeBasis;
    //property FeeBasisExpiration : TDateTime read GetFeeBasisExpiration;
    //property StandingLabOrderExpirationDate : TDateTime read GetStandingLabOrderExpirationDate;
  end;

//var
//  frmOutsideLab: TfrmOutsideLab;

implementation

{$R *.dfm}

procedure TfrmOutsideLab.FormCreate(Sender: TObject);
begin
  FLocalFlowsheet:= TOneFlowsheet.Create;
  FLocalPatient := TPatient.Create;
  InitGUI2Default;
  //FFeeBasis := tfbNo;
  FWantOldINR := false;
end;

procedure TfrmOutsideLab.FormDestroy(Sender: TObject);
begin
  FLocalFlowsheet.Free;
  FLocalPatient.Free;
end;

procedure TfrmOutsideLab.InitGUI2Default;
begin
  edtNewInr.Text := '';        edtNewInrChange(self);
  edtNewHctOrHgb.Text := '';   edtNewHctOrHgbChange(self);
  SetDefaultOutsideLabInfo(FLocalFlowsheet);
  LoadLabInfo();
  OutsideLabDataChange(self);
end;


function TfrmOutsideLab.CheckSetdtpINRValidity : boolean;
var Valid : boolean;
const
  DATE_PANEL_COLOR : array[false..true] of TColor = (clLightRed, clBtnFace);

begin
  Valid := not IsFutureDate(dtpINR.DateTime);
  dtpINR.Color := VALID_COLOR[Valid];
  pnlDatePanel.Color := DATE_PANEL_COLOR[Valid];
  result := Valid;
end;

function TfrmOutsideLab.CheckSetINRValueValidity : boolean;
var Value : string;
    Valid : boolean;
begin
  Value := Trim(edtNewHctOrHgb.Text);
  if Value <> '' then begin
    Valid := (StrToFloatDef(Value, -1) > 0);
  end else begin
    Valid := true;
  end;
  edtNewHctOrHgb.Color := VALID_COLOR[Valid];
  Result := Valid;
end;

procedure TfrmOutsideLab.ckbHistoricalClick(Sender: TObject);
begin
  if FPushingDataToForm then exit;
  FHistorical := ckbHistorical.Checked;
  if not ckbHistorical.Checked then exit;
  if InfoBox('Flow sheet data will be for a past INR. ' + CRLF +
             'All information will refer to that past INR.' + CRLF +
             'No PCE data will be sent.', 'Past INR',
              MB_OKCANCEL or MB_ICONINFORMATION) <> mrOK then begin
    ckbHistorical.Checked := false;
    FHistorical := false;
  end;
end;

function TfrmOutsideLab.CheckSetHgbHctValueValidity : boolean;
//kt added
var Value : string;
    Valid : boolean;
begin
  Value := edtNewINR.Text;
  Valid := (StrToFloatDef(Value, -1) > 0);
  edtNewINR.Color := VALID_COLOR[Valid];
  Result := Valid;
end;

procedure TfrmOutsideLab.EnableChildControls(Control: TWinControl; Enable: Boolean);
var i: Integer;
begin
  with Control do begin
    //Enable/Disable Child Controls
    for i := 0 to ControlCount - 1 do begin
      Controls[i].Enabled := Enable;
    end;
    //finally, toggle the Enabled property of Control itself
    Enabled := Enable;
  end;
end;

procedure TfrmOutsideLab.btnClearOutsideLabClick(Sender: TObject);
begin
  //kt did major changes here, old stuff not kept.
  if InfoBox('Cancel outside INR data?',
          'Update Cancelled', MB_YESNO or MB_ICONQUESTION) <> mrYes then exit;
  InitGUI2Default;
  //AppState.OutsideLabDataEntered := false;
  OutsideLabDataChange(Sender);
  btnOK.Enabled := true;
end;

procedure TfrmOutsideLab.SetDefaultOutsideLabInfo(Flowsheet : TOneFlowsheet); //kt
//kt added
//TO DO, make into parameters.
begin
  Flowsheet.LabDrawLoc := 'Family Physicians of Greeneville';
  Flowsheet.LabDrawPhone := '(423) 787-7000';
  Flowsheet.LabDrawFax := '(423) 787-7049';
end;

function TfrmOutsideLab.CheckEdtLocValidity : boolean;
//kt added
var Valid : boolean;
begin
  Valid := Trim(edtLoc.Text) <> '';
  edtLoc.Color := VALID_COLOR[Valid];
  Result := Valid;
end;

procedure TfrmOutsideLab.dtpChange(Sender: TObject);
var DateInPast : boolean;
begin
  FLocalFlowsheet.INRLabDateTime := dtpINR.DateTime;
  DateInPast := (DateCompare(dtpINR.DateTime, Now) = tdcSecondLater);
  if not DateInPast then ckbHistorical.Checked := false;
  ckbHistorical.Visible := DateInPast;
  OutsideLabDataChange(Sender);
end;


procedure TfrmOutsideLab.dtpExpChange(Sender: TObject);
begin
  FLocalPatient.FeeBasisExpiration := dtpExp.DateTime;
end;

procedure TfrmOutsideLab.dtpLabOrderExpirationChange(Sender: TObject);
begin
  FLocalPatient.StandingLabOrderExpirationDate := dtpLabOrderExpiration.DateTime;
end;

procedure TfrmOutsideLab.edtLFaxChange(Sender: TObject);
begin
  FLocalFlowsheet.LabDrawFax := edtLFax.Text;
  OutsideLabDataChange(Sender);
end;

procedure TfrmOutsideLab.edtLocChange(Sender: TObject);
begin
  if FPushingDataToForm then exit;
  FLocalFlowsheet.LabDrawLoc := edtLoc.Text;
  OutsideLabDataChange(Sender);
end;

procedure TfrmOutsideLab.edtLPhoneChange(Sender: TObject);
begin
  if FPushingDataToForm then exit;
  FLocalFlowsheet.LabDrawPhone := edtLPhone.Text;
  OutsideLabDataChange(Sender);
end;

procedure TfrmOutsideLab.edtNewHctOrHgbChange(Sender: TObject);
begin
  if FPushingDataToForm then exit;
  FLocalFlowsheet.HctOrHgbValue := Trim(edtNewHctOrHgb.Text);
  OutsideLabDataChange(Sender);
end;

procedure TfrmOutsideLab.edtNewInrChange(Sender: TObject);
begin
  if FPushingDataToForm then exit;
  FLocalFlowsheet.INR := Trim(edtNewINR.Text);
  OutsideLabDataChange(sender);
  FLocalFlowsheet.NewINREntered := (FLocalFlowsheet.INR <> '');
end;

procedure TfrmOutsideLab.OutsideLabDataChange(Sender: TObject);
var V1, V2, v3, V4 : boolean;
begin
  V1 := CheckSetdtpINRValidity;
  V2 := CheckSetHgbHctValueValidity;
  V3 := CheckSetINRValueValidity;
  V4 := CheckEdtLocValidity;
  btnOK.Enabled := V1 and V2 and V3 and V4;

  //NOTE: for new patient 'FMostRecentINR.DateTime' is nil
  if not FWantOldINR
    and (edtNewINR.Text <> '')
    and assigned(FMostRecentINR)
    and (DateCompare(dtpINR.Date, FMostRecentINR.DateTime) = tdcSecondLater) then begin
    if InfoBox('More recent INR already recorded for this patient.' + CRLF +
               'do you want to replace it?', 'Newer INR Available',
                MB_YESNO or MB_ICONQUESTION) = mrYes then begin
      FWantOldINR := true;
    end else begin
      edtNewINR.Text := ''; //should trigger event.
    end;
  end;
end;

procedure TfrmOutsideLab.FeeBasisChanged();
var visible : boolean;
begin
  visible := (FLocalPatient.FeeBasis <> tfbNo);
  lblexp.Visible := visible;
  dtpExp.Visible := visible;
end;

procedure TfrmOutsideLab.rbFeeNoClick(Sender: TObject);
begin
  if FPushingDataToForm then exit;
  FLocalPatient.FeeBasis := tfbNo;
  FeeBasisChanged;
end;

procedure TfrmOutsideLab.rbFeePrimClick(Sender: TObject);
begin
  if FPushingDataToForm then exit;
  FLocalPatient.FeeBasis := tfbPrimary;
  FeeBasisChanged;
end;

procedure TfrmOutsideLab.rbFeeSecClick(Sender: TObject);
begin
  if FPushingDataToForm then exit;
  FLocalPatient.FeeBasis := tfbSecondary;
  FeeBasisChanged;
end;

{
function TfrmOutsideLab.GetStandingLabOrderExpirationDate : TDateTime;
begin
  Result := dtpLabOrderExpiration.DateTime;
end;
}
{
function TfrmOutsideLab.GetFeeBasisExpiration : TDateTime;
begin
  Result := dtpExp.DateTime;
end;
}

procedure TfrmOutsideLab.LoadLabInfo();
begin
  edtLoc.Text    := FLocalFlowsheet.LabDrawLoc;
  edtLPhone.Text := FLocalFlowsheet.LabDrawPhone;
  edtLFax.Text   := FLocalFlowsheet.LabDrawFax;
end;


function TfrmOutsideLab.ShowModal(AFlowsheet : TOneFlowsheet;
                                  AppState : TAppState;
                                  Patient : TPatient                 ) : integer;
begin
  FLocalFlowsheet.Assign(AFlowsheet);
  FLocalPatient.Assign(Patient);

  FPushingDataToForm := true;

  rbFeeNo.Checked   := (FLocalPatient.FeeBasis = tfbNo);
  rbFeePrim.Checked := (FLocalPatient.FeeBasis = tfbPrimary);
  rbFeeSec.Checked  := (FLocalPatient.FeeBasis = tfbSecondary);
  dtpExp.DateTime   := IfThenDT(FLocalPatient.FeeBasisExpiration>0, FLocalPatient.FeeBasisExpiration, Now);
  FeeBasisChanged;

  ckbHistorical.Checked := AppState.Historical;
  ckbHistorical.Visible := AppState.Historical;
  FMostRecentINR := AppState.PastINRValues.MostRecent;
  //if Flowsheet.LabDrawLoc = '' then SetDefaultOutsideLabInfo(Flowsheet);
  SetDefaultOutsideLabInfo(FLocalFlowsheet);
  LoadLabInfo();

  if AppState.OutsideLabDataEntered then begin
    edtNewINR.Text := FLocalFlowsheet.INR;
    edtNewHctOrHgb.Text := FLocalFlowsheet.HctOrHgbValue;
    ckbHistorical.Checked := AppState.Historical;
  end else begin
    FLocalFlowsheet.INRLabDateTime := Now;
  end;
  dtpINR.DateTime := FLocalFlowsheet.INRLabDateTime;
  dtpLabOrderExpiration.DateTime := IfThenDT(FLocalPatient.StandingLabOrderExpirationDate>0, FLocalPatient.StandingLabOrderExpirationDate, Now);
  FPushingDataToForm := false;
  OutsideLabDataChange(Self);
  //--------------------------------
  Result := ShowModal;
end;


end.
