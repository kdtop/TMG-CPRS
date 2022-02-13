unit fPtSel;
{ Allows patient selection using various pt lists.  Allows display & processing of alerts. }
 //vwpt enhancements included

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

{$define VAA}

//kt 9/11 Changes made to *FORM* of this unit -- added 2 buttons.

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
  StdCtrls, ORCtrls, ExtCtrls, ORFn, ORNet, ORDtTmRng, Gauges, Menus, ComCtrls,
  fImagePatientPhotoID,  //kt
  UBAGlobals, UBACore, fBase508Form, VA508AccessibilityManager, uConst, Buttons;

type
  TfrmPtSel = class(TfrmBase508Form)
    pnlPtSel: TORAutoPanel;
    cboPatient: TORComboBox;
    lblPatient: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    pnlNotifications: TORAutoPanel;
    cmdProcessInfo: TButton;
    cmdProcessAll: TButton;
    cmdProcess: TButton;
    cmdForward: TButton;
    sptVert: TSplitter;
    cmdSaveList: TButton;
    pnlDivide: TORAutoPanel;
    lblNotifications: TLabel;
    ggeInfo: TGauge;
    cmdRemove: TButton;
    popNotifications: TPopupMenu;
    mnuProcess: TMenuItem;
    mnuRemove: TMenuItem;
    mnuForward: TMenuItem;
    lstvAlerts: TCaptionListView;
    N1: TMenuItem;
    RadioGroup1: TRadioGroup ;
    //RadioGroup1: TRadioGroup;
    cmdComments: TButton;
    TMGcmdAdd: TButton;  //kt 9/11
    //btnSearchPt: TBitBtn;  //kt
    btnSearchPt: TBitBtn;  //kt
    PatientImage: TImage;
    pnlPatientImage: TPanel;  //kt 4/14/15
    txtCmdComments: TVA508StaticText;
    txtCmdRemove: TVA508StaticText;
    txtCmdForward: TVA508StaticText;
    txtCmdProcess: TVA508StaticText;
    btnRefresh: TButton;
    mnuMultiTIUSign: TMenuItem;
    procedure mnuMultiTIUSignClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure PatientImageMouseLeave(Sender: TObject);
    procedure PatientImageMouseEnter(Sender: TObject);
    procedure PatientImageClick(Sender: TObject);  //kt 9/11
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboPatientChange(Sender: TObject);
    procedure cboPatientKeyPause(Sender: TObject);
    procedure cboPatientMouseClick(Sender: TObject);
    procedure cboPatientEnter(Sender: TObject);
    procedure cboPatientExit(Sender: TObject);
    procedure cboPatientNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboPatientDblClick(Sender: TObject);
    procedure cmdProcessClick(Sender: TObject);
    procedure cmdSaveListClick(Sender: TObject);
    procedure cmdProcessInfoClick(Sender: TObject);
    procedure cmdProcessAllClick(Sender: TObject);
    procedure lstvAlertsDblClick(Sender: TObject);
    procedure cmdForwardClick(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnlPtSelResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboPatientKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvAlertsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lstvAlertsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    function DupLastSSN(const DFN: string): Boolean;
    procedure lstFlagsClick(Sender: TObject);
    procedure lstFlagsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstvAlertsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ShowButts(ShowButts: Boolean);
    procedure lstvAlertsInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure lstvAlertsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cmdCommentsClick(Sender: TObject);
    procedure lstvAlertsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cboPatientKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

      //VWPT ENAHANCED PATIENT LOOKUP
    function IsOther(itemindex:Integer):Boolean;

    procedure onclick1(Sender: TObject);

    procedure TMGcmdAddClick(Sender: TObject);  //kt 9/11
    procedure btnSearchPtClick(Sender: TObject);  //kt 9/11
  private
    FsortCol: integer;
    FsortAscending: boolean;
    FLastPt: string;
    FsortDirection: string;
    FUserCancelled: boolean;
    FNotificationBtnsAdjusted: Boolean;
    FAlertsNotReady: boolean;

    FMouseUpPos: TPoint;
    frmPatientPhotoID : TfrmPatientPhotoID;  //kt  7/10/18
    procedure FixPatientImageSize;  //kt 4/15/14
    procedure WMReadyAlert(var Message: TMessage); message UM_MISC;
    procedure ReadyAlert;
    procedure AdjustFormSize(ShowNotif: Boolean; FontSize: Integer);
    procedure ClearIDInfo;
    procedure ShowIDInfo;
    procedure ShowFlagInfo;
    procedure SetCaptionTop;
    procedure SetPtListTop(IEN: Int64);
    procedure RPLDisplay;
    procedure AlertList;
    procedure ReformatAlertDateTime;
    procedure AdjustButtonSize(pButton:TButton);
    procedure AdjustNotificationButtons;
    procedure SetupDemographicsForm;
    procedure ShowDisabledButtonTexts;

  public
    procedure Loaded; override;
  end;

procedure SelectPatient(ShowNotif: Boolean; FontSize: Integer; var UserCancelled: boolean);

var
  frmPtSel: TfrmPtSel;
  FDfltSrc, FDfltSrcType: string;
  IsRPL, RPLJob, DupDFN: string;                 // RPLJob stores server $J job number of RPL pt. list.
  RPLProblem: boolean;                           // Allows close of form if there's an RPL problem.
  PtStrs: TStringList;

  //vwpt enhancement
  itimson : integer = 1;
  enhanceskip : integer = 0;
  radiogrp1index : integer = 0;

implementation

{$R *.DFM}

uses rCore, uCore, fDupPts, fPtSens, fPtSelDemog, fPtSelOptns, fPatientFlagMulti,
     uOrPtf, fAlertForward, rMisc, fFrame, fRptBox, VA508AccessibilityRouter,
     fPtAdd, fPtQuery, fLetterWriter, uTMGOptions, uTMGUtil, fMultiTIUSign,
     uTMGEvent,    //TMG
     VAUtils;

resourcestring
  StrFPtSel_lstvAlerts_Co = 'C'+U+'fPtSel.lstvAlerts.Cols';
var
  FDragging: Boolean = False;

const
  AliasString = ' -- ALIAS';
  THUMBNAIL_IMAGE_SIZE = 35; //kt 4/15/14

   //VWPT ENAHANCED PATIENT LOOKUP
function TfrmPtSel.IsOther(itemindex:Integer):Boolean;


   begin
      Result := True;
      if (RadioGroup1.ItemIndex = -1) or (RadioGroup1.ItemIndex = 0) or (itimson = 0) then Result := False;
   end;

procedure SelectPatient(ShowNotif: Boolean; FontSize: Integer; var UserCancelled: boolean);
{ displays patient selection dialog (with optional notifications), updates Patient object }
var
  frmPtSel: TfrmPtSel;
  ResetTimer:boolean;
begin
  frmPtSel := TfrmPtSel.Create(Application);
  RPLProblem := false;
  try
    with frmPtSel do
    begin
      AdjustFormSize(ShowNotif, FontSize);           // Set initial form size
      FDfltSrc := DfltPtList;
      FDfltSrcType := Piece(FDfltSrc, U, 2);
      FDfltSrc := Piece(FDfltSrc, U, 1);
      if (IsRPL = '1') then                          // Deal with restricted patient list users.
        FDfltSrc := '';
      frmPtSelOptns.SetDefaultPtList(FDfltSrc);
      if RPLProblem then
         begin
          frmPtSel.Release;
          Exit;
        end;
      Notifications.Clear;
      FsortCol := -1;
      AlertList;
      ClearIDInfo;
      if (IsRPL = '1') then                          // Deal with restricted patient list users.
        RPLDisplay;                                  // Removes unnecessary components from view.
      FUserCancelled := FALSE;
      //ELH allow user to over ride this reset 5/14/20
      ResetTimer := uTMGOptions.ReadBool('CPRS Reset Timer On New Chart',True);
      if ResetTimer then frmFrame.btnTimerResetClick(nil);  //kt
      ShowModal;
      UserCancelled := FUserCancelled;
      if not UserCancelled then begin
        //Is this needed??
      end;
    end;
  finally
    frmPtSel.Release;
  end;
end;

procedure TfrmPtSel.AdjustFormSize(ShowNotif: Boolean; FontSize: Integer);
{ Adjusts the initial size of the form based on the font used & if notifications should show. }
var
  Rect: TRect;
  SplitterTop, t1, t2, t3: integer;
begin
  SetFormPosition(self);
  ResizeAnchoredFormToFont(self);
  if ShowNotif then
  begin
    pnlDivide.Visible := True;
    lstvAlerts.Visible := True;
    pnlNotifications.Visible := True;
    pnlPtSel.BevelOuter := bvRaised;
  end
  else
  begin
    pnlDivide.Visible := False;
    lstvAlerts.Visible := False;
    pnlNotifications.Visible := False;
  end;
  //SetFormPosition(self);
  Rect := BoundsRect;
  ForceInsideWorkArea(Rect);
  BoundsRect := Rect;
  if frmFrame.EnduringPtSelSplitterPos <> 0 then
    SplitterTop := frmFrame.EnduringPtSelSplitterPos
  else
    SetUserBounds2(Name+'.'+sptVert.Name,SplitterTop, t1, t2, t3);
  if SplitterTop <> 0 then
    pnlPtSel.Height := SplitterTop;
  FNotificationBtnsAdjusted := False;
  AdjustButtonSize(cmdSaveList);
  AdjustButtonSize(cmdProcessInfo);
  AdjustButtonSize(cmdProcessAll);
  AdjustButtonSize(cmdProcess);
  AdjustButtonSize(cmdForward);
  AdjustButtonSize(cmdRemove);
  AdjustButtonSize(cmdComments);
  AdjustNotificationButtons;
end;

procedure TfrmPtSel.SetCaptionTop;
{ Show patient list name, set top list to 'Select ...' if appropriate. }
var
  x: string;
begin
  x := '';
  lblPatient.Caption := 'Patients';
  if (not User.IsReportsOnly) then
  begin
  case frmPtSelOptns.SrcType of
  TAG_SRC_DFLT: lblPatient.Caption := 'Patients (' + FDfltSrc + ')';
  TAG_SRC_PROV: x := 'Provider';
  TAG_SRC_TEAM: x := 'Team';
  TAG_SRC_SPEC: x := 'Specialty';
  TAG_SRC_CLIN: x := 'Clinic';
  TAG_SRC_WARD: x := 'Ward';
  TAG_SRC_HX:   x := 'History Sort Option';  //kt added
  TAG_SRC_ALL:  { Nothing };
  end; // case stmt
  end; // begin
  if Length(x) > 0 then with cboPatient do
  begin
    RedrawSuspend(Handle);
    ClearIDInfo;
    ClearTop;
    Text := '';
    Items.Add('^Select a ' + x + '...');
    Items.Add(LLS_LINE);
    Items.Add(LLS_SPACE);
    cboPatient.InitLongList('');
    RedrawActivate(cboPatient.Handle);
  end;
end;

{ List Source events: }

procedure TfrmPtSel.SetPtListTop(IEN: Int64);
{ Sets top items in patient list according to list source type and optional list source IEN. }
var
  NewTopList: string;
  FirstDate, LastDate: string;
begin
  // NOTE:  Some pieces in RPC returned arrays are rearranged by ListPtByDflt call in rCore!
  IsRPL := User.IsRPL;
  if (IsRPL = '') then // First piece in ^VA(200,.101) should always be set (to 1 or 0).
    begin
      InfoBox('Patient selection list flag not set.', 'Incomplete User Information', MB_OK);
      RPLProblem := true;
      Exit;
    end;
  // FirstDate := 0; LastDate := 0; // Not req'd, but eliminates hint.
  // Assign list box TabPosition, Pieces properties according to type of list to be displayed.
  // (Always use Piece "2" as the first in the list to assure display of patient's name.)
  cboPatient.pieces := '2,3'; // This line and next: defaults set - exceptions modifield next.
  cboPatient.tabPositions := '20,28';
  if (frmPtSelOptns.SrcType = TAG_SRC_HX) then  //kt added this block
    begin
      cboPatient.pieces := '2,3';  //check this...
      cboPatient.tabPositions := '40';
    end;
  if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and (FDfltSrc = 'Combination')) then
    begin
      cboPatient.pieces := '2,3,4,5,9';
      cboPatient.tabPositions := '20,28,35,45';
    end;
  if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and
      (FDfltSrcType = 'Ward')) or (frmPtSelOptns.SrcType = TAG_SRC_WARD) then
    cboPatient.tabPositions := '35';
  if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and
      (AnsiStrPos(pChar(FDfltSrcType), 'Clinic') <> nil)) or (frmPtSelOptns.SrcType = TAG_SRC_CLIN) then
    begin
      cboPatient.pieces := '2,3,9';
      cboPatient.tabPositions := '24,45';
    end;
  NewTopList := IntToStr(frmPtSelOptns.SrcType) + U + IntToStr(IEN); // Default setting.
  //kt 11/11/13 added 'or (frmPtSelOptns.SrcType = TAG_SRC_HX)' on line below
  if (frmPtSelOptns.SrcType = TAG_SRC_CLIN) or (frmPtSelOptns.SrcType = TAG_SRC_HX) or (frmPtSelOptns.SrcType = TAG_SRC_PROV) then with frmPtSelOptns.cboDateRange do  //elh added Provider 5/22/17
    begin
      if ItemID = '' then Exit;                        // Need both clinic & date range.
      FirstDate := Piece(ItemID, ';', 1);
      LastDate  := Piece(ItemID, ';', 2);
      NewTopList := IntToStr(frmPtSelOptns.SrcType) + U + IntToStr(IEN) + U + ItemID; // Modified for clinics.
    end;
  if NewTopList = frmPtSelOptns.LastTopList then Exit; // Only continue if new top list.
  frmPtSelOptns.LastTopList := NewTopList;
  RedrawSuspend(cboPatient.Handle);
  ClearIDInfo;
  cboPatient.ClearTop;
  cboPatient.Text := '';
  if (IsRPL = '1') then                                // Deal with restricted patient list users.
    begin
      RPLJob := MakeRPLPtList(User.RPLList);           // MakeRPLPtList is in rCore, writes global "B" x-ref list.
      if (RPLJob = '') then
        begin
          InfoBox('Assignment of valid OE/RR Team List Needed.', 'Unable to build Patient List', MB_OK);
          RPLProblem := true;
          Exit;
        end;
    end
  else
    begin
      case frmPtSelOptns.SrcType of
      TAG_SRC_DFLT: ListPtByDflt(cboPatient.Items);
      TAG_SRC_PROV: begin  //elh added begin 5/22/17
        //original -> ListPtByProvider(cboPatient.Items, IEN);
        ListPtByAppt(cboPatient.Items,IEN,FirstDate, LastDate);
      end;
      TAG_SRC_TEAM: ListPtByTeam(cboPatient.Items, IEN);
      TAG_SRC_SPEC: ListPtBySpecialty(cboPatient.Items, IEN);
      TAG_SRC_CLIN: ListPtByClinic(cboPatient.Items, frmPtSelOptns.cboList.ItemIEN, FirstDate, LastDate);
      TAG_SRC_WARD: ListPtByWard(cboPatient.Items, IEN);
      TAG_SRC_ALL:  ListPtTop(cboPatient.Items);
      TAG_SRC_HX:   ListPtByHx(cboPatient.Items, IEN, FirstDate, LastDate); //kt added
      end;
    end;
  if frmPtSelOptns.cboList.Visible then
    lblPatient.Caption := 'Patients (' + frmPtSelOptns.cboList.Text + ')';
  if frmPtSelOptns.SrcType = TAG_SRC_ALL then
    lblPatient.Caption := 'Patients (All Patients)';
  with cboPatient do if ShortCount > 0 then
    begin
      Items.Add(LLS_LINE);
      Items.Add(LLS_SPACE);
    end;
  cboPatient.Caption := lblPatient.Caption;
  cboPatient.InitLongList('');
  //VWPT
  //cboPatient.LongList := True;
  //cboPateint.HintonItem := True;
  //end
  RedrawActivate(cboPatient.Handle);
end;

{ Patient Select events: }

procedure TfrmPtSel.cboPatientEnter(Sender: TObject);
begin
  cmdOK.Default := True;
  if cboPatient.ItemIndex >= 0 then
  begin
    ShowIDInfo;
    ShowFlagInfo;
  end;
end;

procedure TfrmPtSel.cboPatientExit(Sender: TObject);
begin
  cmdOK.Default := False;
end;

procedure TfrmPtSel.cboPatientChange(Sender: TObject);

  procedure ShowMatchingPatients;
  begin
    with cboPatient do begin
      ClearIDInfo;
      if ShortCount > 0 then begin
        if ShortCount = 1 then begin
          ItemIndex := 0;
          ShowIDInfo;
          ShowFlagInfo;
        end;
        Items.Add(LLS_LINE);
        Items.Add(LLS_SPACE);
      end;
      InitLongList('');
    end;
  end;

var
index:integer;
begin
  with cboPatient do begin
    if IsOther(integer(1)) and
    (IsRPL <> '1') and
    (enhanceskip=0) and
    (frmPtSelOptns.IsEnhanced(Text)) and
    (not frmPtSelOptns.IsPatientName(Text)) then begin
      if (IsRPL = '1') then begin
        ///ListPtByRPLLast5(Items, Text)   Messagebox error
      end else  begin
        index := RadioGroup1.ItemIndex;
        caption := piece(RadioGroup1.Items[index],'&',2);
        //Application.MessageBox(pChar(caption), pChar('Message'),MB_OK);
        //caption := '' ; //derivative of integer(1) or other index of radio button selection
        ListPtByOther(Items, Text, caption); // one extra argument on radio button selection
        if Items.Count>0  then begin
          //itimson :=0 ;//no check for timson change in cbopatient until after click event finished
          RadioGroup1.ItemIndex  := 0;
          RadioGroup1.SetFocus;
          RadioGroup1.Refresh;
        end;
        ShowMatchingPatients;
      end;
    end
    //agp //kt prior --> else if frmPtSelOptns.IsLast5(Text) then
    else //  agp wv change removed if statement  //kt
    if frmPtSelOptns.IsLast5(Text) then begin
      if (IsRPL = '1') then
        ListPtByRPLLast5(Items, Text)
      else
        ListPtByLast5(Items, Text);
      ShowMatchingPatients;
    end else if frmPtSelOptns.IsFullSSN(Text) then begin
      if (IsRPL = '1') then
        ListPtByRPLFullSSN(Items, Text)
      else
        ListPtByFullSSN(Items, Text);
      ShowMatchingPatients;
    end else if (not IsOther(integer(1))) and
    (IsRPL <> '1') and
    (enhanceskip=0) and
    (frmPtSelOptns.IsEnhanced(Text)) and
    (not frmPtSelOptns.IsPatientName(Text)) then begin
      //ListPtByTimson(Items,Text) ;
      //ShowMatchingPatients;
      //vwpt enhanced changes
      //check for change here if itimson flag =1 .no matter what however, even if 0,
     //set it back to 1
     //itimson :=1;
     //end vwpt enhanced
    end
    //enhanceskip := 0 ;
  end;  
end;

procedure TfrmPtSel.cboPatientKeyPause(Sender: TObject);
begin
  if Length(cboPatient.ItemID) > 0 then  //*DFN*
  begin
    ShowIDInfo;
    ShowFlagInfo;    
  end else
  begin
    ClearIDInfo;
  end;
end;

procedure TfrmPtSel.cboPatientKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_BACK) and (cboPatient.Text = '') then cboPatient.ItemIndex := -1;
end;

procedure TfrmPtSel.cboPatientMouseClick(Sender: TObject);
begin
  // vwpt enhanced   on click or double clck set mode back to normal to a.) not allow change event
 //erroneously checked with false lookup, and b.0 immedicately put back into normal mode
 //without separate step needed.
  if (RadioGroup1.ItemIndex  > 0) then
begin
      //itimson :=0 ;//no check for timson change in cbopatient until after click event finished
      RadioGroup1.ItemIndex  := 0;
      RadioGroup1.SetFocus;
      RadioGroup1.Refresh;
    end;
    //enhanceskip:=1 ;
//end vwpt enhanced
  if Length(cboPatient.ItemID) > 0 then   //*DFN*
  begin
    ShowIDInfo;
    ShowFlagInfo;
  end else
  begin
    ClearIDInfo;
  end;
end;

procedure TfrmPtSel.cboPatientDblClick(Sender: TObject);
begin
  // vwpt enhanced   on click or double clck set mode back to normal to a.) not allow change event
//erroneiusly checked with false lookup, and b.0 immedicately put back into normal mode
//withut separate step needed.
  if (RadioGroup1.ItemIndex  > 0 ) then
begin
      // itimson :=0 ;//no check for timson change in cbopatient until after click event finished
      RadioGroup1.ItemIndex  := 0;
      RadioGroup1.SetFocus;
      RadioGroup1.Refresh;
    end;
//end vwpt enhanced
  if Length(cboPatient.ItemID) > 0 then cmdOKClick(Self);  //*DFN*
end;

procedure TfrmPtSel.cboPatientNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
var
  i: Integer;
  NoAlias, Patient: String;
  PatientList: TStringList;
begin
  NoAlias := StartFrom;
  with Sender as TORComboBox do
  if Items.Count > ShortCount then
  begin
    NoAlias := Piece(Items[Items.Count-1], U, 1) + U + NoAlias;
    if Direction < 0 then
      NoAlias := Copy(NoAlias, 1, Length(NoAlias) - 1);
  end;
  if pos(AliasString, NoAlias) > 0 then
    NoAlias := Copy(NoAlias, 1, pos(AliasString, NoAlias) - 1);
  PatientList := TStringList.Create;
  try
    begin
      if (IsRPL  = '1') then // Restricted patient lists uses different feed for long list box:
        FastAssign(ReadRPLPtList(RPLJob, NoAlias, Direction), PatientList)
      else
      begin
        FastAssign(SubSetOfPatients(NoAlias, Direction), PatientList);
        for i := 0 to PatientList.Count - 1 do  // Add " - Alias" to alias names:
        begin
          Patient := PatientList[i];
          // Piece 6 avoids display problems when mixed with "RPL" lists:
          if (Uppercase(Piece(Patient, U, 2)) <> Uppercase(Piece(Patient, U, 6))) then
          begin
            SetPiece(Patient, U, 2, Piece(Patient, U, 2) + AliasString);
            PatientList[i] := Patient;
          end;
        end;
      end;
      cboPatient.ForDataUse(PatientList);
    end;
  finally
    PatientList.Free;
  end;
end;

procedure TfrmPtSel.ClearIDInfo;
begin
  frmPtSelDemog.ClearIDInfo;
  PatientImage.Visible := false;  //kt 4/15/14
  PatientImage.Picture.Bitmap.Assign(fFrame.NoPatientIDPhotoIcon); //put in default "?" icon.  //kt 4/15/14
end;

procedure TfrmPtSel.ShowIDInfo;
begin
  frmPtSelDemog.ShowDemog(cboPatient.ItemID);
  //kt start mod
  PatientImage.Visible := true;
  LoadMostRecentPhotoIDThumbNail(cboPatient.ItemID,PatientImage.Picture.Bitmap);
  //kt end mod
end;

procedure TfrmPtSel.WMReadyAlert(var Message: TMessage);
begin
  ReadyAlert;
  Message.Result := 0;
end;

{ Command Button events: }

procedure TfrmPtSel.cmdOKClick(Sender: TObject);
{ Checks for restrictions on the selected patient and sets up the Patient object. }
const
  DLG_CANCEL = False;
var
  NewDFN: string;  //*DFN*
  DateDied: TFMDateTime;
  AccessStatus: integer;
  RPCResult : string;  //kt
begin
// vwpt enhanced   on click or double clck set mode back to normal to a.) not allow change event
//erroniously checked with false lookup, and b.0 immedicately put back into normal mode
//without separate step needed.
  if (RadioGroup1.ItemIndex  > 0 ) then begin
    //itimson :=0 ;//no check for timson change in cbopatient until after click event finished
    RadioGroup1.ItemIndex  := 0;
    RadioGroup1.SetFocus;
    RadioGroup1.Refresh;
  end;
//end vwpt enhanced

  if not (Length(cboPatient.ItemID) > 0) then begin //*DFN*
    InfoBox('A patient has not been selected.', 'No Patient Selected', MB_OK);
    Exit;
  end;
  NewDFN := cboPatient.ItemID;  //*DFN*
  LastSelectedOption := frmPtSelOptns.SrcType;
  if FLastPt <> cboPatient.ItemID then
  begin
    HasActiveFlg(FlagList, HasFlag, cboPatient.ItemID);
    flastpt := cboPatient.ItemID;
  end;

  //kt added 4/8/15
  //if uTMGOptions.ReadString('SpecialLocation','')='INTRACARE' then begin
  //if AtIntracareLoc() then begin
  //  RPCResult := sCallV('VEFA PT HAS SIGNED CONSENT',[NewDFN,'0']);
  //  if piece(RPCResult,'^',1)='-1' then
  //      messagedlg(piece(RPCResult,'^',2),mtWarning,[mbOK],0);
  //  RPCResult := sCallV('VEFA PT MISSING ADDRESS',[NewDFN]);
  //  if piece(RPCResult,'^',1)='-1' then
  //      messagedlg(piece(RPCResult,'^',2),mtWarning,[mbOK],0);
  //end;
  //kt end mod

  If DupLastSSN(NewDFN) then    // Check for, deal with duplicate patient data.
    if (DupDFN = 'Cancel') then
      Exit
    else
      NewDFN := DupDFN;
  if not AllowAccessToSensitivePatient(NewDFN, AccessStatus) then exit;
  DateDied := DateOfDeath(NewDFN);
  if (DateDied > 0) and (InfoBox('This patient died ' + FormatFMDateTime('mmm dd,yyyy hh:nn', DateDied) + CRLF +
     'Do you wish to continue?', 'Deceased Patient', MB_YESNO or MB_DEFBUTTON2) = ID_NO) then
    Exit;
  // 9/23/2002: Code used to check for changed pt. DFN here, but since same patient could be
  //    selected twice in diff. Encounter locations, check was removed and following code runs
  //    no matter; in fFrame code then updates Encounter display if Encounter.Location has changed.
  // NOTE: Some pieces in RPC returned arrays are modified/rearranged by ListPtByDflt call in rCore!
  Patient.DFN := NewDFN;     // The patient object in uCore must have been created already!
  Encounter.Clear;
  Changes.Clear;             // An earlier call to ReviewChanges should have cleared this.
  if (frmPtSelOptns.SrcType = TAG_SRC_CLIN) and (frmPtSelOptns.cboList.ItemIEN > 0) and
    IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 4)) then // Clinics, not by default.
  begin
    Encounter.Location := frmPtSelOptns.cboList.ItemIEN;
    with cboPatient do Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 4));
  end
  else if (frmPtSelOptns.SrcType = TAG_SRC_DFLT) and (DfltPtListSrc = 'C') and
         IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 4))then
       with cboPatient do // "Default" is a clinic.
  begin
    Encounter.Location := StrToIntDef(Piece(Items[ItemIndex], U, 10), 0); // Piece 10 is ^SC( location IEN in this case.
    Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 4));
  end
  else if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and (FDfltSrc = 'Combination') and
           (copy(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 3), 1, 2) = 'Cl')) and
           (IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 8))) then
       with cboPatient do // "Default" combination, clinic pt.
  begin
    Encounter.Location := StrToIntDef(Piece(Items[ItemIndex], U, 7), 0); // Piece 7 is ^SC( location IEN in this case.
    Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 8));
  end
  else if Patient.Inpatient then // Everything else:
  begin
    Encounter.Inpatient := True;
    Encounter.Location := Patient.Location;
    Encounter.DateTime := Patient.AdmitTime;
    Encounter.VisitCategory := 'H';
  end;
  //if User.IsProvider then Encounter.Provider := User.DUZ;    //ELH commented out for code below  9/7/18  //TMG //kt
  Encounter.Provider := StrToInt(sCallV('TMG CPRS GET CURRENT PROVIDER',[Patient.DFN, IntToStr(User.DUZ)]));

  GetBAStatus(Encounter.Provider,Patient.DFN);
  //HDS00005025
  if BILLING_AWARE then
    if Assigned(UBAGLOBALS.BAOrderList) then UBAGLOBALS.BAOrderList.Clear;
  FUserCancelled := FALSE;
  Close;
end;

procedure TfrmPtSel.cmdCancelClick(Sender: TObject);
begin
  // Leave Patient object unchanged
  FUserCancelled := TRUE;
  Close;
end;

procedure TfrmPtSel.cmdCommentsClick(Sender: TObject);
var
  tmpCmt: TStringList;
begin
  if FAlertsNotReady then exit;  
  inherited;
  tmpCmt := TStringList.Create;
  try
    tmpCmt.Text := lstvAlerts.Selected.SubItems[8];
    LimitStringLength(tmpCmt, 74);
    tmpCmt.Insert(0, StringOfChar('-', 74));
    tmpCmt.Insert(0, lstvAlerts.Selected.SubItems[4]);
    tmpCmt.Insert(0, lstvAlerts.Selected.SubItems[3]);
    tmpCmt.Insert(0, lstvAlerts.Selected.SubItems[0]);
    ReportBox(tmpCmt, 'Forwarded by: ' + lstvAlerts.Selected.SubItems[5], TRUE);
    lstvAlerts.SetFocus;
  finally
    tmpCmt.Free;
  end;
end;

procedure TfrmPtSel.cmdProcessClick(Sender: TObject);
var
  AFollowUp, i, infocount: Integer;
  enableclose: boolean;
  ADFN, x, RecordID, XQAID: string;  //*DFN*
  Response: integer;
begin
  if FAlertsNotReady then exit;
  enableclose := false;
  with lstvAlerts do
  begin
    if SelCount <= 0 then Exit;

    // Count information-only selections for gauge
    infocount := 0;
    for i:= 0 to Items.Count - 1 do if Items[i].Selected then begin
      if (Items[i].SubItems[0] = 'I') then Inc(infocount);
    end;

    if infocount >= 1 then begin
      ggeInfo.Visible := true; (*BOB*)
      ggeInfo.MaxValue := infocount;
    end;

    for i := 0 to Items.Count - 1 do if Items[i].Selected then begin
      { Items[i].Selected    =  Boolean TRUE if item is selected
            "   .Caption     =  Info flag ('I')
            "   .SubItems[0] =  Patient ('ABC,PATIE (A4321)')
            "   .    "   [1] =  Patient location ('[2B]')
            "   .    "   [2] =  Alert urgency level ('HIGH, Moderate, low')
            "   .    "   [3] =  Alert date/time ('2002/12/31@12:10')
            "   .    "   [4] =  Alert message ('New order(s) placed.')
            "   .    "   [5] =  Forwarded by/when
            "   .    "   [6] =  XQAID ('OR,66,50;1416;3021231.121024')
                                       'TIU6028;1423;3021203.09')
            "   .    "   [7] =  Remove without processing flag ('YES')
            "   .    "   [8] =  Forwarding comments (if applicable) }
      XQAID := Items[i].SubItems[6];
      RecordID := Items[i].SubItems[0] + ': ' + Items[i].SubItems[4] + '^' + XQAID;
      //RecordID := patient: alert message^XQAID  ('ABC,PATIE (A4321): New order(s) placed.^OR,66,50;1416;3021231.121024')
      if Items[i].Caption = 'I' then begin
        // If Caption is 'I' delete the information only alert.
        ggeInfo.Progress := ggeInfo.Progress + 1;
        if pos('mailbox',RecordID)>0 then begin       //TMG added if 8/26/19
           //ADFN := '74592';  //*DFN*
           ADFN := uTMGOptions.ReadString('Mailbox Patient','74592');
           AFollowUp := NF_MAILBOX;   //StrToIntDef(Piece(Piece(XQAID, ';', 1), ',', 3), 0);  //kt Matches Notification types in uConst, e.g. NF_NOTES_UNSIGNED_NOTE
           Notifications.Add(ADFN, AFollowUp, RecordID, Items[i].SubItems[3]); //CB
           enableclose := true;
           DeleteAlert(XQAID);
        end else begin
           Response := messagedlg(piece(RecordID,'^',1)+#13#10+#13#10+'Do you want to remove this alert?',mtConfirmation,[mbYes,mbNo],0); //TMG  8/22/19
           if Response=mrYes then DeleteAlert(XQAID);  //TMG  8/22/19
        end;
      end else if Piece(XQAID, ',', 1) = 'OR' then begin
        //e.g.  OR,16,50;1311;2980626.100756  or 'OR,75214,3;168;3211104.07122'
        ADFN := Piece(XQAID, ',', 2);  //*DFN*
        AFollowUp := StrToIntDef(Piece(Piece(XQAID, ';', 1), ',', 3), 0);  //kt Matches Notification types in uConst, e.g. NF_NOTES_UNSIGNED_NOTE
        Notifications.Add(ADFN, AFollowUp, RecordID, Items[i].SubItems[3]); //CB     Add(ADFN, AFollowUp, ARecordID, AHighLightSection)
        enableclose := true;
      end else if Copy(XQAID, 1, 6) = 'TIUERR' then begin
        InfoBox(Piece(RecordID, U, 1) + #13#10#13#10 +
           'The CPRS GUI cannot yet process this type of alert.  Please use List Manager.',
           'Unable to Process Alert', MB_OK)
      end else if Copy(XQAID, 1, 3) = 'TIU' then begin
        //e.g. TIU6028;1423;3021203.09
        x := GetTIUAlertInfo(XQAID);
        if Piece(x, U, 2) <> '' then begin
          ADFN := Piece(x, U, 2);  //*DFN*
          AFollowUp := StrToIntDef(Piece(Piece(x, U, 3), ';', 1), 0);  //kt Matches Notification types in uConst, e.g. NF_NOTES_UNSIGNED_NOTE
          Notifications.Add(ADFN, AFollowUp, RecordID + '^^' + Piece(x, U, 3));
          enableclose := true;
        end else begin
          DeleteAlert(XQAID);
        end;
      end else begin  //other alerts cannot be processed
        InfoBox('This alert cannot be processed by the CPRS GUI.', Items[i].SubItems[0] + ': ' + Items[i].SubItems[4], MB_OK);
      end;
    end;
    if enableclose = true then
      Close
    else begin
      ggeInfo.Visible := False;
      // Update notification list:
      lstvAlerts.Clear;
      AlertList;
      //display alerts sorted according to parameter settings:
      FsortCol := -1;     //CA - display alerts in correct sort
      FormShow(Sender);
    end;
    if Items.Count = 0 then ShowButts(False);
    if SelCount <= 0 then ShowButts(False);
  end;
  GetBAStatus(User.DUZ,Patient.DFN);
end;

procedure TfrmPtSel.cmdSaveListClick(Sender: TObject);
begin
  frmPtSelOptns.cmdSaveListClick(Sender);
end;

procedure TfrmPtSel.cmdProcessInfoClick(Sender: TObject);
  // Select and process all items that are information only in the lstvAlerts list box.
var
  i: integer;
begin
  if FAlertsNotReady then exit;  
  if lstvAlerts.Items.Count = 0 then Exit;
  if InfoBox('You are about to process all your INFORMATION alerts.' + CRLF
    + 'These alerts will not be presented to you for individual' + CRLF
    + 'review and they will be permanently removed from your' + CRLF
    + 'alert list.  Do you wish to continue?',
    'Warning', MB_YESNO or MB_ICONWARNING) = IDYES then
  begin
    for i := 0 to lstvAlerts.Items.Count-1 do
      lstvAlerts.Items[i].Selected := False;  //clear any selected alerts so they aren't processed
    for i := 0 to lstvAlerts.Items.Count-1 do
      if lstvAlerts.Items[i].Caption = 'I' then
        lstvAlerts.Items[i].Selected := True;
    cmdProcessClick(Self);
    ShowButts(False);
  end;
end;

procedure TfrmPtSel.cmdProcessAllClick(Sender: TObject);
var
  i: integer;
begin
  if FAlertsNotReady then exit;
  for i := 0 to lstvAlerts.Items.Count-1 do
    lstvAlerts.Items[i].Selected := True;
  cmdProcessClick(Self);
  ShowButts(False);
end;

procedure TfrmPtSel.lstvAlertsDblClick(Sender: TObject);
var
  ScreenCurPos, ClientCurPos: TPoint;
begin
  cmdProcessClick(Self);
  ScreenCurPos.X := 0;
  ScreenCurPos.Y := 0;
  ClientCurPos.X := 0;
  ClientCurPos.Y := 0;
  if GetCursorPos(ScreenCurPos) then ClientCurPos := lstvAlerts.ScreenToClient(ScreenCurPos); //convert screen coord. to client coord.
  //fixes CQ 18657: double clicking on notification, does not go to pt. chart until mouse is moved. [v28.4 - TC]
  if (FMouseUpPos.X = ClientCurPos.X) and (FMouseUpPos.Y = ClientCurPos.Y) then
    begin
      lstvAlerts.BeginDrag(False,0);
      FDragging := True;
    end;
end;

procedure TfrmPtSel.cmdForwardClick(Sender: TObject);
var
  i: integer;
  Alert: String;
begin
  if FAlertsNotReady then exit;  
  try
    with lstvAlerts do
      begin
        if SelCount <= 0 then Exit;
        for i := 0 to Items.Count - 1 do
          if Items[i].Selected then
            try
              Alert := Items[i].SubItems[6] + '^' + Items[i].Subitems[0] + ': ' +
                 Items[i].Subitems[4];
              ForwardAlertTo(Alert);
            finally
              Items[i].Selected := False;
            end;
      end;
  finally
    if lstvAlerts.SelCount <= 0 then ShowButts(False);
  end;
end;

procedure TfrmPtSel.cmdRemoveClick(Sender: TObject);
var
  i: integer;
  msg:string;  //TMG  1/21/19
begin
  if FAlertsNotReady then exit;
  //tmg begin addition 1/21/19
  if lstvAlerts.Items.Count>1 then
     msg := 'Are you sure you want to REMOVE these alerts?'
  else
     msg := 'Are you sure you want to REMOVE this alert?';

  if messagedlg(msg+#13#10+'This can not be undone.',mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  //tmg end addition   1/21/19
  with lstvAlerts do
    begin
      if SelCount <= 0 then Exit;
      for i := 0 to Items.Count - 1 do
        if Items[i].Selected then
          begin
            if Items[i].SubItems[7] = '1' then  //remove flag enabled
              DeleteAlertforUser(Items[i].SubItems[6])
            else InfoBox('This alert cannot be removed.', Items[i].SubItems[0] + ': ' + Items[i].SubItems[4], MB_OK);
          end;
    end;
  lstvAlerts.Clear;
  AlertList;
  FsortCol := -1;     //CA - display alerts in correct sort
  FormShow(Sender);  //CA - display alerts in correct sort
  if lstvAlerts.Items.Count = 0 then ShowButts(False);
  if lstvAlerts.SelCount <= 0 then ShowButts(False);
end;

procedure TfrmPtSel.FormDestroy(Sender: TObject);
var
  i: integer;
  AString: string;
begin
  SaveUserBounds(Self);
  frmFrame.EnduringPtSelSplitterPos := pnlPtSel.Height;
  AString := '';
  for i := 0 to 6 do
  begin
    AString := AString + IntToStr(lstvAlerts.Column[i].Width);
    if i < 6 then AString:= AString + ',';
  end;
  frmFrame.EnduringPtSelColumns := AString;
 end;

procedure TfrmPtSel.FormResize(Sender: TObject);
begin
  inherited;
  FNotificationBtnsAdjusted := False;
  AdjustButtonSize(cmdSaveList);
  AdjustButtonSize(cmdProcessInfo);
  AdjustButtonSize(cmdProcessAll);
  AdjustButtonSize(cmdProcess);
  AdjustButtonSize(cmdForward);
  AdjustButtonSize(cmdComments);
  AdjustButtonSize(cmdRemove);
  AdjustNotificationButtons;
  FixPatientImageSize;
end;

procedure TfrmPtSel.pnlPtSelResize(Sender: TObject);
begin
  frmPtSelDemog.Left := cboPatient.Left + cboPatient.Width + 9;
  frmPtSelDemog.Width := pnlPtSel.Width - frmPtSelDemog.Left - 5;
//  frmPtSelDemog.Width := frmPtSel.CmdCancel.Left - frmPtSelDemog.Left-2;// before vwpt enhancements pnlPtSel.Width - frmPtSelDemog.Left - 2;
  frmPtSelOptns.Width := cboPatient.Left-8;
  FixPatientImageSize;
end;

procedure TfrmPtSel.FixPatientImageSize;
//kt added function 4/15/14
const IMAGE_MARGIN = 5;
      GAP_TO_RIGHT_OF_IMAGE_PANEL = 10;
begin
  pnlPatientImage.Height := THUMBNAIL_IMAGE_SIZE + IMAGE_MARGIN * 2;
  pnlPatientImage.Width := THUMBNAIL_IMAGE_SIZE + IMAGE_MARGIN * 2;
  PatientImage.Top := IMAGE_MARGIN;
  PatientImage.Left := IMAGE_MARGIN;
  PatientImage.Width := THUMBNAIL_IMAGE_SIZE; //kt 4/15/14
  PatientImage.Height := THUMBNAIL_IMAGE_SIZE; //kt 4/15/14
  pnlPatientImage.Top := 5;
  pnlPatientImage.Left := cmdOK.Left - (pnlPatientImage.Width + GAP_TO_RIGHT_OF_IMAGE_PANEL);  //kt 9/27/15
end;

procedure TfrmPtSel.Loaded;
begin
  inherited;
  //vwpt enhancements
  CmdOK.parent := pnlPtSel;
  CmdCancel.parent  :=  pnlPtSel;
  //end vwpt
  SetupDemographicsForm;

  with RadioGroup1 do
  begin
      parent := pnlPtSel;
      TabOrder  := cmdCancel.TabOrder + 2;
      Show;
  end;
  //end vwpt enhancements
  frmPtSelOptns := TfrmPtSelOptns.Create(Self);  // Was application - kcm
  with frmPtSelOptns do
  begin
    parent := pnlPtSel;
    Top := 4;
    Left := 4;
    Width := cboPatient.Left-8;
    SetCaptionTopProc := SetCaptionTop;
    SetPtListTopProc  := SetPtListTop;
    if RPLProblem then
      Exit;
    TabOrder := cmdSaveList.TabOrder;  //Put just before save default list button
    Show;
  end;
  FLastPt := '';
  //Begin at alert list, or patient listbox if no alerts
  if lstvAlerts.Items.Count = 0 then
    ActiveControl := cboPatient;
end;

procedure TfrmPtSel.ShowDisabledButtonTexts;
begin
  if ScreenReaderActive then
  begin
    txtCmdProcess.Visible := not cmdProcess.Enabled;
    txtCmdRemove.Visible := not cmdRemove.Enabled;
    txtCmdForward.Visible := not cmdForward.Enabled;
    txtCmdComments.Visible := not cmdComments.Enabled;
  end;
end;

procedure TfrmPtSel.SetupDemographicsForm;
begin
  // This needs to be in Loaded rather than FormCreate or the TORAutoPanel resize logic breaks.
  frmPtSelDemog := TfrmPtSelDemog.Create(Self);
  // Was application - kcm
  with frmPtSelDemog do
  begin
    parent := pnlPtSel;
    Top := cmdCancel.Top + cmdCancel.Height + 2;
    Left := cboPatient.Left + cboPatient.Width + 9;
    Width := pnlPtSel.Width - Left - 2;
    TabOrder := cmdCancel.TabOrder + 1;
    //Place after cancel button
    Show;
    radioGroup1.BringToFront;  //vw
  end;
  if ScreenReaderActive then begin
    frmPtSelDemog.Memo.Show;
    frmPtSelDemog.Memo.BringToFront;
    radioGroup1.BringToFront;  //vw
  end;
end;

procedure TfrmPtSel.RPLDisplay;
begin

// Make unneeded components invisible:
cmdSaveList.visible := false;
frmPtSelOptns.visible := false;

end;

procedure TfrmPtSel.FormClose(Sender: TObject; var Action: TCloseAction);
var
  colSizes : String;
  RPCResult : string;  //kt added
begin
  colSizes := '';
  with lstvAlerts do begin
    colSizes := IntToStr(Columns[0].Width) + ',';  //Info                 Caption
    colSizes := colSizes + IntToStr(Columns[1].Width) + ',';  //Patient              SubItems[0]
    colSizes := colSizes + IntToStr(Columns[2].Width) + ',';  //Location             SubItems[1]
    colSizes := colSizes + IntToStr(Columns[3].Width) + ',';  //Urgency              SubItems[2]
    colSizes := colSizes + IntToStr(Columns[4].Width) + ',';  //Alert Date/Time      SubItems[3]
    colSizes := colSizes + IntToStr(Columns[5].Width) + ',';  //Message Text         SubItems[4]
    colSizes := colSizes + IntToStr(Columns[6].Width);  //Forwarded By/When    SubItems[5]
  end;
  SizeHolder.SetSize(StrFPtSel_lstvAlerts_Co,colSizes);

  //kt added 4/8/15
  //kt if uTMGOptions.ReadString('SpecialLocation','')='INTRACARE' then begin
  if AtIntracareLoc() then begin
    RPCResult := sCallV('VEFA PT HAS SIGNED CONSENT',[Patient.DFN,'0']);
    if piece(RPCResult,'^',1)='-1' then begin
      messagedlg(piece(RPCResult,'^',2),mtWarning,[mbOK],0);
    end;
    RPCResult := sCallV('VEFA PT MISSING ADDRESS',[PATIENT.DFN]);
    if piece(RPCResult,'^',1)='-1' then begin
      messagedlg(piece(RPCResult,'^',2),mtWarning,[mbOK],0);
    end;
    if FDragging then begin
      lstvAlerts.EndDrag(True); //terminate fake dragging operation from lstvAlertsDblClick.
      FDragging := False;
    end;
  end;
  //kt end mod

  if (IsRPL = '1') then                          // Deal with restricted patient list users.
    KillRPLPtList(RPLJob);                       // Kills server global data each time.
                                                 // (Global created by MakeRPLPtList in rCore.)
end;

procedure TfrmPtSel.FormCreate(Sender: TObject);
begin
  inherited;
  DefaultButton := cmdOK;
  FAlertsNotReady := FALSE;
  ShowDisabledButtonTexts;
end;

procedure TfrmPtSel.cboPatientKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = Ord('D')) and (ssCtrl in Shift) then begin
    Key := 0;
    frmPtSelDemog.ToggleMemo;
  end;
end;

function ConvertDate(var thisList: TStringList; listIndex: integer) : string;
{
 Convert date portion from yyyy/mm/dd to mm/dd/yyyy
}
var
  //thisListItem: TListItem;
  thisDateTime: string[16];
  tempDt: string;
  tempYr: string;
  tempTime: string;
  newDtTime: string;
  k: byte;
  piece1: string;
  piece2: string;
  piece3: string;
  piece4: string;
  piece5: string;
  piece6: string;
  piece7: string;
  piece8: string;
  piece9: string;
  piece10: string;
  piece11: string;
begin
  piece1 := '';
  piece2 := '';
  piece3 := '';
  piece4 := '';
  piece5 := '';
  piece6 := '';
  piece7 := '';
  piece8 := '';
  piece9 := '';
  piece10 := '';
  piece11 := '';

  piece1 := Piece(thisList[listIndex],U,1);
  piece2 := Piece(thisList[listIndex],U,2);
  piece3 := Piece(thisList[listIndex],U,3);
  piece4 := Piece(thisList[listIndex],U,4);
  //piece5 := Piece(thisList[listIndex],U,5);
  piece6 := Piece(thisList[listIndex],U,6);
  piece7 := Piece(thisList[listIndex],U,7);
  piece8 := Piece(thisList[listIndex],U,8);
  piece9 := Piece(thisList[listIndex],U,9);
  piece10 := Piece(thisList[listIndex],U,1);

  thisDateTime := Piece(thisList[listIndex],U,5);

  tempYr := '';
  for k := 1 to 4 do
   tempYr := tempYr + thisDateTime[k];

  tempDt := '';
  for k := 6 to 10 do
   tempDt := tempDt + thisDateTime[k];

  tempTime := '';
  //Use 'Length' to prevent stuffing the control chars into the date when a trailing zero is missing
  for k := 11 to Length(thisDateTime) do //16 do
   tempTime := tempTime + thisDateTime[k];

  newDtTime := '';
  newDtTime := newDtTime + tempDt + '/' + tempYr + tempTime;
  piece5 := newDtTime;

  Result := piece1 +U+ piece2 +U+ piece3 +U+ piece4 +U+ piece5 +U+ piece6 +U+ piece7 +U+ piece8 +U+ piece9 +U+ piece10 +U+ piece11;
end;

procedure TfrmPtSel.AlertList;
var
  List: TStringList;
  NewItem: TListItem;
  I,J: Integer;
  Comment: String;
begin
  // Load the items
  lstvAlerts.Items.Clear;
  List := TStringList.Create;
  NewItem := nil;
  try
     LoadNotifications(List);
     for I := 0 to List.Count - 1 do
       begin
    //   List[i] := ConvertDate(List, i);  //cla commented out 8/9/04 CQ #4749

         if Piece(List[I], U, 1) <> 'Forwarded by: ' then
           begin
              NewItem := lstvAlerts.Items.Add;
              NewItem.Caption := Piece(List[I], U, 1);
              for J := 2 to DelimCount(List[I], U) + 1 do
                 NewItem.SubItems.Add(Piece(List[I], U, J));
           end
         else   //this list item is forwarding information
           begin
             NewItem.SubItems[5] := Piece(List[I], U, 2);
             Comment := Piece(List[I], U, 3);
             if Length(Comment) > 0 then NewItem.SubItems[8] := 'Fwd Comment: ' + Comment;
           end;
       end;
   finally
      List.Free;
   end;
   with lstvAlerts do
     begin
        Columns[0].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 1), 40);          //Info                 Caption
        Columns[1].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 2), 195);         //Patient              SubItems[0]
        Columns[2].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 3), 75);          //Location             SubItems[1]
        Columns[3].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 4), 95);          //Urgency              SubItems[2]
        Columns[4].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 5), 150);         //Alert Date/Time      SubItems[3]
        Columns[5].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 6), 310);         //Message Text         SubItems[4]
        Columns[6].Width := StrToIntDef(Piece(frmFrame.EnduringPtSelColumns, ',', 7), 290);         //Forwarded By/When    SubItems[5]
     //Items not displayed in Columns:     XQAID                SubItems[6]
     //                                    Remove w/o process   SubItems[7]
     //                                    Forwarding comments  SubItems[8]
     end;
end;

procedure TfrmPtSel.lstvAlertsColumnClick(Sender: TObject; Column: TListColumn);
begin

  if (FsortCol = Column.Index) then
     FsortAscending := not FsortAscending;

  if FsortAscending then
     FsortDirection := 'F'
  else
     FsortDirection := 'R';

  FsortCol := Column.Index;

  if FsortCol = 4 then
    ReformatAlertDateTime //  hds7397- ge 2/6/6 sort and display date/time column correctly - as requested
  else
     lstvAlerts.AlphaSort;

  //Set the Notifications sort method to last-used sort-type
  //ie., user clicked on which column header last use of CPRS?
  case Column.Index of
     0: rCore.SetSortMethod('I', FsortDirection);
     1: rCore.SetSortMethod('P', FsortDirection);
     2: rCore.SetSortMethod('L', FsortDirection);
     3: rCore.SetSortMethod('U', FsortDirection);
     4: rCore.SetSortMethod('D', FsortDirection);
     5: rCore.SetSortMethod('M', FsortDirection);
     6: rCore.SetSortMethod('F', FsortDirection);
  end;
end;

procedure TfrmPtSel.lstvAlertsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if not(Sender is TListView) then Exit;
  if FsortAscending then
    begin
      if FsortCol = 0 then Compare := CompareStr(Item1.Caption, Item2.Caption)
      else Compare := CompareStr(Item1.SubItems[FsortCol - 1], Item2.SubItems[FsortCol - 1]);
    end
  else
    begin
      if FsortCol = 0 then Compare := CompareStr(Item2.Caption, Item1.Caption)
      else Compare := CompareStr(Item2.SubItems[FsortCol - 1], Item1.SubItems[FsortCol - 1]);
    end;
end;

function TfrmPtSel.DupLastSSN(const DFN: string): Boolean;
var
  i: integer;
  frmPtDupSel: tForm;
begin
  Result := False;

  // Check data on server for duplicates:
  CallV('DG CHK BS5 XREF ARRAY', [DFN]);
  if (RPCBrokerV.Results[0] <> '1') then // No duplicates found.
    Exit;
  Result := True;
  PtStrs := TStringList.Create;
  with RPCBrokerV do if Results.Count > 0 then
  begin
    for i := 1 to Results.Count - 1 do
    begin
      if Piece(Results[i], U, 1) = '1' then
        PtStrs.Add(Piece(Results[i], U, 2) + U + Piece(Results[i], U, 3) + U +
                   FormatFMDateTimeStr('mmm dd,yyyy', Piece(Results[i], U, 4)) + U +
                   Piece(Results[i], U, 5));
    end;
  end;

  // Call form to get user's selection from expanded duplicate pt. list (resets DupDFN variable if applicable):
  DupDFN := DFN;
  frmPtDupSel:= TfrmDupPts.Create(Application);
  with frmPtDupSel do
    begin
      try
        ShowModal;
      finally
        frmPtDupSel.Release;
      end;
    end;
end;

procedure TfrmPtSel.ShowFlagInfo;
begin
  if (Pos('*SENSITIVE*',frmPtSelDemog.lblPtSSN.Caption)>0) then
  begin
//    pnlPrf.Visible := False;
    Exit;
  end;
  if (flastpt <> cboPatient.ItemID) then
  begin
    HasActiveFlg(FlagList, HasFlag, cboPatient.ItemID);
    flastpt := cboPatient.ItemID;
  end;
  if HasFlag then
  begin
//    FastAssign(FlagList, lstFlags.Items);
//    pnlPrf.Visible := True;
  end
  //else pnlPrf.Visible := False;
end;

procedure TfrmPtSel.lstFlagsClick(Sender: TObject);
begin
{  if lstFlags.ItemIndex >= 0 then
     ShowFlags(lstFlags.ItemID); }
end;

procedure TfrmPtSel.lstFlagsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    lstFlagsClick(Self);
end;

procedure TfrmPtSel.lstvAlertsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if ScreenReaderSystemActive then
  begin
    FAlertsNotReady := TRUE;
    PostMessage(Handle, UM_MISC, 0, 0);
  end
  else
    ReadyAlert;
end;

procedure TfrmPtSel.mnuMultiTIUSignClick(Sender: TObject);
//kt added 9/10/20
begin
  inherited;
  ShowMultiAlertsSign(lstvAlerts.Items);
  AlertList;  //refresh alerts
end;

procedure TfrmPtSel.PatientImageClick(Sender: TObject);
//kt added procedure 4/14/14
var frmPatientPhotoID : TfrmPatientPhotoID;
begin
  inherited;
  frmPatientPhotoID:= TfrmPatientPhotoID.Create(Self);
  if frmPatientPhotoID.ShowModal(cboPatient.ItemID,False) = mrOK then begin
    //ShowIDInfo;  //no refresh needed, photos cannot be added at this point
  end;
  frmPatientPhotoID.Free;
end;

procedure TfrmPtSel.PatientImageMouseEnter(Sender: TObject);
var refresh : boolean;
begin
  inherited;
  try
    if not assigned(frmPatientPhotoID) then frmPatientPhotoID:= TfrmPatientPhotoID.Create(Self);
    frmPatientPhotoID.ShowPreviewMode(cboPatient.ItemID,Self.PatientImage,ltLeft);
  except
    //On E : exception do messagedlg('Error on Mouse Enter'+#13#10+E.Message,mtError,[mbok],0);
  end;
end;

procedure TfrmPtSel.PatientImageMouseLeave(Sender: TObject);
begin
  inherited;
  try
    if assigned(frmPatientPhotoID) then frmPatientPhotoID.hide;
  except
    //On E : exception do messagedlg('Error on Mouse Leave'+#13#10+E.Message,mtError,[mbok],0);
  end;

end;

{    previous code
procedure TfrmPtSel.PatientImageMouseEnter(Sender: TObject);
var refresh : boolean;
begin
  inherited;
  frmPatientPhotoID:= TfrmPatientPhotoID.Create(Self);
  frmPatientPhotoID.ShowPreviewMode(cboPatient.ItemID,Self.PatientImage,ltLeft);
end;


procedure TfrmPtSel.PatientImageMouseLeave(Sender: TObject);
begin
  inherited;
  if assigned(frmPatientPhotoID) then FreeAndNil(frmPatientPhotoID);

end;}

procedure TfrmPtSel.ShowButts(ShowButts: Boolean);
begin
  cmdProcess.Enabled := ShowButts;
  cmdRemove.Enabled := ShowButts;
  cmdForward.Enabled := ShowButts;
  cmdComments.Enabled := ShowButts and (lstvAlerts.SelCount = 1) and (lstvAlerts.Selected.SubItems[8] <> '');
  ShowDisabledButtonTexts;
end;

procedure TfrmPtSel.lstvAlertsInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
begin
  InfoTip := Item.SubItems[8];
end;

procedure TfrmPtSel.lstvAlertsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
{
 //KW
 508: Allow non-sighted users to sort Notifications using Ctrl + <key>
 Numbers in case stmnt are ASCII values for character keys.
}
begin
  if FAlertsNotReady then exit;
  if lstvAlerts.Focused then
     begin
     case Key of
        VK_RETURN: cmdProcessClick(Sender); //Process all selected alerts
        73,105: if (ssCtrl in Shift) then lstvAlertsColumnClick(Sender, lstvAlerts.Columns[0]); //I,i
        80,113: if (ssCtrl in Shift) then lstvAlertsColumnClick(Sender, lstvAlerts.Columns[1]); //P,p
        76,108: if (ssCtrl in Shift) then lstvAlertsColumnClick(Sender, lstvAlerts.Columns[2]); //L,l
        85,117: if (ssCtrl in Shift) then lstvAlertsColumnClick(Sender, lstvAlerts.Columns[3]); //U,u
        68,100: if (ssCtrl in Shift) then lstvAlertsColumnClick(Sender, lstvAlerts.Columns[4]); //D,d
        77,109: if (ssCtrl in Shift) then lstvAlertsColumnClick(Sender, lstvAlerts.Columns[5]); //M,m
        70,102: if (ssCtrl in Shift) then lstvAlertsColumnClick(Sender, lstvAlerts.Columns[6]); //F,f
     end;
     end;
end;

procedure TfrmPtSel.lstvAlertsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FMouseUpPos := Point(X,Y);
end;

procedure TfrmPtSel.FormShow(Sender: TObject);
{
 //KW
 Sort Alerts by last-used method for current user
}
var
  sortResult: string;
  sortMethod: string;
begin
  sortResult := rCore.GetSortMethod;
  sortMethod := Piece(sortResult, U, 1);
  if sortMethod = '' then
     sortMethod := 'D';
  FsortDirection := Piece(sortResult, U, 2);
  if FsortDirection = 'F' then
     FsortAscending := true
  else
     FsortAscending := false;

  case sortMethod[1] of
     'I','i': lstvAlertsColumnClick(Sender, lstvAlerts.Columns[0]);
     'P','p': lstvAlertsColumnClick(Sender, lstvAlerts.Columns[1]);
     'L','l': lstvAlertsColumnClick(Sender, lstvAlerts.Columns[2]);
     'U','u': lstvAlertsColumnClick(Sender, lstvAlerts.Columns[3]);
     'D','d': lstvAlertsColumnClick(Sender, lstvAlerts.Columns[4]);
     'M','m': lstvAlertsColumnClick(Sender, lstvAlerts.Columns[5]);
     'F','f': lstvAlertsColumnClick(Sender, lstvAlerts.Columns[6]);
  end;

end;

//hds7397- ge 2/6/6 sort and display date/time column correctly - as requested
procedure TfrmPtSel.ReadyAlert;
begin
  if lstvAlerts.SelCount <= 0 then ShowButts(False)
  else ShowButts(True);
  GetBAStatus(User.DUZ,Patient.DFN);
  FAlertsNotReady := FALSE;
end;

procedure  TfrmPtSel.ReformatAlertDateTime;
var
  I,J: Integer;
  inDateStr, holdDayTime,srtDate: String;
begin
  // convert date to yyyy/mm/dd prior to sort.
 for J := 0 to lstvAlerts.items.count -1 do
  begin
    inDateStr := '';
    srtDate := '';
    holdDayTime := '';
    inDateStr := lstvAlerts.Items[j].SubItems[3];
    srtDate := ( (Piece( Piece(inDateStr,'/',3), '@',1)) + '/' + Piece(inDateStr,'/',1) + '/' + Piece(inDateStr,'/',2) +'@'+ Piece(inDateStr, '@',2) );
    lstvAlerts.Items[j].SubItems[3] := srtDate;
  end;
   //sort the listview records by date
  lstvAlerts.AlphaSort;
 // loop thru lstvAlerts change date to yyyy/mm/dd
 // sort list
 // change alert date/time back to mm/dd/yyyy@time for display
  for I := 0 to lstvAlerts.items.Count -1 do
   begin
     inDateStr := '';
     srtDate := '';
     holdDayTime := '';
     inDateStr :=   lstvAlerts.Items[i].SubItems[3];
     holdDayTime := Piece(inDateStr,'/',3);  // dd@time
     lstvAlerts.Items[i].SubItems[3] := (Piece(inDateStr, '/', 2) + '/' + Piece(holdDayTime, '@',1) +'/'
                                            + Piece(inDateStr,'/',1) + '@' + Piece(holdDayTime,'@',2) );
  end;
end;

procedure TfrmPtSel.AdjustButtonSize(pButton:TButton);
var
thisButton: TButton;
const Gap = 5;
begin
    thisButton := pButton;
    if thisButton.Width < frmFrame.Canvas.TextWidth(thisButton.Caption) then      //CQ2737  GE
    begin
       FNotificationBtnsAdjusted := (thisButton.Width < frmFrame.Canvas.TextWidth(thisButton.Caption));
       thisButton.Width := (frmFrame.Canvas.TextWidth(thisButton.Caption) + Gap+Gap);    //CQ2737  GE
    end;
    if thisButton.Height < frmFrame.Canvas.TextHeight(thisButton.Caption) then    //CQ2737  GE
       thisButton.Height := (frmFrame.Canvas.TextHeight(thisButton.Caption) + Gap);   //CQ2737  GE
end;

procedure TfrmPtSel.AdjustNotificationButtons;
const
  Gap = 10; BigGap = 40;
 // reposition buttons after resizing eliminate overlap.
begin
 if FNotificationBtnsAdjusted then
 begin
   cmdProcessAll.Left := (cmdProcessInfo.Left + cmdProcessInfo.Width + Gap);
   cmdProcess.Left    := (cmdProcessAll.Left + cmdProcessAll.Width + Gap);
   cmdForward.Left    := (cmdProcess.Left + cmdProcess.Width + Gap);
   cmdComments.Left   := (cmdForward.Left + cmdForward.Width + Gap);
   cmdRemove.Left     := (cmdComments.Left + cmdComments.Width + BigGap);
 end;
end;

procedure TfrmPtSel.TMGcmdAddClick(Sender: TObject);
//kt 9/11 added function
var
  frmPtAdd: TfrmPtAdd;  //kt 9/25/15
begin
 frmPtAdd := TfrmPtAdd.Create(Self);
 {NOTE:  9/25/15 -- I have added line above, which means that frmPtAdd will never = nil
        which means that a new patient CAN now be added before CPRS finishes starting up.
        I will need to check and see if this is a problems.
        I am changing this to minimize the number of auto-created forms, changing to
        make everything to be created just when actually needed.  //kt
 }
 if frmPtAdd <> nil then begin
   self.hide;
   frmPtAdd.Showmodal;
   self.show;
   if frmPtAdd.DFN > 0 then begin
     if cboPatient.SelectByIEN(frmPtAdd.DFN) = -1 then begin
       MessageDlg('Patient successfully added.' +#10+#13+
                  'You may now type in patient name to select it.'+#10+#13+
                  #10+#13+
                  'Additional demographics may be entered from Demographics Page'+#10+#13+
                  '(Cover Sheet tab --> View Demographics menu --> Edit Patient button.)',
                  mtInformation,[mbOK],0);
     end;
   end;
 end else begin
   MessageDlg('CPRS has not completed log in.'+#10+#13+
              'Adding a new patient not allowed now.'+#10+#13+
              #10+#13+
              'Please choose an existing patient and retry later.',
              mtInformation, [mbOK],0);
 end;
 frmPtAdd.Free;
end;

//vwpt enhanced //
procedure TfrmPtSel.onclick1(Sender: TObject);  //click on RadioGroup1
var index :integer;

begin
if RadioGroup1.ItemIndex >0 then
 begin
     itimson := 1  ;
     cboPatient.Text := '' ;
     if (frmPtSelOptns.radAll.Checked <> True)and (frmPtSelOptns.radDflt.Checked <> True) then
     begin
        radiogrp1index :=0  ;
        RadioGroup1.ItemIndex  := 0;
        RadioGroup1.SetFocus;
        RadioGroup1.Refresh;
     end
     else
     begin
          index := RadioGroup1.ItemIndex;
          radiogrp1index := index;
          cboPatient.Hint  := 'Enter ' + piece(RadioGroup1.Items[index],'&',2);
     end ;
 end
 else
 begin
       //itimson := 0;
        cboPatient.Hint :=  'Enter name,Full SSN,Last4(x1234),''HRN'',DOB,or Phone#'  ;
        radiogrp1index := 0;
 end;

end;
 //end vwpt enhanced

procedure TfrmPtSel.btnRefreshClick(Sender: TObject);
begin
  inherited;
  AlertList;
end;

procedure TfrmPtSel.btnSearchPtClick(Sender: TObject);
//kt 9/11 added
var InfoStr : string;
    IEN : int64;
    boolSearchOK : Boolean;
    frmPtQuery: TfrmPtQuery;
begin
  if not assigned(frmPtQuery) then frmPtQuery := TfrmPtQuery.Create(Self);
  frmPtQuery.InitializeForm('PATIENT', 2);
  boolSearchOK := frmPtQuery.ShowModal = mrOK;
  if boolSearchOK then begin
    cboPatient.InitLongList(frmPtQuery.SelectedName);
    IEN := StrToInt64Def(frmPtQuery.SelectedIEN,0);
    if IEN < 1 then exit;
    cboPatient.SelectByIEN(IEN);
    if cboPatient.ItemID = frmPtQuery.SelectedIEN then begin
      InfoStr := cboPatient.Items[cboPatient.ItemIndex];
    end else begin
      InfoStr := '';
    end;
    //OpenPatient(frmPtQuery.SelectedIEN, InfoStr);
    //Note: OpenPatient was used in prior version, but wasn't working properly, so not ported forward
    //      Find alternative method later
  end;
  FreeAndNil(frmPtQuery);
  if boolSearchOK then cmdOKClick(Sender);
end;
end.
