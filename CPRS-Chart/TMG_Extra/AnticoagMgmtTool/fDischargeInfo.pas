unit fDischargeInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics,
  Forms, Dialogs,
  uTypesACM, uFlowsheet, uUtility,
  StdCtrls, Buttons, ComCtrls, Controls, Classes;

type
  TfrmDischargeInfo = class(TForm)
    ckbPtMovedAway: TCheckBox;
    edtPtMovedAway: TEdit;
    ckbPtViolatedAgreement: TCheckBox;
    ckbPtDC: TCheckBox;
    dtpDC: TDateTimePicker;
    lblDCFor: TLabel;
    edtDCReason: TEdit;
    btnCancel: TBitBtn;
    btnDone: TBitBtn;
    lblDischargeDate: TLabel;
    procedure ckbPtMovedAwayClick(Sender: TObject);
    procedure edtPtMovedAwayChange(Sender: TObject);
    procedure dtpDCChange(Sender: TObject);
    procedure edtDCReasonChange(Sender: TObject);
    procedure ckbPtViolatedAgreementClick(Sender: TObject);
    procedure ckbPtDCClick(Sender: TObject);
  private
    { Private declarations }
    FAppState : TAppState;
    FFlowsheet : TOneFlowsheet;
    FPatient : TPatient;         //for convenience
    FPushingOutData : boolean;
    procedure PullDCInfo;
    procedure DataToGUI;
  public
    { Public declarations }
    function ShowModal(AppState : TAppState; AFlowsheet : TOneFlowsheet) : integer; overload;
  end;

//var
//  frmDischargeInfo: TfrmDischargeInfo;

implementation

{$R *.dfm}

procedure TfrmDischargeInfo.ckbPtDCClick(Sender: TObject);
begin
  if FPushingOutData then exit;
  lblDCFor.Enabled := ckbPtDC.Checked;
  edtDCReason.Enabled := ckbPtDC.Checked;
  if not ckbPtDC.Checked then edtDCReason.Text := '';
  PullDCInfo;
end;

procedure TfrmDischargeInfo.ckbPtMovedAwayClick(Sender: TObject);
begin
  if FPushingOutData then exit;
  edtPtMovedAway.Enabled := ckbPtMovedAway.Checked;
  if ckbPtMovedAway.Checked and not ckbPtDC.checked then begin
    FPushingOutData := true;
    if edtDCReason.Text = '' then edtDCReason.Text := 'Moved away';
    ckbPtDC.Checked := true;
    FPushingOutData := false;
  end;
  PullDCInfo;
end;

procedure TfrmDischargeInfo.edtDCReasonChange(Sender: TObject);
begin
  if FPushingOutData then exit;
  PullDCInfo;
end;

procedure TfrmDischargeInfo.edtPtMovedAwayChange(Sender: TObject);
begin
  if FPushingOutData then exit;
  PullDCInfo;
end;

procedure TfrmDischargeInfo.PullDCInfo;
begin
  FFlowsheet.DocsPtMoved      := ckbPtMovedAway.Checked;
  FFlowsheet.DocsPtTransferTo := IfThenStr(edtPtMovedAway.Enabled, edtPtMovedAway.Text, '');
  FPatient.ViolatedAgreement  := ckbPtViolatedAgreement.Checked;
  FPatient.DischargedReason   := edtDCReason.Text;
  FPatient.DischargedDate     := dtpDC.DateTime;
  FPatient.DischargedReason   := IfThenStr(ckbPtDC.Checked, edtDCReason.Text, '');
end;

function TfrmDischargeInfo.ShowModal(AppState : TAppState; AFlowsheet : TOneFlowsheet) : integer;
// It might be that AFlowsheet is not the same as AppState.CurrentNewFlowsheet
begin
  FAppState := AppState;
  FFlowsheet := AFlowsheet;
  FPatient := AppState.Patient;
  DataToGUI;
  Result := Self.ShowModal;
end;

procedure TfrmDischargeInfo.ckbPtViolatedAgreementClick(Sender: TObject);
begin
  if FPushingOutData then exit;
  PullDCInfo;
end;

procedure TfrmDischargeInfo.DataToGUI;
const
  MEDS_CHANGED_INDEX : array[false..true] of integer = (1, 0);
begin
  FPushingOutData := true;

  ckbPtMovedAway.Checked := FFlowsheet.DocsPtMoved;
  edtPtMovedAway.Text := FFlowsheet.DocsPtTransferTo;
  edtPtMovedAway.Enabled := FFlowsheet.DocsPtMoved;
  ckbPtViolatedAgreement.Checked := FPatient.ViolatedAgreement;
  dtpDC.DateTime := IfThenDT(FPatient.DischargedDate <> 0, FPatient.DischargedDate, Now);
  edtDCReason.Text := FPatient.DischargedReason;

  FPushingOutData := false;
end;

procedure TfrmDischargeInfo.dtpDCChange(Sender: TObject);
begin
  if FPushingOutData then exit;
  FPatient.DischargedDate := dtpDC.DateTime;
end;


end.
