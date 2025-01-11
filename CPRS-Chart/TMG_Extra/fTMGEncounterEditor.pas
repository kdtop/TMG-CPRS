unit fTMGEncounterEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StrUtils, ORFn,
  fTMGEncounterICDPicker,
  Dialogs, StdCtrls, ExtCtrls, ORCtrls, Buttons;

type   //note: See also similar entry in fTMGDiagnoses
  { --moved to fTMGEncounterICDPicker
  tDxNodeType = (Other = 0,
                 TopicsDiscussed=1,
                 TopicsUndiscussed=2,
                 ProbList=3,
                 PriorICDs=4,
                 EncounterICDs=5,
                 StaffCode=6,
                 ManualLookup = 7,
                 SuggestedICDs = 8);
  }

  TfrmTMGEncounterEditor = class(TForm)
    pnlTop: TPanel;
    pnlMain: TPanel;
    pnlBottom: TPanel;
    lbSection: TORListBox;
    Splitter1: TSplitter;
    lblTopic: TLabel;
    lblTopicTitle: TLabel;
    Label1: TLabel;
    pnlRight: TPanel;
    Panel1: TPanel;
    lbxSection: TORListBox;
    btnAddToSection: TBitBtn;
    pnlBottomRight: TPanel;
    btnDelDx: TBitBtn;
    btnCancel: TBitBtn;
    procedure btnDelDxClick(Sender: TObject);
    procedure btnAddToSectionClick(Sender: TObject);
    procedure lbxSectionClickCheck(Sender: TObject; Index: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbSectionClick(Sender: TObject);
  private
    { Private declarations }
    FRefreshNeeded : boolean;
    LastLbxSectionIndex : integer;
    IgnorelbxSectionChanges : boolean;
    TMGInfoPriorICDs : TStringList;     //not owned by this class/object
    TMGInfoEncounterICDs : TStringList; //not owned by this class/object
    DxEntry : TDataStr;                 //not owned by this class/object  //Expected format: ENCOUNTER_ICD_FORMAT -- 'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys'; //5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
    SelectedSectionType : tDxNodeType;
    SelectedSectionName : string;
    procedure SetupSectionItems(SelectedSection : string);
    procedure UpdateStatusForLeftSide;
    procedure UpdateStatusForRightSide;
    procedure ListTMGDiagnosisCodes(Dest: TStrings; IntEntryType: Integer);
  public
    { Public declarations }
    EntryDataStr : TDataStr;  //format: STD_ICD_DATA_FORMAT        ICDCode^ProblemText^ICDCode^CodeStatus^ProblemIEN^ICDCodeSys
    procedure Initialize(Sender : TObject;
                         ADxEntry : TDataStr; //Expected ADxEntry format: ENCOUNTER_ICD_FORMAT -- 'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys'; //5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
                         ATMGInfoPriorICDs, ATMGInfoEncounterICDs : TStringList;
                         SelectedSection : string);
    property RefreshNeeded : boolean read FRefreshNeeded;
    property SelectedSection : string read SelectedSectionName;
  end;

  function AddEncounterDx(DxEntry : TDataStr;
                          ATMGInfoPriorICDs, ATMGInfoEncounterICDs : TStringList;
                          var SelectedSectionName : string) : boolean;  //forward  //Expected DxEntry format: ENCOUNTER_ICD_FORMAT -- 'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys'; //5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"

//var
//  frmTMGEncounterEditor: TfrmTMGEncounterEditor;  <-- not autocreated.

implementation

{$R *.dfm}

uses
  rPCE
  , UBAConst
  , rTIU
  , uCore
  ;

const
  STD_ICD_DATA_FORMAT    = 'ICDCode^ProblemText^ICDCode2^CodeStatus^ProblemIEN^ICDCodeSys';
  LB_SECTION_FORMAT      = 'type^SLIndex^DisplayTitle';
  ENCOUNTER_ICD_FORMAT   = 'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys'; //5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
  PRIOR_ICD_FORMAT       = 'Code^ICDCode^ICDLongName^FMDTLastUsed^ICDCodeSys';      //4^<PRIOR ICD>^<ICD LONG NAME>^<FMDT LAST USED>^<ICD_CODE_SYS>
  STD_FORMAT             = STD_ICD_DATA_FORMAT;
  //SUGGESTED_CODE_FORMAT  = 'TopicName^ICDCodeSys^ICDCode^ICDLongName^ProblemIEN^SCTCode^SCTName'; //  ;"TopicName^<"ICD" OR "10D">^<ICD CODE>^<ICD NAME>^<ProbIEN>^<SCT CODE>^<SCT NAME>
  SECTION_NAMES_FORMAT   = 'Code^Type^SectionName^IEN';  //e.g.: 5^HEADER^<Section Name>^<IEN>

  ENCOUNTER_STR          = 'Encounter Section: ';


function AddEncounterDx(DxEntry : TDataStr;
                        ATMGInfoPriorICDs, ATMGInfoEncounterICDs : TStringList;
                        var SelectedSectionName : string) : boolean;
//Expected format of DxEntry: ENCOUNTER_ICD_FORMAT -- 'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys'; //5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
//Result: TRUE if something added, and refresh needed.
var
  frmEditor: TfrmTMGEncounterEditor;
  ModalResult : integer;
begin
  Result := false;
  frmEditor := TfrmTMGEncounterEditor.Create(Application);
  try
    frmEditor.Initialize(Application, DxEntry, ATMGInfoPriorICDs, ATMGInfoEncounterICDs, SelectedSectionName);
    if (SelectedSectionName = '') then begin
      ModalResult := frmEditor.ShowModal;
    end else begin
      frmEditor.btnAddToSectionClick(nil);
      ModalResult := frmEditor.ModalResult;  //this is set by btnAddToSectionClick(), mrOK or mrNone
    end;
    if ModalResult <> mrOK then exit;
    Result := frmEditor.RefreshNeeded;
    if Result = true then begin
      SelectedSectionName := frmEditor.SelectedSection;
    end;
  finally
    frmEditor.Free;
  end;
end;

//====================================================================


procedure TfrmTMGEncounterEditor.lbSectionClick(Sender: TObject);
var IntEntryType : integer;
begin
  inherited;
  IntEntryType := -lbSection.ItemIEN;
  SelectedSectionType := tDxNodeType(IntEntryType);
  if lbSection.ItemIndex > -1 then begin
    SelectedSectionName := lbSection.Items[lbSection.ItemIndex];
    SelectedSectionName := piece(SelectedSectionName, '^', 3);
    SelectedSectionName := piece2(SelectedSectionName, 'Encounter Section: ', 2);
  end else begin
    SelectedSectionName := '';
  end;
  ListTMGDiagnosisCodes(lbxSection.Items, lbSection.ItemIEN);  //this populates right side.
  UpdateStatusForLeftSide();
end;

procedure TfrmTMGEncounterEditor.lbxSectionClickCheck(Sender: TObject; Index: Integer);
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
    EntryDataStr.DataStr := ItemStr;
  end;
  UpdateStatusForRightSide;
end;

procedure TfrmTMGEncounterEditor.btnAddToSectionClick(Sender: TObject);
var SectionName, ICDCode, ErrMsg, Result : string;
    success: boolean;
begin
  SectionName := SelectedSectionName;   //should be the name of the selected section to add entry into.
  ICDCode := DxEntry.Value['ICDCode'];
  Result := AddTMGEntry(SectionName, ICDCode);  //RPC call
  Success := (Result = '1^SUCCESS');
  if Success then begin
    FRefreshNeeded := true;
    Self.ModalResult := mrOK;  //should effect closure of form.
  end else begin
    ErrMsg := piece(Result, '^',2);
    MessageDlg('ERROR:' + CRLF + ErrMsg, mtError, [mbOK], 0);
    Self.ModalResult := mrNone;
  end;
end;

procedure TfrmTMGEncounterEditor.btnDelDxClick(Sender: TObject);
var SectionName, ICDCode, ErrMsg, Result : string;
    success: boolean;
begin
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

procedure TfrmTMGEncounterEditor.FormCreate(Sender: TObject);
begin
  Inherited;
  EntryDataStr := TDataStr.Create(STD_ICD_DATA_FORMAT);
  FRefreshNeeded := false;
  IgnorelbxSectionChanges := false;
  LastLbxSectionIndex := -1;
end;

procedure TfrmTMGEncounterEditor.FormDestroy(Sender: TObject);
begin
  EntryDataStr.Free;
  Inherited;
end;

procedure TfrmTMGEncounterEditor.Initialize(Sender : TObject;
                                            ADxEntry : TDataStr;
                                            ATMGInfoPriorICDs, ATMGInfoEncounterICDs : TStringList;
                                            SelectedSection : string);
//Expected format of ADxEntry: ENCOUNTER_ICD_FORMAT -- 'Code^Entry^ICDCode^DisplayName^ICDLongName^ICDCodeSys'; //5^ENTRY^<ICD CODE>^<DISPLAY NAME>^<ICD LONG NAME>^<ICDCODESYS>"
begin
  DxEntry := ADxEntry;                             //local copy of pointer to object owned elsewhere.
  TMGInfoPriorICDs := ATMGInfoPriorICDs;           //local copy of pointer to object owned elsewhere.
  TMGInfoEncounterICDs := ATMGInfoEncounterICDs;   //local copy of pointer to object owned elsewhere.
  lblTopic.Caption := DxEntry.Value['DisplayName'] + ' ' + DxEntry.Value['ICDCode'];
  SetupSectionItems(SelectedSection); //should effect setting SelectedSectionName
end;


procedure TfrmTMGEncounterEditor.SetupSectionItems(SelectedSection : string);
var TempSL, SL : TStringList;
    TempS, ASection : string;
    i, tempI : integer;
    index : integer;
    Entry : TDataStr;
begin
  TempSL := TStringList.Create;
  index := -1;
  Entry := TDataStr.Create(SECTION_NAMES_FORMAT);  //'Code^Type^SectionName^IEN'   e.g.: 5^HEADER^<Section Name>^<IEN>
  try
    //Add encounter form ICD's
    for i := 0 to TMGInfoEncounterICDs.Count - 1 do begin
      Entry.DataStr := TMGInfoEncounterICDs.Strings[i];  //'Code^Type^SectionName^IEN'   e.g.: 5^HEADER^<Section Name>^<IEN>
      SL := TStringList(TMGInfoEncounterICDs.Objects[i]);
      ASection := Entry.Value['SectionName'];
      if ASection = 'All Encounter Dx''s' then continue;
      TempS := IntToStr(-ord(EncounterICDs)) + '^' + IntToStr(i) + '^' + ENCOUNTER_STR +  ASection + '^' + Entry.Value['IEN'];
      tempI := TempSL.AddObject(TempS, SL );
      if ASection = SelectedSection then index := tempI;
    end;
    lbSection.Items.Assign(TempSL);
    if index = -1 then index := 0;
    lbSection.ItemIndex := index;
    lbSectionClick(lbSection);
  finally
    TempSL.Free;
    Entry.Free;
  end;
end;

procedure TfrmTMGEncounterEditor.UpdateStatusForLeftSide;
//var
//  ShowLinkBtn : boolean;
begin
  btnAddToSection.Enabled := true;
  btnAddToSection.Caption := 'Add To Section: [' + SelectedSectionName + ']';
  //ShowLinkBtn := (SelectedEntryType <> StaffCode);
  //btnOK2Link.Visible := ShowLinkBtn;
  //btnOK.Visible := not ShowLinkBtn;
  //btnEditSection.Visible := (SelectedEntryType = EncounterICDs);
end;


procedure TfrmTMGEncounterEditor.UpdateStatusForRightSide;
var
  ICDCode,ProblemText: string;
  HaveICD : boolean;

begin
  ICDCode := EntryDataStr.Value['ICDCode'];
  ProblemText := EntryDataStr.Value['ProblemText'];
  HaveICD := (ICDCode <> '');
  btnDelDx.Enabled := HaveICD;
  if HaveICD then begin
    pnlBottomRight.Height := btnDelDx.Height + 10;
  end else begin
    pnlBottomRight.Height := 0;
  end;
  btnAddToSection.Enabled := not HaveICD;
  //btnOK2Link.Enabled := HaveICD;
  //btnOK.Enabled      := HaveICD;
  //btnEditDx.Visible  := HaveICD and (SelectedEntryType = EncounterICDs);

end;

procedure TfrmTMGEncounterEditor.ListTMGDiagnosisCodes(Dest: TStrings; IntEntryType: Integer);
//this populates right side.
var i : integer;
    t, c, CodeName : string;
    DxDataStr : TDataStr;
    EntryType : tDxNodeType;
    SrcIndex : integer;  //index in SL
    Index : integer;
    SectionDataStr : TDataStr;
    DestDataStr : TDataStr;
    SL : TStringList;
    AddStr : string;

begin
  Dest.Clear;
  SectionDataStr := TDataStr.Create(LB_SECTION_FORMAT);
  DxDataStr   := TDataStr.Create(ENCOUNTER_ICD_FORMAT);
  DestDataStr    := TDataStr.Create(STD_FORMAT);
  try
    if IntEntryType < 0 then EntryType := tDxNodeType(-IntEntryType) else EntryType := Other;
    if EntryType = Other then begin
      ListDiagnosisCodes(Dest, IntEntryType);
    end else if EntryType = EncounterICDs  then begin
      DxDataStr.FormatStr := ENCOUNTER_ICD_FORMAT;
      Index := lbSection.ItemIndex;
      SectionDataStr.DataStr := lbSection.Items.Strings[Index];
      Index := SectionDataStr.IntValue['SLIndex'];
      if (Index >= 0) and (Index < TMGInfoEncounterICDs.Count) then begin
        SL := TStringList(TMGInfoEncounterICDs.Objects[Index]);
        if not assigned(SL) then exit;
        for i := 0 to SL.Count - 1 do begin
          DxDataStr.DataStr := SL.Strings[i];
          t := DxDataStr.Value['DisplayName'];
          CodeName := DxDataStr.Value['ICDLongName'];
          DxDataStr.Value['DisplayName'] := IfThen(t = '', CodeName, t+' ('+CodeName+')' );
          DestDataStr.AssignViaMap(DxDataStr, 'ICDCode^DisplayName^ICDCode^^^ICDCodeSys');  //compatable with STD_ICD_DATA_FORMAT
          c := DestDataStr.Value['ICDCode'];
          t := DestDataStr.Value['ProblemText'];
          AddStr := DestDataStr.DataStr;
          SrcIndex := i ;  //NOTE: use lbSection to determine which source list is active.
          Dest.AddObject(AddStr, pointer(SrcIndex));  //AddStr format is STD_FORMAT
        end;
      end;
    end;
    EntryDataStr.DataStr := '';  //Just reloaded, so nothing on right should be selected.  
    UpdateStatusForRightSide;
  finally
    SectionDataStr.Free;
    DxDataStr.Free;
    DestDataStr.Free;
  end;
  Application.ProcessMessages;      //Force a repaint  9/19/23
  Self.Invalidate;                  //Force a repaint
end;



end.
