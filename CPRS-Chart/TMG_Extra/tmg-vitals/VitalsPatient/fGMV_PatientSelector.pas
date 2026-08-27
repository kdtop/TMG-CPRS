unit fGMV_PatientSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type
  TgetList = function:TStringList of object;

  TfrmGMV_PatientSelector = class(TForm)
    pnlStatus: TPanel;
    pcMain: TPageControl;
    tsUnit: TTabSheet;
    tsTeam: TTabSheet;
    tsClinic: TTabSheet;
    tsWard: TTabSheet;
    tsAll: TTabSheet;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    pnlTitle: TPanel;
    tmSearch: TTimer;
    Button1: TButton;
    Button2: TButton;
    lblSelected: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    pnlInfo: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    lblTarget: TLabel;
    lblPatientName: TLabel;
    Label6: TLabel;
    lblLocationName: TLabel;
    Label10: TLabel;
    Bevel3: TBevel;
    Label11: TLabel;
    Bevel4: TBevel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Bevel5: TBevel;
    lblSelectedPatientNameID: TLabel;
    lblSelectedPatientLocationNameID: TLabel;
    Label7: TLabel;
    lblPatientLocationID: TLabel;
    Label12: TLabel;
    Bevel6: TBevel;
    mmList: TMemo;
    Label13: TLabel;
    lblSelectStatus: TLabel;
    pnlSelection: TPanel;
    pnlPtInfo: TPanel;
    lblSelectedName: TLabel;
    lblPatientInfo: TLabel;
    Panel3: TPanel;
    lvUnitPatients: TListView;
    Panel16: TPanel;
    Panel11: TPanel;
    Bevel2: TBevel;
    Label14: TLabel;
    Panel6: TPanel;
    Panel17: TPanel;
    cmbUnit: TComboBox;
    lbUnits: TListBox;
    Panel18: TPanel;
    Bevel7: TBevel;
    Label15: TLabel;
    Panel1: TPanel;
    lvWardPatients: TListView;
    Panel15: TPanel;
    Panel19: TPanel;
    Bevel8: TBevel;
    Label16: TLabel;
    Panel7: TPanel;
    Panel20: TPanel;
    cmbWard: TComboBox;
    lbWards: TListBox;
    Panel21: TPanel;
    Bevel9: TBevel;
    Label17: TLabel;
    Panel5: TPanel;
    lvAllPatients: TListView;
    Panel12: TPanel;
    Panel22: TPanel;
    Bevel10: TBevel;
    Label18: TLabel;
    Panel9: TPanel;
    cmbAll: TComboBox;
    Panel2: TPanel;
    lvTeampatients: TListView;
    Panel14: TPanel;
    Panel23: TPanel;
    Bevel11: TBevel;
    Label19: TLabel;
    Panel8: TPanel;
    Panel24: TPanel;
    cmbTeam: TComboBox;
    lbTeams: TListBox;
    Panel25: TPanel;
    Bevel12: TBevel;
    Label20: TLabel;
    Panel4: TPanel;
    lvClinicPatients: TListView;
    Panel13: TPanel;
    Panel26: TPanel;
    Bevel13: TBevel;
    Label21: TLabel;
    Panel10: TPanel;
    Panel27: TPanel;
    cmbClinic: TComboBox;
    cmbPeriod: TComboBox;
    lbClinics: TListBox;
    Panel28: TPanel;
    Bevel14: TBevel;
    Label22: TLabel;
    Label23: TLabel;
    procedure tmSearchTimer(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure cmbUnitChange(Sender: TObject);
    procedure lbUnitsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbUnitsDblClick(Sender: TObject);
    procedure lvUnitPatientsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvUnitPatientsKeyPress(Sender: TObject; var Key: Char);
    procedure lvUnitPatientsDblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure lbUnitsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbUnitKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbUnitEnter(Sender: TObject);
    procedure cmbUnitExit(Sender: TObject);
    procedure lbUnitsEnter(Sender: TObject);
    procedure lbUnitsExit(Sender: TObject);
    procedure lvUnitPatientsEnter(Sender: TObject);
    procedure lvUnitPatientsExit(Sender: TObject);
    procedure cmbPeriodEnter(Sender: TObject);
    procedure cmbPeriodExit(Sender: TObject);
    procedure cmbPeriodChange(Sender: TObject);
    procedure cmbAllChange(Sender: TObject);
    procedure lvAllPatientsKeyPress(Sender: TObject; var Key: Char);
    procedure cmbAllKeyPress(Sender: TObject; var Key: Char);
    procedure lvUnitPatientsClick(Sender: TObject);
    procedure pnlPtInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlPtInfoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    fSelectedPatientName,
    fSelectedPatientID,
    fSelectedPatientLocationName,
    fSelectedPatientLocationID: String;

    fPatientID: string; //
    fPatientLocationName,
    fPatientLocationID,
    fPatientName:String;

    fLocationName,
    fLocationCaption, // Name of Location record in the list
    fLocationID:String;

    fTarget: String;

    fSource: TComboBox;
    fListBox: TListBox;
    fLV: TListView;
    fGetList: TgetList;
    fFound: Integer;
    fIgnore:Boolean;

    bUseLocationID:Boolean;

    fOnPatChange: TNotifyEvent;

    function getUnitList:TStringList;
    function getWardList:TStringList;
    function getTeamList:TStringList;
    function getClinicList:TStringList;
    function getAllPatientList:TStringList;

    procedure SilentSearch;
    procedure Search;
    procedure NotifyStart;
    procedure NotifyEnd;
    procedure setTarget(aValue:String);
    function UpdateListView(aSource:TStrings;lvItems:TListItems;
      iCaption,iSSN:Integer; iSubItems: array of Integer;aMode:Integer):Integer;
    procedure ClearListView(aLV: TListView);
    procedure ReportFoundItems(aCount:Integer;aMessage:String);

    procedure SetPatientIEN(const Value: string);

    procedure SetCurrentPatient;
    procedure SetCurrentList;

    function getSelectCount:Integer;
    function getFocusedPatientID:String;

  public
    { Public declarations }
    bIgnore: Boolean;

    iMSecondsToStart:Integer; //
    sSecondsToStart:String;   //
    sStatus:String;
    SelectionStatus:String;

    property Target:String read fTarget write setTarget;

    property FoundCount:Integer read fFound;
    property SelectCount: Integer read getSelectCount;

    property PatientGroup: TListBox read fListBox;
    property PatientList: TListView read fLV;

    property FocusedPatientID:String read getFocusedPatientID;

    property SelectedPatientName:String read fPatientName;
    property SelectedPatientID: string read fSelectedPatientID write SetPatientIEN;
    property SelectedPatientLocationName:String read fSelectedPatientLocationName;
    property SelectedPatientLocationID:String read fSelectedPatientLocationID;
    property OnPatChange: TNotifyEvent read FOnPatChange write FOnPatChange;

    procedure SetUp;
    procedure SetTimerInterval(sInterval:String);

    procedure setupInfo;
    procedure SetCurrentLocation;
  end;

var
  frmGMV_PatientSelector: TfrmGMV_PatientSelector;

function SelectPatientDFN(var aDFN: String; var aName:String): Boolean;
function getPatientSelectorForm:  TfrmGMV_PatientSelector;

const
  ssSelected = 'SELECTED';
  ssInProgress = 'Selection In Progress';

implementation

uses uGMV_Common, uGMV_FileEntry, uGMV_Const, uGMV_Engine, uGMV_GlobalVars,
  fGMV_PtSelect, uGMV_Patient, fGMV_PtInfo;

{$R *.dfm}
function getPatientSelectorForm:  TfrmGMV_PatientSelector;
begin
  if not Assigned(frmGMV_PatientSelector) then
    begin
      Application.CreateForm(TfrmGMV_patientSelector, frmGMV_PatientSelector);
      frmGMV_PatientSelector.SetUp;
    end;
  Result := frmGMV_PatientSelector;
end;

function SelectPatientDFN(var aDFN: String; var aName:String): Boolean;
begin
  Result := False;
  if not Assigned(frmGMV_PatientSelector) then
    begin
      Application.CreateForm(TfrmGMV_patientSelector, frmGMV_PatientSelector);
      frmGMV_PatientSelector.SetUp;
    end;
  if  frmGMV_PatientSelector = nil then exit;

  if frmGMV_PatientSelector.ShowModal = mrOK then
    begin
      frmGMV_PatientSelector.tmSearch.Enabled := False;
      aName := frmGMV_PatientSelector.SelectedPatientName;
      aDFN := frmGMV_PatientSelector.SelectedPatientID;
      Result := True;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.FormCreate(Sender: TObject);
begin
  SelectionStatus := '';
  bIgnore := False;
  fIgnore := False;
  fFound := 0;
  pcMain.ActivePageIndex := 0;
  fGetList := getUnitList;
  fSource := cmbUnit;
  fLV := lvUnitPatients;
  fListBox := lbUnits;
  lblSelected.Caption := '';
{$IFDEF DEBUGVERSION}
  lblSelected.Visible := True;
  PNLiNFO.Visible := tRUE;
  {$ELSE}
  PNLiNFO.Visible := False;
  lblSelected.Visible := False;
{$ENDIF}
  lblPatientName.Caption := '';
  lblPatientLocationID.Caption := '';

  cmbUnit.Color := clTabIn;
  cmbWard.Color := clTabIn;
  cmbTeam.Color := clTabIn;
  cmbClinic.Color := clTabIn;
  cmbAll.Color := clTabIn;
end;

procedure TfrmGMV_PatientSelector.Setup;
begin
  try
    if GMVNursingUnits.Entries.Count < 1 then
    GMVNursingUnits.LoadEntries('211.4');

    lbUnits.Items.Clear;
    lbUnits.Items.Assign(GMVNursingUnits.Entries);
  except
  end;
  try
    if GMVWardLocations.Entries.Count < 1 then
      GMVWardLocations.LoadEntries('42');

    lbWards.Items.Clear;
    lbWards.Items.Assign(GMVWardLocations.Entries);
  except
  end;
  try
    if GMVTeams.Entries.Count < 1 then
      GMVTeams.LoadEntries('100.21');

    lbTeams.Items.Clear;
    lbTeams.Items.Assign(GMVTeams.Entries);
  except
  end;
  try
    if GMVClinics.Entries.Count < 1 then
    GMVClinics.LoadEntriesConverted('44');  //AAN 01/22/2003 - sorting problem

    lbClinics.Items.Clear;
    lbClinics.Items.Assign(GMVClinics.Entries);
  except
  end;
end;

procedure TfrmGMV_PatientSelector.SetTimerInterval(sInterval:String);
begin
  sSecondsToStart := sInterval;
  iMSecondsToStart := round(StrToFloat(GMVSearchDelay)*1000.0);
end;

procedure TfrmGMV_PatientSelector.SetPatientIEN(const Value: string);
begin
//  if Value = fSelectedPatientID then Exit;
  fSelectedPatientID := Value;
  if Assigned(FOnPatChange) then
    FOnPatChange(Self)
{$IFDEF DEBUGVERSION}
  else
    MessageDLG('OnPatChange is not assigned', mtInformation,[mbOK],0);
{$ENDIF}
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.ReportFoundItems(aCount:Integer;aMessage:String);
begin
  if aCount = 0 then
    begin
      if not bIgnore then
        MessageDlg(aMessage, mtInformation, [mbok], 0);
    end
  else
    begin
      GetParentForm(Self).Perform(WM_NEXTDLGCTL, 0, 0);
      lblSelected.Caption := 'Found: '+IntToStr(aCount);
    end;
end;

function TfrmGMV_PatientSelector.getUnitList:TStringList;
var
  RetList: TStringList;
begin
  fPatientLocationID := '';
  fPatientLocationName := '';

  RetList := getNursingUnitPatients(fLocationID);
  if RetList.Count < 1 then
    fFound := 0
  else
    fFound := UpdateListView(RetList,lvUnitPatients.Items,2,3,[4],0);

  sStatus := Format('%d patients found for nursing unit %s',[fFound,fLocationName]);
  ReportFoundItems(fFound,sStatus);

  Result := Retlist;
end;

function TfrmGMV_PatientSelector.getWardList:TStringList;
var
  RetList: TStringList;
begin
  RetList := getWardPatients(fLocationName);
  if RetList.Count < 1 then
    fFound := 0
  else
    fFound := UpdateListView(RetList,lvWardPatients.Items,2,3,[4],1);
{
  if fFound > 0 then
    begin
      fPatientLocationID := fLocationID;
      fPatientLocationName := fLocationName;
    end;
}
  sStatus := Format('%d patients found for the ward <%s>',[fFound,fLocationName]);
  ReportFoundItems(fFound,sStatus);

  Result := retList;
end;

function TfrmGMV_PatientSelector.getTeamList:TStringList;
var
  RetList: TStringList;
begin
  fPatientLocationID := '';
  fPatientLocationName := '';

  RetList := getTeampatients(fLocationID);

  if RetList.Count < 1 then
    fFound := 0
  else
    if RetList[0] = 'NO PATIENTS' then
      fFound := 0
    else
      fFound := UpdateListView(RetList,lvTeamPatients.Items,1,3,[4],2);

  sStatus := Format('%d patients found for the team <%s>',[fFound,fLocationName]);
  ReportFoundItems(fFound,sStatus);

  Result := RetList;
end;

function TfrmGMV_PatientSelector.getClinicList:TStringList;
var
  RetList: TStringList;
  sFailourReason:String;
begin
  if (fLocationName<>'') and (cmbPeriod.Text <> '') then
    begin
      RetList := getClinicPatients(fLocationCaption,cmbPeriod.Text);
//??      GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0); //AAN 07/18/02

      sFailourReason := '';
      if  (RetList.Count < 1) then
        fFound := 0
      else if pos('No patient',RetList[0]) <> 0 then
        fFound := 0
      else if pos('No clinic',RetList[0]) <> 0 then
        begin
          fFound := 0;
          sFailourReason := 'Check clinic name';
        end
      else if pos('Error',RetList[0]) <> 0 then
        begin
          fFound := 0;
          if pos('^',RetList[0]) > 0 then
            sFailourReason := piece(RetList[0],'^',2)
          else
            sFailourReason := RetList[0];
        end
      else
        fFound := UpdateListView(RetList,lvClinicPatients.Items,2,5,[6,4],3);

      sStatus := Format('%d patient apointments found for:'+#13+
        #13+'Clinic: <%s>'+
        #13+'Date:   <%s>'+
        #13+#13+'%s',[fFound,fLocationName,cmbPeriod.Text,sFailourReason]);

      if fFound > 0 then
        begin
          lvClinicPatients.ItemFocused := lvClinicPatients.Items[0];
          GetParentForm(Self).Perform(CM_SELECTPTLIST, 0, 0);
        end;

      ReportFoundItems(fFound,sStatus);

      Result := RetList;
    end
  else
    Result := nil;
end;

function TfrmGMV_PatientSelector.getAllPatientList:TStringList;
var
  RetList: TStringList;
begin
  fPatientLocationID := '';
  fPatientLocationName := '';
  RetList := getPatientList(Target);
  if Piece(RetList[0], '^', 1) = '-1' then
    begin
      fFound := 0;
      GetParentForm(Self).Perform(CM_PTLISTNOTFOUND, 0, 0); //AAN 07/22/02
      MessageDlg(Piece(RetList[0], '^', 2), mtInformation, [mbok], 0);
    end
  else
    begin
      RetList.Delete(0);
      fFound := UpdateListView(RetList,lvAllPatients.Items,2,11,[10],4);
      GetParentForm(Self).Perform(CM_PTLISTCHANGED, RetList.Count, 0); //AAN 08/30/02
    end;
  Result := RetList;
end;

procedure TfrmGMV_PatientSelector.SilentSearch;
var
  tmpList: TStringList;
begin
  if assigned(fGetList) then
    begin
      ClearListView(fLV);
      tmSearch.Enabled := False;
      tmpList := fGetList;
      GetParentForm(Self).Perform(CM_PTLISTCHANGED, 0, 0);
      tmpList.Free;
      if fFound > 0 then
        begin
          fLV.TabStop := true;
          fLV.Enabled := true;
          fLV.SetFocus;
        end
      else
        begin
          fLV.TabStop := False;
          fLV.Enabled := False;
        end;
    end;
end;

procedure TfrmGMV_PatientSelector.Search;
begin
  NotifyStart;
  SilentSearch;
  NotifyEnd;
end;

procedure TfrmGMV_PatientSelector.tmSearchTimer(Sender: TObject);
begin
  if iMSecondsToStart >= 500 then
    begin
      iMSecondsToStart := iMSecondsToStart - 500;
      sSecondsToStart := Format('%3.1n',[iMSecondsToStart/1000.0]);
      lblSelected.Caption := 'Seconds to start: '+sSecondsToStart;
      GetParentForm(Self).Perform(CM_PTSEARCHDelay, 0, 0); //AAN 07/22/02
      exit;
    end
  else
    begin
      tmSearch.Enabled := False;
      Search;
    end;
end;

procedure TfrmGMV_PatientSelector.setupInfo;
begin
  try
    lblTarget.Caption := fSource.Text;

    lblPatientName.Caption := fPatientName + ' / '+ fPatientID;
    lblLocationName.Caption := fLocationName + ' / ' + fLocationID;
    lblPatientLocationID.Caption := fPatientLocationName + ' / ' + fPatientLocationID;
    lblSelectedPatientNameID.Caption := fSelectedPatientName + ' /' + fSelectedPatientID;
    lblSelectedPatientLocationNameID.Caption := fSelectedPatientLocationName + ' /' + fSelectedPatientLocationID;
    lblSelectStatus.Caption := SelectionStatus;
    if SelectionStatus <> ssSelected then
      begin
        lblSelectedName.Caption := 'No Patient Selected';
        lblPatientInfo.Caption := '000-00-0000';
      end;
  except
    lblPatientName.Caption := '...';
    lblLocationName.Caption := '...';
    lblPatientLocationID.Caption := '';
    lblSelectedPatientNameID.Caption := '';
    lblSelectedPatientLocationNameID.Caption := '';
    lblSelectStatus.Caption := '?';
  end;
end;

procedure TfrmGMV_PatientSelector.SetCurrentList;
var
  i: Integer;
begin
  mmList.Lines.Clear;
  for i := 0 to fLV.Items.Count - 1 do
    if fLV.Items[i].Selected then
      mmList.Lines.Add(fLV.Items[i].Caption+' / '+ TGMV_FileEntry(fLV.Items[i].Data).IEN);
  GetParentForm(Self).Perform(CM_PTLISTCHANGED, 0, 0); // vhaishandria 050518
end;

procedure TfrmGMV_PatientSelector.pcMainChange(Sender: TObject);
begin
  tmSearch.Enabled := False;
  lblSelected.Caption := '';
  case pcMain.ActivePageIndex of
    0: begin
      fSource := cmbUnit;
      fLV := lvUnitPatients;
      fListBox := lbUnits;
      fGetList := getUnitList;
      bUseLocationID := False;
    end;
    1: begin
      fSource := cmbWard;
      fLV := lvWardPatients;
      fListBox := lbWards;
      fGetList := getWardList;
      bUseLocationID := True;
      end;
    2: begin fSource := cmbTeam; fLV := lvTeampatients;  fListBox := lbTeams; fGetList := getTeamList; bUseLocationID := False; end;
    3: begin fSource := cmbClinic; fLV := lvClinicPatients;  fListBox := lbClinics; fGetList := getClinicList; bUseLocationID := True; end;
    4: begin fSource := cmbAll; fLV := lvAllPatients;  fListBox := nil;  fGetList := getAllPatientList; bUseLocationID := False; end;
  end;
  Target := fSource.Text;
  try
    fSource.SetFocus;
  except
    on e: Exception do
      begin
      end;
  end;

  SetCurrentLocation;
  SetCurrentPatient;
  SetCurrentList;// list of selected patients

  SelectionStatus := 'Not selected';

  SetupInfo;
  try
    GetParentForm(Self).Perform(CM_PTLISTCHANGED, 0, 0); // Update Parent Window
  except
  end;
end;

procedure TfrmGMV_PatientSelector.setTarget(aValue:String);
begin
  tmSearch.Enabled := False;
  fTarget := aValue;
end;

procedure TfrmGMV_PatientSelector.NotifyStart;
begin
  lblSelected.Caption := 'Search...';
  GetParentForm(Self).Perform(CM_PTSEARCHING, 0, 0); //AAN 07/22/02
end;

procedure TfrmGMV_PatientSelector.NotifyEnd;
begin
  GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0); //AAN 07/18/02
  lblSelected.Caption := 'Found: '+IntToStr(fFound);;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.cmbUnitChange(Sender: TObject);
var
  i: integer;
  Found: Boolean;
  LookFor: string;
begin
  if fIgnore Then Exit;

  if fListBox <> nil then
    begin
      Found := False;
      ClearListView(fLV);
      Target := fSource.Text; // get search target
      if Target <> '' then
        begin
          i := 0;
          LookFor := LowerCase(Target);
          while (i < fListBox.Items.Count {- 1}) and (not Found) do
            begin
              if LowerCase(Copy(fListBox.Items[i], 1, Length(LookFor))) = LookFor then
                begin
                  fListBox.ItemIndex := i;
                  fSource.Text := fListBox.Items[i];
                  fSource.SelStart := Length(LookFor);
                  fSource.SelLength := Length(fSource.Text);
                  Found := True;
                end
              else
                inc(i);
            end;
        end;
      if not Found then  fListBox.ItemIndex := -1;
    end;

  SelectionStatus := ssInProgress;
  SetupInfo;
end;

procedure TfrmGMV_PatientSelector.cmbPeriodChange(Sender: TObject);
begin
  if fIgnore Then Exit;
  if (fSource.Text <> '') and (cmbPeriod.Text<>'') then
    lbUnitsDblClick(nil);
end;

procedure TfrmGMV_PatientSelector.cmbAllChange(Sender: TObject);
begin
  if fIgnore Then Exit;

  ClearListView(fLV);
  Target := fSource.Text; // get search target
  tmSearch.Enabled := False;
  tmSearch.Enabled := fSource.Text <> ''; // start countdouwn

  SetTimerInterval(GMVSearchDelay);
  GetParentForm(Self).Perform(CM_PTSEARCHKBMODE, 0, 0); //AAN 07/18/02

  SelectionStatus := ssInProgress;

  SetupInfo;
end;

function TfrmGMV_PatientSelector.UpdateListView(aSource:TStrings;lvItems:TListItems;
  iCaption,iSSN:Integer; iSubItems: array of Integer;aMode:Integer):Integer;
var
  s:String;
  ii,jj,
  iFound: Integer;
const
  Delim = '^';
begin
  iFound := 0;
  lvItems.BeginUpdate;
  for jj := 0 to aSource.Count - 1 do
    begin
      s := aSource[jj];
      if pos('-1',s)= 1 then Continue;
      with lvItems.Add do
        begin
          Caption := Piece(s,Delim,iCaption);
          SubItems.Add(FormatSSN(Piece(s, Delim, iSSN)));
          for ii := Low(iSubItems) to High(iSubItems) do
            SubItems.Add(Piece(s, Delim, iSubItems[ii]));
          case aMode of
            0: Data := TGMV_FileEntry.CreateFromRPC('2;' + s);// Nursing Unit
            1: Data := TGMV_FileEntry.CreateFromRPC('2;' + s);// PtWard
            2: Data := TGMV_FileEntry.CreateFromRPC('2;' + Piece(s, '^', 2) + '^' + Piece(s, '^', 1)); // Team
            3: Data := TGMV_FileEntry.CreateFromRPC('2;' + s);// Clinic
            4: Data := TGMV_FileEntry.CreateFromRPC(s);// Patients
          end;
          inc(iFound);
        end;
    end;
  lvItems.EndUpdate;
  Result := iFound;
end;

procedure TfrmGMV_PatientSelector.ClearListView(aLV: TListView);
var
  i: integer;
begin
  aLV.Items.BeginUpdate;
  for i := 0 to aLV.Items.Count - 1 do
    if aLV.Items[i].Data <> nil then
      begin
        TGMV_FileEntry(aLV.Items[i].Data).Free;
        aLV.Items[i].Data := nil;
      end;
  aLV.Items.Clear;
  aLV.Items.EndUpdate;
//  aLV.Enabled := False;

  SetCurrentPatient;

  GetParentForm(Self).Perform(CM_NOPATIENT, 0, 0);
  GetParentForm(Self).Perform(CM_PTLISTCHANGED, 0, 0);
end;

////////////////////////////////////////////////////////////////////////////////
// lbUnitsClick, DblClick, Enter, Exit, KeyDoun methods will be used
// for all inteface elements
////////////////////////////////////////////////////////////////////////////////

procedure TfrmGMV_PatientSelector.lbUnitsClick(Sender: TObject);
begin
  try
    fSource.Text := fListBox.Items[fListBox.ItemIndex];
    if (fSource.Text <>'') and (pos(fSource.Text+#13,fSource.Items.Text)=0) then
      fSource.Items.Insert(0,fSource.Text);
    if fSource.Items.Count > 3 then
      fSource.Items.Delete(3);

    SetCurrentLocation;

    SelectionStatus := 'In progress';
    
    ClearListView(fLV);
    setUpInfo;
    SetCurrentList;
  except
  end;
end;

procedure TfrmGMV_PatientSelector.lbUnitsDblClick(Sender: TObject);
begin
  GetParentForm(Self).Perform(CM_PTSEARCHSTART, 0, 0); //AAN 07/18/02
  tmSearch.Enabled := False;
  SilentSearch;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsDblClick(Sender: TObject);
var
  s: String;
  Patient:TPatient;
begin
  SelectionStatus := '';
  with fLV do
    if Selected <> nil then
      begin
        s := TGMV_FileEntry(Selected.Data).IEN;

        Patient := SelectPatientByDFN(s);
        if Patient <> nil then
          begin
            Screen.Cursor := crHourGlass;

            fPatientID := s;
            fPatientName := Selected.Caption;
            fSelectedPatientName := fPatientName;

            if bUseLocationID then //  Wards and Clinics
              begin
                fSelectedPatientLocationName := fLocationName;
                fSelectedPatientLocationID := fLocationID;
              end
            else
              begin // Nursing Units, Teams, All
                fSelectedPatientLocationName := '';
                fSelectedPatientLocationID := '';
                if Patient.LocationName <> '' then
                  begin
                    fSelectedPatientLocationName := Patient.LocationName;
                    fSelectedPatientLocationID := Patient.LocationID;
                  end
              end;

            SelectionStatus := ssSelected;
            lblSelectedName.Caption := Patient.Name;
            lblPatientInfo.Caption := Patient.SSN + '  '+Patient.Age;

// No need in sending a message. OnPatSelect will be called instead
//            GetParentForm(Self).Perform(CM_PATIENTFOUND, 0, 0); //AAN 06/11/02
//            GetParentForm(Self).Perform(WM_NEXTDLGCTL, 0, 0);

            SelectedPatientID := fPatientID; // Assignment will invoke OnPatSelect

            Screen.Cursor := crDefault;
            FreeAndNil(Patient);
          end //AAN 06/11/02
        else
          Selected := nil;
      end
    else
      begin
        fPatientID := '';
        fPatientName := '';

        fSelectedPatientName := fPatientName;
        fSelectedPatientID := fPatientID;
        fSelectedPatientLocationName := fLocationName;
        fSelectedPatientLocationID := fLocationID;
      end;
   SetUpInfo;
end;

procedure TfrmGMV_PatientSelector.SpeedButton1Click(Sender: TObject);
begin
  pnlInfo.Visible := not pnlInfo.Visible;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    char(VK_RETURN): if fLV.SelCount = 1 then lvUnitPatientsDblClick(Sender);
  else
  end;
end;

procedure TfrmGMV_PatientSelector.lbUnitsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN: if (fListBox.ItemIndex > - 1) then lbUnitsDblClick(Sender);
  else
  end;
end;

procedure TfrmGMV_PatientSelector.cmbUnitKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  with fSource do
    case Key of
     VK_RETURN:
      if (fListBox.ItemIndex > -1) then
        begin
          Key := 0;
          lbUnitsClick(nil);
          lbUnitsDblClick(Sender);
        end;
     VK_Back:
        if (SelLength > 0) then
          begin
            fIgnore := True;
            Text := Copy(Text, 1, SelStart - 1);
            Key := 0;
            fIgnore := False;
          end;
{
     VK_DOWN:
       if fListBox.ItemIndex < fListBox.Items.Count - 1 then
         begin
           fListBox.ItemIndex := fListBox.ItemIndex + 1;
         end;
     VK_UP:
       if fListBox.ItemIndex > 0 then
         begin
           fListBox.ItemIndex := fListBox.ItemIndex - 1;
         end;
}
    end;
end;

procedure TfrmGMV_PatientSelector.cmbUnitEnter(Sender: TObject);
begin
  fSource.Color := clTabIn;
end;

procedure TfrmGMV_PatientSelector.cmbUnitExit(Sender: TObject);
begin
  fSource.Color := clTabOut;
end;

procedure TfrmGMV_PatientSelector.lbUnitsEnter(Sender: TObject);
begin
  fListBox.Color := clTabIn;
end;

procedure TfrmGMV_PatientSelector.lbUnitsExit(Sender: TObject);
begin
  fListBox.Color := clTabOut;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsEnter(Sender: TObject);
begin
  fLV.Color := clTabIn;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsExit(Sender: TObject);
begin
  fLV.Color := clTabOut;
end;

procedure TfrmGMV_PatientSelector.cmbPeriodEnter(Sender: TObject);
begin
  cmbPeriod.Color := clTabIn;
end;

procedure TfrmGMV_PatientSelector.cmbPeriodExit(Sender: TObject);
begin
  cmbPeriod.Color := clTabOut;
end;

procedure TfrmGMV_PatientSelector.lvAllPatientsKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    char(VK_RETURN): if fLV.SelCount = 1 then lvUnitPatientsDblClick(Sender);
  end;
end;

procedure TfrmGMV_PatientSelector.cmbAllKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    char(VK_RETURN): Search;
  else
  end;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  SetCurrentPatient;
  SelectionStatus := ssInProgress;
  SetUpInfo;
  GetParentForm(Self).Perform(CM_PTLISTCHANGED, fLV.Items.Count, 0); 
end;

procedure TfrmGMV_PatientSelector.SetCurrentPatient;
begin
  if fLV.Selected <> nil then
    begin
      try
        fPatientID := TGMV_FileEntry(fLV.Selected.Data).IEN;
        fPatientName := fLV.Selected.Caption;
      except
        fPatientID := '';
        fPatientName := '';
      end;
    end
  else
    begin
      fPatientID := '';
      fPatientName := '';
    end;
end;

procedure TfrmGMV_PatientSelector.SetCurrentLocation;
begin
  try
    fLocationID := TGMV_FileEntry(fListBox.Items.Objects[fListBox.ItemIndex]).IEN;
    fLocationCaption := TGMV_FileEntry(fListBox.Items.Objects[fListBox.ItemIndex]).Caption;
    fLocationName := fListBox.Items[fListBox.ItemIndex];
  except
    fLocationID := '';
    fLocationCaption := '';
    fLocationName := '';
  end;

  if bUseLocationID then
    begin
      fPatientLocationName := fLocationName;
      fPatientLocationID := fLocationID;
    end
  else
    begin
      fPatientLocationName := '';
      fPatientLocationID := '';
    end;
end;

procedure TfrmGMV_PatientSelector.lvUnitPatientsClick(Sender: TObject);
begin
  SelectionStatus := ssInProgress;
  SetCurrentList;
  SetupInfo;
end;

function TfrmGMV_PatientSelector.getSelectCount:Integer;
begin
  Result := fLV.SelCount;
end;

procedure TfrmGMV_PatientSelector.pnlPtInfoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    pnlPtInfo.BevelOuter := bvLowered;
end;

procedure TfrmGMV_PatientSelector.pnlPtInfoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPtInfo.BevelOuter := bvRaised;
  if SelectionStatus = ssSelected then
    ShowPatientInfo(SelectedPatientID)
  else
    MessageDlg('Select Patient first.', mtInformation,[mbOk], 0);
end;

function TfrmGMV_PatientSelector.getFocusedPatientID:String;
begin
  Result := '';
  if Assigned(fLV) and (fLV.Items.Count > 0) then
  try
    Result :=  TGMV_FileEntry(fLV.Items[fLV.ItemIndex].Data).IEN;
  except
  end;
end;

end.

