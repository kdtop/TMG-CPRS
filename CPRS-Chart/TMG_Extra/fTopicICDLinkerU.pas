unit fTopicICDLinkerU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ORCtrls, ORFn, StrUtils;

const
  //SIGNAL_ICD_FOR_STAFF_LOOKUP = 'W56.22xA';   //ICD Code for "Struck by Orca"  This code will later be interpreted to mean staff should find real code...
  SIGNAL_ICD_FOR_STAFF_LOOKUP = 'Y33.XXXA';   //Other sepcified events, undetermined intent, initial encounter

  STD_ICD_DATA_FORMAT = 'ICDCode^ProblemText^ICDCode2^CodeStatus^ProblemIEN^ICDCodeSys';

type
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
    procedure ListTMGDiagnosisCodes(Dest: TStrings; IntEntryType: Integer);
    procedure UpdateStatus;
    procedure SetSearchMode(Mode : boolean);
    procedure ConfigureForSearchMode(SearchMode : boolean);
    function ShouldFilter(Entry : string) : boolean;
  public
    { Public declarations }
    ResultDataStr : TDataStr;  //format: STD_ICD_DATA_FORMAT
    ResultICD : string;  //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys
    procedure Initialize(ATopicName : string; ATMGInfoPriorICDs, ATMGInfoEncounterICDs : TStringList);
  end;

//var
//  frmTopicICDLinker: TfrmTopicICDLinker;  // NOT autocreated.

implementation

{$R *.dfm}

uses rPCE, fPCELex, fPCEOther, UBAConst, rTIU;

const
  ENCOUNTER_STR = 'Encounter Section: ';

  LB_SECTION_FORMAT      = 'type^SLIndex^DisplayTitle';
  ENCOUNTER_ICD_FORMAT   = 'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys'; //5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
  PRIOR_ICD_FORMAT       = 'Code^ICDCode^ICDLongName^FMDTLastUsed^ICDCodeSys';      //4^<PRIOR ICD>^<ICD LONG NAME>^<FMDT LAST USED>^<ICD_CODE_SYS>
  STD_FORMAT             = STD_ICD_DATA_FORMAT;
  SUGGESTED_CODE_FORMAT  = 'TopicName^ICDCodeSys^ICDCode^ICDLongName^ProblemIEN^SCTCode^SCTName'; //  ;"TopicName^<"ICD" OR "10D">^<ICD CODE>^<ICD NAME>^<ProbIEN>^<SCT CODE>^<SCT NAME>


type   //note: See also similar entry in fTMGDiagnoses
  tNodeType = (TopicsDiscussed=1,
               TopicsUndiscussed=2,
               ProbList=3,
               PriorICDs=4,
               EncounterICDs=5,
               StaffCode=6,
               ManualLookup = 7,
               SuggestedICDs = 8);

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

procedure TfrmTopicICDLinker.ListTMGDiagnosisCodes(Dest: TStrings; IntEntryType: Integer);
var i : integer;
    t, c, CodeName : string;
    //f, p, ICDCSYS: string;
    //Temp : string;
    EntryDataStr : TDataStr;
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
  EntryDataStr   := TDataStr.Create();
  DestDataStr    := TDataStr.Create(STD_FORMAT);
  try
    if IntEntryType >= 0 then begin
      ListDiagnosisCodes(Dest, IntEntryType);
    end else if -IntEntryType = ord(EncounterICDs)  then begin
      EntryDataStr.FormatStr := ENCOUNTER_ICD_FORMAT;
      Index := lbSection.ItemIndex;
      SectionDataStr.DataStr := lbSection.Items.Strings[Index];
      Index := SectionDataStr.IntValue['SLIndex'];
      if (Index >= 0) and (Index < TMGInfoEncounterICDs.Count) then begin
        SL := TStringList(TMGInfoEncounterICDs.Objects[Index]);
        if not assigned(SL) then exit;
        for i := 0 to SL.Count - 1 do begin
          EntryDataStr.DataStr := SL.Strings[i];
          t := EntryDataStr.Value['DisplayName'];
          CodeName := EntryDataStr.Value['ICDLongName'];
          EntryDataStr.Value['DisplayName'] := IfThen(t = '', CodeName, t+' ('+CodeName+')' );
          DestDataStr.AssignViaMap(EntryDataStr, 'ICDCode^DisplayName^ICDCode^^^ICDCodeSys');
          c := DestDataStr.Value['ICDCode'];
          t := DestDataStr.Value['ProblemText'];
          AddStr := DestDataStr.DataStr;
          SrcIndex := i ;  //NOTE: use lbSection to determine which source list is active.
          if not ShouldFilter(c + ' ' + t) then begin
            Dest.AddObject(AddStr, pointer(SrcIndex));  //AddStr format is STD_FORMAT
          end;
        end;
      end;
    end else if -IntEntryType = ord(PriorICDs)  then begin
      EntryDataStr.FormatStr := PRIOR_ICD_FORMAT;
      for i := 0 to TMGInfoPriorICDs.Count - 1 do begin
        EntryDataStr.DataStr := TMGInfoPriorICDs.Strings[i];  //  PRIOR_ICD_FORMAT     = 'Code^ICDCode^ICDLongName^FMDTLastUsed^ICDCodeSys';      //4^<PRIOR ICD>^<ICD LONG NAME>^<FMDT LAST USED>^<ICD_CODE_SYS>
        DestDataStr.AssignViaMap(EntryDataStr, 'ICDCode^ICDLongName^ICDCode^^^ICDCodeSys');
        c := DestDataStr.Value['ICDCode'];
        t := DestDataStr.Value['ProblemText'];
        AddStr := DestDataStr.DataStr;
        SrcIndex := i ;  //NOTE: use lbSection to determine which source list is active.
        if not ShouldFilter(c + ' ' + t) then begin
          Dest.AddObject(AddStr, pointer(SrcIndex));   //AddStr format is STD_FORMAT
        end;
      end;
    end else if -IntEntryType = ord(StaffCode)  then begin
      DestDataStr.Value['ICDCode']     := SIGNAL_ICD_FOR_STAFF_LOOKUP;
      DestDataStr.Value['ProblemText'] := FTopicName;
      DestDataStr.Value['ICDCode2']    := SIGNAL_ICD_FOR_STAFF_LOOKUP;
      DestDataStr.Value['CodeStatus']  := '';
      DestDataStr.Value['ProblemIEN']  := '';
      DestDataStr.Value['ICDCodeSys']  := '10D'; //'ICD-10-CM';
      Dest.Add(DestDataStr.DataStr);
      ResultICD := DestDataStr.DataStr;
      ResultDataStr.Assign(DestDataStr);
    end else if -IntEntryType = ord(ManualLookup)  then begin
      EntryDataStr.FormatStr := STD_FORMAT;
      for i := 0 to ManualLookupSL.Count - 1 do begin
        EntryDataStr.DataStr := ManualLookupSL.Strings[i];
        DestDataStr.AssignViaMap(EntryDataStr, 'ICDCode^ProblemText^ICDCode^^^ICDCodeSys');
        SrcIndex := i ;  //NOTE: use lbSection to determine which source list is active.
        Dest.AddObject(DestDataStr.DataStr, pointer(SrcIndex));
      end;
    end else if -IntEntryType = ord(SuggestedICDs)  then begin
      EntryDataStr.FormatStr := SUGGESTED_CODE_FORMAT;
      for i := 0 to FSuggestedLinks.Count - 1 do begin
        EntryDataStr.DataStr := FSuggestedLinks.Strings[i];  //'TopicName^ICDCodeSys^ICDCode^ICDLongName^ProblemIEN^SCTCode^SCTName'
        DestDataStr.AssignViaMap(EntryDataStr, 'ICDCode^ICDLongName^ICDCode^^ProblemIEN^ICDCodeSys');
        Dest.Add(DestDataStr.DataStr);
        ResultICD := DestDataStr.DataStr;
        ResultDataStr.Assign(DestDataStr);
      end;
    end;
    UpdateStatus;
  finally
    SectionDataStr.Free;
    EntryDataStr.Free;
    DestDataStr.Free;
  end;
end;

procedure TfrmTopicICDLinker.btnClearSrchClick(Sender: TObject);
begin
  SetSearchMode(false);
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
begin
  edtSearchTerms.Visible := SearchMode;
  btnClearSrch.Visible := SearchMode;
  if SearchMode then begin
    lbxSection.Top := 28;
    lbxSection.Height := pnlRight.Height - lbSection.Top - 2;
  end else begin
    lbxSection.Top := 1;
    lbxSection.Height := pnlRight.Height - 1
  end;
end;

procedure TfrmTopicICDLinker.btnSrchICDClick(Sender: TObject);
var
  Code: string;
  Entry : string;
  i,j : integer;
  FoundIndex : integer;
  ICDCode,ProblemText,CodeIEN,ICDCSYS: string;

begin
  LexiconLookup(Code, 12, 0, False, '');  //NOTE: Code is an OUT parameter.  12 is from copying other VA code...
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
  ManualLookupSL := TStringList.Create;
  FSearchTerms := TStringList.Create;
  FSuggestedLinks := TStringList.Create;
  FSearchMode := true; //this will ensure next step is carried out
  SetSearchMode(false);
  FProgSrchEditChange := false;
  FProgSectionClick := false;
  ResultDataStr := TDataStr.Create(STD_ICD_DATA_FORMAT);
end;

procedure TfrmTopicICDLinker.FormDestroy(Sender: TObject);
begin
  ManualLookupSL.Free;
  FSearchTerms.Free;
  ResultDataStr.Free;
  FSuggestedLinks.Free;
  Inherited;
end;

procedure TfrmTopicICDLinker.Initialize(ATopicName : string; ATMGInfoPriorICDs, ATMGInfoEncounterICDs : TStringList);
var TempSL, SL : TStringList;
    TempS : string;
    i : integer;
begin
  TMGInfoPriorICDs := ATMGInfoPriorICDs;           //local copy of pointer to object owned elsewhere.
  TMGInfoEncounterICDs := ATMGInfoEncounterICDs;   //local copy of pointer to object owned elsewhere.
  FTopicName := ATopicName;
  lblTopic.Caption := ATopicName;
  TempSL := TStringList.Create;
  try
    ListDiagnosisSections(TempSL);  //in rPCE
    //Delete all entries except for '0^Problem List'
    //The other entries are blocks from an encounter form that can be created on the server.
    //  But it is difficult to work with, and I have replaced it with a different system
    //  that is loaded in via LoadTMGDxInfo
    for i := TempSL.Count - 1 downto 0 do begin
      if Piece(TempSL[i],'^',1) <> '0' then TempSL.Delete(i);
    end;
    GetSuggestedCodesForTopic(FSuggestedLinks, ATopicName);
    if FSuggestedLinks.Count > 0 then begin
      TempSL.Insert(0,IntToStr(-ord(SuggestedICDs))+'^Previously used links^Previously used links');
    end;
    TempSL.Insert(0,IntToStr(-ord(PriorICDs))+'^Prior ICD''s^Prior ICD''s');
    TempSL.Add(IntToStr(-ord(StaffCode))+'^Staff To Code^Staff To Code');
    //Add encounter form ICD's
    for i := 0 to TMGInfoEncounterICDs.Count - 1 do begin
      TempS := TMGInfoEncounterICDs.Strings[i];  //fmt: 5^HEADER^<Section Name>"
      SL := TStringList(TMGInfoEncounterICDs.Objects[i]);
      TempS := IntToStr(-ord(EncounterICDs)) + '^' + IntToStr(i) + '^' + ENCOUNTER_STR + Piece(TempS, '^', 3);
      TempSL.AddObject(TempS, SL );
    end;
    lbSection.Items.Assign(TempSL);
    lbSection.ItemIndex := 0;
    lbSectionClick(lbSection);
  finally
    TempSL.Free;
  end;
end;


procedure TfrmTopicICDLinker.lbSectionClick(Sender: TObject);
var IntEntryType : integer;
    EntryType : tNodeType;
    SrchEnable : boolean;
    ShowLinkBtn : boolean;
begin
  inherited;
  if not FProgSectionClick then SetSearchMode(false);
  IntEntryType := -lbSection.ItemIEN;
  EntryType := tNodeType(IntEntryType);
  SrchEnable := (EntryType=EncounterICDs) or (EntryType=PriorICDs) or (EntryType=EncounterICDs);
  btnSearch.Visible := SrchEnable;
  if not SrchEnable then SetSearchMode(false);
  ListTMGDiagnosisCodes(lbxSection.Items, lbSection.ItemIEN);
  if lbxSection.Items.Count=1 then lbxSection.Checked[0] := true;  //auto check if only 1 entry
  ShowLinkBtn := (EntryType <> StaffCode);
  btnOK2Link.Visible := ShowLinkBtn;
  btnOK.Visible := not ShowLinkBtn;
end;

procedure TfrmTopicICDLinker.lbxSectionClickCheck(Sender: TObject; Index: Integer);
var
  IntEntryType: Integer;
  ItemStr : string;
  SelICDCode,ProblemText,CodeStatus,ProbIEN,ICDCSYS: string;
  TopicNarrative : string;
  SrcIndex : integer;
  SrcLine : string;

begin
  TopicNarrative := '';
  ResultICD := '';
  ResultDataStr.DataStr := '';
  if lbxSection.Checked[Index] then begin
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

    //format: ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys
    SelICDCode := Piece(ItemStr, U, 1);
    ProblemText := Piece(ItemStr, U, 2);
    CodeStatus := Piece(ItemStr, U, 4);
    ProbIEN := Piece(ItemStr, U, 5);
    ICDCSYS := Piece(ItemStr, U, 6);

    ResultICD := ItemStr;
    ResultDataStr.DataStr := ItemStr;
  end;
  UpdateStatus;
end;


procedure TfrmTopicICDLinker.UpdateStatus;
var
  ICDCode,ProblemText: string;

begin
  ICDCode := Piece(ResultICD, U, 1);
  ProblemText := Piece(ResultICD, U, 2);

  if ResultICD <> '' then begin
    lblResult.Caption := 'LINK TO: ' + ICDCode + ' -- ' + ProblemText;
  end else begin
    lblResult.Caption := '';
  end;
  btnOK2Link.Enabled := (ResultICD <> '');
  btnOK.Enabled := (ResultICD <> '');
end;

end.
