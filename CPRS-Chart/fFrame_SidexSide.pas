unit fFrame;
{ This is the main form for the CPRS GUI.  It provides a patient-encounter-user framework
  which all the other forms of the GUI use. }

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



{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED
{$WARN SYMBOL_PLATFORM OFF}
{$DEFINE CCOWBROKER}

{.$define debug}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Tabs, ComCtrls,
  ExtCtrls, Menus, StdCtrls, Buttons, ORFn, fPage, uConst, ORCtrls, Trpcb,
  OleCtrls, VERGENCECONTEXTORLib_TLB, ComObj, AppEvnts, fBase508Form,
  StrUtils, Variants, Types,   //eRx 9/4/12
  rTIU, math,  //TMG
  uTMGEvent,   //TMG  10/29/20
  fImagePatientPhotoID, fTMGChartExporter, //kt
  VA508AccessibilityManager, RichEdit, rWVEHR, XUDsigS, ImgList;

type
  TControlCracker = class(TControl);  //kt-tabs 7/23/21
  TTabPageSide = (tpsLeft, tpsRight);  //kt-tabs 7/23/21
  TTabPageOpenMode = (tpoOpen=0, tpoClosed=1);  //kt-tabs 7/25/21
  TfrmFrame = class(TfrmBase508Form)
    mnuFrame: TMainMenu;
    mnuFile: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuFileReview: TMenuItem;
    Z1: TMenuItem;
    mnuFilePrint: TMenuItem;
    mnuEdit: TMenuItem;
    mnuEditUndo: TMenuItem;
    Z3: TMenuItem;
    mnuEditCut: TMenuItem;
    mnuEditCopy: TMenuItem;
    mnuEditPaste: TMenuItem;
    Z4: TMenuItem;
    mnuEditPref: TMenuItem;
    Prefs1: TMenuItem;
    mnu18pt1: TMenuItem;
    mnu14pt1: TMenuItem;
    mnu12pt1: TMenuItem;
    mnu10pt1: TMenuItem;
    mnu8pt: TMenuItem;
    mnuHelp: TMenuItem;
    mnuHelpContents: TMenuItem;
    mnuHelpTutor: TMenuItem;
    Z5: TMenuItem;
    mnuHelpAbout: TMenuItem;
    mnuTools: TMenuItem;
    mnuView: TMenuItem;
    mnuViewChart: TMenuItem;
    mnuChartReports: TMenuItem;
    mnuChartLabs: TMenuItem;
    mnuChartDCSumm: TMenuItem;
    mnuChartCslts: TMenuItem;
    mnuChartNotes: TMenuItem;
    mnuChartOrders: TMenuItem;
    mnuChartMeds: TMenuItem;
    mnuChartProbs: TMenuItem;
    mnuChartCover: TMenuItem;
    mnuHelpBroker: TMenuItem;
    mnuFileEncounter: TMenuItem;
    mnuViewDemo: TMenuItem;
    mnuViewPostings: TMenuItem;
    mnuHelpLists: TMenuItem;
    Z6: TMenuItem;
    mnuHelpSymbols: TMenuItem;
    mnuFileNext: TMenuItem;
    Z7: TMenuItem;
    mnuFileRefresh: TMenuItem;
    mnuViewReminders: TMenuItem;
    popCIRN: TPopupMenu;
    popCIRNSelectAll: TMenuItem;
    popCIRNSelectNone: TMenuItem;
    popCIRNClose: TMenuItem;
    mnuFilePrintSetup: TMenuItem;
    LabInfo1: TMenuItem;
    mnuFileNotifRemove: TMenuItem;
    Z8: TMenuItem;
    mnuToolsOptions: TMenuItem;
    mnuChartSurgery: TMenuItem;
    OROpenDlg: TOpenDialog;
    mnuFileResumeContext: TMenuItem;
    mnuFileResumeContextSet: TMenuItem;
    Useexistingcontext1: TMenuItem;
    mnuFileBreakContext: TMenuItem;
    mnuFilePrintSelectedItems: TMenuItem;
    popAlerts: TPopupMenu;
    mnuAlertContinue: TMenuItem;
    mnuAlertForward: TMenuItem;
    mnuAlertRenew: TMenuItem;
    AppEvents: TApplicationEvents;
    mnuToolsGraphing: TMenuItem;
    mnuViewInformation: TMenuItem;
    mnuViewVisits: TMenuItem;
    mnuViewPrimaryCare: TMenuItem;
    mnuViewMyHealtheVet: TMenuItem;
    mnuInsurance: TMenuItem;
    mnuViewFlags: TMenuItem;
    mnuViewRemoteData: TMenuItem;
    compAccessTabPage: TVA508ComponentAccessibility;
    mnuEditDemographics: TMenuItem;
    mnuPrintLabels: TMenuItem;
    mnuPrintAdmissionLabel: TMenuItem;
    ViewAuditTrail1: TMenuItem;
    N1: TMenuItem;    //eRx  9/4/12
    mnuEditRedo: TMenuItem;
    EPrescribing1: TMenuItem;
    N2: TMenuItem;
    mnuBillableItems: TMenuItem;
    timerStopwatch: TTimer;
    popTimerMenu: TPopupMenu;
    mnuResetCounter: TMenuItem;
    mnuInsertTime: TMenuItem;
    mnuTeams: TMenuItem;
    N3: TMenuItem;
    mnuADT: TMenuItem;
    DigitalSigningSetup1: TMenuItem;
    mnuChangeES: TMenuItem;
    mnuTMGTemp: TMenuItem;
    mnuLabText: TMenuItem;
    timSchedule: TTimer;
    mnuAnticoagulationTool: TMenuItem;
    timCheckSequel: TTimer;
    mnuUploadImages: TMenuItem;
    mnuExportChart: TMenuItem;
    mnuClosePatient: TMenuItem;
    ImageListSplitterHandle: TImageList;  //kt-tabs
    timHideSplitterHandle: TTimer;
    pnlNoPatientSelected: TPanel;
    pnlPatientSelected: TPanel;
    bvlPageTop: TBevel;
    stsArea: TStatusBar;
    pnlMain: TPanel;
    frameLRSplitter: TSplitter;
    pnlMainL: TPanel;
    pnlPageL: TPanel;
    sbtnFontSmaller: TSpeedButton;
    sbtnFontNormal: TSpeedButton;
    sbtnFontLarger: TSpeedButton;
    lstCIRNLocations: TORListBox;
    tabPageL: TTabControl;
    pnlMainR: TPanel;
    pnlPageR: TPanel;
    tabPageR: TTabControl;
    btnSplitterHandle: TBitBtn;
    pnlToolbar: TPanel;
    bvlToolTop: TBevel;
    pnlCCOW: TPanel;
    imgCCOW: TImage;
    pnlPatient: TKeyClickPanel;
    lblPtName: TStaticText;
    lblPtSSN: TStaticText;
    lblPtAge: TStaticText;
    pnlVisit: TKeyClickPanel;
    lblPtLocation: TStaticText;
    lblPtProvider: TStaticText;
    pnlPrimaryCare: TKeyClickPanel;
    lblPtCare: TStaticText;
    lblPtAttending: TStaticText;
    lblPtMHTC: TStaticText;
    pnlReminders: TKeyClickPanel;
    imgReminder: TImage;
    anmtRemSearch: TAnimate;
    pnlPostings: TKeyClickPanel;
    lblPtPostings: TStaticText;
    lblPtCWAD: TStaticText;
    paVAA: TKeyClickPanel;
    laVAA2: TButton;
    laMHV: TButton;
    pnlRemoteData: TKeyClickPanel;
    pnlVistaWeb: TKeyClickPanel;
    lblVistaWeb: TLabel;
    pnlCIRN: TKeyClickPanel;
    lblCIRN: TLabel;
    lblLoadSequelPat: TLabel;
    pnlCVnFlag: TPanel;
    btnCombatVet: TButton;
    pnlFlag: TKeyClickPanel;
    lblFlag: TLabel;
    pnlPatientImage: TPanel;
    PatientImage: TImage;
    pnlTimer: TPanel;
    btnTimerReset: TButton;
    pnlSchedule: TKeyClickPanel;  //kt-tab
    procedure btnSplitterHandleMouseLeave(Sender: TObject);
    procedure btnSplitterHandleMouseEnter(Sender: TObject);
    procedure timHideSplitterHandleTimer(Sender: TObject);
    procedure btnSplitterHandleClick(Sender: TObject);
    procedure frameLRSplitterMoved(Sender: TObject);
    procedure tabPageRMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tabPageLMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tabPageRChange(Sender: TObject);
    procedure tabPageLChange(Sender: TObject);
    procedure sbtnFontChangeClick(Sender: TObject);
    procedure mnuClosePatientClick(Sender: TObject);
    procedure mnuExportChartClick(Sender: TObject);
    procedure mnuInsertTimeClick(Sender: TObject);
    procedure mnuViewInsurancesClick(Sender: TObject);
    procedure mnuUploadImagesClick(Sender: TObject);
    procedure PatientImageMouseLeave(Sender: TObject);
    procedure PatientImageMouseEnter(Sender: TObject);
    procedure lblLoadSequelPatClick(Sender: TObject);
    procedure timCheckSequelTimer(Sender: TObject);
    procedure mnuAnticoagulationToolClick(Sender: TObject);
    procedure pnlScheduleClick(Sender: TObject);
    procedure timScheduleTimer(Sender: TObject);
    procedure mnuLabTextClick(Sender: TObject);
    procedure mnuTMGTempClick(Sender: TObject);
    procedure mnuChangeESClick(Sender: TObject);
    procedure mnuFrameChange(Sender: TObject; Source: TMenuItem; Rebuild: Boolean);
    procedure mnuTeamsClick(Sender: TObject);
    procedure pnlTimerMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure timerStopwatchTimer(Sender: TObject);
    procedure btnTimerClick(Sender: TObject);
    procedure btnTimerResetClick(Sender: TObject);
    procedure mnuBillableItemsClick(Sender: TObject);
    procedure mnuOpenADTClick(Sender: TObject);
    procedure PatientImageClick(Sender: TObject);       //kt added 4/14/14
    procedure ViewAuditTrail1Click(Sender: TObject);  //kt 9/11
    procedure EPrescribing1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pnlPatientMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlPatientMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlVisitMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlVisitMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure mnuFileExitClick(Sender: TObject);
    procedure pnlPostingsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlPostingsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure mnuFontSizeClick(Sender: TObject);
    procedure mnuChartTabClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuFileOpenClick(Sender: TObject);
    procedure mnuHelpBrokerClick(Sender: TObject);
    procedure mnuFileEncounterClick(Sender: TObject);
    procedure mnuViewPostingsClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
    procedure mnuFileReviewClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuHelpListsClick(Sender: TObject);
    procedure ToolClick(Sender: TObject);
    procedure mnuEditClick(Sender: TObject);
    procedure mnuEditUndoClick(Sender: TObject);
    procedure mnuEditCutClick(Sender: TObject);
    procedure mnuEditCopyClick(Sender: TObject);
    procedure mnuEditPasteClick(Sender: TObject);
    procedure mnuHelpSymbolsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuFilePrintClick(Sender: TObject);
    procedure mnuGECStatusClick(Sender: TObject);
    procedure mnuFileNextClick(Sender: TObject);
    procedure pnlPrimaryCareMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlPrimaryCareMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlRemindersMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlRemindersMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlCIRNClick(Sender: TObject);
    procedure lstCIRNLocationsClick(Sender: TObject);
    procedure popCIRNCloseClick(Sender: TObject);
    procedure popCIRNSelectAllClick(Sender: TObject);
    procedure popCIRNSelectNoneClick(Sender: TObject);
    procedure mnuFilePrintSetupClick(Sender: TObject);
    procedure lstCIRNLocationsChange(Sender: TObject);
    procedure LabInfo1Click(Sender: TObject);
    procedure mnuFileNotifRemoveClick(Sender: TObject);
    procedure mnuToolsOptionsClick(Sender: TObject);
    procedure mnuFileRefreshClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure pnlPrimaryCareEnter(Sender: TObject);
    procedure pnlPrimaryCareExit(Sender: TObject);
    procedure pnlPatientClick(Sender: TObject);
    procedure pnlVisitClick(Sender: TObject);
    procedure pnlPrimaryCareClick(Sender: TObject);
    procedure pnlRemindersClick(Sender: TObject);
    procedure pnlPostingsClick(Sender: TObject);
    procedure ctxContextorCanceled(Sender: TObject);
    procedure ctxContextorCommitted(Sender: TObject);
    procedure ctxContextorPending(Sender: TObject; const aContextItemCollection: IDispatch);
    procedure mnuFileBreakContextClick(Sender: TObject);
    procedure mnuFileResumeContextGetClick(Sender: TObject);
    procedure mnuFileResumeContextSetClick(Sender: TObject);
    procedure pnlFlagMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlFlagMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlFlagClick(Sender: TObject);
    procedure mnuFilePrintSelectedItemsClick(Sender: TObject);
    procedure mnuAlertRenewClick(Sender: TObject);
    procedure mnuAlertForwardClick(Sender: TObject);
    procedure pnlFlagEnter(Sender: TObject);
    procedure pnlFlagExit(Sender: TObject);
    procedure lstCIRNLocationsExit(Sender: TObject);
    procedure AppEventsActivate(Sender: TObject);
    procedure ScreenActiveFormChange(Sender: TObject);
    procedure AppEventsShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure mnuToolsGraphingClick(Sender: TObject);
    procedure pnlCIRNMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlCIRNMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure laMHVClick(Sender: TObject);
    procedure laVAA2Click(Sender: TObject);
    procedure ViewInfo(Sender: TObject);
    procedure mnuViewInformationClick(Sender: TObject);
    procedure compAccessTabPageCaptionQuery(Sender: TObject; var Text: string);
    procedure btnCombatVetClick(Sender: TObject);
    procedure pnlVistaWebClick(Sender: TObject);
    procedure pnlVistaWebMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlVistaWebMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure mnuEditRedoClick(Sender: TObject);
    procedure mnuEditDemographicsClick(Sender: TObject);                                                           //kt 9/11
    procedure tabPageDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);   //kt 9/11
    procedure mnuPrintLabelsClick(Sender: TObject);                                                                //kt 9/11
    procedure mnuPrintAdmissionLabelClick(Sender: TObject);                                                        //kt 9/11
    procedure DigitalSigningSetup1Click(Sender: TObject);
  private
    //FProccessingNextClick : boolean;    //kt 8/28/12  moved to public for fNotes
    FJustEnteredApp : boolean;
    FCCOWInstalled: boolean;
    FCCOWContextChanging: boolean;
    FCCOWIconName: string;
    FCCOWDrivedChange: boolean;
    FCCOWBusy: boolean;
    FCCOWError: boolean;
    FNoPatientSelected: boolean;
    FRefreshing: boolean;
    FClosing: boolean;
    FContextChanging: Boolean;
    FChangeSource: Integer;
    FCreateProgress: Integer;
    FEditCtrl: TCustomEdit;
    FLastPageL, FLastPageR: TfrmPage;  //kt-tabs
    FNextButtonL: Integer;
    FNextButtonR: Integer;
    FNextButtonActive: Boolean;
    FNextButtonBitmap: TBitmap;
    FNextButton: TBitBtn;
    FTerminate: Boolean;
    FTabChanged: TNotifyEvent;
    FOldActivate: TNotifyEvent;
    FOldActiveFormChange: TNotifyEvent;
    FECSAuthUser: Boolean;
    FFixedStatusWidth: integer;
    FPrevInPatient: Boolean;
    FFirstLoad:    Boolean;
    FFlagList: TStringList;
    FPrevPtID: string;
    FGraphFloatActive: boolean;
    FGraphContext: string;
    FDoNotChangeEncWindow: boolean;
    FOrderPrintForm: boolean;
    FReviewclick: boolean;
    FCtrlTabUsed: boolean;
    FDragAndDropFName : String;            //kt 4/15/14
    bTimerOn : boolean;                    //kt 4/14/15
    colorTimerOn : TColor;                 //kt 4/14/15
    colorTimerOnMax : TColor;              //kt 4/17/15
    intTimerMaxTime : integer;             //kt 4/17/15
    colorTimerPaused : Tcolor;             //kt 4/14/15
    colorTimerOff : TColor;                //kt 4/14/15
    OriginalPanelWindowProc :TWndMethod;   //kt 4/16/14
    frmPatientPhotoID : TfrmPatientPhotoID;  //kt  7/10/18
    TMGInitialFontSize : integer;          //kt 4/28/21
    FTabPage : array[tpsLeft..tpsRight] of TTabControl;  //kt-tabs
    PnlPage : array[tpsLeft..tpsRight] of TPanel;  //kt-tabs
    FNextTabL, FLastTabL, FChangingTabL: Integer;  //kt-tabs
    FNextTabR, FLastTabR, FChangingTabR: Integer;  //kt-tabs
    FTabPageOpenMode : TTabPageOpenMode;  //kt-tabs 7/25/21
    procedure PanelWindowProc(var Msg: TMessage); //kt   4/16/14
    procedure RefreshFixedStatusWidth;
    procedure FocusApplicationTopForm;
    procedure AppActivated(Sender: TObject);
    procedure AppDeActivated(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    function AllowContextChangeAll(var Reason: string):  Boolean;
    procedure NotifyContextChangeCancelledAll;  //kt added
    procedure ClearPatient;
    procedure ChangeFont(NewFontSize: Integer);
    procedure LoadTabColors(ColorsList : TStringList);  //kt 9/11
    procedure SaveTabColors(ColorsList : TStringList);  //kt 9/11
    //procedure CreateTab(var AnInstance: TObject; AClass: TClass; ATabID: integer; ALabel: string);
    procedure CreateTab(ASide: TTabPageSide; ATabID: integer; ALabel: string);  //kt-tabs
    procedure tabPageChange(ASide: TTabPageSide);  //kt-tabs
    procedure DetermineNextTab(ASide: TTabPageSide);
    function  GetLastTab(Index : TTabPageSide) : integer;   //kt-tabs
    procedure SetLastTab(Index : TTabPageSide; value : integer);  //kt-tabs
    function  GetNextTab(Index : TTabPageSide) : integer;   //kt-tabs
    procedure SetNextTab(Index : TTabPageSide; value : integer);  //kt-tabs
    function  GetChangingTab(Index : TTabPageSide) : integer;  //kt-tabs
    procedure SetChangingTab(Index : TTabPageSide; value : integer);  //kt-tabs
    function  GetFLastPage(Index : TTabPageSide) : TFrmPage;  //kt-tabs
    procedure SetFLastPage(Index : TTabPageSide; value : TFrmPage); //kt-tabs
    procedure frameLRSplitterMouseEnter(Sender: TObject);  //kt-tabs
    procedure frameLRSplitterMouseLeave(Sender: TObject);  //kt-tabs
    function  OtherPageSide(ASide : TTabPageSide) : TTabPageSide;
    function ExpandCommand(x: string): string;
    procedure FitToolbar;
    procedure LoadSizesForUser;
    procedure SaveSizesForUser;
    procedure LoadUserPreferences;
    procedure SaveUserPreferences;
    procedure SwitchToPage(ASide: TTabPageSide; NewForm: TfrmPage); //kt-tabs
    function TabIndexToPageID(Tab: Integer): Integer; //kt-tabs renamed.  Was TabtoPageID
    function TimeoutCondition: boolean;
    function GetTimedOut: boolean;
    procedure TimeOutAction;
    procedure SetUserTools;
    procedure SetDebugMenu;
    procedure SetupPatient(AFlaggedList : TStringList = nil);
    //procedure SetUpCIRN;
    procedure RemindersChanged(Sender: TObject);
    procedure ReportsOnlyDisplay;
    procedure UMInitiate(var Message: TMessage);   message UM_INITIATE;
    procedure UMNewOrder(var Message: TMessage);   message UM_NEWORDER;
    procedure UMStatusText(var Message: TMessage); message UM_STATUSTEXT;
    procedure UMShowPage(var Message: TMessage);   message UM_SHOWPAGE;
    procedure WMSetFocus(var Message: TMessage);   message WM_SETFOCUS;
    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND;
    procedure UpdateECSParameter(var CmdParameter: string);
    function  ValidECSUser: boolean;
    procedure StartCCOWContextor;
    function  AllowCCOWContextChange(var CCOWResponse: UserResponse; NewDFN: string): boolean;
    procedure UpdateCCOWContext;
    procedure CheckHyperlinkResponse(aContextItemCollection: IDispatch; var HyperlinkReason: string);
    procedure CheckForDifferentPatient(aContextItemCollection: IDispatch; var PtChanged: boolean);
{$IFDEF CCOWBROKER}
    procedure CheckForDifferentUser(aContextItemCollection: IDispatch; var UserChanged: boolean);
{$ENDIF}
    procedure HideEverything(AMessage: string = 'No patient is currently selected.');
    procedure ShowEverything;
    //function FindBestCCOWDFN(var APatientName: string): string;
    function FindBestCCOWDFN: string;
    procedure HandleCCOWError(AMessage: string);
    procedure SetUpNextButton;
    procedure SetUpResizeButtons;  //kt 4/28/21
    procedure NextButtonClick(Sender: TObject);
    procedure NextButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShowLetterWriterClick(Sender: TObject);                                                                     //kt 9/11 added
    procedure DrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Color : TColor; Active: Boolean); //kt 9/11 added
    procedure InsertFormLetterPrintingMenuItem(MenuFile : TMenuItem);                                                     //kt 9/11 added
    procedure CallERx(action: Integer);   //ERx 9/4/12
    procedure OpenChartByDFN(NewDFN:string);  //TMG 6/11/18
    procedure WMCopyData(var Msg : TWMCopyData) ; message WM_COPYDATA;  //TMG added 7/9/18
    procedure SetTabOpenMode(Mode: TTabPageOpenMode; NoResize : boolean = false); //kt-tabs 7/25/21
    procedure PositionSplitterHandle;  //kt-tabs  7/25/21
    function ToggleTabPageOpenMode(Mode: TTabPageOpenMode) : TTabpageOpenMode; //kt-tabs  7/25/21
    procedure ResizeTabs(AutoResizeTabs : boolean = false); //kt-tabs 7/25/21
    property  NextTab[Index : TTabPageSide] : integer read GetNextTab write SetNextTab;   //kt-tabs
    property  LastTab[Index : TTabPageSide] : integer read GetLastTab write SetLastTab;  //kt-tabs
    property  FLastPage[Index : TTabPageSide] : TFrmPage read GetFLastPage write SetFLastPage;  //kt-tabs
  public
    FProccessingNextClick : boolean;    //kt    8/28/12
    EnduringPtSelSplitterPos, frmFrameHeight, pnlPatientSelectedHeight: integer;
    TMGAbort : boolean;  //kt 9/11 added
    WebServerIP : string;  //kt 4/7/15
    WebServerPort: string; //kt 4/7/15
    EnduringPtSelColumns: string;
    NoteTitleDateFormat: string;           //tmg 7//25/19
    TurnOnUploads:boolean;                 //tmg  8/27/19
    TabCtrlClicked: Boolean;               //kt-tabs  7/25/21  used in fProbs
    TabCtrlClickedSide : TTabPageSide;     //kt-tabs 7/23/21 -- When TabCtrlClicked = true, then this will show which side.
    ProbTabClicked: boolean;               //kt-tabs 7/25/21
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;  //kt 4/15/14
    procedure SetBADxList;
    procedure SetActiveTab(PageID: Integer);
    function  GetActiveTab: integer;  //kt added 6/15
    function CheckForRPC(RPCName: string): boolean;  //kt 9/11
    procedure SelectChartTabL(PageID : integer); //kt 12/10/20  //kt-tabs
    procedure SelectChartTabR(PageID : integer); //kt 12/10/20  //kt-tabs
    procedure SelectChartTab(ASide : TTabPageSide; PageID : integer);  overload; //kt-tabs
    procedure SelectChartTab(PageID : integer);  overload;//kt-tabs
    function  TabPage(ASide : TTabPageSide = tpsLeft) : TTabControl;  //kt-tabs 6/10/21
    function PageIDToTab(PageID: Integer): Integer;
    procedure ShowHideChartTabMenus(AMenuItem: TMenuItem);
    procedure UpdatePtInfoOnRefresh;
    function  TabExists(ATabID: integer): boolean;
    procedure DisplayEncounterText;
    function DLLActive: boolean;
    property ChangeSource:    Integer read FChangeSource;
    property CCOWContextChanging: Boolean read FCCOWContextChanging;
    property CCOWDrivedChange: Boolean  read FCCOWDrivedChange;
    property CCOWBusy: Boolean    read FCCOWBusy  write FCCOWBusy;
    property ContextChanging: Boolean read FContextChanging;
    property TimedOut:        Boolean read GetTimedOut;
    property Closing:         Boolean read FClosing;
    property OnTabChanged:    TNotifyEvent read FTabChanged write FTabChanged;
    property GraphFloatActive: boolean read FGraphFloatActive write FGraphFloatActive;
    property GraphContext: string read FGraphContext write FGraphContext;
    procedure ToggleMenuItemChecked(Sender: TObject);
    procedure SetUpCIRN;
    property DoNotChangeEncWindow: boolean read FDoNotChangeEncWindow write FDoNotChangeEncWindow;
    property OrderPrintForm: boolean read FOrderPrintForm write FOrderPrintForm;
    procedure SetATabVisibility(ATabID: integer; Visible: boolean; ALabel:string='x'); //kt 9/11
    procedure SetWebTabsPerServer;                                                      //kt 9/11 added
    procedure SetOneWebTabPerServer(WebTabNum: integer; URLMsg : string);               //kt 9/11 added
    property ActiveTab : integer read GetActiveTab write SetActiveTab;                  //kt added 6/15
    property NoPatientSelected : boolean read FNoPatientSelected;                       //kt added 11/16/20
    property  ChangingTab[Index : TTabPageSide] : integer read GetChangingTab write SetChangingTab; //kt-tabs
  end;

var
  frmFrame: TfrmFrame;
  uTabList: TStringList;
  TabColorsEnabled : Boolean;                   //kt 9/11 added
  TabColorsList : TStringList;                  //kt 9/11 added
  TMGShuttingDownDueToCrash : boolean = FALSE;  //kt added 2/17
  NoPatientIDPhotoIcon : TBitmap;               //kt 4/14/14  NOTE: auto created in initialization section below.
  uRemoteType, uReportID, uLabRepID : string;
  FlaggedPTList: TStringList;
  ctxContextor : TContextorControl;
//  NextTabL, LastTabL, ChangingTabL: Integer;
//  NextTabR, LastTabR, ChangingTabR: Integer;
  uUseVistaWeb: boolean;
  PTSwitchRefresh: boolean = FALSE;  //flag for patient refresh or switch of patients
  //kt-tabs ProbTabClicked: boolean = FALSE;
  //kt-tabs TabCtrlClicked: Boolean = FALSE;  //used in fProbs
  //kt-tabs TabCtrlClickedSide : TTabPageSide = tpsLeft;  //kt 7/23/21 -- When TabCtrlClicked = true, then this will show which side.
  DEAContext: Boolean = False;
  DelayReviewChanges: Boolean = False;


const
  PASSCODE = '_gghwn7pghCrOJvOV61PtPvgdeEU2u5cRsGvpkVDjKT_H7SdKE_hqFYWsUIVT1H7JwT6Yz8oCtd2u2PALqWxibNXx3Yo8GPcTYsNaxW' + 'ZFo8OgT11D5TIvpu3cDQuZd3Yh_nV9jhkvb0ZBGdO9n-uNXPPEK7xfYWCI2Wp3Dsu9YDSd_EM34nvrgy64cqu9_jFJKJnGiXY96Lf1ecLiv4LT9qtmJ-BawYt7O9JZGAswi344BmmCbNxfgvgf0gfGZea';
  TMG_ADD_PATIENT_RPC = 'TMG ADD PATIENT';  //kt 9/11 added

implementation

{$R *.DFM}
{$R sBitmaps}
{$R sRemSrch}

uses
  ORNet, rCore, fPtSelMsg, fPtSel, fCover, fProbs, fMeds, fOrders, rOrders, fNotes, fConsults, fDCSumm,
  rMisc, Clipbrd, fLabs, fReports, rReports, fPtDemo, fEncnt, fPtCWAD, uCore, fAbout, fReview, fxBroker,
  fxLists, fxServer, ORSystem, fRptBox, fSplash, rODAllergy, uInit, fLabTests, fLabInfo,
  uReminders, fReminderTree, ORClasses, fDeviceSelect, fDrawers, fReminderDialog, ShellAPI, rVitals,
  fOptions, fGraphs, fGraphData, rTemplates, fSurgery, rSurgery, uEventHooks, uSignItems,
  fDefaultEvent, rECS, fIconLegend, uOrders, fPtSelOptns, DateUtils, uSpell, uOrPtf, fPatientFlagMulti,
  fAlertForward, UBAGlobals, fBAOptionsDiagnoses, UBACore, fOrdersSign, uVitals, fOrdersRenew, fMHTest, uFormMonitor
  {$IFDEF CCOWBROKER}
  , CCOW_const
  {$ENDIF}
  , fLetterWriter, fSearchResults, fADT, fWebTab, fPtLabelPrint, fImages, uImages, 
  fIntracarePtLbl, fPtAuditLog, fBillableItems, 
  VA508AccessibilityRouter, 
  fOtherSchedule, VAUtils, uVA508CPRSCompatibility, fIVRoutes, frmEPrescribe, fPtDemoEdit, fESEdit, 
  fPrintLocation, fTemplateEditor, fTemplateDialog, fCombatVet,
  ColorUtil,       //kt added
  uTMGOptions,   //kt added
  fSMSLabText,      //kt
  fSingleNote,    //kt
  fAnticoagulator, 
  uTMG_WM_API,  //kt
  fTest_RW_HTML,  //kt TEMP, KILL LATER...
  fMemoEdit,                               //kt  testing purposes only can be removed later
  fPtHTMLDemo, 
  fOptionsLists, 
  uTMGUtil, 
  fMailbox, 
  fUploadImages;

var                                 //  RV 05/11/04
  IsRunExecuted: Boolean = FALSE;           //  RV 05/11/04
  tempFrmWebTab : TfrmWebTab;               //kt 9/11 added
  GraphFloat: TfrmGraphs;

const
 //  moved to uConst - RV v16
(*  CT_NOPAGE   = -1;                             // chart tab - none selected
  CT_UNKNOWN  =  0;                             // chart tab - unknown (shouldn't happen)
  CT_COVER    =  1;                             // chart tab - cover sheet
  CT_PROBLEMS =  2;                             // chart tab - problem list
  CT_MEDS     =  3;                             // chart tab - medications screen
  CT_ORDERS   =  4;                             // chart tab - doctor's orders
  CT_HP       =  5;                             // chart tab - history & physical
  CT_NOTES    =  6;                             // chart tab - progress notes
  CT_CONSULTS =  7;                             // chart tab - consults
  CT_DCSUMM   =  8;                             // chart tab - discharge summaries
  CT_LABS     =  9;                             // chart tab - laboratory results
  CT_REPORTS  = 10;                             // chart tab - reports
  CT_SURGERY  = 11;                             // chart tab - surgery*)

  FCP_UPDATE  = 10;                             // form create about to check auto-update
  FCP_SETHOOK = 20;                             // form create about to set timeout hooks
  FCP_SERVER  = 30;                             // form create about to connect to server
  FCP_CHKVER  = 40;                             // form create about to check version
  FCP_OBJECTS = 50;                             // form create about to create core objects
  FCP_FORMS   = 60;                             // form create about to create child forms
  FCP_PTSEL   = 70;                             // form create about to select patient
  FCP_FINISH  = 99;                             // form create finished successfully

  TX_IN_USE     = 'VistA CPRS in use by: ';     // use same as with CPRSInstances in fTimeout
  TX_OPTION     = 'OR CPRS GUI CHART';
  TX_ECSOPT     = 'EC GUI CONTEXT';
  TX_PTINQ      = 'Retrieving demographic information...';
  TX_NOTIF_STOP = 'Stop processing notifications?';
  TC_NOTIF_STOP = 'Currently Processing Notifications';
  TX_UNK_NOTIF  = 'Unable to process the follow up action for this notification';
  TC_UNK_NOTIF  = 'Follow Up Action Not Implemented';
  TX_NO_SURG_NOTIF = 'This notification must be processed using the Surgery tab, ' + CRLF +
                     'which is not currently available to you.';
  TC_NO_SURG_NOTIF = 'Surgery Tab Not Available';
  TX_VER1       = 'This is version ';
  TX_VER2       = ' of CPRSChart.exe.';
  TX_VER3       = CRLF + 'The running server version is ';
  TX_VER_REQ    = ' version server is required.';
  TX_VER_OLD    = CRLF + 'It is strongly recommended that you upgrade.';
  TX_VER_OLD2   = CRLF + 'The program cannot be run until the client is upgraded.';
  TX_VER_NEW    = CRLF + 'The program cannot be run until the server is upgraded.';
  TC_VER        = 'Server/Client Incompatibility';
  TC_CLIERR     = 'Client Specifications Mismatch';

  SHOW_NOTIFICATIONS = True;

  TC_DGSR_ERR    = 'Remote Data Error';
  TC_DGSR_SHOW   = 'Restricted Remote Record';
  TC_DGSR_DENY   = 'Remote Access Denied';
  TX_DGSR_YESNO  = CRLF + 'Do you want to continue accessing this remote patient record?';

  TX_CCOW_LINKED   = 'Clinical Link On';
  TX_CCOW_CHANGING = 'Clinical link changing';
  TX_CCOW_BROKEN   = 'Clinical link broken';
  TX_CCOW_ERROR    = 'CPRS was unable to communicate with the CCOW Context Vault' + CRLF +
                     'CCOW patient synchronization will be unavailable for the remainder of this session.';
  TC_CCOW_ERROR    = 'CCOW Error';

function TfrmFrame.TimeoutCondition: boolean;
begin
  Result := (FCreateProgress < FCP_PTSEL);
end;

procedure TfrmFrame.timerStopwatchTimer(Sender: TObject);
//kt 4/14/15
var
  Minutes,Seconds : integer;
  Time : Extended;
  Caption : String;
  Percent : integer;
begin
  inherited;
  Minutes := StrToInt(Piece(pnlTimer.Caption,':',1));
  Seconds := StrToInt(Piece(pnlTimer.Caption,':',2));
  Seconds := Seconds + 1;
  if Seconds > 59 then begin
    Seconds := 0;
    Minutes := Minutes + 1;
  end;
  if Minutes < 10 then Caption := '0';
  Caption := Caption + inttostr(Minutes)+':';
  if Seconds < 10 then Caption := Caption + '0';
  Caption := Caption + inttostr(Seconds);

  pnlTimer.Caption := Caption;
  Time := Minutes+(Seconds/60);
  Percent := Round(Time*100/intTimerMaxTime);
  if Percent>100 then Percent:=100;  //elh  11/17/20
  pnlTimer.Color := ColorBlend(colorTimerOnMax,colorTimerOn,Percent);
end;

procedure TfrmFrame.timScheduleTimer(Sender: TObject);
begin
  inherited;
  GetCurrentPatientLoad(pnlSchedule);
end;

function TfrmFrame.GetTimedOut: boolean;
begin
  Result := uInit.TimedOut;
end;

procedure TfrmFrame.TimeOutAction;
var
  ClosingCPRS: boolean;

  procedure CloseCPRS;
  begin
    if ClosingCPRS then
      halt;
    try
      ClosingCPRS := TRUE; 
      Close;
    except
      halt;
    end;
  end;

begin
  ClosingCPRS := FALSE;
  try
    if assigned(frmOtherSchedule) then frmOtherSchedule.Close;
    if assigned (frmIVRoutes) then frmIVRoutes.Close;
    if frmFrame.DLLActive then
    begin
       CloseVitalsDLL();
       CloseMHDLL();
    end;
    CloseCPRS;
  except
    CloseCPRS;
  end;
end;

{ General Functions and Procedures }

procedure TfrmFrame.AppException(Sender: TObject; E: Exception);
var
  AnAddr: Pointer;
  ErrMsg: string;
begin
  Application.NormalizeTopMosts;
  if (E is EIntError) then begin
    ErrMsg := E.Message + CRLF +
              'CreateProgress: ' + IntToStr(FCreateProgress) + CRLF +
              'RPC Info: ' + RPCLastCall;
    if EExternal(E).ExceptionRecord <> nil then begin
      AnAddr := EExternal(E).ExceptionRecord^.ExceptionAddress;
      ErrMsg := ErrMsg + CRLF + 'Address was ' + IntToStr(Integer(AnAddr));
    end;
    ShowMsg(ErrMsg);
  end else if (E is EBrokerError) then begin
    Application.ShowException(E);
    FCreateProgress := FCP_FORMS;
    TMGShuttingDownDueToCrash := TRUE; //kt 2/17
    Close; //kt note: this will close application
  end else if (E is EOleException) then begin
    Application.ShowException(E);
    FCreateProgress := FCP_FORMS;
    TMGShuttingDownDueToCrash := TRUE; //kt 2/17
    Close; //kt note: this will close application
  end
  //kt 9/11 -- begin mod --
  else if (E is EInvalidOperation) then begin
    if E.Message = 'Cannot focus a disabled or invisible window' then begin
      i := 1; // do nothing
    end else Application.ShowException(E);
  end
  //kt 9/11 -- end mod --
  else Application.ShowException(E);
  Application.RestoreTopMosts;
end;

procedure TfrmFrame.btnCombatVetClick(Sender: TObject);
begin
  inherited;
  frmCombatVet := TfrmCombatVet.Create(frmFrame);
  frmCombatVet.ShowModal;
  frmCombatVet.Free;
end;

procedure TfrmFrame.btnTimerClick(Sender: TObject);
//kt added entire function  4/14/15
begin
  inherited;
  bTimerOn := (bTimerOn=False);
  timerStopwatch.enabled := bTimerOn;
  if bTimerOn then begin
     pnlTimer.color := colorTimerOn;
     SaveEvent('',1);
  end else begin
     pnlTimer.color := colorTimerPaused;
     SaveEvent('',2);
  end;
end;

procedure TfrmFrame.btnTimerResetClick(Sender: TObject);
//kt added entire function   4/14/15
begin
  inherited;
  if bTimerOn=True then begin
    pnlTimer.SetFocus;
    SaveEvent('',2);
  end;
  pnlTimer.Caption := '00:00';
  pnlTimer.Color := clBtnFace;
  timerStopwatch.enabled := False;
  pnlTimer.color := colorTimerOff;
  bTimerOn := False;
end;

procedure TfrmFrame.NotifyContextChangeCancelledAll;
//kt added entire function.
{ Rationale is a situation that arises when user is editing a note,
 and note displays in TreeView in "note in progress" section.  If
 user starts to select a new patient, then note gets signed during
 AllowContextChangeAll(), but this doesn't cause notes to reload.
 If user then cancels out of selecting a new patient, then program
 configuration logic drops back to prior state.  But now we have a
 signed note in the wrong section.  So tabs need to be given notification
 that a new patient wasn't selected (which would have taken care of
 the problem), so they can take remedial action if needed. In case of
 Notes tab, reloading notes will solve the problem.
 NOTE: CCOW state is not restored here, but probably could be.
}
begin
  frmNotes.ContextChangeCancelled;
  { //below to be implemented as needed.
  frmCover.ContextChangeCancelled;
  frmProblems.ContextChangeCancelled;
  frmMeds.ContextChangeCancelled;
  frmOrders.ContextChangeCancelled;
  frmConsults.ContextChangeCancelled;
  frmDCSumm.ContextChangeCancelled;
  frmImages.ContextChangeCancelled;
  if Assigned(frmSurgery) then frmSurgery.ContextChangeCancelled;
  frmLabs.ContextChangeCancelled;
  frmReports.ContextChangeCancelled;
  frmGraphData.ContextChangeCancelled;
  TEPrescribeForm.ContextChangeCancelled;
  }
end;

function TfrmFrame.AllowContextChangeAll(var Reason: string): Boolean;
var
  Silent: Boolean;
begin
  if pnlNoPatientSelected.Visible then begin
    Result := True;
    exit;
  end;
  FContextChanging := True;
  Result := True;
  if COMObjectActive or SpellCheckInProgress or DLLActive then begin
    Reason := 'COM_OBJECT_ACTIVE';
    Result:= False;
  end;
  if Result then Result := frmCover.AllowContextChange(Reason);
  if Result then Result := frmProblems.AllowContextChange(Reason);
  if Result then Result := frmMeds.AllowContextChange(Reason);
  if Result then Result := frmOrders.AllowContextChange(Reason);
  if Result then Result := frmNotes.AllowContextChange(Reason);
  if Result then Result := frmConsults.AllowContextChange(Reason);
  if Result then Result := frmDCSumm.AllowContextChange(Reason);
  if Result then Result := frmImages.AllowContextChange(Reason);  //kt 9/11 added
  if Result then if Assigned(frmSurgery) then Result := frmSurgery.AllowContextChange(Reason);;
  if Result then Result := frmLabs.AllowContextChange(Reason);;
  if Result then Result := frmReports.AllowContextChange(Reason);
  if Result then Result := frmGraphData.AllowContextChange(Reason);
  if (not User.IsReportsOnly) then begin
    if Result and Changes.RequireReview then begin //Result := ReviewChanges(TimedOut);
      case BOOLCHAR[FCCOWContextChanging] of
        '1': begin
               if Changes.RequireReview then
                 begin
                   Reason := 'Items will be left unsigned.';
                   Result := False;
                 end
               else
                 Result := True;
             end;
        '0': begin
               Silent := (TimedOut) or (Reason = 'COMMIT');
               if frmNotes.AllowSignature=False then exit;  //FPG for Intracare 2/10/15
               Result := ReviewChanges(Silent);
             end;
      end; //case
    end;
  end;
  if Result then Result := TEPrescribeForm.AllowContextChange(reason);  //eRx  9/4/12
  if Result then if Assigned(frmSingleNote) then Result := frmSingleNote.AllowContextChange(Reason);  //kt 2/10/17

  FContextChanging := False;
end;

procedure TfrmFrame.ClearPatient;
{ call all pages to make sure patient related information is cleared (when switching patients) }
var
  ASide : TTabPageSide;
begin
  //if frmFrame.Timedout then Exit; // added to correct Access Violation when "Refresh Patient Information" selected
  lblPtName.Caption     := '';
  lblPtSSN.Caption      := '';
  lblPtAge.Caption      := '';
  pnlPatient.Caption    := '';
  PatientImage.Picture.Bitmap.Assign(NoPatientIDPhotoIcon);  //kt  4/15/14
  lblPtCWAD.Caption     := '';
  if DoNotChangeEncWindow = false then begin
    lblPtLocation.Caption := 'Visit Not Selected';
    //TMG changed "Current Provider" to "Current PCP" original line -> lblPtProvider.Caption := 'Current Provider Not Selected';
    lblPtProvider.Caption := 'Current PCP Not Selected';  //TMG 9/7/18
    pnlVisit.Caption      := lblPtLocation.Caption + CRLF + lblPtProvider.Caption;
  end;
  lblPtCare.Caption     := sCallV('TMG CPRS GET NEXT APPOINTMENT',[Patient.DFN,'0']);  //Primary Care Team Unassigned
  lblPtAttending.Caption := sCallV('TMG CPRS GET NEXT APPOINTMENT',[Patient.DFN,'1']);  //Primary Care Team Unassigned;
  lblPtMHTC.Caption := '';
  pnlPrimaryCare.Caption := lblPtCare.Caption + ' ' + lblPtAttending.Caption + ' ' + lblPtMHTC.Caption;
  pnlPrimaryCare.Hint := lblPtCare.Caption;
  frmCover.ClearPtData;
  frmProblems.ClearPtData;
  frmMeds.ClearPtData;
  frmOrders.ClearPtData;
  frmNotes.ClearPtData;
  frmConsults.ClearPtData;
  frmDCSumm.ClearPtData;
  if Assigned(frmSurgery) then frmSurgery.ClearPtData;
  frmLabs.ClearPtData;
  frmGraphData.ClearPtData;
  frmReports.ClearPtData;
  for ASide := tpsLeft to tpsRight do begin
    FTabPage[ASide].TabIndex := PageIDToTab(CT_NOPAGE);       // to make sure DisplayPage gets called  //kt-tabs
    tabPageChange(ASide);  //kt-tabs
  end;
  ClearReminderData;
  SigItems.Clear;
  Changes.Clear;
  lstCIRNLocations.Clear;
  ClearFlag;
  if Assigned(FlagList) then FlagList.Clear;
  HasFlag := False;
  HidePatientSelectMessages;
  if (GraphFloat <> nil) and GraphFloatActive then
  with GraphFloat do begin
    Initialize;
    DisplayData('top');
    DisplayData('bottom');
    //GtslCheck.Clear;
    Caption := 'CPRS Graphing - Patient: ' + MixedCase(Patient.Name);
  end;
  if frmFrame.TimedOut then begin
    infoBox('CPRS has encountered a serious problem and is unable to display the selected patient''s data. '
            + 'To prevent patient safety issues, CPRS is shutting down. Shutting down and then restarting CPRS will correct the problem, and you may continue working in CPRS.'
             + CRLF + CRLF + 'Please report all occurrences of this problem by contacting your CPRS Help Desk.', 'CPRS Error', MB_OK);
    TMGShuttingDownDueToCrash := TRUE; //kt 2/17
    frmFrame.Close;
  end;
end;

procedure TfrmFrame.mnuClosePatientClick(Sender: TObject);
//kt added fnction
begin
  inherited;
  SetActiveTab(0); //12/28/20
  HideEverything();
end;

procedure TfrmFrame.DigitalSigningSetup1Click(Sender: TObject);
begin
  inherited;
  LastPINvalue := '';
  SetSAN(Self);
  LastPINvalue := '';
end;

procedure TfrmFrame.DisplayEncounterText;
{ updates the display in the header bar of encounter related information (location & provider) }
begin
  if DoNotChangeEncWindow = true then exit;
  with Encounter do
  begin
    if Length(LocationText) > 0
      then lblPtLocation.Caption := LocationText
      else lblPtLocation.Caption := 'Visit Not Selected';
    if Length(ProviderName) > 0
      then lblPtProvider.Caption := 'PCP:  ' + ProviderName //TMG  9/7/18  original line -> lblPtProvider.Caption := 'Provider:  ' + ProviderName
      else lblPtProvider.Caption := 'Current PCP Not Selected'; //TMG  9/7/18  original line -> lblPtProvider.Caption := 'Current Provider Not Selected';
  end;
  pnlVisit.Caption := lblPtLocation.Caption + CRLF + lblPtProvider.Caption;
  FitToolBar;
end;

function TfrmFrame.DLLActive: boolean;
begin
  Result := (VitalsDLLHandle <> 0) or (MHDLLHandle <> 0);
end;

{ Form Events (Create, Destroy) ----------------------------------------------------------- }


procedure TfrmFrame.RefreshFixedStatusWidth;
begin
  with stsArea do
    FFixedStatusWidth := Panels[0].Width + Panels[2].Width + Panels[3].Width + Panels[4].Width;
end;

procedure TfrmFrame.FormCreate(Sender: TObject);
{ connect to server, create tab pages, select a patient, & initialize core objects }
var
  //ClientVer, ServerVer, ServerReq: string;
  tempS : string;                 //kt 9/11
  i : integer;                    //kt 9/11
  ImagesEnabled : boolean;        //kt 9/11
  Connected : boolean;            //kt 9/11
  RetryConnect : integer;         //kt 9/11
  ClientVer, ServerVer, ServerReq, SAN: string;
  ASide : TTabPageSide; //kt-tabs
begin
  FJustEnteredApp := false;
  SizeHolder := TSizeHolder.Create;
  FOldActiveFormChange := Screen.OnActiveFormChange;
  Screen.OnActiveFormChange := ScreenActiveFormChange;
  TabCtrlClicked := FALSE;  //kt-tabs 7/25/21
  TabCtrlClickedSide := tpsLeft;  //kt-tabs 7/25/21  Default
  ProbTabClicked := FALSE;  //kt-tabs 7/25/21
  //kt begin mod 4/7/15
  WebServerIP := ParamSearch('WS');
  if WebServerIP = '' then WebServerIP := ParamSearch('S');
  WebServerPort := ParamSearch('WP');
  if WebServerPort = '' then WebServerPort := ParamSearch('P');
  //kt end mod 4/7/15

  if not (ParamSearch('CCOW')='DISABLE') then begin
    try
      StartCCOWContextor;
    except
      IsRunExecuted := False;
      FCCOWInstalled := False;
      pnlCCOW.Visible := False;
      mnuFileResumeContext.Visible := False;
      mnuFileBreakContext.Visible := False;
    end
  end else begin
    IsRunExecuted := False;
    FCCOWInstalled := False;
    pnlCCOW.Visible := False;
    mnuFileResumeContext.Visible := False;
    mnuFileBreakContext.Visible := False;
  end;

  RefreshFixedStatusWidth;
  FTerminate := False;
  AutoUpdateCheck;

  FFlagList := TStringList.Create;

  // setup initial timeout here so can timeout logon
  FCreateProgress := FCP_SETHOOK;
  InitTimeOut(TimeoutCondition, TimeOutAction);

  // connect to the server and create an option context
  FCreateProgress := FCP_SERVER;

{$IFDEF CCOWBROKER}
  EnsureBroker;
  if ctxContextor <> nil then begin
    if ParamSearch('CCOW') = 'PATIENTONLY' then
      RPCBrokerV.Contextor := nil
    else
      RPCBrokerV.Contextor := ctxContextor;
  end else
    RPCBrokerV.Contextor := nil;
{$ENDIF}

{ //kt 9/11 -- Original block --
  if not ConnectToServer(TX_OPTION) then
  begin
    if Assigned(RPCBrokerV) then
      InfoBox(RPCBrokerV.RPCBError, 'Error', MB_OK or MB_ICONERROR);
    Close;
    Exit;
  end;  }

  //kt 9/11 -- begin mod --------------
  TMGAbort := False;
  repeat
    Connected := ConnectToServer(TX_OPTION);
    if not Connected then begin
      RetryConnect := mrCancel;
      if Assigned(RPCBrokerV) then begin
        RetryConnect := MessageDlg(RPCBrokerV.RPCBError, mtError, [mbRetry, mbCancel], 0);
      end;
      if RetryConnect <> mrRetry then begin
        Close;
        TMGAbort := True;
        Exit;
      end;
    end;
  until Connected;   //Exit command above will also abort loop
  //kt 9/11 -- end mod ----------

  if ctxContextor <> nil then begin
    if not (ParamSearch('CCOW') = 'PATIENTONLY') then
      ctxContextor.NotificationFilter := ctxContextor.NotificationFilter + ';User';
  end;

  FECSAuthUser := ValidECSUser;
  uECSReport := TECSReport.Create;
  uECSReport.ECSPermit := FECSAuthUser;
  RPCBrokerV.CreateContext(TX_OPTION);
  Application.OnException := AppException;
  FOldActivate := Application.OnActivate;
  Application.OnActivate := AppActivated;
  Application.OnDeActivate := AppDeActivated;

  // create initial core objects
  FCreateProgress := FCP_OBJECTS;
  User := TUser.Create;

 // agp wv begin changes  //kt
  if GetUserParam('WV HIDE PATIENT SSN')= '1' then hidePtSSN := true;
  // adg wv end changes

  // make sure we're using the matching server version
  FCreateProgress := FCP_CHKVER;
  ClientVer := ClientVersion(Application.ExeName);
  ServerVer := ServerVersion(TX_OPTION, ClientVer);
  if (ServerVer = '0.0.0.0') then begin
    InfoBox('Unable to determine current version of server.', TX_OPTION, MB_OK);
    TMGAbort := True; //kt 9/11
    Close;
    Exit;
  end;
  ServerReq := Piece(FileVersionValue(Application.ExeName, FILE_VER_INTERNALNAME), ' ', 1);
  //kt Allow 'SPOOF-VER=x.x.x.x' command-line parameter
  tempS := Trim(ParamSearch('SPOOF-VER')); //kt 9/11 added
  if tempS <>'' then begin
    ServerReq := tempS;  //kt 9/11 added
    //kt 7/15 ServerVer := tempS;  //kt 9/11 added
    ClientVer := tempS;  //kt 7/15 added
  end;
  if (ClientVer <> ServerReq) then begin
    InfoBox('Client "version" does not match client "required" server.', TC_CLIERR, MB_OK);
    TMGAbort := True; //kt 9/11
    Close;
    Exit;
  end;
  SAN := sCallV('XUS PKI GET UPN', []);
  if SAN='' then DigitalSigningSetup1.Visible := True
  else DigitalSigningSetup1.Visible := False;
  if (CompareVersion(ServerVer, ServerReq) <> 0) then begin
    if (sCallV('ORWU DEFAULT DIVISION', [nil]) = '1') then begin
      if (InfoBox('Proceed with mismatched Client and Server versions?', TC_CLIERR, MB_YESNO) = ID_NO) then begin
        TMGAbort := True; //kt 9/11
        Close;
        Exit;
      end;
    end else begin
      if (CompareVersion(ServerVer, ServerReq) > 0) then begin // Server newer than Required
        // NEXT LINE COMMENTED OUT - CHANGED FOR VERSION 19.16, PATCH OR*3*155:
        //      if GetUserParam('ORWOR REQUIRE CURRENT CLIENT') = '1' then
        if (true) then begin // "True" statement guarantees "required" current version client.
          InfoBox(TX_VER1 + ClientVer + TX_VER2 + CRLF + ServerReq + TX_VER_REQ + TX_VER3 + ServerVer + '.' + TX_VER_OLD2, TC_VER, MB_OK);
          TMGAbort := True; //kt 9/11
          Close;
          Exit;
        end;
      end else InfoBox(TX_VER1 + ClientVer + TX_VER2 + CRLF + ServerReq + TX_VER_REQ + TX_VER3 + ServerVer + '.' + TX_VER_OLD, TC_VER, MB_OK);
    end;
    if (CompareVersion(ServerVer, ServerReq) < 0) then begin// Server older then Required
      InfoBox(TX_VER1 + ClientVer + TX_VER2 + CRLF + ServerReq + TX_VER_REQ + TX_VER3 + ServerVer + '.' + TX_VER_NEW, TC_VER, MB_OK);
      TMGAbort := True; //kt 9/11
      Close;
      Exit;
    end;
  end;

  // Add future tabs here as they are created/implemented:
  if (
     (not User.HasCorTabs) and
     (not User.HasRptTab)
     )
  then begin
    InfoBox('No valid tabs assigned', 'Tab Access Problem', MB_OK);
    Close;
    Exit;
  end;

  CheckForRPC(TMG_ADD_PATIENT_RPC);   //Check For TMG Patch    //kt 9/11, 4/14/14 (made constant)

  // create creating core objects
  Patient := TPatient.Create;
  Encounter := TEncounter.Create;
  Changes := TChanges.Create;
  Notifications := TNotifications.Create;
  RemoteSites := TRemoteSiteList.Create;
  RemoteReports := TRemoteReportList.Create;
  uTabList := TStringList.Create;
  TabColorsList := TStringList.Create; //kt added 9/11
  FlaggedPTList := TStringList.Create;
  HasFlag  := False;
  FlagList := TStringList.Create;
  // set up structures specific to the user
  Caption := TX_IN_USE + MixedCase(User.Name) + '  (' + RPCBrokerV.Server + ')';
  SetDebugMenu;
  if InteractiveRemindersActive then
    NotifyWhenRemindersChange(RemindersChanged);
  // load all the tab pages
  FCreateProgress := FCP_FORMS;
  FTabPage[tpsLeft] := tabPageL;  //kt-tabs
  FTabPage[tpsRight] := tabPageR; //kt-tabs
  PnlPage[tpsLeft] := pnlPageL;  //kt-tabs
  PnlPage[tpsRight] := pnlPageR; //kt-tabs

  CreateTab(tpsLeft, CT_PROBLEMS, 'Problems');
  CreateTab(tpsLeft, CT_MEDS,     'Meds');
  CreateTab(tpsLeft, CT_ORDERS,   'Orders');
  CreateTab(tpsLeft, CT_NOTES,    'Notes');
  CreateTab(tpsLeft, CT_CONSULTS, 'Consults');
  if ShowSurgeryTab then CreateTab(tpsLeft, CT_SURGERY,  'Surgery');
  CreateTab(tpsLeft, CT_DCSUMM,   'D/C Summ');
  CreateTab(tpsLeft, CT_LABS,     'Labs');
  CreateTab(tpsLeft, CT_REPORTS,  'Reports');
  CreateTab(tpsLeft, CT_COVER,    'Cover Sheet');

  CreateTab(tpsLeft, CT_IMAGES,   'Images');  //kt 9/11
  CreateTab(tpsLeft, CT_MAILBOX,  'Mailbox');  //kt 9/11
  ImagesEnabled := uTMGOptions.ReadBool('EnableImages',false);           //kt 9/11
  if not ImagesEnabled then SetATabVisibility(CT_IMAGES, ImagesEnabled); //kt 9/11

  for i := CT_WEBTAB1 to CT_LAST_WEBTAB do begin                         //kt 9/11
    CreateTab(tpsLeft, i, IntToStr(i-CT_WEBTAB1+1));                              //kt 9/11
    SetATabVisibility(i, false); //Hide until activated by RPC           //kt 9/11
  end;

  LoadTabColors(TabColorsList);                                          //kt 9/11

  for ASide := tpsLeft to tpsRight do begin
    FTabPage[ASide].OwnerDraw := TabColorsEnabled;                        //kt 9/11  //kt-tabs
  end;

  ShowHideChartTabMenus(mnuViewChart);
  //  We defer calling LoadUserPreferences to UMInitiate, so that the font sizing
  // routines recognize this as the application's main form (this hasn't been
  // set yet).
  FNextButtonBitmap := TBitmap.Create;
  FNextButtonBitmap.LoadFromResourceName(hInstance, 'BMP_HANDRIGHT');
  // set the timeout to DTIME now that there is a connection
  UpdateTimeOutInterval(User.DTIME * 1000);  // DTIME * 1000 mSec
  // get a patient
  HandleNeeded;                              // make sure handle is there for ORWPT SHARE call
  FCreateProgress := FCP_PTSEL;
  Enabled := False;
  FFirstLoad := True;                       // First time to initialize the fFrame
  FCreateProgress := FCP_FINISH;
  pnlReminders.Visible := InteractiveRemindersActive;
  GraphFloatActive := false;
  GraphContext := '';
  frmGraphData := TfrmGraphData.Create(self);        // form is only visible for testing
  GraphDataOnUser;
  uRemoteType := '';
  uReportID := '';
  uLabRepID := '';
  FPrevPtID := '';
  SetUserTools;

  mnuEditDemographics.Enabled := frmFrame.CheckForRPC(TMG_ADD_PATIENT_RPC);  //kt 9/11

  EnduringPtSelSplitterPos := 0;
  EnduringPtSelColumns := '';
  if User.IsReportsOnly then // Reports Only tab.
    ReportsOnlyDisplay; // Calls procedure to hide all components/menus not needed.
  InitialOrderVariables;
  PostMessage(Handle, UM_INITIATE, 0, 0);    // select patient after main form is created
//  mnuFileOpenClick(Self);
//  if Patient.DFN = '' then  //*DFN*
//  begin
//    Close;
//    Exit;
//  end;
//  if WindowState = wsMinimized then WindowState := wsNormal;
  SetFormMonitoring(true);
  InsertFormLetterPrintingMenuItem(mnuFile);  //kt added
  NoPatientIDPhotoIcon.Assign(PatientImage.Picture.Bitmap); //Icon stored in form.  Save here for when changed.

  FDragAndDropFName := '';  //kt 4/15/14
  DragAcceptFiles(pnlPatientImage.Handle, True); //kt 4/15/14
  OriginalPanelWindowProc := pnlPatientImage.WindowProc;  //kt   4/16/14
  pnlPatientImage.WindowProc := PanelWindowProc;            //kt   4/16/14
  //kt 4/14/15 begin mod ----------
  bTimerOn := False;
  colorTimerOn := StringToColor(uTMGOptions.ReadString('colorTimerOn','$FFFF00'));
  colorTimerOff := StringToColor(uTMGOptions.ReadString('colorTimerOff','$C0C0C0'));
  colorTimerPaused := StringToColor(uTMGOptions.ReadString('colorTimerPaused','$00FFFF'));
  colortimerOnMax := StringToColor(uTMGOptions.ReadString('colorTimerOnMax','$FFFFFF'));
  NoteTitleDateFormat := uTMGOptions.ReadString('TMG CPRS NOTE DATE FORMAT','mmm dd,yy'); //tmg 7/25/19
  intTimerMaxTime := uTMGOptions.ReadInteger('TimerMaxTime',40);
  pnlTimer.Color := colorTimerOff;
  CreateProgressBars(pnlSchedule); //11/2/17
  GetCurrentPatientLoad(pnlSchedule); // 12/12/17  Load pat list before timer starts
  timSchedule.Interval := uTMGOptions.ReadInteger('Appt Timer Interval',1000);
  timSchedule.Enabled := true;
  TurnOnUploads := False;
  SetUpResizeButtons; //kt 4/28/21
  TControlCracker(frameLRSplitter).OnMouseEnter := frameLRSplitterMouseEnter;  //kt-tabs
  TControlCracker(frameLRSplitter).OnMouseLeave := frameLRSplitterMouseLeave;  //kt-tabs
  SetTabOpenMode(tpoClosed);
  //timCheckSequel.Enabled := True;
  //Application.OnMessage := AppMessage;
  //kt end mod ------------------- /
end;

procedure TfrmFrame.PanelWindowProc(var Msg: TMessage);        //kt   4/16/14
begin
  if Msg.Msg = WM_DROPFILES then begin
    WMDropFiles(Msg);
  end else begin
    originalPanelWindowProc(Msg);
  end;
end;


procedure TfrmFrame.InsertFormLetterPrintingMenuItem(MenuFile : TMenuItem);
//kt 9/11 added entire function
var InsertPoint, i : integer;
begin
  InsertPoint := MenuFile.Count-2;
  for i := 0 to MenuFile.Count-1 do begin
    if MenuFile.Items[i] <> mnuFilePrint then continue;
    InsertPoint := i+1;
    break;
  end;
  mnuPrintFormLetters := TMenuItem.Create(MenuFile);
  with mnuPrintFormLetters do begin
    Caption := 'Print &Form Letters';
    OnClick := ShowLetterWriterClick;
  end;
  if (InsertPoint >=0) and (InsertPoint < MenuFile.Count) then begin
    MenuFile.Insert(InsertPoint,mnuPrintFormLetters);
  end else begin
    MenuFile.Add(mnuPrintFormLetters);
  end;
end;


procedure TfrmFrame.ShowLetterWriterClick(Sender: TObject);
//kt 9/11 Added entire function
begin
  frmLetterWriter := TfrmLetterWriter.Create(frmFrame);
  frmLetterWriter.ShowModal;
  frmLetterWriter.Free;
end;

procedure TfrmFrame.SetATabVisibility(ATabID: integer; Visible: boolean; ALabel:string='x');  //kt 9/11 //kt-tabs 6/10/21
//kt 9/11 added entire function;
//kt Note: if Visible=True, then ALabel is expected to contain label for tab. (Not remembered from before setting visible=false)
//Note: This presumes that CreateTab has already been called prior to setting visiblity.
var index : integer;
    tempTabPage : TTabControl;
    ASide: TTabPageSide; //kt-tabs

begin
  index := uTabList.IndexOf(IntToStr(ATabID));
  if (index > -1) and (Visible=false) then begin
    uTabList.Delete(index);
    for ASide := tpsLeft to tpsRight do begin
      tempTabPage := FTabPage[ASide];
      tempTabPage.Tabs.Delete(index);
    end;
  end else if (index < 0) and (Visible=true) then begin
    if ATabID = CT_COVER then begin
      uTabList.Insert(0, IntToStr(ATabID));
      for ASide := tpsLeft to tpsRight do begin
        tempTabPage := FTabPage[ASide];
        tempTabPage.Tabs.Insert(0, ALabel);
        tempTabPage.TabIndex := 0;
      end;
    end else begin
      uTabList.Add(IntToStr(ATabID));
      for ASide := tpsLeft to tpsRight do begin
        tempTabPage := FTabPage[ASide];
        tempTabPage.Tabs.Add(ALabel);
      end;
    end;
  end else if (index > -1) and (Visible=true) then begin
    for ASide := tpsLeft to tpsRight do begin
      tempTabPage := FTabPage[ASide];
      tempTabPage.Tabs.Strings[index] := ALabel;  //ensure label is correct.
    end;
  end;
end;


procedure TfrmFrame.SetWebTabsPerServer;
//kt 9/11 added entire function.
var
  URLList: TStringList;
  i      : integer;
  result : string;
begin
  URLList := TStringList.Create;
  result := fWebTab.AskServerForURLs(URLList);
  try
    if piece(result,'^',1)='0' then begin
      MessageDlg(piece(result,'^',2),mtError,[mbOK],0);
      exit;
    end;
    if piece(result,'^',1)='1' then begin
      for i := 1 to URLList.Count-1 do begin
        URLList[i] := StringReplace(URLList[i],'{{ws}}',WebServerIP,[rfReplaceAll,rfIgnoreCase]);
        URLList[i] := StringReplace(URLList[i],'{{wp}}',WebServerPort,[rfReplaceAll,rfIgnoreCase]);
        SetOneWebTabPerServer(i, URLList[i]);
      end;
    end;

  finally
    URLList.Free;
  end;
end;

procedure TfrmFrame.SetOneWebTabPerServer(WebTabNum: integer; URLMsg : string);
//kt 9/11 added entire function.
//Msg format: TabLabelName^URL
//            ^about:blank  <-- will make tab visible, but blank
//            ^<!HIDE!>     <-- will make tab invisible
//WebTabNum must be 1..(CT_LAST_WEBTAB-CT_WEBTAB1+1)
var
  ATabID : integer;
  TabLabel,URL : string;
begin
  ATabID := WebTabNum + CT_WEBTAB1 - 1;
  if (ATabID < CT_WEBTAB1) or (ATabID > CT_LAST_WEBTAB) then exit;
  TabLabel := piece (URLMsg,'^',1);
  URL := pieces (URLMsg,'^',2,32);
  //returns e.g. 'www.yahoo.com^^^^^^^^^^' etc,
  //  This allows for ^ to be contained in URL itself (but final character will be trimmed)
  while (URL <> '')and (URL[Length(URL)]='^') do begin  //trim trailing '^'s
    Delete(URL,Length(URL),1);
  end;
  if URL='<!HIDE!>' then begin
    SetATabVisibility(ATabID, false);
  end else if URL<>'<!NOCHANGE!>' then begin
    SetATabVisibility(ATabID, true, TabLabel);
    tempFrmWebTab := TfrmWebTab(WebTabsList[WebTabNum-1]);
    if tempFrmWebTab <> nil then tempFrmWebTab.NagivateTo(URL);
  end;
end;

procedure TfrmFrame.StartCCOWContextor;
begin
  try
    ctxContextor := TContextorControl.Create(Self);
    with ctxContextor do begin
      OnPending := ctxContextorPending;
      OnCommitted := ctxContextorCommitted;
      OnCanceled := ctxContextorCanceled;
    end;
    FCCOWBusy := False;
    FCCOWInstalled := True;
    FCCOWDrivedChange := False;
    ctxContextor.Run('CPRSChart', '', TRUE, 'Patient');
    IsRunExecuted := True;
  except
    on exc : EOleException do begin
      IsRunExecuted := False;
      FreeAndNil(ctxContextor);
      try
        ctxContextor := TContextorControl.Create(Self);
        with ctxContextor do begin
          OnPending := ctxContextorPending;
          OnCommitted := ctxContextorCommitted;
          OnCanceled := ctxContextorCanceled;
        end;
        FCCOWBusy := False;
        FCCOWInstalled := True;
        FCCOWDrivedChange := False;
        ctxContextor.Run('CPRSChart' + '#', '', TRUE, 'Patient');
        IsRunExecuted := True;
        if ParamSearch('CCOW') = 'FORCE' then begin
          mnuFileResumeContext.Enabled := False;
          mnuFileBreakContext.Visible := True;
          mnuFileBreakContext.Enabled := True;
        end else begin
          ctxContextor.Suspend;
          mnuFileResumeContext.Visible := True;
          mnuFileBreakContext.Visible := True;
          mnuFileBreakContext.Enabled := False;
        end;
      except
        IsRunExecuted := False;
        FCCOWInstalled := False;
        FreeAndNil(ctxContextor);
        pnlCCOW.Visible := False;
        mnuFileResumeContext.Visible := False;
        mnuFileBreakContext.Visible := False;
      end;
    end;
  end
end;

procedure TfrmFrame.UMInitiate(var Message: TMessage);
begin
  NotifyOtherApps(NAE_OPEN, IntToStr(User.DUZ));
  LoadUserPreferences;
  TMGInitialFontSize := MainFontSize;  //kt 4/28/21
  GetBAStatus(User.DUZ,Patient.DFN);
  mnuFileOpenClick(Self);
  Enabled := True;
  // If TimedOut, Close has already been called.
  if not TimedOut and (Patient.DFN = '') then Close;
end;

procedure TfrmFrame.FormDestroy(Sender: TObject);
{ free core objects used by CPRS }
begiN
  Application.OnActivate := FOldActivate;
  Screen.OnActiveFormChange := FOldActiveFormChange;
  FNextButtonBitmap.Free;
  if FNextButton <> nil then FNextButton.Free;
  uTabList.Free;
  TabColorsList.Free;  //kt 9/11 added
  FlaggedPTList.Free;
  RemoteSites.Free;
  RemoteReports.Free;
  Notifications.Free;
  Changes.Free;
  Encounter.Free;
  Patient.Free;
  User.Free;
  SizeHolder.Free;
  ctxContextor.Free;
  DragAcceptFiles(pnlPatientImage.Handle, False); //kt 4/15/14
end;

procedure TfrmFrame.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{ cancels close if the user cancels the ReviewChanges screen }
var
  Reason: string;
begin
  if (FCreateProgress < FCP_FINISH) then Exit;
  if User.IsReportsOnly then // Reports Only tab.
    exit;
  if TimedOut then begin
    if Changes.RequireReview then ReviewChanges(TimedOut);
    Exit;
  end;
  if not AllowContextChangeAll(Reason) then CanClose := False;
end;

procedure TfrmFrame.SetUserTools;
var
  item, parent: TToolMenuItem;
  ok: boolean;
  index, i, idx, count: Integer;
  UserTool: TMenuItem;
  Menus: TStringList;
  //  OptionsClick: TNotifyEvent;
begin
  if User.IsReportsOnly then begin // Reports Only tab.
    mnuTools.Clear; // Remove all current items.
    UserTool := TMenuItem.Create(Self);
    UserTool.Caption := 'Options...';
    UserTool.Hint := 'Options';
    UserTool.OnClick := mnuToolsOptionsClick;
    mnuTools.Add(UserTool); // Add back the "Options" menu.
    exit;
  end;
  if User.GECStatus then begin
    UserTool := TMenuItem.Create(self);
    UserTool.Caption := 'GEC Referral Status Display';
    UserTool.Hint := 'GEC Referral Status Display';
    UserTool.OnClick := mnuGECStatusClick;
    mnuTools.Add(UserTool); // Add back the "Options" menu.
    //exit;
  end;
  GetToolMenu; // For all other users, proceed normally with creation of Tools menu:
  for i := uToolMenuItems.Count-1 downto 0 do begin
    item := TToolMenuItem(uToolMenuItems[i]);
    if (AnsiCompareText(item.Caption, 'Event Capture Interface') = 0 ) and
       (not uECSReport.ECSPermit) then
    begin
      uToolMenuItems.Delete(i);
      Break;
    end;
  end;
  Menus := TStringList.Create;
  try
    count := 0;
    idx := 0;
    index := 0;
    while count < uToolMenuItems.Count do begin
      for I := 0 to uToolMenuItems.Count - 1 do begin
        item := TToolMenuItem(uToolMenuItems[i]);
        if assigned(item.MenuItem) then continue;
        if item.SubMenuID = '' then
          ok := True
        else begin
          idx := Menus.IndexOf(item.SubMenuID);
          ok := (idx >= 0);
        end;
        if ok then begin
          inc(count);
          UserTool := TMenuItem.Create(Self);
          UserTool.Caption := Item.Caption;
          if Item.Action <> '' then begin
            UserTool.Hint := Item.Action;
            UserTool.OnClick := ToolClick;
          end;
          Item.MenuItem := UserTool;
          if item.SubMenuID = '' then begin
            mnuTools.Insert(Index,UserTool);
            inc(Index);
          end else begin
            parent := TToolMenuItem(Menus.Objects[idx]);
            parent.MenuItem.Add(UserTool);
          end;
          if item.MenuID <> '' then
            Menus.AddObject(item.MenuID, item);
        end;
      end;
    end;
  finally
    Menus.Free;
  end;
  FreeAndNil(uToolMenuItems);
end;

procedure TfrmFrame.mnuTeamsClick(Sender: TObject);
// display Personal Lists Option
//kt added entire function
var value: integer;
begin
  inherited;
  value := 0;
  DialogOptionsLists(-1, -1, Font.Size, value);
end;

procedure TfrmFrame.mnuTMGTempClick(Sender: TObject);
//kt added.  KILL LATER.  
var  TMGTestHTML: TfrmTMGTestHTML;
begin
  inherited;
  TMGTestHTML := TfrmTMGTestHTML.Create(Self);
  TMGTestHTML.ShowModal;
  TMGTestHTML.Free;
end;

procedure TfrmFrame.UpdateECSParameter(var CmdParameter: string);  //ECS
var
  vstID,AccVer,Svr,SvrPort,VUser: string;
begin
  AccVer  := '';
  Svr     := '';
  SvrPort := '';
  VUser   := '';
  if RPCBrokerV <> nil then begin
    AccVer  := RPCBrokerV.AccessVerifyCodes;
    Svr     := RPCBrokerV.Server;
    SvrPort := IntToStr(RPCBrokerV.ListenerPort);
    VUser   := RPCBrokerV.User.DUZ;
  end;
  vstID := GetVisitID;
  CmdParameter :=' Svr=' +Svr
                 +' SvrPort='+SvrPort
                 +' VUser='+ VUser
                 +' PtIEN='+ Patient.DFN
                 +' PdIEN='+IntToStr(Encounter.Provider)
                 +' vstIEN='+vstID
                 +' locIEN='+IntToStr(Encounter.Location)
                 +' Date=0'
                 +' Division='+GetDivisionID;

end;

procedure TfrmFrame.compAccessTabPageCaptionQuery(Sender: TObject; var Text: string);
begin
  Text := GetTabText;
end;

function TfrmFrame.ValidECSUser: boolean;   //ECS
var
  isTrue: boolean;
begin
  Result := True;
  with RPCBrokerV do begin
    ShowErrorMsgs := semQuiet;
    Connected     := True;
   try
      isTrue := CreateContext(TX_ECSOPT);
      if not isTrue then
        Result := False;
      ShowErrorMsgs := semRaise;
    except
      on E: Exception do begin
        ShowErrorMsgs := semRaise;
        Result := False;
      end;
    end;
  end;
end;

procedure TfrmFrame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if bTimerOn then btnTimerResetClick(nil);  //tmg   11/2/20
  FClosing := TRUE;
  SetFormMonitoring(false);
  if FCreateProgress < FCP_FINISH then FTerminate := True;

  FlushNotifierBuffer;
  if FCreateProgress = FCP_FINISH then NotifyOtherApps(NAE_CLOSE, '');
  TerminateOtherAppNotification;

  if GraphFloat <> nil then begin
    if frmFrame.GraphFloatActive then
      GraphFloat.Close;
    GraphFloat.Release;
  end;

  // unhook the timeout hooks
  ShutDownTimeOut;
  // clearing changes will unlock notes
  if FCreateProgress = FCP_FINISH then Changes.Clear;
  // clear server side flag global tmp
  if FCreateProgress = FCP_FINISH then ClearFlag;
  // save user preferences
  if FCreateProgress = FCP_FINISH then SaveUserPreferences;
  // call close for each page in case there is any special processing
  if FCreateProgress > FCP_FORMS then begin
    mnuFrame.Merge(nil);
    frmCover.Close;      //frmCover.Release;
    frmProblems.Close;   //frmProblems.Release;
    frmMeds.Close;       //frmMeds.Release;
    frmOrders.Close;     //frmOrders.Release;
    frmNotes.Close;      //frmNotes.Release;
    frmConsults.Close;   //frmConsults.Release;
    frmDCSumm.Close;     //frmDCSumm.Release;
    if Assigned(frmSurgery) then frmSurgery.Close;    //frmSurgery.Release;
    frmLabs.Close;       //frmLabs.Release;
    frmReports.Close;    //frmReports.Release;
    frmGraphData.Close;  //frmGraphData.Release;
  end;
//  with mnuTools do for i := Count - 1 downto 0 do
//  begin
//    UserTool := Items[i];
//    if UserTool <> nil then
//    begin
//      Delete(i);
//      UserTool.Free;
//    end;
//  end;
  //Application.ProcessMessages;  // so everything finishes closing
  // if < FCP_FINISH we came here from inside FormCreate, so need to call terminate
  //if GraphFloat <> nil then GraphFloat.Release;
  if FCreateProgress < FCP_FINISH then Application.Terminate;
end;

procedure TfrmFrame.SetDebugMenu;
var
  IsProgrammer: Boolean;
begin
  IsProgrammer := User.HasKey('XUPROGMODE') or (ShowRPCList = True);
  mnuHelpBroker.Visible  := IsProgrammer;
  mnuHelpLists.Visible   := IsProgrammer;
  mnuHelpSymbols.Visible := IsProgrammer;
  Z6.Visible             := IsProgrammer;
end;

{ Updates posted to MainForm --------------------------------------------------------------- }

procedure TfrmFrame.UMNewOrder(var Message: TMessage);
{ post a notice of change in orders to all TPages, wParam=OrderAction, lParam=TOrder }
var
  OrderAct: string;
begin
  with Message do begin
    frmCover.NotifyOrder(WParam, TOrder(LParam));
    frmProblems.NotifyOrder(WParam, TOrder(LParam));
    frmMeds.NotifyOrder(WParam, TOrder(LParam));
    frmOrders.NotifyOrder(WParam, TOrder(LParam));
    frmNotes.NotifyOrder(WParam, TOrder(LParam));
    frmConsults.NotifyOrder(WParam, TOrder(LParam));
    frmDCSumm.NotifyOrder(WParam, TOrder(LParam));
    if Assigned(frmSurgery) then frmSurgery.NotifyOrder(WParam, TOrder(LParam));
    frmLabs.NotifyOrder(WParam, TOrder(LParam));
    frmReports.NotifyOrder(WParam, TOrder(LParam));
    lblPtCWAD.Caption := GetCWADInfo(Patient.DFN);
    if Length(lblPtCWAD.Caption) > 0
      then lblPtPostings.Caption := 'Postings'
    else lblPtPostings.Caption := 'No Postings';
    pnlPostings.Caption := lblPtPostings.Caption + ' ' + lblPtCWAD.Caption;
    OrderAct := '';
    case WParam of
      ORDER_NEW:   OrderAct := 'NW';
      ORDER_DC:    OrderAct := 'DC';
      ORDER_RENEW: OrderAct := 'RN';
      ORDER_HOLD:  OrderAct := 'HD';
      ORDER_EDIT:  OrderAct := 'XX';
      ORDER_ACT:   OrderAct := 'AC';
    end;
    if Length(OrderAct) > 0 then NotifyOtherApps(NAE_ORDER, OrderAct + U + TOrder(LParam).ID);  // add FillerID
  end;
end;

{ Tab Selection (navigate between pages) --------------------------------------------------- }

procedure TfrmFrame.WMSetFocus(var Message: TMessage);
var ALastPage : TfrmPage;
begin
  ALastPage := FLastPage[tpsLeft];
  if (ALastPage <> nil) and (not TimedOut) and
     (not (csDestroying in ALastPage.ComponentState)) and ALastPage.Visible
    then ALastPage.FocusFirstControl;
end;

procedure TfrmFrame.UMShowPage(var Message: TMessage);
{ shows a page when the UM_SHOWPAGE message is received }
begin
  if FCCOWDrivedChange then FCCOWDrivedChange := False;
  if FLastPage[tpsLeft] <> nil then FLastPage[tpsLeft].DisplayPage;
  FChangeSource := CC_CLICK;  // reset to click so we're only dealing with exceptions to click
  if assigned(FTabChanged) then
    FTabChanged(Self);
end;

procedure TfrmFrame.SwitchToPage(ASide: TTabPageSide; NewForm: TfrmPage);
{ unmerge/merge menus, bring page to top of z-order, call form-specific OnDisplay code }
var
  APnlPage : TPanel;
begin
  APnlPage := PnlPage[ASide];
  if FLastPage[ASide] = NewForm then begin
    if Notifications.Active and Assigned(NewForm) then PostMessage(Handle, UM_SHOWPAGE, 0, 0);
    Exit;
  end;
  if (FLastPage[ASide] <> nil) then begin
    mnuFrame.Unmerge(FLastPage[ASide].Menu);
    FLastPage[ASide].Hide;
  end;
  if Assigned(NewForm) then begin
    {if ((FLastPage = frmOrders) and (NewForm.Name <> frmMeds.Name))
      or ((FLastPage = frmMeds) and (NewForm.Name <> frmOrders.Name)) then
    begin
      if not CloseOrdering then
        Exit;
    end;}
    NewForm.Parent := APnlPage;  //kt-tabs.  This will set it to appear on right vs left side
    mnuFrame.Merge(NewForm.Menu);
    NewForm.Show;
  end;
  lstCIRNLocations.Visible := False;
  pnlCIRN.BevelOuter := bvRaised;
  lstCIRNLocations.SendToBack;
  mnuFilePrint.Enabled := False;           // let individual page enable this
  mnuFilePrintSetup.Enabled := False;      // let individual page enable this
  mnuFilePrintSelectedItems.Enabled := False;
  FLastPage[ASide] := NewForm;
  if NewForm <> nil then begin
    if NewForm.Name = frmNotes.Name then frmNotes.Align := alClient
      else frmNotes.Align := alNone;
    if NewForm.Name = frmConsults.Name then frmConsults.Align := alClient
      else frmConsults.Align := alNone;
    if NewForm.Name = frmReports.Name then frmReports.Align := alClient
      else frmReports.Align := alNone;
    if NewForm.Name = frmDCSumm.Name then frmDCSumm.Align := alClient
      else frmDCSumm.Align := alNone;
    if Assigned(frmSurgery) then
      if NewForm.Name = frmSurgery.Name then frmSurgery.Align := alclient
        else frmSurgery.Align := alNone;

    //kt 9/11 -- start addition
    if Assigned (frmImages) and (NewForm.Name = frmImages.Name) then begin
      frmImages.Align := alClient;
    end else begin
      frmImages.Align := alNone;
    end;
    //kt 9/11 -- end addition
    NewForm.BringToFront;                    // to cause tab switch to happen immediately
//CQ12232 NewForm.FocusFirstControl;
    Application.ProcessMessages;
    PostMessage(Handle, UM_SHOWPAGE, 0, 0);  // this calls DisplayPage for the form
  end;
end;

procedure TfrmFrame.mnuChangeESClick(Sender: TObject);
begin
  ChangeES;
end;

procedure TfrmFrame.mnuChartTabClick(Sender: TObject);
{ use the Tag property of the menu item to switch to proper page }
begin
 SelectChartTabL(TMenuItem(Sender).Tag);
end;

procedure TfrmFrame.SetTabOpenMode(Mode: TTabPageOpenMode; NoResize : boolean = false); //kt-tabs
const PCT_SIZE : array[tpoOpen .. tpoClosed] of integer = (40, 5); //RIGHT side will be this % of total form width based on mode
var LPct : real;
begin
  FTabPageOpenMode := Mode;
  LPct := (100-PCT_SIZE[Mode])/100;
  pnlMainL.Width := Floor(pnlMain.Width * LPct);
  if not NoResize then FormResize(self);
end;

procedure TfrmFrame.SelectChartTabL(PageID : integer);    //kt-tabs
begin
  SelectChartTab(tpsLeft, PageID);
end;

procedure TfrmFrame.SelectChartTab(PageID : integer);  //kt-tabs
begin
  SelectChartTab(tpsLeft, PageID);
end;

procedure TfrmFrame.SelectChartTabR(PageID : integer);
//kt-tabs
begin
  SelectChartTab(tpsRight, PageID);
end;

procedure TfrmFrame.SelectChartTab(ASide : TTabPageSide; PageID : integer);
//kt added 12/10/20, taken from mnuChartTabClick above
//kt NOTE PageID example:  CT_NOTES    =  6;  defined in uConst
var
  ATabPage : TTabControl;
begin
  ATabPage := FTabPage[ASide];
  ATabPage.TabIndex := PageIDToTab(PageID);
  LastTab[ASide] := TabIndexToPageID(ATabPage.TabIndex);
  //ALastTab := TabIndexToPageID(ATabPage.TabIndex) ;
  tabPageChange(ASide);
end;

function  TfrmFrame.GetLastTab(Index : TTabPageSide) : integer;   //kt-tabs
begin
  case index of
    tpsLeft  : Result := FLastTabL;
    tpsRight : Result := FLastTabR;
  end;
end;

procedure TfrmFrame.SetLastTab(Index : TTabPageSide; value : integer);  //kt-tabs
begin
  case index of
    tpsLeft  : FLastTabL := value;
    tpsRight : FLastTabR := value;
  end;
end;

function  TfrmFrame.GetNextTab(Index : TTabPageSide) : integer;   //kt-tabs
begin
  case index of
    tpsLeft : Result := FNextTabL;
    tpsRight : Result := FNextTabR;
  end;
end;

procedure TfrmFrame.SetNextTab(Index : TTabPageSide; value : integer);  //kt-tabs
begin
  case index of
    tpsLeft  : FNextTabL := value;
    tpsRight : FNextTabR := value;
  end;
end;

function  TfrmFrame.GetChangingTab(Index : TTabPageSide) : integer;  //kt-tabs
begin
  case index of
    tpsLeft  : Result := FChangingTabL;
    tpsRight : Result := FChangingTabR;
  end;
end;

procedure TfrmFrame.SetChangingTab(Index : TTabPageSide; value : integer);  //kt-tabs
begin
  case index of
    tpsLeft  : FChangingTabL := value;
    tpsRight : FChangingTabR := value;
  end;
end;

function TfrmFrame.OtherPageSide(ASide : TTabPageSide) : TTabPageSide;  //kt-tabs
begin
  case ASide of
    tpsLeft  : Result := tpsRight;
    tpsRight : Result := tpsLeft;
  end;
end;

function TfrmFrame.GetFLastPage(Index : TTabPageSide) : TFrmPage;      //kt-tabs
begin
  case index of
    tpsLeft  : Result := FLastPageL;
    tpsRight : Result := FLastPageR;
  end;
end;

procedure TfrmFrame.SetFLastPage(Index : TTabPageSide; value : TFrmPage);    //kt-tabs
begin
  case index of
    tpsLeft  : FLastPageL := value;
    tpsRight : FLastPageR := value;
  end;
end;

function TfrmFrame.TabPage(ASide : TTabPageSide = tpsLeft) : TTabControl;  //kt-tabs 6/10/21
begin
  Result := FTabPage[ASide];
end;


procedure TfrmFrame.tabPageRChange(Sender: TObject);      //kt-tabs
//kt-tabs
begin
  inherited;
  tabPageChange(tpsRight);
end;

procedure TfrmFrame.tabPageLChange(Sender: TObject);
//kt-tabs                                               //kt-tabs
begin
  inherited;
  tabPageChange(tpsLeft);
end;

procedure TfrmFrame.tabPagesChange(ASide: TTabPageSide);  //kt-tabs
{ switches to form linked to NewTab }
var
  PageID, OtherPageID : integer;
  ATabPage, OtherTabPage : TTabControl;
  OtherSide : TTabPageSide;

begin
  ATabPage := FTabPage[ASide];
  OtherSide := OtherPageSide(ASide);
  OtherTabPage := TabPage(OtherSide);
  PageID := TabIndexToPageID(ATabPage.TabIndex);
  OtherPageID := TabIndexToPageID(OtherTabPage.TabIndex);
  if (PageID = OtherPageID) and (PageID <> CT_NOPAGE) then begin   //kt-tabs
    OtherTabPage.TabIndex := -1;
    tabPageChange(OtherSide);
  end;
  if (PageID <> CT_NOPAGE) and (ATabPage.CanFocus) and Assigned(FLastPage[ASide]) and
     (not ATabPage.Focused) then begin
    try       //eRx  9/4/12   SetFocus caused as error if eRx alert was selected before the first patient
      ATabPage.SetFocus;  //CQ: 14854
    except
      //Do Nothing
    end;
  end;
  if (not User.IsReportsOnly) then begin
    case PageID of
      CT_NOPAGE:   SwitchToPage(Aside,nil);
      CT_COVER:    SwitchToPage(Aside,frmCover);
      CT_PROBLEMS: SwitchToPage(Aside,frmProblems);
      CT_MEDS:     SwitchToPage(Aside,frmMeds);
      CT_ORDERS:   SwitchToPage(Aside,frmOrders);
      CT_NOTES:    SwitchToPage(Aside,frmNotes);
      CT_CONSULTS: SwitchToPage(Aside,frmConsults);
      CT_DCSUMM:   SwitchToPage(Aside,frmDCSumm);
      CT_SURGERY:  SwitchToPage(Aside,frmSurgery);
      CT_LABS:     SwitchToPage(Aside,frmLabs);
      CT_REPORTS:  SwitchToPage(Aside,frmReports);
      CT_IMAGES:   SwitchToPage(Aside,frmImages);     //kt 9/11
      CT_MAILBOX:  SwitchToPage(Aside,frmMailbox);
      CT_WEBTAB1..CT_LAST_WEBTAB:  SwitchToPage(Aside,WebTabsList[PageID-CT_WEBTAB1]);  //kt 9/11
    end; {case}
  end else begin// Reports Only tab.
    SwitchToPage(Aside,frmReports);
  end;
  if ScreenReaderSystemActive and FCtrlTabUsed then
    SpeakPatient;
  ChangingTab[ASide] := PageID;
end;

procedure TfrmFrame.PatientImageClick(Sender: TObject);
//kt added 4/14/14
//Move to TfrmFrame
var frmPatientPhotoIDFull : TfrmPatientPhotoID;
var refresh : boolean;
begin
  inherited;
  //if assigned(frmPatientPhotoID) then FreeAndNil(frmPatientPhotoID);
  frmPatientPhotoIDFull:= TfrmPatientPhotoID.Create(Self);
  if FDragAndDropFName <> '' then begin
    Refresh :=  (frmPatientPhotoIDFull.ShowModalUploadFName(Patient.DFN, FDragAndDropFName) = mrOK);
    FDragAndDropFName := '';
  end else begin
    Refresh :=  (frmPatientPhotoIDFull.ShowModal(Patient.DFN,True) = mrOK)
  end;
  if refresh then begin
    PatientImage.Picture.Bitmap.Assign(frmPatientPhotoIDFull.MostRecentThumbBitmap);
  end;
  frmPatientPhotoIDFull.Free;
end;

procedure TfrmFrame.PatientImageMouseEnter(Sender: TObject);
var refresh : boolean;
begin
  inherited;
  try
    if not assigned(frmPatientPhotoID) then frmPatientPhotoID:= TfrmPatientPhotoID.Create(Self);
    frmPatientPhotoID.ShowPreviewMode(Patient.DFN,Self.PatientImage,ltRight);
  except
    //On E : exception do messagedlg('Error on Mouse Enter'+#13#10+E.Message,mtError,[mbok],0);
  end;
end;

procedure TfrmFrame.PatientImageMouseLeave(Sender: TObject);
begin
  inherited;
  try
    if assigned(frmPatientPhotoID) then frmPatientPhotoID.hide;
  except
    //On E : exception do messagedlg('Error on Mouse Leave'+#13#10+E.Message,mtError,[mbok],0);
  end;

end;

function TfrmFrame.PageIDToTab(PageID: Integer): Integer;
// returns the tab index that corresponds to a given PageID
// Example of PageID: CT_NOTES
VAR
  i: integer;
begin
  i :=  uTabList.IndexOf(IntToStr(PageID));
  Result := i;
  //Result := uTabList.IndexOf(IntToStr(PageID));
  (*
  Result := -1;
  case PageID of
    CT_NOPAGE:   Result := -1;
    CT_COVER:    Result :=  0;
    CT_PROBLEMS: Result :=  1;
    CT_MEDS:     Result :=  2;
    CT_ORDERS:   Result :=  3;
   {CT_HP:       Result :=  4;}
    CT_NOTES:    Result :=  4;
    CT_CONSULTS: Result :=  5;
    CT_DCSUMM:   Result :=  6;
    CT_LABS:     Result :=  7;
    CT_REPORTS:  Result :=  8;
  end;*)
end;


function TfrmFrame.TabIndexToPageID(Tab: Integer): Integer;
// returns the constant that identifies the page given a TabIndex
// Example of PageID: CT_NOTES

begin
  if (Tab > -1) and (Tab < uTabList.Count) then
    Result := StrToIntDef(uTabList[Tab], CT_UNKNOWN)
  else
    Result := CT_NOPAGE;
(*  case Tab of
   -1: Result := CT_NOPAGE;
    0: Result := CT_COVER;
    1: Result := CT_PROBLEMS;
    2: Result := CT_MEDS;
    3: Result := CT_ORDERS;
   {4: Result := CT_HP;}
    4: Result := CT_NOTES;
    5: Result := CT_CONSULTS;
    6: Result := CT_DCSUMM;
    7: Result := CT_LABS;
    8: Result := CT_REPORTS;
  end;*)
end;



procedure TfrmFrame.timCheckSequelTimer(Sender: TObject);
begin
  inherited;
  timCheckSequel.Enabled := false;
  CurSequelPat := TCurrentSequelPat.Create();
  if (CurSequelPat.New) and (CurSequelPat.DFN<>Patient.DFN) then begin
    if messagedlg('Would you like to open '+CurSequelPat.Name+'''s chart?',mtConfirmation,[mbYes,mbNo],0)=mrYes then begin
      Showmsg('Changing to DFN '+CurSequelPat.DFN);
    end;
  end;
  CurSequelPat.Free;
  timCheckSequel.Enabled := true;
end;

{ File Menu Events ------------------------------------------------------------------------- }

procedure TfrmFrame.SetupPatient(AFlaggedList : TStringList);
var
  AMsg, SelectMsg: string;
begin
  with Patient do begin
    ClearPatient;  // must be called to avoid leaving previous patient's information visible!
    btnCombatVet.Caption := 'CV '+ CombatVet.ExpirationDate;
    btnCombatVet.Visible := Patient.CombatVet.IsEligible;
    Visible := True;
    Application.ProcessMessages;
    if AtFPGLoc then begin  //kt 10/15 remove status from display when at FPG site.
      lblPtName.Caption := Name;
    end else begin
      lblPtName.Caption := Name + Status; //CQ #17491: Allow for the display of the patient status indicator in header bar.
    end;
    //agp //kt prior --> lblPtSSN.Caption := SSN;
    //agp WV BEGIN CHANGE  //kt
    if hidePtSSN = true then lblPtSSN.Caption := '**HIDDEN**'
    else lblPtSSN.Caption := SSN;
    //agp WV END CHANGE  //kt

    //WV Change to patient age
    //WV age includes months for minors  ->    lblPtAge.Caption := FormatFMDateTime('mmm dd,yyyy', DOB) + ' (' + GetPatientBriefAge(Patient.DFN) + ')';
    lblPtAge.Caption := FormatFMDateTime('mmm dd,yyyy', DOB) + ' (' + IntToStr(Age) + ')';
    //WV End Change to patient age
    pnlPatient.Caption := lblPtName.Caption + ' ' + lblPtSSN.Caption + ' ' + lblPtAge.Caption;
    if Length(CWAD) > 0
      then lblPtPostings.Caption := 'Postings'
      else lblPtPostings.Caption := 'No Postings';
    lblPtCWAD.Caption := CWAD;
    pnlPostings.Caption := lblPtPostings.Caption + ' ' + lblPtCWAD.Caption;
    if (Length(PrimaryTeam) > 0) or (Length(PrimaryProvider) > 0) then begin
      lblPtCare.Caption := PrimaryTeam + ' / ' + MixedCase(PrimaryProvider);
      if Length(Associate)>0 then lblPtCare.Caption :=  lblPtCare.Caption + ' / ' + MixedCase(Associate);
    end;
    if Length(Attending) > 0 then lblPtAttending.Caption := '(Inpatient) Attending:  ' + MixedCase(Attending);
    pnlPrimaryCare.Caption := lblPtCare.Caption + ' ' + lblPtAttending.Caption;
      pnlPrimaryCare.Caption := 'TEST HERE';
    if Length(InProvider) > 0  then lblPtAttending.Caption := lblPtAttending.Caption + ' - (Inpatient) Provider: ' + MixedCase(InProvider);
    if Length(MHTC) > 0 then lblPtMHTC.Caption := 'MH Treatment Coordinator: ' + MixedCase(MHTC);
    if (Length(MHTC) = 0) and (Inpatient = True) and (SpecialtySvc = 'P') then
      lblPtMHTC.Caption := 'MH Treatment Coordinator Unassigned';
    pnlPrimaryCare.Caption := lblPtCare.Caption + ' ' + lblPtAttending.Caption + ' ' + lblPtMHTC.Caption;
    SetUpCIRN;
    DisplayEncounterText;
    SetShareNode(DFN, Handle);
    with Patient do
      NotifyOtherApps(NAE_NEWPT, SSN + U + FloatToStr(DOB) + U + Name);
    SelectMsg := '';
    if MeansTestRequired(Patient.DFN, AMsg) then SelectMsg := AMsg;
    if HasLegacyData(Patient.DFN, AMsg)     then SelectMsg := SelectMsg + CRLF + AMsg;

    HasActiveFlg(FlagList, HasFlag, Patient.DFN);
    if HasFlag then begin
      pnlFlag.Enabled := True;
      lblFlag.Font.Color := Get508CompliantColor(clMaroon);
      lblFlag.Enabled := True;
      if (not FReFreshing) and (TriggerPRFPopUp(Patient.DFN)) then
        ShowFlags;
    end else begin
      pnlFlag.Enabled := False;
      lblFlag.Font.Color := clBtnFace;
      lblFlag.Enabled := False;
    end;
    FPrevPtID := patient.DFN;
    frmCover.UpdateVAAButton; //VAA CQ7525  (moved here in v26.30 (RV))
    ProcessPatientChangeEventHook;
    if Length(SelectMsg) > 0 then ShowPatientSelectMessages(SelectMsg);
    LoadMostRecentPhotoIDThumbNail(Patient.DFN,PatientImage.Picture.Bitmap);  //kt  4/15/14
    pnlPatient.Color := DueColorCode;  //kt 10/23/14
    pnlPatient.Font.Color := DueColorCode;  //kt 10/23/14
  end;
end;

procedure TfrmFrame.mnuFileNextClick(Sender: TObject);
var
  SaveDFN, NewDFN: string; // *DFN*
  NextIndex: Integer;
  Reason: string;
  CCOWResponse: UserResponse;
  AccessStatus: integer;

  procedure UpdatePatientInfoForAlert;
  begin
    if Patient.Inpatient then begin
      Encounter.Inpatient := True;
      Encounter.Location := Patient.Location;
      Encounter.DateTime := Patient.AdmitTime;
      Encounter.VisitCategory := 'H';
    end;
    //if User.IsProvider then Encounter.Provider := User.DUZ;  //TMG commented out for code below  11/1/18
    Encounter.Provider := strtoint(sCallV('TMG CPRS GET CURRENT PROVIDER',[Patient.DFN,inttostr(User.DUZ)]));
    SetupPatient(FlaggedPTList);
    if (FlaggedPTList.IndexOf(Patient.DFN) < 0) then
      FlaggedPTList.Add(Patient.DFN);
  end;

begin
  DoNotChangeEncWindow := False;
  OrderPrintForm := False;
  mnuFile.Tag := 0;
  SaveDFN := Patient.DFN;
  Notifications.Next;
  if Notifications.Active then begin
    NewDFN := Notifications.DFN;
    //Patient.DFN := Notifications.DFN;
    //if SaveDFN <> Patient.DFN then
    if SaveDFN <> NewDFN then begin
      // newdfn does not have new patient.co information for CCOW call
      if ((Sender = mnuFileOpen) or (AllowContextChangeAll(Reason)))
          and AllowAccessToSensitivePatient(NewDFN, AccessStatus) then
      begin
        RemindersStarted := FALSE;
        Patient.DFN := NewDFN;
        Encounter.Clear;
        Changes.Clear;
        if Assigned(FlagList) then begin
         FlagList.Clear;
         HasFlag := False;
         HasActiveFlg(FlagList, HasFlag, NewDFN);
        end;
        if FCCOWInstalled and (ctxContextor.State = csParticipating) then begin
          if (AllowCCOWContextChange(CCOWResponse, Patient.DFN)) then
            UpdatePatientInfoForAlert
          else begin
            case CCOWResponse of
              urCancel: begin
                Patient.DFN := SaveDFN;
                Notifications.Prior;
                Exit;
              end;
              urBreak: begin
                // do not revert to old DFN if context was manually broken by user - v26 (RV)
                if (ctxContextor.State = csParticipating) then Patient.DFN := SaveDFN;
                UpdatePatientInfoForAlert;
              end;
              else
                UpdatePatientInfoForAlert;
            end; //case
          end;
        end else
          UpdatePatientInfoForAlert
      end else begin
        if AccessStatus in [DGSR_ASK, DGSR_DENY] then begin
          Notifications.Clear;
          // hide the 'next notification' button
          FNextButtonActive := False;
          FNextButton.Free;
          FNextButton := nil;
          mnuFileNext.Enabled := False;
          mnuFileNotifRemove.Enabled := False;
          Patient.DFN := '';
          mnuFileOpenClick(mnuFileNext);
          exit;
        end else if SaveDFN <> '' then begin
          Patient.DFN := SaveDFN;
          Notifications.Prior;
          Exit;
        end else begin
          Notifications.Clear;
(*          // hide the 'next notification' button
          FNextButtonActive := False;
          FNextButton.Free;
          FNextButton := nil;
          mnuFileNext.Enabled := False;
          mnuFileNotifRemove.Enabled := False;*)
          Patient.DFN := '';
          mnuFileOpenClick(mnuFileNext);
          exit;
        end;
      end;
    end;
    stsArea.Panels.Items[1].Text := Notifications.Text;
    FChangeSource := CC_NOTIFICATION;
    NextIndex := PageIDToTab(CT_COVER);
    TabPage(tpsLeft).TabIndex := CT_NOPAGE;
    tabPageChange(tpsLeft);
    mnuFileNotifRemove.Enabled := Notifications.Followup in [NF_FLAGGED_ORDERS,
                                                             NF_ORDER_REQUIRES_ELEC_SIGNATURE,
                                                             NF_MEDICATIONS_EXPIRING_INPT,
                                                             NF_MEDICATIONS_EXPIRING_OUTPT,
                                                             NF_UNVERIFIED_MEDICATION_ORDER,
                                                             NF_UNVERIFIED_ORDER,
                                                             NF_FLAGGED_OI_EXP_INPT,
                                                             NF_FLAGGED_OI_EXP_OUTPT];
    case Notifications.FollowUp of
      NF_LAB_RESULTS                   : NextIndex := PageIDToTab(CT_LABS);
      NF_FLAGGED_ORDERS                : NextIndex := PageIDToTab(CT_ORDERS);
      NF_ORDER_REQUIRES_ELEC_SIGNATURE : NextIndex := PageIDToTab(CT_ORDERS);
      NF_ABNORMAL_LAB_RESULTS          : NextIndex := PageIDToTab(CT_LABS);
      NF_IMAGING_RESULTS               : NextIndex := PageIDToTab(CT_REPORTS);
      NF_CONSULT_REQUEST_RESOLUTION    : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_ABNORMAL_IMAGING_RESULTS      : NextIndex := PageIDToTab(CT_REPORTS);
      NF_IMAGING_REQUEST_CANCEL_HELD   : NextIndex := PageIDToTab(CT_ORDERS);
      NF_NEW_SERVICE_CONSULT_REQUEST   : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_CONSULT_REQUEST_CANCEL_HOLD   : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_SITE_FLAGGED_RESULTS          : NextIndex := PageIDToTab(CT_ORDERS);
      NF_ORDERER_FLAGGED_RESULTS       : NextIndex := PageIDToTab(CT_ORDERS);
      NF_ORDER_REQUIRES_COSIGNATURE    : NextIndex := PageIDToTab(CT_ORDERS);
      NF_LAB_ORDER_CANCELED            : NextIndex := PageIDToTab(CT_ORDERS);
      NF_STAT_RESULTS                  :
        if Piece(Piece(Notifications.AlertData, '|', 2), '@', 2) = 'LRCH' then
          NextIndex := PageIDToTab(CT_LABS)
        else if Piece(Piece(Notifications.AlertData, '|', 2), '@', 2) = 'GMRC' then
          NextIndex := PageIDToTab(CT_CONSULTS)
        else if Piece(Piece(Notifications.AlertData, '|', 2), '@', 2) = 'RA' then
          NextIndex := PageIDToTab(CT_REPORTS);
      NF_DNR_EXPIRING                  : NextIndex := PageIDToTab(CT_ORDERS);
      NF_MEDICATIONS_EXPIRING_INPT     : NextIndex := PageIDToTab(CT_ORDERS);
      NF_MEDICATIONS_EXPIRING_OUTPT    : NextIndex := PageIDToTab(CT_ORDERS);
      NF_UNVERIFIED_MEDICATION_ORDER   : NextIndex := PageIDToTab(CT_ORDERS);
      NF_NEW_ORDER                     : NextIndex := PageIDToTab(CT_ORDERS);
      NF_IMAGING_RESULTS_AMENDED       : NextIndex := PageIDToTab(CT_REPORTS);
      NF_CRITICAL_LAB_RESULTS          : NextIndex := PageIDToTab(CT_LABS);
      NF_UNVERIFIED_ORDER              : NextIndex := PageIDToTab(CT_ORDERS);
      NF_FLAGGED_OI_RESULTS            : NextIndex := PageIDToTab(CT_ORDERS);
      NF_FLAGGED_OI_ORDER              : NextIndex := PageIDToTab(CT_ORDERS);
      NF_DC_ORDER                      : NextIndex := PageIDToTab(CT_ORDERS);
      NF_DEA_AUTO_DC_CS_MED_ORDER      : NextIndex := PageIDToTab(CT_ORDERS);
      NF_DEA_CERT_REVOKED              : NextIndex := PageIDToTab(CT_ORDERS);
      NF_CONSULT_UNSIGNED_NOTE         : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_DCSUMM_UNSIGNED_NOTE          : NextIndex := PageIDToTab(CT_DCSUMM);
      NF_NOTES_UNSIGNED_NOTE           : NextIndex := PageIDToTab(CT_NOTES);
      NF_MAILBOX                       : NextIndex := PageIDToTab(CT_MAILBOX);  //TMG  8/26/19
      NF_CONSULT_REQUEST_UPDATED       : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_FLAGGED_OI_EXP_INPT           : NextIndex := PageIDToTab(CT_ORDERS);
      NF_FLAGGED_OI_EXP_OUTPT          : NextIndex := PageIDToTab(CT_ORDERS);
      NF_CONSULT_PROC_INTERPRETATION   : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_IMAGING_REQUEST_CHANGED       :
          begin
             ReportBox(GetNotificationFollowUpText(Patient.DFN, Notifications.FollowUp, Notifications.AlertData), Pieces(Piece(Notifications.RecordID, U, 1), ':', 2, 3), True);
             Notifications.Delete;
          end;
      NF_LAB_THRESHOLD_EXCEEDED        : NextIndex := PageIDToTab(CT_LABS);
      NF_MAMMOGRAM_RESULTS             : NextIndex := PageIDToTab(CT_REPORTS);
      NF_PAP_SMEAR_RESULTS             : NextIndex := PageIDToTab(CT_REPORTS);
      NF_ANATOMIC_PATHOLOGY_RESULTS    : NextIndex := PageIDToTab(CT_REPORTS);
      NF_SURGERY_UNSIGNED_NOTE         : if TabExists(CT_SURGERY) then
                                           NextIndex := PageIDToTab(CT_SURGERY)
                                         else
                                           InfoBox(TX_NO_SURG_NOTIF, TC_NO_SURG_NOTIF, MB_OK);
                                           //NextIndex := PageIDToTab(CT_NOTES);
      //eRx  9/4/12      begin
      NF_ERX_REFILL_NEEDED             : begin
                                           NextIndex := PageIDToTab(CT_MEDS);
                                           CallERx(ERX_ACTION_ALERT);
                                           Notifications.Delete;
                                         end;
      NF_ERX_INCOMPLETE_ORDER          : begin
                                           NextIndex := PageIDToTab(CT_MEDS);
                                           CallERx(ERX_ACTION_ORDER);
                                           Notifications.Delete;
                                         end;
      //eRx  9/4/12      end
      else InfoBox(TX_UNK_NOTIF, TC_UNK_NOTIF, MB_OK);
    end;  //case
    TabPage(tpsLeft).TabIndex := NextIndex;
    TabPageChange(tpsLeft);
  end else mnuFileOpenClick(mnuFileNext);
end;

procedure TfrmFrame.SetBADxList;
var
  i: smallint;
begin
  if not Assigned(UBAGlobals.tempDxList) then begin
    UBAGlobals.tempDxList := TList.Create;
    UBAGlobals.tempDxList.Count := 0;
    Application.ProcessMessages;
  end else begin
    //Kill the old Dx list
    for i := 0 to pred(UBAGlobals.tempDxList.Count) do
      TObject(UBAGlobals.tempDxList[i]).Free;

    UBAGlobals.tempDxList.Clear;
    Application.ProcessMessages;

    //Create new Dx list for newly selected patient
    if not Assigned(UBAGlobals.tempDxList) then begin
      UBAGlobals.tempDxList := TList.Create;
      UBAGlobals.tempDxList.Count := 0;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TfrmFrame.mnuFileOpenClick(Sender: TObject);
{ select a new patient & update the header displays (patient id, encounter, postings) }
var
  SaveDFN, Reason: string;
  //NextTab: Integer;     // moved up for visibility - v23.4  rV
  ok, OldRemindersStarted, PtSelCancelled: boolean;
  //i: smallint;
  CCOWResponse: UserResponse;
  tempTabPage : TTabControl;

begin
  tempTabPage := TabPage(tpsLeft);
  pnlPatient.Enabled := false;
  if (Sender = mnuFileOpen) or (FRefreshing) then PTSwitchRefresh := True
  else PTSwitchRefresh := False;  //part of a change to CQ #11529
  PtSelCancelled := FALSE;
  if not FRefreshing then mnuFile.Tag := 0 else mnuFile.Tag := 1;
  DetermineNextTab(tpsLeft);
(*  if (FRefreshing or User.UseLastTab) and (not FFirstLoad) then
    NextTab := TabIndexToPageID(tabPage.TabIndex)
  else
    NextTab := User.InitialTab;
  if NextTab = CT_NOPAGE then NextTab := User.InitialTab;
  if User.IsReportsOnly then // Reports Only tab.
    NextTab := 0; // Only one tab should exist by this point in "REPORTS ONLY" mode.
  if not TabExists(NextTab) then NextTab := CT_COVER;
  if NextTab = CT_NOPAGE then NextTab := User.InitialTab;
  if NextTab = CT_ORDERS then
    if frmOrders <> nil then with frmOrders do
    begin
      if (lstSheets.ItemIndex > -1 ) and (TheCurrentView <> nil) and (theCurrentView.EventDelay.PtEventIFN>0) then
        PtEvtCompleted(TheCurrentView.EventDelay.PtEventIFN, TheCurrentView.EventDelay.EventName);
    end;*)
  //if Sender <> mnuFileNext then        //CQ 16273 & 16419 - Missing Review/Sign Changes dialog when clicking 'Next' button.
  if not AllowContextChangeAll(Reason) then begin
    pnlPatient.Enabled := True;
    Exit;
  end;
  // update status text here
  stsArea.Panels.Items[1].Text := '';
  if (not User.IsReportsOnly) then begin
    if not FRefreshing then begin
      Notifications.Next;   // avoid prompt if no more alerts selected to process  {v14a RV}
      if Notifications.Active then begin
        if (InfoBox(TX_NOTIF_STOP, TC_NOTIF_STOP, MB_YESNO) = ID_NO) then begin
          Notifications.Prior;
          pnlPatient.Enabled := True;
          Exit;
        end;
      end;
      if Notifications.Active then Notifications.Prior;
    end;
  end;

  if FNoPatientSelected then
    SaveDFN := ''
  else
    SaveDFN := Patient.DFN;

  if bTimerOn then btnTimerResetClick(nil);    //10/29/20

  OldRemindersStarted := RemindersStarted;
  RemindersStarted := FALSE;
  try
    if FRefreshing then begin
      UpdatePtInfoOnRefresh;
      ok := TRUE;
    end else begin
      ok := FALSE;
      if (not User.IsReportsOnly) then begin
        if FCCOWInstalled and (ctxContextor.State = csParticipating) then begin
          UpdateCCOWContext;
          if not FCCOWError then begin
            FCCOWIconName := 'BMP_CCOW_LINKED';
            pnlCCOW.Hint := TX_CCOW_LINKED;
            imgCCOW.Picture.Bitmap.LoadFromResourceName(hInstance, FCCOWIconName);
          end;
        end else begin
          FCCOWIconName := 'BMP_CCOW_BROKEN';
          pnlCCOW.Hint := TX_CCOW_BROKEN;
          imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
        end;
        if (Patient.DFN = '') or (Sender = mnuFileOpen) or (Sender = mnuFileNext) or (Sender = mnuViewDemo) then
          SelectPatient(SHOW_NOTIFICATIONS, Font.Size, PtSelCancelled);
        //kt original --> if PtSelCancelled then exit;
        if PtSelCancelled then begin
          //This was causing CPRS to crash. Commented out for the time being. -> If (Patient.DFN <> '') then NotifyContextChangeCancelledAll;  //kt added
         // begin
            //pnlPatient.Enabled := True;
            exit;
        end;
        ShowEverything;
        //HideEverything('Retrieving information - please wait....');  //v27 (pending) RV
        DisplayEncounterText;
        FPrevInPatient := Patient.Inpatient;
        if Notifications.Active then begin
          // display 'next notification' button
          SetUpNextButton;
          FNextButtonActive := True;
          mnuFileNext.Enabled := True;
          mnuFileNextClick(mnuFileOpen);
        end else begin
          // hide the 'next notification' button
          FNextButtonActive := False;
          FNextButton.Free;
          FNextButton := nil;
          mnuFileNext.Enabled := False;
          mnuFileNotifRemove.Enabled := False;
          if Patient.DFN <> SaveDFN then
            ok := TRUE;
        end
      end else begin
        Notifications.Clear;
        SelectPatient(False, Font.Size, PtSelCancelled); // Call Pt. Sel. w/o notifications.
        if PtSelCancelled then exit;
        ShowEverything;
        DisplayEncounterText;
        FPrevInPatient := Patient.Inpatient;
        ok := TRUE;
      end;
    end;
    if ok then begin
      if FCCOWInstalled and (ctxContextor.State = csParticipating) and (not FRefreshing) then begin
        if (AllowCCOWContextChange(CCOWResponse, Patient.DFN)) then begin
          SetupPatient;
          tempTabPage.TabIndex := PageIDToTab(NextTab[tpsLeft]);
          tabPageChange(tpsLeft);
        end else begin
          case CCOWResponse of
            urCancel: UpdateCCOWContext;
            urBreak: begin
                       // do not revert to old DFN if context was manually broken by user - v26 (RV)
                       if (ctxContextor.State = csParticipating) then Patient.DFN := SaveDFN;
                       SetupPatient;
                       tempTabPage.TabIndex := PageIDToTab(NextTab[tpsLeft]);
                       tabPageChange(tpsLeft);
                     end;
            else     begin
                       SetupPatient;
                       tempTabPage.TabIndex := PageIDToTab(NextTab[tpsLeft]);
                       tabPageChange(tpsLeft);
                     end;
          end; //case
        end;
      end else begin
        SetupPatient;
        tempTabPage.TabIndex := PageIDToTab(NextTab[tpsLeft]);
        tabPageChange(tpsLeft);
      end;
    end;
  finally
    if (not FRefreshing) and (Patient.DFN = SaveDFN) then
      RemindersStarted := OldRemindersStarted;
    FFirstLoad := False;
  end;
 {Begin BillingAware}
  if  BILLING_AWARE then frmFrame.SetBADxList; //end IsBillingAware
 {End BillingAware}
 //ShowEverything;  //v27 (pending) RV
 if not FRefreshing then begin
    DoNotChangeEncWindow := false;
    OrderPrintForm := false;
    uCore.TempEncounterLoc := 0;
    uCore.TempEncounterLocName := '';
 end;
 pnlPatient.Enabled := True;
 //frmCover.UpdateVAAButton; //VAA CQ7525   CQ#7933 - moved to SetupPatient, before event hook execution (RV)

 //kt  BEGIN MOD 11/1/13 ---------------------------------------------------------
 frmOrders.TMGLoadColors;   //12/14/17
 frmImages.HandlePatientChanged();  //11/29/20
 CheckForOpenEvent('',0);   //TMG  11/2/20
 if uTMGOptions.ReadBool('CPRS TIMER PROMPT',False)=True then begin    //TMG  11/2/20
   if messagedlg('Would you like to start the chart timer?',mtConfirmation,[mbYes,mbNo],0)=mrYes then begin    //TMG  11/2/20
     btnTimerClick(nil);       //TMG  11/2/20
   end;
 end;
 if fSearchResults.TMGSearchResultsLastSelectedTIUIEN <> '' then begin
   SwitchToPage(tpsLeft, frmNotes);
   Application.ProcessMessages;
   frmNotes.ChangeToNote(fSearchResults.TMGSearchResultsLastSelectedTIUIEN);
 end;
 //kt  END MOD 11/1/13 -----------------------------------------------------------
end;

procedure TfrmFrame.DetermineNextTab(ASide: TTabPageSide);
var
  tempTabPage : TTabControl;

begin
  tempTabPage := FTabPage[ASide];
  if (FRefreshing or User.UseLastTab) and (not FFirstLoad) then begin
    if (tempTabPage.TabIndex < 0) then begin
      NextTab[ASide] := LastTab[ASide];
    end else begin
      NextTab[ASide] := TabIndexToPageID(tempTabPage.TabIndex);
    end;
  end else begin
    NextTab[ASide] := User.InitialTab;
  end;
  if NextTab[ASide] = CT_NOPAGE then NextTab[ASide] := User.InitialTab;
  if User.IsReportsOnly then // Reports Only tab.
    NextTab[ASide] := CT_REPORTS; // Only one tab should exist by this point in "REPORTS ONLY" mode.
  if not TabExists(NextTab[ASide]) then NextTab[ASide] := CT_COVER;
  if NextTab[ASide] = CT_NOPAGE then NextTab[ASide] := User.InitialTab;
  if NextTab[ASide] = CT_ORDERS then begin
    if frmOrders <> nil then with frmOrders do begin
      if (lstSheets.ItemIndex > -1 ) and (TheCurrentView <> nil) and (theCurrentView.EventDelay.PtEventIFN>0) then begin
        PtEvtCompleted(TheCurrentView.EventDelay.PtEventIFN, TheCurrentView.EventDelay.EventName);
      end;
    end;
  end;
end;

procedure TfrmFrame.mnuFileEncounterClick(Sender: TObject);
{ displays encounter window and updates encounter display in case encounter was updated }
begin
  UpdateEncounter(NPF_ALL); {*KCM*}
  DisplayEncounterText;
end;

procedure TfrmFrame.mnuFileReviewClick(Sender: TObject);
{ displays the Review Changes window (which resets the Encounter object) }
var
  EventChanges: boolean;
  NameNeedLook: string;
  tempTabPage : TTabControl;

begin
  tempTabPage := FTabPage[tpsLeft];
  FReviewClick := True;
  mnuFile.Tag := 1;
  EventChanges := False;
  NameNeedLook := '';
  //UpdatePtInfoOnRefresh;
  if Changes.Count > 0 then begin
    if (frmOrders <> nil) and (frmOrders.TheCurrentView <> nil) and ( frmOrders.TheCurrentView.EventDelay.EventIFN>0) then begin
      EventChanges := True;
      NameNeedLook := frmOrders.TheCurrentView.ViewName;
      frmOrders.PtEvtCompleted(frmOrders.TheCurrentView.EventDelay.PtEventIFN, frmOrders.TheCurrentView.EventDelay.EventName);
    end;
    ReviewChanges(TimedOut, EventChanges);
    if TabIndexToPageID(tempTabPage.TabIndex)= CT_MEDS then begin
      frmOrders.InitOrderSheets2(NameNeedLook);
    end;
  end else InfoBox('No new changes to review/sign.', 'Review Changes', MB_OK);
  //CQ #17491: Moved UpdatePtInfoOnRefresh here to allow for the updating of the patient status indicator
  //in the header bar (after the Review Changes dialog closes) if the patient becomes admitted/discharged.
  UpdatePtInfoOnRefresh;
  FOrderPrintForm := false;
  FReviewClick := false;
end;

procedure TfrmFrame.mnuFileExitClick(Sender: TObject);
{ see the CloseQuery event }
var
  i: smallint;
begin
  try
    if BILLING_AWARE then begin
      if Assigned(tempDxList) then begin
         for i := 0 to pred(UBAGlobals.tempDxList.Count) do begin
            TObject(UBAGlobals.tempDxList[i]).Free;
         end;
      end;
      UBAGlobals.tempDxList.Clear;
      Application.ProcessMessages;
    end; //end IsBillingAware
  except
    on EAccessViolation do begin
      {$ifdef debug}Show508Message('Access Violation in procedure TfrmFrame.mnuFileExitClick()');{$endif}
      raise;
    end;
    on E: Exception do begin
      {$ifdef debug}Show508Message('Unhandled exception in procedure TfrmFrame.mnuFileExitClick()');{$endif}
      raise;
    end;
  end;
  Close;
end;

{ View Menu Events ------------------------------------------------------------------------- }

procedure TfrmFrame.mnuViewPostingsClick(Sender: TObject);
begin
end;

{ Tool Menu Events ------------------------------------------------------------------------- }


function TfrmFrame.ExpandCommand(x: string): string;
{ look for 'macros' on the command line and expand them using current context }

  procedure Substitute(const Key, Data: string);
  var
    Stop, Start: Integer;
  begin
    Stop  := Pos(Key, x) - 1;
    Start := Stop + Length(Key) + 1;
    x := Copy(x, 1, Stop) + Data + Copy(x, Start, Length(x));
  end;

begin
  if Pos('%MREF', x) > 0 then Substitute('%MREF', '^TMP(''ORWCHART'',' + MScalar('$J') + ',''' + DottedIPStr + ''',' + IntToHex(Handle, 8) + ')');
  if Pos('%SRV',  x) > 0 then Substitute('%SRV',  RPCBrokerV.Server);
  if Pos('%PORT', x) > 0 then Substitute('%PORT', IntToStr(RPCBrokerV.ListenerPort));
  if Pos('%DFN',  x) > 0 then Substitute('%DFN',  Patient.DFN);  //*DFN*
  if Pos('%DUZ',  x) > 0 then Substitute('%DUZ',  IntToStr(User.DUZ));
  Result := x;
end;

procedure TfrmFrame.ToolClick(Sender: TObject);
{ executes the program associated with an item on the Tools menu, the command line is stored
  in the item's hint property }
const
  TXT_ECS_NOTFOUND = 'The ECS application is not found at the default directory,' + #13 + 'would you like manually search it?';
  TC_ECS_NOTFOUND = 'Application Not Found';
var
  x, AFile, Param, MenuCommand, ECSAppend, CapNm, curPath : string;
  IsECSInterface: boolean;

  function TakeOutAmps(AString: string): string;
  var
    S1,S2: string;
  begin
    if Pos('&',AString)=0 then begin
      Result := AString;
      Exit;
    end;
    S1 := Piece(AString,'&',1);
    S2 := Piece(AString,'&',2);
    Result := S1 + S2;
  end;

  function ExcuteEC(AFile,APara: string): boolean;
  begin
    if (ShellExecute(Handle, 'open', PChar(AFile), PChar(Param), '', SW_NORMAL) > 32 ) then begin
      Result := True
    end else begin
      if InfoBox(TXT_ECS_NOTFOUND, TC_ECS_NOTFOUND, MB_YESNO or MB_ICONERROR) = IDYES then begin
        if OROpenDlg.Execute then begin
          AFile := OROpenDlg.FileName;
          if Pos('ecs gui.exe',lowerCase(AFile))<1 then begin
            ShowMsg('This is not a valid ECS application.');
            Result := True;
          end else begin
            if (ShellExecute(Handle, 'open', PChar(AFile), PChar(Param), '', SW_NORMAL)<32) then begin
              Result := False
            end else Result := True;
          end;
        end else Result := True;
      end else Result := True;
    end;
  end;

  function ExcuteECS(AFile, APara: string; var currPath: string): boolean;
  var
    commandline,RPCHandle: string;
    StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
  begin
    FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
    with StartupInfo do begin
      cb := SizeOf(TStartupInfo);
      dwFlags := STARTF_USESHOWWINDOW;
      wShowWindow := SW_SHOWNORMAL;
    end;
    commandline := AFile + Param;
    RPCHandle := GetAppHandle(RPCBrokerV);
    commandline := commandline + ' H=' + RPCHandle;
    if CreateProcess(nil, PChar(commandline), nil, nil, False,
                     NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then begin
        Result := True
    end else begin
      if InfoBox(TXT_ECS_NOTFOUND, TC_ECS_NOTFOUND, MB_YESNO or MB_ICONERROR) = IDYES then begin
        if OROpenDlg.Execute then begin
          AFile := OROpenDlg.FileName;
          if Pos('ecs gui.exe',lowerCase(AFile))<1 then begin
            ShowMsg('This is not a valid ECS application.');
            Result := True;
          end else begin
            SaveUserPath('Event Capture Interface='+AFile, currPath);
            FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
            with StartupInfo do begin
              cb := SizeOf(TStartupInfo);
              dwFlags := STARTF_USESHOWWINDOW;
              wShowWindow := SW_SHOWNORMAL;
            end;
            commandline := AFile + Param;
            RPCHandle := GetAppHandle(RPCBrokerV);
            commandline := commandline + ' H=' + RPCHandle;
            if not CreateProcess(nil, PChar(commandline), nil, nil, False,
                                 NORMAL_PRIORITY_CLASS, nil, nil,StartupInfo,ProcessInfo) then begin
              Result := False
            end else Result := True;
          end;
        end else Result := True;
      end else Result := True;
    end;
  end;

begin
  MenuCommand := '';
  ECSAppend   := '';
  IsECSInterface := False;
  curPath := '';
  CapNm := LowerCase(TMenuItem(Sender).Caption);
  CapNm := TakeOutAmps(CapNm);
  if AnsiCompareText('event capture interface',CapNm)=0 then begin
    IsECSInterface := True;
    if FECSAuthUser then begin
      UpdateECSParameter(ECSAppend)
    end else begin
      ShowMsg('You don''t have permission to use ECS.');
      exit;
    end;
  end;
  MenuCommand := TMenuItem(Sender).Hint + ECSAppend;
  x := ExpandCommand(MenuCommand);
  if CharAt(x, 1) = '"' then begin
    x     := Copy(x, 2, Length(x));
    AFile := Copy(x, 1, Pos('"',x)-1);
    Param := Copy(x, Pos('"',x)+1, Length(x));
  end else begin
    AFile := Piece(x, ' ', 1);
    Param := Copy(x, Length(AFile)+1, Length(x));
  end;
  if IsECSInterface then begin
    if not ExcuteECS(AFile,Param,curPath) then begin
      ExcuteECS(AFile,Param,curPath);
    end;
    if Length(curPath)>0 then begin
      TMenuItem(Sender).Hint := curPath;
    end;
  end else if (Pos('ecs',LowerCase(AFile))>0) and (not IsECSInterface) then begin
    if not ExcuteEC(AFile,Param) then
      ExcuteEC(AFile,Param);
  end else begin
    ShellExecute(Handle, 'open', PChar(AFile), PChar(Param), '', SW_NORMAL);
  end;
end;

{ Help Menu Events ------------------------------------------------------------------------- }

procedure TfrmFrame.mnuHelpBrokerClick(Sender: TObject);
{ used for debugging - shows last n broker calls }
begin
  ShowBroker;
end;

procedure TfrmFrame.mnuHelpListsClick(Sender: TObject);
{ used for debugging - shows internal contents of TORListBox }
begin
  if Screen.ActiveControl is TListBox
    then DebugListItems(TListBox(Screen.ActiveControl))
    else InfoBox('Focus control is not a listbox', 'ListBox Data', MB_OK);
end;

procedure TfrmFrame.mnuHelpSymbolsClick(Sender: TObject);
{ used for debugging - shows current symbol table }
begin
  DebugShowServer;
end;

procedure TfrmFrame.mnuInsertTimeClick(Sender: TObject);
begin
  inherited;
  frmNotes.InsertText(uTMGOptions.ReadString('TMG CPRS TIME INSERT PREFIX','')+pnlTimer.Caption);
end;

procedure TfrmFrame.mnuLabTextClick(Sender: TObject);
begin
  inherited;
  fSMSLabText.OpenSMSLabText;
end;

procedure TfrmFrame.mnuOpenADTClick(Sender: TObject);
//
begin
  inherited;
  OpenADT;
end;

procedure TfrmFrame.mnuHelpAboutClick(Sender: TObject);
{ displays the about screen }
begin
  ShowAbout;
end;

{ Status Bar Methods }

procedure TfrmFrame.UMStatusText(var Message: TMessage);
{ displays status bar text (using the pointer to a text buffer passed in LParam) }
begin
  stsArea.Panels.Items[0].Text := StrPas(PChar(Message.LParam));
  stsArea.Refresh;
end;

{ Toolbar Methods (make panels act like buttons) ------------------------------------------- }

procedure TfrmFrame.pnlPatientMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ emulate a button press in the patient identification panel }
begin
  if pnlPatient.BevelOuter = bvLowered then exit;
  pnlPatient.BevelOuter := bvLowered;
  with lblPtName do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtSSN  do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtAge  do SetBounds(Left+2, Top+2, Width, Height);
end;

procedure TfrmFrame.pnlPatientMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ emulate the button raising in the patient identification panel & call Patient Inquiry }
begin
  if pnlPatient.BevelOuter = bvRaised then exit;
  pnlPatient.BevelOuter := bvRaised;
  with lblPtName do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtSSN  do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtAge  do SetBounds(Left-2, Top-2, Width, Height);
end;

procedure TfrmFrame.pnlVisitMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ emulate a button press in the encounter panel }
begin
  if User.IsReportsOnly then
    exit;
  if pnlVisit.BevelOuter = bvLowered then exit;
  pnlVisit.BevelOuter := bvLowered;
  //with lblStLocation do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtLocation do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtProvider do SetBounds(Left+2, Top+2, Width, Height);
end;

procedure TfrmFrame.pnlVisitMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ emulate a button raising in the encounter panel and call Update Provider/Location }
begin
  if User.IsReportsOnly then
    exit;
  if pnlVisit.BevelOuter = bvRaised then exit;
  pnlVisit.BevelOuter := bvRaised;
  //with lblStLocation do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtLocation do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtProvider do SetBounds(Left-2, Top-2, Width, Height);
end;

procedure TfrmFrame.pnlVistaWebClick(Sender: TObject);
begin
  inherited;
  uUseVistaWeb := true;
  pnlVistaWeb.BevelOuter := bvLowered;
  pnlCIRNClick(self);
  uUseVistaWeb := false;
end;

procedure TfrmFrame.pnlVistaWebMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  pnlVistaWeb.BevelOuter := bvLowered;
end;

procedure TfrmFrame.pnlVistaWebMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  pnlVistaWeb.BevelOuter := bvRaised;
end;

procedure TfrmFrame.pnlPrimaryCareMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if pnlPrimaryCare.BevelOuter = bvLowered then exit;
  pnlPrimaryCare.BevelOuter := bvLowered;
  with lblPtCare      do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtAttending do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtMHTC do SetBounds(Left+2, Top+2, Width, Height);
end;

procedure TfrmFrame.pnlPrimaryCareMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if pnlPrimaryCare.BevelOuter = bvRaised then exit;
  pnlPrimaryCare.BevelOuter := bvRaised;
  with lblPtCare      do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtAttending do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtMHTC      do SetBounds(Left-2, Top-2, Width, Height);
end;

procedure TfrmFrame.pnlPostingsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{ emulate a button press in the postings panel }
begin
  if pnlPostings.BevelOuter = bvLowered then exit;
  pnlPostings.BevelOuter := bvLowered;
  with lblPtPostings do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtCWAD     do SetBounds(Left+2, Top+2, Width, Height);
end;

procedure TfrmFrame.pnlPostingsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{ emulate a button raising in the posting panel and call Postings }
begin
  if pnlPostings.BevelOuter = bvRaised then exit;
  pnlPostings.BevelOuter := bvRaised;
  with lblPtPostings do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtCWAD     do SetBounds(Left-2, Top-2, Width, Height);
end;

{ Resize and Font-Change procedures -------------------------------------------------------- }

procedure TfrmFrame.LoadSizesForUser;
var
  s1, s2, s3, s4, Dummy: integer;
  panelBottom, panelMedIn : integer;

begin
  ChangeFont(UserFontSize);
  //kt 5/26/14 SetUserBounds(TControl(frmFrame));
  SetFormPosition(TForm(frmFrame));  //kt 5/26/14
  SetUserWidths(TControl(frmProblems.pnlLeft));
  //SetUserWidths(TControl(frmMeds.pnlLeft));
  SetUserWidths(TControl(frmOrders.pnlLeft));
  SetUserWidths(TControl(frmNotes.pnlLeft));
  SetUserWidths(TControl(frmConsults.pnlLeft));
  SetUserWidths(TControl(frmDCSumm.pnlLeft));
  if Assigned(frmSurgery) then SetUserWidths(TControl(frmSurgery.pnlLeft));
  SetUserWidths(TControl(frmLabs.pnlLeft));
  SetUserWidths(TControl(frmReports.pnlLeft));
  SetUserColumns(TControl(frmOrders.hdrOrders));
  SetUserColumns(TControl(frmMeds.hdrMedsIn));  // still need conversion
  SetUserColumns(TControl(frmMeds.hdrMedsOut));
  SetUserString('frmPtSel.lstvAlerts',EnduringPtSelColumns);
  SetUserString(SpellCheckerSettingName, SpellCheckerSettings);
  SetUserBounds2(TemplateEditorSplitters, tmplEditorSplitterMiddle,
                 tmplEditorSplitterProperties, tmplEditorSplitterMain, tmplEditorSplitterBoil);
  SetUserBounds2(TemplateEditorSplitters2, tmplEditorSplitterNotes, Dummy, Dummy, Dummy);
  SetUserBounds2(ReminderTreeName, RemTreeDlgLeft, RemTreeDlgTop, RemTreeDlgWidth, RemTreeDlgHeight);
  SetUserBounds2(RemDlgName, RemDlgLeft, RemDlgTop, RemDlgWidth, RemDlgHeight);
  ForceUserBoundsInsideWorkArea(RemDlgLeft, RemDlgTop, RemDlgWidth, RemDlgHeight); //kt 5/26/14
  SetUserBounds2(RemDlgSplitters, RemDlgSpltr1, RemDlgSpltr2, Dummy ,Dummy);
  SetUserBounds2(DrawerSplitters,s1, s2, s3, Dummy);
  if Assigned(frmSurgery) then frmSurgery.Drawers.LastOpenSize := Dummy; //CQ7315
  frmNotes.Drawers.LastOpenSize := s1;
  frmConsults.Drawers.LastOpenSize := s2;
  frmDCSumm.Drawers.LastOpenSize := s3;

  with frmMeds do begin
    SetUserBounds2(frmMeds.Name+'Split', panelBottom, panelMedIn, Dummy, Dummy);
    if (panelBottom > frmMeds.Height-50) then panelBottom := frmMeds.Height-50;
    if (panelMedIn > panelBottom-50) then panelMedIn := panelBottom-50;
    frmMeds.pnlBottom.Height := panelBottom;
    frmMeds.pnlMedIn.Height := panelMedIn;
    //Meds Tab Non-VA meds columns
    SetUserColumns(TControl(hdrMedsNonVA)); //CQ7314
  end;

  frmCover.DisableAlign;
  try
    SetUserBounds2(CoverSplitters1, s1, s2, s3, s4);
    if s1 > 0 then frmCover.pnl_1.Width := LowerOf( frmCover.pnl_not3.ClientWidth - 5, s1);
    if s2 > 0 then frmCover.pnl_3.Width := LowerOf( frmCover.pnlTop.ClientWidth - 5, s2);
    if s3 > 0 then frmCover.pnlTop.Height := LowerOf( frmCover.pnlBase.ClientHeight - 5, s3);
    if s4 > 0 then frmCover.pnl_4.Width := LowerOf( frmCover.pnlMiddle.ClientWidth - 5, s4);

    SetUserBounds2(CoverSplitters2, s1, s2, s3, Dummy);
    if s1 > 0 then frmCover.pnlBottom.Height := LowerOf( frmCover.pnlBase.ClientHeight - 5, s1);
    if s2 > 0 then frmCover.pnl_6.Width := LowerOf( frmCover.pnlBottom.ClientWidth - 5, s2);
    if s3 > 0 then frmCover.pnl_8.Width := LowerOf( frmCover.pnlBottom.ClientWidth - 5, s3);
  finally
   frmCover.EnableAlign;
  end;
  if ParamSearch('rez') = '640' then SetBounds(Left, Top, 648, 488);  // for testing
end;

procedure TfrmFrame.SaveSizesForUser;
var
  SizeList: TStringList;
  SurgTempHt: integer;
begin
  SaveUserFontSize(MainFontSize);
  SizeList := TStringList.Create;
  try
    with SizeList do begin
      //kt 5/26/14 Add(StrUserBounds(frmFrame));
      SaveUserBounds(frmFrame);  //kt added 5/26/14
      Add(StrUserBounds(frmFrame));
      Add(StrUserWidth(frmProblems.pnlLeft));
      //Add(StrUserWidth(frmMeds.pnlLeft));
      Add(StrUserWidth(frmOrders.pnlLeft));
      Add(StrUserWidth(frmNotes.pnlLeft));
      Add(StrUserWidth(frmConsults.pnlLeft));
      Add(StrUserWidth(frmDCSumm.pnlLeft));
      if Assigned(frmSurgery) then Add(StrUserWidth(frmSurgery.pnlLeft));
      Add(StrUserWidth(frmLabs.pnlLeft));
      Add(StrUserWidth(frmReports.pnlLeft));
      Add(StrUserColumns(frmOrders.hdrOrders));
      Add(StrUserColumns(frmMeds.hdrMedsIn));
      Add(StrUserColumns(frmMeds.hdrMedsOut));
      Add(StrUserString(SpellCheckerSettingName, SpellCheckerSettings));
      Add(StrUserBounds2(TemplateEditorSplitters, tmplEditorSplitterMiddle,
          tmplEditorSplitterProperties, tmplEditorSplitterMain, tmplEditorSplitterBoil));
      Add(StrUserBounds2(TemplateEditorSplitters2, tmplEditorSplitterNotes, 0, 0, 0));
      Add(StrUserBounds2(ReminderTreeName, RemTreeDlgLeft, RemTreeDlgTop, RemTreeDlgWidth, RemTreeDlgHeight));
      Add(StrUserBounds2(RemDlgName, RemDlgLeft, RemDlgTop, RemDlgWidth, RemDlgHeight));
      Add(StrUserBounds2(RemDlgSplitters, RemDlgSpltr1, RemDlgSpltr2, 0 ,0));

      //v26.47 - RV - access violation if Surgery Tab not enabled.  Set to designer height as default.
      if Assigned(frmSurgery) then SurgTempHt := frmSurgery.Drawers.pnlTemplates.Height else SurgTempHt := 85;
      Add(StrUserBounds2(DrawerSplitters, frmNotes.Drawers.LastOpenSize,
                         frmConsults.Drawers.LastOpenSize,
                         frmDCSumm.Drawers.LastOpenSize,
                         SurgTempHt)); // last parameter = CQ7315

      Add(StrUserBounds2(CoverSplitters1,
          frmCover.pnl_1.Width,
          frmCover.pnl_3.Width,
          frmCover.pnlTop.Height,
          frmCover.pnl_4.Width));
      Add(StrUserBounds2(CoverSplitters2,
          frmCover.pnlBottom.Height,
          frmCover.pnl_6.Width,
          frmCover.pnl_8.Width,
          0));

      //Meds Tab Splitters
      Add(StrUserBounds2(frmMeds.Name+'Split',frmMeds.pnlBottom.Height,frmMeds.pnlMedIn.Height,0,0));

      //Meds Tab Non-VA meds columns
      Add(StrUserColumns(fMeds.frmMeds.hdrMedsNonVA)); //CQ7314

      //Orders Tab columns
      Add(StrUserColumns(fOrders.frmOrders.hdrOrders)); //CQ6328

      if EnduringPtSelSplitterPos <> 0 then
        Add(StrUserBounds2('frmPtSel.sptVert', EnduringPtSelSplitterPos, 0, 0, 0));
      if EnduringPtSelColumns <> '' then
        Add('C^frmPtSel.lstvAlerts^' + EnduringPtSelColumns);
    end;
    //Add sizes for forms that used SaveUserBounds() to save thier positions
    SizeHolder.AddSizesToStrList(SizeList);
    //Send the SizeList to the Database
    SaveUserSizes(SizeList);
  finally
    SizeList.Free;
  end;
end;

procedure TfrmFrame.ResizeTabs(AutoResizeTabs : boolean = false);
//kt-tabs 7/25/21  - split out of Resize event handler FormResize()
var i,index : integer;
    width, height : integer;

    procedure DoMove(APage : TFrmpage);
    var height, width: integer;
    begin
      if not assigned(APage) then exit;
      height := APage.Parent.ClientHeight;
      width := APage.Parent.ClientWidth;
      MoveWindow(APage.Handle, 0, 0, width, height, True);
    end;

begin
  if FTerminate or FClosing then Exit;
  if csDestroying in ComponentState then Exit;
  if AutoResizeTabs then SetTabOpenMode(FTabPageOpenMode, true); //kt 7/25/21

  DoMove(frmCover);
  DoMove(frmProblems);
  DoMove(frmMeds);
  DoMove(frmOrders);
  DoMove(frmNotes);
  DoMove(frmConsults);
  DoMove(frmDCSumm);
  DoMove(frmSurgery);
  DoMove(frmLabs);
  DoMove(frmReports);
  DoMove(frmMailbox);

  //MoveWindow(frmCover.Handle,    0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //MoveWindow(frmProblems.Handle, 0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //MoveWindow(frmMeds.Handle,     0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //MoveWindow(frmOrders.Handle,   0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //MoveWindow(frmNotes.Handle,    0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //MoveWindow(frmConsults.Handle, 0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //MoveWindow(frmDCSumm.Handle,   0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //if Assigned(frmSurgery) then MoveWindow(frmSurgery.Handle,     0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //MoveWindow(frmLabs.Handle,     0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //MoveWindow(frmReports.Handle,  0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //MoveWindow(frmMailbox.Handle,  0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  //kt 9/11 -- start addition --
  for i := CT_WEBTAB1 to CT_LAST_WEBTAB do begin
    index := i-CT_WEBTAB1;
    tempFrmWebTab := TfrmWebTab(WebTabsList[index]);
    DoMove(tempFrmWebTab);
  end;
  PositionSplitterHandle;
  //kt 9/11 -- end addition --
  with stsArea do begin
    Panels[1].Width := stsArea.Width - FFixedStatusWidth;
    FNextButtonL := Panels[0].Width + Panels[1].Width;
    FNextButtonR := FNextButtonL + Panels[2].Width;
  end;
  SetUpResizeButtons; //kt 4/28/21
  if Notifications.Active then SetUpNextButton;
  lstCIRNLocations.Left  := FNextButtonL - ScrollBarWidth - 100;
  lstCIRNLocations.Width := ClientWidth - lstCIRNLocations.Left;
  //cq: 15641
  if frmFrame.FNextButtonActive then begin// keeps button alligned if cancel is pressed
    FNextButton.Left := FNextButtonL;
    FNextButton.Top := stsArea.Top;
  end;
  Self.Repaint;
end;

procedure TfrmFrame.FormResize(Sender: TObject);
{ need to resize tab forms specifically since they don't inherit resize event (because they
  are derived from TForm itself) }
begin
  ResizeTabs;
end;

procedure TfrmFrame.frameLRSplitterMoved(Sender: TObject);  //kt-tabs
begin
  //kt-tabs added 7/23/21
  inherited;
  ResizeTabs(false);
  PositionSplitterHandle;
end;

procedure TfrmFrame.PositionSplitterHandle;  //kt-tabs
  procedure SetBtnBitmap(index : integer);
  var BMP : TBitmap;
  begin
    BMP := TBitmap.Create;
    try
      BMP.SetSize(ImageListSplitterHandle.Width, ImageListSplitterHandle.Height);
      ImageListSplitterHandle.GetBitmap(index, BMP);
      btnSplitterHandle.Glyph.Assign(BMP);
    finally
      BMP.free
    end;
  end;

begin
  case FTabPageOpenMode of
    tpoOpen :  begin
                 btnSplitterHandle.Left := frameLRSplitter.Left;
               end;
    tpoClosed: begin
                 btnSplitterHandle.Left := frameLRSplitter.Left - btnSplitterHandle.Width + frameLRSplitter.Width;
               end;
  end;
  SetBtnBitmap(ord(FTabPageOpenMode));
  btnSplitterHandle.Top := Floor((pnlMain.Height - btnSplitterHandle.Height)/2);
end;

procedure TfrmFrame.frameLRSplitterMouseEnter(Sender: TObject);  //kt-tabs
//kt-tabs added 7/23/21
begin
  inherited;
  btnSplitterHandle.Visible := true;
end;

procedure TfrmFrame.frameLRSplitterMouseLeave(Sender: TObject);  //kt-tabs
//kt-tabs added 7/23/21
begin
  inherited;
  timHideSplitterHandle.Enabled := false;
  timHideSplitterHandle.Enabled := true;  //reset timer
end;

function TfrmFrame.ToggleTabPageOpenMode(Mode: TTabPageOpenMode) : TTabpageOpenMode; //kt-tabs
begin
  if Mode = tpoOpen then Result := tpoClosed else Result := tpoOpen;
end;

procedure TfrmFrame.btnSplitterHandleClick(Sender: TObject);  //kt-tabs
//kt-tabs added 7/23/21
var NewMode: TTabPageOpenMode;
begin
  inherited;
  NewMode := ToggleTabPageOpenMode(FTabPageOpenMode);
  SetTabOpenMode(NewMode);
end;

procedure TfrmFrame.timHideSplitterHandleTimer(Sender: TObject);  //kt-tabs
begin
  inherited;
  btnSplitterHandle.Visible := false;
end;

procedure TfrmFrame.btnSplitterHandleMouseEnter(Sender: TObject);  //kt-tabs
begin
  inherited;
  timHideSplitterHandle.Enabled := false;
end;

procedure TfrmFrame.btnSplitterHandleMouseLeave(Sender: TObject);
begin
  inherited;
  timHideSplitterHandle.Enabled := false;
  timHideSplitterHandle.Enabled := true;  //reset timer
end;

procedure TfrmFrame.ChangeFont(NewFontSize: Integer);
{ Makes changes in all components whenever the font size is changed.  This is hardcoded and
  based on MS Sans Serif for now, as only the font size may be selected. Courier New is used
  wherever non-proportional fonts are required. }
const
  TAB_VOFFSET = 7;
var
  OldFont: TFont;
  ASide: TTabPageSide;
begin
// Ho ho!  ResizeAnchoredFormToFont(self) doesn't work here because the
// Form size is aliased with MainFormSize.
  OldFont := TFont.Create;
  try
    DisableAlign;
    try
      OldFont.Assign(Font);
      with Self           do Font.Size := NewFontSize;
      with lblPtName      do Font.Size := NewFontSize;   // must change BOLDED labels by hand
      with lblPtSSN       do Font.Size := NewFontSize;
      with lblPtAge       do Font.Size := NewFontSize;
      with lblPtLocation  do Font.Size := NewFontSize;
      with lblPtProvider  do Font.Size := NewFontSize;
      with lblPtPostings  do Font.Size := NewFontSize;
      with lblPtCare      do Font.Size := NewFontSize;
      with lblPtAttending do Font.Size := NewFontSize;
      with lblPtMHTC      do Font.Size := NewFontSize;
      with lblFlag        do Font.Size := NewFontSize;
      with lblPtCWAD      do Font.Size := NewFontSize;
      with lblCIRN        do Font.Size := NewFontSize;
      with lblVistaWeb    do Font.Size := NewFontSize;
      with lstCIRNLocations do begin
        Font.Size := NewFontSize;
        ItemHeight := NewFontSize + 6;
      end;
      for ASide := tpsLeft to tpsRight do begin
        with FTabPage[ASide] do Font.Size := NewFontSize;
        FTabPage[ASide].Height := MainFontHeight + TAB_VOFFSET;   // resize tab selector
      end;
      with laMHV          do Font.Size := NewFontSize; //VAA
      with laVAA2         do Font.Size := NewFontSize; //VAA

      frmFrameHeight := frmFrame.Height;
      pnlPatientSelectedHeight := pnlPatientSelected.Height;
      //kt  tabPage.Height := MainFontHeight + TAB_VOFFSET;   // resize tab selector
      FitToolbar;                                       // resize toolbar
      stsArea.Font.Size := NewFontSize;
      stsArea.Height := MainFontHeight + TAB_VOFFSET;
      stsArea.Panels[0].Width := ResizeWidth( OldFont, Font, stsArea.Panels[0].Width);
      stsArea.Panels[2].Width := ResizeWidth( OldFont, Font, stsArea.Panels[2].Width);

      //VAA CQ8271
      if ((fCover.PtIsVAA and fCover.PtIsMHV)) then begin
        laMHV.Height := (pnlToolBar.Height div 2) -1;
        with laVAA2 do begin
          Top := laMHV.Top + laMHV.Height;
          Height := (pnlToolBar.Height div 2) -1;
        end;
      end;
      //end VAA

      RefreshFixedStatusWidth;
      FormResize( self );
    finally
      EnableAlign;
    end;
  finally
    OldFont.Free;
  end;

  case (NewFontSize) of
     8: mnu8pt.Checked := true;
    10: mnu10pt1.Checked := true;
    12: mnu12pt1.Checked := true;
    14: mnu14pt1.Checked := true;
    18: mnu18pt1.Checked := true;
  end;

  //Now that the form elements are resized, the pages will know what size to take.
  frmCover.SetFontSize(NewFontSize);                // child pages lack a ParentFont property
  frmProblems.SetFontSize(NewFontSize);
  frmMeds.SetFontSize(NewFontSize);
  frmOrders.SetFontSize(NewFontSize);
  frmNotes.SetFontSize(NewFontSize);
  frmConsults.SetFontSize(NewFontSize);
  frmDCSumm.SetFontSize(NewFontSize);
  if Assigned(frmSurgery) then frmSurgery.SetFontSize(NewFontSize);
  frmLabs.SetFontSize(NewFontSize);
  frmReports.SetFontSize(NewFontSize);
  TfrmIconLegend.SetFontSize(NewFontSize);
  uOrders.SetFontSize(NewFontSize);
  if Assigned(frmRemDlg) then frmRemDlg.SetFontSize;
  if Assigned(frmReminderTree) then frmReminderTree.SetFontSize(NewFontSize);
  if Assigned(frmImages) then frmImages.SetFontSize(NewFontSize); //kt 9/11
  if GraphFloat <> nil then ResizeAnchoredFormToFont(GraphFloat);
end;

procedure TfrmFrame.FitToolBar;
{ resizes and repositions the panels & labels used in the toolbar }
const
  PATIENT_WIDTH = 29;
  VISIT_WIDTH   = 36;
  POSTING_WIDTH = 11.5;
  FLAG_WIDTH    = 5;
  CV_WIDTH      = 15; //14; WAT
  CIRN_WIDTH    = 11;
  MHV_WIDTH     = 6;
  LINES_HIGH2   = 2;
  LINES_HIGH3   = 3;    //lblPtMHTC line change
  M_HORIZ       = 4;
  M_MIDDLE      = 2;
  M_NVERT       = 4;
  M_WVERT       = 6;
  TINY_MARGIN   = 2;
//var
  //WidthNeeded: integer;
begin
  if lblPtMHTC.caption = '' then begin
    lblPtMHTC.Visible := false;
    pnlToolbar.Height  := (LINES_HIGH2 * lblPtName.Height) + M_HORIZ + M_MIDDLE + M_HORIZ + M_MIDDLE
  end else begin
    if (lblPtAttending.Caption <> '') and (lblPtAttending.Caption <> lblPtMHTC.Caption) then begin
      lblPtMHTC.Visible := true;
      pnlToolbar.Height  := (LINES_HIGH3 * lblPtName.Height) + M_HORIZ + M_MIDDLE + M_HORIZ + M_HORIZ;
    end;
    if lblPtAttending.Caption = '' then begin
      lblPtAttending.Caption := lblPtMHTC.Caption;
      lblPtMHTC.Visible := false;
      pnlToolbar.Height  := (LINES_HIGH2 * lblPtName.Height) + M_HORIZ + M_MIDDLE + M_HORIZ + M_MIDDLE;
    end;
  end;
  pnlPatient.Width   := HigherOf(PATIENT_WIDTH * MainFontWidth, lblPtName.Width + (M_WVERT * 2));
  lblPtSSN.Top       := M_HORIZ + lblPtName.Height + M_MIDDLE;
  lblPtAge.Top       := lblPtSSN.Top;
  lblPtAge.Left      := pnlPatient.Width - lblPtAge.Width - M_WVERT;
  pnlVisit.Width     := HigherOf(LowerOf(VISIT_WIDTH * MainFontWidth,
                                         HigherOf(lblPtProvider.Width + (M_WVERT * 2),
                                                  lblPtLocation.Width + (M_WVERT * 2))),
                                 PATIENT_WIDTH * MainFontWidth);
  lblPtProvider.Top  := lblPtSSN.Top;
  lblPtAttending.Top := lblPtSSN.Top;
  lblPtMHTC.Top      := M_MIDDLE + lblPtSSN.Height + lblPtSSN.Top;
  pnlPostings.Width  := Round(POSTING_WIDTH * MainFontWidth);
  if btnCombatVet.Visible then begin
    pnlCVnFlag.Width    := Round(CV_WIDTH * MainFontWidth);
    pnlFlag.Width       := Round(CV_WIDTH * MainFontWidth);
    btnCombatVet.Height := Round(pnlCVnFlag.Height div 2);
  end else begin
    pnlCVnFlag.Width   := Round(FLAG_WIDTH * MainFontWidth);
    pnlFlag.Width      := Round(FLAG_WIDTH * MainFontWidth);
  end;
  pnlRemoteData.Width := Round(CIRN_WIDTH * MainFontWidth) + M_WVERT;
  pnlVistaWeb.Height  := pnlRemoteData.Height div 2;
  paVAA.Width         := Round(MHV_WIDTH * MainFontWidth) + M_WVERT + 2;
  with lblPtPostings do
    SetBounds(M_WVERT, M_HORIZ, pnlPostings.Width-M_WVERT-M_WVERT, lblPtName.Height);
  with lblPtCWAD     do
    SetBounds(M_WVERT, lblPtSSN.Top, lblPtPostings.Width, lblPtName.Height);
  //Low resolution handling: First, try to fit everything on by shrinking fields
  pnlPrimaryCare.Width := 350;
  if pnlPrimaryCare.Width < HigherOf( lblPtCare.Left + lblPtCare.Width, HigherOf(lblPtAttending.Left + lblPtAttending.Width,lblPtMHTC.Left + lblPtMHTC.Width)) + TINY_MARGIN then
  //if pnlPrimaryCare.Width < HigherOf( lblPtCare.Left + lblPtCare.Width, lblPtAttending.Left + lblPtAttending.Width) + TINY_MARGIN then
  begin
    lblPtAge.Left := lblPtAge.Left - (lblPtName.Left - TINY_MARGIN);
    lblPtName.Left := TINY_MARGIN;
    lblPTSSN.Left := TINY_MARGIN;
    pnlPatient.Width := HigherOf( lblPtName.Left + lblPtName.Width, lblPtAge.Left + lblPtAge.Width)+ TINY_MARGIN;
    lblPtLocation.Left := TINY_MARGIN;
    lblPtProvider.Left := TINY_MARGIN;
    pnlVisit.Width := HigherOf( lblPtLocation.Left + lblPtLocation.Width, lblPtProvider.Left + lblPtProvider.Width)+ TINY_MARGIN;
  end;
  pnlSchedule.Width := round(pnlPrimaryCare.Width/2);
  //pnlSchedule.Width := pnlPrimaryCare.Width;

  //txtSchedule.Caption :=
  //If that is not enough, add scroll bars to form
  {if pnlPrimaryCare.Width < HigherOf( lblPtCare.Left + lblPtCare.Width, lblPtAttending.Left + lblPtAttending.Width) + TINY_MARGIN then
  begin
    WidthNeeded := HigherOf( lblPtCare.Left + lblPtCare.Width, lblPtAttending.Left + lblPtAttending.Width) + TINY_MARGIN - pnlPrimaryCare.Width;
    HorzScrollBar.Range := ClientWidth + WidthNeeded;
    Width := Width + WidthNeeded;
  end
  else }   // commented out - BA
    HorzScrollBar.Range := 0;
end;

{ Temporary Calls -------------------------------------------------------------------------- }

procedure TfrmFrame.ToggleMenuItemChecked(Sender: TObject);
begin
  with (Sender as TMenuItem) do begin
    if not Checked then
      Checked := true
    else
      Checked := false;
  end;
end;

procedure TfrmFrame.mnuFontSizeClick(Sender: TObject);
begin
  if (frmRemDlg <> nil) then
    ShowMsg('Please close the reminder dialog before changing font sizes.')
  else
    if (dlgProbs <> nil) then begin
      ShowMsg('Font size cannot be changed while adding or editing a problem.')
    end
  else begin
    with (Sender as TMenuItem) do begin
      ToggleMenuItemChecked(Sender);
      fMeds.oldFont := MainFontSize; //CQ9182
      ChangeFont(Tag);
    end;
  end;
end;

procedure TfrmFrame.mnuFrameChange(Sender: TObject; Source: TMenuItem; Rebuild: Boolean);
var i:integer;
begin
  inherited;
  i := i + 1;
end;

procedure TfrmFrame.mnuEditClick(Sender: TObject);
var
  IsReadOnly: Boolean;
begin
  FEditCtrl := nil;
  if Screen.ActiveControl is TCustomEdit then FEditCtrl := TCustomEdit(Screen.ActiveControl);
  if FEditCtrl <> nil then begin
    if      FEditCtrl is TMemo     then IsReadOnly := TMemo(FEditCtrl).ReadOnly
    else if FEditCtrl is TEdit     then IsReadOnly := TEdit(FEditCtrl).ReadOnly
    else if FEditCtrl is TRichEdit then IsReadOnly := TRichEdit(FEditCtrl).ReadOnly
    else IsReadOnly := True;

    mnuEditRedo.Enabled := FEditCtrl.Perform(EM_CANREDO, 0, 0) <> 0;
    mnuEditUndo.Enabled := (FEditCtrl.Perform(EM_CANUNDO, 0, 0) <> 0) and (FEditCtrl.Perform(EM_CANREDO, 0, 0) = 0);

    mnuEditCut.Enabled := FEditCtrl.SelLength > 0;
    mnuEditCopy.Enabled := mnuEditCut.Enabled;
    mnuEditPaste.Enabled := (IsReadOnly = False) and Clipboard.HasFormat(CF_TEXT);
  end else begin
    mnuEditUndo.Enabled  := False;
    mnuEditCut.Enabled   := False;
    mnuEditCopy.Enabled  := False;
    mnuEditPaste.Enabled := False;
  end;
end;

procedure TfrmFrame.mnuEditUndoClick(Sender: TObject);
begin
  FEditCtrl.Perform(EM_UNDO, 0, 0);
end;

procedure TfrmFrame.mnuExportChartClick(Sender: TObject);
begin
  inherited;
  fTMGChartExporter.ExportOneChart(0);
end;

procedure TfrmFrame.mnuEditRedoClick(Sender: TObject);
begin
  FEditCtrl.Perform(EM_REDO, 0, 0);
end;

procedure TfrmFrame.mnuEditCutClick(Sender: TObject);
begin
  FEditCtrl.CutToClipboard;
end;

procedure TfrmFrame.mnuEditCopyClick(Sender: TObject);
begin
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmFrame.mnuEditPasteClick(Sender: TObject);
begin
  FEditCtrl.SelText := Clipboard.AsText;
  //FEditCtrl.PasteFromClipboard;  // use AsText to prevent formatting from being pasted
end;

procedure TfrmFrame.mnuFilePrintClick(Sender: TObject);
begin
  case mnuFilePrint.Tag of
  CT_NOTES:    frmNotes.RequestPrint;
  CT_CONSULTS: frmConsults.RequestPrint;
  CT_DCSUMM:   frmDCSumm.RequestPrint;
  CT_REPORTS:  frmReports.RequestPrint;
  CT_LABS:     frmLabs.RequestPrint;
  CT_ORDERS:   frmOrders.RequestPrint;
  CT_PROBLEMS: frmProblems.RequestPrint;
  CT_SURGERY:  if Assigned(frmSurgery) then frmSurgery.RequestPrint;
  CT_WEBTAB1..CT_LAST_WEBTAB:  begin                                                     //kt 9/11
                 tempFrmWebTab := TfrmWebTab(WebTabsList[mnuFilePrint.Tag-CT_WEBTAB1]);   //kt 9/11
                 if tempFrmWebTab <> nil then tempFrmWebTab.RequestPrint;                //kt 9/11
               end;
  end;
end;

procedure TfrmFrame.WMSysCommand(var Message: TMessage);
begin
  case TabIndexToPageID(FTabPage[tpsLeft].TabIndex) of
    CT_NOTES: begin
      if Assigned(Screen.ActiveControl.Parent) and (Screen.ActiveControl.Parent.Name = 'cboCosigner') then begin
        with Message do begin
          SendMessage(frmNotes.Handle, Msg, WParam, LParam);
          Result := 0;
        end;
      end else inherited;
    end;
    CT_DCSUMM: begin
      if Assigned(Screen.ActiveControl.Parent) and (Screen.ActiveControl.Parent.Name = 'cboAttending') then begin
        with Message do begin
          SendMessage(frmDCSumm.Handle, Msg, WParam, lParam);
          Result := 0;
        end;
      end else inherited;
    end;
    CT_CONSULTS: begin
      if Assigned(Screen.ActiveControl.Parent) and (Screen.ActiveControl.Parent.Name = 'cboCosigner') then begin
        with Message do begin
          SendMessage(frmConsults.Handle, Msg, WParam, lParam);
          Result := 0;
        end;
      end else inherited;
    end;
    else //case
      inherited;
  end; //case
  if Message.WParam = SC_MAXIMIZE then begin
    // form becomes maximized;
    frmOrders.mnuOptimizeFieldsClick(self);
    frmProblems.mnuOptimizeFieldsClick(self);
    frmMeds.mnuOptimizeFieldsClick(self);
  end else if Message.WParam = SC_MINIMIZE then begin
    // form becomes maximized;
  end else if Message.WParam = SC_RESTORE then begin
    // form is restored (from maximized);
    frmOrders.mnuOptimizeFieldsClick(self);
    frmProblems.mnuOptimizeFieldsClick(self);
    frmMeds.mnuOptimizeFieldsClick(self);
  end;
end;

procedure TfrmFrame.RemindersChanged(Sender: TObject);
var
  ImgName: string;
begin
  pnlReminders.tag := HAVE_REMINDERS;
  pnlReminders.Hint := 'Click to display reminders';
  case GetReminderStatus of
    rsUnknown: begin
        ImgName := 'BMP_REMINDERS_UNKNOWN';
        pnlReminders.Caption := 'Reminders';
      end;
    rsDue: begin
        ImgName := 'BMP_REMINDERS_DUE';
        pnlReminders.Caption := 'Due Reminders';
      end;
    rsApplicable: begin
        ImgName := 'BMP_REMINDERS_APPLICABLE';
        pnlReminders.Caption := 'Applicable Reminders';
      end;
    rsNotApplicable: begin
        ImgName := 'BMP_REMINDERS_OTHER';
        pnlReminders.Caption := 'Other Reminders';
      end;
    else //case
      begin
        ImgName := 'BMP_REMINDERS_NONE';
        pnlReminders.Hint := 'There are currently no reminders available';
        pnlReminders.Caption := pnlReminders.Hint;
        pnlReminders.tag := NO_REMINDERS;
      end;
  end; //case
  if(RemindersEvaluatingInBackground) then begin
    if(anmtRemSearch.ResName = '') then begin
      TORExposedAnimate(anmtRemSearch).OnMouseDown := pnlRemindersMouseDown;
      TORExposedAnimate(anmtRemSearch).OnMouseUp   := pnlRemindersMouseUp;
      anmtRemSearch.ResHandle := 0;
      anmtRemSearch.ResName := 'REMSEARCHAVI';
    end;
    imgReminder.Visible := FALSE;
    anmtRemSearch.Active := TRUE;
    anmtRemSearch.Visible := TRUE;
    if(pnlReminders.Hint <> '') then
      pnlReminders.Hint := CRLF + pnlReminders.Hint + '.';
    pnlReminders.Hint := 'Evaluating Reminders...  ' + pnlReminders.Hint;
    pnlReminders.Caption := pnlReminders.Hint;
  end else begin
    anmtRemSearch.Visible := FALSE;
    imgReminder.Visible := TRUE;
    imgReminder.Picture.Bitmap.LoadFromResourceName(hInstance, ImgName);
    anmtRemSearch.Active := FALSE;
  end;
  mnuViewReminders.Enabled := (pnlReminders.tag = HAVE_REMINDERS);
end;

procedure TfrmFrame.pnlRemindersMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if(not InitialRemindersLoaded) then
    StartupReminders;
  if(pnlReminders.tag = HAVE_REMINDERS) then
    pnlReminders.BevelOuter := bvLowered;
end;

procedure TfrmFrame.pnlRemindersMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlReminders.BevelOuter := bvRaised;
  if(pnlReminders.tag = HAVE_REMINDERS) then
    ViewInfo(mnuViewReminders);
end;

procedure TfrmFrame.pnlScheduleClick(Sender: TObject);
begin
  inherited;
  Showmessage('Schedule report coming soon.');
end;

procedure TfrmFrame.pnlTimerMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
end;

//--------------------- CIRN-related procedures --------------------------------

procedure TfrmFrame.SetUpCIRN;
var
  i: integer;
  aAutoQuery: string;
  ASite: TRemoteSite;
begin
  uUseVistaWeb := false;
  with RemoteSites do begin
    ChangePatient(Patient.DFN);
    lblCIRN.Caption := ' Remote Data';
    lblCIRN.Alignment := taCenter;
    pnlVistaWeb.BevelOuter := bvRaised;
    if RemoteDataExists and (RemoteSites.Count > 0) then begin
      lblCIRN.Enabled     := True;
      pnlCIRN.TabStop     := True;
      lblCIRN.Font.Color  := Get508CompliantColor(clBlue);
      lstCIRNLocations.Font.Color  := Get508CompliantColor(clBlue);
      lblCIRN.Caption := 'Remote Data';
      pnlCIRN.Hint := 'Click to display other facilities having data for this patient.';
      lblVistaWeb.Font.Color := Get508CompliantColor(clBlue);
      pnlVistaWeb.Hint := 'Click to go to VistaWeb to see data from other facilities for this patient.';
      if RemoteSites.Count > 0 then
        lstCIRNLocations.Items.Add('0' + U + 'All Available Sites');
      for i := 0 to RemoteSites.Count - 1 do begin
        ASite := TRemoteSite(SiteList[i]);
        lstCIRNLocations.Items.Add(ASite.SiteID + U + ASite.SiteName + U +
                                   FormatFMDateTime('mmm dd yyyy hh:nn', ASite.LastDate));
      end;
    end else begin
      lblCIRN.Font.Color  := clWindowText;
      lblVistaWeb.Font.Color := clWindowText;
      lblCIRN.Enabled     := False;
      pnlCIRN.TabStop     := False;
      pnlCIRN.Hint := NoDataReason;
    end;
    aAutoQuery := AutoRDV;        //Check to see if Remote Queries should be used for all available sites
    if (aAutoQuery = '1') and (lstCIRNLocations.Count > 0) then begin
      lstCIRNLocations.ItemIndex := 1;
      lstCIRNLocations.Checked[1] := true;
      lstCIRNLocationsClick(self);
    end;
  end;
end;

procedure TfrmFrame.pnlCIRNClick(Sender: TObject);
begin
  ViewInfo(mnuViewRemoteData);
end;

procedure TfrmFrame.lstCIRNLocationsClick(Sender: TObject);
var
  iIndex,j,iAll,iCur: integer;
  aMsg,s: string;
  AccessStatus: integer;
begin
  iAll := 1;
  AccessStatus := 0;
  iIndex := lstCIRNLocations.ItemIndex;
  if not CheckHL7TCPLink then begin
    InfoBox('Local HL7 TCP Link is down.' + CRLF + 'Unable to retrieve remote data.', TC_DGSR_ERR, MB_OK);
    lstCIRNLocations.Checked[iIndex] := false;
    Exit;
  end;
  if lstCIRNLocations.Items.Count > 1 then begin
    if piece(lstCIRNLocations.Items[1],'^',1) = '0' then begin
      iAll := 2;
    end;
  end;
  with frmReports do begin
    if piece(uRemoteType,'^',2) = 'V' then begin
      lvReports.Items.BeginUpdate;
      lvReports.Items.Clear;
      lvReports.Columns.Clear;
      lvReports.Items.EndUpdate;
    end;
  end; //with

  uReportInstruction := '';
  frmReports.TabControl1.Tabs.Clear;
  frmLabs.TabControl1.Tabs.Clear;
  frmReports.TabControl1.Tabs.AddObject('Local',nil);
  frmLabs.TabControl1.Tabs.AddObject('Local',nil);
  StatusText('Checking Remote Sites...');
  if piece(lstCIRNLocations.Items[iIndex],'^',1) = '0' then begin// All sites have been clicked
    if lstCIRNLocations.Checked[iIndex] = false then begin// All selection is being turned off
      with RemoteSites.SiteList do begin
        for j := 0 to Count - 1 do begin
          if lstCIRNLocations.Checked[j+1] = true then begin
            lstCIRNLocations.Checked[j+1] := false;
            TRemoteSite(RemoteSites.SiteList[j]).Selected := false;
            TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
            TRemoteSite(RemoteSites.SiteList[j]).LabClear;
          end;
        end;
      end;
    end else begin
      with RemoteSites.SiteList do begin
        for j := 0 to Count - 1 do begin
          Screen.Cursor := crAppStart;  //kt 9/11.  was crHourGlass;
          //CheckRemotePatient(aMsg, Patient.DFN + ';' + Patient.ICN,TRemoteSite(Items[j]).SiteID,  AccessStatus);
          Screen.Cursor := crDefault;
          aMsg := aMsg + ' at site: ' + TRemoteSite(Items[j]).SiteName;
          s := lstCIRNLocations.Items[j+1];
          lstCIRNLocations.Items[j+1] := pieces(s, '^', 1, 3);
          case AccessStatus of
            DGSR_FAIL: begin
                         if piece(aMsg,':',1) = 'RPC name not found at site' then begin//Allow for backward compatibility
                           lstCIRNLocations.Checked[j+1] := true;
                           TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
                           TRemoteSite(RemoteSites.SiteList[j]).LabClear;
                           TRemoteSite(Items[j]).Selected := true;
                         end else begin
                           InfoBox(aMsg, TC_DGSR_ERR, MB_OK);
                           lstCIRNLocations.Checked[j+1] := false;
                           lstCIRNLocations.Items[j+1] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_ERR;
                           TRemoteSite(Items[j]).Selected := false;
                           Continue;
                         end;
                       end;
            DGSR_NONE: begin
                         lstCIRNLocations.Checked[j+1] := true;
                         TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
                         TRemoteSite(RemoteSites.SiteList[j]).LabClear;
                         TRemoteSite(Items[j]).Selected := true;
                       end;
            DGSR_SHOW: begin
                         InfoBox(AMsg, TC_DGSR_SHOW, MB_OK);
                         lstCIRNLocations.Checked[j+1] := true;
                         TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
                         TRemoteSite(RemoteSites.SiteList[j]).LabClear;
                         TRemoteSite(Items[j]).Selected := true;
                       end;
            DGSR_ASK:  if InfoBox(AMsg + TX_DGSR_YESNO, TC_DGSR_SHOW, MB_YESNO or MB_ICONWARNING or MB_DEFBUTTON2) = IDYES then begin
                         lstCIRNLocations.Checked[j+1] := true;
                         TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
                         TRemoteSite(RemoteSites.SiteList[j]).LabClear;
                         TRemoteSite(Items[j]).Selected := true;
                       end else begin
                         lstCIRNLocations.Checked[j+1] := false;
                         lstCIRNLocations.Items[j+1] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_SHOW;
                         TRemoteSite(Items[j]).Selected := false;
                         Continue;
                       end;
            else       begin
                         InfoBox(AMsg, TC_DGSR_DENY, MB_OK);
                         lstCIRNLocations.Checked[j+1] := false;
                         lstCIRNLocations.Items[j+1] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_DENY;
                         TRemoteSite(Items[j]).Selected := false;
                         Continue;
                       end;
          end; // case
        end; //for
      end; //with
    end;
  end else begin
    if iIndex > 0 then begin
      iCur := iIndex - iAll;
      TRemoteSite(RemoteSites.SiteList[iCur]).Selected := lstCIRNLocations.Checked[iIndex];
      if lstCIRNLocations.Checked[iIndex] = true then begin
        with RemoteSites.SiteList do begin
          Screen.Cursor := crAppStart;  //kt 9/11 was crHourGlass;
          //CheckRemotePatient(aMsg, Patient.DFN + ';' + Patient.ICN,TRemoteSite(Items[iCur]).SiteID,  AccessStatus);
          Screen.Cursor := crDefault;
          aMsg := aMsg + ' at site: ' + TRemoteSite(Items[iCur]).SiteName;
          s := lstCIRNLocations.Items[iIndex];
          lstCIRNLocations.Items[iIndex] := pieces(s, '^', 1, 3);
          case AccessStatus of
            DGSR_FAIL: begin
                         if piece(aMsg,':',1) = 'RPC name not found at site' then begin//Allow for backward compatibility
                           lstCIRNLocations.Checked[iIndex] := true;
                           TRemoteSite(RemoteSites.SiteList[iCur]).ReportClear;
                           TRemoteSite(RemoteSites.SiteList[iCur]).LabClear;
                           TRemoteSite(Items[iCur]).Selected := true;
                         end else begin
                           InfoBox(aMsg, TC_DGSR_ERR, MB_OK);
                           lstCIRNLocations.Checked[iIndex] := false;
                           lstCIRNLocations.Items[iIndex] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_ERR;
                           TRemoteSite(Items[iCur]).Selected := false;
                         end;
                       end;
            DGSR_NONE: begin
                         lstCIRNLocations.Checked[iIndex] := true;
                         TRemoteSite(RemoteSites.SiteList[iCur]).ReportClear;
                         TRemoteSite(RemoteSites.SiteList[iCur]).LabClear;
                         TRemoteSite(Items[iCur]).Selected := true;
                       end;
            DGSR_SHOW: begin
                         InfoBox(AMsg, TC_DGSR_SHOW, MB_OK);
                         lstCIRNLocations.Checked[iIndex] := true;
                         TRemoteSite(RemoteSites.SiteList[iCur]).ReportClear;
                         TRemoteSite(RemoteSites.SiteList[iCur]).LabClear;
                         TRemoteSite(Items[iCur]).Selected := true;
                       end;
            DGSR_ASK:  if InfoBox(AMsg + TX_DGSR_YESNO, TC_DGSR_SHOW, MB_YESNO or MB_ICONWARNING or MB_DEFBUTTON2) = IDYES then begin
                         lstCIRNLocations.Checked[iIndex] := true;
                         TRemoteSite(RemoteSites.SiteList[iCur]).ReportClear;
                         TRemoteSite(RemoteSites.SiteList[iCur]).LabClear;
                         TRemoteSite(Items[iCur]).Selected := true;
                       end else begin
                         lstCIRNLocations.Checked[iIndex] := false;
                         lstCIRNLocations.Items[iIndex] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_SHOW;
                       end;
            else       begin
                         InfoBox(AMsg, TC_DGSR_DENY, MB_OK);
                         lstCIRNLocations.Checked[iIndex] := false;
                         lstCIRNLocations.Items[iIndex] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_DENY;
                         TRemoteSite(Items[iCur]).Selected := false;
                       end;
          end; //case
          with frmReports do begin
            if piece(uRemoteType,'^',1) = '1' then begin
              if not(piece(uRemoteType,'^',2) = 'V') then begin
                TabControl1.Visible := true;
                pnlRightTop.Height := lblTitle.Height + TabControl1.Height;
              end;
            end;
          end;
          with frmLabs do begin
            if piece(uRemoteType,'^',1) = '1' then begin
              if not(piece(uRemoteType,'^',2) = 'V') then begin
                TabControl1.Visible := true;
                pnlRightTop.Height := lblTitle.Height + TabControl1.Height;
              end;
            //if lstReports.ItemIndex > -1 then
            //  if piece(lstReports.Items[lstReports.ItemIndex],'^',3) = '1' then
            //    if not(piece(lstReports.Items[lstReports.ItemIndex],'^',5) = 'V') then
            //      TabControl1.Visible := true;
            end;
          end; //with
        end; //with
      end; //if lstCIRNLocations.Checked[iIndex] = true
    end; //if iIndex > 0
  end;


  with RemoteSites.SiteList do begin
    for j := 0 to Count - 1 do begin
      if TRemoteSite(Items[j]).Selected then begin
        frmReports.TabControl1.Tabs.AddObject(TRemoteSite(Items[j]).SiteName,
                                              TRemoteSite(Items[j]));
        frmLabs.TabControl1.Tabs.AddObject(TRemoteSite(Items[j]).SiteName,
                                           TRemoteSite(Items[j]));
      end;
    end;
  end;
  //uReportID, uLabRepID = Report ID's set when report is selected (from file 101.24)
  if not(Piece(uReportID,':',1) = 'OR_VWAL')
    and not(Piece(uReportID,':',1) = 'OR_VWRX')
    and not(Piece(uReportID,':',1) = 'OR_VWVS')
    and (frmReports.tvReports.SelectionCount > 0) then frmReports.tvReportsClick(self);
  if not(uLabRepID = '6:GRAPH') and not(uLabRepID = '5:WORKSHEET')
    and not(uLabRepID = '4:SELECTED TESTS BY DATE')
    and (frmLabs.tvReports.SelectionCount > 0) then frmLabs.tvReportsClick(self);
  //if frmLabs.lstReports.ItemIndex > -1 then frmLabs.ExtlstReportsClick(self, true);
  StatusText('');
end;

procedure TfrmFrame.popCIRNCloseClick(Sender: TObject);
begin
  lstCIRNLocations.Visible := False;
  lstCirnLocations.SendToBack;
  pnlCIRN.BevelOuter := bvRaised;
end;

procedure TfrmFrame.popCIRNSelectAllClick(Sender: TObject);
begin
  lstCIRNLocations.ItemIndex := 0;
  lstCIRNLocations.Checked[0] := true;
  lstCIRNLocations.OnClick(Self);
end;

procedure TfrmFrame.popCIRNSelectNoneClick(Sender: TObject);
begin
  lstCIRNLocations.ItemIndex := 0;
  lstCIRNLocations.Checked[0] := false;
  lstCIRNLocations.OnClick(Self);
end;

procedure TfrmFrame.mnuFilePrintSetupClick(Sender: TObject);
var
  CurrPrt: string;
begin
  CurrPrt := SelectDevice(Self, Encounter.Location, True, 'Print Device Selection');
  User.CurrentPrinter := Piece(CurrPrt, U, 1);
end;

procedure TfrmFrame.lstCIRNLocationsChange(Sender: TObject);
begin
  {if lstCIRNLocations.ItemIndex > 0 then
    if (lstCIRNLocations.Selected[lstCIRNLocations.ItemIndex] = true) and (uUpdateStat = false) then
      if not (piece(lstCIRNLocations.Items[1],'^',1) = '0') then
        lstCIRNLocations.OnClick(nil);
  // Causing Access Violations}
end;

procedure TfrmFrame.LabInfo1Click(Sender: TObject);
begin
  ExecuteLabInfo;
end;

procedure TfrmFrame.mnuFileNotifRemoveClick(Sender: TObject);
const
  TC_REMOVE_ALERT  = 'Remove Current Alert';
  TX_REMOVE_ALERT1 = 'This action will delete the alert you are currently processing; the alert will ' + CRLF +
        'disappear automatically when all orders have been acted on, but this action may' + CRLF +
        'be used to remove the alert if some orders are to be left unchanged.' + CRLF + CRLF +
        'Your ';
  TX_REMOVE_ALERT2 = ' alert for ';
  TX_REMOVE_ALERT3 = ' will be deleted!' + CRLF + CRLF + 'Are you sure?';
var
  AlertMsg, AlertType: string;

  procedure StopProcessingNotifs;
  begin
    Notifications.Clear;
    FNextButtonActive := False;
    stsArea.Panels[2].Bevel := pbLowered;
    mnuFileNext.Enabled := False;
    mnuFileNotifRemove.Enabled := False;
  end;

begin
  if not Notifications.Active then Exit;
  case Notifications.Followup of
    NF_MEDICATIONS_EXPIRING_INPT    : AlertType := 'Expiring Medications';
    NF_MEDICATIONS_EXPIRING_OUTPT   : AlertType := 'Expiring Medications';
    NF_ORDER_REQUIRES_ELEC_SIGNATURE: AlertType := 'Unsigned Orders';
    NF_FLAGGED_ORDERS               : AlertType := 'Flagged Orders (for clarification)';
    NF_UNVERIFIED_MEDICATION_ORDER  : AlertType := 'Unverified Medication Order';
    NF_UNVERIFIED_ORDER             : AlertType := 'Unverified Order';
    NF_FLAGGED_OI_EXP_INPT          : AlertType := 'Flagged Orderable Item (INPT)';
    NF_FLAGGED_OI_EXP_OUTPT         : AlertType := 'Flagged Orderable Item (OUTPT)';
  else
    Exit;
  end;
  AlertMsg := TX_REMOVE_ALERT1 + AlertType + TX_REMOVE_ALERT2 + Patient.Name + TX_REMOVE_ALERT3;
  if InfoBox(AlertMsg, TC_REMOVE_ALERT, MB_YESNO) = ID_YES then begin
    Notifications.DeleteForCurrentUser;
    Notifications.Next;   // avoid prompt if no more alerts selected to process  {v14a RV}
    if Notifications.Active then begin
      if (InfoBox(TX_NOTIF_STOP, TC_NOTIF_STOP, MB_YESNO) = ID_NO) then begin
        Notifications.Prior;
        mnuFileNextClick(Self);
      end else begin
        StopProcessingNotifs;
      end;
    end else begin
      StopProcessingNotifs;
    end;
  end;
end;

procedure TfrmFrame.mnuToolsOptionsClick(Sender: TObject);
// personal preferences - changes may need to be applied to chart
var
  i: integer;
begin
  i := 0;
  DialogOptions(i);
end;

procedure TfrmFrame.mnuUploadImagesClick(Sender: TObject);
begin
  inherited;
  TurnOnUploads := True;
end;

procedure TfrmFrame.LoadUserPreferences;
begin
  LoadSizesForUser;
  GetUserTemplateDefaults(TRUE);
end;

procedure TfrmFrame.SaveUserPreferences;
begin
  SaveSizesForUser;         // position & size settings
  SaveUserTemplateDefaults;
end;

procedure TfrmFrame.sbtnFontChangeClick(Sender: TObject);
//kt added entire function 4/28/21
//Input: It is expected that the TSpeedButtons that have this as OnClick event handler
//       will have .tag property with value of -1, 0, or 1
type
  TSizeMode = (smSmaller=-1, smNormal=0, smLarger=1);
const
  NUM_SIZES = 5;
  ALLOWED_SIZES : array[1..NUM_SIZES] of integer = (8, 10, 12, 14, 18);
var
  ATag              : integer;
  SizeMode          : TSizeMode;
  i                 : integer;
  SizeIdx           : integer;
  CurSize, NewSize  : integer;
  FakeMenuItem      : TMenuItem;

begin
  inherited;
  ATag := TSpeedButton(Sender).Tag;
  if (ATag < -1) or (ATag > 1) then exit; //shouldn't happen.
  SizeMode := TSizeMode(ATag);
  CurSize := MainFontSize();
  NewSize := 0;
  SizeIdx := -1;
  for i := 1 to NUM_SIZES do begin
    if ALLOWED_SIZES[i] <> CurSize then continue;
    SizeIdx := i;
    break;
  end;
  if SizeIdx = -1 then exit;  //shouldn't happen.
  case SizeMode of
    smSmaller : begin
                  Dec(SizeIdx);
                  if SizeIdx < 1 then exit;
                  NewSize := ALLOWED_SIZES[SizeIdx];
                end;
    smNormal  : NewSize := TMGInitialFontSize;
    smLarger  : begin
                   Inc(SizeIdx);
                   if SizeIdx > NUM_SIZES then exit;
                   NewSize := ALLOWED_SIZES[SizeIdx];
                end;
  end; {case}
  try
    FakeMenuItem := TMenuItem.Create(Self);
    FakeMenuItem.Tag := NewSize;
    mnuFontSizeClick(FakeMenuItem);
  finally
    FakeMenuItem.Free;
  end;
end;

procedure TfrmFrame.mnuFileRefreshClick(Sender: TObject);
begin
  FRefreshing := TRUE;
  try
    mnuFileOpenClick(Self);
  finally
    FRefreshing := FALSE;
    OrderPrintForm := FALSE;
  end;
end;

procedure TfrmFrame.AppActivated(Sender: TObject);
begin
  if assigned(FOldActivate) then begin
    FOldActivate(Sender);
  end;
  SetActiveWindow(Application.Handle);
  if ScreenReaderSystemActive and assigned(Patient) and (Patient.Name <> '') and (Patient.Status <> '') then begin
    SpeakTabAndPatient;
  end;
end;

// close Treatment Factor hint window if alt-tab pressed.
procedure TfrmFrame.AppDeActivated(Sender: TObject);
begin
  if FRVTFhintWindowActive then begin
    FRVTFHintWindow.ReleaseHandle;
    FRVTFHintWindowActive := False;
  end else if FOSTFHintWndActive then begin
    FOSTFhintWindow.ReleaseHandle;
    FOSTFHintWndActive := False ;
  end;
  if FHintWinActive then begin   // graphing - hints on values
    FHintWin.ReleaseHandle;
    FHintWinActive := false;
  end;
end;


procedure TfrmFrame.CreateTab(ASide: TTabPageSide; ATabID: integer; ALabel: string);  //kt-tabs
var TempFrmWebTab : TfrmWebTab;  //kt 9/11 added
    HolderPanel : TPanel;   //kt-tabs
    ATabPage : TTabControl; //kt-tabs
    APageSide: TTabPageSide;  //kt-tabs
begin
  //  old comment - try making owner self (instead of application) to see if solves TMenuItem.Insert bug
  HolderPanel := PnlPage[ASide]; //kt-tabs
  case ATabID of
    CT_PROBLEMS : begin
                    frmProblems := TfrmProblems.Create(Self);
                    frmProblems.Parent := HolderPanel;
                  end;
    CT_MEDS     : begin
                    frmMeds := TfrmMeds.Create(Self);
                    frmMeds.Parent := HolderPanel;
                    frmMeds.InitfMedsSize;
                  end;
    CT_ORDERS   : begin
                    frmOrders := TfrmOrders.Create(Self);
                    frmOrders.Parent := HolderPanel;
                  end;
    CT_HP       : begin
                    // not yet
                  end;
    CT_NOTES    : begin
                    frmNotes := TfrmNotes.Create(Self);
                    frmNotes.Parent := HolderPanel;
                    //kt Note: The following two lines must be done **AFTER**
                    //         the assigment of Parent to HolderPanel.  Otherwise
                    //         the ActiveX object looses its attachement point
                    //         or something and the document objects turns nil.
                    frmNotes.HtmlViewer.Loaded;  //kt 9/11
                    frmNotes.HtmlEditor.Loaded;  //kt 9/11
                  end;
    CT_CONSULTS : begin
                    frmConsults := TfrmConsults.Create(Self);
                    frmConsults.Parent := HolderPanel;
                  end;
    CT_DCSUMM   : begin
                    frmDCSumm := TfrmDCSumm.Create(Self);
                    frmDCSumm.Parent := HolderPanel;
                  end;
    CT_LABS     : begin
                    frmLabs := TfrmLabs.Create(Self);
                    frmLabs.Parent := HolderPanel;
                  end;
    CT_REPORTS  : begin
                    frmReports := TfrmReports.Create(Self);
                    frmReports.Parent := HolderPanel;
                  end;
    CT_SURGERY  : begin
                    frmSurgery := TfrmSurgery.Create(Self);
                    frmSurgery.Parent := HolderPanel;
                  end;
    CT_COVER    : begin
                    frmCover := TfrmCover.Create(Self);
                    frmCover.Parent := HolderPanel;
                  end;
    CT_IMAGES  : begin                                                //kt 9/11
                    frmImages := TfrmImages.Create(Self);             //kt 9/11
                    frmImages.Parent := HolderPanel;                  //kt 9/11
                  end;                                                //kt 9/11
    CT_MAILBOX : begin                                                //kt 9/11
                    frmMailbox := TfrmMailbox.Create(Self);           //kt 9/11
                    frmMailbox.Parent := HolderPanel;                 //kt 9/11
                  end;                                                //kt 9/11
    CT_WEBTAB1..CT_LAST_WEBTAB : begin                                //kt 9/11
                    TempFrmWebTab := TfrmWebTab.Create(Self);         //kt 9/11
                    TempFrmWebTab.Parent := HolderPanel;              //kt 9/11
                    Application.ProcessMessages;                      //kt 8/5/17
                    TempFrmWebTab.WebBrowser.Loaded;                  //kt 8/5/17
                    TempFrmWebTab.NagivateTo('about:blank');          //kt 8/5/17
                    WebTabsList[ATabID-CT_WEBTAB1] := TempFrmWebTab;  //kt 9/11
                  end;                                                //kt 9/11
    else {case}
      Exit;
  end; {case}

  if ATabID = CT_COVER then begin
    uTabList.Insert(0, IntToStr(ATabID));
    for APageSide := tpsLeft to tpsRight do begin  //insert all tabs into both tab controllers.       //kt-tabs
      ATabPage := FTabPage[APageSide];
      ATabPage.Tabs.Insert(0, ALabel);
      ATabPage.TabIndex := 0;
    end;
  end else begin
    uTabList.Add(IntToStr(ATabID));
    for APageSide := tpsLeft to tpsRight do begin  //insert all tabs into both tab controllers.       //kt-tabs
      ATabPage := FTabPage[APageSide];
      ATabPage.Tabs.Add(ALabel);
    end;
  end;
  TabColorsList.Add(IntToStr(ATabID));  //will put colors in later...  //kt 9/11
end;

procedure TfrmFrame.LoadTabColors(ColorsList : TStringList);
//kt 9/11 added
var i : integer;
    sValue : string;
    value : longword;
    DefColor : integer;
const
  DEF_COLORS : array[0..11] of integer =
    (255,
     33023,
     16711935,
     65280,
     65535,
     65535,
     8388736,
     16776960,
     16512,
     65535,
     65535,
     65535 );
begin
  value :=0;
  TabColorsEnabled := uTMGOptions.ReadBool('TAB_COLORS ENABLE',true);
  for i := 0 to ColorsList.Count-1 do begin
    if i <= 11 then DefColor := DEF_COLORS[i]
    else DefColor := ($00FFFF);
    sValue := uTMGOptions.ReadString('Tab '+IntToStr(i)+' Color',inttostr(DefColor));
    try
      value := StrToInt(sValue)
    except
      on EConvertError do value := $00FFFF;
    end;
    ColorsList.Objects[i] := pointer(value);
  end;
end;

procedure TfrmFrame.SaveTabColors(ColorsList : TStringList);
//kt 9/11 added
var i : integer;
begin
  for i := 0 to ColorsList.Count-1 do begin
    uTMGOptions.WriteInteger('Tab '+IntToStr(i)+' Color',longword(ColorsList.Objects[i]));
  end;
  uTMGOptions.WriteBool('TAB_COLORS ENABLE',TabColorsEnabled); //kt 8/09
end;

procedure TfrmFrame.ShowHideChartTabMenus(AMenuItem: TMenuItem);
var
  i: integer;
begin
  for i := 0 to AMenuItem.Count - 1 do begin
    AMenuItem.Items[i].Visible := TabExists(AMenuItem.Items[i].Tag);
  end;
end;

function TfrmFrame.TabExists(ATabID: integer): boolean;
begin
  Result := (uTabList.IndexOf(IntToStr(ATabID)) > -1)
end;

procedure TfrmFrame.ReportsOnlyDisplay;
begin
  // Configure "Edit" menu:
  menuHideAllBut(mnuEdit, mnuEditPref);     // Hide everything under Edit menu except Preferences.
  menuHideAllBut(mnuEditPref, Prefs1); // Hide everything under Preferences menu except Fonts.

  // Remaining pull-down menus:
  mnuView.visible := false;
  mnuFileRefresh.visible := false;
  mnuFileEncounter.visible := false;
  mnuFileReview.visible := false;
  mnuFileNext.visible := false;
  mnuFileNotifRemove.visible := false;
  mnuHelpBroker.visible := false;
  mnuHelpLists.visible := false;
  mnuHelpSymbols.visible := false;

  // Top panel components:
  pnlVisit.hint := 'Provider/Location';
  pnlVisit.onMouseDown := nil;
  pnlVisit.onMouseUp := nil;

  // Forms for other tabs:
  frmCover.visible := false;
  frmProblems.visible := false;
  frmMeds.visible := false;
  frmOrders.visible := false;
  frmNotes.visible := false;
  frmConsults.visible := false;
  frmDCSumm.visible := false;
  if Assigned(frmSurgery) then
    frmSurgery.visible := false;
  frmLabs.visible := false;

  // Other tabs (so to speak):
  FTabPage[tpsLeft].tabs.clear;
  FTabPage[tpsLeft].tabs.add('Reports');
  FTabPage[tpsRight].tabs.clear;

end;

procedure TfrmFrame.UpdatePtInfoOnRefresh;
var
  tmpDFN: string;
begin
  tmpDFN := Patient.DFN;
  Patient.Clear;
  Patient.DFN := tmpDFN;
  uCore.TempEncounterLoc := 0;  //hds7591  Clinic/Ward movement.
  uCore.TempEncounterLocName := ''; //hds7591  Clinic/Ward movement.
  uCore.TempEncounterText := '';
  uCore.TempEncounterDateTime := 0;
  uCore.TempEncounterVistCat := #0;
  if (not FRefreshing) and (FReviewClick = false) then DoNotChangeEncWindow := false;
  if (FPrevInPatient and Patient.Inpatient) then begin                //transfering inside hospital
    if FReviewClick = True then begin
      ucore.TempEncounterLoc := Encounter.Location;
      uCore.TempEncounterLocName := Encounter.LocationName;
      uCore.TempEncounterText := Encounter.LocationText;
      uCore.TempEncounterDateTime := Encounter.DateTime;
      uCore.TempEncounterVistCat := Encounter.VisitCategory;
    end else if (patient.Location <> encounter.Location) and (OrderPrintForm = false) then begin
      frmPrintLocation.SwitchEncounterLoction(Encounter.Location, Encounter.locationName, Encounter.LocationText,
                                              Encounter.DateTime, Encounter.VisitCategory);
      DisplayEncounterText;
      exit;
    end else if (patient.Location <> encounter.Location) and (OrderPrintForm = True) then begin
      OrderPrintForm := false;
      Exit;
    end;
    if orderprintform = false then Encounter.Location := Patient.Location;
  end else if (FPrevInPatient and (not Patient.Inpatient)) then begin     //patient was discharged
    Encounter.Inpatient := False;
    Encounter.Location := 0;
    FPrevInPatient := False;
    lblPtName.Caption := '';
    lblPtName.Caption := Patient.Name + Patient.Status; //CQ #17491: Refresh patient status indicator in header bar on discharge.
  end else if ((not FPrevInPatient) and Patient.Inpatient) then begin     //patient was admitted
    Encounter.Inpatient := True;
    uCore.TempEncounterLoc := Encounter.Location;  //hds7591  Clinic/Ward movement.
    uCore.TempEncounterLocName := Encounter.LocationName; //hds7591  Clinic/Ward movement.
    uCore.TempEncounterText := Encounter.LocationText;
    uCore.TempEncounterDateTime := Encounter.DateTime;
    uCore.TempEncounterVistCat := Encounter.VisitCategory;
    lblPtName.Caption := '';
    lblPtName.Caption := Patient.Name + Patient.Status; //CQ #17491: Refresh patient status indicator in header bar on admission.
    if (FReviewClick = False) and (encounter.Location <> patient.Location) and (OrderPrintForm = false) then begin
      frmPrintLocation.SwitchEncounterLoction(Encounter.Location, Encounter.locationName, Encounter.LocationText,
                                            Encounter.DateTime, Encounter.VisitCategory);
      //agp values are reset depending on the user process
      uCore.TempEncounterLoc := 0;  //hds7591  Clinic/Ward movement.
      uCore.TempEncounterLocName := ''; //hds7591  Clinic/Ward movement.
      uCore.TempEncounterText := '';
      uCore.TempEncounterDateTime := 0;
      uCore.TempEncounterVistCat := #0;
    end else if OrderPrintForm = false then begin
      Encounter.Location := Patient.Location;
      Encounter.DateTime := Patient.AdmitTime;
      Encounter.VisitCategory := 'H';
    end;
    FPrevInPatient := True;
  end;
  //if User.IsProvider then Encounter.Provider := ;
  DisplayEncounterText;
end;

procedure TfrmFrame.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NewTabIndex: integer;
  tempTabPage : TTabControl;
begin
  inherited;
  FCtrlTabUsed := FALSE;
  //CQ2844: Toggle Remote Data button using Alt+R
   case Key of
     82,114:  if (ssAlt in Shift) then
                 frmFrame.pnlCIRNClick(Sender);
     end;

  if (Key = VK_TAB) then begin
    if (ssCtrl in Shift) then begin
      FCtrlTabUsed := TRUE;
      if not (ActiveControl is TCustomMemo) or not TMemo(ActiveControl).WantTabs then begin
        tempTabPage := FTabPage[tpsLeft];
        NewTabIndex := tempTabPage.TabIndex;
        if ssShift in Shift then begin
          dec(NewTabIndex)
        end else begin
          inc(NewTabIndex);
        end;
        if NewTabIndex >= tempTabPage.Tabs.Count then begin
          dec(NewTabIndex, tempTabPage.Tabs.Count)
        end else if NewTabIndex < 0 then begin
          inc(NewTabIndex, tempTabPage.Tabs.Count);
        end;
        tempTabPage.TabIndex := NewTabIndex;
        tabPageChange(tpsLeft);
                Key := 0;
      end;
    end;
  end;
end;

procedure TfrmFrame.FormActivate(Sender: TObject);
var Location: string;
begin
  //kt begin mod ------------------
  if PersonHasKey(user.DUZ,'VEFA ADT ACCESS') then begin
    mnuADT.enabled := True;
  end else begin
   // mnuADT.enabled := false;
  end;
  //Location := uTMGOptions.ReadString('SpecialLocation','');
  Location := TMGSpecialLocation;  //kt 10/15
  if Location='INTRACARE' then begin  //kt 9/11
    mnuPrintAdmissionLabel.Visible := True;                      //kt 9/11
    mnuADT.visible := True;                                    //kt 9/11
    mnuBillableItems.visible := False;
  end else begin                                               //kt 9/11
    mnuPrintAdmissionLabel.Visible := False;                     //kt 9/11
   // mnuADT.visible := False;                                   //kt 9/11
    mnuBillableItems.visible := True;
  end;
  if (Location='MSP') OR (Location='INTRACARE') then begin  //erx 2/14
    N2.Visible := true;
    eprescribing1.visible := true;
    eprescribing1.Enabled := True;
  end;
  if (Location='FPG') OR (Location='INTRACARE') then begin
    mnuChangeES.Visible := True;
  end else begin
    mnuChangeES.Visible := False;
  end;
  //kt end mod ------------------
  if Assigned(FLastPage[tpsLeft]) then
    FLastPage[tpsLeft].FocusFirstControl;
end;

procedure TfrmFrame.pnlPrimaryCareEnter(Sender: TObject);
begin
  with Sender as TPanel do begin
    if (ControlCount > 0) and (Controls[0] is TSpeedButton) and (TSpeedButton(Controls[0]).Down) then begin
      BevelInner := bvLowered
    end else begin
      BevelInner := bvRaised;
    end;
  end;
end;

procedure TfrmFrame.pnlPrimaryCareExit(Sender: TObject);
var
  ShiftIsDown,TabIsDown : boolean;
begin
  with Sender as TPanel do begin
    BevelInner := bvNone;
    //Make the lstCIRNLocations act as if between pnlCIRN & pnlReminders
    //in the Tab Order
    if (lstCIRNLocations.CanFocus) then begin
      ShiftIsDown := Boolean(Hi(GetKeyState(VK_SHIFT)));
      TabIsDown := Boolean(Hi(GetKeyState(VK_TAB)));
      if TabIsDown then begin
        if (ShiftIsDown) and (Name = 'pnlReminders') then begin
          lstCIRNLocations.SetFocus
        end else if Not (ShiftIsDown) and (Name = 'pnlCIRN') then begin
          lstCIRNLocations.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TfrmFrame.pnlPatientClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass; //wat cq 18425 added hourglass and disabled mnuFileOpen
  mnuFileOpen.Enabled := False;
  try
    pnlPatient.Enabled := false;
    ViewInfo(mnuViewDemo);
    pnlPatient.Enabled := true;
  finally
    Screen.Cursor := crDefault;
    mnuFileOpen.Enabled := True;
  end;
end;

procedure TfrmFrame.pnlVisitClick(Sender: TObject);
begin
 //if (not User.IsReportsOnly) then // Reports Only tab.
 //  mnuFileEncounterClick(Self);
  ViewInfo(mnuViewVisits);
end;

procedure TfrmFrame.pnlPrimaryCareClick(Sender: TObject);
//begin
  //ReportBox(DetailPrimaryCare(Patient.DFN), 'Primary Care', True);
  //elh   3/20/17  ViewInfo(mnuViewPrimaryCare);
  
  procedure ParseOneLine(s : string; Lines : TStrings);
  var FMStr : string;
      TempS : string;
  begin
    FMStr := piece(s,'^',1);
    TempS := 'Note on ' + FormatFMDateTime('MM/DD/YY', MakeFMDateTime(FMStr));
    TempS := TempS + ' --> ';
    FMStr := piece(s,'^',2);
    if FMStr = '1' then FMStr := 'Inexact '
    else if FMStr = '-1' then FMStr := '??/??/??'
    else FMStr := FormatFMDateTime('MM/DD/YY', MakeFMDateTime(FMStr));
    TempS := TempS + 'followup due: ' + FMStr;
    //Lines.Add(TempS);
    TempS := TempS + '  "' + piece(s,'^',3) + '"';
    Lines.Add(TempS);
  end;

var i,j : integer;
    OneLine : String;
    frmMemoEdit: TfrmMemoEdit;

begin
  inherited;
  //MessageDlg('Here I can display info',mtInformation,[mbOK],0);
  frmMemoEdit := TfrmMemoEdit.Create(Self);
  frmMemoEdit.lblMessage.Caption := 'Upcoming appointment and follow up detail below.';
  frmMemoEdit.Caption := 'Upcoming appointment and follow up details.';
  //frmMemoEdit.memEdit.Lines.add('Upcoming appt information:');
  for j := 1 to NumPieces(lblPtCare.Caption,';') do begin
    frmMemoEdit.memEdit.Lines.add(piece(lblPtCare.Caption,';',j));
  end;
  frmMemoEdit.memEdit.Lines.add(' ');
  frmMemoEdit.memEdit.Lines.add('Follow up detail:');
  for i := Patient.DueInfo.Count - 1 downto 2 do begin
    OneLine := Patient.DueInfo.Strings[i];
    ParseOneLine(OneLine, frmMemoEdit.memEdit.Lines);
  end;
  if frmMemoEdit.memEdit.Lines.Count = 0 then begin
    frmMemoEdit.memEdit.Lines.Add('(No information to display)');
  end;
  frmMemoEdit.memEdit.ScrollBars := ssBoth;
  frmMemoEdit.memEdit.WordWrap := False;
  frmMemoEdit.ShowModal;
  FreeAndNil(frmMemoEdit);
end;

procedure TfrmFrame.pnlRemindersClick(Sender: TObject);
begin
  if(pnlReminders.tag = HAVE_REMINDERS) then begin
    ViewInfo(mnuViewReminders);
  end;
end;

procedure TfrmFrame.pnlPostingsClick(Sender: TObject);
begin
  ViewInfo(mnuViewPostings);
end;

//=========================== CCOW main changes ========================

procedure TfrmFrame.HandleCCOWError(AMessage: string);
begin
  {$ifdef DEBUG}
    Show508Message(AMessage);
  {$endif}
  InfoBox(TX_CCOW_ERROR, TC_CCOW_ERROR, MB_ICONERROR or MB_OK);
  FCCOWInstalled := False;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, 'BMP_CCOW_BROKEN');
  pnlCCOW.Hint := TX_CCOW_BROKEN;
  mnuFileResumeContext.Visible := True;
  mnuFileResumeContext.Enabled := False;
  mnuFileBreakContext.Visible := True;
  mnuFileBreakContext.Enabled := False;
  FCCOWError := True;
end;

function TfrmFrame.AllowCCOWContextChange(var CCOWResponse: UserResponse; NewDFN: string): boolean;
//kt made formatting changes.
var
  PtData : IContextItemCollection;
  PtDataItem2, PtDataItem3, PtDataItem4 : IContextItem;
  response : UserResponse;
  StationNumber: string;
  IsProdAcct: boolean;
begin
  Result := False;
  response := 0;
  try
    // Start a context change transaction
    if FCCOWInstalled then begin
      FCCOWError := False;
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, 'BMP_CCOW_CHANGING');
      pnlCCOW.Hint := TX_CCOW_CHANGING;
      try
        ctxContextor.StartContextChange();
      except
        on E: Exception do HandleCCOWError(E.Message);
      end;
      if FCCOWError then begin
        Result := False;
        Exit;
      end;
      // Set the new proposed context data.
      PtData := CoContextItemCollection.Create();
      StationNumber := User.StationNumber;
      IsProdAcct := User.IsProductionAccount;

      {$IFDEF CCOWBROKER}
      //IsProdAcct := RPCBrokerV.Login.IsProduction;  //not yet
      {$ENDIF}

      PtDataItem2 := CoContextItem.Create();
      PtDataItem2.Set_Name('Patient.co.PatientName');                // Patient.Name
      PtDataItem2.Set_Value(Piece(Patient.Name, ',', 1) + U + Piece(Patient.Name, ',', 2) + '^^^^');
      PtData.Add(PtDataItem2);

      PtDataItem3 := CoContextItem.Create();
      if not IsProdAcct then begin
        PtDataItem3.Set_Name('Patient.id.MRN.DFN_' + StationNumber + '_TEST')    // Patient.DFN
      end else begin
        PtDataItem3.Set_Name('Patient.id.MRN.DFN_' + StationNumber);             // Patient.DFN
      end;
      PtDataItem3.Set_Value(Patient.DFN);
      PtData.Add(PtDataItem3);

      if Patient.ICN <> '' then begin
        PtDataItem4 := CoContextItem.Create();
        if not IsProdAcct then begin
          PtDataItem4.Set_Name('Patient.id.MRN.NationalIDNumber_TEST')   // Patient.ICN
        end else begin
          PtDataItem4.Set_Name('Patient.id.MRN.NationalIDNumber');       // Patient.ICN
        end;
        PtDataItem4.Set_Value(Patient.ICN);
        PtData.Add(PtDataItem4);
      end;

      // End the context change transaction.
      FCCOWError := False;
      try
        response := ctxContextor.EndContextChange(true, PtData);
      except
        on E: Exception do HandleCCOWError(E.Message);
      end;
      if FCCOWError then begin
        HideEverything;
        Result := False;
        Exit;
      end;
    end else begin //response := urBreak;
      Result := True;
      Exit;
    end;

    CCOWResponse := response;
    if (response = UrCommit) then begin
      // New context is committed.
      //Show508Message('Response was Commit');
      mnuFileResumeContext.Enabled := False;
      mnuFileBreakContext.Enabled := True;
      FCCOWIconName := 'BMP_CCOW_LINKED';
      pnlCCOW.Hint := TX_CCOW_LINKED;
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
      Result := True;
    end else if (response = UrCancel) then begin
      // Proposed context change is canceled. Return to the current context.
      PtData.RemoveAll;
      mnuFileResumeContext.Enabled := False;
      mnuFileBreakContext.Enabled := True;
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
      Result := False;
    end else if (response = UrBreak) then begin
      // The contextor has broken the link by suspending.  This app should
      // update the Clinical Link icon, enable the Resume menu item, and
      // disable the Suspend menu item.
      PtData.RemoveAll;
      mnuFileResumeContext.Enabled := True;
      mnuFileBreakContext.Enabled := False;
      FCCOWIconName := 'BMP_CCOW_BROKEN';
      pnlCCOW.Hint := TX_CCOW_BROKEN;
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
      if Patient.Inpatient then begin
        Encounter.Inpatient := True;
        Encounter.Location := Patient.Location;
        Encounter.DateTime := Patient.AdmitTime;
        Encounter.VisitCategory := 'H';
      end;
      if User.IsProvider then Encounter.Provider := User.DUZ;
      SetupPatient;
      FTabPage[tpsLeft].TabIndex := PageIDToTab(User.InitialTab);
      tabPageChange(tpsLeft);
      Result := False;
    end;
  except
    on exc : EOleException do begin
      //Show508Message('EOleException: ' + exc.Message + ' - ' + string(exc.ErrorCode) );
      ShowMsg('EOleException: ' + exc.Message);
    end;
  end;
end;

procedure TfrmFrame.ctxContextorCanceled(Sender: TObject);
begin
  // Application should maintain its state as the current (existing) context.
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
end;

procedure TfrmFrame.ctxContextorPending(Sender: TObject;
  const aContextItemCollection: IDispatch);
var
  Reason, HyperLinkReason: string;
  PtChanged: boolean;
{$IFDEF CCOWBROKER}
  UserChanged: boolean;
{$ENDIF}
begin
  // If the app would lose data, or have other problems changing context at
  // this time, it should return a message using SetSurveyReponse. Note that the
  // user may decide to commit the context change anyway.
  //
  // if (cannot-change-context-without-a-problem) then
  //   contextor.SetSurveyResponse('Conditional accept reason...');
  if FCCOWBusy then begin
    Sleep(10000);
  end;

  FCCOWError := False;
  try
    CheckForDifferentPatient(aContextItemCollection, PtChanged);
{$IFDEF CCOWBROKER}
    CheckForDifferentUser(aContextItemCollection, UserChanged);
{$ENDIF}
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then begin
    HideEverything;
    Exit;
  end;

{$IFDEF CCOWBROKER}
  if PtChanged or UserChanged then begin
{$ELSE}
  if PtChanged then begin
{$ENDIF}
    FCCOWContextChanging := True;
    imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, 'BMP_CCOW_CHANGING');
    pnlCCOW.Hint := TX_CCOW_CHANGING;
    AllowContextChangeAll(Reason);
  end;
  CheckHyperlinkResponse(aContextItemCollection, HyperlinkReason);
  Reason := HyperlinkReason + Reason;
  if Pos('COM_OBJECT_ACTIVE', Reason) > 0 then begin
    Sleep(12000)
  end else if Length(Reason) > 0 then begin
    ctxContextor.SetSurveyResponse(Reason)
  end else begin
    imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, 'BMP_CCOW_LINKED');
    pnlCCOW.Hint := TX_CCOW_LINKED;
  end;
  FCCOWContextChanging := False;
end;

procedure TfrmFrame.ctxContextorCommitted(Sender: TObject);
var
  Reason: string;
  PtChanged: boolean;
  i: integer;
begin
  // Application should now access the new context and update its state.
  FCCOWError := False;
  try
  {$IFDEF CCOWBROKER}
    with RPCBrokerV do if (WasUserDefined and IsUserCleared and (ctxContextor.CurrentContext.Present(CCOW_USER_NAME) = nil)) then begin   // RV 05/11/04
      Reason := 'COMMIT';
      if AllowContextChangeAll(Reason) then begin
        Close;
        Exit;
      end;
    end;
  {$ENDIF}
    CheckForDifferentPatient(ctxContextor.CurrentContext, PtChanged);
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then begin
    HideEverything;
    Exit;
  end;
  if not PtChanged then exit;
  // HideEverything('Retrieving information - please wait....'); // v27 (pending) RV
  FCCOWDrivedChange := True;
  i := 0;
  while Length(Screen.Forms[i].Name) > 0 do begin
    if fsModal in Screen.Forms[i].FormState then begin
      Screen.Forms[i].ModalResult := mrCancel;
      i := i + 1;
    end else begin  // the fsModal forms always sequenced prior to the none-fsModal forms
      Break;
    end;
  end;
  Reason := 'COMMIT';
  if AllowContextChangeAll(Reason) then UpdateCCOWContext;
  FCCOWIconName := 'BMP_CCOW_LINKED';
  pnlCCOW.Hint := TX_CCOW_LINKED;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
  // ShowEverything;    // v27 (pending) RV
end;

//function TfrmFrame.FindBestCCOWDFN(var APatientName: string): string;
function TfrmFrame.FindBestCCOWDFN: string;
var
  data: IContextItemCollection;
  anItem: IContextItem;
  StationNumber, tempDFN: string;
  IsProdAcct:  Boolean;

  procedure FindNextBestDFN;
  begin
    StationNumber := User.StationNumber;
    if IsProdAcct then begin
      anItem := data.Present('Patient.id.MRN.DFN_' + StationNumber)
    end else begin
      anItem := data.Present('Patient.id.MRN.DFN_' + StationNumber + '_TEST');
    end;
    if anItem <>  nil then tempDFN := anItem.Get_Value();
  end;

begin
  if uCore.User = nil then begin
    Result := '';
    exit;
  end;
  IsProdAcct := User.IsProductionAccount;
  {$IFDEF CCOWBROKER}
  //IsProdAcct := RPCBrokerV.Login.IsProduction;  //not yet
  {$ENDIF}
  // Get an item collection of the current context
  FCCOWError := False;
  try
    data := ctxContextor.CurrentContext;
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then begin
    HideEverything;
    Exit;
  end;
  // Retrieve the ContextItem name and value as strings
  if IsProdAcct then begin
    anItem := data.Present('Patient.id.MRN.NationalIDNumber')
  end else begin
    anItem := data.Present('Patient.id.MRN.NationalIDNumber_TEST');
  end;
  if anItem <> nil then begin
    tempDFN := GetDFNFromICN(anItem.Get_Value());			 // "Public" RPC call
    if tempDFN = '-1' then FindNextBestDFN;
  end else begin
    FindNextBestDFN;
  end;
  Result := tempDFN;
(*  anItem := data.Present('Patient.co.PatientName');
  if anItem <> nil then APatientName := anItem.Get_Value();*)
  data := nil;
  anItem := nil;
end;

procedure TfrmFrame.UpdateCCOWContext;
var
  PtDFN(*, PtName*): string;
begin
  if not FCCOWInstalled then exit;
  DoNotChangeEncWindow := false;
  //PtDFN := FindBestCCOWDFN(PtName);
  PtDFN := FindBestCCOWDFN;
  if StrToInt64Def(PtDFN, 0) > 0 then begin
    // Select new patient based on context value
    if Patient.DFN = PtDFN then exit;
    Patient.DFN := PtDFN;
    //if (Patient.Name = '-1') or (PtName <> Piece(Patient.Name, ',', 1) + U + Piece(Patient.Name, ',', 2) + '^^^^') then
    if (Patient.Name = '-1') then begin
      HideEverything;
      exit;
    end else
      ShowEverything;
    Encounter.Clear;
    if Patient.Inpatient then begin
      Encounter.Inpatient := True;
      Encounter.Location := Patient.Location;
      Encounter.DateTime := Patient.AdmitTime;
      Encounter.VisitCategory := 'H';
    end;
    if User.IsProvider then Encounter.Provider := User.DUZ;
    if not FFirstLoad then SetupPatient;
    frmCover.UpdateVAAButton; //VAA
    DetermineNextTab(tpsLeft);
    FTabPage[tpsLeft].TabIndex := PageIDToTab(NextTab[tpsLeft]);
    tabPageChange(tpsLeft);
  end else
    HideEverything;
end;

procedure TfrmFrame.mnuFileBreakContextClick(Sender: TObject);
begin
  FCCOWError := False;
  FCCOWIconName := 'BMP_CCOW_CHANGING';
  pnlCCOW.Hint := TX_CCOW_CHANGING;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
  try
    ctxContextor.Suspend;
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then exit;
  FCCOWIconName := 'BMP_CCOW_BROKEN';
  pnlCCOW.Hint := TX_CCOW_BROKEN;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
  mnuFileResumeContext.Enabled := True;
  mnuFileBreakContext.Enabled := False;
end;

procedure TfrmFrame.mnuFileResumeContextGetClick(Sender: TObject);
var
  Reason: string;
begin
  Reason := '';
  if not AllowContextChangeAll(Reason) then exit;
  FCCOWIconName := 'BMP_CCOW_CHANGING';
  pnlCCOW.Hint := TX_CCOW_CHANGING;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
  FCCOWError := False;
  try
    ctxContextor.Resume;
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then exit;
  UpdateCCOWContext;
  if not FNoPatientSelected then begin
    FCCOWIconName := 'BMP_CCOW_LINKED';
    pnlCCOW.Hint := TX_CCOW_LINKED;
    imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
    mnuFileResumeContext.Enabled := False;
    mnuFileBreakContext.Visible := True;
    mnuFileBreakContext.Enabled := True;
  end;
end;

procedure TfrmFrame.mnuFileResumeContextSetClick(Sender: TObject);
var
  CCOWResponse: UserResponse;
  Reason: string;
begin
  Reason := '';
  if not AllowContextChangeAll(Reason) then exit;
  FCCOWIconName := 'BMP_CCOW_CHANGING';
  pnlCCOW.Hint := TX_CCOW_CHANGING;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
  FCCOWError := False;
  try
    ctxContextor.Resume;
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then exit;
  if (AllowCCOWContextChange(CCOWResponse, Patient.DFN)) then begin
    mnuFileResumeContext.Enabled := False;
    mnuFileBreakContext.Visible := True;
    mnuFileBreakContext.Enabled := True;
    FCCOWIconName := 'BMP_CCOW_LINKED';
    pnlCCOW.Hint := TX_CCOW_LINKED;
    imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
  end else begin
    mnuFileResumeContext.Enabled := True;
    mnuFileBreakContext.Enabled := False;
    FCCOWIconName := 'BMP_CCOW_BROKEN';
    pnlCCOW.Hint := TX_CCOW_BROKEN;
    imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
    try
      if ctxContextor.State in [csParticipating] then ctxContextor.Suspend;
    except
      on E: Exception do HandleCCOWError(E.Message);
    end;
  end;
  SetupPatient;
  FTabPage[tpsLeft].TabIndex := PageIDToTab(User.InitialTab);
  tabPageChange(tpsLeft);
end;

procedure TfrmFrame.CheckForDifferentPatient(aContextItemCollection: IDispatch; var PtChanged: boolean);
var
  data : IContextItemCollection;
  anItem: IContextItem;
  PtDFN, PtName: string;
begin
  if uCore.Patient = nil then begin
    PtChanged := False;
    Exit;
  end;
  data := IContextItemCollection(aContextItemCollection) ;
  //PtDFN := FindBestCCOWDFN(PtName);
  PtDFN := FindBestCCOWDFN;
  // Retrieve the ContextItem name and value as strings
  anItem := data.Present('Patient.co.PatientName');
  if anItem <> nil then PtName := anItem.Get_Value();
  PtChanged := not ((PtDFN = Patient.DFN) and (PtName = Piece(Patient.Name, ',', 1) + U + Piece(Patient.Name, ',', 2) + '^^^^'));
end;

{$IFDEF CCOWBROKER}
procedure TfrmFrame.CheckForDifferentUser(aContextItemCollection: IDispatch; var UserChanged: boolean);
var
  data : IContextItemCollection;
begin
  if uCore.User = nil then begin
    UserChanged := False;
    Exit;
  end;
  data := IContextItemCollection(aContextItemCollection) ;
  UserChanged := RPCBrokerV.IsUserContextPending(data);
end;
{$ENDIF}

procedure TfrmFrame.CheckHyperlinkResponse(aContextItemCollection: IDispatch; var HyperlinkReason: string);
//kt made formatting changes.
var
  data : IContextItemCollection;
  anItem : IContextItem;
  itemvalue: string;
  PtSubject: string;
begin
  data := IContextItemCollection(aContextItemCollection) ;
  anItem := data.Present('[hds_med_domain]request.id.name');
  // Retrieve the ContextItem name and value as strings
  if anItem <> nil then begin
    itemValue := anItem.Get_Value();
    if itemValue = 'GetWindowHandle' then begin
      PtSubject := 'patient.id.mrn.dfn_' + User.StationNumber;
      if not User.IsProductionAccount then PtSubject := PtSubject + '_test';
      if data.Present(PtSubject) <> nil then begin
        HyperlinkReason := '!@#$' + IntToStr(Self.Handle) + ':0:'
      end else begin
        HyperlinkReason := '';
      end;
    end;
  end;
end;

procedure TfrmFrame.HideEverything(AMessage: string = 'No patient is currently selected.');
begin
  FNoPatientSelected := TRUE;
  pnlNoPatientSelected.Caption := AMessage;
  pnlNoPatientSelected.Visible := True;
  pnlNoPatientSelected.BringToFront;
  mnuFileReview.Enabled := False;
  mnuFilePrint.Enabled := False;
  mnuFilePrintSelectedItems.Enabled := False;
  mnuFileEncounter.Enabled := False;
  mnuFileNext.Enabled := False;
  mnuFileRefresh.Enabled := False;
  mnuFilePrintSetup.Enabled := False;
  mnuFilePrintSelectedItems.Enabled := False;
  mnuFileNotifRemove.Enabled := False;
  mnuFileResumeContext.Enabled := False;
  mnuFileBreakContext.Enabled := False;
  mnuEdit.Enabled := False;
  mnuView.Enabled := False;
  mnuTools.Enabled := False;
  if FNextButtonActive then FNextButton.Visible := False;
  mnuClosePatient.Enabled := False; //kt 11/16/20
  mnuEditDemographics.Enabled := false; //kt 11/16/20
  mnuExportChart.Enabled := false; //kt 11/16/20
  mnuPrintLabels.Enabled := false; //kt 11/16/20
  mnuPrintAdmissionLabel.Enabled := false; //kt 11/16/20
  if assigned(mnuPrintFormLetters) then mnuPrintFormLetters.Enabled := false; //kt 11/16/20
  
end;

procedure TfrmFrame.ShowEverything;
begin
  FNoPatientSelected := FALSE;
  pnlNoPatientSelected.Caption := '';
  pnlNoPatientSelected.Visible := False;
  pnlNoPatientSelected.SendToBack;
  mnuFileReview.Enabled := True;
  mnuFilePrint.Enabled := True;
  mnuFileEncounter.Enabled := True;
  mnuFileNext.Enabled := True;
  mnuFileRefresh.Enabled := True;
  mnuFilePrintSetup.Enabled := True;
  mnuFilePrintSelectedItems.Enabled := True;
  mnuFileNotifRemove.Enabled := True;
  if not FCCOWError then begin
    if FCCOWIconName= 'BMP_CCOW_BROKEN' then begin
      mnuFileResumeContext.Enabled := True;
      mnuFileBreakContext.Enabled := False;
    end else begin
      mnuFileResumeContext.Enabled := False;
      mnuFileBreakContext.Enabled := True;
    end;
  end;
  mnuEdit.Enabled := True;
  mnuView.Enabled := True;
  mnuTools.Enabled := True;
  if FNextButtonActive then FNextButton.Visible := True;
  mnuClosePatient.Enabled := true; //kt 11/16/20
  mnuEditDemographics.Enabled := true; //kt 11/16/20
  mnuExportChart.Enabled := true; //kt 11/16/20
  mnuPrintLabels.Enabled := true; //kt 11/16/20
  mnuPrintAdmissionLabel.Enabled := true; //kt 11/16/20
  if assigned(mnuPrintFormLetters) then mnuPrintFormLetters.Enabled := true; //kt 11/16/20
end;


procedure TfrmFrame.pnlFlagMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlFlag.BevelOuter := bvLowered;
end;

procedure TfrmFrame.pnlFlagMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlFlag.BevelOuter := bvRaised;
end;

procedure TfrmFrame.pnlFlagClick(Sender: TObject);
begin
  //ShowFlags;
  ViewInfo(mnuViewFlags);
end;

procedure TfrmFrame.mnuFilePrintSelectedItemsClick(Sender: TObject);
begin
  case TabIndexToPageID(FTabPage[tpsLeft].TabIndex) of
    CT_NOTES:    frmNotes.LstNotesToPrint;
    CT_CONSULTS: frmConsults.LstConsultsToPrint;
    CT_DCSUMM:   frmDCSumm.LstSummsToPrint;
  end; {case}
end;

procedure TfrmFrame.mnuAlertRenewClick(Sender: TObject);
var XQAID: string;
begin
  XQAID := Piece(Notifications.RecordID, '^', 2);
  RenewAlert(XQAID);
end;

procedure TfrmFrame.mnuAnticoagulationToolClick(Sender: TObject);
//kt added 4/2018
var
  frmAnticoagulate: TfrmAnticoagulate;
begin
  inherited;
  frmAnticoagulate := TfrmAnticoagulate.Create(Self);
  frmAnticoagulate.Initialize(Patient.DFN);
  frmAnticoagulate.ShowModal;
  frmAnticoagulate.Free;
end;

procedure TfrmFrame.mnuBillableItemsClick(Sender: TObject);
//tmg added entire function  4/9/15  //kt
var
  frmBillableItems: TfrmBillableItems;
begin
  inherited;
  frmBillableItems := TfrmBillableItems.Create(Self);
  frmBillableItems.ShowModal;
  frmBillableItems.Free;
end;

procedure TfrmFrame.mnuAlertForwardClick(Sender: TObject);
var
  XQAID, AlertMsg: string;
begin
  XQAID := Piece(Notifications.RecordID,'^', 2);
  AlertMsg := Piece(Notifications.RecordID, '^', 1);
  RenewAlert(XQAID);  // must renew/restore an alert before it can be forwarded
  ForwardAlertTo(XQAID + '^' + AlertMsg);
end;

procedure TfrmFrame.mnuGECStatusClick(Sender: TObject);
var
ans, Result,str,str1,title: string;
cnt,i: integer;
fin: boolean;

begin
  Result := sCallV('ORQQPXRM GEC STATUS PROMPT', [Patient.DFN]);
  if Piece(Result,U,1) <> '0' then begin
    title := Piece(Result,U,2);
    if pos('~',Piece(Result,U,1))>0 then begin
      str:='';
      str1 := Piece(Result,U,1);
      cnt := DelimCount(str1, '~');
      for i:=1 to cnt+1 do begin
        if i = 1 then str := Piece(str1,'~',i);
        if i > 1 then str :=str+CRLF+Piece(str1,'~',i);
      end;
    end else str := Piece(Result,U,1);
    if Piece(Result,U,3)='1' then begin
      fin := (InfoBox(str,title, MB_YESNO or MB_DEFBUTTON2)=IDYES);
      if fin = true then ans := '1';
      if fin = false then ans := '0';
      CallV('ORQQPXRM GEC FINISHED?',[Patient.DFN,ans]);
    end else InfoBox(str,title, MB_OK);
  end;
end;

procedure TfrmFrame.pnlFlagEnter(Sender: TObject);
begin
  pnlFlag.BevelInner := bvRaised;
  pnlFlag.BevelOuter := bvNone;
  pnlFlag.BevelWidth := 3;
end;

procedure TfrmFrame.pnlFlagExit(Sender: TObject);
begin
  pnlFlag.BevelWidth := 2;
  pnlFlag.BevelInner := bvNone;
  pnlFlag.BevelOuter := bvRaised;
end;

procedure TfrmFrame.tabPageRMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  LastTab[tpsRight] := TabIndexToPageID((sender as TTabControl).TabIndex);
  TabCtrlClicked := True;  //used in fProbs.
  TabCtrlClickedSide := tpsLeft; //used in fProbs.
end;


procedure TfrmFrame.tabPageLMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LastTab[tpsLeft] := TabIndexToPageID((sender as TTabControl).TabIndex);
  TabCtrlClicked := True;  //used in fProbs.
  TabCtrlClickedSide := tpsLeft; //used in fProbs.
end;

procedure TfrmFrame.lstCIRNLocationsExit(Sender: TObject);
begin
    //Make the lstCIRNLocations act as if between pnlCIRN & pnlReminders
    //in the Tab Order
  if Boolean(Hi(GetKeyState(VK_TAB))) then begin
    if Boolean(Hi(GetKeyState(VK_SHIFT))) then begin
      pnlCIRN.SetFocus
    end else begin
      pnlReminders.SetFocus;
    end;
  end;
end;

procedure TfrmFrame.AppEventsActivate(Sender: TObject);
begin
  FJustEnteredApp := True;
end;

procedure TfrmFrame.ScreenActiveFormChange(Sender: TObject);
begin
  if(assigned(FOldActiveFormChange)) then begin
    FOldActiveFormChange(Sender);
  end;
  //Focus the Form that Stays on Top after the Application Regains focus.
  if FJustEnteredApp then begin
    FocusApplicationTopForm;
  end;
  FJustEnteredApp := false;
end;

procedure TfrmFrame.FocusApplicationTopForm;
var I : integer;
begin
  for I := (Screen.FormCount-1) downto 0 do begin //Set the last one opened last
    with Screen.Forms[I] do begin
      if (FormStyle = fsStayOnTop) and (Enabled) and (Visible) then begin
        SetFocus;
      end;
    end;
  end;
end;

procedure TfrmFrame.AppEventsShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if ((Boolean(Hi(GetKeyState(VK_MENU{ALT})))) and (Msg.CharCode = VK_F1)) then begin
    FocusApplicationTopForm;
    Handled := True;
  end;
end;

procedure TfrmFrame.mnuToolsGraphingClick(Sender: TObject);
var
  contexthint: string;
begin
  Screen.Cursor := crHourGlass;
  contexthint := mnuToolsGraphing.Hint;
  if GraphFloat = nil then begin
    // new graph
    GraphFloat := TfrmGraphs.Create(self);
    try
      with GraphFloat do begin
        if btnClose.Tag = 1 then begin
          Screen.Cursor := crDefault;
          exit;
        end;
        Initialize;
        Caption := 'CPRS Graphing - Patient: ' + MixedCase(Patient.Name);
        BorderIcons := [biSystemMenu, biMaximize, biMinimize];
        BorderStyle := bsSizeable;
        BorderWidth := 1;
        // context sensitive       type (tabPage.TabIndex)  & [item]
        ResizeAnchoredFormToFont(GraphFloat);
        GraphFloat.pnlFooter.Hint := contexthint;   // context from lab most recent
        Show;
      end;
    finally
      if GraphFloat.btnClose.Tag = 1 then begin
        GraphFloatActive := false;
        GraphFloat.Free;
        GraphFloat := nil;
      end else begin
        GraphFloatActive := true;
      end;
    end;
  end else begin
    GraphFloat.Caption := 'CPRS Graphing - Patient: ' + MixedCase(Patient.Name);
    GraphFloat.pnlFooter.Hint := contexthint;   // context from lab most recent
    if GraphFloat.btnClose.Tag = 1 then begin
      Screen.Cursor := crDefault;
      exit;
    end else if GraphFloatActive and (frmGraphData.pnlData.Hint = Patient.DFN) then begin
      if length(GraphFloat.pnlFooter.Hint) > 1 then begin
        GraphFloat.Close;
        GraphFloatActive := true;
        GraphFloat.Show;
      end;
      GraphFloat.BringToFront;             // graph is active, same patient
    end else if frmGraphData.pnlData.Hint = Patient.DFN then begin
      // graph is not active, same patient
      // context sensitive
      GraphFloat.Show;
      GraphFloatActive := true;
    end else begin
      // new patient
      GraphFloat.InitialRetain;
      GraphFloatActive := false;
      GraphFloat.Free;
      GraphFloat := nil;
      mnuToolsGraphingClick(self);          // delete and recurse
    end;
  end;
  mnuToolsGraphing.Hint := '';
  Screen.Cursor := crDefault;
end;

procedure TfrmFrame.pnlCIRNMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlCIRN.BevelOuter := bvLowered;
end;

procedure TfrmFrame.pnlCIRNMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlCIRN.BevelOuter := bvRaised;
end;

procedure TfrmFrame.laMHVClick(Sender: TObject);
begin
  //if laMHV.Caption = 'MHV' then
  //  ShellExecute(Handle, 'open', PChar('http://www.doma.domain.ext/'), '', '', SW_NORMAL);
  ViewInfo(mnuViewMyHealtheVet);
end;

procedure TfrmFrame.laVAA2Click(Sender: TObject);
{var
  InsuranceSubscriberName: string;
  ReportString: TStringList; //CQ7782 }
begin
  {if fCover.VAAFlag[0] <> '0' then //'0' means subscriber not found
     begin
     InsuranceSubscriberName := fCover.VAAFlag[12];
     //CQ7782
     //ReportString := TStringList.Create;
     ReportString := VAAFlag;
     ReportString[0] := '';
     ReportBox(ReportString, InsuranceSubscriberName, True);
     //end CQ7782
     end;}
  ViewInfo(mnuInsurance);
end;

procedure TfrmFrame.lblLoadSequelPatClick(Sender: TObject);
begin
  inherited;
  CurSequelPat := TCurrentSequelPat.Create();
  //if (CurSequelPat.New) and (CurSequelPat.DFN<>Patient.DFN) then begin
  if (CurSequelPat.DFN<>'') and (CurSequelPat.DFN<>Patient.DFN) then begin
     if messagedlg('Would you like to open '+CurSequelPat.Name+'''s chart?',mtConfirmation,[mbYes,mbNo],0)=mrYes then begin
        OpenChartByDFN(CurSequelPat.DFN);
     end;
  end else if CurSequelPat.DFN=Patient.DFN then begin
    Showmsg('Patient is already open in CPRS');
  end;
           
  CurSequelPat.Free;
end;

procedure TfrmFrame.ViewAuditTrail1Click(Sender: TObject);
var
  frmPtAuditLog: TfrmPtAuditLog;
begin
  inherited;
  frmPtAuditLog := TfrmPtAuditLog.Create(self);
  frmPtAuditLog.Caption := 'View Audit Log For: '+Patient.Name;
  frmPtAuditLog.ShowModal;
  FreeandNil(frmPtAuditLog);
end;

procedure TfrmFrame.ViewInfo(Sender: TObject);
var
  SelectNew: Boolean;
  InsuranceSubscriberName: string;
  ReportString: TStringList;
  aAddress: string;
begin
  case (Sender as TMenuItem).Tag of
    1:begin { displays patient inquiry report (which optionally allows new patient to be selected) }
        StatusText(TX_PTINQ);
        PatientInquiry(SelectNew);
        if Assigned(FLastPage[tpsLeft]) then
          FLastPage[tpsLeft].FocusFirstControl;
        StatusText('');
        if SelectNew then mnuFileOpenClick(mnuViewDemo);
      end;
    2:begin
        if (not User.IsReportsOnly) then begin// Reports Only tab.
          mnuFileEncounterClick(Self);
        end;
      end;
    3:begin
        ReportBox(DetailPrimaryCare(Patient.DFN), 'Primary Care', True);
      end;
    4:begin
        if laMHV.Caption = 'MHV' then begin
          ShellExecute(laMHV.Handle, 'open', PChar('http://www.doma.domain.ext/'), '', '', SW_NORMAL);
        end;
      end;
    5:begin
        if fCover.VAAFlag[0] <> '0' then begin //'0' means subscriber not found
         //  CQ:15534-GE  Remove leading spaces from Patient Name
          InsuranceSubscriberName := ( (Piece(fCover.VAAFlag[12],':',1)) + ':  ' +
                                     (TRIM(Piece(fCover.VAAFlag[12],':',2)) ));//fCover.VAAFlag[12];
          ReportString := VAAFlag;
          ReportString[0] := '';
          ReportBox(ReportString, InsuranceSubscriberName, True);
        end;
      end;
    6:begin
        ShowFlags;
      end;
    7:begin
        if uUseVistaWeb = true then begin
          lblCIRN.Alignment := taCenter;
          lstCIRNLocations.Visible := false;
          lstCIRNLocations.SendToBack;
          aAddress := GetVistaWebAddress(Patient.DFN);
          ShellExecute(pnlCirn.Handle, 'open', PChar(aAddress), PChar(''), '', SW_NORMAL);
          pnlCIRN.BevelOuter := bvRaised;
          Exit;
        end;
        if not RemoteSites.RemoteDataExists then Exit;
        if (not lstCIRNLocations.Visible) then begin
          pnlCIRN.BevelOuter := bvLowered;
          lstCIRNLocations.Visible := True;
          lstCIRNLocations.BringToFront;
          lstCIRNLocations.SetFocus;
          pnlCIRN.Hint := 'Click to close list.';
        end else begin
          pnlCIRN.BevelOuter := bvRaised;
          lstCIRNLocations.Visible := False;
          lstCIRNLocations.SendToBack;
          pnlCIRN.Hint := 'Click to display other facilities having data for this patient.';
        end;
      end;
    8:begin
        ViewReminderTree;
      end;
    9:begin { displays the window that shows crisis notes, warnings, allergies, & advance directives }
        ShowCWAD;
      end;
  end;
end;

procedure TfrmFrame.mnuViewInformationClick(Sender: TObject);
begin
  mnuViewDemo.Enabled := frmFrame.pnlPatient.Enabled;
  mnuViewVisits.Enabled := frmFrame.pnlVisit.Enabled;
  mnuViewPrimaryCare.Enabled := frmFrame.pnlPrimaryCare.Enabled;
  mnuViewMyHealtheVet.Enabled := not (Copy(frmFrame.laMHV.Hint, 1, 2) = 'No');
  mnuInsurance.Enabled := not (Copy(frmFrame.laVAA2.Hint, 1, 2) = 'No');
  mnuViewFlags.Enabled := frmFrame.lblFlag.Enabled;
  mnuViewRemoteData.Enabled := frmFrame.lblCirn.Enabled;
  mnuViewReminders.Enabled := frmFrame.pnlReminders.Enabled;
  mnuViewPostings.Enabled := frmFrame.pnlPostings.Enabled;
end;

procedure TfrmFrame.mnuViewInsurancesClick(Sender: TObject);
begin
  inherited;
  ViewInfo(mnuInsurance);
end;

procedure TfrmFrame.CallERx(action: Integer);     //ERx //kt 9/4/12  added entire function
var
  results, headers: TStringList;
  line, s: string;
  varUrl, varFlags, varTarget, varPostData, varHeaders: OleVariant;
  dynData: TByteDynArray;
  i: Integer;
begin
  //kt if uTMGOptions.ReadString('SpecialLocation','')='INTRACARE' then begin
  if AtIntracareLoc() then begin
    if Encounter.NeedVisit then begin    //TMG added if block
      UpdateVisit(Font.Size, DfltTIULocation);
      frmFrame.DisplayEncounterText;
    end;
    CallV('VEFA SET LOCATION',[User.DUZ,Encounter.Location]);
  end;
  //End TMG add
  if assigned(ePrescribing) then begin
    ePrescribing.BringToFront;
    Exit;
  end;

  if Patient.DFN = '' then begin
    MessageDlg('No patient is selected.', mtWarning, [mbOK], 0);
    Exit;
  end;
  try
    results := TStringList.Create;
    headers := TStringList.Create;
    try
      case action of
        ERX_ACTION_ORDER:
          CallV('C0P ERX ORDER RPC', [User.DUZ, Patient.DFN]);
        ERX_ACTION_ALERT:
          CallV('C0P ERX ALERT RPC', [User.DUZ, Patient.DFN, 1, Notifications.RecordID]);
        Else
          Exit;
      end; {case}
      s := AnsiReplaceStr(RPCBrokerV.Results.Text, '^M', sLineBreak);

      results.Text := s;
      //results.SaveToFile('rpcresults.txt');

      varUrl := Null;
      while (results.Count > 0) and not AnsiStartsText('RxInput=', results[0]) do begin
        line := Trim(results[0]);
        results.Delete(0);
        if line = '' then continue;
        if AnsiStartsText('POST ', line) then begin
          varUrl := Piece(line,' ',2);
          continue;
        end;
        headers.values[Piece(line,':',1)] := Trim(Piece(line,':',2));
      end; {while}

      if VarIsNull(varUrl) then Exit;

      s := results.Text;
      SetLength(dynData, Length(s));
      Move(s[1], dynData[0], Length(s));
      DynArrayToVariant(Variant(varPostData), dynData, TypeInfo(TByteDynArray));

      headers.Values['Content-Length'] := IntToStr(Length(s));

      varHeaders := '';
{$IFDEF VER140}    //  Lets Delphi 6 compile and run correctly (RV)
      for i := 0 to headers.Count - 1 do begin
        varHeaders := varHeaders + headers.Names[i] + ': ' + Piece(headers[i], '=', 2) + sLineBreak;
      end;
{$ELSE}   //  Delphi 7 version
      for i := 0 to headers.Count - 1 do begin
        varHeaders := varHeaders + headers.Names[i] + ': ' + headers.ValueFromIndex[i] + sLineBreak;
      end;
{$ENDIF}

      varFlags := Null;
      varTarget := Null;
      ePrescribing := TEPrescribeForm.Create(Application);
      ePrescribing.browser.Navigate2(varUrl, varFlags, varTarget, varPostData, varHeaders);
      ePrescribing.ShowModal;
    finally
      results.Free;
      headers.Free;
    end;
  except
    on e: Exception do
      MessageDlg('An error occurred: ' + e.Message, mtError, [mbOK], 0);
  end;
  SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_SIGN, 0);
end;


procedure TfrmFrame.EPrescribing1Click(Sender: TObject);  //ERx 9/4/12
begin
 CallERx(ERX_ACTION_ORDER);
end;


function TfrmFrame.CheckForRPC(RPCName: string): boolean;
//kt 9/11 added
var                                                   
    RPCResult              : AnsiString;

begin
  RPCBrokerV.remoteprocedure := 'XWB IS RPC AVAILABLE';
  RPCBrokerV.Param[0].Value := RPCName;
  RPCBrokerV.Param[0].ptype := literal;
  RPCBrokerV.Param[1].Value := 'R';
  RPCBrokerV.Param[1].ptype := literal;
  CallBroker;
  if RPCBrokerV.Results.Count>0 then begin
    RPCResult := RPCBrokerV.Results.Strings[0];
    result := (StrToInt(RPCResult) = 1);
  end else begin
    result := False;
  end;
end;

procedure TfrmFrame.mnuEditDemographicsClick(Sender: TObject);
//kt 9/11 added
var  EditResult: integer;
begin
  //EditResult := frmPtDemoEdit.ShowModal;
  EditResult := EditPatientDemographics;
  if EditResult <> mrCancel then mnuFileRefreshClick(Sender);
end;

procedure TfrmFrame.tabPageDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
//kt 9/11 added
var ALabel : string;
    color : TColor;
begin
  if TabColorsEnabled then begin
    ALabel := TTabControl(Control).Tabs[TabIndex];
    color := TColor(TabColorsList.Objects[TabIndex]);
    DrawTab(Control,TabIndex,Rect,color,Active);
  end else begin
    //this isn't working... This is not what I want.  Fix later...
    //For now, TabColorsEnabled should always be TRUE.
    //Control.Canvas.FillRect(Rect);   //elh   we will try to alter the OwnerDraw property here
    //TabPage.OwnerDraw := TabColorsEnabled;
  end;
end;

procedure TfrmFrame.DrawTab(Control: TCustomTabControl; TabIndex: Integer;
                           const Rect: TRect; Color : TColor; Active: Boolean);
//kt 9/11 added
  var
    oRect         : TRect;
    sCaption,temp : String;
    iTop          : Integer;
    iLeft         : Integer;
    i             : integer;
    TabControl    : TTabControl;
    lf            : TLogFont;  //Windows native font structure
    tf            : TFont;
    Degrees       : integer;
    inactiveColor : TColor;

    function DarkenRed(Color : TColor; Percent : byte) : TColor;
    var red : longWord;
    begin
      red := (Color and $0000FF);
      red := Round (red * (Percent/100));
      Result := (Color and $FFFF00) or red;
    end;

    function DarkenGreen(Color : TColor; Percent : byte) : TColor;
    var green : longWord;
    begin
      green := (Color and $00FF00);
      green := green shr 8;
      green := Round(green * (Percent/100));
      green := green shl 8;
      Result := (Color and $FF00FF) or green;
    end;

    function DarkenBlue(Color : TColor; Percent : byte) : TColor;
    var blue : longWord;
    begin
      blue := (Color and $FF0000);
      blue := blue shr 16;
      Blue := Round (blue * (Percent/100));
      blue := blue shl 16;
      Result := (Color and $00FFFF) or blue;
    end;

   function Darken(Color : TColor; Percent : byte) : TColor;
   begin
     if Percent=0 then begin result := Color; exit; end;
     result := DarkenRed(Color, Percent);
     result := DarkenBlue(result,Percent);
     result := DarkenGreen(result,Percent);
   end;

  begin
    oRect    := Rect;
    inactiveColor := Darken(Color,75);  //75%

    TabControl := TTabControl(Control);
    if TabControl.Tabs.Count=0 then exit;
    sCaption := TabControl.Tabs.Strings[TabIndex];
    for i := 1 to length(temp) do begin
      if temp[i] <> '&' then sCaption := sCaption + temp[i];
    end;

    Control.Canvas.Font.Name := 'Tahoma';
    if Active then begin
      Control.Canvas.Font.Style := Control.Canvas.Font.Style + [fsBold];
      Control.Canvas.Font.Color := clBlack
    end else begin
      Control.Canvas.Font.Style := Control.Canvas.Font.Style - [fsBold];
      Control.Canvas.Font.Color := clWhite;
    end;

    if (TabControl.TabPosition = tpLeft) or (TabControl.TabPosition = tpRight) then begin

      if (TabControl.TabPosition = tpLeft) then begin
        iTop     := Rect.Bottom-4;
        if Active then iTop := iTop - 2;
        iLeft    := Rect.Left + 1;
        Degrees  := 90;
      end else begin
        iTop     := Rect.Top  + 4;
        if Active then iTop := iTop + 2;
        iLeft    := Rect.Right - 2;
        Degrees  := 270;
      end;
      tf := TFont.Create;
      try
        tf.Assign(Control.Canvas.Font);
        GetObject(tf.Handle, sizeof(lf), @lf);
        lf.lfEscapement := 10 * Degrees;  //degrees of desired rotation
        lf.lfHeight := Control.Canvas.Font.Height - 2;
        tf.Handle := CreateFontIndirect(lf);
        Control.Canvas.Font.Assign(tf);
      finally
        tf.Free;
      end;

    end else begin
      iTop     := Rect.Top  + ((Rect.Bottom - Rect.Top  - Control.Canvas.TextHeight(sCaption)) div 2) + 1;
      iLeft    := Rect.Left + ((Rect.Right  - Rect.Left - Control.Canvas.TextWidth (sCaption)) div 2) + 1;
    end;

    if (TabControl.TabPosition = tpBottom) and (not Active) then begin
      iTop := iTop - 2;
    end;

    if Active then begin
      Control.Canvas.Brush.Color := Color;  //Test2
    end else begin
      Control.Canvas.Brush.Color := inactiveColor;  //Test2
    end;
    Control.Canvas.FillRect(Rect);
    Control.Canvas.TextOut(iLeft,iTop,sCaption);
end;

procedure TfrmFrame.mnuPrintLabelsClick(Sender: TObject);
//kt 9/11 added
var  frmPtLabelPrint: TfrmPtLabelPrint;
begin
  frmPtLabelPrint := TfrmPtLabelPrint.Create(Self); //kt 10/15
  //if frmPtLabelPrint <> nil then begin    //kt 10/15
    frmPtLabelPrint.PrepDialog(Patient);
    frmPtLabelPrint.ShowModal;
  //end;
  frmPtLabelPrint.Free;  //kt 10/15
end;

procedure TfrmFrame.mnuPrintAdmissionLabelClick(Sender: TObject);
//kt 9/11 added
var
  frmIntracarePtAdmLbl: TfrmIntracarePtAdmLbl;
begin
  frmIntracarePtAdmLbl:= TfrmIntracarePtAdmLbl.Create(Self);
  frmIntracarePtAdmLbl.ShowModal;
  frmIntracarePtAdmLbl.Free;
end;


procedure TfrmFrame.SetActiveTab(PageID: Integer);
begin
  FTabPage[tpsLeft].TabIndex := frmFrame.PageIDToTab(PageID);
  tabPageChange(tpsLeft);
end;

function TfrmFrame.GetActiveTab: integer;
//kt added 6/15
//NOTE: results match to CT_COVER, CT_PROBLEMS, etc., defined in uConst.pas
begin
  Result := FTabPage[tpsLeft].TabIndex;
end; 
          { REMOVE THIS
procedure TfrmFrame.EPrescribing1Click(Sender: TObject);  //ERx 9/4/12
begin
 CallERx(ERX_ACTION_ORDER);
end;       }

procedure TfrmFrame.NextButtonClick(Sender: TObject);
begin
  if FProccessingNextClick then Exit;
  FProccessingNextClick := true;
  popAlerts.AutoPopup := TRUE;
  mnuFileNext.Enabled := True;
  mnuFileNextClick(Self);
  FProccessingNextClick := false;
end;

procedure TfrmFrame.NextButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
begin
   popAlerts.AutoPopup := TRUE;
end;

procedure TfrmFrame.SetUpNextButton;
begin
  if FNextButton <> nil then begin
    FNextButton.free;
    FNextButton := nil;
  end;
  FNextButton := TBitBtn.Create(self);
  FNextButton.Parent:= frmFrame;
  FNextButton.Glyph := FNextButtonBitmap;
  FNextButton.OnMouseDown := NextButtonMouseDown;
  FNextButton.OnClick := NextButtonClick;
  //kt FNextButton.Caption := '&Next';
  FNextButton.Caption := 'Next';
  FNextButton.PopupMenu := popAlerts;
  FNextButton.Top := stsArea.Top;
  FNextButton.Left := FNextButtonL;
  FNextButton.Height := stsArea.Height;
  FNextButton.Width := stsArea.Panels[2].Width;
  FNextButton.TabStop := True;
  FNextButton.TabOrder := 1;
  FNextButton.show;
end;

procedure TfrmFrame.SetUpResizeButtons;  //kt 4/28/21
var
  FontSmallerLPos: Integer;
  FontNormalLPos: Integer;
  FontLargerLPos: Integer;
  Top : integer;
begin
  sbtnFontSmaller.Parent := stsArea;
  sbtnFontNormal.Parent := stsArea;
  sbtnFontLarger.Parent := stsArea;

  with stsArea do begin
    FontLargerLPos := Panels[0].Width + Panels[1].Width - sbtnFontLarger.Width - 2;
    FontNormalLPos := FontLargerLPos - sbtnFontNormal.Width;
    FontSmallerLPos := FontNormalLPos - sbtnFontSmaller.Width;
  end;
  sbtnFontSmaller.Left := FontSmallerLPos;
  sbtnFontNormal.Left := FontNormalLPos;
  sbtnFontLarger.Left := FontLargerLPos;
  Top := 1;
  sbtnFontSmaller.Top := Top;
  sbtnFontNormal.Top := Top;
  sbtnFontLarger.Top := Top;
end;

procedure TfrmFrame.WMDropFiles(var Msg: TMessage); //kt 4/15/14
//from here: http://www.delphipages.com/forum/showthread.php?t=8535
var
  //N: Integer;
  NumFiles: Word;
  TheFile: array[0..512] of Char;
  //s : string;
  Where: TPoint;
  //OKToAccept : boolean;
begin
  // gets position of mouse when file(s) dropped
  DragQueryPoint(THandle(Msg.WParam), Where);

  // gets the number of dropped files
  NumFiles := DragQueryFile(THandle(Msg.WParam), $FFFFFFFF, nil, 0);
  if (NumFiles > 1) then begin
    MessageDlg('Please drag-and-drop only ONE file!', mtError, [mbOK],0);
  end else begin
    // gets dropped filenames
    DragQueryFile(THandle(Msg.WParam), 0, TheFile, SizeOf(TheFile));
    FDragAndDropFName := TheFile;
    PatientImageClick(Self);
  end;
  DragFinish(THandle(Msg.WParam));
end;

procedure TfrmFrame.OpenChartByDFN(NewDFN:string)  ;  //TMG added entire function 6/11/18
begin
  if NewDFN=Patient.DFN then exit;
  Patient.DFN := NewDFN;     // The patient object in uCore must have been created already!
  FRefreshing := TRUE;
  try
    Encounter.Clear;
    Changes.Clear;
    //frmFrame.UpdatePtInfoOnRefresh;
    if Patient.Inpatient then Encounter.VisitCategory := 'H';
    mnuFileOpenClick(Self);
    //DisplayEncounterText;
  finally
    FRefreshing := FALSE;
    OrderPrintForm := FALSE;
  end;
end;

procedure TfrmFrame.WMCopyData(var Msg: TWMCopyData) ;  //TMG 7/10/18
begin
  //Showmsg(PChar(Msg.CopyDataStruct.lpData));
  TMG_WM_API.HandleCopyDataMsg(Msg, Self.Handle);
  //msg.result := 2006;
end;


initialization
  SpecifyFormIsNotADialog(TfrmFrame);
  NoPatientIDPhotoIcon := TBitmap.Create;  //kt 4/14/14

finalization
  //put finalization code here
  NoPatientIDPhotoIcon.Free;   //kt 4/14/14

end.


