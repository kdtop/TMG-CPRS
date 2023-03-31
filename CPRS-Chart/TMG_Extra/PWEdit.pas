unit PWEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ActiveX, ActiveDs_TLB, ComObj, Trpcb;

type
  TfrmPWEdit = class(TForm)
    lblOldVC: TLabel;
    edtOldVC: TEdit;
    btnOK: TBitBtn;
    Label1: TLabel;
    btnCancel: TBitBtn;
    edtNewVC: TEdit;
    lblNewVC: TLabel;
    lblConfirmVC: TLabel;
    edtConfirmVC: TEdit;
    btnHelp: TBitBtn;
    procedure btnHelpClick(Sender: TObject);
    procedure edtOldVCChange(Sender: TObject);
    procedure edtNewVCExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FConfirmFailCnt : integer;  //counts failed confirms.
    CurrentUser : string;
    FRPCBroker : TRPCBroker;
    procedure NoChange(reason : string);
    function GetObject(const Name:string): IDispatch;
  public
    { Public declarations }
  end;

var
  frmPWEdit: TfrmPWEdit;
  function ChangeLDAPPassword(CurrentUser,CurrentPassword:string;RPCBroker:TRPCBroker):integer;

const
  MAX_CONFIRM_FAIL : integer = 3;

implementation

{$R *.dfm}

function ChangeLDAPPassword(CurrentUser,CurrentPassword:string;RPCBroker:TRPCBroker):integer;
var
   frmPWEdit:TfrmPWEdit;
begin
   frmPWEdit := TfrmPWEdit.Create(nil);
   frmPWEdit.edtOldVC.Text := CurrentPassword;
   frmPWEdit.CurrentUser := CurrentUser;
   frmPWEdit.FRPCBroker := RPCBroker;
   frmPWEdit.ShowModal;
   Result := frmPWEdit.ModalResult;
   frmPWEdit.Free;
end;


procedure TfrmPWEdit.btnHelpClick(Sender: TObject);
var msg:string;
begin
    with FRPCBroker do
    begin
      RemoteProcedure := 'XUS LDAP HELP';
      Call;
      msg := Results.Text;
      if edtOldVC.text = '' then
        msg := 'Enter your current verify code first.' + #13#10 + msg;
    end{with};
    ShowMessage(msg);
end;

procedure TfrmPWEdit.btnOKClick(Sender: TObject);
var
   Usr: IADsUser;
begin
    if edtOldVC.Text = edtNewVC.Text then begin
      NoChange('The new code is the same as the current one.');
      edtNewVC.Text := '';
      edtConfirmVC.Text := '';
      edtNewVC.SetFocus;
    end else if edtNewVC.Text <> edtConfirmVC.Text then begin
      inc(FConfirmFailCnt);
      if FConfirmFailCnt > MAX_CONFIRM_FAIL then begin
        edtNewVC.Text := '';
        edtConfirmVC.Text := '';
        NoChange('The confirmation code does not match.');
        edtNewVC.SetFocus;
      end else begin
        edtConfirmVC.text := '';
        NoChange('The confirmation code does not match.  Try again.');
        edtConfirmVC.SetFocus;
      end;
    end else begin
     try
        Usr := GetObject('WinNT://astronautvista.local/'+CurrentUser+',user') as IADsUser;
     except
        on E: EOleException do begin
          ShowMessage(E.Message);
          ModalResult := mrCancel;
          Close;
        end;
     end;
     try
        Usr.ChangePassword(WideString(edtOLDVC.Text),WideString(edtNewVC.Text));
        //ShowMessage('After change password');
        ModalResult := mrOK;
     except
        on E: EOleException do begin
          edtNewVC.Text := '';
          edtConfirmVC.Text := '';
          NoChange(E.Message);
          edtNewVC.SetFocus;
          //ShowMessage(E.Message);
          //ModalResult := mrCancel;
          //Close;
        end;
     end;
  end;
end;

procedure TfrmPWEdit.NoChange(reason : string);
begin
  ShowMessage('Your VERIFY code was not changed.' + #13 +
              reason + #13 );
end;

procedure TfrmPWEdit.edtNewVCExit(Sender: TObject);
begin
  if edtNewVC.Modified then
  begin
    FConfirmFailCnt := 0;                //Reset counter.
    edtNewVC.Modified := False;
  end;
end;

procedure TfrmPWEdit.edtOldVCChange(Sender: TObject);
begin
  btnOk.Default := ((edtNewVC.Text <> '') and        //Update status of OK btn.
                    (edtOldVC.Text <> '') and
                    (edtConfirmVC.Text <> '') );
end;

function TfrmPWEdit.GetObject(const Name:string): IDispatch;
var
   Moniker: IMoniker;
   Eaten: integer;
   BindContext: IBindCtx;
   Dispatch: IDispatch;
begin
   OleCheck(CreateBindCtx(0, BindContext));
   OleCheck(MkParseDisplayName(BindContext,
            PWideChar(Widestring(Name)),
            Eaten,
            Moniker));
   OleCheck(Moniker.BindToObject(BindContext, NIL, IDispatch,Dispatch));
   Result := Dispatch;
end;

end.

