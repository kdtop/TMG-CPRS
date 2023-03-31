unit fVisitType;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, CheckLst, ORCtrls, ExtCtrls, Buttons, uPCE, rPCE, ORFn, rCore,
  StrUtils, //kt
  ComCtrls, mVisitRelated, VA508AccessibilityManager;

type
  TfrmVisitType = class(TfrmPCEBase)
    pnlTop: TPanel;
    splLeft: TSplitter;
    splRight: TSplitter;
    pnlLeft: TPanel;
    lstVTypeSection: TORListBox;
    pnlMiddle: TPanel;
    fraVisitRelated: TfraVisitRelated;
    pnlSC: TPanel;
    lblSCDisplay: TLabel;
    memSCDisplay: TCaptionMemo;
    pnlBottom: TPanel;
    btnAdd: TButton;
    btnDelete: TButton;
    btnPrimary: TButton;
    pnlBottomLeft: TPanel;
    lblProvider: TLabel;
    cboPtProvider: TORComboBox;
    pnlBottomRight: TPanel;
    lbProviders: TORListBox;
    lblCurrentProv: TLabel;
    lblVTypeSection: TLabel;
    pnlModifiers: TPanel;
    lbMods: TORListBox;
    lblMod: TLabel;
    pnlSection: TPanel;
    lbxVisits: TORListBox;
    lblVType: TLabel;
    btnNext: TBitBtn;
    procedure btnNextClick(Sender: TObject);
    procedure lstVTypeSectionClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnPrimaryClick(Sender: TObject);
    procedure cboPtProviderDblClick(Sender: TObject);
    procedure cboPtProviderChange(Sender: TObject);
    procedure cboPtProviderNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
    procedure lbProvidersChange(Sender: TObject);
    procedure lbProvidersDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbxVisitsClickCheck(Sender: TObject; Index: Integer);
    procedure lbModsClickCheck(Sender: TObject; Index: Integer);
    procedure lbxVisitsClick(Sender: TObject);
    procedure memSCDisplayEnter(Sender: TObject);
  protected
    FSplitterMove: boolean;
    //kt procedure CheckModifiers;
  private
    //FVisitType: TPCEProc;
    FVisitTypesList: TPCEProcList;    //kt added. Local copy.  List of TPCEProc objects.  Will be put back into PCE in TfrmEncounterFrame.UpdateEncounter
    ListOfPotentialVisitCodes: TStringList; //this is a list of all visit-type CPT's that could be chosen between  //kt added
    FChangingSections : boolean;
    FChecking: boolean;
    FCheckingMods: boolean;
    FLastCPTCodes: string;
    //kt removed.  Wasn't being used --> FLastMods: string;
    procedure RefreshProviders;
    procedure UpdateProviderButtons;
    procedure SetVisitType(index : integer;  Value: TPCEProc);   //kt added
    function GetVisitType(index : integer) : TPCEProc; //kt added
    //kt procedure VisitTypeSectionsToForm;  //kt moved public -> private  And Renamed. Was MatchVType
    procedure InitSectionColumnWithoutData;  //kt added
    procedure SetSectionColumnFromData;  //kt added
    procedure InitCodesColumn;    //kt added
    procedure InitModifierColumn; //kt added
    procedure SetupModifiers(SelectedData : string); //kt renamed.  Was ShowModifiers
    procedure SetupLbxVisitsAndModifiers(ItemIEN : Int64); //kt added
    procedure UpdateOutput; //kt added
  public
    procedure EnsureCPTs(List : TStringList);
    procedure InitializeWithoutData; //kt added
    procedure InitFromPCE(PCEData: TPCEData);  //kt added
    //kt property VisitType : TPCEProc read FVisitType write SetVisitType;
    property VisitType[index : integer] : TPCEProc read GetVisitType write SetVisitType; //kt added
    property VisitTypesList: TPCEProcList read FVisitTypesList; //kt added
  end;

var
  frmVisitType: TfrmVisitType;
  USCchecked:boolean = false;
//  PriProv: Int64;
  PriProv: Int64;

const
  LBCheckWidthSpace = 18;

implementation

{$R *.DFM}

uses
  fEncounterFrame, uCore, uConst, VA508AccessibilityRouter;

const
  FN_NEW_PERSON = 200;

procedure TfrmVisitType.EnsureCPTs(List : TStringList);
//Purpose: Take list of CPT's (free text) and ensure entered into PCE data.
//Format:  Each line of List should have 1 CPT code.  E.g. 99213 or 99445x2 <-- x2 means multiplier of 2
var i,j : integer;
    OneCPT : string;
    countStr : string;
    count : integer;
    data : string;
    x : string;
    AVisit : TPCEProc;
begin
  for i := 0 to List.Count - 1 do begin
    OneCPT := List.Strings[i];
    countStr := piece(OneCPT,'x',2);
    if countStr <> '' then begin
      count := StrToIntDef(countStr,0);
      OneCPT := piece(OneCPT,'x',1);
    end else begin
      count := 0;
    end;
    for j := 0 to ListOfPotentialVisitCodes.Count - 1 do begin
      data := ListOfPotentialVisitCodes.Strings[j];  //format e.g.: '99202^NEW PATIENT^Limited Exam        16-25 Min'
      if piece(data,U,1) <> OneCPT then continue;
      //set up x
      //  piece  2  -> Code
      //         3  -> Category
      //         4  -> Narrative
      //         5  -> Quantity
      //         6  -> Provider
      //         9  -> Modifiers
      //         10 -> Comment
      x := 'TMG' + U + Pieces(data, U, 1, 3) + U + IntToStr(count) + U + IntToStr(User.DUZ);  //'TMG' is not used, just placeholder
      FVisitTypesList.EnsureFromString(x);
      SetupLbxVisitsAndModifiers(lstVTypeSection.ItemIEN);
      break;
    end;
  end;

end;


procedure TfrmVisitType.InitFromPCE(PCEData: TPCEData);  //kt added
begin
  InitializeWithoutData;
  //kt removed.  We don't use this functionality --> fraVisitRelated.InitRelated(uEncPCEData); //kt moved here from TfrmEncounterFrame.SynchPCEData
  ListVisitTypeByLoc(ListOfPotentialVisitCodes, PCEData.Location, PCEData.DateTime);
  FVisitTypesList.Assign(PCEData.VisitTypesList);
  SetSectionColumnFromData;  //sets up lstVTypeSelection
  SetupLbxVisitsAndModifiers(lstVTypeSection.ItemIEN); //kt  Local copy.  Data will be put back into PCE in TfrmEncounterFrame.UpdateEncounter
  UpdateOutput; //kt
end;

function TfrmVisitType.GetVisitType(index : integer) : TPCEProc; //kt added
begin
  if FVisitTypesList.ValidIndex(index) then begin
    Result := FVisitTypesList.Proc[index];
  end else begin
    Result := nil;
  end;
end;

procedure TfrmVisitType.SetVisitType(index : integer;  Value: TPCEProc);   //kt added
begin
  if not FVisitTypesList.ValidIndex(index) then exit;
  FVisitTypesList.Proc[index].Assign(Value);
end;

procedure TfrmVisitType.InitSectionColumnWithoutData; //kt added
//This JUST puts available options into form.
//  It doesn't add selections etc from PCE DATA
//  It also doesn't trigger any loading of any other column.
begin
  FChangingSections := true;
  try
    ListVisitTypeSections(lstVTypeSection.Items);
    if lstVTypeSection.Items.Count = 0 then lstVTypeSection.Items.Add(TX_NOSECTION);
  finally
    FChangingSections := false;
  end;
end;

procedure TfrmVisitType.SetSectionColumnFromData;  //kt added
//Put PCE data FVisitTypesList into GUI form
var
  i,j  : Integer;
  AProc : TPCEProc;
  AProcStr : string;
  Index : integer;
begin
  FChangingSections := true;
  try
    Index := -1;
    //Find first active VisitProc in FVisitTypesList, and set selection index to it's category
    for i := 0 to FVisitTypesList.Count - 1 do begin
      AProc := FVisitTypesList.Proc[i]; if not Assigned(AProc) then continue;
      if (AProc.Deleted) or (AProc.Code='') or (AProc.Inactive) then continue;
      AProcStr := AProc.Code + U + AProc.Narrative;
      for j := 0 to lstVTypeSection.Items.Count - 1 do begin  //This is left-most column (sections, e.g. New, Existing, Consults)
        if Piece(lstVTypeSection.Items[j], U, 2) = AProc.Category then begin
          Index := j;
          break;
        end;
      end;
      if index > -1 then break;
    end;
    if (Index = -1) and (lstVTypeSection.Items.Count > 0) then Index := 0;
    lstVTypeSection.ItemIndex := Index;
  finally
    FChangingSections := false;
  end;
end;


procedure TfrmVisitType.InitCodesColumn;  //kt added
begin
  FChecking := true;
  lbxVisits.Items.Clear;
  FChecking := false;
end;

procedure TfrmVisitType.InitModifierColumn;  //kt added
begin
  FCheckingMods := true;
  lbMods.Items.Clear;
  lblMod.Caption := '';
  lbMods.Caption := '';
  lblMod.Hint := '';
  FCheckingMods := false;
end;

procedure TfrmVisitType.InitializeWithoutData; //kt added

  {
  //moved here from TfrmEncounterFrame.SynchPCEData;
  procedure InitList(AListBox: TORListBox);
  var DoClick: boolean;
  begin
    with AListBox do begin
      ListVisitTypeSections(Items);
      DoClick := AutoSelectVisit(PCERPCEncLocation);
      if Items.Count > 0 then begin
        if DoClick then begin
          ItemIndex := 0;
          //kt SectionClick(AListBox);
          lstVTypeSectionClick(self); //kt replace above
        end;
      end else Items.Add(TX_NOSECTION);
    end;
  end;
  }

begin
  //moved here from TfrmEncounterFrame.SynchPCEData;
  //kt not needed, done below --> InitList(lstVTypeSection);                     // set up Visit Type page
  //kt removed.  We don't use this functionality --> ListSCDisabilities(memSCDisplay.Lines);
  //kt removed.  We don't use this functionality --> uSCCond := EligbleConditions;
  //kt removed.  We don't use this functionality --> fraVisitRelated.InitAllow(uSCCond);

  //kt code
  InitSectionColumnWithoutData;
  InitCodesColumn;
  InitModifierColumn;
end;

{ //kt changed code such that this is not called.
procedure TfrmVisitType.VisitTypeSectionsToForm;  //was MatchVType
var
  i,j,k : Integer;
  AProc : TPCEProc;
  AProcStr : string;
  lbxData : string;
  ItemForlbxVisits : integer;
begin
  with FVisitType do begin   //kt changed uVisitType -> FVisitType
    if Code = '' then Exit;
    Found := False;
    with lstVTypeSection do for i := 0 to Items.Count - 1 do begin
      if Piece(Items[i], U, 2) = Category then begin
        ItemIndex := i;
        lstVTypeSectionClick(Self);
        Found := True;
        break;
      end;
    end;
    if Found then for i := 0 to lbxVisits.Items.Count - 1 do begin
      if Pieces(lbxVisits.Items[i], U, 1, 2) = Code + U + Narrative then begin
        lbxVisits.ItemIndex := i;
        FChecking := TRUE;
        try
          lbxVisits.Checked[i] := True;
          lbxVisitsClickCheck(Self, i);
        finally
          FChecking := FALSE;
        end;
      end;
    end;
  end;
end;
}

procedure TfrmVisitType.SetupLbxVisitsAndModifiers(ItemIEN : Int64); //Data -> GUI
//kt added, moving code out of lstVTypeSectionClick
//ItemIEN is lstVTypeSection.ItemIEN
var  i: Integer;
     ItemForlbxVisits : integer;
     AVisit : TPCEProc;
     Checked : boolean; //kt added

begin
  ListVisitTypeCodes(lbxVisits.Items, ItemIEN, FVisitTypesList);  //kt Populate lbxVisits -- including linked Visits object.  Aded FVisitTypesList
  lbxVisits.ItemIndex := -1;  //default
  ItemForlbxVisits := -1;
  FChecking := TRUE;
  try
    for i := 0 to lbxVisits.Items.Count - 1 do begin
      AVisit := TPCEProc(lbxVisits.Items.Objects[i]); //likely nil
      lbxVisits.Checked[i] := Assigned(AVisit);
      if Assigned(AVisit) then ItemForlbxVisits := i;
    end;
    if ItemForlbxVisits > -1 then begin
      lbxVisits.ItemIndex := ItemForlbxVisits;
      UpdateVisitTypeModifierList(lbxVisits, ItemForlbxVisits); //kt added
      //lbxVisitsClick(Self);
      SetupModifiers(lbxVisits.Items[ItemForlbxVisits]);
    end else begin
      InitModifierColumn;
    end;
  finally
    FChecking := FALSE;
  end;
end;

procedure TfrmVisitType.lstVTypeSectionClick(Sender: TObject);
//kt  This doesn't change data.  Just modifies GUI form.
begin
  inherited;
  if FChangingSections then exit; //kt added.
  SetupLbxVisitsAndModifiers(lstVTypeSection.ItemIEN); //kt

  { //kt original below
  with uVisitType do for i := 0 to lbxVisits.Items.Count - 1 do begin
    if ((uVisitType <> nil) and (Pieces(lbxVisits.Items[i], U, 1, 2) = Code + U + Narrative)) then begin
      FChecking := TRUE;
      try
        lbxVisits.Checked[i] := True;
        lbxVisits.ItemIndex := i;
      finally
        FChecking := FALSE;
      end;
    end;
  end;
  lbxVisitsClick(Self);
  }
end;

procedure TfrmVisitType.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  //process before closing

end;

(*function ExposureAnswered: Boolean;
begin
  result := false;
  //if SC answered set result = true
end;*)


procedure TfrmVisitType.RefreshProviders;
var
  i: integer;
  ProvData: TPCEProviderRec;
  ProvEntry: string;

begin
  lbProviders.Clear;
  for i := 0 to uProviders.count-1 do
  begin
    ProvData := uProviders[i];
    ProvEntry := IntToStr(ProvData.IEN) + U + ProvData.Name;
    if(ProvData.Primary) then
      ProvEntry := ProvEntry + ' (Primary)';
    lbProviders.Items.Add(ProvEntry);
  end;
  UpdateProviderButtons;
end;

procedure TfrmVisitType.FormCreate(Sender: TObject);
var
  AIEN: Int64;

begin
  inherited;
  ListOfPotentialVisitCodes := TStringList.Create; //kt added
  //FVisitType := TPCEProc.create;   //kt added
  FVisitTypesList:= TPCEProcList.Create; //kt added
  FTabName := CT_VisitNm;
  FSectionTabCount := 2;
  FormResize(Self);
  AIEN := uProviders.PendingIEN(TRUE);
  if(AIEN = 0) then begin
    AIEN := uProviders.PendingIEN(FALSE);
    if(AIEN = 0) then begin
      cboPtProvider.InitLongList(User.Name);
      AIEN := User.DUZ;
    end else begin
      cboPtProvider.InitLongList(uProviders.PendingName(FALSE));
    end;
    cboPtProvider.SelectByIEN(AIEN);
  end else begin
    cboPtProvider.InitLongList(uProviders.PendingName(TRUE));
    cboPtProvider.SelectByIEN(AIEN);
  end;
  RefreshProviders;
  //kt removed.  Wasn't being used --> FLastMods := uEncPCEData.VisitType.Modifiers;
  fraVisitRelated.TabStop := FALSE;
  //kt begin mod  1/19/2023
  fraVisitRelated.visible := false;
  //pnlSC.visible := false;
  //pnlMiddle.Height := 2;
  pnlMiddle.Height := 80;
  memSCDisplay.Caption := 'Output';
  memSCDisplay.Color := clCream;
  lblSCDisplay.Caption := 'Output';
  btnNext.Height := 32;
  btnNext.Top := Self.Height - btnNext.Height - 1;
  //kt end mod

end;

procedure TfrmVisitType.FormDestroy(Sender: TObject);
begin
  inherited;
  ListOfPotentialVisitCodes.Free; //kt added
  FVisitTypesList.FreeAndClearItems; //kt added
  FVisitTypesList.Free; //kt added
end;

(*procedure TfrmVisitType.SynchEncounterProvider;
// add the Encounter.Provider if this note is for the current encounter
var
  ProviderFound, PrimaryFound: Boolean;
  i: Integer;
  AProvider: TPCEProvider;
begin
  if (FloatToStrF(uEncPCEData.DateTime, ffFixed, 15, 4) =      // compensate rounding errors
      FloatToStrF(Encounter.DateTime,   ffFixed, 15, 4)) and
     (uEncPCEData.Location = Encounter.Location) and
     (Encounter.Provider > 0) then
  begin
    ProviderFound := False;
    PrimaryFound := False;
    for i := 0 to ProviderLst.Count - 1 do
    begin
      AProvider := TPCEProvider(ProviderLst.Items[i]);
      if AProvider.IEN = Encounter.Provider then ProviderFound := True;
      if AProvider.Primary = '1' then PrimaryFound := True;
    end;
    if not ProviderFound then
    begin
      AProvider := TPCEProvider.Create;
      AProvider.IEN := Encounter.Provider;
      AProvider.Name := ExternalName(Encounter.Provider, FN_NEW_PERSON);
      if not PrimaryFound then
      begin
        AProvider.Primary := '1';
        uProvider := Encounter.Provider;
      end
      else AProvider.Primary := '0';
      AProvider.Delete := False;
      ProviderLst.Add(AProvider);
    end;
  end;
end;
*)

procedure TfrmVisitType.UpdateProviderButtons;
var
  ok: boolean;

begin
  ok := (lbProviders.ItemIndex >= 0);
  btnDelete.Enabled := ok;
  btnPrimary.Enabled := ok;
  btnAdd.Enabled := (cboPtProvider.ItemIEN <> 0);
end;

procedure TfrmVisitType.btnAddClick(Sender: TObject);
begin
  inherited;
  uProviders.AddProvider(IntToStr(cboPTProvider.ItemIEN), cboPTProvider.Text, FALSE);
  RefreshProviders;
  lbProviders.SelectByIEN(cboPTProvider.ItemIEN);
end;

procedure TfrmVisitType.btnDeleteClick(Sender: TObject);
var
  idx: integer;

begin
  inherited;
  If lbProviders.ItemIndex = -1 then exit;
  idx := uProviders.IndexOfProvider(lbProviders.ItemID);
  if(idx >= 0) then
    uProviders.Delete(idx);
  RefreshProviders;
end;

procedure TfrmVisitType.btnNextClick(Sender: TObject);
//kt added 21/23
begin
  inherited;
  frmEncounterFrame.SelectNextTab;
end;

procedure TfrmVisitType.btnPrimaryClick(Sender: TObject);
var
  idx: integer;
  AIEN: Int64;

begin
  inherited;
  if lbProviders.ItemIndex = -1 then exit;
  AIEN := lbProviders.ItemIEN;
  idx := uProviders.IndexOfProvider(IntToStr(AIEN));
  if(idx >= 0) then
    uProviders.PrimaryIdx := idx;
  RefreshProviders;
  lbProviders.SelectByIEN(AIEN);
end;

procedure TfrmVisitType.cboPtProviderDblClick(Sender: TObject);
begin
  inherited;
  btnAddClick(Sender);
end;

procedure TfrmVisitType.cboPtProviderChange(Sender: TObject);
begin
  inherited;
  UpdateProviderButtons;
end;

procedure TfrmVisitType.cboPtProviderNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  inherited;
  if(uEncPCEData.VisitCategory = 'E') then
    cboPtProvider.ForDataUse(SubSetOfPersons(StartFrom, Direction))
  else
    cboPtProvider.ForDataUse(SubSetOfUsersWithClass(StartFrom, Direction,
                                     FloatToStr(uEncPCEData.PersonClassDate)));
end;

procedure TfrmVisitType.lbProvidersChange(Sender: TObject);
begin
  inherited;
  UpdateProviderButtons;
end;

procedure TfrmVisitType.lbProvidersDblClick(Sender: TObject);
begin
  inherited;
  btnDeleteClick(Sender);
end;

procedure TfrmVisitType.FormResize(Sender: TObject);
var
  v, i: integer;
  s: string;
  padding, size: integer;
  btnOffset: integer;
begin
  if FSplitterMove then begin
    FSplitterMove := FALSE
  end else begin
//      inherited;
    FSectionTabs[0] := -(lbxVisits.width - LBCheckWidthSpace - MainFontWidth - ScrollBarWidth);
    FSectionTabs[1] := -(lbxVisits.width - (6*MainFontWidth) - ScrollBarWidth);
    if(FSectionTabs[0] <= FSectionTabs[1]) then FSectionTabs[0] := FSectionTabs[1]+2;
    lbxVisits.TabPositions := SectionString;
    v := (lbMods.width - LBCheckWidthSpace - (4*MainFontWidth) - ScrollBarWidth);
    s := '';
    for i := 1 to 20 do begin
      if s <> '' then s := s + ',';
      s := s + inttostr(v);
      if(v<0) then
        dec(v,32)
      else
        inc(v,32);
    end;
    lbMods.TabPositions := s;
  end;
  btnOffset := btnAdd.Width div 7;
  padding := btnAdd.Width + (btnOffset * 2);
  size := (ClientWidth - padding) div 2;
  pnlBottomLeft.Width := size;
  pnlBottomRight.Width := size;
  btnAdd.Left := size + btnOffset;
  btnDelete.Left := size + btnOffset;
  btnPrimary.Left := size + btnOffset;
  btnOK.top := ClientHeight - btnOK.Height - 4;
  btnCancel.top := btnOK.Top;
  btnCancel.Left := ClientWidth - btnCancel.Width - 4;
  btnOK.Left := btnCancel.Left - btnOK.Width - 4;
  size := ClientHeight - btnOK.Height - pnlMiddle.Height - pnlBottom.Height - 8;
  pnlTop.Height := size;
end;

procedure TfrmVisitType.lbxVisitsClickCheck(Sender: TObject; Index: Integer);
//kt  GUI Form --> Data
var
  i: Integer;
  x, CurCategory: string;
  AVisit : TPCEProc; //kt
  ItemSelected : boolean; //kt

begin
  inherited;
  if FChecking or FClosing then exit;
  //kt mod -- new clode below
  i := lbxVisits.ItemIndex;
  if i = -1 then exit;
  ItemSelected := lbxVisits.Checked[i];
  UpdateVisitTypeModifierList(lbxVisits, lbxVisits.ItemIndex); //kt added
  //I am using Objects property of Items TStringList to store link to Visit TPCEProc object.
  AVisit := TPCEProc(lbxVisits.Items.Objects[i]);  //might be nil

  if ItemSelected and not Assigned(AVisit) then begin  //Item toggled to SELECTED for first time.
    CurCategory := Piece(lstVTypeSection.Items[lstVTypeSection.ItemIndex], U, 2);
    x := Pieces(lbxVisits.Items[lbxVisits.ItemIndex], U, 1, 2);
    x := 'CPT' + U +
         Piece(x, U, 1) + U +
         CurCategory + U +
         Piece(x, U, 2) + U +
         '1' + U +
         IntToStr(uProviders.PrimaryIEN);
    AVisit := VisitTypesList.EnsureFromString(x);
    lbxVisits.Items.Objects[i] := AVisit;
  end;
  if assigned(AVisit) then AVisit.Inactive := not ItemSelected;
  //KT: After this, the OnClick event will be automatically triggered
  //    and SetupModifiers is called from there.
  //-----------------------------------------------------------------------

  { //kt original code below
  for i := 0 to lbxVisits.Items.Count - 1 do begin
    if i <> lbxVisits.ItemIndex then begin
      FChecking := TRUE;
      try
        FVisitType.Modifiers := '';  //kt changed uVisitType -> FVisitType
        lbxVisits.Checked[i] := False;
      finally
        FChecking := FALSE;
      end;
    end;
  end;
  if lbxVisits.Checked[lbxVisits.ItemIndex] then with FVisitType do begin  //kt changed uVisitType -> FVisitType
    with lstVTypeSection do CurCategory := Piece(Items[ItemIndex], U, 2);
    x := Pieces(lbxVisits.Items[lbxVisits.ItemIndex], U, 1, 2);
    x := 'CPT' + U + Piece(x, U, 1) + U + CurCategory + U + Piece(x, U, 2) + U + '1' + U
        + IntToStr(uProviders.PrimaryIEN);
//      + IntToStr(uProvider);
    FVisitType.SetFromString(x);  //kt changed uVisitType -> FVisitType
  end else begin
    FVisitType.Clear;  //kt changed uVisitType -> FVisitType
    //with lstVTypeSection do CurCategory := Piece(Items[ItemIndex], U, 2);
  end;
  }
end;

procedure TfrmVisitType.SetupModifiers(SelectedData : string);
//kt  Data --> GUI form

const  //kt changed constants to all uppercase names
  MODIFIER_TXT = 'Modifiers';  //kt ModTxt = 'Modifiers';
  FOR_TXT = ' for ';           //kt ForTxt = ' for ';
  SPACES_TXT = '    ';         //kt Spaces = '    ';
  CB_STATE : array[false..true] of TCheckBoxState = (cbUnchecked, cbChecked);

var
  TopIdx: integer;
//  Needed,
  Codes, VstName, Hint, Msg: string;
  AVisit : TPCEProc; //kt
  i : integer;
  //idx, cnt, mcnt: integer;
  ModIEN: string;
  //Mods: string;
  //state: TCheckBoxState;

begin
  //kt heavily modified code below.
  Codes := piece(SelectedData,U,1) + U;
  VstName := piece(SelectedData,U,2);
  Hint := VstName;
  //Needed := piece(lbxVisit.Items[lbxVisit.ItemIndex],U,4); Don't show expired codes!
  msg := MODIFIER_TXT + IfThen(VstName <> '', FOR_TXT, '');
  lblMod.Caption := msg + VstName;
  lbMods.Caption := lblMod.Caption;
  if (pos(CRLF,Hint)>0) then Hint := ':' + CRLF + SPACES_TXT + Hint;
  lblMod.Hint := msg + Hint;

  if(FLastCPTCodes = Codes) then begin
    TopIdx := lbMods.TopIndex
  end else begin
    TopIdx := 0;
    FLastCPTCodes := Codes;
  end;
  if lbxVisits.ItemIndex < 0 then exit;
  AVisit := TPCEProc(lbxVisits.Items.Objects[lbxVisits.ItemIndex]); //may be nil

  FCheckingMods := True;
  try
    //Load lbMods.Items with relevent items from server, calling RPC if needed.
    //Format of each entry: Ref#^Description^Code. e.g. '390^Actual Item/Service Ordered^GK'
    ListCPTModifiers(lbMods.Items, Codes, ''); // Needed);     //Put all possible modifiers into form, as provided by server
    lbMods.TopIndex := TopIdx;
    //kt removed.  CheckModifiers;
    //Instead of above, I am including all code from CheckModifiers right here, below...
    if Assigned(AVisit) then begin
      {
      cnt := 0;
      Mods := ';';
      if (AVisit.Modifiers <> '') then begin  //kt mod
        //AVisit.Modifiers Format: Modifier1IEN;Modifier2IEN;Modifier3IEN;...
        inc(cnt);
        Mods := Mods + AVisit.Modifiers; //kt mod
      end;
      if (cnt = 0) and (lbxVisits.ItemIndex >= 0) then begin
        Mods := ';' + UpdateVisitTypeModifierList(lbxVisits.Items, lbxVisits.ItemIndex);
        lbxVisits.Checked[lbxVisits.ItemIndex] := True;
        cnt := 1;
      end;
      }
      for i := 0 to lbMods.Items.Count-1 do begin
        ModIEN := ';' + piece(lbMods.Items[i], U, 1) + ';';   //e.g. of lbMods.Items[i]: '390^Actual Item/Service Ordered^GK'
        lbMods.CheckedState[i] := CB_STATE[AVisit.HasModifierIEN(ModIEN)];
      end;
    end;

  finally
    FCheckingMods := false;
  end;

  {//kt original code below
  Codes := '';
  VstName := '';
  Hint := '';
  if(Codes = '') and (lbxVisits.ItemIndex >= 0) then begin
    Codes := piece(lbxVisits.Items[lbxVisits.ItemIndex],U,1) + U;
    VstName := piece(lbxVisits.Items[lbxVisits.ItemIndex],U,2);
    Hint := VstName;
//    Needed := piece(lbxVisit.Items[lbxVisit.ItemIndex],U,4); Don't show expired codes!
  end;
  msg := ModTxt;
  if(VstName <> '') then
    msg := msg + ForTxt;
  lblMod.Caption := msg + VstName;
  lbMods.Caption := lblMod.Caption;
  if(pos(CRLF,Hint)>0) then
    Hint := ':' + CRLF + Spaces + Hint;
  lblMod.Hint := msg + Hint;

  if(FLastCPTCodes = Codes) then begin
    TopIdx := lbMods.TopIndex
  end else begin
    TopIdx := 0;
    FLastCPTCodes := Codes;
  end;
  ListCPTModifiers(lbMods.Items, Codes, ''); // Needed);
  lbMods.TopIndex := TopIdx;
  CheckModifiers;
  }
end;

{
procedure TfrmVisitType.CheckModifiers;
//kt  NOTE: I have modified upstream code so that this is not called any more.
var
  i, idx, cnt, mcnt: integer;
  Code, Mods: string;
  state: TCheckBoxState;
  AVisit : TPCEProc; //kt

begin
  if lbMods.Items.Count < 1 then exit;
  AVisit := nil;  //kt added
  if lbxVisits.ItemIndex > -1 then begin  //kt added
    AVisit := TPCEProc(lbxVisits.Items.Objects[lbxVisits.ItemIndex]);
  end;
  FCheckingMods := TRUE;
  try
    cnt := 0;
    Mods := ';';
    //kt if FVisitType.Modifiers <> '' then begin  //kt changed uVisitType -> FVisitType
    if Assigned(AVisit) and (AVisit.Modifiers <> '') then begin  //kt mod
      inc(cnt);
      Mods := Mods + AVisit.Modifiers; //kt mod
      //ktMods := Mods + FVisitType.Modifiers;  //kt changed uVisitType -> FVisitType
    end;
    if(cnt = 0) and (lbxVisits.ItemIndex >= 0) then begin
      Mods := ';' + UpdateVisitTypeModifierList(lbxVisits.Items, lbxVisits.ItemIndex);
      lbxVisits.Checked[lbxVisits.ItemIndex] := True;
      cnt := 1;
    end;
    for i := 0 to lbMods.Items.Count-1 do begin
      state := cbUnchecked;
      if(cnt > 0) then begin
        Code := ';' + piece(lbMods.Items[i], U, 1) + ';';
        mcnt := 0;
        repeat
          idx := pos(Code, Mods);
          if(idx > 0) then begin
            inc(mcnt);
            delete(Mods, idx, length(Code) - 1);
          end;
        until (idx = 0);
        if mcnt >= cnt then
          State := cbChecked
        else
        if(mcnt > 0) then
          State := cbGrayed;
      end;
      lbMods.CheckedState[i] := state;
    end;
  finally
    FCheckingMods := FALSE;
  end;
end;
}

procedure TfrmVisitType.lbModsClickCheck(Sender: TObject; Index: Integer);
//kt GUI --> Data
var
  //idx: integer;
  ModIEN: string;
  Add: boolean;
  AVisit : TPCEProc; //kt
begin
  if FCheckingMods or (Index < 0) then exit;
  AVisit := nil;  //kt added
  if lbxVisits.ItemIndex > -1 then begin  //kt added
    AVisit := TPCEProc(lbxVisits.Items.Objects[lbxVisits.ItemIndex]);
  end;
  if not assigned(AVisit) then exit; //kt added

  Add := (lbMods.Checked[Index]);
  //kt ModIEN := piece(lbMods.Items[Index],U,1) + ';';
  ModIEN := piece(lbMods.Items[Index],U,1);
  //ktidx := pos(';' + ModIEN, ';' + AVisit.Modifiers);  //kt changed uVisitType -> FVisitType --> AVisit
  //kt if(idx > 0) then begin
  if AVisit.HasModifierIEN(ModIEN) then begin //kt
    if not Add then begin
      AVisit.RemoveModifierIEN(ModIEN); //kt
      //kt delete(AVisit.Modifiers, idx, length(ModIEN));  //kt changed uVisitType -> FVisitType --> AVisit
    end;
  end else begin
    if Add then begin
      //kt AVisit.Modifiers := AVisit.Modifiers + ModIEN;  //kt changed uVisitType -> FVisitType --> AVisit
      AVisit.EnsureModifierIEN(ModIEN); //kt
    end;
  end;
  UpdateOutput; //kt
end;

procedure TfrmVisitType.lbxVisitsClick(Sender: TObject);
//NOTE: lbxVisitsClickCheck is called before this when user clicks form.
//      But if lbxVisits.checked[i] value changed programatically, then JUST this function called.
var SelectedData : string;
    Index : integer; //kt
begin
  inherited;
  if FChecking then exit; //kt added
  Index := lbxVisits.ItemIndex; //kt
  SelectedData := IfThen(Index>-1, lbxVisits.Items[Index], '');
  if lbxVisits.Checked[Index] then begin
    SetupModifiers(SelectedData);
  end else begin
    InitModifierColumn; //don't show modifiers if visit is not checked.
  end;
  UpdateOutput; //kt
end;

procedure TfrmVisitType.memSCDisplayEnter(Sender: TObject);
begin
  inherited;
  memSCDisplay.SelStart := 0;
end;

procedure TfrmVisitType.UpdateOutput; //kt added
var i : integer;
    s : string;
    AVisit : TPCEProc;
    Modifiers : string;
begin
  memSCDisplay.Lines.Clear;
  for i := 0 to FVisitTypesList.Count - 1 do begin
    AVisit := FVisitTypesList.Proc[i]; //likely nil
    if not Assigned(AVisit) then continue;
    if (AVisit.Deleted) or (AVisit.Code='') or (AVisit.Inactive) then continue;
    s := AVisit.Code;
    Modifiers := AVisit.ModCodes;
    if Modifiers <> '' then s := s + ' mod ' + Modifiers;
    memSCDisplay.Lines.Add(s);
  end;
end;


initialization
  SpecifyFormIsNotADialog(TfrmVisitType);

//frmVisitType.CreateProviderList;

finalization
//frmVisitType.FreeProviderList;

end.
