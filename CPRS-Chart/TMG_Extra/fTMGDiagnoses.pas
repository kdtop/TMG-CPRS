unit fTMGDiagnoses;

//kt Copied from fDiagnoses because I plan extensive modifications.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, CheckLst, ORNet, ExtCtrls, Buttons, uPCE, ORFn,
  ComCtrls, fPCEBaseMain, UBAGlobals, UBAConst, UCore, VA508AccessibilityManager,
  ORCtrls, Menus;

type
  TfrmTMGDiagnoses = class(TfrmPCEBaseMain)
    cmdDiagPrimary: TButton;
    ckbDiagProb: TCheckBox;
    BitBtn1: TBitBtn;
    popSectionRClick: TPopupMenu;
    popOptRemoveLink: TMenuItem;
    popOptEditLink: TMenuItem;
    btnSearch: TBitBtn;
    edtSearchTerms: TEdit;
    btnClearSrch: TBitBtn;
    procedure btnClearSrchClick(Sender: TObject);
    procedure lbSectionClick(Sender: TObject);
    procedure edtSearchTermsChange(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure lbxSectionContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure lbxSectionMouseLeave(Sender: TObject);
    procedure lbxSectionMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure clbListMouseDown(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: Integer);
    procedure popOptEditLinkClick(Sender: TObject);
    procedure popOptRemoveLinkClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdDiagPrimaryClick(Sender: TObject);
    procedure ckbDiagProbClicked(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure FormResize(Sender: TObject); override;
    procedure lbxSectionClickCheck(Sender: TObject; Index: Integer);
    procedure btnOKClick(Sender: TObject);  override;
    procedure GetEncounterDiagnoses;
    procedure lbSectionDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lbxSectionDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lbGridSelect(Sender: TObject);
  private
    FSrcPCEData : TPCEData;       //pointer to PCE Data owned elsewhere
    TMGInfoTopicsDiscussed        : TStringList;  //fmt: 1^<TOPIC NAME>^<THREAD TEXT>^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>
    TMGInfoTopicsUndiscussed      : TStringList;  //fmt: 2^<TOPIC NAME>^<SUMMARY TEXT>^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>
    TMGInfoProbList               : TStringList;  //fmt: 3^ifn^status^description^ICD^onset^last modified^SC^SpExp^Condition^Loc^loc.type^prov^service^priority^has comment^date recorded^SC condition(s)^inactive flag^ICD long description^ICD coding system
    TMGInfoPriorICDs              : TStringList;  //fmt: 4^<PRIOR ICD>^<ICD LONG NAME>^<FMDT LAST USED>^<ICD_CODE_SYS>
    TMGInfoEncounterICDs          : TStringList;  // -- see notes below --
      //NOTE: TMGInfoEncounterICDs is different from the others.  It's format is:
      //      TMGInfoEncounterICDs.strings[#] = "section name"                            //fmt of each entry: 5^HEADER^<Section Name>"
      //      TMGInfoEncounterICDs.objects[#] = TStringList with entries for section      //fmt of ->SL[#]:    5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"

    //NOTE: NodeTypeSL[] will hold pointers to TStringLists above.  Defined below.
    FSearchTerms : TStringList;
    FSearchMode : boolean;
    FProgSrchEditChange : boolean;
    FProgSectionClick : boolean;
    pnlRight : TPanel;
    memNarrative : TMemo;
    splRight : TSplitter;
    FlbxSectionRightClickDown : boolean;
    FlbxSectionRightClickPT : TPoint;
    FlbxSectionIndex : integer;
    procedure EnsurePrimaryDiag;
    procedure GetSCTforICD(ADiagnosis: TPCEDiag);
    procedure UpdateProblem(AplIEN: String; AICDCode: String; ASCTCode: String = '');
    function isProblem(diagnosis: TPCEDiag): Boolean;
    function isEncounterDx(problem: string): Boolean;
    procedure LoadTMGDxInfo(IEN8925 : integer; TitlesToAdd : TStringList);
    procedure LinkTopicToICD(TopicName, ICDInfo : string);
    procedure SetSearchMode(Mode : boolean);
    procedure ConfigureForSearchMode(SearchMode : boolean);
    function ShouldFilter(Entry : string) : boolean;  //fmt: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
    procedure ListTMGDiagnosisCodes(Dest: TStrings; IntEntryType: Integer);
  public
    procedure InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc; SrcPCEData : TPCEData);
  end;

var
  frmTMGDiagnoses: TfrmTMGDiagnoses;
  dxList : TStringList;
  PlUpdated: boolean = False;  //agp //kt

implementation

{$R *.DFM}

uses
  fEncounterFrame, uConst, UBACore, VA508AccessibilityRouter, fPCELex, rPCE, uProbs, rProbs,
  fDiagnoses, StrUtils, fTopicICDLinkerU, fProbAutoAdd, //kt
  rTIU, rCore;  //agp //kt

type
  TORCBImgIdx = (iiUnchecked, iiChecked, iiGrayed, iiQMark, iiBlueQMark,
    iiDisUnchecked, iiDisChecked, iiDisGrayed, iiDisQMark,
    iiFlatUnChecked, iiFlatChecked, iiFlatGrayed,
    iiRadioUnchecked, iiRadioChecked, iiRadioDisUnchecked, iiRadioDisChecked);

type
  tNodeType = (TopicsDiscussed=1, TopicsUndiscussed=2, ProbList=3, PriorICDs=4, EncounterICDs=5);

CONST
  tNODE_FIRST = ord(TopicsDiscussed);
  tNODE_LAST = ord(EncounterICDs);


var
  //NOTICE!!  If multiple instances of TfrmTMGDiagnoses created --> this will cause collision, overridden data, memory leak!
  NodeTypeSL : array[TopicsDiscussed .. EncounterICDs] of TStringList;  //not owned here.
  //NOTE: NodeTypeSL[EncounterICDs] is different from the others.  It format is:
  //      NodeTypeSL[EncounterICDs].strings[#] = "section name"
  //      NodeTypeSL[EncounterICDs].objects[#] = TStringList with entries for section

const
  CheckBoxImageResNames: array[TORCBImgIdx] of PChar = (
    'ORCB_UNCHECKED', 'ORCB_CHECKED', 'ORCB_GRAYED', 'ORCB_QUESTIONMARK',
    'ORCB_BLUEQUESTIONMARK', 'ORCB_DISABLED_UNCHECKED', 'ORCB_DISABLED_CHECKED',
    'ORCB_DISABLED_GRAYED', 'ORCB_DISABLED_QUESTIONMARK',
    'ORLB_FLAT_UNCHECKED', 'ORLB_FLAT_CHECKED', 'ORLB_FLAT_GRAYED',
    'ORCB_RADIO_UNCHECKED', 'ORCB_RADIO_CHECKED',
    'ORCB_RADIO_DISABLED_UNCHECKED', 'ORCB_RADIO_DISABLED_CHECKED');

  BlackCheckBoxImageResNames: array[TORCBImgIdx] of PChar = (
    'BLACK_ORLB_FLAT_UNCHECKED', 'BLACK_ORLB_FLAT_CHECKED', 'BLACK_ORLB_FLAT_GRAYED',
    'BLACK_ORCB_QUESTIONMARK', 'BLACK_ORCB_BLUEQUESTIONMARK',
    'BLACK_ORCB_DISABLED_UNCHECKED', 'BLACK_ORCB_DISABLED_CHECKED',
    'BLACK_ORCB_DISABLED_GRAYED', 'BLACK_ORCB_DISABLED_QUESTIONMARK',
    'BLACK_ORLB_FLAT_UNCHECKED', 'BLACK_ORLB_FLAT_CHECKED', 'BLACK_ORLB_FLAT_GRAYED',
    'BLACK_ORCB_RADIO_UNCHECKED', 'BLACK_ORCB_RADIO_CHECKED',
    'BLACK_ORCB_RADIO_DISABLED_UNCHECKED', 'BLACK_ORCB_RADIO_DISABLED_CHECKED');

  PL_ITEMS = 'Problem List Items';

  ARROW_STR = ' --> {';
  ENCOUNTER_STR = ''; //'Encounter Section: ';

var
  ORCBImages: array[TORCBImgIdx, Boolean] of TBitMap;

function GetORCBBitmap(Idx: TORCBImgIdx; BlackMode: boolean): TBitmap;
var
  ResName: string;
begin
  if (not assigned(ORCBImages[Idx, BlackMode])) then begin
    ORCBImages[Idx, BlackMode] := TBitMap.Create;
    if BlackMode then begin
      ResName := BlackCheckBoxImageResNames[Idx]
    end else begin
      ResName := CheckBoxImageResNames[Idx];
    end;
    ORCBImages[Idx, BlackMode].LoadFromResourceName(HInstance, ResName);
  end;
  Result := ORCBImages[Idx, BlackMode];
end;


procedure ListTMGDiagnosisCodesExternal(Dest: TStrings; IntEntryType: Integer);
begin
  if not Assigned(frmTMGDiagnoses) then exit;
  frmTMGDiagnoses.ListTMGDiagnosisCodes(Dest, IntEntryType);
end;

//=========================================================

function TfrmTMGDiagnoses.ShouldFilter(Entry : string) : boolean;  //fmt: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
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


procedure TfrmTMGDiagnoses.ListTMGDiagnosisCodes(Dest: TStrings; IntEntryType: Integer);
//This is a call-back function that is called by ancestor(s) of this class
//It is used for loading lbxSection (right side list) when lbSection (left side list) is clicked
var i : integer;
    EntryType : tNodeType;
    t, c, f, p, CodeName, ICDCSYS: string;
    SL : TStringList;
    SectionStr, Entry : string;
    Index : integer;
    SrcIndex : integer;  //index in SL

begin
  if IntEntryType >= 0 then begin
    ListDiagnosisCodes(Dest, IntEntryType);
    exit;
  end;
  Dest.Clear;
  IntEntryType := -IntEntryType;
  if (IntEntryType < tNODE_FIRST) or (IntEntryType > tNODE_LAST) then exit;
  EntryType := tNodeType(IntEntryType);
  SL := NodeTypeSL[EntryType]; //DEFAULT.  NOTE: SL may be changed to different TStringList below...
  if (EntryType = EncounterICDs) and assigned(frmTMGDiagnoses) then begin
    Index := lbSection.ItemIndex;
    SectionStr := lbSection.Items.Strings[Index]; //fmt: -5^<index>^<Display title>  index is # in TStringlist NodeTypeSL[EncounterICDs]
    Index := StrToIntDef(Piece(SectionStr, '^',2), 0);
    SL := TStringList(NodeTypeSL[EncounterICDs].Objects[Index]);
    if not assigned(SL) then exit;
  end;
  for i := 0 to SL.Count - 1 do begin
    Entry := SL.Strings[i];
    case EntryType of
      //SET UP VARS, for use below
      //--------------------------
      // c = ICDCode
      // t = ProblemText
      // f = CodeStatus
      // p = ProblemIEN
      //ICDSYS = ICD coding system
      //--------------------------
                               //     1       2           3                 4                 5               6                     7                   8
      TopicsDiscussed,         //fmt: 1^<TOPIC NAME>^<THREAD TEXT >^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>
      TopicsUndiscussed: begin //fmt: 2^<TOPIC NAME>^<SUMMARY TEXT>^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>
                           c := Piece(Entry, U, 5);
                           CodeName := Piece(Entry, U, 6);
                           t := Piece(Entry, U, 2);
                           //t2:= Piece(Entry, U, 3);
                           //if length(t2)>80 then t2 := LeftStr(t2, 80)+'...';
                           //t := t + IfThen(t2<>'', ' -- ', '') + t2;
                           if c <> '' then begin
                             t := t + ' --> {' + CodeName + '}';  // c + ' <-- ' + t;
                           end else begin
                             c := '???'; //Piece(Entry, U, 2);
                           end;
                           f := '';                        //kt Code Status    e.g. if outdated, has #, $, or both symbols at start
                           p := Piece(Entry, U, 4);        //kt ProblemIEN
                           ICDCSYS := Piece(Entry, U, 8);  //kt ICD Coding system  (or TMGTOPIC)
                         end;
                                 //    1  2    3        4        5   6        7          8  9         10   11   12       13     14     15         16           17            18            19                20                  21
      ProbList:          begin  //fmt: 3^ifn^status^description^ICD^onset^last modified^SC^SpExp^Condition^Loc^loc.type^prov^service^priority^has comment^date recorded^SC condition(s)^inactive flag^ICD long description^ICD coding system
                           //NOTE: This is a duplication of native functionality.  So I ended up not using this stored information.
                           c := Piece(Entry, U, 5);        //kt ICD Code
                           t := Piece(Entry, U, 4);        //kt Problem Text
                           f := Piece(Entry, U, 19);        //kt Code Status ???   e.g. if outdated, has #, $, or both symbols at start
                           p := '';  //Piece(Entry, U, 4);  //kt ProblemIEN
                           ICDCSYS := Piece(Entry, U, 21);  //kt ICD Coding system
                         end;
                                //     1      2         3                4               5
      PriorICDs:         begin  //fmt: 4^<PRIOR ICD>^<ICD LONG NAME>^<FMDT LAST USED>^<ICD_CODE_SYS>
                           c := Piece(Entry, U, 2);         //kt ICD Code
                           t := Piece(Entry, U, 3);         //kt Problem Text
                           f := ''; //Piece(Entry, U, 19);  //kt Code Status ???   e.g. if outdated, has #, $, or both symbols at start
                           p := '';  //Piece(Entry, U, 4);  //kt ProblemIEN
                           ICDCSYS := Piece(Entry, U, 5);   //kt ICD Coding system
                         end;
                                //    1  2         3          4               5             6
      EncounterICDs:     begin  //fmt 5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
                           c := Piece(Entry, U, 3);         //kt ICD Code
                           t := Piece(Entry, U, 4);         //kt Display name
                           CodeName := Piece(Entry, U, 5);
                           if t= '' then begin
                             t := CodeName;         //kt ICD Long name
                           end else begin
                             t := t + ' (' + CodeName + ')';
                           end;
                           f := ''; //Piece(Entry, U, 19);  //kt Code Status ???   e.g. if outdated, has #, $, or both symbols at start
                           p := '';  //Piece(Entry, U, 4);  //kt ProblemIEN
                           ICDCSYS := Piece(Entry, U, 6);   //kt ICD Coding system
                         end;
    end; //case
    if (Pos('#', f) > 0) or (Pos('$', f) > 0) then begin
      t := '#  ' + t;    //kt this is signal that code is inactive.  See doc in AddProbsToDiagnoses()
    end;
    SrcIndex := i ;  //NOTE: use lbSection to determine which source list is active.

    if not ShouldFilter(c + ' ' + t) then begin
      Dest.AddObject(c + U + t + U + c + U + f + U + p + U + ICDCSYS, pointer(SrcIndex)); //kt doc: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
      //Dest.Add(c + U + t + U + c + U + f + U + p + U + ICDCSYS); //kt doc: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
    end;
  end;
end;


procedure TfrmTMGDiagnoses.LoadTMGDxInfo(IEN8925 : integer; TitlesToAdd : TStringList);
//This is called when form first instantiated.  It gets server information and stores locally.
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
  CMD := 'LIST FOR NOTE^'+IntToStr(IEN8925);
  try
    tCallV(SL, 'TMG CPRS ENCOUNTER GET DX LIST', [Patient.DFN, CMD, SDT]);
    for j := TopicsDiscussed to EncounterICDs do begin
      if j = EncounterICDs then begin
        //NOTE: NodeTypeSL[EncounterICDs] is different from the others.  It format is:
        //      NodeTypeSL[EncounterICDs].strings[#] = "section name"
        //      NodeTypeSL[EncounterICDs].objects[#] = TStringList with entries for section
        for i := 0 to NodeTypeSL[EncounterICDs].Count - 1 do begin
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
        TopicsDiscussed:   begin
                             TempStr := strEntryTypeNum+'^.^Topics Discussed in note';
                             if TitlesToAdd.IndexOf(TempStr)<0 then TitlesToAdd.Add(TempStr);
                             NodeTypeSL[EntryType].Add(Entry);
                           end;
        TopicsUndiscussed: begin
                             TempStr := strEntryTypeNum+'^.^Topics NOT discussed in note';
                             if TitlesToAdd.IndexOf(TempStr)<0 then TitlesToAdd.Add(TempStr);
                             NodeTypeSL[EntryType].Add(Entry);
                           end;
        ProbList:          begin
                             continue;  //<-- remove if I later want to include problem list from TMG code (currently not as good)
                             TempStr := strEntryTypeNum+'^.^TMG Problem List Items';
                             if TitlesToAdd.IndexOf(TempStr)<0 then TitlesToAdd.Add(TempStr);
                             NodeTypeSL[EntryType].Add(Entry);
                           end;
        PriorICDs:         begin
                             TempStr := strEntryTypeNum+'^.^Prior ICD''s';
                             if TitlesToAdd.IndexOf(TempStr)<0 then TitlesToAdd.Add(TempStr);
                             NodeTypeSL[EntryType].Add(Entry);
                           end;
        EncounterICDs:     begin
                             IsHeader := (Piece(Entry,'^',2) = 'HEADER');
                             if IsHeader then begin           //fmt: 5^HEADER^<Section Name>"
                               TempSL := TStringList.Create;
                               LastHeaderIdx := NodeTypeSL[EntryType].AddObject(Entry, TempSL);
                               s2 := ENCOUNTER_STR + Piece(Entry,'^',3);
                               TitlesToAdd.Add(strEntryTypeNum+ '^' + IntToStr(LastHeaderIdx) + '^' + s2);  //fmt: -5^<index>^<Display title>
                             end else begin                   //fmt: 5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
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


procedure TfrmTMGDiagnoses.InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc; SrcPCEData : TPCEData);
var TempSL : TStringList;
    TitlesToAdd : TStringList;
    i : integer;
begin
  //kt --> I DON'T want inherited.  I will achieve here instead --> inherited InitTab(ACopyProc, AListProc);

  TempSL := TStringList.Create;
  TitlesToAdd := TStringList.Create;
  try
    FSrcPCEData := SrcPCEData;  //save local pointer to outside object.
    LoadTMGDxInfo(SrcPCEData.NoteIEN, TitlesToAdd);

    AListProc(TempSL);  //lbSection.Items  -- this is the traditional VA method of loading list.
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
  finally
    TempSL.Free;
    TitlesToAdd.Free;
  end;

end;


procedure TfrmTMGDiagnoses.EnsurePrimaryDiag;
var
  i: Integer;
  Primary: Boolean;

begin
  with lbGrid do begin
    Primary := False;
    for i := 0 to Items.Count - 1 do begin
      if TPCEDiag(Items.Objects[i]).Primary then begin
        Primary := True;
      end;
    end;

    if not Primary and (Items.Count > 0) then begin
      GridIndex := Items.Count - 1;//0; zzzzzzbellc CQ 15836
      TPCEDiag(Items.Objects[Items.Count - 1]).Primary := True;
      GridChanged;
    end;
  end;
end;

procedure TfrmTMGDiagnoses.cmdDiagPrimaryClick(Sender: TObject);
var
  gi, i: Integer;
  ADiagnosis: TPCEDiag;

begin
  inherited;
  gi := GridIndex;
  with lbGrid do for i := 0 to Items.Count - 1 do begin
    ADiagnosis := TPCEDiag(Items.Objects[i]);
    ADiagnosis.Primary := (gi = i);
  end;
  GridChanged;
end;

procedure TfrmTMGDiagnoses.edtSearchTermsChange(Sender: TObject);
begin
  inherited;
  if FProgSrchEditChange then exit;
  FProgSectionClick := true;
  PiecesToList(UpperCase(edtSearchTerms.Text), ' ', FSearchTerms);
  ListTMGDiagnosisCodes(lbxSection.Items, lbSection.ItemIEN);
  FProgSectionClick := false;

end;

procedure TfrmTMGDiagnoses.ckbDiagProbClicked(Sender: TObject);
var
  i: integer;
begin
  inherited;
  if(NotUpdating) then begin
    for i := 0 to lbGrid.Items.Count-1 do begin
      if(lbGrid.Selected[i]) then begin
        TPCEDiag(lbGrid.Items.Objects[i]).AddProb := (ckbDiagProb.Checked) and
                                                     (not isProblem(TPCEDiag(lbGrid.Items.Objects[i]))) and
                                                     (TPCEDiag(lbGrid.Items.Objects[i]).Category <> PL_ITEMS);
        //TODO: Add check for I10Active
        if TPCEDiag(lbGrid.Items.Objects[i]).AddProb and
          (Piece(Encounter.GetICDVersion, U, 1) = '10D') and
          (not ((pos('SCT', TPCEDiag(lbGrid.Items.Objects[i]).Narrative) > 0) or
          (pos('SNOMED', TPCEDiag(lbGrid.Items.Objects[i]).Narrative) > 0))) then begin
          GetSCTforICD(TPCEDiag(lbGrid.Items.Objects[i]));
        end;
      end;
    end;
    GridChanged;
  end;
end;

procedure TfrmTMGDiagnoses.clbListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbRight then begin
    FlbxSectionRightClickDown := true;
    FlbxSectionRightClickPT.X := X;
    FlbxSectionRightClickPT.Y := Y;
    FlbxSectionRightClickPT := lbxSection.ClientToScreen(FlbxSectionRightClickPT);
  end;
end;

procedure TfrmTMGDiagnoses.lbxSectionMouseLeave(Sender: TObject);
begin
  inherited;
  FlbxSectionRightClickDown := false;

end;

procedure TfrmTMGDiagnoses.lbxSectionMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbRight then FlbxSectionRightClickDown := false;
end;

procedure TfrmTMGDiagnoses.lbxSectionContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var IntEntryType : integer;
begin
  inherited;

  FlbxSectionIndex := lbxSection.ItemAtPos(MousePos, true);
//    clbList.Itemindex := clbList.itemAtPos(Point(X,Y), TRUE);

  Handled := true;  //Setting Handled=true prevents popup   DEFAULT
  IntEntryType := -lbSection.ItemIEN;
  if (IntEntryType <> ord(TopicsDiscussed)) and (IntEntryType <> ord(TopicsUndiscussed)) then exit;
  if FlbxSectionIndex = -1 then exit;
  //---- states that disallow popup should exit above -----
  Handled := false;  //allow popup
end;


procedure TfrmTMGDiagnoses.popOptEditLinkClick(Sender: TObject);
var
  frmTopicICDLinker : TfrmTopicICDLinker;
  Index, SrcIndex, IntEntryType, ModalResult : integer;
  ItemStr, SrcLine, TopicName : string;
  PriorChecked, UpdatingSave : boolean;
  EntryType : tNodeType;

begin
  inherited;
  if lbSection.ItemIEN >= 0 then exit;
  Index := FlbxSectionIndex;

  TopicName := '';
  IntEntryType := -lbSection.ItemIEN;
  if (IntEntryType <> ord(TopicsDiscussed)) and (IntEntryType <> ord(TopicsUndiscussed)) then exit;
  EntryType := tNodeType(IntEntryType);
  SrcIndex := Integer(lbxSection.Items.Objects[Index]);
  if (SrcIndex < 0) or (SrcIndex >= NodeTypeSL[EntryType].Count) then exit;
  SrcLine := NodeTypeSL[EntryType].Strings[SrcIndex]; //fmt: #^<TOPIC NAME>^<THREAD TEXT >^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>
  TopicName := Piece(SrcLine,'^',2);
  if Pos(ARROW_STR, TopicName) > 0 then TopicName := Piece2(TopicName, ARROW_STR, 1);

  frmTopicICDLinker := TfrmTopicICDLinker.Create(frmEncounterFrame);
  try
    frmTopicICDLinker.Initialize(TopicName, TMGInfoPriorICDs, TMGInfoEncounterICDs);
    ModalResult := frmTopicICDLinker.ShowModal;
    if ModalResult = mrOK then begin
      ItemStr := frmTopicICDLinker.ResultICD; //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
      SetPiece(ItemStr, '^', 2, TopicName + ARROW_STR + Piece(ItemStr,'^',2)+'}');
      PriorChecked := lbxSection.Checked[Index];
      lbxSection.Items[Index] := ItemStr; //automatically changes lbxSection.Checked[Index] -> false
      if lbxSection.Checked[Index] <> PriorChecked then begin
        UpdatingSave := FUpdatingGrid;
        FUpdatingGrid := true;
        lbxSection.Checked[Index] := PriorChecked;
        FUpdatingGrid := UpdatingSave;
      end;
      LinkTopicToICD(TopicName, ItemStr);
    end else begin
      //
    end;
  finally
    FreeAndNil(frmTopicICDLinker);
  end;

end;

procedure TfrmTMGDiagnoses.popOptRemoveLinkClick(Sender: TObject);
var
  Index, SrcIndex, IntEntryType, ModalResult : integer;
  ItemStr, SrcLine, TopicName, ICDName : string;
  EntryType : tNodeType;

begin
  inherited;
  if lbSection.ItemIEN >= 0 then exit;
  Index := FlbxSectionIndex;

  TopicName := '';
  IntEntryType := -lbSection.ItemIEN;
  if (IntEntryType <> ord(TopicsDiscussed)) and (IntEntryType <> ord(TopicsUndiscussed)) then exit;
  EntryType := tNodeType(IntEntryType);
  SrcIndex := Integer(lbxSection.Items.Objects[Index]);
  if (SrcIndex < 0) or (SrcIndex >= NodeTypeSL[EntryType].Count) then exit;
  SrcLine := NodeTypeSL[EntryType].Strings[SrcIndex]; //fmt: #^<TOPIC NAME>^<THREAD TEXT >^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>
  ICDName := Piece(SrcLine, '^', 6);
  TopicName := Piece(SrcLine,'^',2);
  if Pos(ARROW_STR, TopicName) > 0 then begin
    TopicName := Piece2(TopicName, ARROW_STR, 1);
    SetPiece(SrcLine,'^',2,TopicName);
  end;
  ModalResult := MessageDlg('Remove link? ' + CRLF +
                            TopicName + CRLF +
                            'To:' + CRLF +
                            ICDName,
                            mtConfirmation, [mbOK, mbCancel], 0);
  if ModalResult <> mrOK then exit;
  SetPiece(SrcLine,'^',5,''); SetPiece(SrcLine,'^',6,''); SetPiece(SrcLine,'^',8,'');
  NodeTypeSL[EntryType].Strings[SrcIndex] := SrcLine;
  ItemStr := '???^'+TopicName+'^???^^'+Piece(SrcLine,'^',3)+'^10D';  //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
  lbxSection.Items[Index] := ItemStr; //automatically changes lbxSection.Checked[Index] -> false
  ItemStr := '@^'+TopicName+'^@^^'+Piece(SrcLine,'^',3)+'^';  //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
  LinkTopicToICD(TopicName, ItemStr);  //This will delete link because ICD Code = "@"
end;



procedure TfrmTMGDiagnoses.FormCreate(Sender: TObject);
begin
  inherited;
  TMGInfoTopicsDiscussed        := TStringList.Create;  //kt
  TMGInfoTopicsUndiscussed      := TStringList.Create;  //kt
  TMGInfoProbList               := TStringList.Create;  //kt
  TMGInfoPriorICDs              := TStringList.Create;  //kt
  TMGInfoEncounterICDs          := TStringList.Create;  //kt

  NodeTypeSL[TopicsDiscussed]   := TMGInfoTopicsDiscussed;
  NodeTypeSL[TopicsUndiscussed] := TMGInfoTopicsUndiscussed;
  NodeTypeSL[ProbList]          := TMGInfoProbList;
  NodeTypeSL[PriorICDs]         := TMGInfoPriorICDs;
  NodeTypeSL[EncounterICDs]     := TMGInfoEncounterICDs;

  FTabName := CT_DiagNm;
  //kt FPCEListCodesProc := ListDiagnosisCodes;
  FPCEListCodesProc := ListTMGDiagnosisCodesExternal;  //this is a callback. Will be called by ancestor(s) of this class
  FPCEItemClass := TPCEDiag;
  FPCECode := 'POV';
  FSectionTabCount := 3;

  FlbxSectionRightClickDown := false;

  //Make changes to form.  This is inherited from parent, so have to do at runtime (I don't want to change parent, which may break other forms)
  lbxSection.Align := alNone;
  pnlRight := TPanel.Create(Self);
  pnlRight.Parent := pnlMain;
  pnlRight.Align := alClient;
  lbxSection.Parent := pnlRight;
  lbxSection.Align := alTop;
  lbxSection.Height := lbSection.Height;

  splRight := TSplitter.Create(Self);
  splRight.Parent := pnlRight;
  splRight.Height := lbxSection.Height+5;
  splRight.Align := alTop;

  memNarrative := TMemo.Create(Self);
  memNarrative.Parent := pnlRight;
  memNarrative.Align := alClient;
  memNarrative.Color := clCream;
  //memNarrative.ReadOnly := true;
  memNarrative.WordWrap := true;
  memNarrative.ScrollBars := ssVertical;
  memNarrative.Constraints.MinHeight := 40;

  FormResize(Self);

  FSearchTerms := TStringList.Create;
  FProgSrchEditChange := false;
  FProgSectionClick := false;
  FSearchMode := true; //this will ensure next step is carried out
  SetSearchMode(false);
end;

procedure TfrmTMGDiagnoses.FormDestroy(Sender: TObject);
var SL :TStringList;
    i : integer;
begin
  memNarrative.Parent := nil;
  memNarrative.Free;
  lbxSection.Parent := pnlMain;
  splRight.Free;
  pnlRight.Free;
  TMGInfoTopicsDiscussed.Free;
  TMGInfoTopicsUndiscussed.Free;
  TMGInfoProbList.Free;
  TMGInfoPriorICDs.Free;
  for i := 0 to TMGInfoEncounterICDs.Count - 1 do begin
    SL := TStringList(TMGInfoEncounterICDs.objects[i]);
    SL.Free;
  end;
  TMGInfoEncounterICDs.Free;
  FSearchTerms.Free;

  inherited;
end;

procedure TfrmTMGDiagnoses.btnRemoveClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  EnsurePrimaryDiag;
end;

procedure TfrmTMGDiagnoses.btnSearchClick(Sender: TObject);
begin
  inherited;
  SetSearchMode(not FSearchMode);
  if FSearchMode then edtSearchTerms.SetFocus;
end;

procedure TfrmTMGDiagnoses.ConfigureForSearchMode(SearchMode : boolean);
begin
  edtSearchTerms.Visible := SearchMode;
  btnClearSrch.Visible := SearchMode;
  lblList.Visible := not SearchMode;
end;


procedure TfrmTMGDiagnoses.SetSearchMode(Mode : boolean);
begin
  if FSearchMode = Mode then exit; //no change needed
  FSearchMode := Mode;
  FProgSrchEditChange := true;
  edtSearchTerms.Text := '';
  FProgSrchEditChange := false;
  ConfigureForSearchMode(FSearchMode);
  if FSearchMode = false then edtSearchTermsChange(self);  //this will trigger redisplay WITHOUT filter
end;

procedure TfrmTMGDiagnoses.UpdateNewItemStr(var x: string);
begin
  inherited;
  x := x + U + IfThen(lbGrid.Items.Count = 0, '1', '0');
end;

procedure TfrmTMGDiagnoses.UpdateProblem(AplIEN: String; AICDCode: String; ASCTCode: String = '');
var
  AList: TStringList;
  ProbRec: TProbRec;
  CodeSysStr: String;
  DateOfInt: TFMDateTime;  //kt  //agp
begin
  // Update problem list entry with new ICD (& SCT) code(s) (& narrative).
  AList := TStringList.create;
  try
    FastAssign(EditLoad(AplIEN, Encounter.Provider, User.StationNumber), AList) ;
    ProbRec := TProbRec.create(AList);
    ProbRec.PIFN := AplIEN;

    if AICDCode <> '' then begin
      ProbRec.Diagnosis.DHCPtoKeyVal(Pieces(AICDCode, U, 1, 2));
      CodeSysStr := Piece(AICDCode, U, 4);
      if (Pos('10', CodeSysStr) > 0) then begin
        CodeSysStr := '10D^ICD-10-CM'
      end else begin
        CodeSysStr := 'ICD^ICD-9-CM';
      end;
      ProbRec.CodeSystem.DHCPtoKeyVal(CodeSysStr);
    end;

    if ASCTCode <> '' then begin
      ProbRec.SCTConcept.DHCPtoKeyVal(Pieces(ASCTCode, U, 1, 2));
      //TODO: need to accommodate changes to Designation Code
      ProbRec.Narrative.DHCPtoKeyVal(U + Piece(ASCTCode, U, 3));
      ProbRec.SCTDesignation.DHCPtoKeyVal(Piece(ASCTCode, U, 4) + U + Piece(ASCTCode, U, 4));  //agp //kt
    end;

    ProbRec.RespProvider.DHCPtoKeyVal(IntToStr(Encounter.Provider) + u + Encounter.ProviderName);
    //kt prior --> ProbRec.CodeDateStr := FormatFMDateTime('mm/dd/yy', Encounter.DateTime);
    //agp //kt begin
    if Encounter.DateTime = 0 then DateOfInt := FMNow
    else DateOfInt := Encounter.DateTime;
    ProbRec.CodeDateStr := FormatFMDateTime('mm/dd/yy', DateOfInt);
    //agp //kt end
    AList.Clear;
    FastAssign(EditSave(ProbRec.PIFN, User.DUZ, User.StationNumber, '1', ProbRec.FilerObject, ''), AList);
  finally
    AList.clear;
  end;
end;

function TfrmTMGDiagnoses.isProblem(diagnosis: TPCEDiag): Boolean;
var
  i: integer;
  p, code, narr, sct: String;
begin
  result := false;
  for i := 0 to FProblems.Count - 1 do begin
    p := FProblems[i];
    code := piece(p, '^', 1);
    narr := piece(p, '^', 2);
    if (pos('SCT', narr) > 0) or (pos('SNOMED', narr) > 0) then begin
      sct := piece(piece(piece(narr, ')', 1), '(', 2), ' ', 2)
    end else begin
      sct := '';
    end;
    narr := TrimRight(piece(narr, '(',1));
    if pos(diagnosis.Code, code) > 0 then begin
      result := true;
      break;
    end else if (sct <> '') and (pos(sct, diagnosis.Narrative) > 0) then begin
      result := true;
      break;
    end else if pos(narr, diagnosis.Narrative) > 0 then begin
      result := true;
      break;
    end;
  end;
end;

function TfrmTMGDiagnoses.isEncounterDx(problem: string): Boolean;
var
  i: integer;
  dx, code, narr, pCode, pNarrative, sct: String;

  function ExtractCode(narr: String; csys: String): String;
  var cso: Integer;
  begin
    if csys = 'SCT' then begin
      cso := 4;
    end else if (csys = 'ICD') and (pos('ICD-10', narr) > 0) then begin
      csys := 'ICD-10-CM';
      cso := 10;
    end else begin
      csys := 'ICD-9-CM';
      cso := 9;
    end;
    if (pos(csys, narr) > 0) then begin
      result := Piece(copy(narr, pos(csys, narr) + cso, length(narr)), ')', 1);
    end else begin
      result := '';
    end;
  end;

begin
  result := false;
  pCode := piece(problem, U, 1);
  pNarrative := piece(problem, U, 2);
  for i := 0 to lbGrid.Items.Count - 1 do begin
    dx := lbGrid.Items[i];
    narr := piece(dx, U, 3);
    code := ExtractCode(narr, 'ICD');
    sct := ExtractCode(narr, 'SCT');
    if pos(pCode, narr) > 0 then begin
      result := true;
      break;
    end else if (sct <> '') and (pos(sct, pNarrative) > 0) then begin
      result := true;
      break;
    end else if pos(narr, pNarrative) > 0 then begin
      result := true;
      break;
    end;
  end;
end;

procedure TfrmTMGDiagnoses.UpdateControls;
var
  i, j, k, PLItemCount: integer;
  OK: boolean;
const
  PL_ITEMS = 'Problem List Items';
begin
  inherited;
  if(NotUpdating) then begin
    BeginUpdate;
    try
      cmdDiagPrimary.Enabled := (lbGrid.SelCount = 1);
      OK := (lbGrid.SelCount > 0);
      PLItemCount := 0;
      if OK then begin
        for k := 0 to lbGrid.Items.Count - 1 do begin
          if (lbGrid.Selected[k]) then begin
            if (TPCEDiag(lbGrid.Items.Objects[k]).Category = PL_ITEMS) or isProblem(TPCEDiag(lbGrid.Items.Objects[k])) then begin
              PLItemCount := PLItemCount + 1;
            end;
          end;
        end;
      end;
      OK := OK and (PLItemCount < lbGrid.SelCount);
      ckbDiagProb.Enabled := OK;
      if(OK) then begin
        j := 0;
        for i := 0 to lbGrid.Items.Count-1 do begin
          if(lbGrid.Selected[i]) and (TPCEDiag(lbGrid.Items.Objects[i]).AddProb) then begin
            inc(j);
          end;
        end;
        if(j = 0) then begin
          ckbDiagProb.Checked := FALSE
        end else if(j < lbGrid.SelCount) then begin
          ckbDiagProb.State := cbGrayed
        end else begin
          ckbDiagProb.Checked := TRUE;
        end;
      end else begin
        ckbDiagProb.Checked := FALSE;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmTMGDiagnoses.FormResize(Sender: TObject);
begin
  inherited;
  FSectionTabs[0] := -(lbxSection.width - LBCheckWidthSpace - (10 * MainFontWidth) - ScrollBarWidth);
  FSectionTabs[1] := -FSectionTabs[0]+2;
  FSectionTabs[2] := -FSectionTabs[0]+4;
  UpdateTabPos;
end;

procedure TfrmTMGDiagnoses.lbxSectionClickCheck(Sender: TObject; Index: Integer);
var
  ICDCode, ICDPar, SCTCode, SCTPar, plIEN, msg, SecItem, InputStr, OrigProbStr, I10Description: String;
  EntryType : tNodeType;
  IntEntryType: Integer;
  ItemStr : string;
  SelICDCode,ProblemText,CodeStatus,ProbIEN,ICDCSYS: string;
  TopicName,TopicNarrative : string;
  SrcIndex : integer;
  SrcLine : string;
  frmTopicICDLinker : TfrmTopicICDLinker;
  ModalResult : integer;
  UpdatingSave : boolean;

  function GetSearchString(AString: String): String;
  begin
    if (Pos('#', AString) > 0) then
      Result := TrimLeft(Piece(AString, '#', 2))
    else
      Result := AString;
  end;

begin
  FlbxSectionIndex := -1;
  TopicNarrative := '';
  if (not FUpdatingGrid) and (lbxSection.Checked[Index]) then begin
    ItemStr := lbxSection.Items[Index];  //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem

    SCTPar := '';
    InputStr := '';
    TopicName := '';
    OrigProbStr := ItemStr;
    SrcLine := '';
    SrcIndex := 0;
    IntEntryType := 0;
    if lbSection.ItemIEN < 0 then begin  //kt
      IntEntryType := -lbSection.ItemIEN;
      if (IntEntryType >= tNODE_FIRST) and (IntEntryType <= tNODE_LAST) then begin
        EntryType := tNodeType(IntEntryType);
        SrcIndex := Integer(lbxSection.Items.Objects[Index]);
        if (SrcIndex < 0) or (SrcIndex >= NodeTypeSL[EntryType].Count) then begin
          lbxSection.Checked[Index] := false;
          exit;
        end;
        SrcLine := NodeTypeSL[EntryType].Strings[SrcIndex];
        case EntryType of          //     1       2           3                 4                 5               6                     7                   8
          TopicsDiscussed,         //fmt: 1^<TOPIC NAME>^<THREAD TEXT >^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>
          TopicsUndiscussed: begin //fmt: 2^<TOPIC NAME>^<SUMMARY TEXT>^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>
                               TopicNarrative := Piece(SrcLine,'^',3);
                               TopicName := Piece(SrcLine,'^',2);
                               //p2 := piece(ItemStr,'^',2);
                               //p2 := piece2(p2, ' -- ',1);
                               //SetPiece(ItemStr,'^',2, p2);
                             end;
          ProbList: ;
          PriorICDs:         begin
                               TopicNarrative := Piece(SrcLine,'^',3);
                             end;
        end;
      end;
    end;
    //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
    SelICDCode := Piece(ItemStr, U, 1);
    ProblemText := Piece(ItemStr, U, 2);
    CodeStatus := Piece(ItemStr, U, 4);
    ProbIEN := Piece(ItemStr, U, 5);
    ICDCSYS := Piece(ItemStr, U, 6);

    if FlbxSectionRightClickDown and (SelICDCode <> '???') then begin
      if (IntEntryType <> ord(TopicsDiscussed)) and (IntEntryType <> ord(TopicsUndiscussed)) then begin
        lbxSection.Checked[Index] := false;
        exit;
      end;
      FlbxSectionIndex := Index;
      popSectionRClick.Popup(FlbxSectionRightClickPT.X, FlbxSectionRightClickPT.Y);
      exit;
    end;

    if (SelICDCode = '???') and ((IntEntryType = ord(TopicsDiscussed)) or (IntEntryType = ord(TopicsDiscussed))) then begin
      frmTopicICDLinker := TfrmTopicICDLinker.Create(frmEncounterFrame);
      try
        frmTopicICDLinker.Initialize(TopicName, TMGInfoPriorICDs, TMGInfoEncounterICDs);
        ModalResult := frmTopicICDLinker.ShowModal;
        if ModalResult = mrOK then begin
          TopicName := ProblemText;
          ItemStr := frmTopicICDLinker.ResultICD; //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
          SetPiece(ItemStr, '^', 2, TopicName + ARROW_STR + Piece(ItemStr,'^',2)+'}');
          lbxSection.Items[Index] := ItemStr; //automatically changes lbxSection.Checked[Index] -> false
          UpdatingSave := FUpdatingGrid; FUpdatingGrid := true;
          lbxSection.Checked[Index] := true;  //reset to true
          FUpdatingGrid := UpdatingSave;
          SelICDCode := Piece(ItemStr, U, 1);
          ProblemText := Piece(ItemStr, U, 2);
          CodeStatus := Piece(ItemStr, U, 4);
          ProbIEN := Piece(ItemStr, U, 5);
          ICDCSYS := Piece(ItemStr, U, 6);
                              //     1       2           3                 4                 5               6                     7                   8
          //Change SrcLine    //fmt: 1^<TOPIC NAME>^<THREAD TEXT >^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>
          SetPiece(SrcLine,'^', 5, SelICDCode);
          SetPiece(SrcLine,'^', 6, ProblemText);
          SetPiece(SrcLine,'^', 8, ICDCSYS);
          NodeTypeSL[EntryType].Strings[SrcIndex] := SrcLine;
          //Link TopicName -> ICD
          LinkTopicToICD(TopicName, ItemStr);
        end else begin
          lbxSection.Checked[Index] := false;
          exit;
        end;
      finally
        FreeAndNil(frmTopicICDLinker);
      end;
    end;

    if (CodeStatus = '#') or (Pos('799.9', SelICDCode) > 0) or (Pos('R69', SelICDCode) > 0) then begin
      if (CodeStatus = '#') then begin
        msg := TX_INACTIVE_ICD_CODE
      end else begin
        msg := TX_NONSPEC_ICD_CODE;
      end;

      InputStr := GetSearchString(ProblemText);

      LexiconLookup(ICDCode, LX_ICD, 0, True, InputStr, msg);  //ICDCode is an out parameter

      if (Piece(ICDCode, U, 1) <> '') then begin
        plIEN := ProbIEN;

        FUpdatingGrid := TRUE;
        lbxSection.Items[Index] := Pieces(ICDCode, U, 1, 2) + U + Piece(ICDCode, U, 1) + U + plIEN;
        ItemStr := lbxSection.Items[Index]; //kt
        lbxSection.Checked[Index] := True;
        if plIEN <> '' then begin
          if not (Pos('SCT', Piece(ICDCode, U, 2)) > 0) and (Piece(Encounter.GetICDVersion, U, 1) = '10D') then begin
            //ask for SNOMED CT
            //agp //kt prior --> LexiconLookup(SCTCode, LX_SCT, 0, True, InputStr, TX_PROB_LACKS_SCT_CODE);
            I10Description := Piece(ICDCode, U, 2) + ' (' + Piece(ICDCode, U, 4) + #32 + Piece(ICDCode, U, 1) + ')'; //agp //kt
            LexiconLookup(SCTCode, LX_SCT, 0, True, InputStr, TX_PROB_LACKS_SCT_CODE + CRLF + CRLF + I10Description); //agp //kt

            if (Piece(SCTCode, U, 4) <> '') then begin    //agp  //kt changed piece 3 -> 4
              SecItem := lbxSection.Items[Index];
              SetPiece(SecItem, U, 2, Piece(SCTCode, U, 2));

              FUpdatingGrid := TRUE;
              lbxSection.Items[Index] := SecItem;
              lbxSection.Checked[Index] := True;
              if plIEN <> '' then begin
                //agp //kt prior --> SCTPar := Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 2);
                SCTPar := Piece(SCTCode, U, 4) + U + Piece(SCTCode, U, 4) + U + Piece(SCTCode, U, 2) + U + Piece(SCTCode, U, 3);  //agp //kt
              end;
              FUpdatingGrid := FALSE;
            end else begin
              //Undo previous ICD-10 updates when cancelling out of the SCT update dialog
              lbxSection.Items[Index] := OrigProbStr;
              lbxSection.Checked[Index] := False;
              FUpdatingGrid := False;
              exit;
            end;
          end;
          ICDPar := Piece(ICDCode, U, 3) + U + Piece(ICDCode, U, 1) + U + Piece(ICDCode, U, 2) + U + Piece(ICDCode, U, 4);
          UpdateProblem(plIEN, ICDPar, SCTPar);
          PLUpdated := True; //agp //kt
        end;
        FUpdatingGrid := FALSE;
      end else begin
        lbxSection.Checked[Index] := False;
        exit;
      end;
    end else if (Piece(lbxSection.Items[Index], U, 4) = '$') then begin
      // correct inactive SCT Code
      msg := TX_INACTIVE_SCT_CODE;

      LexiconLookup(SCTCode, LX_SCT, 0, True, InputStr, msg);

      if (Piece(SCTCode, U, 3) <> '') then begin
        plIEN := Piece(lbxSection.Items[Index], U, 5);

        SecItem := lbxSection.Items[Index];
        SetPiece(SecItem, U, 2, Piece(SCTCode, U, 2));

        FUpdatingGrid := TRUE;
        lbxSection.Items[Index] := SecItem;
        lbxSection.Checked[Index] := True;
        if plIEN <> '' then begin
          SCTPar := Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 2);
          UpdateProblem(plIEN, '', SCTPar);
          PLUpdated := True;  //agp //kt
        end;
        FUpdatingGrid := FALSE;
      end else begin
        lbxSection.Checked[Index] := False;
        exit;
      end;
    end else if (Piece(lbxSection.Items[Index], U, 4) = '#$') then begin
      // correct inactive SCT Code
      msg := TX_INACTIVE_SCT_CODE;

      LexiconLookup(SCTCode, LX_SCT, 0, True, InputStr, msg);

      if (Piece(SCTCode, U, 3) = '') then begin
        lbxSection.Checked[Index] := False;
        exit;
      end;

      // correct inactive ICD Code
      msg := TX_INACTIVE_ICD_CODE;

      LexiconLookup(ICDCode, LX_ICD, 0, True, '', msg);

      if (Piece(ICDCode, U, 1) <> '') and (Piece(SCTCode, U, 3) <> '') then begin
        plIEN := Piece(lbxSection.Items[Index], U, 5);

        SetPiece(ICDCode, U, 2, Piece(SCTCode, U, 2));

        FUpdatingGrid := TRUE;
        lbxSection.Items[Index] := Pieces(ICDCode, U, 1, 2) + U + Piece(ICDCode, U, 1) + U + plIEN;
        lbxSection.Checked[Index] := True;
        if plIEN <> '' then begin
          SCTPar := Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 2);
          ICDPar := Piece(ICDCode, U, 3) + U + Piece(ICDCode, U, 1) + U + Piece(ICDCode, U, 2) + U + Piece(ICDCode, U, 4);
          UpdateProblem(plIEN, ICDPar, SCTPar);
        end;
        FUpdatingGrid := FALSE;
      end else begin
        lbxSection.Checked[Index] := False;
        exit;
      end;
    end else if (Piece(lbSection.Items[lbSection.ItemIndex], U, 2) = PL_ITEMS) and
      (Piece(Encounter.GetICDVersion, U, 1) = '10D') and
      not (Pos('SCT', Piece(lbxSection.Items[Index], U, 2)) > 0) then
    begin
      // Problem Lacks SCT Code
      //agp //kt prior --> msg := TX_PROB_LACKS_SCT_CODE;
      msg := TX_PROB_LACKS_SCT_CODE + CRLF + CRLF + Piece(lbxSection.Items[Index], U, 2);  //agp //kt

      LexiconLookup(SCTCode, LX_SCT, 0, True, InputStr, msg);

      if (Piece(SCTCode, U, 3) <> '') then begin
        plIEN := Piece(lbxSection.Items[Index], U, 5);

        SecItem := lbxSection.Items[Index];
        SetPiece(SecItem, U, 2, Piece(SCTCode, U, 2));

        FUpdatingGrid := TRUE;
        lbxSection.Items[Index] := SecItem;
        lbxSection.Checked[Index] := True;
        if plIEN <> '' then begin
          SCTPar := Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 2);
          UpdateProblem(plIEN, '', SCTPar);
        end;
        FUpdatingGrid := FALSE;
      end else begin
        lbxSection.Checked[Index] := False;
        exit;
      end;
    end else if (Piece(Encounter.GetICDVersion, U, 1) = 'ICD') and
      ((Pos('ICD-10', Piece(lbxSection.Items[Index], U, 2)) > 0) or (Piece(lbxSection.Items[Index], U, 6)='10D')) then
    begin
      // Attempting to add an ICD10 diagnosis code to an ICD9 encounter
      InfoBox(TX_INV_ICD10_DX, TC_INV_ICD10_DX, MB_ICONERROR or MB_OK);
      lbxSection.Checked[Index] := False;
      exit;
    end else if isEncounterDx(lbxSection.Items[Index]) then begin
      InfoBox(TX_REDUNDANT_DX, TC_REDUNDANT_DX + piece(lbxSection.Items[Index], '^',2), MB_ICONWARNING or MB_OK);
      lbxSection.Checked[Index] := False;
      exit;
    end;
  end;
  memNarrative.Lines.Text := TopicNarrative;
  inherited;
  EnsurePrimaryDiag;
end;

procedure TfrmTMGDiagnoses.lbxSectionDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Narr, Code: String;
  Format, CodeTab, ItemRight, DY: Integer;
  ARect, TmpR: TRect;
  BMap: TBitMap;
begin
  inherited;
  Narr := Piece((Control as TORListBox).Items[Index], U, 2);
  Code := Piece((Control as TORListBox).Items[Index], U, 3);
  CodeTab := StrToInt(Piece(lbxSection.TabPositions, ',', 2));

  // draw CheckBoxes
  with lbxSection do begin
    if (CheckBoxes) then begin
      case CheckedState[Index] of
        cbUnchecked: begin
                       if (FlatCheckBoxes) then begin
                         BMap := GetORCBBitmap(iiFlatUnChecked, False)
                       end else begin
                         BMap := GetORCBBitmap(iiUnchecked, False);
                       end;
                     end;
        cbChecked:   begin
                       if (FlatCheckBoxes) then begin
                         BMap := GetORCBBitmap(iiFlatChecked, False)
                       end else begin
                         BMap := GetORCBBitmap(iiChecked, False);
                       end;
                     end;
        else         begin// cbGrayed:
                       if (FlatCheckBoxes) then begin
                         BMap := GetORCBBitmap(iiFlatGrayed, False)
                       end else begin
                         BMap := GetORCBBitmap(iiGrayed, False);
                       end;
                     end;
      end; //case
      TmpR := Rect;
      TmpR.Right := TmpR.Left;
      dec(TmpR.Left, (LBCheckWidthSpace - 5));
      DY := ((TmpR.Bottom - TmpR.Top) - BMap.Height) div 2;
      Canvas.Draw(TmpR.Left, TmpR.Top + DY, BMap);
    end;
  end;

  // draw the Problem Text
  ARect := (Control as TListBox).ItemRect(Index);
  ARect.Left := ARect.Left + LBCheckWidthSpace;
  ItemRight := ARect.Right;
  ARect.Right := CodeTab - 10;
  Format := (DT_LEFT or DT_NOPREFIX or DT_WORD_ELLIPSIS);
  DrawText((Control as TListBox).Canvas.Handle, PChar(Narr), Length(Narr), ARect, Format);

  // now draw ICD codes
  ARect.Left := CodeTab;
  ARect.Right := ItemRight;
  DrawText((Control as TListBox).Canvas.Handle, PChar(Code), Length(Code), ARect, Format);
end;

procedure TfrmTMGDiagnoses.BitBtn1Click(Sender: TObject);
var
  frmProbAutoAdd: TfrmProbAutoAdd;
  Result : string;
begin
  inherited;
  frmProbAutoAdd := TfrmProbAutoAdd.Create(Self);
  frmProbAutoAdd.ShowModal;
  Result := frmProbAutoAdd.ResultMessage;  //e.g.   'EDIT^'+IEN+'^'+Name+'^'+ICD+'^'+Category;
  FreeAndNil(frmProbAutoAdd);
end;

procedure TfrmTMGDiagnoses.btnClearSrchClick(Sender: TObject);
begin
  inherited;
  SetSearchMode(false);
end;

procedure TfrmTMGDiagnoses.btnOKClick(Sender: TObject);
begin
  inherited;
  if  BILLING_AWARE then
     GetEncounterDiagnoses;
  if ckbDiagProb.Checked then  //agp //kt
    PLUpdated := True;         //agp //kt
end;

procedure TfrmTMGDiagnoses.lbGridSelect(Sender: TObject);
begin
  inherited;
  Sync2Grid;
end;


procedure TfrmTMGDiagnoses.GetEncounterDiagnoses;
var
  i: integer;
  dxCode, dxName: string;
  ADiagnosis: TPCEItem;
begin
  inherited;
  UBAGlobals.BAPCEDiagList.Clear;
  with lbGrid do for i := 0 to Items.Count - 1 do begin
    ADiagnosis := TPCEDiag(Items.Objects[i]);
    dxCode :=  ADiagnosis.Code;
    dxName :=  ADiagnosis.Narrative;
    if BAPCEDiagList.Count = 0 then begin
      UBAGlobals.BAPCEDiagList.Add(U + DX_ENCOUNTER_LIST_TXT);
    end;
    UBAGlobals.BAPCEDiagList.Add(dxCode + U + dxName);
  end;
end;

procedure TfrmTMGDiagnoses.GetSCTforICD(ADiagnosis: TPCEDiag);
var
  Code, msg, ICDDescription: String;  //agp //kt
begin
  // look-up SNOMED CT
  //agp //kt prior --> LexiconLookup(Code, LX_SCT, 0, False, ADiagnosis.Narrative, TX_ICD_LACKS_SCT_CODE);
  //agp WV INTEGRATE CPRS30.70 CHANGES  begin  //kt
  ICDDescription := ADiagnosis.Narrative + ' (' + Piece(Encounter.GetICDVersion, U, 2) + #32 + ADiagnosis.Code + ')';
  msg := TX_ICD_LACKS_SCT_CODE + CRLF + CRLF + ICDDescription;
  LexiconLookup(Code, LX_SCT, 0, False, ADiagnosis.Narrative, msg);
  //agp end

  if (Code = '') then begin
    ckbDiagProb.Checked := False;
  end else begin
    ADiagnosis.Narrative := Piece(Code, U, 2);
  end;
end;

procedure TfrmTMGDiagnoses.lbSectionClick(Sender: TObject);
var IntEntryType : integer;
    SrchEnable : boolean;
begin
  if not FProgSectionClick then SetSearchMode(false);
  IntEntryType := -lbSection.ItemIEN;
  SrchEnable := true;
  btnSearch.Visible := SrchEnable;
  if not SrchEnable then SetSearchMode(false);
  inherited;        //note: this calls 'FPCEListCodesProc' which is really ListTMGDiagnosisCodesExternal(), setup in FormCreate
end;

procedure TfrmTMGDiagnoses.lbSectionDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  lb : TListBox;
  item : string;

begin
  inherited;
  lb := TListbox(Control);
  item := lb.items[index];
  if (item = DX_PROBLEM_LIST_TXT)   or
     (item = DX_PERSONAL_LIST_TXT)  or
     (item = DX_TODAYS_DX_LIST_TXT) or
     (item = DX_ENCOUNTER_LIST_TXT) then begin
    lb.Canvas.Font.Style := [fsBold]
  end else begin
    lb.Canvas.Font.Style := [];
  end;

  lb.Canvas.TextOut(Rect.Left+2, Rect.Top+1, item); {display the text }
end;

procedure TfrmTMGDiagnoses.LinkTopicToICD(TopicName, ICDInfo : string);
//ICDInfo format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem

var SL : TStringList;
    ICDInfo2 : string;  //format: '<ICD_IEN>;<ICD_CODE>;<ICD_CODING_SYS>;<AS-OF FMDT>'
    Results : TStringList;
    Line : string;
    ICDCode,CodeSys,CDT,ProbIEN : string;
begin
  SL := TStringList.Create;
  Results := TStringList.Create;
  try
    //ICDInfo format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
    ICDCode := Piece(ICDInfo,'^',1);
    CodeSys := Piece(ICDInfo,'^',6);
    CDT     := FMDTToStr(FSrcPCEData.DateTime);
    ProbIEN := Piece(ICDInfo,'^',5);

    ICDInfo2 := '0' + ';' + ICDCode + ';' + CodeSys + ';' + CDT;           //Needed format: '<ICD_IEN>;<ICD_CODE>;<ICD_CODING_SYS>;<AS-OF FMDT>'
    SL.Add('SET^' + Patient.DFN + U + TopicName + U + '0' + U + ICDInfo2);  //Needed format: 'SET^<DFN>^<TopicName>^<ProblemIEN>^<ICD_INFO*>^<SCTIEN>'  <-- can have any combo of IENS's
    TMGTopicLinks(Results, SL);
    if Results.Count > 0 then begin     //Out(#)=1^OK  or -1^ErrorMessage  <-- if line command was a SET or KILL command
      Line := Results[0];
      if Piece(Line,'^',1) = '-1' then begin
        MessageDlg('Error linking Topic to ICD: ' + Piece(Line,'^',2), mtError, [mbOK], 0);
      end;
    end;
  finally
    SL.Free;
    Results.Free;
  end;

end;

initialization
  SpecifyFormIsNotADialog(TfrmTMGDiagnoses);

end.