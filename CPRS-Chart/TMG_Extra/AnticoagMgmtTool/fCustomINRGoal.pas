unit fCustomINRGoal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,
  ORFn;

type
  TfrmCustomINRGoal = class(TForm)
    lblMinINRGoal: TLabel;
    edtMin: TEdit;
    lblMaxINRGoal: TLabel;
    edtMax: TEdit;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    procedure edtMinChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    { Private declarations }
    Fkillme : string;
    procedure CheckValidity;
    function GetLoGoal() : string;
    function GetHiGoal() : string;
    function GetGoalStr() : string;
    procedure SetGoalStr(Value : string);
  public
    { Public declarations }
    property LoGoal : string read GetLoGoal;
    property HiGoal : string read GetHiGoal;
    property GoalStr : string read GetGoalStr write SetGoalStr;
  end;

//var
//  frmCustomINRGoal: TfrmCustomINRGoal;

implementation

{$R *.dfm}

const
  VALID_COLOR : array[false .. true] of TColor = (TColor($CCCCFF), clWindow);

procedure TfrmCustomINRGoal.edtMinChange(Sender: TObject);
begin
 CheckValidity();
end;

procedure TfrmCustomINRGoal.FormShow(Sender: TObject);
begin
  CheckValidity();
  edtMin.SetFocus();
end;

function TfrmCustomINRGoal.GetLoGoal : string;
begin
  Result := Trim(edtMin.Text);
end;

function TfrmCustomINRGoal.GetHiGoal() : string;
begin
  Result := Trim(edtMax.Text);
end;

function TfrmCustomINRGoal.GetGoalStr() : string;
begin
  Result := LoGoal+'-'+HiGoal;
end;

procedure TfrmCustomINRGoal.SetGoalStr(Value : string);
var Lo, Hi : string;
begin
  Lo := ''; Hi := '';
  if Pos('-', Value)> 0 then begin
    Lo := Trim(piece(Value, '-', 1));
    Hi := Trim(piece(Value, '-', 2));
  end;
  edtMin.Text := Lo;
  edtMax.Text := Hi;

end;

procedure TfrmCustomINRGoal.CheckValidity();
var fLo, fHi : single;
    ValidLo, ValidHi : boolean;
begin
  fLo := StrToFloatDef(LoGoal,0);
  fHi := StrToFloatDef(HiGoal,0);
  ValidLo := (fLo >= 1) and (fLo < 4);
  ValidHi := (fHi > 2) and (fHi < 5);
  edtMin.color := VALID_COLOR[ValidLo];
  edtMax.color := VALID_COLOR[ValidHi];
  btnOK.Enabled := ValidLo and ValidHi;
end;


end.
