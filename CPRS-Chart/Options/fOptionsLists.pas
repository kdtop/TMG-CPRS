unit fOptionsLists;

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

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, OrFn, Menus, fBase508Form,
  VA508AccessibilityManager
  ,Registry   //kt added
  ;

type
  TfrmOptionsLists = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lblAddby: TLabel;
    lblPatientsAdd: TLabel;
    lblPersonalPatientList: TLabel;
    lblPersonalLists: TLabel;
    lstAddBy: TORComboBox;
    btnPersonalPatientRA: TButton;
    btnPersonalPatientR: TButton;
    lstListPats: TORListBox;
    lstPersonalPatients: TORListBox;
    btnListAddAll: TButton;
    btnNewList: TButton;
    btnDeleteList: TButton;
    lstPersonalLists: TORListBox;
    radAddByType: TRadioGroup;
    btnListSaveChanges: TButton;
    btnListAdd: TButton;
    lblInfo: TMemo;
    bvlBottom: TBevel;
    mnuPopPatient: TPopupMenu;
    mnuPatientID: TMenuItem;
    grpVisibility: TRadioGroup;
    btnAddCurPt: TButton;
    btnExportList: TButton;
    btnPerExport: TButton;
    procedure btnPerExportClick(Sender: TObject);
    procedure btnExportListClick(Sender: TObject);
    procedure btnAddCurPtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNewListClick(Sender: TObject);
    procedure radAddByTypeClick(Sender: TObject);
    procedure lstPersonalListsChange(Sender: TObject);
    procedure lstAddByClick(Sender: TObject);
    procedure btnDeleteListClick(Sender: TObject);
    procedure btnListSaveChangesClick(Sender: TObject);
    procedure btnPersonalPatientRAClick(Sender: TObject);
    procedure btnListAddAllClick(Sender: TObject);
    procedure btnPersonalPatientRClick(Sender: TObject);
    procedure lstPersonalPatientsChange(Sender: TObject);
    procedure btnListAddClick(Sender: TObject);
    procedure lstListPatsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstAddByNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure mnuPatientIDClick(Sender: TObject);
    procedure lstListPatsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lstPersonalPatientsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lstAddByKeyPress(Sender: TObject; var Key: Char);
    procedure grpVisibilityClick(Sender: TObject);
    procedure lstAddByChange(Sender: TObject);
  private
    { Private declarations }
    FLastList: integer;
    FChanging: boolean;
    procedure AddIfUnique(entry: string; aList: TORListBox);
    procedure ExportList(List: string); //kt added
  public
    { Public declarations }
  end;

var
  frmOptionsLists: TfrmOptionsLists;

procedure DialogOptionsLists(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

uses fOptionsNewList, rOptions, uOptions, rCore, fPtSelOptns, VAUtils
   ,uCore  //kt added
   ,FileCtrl   //kt added
   ,ORNet  //kt added
   ;

{$R *.DFM}

const
  LIST_ADD = 1;
  LIST_PERSONAL = 2;

procedure DialogOptionsLists(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsLists: TfrmOptionsLists;
begin
  frmOptionsLists := TfrmOptionsLists.Create(Application);
  actiontype := 0;
  try
    with frmOptionsLists do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsLists);
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsLists.Release;
  end;
end;

procedure TfrmOptionsLists.FormCreate(Sender: TObject);
begin
  rpcGetPersonalLists(lstPersonalLists.Items);
  grpVisibility.ItemIndex := 1;
  grpVisibility.Enabled := FALSE;
  radAddByType.ItemIndex := 0;
  radAddByTypeClick(self);
  FLastList := 0;
end;

procedure TfrmOptionsLists.btnNewListClick(Sender: TObject);
var
  newlist: string;
  newlistnum: integer;
begin
  newlist := '';
  DialogOptionsNewList(Font.Size, newlist);
  newlistnum := strtointdef(Piece(newlist, '^', 1), 0);
  if newlistnum > 0 then
  begin
    with lstPersonalLists do
    begin
      Items.Add(newlist);
      SelectByIEN(newlistnum);
    end;
    lstPersonalListsChange(self);
    lstPersonalPatients.Items.Clear;
    lstPersonalPatientsChange(self);
  end;
end;

procedure TfrmOptionsLists.radAddByTypeClick(Sender: TObject);
begin
  btnExportList.Enabled := false;
  with lstAddBy do
  begin
    case radAddByType.ItemIndex of
      0: begin
           ListItemsOnly := false;
           LongList := true;
           InitLongList('');
           lblAddby.Caption := 'Patient:';
         end;
      1: begin
           ListItemsOnly := false;
           LongList := false;
           ListWardAll(lstAddBy.Items);
           lblAddby.Caption := 'Ward:';
         end;
      2: begin
           ListItemsOnly := true;
           LongList := true;
           InitLongList('');
           lblAddby.Caption := 'Clinic:';
         end;
      3: begin
           ListItemsOnly := true;
           LongList := true;
           InitLongList('');
           lblAddby.Caption := 'Provider:';
         end;
      4: begin
           ListItemsOnly := false;
           LongList := false;
           ListSpecialtyAll(lstAddBy.Items);
           lblAddby.Caption := 'Specialty:';
         end;
      5: begin
           ListItemsOnly := false;
           LongList := false;
           ListTeamAll(lstAddBy.Items);
           lblAddby.Caption := 'List:';
         end;
    end;
    lstAddby.Caption := lblAddby.Caption;
    ItemIndex := -1;
    Text := '';
  end;
    lstListPats.Items.Clear;
    lstListPatsChange(self);
end;

procedure TfrmOptionsLists.AddIfUnique(entry: string; aList: TORListBox);
var
  i: integer;
  ien: string;
  inlist: boolean;
begin
  ien := Piece(entry, '^', 1);
  inlist := false;
  with aList do
  for i := 0 to Items.Count - 1 do
    if ien = Piece(Items[i], '^', 1) then
    begin
      inlist := true;
      break;
    end;
  if not inlist then
    aList.Items.Add(entry);
end;

procedure TfrmOptionsLists.lstPersonalListsChange(Sender: TObject);
var
  x: integer;
begin
  if (btnListSaveChanges.Enabled) and (not FChanging) then
  begin
    if InfoBox('Do you want to save changes to '
        + Piece(lstPersonalLists.Items[FLastList], '^', 2) + '?',
        'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
      btnListSaveChangesClick(self);
  end;
  if lstPersonalLists.ItemIndex > -1 then FLastList := lstPersonalLists.ItemIndex;
  lstPersonalPatients.Items.Clear;
  btnDeleteList.Enabled := lstPersonalLists.ItemIndex > -1;
  btnAddCurPt.Enabled := btnDeleteList.Enabled;     //kt
  btnPerExport.Enabled := btnDeleteList.Enabled;   //kt
  with lstPersonalLists do
  begin
    if (ItemIndex < 0) or (Items.Count <1) then
    begin
      btnListAdd.Enabled := false;
      btnListAddAll.Enabled := false;
      btnPersonalPatientR.Enabled := false;
      btnPersonalPatientRA.Enabled := false;
      btnListSaveChanges.Enabled := false;
      grpVisibility.Enabled := False;
      exit;
    end;
    ListPtByTeam(lstPersonalPatients.Items, strtointdef(Piece(Items[ItemIndex], '^', 1), 0));
    grpVisibility.Enabled := TRUE;
    FChanging := True;
    x := StrToIntDef(Piece(Items[ItemIndex], '^', 9), 1);
    if x = 2 then x := 1;
    grpVisibility.ItemIndex := x;
    FChanging := False;
    btnDeleteList.Enabled := true;
  end;
  if lstPersonalPatients.Items.Count = 1 then         // avoid selecting '^No patients found.' msg
    if Piece(lstPersonalPatients.Items[0], '^', 1) = '' then
    begin
      btnPersonalPatientR.Enabled := false;
      btnPersonalPatientRA.Enabled := false;
      exit;
    end;
  btnPersonalPatientR.Enabled := lstPersonalPatients.SelCount > 0;
  btnPersonalPatientRA.Enabled := lstPersonalPatients.Items.Count > 0;
  btnListSaveChanges.Enabled := false;
end;

procedure TfrmOptionsLists.lstAddByChange(Sender: TObject);
  procedure ShowMatchingPatients;
  begin
    with lstAddBy do begin
      if ShortCount > 0 then begin
        if ShortCount = 1 then begin
          ItemIndex := 0;
        end;
        Items.Add(LLS_LINE);
        Items.Add(LLS_SPACE);
      end;
      InitLongList('');
    end;
  end;

begin
  inherited;
  if radAddByType.ItemIndex = 0 {patient} then begin
    with lstAddBy do
    if frmPtSelOptns.IsLast5(Text) then begin
        ListPtByLast5(Items, Text);
        ShowMatchingPatients;
      end
    else if frmPtSelOptns.IsFullSSN(Text) then begin
        ListPtByFullSSN(Items, Text);
        ShowMatchingPatients;
    end;
  end;
end;


procedure TfrmOptionsLists.lstAddByClick(Sender: TObject);
var
  ien: string;
  visitstart, visitstop, i: integer;
  visittoday, visitbegin, visitend: TFMDateTime;
  aList: TStringList;
  PtRec: TPtIDInfo;
begin
  if lstAddBy.ItemIndex < 0 then exit;
  ien := Piece(lstAddBy.Items[lstAddBy.ItemIndex], '^', 1);
  If ien = '' then exit;
  case radAddByType.ItemIndex of
    0:
    begin
      PtRec := GetPtIDInfo(ien);
      lblAddBy.Caption := 'Patient:   SSN: ' + PtRec.SSN;
      lstAddby.Caption := lblAddby.Caption;
      AddIfUnique(lstAddBy.Items[lstAddBy.ItemIndex], lstListPats);
    end;
    1:
    begin
      ListPtByWard(lstListPats.Items, strtointdef(ien,0));
    end;
    2:
    begin
      rpcGetApptUserDays(visitstart, visitstop);   // use user's date range for appointments
      visittoday := FMToday;
      visitbegin := FMDateTimeOffsetBy(visittoday, LowerOf(visitstart, visitstop));
      visitend := FMDateTimeOffsetBy(visittoday, HigherOf(visitstart, visitstop));
      aList := TStringList.Create;
      ListPtByClinic(lstListPats.Items, strtointdef(ien, 0), floattostr(visitbegin), floattostr(visitend));
      for i := 0 to aList.Count - 1 do
        AddIfUnique(aList[i], lstListPats);
      aList.Free;
    end;
    3:
    begin
      ListPtByProvider(lstListPats.Items, strtoint64def(ien,0));
    end;
    4:
    begin
      ListPtBySpecialty(lstListPats.Items, strtointdef(ien,0));
    end;
    5:
    begin
      ListPtByTeam(lstListPats.Items, strtointdef(ien,0));
    end;
  end;
  if lstListPats.Items.Count = 1 then         // avoid selecting '^No patients found.' msg
    if Piece(lstListPats.Items[0], '^', 1) = '' then
    begin
      btnListAddAll.Enabled := false;
      btnListAdd.Enabled := false;
      exit;
    end;
  btnListAddAll.Enabled := (lstListPats.Items.Count > 0) and (lstPersonalLists.ItemIndex > -1);
  btnListAdd.Enabled := (lstListPats.SelCount > 0) and (lstPersonalLists.ItemIndex > -1);
  btnExportList.enabled := True;
end;

procedure TfrmOptionsLists.btnAddCurPtClick(Sender: TObject);
//kt added
var
  i: integer;
begin
  //if not btnListAdd.Enabled then exit;
  with lstPersonalPatients do
  begin
    if Items.Count = 1 then
      if Piece(Items[0], '^', 1) = '' then
        Items.Clear;
  end;
      AddIfUnique(patient.DFN+'^'+patient.Name+'^^^^'+patient.name, lstPersonalPatients);
  lstListPatsChange(self);
  lstPersonalPatientsChange(self);
  btnListSaveChanges.Enabled := true;
end;

procedure TfrmOptionsLists.btnDeleteListClick(Sender: TObject);
var
  oldindex: integer;
  deletemsg: string;
begin
  with lstPersonalLists do
    deletemsg := 'You have selected "' + DisplayText[ItemIndex]
      + '" to be deleted.' + CRLF + 'Are you sure you want to delete this list?';
  if InfoBox(deletemsg, 'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    btnListSaveChanges.Enabled := false;
    with lstPersonalLists do
    begin
      oldindex := ItemIndex;
      if oldindex > -1 then
      begin
        rpcDeleteList(Piece(Items[oldindex], '^', 1));
        Items.Delete(oldindex);
        btnPersonalPatientRAClick(self);
        btnListSaveChanges.Enabled := false;
      end;
      if Items.Count > 0 then
      begin
        if oldindex = 0 then
          ItemIndex := 0
        else if oldindex > (Items.Count - 1) then
          ItemIndex := Items.Count - 1
        else
          ItemIndex := oldindex;
        btnListSaveChanges.Enabled := false;
        lstPersonalListsChange(self);
      end;
    end;
  end;
end;

procedure TfrmOptionsLists.btnExportListClick(Sender: TObject);
begin
  inherited;
  ExportList(lstAddBy.Items[lstAddBy.itemindex]);
end;

procedure TfrmOptionsLists.ExportList(List: string);
//kt added entire function
    function GetDesktopFolder:string;
    var
     theReg  : TRegistry;
     KeyName : String;
    begin
     result := '';
     theReg := TRegistry.Create;
     KeyName := 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';
     if (theReg.KeyExists(KeyName)) then begin
         theReg.OpenKey(KeyName, False);
         Result := theReg.ReadString('Desktop');
         if result='' then result := theReg.ReadString('Common Desktop');
         if result='' then result := 'C:\';
     end else begin
         theReg.OpenKey(KeyName, True);
         result := 'C:\';
       end;
     theReg.Free;
    end;
var
    tslist :tstringlist;
    i : integer;
    chosenDirectory,saveFile,filename : string;
begin
  inherited;
  if List='' then exit;
  
  tslist := tstringlist.Create;

  // Ask the user to select a required directory, starting with C:
  if not SelectDirectory('Select a directory to save file.', GetDesktopFolder, chosenDirectory) then begin
    ShowMessage('A directory was not chosen.');
    exit;
  end;
  //filename := piece(lstpersonallists.Items[lstpersonallists.itemindex],'^',2);
  filename := piece(List,'^',2);
  saveFile := chosenDirectory+'\'+filename+'.csv';
  //list.Add('Patient list: '+piece(lstpersonallists.Items[lstpersonallists.itemindex],'^',2));
  //for i:=0 to lstpersonalpatients.Count - 1 do begin
  //   list.Add(' - '+piece(lstpersonalpatients.Items[i],'^',2));
  //end;

  if FileExists(saveFile) then begin
    if messagedlg('File exists at '+chosenDirectory+'. Would you like to replace this file?',mtWarning,[mbYes,mbNo],0)=mrYes then begin
      DeleteFile(saveFile);
    end else begin
      exit;
    end;
  end;
  //tCallV(list,'VEFA GET LIST REPORT',[lstpersonallists.Items[lstpersonallists.itemindex]]);
  tCallV(tslist,'VEFA GET LIST REPORT',[List]);
  tslist.SaveToFile(saveFile);
  tslist.Free;
  if FileExists(saveFile) then
    ShowMessage('File saved at: '+saveFile)
  else
    ShowMessage('File Not Saved! Ensure you have proper permission to save at this location.');
end;

procedure TfrmOptionsLists.btnListSaveChangesClick(Sender: TObject);
var
  listien: integer;
begin
  listien := strtointdef(Piece(lstPersonalLists.Items[FLastList], '^', 1), 0);
  rpcSaveListChanges(lstPersonalPatients.Items, listien, grpVisibility.ItemIndex);
  btnListSaveChanges.Enabled := false;
  rpcGetPersonalLists(lstPersonalLists.Items);
  lstPersonalLists.ItemIndex := FLastList;
  lstPersonalListsChange(Self);
  if lstPersonalPatients.CanFocus then
    lstPersonalPatients.SetFocus;
end;

procedure TfrmOptionsLists.btnPerExportClick(Sender: TObject);
begin
  inherited;
  ExportList(lstpersonallists.Items[lstpersonallists.itemindex]);
end;

procedure TfrmOptionsLists.btnPersonalPatientRAClick(Sender: TObject);
begin
  lstPersonalPatients.Items.Clear;
  btnPersonalPatientR.Enabled := lstPersonalPatients.SelCount > 0;
  btnPersonalPatientRA.Enabled := lstPersonalPatients.Items.Count > 0;
  btnListSaveChanges.Enabled := true;
end;

procedure TfrmOptionsLists.btnListAddAllClick(Sender: TObject);
var
  i: integer;
begin
  with lstPersonalPatients do
  begin
    if Items.Count = 1 then
      if Piece(Items[0], '^', 1) = '' then
        Items.Clear;
  end;
  with lstListPats do
  begin
    for i := 0 to Items.Count - 1 do
      AddIfUnique(Items[i], lstPersonalPatients);
    Items.Clear;
    lstPersonalPatientsChange(self);
    lstAddBy.ItemIndex := -1;
    btnListAddAll.Enabled := false;
    lstPersonalPatientsChange(self);
  end;
  btnListSaveChanges.Enabled := true;
end;

procedure TfrmOptionsLists.btnPersonalPatientRClick(Sender: TObject);
var
  i: integer;
begin
  if not btnPersonalPatientR.Enabled then exit;
  with lstPersonalPatients do
  for i := Items.Count - 1 downto 0 do
    if Selected[i] then
      Items.Delete(i);
  btnPersonalPatientR.Enabled := lstPersonalPatients.SelCount > 0;
  btnPersonalPatientRA.Enabled := lstPersonalPatients.Items.Count > 0;
  btnListSaveChanges.Enabled := true;
end;

procedure TfrmOptionsLists.lstPersonalPatientsChange(Sender: TObject);
begin
  if lstPersonalPatients.SelCount = 1 then         // avoid selecting '^No patients found.' msg
    if Piece(lstPersonalPatients.Items[0], '^', 1) = '' then
    begin
      btnPersonalPatientR.Enabled := false;
      btnPersonalPatientRA.Enabled := false;
      exit;
    end;
  btnPersonalPatientR.Enabled := lstPersonalPatients.SelCount > 0;
  btnPersonalPatientRA.Enabled := lstPersonalPatients.Items.Count > 0;
end;

procedure TfrmOptionsLists.btnListAddClick(Sender: TObject);
var
  i: integer;
begin
  if not btnListAdd.Enabled then exit;
  with lstPersonalPatients do
  begin
    if Items.Count = 1 then
      if Piece(Items[0], '^', 1) = '' then
        Items.Clear;
  end;
  with lstListPats do
  for i := Items.Count - 1 downto 0 do
    if Selected[i] then
    begin
      AddIfUnique(Items[i], lstPersonalPatients);
      Items.Delete(i);
    end;
  lstListPatsChange(self);
  lstPersonalPatientsChange(self);
  btnListSaveChanges.Enabled := true;
end;

procedure TfrmOptionsLists.lstListPatsChange(Sender: TObject);
begin
  if lstListPats.SelCount = 1 then         // avoid selecting '^No patients found.' msg
    if Piece(lstListPats.Items[0], '^', 1) = '' then
      exit;
  btnListAdd.Enabled := (lstListPats.SelCount > 0) and (lstPersonalLists.ItemIndex > -1);
  btnListAddAll.Enabled := (lstListPats.Items.Count > 0) and (lstPersonalLists.ItemIndex > -1);
end;

procedure TfrmOptionsLists.FormShow(Sender: TObject);
begin
  with lstPersonalLists do
    if Items.Count < 1 then
      ShowMsg('You have no personal lists. Use "New List..." to create one.')
    else
    begin
      ItemIndex := 0;
      lstPersonalListsChange(self);
    end;
end;

procedure TfrmOptionsLists.grpVisibilityClick(Sender: TObject);
begin
  inherited;
  if not FChanging then btnListSaveChanges.Enabled := True;
end;

procedure TfrmOptionsLists.lstAddByNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  with lstAddBy do
  begin
    case radAddByType.ItemIndex of
      0: begin
           Pieces := '2';
           ForDataUse(SubSetOfPatients(StartFrom, Direction));
         end;
      1: begin
           Pieces := '2';
         end;
      2: begin
           Pieces := '2';
           ForDataUse(SubSetOfClinics(StartFrom, Direction));
         end;
      3: begin
           Pieces := '2,3';
           ForDataUse(SubSetOfProviders(StartFrom, Direction));
         end;
      4: begin
           Pieces := '2';
         end;
      5: begin
           Pieces := '2';
         end;
    end;
  end;
end;

procedure TfrmOptionsLists.btnOKClick(Sender: TObject);
begin
  if btnListSaveChanges.Enabled then
  begin
    if InfoBox('Do you want to save changes to '
        + Piece(lstPersonalLists.Items[FLastList], '^', 2) + '?',
        'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
      btnListSaveChangesClick(self);
  end;
end;

procedure TfrmOptionsLists.mnuPatientIDClick(Sender: TObject);
begin
  case mnuPopPatient.Tag of
    LIST_PERSONAL: DisplayPtInfo(lstPersonalPatients.ItemID);
    LIST_ADD:      DisplayPtInfo(lstListPats.ItemID);
  end;
end;

procedure TfrmOptionsLists.lstListPatsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mnuPopPatient.AutoPopup :=      (lstListPats.Items.Count > 0)
                              and (lstListPats.ItemIndex > -1)
                              and (lstListPats.SelCount = 1)
                              and (Button = mbRight)
                              and (btnListAdd.Enabled);
  mnuPopPatient.Tag := LIST_ADD;
end;

procedure TfrmOptionsLists.lstPersonalPatientsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mnuPopPatient.AutoPopup :=      (lstPersonalPatients.Items.Count > 0)
                              and (lstPersonalPatients.ItemIndex > -1)
                              and (lstPersonalPatients.SelCount = 1)
                              and (Button = mbRight)
                              and (btnPersonalPatientR.Enabled);
  mnuPopPatient.Tag := LIST_PERSONAL;
end;

procedure TfrmOptionsLists.lstAddByKeyPress(Sender: TObject;
  var Key: Char);

  procedure ShowMatchingPatients;
  begin
    with lstAddBy do
    begin
      if ShortCount > 0 then
      begin
        if ShortCount = 1 then
        begin
          ItemIndex := 0;
        end;
        Items.Add(LLS_LINE);
        Items.Add(LLS_SPACE);
      end;
      InitLongList('');
    end;
    Key := #0; //Now that we've selected it, don't process the last keystroke!
  end;

var
  FutureText: string;
begin
  if radAddByType.ItemIndex = 0 {patient} then
  begin
    with lstAddBy do
    begin
      FutureText := Text + Key;
      if frmPtSelOptns.IsLast5(FutureText) then
        begin
          ListPtByLast5(Items, FutureText);
          ShowMatchingPatients;
        end
      else if frmPtSelOptns.IsFullSSN(FutureText) then
        begin
          ListPtByFullSSN(Items, FutureText);
          ShowMatchingPatients;
        end;
    end;
  end;
end;

end.
