unit fEncounterFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Tabs, ComCtrls, ExtCtrls, Menus, StdCtrls, Buttons, fPCEBase,
  {fVisitType,} fDiagnoses, {fProcedure,} fImmunization, fSkinTest, fPatientEd,
  fHealthFactor, fExam, uPCE, rPCE, rTIU, ORCtrls, ORFn, fEncVitals, rvitals, fBase508Form,
  fFollowUp,
  fTMGDiagnoses, fTMGProcedure, fTMGVisitType, //kt
  VA508AccessibilityManager;

const
  //tab names
  CT_DiagNm         = 'Diagnoses';
  CT_ImmNm          = 'Immunizations';
  CT_SkinNm         = 'Skin Tests';
  CT_PedNm          = 'Patient Ed';
  CT_HlthNm         = 'Health Factors';
  CT_XamNm          = 'Exams';
  CT_VitNm          = 'Vitals';
  CT_GAFNm          = 'GAF';
  CT_TMG_FolwUpNm   = 'Follow Up';  //kt added
  CT_TMG_EnctrMDMNm = 'MDM';        //kt added  
  CT_TMG_LabsNm     = 'Labs';       //kt added
  CT_TMG_DiagNm     = 'Dx''s';      //kt added
  CT_TMG_ProcNm     = 'Procedures'; //kt added, was CT_ProcNm
  CT_TMG_VisitNm    = 'E/M';        //kt added and renamed from CT_VisitNm.  Was -> 'Visit Type';

  //Numbers assigned to tabs to make changes easier.  NOTE!--they must be sequential
  CT_NOPAGE          = -1;
  CT_UNKNOWN         = 0;
  CT_TMG_VISITTYPE   = 1; CT_FIRST = 1;   //kt was CT_VISITTYPE
  CT_DIAGNOSES       = 2;
  CT_TMG_PROCEDURES  = 3;                 //kt  was CT_PROCEDURES
  CT_IMMUNIZATIONS   = 4;
  CT_SKINTESTS       = 5;
  CT_PATIENTED       = 6;
  CT_HEALTHFACTORS   = 7;
  CT_EXAMS           = 8;
  CT_VITALS          = 9;
  CT_GAF             = 10;                //kt  was CT_LAST = 10;
  CT_TMG_FOLLOWUP    = 11;                //kt
  CT_TMG_MDM         = 12;                //kt
  CT_TMG_LABS        = 13;                //kt
  CT_TMG_DIAGNOSIS   = 14;  CT_LAST = 14; //kt

  //------------------------
  //NUM_TABS           = 3;       //kt removed, not used.
  TAG_VTYPE          = 10;
  TAG_DIAG           = 20;
  TAG_PROC           = 30;
  TAG_IMMUNIZ        = 40;
  TAG_SKIN           = 50;
  TAG_PED            = 60;
  TAG_HF             = 70;
  TAG_XAM            = 80;
  TAG_TRT            = 90;

  TX_NOSECTION = '-1^No sections found';
  TX_PROV_REQ = 'A primary encounter provider must be selected before encounter data can' + CRLF +
                'be saved.  Select the Primary Encounter Provider on the VISIT TYPE tab.' + CRLF +
                'Otherwise, press <Cancel> to quit without saving data.';

  TC_PROV_REQ = 'Missing Primary Provider for Encounter';

type
  TfrmEncounterFrame = class(TfrmBase508Form)
    StatusBar1: TStatusBar;
    pnlPage: TPanel;
    Bevel1: TBevel;
    TabControl: TTabControl;
    procedure tabPageChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TabControlChange(Sender: TObject);
    procedure TabControlChanging(Sender: TObject; var AllowChange: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure FormShow(Sender: TObject);
    procedure TabControlEnter(Sender: TObject);
  private
    FAutoSave: boolean;
    FSaveNeeded: boolean;
    FChangeSource: Integer;
    FCancel:  Boolean;      //Indicates the cancel button has been pressed;
    FAbort: boolean;        // indicates that neither OK or Cancel has been pressed
    FormList: TStringList;  //Holds the types of any forms that will be used in the frame.  They must be available at compile time
    FLastPage: TfrmPCEBase;
    FGiveMultiTabMessage: boolean;
    PCEData: TPCEData;  //kt added.  Pointer to object owned elsewhere.
    procedure CreateChildForms(Sender: TObject; Location: integer);
    procedure SynchPCEData(SrcPCEData :TPCEData);  //kt added SrcPCEData parameter
    procedure SwitchToPage(NewForm: TfrmPCEBase);   //was tfrmPage
    function PageIDToForm(PageID: Integer): TfrmPCEBase;
    function PageIDToTab(PageID: Integer): string;
    procedure LoadFormList(Location: integer);
    procedure CreateForms;
    procedure FreeChildForms;  //kt added
    procedure AddTabs;
    function FormListContains(item: string): Boolean;
    procedure SendData;
    procedure UpdateEncounter(DestPCE: TPCEData);
    procedure SetFormFonts;
  public
    uProviders: TPCEProviderList;  //kt added, moving from global scope in this unit.  NOTE: Probably should be renamed later to just 'Providers'.
    procedure SelectTab(NewTabName: string);
    procedure SelectNextTab; //kt added 2/1/23
    procedure Initialize(SrcPCEData : TPCEData; InitialPageIndex : byte = 0);  //kt added
    property ChangeSource:    Integer read FChangeSource;
    property Forms:           tstringlist read FormList;
    property Cancel:          Boolean read FCancel write FCancel;
    property Abort:           Boolean read FAbort write FAbort;
    property SaveNeeded:      Boolean read FSaveNeeded;  //kt added
    property AutoSave:        Boolean read FAutoSave write FAutoSave;  //kt added
  end;

var
  frmEncounterFrame: TfrmEncounterFrame;
  uSCCond:           TSCConditions;
  //kt uVisitType:        TPCEProc;       // contains info for visit type page  //kt moved this into frmTMGVisitType.VisitType
  uEncPCEData:       TPCEData;   //kt <------ note: Used widely across CPRS
  //kt moved to TfrmEncounterFrame --> uProviders:        TPCEProviderList;

// Returns true if PCE data still needs to be saved - vitals/gaf are always saved
//kt original --> function UpdatePCE(PCEData: TPCEData; SaveOnExit: boolean = TRUE): boolean;
function UpdatePCE(SrcPCEData: TPCEData; SaveOnExit: boolean = TRUE; InitialPageIndex : byte = 0): boolean;  //kt 5/16/16


implementation

uses
  uCore,
  fGAF, uConst,
  fEncounterMDM,  //kt

  rCore, fPCEProvider, rMisc, VA508AccessibilityRouter, VAUtils, fEncounterLabs;

{$R *.DFM}

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure UpdatePCE(PCEData: TPCEData);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: The main call to open the encounter frame and capture encounter information.
///////////////////////////////////////////////////////////////////////////////}
//kt original --> function UpdatePCE(PCEData: TPCEData; SaveOnExit: boolean = TRUE): boolean;
function UpdatePCE(SrcPCEData: TPCEData; SaveOnExit: boolean = TRUE; InitialPageIndex : byte = 0): boolean;
//Called from many CPRS tabs

//var
//  FontHeight,
//  FontWidth: Integer;
 //kt moved to Initialize() -->  AUser: string;

begin
  uEncPCEData := SrcPCEData;

  if SrcPCEData.Empty and ((SrcPCEData.Location=0) or (SrcPCEData.VisitDateTime=0)) and (not Encounter.NeedVisit) then begin
    SrcPCEData.UseEncounter := TRUE;
  end;

  frmEncounterFrame := TfrmEncounterFrame.Create(Application);
  try
    frmEncounterFrame.AutoSave := SaveOnExit;   //kt was FAutoSave
    frmEncounterFrame.PCEData := SrcPCEData;    //kt added.  Pointer to object owned elsewhere.

    //kt moved to Initialize()
    {
    //kt  Moved To frmEncounterFrame.Initialize()
    frmEncounterFrame.Caption := 'Encounter Form for ' + ExternalName(SrcPCEData.Location, 44) +
                                   '  (' + FormatFMDateTime('mmm dd,yyyy@hh:nn', SrcPCEData.VisitDateTime) + ')';

    uProviders.Assign(SrcPCEData.Providers);
    SetDefaultProvider(uProviders, SrcPCEData);
    AUser := IntToStr(uProviders.PendingIEN(FALSE));
    if(AUser <> '0') and (uProviders.IndexOfProvider(AUser) < 0)
    and AutoCheckout(SrcPCEData.Location) then begin
      uProviders.AddProvider(AUser, uProviders.PendingName(FALSE), FALSE);
    end;

    frmEncounterFrame.CreateChildForms(frmEncounterFrame, PCEData.Location);
    SetFormPosition(frmEncounterFrame);
    ResizeAnchoredFormToFont(frmEncounterFrame);
    SetFormPosition(frmEncounterFrame);

    SetRPCEncLocation(SrcPCEData.Location);  //kt change PCEData.Location to SrcPCEData.Location for consistency (they are the same thing)
    frmEncounterFrame.SynchPCEData(SrcPCEData); //kt added parameter SrcPCEData
    frmEncounterFrame.TabControl.Tabindex := InitialPageIndex;   //kt 5/16
    frmEncounterFrame.TabControlChange(frmEncounterFrame.TabControl);
    }

    frmEncounterFrame.Initialize(SrcPCEData, InitialPageIndex);
    frmEncounterFrame.ShowModal;
    Result := frmEncounterFrame.SaveNeeded;   //was FSaveNeeded
    //kt NOTE: When frmEncounterFrame is closed (i.e. when ShowModal returns)
    //         then PCE data is typically saved.  If it is NOT saved, then
    //         .SaveNeeded set to true.  HOWEVER, after the form is released,
    //         any data saved in the form will be lost, so I'm not sure how it
    //         can later be saved.  Must be some aspect of this I don't understand...
    //  The data that gets saved is actually uEncPCEData, a globally scoped variable.
    //    So must be that the data is stored there, not in frmEncounterFrame,
    //    and so not lost when form is closed.
    //  Actually, uEncPCEData is a globally scoped pointer that is set to
    //     the SrcPCEData that is passed into this UpdatePCE()

  finally
    frmEncounterFrame.Release;
  end;
end;

//========================================================================
//========================================================================



{///////////////////////////////////////////////////////////////////////////////
//Name: function TfrmEncounterFrame.PageIDToTab(PageID: Integer): String;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: returns the tab index that corresponds to a given PageID .
///////////////////////////////////////////////////////////////////////////////}
function TfrmEncounterFrame.PageIDToTab(PageID: Integer): String;
begin
  result := '';
  case PageID of
    CT_NOPAGE:          Result := '';
    CT_UNKNOWN:         Result := '';
    CT_DIAGNOSES:       Result := CT_DiagNm;
    CT_IMMUNIZATIONS:   Result := CT_ImmNm;
    CT_SKINTESTS:       Result := CT_SkinNm;
    CT_PATIENTED:       Result := CT_PedNm;
    CT_HEALTHFACTORS:   Result := CT_HlthNm;
    CT_EXAMS:           Result := CT_XamNm;
    CT_VITALS:          Result := CT_VitNm;
    CT_GAF:             Result := CT_GAFNm;
    CT_TMG_FOLLOWUP:    Result := CT_TMG_FolwUpNm;    //kt added
    CT_TMG_MDM:         Result := CT_TMG_EnctrMDMNm;  //kt added
    CT_TMG_LABS:        Result := CT_TMG_LabsNm;      //kt added
    CT_TMG_DIAGNOSIS:   Result := CT_TMG_DiagNm;      //kt added
    CT_TMG_PROCEDURES:  Result := CT_TMG_ProcNm;      //kt added  was CT_PROCEDURES:    Result := CT_ProcNm;
    CT_TMG_VISITTYPE:   Result := CT_TMG_VisitNm;     //kt added  was CT_VISITTYPE:     Result := CT_VisitNm;
  end;
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: function TfrmEncounterFrame.PageIDToForm(PageID: Integer): TfrmPCEBase;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: return the form name based on the PageID}
///////////////////////////////////////////////////////////////////////////////}
function TfrmEncounterFrame.PageIDToForm(PageID: Integer): TfrmPCEBase;
begin
  case PageID of
    CT_DIAGNOSES:      Result := frmDiagnoses;
    CT_IMMUNIZATIONS:  Result := frmImmunizations;
    CT_SKINTESTS:      Result := frmSkinTests;
    CT_PATIENTED:      Result := frmPatientEd;
    CT_HEALTHFACTORS:  Result := frmHealthFactors;
    CT_EXAMS:          Result := frmExams;
    CT_VITALS:         Result := frmEncVitals;
    CT_GAF:            Result := frmGAF;
    CT_TMG_FOLLOWUP:   Result := frmFollowUp;      //kt added
    CT_TMG_MDM:        Result := frmEncounterMDM;  //kt added
    CT_TMG_LABS:       Result := frmEnounterLabs;  //kt added
    CT_TMG_DIAGNOSIS:  Result := frmTMGDiagnoses;  //kt added
    CT_TMG_VISITTYPE:  Result := frmTMGVisitType;  //kt added  was CT_VISITTYPE:     Result := frmVisitType;
    CT_TMG_PROCEDURES: Result := frmTMGProcedures; //kt added  was CT_PROCEDURES:    Result := frmProcedures;
  else  //not a valid form
    result := frmPCEBase;
  end;
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.CreatChildForms(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Finds out what pages to display, has the pages and tabs created.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.CreateChildForms(Sender: TObject; Location: integer);
begin
  //load FormList with a list of all forms to display.
  inherited;
  LoadFormList(Location);
  AddTabs;
  CreateForms;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: TfrmEncounterFrame.LoadFormList;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Loads Formlist with the forms to create, will be replaced by RPC call.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.LoadFormList(Location: integer);
begin
  //change this to an RPC in RPCE.pas
  //NOTE: The order of entry here will determine order of tabs displayed.
  FormList.clear;
  FormList.add(CT_TMG_FolwUpNm);   //kt added
  FormList.add(CT_TMG_LabsNm);     //kt added
  FormList.add(CT_TMG_EnctrMDMNm); //kt added
  FormList.add(CT_TMG_VisitNm);    //kt added   was FormList.add(CT_VisitNm);
  FormList.add(CT_TMG_DiagNm);     //kt added   was FormList.add(CT_DiagNm);
  FormList.add(CT_TMG_ProcNm);     //kt added   was FormList.add(CT_ProcNm);
  //kt removed 1/19/2023 --> formList.add(CT_VitNm);
  //kt removed --> formList.add(CT_ImmNm);
  //kt removed --> formList.add(CT_SkinNm);
  //kt removed --> formList.add(CT_PedNm);
  formList.add(CT_HlthNm);
  //kt removed --> formList.add(CT_XamNm);
  //kt removed --> if MHClinic(Location) then formList.add(CT_GAFNm);
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: function TfrmEncounterFrame.FormListContains(item: string): Boolean;
//Created: 12/06/98
//By: Robert Bott
//Location: ISL
//Description: Returns a boolean value indicating if a given string exists in
// the formlist.
///////////////////////////////////////////////////////////////////////////////}
function TfrmEncounterFrame.FormListContains(item: string): Boolean;
begin
  result := false;
  if (FormList.IndexOf(item) <> -1 ) then
    result := true;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.CreateForms;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description:  Creates all of the forms in the list.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.CreateForms;
var
  i: integer;
begin
  //could this be placed in a loop using PagedIdToTab & PageIDToFOrm & ?

  if FormListContains(CT_TMG_FolwUpNm)   then frmFollowUp      := TfrmFollowUp.CreateLinked(pnlPage);      //kt added
  if FormListContains(CT_TMG_EnctrMDMNm) then frmEncounterMDM  := TfrmEncounterMDM.CreateLinked(pnlPage);  //kt added
  if FormListContains(CT_TMG_LabsNm)     then frmEnounterLabs  := TfrmEnounterLabs.CreateLinked(pnlPage);  //kt added
  if FormListContains(CT_TMG_DiagNm)     then frmTMGDiagnoses  := TfrmTMGDiagnoses.CreateLinked(pnlPage);  //kt added
  if FormListContains(CT_TMG_ProcNm)     then frmTMGProcedures := TfrmTMGProcedures.CreateLinked(pnlPage); //kt added
  if FormListContains(CT_TMG_VisitNm)    then frmTMGVisitType  := TfrmTMGVisitTypes.CreateLinked(pnlPage); //kt added
  if FormListContains(CT_DiagNm)         then frmDiagnoses     := TfrmDiagnoses.CreateLinked(pnlPage);
  if FormListContains(CT_VitNm)          then frmEncVitals     := TfrmEncVitals.CreateLinked(pnlPage);
  if FormListContains(CT_ImmNm)          then frmImmunizations := TfrmImmunizations.CreateLinked(pnlPage);
  if FormListContains(CT_SkinNm)         then frmSkinTests     := TfrmSkinTests.CreateLinked(pnlPage);
  if FormListContains(CT_PedNm)          then frmPatientEd     := TfrmPatientEd.CreateLinked(pnlPage);
  if FormListContains(CT_HlthNm)         then frmHealthFactors := TfrmHEalthFactors.CreateLinked(pnlPage);
  if FormListContains(CT_XamNm)          then frmExams         := TfrmExams.CreateLinked(pnlPage);
  if FormListContains(CT_GAFNm)          then frmGAF           := TfrmGAF.CreateLinked(pnlPage);
  //kt if FormListContains(CT_VisitNm)   then frmVisitType     := TfrmVisitType.CreateLinked(pnlPage);
  //kt if FormListContains(CT_ProcNm)    then frmProcedures    := TfrmProcedures.CreateLinked(pnlPage);

  //must switch based on caption, as all tabs may not be present.
  for i := CT_FIRST to CT_LAST do begin
    if Formlist.IndexOf(PageIdToTab(i)) <> -1 then begin
      PageIDToForm(i).Visible := (Formlist.IndexOf(PageIdToTab(i)) = 0);
    end;
  end;
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.FreeChildForms;
//Created: 1/19/2023
//By: K. Toppenberg
//Location: TMG
//Description:  Frees all forms previously created, from list.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.FreeChildForms;
begin
  if FormListContains(CT_TMG_FolwUpNm)   then FreeAndNil(frmFollowUp);      //kt added
  if FormListContains(CT_TMG_EnctrMDMNm) then FreeAndNil(frmEncounterMDM);  //kt added
  if FormListContains(CT_TMG_EnctrMDMNm) then FreeAndNil(frmEnounterLabs);  //kt added
  if FormListContains(CT_TMG_VisitNm)    then FreeAndNil(frmTMGVisitType);  //kt added
  if FormListContains(CT_TMG_DiagNm)     then FreeAndNil(frmTMGDiagnoses);  //kt added
  if FormListContains(CT_TMG_ProcNm)     then FreeAndNil(frmTMGProcedures); //kt added
  if FormListContains(CT_VitNm)          then FreeAndNil(frmEncVitals);
  if FormListContains(CT_ImmNm)          then FreeAndNil(frmImmunizations);
  if FormListContains(CT_SkinNm)         then FreeAndNil(frmSkinTests);
  if FormListContains(CT_PedNm)          then FreeAndNil(frmPatientEd);
  if FormListContains(CT_HlthNm)         then FreeAndNil(frmHealthFactors);
  if FormListContains(CT_XamNm)          then FreeAndNil(frmExams);
  if FormListContains(CT_GAFNm)          then FreeAndNil(frmGAF);
  //kt if FormListContains(CT_VisitNm)   then FreeAndNil(frmVisitType);
  //kt if FormListContains(CT_ProcNm)    then FreeAndNil(frmProcedures);
  //kt if FormListContains(CT_DiagNm)    then FreeAndNil(frmDiagnoses);
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: TfrmEncounterFrame.SwitchToPage(NewForm: tfrmPCEBase);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Brings the selected page to the front for display.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.SwitchToPage(NewForm: tfrmPCEBase);// was TfrmPage);
{ unmerge/merge menus, bring page to top of z-order, call form-specific OnDisplay code }
begin
  if (NewForm = nil) or (FLastPage = NewForm) then Exit;
  if Assigned(FLastPage) then
    FLastPage.Hide;
  FLastPage := NewForm;
//  KeyPreview := (NewForm = frmEncVitals);
  NewForm.DisplayPage;  // this calls BringToFront for the form
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.tabPageChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Finds the page, and calls SwithToPage to display it.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.tabPageChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
{ switches to form linked to NewTab }
var
  i: integer;
begin
  if NewTab = -1 then exit; //kt added
  //must switch based on caption, as all tabs may not be present.
  for i := CT_FIRST to CT_LAST do begin
    With Formlist do begin
      if NewTab = IndexOf(PageIdToTab(i)) then begin
        PageIDToForm(i).show;
        SwitchToPage(PageIDToForm(i));
      end;
    end;
  end;
end;

{ Resize and Font-Change procedures --------------------------------------------------------- }

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.FormResize(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Resizes all windows when parent changes.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.FormResize(Sender: TObject);
var
  i: integer;
begin
 for i := CT_FIRST to CT_LAST do
   if (FormList.IndexOf(PageIdToTab(i)) <> -1) then
     MoveWindow(PageIdToForm(i).Handle, 0, 0, pnlPage.ClientWidth, pnlpage.ClientHeight, true);
  self.repaint;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.AddTabs;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: adds a tab for each page that will be displayed
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.AddTabs;

var
  i: integer;
begin
  TabControl.Tabs.Clear;
  for I := 0 to (Formlist.count - 1) do
    TabControl.Tabs.Add(Formlist.Strings[i]);
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.SynchPCEData;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Synchronize any existing PCE data with what is displayed in the form.
//             //kt: This is PCE data -> GUI form
///////////////////////////////////////////////////////////////////////////////}
//kt procedure TfrmEncounterFrame.SynchPCEData;
procedure TfrmEncounterFrame.SynchPCEData(SrcPCEData : TPCEData);

begin //SynchPCEData
  //Load any existing data from PCEData.  NOTE: Rather than use globally scoped uEncPCEData, I pass this in as SrcPCEData
  if FormListContains(CT_ImmNm)         then frmImmunizations.InitTab(SrcPCEData.CopyImmunizations, ListImmunizSections);
  if FormListContains(CT_SkinNm)        then frmSkinTests.InitTab    (SrcPCEData.CopySkinTests,     ListSkinSections);
  if FormListContains(CT_PedNm)         then frmPatientEd.InitTab    (SrcPCEData.CopyPatientEds,    ListPatientSections);
  if FormListContains(CT_HlthNm)        then frmHealthFactors.InitTab(SrcPCEData.CopyHealthFactors, ListHealthSections);
  if FormListContains(CT_XamNm)         then frmExams.InitTab        (SrcPCEData.CopyExams,         ListExamsSections);
  if FormListContains(CT_TMG_VisitNm)   then frmTMGVisitType.InitTab (SrcPCEData.CopyVisits,        SrcPCEData);                         //kt added
  if FormListContains(CT_TMG_DiagNm)    then frmTMGDiagnoses.InitTab (SrcPCEData.CopyDiagnoses,     ListDiagnosisSections, SrcPCEData);  //kt added
  if FormListContains(CT_TMG_ProcNm)    then frmTMGProcedures.InitTab(SrcPCEData.CopyProcedures,    ListProcedureSections, SrcPCEData);  //kt added
  if FormListContains(CT_TMG_FolwUpNm)  then begin end; //kt added  //consider code here if I want to load any existing PCEData ...
  if FormListContains(CT_TMG_EnctrMDMNm)then begin end; //kt added  //consider code here if I want to load any existing PCEData ...
  if FormListContains(CT_TMG_LabsNm)    then begin end; //kt added  //consider code here if I want to load any existing PCEData ...
  if FormListContains(CT_GAFNm)         then frmGAF.InitTab          ();  //kt added, but in the end not really needed...

  //kt if FormListContains(CT_ProcNm)   then frmProcedures.InitTab   (SrcPCEData.CopyProcedures, ListProcedureSections);
  //kt if FormListContains(CT_DiagNm)   then frmDiagnoses.InitTab    (SrcPCEData.CopyDiagnoses,     ListDiagnosisSections);
  //kt removed.  Will achieve via frmTMGVisitType.InitFromPCE above.  Was -->  uVisitType.Assign(VisitType);
  //kt removed.  Will achieve via frmTMGVisitType.InitFromPCE above.  Was -->  frmVisitType.MatchVType;
  {//kt removed
  if FormListContains(CT_VisitNm) then begin
    with frmVisitType do begin
      InitList(frmVisitType.lstVTypeSection);                     // set up Visit Type page
      ListSCDisabilities(memSCDisplay.Lines);
      uSCCond := EligbleConditions;
      frmVisitType.fraVisitRelated.InitAllow(uSCCond);
    end;
  end;
  }

end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.FormDestroy(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Free up objects in memory when destroying form.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.FormDestroy(Sender: TObject);
//kt var  i: integer;
begin
  {//kt removing. NOTE: old code below frees the various forms, but leaves dangling pointers, e.g. frmTMGVisitType still holds pointer-held data.
  for i := ComponentCount-1 downto 0 do
    if(Components[i] is TForm) then
      TForm(Components[i]).Free;
  }
  FreeChildForms;  //kt replacement for above.
  FormList.clear;
  uProviders.Free;  //kt changed, was KillObj(@uProviders);
  //kt uVisitType.Free;
  Formlist.free;
  inherited;  //kt moved -- was initially first command in this block.
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: TfrmEncounterFrame.Initialize(SrcPCEData : TPCEData; InitialPageIndex : byte = 0);
//Created: 3/23/23
//By: Kevin Toppenberg
//Location: TMG
//Description: Allow form to initialize itself, using PCE Data
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.Initialize(SrcPCEData : TPCEData; InitialPageIndex : byte = 0);  //kt added
var
  AUser: string;
begin
  uProviders.Assign(SrcPCEData.Providers);
  SetDefaultProvider(uProviders, SrcPCEData);
  AUser := IntToStr(uProviders.PendingIEN(FALSE));
  if(AUser <> '0') and (uProviders.IndexOfProvider(AUser) < 0)
  and AutoCheckout(SrcPCEData.Location) then begin
    uProviders.AddProvider(AUser, uProviders.PendingName(FALSE), FALSE);
  end;

  Caption := 'Encounter Form for ' + ExternalName(SrcPCEData.Location, 44) +
             '  (' + FormatFMDateTime('mmm dd,yyyy@hh:nn', SrcPCEData.VisitDateTime) + ')';

  CreateChildForms(self, SrcPCEData.Location);
  SetFormPosition(self);
  ResizeAnchoredFormToFont(self);
  //SetFormPosition(self);

  SetRPCEncLocation(SrcPCEData.Location);
  SynchPCEData(SrcPCEData);

  TabControl.Tabindex := InitialPageIndex;
  TabControlChange(Self.TabControl);
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.FormCreate(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Create instances of the objects needed.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.FormCreate(Sender: TObject);
begin
  inherited;  //kt added, but not really needed as ancestors don't do anything.
  uProviders := TPCEProviderList.Create;  //kt added, moving from global scope in fEncounterFrame unit.
  //kt uVisitType := TPCEProc.create;
  //uVitalOld  := TStringList.create;
  //uVitalNew  := TStringList.create;
  FormList := TStringList.create;
  fCancel := False;
  FAbort := TRUE;
  SetFormFonts;
  FGiveMultiTabMessage := ScreenReaderSystemActive;
end;


{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.SendData;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Send Data back to the M side sor storing.
///////////////////////////////////////////////////////////////////////////////}
procedure TfrmEncounterFrame.SendData;
//send PCE data to the RPC
{
var
  StoreMessage: string;
  GAFScore: integer;
  GAFDate: TFMDateTime;
  GAFStaff: Int64;
}

begin
  inherited;
  // do validation for vitals & anything else here

  if FormListContains(CT_VitNm) then frmEncVitals.SendData;  //kt
  {//kt moved code to frmEncVitals.SendData
  //process vitals
  if FormListContains(CT_VitNm) then begin
    //with frmEncVitals do
    if frmEncVitals.HasData then begin
      if frmEncVitals.AssignVitals then begin
        StoreMessage := ValAndStoreVitals(frmEncVitals.VitalNew);
        if (Storemessage <> 'True') then begin
          ShowMsg(storemessage);
//        exit;
        end;
      end;
    end;
  end;
  }

  if(FormListContains(CT_GAFNm)) then frmGAF.SendData;  //kt
  {//kt moved code to frmGAF.SendData
  if(FormListContains(CT_GAFNm)) then begin
    frmGAF.GetGAFScore(GAFScore, GAFDate, GAFStaff);
    if (GAFScore > 0) then begin
      SaveGAFScore(GAFScore, GAFDate, GAFStaff);
    end;
  end;
  }

  if FormListContains(CT_TMG_FolwUpNm)   then frmFollowUp.SendData;      //kt added.
  if FormListContains(CT_TMG_LabsNm)     then frmEnounterLabs.SendData;  //kt added.
  if FormListContains(CT_TMG_EnctrMDMNm) then frmEncounterMDM.SendData;  //kt added.

  //PCE

  //kt This copies GUI data --> PCE data
  UpdateEncounter(Self.PCEData);  //kt.  Was UpdateEncounter(uEncPCEData);  Really the same thing

  FSaveNeeded := not FSaveNeeded;  //kt
  if FAutoSave then Self.PCEData.Save;  //kt.

  {
  //kt.  Was with uEncPCEData do begin
  if FAutoSave then begin
    Self.PCEData.Save;  //kt.  Was Save
  end else begin
    FSaveNeeded := TRUE;
  end;
  }

  Close;
  //kt NOTE: this seems out of place.  Seems like this should be done elsewhere....  Will leave VA standard
  //
  //Since this is only called by FormCloseQuery (in respones to frmEnounterFrame.OnCloseQuery event)
  //    when CanClose is true, then if this Close() were not called, then it would be called by
  //    the code that generates the OnCloseQuery event.  So seems redundant...
end;

{///////////////////////////////////////////////////////////////////////////////
//Name: procedure TfrmEncounterFrame.FormCloseQuery(Sender: TObject;
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description: Check to see if the Cancel button was pressed, if not, call
// procedure to send the data to the server.
///////////////////////////////////////////////////////////////////////////////}
//kt NOTE: Called by frmEncounterFrame OnCloseQuery event.
procedure TfrmEncounterFrame.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
const
  TXT_SAVECHANGES = 'Save Changes?';

var
  TmpPCEData: TPCEData;
  ask, ChangeOK: boolean;

begin
  CanClose := True;
  if FAbort then FCancel := (InfoBox(TXT_SAVECHANGES, TXT_SAVECHANGES, MB_YESNO) = ID_NO);
  if FCancel then Exit;  //*KCM*

  if(uProviders.PrimaryIdx >= 0) then begin
    ask := TRUE
  end else begin
    TmpPCEData := TPCEData.Create;
    try
      uEncPCEData.CopyPCEData(TmpPCEData);
      UpdateEncounter(TmpPCEData);
      ask := TmpPCEData.NeedProviderInfo;
    finally
      TmpPCEData.Free;
    end;
  end;
  if ask and NoPrimaryPCEProvider(uProviders, uEncPCEData) then begin
    InfoBox(TX_PROV_REQ, TC_PROV_REQ, MB_OK or MB_ICONWARNING);
    CanClose := False;
    Exit;
  end;

  if Assigned(frmTMGVisitType) then frmTMGVisitType.VisitTypesList.SetProvider(uProviders.PrimaryIEN); //kt
  //kt original --> uVisitType.Provider := uProviders.PrimaryIEN;  {RV - v20.1}

  if FormListContains(CT_VitNm) then begin
    CanClose := frmEncVitals.OK2SaveVitals;
  end;

  //kt added
  if CanClose and FormListContains(CT_TMG_VisitNm) then begin
    CanClose := frmTMGVisitType.OK2SaveVisits;
    if not CanClose then begin
      tabPageChange(Self, FormList.IndexOf(CT_TMG_VisitNm), ChangeOK);
      SwitchToPage(PageIDToForm(CT_TMG_VISITTYPE));
      TabControl.TabIndex := FormList.IndexOf(CT_TMG_VisitNm);
    end;
  end;

  {//kt
  if CanClose and FormListContains(CT_ProcNm) then begin
    CanClose := frmProcedures.OK2SaveProcedures;
    if not CanClose then begin
      tabPageChange(Self, FormList.IndexOf(CT_ProcNm), ChangeOK);
      SwitchToPage(PageIDToForm(CT_PROCEDURES));
      TabControl.TabIndex := FormList.IndexOf(CT_ProcNm);
    end;
  end;
  }

  if CanClose and FormListContains(CT_TMG_ProcNm) then begin
    CanClose := frmTMGProcedures.OK2SaveProcedures;
    if not CanClose then begin
      tabPageChange(Self, FormList.IndexOf(CT_TMG_ProcNm), ChangeOK);
      SwitchToPage(PageIDToForm(CT_TMG_PROCEDURES));
      TabControl.TabIndex := FormList.IndexOf(CT_TMG_ProcNm);
    end;
  end;

  if CanClose then SendData;  //*KCM*   //kt NOTE: SendData calls TfrmEncounterFrame.Close
end;

procedure TfrmEncounterFrame.TabControlChange(Sender: TObject);
var  i: integer;
begin
  //must switch based on caption, as all tabs may not be present.
  if (sender as tTabControl).tabindex = -1 then exit;

  if TabControl.CanFocus and Assigned(FLastPage) and not TabControl.Focused then
    TabControl.SetFocus;  //CQ: 14845

  for i := CT_FIRST to CT_LAST do begin
    with Formlist do begin
      with sender as tTabControl do begin
        if Tabindex = IndexOf(PageIdToTab(i)) then begin
          PageIDToForm(i).show;
          SwitchToPage(PageIDToForm(i));
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TfrmEncounterFrame.TabControlChanging(Sender: TObject; var AllowChange: Boolean);
begin
  if(assigned(FLastPage)) then
    FLastPage.AllowTabChange(AllowChange);
end;

procedure TfrmEncounterFrame.UpdateEncounter(DestPCE: TPCEData);
//kt note:  This is GUI's --> PCE data
begin
  if FormListContains(CT_ImmNm)          then DestPCE.SetImmunizations(frmImmunizations.lbGrid.Items);
  if FormListContains(CT_SkinNm)         then DestPCE.SetSkinTests(frmSkinTests.lbGrid.Items);
  if FormListContains(CT_PedNm)          then DestPCE.SetPatientEds(frmPatientEd.lbGrid.Items);
  if FormListContains(CT_HlthNm)         then DestPCE.SetHealthFactors(frmHealthFactors.lbGrid.Items);
  if FormListContains(CT_XamNm)          then DestPCE.SetExams(frmExams.lbGrid.Items);
  if FormListContains(CT_TMG_DiagNm)     then DestPCE.SetDiagnoses(frmTMGDiagnoses.lbGrid.Items);     //kt added
  if FormListContains(CT_TMG_ProcNm)     then DestPCE.SetProcedures(frmTMGProcedures.lbGrid.Items);   //kt added
  if FormListContains(CT_TMG_VisitNm)    then DestPCE.SetVisits(frmTMGVisitType.VisitTypesList);      //kt added.
  if FormListContains(CT_TMG_FolwUpNm)   then begin end; //kt added -- consider code here putting form data into Encounter
  if FormListContains(CT_TMG_EnctrMDMNm) then begin end; //kt added -- consider code here putting form data into Encounter
  if FormListContains(CT_TMG_LabsNm)     then begin end; //kt added -- consider code here putting form data into Encounter
  //kt if FormListContains(CT_ProcNm)    then DestPCE.SetProcedures(frmProcedures.lbGrid.Items);
  //kt if FormListContains(CT_DiagNm)    then DestPCE.SetDiagnoses(frmDiagnoses.lbGrid.Items);
  DestPCE.Providers.Merge(uProviders);  //kt moved, was inside handling CT_TMG_VisitNm
end;

procedure TfrmEncounterFrame.SelectTab(NewTabName: string);
var  AllowChange: boolean;
begin
  AllowChange := True;
  tabControl.TabIndex := FormList.IndexOf(NewTabName);
  tabPageChange(Self, tabControl.TabIndex, AllowChange);
end;

procedure TfrmEncounterFrame.SelectNextTab; //kt added 2/1/23
var index : integer;
    AllowChange: boolean;
begin
  if tabControl.Tabs.Count = 0 then exit;
  index := tabControl.TabIndex + 1;
  if index >= tabControl.Tabs.Count then index := 0;
  tabControl.TabIndex := index;
  AllowChange := True;
  tabPageChange(Self, tabControl.TabIndex, AllowChange);
end;

procedure TfrmEncounterFrame.TabControlEnter(Sender: TObject);
begin
  if FGiveMultiTabMessage then // CQ#15483
  begin
    FGiveMultiTabMessage := FALSE;
    GetScreenReader.Speak('Multi tab form');
  end;
end;

procedure TfrmEncounterFrame.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var CanChange: boolean;
begin
  inherited;
  if (Key = VK_ESCAPE) then begin
    Key := 0;
    FLastPage.btnCancel.Click;
  end else if Key = VK_TAB then begin
    if ssCtrl in Shift then begin
      CanChange := True;
      if Assigned(TabControl.OnChanging) then
        TabControl.OnChanging(TabControl, CanChange);
      if CanChange then begin
        if ssShift in Shift then begin
          if TabControl.TabIndex < 1 then begin
            TabControl.TabIndex := TabControl.Tabs.Count -1
          end else begin
            TabControl.TabIndex := TabControl.TabIndex - 1;
          end;
        end else begin
          TabControl.TabIndex := (TabControl.TabIndex + 1) mod TabControl.Tabs.Count;
        end;
        if Assigned(TabControl.OnChange) then begin
          TabControl.OnChange(TabControl);
        end;
      end;
      Key := 0;
    end;
  end;
end;

procedure TfrmEncounterFrame.SetFormFonts;
var NewFontSize: integer;
begin
  NewFontSize := MainFontsize;
  if FormListContains(CT_DiagNm)         then frmDiagnoses.Font.Size := NewFontSize;
  if FormListContains(CT_ImmNm)          then frmImmunizations.Font.Size := NewFontSize;
  if FormListContains(CT_SkinNm)         then frmSkinTests.Font.Size := NewFontSize;
  if FormListContains(CT_PedNm)          then frmPatientEd.Font.Size := NewFontSize;
  if FormListContains(CT_HlthNm)         then frmHealthFactors.Font.Size := NewFontSize;
  if FormListContains(CT_XamNm)          then frmExams.Font.Size := NewFontSize;
  if FormListContains(CT_VitNm)          then frmEncVitals.Font.Size := NewFontSize;
  if FormListContains(CT_GAFNm)          then frmGAF.SetFontSize(NewFontSize);
  if FormListContains(CT_TMG_VisitNm)    then frmTMGVisitType.Font.Size := NewFontSize;     //kt added
  if FormListContains(CT_TMG_DiagNm)     then frmTMGDiagnoses.Font.Size := NewFontSize;     //kt added
  if FormListContains(CT_TMG_ProcNm)     then frmTMGProcedures.Font.Size := NewFontSize;    //kt added
  if FormListContains(CT_TMG_FolwUpNm)   then frmFollowUp.SetFontSize(NewFontSize);         //kt added
  if FormListContains(CT_TMG_EnctrMDMNm) then frmEncounterMDM.SetFontSize(NewFontSize);     //kt added
  if FormListContains(CT_TMG_LabsNm)     then frmEnounterLabs.SetFontSize(NewFontSize);     //kt added
  //kt if FormListContains(CT_ProcNm)    then frmProcedures.Font.Size := NewFontSize;
  //kt if FormListContains(CT_VisitNm)   then frmVisitType.Font.Size := NewFontSize;
end;

procedure TfrmEncounterFrame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveUserBounds(Self);
end;

procedure TfrmEncounterFrame.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  //CQ4740
  if NewWidth < 200 then begin
    NewWidth := 200;
    Resize := false;
  end;
end;

procedure TfrmEncounterFrame.FormShow(Sender: TObject);
begin
  inherited;
  if TabControl.CanFocus then begin
    TabControl.SetFocus;
  end;
end;

end.
