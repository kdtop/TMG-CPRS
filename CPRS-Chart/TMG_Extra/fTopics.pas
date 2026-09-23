unit fTopics;

interface

uses
  Windows, Messages, Classes, Controls, ExtCtrls, Buttons, Graphics, fPage, VA508AccessibilityManager,
  Vcl.StdCtrls, Vcl.OleCtrls, SHDocVw, ORCtrls, Vcl.ComCtrls, Vcl.Menus, Vcl.Dialogs, MSHTML, Variants, ActiveX, SysUtils,
  CommCtrl, rTopics,
  System.UITypes, Vcl.ToolWin, System.ImageList, Vcl.ImgList, Vcl.BaseImageCollection, Vcl.ImageCollection, uPngGlyphButton, System.Generics.Collections,
  Vcl.Mask, Vcl.Forms;

type
  TControlCracker = class(TControl);

  TTopicListItemData = class
    PropertyID: string;
    LastUsedFMDate: Double;
    TopicName: string;
    Hidden: string;
    UserData: string;
  end;

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
    pnlRightHeader: TPanel;
    pnlRightFooter: TPanel;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    ImageList1: TImageList;
    ImageCollection1: TImageCollection;
    pnlLeftBot: TPanel;
    cbShowHidden: TCheckBox;
    edtFilter: TLabeledEdit;
    btnClearFilter: TBitBtn;
    procedure btnTopicsLeftHandleClick(Sender: TObject);
    procedure btnTopicsLeftHandleMouseEnter(Sender: TObject);
    procedure btnTopicsLeftHandleMouseLeave(Sender: TObject);
    procedure pnlTopicsLeftMouseEnter(Sender: TObject);
    procedure pnlTopicsLeftMouseLeave(Sender: TObject);
    procedure splTopicsLeftMoved(Sender: TObject);
    procedure splTopicsRightMoved(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure btnClearFilterClick(Sender: TObject);
    procedure edtFilterChange(Sender: TObject);
    procedure timTopicsLeftCollapseTimer(Sender: TObject);
    procedure timHideTopicsLeftHandleTimer(Sender: TObject);
    procedure timTopicsLeftAnimateTimer(Sender: TObject);
    procedure timTopicsRightAnimateTimer(Sender: TObject);
    procedure timSaveTopicChangesTimer(Sender: TObject);
    procedure timTopicFilterTimer(Sender: TObject);
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
    procedure TopicListPopupMenuPopup(Sender: TObject);
    procedure wbDisplayPriorBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure wbDisplayPriorDocumentComplete(Sender: TObject; const pDisp: IDispatch; const URL: OleVariant);
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
    FCurrentTopicName: string;
    FCurrentTopicPropertyID: string;
    FTopicSortKeys: TList<TTopicSortKey>;
    FTopicsListViewWindowProc: TWndMethod;
    FTopicListPopupMenu: TPopupMenu;
    FHideTopicsMenuItem: TMenuItem;
    FMergeTopicsMenuItem: TMenuItem;
    FPendingTopicHTML: string;
    FPendingTopicEntryID: string;
    FTopicHiddenColumnWidth: Integer;
    timTopicFilter: TTimer;
    function BuildTopicHTML(TopicData: TStrings; const DefaultTopicName: string): string;
    procedure ClearTopicList;
    procedure CloseTopicsLeftWithoutDelay;
    procedure ConfigureTopicsElsewhereMouseDown(AParent: TWinControl);
    procedure DisplayTopicHTML(const HTML: string);
    function CursorOverControl(AControl: TControl): Boolean;
    function CompareTopicListItems(Item1, Item2: TListItem; ColumnIndex: Integer): Integer;
    function FindTopicSortKey(ColumnIndex: Integer): Integer;
    function FindLatestTopicEntryID(TopicData: TStrings): string;
    function TopicMatchesUserDataFilter(const UserData: string): Boolean;
    procedure EditTopicUserData(ListItem: TListItem);
    procedure InitializeTopicListColumns;
    procedure MergeSelectedTopics;
    procedure NavigateToDocument(const DocumentIEN: string);
    procedure ScrollTopicEntryIntoView(const EntryID: string);
    function TopicListColumnAt(X: Integer): Integer;
    function TopicListItemAt(X, Y: Integer; out ColumnIndex: Integer): TListItem;
    procedure QueueTopicChange(TopicData: TTopicListItemData; HiddenChanged, UserDataChanged: Boolean);
    procedure QueueTopicEntryChange(const PropertyID, EntryFMDate, Hidden, UserData: string; HiddenChanged, UserDataChanged: Boolean);
    procedure RebuildTopicList;
    procedure RestoreTopicListLayout;
    procedure RestartTopicSaveTimer;
    procedure SaveTopicListLayout;
    procedure ToggleTopicEntryHidden(const EntryFMDate: string);
    procedure ToggleTopicHidden(ListItem: TListItem);
    procedure ToggleSelectedTopicsHidden(ListItem: TListItem);
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
    procedure UpdateTopicListSortIndicators;
    procedure UpdateTopicListHiddenColumn;
    procedure lvTopicsWindowProc(var Message: TMessage);
    procedure WritePendingTopicHTML;
  public
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure RefreshTopicList;
  end;

var
  frmTopics: TfrmTopics;

implementation

{$R *.dfm}

uses
  fFrame, ORFn, uCore, uHTMLTools, uTMGOptions;

const
  TOPICS_PANE_ANIMATION_STEPS = 3;
  TOPICS_PANE_ANIMATION_TIMESLICE_MS = 25;
  TOPICS_LEFT_COLLAPSE_DELAY_MS = 500;
  TOPICS_LEFT_COLLAPSE_RIGHT_DISTANCE = 100;
  TOPICS_LEFT_OPEN_SIZE_KEY = 'frmTopics.LeftPaneOpenSize';
  TOPICS_LEFT_CLOSED_SIZE_KEY = 'frmTopics.LeftPaneClosedSize';
  TOPICS_RIGHT_OPEN_SIZE_KEY = 'frmTopics.RightPaneOpenSize';
  TOPICS_RIGHT_CLOSED_SIZE_KEY = 'frmTopics.RightPaneClosedSize';
  TOPICS_CENTER_TOP_HEIGHT_KEY = 'frmTopics.CenterTopHeight';
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

procedure TfrmTopics.Loaded;
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
  FTopicSortKeys := TList<TTopicSortKey>.Create;
  InitializeTopicListColumns;
  FTopicListPopupMenu := TPopupMenu.Create(Self);
  FTopicListPopupMenu.OnPopup := TopicListPopupMenuPopup;
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
  if FTopicsLeftOpenWidth < splTopicsLeft.MinSize then begin
    FTopicsLeftOpenWidth := splTopicsLeft.MinSize;
  end;
  if FTopicsLeftClosedWidth < splTopicsLeft.MinSize then begin
    FTopicsLeftClosedWidth := splTopicsLeft.MinSize;
  end;
  FTopicsLeftOpen := False;
  pnlTopicsLeft.Width := FTopicsLeftClosedWidth;
  FTopicsRightOpenWidth := uTMGOptions.ReadInteger(TOPICS_RIGHT_OPEN_SIZE_KEY, pnlTopicsRight.Width);
  FTopicsRightClosedWidth := uTMGOptions.ReadInteger(TOPICS_RIGHT_CLOSED_SIZE_KEY, splTopicsRight.MinSize);
  if FTopicsRightOpenWidth < splTopicsRight.MinSize then begin
    FTopicsRightOpenWidth := splTopicsRight.MinSize;
  end;
  if FTopicsRightClosedWidth < splTopicsRight.MinSize then begin
    FTopicsRightClosedWidth := splTopicsRight.MinSize;
  end;
  FTopicsRightOpen := True;
  pnlTopicsRight.Width := FTopicsRightOpenWidth;
  pnlCenterTop.Height := uTMGOptions.ReadInteger(TOPICS_CENTER_TOP_HEIGHT_KEY, pnlCenterTop.Height);
  Splitter1.OnMoved := Splitter1Moved;
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
  lvTopics.Color := clWhite;
  RestoreTopicListLayout;
  UpdateTopicListSortIndicators;
  wbDisplayPrior.OnBeforeNavigate2 := wbDisplayPriorBeforeNavigate2;
  wbDisplayPrior.OnDocumentComplete := wbDisplayPriorDocumentComplete;
  UpdateTopicsLeftHandleGlyph;
  UpdateTopicsRightHandleGlyph;
  UpdateTopicsLeftPinGlyph;
  PositionTopicsLeftHandle;
  PositionTopicsRightHandle;
  FTopicsLoaded := True;
  Resize;
end;

procedure TfrmTopics.Resize;
begin
  inherited;
  if (not FTopicsLoaded) or (csDestroying in ComponentState) then begin
    Exit;
  end;
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
  FTopicSortKeys.Free;
  inherited;
end;

procedure TfrmTopics.ClearPtData;
begin
  inherited;
  timSaveTopicChanges.Enabled := False;
  ClearTopicList;
  FTopicListModel.Clear;
  FTopicChanges.Clear;
  FCurrentTopicEntries.Clear;
  FCurrentTopicName := '';
  FCurrentTopicPropertyID := '';
  FPendingTopicHTML := '';
  FPendingTopicEntryID := '';
  wbDisplayPrior.Navigate('about:blank');
end;

procedure TfrmTopics.ClearTopicList;
begin
  lvTopics.Items.Clear;
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
        ListItem.Caption := TopicData.TopicName;
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
      FCurrentTopicName := '';
      FCurrentTopicPropertyID := '';
      FPendingTopicHTML := '';
      FPendingTopicEntryID := '';
      wbDisplayPrior.Navigate('about:blank');
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
  FCurrentTopicName := '';
  FCurrentTopicPropertyID := '';
  FPendingTopicHTML := '';
  FPendingTopicEntryID := '';
  wbDisplayPrior.Navigate('about:blank');
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
        FTopicListModel.AddObject(TopicData.TopicName, TopicData);
        ListItem := lvTopics.Items.Add;
        ListItem.Data := TopicData;
        ListItem.Caption := TopicData.TopicName;
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
    Result := CompareText(Item1.Caption, Item2.Caption);
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
    Exit;
  end;
  if FindTopicSortKey(0) >= 0 then begin
    Sender.Canvas.Brush.Color := clCream
  end else begin
    Sender.Canvas.Brush.Color := clWhite;
  end;
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color + 1;
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color - 1;
end;

procedure TfrmTopics.lvTopicsCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if cdsSelected in State then begin
    Exit;
  end;
  if FindTopicSortKey(SubItem) >= 0 then begin
    Sender.Canvas.Brush.Color := clCream
  end else begin
    Sender.Canvas.Brush.Color := clWhite;
  end;
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color + 1;
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color - 1;
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
      if ColumnIndex > 0 then begin
        if ColumnIndex = TOPIC_USER_DATA_COLUMN then begin
          EditTopicUserData(ListItem);
        end;
        if ColumnIndex = TOPIC_HIDDEN_COLUMN then begin
          ToggleSelectedTopicsHidden(ListItem);
        end;
        Exit;
      end;
    end;
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
  TopicHidden: string;
  TopicName: string;
  TopicUserData: string;
  TOCDateText: string;
  TOCLines: TStringList;
begin
  TopicName := DefaultTopicName;
  EntryTextOpen := false;
  TopicHidden := '';
  TopicUserData := '';
  for Index := 0 to TopicData.Count - 1 do begin
    if Piece(TopicData[Index], '^', 1) = '0' then begin
      TopicName := Piece(TopicData[Index], '^', 2);
      TopicHidden := Piece(TopicData[Index], '^', 3);
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
    HTMLLines.Add('body { font-family: Segoe UI, Tahoma, Arial, sans-serif; margin: 0; color: #202020; background: #ffffff; }');
    HTMLLines.Add('.topic-content { margin-left: 132px; padding: 12px; }');
    HTMLLines.Add('.topic-toc { background: #f5f9fc; border-right: 1px solid #c9d8e6; bottom: 0; display: block; left: 0; overflow-y: auto; padding: 9px 6px; position: fixed; top: 0; width: 120px; }');
    HTMLLines.Add('.toc-title { color: #1f4e79; font-size: 11px; font-weight: bold; margin: 0 3px 6px 3px; text-transform: uppercase; }');
    HTMLLines.Add('.topic-toc a { border-radius: 3px; color: #1f4e79; display: block; font-size: 12px; padding: 4px 3px; text-decoration: none; }');
    HTMLLines.Add('.topic-toc a:hover { background: #dcecf7; }');
    HTMLLines.Add('.toc-empty { color: #666666; font-size: 11px; font-style: italic; padding: 3px; }');
    HTMLLines.Add('h1 { font-size: 18px; margin: 0 0 5px 0; color: #1f4e79; }');
    HTMLLines.Add('.topic-meta { color: #555555; font-size: 12px; margin-bottom: 14px; }');
    HTMLLines.Add('.topic-meta span, .entry-meta span { margin-right: 14px; }');
    HTMLLines.Add('.topic-entry { border: 1px solid #c9d8e6; border-radius: 4px; margin: 0 0 10px 0; overflow: hidden; }');
    HTMLLines.Add('.entry-heading { background: #eaf3fa; padding: 7px 9px; color: #1f4e79; font-weight: bold; }');
    HTMLLines.Add('.document-link { color: #1f4e79; text-decoration: none; }');
    HTMLLines.Add('.entry-hidden-toggle { color: #1f4e79; float: right; font-size: 11px; font-weight: normal; text-decoration: underline; }');
    HTMLLines.Add('.entry-meta { background: #f7fafc; border-top: 1px solid #dce8f1; color: #555555; font-size: 11px; padding: 4px 9px; }');
    HTMLLines.Add('.entry-text { min-height: 1em; padding: 9px; white-space: pre-wrap; font-family: Consolas, Courier New, monospace; font-size: 12px; }');
    HTMLLines.Add('.empty { color: #666666; font-style: italic; }');
    HTMLLines.Add('.topic-bottom-spacer { height: 48px; }');
    HTMLLines.Add('</style></head><body><div class="topic-content">');
    TOCLines.Add('<div class="topic-toc"><div class="toc-title">Entries</div>');
    HTMLLines.Add('<h1>' + HTMLEncode(TopicName, Modified) + '</h1>');
    if (TopicHidden <> '') or (TopicUserData <> '') then begin
      HTMLLines.Add('<div class="topic-meta">');
      if TopicHidden <> '' then begin
        HTMLLines.Add('<span>Hidden: ' + HTMLEncode(TopicHidden, Modified) + '</span>');
      end;
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
          HTMLLines.Add(HTMLEncode(Copy(TopicData[Index], 3, MaxInt), Modified));
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

procedure TfrmTopics.DisplayTopicHTML(const HTML: string);
begin
  FPendingTopicHTML := HTML;
  WritePendingTopicHTML;
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
    Exit;
  end;
  TopicData := TTopicListItemData(ListItem.Data);
  FCurrentTopicEntries.Clear;
  FCurrentTopicName := '';
  FCurrentTopicPropertyID := '';
  FPendingTopicEntryID := '';
  Status := Get1Topic(FCurrentTopicEntries, TopicData.PropertyID);
  if Piece(Status, '^', 1) = '1' then begin
    FCurrentTopicName := TopicData.TopicName;
    FCurrentTopicPropertyID := TopicData.PropertyID;
    FPendingTopicEntryID := FindLatestTopicEntryID(FCurrentTopicEntries);
    DisplayTopicHTML(BuildTopicHTML(FCurrentTopicEntries, FCurrentTopicName));
  end else begin
    ErrorText := Piece(Status, '^', 2);
    if ErrorText = '' then begin
      ErrorText := 'The topic could not be retrieved.';
    end;
    DisplayTopicHTML('<html><body><h1>' + HTMLEncode(ListItem.Caption, Modified) + '</h1><p>' +
      HTMLEncode(ErrorText, Modified) + '</p></body></html>');
  end;
end;

procedure TfrmTopics.wbDisplayPriorDocumentComplete(Sender: TObject; const pDisp: IDispatch; const URL: OleVariant);
begin
  WritePendingTopicHTML;
end;

procedure TfrmTopics.wbDisplayPriorBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
begin
  if Piece(Piece(URL, '^', 1), ':', 2) = 'TopicDocument' then begin
    Cancel := True;
    NavigateToDocument(Piece(URL, '^', 2));
  end;
  if Piece(Piece(URL, '^', 1), ':', 2) = 'TopicEntry' then begin
    Cancel := True;
    ScrollTopicEntryIntoView(Piece(URL, '^', 2));
  end;
  if Piece(Piece(URL, '^', 1), ':', 2) = 'TopicEntryHidden' then begin
    Cancel := True;
    ToggleTopicEntryHidden(Piece(URL, '^', 2));
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
  FTopicsRightOpen := Value;
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
  if FTopicsLoaded then begin
    if FTopicsLeftOpen then begin
      uTMGOptions.WriteInteger(TOPICS_LEFT_OPEN_SIZE_KEY, FTopicsLeftOpenWidth);
    end else begin
      uTMGOptions.WriteInteger(TOPICS_LEFT_CLOSED_SIZE_KEY, FTopicsLeftClosedWidth);
    end;
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
  if FTopicsLoaded then begin
    if FTopicsRightOpen then begin
      uTMGOptions.WriteInteger(TOPICS_RIGHT_OPEN_SIZE_KEY, FTopicsRightOpenWidth);
    end else begin
      uTMGOptions.WriteInteger(TOPICS_RIGHT_CLOSED_SIZE_KEY, FTopicsRightClosedWidth);
    end;
  end;
  PositionTopicsRightHandle;
end;

procedure TfrmTopics.Splitter1Moved(Sender: TObject);
begin
  if not FTopicsLoaded then begin
    Exit;
  end;
  uTMGOptions.WriteInteger(TOPICS_CENTER_TOP_HEIGHT_KEY, pnlCenterTop.Height);
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
