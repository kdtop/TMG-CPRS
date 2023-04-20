unit uCore;
{ The core objects- patient, user, and encounter are defined here.  All other clinical objects
  in the GUI assume that these core objects exist. }

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

 (*
 NOTE: The original version of this file may be obtained freely from the VA.

 This modified version of the file is Copyright 6/23/2015 Kevin S. Toppenberg, MD
 --------------------------------------------------------------------

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 == Alternatively, at user's choice, GPL license below may be used ===

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may view details of the GNU General Public License at this URL:
 http://www.gnu.org/licenses/
 *)


interface

uses SysUtils, Windows, Classes, Forms, ORFn, rCore, uConst, ORClasses, uCombatVet
     ,Dialogs,Controls    //tmg   8/2/22
     ,Graphics,ORNet,VAUtils //kt Added
     ;

type
  TUser = class(TObject)
  private
    FDUZ:             Int64;                      // User DUZ (IEN in New Person file)
    FName:            string;                     // User Name (mixed case)
    FUserClass:       Integer;                    // User Class (based on OR keys for now)
    FCanSignOrders:   Boolean;                    // Has ORES key
    FIsProvider:      Boolean;                    // Has VA Provider key
    FOrderRole:       Integer;
    FNoOrdering:      Boolean;
    FEnableVerify:    Boolean;
    FDTIME:           Integer;
    FCountDown:       Integer;
    FCurrentPrinter:  string;
    FNotifyAppsWM:    Boolean;
    FDomain:          string;
    FPtMsgHang:       Integer;
    FService:         Integer;
    FAutoSave:        Integer;
    FInitialTab:      Integer;
    FUseLastTab:      Boolean;
    FWebAccess:       Boolean;
    FIsRPL:           string;
    FRPLList:         string;
    FHasCorTabs:      Boolean;
    FHasRptTab:       Boolean;
    FIsReportsOnly:   Boolean;
    FToolsRptEdit:    Boolean;
    FDisableHold:     Boolean;
    FGECStatus:       Boolean;
    FStationNumber:   string;
    FIsProductionAccount: boolean;
    FCanMakeTemplatesWithScripts : string[1];  //will be 'Y' if YES, 'N' if NO, or '' if not checked. //kt added 6/16
  public
    constructor Create;
    function HasKey(const KeyName: string): Boolean;
    function CanMakeTemplatesWithScripts : boolean; //kt added 6/23/16
    procedure SetCurrentPrinter(Value: string);
    property DUZ:             Int64   read FDUZ;
    property Name:            string  read FName;
    property UserClass:       Integer read FUserClass;
    property CanSignOrders:   Boolean read FCanSignOrders;
    property IsProvider:      Boolean read FIsProvider;
    property OrderRole:       Integer read FOrderRole;
    property NoOrdering:      Boolean read FNoOrdering;
    property EnableVerify:    Boolean read FEnableVerify;
    property DTIME:           Integer read FDTIME;
    property CountDown:       Integer read FCountDown;
    property PtMsgHang:       Integer read FPtMsgHang;
    property Service:         Integer read FService;
    property AutoSave:        Integer read FAutoSave;
    property InitialTab:      Integer read FInitialTab;
    property UseLastTab:      Boolean read FUseLastTab;
    property WebAccess:       Boolean read FWebAccess;
    property DisableHold:     Boolean read FDisableHold;
    property IsRPL:           string  read FIsRPL;
    property RPLList:         string  read FRPLList;
    property HasCorTabs:      Boolean read FHasCorTabs;
    property HasRptTab:       Boolean read FHasRptTab;
    property IsReportsOnly:   Boolean read FIsReportsOnly;
    property ToolsRptEdit:    Boolean read FToolsRptEdit;
    property CurrentPrinter:  string  read FCurrentPrinter write SetCurrentPrinter;
    property GECStatus:       Boolean read FGECStatus;
    property StationNumber:   string  read FStationNumber;
    property IsProductionAccount: boolean read FIsProductionAccount;
  end;

  TPatient = class(TObject)
  private
    FDFN:        string;                         // Internal Entry Number in Patient file  //*DFN*
    FICN:        string;                         // Integration Control Number from MPI
    FName:       string;                         // Patient Name (mixed case)
    FSSN:        string;                         // Patient Identifier (generally SSN)
    FDOB:        TFMDateTime;                    // Date of Birth in Fileman format
    FAge:        Integer;                        // Patient Age
    FSex:        Char;                           // Male, Female, Unknown
    FCWAD:       string;                         // chars identify if pt has CWAD warnings
    FRestricted: Boolean;                        // True if this is a restricted record
    FInpatient:  Boolean;                        // True if that patient is an inpatient
    FStatus:     string;                         // Patient status indicator (Inpatient or Outpatient)
    FLocation:   Integer;                        // IEN in Hosp Loc if inpatient
    FWardService: string;
    FSpecialty:  Integer;                        // IEN of the treating specialty if inpatient
    FSpecialtySvc: string;                       // treating specialty service if inpatient                                                                               
    FAdmitTime:  TFMDateTime;                    // Admit date/time if inpatient
    FSrvConn:    Boolean;                        // True if patient is service connected
    FSCPercent:  Integer;                        // Per Cent Service Connection
    FPrimTeam:   string;                         // name of primary care team
    FPrimProv:   string;                         // name of primary care provider
    FAttending:  string;                         // if inpatient, name of attending
    FAssociate:  string;                         // if inpatient, name of associate
    FInProvider:  string;                        // if inpatient, name of inpatient provider
    FMHTC:       string;                         // name of Mental Health Treatment Coordinator
    FNickName:   string;                         // Patient's nickname TMG added 8/29/22
    FDateDied: TFMDateTime;                      // Date of Patient Death (<=0 or still alive)
    FDateDiedLoaded: boolean;                    // Used to determine of DateDied has been loaded
    FCombatVet : TCombatVet;                     // Object Holding CombatVet Data
    FDueColor : TColor;                          // Get patient due color  //kt
    FDueInfo : TStringList;                      // Holds patient due status info  //kt
    FDueHint : string;                           // Hint for due status   //kt
    FSyncWebPages : boolean;                     // If true changing patient will change web pages  //kt
    FMostRecentPhoto : string;                   // FPath for most recent patient photo
    //vwpt  HRN
    FHRN:  string ;                              //HRN
    FAltHRN : string ;                           //alternate HRN (future)
    //end vwpt
    procedure SetDFN(const Value: string);
    function GetDateDied: TFMDateTime;
    function GetCombatVet: TCombatVet;       // *DFN*
  public
    procedure Clear;
    procedure ClearWithoutWebSync;  //kt
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source : TPatient);  //kt 9/11
    property DFN:              string      read FDFN write SetDFN;  //*DFN*
    property ICN:              string      read FICN;
    property Name:             string      read FName;
    property NickName:         string      read FNickName;   //TMG added 8/29/22
    property SSN:              string      read FSSN;
    property DOB:              TFMDateTime read FDOB;
    property Age:              Integer     read FAge;
    property Sex:              Char        read FSex;
    property CWAD:             string      read FCWAD;
    property Inpatient:        Boolean     read FInpatient;
    property Status:           string      read FStatus;
    property Location:         Integer     read FLocation;
    property WardService:      string      read FWardService;
    property Specialty:        Integer     read FSpecialty;
    property SpecialtySvc:     string      read FSpecialtySvc;
    property AdmitTime:        TFMDateTime read FAdmitTime;
    property DateDied:         TFMDateTime read GetDateDied;
    property ServiceConnected: Boolean     read FSrvConn;
    property SCPercent:        Integer     read FSCPercent;
    property PrimaryTeam:      string      read FPrimTeam;
    property PrimaryProvider:  string      read FPrimProv;
    property Attending:        string      read FAttending;
    property Associate:        string      read FAssociate;
    property InProvider:        string     read FInProvider;
    property MHTC:             string      read FMHTC;
    property CombatVet:        TCombatVet  read GetCombatVet;
    property DueColorCode:     TColor      read FDueColor; 
    property DueHint:          string      read FDueHint;
    property DueInfo:          TStringList read FDueInfo;
    property SyncWebPages:     boolean     read FSyncWebPages write FSyncWebPages;   //kt
    //vwpt HRN AltHRN
    property HRN:              string      read FHRN ;
    property AltHRN:           string      read FAltHRN;
    //end vwpt
  end;

  TEncounter = class(TObject, IORNotifier)
  private
    FChanged:       Boolean;                     // one or more visit fields have changed
    FDateTime:      TFMDateTime;                 // date/time of encounter (appt, admission)
    FInpatient:     Boolean;                     // true if this is an inpatient encounter
    FLocation:      Integer;                     // IEN in Hospital Location file
    FLocationName:  string;                      // Name in Hospital Location file
    FLocationText:  string;                      // Name + Date/Time or Name + RoomBed
    FProvider:      Int64  ;                     // IEN in New Person file
    FProviderName:  string;                      // Name in New Person file
    FVisitCategory: Char;                        // A=ambulatory,T=Telephone,H=inpt,E=historic
    FStandAlone:    Boolean;                     // true if visit not related to appointment
    FNotifier:      IORNotifier;                 // Event handlers for location changes
    FICD10ImplDate:  TFMDateTime;                 // ICD-10-CM Activation Date
    function GetLocationName: string;
    function GetLocationText: string;
    function GetProviderName: string;
    function GetVisitCategory: Char;
    function GetVisitStr: string;
    procedure SetDateTime(Value: TFMDateTime);
    procedure SetInpatient(Value: Boolean);
    procedure SetLocation(Value: Integer);
    procedure SetProvider(Value: Int64);
    procedure SetStandAlone(Value: Boolean);
    procedure SetVisitCategory(Value: Char);
    procedure UpdateText;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure EncounterSwitch(Loc: integer; LocName, LocText: string; DT: TFMDateTime; vCat: Char);
    procedure SwitchToSaved(ShowInfoBox: boolean);
    procedure EmptySaved();
    procedure CreateSaved(Reason: string);
    function GetICDVersion: String;
    function GetICDVersionCode: String;  //kt added
    function NeedVisit: Boolean;
    function NeedVisitWVerification: Boolean;     //TMG added entire function 8/2/22
    property DateTime:        TFMDateTime read FDateTime  write SetDateTime;
    property Inpatient:       Boolean     read FInpatient write SetInpatient;
    property Location:        Integer     read FLocation  write SetLocation;
    property LocationName:    string      read GetLocationName write FLocationName;
    property LocationText:    string      read GetLocationText write FLocationText;
    property Provider:        Int64       read FProvider  write SetProvider;
    property ProviderName:    string      read GetProviderName;
    property StandAlone:      Boolean     read FStandAlone write SetStandAlone;
    property VisitCategory:   Char        read GetVisitCategory write SetVisitCategory;
    property VisitStr:        string      read GetVisitStr;
    property Notifier:        IORNotifier read FNotifier implements IORNotifier;
    property ICD10ImplDate: TFMDateTime read FICD10ImplDate;
  end;

  TChangeItem = class
  private
    FItemType:     Integer;
    FID:           String;
    FText:         String;
    FGroupName:    String;
    FSignState:    Integer;
    FParentID:     String;
    FUser:         Int64;
    FOrderDG:      String;
    FDCOrder:      Boolean;
    FDelay:        Boolean;
    constructor Create(AnItemType: Integer; const AnID, AText, AGroupName: string;
      ASignState: Integer; AParentID: string = ''; User: int64 = 0; OrderDG: string = '';
      DCOrder: Boolean = False; Delay: Boolean = False);
  public
    property ItemType:  Integer read FItemType;
    property ID:        string  read FID;
    property Text:      string  read FText;
    property GroupName: string  read FGroupName;
    property SignState: Integer read FSignState write FSignState;
    property ParentID : string  read FParentID;
    property User: Int64 read FUser write FUser;
    property OrderDG: string read FOrderDG write FOrderDG;
    property DCOrder: boolean read FDCOrder write FDCOrder;
    property Delay: boolean read FDelay write FDelay;
    function CSValue(): Boolean;
  end;

  TORRemoveChangesEvent = procedure(Sender: TObject; ChangeItem: TChangeItem) of object;  {**RV**}

  TChanges = class
  private
    FCount:        Integer;
    FDocuments:    TList;
    FOrders:       TList;
    FOrderGrp:     TStringList;
    FPCE:          TList;
    FPCEGrp:       TStringList;
    FOnRemove:     TORRemoveChangesEvent;    {**RV**}
    FRefreshCoverPL: Boolean;
    FRefreshProblemList: Boolean;
  private
    procedure AddUnsignedToChanges;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(ItemType: Integer; const AnID, ItemText, GroupName: string; SignState: Integer; AParentID: string = '';
                  User: int64 = 0; OrderDG: String = ''; DCOrder: Boolean = False; Delay: Boolean = False; ProblemAdded: Boolean = False);
    procedure Clear;
    function CanSign: Boolean;
    function Exist(ItemType: Integer; const AnID: string): Boolean;
    function ExistForOrder(const AnID: string): Boolean;
    function Locate(ItemType: Integer; const AnID: string): TChangeItem;
    procedure Remove(ItemType: Integer; const AnID: string);
    procedure ReplaceID(ItemType: Integer; const OldID, NewID: string);
    procedure ReplaceSignState(ItemType: Integer; const AnID: string; NewState: Integer);
    procedure ReplaceText(ItemType: Integer; const AnID, NewText: string);
    procedure ReplaceODGrpName(const AnODID, NewGrp: string);
    procedure ChangeOrderGrp(const oldGrpName,newGrpName: string);
    function RequireReview: Boolean;
    property Count:      Integer     read FCount;
    property Documents:  TList       read FDocuments;
    property OnRemove: TORRemoveChangesEvent read FOnRemove write FOnRemove;        {**RV**}
    property Orders:     TList       read FOrders;
    property PCE:        TList       read FPCE;
    property OrderGrp: TStringList read FOrderGrp;
    property PCEGrp:   TStringList read FPCEGrp;
    property RefreshCoverPL: Boolean read FRefreshCoverPL write FRefreshCoverPL;
    property RefreshProblemList: Boolean read FRefreshProblemList write FRefreshProblemList;
  end;

  TNotifyItem = class
  private
    DFN: string;
    FollowUp: Integer;
    //AlertData: string;
    RecordID: string;
    HighLightSection: String;
  end;

  TNotifications = class
  private
    FActive: Boolean;
    FList: TList;
    FCurrentIndex: Integer;
    FNotifyItem: TNotifyItem;
    FNotifIndOrders: boolean;
    function GetDFN: string;  //*DFN*
    function GetFollowUp: Integer;
    function GetAlertData: string;
    function GetHighLightSection: String; //CB
    function GetIndOrderDisplay: Boolean;
    function GetRecordID: string;
    function GetText: string;
    procedure SetIndOrderDisplay(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const ADFN: string; AFollowUp: Integer; const ARecordID: string; AHighLightSection : string = '');  //*DFN*  CB
    procedure Clear;
    procedure Next;
    procedure Prior;
    procedure Delete;
    procedure DeleteForCurrentUser;
    property Active:   Boolean read FActive;
    property DFN:      string  read GetDFN;  //*DFN*
    property FollowUp: Integer read GetFollowUp;
    property AlertData: string read GetAlertData;
    property RecordID: string  read GetRecordID;
    property Text:     string  read GetText;
    property HighLightSection: String read GetHighLightSection; //cb
    property IndOrderDisplay:  Boolean read GetIndOrderDisplay write SetIndOrderDisplay;
  end;

  TRemoteSite = class
  private
    FSiteID: string;
    FSiteName: string;
    FLastDate: TFMDateTime;
    FSelected: Boolean;
    FRemoteHandle: string;
    FLabRemoteHandle: string;
    FQueryStatus: string;
    FLabQueryStatus: string;
    FData: TStringList;
    FLabData: TStringList;
    FCurrentLabQuery: string;
    FCurrentReportQuery: string;
    procedure SetSelected(Value: Boolean);
  public
    destructor  Destroy; override;
    constructor Create(ASite: string);
    procedure ReportClear;
    procedure LabClear;
    property SiteID  : string        read FSiteID;
    property SiteName: string        read FSiteName;
    property LastDate: TFMDateTime   read FLastDate;
    property Selected: boolean       read FSelected write SetSelected;
    property RemoteHandle: string    read FRemoteHandle write FRemoteHandle;
    property QueryStatus: string     read FQueryStatus write FQueryStatus;
    property Data: TStringList       read FData write FData;
    property LabRemoteHandle: string read FLabRemoteHandle write FLabRemoteHandle;
    property LabQueryStatus: string  read FLabQueryStatus write FLabQueryStatus;
    property LabData: TStringList    read FLabData write FLabData;
    property CurrentLabQuery: string    read FCurrentLabQuery write FCurrentLabQuery;
    property CurrentReportQuery: string read FCurrentReportQuery write FCurrentReportQuery;
  end;

  TRemoteSiteList = class
  private
    FCount: integer;
    FSiteList: TList;
    FRemoteDataExists: Boolean;
    FNoDataReason: string;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure   Add(ASite: string);
    procedure   ChangePatient(const DFN: string);
    procedure   Clear;
    property    Count           : integer     read FCount;
    property    SiteList        : TList       read FSiteList;
    property    RemoteDataExists: Boolean     read FRemoteDataExists;
    property    NoDataReason    : string      read FNoDataReason;
  end;

  TRemoteReport = class
  private
    FReport: string;
    FHandle: string;
  public
    constructor Create(AReport: string);
    destructor Destroy; override;
    property Handle            :string     read FHandle write FHandle;
    property Report            :string     read FReport write FReport;
  end;

  TRemoteReportList = class
  private
    FCount: integer;
    FReportList: TList;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure   Add(AReportList, AHandle: string);
    procedure   Clear;
    property    Count           :integer     read FCount;
    property    ReportList      :TList       read FReportList;
  end;

  PReportTreeObject = ^TReportTreeObject;
  TReportTreeObject = Record
    ID       : String;         //Report ID
    Heading  : String;         //Report Heading
    Remote   : String;         //Remote Data Capable
    RptType  : String;         //Report Type
    Category : String;         //Report Category
    RPCName  : String;         //Associated RPC
    IFN      : String;         //IFN of report in file 101.24
    HDR      : String;         //HDR is source of data if = 1
  end;

  TCurrentSequelPat = class   //kt TMG added 6/5/18
  private
    FName: string;
    FDOB: TDateTime;
    FFMDOB: TFMDateTime;
    FAcctNum: string;
    FDFN: string;
    FWindowText: string;
    FNew: boolean;
  public
    procedure Clear;
    constructor Create;
    procedure SetPatientText();
    property    Name           :string      read FName;
    property    DOB            :TDateTime   read FDOB;
    property    FMDOB          :TFMDateTime read FFMDOB;
    property    AcctNum        :string      read FAcctNum;
    property    DFN            :string      read FDFN;
    property    WindowText     :string      read FWindowText;
    property    New            :boolean     read FNew;
  end;

var
  User: TUser;
  Patient: TPatient;
  CurSequelPat:TCurrentSequelPat;   //TMG added 6/5/18
  SequelWindowText:string;          //TMG added 6/5/18
  LastDFNFound:string;              //TMG added 6/5/18
  Encounter: TEncounter = nil;
  SavedEncounter: TEncounter = nil;
  Changes: TChanges;
  RemoteSites: TRemoteSiteList;
  RemoteReports: TRemoteReportList;
  Notifications: TNotifications;
  HasFlag: boolean;
  FlagList: TStringList;
  hidePtSSN: boolean = false;  // agp wv change  //kt
  //hds7591  Clinic/Ward movement.
  TempEncounterLoc: Integer; // used to Save Encounter Location when user selected "Review Sign Changes" from "File"
  TempEncounterLocName: string; // since in the path PatientRefresh is done prior to checking if patient has been admitted while entering OPT orders.
  TempEncounterText: string;
  TempEncounterDateTime: TFMDateTime;
  TempEncounterVistCat: Char;
  SavedEncounterLoc: Integer; // used to Save Encounter Location when doing clinic meds/ivs
  SavedEncounterLocName: string;
  SavedEncounterText: string;
  SavedEncounterDateTime: TFMDateTime;
  SavedEncounterVisitCat: Char;
  SavedEncounterReason: string; //used to store why it will be reverted to the saved value
  //TempOutEncounterLoc: Integer;
  //TempOutEncounterLocName: string;

procedure NotifyOtherApps(const AppEvent, AppData: string);
procedure FlushNotifierBuffer;
procedure TerminateOtherAppNotification;
procedure GotoWebPage(const URL: WideString);
function subtractMinutesFromDateTime(Time1 : TDateTime;Minutes : extended) : TDateTime;
function AllowAccessToSensitivePatient(NewDFN: string; var AccessStatus: integer): boolean;


implementation

uses rTIU, rOrders, rConsults, uOrders
     ,fFrame , uTMGOptions //kt added
     ;

type
  HlinkNavProc = function(pUnk: IUnknown; szTarget: PWideChar): HResult; stdcall;

var
  uVistaMsg, uVistaDomMsg: UINT;
  URLMonHandle: THandle = 0;
  HlinkNav: HlinkNavProc;

type
  TNotifyAppsThread = class(TThread)
  private
    FRunning: boolean;
  public
    constructor CreateThread;
    procedure ResumeIfIdle;
    procedure ResumeAndTerminate;
    procedure Execute; override;
    property Running: boolean read FRunning;
  end;

  TMsgType = (mtVistaMessage, mtVistaDomainMessage);

var
  uSynchronizer: TMultiReadExclusiveWriteSynchronizer = nil;
  uNotifyAppsThread: TNotifyAppsThread = nil;
  uNotifyAppsQueue: TStringList = nil;
  uNotifyAppsActive: boolean = TRUE;
  AnAtom: ATOM = 0;

const
  LONG_BROADCAST_TIMEOUT = 30000; // 30 seconds
  SHORT_BROADCAST_TIMEOUT = 2000; // 2 seconds
  MSG_TYPE: array[TMsgType] of String = ('V','D');

function AllowAccessToSensitivePatient(NewDFN: string; var AccessStatus: integer): boolean;
const
  TX_DGSR_ERR    = 'Unable to perform sensitive record checks';
  TC_DGSR_ERR    = 'Error';
  TC_DGSR_SHOW   = 'Restricted Record';
  TC_DGSR_DENY   = 'Access Denied';
  TX_DGSR_YESNO  = CRLF + 'Do you want to continue processing this patient record?';
  TC_NEXT_NOTIF  = 'NEXT NOTIFICATION:  ';
var
  //AccessStatus: integer;
  AMsg, PrefixC, PrefixT: string;
begin
  Result := TRUE;
  if Notifications.Active then
  begin
    PrefixT := Piece(Notifications.RecordID, U, 1) + CRLF + CRLF;
    PrefixC := TC_NEXT_NOTIF;
  end
  else
  begin
    PrefixT := '';
    PrefixC := '';
  end;
  CheckSensitiveRecordAccess(NewDFN, AccessStatus, AMsg);
  case AccessStatus of
  DGSR_FAIL: begin
               InfoBox(PrefixT + TX_DGSR_ERR, PrefixC + TC_DGSR_ERR, MB_OK);
               Result := FALSE;
             end;
  DGSR_NONE: { Nothing - allow access to the patient. };
  DGSR_SHOW: InfoBox(PrefixT + AMsg, PrefixC + TC_DGSR_SHOW, MB_OK);
  DGSR_ASK:  if InfoBox(PrefixT + AMsg + TX_DGSR_YESNO, PrefixC + TC_DGSR_SHOW, MB_YESNO or MB_ICONWARNING or
               MB_DEFBUTTON2) = IDYES then LogSensitiveRecordAccess(NewDFN)
             else Result := FALSE;
  else       begin
               InfoBox(PrefixT + AMsg, PrefixC + TC_DGSR_DENY, MB_OK);
               if Notifications.Active then Notifications.DeleteForCurrentUser;
               Result := FALSE;
             end;
  end;
end;

function QueuePending: boolean;
begin
  uSynchronizer.BeginRead;
  try
    Result := (uNotifyAppsQueue.Count > 0);
  finally
    uSynchronizer.EndRead;
  end;
end;

procedure ProcessQueue(ShortTimout: boolean);
var
  msg: String;
  process: boolean;
  AResult: LPDWORD;
  MsgCode, timeout: UINT;
  TypeCode: String;

begin
  if(not QueuePending) then exit;
  uSynchronizer.BeginWrite;
  try
    process := (uNotifyAppsQueue.Count > 0);
    if(process) then
    begin
      msg := uNotifyAppsQueue.Strings[0];
      uNotifyAppsQueue.Delete(0);
    end;
  finally
    uSynchronizer.EndWrite;
  end;
  if(process) then
  begin
    TypeCode := copy(msg,1,1);
    delete(msg,1,1);
    if(TypeCode = MSG_TYPE[mtVistaMessage]) then
      MsgCode := uVistaMsg
    else
      MsgCode := uVistaDomMsg;

    if(ShortTimout) then
      timeout := SHORT_BROADCAST_TIMEOUT
    else
      timeout := LONG_BROADCAST_TIMEOUT;

    // put text in the global atom table
    AnAtom := GlobalAddAtom(PChar(msg));
    if (AnAtom <> 0) then
    begin
      try
        // broadcast 'VistA Domain Event - Clinical' to all main windows
        //SendMessage(HWND_BROADCAST, uVistaDomMsg, WPARAM(Application.MainForm.Handle), LPARAM(AnAtom));
        //
        //Changed to SendMessageTimeout to prevent hang when other app unresponsive  (RV)
        AResult := nil;
{$WARN SYMBOL_DEPRECATED OFF} // researched
{$WARN SYMBOL_PLATFORM OFF}
        SendMessageTimeout(HWND_BROADCAST, MsgCode, WPARAM(Application.MainForm.Handle), LPARAM(AnAtom),
                SMTO_ABORTIFHUNG or SMTO_BLOCK, timeout, AResult^);
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_DEPRECATED ON}
      finally
      // after all windows have processed the message, remove the text from the table
        GlobalDeleteAtom(AnAtom);
        AnAtom := 0;
      end;
    end;
  end;
end;

constructor TNotifyAppsThread.CreateThread;
begin
  inherited Create(TRUE);
  FRunning := TRUE;
end;

procedure TNotifyAppsThread.ResumeIfIdle;
begin
  if(Suspended) then
{$WARN SYMBOL_DEPRECATED OFF} // researched
    Resume;
{$WARN SYMBOL_DEPRECATED ON}
end;

procedure TNotifyAppsThread.ResumeAndTerminate;
begin
  Terminate;
  if(Suspended) then
{$WARN SYMBOL_DEPRECATED OFF} // researched
    Resume;
{$WARN SYMBOL_DEPRECATED ON}
end;

procedure TNotifyAppsThread.Execute;
begin
  while(not Terminated) do
  begin
    if(QueuePending) then
      ProcessQueue(FALSE)
    else if(not Terminated) then
{$WARN SYMBOL_DEPRECATED OFF} // researched
      Suspend;
{$WARN SYMBOL_DEPRECATED ON}
  end;
  FRunning := FALSE;
end;

function AppNotificationEnabled: boolean;
begin
  Result := FALSE;
  if(not uNotifyAppsActive) then exit;
  if Application.MainForm = nil then Exit;
  if User = nil then exit;
  if not User.FNotifyAppsWM then Exit;
  // register the message with windows to get a unique message number (if not already registered)
  if uVistaMsg = 0    then uVistaMsg    := RegisterWindowMessage('VistA Event - Clinical');
  if uVistaDomMsg = 0 then uVistaDomMsg := RegisterWindowMessage('VistA Domain Event - Clinical');
  if (uVistaMsg = 0) or (uVistaDomMsg = 0) then Exit;
  if(not assigned(uNotifyAppsQueue)) then
    uNotifyAppsQueue := TStringList.Create;
  if(not assigned(uSynchronizer)) then
    uSynchronizer := TMultiReadExclusiveWriteSynchronizer.Create;
  if(not assigned(uNotifyAppsThread)) then
    uNotifyAppsThread := TNotifyAppsThread.CreateThread;
  Result := TRUE;
end;

procedure ReleaseAppNotification;
var
  waitState: DWORD;

begin
  uNotifyAppsActive := FALSE;
  if(assigned(uNotifyAppsThread)) then
  begin
    uNotifyAppsThread.ResumeAndTerminate;
    sleep(10);
    if(uNotifyAppsThread.Running) then
    begin
      waitState := WaitForSingleObject(uNotifyAppsThread.Handle, SHORT_BROADCAST_TIMEOUT);
      if((waitState = WAIT_TIMEOUT) or
         (waitState = WAIT_FAILED) or
         (waitState = WAIT_ABANDONED)) then
      begin
        TerminateThread(uNotifyAppsThread.Handle, 0);
        if(AnAtom <> 0) then
        begin
          GlobalDeleteAtom(AnAtom);
          AnAtom := 0;
        end;
      end;
    end;
    FreeAndNil(uNotifyAppsThread);
  end;
  if(assigned(uSynchronizer)) and
    (assigned(uNotifyAppsQueue)) then
  begin
    while(QueuePending) do
      ProcessQueue(TRUE);
  end;
  FreeAndNil(uSynchronizer);
  FreeAndNil(uNotifyAppsQueue);
end;

procedure NotifyOtherApps(const AppEvent, AppData: string);
var
  m1: string;
  m2: string;

begin
  if(AppNotificationEnabled) then
  begin
    // first send the domain version of the message
    m1 := MSG_TYPE[mtVistaDomainMessage] + AppEvent + U + 'CPRS;' + User.FDomain + U + Patient.DFN + U + AppData;
    // for backward compatibility, send the message without the domain
    m2 := MSG_TYPE[mtVistaMessage] + AppEvent + U + 'CPRS' + U + Patient.DFN + U + AppData;
    uSynchronizer.BeginWrite;
    try
      uNotifyAppsQueue.Add(m1);
      uNotifyAppsQueue.Add(m2);
    finally
      uSynchronizer.EndWrite;
    end;
    uNotifyAppsThread.ResumeIfIdle;
  end;
end;

procedure FlushNotifierBuffer;
begin
  if(AppNotificationEnabled) then
  begin
    uSynchronizer.BeginWrite;
    try
      uNotifyAppsQueue.Clear;
    finally
      uSynchronizer.EndWrite;
    end;
  end;
end;

procedure TerminateOtherAppNotification;
begin
  ReleaseAppNotification;
end;

{ TUser methods ---------------------------------------------------------------------------- }

constructor TUser.Create;
{ create the User object for the currently logged in user }
var
  UserInfo: TUserInfo;
begin
  UserInfo := GetUserInfo;
  FDUZ           := UserInfo.DUZ;
  FName          := UserInfo.Name;
  FUserClass     := UserInfo.UserClass;
  FCanSignOrders := UserInfo.CanSignOrders;
  FIsProvider    := UserInfo.IsProvider;
  FOrderRole     := UserInfo.OrderRole;
  FNoOrdering    := UserInfo.NoOrdering;
  FEnableVerify  := UserInfo.EnableVerify;
  FDTIME         := UserInfo.DTIME;
  FCountDown     := UserInfo.CountDown;
  FNotifyAppsWM  := UserInfo.NotifyAppsWM;
  FDomain        := UserInfo.Domain;
  FPtMsgHang     := UserInfo.PtMsgHang;
  FService       := UserInfo.Service;
  FAutoSave      := UserInfo.AutoSave;
  FInitialTab    := UserInfo.InitialTab;
  FUseLastTab    := UserInfo.UseLastTab;
  if(URLMonHandle = 0) then
    FWebAccess := FALSE
  else
    FWebAccess := UserInfo.WebAccess;
  FDisableHold     := UserInfo.DisableHold;
  FIsRPL           := UserInfo.IsRPL;
  FRPLList         := UserInfo.RPLList;
  FHasCorTabs      := UserInfo.HasCorTabs;
  FHasRptTab       := UserInfo.HasRptTab;
  FIsReportsOnly   := UserInfo.IsReportsOnly;
  FToolsRptEdit    := UserInfo.ToolsRptEdit;
  FCurrentPrinter  := GetDefaultPrinter(DUZ, 0);
  FGECStatus       := UserInfo.GECStatusCheck;
  FStationNumber   := UserInfo.StationNumber;
  FIsProductionAccount := UserInfo.IsProductionAccount;
  FCanMakeTemplatesWithScripts := '';  //kt 6/16
end;

function TUser.HasKey(const KeyName: string): Boolean;
{ returns true if the current user has the given security key }
begin
  Result := HasSecurityKey(KeyName);
end;

function TUser.CanMakeTemplatesWithScripts : boolean;
//kt added function 6/23/16
begin
  if FCanMakeTemplatesWithScripts = '' then begin
    FCanMakeTemplatesWithScripts := uTMGOptions.ReadString('Create Templates With Scripts','N');  //Set to false by default
  end;
  Result := (FCanMakeTemplatesWithScripts = 'Y');
end;

procedure TUser.SetCurrentPrinter(Value: string);
//kt moved this procedure here from further down in the document.
//   It wasn't grouped here with other TUser procs.
begin
  FCurrentPrinter := Value;
end;

{ TCurrentSequelPat methods ------------------------------------------------------------------------- }
//TMG added all these methods
procedure TCurrentSequelPat.Clear();
begin
  FName := '';
  FDOB := 0;
  FFMDOB := 0;
  FAcctNum := '';
  FWindowText := '';
  uCore.SequelWindowText := '';
  FNew := false;
end;

function EnumWindowsProc(hwnd: HWND; lParam: LPARAM): BOOL; stdcall;
var
  s: string;
  IsVisible, IsOwned, IsAppWindow: Boolean;
begin
  Result := True;//carry on enumerating

  IsVisible := IsWindowVisible(hwnd);
  if not IsVisible then
    exit;

  IsOwned := GetWindow(hwnd, GW_OWNER)<>0;
  if IsOwned then
    exit;

  {IsAppWindow := GetWindowLongPtr(hwnd, GWL_STYLE) and WS_EX_APPWINDOW<>0;
  if not IsAppWindow then
    exit;}

  SetLength(s, GetWindowTextLength(hwnd));
  GetWindowText(hwnd, PChar(s), Length(s)+1);
  if pos('SequelMed',s)>0 then uCore.SequelWindowText := s;
end;

procedure TCurrentSequelPat.SetPatientText();
    function IsDate(str: string): Boolean;
    var
      dt: TDateTime;
    begin
      Result := True;
      try
        dt := StrToDate(str);
      except
        Result := False;
      end;
    end;
begin
   FWindowText := uCore.SequelWindowText;
   //For testing only -> FWindowText := 'SequelMed GROUP sequelmed TAMMY HENSLEY 321213 03/15/1964, P# 43780 - [Patient Find]';
   FName := piece(WindowText,' ',5)+','+piece(WindowText,' ',4);
   FAcctNum := piece(WindowText,' ',6);
   if (FAcctNum<>'') and (IsDate(piece(piece(WindowText,' ',7),',',1))) then begin
     FDOB := strtodate(piece(piece(WindowText,' ',7),',',1));
     FFMDOB := DateTimeToFMDateTime(FDOB);
     FDFN := sCallV('TMG CPRS FIND PATIENT DFN',[FAcctNum,FName,FMDTToStr(FFMDOB)]);
     if FDFN='0' then begin
       Showmsg('Could not find patient in VistA'+#13#10+FWindowText);
       Clear;
       LastDFNFound := '0';
     end else begin
       FNew := FDFN<>LastDFNFound;
       LastDFNFound := FDFN;
     end;
  end else begin
   Showmsg('No patient selected in SequelMed');
   Clear;
   LastDFNFound := '0';
  end;
end;

constructor TCurrentSequelPat.Create;
begin
  Clear;
  EnumWindows(@EnumWindowsProc, 0);
  if uCore.SequelWindowText<>'' then SetPatientText
  else ShowMsg('SequelMed does not appear to be running');
  //FName := 'zztest,baby';
  //FDOB := '1/1/15';
  //FAcctNum := '321111';
end;

{ TPatient methods ------------------------------------------------------------------------- }

procedure TPatient.ClearWithoutWebSync;
//kt added entire procedure
var   tempWebSync : boolean;
begin
   tempWebSync := SyncWebPages;
   SyncWebPages := False;
   Clear;
   SyncWebPages := tempWebSync;
end;

procedure TPatient.Clear;
{ clears all fields in the Patient object }
begin
  FDFN          := '';
  FName         := '';
  FSSN          := '';
  FDOB          := 0;
  FAge          := 0;
  FSex          := 'U';
  FCWAD         := '';
  FRestricted   := False;
  FInpatient    := False;
  FStatus       := '';
  FLocation     := 0;
  FWardService  := '';
  FSpecialty    := 0;
  FSpecialtySvc := '';
  FAdmitTime    := 0;
  FSrvConn      := False;
  FSCPercent    := 0;
  FPrimTeam     := '';
  FPrimProv     := '';
  FAttending    := '';
  FMHTC         := '';
  FDueInfo.Clear;  //kt 10/23/14
  FDueColor := clInfoBK;    //kt 10/23/14
  if FSyncWebPages = True then frmFrame.SetWebTabsPerServer;  //kt 4/19/15
  FreeAndNil(FCombatVet);
  //vwpt hrn althrn
  FHRN         := '';
  FAltHRN      := '';
  //end vwpt
  FNickName      := '';    //TMG 8/29/22
end;

destructor TPatient.Destroy;
begin
  FreeAndNil(FCombatVet);
  FDueInfo.Free;  //kt  10/23/14
  inherited;
end;

constructor TPatient.Create;
//kt created entire function  10/23/14
begin
  inherited;
  FDueInfo := TStringList.Create();
  FSyncWebPages := True;
end;

procedure TPatient.Assign(Source : TPatient);
//kt 9/11 added 
begin
  DFN := Source.DFN;
  {Note: other properties are read only, determined by DFN}
end;


function TPatient.GetCombatVet: TCombatVet;
begin
  if FCombatVet = nil then
    FCombatVet := TCombatVet.Create(FDFN);
  Result := FCombatVet;
end;

function TPatient.GetDateDied: TFMDateTime;
begin
  if(not FDateDiedLoaded) then
  begin
    FDateDied := DateOfDeath(FDFN);
    FDateDiedLoaded := TRUE;
  end;
  Result := FDateDied;
end;

procedure TPatient.SetDFN(const Value: string);  //*DFN*
{ selects a patient and sets up the Patient object for the patient }
var
  PtSelect: TPtSelect;
begin
  if (Value = '') or (Value = FDFN) then Exit;  //*DFN*
  Clear;
  SelectPatient(Value, PtSelect);
  FDueColor := GetPatientDueInfo(FDueInfo,Value,FDueHint);  //kt 10/23/14
  FDFN        := Value;
  FName       := PtSelect.Name;
  FICN        := PtSelect.ICN;
  FSSN        := PtSelect.SSN;
  FDOB        := PtSelect.DOB;
  FAge        := PtSelect.Age;
  FSex        := PtSelect.Sex;
  FCWAD       := PtSelect.CWAD;
  FRestricted := PtSelect.Restricted;
  FInpatient  := Length(PtSelect.Location) > 0;
  if FInpatient then FStatus := ' (INPATIENT)'
  else FStatus := ' (OUTPATIENT)';
  FWardService := PtSelect.WardService;
  FLocation   := PtSelect.LocationIEN;
  FSpecialty  := PtSelect.SpecialtyIEN;
  FSpecialtySvc := PtSelect.SpecialtySvc;
  FAdmitTime  := PtSelect.AdmitTime;
  FSrvConn    := PtSelect.ServiceConnected;
  FSCPercent  := PtSelect.SCPercent;
  FPrimTeam   := PtSelect.PrimaryTeam;
  FPrimProv   := PtSelect.PrimaryProvider;
  FAttending  := PtSelect.Attending;
  FAssociate  := PtSelect.Associate;
  //vwpt HRN ALTHRN
  FHRN        := PtSelect.HRN;
  FAltHRN     := PtSelect.AltHRN;
  //end vwpt
  FNickName   := PtSelect.NickName;
  FInProvider := PtSelect.InProvider;
  FMHTC       := PtSelect.MHTC    ;
  if FSyncWebPages = True then frmFrame.SetWebTabsPerServer;  //kt 4/19/15
end;

{ TEncounter ------------------------------------------------------------------------------- }

constructor TEncounter.Create;
begin
  inherited;
  FNotifier := TORNotifier.Create(Self, TRUE);
  FICD10ImplDate := GetICD10ImplementationDate;
end;

destructor TEncounter.Destroy;
begin
  FNotifier := nil; // Frees instance
  inherited;
end;

procedure TEncounter.EncounterSwitch(Loc: integer; LocName, LocText: string; DT: TFMDateTime; vCat: Char);
begin
 Encounter.Location := Loc;
 Encounter.LocationName := LocName;
 Encounter.LocationText := LocText;
 Encounter.VisitCategory := vCat;
 Encounter.DateTime := DT;;
end;

procedure TEncounter.CreateSaved(Reason: string);
begin
    SavedEncounterLoc := Encounter.Location;
    SavedEncounterLocName := Encounter.LocationName;
    SavedEncounterText := Encounter.LocationText;
    SavedEncounterDateTime := Encounter.DateTime;
    SavedEncounterVisitCat := Encounter.VisitCategory;
    SavedEncounterReason := Reason;
end;

procedure TEncounter.EmptySaved();
begin
  SavedEncounterLoc := 0;
  SavedEncounterLocName := '';
  SavedEncounterText := '';
  SavedEncounterDateTime := 0;
  SavedEncounterVisitCat := #0;
  SavedEncounterReason := '';
end;

procedure TEncounter.SwitchToSaved(ShowInfoBox: boolean);
begin
  if SavedEncounterLoc > 0 then
  begin
    if ShowInfoBox then InfoBox(SavedEncounterReason, 'Notice', MB_OK or MB_ICONWARNING);
    EncounterSwitch(SavedEncounterLoc, SavedEncounterLocName, SavedEncounterText, SavedEncounterDateTime, SavedEncounterVisitCat);
    EmptySaved();
  end;
end;

procedure TEncounter.Clear;
{ clears all the fields of an Encounter (usually done upon patient selection }
begin
  FChanged      := False;
  FDateTime     := 0;
  FInpatient    := False;
  FLocationName := '';
  FLocationText := '';
  FProvider     := 0;
  FProviderName := '';
  FStandAlone   := False;
  FVisitCategory := #0;
  SetLocation(0); // Used to call Notifications - do it last so everything else is set
end;

function TEncounter.GetLocationText: string;
{ returns abbreviated hospital location + room/bed (or date/time for appt) }
begin
  if FChanged then UpdateText;
  Result := FLocationText;
end;

function TEncounter.GetLocationName: string;
{ returns external text value for hospital location }
begin
  if FChanged then UpdateText;
  Result := FLocationName;
end;

function TEncounter.GetProviderName: string;
{ returns external text value for provider name }
begin
  if FChanged then UpdateText;
  Result := FProviderName;
end;

function TEncounter.GetVisitCategory: Char;
begin
  Result := FVisitCategory;
  if Result = #0 then Result := 'A';
end;

function TEncounter.GetVisitStr: string;
begin
  Result :=  IntToStr(FLocation) + ';' + FloatToStr(FDateTime) + ';' + VisitCategory;
  // use VisitCategory property to insure non-null character
end;

function TEncounter.GetICDVersion: String;
var
  cd: TFMDateTime;  //compare date
begin
  // if no Enc Dt or Historical, Hospitalization, or Daily Visit compare I-10 Impl dt with TODAY
  if (FDateTime <= 0) or (FVisitCategory = 'E') or (FVisitCategory = 'H') then
    cd := FMNow
  else // otherwise compare I-10 Impl dt with Encounter date/time
    cd := FDateTime;

  if (FICD10ImplDate > cd) then
    Result := 'ICD^ICD-9-CM'
  else
    Result := '10D^ICD-10-CM';
end;

function TEncounter.GetICDVersionCode: String;  //kt added
begin
  Result := piece(GetICDVersion,'^',1);
end;


function TEncounter.NeedVisit: Boolean;
{ returns true if required fields for visit creation are present }
begin
  // added "<" to FDateTime check to trap "-1" visit dates - v23.12 (RV)
  if (FDateTime <= 0) or (FLocation = 0) then Result := True else Result := False;
end;

function TEncounter.NeedVisitWVerification: Boolean;   //TMG added function  8/2/22, used to test encounter date for prior date
  function MessageDlg(const AOwner: TForm; const Msg: string; DlgType: TMsgDlgType;
                      Buttons: TMsgDlgButtons; HelpCtx: Integer = 0): Integer;
  begin
    with CreateMessageDialog(Msg, DlgType, Buttons) do
      try
         Left := AOwner.Left + (AOwner.Width - Width) div 2;
         //Top := AOwner.Top;
         Top := (AOwner.Height-(Height div 2)) div 2;
         Result := ShowModal;
      finally
         Free;
      end;
    end;
var
  msg: string;
  ADate, AMaxDate: TDateTime;
  datemsg : string;  //TMG 6/6/22
  response : integer;  //TMG 6/6/22
begin
  if (FDateTime <= 0) or (FLocation = 0) then begin
    Result := True;
    Exit;
  end;
  Result := False;
  ADate := FMDateTimeToDateTime(Trunc(FDateTime));
  if uTMGOptions.ReadBool('OldVisitDateAlert',false) then begin
    if Piece(FloatToStr(FDateTime),'.',1)<>FloatToStr(FMToday) then begin
      datemsg := uTMGOptions.ReadString('OldVisitDateMessage','Note: Selected date is in the past. ('+FormatFMDateTime('mm/dd/yy',FDateTime)+')');
      datemsg := datemsg+#13#10+'Use past date?';
      response := messagedlg(frmframe,datemsg,mterror,[mbYes,mbNo],0);
      if response = mrNo then begin
        FDateTime := 0;
        FLocation := 0;
        FLocationText := '';
        frmFrame.DisplayEncounterText;
        Result := True;
      end;
    end;
  end;
end;

procedure TEncounter.SetDateTime(Value: TFMDateTime);
{ sets the date/time for the encounter - causes the visit to be reset }
begin
  if Value <> FDateTime then
  begin
    FDateTime := Value;
    FChanged := True;
  end;
end;

procedure TEncounter.SetInpatient(Value: Boolean);
{ sets the inpatient flag for the encounter - causes the visit to be reset }
begin
  if Value <> FInpatient then
  begin
    FInpatient := Value;
    FChanged := True;
  end;
end;

procedure TEncounter.SetLocation(Value: Integer);
{ sets the location for the encounter - causes the visit to be reset }
begin
  if Value <> FLocation then
  begin
    FLocation := Value;
    FChanged := True;
    FNotifier.Notify(Self);
  end;
end;

procedure TEncounter.SetProvider(Value: Int64);
{ sets the provider for the encounter - causes the visit to be reset }
begin
  if Value <> FProvider then
  begin
    FProvider := Value;
    FChanged := True;
  end;
end;

procedure TEncounter.SetStandAlone(Value: Boolean);
{ StandAlone should be true if this encounter isn't related to an appointment }
begin
  if Value <> FStandAlone then
  begin
    FStandAlone := Value;
    FChanged := True;
  end;
end;

procedure TEncounter.SetVisitCategory(Value: Char);
{ sets the visit type for this encounter - causes to visit to be reset }
begin
  if Value <> FVisitCategory then
  begin
    FVisitCategory := Value;
    FChanged := True;
  end;
end;

procedure TEncounter.UpdateText;
{ retrieve external values for provider name, hospital location }
var
  EncounterText: TEncounterText;
begin
  { this references the Patient object which is assumed to be created }
  EncounterText := GetEncounterText(Patient.DFN, FLocation, FProvider);
  with EncounterText do
  begin
    FLocationName := LocationName;
    if Length(LocationAbbr) > 0
      then FLocationText := LocationAbbr
      else FLocationText := LocationName;
    if Length(LocationName) > 0 then
    begin
      if (FVisitCategory = 'H') //FInpatient
        then FLocationText := FLocationText + ' ' + RoomBed
        else FLocationText := FLocationText + ' ' +
          FormatFMDateTime('mmm dd,yy hh:nn', FDateTime);
    end
    else FLocationText := '';
    if Length(ProviderName) > 0  // ProviderName is the field in EncounterText
      then FProviderName := ProviderName
      else FProviderName := '';
  end;
  FChanged := False;
end;

{ TChangeItem ------------------------------------------------------------------------------ }

constructor TChangeItem.Create(AnItemType: Integer; const AnID, AText, AGroupName: string;
  ASignState: Integer; AParentID: string; user: int64; OrderDG: string; DCOrder, Delay: Boolean);
begin
  FItemType  := AnItemType;
  FID        := AnID;
  FText      := AText;
  FGroupName := AGroupName;
  FSignState := ASignState;
  FParentID  := AParentID;
  FUser      := User;
  FOrderDG   := OrderDG;
  FDCOrder   := DCOrder;
  FDelay     := Delay;
end;

function TChangeItem.CSValue(): boolean;
var
  ret: string;
begin
  ret := sCallV('ORDEA CSVALUE', [FID]);
  if ret = '1' then Result :=  True
  else Result := False;
end;

{ TChanges --------------------------------------------------------------------------------- }

constructor TChanges.Create;
begin
  FDocuments          := TList.Create;
  FOrders             := TList.Create;
  FPCE                := TList.Create;
  FOrderGrp           := TStringList.Create;
  FPCEGrp             := TStringList.Create;
  FCount              := 0;
  FRefreshCoverPL     := False;
  FRefreshProblemList := False;
end;

destructor TChanges.Destroy;
begin
  Clear;
  FDocuments.Free;
  FOrders.Free;
  FPCE.Free;
  FOrderGrp.Free;
  FPCEGrp.Free;
  inherited Destroy;
end;

procedure TChanges.Add(ItemType: Integer;
                       const AnID, ItemText, GroupName: string;
                       SignState: Integer; AParentID: string;
                       User: int64;
                       OrderDG: String;
                       DCOrder, Delay, ProblemAdded: Boolean);
var
  i: Integer;
  Found: Boolean;
  ChangeList: TList;
  NewChangeItem: TChangeItem;
begin
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;  {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  FRefreshCoverPL := ProblemAdded;
  FRefreshProblemList := ProblemAdded;
  Found := False;
  if ChangeList <> nil then with ChangeList do for i := 0 to Count - 1 do begin
    with TChangeItem(Items[i]) do if ID = AnID then begin
      Found := True;
      // can't change ItemType, ID, or GroupName, must call Remove first
      FText := ItemText;
      FSignState := SignState;
    end;
  end;
  if not Found then begin
    NewChangeItem := TChangeItem.Create(ItemType, AnID, ItemText, GroupName, SignState, AParentID, User, OrderDG, DCOrder, Delay);
    case ItemType of
      CH_DOC: begin
                FDocuments.Add(NewChangeItem);
              end;
      CH_SUM: begin     {*REV*}
                FDocuments.Add(NewChangeItem);
              end;
      CH_CON: begin
                FDocuments.Add(NewChangeItem);
              end;
      CH_SUR: begin
                FDocuments.Add(NewChangeItem);
              end;
      CH_ORD: begin
                FOrders.Add(NewChangeItem);
                with FOrderGrp do if IndexOf(GroupName) < 0 then Add(GroupName);
              end;
      CH_PCE: begin
                FPCE.Add(NewChangeItem);
                with FPCEGrp do if IndexOf(GroupName) < 0 then Add(GroupName);
              end;
    end;
    Inc(FCount);
  end;
end;

function TChanges.CanSign: Boolean;
{ returns true if any items in the changes list can be signed by the user }
var
  i: Integer;
begin
  Result := False;
  with FDocuments do for i := 0 to Count - 1 do begin
    with TChangeItem(Items[i]) do begin
      //kt added, then removed --> if (TChangeItem(Items[i]).FID = frmNotes.EditingIEN) and (frmNotes.AllowSignature(true) = false) then continue;
      if FSignState <> CH_SIGN_NA then begin
        Result := True;
        Exit;
      end;
    end;
  end;
  with FOrders do for i := 0 to Count - 1 do
    with TChangeItem(Items[i]) do if FSignState <> CH_SIGN_NA then
    begin
      Result := True;
      Exit;
    end;
  // don't have to worry about FPCE - it never requires signatures
end;

procedure TChanges.Clear;
var
  i, ConsultIEN: Integer;
  DocIEN: Int64;
  OrderID: string;
begin
  with FDocuments do for i := 0 to Count - 1 do
    begin
      DocIEN := StrToInt64Def(TChangeItem(Items[i]).ID, 0);
      UnlockDocument(DocIEN);
      ConsultIEN := GetConsultIENforNote(DocIEN);
      if ConsultIEN > -1 then
        begin
          OrderID := GetConsultOrderIEN(ConsultIEN);
          UnlockOrderIfAble(OrderID);
        end;
      TChangeItem(Items[i]).Free;
    end;
  with FOrders do for i := 0 to Count - 1 do TChangeItem(Items[i]).Free;
  with FPCE do for i := 0 to Count - 1 do TChangeItem(Items[i]).Free;
  FDocuments.Clear;
  FOrders.Clear;
  FPCE.Clear;
  FOrderGrp.Clear;
  FPCEGrp.Clear;
  FCount := 0;
end;

function TChanges.Exist(ItemType: Integer; const AnID: string): Boolean;
var
  ChangeList: TList;
  i: Integer;
begin
  Result := False;
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;   {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = AnID then
    begin
      Result := True;
      Break;
    end;
end;

function TChanges.ExistForOrder(const AnID: string): Boolean;
{ returns TRUE if any item in the list of orders has matching order number (ignores action) }
var
  i: Integer;
begin
  Result := False;
  if FOrders <> nil then with FOrders do
    for i := 0 to Count - 1 do
      if Piece(TChangeItem(Items[i]).ID, ';', 1) = Piece(AnID, ';', 1) then
      begin
        Result := True;
        Break;
      end;
end;

function TChanges.Locate(ItemType: Integer; const AnID: string): TChangeItem;
var
  ChangeList: TList;
  i: Integer;
begin
  Result := nil;
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;   {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = AnID then
    begin
      Result := TChangeItem(Items[i]);
      Break;
    end;
end;

procedure TChanges.Remove(ItemType: Integer; const AnID: string);
{ remove a change item from the appropriate list of changes (depending on type)
  this doesn't check groupnames, may leave a groupname without any associated items }
var
  ChangeList: TList;
  i,j: Integer;
  needRemove: boolean;
begin
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := Count - 1 downto 0 do if TChangeItem(Items[i]).ID = AnID then
    begin
      if Assigned(FOnRemove) then FOnRemove(Self, TChangeItem(Items[i]))    {**RV**}
        else TChangeItem(Items[i]).Free;                                    {**RV**}
      //TChangeItem(Items[i]).Free;                                         {**RV**}
      // set TChangeItem(Items[i]) = nil?
      Delete(i);
      Dec(FCount);
    end;
  if ItemType = CH_ORD then
  begin
    for i := OrderGrp.Count - 1 downto 0 do
    begin
      needRemove := True;
      for j := 0 to FOrders.Count - 1 do
        if (AnsiCompareText(TChangeItem(FOrders[j]).GroupName,OrderGrp[i]) = 0 ) then
          needRemove := False;
      if needRemove then
        OrderGrp.Delete(i);
    end;
  end;
  if ItemType = CH_ORD then UnlockOrder(AnID);
  if ItemType = CH_DOC then UnlockDocument(StrToIntDef(AnID, 0));
  if ItemType = CH_CON then UnlockDocument(StrToIntDef(AnID, 0));
  if ItemType = CH_SUM then UnlockDocument(StrToIntDef(AnID, 0));
  if ItemType = CH_SUR then UnlockDocument(StrToIntDef(AnID, 0));
end;

procedure TChanges.ReplaceID(ItemType: Integer; const OldID, NewID: string);
var
  ChangeList: TList;
  i: Integer;
begin
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;   {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = OldID then
    begin
      TChangeItem(Items[i]).FID := NewID;
    end;
end;

procedure TChanges.ReplaceSignState(ItemType: Integer; const AnID: string; NewState: Integer);
var
  ChangeList: TList;
  i: Integer;
begin
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;   {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = AnID then
    begin
      TChangeItem(Items[i]).FSignState := NewState;
    end;
end;

procedure TChanges.ReplaceText(ItemType: Integer; const AnID, NewText: string);
var
  ChangeList: TList;
  i: Integer;
begin
  ChangeList := nil;
  case ItemType of
  CH_DOC: ChangeList := FDocuments;
  CH_SUM: ChangeList := FDocuments;   {*REV*}
  CH_CON: ChangeList := FDocuments;
  CH_SUR: ChangeList := FDocuments;
  CH_ORD: ChangeList := FOrders;
  CH_PCE: ChangeList := FPCE;
  end;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = AnID then
    begin
      TChangeItem(Items[i]).FText := NewText;
    end;
end;

function TChanges.RequireReview: Boolean;
{ returns true if documents can be signed or if any orders exist in Changes }
var
  i: Integer;
begin
  Result := False;
  AddUnsignedToChanges;
  if FOrders.Count > 0 then Result := True;
  if Result = False then with FDocuments do for i := 0 to Count - 1 do
    with TChangeItem(Items[i]) do if FSignState <> CH_SIGN_NA then
    begin
      Result := True;
      Break;
    end;
end;

procedure TChanges.AddUnsignedToChanges;
{ retrieves unsigned orders outside this session based on OR UNSIGNED ORDERS ON EXIT }
var
  i, CanSign(*, OrderUser*): Integer;
  OrderUser: int64;
  AnID, Display: string;
  HaveOrders, OtherOrders: TStringList;
  AChangeItem: TChangeItem;
  IsDiscontinue, IsDelay: boolean;
begin
  if Patient.DFN = '' then Exit;
  // exit if there is already an 'Other Unsigned' group?
  HaveOrders  := TStringList.Create;
  OtherOrders := TStringList.Create;
  try
    StatusText('Looking for unsigned orders...');
    for i := 0 to Pred(FOrders.Count) do
    begin
      AChangeItem := FOrders[i];
      HaveOrders.Add(AChangeItem.ID);
    end;
    LoadUnsignedOrders(OtherOrders, HaveOrders);
    if (Encounter.Provider = User.DUZ) and User.CanSignOrders
      then CanSign := CH_SIGN_YES
      else CanSign := CH_SIGN_NA;
    for i := 0 to Pred(OtherOrders.Count) do
    begin
      AnID := Piece(OtherOrders[i],U,1);
      if Piece(OtherOrders[i],U,2) = '' then OrderUser := 0
      else OrderUser := StrtoInt64(Piece(OtherOrders[i],U,2));
      //agp change the M code to pass back the value for the new order properties
      Display := Piece(OtherOrders[i],U,3);
      if Piece(OtherOrders[i],U,4) = '1' then  IsDiscontinue := True
      else IsDiscontinue := False;
      if Piece(OtherOrders[i],U,5) = '1' then  IsDelay := True
      else IsDelay := False;
      Add(CH_ORD, AnID, TextForOrder(AnID), 'Other Unsigned', CanSign,'', OrderUser, Display, IsDiscontinue, IsDelay);
    end;
  finally
    StatusText('');
    HaveOrders.Free;
    OtherOrders.Free;
  end;
end;

{ TNotifications ---------------------------------------------------------------------------- }

constructor TNotifications.Create;
begin
  FList := TList.Create;
  FCurrentIndex := -1;
  FActive := False;
  FNotifIndOrders := False;
end;

destructor TNotifications.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TNotifications.Add(const ADFN: string; AFollowUp: Integer; const ARecordID: string; AHighLightSection : string = '');  //*DFN*
var
  NotifyItem: TNotifyItem;
begin
  NotifyItem := TNotifyItem.Create;
  NotifyItem.DFN := ADFN;
  NotifyItem.FollowUp := AFollowUp;
  NotifyItem.RecordID := ARecordId;
  If AHighLightSection <> '' then NotifyItem.HighLightSection := AHighLightSection;
  FList.Add(NotifyItem);
  FActive := True;
end;

procedure TNotifications.Clear;
var
  i: Integer;
begin
  with FList do for i := 0 to Count - 1 do with TNotifyItem(Items[i]) do Free;
  FList.Clear;
  FActive := False;
  FCurrentIndex := -1;
  FNotifyItem := nil;
  FNotifIndOrders := False;
end;

function TNotifications.GetDFN: string;  //*DFN*
begin
  if FNotifyItem <> nil then Result := FNotifyItem.DFN else Result := '';  //*DFN*
end;

function TNotifications.GetFollowUp: Integer;
begin
  if FNotifyItem <> nil then Result := FNotifyItem.FollowUp else Result := 0;
end;

function TNotifications.GetAlertData: string;
begin
  if FNotifyItem <> nil
    then Result := GetXQAData(Piece(FNotifyItem.RecordID, U, 2))
    else Result := '';
end;

function TNotifications.GetRecordID: string;
begin
  if FNotifyItem <> nil then Result := FNotifyItem.RecordID else Result := '';
end;

function TNotifications.GetText: string;
begin
  if FNotifyItem <> nil
    then Result := Piece(Piece(FNotifyItem.RecordID, U, 1 ), ':', 2)
    else Result := '';
end;

function TNotifications.GetHighLightSection: String; //CB
begin
  if FNotifyItem <> nil then Result := FNotifyItem.HighLightSection else Result := '';
end;

function TNotifications.GetIndOrderDisplay: Boolean;
begin
  Result := FNotifIndOrders;
end;

procedure TNotifications.SetIndOrderDisplay(Value: Boolean);
begin
  FNotifIndOrders := Value;
end;

procedure TNotifications.Next;
begin
  Inc(FCurrentIndex);
  if FCurrentIndex < FList.Count then FNotifyItem := TNotifyItem(FList[FCurrentIndex]) else
  begin
    FActive := False;
    FNotifyItem := nil;
  end;
end;

procedure TNotifications.Prior;
begin
  Dec(FCurrentIndex);
  if FCurrentIndex < 0
    then FNotifyItem := nil
    else FNotifyItem := TNotifyItem(FList[FCurrentIndex]);
  if FList.Count > 0 then FActive := True;
end;

procedure TNotifications.Delete;
begin
  if FNotifyItem <> nil then DeleteAlert(Piece(FNotifyItem.RecordID, U, 2));
end;

procedure TNotifications.DeleteForCurrentUser;
begin
  if FNotifyItem <> nil then DeleteAlertForUser(Piece(FNotifyItem.RecordID, U, 2));
end;

{ TRemoteSite methods ---------------------------------------------------------------------------- }

constructor TRemoteSite.Create(ASite: string);
begin
  FSiteID   := Piece(ASite, U, 1);
  FSiteName := MixedCase(Piece(ASite, U, 2));
  FLastDate := StrToFMDateTime(Piece(ASite, U, 3));
  FSelected := False;
  FQueryStatus := '';
  FData := TStringList.Create;
  FLabQueryStatus := '';
  FLabData := TStringList.Create;
  FCurrentLabQuery := '';
  FCurrentReportQuery := '';
end;

destructor TRemoteSite.Destroy;
begin
  LabClear;
  ReportClear;
  FData.Free;
  FLabData.Free;
  inherited Destroy;
end;

procedure TRemoteSite.ReportClear;
begin
  FData.Clear;
  FQueryStatus := '';
end;

procedure TRemoteSite.LabClear;
begin
  FLabData.Clear;
  FLabQueryStatus := '';
end;

procedure TRemoteSite.SetSelected(Value: boolean);
begin
  FSelected := Value;
end;

constructor TRemoteReport.Create(AReport: string);
begin
  FReport   := AReport;
  FHandle := '';
end;

destructor TRemoteReport.Destroy;
begin
  inherited Destroy;
end;

constructor TRemoteReportList.Create;
begin
  FReportList := TList.Create;
  FCount := 0;
end;

destructor TRemoteReportList.Destroy;
begin
  //Clear;
  FReportList.Free;
  inherited Destroy;
end;

procedure TRemoteReportList.Add(AReportList, AHandle: string);
var
  ARemoteReport: TRemoteReport;
begin
  ARemoteReport := TRemoteReport.Create(AReportList);
  ARemoteReport.Handle := AHandle;
  ARemoteReport.Report := AReportList;
  FReportList.Add(ARemoteReport);
  FCount := FReportList.Count;
end;

procedure TRemoteReportList.Clear;
var
  i: Integer;
begin
  with FReportList do
    for i := 0 to Count - 1 do
      with TRemoteReport(Items[i]) do Free;
  FReportList.Clear;
  FCount := 0;
end;

constructor TRemoteSiteList.Create;
begin
  FSiteList := TList.Create;
  FCount := 0;
end;

destructor TRemoteSiteList.Destroy;
begin
  Clear;
  FSiteList.Free;
  inherited Destroy;
end;

procedure TRemoteSiteList.Add(ASite: string);
var
  ARemoteSite: TRemoteSite;
begin
  ARemoteSite := TRemoteSite.Create(ASite);
  FSiteList.Add(ARemoteSite);
  FCount := FSiteList.Count;
end;

procedure TRemoteSiteList.Clear;
var
  i: Integer;
begin
  with FSiteList do for i := 0 to Count - 1 do with TRemoteSite(Items[i]) do Free;
  FSiteList.Clear;
  FCount := 0;
end;

procedure TRemoteSiteList.ChangePatient(const DFN: string);
var
  ALocations: TStringList;
  i: integer;
begin
  Clear;
  ALocations := TStringList.Create;
  try
    FRemoteDataExists := HasRemoteData(DFN, ALocations);
    if FRemoteDataExists then
      begin
        SortByPiece(ALocations, '^', 2);
        for i := 0 to ALocations.Count - 1 do
          if piece(ALocations[i],'^',5) = '1' then
            Add(ALocations.Strings[i]);
        FNoDataReason := '';
      end
    else
      FNoDataReason := Piece(ALocations[0], U, 2);
    FCount := FSiteList.Count;
  finally
    ALocations.Free;
  end;
end;

procedure GotoWebPage(const URL: WideString);
begin
  if(URLMonHandle <> 0) then
    HlinkNav(nil, PWideChar(URL));
end;

function subtractMinutesFromDateTime(Time1 : TDateTime;Minutes : extended) : TDateTime;
var
  TimeMinutes : TDateTime;
const
  MinutesPerDay = 60 * 24;
begin
  TimeMinutes := Minutes / MinutesPerDay;
  result := time1 - TimeMinutes;
end;

procedure LoadURLMon;
const
  UrlMonLib = 'URLMON.DLL';
  HlinkName = 'HlinkNavigateString';

begin
  URLMonHandle := LoadLibrary(PChar(UrlMonLib));
  if URLMonHandle <= HINSTANCE_ERROR then
    URLMonHandle := 0
  else
  begin
    HlinkNav := GetProcAddress(URLMonHandle, HlinkName);
    if(not assigned(HlinkNav)) then
    begin
      FreeLibrary(URLMonHandle);
      URLMonHandle := 0;
    end;
  end;
end;

procedure ReleaseURLMon;
begin
  if(URLMonHandle <> 0) then
  begin
    FreeLibrary(URLMonHandle);
    URLMonHandle := 0;
  end;
end;

procedure TChanges.ReplaceODGrpName(const AnODID, NewGrp: string);
var
  ChangeList: TList;
  i: Integer;
begin
  ChangeList := FOrders;
  if ChangeList <> nil then with ChangeList do
    for i := 0 to Count - 1 do if TChangeItem(Items[i]).ID = AnODID then
      TChangeItem(Items[i]).FGroupName := NewGrp;
end;

procedure TChanges.ChangeOrderGrp(const oldGrpName,newGrpName: string);
var
  i : integer;
begin
  for i := 0 to FOrderGrp.Count - 1 do
  begin
    if AnsiCompareText(FOrderGrp[i],oldGrpName)= 0 then
      FOrderGrp[i] := newGrpName;
  end;
end;

initialization
  uVistaMsg := 0;
  LoadURLMon;

finalization
  ReleaseURLMon;
  ReleaseAppNotification;

end.
