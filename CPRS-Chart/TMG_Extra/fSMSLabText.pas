unit fSMSLabText;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmSMSLabText = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    editPhone: TEdit;
    editMessage: TEdit;
    btnSend: TBitBtn;
    btnCancel: TBitBtn;
    procedure btnSendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSMSLabText: TfrmSMSLabText;
  procedure OpenSMSLabText;

implementation

uses  uTMGOptions,ORNet;

procedure OpenSMSLabText();
var frmSMSLabText : TfrmSMSLabText;
begin
   frmSMSLabText := TfrmSMSLabText.Create(Application);
   frmSMSLabText.editPhone.Text := uTMGOptions.ReadString('SMS LAB NUMBER','');
   frmSMSLabText.editMessage.Text := uTMGOptions.ReadString('SMS LAB MESSAGE','');
   frmSMSLabText.ShowModal;
   frmSMSLabText.Free;
end;

{$R *.dfm}

procedure TfrmSMSLabText.btnSendClick(Sender: TObject);
var response:integer;
begin
  response := messagedlg('Ok to send message to :'+editPhone.text,mtinformation,[mbYes,mbNo],0);
  if response=mrYes then begin
    CallV('TMG SMS SEND LAB MSG',[editPhone.Text,editMessage.Text]);
  end;
  self.ModalResult := mrOK;
  
end;

end.

