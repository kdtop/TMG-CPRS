unit fInsertOperator;
//VEFA-261 Added entire unit

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmPickOperator = class(TfrmBase508Form)
    rgOperators: TRadioGroup;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetSelected : string;
  end;

var
  frmPickOperator: TfrmPickOperator;

implementation

{$R *.dfm}

  function TfrmPickOperator.GetSelected : string;
  var s : string;
      i : integer;
  begin
    Result := '';
    i := rgOperators.ItemIndex;
    if i < 0 then exit;
    s := rgOperators.Items.Strings[i];
    if s = '' then exit;
    if s[1]='(' then Result := '()'
    else Result := s[1];
  end;


end.

