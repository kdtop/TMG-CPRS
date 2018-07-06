unit uFlowsheet;
//kt 1/22/18

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, grids,
  StdCtrls, StrUtils, Math, DateUtils, ComCtrls, ExtCtrls, graphics,
  ORCtrls, ORFn, ORNet, Trpcb, {VA508AccessibilityManager,} mPCE_ACM,
  uHTMLTools, TMGHTML2, uPastINRs;

type
  tComplication = (tcmpUndefined = 0, tcmpMajorBleed = 1, tcmpClot = 2, tcmpMinorBleed=3);
  tDaysOfWeek = (daySun=1, dayMon=2, dayTue=3, dayWed=4, dayThur=5, dayFri=6, daySat=7, dTotal=8);
  tShowValue = (tsvKeptAppt = 0, tsvWithin1Day = 1, tsvNoShow = 2, tsvUnDef = 3);

  TNumTabsArrayForDay = array[tDaysOfWeek] of string;
  tGoalStatus = (tgsUndef, tgsLow, tgsNormal, tgsHigh);

CONST
  GOAL_STATUS_LABEL : array[tgsUndef .. tgsHigh] of String = ('', 'L', '', 'H');

  //====================================================
type
  TOneFlowsheet = class(TObject)
  private
    FldDateStr               : string;       //piece 1      -- Fileman date of the flow sheet entry
    FldDateTime              : TDateTime;    //from piece 1 -- Fileman date of the flow sheet entry
    FldPillStrength1         : string;       //piece 5
    FldPillStrength2         : string;       //piece 21  <-- note: shown out of order
    FldTotalWeeklyDose       : string;       //piece 6   <-- NOTE: this is used for storage for saving RPC, not as source of information
    FldDailyNumTabs1Str      : string;       //piece 22  e.g. '1|0|1|0.5|1|0|1'
    FldDailyNumTabs2Str      : string;       //piece 23  e.g. '0|1|0|0.5|0|1|0'
    FldDailyTotalMgsStr      : string;       //piece 7   e.g. '7.5|5|7.5|4.375|7.5|5|7.5'
    FldUsing2Pills           : boolean;
    FldINR                   : string;       //piece 3
    FldINRLabDateStr         : string;       //piece 24
    FldINRLabDateTime        : TDateTime;    //from piece 24
    FldLabDrawLoc            : string;       //piece 4, '|' piece 1
    FldLabDrawPhone          : string;       //piece 4, '|' piece 2
    FldLabDrawFax            : string;       //piece 4, '|' piece 3
    FldEntryCreationFMDT     : string;       //piece 9   --  Entry date/time of item into the file. (creation date)

    procedure SetDateStr(Value: string);
    procedure SetDateTime(Value: TDateTime);
    procedure SetINRLabDateStr(Value: string);
    procedure SetINRLabDateTime(Value: TDateTime);
    function  GetComplicationCode : tComplication;
    function  GetfPillStrength1 : single;
    procedure SetfPillStrength1(Value : single);
    function  GetfPillStrength2 : single;
    procedure SetfPillStrength2(Value : single);
    procedure SetPillStrength1(Value : string);
    procedure SetPillStrength2(Value : string);
    function  GetMgForDay(Day : tDaysOfWeek) : string;
    function  GetfMgForDay(Day : tDaysOfWeek) : single;
    function  GetfNumTabs1ForDay(Day : tDaysOfWeek) : single;
    procedure SetfNumTabs1ForDay(Day : tDaysOfWeek; const Value : single);
    function  GetfNumTabs2ForDay(Day : tDaysOfWeek) : single;
    procedure SetfNumTabs2ForDay(Day : tDaysOfWeek; const Value : single);
    function  GetNumTabs1ForDay(Day : tDaysOfWeek) : string;
    procedure SetNumTabs1ForDay(Day : tDaysOfWeek; const Value : string);
    function  GetNumTabs2ForDay(Day : tDaysOfWeek) : string;
    procedure SetNumTabs2ForDay(Day : tDaysOfWeek; const Value : string);
    procedure SetUsingTwoPills(Value: boolean);
    procedure RecalcTMGDailyNumTabs1Str;
    procedure RecalcTMGDailyNumTabs2Str;
    procedure RecalcTMGDailyTotalMgsStr;
    procedure Recalculate;
    function  GetStrINRGoalHigh : string;
    function  GetStrINRGoalLow : string;
    function  GetfINRGoalHigh : single;
    function  GetfINRGoalLow : single;
    function  GetfINR : single;
    function  GetLabInfoStr : string;
    function  GetHgbOrHctInfoStr : string;
    function  GetHumanReadableRegimenX(Pillstrength : string; NumTabsXForDay : TNumTabsArrayForDay) : string;
    function  GetHumanReadableRegimen1 : string;
    function  GetHumanReadableRegimen2 : string;
    function  GetHumanReadableRegimenCombinedForDay(Day : tDaysOfWeek) : string;
    function  GetIsRetracted : boolean;
    function  GetINRGoalStatus : tGoalStatus;
    function  GetINRGoalStatusLabel : string;
    function  GetFMDT : TFMDateTime;
    function  GetFMDTStr : string;
  public
    RawData                  : string;
    DFN                      : string;
    //Moved to Private                       //piece 1
    subIEN                   : string;       //piece 2
    //Moved to Private                       //piece 3
    //Moved to Private                       //piece 4
    //Moved to Private                       //piece 5
    //Moved to Private                       //piece 21  <-- note: shown out of order
    //Moved to Private                       //piece 6
    PriorTWD                 : string;       //Not from server.  Used locally, on client, for comparing current to past.
    DailyDosingStr           : string;       //piece 7
    PatientNotice            : string;       //piece 8
    //Moved to Private                       //piece 9   --  Entry date/time of item into the file. (creation date)
    Provider                 : string;       //piece 10
    CurrentIndication        : string;       //piece 11
    CurrentINRGoal           : string;       //piece 12
    AppointmentShowStatus    : tShowValue;   //piece 13  (ie. no-show, vs show.  This is a set)
    TMGRetractionDate        : TDateTime;    //piece 20
    //Moved to Private                       //piece 22
    //Moved to Private                       //piece 23
    //Moved to Private                       //piece 24
    ComplicationScore        : Integer;
    Comments                 : TStringList;
    Complications            : TStringList;
    FldNumTabs1ForDayArray   : TNumTabsArrayForDay;
    FldNumTabs2ForDayArray   : TNumTabsArrayForDay;
    HctOrHgbValue            : string;  //will be 'Hgb: # on <date>'  or 'Hct: # on <date>'
    DosingSuggested          : boolean;
    SuspendRecalculation     : boolean;
    NewINREntered            : boolean;
    DosingEdited             : boolean;
    // ---------------------
    DoseTakeNumMgToday       : string;
    DoseHoldNumOfDays        : string;
    DocsPtMoved              : boolean;
    DocsPtTransferTo         : string;
    //DocsHTMLSL               : TStringList;
    PatientInstructions      : TStringList;


    //Below are duplicates of data found in TPatient and TAppSate
    //But they are also used for creating documentation for a single flowsheet event, and are
    //  store in flowsheet.  So I need fields here to hold that data
    //**Don't use these as primary data sources.  Use the fields in TPatient and TAppsate.
    DocsAppointmentNoShowDate : TDateTime;
    DocsViolatedAgreement     : Boolean;
    DocsDischargedReason      : string;
    DocsDischargedDate        : TDateTime;

    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Source : TOneFlowsheet); overload;
    function  EqualTo(Other : TOneFlowsheet) : boolean;
    procedure LimitedAssign(Source : TOneFlowsheet);
    procedure AssignJustDosing(Source : TOneFlowsheet);
    procedure LoadINRInfoFromPrior(OnePastINRValue : TOnePastINRValue);
    function  INRIsHigh : boolean;
    function  INRIsLow : boolean;
    function  HiLoOrNormalNarrative: string;
    procedure SetTMGDailyNumTabs1Str(FullValue : string);
    procedure SetTMGDailyNumTabs2Str(FullValue : string);
    function MgsForDayStr : string;              //'e.g. '5|6|5|7.5|3|5|3'
    function fTotalMgs1ForWeek : single;
    function fTotalMgs2ForWeek : single;
    function TotalMgs1ForWeek : string;
    function TotalMgs2ForWeek : string;
    function TotalNumTabs1ForWeek : string;
    function TotalNumTabs2ForWeek : string;
    function fTotalWeeklyDose : single;
    function TotalWeeklyDose : string;
    function fPriorTWD : single;
    function fPctChange : single;
    function PctChange : string;
    function ComplicationsEncodedStr : string;
    procedure ForceOverwriteFldTotalWeeklyDose(Value : string); //should only be used for OLD  flowsheets, not current on (will get overwritten)
    procedure PullDosingInfoFromScreen(sgDosingData : TStringGrid; cboPS, cboPS2 : TComboBox);
    procedure OutputCalculatedFields(sgDosingData : TStringGrid);
    procedure SaveToServer(UntypedAppState : TObject);  //AppState must be TAppState
    procedure SaveToExistingServerRecord(UntypedAppState : TObject); //DEPRECIATED
    procedure LoadINRInfo(Source: TOnePastINRValue);
    procedure OutputInfo(SL : TStrings);
    //--------------------------------------------------------
    property ComplicationCode : tComplication read GetComplicationCode;
    property PillStrength1 : string read FldPillStrength1 write SetPillStrength1;
    property PillStrength2 : string read FldPillStrength2 write SetPillStrength2;
    property fPillStrength1 : single read GetfPillStrength1 write SetfPillStrength1;
    property fPillStrength2 : single read GetfPillStrength2 write SetfPillStrength2;
    property MgForDay[Day : tDaysOfWeek] : string read GetMgForDay;
    property fMgForDay[Day : tDaysOfWeek] : single read GetfMgForDay;
    property fNumTabs1ForDay[Day : tDaysOfWeek] : single read GetfNumTabs1ForDay write SetfNumTabs1ForDay;
    property fNumTabs2ForDay[Day : tDaysOfWeek] : single read GetfNumTabs2ForDay write SetfNumTabs2ForDay;
    property NumTabs1ForDay[Day : tDaysOfWeek] : string read GetNumTabs1ForDay write SetNumTabs1ForDay;
    property NumTabs2ForDay[Day : tDaysOfWeek] : string read GetNumTabs2ForDay write SetNumTabs2ForDay;
    property DailyNumTabs1Str : string read FldDailyNumTabs1Str;
    property DailyNumTabs2Str : string read FldDailyNumTabs2Str;
    property HumanReadableRegimen1 : string read GetHumanReadableRegimen1;
    property HumanReadableRegimen2 : string read GetHumanReadableRegimen2;
    property HumanReadableRegimenCombinedForDay[Day : tDaysOfWeek] : string read GetHumanReadableRegimenCombinedForDay;
    property DailyTotalMgsStr : string read FldDailyTotalMgsStr;
    property UsingTwoPills : boolean read FldUsing2Pills write SetUsingTwoPills;
    property DateStr : string read FldDateStr write SetDateStr;
    property DateTime : TDateTime read FldDateTime write SetDateTime;
    property FMDateTime : TFMDateTime read GetFMDT;
    property FMDateTimeStr : string read GetFMDTStr;
    property INR : string read FldINR write FldINR;
    property fINR : single read GetfINR;
    property INRLabDateStr : string read FldINRLabDateStr write SetINRLabDateStr;
    property INRLabDateTime : TDateTime read FldINRLabDateTime write SetINRLabDateTime;
    property INRGoalStatus : tGoalStatus read GetINRGoalStatus;
    property INRGoalStatusLabel : string read GetINRGoalStatusLabel;
    property LabDrawLoc  : string read FldLabDrawLoc write FldLabDrawLoc;
    property LabDrawPhone : string read FldLabDrawPhone write FldLabDrawPhone;
    property LabDrawFax : string read FldLabDrawFax write FldLabDrawFax;
    property fINRGoalHigh : single read GetfINRGoalHigh;
    property fINRGoalLow : single read GetfINRGoalLow;
    property strINRGoalHigh : string read GetStrINRGoalHigh;
    property strINRGoalLow : string read GetStrINRGoalLow;
    property LabInfoStr : string read GetLabInfoStr;
    property HgbOrHctInfoStr : string read GetHgbOrHctInfoStr;
    property EntryCreationFMDT : string read FldEntryCreationFMDT write FldEntryCreationFMDT; //NOTE: should treat as read only because when saving to server, RPC server code overwrites with NOW
    property Retracted : boolean read GetIsRetracted;
  end;


  TPatientFlowsheetData = class(TObject)
  //This will be a list of TOneFlowsheet entries.
  private
    FList : TList;
    function GetFlowsheet(index : integer) : TOneFlowsheet;
    procedure SetFlowsheet(Index : integer; Value : TOneFlowsheet);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Value : TOneFlowsheet) : integer;  //returns index of added object, 0 based
    function AddOneBlank : TOneFlowsheet;
    procedure ExtractINRData(UntypedAppState : TObject);
    function MostRecent : TOneFlowsheet; //returns nil if none available.
    function Count : integer;
    procedure ParsePatientData(DFN : string; RPCResults : TStrings);
    procedure LoadFromServer(DFN : string);
    procedure Clear();
    procedure Assign(Source : TPatientFlowsheetData);
    function IndexOf(AFlowsheet : TOneFlowsheet) : integer;
    property Flowsheet[index : integer] : TOneFlowsheet read GetFlowsheet write SetFlowsheet; default;
  end;

implementation

uses
  uTypesACM, rRPCsACM, uUtility;


constructor TOneFlowsheet.Create;
begin
  inherited Create;
  Comments            := TStringList.Create;
  Complications       := TStringList.Create;
  PatientInstructions := TStringList.Create;
  //DocsHTMLSL          := TStringList.Create;
  //kt OnePastINRValue := TOnePastINRValue.Create;
  Clear;
end;

procedure TOneFlowsheet.Clear;
var ADay : tDaysOfWeek;
begin
  RawData                                           := '';
  DFN                                               := '';
  DateStr                                           := '';
  DateTime                                          := 0;
  subIEN                                            := '';
  INR                                               := '';
  LabDrawLoc                                        := '';
  LabDrawPhone                                      := '';
  LabDrawFax                                        := '';
  PillStrength1                                     := '';
  PillStrength2                                     := '';
  FldTotalWeeklyDose                                := '';
  DailyDosingStr                                    := '';
  PatientNotice                                     := '';
  FldEntryCreationFMDT                              := '';
  Provider                                          := '';
  CurrentIndication                                 := '';
  CurrentINRGoal                                    := '';
  AppointmentShowStatus                             := tsvUnDef;
  FldDailyNumTabs1Str                               := '';
  FldDailyNumTabs2Str                               := '';
  FldUsing2Pills                                    := false;
  ComplicationScore                                 := 0;
  Comments.Clear;
  Complications.Clear;
  for ADay := daySun to dTotal do FldNumTabs1ForDayArray[ADay]  := '';
  for ADay := daySun to dTotal do FldNumTabs2ForDayArray[ADay]  := '';
  HctOrHgbValue                                     := '';
  DosingSuggested                                   := false;
  NewINREntered                                     := false;
  DosingEdited                                      := false;
  //--------------------------
  DoseTakeNumMgToday                                := '';
  DoseHoldNumOfDays                                 := '';
  DocsPtMoved                                       := false;
  DocsPtTransferTo                                  := '';
  //DocsHTMLSL.Clear;
  PatientInstructions.Clear;
  DocsAppointmentNoShowDate                         := 0;
  DocsViolatedAgreement                             := false;
  DocsDischargedReason                              := '';
  DocsDischargedDate                                := 0;
end;


procedure TOneFlowsheet.SaveToExistingServerRecord(UntypedAppState : TObject);
//Depreciated code.
//Note: This is taken from the original code that saves changes when
//  and old flowsheet is edited.  But it doesn't seem to save everything
//  that could be saved.
var SL : TStringList;
    i : integer;
    strFMDate : string;
    AppState : TAppstate;
    Provider : TProvider;

begin
  if not (UntypedAppState is TAppState) then exit;
  AppState := TAppState(UntypedAppState);
  Provider := AppState.Provider;
  SL := TStringList.Create;
  try
    SL.Add(DFN);
    SL.Add(subIEN);
    SL.Add(DateStr);
    SL.Add(INR);
    SL.Add(PatientNotice);
    SL.Add(TotalWeeklyDose);
    SL.Add(Provider.Name);
    SL.Add(IntToStr(Comments.Count));
    for i := 0 to Comments.Count - 1 do SL.Add(Comments[i]);
    SL.Add(IntToStr(Complications.Count));
    for i := 0 to Complications.Count - 1 do SL.Add(Complications[i]);
    if TMGRetractionDate > 0 then begin
      strFMDate := FloatToStr(DateTimeToFMDateTime(TMGRetractionDate));
    end else begin
      strFMDate := '@'
    end;
    SL.Add('TMGFLD^22700^'+strFMDate);
    SaveExistingFlowsheetEntry(SL, ComplicationCode);
  finally
    SL.Free;
  end;
end;


procedure TOneFlowsheet.LoadINRInfo(Source: TOnePastINRValue);
begin
  if Assigned(Source) then begin
    Self.INR            := Source.INR;
    Self.INRLabDateTime := Source.DateTime;
    Self.LabDrawLoc     := Source.LabDrawLoc;
    Self.LabDrawPhone   := Source.LabDrawPhone;
    Self.LabDrawFax     := Source.LabDrawFax;
  end else begin
    Self.INR            := '';
    Self.INRLabDateTime := 0;
    Self.LabDrawLoc     := '';
    Self.LabDrawPhone   := '';
    Self.LabDrawFax     := '';
  end;
end;

procedure TOneFlowsheet.OutputInfo(SL : TStrings);
begin
  SL.Assign(Comments);
  SL.Add('--- Debug Info ---');
  SL.Add('SubIEN: ' + SubIEN);
  SL.Add('Flowsheet Date: ' + Self.DateStr);
  SL.Add('INR Lab Date: ' + INRLabDateStr);
  if TMGRetractionDate > 0 then begin
    SL.Add('TMGRetractionDate: ' + DateToStr(TMGRetractionDate));
  end;
  SL.Add('Dosing:  ' + HumanReadableRegimen1);
  if Self.UsingTwoPills then begin
    SL.Add('Dosing2: ' + HumanReadableRegimen2);
  end;
end;



procedure TOneFlowsheet.SaveToServer(UntypedAppState : TObject);  //AppState must be TAppState
var AppState : TAppstate;
    ErrStr : string;
begin
 if not (UntypedAppState is TAppState) then exit;
 AppState := TAppState(UntypedAppState);
 if SaveFlowsheetToServer(self, AppState, ErrStr) = false then begin
     InfoBox('Problem encountered saving data:' + CRLF +
            '"'+ErrStr+'"',
            'Problem saving Flowsheet.', MB_OK or MB_ICONEXCLAMATION);
 end;
end;

{
procedure SaveFlowsheetEntry(SL : TStrings; ComplicationCode : tComplication);
var j : integer;
    Count : integer;
//Expected input:
//  SL[7] = <count of following comment lines>
//  SL[8...] = <lines of text of comments>
// ComplicationCode =  1  <- MAJOR BLEED
//                     2  <- CLOT
//                     3  <- MINOR BLEED
}

procedure TOneFlowsheet.Assign(Source : TOneFlowsheet);
begin
  //NOTE: there is probably a faster way of doing this.  But I'm not sure if
  //    self.assign(Source) will keep things safe.  So will just do manually.
  if not assigned(Source) then begin
    Clear();
    exit;
  end;
  if Source = Self then exit;
  FldLabDrawLoc             := Source.FldLabDrawLoc;
  FldLabDrawPhone           := Source.FldLabDrawPhone;
  FldLabDrawFax             := Source.FldLabDrawFax;
  FldINR                    := Source.FldINR;
  FldPillStrength1          := Source.FldPillStrength1;
  FldPillStrength2          := Source.FldPillStrength2;
  FldNumTabs1ForDayArray    := Source.FldNumTabs1ForDayArray;
  FldNumTabs2ForDayArray    := Source.FldNumTabs2ForDayArray;
  FldDailyTotalMgsStr       := Source.FldDailyTotalMgsStr;
  FldINRLabDateStr          := Source.FldINRLabDateStr;
  FldINRLabDateTime         := Source.FldINRLabDateTime;
  FldTotalWeeklyDose        := Source.FldTotalWeeklyDose;
  FldUsing2Pills            := Source.FldUsing2Pills;
  FldDailyNumTabs1Str       := Source.FldDailyNumTabs1Str; //DailyNumTabs1Str;
  FldDailyNumTabs2Str       := Source.FldDailyNumTabs2Str; //DailyNumTabs2Str;
  FldDateStr                := Source.FldDateStr;
  FldDateTime               := Source.FldDateTime;
  FldEntryCreationFMDT      := Source.FldEntryCreationFMDT;

  RawData                   := Source.RawData;
  DFN                       := Source.DFN;
  subIEN                    := Source.subIEN;
  DailyDosingStr            := Source.DailyDosingStr;
  PatientNotice             := Source.PatientNotice;
  Provider                  := Source.Provider;
  CurrentIndication         := Source.CurrentIndication;
  CurrentINRGoal            := Source.CurrentINRGoal;
  AppointmentShowStatus     := Source.AppointmentShowStatus;
  HctOrHgbValue             := Source.HctOrHgbValue;
  DosingSuggested           := Source.DosingSuggested;
  ComplicationScore         := Source.ComplicationScore;
  SuspendRecalculation      := Source.SuspendRecalculation;
  TMGRetractionDate         := Source.TMGRetractionDate;
  PriorTWD                  := Source.PriorTWD;
  NewINREntered             := Source.NewINREntered;
  DosingEdited              := Source.DosingEdited;
  //---------------------
  DoseTakeNumMgToday        := Source.DoseTakeNumMgToday;
  DoseHoldNumOfDays         := Source.DoseHoldNumOfDays;
  DocsPtMoved               := Source.DocsPtMoved;
  DocsPtTransferTo          := Source.DocsPtTransferTo;

  PatientInstructions.Assign(Source.PatientInstructions);
  //DocsHTMLSL.Assign(Source.DocsHTMLSL);

  DocsAppointmentNoShowDate := Source.DocsAppointmentNoShowDate;
  DocsViolatedAgreement     := Source.DocsViolatedAgreement;
  DocsDischargedReason      := Source.DocsDischargedReason;
  DocsDischargedDate        := Source.DocsDischargedDate;

  Comments.Assign(Source.Comments);
  Complications.Assign(Source.Complications);
end;

function TOneFlowsheet.EqualTo(Other : TOneFlowsheet) : boolean;

  function EqualArrayForDay(A, B : TNumTabsArrayForDay) : boolean;
  var ADay : tDaysOfWeek;
  begin
    Result := false;
    for ADay := daySun to DaySat do begin
      if A[ADay] <> B[ADay] then exit;
    end;
    Result := true;
  end;

begin
  Result := false;
  if not assigned(Other) then exit;
  if FldLabDrawLoc             <> Other.FldLabDrawLoc then exit;
  if FldLabDrawPhone           <> Other.FldLabDrawPhone then exit;
  if FldLabDrawFax             <> Other.FldLabDrawFax then exit;
  if FldINR                    <> Other.FldINR then exit;
  if FldPillStrength1          <> Other.FldPillStrength1 then exit;
  if FldPillStrength2          <> Other.FldPillStrength2 then exit;
  if not EqualArrayForDay(FldNumTabs1ForDayArray, Other.FldNumTabs1ForDayArray) then exit;
  if not EqualArrayForDay(FldNumTabs2ForDayArray, Other.FldNumTabs2ForDayArray) then exit;
  if FldDailyTotalMgsStr       <> Other.FldDailyTotalMgsStr then exit;
  if FldINRLabDateStr          <> Other.FldINRLabDateStr then exit;
  if FldINRLabDateTime         <> Other.FldINRLabDateTime then exit;
  if FldTotalWeeklyDose        <> Other.FldTotalWeeklyDose then exit;
  if FldUsing2Pills            <> Other.FldUsing2Pills then exit;
  if FldDailyNumTabs1Str       <> Other.FldDailyNumTabs1Str then exit;
  if FldDailyNumTabs2Str       <> Other.FldDailyNumTabs2Str then exit;
  if FldDateStr                <> Other.FldDateStr then exit;
  if FldDateTime               <> Other.FldDateTime then exit;
  if FldEntryCreationFMDT      <> Other.FldEntryCreationFMDT then exit;
  if RawData                   <> Other.RawData then exit;
  if DFN                       <> Other.DFN then exit;
  if subIEN                    <> Other.subIEN then exit;
  if DailyDosingStr            <> Other.DailyDosingStr then exit;
  if PatientNotice             <> Other.PatientNotice then exit;
  if Provider                  <> Other.Provider then exit;
  if CurrentIndication         <> Other.CurrentIndication then exit;
  if CurrentINRGoal            <> Other.CurrentINRGoal then exit;
  if AppointmentShowStatus     <> Other.AppointmentShowStatus then exit;
  if HctOrHgbValue             <> Other.HctOrHgbValue then exit;
  if DosingSuggested           <> Other.DosingSuggested then exit;
  if ComplicationScore         <> Other.ComplicationScore then exit;
  if SuspendRecalculation      <> Other.SuspendRecalculation then exit;
  if TMGRetractionDate         <> Other.TMGRetractionDate then exit;
  if PriorTWD                  <> Other.PriorTWD then exit;
  if NewINREntered             <> Other.NewINREntered then exit;
  if DosingEdited              <> Other.DosingEdited then exit;
  if DoseTakeNumMgToday        <> Other.DoseTakeNumMgToday then exit;
  if DoseHoldNumOfDays         <> Other.DoseHoldNumOfDays then exit;
  if DocsPtMoved               <> Other.DocsPtMoved then exit;
  if DocsPtTransferTo          <> Other.DocsPtTransferTo then exit;

  if DocsAppointmentNoShowDate <> Other.DocsAppointmentNoShowDate then exit;
  if DocsViolatedAgreement     <> Other.DocsViolatedAgreement then exit;
  if DocsDischargedReason      <> Other.DocsDischargedReason then exit;
  if DocsDischargedDate        <> Other.DocsDischargedDate then exit;
  if not EqualSL(PatientInstructions, Other.PatientInstructions) then exit;
  //if not EqualSL(DocsHTMLSL, Other.DocsHTMLSL) then exit;
  if not EqualSL(Comments, Other.Comments) then exit;
  if not EqualSL(Complications, Other.Complications) then exit;
  Result := true; //true if we passed all the tests above.
end;

procedure TOneFlowsheet.LimitedAssign(Source : TOneFlowsheet);
begin
  if not assigned(Source) then begin
    Clear();
    exit;
  end;
  if Source = Self then exit;
  FldNumTabs1ForDayArray    := Source.FldNumTabs1ForDayArray;
  FldNumTabs2ForDayArray    := Source.FldNumTabs2ForDayArray;
  FldDailyTotalMgsStr       := Source.FldDailyTotalMgsStr;
  //FldINRLabDateStr          := Source.FldINRLabDateStr;
  //FldINRLabDateTime         := Source.FldINRLabDateTime;
  FldTotalWeeklyDose        := Source.FldTotalWeeklyDose;
  FldUsing2Pills            := Source.FldUsing2Pills;
  FldDailyNumTabs1Str       := Source.FldDailyNumTabs1Str; //DailyNumTabs1Str;
  FldDailyNumTabs2Str       := Source.FldDailyNumTabs2Str; //DailyNumTabs2Str;
  FldPillStrength1          := Source.FldPillStrength1;
  FldPillStrength2          := Source.FldPillStrength2;
  DFN                       := Source.DFN;
  DailyDosingStr            := Source.DailyDosingStr;
  CurrentIndication         := Source.CurrentIndication;
  CurrentINRGoal            := Source.CurrentINRGoal;
  PriorTWD                  := Source.PriorTWD;
end;


procedure TOneFlowsheet.AssignJustDosing(Source : TOneFlowsheet);
begin
  if not assigned(Source) then begin
    Clear();
    exit;
  end;
  if Source = Self then exit;
  PillStrength1             := Source.PillStrength1;
  PillStrength2             := Source.PillStrength2;
  FldTotalWeeklyDose        := Source.FldTotalWeeklyDose;
  DailyDosingStr            := Source.DailyDosingStr;
  FldDailyNumTabs1Str       := Source.DailyNumTabs1Str;
  FldDailyNumTabs2Str       := Source.DailyNumTabs2Str;
  FldNumTabs1ForDayArray    := Source.FldNumTabs1ForDayArray;
  FldNumTabs2ForDayArray    := Source.FldNumTabs2ForDayArray;
  FldUsing2Pills            := Source.FldUsing2Pills;
  Recalculate;
end;

procedure TOneFlowsheet.LoadINRInfoFromPrior(OnePastINRValue : TOnePastINRValue);
begin
  //To do -- investigate, is this used??
end;

function  TOneFlowsheet.INRIsHigh : boolean;
begin
  Result := (fINR > fINRGoalHigh);
end;

function  TOneFlowsheet.INRIsLow : boolean;
begin
  Result := (fINR < fINRGoalLow);
end;

function  TOneFlowsheet.HiLoOrNormalNarrative: string;
begin
  if INRIsHigh then begin
    Result := 'Too high';
  end else if INRIsLow then begin
    Result := 'Too low';
  end else begin
    Result := 'In target goal range';
  end;
end;


procedure TOneFlowsheet.SetDateStr(Value: string);
begin
  FldDateStr := Value;
  FldDateTime := StrToDateDef(FldDateStr, 0);
end;

procedure TOneFlowsheet.SetDateTime(Value: TDateTime);
begin
  FldDateTime := Value;
  FldDateStr := DateToStr(FldDateTime);
end;

procedure TOneFlowsheet.SetINRLabDateStr(Value: string);
begin
  FldINRLabDateStr := Value;
  FldINRLabDateTime := StrToDateDef(FldINRLabDateStr, 0);
end;

procedure TOneFlowsheet.SetINRLabDateTime(Value: TDateTime);
begin
  FldINRLabDateTime := Value;
  FldINRLabDateStr := DateToStr(FldINRLabDateTime);
end;

function TOneFlowsheet.GetComplicationCode : tComplication;
//This is set up to mirror code found in server RPC calls
begin
  if ComplicationScore >= 100 then begin
    Result := tcmpClot;
  end else if ComplicationScore >= 10 then begin
    Result := tcmpMajorBleed;
  end else if ComplicationScore = 10 then begin
    Result := tcmpMinorBleed;
  end else begin
    Result := tcmpUndefined;
  end;
end;

function TOneFlowsheet.ComplicationsEncodedStr : string;
begin
  Result := IntToStr(ComplicationScore) + '|' + ListToPieces(Complications);
end;


function TOneFlowsheet.GetfPillStrength1 : single;
begin
  result := StrToFloatDef(PillStrength1, 0);
end;

procedure TOneFlowsheet.SetfPillStrength1(Value : single);
begin
  PillStrength1 := TMGFloatToStr(Value);
  Recalculate;
end;

function TOneFlowsheet.GetfPillStrength2 : single;
begin
  result := StrToFloatDef(PillStrength2, 0);
end;

procedure TOneFlowsheet.SetfPillStrength2(Value : single);
begin
  PillStrength2 := TMGFloatToStr(Value);
  Recalculate;
end;

procedure TOneFlowsheet.SetPillStrength1(Value : string);
begin
  FldPillStrength1 := Value;
  Recalculate;
end;

procedure TOneFlowsheet.SetPillStrength2(Value : string);
begin
  FldPillStrength2 := Value;
  Recalculate;
end;

function TOneFlowsheet.GetMgForDay(Day : tDaysOfWeek) : string;
begin
  Result := TMGFloatToStr(GetfMgForDay(Day));
end;

function TOneFlowsheet.GetfMgForDay(Day : tDaysOfWeek) : single;
var value : single;
begin
  Result := GetfPillStrength1 * GetfNumTabs1ForDay(Day);
  if FldUsing2Pills then begin
    value := GetfPillStrength2 * GetfNumTabs2ForDay(Day);
    Result := Result + value;
  end;

end;

function TOneFlowsheet.GetfNumTabs1ForDay(Day : tDaysOfWeek) : single;
begin
  Result := StrToFloatDef(FldNumTabs1ForDayArray[Day], 0);
end;

procedure TOneFlowsheet.SetfNumTabs1ForDay(Day : tDaysOfWeek; const Value : single);
begin
  NumTabs1ForDay[Day] := TMGFloatToStr(Value);
  Recalculate;
end;

function TOneFlowsheet.GetfNumTabs2ForDay(Day : tDaysOfWeek) : single;
begin
  Result := StrToFloatDef(FldNumTabs2ForDayArray[Day], 0);
end;

procedure TOneFlowsheet.SetfNumTabs2ForDay(Day : tDaysOfWeek; const Value : single);
begin
  NumTabs2ForDay[Day] := TMGFloatToStr(Value);
  Recalculate;
end;


function TOneFlowsheet.GetNumTabs1ForDay(Day : tDaysOfWeek) : string;
begin
  Result := FldNumTabs1ForDayArray[Day];
end;

procedure TOneFlowsheet.SetNumTabs1ForDay(Day : tDaysOfWeek; const Value : string);
begin
  FldNumTabs1ForDayArray[Day] := Value;
  Recalculate;
end;

function TOneFlowsheet.GetNumTabs2ForDay(Day : tDaysOfWeek) : string;
begin
  Result := FldNumTabs2ForDayArray[Day];
end;

procedure TOneFlowsheet.SetNumTabs2ForDay(Day : tDaysOfWeek; const Value : string);
begin
  FldNumTabs2ForDayArray[Day] := Value;
  Recalculate;
end;

procedure TOneFlowsheet.SetUsingTwoPills(Value: boolean);
begin
  FldUsing2Pills := Value;
  Recalculate;
end;


procedure TOneFlowsheet.RecalcTMGDailyNumTabs1Str;
var day : tDaysOfWeek;
    s : string;
begin
  s := '';
  for Day := daySun to daySat do begin
    if s <> '' then s := s + '|';
    s := s + FldNumTabs1ForDayArray[Day];
  end;
  FldDailyNumTabs1Str := s;
end;

procedure TOneFlowsheet.RecalcTMGDailyNumTabs2Str;
var day : tDaysOfWeek;
    s : string;
begin
  s := '';
  for Day := daySun to daySat do begin
    s := s + FldNumTabs2ForDayArray[Day] + IfThenStr(Day<>daySat, '|', '');
  end;
  FldDailyNumTabs2Str := s;
end;

procedure TOneFlowsheet.RecalcTMGDailyTotalMgsStr;
var day : tDaysOfWeek;
    s : string;
begin
  s := '';
  for Day := daySun to daySat do begin
    if s <> '' then s := s + '|';
    s := s + GetMgForDay(Day);
  end;
  FldDailyTotalMgsStr := s;
end;

function TOneFlowsheet.GetHumanReadableRegimenX(Pillstrength : string; NumTabsXForDay : TNumTabsArrayForDay) : string;
var  day : tDaysOfWeek;
     s : string;
     Found : boolean;
     NumTab : single;
begin
  Result := '';
  s := PillStrength + ' mg on';
  Found := false;
  for Day := daySun to daySat do begin
    NumTab := StrToFloatDef(NumTabsXForDay[Day], 0);
    if NumTab = 0 then continue;
    Found := true;
    if RightStr(s, 3) <> ' on' then s := s + ',';
    s := s + ' ' + DAY_NAMES[Day];
    if NumTab <> 1 then begin
      s := s + ' (' + TMGFloatToStr(NumTab) + ' tab';
      if NumTab >= 2 then s := s + 's';
      s := s + ')';
    end;
  end;
  if not Found then s := '(none)';
  Result := s;
end;


function TOneFlowsheet.GetHumanReadableRegimen1 : string;
begin
  Result := GetHumanReadableRegimenX(PillStrength1, FldNumTabs1ForDayArray);
end;

function TOneFlowsheet.GetHumanReadableRegimen2 : string;
begin
  Result := GetHumanReadableRegimenX(PillStrength2, FldNumTabs2ForDayArray);
end;

function TOneFlowsheet.GetHumanReadableRegimenCombinedForDay(Day : tDaysOfWeek) : string;
var FirstIsNonUnity : boolean;
    fNumTab1, fNumTab2 : single;
    NumTab1,  NumTab2 : string;
begin
  Result := '';
  fNumTab1 := GetfNumTabs1ForDay(Day);
  NumTab1 :=  GetNumTabs1ForDay(Day);
  FirstIsNonUnity := false;

  if fNumTab1>0 then begin
    if Frac(fNumTab1) = 0.5 then begin
      Result := Result + IfThen(Trunc(fNumTab1) <> 0, IntToStr(Trunc(fNumTab1)), '')  + '&#189;';
    end else begin
      Result := Result + NumTab1;
    end;
    Result := Result + ' tab' + IfThen(fNumTab1 > 1, 's', '') + ' of ';
  end;


  {
  if (fNumTab1 <> 1) and (fNumTab1 > 0) then begin
    if fNumTab1=0.5 then Result:=Result+'&#189; tab'
    else begin
      Result := Result + GetNumTabs1ForDay(Day) + ' tab';
      if GetfNumTabs1ForDay(Day) <> 1 then Result := Result + 's';
    end;
    Result := Result + ' of ';
    FirstIsNonUnity := true;
  end;
  }

  If fNumTab1 > 0 then Result := Result + PillStrength1 + ' mg';

  fNumTab2 := GetfNumTabs2ForDay(Day);
  NumTab2 :=  GetNumTabs2ForDay(Day);

  if UsingTwoPills and (fNumTab2 > 0) then begin
    If Result <> '' then Result := Result + ', and ';
    if Frac(fNumTab2) = 0.5 then begin
      Result := Result + IfThen(Trunc(fNumTab2) <> 0, IntToStr(Trunc(fNumTab2)), '')  + '&#189;';
    end else begin
      Result := Result + NumTab2;
    end;
    Result := Result + ' tab' + IfThen(fNumTab2 > 1, 's', '') + ' of ';
    Result := Result + PillStrength2 + ' mg';
  end;
  {
  fNumTab2 := GetfNumTabs2ForDay(Day);
  if UsingTwoPills and (fNumTab2 > 0) then begin
    If Result <> '' then Result := Result + ', and ';
    if (GetfNumTabs2ForDay(Day) <> 1) or (FirstIsNonUnity) then begin
      if fNumTab2=0.5 then Result:=Result+'&#189; tab'
      else begin
        Result := Result + GetNumTabs2ForDay(Day) + ' tab';
        if GetfNumTabs2ForDay(Day) <> 1 then Result := Result + 's';
      end;
      Result := Result + ' of ';
    end;
    Result := Result + PillStrength2 + ' mg';
  end;                             }
  if Result = '' then Result := '(none)';

end;


function TOneFlowsheet.GetIsRetracted : boolean;
begin
  Result := TMGRetractionDate > 0;
end;

function TOneFlowsheet.GetINRGoalStatus : tGoalStatus;
var INR, Low, High : single;
begin
  INR  := GetfINR;
  Low  := GetfINRGoalLow;
  High := GetfINRGoalHigh;
  //------------------------------
  if (Low = 0) or (High = 0) then Result := tgsUndef
  else if INR < Low then Result := tgsLow
  else if (INR >= Low) and (INR <= High) then result := tgsNormal
  else if (INR > High) then result := tgsHigh
  else Result := tgsUndef;
end;

function TOneFlowsheet.GetINRGoalStatusLabel : string;
begin
  Result := GOAL_STATUS_LABEL[GetINRGoalStatus];
end;

function  TOneFlowsheet.GetFMDT : TFMDateTime;
begin
 Result := DateTimeToFMDateTime(FldDateTime);
end;

function  TOneFlowsheet.GetFMDTStr : string;
begin
 Result := DateTimeToFMDTStr(FldDateTime);
end;

procedure TOneFlowsheet.Recalculate;
//NOTE: This doesn't have to recalculate everything because many of the other
//      properties and functions will calculate them just-in-time.
//      This just does that part that are stored in static fields.
begin
  if SuspendRecalculation then exit;
  TotalWeeklyDose();
  RecalcTMGDailyNumTabs1Str;
  RecalcTMGDailyNumTabs2Str;
  RecalcTMGDailyTotalMgsStr;
end;

function TOneFlowsheet.GetStrINRGoalHigh : string;
begin
  Result := Trim(piece(CurrentINRGoal,'-',2));
end;

function TOneFlowsheet.GetStrINRGoalLow : string;
begin
  Result := Trim(piece(CurrentINRGoal,'-',1));
end;

function TOneFlowsheet.GetfINRGoalHigh : single;
begin
  Result := StrToFloatDef(GetStrINRGoalHigh,0);
end;

function TOneFlowsheet.GetfINRGoalLow : single;
begin
  Result := StrToFloatDef(GetStrINRGoalLow,0);
end;

function  TOneFlowsheet.GetfINR : single;
begin
  Result := StrToFloatDef(FldINR, 0);
end;


function TOneFlowsheet.GetLabInfoStr : string;
begin
  Result:= LabDrawLoc + '|' + LabDrawPhone +'|'+ LabDrawFax;
end;

function TOneFlowsheet.GetHgbOrHctInfoStr : string;
begin
  Result := IfThenStr(HctOrHgbValue<>'', HctOrHgbValue+'|'+INRLabDateStr+'|'+LabDrawLoc, '');
end;

procedure TOneFlowsheet.SetTMGDailyNumTabs1Str(FullValue : string);
var day : tDaysOfWeek;
begin
  for Day := daySun to daySat do begin
    NumTabs1ForDay[Day] := piece(FullValue,'|',Ord(Day));
  end;
end;

procedure TOneFlowsheet.SetTMGDailyNumTabs2Str(FullValue : string);
var day : tDaysOfWeek;
begin
  for Day := daySun to daySat do begin
    NumTabs2ForDay[Day] := piece(FullValue,'|',Ord(Day));
  end;
end;

function TOneFlowsheet.MgsForDayStr : string;  //'e.g. '5|6|5|7.5|3|5|3'
var day : tDaysOfWeek;
begin
  Result := '';
  for Day := daySun to daySat do begin
    if Result <> '' then Result := Result + '|';
    Result := Result + GetMgForDay(Day);
  end;
end;


function TOneFlowsheet.fTotalMgs1ForWeek : single;
var day : tDaysOfWeek;
    Value : single;
begin
  result := 0;
  for Day := daySun to daySat do begin
    Value := GetfPillStrength1*GetfNumTabs1ForDay(Day);
    Result := Result + Value;
  end;
end;

function TOneFlowsheet.fTotalMgs2ForWeek : single;
var day : tDaysOfWeek;
begin
  result := 0;
  for Day := daySun to daySat do begin
    Result := Result + GetfPillStrength2*GetfNumTabs2ForDay(Day);
  end;
end;

function TOneFlowsheet.TotalMgs1ForWeek : string;
begin
  result := TMGFloatToStr(fTotalMgs1ForWeek);
end;

function TOneFlowsheet.TotalMgs2ForWeek : string;
begin
  result := TMGFloatToStr(fTotalMgs2ForWeek);
end;

function TOneFlowsheet.TotalNumTabs1ForWeek : string;
var day : tDaysOfWeek;
    Total : single;
begin
  Total := 0;
  for Day := daySun to daySat do begin
    Total := total + fNumTabs1ForDay[Day];
  end;
  Result := TMGFloatToStr(Total);
end;

function TOneFlowsheet.TotalNumTabs2ForWeek : string;
var day : tDaysOfWeek;
    Total : single;
begin
  Total := 0;
  for Day := daySun to daySat do begin
    Total := total + fNumTabs2ForDay[Day];
  end;
  Result := TMGFloatToStr(Total);
end;


function TOneFlowsheet.fTotalWeeklyDose : single;
begin
  Result := fTotalMgs1ForWeek();
  if FldUsing2Pills then Result := Result + fTotalMgs2ForWeek;
end;

function TOneFlowsheet.TotalWeeklyDose : string;
begin
  result := TMGFloatToStr(fTotalWeeklyDose);
  FldTotalWeeklyDose := result; // <-- NOTE: this is used for storage for saving RPC, not as source of information
end;

procedure TOneFlowsheet.ForceOverwriteFldTotalWeeklyDose(Value : string);
//should only be used for OLD  flowsheets, not current one
//This will get overwritten if recalculate is triggered.
begin
  FldTotalWeeklyDose := Value;
  //fTotalWeeklyDose := StrToFloatDef(Value, 0);
end;

function TOneFlowsheet.fPriorTWD : single;
begin
  Result := StrToFloatDef(PriorTWD, 0);
end;

function TOneFlowsheet.fPctChange : single;
begin
  if fPriorTWD <> 0 then begin
    Result := 100* (fTotalWeeklyDose - fPriorTWD) / fPriorTWD;
    Result := ceil(Result);
  end else begin
    Result := -999;
  end;
end;

function TOneFlowsheet.PctChange : string;
var temp : single;
begin
  temp := fpctChange();
  if temp <> -999 then begin
    Result := TMGFloatToStr(temp) + '%';
  end else begin
    Result := '';
  end;
end;



procedure TOneFlowsheet.PullDosingInfoFromScreen(sgDosingData : TStringGrid; cboPS, cboPS2 : TComboBox);
var i  : integer;
    s : string;
begin
  SuspendRecalculation := true;
  PillStrength1 := Trim(cboPS.Text);
  for i := 1 to 7 do begin
    s := GetControlText(sgDosingData.Objects[i-1, ROW_NUM_TABS_1]);
    NumTabs1ForDay[tDaysOfWeek(i)] := s;
  end;

  PillStrength2 := trim(cboPS2.Text);
  for i := 1 to 7 do begin
    s := GetControlText(sgDosingData.Objects[i-1, ROW_NUM_TABS_2]);
    NumTabs2ForDay[tDaysOfWeek(i)] := s;
  end;
  SuspendRecalculation := false;
  Recalculate;
end;


procedure TOneFlowsheet.OutputCalculatedFields(sgDosingData : TStringGrid);
var day : tDaysOfWeek;
    AEdit : TEdit;
    ALabel : TLabel;

begin
  ALabel := TLabel(sgDosingData.Objects[COL_TOTAL, ROW_NUM_TABS_1]);
  ALabel.Caption := TotalNumTabs1ForWeek;

  ALabel := TLabel(sgDosingData.Objects[COL_TOTAL, ROW_NUM_TABS_2]);
  ALabel.Caption := TotalNumTabs2ForWeek;

  for Day := daySun to daySat do begin
    AEdit := TEdit(sgDosingData.Objects[ord(Day)-1, ROW_TOTAL_MGS]);
    AEdit.Text := MgForDay[Day];
  end;

  ALabel := TLabel(sgDosingData.Objects[COL_TOTAL, ROW_TOTAL_MGS]);
  ALabel.Caption := TotalWeeklyDose;
end;


destructor TOneFlowsheet.Destroy;
begin
  Comments.Free;
  Complications.Free;
  PatientInstructions.Free;
  //DocsHTMLSL.Free;
  //kt OnePastINRValue.Free;
  inherited Destroy;
end;


// ============================================================

constructor TPatientFlowsheetData.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TPatientFlowsheetData.Destroy;
begin
  Clear();
  FList.Free;
  inherited Destroy;
end;


function TPatientFlowsheetData.GetFlowsheet(index : integer) : TOneFlowsheet;
begin
  Result := nil;
  if (index < FList.Count) and (index >= 0) then begin
    Result := TOneFlowsheet(FList[index]);
  end;
end;

procedure TPatientFlowsheetData.SetFlowsheet(Index : integer; Value : TOneFlowsheet);
begin
  if index < FList.Count then begin
    if Assigned(FList[index]) then TOneFlowsheet(FList[index]).Free;
    FList[Index] := Value;
  end else if index = FList.Count then begin
    Add(Value);
  end else begin
    FList.Count := index + 1;
    FList[Index] := Value;
  end;
end;

function TPatientFlowsheetData.Add(Value : TOneFlowsheet) : integer;  //returns index of added object, 0 based
begin
  Result := FList.Add(Value);
end;


function TPatientFlowsheetData.AddOneBlank : TOneFlowsheet;
begin
  Result := TOneFlowsheet.Create();
  Add(Result);
end;

procedure TPatientFlowsheetData.Clear();
var i : integer;
begin
  for i := 0 to FList.Count - 1 do begin
    TOneFlowsheet(FList[i]).Free;
  end;
  FList.Clear;
end;


procedure TPatientFlowsheetData.Assign(Source : TPatientFlowsheetData);
var i : integer;
    One : TOneFlowsheet;
begin
  Clear();
  for i := 0 to Source.Count - 1 do begin
    One := TOneFlowsheet.Create;
    One.Assign(Source.Flowsheet[i]);
    Add(One);
  end;
end;

function TPatientFlowsheetData.IndexOf(AFlowsheet : TOneFlowsheet) : integer;
begin
  result := FList.IndexOf(AFlowsheet);
end;

function TPatientFlowsheetData.Count : integer;
begin
  Result := FList.Count;
end;

function TPatientFlowsheetData.MostRecent : TOneFlowsheet; //returns nil if none available.
begin
  if FList.Count > 0 then begin
    Result := TOneFlowsheet(FList[FList.Count-1]);
  end else begin    Result := nil;
  end;
end;

procedure TPatientFlowsheetData.ExtractINRData(UntypedAppState : TObject);
//Prior values in OutSL are not cleared before adding here.
//OutSL[#]=<INR VALUE>^^<external date>^<$H date>  <-- this is to match format from rRPCs.GetPastINRValues
var i : integer;
    OneFlowsheet : TOneFlowsheet;
    AppState : TAppState;
begin
  if not (UntypedAppState is TAppState) then exit;
  AppState := TAppState(UntypedAppState);
  for i := 0 to FList.Count - 1 do begin
    OneFlowsheet := GetFlowsheet(i);
    if OneFlowsheet.INR = '' then continue;
    AppState.PastINRValues.AddFrom(OneFlowsheet);
  end;
  AppState.PastINRValues.Sort;
end;

procedure TPatientFlowsheetData.ParsePatientData(DFN : string; RPCResults : TStrings);

  procedure GetOneBlock(RPCResults : TStrings; OutOneBlock : TStringList);
  //Remove lines from RPC, and put into OutOneBlock
  var CommentAndInstructionsCt, ComplicationsCt : integer;
      Line : string;
      i : Integer;
  begin
    OutOneBlock.Clear();
    if RPCResults.Count = 0  then exit;
    Line := RPCResults[0]; RPCResults.Delete(0);
    OutOneBlock.Add(Line);
    Line := piece(Line, '|', 1);
    CommentAndInstructionsCt := StrToIntDef(Piece(line, ',',1),0);
    ComplicationsCt := StrToIntDef(Piece(line, ',',2),0);
    for i := 1 to (CommentAndInstructionsCt + ComplicationsCt) do begin
      if RPCResults.Count = 0 then break;
      OutOneBlock.Add(RPCResults[0]); RPCResults.Delete(0);
    end;
  end;

  procedure ParseOneBlock(OneBlock : TStringList; OneFlowsheet : TOneFlowsheet);
    { //kt
      RESULT(0) = <#A>[,<#B>]|<ZERO NODE>^@^<TMG NODE> <-- first flowsheet entry
               #A = number of comments lines
               #B = number of complications lines (optional)
               <ZERO NODE> is the 0 node, but date is made external, and piece #2 is subIEN
                 0;1: 12/3/17^               .01   FS DATE  <-- external mode    -- Fileman date of the flow sheet entry
                 0;2: 3^                     104   COMPLICATION  <-- changed to subIEN
                 0;3: 2.5^                    20   INR
                 0;4: lo||^                   30   LAB DRAW LOC
                 0;5: 5^                      40   PILL STRENGTH
                 0;6: ---^                    50   TOTAL WEEKLY DOSE
                 0;7: 5|10|5|10|5|10|5^       60   DAILY DOSING
                 0;8: Pt notice here^         70   PATIENT NOTICE
                 0;9: 3171213.183135^         80   D/T STAMP   --  Entry date/time of item into the file.
                 0;10: 168^                   90   PROVIDER
                 0;11: A Flutter^             92   CURRENT INDICATION
                 0;12: 2.0-3.0^               95   CURRENT GOAL
                 0;13: 2                     100   SHOW VALUE
                 0;14-19 -- unused
                 0;21  7.5                   22701 TMG PILL STRENGTH #2
                 0;22  1|0|2|0|2|0|1         22702 TMG DAILY NUM TABS #1
                 0;23  0|1|0|1|0|1|0         22703 TMG DAILY NUM TABS #2
                 0;24  3181212.1201          22704 TMG LAB/INR DATE

              <TMG NODE> is the "TMG" node
                 TMG;1:                      22714 DOSING EDITED
                 TMG;2:                      22715 HOLD RX NUMBER OF DAYS
                 TMG;3:                      22716 TAKE NUMBER OF TABS TODAY
                 TMG;4:                      22717 APPOINTMENT NOSHOW DATE
                 TMG;5:                      22718 PATIENT MOVED AWAY
                 TMG;6:                      22719 PATIENT CARE TRANSFERRED TO
                 TMG;7:                      22720 PATIENT VIOLATED AGREEMENT
                 TMG;8:                      22721 DISCHARGE REASON
                 TMG;9:                      22722 DISCHARGE DATE

      RESULT(1..x1) = <line of comments> <--- only if comments #A > 0
      RESULT(x1+1) = "-= PATIENT INSTRUNCTIONS =-"  <-- tagged text marker dividing comments from patient instructions.  Only if instructions present
      RESULT(x1+2..y) <line of patient instructions> <-- only if patient instructions present.
      RESULT(y+1) = "Complications noted:" <-- only if complications #B > 0
      RESULT(y+2..z) = <line of complication) <-- only if complications #B > 0
                       NOTE: I think this is a formated group of text, with tags
                       'MB:', 'C:', 'Minor bleed', 'Thrombotic Event'
      ...
      <repeat of above pattern for each flowsheet entry.
}


  var
    Start, line :                  string;
    i :                            integer;
    ZeroNode, TMGNode :            string;
    tempS :                        string;
    tempFMDate :                   TFMDateTime;
    CommentAndInstructionsCt, ComplicationsCt :   integer;
    FoundPtInstructions:           boolean;

  begin
    if OneBlock.Count = 0 then exit;
    line := OneBlock[0]; OneBlock.Delete(0);
    Start := piece(line, '|', 1);
    ZeroNode := MidStr(line, length(Start)+2, Length(Line)); //piece(line, '|', 2);
    TMGNode := Piece2(ZeroNode,'^@^',2);
    ZeroNode := Piece2(ZeroNode,'^@^',1);
    OneFlowsheet.RawData := ZeroNode; //was line
    OneFlowsheet.SuspendRecalculation := true;
    CommentAndInstructionsCt := StrToIntDef(Piece(Start, ',',1),0);
    FoundPtInstructions := false;
    for i := 1 to CommentAndInstructionsCt do begin
      if OneBlock.count = 0 then break;
      line := OneBlock[0]; OneBlock.Delete(0);
      if Pos('-= PATIENT INSTRUNCTIONS =-', line)>0 then begin
        FoundPtInstructions := true;
        continue;
      end;
      if FoundPtInstructions then begin
        OneFlowsheet.PatientInstructions.Add(line);
      end else begin
        OneFlowsheet.Comments.Add(line);
      end;
    end;
    if OneFlowsheet.Comments.Count = 0 then OneFlowsheet.Comments.Add('none');
    ComplicationsCt := StrToIntDef(Piece(Start, ',',2),0);
    for i := 1 to ComplicationsCt do begin
      if OneBlock.count = 0 then break;
      line := OneBlock[0]; OneBlock.Delete(0);
      OneFlowsheet.Complications.Add(line);
    end;
    OneFlowsheet.DFN                   := DFN;
    OneFlowsheet.DateStr               := piece(ZeroNode, '^', 1);
    OneFlowsheet.DateTime              := StrToDateDef(OneFlowsheet.DateStr, 0);
    OneFlowsheet.subIEN                := piece(ZeroNode, '^', 2);
    OneFlowsheet.INR                   := piece(ZeroNode, '^', 3);
    tempS                              := piece(ZeroNode, '^', 4);
    OneFlowsheet.LabDrawLoc            := piece(tempS, '|', 1);
    OneFlowsheet.LabDrawPhone          := piece(tempS, '|', 2);
    OneFlowsheet.LabDrawFax            := piece(tempS, '|', 3);
    OneFlowsheet.FldPillStrength1      := piece(ZeroNode, '^', 5);
    OneFlowsheet.FldPillStrength2      := piece(ZeroNode, '^', 21);
    OneFlowsheet.UsingTwoPills         := (OneFlowsheet.FldPillStrength2 <> '');
    OneFlowsheet.FldTotalWeeklyDose    := piece(ZeroNode, '^', 6);
    OneFlowsheet.DailyDosingStr        := piece(ZeroNode, '^', 7);
    OneFlowsheet.PatientNotice         := piece(ZeroNode, '^', 8);
    OneFlowsheet.EntryCreationFMDT     := piece(ZeroNode, '^', 9);
    OneFlowsheet.Provider              := piece(ZeroNode, '^', 10);
    OneFlowsheet.CurrentIndication     := piece(ZeroNode, '^', 11);
    OneFlowsheet.CurrentINRGoal        := piece(ZeroNode, '^', 12);
    tempS                              := piece(ZeroNode, '^', 13);
    OneFlowsheet.AppointmentShowStatus := tShowValue(StrToIntDef(tempS, 3));
    tempS                              := piece(ZeroNode, '^', 20);
    if IsFMDateTime(tempS) then begin
      tempFMDate := StrToFloat(tempS);
      OneFlowsheet.TMGRetractionDate    := FMDateTimeToDateTime(tempFMDate);
    end else begin
      OneFlowsheet.TMGRetractionDate    := 0;
    end;
    tempS := Trim(piece(ZeroNode, '^', 22));
    if tempS <> '' then begin
      OneFlowsheet.DosingSuggested := false;
      OneFlowsheet.SetTMGDailyNumTabs1Str(tempS);
    end else begin
      OneFlowsheet.DosingSuggested := true;
      OneFlowsheet.SetTMGDailyNumTabs1Str('1|1|1|1|1|1|1');
    end;

    OneFlowsheet.SetTMGDailyNumTabs2Str(piece(ZeroNode, '^', 23));

    tempS := piece(ZeroNode, '^', 24);
    if IsFMDateTime(tempS) then begin
      tempFMDate := StrToFloat(tempS);
      OneFlowsheet.INRLabDateTime  := FMDateTimeToDateTime(tempFMDate);
    end else begin
      OneFlowsheet.INRLabDateTime  := 0;
    end;

    OneFlowsheet.DosingEdited              :=(piece(TMGNode,'^',1) = 'Y');
    OneFlowsheet.DoseHoldNumOfDays         := piece(TMGNode,'^',2);
    OneFlowsheet.DoseTakeNumMgToday        := piece(TMGNode,'^',3);
    OneFlowsheet.DocsAppointmentNoShowDate := FMDTStrToDateTime(piece(TMGNode,'^',4));
    OneFlowsheet.DocsPtMoved               :=(piece(TMGNode,'^',5) = 'Y');
    OneFlowsheet.DocsPtTransferTo          := piece(TMGNode,'^',6);
    OneFlowsheet.DocsViolatedAgreement     :=(piece(TMGNode,'^',7) = 'Y');
    OneFlowsheet.DocsDischargedReason      := piece(TMGNode,'^',8);
    OneFlowsheet.DocsDischargedDate        := FMDTStrToDateTime(piece(TMGNode,'^',9));

    //Note:  OneFlowsheet.DocsHTMLNote will be saved as TIU NOTE, not with flowsheet data.

    {
    //OneFlowsheet.OutINR := '^';
    if (OneFlowsheet.INR <> '') and
      ((OneFlowsheet.LabDrawLoc <> 'PVAMC') and (OneFlowsheet.LabDrawLoc <> 'VAMC')) then begin
      temp1date := StrToDate(OneFlowsheet.DateStr);
      //I can't find this being used...
      if MonthsBetween(now,temp1date) < 6 then begin
        OneFlowsheet.OutINR := OneFlowsheet.OutINR + '^' + OneFlowsheet.INR + '^' + OneFlowsheet.DateStr;
      end;
    end;
    }

    OneFlowsheet.SuspendRecalculation := false;
  end;

  var
    OneBlock : TStringList;
    OneFlowsheet : TOneFlowsheet;  //will be owned by list

begin
  OneBlock := TStringList.Create();
  try
    while RPCResults.Count > 0 do begin
      GetOneBlock(RPCResults, OneBlock);
      OneFlowsheet := AddOneBlank();
      ParseOneBlock(OneBlock, OneFlowsheet);
    end;
  finally
    OneBlock.Free;
  end;
end;


procedure TPatientFlowsheetData.LoadFromServer(DFN : string);
var SL : TStringList;
begin
  SL := TStringList.Create;
  try
    RPCGetFlowsheetRawData(DFN, SL);
    Clear();
    ParsePatientData(DFN, SL);
  finally
    SL.Free;
  end;
end;

end.
