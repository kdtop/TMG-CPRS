unit fLetterFormatting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, StrUtils,fBase508Form, VA508AccessibilityManager;

type
  TfrmLetterFormatting = class(TfrmBase508Form)
    lbCommands: TListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure lbCommandsDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Command : string;
  end;

var
  frmLetterFormatting: TfrmLetterFormatting;

implementation

{$R *.dfm}

procedure TfrmLetterFormatting.btnOKClick(Sender: TObject);
var
   arg : string;
begin
  Command := lbCommands.Items.Strings[lbCommands.ItemIndex];
  if pos('arg#',Command)>0 then begin
    arg := inputbox('Insert Command','Please enter the number of arguments, separated by commas','');
    Command := AnsiReplaceText(Command,'arg',arg);
  end else if pos('arg',Command)>0 then begin
    arg := inputbox('Insert Command','Please enter desired argument','');
    Command := AnsiReplaceText(Command,'arg',arg);
  end;
end;

procedure TfrmLetterFormatting.FormShow(Sender: TObject);
begin
  Command := '';
end;

procedure TfrmLetterFormatting.lbCommandsDblClick(Sender: TObject);
begin
  btnOKClick(self);
  frmLetterFormatting.ModalResult := mrOK;
end;

end.

