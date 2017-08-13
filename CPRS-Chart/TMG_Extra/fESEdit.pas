unit fESEdit;
{10/07/15 //TMG added mode to change electronic signature
Note: By default this form changes the Verify Code. To utilize the
      changing of the electronic signature, you must first change the mode
      to emES, then call the form. Once the form is destroyed, it will
      reset back to emES by default.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ORNet,VAUtils,
  {Broker units}
  Trpcb, Hash;

type
  TfrmESEdit = class(TForm)
    lblOldVC: TLabel;
    lblNewVC: TLabel;
    lblConfirmVC: TLabel;
    edtOldES: TEdit;
    edtNewES: TEdit;
    edtConfirmES: TEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure btnOKClick(Sender: TObject);
    procedure edtNewESExit(Sender: TObject);
    procedure edtOldESChange(Sender: TObject);
  protected
  public
    { Public declarations }
    ConfirmFailCnt : integer;
  end;


procedure ChangeES;

//kt 3/30/14  removed from autocreated forms.
//var                       //kt 3/30/14
//  frmESEdit: TfrmESEdit;  //kt 3/30/14

const
  MAX_CONFIRM_FAIL : integer = 3;
  U = '^';

{procedure Register;}

implementation

{$R *.DFM}


{--------------------------ChangeES function---------------------------}
procedure ChangeES;
var
  OldHandle: THandle;
  frmESEdit: TfrmESEdit; //kt added, removing
begin
  frmESEDit := TfrmESEDit.Create(application);
  with frmESEDit do begin
    ConfirmFailCnt := 0;
    OldHandle := GetForegroundWindow;
    SetForegroundWindow(frmESEdit.Handle);
    if ShowModal = mrOK then    //outcome of form.
    SetForegroundWindow(OldHandle);
  end{with};
  frmESEDit.Free;
end;


{-------------------------TfrmESEdit methods-------------------------------}
procedure TfrmESEdit.btnOKClick(Sender: TObject);
begin
    if (Length(edtNewES.Text)<6) or (Length(edtNewES.Text)>20) then begin
      ShowMessage('Tme new code must be between 6 and 20 characters.');
      edtNewES.text := '';
      edtConfirmES.Text := '';
      edtNewES.SetFocus;
    end else
    if edtOldES.Text = edtNewES.Text then begin
      ShowMessage('The new code is the same as the current one.');
      edtNewES.Text := '';
      edtConfirmES.Text := '';
      edtNewES.SetFocus;
    end else
    if edtNewES.Text <> edtConfirmES.Text then begin
      inc(ConfirmFailCnt);
      if ConfirmFailCnt > MAX_CONFIRM_FAIL then begin
        edtNewES.Text := '';
        edtConfirmES.Text := '';
        ShowMessage('The confirmation code does not match.');
        edtNewES.SetFocus;
      end else begin
        edtConfirmES.text := '';
        ShowMessage('The confirmation code does not match.  Try again.');
        edtConfirmES.SetFocus;
      end;
    end else
    with RPCBrokerV do begin
      RemoteProcedure := 'TMG CPRS CHANGE ES';
      Param[0].PType := literal;
      Param[0].Value := Encrypt(edtOldES.Text)
                        + U + Encrypt(edtNewES.Text)
                        + U + Encrypt(edtConfirmES.Text) ;
      Call;
      if Piece(Results.TEXT,'^',1) = '0' then begin
        ShowMessage('Your ELECTRONIC SIGNATURE has been changed');
        ModalResult := mrOK;  //Close form.
      end else begin
        //if Results.Count > 1 then
        ShowMessage(Piece(Results.Text,'^',2));
        //else
        edtNewES.Text := '';
        edtConfirmES.Text := '';
        edtNewES.SetFocus;
      end;
    end;
end;



procedure TfrmESEdit.edtNewESExit(Sender: TObject);
begin
  if edtNewES.Modified then
  begin
    ConfirmFailCnt := 0;                //Reset counter.
    edtNewES.Modified := False;
  end;
end;

procedure TfrmESEdit.edtOldESChange(Sender: TObject); //Also NewES and ConfirmES
begin
  btnOk.Default := ((edtNewES.Text <> '') and        //Update status of OK btn.
                    (edtOldES.Text <> '') and
                    (edtConfirmES.Text <> '') );
end;

end.




























