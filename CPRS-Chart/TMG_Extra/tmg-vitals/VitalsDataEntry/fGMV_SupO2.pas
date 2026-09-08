unit fGMV_SupO2;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 2 $  $Modtime: 7/14/05 2:12p $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Accepts flow rate data for PO2 vital.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry/fGMV_SupO2.pas $
*
* $History: fGMV_SupO2.pas $
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 7/22/05    Time: 3:51p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:35p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:20p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 1/30/04    Time: 4:32p
 * Updated in $/VitalsLite/VitalsLiteDLL
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 1/15/04    Time: 3:06p
 * Created in $/VitalsLite/VitalsLiteDLL
 * Vitals Lite DLL
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 10/29/03   Time: 4:15p
 * Created in $/Vitals503/Vitals User
 * Version 5.0.3
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 7  *****************
 * User: Vhaishandria Date: 4/17/03    Time: 5:02p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 6  *****************
 * User: Vhaishandria Date: 12/02/02   Time: 3:00p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Vitals Light updates
 * 
 * *****************  Version 5  *****************
 * User: Vhaishandria Date: 11/07/02   Time: 10:33a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Pulse Ox Changes
 * 
 * *****************  Version 4  *****************
 * User: Vhaishandria Date: 8/16/02    Time: 11:17a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * v T30
 * 
 * *****************  Version 3  *****************
 * User: Vhaishandria Date: 7/25/02    Time: 2:51p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 *
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 7/12/02    Time: 5:00p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * GUI Version T28
 * 
 * *****************  Version 1  *****************
 * User: Vhaishpetitd Date: 4/04/02    Time: 12:08p
 * Created in $/Vitals GUI Version 5.0/Vitals User
 *
*
================================================================================
}
interface

uses
  System.Types, //kt //codex 8/30/26
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  Buttons,
  ExtCtrls
  ,CheckLst;

type
  TfrmGMV_SupO2 = class(TForm)
    pnlMain: TPanel;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    lblFlow: TLabel;
    lblO2Con: TLabel;
    edtFlow: TEdit;
    edtO2Con: TEdit;
    udFlow: TUpDown;
    udO2: TUpDown;
    lblPercent: TLabel;
    lblLitMin: TLabel;
    Panel2: TPanel;
    pnlQual: TPanel;
    Panel5: TPanel;
    cbMethod: TComboBox;
    lblMethodValue: TLabel;
    procedure udFlowChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure udO2ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure edtFlowKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtO2ConKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbMethodChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtFlowKeyPress(Sender: TObject; var Key: Char);
    procedure edtO2ConKeyPress(Sender: TObject; var Key: Char);
    procedure edtFlowChange(Sender: TObject);
    procedure edtFlowExit(Sender: TObject);
    procedure edtO2ConChange(Sender: TObject);
    procedure edtO2ConExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    QualVal:Integer;
  end;

function GetSupplementO2Data(var FlowRate: string; var Percentage: string; ctrl: TControl;sQual:String): Boolean;

implementation

uses uGMV_Common
, uGMV_Utils, uGMV_Engine
  ;

{$R *.DFM}

function GetSupplementO2Data(var FlowRate: string; var Percentage: string; ctrl: TControl;sQual:String): Boolean;
var
  s:String;
  sType, sCategory: String;
  i: INteger;
  pt: TPoint;
  SL: TStringList;
begin
  Result := False;
  with TfrmGMV_SupO2.Create(Application) do
  try
    pt := Ctrl.Parent.ClientToScreen(Point(Ctrl.Left, Ctrl.Top));
    Left := pt.x;
    Top := pt.y + Ctrl.Height;

    edtFlow.Text := FlowRate;
    edtO2Con.Text := Percentage;
{
    // Changes to select Pulse Oximetry file number -------------------------- start
    sType := '';
    sCategory := '';
    try

      CallRemoteProc(RPCBroker, 'GMV GET VITAL TYPE IEN',['PULSE OXIMETRY'], nil,[],nil);
      sType := RPCBroker.Results[0];
      CallRemoteProc(RPCBroker, 'GMV GET CATEGORY IEN',['METHOD'], nil,[],nil);
      sCategory := RPCBroker.Results[0];
      CallRemoteProc(RPCBroker, RPC_MANAGER, ['GETQUAL', sType+';'+sCategory], nil,[], nil);
    except
      on E: Exception do
      ;
    end;
    // Changes to select Pulse Oximetry file number ---------------------------- end
      for i := 1 to RPCBroker.Results.Count - 1 do
        begin
          cbMethod.Items.AddObject(TitleCase(Piece(RPCBroker.Results[i], '^', 2)),
            Pointer(StrToIntDef(Piece(RPCBroker.Results[i], '^', 1), 0)));
        end;
}
    sType := getVitalTypeIEN('PULSE OXIMETRY');
    sCategory := getVitalCategoryIEN('METHOD');
    SL := getQualifiers(sType,sCategory);
    if SL.Count > 1 then
      begin
{$IFDEF CQ6942}
        cbMethod.Items.Add('-None-'); //CQ Ticket #6942
{$ENDIF}
        for i := 1 to SL.Count - 1 do
          begin
            s := SL[i];
            cbMethod.Items.AddObject(TitleCase(Piece(s,'^', 2)),
              Pointer(StrToIntDef(Piece(s,'^', 1), 0)));
          end;
      end;
    SL.Free;

    s := Piece(sQual,'[',2);
    if pos('  ',s)= 0 then
      s := Piece(s,']',1)
    else
      s := Piece(s,'  ',1);
    i := cbMethod.Items.IndexOf(s);
    if i >= 0 then
      begin
        cbMethod.ItemIndex := i;
        QualVal := integer(cbMethod.Items.Objects[i]);   //AAN 11/5/2002 initial value added;
      end;
    ActiveControl := edtFlow;
    ShowModal;
    if ModalResult = mrOk then
      begin
        FlowRate := edtFlow.Text;
//AAN 07/09/2002        Percentage := edtO2Con.text;
        Percentage := edtO2Con.text + '^'+IntToStr(QualVal)+'^'+cbMethod.Text;
        Result := True;
      end;
  finally
    free;
  end;
end;

procedure TfrmGMV_SupO2.udFlowChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
var
  d: Double;
  Value: string;
begin
  Value := edtFlow.Text;
  if (Value = '') then
    VitalMath(Value, 0, 1, vfInit, 1)
  else
    begin
      case Direction of
        updUp: VitalMath(Value, 1, 10, vfAdd, 1);
        updDown: VitalMath(Value, 1, 10, vfSubtract, 1);
      end;
    end;
  try
    d := StrToFloat(Value);
    if d > 20.0 then Value := '20';
    if d < 0.5 then Value := '0.5';
  except
  end;
  edtFlow.Text := Value;
end;

procedure TfrmGMV_SupO2.udO2ChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Smallint; Direction: TUpDownDirection);
var
  d: Double;
  Value: string;
begin
  Value := edtO2Con.Text;
  if (Value = '') then
    VitalMath(Value, 0, 80, vfInit, 0)
  else
    begin
      case Direction of
        updUp: VitalMath(Value, 1, 80, vfAdd, 0);
        updDown: VitalMath(Value, 1, 80, vfSubtract, 0);
      end;
    end;
  try
    d := StrToFloat(Value);
    if d > 100.0 then Value := '100';
    if d < 21.0 then Value := '21';
  except
  end;
  edtO2Con.Text := Value;
end;

procedure TfrmGMV_SupO2.edtFlowKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tmp: boolean;
begin
  inherited;
  if (Key = VK_UP) then
    udFlowChangingEx(Sender, tmp, 0, updUp)
  else if (Key = VK_DOWN) then
    udFlowChangingEx(Sender, tmp, 0, updDown);
end;

procedure TfrmGMV_SupO2.edtO2ConKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tmp: boolean;
begin
  inherited;
  if (Key = VK_UP) then
    udO2ChangingEx(Sender, tmp, 0, updUp)
  else if (Key = VK_DOWN) then
    udO2ChangingEx(Sender, tmp, 0, updDown);
end;

procedure TfrmGMV_SupO2.cbMethodChange(Sender: TObject);
begin
  if
{$IFDEF CQ6942}
  // CQ Ticket # 6942 - Start
 (cbMethod.ItemIndex = 0)
    or
{$ENDIF}
    (pos('ROOM AIR',uppercase(cbMethod.Text))>0) // no values for Room Air
  then
    begin
      edtFlow.Text := '';
      edtO2Con.Text := '';
      edtFlow.Enabled := False;
      edtO2Con.Enabled := False;
      udFlow.Enabled := False;
      udO2.Enabled := False;

      lblFlow.Font.Color := clGray;
      lblO2Con.Font.Color := clGray;
      lblLitMin.Font.Color := clGray;
      lblPercent.Font.Color := clGray;

      try
        QualVal := integer(cbMethod.Items.Objects[cbMethod.ItemIndex]);
      except
        QualVal := -99;
      end;
    end
  else   // CQ Ticket # 6942 - end
    begin
      edtFlow.Enabled := True;
      edtO2Con.Enabled := True;
      udFlow.Enabled := True;
      udO2.Enabled := True;
      lblFlow.Font.Color := clWindowText;
      lblO2Con.Font.Color := clWindowText;
      lblLitMin.Font.Color := clWindowText;
      lblPercent.Font.Color := clWindowText;
      try
        QualVal := integer(cbMethod.Items.Objects[cbMethod.ItemIndex]);
      except
        QualVal := -99;
      end;
    end;
end;

procedure TfrmGMV_SupO2.FormActivate(Sender: TObject);
begin
  if (Left + Width) > Forms.Screen.Width then
    Left := Forms.Screen.Width - Width;
  if (Top + Height) > Forms.Screen.Height then
    Top := Forms.Screen.Height - Height - pnlBottom.Height div 2;
end;

procedure TfrmGMV_SupO2.btnOKClick(Sender: TObject);
var
  s,ss: String;
  i: integer;
  f: double;
begin
  try
    i :=0;
    if edtO2Con.Text <> '' then
      i := StrToInt(edtO2Con.Text);
  except
    s :='Invalid value for O2 concentration entered: <'+
        String(edtO2Con.Text)+'>'+#13+
//        'Valid values are integers between 21 and 100'+#13+#13+'Try again?';
        'Valid values are integers from 21 to 100'+#13+#13+'Try again?';
    if Application.MessageBox(pChar(s),'Value Error', MB_OKCANCEL + MB_DEFBUTTON1) <> IDOK
    then
      ModalResult := mrCancel
    else
      begin
        activeControl := edtO2Con;
        ModalResult := mrNone;
      end;
    Exit;
  end;
  try
    f := 0;
    if edtFlow.Text <> '' then
      f := StrToFloat(edtFlow.Text);
  except
    s := 'Error value for the flow rate entered: <'+ edtFlow.Text+'>'+#13+
//        'Valid values are between 0.5 and 20'+#13+#13+'Try again?';
        'Valid values are from 0.5 to 20'+#13+#13+'Try again?';
    if Application.MessageBox(PChar(s),'Value Error', MB_OKCANCEL + MB_DEFBUTTON1) <> IDOK
    then
      ModalResult := mrCancel
    else
      begin
        activeControl := edtFlow;
        ModalResult := mrNone;
      end;
    Exit;
  end;

  if edtO2Con.Text <> '' then
    if (i<21) or (i>100) then s := 'O2 concentration value '+edtO2Con.Text+' is out of range'
    else s := '';
  if edtFlow.Text <> '' then
    if (f<0.5) or (f>20) then ss := 'Flow rate value '+edtFlow.Text+' is out of range (.5-20)'
    else ss := '';

  if (s+#13+ss)<>#13 then
    begin
      s := s+#13+ss+#13+'Try again?';
      if Application.MessageBox(PChar(s),'Range Error', MB_OKCANCEL + MB_DEFBUTTON1) <> IDOK
      then
        ModalResult := mrCancel
      else
        begin
          if (i<21) or (i>100) then ActiveControl := edtO2Con
          else ActiveControl := edtFlow;
          ModalResult := mrNone;
        end;
      Exit;
    end;

  ModalResult := mrOK;
end;

procedure TfrmGMV_SupO2.edtFlowKeyPress(Sender: TObject; var Key: Char);
begin
  if pos(Key,'-,`~!@#$%^&*()_+=|\/"''') > 0 then
    Key := #0;
  inherited;
end;

procedure TfrmGMV_SupO2.edtO2ConKeyPress(Sender: TObject; var Key: Char);
begin
  if pos(Key,'-,`~!@#$%^&*()_+=|\/"''') > 0 then
    Key := #0;
  inherited;
end;

procedure TfrmGMV_SupO2.edtFlowChange(Sender: TObject);
var
  d: Double;
begin
  try
    d := StrToFloat(edtFlow.Text);
    if d > 20.0 then
      begin
        ShowMessage('Flow rate value '+edtFlow.Text+' is out of range (.5-20)');
        edtFlow.SelStart := Length(edtFlow.Text)-1;
        edtFlow.SelLength := 1;
      end;
  except
  end;
end;

procedure TfrmGMV_SupO2.edtFlowExit(Sender: TObject);
var
  d: Double;
begin
  if edtFlow.Text = '' then Exit;
  try
    d := StrToFloat(edtFlow.Text);
    if (d > 20.0) or (d < 0.5) then
      begin
        ShowMessage('Flow rate value '+edtFlow.Text+' is out of range (.5-20)');
        edtFlow.SelStart := Length(edtFlow.Text)-1;
        edtFlow.SelLength := 1;
        ActiveControl := edtFlow;
      end;
  except
  end;
end;


procedure TfrmGMV_SupO2.edtO2ConChange(Sender: TObject);
var
  d: Double;
begin
  try
    d := StrToFloat(edtO2Con.Text);
    if d > 100.0 then
      begin
        ShowMessage('Flow rate value '+edtO2Con.Text+' is out of range (21-100)');
        edtO2Con.SelStart := Length(edtO2Con.Text)-1;
        edtO2Con.SelLength := 1;
      end;
  except
  end;
end;

procedure TfrmGMV_SupO2.edtO2ConExit(Sender: TObject);
var
  d: Double;
begin
  if edtO2Con.Text = '' then Exit;
  try
    d := StrToFloat(edtO2Con.Text);
    if (d > 100.0) or (d < 21.0) then
      begin
        ShowMessage('O2 concentration value '+edtO2Con.Text+' is out of range (21-100)');
        edtO2Con.SelStart := Length(edtO2Con.Text)-1;
        edtO2Con.SelLength := 1;
        ActiveControl := edtO2Con;
      end;
  except
  end;
end;

end.
