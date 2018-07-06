unit fBridgeCommentsDialog;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls {, VA508AccessibilityManager};

type
  TfrmBridgeCommentDlg = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    pnlButtons: TPanel;
    pnlMemo: TPanel;
    memBridgeComments: TMemo;
    pnlTop: TPanel;
    lblEnterComments: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  frmBridgeCommentDlg: TfrmBridgeCommentDlg;

implementation

{$R *.dfm}

end.
