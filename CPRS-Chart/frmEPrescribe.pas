unit frmEPrescribe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, ExtCtrls;

type
  TEPrescribeForm = class(TForm)
    btnClose: TButton;
    Panel1: TPanel;
    browser: TWebBrowser;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure browserNewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
  private
    { Private declarations }
  public
    { Public declarations }
    class function AllowContextChange(var WhyNot: string): Boolean;
  end;

var
  ePrescribing: TEPrescribeForm;

implementation

uses fFrame, ORFn, ORNet, uCore;

{$R *.dfm}

{ TEPrescribeForm }

class function TEPrescribeForm.AllowContextChange(var WhyNot: string): Boolean;
begin
  Result := True;
  if ePrescribing <> nil then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             WhyNot := 'E-prescribing window is still in use.';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then
               begin
                 ePrescribing.Close;
               end
             else
               begin
                 Result := MessageDlg('CPRS is attempting to change context.  ' + sLineBreak + sLineBreak +
                                      'Click OK to close the e-prescribing window and change context.' + sLineBreak + sLineBreak +
                                      'Click Cancel to prevent the context change and keep the e-prescribing window open.',
                                      mtConfirmation,mbOKCancel,0) = mrOK;
                 if Result then ePrescribing.Close;
               end;
           end;
    end;
end;

procedure TEPrescribeForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  s: String;
begin
  if (self = ePrescribing) then
  begin
    ePrescribing := nil;

    if not frmFrame.ContextChanging then
    begin
        CallV('C0P ERX PULLBACK', [User.DUZ, Patient.DFN]);
        s := Trim(RPCBrokerV.Results.Text);

        if (s = 'OK') then
          frmFrame.mnuFileRefreshClick(Self)
        else
          MessageDlg(s, mtWarning, [mbOK], 0);
    end;
  end;

  Action := caFree;
end;

procedure TEPrescribeForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TEPrescribeForm.browserNewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
var
  tmpfrm: TEPrescribeForm;
begin
  tmpfrm := TEPrescribeForm.Create(Application);
  tmpfrm.Show;

  ppDisp := tmpfrm.browser.Application;
end;

end.
