unit fFollowUp;
//kt //TMG added entire form 1/19/2023

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  VAUtils,  Math, StrUtils,
  Dialogs, fPCEBase, VA508AccessibilityManager, StdCtrls, Buttons, ExtCtrls,
  ComCtrls;

type
  TfrmFollowUp = class(TfrmPCEBase)
    Panel1: TPanel;
    lblFreeTxtFU: TLabel;
    Shape1: TShape;
    lblGroup: TLabel;
    lblFor: TLabel;
    lblWith: TLabel;
    btnGroupA: TSpeedButton;
    btnGroupB: TSpeedButton;
    btnGroupC: TSpeedButton;
    btnCPE: TSpeedButton;
    btnAWV: TSpeedButton;
    btnNoPap: TSpeedButton;
    btnRecheck: TSpeedButton;
    btnDrKT: TSpeedButton;
    btnDrDT: TSpeedButton;
    btn1Week: TSpeedButton;
    btn2Weeks: TSpeedButton;
    btn3Weeks: TSpeedButton;
    btn1Month: TSpeedButton;
    btn2Months: TSpeedButton;
    btn3Months: TSpeedButton;
    btn4Months: TSpeedButton;
    btn6Months: TSpeedButton;
    btn1Yr: TSpeedButton;
    btn2Yrs: TSpeedButton;
    btnAsPrev: TSpeedButton;
    edtFreeTxtFU: TEdit;
    DateTimePicker: TDateTimePicker;
    edtGroupFreeTxt: TEdit;
    edtFUReason: TEdit;       
    edtApptWith: TEdit;
    rgTelemed: TRadioButton;
    rgInOffice: TRadioButton;
    memOutput: TMemo;
    btnNext: TBitBtn;
    procedure btnNextClick(Sender: TObject);
    procedure btnIntervalClick(Sender: TObject);
    procedure edtApptWithChange(Sender: TObject);
    procedure DateTimePickerChange(Sender: TObject);
    procedure edtFUReasonChange(Sender: TObject);
    procedure rgLocationClick(Sender: TObject);
    procedure edtGroupFreeTxtChange(Sender: TObject);
    procedure btnProviderClick(Sender: TObject);
    procedure btnGroupABCClick(Sender: TObject);
    procedure btnReasonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtFreeTxtFUChange(Sender: TObject);
  private
    { Private declarations }
    FUInterval : string;
    GrpStr : string;
    ReasonStr : string;
    ProviderStr : string;
    LocationStr : string;
    NetOutput : string;
    HTMLNetOutput : string;
    FIntervalList : TStringList;
    FGroupABCList : TList;
    FReasonList : TList;
    FProviderList : TList;
    FAllBtns : TList;
    FRGList : TList;
    procedure TurnOffOtherIntervals(Btn : TSpeedButton);
    procedure ToggleBtnState(Btn : TSpeedButton);
    procedure SetBtnState(Btn : TSpeedButton; OnState: boolean);
    procedure InitData;
    procedure UpdateFollowUpTime;
    procedure UpdateGroupOutput;
    procedure UpdateRGLocationOutput;
    procedure UpdateNetOutput;
  public
    { Public declarations }
    procedure SendData;  //kt
    constructor CreateLinked(AParent: TWinControl);
  end;

var
  frmFollowUp: TfrmFollowUp;

implementation

{$R *.dfm}

uses
  fEncounterFrame, fNotes;

const BTN_BACKGROUND_COLOR = $8080FF;  //light red.  was clMaroon;

constructor TfrmFollowUp.CreateLinked(AParent: TWinControl);
begin
  AutoSizeDisabled := true;  //<--- this turns off crazy form resizing from parent forms.
  inherited;
end;


procedure TfrmFollowUp.FormCreate(Sender: TObject);
begin
  FTabName := CT_TMG_FolwUpNm;    // <-- required!

  btnOK.Height := 32;
  btnOK.Top := Self.Height - BtnOK.Height - 5;
  btnCancel.Height := 32;
  btnCancel.Top := BtnOK.Top;
  btnNext.Top := Self.Height - BtnNext.Height - 5;

  FGroupABCList := TList.Create;  //doesn't own objects.
  FReasonList := TList.Create;  //doesn't own objects.
  FProviderList := TList.Create;  //doesn't own objects.
  FRGList := TList.Create;   //doesn't own objects.
  FAllBtns := TList.Create; //doesn't own objects
  FIntervalList := TStringList.Create;   //doesn't own objects.

  InitData;
end;

procedure TfrmFollowUp.FormDestroy(Sender: TObject);
  procedure ClearBtnBackground(Btn : TSpeedButton);
  var APanel : TPanel;
  begin
    APanel := TPanel(Btn.Parent);
    Btn.Parent := APanel.Parent;
    APanel.Free;
  end;
var i : integer;
begin
  FGroupABCList.Free;  //doesn't own objects.
  FReasonList.Free;  //doesn't own objects.
  FProviderList.Free; //Doesn't own objects
  FRGList.Free; //Doesn't own objects
  FIntervalList.Free;   //doesn't own objects.
  //clear parent panels
  for i := 0 to FAllBtns.Count - 1 do begin
    ClearBtnBackground(TSpeedButton(FAllBtns[i]));
  end;
  FAllBtns.Free; //doesn't own objects

  inherited;
end;

procedure TfrmFollowUp.DateTimePickerChange(Sender: TObject);
begin
  inherited;
  TurnOffOtherIntervals(nil);
  edtFreeTxtFU.Text := 'On ' + DateToStr(DateTimePicker.Date);    //this will trigger change handler --> update net output
end;

procedure TfrmFollowUp.edtApptWithChange(Sender: TObject);
var Str : string;
begin
  inherited;
  Str := edtApptWith.Text;
  ProviderStr := IfThen(Str <> '', 'with '+str, '');
  UpdateNetOutput();
end;

procedure TfrmFollowUp.edtFreeTxtFUChange(Sender: TObject);
begin
  inherited;
  FUInterval := edtFreeTxtFU.Text;
  UpdateFollowUpTime;  //this will itself trigger updating net output;
end;

procedure TfrmFollowUp.edtFUReasonChange(Sender: TObject);
begin
  inherited;
  ReasonStr := edtFUReason.Text;
  //if ReasonStr <> '' then ReasonStr := 'For ' + ReasonStr;
  UpdateNetOutput();
end;

procedure TfrmFollowUp.edtGroupFreeTxtChange(Sender: TObject);
begin
  inherited;
  //NOTE: When group A, B, or C buttons are changed, they should trigger this handler.
  UpdateGroupOutput();  //this will itself trigger updating net output;
end;

procedure TfrmFollowUp.btnGroupABCClick(Sender: TObject);
var Btn : TSpeedButton;
    i : integer;
    Str : string;
begin
  inherited;
  if not (Sender is TSpeedButton) then exit;
  Btn := TSpeedButton(Sender);
  ToggleBtnState(Btn);
  //Update output
  Str := '';
  for i := 0 to FGroupABCList.Count-1 do begin
    Btn := TSpeedButton(FGroupABCList[i]);
    if Btn.Tag = 0 then continue;
    if Str <> '' then Str := Str + ',';
    Str := Str + Btn.Caption;
  end;
  edtGroupFreeTxt.Text := Str;
  //NOTE: By setting text, this should trigger it's onchange handler, which will trigger UpdateNetOutput
end;

procedure TfrmFollowUp.btnIntervalClick(Sender: TObject);
var i : integer;
    Btn : TSpeedButton;
begin
  inherited;
  i := FIntervalList.IndexOfObject(Sender);
  if i = -1 then exit;
  Btn := TSpeedButton(FIntervalList.Objects[i]);
  ToggleBtnState(Btn);
  TurnOffOtherIntervals(Btn);
  edtFreeTxtFU.Text := Btn.Caption;    //this will trigger change handler --> update net output.
end;

procedure TfrmFollowUp.btnNextClick(Sender: TObject);
begin
  inherited;
  frmEncounterFrame.SelectNextTab;
end;

procedure TfrmFollowUp.btnProviderClick(Sender: TObject);
var Btn,OtherBtn : TSpeedButton;
    i,j : integer;
    Str : string;
begin
  inherited;
  //if not (Sender is TSpeedButton) then exit;
  Btn := TSpeedButton(Sender);
  ToggleBtnState(Btn);
  //Turn other button off
  i := FProviderList.IndexOf(Btn);
  if i >= 0 then begin
    j := IfThen(i=0, 1, 0);
    OtherBtn := TSpeedButton(FProviderList[j]);
    SetBtnState(OtherBtn, false);
  end;

  Str := '';
  for i := 0 to FProviderList.Count - 1 do begin
    Btn := TSpeedButton(FProviderList[i]);
    if Btn.Tag = 0 then continue;
    Str := Btn.Caption;
  end;
  edtApptWith.Text := Str; //this will trigger change handler --> UpdateNetOutput
end;

procedure TfrmFollowUp.btnReasonClick(Sender: TObject);
var Btn : TSpeedButton;
    i : integer;
    Str : string;
const
  NO_PAP_INDEX = 2;

begin
  inherited;
  if not (Sender is TSpeedButton) then exit;
  Btn := TSpeedButton(Sender);
  ToggleBtnState(Btn);
  //Prep text to put into edtFUReasonf
  Str := '';
  for i := 0 to FReasonList.Count - 1 do begin
    Btn := TSpeedButton(FReasonList[i]);
    if Btn.Tag = 0 then continue;
    if (Str <> '') then begin
      Str := Str + IfThen(i = NO_PAP_INDEX, ' (', ', ');
    end;
    Str := Str + Btn.Caption;
    Str := Str + IfThen(i = NO_PAP_INDEX, ') ', '');
  end;
  edtFUReason.Text := Str;   //this will trigger event handler --> UpdateNetOutput
end;

procedure TfrmFollowUp.rgLocationClick(Sender: TObject);
var RG,OtherRG : TRadioButton;
    i,j : integer;
begin
  inherited;
  if not (Sender is TRadioButton) then exit;
  RG := TRadioButton(Sender);
  //Turn other button off
  i := FRGList.IndexOf(RG);
  if i >= 0 then begin
    j := IfThen(i=0, 1, 0);
    OtherRG := TRadioButton(FRGList[j]);
    OtherRG.Checked := false;
  end;
  UpdateRGLocationOutput; //this will trigger update net output
  //
end;

//=====================================================================

procedure TfrmFollowUp.TurnOffOtherIntervals(Btn : TSpeedButton);
var i : integer;
    Btn2 : TSpeedButton;
begin
  for i := 0 to FIntervalList.Count - 1 do begin
    Btn2 := TSpeedButton(FIntervalList.Objects[i]);
    if Btn2 = Btn then continue;
    if Btn2.Tag = 0 then continue;
    SetBtnState(Btn2, false);
  end;
end;

procedure TfrmFollowUp.UpdateFollowUpTime;
begin
  FUInterval := edtFreeTxtFU.Text + ' or sooner if needed ';
  UpdateNetOutput;
end;

procedure TfrmFollowUp.UpdateGroupOutput;
var Str : string;
begin
  Str := edtGroupFreeTxt.Text;
  //GrpStr := IfThen(Str <> '', 'for group ' + Str + ' problems ', '');
  GrpStr := IfThen(Str <> '', 'group ' + Str + ' problems ', '');
  UpdateNetOutput();
end;

procedure TfrmFollowUp.UpdateRGLocationOutput;
var RG : TRadioButton;
    i : integer;
begin
   LocationStr := '';
  for i := 0 to FProviderList.Count - 1 do begin
    RG := TRadioButton(FRGList[i]);
    if RG.Checked = false then continue;
    LocationStr := RG.Caption;
    break;
  end;
  UpdateNetOutput();
end;

procedure TfrmFollowUp.UpdateNetOutput;
  function Add(Prior, AddOn : string) : string;
  begin
    Result := Prior + IfThen(AddOn <> '', ' ', '') + AddOn;
  end;
var ForString:String;
const PREFIX = 'FOLLOW UP APPT: ';
begin
  ForString := IfThen(ReasonStr <> '', ReasonStr, '');
  ForString := ForString + IfThen(ForString <> '', ' and ', '') + IfThen(GrpStr <> '', GrpStr, '');
  ForString := IfThen(ForString <> '', 'for ', '') + ForString;
  NetOutput := '';
  NetOutput := Add(NetOutput, FUInterval);
  NetOutput := Add(NetOutput, ForString);
  //NetOutput := Add(NetOutput, GrpStr);
  //NetOutput := Add(NetOutput, ReasonStr);
  NetOutput := Add(NetOutput, ProviderStr);
  NetOutput := Add(NetOutput, LocationStr);

  NetOutput := PREFIX + NetOutput;
  HTMLNetOutput := '<B>'+ PREFIX + '</B>' + NetOutput;

  memOutput.Text := NetOutput;

end;


procedure TfrmFollowUp.SetBtnState(Btn : TSpeedButton; OnState: boolean);
//NOTE: I will be using .tag as a boolean state variable.  1=ON, 0=OFF
begin
  if OnState then begin
    Btn.Font.Style := Btn.Font.Style + [fsBold];
  end else begin
    Btn.Font.Style := Btn.Font.Style - [fsBold];
  end;
  Btn.Down := OnState;
  Btn.Tag := IfThen(OnState, 1, 0);
  Btn.Flat := OnState;
  Btn.Transparent := OnState;
end;

procedure TfrmFollowUp.ToggleBtnState(Btn : TSpeedButton);
//NOTE: I will be using .tag as a boolean state variable.  1=ON, 0=OFF
var CurState : boolean;
begin
  CurState := (Btn.Tag = 1);
  SetBtnState(Btn, not CurState);
end;

procedure TfrmFollowUp.InitData;
  procedure FixBtn(Btn : TSpeedButton);
  var APanel : TPanel;
  begin
    APanel := TPanel.Create(Self);
    APanel.Caption := '';
    APanel.Color := BTN_BACKGROUND_COLOR;
    APanel.Parent := Btn.Parent;
    Btn.Parent := APanel;
    APanel.Top := Btn.Top;
    APanel.Left := Btn.Left;
    APanel.Width := Btn.Width;
    APanel.Height := Btn.Height;
    Btn.Top := 0;
    Btn.Left := 0;
    Btn.Flat := false;  //set true later to let color show through
    Btn.Transparent := false;  //set true later to let color show through
  end;

var i : integer;
begin
  FIntervalList.AddObject('1 Week',btn1Week);
  FIntervalList.AddObject('2 Weeks',btn2Weeks);
  FIntervalList.AddObject('3 Weeks',btn3Weeks);
  FIntervalList.AddObject('1 Month',btn1Month);
  FIntervalList.AddObject('2 Months',btn2Months);
  FIntervalList.AddObject('3 Months',btn3Months);
  FIntervalList.AddObject('4 Months',btn4Months);
  FIntervalList.AddObject('6 Months',btn6Months);
  FIntervalList.AddObject('1 Year',btn1Yr);
  FIntervalList.AddObject('2 Years',btn2Yrs);
  FIntervalList.AddObject('As Previously Scheduled',btnAsPrev);

  FGroupABCList.Add(btnGroupA);
  FGroupABCList.Add(btnGroupB);
  FGroupABCList.Add(btnGroupC);

  FReasonList.Add(btnCPE);
  FReasonList.Add(btnAWV);
  FReasonList.Add(btnNoPap);
  FReasonList.Add(btnRecheck);

  FProviderList.Add(btnDrKT);
  FProviderList.Add(btnDrDT);

  FRGList.Add(rgTelemed);
  FRGList.Add(rgInOffice);

  for i := 0 to FIntervalList.Count - 1 do begin
    FAllBtns.Add(FIntervalList.Objects[i]);
  end;
  for i := 0 to FGroupABCList.Count - 1 do begin
    FAllBtns.Add(FGroupABCList[i]);
  end;
  for i := 0 to FReasonList.Count - 1 do begin
    FAllBtns.Add(FReasonList[i]);
  end;
  for i := 0 to FProviderList.Count - 1 do begin
    FAllBtns.Add(FProviderList[i]);
  end;

  for i := 0 to FAllBtns.Count - 1 do begin
    FixBtn(TSpeedButton(FAllBtns[i]));
  end;

  FUInterval := '';
  GrpStr := '';
  ReasonStr := '';
  ProviderStr := '';
  LocationStr := '';
  NetOutput := '';
  HTMLNetOutput := '';
end;


procedure TfrmFollowUp.SendData;  //kt
var Tag, InsertStr, Result : string;
begin
  if not Assigned(frmNotes) then exit;
  Tag := '[*FOLLOWUP*]';
  InsertStr := memOutput.Text;
  if InsertStr = '' then exit;
  InsertStr := '<B>FOLLOW UP APPT:</B>' + InsertStr + '<DIV name="*FOLLOWUP*"></DIV>';
  Result := frmNotes.WMReplaceHTMLText(Tag,InsertStr);
  if piece(Result,'^',1) <> '1' then begin
    MessageDlg(piece(Result,'^',2), mtError, [mbOK], 0);
  end;
end;


end.
