unit fStartAnticoagMgmt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, grids,
  StdCtrls, StrUtils, Math, DateUtils,
  ORCtrls, ORFn, ORNet, Trpcb,
  rRPCsACM, uTypesACM,
  uHTMLTools, TMGHTML2, ComCtrls, ExtCtrls;


type
  TfrmStartAnticoagationManagement = class(TForm)
    pnlBottom: TPanel;
    lblDCSign: TLabel;
    edtSigDC: TEdit;
    btnEditNote: TButton;
    btnDCsign: TButton;
    btnCancel: TButton;
    pnlTop: TPanel;
    ckbPMove: TCheckBox;
    edtPMove: TEdit;
    ckbPViol: TCheckBox;
    ckbPtDC: TCheckBox;
    ckbOther: TCheckBox;
    edtPDC: TEdit;
    lblDCOn: TLabel;
    dtpDC: TDateTimePicker;
    lblDCFor: TLabel;
    pnlHTMLObjHolder: TPanel;
    procedure btnDCsignClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FAppState : TAppState;
  public
    { Public declarations }
    HtmlEditor : THtmlObj;
    function ShowModal(AppState : TAppState) : integer; overload;
  end;

//var
//  frmStartAnticoagationManagement: TfrmStartAnticoagationManagement;

implementation

{$R *.dfm}

function TfrmStartAnticoagationManagement.ShowModal(AppState : TAppState) : integer;
begin
  FAppState := AppState;
  Result := Self.ShowModal;
end;


procedure TfrmStartAnticoagationManagement.btnDCsignClick(Sender: TObject);
//var
//  s: Integer;
//  TempStr: String;
begin
{
  if btnDCsign.Caption = '&Sign Note' then
  begin
    lblDCSign.Visible := true;
    edtSigDC.Visible := true;
    edtSigDC.SetFocus;
    btnDCsign.Caption := '&Submit Note';
    //ktAccessibilityManager.AccessText[btnDCsign] := 'Click to submit the changes to the Progress Note.';
  end
  else if btnDCsign.Caption = '&Submit Note' then
  begin
    TempStr := sCallV('ORAM SIGCHECK',[edtSigDC.Text]);
    if (TempStr <> '1') and (edtSigDC.Text <> '') then
    begin
      InfoBox('Please retype your signature code',
              'Invalid Signature Code', MB_OK or MB_ICONEXCLAMATION);
      edtSigDC.Text := '';
      edtSigDC.SetFocus;
      exit;
    end
    else
    begin
      if edtSigDC.Text = '' then begin
        if (InfoBox('Would you like to save your note without signing?',
                    'Save Without Signature?', MB_YESNO or MB_ICONQUESTION) = mrNo) then
        begin
          edtSigDC.Text := '';
          edtSigDC.SetFocus;
          exit;
        end;
      end;
      edtSigDC.Visible := false;
      lblDCSign.Visible := false;
      SetEClinic;

      NoteNumber := MakeNote(PDFN, FTitle, EClinic, VisitDate, SvcCat, Lines);

      cofactor := 1;
      Cosigner(FTitle); //COSIGN CHECK   if CS = 1 then needs cosigner
      if FTitle = DischargeNote  then
        ckbDC.Checked := true;
      gbxDC.Visible := false;
      btnIntakeNote.Enabled := false;
      btnInterimNote.Enabled := false;
      btnDCstart.Enabled := false;
    end;  // good sig
    ToggleExitVisible(ReturnFocus);
  end; // but is submit now
  btnComp.SetFocus;
  }
end;



procedure TfrmStartAnticoagationManagement.FormCreate(Sender: TObject);
begin
  HtmlEditor := THtmlObj.Create(pnlHTMLObjHolder, Application);
  TWinControl(HtmlEditor).Parent:= pnlHTMLObjHolder;
  TWinControl(HtmlEditor).Align:=alClient;
  HtmlEditor.Loaded();
  HtmlEditor.HTMLText := '<p>';
  HtmlEditor.Editable := False;
end;

procedure TfrmStartAnticoagationManagement.FormDestroy(Sender: TObject);
begin
  HtmlEditor.Free;
end;


end.
