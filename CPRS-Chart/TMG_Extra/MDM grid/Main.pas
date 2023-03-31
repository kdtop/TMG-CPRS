unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,
  MDMHelper
  ;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    btnLaunchEmbedded: TButton;
    btnClear: TButton;
    Panel1: TPanel;
    btnLaunchFloating: TButton;
    procedure btnLaunchFloatingClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnLaunchEmbeddedClick(Sender: TObject);
  private
    { Private declarations }
    frmMDMGrid: TfrmMDMGrid;    //not autocreated
    procedure InstantiateHelper;
    procedure HandleMDMClosing(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.btnClearClick(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

procedure TForm1.btnLaunchEmbeddedClick(Sender: TObject);
begin
  if Assigned(frmMDMGrid) then exit;
  InstantiateHelper;
  frmMDMGrid.EmbeddedMode := true;
  frmMDMGrid.Parent := Panel1;
  frmMDMGrid.Show;
end;

procedure TForm1.btnLaunchFloatingClick(Sender: TObject);
begin
  if Assigned(frmMDMGrid) then exit;
  InstantiateHelper;
  frmMDMGrid.EmbeddedMode := false;
  frmMDMGrid.Show;
end;

procedure TForm1.InstantiateHelper;
begin
  frmMDMGrid := TfrmMDMGrid.Create(Self);
  //frmMDMGrid.CommonLog := Memo1.Lines;
  frmMDMGrid.OnCloseForm := HandleMDMClosing;
end;


procedure TForm1.HandleMDMClosing(Sender: TObject);
var
  i : integer;
  SL : TStringList;

begin
  Memo1.Lines.Add(frmMDMGrid.CPT);
  Memo1.Lines.Add(frmMDMGrid.Narrative);
  SL := frmMDMGrid.TextTable;
  for i := 0 to SL.Count - 1 do begin
    Memo1.Lines.Add(SL[i]);
  end;
  if not frmMDMGrid.EmbeddedMode then begin
    FreeAndNil(frmMDMGrid);
  end else begin
    frmMDMGrid.reset
  end;
end;



end.
