unit fTMGProcedure;
{Warning: The tab order has been changed in the OnExit event of several controls.
 To change the tab order of lbSection, lbxSection, lbMods, and btnOther you must do it programatically.}

//kt  NOTE: This was copied from fProcedure because I plan significant changes.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, ComCtrls, CheckLst, ORCtrls, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  ORNet, uCore,  //kt
  fPCELex, fPCEOther, fPCEBaseGrid, fPCEBaseMain, VA508AccessibilityManager;

type
  TfrmTMGProcedures = class(TfrmPCEBaseMain)
    lblProcQty: TLabel;
    spnProcQty: TUpDown;
    txtProcQty: TCaptionEdit;
    lbMods: TORListBox;
    splRight: TSplitter;
    lblMod: TLabel;
    cboProvider: TORComboBox;
    lblProvider: TLabel;
    btnSearch: TBitBtn;
    btnClearSrch: TBitBtn;
    edtSearchTerms: TEdit;
    procedure btnSearchClick(Sender: TObject);
    procedure btnClearSrchClick(Sender: TObject);
    procedure edtSearchTermsChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure txtProcQtyChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject); override;
    procedure splRightMoved(Sender: TObject);
    procedure clbListClick(Sender: TObject);
    procedure lbGridSelect(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure lbModsClickCheck(Sender: TObject; Index: Integer);
    procedure lbSectionClick(Sender: TObject);
    procedure lbxSectionClickCheck(Sender: TObject; Index: Integer);
    procedure btnOtherClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure cboProviderNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
    procedure cboProviderChange(Sender: TObject);
    procedure lbxSectionExit(Sender: TObject);
    procedure lbModsExit(Sender: TObject);
    procedure btnOtherExit(Sender: TObject);
  private
    FSrcPCEData : TPCEData;       //pointer to PCE Data owned elsewhere
    TMGInfoPriorCPTs              : TStringList;  //fmt: 1^<PRIOR CPT code>^<CPT NAME>^<FMDT LAST USED>"
    TMGInfoEncounterCPTs          : TStringList;  // -- see notes below --
      //NOTE: TMGInfoEncounterCPTs format is:
      //      TMGInfoEncounterCPTs.strings[#] = "section name"                            //fmt of each entry: 2^HEADER^<Section Name>"
      //      TMGInfoEncounterCPTs.objects[#] = TStringList with entries for section      //fmt of ->SL[#]:    2^ENTRY^<CPT CODE>^<DISPLAY NAME>^<CPT NAME>"

    //NOTE: NodeTypeSL[] will hold pointers to TStringLists above.  Defined below.
    FCheckingCode: boolean;
    FCheckingMods: boolean;
    FLastCPTCodes: string;
    FModsReadOnly: boolean;
    FProviderChanging: boolean;
    FModsROChecked: string;
    FSearchTerms : TStringList;  //kt
    FSearchMode : boolean;  //kt
    FProgSrchEditChange : boolean;
    FProgSectionClick : boolean;
    function MissingProvider: boolean;
    procedure SetSearchMode(Mode : boolean);
    procedure ConfigureForSearchMode(SearchMode : boolean);
    function ShouldFilter(Entry : string) : boolean;  //fmt: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
    procedure ShowModifiers;
    procedure CheckModifiers;
    procedure ListTMGProcedureCodes(Dest: TStrings; IntEntryType: Integer); //kt
    procedure LoadTMGProcedureInfo(TitlesToAdd : TStringList);  //kt
  public
    function OK2SaveProcedures: boolean;
    //procedure InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc);
    procedure InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc; SrcPCEData : TPCEData);
  end;

var
  frmTMGProcedures: TfrmTMGProcedures;

implementation

{$R *.DFM}

uses
  fEncounterFrame, uConst, rCore, VA508AccessibilityRouter;

const
  TX_PROC_PROV = 'Each procedure requires selection of a Provider before it can be saved.';
  TC_PROC_PROV = 'Missing Procedure Provider';

  ENCOUNTER_STR = ''; //'Encounter Section: ';

type
  tNodeType = (PriorCPTs=1, EncounterCPTs=2);


CONST
  tNODE_FIRST = ord(PriorCPTs);
  tNODE_LAST = ord(EncounterCPTs);

var
  //NOTICE!!  If multiple instances of TfrmTMGProcedures created --> this will cause collision, overridden data, memory leak!
  NodeTypeSL : array[PriorCPTs .. EncounterCPTs] of TStringList;  //not owned here.
  //NOTE: NodeTypeSL[EncounterCPTs] format is:
  //      NodeTypeSL[EncounterCPTs].strings[#] = "section name"
  //      NodeTypeSL[EncounterCPTs].objects[#] = TStringList with entries for section

  //=============================================================================


procedure ListTMGProcedureCodesExternal(Dest: TStrings; IntEntryType: Integer);
begin
  if not Assigned(frmTMGProcedures) then exit;
  frmTMGProcedures.ListTMGProcedureCodes(Dest, IntEntryType);
end;


//=============================================================================


procedure TfrmTMGProcedures.ListTMGProcedureCodes(Dest: TStrings; IntEntryType: Integer);
//This is a call-back function that is called by ancestor(s) of this class
//It is used for loading lbxSection (right side list) when lbSection (left side list) is clicked

{Documentation data from VA system:
  uProcedures:    TStringList;  //e.g. format.  Either (for header) --> ^MISCELLANEOUS     //kt documentation
                                //                              or   -->  17000^Destruction of facial lesion^^^^^^^
                                //            P1 := cpt or icd code / ien of other items
                                //            P2 := user defined text
                                //            p6 := user defined expanded text to send to PCE
                                //            p7 := second code or item defined for line item
                                //            p8 := third code or item defined for line item
                                //            p9 := associated clinical lexicon term

    procedure rPCE.ListProcedureCodes(Dest: TStrings; SectionIndex: Integer);
    //Piece 12 are CPT Modifiers, Piece 13 is a flag indicating conversion of Piece 12 from
    //modifier code to modifier IEN (updated in UpdateModifierList routine)

    var
      i: Integer;
    begin
      Dest.Clear;
      i := SectionIndex + 1;           // first line after the section name
      while (i < uProcedures.Count) and (CharAt(uProcedures[i], 1) <> U) do
      begin
        //                                 1 ^ 2   ^                  3              ^                   4              ^               5                  ^       6
        Dest.Add(Pieces(uProcedures[i], U, 1, 2) + U + Piece(uProcedures[i], U, 1) + U + Piece(uProcedures[i], U, 12) + U + Piece(uProcedures[i], U, 13) + U + IntToStr(i));

                 //kt   17000^Destr facial lesion  ^               17000             ^     <cpt modifiers>              ^      <Flag**>                    ^ #

                  **Piece 13 is flag indicating conversion of Piece 12 from modifier code to modifier IEN (updated in UpdateModifierList routine)

        Inc(i);
      end;
    end;
}


var i : integer;
    EntryType : tNodeType;
    t, c, m, f, CodeName: string;
    SectionStr : string;
    SL : TStringList;
    Entry : string;
    Index : integer;
    SrcIndex : integer;  //index in SL

begin
  if IntEntryType >= 0 then begin
    ListProcedureCodes(Dest, IntEntryType);
    exit;
  end;
  Dest.Clear;
  IntEntryType := -IntEntryType;
  if (IntEntryType < tNODE_FIRST) or (IntEntryType > tNODE_LAST) then exit;
  EntryType := tNodeType(IntEntryType);
  SL := NodeTypeSL[EntryType]; //DEFAULT.  NOTE: SL may be changed to different TStringList below...
  if (EntryType = EncounterCPTs) then begin
    Index := lbSection.ItemIndex;
    SectionStr := lbSection.Items.Strings[Index]; //fmt: -2^<index>^<Display title>  index is # in TStringlist NodeTypeSL[EncounterCPTs]
    Index := StrToIntDef(Piece(SectionStr, '^',2), 0);
    SL := TStringList(NodeTypeSL[EncounterCPTs].Objects[Index]);
    if not assigned(SL) then exit;
  end;
  for i := 0 to SL.Count - 1 do begin
    Entry := SL.Strings[i];
    case EntryType of
      //SET UP VARS, for use below
      //--------------------------
      // c = CPT Code
      // t = CPT Name
      // m = CPT modifiers
      // f = Flag
      //--------------------------
                                //     1      2         3                4
      PriorCPTs:         begin  //fmt: 1^<PRIOR CPT>^<CPT NAME>^<FMDT LAST USED>
                           c := Piece(Entry, U, 2);         //kt CPT Code
                           t := Piece(Entry, U, 3);         //kt Problem Text
                           m := '';                         //kt CPT modifiers
                           f := '';                         //kt Flag. flag indicating conversion of modifier code to modifier IEN (updated in UpdateModifierList routine)
                         end;
                                //    1  2         3          4               5
      EncounterCPTs:     begin  //fmt 2^ENTRY^<CPT CODE>^<DISPLAY NAME>^<CPT NAME>
                           c := Piece(Entry, U, 3);         //kt CPT Code
                           t := Piece(Entry, U, 4);         //kt Display name
                           CodeName := Piece(Entry, U, 5);
                           if t= '' then begin
                             t := CodeName;                 //kt CPT name
                           end else if CodeName <> '' then begin
                             t := t + ' (' + CodeName + ')';
                           end;
                           if t = '' then t := '??';
                           m := '';                        //kt CPT modifiers
                           f := '';                        //kt Flag. flag indicating conversion of modifier code to modifier IEN (updated in UpdateModifierList routine)
                         end;
    end; //case
    SrcIndex := i ;  //NOTE: use lbSection to determine which source list is active.
    if not ShouldFilter(c + ' ' + t) then begin
      Dest.AddObject(c + U + t + U + c + U + m + U + f + U + IntToStr(i), pointer(SrcIndex)); //kt doc: CPTCode^CPTName^CPTCode^CPTModifiers^Flag^#
    end;
  end;
end;

{
procedure TfrmTMGProcedures.InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc);
var
  i: integer;
begin
  inherited;
  for i := 0 to lbGrid.Items.Count - 1 do
    TPCEProc(lbGrid.Items.Objects[i]).fIsOldProcedure := True;
end;
}


procedure TfrmTMGProcedures.InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc; SrcPCEData : TPCEData);
var TempSL : TStringList;
    TitlesToAdd : TStringList;
    i : integer;
begin
  //kt --> I DON'T want inherited.  I will achieve here instead --> inherited InitTab(ACopyProc, AListProc);
  TempSL := TStringList.Create;
  TitlesToAdd := TStringList.Create;
  try
    FSrcPCEData := SrcPCEData;  //save local pointer to outside object.
    LoadTMGProcedureInfo(TitlesToAdd);

    //kt UPDATE: I don't think I want anything from traditional VA method.  May delete TitleToAdd stuff this later if this is still true.
    //-------------
    //AListProc(TempSL);  //lbSection.Items  -- this is the traditional VA method of loading list.
    //Delete all entries except for '0^Problem List'
    //The other entries are blocks from an encounter form that can be created on the server.
    //  But it is difficult to work with, and I have replaced it with a different system
    //  that is loaded in via LoadTMGDxInfo
    for i := TempSL.Count - 1 downto 0 do begin
      if Piece(TempSL[i],'^',1) <> '0' then TempSL.Delete(i);
    end;
    for i := TitlesToAdd.Count - 1 downto 0 do begin
      TempSL.Insert(0,TitlesToAdd[i]);
    end;
    lbSection.Items.Assign(TempSL);
    ACopyProc(lbGrid.Items);
    lbSection.ItemIndex := 0;
    lbSectionClick(lbSection);
    ClearGrid;
    GridChanged;

    //below was in inherited InitTab
    for i := 0 to lbGrid.Items.Count - 1 do begin
      TPCEProc(lbGrid.Items.Objects[i]).fIsOldProcedure := True;
    end;

  finally
    TempSL.Free;
    TitlesToAdd.Free;
  end;
end;


procedure TfrmTMGProcedures.LoadTMGProcedureInfo(TitlesToAdd : TStringList);
//This is called when form first instantiated.  It gets server information and stores locally.
//   called from InitTMGTab()
var SL, tempSL: TStringList;
    TempStr,s2 : string;
    CMD, SDT, Entry : string;
    IntEntryType : integer;
    strEntryTypeNum : string;
    EntryType : tNodeType;
    i : integer;
    j : tNodeType;
    IsHeader : boolean;
    LastHeaderIdx : integer;
begin
  LastHeaderIdx := -1;
  SL := TStringList.Create;
  SDT := ''; //can add later...
  CMD := 'LIST FOR USER^'+IntToStr(User.DUZ);
  try
    tCallV(SL, 'TMG CPRS ENCOUNTER GET CPT LST', [Patient.DFN, CMD, SDT]);
    for j := PriorCPTs to EncounterCPTs do begin
      if j = EncounterCPTs then begin
        //NOTE: NodeTypeSL[EncounterCPTs] format is:
        //      NodeTypeSL[EncounterCPTs].strings[#] = "section name"
        //      NodeTypeSL[EncounterCPTs].objects[#] = TStringList with entries for section
        for i := 0 to NodeTypeSL[EncounterCPTs].Count - 1 do begin
          SL := TStringList(NodeTypeSL[j].objects[i]);
          SL.Free;
        end;
      end;
      NodeTypeSL[j].Clear;
    end;

    for i := 1 to SL.Count - 1 do begin
      Entry := SL.Strings[i];
      IntEntryType := StrToIntDef(Piece(Entry, '^',1),0);
      if (IntEntryType < tNODE_FIRST) or (IntEntryType > tNODE_LAST) then continue;
      strEntryTypeNum := IntToStr(-IntEntryType);
      EntryType := tNodeType(IntEntryType);
      case EntryType of
        PriorCPTs:     begin
                         TempStr := strEntryTypeNum+'^.^Prior CPT''s';
                         if TitlesToAdd.IndexOf(TempStr)<0 then TitlesToAdd.Add(TempStr);
                         NodeTypeSL[EntryType].Add(Entry);
                       end;
        EncounterCPTs: begin
                         IsHeader := (Piece(Entry,'^',2) = 'HEADER');
                         if IsHeader then begin           //fmt: 2^HEADER^<Section Name>"
                           TempSL := TStringList.Create;
                           LastHeaderIdx := NodeTypeSL[EntryType].AddObject(Entry, TempSL);
                           s2 := ENCOUNTER_STR + Piece(Entry,'^',3);
                           TitlesToAdd.Add(strEntryTypeNum+ '^' + IntToStr(LastHeaderIdx) + '^' + s2);  //fmt: -2^<index>^<Display title>
                         end else begin                   //fmt: 2^ENTRY^<CPT CODE>^<DISPLAY NAME>^<CPT NAME>"
                           if LastHeaderIdx >= 0 then begin
                             TempSL := TStringList(NodeTypeSL[EntryType].Objects[LastHeaderIdx]);
                             TempSL.Add(Entry)
                           end;
                         end;
                       end;
      end;  //case
    end;
  finally
    SL.Free;
  end;
end;






procedure TfrmTMGProcedures.txtProcQtyChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) then
  begin
    for i := 0 to lbGrid.Items.Count-1 do
      if(lbGrid.Selected[i]) then
        TPCEProc(lbGrid.Items.Objects[i]).Quantity := spnProcQty.Position;
    GridChanged;
  end;
end;

procedure TfrmTMGProcedures.cboProviderChange(Sender: TObject);
var
  i: integer;
begin
  inherited;
  if(NotUpdating) then
  begin
    for i := 0 to lbGrid.Items.Count-1 do
      if(lbGrid.Selected[i]) then
        TPCEProc(lbGrid.Items.Objects[i]).Provider := cboProvider.ItemIEN;
    FProviderChanging := TRUE; // CQ 11707
    try
      GridChanged;
    finally
      FProviderChanging := FALSE;
    end;
  end;
end;

procedure TfrmTMGProcedures.FormCreate(Sender: TObject);
begin
  inherited;
  TMGInfoPriorCPTs              := TStringList.Create;  //kt
  TMGInfoEncounterCPTs          := TStringList.Create;  //kt

  NodeTypeSL[PriorCPTs]         := TMGInfoPriorCPTs;
  NodeTypeSL[EncounterCPTs]     := TMGInfoEncounterCPTs;

  FTabName := CT_TMG_ProcNm;
  FPCEListCodesProc := ListTMGProcedureCodesExternal;
  // FPCEListCodesProc := ListTMGDiagnosisCodesExternal;  //this is a callback. Will be called by ancestor(s) of this class

  cboProvider.InitLongList(FProviders.PCEProviderName);
  FPCEItemClass := TPCEProc;
  FPCECode := 'CPT';
  FSectionTabCount := 1;
  FormResize(Self);
  lbMods.HideSelection := TRUE;

  FSearchTerms := TStringList.Create;

  FProgSrchEditChange := false;  //kt
  FProgSectionClick := false;    //kt

end;

procedure TfrmTMGProcedures.FormDestroy(Sender: TObject);
begin
  inherited;
  TMGInfoPriorCPTs.Free; //kt
  FSearchTerms.Free;  //kt
end;

procedure TfrmTMGProcedures.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumProcQty, '1');
  //x := x + U + '1';
end;

procedure TfrmTMGProcedures.UpdateControls;
var
  ok, First: boolean;
  SameQty: boolean;
  SameProv: boolean;
  i: integer;
  Qty: integer;
  Prov: int64;
  Obj: TPCEProc;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lbGrid.SelCount > 0);
      lblProcQty.Enabled := ok;
      txtProcQty.Enabled := ok;
      spnProcQty.Enabled := ok;
      cboProvider.Enabled := ok;
      lblProvider.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameQty := TRUE;
        SameProv := TRUE;
        Prov := 0;
        Qty := 1;
        for i := 0 to lbGrid.Items.Count-1 do
        begin
          if lbGrid.Selected[i] then
          begin
            Obj := TPCEProc(lbGrid.Items.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              Qty := Obj.Quantity;
              Prov := Obj.Provider;
            end
            else
            begin
              if(SameQty) then
                SameQty := (Qty = Obj.Quantity);
              if(SameProv) then
                SameProv := (Prov = Obj.Provider);
            end;
          end;
        end;
        if(SameQty) then
        begin
          spnProcQty.Position := Qty;
          txtProcQty.Text := IntToStr(Qty);
          txtProcQty.SelStart := length(txtProcQty.Text);
        end
        else
        begin
          spnProcQty.Position := 1;
          txtProcQty.Text := '';
        end;
        if not FProviderChanging then // CQ 11707
        begin
          if(SameProv) then
            cboProvider.SetExactByIEN(Prov, ExternalName(Prov, 200))
          else
            cboProvider.SetExactByIEN(FProviders.PCEProvider, FProviders.PCEProviderName);
            //cboProvider.ItemIndex := -1;     v22.8 - RV
        end;
      end
      else
      begin
        txtProcQty.Text := '';
        cboProvider.ItemIndex := -1;
      end;
//      ShowModifiers;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmTMGProcedures.FormResize(Sender: TObject);
var
  v, i: integer;
  s: string;
  
begin
  inherited;
  FSectionTabs[0] := -(lbxSection.width - LBCheckWidthSpace - MainFontWidth - ScrollBarWidth);
  UpdateTabPos;
  v := (lbMods.width - LBCheckWidthSpace - (4*MainFontWidth) - ScrollBarWidth);
  s := '';
  for i := 1 to 20 do
  begin
    if s <> '' then s := s + ',';
    s := s + inttostr(v);
    if(v<0) then
      dec(v,32)
    else
      inc(v,32);
  end;
  lbMods.TabPositions := s;
end;

procedure TfrmTMGProcedures.splRightMoved(Sender: TObject);
begin
  inherited;
  lblMod.Left := lbMods.Left + pnlMain.Left;
  FSplitterMove := TRUE;
  FormResize(Sender);
end;

procedure TfrmTMGProcedures.clbListClick(Sender: TObject);
begin
  inherited;
  Sync2Section;
  UpdateControls;
  ShowModifiers;
end;

procedure TfrmTMGProcedures.lbGridSelect(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmTMGProcedures.btnSearchClick(Sender: TObject);
begin
  inherited;
  SetSearchMode(not FSearchMode);
  if FSearchMode then edtSearchTerms.SetFocus;
end;

procedure TfrmTMGProcedures.btnSelectAllClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmTMGProcedures.ShowModifiers;
const
  ModTxt = 'Modifiers';
  ForTxt = ' for ';
  Spaces = '    ';
  CommonTxt = ' Common to Multiple Procedures';

var
  i, TopIdx: integer;
//  Needed,
  Codes, ProcName, Hint, Msg: string;
  Proc: TPCEProc;

begin
  if(not NotUpdating) then exit;
  Codes := '';
  ProcName := '';
  Hint := '';
//  Needed := '';
  for i := 0 to lbGrid.Items.Count-1 do
  begin
    if(lbGrid.Selected[i]) then
    begin
      Proc := TPCEProc(lbGrid.Items.Objects[i]);
      Codes := Codes + Proc.Code + U;
      if(ProcName = '') then
        ProcName := Proc.Narrative
      else
        ProcName := CommonTxt;
      if(Hint <> '') then
        Hint := Hint + CRLF + Spaces;
      Hint := Hint + Proc.Narrative;
//      Needed := Needed + Proc.Modifiers;
    end;
  end;
  if(Codes = '') and (lbxSection.ItemIndex >= 0) then
  begin
    Codes := piece(lbxSection.Items[lbxSection.ItemIndex],U,1) + U;
    ProcName := piece(lbxSection.Items[lbxSection.ItemIndex],U,2);
    Hint := ProcName;
//    Needed := piece(lbxSection.Items[lbxSection.ItemIndex],U,4); Don't show expired codes!
  end;
  msg := ModTxt;
  if(ProcName <> '') and (ProcName <> CommonTxt) then
    msg := msg + ForTxt;
  lblMod.Caption := msg + ProcName;
  if(pos(CRLF,Hint)>0) then
    Hint := ':' + CRLF + Spaces + Hint;
  lblMod.Hint := msg + Hint;
  
  if(FLastCPTCodes = Codes) then
    TopIdx := lbMods.TopIndex
  else
  begin
    TopIdx := 0;
    FLastCPTCodes := Codes;
  end;
  ListCPTModifiers(lbMods.Items, Codes, ''); // Needed);
  lbMods.TopIndex := TopIdx;
  CheckModifiers;
end;

procedure TfrmTMGProcedures.CheckModifiers;
var
  i, idx, cnt, mcnt: integer;
  Code, Mods: string;
  state: TCheckBoxState;

begin
  FModsReadOnly := TRUE;
  if lbMods.Items.Count < 1 then exit;
  FCheckingMods := TRUE;
  try
    cnt := 0;
    Mods := ';';
    for i := 0 to lbGrid.Items.Count-1 do
    begin
      if(lbGrid.Selected[i]) then
      begin
        inc(cnt);
        Mods := Mods + TPCEProc(lbGrid.Items.Objects[i]).Modifiers;
        FModsReadOnly := FALSE;
      end;
    end;
    if(cnt = 0) and (lbxSection.ItemIndex >= 0) then
    begin
      Mods := ';' + UpdateModifierList(lbxSection.Items, lbxSection.ItemIndex);
      cnt := 1;
    end;
    for i := 0 to lbMods.Items.Count-1 do
    begin
      state := cbUnchecked;
      if(cnt > 0) then
      begin
        Code := ';' + piece(lbMods.Items[i], U, 1) + ';';
        mcnt := 0;
        repeat
          idx := pos(Code, Mods);
          if(idx > 0) then
          begin
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
    if FModsReadOnly then
    begin
      FModsROChecked := lbMods.CheckedString;
      lbMods.Font.Color := clInactiveCaption;
    end
    else
      lbMods.Font.Color := clWindowText;
  finally
    FCheckingMods := FALSE;
  end;
end;

procedure TfrmTMGProcedures.lbModsClickCheck(Sender: TObject; Index: Integer);
var
  i, idx: integer;
  PCEObj: TPCEProc;
  ModIEN: string;
  DoChk, Add: boolean;

begin
  if FCheckingMods or (Index < 0) then exit;
  if FModsReadOnly then
  begin
    lbMods.CheckedString := FModsROChecked;
    exit;
  end;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      DoChk := FALSE;
      Add := (lbMods.Checked[Index]);
      //kt ModIEN := piece(lbMods.Items[Index],U,1) + ';';
      ModIEN := piece(lbMods.Items[Index],U,1);  //kt
      for i := 0 to lbGrid.Items.Count-1 do
      begin
        if(lbGrid.Selected[i]) then begin
          PCEObj := TPCEProc(lbGrid.Items.Objects[i]);
          if PCEObj.HasModifierIEN(ModIEN) then begin //kt
          //kt idx := pos(';' + ModIEN, ';' + PCEObj.Modifiers);
          //kt if(idx > 0) then begin
            if not Add then begin
              //kt original --> delete(PCEObj.Modifiers, idx, length(ModIEN));
              PCEObj.RemoveModifierIEN(ModIEN); //kt
              DoChk := TRUE;
            end;
          end else begin
            if Add then begin
              //kt PCEObj.Modifiers := PCEObj.Modifiers + ModIEN;
              PCEObj.EnsureModifierIEN(ModIEN); //kt
              DoChk := TRUE;
            end;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
    if DoChk then
      GridChanged;
  end;
end;

procedure TfrmTMGProcedures.lbModsExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed then
    if btnOther.CanFocus then
      btnOther.SetFocus;
end;

procedure TfrmTMGProcedures.lbSectionClick(Sender: TObject);
var IntEntryType : integer;
    SrchEnable : boolean;
begin
  if not FProgSectionClick then SetSearchMode(false);
  IntEntryType := -lbSection.ItemIEN;
  SrchEnable := true;
  //btnSearch.Visible := SrchEnable;
  if not SrchEnable then SetSearchMode(false);
  inherited;        //note: this calls 'FPCEListCodesProc' which is really ListTMGProcedureCodesExternal(), setup in FormCreate
  ShowModifiers;
end;

procedure TfrmTMGProcedures.lbxSectionClickCheck(Sender: TObject;
  Index: Integer);
var
  i: integer;
begin
  if FCheckingCode then exit;
  FCheckingCode := TRUE;
  try
    inherited;
    Sync2Grid;
    lbxSection.Selected[Index] := True;
    if(lbxSection.ItemIndex >= 0) and (lbxSection.ItemIndex = Index) and
      (lbxSection.Checked[Index]) then
    begin
      UpdateModifierList(lbxSection.Items, Index); // CQ#16439
      lbxSection.Checked[Index] := TRUE;
      for i := 0 to lbGrid.Items.Count-1 do begin
        if(lbGrid.Selected[i]) then
        with TPCEProc(lbGrid.Items.Objects[i]) do begin
          if(Category = GetCat) and
            (Pieces(lbxSection.Items[Index], U, 1, 2) = Code + U + Narrative) then
          begin
            { TODO -oRich V. -cEncounters : v21/22 - Added this block to default provider for procedures.}
            if Provider = 0 then Provider := FProviders.PCEProvider;
            { uPCE.TPCEProviderList.PCEProvider function sorts this out automatically:                            }
            {   1.  Current CPRS encounter provider, if present and has active person class as of encounter date. }
            {   2.  Current user, if has active person class as of encounter date.                                }
            {   3.  Primary provider for the visit, if defined.                                                   }
            {   4.  No default.                                                                                   }
            Modifiers := Piece(lbxSection.Items[lbxSection.ItemIndex], U, 4);
            GridChanged;
            lbxSection.Selected[Index] := True; // CQ#15493
            exit;
          end;
        end;
      end;
    end;
  finally
    FCheckingCode := FALSE;
  end;
end;

procedure TfrmTMGProcedures.lbxSectionExit(Sender: TObject);
begin
  if TabIsPressed then begin
    if lbMods.CanFocus then
      lbMods.SetFocus;
  end
  else if ShiftTabIsPressed then
    if lbSection.CanFocus then
      lbSection.SetFocus;
end;

procedure TfrmTMGProcedures.btnClearSrchClick(Sender: TObject);
begin
  inherited;
  SetSearchMode(false);
end;

procedure TfrmTMGProcedures.btnOtherClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmTMGProcedures.btnOtherExit(Sender: TObject);
begin
  if TabIsPressed then begin
    if lbGrid.CanFocus then
      lbGrid.SetFocus;
  end
  else if ShiftTabIsPressed then
    if lbMods.CanFocus then
      lbMods.SetFocus;    
end;

procedure TfrmTMGProcedures.btnRemoveClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmTMGProcedures.cboProviderNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  inherited;
  if(uEncPCEData.VisitCategory = 'E') then
    cboProvider.ForDataUse(SubSetOfPersons(StartFrom, Direction))
  else
    cboProvider.ForDataUse(SubSetOfUsersWithClass(StartFrom, Direction,
                                     FloatToStr(uEncPCEData.PersonClassDate)));
end;

function TfrmTMGProcedures.OK2SaveProcedures: boolean;
begin
  Result := TRUE;
  if MissingProvider then
  begin
    InfoBox(TX_PROC_PROV, TC_PROC_PROV, MB_OK or MB_ICONWARNING);
    Result := False;
  end;
end;

function TfrmTMGProcedures.MissingProvider: boolean;
var
  i: integer;
  AProc: TPCEProc;
begin
  { TODO -oRich V. -cEncounters : {v21 - Entry of a provider for each new CPT is now required}
            {Existing CPTs on the encounter will NOT require entry of a provider}
            {Monitor status of new service request #20020203.}
  Result := False;

  { Comment out the block below (and the "var" block above) }
  {  to allow but not require entry of a provider with each new CPT entered}
//------------------------------------------------
  for i := 0 to lbGrid.Items.Count - 1 do
  begin
    AProc := TPCEProc(lbGrid.Items.Objects[i]);
    if AProc.fIsOldProcedure then continue;
    if (AProc.Provider = 0) then
    begin
      Result := True;
      lbGrid.ItemIndex := i;
      exit;
    end;
  end;
//-------------------------------------------------
end;

procedure TfrmTMGProcedures.ConfigureForSearchMode(SearchMode : boolean);
begin
  edtSearchTerms.Visible := SearchMode;
  btnClearSrch.Visible := SearchMode;
  lblList.Visible := not SearchMode;
  lblMod.Visible := not SearchMode;
end;


procedure TfrmTMGProcedures.edtSearchTermsChange(Sender: TObject);
begin
  inherited;
  if FProgSrchEditChange then exit;
  FProgSectionClick := true;
  PiecesToList(UpperCase(edtSearchTerms.Text), ' ', FSearchTerms);
  ListTMGProcedureCodes(lbxSection.Items, lbSection.ItemIEN);
  FProgSectionClick := false;

end;

procedure TfrmTMGProcedures.SetSearchMode(Mode : boolean);
begin
  if FSearchMode = Mode then exit; //no change needed
  FSearchMode := Mode;
  FProgSrchEditChange := true;
  edtSearchTerms.Text := '';
  FProgSrchEditChange := false;
  ConfigureForSearchMode(FSearchMode);
  if FSearchMode = false then edtSearchTermsChange(self);  //this will trigger redisplay WITHOUT filter
end;


function TfrmTMGProcedures.ShouldFilter(Entry : string) : boolean;  //fmt: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
var i : integer;
    ATerm : string;
begin
  Result := false;
  if not FSearchMode then exit;
  Entry := UpperCase(Entry);
  for i := 0 to FSearchTerms.Count - 1 do begin
    ATerm := FSearchTerms[i];
    if Pos(ATerm, Entry) > 0 then continue;
    Result := true;
    break;
  end;
end;




initialization
  SpecifyFormIsNotADialog(TfrmTMGProcedures);

end.
