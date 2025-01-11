unit fPopHealth;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, uConst,
  Dialogs, ExtCtrls, OleCtrls, SHDocVw, fPage, VA508AccessibilityManager, uCore, ORNet, uHTMLTools, ORFn,
  StdCtrls, Buttons, ORDtTm, rCore, uTMGOptions, fSingleNote, fNotes, Math, DateUtils;

type
  TfrmPopHealth = class(TFrmPage)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    wbPopHealth: TWebBrowser;
    RadioGroup1: TRadioGroup;
    dtBeginning: TORDateBox;
    dtEnding: TORDateBox;
    Label1: TLabel;
    Label2: TLabel;
    cmbBeginningLetter: TComboBox;
    cmbEndingLetter: TComboBox;
    btnUpdate: TBitBtn;
    timUpdatePopHealth: TTimer;
    chkInactivePat: TCheckBox;
    cmbNumResults: TComboBox;
    Label3: TLabel;
    chkOpenNote: TCheckBox;
    btnNext: TBitBtn;
    btnPrev: TBitBtn;
    Label4: TLabel;
    cmbSortBy: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    btnCancel: TBitBtn;
    procedure dtEndingChange(Sender: TObject);
    procedure dtBeginningChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure timUpdatePopHealthTimer(Sender: TObject);
    procedure cmbEndingLetterChange(Sender: TObject);
    procedure cmbBeginningLetterChange(Sender: TObject);
    procedure dtEndingClick(Sender: TObject);
    procedure dtBeginningClick(Sender: TObject);
    procedure cmbEndingLetterClick(Sender: TObject);
    procedure cmbBeginningLetterClick(Sender: TObject);
    procedure cmbSortByClick(Sender: TObject);
    procedure cmbNumResultsClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure chkOpenNoteClick(Sender: TObject);
    procedure chkInactivePatClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure wbPopHealthBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName,
      PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
    IsDirty : boolean;
    Partial:Boolean;
    FirstDisplayed:integer;
    LastDisplayed:integer;
    TotalResults:integer;
    SearchStatus:string;
    procedure SetButtons;
    procedure LoadPopHealth(Refresh:boolean;Direction:string='0');
  public
    { Public declarations }
  end;

var
  frmPopHealth: TfrmPopHealth;

implementation

{$R *.dfm}

uses fFrame;

procedure TfrmPopHealth.btnCancelClick(Sender: TObject);
begin
  inherited;
  if btnCancel.Caption='Pause' then
    btnCancel.Caption:='Resume'
  else
    btnCancel.Caption:='Pause';
  timUpdatePopHealth.enabled:=btnCancel.Caption='Pause';
end;

procedure TfrmPopHealth.btnNextClick(Sender: TObject);
begin
  inherited;
  LoadPopHealth(False,'2');
end;

procedure TfrmPopHealth.btnPrevClick(Sender: TObject);
begin
  inherited;
  LoadPopHealth(False,'1');
end;

procedure TfrmPopHealth.btnUpdateClick(Sender: TObject);
begin
  inherited;
  LoadPopHealth(True);
end;

procedure TfrmPopHealth.chkInactivePatClick(Sender: TObject);
begin
  inherited;
  IsDirty := True;
  SetButtons;
  uTMGOptions.WriteBool('PopHealthInactivePats',chkInactivePat.checked);
end;

procedure TfrmPopHealth.chkOpenNoteClick(Sender: TObject);
begin
  inherited;
  uTMGOptions.WriteBool('PopHealthOpenNote',chkOpenNote.checked);
end;

procedure TfrmPopHealth.cmbBeginningLetterChange(Sender: TObject);
begin
  inherited;
  IsDirty := True;
  SetButtons;
end;

procedure TfrmPopHealth.cmbBeginningLetterClick(Sender: TObject);
begin
  inherited;
  IsDirty := True;
  SetButtons;
end;

procedure TfrmPopHealth.cmbEndingLetterChange(Sender: TObject);
begin
  inherited;
  IsDirty := True;
  SetButtons;
end;

procedure TfrmPopHealth.cmbEndingLetterClick(Sender: TObject);
begin
  inherited;
  IsDirty := True;
  SetButtons;
end;

procedure TfrmPopHealth.cmbNumResultsClick(Sender: TObject);
begin
  inherited;
  LoadPopHealth(False,'0');
end;

procedure TfrmPopHealth.cmbSortByClick(Sender: TObject);
begin
  inherited;
  LoadPopHealth(False,'0');
end;

procedure TfrmPopHealth.dtBeginningChange(Sender: TObject);
begin
  inherited;
  IsDirty := True;
  SetButtons;
end;

procedure TfrmPopHealth.dtBeginningClick(Sender: TObject);
begin
  inherited;
  IsDirty := True;
  SetButtons;
end;

procedure TfrmPopHealth.dtEndingChange(Sender: TObject);
begin
  inherited;
  IsDirty := True;
  SetButtons;
end;

procedure TfrmPopHealth.dtEndingClick(Sender: TObject);
begin
  inherited;
  IsDirty := True;
  SetButtons;
end;

procedure TfrmPopHealth.FormCreate(Sender: TObject);
var ch:Char;
    NumResults:string;
    NumOfPieces,i:integer;
    DateTime:TDateTime;
begin
  inherited;
  IsDirty := False;
  cmbBeginningLetter.Items.clear;
  cmbEndingLetter.Items.clear;

  for ch := 'A' to 'Z' do begin
    cmbBeginningLetter.Items.Add(ch);
    cmbEndingLetter.Items.Add(ch);
  end;
  cmbBeginningLetter.ItemIndex := 0;
  cmbEndingLetter.ItemIndex := cmbEndingLetter.Items.Count-1;

  DateTime := IncDay(Now,1);
  dtBeginning.FMDateTime := DateTimeToFMDateTime(DateTime);
  DateTime := IncDay(Now,8);
  dtEnding.FMDateTime := DateTimeToFMDateTime(DateTime);

  NumResults := uTMGOptions.ReadString('PopHealthResultAmount','25,50,75,100');
  NumOfPieces := NumPieces(NumResults,',');
  for I := 1 to NumOfPieces do
    cmbNumResults.Items.Add(piece(NumResults,',',I));

  chkInactivePat.Checked := uTMGOptions.ReadBool('PopHealthInactivePats',False);

  chkOpenNote.Checked := uTMGOptions.ReadBool('PopHealthOpenNote',False);

  cmbNumResults.ItemIndex := 0;

  cmbSortBy.ItemIndex := 0;
end;

procedure TfrmPopHealth.FormHide(Sender: TObject);
begin
  //timUpdatePopHealth.Enabled := False;
end;

procedure TfrmPopHealth.FormShow(Sender: TObject);
begin
  //timUpdatePopHealth.enabled := True;
  RadioGroup1.ItemIndex := 0;
  LoadPopHealth(True);
end;

procedure TfrmPopHealth.RadioGroup1Click(Sender: TObject);
begin
   IsDirty := True;
   SetButtons;
   Label1.Visible := (RadioGroup1.ItemIndex <> 2);
   Label2.Visible := (RadioGroup1.ItemIndex <> 2);
   dtBeginning.Visible := RadioGroup1.ItemIndex = 0;
   dtEnding.Visible := RadioGroup1.ItemIndex = 0;
   cmbBeginningLetter.Visible := RadioGroup1.ItemIndex = 1;
   cmbEndingLetter.Visible := RadioGroup1.ItemIndex = 1;
   case RadioGroup1.ItemIndex of
     0: begin
        Label1.Caption := 'Beginning Date:';
        Label2.Caption := 'Ending Date:';
     end;
     1: begin
        Label1.Caption := 'Beginning Letter:';
        Label2.Caption := 'Ending Letter:';
     end;
     2: begin
        //Nothing needed yet
     end;
   end;
end;

procedure TfrmPopHealth.wbPopHealthBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL, Flags,
  TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
var MsgType:string;
    DFN:string;
    RemIEN:string;
begin
  //MsgType := piece(piece(URL,'^',1),':',2);  //trim out the about: and the command
  if pos('DFN-',URL)>0 then begin
    DFN := piece2(URL,'DFN-',2);
    //Patient.DFN := '0';
    //ShowEverything;
    //Patient.DFN := DFN;     // The patient object in uCore must have been created already!
    if pos('&',DFN)>0 then begin
      RemIEN := piece2(DFN,'REM-',2);
      DFN := piece(DFN,'&',1);
    end else begin
      RemIEN := '';
    end;
    try
      if Patient.DFN=DFN then begin   //Added this IF to navigate to Notes tab
        frmFrame.SelectChartTab(tpsLeft, CT_NOTES);
      end else begin
        frmFrame.OpenAPatient(DFN);
        application.processmessages;
        if chkOpenNote.Checked=True then begin
          fSingleNote.CreateSingleNote(snmReminder,False,RemIEN);
          //frmNotes.cmdNewNoteClick(ASender);
        end
      end;
    finally
      //OrderPrintForm := FALSE;
    end;
    Cancel := True;
  end;

end;

procedure TfrmPopHealth.SetButtons;
begin
   btnCancel.visible := SearchStatus<>'COMPLETED';
   if SearchStatus<>'COMPLETED' then begin
      btnPrev.Enabled := False;
      btnNext.Enabled := False;
      btnUpdate.enabled := False;
      exit;
   end;
   btnPrev.Enabled := (Partial and (FirstDisplayed <> 1));
   btnNext.Enabled := (Partial and (LastDisplayed <> TotalResults));
   btnUpdate.Enabled := IsDirty=True;
end;

procedure TfrmPopHealth.timUpdatePopHealthTimer(Sender: TObject);
begin
  inherited;
  LoadPopHealth(False,'0');
end;

procedure TfrmPopHealth.LoadPopHealth(Refresh:boolean;Direction:string='0');
    function BoolToStr(IsTrue:boolean):string;
    begin
       result := '0';
       if IsTrue then result := '1';
    end;
var MessageArr:TStringList;
    ParamStr,Sort,Inactive,NumResults,RefreshStr,StartPos : string;
    ResultStats:string;
begin
   timUpdatePopHealth.enabled := False;
   case RadioGroup1.ItemIndex of
     0: begin
        ParamStr := '0;'+FMDTToStr(dtBeginning.FMDateTime)+';'+FMDTToStr(dtEnding.FMDateTime);
     end;
     1: begin
        ParamStr := '1;'+cmbBeginningLetter.Text+';'+cmbEndingLetter.Text;
     end;
     2: begin
        ParamStr := '2';
     end;
  end;
  Sort := inttostr(cmbSortBy.ItemIndex);
  Inactive := BoolToStr(chkInactivePat.Checked);
  RefreshStr := BoolToStr(Refresh);
  NumResults := cmbNumResults.Text;
  MessageArr := TStringList.Create();
  //StartPos should be dependent on which direction we are moving. If backwards, it is the first of the list and vice versa
  if Direction='1' then
    StartPos := inttostr(FirstDisplayed)
  else
    StartPos := inttostr(LastDisplayed);
  
  tCallV(MessageArr,'TMG CPRS GET POP HEALTH REPORT',[User.DUZ,'0',ParamStr,Sort,Inactive,RefreshStr,NumResults,Direction,StartPos]);
  //Review results
  ResultStats := MessageArr[0];
  MessageArr.Delete(0);
  if piece(ResultStats,'^',1)='-1' then begin
    ShowMessage(piece(ResultStats,'^',2));
    //exit;
  end;
  Partial := (piece(ResultStats,'^',3)='1');
  FirstDisplayed := strtoint(piece(ResultStats,'^',4));
  LastDisplayed := strtoint(piece(ResultStats,'^',5));
  TotalResults := strtoint(piece(ResultStats,'^',6));
  SearchStatus := piece(ResultStats,'^',7);
  label6.caption := SearchStatus;
  label6.Visible := (label6.caption<>'COMPLETED');
  IsDirty := False;
  //LoadList
  WBLoadHTML(wbPopHealth, MessageArr.TEXT);
  if (Refresh) or (SearchStatus <> 'COMPLETED') then timUpdatePopHealth.enabled := True;
  label5.Visible := timUpdatePopHealth.enabled;
  SetButtons;
  MessageArr.Free;
end;

end.

