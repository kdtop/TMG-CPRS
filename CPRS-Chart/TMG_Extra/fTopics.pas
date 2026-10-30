unit fTopics;

interface

uses
  Windows, Messages, Classes, Controls, ExtCtrls, Buttons, Graphics, fPage, VA508AccessibilityManager,
  Vcl.StdCtrls, Vcl.OleCtrls, SHDocVw, ORCtrls, Vcl.ComCtrls, Vcl.Menus, Vcl.Dialogs, MSHTML, Variants, ActiveX, SysUtils,
  CommCtrl, rTopics, ORDtTm, rCore, ORFn,
  System.UITypes, Vcl.ToolWin, System.ImageList, Vcl.ImgList, Vcl.BaseImageCollection, Vcl.ImageCollection, uPngGlyphButton, System.Generics.Collections,
  Vcl.Mask, Vcl.Forms;

type
  TControlCracker = class(TControl);

  TPendingTopicNoteChange = (ptncNewEntry, ptncExistingEntry, ptncTable);
  TPendingTopicNoteChanges = set of TPendingTopicNoteChange;

  TTopicListItemData = class
    PropertyID: string;
    LastUsedFMDate: Double;
    TopicName: string;
    Hidden: string;
    UserData: string;
    PendingNoteChanges: TPendingTopicNoteChanges;
  end;

  TTopicDataTable = class
    Changed: Boolean;
    TableIEN: string;
    TableName: string;
    Lines: TStringList;
    constructor Create(const ATableName: string; const ATableIEN: string = '');
    destructor Destroy; override;
  end;

  TTopicEntryPushData = class
    PropertyID: string;
    TopicName: string;
    EntryFMDate: string;
    HTMLText: string;
    Sequence: Integer;
  end;

  TTopicNotePatch = class
    PropertyID: string;
    TopicName: string;
    HTML: string;
    InsertedDates: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

  TPushSyncMode = (psmNewNote, psmCurrentNote);

  TTopicSortKey = record
    ColumnIndex: Integer;
    Ascending: Boolean;
  end;

  TfrmTopics = class(TfrmPage)
    pnlTopicsLeft: TPanel;
    splTopicsLeft: TSplitter;
    pnlTopicsCenter: TPanel;
    splTopicsRight: TSplitter;
    pnlTopicsRight: TPanel;
    timTopicsLeftCollapse: TTimer;
    timHideTopicsLeftHandle: TTimer;
    timTopicsLeftAnimate: TTimer;
    timTopicsRightAnimate: TTimer;
    timSaveTopicChanges: TTimer;
    wbDisplayPrior: TWebBrowser;
    wbEnterNew: TWebBrowser;
    lvTopics: TCaptionListView;
    wbTopicData: TWebBrowser;
    pnlCenterTop: TPanel;
    pnlCenterBottom: TPanel;
    Splitter1: TSplitter;
    ToolBar: TToolBar;
    btnDelete: TSpeedButton;
    cbFontNames: TComboBox;
    cbFontSize: TComboBox;
    btnFonts: TSpeedButton;
    btnItalic: TSpeedButton;
    btnBold: TSpeedButton;
    btnUnderline: TSpeedButton;
    btnBullets: TSpeedButton;
    btnNumbers: TSpeedButton;
    btnLeftAlign: TSpeedButton;
    btnCenterAlign: TSpeedButton;
    btnRightAlign: TSpeedButton;
    btnMoreIndent: TSpeedButton;
    btnLessIndent: TSpeedButton;
    btnShiftEnter: TSpeedButton;
    btnTextColor: TSpeedButton;
    btnBackColor: TSpeedButton;
    btnImage: TSpeedButton;
    btnEditZoomOut: TSpeedButton;
    btnEditNormalZoom: TSpeedButton;
    btnEditZoomIn: TSpeedButton;
    pnlBtnHolder: TPanel;
    btnSave: TBitBtn;
    pnlRightFooter: TPanel;
    btnAddAssocTable: TBitBtn;
    ImageList1: TImageList;
    ImageCollection1: TImageCollection;
    pnlLeftBot: TPanel;
    cbShowHidden: TCheckBox;
    edtFilter: TLabeledEdit;
    btnClearFilter: TBitBtn;
    btnCancel: TBitBtn;
    lblFMDT: TLabel;
    btnNewFMDTEntry: TBitBtn;
    btnNewTopic: TBitBtn;
    btnPushSync: TBitBtn;
    pnlCenterMiddle: TPanel;
    Splitter2: TSplitter;
    wbShowCurated: TWebBrowser;
    pnlCenterMiddleBanner: TPanel;
    lblLastCuratedTopic: TLabel;
    btnOpenCloseCurated: TBitBtn;
    procedure btnAddAssocTableClick(Sender: TObject);
    procedure btnPushSyncClick(Sender: TObject);
    procedure btnTopicsLeftHandleClick(Sender: TObject);
    procedure btnTopicsLeftHandleMouseEnter(Sender: TObject);
    procedure btnTopicsLeftHandleMouseLeave(Sender: TObject);
    procedure pnlTopicsLeftMouseEnter(Sender: TObject);
    procedure pnlTopicsLeftMouseLeave(Sender: TObject);
    procedure splTopicsLeftMoved(Sender: TObject);
    procedure splTopicsRightMoved(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure Splitter2Moved(Sender: TObject);
    procedure btnOpenCloseCuratedClick(Sender: TObject);
    procedure btnOpenCloseCuratedMouseEnter(Sender: TObject);
    procedure btnOpenCloseCuratedMouseLeave(Sender: TObject);
    procedure btnClearFilterClick(Sender: TObject);
    procedure edtFilterChange(Sender: TObject);
    procedure timTopicsLeftCollapseTimer(Sender: TObject);
    procedure timHideTopicsLeftHandleTimer(Sender: TObject);
    procedure timTopicsLeftAnimateTimer(Sender: TObject);
    procedure timTopicsRightAnimateTimer(Sender: TObject);
    procedure timSaveTopicChangesTimer(Sender: TObject);
    procedure timTopicFilterTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnNewFMDTEntryClick(Sender: TObject);
    procedure btnNewTopicClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnTopicsRightHandleClick(Sender: TObject);
    procedure btnTopicsLeftPinClick(Sender: TObject);
    procedure pnlTopicsElsewhereMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lvTopicsClick(Sender: TObject);
    procedure lvTopicsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvTopicsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lvTopicsCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvTopicsCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure cbShowHiddenClick(Sender: TObject);
    procedure HideTopicsMenuItemClick(Sender: TObject);
    procedure MergeTopicsMenuItemClick(Sender: TObject);
    procedure RenameTopicMenuItemClick(Sender: TObject);
    procedure DeleteTopicMenuItemClick(Sender: TObject);
    procedure TopicListPopupMenuPopup(Sender: TObject);
    procedure wbDisplayPriorBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure wbDisplayPriorDocumentComplete(Sender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    procedure wbTopicDataBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure wbTopicDataDocumentComplete(Sender: TObject; const pDisp: IDispatch; const URL: OleVariant);
  protected
    procedure Loaded; override;
    procedure Resize; override;
    procedure WMNotify(var Message: TWMNotify); message WM_NOTIFY;
    destructor Destroy; override;
  private
    btnTopicsLeftHandle: TPngGlyphButton;
    btnTopicsRightHandle: TPngGlyphButton;
    btnTopicsLeftPin: TPngGlyphButton;
    FTopicsLeftOpen: Boolean;
    FTopicsLeftPinned: Boolean;
    FTopicsLeftOpenWidth: Integer;
    FTopicsLeftClosedWidth: Integer;
    FTopicsLeftAnimating: Boolean;
    FTopicsLeftAnimationStartWidth: Integer;
    FTopicsLeftAnimationTargetWidth: Integer;
    FTopicsLeftAnimationStep: Integer;
    FTopicsRightOpen: Boolean;
    FTopicsRightOpenWidth: Integer;
    FTopicsRightClosedWidth: Integer;
    FTopicsRightAnimating: Boolean;
    FTopicsRightAnimationStartWidth: Integer;
    FTopicsRightAnimationTargetWidth: Integer;
    FTopicsRightAnimationStep: Integer;
    FTopicsLoaded: Boolean;
    FTopicListModel: TStringList;
    FTopicChanges: TTopicChanges;
    FCurrentTopicEntries: TStringList;
    FTopicDataTables: TObjectList<TTopicDataTable>;
    FPendingTopicTables: TObjectDictionary<string, TTopicDataTable>;
    FPendingTopicEntries: TObjectDictionary<string, TTopicEntryPushData>;
    FModifiedTopicEntries: TObjectDictionary<string, TTopicEntryPushData>;
    FPendingTopicNoteChanges: TDictionary<string, TPendingTopicNoteChanges>;
    FNextPendingTopicEntrySequence: Integer;
    FPushSyncMode: TPushSyncMode;
    FCurrentTopicName: string;
    FCurrentTopicPropertyID: string;
    FEditingTopicEntryFMDate: string;
    FNewTopicEntry: Boolean;
    FTopicSortKeys: TList<TTopicSortKey>;
    FTopicsListViewWindowProc: TWndMethod;
    FTopicListPopupMenu: TPopupMenu;
    FHideTopicsMenuItem: TMenuItem;
    FMergeTopicsMenuItem: TMenuItem;
    FRenameTopicMenuItem: TMenuItem;
    FDeleteTopicMenuItem: TMenuItem;
    FPendingTopicHTML: string;
    FPendingTopicEntryID: string;
    FTopicHiddenColumnWidth: Integer;
    FCuratedPaneOpen: Boolean;
    FCuratedPaneTopHeight: Integer;
    FCuratedPaneButtonHovered: Boolean;
    timTopicFilter: TTimer;
    function BuildCuratedTopicHTML(CuratedData: TStrings; const DefaultTopicName: string): string;
    function BuildTopicHTML(TopicData: TStrings; const DefaultTopicName: string): string;
    function BuildTopicDataHTML: string;
    procedure ClearTopicList;
    procedure ClearTopicEntryEditor;
    procedure CloseTopicsLeftWithoutDelay;
    procedure ConfigureTopicsElsewhereMouseDown(AParent: TWinControl);
    procedure DisplayTopicHTML(const HTML: string);
    procedure DisplayCuratedTopic;
    procedure DisplayTopicDataHTML;
    function CursorOverControl(AControl: TControl): Boolean;
    function CompareTopicListItems(Item1, Item2: TListItem; ColumnIndex: Integer): Integer;
    function FindTopicSortKey(ColumnIndex: Integer): Integer;
    function TopicListCellBackgroundColor(ColumnIndex: Integer): TColor;
    function FindLatestTopicEntryID(TopicData: TStrings): string;
    function FindTopicListItemData(const PropertyID: string): TTopicListItemData;
    function FindTopicDataTable(const TableName: string): TTopicDataTable;
    function FindTopicDataTableByIEN(const TableIEN: string): TTopicDataTable;
    function HasPendingPushSync: Boolean;
    function BuildPendingTopicEntryHTML: string;
    function SyncPendingTopicEntriesToCurrentNote(out ErrorText: string): Boolean;
    function CurrentPushSyncMode: TPushSyncMode;
    function TopicEntryPushKey(const PropertyID, EntryFMDate: string): string;
    function TopicTablePushKey(const TopicTable: TTopicDataTable): string;
    function TopicMatchesUserDataFilter(const UserData: string): Boolean;
    procedure EditTopicUserData(ListItem: TListItem);
    procedure EditCurrentTopicEntry(const EntryFMDate: string);
    procedure DeleteCurrentTopicEntry(const EntryFMDate: string);
    procedure DeleteSelectedTopic;
    procedure DeleteTopicDataTable(const TableIEN: string);
    procedure EditTopicDataTable(const TableIEN: string);
    procedure InitializeTopicListColumns;
    procedure LoadTopicDataTables(TopicEntries: TStrings);
    procedure MergeSelectedTopics;
    procedure RenameSelectedTopic;
    procedure NavigateToDocument(const DocumentIEN: string);
    procedure NormalizeTopicsLeftPaneWidths;
    procedure NormalizeTopicsRightPaneWidths;
    procedure ScrollTopicEntryIntoView(const EntryID: string);
    function TopicListColumnAt(X: Integer): Integer;
    function TopicListItemAt(X, Y: Integer; out ColumnIndex: Integer): TListItem;
    procedure QueueTopicChange(TopicData: TTopicListItemData; HiddenChanged, UserDataChanged: Boolean);
    procedure QueueTopicEntryChange(const PropertyID, EntryFMDate, Hidden, UserData: string; HiddenChanged, UserDataChanged: Boolean);
    procedure MarkTopicForNoteSync(const PropertyID: string; Change: TPendingTopicNoteChange);
    procedure ClearTopicNoteSyncChanges(Changes: TPendingTopicNoteChanges);
    procedure UpdateTopicPendingNoteChanges(const PropertyID: string);
    procedure RebuildTopicList;
    procedure RestoreTopicListLayout;
    procedure RestartTopicSaveTimer;
    procedure SaveTopicListLayout;
    procedure SetTopicEditorFormattingEnabled(Enabled: Boolean);
    procedure SetTopicEditorEditable(Editable: Boolean);
    procedure ToggleTopicEntryHidden(const EntryFMDate: string);
    procedure TrackAddedTopicEntry(const PropertyID, TopicName, EntryFMDate, HTMLText: string);
    procedure TrackModifiedTopicEntry(const PropertyID, TopicName, EntryFMDate, HTMLText: string);
    procedure TrackTopicTableChange(TopicTable: TTopicDataTable);
    procedure RemoveAddedTopicEntry(const PropertyID, EntryFMDate: string);
    procedure RemoveTopicTableChange(const TableIEN: string);
    procedure ClearPushedModifiedTopicEntries(const NoteDate: TFMDateTime);
    procedure ResetPushSyncState;
    procedure ResetPushedTopicEntries;
    procedure UpdatePushSyncButton;
    procedure ToggleTopicHidden(ListItem: TListItem);
    procedure ToggleSelectedTopicsHidden(ListItem: TListItem);
    procedure UpdateCenterPanelConstraints;
    procedure SetCuratedPaneOpen(ShouldOpen: Boolean);
    procedure UpdateOpenCloseCuratedGlyph;
    procedure HideTopicsLeftHandle;
    procedure PositionTopicsLeftHandle;
    procedure PositionTopicsLeftPin;
    procedure PositionTopicsRightHandle;
    procedure QueueTopicsLeftCollapse;
    procedure QueueHideTopicsLeftHandle;
    procedure SetTopicsLeftOpen(Value: Boolean);
    procedure SetTopicsRightOpen(Value: Boolean);
    procedure ShowTopicsLeftHandle;
    procedure splTopicsLeftMouseEnter(Sender: TObject);
    procedure splTopicsLeftMouseLeave(Sender: TObject);
    procedure UpdateTopicsLeftHandleGlyph;
    procedure UpdateTopicsLeftPinGlyph;
    procedure UpdateTopicsRightHandleGlyph;
    procedure UpdateTopicListColors;
    procedure UpdateTopicListSortIndicators;
    procedure UpdateTopicsRightColors;
    procedure UpdateTopicDataModel(TableData: TStrings);
    procedure UpdateTopicListHiddenColumn;
    procedure lvTopicsWindowProc(var Message: TMessage);
    procedure WritePendingTopicHTML;
  public
    function AllowContextChange(var WhyNot: string): Boolean; override;
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure HandlePushSync;
    procedure RefreshTopicList;
  end;

var
  frmTopics: TfrmTopics;

implementation

{$R *.dfm}

uses
  fFrame, fNotes, fSingleNote, fEncnt, uConst, uCore, uHTMLTools, uPCE,
  uTMGOptions, fTopicTablePicker, fTopicTableEdit, uHTMLNoteAnalysis, System.JSON;

const
  TOPICS_PANE_ANIMATION_STEPS = 3;
  TOPICS_PANE_ANIMATION_TIMESLICE_MS = 25;
  TOPICS_LEFT_COLLAPSE_DELAY_MS = 500;
  TOPICS_LEFT_COLLAPSE_RIGHT_DISTANCE = 100;
  TOPICS_LEFT_PANE_MINIMUM_WIDTH_GAP = 50;
  TOPICS_RIGHT_PANE_MINIMUM_WIDTH_GAP = 50;
  TOPICS_LEFT_OPEN_SIZE_KEY = 'frmTopics.LeftPaneOpenSize';
  TOPICS_LEFT_CLOSED_SIZE_KEY = 'frmTopics.LeftPaneClosedSize';
  TOPICS_RIGHT_OPEN_SIZE_KEY = 'frmTopics.RightPaneOpenSize';
  TOPICS_RIGHT_CLOSED_SIZE_KEY = 'frmTopics.RightPaneClosedSize';
  TOPICS_CENTER_TOP_HEIGHT_KEY = 'frmTopics.CenterTopHeight';
  TOPICS_CENTER_MIDDLE_OPEN_KEY = 'frmTopics.CenterMiddleOpen';
  TOPICS_CENTER_MIDDLE_MINIMUM_HEIGHT = 100;
  TOPICS_CENTER_MIDDLE_COLLAPSED_BROWSER_HEIGHT = 5;
  TOPICS_SHOW_HIDDEN_KEY = 'frmTopics.ShowHidden';
  TOPICS_LIST_COLUMN_WIDTH_KEY_PREFIX = 'frmTopics.ListColumnWidth';
  TOPICS_LIST_SORT_KEY = 'frmTopics.ListSort';
  TOPICS_IMAGE_PIN_DOWN_BLUE = 0;
  TOPICS_IMAGE_PIN_UP_BLUE = 1;
  TOPICS_IMAGE_ARROW_LEFT = 2;
  TOPICS_IMAGE_ARROW_RIGHT = 3;
  TOPICS_IMAGE_PIN_DOWN_RED = 4;
  TOPIC_SORT_ASCENDING_GLYPH = #9650;
  TOPIC_SORT_DESCENDING_GLYPH = #9660;
  TOPIC_PENDING_SYNC_GLYPH = #$2022;
  TOPIC_HIDDEN_COLUMN = 3;
  TOPIC_HIDDEN_SUBITEM = 2;
  TOPIC_USER_DATA_COLUMN = 2;
  TOPIC_USER_DATA_SUBITEM = 1;
  TOPIC_HIDDEN_COLUMN_WIDTH = 50;
  TOPIC_SAVE_DELAY_MS = 2000;
  TOPIC_FILTER_DELAY_MS = 200;
  TOPIC_COLUMN_CAPTIONS: array[0..3] of string = ('Topic', 'Last Used', 'User Data', 'Hidden');

function NormalizeTopicHidden(const Hidden: string): string;
begin
  if SameText(Hidden, 'Y') or SameText(Hidden, 'YES') then begin
    Result := 'YES'
  end else begin
    Result := Hidden;
  end;
end;

constructor TTopicDataTable.Create(const ATableName: string; const ATableIEN: string);
begin
  inherited Create;
  Changed := False;
  TableIEN := ATableIEN;
  TableName := ATableName;
  Lines := TStringList.Create;
end;

destructor TTopicDataTable.Destroy;
begin
  Lines.Free;
  inherited;
end;

constructor TTopicNotePatch.Create;
begin
  inherited Create;
  InsertedDates := TStringList.Create;
  InsertedDates.CaseSensitive := False;
  InsertedDates.Duplicates := dupIgnore;
  InsertedDates.Sorted := True;
end;

destructor TTopicNotePatch.Destroy;
begin
  InsertedDates.Free;
  inherited;
end;

function TfrmTopics.TopicEntryPushKey(const PropertyID, EntryFMDate: string): string;
begin
  Result := PropertyID + '^' + EntryFMDate;
end;

function TfrmTopics.TopicTablePushKey(const TopicTable: TTopicDataTable): string;
begin
  if TopicTable.TableIEN <> '' then begin
    Result := 'IEN:' + TopicTable.TableIEN;
  end else begin
    Result := 'NAME:' + UpperCase(TopicTable.TableName);
  end;
end;

function TfrmTopics.FindTopicListItemData(const PropertyID: string): TTopicListItemData;
var
  Index: Integer;
begin
  Result := nil;
  for Index := 0 to FTopicListModel.Count - 1 do begin
    if TTopicListItemData(FTopicListModel.Objects[Index]).PropertyID = PropertyID then begin
      Result := TTopicListItemData(FTopicListModel.Objects[Index]);
      Exit;
    end;
  end;
end;

procedure TfrmTopics.MarkTopicForNoteSync(const PropertyID: string; Change: TPendingTopicNoteChange);
var
  Changes: TPendingTopicNoteChanges;
  TopicData: TTopicListItemData;
begin
  if PropertyID = '' then begin
    Exit;
  end;
  FPendingTopicNoteChanges.TryGetValue(PropertyID, Changes);
  Include(Changes, Change);
  FPendingTopicNoteChanges.AddOrSetValue(PropertyID, Changes);
  TopicData := FindTopicListItemData(PropertyID);
  if Assigned(TopicData) then begin
    TopicData.PendingNoteChanges := Changes;
  end;
  RebuildTopicList;
end;

procedure TfrmTopics.ClearTopicNoteSyncChanges(Changes: TPendingTopicNoteChanges);
var
  Index: Integer;
  KeyList: TStringList;
  PendingChanges: TPendingTopicNoteChanges;
  Pair: TPair<string, TPendingTopicNoteChanges>;
  TopicData: TTopicListItemData;
begin
  KeyList := TStringList.Create;
  try
    for Pair in FPendingTopicNoteChanges do begin
      KeyList.Add(Pair.Key);
    end;
    for Index := 0 to KeyList.Count - 1 do begin
      PendingChanges := FPendingTopicNoteChanges[KeyList[Index]] - Changes;
      if PendingChanges = [] then begin
        FPendingTopicNoteChanges.Remove(KeyList[Index]);
      end else begin
        FPendingTopicNoteChanges[KeyList[Index]] := PendingChanges;
      end;
    end;
  finally
    KeyList.Free;
  end;
  for Index := 0 to FTopicListModel.Count - 1 do begin
    TopicData := TTopicListItemData(FTopicListModel.Objects[Index]);
    if not FPendingTopicNoteChanges.TryGetValue(TopicData.PropertyID, TopicData.PendingNoteChanges) then begin
      TopicData.PendingNoteChanges := [];
    end;
  end;
  RebuildTopicList;
end;

procedure TfrmTopics.UpdateTopicPendingNoteChanges(const PropertyID: string);
var
  Changes: TPendingTopicNoteChanges;
  TopicData: TTopicListItemData;
begin
  TopicData := FindTopicListItemData(PropertyID);
  if not Assigned(TopicData) then begin
    Exit;
  end;
  if FPendingTopicNoteChanges.TryGetValue(PropertyID, Changes) then begin
    TopicData.PendingNoteChanges := Changes;
  end else begin
    TopicData.PendingNoteChanges := [];
  end;
end;

function TfrmTopics.CurrentPushSyncMode: TPushSyncMode;
begin
  if Assigned(frmNotes) and frmNotes.InEditMode and
     (frmNotes.HTMLEditMode = emHTML) then begin
    Result := psmCurrentNote;
  end else begin
    Result := psmNewNote;
  end;
end;

function TfrmTopics.BuildPendingTopicEntryHTML: string;
var
  EntryDate: TFMDateTime;
  EntryDateText: string;
  EntryIndex: Integer;
  EntryList: TList<TTopicEntryPushData>;
  HTMLLines: TStringList;
  Modified: Boolean;
  NextIndex: Integer;
  Pair: TPair<string, TTopicEntryPushData>;
  TempEntry: TTopicEntryPushData;
  UseAsteriskStyle: Boolean;
begin
  Result := '';
  if FPendingTopicEntries.Count = 0 then begin
    Exit;
  end;
  EntryList := TList<TTopicEntryPushData>.Create;
  HTMLLines := TStringList.Create;
  try
    for Pair in FPendingTopicEntries do begin
      EntryList.Add(Pair.Value);
    end;
    for EntryIndex := 0 to EntryList.Count - 2 do begin
      for NextIndex := EntryIndex + 1 to EntryList.Count - 1 do begin
        if EntryList[NextIndex].Sequence < EntryList[EntryIndex].Sequence then begin
          TempEntry := EntryList[EntryIndex];
          EntryList[EntryIndex] := EntryList[NextIndex];
          EntryList[NextIndex] := TempEntry;
        end;
      end;
    end;
    UseAsteriskStyle := Pos('MARCIA', UpperCase(User.Name)) > 0;
    if not UseAsteriskStyle then begin
      HTMLLines.Add('<UL>');
    end;
    for EntryIndex := 0 to EntryList.Count - 1 do begin
      EntryDate := MakeFMDateTime(EntryList[EntryIndex].EntryFMDate);
      if EntryDate > 0 then begin
        EntryDateText := FormatDateTime('m/d/yy', FMDateTimeToDateTime(EntryDate));
      end else begin
        EntryDateText := EntryList[EntryIndex].EntryFMDate;
      end;
      Modified := False;
      if UseAsteriskStyle then begin
        HTMLLines.Add('<P>&nbsp;&nbsp;&nbsp;&nbsp;* <U>' +
          HTMLEncode(EntryList[EntryIndex].TopicName, Modified) + '</U>: ' +
          EntryDateText + ': ' + EntryList[EntryIndex].HTMLText + '<BR>');
      end else begin
        HTMLLines.Add('<LI><U>' +
          HTMLEncode(EntryList[EntryIndex].TopicName, Modified) + '</U>: ' +
          EntryDateText + ': ' + EntryList[EntryIndex].HTMLText + '<BR></LI>');
      end;
    end;
    if not UseAsteriskStyle then begin
      HTMLLines.Add('</UL>');
    end;
    Result := HTMLLines.Text;
  finally
    HTMLLines.Free;
    EntryList.Free;
  end;
end;

function TfrmTopics.SyncPendingTopicEntriesToCurrentNote(out ErrorText: string): Boolean;
var
  Analysis: TJSONObject;
  DateAnalysis: TJSONObject;
  EntryDate: TFMDateTime;
  EntryDateText: string;
  EntryIndex: Integer;
  EntryList: TList<TTopicEntryPushData>;
  OneEntry: TTopicEntryPushData;
  HTMLFragments: TStringList;
  HPI: TJSONObject;
  Index: Integer;
  NextIndex: Integer;
  NoteDate: TFMDateTime;
  NoteHTML: string;
  Patch: TTopicNotePatch;
  PatchList: TObjectList<TTopicNotePatch>;
  Pair: TPair<string, TTopicEntryPushData>;
  RequiresDate: Boolean;
  TempEntry: TTopicEntryPushData;
  Topic: TJSONObject;
  Topics: TJSONArray;
  TopicNames: TStringList;

  function JSONText(AObject: TJSONObject; const Name: string): string;
  var
    Value: TJSONValue;
  begin
    Result := '';
    if not Assigned(AObject) then begin
      Exit;
    end;
    Value := AObject.GetValue(Name);
    if Assigned(Value) then begin
      Result := Value.Value;
    end;
  end;

  function CanonicalTopicName(const TopicName: string): string;
  var
    CharacterIndex: Integer;
  begin
    Result := '';
    for CharacterIndex := 1 to Length(TopicName) do begin
      case TopicName[CharacterIndex] of
        ' ', #9, #10, #13, #160, #$200B, #$FEFF: begin
          // Ignore visible and invisible spacing characters.
        end;
        '-', #$2010, #$2011, #$2012, #$2013, #$2014, #$2212: begin
          Result := Result + '-';
        end;
      else
        Result := Result + UpperCase(TopicName[CharacterIndex]);
      end;
    end;
  end;

  function FindTopic(AAnalysis: TJSONObject; const TopicName: string): TJSONObject;
  var
    Topics: TJSONArray;
    TopicIndex: Integer;
    AnalyzedTopicName: string;
  begin
    Result := nil;
    if not Assigned(AAnalysis) then begin
      Exit;
    end;
    Topics := AAnalysis.GetValue('topics') as TJSONArray;
    if not Assigned(Topics) then begin
      Exit;
    end;
    for TopicIndex := 0 to Topics.Count - 1 do begin
      AnalyzedTopicName := CanonicalTopicName(JSONText(
        Topics.Items[TopicIndex] as TJSONObject, 'name'));
      if AnalyzedTopicName = CanonicalTopicName(TopicName) then begin
        Result := Topics.Items[TopicIndex] as TJSONObject;
        Exit;
      end;
    end;
  end;

  function FindPatch(const PropertyID: string): TTopicNotePatch;
  var
    ExistingPatchIndex: Integer;
  begin
    Result := nil;
    for ExistingPatchIndex := 0 to PatchList.Count - 1 do begin
      if PatchList[ExistingPatchIndex].PropertyID = PropertyID then begin
        Result := PatchList[ExistingPatchIndex];
        Exit;
      end;
    end;
  end;

  procedure AddOrReplaceEntry(Entry: TTopicEntryPushData);
  var
    ExistingEntryIndex: Integer;
  begin
    for ExistingEntryIndex := 0 to EntryList.Count - 1 do begin
      if (EntryList[ExistingEntryIndex].PropertyID = Entry.PropertyID) and
         (EntryList[ExistingEntryIndex].EntryFMDate = Entry.EntryFMDate) then begin
        EntryList[ExistingEntryIndex] := Entry;
        Exit;
      end;
    end;
    EntryList.Add(Entry);
  end;

  function RecognizedTopicNames(AAnalysis: TJSONObject): string;
  var
    RecognizedTopics: TJSONArray;
    TopicIndex: Integer;
  begin
    Result := '';
    if not Assigned(AAnalysis) then begin
      Exit;
    end;
    RecognizedTopics := AAnalysis.GetValue('topics') as TJSONArray;
    if not Assigned(RecognizedTopics) then begin
      Exit;
    end;
    for TopicIndex := 0 to RecognizedTopics.Count - 1 do begin
      if Result <> '' then begin
        Result := Result + ', ';
      end;
      Result := Result + JSONText(RecognizedTopics.Items[TopicIndex] as TJSONObject,
        'name');
    end;
    if Result = '' then begin
      Result := '(none)';
    end;
  end;

begin
  Result := False;
  ErrorText := '';
  if (FPendingTopicEntries.Count = 0) and (FModifiedTopicEntries.Count = 0) then begin
    ErrorText := 'There are no new or edited topic entries to sync to the current note.';
    Exit;
  end;
  if not Assigned(frmNotes) then begin
    ErrorText := 'The Notes window is not available.';
    Exit;
  end;
  NoteDate := frmNotes.ActiveEditDateTime;
  if NoteDate <= 0 then begin
    ErrorText := 'The active note does not have a valid date and time.';
    Exit;
  end;
  if not frmNotes.GetActiveEditorHTML(NoteHTML, ErrorText) then begin
    Exit;
  end;

  Analysis := AnalyzeHTMLNote(NoteHTML, FMDateTimeToDateTime(frmNotes.ActiveEditDateTime));
  EntryList := TList<TTopicEntryPushData>.Create;
  PatchList := TObjectList<TTopicNotePatch>.Create(True);
  try
    HPI := Analysis.GetValue('hpi') as TJSONObject;
    if not SameText(JSONText(HPI, 'found'), 'true') then begin
      ErrorText := 'The current note does not contain an HPI topic insertion target.' +
        sLineBreak + 'Add or load the HPI topic list before syncing.';
      Exit;
    end;
    Topics := Analysis.GetValue('topics') as TJSONArray;
    if (not Assigned(Topics)) or (Topics.Count = 0) then begin
      ErrorText := 'The current note contains no HPI topic insertion targets.' +
        sLineBreak + 'Add or load the HPI topic list before syncing.';
      Exit;
    end;
    for Pair in FPendingTopicEntries do begin
      AddOrReplaceEntry(Pair.Value);
    end;
    for Pair in FModifiedTopicEntries do begin
      EntryDate := MakeFMDateTime(Pair.Value.EntryFMDate);
      if (EntryDate > 0) and (Trunc(FMDateTimeToDateTime(EntryDate)) =
        Trunc(FMDateTimeToDateTime(NoteDate))) then begin
        AddOrReplaceEntry(Pair.Value);
      end;
    end;
    if EntryList.Count = 0 then begin
      ErrorText := 'There are no new topic entries or edited entries dated the same as the current note to sync.';
      Exit;
    end;
    for EntryIndex := 0 to EntryList.Count - 2 do begin
      for NextIndex := EntryIndex + 1 to EntryList.Count - 1 do begin
        if EntryList[NextIndex].Sequence < EntryList[EntryIndex].Sequence then begin
          TempEntry := EntryList[EntryIndex];
          EntryList[EntryIndex] := EntryList[NextIndex];
          EntryList[NextIndex] := TempEntry;
        end;
      end;
    end;
    for EntryIndex := 0 to EntryList.Count - 1 do begin
      OneEntry := EntryList[EntryIndex];  //for easier view during debugging.
      if Trim(EntryList[EntryIndex].HTMLText) = '' then begin
        ErrorText := 'A pending topic entry has no text to insert.';
        Exit;
      end;
      EntryDate := MakeFMDateTime(EntryList[EntryIndex].EntryFMDate);
      if EntryDate <= 0 then begin
        ErrorText := 'A pending topic entry has an invalid FileMan date.';
        Exit;
      end;
      Patch := FindPatch(EntryList[EntryIndex].PropertyID);
      if not Assigned(Patch) then begin
        Topic := FindTopic(Analysis, EntryList[EntryIndex].TopicName);
        if not Assigned(Topic) then begin
          ErrorText := 'The topic "' + EntryList[EntryIndex].TopicName +
            '" was not recognized in the HPI of the current note.' + sLineBreak +
            'Recognized HPI topics: ' + RecognizedTopicNames(Analysis);
          Exit;
        end;
        Patch := TTopicNotePatch.Create;
        Patch.PropertyID := EntryList[EntryIndex].PropertyID;
        Patch.TopicName := EntryList[EntryIndex].TopicName;
        if StrToIntDef(JSONText(Topic, 'insertionOffset'), -1) < 0 then begin
          Patch.Free;
          ErrorText := 'The insertion point for topic "' + EntryList[EntryIndex].TopicName +
            '" could not be determined.';
          Exit;
        end;
        PatchList.Add(Patch);
      end;
      DateAnalysis := AnalyzeHTMLNote(NoteHTML, FMDateTimeToDateTime(EntryDate));
      try
        Topic := FindTopic(DateAnalysis, EntryList[EntryIndex].TopicName);
        if not Assigned(Topic) then begin
          ErrorText := 'The dated insertion point for topic "' + EntryList[EntryIndex].TopicName +
            '" could not be determined.';
          Exit;
        end;
        RequiresDate := SameText(JSONText(Topic, 'requiresAsOfDate'), 'true');
      finally
        DateAnalysis.Free;
      end;
      EntryDateText := FormatDateTime('m/d/yy', FMDateTimeToDateTime(EntryDate));
      if RequiresDate and (Patch.InsertedDates.IndexOf(EntryDateText) < 0) then begin
        Patch.HTML := Patch.HTML + EntryDateText + ': ';
        Patch.InsertedDates.Add(EntryDateText);
      end;
      Patch.HTML := Patch.HTML + EntryList[EntryIndex].HTMLText + '<BR><BR>';
    end;
    TopicNames := TStringList.Create;
    HTMLFragments := TStringList.Create;
    try
      for Index := 0 to PatchList.Count - 1 do begin
        TopicNames.Add(PatchList[Index].TopicName);
        HTMLFragments.Add(PatchList[Index].HTML);
      end;
      if not frmNotes.InsertHTMLAtTopicEnds(TopicNames, HTMLFragments, ErrorText) then begin
        Exit;
      end;
      ResetPushedTopicEntries;
      ClearPushedModifiedTopicEntries(NoteDate);
      Result := True;
    finally
      HTMLFragments.Free;
      TopicNames.Free;
    end;
  finally
    PatchList.Free;
    EntryList.Free;
    Analysis.Free;
  end;
end;

function TfrmTopics.HasPendingPushSync: Boolean;
begin
  Result := FPendingTopicNoteChanges.Count > 0;
end;

procedure TfrmTopics.UpdatePushSyncButton;
begin
  FPushSyncMode := CurrentPushSyncMode;
  case FPushSyncMode of
    psmNewNote: btnPushSync.Caption := 'Push to New Note';
    psmCurrentNote: btnPushSync.Caption := 'Sync to Current Note';
  end;
  btnPushSync.Enabled := HasPendingPushSync;
end;

procedure TfrmTopics.TrackTopicTableChange(TopicTable: TTopicDataTable);
var
  PendingTable: TTopicDataTable;
  PushKey: string;
begin
  if not Assigned(TopicTable) then begin
    Exit;
  end;
  PushKey := TopicTablePushKey(TopicTable);
  if not FPendingTopicTables.TryGetValue(PushKey, PendingTable) then begin
    PendingTable := TTopicDataTable.Create(TopicTable.TableName, TopicTable.TableIEN);
    FPendingTopicTables.Add(PushKey, PendingTable);
  end;
  PendingTable.TableName := TopicTable.TableName;
  PendingTable.TableIEN := TopicTable.TableIEN;
  PendingTable.Lines.Assign(TopicTable.Lines);
  PendingTable.Changed := True;
  TopicTable.Changed := True;
  MarkTopicForNoteSync(FCurrentTopicPropertyID, ptncTable);
  UpdatePushSyncButton;
end;

procedure TfrmTopics.TrackAddedTopicEntry(const PropertyID, TopicName, EntryFMDate,
  HTMLText: string);
var
  PendingEntry: TTopicEntryPushData;
  PushKey: string;
begin
  PushKey := TopicEntryPushKey(PropertyID, EntryFMDate);
  if not FPendingTopicEntries.TryGetValue(PushKey, PendingEntry) then begin
    PendingEntry := TTopicEntryPushData.Create;
    PendingEntry.Sequence := FNextPendingTopicEntrySequence;
    Inc(FNextPendingTopicEntrySequence);
    FPendingTopicEntries.Add(PushKey, PendingEntry);
  end;
  PendingEntry.PropertyID := PropertyID;
  PendingEntry.TopicName := TopicName;
  PendingEntry.EntryFMDate := EntryFMDate;
  PendingEntry.HTMLText := HTMLText;
  MarkTopicForNoteSync(PropertyID, ptncNewEntry);
  UpdatePushSyncButton;
end;

procedure TfrmTopics.TrackModifiedTopicEntry(const PropertyID, TopicName, EntryFMDate,
  HTMLText: string);
var
  PendingEntry: TTopicEntryPushData;
  PushKey: string;
begin
  PushKey := TopicEntryPushKey(PropertyID, EntryFMDate);
  if not FModifiedTopicEntries.TryGetValue(PushKey, PendingEntry) then begin
    PendingEntry := TTopicEntryPushData.Create;
    PendingEntry.Sequence := FNextPendingTopicEntrySequence;
    Inc(FNextPendingTopicEntrySequence);
    FModifiedTopicEntries.Add(PushKey, PendingEntry);
  end;
  PendingEntry.PropertyID := PropertyID;
  PendingEntry.TopicName := TopicName;
  PendingEntry.EntryFMDate := EntryFMDate;
  PendingEntry.HTMLText := HTMLText;
  MarkTopicForNoteSync(PropertyID, ptncExistingEntry);
  UpdatePushSyncButton;
end;

procedure TfrmTopics.RemoveTopicTableChange(const TableIEN: string);
var
  PendingTable: TTopicDataTable;
  PushKey: string;
begin
  PushKey := 'IEN:' + TableIEN;
  if FPendingTopicTables.TryGetValue(PushKey, PendingTable) then begin
    FPendingTopicTables.Remove(PushKey);
  end;
  MarkTopicForNoteSync(FCurrentTopicPropertyID, ptncTable);
  UpdatePushSyncButton;
end;

procedure TfrmTopics.RemoveAddedTopicEntry(const PropertyID, EntryFMDate: string);
var
  HasAnotherPendingEntry: Boolean;
  PendingChanges: TPendingTopicNoteChanges;
  Pair: TPair<string, TTopicEntryPushData>;
  PushKey: string;
begin
  PushKey := TopicEntryPushKey(PropertyID, EntryFMDate);
  FPendingTopicEntries.Remove(PushKey);
  HasAnotherPendingEntry := False;
  for Pair in FPendingTopicEntries do begin
    if Pair.Value.PropertyID = PropertyID then begin
      HasAnotherPendingEntry := True;
      Break;
    end;
  end;
  if not HasAnotherPendingEntry then begin
    if FPendingTopicNoteChanges.TryGetValue(PropertyID, PendingChanges) then begin
      Exclude(PendingChanges, ptncNewEntry);
      if PendingChanges = [] then begin
        FPendingTopicNoteChanges.Remove(PropertyID);
      end else begin
        FPendingTopicNoteChanges[PropertyID] := PendingChanges;
      end;
      UpdateTopicPendingNoteChanges(PropertyID);
      RebuildTopicList;
    end;
  end;
  UpdatePushSyncButton;
end;

procedure TfrmTopics.ClearPushedModifiedTopicEntries(const NoteDate: TFMDateTime);
var
  AffectedPropertyIDs: TStringList;
  EntryDate: TFMDateTime;
  HasRemainingModifiedEntry: Boolean;
  Index: Integer;
  Pair: TPair<string, TTopicEntryPushData>;
  PendingChanges: TPendingTopicNoteChanges;
  PushedKeys: TStringList;
begin
  PushedKeys := TStringList.Create;
  AffectedPropertyIDs := TStringList.Create;
  try
    AffectedPropertyIDs.Sorted := True;
    AffectedPropertyIDs.Duplicates := dupIgnore;
    for Pair in FModifiedTopicEntries do begin
      EntryDate := MakeFMDateTime(Pair.Value.EntryFMDate);
      if (EntryDate > 0) and (Trunc(FMDateTimeToDateTime(EntryDate)) =
        Trunc(FMDateTimeToDateTime(NoteDate))) then begin
        PushedKeys.Add(Pair.Key);
        AffectedPropertyIDs.Add(Pair.Value.PropertyID);
      end;
    end;
    for Index := 0 to PushedKeys.Count - 1 do begin
      FModifiedTopicEntries.Remove(PushedKeys[Index]);
    end;
    for Index := 0 to AffectedPropertyIDs.Count - 1 do begin
      HasRemainingModifiedEntry := False;
      for Pair in FModifiedTopicEntries do begin
        if Pair.Value.PropertyID = AffectedPropertyIDs[Index] then begin
          HasRemainingModifiedEntry := True;
          Break;
        end;
      end;
      if not HasRemainingModifiedEntry and
         FPendingTopicNoteChanges.TryGetValue(AffectedPropertyIDs[Index], PendingChanges) then begin
        Exclude(PendingChanges, ptncExistingEntry);
        if PendingChanges = [] then begin
          FPendingTopicNoteChanges.Remove(AffectedPropertyIDs[Index]);
        end else begin
          FPendingTopicNoteChanges[AffectedPropertyIDs[Index]] := PendingChanges;
        end;
        UpdateTopicPendingNoteChanges(AffectedPropertyIDs[Index]);
      end;
    end;
    if PushedKeys.Count > 0 then begin
      RebuildTopicList;
    end;
  finally
    AffectedPropertyIDs.Free;
    PushedKeys.Free;
  end;
  UpdatePushSyncButton;
end;

procedure TfrmTopics.ResetPushSyncState;
var
  Index: Integer;
begin
  FPendingTopicTables.Clear;
  FPendingTopicEntries.Clear;
  FModifiedTopicEntries.Clear;
  ClearTopicNoteSyncChanges([ptncNewEntry, ptncExistingEntry, ptncTable]);
  for Index := 0 to FTopicDataTables.Count - 1 do begin
    FTopicDataTables[Index].Changed := False;
  end;
  UpdatePushSyncButton;
end;

procedure TfrmTopics.ResetPushedTopicEntries;
begin
  FPendingTopicEntries.Clear;
  ClearTopicNoteSyncChanges([ptncNewEntry]);
  UpdatePushSyncButton;
end;

procedure TfrmTopics.btnPushSyncClick(Sender: TObject);
begin
  HandlePushSync;
end;

procedure TfrmTopics.HandlePushSync;
var
  ErrorText: string;
  TopicHTML: string;
begin
  UpdatePushSyncButton;
  case FPushSyncMode of
    psmNewNote: begin
      TopicHTML := BuildPendingTopicEntryHTML;
      if TopicHTML = '' then begin
        MessageDlg('There are no new topic entries to push to a new note.',
          mtInformation, [mbOK], 0);
        Exit;
      end;
      if Assigned(frmSingleNote) then begin
        MessageDlg('A Single Note window is already open.' + sLineBreak +
          'Close it before pushing topics to a new note.', mtWarning, [mbOK], 0);
        frmSingleNote.BringToFront;
        Exit;
      end;
      CreateSingleNote(snmNurse);
      if not Assigned(frmSingleNote) then begin
        Exit;
      end;
      if frmSingleNote.InsertCarryForwardTopics(TopicHTML) then begin
        ResetPushedTopicEntries;
      end else begin
        MessageDlg('The Carry Forward area could not be created in the new note.',
          mtError, [mbOK], 0);
      end;
    end;
    psmCurrentNote: begin
      if not SyncPendingTopicEntriesToCurrentNote(ErrorText) then begin
        MessageDlg(ErrorText, mtError, [mbOK], 0);
      end else if (FModifiedTopicEntries.Count > 0) or (FPendingTopicTables.Count > 0) then begin
        MessageDlg('New topic entries were inserted into the current note.' + sLineBreak + sLineBreak +
          'Existing-entry and table changes remain pending for a later sync.',
          mtInformation, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TfrmTopics.Loaded;
var
  SavedTopicsLeftOpenWidth: Integer;
  SavedTopicsLeftClosedWidth: Integer;
  SavedTopicsRightOpenWidth: Integer;
  SavedTopicsRightClosedWidth: Integer;
begin
  inherited;
  btnTopicsLeftHandle := TPngGlyphButton.Create(Self);
  btnTopicsLeftHandle.Name := 'btnTopicsLeftHandle';
  btnTopicsLeftHandle.Parent := Self;
  btnTopicsLeftHandle.Visible := False;
  btnTopicsLeftHandle.OnClick := btnTopicsLeftHandleClick;
  btnTopicsLeftHandle.OnMouseEnter := btnTopicsLeftHandleMouseEnter;
  btnTopicsLeftHandle.OnMouseLeave := btnTopicsLeftHandleMouseLeave;
  btnTopicsRightHandle := TPngGlyphButton.Create(Self);
  btnTopicsRightHandle.Name := 'btnTopicsRightHandle';
  btnTopicsRightHandle.Parent := Self;
  btnTopicsRightHandle.OnClick := btnTopicsRightHandleClick;
  btnTopicsLeftPin := TPngGlyphButton.Create(Self);
  btnTopicsLeftPin.Name := 'btnTopicsLeftPin';
  btnTopicsLeftPin.Parent := Self;
  btnTopicsLeftPin.OnClick := btnTopicsLeftPinClick;
  FTopicListModel := TStringList.Create;
  FTopicListModel.OwnsObjects := True;
  FTopicChanges := TTopicChanges.Create([doOwnsValues]);
  FCurrentTopicEntries := TStringList.Create;
  FTopicDataTables := TObjectList<TTopicDataTable>.Create(True);
  FPendingTopicTables := TObjectDictionary<string, TTopicDataTable>.Create([doOwnsValues]);
  FPendingTopicEntries := TObjectDictionary<string, TTopicEntryPushData>.Create([doOwnsValues]);
  FModifiedTopicEntries := TObjectDictionary<string, TTopicEntryPushData>.Create([doOwnsValues]);
  FPendingTopicNoteChanges := TDictionary<string, TPendingTopicNoteChanges>.Create;
  FNextPendingTopicEntrySequence := 0;
  FPushSyncMode := psmNewNote;
  FTopicSortKeys := TList<TTopicSortKey>.Create;
  InitializeTopicListColumns;
  FTopicListPopupMenu := TPopupMenu.Create(Self);
  FTopicListPopupMenu.OnPopup := TopicListPopupMenuPopup;
  FRenameTopicMenuItem := TMenuItem.Create(FTopicListPopupMenu);
  FRenameTopicMenuItem.Caption := 'Rename topic';
  FRenameTopicMenuItem.OnClick := RenameTopicMenuItemClick;
  FTopicListPopupMenu.Items.Add(FRenameTopicMenuItem);
  FDeleteTopicMenuItem := TMenuItem.Create(FTopicListPopupMenu);
  FDeleteTopicMenuItem.Caption := 'Delete topic';
  FDeleteTopicMenuItem.OnClick := DeleteTopicMenuItemClick;
  FTopicListPopupMenu.Items.Add(FDeleteTopicMenuItem);
  FHideTopicsMenuItem := TMenuItem.Create(FTopicListPopupMenu);
  FHideTopicsMenuItem.OnClick := HideTopicsMenuItemClick;
  FTopicListPopupMenu.Items.Add(FHideTopicsMenuItem);
  FMergeTopicsMenuItem := TMenuItem.Create(FTopicListPopupMenu);
  FMergeTopicsMenuItem.Caption := 'Merge Topics';
  FMergeTopicsMenuItem.OnClick := MergeTopicsMenuItemClick;
  FTopicListPopupMenu.Items.Add(FMergeTopicsMenuItem);
  timTopicFilter := TTimer.Create(Self);
  timTopicFilter.Interval := TOPIC_FILTER_DELAY_MS;
  timTopicFilter.OnTimer := timTopicFilterTimer;
  edtFilter.OnChange := edtFilterChange;
  btnClearFilter.OnClick := btnClearFilterClick;
  btnClearFilter.Enabled := edtFilter.Text <> '';
  cbShowHidden.Checked := uTMGOptions.ReadBool(TOPICS_SHOW_HIDDEN_KEY, False);
  cbShowHidden.OnClick := cbShowHiddenClick;
  lvTopics.MultiSelect := True;
  FTopicsLeftOpenWidth := uTMGOptions.ReadInteger(TOPICS_LEFT_OPEN_SIZE_KEY, pnlTopicsLeft.Width);
  FTopicsLeftClosedWidth := uTMGOptions.ReadInteger(TOPICS_LEFT_CLOSED_SIZE_KEY, splTopicsLeft.MinSize);
  SavedTopicsLeftOpenWidth := FTopicsLeftOpenWidth;
  SavedTopicsLeftClosedWidth := FTopicsLeftClosedWidth;
  NormalizeTopicsLeftPaneWidths;
  FTopicsLeftOpen := False;
  pnlTopicsLeft.Width := FTopicsLeftClosedWidth;
  FTopicsRightOpenWidth := uTMGOptions.ReadInteger(TOPICS_RIGHT_OPEN_SIZE_KEY, pnlTopicsRight.Width);
  FTopicsRightClosedWidth := uTMGOptions.ReadInteger(TOPICS_RIGHT_CLOSED_SIZE_KEY, splTopicsRight.MinSize);
  SavedTopicsRightOpenWidth := FTopicsRightOpenWidth;
  SavedTopicsRightClosedWidth := FTopicsRightClosedWidth;
  NormalizeTopicsRightPaneWidths;
  pnlTopicsRight.Constraints.MinWidth := FTopicsRightClosedWidth;
  FTopicsRightOpen := True;
  pnlTopicsRight.Width := FTopicsRightOpenWidth;
  FCuratedPaneOpen := True;
  FCuratedPaneButtonHovered := False;
  UpdateCenterPanelConstraints;
  pnlCenterTop.Height := uTMGOptions.ReadInteger(TOPICS_CENTER_TOP_HEIGHT_KEY, pnlCenterTop.Height);
  UpdateCenterPanelConstraints;
  FCuratedPaneTopHeight := pnlCenterTop.Height;
  FCuratedPaneOpen := uTMGOptions.ReadBool(TOPICS_CENTER_MIDDLE_OPEN_KEY, True);
  UpdateCenterPanelConstraints;
  Splitter1.OnMoved := Splitter1Moved;
  Splitter2.OnMoved := Splitter2Moved;
  btnOpenCloseCurated.OnClick := btnOpenCloseCuratedClick;
  btnOpenCloseCurated.OnMouseEnter := btnOpenCloseCuratedMouseEnter;
  btnOpenCloseCurated.OnMouseLeave := btnOpenCloseCuratedMouseLeave;
  UpdateOpenCloseCuratedGlyph;
  timTopicsLeftCollapse.Interval := TOPICS_LEFT_COLLAPSE_DELAY_MS;
  timTopicsLeftAnimate.Interval := TOPICS_PANE_ANIMATION_TIMESLICE_MS;
  timTopicsRightAnimate.Interval := TOPICS_PANE_ANIMATION_TIMESLICE_MS;
  timSaveTopicChanges.Interval := TOPIC_SAVE_DELAY_MS;
  TControlCracker(splTopicsLeft).OnMouseEnter := splTopicsLeftMouseEnter;
  TControlCracker(splTopicsLeft).OnMouseLeave := splTopicsLeftMouseLeave;
  TControlCracker(lvTopics).OnMouseEnter := pnlTopicsLeftMouseEnter;
  TControlCracker(lvTopics).OnMouseLeave := pnlTopicsLeftMouseLeave;
  ConfigureTopicsElsewhereMouseDown(pnlTopicsCenter);
  ConfigureTopicsElsewhereMouseDown(pnlTopicsRight);
  lvTopics.OnClick := lvTopicsClick;
  FTopicsListViewWindowProc := lvTopics.WindowProc;
  lvTopics.WindowProc := lvTopicsWindowProc;
  lvTopics.OnColumnClick := lvTopicsColumnClick;
  lvTopics.OnCompare := lvTopicsCompare;
  lvTopics.OnCustomDrawItem := lvTopicsCustomDrawItem;
  lvTopics.OnCustomDrawSubItem := lvTopicsCustomDrawSubItem;
  UpdateTopicListColors;
  RestoreTopicListLayout;
  UpdateTopicListSortIndicators;
  wbDisplayPrior.OnBeforeNavigate2 := wbDisplayPriorBeforeNavigate2;
  wbDisplayPrior.OnDocumentComplete := wbDisplayPriorDocumentComplete;
  wbTopicData.OnBeforeNavigate2 := wbTopicDataBeforeNavigate2;
  wbTopicData.OnDocumentComplete := wbTopicDataDocumentComplete;
  WBLoadHTML(wbShowCurated, '<html><body></body></html>');
  WBLoadHTML(wbTopicData, '<html><body></body></html>');
  UpdateTopicsLeftHandleGlyph;
  UpdateTopicsRightHandleGlyph;
  UpdateTopicsLeftPinGlyph;
  UpdateTopicsRightColors;
  WBLoadHTML(wbEnterNew, '<html><body></body></html>');
  SetTopicEditorEditable(False);
  UpdatePushSyncButton;
  btnAddAssocTable.Enabled := False;
  btnNewTopic.Enabled := Patient.DFN <> '';
  PositionTopicsLeftHandle;
  PositionTopicsRightHandle;
  FTopicsLoaded := True;
  if (FTopicsLeftOpenWidth <> SavedTopicsLeftOpenWidth) or (FTopicsLeftClosedWidth <> SavedTopicsLeftClosedWidth) then begin
    uTMGOptions.WriteInteger(TOPICS_LEFT_OPEN_SIZE_KEY, FTopicsLeftOpenWidth);
    uTMGOptions.WriteInteger(TOPICS_LEFT_CLOSED_SIZE_KEY, FTopicsLeftClosedWidth);
  end;
  if (FTopicsRightOpenWidth <> SavedTopicsRightOpenWidth) or (FTopicsRightClosedWidth <> SavedTopicsRightClosedWidth) then begin
    uTMGOptions.WriteInteger(TOPICS_RIGHT_OPEN_SIZE_KEY, FTopicsRightOpenWidth);
    uTMGOptions.WriteInteger(TOPICS_RIGHT_CLOSED_SIZE_KEY, FTopicsRightClosedWidth);
  end;
  Resize;
end;

procedure TfrmTopics.Resize;
begin
  inherited;
  if (not FTopicsLoaded) or (csDestroying in ComponentState) then begin
    Exit;
  end;
  UpdateCenterPanelConstraints;
  PositionTopicsLeftHandle;
  PositionTopicsRightHandle;
  PositionTopicsLeftPin;
end;

procedure TfrmTopics.WMNotify(var Message: TWMNotify);
begin
  inherited;
  if (Message.NMHdr <> nil) and (Message.NMHdr^.hwndFrom = lvTopics.Handle) and (Message.NMHdr^.code = -121) then begin
    if cbShowHidden.Checked then begin
      FTopicHiddenColumnWidth := lvTopics.Columns[TOPIC_HIDDEN_COLUMN].Width;
    end;
    SaveTopicListLayout;
  end;
end;

destructor TfrmTopics.Destroy;
begin
  if Assigned(lvTopics) then begin
    if Assigned(FTopicsListViewWindowProc) then begin
      lvTopics.WindowProc := FTopicsListViewWindowProc;
    end;
    ClearTopicList;
  end;
  if Assigned(timSaveTopicChanges) then begin
    timSaveTopicChanges.Enabled := False;
  end;
  FTopicListModel.Free;
  FTopicChanges.Free;
  FCurrentTopicEntries.Free;
  FTopicDataTables.Free;
  FPendingTopicTables.Free;
  FPendingTopicEntries.Free;
  FModifiedTopicEntries.Free;
  FPendingTopicNoteChanges.Free;
  FTopicSortKeys.Free;
  inherited;
end;

function TfrmTopics.AllowContextChange(var WhyNot: string): Boolean;
begin
  Result := inherited AllowContextChange(WhyNot);
  if not Result then begin
    Exit;
  end;
  if (FEditingTopicEntryFMDate <> '') or FNewTopicEntry then begin
    Result := MessageDlg('A topic entry is being edited.' + sLineBreak + sLineBreak +
      'Discard its changes and change patients?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
    if not Result then begin
      WhyNot := 'A topic entry is being edited.';
    end;
  end;
end;

procedure TfrmTopics.ClearPtData;
begin
  inherited;
  timSaveTopicChanges.Enabled := False;
  if Assigned(timTopicFilter) then begin
    timTopicFilter.Enabled := False;
  end;
  edtFilter.Text := '';
  btnClearFilter.Enabled := False;
  ClearTopicList;
  FTopicListModel.Clear;
  FTopicChanges.Clear;
  FCurrentTopicEntries.Clear;
  FTopicDataTables.Clear;
  FPendingTopicTables.Clear;
  FPendingTopicEntries.Clear;
  FModifiedTopicEntries.Clear;
  FPendingTopicNoteChanges.Clear;
  FNextPendingTopicEntrySequence := 0;
  FCurrentTopicName := '';
  FCurrentTopicPropertyID := '';
  FPendingTopicHTML := '';
  FPendingTopicEntryID := '';
  ClearTopicEntryEditor;
  btnAddAssocTable.Enabled := False;
  wbDisplayPrior.Navigate('about:blank');
  wbShowCurated.Navigate('about:blank');
  DisplayTopicDataHTML;
  UpdatePushSyncButton;
end;

procedure TfrmTopics.ClearTopicList;
begin
  lvTopics.Items.Clear;
end;

procedure TfrmTopics.ClearTopicEntryEditor;
var
  WebDocument: IHTMLDocument2;
begin
  FEditingTopicEntryFMDate := '';
  FNewTopicEntry := False;
  lblFMDT.Caption := '';
  btnCancel.Enabled := False;
  btnSave.Enabled := False;
  btnNewFMDTEntry.Enabled := FCurrentTopicPropertyID <> '';
  btnNewTopic.Enabled := Patient.DFN <> '';
  SetTopicEditorEditable(False);
  if not Assigned(wbEnterNew.Document) then begin
    Exit;
  end;
  WebDocument := wbEnterNew.Document as IHTMLDocument2;
  if (WebDocument <> nil) and (WebDocument.body <> nil) then begin
    WebDocument.body.innerHTML := '';
  end;
end;

procedure TfrmTopics.RebuildTopicList;
var
  CurrentTopicItem: TListItem;
  Index: Integer;
  ListItem: TListItem;
  SelectedPropertyIDs: TStringList;
  TopicData: TTopicListItemData;
begin
  SelectedPropertyIDs := TStringList.Create;
  try
    for Index := 0 to lvTopics.Items.Count - 1 do begin
      if lvTopics.Items[Index].Selected and (lvTopics.Items[Index].Data <> nil) then begin
        SelectedPropertyIDs.Add(TTopicListItemData(lvTopics.Items[Index].Data).PropertyID);
      end;
    end;
    CurrentTopicItem := nil;
    lvTopics.Items.BeginUpdate;
    try
      ClearTopicList;
      for Index := 0 to FTopicListModel.Count - 1 do begin
        TopicData := TTopicListItemData(FTopicListModel.Objects[Index]);
        TopicData.Hidden := NormalizeTopicHidden(TopicData.Hidden);
        if (not cbShowHidden.Checked) and (TopicData.Hidden = 'YES') then begin
          Continue;
        end;
        if not TopicMatchesUserDataFilter(TopicData.UserData) then begin
          Continue;
        end;
        ListItem := lvTopics.Items.Add;
        ListItem.Data := TopicData;
        if TopicData.PendingNoteChanges <> [] then begin
          ListItem.Caption := TOPIC_PENDING_SYNC_GLYPH + ' ' + TopicData.TopicName;
        end else begin
          ListItem.Caption := TopicData.TopicName;
        end;
        if TopicData.LastUsedFMDate > 0 then begin
          ListItem.SubItems.Add(FormatFMDateTime('mm/dd/yy', TopicData.LastUsedFMDate))
        end else begin
          ListItem.SubItems.Add('');
        end;
        ListItem.SubItems.Add(TopicData.UserData);
        ListItem.SubItems.Add(TopicData.Hidden);
        ListItem.Selected := SelectedPropertyIDs.IndexOf(TopicData.PropertyID) >= 0;
        if TopicData.PropertyID = FCurrentTopicPropertyID then begin
          CurrentTopicItem := ListItem;
        end;
      end;
      lvTopics.CustomSort(nil, 0);
      if CurrentTopicItem <> nil then begin
        CurrentTopicItem.Selected := True;
        CurrentTopicItem.Focused := True;
      end;
    finally
      lvTopics.Items.EndUpdate;
    end;
    if (FCurrentTopicPropertyID <> '') and (CurrentTopicItem = nil) then begin
      FCurrentTopicEntries.Clear;
      FTopicDataTables.Clear;
      FCurrentTopicName := '';
      FCurrentTopicPropertyID := '';
      FPendingTopicHTML := '';
      FPendingTopicEntryID := '';
      wbDisplayPrior.Navigate('about:blank');
      wbShowCurated.Navigate('about:blank');
      btnAddAssocTable.Enabled := False;
      DisplayTopicDataHTML;
    end;
  finally
    SelectedPropertyIDs.Free;
  end;
end;

procedure TfrmTopics.RestoreTopicListLayout;
var
  ColumnIndex: Integer;
  SortKey: TTopicSortKey;
  SortKeyText: string;
  SortKeyValues: TStringList;
  ValueIndex: Integer;
begin
  for ColumnIndex := 0 to lvTopics.Columns.Count - 1 do begin
    if ColumnIndex = TOPIC_HIDDEN_COLUMN then begin
      FTopicHiddenColumnWidth := uTMGOptions.ReadInteger(TOPICS_LIST_COLUMN_WIDTH_KEY_PREFIX + IntToStr(ColumnIndex), lvTopics.Columns[ColumnIndex].Width);
      lvTopics.Columns[ColumnIndex].Width := FTopicHiddenColumnWidth;
    end else begin
      lvTopics.Columns[ColumnIndex].Width := uTMGOptions.ReadInteger(TOPICS_LIST_COLUMN_WIDTH_KEY_PREFIX + IntToStr(ColumnIndex), lvTopics.Columns[ColumnIndex].Width);
    end;
  end;
  FTopicSortKeys.Clear;
  SortKeyValues := TStringList.Create;
  try
    SortKeyValues.StrictDelimiter := True;
    SortKeyValues.Delimiter := ';';
    SortKeyText := uTMGOptions.ReadString(TOPICS_LIST_SORT_KEY, '');
    if SortKeyText <> '' then begin
      SortKeyValues.DelimitedText := SortKeyText;
    end;
    for ValueIndex := 0 to SortKeyValues.Count - 1 do begin
      SortKey.ColumnIndex := StrToIntDef(Piece(SortKeyValues[ValueIndex], ',', 1), -1);
      SortKey.Ascending := SameText(Piece(SortKeyValues[ValueIndex], ',', 2), 'A');
      if (SortKey.ColumnIndex >= 0) and (SortKey.ColumnIndex < lvTopics.Columns.Count) and (FindTopicSortKey(SortKey.ColumnIndex) < 0) then begin
        FTopicSortKeys.Add(SortKey);
      end;
    end;
  finally
    SortKeyValues.Free;
  end;
  if FTopicSortKeys.Count = 0 then begin
    SortKey.ColumnIndex := 0;
    SortKey.Ascending := True;
    FTopicSortKeys.Add(SortKey);
  end;
  UpdateTopicListHiddenColumn;
end;

procedure TfrmTopics.SaveTopicListLayout;
var
  ColumnIndex: Integer;
  SortKey: TTopicSortKey;
  SortKeyIndex: Integer;
  SortKeyValues: TStringList;
begin
  if not FTopicsLoaded then begin
    Exit;
  end;
  for ColumnIndex := 0 to lvTopics.Columns.Count - 1 do begin
    if ColumnIndex = TOPIC_HIDDEN_COLUMN then begin
      uTMGOptions.WriteInteger(TOPICS_LIST_COLUMN_WIDTH_KEY_PREFIX + IntToStr(ColumnIndex), FTopicHiddenColumnWidth)
    end else begin
      uTMGOptions.WriteInteger(TOPICS_LIST_COLUMN_WIDTH_KEY_PREFIX + IntToStr(ColumnIndex), lvTopics.Columns[ColumnIndex].Width);
    end;
  end;
  SortKeyValues := TStringList.Create;
  try
    SortKeyValues.StrictDelimiter := True;
    SortKeyValues.Delimiter := ';';
    for SortKeyIndex := 0 to FTopicSortKeys.Count - 1 do begin
      SortKey := FTopicSortKeys[SortKeyIndex];
      if SortKey.Ascending then begin
        SortKeyValues.Add(IntToStr(SortKey.ColumnIndex) + ',A')
      end else begin
        SortKeyValues.Add(IntToStr(SortKey.ColumnIndex) + ',D');
      end;
    end;
    uTMGOptions.WriteString(TOPICS_LIST_SORT_KEY, SortKeyValues.DelimitedText);
  finally
    SortKeyValues.Free;
  end;
end;

function TfrmTopics.TopicMatchesUserDataFilter(const UserData: string): Boolean;
var
  FilterWords: TStringList;
  Index: Integer;
  UpperUserData: string;
begin
  Result := True;
  if Trim(edtFilter.Text) = '' then begin
    Exit;
  end;
  FilterWords := TStringList.Create;
  try
    ExtractStrings([' '], [], PChar(edtFilter.Text), FilterWords);
    UpperUserData := UpperCase(UserData);
    for Index := 0 to FilterWords.Count - 1 do begin
      if Pos(UpperCase(FilterWords[Index]), UpperUserData) = 0 then begin
        Result := False;
        Exit;
      end;
    end;
  finally
    FilterWords.Free;
  end;
end;

procedure TfrmTopics.DisplayPage;
begin
  inherited DisplayPage;
  UpdatePushSyncButton;
  if InitPatient then begin
    RefreshTopicList;
  end;
end;

procedure TfrmTopics.InitializeTopicListColumns;
var
  Column: TListColumn;
begin
  lvTopics.ViewStyle := vsReport;
  if lvTopics.Columns.Count > 0 then begin
    Exit;
  end;

  Column := lvTopics.Columns.Add;
  Column.Caption := 'Topic';
  Column.Width := 130;
  Column := lvTopics.Columns.Add;
  Column.Caption := 'Last Used';
  Column.Width := 65;
  Column := lvTopics.Columns.Add;
  Column.Caption := 'User Data';
  Column.Width := 90;
  Column := lvTopics.Columns.Add;
  Column.Caption := 'Hidden';
  Column.Width := TOPIC_HIDDEN_COLUMN_WIDTH;
end;

procedure TfrmTopics.cbShowHiddenClick(Sender: TObject);
begin
  uTMGOptions.WriteBool(TOPICS_SHOW_HIDDEN_KEY, cbShowHidden.Checked);
  UpdateTopicListHiddenColumn;
  SaveTopicListLayout;
  RebuildTopicList;
end;

procedure TfrmTopics.btnClearFilterClick(Sender: TObject);
begin
  edtFilter.Text := '';
  edtFilter.SetFocus;
end;

procedure TfrmTopics.edtFilterChange(Sender: TObject);
begin
  btnClearFilter.Enabled := edtFilter.Text <> '';
  timTopicFilter.Enabled := False;
  timTopicFilter.Enabled := True;
end;

procedure TfrmTopics.timTopicFilterTimer(Sender: TObject);
begin
  timTopicFilter.Enabled := False;
  RebuildTopicList;
end;

procedure TfrmTopics.EditTopicUserData(ListItem: TListItem);
var
  ApplyToSelection: Boolean;
  CurrentUserData: string;
  HasChanged: Boolean;
  Index: Integer;
  NewUserData: string;
  SelectedCount: Integer;
  TopicData: TTopicListItemData;
  function FindModelTopicData(const PropertyID: string): TTopicListItemData;
  var
    ModelIndex: Integer;
  begin
    Result := nil;
    for ModelIndex := 0 to FTopicListModel.Count - 1 do begin
      if TTopicListItemData(FTopicListModel.Objects[ModelIndex]).PropertyID = PropertyID then begin
        Result := TTopicListItemData(FTopicListModel.Objects[ModelIndex]);
        Exit;
      end;
    end;
  end;
  procedure ApplyUserData(AListItem: TListItem);
  var
    ATopicData: TTopicListItemData;
    ModelTopicData: TTopicListItemData;
  begin
    if AListItem.Data = nil then begin
      Exit;
    end;
    ATopicData := TTopicListItemData(AListItem.Data);
    ModelTopicData := FindModelTopicData(ATopicData.PropertyID);
    if ModelTopicData <> nil then begin
      ATopicData := ModelTopicData;
    end;
    if ATopicData.UserData = NewUserData then begin
      Exit;
    end;
    ATopicData.UserData := NewUserData;
    AListItem.Data := ATopicData;
    while AListItem.SubItems.Count <= TOPIC_USER_DATA_SUBITEM do begin
      AListItem.SubItems.Add('');
    end;
    AListItem.SubItems[TOPIC_USER_DATA_SUBITEM] := ATopicData.UserData;
    QueueTopicChange(ATopicData, False, True);
    HasChanged := True;
  end;
begin
  if (ListItem = nil) or (ListItem.Data = nil) then begin
    Exit;
  end;
  SelectedCount := 0;
  for Index := 0 to lvTopics.Items.Count - 1 do begin
    if lvTopics.Items[Index].Selected then begin
      Inc(SelectedCount);
    end;
  end;
  ApplyToSelection := ListItem.Selected and (SelectedCount > 1);
  TopicData := FindModelTopicData(TTopicListItemData(ListItem.Data).PropertyID);
  if TopicData = nil then begin
    TopicData := TTopicListItemData(ListItem.Data);
  end;
  CurrentUserData := TopicData.UserData;
  if ApplyToSelection then begin
    for Index := 0 to lvTopics.Items.Count - 1 do begin
      if lvTopics.Items[Index].Selected and (lvTopics.Items[Index].Data <> nil) then begin
        TopicData := TTopicListItemData(lvTopics.Items[Index].Data);
        if TopicData.UserData <> CurrentUserData then begin
          MessageDlg('Selected topics have mixed User Data values and cannot be edited together.', mtInformation, [mbOK], 0);
          Exit;
        end;
      end;
    end;
  end;
  NewUserData := CurrentUserData;
  if not InputQuery('Edit Topic User Data', 'User Data:', NewUserData) then begin
    Exit;
  end;
  if Length(NewUserData) > 64 then begin
    MessageDlg('User Data is limited to 64 characters.', mtInformation, [mbOK], 0);
    Exit;
  end;
  HasChanged := False;
  lvTopics.Items.BeginUpdate;
  try
    if ApplyToSelection then begin
      for Index := 0 to lvTopics.Items.Count - 1 do begin
        if lvTopics.Items[Index].Selected then begin
          ApplyUserData(lvTopics.Items[Index]);
        end;
      end;
    end else begin
      ApplyUserData(ListItem);
    end;
  finally
    lvTopics.Items.EndUpdate;
  end;
  if HasChanged then begin
    RebuildTopicList;
  end;
end;

procedure TfrmTopics.HideTopicsMenuItemClick(Sender: TObject);
var
  Index: Integer;
  ListItem: TListItem;
  TopicData: TTopicListItemData;
begin
  lvTopics.Items.BeginUpdate;
  try
    for Index := 0 to lvTopics.Items.Count - 1 do begin
      ListItem := lvTopics.Items[Index];
      if not ListItem.Selected or (ListItem.Data = nil) then begin
        Continue;
      end;
      TopicData := TTopicListItemData(ListItem.Data);
      TopicData.Hidden := NormalizeTopicHidden(TopicData.Hidden);
      if TopicData.Hidden <> 'YES' then begin
        ToggleTopicHidden(ListItem);
      end;
    end;
  finally
    lvTopics.Items.EndUpdate;
  end;
  RebuildTopicList;
end;

procedure TfrmTopics.MergeTopicsMenuItemClick(Sender: TObject);
begin
  MergeSelectedTopics;
end;

procedure TfrmTopics.RenameTopicMenuItemClick(Sender: TObject);
begin
  RenameSelectedTopic;
end;

procedure TfrmTopics.DeleteTopicMenuItemClick(Sender: TObject);
begin
  DeleteSelectedTopic;
end;

procedure TfrmTopics.DeleteSelectedTopic;
var
  ListItem: TListItem;
  Status: string;
  TopicData: TTopicListItemData;
begin
  ListItem := lvTopics.Selected;
  if (ListItem = nil) or (ListItem.Data = nil) then begin
    Exit;
  end;
  TopicData := TTopicListItemData(ListItem.Data);
  if MessageDlg('Delete topic ''' + TopicData.TopicName + '''?' + sLineBreak + sLineBreak +
    'This cannot be undone!', mtWarning, [mbYes, mbNo], 0) <> mrYes then begin
    Exit;
  end;
  Status := DeleteTopic(TopicData.PropertyID);
  if Piece(Status, '^', 1) <> '1' then begin
    MessageDlg('The topic could not be deleted.' + sLineBreak + Piece(Status, '^', 2), mtError, [mbOK], 0);
    Exit;
  end;
  FTopicChanges.Remove(TopicData.PropertyID);
  if FTopicChanges.Count = 0 then begin
    timSaveTopicChanges.Enabled := False;
  end;
  RefreshTopicList;
end;

procedure TfrmTopics.RenameSelectedTopic;
var
  Index: Integer;
  ListItem: TListItem;
  NewTopicName: string;
  Status: string;
  TopicData: TTopicListItemData;
begin
  ListItem := lvTopics.Selected;
  if (ListItem = nil) or (ListItem.Data = nil) then begin
    Exit;
  end;
  TopicData := TTopicListItemData(ListItem.Data);
  NewTopicName := TopicData.TopicName;
  if not InputQuery('Rename Topic', 'Topic name:', NewTopicName) then begin
    Exit;
  end;
  NewTopicName := Trim(NewTopicName);
  if NewTopicName = '' then begin
    MessageDlg('A topic name is required.', mtInformation, [mbOK], 0);
    Exit;
  end;
  if Pos('^', NewTopicName) > 0 then begin
    MessageDlg('A topic name cannot contain ^.', mtInformation, [mbOK], 0);
    Exit;
  end;
  if Length(NewTopicName) > 180 then begin
    MessageDlg('A topic name is limited to 180 characters.', mtInformation, [mbOK], 0);
    Exit;
  end;
  if NewTopicName = TopicData.TopicName then begin
    Exit;
  end;
  Status := RenameTopic(TopicData.PropertyID, NewTopicName);
  if Piece(Status, '^', 1) <> '1' then begin
    MessageDlg('The topic could not be renamed.' + sLineBreak + Piece(Status, '^', 2), mtError, [mbOK], 0);
    Exit;
  end;
  TopicData.TopicName := NewTopicName;
  ListItem.Caption := NewTopicName;
  for Index := 0 to FTopicListModel.Count - 1 do begin
    if FTopicListModel.Objects[Index] = TopicData then begin
      FTopicListModel.Strings[Index] := NewTopicName;
      Break;
    end;
  end;
  if FCurrentTopicPropertyID = TopicData.PropertyID then begin
    FCurrentTopicName := NewTopicName;
    DisplayTopicHTML(BuildTopicHTML(FCurrentTopicEntries, FCurrentTopicName));
  end;
  RebuildTopicList;
end;

procedure TfrmTopics.MergeSelectedTopics;
var
  CancelButton: TButton;
  DestinationItem: TListItem;
  DestinationTopicData: TTopicListItemData;
  Dialog: TForm;
  Index: Integer;
  ListBox: TListBox;
  OKButton: TButton;
  PromptLabel: TLabel;
  SourcePropertyIDs: TStringList;
  Status: string;
  TopicData: TTopicListItemData;
begin
  Dialog := TForm.Create(Self);
  try
    Dialog.BorderStyle := bsDialog;
    Dialog.Caption := 'Merge Topics';
    Dialog.ClientHeight := 275;
    Dialog.ClientWidth := 420;
    Dialog.Position := poOwnerFormCenter;

    PromptLabel := TLabel.Create(Dialog);
    PromptLabel.Parent := Dialog;
    PromptLabel.AutoSize := False;
    PromptLabel.SetBounds(12, 12, 396, 38);
    PromptLabel.Caption := 'Select the destination topic. The other selected topics will be merged into it.';
    PromptLabel.WordWrap := True;

    ListBox := TListBox.Create(Dialog);
    ListBox.Parent := Dialog;
    ListBox.SetBounds(12, 58, 396, 165);
    ListBox.MultiSelect := False;
    for Index := 0 to lvTopics.Items.Count - 1 do begin
      if lvTopics.Items[Index].Selected and (lvTopics.Items[Index].Data <> nil) then begin
        TopicData := TTopicListItemData(lvTopics.Items[Index].Data);
        ListBox.Items.AddObject(TopicData.TopicName, lvTopics.Items[Index]);
      end;
    end;
    if ListBox.Items.Count < 2 then begin
      Exit;
    end;
    ListBox.ItemIndex := 0;

    OKButton := TButton.Create(Dialog);
    OKButton.Parent := Dialog;
    OKButton.Caption := 'OK';
    OKButton.Default := True;
    OKButton.ModalResult := mrOK;
    OKButton.SetBounds(236, 235, 80, 28);

    CancelButton := TButton.Create(Dialog);
    CancelButton.Parent := Dialog;
    CancelButton.Caption := 'Cancel';
    CancelButton.Cancel := True;
    CancelButton.ModalResult := mrCancel;
    CancelButton.SetBounds(328, 235, 80, 28);

    if Dialog.ShowModal <> mrOK then begin
      Exit;
    end;
    if ListBox.ItemIndex < 0 then begin
      Exit;
    end;
    DestinationItem := TListItem(ListBox.Items.Objects[ListBox.ItemIndex]);
    if DestinationItem.Data = nil then begin
      Exit;
    end;
    DestinationTopicData := TTopicListItemData(DestinationItem.Data);

    SourcePropertyIDs := TStringList.Create;
    try
      for Index := 0 to lvTopics.Items.Count - 1 do begin
        if lvTopics.Items[Index].Selected and (lvTopics.Items[Index] <> DestinationItem) and (lvTopics.Items[Index].Data <> nil) then begin
          TopicData := TTopicListItemData(lvTopics.Items[Index].Data);
          SourcePropertyIDs.Add(TopicData.PropertyID);
        end;
      end;
      if SourcePropertyIDs.Count = 0 then begin
        Exit;
      end;
      if MessageDlg(Format('Merge %d record(s) into record ''%s''?' + sLineBreak + sLineBreak + 'NOTE: This cannot be undone!',
        [SourcePropertyIDs.Count, DestinationTopicData.TopicName]), mtWarning, [mbOK, mbCancel], 0) <> mrOK then begin
        Exit;
      end;

      timSaveTopicChanges.Enabled := False;
      if FTopicChanges.Count > 0 then begin
        Status := SaveTopicChanges(FTopicChanges);
        if Piece(Status, '^', 1) <> '1' then begin
          MessageDlg('Pending topic changes could not be saved. The merge was not performed.' + sLineBreak + Piece(Status, '^', 2), mtError, [mbOK], 0);
          Exit;
        end;
        FTopicChanges.Clear;
      end;

      if SourcePropertyIDs.Count = 1 then begin
        Status := MergeTopics(SourcePropertyIDs[0], DestinationTopicData.PropertyID);
      end else begin
        Status := MergeTopics(SourcePropertyIDs, DestinationTopicData.PropertyID);
      end;
      if Piece(Status, '^', 1) = '1' then begin
        RefreshTopicList;
      end else begin
        MessageDlg('The topics could not be merged.' + sLineBreak + Piece(Status, '^', 2), mtError, [mbOK], 0);
      end;
    finally
      SourcePropertyIDs.Free;
    end;
  finally
    Dialog.Free;
  end;
end;

procedure TfrmTopics.TopicListPopupMenuPopup(Sender: TObject);
var
  HasTopicToHide: Boolean;
  Index: Integer;
  SelectedCount: Integer;
  TopicData: TTopicListItemData;
begin
  HasTopicToHide := False;
  SelectedCount := 0;
  for Index := 0 to lvTopics.Items.Count - 1 do begin
    if lvTopics.Items[Index].Selected then begin
      Inc(SelectedCount);
      if lvTopics.Items[Index].Data <> nil then begin
        TopicData := TTopicListItemData(lvTopics.Items[Index].Data);
        TopicData.Hidden := NormalizeTopicHidden(TopicData.Hidden);
        if TopicData.Hidden <> 'YES' then begin
          HasTopicToHide := True;
        end;
      end;
    end;
  end;
  if SelectedCount = 1 then begin
    FHideTopicsMenuItem.Caption := 'Hide topic'
  end else begin
    FHideTopicsMenuItem.Caption := 'Hide selected topics';
  end;
  FHideTopicsMenuItem.Enabled := HasTopicToHide;
  FHideTopicsMenuItem.Visible := not cbShowHidden.Checked;
  FRenameTopicMenuItem.Visible := SelectedCount = 1;
  FRenameTopicMenuItem.Enabled := SelectedCount = 1;
  FDeleteTopicMenuItem.Visible := SelectedCount = 1;
  FDeleteTopicMenuItem.Enabled := SelectedCount = 1;
  FMergeTopicsMenuItem.Visible := SelectedCount > 1;
  FMergeTopicsMenuItem.Enabled := SelectedCount > 1;
end;

procedure TfrmTopics.UpdateTopicListHiddenColumn;
begin
  if lvTopics.Columns.Count <= TOPIC_HIDDEN_COLUMN then begin
    Exit;
  end;
  if cbShowHidden.Checked then begin
    lvTopics.Columns[TOPIC_HIDDEN_COLUMN].Width := FTopicHiddenColumnWidth
  end else begin
    if lvTopics.Columns[TOPIC_HIDDEN_COLUMN].Width > 0 then begin
      FTopicHiddenColumnWidth := lvTopics.Columns[TOPIC_HIDDEN_COLUMN].Width;
    end;
    lvTopics.Columns[TOPIC_HIDDEN_COLUMN].Width := 0;
  end;
  if Assigned(FTopicListPopupMenu) then begin
    lvTopics.PopupMenu := FTopicListPopupMenu;
  end;
end;

procedure TfrmTopics.RefreshTopicList;
var
  TopicListData: TStringList;
  TopicData: TTopicListItemData;
  ListItem: TListItem;
  Index: Integer;
  Status: string;
begin
  ClearTopicList;
  FTopicListModel.Clear;
  FCurrentTopicEntries.Clear;
  FTopicDataTables.Clear;
  FCurrentTopicName := '';
  FCurrentTopicPropertyID := '';
  FPendingTopicHTML := '';
  FPendingTopicEntryID := '';
  ClearTopicEntryEditor;
  btnAddAssocTable.Enabled := False;
  wbDisplayPrior.Navigate('about:blank');
  wbShowCurated.Navigate('about:blank');
  DisplayTopicDataHTML;
  if Patient.DFN = '' then begin
    Exit;
  end;

  TopicListData := TStringList.Create;
  try
    Status := TopicList(TopicListData);
    if Piece(Status, '^', 1) <> '1' then begin
      Exit;
    end;

    lvTopics.Items.BeginUpdate;
    try
      for Index := 0 to TopicListData.Count - 1 do begin
        TopicData := TTopicListItemData.Create;
        TopicData.PropertyID := Piece(TopicListData[Index], '^', 1);
        TopicData.LastUsedFMDate := MakeFMDateTime(Piece(TopicListData[Index], '^', 2));
        TopicData.TopicName := Piece(TopicListData[Index], '^', 3);
        TopicData.Hidden := NormalizeTopicHidden(Piece(TopicListData[Index], '^', 4));
        TopicData.UserData := Piece(TopicListData[Index], '^', 5);
        if not FPendingTopicNoteChanges.TryGetValue(TopicData.PropertyID, TopicData.PendingNoteChanges) then begin
          TopicData.PendingNoteChanges := [];
        end;
        FTopicListModel.AddObject(TopicData.TopicName, TopicData);
        ListItem := lvTopics.Items.Add;
        ListItem.Data := TopicData;
        if TopicData.PendingNoteChanges <> [] then begin
          ListItem.Caption := TOPIC_PENDING_SYNC_GLYPH + ' ' + TopicData.TopicName;
        end else begin
          ListItem.Caption := TopicData.TopicName;
        end;
        if TopicData.LastUsedFMDate > 0 then begin
          ListItem.SubItems.Add(FormatFMDateTime('mm/dd/yy', TopicData.LastUsedFMDate))
        end else begin
          ListItem.SubItems.Add('');
        end;
        ListItem.SubItems.Add(TopicData.UserData);
        ListItem.SubItems.Add(TopicData.Hidden);
      end;
    finally
      lvTopics.Items.EndUpdate;
    end;
    lvTopics.CustomSort(nil, 0);
    RebuildTopicList;
    if lvTopics.Items.Count > 0 then begin
      lvTopics.Items[0].Selected := True;
      lvTopics.Items[0].Focused := True;
      lvTopicsClick(lvTopics);
    end;
  finally
    TopicListData.Free;
  end;
end;

function TfrmTopics.FindTopicSortKey(ColumnIndex: Integer): Integer;
var
  SortKeyIndex: Integer;
begin
  Result := -1;
  for SortKeyIndex := 0 to FTopicSortKeys.Count - 1 do begin
    if FTopicSortKeys[SortKeyIndex].ColumnIndex = ColumnIndex then begin
      Result := SortKeyIndex;
      Exit;
    end;
  end;
end;

function TfrmTopics.CompareTopicListItems(Item1, Item2: TListItem; ColumnIndex: Integer): Integer;
var
  TopicData1: TTopicListItemData;
  TopicData2: TTopicListItemData;
begin
  if ColumnIndex = 0 then begin
    TopicData1 := TTopicListItemData(Item1.Data);
    TopicData2 := TTopicListItemData(Item2.Data);
    Result := CompareText(TopicData1.TopicName, TopicData2.TopicName);
  end else begin
    if ColumnIndex = 1 then begin
      TopicData1 := TTopicListItemData(Item1.Data);
      TopicData2 := TTopicListItemData(Item2.Data);
      if TopicData1.LastUsedFMDate < TopicData2.LastUsedFMDate then begin
        Result := -1;
      end else begin
        if TopicData1.LastUsedFMDate > TopicData2.LastUsedFMDate then begin
          Result := 1;
        end else begin
          Result := 0;
        end;
      end;
    end else begin
      Result := CompareText(Item1.SubItems[ColumnIndex - 1], Item2.SubItems[ColumnIndex - 1]);
    end;
  end;
end;

procedure TfrmTopics.lvTopicsColumnClick(Sender: TObject; Column: TListColumn);
var
  SortKey: TTopicSortKey;
  SortKeyIndex: Integer;
begin
  SortKeyIndex := FindTopicSortKey(Column.Index);
  if GetKeyState(VK_CONTROL) < 0 then begin
    if SortKeyIndex >= 0 then begin
      SortKey := FTopicSortKeys[SortKeyIndex];
      SortKey.Ascending := not SortKey.Ascending;
      FTopicSortKeys[SortKeyIndex] := SortKey;
    end else begin
      SortKey.ColumnIndex := Column.Index;
      SortKey.Ascending := True;
      FTopicSortKeys.Add(SortKey);
    end;
  end else begin
    if (SortKeyIndex = 0) and (FTopicSortKeys.Count = 1) then begin
      SortKey := FTopicSortKeys[0];
      SortKey.Ascending := not SortKey.Ascending;
      FTopicSortKeys[0] := SortKey;
    end else begin
      FTopicSortKeys.Clear;
      SortKey.ColumnIndex := Column.Index;
      SortKey.Ascending := True;
      FTopicSortKeys.Add(SortKey);
    end;
  end;
  lvTopics.CustomSort(nil, 0);
  UpdateTopicListSortIndicators;
  SaveTopicListLayout;
end;

procedure TfrmTopics.lvTopicsCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if cdsSelected in State then begin
    Sender.Canvas.Brush.Color := RGB(214, 232, 246);
    Sender.Canvas.Font.Color := clNavy;
  end else begin
    Sender.Canvas.Brush.Color := TopicListCellBackgroundColor(0);
    Sender.Canvas.Font.Color := clWindowText;
  end;
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color + 1;
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color - 1;
end;

procedure TfrmTopics.lvTopicsCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if cdsSelected in State then begin
    Sender.Canvas.Brush.Color := RGB(214, 232, 246);
    Sender.Canvas.Font.Color := clNavy;
  end else begin
    Sender.Canvas.Brush.Color := TopicListCellBackgroundColor(SubItem);
    Sender.Canvas.Font.Color := clWindowText;
  end;
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color + 1;
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color - 1;
end;

function TfrmTopics.TopicListCellBackgroundColor(ColumnIndex: Integer): TColor;
begin
  if FindTopicSortKey(ColumnIndex) >= 0 then begin
    Result := RGB(232, 242, 252);
  end else if FTopicsLeftOpen then begin
    Result := clWhite;
  end else begin
    Result := clCream;
  end;
end;

procedure TfrmTopics.UpdateTopicsRightColors;
var
  WebDocument: IHTMLDocument2;
begin
  if FTopicsRightOpen then begin
    pnlTopicsRight.Color := clWhite;
    pnlRightFooter.Color := clWhite;
  end else begin
    pnlTopicsRight.Color := clCream;
    pnlRightFooter.Color := clCream;
  end;
  if not Assigned(wbTopicData.Document) then begin
    Exit;
  end;
  WebDocument := wbTopicData.Document as IHTMLDocument2;
  if (WebDocument = nil) or (WebDocument.body = nil) then begin
    Exit;
  end;
  if FTopicsRightOpen then begin
    WebDocument.body.style.backgroundColor := '#FFFFFF';
  end else begin
    WebDocument.body.style.backgroundColor := '#FFFBF0';
  end;
end;

procedure TfrmTopics.UpdateTopicListColors;
begin
  if FTopicsLeftOpen then begin
    lvTopics.Color := clWhite;
  end else begin
    lvTopics.Color := clCream;
  end;
  lvTopics.Invalidate;
end;

procedure TfrmTopics.UpdateTopicListSortIndicators;
var
  ColumnIndex: Integer;
  SortGlyph: string;
  SortKey: TTopicSortKey;
  SortKeyIndex: Integer;
begin
  for ColumnIndex := 0 to lvTopics.Columns.Count - 1 do begin
    lvTopics.Columns[ColumnIndex].Caption := TOPIC_COLUMN_CAPTIONS[ColumnIndex];
    SortKeyIndex := FindTopicSortKey(ColumnIndex);
    if SortKeyIndex >= 0 then begin
      SortKey := FTopicSortKeys[SortKeyIndex];
      if SortKey.Ascending then begin
        SortGlyph := TOPIC_SORT_ASCENDING_GLYPH
      end else begin
        SortGlyph := TOPIC_SORT_DESCENDING_GLYPH;
      end;
      lvTopics.Columns[ColumnIndex].Caption := IntToStr(SortKeyIndex + 1) + SortGlyph + ' ' + lvTopics.Columns[ColumnIndex].Caption;
    end;
  end;
  lvTopics.Invalidate;
end;

procedure TfrmTopics.lvTopicsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  SortKey: TTopicSortKey;
  SortKeyIndex: Integer;
begin
  Compare := 0;
  for SortKeyIndex := 0 to FTopicSortKeys.Count - 1 do begin
    SortKey := FTopicSortKeys[SortKeyIndex];
    Compare := CompareTopicListItems(Item1, Item2, SortKey.ColumnIndex);
    if not SortKey.Ascending then begin
      Compare := -Compare;
    end;
    if Compare <> 0 then begin
      Exit;
    end;
  end;
  Compare := CompareText(TTopicListItemData(Item1.Data).PropertyID, TTopicListItemData(Item2.Data).PropertyID);
end;

function TfrmTopics.TopicListColumnAt(X: Integer): Integer;
var
  ColumnIndex: Integer;
  ColumnLeft: Integer;
begin
  Result := -1;
  ColumnLeft := 0;
  X := X + GetScrollPos(lvTopics.Handle, SB_HORZ);
  for ColumnIndex := 0 to lvTopics.Columns.Count - 1 do begin
    if (X >= ColumnLeft) and (X < ColumnLeft + lvTopics.Columns[ColumnIndex].Width) then begin
      Result := ColumnIndex;
      Exit;
    end;
    Inc(ColumnLeft, lvTopics.Columns[ColumnIndex].Width);
  end;
end;

function TfrmTopics.TopicListItemAt(X, Y: Integer; out ColumnIndex: Integer): TListItem;
var
  HitTest: TLVHitTestInfo;
begin
  Result := nil;
  ColumnIndex := -1;
  FillChar(HitTest, SizeOf(HitTest), 0);
  HitTest.pt := Point(X, Y);
  if ListView_SubItemHitTest(lvTopics.Handle, @HitTest) < 0 then begin
    Exit;
  end;
  if (HitTest.iItem < 0) or (HitTest.iItem >= lvTopics.Items.Count) then begin
    Exit;
  end;
  Result := lvTopics.Items[HitTest.iItem];
  ColumnIndex := HitTest.iSubItem;
end;

procedure TfrmTopics.QueueTopicChange(TopicData: TTopicListItemData; HiddenChanged, UserDataChanged: Boolean);
var
  TopicChange: TTopicChange;
begin
  if (TopicData = nil) or ((not HiddenChanged) and (not UserDataChanged)) then begin
    Exit;
  end;
  if not FTopicChanges.TryGetValue(TopicData.PropertyID, TopicChange) then begin
    TopicChange := TTopicChange.Create;
    TopicChange.PropertyID := TopicData.PropertyID;
    FTopicChanges.Add(TopicData.PropertyID, TopicChange);
  end;
  if HiddenChanged then begin
    TopicChange.HiddenChanged := True;
    TopicChange.Hidden := TopicData.Hidden;
  end;
  if UserDataChanged then begin
    TopicChange.UserDataChanged := True;
    TopicChange.UserData := TopicData.UserData;
  end;
  RestartTopicSaveTimer;
end;

procedure TfrmTopics.QueueTopicEntryChange(const PropertyID, EntryFMDate, Hidden, UserData: string; HiddenChanged, UserDataChanged: Boolean);
var
  TopicChange: TTopicChange;
  EntryChange: TTopicEntryChange;
begin
  if (PropertyID = '') or (EntryFMDate = '') or ((not HiddenChanged) and (not UserDataChanged)) then begin
    Exit;
  end;
  if not FTopicChanges.TryGetValue(PropertyID, TopicChange) then begin
    TopicChange := TTopicChange.Create;
    TopicChange.PropertyID := PropertyID;
    FTopicChanges.Add(PropertyID, TopicChange);
  end;
  if not TopicChange.EntryChanges.TryGetValue(EntryFMDate, EntryChange) then begin
    EntryChange := TTopicEntryChange.Create;
    TopicChange.EntryChanges.Add(EntryFMDate, EntryChange);
  end;
  if HiddenChanged then begin
    EntryChange.HiddenChanged := True;
    EntryChange.Hidden := Hidden;
  end;
  if UserDataChanged then begin
    EntryChange.UserDataChanged := True;
    EntryChange.UserData := UserData;
  end;
  RestartTopicSaveTimer;
end;

procedure TfrmTopics.RestartTopicSaveTimer;
begin
  if FTopicChanges.Count = 0 then begin
    Exit;
  end;
  timSaveTopicChanges.Enabled := False;
  timSaveTopicChanges.Enabled := True;
end;

procedure TfrmTopics.ToggleTopicHidden(ListItem: TListItem);
var
  TopicData: TTopicListItemData;
begin
  if ListItem.Data = nil then begin
    Exit;
  end;
  TopicData := TTopicListItemData(ListItem.Data);
  TopicData.Hidden := NormalizeTopicHidden(TopicData.Hidden);
  if TopicData.Hidden = 'YES' then begin
    TopicData.Hidden := ''
  end else begin
    TopicData.Hidden := 'YES';
  end;
  while ListItem.SubItems.Count <= TOPIC_HIDDEN_SUBITEM do begin
    ListItem.SubItems.Add('');
  end;
  ListItem.SubItems[TOPIC_HIDDEN_SUBITEM] := TopicData.Hidden;
  QueueTopicChange(TopicData, True, False);
end;

procedure TfrmTopics.ToggleSelectedTopicsHidden(ListItem: TListItem);
var
  Index: Integer;
  SelectedCount: Integer;
  TargetHidden: string;
  TopicData: TTopicListItemData;
begin
  if (ListItem = nil) or (ListItem.Data = nil) then begin
    Exit;
  end;
  SelectedCount := 0;
  for Index := 0 to lvTopics.Items.Count - 1 do begin
    if lvTopics.Items[Index].Selected then begin
      Inc(SelectedCount);
    end;
  end;
  if (SelectedCount <= 1) or not ListItem.Selected then begin
    ToggleTopicHidden(ListItem);
    RebuildTopicList;
    Exit;
  end;
  TopicData := TTopicListItemData(ListItem.Data);
  TopicData.Hidden := NormalizeTopicHidden(TopicData.Hidden);
  if TopicData.Hidden = 'YES' then begin
    TargetHidden := ''
  end else begin
    TargetHidden := 'YES';
  end;
  lvTopics.Items.BeginUpdate;
  try
    for Index := 0 to lvTopics.Items.Count - 1 do begin
      if lvTopics.Items[Index].Selected and (lvTopics.Items[Index].Data <> nil) then begin
        TopicData := TTopicListItemData(lvTopics.Items[Index].Data);
        TopicData.Hidden := NormalizeTopicHidden(TopicData.Hidden);
        if TopicData.Hidden = TargetHidden then begin
          Continue;
        end;
        TopicData.Hidden := TargetHidden;
        while lvTopics.Items[Index].SubItems.Count <= TOPIC_HIDDEN_SUBITEM do begin
          lvTopics.Items[Index].SubItems.Add('');
        end;
        lvTopics.Items[Index].SubItems[TOPIC_HIDDEN_SUBITEM] := TopicData.Hidden;
        QueueTopicChange(TopicData, True, False);
      end;
    end;
  finally
    lvTopics.Items.EndUpdate;
  end;
  RebuildTopicList;
end;

procedure TfrmTopics.ToggleTopicEntryHidden(const EntryFMDate: string);
var
  EntryHidden: string;
  Index: Integer;
  temp : string;
begin
  if (FCurrentTopicPropertyID = '') or (EntryFMDate = '') then begin
    Exit;
  end;
  for Index := 0 to FCurrentTopicEntries.Count - 1 do begin
    if (Piece(FCurrentTopicEntries[Index], '^', 1) = '1') and (Piece(FCurrentTopicEntries[Index], '^', 2) = EntryFMDate) then begin
      EntryHidden := Piece(FCurrentTopicEntries[Index], '^', 4);
      if EntryHidden <> '' then begin
        EntryHidden := ''
      end else begin
        EntryHidden := 'YES';
      end;
      temp := FCurrentTopicEntries[Index];
      SetPiece(temp, '^', 4, EntryHidden);
      FCurrentTopicEntries[Index] := temp;
      QueueTopicEntryChange(FCurrentTopicPropertyID, EntryFMDate, EntryHidden, Piece(FCurrentTopicEntries[Index], '^', 5), True, False);
      DisplayTopicHTML(BuildTopicHTML(FCurrentTopicEntries, FCurrentTopicName));
      Exit;
    end;
  end;
end;

procedure TfrmTopics.SetTopicEditorFormattingEnabled(Enabled: Boolean);
begin
  btnDelete.Enabled := Enabled;
  cbFontNames.Enabled := Enabled;
  cbFontSize.Enabled := Enabled;
  btnFonts.Enabled := Enabled;
  btnItalic.Enabled := Enabled;
  btnBold.Enabled := Enabled;
  btnUnderline.Enabled := Enabled;
  btnBullets.Enabled := Enabled;
  btnNumbers.Enabled := Enabled;
  btnLeftAlign.Enabled := Enabled;
  btnCenterAlign.Enabled := Enabled;
  btnRightAlign.Enabled := Enabled;
  btnMoreIndent.Enabled := Enabled;
  btnLessIndent.Enabled := Enabled;
  btnShiftEnter.Enabled := Enabled;
  btnTextColor.Enabled := Enabled;
  btnBackColor.Enabled := Enabled;
  btnImage.Enabled := Enabled;
end;

procedure TfrmTopics.SetTopicEditorEditable(Editable: Boolean);
var
  WebDocument: IHTMLDocument2;
begin
  SetTopicEditorFormattingEnabled(Editable);
  if not Assigned(wbEnterNew.Document) then begin
    Exit;
  end;
  WebDocument := wbEnterNew.Document as IHTMLDocument2;
  if (WebDocument = nil) or (WebDocument.body = nil) then begin
    Exit;
  end;
  if Editable then begin
    WebDocument.body.setAttribute('contentEditable', 'true', 0);
    WebDocument.body.style.backgroundColor := '#FFFFFF';
    WebDocument.execCommand('RespectVisibilityInDesign', False, True);
  end else begin
    WebDocument.body.setAttribute('contentEditable', 'false', 0);
    WebDocument.body.style.backgroundColor := '#FFFBF0';
  end;
end;

procedure TfrmTopics.EditCurrentTopicEntry(const EntryFMDate: string);
var
  EntryDate: TFMDateTime;
  EntryStartIndex: Integer;
  EntryText: TStringList;
  Index: Integer;
  temp : string;
begin
  if (FCurrentTopicPropertyID = '') or (EntryFMDate = '') then begin
    Exit;
  end;
  EntryStartIndex := -1;
  for Index := 0 to FCurrentTopicEntries.Count - 1 do begin
    if (Piece(FCurrentTopicEntries[Index], '^', 1) = '1') and (Piece(FCurrentTopicEntries[Index], '^', 2) = EntryFMDate) then begin
      EntryStartIndex := Index;
      Break;
    end;
  end;
  if EntryStartIndex < 0 then begin
    Exit;
  end;
  EntryText := TStringList.Create;
  try
    Index := EntryStartIndex + 1;
    while (Index < FCurrentTopicEntries.Count) and (Piece(FCurrentTopicEntries[Index], '^', 1) = '2') do begin
      temp := FCurrentTopicEntries[Index];
      temp  := Copy(temp, 3, MaxInt);
      EntryText.Add(temp);
      //EntryText.Add(Copy(FCurrentTopicEntries[Index], 3, MaxInt));
      Inc(Index);
    end;
    if IsHTML(EntryText) then begin
      WBLoadHTML(wbEnterNew, EntryText.Text);
    end else begin
      WBLoadHTML(wbEnterNew, Text2HTML(EntryText));
    end;
    SetTopicEditorEditable(True);
    EntryDate := MakeFMDateTime(EntryFMDate);
    if EntryDate > 0 then begin
      lblFMDT.Caption := FormatDateTime('mmmm d, yyyy h:nn am/pm', FMDateTimeToDateTime(EntryDate));
    end else begin
      lblFMDT.Caption := EntryFMDate;
    end;
    FEditingTopicEntryFMDate := EntryFMDate;
    FNewTopicEntry := False;
    btnCancel.Enabled := True;
    btnSave.Enabled := True;
    btnNewFMDTEntry.Enabled := False;
    btnNewTopic.Enabled := False;
  finally
    EntryText.Free;
  end;
end;

procedure TfrmTopics.btnCancelClick(Sender: TObject);
begin
  ClearTopicEntryEditor;
end;

procedure TfrmTopics.btnNewFMDTEntryClick(Sender: TObject);
var
  EntryDate: TFMDateTime;
  Index: Integer;
begin
  if FCurrentTopicPropertyID = '' then begin
    Exit;
  end;
  if (FEditingTopicEntryFMDate <> '') and
     (MessageDlg('Discard the current topic entry changes?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then begin
    Exit;
  end;
  if Assigned(frmNotes) and frmNotes.InEditMode then begin
    EntryDate := frmNotes.ActiveEditDateTime;
    if EntryDate <= 0 then begin
      MessageDlg('The active note does not have a valid date and time.', mtError, [mbOK], 0);
      Exit;
    end;
  end else begin
    if Encounter.NeedVisitWVerification then begin
      UpdateVisit(Font.Size);
      frmFrame.DisplayEncounterText;
    end;
    if Encounter.NeedVisit then begin
      InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
      Exit;
    end;
    EntryDate := Encounter.DateTime;
    if EntryDate <= 0 then begin
      MessageDlg('The current visit does not have a valid date and time.', mtError, [mbOK], 0);
      Exit;
    end;
  end;
  for Index := 0 to FCurrentTopicEntries.Count - 1 do begin
    if (Piece(FCurrentTopicEntries[Index], '^', 1) = '1') and
       (MakeFMDateTime(Piece(FCurrentTopicEntries[Index], '^', 2)) = EntryDate) then begin
      MessageDlg('This topic already has an entry at the selected date and time.', mtError, [mbOK], 0);
      Exit;
    end;
  end;
  ClearTopicEntryEditor;
  WBLoadHTML(wbEnterNew, '<html><body></body></html>');
  FEditingTopicEntryFMDate := FloatToStr(EntryDate);
  FNewTopicEntry := True;
  lblFMDT.Caption := FormatDateTime('mmmm d, yyyy h:nn am/pm', FMDateTimeToDateTime(EntryDate));
  SetTopicEditorEditable(True);
  btnCancel.Enabled := True;
  btnSave.Enabled := True;
  btnNewFMDTEntry.Enabled := False;
  btnNewTopic.Enabled := False;
end;

procedure TfrmTopics.btnNewTopicClick(Sender: TObject);
var
  Index: Integer;
  ListItem: TListItem;
  NewTopicName: string;
  NewTopicPropertyID: string;
  Status: string;
begin
  if (Patient.DFN = '') or (FEditingTopicEntryFMDate <> '') then begin
    Exit;
  end;
  NewTopicName := '';
  if not InputQuery('New Topic', 'Topic name:', NewTopicName) then begin
    Exit;
  end;
  NewTopicName := Trim(NewTopicName);
  if NewTopicName = '' then begin
    MessageDlg('A topic name is required.', mtInformation, [mbOK], 0);
    Exit;
  end;
  if Pos('^', NewTopicName) > 0 then begin
    MessageDlg('A topic name cannot contain ^.', mtInformation, [mbOK], 0);
    Exit;
  end;
  if Length(NewTopicName) > 180 then begin
    MessageDlg('A topic name is limited to 180 characters.', mtInformation, [mbOK], 0);
    Exit;
  end;
  for Index := 0 to FTopicListModel.Count - 1 do begin
    if SameText(FTopicListModel.Strings[Index], NewTopicName) then begin
      MessageDlg('A topic with this name already exists.', mtInformation, [mbOK], 0);
      Exit;
    end;
  end;
  Status := AddTopic(NewTopicName);
  if Piece(Status, '^', 1) <> '1' then begin
    MessageDlg('The topic could not be created.' + sLineBreak + Piece(Status, '^', 2), mtError, [mbOK], 0);
    Exit;
  end;
  NewTopicPropertyID := Piece(Status, '^', 2);
  if NewTopicPropertyID = '' then begin
    MessageDlg('The topic was created, but its identifier was not returned.', mtError, [mbOK], 0);
    Exit;
  end;
  if edtFilter.Text <> '' then begin
    edtFilter.Text := '';
    timTopicFilter.Enabled := False;
  end;
  RefreshTopicList;
  ListItem := nil;
  for Index := 0 to lvTopics.Items.Count - 1 do begin
    if (lvTopics.Items[Index].Data <> nil) and
       (TTopicListItemData(lvTopics.Items[Index].Data).PropertyID = NewTopicPropertyID) then begin
      ListItem := lvTopics.Items[Index];
      Break;
    end;
  end;
  if ListItem = nil then begin
    MessageDlg('The topic was created, but could not be located in the topic list.', mtError, [mbOK], 0);
    Exit;
  end;
  for Index := 0 to lvTopics.Items.Count - 1 do begin
    lvTopics.Items[Index].Selected := False;
  end;
  ListItem.Selected := True;
  ListItem.Focused := True;
  lvTopicsClick(nil);
  if MessageDlg('Add a new entry to this topic now?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    btnNewFMDTEntryClick(btnNewFMDTEntry);
  end;
end;

procedure TfrmTopics.btnSaveClick(Sender: TObject);
var
  EntryDate: TFMDateTime;
  EntryHTML: string;
  EntryText: TStringList;
  Status: string;
  WasNewEntry: Boolean;
begin
  if (FCurrentTopicPropertyID = '') or (FEditingTopicEntryFMDate = '') then begin
    Exit;
  end;
  if (not FNewTopicEntry) and
     (MessageDlg('Overwrite the existing topic entry text?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then begin
    Exit;
  end;
  EntryDate := MakeFMDateTime(FEditingTopicEntryFMDate);
  if EntryDate <= 0 then begin
    MessageDlg('The topic entry has an invalid FileMan date and cannot be saved.', mtError, [mbOK], 0);
    Exit;
  end;
  WasNewEntry := FNewTopicEntry;
  EntryHTML := '';
  EntryText := TStringList.Create;
  try
    EntryText.Text := GetWebBrowserHTML(wbEnterNew);
    EntryHTML := EntryText.Text;
    if WasNewEntry then begin
      Status := Add1TopicEntry(FCurrentTopicPropertyID, EntryDate, EntryText);
    end else begin
      Status := Set1TopicEntryText(FCurrentTopicPropertyID, EntryDate, EntryText);
    end;
  finally
    EntryText.Free;
  end;
  if Piece(Status, '^', 1) <> '1' then begin
    MessageDlg('The topic entry could not be saved.' + sLineBreak + Piece(Status, '^', 2), mtError, [mbOK], 0);
    Exit;
  end;
  if WasNewEntry then begin
    TrackAddedTopicEntry(FCurrentTopicPropertyID, FCurrentTopicName,
      FEditingTopicEntryFMDate, EntryHTML);
  end else begin
    TrackModifiedTopicEntry(FCurrentTopicPropertyID, FCurrentTopicName,
      FEditingTopicEntryFMDate, EntryHTML);
  end;
  ClearTopicEntryEditor;
  lvTopicsClick(nil);
end;

procedure TfrmTopics.DeleteCurrentTopicEntry(const EntryFMDate: string);
var
  EntryDate: TFMDateTime;
  EntryStartIndex: Integer;
  Index: Integer;
  Status: string;
  TopicChange: TTopicChange;
  WasPendingNewEntry: Boolean;
begin
  if (FCurrentTopicPropertyID = '') or (EntryFMDate = '') then begin
    Exit;
  end;
  EntryStartIndex := -1;
  for Index := 0 to FCurrentTopicEntries.Count - 1 do begin
    if (Piece(FCurrentTopicEntries[Index], '^', 1) = '1') and (Piece(FCurrentTopicEntries[Index], '^', 2) = EntryFMDate) then begin
      EntryStartIndex := Index;
      Break;
    end;
  end;
  if EntryStartIndex < 0 then begin
    Exit;
  end;
  if MessageDlg('Delete this topic entry?' + sLineBreak + sLineBreak + 'This cannot be undone!', mtWarning, [mbYes, mbNo], 0) <> mrYes then begin
    Exit;
  end;
  EntryDate := MakeFMDateTime(EntryFMDate);
  if EntryDate <= 0 then begin
    MessageDlg('The topic entry has an invalid FileMan date and cannot be deleted.', mtError, [mbOK], 0);
    Exit;
  end;
  WasPendingNewEntry := FPendingTopicEntries.ContainsKey(TopicEntryPushKey(FCurrentTopicPropertyID, EntryFMDate));
  Status := Delete1TopicEntry(FCurrentTopicPropertyID, EntryDate);
  if Piece(Status, '^', 1) <> '1' then begin
    MessageDlg('The topic entry could not be deleted.' + sLineBreak + Piece(Status, '^', 2), mtError, [mbOK], 0);
    Exit;
  end;
  RemoveAddedTopicEntry(FCurrentTopicPropertyID, EntryFMDate);
  FModifiedTopicEntries.Remove(TopicEntryPushKey(FCurrentTopicPropertyID, EntryFMDate));
  if not WasPendingNewEntry then begin
    MarkTopicForNoteSync(FCurrentTopicPropertyID, ptncExistingEntry);
    UpdatePushSyncButton;
  end;
  if FTopicChanges.TryGetValue(FCurrentTopicPropertyID, TopicChange) then begin
    TopicChange.EntryChanges.Remove(EntryFMDate);
    if (not TopicChange.HiddenChanged) and (not TopicChange.UserDataChanged) and (TopicChange.EntryChanges.Count = 0) then begin
      FTopicChanges.Remove(FCurrentTopicPropertyID);
    end;
  end;
  Index := EntryStartIndex + 1;
  while (Index < FCurrentTopicEntries.Count) and (Piece(FCurrentTopicEntries[Index], '^', 1) = '2') do begin
    FCurrentTopicEntries.Delete(Index);
  end;
  FCurrentTopicEntries.Delete(EntryStartIndex);
  if FTopicChanges.Count = 0 then begin
    timSaveTopicChanges.Enabled := False;
  end;
  if FEditingTopicEntryFMDate = EntryFMDate then begin
    ClearTopicEntryEditor;
  end;
  FPendingTopicEntryID := '';
  DisplayTopicHTML(BuildTopicHTML(FCurrentTopicEntries, FCurrentTopicName));
end;

procedure TfrmTopics.timSaveTopicChangesTimer(Sender: TObject);
var
  Status: string;
begin
  timSaveTopicChanges.Enabled := False;
  if FTopicChanges.Count = 0 then begin
    Exit;
  end;
  Status := SaveTopicChanges(FTopicChanges);
  if Piece(Status, '^', 1) = '1' then begin
    FTopicChanges.Clear;
  end;
end;

procedure TfrmTopics.lvTopicsWindowProc(var Message: TMessage);
//Using message handler because a native Windows TListView processes its left-button message to select the row before a normal
//  OnMouseDown/OnClick approach can reliably stop it. Intercepting the message lets Hidden toggle while preventing selection.

var
  ColumnIndex: Integer;
  ListItem: TListItem;
  Index: Integer;
  X: Integer;
  Y: Integer;
begin
  if (Message.Msg = WM_NOTIFY) and (Message.LParam <> 0) and (PNMHdr(Message.LParam)^.code = HDN_ENDTRACK) then begin
    FTopicsListViewWindowProc(Message);
    if cbShowHidden.Checked then begin
      FTopicHiddenColumnWidth := lvTopics.Columns[TOPIC_HIDDEN_COLUMN].Width;
    end;
    SaveTopicListLayout;
    Exit;
  end;
  if (Message.Msg = WM_LBUTTONDOWN) or (Message.Msg = WM_LBUTTONDBLCLK) then begin
    X := SmallInt(LoWord(Message.LParam));
    Y := SmallInt(HiWord(Message.LParam));
    ListItem := TopicListItemAt(X, Y, ColumnIndex);
    if ListItem <> nil then begin
      if ColumnIndex = TOPIC_USER_DATA_COLUMN then begin
        EditTopicUserData(ListItem);
        Exit;
      end;
      if ColumnIndex = TOPIC_HIDDEN_COLUMN then begin
        ToggleSelectedTopicsHidden(ListItem);
        Exit;
      end;
    end;
    FTopicsListViewWindowProc(Message);
    if (ListItem <> nil) and (ColumnIndex = 1) and not ListItem.Selected then begin
      for Index := 0 to lvTopics.Items.Count - 1 do begin
        lvTopics.Items[Index].Selected := False;
      end;
      ListItem.Selected := True;
      ListItem.Focused := True;
      lvTopicsClick(lvTopics);
    end;
    Exit;
  end;
  if Message.Msg = WM_RBUTTONDOWN then begin
    X := SmallInt(LoWord(Message.LParam));
    Y := SmallInt(HiWord(Message.LParam));
    ListItem := TopicListItemAt(X, Y, ColumnIndex);
    if (ListItem <> nil) and not ListItem.Selected then begin
      for Index := 0 to lvTopics.Items.Count - 1 do begin
        lvTopics.Items[Index].Selected := False;
      end;
      ListItem.Selected := True;
      ListItem.Focused := True;
    end;
  end;
  FTopicsListViewWindowProc(Message);
end;

function TfrmTopics.BuildTopicHTML(TopicData: TStrings; const DefaultTopicName: string): string;
var
  HTMLLines: TStringList;
  DateText: string;
  EntryDate: TFMDateTime;
  EntryFMDate: string;
  EntryHidden: string;
  EntryIEN: string;
  EntryToggleText: string;
  EntryUserData: string;
  EntryOpen: Boolean;
  EntryTextOpen: Boolean;
  EntryCount: Integer;
  Index: Integer;
  Modified: Boolean;
  TopicName: string;
  TopicUserData: string;
  TOCDateText: string;
  TOCLines: TStringList;
begin
  TopicName := DefaultTopicName;
  EntryTextOpen := false;
  TopicUserData := '';
  for Index := 0 to TopicData.Count - 1 do begin
    if Piece(TopicData[Index], '^', 1) = '0' then begin
      TopicName := Piece(TopicData[Index], '^', 2);
      TopicUserData := Piece(TopicData[Index], '^', 4);
      Break;
    end;
  end;

  HTMLLines := TStringList.Create;
  TOCLines := nil;
  try
    TOCLines := TStringList.Create;
    HTMLLines.Add('<!DOCTYPE html>');
    HTMLLines.Add('<html><head><style>');
    HTMLLines.Add('body { font-family: Segoe UI, Tahoma, Arial, sans-serif; height: 100%; margin: 0; overflow: hidden; color: #202020; background: #ffffff; }');
    HTMLLines.Add('.topic-header { background: #ffffff; border-bottom: 1px solid #c9d8e6; height: 26px; left: 132px; overflow: hidden; padding: 8px 12px; position: absolute; right: 0; top: 0; white-space: nowrap; }');
    HTMLLines.Add('.topic-content { bottom: 0; left: 132px; overflow: auto; padding: 12px; position: absolute; right: 0; top: 43px; }');
    HTMLLines.Add('.topic-toc { background: #f5f9fc; border-right: 1px solid #c9d8e6; bottom: 0; display: block; left: 0; overflow-y: auto; padding: 9px 6px; position: absolute; top: 0; width: 120px; }');
    HTMLLines.Add('.toc-title { color: #1f4e79; font-size: 11px; font-weight: bold; margin: 0 3px 6px 3px; text-transform: uppercase; }');
    HTMLLines.Add('.topic-toc a { border-radius: 3px; color: #1f4e79; display: block; font-size: 12px; padding: 4px 3px; text-decoration: none; }');
    HTMLLines.Add('.topic-toc a:hover { background: #dcecf7; }');
    HTMLLines.Add('.toc-empty { color: #666666; font-size: 11px; font-style: italic; padding: 3px; }');
    HTMLLines.Add('h1 { color: #1f4e79; font-size: 18px; line-height: 26px; margin: 0; overflow: hidden; text-overflow: ellipsis; }');
    HTMLLines.Add('.topic-delete { color: #a00000; float: right; font-size: 11px; font-weight: normal; line-height: 26px; margin-left: 12px; text-decoration: underline; }');
    HTMLLines.Add('.topic-meta { color: #555555; font-size: 12px; margin-bottom: 14px; }');
    HTMLLines.Add('.topic-meta span, .entry-meta span { margin-right: 14px; }');
    HTMLLines.Add('.topic-entry { border: 1px solid #c9d8e6; border-radius: 4px; margin: 0 0 10px 0; overflow: hidden; }');
    HTMLLines.Add('.entry-heading { background: #eaf3fa; padding: 7px 9px; color: #1f4e79; font-weight: bold; }');
    HTMLLines.Add('.document-link { color: #1f4e79; text-decoration: none; }');
    HTMLLines.Add('.entry-hidden-toggle { color: #1f4e79; float: right; font-size: 11px; font-weight: normal; margin-right: 12px; text-decoration: underline; }');
    HTMLLines.Add('.entry-delete { color: #a00000; float: right; font-size: 11px; font-weight: normal; margin-right: 12px; text-decoration: underline; }');
    HTMLLines.Add('.entry-edit { color: #1f4e79; float: right; font-size: 11px; font-weight: normal; text-decoration: underline; }');
    HTMLLines.Add('.entry-meta { background: #f7fafc; border-top: 1px solid #dce8f1; color: #555555; font-size: 11px; padding: 4px 9px; }');
    HTMLLines.Add('.entry-text { min-height: 1em; padding: 9px; white-space: pre-wrap; font-family: Consolas, Courier New, monospace; font-size: 12px; }');
    HTMLLines.Add('.empty { color: #666666; font-style: italic; }');
    HTMLLines.Add('.topic-bottom-spacer { height: 48px; }');
    HTMLLines.Add('</style></head><body><div class="topic-header"><a class="topic-delete" href="about:TopicDelete">Delete Entire Topic</a><h1>' + HTMLEncode(TopicName, Modified) + '</h1></div><div class="topic-content">');
    TOCLines.Add('<div class="topic-toc"><div class="toc-title">Entries</div>');
    if TopicUserData <> '' then begin
      HTMLLines.Add('<div class="topic-meta">');
      if TopicUserData <> '' then begin
        HTMLLines.Add('<span>User data: ' + HTMLEncode(TopicUserData, Modified) + '</span>');
      end;
      HTMLLines.Add('</div>');
    end;

    EntryOpen := False;
    EntryCount := 0;
    for Index := 0 to TopicData.Count - 1 do begin
      if Piece(TopicData[Index], '^', 1) = '1' then begin
        if EntryOpen then begin
          if EntryTextOpen then begin
            HTMLLines.Add('</div>');
          end;
          HTMLLines.Add('</div>');
        end;
        EntryFMDate := Piece(TopicData[Index], '^', 2);
        EntryDate := MakeFMDateTime(EntryFMDate);
        if EntryDate > 0 then begin
          DateText := FormatDateTime('mmmm d, yyyy h:nn am/pm', FMDateTimeToDateTime(EntryDate));
        end else begin
          DateText := Piece(TopicData[Index], '^', 2);
        end;
        if EntryDate > 0 then begin
          TOCDateText := FormatFMDateTime('mm/dd/yy', EntryDate)
        end else begin
          TOCDateText := '(No date)';
        end;
        EntryIEN := Piece(TopicData[Index], '^', 3);
        EntryHidden := Piece(TopicData[Index], '^', 4);
        EntryUserData := Piece(TopicData[Index], '^', 5);
        Inc(EntryCount);
        TOCLines.Add('<a href="about:TopicEntry^topic-entry-' + IntToStr(EntryCount) + '">' + HTMLEncode(TOCDateText, Modified) + '</a>');
        HTMLLines.Add('<div class="topic-entry" id="topic-entry-' + IntToStr(EntryCount) + '">');
        HTMLLines.Add('<div class="entry-heading">');
        if EntryIEN <> '' then begin
          HTMLLines.Add('<a class="document-link" href="about:TopicDocument^' + HTMLEncode(EntryIEN, Modified) + '">' + HTMLEncode(DateText, Modified) + '</a>');
        end else begin
          HTMLLines.Add(HTMLEncode(DateText, Modified));
        end;
        if EntryHidden <> '' then begin
          EntryToggleText := 'Show'
        end else begin
          EntryToggleText := 'Hide';
        end;
        HTMLLines.Add('<a class="entry-edit" href="about:TopicEntryEdit^' + HTMLEncode(EntryFMDate, Modified) + '">Edit</a>');
        HTMLLines.Add('<a class="entry-delete" href="about:TopicEntryDelete^' + HTMLEncode(EntryFMDate, Modified) + '">Delete</a>');
        HTMLLines.Add('<a class="entry-hidden-toggle" href="about:TopicEntryHidden^' + HTMLEncode(EntryFMDate, Modified) + '">' + EntryToggleText + '</a>');
        HTMLLines.Add('</div>');
        if (EntryHidden <> '') or (EntryUserData <> '') then begin
          HTMLLines.Add('<div class="entry-meta">');
          if EntryHidden <> '' then begin
            HTMLLines.Add('<span>(Hidden...)</span>');
          end;
          if EntryUserData <> '' then begin
            HTMLLines.Add('<span>User data: ' + HTMLEncode(EntryUserData, Modified) + '</span>');
          end;
          HTMLLines.Add('</div>');
        end;
        EntryTextOpen := EntryHidden = '';
        if EntryTextOpen then begin
          HTMLLines.Add('<div class="entry-text">');
        end;
        EntryOpen := True;
      end else begin
        if (Piece(TopicData[Index], '^', 1) = '2') and EntryTextOpen then begin
          HTMLLines.Add(Copy(TopicData[Index], 3, MaxInt));
        end;
      end;
    end;
    if EntryOpen then begin
      if EntryTextOpen then begin
        HTMLLines.Add('</div>');
      end;
      HTMLLines.Add('</div>');
    end;
    if EntryCount = 0 then begin
      HTMLLines.Add('<p class="empty">No entries are recorded for this topic.</p>');
    end;
    HTMLLines.Add('<div class="topic-bottom-spacer"></div>');
    if EntryCount = 0 then begin
      TOCLines.Add('<div class="toc-empty">None</div>');
    end;
    TOCLines.Add('</div>');
    HTMLLines.Add('</div>');
    HTMLLines.AddStrings(TOCLines);
    HTMLLines.Add('</body></html>');
    Result := HTMLLines.Text;
  finally
    TOCLines.Free;
    HTMLLines.Free;
  end;
end;

function TfrmTopics.BuildCuratedTopicHTML(CuratedData: TStrings; const DefaultTopicName: string): string;
var
  CuratedDate: TFMDateTime;
  CuratedDateText: string;
  HTMLLines: TStringList;
  FirstText: Boolean;
  Index: Integer;
  Modified: Boolean;
  TopicName: string;
  HasText: Boolean;
begin
  TopicName := DefaultTopicName;
  CuratedDateText := '';
  HasText := False;
  for Index := 0 to CuratedData.Count - 1 do begin
    if Piece(CuratedData[Index], '^', 1) = '0' then begin
      TopicName := Piece(CuratedData[Index], '^', 2);
      CuratedDate := MakeFMDateTime(Piece(CuratedData[Index], '^', 4));
      if CuratedDate > 0 then begin
        CuratedDateText := FormatDateTime('mmmm d, yyyy h:nn am/pm', FMDateTimeToDateTime(CuratedDate));
      end;
    end else if Piece(CuratedData[Index], '^', 1) = '2' then begin
      HasText := True;
    end;
  end;
  HTMLLines := TStringList.Create;
  try
    HTMLLines.Add('<!DOCTYPE html>');
    HTMLLines.Add('<html><head><style>');
    HTMLLines.Add('body { color: #202020; font-family: Segoe UI, Tahoma, Arial, sans-serif; margin: 0; padding: 8px; }');
    HTMLLines.Add('.curated-meta { color: #555555; font-size: 12px; margin: 16px 0 0 0; }');
    HTMLLines.Add('.curated-text { font-family: Segoe UI, Tahoma, Arial, sans-serif; font-size: 12px; white-space: pre-wrap; word-break: break-word; }');
    HTMLLines.Add('.empty { color: #666666; font-style: italic; margin: 4px 0; }');
    HTMLLines.Add('</style></head><body>');
    if HasText then begin
      HTMLLines.Add('<div class="curated-text">');
      FirstText := True;
      for Index := 0 to CuratedData.Count - 1 do begin
        if Piece(CuratedData[Index], '^', 1) = '2' then begin
          if FirstText then begin
            HTMLLines.Add('<b><u>' + HTMLEncode(TopicName, Modified) + '</u></b>:&nbsp;' + Copy(CuratedData[Index], 3, MaxInt));
            FirstText := False;
          end else begin
            HTMLLines.Add(Copy(CuratedData[Index], 3, MaxInt));
          end;
        end;
      end;
      HTMLLines.Add('</div>');
    end else begin
      HTMLLines.Add('<p class="empty">No curated text is cached yet for ' + HTMLEncode(TopicName, Modified) + '.</p>');
    end;
    if CuratedDateText <> '' then begin
      HTMLLines.Add('<div class="curated-meta">Curated from the progress note dated ' + HTMLEncode(CuratedDateText, Modified) + '.</div>');
    end;
    HTMLLines.Add('</body></html>');
    Result := HTMLLines.Text;
  finally
    HTMLLines.Free;
  end;
end;

procedure TfrmTopics.DisplayTopicHTML(const HTML: string);
begin
  FPendingTopicHTML := HTML;
  WritePendingTopicHTML;
end;

procedure TfrmTopics.DisplayCuratedTopic;
var
  CuratedData: TStringList;
  Status: string;
begin
  CuratedData := TStringList.Create;
  try
    Status := GetCuratedTopic(CuratedData, FCurrentTopicPropertyID);
    if Piece(Status, '^', 1) <> '1' then begin
      CuratedData.Clear;
    end;
    WBLoadHTML(wbShowCurated, BuildCuratedTopicHTML(CuratedData, FCurrentTopicName));
  finally
    CuratedData.Free;
  end;
end;

function TfrmTopics.BuildTopicDataHTML: string;
var
  HTMLLines: TStringList;
  Index: Integer;
  LineIndex: Integer;
  Modified: Boolean;
  TableData: TTopicDataTable;
begin
  HTMLLines := TStringList.Create;
  try
    HTMLLines.Add('<!DOCTYPE html>');
    HTMLLines.Add('<html><head><style>');
    HTMLLines.Add('body { color: #202020; font-family: Segoe UI, Tahoma, Arial, sans-serif; margin: 0; padding: 8px; }');
    HTMLLines.Add('.related-data-table-container { margin: 0 0 8px 0; overflow-x: auto; overflow-y: hidden; }');
    HTMLLines.Add('.related-data-table { border: 1px solid #9fbad0; border-collapse: separate; border-radius: 4px; border-spacing: 0; margin: 0; min-width: 100%; }');
    HTMLLines.Add('.related-data-table th { background: #2f75b5; color: #ffffff; font-size: 12px; line-height: 1.15; padding: 5px 8px; text-align: left; }');
    HTMLLines.Add('.table-delete { color: #ffffff; font-size: 11px; font-weight: normal; margin-left: 12px; text-decoration: underline; }');
    HTMLLines.Add('.table-edit { color: #ffffff; font-size: 11px; font-weight: normal; margin-left: 12px; text-decoration: underline; }');
    HTMLLines.Add('.related-data-table td { font-family: Consolas, Courier New, monospace; font-size: 12px; line-height: 1.1; padding: 1px 8px; white-space: pre; word-break: normal; }');
    HTMLLines.Add('.table-bottom-spacer td { height: 14px; padding: 0; }');
    HTMLLines.Add('.no-data { color: #666666; font-family: Segoe UI, Tahoma, Arial, sans-serif !important; font-style: italic; }');
    HTMLLines.Add('.empty { color: #666666; font-style: italic; margin: 4px; }');
    HTMLLines.Add('</style></head><body>');
    if FTopicDataTables.Count = 0 then begin
      HTMLLines.Add('<p class="empty">No related data tables have been added.</p>');
    end else begin
      for Index := 0 to FTopicDataTables.Count - 1 do begin
        TableData := FTopicDataTables[Index];
        HTMLLines.Add('<div class="related-data-table-container"><table class="related-data-table"><thead><tr><th>');
        HTMLLines.Add(HTMLEncode(TableData.TableName, Modified));
        if TableData.TableIEN <> '' then begin
          HTMLLines.Add('<a class="table-edit" href="about:TopicTableEdit^' + HTMLEncode(TableData.TableIEN, Modified) + '">Edit</a>');
          HTMLLines.Add('<a class="table-delete" href="about:TopicTableDelete^' + HTMLEncode(TableData.TableIEN, Modified) + '">Remove</a>');
        end;
        HTMLLines.Add('</th></tr></thead><tbody>');
        if TableData.Lines.Count = 0 then begin
          HTMLLines.Add('<tr><td class="no-data">No data found for this table.</td></tr>');
        end else begin
          for LineIndex := 0 to TableData.Lines.Count - 1 do begin
            HTMLLines.Add('<tr><td>' + TableData.Lines[LineIndex] + '</td></tr>');
          end;
        end;
        HTMLLines.Add('<tr class="table-bottom-spacer"><td>&nbsp;</td></tr>');
        HTMLLines.Add('</tbody></table></div>');
      end;
    end;
    HTMLLines.Add('</body></html>');
    Result := HTMLLines.Text;
  finally
    HTMLLines.Free;
  end;
end;

procedure TfrmTopics.DisplayTopicDataHTML;
begin
  WBLoadHTML(wbTopicData, BuildTopicDataHTML);
end;

function TfrmTopics.FindTopicDataTable(const TableName: string): TTopicDataTable;
var
  Index: Integer;
begin
  Result := nil;
  for Index := 0 to FTopicDataTables.Count - 1 do begin
    if SameText(FTopicDataTables[Index].TableName, TableName) then begin
      Result := FTopicDataTables[Index];
      Exit;
    end;
  end;
end;

function TfrmTopics.FindTopicDataTableByIEN(const TableIEN: string): TTopicDataTable;
var
  Index: Integer;
begin
  Result := nil;
  for Index := 0 to FTopicDataTables.Count - 1 do begin
    if FTopicDataTables[Index].TableIEN = TableIEN then begin
      Result := FTopicDataTables[Index];
      Exit;
    end;
  end;
end;

procedure TfrmTopics.UpdateTopicDataModel(TableData: TStrings);
var
  CurrentTable: TTopicDataTable;
  Index: Integer;
  RowType: string;
  TableName: string;
begin
  CurrentTable := nil;
  for Index := 0 to TableData.Count - 1 do begin
    RowType := Piece(TableData[Index], '^', 1);
    if RowType = '1' then begin
      TableName := Copy(TableData[Index], 3, MaxInt);
      CurrentTable := FindTopicDataTable(TableName);
      if CurrentTable = nil then begin
        CurrentTable := TTopicDataTable.Create(TableName);
        FTopicDataTables.Add(CurrentTable);
      end else begin
        CurrentTable.Lines.Clear;
      end;
    end else if (RowType = '2') and Assigned(CurrentTable) then begin
      CurrentTable.Lines.Add(Copy(TableData[Index], 3, MaxInt));
    end;
  end;
end;

procedure TfrmTopics.DeleteTopicDataTable(const TableIEN: string);
var
  ErrorText: string;
  Index: Integer;
  Status: string;
begin
  if (FCurrentTopicPropertyID = '') or (TableIEN = '') then begin
    Exit;
  end;
  if MessageDlg('Remove associated table from this topic?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
    Exit;
  end;
  Status := SetTopicLinkedTables(FCurrentTopicPropertyID, '@' + TableIEN);
  if Piece(Status, '^', 1) <> '1' then begin
    ErrorText := Piece(Status, '^', 2);
    if ErrorText = '' then begin
      ErrorText := 'The associated table could not be removed from this topic.';
    end;
    MessageDlg(ErrorText, mtError, [mbOK], 0);
    Exit;
  end;
  for Index := FTopicDataTables.Count - 1 downto 0 do begin
    if FTopicDataTables[Index].TableIEN = TableIEN then begin
      FTopicDataTables.Delete(Index);
      Break;
    end;
  end;
  RemoveTopicTableChange(TableIEN);
  DisplayTopicDataHTML;
end;

procedure TfrmTopics.EditTopicDataTable(const TableIEN: string);
var
  EditedLines: TStringList;
  Editor: TfrmTopicTableEdit;
  ErrorText: string;
  Status: string;
  TopicTable: TTopicDataTable;
begin
  TopicTable := FindTopicDataTableByIEN(TableIEN);
  if not Assigned(TopicTable) then begin
    Exit;
  end;
  Editor := TfrmTopicTableEdit.Create(Self, TopicTable.TableName, TopicTable.Lines);
  EditedLines := TStringList.Create;
  try
    if Editor.ShowModal = mrOk then begin
      Editor.CopyEditedLines(EditedLines);
      Status := SetTopicTableData(TableIEN, EditedLines);
      if Piece(Status, '^', 1) = '1' then begin
        TopicTable.Lines.Assign(EditedLines);
        TrackTopicTableChange(TopicTable);
        DisplayTopicDataHTML;
      end else begin
        ErrorText := Piece(Status, '^', 2);
        if ErrorText = '' then begin
          ErrorText := 'The edited table could not be saved.';
        end;
        MessageDlg(ErrorText, mtError, [mbOK], 0);
      end;
    end;
  finally
    EditedLines.Free;
    Editor.Free;
  end;
end;

procedure TfrmTopics.LoadTopicDataTables(TopicEntries: TStrings);
var
  Index: Integer;
  Params: string;
  Status: string;
  TableData: TStringList;
  TopicTable: TTopicDataTable;
  TableIndex: Integer;
  TableIEN: string;
  TableInfo: string;
  TableName: string;
  TableNames: TStringList;
begin
  FTopicDataTables.Clear;
  if not Assigned(TopicEntries) then begin
    DisplayTopicDataHTML;
    Exit;
  end;
  TableNames := TStringList.Create;
  TableData := TStringList.Create;
  try
    TableNames.CaseSensitive := False;
    TableNames.Duplicates := dupIgnore;
    TableNames.Sorted := True;
    for Index := 0 to TopicEntries.Count - 1 do begin
      if Piece(TopicEntries[Index], '^', 1) = '0.5' then begin
        for TableIndex := 2 to NumPieces(TopicEntries[Index], '^') do begin
          TableInfo := Piece(TopicEntries[Index], '^', TableIndex);
          TableIEN := Piece(TableInfo, ';', 1);
          TableName := Piece(TableInfo, ';', 2);
          if (StrToIntDef(TableIEN, 0) > 0) and (TableName <> '') then begin
            TableNames.Add(TableIEN + '^' + TableName);
          end;
        end;
      end;
    end;
    Params := '';
    for Index := 0 to TableNames.Count - 1 do begin
      if Params <> '' then begin
        Params := Params + '^';
      end;
      Params := Params + Piece(TableNames[Index], '^', 2);
    end;
    if Params <> '' then begin
      Status := GetTopicTablesAsData(TableData, Params);
      if Piece(Status, '^', 1) = '1' then begin
        UpdateTopicDataModel(TableData);
        for Index := 0 to TableNames.Count - 1 do begin
          TopicTable := FindTopicDataTable(Piece(TableNames[Index], '^', 2));
          if Assigned(TopicTable) then begin
            TopicTable.TableIEN := Piece(TableNames[Index], '^', 1);
          end;
        end;
      end;
    end;
  finally
    TableData.Free;
    TableNames.Free;
  end;
  DisplayTopicDataHTML;
end;

procedure TfrmTopics.btnAddAssocTableClick(Sender: TObject);
var
  AvailableTables: TStringList;
  ErrorText: string;
  Index: Integer;
  Picker: TfrmTopicTablePicker;
  SelectedTable: string;
  SelectedTableIEN: string;
  Status: string;
  TableData: TStringList;
  TopicTable: TTopicDataTable;
  TableIENs: TStringList;
  TableName: string;
begin
  if (Patient.DFN = '') or (FCurrentTopicPropertyID = '') then begin
    Exit;
  end;

  AvailableTables := TStringList.Create;
  TableIENs := TStringList.Create;
  try
    Status := ListTopicTables(AvailableTables);
    if Piece(Status, '^', 1) <> '1' then begin
      ErrorText := Piece(Status, '^', 2);
      if ErrorText = '' then begin
        ErrorText := 'The available tables could not be retrieved.';
      end;
      MessageDlg(ErrorText, mtError, [mbOK], 0);
      Exit;
    end;

    AvailableTables.Sorted := False;
    AvailableTables.CaseSensitive := False;
    for Index := AvailableTables.Count - 1 downto 0 do begin
      TableName := Piece(AvailableTables[Index], '^', 1);
      SelectedTableIEN := Piece(AvailableTables[Index], '^', 2);
      if (TableName = '') or (SelectedTableIEN = '') then begin
        AvailableTables.Delete(Index)
      end else begin
        TableIENs.Add(AvailableTables[Index]);
        AvailableTables[Index] := TableName;
      end;
    end;
    AvailableTables.Duplicates := dupIgnore;
    AvailableTables.Sorted := True;
    if AvailableTables.Count = 0 then begin
      MessageDlg('No related-data tables are available.', mtInformation, [mbOK], 0);
      Exit;
    end;

    Picker := TfrmTopicTablePicker.Create(Self, AvailableTables);
    try
      SelectedTable := '';
      if Picker.ShowModal = mrOk then begin
        SelectedTable := Picker.SelectedTable;
      end;
    finally
      Picker.Free;
    end;

    if SelectedTable = '' then begin
      Exit;
    end;
    SelectedTableIEN := '';
    for Index := 0 to TableIENs.Count - 1 do begin
      if SameText(Piece(TableIENs[Index], '^', 1), SelectedTable) then begin
        SelectedTableIEN := Piece(TableIENs[Index], '^', 2);
        Break;
      end;
    end;
    if SelectedTableIEN = '' then begin
      MessageDlg('The selected table has no file 22708 identifier.', mtError, [mbOK], 0);
      Exit;
    end;
    Status := SetTopicLinkedTables(FCurrentTopicPropertyID, SelectedTableIEN);
    if Piece(Status, '^', 1) <> '1' then begin
      ErrorText := Piece(Status, '^', 2);
      if ErrorText = '' then begin
        ErrorText := 'The selected table could not be associated with this topic.';
      end;
      MessageDlg(ErrorText, mtError, [mbOK], 0);
      Exit;
    end;

    TableData := TStringList.Create;
    try
      Status := GetTopicTablesAsData(TableData, SelectedTable);
      if Piece(Status, '^', 1) <> '1' then begin
        ErrorText := Piece(Status, '^', 2);
        if ErrorText = '' then begin
          ErrorText := 'The selected table could not be retrieved.';
        end;
        MessageDlg(ErrorText, mtError, [mbOK], 0);
        Exit;
      end;
      UpdateTopicDataModel(TableData);
      TopicTable := FindTopicDataTable(SelectedTable);
      if Assigned(TopicTable) then begin
        TopicTable.TableIEN := SelectedTableIEN;
      end;
      MarkTopicForNoteSync(FCurrentTopicPropertyID, ptncTable);
      UpdatePushSyncButton;
      DisplayTopicDataHTML;
    finally
      TableData.Free;
    end;
  finally
    TableIENs.Free;
    AvailableTables.Free;
  end;
end;

function TfrmTopics.FindLatestTopicEntryID(TopicData: TStrings): string;
var
  EntryCount: Integer;
  EntryDate: TFMDateTime;
  Index: Integer;
  LatestDate: TFMDateTime;
begin
  Result := '';
  EntryCount := 0;
  LatestDate := 0;
  for Index := 0 to TopicData.Count - 1 do begin
    if Piece(TopicData[Index], '^', 1) = '1' then begin
      Inc(EntryCount);
      EntryDate := MakeFMDateTime(Piece(TopicData[Index], '^', 2));
      if EntryDate > LatestDate then begin
        LatestDate := EntryDate;
        Result := 'topic-entry-' + IntToStr(EntryCount);
      end;
    end;
  end;
end;

procedure TfrmTopics.WritePendingTopicHTML;
var
  HTML: string;
  WebDoc: IHTMLDocument2;
  V: Variant;
begin
  if FPendingTopicHTML = '' then begin
    Exit;
  end;
  if not Assigned(wbDisplayPrior.Document) then begin
    wbDisplayPrior.Navigate('about:blank');
    Exit;
  end;
  HTML := FPendingTopicHTML;
  FPendingTopicHTML := '';
  WebDoc := wbDisplayPrior.Document as IHTMLDocument2;
  V := VarArrayCreate([0, 0], varVariant);
  V[0] := HTML;
  WebDoc.write(PSafeArray(TVarData(V).VArray));
  WebDoc.close;
  if FPendingTopicEntryID <> '' then begin
    ScrollTopicEntryIntoView(FPendingTopicEntryID);
    FPendingTopicEntryID := '';
  end;
end;

procedure TfrmTopics.lvTopicsClick(Sender: TObject);
var
  ErrorText: string;
  ListItem: TListItem;
  Status: string;
  TopicData: TTopicListItemData;
  Modified: Boolean;
begin
  if Patient.DFN = '' then begin
    Exit;
  end;
  ListItem := lvTopics.Selected;
  if (ListItem = nil) or (ListItem.Data = nil) then begin
    FCurrentTopicEntries.Clear;
    FTopicDataTables.Clear;
    FCurrentTopicName := '';
    FCurrentTopicPropertyID := '';
    FPendingTopicEntryID := '';
    ClearTopicEntryEditor;
    btnAddAssocTable.Enabled := False;
    wbDisplayPrior.Navigate('about:blank');
    wbShowCurated.Navigate('about:blank');
    DisplayTopicDataHTML;
    Exit;
  end;
  ClearTopicEntryEditor;
  TopicData := TTopicListItemData(ListItem.Data);
  if TopicData.PropertyID <> FCurrentTopicPropertyID then begin
    FTopicDataTables.Clear;
    DisplayTopicDataHTML;
  end;
  FCurrentTopicEntries.Clear;
  FCurrentTopicName := '';
  FCurrentTopicPropertyID := '';
  FPendingTopicEntryID := '';
  btnNewFMDTEntry.Enabled := False;
  btnAddAssocTable.Enabled := False;
  Status := Get1Topic(FCurrentTopicEntries, TopicData.PropertyID);
  if Piece(Status, '^', 1) = '1' then begin
    FCurrentTopicName := TopicData.TopicName;
    FCurrentTopicPropertyID := TopicData.PropertyID;
    btnNewFMDTEntry.Enabled := True;
    btnAddAssocTable.Enabled := True;
    LoadTopicDataTables(FCurrentTopicEntries);
    FPendingTopicEntryID := FindLatestTopicEntryID(FCurrentTopicEntries);
    DisplayTopicHTML(BuildTopicHTML(FCurrentTopicEntries, FCurrentTopicName));
    DisplayCuratedTopic;
  end else begin
    ErrorText := Piece(Status, '^', 2);
    if ErrorText = '' then begin
      ErrorText := 'The topic could not be retrieved.';
    end;
    DisplayTopicHTML('<html><body><h1>' + HTMLEncode(ListItem.Caption, Modified) + '</h1><p>' +
      HTMLEncode(ErrorText, Modified) + '</p></body></html>');
    wbShowCurated.Navigate('about:blank');
  end;
end;

procedure TfrmTopics.wbDisplayPriorDocumentComplete(Sender: TObject; const pDisp: IDispatch; const URL: OleVariant);
begin
  WritePendingTopicHTML;
end;

procedure TfrmTopics.wbTopicDataDocumentComplete(Sender: TObject; const pDisp: IDispatch; const URL: OleVariant);
begin
  UpdateTopicsRightColors;
end;

procedure TfrmTopics.wbTopicDataBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
var
  ActionName: string;
  ActionParam: string;
  ActionURL: string;
begin
  ActionURL := URL;
  ActionURL := StringReplace(ActionURL, '%5E', '^', [rfReplaceAll, rfIgnoreCase]);
  ActionName := Piece(Piece(ActionURL, '^', 1), ':', 2);
  ActionParam := Piece(ActionURL, '^', 2);
  if ActionName = 'TopicTableDelete' then begin
    Cancel := True;
    DeleteTopicDataTable(ActionParam);
  end;
  if ActionName = 'TopicTableEdit' then begin
    Cancel := True;
    EditTopicDataTable(ActionParam);
  end;
end;

procedure TfrmTopics.wbDisplayPriorBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
var
  ActionName: string;
  ActionParam: string;
  ActionURL: string;
begin
  ActionURL := URL;
  ActionURL := StringReplace(ActionURL, '%5E', '^', [rfReplaceAll, rfIgnoreCase]);
  ActionName := Piece(Piece(ActionURL, '^', 1), ':', 2);
  ActionParam := Piece(ActionURL, '^', 2);
  if ActionName = 'TopicDocument' then begin
    Cancel := True;
    NavigateToDocument(ActionParam);
  end;
  if ActionName = 'TopicEntry' then begin
    Cancel := True;
    ScrollTopicEntryIntoView(ActionParam);
  end;
  if ActionName = 'TopicEntryHidden' then begin
    Cancel := True;
    ToggleTopicEntryHidden(ActionParam);
  end;
  if ActionName = 'TopicEntryEdit' then begin
    Cancel := True;
    EditCurrentTopicEntry(ActionParam);
  end;
  if ActionName = 'TopicEntryDelete' then begin
    Cancel := True;
    DeleteCurrentTopicEntry(ActionParam);
  end;
  if ActionName = 'TopicDelete' then begin
    Cancel := True;
    DeleteSelectedTopic;
  end;
end;

procedure TfrmTopics.NavigateToDocument(const DocumentIEN: string);
begin
  // Future Topics document navigation will be implemented here.
end;

procedure TfrmTopics.ScrollTopicEntryIntoView(const EntryID: string);
var
  Document: IHTMLDocument3;
  EntryElement: IHTMLElement;
begin
  if not Assigned(wbDisplayPrior.Document) then begin
    Exit;
  end;
  Document := wbDisplayPrior.Document as IHTMLDocument3;
  if not Assigned(Document) then begin
    Exit;
  end;
  EntryElement := Document.getElementById(EntryID);
  if Assigned(EntryElement) then begin
    EntryElement.scrollIntoView(True);
  end;
end;

function TfrmTopics.CursorOverControl(AControl: TControl): Boolean;
var
  CursorPos: TPoint;
begin
  GetCursorPos(CursorPos);
  CursorPos := AControl.Parent.ScreenToClient(CursorPos);
  Result := PtInRect(AControl.BoundsRect, CursorPos);
end;

procedure TfrmTopics.ConfigureTopicsElsewhereMouseDown(AParent: TWinControl);
var
  Child: TControl;
  Index: Integer;
begin
  TControlCracker(AParent).OnMouseDown := pnlTopicsElsewhereMouseDown;
  for Index := 0 to AParent.ControlCount - 1 do begin
    Child := AParent.Controls[Index];
    if Child is TWinControl then begin
      ConfigureTopicsElsewhereMouseDown(TWinControl(Child));
    end else begin
      TControlCracker(Child).OnMouseDown := pnlTopicsElsewhereMouseDown;
    end;
  end;
end;

procedure TfrmTopics.CloseTopicsLeftWithoutDelay;
begin
  timTopicsLeftCollapse.Enabled := False;
  if FTopicsLeftPinned then begin
    Exit;
  end;
  SetTopicsLeftOpen(False);
end;

procedure TfrmTopics.HideTopicsLeftHandle;
begin
  timHideTopicsLeftHandle.Enabled := False;
  btnTopicsLeftHandle.Visible := False;
  splTopicsLeft.Color := clBtnFace;
end;

procedure TfrmTopics.PositionTopicsLeftHandle;
begin
  btnTopicsLeftHandle.Left := splTopicsLeft.Left - (btnTopicsLeftHandle.Width div 2) + (splTopicsLeft.Width div 2);
  btnTopicsLeftHandle.Top := (pnlTopicsLeft.Height - btnTopicsLeftHandle.Height) div 2;
  btnTopicsLeftHandle.BringToFront;
  PositionTopicsLeftPin;
end;

procedure TfrmTopics.PositionTopicsLeftPin;
begin
  btnTopicsLeftPin.Left := splTopicsLeft.Left - (btnTopicsLeftPin.Width div 2) + (splTopicsLeft.Width div 2);
  btnTopicsLeftPin.Top := splTopicsLeft.Top + splTopicsLeft.Height - btnTopicsLeftPin.Height;
  btnTopicsLeftPin.BringToFront;
end;

procedure TfrmTopics.PositionTopicsRightHandle;
begin
  btnTopicsRightHandle.Left := splTopicsRight.Left - (btnTopicsRightHandle.Width div 2) + (splTopicsRight.Width div 2);
  btnTopicsRightHandle.Top := (pnlTopicsRight.Height - btnTopicsRightHandle.Height) div 2;
  btnTopicsRightHandle.BringToFront;
end;

procedure TfrmTopics.QueueTopicsLeftCollapse;
begin
  if FTopicsLeftPinned then begin
    Exit;
  end;
  timTopicsLeftCollapse.Enabled := False;
  timTopicsLeftCollapse.Enabled := True;
end;

procedure TfrmTopics.NormalizeTopicsLeftPaneWidths;
begin
  if FTopicsLeftOpenWidth < splTopicsLeft.MinSize + TOPICS_LEFT_PANE_MINIMUM_WIDTH_GAP then begin
    FTopicsLeftOpenWidth := splTopicsLeft.MinSize + TOPICS_LEFT_PANE_MINIMUM_WIDTH_GAP;
  end;
  if FTopicsLeftClosedWidth < splTopicsLeft.MinSize then begin
    FTopicsLeftClosedWidth := splTopicsLeft.MinSize;
  end;
  if FTopicsLeftClosedWidth > FTopicsLeftOpenWidth - TOPICS_LEFT_PANE_MINIMUM_WIDTH_GAP then begin
    FTopicsLeftClosedWidth := FTopicsLeftOpenWidth - TOPICS_LEFT_PANE_MINIMUM_WIDTH_GAP;
  end;
end;

procedure TfrmTopics.NormalizeTopicsRightPaneWidths;
begin
  if FTopicsRightOpenWidth < splTopicsRight.MinSize + TOPICS_RIGHT_PANE_MINIMUM_WIDTH_GAP then begin
    FTopicsRightOpenWidth := splTopicsRight.MinSize + TOPICS_RIGHT_PANE_MINIMUM_WIDTH_GAP;
  end;
  if FTopicsRightClosedWidth < splTopicsRight.MinSize then begin
    FTopicsRightClosedWidth := splTopicsRight.MinSize;
  end;
  if FTopicsRightClosedWidth > FTopicsRightOpenWidth - TOPICS_RIGHT_PANE_MINIMUM_WIDTH_GAP then begin
    FTopicsRightClosedWidth := FTopicsRightOpenWidth - TOPICS_RIGHT_PANE_MINIMUM_WIDTH_GAP;
  end;
end;

procedure TfrmTopics.QueueHideTopicsLeftHandle;
begin
  if FTopicsLeftPinned then begin
    Exit;
  end;
  timHideTopicsLeftHandle.Enabled := False;
  timHideTopicsLeftHandle.Enabled := True;
end;

procedure TfrmTopics.SetTopicsLeftOpen(Value: Boolean);
begin
  if FTopicsLeftOpen = Value then begin
    Exit;
  end;
  FTopicsLeftOpen := Value;
  UpdateTopicListColors;
  FTopicsLeftAnimationStartWidth := pnlTopicsLeft.Width;
  if FTopicsLeftOpen then begin
    FTopicsLeftAnimationTargetWidth := FTopicsLeftOpenWidth;
  end else begin
    FTopicsLeftAnimationTargetWidth := FTopicsLeftClosedWidth;
  end;
  FTopicsLeftAnimationStep := 0;
  FTopicsLeftAnimating := FTopicsLeftAnimationStartWidth <> FTopicsLeftAnimationTargetWidth;
  UpdateTopicsLeftHandleGlyph;
  PositionTopicsLeftHandle;
  timTopicsLeftAnimate.Enabled := FTopicsLeftAnimating;
end;

procedure TfrmTopics.SetTopicsRightOpen(Value: Boolean);
begin
  if FTopicsRightOpen = Value then begin
    Exit;
  end;
  NormalizeTopicsRightPaneWidths;
  pnlTopicsRight.Constraints.MinWidth := FTopicsRightClosedWidth;
  FTopicsRightOpen := Value;
  UpdateTopicsRightColors;
  FTopicsRightAnimationStartWidth := pnlTopicsRight.Width;
  if FTopicsRightOpen then begin
    FTopicsRightAnimationTargetWidth := FTopicsRightOpenWidth;
  end else begin
    FTopicsRightAnimationTargetWidth := FTopicsRightClosedWidth;
  end;
  FTopicsRightAnimationStep := 0;
  FTopicsRightAnimating := FTopicsRightAnimationStartWidth <> FTopicsRightAnimationTargetWidth;
  UpdateTopicsRightHandleGlyph;
  PositionTopicsRightHandle;
  timTopicsRightAnimate.Enabled := FTopicsRightAnimating;
end;

procedure TfrmTopics.ShowTopicsLeftHandle;
begin
  timHideTopicsLeftHandle.Enabled := False;
  PositionTopicsLeftHandle;
  UpdateTopicsLeftHandleGlyph;
  btnTopicsLeftHandle.Visible := True;
  splTopicsLeft.Color := clSkyBlue;
end;

procedure TfrmTopics.splTopicsLeftMoved(Sender: TObject);
begin
  if FTopicsLeftAnimating then begin
    Exit;
  end;
  if FTopicsLeftOpen then begin
    FTopicsLeftOpenWidth := pnlTopicsLeft.Width;
  end else begin
    FTopicsLeftClosedWidth := pnlTopicsLeft.Width;
  end;
  NormalizeTopicsLeftPaneWidths;
  if FTopicsLeftOpen and (pnlTopicsLeft.Width <> FTopicsLeftOpenWidth) then begin
    pnlTopicsLeft.Width := FTopicsLeftOpenWidth;
  end;
  if FTopicsLoaded then begin
    uTMGOptions.WriteInteger(TOPICS_LEFT_OPEN_SIZE_KEY, FTopicsLeftOpenWidth);
    uTMGOptions.WriteInteger(TOPICS_LEFT_CLOSED_SIZE_KEY, FTopicsLeftClosedWidth);
  end;
  PositionTopicsLeftHandle;
end;

procedure TfrmTopics.splTopicsRightMoved(Sender: TObject);
begin
  if FTopicsRightAnimating then begin
    Exit;
  end;
  if FTopicsRightOpen then begin
    FTopicsRightOpenWidth := pnlTopicsRight.Width;
  end else begin
    FTopicsRightClosedWidth := pnlTopicsRight.Width;
  end;
  NormalizeTopicsRightPaneWidths;
  pnlTopicsRight.Constraints.MinWidth := FTopicsRightClosedWidth;
  if FTopicsRightOpen then begin
    if pnlTopicsRight.Width <> FTopicsRightOpenWidth then begin
      pnlTopicsRight.Width := FTopicsRightOpenWidth;
    end;
  end else begin
    if pnlTopicsRight.Width <> FTopicsRightClosedWidth then begin
      pnlTopicsRight.Width := FTopicsRightClosedWidth;
    end;
  end;
  if FTopicsLoaded then begin
    uTMGOptions.WriteInteger(TOPICS_RIGHT_OPEN_SIZE_KEY, FTopicsRightOpenWidth);
    uTMGOptions.WriteInteger(TOPICS_RIGHT_CLOSED_SIZE_KEY, FTopicsRightClosedWidth);
  end;
  PositionTopicsRightHandle;
end;

procedure TfrmTopics.Splitter1Moved(Sender: TObject);
begin
  UpdateCenterPanelConstraints;
  if (not FTopicsLoaded) or (not FCuratedPaneOpen) then begin
    Exit;
  end;
  uTMGOptions.WriteInteger(TOPICS_CENTER_TOP_HEIGHT_KEY, pnlCenterTop.Height);
end;

procedure TfrmTopics.Splitter2Moved(Sender: TObject);
begin
  UpdateCenterPanelConstraints;
end;

procedure TfrmTopics.UpdateCenterPanelConstraints;
var
  MaximumBottomHeight: Integer;
  MaximumTopHeight: Integer;
  MinimumMiddleHeight: Integer;
begin
  if FCuratedPaneOpen then begin
    MinimumMiddleHeight := TOPICS_CENTER_MIDDLE_MINIMUM_HEIGHT;
  end else begin
    MinimumMiddleHeight := pnlCenterMiddleBanner.Height + TOPICS_CENTER_MIDDLE_COLLAPSED_BROWSER_HEIGHT;
  end;
  pnlCenterMiddle.Constraints.MinHeight := MinimumMiddleHeight;
  MaximumTopHeight := pnlTopicsCenter.ClientHeight - pnlCenterBottom.Height -
    Splitter1.Height - Splitter2.Height - MinimumMiddleHeight;
  if MaximumTopHeight < 1 then begin
    MaximumTopHeight := 1;
  end;
  if not FCuratedPaneOpen then begin
    pnlCenterTop.Height := MaximumTopHeight;
  end else if pnlCenterTop.Height > MaximumTopHeight then begin
    pnlCenterTop.Height := MaximumTopHeight;
  end;
  MaximumBottomHeight := pnlTopicsCenter.ClientHeight - pnlCenterTop.Height -
    Splitter1.Height - Splitter2.Height - MinimumMiddleHeight;
  if MaximumBottomHeight < 1 then begin
    MaximumBottomHeight := 1;
  end;
  if pnlCenterBottom.Height > MaximumBottomHeight then begin
    pnlCenterBottom.Height := MaximumBottomHeight;
  end;
end;

procedure TfrmTopics.SetCuratedPaneOpen(ShouldOpen: Boolean);
begin
  if FCuratedPaneOpen = ShouldOpen then begin
    Exit;
  end;
  if not ShouldOpen then begin
    FCuratedPaneTopHeight := pnlCenterTop.Height;
  end;
  FCuratedPaneOpen := ShouldOpen;
  if FCuratedPaneOpen then begin
    pnlCenterTop.Height := FCuratedPaneTopHeight;
  end;
  UpdateCenterPanelConstraints;
  UpdateOpenCloseCuratedGlyph;
  if FTopicsLoaded then begin
    uTMGOptions.WriteBool(TOPICS_CENTER_MIDDLE_OPEN_KEY, FCuratedPaneOpen);
  end;
end;

procedure TfrmTopics.UpdateOpenCloseCuratedGlyph;
begin
  if FCuratedPaneOpen then begin
    if FCuratedPaneButtonHovered then begin
      btnOpenCloseCurated.ImageIndex := 1;
    end else begin
      btnOpenCloseCurated.ImageIndex := 0;
    end;
  end else begin
    if FCuratedPaneButtonHovered then begin
      btnOpenCloseCurated.ImageIndex := 3;
    end else begin
      btnOpenCloseCurated.ImageIndex := 2;
    end;
  end;
end;

procedure TfrmTopics.btnOpenCloseCuratedClick(Sender: TObject);
begin
  SetCuratedPaneOpen(not FCuratedPaneOpen);
end;

procedure TfrmTopics.btnOpenCloseCuratedMouseEnter(Sender: TObject);
begin
  FCuratedPaneButtonHovered := True;
  UpdateOpenCloseCuratedGlyph;
end;

procedure TfrmTopics.btnOpenCloseCuratedMouseLeave(Sender: TObject);
begin
  FCuratedPaneButtonHovered := False;
  UpdateOpenCloseCuratedGlyph;
end;

procedure TfrmTopics.pnlTopicsLeftMouseEnter(Sender: TObject);
begin
  if FTopicsLeftPinned then begin
    Exit;
  end;
  timTopicsLeftCollapse.Enabled := False;
  SetTopicsLeftOpen(True);
end;

procedure TfrmTopics.pnlTopicsLeftMouseLeave(Sender: TObject);
begin
  if FTopicsLeftPinned then begin
    Exit;
  end;
  QueueTopicsLeftCollapse;
end;

procedure TfrmTopics.splTopicsLeftMouseEnter(Sender: TObject);
begin
  if FTopicsLeftPinned then begin
    Exit;
  end;
  timTopicsLeftCollapse.Enabled := False;
  ShowTopicsLeftHandle;
end;

procedure TfrmTopics.splTopicsLeftMouseLeave(Sender: TObject);
begin
  if FTopicsLeftPinned then begin
    Exit;
  end;
  QueueTopicsLeftCollapse;
  QueueHideTopicsLeftHandle;
end;

procedure TfrmTopics.btnTopicsLeftHandleClick(Sender: TObject);
begin
  if FTopicsLeftPinned then begin
    Exit;
  end;
  SetTopicsLeftOpen(not FTopicsLeftOpen);
  ShowTopicsLeftHandle;
end;

procedure TfrmTopics.btnTopicsRightHandleClick(Sender: TObject);
begin
  SetTopicsRightOpen(not FTopicsRightOpen);
end;

procedure TfrmTopics.btnTopicsLeftPinClick(Sender: TObject);
begin
  FTopicsLeftPinned := not FTopicsLeftPinned;
  timTopicsLeftCollapse.Enabled := False;
  timHideTopicsLeftHandle.Enabled := False;
  if FTopicsLeftPinned then begin
    timTopicsLeftAnimate.Enabled := False;
    if FTopicsLeftAnimating then begin
      pnlTopicsLeft.Width := FTopicsLeftAnimationTargetWidth;
    end;
    FTopicsLeftAnimating := False;
    PositionTopicsLeftHandle;
    HideTopicsLeftHandle;
  end;
  UpdateTopicsLeftPinGlyph;
end;

procedure TfrmTopics.btnTopicsLeftHandleMouseEnter(Sender: TObject);
begin
  if FTopicsLeftPinned then begin
    Exit;
  end;
  timTopicsLeftCollapse.Enabled := False;
  timHideTopicsLeftHandle.Enabled := False;
  splTopicsLeft.Color := clSkyBlue;
end;

procedure TfrmTopics.btnTopicsLeftHandleMouseLeave(Sender: TObject);
begin
  if FTopicsLeftPinned then begin
    Exit;
  end;
  QueueTopicsLeftCollapse;
  QueueHideTopicsLeftHandle;
end;

procedure TfrmTopics.timTopicsLeftCollapseTimer(Sender: TObject);
var
  MousePosition: TPoint;
begin
  if FTopicsLeftPinned then begin
    timTopicsLeftCollapse.Enabled := False;
    Exit;
  end;
  if GetCapture <> 0 then begin
    Exit;
  end;
  if CursorOverControl(pnlTopicsLeft) or CursorOverControl(splTopicsLeft) or CursorOverControl(btnTopicsLeftHandle) or CursorOverControl(btnTopicsLeftPin) then begin
    Exit;
  end;
  MousePosition := ScreenToClient(Mouse.CursorPos);
  if MousePosition.X < splTopicsLeft.Left + splTopicsLeft.Width + TOPICS_LEFT_COLLAPSE_RIGHT_DISTANCE then begin
    Exit;
  end;
  timTopicsLeftCollapse.Enabled := False;
  SetTopicsLeftOpen(False);
end;

procedure TfrmTopics.timTopicsLeftAnimateTimer(Sender: TObject);
begin
  Inc(FTopicsLeftAnimationStep);
  pnlTopicsLeft.Width := FTopicsLeftAnimationStartWidth +
    ((FTopicsLeftAnimationTargetWidth - FTopicsLeftAnimationStartWidth) * FTopicsLeftAnimationStep div TOPICS_PANE_ANIMATION_STEPS);
  PositionTopicsLeftHandle;
  if FTopicsLeftAnimationStep >= TOPICS_PANE_ANIMATION_STEPS then begin
    pnlTopicsLeft.Width := FTopicsLeftAnimationTargetWidth;
    FTopicsLeftAnimating := False;
    timTopicsLeftAnimate.Enabled := False;
    PositionTopicsLeftHandle;
  end;
end;

procedure TfrmTopics.timTopicsRightAnimateTimer(Sender: TObject);
begin
  Inc(FTopicsRightAnimationStep);
  pnlTopicsRight.Width := FTopicsRightAnimationStartWidth +
    ((FTopicsRightAnimationTargetWidth - FTopicsRightAnimationStartWidth) * FTopicsRightAnimationStep div TOPICS_PANE_ANIMATION_STEPS);
  PositionTopicsRightHandle;
  if FTopicsRightAnimationStep >= TOPICS_PANE_ANIMATION_STEPS then begin
    pnlTopicsRight.Width := FTopicsRightAnimationTargetWidth;
    FTopicsRightAnimating := False;
    timTopicsRightAnimate.Enabled := False;
    PositionTopicsRightHandle;
  end;
end;

procedure TfrmTopics.timHideTopicsLeftHandleTimer(Sender: TObject);
begin
  if CursorOverControl(splTopicsLeft) or CursorOverControl(btnTopicsLeftHandle) then begin
    Exit;
  end;
  HideTopicsLeftHandle;
end;

procedure TfrmTopics.UpdateTopicsLeftHandleGlyph;
var
  Bitmap: TBitmap;
  ImageIndex: Integer;
begin
  if FTopicsLeftOpen then begin
    ImageIndex := 1;
  end else begin
    ImageIndex := 0;
  end;
  if FTopicsLeftOpen then begin
    btnTopicsLeftHandle.LoadGlyph(ImageCollection1, TOPICS_IMAGE_ARROW_LEFT);
  end else begin
    btnTopicsLeftHandle.LoadGlyph(ImageCollection1, TOPICS_IMAGE_ARROW_RIGHT);
  end;
  Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(TfrmFrame(Owner).ImageListSplitterHandle.Width, TfrmFrame(Owner).ImageListSplitterHandle.Height);
    TfrmFrame(Owner).ImageListSplitterHandle.GetBitmap(ImageIndex, Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TfrmTopics.UpdateTopicsLeftPinGlyph;
begin
  if FTopicsLeftPinned then begin
    btnTopicsLeftPin.LoadGlyph(ImageCollection1, TOPICS_IMAGE_PIN_DOWN_RED);
  end else begin
    btnTopicsLeftPin.LoadGlyph(ImageCollection1, TOPICS_IMAGE_PIN_UP_BLUE);
  end;
end;

procedure TfrmTopics.UpdateTopicsRightHandleGlyph;
var
  Bitmap: TBitmap;
  ImageIndex: Integer;
begin
  if FTopicsRightOpen then begin
    ImageIndex := 0;
  end else begin
    ImageIndex := 1;
  end;
  if FTopicsRightOpen then begin
    btnTopicsRightHandle.LoadGlyph(ImageCollection1, TOPICS_IMAGE_ARROW_RIGHT);
  end else begin
    btnTopicsRightHandle.LoadGlyph(ImageCollection1, TOPICS_IMAGE_ARROW_LEFT);
  end;
  Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(TfrmFrame(Owner).ImageListSplitterHandle.Width, TfrmFrame(Owner).ImageListSplitterHandle.Height);
    TfrmFrame(Owner).ImageListSplitterHandle.GetBitmap(ImageIndex, Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TfrmTopics.pnlTopicsElsewhereMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CloseTopicsLeftWithoutDelay;
end;

end.
