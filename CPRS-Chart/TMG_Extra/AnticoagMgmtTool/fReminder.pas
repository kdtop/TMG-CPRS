unit fReminder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  ORCtrls, ORFn, ORNet, Trpcb, uTypesACM, Buttons,
  ExtCtrls;

type
  TfrmReminder = class(TForm)
    lblRemindText: TLabel;
    memRemind: TMemo;
    btnClear: TButton;
    pnlDTColorRing: TPanel;
    dtpRemind: TDateTimePicker;
    lblRemDate: TLabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure memRemindChange(Sender: TObject);
    procedure dtpRemindChange(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
    FPatient : TPatient;
    //FStatus : tReminderStatus;
    FDate : TDate;
    procedure CheckForOKEnable();
    function GetReminderText : TStrings;
  public
    { Public declarations }
    procedure Initialize (APatient : TPatient);
    function ReminderStr : string;
    function DisplayStr : string;
    function DateStr : string;
    function CaptionForButton : string;
    procedure PopupBoxIfAppropriate();
    //property Status : tReminderStatus read FStatus;
    property ReminderText : TStrings read GetReminderText;
  end;

//var
//  frmReminder: TfrmReminder;

procedure PopupReminderBoxIfAppropriate(Patient : TPatient);
function CaptionForReminderButton(Patient : TPatient) : string;


implementation

{$R *.dfm}

uses
  uUtility;

procedure PopupReminderBoxIfAppropriate(Patient : TPatient);
var  frmReminder: TfrmReminder;
begin
  if Patient.ReminderTextSL.Text = '' then exit;
  frmReminder := TfrmReminder.Create(Application);
  try
    frmReminder.Initialize(Patient);
    frmReminder.PopupBoxIfAppropriate;
  finally
    frmReminder.Free;
  end;
end;

function CaptionForReminderButton(Patient : TPatient) : string;
begin
  if Patient.ReminderTextSL.Count > 0 then begin
    Result := 'View &Reminder';
  end else begin
    Result := 'Set &Reminder';
  end;
end;

  //--------------------------------------

procedure TfrmReminder.btnClearClick(Sender: TObject);
begin
  //FStatus := trmUndef;      //clear reminder  //was 2
  memRemind.Clear;
  dtpRemind.Date := Now;
  CheckForOKEnable();
end;

procedure TfrmReminder.CheckForOKEnable();
var Empty, OK : boolean;
const
  VALID_COLOR : array[false .. true] of TColor = (clLightRed, clBtnFace);   //kt added
begin
  Empty := (memRemind.Lines.Text = '');
  OK := Empty or (not Empty and IsFutureDate(FDate));
  btnOK.Enabled := OK;
  pnlDTColorRing.color := VALID_COLOR[OK];
end;

function TfrmReminder.GetReminderText : TStrings;
begin
  Result := memRemind.Lines;
end;


procedure TfrmReminder.dtpRemindChange(Sender: TObject);
begin
  FDate := dtpRemind.Date;
  CheckForOKEnable();
end;

procedure TfrmReminder.FormCreate(Sender: TObject);
begin
  //FStatus := trmUndef;
  dtpRemind.Date := Now;
end;

procedure TfrmReminder.FormShow(Sender: TObject);
begin
  dtpRemind.SetFocus;
  CheckForOKEnable;
end;

procedure TfrmReminder.Initialize (APatient : TPatient);
begin
  FPatient := APatient;
  memRemind.Lines.Assign(APatient.ReminderTextSL);
  if APatient.ReminderDate > 0 then begin
    dtpRemind.Date := APatient.ReminderDate;
  end else begin
    dtpRemind.Date := Now;
  end;
end;

procedure TfrmReminder.memRemindChange(Sender: TObject);
begin
  CheckForOKEnable();
end;

function TfrmReminder.ReminderStr : string;
begin
  Result := ListToPieces(memRemind.Lines);
end;

function TfrmReminder.DisplayStr : string;
var x : integer;
begin
  Result := '';
  for x := 0 to (memRemind.Lines.Count-1) do begin
    Result := Result + memRemind.Lines[x] + ' ';
  end;
end;


function TfrmReminder.DateStr : string;
begin
  Result := DateToStr(FDate);
end;

procedure TfrmReminder.PopupBoxIfAppropriate();
var MessageStr, s : string;
begin
  s := DisplayStr;
  if (s <> '') and IsPastDate(FDate) then begin
    MessageStr := 'Anticoagulation Reminder message for ' + FPatient.Name + ': ' + #13#10 +
                   DisplayStr;
    InfoBox(MessageStr, 'Reminder', MB_OK or MB_ICONINFORMATION);
  end;
end;

function TfrmReminder.CaptionForButton : string;
begin
  if  DisplayStr <> '' then begin
    Result := 'View &Reminder';
  end else begin
    Result := 'Set &Reminder';
  end;
end;


end.
