unit fGMV_ReportOptions;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 1/04/05 6:11p $
*       Developer:    andrey.andriyevskiy@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Report selection and device setup options.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsPatient/fGMV_ReportOptions.pas $
*
* $History: fGMV_ReportOptions.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 4:59p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsPatient
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:23p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSPATIENT
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
  StdCtrls
  ,  ComCtrls,
  ExtCtrls,
  uGMV_Common,
  ActnList, Buttons
  ;

type
  TfrmGMV_ReportOptions = class(TForm)
    pnlBottom: TPanel;
    OKButton: TButton;
    Button2: TButton;
    pnlLeft: TPanel;
    GroupBox2: TGroupBox;
    ReportCombo: TComboBox;
    Bevel1: TBevel;
    WardLabel: TLabel;
    WardCombo: TORComboBox;
    RoomLabel: TLabel;
    RoomCombo: TORComboBox;
    Label1: TLabel;
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
    tmDevice: TTimer;
    Panel1: TPanel;
    edTarget: TEdit;
    lvDevices: TListView;
    Panel2: TPanel;
    Bevel4: TBevel;
    Label5: TLabel;
    Bevel3: TBevel;
    SpeedButton1: TSpeedButton;
    acSearch: TAction;
    Label3: TLabel;
    lblDevice: TLabel;
    Label6: TLabel;
    dtpPrintDate: TDateTimePicker;
    dtpPrintTime: TDateTimePicker;
    Label2: TLabel;
    lblStart: TLabel;
    lblEnd: TLabel;
    dtpFromDate: TDateTimePicker;
    dtpToDate: TDateTimePicker;
    dtpFromTime: TDateTimePicker;
    dtpToTime: TDateTimePicker;
    Bevel2: TBevel;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure acReportChanged(Sender: TObject);
    procedure acScopeChangedExecute(Sender: TObject);
    procedure acWardChangedExecute(Sender: TObject);
    procedure acPrintReportExecute(Sender: TObject);
    procedure acStartDateChanged(Sender: TObject);
    procedure acStopDateChangedExecute(Sender: TObject);
    procedure acUPdateDTPColorsExecute(Sender: TObject);
    procedure acStartTimeChangedExecute(Sender: TObject);
    procedure acEndTimeChangedExecute(Sender: TObject);
    procedure acPrintDateChangedExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmDeviceTimer(Sender: TObject);
    procedure edTargetChange(Sender: TObject);
    procedure edTargetKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acSearchExecute(Sender: TObject);
    procedure lvDevicesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    CurrentTime,
    MinTime,MaxTime,
    MinDate,MaxDate: TDateTime;
    procedure SetWardActive(bState: Boolean);
    procedure SetRoomActive(bState: Boolean);
    procedure PrintER;
    procedure ReportPr(const routine, value, Report: string);
    function getDeviceName:String;
    function getDeviceIEN:String;
  public
    { Public declarations }
    FPTien: string;
    PatientInfo: string;
    Margin: string;
    SearchDirection: Integer;
    property DeviceIEN:String read getDeviceIEN;
    property DeviceName:String read getDeviceName;
  end;

var
  frmGMV_ReportOptions: TfrmGMV_ReportOptions;

procedure PrintReport2(ReportNumber: integer = 0; PatientIEN: string = ''; PName: string = '');

implementation

uses uGMV_User, uGMV_Engine
  ;

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

procedure TfrmGMV_ReportOptions.FormCreate(Sender: TObject);
var
  sDateTime:String;
  ServerTime: Double;
  SL: TStringList;
begin
  SearchDirection := 1;
  Margin := '132';
  sDateTime := getCurrentDateTime;
  ServerTime := StrToFloat(sDateTime);

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

  SL := getWardLocations;
  if SL.Count > 0 then
    WardCombo.Items.AddStrings(SL);
  SL.Free;
  acWardChangedExecute(Sender); //AAN 06/10/02
end;

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
  case ReportCombo.ItemIndex of
    0..6:
      begin
        SetWardActive(True); //AAN 06/10/02
        if ReportCombo.ItemIndex > 4 then  // vhaishandria 060123
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
//      Margin := '132'; vhaishandria 060123
      Margin := '80';
      if ReportCombo.ItemIndex = 7 then
        SetPeriodActive(False)
      else
        SetPeriodActive(True);

      if FPTien = '' then
        begin
          MessageDlg('Report needs patient to be selected.' + #13 +
            'Select patient prior to print report', mtInformation,
            [mbOk], 0);
          ReportCombo.ItemIndex := 6;
          rbAllPatients.Enabled := True;
        end
      else
        begin
          SetWardActive(False);
//          Margin := '132'; vhaishandria 060123
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
var
  RetList : TStrings;
begin
  RoomCombo.Clear;
  if WardCombo.DisplayText[WardCombo.itemindex] <> '' then
    begin
      RetList := getRoomBedByWard(WardCombo.DisplayText[WardCombo.itemindex]);
      if RetList.Count > 0 then
        begin                                                   //AAN 06/10/02
          SetRoomActive(True);                                  //AAN 06/10/02
          RoomCombo.Items.AddStrings(RetList);
        end                                                     //AAN 06/10/02
      else                                                      //AAN 06/10/02
        SetRoomActive(False);                                   //AAN 06/10/02
      acPrintReport.Enabled := True;
      RetList.Free;
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
  if ((FptIen = '') and (Wardcombo.text = '')) then
    begin
      Messagedlg(
        'No Patient selected, please select a patient to continue',
        mtinformation,
        [mbOK],
        0)
    end
  else if ReportCombo.text = '' then
    Messagedlg(
      'No Report selected, please select a Report to continue',
      mtInformation,
      [mbOK],
      0)
  else if lvDevices.ItemIndex = -1 then
    Messagedlg('No Device selected, please select a Device to continue',mtInformation,[mbOK],0)
  else
    begin
      FromDate := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpFromDate.Date) + (dtpFromTime.Time - trunc(dtpFromTime.Date))));
      ToDate := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpToDate.Date) + (dtpToTime.Time - trunc(dtpToTime.Date))));
      PrintDT := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpPrintDate.Date) + (dtpPrintTime.Time - trunc(dtpPrintTime.Date))));

      Wardstr := '';
      if rbAllPatients.Checked and (WardCombo.ItemIndex > -1) then // AAN 07/01/2002
        WardIEN := Piece(WardCombo.Items.Strings[wardcombo.itemindex], '^', 1)
      else
        WardIEN := '';

      WardList := '';                                           // AAN 07/01/2002
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
        DeviceName + '^' + DeviceIEN + '^' + PrintDT + '^' + WardIEN + '^^' + WardList;
      ReportPr(Froutine, Fvalue, GraphName);

      ModalResult := mrOk;
    end;
end;

procedure TfrmGMV_ReportOPtions.ReportPr(const routine, value, Report: string);
begin
  Messagedlg(getProcedureResult(routine,value), mtInformation, [mbOK], 0);
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

procedure TfrmGMV_ReportOptions.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  try
    GMVUser.Setting[usLastVistAPrinter] := DeviceIEN;
  except
  end;
  CanClose := True;
end;

function TfrmGMV_ReportOptions.getDeviceName:String;
begin
  Result := lvDevices.Items[lvDevices.ItemIndex].SubItems[0];
end;

function TfrmGMV_ReportOptions.getDeviceIEN:String;
begin
  Result := lvDevices.Items[lvDevices.ItemIndex].Caption;
end;

procedure TfrmGMV_ReportOptions.tmDeviceTimer(Sender: TObject);
var
  s: String;
    i: Integer;
  sl: TStringList;
  LI: TListItem;
begin
  tmDevice.Enabled := False;
  SL := TStringList.Create;
  try
    s := getDeviceList(uppercase(edTarget.Text),Margin,SearchDirection);
    SL.Text := S;
    lvDevices.Items.Clear;
    if sl.Count <> 0 then
      for i := 0 to SL.Count do
        begin
          if piece(SL[i],'^',1) = '' then continue;
          LI := lvDevices.Items.Add;
          LI.Caption := piece(SL[i],'^',1);
          LI.SubItems.Add(piece(SL[i],'^',2));
          LI.SubItems.Add(piece(SL[i],'^',4));
          LI.SubItems.Add(piece(SL[i],'^',5));
          LI.SubItems.Add(piece(SL[i],'^',6));
        end;
  except
  end;
  SL.Free;
end;

procedure TfrmGMV_ReportOptions.edTargetChange(Sender: TObject);
begin
  tmDevice.Enabled := True;
end;

procedure TfrmGMV_ReportOptions.edTargetKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
{
  if ssShift in Shift then
    SearchDirection := -1
  else
    SearchDirection := 1;
}
  if Key = VK_RETURN then
    tmDeviceTimer(nil);
end;

procedure TfrmGMV_ReportOptions.acSearchExecute(Sender: TObject);
begin
  tmDevice.Enabled := True;
end;

procedure TfrmGMV_ReportOptions.lvDevicesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  try
    lblDevice.Caption := lvDevices.ItemFocused.SubItems[0]+'  '+
      lvDevices.ItemFocused.SubItems[1]+' ' +
      lvDevices.ItemFocused.SubItems[2]+'x' + lvDevices.ItemFocused.SubItems[3];
  except
    lblDevice.Caption := 'Not selected';
  end;
end;

procedure TfrmGMV_ReportOptions.SpeedButton2Click(Sender: TObject);
//var
//  i: Integer;
begin
  if lvDevices.Items.Count <= 0 then Exit;
  try
//    i := Length(lvDevices.Items[lvDevices.Items.Count-1].SubItems.Text);
    edTarget.Text :=
      Copy(lvDevices.Items[lvDevices.Items.Count-1].SubItems[0],1,1{i-1});
    tmDeviceTimer(nil);  
  except
  end;
end;

end.

