unit fInsertFldEtc;
//VEFA-261 added entire unit

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TInsertFldReplyType = (ifrtNone=0, ifrtField=1, ifrtObject=2, ifrtFunction=3, ifrtVar=4);

  TfrmPickFldFnObj = class(TfrmBase508Form)
    rgInsertType: TRadioGroup;
    btnCancel: TBitBtn;
    procedure rgInsertTypeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function UserSelection : TInsertFldReplyType;
  end;


var
  frmPickFldFnObj: TfrmPickFldFnObj;

implementation

{$R *.dfm}

procedure TfrmPickFldFnObj.FormShow(Sender: TObject);
begin
  rgInsertType.ItemIndex := -1;
end;

procedure TfrmPickFldFnObj.rgInsertTypeClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

function TfrmPickFldFnObj.UserSelection : TInsertFldReplyType;
begin
  Result := TInsertFldReplyType(rgInsertType.ItemIndex + 1);
  rgInsertType.ItemIndex := -1;
end;


end.

