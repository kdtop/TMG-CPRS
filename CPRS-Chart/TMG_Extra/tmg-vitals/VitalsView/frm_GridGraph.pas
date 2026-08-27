unit frm_GridGraph;
{
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
  StdCtrls,
  Grids,
  ExtCtrls,
  Chart,
  Buttons,
  ExtDlgs,
  Menus, ActnList, ImgList, ComCtrls
  , mGMV_MDateTime, TeeProcs, Series, TeEngine, StdActns
  ;

type
  TStringToDouble = Function(aString: String): Double;
(*
  TGraph = Class(TObject);
    ChartTitle: String;
    GridTitle:String;
    Converter: TStringToDouble;
  public
//    procedure Reload(ChronoMode:Boolean);

  end;
*)
  Tfrm_GridGraph = class(TForm)
    pnlMain: TPanel;
    ActionList1: TActionList;
    acResizeGraph: TAction;
    acPrintGraph: TAction;
    acValueCaptions: TAction;
    ImageList1: TImageList;
    acGraphButtons: TAction;
    pnlGridGraph: TPanel;
    splGridGraph: TSplitter;
    pnlGraph: TPanel;
    pnlGrid: TPanel;
    grdVitals: TStringGrid;
    pnlDateRange: TPanel;
    acEnterVitals: TAction;
    ac3D: TAction;
    pnlTitle: TPanel;
    pnlPtInfo: TPanel;
    lblPatientName: TLabel;
    lblPatientInfo: TLabel;
    Panel9: TPanel;
    lblHospital: TLabel;
    Label6: TLabel;
    pnlActions: TPanel;
    sbEnterVitals: TSpeedButton;
    SpeedButton8: TSpeedButton;
    pnlGraphBackground: TPanel;
    chrtVitals: TChart;
    pnlGridTop: TPanel;
    Panel1: TPanel;
    Series3: TPointSeries;
    Series4: TPointSeries;
    acOptions: TAction;
    Label1: TLabel;
    pnlDateRangeInfo: TPanel;
    Label11: TLabel;
    lblDateFromTitle: TLabel;
    pnlGBot: TPanel;
    pnlGTop: TPanel;
    pnlGLeft: TPanel;
    pnlGRight: TPanel;
    sbEnteredInError: TSpeedButton;
    acEnteredInError: TAction;
    acCustomRange: TAction;
    pnlGraphOptions: TPanel;
    PopupMenu1: TPopupMenu;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    acZoom: TAction;
    acGraphOptions: TAction;
    ShowHideGraphOptions1: TMenuItem;
    Panel5: TPanel;
    pnlPTop: TPanel;
    pnlPRight: TPanel;
    pnlPLeft: TPanel;
    pnlPBot: TPanel;
    pnlDateRangeTop: TPanel;
    lbDateRange: TListBox;
    Panel6: TPanel;
    lblDateRange: TLabel;
    acEnteredInErrorByTime: TAction;
    N1: TMenuItem;
    MarkasEnteredInError1: TMenuItem;
    N2: TMenuItem;
    Print1: TMenuItem;
    acPatientAllergies: TAction;
    sbtnAllergies: TSpeedButton;
    ColorSelect1: TColorSelect;
    ColorDialog1: TColorDialog;
    cbChrono: TCheckBox;
    Series2: TPointSeries;
    cbxGraph: TComboBox;
    SelectGraphColor1: TMenuItem;
    EnterVitals1: TMenuItem;
    Allergies1: TMenuItem;
    Panel4: TPanel;
    trbHGraph: TTrackBar;
    pnlDebug: TPanel;
    lblPos: TLabel;
    lblMin: TLabel;
    lblMax: TLabel;
    lblDate: TLabel;
    lblX: TLabel;
    Series5: TPointSeries;
    Series6: TPointSeries;
    Series7: TPointSeries;
    Series8: TPointSeries;
    Series9: TPointSeries;
    Series10: TPointSeries;
    Series11: TPointSeries;
    Series12: TPointSeries;
    Series13: TPointSeries;
    Bevel1: TBevel;
    Series1: TPointSeries;
    Bevel2: TBevel;
    Bevel3: TBevel;
    procedure cbxDateRangeClick(Sender: TObject);
    procedure cbxGraphChange(Sender: TObject);
    procedure ShowHideLabels(Sender: TObject);
    procedure chrtVitalsClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: integer; Button: TMouseButton; Shift: TShiftState; x,
      Y: integer);
    procedure chrtVitalsAfterDraw(Sender: TObject);
    procedure sbtnPrintGraphClick(Sender: TObject);
    procedure sbtnLabelsClick(Sender: TObject);
    procedure sbtnMaxGraphClick(Sender: TObject);
    procedure grdVitalsDrawCell(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdVitalsSelectCell(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; x, Y: integer);
    procedure FrameResize(Sender: TObject);
    procedure acResizeGraphExecute(Sender: TObject);
    procedure acPrintGraphExecute(Sender: TObject);
    procedure acValueCaptionsExecute(Sender: TObject);
    procedure acEnterVitalsExecute(Sender: TObject);
    procedure ac3DExecute(Sender: TObject);
    procedure lbDateRangeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sbStyleClick(Sender: TObject);
    procedure Panel9Resize(Sender: TObject);
    procedure pnlGridResize(Sender: TObject);
    procedure scbHGraphChange(Sender: TObject);
    procedure chrtVitalsResize(Sender: TObject);
    procedure cbxGraphExit(Sender: TObject);
    procedure cbxGraphEnter(Sender: TObject);
    procedure lbDateRangeExit(Sender: TObject);
    procedure lbDateRangeEnter(Sender: TObject);
    procedure grdVitalsEnter(Sender: TObject);
    procedure grdVitalsExit(Sender: TObject);
    procedure acEnteredInErrorExecute(Sender: TObject);
    procedure acCustomRangeExecute(Sender: TObject);
    procedure lbDateRangeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acZoomExecute(Sender: TObject);
    procedure acGraphOptionsExecute(Sender: TObject);
    procedure acEnteredInErrorByTimeExecute(Sender: TObject);
    procedure acPatientAllergiesExecute(Sender: TObject);
    procedure ColorSelect1Accept(Sender: TObject);
    procedure sbGraphColorClick(Sender: TObject);
    procedure cbChronoClick(Sender: TObject);
    procedure cbPeriodChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure lbDateRangeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chrtVitalsBeforeDrawSeries(Sender: TObject);
    procedure grdVitalsTopLeftChanged(Sender: TObject);
  private
    fXL,fXR: LongInt;                   // X coordinates of the Blue Lines
    FbgColor: TColor;   // graph bg color

    FPatientNumber: string;           // parent copy to enter vitals, to retreive data
    ptName:String;
    ptInfo: String;

    FMDateTimeRange: TMDateTimeRange; // parent copy to retreive data
    FObservationRange: String;  // string copy of the above

    FPatientLocation: String;         // parent copy to enter vitals
    FPatientLocationName:String;

    fCurrentGraph:String;

    fGridNameString:String;
    fGridRow:Integer;

    fGraphIndex:Integer;
    fFrameInitialized: Boolean;

    bLabelShow: Boolean;
    FStyle:String; // fsVitals or fsDLL

    FCurrentPoint: Integer;

    fSelectedDateTime:TDateTime;  // entered in error

    iIgnoreCount:Integer;

    function MetricValueString(_Row_:Integer;_Value_:String):String;// AAN 06/24/2002
    procedure DrawMissingDataLines(Sender: TObject);
    procedure DrawMissingLines(aStartPoint,aStopPoint:Integer);
    procedure MaximizeGraph(Sender: TObject);
    procedure PrintGraph(Sender: TObject);
    procedure SetPatientNumber(const Value: string);
    procedure GetVitalsData(aFrom,aTo:String);
    procedure GraphDataByIndex(anIndex:Integer);
    procedure getGraphDataByName(aName:String);
    procedure SetGraphIndex(anIndex:Integer);

    procedure SetStyle(aStyle:String);
    procedure setPatientLocation(aLocation:String);
    procedure setPatientLocationName(aLocationName:String);
    procedure setMDateTimeRange(aMDTR: TMDateTimeRange);

    procedure setTRP;
    procedure setBP;
    procedure setHW;

    procedure setSingleVital(aRow:Integer;aSeria:Integer=0;aName:String='';
      aConvertor:TStringToDouble = nil);
    procedure setSeriesAxis(TheSeries:Array of Integer);
    procedure setActiveAxisLimits;

    procedure setCurrentPoint(aValue: Integer);
    procedure setGridPosition(aPosition: Integer);

    procedure setObservationRange(aRange:String);
    procedure setGridLimits;

    procedure UpdateLists;
    procedure SetColor(aColor:TColor);

{$IFDEF ALLSERIES}
    procedure RefreshFrame;

    procedure OnPatientChange;
    procedure OnPeriodChange;
    procedure OnPositionChange;
    procedure OnGraphChange;
    procedure OnAddData;
    procedure OnChangeData;
    procedure ActivateSeriesByGridRow(aRow:Integer);
    procedure ActivateSeriesByGraphIndex;
{$ENDIF}
   function GraphNameByGridRow(aRow:Integer):String;
   function GridRowByGraphIndex(anIndex:Integer):Integer;
  public
    PackageSignature: String;   //?
    InputTemplateName: String;

    procedure setGraphTitle(aFirst,aSecond: String);
    procedure SetUp;
    procedure UpdateTimeLabels;
    procedure UpdateFrame;

    procedure SaveStatus;
    procedure RestoreStatus;

    procedure setGraphByABBR(aABBR:String);
  published
    property BGColor: TColor read fBGColor write SetColor;

    property FrameInitialized: Boolean  read FFrameInitialized write FFrameInitialized;
    property GraphIndex: Integer        read FGraphIndex write setGraphIndex; //needs update
    property FrameStyle: String         read FStyle write SetStyle; //CPRS or Vitals
    property PatientNumber: string      read FPatientNumber write SetPatientNumber;
    property PatientLocation: string    read FPatientLocation write SetPatientLocation;
    property PatientLocationName:string read FPatientLocationName write SetPatientLocationName;
    property MDateTimeRange: TMDateTimeRange read FMDateTimeRange write setMDateTimeRange;
    property CurrentPoint: Integer      read FCurrentPoint write setCurrentPoint;
    property ObservationRange: String   read FObservationRange write setObservationRange;

    property GridRow: Integer read fGridRow write fGridRow;
  end;

const
  fsVitals = 'Vitals';
  fsDLL = 'Dll';


implementation

uses
  fGMV_DateRange,
  fGMV_ShowSingleVital
  , uGMV_Const
  , uGMV_GlobalVars
  , uGMV_User
  , uGMV_Utils
  , fGMV_InputLite
  , uGMV_Engine
  , fGMV_EnteredInError
  , fGMV_PtInfo, uGMV_VitalTypes
  , u_Common
  , Math
  ;

{$R *.DFM}
const
  rHeader = 0;
  rTemp = 1;
  rPulse = 2;
  rResp = 3;
  rBP = 6;
  rWeight = 7;
  rBMI = 8;
  rHeight = 9;
  rGirth = 10;
  rPain = 14;
  rPOx = 4;

  sGraphNameNoGraph = 'No Graph';

  sgnTRP = 'TPR';
  sgnBP = 'B/P';
  sgnHW = 'Height/Weight';
  sgnPOX = 'Pulse Ox.';

  sgnTemp = ' Temperature';
  sgnPulse = ' Pulse';
  sgnResp = ' Respiration';
//      Cells[0, 4] := ' P Ox %:'; //AAN 2003/06/03
  sgnWeight = 'Weight';//    Cells[0, 7] := ' Wt (lbs):';
  sgnBMI = 'BMI';//    Cells[0, 8] := ' BMI:';
  sgnHeight = 'Height'; //    Cells[0, 9] := ' Ht (in):';
  sgnGirth = 'Girth';//    Cells[0, 10] := ' C/G:';
  sgnCVP = 'CVP';//    Cells[0, 11] := ' CVP (cmH2O):';
  sgnIn = 'Intake';//    Cells[0, 12] := ' In 24hr (c.c.):';
  sgnOutput = 'Output';//    Cells[0, 13] := ' Out 24hr (c.c.):';
  sgnPain = 'Pain';//  Cells[0, 14] := ' Pain:';


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function BPMeanBP(aString:String):Double;
  begin
    Result := BPMean(aString);
  end;

function BPDias(aString:String):Double;
  begin
    Result := iVal(Piece(aString, '/', 2));
  end;

{$IFDEF ALLSERIES}
procedure Tfrm_GridGraph.ActivateSeriesByGraphIndex;
var
  i: Integer;
begin
  case GraphIndex of
    0:i := 1; // TPR
    1: i := 6;// BP
    2: i := 8;
    3: i := 14;
    4: i := 4;
    5: i := 9;
    6: i := 7;
    7: i := 10;
  else
    i := 0;
  end;
  ActivateSeriesByGridRow(i);
end;

procedure Tfrm_GridGraph.ActivateSeriesByGridRow(aRow:Integer);

  procedure setActive(aList:Array of Integer);
  var
    i: Integer;
    begin
      for i := low(aList) to High(aList) do
        chrtVitals.Series[i].Active := aList[i] = 1;
      setActiveAxisLimits;
    end;

begin
  chrtVitals.Visible := True;
  case aRow of
    1,2,3: setActive([1,1,1,0,0,0,0,0,0,0,0,0,0]);
    4: setActive([0,0,0,1,0,0,0,0,0,0,0,0,0]);
    6: setActive([0,0,0,0,1,1,1,0,0,0,0,0,0]);
    7: setActive([0,0,0,0,0,0,0,1,0,0,0,0,0]);
    8: setActive([0,0,0,0,0,0,0,0,1,1,0,0,0]);
    9: setActive([0,0,0,0,0,0,0,0,0,0,1,0,0]);
    10: setActive([0,0,0,0,0,0,0,0,0,0,0,1,0]);
    14: setActive([0,0,0,0,0,0,0,0,0,0,0,0,1]);
  else
    chrtVitals.Visible := False;
  end;
end;

procedure Tfrm_GridGraph.RefreshFrame;
begin
  // GetVitals Data (Patient, Period)
  // Prepare Series
  if Assigned(MDateTimeRange) then
    GetVitalsData(MDateTimeRange.Start.getSMDateTime,MDateTimeRange.Stop.getSMDateTime)
  else Exit;

  // Set scroller limits
  trbHGraph.Max := grdVitals.Colcount - 2;
  // Set Default Position of the scroller(LastVisible grid cells)
  trbHGraph.Position := grdVitals.ColCount - grdVitals.VisibleColCount+1;

  // Activate Series (CurrentGraph, ChronoStatus)
  ActivateSeriesByGraphIndex;

  // Set Ative Axis Limits
  SetActiveAxisLimits;

  // UpdateIndicators
  //    - Patient
  //    - Period

end;

procedure Tfrm_GridGraph.OnPatientChange;
begin
  RefreshFrame;
end;

procedure Tfrm_GridGraph.OnPeriodChange;
begin
  RefreshFrame;
end;

procedure Tfrm_GridGraph.OnPositionChange;
begin
  grdVitals.LeftCol := trbHGraph.Position;
end;

procedure Tfrm_GridGraph.OnGraphChange;
begin
  ActivateSeriesByGraphIndex;
  SetActiveAxisLimits;
end;

procedure Tfrm_GridGraph.OnAddData;
begin
  RefreshFrame;
end;

procedure Tfrm_GridGraph.OnChangeData;
begin
  RefreshFrame;
end;

{$ENDIF}

////////////////////////////////////////////////////////////////////////////////

procedure Tfrm_GridGraph.GetVitalsData(aFrom,aTo:String);
var
  VMEntry: TStringlist;

  function getDateTime(aString:String):String;
  begin
    Result := Piece(aString, '^', 1) + ' ' + Piece(aString, '^', 2); // Date Time
  end;
  function getTemperature(aString:String):String;
  begin
    Result := Piece(Piece(aString, '^', 3), '-', 1) + Piece(Piece(aString, '^', 3), '-', 2); //temperature
  end;
  function getPulse(aString:String):String;
  var
    s1,s2:String;
  begin
    s1 := Piece(Piece(aString, '^', 4), '-', 1);
    s2 := Piece(Piece(aString, '^', 4), '-', 2);
    while pos(' ',s2)=1 do
      s2 := copy(s2,2,length(s2)-1);
    Result := s1 + ' ' +Piece(s2, ' ', 1) + ' ' +
                        Piece(s2, ' ', 2) + ' ' +
                        Piece(s2, ' ', 3) + ' ' +
                        Piece(s2, ' ', 4);
  end;
  function getRespiration(aString:String):String;
  begin
    Result := Piece(Piece(aString, '^', 5), '-', 1) +Piece(Piece(aString, '^', 5), '-', 2); // Respiratory
  end;

  procedure CleanUpGrid;
  var
    c,r: Integer;
  begin
    with grdVitals do
      begin
        for c := 1 to ColCount - 1 do
        for r := 1 to RowCount - 1 do
          Cells[c, r] := '';
      end;
  end;

  procedure FillGrid;
  var
    i, r, c, j: integer;
    _S_,__S,s3,//AAN
    sFrom,sTo,
    s1, s2: string;
  begin
    with grdVitals do
      begin
        // check if we need an extra point
        if VMEntry.Count < 1 then Exit;

        c := 1;
        ColCount := VMEntry.Count + 1;
{
// The next code adds 2 blank columns - at the boundaries of the observation period
        s1 := FormatDateTime(GMV_DateTimeFormat,FMDateTimeToWindowsDateTime(StrToFloat(aFrom)));
        s1 := ReplaceStr(s1,'/','-');
        s2 := FormatDateTime(GMV_DateTimeFormat,FMDateTimeToWindowsDateTime(StrToFloat(aTo)));
        s2 := ReplaceStr(s2,'/','-');
        if Piece(getDateTime(VMEntry[0]),' ',1)<> s1 then
          begin
            Cells[1,0] := s1;
            c := 2;
            ColCount := ColCount + 1;
          end;
        if Piece(getDateTime(VMEntry[VMEntry.Count-1]),' ',1)<> s2 then
          begin
            ColCount := ColCount + 1;
            Cells[ColCount-1,0] := s2;
          end;
}
        CleanUpGrid;

        for i := VMEntry.Count - 1 downto 0 do
          begin
            s1 := VMEntry[i];
            _s_ := VMEntry[i];

            Cells[c, 0] := getDateTime(_s_);
            Cells[c, 1] := getTemperature(_s_);
            Cells[c, 2] := getPulse(_s_);
            Cells[c, 3] := getRespiration(_s_);

            // Pulse Oximetry
            s1 := Piece(Piece(VMEntry[i], '^', 6), '-', 1);//Value
            s2 := Piece(Piece(VMEntry[i], '^', 6), '-', 2);//Method
            s3 := Piece(Piece(VMEntry[i], '^', 6), '--',2);//
            Cells[c, 4] := s1;//Moving qualifiers away

            __s := Piece(Piece(VMEntry[i], '^',6), '-', 3)+' / '+
                   Piece(Piece(VMEntry[i],'^', 6), '-', 4); //Pox
            if __s = ' / ' then
              Cells[c, 5] := s2
            else
              Cells[c, 5] := __s+ ' / '+s2;

            s1 := Piece(Piece(VMEntry[i], '^', 7), '-', 1);
            s2 := Piece(Piece(VMEntry[i], '^', 7), '-', 2);
            Cells[c, 6] := s1 + ' ' + s2;

            Cells[c, 7] := Piece(Piece(VMEntry[i], '^', 8), '-', 1) +
                           Piece(Piece(VMEntry[i], '^', 8), '-', 2);
            Cells[c, 8] := Piece(Piece(VMEntry[i], '^', 10), '-', 1)
                         + Piece(Piece(VMEntry[i], '^', 10), '-', 2);
            Cells[c, 9] := Piece(Piece(VMEntry[i], '^', 11), '-', 1)
                         + Piece(Piece(VMEntry[i], '^', 11), '-', 2);
            Cells[c, 10] := Piece(Piece(VMEntry[i], '^', 13), '-', 1)
                          + Piece(Piece(VMEntry[i], '^', 13), '-', 2);
            Cells[c, 11] := Piece(VMEntry[i], '^', 15);
            Cells[c, 12] := Piece(Piece(VMEntry[i], '^', 17), '-', 1);
            Cells[c, 13] := Piece(Piece(VMEntry[i], '^', 18), '-', 1);
            Cells[c, 14] := Piece(Piece(VMEntry[i], '^', 19), '-', 1);

            for j := 0 to 14 do                           //AAN 07/11/2002
              if pos('Unavail',Cells[c,j]) <> 0  then     //AAN 07/11/2002
                Cells[c,j] := 'Unavailable';              //AAN 07/11/2002

            inc(c);
          end;
        Col := ColCount - 1;
        Row := 1;
      end;
  end;

begin
  if not Assigned(MDateTimeRange) or (MDateTimeRange.getSWRange = '')
     or (FPatientNumber = '') then
    Exit;

  try
    VMEntry := getAllPatientData(FPatientNumber,aFrom,aTo);
    if VMEntry.Count > 0 then
      begin
        FillGrid;
{$IFDEF ALLSERIES} // prepare data series
// 1 - Temperature
// 2 - Pulse
// 3 - Resp
        SetSingleVital(rTemp,0,'Temp.');
        SetSingleVital(rPulse,1,'Pulse');
        SetSingleVital(rResp,2,'Resp.');
// 4 - POx
        setSingleVital(rPOx,3);
//     l/min
// 6 - BP
        SetSingleVital(rBP,4,'Sys.');
        SetSingleVital(rBP,5,'Mean',BPMeanBP);
        SetSingleVital(rBP,6,'Dias.',BPDias);
// 7 - Wt
        setSingleVital(rWeight,7);
// 8 - BMI
?        SetSingleVital(rHeight,8,'Height');
        SetSingleVital(rWeight,9,'Weight');
// 9 - Ht
        setSingleVital(rHeight,10);
//10 - C/G
        setSingleVital(rGirth,11);
//11 CVP
//12 In
//13 Out
//14 - Pain
        setSingleVital(rPain,12);
{$ENDIF}
      end;
    GrdVitals.Refresh;
  finally
    VMEntry.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//==============================================================================
procedure Tfrm_GridGraph.setActiveAxisLimits;
var
  i: Integer;
  dMax,dMin,dDelta: Double;
begin
  chrtVitals.LeftAxis.Minimum := 0;

  dMax := 0;// chrtVitals.Series[Low(TheSeries)].MaxYValue;
  dMin := 500;//chrtVitals.Series[Low(TheSeries)].MinYValue;

  for i := 0 to chrtVitals.SeriesCount - 1 do
    begin
      if not chrtVitals.Series[i].Active then continue;
      chrtVitals.Series[i].Xvalues.DateTime := cbChrono.Checked;
      chrtVitals.Series[i].Marks.Visible := bLabelShow;
      dMax := Max(dMax,chrtVitals.Series[i].MaxYValue);
      dMin := Min(dMin,chrtVitals.Series[i].MinYValue);
    end;

  dDelta := 0.05*(dMax - dMin);
  chrtVitals.LeftAxis.Maximum := dMax+dDelta;
  chrtVitals.LeftAxis.Minimum := dMin-dDelta;
end;

procedure Tfrm_GridGraph.setSeriesAxis(TheSeries:Array of Integer);
var
  i: Integer;
  dMax,dMin,dDelta: Double;

  function LocalMin(aSeries:TChartSeries): Double;
  var
    j: Integer;
    LM: Double;
  begin
    LM := 500;
    for j := 0 to aSeries.Count - 1 do
      if aSeries.YValue[j] = 0 then continue
      else LM := min(LM,aSeries.YValues[j]);
    Result := LM;
  end;

begin
  chrtVitals.LeftAxis.Minimum := 0;
  dMax := chrtVitals.Series[Low(TheSeries)].MaxYValue;
  if cbChrono.Checked then
    dMin := chrtVitals.Series[Low(TheSeries)].MinYValue
  else
    dMin := LocalMin(chrtVitals.Series[Low(TheSeries)]);

  for i := Low(TheSeries) to High(TheSeries) do
    begin
      dMax := Max(dMax,chrtVitals.Series[Theseries[i]].MaxYValue);
      if cbChrono.Checked then
        dMin := Min(dMin,chrtVitals.Series[i].MinYValue)
      else
        dMin := Min(dMin,LocalMin(chrtVitals.Series[i]));
    end;

  dDelta := 0.05*(dMax - dMin);
  chrtVitals.LeftAxis.Maximum := dMax+dDelta;
  chrtVitals.LeftAxis.Minimum := dMin-dDelta;
end;

procedure Tfrm_GridGraph.setSingleVital(aRow:Integer;aSeria:Integer=0;aName:String='';
      aConvertor:TStringToDouble = nil);
var
  gCol: integer;
  s: String;
  dValue,
  dHMax,dWMax,
  dHMin,dWMin,
  d: Double;

  function ValueDateTime(aCol:Integer):Double;
  var
    ss:String;
    dd: Double;
  begin
    try
      sS := grdVitals.Cells[aCol, rHeader];
      sS := ReplaceStr(ss,'-','/');
      dD := StrToDateTime(ss);
    except
      dd := Now;
    end;
    Result := dd;
  end;

begin
  gCol := 1;

  chrtVitals.LeftAxis.Automatic := False;
  chrtVitals.LeftAxis.Minimum := 0;
  chrtVitals.LeftAxis.Maximum := 500;
  chrtVitals.Series[aSeria].Clear;

  if aName = '' then
    chrtVitals.Series[aSeria].Title := grdVitals.Cells[0,aRow]
  else
    chrtVitals.Series[aSeria].Title := aName;
  chrtVitals.Series[aSeria].Identifier := IntToStr(aRow);

  with grdVitals do
    while (Cells[gCol, rHeader] <> '') and (gCol < ColCount) do
      begin
        try
          d := ValueDateTime(gCol);
          if cbChrono.Checked then
            begin
              if HasNumericValue(Cells[gCol, aRow]) then
                begin
                  // dValue := iVal(Cells[gCol, aRow]);
                  if assigned(aConvertor) then dValue := aConvertor(Cells[gCol, aRow])
                  else dValue := iVal(Cells[gCol, aRow]);
                  chrtVitals.Series[aSeria].AddXY(d,dValue, SeriesLabel(Cells[gCol, rHeader]), clTeeColor);
//                  else
//                    chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]));
                end
                ;
            end
          else
            begin
              if assigned(aConvertor) then dValue := aConvertor(Cells[gCol, aRow])
              else dValue := iVal(Cells[gCol, aRow]);
              if HasNumericValue(Cells[gCol, aRow]) then
                chrtVitals.Series[aSeria].Add(dValue, SeriesLabel(Cells[gCol, rHeader]), clTeeColor)
              else
                chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]))
                ;
            end;
        except
            chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]));
        end;
        inc(gCol);
      end;

  setSeriesAxis([aSeria]);

  if aRow = rPain then chrtVitals.LeftAxis.Maximum := 12;
  if aRow = rPain then chrtVitals.LeftAxis.Minimum := -0.5;

  chrtVitals.Series[aSeria].Active := True;
end;

procedure Tfrm_GridGraph.setHW;
begin
  SetSingleVital(rHeight,0,'Height');
  SetSingleVital(rWeight,1,'Weight');
  setSeriesAxis([0,1]);
end;

procedure Tfrm_GridGraph.setTRP;
begin
  SetSingleVital(rTemp,0,'Temp.');
  SetSingleVital(rPulse,1,'Pulse');
  SetSingleVital(rResp,2,'Resp.');
  setSeriesAxis([0,1,2]);
end;

procedure Tfrm_GridGraph.setBP;
begin
  SetSingleVital(rBP,0,'Sys.');
  SetSingleVital(rBP,1,'Dias.',BPDias);
  setSeriesAxis([0,1]);
//  SetSingleVital(rBP,1,'Mean',BPMeanBP);
//  SetSingleVital(rBP,2,'Dias.',BPDias);
//  setSeriesAxis([0,1,2]);
end;

//==============================================================================
//==============================================================================
//==============================================================================
procedure Tfrm_GridGraph.getGraphDataByName(aName:String);

  function getDefaultPosition: Integer;
  var
    i: Integer;
  begin
    i := (grdVitals.Width - grdVitals.ColWidths[0]) div grdVitals.ColWidths[1];
    i := grdVitals.ColCount - i;
    if i < 1 then i := 1;
    Result := i;
  end;

  procedure CleanUp;
  var
    j: Integer;
  begin
    with chrtVitals do
      begin
        ScaleLastPage := true;
        UndoZoom;
        for j := SeriesList.Count-1 downto 0 do
          begin
            Series[j].Clear;
            Series[j].Active := False;
            Series[j].Marks.Visible := checkBox1.Checked;
          end;
      end;
  end;

begin
  acGraphButtons.Enabled := True;
  acResizeGraph.Enabled := True;


  if FPatientNumber = '' then  Exit;

  if (aName = sGraphNameNoGraph)
    or (aName = sgnGirth)
    or (aName = sgnCVP)
    or (aName = sgnIn)
    or (aName = sgnOutput)
    then
    begin
      chrtVitals.Visible := False;
      acGraphButtons.Enabled := False;
      acResizeGraph.Enabled := False;
      if not pnlGrid.Visible then MaximizeGraph(nil);
      pnlGraphBackground.Caption := 'Sorry the graph of <'+aName+'> is not available.';
      Exit;
    end;

  CleanUp;
  chrtVitals.Visible := true;;

  if aName = sgnTRP then setTRP
  else if aName = sgnBP then  setBP
  else if aName = sgnPain then setSingleVital(rPain,0,sgnPain)
  else if aName = sgnHW then setHW
  else if aName = sgnPOX then setSingleVital(rPOx,0,sgnPOX)
  else if aName = sgnHeight then setSingleVital(rHeight,0,sgnHeight)
  else if aName = sgnWeight then setSingleVital(rWeight,0,sgnWeight)
  else if aName = sgnBMI then setSingleVital(rBMI,0,sgnBMI)
  else if aName = sgnTemp then setSingleVital(rTemp,0,sgnTemp)
  else if aName = sgnPulse then setSingleVital(rPulse,0,sgnPulse)
  else if aName = sgnResp then setSingleVital(rResp,0,sgnResp)
  ;
  setGridLimits;

  grdVitals.LeftCol := getDefaultPosition;
  CurrentPoint := grdVitals.LeftCol;
  trbHGraph.Position := grdVitals.LeftCol;
  setGridPosition(grdVitals.LeftCol);

end;

procedure Tfrm_GridGraph.GraphDataByIndex(anIndex:Integer);
begin
{$IFDEF ALLSERIES}EXIT;{$ENDIF}
  // Index - index of the Graph list control
  getGraphDataByName(cbxGraph.Items[anIndex]);
end;

////////////////////////////////////////////////////////////////////////////////

procedure Tfrm_GridGraph.setGridPosition(aPosition: Integer);
var
  i,
  iPos,
  iMin,iMax: Integer;
  d,dd:Double;

begin
  lblPos.Caption := 'slider pos:'+IntToStr(aPosition);

  try
    chrtVitals.BottomAxis.Automatic := False;

    iPos := aPosition;
    if iPos < 1 then iPos := 1;
    grdVitals.LeftCol := iPos;

    lblDate.Caption := 'Date= '+grdVitals.Cells[iPos,0];

    if cbChrono.Checked then
      begin
        d := getCellDateTime(grdVitals.Cells[iPos,0]);
        lblX.Caption := 'X= '+FloatToStr(d);

        d := MDateTimeRange.Start.WDate;
        dd := MDateTimeRange.Stop.WDate;

        lblMin.Caption := 'Min= '+FloatToStr(d);
        lblMax.Caption := 'Max= '+FloatToStr(dd);
        if d <= dd then
          begin
            if chrtVitals.BottomAxis.Minimum > d then
              begin
                chrtVitals.BottomAxis.Minimum := d;
                chrtVitals.BottomAxis.Maximum := dd;
              end
            else
            if chrtVitals.BottomAxis.Maximum < dd then
              begin
                chrtVitals.BottomAxis.Maximum := dd;
                chrtVitals.BottomAxis.Minimum := d;
              end
            else
              begin
                chrtVitals.BottomAxis.Minimum := 0;
                chrtVitals.BottomAxis.Maximum := dd;
                chrtVitals.BottomAxis.Minimum := d;
              end;
          end;
      end
    else
      begin
        iMin :=grdVitals.LeftCol - 1; // no need in correction
        iMax  :=grdVitals.LeftCol - 1+ grdVitals.VisibleColCount;
        if iMin <= iMax then
          begin
            if chrtVitals.BottomAxis.Minimum > iMin then
              begin
                chrtVitals.BottomAxis.Minimum := iMin;
                chrtVitals.BottomAxis.Maximum := iMax;
              end
            else
            if chrtVitals.BottomAxis.Maximum < iMax then
              begin
                chrtVitals.BottomAxis.Maximum := iMax;
                chrtVitals.BottomAxis.Minimum := iMin;
              end
            else
              begin
                chrtVitals.BottomAxis.Minimum := 0;
                chrtVitals.BottomAxis.Maximum := iMax;
                chrtVitals.BottomAxis.Minimum := iMin;
              end;
      end;

        chrtVitals.Invalidate;
        pnlGridResize(nil);
      end;
  except
  end;
end;

procedure Tfrm_GridGraph.setCurrentPoint(aValue: Integer);
begin
  FCurrentPoint := aValue;
  if iIgnoreCount > 0 then Exit;
  Inc(iIgnoreCount);
  setGridPosition(aValue);
  Dec(iIgnoreCount);
end;

procedure Tfrm_GridGraph.scbHGraphChange(Sender: TObject);
begin
  if Sender = trbHGraph then
    CurrentPoint := trbHGraph.Position;
end;

////////////////////////////////////////////////////////////////////////////////

procedure Tfrm_GridGraph.setMDateTimeRange(aMDTR: TMDateTimeRange);
begin
  FMDateTimeRange := aMDTR;
  UpdateTimeLabels;
end;

procedure Tfrm_GridGraph.setObservationRange(aRange:String);
begin
  if iIGnoreCount > 0 then Exit;
  Inc(iIgnoreCount);

  if MDateTimeRange.setMRange(aRange) then
    begin
      if (Uppercase(aRange) = sDateRange) then
        UpdateLists;

      FObservationRange:= aRange;
      updateTimeLabels;
      //set interface elements
      lbDateRange.ItemIndex := lbDateRange.Items.IndexOf(FObservationRange);
      if FrameInitialized then
        UpdateFrame;
//      setGridPosition(grdVitals.LeftCol);
    end;
  Dec(iIgnoreCount);
end;

procedure Tfrm_GridGraph.cbxDateRangeClick(Sender: TObject);
var
  s: String;
begin
  s := lbDateRange.Items[lbDateRange.ItemIndex];

  ObservationRange := s;

  if fStyle = fsVitals then
    GetParentForm(Self).Perform(CM_PERIODCHANGED, 0, 0);
end;

procedure Tfrm_GridGraph.SetPatientNumber(const Value: string);
begin
  if not FrameInitialized then Setup;
  FPatientNumber := Value;
  if Assigned(MDateTimeRange) then
    begin
      UpdateFrame;
//      GetVitalsData(MDateTimeRange.Start.getSMDateTime,MDateTimeRange.Stop.getSMDateTime);
//      GraphDataByIndex(GraphIndex);
      Visible := (Value <> '');
    end;
end;

procedure Tfrm_GridGraph.setGridLimits;
var
  i: Integer;
  iGridColCount: Integer;
  iTrbHGraphMax: Integer;
begin
  iGridColCount := (grdVitals.Width - grdVitals.ColWidths[0]) div grdVitals.ColWidths[1];
  if iGridColCount < grdVitals.VisibleColCount then
    iGridColCount := grdVitals.VisibleColCount;
  i := grdVitals.Width - grdVitals.ColWidths[0] - grdVitals.ColWidths[1]*(iGridColCount-1);
  if i < 0 then
    i := i + grdVitals.ColWidths[1];

//  iTrbHGraphMax := grdVitals.ColCount-2;
  iTrbHGraphMax := grdVitals.ColCount - iGridColCount;

  trbHGraph.min := 1;
  if iTrbHGraphMax < 1 then iTrbHGraphMax := 1;
  trbHGraph.max := iTrbHGraphMax;

  if not cbChrono.Checked then
    if chrtVitals.MaxPointsPerPage <> iGridColCount then
      begin
        chrtVitals.MaxPointsPerPage := iGridColCount;
        chrtVitals.Invalidate;
      end;
end;

procedure Tfrm_GridGraph.setGraphIndex(anIndex: Integer);
begin
  FGraphIndex := anIndex;

  if iIgnoreCount > 0 then Exit;
  Inc(iIgnoreCount);

  if GraphIndex <> 11 then
    cbxGraph.ItemIndex := FGraphIndex;

//  GraphDataByIndex(GraphIndex);
  if GraphIndex <> 11 then
    getGraphDataByName(cbxGraph.Items[GraphIndex])
  else
    begin
      fGraphIndex := 0;
      getGraphDataByName(sGraphNameNoGraph);
    end;
  pnlGridResize(nil);
  grdVitals.Invalidate;
  chrtVitals.Invalidate;

  Dec(iIgnoreCount);
end;

procedure Tfrm_GridGraph.cbxGraphChange(Sender: TObject);
begin
//  if iIgnoreCount > 0 then Exit;
//  Inc(iIgnoreCount);
  if Sender = cbxGraph then
    GraphIndex := cbxGraph.ItemIndex;

  case GraphIndex of
    0: fGridRow := 1;
    1: fGridRow := 2;
    2: fGridRow := 3;
    3: fGridRow := 6;
    4: fGridRow := 4;
    5: fGridRow := 9;
    6: fGridRow := 7;
    7: fGridRow := 8;
    8: fGridRow := 14;

  else fGridRow := -1;
  end;
//  Dec(iIgnoreCount);
end;

////////////////////////////////////////////////////////////////////////////////
procedure Tfrm_GridGraph.UpdateFrame;
var
  MDT: TMDateTime;
begin
  if not FrameInitialized then Exit;
  try
    MDT := TMDateTime.Create;
    MDT.WDateTime := MDateTimeRange.Stop.WDateTime;
    MDT.WDateTime := trunc(MDT.WDateTime)+1-5/(3600*24);
    GetVitalsData(MDateTimeRange.Start.getSMDateTime,MDT.getSMDateTime);
    MDT.Free;

    GraphDataByIndex(GraphIndex);

    pnlGridResize(nil);
    grdVitals.Invalidate;
    chrtVitals.Invalidate;
  except
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure Tfrm_GridGraph.UpdateTimeLabels;
begin
//  lblDateFrom.Caption := MDateTimeRange.Start.getSWDate;
//  lblDateTo.Caption := MDateTimeRange.Stop.getSWDate;

  lblDateFromTitle.Caption := MDateTimeRange.Start.getSWDate;
  lblDateFromTitle.Caption := lblDateFromTitle.Caption + ' -- ' + MDateTimeRange.Stop.getSWDate;

  Application.ProcessMessages;
end;

procedure Tfrm_GridGraph.UpdateLists;
begin
  if (pos(MDateTimeRange.getSWRange,lbDateRange.Items.Text) = 0) then
    begin
      lbDateRange.Items.Add(MDateTimeRange.getSWRange);
      lbDateRange.ItemIndex := lbDateRange.Items.IndexOf(MDateTimeRange.getSWRange);
    end;
end;


procedure Tfrm_GridGraph.setGraphTitle(aFirst,aSecond: string);
begin
  chrtVitals.Title.Text.Clear;
  chrtVitals.Title.Text.Add(aFirst);
  chrtVitals.Title.Text.Add(aSecond);

  lblPatientName.Caption := aFirst;
  lblPatientInfo.Caption := aSecond;

  ptName := aFirst;
  ptInfo := aSecond;
end;

procedure Tfrm_GridGraph.ShowHideLabels(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to chrtVitals.SeriesCount - 1 do
    if chrtVitals.Series[i].Active then
      chrtVitals.Series[i].Marks.Visible := bLabelShow;
end;

function Tfrm_GridGraph.MetricValueString(_Row_:Integer;_Value_:String):String;
var
  s: String;
  f: Extended;
begin
  Result := '';
  s := piece(_Value_,' ');
  if pos('*',s)=Length(s) then s := copy(s,1,Length(s)-1);
  case _Row_ of
    1:try //Temperature
          f := StrToFloat(S);
          f := (f-32)/9*5;
          s := format('%-8.1f (C)',[f]);
          Result := s;
        except
        end;
    7:try //Weight
          f := StrToFloat(S);
          f := f*0.4535924;
          s := format('%-8.2f (kg)',[f]);
          Result := s;
      except
      end;
    9,10: try //Height, C/G
          f := StrToFloat(S);
          f := f*2.54;
          s := format('%-8.2f (cm)',[f]);
          Result := s;
      except
      end;
    else
      Result := '';
  end;
end;


procedure Tfrm_GridGraph.chrtVitalsClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: integer; Button: TMouseButton;
  Shift: TShiftState; x, Y: integer);
const
  NoData = 'NO DATA';
  iDate = 1;
  iTime = 2;
  iLocation = 22;
  iEnteredBy = 23;

var
  iCol,iRow:Integer;
  d: Double;
  sFrom,sTo,sFor:String;
  AllVitalsData,
  VitalsData: TStringList;
  MDT: TMDateTime;

  procedure SetVitalInfo(aRow:Integer);
  var
    sv: String;
    sName,
    sValue, sMetric: String;
  begin
    sName := grdVitals.Cells[0, aRow];
    if pos(':',sName) = length(sName) then   sName := copy(sName,1,Length(sName)-1);
    sV := grdVitals.Cells[iCol, aRow];
    if Trim(sV) <> '' then sValue := Trim(sV)
    else                   sValue := NoData;
    sMetric := MetricValueString(aRow,grdVitals.Cells[iCol, aRow]);

    VitalsData.Add('  Vital:' + #9 + sName);
    VitalsData.Add('  Value:' + #9 + sValue);
    if sMetric <> '' then  VitalsData.Add('        ' + #9 + sMetric);
    if aRow = 4 then       VitalsData.Add('        ' + #9 + grdVitals.Cells[iCol, 5]);
    VitalsData.Add('');
  end;

  function ConvertVitalsToText:String;
  var
    iVType,
    i: Integer;
    _S_,__S,s3,//AAN
    s1, s2: string;
    s,ss, sVType,
    sDate,sTime, sLocation,sEnteredBy, sOldInfo,sNewInfo,
    sTemp, sPulse,sResp,sBP,sPOx, sFive, sSix, sWt, sBMI,
    sHt, sGirth, sCVP, sIn, sOut,sPain:String;
  const
    CRLF = #13#10;
    TAB = char(VK_TAB);

    procedure AddValue(aLabel,aValue:String);
    begin
      if aValue <>'' then
        begin
          ss := ss + TAB+sTime + TAB + aLabel+Piece(aValue,' ',1)+TAB+piece(aValue,' ',2,99) + CRLF;
          sTime := TAB;
        end;
    end;

  begin
    sOldInfo := '';
    sNewInfo := '';
    s := '';
    ss := '';
    sDate := '';
    sTime := '';

    for i := 0 to  AllVitalsData.Count - 1 do
      begin
        s := AllVitalsData[i];
        s1 := s;
        _s_ := s;

        sDate := Piece(s,'^',iDate);
        sTime := Piece(s,'^',iTime);
//        if i = 0 then
//           ss := ss + sDate + CRLF;
        sLocation := Piece(s,'^',iLocation);
        sEnteredBy := Piece(s,'^',iEnteredBy);

        sNewInfo := '--------------- Location: '+ sLocation+ char(VK_TAB)+'  Entered By: '+sEnteredBy+' ---------------';
        if sNewInfo <> sOldInfo then
          begin
            ss := ss + CRLF + TAB+sNewInfo+CRLF;
            sOldInfo := sNewInfo;
          end;
//        ss := ss + TAB+sTime+CRLF;
//        ss := ss + TAB+sTime;
        sTemp := Piece(Piece(s, '^', 3), '-', 1) + Piece(Piece(s, '^', 3), '-', 2); //temperature

        s1 := Piece(Piece(s, '^', 4), '-', 1);
        s2 := Piece(Piece(s, '^', 4), '-', 2);

        while pos(' ',s2)=1 do  s2 := copy(s2,2,length(s2)-1);
        sPulse := s1 + ' ' +
                            Piece(s2, ' ', 1) + ' ' +
                            Piece(s2, ' ', 2) + ' ' +
                            Piece(s2, ' ', 3) + ' ' +
                            Piece(s2, ' ', 4);

        sResp := Piece(Piece(s, '^', 5), '-', 1) + Piece(Piece(s, '^', 5), '-', 2); // Respiratory
        // Pulse Oximetry
        s1 := Piece(Piece(s, '^', 6), '-', 1);//Value
        s2 := Piece(Piece(s, '^', 6), '-', 2);//Method
        s3 := Piece(Piece(s, '^', 6), '--',2);//
        sPOx := s1;//Moving qualifiers away
        __s := Piece(Piece(s, '^',6), '-', 3)+' / '+
               Piece(Piece(s,'^', 6), '-', 4); //Pox
        if __s = ' / ' then      sFive := s2
        else                     sFive := __s+ ' / '+s2;
        if sFive <> '' then sPOx := sPOx + ' '+sFive;
        s1 := Piece(Piece(s, '^', 7), '-', 1);
        s2 := Piece(Piece(s, '^', 7), '-', 2);
        sBP := s1 + ' ' + s2;

        sWt := Piece(Piece(s, '^', 8), '-', 1) + Piece(Piece(s, '^', 8), '-', 2);
        sBMI := Piece(Piece(s, '^', 10), '-', 1) + Piece(Piece(s, '^', 10), '-', 2);
        sHt := Piece(Piece(s, '^', 11), '-', 1) + Piece(Piece(s, '^', 11), '-', 2);
        sGirth := Piece(Piece(s, '^', 13), '-', 1) + Piece(Piece(s, '^', 13), '-', 2);
        sCVP := Piece(s, '^', 15);
        sIn := Piece(Piece(s, '^', 17), '-', 1);
        sOut := Piece(Piece(s, '^', 18), '-', 1);
        sPain := Piece(Piece(s, '^', 19), '-', 1);

        StripSpaces(sTemp);
        StripSpaces(sPulse);
        StripSpaces(sResp);
        StripSpaces(sPOx);
        StripSpaces(sBP);
        StripSpaces(sWt);
        StripSpaces(sBMI);
        StripSpaces(sHt);
        StripSpaces(sGirth);
        StripSpaces(sIn);
        StripSpaces(sOut);
        StripSpaces(sCVP);
        StripSpaces(sPain);

        AddValue('Temp.:'+ TAB,sTemp);
        AddValue('Pulse:'+ TAB,sPulse);
        AddValue('Resp.:'+ TAB,sResp);

        AddValue('POx.: '+ TAB,sPOx);
        AddValue('BP:   '+ TAB,sBP);

        AddValue('Wt:   '+ TAB,sWt);
        AddValue('Ht:   '+ TAB,sHt);
        AddValue('C/G.: '+ TAB,sGirth);
        AddValue('CVP:  '+ TAB,sCVP);
        AddValue('In:   '+ TAB,sIn);
        AddValue('Out:  '+ TAB,sOut);
        AddValue('Pain: '+ TAB,sPain);
      end;
    Result := ss;
  end;

begin
// The next line will scroll Vitals grid to the point selected
//  grdVitals.Col := ValueIndex + 1;  //!! No scrolling to the poin
//  grdVitals.Row := StrToIntDef(Series.Identifier, 1);

  iCol := ValueIndex + 1;  //!!
  iRow := StrToIntDef(Series.Identifier, 1);
  VitalsData := TStringList.Create;
  try
    VitalsData.Add('');
    sFor := piece(grdVitals.Cells[iCol, 0],' ',1);
//    VitalsData.Add('  Date:' + #9 + grdVitals.Cells[iCol, 0]);
    if cbxGraph.Items[GraphIndex] = sgnTRP then
      begin
        SetVitalInfo(1);
        SetVitalInfo(2);
        SetVitalInfo(3);
      end
    else if cbxGraph.Items[GraphIndex] = sgnHW then
      begin
        SetVitalInfo(7);
        SetVitalInfo(9);
      end
    else
      SetVitalInfo(iRow);

    {=== ALL VITALS for the day ===============================================}
    if cbChrono.Checked then d := Series.XValue[ValueIndex]
    else
      begin
        sFrom := grdVitals.Cells[ValueIndex+1,0];
        d := getCellDateTime(sFrom);
      end;
    mdt := TMDateTime.Create;
    mdt.WDateTime := trunc(d)+1/24/60/60;
    sFrom := mdt.getSMDate;
    sFor := mdt.getSWDate;
    mdt.WDateTime := d + 1 - 2/24/60/60;
    sTo := mdt.getSMDate;
    AllVitalsData := getALLPatientData(fPatientNumber,sFrom,sTo);
    VitalsData.Text := ConvertVitalsToText;
    AllVitalsData.Free;
{===============================================================================}
    ShowInfo('Vitals '+lblPatientName.Caption+' for '+sFor,VitalsData.Text);
    mdt.Free;
  finally
    FreeAndNil(VitalsData);
  end;
end;

procedure Tfrm_GridGraph.DrawMissingLines(aStartPoint,aStopPoint:Integer);
var
  rect, RectOld: TRect;
  x,y,
  i, j: integer;
  SeriesNumber: integer;
  FirstDataPoint,
  LastDataPoint  : integer;
  CurrentSeries: TChartSeries;
const
  iSize = 3;
begin
//Exit;

  RectOld := TCanvas(chrtVitals.Canvas).ClipRect;
  chrtVitals.Canvas.ClipRectangle(chrtVitals.chartRect);

  for SeriesNumber := 0 to chrtVitals.SeriesCount - 1 do
    if chrtVitals.Series[SeriesNumber].Active then
      begin
        CurrentSeries := chrtVitals.Series[SeriesNumber];
        if CurrentSeries.Count < 1 then Continue;
        FirstDataPoint :=0;
        LastDataPoint := CurrentSeries.Count-1;
        j := FirstDataPoint;
        for i := FirstDataPoint+1 to LastDataPoint do
          begin
            if not CurrentSeries.IsNull(i) then
              begin
                with chrtVitals.Canvas do
                  begin
                    Pen.Width := 2;
                    Pen.Color := CurrentSeries.SeriesColor;
{ }
                    if not chrtVitals.View3d then
                    case SeriesNumber of
                      0: begin
                        rect.left := CurrentSeries.CalcXPos(i)-iSize;
                        rect.Top := CurrentSeries.CalcYPos(i)-iSize;
                        rect.Right := CurrentSeries.CalcXPos(i)+iSize;
                        rect.Bottom := CurrentSeries.CalcYPos(i)+iSize;
                        Brush.Color := CurrentSeries.SeriesColor;
                        FillRect(rect);
                        end;
                      1:begin
                        rect.left := CurrentSeries.CalcXPos(i)-iSize;
                        rect.Top := CurrentSeries.CalcYPos(i)-iSize;
                        rect.Right := CurrentSeries.CalcXPos(i)+iSize;
                        rect.Bottom := CurrentSeries.CalcYPos(i)+iSize;
                        Brush.Color := CurrentSeries.SeriesColor;
                        Ellipse(rect.Left,rect.top,rect.right,rect.Bottom);
                        end;
                      2:begin
                        Polygon([
                          Point(CurrentSeries.CalcXPos(i)-iSize,CurrentSeries.CalcYPos(i)+iSize),
                          Point(CurrentSeries.CalcXPos(i)+iSize,CurrentSeries.CalcYPos(i)+iSize),
                          Point(CurrentSeries.CalcXPos(i),CurrentSeries.CalcYPos(i)-iSize)
                        ])
                      end;

                      3:begin
                        Polygon([
                          Point(CurrentSeries.CalcXPos(i)-iSize,CurrentSeries.CalcYPos(i)-iSize),
                          Point(CurrentSeries.CalcXPos(i)+iSize,CurrentSeries.CalcYPos(i)-iSize),
                          Point(CurrentSeries.CalcXPos(i),CurrentSeries.CalcYPos(i)+iSize)
                        ])
                      end;
                    end;
{}
                  // to avoid starting null on the screen
                  if {(j <> 0) or} not CurrentSeries.IsNull(j) then
                    begin
                      x := CurrentSeries.CalcXPos(j);
                      y := CurrentSeries.CalcYPos(j);
                      if chrtVitals.View3d then
                        begin
                          x := x + chrtVitals.Width3D ;
                          y := y + chrtVitals.Height3D div 2;
                        end;
                      MoveTo(x,y);
                      x := CurrentSeries.CalcXPos(i);
                      y := CurrentSeries.CalcYPos(i);
                      if chrtVitals.View3d then
                        begin
                          x := x + chrtVitals.Width3D;
                          y := y + chrtVitals.Height3D div 2;
                        end;
                      LineTo(x,y);
                    end;
                  end;
                j := i;
              end;
          end;
      end;
  chrtVitals.Canvas.ClipRectangle(RectOld);//Restore ClipRectangle
end;

procedure Tfrm_GridGraph.DrawMissingDataLines(Sender: TObject);
var
  FirstPointOnPage, LastPointOnPage: integer;
begin
  if chrtVitals.MaxPointsPerPage > 0 then
    begin
      FirstPointOnPage := (chrtVitals.Page - 1) * chrtVitals.MaxPointsPerPage;
      LastPointOnPage := (chrtVitals.Page * chrtVitals.MaxPointsPerPage) - 1;
    end
  else
    begin
      FirstPointOnPage := 0;
      LastPointOnPage := chrtVitals.Series[0].Count-1;
    end;
  DrawMissingLines(FirstPointOnPage,LastPointOnPage);
end;

procedure Tfrm_GridGraph.chrtVitalsAfterDraw(Sender: TObject);
begin
    DrawMissingDataLines(nil);
end;

procedure Tfrm_GridGraph.grdVitalsDrawCell(
  Sender: TObject;
  ACol, ARow: integer;
  Rect: TRect;
  State: TGridDrawState);

  function CurrentGraph:Boolean;
    begin
      case GraphIndex of
        0..3: Result := aRow = fGridRow;
        4: Result := (aRow = 4) or (aRow=5);
        5..8: Result := aRow = fGridRow;
        9:Result := (aRow = 7) or (aRow = 9);
        10: Result := (aRow = 1) or (aRow = 2) or (aRow=3);
      else
        Result := aRow = fGridRow;
      end;
    end;

var
  sToday,
  Value: string;
  TodayValue,
  AbnormalValue: Boolean;
begin

  sToday :=FormatDateTime('mm-dd-yy',Now);
  //with grdVitals do
  with TStringGrid(Sender) do
    begin
      Value := trim(Cells[ACol, ARow]);
      AbnormalValue := Pos('*', Value) > 0;

      TodayValue := piece(Cells[aCol,0],' ',1) = sToday;
      // Fill in background as btnFace, Abnormal, Normal
      if aRow > 14 then
            Canvas.Brush.Color := clBtnFace
      else if (ACol = 0) then
        begin
          if (aRow<>0) and
          CurrentGraph then
            Canvas.Brush.Color := clInfoBk
          else
            Canvas.Brush.Color := clSilver;// clBtnFace;
        end
      else if AbnormalValue then
        begin
          if TodayValue then
            Canvas.Brush.Color := DISPLAYCOLORS[GMVAbnormalTodayBkgd]
          else
            Canvas.Brush.Color := DISPLAYCOLORS[GMVAbnormalBkgd];
        end
      else
          if TodayValue then
            Canvas.Brush.Color := DISPLAYCOLORS[GMVNormalTodayBkgd]
          else
            if CurrentGraph then
              Canvas.Brush.Color := $00DFDFDF
            else
              Canvas.Brush.Color := bgColor; //DISPLAYCOLORS[GMVNormalBkgd];
//      Canvas.FillRect(Rect);
      Canvas.FrameRect(Rect);

      {
      // Draw rectangle around selected cell
      if (ACol > 0) and (ARow > 0) and (gdSelected in State) then
        begin
          if AbnormalValue then
            Canvas.Pen.Color := DISPLAYCOLORS[GMVAbnormalText]
          else
            Canvas.Pen.Color := DISPLAYCOLORS[GMVNormalText];
          Canvas.FrameRect(Rect);
        end;
      }

      // Set up font color as btnText, Abnormal, Normal
      if (ACol = 0) or (ARow = 0) then
        Canvas.Font.Color := clBtnText
      else if AbnormalValue then
        begin
          Canvas.Font.Color := DISPLAYCOLORS[GMVAbnormalText];
          if GMVAbnormalBold then
            Canvas.Font.Style := [fsBold]
          else
            Canvas.Font.Style := [];
        end
      else
        begin
          Canvas.Font.Color := DISPLAYCOLORS[GMVNormalText];
          if GMVNormalBold then
            Canvas.Font.Style := [fsBold]
          else
            Canvas.Font.Style := [];
        end;

      // Fill in the data
      if (ACol = 0) or (ARow = 0) then
        Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
      else if AbnormalValue then
        if GMVAbnormalQuals then
          Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
        else
          Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Piece(Value, ' ', 1))
      else if GMVNormalQuals then
        Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
      else
        Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Piece(Value, ' ', 1));

      if gdSelected in State then
        begin
//          Canvas.Brush.Color := clBlack;//vhaishandria 050705
          Canvas.Brush.Color := clRed;
          Canvas.FrameRect(Rect);
        end;
    end;
end;

function Tfrm_GridGraph.GraphNameByGridRow(aRow:Integer):String;
  begin
    case aRow of
      1: Result := sgnTemp;
      2: Result := sgnPulse;
      3: Result := sgnResp;
      4: Result := sgnPOX;
      5: Result := sgnPOX;
      6: Result := sgnBP;
      7: Result := sgnWeight;
      8: Result := sgnBMI;
      9: Result := sgnHeight;
      10: Result := sgnGirth;//GraphNameNoGraph;
      11: Result := sgnCVP; //GraphNameNoGraph;
      12: Result := sgnIn;//GraphNameNoGraph;
      13: Result := sgnOutput;//GraphNameNoGraph;
      14: Result := sgnPain;
    else
      Result := sGraphNameNoGraph;
    end;
//    if (Result <> sGraphNameNoGraph) then fGridRow := aRow;
  end;

function GraphIndexByGridRow(aRow:Integer):Integer;
begin
  case aRow of
    1: Result := 0;
    2: Result := 1;
    3: Result := 2;
    4: Result := 4;
    5: Result := 4;
    6: Result := 3;
    7: Result := 6;
    8: Result := 7;
    9: Result := 5;
    10: Result := 11;
    11: Result := 11;
    12: Result := 11;
    13: Result := 11;
    14: Result := 8;
  else
    Result := 11;
  end;
end;

procedure Tfrm_GridGraph.grdVitalsSelectCell(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, Y: integer);
var
  ACol, ARow: Longint;
  sName:String;
begin
  grdVitals.MouseToCell(x, Y, ACol, ARow);
  if (aCol = 0) then
    begin
{$IFDEF ALLSERIES}
      ActivateSeriesByGridRow(aRow);
      chrtVitals.Invalidate;
      fGraphIndex := GraphIndexByGridRow(aRow);
      grdVitals.Invalidate;
      Exit;
{$ENDIF}
      sName := GraphNameByGridRow(aRow);
      getGraphDataByName(sName);

      if GraphIndexByGridRow(aRow) <> 11 then
        GraphIndex := GraphIndexByGridRow(aRow)
      else
        fGraphIndex := 0;
      fGridRow := aRow;
      grdVitals.Invalidate;
    end;

  if (ACol > 0) and (ARow = 0) then
    try
      fSelectedDateTime := getCellDateTime(grdVitals.Cells[aCol, 0]);
      acEnteredInErrorByTimeExecute(nil);
    except
    end;
end;

procedure Tfrm_GridGraph.FrameResize(Sender: TObject);
var
  i,j: Integer;
begin
  if not FrameInitialized then Exit;
  j := 0;
  for i := 0 to grdVitals.RowCount - 1 do
    j := j + grdVitals.RowHeights[i]+1;
  pnlGrid.Height := j+8+pnlGridTop.Height;
end;

procedure Tfrm_GridGraph.setPatientLocation(aLocation: String);
begin
  FPatientLocation := aLocation;
end;

procedure Tfrm_GridGraph.setPatientLocationName(aLocationName: String);
begin
  FPatientLocationName := aLocationName;
  lblHospital.Caption := aLocationName;
end;

// Actions =====================================================================
procedure Tfrm_GridGraph.cbPeriodChange(Sender: TObject);
begin
end;
//=======================

procedure Tfrm_GridGraph.sbtnPrintGraphClick(Sender: TObject);
begin
  acPrintGraphExecute(Sender);
end;

procedure Tfrm_GridGraph.sbtnLabelsClick(Sender: TObject);
begin
  acValueCaptionsExecute(Sender);
end;

procedure Tfrm_GridGraph.sbtnMaxGraphClick(Sender: TObject);
begin
  acResizeGraphExecute(Sender);
end;

procedure Tfrm_GridGraph.cbChronoClick(Sender: TObject);
begin
  ChrtVitals.SeriesList[0].XValues.DateTime := cbChrono.Checked;
  ChrtVitals.SeriesList[1].XValues.DateTime := cbChrono.Checked;
  ChrtVitals.SeriesList[2].XValues.DateTime := cbChrono.Checked;
  GraphDataByIndex(GraphIndex);
  scbHGraphChange(trbHGraph);
  pnlGridResize(nil);
end;

procedure Tfrm_GridGraph.acCustomRangeExecute(Sender: TObject);
begin
  setObservationRange(sDateRange);
  UpdateLists;
end;

procedure Tfrm_GridGraph.acEnteredInErrorExecute(Sender: TObject);
begin
  if EnterVitalsInError(FPatientNumber) <> mrCancel then
    cbxDateRangeClick(nil);
end;

procedure Tfrm_GridGraph.acZoomExecute(Sender: TObject);
begin
  chrtVitals.AllowZoom := not chrtVitals.AllowZoom;
end;

procedure Tfrm_GridGraph.acGraphOptionsExecute(Sender: TObject);
begin
  pnlGraphOptions.Visible := not pnlGraphOptions.Visible;
end;

procedure Tfrm_GridGraph.acEnteredInErrorByTimeExecute(Sender: TObject);
begin
  if fSelectedDateTime = 0 then Exit;
  if EnteredInErrorByDate(FPatientNumber,
    trunc(fSelectedDateTime)+1-1/(3600*24)) <> mrCancel then
  cbxDateRangeClick(nil);
end;

procedure Tfrm_GridGraph.acPatientAllergiesExecute(Sender: TObject);
begin
  sbtnAllergies.Down := True;
  ShowPatientAllergies(FPatientNumber);
  sbtnAllergies.Down := False;
end;

procedure Tfrm_GridGraph.ColorSelect1Accept(Sender: TObject);
begin
  BGColor := ColorSelect1.Dialog.Color;
end;

procedure Tfrm_GridGraph.SetColor;
begin
  fBGColor := aColor;
    begin
      chrtVitals.Color := fBGColor;
 //     pnlRMargin.Color := fBGColor;
      trbHGraph.Invalidate;
      grdVitals.Invalidate;
    end;
end;

procedure Tfrm_GridGraph.sbGraphColorClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
    BGColor := ColorDialog1.Color;
end;

procedure Tfrm_GridGraph.acEnterVitalsExecute(Sender: TObject);
begin
  VitalsInputDLG(
     PatientNumber,
     PatientLocation,
     '', // Template
     '', // Signature
     getServerWDateTime,// select server date time  - vhaishandria 050419
     ptName,
     ptInfo
     ) ;

  UpdateFrame;
end;

procedure Tfrm_GridGraph.acValueCaptionsExecute(Sender: TObject);
begin
  bLabelShow := not bLabelShow;
  ShowHideLabels(Sender);
end;

procedure Tfrm_GridGraph.ac3DExecute(Sender: TObject);
begin
  chrtVitals.View3D := not chrtVitals.View3D;
end;

procedure Tfrm_GridGraph.acResizeGraphExecute(Sender: TObject);
begin
  MaximizeGraph(Sender);
end;

procedure Tfrm_GridGraph.PrintGraph(Sender: TObject);
begin
  with TPrintDialog.Create(Application) do
    try
      if Execute then
        begin
          chrtVitals.PrintProportional := True;
          chrtVitals.PrintMargins.Left := 1;
          chrtVitals.PrintMargins.Top := 1;
          chrtVitals.PrintMargins.Bottom := 1;
          chrtVitals.PrintMargins.Right := 1;
          chrtVitals.PrintResolution := -10;//-70;
          chrtVitals.BottomAxis.LabelsAngle := 0;
          chrtVitals.BackImageInside := False;
          chrtVitals.Print;
          chrtVitals.backimageinside := True;
          chrtVitals.BottomAxis.LabelsAngle := 90;
        end;
    finally
      free;
    end;
end;

procedure Tfrm_GridGraph.acPrintGraphExecute(Sender: TObject);
var
  b,bb:Boolean;
  TS: TStrings;

begin
  b := pnlGrid.Visible;
  splGridGraph.Align := alTop;
  bb := chrtVitals.Title.Visible;
  chrtVitals.Title.Visible := True;
  if b then pnlGrid.Visible := false;
  TS := TStringList.Create;
  TS.Add('');
  TS.Text := chrtVitals.Title.Text.Text;
  chrtVitals.Title.Text.Text := '';
  chrtVitals.Title.Text.ADD('Vitals Type: '+char(VK_TAB)+cbxGraph.Text+ '  for period '+lblDateFromTitle.Caption);
  chrtVitals.Title.Text.ADD('Patient: '+char(VK_TAB)+lblPatientName.Caption+ '   '+lblPatientInfo.Caption);
  chrtVitals.Title.Text.ADD('Hospital location: '+char(VK_TAB)+lblHospital.Caption+char(VK_TAB)+' '+FormatDateTime('"Printed:  " mm/dd/yyyy hh:nn:ss',Now));
  chrtVitals.Title.Text.ADD('*** Work copy only ***');
  PrintGraph(Sender);
  chrtVitals.Title.Text.Text := TS.Text;
  chrtVitals.Title.Visible := bb;
  TS.Free;
  pnlGrid.Visible := b;
  splGridGraph.Align := alBottom;
end;

procedure Tfrm_GridGraph.lbDateRangeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
      cbxDateRangeClick(lbDateRange);
end;

procedure Tfrm_GridGraph.SpeedButton1Click(Sender: TObject);
begin
  pnlDebug.Visible := not pnlDebug.Visible;
end;

////////////////////////////////////////////////////////////////////////////////

procedure Tfrm_GridGraph.SetUp;
begin
  if FrameInitialized then
    Exit;
  with grdVitals do
    begin
      RowCount := 15;
      DefaultRowHeight := 15;
      DefaultColWidth := 100;
      ColWidths[0] := 100;
      Cells[0, 1] := ' Temp:';
      Cells[0, 2] := ' Pulse:';
      Cells[0, 3] := ' Resp:';
      Cells[0, 4] := ' P Ox %:'; //AAN 2003/06/03
      Cells[0, 5] := ' L/Min/%:';
      Cells[0, 6] := ' B/P:';
      Cells[0, 7] := ' Wt (lbs):';
      Cells[0, 8] := ' BMI:';
      Cells[0, 9] := ' Ht (in):';
      Cells[0, 10] := ' C/G:';
      Cells[0, 11] := ' CVP (cmH2O):';
      Cells[0, 12] := ' In 24hr (c.c.):';
      Cells[0, 13] := ' Out 24hr (c.c.):';
      Cells[0, 14] := ' Pain:';
      Height := (DefaultRowHeight * RowCount) + (GridLineWidth * (RowCount+3)) + GetSystemMetrics(SM_CYVSCROLL);

      if FrameStyle <> fsVitals then
        pnlGrid.Height := pnlGridTop.Height +
          (DefaultRowHeight * RowCount) + (GridLineWidth * (RowCount+3)) + GetSystemMetrics(SM_CYVSCROLL);
      Invalidate;
    end;
  lbDateRange.Items.Add('TODAY');
  lbDateRange.Items.Add('T-1');
  lbDateRange.Items.Add('T-2');
  lbDateRange.Items.Add('T-3');
  lbDateRange.Items.Add('T-4');
  lbDateRange.Items.Add('T-5');
  lbDateRange.Items.Add('T-6');
  lbDateRange.Items.Add('T-7');
  lbDateRange.Items.Add('T-15');
  lbDateRange.Items.Add('T-30');
//  lbDateRange.Items.Add('Custom');  //vhaishandria 050420
  lbDateRange.Items.Add('Six Months');
  lbDateRange.Items.Add('One Year');
  lbDateRange.Items.Add('Two Years');
  lbDateRange.Items.Add(sDateRange);  //vhaishandria 050421

  cbxGraph.Items.Add(sgnTemp);
  cbxGraph.Items.Add(sgnPulse);
  cbxGraph.Items.Add(sgnResp);
  cbxGraph.Items.Add(sgnBP);
  cbxGraph.Items.Add(sgnPOX);
  cbxGraph.Items.Add(sgnHeight);
  cbxGraph.Items.Add(sgnWeight);
  cbxGraph.Items.Add(sgnBMI);
  cbxGraph.Items.Add(sgnPain);
  cbxGraph.Items.Add(sgnHW);
  cbxGraph.Items.Add(sgnTRP); //'TPR';
//  cbxGraph.Items.Add('Girth'); //'Pulse Ox.';

  iIgnoreCount := 0;

  FrameInitialized := True;
  bLabelSHow := False;
  GraphIndex := 1;
  cbxGraph.ItemIndex := 1;

  if Assigned(MDateTimeRange) then
    try
      lbDateRange.Items.Add(MDateTimeRange.getSWRange);
      lbDateRange.ItemIndex := lbDateRange.Items.IndexOf(MDateTimeRange.getSWRange);
    except
    end;

  fSelectedDateTime := 0;

  chrtVitals.Color := DISPLAYCOLORS[GMVNormalBkgd];
//  pnlRMargin.Color := DISPLAYCOLORS[GMVNormalBkgd];
end;

procedure Tfrm_GridGraph.SetStyle(aStyle:String);
begin
//  if aStyle = FStyle then Exit;

  chrtVitals.BottomAxis.Automatic := False;
  chrtVitals.BottomAxis.LabelsAngle := 0;
  // set layout
  splGridGraph.Align := alTop;
  pnlGrid.Align := alBottom;
  pnlGraph.Align := alClient;
  splGridGraph.Align := alBottom;

  pnlDateRangeTop.Visible := True;

  FStyle := aStyle;

  if aStyle = fsVitals then
    begin

      pnlGrid.Constraints.MaxHeight := (grdVitals.RowCount+1) * (grdVitals.RowHeights[0]+1)+
        + pnlGridTop.Height;

      pnlTitle.Visible := False;
//      pnlRMargin.Visible := False;
    end
  else   // CPRS
    begin
      pnlTitle.Visible := True;
      pnlDateRange.Visible := True;
    end;
end;

procedure Tfrm_GridGraph.sbStyleClick(Sender: TObject);
begin
  if FrameStyle <> fsVitals then    FrameStyle := fsVitals
  else                              FrameStyle := '';
end;

// Resizing ====================================================================

procedure Tfrm_GridGraph.MaximizeGraph(Sender: TObject);
begin
  pnlGrid.Visible := (pnlGrid.Visible = False);
  if fStyle = fsVitals then
    begin
      if pnlGrid.Visible then
        begin
          splGridGraph.Visible := True;
          splGridGraph.Align := alTop;
        end
      else
        begin
          splGridGraph.Visible := False;
          splGridGraph.Align := alBottom;
        end;
    end
  else
    begin
      if pnlGrid.Visible then
        begin
          splGridGraph.Visible := True;
          splGridGraph.Align := alBottom;
        end
      else
        begin
          splGridGraph.Visible := False;
          splGridGraph.Align := alTop;
        end;
    end;

end;

procedure Tfrm_GridGraph.pnlGridResize(Sender: TObject);
var
  i: Integer;
begin
  grdVitals.ColWidths[0] := pnlDateRange.Width;
  i := (grdVitals.Width - grdVitals.ColWidths[0]) div (grdVitals.ColWidths[1]);
  if not cbChrono.Checked then
    chrtVitals.MaxPointsPerPage := i;
end;

procedure Tfrm_GridGraph.chrtVitalsResize(Sender: TObject);
begin
  setGridLimits;
  setGridPosition(grdVitals.LeftCol-1);
end;

procedure Tfrm_GridGraph.Panel9Resize(Sender: TObject);
begin
  lblHospital.Width := panel9.Width - lblHospital.Left - 4;
  lblHospital.Height := panel9.Height - lblHospital.Top - 2;
end;

// Color frames ================================================================

procedure Tfrm_GridGraph.cbxGraphExit(Sender: TObject);
begin
  cbxGraph.Color := clTabOut;
end;

procedure Tfrm_GridGraph.cbxGraphEnter(Sender: TObject);
begin
  cbxGraph.Color := clTabIn;
end;

procedure Tfrm_GridGraph.lbDateRangeExit(Sender: TObject);
begin
  pnlPBot.Color := clbtnFace;
  pnlPTop.Color := clbtnFace;
  pnlPLeft.Color := clbtnFace;
  pnlPRight.Color := clbtnFace;
end;

procedure Tfrm_GridGraph.lbDateRangeEnter(Sender: TObject);
begin
  pnlPBot.Color := clTabIn;
  pnlPTop.Color := clTabIn;
  pnlPLeft.Color := clTabIn;
  pnlPRight.Color := clTabIn;
end;

procedure Tfrm_GridGraph.grdVitalsEnter(Sender: TObject);
begin
  pnlGBot.Color := clTabIn;
  pnlGTop.Color := clTabIn;
  pnlGLeft.Color := clTabIn;
  pnlGRight.Color := clTabIn;
end;

procedure Tfrm_GridGraph.grdVitalsExit(Sender: TObject);
begin
  pnlGBot.Color := clbtnFace;
  pnlGTop.Color := clbtnFace;
  pnlGLeft.Color := clbtnFace;
  pnlGRight.Color := clbtnFace;
end;

procedure Tfrm_GridGraph.chrtVitalsBeforeDrawSeries(Sender: TObject);
var
  li: LongInt;
  i: integer;
  iDelta,   ddd,
  iMin,iMax: LongInt;

  dBegin,dEnd: Double;

  function ValueDateTime(aCol:Integer):Double;
  var
    ss:String;
    dd: Double;
  begin
    try
      sS := grdVitals.Cells[aCol, rHeader];
      sS := ReplaceStr(ss,'-','/');
      if pos(' 24:',sS)>0 then
        ss := piece(ss,' ',1);
      dD := StrToDateTime(ss);
    except
      dd := Now;
    end;
    Result := dd;
  end;

begin
  if chrtVitals.View3D then exit;

  dBegin := ValueDateTime(grdVitals.LeftCol);
  dEnd := ValueDateTime(grdVitals.LeftCol+grdVitals.VisibleColCount-1);

  fXL := round(chrtVitals.BottomAxis.CalcPosValue(dBegin));
  fXR := round(chrtVitals.BottomAxis.CalcPosValue(dEnd));

  lblDate.Caption := grdVitals.Cells[grdVitals.LeftCol+grdVitals.VisibleColCount-1,0];
  lblPos.Caption := IntToStr(fXR);

  idelta := round(0.05*(chrtVitals.BottomAxis.Maximum-chrtVitals.BottomAxis.Minimum));
  if iDelta > 5 then iDelta := 5;

  with chrtVitals.Canvas do
    begin
      iMin := chrtVitals.ChartRect.Top+1;
      iMax := chrtVitals.ChartRect.Bottom-1;
      Pen.Color := clBlue;
      if fXL > chrtVitals.ChartRect.Left then
        begin
          MoveTo(fXL,iMin);
          LineTo(fXL,iMax);
        end;
      if fXR < chrtVitals.ChartRect.Right then
        begin
          MoveTo(fXR,iMin);
          LineTo(fXR,iMax);
        end;
      Brush.Color := clSilver;
      ddd := 0;
      FillRect(Rect(fXL+1+ddd,iMin,fXR+ddd,iMin+iDelta));
      FillRect(Rect(fXL+1+ddd,iMax-iDelta,fXR+ddd,iMax));
    end;
end;

//  Unknown ////////////////////////////////////////////////////////////////////

procedure Tfrm_GridGraph.lbDateRangeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cbxDateRangeClick(nil);
end;

procedure Tfrm_GridGraph.lbDateRangeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  i := Y div lbDateRange.ItemHeight + lbDateRange.TopIndex;
  if (i < lbDateRange.Items.Count) and (i>=0) then
    lbDateRange.Hint := lbDateRange.Items[i];
end;

procedure Tfrm_GridGraph.grdVitalsTopLeftChanged(Sender: TObject);
begin
  Inc(iIgnoreCOunt);
  trbHGraph.Position := grdVitals.LeftCol;
  CurrentPoint := grdVitals.LeftCol;
  chrtVitals.Invalidate;
  Dec(iIgnoreCOunt);
end;

function Tfrm_GridGraph.GridRowByGraphIndex(anIndex:Integer):Integer;
begin
  case anIndex of
    0: Result := 1;
    1: Result := 2;
    2: Result := 3;
    3: Result := 6;
    4: Result := 4;
    5: Result := 9;
    6: Result := 7;
    7: Result := 8;
    8: Result := 14;
  else
    if GraphIndex < 9 then
      Result := GridRowByGraphIndex(GraphIndex)
    else
      Result := 0;
  end;
end;


procedure Tfrm_GridGraph.SaveStatus;
var
  s: String;
  i: Integer;


  procedure SaveIntegerItem(aValue:Integer;aName:String);
  var
    s: String;
  begin
    try
      s := IntToStr(aValue);
      setUserSettings(aName,s);
    except
    end;
  end;

  procedure SaveBooleanItem(aValue:Boolean;aName:String);
  begin
    try
      if aValue then setUserSettings(aName,'ON')
      else           setUserSettings(aName,'OFF');
    except
    end;
  end;

begin
  try
    GMVUser.Setting[usGridDateRange] := IntToStr(lbDateRange.ItemIndex);
  except
  end;

  SaveIntegerItem(pnlGrid.Height,'GRIDSIZE');
  SaveIntegerItem(bgColor,'GRAPHCOLOR');

  SaveBooleanItem(pnlGridTop.Visible,'GRAPHCONTROL');
  SaveBooleanItem(pnlGraphOptions.Visible,'GRAPHOPTIONS');
  SaveBooleanItem(CheckBox1.Checked,'GRAPHOPTIONS-1');
  SaveBooleanItem(CheckBox2.Checked,'GRAPHOPTIONS-2');
  SaveBooleanItem(CheckBox3.Checked,'GRAPHOPTIONS-3');
  SaveBooleanItem(cbChrono.Checked,'GRAPHOPTIONS-4');

  SaveIntegerItem(GraphIndex,'GRAPH_INDEX');

end;

procedure Tfrm_GridGraph.RestoreStatus;
var
  s: String;
begin
  s := getUserSettings('GRIDSIZE');
  if s <> '' then pnlGrid.Height := StrToInt(s);

  s := getUserSettings('GRAPHCOLOR');
  if s <> '' then BGColor := StrToInt(s)
  else            BGColor := clWhite;

  s := getUserSettings('GRAPHCONTROL');
  pnlGridTop.Visible := s='ON';
  s := getUserSettings('GRAPHOPTIONS');
  pnlGraphOptions.Visible := s <> 'OFF';

  s := getUserSettings('GRAPHOPTIONS-1');
  CheckBox1.Checked := s='ON';
  s := getUserSettings('GRAPHOPTIONS-2');
  CheckBox2.Checked := s='ON';
  s := getUserSettings('GRAPHOPTIONS-3');
  CheckBox3.Checked := s='ON';
  s := getUserSettings('GRAPHOPTIONS-4');
  cbChrono.Checked := s='ON';

  s := getUserSettings('GRAPH_INDEX');
  if s <> '' then
      GraphIndex:= StrToInt(s)
  else
      GraphIndex:= 0;

  GridRow:= GridRowByGraphIndex(GraphIndex);
  grdVitals.Invalidate;
end;

procedure Tfrm_GridGraph.setGraphByABBR(aABBR:String);
var
  sName: String;
  aRow: Integer;
begin
  case VitalTypeByABBR(aABBR) of
    vtTemp:aRow := 1;
    vtPulse:aRow := 2;
    vtResp: aRow := 3;
    vtPO2: aRow := 4;
    vtBP: aRow := 6;
    vtHeight: aRow := 9;
    vtWeight: aRow := 7;
//    vtBMI: aRow := 8;
    vtPain: aRow := 14;
  else
    aRow := 0;
  end;

  getGraphDataByName(GraphNameByGridRow(aRow));
  if GraphIndexByGridRow(aRow) <> 11 then
  GraphIndex := GraphIndexByGridRow(aRow);
  fGridRow := aRow;
  grdVitals.Invalidate;
end;

end.

