unit fEditFlowsheet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ORCtrls, ORFn, ORNet, Trpcb, uTypesACM, uFlowsheet,
  Dialogs, StdCtrls, ComCtrls, Buttons;

type
  TfrmEditFlowsheetEntry = class(TForm)
    lblEditDate: TLabel;
    dtpEdit: TDateTimePicker;
    lblINREdit: TLabel;
    edtEditINR: TEdit;
    lblPtNotifEdit: TLabel;
    edtPN: TEdit;
    lblTWDEdit: TLabel;
    edtTWD: TEdit;
    lblEComm: TLabel;
    memComments: TMemo;
    lblEditDuz: TLabel;
    memComplications: TMemo;
    lblEComplications: TLabel;
    btnDelete: TBitBtn;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    btnEditComplications: TBitBtn;
    dtpINRDate: TDateTimePicker;
    lblINRDT: TLabel;
    lblDosing: TLabel;
    lblDosingStr1: TLabel;
    lblDosingStr2: TLabel;
    btnEditDocumentation: TBitBtn;
    procedure btnCancelClick(Sender: TObject);
    procedure btnEditCanClick(Sender: TObject);
    procedure memCommentsChange(Sender: TObject);
    procedure edtPNChange(Sender: TObject);
    procedure edtEditINRChange(Sender: TObject);
    procedure dtpEditChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditOKClick(Sender: TObject);
    procedure c(Sender: TObject);
    procedure dtpINRDateChange(Sender: TObject);
    procedure btnEditDocumentationClick(Sender: TObject);
  private
    { Private declarations }
    FChangingMemoInCode : boolean;
    FOneFlowsheet : TOneFlowsheet; //owned locally
    FAppState : TAppState;         //NOT owned locally
    FLoadingForm : boolean;
    FModified : boolean;
    procedure DataToGUI();
    procedure Initialize(AFlowsheet : TOneFlowsheet; AppState : TAppState);
    procedure HandleModified;
  public
    { Public declarations }
    procedure ClearForm;
    function ShowModal(AFlowsheet : TOneFlowsheet; AppState : TAppState) : integer; overload;
    property EditedFlowSheet : TOneFlowSheet read FOneFlowSheet;
    property Modified : boolean read FModified;
  end;

//var
//  frmEditFlowsheetEntry: TfrmEditFlowsheetEntry;

const
  mrRecordDelete = -99;


implementation

{$R *.dfm}

uses
  fAnticoagulator, fEditComplications, rRPCsACM, fCompletedVisitNote, uUtility;


procedure TfrmEditFlowsheetEntry.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel; //closes form.
end;

procedure TfrmEditFlowsheetEntry.btnDeleteClick(Sender: TObject);
begin
  if InfoBox('This will retract the flow sheet entry associated ' + CRLF +
              'with this specific date.  OK?',
              'Retract Flowsheet Entry?', MB_YESNO or MB_ICONQUESTION) <> mrYes then exit;
  FOneFlowsheet.TMGRetractionDate := Now;
  FOneFlowsheet.Comments.Add('Entry retracted by: ' + FAppState.Provider.Name + ' on ' + DateToStr(Date));
  //FOneFlowsheet.SaveToExistingServerRecord(FAppState);
  ModalResult := mrRecordDelete; //closes form.
end;

procedure TfrmEditFlowsheetEntry.btnEditCanClick(Sender: TObject);
begin
  ModalResult := mrCancel; //closes form.
end;

procedure TfrmEditFlowsheetEntry.btnEditDocumentationClick(Sender: TObject);
var
  frmCompletedVisitNote: TfrmCompletedVisitNote;
  TempAppState : TAppState;

begin
  frmCompletedVisitNote := TfrmCompletedVisitNote.Create(Self);
  TempAppState := TAppState.Create;
  try
    TempAppState.Assign(FAppState);
    if frmCompletedVisitNote.ShowModal(TempAppState, FOneFlowsheet) = mrOK then begin
      FAppState.Assign(TempAppState);
    end;
  finally
    frmCompletedVisitNote.Free;
    TempAppState.Free;
  end;
end;

procedure TfrmEditFlowsheetEntry.c(Sender: TObject);
var
  frmEditComplications: TfrmEditComplications;
begin
  frmEditComplications := TfrmEditComplications.Create(Self);
  try
    if frmEditComplications.ShowModal(FOneFlowsheet.Complications, FOneFlowsheet.DateStr) = mrOK then begin
      FOneFlowsheet.Complications.Assign(frmEditComplications.Complications);  //this is an encoded SL
      FOneFlowsheet.ComplicationScore := frmEditComplications.ComplicationScore;
      Initialize(FOneFlowsheet, FAppState);
      HandleModified;
    end;
  finally
    frmEditComplications.Free;
  end;
end;

procedure TfrmEditFlowsheetEntry.btnEditOKClick(Sender: TObject);

begin
  if InfoBox('This will save changes NOW.  OK?', 'Apply Changes',
              MB_YESNO or MB_ICONQUESTION) <> mrYes then exit;
  FOneFlowsheet.Comments.Add('Entry edited by: ' + FAppState.Provider.Name + ' on ' + DateToStr(Date));
  FOneFlowsheet.SaveToExistingServerRecord(FAppState);
  ModalResult := mrOK; //closes form.
end;


procedure TfrmEditFlowsheetEntry.ClearForm;
begin
  dtpEdit.Date := Now;
  edtEditINR.Text := '';
  edtPN.Text := '';
  edtTWD.Text := '';
  memComments.Lines.Clear;
  memComplications.Lines.Clear;
end;

procedure TfrmEditFlowsheetEntry.Initialize(AFlowsheet : TOneFlowsheet; AppState : TAppState);
begin
  FOneFlowsheet.Assign(AFlowsheet);
  FAppState := AppState;
  DataToGUI();
  FModified := false;
  btnOK.Enabled := false; //will be enabled if changes are made.
end;

function TfrmEditFlowsheetEntry.ShowModal(AFlowsheet : TOneFlowsheet; AppState : TAppState) : integer;
begin
  Initialize(AFlowsheet, AppState);
  Result := Self.ShowModal;
end;

procedure TfrmEditFlowsheetEntry.DataToGUI();
var count, index : integer;
    FirstWord, LastLine  : string;

  procedure DeleteIfUnwanted(index : integer);
  var
    FirstWord, Line : string;
  begin
    Line := FOneFlowsheet.Comments[index];
    FirstWord := Piece(Line, ' ', 1);
    if (FirstWord = 'Next') or (FirstWord = 'Missed') then begin
      FOneFlowsheet.Comments.Delete(index);
    end;
  end;

begin
  FLoadingForm := true;

  Caption := 'EDIT - ' + FOneFlowsheet.DateStr;
  edtEditINR.Text         := FOneFlowsheet.INR;
  dtpINRDate.DateTime     := FOneFlowsheet.INRLabDateTime;
  edtPN.Text              := FOneFlowsheet.PatientNotice;
  edtTWD.Text             := FOneFlowsheet.TotalWeeklyDose;
  dtpEdit.Date            := FOneFlowsheet.DateTime;

  //NOTE: I am copying the functionality of the prior program,
  //  but I don't like what it is doing (the business logic).  Consider deleting later...
  Count := FOneFlowsheet.Comments.Count;
  if Count > 0 then begin
    index := Count-1;
    if Count>1 then begin
      index := Count-2;
      LastLine := Trim(FOneFlowsheet.Comments[index]);
      FirstWord := Piece(LastLine, ' ', 1);
      if FirstWord = 'Edited' then DeleteIfUnwanted(index-1);
    end else begin
      DeleteIfUnwanted(index);
    end;
  end;
  FChangingMemoInCode := true;
  memComments.Lines.Assign(FOneFlowsheet.Comments);
  memComplications.Lines.Assign(FOneFlowsheet.Complications);
  FChangingMemoInCode := false;
  lblEditDuz.Caption := 'Entered by: '+  FOneFlowsheet.Provider;
  lblDosingStr1.Caption := FOneFlowsheet.HumanReadableRegimen1;
  lblDosingStr2.Caption := FOneFlowsheet.HumanReadableRegimen2;
  lblDosingStr2.Visible := FOneFlowsheet.UsingTwoPills;
  FLoadingForm := false;
end;


procedure TfrmEditFlowsheetEntry.FormCreate(Sender: TObject);
begin
  FOneFlowsheet := TOneFlowsheet.Create(); //owned locally
  FLoadingForm := false;
end;

procedure TfrmEditFlowsheetEntry.FormDestroy(Sender: TObject);
begin
  FOneFlowsheet.Free;
end;

procedure TfrmEditFlowsheetEntry.memCommentsChange(Sender: TObject);
begin
  if FLoadingForm then exit;
  if FChangingMemoInCode then exit;
  FOneFlowsheet.Comments.Assign(memComments.Lines);
  HandleModified;
end;

procedure TfrmEditFlowsheetEntry.dtpEditChange(Sender: TObject);
begin
  if FLoadingForm then exit;
  if FOneFlowsheet.DateTime = dtpEdit.Date then exit;
  FOneFlowsheet.DateTime := dtpEdit.Date;
  FOneFlowsheet.DateStr := DateToStr(dtpEdit.Date);
  HandleModified;
end;

procedure TfrmEditFlowsheetEntry.dtpINRDateChange(Sender: TObject);
begin
  if FLoadingForm then exit;
  if FOneFlowsheet.INRLabDateTime = dtpINRDate.DateTime then exit;
  FOneFlowsheet.INRLabDateTime := dtpINRDate.DateTime;
  HandleModified;
end;

procedure TfrmEditFlowsheetEntry.edtEditINRChange(Sender: TObject);
begin
  if FLoadingForm then exit;
  if FOneFlowsheet.INR = Trim(edtEditINR.Text) then exit;
  FOneFlowsheet.INR := Trim(edtEditINR.Text);
  HandleModified;
end;

procedure TfrmEditFlowsheetEntry.edtPNChange(Sender: TObject);
begin
  if FLoadingForm then exit;
  if FOneFlowsheet.PatientNotice = Trim(edtPN.Text) then exit;
  FOneFlowsheet.PatientNotice := Trim(edtPN.Text);
  FOneFlowsheet.INRLabDateTime := dtpINRDate.DateTime;
  HandleModified;
end;

procedure TfrmEditFlowsheetEntry.HandleModified;
begin
  FModified := true;
  btnOK.Enabled := FModified;
end;



end.
