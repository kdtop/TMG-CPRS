unit fEndAnticoagMgmt;
//DEPRECIATED... DELETE LATER

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, grids,
  StdCtrls, StrUtils, Math, DateUtils, rRPCsACM, fCosign,
  ORCtrls, ORFn, ORNet, Trpcb, uTypesACM, {VA508AccessibilityManager,}
  uHTMLTools, TMGHTML2, ComCtrls, ExtCtrls;

type
  TfrmEndAnticoagationManagement = class(TForm)
    pnlBottom: TPanel;
    pnlHTMLObjHolder: TPanel;
    procedure btnDCsignClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    dcexit: Integer;  //kt moved here
    FPatient : TPatient;
    FParameters : TParameters;
    FProvider : TProvider;
    HtmlEditor : THtmlObj;
    FAppState : TAppState; //owned elsewhere.  Copy of pointer, not original object
  public
    { Public declarations }
    function ShowModal(AppState : TAppState) : integer;  overload;
  end;

//var
//  frmEndAnticoagationManagement: TfrmEndAnticoagationManagement;

implementation

{$R *.dfm}

function TfrmEndAnticoagationManagement.ShowModal(AppState : TAppState) : integer;
begin
  FPatient := AppState.Patient;
  FProvider := AppState.Provider;
  FParameters := AppState.Parameters;
  FAppState := AppState;
  Result := ShowModal;
end;

procedure TfrmEndAnticoagationManagement.btnDCsignClick(Sender: TObject);
//var
  //s: Integer;
  //TempStr: String;
  //Lines : TStringList;
begin
  {
  if btnDCsign.Caption = '&Sign Note' then begin
    lblDCSign.Visible := true;
    edtSigDC.Visible := true;
    edtSigDC.SetFocus;
    btnDCsign.Caption := '&Submit Note';
    FAppState.AccessibilityManager.AccessText[btnDCsign] := 'Click to submit the changes to the Progress Note.';
  end else if btnDCsign.Caption = '&Submit Note' then begin
    TempStr := sCallV('ORAM SIGCHECK',[edtSigDC.Text]);
    if (TempStr <> '1') and (edtSigDC.Text <> '') then begin
      InfoBox('Please retype your signature code',
              'Invalid Signature Code', MB_OK or MB_ICONEXCLAMATION);
      edtSigDC.Text := '';
      edtSigDC.SetFocus;
      exit;
    end else begin
      if edtSigDC.Text = '' then begin
        if (InfoBox('Would you like to save your note without signing?',
                    'Save Without Signature?', MB_YESNO or MB_ICONQUESTION) = mrNo) then begin
          edtSigDC.Text := '';
          edtSigDC.SetFocus;
          exit;
        end;
      end;
      if FAppState.FTitle = FParameters.DischargeNote then begin
        if InfoBox('Sending a Discharge note will also inactivate patient from anticoagulation clinic.  Send Note?',
                   'Confirm Discharge', MB_YESNO or MB_ICONQUESTION) = mrNo then
          exit;
        //kt replace later --> if dcexit <> 1 then btnDC.Click;
      end;
      edtSigDC.Visible := false;
      lblDCSign.Visible := false;

      Lines := TStringList.Create;
      Lines.Text := HtmlEditor.GetFullHTMLText;
      //Fix Later -- probably need uHTMLUtils to make into short lines....
      FAppState.NoteIEN := MakeNote(FAppState, Lines);
      Lines.Free;

      if CosignerNeeded(tcfNote, FAppState, FAppState.FTitle) then begin
        //What is supposed to be done here?
        //A cosign, but needs to be implemented.  Fix Later
      end;
    end;  // good sig
    //kt ToggleExitVisible(ReturnFocus);
  end; // but is submit now
  }
end;

{
procedure TfrmAnticoagulate.btnDCClick(Sender: TObject);
var
  r:Integer;
begin
  edtSigDC.Visible := false;
  lblDCSign.Visible := false;
  pnlDCsign.Align := alBottom;
  if btnDC.Caption = '&Cancel' then
  begin
    memDCnote.Clear;
    dcexit := 0;
    pnlDCedt.Visible := false;
    btnDC.Caption := '&View/Edit';
    AccessibilityManager.AccessText[btnDC] := 'Click to view and edit Progress Note.';
    btnDCsign.Caption := '&Sign Note';
    AccessibilityManager.AccessText[btnDCsign] := 'Click to apply your electronic signature to the Progress Note.';
    gbxDC.Visible := false;
    edtSigDC.Visible := true;
    lblDCSign.Visible := true;
    ToggleExitVisible(ReturnFocus);
    (ReturnFocus as TButton).SetFocus;
  end
  else
  begin
    if ckbPMove.Checked = true then
    begin
      if edtPMove.Text = '' then
      begin
        InfoBox('Please indicate where anticoagulation management will be transferred to.',
                'Destination Needed', MB_OK or MB_ICONEXCLAMATION);
        edtPMove.SetFocus;
        exit;
      end
      else
      begin
        DCNote := 'Patient has moved from the ' + SiteName + ' service area and will '+
                  'be transferring anticoagulation management to ' + edtPMove.text;
      end;
    end //if PMOVE checked
    else if ckbPViol.Checked = true then
      DCNote := 'Patient has not maintained conditions of Anticoagulation Treatment Agreement.  '+
                'He/she has been notified that they have been discharged from this clinic, '+
                'and will no longer receive warfarin from this facility.'
    else if ckbPtDC.Checked = true then
    begin
      if ((edtPDC.text = '') or (memDC.Lines.Count = 0)) then
      begin
        InfoBox('Please add required information',
                'Required Information Needed', MB_OK or MB_ICONEXCLAMATION);
        exit;
      end
      else
      begin
        reason := '';
        for r := 0 to memDC.lines.Count - 1 do
          reason := reason + #13#10 + memDC.lines[r];
        DCNote := 'Anticoagulation discontinued on ' + DateToStr(dtpDC.DateTime) + ' by ' +
                  edtPDC.text + ' for the following reason: ' + reason + #13#10;
      end;
    end  // PtDC checked
    else if ckbOther.Checked = true then
    begin
      DCNote := 'Patient discharged from Anticoagulation Clinic for the following reason(s): ' + #13#10;
      InfoBox('Please add discharge reason to note.', 'Discharge Reason Needed',
               MB_OK or MB_ICONEXCLAMATION);
    end
    else
    begin
      InfoBox('Must check one of the options.', 'Information Required', MB_OK or MB_ICONEXCLAMATION);
      btnDC.Caption := '&View/Edit';
      AccessibilityManager.AccessText[btnDC] := 'Click to view and edit Progress Note.';
      btnDCsign.Caption := '&Sign Note';
      AccessibilityManager.AccessText[btnDCsign] := 'Click to apply your electronic signature to the Progress Note.';
      lblDCSign.Visible := false;
      edtSigDC.Visible := false;
      exit;
    end;
    lblNBox.Caption := 'Anticoag Discharge Note:';
    pnlDCedt.Visible := true;
    pnlDCTop.Visible := false;
    btnDCGClose.Visible := false;
    btnCloseGbxDC.Visible := false; //kt added 12/17
    edtSigDC.Visible := true;
    lblDCSign.Visible := true;
    pnldcedt.Height := pnlDCsign.top - 10;
    btnDC.caption := '&Cancel';
    AccessibilityManager.AccessText[btnDC] := 'Click to discard changes to Progress Note.';
    btnDCsign.Enabled := TRUE;
    memDCnote.Lines[0] := DCNote;
    //kt 12/17 memDCnote.SetFocus;
    HtmlDCNote.SetFocus;   //kt 12/17
    if ScreenReaderSystemActive then
      memDCnote.SelStart := 0;
    dcexit := 1;
  end;
end;

}


procedure TfrmEndAnticoagationManagement.FormCreate(Sender: TObject);
begin
  HtmlEditor := THtmlObj.Create(pnlHTMLObjHolder, Application);
  TWinControl(HtmlEditor).Parent:= pnlHTMLObjHolder;
  TWinControl(HtmlEditor).Align:=alClient;
  HtmlEditor.Loaded();
  HtmlEditor.HTMLText := '<p>';
  HtmlEditor.Editable := False;
  dcexit := 0; //kt added to keep functionality the same
end;

procedure TfrmEndAnticoagationManagement.FormDestroy(Sender: TObject);
begin
  HtmlEditor.Free;
end;

end.
