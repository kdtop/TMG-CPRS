unit fConfirmTimer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrmConfirmTimer = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    btnOk: TBitBtn;
    btnNo: TBitBtn;
    chkRemember: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfirmTimer: TfrmConfirmTimer;

  function ConfirmTimerStart(var SaveAnswer:integer) : boolean;

implementation

{$R *.dfm}

  uses
    fFrame;

  function ConfirmTimerStart(var SaveAnswer:integer) : boolean;
  var frmConfirmTimer : TfrmConfirmTimer;
      ModalResult : integer;
  begin
    Result := false;
    frmConfirmTimer := TfrmConfirmTimer.Create(frmFrame);
    try
      ModalResult := frmConfirmTimer.ShowModal;
      if frmConfirmTimer.chkRemember.Checked then begin
        if ModalResult=mrYes then SaveAnswer := 1
        else SaveAnswer := -1;
      end else begin
        SaveAnswer := 0;
      end;
      result := (ModalResult=mrYes);
    finally
      frmConfirmTimer.Free;
    end;
  end;

end.

