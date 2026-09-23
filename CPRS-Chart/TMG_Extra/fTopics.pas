unit fTopics;
//kt //codex 9/14/26  Added entire unit.

interface

uses
  //kt //codex original --> Windows, Classes, Controls, ExtCtrls, Buttons, Graphics, fPage, VA508AccessibilityManager,
  Windows, Messages, Classes, Controls, ExtCtrls, Buttons, Graphics, fPage, VA508AccessibilityManager, //kt //codex 9/21/26
  Vcl.StdCtrls, Vcl.OleCtrls, SHDocVw, ORCtrls, Vcl.ComCtrls, MSHTML, Variants, ActiveX, SysUtils,
  CommCtrl, rTopics, //kt //codex 9/21/26
  //kt //codex original --> System.UITypes, Vcl.ToolWin, System.ImageList, Vcl.ImgList, Vcl.BaseImageCollection, Vcl.ImageCollection, uPngGlyphButton;
  System.UITypes, Vcl.ToolWin, System.ImageList, Vcl.ImgList, Vcl.BaseImageCollection, Vcl.ImageCollection, uPngGlyphButton, System.Generics.Collections; //kt //codex 9/22/26

type
  TControlCracker = class(TControl);

  TTopicListItemData = class
    PropertyID: string;
    LastUsedFMDate: Double;
    TopicName: string; //kt //codex 9/18/26
    Hidden: string; //kt //codex 9/18/26
    UserData: string; //kt //codex 9/18/26
  end;

  TTopicSortKey = record //kt //codex 9/22/26
    ColumnIndex: Integer; //kt //codex 9/22/26
    Ascending: Boolean; //kt //codex 9/22/26
  end;

  TfrmTopics = class(TfrmPage)
    pnlTopicsLeft: TPanel;
    splTopicsLeft: TSplitter;
    pnlTopicsCenter: TPanel;
    splTopicsRight: TSplitter;
    pnlTopicsRight: TPanel;
    //kt //codex original --> btnTopicsLeftHandle: TButton;
    //kt //codex original --> btnTopicsLeftHandle: TPngGlyphButton;
    //kt //codex original --> btnTopicsRightHandle: TButton;
    //kt //codex original --> btnTopicsRightHandle: TPngGlyphButton;
    btnTopicsLeftHandleLegacy: TBitBtn; //kt //codex 9/18/26
    btnTopicsRightHandleLegacy: TBitBtn; //kt //codex 9/18/26
    timTopicsLeftCollapse: TTimer;
    timHideTopicsLeftHandle: TTimer;
    timTopicsLeftAnimate: TTimer;
    timTopicsRightAnimate: TTimer;
    timSaveTopicChanges: TTimer; //kt //codex 9/21/26
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
    //kt //codex original --> BitBtn2: TBitBtn;
    //kt //codex original --> btnTopicsLeftPin: TButton;
    //kt //codex original --> btnTopicsLeftPin: TPngGlyphButton;
    ImageList1: TImageList;
    ImageCollection1: TImageCollection;
    procedure btnTopicsLeftHandleClick(Sender: TObject);
    procedure btnTopicsLeftHandleMouseEnter(Sender: TObject);
    procedure btnTopicsLeftHandleMouseLeave(Sender: TObject);
    procedure pnlTopicsLeftMouseEnter(Sender: TObject);
    procedure pnlTopicsLeftMouseLeave(Sender: TObject);
    procedure splTopicsLeftMoved(Sender: TObject);
    procedure splTopicsRightMoved(Sender: TObject); //kt //codex 9/18/26
    procedure timTopicsLeftCollapseTimer(Sender: TObject);
    procedure timHideTopicsLeftHandleTimer(Sender: TObject);
    procedure timTopicsLeftAnimateTimer(Sender: TObject); //kt //codex 9/18/26
    procedure timTopicsRightAnimateTimer(Sender: TObject); //kt //codex 9/18/26
    procedure timSaveTopicChangesTimer(Sender: TObject); //kt //codex 9/21/26
    procedure btnTopicsRightHandleClick(Sender: TObject); //kt //codex 9/18/26
    procedure btnTopicsLeftPinClick(Sender: TObject); //kt //codex 9/18/26
    procedure pnlTopicsElsewhereMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); //kt //codex 9/18/26
    procedure lvTopicsClick(Sender: TObject); //kt //codex 9/17/26
    procedure lvTopicsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvTopicsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lvTopicsCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean); //kt //codex 9/18/26
    procedure lvTopicsCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean); //kt //codex 9/18/26
    procedure wbDisplayPriorBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool); //kt //codex 9/17/26
    procedure wbDisplayPriorDocumentComplete(Sender: TObject; const pDisp: IDispatch; const URL: OleVariant); //kt //codex 9/17/26
  protected
    procedure Loaded; override;
    procedure Resize; override; //kt //codex 9/18/26
    destructor Destroy; override;
  private
    btnTopicsLeftHandle: TPngGlyphButton; //kt //codex 9/21/26
    btnTopicsRightHandle: TPngGlyphButton; //kt //codex 9/21/26
    btnTopicsLeftPin: TPngGlyphButton; //kt //codex 9/21/26
    FTopicsLeftOpen: Boolean;
    FTopicsLeftPinned: Boolean; //kt //codex 9/18/26
    FTopicsLeftOpenWidth: Integer;
    FTopicsLeftClosedWidth: Integer;
    FTopicsLeftAnimating: Boolean; //kt //codex 9/18/26
    FTopicsLeftAnimationStartWidth: Integer; //kt //codex 9/18/26
    FTopicsLeftAnimationTargetWidth: Integer; //kt //codex 9/18/26
    FTopicsLeftAnimationStep: Integer; //kt //codex 9/18/26
    FTopicsRightOpen: Boolean; //kt //codex 9/18/26
    FTopicsRightOpenWidth: Integer; //kt //codex 9/18/26
    FTopicsRightClosedWidth: Integer; //kt //codex 9/18/26
    FTopicsRightAnimating: Boolean; //kt //codex 9/18/26
    FTopicsRightAnimationStartWidth: Integer; //kt //codex 9/18/26
    FTopicsRightAnimationTargetWidth: Integer; //kt //codex 9/18/26
    FTopicsRightAnimationStep: Integer; //kt //codex 9/18/26
    FTopicsLoaded: Boolean; //kt //codex 9/18/26
    FTopicListModel: TStringList; //kt //codex 9/18/26
    FTopicChanges: TTopicChanges; //kt //codex 9/21/26
    FCurrentTopicEntries: TStringList; //kt //codex 9/22/26
    FCurrentTopicName: string; //kt //codex 9/22/26
    FCurrentTopicPropertyID: string; //kt //codex 9/22/26
    //kt //codex original --> FTopicSortColumn: Integer;
    //kt //codex original --> FTopicSortAscending: Boolean;
    FTopicSortKeys: TList<TTopicSortKey>; //kt //codex 9/22/26
    FTopicsListViewWindowProc: TWndMethod; //kt //codex 9/21/26
    FPendingTopicHTML: string; //kt //codex 9/17/26
    function BuildTopicHTML(TopicData: TStrings; const DefaultTopicName: string): string; //kt //codex 9/17/26
    procedure ClearTopicList;
    procedure CloseTopicsLeftWithoutDelay; //kt //codex 9/18/26
    procedure ConfigureTopicsElsewhereMouseDown(AParent: TWinControl); //kt //codex 9/18/26
    procedure DisplayTopicHTML(const HTML: string); //kt //codex 9/17/26
    function CursorOverControl(AControl: TControl): Boolean;
    function CompareTopicListItems(Item1, Item2: TListItem; ColumnIndex: Integer): Integer; //kt //codex 9/22/26
    function FindTopicSortKey(ColumnIndex: Integer): Integer; //kt //codex 9/22/26
    procedure InitializeTopicListColumns;
    procedure NavigateToDocument(const DocumentIEN: string); //kt //codex 9/17/26
    procedure ScrollTopicEntryIntoView(const EntryID: string);
    function TopicListColumnAt(X: Integer): Integer; //kt //codex 9/21/26
    function TopicListItemAt(X, Y: Integer; out ColumnIndex: Integer): TListItem; //kt //codex 9/21/26
    procedure QueueTopicChange(TopicData: TTopicListItemData; HiddenChanged, UserDataChanged: Boolean); //kt //codex 9/21/26
    procedure QueueTopicEntryChange(const PropertyID, EntryFMDate, Hidden, UserData: string; HiddenChanged, UserDataChanged: Boolean); //kt //codex 9/22/26
    procedure RestartTopicSaveTimer; //kt //codex 9/21/26
    procedure ToggleTopicEntryHidden(const EntryFMDate: string); //kt //codex 9/22/26
    procedure ToggleTopicHidden(ListItem: TListItem); //kt //codex 9/21/26
    procedure HideTopicsLeftHandle;
    procedure PositionTopicsLeftHandle;
    procedure PositionTopicsLeftPin; //kt //codex 9/18/26
    procedure PositionTopicsRightHandle; //kt //codex 9/18/26
    procedure QueueTopicsLeftCollapse;
    procedure QueueHideTopicsLeftHandle;
    procedure SetTopicsLeftOpen(Value: Boolean);
    procedure SetTopicsRightOpen(Value: Boolean); //kt //codex 9/18/26
    procedure ShowTopicsLeftHandle;
    procedure splTopicsLeftMouseEnter(Sender: TObject);
    procedure splTopicsLeftMouseLeave(Sender: TObject);
    procedure UpdateTopicsLeftHandleGlyph;
    procedure UpdateTopicsLeftPinGlyph; //kt //codex 9/18/26
    procedure UpdateTopicsRightHandleGlyph; //kt //codex 9/18/26
    procedure UpdateTopicListSortIndicators; //kt //codex 9/18/26
    procedure lvTopicsWindowProc(var Message: TMessage); //kt //codex 9/21/26
    procedure WritePendingTopicHTML; //kt //codex 9/17/26
  public
    procedure ClearPtData; override;
    procedure DisplayPage; override; //kt //codex 9/18/26
    procedure RefreshTopicList;
  end;

var
  frmTopics: TfrmTopics;

implementation

{$R *.dfm}

uses
  //kt //codex original --> fFrame, ORFn, rTopics, uCore, uHTMLTools, uTMGOptions;
  fFrame, ORFn, uCore, uHTMLTools, uTMGOptions; //kt //codex 9/21/26

const
  TOPICS_PANE_ANIMATION_STEPS = 3; //kt //codex 9/18/26
  TOPICS_PANE_ANIMATION_TIMESLICE_MS = 25; //kt //codex 9/18/26
  TOPICS_LEFT_COLLAPSE_DELAY_MS = 500; //kt //codex 9/18/26
  TOPICS_LEFT_OPEN_SIZE_KEY = 'frmTopics.LeftPaneOpenSize'; //kt //codex 9/18/26
  TOPICS_LEFT_CLOSED_SIZE_KEY = 'frmTopics.LeftPaneClosedSize'; //kt //codex 9/18/26
  TOPICS_RIGHT_OPEN_SIZE_KEY = 'frmTopics.RightPaneOpenSize'; //kt //codex 9/18/26
  TOPICS_RIGHT_CLOSED_SIZE_KEY = 'frmTopics.RightPaneClosedSize'; //kt //codex 9/18/26
  TOPICS_IMAGE_PIN_DOWN_BLUE = 0; //kt //codex 9/18/26
  TOPICS_IMAGE_PIN_UP_BLUE = 1; //kt //codex 9/18/26
  TOPICS_IMAGE_ARROW_LEFT = 2; //kt //codex 9/18/26
  TOPICS_IMAGE_ARROW_RIGHT = 3; //kt //codex 9/18/26
  TOPICS_IMAGE_PIN_DOWN_RED = 4; //kt //codex 9/18/26
  TOPIC_SORT_ASCENDING_GLYPH = #9650; //kt //codex 9/18/26
  TOPIC_SORT_DESCENDING_GLYPH = #9660; //kt //codex 9/18/26
  TOPIC_HIDDEN_COLUMN = 3; //kt //codex 9/21/26
  TOPIC_HIDDEN_SUBITEM = 2; //kt //codex 9/21/26
  TOPIC_SAVE_DELAY_MS = 2000; //kt //codex 9/21/26
  TOPIC_COLUMN_CAPTIONS: array[0..3] of string = ('Topic', 'Last Used', 'User Data', 'Hidden'); //kt //codex 9/18/26

procedure TfrmTopics.Loaded;
var
  InitialSortKey: TTopicSortKey; //kt //codex 9/22/26
begin
  inherited;
  btnTopicsLeftHandle := TPngGlyphButton.Create(Self); //kt //codex 9/21/26
  btnTopicsLeftHandle.Name := 'btnTopicsLeftHandle'; //kt //codex 9/21/26
  btnTopicsLeftHandle.Parent := Self; //kt //codex 9/21/26
  btnTopicsLeftHandle.Visible := False; //kt //codex 9/21/26
  btnTopicsLeftHandle.OnClick := btnTopicsLeftHandleClick; //kt //codex 9/21/26
  btnTopicsLeftHandle.OnMouseEnter := btnTopicsLeftHandleMouseEnter; //kt //codex 9/21/26
  btnTopicsLeftHandle.OnMouseLeave := btnTopicsLeftHandleMouseLeave; //kt //codex 9/21/26
  btnTopicsRightHandle := TPngGlyphButton.Create(Self); //kt //codex 9/21/26
  btnTopicsRightHandle.Name := 'btnTopicsRightHandle'; //kt //codex 9/21/26
  btnTopicsRightHandle.Parent := Self; //kt //codex 9/21/26
  btnTopicsRightHandle.OnClick := btnTopicsRightHandleClick; //kt //codex 9/21/26
  btnTopicsLeftPin := TPngGlyphButton.Create(Self); //kt //codex 9/21/26
  btnTopicsLeftPin.Name := 'btnTopicsLeftPin'; //kt //codex 9/21/26
  btnTopicsLeftPin.Parent := Self; //kt //codex 9/21/26
  btnTopicsLeftPin.OnClick := btnTopicsLeftPinClick; //kt //codex 9/21/26
  FTopicListModel := TStringList.Create; //kt //codex 9/18/26
  FTopicListModel.OwnsObjects := True; //kt //codex 9/18/26
  //kt //codex original --> FTopicChanges := TTopicChanges.Create;
  FTopicChanges := TTopicChanges.Create([doOwnsValues]); //kt //codex 9/22/26
  //kt //codex original --> FTopicChanges.OwnsObjects := True;
  FCurrentTopicEntries := TStringList.Create; //kt //codex 9/22/26
  FTopicSortKeys := TList<TTopicSortKey>.Create; //kt //codex 9/22/26
  InitializeTopicListColumns;
  FTopicsLeftOpenWidth := uTMGOptions.ReadInteger(TOPICS_LEFT_OPEN_SIZE_KEY, pnlTopicsLeft.Width); //kt //codex 9/18/26
  FTopicsLeftClosedWidth := uTMGOptions.ReadInteger(TOPICS_LEFT_CLOSED_SIZE_KEY, splTopicsLeft.MinSize); //kt //codex 9/18/26
  if FTopicsLeftOpenWidth < splTopicsLeft.MinSize then FTopicsLeftOpenWidth := splTopicsLeft.MinSize; //kt //codex 9/18/26
  if FTopicsLeftClosedWidth < splTopicsLeft.MinSize then FTopicsLeftClosedWidth := splTopicsLeft.MinSize; //kt //codex 9/18/26
  FTopicsLeftOpen := False;
  pnlTopicsLeft.Width := FTopicsLeftClosedWidth;
  FTopicsRightOpenWidth := uTMGOptions.ReadInteger(TOPICS_RIGHT_OPEN_SIZE_KEY, pnlTopicsRight.Width); //kt //codex 9/18/26
  FTopicsRightClosedWidth := uTMGOptions.ReadInteger(TOPICS_RIGHT_CLOSED_SIZE_KEY, splTopicsRight.MinSize); //kt //codex 9/18/26
  if FTopicsRightOpenWidth < splTopicsRight.MinSize then FTopicsRightOpenWidth := splTopicsRight.MinSize; //kt //codex 9/18/26
  if FTopicsRightClosedWidth < splTopicsRight.MinSize then FTopicsRightClosedWidth := splTopicsRight.MinSize; //kt //codex 9/18/26
  FTopicsRightOpen := True;
  pnlTopicsRight.Width := FTopicsRightOpenWidth;
  //kt //codex original --> btnTopicsLeftHandle.Images := ImageList1;
  //kt //codex original --> btnTopicsRightHandle.Images := ImageList1;
  //kt //codex original --> btnTopicsLeftPin.Images := ImageList1;
  //kt //codex original --> btnTopicsLeftHandle.Width := ImageList1.Width + 4;
  //kt //codex original --> btnTopicsLeftHandle.Height := ImageList1.Height + 4;
  //kt //codex original --> btnTopicsRightHandle.Width := ImageList1.Width + 4;
  //kt //codex original --> btnTopicsRightHandle.Height := ImageList1.Height + 4;
  //kt //codex original --> btnTopicsLeftPin.Width := ImageList1.Width + 4;
  //kt //codex original --> btnTopicsLeftPin.Height := ImageList1.Height + 4;
  timTopicsLeftCollapse.Interval := TOPICS_LEFT_COLLAPSE_DELAY_MS; //kt //codex 9/18/26
  timTopicsLeftAnimate.Interval := TOPICS_PANE_ANIMATION_TIMESLICE_MS; //kt //codex 9/18/26
  timTopicsRightAnimate.Interval := TOPICS_PANE_ANIMATION_TIMESLICE_MS; //kt //codex 9/18/26
  timSaveTopicChanges.Interval := TOPIC_SAVE_DELAY_MS; //kt //codex 9/21/26
  TControlCracker(splTopicsLeft).OnMouseEnter := splTopicsLeftMouseEnter;
  TControlCracker(splTopicsLeft).OnMouseLeave := splTopicsLeftMouseLeave;
  TControlCracker(lvTopics).OnMouseEnter := pnlTopicsLeftMouseEnter;
  TControlCracker(lvTopics).OnMouseLeave := pnlTopicsLeftMouseLeave;
  ConfigureTopicsElsewhereMouseDown(pnlTopicsCenter); //kt //codex 9/18/26
  ConfigureTopicsElsewhereMouseDown(pnlTopicsRight); //kt //codex 9/18/26
  lvTopics.OnClick := lvTopicsClick; //kt //codex 9/17/26
  FTopicsListViewWindowProc := lvTopics.WindowProc; //kt //codex 9/21/26
  lvTopics.WindowProc := lvTopicsWindowProc; //kt //codex 9/21/26
  lvTopics.OnColumnClick := lvTopicsColumnClick;
  lvTopics.OnCompare := lvTopicsCompare;
  lvTopics.OnCustomDrawItem := lvTopicsCustomDrawItem; //kt //codex 9/18/26
  lvTopics.OnCustomDrawSubItem := lvTopicsCustomDrawSubItem; //kt //codex 9/18/26
  lvTopics.Color := clWhite; //kt //codex 9/18/26
  //kt //codex original --> FTopicSortColumn := 0;
  //kt //codex original --> FTopicSortAscending := True;
  InitialSortKey.ColumnIndex := 0; //kt //codex 9/22/26
  InitialSortKey.Ascending := True; //kt //codex 9/22/26
  FTopicSortKeys.Add(InitialSortKey); //kt //codex 9/22/26
  UpdateTopicListSortIndicators; //kt //codex 9/18/26
  wbDisplayPrior.OnBeforeNavigate2 := wbDisplayPriorBeforeNavigate2; //kt //codex 9/17/26
  wbDisplayPrior.OnDocumentComplete := wbDisplayPriorDocumentComplete; //kt //codex 9/17/26
  UpdateTopicsLeftHandleGlyph; //kt //codex 9/18/26
  UpdateTopicsRightHandleGlyph; //kt //codex 9/18/26
  UpdateTopicsLeftPinGlyph; //kt //codex 9/18/26
  PositionTopicsLeftHandle; //kt //codex 9/18/26
  PositionTopicsRightHandle; //kt //codex 9/18/26
  FTopicsLoaded := True; //kt //codex 9/18/26
  Resize; //kt //codex 9/18/26
end;

procedure TfrmTopics.Resize;
//kt //codex added entire procedure 9/18/26
begin
  inherited;
  //kt //codex original --> if not FTopicsLoaded then Exit;
  if (not FTopicsLoaded) or (csDestroying in ComponentState) then Exit; //kt //codex 9/18/26
  PositionTopicsLeftHandle;
  PositionTopicsRightHandle;
  PositionTopicsLeftPin; //kt //codex 9/18/26
end;

destructor TfrmTopics.Destroy;
begin
  //kt //codex original --> if Assigned(FTopicsListViewWindowProc) then lvTopics.WindowProc := FTopicsListViewWindowProc;
  if Assigned(lvTopics) then //kt //codex 9/21/26
  begin //kt //codex 9/21/26
    if Assigned(FTopicsListViewWindowProc) then lvTopics.WindowProc := FTopicsListViewWindowProc; //kt //codex 9/21/26
    ClearTopicList; //kt //codex 9/21/26
  end; //kt //codex 9/21/26
  //kt //codex original --> timSaveTopicChanges.Enabled := False;
  if Assigned(timSaveTopicChanges) then timSaveTopicChanges.Enabled := False; //kt //codex 9/21/26
  //kt //codex original --> ClearTopicList;
  FTopicListModel.Free; //kt //codex 9/18/26
  FTopicChanges.Free; //kt //codex 9/21/26
  FCurrentTopicEntries.Free; //kt //codex 9/22/26
  FTopicSortKeys.Free; //kt //codex 9/22/26
  inherited;
end;

procedure TfrmTopics.ClearPtData;
begin
  inherited;
  timSaveTopicChanges.Enabled := False; //kt //codex 9/21/26
  ClearTopicList;
  FTopicListModel.Clear; //kt //codex 9/18/26
  FTopicChanges.Clear; //kt //codex 9/21/26
  FCurrentTopicEntries.Clear; //kt //codex 9/22/26
  FCurrentTopicName := ''; //kt //codex 9/22/26
  FCurrentTopicPropertyID := ''; //kt //codex 9/22/26
  FPendingTopicHTML := ''; //kt //codex 9/17/26
  wbDisplayPrior.Navigate('about:blank'); //kt //codex 9/17/26
end;

procedure TfrmTopics.ClearTopicList;
begin
  //kt //codex original --> for Index := 0 to lvTopics.Items.Count - 1 do
  //kt //codex original -->   TObject(lvTopics.Items[Index].Data).Free;
  lvTopics.Items.Clear;
end;

procedure TfrmTopics.DisplayPage;
//kt //codex added entire procedure 9/18/26
begin
  inherited DisplayPage;
  if InitPatient then RefreshTopicList;
end;

procedure TfrmTopics.InitializeTopicListColumns;
var
  Column: TListColumn;
begin
  lvTopics.ViewStyle := vsReport;
  if lvTopics.Columns.Count > 0 then Exit;

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
  Column.Width := 50;
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
  FTopicListModel.Clear; //kt //codex 9/18/26
  FCurrentTopicEntries.Clear; //kt //codex 9/22/26
  FCurrentTopicName := ''; //kt //codex 9/22/26
  FCurrentTopicPropertyID := ''; //kt //codex 9/22/26
  FPendingTopicHTML := ''; //kt //codex 9/17/26
  wbDisplayPrior.Navigate('about:blank'); //kt //codex 9/17/26
  if Patient.DFN = '' then Exit;

  TopicListData := TStringList.Create;
  try
    Status := TopicList(TopicListData);
    if Piece(Status, '^', 1) <> '1' then Exit;

    lvTopics.Items.BeginUpdate;
    try
      for Index := 0 to TopicListData.Count - 1 do
      begin
        TopicData := TTopicListItemData.Create;
        TopicData.PropertyID := Piece(TopicListData[Index], '^', 1);
        TopicData.LastUsedFMDate := MakeFMDateTime(Piece(TopicListData[Index], '^', 2));
        TopicData.TopicName := Piece(TopicListData[Index], '^', 3); //kt //codex 9/18/26
        TopicData.Hidden := Piece(TopicListData[Index], '^', 4); //kt //codex 9/18/26
        TopicData.UserData := Piece(TopicListData[Index], '^', 5); //kt //codex 9/18/26
        FTopicListModel.AddObject(TopicData.TopicName, TopicData); //kt //codex 9/18/26
        ListItem := lvTopics.Items.Add;
        ListItem.Data := TopicData;
        //kt //codex original --> ListItem.Caption := Piece(TopicListData[Index], '^', 3);
        ListItem.Caption := TopicData.TopicName; //kt //codex 9/18/26
        if TopicData.LastUsedFMDate > 0 then
          ListItem.SubItems.Add(FormatFMDateTime('mm/dd/yy', TopicData.LastUsedFMDate))
        else
          ListItem.SubItems.Add('');
        //kt //codex original --> ListItem.SubItems.Add(Piece(TopicListData[Index], '^', 5));
        ListItem.SubItems.Add(TopicData.UserData); //kt //codex 9/18/26
        //kt //codex original --> ListItem.SubItems.Add(Piece(TopicListData[Index], '^', 4));
        ListItem.SubItems.Add(TopicData.Hidden); //kt //codex 9/18/26
      end;
    finally
      lvTopics.Items.EndUpdate;
    end;
    lvTopics.CustomSort(nil, 0); //kt //codex 9/18/26
  finally
    TopicListData.Free;
  end;
end;

function TfrmTopics.FindTopicSortKey(ColumnIndex: Integer): Integer;
//kt //codex added entire function 9/22/26
var
  SortKeyIndex: Integer;
begin
  Result := -1;
  for SortKeyIndex := 0 to FTopicSortKeys.Count - 1 do
    if FTopicSortKeys[SortKeyIndex].ColumnIndex = ColumnIndex then
    begin
      Result := SortKeyIndex;
      Exit;
    end;
end;

function TfrmTopics.CompareTopicListItems(Item1, Item2: TListItem; ColumnIndex: Integer): Integer;
//kt //codex added entire function 9/22/26
var
  TopicData1: TTopicListItemData;
  TopicData2: TTopicListItemData;
begin
  if ColumnIndex = 0 then
    Result := CompareText(Item1.Caption, Item2.Caption)
  else if ColumnIndex = 1 then
  begin
    TopicData1 := TTopicListItemData(Item1.Data);
    TopicData2 := TTopicListItemData(Item2.Data);
    if TopicData1.LastUsedFMDate < TopicData2.LastUsedFMDate then
      Result := -1
    else if TopicData1.LastUsedFMDate > TopicData2.LastUsedFMDate then
      Result := 1
    else
      Result := 0;
  end
  else
    Result := CompareText(Item1.SubItems[ColumnIndex - 1], Item2.SubItems[ColumnIndex - 1]);
end;

procedure TfrmTopics.lvTopicsColumnClick(Sender: TObject; Column: TListColumn);
var
  SortKey: TTopicSortKey;
  SortKeyIndex: Integer;
begin
  SortKeyIndex := FindTopicSortKey(Column.Index);
  if GetKeyState(VK_CONTROL) < 0 then
  begin
    if SortKeyIndex >= 0 then
    begin
      SortKey := FTopicSortKeys[SortKeyIndex];
      SortKey.Ascending := not SortKey.Ascending;
      FTopicSortKeys[SortKeyIndex] := SortKey;
    end
    else
    begin
      SortKey.ColumnIndex := Column.Index;
      SortKey.Ascending := True;
      FTopicSortKeys.Add(SortKey);
    end;
  end
  else if (SortKeyIndex = 0) and (FTopicSortKeys.Count = 1) then
  begin
    SortKey := FTopicSortKeys[0];
    SortKey.Ascending := not SortKey.Ascending;
    FTopicSortKeys[0] := SortKey;
  end
  else
  begin
    FTopicSortKeys.Clear;
    SortKey.ColumnIndex := Column.Index;
    SortKey.Ascending := True;
    FTopicSortKeys.Add(SortKey);
  end;
  lvTopics.CustomSort(nil, 0);
  UpdateTopicListSortIndicators; //kt //codex 9/22/26
end;

procedure TfrmTopics.lvTopicsCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
//kt //codex added entire procedure 9/18/26
begin
  if cdsSelected in State then Exit;
  //kt //codex original --> if FTopicSortColumn = 0 then
  if FindTopicSortKey(0) >= 0 then //kt //codex 9/22/26
    Sender.Canvas.Brush.Color := clCream
  else
    Sender.Canvas.Brush.Color := clWhite;
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color + 1; //kt //codex 9/18/26
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color - 1; //kt //codex 9/18/26
end;

procedure TfrmTopics.lvTopicsCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
//kt //codex added entire procedure 9/18/26
begin
  if cdsSelected in State then Exit;
  //kt //codex original --> if SubItem = FTopicSortColumn then
  if FindTopicSortKey(SubItem) >= 0 then //kt //codex 9/22/26
    Sender.Canvas.Brush.Color := clCream
  else
    Sender.Canvas.Brush.Color := clWhite;
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color + 1; //kt //codex 9/18/26
  Sender.Canvas.Brush.Color := Sender.Canvas.Brush.Color - 1; //kt //codex 9/18/26
end;

procedure TfrmTopics.UpdateTopicListSortIndicators;
//kt //codex added entire procedure 9/18/26
var
  ColumnIndex: Integer;
  SortGlyph: string; //kt //codex 9/22/26
  SortKey: TTopicSortKey; //kt //codex 9/22/26
  SortKeyIndex: Integer; //kt //codex 9/22/26
begin
  for ColumnIndex := 0 to lvTopics.Columns.Count - 1 do
  begin
    lvTopics.Columns[ColumnIndex].Caption := TOPIC_COLUMN_CAPTIONS[ColumnIndex];
    //kt //codex original --> if ColumnIndex = FTopicSortColumn then
    SortKeyIndex := FindTopicSortKey(ColumnIndex); //kt //codex 9/22/26
    if SortKeyIndex >= 0 then //kt //codex 9/22/26
    begin
      SortKey := FTopicSortKeys[SortKeyIndex]; //kt //codex 9/22/26
      //kt //codex original --> if FTopicSortAscending then
      if SortKey.Ascending then //kt //codex 9/22/26
        SortGlyph := TOPIC_SORT_ASCENDING_GLYPH //kt //codex 9/22/26
      else
        SortGlyph := TOPIC_SORT_DESCENDING_GLYPH; //kt //codex 9/22/26
      //kt //codex original --> lvTopics.Columns[ColumnIndex].Caption := TOPIC_SORT_ASCENDING_GLYPH + ' ' + lvTopics.Columns[ColumnIndex].Caption
      //kt //codex original --> lvTopics.Columns[ColumnIndex].Caption := TOPIC_SORT_DESCENDING_GLYPH + ' ' + lvTopics.Columns[ColumnIndex].Caption;
      lvTopics.Columns[ColumnIndex].Caption := IntToStr(SortKeyIndex + 1) + SortGlyph + ' ' + lvTopics.Columns[ColumnIndex].Caption; //kt //codex 9/22/26
    end;
  end;
  lvTopics.Invalidate;
end;

procedure TfrmTopics.lvTopicsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  SortKey: TTopicSortKey; //kt //codex 9/22/26
  SortKeyIndex: Integer; //kt //codex 9/22/26
begin
  //kt //codex original --> if FTopicSortColumn = 0 then
  //kt //codex original -->   Compare := CompareText(Item1.Caption, Item2.Caption)
  //kt //codex original --> else if FTopicSortColumn = 1 then
  //kt //codex original --> begin
  //kt //codex original -->   TopicData1 := TTopicListItemData(Item1.Data);
  //kt //codex original -->   TopicData2 := TTopicListItemData(Item2.Data);
  //kt //codex original -->   if TopicData1.LastUsedFMDate < TopicData2.LastUsedFMDate then
  //kt //codex original -->     Compare := -1
  //kt //codex original -->   else if TopicData1.LastUsedFMDate > TopicData2.LastUsedFMDate then
  //kt //codex original -->     Compare := 1
  //kt //codex original -->   else
  //kt //codex original -->     Compare := 0;
  //kt //codex original --> end
  //kt //codex original --> else
  //kt //codex original -->   Compare := CompareText(Item1.SubItems[FTopicSortColumn - 1], Item2.SubItems[FTopicSortColumn - 1]);
  //kt //codex original --> if not FTopicSortAscending then Compare := -Compare;
  Compare := 0; //kt //codex 9/22/26
  for SortKeyIndex := 0 to FTopicSortKeys.Count - 1 do //kt //codex 9/22/26
  begin
    SortKey := FTopicSortKeys[SortKeyIndex]; //kt //codex 9/22/26
    Compare := CompareTopicListItems(Item1, Item2, SortKey.ColumnIndex); //kt //codex 9/22/26
    if not SortKey.Ascending then Compare := -Compare; //kt //codex 9/22/26
    if Compare <> 0 then Exit; //kt //codex 9/22/26
  end;
  Compare := CompareText(TTopicListItemData(Item1.Data).PropertyID, TTopicListItemData(Item2.Data).PropertyID); //kt //codex 9/22/26
end;

function TfrmTopics.TopicListColumnAt(X: Integer): Integer;
//kt //codex added entire function 9/21/26
var
  ColumnIndex: Integer;
  ColumnLeft: Integer;
begin
  Result := -1;
  //kt //codex original --> ColumnLeft := GetScrollPos(lvTopics.Handle, SB_HORZ);
  ColumnLeft := 0; //kt //codex 9/21/26
  X := X + GetScrollPos(lvTopics.Handle, SB_HORZ); //kt //codex 9/21/26
  for ColumnIndex := 0 to lvTopics.Columns.Count - 1 do
  begin
    //kt //codex original --> if (X + ColumnLeft >= ColumnLeft) and (X + ColumnLeft < ColumnLeft + lvTopics.Columns[ColumnIndex].Width) then
    if (X >= ColumnLeft) and (X < ColumnLeft + lvTopics.Columns[ColumnIndex].Width) then //kt //codex 9/21/26
    begin
      Result := ColumnIndex;
      Exit;
    end;
    Inc(ColumnLeft, lvTopics.Columns[ColumnIndex].Width);
  end;
end;

function TfrmTopics.TopicListItemAt(X, Y: Integer; out ColumnIndex: Integer): TListItem;
//kt //codex added entire function 9/21/26
var
  HitTest: TLVHitTestInfo;
begin
  Result := nil;
  ColumnIndex := -1;
  FillChar(HitTest, SizeOf(HitTest), 0);
  HitTest.pt := Point(X, Y);
  //kt //codex original --> if ListView_SubItemHitTest(lvTopics.Handle, HitTest) < 0 then Exit;
  if ListView_SubItemHitTest(lvTopics.Handle, @HitTest) < 0 then Exit; //kt //codex 9/21/26
  if (HitTest.iItem < 0) or (HitTest.iItem >= lvTopics.Items.Count) then Exit;
  Result := lvTopics.Items[HitTest.iItem];
  ColumnIndex := HitTest.iSubItem;
end;

procedure TfrmTopics.QueueTopicChange(TopicData: TTopicListItemData; HiddenChanged, UserDataChanged: Boolean);
//kt //codex added entire procedure 9/21/26
var
  //kt //codex original --> ChangeIndex: Integer;
  TopicChange: TTopicChange;
begin
  if (TopicData = nil) or ((not HiddenChanged) and (not UserDataChanged)) then Exit;
  //kt //codex original --> ChangeIndex := FTopicChanges.IndexOf(TopicData.PropertyID);
  //kt //codex original --> if ChangeIndex < 0 then
  if not FTopicChanges.TryGetValue(TopicData.PropertyID, TopicChange) then begin//kt //codex 9/22/26
    TopicChange := TTopicChange.Create;
    TopicChange.PropertyID := TopicData.PropertyID; //kt //codex 9/22/26
    //kt //codex original --> FTopicChanges.AddObject(TopicData.PropertyID, TopicChange);
    FTopicChanges.Add(TopicData.PropertyID, TopicChange); //kt //codex 9/22/26
  end;
  //kt //codex original --> else
  //kt //codex original -->   TopicChange := TTopicChange(FTopicChanges.Objects[ChangeIndex]);
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
//kt //codex added entire procedure 9/22/26
var
  TopicChange: TTopicChange;
  EntryChange: TTopicEntryChange;
begin
  if (PropertyID = '') or (EntryFMDate = '') or ((not HiddenChanged) and (not UserDataChanged)) then Exit;
  if not FTopicChanges.TryGetValue(PropertyID, TopicChange) then
  begin
    TopicChange := TTopicChange.Create;
    TopicChange.PropertyID := PropertyID;
    FTopicChanges.Add(PropertyID, TopicChange);
  end;
  if not TopicChange.EntryChanges.TryGetValue(EntryFMDate, EntryChange) then
  begin
    EntryChange := TTopicEntryChange.Create;
    TopicChange.EntryChanges.Add(EntryFMDate, EntryChange);
  end;
  if HiddenChanged then
  begin
    EntryChange.HiddenChanged := True;
    EntryChange.Hidden := Hidden;
  end;
  if UserDataChanged then
  begin
    EntryChange.UserDataChanged := True;
    EntryChange.UserData := UserData;
  end;
  RestartTopicSaveTimer;
end;

procedure TfrmTopics.RestartTopicSaveTimer;
//kt //codex added entire procedure 9/21/26
begin
  if FTopicChanges.Count = 0 then Exit;
  timSaveTopicChanges.Enabled := False;
  timSaveTopicChanges.Enabled := True;
end;

procedure TfrmTopics.ToggleTopicHidden(ListItem: TListItem);
//kt //codex added entire procedure 9/21/26
var
  TopicData: TTopicListItemData;
begin
  if ListItem.Data = nil then Exit;
  TopicData := TTopicListItemData(ListItem.Data);
  if TopicData.Hidden = 'YES' then
    TopicData.Hidden := ''
  else
    TopicData.Hidden := 'YES';
  while ListItem.SubItems.Count <= TOPIC_HIDDEN_SUBITEM do ListItem.SubItems.Add('');
  ListItem.SubItems[TOPIC_HIDDEN_SUBITEM] := TopicData.Hidden;
  QueueTopicChange(TopicData, True, False); //kt //codex 9/21/26
end;

procedure TfrmTopics.ToggleTopicEntryHidden(const EntryFMDate: string);
//kt //codex added entire procedure 9/22/26
var
  EntryHidden: string;
  Index: Integer;
  temp : string;
begin
  if (FCurrentTopicPropertyID = '') or (EntryFMDate = '') then Exit;
  for Index := 0 to FCurrentTopicEntries.Count - 1 do
  begin
    if (Piece(FCurrentTopicEntries[Index], '^', 1) = '1') and (Piece(FCurrentTopicEntries[Index], '^', 2) = EntryFMDate) then
    begin
      EntryHidden := Piece(FCurrentTopicEntries[Index], '^', 4);
      if EntryHidden <> '' then
        EntryHidden := ''
      else
        EntryHidden := 'YES';
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
//kt //codex added entire procedure 9/21/26
var
  Status: string;
begin
  timSaveTopicChanges.Enabled := False;
  if FTopicChanges.Count = 0 then Exit;
  Status := SaveTopicChanges(FTopicChanges);
  if Piece(Status, '^', 1) = '1' then FTopicChanges.Clear;
end;

procedure TfrmTopics.lvTopicsWindowProc(var Message: TMessage);
//kt //codex added entire procedure 9/21/26
//Using message handler because a native Windows TListView processes its left-button message to select the row before a normal
//  OnMouseDown/OnClick approach can reliably stop it. Intercepting the message lets Hidden toggle while preventing selection.

var
  ColumnIndex: Integer;
  ListItem: TListItem;
  X: Integer;
  Y: Integer;
begin
  if (Message.Msg = WM_LBUTTONDOWN) or (Message.Msg = WM_LBUTTONDBLCLK) then
  begin
    X := SmallInt(LoWord(Message.LParam));
    Y := SmallInt(HiWord(Message.LParam));
    //kt //codex original --> ListItem := lvTopics.GetItemAt(X, Y);
    ListItem := TopicListItemAt(X, Y, ColumnIndex); //kt //codex 9/21/26
    if ListItem <> nil then
    begin
      //kt //codex original --> ColumnIndex := TopicListColumnAt(X);
      if ColumnIndex > 0 then
      begin
        if ColumnIndex = TOPIC_HIDDEN_COLUMN then ToggleTopicHidden(ListItem);
        Exit;
      end;
    end;
  end;
  FTopicsListViewWindowProc(Message);
end;

function TfrmTopics.BuildTopicHTML(TopicData: TStrings; const DefaultTopicName: string): string;
//kt //codex added entire function 9/17/26
var
  HTMLLines: TStringList;
  DateText: string;
  EntryDate: TFMDateTime;
  EntryFMDate: string; //kt //codex 9/22/26
  EntryHidden: string;
  EntryIEN: string;
  EntryToggleText: string; //kt //codex 9/22/26
  EntryUserData: string;
  EntryOpen: Boolean;
  EntryTextOpen: Boolean; //kt //codex 9/22/26
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
  for Index := 0 to TopicData.Count - 1 do
  begin
    if Piece(TopicData[Index], '^', 1) = '0' then
    begin
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
    //kt //codex original -->     HTMLLines.Add('.topic-toc { background: #f5f9fc; border-right: 1px solid #c9d8e6; bottom: 0; box-sizing: border-box; left: 0; overflow-y: auto; padding: 9px 6px; position: fixed; top: 0; width: 120px; }');
    HTMLLines.Add('.topic-toc { background: #f5f9fc; border-right: 1px solid #c9d8e6; bottom: 0; display: block; left: 0; overflow-y: auto; padding: 9px 6px; position: fixed; top: 0; width: 120px; }'); //kt //codex 9/17/26
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
    HTMLLines.Add('.entry-hidden-toggle { color: #1f4e79; float: right; font-size: 11px; font-weight: normal; text-decoration: underline; }'); //kt //codex 9/22/26
    HTMLLines.Add('.entry-meta { background: #f7fafc; border-top: 1px solid #dce8f1; color: #555555; font-size: 11px; padding: 4px 9px; }');
    HTMLLines.Add('.entry-text { min-height: 1em; padding: 9px; white-space: pre-wrap; font-family: Consolas, Courier New, monospace; font-size: 12px; }');
    HTMLLines.Add('.empty { color: #666666; font-style: italic; }');
    HTMLLines.Add('.topic-bottom-spacer { height: 48px; }');
    HTMLLines.Add('</style></head><body><div class="topic-content">');
    //kt //codex original -->     TOCLines.Add('<nav class="topic-toc"><div class="toc-title">Entries</div>');
    TOCLines.Add('<div class="topic-toc"><div class="toc-title">Entries</div>'); //kt //codex 9/17/26
    HTMLLines.Add('<h1>' + HTMLEncode(TopicName, Modified) + '</h1>');
    if (TopicHidden <> '') or (TopicUserData <> '') then
    begin
      HTMLLines.Add('<div class="topic-meta">');
      if TopicHidden <> '' then HTMLLines.Add('<span>Hidden: ' + HTMLEncode(TopicHidden, Modified) + '</span>');
      if TopicUserData <> '' then HTMLLines.Add('<span>User data: ' + HTMLEncode(TopicUserData, Modified) + '</span>');
      HTMLLines.Add('</div>');
    end;

    EntryOpen := False;
    EntryCount := 0;
    for Index := 0 to TopicData.Count - 1 do
    begin
      if Piece(TopicData[Index], '^', 1) = '1' then
      begin
        //kt //codex original --> if EntryOpen then HTMLLines.Add('</div></div>');
        if EntryOpen then //kt //codex 9/22/26
        begin
          if EntryTextOpen then HTMLLines.Add('</div>'); //kt //codex 9/22/26
          HTMLLines.Add('</div>'); //kt //codex 9/22/26
        end;
        EntryFMDate := Piece(TopicData[Index], '^', 2); //kt //codex 9/22/26
        //kt //codex original --> EntryDate := MakeFMDateTime(Piece(TopicData[Index], '^', 2));
        EntryDate := MakeFMDateTime(EntryFMDate); //kt //codex 9/22/26
        if EntryDate > 0 then begin
          DateText := FormatDateTime('mmmm d, yyyy h:nn am/pm', FMDateTimeToDateTime(EntryDate)); //kt //codex 9/17/26
        end else begin
          DateText := Piece(TopicData[Index], '^', 2);
        end;
        if EntryDate > 0 then
          TOCDateText := FormatFMDateTime('mm/dd/yy', EntryDate)
        else
          TOCDateText := '(No date)';
        EntryIEN := Piece(TopicData[Index], '^', 3);
        EntryHidden := Piece(TopicData[Index], '^', 4);
        EntryUserData := Piece(TopicData[Index], '^', 5);
        Inc(EntryCount);
        TOCLines.Add('<a href="about:TopicEntry^topic-entry-' + IntToStr(EntryCount) + '">' + HTMLEncode(TOCDateText, Modified) + '</a>');
        HTMLLines.Add('<div class="topic-entry" id="topic-entry-' + IntToStr(EntryCount) + '">'); //kt //codex 9/17/26
        HTMLLines.Add('<div class="entry-heading">'); //kt //codex 9/22/26
        //kt //codex original --> if EntryIEN <> '' then
        if EntryIEN <> '' then //kt //codex 9/22/26
        begin
          //kt //codex original --> HTMLLines.Add('<div class="entry-heading"><a class="document-link" href="about:TopicDocument^' + HTMLEncode(EntryIEN, Modified) + '">' + HTMLEncode(DateText, Modified) + '</a></div>')
          HTMLLines.Add('<a class="document-link" href="about:TopicDocument^' + HTMLEncode(EntryIEN, Modified) + '">' + HTMLEncode(DateText, Modified) + '</a>'); //kt //codex 9/22/26
        end
        else
        begin
          //kt //codex original --> HTMLLines.Add('<div class="entry-heading">' + HTMLEncode(DateText, Modified) + '</div>');
          HTMLLines.Add(HTMLEncode(DateText, Modified)); //kt //codex 9/22/26
        end;
        if EntryHidden <> '' then //kt //codex 9/22/26
          //kt //codex original --> EntryToggleText := 'Hidden: Yes'
          EntryToggleText := 'Show' //kt //codex 9/22/26
        else
          //kt //codex original --> EntryToggleText := 'Hidden: No';
          EntryToggleText := 'Hide'; //kt //codex 9/22/26
        HTMLLines.Add('<a class="entry-hidden-toggle" href="about:TopicEntryHidden^' + HTMLEncode(EntryFMDate, Modified) + '">' + EntryToggleText + '</a>'); //kt //codex 9/22/26
        HTMLLines.Add('</div>'); //kt //codex 9/22/26
        //kt //codex original --> if EntryIEN <> '' then
        //kt //codex original -->   HTMLLines.Add('<div class="entry-heading"><a class="document-link" href="about:TopicDocument^' + HTMLEncode(EntryIEN, Modified) + '">' + HTMLEncode(DateText, Modified) + '</a></div>')
        //kt //codex original --> else
        //kt //codex original -->   HTMLLines.Add('<div class="entry-heading">' + HTMLEncode(DateText, Modified) + '</div>');
        if (EntryHidden <> '') or (EntryUserData <> '') then //kt //codex 9/17/26
        begin
          HTMLLines.Add('<div class="entry-meta">');
          //kt //codex original --> if EntryHidden <> '' then HTMLLines.Add('<span>Hidden: ' + HTMLEncode(EntryHidden, Modified) + '</span>');
          if EntryHidden <> '' then HTMLLines.Add('<span>(Hidden...)</span>'); //kt //codex 9/22/26
          if EntryUserData <> '' then HTMLLines.Add('<span>User data: ' + HTMLEncode(EntryUserData, Modified) + '</span>');
          HTMLLines.Add('</div>');
        end;
        //kt //codex original --> HTMLLines.Add('<div class="entry-text">');
        EntryTextOpen := EntryHidden = ''; //kt //codex 9/22/26
        if EntryTextOpen then HTMLLines.Add('<div class="entry-text">'); //kt //codex 9/22/26
        EntryOpen := True;
      end
      //kt //codex original --> else if (Piece(TopicData[Index], '^', 1) = '2') and EntryOpen then
      else if (Piece(TopicData[Index], '^', 1) = '2') and EntryTextOpen then //kt //codex 9/22/26
        HTMLLines.Add(HTMLEncode(Copy(TopicData[Index], 3, MaxInt), Modified));
    end;
    //kt //codex original -->     if EntryOpen then HTMLLines.Add('</div></article>');
    //kt //codex original --> if EntryOpen then HTMLLines.Add('</div></div>');
    if EntryOpen then //kt //codex 9/22/26
    begin
      if EntryTextOpen then HTMLLines.Add('</div>'); //kt //codex 9/22/26
      HTMLLines.Add('</div>'); //kt //codex 9/22/26
    end;
    if EntryCount = 0 then HTMLLines.Add('<p class="empty">No entries are recorded for this topic.</p>');
    HTMLLines.Add('<div class="topic-bottom-spacer"></div>');
    if EntryCount = 0 then TOCLines.Add('<div class="toc-empty">None</div>');
    //kt //codex original -->     TOCLines.Add('</nav>');
    TOCLines.Add('</div>'); //kt //codex 9/17/26
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
//kt //codex added entire procedure 9/17/26
begin
  FPendingTopicHTML := HTML;
  WritePendingTopicHTML;
end;

procedure TfrmTopics.WritePendingTopicHTML;
//kt //codex added entire procedure 9/17/26
var
  HTML: string;
  WebDoc: IHTMLDocument2;
  V: Variant;
begin
  if FPendingTopicHTML = '' then Exit;
  if not Assigned(wbDisplayPrior.Document) then
  begin
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
end;

procedure TfrmTopics.lvTopicsClick(Sender: TObject);
//kt //codex added entire procedure 9/17/26
var
  ErrorText: string;
  ListItem: TListItem;
  Status: string;
  TopicData: TTopicListItemData;
  //kt //codex original --> TopicEntries: TStringList;
  Modified: Boolean;
begin
  if Patient.DFN = '' then Exit;
  ListItem := lvTopics.Selected;
  if (ListItem = nil) or (ListItem.Data = nil) then Exit;
  TopicData := TTopicListItemData(ListItem.Data);
  //kt //codex original --> TopicEntries := TStringList.Create;
  //kt //codex original --> try
  //kt //codex original -->   Status := Get1Topic(TopicEntries, TopicData.PropertyID);
  //kt //codex original -->   if Piece(Status, '^', 1) = '1' then
  //kt //codex original -->     DisplayTopicHTML(BuildTopicHTML(TopicEntries, ListItem.Caption))
  //kt //codex original -->   else
  //kt //codex original -->   begin
  //kt //codex original -->     ErrorText := Piece(Status, '^', 2);
  //kt //codex original -->     if ErrorText = '' then ErrorText := 'The topic could not be retrieved.';
  //kt //codex original -->     DisplayTopicHTML('<html><body><h1>' + HTMLEncode(ListItem.Caption, Modified) + '</h1><p>' +
  //kt //codex original -->       HTMLEncode(ErrorText, Modified) + '</p></body></html>');
  //kt //codex original -->   end;
  //kt //codex original --> finally
  //kt //codex original -->   TopicEntries.Free;
  //kt //codex original --> end;
  FCurrentTopicEntries.Clear; //kt //codex 9/22/26
  FCurrentTopicName := ''; //kt //codex 9/22/26
  FCurrentTopicPropertyID := ''; //kt //codex 9/22/26
  Status := Get1Topic(FCurrentTopicEntries, TopicData.PropertyID); //kt //codex 9/22/26
  if Piece(Status, '^', 1) = '1' then
  begin
    FCurrentTopicName := TopicData.TopicName; //kt //codex 9/22/26
    FCurrentTopicPropertyID := TopicData.PropertyID; //kt //codex 9/22/26
    DisplayTopicHTML(BuildTopicHTML(FCurrentTopicEntries, FCurrentTopicName)); //kt //codex 9/22/26
  end
  else
  begin
    ErrorText := Piece(Status, '^', 2);
    if ErrorText = '' then ErrorText := 'The topic could not be retrieved.';
    DisplayTopicHTML('<html><body><h1>' + HTMLEncode(ListItem.Caption, Modified) + '</h1><p>' +
      HTMLEncode(ErrorText, Modified) + '</p></body></html>');
  end;
end;

procedure TfrmTopics.wbDisplayPriorDocumentComplete(Sender: TObject; const pDisp: IDispatch; const URL: OleVariant);
//kt //codex added entire procedure 9/17/26
begin
  WritePendingTopicHTML;
end;

procedure TfrmTopics.wbDisplayPriorBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
//kt //codex added entire procedure 9/17/26
begin
  if Piece(Piece(URL, '^', 1), ':', 2) = 'TopicDocument' then
  begin
    Cancel := True;
    NavigateToDocument(Piece(URL, '^', 2));
  end;
  if Piece(Piece(URL, '^', 1), ':', 2) = 'TopicEntry' then
  begin
    Cancel := True;
    ScrollTopicEntryIntoView(Piece(URL, '^', 2));
  end;
  if Piece(Piece(URL, '^', 1), ':', 2) = 'TopicEntryHidden' then //kt //codex 9/22/26
  begin
    Cancel := True; //kt //codex 9/22/26
    ToggleTopicEntryHidden(Piece(URL, '^', 2)); //kt //codex 9/22/26
  end;
end;

procedure TfrmTopics.NavigateToDocument(const DocumentIEN: string);
//kt //codex added entire procedure 9/17/26
begin
  // Future Topics document navigation will be implemented here.
end;

procedure TfrmTopics.ScrollTopicEntryIntoView(const EntryID: string);
var
  Document: IHTMLDocument3;
  EntryElement: IHTMLElement;
begin
  if not Assigned(wbDisplayPrior.Document) then Exit;
  Document := wbDisplayPrior.Document as IHTMLDocument3;
  if not Assigned(Document) then Exit;
  EntryElement := Document.getElementById(EntryID);
  if Assigned(EntryElement) then EntryElement.scrollIntoView(True);
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
//kt //codex added entire procedure 9/18/26
var
  Child: TControl;
  Index: Integer;
begin
  TControlCracker(AParent).OnMouseDown := pnlTopicsElsewhereMouseDown;
  for Index := 0 to AParent.ControlCount - 1 do
  begin
    Child := AParent.Controls[Index];
    if Child is TWinControl then
      ConfigureTopicsElsewhereMouseDown(TWinControl(Child))
    else
      TControlCracker(Child).OnMouseDown := pnlTopicsElsewhereMouseDown;
  end;
end;

procedure TfrmTopics.CloseTopicsLeftWithoutDelay;
//kt //codex added entire procedure 9/18/26
begin
  timTopicsLeftCollapse.Enabled := False;
  if FTopicsLeftPinned then Exit; //kt //codex 9/18/26
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
  btnTopicsLeftHandleLegacy.Left := btnTopicsLeftHandle.Left; //kt //codex 9/18/26
  btnTopicsLeftHandleLegacy.Top := (pnlTopicsLeft.Height - btnTopicsLeftHandleLegacy.Height) div 2; //kt //codex 9/18/26
  btnTopicsLeftHandle.BringToFront;
  PositionTopicsLeftPin; //kt //codex 9/18/26
end;

procedure TfrmTopics.PositionTopicsLeftPin;
//kt //codex added entire procedure 9/18/26
begin
  btnTopicsLeftPin.Left := splTopicsLeft.Left - (btnTopicsLeftPin.Width div 2) + (splTopicsLeft.Width div 2);
  btnTopicsLeftPin.Top := splTopicsLeft.Top + splTopicsLeft.Height - btnTopicsLeftPin.Height;
  btnTopicsLeftPin.BringToFront;
end;

procedure TfrmTopics.PositionTopicsRightHandle;
//kt //codex added entire procedure 9/18/26
begin
  btnTopicsRightHandle.Left := splTopicsRight.Left - (btnTopicsRightHandle.Width div 2) + (splTopicsRight.Width div 2);
  btnTopicsRightHandle.Top := (pnlTopicsRight.Height - btnTopicsRightHandle.Height) div 2;
  btnTopicsRightHandleLegacy.Left := btnTopicsRightHandle.Left; //kt //codex 9/18/26
  btnTopicsRightHandleLegacy.Top := (pnlTopicsRight.Height - btnTopicsRightHandleLegacy.Height) div 2; //kt //codex 9/18/26
  btnTopicsRightHandle.BringToFront;
end;

procedure TfrmTopics.QueueTopicsLeftCollapse;
begin
  if FTopicsLeftPinned then Exit; //kt //codex 9/18/26
  timTopicsLeftCollapse.Enabled := False;
  timTopicsLeftCollapse.Enabled := True;
end;

procedure TfrmTopics.QueueHideTopicsLeftHandle;
begin
  if FTopicsLeftPinned then Exit; //kt //codex 9/18/26
  timHideTopicsLeftHandle.Enabled := False;
  timHideTopicsLeftHandle.Enabled := True;
end;

procedure TfrmTopics.SetTopicsLeftOpen(Value: Boolean);
begin
  //kt //codex original --> FTopicsLeftOpen := Value;
  //kt //codex original --> if FTopicsLeftOpen then
  //kt //codex original -->   pnlTopicsLeft.Width := FTopicsLeftOpenWidth
  //kt //codex original --> else
  //kt //codex original -->   pnlTopicsLeft.Width := FTopicsLeftClosedWidth;
  if FTopicsLeftOpen = Value then Exit; //kt //codex 9/18/26
  FTopicsLeftOpen := Value; //kt //codex 9/18/26
  FTopicsLeftAnimationStartWidth := pnlTopicsLeft.Width; //kt //codex 9/18/26
  if FTopicsLeftOpen then //kt //codex 9/18/26
    FTopicsLeftAnimationTargetWidth := FTopicsLeftOpenWidth //kt //codex 9/18/26
  else //kt //codex 9/18/26
    FTopicsLeftAnimationTargetWidth := FTopicsLeftClosedWidth; //kt //codex 9/18/26
  FTopicsLeftAnimationStep := 0; //kt //codex 9/18/26
  FTopicsLeftAnimating := FTopicsLeftAnimationStartWidth <> FTopicsLeftAnimationTargetWidth; //kt //codex 9/18/26
  UpdateTopicsLeftHandleGlyph;
  PositionTopicsLeftHandle;
  timTopicsLeftAnimate.Enabled := FTopicsLeftAnimating; //kt //codex 9/18/26
end;

procedure TfrmTopics.SetTopicsRightOpen(Value: Boolean);
//kt //codex added entire procedure 9/18/26
begin
  if FTopicsRightOpen = Value then Exit;
  FTopicsRightOpen := Value;
  FTopicsRightAnimationStartWidth := pnlTopicsRight.Width;
  if FTopicsRightOpen then
    FTopicsRightAnimationTargetWidth := FTopicsRightOpenWidth
  else
    FTopicsRightAnimationTargetWidth := FTopicsRightClosedWidth;
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
  if FTopicsLeftAnimating then Exit; //kt //codex 9/18/26
  if FTopicsLeftOpen then
    FTopicsLeftOpenWidth := pnlTopicsLeft.Width //kt //codex 9/18/26
  else
    FTopicsLeftClosedWidth := pnlTopicsLeft.Width; //kt //codex 9/18/26
  if FTopicsLoaded then //kt //codex 9/18/26
  begin //kt //codex 9/18/26
    if FTopicsLeftOpen then //kt //codex 9/18/26
      uTMGOptions.WriteInteger(TOPICS_LEFT_OPEN_SIZE_KEY, FTopicsLeftOpenWidth) //kt //codex 9/18/26
    else //kt //codex 9/18/26
      uTMGOptions.WriteInteger(TOPICS_LEFT_CLOSED_SIZE_KEY, FTopicsLeftClosedWidth); //kt //codex 9/18/26
  end; //kt //codex 9/18/26
  PositionTopicsLeftHandle;
end;

procedure TfrmTopics.splTopicsRightMoved(Sender: TObject);
//kt //codex added entire procedure 9/18/26
begin
  if FTopicsRightAnimating then Exit;
  if FTopicsRightOpen then
    FTopicsRightOpenWidth := pnlTopicsRight.Width
  else
    FTopicsRightClosedWidth := pnlTopicsRight.Width;
  if FTopicsLoaded then
  begin
    if FTopicsRightOpen then
      uTMGOptions.WriteInteger(TOPICS_RIGHT_OPEN_SIZE_KEY, FTopicsRightOpenWidth)
    else
      uTMGOptions.WriteInteger(TOPICS_RIGHT_CLOSED_SIZE_KEY, FTopicsRightClosedWidth);
  end;
  PositionTopicsRightHandle;
end;

procedure TfrmTopics.pnlTopicsLeftMouseEnter(Sender: TObject);
begin
  if FTopicsLeftPinned then Exit; //kt //codex 9/18/26
  timTopicsLeftCollapse.Enabled := False;
  SetTopicsLeftOpen(True);
end;

procedure TfrmTopics.pnlTopicsLeftMouseLeave(Sender: TObject);
begin
  if FTopicsLeftPinned then Exit; //kt //codex 9/18/26
  QueueTopicsLeftCollapse;
end;

procedure TfrmTopics.splTopicsLeftMouseEnter(Sender: TObject);
begin
  if FTopicsLeftPinned then Exit; //kt //codex 9/18/26
  timTopicsLeftCollapse.Enabled := False;
  ShowTopicsLeftHandle;
end;

procedure TfrmTopics.splTopicsLeftMouseLeave(Sender: TObject);
begin
  if FTopicsLeftPinned then Exit; //kt //codex 9/18/26
  QueueTopicsLeftCollapse;
  QueueHideTopicsLeftHandle;
end;

procedure TfrmTopics.btnTopicsLeftHandleClick(Sender: TObject);
begin
  if FTopicsLeftPinned then Exit; //kt //codex 9/18/26
  SetTopicsLeftOpen(not FTopicsLeftOpen);
  ShowTopicsLeftHandle;
end;

procedure TfrmTopics.btnTopicsRightHandleClick(Sender: TObject);
//kt //codex added entire procedure 9/18/26
begin
  SetTopicsRightOpen(not FTopicsRightOpen);
end;

procedure TfrmTopics.btnTopicsLeftPinClick(Sender: TObject);
//kt //codex added entire procedure 9/18/26
begin
  FTopicsLeftPinned := not FTopicsLeftPinned;
  timTopicsLeftCollapse.Enabled := False;
  timHideTopicsLeftHandle.Enabled := False;
  if FTopicsLeftPinned then
  begin
    timTopicsLeftAnimate.Enabled := False;
    if FTopicsLeftAnimating then
      pnlTopicsLeft.Width := FTopicsLeftAnimationTargetWidth;
    FTopicsLeftAnimating := False;
    PositionTopicsLeftHandle;
    HideTopicsLeftHandle;
  end;
  UpdateTopicsLeftPinGlyph;
end;

procedure TfrmTopics.btnTopicsLeftHandleMouseEnter(Sender: TObject);
begin
  if FTopicsLeftPinned then Exit; //kt //codex 9/18/26
  timTopicsLeftCollapse.Enabled := False;
  timHideTopicsLeftHandle.Enabled := False;
  splTopicsLeft.Color := clSkyBlue;
end;

procedure TfrmTopics.btnTopicsLeftHandleMouseLeave(Sender: TObject);
begin
  if FTopicsLeftPinned then Exit; //kt //codex 9/18/26
  QueueTopicsLeftCollapse;
  QueueHideTopicsLeftHandle;
end;

procedure TfrmTopics.timTopicsLeftCollapseTimer(Sender: TObject);
begin
  if FTopicsLeftPinned then
  begin
    timTopicsLeftCollapse.Enabled := False;
    Exit;
  end;
  if GetCapture <> 0 then Exit;
  //kt //codex original --> if CursorOverControl(pnlTopicsLeft) or CursorOverControl(splTopicsLeft) or CursorOverControl(btnTopicsLeftHandle) then Exit;
  if CursorOverControl(pnlTopicsLeft) or CursorOverControl(splTopicsLeft) or CursorOverControl(btnTopicsLeftHandle) or CursorOverControl(btnTopicsLeftPin) then Exit; //kt //codex 9/18/26
  timTopicsLeftCollapse.Enabled := False;
  SetTopicsLeftOpen(False);
end;

procedure TfrmTopics.timTopicsLeftAnimateTimer(Sender: TObject);
//kt //codex added entire procedure 9/18/26
begin
  Inc(FTopicsLeftAnimationStep);
  pnlTopicsLeft.Width := FTopicsLeftAnimationStartWidth +
    ((FTopicsLeftAnimationTargetWidth - FTopicsLeftAnimationStartWidth) * FTopicsLeftAnimationStep div TOPICS_PANE_ANIMATION_STEPS);
  PositionTopicsLeftHandle;
  if FTopicsLeftAnimationStep >= TOPICS_PANE_ANIMATION_STEPS then
  begin
    pnlTopicsLeft.Width := FTopicsLeftAnimationTargetWidth;
    FTopicsLeftAnimating := False;
    timTopicsLeftAnimate.Enabled := False;
    PositionTopicsLeftHandle;
  end;
end;

procedure TfrmTopics.timTopicsRightAnimateTimer(Sender: TObject);
//kt //codex added entire procedure 9/18/26
begin
  Inc(FTopicsRightAnimationStep);
  pnlTopicsRight.Width := FTopicsRightAnimationStartWidth +
    ((FTopicsRightAnimationTargetWidth - FTopicsRightAnimationStartWidth) * FTopicsRightAnimationStep div TOPICS_PANE_ANIMATION_STEPS);
  PositionTopicsRightHandle;
  if FTopicsRightAnimationStep >= TOPICS_PANE_ANIMATION_STEPS then
  begin
    pnlTopicsRight.Width := FTopicsRightAnimationTargetWidth;
    FTopicsRightAnimating := False;
    timTopicsRightAnimate.Enabled := False;
    PositionTopicsRightHandle;
  end;
end;

procedure TfrmTopics.timHideTopicsLeftHandleTimer(Sender: TObject);
begin
  if CursorOverControl(splTopicsLeft) or CursorOverControl(btnTopicsLeftHandle) then Exit;
  HideTopicsLeftHandle;
end;

procedure TfrmTopics.UpdateTopicsLeftHandleGlyph;
var
  Bitmap: TBitmap;
  ImageIndex: Integer;
begin
  if FTopicsLeftOpen then
    ImageIndex := 1
  else
    ImageIndex := 0;
  if FTopicsLeftOpen then //kt //codex 9/18/26
    btnTopicsLeftHandle.LoadGlyph(ImageCollection1, TOPICS_IMAGE_ARROW_LEFT) //kt //codex 9/21/26
  else //kt //codex 9/18/26
    btnTopicsLeftHandle.LoadGlyph(ImageCollection1, TOPICS_IMAGE_ARROW_RIGHT); //kt //codex 9/21/26
  Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(TfrmFrame(Owner).ImageListSplitterHandle.Width, TfrmFrame(Owner).ImageListSplitterHandle.Height);
    TfrmFrame(Owner).ImageListSplitterHandle.GetBitmap(ImageIndex, Bitmap);
    //kt //codex original --> btnTopicsLeftHandle.Glyph.Assign(Bitmap);
    btnTopicsLeftHandleLegacy.Glyph.Assign(Bitmap); //kt //codex 9/18/26
  finally
    Bitmap.Free;
  end;
end;

procedure TfrmTopics.UpdateTopicsLeftPinGlyph;
//kt //codex added entire procedure 9/18/26
begin
  if FTopicsLeftPinned then
    btnTopicsLeftPin.LoadGlyph(ImageCollection1, TOPICS_IMAGE_PIN_DOWN_RED) //kt //codex 9/21/26
  else
    btnTopicsLeftPin.LoadGlyph(ImageCollection1, TOPICS_IMAGE_PIN_UP_BLUE); //kt //codex 9/21/26
end;

procedure TfrmTopics.UpdateTopicsRightHandleGlyph;
//kt //codex added entire procedure 9/18/26
var
  Bitmap: TBitmap;
  ImageIndex: Integer;
begin
  if FTopicsRightOpen then
    ImageIndex := 0
  else
    ImageIndex := 1;
  if FTopicsRightOpen then //kt //codex 9/18/26
    btnTopicsRightHandle.LoadGlyph(ImageCollection1, TOPICS_IMAGE_ARROW_RIGHT) //kt //codex 9/21/26
  else //kt //codex 9/18/26
    btnTopicsRightHandle.LoadGlyph(ImageCollection1, TOPICS_IMAGE_ARROW_LEFT); //kt //codex 9/21/26
  Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(TfrmFrame(Owner).ImageListSplitterHandle.Width, TfrmFrame(Owner).ImageListSplitterHandle.Height);
    TfrmFrame(Owner).ImageListSplitterHandle.GetBitmap(ImageIndex, Bitmap);
    //kt //codex original --> btnTopicsRightHandle.Glyph.Assign(Bitmap);
    btnTopicsRightHandleLegacy.Glyph.Assign(Bitmap); //kt //codex 9/18/26
  finally
    Bitmap.Free;
  end;
end;

procedure TfrmTopics.pnlTopicsElsewhereMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
//kt //codex added entire procedure 9/18/26
begin
  CloseTopicsLeftWithoutDelay;
end;

end.
