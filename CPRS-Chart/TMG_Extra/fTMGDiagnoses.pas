unit fTMGDiagnoses;

//kt Copied from fDiagnoses because I plan extensive modifications.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, CheckLst, ORNet, ExtCtrls, Buttons, uPCE, ORFn,
  ComCtrls, fPCEBaseMain, UBAGlobals, UBAConst, UCore, VA508AccessibilityManager,
  fPCELex, //kt
  ORCtrls, Menus;

type
  tNodeType = (ntNone=0, TopicsDiscussed=1, TopicsUndiscussed=2, ProbList=3, PriorICDs=4, EncounterICDs=5);

  TfrmTMGDiagnoses = class(TfrmPCEBaseMain)
    cmdDiagPrimary: TBitBtn;
    ckbDiagProb: TCheckBox;
    BitBtn1: TBitBtn;
    popSectionRClick: TPopupMenu;
    popOptRemoveLink: TMenuItem;
    popOptEditLink: TMenuItem;
    btnSearch: TBitBtn;
    edtSearchTerms: TEdit;
    btnClearSrch: TBitBtn;
    btnNext: TBitBtn;
    btnUnlink: TBitBtn;
    btnEditSection: TBitBtn;
    btnDelDx: TBitBtn;
    btnAddDx: TBitBtn;
    btnSrchICD: TBitBtn;
    btnAddSection: TBitBtn;
    btnDelSection: TBitBtn;
    btnEditDx: TBitBtn;
    popAddAddlDx: TMenuItem;
    procedure popAddAddlDxClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnEditDxClick(Sender: TObject);
    procedure btnDelSectionClick(Sender: TObject);
    procedure btnAddSectionClick(Sender: TObject);
    procedure btnAddDxClick(Sender: TObject);
    procedure btnOtherClick(Sender: TObject);
    procedure btnDelDxClick(Sender: TObject);
    procedure lbSectionChange(Sender: TObject);
    procedure btnUnlinkClick(Sender: TObject);
    procedure btnEditSectionClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure lbxSectionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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
    FlbxSectionHoverIndex : integer;
    FListProc: TListSectionsProc;
    FCopyProc: TCopyItemsMethod;
    EntryDataStr : TDataStr;  //format: STD_ICD_DATA_FORMAT        ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys
    SelectedSectionName : string;
    SelectedSectionType : tNodeType;
    LastLbxSectionIndex : integer;
    FAddToEncounterForm : boolean;
    procedure EnsurePrimaryDiag;
    procedure GetSCTforICD(ADiagnosis: TPCEDiag);
    procedure UpdateProblem(AplIEN: String; AICDCode: String; ASCTCode: String = '');
    function isProblem(diagnosis: TPCEDiag): Boolean;
    function isEncounterDx(problem: string): Boolean;
    procedure LoadTMGDxInfo(IEN8925 : integer; TitlesToAdd : TStringList);
    procedure LinkTopicToICD(TopicName: string;  ItemDataStr : TDataStr; Mode:string='SET');
    procedure SetSearchMode(Mode : boolean);
    procedure ConfigureForSearchMode(SearchMode : boolean);
    function ShouldFilter(Entry : string) : boolean;
    function HandleNeedsLink(TopicName : string; Index : integer; Mode:string='SET') : boolean; //result is OK, i.e. not Cancelled
    function HandleBadICDCode(ItemDataStr : TDataStr; Index : integer) : boolean; //result is OK, i.e. not Cancelled
    function CorrectInactiveSCTCode(ItemDataStr : TDataStr; Index : integer) : boolean; //result is OK, i.e. not Cancelled
    function CorrectBadOrInactiveSCTCode(ItemDataStr : TDataStr; Index : integer) : boolean; //result is OK, i.e. not Cancelled
    function CorrectMissingSCTCode(ItemDataStr : TDataStr; Index : integer) : boolean; //result is OK, i.e. not Cancelled
    procedure GetlbxSectionInfo(Index : integer; var ADataStr : TDataStr; var OutEntryType : tNodetype);
    procedure RemoveIndexLink(Index : integer;NoPrompt:boolean = False);
    procedure SetUnlinkBtnStatus;
    procedure UpdateStatusForRightSide;
    procedure UpdateStatusForLeftSide;
    procedure HandlePCELookupCBChange(PCELexForm : TfrmPCELex; checked : boolean);  //kt added
    procedure LexLookupFormTweaker(PCELexForm : TfrmPCELex);  //kt added
    function  GetCustomCode(Sender: TObject; SelectedSection : string) : string;
    function  GetCurrentSelectedSectionName : string;
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
    procedure ListTMGDiagnosisCodes(Dest: TStrings; IntEntryType: Integer);
    //procedure DeletelbxSectionEntry(DelIndex : integer);
  public
    IsDirty:boolean;      //11/14/23
    procedure SetDirtyStatus(DirtyStatus:boolean);  //11/14/23
    procedure InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc; SrcPCEData : TPCEData);
    procedure SendData(var SendErrors,UnpastedHTML:string);
    procedure ReloadSectionData;
    procedure LoadSectionItems(AutoSelectIndex : integer = 0);
    procedure GetSelectedDxs(OutDxList : TStringList);
  end;

var
  frmTMGDiagnoses: TfrmTMGDiagnoses;
  dxList : TStringList;
  PlUpdated: boolean = False;  //agp //kt

  procedure DeletelbxSectionEntry(lbSection, lbxSection : TORListBox; DelIndex : integer);  //forward;


implementation

{$R *.DFM}

uses
  fEncounterFrame, uConst, UBACore, VA508AccessibilityRouter, {fPCELex,} rPCE, uProbs, rProbs,
  uTMGTypes, fGUIEditFMFile, fDiagnoses, StrUtils, fTopicICDLinkerU, fProbAutoAdd, fNotes, fTMGEncounterICDPicker, //kt
  fHFSearch, fPCEOther,
  rTIU, rCore, fTMGEncounterEditor;  //agp //kt

type
  TORCBImgIdx = (iiUnchecked, iiChecked, iiGrayed, iiQMark, iiBlueQMark,
    iiDisUnchecked, iiDisChecked, iiDisGrayed, iiDisQMark,
    iiFlatUnChecked, iiFlatChecked, iiFlatGrayed,
    iiRadioUnchecked, iiRadioChecked, iiRadioDisUnchecked, iiRadioDisChecked);

CONST
  tNODE_FIRST = ord(TopicsDiscussed);
  tNODE_LAST = ord(EncounterICDs);

                                                                                                                    //       1     2             3                4               5                 6                      7                  8
  TOPIC_PROBLEM_FORMAT       = 'Code^TopicName^ThreadText^ProblemIEN^ICDCode^ICDLongName^SnowmedName^ICDCodeSys^Color';   // 1^<TOPIC NAME>^<THREAD TEXT >^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>^<COLOR>

                                                          //  1     2         3
  SECTION_DATA_FORMAT        = 'Type^Index^DisplayText^Color';  //'Type^Index^DisplayText';

                                                                                                                                                                                                             //     1  2   3       4          5   6         7         8   9       10     11   12     13     14      15       16            17           18                 19              20                 21
  PROB_LIST_DATA_FORMAT      = 'Type^ifn^status^description^ICDCode^onset^LastModified^SC^SpExp^Cond^Loc^LocType^prov^service^priority^HasComment^DateRecorded^SCCond^InactiveFlag^ICDLongName^ICDCodeSys^Color';  //fmt: 3^ifn^status^description^ICD^onset^last modified^SC^SpExp^Condition^Loc^loc.type^prov^service^priority^has comment^date recorded^SC condition(s)^inactive flag^ICD long description^ICD coding system

                                                                                     //     1      2         3                4               5
  PRIOR_ICDS_DATA_FORMAT     = 'Type^ICDCode^ICDLongName^FMDTLastUsed^ICDCodeSys^Color';   //fmt: 4^<PRIOR ICD>^<ICD LONG NAME>^<FMDT LAST USED>^<ICD_CODE_SYS>

                                                                                     //              1   2       3           4               5             6
  ENCOUNTER_ICDS_DATA_FORMAT = 'Type^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys^Color';  //fmt 5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"

  NODE_TYPE_DATA_FORMAT : array[TopicsDiscussed..EncounterICDs] of string = (
    TOPIC_PROBLEM_FORMAT,
    TOPIC_PROBLEM_FORMAT,
    PROB_LIST_DATA_FORMAT,
    PRIOR_ICDS_DATA_FORMAT,
    ENCOUNTER_ICDS_DATA_FORMAT
  );

var
  //NOTICE!!  If multiple instances of TfrmTMGDiagnoses created --> this will cause collision, overridden data, memory leak!
  NodeTypeSL : array[TopicsDiscussed .. EncounterICDs] of TStringList;  //TStringList's are not owned here.
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

procedure DeletelbxSectionEntry(lbSection, lbxSection : TORListBox; DelIndex : integer);
//This removed entry from data.  It doesn't remove from GUI
//kt added
var SectionIndex, SourceIdx: integer;
    SectionDataStr : TDataStr;
    SL : TStringList;

begin
  SectionIndex := lbSection.ItemIndex;
  SectionDataStr := TDataStr.Create(SECTION_DATA_FORMAT);
  try
    SectionDataStr.DataStr := lbSection.Items.Strings[SectionIndex]; //Format: SECTION_DATA_FORMAT e.g. -5^<index>^<Display title>  index is # in TStringlist NodeTypeSL[EncounterICDs]
    SectionIndex := SectionDataStr.IntValueDef('Index', 0);
    SL := TStringList(NodeTypeSL[EncounterICDs].Objects[SectionIndex]);
    SourceIdx := Integer(lbxSection.Items.Objects[DelIndex]);
    SL.Delete(SourceIdx);
    //lbxSection.Items.Delete(DelIndex : integer);
  finally
    SectionDataStr.Free;
  end;
end;


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

function TfrmTMGDiagnoses.ShouldFilter(Entry : string) : boolean;  //fmt: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys
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
    DisplayText, ICDCode, CodeStatus, ProblemIEN, CodeName, ICDCodeSys,Color: string;
    SL : TStringList;
    //Entry : string;
    //SectionStr : string;
    Index : integer;
    SrcIndex : integer;  //index in SL
    SectionDataStr : TDataStr;
    ADataStr : TDataStr;
    DestDataStr : TDataStr;

begin
  if IntEntryType >= 0 then begin
    ListDiagnosisCodes(Dest, IntEntryType);
    exit;
  end;
  SectionDataStr := TDataStr.Create(SECTION_DATA_FORMAT);
  ADataStr := TDataStr.Create(); //format will vary
  DestDataStr := TDataStr.Create(STD_ICD_DATA_FORMAT);  //STD_ICD_DATA_FORMAT = 'ICDCode^ProblemText^ICDCode2^CodeStatus^ProblemIEN^ICDCodeSys';
  try
    Dest.Clear;
    IntEntryType := -IntEntryType;
    if (IntEntryType < tNODE_FIRST) or (IntEntryType > tNODE_LAST) then exit;
    EntryType := tNodeType(IntEntryType);
    SL := NodeTypeSL[EntryType]; //DEFAULT.  NOTE: SL may be changed to different TStringList below...
    if (EntryType = EncounterICDs) and assigned(frmTMGDiagnoses) then begin
      Index := lbSection.ItemIndex;
      SectionDataStr.DataStr := lbSection.Items.Strings[Index]; //Format: SECTION_DATA_FORMAT e.g. -5^<index>^<Display title>  index is # in TStringlist NodeTypeSL[EncounterICDs]
      Index := SectionDataStr.IntValueDef('Index', 0);
      SL := TStringList(NodeTypeSL[EncounterICDs].Objects[Index]);
      if not assigned(SL) then exit;
    end;
    ADataStr.FormatStr := NODE_TYPE_DATA_FORMAT[EntryType];
    for i := 0 to SL.Count - 1 do begin
      //Entry := SL.Strings[i];
      DestDataStr.DataStr := ''; //STD_ICD_DATA_FORMAT = 'ICDCode^ProblemText^ICDCode2^CodeStatus^ProblemIEN^ICDCodeSys';
      ADataStr.DataStr := SL.Strings[i];
      ICDCode      := '';
      DisplayText  := '';
      CodeStatus   := '';
      ProblemIEN   := '';
      ICDCodeSys   := '';
      Color := '';
      case EntryType of
        TopicsDiscussed,
        TopicsUndiscussed: begin
                             //TOPIC_PROBLEM_FORMAT = 'Code^TopicName^ThreadText^ProblemIEN^ICDCode^ICDLongName^SnowmedName^ICDCodeSys^Color';
                             //ICDCode    := Piece(Entry, U, 5);
                             //CodeName   := Piece(Entry, U, 6);
                             //DisplayText:= Piece(Entry, U, 2);
                             //ProbIEN    := Piece(Entry, U, 4);         //kt ProblemIEN
                             //ICDCodeSys := Piece(Entry, U, 8);         //kt ICD Coding system  (or TMGTOPIC)
                             ICDCode      := ADataStr.ValueDef('ICDCode','???');
                             CodeName     := ADataStr.Value['ICDLongName'];
                             if Pos(ARROW_STR, CodeName)>0 then begin
                               DisplayText := CodeName;
                             end else begin
                               DisplayText := ADataStr.Value['TopicName'] + IfThen(ICDCode <> '???', ARROW_STR + CodeName + '}', '');
                             end;
                             CodeStatus   := '';
                             ProblemIEN   := '';
                             ICDCodeSys   := ADataStr.Value['ICDCodeSys'];
                             Color        := ADataStr.Value['Color'];    //Color
                           end;
        ProbList:          begin  //NOTE: This is a duplication of native functionality.  So I ended up not using this stored information.
                             //PROB_LIST_DATA_FORMAT = 'Type^ifn^status^description^ICDCode^onset^LastModified^SC^SC^SpExp^Cond^Loc^LocType^prov^service^priority^HasComment^DateRecorded^SCCond^inactive flag^ICDLongName^ICDCodeSys';
                             //ICDCode     := Piece(Entry, U, 5);        //kt ICD Code
                             //DisplayText := Piece(Entry, U, 4);        //kt Problem Text
                             //CodeStatus  := Piece(Entry, U, 19);       //kt Code Status ???   e.g. if outdated, has #, $, or both symbols at start
                             //ProbIEN     := '';                        //kt ProblemIEN
                             //ICDCodeSys  := Piece(Entry, U, 21);       //kt ICD Coding system
                             ICDCode     := ADataStr.ValueDef('ICDCode','???');
                             DisplayText := ADataStr.Value['description'];
                             CodeStatus  := ADataStr.Value['InactiveFlag'];  //e.g. if outdated, has #, $, or both symbols at start
                             ProblemIEN  := '';
                             ICDCodeSys  := ADataStr.Value['ICDCodeSys'];
                             Color        := ADataStr.Value['Color'];    //Color
                           end;

        PriorICDs:         begin
                             //PRIOR_ICDS_DATA_FORMAT     = 'Type^ICDCode^ICDLongName^FMDTLastUsed^ICDCodeSys^Color';
                             //ICDCode     := Piece(Entry, U, 2);         //kt ICD Code
                             //DisplayText := Piece(Entry, U, 3);         //kt Problem Text
                             //CodeStatus  := '';                         //kt Code Status
                             //ProbIEN     := '';                         //kt ProblemIEN
                             //ICDCodeSys  := Piece(Entry, U, 5);         //kt ICD Coding system
                             ICDCode      := ADataStr.Value['ICDCode'];
                             DisplayText  := ADataStr.Value['ICDLongName'];
                             CodeStatus   := '';
                             ProblemIEN   := '';
                             ICDCodeSys   := ADataStr.Value['ICDCodeSys'];
                             Color        := ADataStr.Value['Color'];    //Color
                           end;

        EncounterICDs:     begin
                             //ENCOUNTER_ICDS_DATA_FORMAT = 'Type^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys';
                             //ICDCode     := Piece(Entry, U, 3);   //kt ICD Code
                             //DisplayText := Piece(Entry, U, 4);   //kt Display name
                             //CodeName    := Piece(Entry, U, 5);
                             //if DisplayText= '' then begin
                             //  DisplayText := CodeName;           //kt ICD Long name
                             //end else begin
                             //  DisplayText := DisplayText + ' (' + CodeName + ')';
                             //end;
                             //CodeStatus  := ''; //Piece(Entry, U, 19);  //kt Code Status ???   e.g. if outdated, has #, $, or both symbols at start
                             //ProbIEN     := '';  //Piece(Entry, U, 4);  //kt ProblemIEN
                             //ICDCodeSys  := Piece(Entry, U, 6);         //kt ICD Coding system
                             CodeName     := ADataStr.Value['ICDLongName'];
                             DisplayText  := ADataStr.Value['DisplayName'];
                             DisplayText  := DisplayText + IfThen(Displaytext='', CodeName, '('+CodeName+')');
                             ICDCode      := ADataStr.Value['ICDCode'];
                             CodeStatus   := '';
                             ProblemIEN   := '';
                             ICDCodeSys   := ADataStr.Value['ICDCodeSys'];
                             Color        := ADataStr.Value['Color'];    //Color
                           end;
      end; //case
      if (Pos('#', CodeStatus) > 0) or (Pos('$', CodeStatus) > 0) then begin
        DisplayText := '#  ' + DisplayText;    //kt this is signal that code is inactive.  See doc in AddProbsToDiagnoses()
      end;
      DestDataStr.Value['ICDCode']     := ICDCode;
      DestDataStr.Value['ICDCode2']    := ICDCode;
      DestDataStr.Value['ProblemText'] := DisplayText;
      DestDataStr.Value['CodeStatus']  := CodeStatus;
      DestDataStr.Value['ProblemIEN']  := ProblemIEN;
      DestDataStr.Value['ICDCodeSys']  := ICDCodeSys;
      DestDataStr.Value['Color']       := Color;
      SrcIndex := i ;  //NOTE: use lbSection to determine which source list is active.
      if not ShouldFilter(ICDCode + ' ' + DisplayText) then begin
        //Dest.AddObject(ICDCode + U + DisplayText + U + ICDCode + U + CodeStatus + U + ProbIEN + U + ICDCSYS, pointer(SrcIndex)); //kt doc: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
        Dest.AddObject(DestDataStr.DataStr, pointer(SrcIndex)); //STD_ICD_DATA_FORMAT = 'ICDCode^ProblemText^ICDCode2^CodeStatus^ProblemIEN^ICDCodeSys';
      end;
    end;
  finally
    SectionDataStr.Free;
    ADataStr.Free;
    DestDataStr.Free;
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
    Saved : boolean;

begin
  if (frmNotes.ActiveEditIEN = IEN8925)  then begin
    frmNotes.SaveCurrentNote(Saved, true);  //ensure server has a saved note to process
  end;
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
          tempSL := TStringList(NodeTypeSL[j].objects[i]);
          tempSL.Free;
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
                             if IsHeader then begin           //fmt: 5^HEADER^<Section Name>^<SubIEN>"
                               TempSL := TStringList.Create;
                               LastHeaderIdx := NodeTypeSL[EntryType].AddObject(Entry, TempSL);
                               s2 := ENCOUNTER_STR + Pieces(Entry,'^',3,4);
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
//Call Stack:
// TEncounterFrame.Initialize
//  TFrmEncounterFrame.SyncPCEData
//   TfrmTMGDiagnoses.InitTab (this function)

begin
  //kt --> I DON'T want inherited.  I will achieve here instead --> inherited InitTab(ACopyProc, AListProc);
  FSrcPCEData := SrcPCEData;  //save local pointer to outside object.
  FListProc := AListProc;
  FCopyProc := ACopyProc;
  //=============
  LoadSectionItems;
  //=============
  ClearGrid;
  GridChanged;
end;

procedure TfrmTMGDiagnoses.ReloadSectionData;
var index : integer;
begin
  index := lbSection.ItemIndex;
  LoadSectionItems(index);
end;

procedure TfrmTMGDiagnoses.LoadSectionItems(AutoSelectIndex : integer = 0);
//Call Stack:
// TEncounterFrame.Initialize
//  TFrmEncounterFrame.SyncPCEData
//   TfrmTMGDiagnoses.InitTab
//    TfrmTMGDiagnoses.LoadSectionItems (this function)

var TempSL : TStringList;
    TitlesToAdd : TStringList;
    i : integer;

begin
  TempSL := TStringList.Create;
  TitlesToAdd := TStringList.Create;
  try
    LoadTMGDxInfo(FSrcPCEData.NoteIEN, TitlesToAdd);

    if assigned(FListProc) then FListProc(TempSL);  //lbSection.Items  -- this is the traditional VA method of loading list.
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
    if assigned(FCopyProc) then FCopyProc(lbGrid.Items);
    if AutoSelectIndex >= lbSection.Items.Count then AutoSelectIndex := 0;
    lbSection.ItemIndex := AutoSelectIndex;
    lbSectionClick(lbSection);
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
          (Encounter.GetICDVersionCode = '10D') and
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
  SetDirtyStatus(True);
end;

procedure TfrmTMGDiagnoses.lbxSectionMouseLeave(Sender: TObject);
begin
  inherited;
  FlbxSectionRightClickDown := false;

end;

procedure TfrmTMGDiagnoses.lbxSectionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var  HoverIndex : integer;
     MousePos: TPoint;
     DataStr : TDataStr;
     EntryType : tNodetype;
     TopicNarrative : string;
begin
  inherited;
  MousePos.X := X; MousePos.Y := Y;
  HoverIndex := lbxSection.ItemAtPos(MousePos, true);
  if HoverIndex = FlbxSectionHoverIndex then exit; //no change, same as last movement event
  FlbxSectionHoverIndex := HoverIndex;
  TopicNarrative := '';
  if HoverIndex >= 0 then begin
    DataStr := TDataStr.Create();
    try
      GetlbxSectionInfo(HoverIndex, DataStr, EntryType);
      TopicNarrative := DataStr.ValueDef('ThreadText', '');
    finally
      DataStr.Free;
    end;
  end;
  memNarrative.Text := TopicNarrative;
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
  SetUnlinkBtnStatus;

  Handled := true;  //Setting Handled=true prevents popup   DEFAULT
  IntEntryType := -lbSection.ItemIEN;
  if (IntEntryType <> ord(TopicsDiscussed)) and (IntEntryType <> ord(TopicsUndiscussed)) then exit;
  if FlbxSectionIndex = -1 then exit;
  //---- states that disallow popup should exit above -----
  Handled := false;  //allow popup
end;


procedure TfrmTMGDiagnoses.popAddAddlDxClick(Sender: TObject);
var
  //frmTopicICDLinker : TfrmTopicICDLinker;
  Index, SrcIndex, IntEntryType : integer;
  SrcLine, TopicName : string;
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

  HandleNeedsLink(TopicName, Index, 'ADDL');
  ReloadSectionData;
end;

procedure TfrmTMGDiagnoses.popOptEditLinkClick(Sender: TObject);
var
  //frmTopicICDLinker : TfrmTopicICDLinker;
  Index, SrcIndex, IntEntryType : integer;
  SrcLine, TopicName : string;
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
  RemoveIndexLink(FlbxSectionIndex,True);
  HandleNeedsLink(TopicName, Index);
  ReloadSectionData;
end;

procedure TfrmTMGDiagnoses.popOptRemoveLinkClick(Sender: TObject);
begin
  inherited;
  if lbSection.ItemIEN >= 0 then exit;
  RemoveIndexLink(FlbxSectionIndex);
  ReloadSectionData;    //TEST
end;

procedure TfrmTMGDiagnoses.RemoveIndexLink(Index : integer;NoPrompt:boolean = False);
var
  SrcIndex, IntEntryType, ModalResult : integer;
  ItemStr, SrcLine, TopicName, ICDName, ICDCode : string;
  ItemDataStr : TDataStr;
  EntryType : tNodeType;

begin
  ItemDataStr := TDataStr.Create();
  try
    TopicName := '';
    IntEntryType := -lbSection.ItemIEN;
    if (IntEntryType <> ord(TopicsDiscussed)) and (IntEntryType <> ord(TopicsUndiscussed)) then exit;
    EntryType := tNodeType(IntEntryType);
    SrcIndex := Integer(lbxSection.Items.Objects[Index]);
    if (SrcIndex < 0) or (SrcIndex >= NodeTypeSL[EntryType].Count) then exit;
    SrcLine := NodeTypeSL[EntryType].Strings[SrcIndex]; //fmt: #^<TOPIC NAME>^<THREAD TEXT >^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>
    ICDName := Piece(SrcLine, '^', 6);
    TopicName := Piece(SrcLine,'^',2);
    ICDCode := Piece(SrcLine, U, 5);
    if Pos(ARROW_STR, TopicName) > 0 then begin
      TopicName := Piece2(TopicName, ARROW_STR, 1);
      SetPiece(SrcLine,'^',2,TopicName);
    end;
    if NoPrompt=True then begin
      ModalResult := mrOK;
    end else begin
      ModalResult := MessageDlg('Remove link? ' + CRLF +
                                TopicName + CRLF +
                                'To:' + CRLF +
                                ICDName,
                                mtConfirmation, [mbOK, mbCancel], 0);
    end;
    if ModalResult <> mrOK then exit;
    SetPiece(SrcLine,'^',5,''); SetPiece(SrcLine,'^',6,''); SetPiece(SrcLine,'^',8,'');
    //NodeTypeSL[EntryType].Strings[SrcIndex] := SrcLine;
    //ItemStr := '???^'+TopicName+'^???^^'+Piece(SrcLine,'^',3)+'^10D';  //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
    //lbxSection.Items[Index] := ItemStr; //automatically changes lbxSection.Checked[Index] -> false
    ItemStr := ICDCode+'^'+TopicName+'^'+ICDCode+'^^'+Piece(SrcLine,'^',3)+'^';  //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
    ItemDataStr.FormatStr := STD_ICD_DATA_FORMAT; //'ICDCode^ProblemText^ICDCode2^CodeStatus^ProblemIEN^ICDCodeSys';
    ItemDataStr.DataStr := ItemStr;

    LinkTopicToICD(TopicName, ItemDataStr, 'KILL');  //This will delete link because ICD Code = "@"
  finally
    ItemDataStr.Free;
  end;
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

  FTabName := CT_TMG_DiagNm;   // <-- required!
  //kt FPCEListCodesProc := ListDiagnosisCodes;
  FPCEListCodesProc := ListTMGDiagnosisCodesExternal;  //this is a callback. Will be called by ancestor(s) of this class
  FPCEItemClass := TPCEDiag;
  FPCECode := 'POV';
  FSectionTabCount := 3;

  FlbxSectionRightClickDown := false;
  FlbxSectionHoverIndex := -1;

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

  EntryDataStr := TDataStr.Create(STD_ICD_DATA_FORMAT);
  LastLbxSectionIndex := -1;

  IsDirty := False;
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
  EntryDataStr.Free;
  inherited;
end;

procedure TfrmTMGDiagnoses.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  SetDirtyStatus(True);
end;

procedure TfrmTMGDiagnoses.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  SetDirtyStatus(True);
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

procedure TfrmTMGDiagnoses.btnUnlinkClick(Sender: TObject);
begin
  inherited;
  RemoveIndexLink(FlbxSectionIndex);
  ReloadSectionData;
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

function TfrmTMGDiagnoses.HandleNeedsLink(TopicName : string; Index : integer; Mode:string='SET') : boolean; //result is OK, i.e. not Cancelled
var
  EntryType : tNodeType;
  //ItemStr : string;
  SrcIndex : integer;
  ItemDataStr, SrcDataStr : TDataStr;
  frmTopicICDLinker : TfrmTopicICDLinker;
  ModalResult : integer;
  UpdatingSave : boolean;
  StaffToCode : boolean;
  IntEntryType : integer;

begin
  Result := true;
  frmTopicICDLinker := TfrmTopicICDLinker.Create(frmEncounterFrame);
  SrcDataStr := TDataStr.Create(TOPIC_PROBLEM_FORMAT);
  ItemDataStr := TDataStr.Create(STD_ICD_DATA_FORMAT);
  try
    if lbSection.ItemIEN >= 0 then exit;
    IntEntryType := -lbSection.ItemIEN;
    if (IntEntryType < tNODE_FIRST) or (IntEntryType > tNODE_LAST) then exit;
    EntryType := tNodeType(IntEntryType);
    SrcIndex := Integer(lbxSection.Items.Objects[Index]);
    if (SrcIndex < 0) or (SrcIndex >= NodeTypeSL[EntryType].Count) then exit;
    SrcDataStr.DataStr := NodeTypeSL[EntryType].Strings[SrcIndex];  //  TOPIC_PROBLEM_FORMAT = 'Code^TopicName^ThreadText^ProblemIEN^ICDCode^ICDLongName^SnowmedName^ICDCodeSys';   // 1^<TOPIC NAME>^<THREAD TEXT >^<LINKED PROBLEM IEN>^<LINKED ICD>^<LINKED ICD LONG NAME>^<LINKED SNOWMED NAME>^<ICD_SYS_NAME>

    frmTopicICDLinker.Initialize(Self, TopicName, TMGInfoPriorICDs, TMGInfoEncounterICDs);
    ModalResult := frmTopicICDLinker.ShowModal;
    if ModalResult <> mrOK then begin Result := false; exit; end;
    ItemDataStr.Assign(frmTopicICDLinker.ResultDataStr); //format: STD_ICD_DATA_FORMAT = 'ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys';
    StaffToCode := (ItemDataStr.Value['ICDCode'] = SIGNAL_ICD_FOR_STAFF_LOOKUP);
    ItemDataStr.Value['ProblemText'] := TopicName + ARROW_STR + IfThen(StaffToCode, 'Staff to code', ItemDataStr.Value['ProblemText']) + '}';
    lbxSection.Items[Index] := ItemDataStr.DataStr;  //automatically changes lbxSection.Checked[Index] -> false

    UpdatingSave := FUpdatingGrid; FUpdatingGrid := true;
    lbxSection.Checked[Index] := true;  //reset to true. NOTE: This triggers a change event -> calls into lbxSectionClickCheck() again
    FUpdatingGrid := UpdatingSave;

    SrcDataStr.Value['ICDCode']     := ItemDataStr.Value['ICDCode'];
    SrcDataStr.Value['ICDLongName'] := ItemDataStr.Value['ProblemText'];
    SrcDataStr.Value['ICDCodeSys']  := ItemDataStr.Value['ICDCodeSys'];

    NodeTypeSL[EntryType].Strings[SrcIndex] := SrcDataStr.DataStr;

    //Link TopicName -> ICD
    if not StaffToCode then begin
      LinkTopicToICD(TopicName, ItemDataStr, Mode);
    end else begin
      //put name into comment in grid somehow.
    end;
  finally
    FreeAndNil(frmTopicICDLinker);
    SrcDataStr.Free;
    ItemDataStr.Free;
    if Result <> true  then lbxSection.Checked[Index] := false;
  end;
end;



function TfrmTMGDiagnoses.HandleBadICDCode(ItemDataStr : TDataStr; Index : integer) : boolean; //result is OK, i.e. not Cancelled
var
  ICDCode  : string;
  ProblemText : string;
  CodeStatus  : string;
  ProbIEN     : string;
  ICDCSYS     : string;
  ItemStr, I10Description, SCTCode,SecItem, SCTpar : string;
  msg, plIEN, InputStr, ICDPar : string;
  OrigProbStr : string;

begin
  result := true;

  ICDCode     := ItemDataStr.Value['ICDCode'];
  ProblemText := ItemDataStr.Value['ProblemText'];
  CodeStatus  := ItemDataStr.Value['CodeStatus'];
  ProbIEN     := ItemDataStr.Value['ProblemIEN'];
  ICDCSYS     := ItemDataStr.Value['ICDCodeSys'];

  msg := IfThen(CodeStatus = '#', TX_INACTIVE_ICD_CODE, TX_NONSPEC_ICD_CODE);
  OrigProbStr := lbxSection.Items[Index];
  InputStr := IfThen(Pos('#', ProblemText) > 0, TrimLeft(Piece(ProblemText, '#', 2)), ProblemText);

  LexiconLookup(ICDCode, LX_ICD, 0, True, InputStr, msg);  //ICDCode is an out parameter

  if (Piece(ICDCode, U, 1) <> '') then begin
    plIEN := ProbIEN;

    FUpdatingGrid := TRUE;
    lbxSection.Items[Index] := Pieces(ICDCode, U, 1, 2) + U + Piece(ICDCode, U, 1) + U + plIEN;
    ItemStr := lbxSection.Items[Index]; //kt
    lbxSection.Checked[Index] := True;
    if plIEN <> '' then begin
      if not (Pos('SCT', Piece(ICDCode, U, 2)) > 0) and (Encounter.GetICDVersionCode = '10D') then begin
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
          Result := false;
          exit;
        end;
      end;
      ICDPar := Piece(ICDCode, U, 3) + U + Piece(ICDCode, U, 1) + U + Piece(ICDCode, U, 2) + U + Piece(ICDCode, U, 4);
      UpdateProblem(plIEN, ICDPar, SCTPar);
      PLUpdated := True; //agp //kt
    end;
    FUpdatingGrid := FALSE;
  end else begin
    Result := false;
    lbxSection.Checked[Index] := False;
    exit;
  end;
end;


function TfrmTMGDiagnoses.CorrectInactiveSCTCode(ItemDataStr : TDataStr; Index : integer) : boolean; //result is OK, i.e. not Cancelled
var
  msg, SCTCode, plIEN, SecItem, SCTPar : string;
  InputStr : string;
  ICDCode  : string;
  ProblemText : string;
  CodeStatus  : string;
  ProbIEN     : string;
  ICDCSYS     : string;

begin
  result := true;

  ICDCode     := ItemDataStr.Value['ICDCode'];
  ProblemText := ItemDataStr.Value['ProblemText'];
  CodeStatus  := ItemDataStr.Value['CodeStatus'];
  ProbIEN     := ItemDataStr.Value['ProblemIEN'];
  ICDCSYS     := ItemDataStr.Value['ICDCodeSys'];

  // correct inactive SCT Code
  msg := TX_INACTIVE_SCT_CODE;

  InputStr := '';

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
    result := false;
    lbxSection.Checked[Index] := False;
    exit;
  end;
end;


function TfrmTMGDiagnoses.CorrectBadOrInactiveSCTCode(ItemDataStr : TDataStr; Index : integer) : boolean; //result is OK, i.e. not Cancelled
var
  msg, SCTCode, plIEN, SCTPar, ICDPar : string;
  InputStr : string;
  ICDCode  : string;
  ProblemText : string;
  CodeStatus  : string;
  ProbIEN     : string;
  ICDCSYS     : string;

begin
  result := true;
  // correct inactive SCT Code
  msg := TX_INACTIVE_SCT_CODE;

  ICDCode     := ItemDataStr.Value['ICDCode'];
  ProblemText := ItemDataStr.Value['ProblemText'];
  CodeStatus  := ItemDataStr.Value['CodeStatus'];
  ProbIEN     := ItemDataStr.Value['ProblemIEN'];
  ICDCSYS     := ItemDataStr.Value['ICDCodeSys'];

  InputStr := '';

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
    result := false;
    lbxSection.Checked[Index] := False;
    exit;
  end;
end;

function TfrmTMGDiagnoses.CorrectMissingSCTCode(ItemDataStr : TDataStr; Index : integer) : boolean; //result is OK, i.e. not Cancelled
var msg : string;
    SCTCode, SCTPar, plIEN, SecItem, InputStr : string;
    ICDCode : string;

begin
  result := true;
  ICDCode := ItemDataStr.Value['ICDCode'];

  // Problem Lacks SCT Code
  //agp //kt prior --> msg := TX_PROB_LACKS_SCT_CODE;
  //msg := TX_PROB_LACKS_SCT_CODE + CRLF + CRLF + Piece(lbxSection.Items[Index], U, 2);  //agp //kt
  msg := TX_PROB_LACKS_SCT_CODE + CRLF + CRLF + ICDCode;  //agp //kt

  LexiconLookup(SCTCode, LX_SCT, 0, True, InputStr, msg);

  if (Piece(SCTCode, U, 3) <> '') then begin
    //plIEN := Piece(lbxSection.Items[Index], U, 5);
    plIEN := ItemDataStr.Value['ProblemIEN'];

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
    result := false;
    lbxSection.Checked[Index] := False;
  end;
end;


procedure TfrmTMGDiagnoses.GetlbxSectionInfo(Index : integer; var ADataStr : TDataStr; var OutEntryType : tNodetype);
var IntEntryType, SrcIndex : integer;
begin
  OutEntryType := ntNone;
  if not Assigned(ADataStr) then exit;
  ADataStr.Clear;
  if lbSection.ItemIEN >= 0 then exit;
  IntEntryType := -lbSection.ItemIEN;
  if (IntEntryType < tNODE_FIRST) or (IntEntryType > tNODE_LAST) then exit;
  OutEntryType := tNodeType(IntEntryType);
  SrcIndex := Integer(lbxSection.Items.Objects[Index]);
  if (SrcIndex < 0) or (SrcIndex >= NodeTypeSL[OutEntryType].Count) then exit;
  ADataStr.FormatStr := NODE_TYPE_DATA_FORMAT[outEntryType];
  ADataStr.DataStr := NodeTypeSL[OutEntryType].Strings[SrcIndex];
end;


procedure TfrmTMGDiagnoses.lbxSectionClickCheck(Sender: TObject; Index: Integer);
var
  SCTPar, InputStr: String;
  EntryType : tNodeType;
  //ItemStr : string;
  SelICDCode,ProblemText,CodeStatus,ProbIEN,ICDCSYS: string;
  TopicName,TopicNarrative : string;
  SrcDataStr : TDataStr;
  TempIndex, NumChecked : integer;
  //StaffToCode : boolean;
  ItemStr : string;

begin
  frmEncounterFrame.SelectTab(CT_TMG_DiagNm);//for some reason, at this point, the frmEncounterFrame.TabControl.TabIndex = -1.  Will select this tab again.
  SrcDataStr := TDataStr.Create(TOPIC_PROBLEM_FORMAT);
  try
    FlbxSectionIndex := -1;
    LastLbxSectionIndex := index;
    TopicNarrative := '';
    EntryDataStr.DataStr := '';
    if (not FUpdatingGrid) then begin
      if (lbxSection.Checked[Index]) then begin
        ItemStr := lbSection.Items[lbSection.ItemIndex];
        //ItemStr := lbxSection.Items[Index];  //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
        EntryDataStr.DataStr := lbxSection.Items[Index];  //STD_ICD_DATA_FORMAT

        SCTPar := '';
        InputStr := '';

        GetlbxSectionInfo(Index, SrcDataStr, EntryType);
        if EntryType = ntNone then begin
          lbxSection.Checked[Index] := false;
          exit;
        end;
        TopicNarrative := SrcDataStr.ValueDef('ThreadText', '');
        TopicName      := SrcDataStr.ValueDef('TopicName', '');

        //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodingSystem
        //SelICDCode  := Piece(ItemStr, U, 1);
        //ProblemText := Piece(ItemStr, U, 2);
        //CodeStatus  := Piece(ItemStr, U, 4);
        //ProbIEN     := Piece(ItemStr, U, 5);
        //ICDCSYS     := Piece(ItemStr, U, 6);

        SelICDCode  := EntryDataStr.Value['ICDCode'];
        ProblemText := EntryDataStr.Value['ProblemText'];
        CodeStatus  := EntryDataStr.Value['CodeStatus'];
        ProbIEN     := EntryDataStr.Value['ProblemIEN'];
        ICDCSYS     := EntryDataStr.Value['ICDCodeSys'];

        if FlbxSectionRightClickDown and (SelICDCode <> '???') then begin
          if (EntryType <> TopicsDiscussed) and (EntryType <> TopicsUndiscussed) then begin
            lbxSection.Checked[Index] := false;
            exit;
          end;
          FlbxSectionIndex := Index;
          popSectionRClick.Popup(FlbxSectionRightClickPT.X, FlbxSectionRightClickPT.Y);
          exit;
        end;

        if (SelICDCode = '???') and ((EntryType = TopicsDiscussed) or (EntryType = TopicsUndiscussed)) then begin
          if not HandleNeedsLink(TopicName, Index) then exit;
        end;

        if (CodeStatus = '#') or (Pos('799.9', SelICDCode) > 0) or (Pos('R69', SelICDCode) > 0) then begin
          if not HandleBadICDCode(EntryDataStr, Index) then exit;
        end;

        if (CodeStatus = '$') then begin
          if not CorrectInactiveSCTCode(EntryDataStr, Index) then exit;
        end;

        if (CodeStatus = '#$') then begin
          if not CorrectBadOrInactiveSCTCode(EntryDataStr, Index) then exit;
        end;

        //if (Piece(SectionStr, U, 2) = PL_ITEMS) and (Encounter.GetICDVersionCode = '10D')
        //and not (Pos('SCT', Piece(lbxSection.Items[Index], U, 2)) > 0) then begin
        if (Entrytype = ProbList) and (Encounter.GetICDVersionCode = '10D') and not (Pos('SCT', ProblemText) > 0) then begin
          if not CorrectMissingSCTCode(EntryDataStr, Index) then exit
        end;

        //if (Piece(Encounter.GetICDVersion, U, 1) = 'ICD') and
        //  ((Pos('ICD-10', Piece(lbxSection.Items[Index], U, 2)) > 0) or (Piece(lbxSection.Items[Index], U, 6)='10D')) then
        if (Encounter.GetICDVersionCode = 'ICD') and ((Pos('ICD-10', ProblemText) > 0) or (ICDCSYS='10D')) then begin
          // Attempting to add an ICD10 diagnosis code to an ICD9 encounter
          InfoBox(TX_INV_ICD10_DX, TC_INV_ICD10_DX, MB_ICONERROR or MB_OK);
          lbxSection.Checked[Index] := False;
          exit;
        end else if isEncounterDx(lbxSection.Items[Index]) then begin
          InfoBox(TX_REDUNDANT_DX, TC_REDUNDANT_DX + piece(lbxSection.Items[Index], '^',2), MB_ICONWARNING or MB_OK);
          lbxSection.Checked[Index] := False;
          exit;
        end;
      end else begin
        NumChecked := 0;
        for TempIndex := 0 to lbxSection.Items.Count - 1 do if lbxSection.Checked[TempIndex] then inc(NumChecked);
        if NumChecked = 1 then begin
          for TempIndex := 0 to lbxSection.Items.Count - 1 do if lbxSection.Checked[TempIndex] then begin
            EntryDataStr.DataStr := lbxSection.Items[Index];  //STD_ICD_DATA_FORMAT
            break;
          end;
        end;
      end;
    end;
    memNarrative.Text := TopicNarrative;
    inherited;
    EnsurePrimaryDiag;
    UpdateStatusForRightSide;
  finally
    SrcDataStr.Free;
  end;
end;

procedure TfrmTMGDiagnoses.SetUnlinkBtnStatus;
begin
  //btnUnlink.Visible := false;  //kt removing this functionality for now.  Not sure if it is still needed.  
  btnUnlink.Enabled := (FlbxSectionIndex <> -1)
end;


procedure TfrmTMGDiagnoses.lbxSectionDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);

  function HTMLToColor(const HTMLColor:string):TColor;
  var
    Red,Green,Blue: Byte;
    HexColor:string;
  begin
    if HTMLColor[1] = '#' then
      HexColor := Copy(HTMLColor, 2, Length(HTMLColor) - 1)
    else
      HexColor := HTMLColor;

    Red := StrToInt('$' + Copy(HexColor,1,2));
    Green := StrToInt('$' + Copy(HexColor,3,2));
    Blue := StrToInt('$' + Copy(HexColor,5,2));

    Result := (Blue shl 16) or (Green shl 8) or Red;
  end;

var
  Narr, Code: String;
  Format, CodeTab, ItemRight, DY: Integer;
  ARect, TmpR: TRect;
  BMap: TBitMap;
  BColor:string;
begin
  inherited;
  Narr := Piece((Control as TORListBox).Items[Index], U, 2);
  Code := Piece((Control as TORListBox).Items[Index], U, 3);
  //messagedlg((Control as TORListBox).Items[Index],mtinformation,[mbok],0);
  BColor := Piece((Control as TORListBox).Items[Index], U, 7);
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
      if BColor<>'' then begin
         Canvas.Brush.Color := HTMLToColor(BColor);
      end;
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

function TfrmTMGDiagnoses.GetCurrentSelectedSectionName : string;
var
  SectionIndex : integer;
  SectionDataStr : TDataStr;

begin
  SectionIndex := lbSection.ItemIndex;
  SectionDataStr := TDataStr.Create(SECTION_DATA_FORMAT);
  try
    SectionDataStr.DataStr := lbSection.Items.Strings[SectionIndex]; //Format: SECTION_DATA_FORMAT e.g. -5^<index>^<Display title>  index is # in TStringlist NodeTypeSL[EncounterICDs]
    Result := SectionDataStr.Value['DisplayText'];
  finally
    SectionDataStr.Free;
  end;
end;

procedure TfrmTMGDiagnoses.btnAddDxClick(Sender: TObject);
var SelectedSection, Code : string;
begin
  inherited;
  SelectedSection := GetCurrentSelectedSectionName;
  Code := GetCustomCode(Sender, SelectedSection);  //should insert code into GUI and data.
end;

procedure TfrmTMGDiagnoses.btnAddSectionClick(Sender: TObject);
begin
  inherited;
  MessageDlg('Finish Adding', mtInformation, [mbOK], 0);
end;

procedure TfrmTMGDiagnoses.btnClearSrchClick(Sender: TObject);
begin
  inherited;
  SetSearchMode(false);
end;

procedure TfrmTMGDiagnoses.btnDelDxClick(Sender: TObject);
var SectionName, ICDCode, ErrMsg, Result : string;
    success: boolean;
    DlgResult : integer;
begin
  inherited;
  ICDCode := EntryDataStr.Value['ICDCode'];
  DlgResult := MessageDlg('Delete '+ICDCode+' from MASTER encounter form?' + CRLF +
                          'NOTE: this is NOT for removing for just one patient.', mtConfirmation, [mbOK, mbCancel], 0);
  if DlgResult <> mrOK then exit;
  //Name := EntryDataStr.Value['ProblemText'] + ' ' + DxEntry.Value['ICDCode'];  //format: STD_ICD_DATA_FORMAT, i.e. ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys
  SectionName := SelectedSectionName;   //should be the name of the selected section to delete entry from.
  Result := DelTMGEntry(SectionName, ICDCode);  //RPC call
  Success := (Result = '1^SUCCESS');
  if Success then begin
    Self.ModalResult := mrOK;  //should effect closure of form.
    DeletelbxSectionEntry(lbSection, lbxSection, LastLbxSectionIndex);
    SelectedSectionName := '';
    LastLbxSectionIndex := -1;
    ReloadSectionData;  //This should trigger a reloading of listbox to update GUI.
    UpdateStatusForRightSide;
  end else begin
    ErrMsg := piece(Result, '^',2);
    MessageDlg('ERROR:' + CRLF + ErrMsg, mtError, [mbOK], 0);
  end;

end;

procedure TfrmTMGDiagnoses.btnDelSectionClick(Sender: TObject);
begin
  inherited;
  MessageDlg('Finish Deleting Section', mtInformation, [mbOK], 0);
  //NOTICE:  There will need to be some sort of MASSIVE warning here to prevent
  //         accidentally deleting an entire section.
end;

procedure TfrmTMGDiagnoses.btnEditDxClick(Sender: TObject);
begin
  inherited;
  MessageDlg('Finish Edit Dx DisplayName', mtInformation, [mbOK], 0);
end;

procedure TfrmTMGDiagnoses.btnEditSectionClick(Sender: TObject);
var
  frmGUIEditFMFile: TfrmGUIEditFMFile;
  i : integer;
  Data, IEN : string;
  GridInfo : TGridInfo; //owned elsewhere
begin
  i := lbSection.ItemIndex; if i < 0 then exit;
  Data := lbSection.Items[i];
  IEN := piece(Data,'^',4);

  frmGUIEditFMFile := TfrmGUIEditFMFile.Create(Self);
  try
    frmGUIEditFMFile.SetGridsToShow([integer(tsgAdvanced)]);
    frmGUIEditFMFile.PrepForm('22753', IEN+',', IntToStr(User.DUZ));
    GridInfo := frmGUIEditFMFile.GridInfo(tsgAdvanced);
    GridInfo.IdentifierCode := 'DO SUBRECID^TMGTIUT3(DIC,Y,+$GET(DIFILE))';
    GridInfo.CustomPtrFieldEditors.AddObject('80', Addr(HandlePtrEdit));
    frmGUIEditFMFile.ShowModal;
  finally
    frmGUIEditFMFile.Free;
  end;
  LoadSectionItems;
end;

procedure TfrmTMGDiagnoses.btnNextClick(Sender: TObject);
begin
  inherited;
  frmEncounterFrame.SelectNextTab;
end;

procedure TfrmTMGDiagnoses.btnOKClick(Sender: TObject);
begin
  inherited;
  if  BILLING_AWARE then
     GetEncounterDiagnoses;
  if ckbDiagProb.Checked then  //agp //kt
    PLUpdated := True;         //agp //kt
end;

procedure TfrmTMGDiagnoses.HandlePCELookupCBChange(PCELexForm : TfrmPCELex; checked : boolean);  //kt added
begin
  FAddToEncounterForm := checked;
end;

procedure TfrmTMGDiagnoses.LexLookupFormTweaker(PCELexForm : TfrmPCELex);  //kt added
begin
  PCELexForm.SetupforTMGEncounter(HandlePCELookupCBChange);
end;

function TfrmTMGDiagnoses.GetCustomCode(Sender: TObject; SelectedSection : string) : string;
//result example: 'I10.^Essential (Primary) Hypertension^508014^ICD-10-CM'     ICDCode^ProblemText^CodeIEN^ICDCSYS
var
  Code: string;
  SrchCode: integer;
  DxEntry : TDataStr;
  ICDCode,ProblemText,CodeIEN,ICDCSYS: string;
  RefreshNeeded : boolean;
  SelectedSectionIndex : integer;

begin
  FAddToEncounterForm := false;  //may be changed by call back handler
  if not (Sender is TButton) then exit;

  SrchCode := (Sender as TButton).Tag;
  if(SrchCode <= LX_Threshold) then begin
    if (Sender = btnAddDx) then begin
      //NOTE: I won't use LexLookupFormTweaker which gives user option for adding to encounter.
      //      Because btnAddDx has already shown the user wants to add to encounter form.
      LexiconLookup(Code, SrchCode, 0, False);  //<-- original
      if Code <> '' then FAddToEncounterForm := true;
    end else begin
      LexiconLookup(Code, SrchCode, 0, False, '', '', false, LexLookupFormTweaker);  //NOTE: Code is an OUT parameter.
    end;
  end else if(SrchCode = PCE_HF) then begin
    HFLookup(Code)
  end else begin
    OtherLookup(Code, SrchCode);
  end;

  Result := Code;
  if FAddToEncounterForm then begin
    //Code example: 'I10.^Essential (Primary) Hypertension^508014^ICD-10-CM'
    ICDCode     := Piece(Code, U, 1);
    ProblemText := Piece(Code, U, 2);
    CodeIEN     := Piece(Code, U, 3);
    ICDCSYS     := Piece(Code, U, 4);

    DxEntry := TDataStr.Create(ENCOUNTER_ICD_FORMAT); //'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys'; //5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
    try
      DxEntry.DataStr := '0^ENTRY^' + ICDCode + '^' + ProblemText + '^' + ProblemText + '^' + ICDCSYS;
      RefreshNeeded := fTMGEncounterEditor.AddEncounterDx(DxEntry, TMGInfoPriorICDs, TMGInfoEncounterICDs, SelectedSection);
      if RefreshNeeded then begin
        SelectedSectionIndex := lbSection.Items.IndexOf(SelectedSection);
        If SelectedSectionIndex < 0 then SelectedSectionIndex := 0;
        LoadSectionItems(SelectedSectionIndex);
      end;
    finally
      DxEntry.Free;
    end;
  end;
end;


procedure TfrmTMGDiagnoses.btnOtherClick(Sender: TObject);
var
  x, Code: string;
  ICD, Narrative, Status, ProbIEN, CodeSys : string;
  DxEntry : TDataStr;
  APCEItem: TPCEItem;
  //SrchCode: integer;
  //DxEntry : TDataStr;
  //ICDCode,ProblemText,CodeIEN,ICDCSYS: string;
  //RefreshNeeded : boolean;
  //SelectedSectionIndex : integer;

begin
  //inherited;   <--- I copied inherited code here so I could customize it.
  FAddToEncounterForm := false;  //may be changed by call back handler

  Code := GetCustomCode(Sender, '');  //result example: 'I10.^Essential (Primary) Hypertension^508014^ICD-10-CM'

  //kt --- copy of inherited code below ---
  {
  ClearGrid;
  SrchCode := (Sender as TButton).Tag;
  if(SrchCode <= LX_Threshold) then begin
    //kt original --> LexiconLookup(Code, SrchCode, 0, False);
    LexiconLookup(Code, SrchCode, 0, False, '', '', false, LexLookupFormTweaker);  //NOTE: Code is an OUT parameter.
  end else if(SrchCode = PCE_HF) then begin
    HFLookup(Code)
  end else begin
    OtherLookup(Code, SrchCode);
  end;
  }
  if (Sender is TWinControl) then (Sender as TWinControl).SetFocus;  //kt
  //kt btnOther.SetFocus;
  if Code <> '' then begin
    ICD := Piece(Code, U, 1);
    x := FPCECode + U + ICD + U + U + Piece(Code, U, 2);
    if FPCEItemClass = TPCEProc then begin
      SetPiece(x, U, pnumProvider, IntToStr(FProviders.PCEProvider));
    end;
    UpdateNewItemStr(x);
    APCEItem := FPCEItemClass.Create;
    APCEItem.SetFromString(x);
    if APCEItem is TPCEItem then begin
      DxEntry := TDataStr.Create(STD_ICD_DATA_FORMAT); //STD_ICD_DATA_FORMAT = 'ICDCode^ProblemText^ICDCode2^CodeStatus^ProblemIEN^ICDCodeSys';
      try
        //kt NOTE:  Below is less efficient that just concatinating parts, but I feel it is less error prone. 
        //code example: 'I10.^Essential (Primary) Hypertension^508014^ICD-10-CM'
        DxEntry.Value['ICDCode']     := ICD;
        DxEntry.Value['ProblemText'] := Piece(Code, U, 2);
        DxEntry.Value['ICDCode2']    := ICD;
        DxEntry.Value['CodeStatus']  := '';
        DxEntry.Value['ProblemIEN']  := Piece(Code, U, 3);
        DxEntry.Value['ICDCodeSys']  := Piece(Code, U, 4);
        TPCEItem(APCEItem).TMGData := DxEntry.DataStr;
      finally
        DxEntry.Free;
      end;
    end;
//    UpdateNewItem(APCEItem);
    GridIndex := lbGrid.Items.AddObject(APCEItem.ItemStr, APCEItem);
    SyncGridData;
  end;
  UpdateControls;  //button, label enabled etc.
  //kt --- end copied code --------
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

procedure TfrmTMGDiagnoses.lbSectionChange(Sender: TObject);
begin
  inherited;
  lbSection.Repaint;
end;

procedure TfrmTMGDiagnoses.lbSectionClick(Sender: TObject);
var SrchEnable : boolean;
    IntEntryType : integer;
    SectionDataStr : TDataStr;
begin
  if not FProgSectionClick then SetSearchMode(false);

  FlbxSectionIndex := -1;
  SelectedSectionName := '';
  memNarrative.Lines.Text := '';
  IntEntryType := -lbSection.ItemIEN;
  SelectedSectionType := tNodeType(IntEntryType);
  if (lbSection.ItemIndex > -1) and (SelectedSectionType = EncounterICDs) then begin
    SelectedSectionName := GetCurrentSelectedSectionName;
  end;
  UpdateStatusForLeftSide;
  inherited;//Note: --> calls @FPCEListCodesProc = ListTMGDiagnosisCodesExternal()  (setup in FormCreate)
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
  if pos('SUSPECT',item)>0 then begin
     lb.Canvas.Brush.Color := clWebRed;
  end else begin
     //lb.Canvas.Brush.Color := clWindow;
  end;
  lb.Canvas.FillRect(Rect);
  lb.Canvas.TextOut(Rect.Left+2, Rect.Top+1, item); {display the text }

  exit;
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

procedure TfrmTMGDiagnoses.LinkTopicToICD(TopicName: string;  ItemDataStr : TDataStr; Mode:string='SET');
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
    //ICDCode := Piece(ICDInfo,'^',1);
    //CodeSys := Piece(ICDInfo,'^',6);
    CDT     := FMDTToStr(FSrcPCEData.DateTime);
    //ProbIEN := Piece(ICDInfo,'^',5);

    ICDCode := ItemDataStr.Value['ICDCode'];
    ProbIEN := ItemDataStr.Value['ProblemIEN'];
    CodeSys := ItemDataStr.Value['ICDCodeSys'];

    ICDInfo2 := '0' + ';' + ICDCode + ';' + CodeSys + ';' + CDT;           //Needed format: '<ICD_IEN>;<ICD_CODE>;<ICD_CODING_SYS>;<AS-OF FMDT>'
    //Added Mode below
    SL.Add(Mode + '^' + Patient.DFN + U + TopicName + U + '0' + U + ICDInfo2);  //Needed format: 'SET^<DFN>^<TopicName>^<ProblemIEN>^<ICD_INFO*>^<SCTIEN>'  <-- can have any combo of IENS's
    TMGTopicLinks(Results, SL);
    if Results.Count > 0 then begin     //Out(#)=1^OK  or -1^ErrorMessage  <-- if line command was a SET or KILL command
      Line := Results.Text;
      if Piece(Line,'^',1) = '-1' then begin
        MessageDlg('Error linking Topic to ICD: ' + Piece(Line,'^',2), mtError, [mbOK], 0);
      end;
    end;
  finally
    SL.Free;
    Results.Free;
  end;

end;

procedure TfrmTMGDiagnoses.SendData(var SendErrors,UnpastedHTML:string);
var SL, HTMLTable : TStringList;
    TempPCE: TPCEData;
    i : integer;
    Line : string;
    PrevLine : string;
begin
  //exit;  //remove later if feature wanted...
  if not assigned(frmNotes) then exit;
  if IsDirty=false then exit;

  PrevLine := '';
  SL := TStringList.Create;
  HTMLTable := TStringList.Create;
  TempPCE := TPCEData.Create;
  try
    //Assemble Dx listing....
    TempPCE.SetDiagnoses(lbGrid.Items);
    SL.Text := TempPCE.StrDiagnoses(True);
    if SL.Count > 0 then begin
      HTMLTable.Add('<table border="0" cellspacing="2" cellpadding="0" bgcolor="#d3d3d3" DXs="1">');
      HTMLTable.Add('<tr><th colspan="2">DIAGNOSES</th></tr>');
      for i := 0 to SL.Count - 1 do begin
        Line := SL[i];
        Line := StringReplace(Line,' (Primary)','',[rfReplaceAll, rfIgnoreCase]);   //Remove the Primary tag if there
        if Line=PrevLine then continue;
        PrevLine := Line;        
        HTMLTable.Add('<tr bgcolor="#f2f2f2">');
        HTMLTable.Add('<td>'+Line+'</td>');
        HTMLTable.Add('</tr>')
      end;
      HTMLTable.Add('</table>');
      HTMLTable.Add('<p><DIV name="'+HTML_TARGET_DX+'"></DIV>');
      frmNotes.InsertDxGrid(HTMLTable,SendErrors, UnpastedHTML);
    end;
  finally
    SL.Free;
    HTMLTable.Free;
    TempPCE.Free;
  end;
end;

procedure TfrmTMGDiagnoses.UpdateStatusForLeftSide;
var
  SrchEnable : boolean;
begin
  SetUnlinkBtnStatus;
  btnAddDx.Visible := (SelectedSectionType = EncounterICDs)
                      and (SelectedSectionName <> 'All Encounter Dx''s');
  SrchEnable := (SelectedSectionType = EncounterICDs);
  //if not SrchEnable then SetSearchMode(false);
  SetSearchMode(SrchEnable);

  btnSearch.Visible := FSearchMode;
  btnEditSection.Visible := (SelectedSectionType = EncounterICDs);
end;

procedure TfrmTMGDiagnoses.UpdateStatusForRightSide;
var
  ICDCode,ProblemText: string;
  HaveICD : boolean;
  NumChecked, i : integer;
begin
  SetUnlinkBtnStatus;
  ICDCode := EntryDataStr.Value['ICDCode'];
  ProblemText := EntryDataStr.Value['ProblemText'];
  HaveICD := (ICDCode <> '');
  //lblResult.Caption  := IfThen(HaveICD, 'LINK TO: ' + ICDCode + ' -- ' + ProblemText,'');
  //btnOK2Link.Enabled := HaveICD;
  //btnOK.Enabled      := HaveICD;
  //btnEditDx.Visible  := HaveICD and (SelectedEntryType = EncounterICDs);
  NumChecked := 0;
  for i := 0 to lbxSection.Items.Count-1 do begin
    if lbxSection.Checked[i] then inc(NumChecked);
  end;

  btnDelDx.Visible := HaveICD and (SelectedSectionName <> '')
                      and (SelectedSectionType = EncounterICDs)
                      and (NumChecked = 1);
  btnEditDx.Visible := btnDelDx.Visible;

end;

procedure TfrmTMGDiagnoses.SetDirtyStatus(DirtyStatus:boolean);
begin
  IsDirty := DirtyStatus;
  frmEncounterFrame.SetCurrentTabAsDirty(DirtyStatus);
end;

procedure TfrmTMGDiagnoses.GetSelectedDxs(OutDxList : TStringList);
var APCEItem : TPCEItem;
    Obj : TObject;
    i : integer;
begin
  if not assigned(OutDxList) then exit;
  for i := 0 to lbGrid.Items.Count-1 do begin
    Obj := lbGrid.Items.Objects[i];
    if (Assigned(Obj)=false) or ((Obj is TPCEItem) = false) then continue;
    APCEItem := TPCEItem(Obj);
    OutDxList.Add(APCEItem.TMGData);  //I think format is STD_ICD_DATA_FORMAT = 'ICDCode^ProblemText^ICDCode2^CodeStatus^ProblemIEN^ICDCodeSys';
  end;
end;


initialization
  SpecifyFormIsNotADialog(TfrmTMGDiagnoses);

end.

