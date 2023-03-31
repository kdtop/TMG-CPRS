unit fEncounterLabs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ORFn,
  Dialogs, fPCEBase, VA508AccessibilityManager, StdCtrls, Buttons;

type
  TfrmEnounterLabs = class(TfrmPCEBase)
    btnLaunchLabDlg: TBitBtn;
    btnNext: TBitBtn;
    procedure btnNextClick(Sender: TObject);
    procedure btnLaunchLabDlgClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SendData;  //kt
    constructor CreateLinked(AParent: TWinControl);

  end;

var
  frmEnounterLabs: TfrmEnounterLabs;     //not auto-created

implementation

{$R *.dfm}

uses fEncounterFrame, fOrders, fODTMG1;

procedure TfrmEnounterLabs.btnLaunchLabDlgClick(Sender: TObject);
var i, index : integer;
    ItemName : string;
    //SavedNeedsModal : boolean;
const TMG_LAB_ORDER_NAME = 'TMG Lab Order';
begin
  inherited;
  frmOrders.EnsureLstWriteLoaded();
  index := -1;
  for i := 0 to frmOrders.lstWrite.Items.Count - 1 do begin
    ItemName := Piece(frmOrders.lstWrite.Items[i], '^', 2);
    if ItemName <> TMG_LAB_ORDER_NAME then continue;
    index := i;
    break;
  end;
  if index = -1 then begin
    MessageDlg('Can''t find order "'+TMG_LAB_ORDER_NAME+'".',mtError, [mbOK], 0);
    exit;
  end;

  frmOrders.lstWrite.ItemIndex := index;
  frmOrders.lstWriteClick(self);
end;

procedure TfrmEnounterLabs.btnNextClick(Sender: TObject);
begin
  inherited;
  frmEncounterFrame.SelectNextTab;
end;

constructor TfrmEnounterLabs.CreateLinked(AParent: TWinControl);
begin
  AutoSizeDisabled := true;  //<--- this turns off crazy form resizing from parent forms.
  inherited;
end;



procedure TfrmEnounterLabs.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_TMG_LabsNm;    // <-- required!

  btnOK.Height := 32;
  btnOK.Top := Self.Height - BtnOK.Height - 5;
  btnCancel.Height := 32;
  btnCancel.Top := BtnOK.Top;
  btnNext.Top := Self.Height - BtnNext.Height - 5;
end;


procedure TfrmEnounterLabs.SendData;  //kt
begin
  TMGLabOrderAutoPopulateIfActive; //kt added
end;

end.
