unit fEditComplications;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics,
  strUtils,
  Controls, Forms, Dialogs, Buttons, StdCtrls, ComCtrls,
  ExtCtrls, Classes;

type
  TfrmEditComplications = class(TForm)
    pnlTabEnterTabComplications: TPanel;
    lblRedLine: TLabel;
    lblComplDt: TLabel;
    lblARTReminder: TLabel;
    ckbTT: TCheckBox;
    dtpComp: TDateTimePicker;
    lblRecur: TStaticText;
    ckbCC: TCheckBox;
    lblComplications: TStaticText;
    btnOK: TBitBtn;
    btnClearComplications: TBitBtn;
    lblThrombosis: TStaticText;
    btnCancel: TBitBtn;
    Label1: TLabel;
    lblBleeding: TStaticText;
    lblComplMajor: TStaticText;
    ckbMCDeath: TCheckBox;
    ckbMCtran: TCheckBox;
    ckbMCH: TCheckBox;
    ckbMChgb: TCheckBox;
    ckbMCR: TCheckBox;
    ckbMCother: TCheckBox;
    memMinorC: TMemo;
    ckbMinorC: TCheckBox;
    memComments: TMemo;
    procedure btnClearComplicationsClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ckbComplicationClick(Sender: TObject);
    procedure ckbCCClick(Sender: TObject);
    procedure ckbMCotherClick(Sender: TObject);
  private
    { Private declarations }
    FLocalDataSL : TStringList;
    FDateStr : string;
    FComplicationScore : integer;
    FComplicationsCkbList : TStringList;
    procedure Data2GUI(DataSL : TStringList);
    procedure GUI2Data(DataSL : TStringList);
    function GetComplications : TStringList;
  public
    { Public declarations }
    function ShowModal(DataSL : TStringList; DateStr : string) : integer; overload;
    property Complications : TStringList read GetComplications;  //This is an encoded string
    property ComplicationScore : integer read FComplicationScore;
  end;

//var
//  frmEditComplications: TfrmEditComplications;

implementation

{$R *.dfm}

uses
  ORFn;

function TfrmEditComplications.ShowModal(DataSL : TStringList; DateStr : string) : integer;
begin
  FLocalDataSL.Assign(DataSL);
  FDateStr := DateStr;
  Data2GUI(FLocalDataSL);
  Result := ShowModal;
end;

procedure TfrmEditComplications.Data2GUI(DataSL : TStringList);
var CKB : TCheckBox;
    i, index : integer;
    Cmd, Line, DateStr : string;
begin
  memComments.Lines.Clear;
  FComplicationScore := 0;
  DateStr := FDateStr;
  for i := 0 to FComplicationsCkbList.Count-1 do begin
    CKB := TCheckBox(FComplicationsCkbList.Objects[i]);
    CKB.Checked := false; //default
  end;
  for i := 0 to  DataSL.Count-1 do begin
    Line := Trim(DataSL[i]);
    Cmd := '';
    if Pos(':', Line) > 0 then begin
      Cmd := Trim(UpperCase(piece(line, ':', 1)));
    end;
    if Cmd = 'C' then begin
      Line := MidStr(Line, 2, Length(Line));
      memComments.Lines.Add(Line);
      continue;
    end else if Cmd = 'MB' then begin
      Line := MidStr(Line, 4, Length(Line));
    end else if Cmd = 'DATE' then begin
      DateStr := MidStr(Line, 6, Length(Line));
      continue; //will use after loop done;
    end;
    index := FComplicationsCkbList.IndexOf(Line);
    if index < 0 then continue;
    CKB := TCheckBox(FComplicationsCkbList.Objects[index]);
    CKB.Checked := true;
  end;
  dtpComp.DateTime := StrToDateDef(DateStr, Now);
  ckbCC.Checked := (memComments.Lines.Count > 0);  //should trigger event to alter enabled
end;

procedure TfrmEditComplications.GUI2Data(DataSL : TStringList);
var Line : string;
    CKB : TCheckBox;
    i : integer;
begin
  DataSL.Clear;
  DataSL.Add('DATE:'+DateToStr(dtpComp.DateTime));
  for i := 0 to FComplicationsCkbList.Count-1 do begin
    CKB := TCheckBox(FComplicationsCkbList.Objects[i]);
    if not CKB.Checked then continue;
    case CKB.Tag of
      1 :    Line := 'Minor Bleed';
      10 :   Line := 'MB:' + CKB.Caption;
      100 :  Line := 'Thrombotic event';
      else   Line := '';
    end;
    if Line = '' then continue;
    DataSL.Add(Line);
  end;
  if ckbCC.Checked then begin
    for i := 0 to memComments.Lines.Count - 1 do begin
      DataSL.Add('C:' + memComments.Lines[i]);
    end;
  end;
end;

function TfrmEditComplications.GetComplications : TStringList;
begin
  GUI2Data(FLocalDataSL);
  Result := FLocalDataSL;
end;


procedure TfrmEditComplications.btnCancelClick(Sender: TObject);
begin
  btnClearComplicationsClick(self);
  ModalResult := mrCancel; // will close form.
end;

procedure TfrmEditComplications.btnClearComplicationsClick(Sender: TObject);
begin
 //clear here.
 FLocalDataSL.Clear;
 FDateStr := DateToStr(Now);
 Data2GUI(FLocalDataSL);
end;

procedure TfrmEditComplications.ckbCCClick(Sender: TObject);
const
  MEMO_COLORS : array[false..true] of TColor = (clGradientInactiveCaption, clWindow);
begin
  memComments.Enabled := ckbCC.Checked;
  memComments.Color := MEMO_COLORS[ckbCC.Checked];
  if ckbCC.Checked = true then begin
    if FComplicationScore < 1 then begin
      InfoBox('Please select a complication to comment on.',
              'Select Complication', MB_OK or MB_ICONEXCLAMATION);
      ckbCC.checked := false;
      exit;
    end;
    memComments.SetFocus;
  end;
end;

procedure TfrmEditComplications.ckbComplicationClick(Sender: TObject);
//NOTE: The minor complications were given score of 10, and major 1, and thrombotic 100
//      This doesn't seem to make any sense to me .  But if I change it, I think I
//      haveto change the server code too. So will continue same as the old code.
//CORRECTION: I am going to change major to 10 and minor to 1 after all.
var  CKB : TCheckBox;
const  BOOL_MULT : array[false..true] of integer = (-1, 1);
begin
  if not (Sender is TCheckBox) then exit;
  CKB := TCheckBox(Sender);
  FComplicationScore := FComplicationScore + CKB.Tag * BOOL_MULT[CKB.Checked];
  if FComplicationScore < 0 then FComplicationScore := 0;
end;

procedure TfrmEditComplications.ckbMCotherClick(Sender: TObject);
begin
  ckbComplicationClick(Sender);
  if not (Sender is TCheckBox) then exit;
  ckbCC.Checked := TCheckBox(Sender).Checked;
  if memComments.Lines.Count > 0 then ckbCC.Checked := true;
end;

procedure TfrmEditComplications.FormCreate(Sender: TObject);
begin
  FLocalDataSL := TStringList.Create;
  FComplicationsCkbList := TStringList.Create; //doesn't own objects
  FComplicationsCkbList.AddObject(ckbMCDeath.Caption, ckbMCDeath);
  FComplicationsCkbList.AddObject(ckbMCR.Caption, ckbMCR);
  FComplicationsCkbList.AddObject(ckbMCH.Caption, ckbMCH);
  FComplicationsCkbList.AddObject(ckbMChgb.Caption, ckbMChgb);
  FComplicationsCkbList.AddObject(ckbMCtran.Caption, ckbMCtran);
  FComplicationsCkbList.AddObject('Minor Bleed', ckbMinorC);
  FComplicationsCkbList.AddObject('Thrombotic event', ckbTT);
  FComplicationScore := 0;
  dtpComp.DateTime := Now;
end;

procedure TfrmEditComplications.FormDestroy(Sender: TObject);
begin
  FComplicationsCkbList.Free;
  FLocalDataSL.Free;
end;

end.
