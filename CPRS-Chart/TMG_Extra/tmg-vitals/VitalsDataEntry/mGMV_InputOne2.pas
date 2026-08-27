unit mGMV_InputOne2;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 2 $  $Modtime: 7/22/05 10:20a $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Frame to manage the input of a single vital.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry/mGMV_InputOne2.pas $
*
* $History: mGMV_InputOne2.pas $
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
*
================================================================================
}
interface

uses
  System.UITypes,  //kt //codex 8/26/26
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  ComCtrls,
  ExtCtrls
  , ActnList
  , uGMV_Template
  , uGMV_FileEntry
  , uGMV_GlobalVars
  , uGMV_VitalTypes
  ;

type
  TfraGMV_InputOne2 = class(TFrame)
    pnlMain: TPanel;
    pnlValues: TPanel;
    cbxInput: TComboBox;
    pnlRefusedUnavailable: TPanel;
    cbxRefused: TCheckBox;
    cbxUnavailable: TCheckBox;
    pnlQualifiers: TPanel;
    bbtnQualifiers: TBitBtn;
    lblQualifiers: TLabel;
    ckbMetric: TCheckBox;
    pnlName: TPanel;
    lblVital: TLabel;
    lblUnit: TLabel;
    lblNum: TLabel;
    bvU: TBevel;
    bvR: TBevel;
    bvMetric: TBevel;
    bvQual: TBevel;
    cbxUnits: TComboBox;
    procedure cbxInputExit(Sender: TObject);
    procedure bbtnQualifiersClick(Sender: TObject);
    procedure ckbMetricClick(Sender: TObject);
    procedure cbxRefusedClick(Sender: TObject);
    procedure cbxUnavailableClick(Sender: TObject);
    procedure DisablePanel;
    procedure EnablePanel;
    procedure cbxRefusedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; x, Y: integer);
    procedure cbxUnavailableMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; x, Y: integer);
    procedure cbxInputKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxInputChange(Sender: TObject);
    procedure cbxInputClick(Sender: TObject);
    procedure acMetricChangedExecute(Sender: TObject);
    procedure ckbMetricEnter(Sender: TObject);
    procedure ckbMetricExit(Sender: TObject);
    procedure cbxRefusedEnter(Sender: TObject);
    procedure cbxRefusedExit(Sender: TObject);
    procedure cbxUnavailableExit(Sender: TObject);
    procedure cbxUnavailableEnter(Sender: TObject);
    procedure bbtnQualifiersEnter(Sender: TObject);
    procedure bbtnQualifiersExit(Sender: TObject);
    procedure cbxInputKeyPress(Sender: TObject; var Key: Char);
    procedure cbxInputEnter(Sender: TObject);
    procedure cbxUnitsEnter(Sender: TObject);
    procedure cbxUnitsExit(Sender: TObject);
  private
    FTemplateVital: TGMV_TemplateVital;
    FTemplateVitalType: TVitalType;
    FVitalQualifiers: string;
    FValueDbl: Double; {This stores the value for the input in US Standard where applicable}
    FValueInt: integer; {This stores the value for the input in US Standard where applicable}
//    FValueStr: string; {This stores the value for the input in US Standard where applicable}
    FPO2FlowRate: string;
    FPO2Percentage: string;
    bCPRSMetric: Boolean;
    bMetric: Boolean;
    function ValidBP: Boolean;
    function ValidTemperature: Boolean;
    function ValidPulse: Boolean;
    function ValidRespiration: Boolean;
    function ValidWeight: Boolean;
    function ValidHeight: Boolean;
    function ValidPain: Boolean;
    function ValidGirth: Boolean;
    function ValidPO2: Boolean;
    function ValidCVP: Boolean;
    {$IFDEF TMG_WOUNDS}
    function ValidWoundMeas: Boolean;  //elh 3/14/08
    //function ValidWoundVolArea: Boolean;  //elh 3/14/08
    //function ValidWoundHFPct: Boolean;  //elh 3/14/08
    {$ENDIF}
    procedure OutOfRange(aVitalType:String='');
    procedure SetTemplateVital(const Value: TGMV_TemplateVital);
    procedure SetPanelStatus(bStatus:Boolean);//AAN 07/11/2002
    function HintString(isMetric:Boolean):String;
    { Private declarations }
  public
    ConversionWarning: Boolean;
    Valid: Boolean;
    DefaultTemplateVital: TGMV_TemplateVital;
    function VitalIEN: string;
    function VitalsRate: string;
    function VitalsQualifiers: string;
    procedure ShowMetrics;
    procedure SetMetricStyle(bCPRSStyle:Boolean);
    function Check:Boolean;
    procedure ClearPO2FlowRateAndPercentage;
    procedure SetMetricUnitLabels(aMetric:Boolean);

    function getStatusString:String;
    procedure setStatusString(aString:String);
  published
    property TemplateVital: TGMV_TemplateVital
      read FTemplateVital write SetTemplateVital;
  end;

implementation

uses
  fGMV_SupO2,
  fGMV_Qualifiers
  , uGMV_Utils
  , mGMV_GridGraph  //kt added
  , uGMV_Common
  , uGMV_Const, fGMV_InputLite;

{$R *.DFM}

var
  tmpDouble: Double;
  tmpInt: integer;

const
  cRefused = 'Refused';
  cUnavailable = 'Unavailable';

  { TfraGMV_InputOne }
procedure TfraGMV_InputOne2.ClearPO2FlowRateAndPercentage;
begin
  FPO2FlowRate := '';
  FPO2Percentage := '';
end;

procedure TfraGMV_InputOne2.ShowMetrics;
begin
  if not bCPRSMetric then
    begin
      cbxUnits.Visible := False;
      if lblUnit.caption <> '' then lblUnit.visible := True;   //elh 3/14/08
      //lblUnit.Visible := bMetric;  //elh 3/14/08  - now shows units if text exists, rather than if metric
      ckbMetric.Visible := bMetric;
    end
  else
    begin
      if lblUnit.caption <> '' then lblUnit.visible := True;  //elh 3/14/08
      //lblUnit.Visible := False;     //elh 3/14/08 - now shows units if text exists, rather than if metric
      ckbMetric.Visible := False;
      cbxUnits.Visible := bMetric;
//      cbxUnits.Visible := bCPRSMetric; //??
    end;
  cbxInput.Hint := HintString(ckbMetric.Checked);
  SetMetricUnitLabels(ckbMetric.Checked);
end;

procedure TfraGMV_InputOne2.SetMetricStyle(bCPRSStyle:Boolean);
begin
  bcPRSMetric := bCPRSStyle;
  ShowMetrics;
end;

procedure TfraGMV_InputOne2.SetTemplateVital(const Value: TGMV_TemplateVital);
var
  i: integer;
  aType: TVitalType;
begin
  Valid := True;
  FTemplateVital := Value;
  lblVital.Caption := TitleCase(FTemplateVital.VitalName) + ':';
  ckbMetric.Checked := FTemplateVital.Metric;
  lblQualifiers.Caption := '';
  FVitalQualifiers := '';
  i := 1;
  while Piece(FTemplateVital.Qualifiers, '~', i) <> '' do
    begin
      if FVitalQualifiers <> '' then
        FVitalQualifiers := FVitalQualifiers + ':';
      FVitalQualifiers := FVitalQualifiers + Piece(Piece(FTemplateVital.Qualifiers, '~', i), ',', 2);
      inc(i);
    end;
  //Defaults --- //AAN 07/10/2002
  cbxInput.Style := csSimple;
  cbxInput.Text := '';
  ckbMetric.Visible := False;
  cbxUnits.Visible := False;
  lblQualifiers.Caption := TitleCase(FTemplateVital.DisplayQualifiers);
  lblUnit.Caption := '';
  lblUnit.Visible := False;
  ckbMetric.Visible := False;

  bvQual.Visible := False;
  bvU.Visible := False;
  bvR.Visible := False;
  bvMetric.Visible := False;

  bMetric := False;
  bCPRSMetric := False;
// Changes to avoid using fixed number for the types -------------- AAN 12/04/02
//  case StrToIntDef(FTemplateVital.IEN, -1) of
  aType := VitalTypeByString(FTemplateVital.IEN);
  case aType of             //kt make changes here
    vtBP:  FTemplateVitalType := vtBP;
    vtTemp:
      begin
        FTemplateVitalType := vtTemp;
        ckbMetric.Visible := True;

        lblUnit.Caption := 'F';
        cbxUnits.Items.Clear;
        cbxUnits.Items.Add('F');
        cbxUnits.Items.Add('C');
        if ckbMetric.Checked then
          cbxUnits.ItemIndex := 1
        else
          cbxUnits.ItemIndex := 0;

        bMetric := True;
      end;
    vtResp:  FTemplateVitalType := vtResp;
    vtPulse: FTemplateVitalType := vtPulse;
    vtHeight:
      begin
        FTemplateVitalType := vtHeight;
        ckbMetric.Visible := True;
        lblUnit.Caption := '(in)';
        cbxUnits.Items.Clear;
        cbxUnits.Items.Add('in');
        cbxUnits.Items.Add('cm');
        if ckbMetric.Checked then
          cbxUnits.ItemIndex := 1
        else
          cbxUnits.ItemIndex := 0;
        bMetric := True;
      end;
    vtWeight:
      begin
        FTemplateVitalType := vtWeight;
        ckbMetric.Visible := True;
        lblUnit.Caption := '(lb)';
        cbxUnits.Items.Clear;
        cbxUnits.Items.Add('lb');
        cbxUnits.Items.Add('kg');
        if ckbMetric.Checked then
          cbxUnits.ItemIndex := 1
        else
          cbxUnits.ItemIndex := 0;

        bMetric := True;
      end;
    vtCircum:
      begin
        FTemplateVitalType := vtCircum;
        ckbMetric.Visible := True;
        lblUnit.Caption := '(in)';
        cbxUnits.Items.Clear;
        cbxUnits.Items.Add('in');
        cbxUnits.Items.Add('cm');
        cbxUnits.Text := 'in';
        if ckbMetric.Checked then
          cbxUnits.ItemIndex := 1
        else
          cbxUnits.ItemIndex := 0;

        bMetric := True;
      end;
    vtCVP:
      begin
        FTemplateVitalType := vtCVP;
        ckbMetric.Caption := 'mmHg';
        ckbMetric.Visible := True;

        lblVital.Caption := 'CVP';//AAN 07/03/2002
        bbtnQualifiers.Visible := False;
        lblQualifiers.Caption := '';
        lblUnit.Caption := '(cmH2O)';
        cbxUnits.Items.Clear;
        cbxUnits.Items.Add('cmH20');
        cbxUnits.Items.Add('mmHg');
        cbxUnits.Text := 'cmH20';
        if ckbMetric.Checked then
          cbxUnits.ItemIndex := 1
        else
          cbxUnits.ItemIndex := 0;

        bMetric := True;
      end;
    vtPO2:
      begin
        FTemplateVitalType := vtPO2;
        lblQualifiers.Caption := '[]';

        bbtnQualifiers.Hint := 'Press to select Supplemental Oxygen Rate, Concentration and Method';
      end;
    vtPain:
      begin
        FTemplateVitalType := vtPain;
        cbxInput.Style := csDropDownList; // vhaishandria 050209 end
// vhaishandria 050706 added blank line to the pain list
        cbxInput.Items.CommaText := '"","0 - no pain","1 - slightly uncomfortable",2,3,4,5,6,7,8,9,"10 - worst imaginable","99 - unable to respond"';
        cbxInput.ItemIndex := -1;
        cbxInput.Hint := 'Enter a value from '+FloatToStr(GMVVitalLoRange[FTemplateVitalType])+
          ' to '+ FloatToStr(GMVVitalHiRange[FTemplateVitalType])+' or 99';//AAN 04/15/2003
        bbtnQualifiers.Visible := False;
        lblQualifiers.Caption := '';
      end;

      {$IFDEF TMG_WOUNDS}
      //elh 3/26/08
      vtWoundMeas1:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas1;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas2:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas2;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas3:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas3;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas4:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas4;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas5:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas5;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas6:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas6;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas7:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas7;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas8:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas8;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas9:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas9;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas10:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas10;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas11:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas11;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas12:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas12;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas13:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas13;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas14:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas14;
        lblUnit.Caption := '(cm)';
      end;

      vtWoundMeas15:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundMeas15;
        lblUnit.Caption := '(cm)';
      end;

      {vtWoundAreaVol1,vtWoundAreaVol2,vtWoundAreaVol3,vtWoundAreaVol4,
      vtWoundAreaVol5,vtWoundAreaVol6,vtWoundAreaVol7,vtWoundAreaVol8,
      vtWoundAreaVol9,vtWoundAreaVol10,vtWoundAreaVol11,vtWoundAreaVol12,
      vtWoundAreaVol13,vtWoundAreaVol14,vtWoundAreaVol15:
      begin
      //elh   3/14/08
        FTemplateVitalType := vtWoundAreaVol1;
        lblUnit.Caption := '(cm²)';
        //elh comment the next two lines if qualifiers are to be used  3/14/08
        bbtnQualifiers.Visible := False;
        lblQualifiers.Caption := '';
      end;

      vtWoundHFPct1,vtWoundHFPct2,vtWoundHFPct3,vtWoundHFPct4,vtWoundHFPct5,
      vtWoundHFPct6,vtWoundHFPct7,vtWoundHFPct8,vtWoundHFPct9,vtWoundHFPct10,
      vtWoundHFPct11,vtWoundHFPct12,vtWoundHFPct13,vtWoundHFPct14,vtWoundHFPct15:
      begin
      //elh  3/14/08
        FTemplateVitalType := vtWoundHFPct1;
        lblUnit.Caption := '(%)';
        //elh comment the next two lines if qualifiers are to be used  3/14/08
        bbtnQualifiers.Visible := False;
        lblQualifiers.Caption := '';
      end;}
      {$ENDIF}
  else
    FTemplateVitalType := vtUnknown;
  end;
  cbxInput.Hint := HintString(ckbMetric.Checked);//HintText;//AAN 07/08/2002  //kt moved below case
  ShowMetrics;
end;

function TfraGMV_InputOne2.HintString(isMetric:Boolean):String;
var
  fLow,fHigh:Double;
begin
  fLow := GMVVitalLoRange[FTemplateVitalType];
  fHigh := GMVVitalHiRange[FTemplateVitalType];
//kt  if isMetric then begin
    //messagedlg('Type Sent ',mtInformation ,mbOKCancel ,0);
    Result := 'Please enter a value from  ';
    case FTemplateVitalType of
      vtTemp:   begin
                  fLow := ConvertFToC(fLow);
                  fHigh := ConvertFToC(fHigh);
                  Result := Result + FloatToStr(fLow) + ' to ' +  FloatToStr(fHigh);
                end;
      vtHeight,
      vtCircum: begin
                  fLow := fLow*2.54;
                  fHigh := fHigh*2.54;
                  Result := Result + FloatToStr(fLow) + ' to ' +  FloatToStr(fHigh);
                end;
      vtWeight: begin
                  fLow :=ConvertLbsToKgs(fLow);
                  fHigh :=ConvertLbsToKgs(fHigh);
                  Result := Result + FloatToStr(fLow) + ' to ' +  FloatToStr(fHigh);
                end;
      vtCVP:    begin
                  fLow := ConvertcmH20TommHg(fLow);
                  fHigh := ConvertcmH20TommHg(fHigh);
                  Result := Result + FloatToStr(fLow) + ' to ' +  FloatToStr(fHigh);
                end;
    {$IFDEF TMG_WOUNDS}
    vtWoundMeas1..vtWoundMeas15 : begin
                  Result := 'Please enter a LxWxD, each value from '
                             + FloatToStr(fLow) + ' to ' +  FloatToStr(fHigh);
                end;
    {$ENDIF}
       else     begin
                  Result := Result + FloatToStr(fLow) + ' to ' +  FloatToStr(fHigh);
                end;
    end; {case}
//kt  end;
end;

procedure TfraGMV_InputOne2.OutOfRange(aVitalType:String='');
var
  s: String;
begin
  s := 'The value you entered is out of range for this vital.' + #13 +#13+
      HintString(ckbMetric.Checked);
  if aVitalType <> '' then  s := 'Vital Type: '+aVitalType+ #13+#13+s;
  MessageDlg(s, mtError, [mbOk], 0);
end;

procedure TfraGMV_InputOne2.cbxInputExit(Sender: TObject);
begin
//messagedlg('Check here',mtInformation ,mbOKCancel ,0);
  if not Check then
    cbxInput.SetFocus;
  setStatusString('');
end;

procedure TfraGMV_InputOne2.bbtnQualifiersClick(Sender: TObject);
var
  s: String;
  Quals: string;
  QualsText: string;
  PO2FlowRate: string;
  PO2Percentage: string;

const // vhaishandria 050714
  cRoomAir = 'ROOM AIR'; // vhaishandria 050714

begin
  if FTemplateVitalType = vtPO2 then
    begin
      PO2FlowRate := FPO2FlowRate;
      PO2Percentage := FPO2Percentage;
      if GetSupplementO2Data(PO2FlowRate, PO2Percentage, TControl(Sender),lblQualifiers.Caption) then
        begin
          FPO2FlowRate := PO2FlowRate;
          FPO2Percentage := piece(PO2Percentage,'^',1);
          FVitalQualifiers := piece(PO2Percentage,'^',2);
          QualsText := piece(PO2Percentage,'^',3);
          s := ' ';//AAN 11/07/2002 -- two spaces between Qualifier and data
          if FPO2FlowRate <> '' then
              s := s + ' ' + FPO2FlowRate + ' l/min';
          if FPO2Percentage <> '' then
            s := s + ' ' + FPO2Percentage + ' %';
          if s = ' ' then s := '';
          if (FPO2FlowRate <> '') or (FPO2Percentage <> '') then
             lblQualifiers.Caption := '[' + QualsText + s + ']'
          else if pos(cRoomAir,uppercase(QualsText)) > 0 then // vhaishandria 050714
             lblQualifiers.Caption := '[' + QualsText + ']' // vhaishandria 050714
          else
             lblQualifiers.Caption := '[]';
        end;
      Exit;
    end;

  Quals := FVitalQualifiers;
  if SelectQualifiers(FTemplateVitalType, Quals, QualsText, TControl(Sender),cbxInput.Text) then
    begin
      FVitalQualifiers := Quals;
      lblQualifiers.Caption := '[' + QualsText + ']';
    end;
end;

procedure TfraGMV_InputOne2.SetMetricUnitLabels(aMetric:Boolean);
begin
  if aMetric then
      case FTemplateVitalType of
        vtTemp: cbxUnits.Text := 'C';
        vtWeight: cbxUnits.Text := 'kg';
        vtHeight: cbxUnits.Text := 'cm';
        vtCircum: cbxUnits.Text := 'cm';
        vtCVP: cbxUnits.Text := 'mmHg';
      end
  else
      case FTemplateVitalType of
        vtTemp: cbxUnits.Text := 'F';
        vtWeight: cbxUnits.Text := 'lb';
        vtHeight: cbxUnits.Text := 'in';
        vtCircum: cbxUnits.Text := 'in';
        vtCVP: cbxUnits.Text := 'cmH20';
      end;
end;

procedure TfraGMV_InputOne2.ckbMetricClick(Sender: TObject);
var
  IsMetric: Boolean;
begin
  IsMetric := ckbMetric.Checked;
  if IsMetric then
      case FTemplateVitalType of
        vtTemp: lblUnit.Caption := '(C)';
        vtWeight: lblUnit.Caption := '(kg)';
        vtHeight: lblUnit.Caption := '(cm)';
        vtCircum: lblUnit.Caption := '(cm)';
        vtCVP: lblUnit.Caption := '(mmHg)';
      end
  else
      case FTemplateVitalType of
        vtTemp: lblUnit.Caption := '(F)';
        vtWeight: lblUnit.Caption := '(lb)';
        vtHeight: lblUnit.Caption := '(in)';
        vtCircum: lblUnit.Caption := '(in)';
        vtCVP: lblUnit.Caption := '(cmH20)';
      end;
  cbxInput.Hint := HintString(ckbMetric.Checked);// AAN 2003/06/06

{$IFDEF METRICCONVERSION}
  if (cbxInput.Text <> '') then
    begin
      IsMetric := ckbMetric.Checked;
      case FTemplateVitalType of
        vtTemp:
          begin
           if (cbxInput.Text <> '') then
              if IsMetric then
                  cbxInput.Text := FloatToStr(convertFToC(FValueDbl))
              else
                  cbxInput.Text := FloatToStr(FValueDbl);
          end;
        vtWeight:
          begin
            if IsMetric then
                cbxInput.Text := FloatToStr(ConvertLbsToKgs(FValueDbl))
            else
                cbxInput.Text := FloatToStr(FValueDbl);
          end;
        vtHeight:
          begin
            if IsMetric then
                cbxInput.Text := FloatToStr(ConvertInToCm(FValueDbl))
            else
                cbxInput.Text := FloatToStr(FValueDbl);
          end;
        vtCircum:
          begin
            if IsMetric then
                cbxInput.Text := FloatToStr(ConvertInToCm(FValueDbl))
            else
                cbxInput.Text := FloatToStr(FValueDbl);
          end;
//AAN 07/03/2002---------------------------------------------------------- Begin
        vtCVP:
          begin
            try
              if IsMetric then
                  cbxInput.Text := Format('%1.1f',[ConvertCMH20TommHg(FValueDbl)])
              else
                  cbxInput.Text := Format('%1.2f',[FValueDbl]);
            except
            end;
          end;
//AAN 07/03/2002------------------------------------------------------------ End
      end;
    end;
{$ELSE}
  if (cbxInput.Text <> '') and ConversionWarning then
    ShowMessage('Units have been changed...');
{$ENDIF}
end;

function TfraGMV_InputOne2.VitalsRate: string;
var
  S: String;
begin
//elh  to be changed
  if cbxRefused.Checked then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';Refused;'
  else if cbxUnavailable.Checked then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';Unavailable;'
  else if cbxInput.Text = '' then
    Result := ''
  else if FTemplateVitalType = vtCVP then
    begin
//      Result := GMVVitalTypeIEN[FTemplateVitalType] + Format(';%1.1f;',[FValueDbl]);
      s := Format(';%1.1f',[FValueDbl]);
      if pos('.0',s) = length(s)-1 then
        s := copy(s,1,Length(s)-2);
      Result := GMVVitalTypeIEN[FTemplateVitalType] + s + ';';
    end
  else if FTemplateVitalType = vtPO2 then
    begin
      Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + cbxInput.Text + ';';
      if FPO2FlowRate <> '' then
        s:= FPO2FlowRate + ' l/min '
      else
        s:= '';
      if FPO2Percentage <> '' then
        Result := Result + S + FPO2Percentage + '%'
      else if FPO2FlowRate <> '' then
        Result := Result + S;
    end
  else if FTemplateVitalType = vtTemp then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + FloatToStr(FValueDbl)
  else if FTemplateVitalType = vtWeight then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + FloatToStr(FValueDbl)
  else if FTemplateVitalType = vtHeight then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + FloatToStr(FValueDbl)
  else if FTemplateVitalType = vtPain then
    begin
      if pos('-',cbxInput.Text) <> 0 then
        Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' +
          copy(cbxInput.Text,1,pos('-',cbxInput.Text)-2)
      else
        Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + cbxInput.Text;
    end
  else if FTemplateVitalType = vtResp then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + IntToStr(FValueInt)
  else if FTemplateVitalType = vtPulse then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + IntToStr(FValueInt)
  else if FTemplateVitalType = vtBP then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + cbxInput.Text
  {$IFDEF TMG_WOUNDS}
  else if FTemplateVitalType in [vtWoundMeas1..vtWoundMeas15] then
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + cbxInput.Text
  //else if FTemplateVitalType = vtWoundAreaVol1 then
  //  Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + cbxInput.Text
  //else if FTemplateVitalType = vtWoundHFPct1 then
  //  Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + cbxInput.Text
  {$ENDIF}
  else
    Result := GMVVitalTypeIEN[FTemplateVitalType] + ';' + FloatToStr(FValueDbl);
end;

function TfraGMV_InputOne2.VitalsQualifiers: string;
begin
  if cbxRefused.Checked or cbxUnavailable.Checked then
    Result := ''
  else
    Result := FVitalQualifiers;
end;

function TfraGMV_InputOne2.VitalIEN: string;
begin
  Result := GMVVitalTypeIEN[FTemplateVitalType]
end;

procedure TfraGMV_InputOne2.cbxRefusedClick(Sender: TObject);
begin
  if cbxRefused.Checked or cbxUnavailable.Checked then
    begin
      DisablePanel;
      GetParentForm(self).Perform(CM_VITALCHANGED,0,0);//2003/08/29 AAN
    end
  else
    EnablePanel;
  if cbxRefused.Checked then
    begin
      cbxUnavailable.Checked := False;
      cbxInput.Text := '';
    end;
end;

procedure TfraGMV_InputOne2.cbxUnavailableClick(Sender: TObject);
begin
  if cbxUnavailable.Checked or cbxRefused.Checked then
    begin
      DisablePanel;
      GetParentForm(self).Perform(CM_VITALCHANGED,0,0);//2003/08/29 AAN
    end
  else
    EnablePanel;
  if cbxUnavailable.Checked then
    begin
      cbxRefused.Checked := False;
      cbxInput.Text := '';
    end;
end;

procedure TfraGMV_InputOne2.DisablePanel;
begin
  SetPanelStatus(False);
end;

procedure TfraGMV_InputOne2.EnablePanel;
begin
  SetPanelStatus(True);
end;

procedure TfraGMV_InputOne2.SetPanelStatus(bStatus:Boolean);
begin
  cbxInput.Enabled := bStatus;
  cbxUnits.Enabled := bStatus;
  lblUnit.Enabled := bStatus;
  lblNum.Enabled := bStatus;
  lblVital.Enabled := bStatus;
  ckbMetric.Enabled := bStatus;
  bbtnQualifiers.Enabled :=  bStatus;
  lblQualifiers.Enabled := bStatus;
  if bStatus then
    begin
      cbxInput.Color := clWindow;
      cbxUnits.Color := clWindow;
    end
  else
    begin
      cbxInput.Color := pnlValues.Color;
      cbxUnits.Color := pnlValues.Color;
    end;
end;

procedure TfraGMV_InputOne2.cbxRefusedMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; x, Y: integer);
var
  ScrollBox: TScrollBox;
  i: integer;
begin
  if (ssShift in Shift) and (cbxRefused.Checked) then
    if Self.Parent is TScrollBox then
      if MessageDlg('Mark all vitals as Refused?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then
        begin
          ScrollBox := TScrollBox(Self.Parent);
          for i := 0 to ScrollBox.ComponentCount - 1 do
            if ScrollBox.Components[i] is TfraGMV_InputOne2 then
              begin
                TfraGMV_InputOne2(ScrollBox.Components[i]).cbxRefused.Checked := True;
                TfraGMV_InputOne2(ScrollBox.Components[i]).cbxRefusedClick(Sender);
              end;
        end;
end;

procedure TfraGMV_InputOne2.cbxUnavailableMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; x, Y: integer);
var
  ScrollBox: TScrollBox;
  i: integer;
begin
  if (ssShift in Shift) and (cbxUnavailable.Checked) then
    if Self.Parent is TScrollBox then
      if MessageDlg('Mark all vitals as Unavailable?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then
        begin
          ScrollBox := TScrollBox(Self.Parent);
          for i := 0 to ScrollBox.ComponentCount - 1 do
            if ScrollBox.Components[i] is TfraGMV_InputOne2 then
              begin
                TfraGMV_InputOne2(ScrollBox.Components[i]).cbxUnavailable.Checked := True;
                TfraGMV_InputOne2(ScrollBox.Components[i]).cbxUnavailableClick(Sender);
              end;
        end;
end;

procedure TfraGMV_InputOne2.cbxInputKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  j, // NOIS RIC-0103-22002 Jan 27 2003
  i: integer;
//  s:String;
begin
  i := Self.ComponentIndex;
  if Key = VK_RETURN then
    begin
      if ssShift in Shift then
        begin
          while i > 0 do
            try
              TfraGMV_InputOne2(Parent.Components[i - 1]).cbxInput.SetFocus;
              break;
            except
              i := i - 1;
            end;
          if i = 0 then
            begin
              j := Self.ComponentIndex;
              i := Parent.ComponentCount;
              while j < i do
                try
                  TfraGMV_InputOne2(Parent.Components[i - 1]).cbxInput.SetFocus;
                  break;
                except
                  i := i - 1;
                end;
              if i=j then //AAN 2003/06/04 --
                begin
                  // Try to save
                  try
                     GetParentForm(Self).Perform(CM_SAVEINPUT, 0, 0);
                  except
                  end;
                end;
            end;
        end
      else
        begin
          while i < Parent.ComponentCount - 1 do
            try
              TfraGMV_InputOne2(Parent.Components[i + 1]).cbxInput.SetFocus;
              break;
            except
              i := i + 1;
            end;
          if i = Parent.ComponentCount - 1 then
            begin
              j := Self.ComponentIndex;
              i := 0;
              while i < j do
                try
                  TfraGMV_InputOne2(Parent.Components[i]).cbxInput.SetFocus;
                  break;
                except
                  i := i + 1;
                end;
              if i=j then //AAN 2003/06/04 --
                begin     // Try to save
                  try
                     GetParentForm(Self).Perform(CM_SAVEINPUT, 0, 0);
                  except
                  end;
                end;
            end;
        end;
    end;
end;

procedure TfraGMV_InputOne2.cbxInputChange(Sender: TObject);
begin
  if (cbxInput.Text = cRefused) or (cbxInput.Text = cUnavailable) then
    SetPanelStatus(False)
  else
    SetPanelStatus(True);
  GetParentForm(self).Perform(CM_VITALCHANGED,0,0);//09/11/02
end;

procedure TfraGMV_InputOne2.cbxInputClick(Sender: TObject);
begin
  cbxInput.SelStart := 0;
end;

procedure TfraGMV_InputOne2.acMetricChangedExecute(Sender: TObject);
begin
  case FTemplateVitalType of
    vtTemp:     ckbMetric.Checked := cbxUnits.Text = 'C';
    vtWeight:   ckbMetric.Checked := cbxUnits.Text = 'kg';
    vtHeight:   ckbMetric.Checked := cbxUnits.Text = 'cm';
    vtCircum:   ckbMetric.Checked := cbxUnits.Text = 'cm';
    vtCVP:      ckbMetric.Checked := cbxUnits.Text = 'mmHg';
  end;
  cbxInput.Hint := HintString(ckbMetric.Checked);
end;

procedure TfraGMV_InputOne2.ckbMetricEnter(Sender: TObject);
begin
  bvMetric.Visible := True;
end;

procedure TfraGMV_InputOne2.ckbMetricExit(Sender: TObject);
begin
  bvMetric.Visible := False;
end;

procedure TfraGMV_InputOne2.cbxRefusedEnter(Sender: TObject);
begin
  bvR.Visible := True;
end;

procedure TfraGMV_InputOne2.cbxRefusedExit(Sender: TObject);
begin
  bvR.Visible := False;
end;

procedure TfraGMV_InputOne2.cbxUnavailableExit(Sender: TObject);
begin
  bvU.Visible := False;
end;

procedure TfraGMV_InputOne2.cbxUnavailableEnter(Sender: TObject);
begin
  bvU.Visible := True;
end;

procedure TfraGMV_InputOne2.bbtnQualifiersEnter(Sender: TObject);
begin
  bvQual.Visible := True;
  setStatusString(lblQualifiers.Caption);
end;

procedure TfraGMV_InputOne2.bbtnQualifiersExit(Sender: TObject);
begin
  bvQual.Visible := False;
  setStatusString('');
end;

//=================================================================== Validation
//==============================================================================
function MessageDlgEnteredInvalidValue(S,ErrorS:String;sType:String=''): Word;//AAN 07/03/2002
var
  ss: String;
begin
  if ErrorS = '' then
//    ss := 'The value you entered ''' + S + ''' is not valid' + #13 + #13 + ErrorS;
    ss := 'The value you entered ''' + S + ''' is not valid'
  else
    ss := ErrorS;

  if sType <> '' then
    ss := 'Vital Type: '+sType+#13#13+ss;

  result :=  MessageDlg(ss, mtError, [mbok], 0);
end;

function TfraGMV_InputOne2.Check:Boolean;
var
  OKToProceed: Boolean;
begin
  OKToProceed := True;
  if cbxInput.Text <> '' then
    begin
      case FTemplateVitalType of
        //kt make changes here
        vtUnknown:
          begin
            MessageDlg('Unknown Vital Type!', mtError, [mbok], 0);
            OKToProceed := True;
          end;

        vtBP: OKToProceed := ValidBP;
        vtTemp: OKToProceed := ValidTemperature;
        vtPulse: OKToProceed := ValidPulse;
        vtResp: OKToProceed := ValidRespiration;
        vtHeight: OKToProceed := ValidHeight;
        vtWeight: OKToProceed := ValidWeight;
        vtPain: OKToProceed := ValidPain;
        vtCircum: OKToProceed := ValidGirth;
        vtPO2: OKToProceed := ValidPO2;
        vtCVP: OKToProceed := ValidCVP;
        {$IFDEF TMG_WOUNDS}
        //elh  added wounds  3/14/08
        vtWoundMeas1: OKToProceed := ValidWoundMeas;
        vtWoundMeas2: OKToProceed := ValidWoundMeas;
        vtWoundMeas3: OKToProceed := ValidWoundMeas;
        vtWoundMeas4: OKToProceed := ValidWoundMeas;
        vtWoundMeas5: OKToProceed := ValidWoundMeas;
        vtWoundMeas6: OKToProceed := ValidWoundMeas;
        vtWoundMeas7: OKToProceed := ValidWoundMeas;
        vtWoundMeas8: OKToProceed := ValidWoundMeas;
        vtWoundMeas9: OKToProceed := ValidWoundMeas;
        vtWoundMeas10: OKToProceed := ValidWoundMeas;
        vtWoundMeas11: OKToProceed := ValidWoundMeas;
        vtWoundMeas12: OKToProceed := ValidWoundMeas;
        vtWoundMeas13: OKToProceed := ValidWoundMeas;
        vtWoundMeas14: OKToProceed := ValidWoundMeas;
        vtWoundMeas15: OKToProceed := ValidWoundMeas;
        {$ENDIF}
      else
        begin
          MessageDlg('Cannot validate this vital type.', mtError, [mbok], 0);
          OKToProceed := False;
        end;
      end;
    end;

  Valid := OKToProceed;
  Result := OKToProceed;
end;



function TfraGMV_InputOne2.ValidPain: Boolean;
var
  PainValue: integer;
begin
// vhaishandria 050706 blank value for pain added
  if cbxInput.Text = '' then
    begin
      Result := True;
      Exit;
    end;

  if pos('-',cbxInput.Text) <> 0 then
    begin
      PainValue := StrToInt(Copy(cbxInput.Text,1,pos('-',cbxInput.Text)-2));
    end
  else
    PainValue := StrToIntDef(cbxInput.Text, -1);

  if ((PainValue >= 0) and (PainValue <= 10)) or (PainValue = 99) then
    begin
      FValueInt := PainValue;
      Result := True;
    end
  else
    begin
      MessageDlg('Pain must be a numeric value from 0 to 10 ' + #13 +
                  'or 99 if patient is unable to respond.',mtError,[],0);
      Result := False;
    end;
end;

function TfraGMV_InputOne2.ValidPO2: Boolean;
begin
  Result := False;
  try
    tmpInt := StrToInt(cbxInput.Text);
    if (tmpInt >= GMVVitalLoRange[vtPO2]) and
      (tmpInt <= GMVVitalHiRange[vtPO2]) then
      begin
        {Process valid PO2 Here}
        FValueInt := tmpInt;
        Result := True;
      end
    else
      OutOfRange(sgnPOX);
  except
    on E: EConvertError do
//      MessageDlg('The value you entered ''' + cbxInput.Text + ''' is not valid',
//        mtError, [mbok], 0);
      MessageDlgEnteredInvalidValue(cbxInput.Text,'',sgnPOX);
  else
    raise;
  end;
end;

{$IFDEF TMG_WOUNDS}
function TfraGMV_InputOne2.ValidWoundMeas: Boolean;  //elh 3/14/08
var
  s: string;
  sL, sW, sD: double;
begin
  Result := False;
  try
    s := uppercase(cbxInput.Text);
    sL := StrToFloat(Piece(s, 'X', 1));
    sW := StrToFloat(Piece(s, 'X', 2));
    sD := StrToFloat(Piece(s, 'X', 3));
    Result := False;

    //tmpInt := StrToInt(cbxInput.Text);
    if (sL >= GMVVitalLoRange[vtWoundMeas1]) and
      (sL <= GMVVitalHiRange[vtWoundMeas1]) or
      (sW >= GMVVitalLoRange[vtWoundMeas1]) and
      (sW <= GMVVitalHiRange[vtWoundMeas1]) or
      (sD >= GMVVitalLoRange[vtWoundMeas1]) and
      (sD <= GMVVitalHiRange[vtWoundMeas1]) then
      begin
        {Process valid wound measure Here}
        FValueInt := tmpInt;
        Result := True;
      end
    else
      OutOfRange('Wound Measurement');
  except
    on E: EConvertError do
//      MessageDlg('The value you entered ''' + cbxInput.Text + ''' is not valid',
//        mtError, [mbok], 0);
      MessageDlgEnteredInvalidValue(cbxInput.Text,'','Wound Measurement');
  else
    raise;
  end;
end;

(*function TfraGMV_InputOne2.ValidWoundVolArea: Boolean;
//elh Here we have to check three pieces of data LxWxD 3/14/08
begin
  Result := False;
  try
    tmpInt := StrToInt(cbxInput.Text);
    if (tmpInt >= GMVVitalLoRange[vtWoundAreaVol1]) and
      (tmpInt <= GMVVitalHiRange[vtWoundAreaVol1]) then
      begin
        {Process valid wound vol area Here}
        FValueInt := tmpInt;
        Result := True;
      end
    else
      OutOfRange('Wound Volume Area');
  except
    on E: EConvertError do
//      MessageDlg('The value you entered ''' + cbxInput.Text + ''' is not valid',
//        mtError, [mbok], 0);
      MessageDlgEnteredInvalidValue(cbxInput.Text,'','Wound Volume Area');
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidWoundHFPct: Boolean;  //elh 3/14/08
begin
  Result := False;
  try
    tmpInt := StrToInt(cbxInput.Text);
    if (tmpInt >= GMVVitalLoRange[vtWoundHFPct1]) and
      (tmpInt <= GMVVitalHiRange[vtWoundHFPct1]) then
      begin
        {Process valid wound hf pct Here}
        FValueInt := tmpInt;
        Result := True;
      end
    else
      OutOfRange('Wound Healing Factor Percent');
  except
    on E: EConvertError do
//      MessageDlg('The value you entered ''' + cbxInput.Text + ''' is not valid',
//        mtError, [mbok], 0);
      MessageDlgEnteredInvalidValue(cbxInput.Text,'','Wound Healing Factor Percent');
  else
    raise;
  end;
end;  *)
{$ENDIF}


function TfraGMV_InputOne2.ValidCVP: Boolean;
begin
  Result := False;
  if cbxInput.Text = '.' then
    begin
      MessageDlgEnteredInvalidValue(cbxInput.Text,'','CVP');//vhaishandria 050429
      Exit;
    end;
  try
//AAN 07/03/2002---------------------------------------------------------- Begin
    tmpDouble := StrToFloat(cbxInput.Text);
    if ckbMetric.Checked then
      tmpDouble := ConvertmmHGtoCMH20(tmpDouble);
    if (tmpDouble >= GMVVitalLoRange[vtCVP]) and
      (tmpDouble <= GMVVitalHiRange[vtCVP]) then
      begin
        {Process valid CVP Here}
        FValueDbl := tmpDouble;
        Result := True;
      end
//AAN 07/03/2002------------------------------------------------------------ End
    else
      OutOfRange('CVP');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'CVP');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidBP: Boolean;
var
  i,iCount: Integer;
  s, sS, sD, sM: String;
  bS,bD,bM: Boolean;
  Systolic, Diastolic, Middle: integer;
begin
  Result := False;
  try
{AAN 2003/06/05-----------------------------------------------------------Start}
    s := cbxInput.Text;
    sS := Piece(s, '/', 1);
    sD := Piece(s, '/', 2);
    sM := Piece(s, '/', 3);

    iCount := 0;
    for i := 1 to length(s) do
      if copy(s,i,1) = '/' then inc(iCount);

    s := Piece(cbxInput.Text, '/', 4);
    if (s <>'') or (iCount > 2) or (iCount < 1)
      or ((iCount=2) and (sD='') and (sM=''))
      or ((iCount=2) and (sM=''))
//      or ((iCount=1) and (sD='')) // comment this line to let values like '120/'
      then
      begin
//        MessageDlg(sMsgInvalidBP, mtError, [mbok], 0);
        MessageDlgEnteredInvalidValue(cbxInput.Text,sMsgInvalidBP,'BP');//AAN 07/03/2002
        Exit;
      end;

    Systolic := StrToInt(sS);
    bS :=
      (Systolic >= GMVVitalLoRange[vtBP]) and
      (Systolic <= GMVVitalHiRange[vtBP]);

    if sD <> '' then
      Diastolic :=StrToInt(sD)
    else
      Diastolic := -1;
    bD := (sD = '') or
      ((Diastolic >= GMVVitalLoRange[vtBP]) and
       (Diastolic <= GMVVitalHiRange[vtBP]));

    if sM <> '' then
      Middle :=StrToInt(sM)
    else
      Middle := -1;
    bM := (sM = '') or
          ((Middle >= GMVVitalLoRange[vtBP]) and
          (Middle <= GMVVitalHiRange[vtBP]));

    Result :=(bS and bD and bM);

    if sM = '' then
      Result := Result and (Diastolic < Systolic)
    else
      Result := Result and (Middle < Systolic);


    if not Result then
//      MessageDlg(sMsgInvalidBP,mtError, [mbok], 0);
        MessageDlgEnteredInvalidValue(cbxInput.Text,sMsgInvalidBP,'BP');//AAN 07/03/2002
    Exit;

{AAN 2003/06/05-------------------------------------------------------------End}
    Systolic := StrToInt(Piece(cbxInput.Text, '/', 1));
    Diastolic := StrToInt(Piece(cbxInput.Text, '/', 2));
    Middle := StrToIntDef(Piece(cbxInput.Text, '/', 3), 0);
    if Diastolic = 0 then
      begin
        if
          (Systolic >= GMVVitalLoRange[vtBP]) and
          (Systolic <= GMVVitalHiRange[vtBP]) and
          (Middle >= GMVVitalLoRange[vtBP]) and
          (Middle <= GMVVitalHiRange[vtBP]) then
          begin
            Result := True;
          end
        else
          Exit;
      end;

    if (
      (Middle = 0) and
      (Systolic >= GMVVitalLoRange[vtBP]) and
      (Systolic <= GMVVitalHiRange[vtBP]) and
      (Diastolic >= GMVVitalLoRange[vtBP]) and
      (Diastolic <= GMVVitalHiRange[vtBP])
      )
      or
      (
      (Systolic >= GMVVitalLoRange[vtBP]) and
      (Systolic <= GMVVitalHiRange[vtBP]) and
      (Diastolic >= GMVVitalLoRange[vtBP]) and
      (Diastolic <= GMVVitalHiRange[vtBP]) and
      (Middle >= GMVVitalLoRange[vtBP]) and
      (Middle <= GMVVitalHiRange[vtBP])
      ) then
      begin
        Result := True;
      end
    else
//      MessageDlg('That is not a valid Blood Pressure' + #13 +
//        'Enter as Systolic/Diastolic with values from 0 to 300',
//        mtError, [mbok], 0);
        MessageDlgEnteredInvalidValue(cbxInput.Text,sMsgInvalidBP,'BP');//AAN 07/03/2002
  except
    on E: EConvertError do
//      MessageDlg( sMsgInvalidBP, mtError, [mbok], 0);
        MessageDlgEnteredInvalidValue(cbxInput.Text,sMsgInvalidBP+#13+E.Message,'BP');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidTemperature: Boolean;
begin
  Result := False;
  try
    tmpDouble := StrToFloat(cbxInput.Text);
    if ckbMetric.Checked then
      tmpDouble := ConvertCToF(tmpDouble);
    if (tmpDouble >= GMVVitalLoRange[vtTemp]) and
      (tmpDouble <= GMVVitalHiRange[vtTemp]) then
      begin {Process valid Temperature here}
        FValueDbl := tmpDouble;
        Result := True;
      end
    else
      OutOfRange('Temperature');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Temperature');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidPulse: Boolean;
begin
  Result := False;
  try
    tmpInt := StrToInt(cbxInput.Text);
    if (tmpInt >= GMVVitalLoRange[vtPulse]) and
      (tmpInt <= GMVVitalHiRange[vtPulse]) then
      begin {Process valid Pulse Here}
        FValueInt := tmpInt;
        Result := True;
      end
    else
      OutOfRange(sgnPulse);
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,sgnPulse);//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidRespiration: Boolean;
begin
  Result := False;
  try
    tmpInt := StrToInt(cbxInput.Text);
    if (tmpInt >= GMVVitalLoRange[vtResp]) and
      (tmpInt <= GMVVitalHiRange[vtResp]) then
      begin {Process valid respiration here}
        FValueInt := tmpInt;
        Result := True;
      end
    else
      OutOfRange('Respiration');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Respiration');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidWeight: Boolean;
begin
  Result := False;
  try
    tmpDouble := StrToFloat(cbxInput.Text);
    if ckbMetric.Checked then
      tmpDouble := ConvertKgsToLbs(tmpDouble);
    if (tmpDouble >= GMVVitalLoRange[vtWeight]) and
      (tmpDouble <= GMVVitalHiRange[vtWeight]) then
      begin {Process valid weight Here}
        FValueDbl := tmpDouble;
        Result := True;
      end
    else
      OutOfRange('Weight');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Weight');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidHeight: Boolean;
begin
  Result := False;
  try
    tmpDouble := StrToFloat(cbxInput.Text);
    if ckbMetric.Checked then
      tmpDouble := ConvertCmToIn(tmpDouble);
    if (tmpDouble >= GMVVitalLoRange[vtHeight]) and
      (tmpDouble <= GMVVitalHiRange[vtHeight]) then
      begin  {Process valid height here}
        FValueDbl := tmpDouble;
        Result := True;
      end
    else
      OutOfRange('Height');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Height');//AAN 07/03/2002
  else
    raise;
  end;
end;

function TfraGMV_InputOne2.ValidGirth: Boolean;
begin
  Result := False;
  try
    tmpDouble := StrToFloat(cbxInput.Text);
    if ckbMetric.Checked then
      tmpDouble := ConvertCmToIn(tmpDouble);
    if (tmpDouble >= GMVVitalLoRange[vtCircum]) and
      (tmpDouble <= GMVVitalHiRange[vtCircum]) then
      begin
        {Process valid girth here}
        FValueDbl := tmpDouble;
        Result := True;
      end
    else
      OutOfRange('Circumference/Girth');
  except
    on E: EConvertError do
      MessageDlgEnteredInvalidValue(cbxInput.Text,E.Message,'Girth');//AAN 07/03/2002
  else
    raise;
  end;
end;


procedure TfraGMV_InputOne2.cbxInputKeyPress(Sender: TObject;
  var Key: Char);
var
  s:String;
  iLen: Integer;// = 2;
begin
{ }
  iLen := 2;
  if (fTemplateVitalType = vtTemp) or
     (fTemplateVitalType = vtCVP) then iLen := 1;
  if (fTemplateVitalType = vtHeight) or
    (fTemplateVitalType = vtCircum) or
    (fTemplateVitalType = vtWeight) then iLen := 2;

  if (fTemplateVitalType = vtCircum) or
    (fTemplateVitalType = vtHeight) or
    (fTemplateVitalType = vtCVP) or
    (fTemplateVitalType = vtTemp) or
    (fTemplateVitalType = vtWeight) then
    begin
      if (pos(char(Key),'0123456789.') <> 0) and (cbxInput.SelStart>=pos('.',cbxInput.Text)) then
        begin
          s := Piece(cbxInput.Text,'.',2);
          if Length(s)> iLen-1 then
            begin
              s := copy(s,1,iLen-1);
              cbxInput.Text := Piece(cbxInput.Text,'.',1)+'.'+s+Key;
              cbxInput.SelStart := pos('.',cbxInput.Text)+iLen-1;
              cbxInput.SelLength := 1;
              Key := #0;
            end;
        end;

    end;
end;

function TfraGMV_InputOne2.getStatusString;
begin
  result := lblVital.Caption;
end;


procedure TfraGMV_InputOne2.cbxInputEnter(Sender: TObject);
begin
  setStatusString(getStatusString);
end;

procedure TfraGMV_InputOne2.setStatusString(aString:String);
begin
  if not assigned(frmGMV_InputLite) then exit;
  try
    frmGMV_InputLite.StatusBar.SimpleText := '  '+aString;
  except
  end;
end;

procedure TfraGMV_InputOne2.cbxUnitsEnter(Sender: TObject);
begin
  setStatusString(cbxUnits.Text);
end;

procedure TfraGMV_InputOne2.cbxUnitsExit(Sender: TObject);
begin
  setStatusString('');
end;

end.

