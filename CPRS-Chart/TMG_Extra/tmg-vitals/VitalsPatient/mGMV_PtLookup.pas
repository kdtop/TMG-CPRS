unit mGMV_PtLookup;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 1/04/05 5:56p $
*       Developer:    david.sansom@med.va.gov/dan.petit@med.va.gov
*       Site:         Hines OIFO
*
*       Description:  Frame to allow multiple different ways of selecting pt's
*                     from VistA
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsPatient/mGMV_PtLookup.pas $
*
* $History: mGMV_PtLookup.pas $
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 5/24/05    Time: 4:59p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsPatient
 * 
 * *****************  Version 1  *****************
 * User: Vhaishandria Date: 4/16/04    Time: 4:23p
 * Created in $/Vitals/Vitals GUI Version 5.0.3 (CCOW, CPRS, Delphi 7)/VITALSPATIENT
 * 
*
================================================================================
}
interface

uses
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ImgList,
  ExtCtrls,
  StdCtrls,
  Classes,
  u_Common,
  fGMV_PtSelect,
  Buttons,
  Windows,
  Messages,
  CheckLst
  , ActnList
  ;

type
  TfraGMV_PtLookup = class(TFrame)
    tmrLookup: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    rgPtList: TRadioGroup;
    gbxListBox: TGroupBox;
    lblApptDate: TLabel;
    cbxApptDate: TComboBox;
    gbxPtList: TGroupBox;
    Panel3: TPanel;
    lvPatients: TListView;
    edPattern: TEdit;
    pnDropList: TPanel;
    Panel6: TPanel;
    lbDropDown: TListBox;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    ActionList1: TActionList;
    acSearchPatient2: TAction;
    Bevel1: TBevel;
    Bevel2: TBevel;
    acPatientsListChanged: TAction;
    procedure SelectListType(Sender: TObject);
//    procedure TimeOption(var ExDate, InDate: string; RPCBroker: TRPCBroker);
    procedure tmrLookupTimer(Sender: TObject);
    procedure lvPatientsDblClick(Sender: TObject);
    procedure lvPatientsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvPatientsClick(Sender: TObject);
    procedure edPatternChange(Sender: TObject);
    procedure lbDropDownClick(Sender: TObject);
    procedure edPatternKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acSearchPatient2Execute(Sender: TObject);
    procedure edPatternDblClick(Sender: TObject);
    procedure lvPatientsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvPatientsEnter(Sender: TObject);
    procedure lvPatientsExit(Sender: TObject);
    procedure lbDropDownExit(Sender: TObject);
    procedure lbDropDownEnter(Sender: TObject);
    procedure edPatternEnter(Sender: TObject);
    procedure edPatternExit(Sender: TObject);
    procedure lvPatientsKeyPress(Sender: TObject; var Key: Char);
  private
    sLastPattern:String;
    bSearchInProgress:Boolean;
    bTeamSelectionInProgress: Boolean;
    FOnPatChange: TNotifyEvent;
    FPatientIEN: string;
    procedure ClearListView;
    procedure SetOnPatChange(const Value: TNotifyEvent);
    procedure SetPatientIEN(const Value: string);
    procedure SearchPatient(_sIEN,_sListText,_sDate,_sText:String;_iListIndex,_iDateIndex:Integer);
    function ValidPatientInfo(sPTInfo:String):Boolean;
    function UpdateListView(aSource:TStrings;lvItems:TListItems;
      iCaption,iSSN:Integer; iSubItems: array of Integer;aMode:Integer):Integer;
  public
    {Public Declarations}
    bSilentSearch:Boolean;//AAN 05/21/2003 - to prevent message DLG for the first time
    iMSecondsToStart:Integer;
    sSecondsToStart:String;
    sLocationName:String;
    sLocationID:String;
    procedure SetTimerInterval(sInterval:String);
  published
    property PatientIEN: string read FPatientIEN write SetPatientIEN;
    property OnPatChange: TNotifyEvent
      read FOnPatChange write SetOnPatChange;
  end;

implementation

{$R *.DFM}
uses
  Sysutils
  ,Graphics
  , uGMV_FileEntry
  , uGMV_Const
  , uGMV_GlobalVars, uGMV_Engine
  ;

const
  clTabIn = clInfoBk;
  clTabOut = clWindow;

function formatSSN(sSSN:String):String;
var
  s: String;
begin
  s := sSSN;
  While pos(' ',s) = 1 do
    s := copy(s,2,length(s)-1);
  if pos('*S',s)=1 then
    Result := s
  else
    Result := copy(s,1,3)+'-'+copy(s,4,2)+'-'+copy(s,6,Length(s)-5);
end;

procedure TfraGMV_PtLookup.SelectListType(Sender: TObject);
begin
  bSearchInProgress := False;

  edPattern.Text := '';
  edPattern.CharCase := ecNormal;
  edPattern.Anchors := [akLeft,akRight, akTop];
  edPattern.Hint := 'Click to open dropdown list';

  lbDropDown.Clear;

  gbxListBox.Enabled := True;
  gbxListBox.Visible := True;

  cbxApptDate.Visible := (rgPtList.ItemIndex = 3);

  lblApptDate.Visible := (rgPtList.ItemIndex = 3);

  lvPatients.Columns[3].Width := 0;

  sLocationName := '';
  sLocationID := '';
  
  case rgPtList.ItemIndex of
    0: {Unit}
      begin
        gbxListBox.Caption := '&Select Nursing Unit:';
        {Check GMVNursingUnits for first time access}
        if GMVNursingUnits.Entries.Count < 1 then
          GMVNursingUnits.LoadEntries('211.4');

        lbDropDown.Items.Clear;
        lbDropDown.Items.Assign(GMVNursingUnits.Entries);
        edPattern.Width := gbxListBox.Width - (edPattern.Left * 2);//AAN 07/23/2002
      end;
    1: {Ward}
      begin
        gbxListBox.Caption := '&Select Ward Location:';
        if GMVWardLocations.Entries.Count < 1 then
          GMVWardLocations.LoadEntries('42');
        lbDropDown.Items.Clear;
        lbDropDown.Items.Assign(GMVWardLocations.Entries);
        edPattern.Width := gbxListBox.Width - (edPattern.Left * 2);//AAN 07/23/2002
      end;
    2: {Team}
      begin
        gbxListBox.Caption := '&Select Team:';
        if GMVTeams.Entries.Count < 1 then
          GMVTeams.LoadEntries('100.21');
        lbDropDown.Items.Clear;
        lbDropDown.Items.Assign(GMVTeams.Entries);
        edPattern.Width := gbxListBox.Width - (edPattern.Left * 2);//AAN 07/23/2002
      end;
    3: {Clinic}
      begin
        edPattern.Anchors := [akLeft, akTop];
        edPattern.Width := gbxListBox.Width div 2;

        gbxListBox.Caption := '&Select Clinic:';
        {Check GMVClinics for first time access}
        if GMVClinics.Entries.Count < 1 then
//          GMVClinics.LoadEntries('44');//AAN 01/22/2003 - sorting problem
          GMVClinics.LoadEntriesConverted('44');  //AAN 01/22/2003 - sorting problem

        lblApptDate.Left := edPattern.Width + (edPattern.Left * 2);

        cbxApptDate.ItemIndex := -1;
        cbxApptDate.Left := lblApptDate.Left + lblApptDate.Width + edPattern.Left;
        cbxApptDate.Width := gbxListBox.Width - cbxApptDate.Left - edPattern.Left;
        cbxApptDate.ItemIndex := 0;// AAN 07/02/2002 - to set 'Today' as default
        lbDropDown.Items.Clear;

{-- Strange issue: sorting is not working.....:-(((
        lbDropDown.Sorted := true;

        for i := 0 to GMVClinics.Entries.Count-1 do
          begin
            s := '';
            for k := 1 to Length(GMVClinics.Entries[i]) do
              if pos(copy(GMVClinics.Entries[i],k,1),ALPHA) <>0 then
                S := s + ' '
              else
                s := s + copy(GMVClinics.Entries[i],k,1);
            lbDropDown.Items.Add(s);
          end;
}
        lbDropDown.Items.Assign(GMVClinics.Entries);
        lvPatients.Columns[3].Width := 80;
      end;
    4: {All}
      begin
        gbxListBox.Caption := 'Patient Name (Last, First or Last 4 SSN)';
        edPattern.Hint := 'Enter Patient Name or SSN';
        edPattern.Width := gbxListBox.Width - (edPattern.Left * 2);//AAN 07/23/2002
        edPattern.CharCase := ecUpperCase;

        pnDropList.Visible := False;
      end;
  else
    MessageDlg('Internal Error - No such option', mtError, [mbok], 0);
  end;

//  for i := 0 to lbDropDown.Items.Count - 1 do
//    lbDropDown.Items[i] := UpperCase(lbDropDown.Items[i]);
  ClearListView;
  edPattern.SetFocus;
  if rgPtList.ItemIndex <> 4 then
    pnDropList.Visible := True;

  lvPatientsClick(nil);
end;

procedure TfraGMV_PtLookup.SetOnPatChange(const Value: TNotifyEvent);
begin
  FOnPatChange := Value;
end;

procedure TfraGMV_PtLookup.SetPatientIEN(const Value: string);
begin
  if Value = FPatientIEN then Exit;
  FPatientIEN := Value;
  if Assigned(FOnPatChange) then
    FOnPatChange(Self)
  else
    MessageDLG('OnPatChange is not assigned', mtInformation,[mbOK],0);
end;

procedure TfraGMV_PtLookup.tmrLookupTimer(Sender: TObject);
var
  i: integer;
  RetList :TStrings;
begin
  if iMSecondsToStart >= 500 then
    begin
      iMSecondsToStart := iMSecondsToStart - 500;
      sSecondsToStart := Format('%3.1n',[iMSecondsToStart/1000.0]);
      GetParentForm(Self).Perform(CM_PTSEARCHDelay, 0, 0); //AAN 07/22/02
      exit;
    end;

  tmrLookup.Enabled := False;

  if edPattern.Text = '' then exit;

  GetParentForm(Self).Perform(CM_PTSEARCHING, 0, 0); //AAN 07/22/02

  lvPatients.Enabled := False;
  Application.ProcessMessages;

//  RetList := TStringList.Create;
//  CallRemoteProc(RPCBroker, 'GMV PTSELECT', ['PTLKUP', '', edPattern.Text], nil, [rpcSilent,rpcNoResChk], RetList);
  RetList := getPatientList(edpattern.Text);
  if Piece(RetList[0], '^', 1) = '-1' then
    begin
      GetParentForm(Self).Perform(CM_PTLISTNOTFOUND, 0, 0); //AAN 07/22/02
      MessageDlg(Piece(RetList[0], '^', 2), mtInformation, [mbok], 0);
      ClearListView;
    end
  else
    begin
      ClearListView;

      lvPatients.Items.BeginUpdate;
      for i := 1 to RetList.Count - 1 do
        if ValidPatientInfo(RetList[i]) then
        with lvPatients.Items.Add do
          begin
            Caption := Piece(RetList[i], '^', 2);
            SubItems.Add(FormatSSN(Piece(RetList[i], '^', 11)));
            SubItems.Add(Piece(RetList[i], '^', 10));
            Data := TGMV_FileEntry.CreateFromRPC(RetList[i]);
          end;
      GetParentForm(Self).Perform(CM_PTLISTCHANGED, RetList.Count, 0); //AAN 08/30/02
      lvPatients.Items.EndUpdate;

    end;
  RetList.Free;

  if lvPatients.Items.Count > 0 then
    begin
      lvPatients.Enabled := True;
      lvPatients.Selected := lvPatients.Items[0];
      lvPatients.SetFocus;
    end;

  GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0); //AAN 07/22/02
end;

procedure TfraGMV_PtLookup.lvPatientsClick(Sender: TObject);
begin
  PatientIEN := '';
  GetParentForm(Self).Perform(CM_NOPATIENT, 0, 0) //AAN 06/11/02
end;

procedure TfraGMV_PtLookup.lvPatientsDblClick(Sender: TObject);
begin
  with lvPatients do
    if Selected <> nil then
      begin
//        if PatientSelect(RPCBroker, TGMV_FileEntry(Selected.Data).IEN) then
        if PatientSelectByDFN(TGMV_FileEntry(Selected.Data).IEN) then
          begin //AAN 06/11/02
            Screen.Cursor := crHourGlass;
            PatientIEN := TGMV_FileEntry(Selected.Data).IEN;
            GetParentForm(Self).Perform(CM_PATIENTFOUND, 0, 0); //AAN 06/11/02
            GetParentForm(Self).Perform(WM_NEXTDLGCTL, 0, 0);
            Screen.Cursor := crDefault;
          end //AAN 06/11/02
        else
          Selected := nil;

      end
    else
      PatientIEN := ''
end;

procedure TfraGMV_PtLookup.lvPatientsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_Up, VK_Down:
      begin
        lvPatientsClick(nil);
      end;
  else
  end;
end;

procedure TfraGMV_PtLookup.ClearListView;
var
  i: integer;
begin
  PatientIEN := '';

  lvPatients.Items.BeginUpdate;
  for i := 0 to lvPatients.Items.Count - 1 do
    if lvPatients.Items[i].Data <> nil then
      begin
        TGMV_FileEntry(lvPatients.Items[i].Data).Free;
        lvPatients.Items[i].Data := nil;
      end;
  lvPatients.Items.Clear;
  lvPatients.Items.EndUpdate;

  GetParentForm(Self).Perform(CM_NOPATIENT, 0, 0); //AAN 06/11/02
  GetParentForm(Self).Perform(CM_PTLISTCHANGED, 0, 0); //AAN 08/30/02

  lvPatients.TabStop := False;
end;

function TfraGMV_PtLookup.UpdateListView(aSource:TStrings;lvItems:TListItems;
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
          end;
          inc(iFound);
        end;
    end;
  lvItems.EndUpdate;
  Result := iFound;
end;

function TfraGMV_PtLookup.ValidPatientInfo(sPTInfo:String):Boolean;
var
  s: String;
begin
  s := Piece(sPTInfo, '^', 2);
  Result := (Trim(s)<>'');
end;

procedure TfraGMV_PtLookup.SearchPatient(_sIEN,_sListText,_sDate,_sText:String;_iListIndex,_iDateIndex:Integer);
var
// --------------------------------Variables added to check parameter passing...
  sIEN,
  sListText,
  sText,
  sDate : String;
  iListIndex,
  iDateIndex,
  iFoundPtCount: Integer;
//------------------------------------------------------------------------------
  RetList: TStrings;

  procedure ReportFoundItems(aCount:Integer;aMessage:String);
  begin
    if aCount = 0 then
      MessageDlg(aMessage, mtInformation, [mbok], 0)
    else
      begin
        pnDropList.Visible := False;
        GetParentForm(Self).Perform(WM_NEXTDLGCTL, 0, 0);
      end;
  end;

begin
  if bSearchInProgress then Exit;
  bSearchInProgress := True;

  sText := _sText;
  sDate := _sDate;
  sIEN := _sIEN;
  sListText := _sListText;
  iListIndex := _iListIndex;
  iDateIndex := _iDateIndex;

  ClearListView;

  case rgPtList.ItemIndex of
    0..3:
      if (iListIndex < 0) or bTeamSelectionInProgress then
        exit;
    4: begin
      tmrLookup.Enabled := False;
      tmrLookup.Enabled := (sText <> '');//AAN 07/18/2002
      Exit;
      end;
  end;
//  RetList := TStringList.Create;

  lvPatients.Columns[3].Width := 0;
  case rgPtList.ItemIndex of
    0: {New nursing unit selected}
      begin
//        CallRemoteProc(RPCBroker, 'GMV NUR UNIT PT', [sIEN], nil, [rpcNoResChk,rpcSilent],RetList);
        RetList := getNursingUnitPatients(sIEN);
        GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0); //AAN 07/18/02
        if RetList.Count < 1 then
            MessageDlg('No patients found for nursing unit <'+sText+'>', mtInformation, [mbok], 0)//AAN 07/22/2002
        else
          begin
            iFoundPtCount := UpdateListView(RetList,lvPatients.Items,2,3,[4],0);
            ReportFoundItems(iFoundPtCount,'No patients found for nursing unit <'+sText+'>');
          end;
      end;
    1: {New ward location selected}
      begin
//        CallRemoteProc(RPCBroker, 'GMV WARD PT', [sText], nil, [rpcNoResChk,rpcSilent], RetList);//AAN 07/23/2002
        RetList := getWardPatients(sText);
        GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0); //AAN 07/18/02
        if RetList.Count < 1 then
            MessageDlg('No patients found for the ward <'+sText+'>.', mtInformation, [mbok], 0)
        else
          begin
            iFoundPtCount := UpdateListView(RetList,lvPatients.Items,2,3,[4],1);
            ReportFoundItems(iFoundPtCount,'No patients found for the ward <'+sText+'>.');
          end;
      end;
    2: {New Team Selected}
      begin
//        CallRemoteProc(RPCBroker, 'GMV TEAM PATIENTS', [sIEN], nil, [rpcNoResChk,rpcSilent],RetList);
        RetList := getTeampatients(sIEN);
        GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0); //AAN 07/18/02
        if RetList.Count < 1 then
          MessageDlg('No patients found for the team <'+sListText+'>.', mtInformation, [mbok], 0) //AAN 07/18/2002
        else if RetList[0] = 'NO PATIENTS' then
          MessageDlg('No patients found for the team  <'+sListText+'>.', mtInformation, [mbok], 0)
        else
          begin
            iFoundPtCount := UpdateListView(RetList,lvPatients.Items,1,3,[4],2);
            ReportFoundItems(iFoundPtCount,'No patients found for the team <'+sListText+'>');
          end;
      end;
    3: {New clinic selected}
      begin
        if (iListIndex > -1) and (iDateIndex > -1) then
          begin
//            CallRemoteProc(RPCBroker, 'GMV CLINIC PT', [sText, sDate], nil, [rpcNoResChk,rpcSilent], RetList);
            RetList := getClinicPatients(sText,sDate);
            GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0); //AAN 07/18/02
            if  (RetList.Count < 1) then
                MessageDlg('No patient appointments found for:'+#13+     //AAN 07/22/2002
                          'Clinic: <'+ sText+'>'+ #13+           //AAN 07/22/2002
                          'Date: <'+sDate+'>', mtInformation, [mbok], 0) //AAN 07/22/2002
            else if pos('No patient',RetList[0]) <> 0 then
                if bSilentSearch then //AAN 05/21/2003 - to prevent message DLG for the first time
                    bSilentSearch := False//AAN 05/21/2003 - to prevent message DLG for the first time
                else                  //AAN 05/21/2003 - to prevent message DLG for the first time
                MessageDlg('No patient appointments found for:'+#13+     //AAN 07/22/2002
                          'Clinic: <'+ sText+'>'+ #13+           //AAN 07/22/2002
                          'Date: <'+sDate+'>', mtInformation, [mbok], 0) //AAN 07/22/2002

            else if pos('No clinic',RetList[0]) <> 0 then
                MessageDlg('Check the clinic value:'+#13+     //AAN 07/22/2002
                          'Clinic: <'+ sText+'>'+ #13+           //AAN 07/22/2002
                          'Date: <'+sDate+'>', mtInformation, [mbok], 0) //AAN 07/22/2002
            else
              begin
                iFoundPtCount := UpdateListView(RetList,lvPatients.Items,2,5,[6,4],3);
                if iFoundPtCount = 0 then
                  MessageDlg('No patient appointments found for:'+#13+     //AAN 07/22/2002
                            'Clinic: <'+ sText+'>'+ #13+           //AAN 07/22/2002
                            'Date: <'+sDate+'>', mtInformation, [mbok], 0) //AAN 07/22/2002
                else
                  begin
                    pnDropList.Visible := False;
                    lvPatients.ItemFocused := lvPatients.Items[0];
//                    GetParentForm(Self).Perform(WM_NEXTDLGCTL, 0, 0);
                    GetParentForm(Self).Perform(CM_SELECTPTLIST, 0, 0);
                  end;
              end;
          end;
      end;
  else
    MessageDlg('Internal Error - No List Selected', mtError, [mbok], 0);
  end;
  if Assigned(RetList) then
    RetList.Free;
end;

procedure TfraGMV_PtLookup.edPatternChange(Sender: TObject);
var
  i: Integer;
  S: String;
begin
  for i := 0 to lbDropDown.Items.Count - 1 do
    begin
      s := lbDropDown.Items[i];
{
      ss := UpperCase(edPattern.Text);
      sTarget := '';
      for k := 1 to length(ss) do
        if pos(copy(ss,k,1),ALPHA) = 0 then
          sTarget := sTarget + ' '
        else
          sTarget := sTarget +copy(ss,k,1);

      ss := UpperCase(s);
      sPattern := '';
      for k := 1 to length(ss) do
        if pos(copy(ss,k,1),ALPHA) = 0 then
          sPattern := sPattern + ' '
        else
          sPattern := sPattern +copy(ss,k,1);

      if sTarget <= sPattern then
        begin
          ShowMessage(sTarget +' <= '+sPattern);
          break;
        end

}
      if UpperCase(edPattern.Text) <= UpperCase(s) then  Break;
    end;

  if i = lbDropDown.Items.Count then  i := lbDropDown.Items.Count-1;
  lbDropDown.TopIndex := i;
  lbDropDown.ItemIndex := i;

  if (rgPTList.ItemIndex = 4) then
    if (edPattern.Text <>'') then
      begin
        tmrLookup.Enabled := False;
        tmrLookup.Enabled := True;
        SetTimerInterval(GMVSearchDelay);
        GetParentForm(Self).Perform(CM_PTSEARCHKBMODE, 0, 0); //AAN 07/18/02
      end
    else
      begin
        tmrLookup.Enabled := False;
        GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0); //AAN 07/18/02
      end;
end;

procedure TfraGMV_PtLookup.lbDropDownClick(Sender: TObject);
begin
  edPattern.Text := lbDropDown.Items[lbDropDown.ItemIndex];
  
  sLocationName := edPattern.Text;
  sLocationID := TGMV_FileEntry(lbDropDown.Items.Objects[lbDropDown.ItemIndex]).IEN;
end;

procedure TfraGMV_PtLookup.edPatternKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s,ss:String;
begin
  if not pnDropList.Visible and (rgPTList.ItemIndex<>4) then
    pnDropList.Visible:= True;

  case Key of
    VK_ESCAPE:
      begin
        bTeamSelectionInProgress := False;
        GetParentForm(Self).Perform(CM_PTSEARCHDONE, 0, 0);
        pnDropList.Visible := False;
        edPattern.Text := sLastPattern;
      end;
    VK_RETURN:
      begin
        if (lbDropDown.ItemIndex < 0) and (rgPTList.ItemIndex<>4)then
          begin
            if lbDropDown.Items.Count > 0 then
              MessageDlg('Type search target or'+#13+'Select target from the List',mtWarning,[mbOK],0);
            Exit;
          end;

        if (rgPTList.ItemIndex<>4) and
          (UpperCase(edPattern.Text) <> UpperCase(lbDropDown.Items[lbDropDown.ItemIndex])) then
          edPattern.Text := lbDropDown.Items[lbDropDown.ItemIndex]
        else if (edPattern.Text <>'') then
          begin
            iMSecondsToStart := 0; //AAN 08/28/2002
            GetParentForm(Self).Perform(CM_PTSEARCHSTART, 0, 0); //AAN 07/18/02
          end;
       acSearchPatient2Execute(Sender);
      end;
    VK_UP:
      begin
        if Sender = lbDropDown then Exit;
        if rgPTList.ItemIndex =4 then Exit; //AAN 08/02/2002

        GetParentForm(Self).Perform(CM_PTSEARCHKBMODE, 0, 0); //AAN 07/18/02
        try
          if lbDropDown.ItemIndex > 0 then
            lbDropDown.ItemIndex := lbDropDown.ItemIndex - 1;
//          if  edPattern.Text <> lbDropDown.Items[lbDropDown.ItemIndex] then
          s :=UpperCase(edPattern.Text);
          ss :=UpperCase(lbDropDown.Items[lbDropDown.ItemIndex]);
          if S <> SS then
            edPattern.Text := lbDropDown.Items[lbDropDown.ItemIndex];
        except
        end;
      end;
    VK_DOWN:
      begin
        if Sender = lbDropDown then Exit;
        if rgPTList.ItemIndex =4 then Exit; //AAN 08/02/2002

        GetParentForm(Self).Perform(CM_PTSEARCHKBMODE, 0, 0); //AAN 07/18/02
        try
          if lbDropDown.ItemIndex < lbDropDown.Items.Count - 1 then
            lbDropDown.ItemIndex := lbDropDown.ItemIndex + 1;
          s :=UpperCase(edPattern.Text);
          ss :=UpperCase(lbDropDown.Items[lbDropDown.ItemIndex]);
          if S <> SS then
            edPattern.Text := lbDropDown.Items[lbDropDown.ItemIndex];
        except
        end;
      end;
  else
      begin
      end;
  end;
end;

procedure TfraGMV_PtLookup.acSearchPatient2Execute(Sender: TObject);
begin
  sLastPattern := edPattern.Text;
  if (rgPTList.ItemIndex<>4) then
      SearchPatient(
            TGMV_FileEntry(lbDropDown.Items.Objects[lbDropDown.ItemIndex]).IEN,
            lbDropDown.Items[lbDropDown.ItemIndex],
            cbxApptDate.Text,
            TGMV_FileEntry(lbDropDown.Items.Objects[lbDropDown.ItemIndex]).Caption,//AAN 01/22/2002 - sorting problem
            lbDropDown.ItemIndex,
            cbxApptDate.ItemIndex
      )
  else
      SearchPatient(
            '',
            '',
            cbxApptDate.Text,
            edPattern.Text,
            lbDropDown.ItemIndex,
            cbxApptDate.ItemIndex
      );
  bSearchInProgress := False;
end;

procedure TfraGMV_PtLookup.edPatternDblClick(Sender: TObject);
begin
  if not pnDropList.Visible and (rgPTList.ItemIndex<>4) then
      pnDropList.Visible:= True;
end;

procedure TfraGMV_PtLookup.SetTimerInterval(sInterval:String);
begin
  sSecondsToStart := sInterval;
  iMSecondsToStart := round(StrToFloat(GMVSearchDelay)*1000.0);
end;

procedure TfraGMV_PtLookup.lvPatientsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  lvPatients.TabStop := lvPatients.Items.Count > 0;
  GetParentForm(Self).Perform(CM_PTLISTCHANGED, lvPatients.Items.Count, 0); //AAN 07/18/02
end;

procedure TfraGMV_PtLookup.lvPatientsEnter(Sender: TObject);
begin
  lvPatients.Color := clTabIn;
end;

procedure TfraGMV_PtLookup.lvPatientsExit(Sender: TObject);
begin
  lvPatients.Color := clTabOut;
end;

procedure TfraGMV_PtLookup.lbDropDownExit(Sender: TObject);
begin
  lbDropDown.Color := clTabOut;
end;

procedure TfraGMV_PtLookup.lbDropDownEnter(Sender: TObject);
begin
  lbDropDown.Color := clTabIn;
end;

procedure TfraGMV_PtLookup.edPatternEnter(Sender: TObject);
begin
  edPattern.Color := clTabIn;
end;

procedure TfraGMV_PtLookup.edPatternExit(Sender: TObject);
begin
  edPattern.Color := clTabOut;
end;

procedure TfraGMV_PtLookup.lvPatientsKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    char(13): if lvPatients.SelCount = 1 then lvPatientsDblClick(Sender);
  else
  end;
end;


{
procedure TfraGMV_PtLookup.TimeOption(var ExDate, InDate: string; RPCBroker: TRPCBroker);
begin
  with RPCBroker do
    begin
      RemoteProcedure := 'GMV CONVERT DATE';
      Results.Clear;
      Param[0].Value := ExDate;
      Param[0].PType := literal;
      Call;
      if (Results.Count > 0) then
        begin
          ExDate := Piece(RPCBroker.Results[0], '^', 2);
          InDate := Piece(RPCBroker.Results[0], '^', 1);
        end;
    end;
end;
}
end.

