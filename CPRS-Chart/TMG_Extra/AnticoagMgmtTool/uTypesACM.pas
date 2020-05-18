unit uTypesACM;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, grids,
  StdCtrls, StrUtils, Math, DateUtils, ComCtrls, ExtCtrls, graphics,
  ORCtrls, ORFn, ORNet, Trpcb, {VA508AccessibilityManager,} mPCE_ACM,
  uHTMLTools, TMGHTML2, uFlowsheet, uPastINRs;

type
  tMessagePhone      = (tmpNotAsked = 0, tmpNoMsg = 1, tmpMsgOK = 2);
  tPatientComplexity = (tpcStandard = 0, tpcComplex = 1, tpcInactive = 2);
  tAMMeds            = (tammPMMeds = 0, tammAMMeds = 1, tammUnknown = 2);
  tFeeBasis          = (tfbNo = 0, tfbPrimary = 1, tfbSecondary = 2);
  tSaveMode          = (tsmSave = 0, tsmTempSave = 1);
  tPctInGoalMode     = (igmAll = 0, igmNonComplex = 1);

  TWeekBoolArray     = array [daySun .. daySat] of boolean;
  TWeekCheckBoxArray = array [daySun .. daySat] of TCheckbox;
  BOOL_COLOR_ARRAY   = array [false .. true] of TColor;

  TExposedControl = class(TControl)
  public
    property Color;
  end;

const
  DAY_NAMES: array [daySun .. daySat] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat');
  BOOL_YN:      array [false .. true] of char = ('N', 'Y');
  BOOL_0or1:    array [false .. true] of char = ('0', '1');
  clLightMoneyGreen = TColor($DEEDDE);
  clLightSkyBlue    = TColor($F8E5D3);
  clLightYellow     = TColor($B3FFFF);
  clLightRed        = TColor($CCCCFF);
  clLightOrange     = TColor($80BFFF);
  clTotalRow        = clLightYellow;
  clDoseColEmpty    = clLightOrange;
  clNeedsData       = clYellow;
  clInvalid         = clYellow;
  VALID_COLOR: array [false .. true] of TColor = (clLightRed, clWindow);
  SAVE_MODE: array [tsmSave .. tsmTempSave] of string   = ('SAVE', 'TEMPSVE');
  MSG_PHONE_VAL: array [false .. true] of tMessagePhone = (tmpNoMsg, tmpMsgOK);

  ROW_STRENGTH_1 = 0;
  ROW_NUM_TABS_1 = 1;
  ROW_STRENGTH_2 = 2;
  ROW_NUM_TABS_2 = 3;
  ROW_TOTAL_MGS  = 4;

  COL_SUN   = 0;
  COL_MON   = 1;
  COL_TUE   = 2;
  COL_WED   = 3;
  COL_THUR  = 4;
  COL_FRI   = 5;
  COL_SAT   = 6;
  COL_TOTAL = 7;

  FLOWSHEET_HOLDER_COL = 0;

  GREEN_COLOR_ARRAY: BOOL_COLOR_ARRAY = (clMoneyGreen, clLightMoneyGreen);
  BLUE_COLOR_ARRAY: BOOL_COLOR_ARRAY  = (clSkyBlue, clLightSkyBlue);
  DOSE_GRID_DISPLAY_COLORS: array [false .. true] of BOOL_COLOR_ARRAY =
    ((clMoneyGreen, clLightMoneyGreen), (clSkyBlue, clLightSkyBlue));

  FLOWSHEET_GRID_DATE_COL                = 0;
  FLOWSHEET_GRID_DATE_COL_WIDTH          = 65;
  FLOWSHEET_GRID_INR_COL                 = 1;
  FLOWSHEET_GRID_INR_COL_WIDTH           = 35;
  FLOWSHEET_GRID_TWD_COL                 = 2;
  FLOWSHEET_GRID_TWD_COL_WIDTH           = 35;
  FLOWSHEET_GRID_COMPLICATIONS_COL       = 3;
  FLOWSHEET_GRID_COMPLICATIONS_COL_WIDTH = 35;
  FLOWSHEET_GRID_NOTICE_COL              = 4;
  FLOWSHEET_GRID_NOTICE_COL_WIDTH        = 130;
  FLOWSHEET_GRID_COMMENTS_COL            = 5;

type
  TAppState = class; // forward, defined below
  TNoteInfo = class;  // forward, defined below

  TPatient = class(TObject)
  // was initially a record...., so I'll leave in this file.
  private
    FNextApptDateStr                   : string;
    FNextApptDateTimeStr               : string;
    FDateOfNextScheduledINRCheck       : TDate;
    FNextApptTime                      : TTime;
    FNextApptTimeStr                   : string;
    function GetfINRGoalHigh: single;
    function GetfINRGoalLow: single;
    function GetINRGoalHigh: string;
    function GetINRGoalLow: string;
    function  GetNextApptDate : TDateTime;
    procedure SetNextApptDate(Value: TDateTime);
    procedure SetNextApptDateStr(Value: string);
    procedure SetNextApptTime(Value: TTime);
    function GetDrawRestrictionsStr : string;
  public
    // DFN^NAME^GENDER^ADMISSION^CURRENT DT/TIME (internal)^SSN^CURRENT DT/TIME (external)^CLINIC LOCATION^DTIME^VDT
    DFN                                  : string;    // piece 1
    Name                                 : string;    // piece 2
    NiceName                             : string;    // e.g. Mr. John Davis
    Gender                               : string;    // piece 3
    Admission                            : string;    // piece 4
    CurrentFMDT                          : string;    // piece 5
    SSN                                  : string;    // piece 6
    CurrentExtDT                         : string;    // piece 7
    ClinicLoc                            : string;    // piece 8    e.g. '17;SC('
    ClinicIEN                            : string;    // (piece(p8,';',1)
    ClinicName                           : string;
    TimeoutSeconds                       : integer;   // piece 9     //timeout time.
    VisitDate                            : string;    // piece 10
    DOB                                  : TDateTime; // piece 11
    Greeting                             : string;
    PaddedNowDateStr                     : string;
    NewPatient                           : boolean;
    // ------------------------------
    // Below is from common info in anticoagulation flowsheet file (103)
    GoalINR                              : string;
    Indication_Text                      : string;
    Indication_ICDCode                   : string;
    UserSelectedIndication               : boolean;
    ScheduledLabDateStr                  : string;
    //DateOfNextScheduledINRCheck          : TDate;
    StartDate                            : string;
    StopDate                             : string;
    ExpectedTreatmentDuration                             : string;
    SignedAgreement                      : boolean;
    ViolatedAgreement                    : boolean;
    Orientation                          : string;
    Complexity                           : tPatientComplexity;
    MsgPhone                             : tMessagePhone;
    AM_Meds                              : tAMMeds;
    SaveMode                             : tSaveMode;
    FeeBasis                             : tFeeBasis;
    FeeBasisExpiration                   : TDate;
    FeeBasisEvaluatedBy                  : string;
    StandingLabOrderExpirationDate       : TDate;
    ReminderDate                         : TDate;
    Locked                               : boolean;
    LockUserName                         : string;
    //DrawRestrictions                     : string;
    DrawRestrictionsArray                : TWeekBoolArray;
    NextDayCallback                      : string;
    RestrictLabDraws                     : string;
    Complex                              : string;
    OutsideHctOrHgb                      : string;  //Unusued. See description below.
    {DESCRIPTION:      Outside HCT lab value, entered by the pharmacist through
                       the GUI, is  stored here in the following format:
                       value | DATE
                       date is not in fileman format
                       example: 21.6|9/19/2008
     NOTE: This only allows 1 value to be stored at a time per patient.  So
           I am NOT going to use this field.  I will be storing data into the
           flowsheet entry for each encounter.
    }
    Needs_LMWH_Bridging                  : boolean;
    SpecialInstructionsSL                : TStringlist;
    RiskFactorsSL                        : TStringlist;
    PersonsOKForMsgSL                    : TStringlist;
    ReminderTextSL                       : TStringlist;
    BridgingCommentsSL                   : TStringlist;
    // -----------------------------------------
    Addr_Street_Line1                    : string;
    Addr_Street_Line2                    : string;
    Addr_Street_Line3                    : string;
    Addr_City                            : string;
    Addr_State                           : string;
    Addr_ZIP                             : string;
    Addr_Bad_Code                        : string;
    Addr_Is_Temp                         : boolean;
    // -----------------------------------------
    HomePhone                            : string;
    WorkPhone                            : string;
    // -----------------------------------------
    PctINRInGoal                         : string;
    TotalINRValues                       : string;
    PctNoShow                            : string;
    TotalVisits                          : string;
    DischargedFromClinic                 : boolean;
    DischargedDate                       : TDateTime;
    DischargedReason                     : string;  //not stored in database, but used in documentation
    InstructionsSL                       : TStringlist;
    FlowsheetData                        : TPatientFlowsheetData;
    //HctOrHgbString                       : string;
    HctOrHgbValue                        : string;
    HctOrHgbDate                         : string;
    HgbFlag                              : boolean;
    // -----------------------------------------
    procedure Clear();
    procedure Assign(Source: TPatient);
    procedure Lock(DUZ: string);
    procedure Unlock;
    procedure SaveToServer(AppState: TAppState);
    function ComplexityNumberStr: string;
    function MsgPhoneNumberStr: string;
    function AMMedsNumberStr: string;
    function FeeBasisNumberStr: string;
    function PersonsOKForMessageStr: string;
    function DrawDaysRestrictionStr: string;
    constructor Create();
    destructor Destroy(); override;
    // --------------------------------------
    property fINRGoalHigh: single read GetfINRGoalHigh;
    property fINRGoalLow: single read GetfINRGoalLow;
    property INRGoalHigh: string read GetINRGoalHigh;
    property INRGoalLow: string read GetINRGoalLow;
    property NextScheduledINRCheckDate: TDateTime read GetNextApptDate write SetNextApptDate;
    property NextScheduledINRCheckDateStr: string read FNextApptDateStr write SetNextApptDateStr;
    property NextScheduledINRCheckDateTimeStr: string read FNextApptDateTimeStr;
    property NextScheduledINRCheckTime: TTime read FNextApptTime write SetNextApptTime;
    property DrawRestrictionsStr : string read GetDrawRestrictionsStr;
  end;

  tPtCheck        = (tpcInvalid, tpcIsPatient, tpcNotPatient, tpcConfigNeeded);
  tDateCompare    = (tdcSame, tdcFirstLater, tdcSecondLater);
  tReminderStatus = (trmUndef, trmPresent, trmToShow);
  tCofactor       = (tcfUndef, tcfNote, tcfOrder);

  TCommentsArray    = Array of TStrings;
  TDUZArr           = Array of String;
  TComplicationsArr = Array of TStrings;

  TProvider = class(TObject)
  // was initially a record...., so I'll leave in this file.
    DUZ: string;
    Name: string;
    Initials: string;
    CosignNeeded: boolean;
    DefaultCosigner: string; // format: IEN^Name
    HasOrESKey: boolean;
    HaOrElseKey: boolean;
    HasOrProviderKey: boolean;
    procedure Clear();
    procedure Assign(Source: TProvider);
  end;

  TParameters = class(TObject)
  // was initially a record...., so I'll leave in this unit file.
    RawData0, RawData1, RawData2:       string;
    ConsultCtrl:                        integer;
    ConsultService:                     string;
    SiteHead:                           string;
    SiteName:                           string;
    DefaultPillStrength:                single;
    LetterINRTime:                      string;
    InclINRTime:                        boolean;
    ListName:                           string;
    SiteAddA:                           string;
    SiteAddB:                           string;
    SiteAddC:                           string;
    ClinicName:                         string;
    ClinicPhone:                        string;
    TollFreePhone:                      string;
    ClinicFAX:                          string;
    SigName:                            string;
    SigTitle:                           string;
    IntakeNoteIEN:                      string;
    InterimNoteIEN:                     string;
    DischargeNoteIEN:                   string;
    MissedApptNoteIEN:                  string;
    SimplePhoneCPT:                     string;
    SubsequentVisitCPT:                 string;
    ComplexPhoneCPT:                    string;
    InitialVisitCPT:                    string;
    OrientationClassCPT:                string;
    PatientLetterCPT:                   string;
    INRQuickOrder:                      string;
    CBCQuickOrder:                      string;
    VisitClinic:                        string;
    PhoneClinic:                        string;
    NonCountClinic:                     string;
    StationNumber:                      string;
    DSSUnit:                            string;
    DSSId:                              string;
    NetworkPath:                        string;
    AutoPrimaryIndicationCode:          string;
    AutoPrimaryIndicationText:          string;
    Str0Pce13:                          string;
    Str2Pce2:                           string;
    IENIntakeNoteTemplate:              string;
    NameIntakeNoteTemplate:             string;
    IENInterimNoteTemplate:             string;
    NameInterimNoteTemplate:            string;
    IENDCNoteTemplate:                  string;
    NameDCNoteTemplate:                 string;
    IENMissedApptNoteTemplate:          string;
    NameMissedApptNoteTemplate:         string;
    IENNoteForPatientNoteTemplate:      string;
    NameNoteForPatientNoteTemplate:     string;
    // ------------------------------------
    TMGSaveINRIntoLabPackage:           boolean;
    TMGSaveINRLabSpecimenIEN61:         string;
    TMGSaveINRLabIEN60:                 string;
    TMGSaveHgbLabIEN60:                 string;
    TMGSaveHctLabIEN60:                 string;

    // ------------------------------------
    procedure Clear;
    procedure Assign(Source: TParameters);
  end;

  TAppState = class(TObject)
  private
    function GetAppointmentShowStatusStr: string;
  public
    EClinic                            : string;
    SvcCat                             : string;
    //NoteIEN                            : string; //This is the IEN in 8925 of the note being saved for interaction.
    //NoteTitleIEN                       : string;
    Cofactor                           : tCofactor;
    //CosignNeeded                       : boolean;
    //CosignerDUZ                        : string;
    NoteInfo                           : TNoteInfo;
    INROrderSelected                   : boolean;
    CBCOrderSelected                   : boolean;
    //AccessibilityManager               : TVA508AccessibilityManager; // owned elsewhere
    Historical                         : boolean;
    OutsideLabDataEntered              : boolean;
    PCEProcedureStr                    : string;
    SpecialInstructionsEdited          : boolean;
    RisksEdited                        : boolean;
    IncludeRisksInNote                 : boolean;
    PeopleOKForMessageChanged          : boolean;
    PushingDataToScreen                : boolean;
    AppointmentShowStatus              : tShowValue;
    AppointmentNoShowDate              : TDateTime;
    FilePCEData                        : boolean;
    NextDayCallback                    : boolean;
    NoDrawOnDay                        : TWeekBoolArray;
    UserSelectedPillStrength           : boolean;
    ShowRetractedFlowsheets            : boolean;
    // ---------------------
    Patient                            : TPatient;
    Provider                           : TProvider;
    Parameters                         : TParameters;
    PastINRValues                      : TPastINRValues;
    CurrentNewFlowsheet                : TOneFlowsheet;
    PCEData                            : TPCEData; // not owned here
    PctInGoalMode                      : tPctInGoalMode;
    // ---------------------

    constructor Create();
    destructor Destroy(); override;
    procedure Clear();
    procedure Assign(Source: TAppState);
    //function DrawDaysRestrictionStr: string;
    property AppointmentShowStatusStr: string read GetAppointmentShowStatusStr;

  end;

  TNoteInfo = class(TObject)
  private
  public
    NoteSL            : TStringList;
    NoteIEN           : string;  //This is the IEN in 8925 of the note being saved for interaction.
    CosignNeeded      : boolean;
    CosignerDUZ       : string;
    SaveSuccess       : boolean;
    function CosignOK : boolean;
    procedure Clear;
    procedure Assign(Source : TNoteInfo);
    constructor Create;
    Destructor Destroy;
  end;


  // ====================================================

implementation

uses
  rRPCsACM, uUtility;

procedure TParameters.Clear();
begin
  ConsultCtrl                        := -1;
  ConsultService                     := '';
  SiteHead                           := '';
  SiteName                           := '';
  DefaultPillStrength                := 0;
  LetterINRTime                      := '';
  InclINRTime                        := false;
  ListName                           := '';
  SiteAddA                           := '';
  SiteAddB                           := '';
  SiteAddC                           := '';
  ClinicName                         := '';
  ClinicPhone                        := '';
  TollFreePhone                      := '';
  ClinicFAX                          := '';
  SigName                            := '';
  SigTitle                           := '';
  IntakeNoteIEN                      := '';
  InterimNoteIEN                     := '';
  DischargeNoteIEN                   := '';
  MissedApptNoteIEN                  := '';
  SimplePhoneCPT                     := '';
  SubsequentVisitCPT                 := '';
  ComplexPhoneCPT                    := '';
  InitialVisitCPT                    := '';
  OrientationClassCPT                := '';
  PatientLetterCPT                   := '';
  INRQuickOrder                      := '';
  CBCQuickOrder                      := '';
  VisitClinic                        := '';
  PhoneClinic                        := '';
  NonCountClinic                     := '';
  StationNumber                      := '';
  DSSUnit                            := '';
  DSSId                              := '';
  NetworkPath                        := '';
  AutoPrimaryIndicationCode          := '';
  AutoPrimaryIndicationText          := '';
  Str0Pce13                          := '';
  Str2Pce2                           := '';
  IENIntakeNoteTemplate              := '';
  IENInterimNoteTemplate             := '';
  IENDCNoteTemplate                  := '';
  IENMissedApptNoteTemplate          := '';
  IENNoteForPatientNoteTemplate      := '';
end;

procedure TParameters.Assign(Source: TParameters);
begin
  ConsultCtrl                        := Source.ConsultCtrl;
  ConsultService                     := Source.ConsultService;
  SiteHead                           := Source.SiteHead;
  SiteName                           := Source.SiteName;
  DefaultPillStrength                := Source.DefaultPillStrength;
  LetterINRTime                      := Source.LetterINRTime;
  InclINRTime                        := Source.InclINRTime;
  ListName                           := Source.ListName;
  SiteAddA                           := Source.SiteAddA;
  SiteAddB                           := Source.SiteAddB;
  SiteAddC                           := Source.SiteAddC;
  ClinicName                         := Source.ClinicName;
  ClinicPhone                        := Source.ClinicPhone;
  TollFreePhone                      := Source.TollFreePhone;
  ClinicFAX                          := Source.ClinicFAX;
  SigName                            := Source.SigName;
  SigTitle                           := Source.SigTitle;
  IntakeNoteIEN                      := Source.IntakeNoteIEN;
  InterimNoteIEN                     := Source.InterimNoteIEN;
  DischargeNoteIEN                   := Source.DischargeNoteIEN;
  MissedApptNoteIEN                  := Source.MissedApptNoteIEN;
  SimplePhoneCPT                     := Source.SimplePhoneCPT;
  SubsequentVisitCPT                 := Source.SubsequentVisitCPT;
  ComplexPhoneCPT                    := Source.ComplexPhoneCPT;
  InitialVisitCPT                    := Source.InitialVisitCPT;
  OrientationClassCPT                := Source.OrientationClassCPT;
  PatientLetterCPT                   := Source.PatientLetterCPT;
  INRQuickOrder                      := Source.INRQuickOrder;
  CBCQuickOrder                      := Source.CBCQuickOrder;
  VisitClinic                        := Source.VisitClinic;
  PhoneClinic                        := Source.PhoneClinic;
  NonCountClinic                     := Source.NonCountClinic;
  StationNumber                      := Source.StationNumber;
  DSSUnit                            := Source.DSSUnit;
  DSSId                              := Source.DSSId;
  NetworkPath                        := Source.NetworkPath;
  AutoPrimaryIndicationCode          := Source.AutoPrimaryIndicationCode;
  AutoPrimaryIndicationText          := Source.AutoPrimaryIndicationText;
  Str0Pce13                          := Source.Str0Pce13;
  Str2Pce2                           := Source.Str2Pce2;
  IENIntakeNoteTemplate              := Source.IENIntakeNoteTemplate;
  IENInterimNoteTemplate             := Source.IENInterimNoteTemplate;
  IENDCNoteTemplate                  := Source.IENDCNoteTemplate;
  IENMissedApptNoteTemplate          := Source.IENMissedApptNoteTemplate;
  IENNoteForPatientNoteTemplate      := Source.IENNoteForPatientNoteTemplate;

  NameIntakeNoteTemplate             := Source.NameIntakeNoteTemplate;
  NameInterimNoteTemplate            := Source.NameInterimNoteTemplate;
  NameDCNoteTemplate                 := Source.NameDCNoteTemplate;
  NameMissedApptNoteTemplate         := Source.NameMissedApptNoteTemplate;
  NameNoteForPatientNoteTemplate     := Source.NameNoteForPatientNoteTemplate;
end;

// ======================================================

constructor TPatient.Create();
begin
  inherited Create;
  SpecialInstructionsSL     := TStringlist.Create;
  RiskFactorsSL             := TStringlist.Create;
  PersonsOKForMsgSL         := TStringlist.Create;
  ReminderTextSL            := TStringlist.Create;
  BridgingCommentsSL        := TStringlist.Create;
  InstructionsSL            := TStringlist.Create;
  FlowsheetData             := TPatientFlowsheetData.Create;
end;

destructor TPatient.Destroy();
begin
  SpecialInstructionsSL.Free;
  RiskFactorsSL.Free;
  PersonsOKForMsgSL.Free;
  ReminderTextSL.Free;
  BridgingCommentsSL.Free;
  InstructionsSL.Free;
  FlowsheetData.Free;

  inherited Destroy;
end;

procedure TPatient.Clear();
begin
  DFN                                       := '';
  Name                                      := '';
  NiceName                                  := '';
  Gender                                    := '';
  Admission                                 := '';
  CurrentFMDT                               := '';
  SSN                                       := '';
  CurrentExtDT                              := '';
  ClinicLoc                                 := '';
  ClinicIEN                                 := '';
  ClinicName                                := '';
  TimeoutSeconds                            := 300;
  VisitDate                                 := '';
  Greeting                                  := '';
  PaddedNowDateStr                          := '';
  NewPatient                                := true;
  GoalINR                                   := '';
  Indication_Text                           := '';
  Indication_ICDCode                        := '';
  UserSelectedIndication                    := false;
  ScheduledLabDateStr                       := '';
  StartDate                                 := '';
  StopDate                                  := '';
  ExpectedTreatmentDuration                                  := '';
  SignedAgreement                           := false;
  ViolatedAgreement                         := false;
  Orientation                               := '';
  Complexity                                := tpcStandard;
  MsgPhone                                  := tmpNotAsked;
  AM_Meds                                   := tammPMMeds;
  SaveMode                                  := tsmSave;
  FeeBasis                                  := tfbNo;
  FeeBasisExpiration                        := StrToDateDef('', 0);
  FeeBasisEvaluatedBy                       := '';
  StandingLabOrderExpirationDate            := StrToDateDef('', 0);
  ReminderDate                              := StrToDateDef('', 0);
  Locked                                    := false;
  NextDayCallback                           := '';
  RestrictLabDraws                          := '';
  Complex                                   := '';
  OutsideHctOrHgb                           := '';
  Needs_LMWH_Bridging                       := false;
  Addr_Street_Line1                         := '';
  Addr_Street_Line2                         := '';
  Addr_Street_Line3                         := '';
  Addr_City                                 := '';
  Addr_State                                := '';
  Addr_ZIP                                  := '';
  Addr_Bad_Code                             := '';
  Addr_Is_Temp                              := false;
  HomePhone                                 := '';
  WorkPhone                                 := '';
  PctINRInGoal                              := '';
  TotalINRValues                            := '';
  PctNoShow                                 := '';
  TotalVisits                               := '';
  DischargedFromClinic                      := false;
  DischargedDate                            := 0;
  DischargedReason                          := '';
  HctOrHgbValue                             := '';
  HctOrHgbDate                              := '';
  HgbFlag                                   := false;
  FNextApptDateStr                          := '';
  FNextApptDateTimeStr                      := '';
  FNextApptTime                             := 0;
  FNextApptTimeStr                          := '';
  //-----------------------
  SpecialInstructionsSL.Clear;
  RiskFactorsSL.Clear;
  PersonsOKForMsgSL.Clear;
  ReminderTextSL.Clear;
  BridgingCommentsSL.Clear;
  InstructionsSL.Clear;
  FlowsheetData.Clear;
end;

procedure TPatient.Assign(Source: TPatient);
begin
  DFN :=                                          Source.DFN;
  Name :=                                         Source.Name;
  NiceName :=                                     Source.NiceName;
  Gender :=                                       Source.Gender;
  Admission :=                                    Source.Admission;
  CurrentFMDT :=                                  Source.CurrentFMDT;
  SSN :=                                          Source.SSN;
  CurrentExtDT :=                                 Source.CurrentExtDT;
  ClinicLoc :=                                    Source.ClinicLoc;
  ClinicIEN :=                                    Source.ClinicIEN;
  ClinicName :=                                   Source.ClinicName;
  TimeoutSeconds :=                               Source.TimeoutSeconds;
  VisitDate :=                                    Source.VisitDate;
  Greeting :=                                     Source.Greeting;
  PaddedNowDateStr :=                             Source.PaddedNowDateStr;
  NewPatient :=                                   Source.NewPatient;
  GoalINR :=                                      Source.GoalINR;
  Indication_Text :=                              Source.Indication_Text;
  Indication_ICDCode :=                           Source.Indication_ICDCode;
  UserSelectedIndication :=                       Source.UserSelectedIndication;
  ScheduledLabDateStr :=                          Source.ScheduledLabDateStr;
  FDateOfNextScheduledINRCheck :=                  Source.FDateOfNextScheduledINRCheck;
  StartDate :=                                    Source.StartDate;
  StopDate :=                                     Source.StopDate;
  ExpectedTreatmentDuration :=                    Source.ExpectedTreatmentDuration;
  SignedAgreement :=                              Source.SignedAgreement;
  ViolatedAgreement :=                            Source.ViolatedAgreement;
  Orientation :=                                  Source.Orientation;
  Complexity :=                                   Source.Complexity;
  MsgPhone :=                                     Source.MsgPhone;
  AM_Meds :=                                      Source.AM_Meds;
  SaveMode :=                                     Source.SaveMode;
  FeeBasis :=                                     Source.FeeBasis;
  FeeBasisExpiration :=                           Source.FeeBasisExpiration;
  FeeBasisEvaluatedBy :=                          Source.FeeBasisEvaluatedBy;
  StandingLabOrderExpirationDate :=               Source.StandingLabOrderExpirationDate;
  ReminderDate :=                                 Source.ReminderDate;
  Locked :=                                       Source.Locked;
  LockUserName :=                                 Source.LockUserName;
  //DrawRestrictions :=                             Source.DrawRestrictions;
  DrawRestrictionsArray :=                        Source.DrawRestrictionsArray;
  NextDayCallback :=                              Source.NextDayCallback;
  RestrictLabDraws :=                             Source.RestrictLabDraws;
  Complex :=                                      Source.Complex;
  OutsideHctOrHgb :=                              Source.OutsideHctOrHgb;
  Needs_LMWH_Bridging :=                          Source.Needs_LMWH_Bridging;
  Addr_Street_Line1 :=                            Source.Addr_Street_Line1;
  Addr_Street_Line2 :=                            Source.Addr_Street_Line2;
  Addr_Street_Line3 :=                            Source.Addr_Street_Line3;
  Addr_City :=                                    Source.Addr_City;
  Addr_State :=                                   Source.Addr_State;
  Addr_ZIP :=                                     Source.Addr_ZIP;
  Addr_Bad_Code :=                                Source.Addr_Bad_Code;
  Addr_Is_Temp :=                                 Source.Addr_Is_Temp;
  HomePhone :=                                    Source.HomePhone;
  WorkPhone :=                                    Source.WorkPhone;
  PctINRInGoal :=                                 Source.PctINRInGoal;
  TotalINRValues :=                               Source.TotalINRValues;
  PctNoShow :=                                    Source.PctNoShow;
  TotalVisits :=                                  Source.TotalVisits;
  DischargedFromClinic :=                         Source.DischargedFromClinic;
  DischargedDate :=                               Source.DischargedDate;
  DischargedReason :=                             Source.DischargedReason;
  HctOrHgbValue :=                                Source.HctOrHgbValue;
  HctOrHgbDate :=                                 Source.HctOrHgbDate;
  HgbFlag :=                                      Source.HgbFlag;
  //FNextApptDate :=                              Source.FNextApptDate;
  FNextApptDateStr :=                             Source.FNextApptDateStr;
  FNextApptDateTimeStr :=                         Source.FNextApptDateTimeStr;
  FNextApptTime :=                                Source.FNextApptTime;
  FNextApptTimeStr :=                             Source.FNextApptTimeStr;

  // ---------------
  InstructionsSL.Assign(Source.InstructionsSL);
  SpecialInstructionsSL.Assign(Source.SpecialInstructionsSL);
  RiskFactorsSL.Assign(Source.RiskFactorsSL);
  PersonsOKForMsgSL.Assign(Source.PersonsOKForMsgSL);
  ReminderTextSL.Assign(Source.ReminderTextSL);
  BridgingCommentsSL.Assign(Source.BridgingCommentsSL);
  FlowsheetData.Assign(Source.FlowsheetData);
end;

procedure TPatient.Lock(DUZ: string);
begin
  LockUserName := DUZ;
  LockPatient(DFN, LockUserName);
  Locked := true;
  // later consider checking for RPC result and handle error state.
end;

procedure TPatient.Unlock;
begin
  UnlockPatient(DFN);
  Locked := false;
  // later consider checking for RPC result and handle error state.
end;

procedure TPatient.SaveToServer(AppState: TAppState);
begin
  SaveTopLevelPatientData(AppState);
end;

function TPatient.ComplexityNumberStr: string;
begin
  Result := IntToStr(Ord(Complexity));
end;

function TPatient.MsgPhoneNumberStr: string;
begin
  Result := IntToStr(Ord(MsgPhone));
end;

function TPatient.AMMedsNumberStr: string;
begin
  Result := IntToStr(Ord(AM_Meds));
end;

function TPatient.FeeBasisNumberStr: string;
begin
  Result := IntToStr(Ord(FeeBasis));
end;

function TPatient.PersonsOKForMessageStr: string;
var
  i       : integer;
  Contacts: string;
begin
  Contacts := '';
  for i := 0 to PersonsOKForMsgSL.Count - 1 do
  begin
    if Contacts <> '' then
      Contacts := Contacts + ', ';
    Contacts := Contacts + PersonsOKForMsgSL[i];
  end;
  Result := Contacts;
end;

function TPatient.DrawDaysRestrictionStr: string;
var
  AWeekDay: tDaysOfWeek;
begin
  Result := '';
  for AWeekDay := dayMon to dayFri do begin
    if DrawRestrictionsArray[AWeekDay] then begin
      if Result <> '' then Result := Result + ', ';
      Result := Result + DAY_NAMES[AWeekDay];
    end;
  end;
  if Result <> '' then Result := 'Do NOT draw on: ' + Result;
end;


function TPatient.GetINRGoalHigh: string;
begin
  Result := Trim(piece(GoalINR, '-', 2));
end;

function TPatient.GetINRGoalLow: string;
begin
  Result := Trim(piece(GoalINR, '-', 1));
end;

function TPatient.GetfINRGoalHigh: single;
begin
  Result := StrToFloatDef(GetINRGoalHigh, 0);
end;

function TPatient.GetfINRGoalLow: single;
begin
  Result := StrToFloatDef(GetINRGoalLow, 0);
end;

function TPatient.GetNextApptDate : TDateTime;
begin
  Result := FDateOfNextScheduledINRCheck;
end;

procedure TPatient.SetNextApptDate(Value: TDateTime);
var
  tmFormat: TFormatSettings; // a record that also has a constructor

begin
  //FNextApptDate := Value;
  FDateOfNextScheduledINRCheck := Value;
  FNextApptDateStr := IfThenStr(Value > 0, DateToStr(Value), '');
  if FNextApptTime > 0 then begin
    //tmFormat := TFormatSettings.Create(LOCALE_USER_DEFAULT);
    tmFormat.LongTimeFormat := 'HH:mm';
    tmFormat.TimeSeparator := ':';  //elh added 7/22/19
    FNextApptTimeStr := TimeToStr(FNextApptTime, tmFormat);
    FNextApptDateTimeStr := FNextApptDateStr + '@' + FNextApptTimeStr;
  end else begin
    FNextApptTimeStr := '';
    FNextApptDateTimeStr := FNextApptDateStr;
  end;
end;

procedure TPatient.SetNextApptDateStr(Value: string);
var
  tempDT: TDateTime;
begin
  tempDT := StrToDateDef(Value, 0);
  SetNextApptDate(tempDT);
end;

procedure TPatient.SetNextApptTime(Value: TTime);
begin
  FNextApptTime := Value;
  SetNextApptDate(NextScheduledINRCheckDate);
  //SetNextApptDate(DateOfNextScheduledINRCheck);
end;

function TPatient.GetDrawRestrictionsStr : string;
var ADay : tDaysOfWeek;
begin
  Result := '';
  for ADay := daySun to daySat do begin  //(daySun=1, dayMon=2, ...
    if not DrawRestrictionsArray[ADay] then continue;
    Result := Result + IntToStr(Ord(ADay)-1);  //Monday = 1
  end;
end;


// ======================================================

procedure TAppState.Clear();
begin
  //FNextApptDate                         := 0;
  EClinic                               := '';
  SvcCat                                := 'A';
  //NoteIEN                               := '';
  //NoteTitleIEN                          := '';
  //CosignNeeded                          := false;
  //CosignerDUZ                           := '';
  Cofactor                              := tcfUndef;
  INROrderSelected                      := false;
  CBCOrderSelected                      := false;
  Historical                            := false;
  OutsideLabDataEntered                 := false;
  PCEProcedureStr                       := '';
  SpecialInstructionsEdited             := false;
  RisksEdited                           := false;
  IncludeRisksInNote                    := false;
  PeopleOKForMessageChanged             := false;
  PushingDataToScreen                   := false;
  AppointmentShowStatus                 := tsvUndef;
  AppointmentNoShowDate                 := 0;
  FilePCEData                           := true;
  NextDayCallback                       := false;
  UserSelectedPillStrength              := false;
  ShowRetractedFlowsheets               := false;
  PctInGoalMode                         := igmNonComplex;

  //------------------
  PATIENT.Clear;
  Provider.Clear;
  Parameters.Clear;
  PastINRValues.Clear;
  CurrentNewFlowsheet.Clear;
  NoteInfo.Clear();
  if assigned(PCEData) then PCEData.Clear;
end;


{
function TAppState.DrawDaysRestrictionStr: string;
var
  AWeekDay: tDaysOfWeek;
begin
  Result := '';
  for AWeekDay := dayMon to dayFri do begin
    if not NoDrawOnDay[AWeekDay] then begin
      continue;
    end;
    if Result <> '' then begin
      Result := Result + ' ';
    end;
    Result := Result + DAY_NAMES[AWeekDay];
  end;
  if Result <> '' then
    Result := 'Do NOT draw on: ' + Result;
end;
}

procedure TAppState.Assign(Source: TAppState);
begin
  EClinic                              := Source.EClinic;
  SvcCat                               := Source.SvcCat;
  //NoteIEN                              := Source.NoteIEN;
  //NoteTitleIEN                         := Source.NoteTitleIEN;
  Cofactor                             := Source.Cofactor;
  //CosignNeeded                         := Source.CosignNeeded;
  //CosignerDUZ                          := Source.CosignerDUZ;
  INROrderSelected                     := Source.INROrderSelected;
  CBCOrderSelected                     := Source.CBCOrderSelected;
  //AccessibilityManager                 := Source.AccessibilityManager;
  Historical                           := Source.Historical;
  OutsideLabDataEntered                := Source.OutsideLabDataEntered;
  PCEProcedureStr                      := Source.PCEProcedureStr;
  SpecialInstructionsEdited            := Source.SpecialInstructionsEdited;
  RisksEdited                          := Source.RisksEdited;
  IncludeRisksInNote                   := Source.IncludeRisksInNote;
  PeopleOKForMessageChanged            := Source.PeopleOKForMessageChanged;
  PushingDataToScreen                  := Source.PushingDataToScreen;
  AppointmentShowStatus                := Source.AppointmentShowStatus;
  AppointmentNoShowDate                := Source.AppointmentNoShowDate;
  FilePCEData                          := Source.FilePCEData;
  NextDayCallback                      := Source.NextDayCallback;
  UserSelectedPillStrength             := Source.UserSelectedPillStrength;
  NoDrawOnDay                          := Source.NoDrawOnDay;
  PCEData                              := Source.PCEData; // not doing an assign because not owned here
  ShowRetractedFlowsheets              := Source.ShowRetractedFlowsheets;
  PctInGoalMode                        := Source.PctInGoalMode;
  //----------

  Patient.Assign(Source.Patient);
  Provider.Assign(Source.Provider);
  Parameters.Assign(Source.Parameters);
  PastINRValues.Assign(Source.PastINRValues);
  CurrentNewFlowsheet.Assign(Source.CurrentNewFlowsheet);
  NoteInfo.Assign(Source.NoteInfo);
end;

constructor TAppState.Create();
begin
  Patient := TPatient.Create();
  Provider := TProvider.Create();
  Parameters := TParameters.Create();
  PastINRValues := TPastINRValues.Create();
  CurrentNewFlowsheet := TOneFlowsheet.Create();
  PctInGoalMode := igmNonComplex;
  NoteInfo := TNoteInfo.Create();
  Clear;
end;

destructor TAppState.Destroy();
begin
  Patient.Free;
  Provider.Free;
  Parameters.Free;
  PastINRValues.Free;
  CurrentNewFlowsheet.Free;
  NoteInfo.Free;
end;

function TAppState.GetAppointmentShowStatusStr: string;
begin
  Result := IntToStr(Ord(AppointmentShowStatus));
end;


// ======================================================

procedure TProvider.Clear;
begin
  DUZ                       := '';
  Name                      := '';
  Initials                  := '';
  CosignNeeded              := false;
  DefaultCosigner           := '';
  HasOrESKey                := false;
  HaOrElseKey               := false;
  HasOrProviderKey          := false;
end;

procedure TProvider.Assign(Source: TProvider);
begin
  DUZ                       := Source.DUZ;
  Name                      := Source.Name;
  Initials                  := Source.Initials;
  CosignNeeded              := Source.CosignNeeded;
  DefaultCosigner           := Source.DefaultCosigner;
  HasOrESKey                := Source.HasOrESKey;
  HaOrElseKey               := Source.HaOrElseKey;
  HasOrProviderKey          := Source.HasOrProviderKey;
end;


// ========================================================================

function TNoteInfo.CosignOK : boolean;
begin
  if CosignNeeded then begin
    Result := (StrToIntDef(CosignerDUZ, -1) > 0);
  end else begin
    Result := true;
  end;
end;

procedure TNoteInfo.Clear;
begin
  NoteSL.Clear;
  NoteIEN          := '';
  CosignNeeded     := false;
  CosignerDUZ      := '';
  SaveSuccess      := false;
end;

procedure TNoteInfo.Assign(Source : TNoteInfo);
begin
  NoteSL.Assign(Source.NoteSL);
  NoteIEN          := Source.NoteIEN;
  CosignNeeded     := Source.CosignNeeded;
  CosignerDUZ      := Source.CosignerDUZ;
  SaveSuccess      := Source.SaveSuccess;
end;

constructor TNoteInfo.Create;
begin
  NoteSL := TStringList.Create;
end;

destructor TNoteInfo.Destroy;
begin
  NoteSL.Free;
end;


//==============================================================


end.
