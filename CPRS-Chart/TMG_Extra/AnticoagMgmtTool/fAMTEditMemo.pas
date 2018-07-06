unit fAMTEditMemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Classes;

type
  TfrmAMTEditMemo = class(TForm)
    pnlBottom: TPanel;
    btnCancel: TBitBtn;
    btnDone: TBitBtn;
    memMemo: TMemo;
    btnClear: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ShowModal(SourceSL : TStrings) : integer; overload;
  end;

//var
//  frmAMTEditMemo: TfrmAMTEditMemo;

implementation

{$R *.dfm}


procedure TfrmAMTEditMemo.btnClearClick(Sender: TObject);
begin
  memMemo.Clear;
end;

procedure TfrmAMTEditMemo.FormShow(Sender: TObject);
begin
  memMemo.SetFocus;
end;

function TfrmAMTEditMemo.ShowModal(SourceSL : TStrings) : integer;
begin
  memMemo.Lines.Assign(SourceSL);
  Result := Self.ShowModal();
end;


end.
