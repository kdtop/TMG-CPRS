unit fUnlockPatient;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics,
  Forms, Dialogs,
  StdCtrls, Buttons, Controls, Classes, ExtCtrls;

type
  TfrmUnlockPatient = class(TForm)
    pnlPtLookUp: TPanel;
    lblLast4: TLabel;
    lblLU: TLabel;
    cboPtSel: TComboBox;
    btnUnlock: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnUnlockClick(Sender: TObject);
    procedure cboPtSelChange(Sender: TObject);
  private
    { Private declarations }
    SL : TStringList;
    FSelectedDFN : string;
    procedure Refresh;
  public
    { Public declarations }
  end;

//var
//  frmUnlockPatient: TfrmUnlockPatient;

implementation

{$R *.dfm}

uses
  rRPCsACM, uUtility, ORFn;

procedure TfrmUnlockPatient.btnUnlockClick(Sender: TObject);
begin
  if FSelectedDFN = '' then exit;
  UnlockPatient(FSelectedDFN);
  ModalResult := mrOK; //will close form.
end;

procedure TfrmUnlockPatient.cboPtSelChange(Sender: TObject);
var  Index : integer;
begin
  Index := cboPTSel.ItemIndex;
  if Index >=0 then FSelectedDFN := Piece(SL[Index],'^',1)
  else FSelectedDFN := '';
  btnUnlock.Enabled := (FSelectedDFN <> '');
end;

procedure TfrmUnlockPatient.FormCreate(Sender: TObject);
begin
  SL := TStringList.Create;
  cboPtSel.Tag := integer(pointer(SL));  //kt This will have a 1:1 relationship between RPC source and .Items display
end;

procedure TfrmUnlockPatient.FormDestroy(Sender: TObject);
begin
  SL.Free;
end;

procedure TfrmUnlockPatient.FormShow(Sender: TObject);
begin
  Refresh;
end;

procedure TfrmUnlockPatient.Refresh;
begin
  GetLockedPatients(SL);
  cboLoadFromTagItems(cboPTSel, [2]);
  if SL.Count = 0 then begin
    InfoBox('No patients are currently locked', 'No One To Unlock', MB_OK);
    exit;
  end;
  cboPtSel.ItemIndex := -1;
  cboPtSel.SetFocus;
end;


end.
