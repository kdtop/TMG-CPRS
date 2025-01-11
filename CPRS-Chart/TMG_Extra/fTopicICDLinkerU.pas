unit fTopicICDLinkerU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uTMGTypes, fPCELex,
  fTMGEncounterICDPicker,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ORCtrls, ORFn, StrUtils;

{-- moved to fTMGEncounterICDPicker
const
  SIGNAL_ICD_FOR_STAFF_LOOKUP = 'Y33.XXXA';   //Other sepcified events, undetermined intent, initial encounter

  STD_ICD_DATA_FORMAT    = 'ICDCode^ProblemText^ICDCode2^CodeStatus^ProblemIEN^ICDCodeSys';
  LB_SECTION_FORMAT      = 'type^SLIndex^DisplayTitle';
  ENCOUNTER_ICD_FORMAT   = 'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys'; //5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
  PRIOR_ICD_FORMAT       = 'Code^ICDCode^ICDLongName^FMDTLastUsed^ICDCodeSys';      //4^<PRIOR ICD>^<ICD LONG NAME>^<FMDT LAST USED>^<ICD_CODE_SYS>
  STD_FORMAT             = STD_ICD_DATA_FORMAT;
  SUGGESTED_CODE_FORMAT  = 'TopicName^ICDCodeSys^ICDCode^ICDLongName^ProblemIEN^SCTCode^SCTName'; //  ;"TopicName^<"ICD" OR "10D">^<ICD CODE>^<ICD NAME>^<ProbIEN>^<SCT CODE>^<SCT NAME>
  SECTION_NAMES_FORMAT   = 'Code^Type^SectionName^IEN';  //e.g.: 5^HEADER^<Section Name>^<IEN>

}

type   //note: See also similar entry in fTMGDiagnoses and fTMGEncounterICDPicker
  tDxNodeType = (Other = 0,
                 TopicsDiscussed=1,
                 TopicsUndiscussed=2,
                 ProbList=3,
                 PriorICDs=4,
                 EncounterICDs=5,
                 StaffCode=6,
                 ManualLookup = 7,
                 SuggestedICDs = 8);

  TfrmTopicICDLinker = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlMain: TPanel;
    pnlLeft: TPanel;
    splSplitter: TSplitter;
    pnlRight: TPanel;
    Label1: TLabel;
    pnlLeftTop: TPanel;
    btnSrchICD: TBitBtn;
    btnOK2Link: TBitBtn;
    btnCancel: TBitBtn;
    lblTopicTitle: TLabel;
    lblTopic: TLabel;
    lbxSection: TORListBox;
    lbSection: TORListBox;
    lblResult: TLabel;
    btnSearch: TBitBtn;
    edtSearchTerms: TEdit;
    btnClearSrch: TBitBtn;
    btnOK: TBitBtn;
    btnAddSection: TBitBtn;
    btnDelSection: TBitBtn;
    btnAddDx: TBitBtn;
    btnDelDx: TBitBtn;
    btnEditDx: TBitBtn;
    btnEditSection: TBitBtn;
    procedure btnEditSectionClick(Sender: TObject);
    procedure btnDelDxClick(Sender: TObject);
    procedure btnAddDxClick(Sender: TObject);
    procedure btnEditDxClick(Sender: TObject);
    procedure btnDelSectionClick(Sender: TObject);
    procedure btnAddSectionClick(Sender: TObject);
    procedure btnClearSrchClick(Sender: TObject);
    procedure edtSearchTermsChange(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbxSectionClickCheck(Sender: TObject; Index: Integer);
    procedure lbSectionClick(Sender: TObject);
    procedure btnSrchICDClick(Sender: TObject);
  private
    { Private declarations }
    FTopicName : string;
    FSearchMode : boolean;
    FProgSrchEditChange : boolean;
    FProgSectionClick : boolean;
    FSearchTerms : TStringList;
    ManualLookupSL : TStringList;
    TMGInfoPriorICDs : TStringList;  //not owned by this class/object
    TMGInfoEncounterICDs : TStringList; //not owned by this class/object
    FSuggestedLinks : TStringList;
    SelectedSectionType : tDxNodeType;
    LastLbxSectionIndex : integer;
    IgnorelbxSectionChanges : boolean;
    FAddToEncounterForm : boolean;
    SelectedSectionName : string;
    FRefreshNeeded : boolean;
    procedure ChangeTMGDiagnosisCodes(Index1, Index2 : integer; NewItem : TDataStr);
    procedure ListTMGDiagnosisCodes(Dest: TStrings; IntEntryType: Integer);
    procedure UpdateStatusForRightSide;
    procedure UpdateStatusForLeftSide;
    procedure SetSearchMode(Mode : boolean);
    procedure ConfigureForSearchMode(SearchMode : boolean);
    function ShouldFilter(Entry : string) : boolean;
    procedure SetupSectionItems(RefreshMode : boolean);
    function lbSectionItemType() : tDxNodeType;
    procedure GetDataRefs(lbxSectionIndex : integer; var ResultIndex1, ResultIndex2 : integer; ResultDataStr : TDataStr);
    procedure LexLookupFormTweaker(PCELexForm : TfrmPCELex);  //kt added
    procedure HandlePCELookupCBChange(PCELexForm : TfrmPCELex; checked : boolean);  //kt added
  public
    { Public declarations }
    ResultDataStr : TDataStr;  //format: STD_ICD_DATA_FORMAT
    EntryDataStr : TDataStr;   //format: STD_ICD_DATA_FORMAT        ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys
    ResultICD : string;        //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys
    procedure Initialize(Sender : TObject; ATopicName : string; ATMGInfoPriorICDs, ATMGInfoEncounterICDs : TStringList);
    property RefreshNeeded : boolean read FRefreshNeeded;
  end;

//var
//  frmTopicICDLinker: TfrmTopicICDLinker;  // NOT autocreated.

{
function HandlePtrEdit(InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string; ExtraInfoSL : TStringList;
                        Fields : string;
                        Identifier : string) : string;     forward;
}

implementation

{$R *.dfm}

uses
  rPCE, {fPCELex, } fPCEOther, UBAConst, rTIU, uCore,
  uTMGGrid, fTMGDiagnoses, fTMGEncounterEditor,
  fTMGEditEncounterInfo, fGUIEditFMFile;

var
  SenderFrmDiagnoses : TfrmTMGDiagnoses;

const
  ENCOUNTER_STR = 'Encounter Section: ';

//==========================================================

function TfrmTopicICDLinker.ShouldFilter(Entry : string) : boolean;  //fmt: 'ICDCode ProblemText'
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

procedure TfrmTopicICDLinker.GetDataRefs(lbxSectionIndex : integer; var ResultIndex1, ResultIndex2 : integer; ResultDataStr : TDataStr);
//Index1 is the index of SL in TMGInfoEncounterICDs.Objects[Index1]);
//Index2 is the index of entry in SL that matches lbxSection.Items[lbxSectionIndex]
//ResultDataStr should be an object passed in, created with format ENCOUNTER_ICD_FORMAT

var Index : integer;
    SL : TStringList;

begin
  ResultIndex1 := -1; //default
  ResultIndex2 := -1; //default
  Index := TDataStr.StaticIntValue(lbSection.Items.Strings[lbSection.ItemIndex], LB_SECTION_FORMAT, 'SLIndex');  //Get 'SLIndex' value from data string
  if (Index < 0) or  (Index >= TMGInfoEncounterICDs.Count) then exit;
  SL := TStringList(TMGInfoEncounterICDs.Objects[Index]);
  if not assigned(SL) then exit;
  ResultIndex1 := Index;
  ResultIndex2 := Integer(lbxSection.Items.Objects[LastLbxSectionIndex]);
  ResultDataStr.DataStr := SL.Strings[ResultIndex2];
end;


procedure TfrmTopicICDLinker.ChangeTMGDiagnosisCodes(Index1, Index2 : integer; NewItem : TDataStr);
//Index1 is the index of SL in TMGInfoEncounterICDs.Objects[Index1]);
//Index2 is the index of entry in SL that matches lbxSection.Items[lbxSectionIndex]
//NewItem should be an object passed in, created with format ENCOUNTER_ICD_FORMAT

var
  SL : TStringList;

begin
  if (Index1 < 0) or (Index1 >= TMGInfoEncounterICDs.Count) then exit;
  SL := TStringList(TMGInfoEncounterICDs.Objects[Index1]);
  if not assigned(SL) then exit;
  SL.Strings[Index2] := NewItem.DataStr;
  //something here to refresh, and send to server etc....
  MessageDlg('TfrmTopicICDLinker.ChangeTMGDiagnosisCodes', mtWarning, [mbOK], 0);
end;

procedure TfrmTopicICDLinker.ListTMGDiagnosisCodes(Dest: TStrings; IntEntryType: Integer);
var i : integer;
    t, c, CodeName : string;
    ADataStr : TDataStr;
    EntryType : tDxNodeType;
    SrcIndex : integer;  //index in SL
    Index : integer;
    SectionDataStr : TDataStr;
    DestDataStr : TDataStr;
    SL : TStringList;
    AddStr : string;

begin
  ResultICD := '';
  Dest.Clear;
  SectionDataStr := TDataStr.Create(LB_SECTION_FORMAT);
  ADataStr       := TDataStr.Create(ENCOUNTER_ICD_FORMAT);
  DestDataStr    := TDataStr.Create(STD_FORMAT);
  try
    if IntEntryType < 0 then EntryType := tDxNodeType(-IntEntryType) else EntryType := Other;
    if EntryType = Other then begin
      rPCE.ListDiagnosisCodes(Dest, IntEntryType);
    end else if EntryType = EncounterICDs  then begin
      ADataStr.FormatStr := ENCOUNTER_ICD_FORMAT;
      Index := lbSection.ItemIndex;
      SectionDataStr.DataStr := lbSection.Items.Strings[Index];
      Index := SectionDataStr.IntValue['SLIndex'];
      if (Index >= 0) and (Index < TMGInfoEncounterICDs.Count) then begin
        SL := TStringList(TMGInfoEncounterICDs.Objects[Index]);
        if not assigned(SL) then exit;
        for i := 0 to SL.Count - 1 do begin
          ADataStr.DataStr := SL.Strings[i];
          t := ADataStr.Value['DisplayName'];
          CodeName := ADataStr.Value['ICDLongName'];
          ADataStr.Value['DisplayName'] := IfThen(t = '', CodeName, t+' ('+CodeName+')' );
          DestDataStr.AssignViaMap(ADataStr, 'ICDCode^DisplayName^ICDCode^^^ICDCodeSys');  //compatable with STD_ICD_DATA_FORMAT
          c := DestDataStr.Value['ICDCode'];
          t := DestDataStr.Value['ProblemText'];
          AddStr := DestDataStr.DataStr;
          SrcIndex := i ;  //NOTE: use lbSection to determine which source list is active.
          if not ShouldFilter(c + ' ' + t) then begin
            Dest.AddObject(AddStr, pointer(SrcIndex));  //AddStr format is STD_FORMAT
          end;
        end;
      end;
    end else if EntryType = PriorICDs then begin
      ADataStr.FormatStr := PRIOR_ICD_FORMAT;
      for i := 0 to TMGInfoPriorICDs.Count - 1 do begin
        ADataStr.DataStr := TMGInfoPriorICDs.Strings[i];  //  PRIOR_ICD_FORMAT     = 'Code^ICDCode^ICDLongName^FMDTLastUsed^ICDCodeSys';      //4^<PRIOR ICD>^<ICD LONG NAME>^<FMDT LAST USED>^<ICD_CODE_SYS>
        DestDataStr.AssignViaMap(ADataStr, 'ICDCode^ICDLongName^ICDCode^^^ICDCodeSys');
        c := DestDataStr.Value['ICDCode'];
        t := DestDataStr.Value['ProblemText'];
        AddStr := DestDataStr.DataStr;
        SrcIndex := i ;  //NOTE: use lbSection to determine which source list is active.
        if not ShouldFilter(c + ' ' + t) then begin
          Dest.AddObject(AddStr, pointer(SrcIndex));   //AddStr format is STD_FORMAT
        end;
      end;
    end else if EntryType = StaffCode then begin
      DestDataStr.Value['ICDCode']     := SIGNAL_ICD_FOR_STAFF_LOOKUP;
      DestDataStr.Value['ProblemText'] := FTopicName;
      DestDataStr.Value['ICDCode2']    := SIGNAL_ICD_FOR_STAFF_LOOKUP;
      DestDataStr.Value['CodeStatus']  := '';
      DestDataStr.Value['ProblemIEN']  := '';
      DestDataStr.Value['ICDCodeSys']  := '10D'; //'ICD-10-CM';
      Dest.Add(DestDataStr.DataStr);
      ResultICD := DestDataStr.DataStr;
      ResultDataStr.Assign(DestDataStr);
    end else if EntryType = ManualLookup then begin
      ADataStr.FormatStr := STD_FORMAT;
      for i := 0 to ManualLookupSL.Count - 1 do begin
        ADataStr.DataStr := ManualLookupSL.Strings[i];
        DestDataStr.AssignViaMap(ADataStr, 'ICDCode^ProblemText^ICDCode^^^ICDCodeSys');
        SrcIndex := i ;  //NOTE: use lbSection to determine which source list is active.
        Dest.AddObject(DestDataStr.DataStr, pointer(SrcIndex));
      end;
    end else if EntryType = SuggestedICDs then begin
      ADataStr.FormatStr := SUGGESTED_CODE_FORMAT;
      for i := 0 to FSuggestedLinks.Count - 1 do begin
        ADataStr.DataStr := FSuggestedLinks.Strings[i];  //'TopicName^ICDCodeSys^ICDCode^ICDLongName^ProblemIEN^SCTCode^SCTName'
        DestDataStr.AssignViaMap(ADataStr, 'ICDCode^ICDLongName^ICDCode^^ProblemIEN^ICDCodeSys');
        Dest.Add(DestDataStr.DataStr);
        ResultICD := DestDataStr.DataStr;
        ResultDataStr.Assign(DestDataStr);
      end;
    end;
    UpdateStatusForRightSide;
  finally
    SectionDataStr.Free;
    ADataStr.Free;
    DestDataStr.Free;
  end;
  Application.ProcessMessages;      //Force a repaint  9/19/23
  Self.Invalidate;                  //Force a repaint
end;

procedure TfrmTopicICDLinker.btnAddDxClick(Sender: TObject);
begin
  MessageDlg('To Do: ADD DIAGNOSIS', mtInformation, [mbOK], 0);
end;

procedure TfrmTopicICDLinker.btnAddSectionClick(Sender: TObject);
begin
  MessageDlg('To Do: ADD DIAGNOSIS SECTION', mtInformation, [mbOK], 0);
end;

procedure TfrmTopicICDLinker.btnClearSrchClick(Sender: TObject);
begin
  SetSearchMode(false);
end;

procedure TfrmTopicICDLinker.btnDelDxClick(Sender: TObject);
var SectionName, ICDCode, ErrMsg, Result : string;
    success: boolean;
begin
  inherited;
  //Name := EntryDataStr.Value['ProblemText'] + ' ' + DxEntry.Value['ICDCode'];  //format: STD_ICD_DATA_FORMAT, i.e. ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys
  SectionName := SelectedSectionName;   //should be the name of the selected section to delete entry from.
  ICDCode := EntryDataStr.Value['ICDCode'];
  Result := DelTMGEntry(SectionName, ICDCode);  //RPC call
  Success := (Result = '1^SUCCESS');
  if Success then begin
    FRefreshNeeded := true;
    Self.ModalResult := mrOK;  //should effect closure of form.
    lbxSection.Items.Delete(LastLbxSectionIndex);

    //remove from --> TMGInfoEncounterICDs := ATMGInfoEncounterICDs;   //local copy of pointer to object owned elsewhere.

    SelectedSectionName := '';
    LastLbxSectionIndex := -1;
  end else begin
    ErrMsg := piece(Result, '^',2);
    MessageDlg('ERROR:' + CRLF + ErrMsg, mtError, [mbOK], 0);
  end;

end;

procedure TfrmTopicICDLinker.btnDelSectionClick(Sender: TObject);
begin
  MessageDlg('To Do: DELETE DIAGNOSIS SECTION', mtInformation, [mbOK], 0);

end;

procedure TfrmTopicICDLinker.btnEditDxClick(Sender: TObject);
var
  frmTMGEditEncounterInfo: TfrmTMGEditEncounterInfo;
  Index1, Index2 : integer;
  //DataStr : string;
  EditDataStr : TDataStr;

begin
  EditDataStr   := TDataStr.Create(ENCOUNTER_ICD_FORMAT);
  GetDataRefs(LastLbxSectionIndex, Index1, Index2, EditDataStr);
  frmTMGEditEncounterInfo := TfrmTMGEditEncounterInfo.Create(self);
  try
    frmTMGEditEncounterInfo.Initialize(EditDataStr);
    if frmTMGEditEncounterInfo.ShowModal = mrOK then begin
      if frmTMGEditEncounterInfo.Modified then begin
        ChangeTMGDiagnosisCodes(Index1, Index2, frmTMGEditEncounterInfo.ResultDataStr);
        if LastLbxSectionIndex > -1 then begin
          lbSectionClick(Sender);
          IgnorelbxSectionChanges := true;
          lbxSection.Checked[LastLbxSectionIndex] := true;  //NOTE: triggers another lbxSectionClickCheck() event.
          IgnorelbxSectionChanges := false;
        end;
      end;
    end;
  finally
    frmTMGEditEncounterInfo.Free;
    EditDataStr.Free;
  end;

end;

{ -- moved to fTMGEncounterICDPicker
//NOTE: function below is not part of class
function HandlePtrEdit(InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string; ExtraInfoSL : TStringList;
                        Fields : string;
                        Identifier : string) : string;
var
  TargetFileNum, tempS : string;
  Code: string;
  //Entry : string;
  //i,j : integer;
  //FoundIndex : integer;
  //ICDCode,ProblemText,CodeIEN,ICDCSYS: string;

begin
  Result := InitValue;
  TargetFileNum := piece2(ExtraInfo, EXTRA_INFO_PIECE_DIV, 1);
  tempS := piece2(ExtraInfo, EXTRA_INFO_PIECE_DIV, 2);  //boolean
  GridInfo.DisplayRefreshIndicated := false;  //default
  Changed := false;  //default

  // procedure LexiconLookup(var Code: string;
  //                          ALexApp: Integer;
  //                          ADate: TFMDateTime = 0;
  //                          AExtend: Boolean = False;
  //                          AInputString: String = '';
  //                          AMessage: String = '';
  //                          ADefaultToInput: Boolean = False);

  LexiconLookup(Code, LX_ICD, 0, True, InitValue, 'Pick Dx', true);  //NOTE: Code is an OUT parameter.
  if Code <> '' then begin
    //Code example: 'I10.^Essential (Primary) Hypertension^508014^ICD-10-CM'
    //ICDCode     := Piece(Code, U, 1);
    //ProblemText := Piece(Code, U, 2);
    //CodeIEN     := Piece(Code, U, 3);
    //ICDCSYS     := Piece(Code, U, 4);
    Result := Piece(Code, U, 1);  //ICD code
    CanSelect := true;
    Changed := (Result <> InitValue);
    GridInfo.DisplayRefreshIndicated := Changed;
  end;
end;
}


procedure TfrmTopicICDLinker.btnEditSectionClick(Sender: TObject);
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
  if Assigned(SenderFrmDiagnoses) then begin
    SenderFrmDiagnoses.LoadSectionItems; //This will refresh data source there, and we have pointers to that same data.
    SetupSectionItems(True);
  end;

end;

procedure TfrmTopicICDLinker.btnSearchClick(Sender: TObject);
begin
  SetSearchMode(not FSearchMode);
  if FSearchMode then edtSearchTerms.SetFocus;
end;

procedure TfrmTopicICDLinker.SetSearchMode(Mode : boolean);
begin
  if FSearchMode = Mode then exit; //no change needed
  FSearchMode := Mode;
  FProgSrchEditChange := true;
  edtSearchTerms.Text := '';
  FProgSrchEditChange := false;
  ConfigureForSearchMode(FSearchMode);
  if FSearchMode = false then edtSearchTermsChange(self);  //this will trigger redisplay WITHOUT filter
end;


procedure TfrmTopicICDLinker.ConfigureForSearchMode(SearchMode : boolean);
const
  BOTTOM_BUTTON_AREA_HT = 45;
begin
  edtSearchTerms.Visible := SearchMode;
  btnClearSrch.Visible := SearchMode;
  if SearchMode then begin
    lbxSection.Top := 28;
  end else begin
    lbxSection.Top := 1;
  end;
  lbxSection.Height := pnlRight.Height - lbSection.Top - BOTTOM_BUTTON_AREA_HT;
end;

procedure TfrmTopicICDLinker.HandlePCELookupCBChange(PCELexForm : TfrmPCELex; checked : boolean);  //kt added
begin
  FAddToEncounterForm := checked;
end;

procedure TfrmTopicICDLinker.LexLookupFormTweaker(PCELexForm : TfrmPCELex);  //kt added
begin
  PCELexForm.SetupforTMGEncounter(HandlePCELookupCBChange);
end;

procedure TfrmTopicICDLinker.btnSrchICDClick(Sender: TObject);
var
  Code: string;
  Entry : string;
  i,j : integer;
  FoundIndex : integer;
  ICDCode,ProblemText,CodeIEN,ICDCSYS: string;
  DxEntry : TDataStr;
  SelectedSection : string;
  RefreshNeeded : boolean;

begin
  FAddToEncounterForm := false;  //may be changed by call back handler
  LexiconLookup(Code, LX_ICD, 0, False, '', '', false, LexLookupFormTweaker);  //NOTE: Code is an OUT parameter.
  if Code = '' then exit;
  //Code example: 'I10.^Essential (Primary) Hypertension^508014^ICD-10-CM'
  ICDCode     := Piece(Code, U, 1);
  ProblemText := Piece(Code, U, 2);
  CodeIEN     := Piece(Code, U, 3);
  ICDCSYS     := Piece(Code, U, 4);

  Entry := ICDCode + U + ProblemText + U + ICDCode + U + U + ICDCSYS;  //Output format: ICDCode^ProblemText^ICDCode^^^ICDCodeSys  <-- STD_FORMAT
  //Ensure section added.
  j := ManualLookupSL.Add(Entry);
  FoundIndex := -1;
  for i := 0 to lbSection.Items.Count - 1 do begin
    if Piece(lbSection.Items.Strings[i],U,1) <> IntToStr(ord(ManualLookup)) then continue;
    FoundIndex := i;
    break;
  end;
  if FoundIndex < 0 then begin
    FoundIndex := lbSection.Items.Add(IntToStr(-ord(ManualLookup))+'^Manual Lookup^Manual Lookup');
  end;
  lbSection.ItemIndex := FoundIndex;
  lbSectionClick(self);
  //autocheck last entry now in lbxSection
  i := lbxSection.Items.Count-1;
  if i>=0 then begin
    lbxSection.Checked[i] := true; //should change trigger event
  end;

  if FAddToEncounterForm then begin
    DxEntry := TDataStr.Create(ENCOUNTER_ICD_FORMAT); //'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys'; //5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
    try
      DxEntry.DataStr := '0^ENTRY^' + ICDCode + '^' + ProblemText + '^' + ProblemText + '^' + ICDCSYS;
      RefreshNeeded := fTMGEncounterEditor.AddEncounterDx(DxEntry, TMGInfoPriorICDs, TMGInfoEncounterICDs, SelectedSection);
      if RefreshNeeded then begin
        //finish...
      end;
    finally
      DxEntry.Free;
    end;

  end;

end;

function TfrmTopicICDLinker.lbSectionItemType() : tDxNodeType;
var  IntEntryType : integer;
begin
  IntEntryType := lbSection.ItemIEN;
  if IntEntryType < 0 then Result := tDxNodeType(-IntEntryType) else Result := Other;
end;

procedure TfrmTopicICDLinker.edtSearchTermsChange(Sender: TObject);
begin
  if FProgSrchEditChange then exit;
  FProgSectionClick := true;
  PiecesToList(UpperCase(edtSearchTerms.Text), ' ', FSearchTerms);
  ListTMGDiagnosisCodes(lbxSection.Items, lbSection.ItemIEN);
  FProgSectionClick := false;
end;

procedure TfrmTopicICDLinker.FormCreate(Sender: TObject);
begin
  Inherited;
  IgnorelbxSectionChanges := false;
  ResultDataStr := TDataStr.Create(STD_ICD_DATA_FORMAT);
  EntryDataStr := TDataStr.Create(STD_ICD_DATA_FORMAT);
  LastLbxSectionIndex := -1;
  ManualLookupSL := TStringList.Create;
  FSearchTerms := TStringList.Create;
  FSuggestedLinks := TStringList.Create;
  FSearchMode := true; //this will ensure next step is carried out
  SetSearchMode(false);
  FProgSrchEditChange := false;
  FProgSectionClick := false;
  FRefreshNeeded := false;
end;

procedure TfrmTopicICDLinker.FormDestroy(Sender: TObject);
begin
  ManualLookupSL.Free;
  FSearchTerms.Free;
  ResultDataStr.Free;
  EntryDataStr.Free;
  FSuggestedLinks.Free;
  Inherited;
end;

procedure TfrmTopicICDLinker.Initialize(Sender : TObject; ATopicName : string; ATMGInfoPriorICDs, ATMGInfoEncounterICDs : TStringList);

  function CompareStrings(List:TStringList; Index1,Index2:integer):integer;
  var
     piece1,piece2:string;
  begin
      piece1 := piece(List[index1],'^',3);
      piece2 := piece(List[index2],'^',3);

      Result := CompareStr(piece1,piece2);
  end;

  procedure SortStringList(StringList : TStringList);
  begin
     StringList.CustomSort(@CompareStrings);
  end;

begin
  if Sender is TfrmTMGDiagnoses then begin
    SenderFrmDiagnoses := TfrmTMGDiagnoses(Sender);
  end else begin
    SenderFrmDiagnoses := nil;
  end;
  TMGInfoPriorICDs := ATMGInfoPriorICDs;           //local copy of pointer to object owned elsewhere.
  TMGInfoEncounterICDs := ATMGInfoEncounterICDs;   //local copy of pointer to object owned elsewhere.
  SortStringList(TMGInfoEncounterICDs);
  FTopicName := ATopicName;
  lblTopic.Caption := ATopicName;
  SetupSectionItems(false);
end;

procedure TfrmTopicICDLinker.SetupSectionItems(RefreshMode : boolean);
var TempSL, SL : TStringList;
    TempS : string;
    i : integer;
    Entry : TDataStr;
begin
  TempSL := TStringList.Create;
  Entry := TDataStr.Create(SECTION_NAMES_FORMAT);  //'Code^Type^SectionName^IEN'   e.g.: 5^HEADER^<Section Name>^<IEN>
  try
    ListDiagnosisSections(TempSL);  //in rPCE
    //Delete all entries except for '0^Problem List'
    //The other entries are blocks from an encounter form that can be created on the server.
    //  But it is difficult to work with, and I have replaced it with a different system
    //  that is loaded in via LoadTMGDxInfo
    for i := TempSL.Count - 1 downto 0 do begin
      if Piece(TempSL[i],'^',1) <> '0' then TempSL.Delete(i);
    end;
    if not RefreshMode then GetSuggestedCodesForTopic(FSuggestedLinks, FTopicName, True);  //true = Filtered
    if FSuggestedLinks.Count > 0 then begin
      TempSL.Insert(0,IntToStr(-ord(SuggestedICDs))+'^Previously used links^Previously used links');
    end;
    TempSL.Insert(0,IntToStr(-ord(PriorICDs))+'^Prior ICD''s^Prior ICD''s');
    TempSL.Add(IntToStr(-ord(StaffCode))+'^Staff To Code^Staff To Code');
    //Add encounter form ICD's
    for i := 0 to TMGInfoEncounterICDs.Count - 1 do begin
      Entry.DataStr := TMGInfoEncounterICDs.Strings[i];  //'Code^Type^SectionName^IEN'   e.g.: 5^HEADER^<Section Name>^<IEN>
      SL := TStringList(TMGInfoEncounterICDs.Objects[i]);
      TempS := IntToStr(-ord(EncounterICDs)) + '^' + IntToStr(i) + '^' + ENCOUNTER_STR +  Entry.Value['SectionName'] + '^' + Entry.Value['IEN'];
      TempSL.AddObject(TempS, SL );
    end;
    lbSection.Items.Assign(TempSL);
    lbSection.ItemIndex := 0;
    lbSectionClick(lbSection);
  finally
    TempSL.Free;
    Entry.Free;
  end;
end;

procedure TfrmTopicICDLinker.lbSectionClick(Sender: TObject);
var IntEntryType : integer;
    SrchEnable : boolean;
begin
  inherited;
  if not FProgSectionClick then SetSearchMode(false);
  IntEntryType := -lbSection.ItemIEN;
  SelectedSectionType := tDxNodeType(IntEntryType);
  if lbSection.ItemIndex > -1 then begin
    SelectedSectionName := lbSection.Items[lbSection.ItemIndex];
    SelectedSectionName := piece(SelectedSectionName, '^', 3);
    SelectedSectionName := piece2(SelectedSectionName, 'Encounter Section: ', 2);
  end else begin
    SelectedSectionName := '';
  end;
  SrchEnable := (SelectedSectionType=EncounterICDs) or (SelectedSectionType=PriorICDs);
  if not SrchEnable then SetSearchMode(false);
  ListTMGDiagnosisCodes(lbxSection.Items, lbSection.ItemIEN);  //this populates right side.
  if lbxSection.Items.Count=1 then lbxSection.Checked[0] := true;  //auto check if only 1 entry
  UpdateStatusForLeftSide();
end;

procedure TfrmTopicICDLinker.lbxSectionClickCheck(Sender: TObject; Index: Integer);
var
  IntEntryType: Integer;
  ItemStr : string;
  TopicNarrative : string;
  SrcIndex : integer;
  SrcLine : string;
  i : integer;

begin
  if IgnorelbxSectionChanges then exit;
  TopicNarrative := '';
  ResultICD := '';
  ResultDataStr.DataStr := '';
  EntryDataStr.DataStr := '';
  LastLbxSectionIndex := index;
  if lbxSection.Checked[Index] then begin
    for i := 0 to lbxSection.Items.Count-1 do begin
      if i = Index then continue;
      IgnorelbxSectionChanges := true;
      lbxSection.Checked[i] := false;  //uncheck every other.  NOTE: triggers another lbxSectionClickCheck() event.
      IgnorelbxSectionChanges := false;
    end;
    ItemStr := lbxSection.Items[Index];  //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodSys
    if lbSection.ItemIEN < 0 then begin  //kt
      IntEntryType := -lbSection.ItemIEN;
      if IntEntryType = ord(PriorICDs) then begin
        SrcIndex := Integer(lbxSection.Items.Objects[Index]);
        SrcLine := IfThen(SrcIndex < TMGInfoPriorICDs.Count, TMGInfoPriorICDs.Strings[SrcIndex], '');
        TopicNarrative := Piece(SrcLine,'^',3);
      end else if IntEntryType = ord(ManualLookup) then begin
        //
      end;
    end;

    ResultICD := ItemStr;
    ResultDataStr.DataStr := ItemStr;
    EntryDataStr.DataStr := ItemStr;
  end;
  UpdateStatusForRightSide;
end;

procedure TfrmTopicICDLinker.UpdateStatusForLeftSide;
var
  SrchEnable, ShowLinkBtn : boolean;

begin
  SrchEnable := (SelectedSectionType=EncounterICDs) or (SelectedSectionType=PriorICDs);
  btnSearch.Visible := SrchEnable;
  ShowLinkBtn := (SelectedSectionType <> StaffCode);
  btnOK2Link.Visible := ShowLinkBtn;
  btnOK.Visible := not ShowLinkBtn;
  btnEditSection.Visible := (SelectedSectionType = EncounterICDs);
end;


procedure TfrmTopicICDLinker.UpdateStatusForRightSide;
var
  ICDCode,ProblemText: string;
  HaveICD : boolean;

begin
  ICDCode := ResultDataStr.Value['ICDCode'];
  ProblemText := ResultDataStr.Value['ProblemText'];
  HaveICD := (ICDCode <> '');
  lblResult.Caption  := IfThen(HaveICD, 'LINK TO: ' + ICDCode + ' -- ' + ProblemText,'');
  btnOK2Link.Enabled := HaveICD;
  btnOK.Enabled      := HaveICD;
  btnEditDx.Visible  := HaveICD and (SelectedSectionType = EncounterICDs);
  btnDelDx.Visible   := HaveICD and (SelectedSectionType = EncounterICDs);
  btnAddDx.Visible   := (SelectedSectionType = EncounterICDs)
end;

initialization
  SenderFrmDiagnoses := nil;

end.
