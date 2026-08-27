unit fGMV_UserSettings;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls,
  ToolWin,
  StdCtrls,
  ImgList,
  Grids,
  uGMV_Common, ActnList, Buttons;

type
  TfrmGMV_UserSettings = class(TForm)
    pnlControls: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    Button1: TButton;
    ActionList1: TActionList;
    acRestoreDefaults: TAction;
    ColorDialog1: TColorDialog;
    pgctrl: TPageControl;
    tbshtValueDisplay: TTabSheet;
    gbxNormal: TGroupBox;
    tbarNormal: TToolBar;
    ToolButton3: TToolButton;
    tbtnNormalText: TToolButton;
    ToolButton6: TToolButton;
    tbtnNormalBackground: TToolButton;
    ToolButton4: TToolButton;
    ckbNormalBold: TCheckBox;
    ckbNormalQuals: TCheckBox;
    ToolButton7: TToolButton;
    tbtnNormalTodayBackground: TToolButton;
    gbxAbnormal: TGroupBox;
    tbarAbnormal: TToolBar;
    ToolButton1: TToolButton;
    tbtnAbnormalText: TToolButton;
    ToolButton2: TToolButton;
    tbtnAbnormalBackground: TToolButton;
    ToolButton5: TToolButton;
    ckbAbnormalBold: TCheckBox;
    ckbAbnormalQuals: TCheckBox;
    ToolButton9: TToolButton;
    tbtnAbNormalTodayBackground: TToolButton;
    gbxSamples: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtNormal: TEdit;
    edtAbnormal: TEdit;
    grdSample: TStringGrid;
    tbsParameters: TTabSheet;
    GroupBox1: TGroupBox;
    lblSearchDelay: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label4: TLabel;
    cbxSearchDelay: TComboBox;
    cbxDefaultTemplate: TComboBox;
    pnlInquiry: TPanel;
    memInquiry: TMemo;
    lbxInquiryName: TListBox;
    procedure tbtnAbnormalTextClick(Sender: TObject);
    procedure UpdateSample;
    procedure tbtnAbnormalBackgroundClick(Sender: TObject);
    procedure tbtnNormalBackgroundClick(Sender: TObject);
    procedure tbtnNormalTextClick(Sender: TObject);
    procedure ckbNormalBoldClick(Sender: TObject);
    procedure ckbAbnormalBoldClick(Sender: TObject);
    procedure grdSampleDrawCell(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState);
    procedure ckbNormalQualsClick(Sender: TObject);
    procedure ckbAbnormalQualsClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure acRestoreDefaultsExecute(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbxSearchDelayChange(Sender: TObject);
    procedure tbtnNormalTodayBackgroundClick(Sender: TObject);
    procedure tbtnAbNormalTodayBackgroundClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure lbxInquiryNameClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    ChangesMade: Boolean;
    procedure SetApplyActive(bState: Boolean);
  public
    { Public declarations }
  end;

procedure UpdateUserSettings;

implementation

uses fGMV_SelectColor, uGMV_Const, uGMV_GlobalVars, uGMV_User;

{$R *.DFM}
var
  oldGMVAbnormalText: integer = 9;
  oldGMVAbnormalBkgd: integer = 15;
  oldGMVAbnormalTodayBkgd: integer = 15;
  oldGMVAbnormalBold: Boolean = False;
  oldGMVAbnormalQuals: Boolean = False;
  oldGMVNormalText: integer = 0;
  oldGMVNormalBkgd: integer = 15;
  oldGMVNormalTodayBkgd: integer = 15;
  oldGMVNormalBold: Boolean = False;
  oldGMVNormalQuals: Boolean = True;

  oldGMVInquiryBkgd : Integer = $00EACF80;
  newGMVInquiryBkgd : Integer = $00EACF80;
  oldGMVInquiryTextBkgd : Integer = clInfoBk;
  newGMVInquiryTextBkgd : Integer = clInfoBk;

  oldGMVSearchDelay: String = '1.0';

  newGMVAbnormalText: integer = 9;
  newGMVAbnormalBkgd: integer = 15;
  newGMVAbnormalTodayBkgd: integer = 15;
  newGMVAbnormalBold: Boolean = False;
  newGMVAbnormalQuals: Boolean = False;
  newGMVNormalText: integer = 0;
  newGMVNormalBkgd: integer = 15;
  newGMVNormalTodayBkgd: integer = 15;
  newGMVNormalBold: Boolean = False;
  newGMVNormalQuals: Boolean = True;

  newGMVSearchDelay: String = '1.0';

  oldGMVInquiryName: String = 'ORWPT PTINQ';
  newGMVInquiryName: String = 'ORWPT PTINQ';


procedure SetDefaultSettings;
begin

  newGMVAbnormalText := dfltGMVAbnormalText;
  newGMVAbnormalBkgd := dfltGMVAbnormalBkgd;
  newGMVAbnormalTodayBkgd := dfltGMVAbnormalTodayBkgd;
  newGMVAbnormalBold := dfltGMVAbnormalBold;
  newGMVAbnormalQuals := dfltGMVAbnormalQuals;
  newGMVNormalText := dfltGMVNormalText;
  newGMVNormalBkgd := dfltGMVNormalBkgd;
  newGMVNormalTodayBkgd := dfltGMVNormalTodayBkgd;
  newGMVNormalBold := dfltGMVNormalBold;
  newGMVNormalQuals := dfltGMVNormalQuals;

//  newGMVInquiryBkgd := dfltGMVInquiryBkgd;

end;

procedure SaveSettings;
begin
  GMVAbnormalText := newGMVAbnormalText;
  GMVAbnormalBkgd := newGMVAbnormalBkgd;
  GMVAbnormalTodayBkgd := newGMVAbnormalTodayBkgd;
  GMVAbnormalBold := newGMVAbnormalBold;
  GMVAbnormalQuals := newGMVAbnormalQuals;
  GMVNormalText := newGMVNormalText;
  GMVNormalBkgd := newGMVNormalBkgd;
  GMVNormalTodayBkgd := newGMVNormalTodayBkgd;
  GMVNormalBold := newGMVNormalBold;
  GMVNormalQuals := newGMVNormalQuals;

  GMVSearchDelay := newGMVSearchDelay;

  GMVInquiryBkgd := newGMVInquiryBkgd;
  GMVInquiryTextBkgd := newGMVInquiryTextBkgd;
  GMVInquiryName := newGMVInquiryName;
end;

procedure RestoreSettings;
begin
  GMVAbnormalText := oldGMVAbnormalText;
  GMVAbnormalBkgd := oldGMVAbnormalBkgd;
  GMVAbnormalTodayBkgd := oldGMVAbnormalTodayBkgd;
  GMVAbnormalBold := oldGMVAbnormalBold;
  GMVAbnormalQuals := oldGMVAbnormalQuals;
  GMVNormalText := oldGMVNormalText;
  GMVNormalBkgd := oldGMVNormalBkgd;
  GMVNormalTodayBkgd := oldGMVNormalTodayBkgd;
  GMVNormalBold := oldGMVNormalBold;
  GMVNormalQuals := oldGMVNormalQuals;

  GMVSearchDelay := oldGMVSearchDelay;
  GMVInquiryBkgd := oldGMVInquiryBkgd;
  GMVInquiryTextBkgd := oldGMVInquiryTextBkgd;
  GMVInquiryName := oldGMVInquiryName;

end;

procedure CopySettings;
begin
  oldGMVAbnormalText := GMVAbnormalText;
  oldGMVAbnormalBkgd := GMVAbnormalBkgd;
  oldGMVAbnormalTodayBkgd := GMVAbnormalTodayBkgd;
  oldGMVAbnormalBold := GMVAbnormalBold;
  oldGMVAbnormalQuals := GMVAbnormalQuals;
  oldGMVNormalText := GMVNormalText;
  oldGMVNormalBkgd := GMVNormalBkgd;
  oldGMVNormalTodayBkgd := GMVNormalTodayBkgd;
  oldGMVNormalBold := GMVNormalBold;
  oldGMVNormalQuals := GMVNormalQuals;

  oldGMVInquiryBkgd := GMVInquiryBkgd;
  oldGMVInquiryTextBkgd := GMVInquiryTextBkgd;

  oldGMVSearchDelay := GMVSearchDelay;
  oldGMVInquiryName := GMVInquiryName;

  newGMVAbnormalText := GMVAbnormalText;
  newGMVAbnormalBkgd := GMVAbnormalBkgd;
  newGMVAbnormalTodayBkgd := GMVAbnormalTodayBkgd;
  newGMVAbnormalBold := GMVAbnormalBold;
  newGMVAbnormalQuals := GMVAbnormalQuals;
  newGMVNormalText := GMVNormalText;
  newGMVNormalBkgd := GMVNormalBkgd;
  newGMVNormalTodayBkgd := GMVNormalTodayBkgd;
  newGMVNormalBold := GMVNormalBold;
  newGMVNormalQuals := GMVNormalQuals;

  newGMVSearchDelay := GMVSearchDelay;

  newGMVInquiryBkgd := GMVInquiryBkgd;
  newGMVInquiryTextBkgd := GMVInquiryTextBkgd;
  newGMVInquiryName := GMVInquiryName;
end;

procedure UpdateUserSettings;
begin
{$IFDEF DLL}
  if not assigned(frmGMV_SelectColor)
    then Application.CreateForm(TfrmGMV_SelectColor,frmGMV_SelectColor);
{$ENDIF}
  with TfrmGMV_UserSettings.Create(Application) do
    try
//      cbxDefaultTemplate.Items.Assign( TGMV_DefaultTemplates(GMVDefaultTemplates).FTemplates);
      pgctrl.ActivePageIndex := 0;
{$IFDEF DLL}
  tbsParameters.TabVisible := False;
  tbsParameters.Visible := False;
{$ENDIF}
      pnlInquiry.Color := GMVInquiryBkgd;
      memInquiry.Color := GMVInquiryTextBkgd;

      lbxInquiryName.ItemIndex := lbxInquiryName.Items.IndexOf(GMVInquiryName);

      cbxSearchDelay.Text := GMVSearchDelay;

      CopySettings; //AAN 06/13/02
{$IFDEF DLL}
      Caption := 'User preferences';
{$ELSE}
      Caption := 'User preferences [' + GMVUser.Name + ']';
{$ENDIF}
      tbtnNormalText.ImageIndex := GMVNormalText;
      tbtnNormalBackground.ImageIndex := GMVNormalBkgd;
      ckbNormalBold.Checked := GMVNormalBold;
      ckbNormalQuals.Checked := GMVNormalQuals;
      tbtnAbnormalText.ImageIndex := GMVAbnormalText;
      tbtnAbnormalBackground.ImageIndex := GMVAbnormalBkgd;
      ckbAbnormalBold.Checked := GMVAbnormalBold;
      ckbAbnormalQuals.Checked := GMVAbnormalQuals;
      grdSample.Cells[0, 0] := '';
      grdSample.Cells[1, 0] := FormatDateTime('nn-dd-yy',Now-7);;
      grdSample.Cells[2, 0] := FormatDateTime('nn-dd-yy',Now-1);
//      grdSample.Cells[3, 0] := FormatDateTime('nn-dd-yy',Now);

      grdSample.Cells[0, 1] := 'xxxxxx';
      grdSample.Cells[1, 1] := '123 Normal';

      grdSample.Cells[0, 2] := 'xxxxxx';
      grdSample.Cells[2, 2] := '999* Abnormal';

      grdSample.Cells[0, 3] := 'xxxxxx';//'Today';
      grdSample.Cells[1, 3] := '123 Normal';
      grdSample.Cells[2, 3] := '999* Abnormal';

      UpdateSample;
      ChangesMade := False;
      SetApplyActive(False);//AAN 06/10/02
      if (ShowModal <> mrOK) and ChangesMade then //AAN 06/13/02
        begin
{
        if Application.MessageBox('User Options have been changed.'#13+
          'Restore original values?','Confirm operation',
          MB_OKCANCEL + MB_DEFBUTTON1) = IDOK then
}
            begin
              RestoreSettings;
              CopySettings;
              SaveSettings;
            end;
        end
      else
        if ChangesMade then
          SaveSettings;
    finally
      Free;
    end;
end;

procedure TfrmGMV_UserSettings.tbtnNormalTextClick(Sender: TObject);
begin
  tbtnNormalText.Down := True;
  SelectColor(tbtnNormalText, newGMVNormalText); //AAN 06/13/02
//  tbtnNormalText.ImageIndex := newGMVNormalText; //AAN 06/13/02
  UpdateSample;
  tbtnNormalText.Down := False;
end;

procedure TfrmGMV_UserSettings.tbtnAbnormalTextClick(Sender: TObject);
begin
  tbtnAbnormalText.Down := True;
  SelectColor(tbtnAbnormalText, newGMVAbnormalText); //AAN 06/13/02
//  tbtnAbnormalText.ImageIndex := newGMVAbnormalText; //AAN 06/13/02
  UpdateSample;
  tbtnAbnormalText.Down := False;
end;

procedure TfrmGMV_UserSettings.tbtnNormalBackgroundClick(Sender: TObject);
begin
  tbtnNormalBackground.Down := True;
  SelectColor(tbtnNormalBackground, newGMVNormalBkgd);//AAN 06/13/02
//  tbtnNormalBackground.ImageIndex := newGMVNormalBkgd;//AAN 06/13/02
  UpdateSample;
  tbtnNormalBackground.Down := False;
end;

procedure TfrmGMV_UserSettings.tbtnAbnormalBackgroundClick(Sender: TObject);
begin
  tbtnAbnormalBackground.Down := True;
  SelectColor(tbtnAbnormalBackground, newGMVAbnormalBkgd);//AAN 06/13/02
//  tbtnAbnormalBackground.ImageIndex := newGMVAbnormalBkgd;//AAN 06/13/02
  UpdateSample;
  tbtnAbnormalBackground.Down := False;
end;

procedure TfrmGMV_UserSettings.UpdateSample;
begin
  tbtnNormalText.ImageIndex := newGMVNormalText; //AAN 06/13/02
  tbtnAbnormalText.ImageIndex := newGMVAbnormalText; //AAN 06/13/02
  tbtnNormalBackground.ImageIndex := newGMVNormalBkgd;//AAN 06/13/02
  tbtnNormalTodayBackground.ImageIndex := newGMVNormalTodayBkgd;//AAN 06/13/02
  tbtnAbnormalBackground.ImageIndex := newGMVAbnormalBkgd;//AAN 06/13/02
  tbtnAbnormalTodayBackground.ImageIndex := newGMVAbnormalTodayBkgd;//AAN 06/13/02

  edtAbnormal.Color := DISPLAYCOLORS[newGMVAbnormalBkgd];//AAN 06/13/02
  edtAbnormal.Font.Color := DISPLAYCOLORS[newGMVAbnormalText];//AAN 06/13/02
  ckbAbnormalBold.Checked := newGMVAbnormalBold;//AAN 06/14/02
  ckbAbnormalQuals.Checked := newGMVAbnormalQuals;//AAN 06/14/02
  if newGMVAbnormalBold then//AAN/06/14
      edtAbnormal.Font.Style := [fsBold]
  else
    edtAbnormal.Font.Style := [];
  edtNormal.Color := DISPLAYCOLORS[newGMVNormalBkgd];//AAN 06/13/02
  edtNormal.Font.Color := DISPLAYCOLORS[newGMVNormalText];//AAN 06/13/02
  ckbNormalQuals.Checked := newGMVNormalQuals;//AAN 06/14/02
  ckbNormalBold.Checked := newGMVNormalBold;//AAN 06/14/02
  if newGMVNormalBold then //AAN 06/13/02
    edtNormal.Font.Style := [fsBold]
  else
    edtNormal.Font.Style := [];
  grdSample.Refresh;

  ChangesMade := True;//AAN 06/13/02
  SetApplyActive(True);//AAN 06/10/02

  pnlInquiry.Color :=   newGMVInquiryBkgd;
  memInquiry.Color :=   newGMVInquiryTextBkgd;
end;

procedure TfrmGMV_UserSettings.ckbNormalBoldClick(Sender: TObject);
begin
  newGMVNormalBold := ckbNormalBold.Checked;//AAN 06/13/02
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.ckbAbnormalBoldClick(Sender: TObject);
begin
  newGMVAbnormalBold := ckbAbnormalBold.Checked;//AAN 06/13/02
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.ckbNormalQualsClick(Sender: TObject);
begin
  newGMVNormalQuals := ckbNormalQuals.Checked;//AAN 06/13/02
  if newGMVNormalQuals then
    grdSample.Cells[1,1] := '123 Normal'
  else
    grdSample.Cells[1,1] := '123';
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.ckbAbnormalQualsClick(Sender: TObject);
begin
  newGMVAbnormalQuals := ckbAbnormalQuals.Checked;//AAN 06/13/02
  if newGMVAbNormalQuals then
    grdSample.Cells[2,2] := '999* Abnormal'
  else
    grdSample.Cells[2,2] := '999*';
  UpdateSample;
end;

procedure TfrmGMV_UserSettings.grdSampleDrawCell(
  Sender: TObject;
  ACol, ARow: integer;
  Rect: TRect;
  State: TGridDrawState);
begin
  with grdSample do
    begin
      // Fill in background as btnFace, Abnormal, Normal
      if (ACol = 0) or (ARow = 0) then
        Canvas.Brush.Color := clBtnFace
      else if Pos('*', Cells[ACol, ARow]) > 0 then
        begin
//          if ARow = 3 then
//            Canvas.Brush.Color := DISPLAYCOLORS[newGMVAbnormalTodayBkgd]
//          else
            Canvas.Brush.Color := DISPLAYCOLORS[newGMVAbnormalBkgd];//AAN 06/13/02
        end
      else
//          if ARow = 3 then
//            Canvas.Brush.Color := DISPLAYCOLORS[newGMVNormalTodayBkgd]
//          else
            Canvas.Brush.Color := DISPLAYCOLORS[newGMVNormalBkgd];//AAN 06/13/02
      Canvas.FillRect(Rect);

      // Set up font color as btnText, Abnormal, Normal
      if (ACol = 0) or (ARow = 0) then
        begin
          Canvas.Font.Color := clBtnText;
          Canvas.Font.Style := [];//AAN 06/14/02
        end
      else if Pos('*', Cells[ACol, ARow]) > 0 then
        begin
          Canvas.Font.Color := DISPLAYCOLORS[newGMVAbnormalText];//AAN 06/13/02
          if newGMVAbnormalBold then//AAN 06/13/02
            Canvas.Font.Style := [fsBold]
          else
            Canvas.Font.Style := [];
        end
      else
        begin
          Canvas.Font.Color := DISPLAYCOLORS[newGMVNormalText];//AAN 06/13/02
          if newGMVNormalBold then//AAN 06/13/02
            Canvas.Font.Style := [fsBold]
          else
            Canvas.Font.Style := [];
        end;
      Canvas.TextRect(Rect, Rect.Left, Rect.Top, Cells[ACol, ARow]);
    end;
end;

procedure TfrmGMV_UserSettings.btnApplyClick(Sender: TObject);
begin
  SaveSettings;//AAN 06/13/02
  GMVUser.Setting[usCanvasNormal] :=
    IntToStr(GMVNormalBkgd) + ';' +
    IntToStr(GMVNormalText) + ';' +
    IntToStr(BOOLEAN01[ckbNormalBold.Checked]) + ';' +
    IntToStr(BOOLEAN01[ckbNormalQuals.Checked])+ ';' +
    IntToStr(GMVNormalTodayBkgd)
    +';'+ IntToStr(GMVInquiryBkgd)
    +';'+ IntToStr(GMVInquiryTextBkgd)
    +';'+ GMVInquiryName
    ;
  GMVUser.Setting[usCanvasAbnormal] :=
    IntToStr(GMVAbnormalBkgd) + ';' +
    IntToStr(GMVAbnormalText) + ';' +
    IntToStr(BOOLEAN01[ckbAbnormalBold.Checked]) + ';' +
    IntToStr(BOOLEAN01[ckbAbnormalQuals.Checked]) + ';'+
    IntToStr(GMVAbnormalTodayBkgd);

  try
    GMVSearchDelay := cbxSearchDelay.Text;
    GMVUser.Setting[usSearchDelay] := cbxSearchDelay.Text;
  except
  end;

  pnlInquiry.Color := GMVInquiryBkgd;

  SetApplyActive(False);//AAN 06/10/02
end;

//AAN 06/10/02-------------------------------------------------Begin
procedure TfrmGMV_UserSettings.SetApplyActive(bState: boolean);
begin
  btnApply.Enabled := bState;
end;
//AAN 06/10/02---------------------------------------------------End

procedure TfrmGMV_UserSettings.acRestoreDefaultsExecute(Sender: TObject);
begin
  case pgctrl.ActivePageIndex of
    0: begin
        SetDefaultSettings;
        ChangesMade := True;
        UpdateSample;
        refresh;
      end;
    1:begin
      GMVSearchDelay := '1.0';
      cbxSearchDelay.Text := '1.0';
      SetApplyActive(true);
    end;
    2: begin
         newGMVInquiryBkgd := dfltGMVInquiryBkgd;
         newGMVInquiryTextBkgd := dfltGMVInquiryTextBkgd;
         UpdateSample;
      end;

  end;
end;

procedure TfrmGMV_UserSettings.btnOKClick(Sender: TObject);
begin
  btnApplyClick(Sender);
end;

procedure TfrmGMV_UserSettings.cbxSearchDelayChange(Sender: TObject);
begin
  SetApplyActive(true);
end;

procedure TfrmGMV_UserSettings.tbtnNormalTodayBackgroundClick(Sender: TObject);
begin
  tbtnNormalTodayBackground.Down := True;
  SelectColor(tbtnNormalTodayBackground, newGMVNormalTodayBkgd);//AAN 06/13/02
//  tbtnNormalBackground.ImageIndex := newGMVNormalBkgd;//AAN 06/13/02
  UpdateSample;
  tbtnNormalTodayBackground.Down := False;

end;

procedure TfrmGMV_UserSettings.tbtnAbNormalTodayBackgroundClick(
  Sender: TObject);
begin
  tbtnAbNormalTodayBackground.Down := True;
  SelectColor(tbtnAbNormalTodayBackground, newGMVAbNormalTodayBkgd);//AAN 06/13/02
//  tbtnNormalBackground.ImageIndex := newGMVNormalBkgd;//AAN 06/13/02
  UpdateSample;
  tbtnAbNormalTodayBackground.Down := False;
end;

procedure TfrmGMV_UserSettings.SpeedButton1Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    begin
      if pnlInquiry.Color = ColorDialog1.Color then
        exit;
      SetApplyActive(true);
      pnlInquiry.Color := ColorDialog1.Color;
      newGMVInquiryBkgd := ColorDialog1.Color;
    end;
end;

procedure TfrmGMV_UserSettings.lbxInquiryNameClick(Sender: TObject);
begin
  if newGMVInquiryName = lbxInquiryName.Items[lbxInquiryName.ItemIndex] then exit;
  newGMVInquiryName := lbxInquiryName.Items[lbxInquiryName.ItemIndex];
  SetApplyActive(true);
end;

procedure TfrmGMV_UserSettings.SpeedButton2Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    begin
      if memInquiry.Color = ColorDialog1.Color then
        exit;
      SetApplyActive(true);
      memInquiry.Color := ColorDialog1.Color;
      newGMVInquiryTextBkgd := ColorDialog1.Color;
    end;
end;

end.

