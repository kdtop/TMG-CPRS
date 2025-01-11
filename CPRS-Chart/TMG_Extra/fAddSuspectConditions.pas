unit fAddSuspectConditions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ORCtrls, Buttons, DateUtils, ORNet, ORFn, uCore;

type
  TfrmAddSuspectConditions = class(TForm)
    btnClose: TBitBtn;
    ORListBox1: TORListBox;
    btnAddThisCondition: TBitBtn;
    RadioGroup1: TRadioGroup;
    edtCodeToAdd: TEdit;
    Label1: TLabel;
    chkAlreadyReviewed: TCheckBox;
    procedure btnAddThisConditionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure AddSuspectMedicalConditions;

var
  frmAddSuspectConditions: TfrmAddSuspectConditions;

implementation

{$R *.dfm}
procedure AddSuspectMedicalConditions;
var
  frmAddSuspectConditions: TfrmAddSuspectConditions;
begin
  frmAddSuspectConditions := TfrmAddSuspectConditions.create(nil);
  frmAddSuspectConditions.ShowModal;
  frmAddSuspectConditions.Free;
end;

procedure TfrmAddSuspectConditions.btnAddThisConditionClick(Sender: TObject);
var Result : String;
    Code,Year : String;
    Reviewed:string;
begin
  inherited;
  Code := edtCodeToAdd.Text;
  if Code='' then exit;
  if RadioGroup1.ItemIndex=0 then Year:=inttostr(YearOf(Date));
  if RadioGroup1.ItemIndex=1 then Year:='9999';
  if chkAlreadyReviewed.Checked then Reviewed := '1'
  else Reviewed := '0';  
  Result := sCallV('TMG CPRS ADD SUSPECT CONDITION',[Patient.DFN,Code,Year,Reviewed]);
  if piece(Result,'^',1)='-1' then begin
    ShowMessage(piece(Result,'^',2));
  end else begin
    ORListBox1.Items.Add(piece(Result,'^',2));
    edtCodeToAdd.Text := '';
  end;
end;

end.

