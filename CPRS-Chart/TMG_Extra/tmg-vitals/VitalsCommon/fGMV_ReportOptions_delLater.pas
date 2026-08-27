unit fGMV_ReportOptions;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 5/22/03 10:12a $
*       Developer:    andrey.andriyevskiy@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Report selection and device setup options.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon/fGMV_ReportOptions.pas $
*
* $History: fGMV_ReportOptions.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:33p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsCommon
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:17p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSCOMMON
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 1/26/04    Time: 1:08p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, Delphi7)/V5031-D7/VitalsUser
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 10/29/03   Time: 4:15p
 * Created in $/Vitals503/Vitals User
 * Version 5.0.3
 * 
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 5/22/03    Time: 10:14a
 * Updated in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Preparation To CCOW
 * MessageDLG changet to Message DLGS
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/21/03    Time: 1:18p
 * Created in $/Vitals GUI Version 5.0/VitalsUserNoCCOW
 * Pre CCOW Version of Vitals User
 * 
 * *****************  Version 12  *****************
 * User: Vhaishandria Date: 11/04/02   Time: 9:15a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Version 5.0.0.0
 * 
 * *****************  Version 11  *****************
 * User: Vhaishandria Date: 8/02/02    Time: 4:14p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * Weekly Backup
 * 
 * *****************  Version 10  *****************
 * User: Vhaishandria Date: 7/18/02    Time: 5:57p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 9  *****************
 * User: Vhaishandria Date: 7/12/02    Time: 5:00p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * GUI Version T28
 * 
 * *****************  Version 8  *****************
 * User: Vhaishandria Date: 7/03/02    Time: 4:59p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 7  *****************
 * User: Vhaishandria Date: 7/02/02    Time: 11:56a
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 6  *****************
 * User: Vhaishandria Date: 7/01/02    Time: 5:14p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 5  *****************
 * User: Vhaishandria Date: 6/28/02    Time: 5:19p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 4  *****************
 * User: Vhaishandria Date: 6/17/02    Time: 4:51p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 3  *****************
 * User: Vhaishandria Date: 6/17/02    Time: 4:26p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 * 
 * *****************  Version 2  *****************
 * User: Vhaishpetitd Date: 6/17/02    Time: 3:47p
 * Updated in $/Vitals GUI Version 5.0/Vitals User
 *
*
================================================================================
}
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
  ORCtrls,
  StdCtrls,
  mGMV_Lookup,
  ComCtrls,
  ExtCtrls,
  TRpcb,
  uGMV_Common,
  ActnList;

type
  TfrmGMV_ReportOptions = class(TForm)
    pnlBottom: TPanel;
    OKButton: TButton;
    Button2: TButton;
    pnlLeft: TPanel;
    GroupBox2: TGroupBox;
    ReportCombo: TComboBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    WardLabel: TLabel;
    WardCombo: TORComboBox;
    RoomLabel: TLabel;
    RoomCombo: TORComboBox;
    lblStart: TLabel;
    dtpFromDate: TDateTimePicker;
    dtpFromTime: TDateTimePicker;
    dtpToTime: TDateTimePicker;
    dtpToDate: TDateTimePicker;
    lblEnd: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    fraDevLookup: TfraGMV_Lookup;
    Bevel3: TBevel;
    Label5: TLabel;
    Bevel4: TBevel;
    Label6: TLabel;
    dtpPrintDate: TDateTimePicker;
    dtpPrintTime: TDateTimePicker;
    ActionList1: TActionList;
    acReportCh: TAction;
    acScopeChanged: TAction;
    rbPatient: TRadioButton;
    rbAllPatients: TRadioButton;
    acWardChanged: TAction;
    acPrintReport: TAction;
    acStartDate: TAction;
    acStopDateChanged: TAction;
    acUPdateDTPColors: TAction;
    acStartTimeChanged: TAction;
    acEndTimeChanged: TAction;
    acPrinTimeChanged: TAction;
    acPrintDateChanged: TAction;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acReportChanged(Sender: TObject);
    procedure acScopeChangedExecute(Sender: TObject);
    procedure acWardChangedExecute(Sender: TObject);
    procedure acPrintReportExecute(Sender: TObject);
    procedure acStartDateChanged(Sender: TObject);
    procedure acStopDateChangedExecute(Sender: TObject);
    procedure acUPdateDTPColorsExecute(Sender: TObject);
    procedure fraDevLookuptmrLookupTimer(Sender: TObject);
    procedure acStartTimeChangedExecute(Sender: TObject);
    procedure acEndTimeChangedExecute(Sender: TObject);
    procedure acPrintDateChangedExecute(Sender: TObject);
  private
    { Private declarations }
    CurrentTime,
    MinTime,MaxTime,
    MinDate,MaxDate: TDateTime;
    DevIEN: string;
//    procedure DevComboNeedData(Sender: TObject; const StartFrom: string; Direction, InsertAt: integer);
    procedure SetWardActive(bState: Boolean);
    procedure SetRoomActive(bState: Boolean);
    procedure PrintER;
    procedure ReportPr(const routine, value, Report: string);
  public
    { Public declarations }
    FPTien: string;
    PatientInfo: string;
    Margin: string;
  end;

var
  frmGMV_ReportOptions: TfrmGMV_ReportOptions;

procedure PrintReport2(ReportNumber: integer = 0; PatientIEN: string = ''; PName: string = '');

implementation

{$R *.DFM}

procedure PrintReport2(ReportNumber: integer = 0; PatientIEN: string = ''; PName: string = '');
begin
  with TfrmGMV_ReportOptions.Create(Application) do
    try
      if (ReportNumber > -1) and (ReportNumber < ReportCombo.Items.Count) then
        ReportCombo.ItemIndex := ReportNumber;

      FPTien := PatientIEN;
      PatientInfo := PName;
      rbPatient.Caption := 'Patien&t: '+Piece(PatientInfo, ' ');
      if rbPatient.Caption = 'Patient: No' then
        rbPatient.Caption := 'No Panient Selected';

      if FPTien = '' then
        begin
          rbPatient.Checked := False;
          rbPatient.Enabled := False;
          rbAllPatients.Checked := True;
          WardCombo.Enabled := True;
          acScopeChangedExecute(nil);
        end;
      acScopeChangedExecute(nil);
      acReportChanged(nil);
      repeat
      until ShowModal = mrCancel;
    finally
      Free;
    end;
end;

procedure TfrmGMV_ReportOptions.SetWardActive(bState: Boolean);
begin
  WardCombo.Enabled := bState;
  WardLabel.Enabled := bState;
end;

procedure TfrmGMV_ReportOptions.SetRoomActive(bState: Boolean);
begin
  RoomCombo.Enabled := bState;
  RoomLabel.Enabled := bState;
end;

procedure TfrmGMV_ReportOptions.FormDestroy(Sender: TObject);
begin
  if fraDevLookUP.IEN <> '' then
    GMVUser.Setting[usLastVistAPrinter] := fraDevLookUp.IEN;
end;

procedure TfrmGMV_ReportOptions.FormCreate(Sender: TObject);
var
  ServerTime: Double;
begin
  Margin := '132';
  with GMVBroker do
    begin
      Results.Clear;
      RemoteProcedure := 'GMV GET CURRENT TIME';
      Call;
      ServerTime := StrToFloat(Results[0]);
    end;
  //FMTimeToWindowsTime(Piece(ServerTime, '.', 2));
  //FMDateToWindowsDate(Piece(ServerTime, '.', 1));
  // ToDatePick.Date := FMDateToWindowsDate(Piece(ServerTime, '.', 1));
  //FromDatePick.Date := FMDateToWindowsDate(Piece(ServerTime, '.', 1));
  dtpPrintTime.DateTime :=    FMDateTimeToWindowsDateTime(ServerTime);
  dtpPrintDate.Date :=    FMDateTimeToWindowsDateTime(ServerTime);
  dtpFromDate.DateTime := FMDateTimeToWindowsDateTime(ServerTime);
  dtpToDate.DateTime :=   FMDateTimeToWindowsDateTime(ServerTime);

  CurrentTime := dtpPrintTime.DateTime;

  MinDate := dtpFromDate.Date;
  MaxDate := dtpToDate.Date;

  dtpFromDate.MaxDate := MaxDate;
  dtpToDate.MinDate := MinDate;
  dtpToDate.MaxDate := MaxDate;
  acUpdateDtpColorsExecute(Sender);

  dtpFromTime.Time := StrToTime('00:01');
  dtpToTime.Time := StrToTime('23:59');
  MinTime := dtpFromTime.Time;
  MaxTime := dtpToTime.Time;

  dtpPrintDate.MinDate := trunc(FMDateTimeToWindowsDateTime(ServerTime));
  with GMVBroker do
    begin
      RemoteProcedure := 'GMV WARD LOCATION';
      Results.Clear;
      Call;
      if Results.Count > 0 then
        WardCombo.Items.AddStrings(Results);
      acWardChangedExecute(Sender); //AAN 06/10/02
    end;
  DevIEN := GMVUser.Setting[usLastVistAPrinter];
  fraDevLookup.InitFrame(GMVBroker, '3.5', DevIEN);
  fraDevLookup.ReportWidth := Margin;
end;
{
procedure TfrmGMV_ReportOptions.DevComboNeedData(Sender: TObject; const StartFrom: string; Direction, InsertAt: integer);
begin
  CallServer(GMVBroker, 'GMV GET DEVICES', [StartFrom, IntToStr(Direction), Margin], nil, RetList);
end;
}
procedure TfrmGMV_ReportOptions.acReportChanged(Sender: TObject);

procedure SetPeriodActive(aState:Boolean);
begin
  lblStart.Enabled := aState;
  lblEnd.Enabled := aState;
  dtpFromDate.Enabled := aState;
  dtpFromTime.Enabled := aState;
  dtpToDate.Enabled := aState;
  dtpToTime.Enabled := aState;

  acUpdateDtpColorsExecute(Sender);
end;

begin
  Margin := '132';
  if ReportCombo.ItemIndex <=5 then
    fraDevLookup.ReportWidth := '80'
  else
    fraDevLookup.ReportWidth := '80-132';
  case ReportCombo.ItemIndex of
    0..6:
      begin
        SetWardActive(True); //AAN 06/10/02
        Margin := '80';
        if ReportCombo.ItemIndex <> 6 then
          begin
            rbPatient.Enabled := True;
            rbAllPatients.Enabled := True;
            SetWardActive(True);
            SetPeriodActive(True);
          end
        else
          begin
            rbPatient.Enabled := False;
            rbAllPatients.Enabled := True;
            rbAllPatients.Checked := True;
            SetPeriodActive(False);
          end;
        if FPTien = '' then
          rbPatient.Enabled := False;
      end;
  else
    begin
      if ReportCombo.ItemIndex = 7 then
        SetPeriodActive(False)
      else
        SetPeriodActive(True);
      if FPTien = '' then
        begin
          MessageDlgS('Report needs patient to be selected.' + #13 +
            'Select patient prior to print report', mtInformation,
            [mbOk], 0);
          ReportCombo.ItemIndex := 6;
          rbAllPatients.Enabled := True;
        end
      else
        begin
          SetWardActive(False);
          Margin := '132';
          rbAllPatients.Enabled := False;
          rbAllPatients.Checked := False;
          rbPatient.Checked := True;
          rbPatient.Enabled := True;
        end;
    end;
  end;
  WardCombo.Text := '';
  acWardChangedExecute(Sender);
  acScopeChangedExecute(Sender);
  fraDevLookup.ReportWidth := Margin;
end;

procedure TfrmGMV_ReportOptions.acScopeChangedExecute(Sender: TObject);
begin
  if rbPatient.Checked then
    begin
      WardCombo.Enabled := False;
      SetWardActive(False);
      SetRoomActive(False);
      acPrintReport.Enabled := True;
    end
  else
    begin
      WardCombo.Enabled := True;
      SetWardActive(True);
      acPrintReport.Enabled := (WardCombo.Text <> '')
    end;
end;

procedure TfrmGMV_ReportOptions.acWardChangedExecute(Sender: TObject);
begin
  RoomCombo.Clear;
  if WardCombo.DisplayText[WardCombo.itemindex] <> '' then
    begin
      CallServer(GMVBroker, 'GMV ROOM/BED', [WardCombo.DisplayText[WardCombo.itemindex]], nil, RetList);
      if RetList.Count > 0 then
        begin                                                   //AAN 06/10/02
          SetRoomActive(True);                                  //AAN 06/10/02
          RoomCombo.Items.AddStrings(RetList);
        end                                                     //AAN 06/10/02
      else                                                      //AAN 06/10/02
        SetRoomActive(False);                                   //AAN 06/10/02
      acPrintReport.Enabled := True;
    end
  else                                                          //AAN 06/10/02
    begin
      SetWardActive(True);                                      //AAN 06/10/02
      SetRoomActive(False);                                     //AAN 06/10/02
      acPrintReport.Enabled := False;
    end;
end;

procedure TfrmGMV_ReportOptions.acPrintReportExecute(Sender: TObject);
begin
  PrintER;
end;

procedure TfrmGMV_ReportOPtions.PrintER;
var
  A: integer;
  PrintDT,
//    FDevIEN,
    WardStr,
    WardIEN,
    Fgraph,
    GraphName,
    Froutine,
    FValue,
    FromDate,
    Wardlist,
    ToDate: string;
begin
  DevIEN := fraDevLookUp.IEN;
{
  CallServer(GMVBroker, 'GMV CHECK DEVICE', [DevIEN, Margin], nil, RetList);
  if RetList[0] <> '1' then
    begin
      MessagedlgS(RetList[0], mtinformation, [mbOK], 0);
      Exit;
    end;
}
  if ((FptIen = '') and (Wardcombo.text = '')) then
    begin
      MessagedlgS(
        'No Patient selected, please select a patient to continue',
        mtinformation,
        [mbOK],
        0)
    end
  else if ReportCombo.text = '' then
    MessagedlgS(
      'No Report selected, please select a Report to continue',
      mtInformation,
      [mbOK],
      0)
  else if fraDevLookup.IEN = '' then
    MessagedlgS(
      'No Device selected, please select a Device to continue',
      mtInformation,
      [mbOK],
      0)
  // It is not the best way to check the device...
  else if fraDevLookup.edtValue.Text = '' then
    MessagedlgS(
      'No Device selected, please select a Device to continue',
      mtInformation,
      [mbOK],
      0)
  else
    begin
      FromDate := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpFromDate.Date) + (dtpFromTime.Time - trunc(dtpFromTime.Date))));
      ToDate := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpToDate.Date) + (dtpToTime.Time - trunc(dtpToTime.Date))));
      PrintDT := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpPrintDate.Date) + (dtpPrintTime.Time - trunc(dtpPrintTime.Date))));

      Wardstr := '';
//      if WardCombo.ItemIndex > -1 then
      if rbAllPatients.Checked and (WardCombo.ItemIndex > -1) then // AAN 07/01/2002
        WardIEN := Piece(WardCombo.Items.Strings[wardcombo.itemindex], '^', 1)
      else
        WardIEN := '';

      WardList := '';                                           // AAN 07/01/2002
//      for a := 0 to Roomcombo.Items.Count - 1 do              // AAN 07/01/2002
      if  rbAllPatients.Checked  then                           // AAN 07/01/2002
        begin                                                   // AAN 07/01/2002
          for  a := 0 to Roomcombo.Items.Count - 1 do
            if RoomCombo.Checked[a] = True then
              WardList := WardList + Roomcombo.DisplayText[a] + ',';
          WardList := Copy(WardList, 1, Length(WardList) - 1);
        end;                                                    // AAN 07/01/2002

      if WardIEN = '' then
        FValue := FptIEN;

      FGraph := '';

      case ReportCombo.ItemIndex of
        0..4:
          begin
            FGraph := IntToStr(ReportCombo.ItemIndex + 1);
            GraphName := ReportCombo.Text;
            Froutine := 'GMV PT GRAPH';
          end;
        5: Froutine := 'GMV CUMULATIVE REPORT';
        6: FRoutine := 'GMV LATEST VITALS BY LOCATION';
        7: FRoutine := 'GMV LATEST VITALS FOR PATIENT';
        8: Froutine := 'GMV ENTERED IN ERROR-PATIENT';
      end;

      FValue := FValue + '^' + FromDate + '^' + ToDate + '^' + Fgraph + '^' +
        fraDevLookup.edtValue.Text + '^' + DevIen + '^' + PrintDT + '^' + WardIEN + '^^' + WardList;
      ReportPr(Froutine, Fvalue, GraphName);

      ModalResult := mrOk;
    end;
end;

procedure TfrmGMV_ReportOPtions.ReportPr(const routine, value, Report: string);
begin
  CallServer(GMVBroker, routine, [value], nil, nil);
  MessagedlgS(GMVBroker.Results[0], mtInformation, [mbOK], 0);
end;

procedure TfrmGMV_ReportOptions.fraDevLookuptmrLookupTimer(
  Sender: TObject);
begin
  fraDevLookup.tmrLookupTimer(Sender);
end;

procedure TfrmGMV_ReportOptions.acStartDateChanged(Sender: TObject);
begin
  MinDate := dtpFromDate.Date;
  dtpToDate.MinDate := MinDate;
  acUpdateDtpColorsExecute(Sender);
end;

procedure TfrmGMV_ReportOptions.acStopDateChangedExecute(Sender: TObject);
begin
  MaxDate := dtpToDate.Date;
  dtpFromDate.MaxDate := MaxDate;
  acUpdateDtpColorsExecute(Sender);
end;

procedure TfrmGMV_ReportOptions.acUPdateDTPColorsExecute(Sender: TObject);
begin
  dtpToDate.Enabled := (trunc(dtpToDate.MinDate) <> trunc(dtpToDate.MaxDate));
  dtpFromDate.Enabled := (trunc(dtpFromDate.MinDate) <> trunc(dtpFromDate.MaxDate));
  lblStart.Enabled := dtpFromDate.Enabled;
  lblEnd.Enabled := dtpToDate.Enabled;
end;

procedure TfrmGMV_ReportOptions.acStartTimeChangedExecute(Sender: TObject);
begin
  if dtpFromTime.Time > dtpToTime.Time Then
     dtpFromTime.Time := dtpToTime.Time;
end;

procedure TfrmGMV_ReportOptions.acEndTimeChangedExecute(Sender: TObject);
begin
  if dtpToTime.Time < dtpFromTime.Time Then
     dtpToTime.Time := dtpFromTime.Time;
end;

procedure TfrmGMV_ReportOptions.acPrintDateChangedExecute(Sender: TObject);
var
  DT: TDateTime;
begin
  DT := trunc(dtpPrintDate.Date)+ frac(dtpPrintTime.Time);
  if DT < CurrentTime then
    dtpPrintTime.Time := frac(CurrentTime);
end;

end.

