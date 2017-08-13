unit fInsertComparator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ORFn,
  Dialogs, StdCtrls, Buttons, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmPickComparator = class(TfrmBase508Form)
    rgComparators: TRadioGroup;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetSelected : string;
  end;

var
  frmPickComparator: TfrmPickComparator;

implementation

{$R *.dfm}

  function TfrmPickComparator.GetSelected : string;
  var s : string;
      i : integer;
  begin
    Result := '';
    i := rgComparators.ItemIndex;
    if i < 0 then exit;
    s := rgComparators.Items.Strings[i];
    if s = '' then exit;
    Result := Piece(s,' ',1);
  end;


end.

