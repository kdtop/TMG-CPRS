unit fPickTemplateVar;
//VEFA-261 Added entire unit

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, RichEdit, ComCtrls, StrUtils,
  fBase508Form, VA508AccessibilityManager;

type
  TfrmPickTemplateVar = class(TfrmBase508Form)
    reTemplateCopy: TRichEdit;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    lblPickOne: TLabel;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    lblSelected: TLabel;
    lblSelTitle: TLabel;
    procedure reTemplateCopyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    RE: TRichEdit;
  public
    { Public declarations }
    VarName: string;
    constructor Create(AOwner: TComponent; ARichEdit : TRichEdit);
  end;

var
  frmPickTemplateVar: TfrmPickTemplateVar;

implementation

{$R *.dfm}

uses
  fFormulaHelper;

const
  FN_TAG = '{FN:';


function VarNameAtPos(Text : string; P : integer) : string;
//Assumes that P is positioned at beginning of FN_TAG
var s : string;
    P2 : integer;
begin
  Result := '';
  P := P + Length(FN_TAG);
  s := Midstr(Text, P, Length(Text));
  P2 := Pos('^H:',s);
  if P2=0 then P2 := Pos(':',s);
  if P2=0 then exit;
  s := MidStr(s, 1, P2-1);
  if (Pos('[',s)>0) or (Pos(#13,s)>0) or (Pos(#10,s)>0) then exit;  //Ignore [FLD:SomeName]
  Result := s;
end;


Function HighlightVarNames(RichEdit: TRichEdit;  Color: TColor) : boolean;
//Returns TRUE if something was highlighted
var Format: CHARFORMAT2;
    BegPos : integer;
    s, Text : string;

begin
  Result := false;
  if not assigned(RichEdit) then exit;
  FillChar(Format, sizeof(Format), 0);
  Format.cbsize := Sizeof(Format);
  Format.dwMask := CFM_BACKCOLOR;
  Text := RichEdit.Text;

  BegPos := Pos(FN_TAG, Text);
  while BegPos > 0 do begin
    s := VarNameAtPos(Text, BegPos);
    BegPos := BegPos + Length(FN_TAG);
    if s <> '' then begin
      //Do highlighting
      RichEdit.SelStart := BegPos-1;
      RichEdit.SelLength := length(s);
      Format.crBackColor := Color;
      RichEdit.Perform(EM_SETCHARFORMAT, SCF_SELECTION, LongInt(@Format));
      Result := true;
    end;
    BegPos := PosEx(FN_TAG, Text, BegPos);
  end;
  RichEdit.SelStart := 0;
  RichEdit.SelLength := 0;
end;


constructor TfrmPickTemplateVar.Create(AOwner: TComponent; ARichEdit : TRichEdit);
begin
  inherited Create(AOwner);
  RE := ARichEdit;
  reTemplateCopy.Lines.Assign(ARichEdit.Lines);
  //reTemplateCopyClick(Self);
end;

procedure TfrmPickTemplateVar.FormShow(Sender: TObject);
begin
  if not HighlightVarNames(reTemplateCopy, clWebYellow) then begin
    MessageDlg('NONE FOUND!'+#13#10+
               'A storage variable name my be created when editing a function.',mtWarning,[mbOK],0);
  end;
end;

procedure TfrmPickTemplateVar.reTemplateCopyClick(Sender: TObject);
var IsGood : boolean;
    P : integer;
    Text : string;
begin
  Text := reTemplateCopy.Text;
  if Text = '' then exit;
  p := reTemplateCopy.SelStart;
  while p > 0 do begin
    if Text[p] = FN_TAG[1] then break;
    Dec(p);
  end;
  if Text[p]<>FN_TAG[1] then exit;
  VarName := VarNameAtPos(Text, p);
  IsGood := (VarName <> '');
  if IsGood then VarName := '[FN:'+VarName+']';
  btnOK.Enabled := IsGood;
  lblSelected.Caption := VarName;
  lblSelTitle.Visible := IsGood;
  lblSelected.Visible := IsGood;
end;

end.

