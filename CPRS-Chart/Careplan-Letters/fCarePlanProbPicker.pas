unit fCarePlanProbPicker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ORFn, StrUtils,rCarePlans,
  Dialogs, StdCtrls, Buttons,fBase508Form, VA508AccessibilityManager;

type
  TfrmCarePlanProbPicker = class(TfrmBase508Form)
    lbxProbList: TListBox;
    lblExplain: TLabel;
    lblCPName: TLabel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    btnGoToProbs: TBitBtn;
    lblMultiInstructions: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbxProbListClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SelectionResult : TStringList;     //Format: ICDCode^Name
    TemplateID : string;
    procedure Initialize(ProbList : TStringList);
  end;

var
  frmCarePlanProbPicker: TfrmCarePlanProbPicker;

implementation

{$R *.dfm}

procedure TfrmCarePlanProbPicker.lbxProbListClick(Sender: TObject);
var i : integer;
    ICDCode, Name : string;
begin
  SelectionResult.Clear;
  for i := 0 to lbxProbList.Items.Count - 1 do begin
    if not lbxProbList.Selected[i] then continue;
    ICDCode := piece(lbxProbList.Items.Strings[i],' ',1);
    Name := Trim(pieces(lbxProbList.Items.Strings[i],' ',2,64));
    while (Name[1] in [' ','-']) and (length(Name)>1) do Name := MidStr(Name,2,999);
    SelectionResult.Add(ICDCode+'^'+Name);
  end;
  btnOK.Enabled := SelectionResult.Count > 0;
end;

procedure TfrmCarePlanProbPicker.FormCreate(Sender: TObject);
begin
  SelectionResult := TStringList.Create;
end;

procedure TfrmCarePlanProbPicker.FormDestroy(Sender: TObject);
begin
  SelectionResult.Free;
end;

procedure TfrmCarePlanProbPicker.Initialize(ProbList : TStringList);
var i : integer;
    ICDCode, Name : string;
begin
  lbxProbList.Items.Clear;
  SelectionResult.Clear;
  for i := 0 to ProbList.count - 1 do begin
    ICDCode := piece(ProbList.Strings[i],'^',1);
    Name := piece(ProbList.strings[i],'^',2);
    lbxProbList.Items.Add(ICDCode+' -- '+Name);
  end;

end;


end.

