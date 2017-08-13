unit uTMGAllscriptsDriver;

interface

  uses
    Forms, SysUtils,Variants, ExtCtrls, Classes, StrUtils,
    uTMGWebDriver, uCore, ORFn,
    TMGHTML2, dialogs, SHDocVw, MSHTMLEvents,MSHTML_EWB,MSHTML;


Procedure AllScriptsSyncToPatient(WB: THtmlObj; URL: WideString; Patient: TPatient);


implementation

(*
[STATES]  {Actions}

 [Undef] ---> {browse to base URL} --> [wpsAtLoginForm] --> ...

 ... --> {Enter credentials and click Login} --> [wpsAtLoginAnimation] --> ...

 ... --> [wpsAtSelectPatient] -->  {Enter patient name, DOB, click Search} --> ...

 ... --> [wpsAtPickFoundPatient] -->  {Select Patient} --> [wpsAtPatientSelected] --> ...

 ... --> Options:
  1. ||To Prescribe A Medication|| --> {click Select Med} --> [wpsAtSelectMed]

  2. ||To Get Medication History|| --> {Click Review History} --> [wpsAtReviewMeds]


Issues:
 -- The "WebState" needs to be combination of 2 factors: 1) are we at correct
    part of the web site, and 2) do we have the right patient selected?

 -- So if we are at the SelectMedication screen, but patient is wrong, then
    we need to go back to the SelectPatient screen.

*)



type
  wpStates = (wpsUnknown,
              wpsAtLoginForm,
              wpsAtLoginAnimation,
              wpsAtSelectPatient,
              wpsAtSinglePatientFound,
              wpsAtZeroOrMultiplePatientsFound,
              wpsAtPatientSelected,
              wpsAtSelectMed,
              wpsAtReviewMeds
             );
  wpActions = (wpaNoAction,
               wpaWaitLonger,
               wpaBrowseToURL,
               wpaEnterCredentialsAndLogin,
               wpaEnterPatientInfoAndSearch,
               wpaSelectSingleFoundPatient,
               wpaClickSelectMed,
               wpaClickReviewHistory,
               wpaClickBackToSelectPt,
               wpaScrapeMeds
              );

  TWebsitePatient = record
    LastName : string;
    LastNameRaw : string;
    FirstName : string;
    FirstNameRaw : string;
    Gender : string;
    DOB : string;
    DOBGenderRaw : string;
    MRN : string;
    MatchedVistADFN : string;
  end;

  TCredentials = record
    Login, Password : string;
  end;

  TTMGAllscriptsDriver = class(TObject)
  private
    function DriveClickReviewHistory(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
    function DriveClickBackToSelectPt(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
    function DriveScrapeMeds(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
    function DriveClickSelectMed(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
    function DriveSelectSingleFoundPatient(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
    function DriveEnterPatientInfoAndSearch(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
    function DriveEnterCredentialsAndLogin(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
    function GetWebPageState(WB: THtmlObj; var ErrMsg : string) : wpStates;
    function GetWebSitePatient(var ErrMsg : string): boolean; //returns True if website = VistaPatient, False if wrong patient
    function GetNextAction(DesiredWebState : wpStates; var ErrMsg : string) : wpActions;
    function DriveNextAction(Action : wpActions; var ErrMsg : string) : boolean; //Result is if timer should be re-enabled
    function GetCredentials : TCredentials;
    procedure HandlePtSrchGetElementCallback (Elem : MSHTML_EWB.IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean);
    procedure GetSearchPatientsResultsList (AList : TInterfaceList);
    function GetSearchPatientsResultsCount : integer;
  public
    InitURL : string;
    WB : THtmlObj;
    VistACurrentPatient: TPatient;  //pointer to object controlled elsewhere.
    WebSitePatient: TWebsitePatient;
    GoalWebPageState: wpStates;
    procedure HandleTimerEvent(Sender : TObject);
  end;


var
  TMGAllscriptsBackgroundTimer : TTimer;
  TMGAllscriptsDriver : TTMGAllscriptsDriver;


Procedure AllScriptsSyncToPatient(WB: THtmlObj; URL: WideString; Patient: TPatient);
//URL should always be the default, login-in URL
var ErrMsg : string;
    PatientMatches : boolean;
begin
  if TMGAllscriptsDriver.InitURL = '' then begin  //should be first cycle only
    WB.Navigate(URL);
    TMGAllscriptsDriver.InitURL := URL;
    TMGAllscriptsDriver.WB := WB;
    TMGAllscriptsBackgroundTimer.Interval := 5*1000;  //fire event to login after __ seconds
    TMGAllscriptsBackgroundTimer.OnTimer := TMGAllscriptsDriver.HandleTimerEvent;
    TMGAllscriptsDriver.VistACurrentPatient := Patient;
    TMGAllscriptsDriver.GoalWebPageState := wpsAtSelectMed;
    TMGAllscriptsBackgroundTimer.Enabled := true;
  end else begin
    PatientMatches := TMGAllscriptsDriver.GetWebSitePatient(ErrMsg);
    if ErrMsg <> '' then begin
      MessageDlg(ErrMsg, mtError, [mbOK], 0);
      exit;
    end;
    if (Patient.DFN = '') or (not PatientMatches) then begin
      TMGAllscriptsBackgroundTimer.Enabled := true;
    end else begin
      //Nothing to be done here, so don't enable timer
    end;
  end;
end;

procedure ClearWebSitePatient (WSPatient : TWebsitePatient);
begin
  WSPatient.LastName := '';
  WSPatient.FirstName := '';
  WSPatient.Gender := '';
  WSPatient.DOB := '';
  WSPatient.MRN := '';
  WSPatient.MatchedVistADFN := '';
end;


//================================================================================

function TTMGAllscriptsDriver.GetWebSitePatient(var ErrMsg : string): boolean; //returns True if website = VistaPatient, False if wrong patient
  procedure LookupWSPatient(var WSPatient : TWebsitePatient);
  var temp : string;
  begin
    //process  LastNameRaw --> LastName
    temp := UpperCase(WSPatient.LastNameRaw);
    while (length(temp)>0) and (temp[length(temp)] in [' ',',']) do temp := LeftStr(temp, length(temp)-1);
    WSPatient.LastName := temp;

    //process  FirstnameRaw --> FirstName
    temp := UpperCase(WSPatient.FirstNameRaw);
    while (length(temp)>0) and (temp[length(temp)] in [' ',',']) do temp := LeftStr(temp, length(temp)-1);
    WSPatient.FirstName := temp;

    //Process  DOBGenderRaw --> DOB and Gender   e.g. of value: 'April 14, 1972 (45 Y) | Female'
    temp := UpperCase(WSPatient.DOBGenderRaw);
    temp := Trim(Piece(temp, '(', 1)); //e.g. 'APRIL 14, 1972'
    WSPatient.DOB := temp;
    temp := UpperCase(WSPatient.DOBGenderRaw);
    temp := Trim(Piece(temp, '|', 2)); //e.g. 'FEMALE'
    if temp='' then temp := ' ';
    if temp[1]='F' then WSPatient.Gender := 'F' else WSPatient.Gender := 'M';

    if (WSPatient.LastName = '') or
       (WSPatient.FirstName = '') or
       (WSPatient.DOB = '') or
       (WSPatient.Gender = '') then begin
       WSPatient.MatchedVistADFN := ''  //can't look up because missing demographics
    end else begin
      //At this point we should have LNAME, FNAME, EXTERNAL DOB, GENDER
      //FINISH!!
      //do VistA lookup via RPC.
      //Put resulting DFN into MatchedVistADFN
    end;
  end;

var Value : string;
    CurWSPatient : TWebsitePatient;
    Success: boolean;
begin
  ClearWebSitePatient(CurWSPatient);
  Success := GetInnerTextById(WB, 'lblPatientLast', Value, ErrMsg);
  if ErrMsg <> '' then begin
    CurWSPatient.LastNameRaw := Trim(Value);
    Success := GetInnerTextById(WB, 'lblPatientFirst', Value, ErrMsg);
    if ErrMsg <> '' then begin
      CurWSPatient.FirstNameRaw := Trim(Value);
      Success := GetInnerTextById(WB, 'lblGenderDob', Value, ErrMsg);
      if ErrMsg <> '' then begin
        CurWSPatient.DOBGenderRaw := Trim(Value);
        Success := GetInnerTextById(WB, 'lblMrn', Value, ErrMsg);
        if ErrMsg <> '' then begin
          CurWSPatient.MRN := Trim(Value);
        end;
      end;
    end;
  end;

  if (CurWSPatient.LastNameRaw <> Self.WebSitePatient.LastNameRaw) or
    (CurWSPatient.FirstNameRaw <> Self.WebSitePatient.FirstNameRaw ) or
    (CurWSPatient.DOBGenderRaw <> Self.WebSitePatient.DOBGenderRaw ) or
    (CurWSPatient.MRN <> Self.WebSitePatient.MRN) then begin
    ClearWebSitePatient(Self.WebSitePatient);
    Self.WebSitePatient := CurWSPatient;
    LookupWSPatient(Self.WebSitePatient);
  end;
  Result := Self.VistACurrentPatient.DFN = Self.WebSitePatient.MatchedVistADFN;
end;


procedure TTMGAllscriptsDriver.HandlePtSrchGetElementCallback (Elem : MSHTML_EWB.IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean);
var Id : string;
begin
  if not assigned(Elem) then exit;
  Id := Elem.id;
  if Pos('grdViewPatients_ctl00_', Id)<1 then exit;
  TInterfaceList(Obj).Add(Elem);
end;

procedure TTMGAllscriptsDriver.GetSearchPatientsResultsList (AList : TInterfaceList);
begin
  WB.IterateElements(HandlePtSrchGetElementCallback, '', AList);
end;

function TTMGAllscriptsDriver.GetSearchPatientsResultsCount : integer;
var AList : TInterfaceList;
begin
  Result := 0;
  AList := TInterfaceList.Create;
  GetSearchPatientsResultsList(AList);
  Result := AList.Count;
  AList.Free;
end;


function TTMGAllscriptsDriver.GetWebPageState(WB: THtmlObj; var ErrMsg : string) : wpStates;
var SearchLName, SelectedLName : string;
    Count : integer;
begin
  Result := wpsUnknown;
  if Assigned(WB.GetElementByClass('loginform')) then begin  //Test for loginform
    Result := wpsAtLoginForm;  exit;
  end;
  if Assigned(WB.GetElementById('ctl00_ContentPlaceHolder1_txtSearchMed')) then begin
    Result := wpsAtSelectMed;  exit;
  end;
  if Assigned(WB.GetElementById('searchPanel')) then begin
    Result := wpsAtSelectPatient;
    if Assigned(WB.GetElementById('PatientSearch_txtLastName')) then begin  //At page with field to enter patient name, DOB
      if not GetInnerTextById(WB, 'lblPatientFirst', SelectedLName, ErrMsg) then exit;
      if not GetInnerTextById(WB, 'PatientSearch_txtLastName', SearchLName, ErrMsg) then exit;
      SelectedLName := Trim(SelectedLName);
      SearchLName := Trim(SearchLName);
      Count := GetSearchPatientsResultsCount;
      if (SelectedLName = '[No Patient Selected]') or (SelectedLName = '') then begin
        if SearchLName <> '' then begin  //user has searched for patient names.  How many results?
          if Count=1 then begin
            Result := wpsAtSinglePatientFound  //Search name entered, no patient selected, and only one patient result below.
          end else Result := wpsAtZeroOrMultiplePatientsFound;  //Search name entered, no patient selected, and 0 or mult patients in result below.
        end else begin
          Result := wpsAtSelectPatient;  //Search name NOT entered, no patient selected
        end;
      end else begin
        //At the search page, and there is a patient name in the top part, Selected patient.
        Result := wpsAtPatientSelected;
      end;
    end;
  end;
  if assigned(WB.GetElementByClass('erxTable')) then begin
    Result := wpsAtReviewMeds;  exit;
  end;
  //Finish testing for these states....   wpsAtLoginAnimation,
end;


function TTMGAllscriptsDriver.GetNextAction(DesiredWebState : wpStates; var ErrMsg : string) : wpActions;
var CurState : wpStates;
    CorrectPatient : boolean;
begin
  Result := wpaNoAction;
  CurState := GetWebPageState(WB, ErrMsg);  //Finish, handle ErrMsg
  if not (CurState in [wpsUnknown, wpsAtLoginForm, wpsAtLoginAnimation, wpsAtSelectPatient]) then begin
    CorrectPatient := GetWebSitePatient(ErrMsg);
  end else CorrectPatient := False;
  case CurState of
    wpsUnknown:                       Result := wpaBrowseToURL;
    wpsAtLoginForm:                   Result := wpaEnterCredentialsAndLogin;
    wpsAtLoginAnimation:              Result := wpaWaitLonger;
    wpsAtSelectPatient:               Result := wpaEnterPatientInfoAndSearch;
    wpsAtSinglePatientFound:          Result := wpaSelectSingleFoundPatient;
    wpsAtZeroOrMultiplePatientsFound: Result := wpaNoAction;
    wpsAtPatientSelected: begin
      if not CorrectPatient then begin
        Result := wpaEnterPatientInfoAndSearch;
      end else begin
        case DesiredWebState of
          wpsAtSelectMed : Result := wpaClickSelectMed;
          wpsAtReviewMeds : Result := wpaClickReviewHistory;
        end; {case}
      end;
    end;
    wpsAtSelectMed: begin
      if not CorrectPatient then begin
        Result := wpaClickBackToSelectPt;
      end else begin
        Result := wpaNoAction;  //ready for user to work with web site.
      end;
    end;
    wpsAtReviewMeds: begin
      if not CorrectPatient then begin
        Result := wpaClickBackToSelectPt;
      end else begin
        Result := wpaScrapeMeds;
      end;
    end;
  end; {case}
end;

function TTMGAllscriptsDriver.DriveNextAction(Action : wpActions; var ErrMsg : string) : boolean; //Result is if timer should be re-enabled
begin
  ErrMsg := '';
  Result := true;
  case Action of
    wpaNoAction:                  Result := false;
    wpaWaitLonger:                exit;
    wpaBrowseToURL:               WB.Navigate(InitURL);
    wpaEnterCredentialsAndLogin:  Result := DriveEnterCredentialsAndLogin(ErrMsg);
    wpaEnterPatientInfoAndSearch: Result := DriveEnterPatientInfoAndSearch(ErrMsg);
    wpaSelectSingleFoundPatient:  Result := DriveSelectSingleFoundPatient(ErrMsg);
    wpaClickSelectMed:            Result := DriveClickSelectMed(ErrMsg);
    wpaClickReviewHistory:        Result := DriveClickReviewHistory(ErrMsg);
    wpaClickBackToSelectPt:       Result := DriveClickBackToSelectPt(ErrMsg);
    wpaScrapeMeds:                Result := DriveScrapeMeds(ErrMsg);
  end;
end;

function TTMGAllscriptsDriver.DriveEnterCredentialsAndLogin(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
var Credentials : TCredentials;
begin
  ErrMsg := '';
  Result := true;
  Credentials := GetCredentials;
  if (Credentials.Login = '') or (Credentials.Password = '') then begin
    Result := false; //a signal to stop timer callbacks.
    exit;
  end;
  Result := FillInputValueById(WB, 'txtUserName', Credentials.Login, ErrMsg);
  if ErrMsg <> '' then exit;
  Result := Result and FillInputValueById(WB, 'txtPassword', Credentials.Password, ErrMsg);
  if ErrMsg <> '' then exit;
  Result := Result and ButtonClickById(WB, 'btnLogin', ErrMsg);
  if ErrMsg <> '' then exit;
end;

function TTMGAllscriptsDriver.DriveEnterPatientInfoAndSearch(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
begin
  //finish
end;

function TTMGAllscriptsDriver.DriveSelectSingleFoundPatient(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
begin
  //finish
end;

function TTMGAllscriptsDriver.DriveClickSelectMed(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
begin
  //finish
end;

function TTMGAllscriptsDriver.DriveClickReviewHistory(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
begin
  //finish
end;

function TTMGAllscriptsDriver.DriveClickBackToSelectPt(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
begin
  //finish
end;

function TTMGAllscriptsDriver.DriveScrapeMeds(var ErrMsg : string) : boolean; //returns false if ErrMsg <> ''
begin
  //finish
end;



procedure TTMGAllscriptsDriver.HandleTimerEvent(Sender : TObject);
var Success: boolean;
    ErrMsg : string;
    NextAction: wpActions;
begin
  TMGAllscriptsBackgroundTimer.Enabled := false; //prevent further event firing unless turned back on
  NextAction := GetNextAction(Self.GoalWebPageState,ErrMsg);
  if ErrMsg <> '' then begin
    MessageDlg(ErrMsg, mtError, [mbOK], 0);
    exit;
  end;
  Success := DriveNextAction(NextAction, ErrMsg);
  if ErrMsg <> '' then begin
    MessageDlg(ErrMsg, mtError, [mbOK], 0);
    exit;
  end;
  TMGAllscriptsBackgroundTimer.Enabled := Success;
end;


function TTMGAllscriptsDriver.GetCredentials : TCredentials;
//Later tie into an RPC call
begin
  Result.Login := 'fpofgreeneville';
  Result.Password :='lipw4ERx0';
end;


Initialization
  TMGAllscriptsDriver := TTMGAllscriptsDriver.Create;
  TMGAllscriptsDriver.VistACurrentPatient := Nil;
  TMGAllscriptsDriver.InitURL := '';
  TMGAllscriptsBackgroundTimer := TTimer.Create(Application);
  TMGAllscriptsBackgroundTimer.Enabled := false;

Finalization
  TMGAllscriptsDriver.Free;
  //If not commented, causes crash on shutdown --> TMGAllscriptsBackgroundTimer.Free;
end.
