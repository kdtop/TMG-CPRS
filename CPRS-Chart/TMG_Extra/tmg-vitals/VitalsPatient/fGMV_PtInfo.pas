unit fGMV_PtInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TfraGMV_PatientInfo = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    memInfo: TMemo;
    bbtnPrint: TBitBtn;
    PrintDialog1: TPrintDialog;
    btnClose: TButton;
    btnOK: TButton;
    pnlTop: TPanel;
    procedure bbtnPrintClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fraGMV_PatientInfo: TfraGMV_PatientInfo;

procedure ShowPatientInfo(aPatientID:String);
procedure ShowPatientAllergies(const PatientDFN: string);
procedure ShowInfo(aTitle,anInfo:String;ShowPrint:Boolean=False;aLinePos:Integer=1);
function AskConfirmation(aTitle,aQuestion,anInfo:String):Word;

implementation

uses uGMV_Common,Printers
, uGMV_Const
, uGMV_GlobalVars, uGMV_Engine
  ;

procedure SkipStartBlanks(aMemo:TMemo);
var
  s: String;
  iSel,
  i: integer;
begin
  i := 1;
  iSel := 0;
  with aMemo do
    begin
      while i < Length(Text) do
        begin
          s := Copy(Text,i,1);
          if (s = ' ') or (s=#13) or (s=#10) then
              inc(iSel)
          else break;
          inc(i);
        end;
      selStart := iSel;
    end;
end;

{$R *.DFM}
procedure ShowPatientInfo(aPatientID:String);
var
  SL: TStringList;
begin
  try
    fraGMV_PatientInfo := TfraGMV_PatientInfo.Create(nil);
    with fraGMV_PatientInfo do
      begin
        memInfo.Clear;

        SL := getPatientINQInfo(GMVInquiryName, aPatientID);
        memInfo.Lines.Assign(SL);
        SkipStartBlanks(memInfo);
        ActiveControl := memInfo;
        ShowModal;
//        Free;
      end;
    SL.Free;
  finally
    FreeAndNil(fraGMV_PatientInfo);
  end;
end;

procedure ShowPatientAllergies(const PatientDFN: string);
var
  RetList:TStrings;
begin
  with TfraGMV_PatientInfo.Create(Application) do
  try
    Caption := 'Patient Allergies';
    bbtnPrint.Visible := False;
    RetList := getPatientAllergies(PatientDFN);
    memInfo.Lines.Assign(RetList);
    ShowModal;
  finally
    Free;
  end;
  RetList.Free;
end;

procedure ShowInfo(aTitle,anInfo:String;ShowPrint:Boolean=False;aLinePos:Integer=1);
var
  i: Integer;
  iCount: Integer;
begin
  if not Assigned(FraGMV_PatientInfo) then
    Application.CreateForm(TFraGMV_PatientInfo,fraGMV_PatientInfo);
  with fraGMV_PatientInfo do
  try
    Caption := aTitle;
    bbtnPrint.Visible := ShowPrint;
    ActiveControl := memInfo;
    memInfo.Lines.Text := anInfo;
{$IFDEF T20}
// vhaishandria 060324 =======================================================//
    iCount := 0;
    i := 1;
    while i < Length(anInfo)-1 do
      begin
        if copy(anInfo,i,1) = #10 then
          begin
            inc(iCount);
            if iCount >= aLinePos then break;
          end;
        inc(i);
      end;
    memInfo.SelStart := i;
    memInfo.SelLength := 0;
    memInfo.Perform(WM_VSCROLL, SB_TOP,0);
    for i := 1 to aLinePos do
      memInfo.Perform(WM_VSCROLL, SB_LINEDOWN,0);
//======================================================= vhaishandria 060324 //
{$ENDIF}
    ShowModal;
  finally
  end;
end;

function AskConfirmation(aTitle,aQuestion,anInfo:String):Word;
begin
  if not Assigned(FraGMV_PatientInfo) then
    Application.CreateForm(TFraGMV_PatientInfo,fraGMV_PatientInfo);
  with fraGMV_PatientInfo do
  try
    Caption := aTitle;
    width := 500;
    bbtnPrint.Visible := False;
    ActiveControl := memInfo;
    memInfo.Lines.Text := anInfo;
    memInfo.Color := clBtnFace;
    btnOK.Visible := True;
    pnlTop.Visible := True;
    pnlTop.Caption := aQuestion;
    memInfo.BorderStyle := bsNone;
    btnClose.Caption := 'Cancel';
    memInfo.ScrollBars := ssVertical;
    Result := ShowModal;
  finally
    freeandNil(fraGMV_PatientInfo);
  end;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_PatientInfo.bbtnPrintClick(Sender: TObject);
var
  Line: Integer;
  PrintText: TextFile;   {declares a file variable}
begin
  if PrintDialog1.Execute then
  begin
    AssignPrn(PrintText);   {assigns PrintText to the printer}
    Rewrite(PrintText);     {creates and opens the output file}
    Printer.Canvas.Font := memInfo.Font;  {assigns Font settings to the canvas}
    for Line := 0 to memInfo.Lines.Count - 1 do
      {writes the contents of the Memo1 to the printer object}
      Writeln(PrintText,'        '+ memInfo.Lines[Line]);
    CloseFile(PrintText); {Closes the printer variable}
  end;
end;

procedure TfraGMV_PatientInfo.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TfraGMV_PatientInfo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
end;

end.
