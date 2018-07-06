unit fCompletedVisitNote;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, uFlowsheet,
  ORCtrls, ORFn, ORNet, Trpcb, StrUtils,
  uTypesACM, uHTMLTools, TMGHTML2, Buttons;

type

  TfrmCompletedVisitNote = class(TForm)
    pnlBottom: TPanel;
    btnCancel: TBitBtn;
    btnDone: TBitBtn;
    pnlHTMLObjHolder: TPanel;
    pnlTop: TPanel;
    cboNoteType: TComboBox;
    lblNoteType: TLabel;
    ckbPrintAfterSig: TCheckBox;
    lblTemplateNameLabel: TLabel;
    lblTemplateName: TLabel;
    ckbNoNoteSave: TCheckBox;
    btnPrint: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure cboNoteTypeChange(Sender: TObject);
    procedure ckbNoNoteSaveClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    FAppState : TAppState;       //Owned here.
    FFlowsheet : TOneFlowsheet;  //Owned here.  May be different from FAppState.CurrentFlowsheet.
    FPushingOutData : boolean;
    TemplateNames : TStringList;
    NoteTemplateIENs : TStringList;
    NoteTitleIENs : TStringList;
    function GetTemplateIEN : string;
    function GetTemplateName : string;
    function GetNoteTitleIEN : string;
    function GetNoNoteSave : boolean;
    procedure Initialize;
  public
    { Public declarations }
    HtmlEditor : THtmlObj;
    function ShowModal(AppState : TAppState; AFlowsheet : TOneFlowsheet) : integer; overload;
    function MakeAndSaveTIUNote(Var ErrMsg : string) : boolean; //kt
    property ModifiedAppState : TAppState read FAppState;
    property ModifiedFlowsheet : TOneFlowsheet read FFlowsheet;
    property SelectedTemplateIEN : string read GetTemplateIEN;
    property SelectedTemplateName : string read GetTemplateName;
    property SelectedNoteTitleIEN : string read GetNoteTitleIEN;
    property NoNoteSave : boolean read GetNoNoteSave;
  end;

//var
//  frmCompletedVisitLetter: TfrmCompletedVisitLetter;

implementation

{$R *.dfm}

uses uTMGMods,
     uUtility,
     fCosign,
     rRPCsACM,
     fSignItemACM,
     fCompleteConsult;



function TfrmCompletedVisitNote.GetTemplateIEN : string;
var Idx : integer;
begin
  Idx := cboNoteType.ItemIndex;
  result := IfThen(Idx >= 0, NoteTemplateIENs[Idx], '');
end;

function TfrmCompletedVisitNote.GetTemplateName : string;
var Idx : integer;
begin
  Idx := cboNoteType.ItemIndex;
  Result := IfThen(Idx >= 0, TemplateNames[Idx], '');
end;

function TfrmCompletedVisitNote.GetNoteTitleIEN : string;
var Idx : integer;
begin
  Idx := cboNoteType.ItemIndex;
  Result := IfThen(Idx >= 0, NoteTitleIENs[Idx], '');
end;

function TfrmCompletedVisitNote.GetNoNoteSave : boolean;
begin
  Result := ckbNoNoteSave.Checked;
end;


procedure TfrmCompletedVisitNote.cboNoteTypeChange(Sender: TObject);
begin
  lblTemplateName.Caption := SelectedTemplateName;
  GenerateNote(FAppState, FFlowsheet, SelectedTemplateIEN, HtmlEditor);  //saves HTML into FFlowsheet.DocsHTMLNote
  //FAppState.NoteInfo.NoteSL.Assign(FFlowSheet.DocsHTMLSL);
end;

procedure TfrmCompletedVisitNote.ckbNoNoteSaveClick(Sender: TObject);
begin
  ckbPrintAfterSig.Visible := ckbNoNoteSave.Checked;
  if not ckbPrintAfterSig.Visible then ckbPrintAfterSig.Checked := false;
end;

procedure TfrmCompletedVisitNote.Initialize;
begin
  cboNoteType.Items.Clear;
  TemplateNames.Clear;     //will have 1:1 relation to cboNoteType.Items
  NoteTemplateIENs.Clear;  //will have 1:1 relation to cboNoteType.Items
  NoteTitleIENs.Clear;     //will have 1:1 relation to cboNoteType.Items

  if FAppState.Patient.NewPatient then begin
    cboNoteType.Items.Add('Instructions for Initial Visit');
    NoteTemplateIENs.Add(FAppState.Parameters.IENIntakeNoteTemplate);
    TemplateNames.Add(FAppState.Parameters.NameIntakeNoteTemplate);
    NoteTitleIENs.Add(FAppState.Parameters.IntakeNoteIEN);
  end else begin
    cboNoteType.Items.Add('Instructions for Normal Visit');
    NoteTemplateIENs.Add(FAppState.Parameters.IENInterimNoteTemplate);
    TemplateNames.Add(FAppState.Parameters.NameInterimNoteTemplate);
    NoteTitleIENs.Add(FAppState.Parameters.InterimNoteIEN);
  end;

  if (FAppState.AppointmentShowStatus = tsvNoShow) then begin
    cboNoteType.Items.Add('Missed Appointment');
    NoteTemplateIENs.Add(FAppState.Parameters.IENMissedApptNoteTemplate);
    TemplateNames.Add(FAppState.Parameters.NameMissedApptNoteTemplate);
    NoteTitleIENs.Add(FAppState.Parameters.MissedApptNoteIEN);
  end;

  if FAppState.Patient.DischargedFromClinic then begin
    cboNoteType.Items.Add('Discharge From Clinic');
    NoteTemplateIENs.Add(FAppState.Parameters.IENDCNoteTemplate);
    TemplateNames.Add(FAppState.Parameters.NameDCNoteTemplate);
    NoteTitleIENs.Add(FAppState.Parameters.DischargeNoteIEN);
  end;

  cboNoteType.ItemIndex := 0;
  cboNoteTypeChange(self); //will cause note to be generated
end;

function TfrmCompletedVisitNote.ShowModal(AppState : TAppState; AFlowsheet : TOneFlowsheet) : integer;
// It might be that AFlowsheet is not the same as AppState.CurrentNewFlowsheet
begin
  FAppState.Assign(AppState);
  FFlowsheet.Assign(AFlowsheet);
  Initialize;
  Result := Self.ShowModal;
end;

procedure TfrmCompletedVisitNote.BitBtn1Click(Sender: TObject);
var UseUI:OleVariant;
    TempLines : TStringList;
    ErrMsg: string;
begin
  //to do!!!  Replace with CPRS functionality --> HTMLEditor.Print(True);
  UseUI := true;
  HTMLEditor.PrintDocument(UseUI);
//  TempLines := TStringList.Create;
//  TempLines.Assign(GetFormattedNote(FNote, True));
//  LoadDocumentText(TempLines, FNote);  //Get document without headers/footers
 // HTMLEditor.P
 // PrintHTMLReport(HTMLEditor, ErrMsg, Patient.Name,
 //                   FormatFMDateTime('mm/dd/yyyy', Patient.DOB),
 //                   uHTMLtools.ExtractDateOfNote(TempLines), // date for report.
 //                   Patient.WardService, Application);
 // TempLines.Free;
 // if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
end;

procedure TfrmCompletedVisitNote.btnDoneClick(Sender: TObject);
begin
  ModalResult := mrOK;  //this should cause form to close.
end;

procedure TfrmCompletedVisitNote.btnPrintClick(Sender: TObject);
begin
  //to do!!!  Replace with CPRS functionality --> HTMLEditor.Print(True);
  //kt HtmlEditor.Print;  //could be HtmlEditor.PrintPreview
end;

procedure TfrmCompletedVisitNote.FormCreate(Sender: TObject);
begin
  HtmlEditor := THtmlObj.Create(pnlHTMLObjHolder, Application);
  TWinControl(HtmlEditor).Parent:= pnlHTMLObjHolder;
  TWinControl(HtmlEditor).Align:=alClient;
  HtmlEditor.Loaded();
  HtmlEditor.HTMLText := '<p>';
  HtmlEditor.Editable := False;
  FPushingOutData := false;

  FAppState := TAppState.Create();
  FFlowsheet := TOneFlowsheet.Create;
  TemplateNames := TStringList.Create;
  NoteTemplateIENs := TStringList.Create;
  NoteTitleIENs  := TStringList.Create;
end;

procedure TfrmCompletedVisitNote.FormDestroy(Sender: TObject);
begin
  HtmlEditor.Free;
  FAppState.Free;
  FFlowsheet.Free;
  TemplateNames.Free;
  NoteTemplateIENs.Free;
  NoteTitleIENs.Free;
end;

function TfrmCompletedVisitNote.MakeAndSaveTIUNote(var ErrMsg : string) : boolean; //kt
//Makes, Saves, Signs TIU Note.
//Result: True if save OK, false if problem.
var EncSig :string;
    frmSignItemACM: TfrmSignItemACM;
    CosignWanted : boolean;
    frmCosign: TfrmCosign;
    temp : boolean;
    UseUI:OleVariant;
begin

  Result := false; //default to failure
  with FAppState do begin
    NoteInfo.NoteIEN := '';
    NoteInfo.SaveSuccess := false;    ErrMsg := '';
    if EClinic = '' then EClinic := Parameters.NonCountClinic;

    //Create note and set text
    //SplitHTMLToArray (FFlowsheet.DocsHTMLNote, ANote, 120);
    WrapLongHTMLLines(NoteInfo.NoteSL, 255, CRLF);
    NoteInfo.NoteIEN := MakeNote(FAppState, SelectedNoteTitleIEN, NoteInfo.NoteSL);
    if StrToIntDef(NoteInfo.NoteIEN, -1)  < 0 then begin
      ErrMsg := 'Error creating note on server.';
      exit;
    end;

    //SignatureForItem(12, 'Sign Document', 'Electronic Signature Code', EncSig);
    CosignWanted := false;
    frmSignItemACM := TfrmSignItemACM.Create(Application);
    try
      if frmSignItemACM.ShowModal('Sign Document', 'Electronic Signature Code') = mrOK then begin
        if ckbPrintAfterSig.Checked then begin
          UseUI := true;
          HTMLEditor.PrintDocument(UseUI);
          MessageDlg('Press OK when done printing.', mtInformation, [mbOK], 0);
        end;
        CosignWanted := frmSignItemACM.CosignerWanted;
        EncSig := frmSignItemACM.ESCode;
      end;
      if EncSig='' then begin
        ErrMsg := 'Document not signed.';
        exit;
      end;
    finally
      frmSignItemACM.Free;
    end;

    if not SignRecord(NoteInfo.NoteIEN, EncSig) then begin
      ErrMsg := 'Error signing note on server.';
      exit;
    end;

    //NoteInfo.CosignNeeded := CosignerNeeded(tcfNote, FAppState, NoteInfo.CosignerDUZ, SelectedNoteTitleIEN, CosignWanted);
    frmCosign := TfrmCosign.Create(Application);
    try
      NoteInfo.CosignerDUZ := '';
      NoteInfo.CosignNeeded := frmCosign.CoSignNeeded(tcfNote, FAppState, SelectedNoteTitleIEN) or CosignWanted;
      if NoteInfo.CosignNeeded then begin
        if frmCosign.ShowModal = mrOK then begin
          NoteInfo.CosignerDUZ := frmCosign.CoSignerDUZ;
        end;
      end;
    finally
      frmCosign.Free;
    end;
    if not NoteInfo.CosignOK() then begin
      ErrMsg := 'Cosigner not selected.';
      exit;
    end;

    if SelectedNoteTitleIEN = FAppState.Parameters.IntakeNoteIEN then begin
      CompleteConsult (Parameters,   NoteInfo.NoteIEN,
                       Provider.DUZ, Patient.DFN);
    end;
    NoteInfo.SaveSuccess := true;
    Result := True; //success if we got this far.

  end;
end;


end.
