unit fPCE_ACM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ORFn, {VA508AccessibilityManager,} ExtCtrls, mPCE_ACM,
  mVisitRelatedACM;

type
  TfrmPCE_ACM = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    pnlButtons: TPanel;
    pnlVisit: TPanel;
    fraVisitRelatedACM: TfraVisitRelatedACM;
    pnlForm: TPanel;
    memSvcConn: TMemo;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure memSvcConnEnter(Sender: TObject);
  private
    {private declarations}
  public
    procedure initialize(PtId, EncDt, EncLoc: string);
  end;

var
  //frmPCE_ACM: TfrmPCE_ACM;
  uPCEData: TPCEData;
  uSCCond: TSCConditions;

implementation

//uses VA508AccessibilityRouter;
{$R *.dfm}


procedure TfrmPCE_ACM.btnOKClick(Sender: TObject);
begin
  fraVisitRelatedACM.GetRelated(uPCEData);

  //Consider removing...
  //Check whether expected questions remained unanswered
  if uSCCond.SCAllow and (uPCEData.SCRelated = SCC_NA) then
  begin
    InfoBox('Need to choose Yes or No for Service Connected Condition to receive PCE credit.',
            'Service Connection Required', MB_OK or MB_ICONEXCLAMATION);
    ModalResult := mrRetry;
    exit;
  end;

  if uSCCond.AOAllow and (uPCEData.AORelated = SCC_NA) and
    not fraVisitRelatedACM.chkSCYes.Checked then
  begin
    InfoBox('Need to choose Yes or No for Agent Orange Exposure to receive PCE credit.',
            'Agent Orange Exposure Required', MB_OK or MB_ICONEXCLAMATION);
    ModalResult := mrRetry;
    exit;
  end;

  if uSCCond.IRAllow and (uPCEData.IRRelated = SCC_NA) and
    not fraVisitRelatedACM.chkSCYes.Checked then
  begin
    InfoBox('Need to choose Yes or No for Ionizing Radiation to receive PCE credit.',
            'Ionizing Radiation Required', MB_OK or MB_ICONEXCLAMATION);
    ModalResult := mrRetry;
    exit;
  end;

  if uSCCond.ECAllow and (uPCEData.ECRelated = SCC_NA) and
    not fraVisitRelatedACM.chkSCYes.Checked then
  begin
    InfoBox('Need to choose Yes or No for Southwest Asia Condition to receive PCE credit.',
            'Southwest Asia Condition Required', MB_OK or MB_ICONEXCLAMATION);
    ModalResult := mrRetry;
    exit;
  end;

  if uSCCond.MSTAllow and (uPCEData.MSTRelated = SCC_NA) then
  begin
    InfoBox('Need to choose Yes or No for MST to receive PCE credit.',
            'MST Required', MB_OK or MB_ICONEXCLAMATION);
    ModalResult := mrRetry;
    exit;
  end;

  if uSCCond.HNCAllow and (uPCEData.HNCRelated = SCC_NA) then
  begin
    InfoBox('Need to choose Yes or No for Head and/or Neck Cancer to receive PCE credit.',
            'Head and/or Neck Cancer Required', MB_OK or MB_ICONEXCLAMATION);
    ModalResult := mrRetry;
    exit;
  end;

  if uSCCond.CVAllow and (uPCEData.CVRelated = SCC_NA) then
  begin
    InfoBox('Need to choose Yes or No for Combat Veteran to receive PCE credit.',
            'Service Connection Required', MB_OK or MB_ICONEXCLAMATION);
    ModalResult := mrRetry;
    exit;
  end;

  if uSCCond.SHDAllow and (uPCEData.SHADRelated = SCC_NA) and
    not fraVisitRelatedACM.chkSCYes.Checked then
  begin
    InfoBox('Need to choose Yes or No for Shipboard Hazard and Defence to receive PCE credit.',
            'Shipboard Hazard and Defence Required', MB_OK or MB_ICONEXCLAMATION);
    ModalResult := mrRetry;
    exit;
  end;

end;

procedure TfrmPCE_ACM.FormShow(Sender: TObject);
begin
  {
  if ScreenReaderSystemActive then
  begin
    memSvcConn.SetFocus;
  end
  else
  }
    fraVisitRelatedACM.SetFocus;
end;

procedure TfrmPCE_ACM.initialize(PtId, EncDt, EncLoc: string);
begin
  memSvcConn.Lines.Clear;
  Disabilities(memSvcConn.Lines, PtId);
  uSCCond := EligibleConditions(PtId, EncDt, EncLoc);
  fraVisitRelatedACM.InitAllow(uSCCond);
  fraVisitRelatedACM.InitRelated(uPCEData);
end;

procedure TfrmPCE_ACM.memSvcConnEnter(Sender: TObject);
begin
  memSvcConn.SelStart := 0;
end;

initialization
  uPCEData := TPCEData.Create;

finalization
  uPCEData.Free;  //kt added

end.
