unit fTMGVisitType;    //<--- note: would ideally be renamed to fTMGVisitTypes (added 's')
                       //     to match the class name (with an 's'), but I'll leave for now.

{Warning: The tab order has been changed in the OnExit event of several controls.
 To change the tab order of lbSection, lbxSection, lbMods, and btnOther you must do it programatically.}

//kt  NOTE: This was copied from fProcedure, then fTMG because I plan significant changes.

{
NOTE: This form is for dealing with E/M codes, which are a subset of all CPT codes.
      Fundamentally, this form could be an exact copy of fTMGProcedure, because they
      really do the same thing.  However, because I the VA fVisitTypes form treated
      visits differently, I started out there, and worked towards fTMGProcedures, and
      ended up with this form.
      The fundamental difference is that every time data is written to lbGrid, which
      is the core repository of selected procedures in fTMGProcedure, in this unit,
      it is also copied to FVisitTypesList.  In fTMGProcedure, when saving out the
      PCE information, the data is retrieved from lbGrid.  In this form, it is
      retrieved from FVisitTypesList.  In the future, if I have extra energy, I could
      probably try to eliminate this difference, and use the same form for both.
      But for now, I have two froms/classes/units that are behaving very similarly.

      Another difference is that each form calls a different RPC to get back the
      relevent CPT's.  In fTMGProcedure, each element comes back with various type
      numbers, e.g. 1, 2, 3, 4 etc.  In fTMGVisitType, I have data come back with
      type number=1.  If I combine the forms, I would need to make the server RPC
      return the value on a non-conflicting node, e.g. 5.

      Also, because of the way NodeTypeSL is not contained in the class for both
      frmTMGVisitType and frmTMGDiagnoses, I would have to rework the use of this
      if I want to have 2 instances of the the same class.

      -- KT 3/23/2023
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, ComCtrls, CheckLst, ORCtrls, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  ORNet, uCore,  //kt
  fPCELex, fPCEOther, fPCEBaseGrid, fPCEBaseMain, VA508AccessibilityManager;

type
  TfrmTMGVisitTypes = class(TfrmPCEBaseMain)
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
    FVisitTypesList: TPCEProcList; //kt added. Local copy.  Owned here.  List of TPCEProc objects.  Will be copied back into PCE in TfrmEncounterFrame.UpdateEncounter
    FSrcPCEData : TPCEData;        //pointer to PCE Data owned elsewhere
    TMGInfoVisitCPTs          : TStringList;  // -- see notes below --
      //NOTE: TMGInfoEncounterCPTs format is:
      //      TMGInfoEncounterCPTs.strings[#] = "section name"                            //fmt of each entry: 2^HEADER^<Section Name>"
      //      TMGInfoEncounterCPTs.objects[#] = TStringList with entries for section      //fmt of ->SL[#]:    2^ENTRY^<CPT CODE>^<DISPLAY NAME>^<CPT NAME>"

    //NOTE: NodeTypeSL[] will hold pointers to TStringLists above.  Defined below.
    FListOfPotentialVisitCodes: TStringList; //this is a list of all visit-type CPT's that could be chosen between  //kt added
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
    procedure SetVisitType(index : integer;  Value: TPCEProc);   //kt added
    function GetVisitType(index : integer) : TPCEProc; //kt added
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
    procedure ShowModifiers;
    procedure CheckModifiers;
    procedure ListTMGVisitCodes(Dest: TStrings; IntEntryType: Integer); //kt
    procedure LoadTMGVisitInfo(TitlesToAdd : TStringList);  //kt
    procedure Grid2Data;  //kt
    procedure Data2Grid;  //kt
  public
    function OK2SaveVisits: boolean;
    procedure InitTab(ACopyProc: TCopyVisitsMethod; SrcPCEData : TPCEData);
    procedure EnsureCPTs(List : TStringList);
    property VisitType[index : integer] : TPCEProc read GetVisitType write SetVisitType; //kt added
    property VisitTypesList: TPCEProcList read FVisitTypesList; //kt added
  end;

var
  frmTMGVisitType: TfrmTMGVisitTypes;

implementation

{$R *.DFM}

uses
  fEncounterFrame, uConst, rCore, VA508AccessibilityRouter;

const
  TX_PROC_PROV = 'Each procedure requires selection of a Provider before it can be saved.';
  TC_PROC_PROV = 'Missing Procedure Provider';

  ENCOUNTER_STR = ''; //'Encounter Section: ';

type
  tNodeType = (Visit_CPTs=1);   //even though only 1 entry, I am using this to be consistent with fTMGProcedure and fTMGDiagnoses

CONST
  tNODE_FIRST = Visit_CPTs;
  tNODE_LAST = Visit_CPTs;

var
  //NOTICE!!  If multiple instances of TfrmTMGVisitTypes created --> this will cause collision, overridden data, memory leak!
  NodeTypeSL : array[tNODE_FIRST .. tNODE_LAST] of TStringList;  //not owned here.
  //NOTE: NodeTypeSL[Visit_CPTs] format is:
  //      NodeTypeSL[Visit_CPTs].strings[#] = "section name"
  //      NodeTypeSL[Visit_CPTs].objects[#] = TStringList with entries for section

  //=============================================================================


procedure ListTMGVisitCodesExternal(Dest: TStrings; IntEntryType: Integer);
begin
  if not Assigned(frmTMGVisitType) then exit;
  frmTMGVisitType.ListTMGVisitCodes(Dest, IntEntryType);
end;


//=============================================================================

procedure TfrmTMGVisitTypes.EnsureCPTs(List : TStringList);
//Purpose: Take list of CPT's (free text) and ensure entered into PCE data.
//Format:  Each line of List should have 1 CPT code.  E.g. 99213 or 99445x2 <-- x2 means multiplier of 2
var i,j : integer;
    OneCPT : string;
    countStr : string;
    count : integer;
    data : string;
    x : string;
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
    for j := 0 to FListOfPotentialVisitCodes.Count - 1 do begin
      data := FListOfPotentialVisitCodes.Strings[j];  //format e.g.: '99202^NEW PATIENT^Limited Exam        16-25 Min'
      if piece(data,U,1) <> OneCPT then continue;
      //set up x. Format: TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov
      //  piece  1  -> Type <-- NOTE: not used
      //         2  -> Code
      //         3  -> Category
      //         4  -> Narrative
      //         5  -> Quantity
      //         6  -> Provider
      //         9  -> Modifiers
      //         10 -> Comment
      //
      //e.g  CPT    ^   99202^NEW PATIENT^Limited Exam ^          0          ^      168
      x :=  'CPT' + U +      Pieces(data, U, 1, 3)   + U + IntToStr(count) + U + IntToStr(User.DUZ);
      FVisitTypesList.EnsureFromString(x);
      Data2Grid;
      break;
    end;
  end;
end;


procedure TfrmTMGVisitTypes.ListTMGVisitCodes(Dest: TStrings; IntEntryType: Integer);
//This is a call-back function that is called by ancestor(s) of this class
//It is used for loading lbxSection (right side list) when lbSection (left side list) is clicked

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
  if (IntEntryType < ord(tNODE_FIRST)) or (IntEntryType > ord(tNODE_LAST)) then exit;
  EntryType := tNodeType(IntEntryType);
  SL := NodeTypeSL[EntryType]; //DEFAULT.  NOTE: SL may be changed to different TStringList below...
  if (EntryType = Visit_CPTs) then begin
    Index := lbSection.ItemIndex;
    SectionStr := lbSection.Items.Strings[Index]; //fmt: -1^<index>^<Display title>  index is # in TStringlist NodeTypeSL[EncounterCPTs]
    Index := StrToIntDef(Piece(SectionStr, '^',2), 0);
    SL := TStringList(NodeTypeSL[Visit_CPTs].Objects[Index]);
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
                        //    1  2         3          4               5
    Visit_CPTs:  begin  //fmt 1^ENTRY^<CPT CODE>^<DISPLAY NAME>^<CPT NAME>
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

procedure TfrmTMGVisitTypes.Grid2Data;
var i : integer;
    AProc : TPCEProc;
begin
  FVisitTypesList.FreeAndClearItems;
  for i := lbGrid.Items.Count - 1 downto 0 do begin
    AProc := TPCEProc(lbGrid.Items.Objects[i]);
    FVisitTypesList.EnsureProc(AProc);  //List will make copy of AProc if not already added
  end;
end;

procedure TfrmTMGVisitTypes.Data2Grid;  //kt added
var i : integer;
    AProc, ACopiedProc : TPCEProc;
    APCEItem : TPCEItem;
    ItemStr : string;
begin
  for i := lbGrid.Items.Count - 1 downto 0 do begin
    APCEItem := TPCEItem(lbGrid.Items.Objects[i]);
    APCEItem.Free;
    lbGrid.Items.Delete(i);
  end;
  for i := 0 to FVisitTypesList.Count - 1 do begin
    AProc := FVisitTypesList.Proc[i];
    ACopiedProc := TPCEProc.Create;
    ACopiedProc.Assign(AProc);
    lbGrid.Items.AddObject(ACopiedProc.Narrative, ACopiedProc);
  end;
end;

procedure TfrmTMGVisitTypes.InitTab(ACopyProc: TCopyVisitsMethod; SrcPCEData : TPCEData);
var TempSL : TStringList;
    TitlesToAdd : TStringList;
    i : integer;
begin
  //kt --> I DON'T want inherited.  I will achieve here instead --> inherited InitTab(ACopyProc, AListProc);
  ListVisitTypeByLoc(FListOfPotentialVisitCodes, SrcPCEData.Location, SrcPCEData.DateTime);  //only calls server if loc, date changed since last load. 
  TempSL := TStringList.Create;
  TitlesToAdd := TStringList.Create;
  try
    FSrcPCEData := SrcPCEData;  //save local pointer to outside object.
    LoadTMGVisitInfo(TitlesToAdd);
    //Before, would call VA code here to load up TempSL .... e.g. ListVisitTypeCodes
    for i := TitlesToAdd.Count - 1 downto 0 do begin
      TempSL.Insert(0,TitlesToAdd[i]);
    end;
    lbSection.Items.Assign(TempSL);
    ACopyProc(FVisitTypesList);  //kt  FVisitTypesList.Assign(FSrcPCEData.VisitTypesList);  //kt
    for i := 0 to FVisitTypesList.Count - 1 do begin
      FVisitTypesList.Proc[i].fIsOldProcedure := True;
    end;
    Data2Grid;                   //kt  //ACopyProc(lbGrid.Items);
    lbSection.ItemIndex := 0;
    lbSectionClick(lbSection);
    ClearGrid;
    GridChanged;
  finally
    TempSL.Free;
    TitlesToAdd.Free;
  end;
end;

function TfrmTMGVisitTypes.GetVisitType(index : integer) : TPCEProc; //kt added
begin
  if FVisitTypesList.ValidIndex(index) then begin
    Result := FVisitTypesList.Proc[index];
  end else begin
    Result := nil;
  end;
end;

procedure TfrmTMGVisitTypes.SetVisitType(index : integer;  Value: TPCEProc);   //kt added
begin
  if not FVisitTypesList.ValidIndex(index) then exit;
  FVisitTypesList.Proc[index].Assign(Value);
end;

procedure TfrmTMGVisitTypes.LoadTMGVisitInfo(TitlesToAdd : TStringList);
//This is called when form first instantiated.  It gets server information and stores locally.
//  called from InitTMGTab()
var SL, tempSL: TStringList;
    TempStr,s2 : string;
    CMD, Entry : string;
    SDT : TFMDateTime;
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
  SDT := FSrcPCEData.DateTime;
  CMD := 'LIST FOR USER,LOC^'+IntToStr(User.DUZ)+'^'+IntToStr(FSrcPCEData.Location);
  try
    tCallV(SL, 'TMG CPRS ENCOUNTER GET VST LST', [Patient.DFN, CMD, SDT]);
    for j := tNODE_FIRST to tNODE_LAST do begin
      if j = Visit_CPTs then begin
        //NOTE: NodeTypeSL[Visit_CPTs] format is:
        //      NodeTypeSL[Visit_CPTs].strings[#] = "section name"
        //      NodeTypeSL[Visit_CPTs].objects[#] = TStringList with entries for section
        for i := 0 to NodeTypeSL[Visit_CPTs].Count - 1 do begin
          SL := TStringList(NodeTypeSL[j].objects[i]);
          SL.Free;
        end;
      end;
      NodeTypeSL[j].Clear;
    end;

    for i := 1 to SL.Count - 1 do begin
      Entry := SL.Strings[i];
      IntEntryType := StrToIntDef(Piece(Entry, '^',1),0);
      if (IntEntryType < ord(tNODE_FIRST)) or (IntEntryType > ord(tNODE_LAST)) then continue;
      strEntryTypeNum := IntToStr(-IntEntryType);
      EntryType := tNodeType(IntEntryType);
      case EntryType of
        Visit_CPTs: begin
                      IsHeader := (Piece(Entry,'^',2) = 'HEADER');
                      if IsHeader then begin           //fmt: 1^HEADER^<Section Name>"
                        TempSL := TStringList.Create;
                        LastHeaderIdx := NodeTypeSL[EntryType].AddObject(Entry, TempSL);
                        s2 := ENCOUNTER_STR + Piece(Entry,'^',3);
                        TitlesToAdd.Add(strEntryTypeNum+ '^' + IntToStr(LastHeaderIdx) + '^' + s2);  //fmt: -1^<index>^<Display title>
                      end else begin                   //fmt: 1^ENTRY^<CPT CODE>^<DISPLAY NAME>^<CPT NAME>"
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


procedure TfrmTMGVisitTypes.txtProcQtyChange(Sender: TObject);
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

procedure TfrmTMGVisitTypes.cboProviderChange(Sender: TObject);
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

procedure TfrmTMGVisitTypes.FormCreate(Sender: TObject);
begin
  inherited;
  FListOfPotentialVisitCodes := TStringList.Create; //kt added
  FVisitTypesList:= TPCEProcList.Create; //kt added

  TMGInfoVisitCPTs          := TStringList.Create;  //kt
  NodeTypeSL[Visit_CPTs]    := TMGInfoVisitCPTs;

  FTabName := CT_TMG_VisitNm;
  FPCEListCodesProc := ListTMGVisitCodesExternal;     //this is a callback. Will be called by ancestor(s) of this class

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

procedure TfrmTMGVisitTypes.FormDestroy(Sender: TObject);
begin
  FVisitTypesList.FreeAndClearItems; //kt added
  FVisitTypesList.Free; //kt added
  FListOfPotentialVisitCodes.Free; //kt

  TMGInfoVisitCPTs.Free; //kt
  FSearchTerms.Free;  //kt
  inherited;
end;

procedure TfrmTMGVisitTypes.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumProcQty, '1');
  //x := x + U + '1';
end;

procedure TfrmTMGVisitTypes.UpdateControls;
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
  if NotUpdating then begin
    BeginUpdate;
    try
      ok := (lbGrid.SelCount > 0);
      lblProcQty.Enabled := ok;
      txtProcQty.Enabled := ok;
      spnProcQty.Enabled := ok;
      cboProvider.Enabled := ok;
      lblProvider.Enabled := ok;
      if ok then begin
        First := TRUE;
        SameQty := TRUE;
        SameProv := TRUE;
        Prov := 0;
        Qty := 1;
        for i := 0 to lbGrid.Items.Count-1 do begin
          if lbGrid.Selected[i] then begin
            Obj := TPCEProc(lbGrid.Items.Objects[i]);
            if(First) then begin
              First := FALSE;
              Qty := Obj.Quantity;
              Prov := Obj.Provider;
            end else begin
              if(SameQty) then
                SameQty := (Qty = Obj.Quantity);
              if(SameProv) then
                SameProv := (Prov = Obj.Provider);
            end;
          end;
        end;
        if SameQty then begin
          spnProcQty.Position := Qty;
          txtProcQty.Text := IntToStr(Qty);
          txtProcQty.SelStart := length(txtProcQty.Text);
        end else begin
          spnProcQty.Position := 1;
          txtProcQty.Text := '';
        end;
        if not FProviderChanging then begin // CQ 11707
          if(SameProv) then begin
            cboProvider.SetExactByIEN(Prov, ExternalName(Prov, 200))
          end else begin
            cboProvider.SetExactByIEN(FProviders.PCEProvider, FProviders.PCEProviderName);
            //cboProvider.ItemIndex := -1;     v22.8 - RV
          end;
        end;
      end else begin
        txtProcQty.Text := '';
        cboProvider.ItemIndex := -1;
      end;
//      ShowModifiers;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmTMGVisitTypes.FormResize(Sender: TObject);
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

procedure TfrmTMGVisitTypes.splRightMoved(Sender: TObject);
begin
  inherited;
  lblMod.Left := lbMods.Left + pnlMain.Left;
  FSplitterMove := TRUE;
  FormResize(Sender);
end;

procedure TfrmTMGVisitTypes.clbListClick(Sender: TObject);
begin
  inherited;
  Sync2Section;
  UpdateControls;
  ShowModifiers;
end;

procedure TfrmTMGVisitTypes.lbGridSelect(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmTMGVisitTypes.btnSearchClick(Sender: TObject);
begin
  inherited;
  SetSearchMode(not FSearchMode);
  if FSearchMode then edtSearchTerms.SetFocus;
end;

procedure TfrmTMGVisitTypes.btnSelectAllClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmTMGVisitTypes.ShowModifiers;
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
  for i := 0 to lbGrid.Items.Count-1 do begin
    if(lbGrid.Selected[i]) then begin
      Proc := TPCEProc(lbGrid.Items.Objects[i]);
      Codes := Codes + Proc.Code + U;
      if(ProcName = '') then begin
        ProcName := Proc.Narrative
      end else begin
        ProcName := CommonTxt;
      end;
      if(Hint <> '') then begin
        Hint := Hint + CRLF + Spaces;
      end;
      Hint := Hint + Proc.Narrative;
//      Needed := Needed + Proc.Modifiers;
    end;
  end;
  if(Codes = '') and (lbxSection.ItemIndex >= 0) then begin
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

  if(FLastCPTCodes = Codes) then begin
    TopIdx := lbMods.TopIndex
  end else begin
    TopIdx := 0;
    FLastCPTCodes := Codes;
  end;
  ListCPTModifiers(lbMods.Items, Codes, ''); // Needed);
  lbMods.TopIndex := TopIdx;
  CheckModifiers;
end;

procedure TfrmTMGVisitTypes.CheckModifiers;
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
    for i := 0 to lbGrid.Items.Count-1 do begin
      if(lbGrid.Selected[i]) then begin
        inc(cnt);
        Mods := Mods + TPCEProc(lbGrid.Items.Objects[i]).Modifiers;
        FModsReadOnly := FALSE;
      end;
    end;
    if(cnt = 0) and (lbxSection.ItemIndex >= 0) then begin
      Mods := ';' + UpdateModifierList(lbxSection.Items, lbxSection.ItemIndex);
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
        if mcnt >= cnt then begin
          State := cbChecked
        end else if(mcnt > 0) then begin
          State := cbGrayed;
        end;
      end;
      lbMods.CheckedState[i] := state;
    end;
    if FModsReadOnly then begin
      FModsROChecked := lbMods.CheckedString;
      lbMods.Font.Color := clInactiveCaption;
    end else begin
      lbMods.Font.Color := clWindowText;
    end;
  finally
    FCheckingMods := FALSE;
  end;
end;

procedure TfrmTMGVisitTypes.lbModsClickCheck(Sender: TObject; Index: Integer);
var
  i, idx: integer;
  PCEObj: TPCEProc;
  ModIEN: string;
  DoChk, Add: boolean;

begin
  if FCheckingMods or (Index < 0) then exit;
  if FModsReadOnly then begin
    lbMods.CheckedString := FModsROChecked;
    exit;
  end;
  if(NotUpdating) then begin
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

procedure TfrmTMGVisitTypes.lbModsExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed then
    if btnOther.CanFocus then
      btnOther.SetFocus;
end;

procedure TfrmTMGVisitTypes.lbSectionClick(Sender: TObject);
var IntEntryType : integer;
    SrchEnable : boolean;
begin
  if not FProgSectionClick then SetSearchMode(false);
  IntEntryType := -lbSection.ItemIEN;
  SrchEnable := true;
  //btnSearch.Visible := SrchEnable;
  if not SrchEnable then SetSearchMode(false);
  inherited;        //note: this calls 'FPCEListCodesProc' which is really ListTMGVisitCodesExternal(), setup in FormCreate
  ShowModifiers;
end;

procedure TfrmTMGVisitTypes.lbxSectionClickCheck(Sender: TObject; Index: Integer);
var
  i: integer;
begin
  if FCheckingCode then exit;
  FCheckingCode := TRUE;
  try
    inherited;  // <--- note: significant work done here.  Data is put into lbGrid here..
    Sync2Grid;
    lbxSection.Selected[Index] := True;
    if(lbxSection.ItemIndex >= 0) and (lbxSection.ItemIndex = Index) and (lbxSection.Checked[Index]) then begin
      UpdateModifierList(lbxSection.Items, Index); // CQ#16439
      lbxSection.Checked[Index] := TRUE;
      for i := 0 to lbGrid.Items.Count-1 do begin
        if (lbGrid.Selected[i]) then with TPCEProc(lbGrid.Items.Objects[i]) do begin
          if(Category = GetCat) and (Pieces(lbxSection.Items[Index], U, 1, 2) = Code + U + Narrative) then begin
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
            //kt exit;
            break; //kt
          end;
        end;
      end;
    end;
    Grid2Data;  //kt
  finally
    FCheckingCode := FALSE;
  end;
end;

procedure TfrmTMGVisitTypes.lbxSectionExit(Sender: TObject);
begin
  if TabIsPressed then begin
    if lbMods.CanFocus then
      lbMods.SetFocus;
  end
  else if ShiftTabIsPressed then
    if lbSection.CanFocus then
      lbSection.SetFocus;
end;

procedure TfrmTMGVisitTypes.btnClearSrchClick(Sender: TObject);
begin
  inherited;
  SetSearchMode(false);
end;

procedure TfrmTMGVisitTypes.btnOtherClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmTMGVisitTypes.btnOtherExit(Sender: TObject);
begin
  if TabIsPressed then begin
    if lbGrid.CanFocus then
      lbGrid.SetFocus;
  end
  else if ShiftTabIsPressed then
    if lbMods.CanFocus then
      lbMods.SetFocus;    
end;

procedure TfrmTMGVisitTypes.btnRemoveClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
  Grid2Data;
end;

procedure TfrmTMGVisitTypes.cboProviderNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  inherited;
  if(uEncPCEData.VisitCategory = 'E') then
    cboProvider.ForDataUse(SubSetOfPersons(StartFrom, Direction))
  else
    cboProvider.ForDataUse(SubSetOfUsersWithClass(StartFrom, Direction,
                                     FloatToStr(uEncPCEData.PersonClassDate)));
end;

function TfrmTMGVisitTypes.OK2SaveVisits: boolean;
begin
  Result := TRUE;
  if MissingProvider then begin
    InfoBox(TX_PROC_PROV, TC_PROC_PROV, MB_OK or MB_ICONWARNING);
    Result := False;
  end;
end;

function TfrmTMGVisitTypes.MissingProvider: boolean;
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

procedure TfrmTMGVisitTypes.ConfigureForSearchMode(SearchMode : boolean);
begin
  edtSearchTerms.Visible := SearchMode;
  btnClearSrch.Visible := SearchMode;
  lblList.Visible := not SearchMode;
  lblMod.Visible := not SearchMode;
end;


procedure TfrmTMGVisitTypes.edtSearchTermsChange(Sender: TObject);
begin
  inherited;
  if FProgSrchEditChange then exit;
  FProgSectionClick := true;
  PiecesToList(UpperCase(edtSearchTerms.Text), ' ', FSearchTerms);
  ListTMGVisitCodes(lbxSection.Items, lbSection.ItemIEN);
  FProgSectionClick := false;

end;

procedure TfrmTMGVisitTypes.SetSearchMode(Mode : boolean);
begin
  if FSearchMode = Mode then exit; //no change needed
  FSearchMode := Mode;
  FProgSrchEditChange := true;
  edtSearchTerms.Text := '';
  FProgSrchEditChange := false;
  ConfigureForSearchMode(FSearchMode);
  if FSearchMode = false then edtSearchTermsChange(self);  //this will trigger redisplay WITHOUT filter
end;


function TfrmTMGVisitTypes.ShouldFilter(Entry : string) : boolean;  //fmt: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
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
  SpecifyFormIsNotADialog(TfrmTMGVisitTypes);

end.
