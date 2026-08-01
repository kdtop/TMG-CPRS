unit MDMHelper;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  {$IFNDEF STAND_ALONE_APP}
  VAUtils,  ORNet, uCore,  rTemplates,
  {$ENDIF}
  Dialogs, StdCtrls, Buttons, ExtCtrls, Math, StrUtils,
  CollapsablePanelU;

type
  TPatientType = (ptUndef = -1, ptEstablished=0, ptNew=1);  //must match order of items in rgNewOrOldPatient
  TComplexityLevel = (clUnDef=-1, clMin=0, clLow=1, clMod=2, clHigh=3);
  TBillingModeType = (tcUndef = -1, tcComplexity, tcTime, tcTelemedTime, tcCPE); //must match order of items in rgBillingMode

  TDisplayState = record
    PatientType : TPatientType;
    BillingMode : TBillingModeType;
  end;

  TfrmMDMGrid = class(TForm)
    sbMain: TScrollBox;
    pnlBillingMode: TPanel;
    rgBillingMode: TRadioGroup;
    pnlNewOrOldPatient: TPanel;
    rgNewOrOldPatient: TRadioGroup;
    pnlNewPtTimeAmount: TPanel;
    rgNewPtTimeAmount: TRadioGroup;
    pnlOldPtTimeAmount: TPanel;
    rgOldPtTimeAmount: TRadioGroup;
    memNewPtTimeInfo: TMemo;
    memOldPtTimeInfo: TMemo;
    pnlComplexity: TPanel;
    gpProblems: TGroupBox;
    rgMinimal: TRadioGroup;
    rgLow: TRadioGroup;
    rgModerate: TRadioGroup;
    rgHigh: TRadioGroup;
    pnlTestsDocs: TPanel;
    grpTestsDocsIndHx: TGroupBox;
    ckbReview1Test: TCheckBox;
    ckbReview2Tests: TCheckBox;
    ckbReview3Tests: TCheckBox;
    ckbReview1ExtDoc: TCheckBox;
    ckbReview2ExtDocs: TCheckBox;
    ckbReview3ExtDocs: TCheckBox;
    ckbIndHistorian: TCheckBox;
    ckbOrder1Test: TCheckBox;
    ckbOrder2Tests: TCheckBox;
    ckbOrder3Tests: TCheckBox;
    memChargeComments: TMemo;
    lblDataScoreTitle: TLabel;
    lblDataScore: TLabel;
    ckbIndInterpret: TCheckBox;
    ckbDiscussExternal: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    pnlRisk: TPanel;
    grpRisk: TGroupBox;
    rgRisk: TRadioGroup;
    memExampleRiskMod: TMemo;
    memExampleRiskHigh: TMemo;
    btnNextSection: TButton;
    btnReviewTestHelp: TBitBtn;
    btnOrderTestsHelp: TBitBtn;
    btnReviewDocsHelp: TBitBtn;
    btnIndependentHxHelp: TBitBtn;
    btnInterpretTestHelp: TBitBtn;
    btnDiscussExternalDocHelp: TBitBtn;
    pnlBottom: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    Label1: TLabel;
    lblResult: TLabel;
    lblResultValue: TLabel;
    memBillingModeHint: TMemo;
    pnlTelemedTimeAmount: TPanel;
    rgTelemedTimeAmount: TRadioGroup;
    memTelemedTimeAmount: TMemo;
    pnlNewCPE: TPanel;
    rgNewCPE: TRadioGroup;
    memNewCPE: TMemo;
    pnlOldCPE: TPanel;
    rgOldCPE: TRadioGroup;
    memOldCPE: TMemo;
    btnNewPtRefreshTime: TButton;
    btnOldPtRefresh: TButton;
    btnTeleMedRefresh: TButton;
    lblChargeDetails: TLabel;
    btnOKRelaunch: TBitBtn;
    procedure btnOKRelaunchClick(Sender: TObject);
    procedure btnTeleMedRefreshClick(Sender: TObject);
    procedure btnOldPtRefreshClick(Sender: TObject);
    procedure btnNewPtRefreshTimeClick(Sender: TObject);
    procedure rgOldCPEClick(Sender: TObject);
    procedure rgNewCPEClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rgTelemedTimeAmountClick(Sender: TObject);
    procedure btnDiscussExternalDocHelpClick(Sender: TObject);
    procedure btnInterpretTestHelpClick(Sender: TObject);
    procedure btnIndependentHxHelpClick(Sender: TObject);
    procedure btnReviewDocsHelpClick(Sender: TObject);
    procedure btnTestsHelpClick(Sender: TObject);
    procedure btnNextSectionClick(Sender: TObject);
    procedure rgRiskClick(Sender: TObject);
    procedure rgComplexityLevelClick(Sender: TObject);
    procedure HandleReviewTestsChange(Sender: TObject);
    procedure rgOldPtTimeAmountClick(Sender: TObject);
    procedure rgNewPtTimeAmountClick(Sender: TObject);
    procedure rgBillingModeClick(Sender: TObject);
    procedure rgNewOrOldPatientClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOnCloseForm : TNotifyEvent;
    FOnFrameSize : TNotifyEvent;
    FFormSuccess : boolean;
    FEmbeddedMode : boolean;
    FEncounterFrame : TForm;
    InHandleReviewTestsChange : boolean;
    FNumIssuesScore: TComplexityLevel;
    FNumIssuesNarrrative : string;
    FDataScore: TComplexityLevel;
    FDataNarrative: string;
    FRiskScore: TComplexityLevel;
    FRiskNarrative : string;
    FPatientType : TPatientType;
    FPatientTypeText : string;
    FOverallComplexityScore : TComplexityLevel;
    FOverallComplexityNarrative : string;
    Cat1CheckBoxes : TList; //doesn't own.
    FBillingMode :  TBillingModeType;
    FTimeOrComplexityModeText : string;
    FOldPtTimeAmountIndex : integer;
    FNewPtTimeAmountIndex : integer;
    FCPEIndex : integer;
    FTimeAmountIndex : Integer;
    FTimeAmountNarrative : string;
    FCPENarrative : string;
    FTelemedTimeAmountIndex : integer;
    FTelemedTimeAmountNarrative : string;
    FOutputCPTMDM : string;
    FOutputCPTTime : string;
    FOuputCPTTelemedTime : string;
    FOutputCPTCPE : string;
    FOverallCPTOutput : string;
    FOverallNarrative : string;
    CurrentDisplayState : TDisplayState;
    FTableStrings : TStringList;  //every other line will be right vs left column.
    FTextTable : TStringList; //formatted version of FTableStrings
    FHTMLTable : TStringList;  //formatted version of FTableStrings
    cpFirst : TCollapsablePanel;  //doesn't own anything.  Just points to others.
    cpPanelNewOrOldPt : TCollapsablePanel;
    cpBillingMode : TCollapsablePanel;
    cpNewPtTimeAmount : TCollapsablePanel;
    cpOldPtTimeAmount : TCollapsablePanel;
    cpNewCPE : TCollapsablePanel;
    cpOldCPE : TCollapsablePanel;
    cpTelemedTimeAmount : TCollapsablePanel;
    cpMDM3ColHolder : TCollapsablePanel;
    cpComplexity : TCollapsablePanel;
    cpTestsData : TCollapsablePanel;
    cpRisk : TCollapsablePanel;
    CPTAvgPayments : TStringList;
    ChargeStr99212 : String;
    ChargeStr99213 : String;
    ChargeStr99214 : String;
    ChargeStr99215 : String;
    procedure FreeCollapsablePanel(var ACollapsablePanel: TCollapsablePanel);
    procedure ClearMDM3ColView;
    procedure ClearTimeView;
    procedure ClearTelemedTimeView;
    procedure ClearCPEView;
    procedure ClearOldTimeAmountView;
    procedure ClearNewTimeAmountView;
    procedure SetupTimeView(AUnitBefore : TCollapsablePanel);
    procedure SetupTelemedTimeView(AUnitBefore : TCollapsablePanel);
    procedure SetupComplexityView(AUnitBefore : TCollapsablePanel);
    procedure SetupCPEView(AUnitBefore : TCollapsablePanel);
    procedure SizeFrame();
    procedure SetupBasedOnBillingMode(AUnitBefore : TCollapsablePanel);
    procedure RecalcOverallComplexity();
    //procedure RefreshTimeBasedOutput(s : string);
    function NumOf3(Bool1, Bool2, Bool3 : boolean) : integer;
    function NumOf2(Bool1, Bool2 : boolean) : integer;
    procedure HandleStartOpenStateChange(Sender : TObject);
    procedure HandleEndOpenStateChange(Sender : TObject);
    function ItemDef(Items : TStrings; i : integer; default : string = '') : string;
    procedure RefreshOutput();
    function GetCPTOutput : string;
    function GetNarrative :  string;
    procedure MakeTextTable(SL : TStringList);
    procedure MakeHTMLTable(SL : TStringList);
    function HTMLSpc(n : integer  = 1) : string;
    {$IFNDEF STAND_ALONE_APP}
    procedure LoadPaymentInformation(CPTAvgPayments:TStringList);
    {$ENDIF}
    procedure LogEvent(S : string);
    procedure InitVars;
  public
    { Public declarations }
    CommonLog : TStrings;
    Relaunch : boolean;   //elh 1/23/25
    procedure Reset;
    procedure SetEmbeddedMode(value : boolean; HolderForm : TForm = nil);
    property CPT : string read GetCPTOutput;
    property Narrative : string read GetNarrative;
    property TextTable : TStringList read FTextTable;
    property HTMLTable : TStringList read FHTMLTable;
    property OnCloseForm : TNotifyEvent read FOnCloseForm write FOnCloseForm;
    property OnFrameSize : TNotifyEvent read FOnFrameSize write FOnFrameSize;
    property Result : boolean read FFormSuccess write FFormSuccess;
    //kt property EmbeddedMode : boolean read FEmbeddedMode write SetEmbeddedMode;

  end;

var
  frmMDMGrid : TfrmMDMGrid; //NOT auto-instantiated

const
   BILLING_MODE_CAPTION : array[tcUndef..tcCPE] of string = (
     'Undefined',
     'Using Medical Complexity Mode Billing',
     'Using TIME Mode Billing',
     'Using Telemedicine Time Mode Billing',
     'Preventative / CPE Billing'
   );

  COMPLEXITY_LEVEL_NAMES   : array[clUndef..clHigh] of string = ('Unspecified', 'Minimal', 'Low', 'Moderate', 'High');
  NEW_OR_OLD_PATIENT_NAMES : array[ptUndef..ptNew]  of string = ('Undefined', 'ESTABLISHED patient', 'NEW patient');
  BILLING_MODE  : array[tcUndef..tcCPE] of string = (
    'Undefined',
    'Medical Complexity',
    'Time Basis',
    'Telemedicine Time Basis',
    'Preventative / CPE'
  );
  CPT_FOR_MDM              : array[ptUndef..ptNew, clUnDef..clHigh] of string = (
    ('Undefined', 'Undefined', 'Undefined', 'Undefined', 'Undefined'),
    ('', '99212', '99213', '99214', '99215'),
    ('', '99202', '99203', '99204', '99205')
  );

  CPT_FOR_TIME : array[ptUndef..ptNew, -1..9] of string = (
    ('', '', '', '', '', '', '', '', '', '', ''),
    ('', '99212', '99213', '99214', '99215', '99215 + 99417x1', '99215 + 99417x2', '99215 + 99417x3', '99215 + 99417x4', '99214 + G0438', '99214 + G0439'),
    ('', '99202', '99203', '99204', '99205', '99205 + 99417x1', '99205 + 99417x2', '99205 + 99417x3', '99205 + 99417x4', '', '')
   );

  CPT_FOR_TELEMED_TIME : array[ptUndef..ptNew, -1..2] of string = (
    ('', '', '', ''),
    ('', '99441', '99442', '99443'),
    ('', '', '', '')
   );

  CPT_FOR_CPE : array[ptUndef..ptNew, -1..6] of string = (
    ('', '', '', '', '', '', '', ''),
    ('', '99394', '99395', '99396', '99397', 'G0438', 'G0439', 'G0402'),
    ('', '99384', '99385', '99386', '99387', 'G0438', 'G0439', 'G0402')
   );


  UNDEFINED = '<UNDEFINED>';

  SECT_ISSUES = 1;
  SECT_DATA   = 2;
  SECT_RISK   = 3;
  SECTION_TITLES : array[SECT_ISSUES..SECT_RISK] of string = (
    'Number and Complexity of Problems Addressed',
    'Amount and/or Complexity of Data to be Reviewed and Analyzed',
    'Risk of Complications and/or Morbidity or Mortality of Patient Management'
  );


//var  frmMDMGrid: TfrmMDMGrid;    //not autocreated

implementation

uses
  fEncounterFrame,
  uHTMLTools;

{$R *.dfm}

const
  ZERO_POINT : TPoint = (x : 0; y : 0);
  CRLF = #13#10;

function TfrmMDMGrid.ItemDef(Items : TStrings; i : integer; default : string = '') : string;
begin
  Result := default;
  if not assigned(Items) then exit;
  if (i < 0) or (i >= Items.Count) then exit;
  Result := Items[i];
end;


function TfrmMDMGrid.NumOf3(Bool1, Bool2, Bool3 : boolean) : integer;
begin
  Result := 0;
  if Bool1 then inc(Result);
  if Bool2 then inc(Result);
  if Bool3 then inc(Result);
end;

function TfrmMDMGrid.NumOf2(Bool1, Bool2 : boolean) : integer;
begin
  Result := NumOf3(Bool1, Bool2, false);
end;

procedure TfrmMDMGrid.btnNewPtRefreshTimeClick(Sender: TObject);
begin
  {$IFNDEF STAND_ALONE_APP}
  memNewPtTimeInfo.Lines.Clear;
  memNewPtTimeInfo.Lines.Add('|TMG TIME WITH PATIENT TODAY VERBOSE|');
  GetTemplateText(memNewPtTimeInfo.Lines);
  {$ENDIF}
end;

procedure TfrmMDMGrid.btnReviewDocsHelpClick(Sender: TObject);
begin
  MessageDlg('An “external” note includes records, notes, ' + CRLF +
             'and tests from external providers', mtInformation, [mbOK], 0);
end;

procedure TfrmMDMGrid.btnTestsHelpClick(Sender: TObject);
begin
  MessageDlg('A single “unique test” for coding purposes includes panels.' + CRLF +
             'E.g., a basic metabolic panel is considered a single unique test.',
             mtInformation, [mbOK], 0);
end;

procedure TfrmMDMGrid.btnOldPtRefreshClick(Sender: TObject);
begin
  {$IFNDEF STAND_ALONE_APP}
  memOldPtTimeInfo.Lines.Clear;
  memOldPtTimeInfo.Lines.Add('|TMG TIME WITH PATIENT TODAY VERBOSE W MSG|');
  GetTemplateText(memOldPtTimeInfo.Lines);
  {$ENDIF}
end;

procedure TfrmMDMGrid.btnTeleMedRefreshClick(Sender: TObject);
begin
  {$IFNDEF STAND_ALONE_APP}
  memTelemedTimeAmount.Lines.Clear;
  memTelemedTimeAmount.Lines.Add('|TMG TIME WITH PATIENT TODAY VERBOSE|');
  GetTemplateText(memTelemedTimeAmount.Lines);
  {$ENDIF}
end;

procedure TfrmMDMGrid.btnCancelClick(Sender: TObject);
begin
  FFormSuccess := false;
  Self.Close;
end;

procedure TfrmMDMGrid.btnDiscussExternalDocHelpClick(Sender: TObject);
begin
  MessageDlg('An “external” physician or qualified health professional is'+CRLF+
             'a provider from a different specialty or a totally different'+CRLF+
             'group practice.', mtInformation, [mbOK], 0);
end;

procedure TfrmMDMGrid.btnIndependentHxHelpClick(Sender: TObject);
begin
  MessageDlg('An independent historian is an individual (eg, parent,'+CRLF+
             'guardian, surrogate, spouse, witness) who provides a history'+CRLF+
             'in addition to the history provided by the patient who was '+CRLF+
             'unable to provide a complete or reliable history (eg, due to '+CRLF+
             'developmental stage, dementia, or psychosis) or because'+CRLF+
             'confirmatory history is judged to be necessary in the case '+CRLF+
             'where there may be a conflict or poor communication between '+CRLF+
             'multiple historians and more than one historian(s) is needed.', mtInformation, [mbOK], 0);
end;

procedure TfrmMDMGrid.btnInterpretTestHelpClick(Sender: TObject);
begin
  MessageDlg('An “Independent interpretation of tests” includes looking at'+CRLF+
             'or interpreting a chest X-ray (CXR) or electrocardiogram (ECG) '+CRLF+
             'tracing (i.e., “I ordered and personally reviewed the CXR and '+CRLF+
             'it shows …”). You are not credited with interpretation in this '+CRLF+
             'category if you are also billing for your interpretation separately.', mtInformation, [mbOK], 0);
end;

procedure TfrmMDMGrid.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(FOnCloseForm) then begin
    FOnCloseForm(self);
  end;
end;

procedure TfrmMDMGrid.InitVars;
begin
  FPatientType := ptUndef;

  FNumIssuesScore := clUndef;
  FNumIssuesNarrrative := '';
  FDataScore := clUndef;
  FDataNarrative:= '';
  FRiskScore := clUndef;
  FRiskNarrative := '';
  FBillingMode := tcUndef;
  FTimeOrComplexityModeText := '';
  FOldPtTimeAmountIndex := -1;
  FNewPtTimeAmountIndex := -1;
  FCPEIndex := -1;
  FTimeAmountIndex := -1;
  FTelemedTimeAmountIndex := -1;
  FTimeAmountNarrative := '';
  FCPENarrative := '';
  FTelemedTimeAmountNarrative := '';
  FOutputCPTMDM := '';
  FOutputCPTTime := '';
  FOuputCPTTelemedTime := '';
  FPatientType := ptUndef;
  FPatientTypeText := '';
  FOverallComplexityScore := clUndef;
  FOverallComplexityNarrative := '';
  CurrentDisplayState.PatientType := ptUndef;
  CurrentDisplayState.BillingMode := tcUndef;
end;

procedure TfrmMDMGrid.FormCreate(Sender: TObject);
begin
  Relaunch := False;
  FFormSuccess := false;
  CommonLog := nil;
  FEmbeddedMode := false;

  //Later allow initialization...
  InHandleReviewTestsChange := false;
  FTableStrings := TStringList.Create;
  FTextTable := TStringList.Create; //formatted version of FTableStrings
  FHTMLTable := TStringList.Create;

  FOnCloseForm := nil;

  InitVars;

  cpNewPtTimeAmount := nil;
  cpOldPtTimeAmount := nil;

  Cat1CheckBoxes := TList.Create; //doesn't own.
  Cat1CheckBoxes.Add(ckbReview1Test);
  Cat1CheckBoxes.Add(ckbReview2Tests);
  Cat1CheckBoxes.Add(ckbReview3Tests);
  Cat1CheckBoxes.Add(ckbOrder1Test);
  Cat1CheckBoxes.Add(ckbOrder2Tests);
  Cat1CheckBoxes.Add(ckbOrder3Tests);
  Cat1CheckBoxes.Add(ckbReview1ExtDoc);
  Cat1CheckBoxes.Add(ckbReview2ExtDocs);
  Cat1CheckBoxes.Add(ckbReview3ExtDocs);

  cpPanelNewOrOldPt := TCollapsablePanel.Create('cpNewOrOldPt', sbMain, nil, OpensUpDown, pnlNewOrOldPatient, CommonLog);
  cpPanelNewOrOldPt.Top := pnlBottom.Height;     //Was 0... moved to accomodate pnlBottom to be on the top
  cpPanelNewOrOldPt.Left := 0;
  cpPanelNewOrOldPt.Width := 600;
  cpFirst := cpPanelNewOrOldPt;
  cpPanelNewOrOldPt.OnStartOpenStateClick := HandleStartOpenStateChange;
  cpPanelNewOrOldPt.OnEndOpenStateClick := HandleEndOpenStateChange;
  cpPanelNewOrOldPt.Initialize(OpenPanel);

  Self.Width := cpPanelNewOrOldPt.Width + 10 + 6;

  cpPanelNewOrOldPt.OpenState := OpenPanel;

  {
  memBillingModeHint.lines.add('|TMG MDM HELPER TEXT|');
  GetTemplateText(memBillingModeHint.Lines);
  if pos('NOTE',memBillingModeHint.Lines.Text)>0 then memBillingModeHint.Color := clRed
  else memBillingModeHint.Color := clSkyBlue;
  }

  tRadioButton(rgBillingMode.Controls[2]).enabled := False;        //added 1/16/25 to suppress AUDIO ONLY, without removing it

  {$IFNDEF STAND_ALONE_APP}
  CPTAvgPayments := TStringList.Create();
  tCallV(CPTAvgPayments,'TMG CPRS GET AVG INS CHARGES',[Patient.DFN]);
  LoadPaymentInformation(CPTAvgPayments);
  CPTAvgPayments.Free;
  {$ENDIF}
end;

{$IFNDEF STAND_ALONE_APP}
procedure TfrmMDMGrid.LoadPaymentInformation(CPTAvgPayments:TStringList);
   procedure ReplaceControlText(Control:TRadioGroup; Text:string);
   var CPT,Avg,High,Low,Charge : string;
       i : integer;
   begin
      CPT := piece(Text,'^',1);
      Charge := piece(Text,'^',2);
      Avg := piece(Text,'^',3);
      High := piece(Text,'^',4);
      Low := piece(Text,'^',5);
      for i := 0 to Control.ControlCount-1 do begin
         if pos(CPT,TRadioButton(Control.Controls[i]).Caption)>0 then begin
            if pos('99417',TRadioButton(Control.Controls[i]).Caption)>0 then continue;
            if pos(' + ',TRadioButton(Control.Controls[i]).Caption)>0 then continue;
            TRadioButton(Control.Controls[i]).Caption := piece2(TRadioButton(Control.Controls[i]).Caption,CPT,1)+CPT+' [Avg $'+Avg+'] '+piece2(TRadioButton(Control.Controls[i]).Caption,CPT,2);
            TRadioButton(Control.Controls[i]).Hint := 'Charge: $'+Charge+' Avg: $'+Avg+' High: $'+High+' Low: $'+Low;
            TRadioButton(Control.Controls[i]).ShowHint := True;
         end;
      end;
   end;

   function AddChargeStrToVariable(Text:string):string;
   var CPT,Avg,High,Low,Charge : string;
   begin
     CPT := piece(Text,'^',1);
     Charge := piece(Text,'^',2);
     Avg := piece(Text,'^',3);
     High := piece(Text,'^',4);
     Low := piece(Text,'^',5);
     Result := 'Charge: $'+Charge+' Avg: $'+Avg+' High: $'+High+' Low: $'+Low;
   end;
var
  i : integer;
  CPT:string;
begin
  for I := 0 to CPTAvgPayments.Count - 1 do begin
      CPT := piece(CPTAvgPayments[i],'^',1);
      if CPT='99212' then ChargeStr99212 := AddChargeStrToVariable(CPTAvgPayments[i]);
      if CPT='99213' then ChargeStr99213 := AddChargeStrToVariable(CPTAvgPayments[i]);
      if CPT='99214' then ChargeStr99214 := AddChargeStrToVariable(CPTAvgPayments[i]);
      if CPT='99215' then ChargeStr99215 := AddChargeStrToVariable(CPTAvgPayments[i]);
      ReplaceControlText(rgOldCPE,CPTAvgPayments[i]);
      ReplaceControlText(rgNewCPE,CPTAvgPayments[i]);
      ReplaceControlText(rgTelemedTimeAmount,CPTAvgPayments[i]);
      ReplaceControlText(rgNewPtTimeAmount,CPTAvgPayments[i]);
      ReplaceControlText(rgOldPtTimeAmount,CPTAvgPayments[i]);
  end;
end;
{$ENDIF}

procedure TfrmMDMGrid.FormDestroy(Sender: TObject);
begin
  FreeAndNil(cpPanelNewOrOldPt);
  FreeAndNil(cpBillingMode);
  FreeAndNil(cpNewPtTimeAmount);
  FreeAndNil(cpOldPtTimeAmount);
  FreeAndNil(cpComplexity);
  FreeAndNil(cpTestsData);
  FreeAndNil(cpRisk);
  FreeAndNil(cpMDM3ColHolder);
  FTableStrings.Free;
  FTextTable.Free;
  FHTMLTable.Free;
  Cat1CheckBoxes.Free; //doesn't own items
end;

procedure TfrmMDMGrid.HandleStartOpenStateChange(Sender : TObject);
begin
end;

procedure TfrmMDMGrid.HandleEndOpenStateChange(Sender : TObject);
begin
  //LogEvent('HandleEndOpenStateChange');
  SizeFrame;
end;


procedure TfrmMDMGrid.SizeFrame();
var
  MaxRight  : integer;
  MaxBottom : integer;
  cp : TCollapsablePanel;
  ARect : TRect;
begin
  //MaxRight := 0;
  MaxBottom := 0;
  cp := cpFirst;
  LogEvent('In SizeFrame');
  repeat
    ARect := cp.CurrentRect;
    MaxRight := Max(ARect.Right, MaxRight);
    MaxBottom := Max(ARect.Bottom, MaxBottom);
    LogEvent('  After considering panel ['+cp.name+'], MaxBottom='+IntToStr(MaxBottom)+'.');
    cp := cp.UnitAfter;
  until cp = nil;
  Self.Height := MaxBottom + pnlBottom.Height + 28 + 6;
  //Self.Width := MaxRight + 6;
  LogEvent('  Setting self Height: '+ IntToStr(MaxBottom)+'+ pnlBottom.Height + 28 + 6 = ' + IntToStr(Self.Height));
  if assigned(FOnFrameSize) then FOnFrameSize(Self);
end;


procedure TfrmMDMGrid.FreeCollapsablePanel(var ACollapsablePanel: TCollapsablePanel);
begin
  if assigned(ACollapsablePanel) then begin
    LogEvent('FreeCollapsablePanel for Collapsable Panel: '+ACollapsablePanel.Name);
    if ACollapsablePanel.OwnsPanel = false then begin
      ACollapsablePanel.DisplayPanel.Visible := false;
      ACollapsablePanel.DisplayPanel.Parent := sbMain;
      ACollapsablePanel.DisplayPanel.Width := ACollapsablePanel.DisplayPanelOriginalSize.X;
      ACollapsablePanel.DisplayPanel.Height := ACollapsablePanel.DisplayPanelOriginalSize.Y;
    end; //note: if ACollapsablePanel.OwnsPanel = true, it will be freed in the destructor for ACollapsablePanel
    if assigned(ACollapsablePanel.UnitBefore) then ACollapsablePanel.UnitBefore.UnitAfter := nil;
    //FreeAndNil(ACollapsablePanel);
    //ACollapsablePanel.Free;
    ACollapsablePanel.Destroy;  //<-- for some reason, Destructor wasn't being called with either .Free or FreeAndNil().  ??Compiler bug??  Try again later...
    ACollapsablePanel := nil;
  end;
end;

procedure TfrmMDMGrid.ClearMDM3ColView;
begin
  //LogEvent('ClearMDMVeiw');
  FreeCollapsablePanel(cpRisk);
  FreeCollapsablePanel(cpTestsData);
  FreeCollapsablePanel(cpComplexity);
  FreeCollapsablePanel(cpMDM3ColHolder);
end;

procedure TfrmMDMGrid.ClearOldTimeAmountView;
begin
  //LogEvent('ClearOldTimeAmountView');
  FreeCollapsablePanel(cpOldPtTimeAmount);
end;

procedure TfrmMDMGrid.ClearNewTimeAmountView;
begin
  LogEvent('ClearNewTimeAmountView');
  FreeCollapsablePanel(cpNewPtTimeAmount);
end;

procedure TfrmMDMGrid.ClearTimeView;
begin
  //LogEvent('ClearTimeView');
  ClearOldTimeAmountView;
  ClearNewTimeAmountView;
end;

procedure TfrmMDMGrid.ClearTelemedTimeView;
begin
  //LogEvent('ClearTelemedTimeView');
  FreeCollapsablePanel(cpTelemedTimeAmount);
end;

procedure TfrmMDMGrid.ClearCPEView;
begin
  LogEvent('ClearCPEView');
  FreeCollapsablePanel(cpNewCPE);
  FreeCollapsablePanel(cpOldCPE);
end;

procedure TfrmMDMGrid.SetupTimeView(AUnitBefore : TCollapsablePanel);
begin
  LogEvent('SetupTimeView');
  if FPatientType = ptNew then begin
    ClearOldTimeAmountView;
    if cpNewPtTimeAmount<>nil then FreeAndNil(cpNewPtTimeAmount);
    cpNewPtTimeAmount := TCollapsablePanel.Create('cpNewPtTimeAmount', sbMain, AUnitBefore, OpensUpDown, pnlNewPtTimeAmount, CommonLog);
    cpNewPtTimeAmount.CommonLog := CommonLog;
    cpNewPtTimeAmount.RefreshHandler := rgNewPtTimeAmountClick;
    cpNewPtTimeAmount.OnStartOpenStateClick := HandleStartOpenStateChange;
    cpNewPtTimeAmount.OnEndOpenStateClick := HandleEndOpenStateChange;
    memNewPtTimeInfo.Lines.Clear;
    memNewPtTimeInfo.Lines.Add('|TMG TIME WITH PATIENT TODAY VERBOSE W MSG|');
    {$IFNDEF STAND_ALONE_APP}
    GetTemplateText(memNewPtTimeInfo.Lines);
    {$ENDIF}
    cpNewPtTimeAmount.Initialize(OpenPanel);
    rgNewPtTimeAmountClick(self);
  end else begin
    ClearNewTimeAmountView;
    if cpOldPtTimeAmount<>nil then FreeAndNil(cpOldPtTimeAmount);
    cpOldPtTimeAmount := TCollapsablePanel.Create('cpOldPtTimeAmount', sbMain, AUnitBefore, OpensUpDown, pnlOldPtTimeAmount, CommonLog);
    cpOldPtTimeAmount.CommonLog := CommonLog;
    cpOldPtTimeAmount.RefreshHandler := rgOldPtTimeAmountClick;
    cpOldPtTimeAmount.OnStartOpenStateClick := HandleStartOpenStateChange;
    cpOldPtTimeAmount.OnEndOpenStateClick := HandleEndOpenStateChange;
    memOldPtTimeInfo.Lines.Clear;
    memOldPtTimeInfo.Lines.Add('|TMG TIME WITH PATIENT TODAY VERBOSE W MSG|');
   {$IFNDEF STAND_ALONE_APP}
    GetTemplateText(memOldPtTimeInfo.Lines);
    {$ENDIF}
    cpOldPtTimeAmount.Initialize(OpenPanel);
    rgOldPtTimeAmountClick(Self);
  end;
end;

procedure TfrmMDMGrid.SetupTelemedTimeView(AUnitBefore : TCollapsablePanel);
begin
  LogEvent('SetupTelemedTimeView');
  FreeAndNil(cpTelemedTimeAmount);
  cpTelemedTimeAmount := TCollapsablePanel.Create('cpTelemedTimeAmount', sbMain, AUnitBefore, OpensUpDown, pnlTelemedTimeAmount, CommonLog);
  cpTelemedTimeAmount.CommonLog := CommonLog;
  cpTelemedTimeAmount.RefreshHandler := rgTelemedTimeAmountClick;
  cpTelemedTimeAmount.OnStartOpenStateClick := HandleStartOpenStateChange;
  cpTelemedTimeAmount.OnEndOpenStateClick := HandleEndOpenStateChange;
  memTelemedTimeAmount.Lines.Clear;
  memTelemedTimeAmount.Lines.Add('|TMG TIME WITH PATIENT TODAY VERBOSE|');
  {$IFNDEF STAND_ALONE_APP}
  GetTemplateText(memTelemedTimeAmount.Lines);
  {$ENDIF}
  cpTelemedTimeAmount.Initialize(OpenPanel);
  rgTelemedTimeAmountClick(self);
end;

procedure TfrmMDMGrid.SetupComplexityView(AUnitBefore : TCollapsablePanel);
var NeededHt : integer;
    FrmEncounterFrame : TfrmEncounterFrame;
    Delta : integer;
    ExtraHeight:integer;
begin
  LogEvent('SetupComplexityView');
  FreeAndNil(cpMDM3ColHolder);
  cpMDM3ColHolder := TCollapsablePanel.Create('cpMDM3ColHolder', sbMain, AUnitBefore, OpensUpDown, nil, CommonLog);
  cpMDM3ColHolder.RefreshHandler := rgNewPtTimeAmountClick;
  cpMDM3ColHolder.OnStartOpenStateClick := HandleStartOpenStateChange;
  cpMDM3ColHolder.OnEndOpenStateClick := HandleEndOpenStateChange;
  cpMDM3ColHolder.Initialize(OpenPanel);

  FreeAndNil(cpComplexity);
  cpComplexity := TCollapsablePanel.Create('cpComplexity', cpMDM3ColHolder.DisplayPanel, ZERO_POINT, OpensLeftRight, pnlComplexity, CommonLog);
  cpComplexity.Initialize(OpenPanel);
  cpComplexity.RefreshHandler := rgComplexityLevelClick;

  FreeAndNil(cpTestsData);
  cpTestsData := TCollapsablePanel.Create('cpTestsData', cpMDM3ColHolder.DisplayPanel, cpComplexity, OpensLeftRight, pnlTestsDocs, CommonLog);
  cpTestsData.Initialize(ClosedPanel);
  cpTestsData.RefreshHandler := HandleReviewTestsChange;

  FreeAndNil(cpRisk);
  cpRisk := TCollapsablePanel.Create('cpRisk', cpMDM3ColHolder.DisplayPanel, cpTestsData, OpensLeftRight, pnlRisk, CommonLog);
  cpRisk.Initialize(ClosedPanel);
  cpRisk.RefreshHandler := rgRiskClick;

  //kt 1/9/24
  if FEmbeddedMode and Assigned(FEncounterFrame) and (FEncounterFrame is TfrmEncounterFrame) then begin
    FrmEncounterFrame := TfrmEncounterFrame(FEncounterFrame);
    //Ensure HolderForm is large enough to show MDM content.
    ExtraHeight := 140;
    NeededHt := cpMDM3ColHolder.Top +  cpMDM3ColHolder.Height + ExtraHeight;
    Delta := NeededHt - FrmEncounterFrame.Height;
    if Delta > 0 then begin
      FrmEncounterFrame.Height := FrmEncounterFrame.Height + Delta;  //resizing entire for should automatically resize pnlLeft (I think)
    end;
  end;


end;

procedure TfrmMDMGrid.SetupCPEView(AUnitBefore : TCollapsablePanel);
begin
  LogEvent('SetupCPEView');
  if FPatientType = ptNew then begin
    if cpNewCPE <> nil then FreeAndNil(cpNewCPE);
    cpNewCPE := TCollapsablePanel.Create('cpNewCPE', sbMain, AUnitBefore, OpensUpDown, pnlNewCPE, CommonLog);
    cpNewCPE.RefreshHandler := rgNewCPEClick;
    cpNewCPE.OnStartOpenStateClick := HandleStartOpenStateChange;
    cpNewCPE.OnEndOpenStateClick := HandleEndOpenStateChange;
    cpNewCPE.Initialize(OpenPanel);
    rgNewCPEClick(self);
  end else begin
    if cpOldCPE <> nil then FreeAndNil(cpOldCPE);
    cpOldCPE := TCollapsablePanel.Create('cpOldCPE', sbMain, AUnitBefore, OpensUpDown, pnlOldCPE, CommonLog);
    cpOldCPE.RefreshHandler := rgOldCPEClick;
    cpOldCPE.OnStartOpenStateClick := HandleStartOpenStateChange;
    cpOldCPE.OnEndOpenStateClick := HandleEndOpenStateChange;
    cpOldCPE.Initialize(OpenPanel);
    rgOldCPEClick(self);
  end;
end;

procedure TfrmMDMGrid.Reset;
begin
  ClearTelemedTimeView;
  ClearTimeView;
  ClearMDM3ColView;
  ClearCPEView;
  FreeCollapsablePanel(cpBillingMode);
  rgNewOrOldPatient.ItemIndex := -1;
  cpPanelNewOrOldPt.OpenState := OpenPanel;
  InitVars;
  RefreshOutput();
end;

procedure TfrmMDMGrid.SetupBasedOnBillingMode(AUnitBefore : TCollapsablePanel);
begin
  LogEvent('SetupBasedOnBillingMode');
  //RedrawSuspend(sbMain.Handle);
  ClearTelemedTimeView;
  ClearTimeView;
  ClearMDM3ColView;
  ClearCPEView;

  case FBillingMode of
    tcTime:        SetupTimeView(AUnitBefore);
    // 1/16/25  tcTelemedTime: SetupTelemedTimeView(AUnitBefore);
    tcComplexity:  SetupComplexityView(AUnitBefore);
    tcCPE:         SetupCPEView(AUnitBefore);
  end;

  CurrentDisplayState.PatientType := FPatientType;
  CurrentDisplayState.BillingMode := FBillingMode;
end;

function TfrmMDMGrid.HTMLSpc(n : integer  = 1) : string;
var i : integer;
begin
  Result := '';
  for i := 1 to n do begin
    Result := Result + '&nbsp;';
  end;
end;


procedure TfrmMDMGrid.MakeHTMLTable(SL : TStringList);  //NOTE: This is to output HTML table.  For ASCII text table, see MakeTextTable
//SL is source input.
//    for SL input, every other line will be right vs left column.
//Output is FHTMLTable
var i : integer;
    Line,StrL,StrR,s : string;

begin
  //exit;  //remove later if feature wanted...
  Line := '<table border="0" cellspacing="2" cellpadding="0" bgcolor="#d3d3d3">';
  Line := Line+'<tr><th>MEDICAL DECISION MAKING ITEM</th><th>VALUE</th></tr>';
  i := 0;
  while i< SL.count do begin
    StrL := SL[i];
    StrR := SL[i+1];
    s := '<tr bgcolor="#f2f2f2"><td>' + strL + '</td><td>' + strR + '</td></tr>';
    Line := Line+s;
    inc(i, 2);
  end;
  Line := Line+'</table>';
  FHTMLTable.Text := Line;
end;
{var
    //i : integer;
    //StrL, StrR : string;
    //s : string;
    Options : TStringList;
begin
  FHTMLTable.Clear;

  Options := TStringList.Create;
  try
    Options.Add('l-title=MEDICAL DECISION MAKING ITEM');
    Options.Add('r-title=VALUE');
    Options.Add('border=0');

    FHTMLTable.Text := uHTMLTools.Make2ColHTMLTable(SL, Options);
  finally
    Options.Free;
  end;    }


  {

  i := 0;
  while i< SL.count do begin
    StrL := ItemDef(SL, i);
    StrR := ItemDef(SL, i+1);
    inc(i, 2);
  end;

  FHTMLTable.Add('<table border=1>');

  FHTMLTable.Add('<TR><th>MEDICAL DECISION MAKING ITEM</th> <th>VALUE</th></TR>');

  i := 0;
  while i< SL.count do begin
    StrL := ItemDef(SL, i);
    StrR := ItemDef(SL, i+1);
    s := '<tr><td>' + strL + '</td><td>' + strR + '</td></tr>';
    FHTMLTable.Add(s);
    inc(i, 2);
  end;

  FHTMLTable.Add('</table>');

end;}


procedure TfrmMDMGrid.MakeTextTable(SL : TStringList);  //NOTE: This is to output ASCII text table.  For HTML table, see MakeHTMLTable
//SL is source input.
//    for SL input, every other line will be right vs left column.
//Output is FTextTable
  function padCh(ch : char; ct : integer) : string;
  var i : integer;
  begin
    Result := '';
    for i := 1 to ct do Result := Result + ch;
  end;

  function padCh2Len(s : string; width : integer; ch : char = ' ') : string;
  var w : integer;
  begin
    w := length(s);
    Result := s + padCh(ch, width - w);
  end;

  function AsciiStr(s : string) : string;
  begin
    Result := ReplaceStr(s, '&nbsp;',' ');
  end;

var MaxWLeft, MaxWRight : integer;
    i : integer;
    StrL, StrR : string;
    s : string;
    DivLine : string;
begin
  FTextTable.Clear;

  MaxWLeft:= 0;
  MaxWRight := 0;
  i := 0;
  while i< SL.count do begin
    StrL := AsciiStr(ItemDef(SL, i));
    StrR := AsciiStr(ItemDef(SL, i+1));
    MaxWLeft := Max(MaxWLeft, Length(StrL));
    MaxWright:= Max(MaxWRight, Length(StrR));
    inc(i, 2);
  end;

  DivLine := '+' + padCh('-', MaxWLeft) + '+' + padCh('-', MaxWRight) + '+';
  FTextTable.Add(DivLine);

  i := 0;
  while i< SL.count do begin
    StrL := AsciiStr(ItemDef(SL, i));
    StrR := AsciiStr(ItemDef(SL, i+1));
    s := '|' + padCh2Len(strL, MaxWLeft) + '|' + padCh2Len(strR, MaxWRight) + '|';
    FTextTable.Add(s);
    FTextTable.Add(DivLine);
    inc(i, 2);
  end;
end;

procedure TfrmMDMGrid.RefreshOutput();
var
  Narrative, TempResult, text : string;
  BillingBasis : string;
  indent : integer;
begin
  TempResult := '';
  indent := 0;
  FOutputCPTMDM := CPT_FOR_MDM[FPatientType, FOverallComplexityScore];
  FOutputCPTTime := CPT_FOR_TIME[FPatientType, FTimeAmountIndex];
  FOuputCPTTelemedTime := CPT_FOR_TELEMED_TIME[FPatientType, FTelemedTimeAmountIndex];
  FOutputCPTCPE := CPT_FOR_CPE[FPatientType, FCPEIndex];

  FTableStrings.Clear();
  BillingBasis := NEW_OR_OLD_PATIENT_NAMES[FPatientType] + ' status & ' + BILLING_MODE[FBillingMode];
  Narrative := 'Billing based on: ' + BillingBasis + '. ' + CRLF;

  case FBillingMode of
    tcTime:
      begin
        TempResult := FOutputCPTTime;
        Narrative := Narrative + 'Time: ' + FTimeAmountNarrative;
        FTableStrings.Add('CPT code:'); FTableStrings.Add(FOutputCPTTime);
        FTableStrings.Add('Time:'); FTableStrings.Add(FTimeAmountNarrative);

        case FPatientType of
          ptNew: Text := memNewPtTimeInfo.Lines.Text;
          ptEstablished: Text := memOldPtTimeInfo.Lines.Text;
          else Text := '';
        end;
        if Text <> '' then begin
          indent := 3;
          FTableStrings.Add(HTMLSpc(indent)+'DETAIL:');
          FTableStrings.Add(HTMLSpc(indent)+Text);
        end;
      end;
    tcTelemedTime :
      begin
        TempResult := FOuputCPTTelemedTime;
        Narrative := Narrative + 'Telemedicine Time: ' + FTimeAmountNarrative;
        FTableStrings.Add('CPT code:'); FTableStrings.Add(FOuputCPTTelemedTime);
        FTableStrings.Add('Telemedicine Time:'); FTableStrings.Add(FTelemedTimeAmountNarrative);
        Text := memTelemedTimeAmount.Lines.Text;
        if Text <> '' then begin
          indent := 3;
          FTableStrings.Add(HTMLSpc(indent)+'DETAIL:');
          FTableStrings.Add(HTMLSpc(indent)+Text);
        end;
      end;
    tcComplexity :
      begin
        TempResult := FOutputCPTMDM;
        Narrative := Narrative + 'Visit Complexity: ' + FOverallComplexityNarrative;
        FTableStrings.Add('CPT code:');
          FTableStrings.Add(FOutputCPTMDM);
        FTableStrings.Add('Visit Complexity: ');
          FTableStrings.Add(COMPLEXITY_LEVEL_NAMES[FOverallComplexityScore]);
        indent := 3;
        FTableStrings.Add(HTMLSpc(indent) +SECTION_TITLES[SECT_ISSUES]+':');
          FTableStrings.Add(HTMLSpc(indent) +COMPLEXITY_LEVEL_NAMES[FNumIssuesScore]);
        FTableStrings.Add(HTMLSpc(indent*2)+'DETAIL:');
          FTableStrings.Add(HTMLSpc(indent*2)+FNumIssuesNarrrative);
        FTableStrings.Add(HTMLSpc(indent) +SECTION_TITLES[SECT_DATA]+':');
          FTableStrings.Add(HTMLSpc(indent) +COMPLEXITY_LEVEL_NAMES[FDataScore]);
        FTableStrings.Add(HTMLSpc(indent*2)+'DETAIL:');
          FTableStrings.Add(HTMLSpc(indent*2)+ FDataNarrative);
        FTableStrings.Add(HTMLSpc(indent) +SECTION_TITLES[SECT_RISK]+':');
          FTableStrings.Add(HTMLSpc(indent) +COMPLEXITY_LEVEL_NAMES[FRiskScore]);
        FTableStrings.Add(HTMLSpc(indent*2)+'DETAIL:');
          FTableStrings.Add(HTMLSpc(indent*2)+ FRiskNarrative);
      end;
    tcCPE :
      begin
        TempResult := FOutputCPTCPE;
        Narrative := Narrative + 'Preventative Visit / CPE: ' + FCPENarrative;
        FTableStrings.Add('CPT code:'); FTableStrings.Add(FOutputCPTCPE);
        FTableStrings.Add('Preventative Visit / CPE:'); FTableStrings.Add(FCPENarrative);
      end

    else begin
      TempResult := 'undefined';
      FTableStrings.Add('CPT code:'); FTableStrings.Add('undefined');
    end;
  end;

  MakeTextTable(FTableStrings);  //Output is info FTextTable
  MakeHTMLTable(FTableStrings);  //Output is info FHTMLTable

  FOverallCPTOutput := TempResult;
  lblChargeDetails.Caption := '';
  if TempResult = '99212' then lblChargeDetails.Caption := ChargeStr99212;
  if TempResult = '99213' then lblChargeDetails.Caption := ChargeStr99213;
  if TempResult = '99214' then lblChargeDetails.Caption := ChargeStr99214;
  if TempResult = '99215' then lblChargeDetails.Caption := ChargeStr99215;
  FOverallNarrative := Narrative;
  if TempResult = 'undefined' then TempResult := '';  //kt 1/16/23
  lblResultValue.Caption := TempResult;
  btnOK.Enabled := (TempResult <> '');
  btnOKRelaunch.Enabled := (TempResult <> '');
end;

function TfrmMDMGrid.GetCPTOutput : string;
begin
  RefreshOutput;
  Result := FOverallCPTOutput;
end;

function TfrmMDMGrid.GetNarrative :  string;
begin
  RefreshOutput;
  Result := FOverallNarrative;
end;

procedure TfrmMDMGrid.RecalcOverallComplexity();
  function Highest2of3(n1, n2, n3 : TComplexityLevel) : TComplexityLevel;
  var Counts: array[clMin .. clHigh] of integer;
      i, j : TComplexityLevel;
  begin
    Result := clUndef;
    for i := clMin to clHigh do Counts[i] := 0;
    inc(Counts[n1]);
    inc(Counts[n2]);
    inc(Counts[n3]);

    //A higher level also counts as a lower level.
    //  E.g. 1 mod + 1 high is same as 2 moderate
    //       1 min + 1 high is same as 2 min
    for i := clLow to clHigh do begin
      for j := Pred(i) downto clMin do begin
        Counts[j] := Counts[j] + Counts[i];
      end;
    end;

    for i := clHigh downto clUndef do begin
      if Counts[i] < 2 then continue;
      Result := i;
      break;
    end;
  end;

begin
  FOverallComplexityScore := Highest2Of3(FNumIssuesScore, FDataScore, FRiskScore);
  FOverallComplexityNarrative := COMPLEXITY_LEVEL_NAMES[FOverallComplexityScore] + '.  ' + CRLF +
    SECTION_TITLES[SECT_ISSUES] + ' = ' + COMPLEXITY_LEVEL_NAMES[FNumIssuesScore] + ' (' + FNumIssuesNarrrative + '); ' + CRLF +
    SECTION_TITLES[SECT_DATA]   + ' = ' + COMPLEXITY_LEVEL_NAMES[FDataScore]      + ' (' + FDataNarrative + '); ' + CRLF +
    SECTION_TITLES[SECT_RISK]   + ' = ' + COMPLEXITY_LEVEL_NAMES[FRiskScore]      + ' (' + FRiskNarrative + ').';
  RefreshOutput();
end;


//Data input change handlers ----------------------------------------

procedure TfrmMDMGrid.HandleReviewTestsChange(Sender: TObject);
var
  Cat1Points, Cat1bPoints, Cat2Points, Cat3Points : integer;
  i : integer;
  ckb : TCheckbox;
  Narrative : string;

  function InGroup(Sender: TObject; ckb1, ckb2, ckb3 : TCheckBox) : boolean;
  begin
    Result := (Sender = ckb1) or (Sender = ckb2) or (Sender = ckb3);
  end;

  procedure AllowJustOne(Sender: TObject; ckb1, ckb2, ckb3 : TCheckBox);
  begin
    ckb1.Checked := (Sender = ckb1);
    ckb2.Checked := (Sender = ckb2);
    ckb3.Checked := (Sender = ckb3);
  end;

  procedure AddNarrative(var Narrative : string; text : string);
  begin
    if Narrative <> '' then Narrative := Narrative + ', ';
    Narrative := Narrative + text;
  end;

begin
  if not (Sender is TCheckBox) then exit;
  ckb := TCheckBox(Sender);
  if InHandleReviewTestsChange then exit;  //avoid recursion
  InHandleReviewTestsChange := true;
  FDataNarrative := '';

  if ckb.Checked then begin
    if InGroup(Sender, ckbReview1Test, ckbReview2Tests, ckbReview3Tests) then begin
      AllowJustOne(Sender, ckbReview1Test, ckbReview2Tests, ckbReview3Tests);
    end;

    if InGroup(Sender, ckbOrder1Test, ckbOrder2Tests, ckbOrder3Tests) then begin
      AllowJustOne(Sender, ckbOrder1Test, ckbOrder2Tests, ckbOrder3Tests);
    end;

    if InGroup(Sender, ckbReview1ExtDoc, ckbReview2ExtDocs, ckbReview3ExtDocs) then begin
      AllowJustOne(Sender, ckbReview1ExtDoc, ckbReview2ExtDocs, ckbReview3ExtDocs);
    end;
  end;

  Narrative := '';
  Cat1Points  := 0;
  Cat1bPoints := 0;
  Cat2Points  := 0;
  Cat3Points  := 0;

  for i := 0 to Cat1CheckBoxes.Count - 1 do begin
    ckb := TCheckBox(Cat1CheckBoxes[i]);
    if not ckb.checked then continue;
    Inc(Cat1Points, ckb.Tag);  //.tag holds number of points for item.
    AddNarrative(Narrative, ckb.Caption);
  end;

  if ckbIndHistorian.Checked then begin
    inc(Cat1bPoints);
    AddNarrative(Narrative, ckbIndHistorian.Caption);
  end;

  if ckbIndInterpret.Checked then begin
    inc(Cat2Points);
    AddNarrative(Narrative, ckbIndInterpret.Caption);
  end;

  if ckbDiscussExternal.Checked then begin
    inc(Cat3Points);
    AddNarrative(Narrative, ckbDiscussExternal.Caption);
  end;

  if NumOf3((Cat1Points+Cat1bPoints)>=3, Cat2Points>=1, Cat3Points>=1) >= 2 then begin
    FDataScore := clHigh;
  end else if NumOf3((Cat1Points+Cat1bPoints)>=3, Cat2Points>=1, Cat3Points>=1) >= 1 then begin
    FDataScore := clMod;
  end else if NumOf2(Cat1Points>=2, Cat1bPoints>=1) >= 1 then begin
    FDataScore := clLow;
  end else begin
    FDataScore := clMin;
  end;

  FDataNarrative := Narrative;
  lblDataScore.Caption := COMPLEXITY_LEVEL_NAMES[FDataScore];
  lblDataScoreTitle.Visible := true;
  lblDataScore.Visible := true;
  RecalcOverallComplexity;  //calls RefreshOutput
  InHandleReviewTestsChange := false;
end;

procedure TfrmMDMGrid.btnNextSectionClick(Sender: TObject);
begin
  LogEvent('btnNextSectionClick');
  cpTestsData.OpenState := ClosedPanel;
  if assigned(cpTestsData.UnitAfter) then begin
    cpTestsData.UnitAfter.OpenState := OpenPanel;
  end;
end;

procedure TfrmMDMGrid.btnOKClick(Sender: TObject);
begin
  FFormSuccess := true;
  if FEmbeddedMode then begin
    if assigned(FOnCloseForm) then begin
      FOnCloseForm(self);
    end;
    //Reset;  //Consider resetting form to initial state....
  end else begin
    self.Close;
  end;
end;

procedure TfrmMDMGrid.btnOKRelaunchClick(Sender: TObject);
begin
  Relaunch := True;
  btnOKClick(Sender);
end;

procedure TfrmMDMGrid.rgNewPtTimeAmountClick(Sender: TObject);
var i : integer;
begin
  LogEvent('rgNewPtTimeAmountClick');
  i := rgNewPtTimeAmount.ItemIndex;
  FTimeAmountNarrative := ItemDef(rgNewPtTimeAmount.Items, i, UNDEFINED);
  if assigned(cpNewPtTimeAmount) then cpNewPtTimeAmount.ClosedCaption := FTimeAmountNarrative;
  FNewPtTimeAmountIndex := i;
  FTimeAmountIndex := i;
  RefreshOutput;
end;

procedure TfrmMDMGrid.rgOldCPEClick(Sender: TObject);
var i : integer;
begin
  LogEvent('rgOldCPEClick');
  i := rgOldCPE.ItemIndex;
  FCPENarrative := ItemDef(rgOldCPE.Items, i, UNDEFINED);
  if assigned(cpOldCPE) then cpOldCPE.ClosedCaption := FCPENarrative;
  FCPEIndex := i;
  RefreshOutput;
end;

procedure TfrmMDMGrid.rgOldPtTimeAmountClick(Sender: TObject);
var i : integer;
begin
  LogEvent('rgOldPtTimeAmountClick');
  i := rgOldPtTimeAmount.ItemIndex;
  FTimeAmountNarrative := ItemDef(rgOldPtTimeAmount.Items, i, UNDEFINED);
  if assigned(cpOldPtTimeAmount) then cpOldPtTimeAmount.ClosedCaption := FTimeAmountNarrative;
  FOldPtTimeAmountIndex := i;
  FTimeAmountIndex := i;
  RefreshOutput;
end;

procedure TfrmMDMGrid.rgRiskClick(Sender: TObject);
begin
  LogEvent('rgRiskClick');
  memExampleRiskMod.Visible := rgRisk.ItemIndex = 2;
  memExampleRiskHigh.Visible := rgRisk.ItemIndex = 3;
  memExampleRiskHigh.Top := memExampleRiskMod.Top;
  FRiskScore := TComplexityLevel(rgRisk.ItemIndex);
  FRiskNarrative := ItemDef(rgRisk.Items, rgRisk.ItemIndex, '') +
    ' risk of mobidity from additional/future diagnostic testing or treatment';
  RecalcOverallComplexity;  //calls RefreshOutput
end;

procedure TfrmMDMGrid.rgTelemedTimeAmountClick(Sender: TObject);
var i : integer;
begin
  LogEvent('rgTelemedTimeAmountClick');
  i := rgTelemedTimeAmount.ItemIndex;
  FTelemedTimeAmountNarrative := ItemDef(rgTelemedTimeAmount.Items, i, UNDEFINED);
  if assigned(cpTelemedTimeAmount) then cpTelemedTimeAmount.ClosedCaption := FTelemedTimeAmountNarrative;
  FTelemedTimeAmountIndex := i;
  RefreshOutput;
end;

procedure TfrmMDMGrid.rgComplexityLevelClick(Sender: TObject);
var Narrative : string;

    function rgText(rg : TRadioGroup) : string;
    begin
      result := rg.Caption + ': ' + ItemDef(rg.Items, rg.ItemIndex, '');
    end;

begin
  if not assigned(Sender) then exit;
  if not (Sender is TRadioGroup) then exit;

  LogEvent('rgComplexityLevelClick');
  FNumIssuesNarrrative := '';
  Narrative := '';

  if Sender = rgMinimal then begin
    FNumIssuesScore := clMin;
    Narrative := rgText(rgMinimal);
  end else begin
    rgMinimal.ItemIndex := -1;
  end;

  if Sender = rgLow then begin
    FNumIssuesScore := clLow;
    Narrative := rgText(rgLow);
  end else begin
    rgLow.ItemIndex := -1;
  end;

  if Sender = rgModerate then begin
    FNumIssuesScore := clMod;
    Narrative := rgText(rgModerate);
  end else begin
    rgModerate.ItemIndex := -1;
  end;

  if Sender = rgHigh then begin
    FNumIssuesScore := clHigh;
    Narrative := rgText(rgHigh);
  end else begin
    rgHigh.ItemIndex := -1;
  end;

  FNumIssuesNarrrative := Narrative;
  RecalcOverallComplexity;  //calls RefreshOutput
  cpComplexity.OpenState := ClosedPanel;
  if assigned(cpComplexity.UnitAfter) then begin
    cpComplexity.UnitAfter.OpenState := OpenPanel;
  end;
end;

procedure TfrmMDMGrid.rgNewCPEClick(Sender: TObject);
var i : integer;
begin
  LogEvent('rgNewCPEClick');
  i := rgNewCPE.ItemIndex;
  FCPENarrative := ItemDef(rgNewCPE.Items, i, UNDEFINED);
  if assigned(cpNewCPE) then cpNewCPE.ClosedCaption := FCPENarrative;
  FCPEIndex := i;
  RefreshOutput;
end;

procedure TfrmMDMGrid.rgNewOrOldPatientClick(Sender: TObject);
var s,TiuTemplate : string;
begin
  LogEvent('rgNewOrOldPatientClick');
  if not assigned(cpBillingMode) then begin
    cpBillingMode := TCollapsablePanel.Create('cpBillingMode', sbMain, cpPanelNewOrOldPt, OpensUpDown, pnlBillingMode, CommonLog);
    cpBillingMode.RefreshHandler := rgBillingModeClick;
    cpBillingMode.OnStartOpenStateClick := HandleStartOpenStateChange;
    cpBillingMode.OnEndOpenStateClick := HandleEndOpenStateChange;
    cpBillingMode.Initialize(ClosedPanel);  //parent must be set before calling Initialize
    rgBillingMode.ItemIndex := -1;
  end;

  //in case these had been opened.
  ClearMDM3ColView;
  ClearTimeView;
  ClearTelemedTimeView;

  FPatientType := TPatientType(rgNewOrOldPatient.ItemIndex);
  s := NEW_OR_OLD_PATIENT_NAMES[FPatientType];
  FPatientTypeText := s;
  cpPanelNewOrOldPt.ClosedCaption := s;

  if FPatientType=ptNew then TiuTemplate := 'TMG MDM NEW HELPER TEXT'
  else TiuTemplate := 'TMG MDM HELPER TEXT';

  memBillingModeHint.Lines.Clear;
  memBillingModeHint.lines.add('|'+TiuTemplate+'|');
  {$IFNDEF STAND_ALONE_APP}
  GetTemplateText(memBillingModeHint.Lines);
  {$ENDIF}
  if pos('NOTE',memBillingModeHint.Lines.Text)>0 then memBillingModeHint.Color := clRed
  else memBillingModeHint.Color := clSkyBlue;

  cpPanelNewOrOldPt.OpenState := ClosedPanel;
  if assigned(cpPanelNewOrOldPt.UnitAfter) then cpPanelNewOrOldPt.UnitAfter.OpenState := OpenPanel;
  cpPanelNewOrOldPt.Refresh;
  Application.processmessages; //debug
end;

procedure TfrmMDMGrid.rgBillingModeClick(Sender: TObject);
var AMode : TBillingModeType;

begin
  AMode := TBillingModeType(rgBillingMode.ItemIndex);
  if AMode = tcUndef then exit; //This function is called during a refresh, before user clicks.
  if (AMode = CurrentDisplayState.BillingMode) and (CurrentDisplayState.PatientType = FPatientType) then exit; //don't reload if no change.
  FBillingMode := AMode;

  if assigned(cpBillingMode) then cpBillingMode.ClosedCaption := BILLING_MODE_CAPTION[FBillingMode];
  FTimeOrComplexityModeText := BILLING_MODE[FBillingMode];
  cpBillingMode.OpenState := ClosedPanel;
  SetupBasedOnBillingMode(cpBillingMode);
  RefreshOutput;
end;

procedure TfrmMDMGrid.LogEvent(S : string);
begin
  if Assigned(CommonLog) then begin
    CommonLog.Add('MDMHelper: ' + S);
  end;
end;

procedure TfrmMDMGrid.SetEmbeddedMode(value : boolean; HolderForm : TForm = nil);
begin
  if value = FEmbeddedMode then exit;
  FEmbeddedMode := value;
  FEncounterFrame := HolderForm;
  if FEmbeddedMode then begin
    btnOK.Caption := '&Use Code';
    //btnOK.Enabled := true;
    //btnOK.Visible := true;
    btnOK.ModalResult := mrNone;
    btnCancel.Visible := false;
    btnOKRelaunch.Visible := False;
    BorderStyle := bsNone;
  end else begin
    btnOK.Caption := '&OK';
    btnOK.ModalResult := mrOK;
    btnCancel.Visible := true;
    btnOKRelaunch.Visible := True;
    BorderStyle := bsToolWindow;
  end;


end;



initialization
  frmMDMGrid := nil;

end.
