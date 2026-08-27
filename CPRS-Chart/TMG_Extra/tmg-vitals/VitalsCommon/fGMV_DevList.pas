unit fGMV_DevList;

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
  ExtCtrls,
  StdCtrls,
  TRpcb,
  ORCtrls,
  uGMV_Common,
  ComCtrls, mGMV_Lookup;

type
  TfrmGMV_DevList = class(TForm)
    pnlBottom: TPanel;
    pnlLeft: TPanel;
    OKButton: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    ReportCombo: TComboBox;
    GroupBox3: TGroupBox;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    dtpToDate: TDateTimePicker;
    dtpFromDate: TDateTimePicker;
    pnlRight: TPanel;
    GroupBox5: TGroupBox;
    WardLabel: TLabel;
    RoomLabel: TLabel;
    RoomCombo: TORComboBox;
    WardCombo: TORComboBox;
    GroupBox4: TGroupBox;
    dtpPrintDate: TDateTimePicker;
    dtpFromTime: TDateTimePicker;
    dtpToTime: TDateTimePicker;
    dtpPrintTime: TDateTimePicker;
    fraDevLookup: TfraGMV_Lookup;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure WardComboChange(Sender: TObject);
    procedure ReportComboChange(Sender: TObject);
    procedure DevComboNeedData(Sender: TObject; const StartFrom: string; Direction, InsertAt: Integer);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    DevIEN : String;
    procedure ReportPr(const routine, value, Report: string);
    procedure PrintER;
    procedure SetWardActive(bState: Boolean);
    procedure SetRoomActive(bState: Boolean);
  public
    { Public declarations }
    FPTien: string;
    Margin : string;
  end;

procedure PrintReport(ReportNumber: Integer = 0; PatientIEN: string = '');

implementation

{$R *.DFM}

procedure PrintReport(ReportNumber: Integer = 0; PatientIEN: string = '');
begin
  with TfrmGMV_DevList.Create(Application) do
  try
    if (ReportNumber > -1) and (ReportNumber < ReportCombo.Items.Count) then
      ReportCombo.ItemIndex := ReportNumber;
    ReportComboChange(Application);
    FPTien := PatientIEN;
//AAN 06/11/02    ShowModal;
    repeat    //AAN 06/11/02
    until ShowModal = mrCancel;//AAN 06/11/02
  finally
    Free;
  end;
end;

procedure TfrmGMV_DevList.FormCreate(Sender: TObject);
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
  dtpPrintTime.Time := FMDateTimeToWindowsDateTime(ServerTime); //FMTimeToWindowsTime(Piece(ServerTime, '.', 2));
  dtpPrintDate.Date := FMDateTimeToWindowsDateTime(ServerTime); //FMDateToWindowsDate(Piece(ServerTime, '.', 1));
  dtpFromDate.DateTime := FMDateTimeToWindowsDateTime(ServerTime); //FromDatePick.Date := FMDateToWindowsDate(Piece(ServerTime, '.', 1));
  dtpToDate.DateTime := FMDateTimeToWindowsDateTime(ServerTime); // ToDatePick.Date := FMDateToWindowsDate(Piece(ServerTime, '.', 1));
  dtpFromTime.Time := StrToTime('00:01');
  dtpToTime.Time := StrToTime('23:59');
  with GMVBroker do
    begin
      RemoteProcedure := 'GMV WARD LOCATION';
      Results.Clear;
      Call;
      if Results.Count > 0 then
        WardCombo.Items.AddStrings(Results);
      WardComboChange(Sender); //AAN 06/10/02
    end;
    DevIEN := GMVUser.Setting[usLastVistAPrinter];
    fraDevLookup.InitFrame(GMVBroker, '3.5', DevIEN);
end;

procedure TfrmGMV_DevList.OKButtonClick(Sender: TObject);
begin
  PrintER;
end;

procedure TfrmGMV_DevList.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmGMV_DevList.PrintER;
var
  A: integer;
  PrintDT,
//    FDevIEN, -- never used ------------------------------------ AAN 07/25/2002
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
  CallServer(GMVBroker, 'GMV CHECK DEVICE', [DevIEN,Margin], nil, RetList);
  If RetList[0] <> '1' Then
  Begin
      MessagedlgS(
      RetList[0],
      mtinformation,
      [mbOK],
      0);
      Exit;
  End;
  if ((FptIen = '') and (Wardcombo.text = ''))  then
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
  else
    begin
      FromDate := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpFromDate.Date) + (dtpFromTime.Time - trunc(dtpFromTime.Date))));
      ToDate := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpToDate.Date) + (dtpToTime.Time - trunc(dtpToTime.Date))));
      PrintDT := FloatToStr(WindowsDateTimeToFMDateTime(trunc(dtpPrintDate.Date) + (dtpPrintTime.Time - trunc(dtpPrintTime.Date))));
      Wardstr := '';
      if WardCombo.ItemIndex > -1 then
        WardIEN := Piece(WardCombo.Items.Strings[wardcombo.itemindex], '^', 1)
      else
        WardIEN := '';
      if (DEVIen <> '') and (ReportCombo.ItemIndex < 5) then
        begin
          Fgraph := inttostr(ReportCombo.itemindex + 1);
          GraphName := ReportCombo.Text; //   'Weight Chart';
          Froutine := 'GMV PT GRAPH';
          for a := 0 to Roomcombo.Items.Count - 1 do
            begin
              if RoomCombo.Checked[a] = True then
                begin
                  WardList := WardList + Roomcombo.DisplayText[a] + ',';
                end;
            end;
          If WardIEN = '' then
          Begin
             FValue := FptIEN;
          End;
          WardList := Copy(WardList,1,Length(WardList)-1);
          FValue := FValue + '^' + FromDate + '^' + ToDate + '^' + Fgraph + '^' +
            fraDevLookup.edtValue.Text + '^' + DevIen + '^' + PrintDT + '^' + WardIEN + '^^' + WardList;

          ReportPr(Froutine, Fvalue, GraphName);
        end;
      if (DEVIen <> '') and (ReportCombo.ItemIndex > 4) then
        begin
          if ReportCombo.ItemIndex = 5 then
            Froutine := 'GMV CUMULATIVE REPORT';
          if ReportCombo.ItemIndex = 6 then
            FRoutine := 'GMV LATEST VITALS BY LOCATION';
          if ReportCombo.ItemIndex = 7 then
            FRoutine := 'GMV LATEST VITALS FOR PATIENT';
          if ReportCombo.ItemIndex = 8 then
            Froutine := 'GMV ENTERED IN ERROR-PATIENT';
          for a := 0 to Roomcombo.Items.Count - 1 do
          begin
              if RoomCombo.Checked[a] = True then
                begin
                  WardList := WardList + Roomcombo.DisplayText[a] + ',';
                end;
          end;
          If WardIEN = '' then
          Begin
             FValue := FptIEN;
          End;
          WardList := Copy(WardList,1,Length(WardList)-1);
          FValue := Fvalue +  '^' + FromDate + '^' + ToDate + '^^' +
            fraDevLookup.edtValue.Text + '^' + DevIen + '^' + PrintDT + '^' + WardIEN + '^^' + WardList;
          ReportPr(Froutine, Fvalue, GraphName);
        end;
      ModalResult := mrOk;
    end;
end;

procedure TfrmGMV_DevList.ReportPr(const routine, value, Report: string);
begin
  CallServer(GMVBroker, routine, [value], nil, nil);
  MessagedlgS(GMVBroker.Results[0], mtInformation, [mbOK], 0);
end;

procedure TfrmGMV_DevList.WardComboChange(Sender: TObject);
begin
  RoomCombo.Clear;
  if WardCombo.DisplayText[WardCombo.itemindex] <> '' then
    begin
      CallServer(GMVBroker, 'GMV ROOM/BED', [WardCombo.DisplayText[WardCombo.itemindex]], nil, RetList);
      if RetList.Count > 0 then
        begin                   //AAN 06/10/02
          SetRoomActive(True);  //AAN 06/10/02
          RoomCombo.Items.AddStrings(RetList);
        end                     //AAN 06/10/02
      else                      //AAN 06/10/02
        SetRoomActive(False);   //AAN 06/10/02
    end
  else                          //AAN 06/10/02
    SetRoomActive(False);       //AAN 06/10/02
end;

procedure TfrmGMV_DevList.ReportComboChange(Sender: TObject);
begin
  if (ReportCombo.ItemIndex > -1) and (ReportCombo.ItemIndex < 7) then
    begin
//      WardCombo.Enabled := True;              //AAN 06/10/02
//      If ReportCombo.ItemIndex <> 6 then      //AAN 06/10/02
//         RoomCombo.Enabled := True            //AAN 06/10/02
//      Else RoomCombo.Enabled := False;        //AAN 06/10/02
      SetWardActive(True);                      //AAN 06/10/02
      Margin := '80';
    end
  else
    begin
//      WardCombo.Enabled := False;     //AAN 06/10/02
//      RoomCombo.Enabled := False;     //AAN 06/10/02
      SetWardActive(False);
      Margin := '132';
    end;
   WardCombo.Text := '';                //AAN 06/10/02
   WardComboChange(Sender);             //AAN 06/10/02
//   GroupBox5.Enabled := WardCombo.Enabled; //AAN 06/10/02
//   GroupBox5.Visible := WardCombo.Enabled; //AAN 06/10/02
end;

procedure TfrmGMV_DevList.DevComboNeedData(Sender: TObject; const StartFrom: string; Direction, InsertAt: Integer);
begin
  CallServer(GMVBroker, 'GMV GET DEVICES', [StartFrom, IntToStr(Direction), Margin], nil, RetList);
end;

procedure TfrmGMV_DevList.FormDestroy(Sender: TObject);
begin
If fraDevLookUP.IEN <> '' then
  GMVUser.Setting[usLastVistAPrinter] := fraDevLookUp.IEN;
end;
//AAN 06/10/02 ------------------------------------------------------------Begin
procedure TfrmGMV_DevList.SetWardActive(bState: Boolean);
begin
  WardCombo.Enabled := bState;
  WardLabel.Enabled := bState;
end;

procedure TfrmGMV_DevList.SetRoomActive(bState: Boolean);
begin
  RoomCombo.Enabled := bState;
  RoomLabel.Enabled := bState;
end;
//AAN 06/10/02 --------------------------------------------------------------End

end.
