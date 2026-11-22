unit fRxHistory;
//kt added entire unit 11/2/26   //kt //codex
interface

uses
  //kt //codex original --> Windows, Classes, Controls, Graphics, ExtCtrls, Buttons, Forms, OleCtrls, SHDocVw,
  Windows, Messages, Classes, Controls, Graphics, ExtCtrls, Buttons, Forms, OleCtrls, SHDocVw, //kt //codex 11/22/26
  System.ImageList, Vcl.ImgList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  fPage, uPngGlyphButton, Vcl.ComCtrls, Vcl.StdCtrls, VA508AccessibilityManager, Vcl.Tabs, Vcl.DockTabSet;

const
  UM_RXHX_SELECT_FIRST = WM_APP + 271; //kt //codex 11/22/26

type
  TRxHxControlAccess = class(TControl);
  TfrmRxHistory = class(TfrmPage)
    splRxHxLeft: TSplitter;
    splRxHxRight: TSplitter;
    pnlRxHxLeft: TPanel;
    tcRxHxView: TTabControl;
    tvRxHx: TTreeView;
    pnlRxHxSettings: TPanel;
    cbRxHxParsed: TCheckBox;
    pnlRxHxCenter: TPanel;
    pnlRxHxNoteBar: TPanel; //kt //codex 11/3/26
    btnRxHxZoomOut, btnRxHxZoomNormal, btnRxHxZoomIn: TSpeedButton; //kt //codex 11/3/26
    pnlRxHxRight: TPanel;
    wbRxHxData: TWebBrowser;
    pnlRightFooter: TPanel;
    btnAddAssocTable: TBitBtn;
    timHideRxHxLeftHandle: TTimer;
    timRxHxLeftCollapse: TTimer;
    timRxHxLeftAnimate: TTimer;
    timRxHxRightAnimate: TTimer;
    ImageList1: TImageList;
    ImageCollection1: TImageCollection;
    procedure RxHxZoomClick(Sender: TObject); //kt //codex 11/3/26
    procedure cbRxHxParsedClick(Sender: TObject);
    function CursorOverControl(AControl: TControl): Boolean;
    procedure ConfigureRxHxElsewhereMouseDown(AParent: TWinControl);
    procedure CloseRxHxLeftWithoutDelay;
    procedure HideRxHxLeftHandle;
    procedure PositionRxHxLeftHandle;
    procedure PositionRxHxLeftPin;
    procedure PositionRxHxRightHandle;
    procedure QueueRxHxLeftCollapse;
    procedure NormalizeRxHxLeftPaneWidths;
    procedure NormalizeRxHxRightPaneWidths;
    procedure QueueHideRxHxLeftHandle;
    procedure SetRxHxLeftOpen(Value: Boolean);
    procedure SetRxHxRightOpen(Value: Boolean);
    procedure ShowRxHxLeftHandle;
    procedure splRxHxLeftMoved(Sender: TObject);
    procedure splRxHxRightMoved(Sender: TObject);
    procedure pnlRxHxLeftMouseEnter(Sender: TObject);
    procedure pnlRxHxLeftMouseLeave(Sender: TObject);
    procedure splRxHxLeftMouseEnter(Sender: TObject);
    procedure splRxHxLeftMouseLeave(Sender: TObject);
    procedure btnRxHxLeftHandleClick(Sender: TObject);
    procedure btnRxHxRightHandleClick(Sender: TObject);
    procedure btnRxHxLeftPinClick(Sender: TObject);
    procedure btnRxHxLeftHandleMouseEnter(Sender: TObject);
    procedure btnRxHxLeftHandleMouseLeave(Sender: TObject);
    procedure timRxHxLeftCollapseTimer(Sender: TObject);
    procedure timRxHxLeftAnimateTimer(Sender: TObject);
    procedure timRxHxRightAnimateTimer(Sender: TObject);
    procedure timHideRxHxLeftHandleTimer(Sender: TObject);
    procedure UpdateRxHxLeftHandleGlyph;
    procedure UpdateRxHxLeftPinGlyph;
    procedure UpdateRxHxRightHandleGlyph;
    procedure pnlRxHxElsewhereMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FRxHxSummary: TStringList;
    FRxHxSummaryLoaded: Boolean;
    //kt //codex original --> FRxHxNoteBar: TPanel;
    FRxHxNoteBrowser: TWebBrowser; //kt //codex 11/3/26
    FRxHxSelectionSerial: Integer; //kt //codex 11/3/26
    FRxHxRebuilding: Boolean; //kt //codex 11/22/26
    FRxHxTreeGeneration: Integer; //kt //codex 11/22/26
    FRxHxDateTree: TTreeView; //kt //codex 11/22/26
    FRxHxDisplayedNoteIEN: string; //kt //codex 11/22/26
    FRxHxDisplayedHighlight: string; //kt //codex 11/22/26
    FRxHxZoom: Integer; //kt //codex 11/3/26
    btnRxHxLeftHandle, btnRxHxRightHandle, btnRxHxLeftPin: TPngGlyphButton;
    FRxHxLeftOpen, FRxHxLeftPinned, FRxHxLeftAnimating: Boolean;
    FRxHxRightOpen, FRxHxRightAnimating, FRxHxLoaded: Boolean;
    FRxHxLeftOpenWidth, FRxHxLeftClosedWidth: Integer;
    FRxHxLeftAnimationStartWidth, FRxHxLeftAnimationTargetWidth, FRxHxLeftAnimationStep: Integer;
    FRxHxRightOpenWidth, FRxHxRightClosedWidth: Integer;
    FRxHxRightAnimationStartWidth, FRxHxRightAnimationTargetWidth, FRxHxRightAnimationStep: Integer;
    procedure RxHxTreeChange(Sender: TObject; Node: TTreeNode); //kt //codex 11/3/26
    procedure RxHxTreeExpanded(Sender: TObject; Node: TTreeNode); //kt //codex 11/22/26
    procedure UMRxHxSelectFirst(var Message: TMessage); message UM_RXHX_SELECT_FIRST; //kt //codex 11/22/26
    procedure RxHxViewChange(Sender: TObject); //kt //codex 11/3/26
    procedure RebuildRxHxDateTree; //kt //codex 11/3/26
    procedure RxHxTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); //kt //codex 11/3/26
    procedure LoadRxHxSummary;
    procedure RebuildRxHxTree;
  protected
    procedure Loaded; override;
    procedure Resize; override;
  public
    destructor Destroy; override;
    procedure ClearPtData; override;
    procedure DisplayPage; override;
  end;

var
  frmRxHistory: TfrmRxHistory;

implementation

//kt //codex original --> uses uTMGOptions;
//kt //codex original --> uses uTMGOptions, uCore, rRxHistory, Dialogs, ORFn;
//kt //codex original --> uses uTMGOptions, uCore, rRxHistory, Dialogs, ORFn, SysUtils;
uses uTMGOptions, uCore, rRxHistory, Dialogs, ORFn, SysUtils, rTIU, uHTMLTools; //kt //codex 11/3/26

{$R *.dfm}

const
  RXHX_PANE_ANIMATION_STEPS = 3;
  RXHX_PANE_ANIMATION_TIMESLICE_MS = 25;
  RXHX_LEFT_COLLAPSE_DELAY_MS = 500;
  RXHX_LEFT_COLLAPSE_RIGHT_DISTANCE = 100;
  RXHX_LEFT_PANE_MINIMUM_WIDTH_GAP = 50;
  RXHX_RIGHT_PANE_MINIMUM_WIDTH_GAP = 50;
  RXHX_LEFT_OPEN_SIZE_KEY = 'frmRxHistory.LeftPaneOpenSize';
  RXHX_LEFT_CLOSED_SIZE_KEY = 'frmRxHistory.LeftPaneClosedSize';
  RXHX_RIGHT_OPEN_SIZE_KEY = 'frmRxHistory.RightPaneOpenSize';
  RXHX_RIGHT_CLOSED_SIZE_KEY = 'frmRxHistory.RightPaneClosedSize';
  RXHX_RIGHT_OPEN_KEY = 'frmRxHistory.RightPaneOpen';
  RXHX_IMAGE_PIN_UP_BLUE = 1;
  RXHX_IMAGE_ARROW_LEFT = 2;
  RXHX_IMAGE_ARROW_RIGHT = 3;
  RXHX_IMAGE_PIN_DOWN_RED = 4;

procedure TfrmRxHistory.Loaded;
//kt //codex added entire procedure 11/2/26
begin
  inherited;
  FRxHxSummary := TStringList.Create;
  //kt //codex original --> FRxHxNoteBar := TPanel.Create(Self);
  //kt //codex original --> FRxHxNoteBar.Parent := pnlRxHxCenter;
  //kt //codex original --> FRxHxNoteBar.Align := alTop;
  //kt //codex original --> FRxHxNoteBar.Height := 15;
  FRxHxZoom := 100; //kt //codex 11/3/26
  FRxHxNoteBrowser := TWebBrowser.Create(Self); //kt //codex 11/3/26
  //kt //codex original --> FRxHxNoteBrowser.Parent := pnlRxHxCenter;
  TWinControl(FRxHxNoteBrowser).Parent := pnlRxHxCenter; //kt //codex 11/3/26
  FRxHxNoteBrowser.Align := alClient; //kt //codex 11/3/26
  tvRxHx.OnChange := RxHxTreeChange; //kt //codex 11/3/26
  tvRxHx.OnExpanded := RxHxTreeExpanded; //kt //codex 11/22/26
  tcRxHxView.OnChange := RxHxViewChange; //kt //codex 11/3/26
  tvRxHx.OnMouseDown := RxHxTreeMouseDown; //kt //codex 11/3/26
  FRxHxDateTree := TTreeView.Create(Self); //kt //codex 11/22/26
  FRxHxDateTree.Parent := pnlRxHxLeft; //kt //codex 11/22/26
  FRxHxDateTree.Visible := False; //kt //codex 11/22/26
  FRxHxDateTree.Align := alClient; //kt //codex 11/22/26
  FRxHxDateTree.Indent := tvRxHx.Indent; //kt //codex 11/22/26
  FRxHxDateTree.ReadOnly := True; //kt //codex 11/22/26
  FRxHxDateTree.ShowLines := False; //kt //codex 11/22/26
  FRxHxDateTree.OnChange := RxHxTreeChange; //kt //codex 11/22/26
  FRxHxDateTree.OnMouseDown := RxHxTreeMouseDown; //kt //codex 11/22/26
  TRxHxControlAccess(FRxHxDateTree).OnMouseEnter := pnlRxHxLeftMouseEnter; //kt //codex 11/22/26
  TRxHxControlAccess(FRxHxDateTree).OnMouseLeave := pnlRxHxLeftMouseLeave; //kt //codex 11/22/26
  btnRxHxLeftHandle := TPngGlyphButton.Create(Self);
  btnRxHxLeftHandle.Name := 'btnRxHxLeftHandle';
  btnRxHxLeftHandle.Parent := Self;
  btnRxHxLeftHandle.Visible := False;
  btnRxHxLeftHandle.OnClick := btnRxHxLeftHandleClick;
  btnRxHxLeftHandle.OnMouseEnter := btnRxHxLeftHandleMouseEnter;
  btnRxHxLeftHandle.OnMouseLeave := btnRxHxLeftHandleMouseLeave;
  btnRxHxRightHandle := TPngGlyphButton.Create(Self);
  btnRxHxRightHandle.Name := 'btnRxHxRightHandle';
  btnRxHxRightHandle.Parent := Self;
  btnRxHxRightHandle.OnClick := btnRxHxRightHandleClick;
  btnRxHxLeftPin := TPngGlyphButton.Create(Self);
  btnRxHxLeftPin.Name := 'btnRxHxLeftPin';
  btnRxHxLeftPin.Parent := Self;
  btnRxHxLeftPin.OnClick := btnRxHxLeftPinClick;
  FRxHxLeftOpenWidth := uTMGOptions.ReadInteger(RXHX_LEFT_OPEN_SIZE_KEY, pnlRxHxLeft.Width);
  FRxHxLeftClosedWidth := uTMGOptions.ReadInteger(RXHX_LEFT_CLOSED_SIZE_KEY, splRxHxLeft.MinSize);
  NormalizeRxHxLeftPaneWidths;
  FRxHxLeftOpen := False;
  pnlRxHxLeft.Width := FRxHxLeftClosedWidth;
  FRxHxRightOpenWidth := uTMGOptions.ReadInteger(RXHX_RIGHT_OPEN_SIZE_KEY, pnlRxHxRight.Width);
  FRxHxRightClosedWidth := uTMGOptions.ReadInteger(RXHX_RIGHT_CLOSED_SIZE_KEY, splRxHxRight.MinSize);
  NormalizeRxHxRightPaneWidths;
  pnlRxHxRight.Constraints.MinWidth := FRxHxRightClosedWidth;
  FRxHxRightOpen := uTMGOptions.ReadBool(RXHX_RIGHT_OPEN_KEY, True);
  if FRxHxRightOpen then begin
    pnlRxHxRight.Width := FRxHxRightOpenWidth;
  end else begin
    pnlRxHxRight.Width := FRxHxRightClosedWidth;
  end;
  timRxHxLeftCollapse.Interval := RXHX_LEFT_COLLAPSE_DELAY_MS;
  timRxHxLeftAnimate.Interval := RXHX_PANE_ANIMATION_TIMESLICE_MS;
  timRxHxRightAnimate.Interval := RXHX_PANE_ANIMATION_TIMESLICE_MS;
  TRxHxControlAccess(splRxHxLeft).OnMouseEnter := splRxHxLeftMouseEnter;
  TRxHxControlAccess(splRxHxLeft).OnMouseLeave := splRxHxLeftMouseLeave;
  TRxHxControlAccess(tcRxHxView).OnMouseEnter := pnlRxHxLeftMouseEnter;
  TRxHxControlAccess(tcRxHxView).OnMouseLeave := pnlRxHxLeftMouseLeave;
  TRxHxControlAccess(tvRxHx).OnMouseEnter := pnlRxHxLeftMouseEnter;
  TRxHxControlAccess(tvRxHx).OnMouseLeave := pnlRxHxLeftMouseLeave;
  TRxHxControlAccess(pnlRxHxSettings).OnMouseEnter := pnlRxHxLeftMouseEnter;
  TRxHxControlAccess(pnlRxHxSettings).OnMouseLeave := pnlRxHxLeftMouseLeave;
  TRxHxControlAccess(cbRxHxParsed).OnMouseEnter := pnlRxHxLeftMouseEnter;
  TRxHxControlAccess(cbRxHxParsed).OnMouseLeave := pnlRxHxLeftMouseLeave;
  ConfigureRxHxElsewhereMouseDown(pnlRxHxCenter);
  ConfigureRxHxElsewhereMouseDown(pnlRxHxRight);
  UpdateRxHxLeftHandleGlyph;
  UpdateRxHxRightHandleGlyph;
  UpdateRxHxLeftPinGlyph;
  PositionRxHxLeftHandle;
  PositionRxHxRightHandle;
  FRxHxLoaded := True;
  Resize;
end;

destructor TfrmRxHistory.Destroy;
//kt //codex added entire destructor 11/2/26
begin
  FRxHxSummary.Free;
  inherited;
end;

procedure TfrmRxHistory.ClearPtData;
//kt //codex added entire procedure 11/2/26
begin
  inherited;
  FRxHxSummaryLoaded := False;
  Inc(FRxHxSelectionSerial); //kt //codex 11/3/26
  if Assigned(FRxHxSummary) then begin
    FRxHxSummary.Clear;
  end;
  //kt //codex original --> tvRxHx.Items.Clear;
  Inc(FRxHxTreeGeneration); //kt //codex 11/22/26
  FRxHxRebuilding := True; //kt //codex 11/22/26
  try //kt //codex 11/22/26
    tvRxHx.Items.Clear; //kt //codex 11/22/26
    FRxHxDateTree.Items.Clear; //kt //codex 11/22/26
    FRxHxDisplayedNoteIEN := ''; //kt //codex 11/22/26
    FRxHxDisplayedHighlight := ''; //kt //codex 11/22/26
  finally //kt //codex 11/22/26
    FRxHxRebuilding := False; //kt //codex 11/22/26
  end; //kt //codex 11/22/26
  FRxHxNoteBrowser.Navigate('about:blank'); //kt //codex 11/3/26
  wbRxHxData.Navigate('about:blank'); //kt //codex 11/3/26
end;

procedure TfrmRxHistory.DisplayPage;
//kt //codex added entire procedure 11/2/26
begin
  inherited;
  if not FRxHxSummaryLoaded then begin
    LoadRxHxSummary;
  end;
end;

procedure TfrmRxHistory.cbRxHxParsedClick(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLoaded then begin
    LoadRxHxSummary;
  end;
end;

function RxHxSelectedMedText(Node: TTreeNode; Lines: TStrings): string;
//kt //codex added entire function 11/22/26
var
  Index: Integer;
  LineType: string;
begin
  Result := '';
  if not Assigned(Node) or not Assigned(Node.Parent) or not Assigned(Node.Parent.Parent) or
     not Assigned(Node.Data) or not Assigned(Lines) then begin
    Exit;
  end;
  Index := NativeInt(Node.Data) - 2;
  if (Index < 0) or (Index >= Lines.Count) then begin
    Exit;
  end;
  while Index >= 0 do begin
    LineType := Piece(Lines[Index], '^', 1);
    if LineType = '1' then begin
      Result := Piece(Lines[Index], '^', 2);
      Exit;
    end;
    if LineType = '0' then begin
      Exit;
    end;
    Dec(Index);
  end;
end;

procedure TfrmRxHistory.RxHxViewChange(Sender: TObject);
//kt //codex added entire procedure 11/3/26
var
  ActiveTree: TTreeView; //kt //codex 11/22/26
  NoteIndex: Integer; //kt //codex 11/22/26
begin
  if not FRxHxLoaded or FRxHxRebuilding then begin //kt //codex 11/22/26
    Exit; //kt //codex 11/22/26
  end; //kt //codex 11/22/26
  Inc(FRxHxSelectionSerial); //kt //codex 11/22/26
  Inc(FRxHxTreeGeneration); //kt //codex 11/22/26
  FRxHxRebuilding := True; //kt //codex 11/22/26
  try //kt //codex 11/22/26
    tvRxHx.Visible := tcRxHxView.TabIndex <> 1; //kt //codex 11/22/26
    FRxHxDateTree.Visible := tcRxHxView.TabIndex = 1; //kt //codex 11/22/26
  finally //kt //codex 11/22/26
    FRxHxRebuilding := False; //kt //codex 11/22/26
  end; //kt //codex 11/22/26
  if FRxHxDateTree.Visible then begin //kt //codex 11/22/26
    ActiveTree := FRxHxDateTree; //kt //codex 11/22/26
  end else begin //kt //codex 11/22/26
    ActiveTree := tvRxHx; //kt //codex 11/22/26
  end; //kt //codex 11/22/26
  if Assigned(ActiveTree.Selected) and Assigned(ActiveTree.Selected.Data) then begin //kt //codex 11/22/26
    NoteIndex := NativeInt(ActiveTree.Selected.Data) - 1; //kt //codex 11/22/26
    if (NoteIndex >= 0) and (NoteIndex < FRxHxSummary.Count) and //kt //codex 11/22/26
       ((Piece(FRxHxSummary[NoteIndex], '^', 2) <> FRxHxDisplayedNoteIEN) or //kt //codex 11/22/26
        (RxHxSelectedMedText(ActiveTree.Selected, FRxHxSummary) <> FRxHxDisplayedHighlight)) then begin //kt //codex 11/22/26
      RxHxTreeChange(ActiveTree, ActiveTree.Selected); //kt //codex 11/22/26
    end; //kt //codex 11/22/26
  end; //kt //codex 11/22/26
end;

procedure TfrmRxHistory.LoadRxHxSummary;
//kt //codex added entire procedure 11/2/26
var
  Status: string;
begin
  FRxHxSummaryLoaded := False;
  Inc(FRxHxSelectionSerial); //kt //codex 11/3/26
  FRxHxSummary.Clear;
  //kt //codex original --> tvRxHx.Items.Clear;
  Inc(FRxHxTreeGeneration); //kt //codex 11/22/26
  FRxHxRebuilding := True; //kt //codex 11/22/26
  try //kt //codex 11/22/26
    tvRxHx.Items.Clear; //kt //codex 11/22/26
    FRxHxDateTree.Items.Clear; //kt //codex 11/22/26
    FRxHxDisplayedNoteIEN := ''; //kt //codex 11/22/26
    FRxHxDisplayedHighlight := ''; //kt //codex 11/22/26
  finally //kt //codex 11/22/26
    FRxHxRebuilding := False; //kt //codex 11/22/26
  end; //kt //codex 11/22/26
  FRxHxNoteBrowser.Navigate('about:blank'); //kt //codex 11/3/26
  wbRxHxData.Navigate('about:blank'); //kt //codex 11/3/26
  if Patient.DFN = '' then begin
    Exit;
  end;
  Status := ListRxHistorySummary(FRxHxSummary, cbRxHxParsed.Checked);
  if Status <> '1^OK' then begin
    ShowMessage('Could not load medication history: ' + Status);
    Exit;
  end;
  FRxHxSummaryLoaded := True;
  RebuildRxHxTree;
end;

function RxHxExternalDateTime(const FMValue: string): string;
//kt //codex added entire function 11/2/26
begin
  Result := FormatFMDateTimeStr('mm/dd/yyyy', FMValue);  //kt //codex 11/2/26
end;

function RxHxEntryText(Lines: TStrings; EntryIndex: Integer): string;
//kt //codex added entire function 11/2/26
var
  Entry: string;
begin
  Entry := Lines[EntryIndex];
  Result := Piece(Entry, '^', 2) + ' from ' +
    RxHxExternalDateTime(Piece(Entry, '^', 3)) + ' to ' +
    RxHxExternalDateTime(Piece(Entry, '^', 4));
end;

function RxHxNoteLabel(const NoteLine: string): string;
//kt //codex added entire function 11/3/26
var
  NoteTitle: string;
begin
  NoteTitle := Piece(NoteLine, '^', 3);
  if NoteTitle = '' then begin
    NoteTitle := 'Untitled note';
  end;
  Result := FormatFMDateTimeStr('yyyy/mm/dd', Piece(NoteLine, '^', 4)) +
    '  ' + NoteTitle + ' -- ' + Piece(NoteLine, '^', 5);
end;

procedure TfrmRxHistory.RebuildRxHxDateTree;
//kt //codex added entire procedure 11/3/26
var
  Seen, SortedNotes: TStringList;
  Index, I, NoteIndex: Integer;
  //kt //codex original --> Line, TIUIEN, NoteDate, YearText, CurrentYear: string;
  //kt //codex original --> YearNode: TTreeNode;
  Line, TIUIEN, NoteDate: string; //kt //codex 11/22/26
begin
  Seen := TStringList.Create;
  SortedNotes := TStringList.Create;
  try
    Seen.Sorted := True;
    SortedNotes.Sorted := True;
    for Index := 0 to FRxHxSummary.Count - 1 do begin
      Line := FRxHxSummary[Index];
      if Piece(Line, '^', 1) <> '1.5' then begin
        Continue;
      end;
      TIUIEN := Piece(Line, '^', 2);
      if (TIUIEN = '') or (Seen.IndexOf(TIUIEN) >= 0) then begin
        Continue;
      end;
      Seen.Add(TIUIEN);
      NoteDate := Piece(Line, '^', 4);
      SortedNotes.Add(Copy(Piece(NoteDate, '.', 1) + '0000000', 1, 7) + '.' +
        Copy(Piece(NoteDate, '.', 2) + '000000', 1, 6) + '^' + Format('%.10d', [Index]));
    end;
    //kt //codex original --> CurrentYear := '';
    //kt //codex original --> YearNode := nil;
    //kt //codex original --> tvRxHx.Items.BeginUpdate;
    FRxHxDateTree.Items.BeginUpdate; //kt //codex 11/22/26
    try
    //kt //codex original --> tvRxHx.Items.Clear;
      FRxHxDateTree.Items.Clear; //kt //codex 11/22/26
      for I := SortedNotes.Count - 1 downto 0 do begin
        NoteIndex := StrToInt(Piece(SortedNotes[I], '^', 2));
        Line := FRxHxSummary[NoteIndex];
        //kt //codex original --> YearText := FormatFMDateTimeStr('yyyy', Piece(Line, '^', 4));
        //kt //codex original --> if YearText = '' then begin
        //kt //codex original --> YearText := 'Unknown year';
        //kt //codex original --> end;
        //kt //codex original --> if (not Assigned(YearNode)) or (YearText <> CurrentYear) then begin
        //kt //codex original --> CurrentYear := YearText;
        //kt //codex original --> YearNode := tvRxHx.Items.Add(nil, YearText);
        //kt //codex original --> end;
        //kt //codex original --> tvRxHx.Items.AddChildObject(YearNode, RxHxNoteLabel(Line), Pointer(NativeInt(NoteIndex + 1)));
    //kt //codex original --> tvRxHx.Items.AddObject(nil, RxHxNoteLabel(Line), Pointer(NativeInt(NoteIndex + 1))); //kt //codex 11/22/26
        FRxHxDateTree.Items.AddObject(nil, RxHxNoteLabel(Line), Pointer(NativeInt(NoteIndex + 1))); //kt //codex 11/22/26
      end;
    finally
    //kt //codex original --> tvRxHx.Items.EndUpdate;
      FRxHxDateTree.Items.EndUpdate; //kt //codex 11/22/26
    end;
  finally
    SortedNotes.Free;
    Seen.Free;
  end;
end;

procedure TfrmRxHistory.RebuildRxHxTree;
//kt //codex added entire procedure 11/2/26
var
  Index, Separator: Integer;
  Line, LineType, Heading: string;
  GroupNode: TTreeNode;
  SortedEntries: TStringList;  //kt //codex 11/2/26

  procedure AddSortedEntries;
  //kt //codex added entire procedure 11/2/26
  var
    //kt //codex original --> EntryIndex, I: Integer;
    EntryIndex, I, NoteIndex: Integer; //kt //codex 11/3/26
    EntryNode: TTreeNode; //kt //codex 11/3/26
    //kt //codex original --> NoteLine, NoteType, NoteTitle: string;
    NoteLine, NoteType: string; //kt //codex 11/3/26
  begin
    if Assigned(GroupNode) then begin
      for I := 0 to SortedEntries.Count - 1 do begin
        EntryIndex := StrToInt(Piece(SortedEntries[I], '^', 2));
        //kt //codex original --> tvRxHx.Items.AddChild(GroupNode, RxHxEntryText(FRxHxSummary, EntryIndex));
        EntryNode := tvRxHx.Items.AddChild(GroupNode, RxHxEntryText(FRxHxSummary, EntryIndex)); //kt //codex 11/3/26
        NoteIndex := EntryIndex + 1; //kt //codex 11/3/26
        while NoteIndex < FRxHxSummary.Count do begin //kt //codex 11/3/26
          NoteLine := FRxHxSummary[NoteIndex]; //kt //codex 11/3/26
          NoteType := Piece(NoteLine, '^', 1); //kt //codex 11/3/26
          if (NoteType = '0') or (NoteType = '1') then begin //kt //codex 11/3/26
            Break; //kt //codex 11/3/26
          end; //kt //codex 11/3/26
          if NoteType = '1.5' then begin //kt //codex 11/3/26
            //kt //codex original --> NoteTitle := Piece(NoteLine, '^', 3);
            //kt //codex original --> if NoteTitle = '' then begin
            //kt //codex original -->   NoteTitle := 'Untitled note';
            //kt //codex original --> end;
            //kt //codex original --> tvRxHx.Items.AddChildObject(EntryNode, NoteTitle + ' (' +
            //kt //codex original -->   RxHxExternalDateTime(Piece(NoteLine, '^', 4)) + ', TIU IEN: ' +
            //kt //codex original -->   Piece(NoteLine, '^', 2) + ')', Pointer(NativeInt(NoteIndex + 1)));
            //kt //codex original --> tvRxHx.Items.AddChildObject(EntryNode, FormatFMDateTimeStr('yyyy/mm/dd', Piece(NoteLine, '^', 4)) +
            //kt //codex original -->   '  ' + NoteTitle + ' ' + Piece(NoteLine, '^', 5), Pointer(NativeInt(NoteIndex + 1)));
            //kt //codex original -->   '  ' + NoteTitle + ' -- ' + Piece(NoteLine, '^', 5), Pointer(NativeInt(NoteIndex + 1)));
            tvRxHx.Items.AddChildObject(EntryNode, RxHxNoteLabel(NoteLine), Pointer(NativeInt(NoteIndex + 1))); //kt //codex 11/3/26
          end; //kt //codex 11/3/26
          Inc(NoteIndex); //kt //codex 11/3/26
        end; //kt //codex 11/3/26
      end;
    end;
    SortedEntries.Clear;
  end;

begin
  if FRxHxRebuilding then begin //kt //codex 11/22/26
    Exit; //kt //codex 11/22/26
  end; //kt //codex 11/22/26
  Inc(FRxHxTreeGeneration); //kt //codex 11/22/26
  FRxHxRebuilding := True; //kt //codex 11/22/26
  try //kt //codex 11/22/26
  //kt //codex original --> if tcRxHxView.TabIndex = 1 then begin
  //kt //codex original -->   RebuildRxHxDateTree;
  //kt //codex original -->   Exit;
  //kt //codex original --> end;
  RebuildRxHxDateTree; //kt //codex 11/22/26
  GroupNode := nil;
  //kt //codex original --> Info1Node := nil;
  //kt //codex original --> Info2Node := nil;
  //kt //codex original --> EntriesNode := nil;
  SortedEntries := TStringList.Create;  //kt //codex 11/2/26
  SortedEntries.Sorted := True;  //kt //codex 11/2/26
  tvRxHx.Items.BeginUpdate;
  try
    tvRxHx.Items.Clear;
    for Index := 0 to FRxHxSummary.Count - 1 do begin
      Line := FRxHxSummary[Index];
      Separator := Pos('^', Line);
      if Separator = 0 then begin
        Continue;
      end;
      LineType := Copy(Line, 1, Separator - 1);
      if LineType = '0' then begin
        AddSortedEntries;  //kt //codex 11/2/26
        Heading := Piece(Line, '^', 2);
        if Heading = '' then begin
          Heading := 'UNMATCHED';
        end;
        GroupNode := tvRxHx.Items.Add(nil, Heading);
        //kt //codex original --> Info1Node := tvRxHx.Items.AddChild(GroupNode, 'Info 1');
        //kt //codex original --> Info2Node := tvRxHx.Items.AddChild(GroupNode, 'Info 2');
        //kt //codex original --> EntriesNode := tvRxHx.Items.AddChild(GroupNode, 'Entries');
      end else if Assigned(GroupNode) and (LineType = '1') then begin
        //kt //codex original --> tvRxHx.Items.AddChild(Info1Node, Line);
        //kt //codex original --> tvRxHx.Items.AddChild(Info1Node, Piece(Line, '^', 2) + ' from ' +
        //kt //codex original -->   RxHxExternalDateTime(Piece(Line, '^', 3)) + ' to ' +
        //kt //codex original -->   RxHxExternalDateTime(Piece(Line, '^', 4)));
        //kt //codex original --> end else if Assigned(GroupNode) and (LineType = '2') then begin
        //kt //codex original --> tvRxHx.Items.AddChild(Info2Node, Line);
        //kt //codex original --> tvRxHx.Items.AddChild(Info2Node, Copy(Line, Separator + 1, MaxInt));
        //kt //codex original --> tvRxHx.Items.AddChild(EntriesNode, RxHxEntryText(FRxHxSummary, Index));
        //kt //codex original --> tvRxHx.Items.AddChild(GroupNode, RxHxEntryText(FRxHxSummary, Index));
        SortedEntries.Add(Piece(Piece(Line, '^', 3), '.', 1) + '.' +  //kt //codex 11/2/26
          Copy(Piece(Piece(Line, '^', 3), '.', 2) + '000000', 1, 6) + '^' +  //kt //codex 11/2/26
          Format('%.10d', [Index]));  //kt //codex 11/2/26
      end;
    end;
    AddSortedEntries;  //kt //codex 11/2/26
  finally
    tvRxHx.Items.EndUpdate;
    SortedEntries.Free;  //kt //codex 11/2/26
  end;
  finally //kt //codex 11/22/26
    FRxHxRebuilding := False; //kt //codex 11/22/26
  end; //kt //codex 11/22/26
end;

//kt //codex original --> function RxHxTableHTML(Lines: TStrings): string;
function RxHxTableHTML(Lines: TStrings; const HighlightText: string; UseParsed: Boolean): string; //kt //codex 11/22/26
//kt //codex added entire function 11/3/26
var
  HTML: TStringList;
  //kt //codex original --> TableType, LineType, LineText: string;
  TableType, LineType, LineText, MatchText: string; //kt //codex 11/22/26
  I, Kind, Count: Integer;
  Modified: Boolean;
begin
  HTML := TStringList.Create;
  try
    HTML.Add('<!DOCTYPE html><html><head><style>');
    //kt //codex original --> HTML.Add('body {font-family: Segoe UI, Tahoma, Arial, sans-serif; margin: 0; padding: 8px;}');
    HTML.Add('body {font-family: Segoe UI, Tahoma, Arial, sans-serif; margin: 0; padding: 4px;}'); //kt //codex 11/22/26
    //kt //codex original --> HTML.Add('.container {margin: 0 0 8px 0; overflow-x: auto; overflow-y: hidden;}');
    HTML.Add('.container {margin: 0 0 4px 0; overflow-x: auto; overflow-y: hidden;}'); //kt //codex 11/22/26
    HTML.Add('table {border: 1px solid #9fbad0; border-collapse: separate; border-spacing: 0; min-width: 100%;}');
    //kt //codex original --> HTML.Add('th {background: #2f75b5; color: white; text-align: left; padding: 5px 8px;}');
    HTML.Add('th {background: #2f75b5; color: white; text-align: left; font-size: 12px; padding: 2px 6px;}'); //kt //codex 11/22/26
    //kt //codex original --> HTML.Add('td {font-family: Consolas, Courier New, monospace; white-space: pre; padding: 1px 8px;}');
    //kt //codex original --> HTML.Add('td {font-family: Consolas, Courier New, monospace; font-size: 12px; line-height: 14px; white-space: pre; padding: 0 6px;}');
    HTML.Add('td {font-family: Consolas, Courier New, monospace; font-size: 12px; line-height: 10px; white-space: pre; padding: 0 6px;}'); //kt //codex 11/22/26
    //kt //codex original --> HTML.Add('.empty {color: #666; font-style: italic;} .spacer td {height: 14px; padding: 0;}');
    HTML.Add('.empty {color: #666; font-style: italic;}'); //kt //codex 11/22/26
    HTML.Add('td.match {background: #fff2a8; color: #222; font-weight: bold;}'); //kt //codex 11/22/26
    //kt //codex original --> HTML.Add('.zoom-controls {float: right; white-space: nowrap;} .zoom-controls a {color: white; text-decoration: none; padding: 0 4px; font-weight: bold;}');
    HTML.Add('.zoom-controls {display: inline-block; margin-left: 14px; white-space: nowrap; vertical-align: middle;}'); //kt //codex 11/22/26
    //kt //codex original --> HTML.Add('.zoom-controls a {display: inline-block; width: 17px; height: 16px; margin-left: 3px; border: 1px solid #bad6ec; border-radius: 3px; background: #205c92; color: white; text-align: center; text-decoration: none; font: bold 13px/16px Arial, sans-serif;}');
    //kt //codex original --> HTML.Add('.zoom-controls a {display: inline-block; width: 12px; height: 11px; margin-left: 3px; border: 1px solid #bad6ec; border-radius: 3px; background: #205c92; color: white; text-align: center; text-decoration: none; vertical-align: middle; font: bold 13px/11px Arial, sans-serif;}');
    //kt //codex original --> HTML.Add('.zoom-controls a:hover {background: #174872; border-color: white;}');
    HTML.Add('.zoom-controls a {position: relative; display: inline-block; width: 17px; height: 16px; margin-left: 3px; border: 1px solid transparent; color: white; text-align: center; text-decoration: none; font: bold 13px/16px Arial, sans-serif;}'); //kt //codex 11/22/26
    HTML.Add('.zoom-box {position: absolute; left: 2px; top: 2px; width: 11px; height: 10px; border: 1px solid #bad6ec; border-radius: 3px; background: #205c92;}'); //kt //codex 11/22/26
    //kt //codex original --> HTML.Add('.zoom-symbol {position: relative;} .zoom-controls a:hover .zoom-box {background: #174872; border-color: white;}');
    HTML.Add('.zoom-symbol {position: relative; top: -1px;} .zoom-symbol.reset {top: -2px;} .zoom-controls a:hover .zoom-box {background: #174872; border-color: white;}'); //kt //codex 11/22/26
    //kt //codex original --> HTML.Add('</style></head><body>');
    HTML.Add('</style><script type="text/javascript">'); //kt //codex 11/22/26
    HTML.Add('var rxSizes = [0, 12, 12];'); //kt //codex 11/22/26
    HTML.Add('function rxZoom(tableNo, change) {'); //kt //codex 11/22/26
    HTML.Add('  var size = change === 0 ? 12 : rxSizes[tableNo] + change;'); //kt //codex 11/22/26
    HTML.Add('  if (size < 9) size = 9; if (size > 24) size = 24;'); //kt //codex 11/22/26
    HTML.Add('  rxSizes[tableNo] = size;'); //kt //codex 11/22/26
    HTML.Add('  var table = document.getElementById("rx-table-" + tableNo);'); //kt //codex 11/22/26
    HTML.Add('  if (table) { var cells = table.getElementsByTagName("td");'); //kt //codex 11/22/26
    HTML.Add('    for (var i = 0; i < cells.length; i++) {'); //kt //codex 11/22/26
    HTML.Add('      cells[i].style.fontSize = size + "px";'); //kt //codex 11/22/26
    HTML.Add('      cells[i].style.lineHeight = Math.round(size * 10 / 12) + "px";'); //kt //codex 11/22/26
    HTML.Add('    }'); //kt //codex 11/22/26
    HTML.Add('  } return false;'); //kt //codex 11/22/26
    HTML.Add('}'); //kt //codex 11/22/26
    HTML.Add('</script></head><body>'); //kt //codex 11/22/26
    for Kind := 1 to 2 do begin
      TableType := IntToStr(Kind);
      if Kind = 1 then begin
        LineText := 'Incoming medications';
      end else begin
        LineText := 'Final medications';
      end;
      //kt //codex original --> HTML.Add('<div class="container"><table><thead><tr><th>' + LineText + '</th></tr></thead><tbody>');
      //kt //codex original --> HTML.Add('<div class="container"><table id="rx-table-' + TableType + '"><thead><tr><th>' +
      //kt //codex original -->   '<span class="zoom-controls">' +
      //kt //codex original -->   '<a href="#" title="Decrease text size" onclick="return rxZoom(' + TableType + ',-1)">(-)</a>' +
      //kt //codex original -->   '<a href="#" title="Reset text size" onclick="return rxZoom(' + TableType + ',0)">(*)</a>' +
      //kt //codex original -->   '<a href="#" title="Increase text size" onclick="return rxZoom(' + TableType + ',1)">(+)</a>' +
      //kt //codex original -->   '</span>' + LineText + '</th></tr></thead><tbody>');
      HTML.Add('<div class="container"><table id="rx-table-' + TableType + '"><thead><tr><th>' + LineText + //kt //codex 11/22/26
        '<span class="zoom-controls">' + //kt //codex 11/22/26
        //kt //codex original --> '<a href="#" title="Decrease text size" onclick="return rxZoom(' + TableType + ',-1)">&#8722;</a>' +
        '<a href="#" title="Decrease text size" onclick="return rxZoom(' + TableType + ',-1)"><span class="zoom-box"></span><span class="zoom-symbol">&#8722;</span></a>' + //kt //codex 11/22/26
        //kt //codex original --> '<a href="#" title="Reset text size" onclick="return rxZoom(' + TableType + ',0)">&#8634;</a>' +
        //kt //codex original --> '<a href="#" title="Reset text size" onclick="return rxZoom(' + TableType + ',0)">&#9679;</a>' +
        //kt //codex original --> '<a href="#" title="Reset text size" onclick="return rxZoom(' + TableType + ',0)"><span class="zoom-box"></span><span class="zoom-symbol">&#9679;</span></a>' +
        '<a href="#" title="Reset text size" onclick="return rxZoom(' + TableType + ',0)"><span class="zoom-box"></span><span class="zoom-symbol reset">&#9679;</span></a>' + //kt //codex 11/22/26
        //kt //codex original --> '<a href="#" title="Increase text size" onclick="return rxZoom(' + TableType + ',1)">+</a>' +
        '<a href="#" title="Increase text size" onclick="return rxZoom(' + TableType + ',1)"><span class="zoom-box"></span><span class="zoom-symbol">+</span></a>' + //kt //codex 11/22/26
        '</span></th></tr></thead><tbody>'); //kt //codex 11/22/26
      Count := 0;
      for I := 0 to Lines.Count - 1 do begin
        LineType := Piece(Lines[I], '^', 1);
        if LineType = TableType then begin
          LineText := Piece(Lines[I], '^', 2);
          //kt //codex original --> HTML.Add('<tr><td>' + HTMLEncode(LineText, Modified) + '</td></tr>');
          MatchText := LineText; //kt //codex 11/22/26
          if UseParsed and (Trim(Piece(Lines[I], '^', 3)) <> '') then begin //kt //codex 11/22/26
            MatchText := Piece(Lines[I], '^', 3); //kt //codex 11/22/26
          end; //kt //codex 11/22/26
          if (HighlightText <> '') and (Trim(MatchText) = HighlightText) then begin //kt //codex 11/22/26
            HTML.Add('<tr><td class="match">' + HTMLEncode(LineText, Modified) + '</td></tr>'); //kt //codex 11/22/26
          end else begin //kt //codex 11/22/26
            HTML.Add('<tr><td>' + HTMLEncode(LineText, Modified) + '</td></tr>'); //kt //codex 11/22/26
          end; //kt //codex 11/22/26
          Inc(Count);
        end;
      end;
      if Count = 0 then begin
        HTML.Add('<tr><td class="empty">No medication entries found.</td></tr>');
      end;
    //kt //codex original --> HTML.Add('<tr class="spacer"><td>&nbsp;</td></tr></tbody></table></div>');
      HTML.Add('</tbody></table></div>'); //kt //codex 11/22/26
    end;
    HTML.Add('</body></html>');
    Result := HTML.Text;
  finally
    HTML.Free;
  end;
end;

procedure TfrmRxHistory.RxHxTreeExpanded(Sender: TObject; Node: TTreeNode);
//kt //codex added entire procedure 11/22/26
begin
  if FRxHxRebuilding or (Sender <> tvRxHx) or not Assigned(Node) then begin
    Exit;
  end;
  if (Node.Level = 1) and Node.HasChildren then begin
    PostMessage(Handle, UM_RXHX_SELECT_FIRST, WPARAM(FRxHxTreeGeneration), LPARAM(Node));
  end;
end;

procedure TfrmRxHistory.UMRxHxSelectFirst(var Message: TMessage);
//kt //codex added entire procedure 11/22/26
var
  I: Integer;
  Node: TTreeNode;
begin
  if FRxHxRebuilding or (tcRxHxView.TabIndex <> 0) or
     (Message.WParam <> WPARAM(FRxHxTreeGeneration)) then begin
    Exit;
  end;
  for I := 0 to tvRxHx.Items.Count - 1 do begin
    Node := tvRxHx.Items[I];
    if LPARAM(Node) = Message.LParam then begin
      if (Node.Level = 1) and Node.Expanded and Node.HasChildren then begin
        tvRxHx.Selected := Node.getFirstChild;
      end;
      Exit;
    end;
  end;
end;

procedure TfrmRxHistory.RxHxTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
//kt //codex added entire procedure 11/3/26
var
  Node: TTreeNode;
  Hit: THitTests;
  Tree: TTreeView; //kt //codex 11/22/26
begin
  if not (Sender is TTreeView) then begin //kt //codex 11/22/26
    Exit; //kt //codex 11/22/26
  end; //kt //codex 11/22/26
  Tree := TTreeView(Sender); //kt //codex 11/22/26
  if (Button <> mbLeft) or (ssDouble in Shift) then begin
    Exit;
  end;
  //kt //codex original --> Hit := tvRxHx.GetHitTestInfoAt(X, Y);
  Hit := Tree.GetHitTestInfoAt(X, Y); //kt //codex 11/22/26
  if not (htOnLabel in Hit) then begin
    Exit;
  end;
  //kt //codex original --> Node := tvRxHx.GetNodeAt(X, Y);
  Node := Tree.GetNodeAt(X, Y); //kt //codex 11/22/26
  //kt //codex original --> if Assigned(Node) and (Node.Level = 1) and Node.HasChildren then begin
  if Assigned(Node) and not Assigned(Node.Data) and Node.HasChildren then begin //kt //codex 11/3/26
    if Node.Expanded then begin
      Node.Collapse(False);
    end else begin
      Node.Expand(False);
    end;
  end;
end;

procedure TfrmRxHistory.RxHxZoomClick(Sender: TObject);
//kt //codex added entire procedure 11/3/26
const
  OLECMDID_OPTICAL_ZOOM = $0000003F;
var
  NewZoom: Integer;
  ZoomIn, ZoomOut: OleVariant;
begin
  NewZoom := FRxHxZoom;
  if Sender = btnRxHxZoomOut then begin
    NewZoom := NewZoom - 20;
  end else if Sender = btnRxHxZoomIn then begin
    NewZoom := NewZoom + 20;
  end else begin
    NewZoom := 100;
  end;
  if NewZoom < 10 then begin
    NewZoom := 10;
  end else if NewZoom > 1000 then begin
    NewZoom := 1000;
  end;
  ZoomIn := NewZoom;
  ZoomOut := 0;
  try
    FRxHxNoteBrowser.ControlInterface.ExecWB(OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, ZoomIn, ZoomOut);
    FRxHxZoom := NewZoom;
  except
    on E: Exception do begin
      ShowMessage('Could not change note zoom: ' + E.Message);
    end;
  end;
end;

procedure TfrmRxHistory.RxHxTreeChange(Sender: TObject; Node: TTreeNode);
//kt //codex added entire procedure 11/3/26
var
  NoteIndex, TIUIEN, SelectionSerial: Integer;
  IsHTML: Boolean;
  NoteLines, TableLines: TStringList;
  //kt //codex original --> Status, HTML: string;
  Status, HTML, HighlightText: string; //kt //codex 11/22/26
  UseParsed: Boolean; //kt //codex 11/22/26
begin
  if FRxHxRebuilding then begin //kt //codex 11/22/26
    Exit; //kt //codex 11/22/26
  end; //kt //codex 11/22/26
  Inc(FRxHxSelectionSerial);
  SelectionSerial := FRxHxSelectionSerial;
  if not Assigned(Node) or not Assigned(Node.Data) then begin
    Exit;
  end;
  NoteIndex := NativeInt(Node.Data) - 1;
  if (NoteIndex < 0) or (NoteIndex >= FRxHxSummary.Count) then begin
    Exit;
  end;
  if Piece(FRxHxSummary[NoteIndex], '^', 1) <> '1.5' then begin
    Exit;
  end;
  TIUIEN := StrToIntDef(Piece(FRxHxSummary[NoteIndex], '^', 2), 0);
  if TIUIEN <= 0 then begin
    Exit;
  end;
  HighlightText := RxHxSelectedMedText(Node, FRxHxSummary); //kt //codex 11/22/26
  UseParsed := cbRxHxParsed.Checked; //kt //codex 11/22/26
  NoteLines := TStringList.Create;
  TableLines := TStringList.Create;
  try
    FRxHxDisplayedNoteIEN := ''; //kt //codex 11/22/26
    FRxHxDisplayedHighlight := ''; //kt //codex 11/22/26
    FRxHxNoteBrowser.Navigate('about:blank');
    wbRxHxData.Navigate('about:blank');
    LoadDocumentText(NoteLines, TIUIEN, IsHTML);
    Status := ListRxHistoryForNote(TableLines, IntToStr(TIUIEN));
    if IsHTML then begin
      FixHTML(NoteLines);
      HTML := NoteLines.Text;
    end else begin
      HTMLEncode(NoteLines);
      HTML := Text2HTML(NoteLines);
    end;
    if SelectionSerial <> FRxHxSelectionSerial then begin
      Exit;
    end;
    WBLoadHTML(FRxHxNoteBrowser, HTML);
    if SelectionSerial <> FRxHxSelectionSerial then begin
      Exit;
    end;
    if Status <> '1^OK' then begin
      ShowMessage('Could not load medication tables: ' + Status);
      Exit;
    end;
    //kt //codex original --> WBLoadHTML(wbRxHxData, RxHxTableHTML(TableLines));
    WBLoadHTML(wbRxHxData, RxHxTableHTML(TableLines, HighlightText, UseParsed)); //kt //codex 11/22/26
    if SelectionSerial = FRxHxSelectionSerial then begin //kt //codex 11/22/26
      FRxHxDisplayedNoteIEN := IntToStr(TIUIEN); //kt //codex 11/22/26
      FRxHxDisplayedHighlight := HighlightText; //kt //codex 11/22/26
    end; //kt //codex 11/22/26
  finally
    TableLines.Free;
    NoteLines.Free;
  end;
end;

procedure TfrmRxHistory.Resize;
//kt //codex added entire procedure 11/2/26
begin
  inherited;
  if (not FRxHxLoaded) or (csDestroying in ComponentState) then begin
    Exit;
  end;
  PositionRxHxLeftHandle;
  PositionRxHxRightHandle;
  PositionRxHxLeftPin;
end;

function TfrmRxHistory.CursorOverControl(AControl: TControl): Boolean;
//kt //codex added entire function 11/2/26
var
  CursorPos: TPoint;
begin
  GetCursorPos(CursorPos);
  CursorPos := AControl.Parent.ScreenToClient(CursorPos);
  Result := PtInRect(AControl.BoundsRect, CursorPos);
end;

procedure TfrmRxHistory.ConfigureRxHxElsewhereMouseDown(AParent: TWinControl);
//kt //codex added entire procedure 11/2/26
var
  Child: TControl;
  Index: Integer;
begin
  TRxHxControlAccess(AParent).OnMouseDown := pnlRxHxElsewhereMouseDown;
  for Index := 0 to AParent.ControlCount - 1 do begin
    Child := AParent.Controls[Index];
    if Child is TWinControl then begin
      ConfigureRxHxElsewhereMouseDown(TWinControl(Child));
    end else begin
      TRxHxControlAccess(Child).OnMouseDown := pnlRxHxElsewhereMouseDown;
    end;
  end;
end;

procedure TfrmRxHistory.CloseRxHxLeftWithoutDelay;
//kt //codex added entire procedure 11/2/26
begin
  timRxHxLeftCollapse.Enabled := False;
  if FRxHxLeftPinned then begin
    Exit;
  end;
  SetRxHxLeftOpen(False);
end;

procedure TfrmRxHistory.HideRxHxLeftHandle;
//kt //codex added entire procedure 11/2/26
begin
  timHideRxHxLeftHandle.Enabled := False;
  btnRxHxLeftHandle.Visible := False;
  splRxHxLeft.Color := clBtnFace;
end;

procedure TfrmRxHistory.PositionRxHxLeftHandle;
//kt //codex added entire procedure 11/2/26
begin
  btnRxHxLeftHandle.Left := splRxHxLeft.Left - (btnRxHxLeftHandle.Width div 2) + (splRxHxLeft.Width div 2);
  btnRxHxLeftHandle.Top := (pnlRxHxLeft.Height - btnRxHxLeftHandle.Height) div 2;
  btnRxHxLeftHandle.BringToFront;
  PositionRxHxLeftPin;
end;

procedure TfrmRxHistory.PositionRxHxLeftPin;
//kt //codex added entire procedure 11/2/26
begin
  btnRxHxLeftPin.Left := splRxHxLeft.Left - (btnRxHxLeftPin.Width div 2) + (splRxHxLeft.Width div 2);
  btnRxHxLeftPin.Top := splRxHxLeft.Top + splRxHxLeft.Height - btnRxHxLeftPin.Height;
  btnRxHxLeftPin.BringToFront;
end;

procedure TfrmRxHistory.PositionRxHxRightHandle;
//kt //codex added entire procedure 11/2/26
begin
  btnRxHxRightHandle.Left := splRxHxRight.Left - (btnRxHxRightHandle.Width div 2) + (splRxHxRight.Width div 2);
  btnRxHxRightHandle.Top := (pnlRxHxRight.Height - btnRxHxRightHandle.Height) div 2;
  btnRxHxRightHandle.BringToFront;
end;

procedure TfrmRxHistory.QueueRxHxLeftCollapse;
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftPinned then begin
    Exit;
  end;
  timRxHxLeftCollapse.Enabled := False;
  timRxHxLeftCollapse.Enabled := True;
end;

procedure TfrmRxHistory.NormalizeRxHxLeftPaneWidths;
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftOpenWidth < splRxHxLeft.MinSize + RXHX_LEFT_PANE_MINIMUM_WIDTH_GAP then begin
    FRxHxLeftOpenWidth := splRxHxLeft.MinSize + RXHX_LEFT_PANE_MINIMUM_WIDTH_GAP;
  end;
  if FRxHxLeftClosedWidth < splRxHxLeft.MinSize then begin
    FRxHxLeftClosedWidth := splRxHxLeft.MinSize;
  end;
  if FRxHxLeftClosedWidth > FRxHxLeftOpenWidth - RXHX_LEFT_PANE_MINIMUM_WIDTH_GAP then begin
    FRxHxLeftClosedWidth := FRxHxLeftOpenWidth - RXHX_LEFT_PANE_MINIMUM_WIDTH_GAP;
  end;
end;

procedure TfrmRxHistory.NormalizeRxHxRightPaneWidths;
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxRightOpenWidth < splRxHxRight.MinSize + RXHX_RIGHT_PANE_MINIMUM_WIDTH_GAP then begin
    FRxHxRightOpenWidth := splRxHxRight.MinSize + RXHX_RIGHT_PANE_MINIMUM_WIDTH_GAP;
  end;
  if FRxHxRightClosedWidth < splRxHxRight.MinSize then begin
    FRxHxRightClosedWidth := splRxHxRight.MinSize;
  end;
  if FRxHxRightClosedWidth > FRxHxRightOpenWidth - RXHX_RIGHT_PANE_MINIMUM_WIDTH_GAP then begin
    FRxHxRightClosedWidth := FRxHxRightOpenWidth - RXHX_RIGHT_PANE_MINIMUM_WIDTH_GAP;
  end;
end;

procedure TfrmRxHistory.QueueHideRxHxLeftHandle;
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftPinned then begin
    Exit;
  end;
  timHideRxHxLeftHandle.Enabled := False;
  timHideRxHxLeftHandle.Enabled := True;
end;

procedure TfrmRxHistory.SetRxHxLeftOpen(Value: Boolean);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftOpen = Value then begin
    Exit;
  end;
  FRxHxLeftOpen := Value;
  FRxHxLeftAnimationStartWidth := pnlRxHxLeft.Width;
  if FRxHxLeftOpen then begin
    FRxHxLeftAnimationTargetWidth := FRxHxLeftOpenWidth;
  end else begin
    FRxHxLeftAnimationTargetWidth := FRxHxLeftClosedWidth;
  end;
  FRxHxLeftAnimationStep := 0;
  FRxHxLeftAnimating := FRxHxLeftAnimationStartWidth <> FRxHxLeftAnimationTargetWidth;
  UpdateRxHxLeftHandleGlyph;
  PositionRxHxLeftHandle;
  timRxHxLeftAnimate.Enabled := FRxHxLeftAnimating;
end;

procedure TfrmRxHistory.SetRxHxRightOpen(Value: Boolean);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxRightOpen = Value then begin
    Exit;
  end;
  NormalizeRxHxRightPaneWidths;
  pnlRxHxRight.Constraints.MinWidth := FRxHxRightClosedWidth;
  FRxHxRightOpen := Value;
  if FRxHxLoaded then begin
    uTMGOptions.WriteBool(RXHX_RIGHT_OPEN_KEY, FRxHxRightOpen);
  end;
  FRxHxRightAnimationStartWidth := pnlRxHxRight.Width;
  if FRxHxRightOpen then begin
    FRxHxRightAnimationTargetWidth := FRxHxRightOpenWidth;
  end else begin
    FRxHxRightAnimationTargetWidth := FRxHxRightClosedWidth;
  end;
  FRxHxRightAnimationStep := 0;
  FRxHxRightAnimating := FRxHxRightAnimationStartWidth <> FRxHxRightAnimationTargetWidth;
  UpdateRxHxRightHandleGlyph;
  PositionRxHxRightHandle;
  timRxHxRightAnimate.Enabled := FRxHxRightAnimating;
end;

procedure TfrmRxHistory.ShowRxHxLeftHandle;
//kt //codex added entire procedure 11/2/26
begin
  timHideRxHxLeftHandle.Enabled := False;
  PositionRxHxLeftHandle;
  UpdateRxHxLeftHandleGlyph;
  btnRxHxLeftHandle.Visible := True;
  splRxHxLeft.Color := clSkyBlue;
end;

procedure TfrmRxHistory.splRxHxLeftMoved(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftAnimating then begin
    Exit;
  end;
  if FRxHxLeftOpen then begin
    FRxHxLeftOpenWidth := pnlRxHxLeft.Width;
  end else begin
    FRxHxLeftClosedWidth := pnlRxHxLeft.Width;
  end;
  NormalizeRxHxLeftPaneWidths;
  if FRxHxLeftOpen and (pnlRxHxLeft.Width <> FRxHxLeftOpenWidth) then begin
    pnlRxHxLeft.Width := FRxHxLeftOpenWidth;
  end;
  if FRxHxLoaded then begin
    uTMGOptions.WriteInteger(RXHX_LEFT_OPEN_SIZE_KEY, FRxHxLeftOpenWidth);
    uTMGOptions.WriteInteger(RXHX_LEFT_CLOSED_SIZE_KEY, FRxHxLeftClosedWidth);
  end;
  PositionRxHxLeftHandle;
end;

procedure TfrmRxHistory.splRxHxRightMoved(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxRightAnimating then begin
    Exit;
  end;
  if FRxHxRightOpen then begin
    FRxHxRightOpenWidth := pnlRxHxRight.Width;
  end else begin
    FRxHxRightClosedWidth := pnlRxHxRight.Width;
  end;
  NormalizeRxHxRightPaneWidths;
  pnlRxHxRight.Constraints.MinWidth := FRxHxRightClosedWidth;
  if FRxHxRightOpen then begin
    if pnlRxHxRight.Width <> FRxHxRightOpenWidth then begin
      pnlRxHxRight.Width := FRxHxRightOpenWidth;
    end;
  end else begin
    if pnlRxHxRight.Width <> FRxHxRightClosedWidth then begin
      pnlRxHxRight.Width := FRxHxRightClosedWidth;
    end;
  end;
  if FRxHxLoaded then begin
    uTMGOptions.WriteInteger(RXHX_RIGHT_OPEN_SIZE_KEY, FRxHxRightOpenWidth);
    uTMGOptions.WriteInteger(RXHX_RIGHT_CLOSED_SIZE_KEY, FRxHxRightClosedWidth);
  end;
  PositionRxHxRightHandle;
end;

procedure TfrmRxHistory.pnlRxHxLeftMouseEnter(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftPinned then begin
    Exit;
  end;
  timRxHxLeftCollapse.Enabled := False;
  SetRxHxLeftOpen(True);
end;

procedure TfrmRxHistory.pnlRxHxLeftMouseLeave(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftPinned then begin
    Exit;
  end;
  QueueRxHxLeftCollapse;
end;

procedure TfrmRxHistory.splRxHxLeftMouseEnter(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftPinned then begin
    Exit;
  end;
  timRxHxLeftCollapse.Enabled := False;
  ShowRxHxLeftHandle;
end;

procedure TfrmRxHistory.splRxHxLeftMouseLeave(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftPinned then begin
    Exit;
  end;
  QueueRxHxLeftCollapse;
  QueueHideRxHxLeftHandle;
end;

procedure TfrmRxHistory.btnRxHxLeftHandleClick(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftPinned then begin
    Exit;
  end;
  SetRxHxLeftOpen(not FRxHxLeftOpen);
  ShowRxHxLeftHandle;
end;

procedure TfrmRxHistory.btnRxHxRightHandleClick(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  SetRxHxRightOpen(not FRxHxRightOpen);
end;

procedure TfrmRxHistory.btnRxHxLeftPinClick(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  FRxHxLeftPinned := not FRxHxLeftPinned;
  timRxHxLeftCollapse.Enabled := False;
  timHideRxHxLeftHandle.Enabled := False;
  if FRxHxLeftPinned then begin
    timRxHxLeftAnimate.Enabled := False;
    if FRxHxLeftAnimating then begin
      pnlRxHxLeft.Width := FRxHxLeftAnimationTargetWidth;
    end;
    FRxHxLeftAnimating := False;
    PositionRxHxLeftHandle;
    HideRxHxLeftHandle;
  end;
  UpdateRxHxLeftPinGlyph;
end;

procedure TfrmRxHistory.btnRxHxLeftHandleMouseEnter(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftPinned then begin
    Exit;
  end;
  timRxHxLeftCollapse.Enabled := False;
  timHideRxHxLeftHandle.Enabled := False;
  splRxHxLeft.Color := clSkyBlue;
end;

procedure TfrmRxHistory.btnRxHxLeftHandleMouseLeave(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftPinned then begin
    Exit;
  end;
  QueueRxHxLeftCollapse;
  QueueHideRxHxLeftHandle;
end;

procedure TfrmRxHistory.timRxHxLeftCollapseTimer(Sender: TObject);
//kt //codex added entire procedure 11/2/26
var
  MousePosition: TPoint;
begin
  if FRxHxLeftPinned then begin
    timRxHxLeftCollapse.Enabled := False;
    Exit;
  end;
  if GetCapture <> 0 then begin
    Exit;
  end;
  if CursorOverControl(pnlRxHxLeft) or CursorOverControl(splRxHxLeft) or CursorOverControl(btnRxHxLeftHandle) or CursorOverControl(btnRxHxLeftPin) then begin
    Exit;
  end;
  MousePosition := ScreenToClient(Mouse.CursorPos);
  if MousePosition.X < splRxHxLeft.Left + splRxHxLeft.Width + RXHX_LEFT_COLLAPSE_RIGHT_DISTANCE then begin
    Exit;
  end;
  timRxHxLeftCollapse.Enabled := False;
  SetRxHxLeftOpen(False);
end;

procedure TfrmRxHistory.timRxHxLeftAnimateTimer(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  Inc(FRxHxLeftAnimationStep);
  pnlRxHxLeft.Width := FRxHxLeftAnimationStartWidth +
    ((FRxHxLeftAnimationTargetWidth - FRxHxLeftAnimationStartWidth) * FRxHxLeftAnimationStep div RXHX_PANE_ANIMATION_STEPS);
  PositionRxHxLeftHandle;
  if FRxHxLeftAnimationStep >= RXHX_PANE_ANIMATION_STEPS then begin
    pnlRxHxLeft.Width := FRxHxLeftAnimationTargetWidth;
    FRxHxLeftAnimating := False;
    timRxHxLeftAnimate.Enabled := False;
    PositionRxHxLeftHandle;
  end;
end;

procedure TfrmRxHistory.timRxHxRightAnimateTimer(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  Inc(FRxHxRightAnimationStep);
  pnlRxHxRight.Width := FRxHxRightAnimationStartWidth +
    ((FRxHxRightAnimationTargetWidth - FRxHxRightAnimationStartWidth) * FRxHxRightAnimationStep div RXHX_PANE_ANIMATION_STEPS);
  PositionRxHxRightHandle;
  if FRxHxRightAnimationStep >= RXHX_PANE_ANIMATION_STEPS then begin
    pnlRxHxRight.Width := FRxHxRightAnimationTargetWidth;
    FRxHxRightAnimating := False;
    timRxHxRightAnimate.Enabled := False;
    PositionRxHxRightHandle;
  end;
end;

procedure TfrmRxHistory.timHideRxHxLeftHandleTimer(Sender: TObject);
//kt //codex added entire procedure 11/2/26
begin
  if CursorOverControl(splRxHxLeft) or CursorOverControl(btnRxHxLeftHandle) then begin
    Exit;
  end;
  HideRxHxLeftHandle;
end;

procedure TfrmRxHistory.UpdateRxHxLeftHandleGlyph;
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftOpen then begin
    btnRxHxLeftHandle.LoadGlyph(ImageCollection1, RXHX_IMAGE_ARROW_LEFT);
  end else begin
    btnRxHxLeftHandle.LoadGlyph(ImageCollection1, RXHX_IMAGE_ARROW_RIGHT);
  end;
end;

procedure TfrmRxHistory.UpdateRxHxLeftPinGlyph;
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxLeftPinned then begin
    btnRxHxLeftPin.LoadGlyph(ImageCollection1, RXHX_IMAGE_PIN_DOWN_RED);
  end else begin
    btnRxHxLeftPin.LoadGlyph(ImageCollection1, RXHX_IMAGE_PIN_UP_BLUE);
  end;
end;

procedure TfrmRxHistory.UpdateRxHxRightHandleGlyph;
//kt //codex added entire procedure 11/2/26
begin
  if FRxHxRightOpen then begin
    btnRxHxRightHandle.LoadGlyph(ImageCollection1, RXHX_IMAGE_ARROW_RIGHT);
  end else begin
    btnRxHxRightHandle.LoadGlyph(ImageCollection1, RXHX_IMAGE_ARROW_LEFT);
  end;
end;

procedure TfrmRxHistory.pnlRxHxElsewhereMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
//kt //codex added entire procedure 11/2/26
begin
  CloseRxHxLeftWithoutDelay;
end;

end.
