unit fToolWin;
//kt added entire unit

//NOTE: plan is to remove this unit.  

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfrmTMGToolWindow = class(TForm)
    Button1: TButton;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTMGToolWindow: TfrmTMGToolWindow;

implementation

{$R *.dfm}

  procedure TfrmTMGToolWindow.Button1Click(Sender: TObject);
  begin
    MessageDlg('Here!', mtInformation, [mbOK], 0);
  end;

  procedure TfrmTMGToolWindow.Timer1Timer(Sender: TObject);
  begin
    BringWindowToTop(Self.Handle);
  end;

end.

