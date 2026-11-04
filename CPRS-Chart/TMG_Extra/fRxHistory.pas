unit fRxHistory;
//kt added entire unit 11/2/26   //kt //codex
interface

uses
  Windows, Classes, Controls, Graphics, ExtCtrls, Buttons, Forms, OleCtrls, SHDocVw,
  System.ImageList, Vcl.ImgList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  fPage, uPngGlyphButton, Vcl.ComCtrls, Vcl.StdCtrls, VA508AccessibilityManager, Vcl.Tabs, Vcl.DockTabSet;

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
    FRxHxZoom: Integer; //kt //codex 11/3/26
    btnRxHxLeftHandle, btnRxHxRightHandle, btnRxHxLeftPin: TPngGlyphButton;
    FRxHxLeftOpen, FRxHxLeftPinned, FRxHxLeftAnimating: Boolean;
    FRxHxRightOpen, FRxHxRightAnimating, FRxHxLoaded: Boolean;
    FRxHxLeftOpenWidth, FRxHxLeftClosedWidth: Integer;
    FRxHxLeftAnimationStartWidth, FRxHxLeftAnimationTargetWidth, FRxHxLeftAnimationStep: Integer;
    FRxHxRightOpenWidth, FRxHxRightClosedWidth: Integer;
    FRxHxRightAnimationStartWidth, FRxHxRightAnimationTargetWidth, FRxHxRightAnimationStep: Integer;
    procedure RxHxTreeChange(Sender: TObject; Node: TTreeNode); //kt //codex 11/3/26
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
  tcRxHxView.OnChange := RxHxViewChange; //kt //codex 11/3/26
  tvRxHx.OnMouseDown := RxHxTreeMouseDown; //kt //codex 11/3/26
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
  tvRxHx.Items.Clear;
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

procedure TfrmRxHistory.RxHxViewChange(Sender: TObject);
//kt //codex added entire procedure 11/3/26
begin
  if FRxHxLoaded and FRxHxSummaryLoaded then begin
    Inc(FRxHxSelectionSerial);
    RebuildRxHxTree;
  end;
end;

procedure TfrmRxHistory.LoadRxHxSummary;
//kt //codex added entire procedure 11/2/26
var
  Status: string;
begin
  FRxHxSummaryLoaded := False;
  Inc(FRxHxSelectionSerial); //kt //codex 11/3/26
  FRxHxSummary.Clear;
  tvRxHx.Items.Clear;
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
  Line, TIUIEN, NoteDate, YearText, CurrentYear: string;
  YearNode: TTreeNode;
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
    CurrentYear := '';
    YearNode := nil;
    tvRxHx.Items.BeginUpdate;
    try
      tvRxHx.Items.Clear;
      for I := SortedNotes.Count - 1 downto 0 do begin
        NoteIndex := StrToInt(Piece(SortedNotes[I], '^', 2));
        Line := FRxHxSummary[NoteIndex];
        YearText := FormatFMDateTimeStr('yyyy', Piece(Line, '^', 4));
        if YearText = '' then begin
          YearText := 'Unknown year';
        end;
        if (not Assigned(YearNode)) or (YearText <> CurrentYear) then begin
          CurrentYear := YearText;
          YearNode := tvRxHx.Items.Add(nil, YearText);
        end;
        tvRxHx.Items.AddChildObject(YearNode, RxHxNoteLabel(Line), Pointer(NativeInt(NoteIndex + 1)));
      end;
    finally
      tvRxHx.Items.EndUpdate;
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
  if tcRxHxView.TabIndex = 1 then begin //kt //codex 11/3/26
    RebuildRxHxDateTree; //kt //codex 11/3/26
    Exit; //kt //codex 11/3/26
  end; //kt //codex 11/3/26
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
end;

function RxHxTableHTML(Lines: TStrings): string;
//kt //codex added entire function 11/3/26
var
  HTML: TStringList;
  TableType, LineType, LineText: string;
  I, Kind, Count: Integer;
  Modified: Boolean;
begin
  HTML := TStringList.Create;
  try
    HTML.Add('<!DOCTYPE html><html><head><style>');
    HTML.Add('body {font-family: Segoe UI, Tahoma, Arial, sans-serif; margin: 0; padding: 8px;}');
    HTML.Add('.container {margin: 0 0 8px 0; overflow-x: auto; overflow-y: hidden;}');
    HTML.Add('table {border: 1px solid #9fbad0; border-collapse: separate; border-spacing: 0; min-width: 100%;}');
    HTML.Add('th {background: #2f75b5; color: white; text-align: left; padding: 5px 8px;}');
    HTML.Add('td {font-family: Consolas, Courier New, monospace; white-space: pre; padding: 1px 8px;}');
    HTML.Add('.empty {color: #666; font-style: italic;} .spacer td {height: 14px; padding: 0;}');
    HTML.Add('</style></head><body>');
    for Kind := 1 to 2 do begin
      TableType := IntToStr(Kind);
      if Kind = 1 then begin
        LineText := 'Incoming medications';
      end else begin
        LineText := 'Final medications';
      end;
      HTML.Add('<div class="container"><table><thead><tr><th>' + LineText + '</th></tr></thead><tbody>');
      Count := 0;
      for I := 0 to Lines.Count - 1 do begin
        LineType := Piece(Lines[I], '^', 1);
        if LineType = TableType then begin
          LineText := Piece(Lines[I], '^', 2);
          HTML.Add('<tr><td>' + HTMLEncode(LineText, Modified) + '</td></tr>');
          Inc(Count);
        end;
      end;
      if Count = 0 then begin
        HTML.Add('<tr><td class="empty">No medication entries found.</td></tr>');
      end;
      HTML.Add('<tr class="spacer"><td>&nbsp;</td></tr></tbody></table></div>');
    end;
    HTML.Add('</body></html>');
    Result := HTML.Text;
  finally
    HTML.Free;
  end;
end;

procedure TfrmRxHistory.RxHxTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
//kt //codex added entire procedure 11/3/26
var
  Node: TTreeNode;
  Hit: THitTests;
begin
  if (Button <> mbLeft) or (ssDouble in Shift) then begin
    Exit;
  end;
  Hit := tvRxHx.GetHitTestInfoAt(X, Y);
  if not (htOnLabel in Hit) then begin
    Exit;
  end;
  Node := tvRxHx.GetNodeAt(X, Y);
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
  Status, HTML: string;
begin
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
  NoteLines := TStringList.Create;
  TableLines := TStringList.Create;
  try
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
    WBLoadHTML(wbRxHxData, RxHxTableHTML(TableLines));
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
