unit fNewPatientInstructions;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Classes;

type
  TfrmNewPatientInstructions = class(TForm)
    pnlNewPt: TPanel;
    memNewPtInst: TMemo;
    lblNewPtInst: TStaticText;
    btnClose: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  frmNewPatientInstructions: TfrmNewPatientInstructions;

implementation

{$R *.dfm}

procedure TfrmNewPatientInstructions.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmNewPatientInstructions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;  //should cause it to free itself.
end;

end.
