unit fLetterEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Menus,fBase508Form, VA508AccessibilityManager;

type
  TfrmLetterEditor = class(TfrmBase508Form)
    Label1: TLabel;
    editLetterName: TEdit;
    memoLetterText: TMemo;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    MainMenu1: TMainMenu;
    Insert1: TMenuItem;
    Field1: TMenuItem;
    Formatting1: TMenuItem;
    Exit1: TMenuItem;
    procedure Formatting1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure editLetterNameChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    boolEditing : boolean;
  end;

var
  frmLetterEditor: TfrmLetterEditor;

implementation

uses
   fLetterFormatting;

{$R *.dfm}

procedure TfrmLetterEditor.editLetterNameChange(Sender: TObject);
begin
  if boolEditing then
    frmLetterEditor.Caption := 'Editing: ' + editLetterName.Text
  else
    frmLetterEditor.Caption := 'Creating: ' + editLetterName.Text;
end;

procedure TfrmLetterEditor.Exit1Click(Sender: TObject);
begin
  //Check if Dirty
  exit;
end;

procedure TfrmLetterEditor.Formatting1Click(Sender: TObject);
begin
   frmLetterFormatting.showmodal;
   if frmLetterFormatting.Command <> '' then begin
     memoLetterText.SelLength := 0;
     memoLetterText.SelText := frmLetterFormatting.Command;
   end;
end;

end.

