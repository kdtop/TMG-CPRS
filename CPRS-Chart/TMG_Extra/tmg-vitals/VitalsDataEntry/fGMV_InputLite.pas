unit fGMV_InputLite;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 4 $  $Modtime: 7/22/05 10:15a $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Main form for entering a new series of vitals for pt.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry/fGMV_InputLite.pas $
*
* $History: fGMV_InputLite.pas $
 *
 * *****************  Version 4  *****************
 * User: Vhaishandria Date: 7/22/05    Time: 3:51p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry
 *
 * *****************  Version 3  *****************
 * User: Vhaishandria Date: 7/06/05    Time: 12:11p
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsDataEntry
 *
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 7/05/05    Time: 9:38a
 * Updated in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
 *
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 3:35p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/VitalsDataEntry
 *
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 4/23/04    Time: 1:21p
 * Updated in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
 *
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:20p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSDATAENTRY
 *
 * *****************  Version 2  *****************
 * User: Vhaishandria Date: 2/06/04    Time: 4:47p
 * Updated in $/VitalsLite/VitalsLiteDLL
 *
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 1/30/04    Time: 4:30p
 * Created in $/VitalsLite/VitalsLiteDLL
 *
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 1/15/04    Time: 3:06p
 * Created in $/VitalsLite/VitalsLiteDLL
 * Vitals Lite DLL
 *
================================================================================
}
interface

uses
  System.UITypes,  //kt //codex 8/26/26
  Windows,
  ShellAPI,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComCtrls, Menus, StdActns, ActnList, ImgList, ToolWin, Buttons, Grids
  , uGMV_Template
  , uGMV_Const
  , AppEvnts, System.Actions, System.ImageList
{$IFDEF USEVSMONITOR}
, uGMV_Monitor
{$ENDIF}
  ;

type
  TfrmGMV_InputLite = class(TForm)
    pnlBottom: TPanel;
    pnlInput: TPanel;
    pnlParams: TPanel;
    pnlTemplates: TPanel;
    gbxTemplates: TGroupBox;
    imgTemplates: TImageList;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    tv: TTreeView;
    pnlTemplInfo: TPanel;
    lblTemplInfo: TLabel;
    splParams: TSplitter;
    splLastVitals: TSplitter;
    pnlButtons: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    alInputVitals: TActionList;
    acMetricStyleChange: TAction;
    acSavePreferences: TAction;
    acLoadPreferences: TAction;
    acPatientSelected: TAction;
    Splitter1: TSplitter;
    pnlTools: TPanel;
    pnlPatient: TPanel;
    pnlSettings: TPanel;
    lblHospital: TLabel;
    lblDateTime: TLabel;
    acTemplateClicked: TAction;
    acSetOnPass: TAction;
    acSaveInput: TAction;
    ImageList1: TImageList;
    acCheckBoxesChange: TAction;
    PopupMenu2: TPopupMenu;
    PatienOnPass1: TMenuItem;
    acDateTimeSelector: TAction;
    acHospitalSelector: TAction;
    acTemplateSelect: TAction;
    lblHospitalCap: TLabel;
    Label2: TLabel;
    tlbInput: TToolBar;
    sbtnHospitals: TSpeedButton;
    acParamsShowHide: TAction;
    acVitalsShowHide: TAction;
    acAdjustToolbars: TAction;
    acTemplateSelector: TAction;
    ToolButton2: TToolButton;
    sbtnTemplates: TSpeedButton;
    pnlInputTemplate: TPanel;
    pnlInputTemplateHeader: TPanel;
    hc: THeaderControl;
    pnlScrollBox: TPanel;
    sbxMain: TScrollBox;
    pnlLatestVitalsBg: TPanel;
    pnlLatestVitalsHeader: TPanel;
    pnlOptions: TPanel;
    bvU: TBevel;
    ckbOnPass: TCheckBox;
    pnlCPRSMetricStyle: TPanel;
    chkCPRSSTyle: TCheckBox;
    Bevel1: TBevel;
    Panel13: TPanel;
    strgLV: TStringGrid;
    WindowClose1: TWindowClose;
    bvUnavailable: TBevel;
    lblUnavailable: TLabel;
    ckbUnavailable: TCheckBox;
    Label3: TLabel;
    chkbCloseOnSave: TCheckBox;
    chkOneUnavailableBox: TCheckBox;
    acUnavailableBoxStatus: TAction;
    gbDateTime: TGroupBox;
    dtpDate: TDateTimePicker;
    dtpTime: TDateTimePicker;
    sbtnToolShowParams: TSpeedButton;
    pnlParamTools: TPanel;
    SpeedButton4: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel10: TPanel;
    sbtnTemplateTree: TSpeedButton;
    Panel3: TPanel;
    sbtnShowLatestVitals: TSpeedButton;
    gbxPatients: TGroupBox;
    Panel1: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    lvSelPatients: TListView;
    pnlCasmed: TPanel;
    spbDevice: TSpeedButton;
    alDevice: TActionList;
    acGetCASMEDData: TAction;
    acCASMEDReset: TAction;
    acGetCASMEDDescription: TAction;
    btnSaveAndExit: TButton;
    pnlMonitor: TPanel;
    sbMonitor: TSpeedButton;
    acMonitorGetData: TAction;
    SpeedButton1: TSpeedButton;
    SpeedButton5: TSpeedButton;
    cbR: TCheckBox;
    cbU: TCheckBox;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel7: TPanel;
    cbConversionWarning: TCheckBox;
    Bevel4: TBevel;
    acPatientInfo: TAction;
    MainMenu1: TMainMenu;
    acPatientInfo1: TMenuItem;
    edPatientName: TEdit;
    edPatientInfo: TEdit;
    Hospital1: TMenuItem;
    ExpView1: TMenuItem;
    LatestV1: TMenuItem;
    DateTime1: TMenuItem;
    StatusBar: TStatusBar;
    acShowStatusBar: TAction;
    ShowHideStatusBar1: TMenuItem;
    File1: TMenuItem;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dtpTimeChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tvChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure acMetricStyleChangeExecute(Sender: TObject);
    procedure ckbOnPassEnter(Sender: TObject);
    procedure ckbOnPassExit(Sender: TObject);
    procedure acSavePreferencesExecute(Sender: TObject);
    procedure acLoadPreferencesExecute(Sender: TObject);
    procedure tvExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvCollapsed(Sender: TObject; Node: TTreeNode);
    procedure pnlParamsResize(Sender: TObject);
    procedure acSetOnPassExecute(Sender: TObject);
    procedure acSaveInputExecute(Sender: TObject);
    procedure ckbOnPassClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure acDateTimeSelectorExecute(Sender: TObject);
    procedure acHospitalSelectorExecute(Sender: TObject);
    procedure pnlLatestVitalsBgResize(Sender: TObject);
    procedure strgLVDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure ckbUnavailableEnter(Sender: TObject);
    procedure ckbUnavailableExit(Sender: TObject);
    procedure ckbUnavailableClick(Sender: TObject);
    procedure acUnavailableBoxStatusExecute(Sender: TObject);
    procedure acParamsShowHideExecute(Sender: TObject);
    procedure acAdjustToolbarsExecute(Sender: TObject);
    procedure acVitalsShowHideExecute(Sender: TObject);
    procedure lvSelPatientsClick(Sender: TObject);
    procedure lvSelPatientsChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure lvSelPatientsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormDestroy(Sender: TObject);
    procedure acGetCASMEDDataExecute(Sender: TObject);
    procedure acCASMEDResetExecute(Sender: TObject);
    procedure acGetCASMEDDescriptionExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acMonitorGetDataExecute(Sender: TObject);
    procedure cbRClick(Sender: TObject);
    procedure hcMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure cbConversionWarningClick(Sender: TObject);
    procedure pnlPatientEnter(Sender: TObject);
    procedure pnlPatientExit(Sender: TObject);
    procedure pnlPatientClick(Sender: TObject);
    procedure acPatientInfoExecute(Sender: TObject);
    procedure edPatientNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acShowStatusBarExecute(Sender: TObject);
    procedure pnlPatientMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlPatientMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hcSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);  //kt //codex 8/27/26
    //kt //codex added entire function/procedure 8/27/26
  private
    FTmpltRoot: TTreeNode;
    FTmpltDomainRoot: TTreeNode;
    FTmpltInstitutionRoot: TTreeNode;
    FTmpltHopsitalLocationRoot: TTreeNode;
    FTmpltNewPersonRoot: TTreeNode;
    FNewTemplate: string;
    FNewTemplateDescription:String;
    FDefaultTemplate, // AAN 08/27/2002
    FInputTemplate: TGMV_Template;
    FTemplateData: string;
    FDFN: string;
    CurrentTime:TDateTime;//AAN 07/11/2002

    fStatus:String;

    fFileVersion: String; // vhaishandria 050415
    fFileComments: String; // vhaishandria 050415

    // VS monitor support;
{$IFDEF USEVSMONITOR}
   fMonitor: TGMV_Monitor;
{$ENDIF}

    bShowVitals,
    bShowParams: Boolean;
    bDataUpdated: Boolean;
    bSlave:Boolean;
    _FCurrentPtIEN: string;
    _FHospitalIEN: String;
    procedure _SetCurrentPtIEN(const Value: string);
    procedure LoadTreeView;
    procedure InsertTemplate(Template: TGMV_Template; GoToTemplate: Boolean = False);
    procedure SetVitalsList(InputTemplate:String);
    procedure ClearVitalsList;
    procedure CleanUpVitalsList;
    procedure UpdateLatestVitals(aPatient:String;bSilent:Boolean);
    procedure FocusInputField;
    function InputString: String;
    procedure SaveData;
    procedure CMHospitalUpdate(var Message: TMessage); message CM_UPDATELOOKUP;
    procedure CMVitalChanged(var Message: TMessage); message CM_VITALCHANGED;
    procedure UpdatePatient(aPatient:String);
    procedure PatientSelected;
    procedure setStatus(aStatus:String);

    procedure setPatientInfoView(aName,anInfo:String);
    procedure updatePatientInfoView;
    function getPatientName:String;
    function getPatientInfo:String;
    function CurrentPatientItem: TListItem;  //kt //codex 8/27/26
    //kt //codex added entire function/procedure 8/27/26
    procedure ApplyInputTemplateLayout(AResetColumnWidths: Boolean);  //kt //codex 8/27/26
    //kt //codex added entire function/procedure 8/27/26

  public
    property Status:String read fStatus write setStatus;
    property _CurrentPtIEN:String read _FCurrentPtIEN write _SetCurrentPtIEN;

    procedure InputLite(PatientDFN:String;PatientLocationIEN: string;InputTemplate: string;aDateTime:TDateTime);
    function FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
  protected
    procedure CMSaveInput(var Message: TMessage); message CM_SAVEINPUT; //AAN 2003/06/06
  end;

//Forward declarations
function VitalsInputDLG(aPatient, aLocation, aTemplate, aSignature: String;
           aDateTime:TDateTime;  aName,anInfo:String): Integer;
//function FormatLV(aSL:TStringList;aDelim:String):TStringList;
//procedure VitalsLiteInput(aPatient, aLocation, aTemplate,aSignature:ShortString;
//function GetLatestVitals(aBroker:TRPCBroker;aPatient,aDelim:String;bSilent:Boolean):TStringList;
procedure InputVitals(PatientDFN: string; PatientLocationIEN: string;
            InputTemplate: string;LV:TListView;aLocationName:String);
function VitalsInputForm(aPatient,aLocation,aTemplate,aSignature:String;
           aDateTime:TDateTime): TfrmGMV_InputLite;
function GetLatestVitals(aPatient,aDelim:String;bSilent:Boolean):TStringList;


var
  frmGMV_InputLite: TfrmGMV_InputLite;

implementation

uses
  mGMV_InputOne2
{$IFNDEF DLL}
  , fGMV_Splash
  , fGMV_AboutDlg
{$ENDIF}
  , uGMV_Common
  , uGMV_GlobalVars, uGMV_User, uGMV_FileEntry, uGMV_Utils
  , uGMV_SaveRestore
  , frmGMV_DateTime
  , fGMV_HospitalSelector2
  , uGMV_VitalTypes
  , uGMV_Setup
  , RS232
  , uVHA_ATE740X, uGMV_Engine
  , uGMV_VersionInfo // vhaishandria 050415
{$IFDEF USEVSMONITOR}
  , DLLCommon
{$ENDIF}
  , fGMV_PtInfo
  ;

{$IFDEF DLL}
var
  PrevApp: TApplication;
  PrevScreen: TScreen;
{$ENDIF}

const
  indMultipleInput: Integer = 19;
  indSingleCurrent: Integer = 17;
  indMultipleCurrent: Integer = 18;
  indOnPass: Integer = 5;
  indUnavail: Integer = 5;
  indSingleInput: Integer = 3;
  indBlankInput: Integer = 13;

  _WindowName = 'VitalsLite';

  stsDLL = 'DLL';
  stsDIALOG = 'DIALOG';
  stsCPRS = 'CPRS';
  stsDefault = 'DEFAULT';

{$R *.DFM}

procedure InputVitals(PatientDFN: string; PatientLocationIEN: string; InputTemplate: string;
  LV:TListView;aLocationName:String);
var
  InputVitalsForm:TfrmGMV_InputLite;
  LI: TListItem;
  lc: TListColumn;
  i: integer;

  CurrentServerDateTime: TDateTime;

  sHospitalLocationID,
  sHospitalLocationName,

  sWindowSettings,
  sDateTime,
  sTemplate: String;

  // Have some problems with:     RestoreWindowSettings(TForm(InputVitalsForm));
  procedure RestoreWin;
  var
    RetList:TStrings;
  begin
    RetList := TStringList.Create;
    try
      with InputVitalsForm do
        begin
          sWindowSettings := InputVitalsForm.ClassName;
          sWindowSettings := getUserSettings(sWindowSettings);
          if sWindowSettings <> '' then
            begin
              Left := StrToIntDef(Piece(sWindowSettings, ';', 3), Left);
              Top := StrToIntDef(Piece(sWindowSettings, ';', 4), Top);
              Width := StrToIntDef(Piece(sWindowSettings, ';', 5), Width);
              Height := StrToIntDef(Piece(sWindowSettings, ';', 6), Height);
            end
          else
            begin
              Left := (Screen.Width - Width) div 2;
              Top := (Screen.Height - Height) div 2;
              if Top < 0 Then Top := 0;
              if Left < 0 Then Left := 0;
            end;
        end;
    except
    end;
    RetList.Free;
  end;

begin
  sHospitalLocationID := PatientLocationIEN;
  sHospitalLocationName := aLocationName;

  if sHospitalLocationID = '' then
   begin
//{$IFDEF AANTEST}
     if not SelectLocation2(PatientDFN,sHospitalLocationID, sHospitalLocationName) then
//{$ELSE}
//     if not SelectLocation(PatientDFN,sHospitalLocationID, sHospitalLocationName) then
//{$ENDIF}
       begin
          MessageDLG('Not enough information to start input'+#13+
          'Select hospital location to proceed',mtInformation, [mbOK],0);
          exit;
       end;
   end;

  try
    sDateTime := getCurrentDateTime;
    CurrentServerDateTime := FMDateTimeToWindowsDateTime(StrToFloat(sDateTime));//10/08/2002 AAN
  except
    on E: Exception do
      begin
        MessageDlg('Input Vitals: Unable to set client to the servers time.'+
          #13#10+E.Message, mtWarning, [mbok], 0);
        Exit;
      end;
  end;


  InputVitalsForm := TfrmGMV_InputLite.Create(Application);

  with InputVitalsForm do
  try
    if (PatientDFN = '') and ((LV = nil) or (LV.Items.Count <1)) then
        MessageDLG('Not enough information to start input'+#13+
          'Select one or more patients to proceed',mtInformation, [mbOK],0)
    else
      begin
        if PatientDFN = '' then
            FDFN := LV.Items[0].SubItems[1]
        else
            FDFN := PatientDFN;
{
//        CallRemoteProc(RPCBroker, 'GMV GET CURRENT TIME', [''], nil);
        sDateTime := getCurrentDateTime;
        try
          dtpDate.Date := FMDateTimeToWindowsDateTime(StrToFloat(sDateTime));//10/08/2002 AAN
          dtpDate.MaxDate := dtpDate.Date;
          dtpTime.DateTime := FMDateTimeToWindowsDateTime(StrToFloat(sDateTime));
          CurrentTime := dtpTime.DateTime;
        except
          on E: EConvertError do
            MessageDlg('Unable to set client to the servers time.', mtWarning, [mbok], 0);
        else
          raise
        end;
}
        dtpDate.Date := CurrentServerDateTime;
        dtpDate.MaxDate := dtpDate.Date;
        dtpTime.DateTime := CurrentServerDateTime;
        CurrentTime := dtpTime.DateTime;

        _FHospitalIEN := sHospitalLocationID;
        lblHospital.Caption := sHospitalLocationName;

        acLoadPreferencesExecute(nil);
        RestoreWin;
//        pnlPatient.Color := GMVInquiryBkGd;
        LoadTreeView;
        if tv <> nil then
          begin
            // AAN 08/27/2002 Default template handling------------------ begin
            sTemplate := piece(FNewTemplate,'|',2);
            if sTemplate = '' then
              try
                sTemplate := FDefaultTemplate.TemplateName;
              except
              end;
            for i := 0 to tv.Items.Count-1 do
              begin
                if sTemplate = tv.Items[i].Text then
                  begin
                    tv.Selected := tv.Items[i];
                    break;
                  end;
              end;
          end;

        if LV <> nil then
           begin
             lvSelPatients.SmallImages := imgTemplates;
             if lvSelPatients.Columns.Count < 3 then
               begin
                 lc := lvSelPatients.Columns.Add;
                 lc.Width := 150;
                 lc := lvSelPatients.Columns.Add;
                 lc.Width := 0;
                 lc := lvSelPatients.Columns.Add;
                 lc.Width := 0;
                 lc := lvSelPatients.Columns.Add;
                 lc.Width := 0;
               end;
             for i := 0 to LV.Items.Count - 1 do
               begin
                 LI := lvSelPatients.Items.Add;
                 LI.Caption := LV.Items[i].SubItems[0];
                 LI.SubItems.Add(LV.Items[i].SubItems[0]);
                 LI.SubItems.Add(LV.Items[i].SubItems[1]);
                 LI.SubItems.Add(LV.Items[i].SubItems[2]);
                 LI.SubItems.Add('');
                 LI.Checked := False;
               end;
             if lvSelPatients.Items.Count > 0 then
               begin
                 lvSelPatients.ItemFocused := lvSelPatients.Items[0];
                 lvSelPatientsClick(nil);
                 btnSaveAndExit.Visible := False;
               end;
             if lvSelPatients.Items.Count < 2 then
               gbxPatients.Visible := False;
           end
         else
           begin
             gbxPatients.Visible := False;
             updatePatientInfoView; // vhaishandria 060309
             updateLatestVitals(FDFN,False);
           end;

         ShowModal;
         bDataUpdated := False;

         acSavePreferencesExecute(nil);
         SaveWindowSettings(TForm(InputVitalsForm));
      end;
  finally
    free;
  end;
end;

function VitalsInputDLG(aPatient, aLocation, aTemplate, aSIgnature: String;
  aDateTime:TDateTime;
  aName,anInfo:String): Integer;

  procedure SaveWindowSettings(Form: TForm);
  var
    s,
    WindowSetting: string;
    State: TWindowState;
  begin
    State := Form.WindowState;
    Form.WindowState := wsNormal;
    Form.Visible := False;
    WindowSetting :=
      IntToStr(Screen.Width) + ';' +
      IntToStr(Screen.Height) + ';' +
      IntToStr(Form.Left) + ';' +
      IntToStr(Form.Top) + ';' +
      IntToStr(Form.Width) + ';' +
      IntToStr(Form.Height) + ';' +
      IntToStr(integer(State));

    s := setUserSettings(_WindowName,WindowSetting);
    if Piece(s, '^', 1) = '-1' then
      MessageDlg('Unable to set parameter ' + Form.ClassName + '.' + #13 +
        'Error Message: ' + Piece(s, '^', 2), mtError, [mbOK], 0);
  end;

begin
  Result := -1;
  try
    SetUpGlobals;
    GMVUser.SetupSignOnParams;
    GMVUser.SetupUser;

    Application.CreateForm(TfrmGMV_InputLite, frmGMV_InputLite);

    frmGMV_InputLite.InputLite(aPatient,aLocation,aTemplate,aDateTime);
    if frmGMV_InputLite._FHospitalIEN <> '' then
      begin
        frmGMV_InputLite.setPatientInfoView(aName,anInfo);// vhaishandria 060309

        PositionForm(frmGMV_InputLite);
        Result := frmGMV_InputLite.ShowModal;

        frmGMV_InputLite.acSavePreferencesExecute(nil);
        SaveWindowSettings(TForm(frmGMV_InputLite));
      end
    else
      ShowMessage('To enter Vitals select the patient location first');
  finally
    frmGMV_InputLite.Free;
    CleanUpGlobals;
  end;
end;

function FormatLV(aSL:TStringList;aDelim:String):TStringList;
var
  AbNormal: Boolean;
  sBMI,
  sVital, sDate, sTime, sKey,sValue,sQual,sMetric,sEnteredBy,
  s,ss: string;
  i: integer;
  SL: TStringList;
const
  //          1   5    10   15   20   25   30   35   40   45   50   55   60
  //          |   |    |    |    |    |    |    |    |    |    |    |    |
  KeyWords = 'Temp. Pulse Resp. Pulse Ox B/P Ht. Wt. CVP Circ/Girth Pain Body Mass Index';
  //          1     7     13    19       28  32  36  40  44         55   60
//AAN 06/10/02----------------------------------------------------------- Begin
  procedure CorrectList(var tSL: TStringList);
  var
    s: string;
    i,j: integer;
  begin
    for i := 0 to tSL.count-1 do
      begin
        s := tSL.Strings[i];
        j := pos('(,',s);
        while j <> 0 do
          begin
            s := copy(s,1,j)+ copy(s,j+2,Length(s)-j-1);
            j := pos('(,',s);
          end;
        tSL.Strings[i] := s;
      end;
  end;
//AAN 06/10/02------------------------------------------------------------- End

begin
  SL := TStringList.Create;
  SL.Assign(aSL);

  CorrectList(SL);
  sBMI := '';
  for i := 0 to SL.count-1 do
    begin
      s := SL.Strings[i];
      if pos('Body Mass Index:',s)<>0 then
        begin
          sVital := 'Body Mass Index';
          sEnteredBy := '';
          ss := copy(s,17, Length(S));
          ss := TrimLeft(ss);
          sBMI := ss;
        end
      else if pos('Pulse Ox:',S) <> 0 then
        begin
          sVital := 'Pulse Ox:';
          ss := copy(s,10, Length(S));
          ss := TrimLeft(ss);
        end
      else
        begin
          sVital := Piece(S,' ',1);
          ss := copy(S,pos(' ',S),Length(S));
          ss := TrimLeft(ss);
        end;

      s := piece(sVital,':',1);
      if s = '' then //two records for the same date/time
        begin
          ss := TrimLeft(SL.Strings[i]);
          sValue := ss;
          sDate := '';
          sTime := '';
        end
      else
        begin
          sKey := s;
          s := copy(ss,1,pos(' ',ss));
          if pos('(',s) = 1 then
            s := piece(piece(s,'(',2),')',1); //  to delete ()
          sDate := piece(s,'@',1);
          sTime := piece(s,'@',2);

          ss := copy(ss,pos(' ',ss),Length(ss));
          ss := TrimLeft(ss);
          sValue := ss;
        end;
      sQual := '';
      sMetric := '';
      //kt make changes here
      case pos(sKey,Keywords) of
  //          1   5    10   15   20   25   30   35   40   45   50   55   60
  //          |   |    |    |    |    |    |    |    |    |    |    |    |
//KeyWords = 'Temp. Pulse Resp. Pulse Ox B/P Ht. Wt. CVP Circ/Girth Pain Body Mass Index';
  //          1     7     13    19       28  32  36  40  44         55   60
        0:
          begin
            sDate:= '';
            sTime:= '';
            sVital:= ' ';
            sValue := '';
            sMetric:= '';
            sEnteredBy := '';
            sQual := SL.Strings[i];
          end;
        1://Temp
          begin
            ABNormal := pos('*',sValue) > 0;

            sEnteredBy := piece(sValue,'_',2);
            sValue := piece(sValue,'_',1);//AAN 05/28/2003
            sMetric := piece(sValue,'(',2,2);
            sMetric := piece(sMetric,')',1);
            sQual := sValue;
            sValue := piece(sValue,'(',1);

            if ABNormal and (pos('*',sValue)=0) then sValue := sValue + '*';

            sQual := piece(piece(sQual,')',2),'(',2);
            sVital := 'Temperature';
          end;
        7://Pulse
          begin
            ABNormal := pos('*',sValue) > 0;
            sEnteredBy := piece(sValue,'_',2);
            sValue := piece(sValue,'_',1);//AAN 05/28/2003
            sValue := Piece(sValue,' ',1);

            if ABNormal and (pos('*',sValue)=0) then sValue := sValue + '*';

            sQual := Piece(Piece(ss,'(',2),')',1);
            sMetric := '';
            sVital := 'Pulse';
          end;
        13://Resp;
          begin
            ABNormal := pos('*',sValue) > 0;
            sEnteredBy := piece(sValue,'_',2);
            sValue := piece(sValue,'_',1);//AAN 05/28/2003
            sValue := Piece(sValue,' ',1);

            if ABNormal and (pos('*',sValue)=0) then sValue := sValue + '*';

            sQual := Piece(Piece(ss,'(',2),')',1);
            sMetric := '';
            sVital := 'Respiration';
          end;
        19://Pulse Ox;
          begin
//            ABNormal := pos('*',sValue) > 0;
            sEnteredBy := piece(sValue,'_',2);
            sValue := piece(sValue,'_',1);//AAN 05/28/2003
            sValue := piece(sValue,'_',1);
            sQual := Trim(Piece(sValue,' ',2,10 ));
            if (pos('P',sValue)<>1) and (pos('U',sValue)<>1)and (pos('R',sValue)<>1) then
              sValue := Piece(sValue,'%',1)+'%';
            sMetric := '';
            sVital := 'Pulse Oximetry';
            if pos('*',sQual) = 1 then
              begin
                sValue := sValue + '*';
                sQual := Trim(Piece(sQual,'*',2));
              end;
          end;
        28://B/P
          begin
            ABNormal := pos('*',sValue) > 0;
            sEnteredBy := piece(sValue,'_',2);
            sValue := piece(sValue,'_',1);//AAN 05/28/2003
            sValue := Piece(sValue,' ',1);

            if ABNormal and (pos('*',sValue)=0) then sValue := sValue + '*';

            sQual := Piece(Piece(ss,'(',2),')',1);
            sMetric := '';
            sVital := 'Blood Pressure';
          end;
        32://Height
          begin
            ABNormal := pos('*',sValue) > 0;
            sEnteredBy := piece(sValue,'_',2);
            sValue := piece(sValue,'_',1);//AAN 05/28/2003
            sMetric := piece(sValue,'(',2,2);
            sMetric := piece(sMetric,')',1);
            sQual := sValue;
            sValue := piece(sValue,'(',1);

            if ABNormal and (pos('*',sValue)=0) then sValue := sValue + '*';

            sQual := piece(piece(sQual,')',2),'(',2);
            sVital := 'Height';
          end;
        36://Weight
          begin
            ABNormal := pos('*',sValue) > 0;
            sEnteredBy := piece(sValue,'_',2);
            sValue := piece(sValue,'_',1);//AAN 05/28/2003
            sMetric := piece(sValue,'(',2,2);
            sMetric := piece(sMetric,')',1);
            sQual := sValue;
            sValue := piece(sValue,'(',1);

            if ABNormal and (pos('*',sValue)=0) then sValue := sValue + '*';

            sQual := piece(piece(sQual,')',2),'(',2);
            sVital := 'Weight';
          end;
        40://CVP
          begin
            ABNormal := pos('*',sValue) > 0;
            sEnteredBy := piece(sValue,'_',2);
            sValue := piece(sValue,'_',1);//AAN 05/28/2003
            sMetric := piece(sValue,'(',2,2);
            sMetric := piece(sMetric,')',1);
            sQual := sValue;
            sValue := piece(sValue,'(',1);

            if ABNormal and (pos('*',sValue)=0) then sValue := sValue + '*';

            sQual := piece(piece(sQual,')',2),'(',2);
            sVital := 'CVP';
          end;
        44:
          begin
            ABNormal := pos('*',sValue) > 0;
            sEnteredBy := piece(sValue,'_',2);
            sValue := piece(sValue,'_',1);//AAN 05/28/2003
            sMetric := piece(sValue,'(',2,2);
            sMetric := piece(sMetric,')',1);
            sQual := sValue;
            sValue := piece(sValue,'(',1);

            if ABNormal and (pos('*',sValue)=0) then sValue := sValue + '*';

            sQual := piece(piece(sQual,')',2),'(',2);
            sVital := 'Circumference/Girth';
          end;
        55://Pain
          begin
            ABNormal := pos('*',sValue) > 0;
            sEnteredBy := piece(sValue,'_',2);
            sValue := piece(sValue,'_',1);

            if ABNormal and (pos('*',sValue)=0) then sValue := sValue + '*';

            sVital := 'Pain';
          end;
        60:// Body Mass Index;
          begin
            sQual := '';
            sMetric := '';
            sDate := '';
            sTime := '';
            sValue := sBMI;
          end;
      end;

      if ((Trim(sVital)='') and (pos('There',Trim(sQual))=1)) then
        begin
          SL.Strings[i] :=
            aDelim+
            'There are'+ aDelim+
            'no results'+aDelim+
            'to report'+aDelim+aDelim;
        end
      else
        begin
          SL.Strings[i] :=
            sDate + ' ' + sTime+aDelim+
            sVital + aDelim+
            sValue+aDelim+
            sMetric+aDelim+
            sQual+aDelim+
            sEnteredBy;

        end;
    end;
  SL.Insert(0,
  'Date & Time' + aDelim+
  'Vital' + aDelim+
  'USS Value' + aDelim+
  'Metric Value' + aDelim+
  'Qualifiers' + aDelim+
  'Entered by');

  Result := SL;
end;


function VitalsInputForm(aPatient,aLocation,aTemplate,aSignature:String;
  aDateTime:TDateTime): TfrmGMV_InputLite;
begin
  try
    Application.CreateForm(TfrmGMV_InputLite, frmGMV_InputLite);
    frmGMV_InputLite.Status := stsDLL;

    frmGMV_InputLite.InputLite(aPatient,aLocation,aTemplate,aDateTime);
        frmGMV_InputLite.pnlTools.Visible := false;

        frmGMV_InputLite.chkbCloseOnSave.Visible := False;
        frmGMV_InputLite.btnSave.Caption := 'Save &and Exit';  //kt //codex 8/26/26
        frmGMV_InputLite.btnCancel.Caption := '&Quit';  //kt //codex 8/26/26
        frmGMV_InputLite.btnSaveAndExit.Visible := False;  //kt //codex 8/26/26
        frmGMV_InputLite.pnlButtons.Width := frmGMV_InputLite.btnCancel.Left +
          frmGMV_InputLite.btnCancel.Width + 8;  //kt //codex 8/26/26
    frmGMV_InputLite.BorderStyle := bsNone;

    result := frmGMV_InputLite;
  except
    result := nil;
  end;
end;

function GetLatestVitals(aPatient,aDelim:String;bSilent:Boolean):TStringList;
var
  aSL: TStringList;
begin
  aSL := getLatestVitalsByDFN(aPatient,bSilent);
  Result := FormatLV(aSL,'^');
  aSL.Free;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_InputLite.InputLite(PatientDFN: string;
  PatientLocationIEN: string; InputTemplate: string;
  aDateTime:TDateTime);
var
  i: integer;
  sDateTime, sCaption,
  sTemplate: String;
  sWindowSettings: String;
  aSL: TStrings;

  // Have some problems with:     RestoreWindowSettings(TForm(InputVitalsForm));
  procedure RestoreWin;
  begin
    try
      sWindowSettings := ClassName;

      sWIndowSettings := getUserSettings(_Windowname);

      if sWindowSettings <> '' then
        begin
          Left := StrToIntDef(Piece(sWindowSettings, ';', 3), Left);
          Top := StrToIntDef(Piece(sWindowSettings, ';', 4), Top);
          Width := StrToIntDef(Piece(sWindowSettings, ';', 5), Width);
          Height := StrToIntDef(Piece(sWindowSettings, ';', 6), Height);
        end;
    except
    end;
  end;

  procedure setWindowCaption;
  begin

    sCaption := ' Vitals Lite Enter';
    if fFileComments <> '' then
      sCaption := sCaption + ' ('+fFileComments+') ';
    sCaption := sCaption + '  User: ' + GMVUser.Name;
    if GMVUser.Title <> '' then
      sCaption := sCaption + '  (' + GMVUser.Title + ')';
    sCaption := sCaption +  '  Division: ' + GMVUser.Division;

    Caption := sCaption;
  end;

begin
  aSL := TStringList.Create;
  try
        gbxPatients.Visible := False;

        setWindowCaption;

        chkbCloseOnSave.Visible := False;  //kt //codex 8/26/26
        btnSave.Caption := 'Save &and Exit';  //kt //codex 8/26/26
        btnCancel.Caption := '&Quit';  //kt //codex 8/26/26
        btnSaveAndExit.Visible := False;

        bSlave := True;
        FDFN := PatientDFN;

        // select a location first
        if (PatientLocationIEN = '') or (PatientLocationIEN = '0') then
          acHospitalSelectorExecute(nil)
        else
          begin
            sCaption := getFileField('44','2',PatientLocationIEN);
            if (pos('WARD',uppercase(sCaption)) <> 0) or (pos('CLINIC',uppercase(sCaption)) <> 0) then
               begin
                _FHospitalIEN := PatientLocationIEN;
                sCaption := getFileField('44','.01',_FHospitalIEN); // vhaishandria 050210
                lblHospital.Caption := sCaption;
               end
            else
              _FHospitalIEN := PatientLocationIEN;
          end;
//        CallRemoteProc(RPCBroker, RPC_MANAGER, ['GETDATA', '44^' + _FHospitalIEN + '^.01']);
//        lblHospital.Caption := RPCBroker.Results[0];
//        sCaption := getFileField('44',_FHospitalIEN,'.01');

        sCaption := getFileField('44','.01',_FHospitalIEN); // vhaishandria 050210
        lblHospital.Caption := sCaption;

        try
          sDateTime := getCurrentDateTime;
          dtpDate.Date := FMDateTimeToWindowsDateTime(StrToFloat(sDateTime));//10/08/2002 AAN
          dtpDate.MaxDate := dtpDate.Date;
          dtpTime.DateTime := FMDateTimeToWindowsDateTime(StrToFloat(sDateTime));
{$IFDEF DLL}
          chkbCloseOnSave.Visible := False; //kt //codex 8/26/26
          btnSave.Caption := 'Save &and Exit'; //kt //codex 8/26/26
          btnCancel.Caption := '&Quit'; //kt //codex 8/26/26
          btnSaveAndExit.Visible := False; //kt //codex 8/26/26
//         CurrentTime := aDateTime;
//          dtpDate.Date := aDateTime;
//          dtpTime.DateTime := aDateTime;
          CurrentTime := Now;
          dtpDate.Date := CurrentTime;
          dtpTime.DateTime := CurrentTime;

          dtpTimeChange(nil);
//          Caption := ' Vitals Lite: Enter Vitals for '+getPatientName + ' '+getPatientInfo;
{$ELSE}
          CurrentTime := dtpTime.DateTime;
{$ENDIF}
        except
          on E: EConvertError do
            MessageDlg('Input Lite: Unable to set client to the servers time.'+
              #13#10+E.Message, mtWarning, [mbok], 0);
        else
          raise
        end;
        acLoadPreferencesExecute(nil);
        RestoreWin;

        LoadTreeView;
        if tv <> nil then
          begin
            // AAN 08/27/2002 Default template handling------------------ begin
            sTemplate := piece(FNewTemplate,'|',2);
            if sTemplate = '' then
              try
                sTemplate := FDefaultTemplate.TemplateName;
              except
              end;
            for i := 0 to tv.Items.Count-1 do
              begin
                if sTemplate = tv.Items[i].Text then
                  begin
                    tv.Selected := tv.Items[i];
                    break;
                  end;
              end;
          end;

        UpdatePatient(FDFN);
  finally
    aSL.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_InputLite.UpdatePatient(aPatient:String);
begin
{$IFNDEF DLL}
  updatePatientInfoView;
{$ENDIF}
  UpdateLatestVitals(aPatient,False);
end;

procedure TfrmGMV_InputLite._SetCurrentPtIEN(const Value: string);
begin
  _FCurrentPtIEN := Value;
  FDFN := Value;
{$IFNDEF DLL}
  lblHospital.Caption := getHospitalLocationByID(_CurrentPtIEN);
{$ENDIF}
  UpdatePatient(_CurrentPtIEN);
end;

procedure TfrmGMV_InputLite.FocusInputField;
var
  i: Integer;
begin
  for i := 0 to sbxMain.ControlCount - 1 do
    if sbxMain.Controls[i] is TfraGMV_InputOne2 then
      begin
        ActiveControl :=TfraGMV_InputOne2(sbxMain.Controls[i]).cbxInput;
        break;
      end;
end;

procedure TfrmGMV_InputLite.btnCancelClick(Sender: TObject);
begin
  if (InputString <> '') then
    begin
       if (MessageDlg('Some of the input fields contain data.'+#13+#13
//          +'Do you really want to close the input window?',
          +'Click "Yes" to exit without saving the data' + #13+#10
          +'Click "No" to return to the input template',
          mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
            Exit
       else
         bDataUpdated := False;
    end;

  if bSlave then
    begin
      acSavePreferencesExecute(nil);
      SaveWindowSettings(Self);
    end;

  Close;
end;

procedure TfrmGMV_InputLite.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  for i := sbxMain.ComponentCount - 1 downto 0 do
    if sbxMain.Components[i] is TfraGMV_InputOne2 then
      TfraGMV_InputOne2(sbxMain.Components[i]).Free;

  if bSlave then
    begin
//  commented by vhaishandria on 050209
//      acSaveInputExecute(nil);
      if InputString = '' then
        Action := caFree//DLL
      else
        Action := caNone;
    end;
end;

procedure TfrmGMV_InputLite.ClearVitalsList;
var
  i: Integer;
  p: TPanel;
begin
  i := 0;
  while sbxMain.ComponentCount > 0 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
          TfraGMV_InputOne2(sbxMain.Components[i]).Free
      else if sbxMain.Components[i] is TPanel then
        begin
          p := TPanel(sbxMain.Components[i]);
          p.Free;
        end
      else
        inc(i);
      if i > sbxMain.ComponentCount then break;
    end;
end;

procedure TfrmGMV_InputLite.SetVitalsList(InputTemplate:String);
var
  InputOne2: TfraGMV_InputOne2;
  i: Integer;
begin

  Screen.Cursor := crHourGlass;
  sbxMain.Visible := False;

  try
    ClearVitalsList;
    acSaveInput.Enabled := False;
  except
  end;

  //messagedlg('InputTemplate='+InputTemplate,mtInformation,[mbOK],0); //kt
  FInputTemplate := GetTemplateObject(piece(InputTemplate,'|',1),piece(InputTemplate,'|',2));

  if FInputTemplate <> nil then
    begin
      //messagedlg('FInputTemplate.XPar='+FInputTemplate.XPARValue,mtInformation,[mbOK],0); //kt
      FTemplateData := piece(FInputTemplate.XPARValue, '|', 2);
      i := 1;
      while piece(FTemplateData, ';', i) <> '' do
        begin
          try
            InputOne2 := TfraGMV_InputOne2.Create(sbxMain); //works in unit
            acSaveInput.Enabled := True;

            with InputOne2 do
              begin
                ConversionWarning := False;
                cbConversionWarning.Checked := False;

                Parent := sbxMain;
                Name := 'tmplt' + IntToStr(i);

                if (i mod 2) = 0 then
                  pnlMain.Color := $00b1b1b1;
                //messagedlg('FInputTemplateData piece ='+piece(FTemplateData, ';', i),mtInformation,[mbOK],0); //kt
                TemplateVital := TGMV_TemplateVital.CreateFromXPAR(piece(FTemplateData, ';', i));
                DefaultTemplateVital := TemplateVital;
                lblNum.Caption := IntToStr(i) + '. ';
                if i < 10 then
                  begin
                    lblNum.Caption := '&'+lblNum.Caption;
                    lblNum.FocusControl := cbxInput;
                  end;

                Top := i * Height;
                TabOrder := Top;
                Align := alTop;
                try
                  ckbMetricClick(nil);//AAN 08/16/2002
                except
                end;
              end;
          except
            on e: Exception do
              MessageDialog('Error','Error creating input template '+#13+ e.Message,
                mtError,mbYesNoCancel,0,0);
          end;
          inc(i);
        end;
      try
        acMetricStyleChangeExecute(nil);
      except
      end;
    end;
  ApplyInputTemplateLayout(True);  //kt //codex 8/27/26
  sbxMain.Visible := True;
  bDataUpdated := False;
  FocusInputField;
  Screen.Cursor := crDefault;
end;

procedure TfrmGMV_InputLite.dtpTimeChange(Sender: TObject);
begin
  if trunc(dtpDate.Date) + frac(dtpTime.Time) > CurrentTime then
    dtpTime.Time := CurrentTime;
  lblDateTime.Caption := ' ' + FormatDateTime(GMV_DateFormat,dtpDate.Date) + '  ' +
                         FormatDateTime(GMV_TimeFormat,dtpTime.Time);
end;

procedure TfrmGMV_InputLite.FormResize(Sender: TObject);
begin
  ApplyInputTemplateLayout(False);  //kt //codex 8/27/26
  if Height > Screen.Height then
    Height := Screen.Height;

  acAdjustToolBars.Execute;
end;

procedure TfrmGMV_InputLite.LoadTreeView;
var
  tmpList: TStringList;
  i: integer;
begin
  tv.Enabled := False;
  tv.Items.BeginUpdate;
  tv.ShowRoot := True;
  with tv.items do
    begin
      Clear;
      FTmpltRoot := nil;
      FTmpltDomainRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teDomain]);
      FTmpltInstitutionRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teInstitution]);
      FTmpltHopsitalLocationRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teHospitalLocation]);
      if GMVAllowUserTemplates then
        FTmpltNewPersonRoot := AddChild(FTmpltRoot, GMVENTITYNAMES[teNewPerson]);
    end;

//  tmpList := TStringList.Create;
  try
    tmpList := getTemplateListByID('');
    for i := 1 to tmpList.Count - 1 do
      InsertTemplate(TGMV_Template.CreateFromXPAR(tmpList[i]));
  finally
    FreeAndNil(tmpList);
  end;

  tv.Ctl3D := False;
  tv.AlphaSort;
  tv.Enabled := True;
  tv.TopItem := tv.Items.GetFirstNode;
  tv.Items.EndUpdate;
  Refresh;
end;

procedure TfrmGMV_InputLite.InsertTemplate(
  Template: TGMV_Template; GoToTemplate: Boolean = False);
var
  TypeRoot: TTreeNode;
  oRoot: TTreeNode;
  NewNode: TTreeNode;

  function OwnerRoot: TTreeNode;
  begin
    Result := nil;
    try
      oRoot := TypeRoot.getFirstChild;
    except
      oRoot := nil;
    end;
    while oRoot <> nil do
      begin
        if TGMV_TemplateOwner(oRoot.Data).Entity = Template.Entity then
          begin
            Result := oRoot;
            exit;
          end
        else
          oRoot := TypeRoot.GetNextChild(oRoot);
      end;

    if oRoot = nil then
      begin
        if Template.EntityType = teNewPerson then
          begin
            if GMVAllowUserTemplates then
              Result := tv.Items.AddChildObject(TypeRoot, TitleCase(Template.Owner.OwnerName), Template.Owner);
          end
        else
          Result := tv.Items.AddChildObject(TypeRoot, Template.Owner.OwnerName, Template.Owner);
      end;
  end;

begin
  case Template.EntityType of
    teUnknown: TypeRoot := nil;
    teDomain: TypeRoot := FTmpltDomainRoot;
    teInstitution: TypeRoot := FTmpltInstitutionRoot;
    teHospitalLocation: TypeRoot := FTmpltHopsitalLocationRoot;
    teNewPerson: TypeRoot := FTmpltNewPersonRoot;
  end;

  NewNode := tv.Items.AddChildObject(OwnerRoot, Template.TemplateName, Template);

  if (GMVDefaultTemplates <> nil)
    and GMVDefaultTemplates.IsDefault(Template.Entity, Template.TemplateName) then
    begin
      NewNode.ImageIndex := GMVIMAGES[iiDefaultTemplate];
      NewNode.SelectedIndex := GMVIMAGES[iiDefaultTemplate];
      // Default Template Data;
      if Template.EntityType = teDomain then
          FDefaultTemplate := Template;
    end
  else
    begin
      NewNode.ImageIndex := GMVIMAGES[iiTemplate];
      NewNode.SelectedIndex := GMVIMAGES[iiTemplate];
    end;

  if GoToTemplate then
    begin
      NewNode.Selected := True;
      tv.SetFocus;
    end;
end;

procedure TfrmGMV_InputLite.tvChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  if Node = nil then Exit;
  try
    if Node.Level > 1 then
      begin
        FNewTemplate := TGMV_Template(Node.Data).Entity + '|' +
          TGMV_Template(Node.Data).TemplateName;
        FNewTemplateDescription := Piece(TGMV_Template(Node.Data).XPARValue,'|',1);

        //messagedlg('In TfrmGMV_InputLite.tvChanging.  Calling SetVitalsList("'+FNewTemplate +'^'+FNewTemplateDescription+'")',mtInformation,[mbOK],0); //kt
        SetVitalsList(FNewTemplate +'^'+FNewTemplateDescription);
        pnlInputTemplateHeader.Caption := '  Vitals input template: <' + TGMV_Template(Node.Data).TemplateName + '>';
        lblTemplInfo.Caption := Piece(TGMV_Template(Node.Data).XPARValue,'|',1);
      end
    else
        lblTemplInfo.Caption := '';
    tv.hint := lblTemplInfo.Caption;
  except
  end;
end;

procedure TfrmGMV_InputLite.CleanUpVitalsList;
var
  i: Integer;
begin
  for i := 0 to  sbxMain.ComponentCount-1 do
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        try
          TfraGMV_InputOne2(sbxMain.Components[i]).cbxInput.ItemIndex := -1;
          TfraGMV_InputOne2(sbxMain.Components[i]).cbxInput.Text := '';
          TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Checked := false;
          TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Checked := false;
          TfraGMV_InputOne2(sbxMain.Components[i]).TemplateVital :=
            TfraGMV_InputOne2(sbxMain.Components[i]).DefaultTemplateVital;
          TfraGMV_InputOne2(sbxMain.Components[i]).SetMetricStyle(
            chkCPRSStyle.Checked
            );
//AAN 2003/09/17
          TfraGMV_InputOne2(sbxMain.Components[i]).ckbMetricClick(nil);
          TfraGMV_InputOne2(sbxMain.Components[i]).ClearPO2FlowRateAndPercentage;
        except
        end;
  ckbOnPass.Checked := False; // vhaishandria 050429
  ckbUnavailable.Checked := False; // vhaishandria 050429
  bDataUpdated := False;
end;

procedure TfrmGMV_InputLite.FormActivate(Sender: TObject);
begin
  dtpTimeChange(Sender);
  acUnavailableBoxStatusExecute(sender);//?
  cbRClick(nil);
end;

procedure TfrmGMV_InputLite.acMetricStyleChangeExecute(Sender: TObject);
var
  i : Integer;
begin
  for I := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          TfraGMV_InputOne2(sbxMain.Components[i]).SetMetricStyle(chkCPRSStyle.Checked);
        end;
    end;
  if acMetricStyleChange.Enabled then
    acMetricStyleChange.Checked := True
  else
    acMetricStyleChange.Checked := False;
end;

procedure TfrmGMV_InputLite.CMHospitalUpdate(var Message: TMessage);
begin
end;

procedure TfrmGMV_InputLite.ckbOnPassEnter(Sender: TObject);
begin
  bvU.Visible := true;
end;

procedure TfrmGMV_InputLite.ckbOnPassExit(Sender: TObject);
begin
  bvU.Visible := False;
end;

procedure TfrmGMV_InputLite.acSavePreferencesExecute(Sender: TObject);
begin
  if FNewTemplate <> '' then                    // vhaishandria 050209
    GMVUser.Setting[usDefaultTemplate] := FNewTemplate;

  if chkOneUnavailableBox.Checked then
    GMVUser.Setting[usOneUnavailableBox] :='OneUnavailableBox'
  else
    GMVUser.Setting[usOneUnavailableBox] :='ManyUnavailableBoxes';

  if chkbCloseOnSave.Checked then
    GMVUser.Setting[usCloseInputWindowAfterSave] :='CloseInputWindowAfterSave'
  else
    GMVUser.Setting[usCloseInputWindowAfterSave] :='DoNotCloseInputWindow';

  if chkCPRSStyle.Checked then
    GMVUser.Setting[usMetricStyle] :='CPRSMetricStyle'
  else
    GMVUser.Setting[usMetricStyle] :='VitalsMetricStyle';

  GMVUser.Setting[usParamTreeWidth] := IntToStr(pnlParams.Width);
  if bShowParams then
    begin
      GMVUser.Setting[usTemplateTree] := 'ShowTemplates';
    end
  else
    GMVUser.Setting[usTemplateTree] := 'NoTemplates';

  GMVUser.Setting[usLastVitalsListHeight] := IntToStr(pnlLatestVitalsBG.Height);
  if  bShowVitals then
      GMVUser.Setting[usLastVitals] := 'ShowLastVitals'
  else
    GMVUser.Setting[usLastVitals] := 'NoLatestVitals';

  if cbR.Checked then setUserSettings('RefuseStatus','ON')
  else setUserSettings('RefuseStatus','OFF');

  if cbU.Checked then setUserSettings('UnavailableStatus','ON')
  else setUserSettings('UnavailableStatus','OFF');

  if cbU.Checked then setUserSettings('ConversionWarningStatus','ON')
  else setUserSettings('ConversionWarningStatus','OFF');

end;

procedure TfrmGMV_InputLite.acLoadPreferencesExecute(Sender: TObject);
var
  s: String;
  i: integer;
begin
  try
    FNewTemplate := GMVUser.Setting[usDefaultTemplate];
  except
    FNewTemplate := '';
  end;

  bShowVitals := not (GMVUser.Setting[usLastVitals]='ShowLastVitals');
  acVitalsShowHideExecute(nil);

  s  := GMVUser.Setting[usLastVitalsListHeight];
  if s <> '' then
    try
      pnlLatestVitalsBG.Height := StrToInt(s);
    except
      pnlLatestVitalsBG.Height := pnlInput.Height div 4;
    end
  else
    pnlLatestVitalsBG.Height := pnlInput.Height div 4;

  bShowParams := not (GMVUser.Setting[usTemplateTree]='ShowTemplates');
  acParamsShowHideExecute(nil);

  s := GMVUser.Setting[usParamTreeWidth];
  if s <> '' then
    try
      i := StrToInt(s);
      pnlParams.Width := i;
    except
      pnlParams.Width := 150;
    end
  else
    pnlParams.Width := 150;

  chkCPRSStyle.Checked := GMVUser.Setting[usMetricStyle]='CPRSMetricStyle';
  acMetricStyleChangeExecute(Sender);

//  chkOneUnavailableBox.Checked :=
//    GMVUser.Setting[usOneUnavailableBox] ='OneUnavailableBox';
  chkOneUnavailableBox.Checked := False; //AAN 05/21/2003

  acUnavailableBoxStatusExecute(sender);
{ vhaishandria 050209
  chkbCloseOnSave.Checked :=
    GMVUser.Setting[usCloseInputWindowAfterSave] ='CloseInputWindowAfterSave';
}
  s := getUserSettings('RefuseStatus');
  cbR.Checked := s <> 'OFF';
  s := getUserSettings('UnavailableStatus');
  cbU.Checked := s <> 'OFF';
  s := getUserSettings('ConversionWarningStatus');
  cbConversionWarning.Checked := s = 'ON';

end;

procedure TfrmGMV_InputLite.UpdateLatestVitals(aPatient:String;bSilent:Boolean);
var
  aSL: TStringList;
  TheSL: TStringList;
  i,j: Integer;
  s:String;
begin
{
  aSL := TStringList.Create;
  if bSilent then
    CallRemoteProc(RPCBroker, 'GMV LATEST VM', [aPatient], nil, [rpcNoResChk,rpcSilent], aSL)
  else
    CallRemoteProc(RPCBroker, 'GMV LATEST VM', [aPatient], nil, [], aSL);
}
  aSL := getLatestVitalsByDFN(aPatient,bSilent);

  TheSL := FormatLV(aSL,'^');
  strgLV.RowCount := TheSL.count+1;
  strgLV.Cells[0,0] := 'Date & Time';
  strgLV.Cells[1,0] := 'Vital';
  strgLV.Cells[2,0] := 'USS Value';
  strgLV.Cells[3,0] := 'Metric Value';
  strgLV.Cells[4,0] := 'Qualifiers';
  strgLV.Cells[5,0] := 'Entered by';
{$IFDEF AANTEST}
  showMessage(aSL.Text+#13#10+TheSL.Text); // vhaishandria 050429
{$ENDIF}
  for i := 1 to TheSL.Count-1 do // first row contains headers
    begin
      s := TheSL.Strings[i];
      for j := 0 to 5 do  strgLV.Cells[j,i] := Piece(s,'^',j+1);
    end;
  TheSL.Free;

  aSL.Free;
end;

procedure TfrmGMV_InputLite.tvExpanded(Sender: TObject;
  Node: TTreeNode);
begin
  if Node.Level< 2 then
    Node.ImageIndex := 1;
end;

procedure TfrmGMV_InputLite.tvCollapsed(Sender: TObject;
  Node: TTreeNode);
begin
  if Node.Level< 2 then
    Node.ImageIndex := 0;
end;

procedure TfrmGMV_InputLite.pnlParamsResize(Sender: TObject);
begin
  pnlPatient.Width := pnlParams.Width+5;
  acAdjustToolBars.Execute;   
end;

procedure TfrmGMV_InputLite.acSetOnPassExecute(Sender: TObject);
var
  i: Integer;
begin
  if (Sender = ckbUnavailable ) and
    ckbUnavailable.Checked and ckbOnPass.Checked then
    ckbOnPass.Checked := false
  else
    if ckbOnPass.Checked and ckbUnavailable.Checked then
    ckbUnavailable.Checked := false;

  for  i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          if (ckbOnPass.Checked) or (ckbUnavailable.Checked)//AAN 12/09/2002
          then
            begin
              TfraGMV_InputOne2(sbxMain.Components[i]).DisablePanel;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Enabled := False;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Enabled := False;
            end
          else
            begin
              if TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Checked or
                 TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Checked then
                TfraGMV_InputOne2(sbxMain.Components[i]).DisablePanel
              else
                TfraGMV_InputOne2(sbxMain.Components[i]).EnablePanel;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Enabled := True;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Enabled := True;
            end;
        end
    end;

  if acSetOnPass.Enabled then
    acSetOnPass.Checked := True
  else
    acSetOnPass.Checked := False;
end;

procedure TfrmGMV_InputLite.SaveData;
var
  sPO2:String;
  i: Integer;
  s1,s2,
  x: String;
  dt: TDateTime;
{$IFDEF V5021} // CASMED support
  aCM: TATE740X;
{$ENDIF}
begin
  sPO2 := getVitalTypeIEN('PULSE OXIMETRY');  // vhaishandria 050715

  dt := WindowsDateTimeToFMDateTime(trunc(dtpDate.Date) +
    (dtpTime.DateTime - trunc(dtpTime.Date)));

  for i := 0 to sbxMain.ControlCount - 1 do
    begin
      if sbxMain.Controls[i] is TfraGMV_InputOne2 then
        with TfraGMV_InputOne2(sbxMain.Controls[i]) do
          begin
            x := '';
            if ckbOnPass.Checked then
              begin
                x := FloatToStr(dt) + '^' +
                  FDFN + '^' +
                  VitalIEN + ';Pass;' + '^' +
                  _FHospitalIEN + '^' +
                  GMVUser.DUZ + '*';
              end else
            if ckbUnavailable.Checked then
              begin
                x := FloatToStr(dt) + '^' +
                  FDFN + '^' +
                  VitalIEN + ';Unavailable;' + '^' +
                  _FHospitalIEN + '^' +
                  GMVUser.DUZ + '*';
              end
            else if VitalsRate <> '' then
              begin
                s1 := VitalsRate;
                // AAN 2003/06/30 -- do not show qualifiers for PulseOx if there is no rate
                if (piece(s1,';',1) = sPO2) // PulseOx ID {'21'}
                  and (piece(s1,';',3)='')  // no value for the Flow rate for PulseOx
// uncomment the next line if you'd like to ignore "no Flow Rate" for the Room Air
                  and (pos('ROOM AIR',uppercase(lblQualifiers.Caption))=0) // Method is not <Room Air>
                then
                  s2 := ''
                else
                  s2 := VitalsQualifiers;

                x := FloatToStr(dt) + '^' +
                FDFN + '^' +
                s1 + '^' +
                _FHospitalIEN + '^' +
                GMVUser.DUZ +
                '*' +
                s2;
                //messagedlg('x = ' + x,mtInformation,mbOKCancel,0);
              end;

            if x <> '' then
              begin
//                CallRemoteProc(RPCBroker, 'GMV ADD VM', [x], nil,[rpcSilent,rpcNoresChk]);
//                if RPCBroker.Results.Count > 1 then
//                  MessageDlg(RPCBroker.Results.Text, mtError, [mbok], 0);
                  x := addVM(x);
                  if x <> '' then
                    //MessageDlg('Collecting Data ' + x, mtError, [mbok], 0);
              end;
            end;
    end;
{$IFDEF V5021} // CASMED support////////////////////////////////////////////////
  try
    aCM := TATE740X.Create;
    aCM.NewPatient;
  finally
    aCM.Free;
  end;
{$ENDIF}  //////////////////////////////////////////////////////////////////////
  CleanUpVitalsList;
  UpdatePatient(FDFN);
end;

procedure TfrmGMV_InputLite.acSaveInputExecute(Sender: TObject);
const
  sLastProcessedMessage = 'The last patient in the list processed'+#13+'Close the input window?';
  sSelectHospital = 'Please select a valid hospital location for this patient.';
var
  sNoDataEntered:String;
  CurrentItem: TListItem;  //kt //codex 8/27/26

  procedure AssignImageIndex(anIndex:Integer);
  begin
    if CurrentItem = nil then Exit;  //kt //codex 8/27/26
    if CurrentItem.SubItems[3] = '' then
      begin
        CurrentItem.ImageIndex := anIndex;  //kt //codex 8/27/26
        CurrentItem.SubItems[3] := IntToStr(anIndex);  //kt //codex 8/27/26
      end
    else
      begin
        CurrentItem.SubItems[3] :=
          CurrentItem.SubItems[3] + ' ' +IntToStr(anIndex);  //kt //codex 8/27/26
        CurrentItem.ImageIndex := indMultipleInput;  //kt //codex 8/27/26
      end;
  end;

  function CheckData:Boolean;
  var
    i : Integer;
  begin
    Result := False;
    for i := 0 to sbxMain.ComponentCount - 1 do
      begin
        if not TfraGMV_InputOne2(sbxMain.Components[i]).Check then
          break;
      end;
    if i = sbxMain.ComponentCount then
      Result := True;
  end;

  procedure ProcessNext(ResultIndex:Integer);
  var
    NextIndex: Integer;  //kt //codex 8/27/26
  begin
    if (lvSelPatients = nil) or (lvSelPatients.Items.Count < 2) then
      begin
        if bSlave then // DLL
          begin
            if chkbCloseOnSave.Checked
              or (Sender = btnSave)
              or (Sender = btnSaveAndExit) // legacy compatibility
              then  Close
            else
              UpdateLatestVitals(FDFN,True);
          end
        else
          begin
  //  Do we need to close window if the list contains only one patient?
  //      Yes we do
  //  Do we need to have a message?
  //      No we don't
  //            s := LastProcessedMessage;
  //            if MessageDlgS(S,mtInformation,mbOKCancel,0) = mrOK then
          if (Sender = btnSave) or (Sender = btnSaveAndExit) then
                  ModalResult := mrOk;
          end;
        Exit;  //kt //codex 8/27/26
      end;

    CurrentItem := CurrentPatientItem;  //kt //codex 8/27/26
    if CurrentItem = nil then Exit;  //kt //codex 8/27/26

    try
      NextIndex := CurrentItem.Index + 1;  //kt //codex 8/27/26
      if CurrentItem.Index < lvSelPatients.Items.Count -1 then
        begin
          AssignImageIndex(ResultIndex);
          lvSelPatients.ItemFocused := lvSelPatients.Items[NextIndex];  //kt //codex 8/27/26
          lvSelPatients.ItemFocused.ImageIndex := 1;  //kt //codex 8/27/26
          lvSelPatientsClick(Sender);
          CleanUpVitalsList;

          if not lvSelPatients.CheckBoxes then
            ckbOnPass.Checked := False;

          FocusInputField;
        end
      else
        begin
          AssignImageIndex(ResultIndex);
          lvSelPatients.Invalidate;
          //lvSelPatientsClick(Sender);// may be it is too much

          if lvSelPatients.Items.Count < 2 then
            ModalResult := mrOK
          else  if MessageDlg(sLastProcessedMessage,mtInformation,mbOKCancel,0) = mrOK then
                ModalResult := mrOk;
        end;
    except
    end;
  end;

begin
  //Check all input panels for valid values
  if not CheckData then Exit;
  // Hospital location should be set before saving data -- 03/14/2003 AAN
  if (_FHospitalIEN = '') or (_fHospitalIEN = '0') then
    MessageDlg(sSelectHospital, mtWarning, [mbok], 0)
  else
    begin
      if InputString <> '' then
        begin
          SaveData;
          if ckbOnPass.Checked then
             ProcessNext(indOnPass)
          else
             ProcessNext(indSingleInput);
        end
      else
        begin
          sNoDataEntered := 'No data entered for patient '+#13+getPatientName+#13;
          case lvSelPatients.Items.Count of
            0,1: begin
                if (MessageDlg(sNoDataEntered+'Close the window?',
                  mtInformation, [mbYes,mbNo], 0) = mrYes) then
                if bSlave then Close
                else ModalResult := mrOK;
              end;
            else
              begin
                if (MessageDlg(sNoDataEntered+'Process next Patient?',
                  mtInformation, [mbYes,mbNo], 0) = mrYes) then
                    ProcessNext(indBlankInput);
              end;
          end;
        end;
    end;
end;

procedure TfrmGMV_InputLite.ckbOnPassClick(Sender: TObject);
begin
  acSetOnPassExecute(ckbOnPass);
  if not ckbOnPass.Checked then
    cbRClick(nil);
end;

procedure TfrmGMV_InputLite.SpeedButton2Click(Sender: TObject);
begin
  pnlOptions.Visible := not pnlOptions.Visible;
end;

procedure TfrmGMV_InputLite.acDateTimeSelectorExecute(Sender: TObject);
var
  aTime:TDateTime;
begin
  Application.CreateForm(TfGMV_DateTime, fGMV_DateTime);
  with fGMV_DateTime do
    begin
      // Enter date could not be less then a year before -- //AAN 12/12/2002
      fGMV_DateTime.mncCalendar.minDate := Now - 365;                     //AAN 12/12/2002
      fGMV_DateTime.mncCalendar.Date := dtpDate.Date;
      fGMV_DateTime.edtTime.Text := FormatDateTime(GMV_TimeFormat,dtpTime.Time);
      fGMV_DateTime.SetDateTimeText;

      if fGMV_DateTime.ShowModal <> mrCancel then
        begin
          CurrentTime := fGMV_DateTime.mncCalendar.MaxDate;
          aTime := trunc(fGMV_DateTime.mncCalendar.Date)+StrToTime(fGMV_DateTime.edtTime.Text);
          if dtpDate.MaxDate < aTime then
            dtpDate.MaxDate := aTime;
          dtpDate.Date := aTime;
          dtpTime.Time := trunc(aTime) + StrToTime(fGMV_DateTime.edtTime.Text);
          dtpTimeChange(Sender);
        end;
    end;
  fGMV_DateTime.Free;
end;

procedure TfrmGMV_InputLite.acHospitalSelectorExecute(Sender: TObject);
var
  sLocationID,
  sLocationName:String;
//  sPatientLocation: String;
begin
{
  if not Assigned(frmGMV_HospitalSelector) then
    Application.CreateForm(TfrmGMV_HospitalSelector, frmGMV_HospitalSelector);
  if  frmGMV_HospitalSelector = nil then exit;

  sPatientLocation := _FHospitalIEN;

//  frmGMV_HospitalSelector.fraHospLocationLookup.InitFrame(RPCBroker, '44', sPatientLocation);
  frmGMV_HospitalSelector.fraHospLocationLookup.InitFrame('44', sPatientLocation);
  if frmGMV_HospitalSelector.ShowModal = mrOK then
    begin
      lblHospital.Caption := frmGMV_HospitalSelector.fraHospLocationLookup.edtValue.Text;
      _FHospitalIEN := frmGMV_HospitalSelector.fraHospLocationLookup.IEN;
    end;
  FreeAndNil(frmGMV_HospitalSelector);
}

  sLocationID := _FHospitalIEN;
  sLocationName := '';
//{$IFDEF AANTEST}
  if SelectLocation2(FDFN,sLocationID,sLocationName) then
//{$ELSE}
//  if SelectLocation(FDFN,sLocationID,sLocationName) then
//{$ENDIF}
    begin
      _FHospitalIEN := sLocationID;
      lblHospital.Caption := sLocationName;
    end;
end;

procedure TfrmGMV_InputLite.pnlLatestVitalsBgResize(Sender: TObject);
begin
  if pnlLatestVitalsBG.Height > (pnlInput.Height div 4 ) * 3 then
    pnlLatestVitalsBG.Height := (pnlInput.Height div 4 ) * 3;
  if pnlLatestVitalsBG.Height < pnlInput.Height div 5 then
    pnlLatestVitalsBG.Height := pnlInput.Height div 5;
end;

procedure TfrmGMV_InputLite.CMVitalChanged(var Message: TMessage);
begin
  bDataUpdated := True;
end;

function TfrmGMV_InputLite.InputString: String;
var
  i: Integer;
  s: String;
begin
  s := '';
  for i := 0 to sbxMain.ControlCount - 1 do
    if sbxMain.Controls[i] is TfraGMV_InputOne2 then
      with TfraGMV_InputOne2(sbxMain.Controls[i]) do
        if ckbOnPass.Checked then
          s := s + 'OnPass'
        else
          s := s + VitalsRate;
  Result := s;
end;

procedure TfrmGMV_InputLite.strgLVDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with strgLV.canvas do
    begin
      if aRow = 0 then Brush.Color := clBtnFace
      else
      if pos('*',strgLV.Cells[2,aRow])<>0 then
        begin
          Font.Color := DisplayColors[GMVAbnormalText];
//          if pos(FormatDateTime('mm/dd/yy',Now),strgLV.Cells[0,ARow])<>0 then
//            Brush.Color := DisplayColors[GMVAbnormalTodayBkgd]
//          else
            Brush.Color := DisplayColors[GMVAbnormalBkgd];
        end
      else
        begin
          Font.Color := DisplayColors[GMVnormalText];
//          if pos(FormatDateTime('mm/dd/yy',Now),strgLV.Cells[0,ARow])<>0 then
//            Brush.Color := DisplayColors[GMVnormalTodayBkgd]
//          else
            Brush.Color := DisplayColors[GMVnormalBkgd];
        end;

      FillRect(Rect);
      TextRect(Rect,Rect.Left+2,Rect.Top,strgLV.Cells[aCol,aRow]);
    end;

end;

procedure TfrmGMV_InputLite.FormCreate(Sender: TObject);
begin
  bSlave := False;

  pnlMonitor.Visible := False;
  pnlCasmed.Visible := False;

{$IFDEF V5021} // CASMED support
  pnlCasmed.Visible := true;
{$ENDIF}

  with TVersionInfo.Create(self) do
  try
    fFileVersion := FileVersion;
    fFileComments := Comments;
  finally
    free;
  end;

{$IFDEF USEVSMONITOR}
  fMonitor := TGMV_Monitor.Create;
  if (fMonitor <> nil) and fMonitor.Active then
    begin
      pnlMonitor.Visible := True;
      sbMonitor.Caption := fMonitor.Model;
      pnlCasmed.Visible := False;
    end;
{$ENDIF}

{$IFDEF DLL}
  HelpContext := 3;
{$ENDIF}

end;

procedure TfrmGMV_InputLite.ckbUnavailableEnter(Sender: TObject);
begin
  bvUnavailable.Visible := True;
end;

procedure TfrmGMV_InputLite.ckbUnavailableExit(Sender: TObject);
begin
  bvUnavailable.Visible := False;
end;

procedure TfrmGMV_InputLite.ckbUnavailableClick(Sender: TObject);
begin
  acSetOnPassExecute(ckbUnavailable);
end;

procedure TfrmGMV_InputLite.acUnavailableBoxStatusExecute(
  Sender: TObject);

  procedure SetUStatus(aStatus:Boolean);
  var
    i: Integer;
  begin
    ckbUnavailable.Visible := aStatus;
    lblUnavailable.Visible := aStatus;
    for i := 0 to sbxMain.ComponentCount - 1 do
      begin
        if sbxMain.Components[i] is TfraGMV_InputOne2 then
          begin
             TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Visible := not aStatus;
             TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Checked :=
                 ckbUnavailable.Checked;
             TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Enabled := True;
          end;
      end;
    if aStatus then
      begin
        hc.Sections[2].Text := 'Refused';
      end
    else
      hc.Sections[2].Text := 'U... R...'
  end;

begin
  if chkOneUnavailableBox.Checked then
    SetUStatus(True)
  else
    SetUStatus(False);
  ApplyInputTemplateLayout(True);  //kt //codex 8/27/26
end;

procedure TfrmGMV_InputLite.CMSaveInput(var Message: TMessage);
begin
  acSaveInputExecute(nil);
end;

procedure TfrmGMV_InputLite.acParamsShowHideExecute(Sender: TObject);
begin
  bShowParams := not bShowParams;
//  sbtnTemplateTree.Down := bShowParams;
  sbtnToolShowParams.Down := bShowParams;

  if pnlParams.Visible and not bShowParams then
      splParams.Visible := False;
  pnlParams.Visible := bShowParams;
  if Sender <> nil then
    try
      FormResize(sender);
    except
    end;
  if pnlParams.Visible then
      splParams.Visible := True;
end;

procedure TfrmGMV_InputLite.acAdjustToolbarsExecute(Sender: TObject);
var
  i,j: Integer;
begin
  j := lblHospital.Width + lblHospital.left+4;
  i := lblDateTime.Width + lblDateTime.left+4;
  if j<i then
    j := i;
  i := pnlTools.Width - pnlPatient.Width - pnlParamTools.Width;

  if i < j then
    begin
      pnlTools.Visible := False;
      pnlTools.Visible := True;
      tlbInput.Align := alTop;
      tlbInput.Visible := True;
      Application.ProcessMessages;
    end
  else
    tlbInput.Visible := False;
  pnlParamTools.Visible := not tlbInput.Visible;
end;

procedure TfrmGMV_InputLite.acVitalsShowHideExecute(Sender: TObject);
begin
  bShowVitals := not bShowVitals;
  sbtnShowLatestVitals.Down := bSHowVitals;
//  sbtnToolShowVitals.Down := bSHowVitals;
  if pnlLatestVitalsBG.Visible and not bSHowVitals then
    splLastVitals.Visible := False;
  pnlLatestVitalsBG.Visible := bShowVitals;
  if pnlLatestVitalsBG.Visible then
    begin
      splLastVitals.Visible := true;
    end
  else
    pnlInputTemplate.Align := alClient;
end;

procedure TfrmGMV_InputLite.lvSelPatientsClick(Sender: TObject);
begin
  PatientSelected;
  acSetOnPassExecute(Sender);
  cbRClick(nil); // vhaishandria 060223
end;

procedure TfrmGMV_InputLite.lvSelPatientsChanging(Sender: TObject;
  Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
var
  i: Integer;
  bFlag: Boolean;
begin
  bFlag := True;
  for i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          bFlag := bFlag and TfraGMV_InputOne2(sbxMain.Components[i]).Valid;
          if not bFlag then break;
        end;
    end;
  AllowChange := bFlag;
end;

procedure TfrmGMV_InputLite.lvSelPatientsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  try
    if (Item.SubItems[1] = FDFN) and
        (InputString <> '') and         //2003/08/29 AAN
        bDataUpdated
       then  if (MessageDlg(
             'You are selecting another patient.' + #13
            +'Some of the input fields contain data.'+#13+#13
            +'Save this data for the patient "'+getPatientName+'"?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
          begin
            acSaveInputExecute(Sender);
          end
        else
          begin
            bDataUpDated := False;      //2003/08/29 AAN
          end
    else                                //2003/08/29 AAN
    bDataUpDated := InputString <>'';   //2003/08/29 AAN
  except
  end;
end;

procedure TfrmGMV_InputLite.PatientSelected;
var
  I: Integer;
  s,
  sPatientID: String;
  CurrentItem: TListItem;  //kt //codex 8/27/26
begin
  for i := 0 to lvSelPatients.Items.Count-1 do
    try
      s := lvSelPatients.Items[i].SubItems[3];
      if s = '' then
//      if lvSelPatients.Items[i].ImageIndex = 1 then
         lvSelPatients.Items[i].ImageIndex := 0
      else if pos(' ',s) <> 0 then
         lvSelPatients.Items[i].ImageIndex := indMultipleInput
      else
//         lvSelPatients.Items[i].ImageIndex := indSingleInput;
         lvSelPatients.Items[i].ImageIndex := StrToInt(s);
     except
     end;

  CurrentItem := CurrentPatientItem;  //kt //codex 8/27/26
  try
    if CurrentItem <> nil then
      begin
        sPatientID := CurrentItem.SubItems[1];  //kt //codex 8/27/26
        if CurrentItem.SubItems[3] = '' then
          CurrentItem.ImageIndex := 1  //kt //codex 8/27/26
        else if pos(' ',CurrentItem.SubItems[3]) <> 0 then
          CurrentItem.ImageIndex := indMultipleCurrent  //kt //codex 8/27/26
        else
          CurrentItem.ImageIndex := indSingleCurrent;  //kt //codex 8/27/26
      end
    else
      sPatientID := '';
  except
    sPatientID := '';
  end;
  if sPatientID = '' then Exit;

  if lvSelPatients.Checkboxes then
    ckbOnPass.Checked := CurrentItem.Checked;  //kt //codex 8/27/26

  setPatientInfoView(CurrentItem.SubItems[0],
    CurrentItem.SubItems[2]); // vhaishandria 060309  //kt //codex 8/27/26

  pnlLatestVitalsHeader.Caption :=
    '  Latest Vitals for patient <'+getPatientName+'>';

  FDFN := sPatientID;

  UpdateLatestVitals(sPatientID,True);

  bDataUpdated := InputString <> '';
end;

function TfrmGMV_InputLite.CurrentPatientItem: TListItem;  //kt //codex 8/27/26
//kt //codex added entire function/procedure 8/27/26
var
  i: Integer;  //kt //codex 8/27/26
begin
  Result := nil;
  if lvSelPatients = nil then Exit;
  if FDFN <> '' then
    for i := 0 to lvSelPatients.Items.Count - 1 do
      if lvSelPatients.Items[i].SubItems[1] = FDFN then
        begin
          Result := lvSelPatients.Items[i];
          Exit;
        end;
  if lvSelPatients.ItemFocused <> nil then
    Result := lvSelPatients.ItemFocused
  else if lvSelPatients.Items.Count > 0 then
    Result := lvSelPatients.Items[0];
end;

procedure TfrmGMV_InputLite.ApplyInputTemplateLayout(
  AResetColumnWidths: Boolean);  //kt //codex 8/27/26
//kt //codex added entire function/procedure 8/27/26
const
  DEFAULT_NUM_WIDTH = 29;
  DEFAULT_UNAVAILABLE_WIDTH = 70;
  DEFAULT_REFUSED_WIDTH = 60;
  DEFAULT_VITAL_WIDTH = 130;
  DEFAULT_VALUE_WIDTH = 116;
  DEFAULT_UNITS_WIDTH = 78;
  MIN_QUALIFIERS_WIDTH = 80;
var
  i: Integer;
  UsedWidth: Integer;
  QualifierWidth: Integer;
  RowFrame: TfraGMV_InputOne2;
  NumWidth: Integer;
  UnavailableWidth: Integer;
  RefusedWidth: Integer;
  VitalWidth: Integer;
  ValueWidth: Integer;
  UnitsWidth: Integer;

  procedure CenterControl(AControl: TControl; ALeft, AWidth: Integer);
  begin
    AControl.Left := ALeft + ((AWidth - AControl.Width) div 2);
    if AControl.Left < ALeft then
      AControl.Left := ALeft;
  end;

begin
  if (hc = nil) or (hc.Sections.Count < 7) then Exit;

  if AResetColumnWidths then
  begin
    hc.Sections[0].Width := DEFAULT_NUM_WIDTH;
    if chkOneUnavailableBox.Checked then
      hc.Sections[1].Width := 0
    else
      hc.Sections[1].Width := DEFAULT_UNAVAILABLE_WIDTH;
    hc.Sections[2].Width := DEFAULT_REFUSED_WIDTH;
    hc.Sections[3].Width := DEFAULT_VITAL_WIDTH;
    hc.Sections[4].Width := DEFAULT_VALUE_WIDTH;
    hc.Sections[5].Width := DEFAULT_UNITS_WIDTH;
  end;

  UsedWidth := 0;
  for i := 0 to 5 do
    Inc(UsedWidth, hc.Sections[i].Width);
  QualifierWidth := hc.Width - UsedWidth;
  if QualifierWidth < MIN_QUALIFIERS_WIDTH then
    QualifierWidth := MIN_QUALIFIERS_WIDTH;
  hc.Sections[6].Width := QualifierWidth;

  strgLV.ColWidths[0] := hc.Sections[0].Width + hc.Sections[1].Width + hc.Sections[2].Width + 2;
  strgLV.ColWidths[1] := hc.Sections[3].Width - 2;
  strgLV.ColWidths[2] := hc.Sections[4].Width;
  strgLV.ColWidths[3] := hc.Sections[5].Width;
  strgLV.ColWidths[4] := hc.Sections[6].Width - 100;
  strgLV.ColWidths[5] := 100;

  NumWidth := hc.Sections[0].Width;
  UnavailableWidth := hc.Sections[1].Width;
  RefusedWidth := hc.Sections[2].Width;
  VitalWidth := hc.Sections[3].Width;
  ValueWidth := hc.Sections[4].Width;
  UnitsWidth := hc.Sections[5].Width;

  for i := 0 to sbxMain.ComponentCount - 1 do
    if sbxMain.Components[i] is TfraGMV_InputOne2 then
    begin
      RowFrame := TfraGMV_InputOne2(sbxMain.Components[i]);
      RowFrame.pnlRefusedUnavailable.Width := NumWidth + UnavailableWidth + RefusedWidth;
      RowFrame.lblNum.Width := NumWidth;
      CenterControl(RowFrame.bvU, NumWidth, UnavailableWidth);
      CenterControl(RowFrame.cbxUnavailable, NumWidth, UnavailableWidth);
      CenterControl(RowFrame.bvR, NumWidth + UnavailableWidth, RefusedWidth);
      CenterControl(RowFrame.cbxRefused, NumWidth + UnavailableWidth, RefusedWidth);

      RowFrame.pnlName.Width := VitalWidth;

      RowFrame.pnlValues.Width := ValueWidth + UnitsWidth;
      RowFrame.cbxInput.Width := ValueWidth - 4;
      if RowFrame.cbxInput.Width < 40 then
        RowFrame.cbxInput.Width := 40;
      RowFrame.cbxUnits.Left := ValueWidth + 1;
      RowFrame.cbxUnits.Width := UnitsWidth - 2;
      if RowFrame.cbxUnits.Width < 0 then
        RowFrame.cbxUnits.Width := 0;
      RowFrame.lblUnit.Left := ValueWidth + 4;
      RowFrame.ckbMetric.Left := RowFrame.pnlValues.Width - RowFrame.ckbMetric.Width - 6;
      RowFrame.bvMetric.Left := RowFrame.ckbMetric.Left - 4;
    end;
end;

procedure TfrmGMV_InputLite.hcSectionResize(HeaderControl: THeaderControl;
  Section: THeaderSection);  //kt //codex 8/27/26
//kt //codex added entire function/procedure 8/27/26
begin
  ApplyInputTemplateLayout(False);
end;

procedure TfrmGMV_InputLite.FormDestroy(Sender: TObject);
begin
  if Status = stsDLL then CleanUpGlobals;
{$IFDEF USEVSMONITOR}
  if fMonitor <> nil then
    fMonitor.Free;
{$ENDIF}
end;

procedure TfrmGMV_InputLite.setStatus(aStatus:String);
begin
  fStatus := aStatus;
  if fStatus = stsDLL then
    begin
      SetUpGlobals;
      GMVUser.SetupSignOnParams;
      GMVUser.SetupUser;
    end;
end;

//////////////////////////////////////////////////////////////////// CASMED UNIT
procedure TfrmGMV_InputLite.acGetCASMEDDataExecute(Sender: TObject);
var
  i: Integer;
  anIn: TfraGMV_InputOne2;
  rr, rTemp:Real;

  aCM: TATE740X;        // should be interface, that supprts VS

  sBP : String;
  sPulse: String;
  sTemp: String;
  sTempUnit:String;
  sSpO2:String;

  // V5021 supports 740-3MS 740-2T 740-3ML and software 2.2 and up
  const
    cSupportedUnits = '740-3MS 740-2T 740 2T 740-3NL ';
    cSupportedSoftvare = ' 2.2'; // v. 5.0.2.1

  function SupportedModel(aValue:String):Boolean;
  begin
    Result := pos(trim(uppercase(aValue)),cSupportedUnits) > 0;// aValue = cSupportedUnit;
  end;

  function SupportedSoftware(aValue:String):Boolean;
  var
    f: Double;
  begin
    try
      f := strToFloat(aValue);
    except
      on E: Exception do
        f := 0.0;
    end;
    Result := f >=2.2;
  end;

begin
  try
    try
      ComPort.Free;
      ComPort := TComPort.Create;
    except
      Exit;
    end;
    ComPort.Purge;
    ComPort.Close;

    Screen.Cursor := crHourGlass;
    aCM := TATE740X.Create;
    Screen.Cursor := crDefault;

    if aCM.Status <> cmsCreated then
      begin
        ShowMessage(errCheckStatus);
        aCM.Free;
        Exit;
      end;

    if aCM.Numerics <> 'ERROR' then
      begin
        if not SupportedModel(aCM.Model) then
          begin
            ShowMessage('Sorry. The model <'+aCM.Model+'> is not supported.');
            aCM.Free;
            Exit;
          end;
        if not SupportedSoftware(aCM.SoftwareVersion) then
          begin
            ShowMessage('Sorry. The software version <'+aCM.SoftwareVersion+'> is not supported.');
            aCM.Free;
            Exit;
          end;

        sBP := aCM.sBP;
        sPulse := aCM.sPulse;
        sSpO2 := aCM.sSpO2;
        rTemp :=aCM.fTemp;              // rTemp := 33.3;
        sTemp := aCM.sTemp;             // sTemp := '33.3';
        sTempUnit := aCM.TempUnit;      // sTempUnit := 'C';
         //kt make changes here
        for i := 0 to sbxMain.ComponentCount - 1 do
          begin
            if sbxMain.Components[i] is TfraGMV_InputOne2 then
              begin
                anIn := TfraGMV_InputOne2(sbxMain.Components[i]);
                //kt make changes here
                if (anIn.TemplateVital.VitalName = 'TEMPERATURE') and (sTemp<>'') then
                  begin
                    if sTempUnit = copy(anIn.lblUnit.Caption,2,1) then
                      anIn.cbxInput.Text := sTemp
                    else
                      begin
                        if sTempUnit = 'C' then  rr := ConvertCtoF(rTemp)
                        else                     rr := ConvertFtoC(rTemp);
                        sTemp := Format('%4.1f',[rr]);
                        anIn.cbxInput.Text := sTemp
                      end;
                    anIn.Check;
                    sTemp := '';
                  end;
                if (anIn.TemplateVital.VitalName = 'PULSE') and (sPulse<>'') then
                  begin
                    anIn.cbxInput.Text := sPulse;
                    sPulse := '';
                  end;
                if (anIn.TemplateVital.VitalName = 'BLOOD PRESSURE') and (sBP<>'') then
                  begin
                    anIn.cbxInput.Text := sBP;
                    sBP := '';
                  end;
                if (anIn.TemplateVital.VitalName = 'PULSE OXIMETRY') and (sSpO2<>'') then
                  begin
                    anIn.cbxInput.Text := sSpO2;
                    sSpO2 := '';
                  end;
              end;
          end;
      end;
    aCM.Free;

  except
    on E: Exception do
        ShowMessage('Getting CASMED instrument data error:'+#13#10+E.Message);
  end;
end;

procedure TfrmGMV_InputLite.acCASMEDResetExecute(Sender: TObject);
begin
  try
    ComPort.Free;
    ComPort := TComPort.Create;
  except
    on E: Exception do
      ShowMessage('Reset CASMED instrument error:'+#13+#10+E.Message);
  end;
end;

procedure TfrmGMV_InputLite.acGetCASMEDDescriptionExecute(Sender: TObject);
var
  aCM: TATE740X;
begin
  Screen.Cursor := crHourGlass;
{$IFDEF USEVSMONITOR}
  if (fMonitor <> nil) and fMonitor.Active then
    begin
      ShowMessage(fMonitor.Description);
      Screen.Cursor := crDefault;
      Exit;
    end;
{$ENDIF}
  aCM := TATE740X.Create;
  Screen.Cursor := crDefault;
  if aCM.Status <> cmsCreated then
    ShowMessage(errCheckStatus)
  else
    ShowMessage('CASMED '+aCM.Model+ ' (SN: '+aCM.SerialNumber+')  at '+aCM.ComPortname+#13+
              '___________________________________'+#13+#13+#9+
              'Software: '+aCM.SoftwareVersion+' ('+aCM.SoftwareDate+')'+#13+#9+#9+
              'Boot: '+#9+aCM.BootVersion+#13+#9+#9+
              'PIC: '+#9+aCM.PICVersion+#13+#9+#9+
              'NBP: '+#9+aCM.NBPVersion+#13+#9+#9+
              'Temp: '+#9+aCM.TempVersion);
  aCM.Free;

  Screen.Cursor := crDefault;
end;
//////////////////////////////////////////////////////////////// CASMED UNIT END

procedure TfrmGMV_InputLite.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ww: Word;
begin
  if (Key = word('Z')) and (ssCtrl in Shift) then
    acGetCasmedDescriptionExecute(nil); // CASMED
  if Key = VK_ESCAPE then btnCancelClick(nil);

  if Key = VK_F1 then
    begin
      Application.HelpCommand(0,0);
    end;

  if (Key = VK_Return) and (ActiveControl=pnlPatient) then
    begin
      acPatientInfo.Execute;
    end;

end;

procedure TfrmGMV_InputLite.acMonitorGetDataExecute(Sender: TObject);
{$IFDEF USEVSMONITOR}
var
  aCM: TGMV_Monitor;
  sBP,sBPSystolic,sBPDiastolic,sBPMean,
  sPulse,
  sSpO2,
  sTemp,
  sTempUnit:String;
  rTemp, rr: Real;

  i: Integer;
  anIn: TfraGMV_InputOne2;
{$ENDIF}
begin
{$IFDEF USEVSMONITOR}
  if fMonitor = nil then Exit;

  fMonitor.GetData;
  sBP := fMonitor.sBP;
  sPulse := fMonitor.sPulse;
  sSpO2 := fMonitor.sSpO2;
  sTemp := fMonitor.sTemp;             // sTemp := '33.3';
  sTempUnit := fMonitor.sTempUnit;      // sTempUnit := 'C';
{$IFDEF AANTEST}
  ShowMessage(
    'BP:'+sBP+#13#10+
    'Pulse:'+sPulse+#13#10+
    'SpO2:'+sSpO2+#13#10+
    'Temp:'+sTemp+#13#10+
    'Temp Unit:'+sTempUnit+#13#10+
    fMonitor.XMLString);
{$ENDIF}
  //kt make changes here
  for i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          anIn := TfraGMV_InputOne2(sbxMain.Components[i]);
          if (anIn.TemplateVital.VitalName = 'TEMPERATURE') and (sTemp<>'') then
            begin
              if sTempUnit = copy(anIn.lblUnit.Caption,2,1) then
                anIn.cbxInput.Text := sTemp
              else
                begin
                  if sTempUnit = 'C' then  rr := ConvertCtoF(rTemp)
                  else                     rr := ConvertFtoC(rTemp);
                  sTemp := Format('%4.1f',[rr]);
                  anIn.cbxInput.Text := sTemp
                end;
              anIn.Check;
              sTemp := '';
            end;
          if (anIn.TemplateVital.VitalName = 'PULSE') and (sPulse<>'') then
            begin
              anIn.cbxInput.Text := sPulse;
              sPulse := '';
            end;
          if (anIn.TemplateVital.VitalName = 'BLOOD PRESSURE') and (sBP<>'') then
            begin
              anIn.cbxInput.Text := sBP;
              sBP := '';
            end;
          if (anIn.TemplateVital.VitalName = 'Systolic_blood_pressure') and (sBP<>'') then
            begin
              sBPSystolic := sBP;
              sBP := '';
            end;
          if (anIn.TemplateVital.VitalName = 'Diastolic_blood_pressure') and (sBP<>'') then
            begin
              sBPDiastolic := sBP;
              sBP := '';
            end;
          if (anIn.TemplateVital.VitalName = 'Mean_arterial_pressure') and (sBP<>'') then
            begin
              sBPMean := sBP;
              sBP := '';
            end;
          if (anIn.TemplateVital.VitalName = 'PULSE OXIMETRY') and (sSpO2<>'') then
            begin
              anIn.cbxInput.Text := sSpO2;
              sSpO2 := '';
            end;
        end;
    end;

{$ENDIF}
end;

procedure TfrmGMV_InputLite.cbRClick(Sender: TObject);
var
  i: Integer;
begin
  for  i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
        begin
          if not ckbOnPass.Checked then
            begin
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxUnavailable.Enabled := cbU.Checked;
              TfraGMV_InputOne2(sbxMain.Components[i]).cbxRefused.Enabled := cbR.Checked;
            end;
        end
    end;
end;


procedure TfrmGMV_InputLite.hcMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  j,
  i: integer;
begin
  hc.Enabled := True;
  j := 0;
  for i := 0 to hc.Sections.Count - 1 do
    begin
      j := j + hc.Sections[i].Width;
      if j > X then
        begin
          case i of
            0: hc.Hint := 'Template Line Number';
            2: hc.Hint := 'U - Unavailable, R - Refused';
            3: hc.Hint := 'Vital Type';
            4: hc.Hint := 'Vital Value';
            5: hc.Hint := 'Vital Value Units';
            6: hc.Hint := 'Vital Value Qualifiers';
          else
            hc.Hint := hc.Sections[i].Text;
          end;
          break;
        end;
    end;

end;

procedure TfrmGMV_InputLite.cbConversionWarningClick(Sender: TObject);
var
  i: Integer;
begin
  for  i := 0 to sbxMain.ComponentCount - 1 do
    begin
      if sbxMain.Components[i] is TfraGMV_InputOne2 then
          TfraGMV_InputOne2(sbxMain.Components[i]).conversionWarning := cbConversionWarning.Checked;
    end;
end;

procedure TfrmGMV_InputLite.pnlPatientEnter(Sender: TObject);
begin
  pnlPatient.BevelInner := bvRaised; // vhaishandria 060308
end;

procedure TfrmGMV_InputLite.pnlPatientExit(Sender: TObject);
begin
  pnlPatient.BevelInner := bvNone; // vhaishandria 060308
end;

procedure TfrmGMV_InputLite.pnlPatientClick(Sender: TObject);
begin
  acPatientInfo.Execute;
end;

procedure TfrmGMV_InputLite.acPatientInfoExecute(Sender: TObject);
var
  sTitle,
  sInfo:String;
begin
  ShowPatientInfo(FDFN); // vhaishandria 060308
{
  sTitle := 'About patient '+getPatientName;
  sInfo := 'Patient: '+getPatientName + #13#10;
  sInfo := sInfo + getPatientInfo;
  ShowInfo(sTitle,sInfo); // vhaishandria 060308
}
end;

procedure TfrmGMV_InputLite.setPatientInfoView(aName,anInfo:String);
begin
  edPatientName.Text := aName;
//  lblPatientName.Caption := aName;
//  lblPatientInfo.Caption := anInfo;
  edPatientInfo.Text := anInfo;
{$IFDEF DLL}
  Caption := 'Vitals Lite: Enter Vitals for '+aName + ' ' + anInfo;
{$ELSE}
  Caption := 'Vitals: Enter Vitals for '+aName + ' ' + anInfo;
{$ENDIF}
end;

procedure TfrmGMV_InputLite.updatePatientInfoView;
var
  SL: TStringList;
begin
  SL := getPatientHeader(FDFN);
  setPatientInfoView(FormatPatientName(SL[1]),
     FormatPatientInfo(SL[1]+ SL[2]));
  SL.Free;
//lblPatientInfo.Caption := FormatPatientInfo(SL[1]+ SL[2]);
//lblPatientName.Caption := FormatPatientName(SL[1]);
{$IFDEF DLL}
   Caption := ' Vitals Lite: Enter Vitals for '+getPatientName + ' '+getPatientInfo;
{$ELSE}
   Caption := ' Vitals: Enter Vitals for '+getPatientName + ' '+getPatientInfo;
{$ENDIF}

end;

function TfrmGMV_InputLite.getPatientName:String;
begin
//  Result := lblPatientName.Caption;
  Result := edPatientName.Text;
end;

function TfrmGMV_InputLite.getPatientInfo:String;
begin
//  Result := lblPatientInfo.Caption;
  Result := edPatientInfo.Text;
end;

procedure TfrmGMV_InputLite.edPatientNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
      acPatientInfo.Execute;
end;

procedure TfrmGMV_InputLite.acShowStatusBarExecute(Sender: TObject);
begin
  StatusBar.Visible := not StatusBar.Visible;
end;

procedure TfrmGMV_InputLite.pnlPatientMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPatient.BevelOuter := bvLowered;
end;

procedure TfrmGMV_InputLite.pnlPatientMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPatient.BevelOuter := bvRaised;
  acPatientInfo.Execute;
end;


function TfrmGMV_InputLite.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
var
    s: String;
begin
  try
    s := GetProgramFilesPath+'\Vista\Common Files\GMV_VitalsViewEnter.hlp';
    Application.HelpSystem.ShowContextHelp(1,s);
    Result := true;
  except
    Result := false;
  end;
  CallHelp := False;
end;


end.

