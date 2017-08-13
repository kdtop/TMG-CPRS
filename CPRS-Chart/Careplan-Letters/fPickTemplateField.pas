unit fPickTemplateField;
//VEFA-261 Added entire unit

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmPickTemplateField = class(TfrmBase508Form)
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
    FieldName: string;
    constructor Create(AOwner: TComponent; ARichEdit : TRichEdit);
  end;

var
  frmPickTemplateField: TfrmPickTemplateField;

implementation

{$R *.dfm}

uses
  fFormulaHelper;


constructor TfrmPickTemplateField.Create(AOwner: TComponent; ARichEdit : TRichEdit);
begin
  inherited Create(AOwner);
  RE := ARichEdit;
  reTemplateCopy.Lines.Assign(ARichEdit.Lines);
  reTemplateCopyClick(Self);
end;

procedure TfrmPickTemplateField.FormShow(Sender: TObject);
begin
  HighlightTags(reTemplateCopy, '{FLD:', '}', clWebYellow);
end;

procedure TfrmPickTemplateField.reTemplateCopyClick(Sender: TObject);
var IsGood : boolean;
begin
  FieldName := GetCurrentField(reTemplateCopy, '{FLD:','}',reTemplateCopy.SelStart);
  if FieldName = '-1' then FieldName := '';
  IsGood := (FieldName <> '');
  btnOK.Enabled := IsGood;
  lblSelected.Caption := FieldName;
  lblSelTitle.Visible := IsGood;
  lblSelected.Visible := IsGood;
end;

end.

