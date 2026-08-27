unit mGMV_GridGraph;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 4 $  $Modtime: 7/21/05 4:45p $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Manages both tabular and graphical display of a patients
*                     vitals records.  Uses the TChart component which requires
*                     the Delphi DB components be on the palette as well.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsView/mGMV_GridGraph.pas $
*
* $History: mGMV_GridGraph.pas $
 *
 * *****************  Version 4  *****************
 * User: Vhaishandria Date: 7/22/05    Time: 3:51p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsView
 *
 * *****************  Version 3  *****************
 * User: Vhaishandria Date: 7/06/05    Time: 12:11p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsView
 *
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 6/03/05    Time: 6:02p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsView
 *
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 5:04p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsView
 *
*
================================================================================
}
interface

uses
  Windows,
  Messages,
  SysUtils,
  StrUtils,
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
  Menus, ActnList, ImgList, ComCtrls,
  uGMV_VitalTypes,  //kt added
  StdActns, TeEngine, Series, TeeProcs,
  mGMV_MDateTime
  ;

type
  TStringToDouble = Function(aString: String): Double;

  TfraGMV_GridGraph = class(TFrame)
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
    Panel9: TPanel;
    lblHospital: TLabel;
    Label6: TLabel;
    pnlActions: TPanel;
    sbEnterVitals: TSpeedButton;
    pnlGraphBackground: TPanel;
    chrtVitals: TChart;
    pnlGridTop: TPanel;
    Panel1: TPanel;
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
    cbValues: TCheckBox;
    ckb3D: TCheckBox;
    cbAllowZoom: TCheckBox;
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
    cbxGraph: TComboBox;
    SelectGraphColor1: TMenuItem;
    EnterVitals1: TMenuItem;
    Allergies1: TMenuItem;
    Panel4: TPanel;
    trbHGraph: TTrackBar;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    acZoomOut: TAction;
    acZoomIn: TAction;
    acZoomReset: TAction;
    pnlRight: TPanel;
    pnlDebug: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    ed: TEdit;
    pnlZoom: TPanel;
    sbPlus: TSpeedButton;
    sbMinus: TSpeedButton;
    sbReset: TSpeedButton;
    edZoom: TEdit;
    PrintDialog1: TPrintDialog;
    sbTest: TStatusBar;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series1: TLineSeries;
    acUpdateGridColors: TAction;
    UpdateGridColors1: TMenuItem;
    acPatientInfo: TAction;
    edPatientName: TEdit;
    edPatientInfo: TEdit;
    acVitalsReport: TAction;
    DebugLabel: TLabel;
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
    procedure acResizeGraphExecute(Sender: TObject);
    procedure acPrintGraphExecute(Sender: TObject);
    procedure acValueCaptionsExecute(Sender: TObject);
    procedure acEnterVitalsExecute(Sender: TObject);
    procedure ac3DExecute(Sender: TObject);
    procedure lbDateRangeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel9Resize(Sender: TObject);
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
    procedure lbDateRangeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chrtVitalsBeforeDrawSeries(Sender: TObject);
    procedure grdVitalsTopLeftChanged(Sender: TObject);
    procedure chrtVitalsClickLegend(Sender: TCustomChart;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure acZoomOutExecute(Sender: TObject);
    procedure acZoomInExecute(Sender: TObject);
    procedure acZoomResetExecute(Sender: TObject);
    procedure splGridGraphMoved(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure chrtVitalsDblClick(Sender: TObject);
    procedure acUpdateGridColorsExecute(Sender: TObject);
    procedure pnlPtInfoEnter(Sender: TObject);
    procedure pnlPtInfoExit(Sender: TObject);
    procedure acPatientInfoExecute(Sender: TObject);
    procedure acVitalsReportExecute(Sender: TObject);
    procedure pnlPtInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlPtInfoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    fXL,fXR: LongInt;                   // X coordinates of the Blue Lines
    FbgColor: TColor;                   // graph bg color
    FbgTodayColor: TColor;              // graph bg color

    FPatientDFN: string;                // parent copy to enter vitals, to retreive data
    ptName:String;
    ptInfo: String;

    FMDateTimeRange: TMDateTimeRange;   // parent copy to retreive data
    FObservationRange: String;          // string copy of the above

    FPatientLocation: String;           // parent copy to enter vitals
    FPatientLocationName:String;

    fCurrentGraph:String;

    fGridNameString:String;
    fGridRow:Integer;

    fGraphIndex:Integer;
    fFrameInitialized: Boolean;

    bLabelShow: Boolean;
    FStyle:String;                      // fsVitals or fsDLL

    FCurrentPoint: Integer;

    fSelectedDateTime:TDateTime;        // entered in error

    iIgnoreCount:Integer;
    iIgnoreGraph:Integer;

    fAxisMax,
    fAxisMin: Double;

    bIgnoreBlueLines: Boolean;
    FVitalsData : TVitalsData;  //kt  Will hold data for all vitals (prior to putting into grid)
    FGraphCombos: TGraphCombos;  //kt  Will hold selectable graph combos.

    procedure SetupVitalsInfo;  //kt added
    procedure SetupGraphCombos;  //kt added
    function MetricValueString(_Row_:Integer;_Value_:String):String;// AAN 06/24/2002
    procedure drawMissingDataLines(Sender: TObject);
    procedure drawMissingLines(aStartPoint,aStopPoint:Integer);
    procedure maximizeGraph(Sender: TObject);
    procedure printGraph(Sender: TObject);
    procedure setPatientDFN(const Value: string);
    procedure getVitalsData(aFrom,aTo:String);
    procedure GraphDataByIndex(anIndex:Integer);
    procedure getGraphByName(aName:String);
    procedure setGraphIndex(anIndex:Integer);

    procedure setStyle(aStyle:String);
    procedure setPatientLocation(aLocation:String);
    procedure setPatientLocationName(aLocationName:String);
    procedure setMDateTimeRange(aMDTR: TMDateTimeRange);

    procedure setTRP;
    procedure setBP;
    procedure setBPWeight;
    procedure setHW;

    procedure setSingleGraph(anIndex:Integer;aName:String;
      aConverter:TStringToDouble = nil);
    procedure setSingleVital(aRow:Integer;aSeria:Integer=0;aName:String='';
      aConverter:TStringToDouble = nil);
    procedure setSeriesAxis(TheSeries:Array of Integer);

    procedure setCurrentPoint(aValue: Integer);
    procedure setGridPosition(aPosition: Integer);

    procedure setObservationRange(aRange:String);
    procedure setTrackBarLimits;

    procedure updateLists;
    procedure setColor(aColor:TColor);
    procedure setTodayColor(aColor:TColor);

    function GraphNameByGridRow(aRow:Integer):String;
    function GridRowByGraphIndex(anIndex:Integer):Integer;

    procedure updateSB(aValue:String;Append:Boolean=False);
    function getDefaultGridPosition: Integer;

    procedure setPatientInfoView(aName,anInfo:String);
    function getPatientName:String;
    function getPatientInfo:String;

    function GridScrollBarIsVisible:Boolean;
    function getVisibleColCount:Integer;
  public
    PackageSignature: String;   //?
    InputTemplateName: String;

    procedure setGraphTitle(aFirst,aSecond: String);
    procedure updateTimeLabels;
    procedure updateFrame;

    procedure setUpFrame;
    procedure saveStatus;
    procedure restoreUserPreferences;
    function scrollbarIsVisible:Boolean;

    procedure setGraphByABBR(aABBR:String);

    procedure showVitalsReport;
    constructor Create;  //kt
    destructor Destroy;  override; //kt
  published
    property BGColor: TColor read fBGColor write SetColor;
    property BGTodayColor: TColor read fBGTodayColor write SetTodayColor;

    property FrameInitialized: Boolean  read FFrameInitialized write FFrameInitialized;
    property GraphIndex: Integer        read FGraphIndex write setGraphIndex; //needs update
    property FrameStyle: String         read FStyle write SetStyle; //CPRS or Vitals
    property PatientDFN: string      read FPatientDFN write SetPatientDFN;
    property PatientLocation: string    read FPatientLocation write SetPatientLocation;
    property PatientLocationName:string read FPatientLocationName write SetPatientLocationName;
    property MDateTimeRange: TMDateTimeRange read FMDateTimeRange write setMDateTimeRange;
    property CurrentPoint: Integer      read FCurrentPoint write setCurrentPoint;
    property ObservationRange: String   read FObservationRange write setObservationRange;
    property IgnoreCount: Integer read iIgnoreCount write iIgnoreCount;

    property GridRow: Integer read fGridRow write fGridRow;
    function GraphIndexByGridRow(aRow:Integer):Integer;
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
  , fGMV_PtInfo
//  , uGMV_VitalTypes
  , uGMV_Common
  , Math
  , Clipbrd, Printers, fGMV_SelectColor, fGMV_UserSettings
  ;

{$R *.DFM}


const
  rHeader = 0;
  rLocation = 1;    //elh  was 16
  rUser = 2;        //elh  was 15
  rTemp = 3;            //was 1
  rPulse = 4;           //was 2
  rResp = 5;            //was 3
  rPOx = 6;             //was 4
  rLPM = 7;         //elh
  rBP = 8;              //was 6
  rWeight = 9;          //was 7
  rBMI = 10;            //was 8
  rHeight = 11;         //was 9
  rGirth = 12;          //was 10
  rCVP = 13;             // was 11
  rIntake = 14;           // was 12
  rOutput = 15;          //was 13
  rPain = 16;            //was 14

  rWoundS1VA = 17;  //Added 15 sets of wound data  //elh 3/12/08
  rWoundS1HF = 18;
  rWoundS2VA = 19;
  rWoundS2HF = 20;
  rWoundS3VA = 21;
  rWoundS3HF = 22;
  rWoundS4VA = 23;
  rWoundS4HF = 24;
  rWoundS5VA = 25;
  rWoundS5HF = 26;
  rWoundS6VA = 27;
  rWoundS6HF = 28;
  rWoundS7VA = 29;
  rWoundS7HF = 30;
  rWoundS8VA = 31;
  rWoundS8HF = 32;
  rWoundS9VA = 33;
  rWoundS9HF = 34;
  rWoundS10VA = 35;
  rWoundS10HF = 36;
  rWoundS11VA = 37;
  rWoundS11HF = 38;
  rWoundS12VA = 39;
  rWoundS12HF = 40;
  rWoundS13VA = 41;
  rWoundS13HF = 42;
  rWoundS14VA = 43;
  rWoundS14HF = 44;
  rWoundS15VA = 45;
  rWoundS15HF = 46;  rMAX_ROW = 46   ;  //should be equal to last row in Grid //elh
  giTPR       = 47;    //Should = Index in Cbxgraph
  giBPW       = 48;    //Should = Index in Cbxgraph
  giHW        = 49;    //Should = Index in Cbxgraph

//  iIgnore = - 999999;

  // Graph names================================================================
  sgnNoGraph = 'No Graph';

  sgnTRP = 'TPR';
  sgnBP = 'B/P';
  sgnHW = 'Height/Weight';
  sgnPOX = 'Pulse Ox.';
  sgnBPWeight = 'B/P -- Weight';

  sgnTemp = 'Temperature';
  sgnPulse = 'Pulse';
  sgnResp = 'Respiration';
                        //    Cells[0, x] := ' P Ox %:'; //AAN 2003/06/03

  sgnWeight = 'Weight'; //    Cells[0, x] := ' Wt (lbs):';
  sgnBMI = 'BMI';       //    Cells[0, x] := ' BMI:';
  sgnHeight = 'Height'; //    Cells[0, x] := ' Ht (in):';
  sgnGirth = 'C/G';     //    Cells[0, x] := ' C/G:';
  sgnCVP = 'CVP';       //    Cells[0, x] := ' CVP (cmH2O):';
  sgnIn = 'Intake';     //    Cells[0, x] := ' In 24hr (c.c.):';
  sgnOutput = 'Output'; //    Cells[0, x] := ' Out 24hr (c.c.):';
  sgnPain = 'Pain';     //    Cells[0, x] := ' Pain:';

  //added //elh
  sgnDate = 'Date';
  sgnLoc = 'Location';
  sgnUser= 'User';
  sgnLPM = 'L/min';
  //Added three sets of wound data elh 3/12/08
  sgnVA1 = 'Vol/Area 1';
  sgnHF1 = 'HF% 1';
  sgnVA2 = 'Vol/Area 2';
  sgnHF2 = 'HF% 2';
  sgnVA3 = 'Vol/Area 3';
  sgnHF3 = 'HF% 3';
  sgnVA4 = 'Vol/Area 4';
  sgnHF4 = 'HF% 4';
  sgnVA5 = 'Vol/Area 5';
  sgnHF5 = 'HF% 5';
  sgnVA6 = 'Vol/Area 6';
  sgnHF6 = 'HF% 6';
  sgnVA7 = 'Vol/Area 7';
  sgnHF7 = 'HF% 7';
  sgnVA8 = 'Vol/Area 8';
  sgnHF8 = 'HF% 8';
  sgnVA9 = 'Vol/Area 9';
  sgnHF9 = 'HF% 9';
  sgnVA10 = 'Vol/Area 10';
  sgnHF10 = 'HF% 10';
  sgnVA11 = 'Vol/Area 11';
  sgnHF11 = 'HF% 11';
  sgnVA12 = 'Vol/Area 12';
  sgnHF12 = 'HF% 12';
  sgnVA13 = 'Vol/Area 13';
  sgnHF13 = 'HF% 13';
  sgnVA14 = 'Vol/Area 14';
  sgnHF14 = 'HF% 14';
  sgnVA15 = 'Vol/Area 15';
  sgnHF15 = 'HF% 15';

  cRowLabel : Array[0..46] of string[16] =(   //elh added
      sgnDate,                   //rHeader = 0;
      sgnLoc,                    //rLocation = 1;    //elh
      sgnUser,                   //rUser = 2;        //el
      sgnTemp,                   //rTemp = 3;
      sgnPulse,                  //rPulse = 4;
      sgnResp,                   //rResp = 5;
      sgnPOX,                    //rPOx = 6;
      sgnLPM,                    //rLPM = 7;         //el
      sgnBP,                     //rBP = 8;
      sgnWeight,                 //rWeight = 9;
      sgnBMI,                    //rBMI = 10;
      sgnHeight,                 //rHeight = 11;
      sgnGirth,                  //rGirth = 12;
      sgnCVP,                    //rCVP = 13;
      sgnIn,                     //rIntake = 14;
      sgnOutput,                 //rOutput = 15;
      sgnPain,                   //rPain = 16;
      sgnVA1,                    //rWoundS1VA = 17;  //Ad
      sgnHF1,                    //rWoundS1HF = 18;
      sgnVA2,                    //rWoundS2VA = 19;
      sgnHF2,                    //rWoundS2HF = 20;
      sgnVA3,                    //rWoundS3VA = 21;
      sgnHF3,                    //rWoundS3HF = 22;
      sgnVA4,                    //rWoundS4VA = 23;
      sgnHF4,                    //rWoundS4HF = 24;
      sgnVA5,                    //rWoundS5VA = 25;
      sgnHF5,                    //rWoundS5HF = 26;
      sgnVA6,                    //rWoundS6VA = 27;
      sgnHF6,                    //rWoundS6HF = 28;
      sgnVA7,                    //rWoundS7VA = 29;
      sgnHF7,                    //rWoundS7HF = 30;
      sgnVA8,                    //rWoundS8VA = 31;
      sgnHF8,                    //rWoundS8HF = 32;
      sgnVA9,                    //rWoundS9VA = 33;
      sgnHF9,                    //rWoundS9HF = 34;
      sgnVA10,                   //rWoundS10VA = 35;
      sgnHF10,                   //rWoundS10HF = 36;
      sgnVA11,                   //rWoundS11VA = 37;
      sgnHF11,                   //rWoundS11HF = 38;
      sgnVA12,                   //rWoundS12VA = 39;
      sgnHF12,                   //rWoundS12HF = 40;
      sgnVA13,                   //rWoundS13VA = 41;
      sgnHF13,                   //rWoundS13HF = 42;
      sgnVA14,                   //rWoundS14VA = 43;
      sgnHF14,                   //rWoundS14HF = 44;
      sgnVA15,                   //rWoundS15VA = 45;
      sgnHF15                    //rWoundS15HF = 46;
  );

  iMaximumLimit = 2000;

  sNoData = 'NO DATA';




////////////////////////////////////////////////////////////////////////////////

function BPMeanBP(aString:String):Double;
begin
  Result := BPMean(aString);
end;

function BPDias(aString:String):Double;
var
  s2,s3:String;

begin
  s2 := Piece(Piece(aString,'/',2),' ',1);
  s3 := Piece(Piece(aString,'/',3),' ',1);
  if s3 = '' then
    Result := iVal(s2)
  else
    Result := iVal(s3);
end;

function PainNo99(aString:String):Double;
begin
  if trim(aString) = '99' then
    Result := iIgnore
  else
    Result := iVal(aString);
end;

//////////////////////////////////////////////////////////////////////////////

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

function getBP(aString:String):String;
begin
  Result  := Piece(Piece(aString, '^', 7), '-', 1) + ' ' + Piece(Piece(aString, '^', 7), '-', 2);
end;

function getWeight(aString:String):String;
begin
  Result := Piece(Piece(aString, '^', 8), '-', 1) + Piece(Piece(aString, '^', 8), '-', 2);
end;

////////////////////////////////////////////////////////////////////////////////
procedure PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
var
  BitmapHeader:  pBitmapInfo;
  BitmapImage :  POINTER;
  HeaderSize  :  DWORD;    // Use DWORD for D3-D5 compatibility
  ImageSize   :  DWORD;
begin
  GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage,  ImageSize);
  try
    GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(Canvas.Handle,
                  DestRect.Left, DestRect.Top,     // Destination Origin
                  DestRect.Right  - DestRect.Left, // Destination Width
                  DestRect.Bottom - DestRect.Top,  // Destination Height
                  0, 0,                            // Source Origin
                  Bitmap.Width, Bitmap.Height,     // Source Width & Height
                  BitmapImage,
                  TBitmapInfo(BitmapHeader^),
                  DIB_RGB_COLORS,
                  SRCCOPY)
  finally
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  end
end {PrintBitmap};

procedure CPRSPrintGraph(GraphImage: TChart; PageTitle: string);
var
  AHeader: TStringList;
  i, y, LineHeight: integer;
  GraphPic: TBitMap;
  Magnif: integer;
const
  TX_FONT_SIZE = 12;
  TX_FONT_NAME = 'Courier New';
  CF_BITMAP = 2;      // from Windows.pas
begin
  ClipBoard;
  AHeader := TStringList.Create;
//  CreatePatientHeader(AHeader, PageTitle);
  aHeader.Text := PageTitle;
  GraphPic := TBitMap.Create;
  try
    GraphImage.CopyToClipboardBitMap;
    GraphPic.LoadFromClipBoardFormat(CF_BITMAP, ClipBoard.GetAsHandle(CF_BITMAP), 0);
    with Printer do
      begin
        Canvas.Font.Size := TX_FONT_SIZE;
        Canvas.Font.Name := TX_FONT_NAME;
//        Title := 'PageTitle;
        Title := aHeader[0];
        Magnif := ((Canvas.TextWidth(StringOfChar('=', 74))) div GraphImage.Width);
        LineHeight := Printer.Canvas.TextHeight(TX_FONT_NAME);
        y := LineHeight;
        BeginDoc;
        try
          for i := 0 to AHeader.Count - 1 do
            begin
              Canvas.TextOut(0, y, AHeader[i]);
              y := y + LineHeight;
            end;
          y := y + (4 * LineHeight);
          //GraphImage.PrintPartial(Rect(0, y, Canvas.TextWidth(StringOfChar('=', 74)), y + (Magnif * GraphImage.Height)));
          PrintBitmap(Canvas, Rect(0, y, Canvas.TextWidth(StringOfChar('=', 74)), y + (Magnif * GraphImage.Height)), GraphPic);
        finally
          EndDoc;
        end;
      end;
  finally
    ClipBoard.Clear;
    GraphPic.Free;
    AHeader.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

constructor TfraGMV_GridGraph.Create;  //kt
begin
  //FVitalsData := TVitalsData.Create;
  //FGraphCombos:= TGraphCombos.Create;
end;

destructor TfraGMV_GridGraph.Destroy;  //kt
begin
  //FVitalsData.Destroy;  //will free owned objects
  //FGraphCombos.Destroy;  //will free owned objects
end;

procedure TfraGMV_GridGraph.SetupVitalsInfo;  //kt
//Note: This is essentially a display template.  In the future, this could be
//      obtained from the server, to allow server to add new displayed vitals
//      in the future.
var i : integer;
begin
  FVitalsData.Clear;
//'DataPiece^DisplaySeq^NumDataValues^DataDelim^DesiredSubPiece^GridLabel^AbbrevLabel^HideIfEmpty^HeaderColor^Graphable'
  FVitalsData.AddRowFromStr('3^^^^^Temperature^Temp^^^^45^110');
  FVitalsData.AddRowFromStr('4^^^^^Pulse^Pulse^^^^0^300');
  FVitalsData.AddRowFromStr('5^^^^^Respiration^Resp^^^^70^200');
  FVitalsData.AddRowFromStr('6^^^--^1^Pulse Oximetry^pOx^^^^0^100');
  FVitalsData.AddRowFromStr('6^^^--^2^L/min^L/m^^^^0^100');
  FVitalsData.AddRowFromStr('7^^2^/^^Blood Pressure^BP^^^^0/0^300/200');
  FVitalsData.AddRowFromStr('8^^^^^Weight (lbs)^Wt (lbs)^^^^0^1500');
  //FVitalsData.AddRowFromStr('9^^^^^Weight (kgs)^Wt (kgs)^^^^0^680');
  FVitalsData.AddRowFromStr('10^^^^^Body Mass Index^BMI^^^^0^500');
  FVitalsData.AddRowFromStr('11^^^^^Height (in)^Ht (in)^^^^0^100');
  //FVitalsData.AddRowFromStr('12^^^^^Height (cm)^Ht (cm)^^^^0^254');
  FVitalsData.AddRowFromStr('13^^^^^Circum Girth (in)^C/G (in)^1^^^1^200');
  //FVitalsData.AddRowFromStr('14^^^^^Circum Girth (cm)^C/G (cm)^1');
  FVitalsData.AddRowFromStr('15^^^^^Central Venous Pressure (cmH20)^CVP (cmH2O)^1^^^-13.6^136');
  //FVitalsData.AddRowFromStr('16^^^^^Central Venous Pressure (mmHg)^CVP (mmHg)^1');
  FVitalsData.AddRowFromStr('17^^^^^Intake 24h (cc)^In 24h (cc)^1^^^0^20000');
  FVitalsData.AddRowFromStr('18^^^^^Output 24h (cc)^Out 24h (cc)^1^^^0^40000');
  FVitalsData.AddRowFromStr('19^^^^^Pain^Pain^^^^0^10');
  for i := 0 to 14 do begin
    FVitalsData.AddRowFromStr(IntToStr(24+i*3)+'^^3^x^^Wound Size '+IntToStr(i+1)+'^W Size '+IntToStr(i+1)+'^1^^^0x0x0^200x200x200');
    FVitalsData.AddRowFromStr(IntToStr(25+i*3)+'^^2^/^^Vol/Area '+IntToStr(i+1)+'^W V/A '+IntToStr(i+1)+'^1^^^0^30000');
    FVitalsData.AddRowFromStr(IntToStr(26+i*3)+'^^^^^Wound Healing% '+IntToStr(i+1)+'^W H% '+IntToStr(i+1)+'^1^^^0^100');
  end;
end;

procedure TfraGMV_GridGraph.SetupGraphCombos;  //kt added
//Note: This is essentially a display template.  In the future, this could be
//      obtained from the server, to allow server to add new displayed vitals
//      in the future.
var OneRow : TVitalRow;
    i : integer;
begin
  FGraphCombos.Clear;
  //Add combo graph options-----------------------
  FGraphCombos.AddCombo('TPR','3^4^5',FVitalsData);
  FGraphCombos.AddCombo('Height/Weight','11^8',FVitalsData);
  //FGraphCombos.AddCombo('Height/Weight metric','12^9',FVitalsData);
  FGraphCombos.AddCombo('B/P, Weight','7^8',FVitalsData);
  //FGraphCombos.AddCombo('B/P, Weight metric','7^9',FVitalsData);
  FGraphCombos.AddCombo('pOx, L/M','6;1^6;2',FVitalsData);
  //Add all individual vitals to graph options-----------------
  for i := 0 to FVitalsData.Count-1 do begin
    OneRow := FVitalsData.Item(i);
    FGraphCombos.AddCombo(OneRow.GridLabel,IntToStr(OneRow.DataPiece),FVitalsData);
  end;
  //COMPLETE
  //These options would been to be loaded into ComboBox for selection
end;

procedure TfraGMV_GridGraph.acPrintGraphExecute(Sender: TObject);
var
  bGrid,
  b,bb:Boolean;
  TS: TStrings;
  sName,sInfo,
  sPatient,sLocation,sPrinted,sLabel,sType,sPeriod,
  ss,sss: String;
  i,iLen: Integer;
begin
  if not PrintDialog1.Execute then Exit;

  b := bIgnoreBlueLines;
  bIgnoreBlueLines := true;
  iLen := 74;

  sLocation := 'Hospital location: '+lblHospital.Caption;
  sName := getPatientName;
  sInfo := getPatientInfo;

  sPatient := sName
    + StringOfChar(' ',iLen -1 - Length(sName) - Length(sInfo)) + sInfo;
  sPrinted := 'Printed On: ' + FormatDateTime('mmm dd, yyyy  hh:nn', Now);
  sLabel := ' WORK COPY ONLY ';

  while Length(sLabel) < iLen do sLabel := '*'+sLabel +'*';
  sLabel := copy(sLabel,1,ilen-1);

  sPeriod := 'Period: '+lblDateFromTitle.Caption;
  sType := 'Vitals Type: '+cbxGraph.Text;
  sss := '';
  for i := 1 to Length(sPeriod) do
    begin
      if Copy(sPeriod,i,1) = '/' then sss := sss + '-'
      else sss := sss + Copy(sPeriod,i,1);
    end;
  sPeriod := sss;
  sss := '';
  ss := sType + sPeriod;

  while Length(ss) < iLen-1 do
    begin
      sss := sss + ' ';
      ss := sType + sss + sPeriod;
    end;

  ss :=
    ss + #13 +
    sPatient + #13 +
    sLabel +  #13 +
    sLocation + StringOfChar(' ', iLen - Length(sPrinted+sLocation)-1) + sPrinted+#13
    ;

  ChrtVitals.Invalidate;
  Application.ProcessMessages;


  bGrid := pnlGrid.Visible;
  splGridGraph.Align := alTop;
  if bGrid then pnlGrid.Visible := false;

  CPRSPrintGraph(ChrtVitals,ss);

  pnlGrid.Visible := bGrid;
  splGridGraph.Align := alBottom;

  bIgnoreBlueLines := b;
  ChrtVitals.Invalidate;
  Application.ProcessMessages;
  Exit;

  b := pnlGrid.Visible;
  splGridGraph.Align := alTop;
  bb := chrtVitals.Title.Visible;
  chrtVitals.Title.Visible := True;
  if b then pnlGrid.Visible := false;
  TS := TStringList.Create;
  TS.Add('');
  TS.Text := chrtVitals.Title.Text.Text;
  chrtVitals.Title.Text.Text := '';
  chrtVitals.Title.Text.ADD('Vitals Type: '+{char(VK_TAB)+}cbxGraph.Text+ '  for period '+lblDateFromTitle.Caption);
  chrtVitals.Title.Text.ADD('Patient: '+{char(VK_TAB)+}sName+ '   '+sInfo);
  chrtVitals.Title.Text.ADD('Hospital location: '+{char(VK_TAB)+}lblHospital.Caption+{char(VK_TAB)+}' '+FormatDateTime('"Printed:  " mm/dd/yyyy hh:nn:ss',Now));
  chrtVitals.Title.Text.ADD('*** Work copy only ***');
  PrintGraph(Sender);
  chrtVitals.Title.Text.Text := TS.Text;
  chrtVitals.Title.Visible := bb;
  TS.Free;
  pnlGrid.Visible := b;
  splGridGraph.Align := alBottom;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.GetVitalsData(aFrom,aTo:String);
var
  VMEntry: TStringlist;

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

  procedure PopulateGrid;
  var
    i, c, j, e: integer;
    k : integer; //elh
    tempS : string; //elh
    _S_,__S,s3,
    s1, s2: string;
  begin
    with grdVitals do begin
      c := 1;
      ColCount := VMEntry.Count + 1;

      for i := VMEntry.Count - 1 downto 0 do begin


        //THE FOLLOWING LINE IS FOR TESTING ONLY. KILL THIS   elh
        //VMEntry[i] := VMEntry[i] + '^21^15^19';
        messagedlg(VMEntry[i],mtInformation ,mbOKCancel ,0); //kt
        //END KILL
        //FVitalsData.AddVitalSet(VMEntry[i]);  //kt

        s1 := VMEntry[i];
        _s_ := VMEntry[i];

        Cells[c, rHeader] := getDateTime(_s_);    //elh changed 0 --> rHeader
        //messagedlg('Putting Header At ' + inttostr(rLocation),mtInformation,mbOKCancel,0);
        Cells[c, rLocation] := Piece(VMEntry[i], '^', 22);              //elh changed 15 --> rLocation
        Cells[c, rUser] := Piece(VMEntry[i], '^', 23);                  //elh changed 16 --> rUser
        Cells[c, rTemp] := getTemperature(_s_);   //elh changed 1 --> rTemp
        Cells[c, rPulse] := getPulse(_s_);        //elh changed 2 --> rPulse
        Cells[c, rResp] := getRespiration(_s_);   //elh changed 3 --> rResp

        // Pulse Oximetry
        s1 := Piece(Piece(VMEntry[i], '^', 6), '-', 1);//Value
        s2 := Piece(Piece(VMEntry[i], '^', 6), '-', 2);//Method
        s3 := Piece(Piece(VMEntry[i], '^', 6), '--',2);//
        Cells[c, rPOx] := s1;//Moving qualifiers away   //elh changed 4 --> rPOx

        __s := Piece(Piece(VMEntry[i], '^',6), '-', 3)+' / '+
               Piece(Piece(VMEntry[i],'^', 6), '-', 4); //Pox
        if __s = ' / ' then
          Cells[c, rLPM] := s2               //elh changed 5 --> rLPM
        else
          Cells[c, rLPM] := __s+ ' / '+s2;   //elh changed 5 --> rLPM

//            s1 := Piece(Piece(VMEntry[i], '^', 7), '-', 1);
//            s2 := Piece(Piece(VMEntry[i], '^', 7), '-', 2);
//            Cells[c, 6] := s1 + ' ' + s2;
        Cells[c, rBP] := getBP(_s_);    //elh changed 6 --> rBP

//            Cells[c, 7] := Piece(Piece(VMEntry[i], '^', 8), '-', 1) +
//                           Piece(Piece(VMEntry[i], '^', 8), '-', 2);
        Cells[c, rWeight] := getWeight(_s_);   //elh changed 7 --> rWeight

        Cells[c, rBMI] := Piece(Piece(VMEntry[i], '^', 10), '-', 1)    //elh changed 8 --> rBMI
                     + Piece(Piece(VMEntry[i], '^', 10), '-', 2);
        Cells[c, rHeight] := Piece(Piece(VMEntry[i], '^', 11), '-', 1) //elh changed 9 --> rHeight
                     + Piece(Piece(VMEntry[i], '^', 11), '-', 2);
        Cells[c, rGirth] := Piece(Piece(VMEntry[i], '^', 13), '-', 1)   //elh changed 10 --> rGirth
                      + Piece(Piece(VMEntry[i], '^', 13), '-', 2);
        Cells[c, rCVP] := Piece(VMEntry[i], '^', 15);                   //elh changed 11 --> rCVP
        Cells[c, rIntake] := Piece(Piece(VMEntry[i], '^', 17), '-', 1); //elh changed 12 --> rIntake
        Cells[c, rOutput] := Piece(Piece(VMEntry[i], '^', 18), '-', 1); //elh changed 13 --> rOutput
        Cells[c, rPain] := Piece(Piece(VMEntry[i], '^', 19), '-', 1);   //elh changed 14 --> rPain


        for j := 0 to 14 do begin  //elh added block
          tempS := Piece(VMEntry[i], '^', 24+(3*j), 26+(3*j) );
          //messagedlg(tempS,mtInformation,mbOKCancel,0);
          Cells[c,rWoundS1VA+(2*j)] := Piece(tempS, '^', 2);
          Cells[c,rWoundS1HF+(2*j)] := Piece(tempS, '^', 3);
        end;

        for j := 0 to rMAX_ROW do                     //AAN 07/11/2002  //elh changed 14 -- rMAX_ROW
          if pos('Unavail',Cells[c,j]) <> 0  then     //AAN 07/11/2002
            Cells[c,j] := 'Unavailable';              //AAN 07/11/2002

        inc(c);
      end;

      Col := ColCount - 1;
      Row := 1;
    end;
  end;

begin
  //SetupVitalsInfo;   //kt   could probably move to someplace where not called repeatedly.
  //SetupGraphCombos;  //kt

  if not Assigned(MDateTimeRange)
    or (MDateTimeRange.getSWRange = '')
    or (FPatientDFN = '') then Exit;

  try
    CleanUpGrid;
    VMEntry := getAllPatientData(FPatientDFN,aFrom,aTo);

    if VMEntry.Count > 0 then
      begin
        PopulateGrid;
      end;
    GrdVitals.Refresh;
    GrdVitals.Repaint;
  finally
    VMEntry.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.setSeriesAxis(TheSeries:Array of Integer);
var
  i: Integer;
  dXMin,dXMax,
  dMax,dMin,dDelta: Double;

  function LocalMin(aSeries:TChartSeries): Double;
  var
    j: Integer;
    LM: Double;
    flag: Boolean;
  begin
    LM := 500;
    flag := false;
    for j := 0 to aSeries.Count - 1 do
      if aSeries.YValue[j] = 0 then continue
      else
        begin
          LM := min(LM,aSeries.YValues[j]);
          flag := True;
        end;
    if Flag then
      Result := LM
    else
      Result :=0;
  end;

  function LocalXMin(aSeries:TChartSeries): Double;
  var
    j: Integer;
    LM: Double;
  begin
    LM := Now;
    for j := 0 to aSeries.Count - 1 do
      if aSeries.XValue[j] = 0 then continue
      else LM := min(LM,aSeries.XValues[j]);
    Result := LM
  end;

begin
  if chrtVitals.LeftAxis.Minimum > 0 then chrtVitals.LeftAxis.Minimum := 0;

  dMax := chrtVitals.Series[Low(TheSeries)].MaxYValue;
  dXMax := chrtVitals.Series[Low(TheSeries)].MaxXValue;
  dXMin := LocalXMin(chrtVitals.Series[Low(TheSeries)]);

  if cbChrono.Checked then dMin := chrtVitals.Series[Low(TheSeries)].MinYValue
  else                     dMin := LocalMin(chrtVitals.Series[Low(TheSeries)]);

  for i := Low(TheSeries) to High(TheSeries) do
    begin
      if not chrtVitals.Series[Theseries[i]].Active then Continue;
      dMax := Max(dMax,chrtVitals.Series[Theseries[i]].MaxYValue);
      if cbChrono.Checked then
        dMin := Min(dMin,chrtVitals.Series[i].MinYValue)
      else
        dMin := Min(dMin,LocalMin(chrtVitals.Series[i]));

      dXMax := Max(dXMax,chrtVitals.Series[Theseries[i]].MaxXValue);
      dXMin := Min(dXMin,LocalXMin(chrtVitals.Series[Theseries[i]]));

    end;

  dDelta := 0.05*(dMax - dMin);
  dDelta := max(dDelta,0.05*dMax);
  if dDelta = 0 then dDelta := 1
  else if dDelta < 0 then dDelta := - dDelta;

  try
    chrtVitals.LeftAxis.Automatic := False;
    if dMax+dDelta < chrtVitals.LeftAxis.Minimum then
      begin
        chrtVitals.LeftAxis.Minimum := dMin-dDelta;
        chrtVitals.LeftAxis.Maximum := dMax+dDelta;
      end
    else
      begin
        chrtVitals.LeftAxis.Maximum := dMax+dDelta;
        chrtVitals.LeftAxis.Minimum := dMin-dDelta;
      end;

    fAxisMax := dMax+dDelta;
    fAxisMin := dMin-dDelta;

  except
    on E: Exception do
      ShowMessage('(2) Set Series Axis error:'+#13#10+E.Message);
  end;

  try
    if dXMax < dXMin then  dXMax := dXMin;

    chrtVitals.BottomAxis.Automatic := False;
    if chrtVitals.BottomAxis.Maximum < trunc(dXMax+1) then
      chrtVitals.BottomAxis.Maximum := trunc(dXMax+1)
    else
      if dXMax < chrtVitals.BottomAxis.Minimum then
        begin
          chrtVitals.BottomAxis.Minimum := trunc(dXMin);
          chrtVitals.BottomAxis.Maximum := trunc(dXMax+1);
        end
      else
        begin
          chrtVitals.BottomAxis.Maximum := trunc(dXMax+1);
          chrtVitals.BottomAxis.Minimum := trunc(dXMin);
        end;

    if chrtVitals.BottomAxis.Minimum = 0 then
      chrtVitals.BottomAxis.Minimum := trunc(dXMin);

  except
    on E: Exception do
      ShowMessage('(3) Set Series Axis error:'+#13#10+E.Message);
  end;

  chrtVitals.BottomAxis.ExactDateTime := True;// 051031 vhaishandria
  chrtVitals.BottomAxis.Increment := DateTimeStep[dtOneMinute];// 051031 vhaishandria

end;

procedure TfraGMV_GridGraph.setSingleVital(aRow:Integer;aSeria:Integer=0;aName:String='';
      aConverter:TStringToDouble = nil);
var
  gCol: integer;
  dValue: Double;
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
//  chrtVitals.BottomAxis.Visible := True; // vhaishandria 060123
  chrtVitals.LeftAxis.Automatic := False;
  try
    if 0 < chrtVitals.LeftAxis.Maximum then chrtVitals.LeftAxis.Minimum := 0;
    chrtVitals.LeftAxis.Maximum := 500;
  except
    On E: Exception do
      ShowMessage('Set Single Vital'+#13+E.Message);
  end;

  chrtVitals.Series[aSeria].Clear;

 // messagedlg('Here',mtInformation,mbOKCancel ,0);
  if aName = '' then chrtVitals.Series[aSeria].Title := grdVitals.Cells[0,aRow]
  else               chrtVitals.Series[aSeria].Title := aName;
//messagedlg('Here Again',mtInformation,mbOKCancel ,0);

  chrtVitals.Series[aSeria].Identifier := IntToStr(aRow);

  gCol := 1;
  with grdVitals do
    while (Cells[gCol, rHeader] <> '') and (gCol < ColCount) do
      begin
        try
          d := ValueDateTime(gCol);

          if cbChrono.Checked then
            begin
              if HasNumericValue(Cells[gCol, aRow]) then
                begin
                  if assigned(aConverter) then dValue := aConverter(Cells[gCol, aRow])
                  else dValue := dVal(Cells[gCol, aRow],grdVitals.Cells[gCol, rHeader]);

                  if dValue <> iIgnore then
                    chrtVitals.Series[aSeria].AddXY(d,dValue, SeriesLabel(Cells[gCol, rHeader]), clTeeColor);
                end
{$IFDEF LINES}
              else
                chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]));
{$ENDIF}
                ;
            end
          else
            begin
              if assigned(aConverter) then dValue := aConverter(Cells[gCol, aRow])
              else dValue := dVal(Cells[gCol, aRow],grdVitals.Cells[gCol, rHeader]);

              if dValue <> iIgnore then
                begin
                  if HasNumericValue(Cells[gCol, aRow]) then
                    begin
                      chrtVitals.Series[aSeria].Add(dValue, SeriesLabel(Cells[gCol, rHeader]), clTeeColor);
                    end
                  else
                    chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]));

                end
              else // we can not just delete 99 for pain
                  chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]))
            end;
        except
            chrtVitals.Series[aSeria].AddNull(SeriesLabel(Cells[gCol, rHeader]));
        end;
        inc(gCol);
      end;

  setSeriesAxis([aSeria]);

  try
    if aRow = rPain then chrtVitals.LeftAxis.Minimum := -0.5;
    if aRow = rPain then chrtVitals.LeftAxis.Maximum := 12;
  except
    on E: Exception do
      ShowMessage('Pain setup error:'+#13#10+E.Message);
  end;

  chrtVitals.Series[aSeria].Active := True;

  try
    if (grdVitals.ColCount = 2) and
      ((pos(sNoData,grdVitals.Cells[1,0]) = 1)
        or
       (trim(grdVitals.Cells[1,aRow])='')
      ) then
     chrtVitals.Series[aSeria].Active := False;
  except
  end;

end;

procedure TfraGMV_GridGraph.setHW;
begin
  SetSingleVital(rHeight,0,'Height');
  SetSingleVital(rWeight,1,'Weight');
  setSeriesAxis([0,1]);
end;

procedure TfraGMV_GridGraph.setTRP;
begin
  SetSingleVital(rTemp,0,'Temp.');
  SetSingleVital(rPulse,1,'Pulse');
  SetSingleVital(rResp,2,'Resp.');
  setSeriesAxis([0,1,2]);
end;

procedure TfraGMV_GridGraph.setBP;
begin
  SetSingleVital(rBP,0,'Sys.');
  SetSingleVital(rBP,1,'Dias.',BPDias);
  setSeriesAxis([0,1]);

//  SetSingleVital(rBP,1,'Mean',BPMeanBP);
//  SetSingleVital(rBP,2,'Dias.',BPDias);
//  setSeriesAxis([0,1,2]);
end;

procedure TfraGMV_GridGraph.setBPWeight;
begin
  SetSingleVital(rBP,0,'Sys.');
  SetSingleVital(rBP,1,'Dias.',BPDias);
  SetSingleVital(rWeight,2,'Weight');
  setSeriesAxis([0,1,2]);
end;

procedure TfraGMV_GridGraph.setSingleGraph(anIndex:Integer;aName:String;
      aConverter:TStringToDouble = nil);
begin
  SetSingleVital(anIndex,0,aName,aConverter);
//  setSeriesAxis([0]);   // vhaishandria 051203
end;

//==============================================================================
//==============================================================================
//==============================================================================

function TfraGMV_GridGraph.getDefaultGridPosition: Integer;
var
  i: Integer;
begin
  i := (grdVitals.Width - grdVitals.ColWidths[0]) div grdVitals.ColWidths[1];
  i := grdVitals.ColCount - i;

  // vhaishandria 051205 - Sorry for the patch
  if (FrameStyle=fsVitals) then
    i := i - 1;

  if i < 1 then i := 1;
  Result := i;
end;

procedure TfraGMV_GridGraph.getGraphByName(aName:String);
var
  intWoundNumber: integer;
  function DataFound:Boolean;
  var
    b: Boolean;
    i: integer;

  begin
    DataFound := False;
    for i := 1 to grdVitals.ColCount - 1 do
      begin
        if Trim(grdVitals.Cells[i,fGridRow]) ='' then continue;
        DataFound := True;
        Break;
      end;
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
            Series[j].Marks.Visible := cbValues.Checked;
          end;
      end;
  end;

begin
  acGraphButtons.Enabled := True;
  acResizeGraph.Enabled := True;

  if FPatientDFN = '' then  Exit;

  if (aName = sgnNoGraph)
  or (aName = sgnGirth) then
    begin
      chrtVitals.Visible := False;
      acGraphButtons.Enabled := False;
      acResizeGraph.Enabled := False;
      if not pnlGrid.Visible then MaximizeGraph(nil);
      if aName = sgnNoGraph then
        pnlGraphBackground.Caption := 'Sorry there is no data for this graph.'
      else
        pnlGraphBackground.Caption := 'Sorry the graph of <'+aName+'> is not available.';
      Exit;
    end
  else
    chrtVitals.Visible := True;

  CleanUp;
  //messagedlg('Name is ' + aName,mtInformation,mbOKCancel,0);
  if aName = sgnTRP then setTRP
  else if aName = sgnBP then setBP
  else if aName = sgnPain then setSingleGraph(rPain,sgnPain,PainNo99) // values of 99 will be ignored
  else if aName = sgnHW then setHW
  else if aName = sgnPOX then setSingleGraph(rPOx,sgnPOX)
  else if aName = sgnHeight then setSingleGraph(rHeight,sgnHeight)
  else if aName = sgnWeight then setSingleGraph(rWeight,sgnWeight)
  else if aName = sgnBMI then setSingleGraph(rBMI,sgnBMI)
  else if aName = sgnTemp then setSingleGraph(rTemp,sgnTemp)
  else if aName = sgnPulse then setSingleGraph(rPulse,sgnPulse)
  else if aName = sgnResp then setSingleGraph(rResp,sgnResp)
  else if aName = sgnGirth then setSingleGraph(rGirth,sgnGirth)
  else if aName = sgnCVP then setSingleGraph(rCVP,sgnCVP)
  else if aName = sgnIn then setSingleGraph(rIntake,sgnIn)
  else if aName = sgnOutput then setSingleGraph(rOutput,sgnOutput)
  else if aName = sgnBPWeight then  setBPWeight
  else if leftstr(aName,5) = leftstr(sgnVA1,5) then begin  //elh 3/13/08  added to graph Wounds
    intWoundNumber := strtoint(piece(aName,' ',2));
    intWoundNumber := ((intWoundNumber - 1) * 2) + rWoundS1VA;
    //messagedlg('VA Number is ' + inttostr(intWoundNumber),mtInformation ,mbOKCancel ,0);
    setSingleGraph(intWoundNumber ,aName)
  end else if leftstr(aName,5) = leftstr(sgnHF1,5) then begin
    intWoundNumber := strtoint(piece(aName,' ',2));
    intWoundNumber := ((intWoundNumber - 1) * 2) + rWoundS1HF;
//    messagedlg('HF Number is ' + inttostr(intWoundNumber),mtInformation ,mbOKCancel ,0);
    setSingleGraph(intWoundNumber ,aName)
  end;

  if aName = sgnTemp then chrtVitals.LeftAxis.MinorTickCount := 9
  else                    chrtVitals.LeftAxis.MinorTickCount := 4;

  setTrackBarLimits;
  CurrentPoint := getDefaultGridPosition;

{
  // vhaishandria 060123
  if not DataFound then
    begin
      pnlGraphBackground.Caption := 'Sorry there is no data for this graph.';
      chrtVitals.Visible := False;
    end;
}
end;

procedure TfraGMV_GridGraph.GraphDataByIndex(anIndex:Integer);
begin
  // Index - index of the Graph list control
  getGraphByName(cbxGraph.Items[anIndex]);
end;

////////////////////////////////////////////////////////////////////////////////

function TfraGMV_GridGraph.ScrollbarIsVisible:Boolean;
var
  i, iCount: Integer;
begin
  iCount := 0;
  for i := 0 to grdVitals.RowCount - 1 do
    iCount := iCount + grdVitals.RowHeights[i];
  Result := grdVitals.Height < iCount;
end;

function TfraGMV_GridGraph.GridScrollBarIsVisible:Boolean;
var
 jj: Integer;
 jCount: Integer;
begin
  jCount := 0;
  for jj := 0 to grdVitals.RowCount - 1 do
    jCount := jCount + grdVitals.RowHeights[jj]+ 1;
  Result := grdVitals.Height < jCount;
end;

function TfraGMV_GridGraph.getVisibleColCount:Integer;
var
  iGridColCount: Integer;
begin
  iGridColCount := ((grdVitals.Width - grdVitals.ColWidths[0]) div grdVitals.ColWidths[1]);
  // if the scroll bar is visible then we need to adjust this value
  if ScrollBarIsVisible  then
    Inc(iGridColCount);
  Result := iGridColCount;
end;

procedure TfraGMV_GridGraph.setTrackBarLimits;
var
  iGridColCount: Integer;
  iMax: Integer;
begin
  iGridColCount := getVisibleColCount;

  iMax := (grdVitals.ColCount - 1) - iGridColCount + 1;
  if GridScrollBarIsVisible  then
    Inc(iMax);

  if (FrameStyle=fsVitals) then //vhaishandria 051205
    iMax := iMax - 1;

  if iMax < 1 then iMax := 1;

  trbHGraph.min := 1;
  trbHGraph.max := iMax;
end;

procedure TfraGMV_GridGraph.setGridPosition(aPosition: Integer);
var
  iPos,
  iMin,iMax: Integer;

  function getVisibleColumnsCount:Integer;
  begin
    Result := ((grdVitals.Width - grdVitals.ColWidths[0]) div grdVitals.ColWidths[1]);
    if (FrameStyle=fsVitals) then
//    and scrollbarIsVisible then
      Result := Result + 1;
  end;

begin
  try
    iPos := aPosition;
    if iPos < 1 then iPos := 1;
    grdVitals.LeftCol := iPos;

    if not cbChrono.Checked then
      begin
        chrtVitals.BottomAxis.Automatic := False;
        iMin :=grdVitals.LeftCol -1; // needs correction becouse Series starts from 0
        iMax  :=grdVitals.LeftCol - 1 + getVisibleColumnsCount -1;
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
      end
    else
      setSeriesAxis([0,1,2]);

  except
//    on E: Exception do
//      ShowMessage('3'+#13#10+E.Message);
  end;
end;

procedure TfraGMV_GridGraph.setCurrentPoint(aValue: Integer);
begin
  FCurrentPoint := aValue;
  grdVitals.LeftCol := aValue;// vhaishandria 051204
  if iIgnoreCount > 0 then Exit;
  Inc(iIgnoreCount);
  setGridPosition(aValue);
  Dec(iIgnoreCount);
end;

procedure TfraGMV_GridGraph.scbHGraphChange(Sender: TObject);
begin
    CurrentPoint := trbHGraph.Position;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.setMDateTimeRange(aMDTR: TMDateTimeRange);
begin
  FMDateTimeRange := aMDTR;
  UpdateTimeLabels;
end;

procedure TfraGMV_GridGraph.setObservationRange(aRange:String);
begin
//  if iIGnoreCount > 0 then Exit; // vhaishandria 051203
//  Inc(iIgnoreCount);

  if MDateTimeRange.setMRange(aRange) then
    begin
      if (Uppercase(aRange) = sDateRange) then
        UpdateLists;

      FObservationRange:= aRange;
      updateTimeLabels;
      //set interface elements
      lbDateRange.ItemIndex := lbDateRange.Items.IndexOf(FObservationRange);

      if iIGnoreCount > 0 then Exit;
      Inc(iIgnoreCount);
      if FrameInitialized then
          UpdateFrame;
      Dec(iIgnoreCount);
    end;
//  Dec(iIgnoreCount);
end;

procedure TfraGMV_GridGraph.cbxDateRangeClick(Sender: TObject);
var
  s: String;
begin
  try // vhaishandria 051208
    if lbDateRange.ItemIndex = -1 then
      s := lbDateRange.Items[0]
    else
      s := lbDateRange.Items[lbDateRange.ItemIndex];
  except
  end;

  ObservationRange := s;

  if fStyle = fsVitals then
    GetParentForm(Self).Perform(CM_PERIODCHANGED, 0, 0);
end;

procedure TfraGMV_GridGraph.setPatientDFN(const Value: string);
begin
//  if not FrameInitialized then SetupFrame;
  FPatientDFN := Value;
  Visible := (Value <> '');
  if iIgnoreCount > 0 then
    Exit;//  vhaishandria 051202
  if Assigned(MDateTimeRange) then
    UpdateFrame;
end;

procedure TfraGMV_GridGraph.setGraphIndex(anIndex: Integer);
begin
  fGraphIndex := anIndex;

  if iIgnoreCount > 0 then Exit;
  Inc(iIgnoreCount);

  if FGraphIndex <> iIgnoreGraph then
    begin
      cbxGraph.ItemIndex := fGraphIndex;
      getGraphByName(cbxGraph.Items[GraphIndex]);
    end
  else
    begin
      fGraphIndex := 0;
      getGraphByName(sgnNoGraph);
    end;

  grdVitals.Invalidate;
  chrtVitals.Invalidate;

  Dec(iIgnoreCount);
end;

procedure TfraGMV_GridGraph.cbxGraphChange(Sender: TObject);
begin
  fGridRow := -1;  //default
  if Sender = cbxGraph then begin
    GraphIndex := cbxGraph.ItemIndex;
    DebugLabel.Caption := IntToStr(GraphIndex);
    if GraphIndex > 2 then fGridRow := GraphIndex+3;
    //MessageDlg(' in cbxGraphChange. GraphIndex='+IntToStr(GraphIndex)+', fGridRow='+IntToStr(fGridRow),mtInformation,mbOKCancel,0);
    UpdateFrame;
  end else begin
    //MessageDlg(' in cbxGraphChange. Sender='+Sender.ClassName,mtInformation,mbOKCancel,0);
  end;

  {case GraphIndex of       //elh removed
    0: fGridRow := 1;
    1: fGridRow := 2;
    2: fGridRow := 3;
    3: fGridRow := 6;
    4: fGridRow := 4;
    5: fGridRow := 9;
    6: fGridRow := 7;
    7: fGridRow := 8;
    8: fGridRow := 14;

    12: fGridRow := 10;
    13: fGridRow := 11;
    14: fGridRow := 12;
    15: fGridRow := 13;
  else fGridRow := -1;
  end;}
end;

////////////////////////////////////////////////////////////////////////////////
procedure TfraGMV_GridGraph.UpdateFrame;
var
  MDT: TMDateTime;
begin
  if not FrameInitialized then Exit;
  try
    MDT := TMDateTime.Create;
    MDT.WDateTime := MDateTimeRange.Stop.WDateTime;
    MDT.WDateTime := trunc(MDT.WDateTime)+1-5/(3600*24);
    //messagedlg('Prior to Vitals Data',mtInformation,mbOKCancel,0);
    GetVitalsData(MDateTimeRange.Start.getSMDateTime,MDT.getSMDateTime);
    //messagedlg('After Vitals Data',mtInformation,mbOKCancel,0);
    MDT.Free;

    GraphDataByIndex(GraphIndex);
    //messagedlg('After Graph Data',mtInformation,mbOKCancel,0);

    grdVitals.Invalidate;
    chrtVitals.Invalidate;
  except
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Resizing ====================================================================

procedure TfraGMV_GridGraph.chrtVitalsResize(Sender: TObject);
begin
  setTrackBarLimits;
  setGridPosition(grdVitals.LeftCol{-1});// vhaishandria 051130
end;

procedure TfraGMV_GridGraph.MaximizeGraph(Sender: TObject);
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

procedure TfraGMV_GridGraph.Panel9Resize(Sender: TObject);
begin
  lblHospital.Width := panel9.Width - lblHospital.Left - 4;
  lblHospital.Height := panel9.Height - lblHospital.Top - 2;
end;

////////////////////////////////////////////////////////////////////////////////

function TfraGMV_GridGraph.GraphNameByGridRow(aRow:Integer):String;
  begin
//elh converted hard coded numbers to constants, added wounds,  3/12/08
    if (aRow>=0) or (aRow<=rMAX_ROW) then begin
      Result := cRowLabel[aRow];
    end else begin
      Result := sgnNoGraph;
    end;
    {
    case aRow of
      rTemp: Result := sgnTemp;
      rPulse: Result := sgnPulse;
      rResp: Result := sgnResp;
      rPOx: Result := sgnPOX;
      rLPM: Result := sgnPOX;
      rBP: Result := sgnBP;
      rWeight: Result := sgnWeight;
      rBMI: Result := sgnBMI;
      rHeight: Result := sgnHeight;
      rGirth: Result := sgnGirth;
      rCVP: Result := sgnCVP; //GraphNameNoGraph;
      rIntake: Result := sgnIn;//GraphNameNoGraph;
      rOutput: Result := sgnOutput;//GraphNameNoGraph;
      rPain: Result := sgnPain;
      rPain: Result := sgnPain;
      rPain: Result := sgnPain;
      rWoundS1VA: Result := sgnVA1;
      rWoundS1HF: Result := sgnHF1;
      rWoundS2VA: Result := sgnVA2;
      rWoundS2HF: Result := sgnHF2;
      rWoundS3VA: Result := sgnVA3;
      rWoundS3HF: Result := sgnHF3;
      rWoundS4VA: Result := sgnVA4;
      rWoundS4HF: Result := sgnHF4;
      rWoundS5VA: Result := sgnVA5;
      rWoundS5HF: Result := sgnHF5;
      rWoundS6VA: Result := sgnVA6;
      rWoundS6HF: Result := sgnHF6;
      rWoundS7VA: Result := sgnVA7;
      rWoundS7HF: Result := sgnHF7;
      rWoundS8VA: Result := sgnVA8;
      rWoundS8HF: Result := sgnHF8;
      rWoundS9VA: Result := sgnVA9;
      rWoundS9HF: Result := sgnHF9;
      rWoundS10VA: Result := sgnVA10;
      rWoundS10HF: Result := sgnHF10;
      rWoundS11VA: Result := sgnVA11;
      rWoundS11HF: Result := sgnHF11;
      rWoundS12VA: Result := sgnVA12;
      rWoundS12HF: Result := sgnHF12;
      rWoundS13VA: Result := sgnVA13;
      rWoundS13HF: Result := sgnHF13;
      rWoundS14VA: Result := sgnVA14;
      rWoundS14HF: Result := sgnHF14;
      rWoundS15VA: Result := sgnVA15;
      rWoundS15HF: Result := sgnHF15;
    else
      Result := sgnNoGraph;
    end;
    }
//    if (Result <> sgnNoGraph) then fGridRow := aRow;
  end;

function TfraGMV_GridGraph.GraphIndexByGridRow(aRow:Integer):Integer;
begin
//messagedlg('calling graphindexbygridrow ' + inttostr(aRow),mtInformation ,mbOKCancel ,0);
//Since we are  elh   3/13/08
if aRow > 2 then
   Result := aRow - 3
else
    Result := iIgnoreGraph
{
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
    10: Result := 12; //iIgnoreGraph; // C/G
    11: Result := 13; //iIgnoreGraph;  // CVP
    12: Result := 14; //iIgnoreGraph;  // In
    13: Result := 15; //iIgnoreGraph;  // Out
    14: Result := 8;
  else
    Result := iIgnoreGraph;
  end;
}
end;

function TfraGMV_GridGraph.GridRowByGraphIndex(anIndex:Integer):Integer;
begin
//kt make changes here
//messagedlg('calling gridrowbygraphindex ' + inttostr(anIndex),mtInformation ,mbOKCancel ,0);
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
    9: Result := 0;
    10:Result := 0;
    11:Result := 0;
    12:Result := 11;// CVP
    13:Result := 12;// CVP
    14:Result := 13;// In
    15:Result := 14;// Out

  else
    if GraphIndex < 9 then
      Result := GridRowByGraphIndex(GraphIndex)
    else
      Result := 0;
  end;
end;

procedure TfraGMV_GridGraph.cbChronoClick(Sender: TObject);
begin
  if iIgnoreCount > 0 then Exit;

  ChrtVitals.SeriesList[0].XValues.DateTime := cbChrono.Checked;
  ChrtVitals.SeriesList[1].XValues.DateTime := cbChrono.Checked;
  ChrtVitals.SeriesList[2].XValues.DateTime := cbChrono.Checked;

{
  GraphDataByIndex(GraphIndex);
  scbHGraphChange(trbHGraph);
  chrtVitals.Invalidate;
}
  ckb3D.Enabled := cbChrono.Checked;
  if not cbChrono.Checked then
    begin
      ckb3D.Checked := False;
      ckb3D.Enabled := False;
    end;
  UpdateFrame;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.UpdateTimeLabels;
begin
  lblDateFromTitle.Caption := MDateTimeRange.Start.getSWDate;
  lblDateFromTitle.Caption := lblDateFromTitle.Caption + ' -- ' + MDateTimeRange.Stop.getSWDate;

  Application.ProcessMessages;
end;

procedure TfraGMV_GridGraph.UpdateLists;
begin
  if (pos(MDateTimeRange.getSWRange,lbDateRange.Items.Text) = 0) then
    begin
      lbDateRange.Items.Add(MDateTimeRange.getSWRange);
      lbDateRange.ItemIndex := lbDateRange.Items.IndexOf(MDateTimeRange.getSWRange);
    end;
end;


procedure TfraGMV_GridGraph.setGraphTitle(aFirst,aSecond: string);
begin
  chrtVitals.Title.Text.Clear;
  chrtVitals.Title.Text.Add(aFirst);
  chrtVitals.Title.Text.Add(aSecond);

//  lblPatientName.Caption := aFirst;
//  lblPatientInfo.Caption := aSecond;
  edPatientName.Text := aFirst;
  edPatientInfo.Text:= aSecond;

  ptName := aFirst;
  ptInfo := aSecond;
end;

procedure TfraGMV_GridGraph.ShowHideLabels(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to chrtVitals.SeriesCount - 1 do
    if chrtVitals.Series[i].Active then
      chrtVitals.Series[i].Marks.Visible := bLabelShow;
end;

function TfraGMV_GridGraph.MetricValueString(_Row_:Integer;_Value_:String):String;
var
  s: String;
  f: Extended;
begin
  Result := '';
  s := piece(_Value_,' ');
  if pos('*',s)=Length(s) then s := copy(s,1,Length(s)-1);
//kt make changes here
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


procedure TfraGMV_GridGraph.chrtVitalsClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: integer; Button: TMouseButton;
  Shift: TShiftState; x, Y: integer);
const
//  NoData = 'NO DATA';
  iDate = 1;       //piece location in s
  iTime = 2;       //piece location in s
  iLocation = 22;  //piece location in s
  iEnteredBy = 23; //piece location in s

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
    else                   sValue := sNoData;
    sMetric := MetricValueString(aRow,grdVitals.Cells[iCol, aRow]);

    VitalsData.Add('  Vital:' + #9 + sName);
    VitalsData.Add('  Value:' + #9 + sValue);
    if sMetric <> '' then  VitalsData.Add('        ' + #9 + sMetric);
    if aRow = 4 then       VitalsData.Add('        ' + #9 + grdVitals.Cells[iCol, 5]);
    VitalsData.Add('');
  end;

  function ConvertVitalsToText:String;
  var
    i: Integer;
    _S_,__S,s3,//AAN
    s1, s2: string;
    s,ss,
    sDate,sTime, sLocation,sEnteredBy, sOldInfo,sNewInfo,
    sTemp, sPulse,sResp,sBP,sPOx, sFive, {sSix,} sWt, sBMI,
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

//kt make changes here ... add wound data..

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

//kt make changes here ... add wound data..

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

//kt make changes here ... add wound data..

      end;
    Result := ss;
  end;

begin
  iCol := ValueIndex + 1;
  iRow := StrToIntDef(Series.Identifier, 1);
  VitalsData := TStringList.Create;
  try
    VitalsData.Add('');
    sFor := piece(grdVitals.Cells[iCol, 0],' ',1);
//    VitalsData.Add('  Date:' + #9 + grdVitals.Cells[iCol, 0]);
    if cbxGraph.Items[GraphIndex] = sgnTRP then
      begin
        SetVitalInfo(1);  //kt make changes here.  change #'2 in rXYZ constants
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
    AllVitalsData := getALLPatientData(fPatientDFN,sFrom,sTo);
    VitalsData.Text := ConvertVitalsToText;
    AllVitalsData.Free;
{===============================================================================}
    ShowInfo('Vitals '+getPatientName+' for '+sFor,VitalsData.Text);
    mdt.Free;
  finally
    FreeAndNil(VitalsData);
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.DrawMissingLines(aStartPoint,aStopPoint:Integer);
var
  rect, RectOld: TRect;
  x,y,
  i, j: integer;
  SeriesNumber: integer;
  FirstDataPoint,
  LastDataPoint  : integer;
  CurrentSeries: TChartSeries;
  iActiveCount: Integer;
const
  iSize = 3;

  procedure DrawEllipse;
  begin
    rect.left := CurrentSeries.CalcXPos(i)-iSize;
    rect.Top := CurrentSeries.CalcYPos(i)-iSize;
    rect.Right := CurrentSeries.CalcXPos(i)+iSize;
    rect.Bottom := CurrentSeries.CalcYPos(i)+iSize;

    chrtVitals.Canvas.Pen.Width := 4;
    Brush.Style := bsSolid;
    Brush.Color := CurrentSeries.SeriesColor;
    chrtVitals.Canvas.Ellipse(rect.Left,rect.top,rect.right,rect.Bottom);
    chrtVitals.Canvas.Pen.Width := 2;
  end;

  procedure DrawRect;
  begin
    rect.left := CurrentSeries.CalcXPos(i)-iSize;
    rect.Top := CurrentSeries.CalcYPos(i)-iSize;
    rect.Right := CurrentSeries.CalcXPos(i)+iSize;
    rect.Bottom := CurrentSeries.CalcYPos(i)+iSize;
    chrtVitals.Canvas.Brush.Color := CurrentSeries.SeriesColor;
    chrtVitals.Canvas.FillRect(rect);
  end;

  procedure DrawPolygon;
  begin
  end;

  function yStep:Integer;
  begin
    Result := 0;
    if not chrtVitals.View3d then Exit;

    chrtVitals.CalcSize3dWalls;
    if chrtVitals.SeriesCount > 0 then
      Result := chrtVitals.Height3D div iActiveCount;
  end;

  function xStep:Integer;
  begin
    Result := 0;
    if not chrtVitals.View3d then Exit;

    chrtVitals.CalcSize3dWalls;
    if chrtVitals.SeriesCount > 0 then
      Result := chrtVitals.Width3D div iActiveCount;
  end;

  function xDelta(ii: Integer): Integer;
  begin
    Result := 0;
  end;

  function yDelta(ii: Integer): Integer;
  begin
    Result := 0;
EXIT;
    case iActiveCount of
      1:begin
          yDelta := yStep+2;
        end;
      2: begin
          case ii of
            0: yDelta :=  - yStep - 2
          else
            yDelta := yStep;
          end;
        end;
      3: begin
          case ii of
            0: yDelta :=  yStep + 2;
            1: yDelta := 0;
            2: yDelta := - yStep - 2
          else
           yDelta := 0;
          end;
        end;
    else
      yDelta := 0;
    end;

  end;

begin
  RectOld := TCanvas(chrtVitals.Canvas).ClipRect;
  chrtVitals.Canvas.ClipRectangle(chrtVitals.chartRect);

  iActiveCount := 0;
  for SeriesNumber := 0 to chrtVitals.SeriesCount - 1 do
    if chrtVitals.Series[SeriesNumber].Active then
        Inc(iActiveCount);

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
//                    if not chrtVitals.View3d then vhaishandria 060106
                    case SeriesNumber of
                      0: DrawEllipse;
                      1: DrawEllipse;
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
                  // to avoid starting with null on the screen
                  if {(j <> 0) or}
                    not CurrentSeries.IsNull(j)
                    and not ((i = LastDataPoint) and (CurrentSeries.IsNull(i)))
                  then
                    begin
                      x := CurrentSeries.CalcXPos(j) + xDelta(SeriesNumber);
                      y := CurrentSeries.CalcYPos(j) + yDelta(SeriesNumber);
                      MoveTo(x,y);

                      x := CurrentSeries.CalcXPos(i) + xDelta(SeriesNumber);
                      y := CurrentSeries.CalcYPos(i) + YDelta(SeriesNumber);
                      LineTo(x,y);
{
                      Pen.Color := clRed;
                      y := y + chrtVitals.SeriesHeight3d;
                      LineTo(x,y);
                      x := CurrentSeries.CalcXPos(i) + xDelta(SeriesNumber);
                      y := CurrentSeries.CalcYPos(i) + YDelta(SeriesNumber);
                      MoveTo(x,y);
                      x := x + chrtVitals.SeriesWidth3d;
                      LineTo(x,y);
}
                    end;
                  end;
                j := i;
              end;
          end;
      end;
  chrtVitals.Canvas.ClipRectangle(RectOld);//Restore ClipRectangle
end;

procedure TfraGMV_GridGraph.DrawMissingDataLines(Sender: TObject);
var
  FirstPointOnPage, LastPointOnPage: integer;
begin
  FirstPointOnPage := 0;
  LastPointOnPage := chrtVitals.Series[0].Count-1;
  DrawMissingLines(FirstPointOnPage,LastPointOnPage);
end;

procedure TfraGMV_GridGraph.chrtVitalsAfterDraw(Sender: TObject);
begin
{$IFDEF LINES}
  Exit;
{$ENDIF}
  if not cbChrono.Checked then
    DrawMissingDataLines(nil);
end;

procedure TfraGMV_GridGraph.grdVitalsDrawCell(
  Sender: TObject;
  ACol, ARow: integer;
  Rect: TRect;
  State: TGridDrawState);

  function CurrentGraph:Boolean;
    begin
      //kt make changes here
      //messageDlg('In CurrentGraph.  GraphIndex='+IntToStr(GraphIndex)+', aRow='+IntToStr(aRow),mtInformation,mbOKCancel,0);
     DebugLabel.caption := 'In CurrentGraph: GraphIndex='+IntToStr(GraphIndex)+' aRow ' + inttostr(aRow) + ' fGridRog='+IntToStr(fGridRow);
     //case GraphIndex of
     case fGridRow of
       giTPR: Result := (aRow = rTemp) or (aRow = rPulse) or (aRow = rResp);
       giHW: begin
           DebugLabel.caption := 'In CurrentGraph: GraphIndex='+IntToStr(GraphIndex)+' aRow ' + inttostr(aRow);
           //messagedlg('In CurrentGraph: GraphIndex='+IntToStr(GraphIndex)+' aRow ' + inttostr(aRow),mtInformation ,mbOKCancel ,0);
           Result := (aRow = rHeight) or (aRow = rWeight);
       end;
       giBPW: begin
           //messagedlg('In CurrentGraph: GraphIndex='+IntToStr(GraphIndex)+'  aRow ' + inttostr(aRow),mtInformation ,mbOKCancel ,0);
           Result := (aRow = rBP) or (aRow = rWeight);
       end;
       rPOx,rLPM: Result := (aRow = rPOx) or (aRow=rLPM);
       rIntake,rOutput: Result := (aRow = rIntake) or (aRow = rOutput);
      else
        Result := (aRow = fGridRow);
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
      if (aRow < rTemp ) then            //elh 3/12/08
            Canvas.Brush.Color := clBtnFace
      else if (ACol = 0) then
        begin
          if (aRow<>0) and CurrentGraph then
            Canvas.Brush.Color := clInfoBk
          else
            Canvas.Brush.Color := clSilver;// clBtnFace;
        end
      else if AbnormalValue then
        begin
// Uncomment if you need a separate color for today's values
//          if TodayValue then
//            Canvas.Brush.Color := DISPLAYCOLORS[GMVAbnormalTodayBkgd]
//          else
            Canvas.Brush.Color := DISPLAYCOLORS[GMVAbnormalBkgd];
        end
      else
// Uncomment if you need a separate color for today's values
//          if TodayValue then
//            Canvas.Brush.Color := DISPLAYCOLORS[GMVNormalTodayBkgd]
//          else
            if CurrentGraph then
              Canvas.Brush.Color := $00DFDFDF
            else
//              Canvas.Brush.Color :=  fBGColor; //DISPLAYCOLORS[GMVNormalBkgd];
              Canvas.Brush.Color :=  DISPLAYCOLORS[GMVNormalBkgd];
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
      if (ACol = 0) or (ARow = rHeader) or (ARow = rUser) or (ARow = rLocation) then
        begin
          Canvas.Font.Color := clBtnText;
          Canvas.Font.Style := [];
        end
      else if AbnormalValue then
        begin
          Canvas.Font.Color := DISPLAYCOLORS[GMVAbnormalText];
          if GMVAbnormalBold then  Canvas.Font.Style := [fsBold]
          else                     Canvas.Font.Style := [];
        end
      else
        begin
          Canvas.Font.Color := DISPLAYCOLORS[GMVNormalText];
          if GMVNormalBold then    Canvas.Font.Style := [fsBold]
          else                     Canvas.Font.Style := [];
        end;

      // Fill in the data
      if ((ACol = 0) or (ARow = 0)) and (aRow <>15) and (aRow <>16) then
        Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
      else if ((aRow = 15) or (aRow=16)) {and (not cbWho.Checked)} then
        begin
          Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
        end
      else if AbnormalValue then
        begin
          if GMVAbnormalQuals then Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
          else                     Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Piece(Value, ' ', 1))
        end
      else
        begin
          if GMVNormalQuals then  Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Value)
          else                    Canvas.TextRect(Rect, Rect.Left+10, Rect.Top, Piece(Value, ' ', 1));
        end;

      if gdSelected in State then
        begin
          Canvas.Brush.Color := clRed; // clBlack;//vhaishandria 050705
          Canvas.FrameRect(Rect);
        end;
    end;
end;


procedure TfraGMV_GridGraph.grdVitalsSelectCell(Sender: TObject; Button: TMouseButton; Shift: TShiftState; x, Y: integer);
var
  ACol, ARow: Longint;
//  sName:String;
begin
  grdVitals.MouseToCell(x, Y, ACol, ARow);
  if (aCol = 0) then
    begin
      //sName := GraphNameByGridRow(aRow);      // vhaishandria 060105
      //getGraphByName(sName);                  // vhaishandria 060105
      //messagedlg('Prior to Update1',mtInformation,mbOKCancel,0);
      if GraphIndexByGridRow(aRow) <> iIgnoreGraph then
        GraphIndex := GraphIndexByGridRow(aRow)
      else
        fGraphIndex := 0;
      fGridRow := aRow;
      //messagedlg('Prior to Update2',mtInformation,mbOKCancel,0);
      //messagedlg('Prior to Update',mtInformation,mbOKCancel,0);
      UpdateFrame; // vhaishandria 060105
      //messagedlg('After update',mtInformation,mbOKCancel,0);
      grdVitals.Invalidate;
      chrtVitals.Invalidate;
    end;

  if (ACol > 0) and (ARow = 0) then
    try
      fSelectedDateTime := getCellDateTime(grdVitals.Cells[aCol, 0]);
      acEnteredInErrorByTimeExecute(nil);
    except
    end;
end;

procedure TfraGMV_GridGraph.setPatientLocation(aLocation: String);
begin
  FPatientLocation := aLocation;
end;

procedure TfraGMV_GridGraph.setPatientLocationName(aLocationName: String);
begin
  FPatientLocationName := aLocationName;
  lblHospital.Caption := aLocationName;
end;

// Actions =====================================================================

procedure TfraGMV_GridGraph.sbtnPrintGraphClick(Sender: TObject);
begin
  acPrintGraphExecute(Sender);
end;

procedure TfraGMV_GridGraph.sbtnLabelsClick(Sender: TObject);
begin
  acValueCaptionsExecute(Sender);
end;

procedure TfraGMV_GridGraph.sbtnMaxGraphClick(Sender: TObject);
begin
  acResizeGraphExecute(Sender);
end;

procedure TfraGMV_GridGraph.acCustomRangeExecute(Sender: TObject);
begin
  setObservationRange(sDateRange);
  UpdateLists;
end;

procedure TfraGMV_GridGraph.acEnteredInErrorExecute(Sender: TObject);
begin
  if EnterVitalsInError(FPatientDFN) <> mrCancel then
    cbxDateRangeClick(nil);
end;

procedure TfraGMV_GridGraph.acZoomExecute(Sender: TObject);
begin
//  chrtVitals.AllowZoom := not chrtVitals.AllowZoom;
  chrtVitals.AllowZoom := cbAllowZoom.Checked;
  edZoom.Enabled := chrtVitals.AllowZoom;
  sbPlus.Enabled := chrtVitals.AllowZoom;
  sbMinus.Enabled := chrtVitals.AllowZoom;
  sbReset.Enabled := chrtVitals.AllowZoom;
end;

procedure TfraGMV_GridGraph.acGraphOptionsExecute(Sender: TObject);
begin
  pnlGraphOptions.Visible := not pnlGraphOptions.Visible;
end;

procedure TfraGMV_GridGraph.acEnteredInErrorByTimeExecute(Sender: TObject);
begin
  if fSelectedDateTime = 0 then Exit;
  if EnteredInErrorByDate(FPatientDFN,trunc(fSelectedDateTime)+1-1/(3600*24)) <> mrCancel then
    cbxDateRangeClick(nil);
end;

procedure TfraGMV_GridGraph.acPatientAllergiesExecute(Sender: TObject);
begin
  sbtnAllergies.Down := True;
  ShowPatientAllergies(FPatientDFN);
  sbtnAllergies.Down := False;
end;

procedure TfraGMV_GridGraph.ColorSelect1Accept(Sender: TObject);
begin
  BGColor := ColorSelect1.Dialog.Color;
end;

procedure TfraGMV_GridGraph.SetColor;
begin
  fBGColor := aColor;
    begin
      chrtVitals.Color := fBGColor;
      pnlRight.Color := fBGColor;
      trbHGraph.Invalidate;
      grdVitals.Invalidate;
    end;
end;

procedure TfraGMV_GridGraph.SetTodayColor;
begin
  fBGTodayColor := aColor;
    begin
      trbHGraph.Invalidate;
      grdVitals.Invalidate;
    end;
end;

procedure TfraGMV_GridGraph.sbGraphColorClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
    BGColor := ColorDialog1.Color;
end;

procedure TfraGMV_GridGraph.acEnterVitalsExecute(Sender: TObject);
begin
  //messagedlg('Here',mtInformation ,mbOKCancel ,0);
  VitalsInputDLG(
     PatientDFN,
     PatientLocation,
     '', // Template
     '', // Signature
     getServerWDateTime,// select server date time  - vhaishandria 050419
     ptName,
     ptInfo
     ) ;

  UpdateFrame;
end;

procedure TfraGMV_GridGraph.acValueCaptionsExecute(Sender: TObject);
begin
  bLabelShow := not bLabelShow;
  ShowHideLabels(Sender);
end;

procedure TfraGMV_GridGraph.ac3DExecute(Sender: TObject);
begin
  chrtVitals.View3D := ckb3D.Checked;
  bIgnoreBlueLines := ckb3D.Checked;
end;

procedure TfraGMV_GridGraph.acResizeGraphExecute(Sender: TObject);
begin
  MaximizeGraph(Sender);
end;

procedure TfraGMV_GridGraph.PrintGraph(Sender: TObject);
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
        end;
    finally
      free;
    end;
end;


procedure TfraGMV_GridGraph.lbDateRangeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
      cbxDateRangeClick(lbDateRange);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TfraGMV_GridGraph.SetStyle(aStyle:String);
begin
  splGridGraph.Align := alTop;
  pnlGrid.Align := alBottom;
  pnlGraph.Align := alClient;
  splGridGraph.Align := alBottom;

  pnlDateRangeTop.Visible := True;

  if aStyle = fsVitals then
    begin
      pnlGrid.Constraints.MaxHeight :=
        (grdVitals.RowCount+1) * (grdVitals.RowHeights[0]+1)+
        + pnlGridTop.Height;

      pnlTitle.Visible := False;
    end
  else   // CPRS
      pnlTitle.Visible := True;

  FStyle := aStyle;
end;

procedure TfraGMV_GridGraph.setUpFrame;
var
e: integer;
  function GridHeight:Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to grdVitals.RowCount - 1 do
      Result := Result + grdVitals.RowHeights[i]+2;
  end;

begin
  if FrameInitialized then  Exit;

  with grdVitals do
    begin
      RowCount := rMAX_ROW + 1;
      //Change the labels to the 'r' constants
      DefaultRowHeight := 15;
      DefaultColWidth := 100;
      ColWidths[0] := 100;
      //kt make changes here.  Change string labels with sgnXYZ constants+':'
      Cells[0, rLocation] := 'Location:';
      Cells[0, rUser] := 'Entered By:';
      Cells[0, rTemp] := ' Temp:';
      Cells[0, rPulse] := ' Pulse:';
      Cells[0, rResp] := ' Resp:';
      Cells[0, rPOx] := ' P Ox %:'; //AAN 2003/06/03
      Cells[0, rLPM] := ' L/Min/%:';
      Cells[0, rBP] := ' B/P:';
      Cells[0, rWeight] := ' Wt (lbs):';
      Cells[0, rBMI] := ' BMI:';
      Cells[0, rHeight] := ' Ht (in):';
      Cells[0, rGirth] := ' C/G:';
      Cells[0, rCVP] := ' CVP (cmH2O):';
      Cells[0, rIntake] := ' In 24hr (ml):';
      Cells[0, rOutput]:= ' Out 24hr (ml):';
      Cells[0, rPain]:= ' Pain:';
      Cells[0, rWoundS1VA] := sgnVA1;
      Cells[0, rWoundS1HF] := sgnHF1;
      Cells[0, rWoundS2VA] := sgnVA2;
      Cells[0, rWoundS2HF] := sgnHF2;
      Cells[0, rWoundS3VA] := sgnVA3;
      Cells[0, rWoundS3HF] := sgnHF3;
      Cells[0, rWoundS4VA] := sgnVA4;
      Cells[0, rWoundS4HF] := sgnHF4;
      Cells[0, rWoundS5VA] := sgnVA5;
      Cells[0, rWoundS5HF] := sgnHF5;
      Cells[0, rWoundS6VA] := sgnVA6;
      Cells[0, rWoundS6HF] := sgnHF6;
      Cells[0, rWoundS7VA] := sgnVA7;
      Cells[0, rWoundS7HF] := sgnHF7;
      Cells[0, rWoundS8VA] := sgnVA8;
      Cells[0, rWoundS8HF] := sgnHF8;
      Cells[0, rWoundS9VA] := sgnVA9;
      Cells[0, rWoundS9HF] := sgnHF9;
      Cells[0, rWoundS10VA] := sgnVA10;
      Cells[0, rWoundS10HF] := sgnHF10;
      Cells[0, rWoundS11VA] := sgnVA11;
      Cells[0, rWoundS11HF] := sgnHF11;
      Cells[0, rWoundS12VA] := sgnVA12;
      Cells[0, rWoundS12HF] := sgnHF12;
      Cells[0, rWoundS13VA] := sgnVA13;
      Cells[0, rWoundS13HF] := sgnHF13;
      Cells[0, rWoundS14VA] := sgnVA14;
      Cells[0, rWoundS14HF] := sgnHF14;
      Cells[0, rWoundS15VA] := sgnVA15;
      Cells[0, rWoundS15HF] := sgnHF15;

//      Cells[0, 17] := 'Source App:';

      Height :=
        (DefaultRowHeight * RowCount) +
        (GridLineWidth * (RowCount+3)) +
        GetSystemMetrics(SM_CYVSCROLL);

      if FrameStyle <> fsVitals then
        pnlGrid.Height :=
          pnlGridTop.Height +
          (DefaultRowHeight * RowCount) +
          (GridLineWidth * (RowCount+3)) +
          GetSystemMetrics(SM_CYVSCROLL);

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
  lbDateRange.Items.Add('Six Months');
  lbDateRange.Items.Add('One Year');
  lbDateRange.Items.Add('Two Years');
  lbDateRange.Items.Add('All Results');
  lbDateRange.Items.Add(sDateRange);  //vhaishandria 050421

  for e := rTemp to rMax_Row do begin      //Changed the combobox to add the items
    cbxGraph.Items.add(cRowLabel[e]);      //in the order they are listed in the
  end;                                     //array.    elh    3/13/08
  {
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
  cbxGraph.Items.Add(sgnTRP);
  cbxGraph.Items.Add(sgnBPWeight);

  cbxGraph.Items.Add(sgnGirth);
  cbxGraph.Items.Add(sgnCVP);
  cbxGraph.Items.Add(sgnIn);
  cbxGraph.Items.Add(sgnOutput);
  }
  cbxGraph.Items.add(sgnTRP);      //Note: order of addition must match gi[XYZ] constants
  cbxGraph.Items.add(sgnBPWeight);
  cbxGraph.Items.add(sgnHW);

  iIgnoreGraph := 50;  //Changed from 21 -> 50 elh 3/13/08

  bLabelSHow := False;
  Inc(iIgnoreCount);
  GraphIndex := 1;
  Dec(iIgnoreCount);
  cbxGraph.ItemIndex := 1;

  if Assigned(MDateTimeRange) then
    try
      lbDateRange.Items.Add(MDateTimeRange.getSWRange);
      lbDateRange.ItemIndex := lbDateRange.Items.IndexOf(MDateTimeRange.getSWRange);
    except
    end;

  fSelectedDateTime := 0;
  iIgnoreCount := 0;

  pnlGrid.Constraints.MaxHeight := pnlGridTop.Height + gridHeight;
  grdVitals.ColWidths[0] := pnlDateRange.Width;

{$IFDEF AANTEST}
  sbTest.Visible := True;
  pnlDebug.Visible := True;
{$ENDIF}

  FrameInitialized := True;
end;

// Color frames ================================================================

procedure TfraGMV_GridGraph.cbxGraphExit(Sender: TObject);
begin
  cbxGraph.Color := clTabOut;
end;

procedure TfraGMV_GridGraph.cbxGraphEnter(Sender: TObject);
begin
  cbxGraph.Color := clTabIn;
end;

procedure TfraGMV_GridGraph.lbDateRangeExit(Sender: TObject);
begin
  pnlPBot.Color := clbtnFace;
  pnlPTop.Color := clbtnFace;
  pnlPLeft.Color := clbtnFace;
  pnlPRight.Color := clbtnFace;
end;

procedure TfraGMV_GridGraph.lbDateRangeEnter(Sender: TObject);
begin
  pnlPBot.Color := clTabIn;
  pnlPTop.Color := clTabIn;
  pnlPLeft.Color := clTabIn;
  pnlPRight.Color := clTabIn;
end;

procedure TfraGMV_GridGraph.grdVitalsEnter(Sender: TObject);
begin
  pnlGBot.Color := clTabIn;
  pnlGTop.Color := clTabIn;
  pnlGLeft.Color := clTabIn;
  pnlGRight.Color := clTabIn;
end;

procedure TfraGMV_GridGraph.grdVitalsExit(Sender: TObject);
begin
  pnlGBot.Color := clbtnFace;
  pnlGTop.Color := clbtnFace;
  pnlGLeft.Color := clbtnFace;
  pnlGRight.Color := clbtnFace;
end;

procedure TfraGMV_GridGraph.chrtVitalsBeforeDrawSeries(Sender: TObject);
var
  iLeft,iRight,
  iDelta,
  iMin,iMax: LongInt;

  dBeginPlus, dEndPlus,
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

  function yStep:Integer;
  begin
    Result := 0;
    if not chrtVitals.View3d then Exit;

    chrtVitals.CalcSize3dWalls;
    Result := chrtVitals.Height3D div 2;
  end;

  function xStep:Integer;
  begin
    Result := 0;
    if not chrtVitals.View3d then Exit;

    chrtVitals.CalcSize3dWalls;
    Result := chrtVitals.Width3D;
  end;


begin
{$IFDEF LINES}
  Exit;
{$ENDIF}

  if bIgnoreBlueLines then Exit;
  if chrtVitals.View3D then Exit;
  try
    if (grdVitals.ColCount = 2) and
      ((pos(sNoData,grdVitals.Cells[1,0]) = 1)
        or
       (trim(grdVitals.Cells[1,fGridRow])='')
      ) then Exit;
  except
    Exit;
  end;

  dBegin := ValueDateTime(grdVitals.LeftCol);
  if FrameStyle = fsVitals then
    dEnd := ValueDateTime(grdVitals.LeftCol+grdVitals.VisibleColCount)
  else
    dEnd := ValueDateTime(grdVitals.LeftCol+grdVitals.VisibleColCount-1);

  if grdVitals.LeftCol > 1 then
    dBeginPlus := ValueDateTime(grdVitals.LeftCol -1)
  else
    dBeginPlus := dBegin;

  if grdVitals.LeftCol+grdVitals.VisibleColCount< grdVitals.ColCount then
    dEndPlus := ValueDateTime(grdVitals.LeftCol+grdVitals.VisibleColCount)
  else
    dEndPlus := dEnd;

  fXL := (round(chrtVitals.BottomAxis.CalcPosValue(dBegin))+
    round(chrtVitals.BottomAxis.CalcPosValue(dBeginPlus))) div 2
    +xStep;

  fXR := (round(chrtVitals.BottomAxis.CalcPosValue(dEnd)) +
    round(chrtVitals.BottomAxis.CalcPosValue(dEndPlus))) div 2
    +xStep;

//  idelta := round(0.05*(chrtVitals.LeftAxis.Maximum-chrtVitals.LeftAxis.Minimum));
//  if iDelta > 5 then iDelta := 5;
  iDelta := 5;

  iLeft := -1;
  iRight := -1;

  with chrtVitals.Canvas do
    begin
      iMin := chrtVitals.ChartRect.Top+1 + yStep;
      iMax := chrtVitals.ChartRect.Bottom-1 + yStep;
      Pen.Color := clBlue;
      if (fXL > chrtVitals.ChartRect.Left) and (fXL < chrtVitals.ChartRect.Right) then
        begin
          iLeft := fXL+1;
          MoveTo(fXL,iMin);
          LineTo(fXL,iMax);
        end
      else if fXL <= chrtVitals.ChartRect.Left then
        iLeft := chrtVitals.ChartRect.Left + 1;

      if (fXR > chrtVitals.ChartRect.Left) and (fXR < chrtVitals.ChartRect.Right) then
        begin
          iRight := fXR;
          MoveTo(fXR,iMin);
          LineTo(fXR,iMax);
        end
      else if fXR >= chrtVitals.ChartRect.Right then
        iRight := chrtVitals.ChartRect.Right;

      Brush.Color := clSilver;

      if (iLeft > 0) and (iRight > 0) then
        begin
          FillRect(Rect(iLeft,iMin,iRight,iMin+iDelta));
          FillRect(Rect(iLeft,iMax-iDelta,iRight,iMax));
        end;
    end;
end;

//  Unknown ////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.lbDateRangeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cbxDateRangeClick(nil);
  UpdateFrame;// vhaishandria 060111
end;

procedure TfraGMV_GridGraph.lbDateRangeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  i := Y div lbDateRange.ItemHeight + lbDateRange.TopIndex;
  if (i < lbDateRange.Items.Count) and (i>=0) then
    lbDateRange.Hint := lbDateRange.Items[i];
end;

procedure TfraGMV_GridGraph.grdVitalsTopLeftChanged(Sender: TObject);
begin
//messagedlg('Prior to TopLeft',mtInformation ,mbOKCancel ,0);
  Inc(iIgnoreCount);
  trbHGraph.Position := grdVitals.LeftCol;
  CurrentPoint := grdVitals.LeftCol;
  chrtVitals.Invalidate;
  Dec(iIgnoreCOunt);
//messagedlg('After TopLeft',mtInformation ,mbOKCancel ,0);
end;

procedure TfraGMV_GridGraph.SaveStatus;

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

  SaveBooleanItem(pnlGraphOptions.Visible,'GRAPHOPTIONS');
  SaveBooleanItem(cbValues.Checked,'GRAPHOPTIONS-1');
  SaveBooleanItem(ckb3D.Checked,'GRAPHOPTIONS-2');
  SaveBooleanItem(cbAllowZoom.Checked,'GRAPHOPTIONS-3');
  SaveBooleanItem(cbChrono.Checked,'GRAPHOPTIONS-4');

  SaveIntegerItem(GraphIndex,'GRAPH_INDEX');

  SaveIntegerItem(GMVAbnormalText, 'ABNORMALTEXTCOLOR');
  SaveIntegerItem(GMVAbnormalBkgd, 'ABNORMALBGCOLOR');
//  SaveIntegerItem(GMVAbnormalTodayBkgd: integer = 15;
  SaveBooleanItem(GMVAbnormalBold, 'ABNORMALBOLD');
  SaveBooleanItem(GMVAbnormalQuals, 'ABNORMALQUALIFIERS');

  SaveIntegerItem(GMVNormalText, 'NORMALTEXTCOLOR');
  SaveIntegerItem(GMVNormalBkgd, 'NORMALBGCOLOR');;
//  SaveIntegerItem(GMVNormalTodayBkgd: integer = 15;
  SaveBooleanItem(GMVNormalBold, 'NORMALBOLD');
  SaveBooleanItem(GMVNormalQuals, 'NORMALQUALIFIERS');


end;

procedure TfraGMV_GridGraph.RestoreUserPreferences;
var
  s: String;

  function getBoolean(aDefault:Boolean; aName,aTrueString:String):Boolean;
  var
    ss: String;
  begin
    ss := getUserSettings(aName);
    Result := ss = aTrueString;
  end;

  function getInteger(aDefault:Integer;aName:String):Integer;
  var
    ss: String;
  begin
    ss := getUserSettings(aName);
    if ss = '' then
      Result := aDefault
    else
      try
        Result := StrToIntDef(ss,aDefault);
      except
        Result := aDefault;
      end;
  end;

begin
  s := getUserSettings('GRIDSIZE');
  if s <> '' then pnlGrid.Height := StrToInt(s);

  BGColor := getInteger(clWindow,'GRAPHCOLOR');

  s := getUserSettings('GRAPHOPTIONS');
  pnlGraphOptions.Visible := s <> 'OFF';

  cbValues.Checked := getBoolean(TRUE,'GRAPHOPTIONS-1','ON');

  s := getUserSettings('GRAPHOPTIONS-4');
  inc(iIgnoreCount);
  cbChrono.Checked := s <> 'OFF';
  dec(iIgnoreCount);


  s := getUserSettings('GRAPHOPTIONS-3');
  cbAllowZoom.Checked := s='ON';
  chrtVitals.AllowZoom := s='ON';
  acZoom.Execute;

  s := getUserSettings('GRAPHOPTIONS-2');
  ckb3D.Checked := (s='ON') and cbChrono.Checked;
  ckb3D.Enabled := cbChrono.Checked;

  if FrameStyle = fsVitals then
    begin
      s := getUserSettings('GRAPH_INDEX');
      if s <> '' then
          GraphIndex:= StrToInt(s)
      else
          GraphIndex:= 0;

      GridRow:= GridRowByGraphIndex(GraphIndex);
    end;


  GMVAbnormalText := getInteger(GMVAbnormalText,'ABNORMALTEXTCOLOR');
  GMVAbnormalBkgd := getInteger(GMVAbnormalBkgd, 'ABNORMALBGCOLOR');
//  SaveIntegerItem(GMVAbnormalTodayBkgd: integer = 15;
  GMVAbnormalBold := getBoolean(GMVAbnormalBold, 'ABNORMALBOLD','ON');
  GMVAbnormalQuals := getBoolean(GMVAbnormalQuals, 'ABNORMALQUALIFIERS','ON');

  GMVNormalText := getInteger(GMVNormalText, 'NORMALTEXTCOLOR');
  GMVNormalBkgd := getInteger(GMVNormalBkgd, 'NORMALBGCOLOR');;
//  SaveIntegerItem(GMVNormalTodayBkgd: integer = 15;
  GMVNormalBold := getBoolean(GMVNormalBold, 'NORMALBOLD','ON');
  GMVNormalQuals := getBoolean(GMVNormalQuals, 'NORMALQUALIFIERS','ON');

  grdVitals.Invalidate;
end;

procedure TfraGMV_GridGraph.setGraphByABBR(aABBR:String);
var
  aRow: Integer;
begin
  //kt make changes here
  case VitalTypeByABBR(aABBR) of
    vtTemp:aRow := 1;
    vtPulse:aRow := 2;
    vtResp: aRow := 3;
    vtPO2: aRow := 4;
    vtBP: aRow := 6;
    vtHeight: aRow := 9;
    vtWeight: aRow := 7;
//    vtBMI: aRow := 8;
    vtCircum: aRow := 10;
    vtCVP: aRow := 11;
//    vtIn: aRow := 8;
//    vtOutput: aRow := 8;
    vtPain: aRow := 14;
  else
    aRow := 0;
  end;

  grdVitals.Invalidate;

  getGraphByName(GraphNameByGridRow(aRow));
  if GraphIndexByGridRow(aRow) <> iIgnoreGraph then
    fGridRow := aRow;
//  fGraphIndex := GraphIndexByGridRow(aRow);
  GraphIndex := GraphIndexByGridRow(aRow);
  grdVitals.Invalidate;
end;

procedure TfraGMV_GridGraph.chrtVitalsClickLegend(Sender: TCustomChart;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  sF = '%-20s';
  sNA = 'N/A';

var
    i,j,k,m: Integer;
    sName,sLocation,
    s,ss,s4: String;
    ST,
    SL: TStringList;

  function RowByName(aName:String):Integer;
  begin
    Result := -1;
    if (aName = sgnTemp) or (aName = 'Temp.') then
      Result := 1
    else  if (aName = sgnPulse) or (aName = 'Pulse') then
      Result := 2
    else  if (aName = sgnResp) or (aName = 'Resp.') then Result := 3
    else  if (aName = 'Pulse Ox.') then Result := 4
    else  if (aName = 'Sys.') then Result := 6
    else  if (aName = 'Dias.') then Result := -1
    else  if (aName = sgnWeight) then Result := 7
    else  if (aName = 'BMI') then Result := 8
    else  if (aName = sgnHeight) then Result := 9

    else  if (aName = sgnGirth) then Result := 10
    else  if (aName = sgnCVP) then Result := 11
    else  if (aName = sgnIn) then Result := 12
    else  if (aName = sgnOutput) then Result := 13

    else  if (aName = sgnPain) then Result := 14
    ;
  end;

begin
  SL := TStringList.Create;
  ST := TStringList.Create;
  ss := Format(sF,['Date/Time']);
  for i := 0 to chrtVitals.SeriesCount - 1 do
    begin
      if not chrtVitals.Series[i].Active then continue;
      s := chrtVitals.Series[i].Title;
      j := RowByName(s);
      if j < 0 then continue;
      if s = 'Sys.' then s := 'B/P';
      ss := ss + Format(sF,[s]) ;
      ST.Add(Format(sF,[s]));
      ST.Objects[ST.Count-1] := Pointer(j);
      if j = 4 then
        begin
          ST.Add('');
          ST.Objects[ST.Count-1] := Pointer(5);
        end;
    end;
  ss := ss + Format(sF,['Location'])+Format(sF,['Entered By']);
  Sl.Add(ss);
  s := '';
  while length(s) < Length(ss) do s := s + '-';
  SL.Add(s);

  for i := 1 to grdVitals.ColCount - 1 do
    begin
      s := '';
      m := 0;
      for j := 0 to ST.Count - 1 do
        begin
          k := Integer(Pointer(ST.Objects[j]));
          ss := grdVitals.Cells[i, k];
          case k of
            4: s4 := ss;
            5: s := s + Format(sF,[s4+' '+ss]);
          else
            s := s + Format(sF,[ss]);
          end;
          if k <> 4 then inc(m);
        end;
      if trim(s) <> '' then
        begin
          sName := grdVitals.Cells[i,rUser]; if sName = '' then sName := sNA;         //elh 15 -> rUser 3/12/08
          sLocation := grdVitals.Cells[i,rLocation];  if sLocation = '' then sLocation := sNA;   //elh 16 -> rLocation  3/12/08

          k := m * 20;
          while (Length(s) > k) and (copy(s,Length(s),1)=' ') and (s<>'') do
            s := copy(s,1,Length(s)-1);
          if Length(s) = k then
            s := s + ' ';
          s := Format(sF,[grdVitals.Cells[i,0]]) + s + Format(sF,[sLocation]);
          k := (m+2) * 20;
          while (Length(s) > k) and (copy(s,Length(s),1)=' ') and (s<>'') do
            s := copy(s,1,Length(s)-1);
          if Length(s) = k then
            s := s + ' ';
          s := s + Format(sF,[sName]);
          SL.Add(s);
        end;
    end;

  ShowInfo('Results on '+getPatientName,SL.Text,True);

  SL.Free;
  ST.Free;
end;

procedure TfraGMV_GridGraph.acZoomOutExecute(Sender: TObject);
var
  d: Double;
  i: Integer;
begin
  if chrtVitals.LeftAxis.Maximum > iMaximumLimit then Exit;

  try
    i := StrToIntDef(edZoom.Text,50);
    if i > 100 then i := 100;
    if i = 100 then edZoom.Text := '100';
  except
    begin
      edZoom.Text := '50';
      i := 50;
    end;
  end;

  d := i/100;
  try
    chrtVitals.LeftAxis.Maximum := (1+d) * chrtVitals.LeftAxis.Maximum;
    if chrtVitals.LeftAxis.Minimum >=0 then
      chrtVitals.LeftAxis.Minimum := (1-d) * chrtVitals.LeftAxis.Minimum;
  except
    on E: Exception do
      ShowMessage('Zoom In'+#13#10+E.Message);
  end;
end;

procedure TfraGMV_GridGraph.acZoomInExecute(Sender: TObject);
var
  d: Double;
  i: Integer;
begin
  try
    i := StrToIntDef(edZoom.Text,50);
  except
    begin
      edZoom.Text := '50';
      i := 50;
    end;
  end;
  d := i/100;

  if ((1-d) * chrtVitals.LeftAxis.Maximum >= (1+d) * chrtVitals.LeftAxis.Minimum)  then
    begin
      try
        chrtVitals.LeftAxis.Maximum := (1-d) * chrtVitals.LeftAxis.Maximum;
        if chrtVitals.LeftAxis.Minimum >=0 then
          chrtVitals.LeftAxis.Minimum := (1+d) * chrtVitals.LeftAxis.Minimum;
      except
        on E: Exception do
          ShowMessage('Zoom Out'+#13#10+E.Message);
      end;
    end;
end;

procedure TfraGMV_GridGraph.acZoomResetExecute(Sender: TObject);
begin
  try
    chrtVitals.LeftAxis.Maximum := fAxisMax;
    chrtVitals.LeftAxis.Minimum := fAxisMin;
  except
    on E: Exception do
      ShowMessage('Zoom Reset '+#13#10+E.Message);
  end;
end;

procedure TfraGMV_GridGraph.splGridGraphMoved(Sender: TObject);
begin
  splGridGraph.Align := alTop;
  Application.ProcessMessages;

  splGridGraph.Align := alBottom;
  Application.ProcessMessages;
end;

////////////////////////////////////////////////////////////////////////////////
// debug //
////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.UpdateSB(aValue:String;Append:Boolean=False);
var
  ss: String;
begin
  if Append then
    ss := sbTest.SimpleText + ' '
  else
    ss := '';

  sbTest.SimpleText := ss +
    aValue + ' ' +
    FormatdateTime('mm/dd/yy hh:nn:ss',chrtVitals.BottomAxis.Minimum)+ ' -- ' +
    FormatdateTime('mm/dd/yy hh:nn:ss',chrtVitals.BottomAxis.Maximum);
end;

procedure TfraGMV_GridGraph.SpeedButton1Click(Sender: TObject);
begin
  updateSB(Format('W=%d  H=%d  SeriesW=%d  SeriesH=%d  ',
    [chrtVitals.Width3d,chrtVitals.Height3d,chrtVitals.SeriesWidth3d,chrtVitals.SeriesHeight3d]));
end;

procedure TfraGMV_GridGraph.chrtVitalsDblClick(Sender: TObject);
begin
{$IFDEF AANTEST}
  chrtVitals.CalcSize3DWalls;
  ShowMessage(Format('Width = %d Height = %d',[chrtVitals.Width3d,chrtVitals.Height3D]));
{$ENDIF}
end;

procedure TfraGMV_GridGraph.acUpdateGridColorsExecute(Sender: TObject);
begin
  UpdateUserSettings;
  BGTodayColor := GMVNormalTodayBkgd;
  try
  grdVitals.Refresh;
  except
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfraGMV_GridGraph.acPatientInfoExecute(Sender: TObject);
begin
  ShowPatientInfo(PatientDFN); // vhaishandria 060308
end;

procedure TfraGMV_GridGraph.pnlPtInfoEnter(Sender: TObject);
begin
  pnlPtInfo.BevelOuter := bvRaised; // vhaishandria 060308
end;

procedure TfraGMV_GridGraph.pnlPtInfoExit(Sender: TObject);
begin
  pnlPtInfo.BevelOuter := bvNone; // vhaishandria 060308
end;


{
procedure TfrmGMV_InputLite.pnlPatientClick(Sender: TObject);
begin
  acPatientInfo.Execute;
end;
}
procedure TfraGMV_GridGraph.setPatientInfoView(aName,anInfo:String);
begin
//  lblPatientName.Caption := aName;
//  lblPatientInfo.Caption := anInfo;
  edPatientName.Text := aName;
  edPatientInfo.Text := anInfo;
end;

function TfraGMV_GridGraph.getPatientName:String;
begin
//  Result := lblPatientName.Caption;
  Result := edPatientName.Text;
end;

function TfraGMV_GridGraph.getPatientInfo:String;
begin
//  Result := lblPatientInfo.Caption;
  Result := edPatientInfo.Text;
end;

procedure TfraGMV_GridGraph.showVitalsReport;
var
  StIME,
  sStart,sEnd,sLine,
  s,sItem,sVal: String;
  j,iEnd,iCount,
  iStart, iStartLine,
  i: integer;
begin
  s := '';
  iEnd := getVisibleColCount;
  if ScrollBarIsVisible then Dec(iEnd);
  if iEnd > grdVitals.ColCount-1 then
    iEnd := grdVitals.ColCount-1;
  iCount := 0;
  iStart := grdVitals.LeftCol;
  iEnd := iStart + iEnd -1;

  if fStyle = fsVitals then inc(iEnd); // vhaishandria 060314

{$IFDEF T20}
  // vhaishandria 060324 T20
  iStartLine := iStart +2;
  iStart := 1;
  iEnd := grdVitals.ColCount-1;
{$ENDIF}

  for i := iStart to iEnd do
    begin
      if (i = iStart) then
        sStart := grdVitals.Cells[i,0];
      if (i = iEnd) then
        sEnd := grdVitals.Cells[i,0];

//      s := s + Format(' %s',[grdVitals.Cells[i,0]]);
      sTime := Format(' %s',[grdVitals.Cells[i,0]]);
      sVal := '';
      sLine := '';
      for j := 1 to grdVitals.RowCount - 1 do
        begin
          sItem := grdVitals.Cells[i,j];
          if trim(sItem)<>'' then
            begin
              sLine := sLine + Format(' %s %s;',[grdVitals.Cells[0,j],sItem]);
              sVal := sVal + sItem;
            end;
        end;
////      if sLine <> '' then sLine := copy(sLine,1,length(sLine)-1);
//      s := s + sLine + #13#10;
      if Trim(sLine) <> '' then
        s := s + sTime + sLine + #13#10;
      if sVal <> '' then inc(iCount);
    end;
  if trim(lblHospital.Caption) <> '' then
    sLine := lblHospital.Caption
  else
    sLine :=  'no location selected';
  s :=
    'Patient Location: '+ sLine  +#13#10 +
    'Date Range: '+lblDateFromTitle.Caption + #13#10 +
    'The following '+IntToStr(iCount)+' lines are currently visible in the data grid display.'+#13#10 +
    s;
  ShowInfo('Data Grid Report for '+getPatientName+ ' ' + getPatientInfo,s, False,iStartLine);

end;

{
procedure TfraGMV_GridGraph.edPatientNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
      acPatientInfo.Execute;
end;
}

procedure TfraGMV_GridGraph.acVitalsReportExecute(Sender: TObject);
begin
  ShowVitalsReport;
end;

procedure TfraGMV_GridGraph.pnlPtInfoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPtInfo.BevelOuter := bvLowered; // vhaishandria 060308
end;

procedure TfraGMV_GridGraph.pnlPtInfoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPtInfo.BevelOuter := bvNone; // vhaishandria 060308
  acPatientInfo.Execute;
end;

end.
