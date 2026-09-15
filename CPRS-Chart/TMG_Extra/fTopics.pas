unit fTopics;
//kt //codex 9/14/26  Added entire unit.

interface

uses
  Windows, Classes, Controls, ExtCtrls, Buttons, Graphics, fPage, VA508AccessibilityManager,
  Vcl.StdCtrls, Vcl.OleCtrls, SHDocVw, ORCtrls, Vcl.ComCtrls;

type
  TControlCracker = class(TControl);

  TTopicListItemData = class
    PropertyID: string;
  end;

  TfrmTopics = class(TfrmPage)
    pnlTopicsLeft: TPanel;
    splTopicsLeft: TSplitter;
    pnlTopicsCenter: TPanel;
    splTopicsRight: TSplitter;
    pnlTopicsRight: TPanel;
    btnTopicsLeftHandle: TBitBtn;
    timTopicsLeftCollapse: TTimer;
    timHideTopicsLeftHandle: TTimer;
    wbDisplayPrior: TWebBrowser;
    wbEnterNew: TWebBrowser;
    lvTopics: TCaptionListView;
    wbTopicData: TWebBrowser;
    procedure btnTopicsLeftHandleClick(Sender: TObject);
    procedure btnTopicsLeftHandleMouseEnter(Sender: TObject);
    procedure btnTopicsLeftHandleMouseLeave(Sender: TObject);
    procedure pnlTopicsLeftMouseEnter(Sender: TObject);
    procedure pnlTopicsLeftMouseLeave(Sender: TObject);
    procedure splTopicsLeftMoved(Sender: TObject);
    procedure timTopicsLeftCollapseTimer(Sender: TObject);
    procedure timHideTopicsLeftHandleTimer(Sender: TObject);
  protected
    procedure Loaded; override;
    destructor Destroy; override;
  private
    FTopicsLeftOpen: Boolean;
    FTopicsLeftOpenWidth: Integer;
    FTopicsLeftClosedWidth: Integer;
    procedure ClearTopicList;
    function CursorOverControl(AControl: TControl): Boolean;
    procedure InitializeTopicListColumns;
    procedure HideTopicsLeftHandle;
    procedure PositionTopicsLeftHandle;
    procedure QueueTopicsLeftCollapse;
    procedure QueueHideTopicsLeftHandle;
    procedure SetTopicsLeftOpen(Value: Boolean);
    procedure ShowTopicsLeftHandle;
    procedure splTopicsLeftMouseEnter(Sender: TObject);
    procedure splTopicsLeftMouseLeave(Sender: TObject);
    procedure UpdateTopicsLeftHandleGlyph;
  public
    procedure ClearPtData; override;
    procedure RefreshTopicList;
  end;

var
  frmTopics: TfrmTopics;

implementation

{$R *.dfm}

uses
  fFrame, ORFn, rTopics, uCore;

procedure TfrmTopics.Loaded;
begin
  inherited;
  InitializeTopicListColumns;
  FTopicsLeftOpenWidth := pnlTopicsLeft.Width;
  FTopicsLeftClosedWidth := splTopicsLeft.MinSize;
  FTopicsLeftOpen := False;
  pnlTopicsLeft.Width := FTopicsLeftClosedWidth;
  TControlCracker(splTopicsLeft).OnMouseEnter := splTopicsLeftMouseEnter;
  TControlCracker(splTopicsLeft).OnMouseLeave := splTopicsLeftMouseLeave;
  TControlCracker(lvTopics).OnMouseEnter := pnlTopicsLeftMouseEnter;
  TControlCracker(lvTopics).OnMouseLeave := pnlTopicsLeftMouseLeave;
end;

destructor TfrmTopics.Destroy;
begin
  ClearTopicList;
  inherited;
end;

procedure TfrmTopics.ClearPtData;
begin
  inherited;
  ClearTopicList;
end;

procedure TfrmTopics.ClearTopicList;
var
  Index: Integer;
begin
  for Index := 0 to lvTopics.Items.Count - 1 do
    TObject(lvTopics.Items[Index].Data).Free;
  lvTopics.Items.Clear;
end;

procedure TfrmTopics.InitializeTopicListColumns;
var
  Column: TListColumn;
begin
  lvTopics.ViewStyle := vsReport;
  if lvTopics.Columns.Count > 0 then Exit;

  Column := lvTopics.Columns.Add;
  Column.Caption := 'Topic';
  Column.Width := 160;
  Column := lvTopics.Columns.Add;
  Column.Caption := 'Hidden';
  Column.Width := 55;
  Column := lvTopics.Columns.Add;
  Column.Caption := 'User Data';
  Column.Width := 120;
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
        ListItem := lvTopics.Items.Add;
        ListItem.Data := TopicData;
        ListItem.Caption := Piece(TopicListData[Index], '^', 2);
        ListItem.SubItems.Add(Piece(TopicListData[Index], '^', 3));
        ListItem.SubItems.Add(Piece(TopicListData[Index], '^', 4));
      end;
    finally
      lvTopics.Items.EndUpdate;
    end;
  finally
    TopicListData.Free;
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
end;

procedure TfrmTopics.QueueTopicsLeftCollapse;
begin
  timTopicsLeftCollapse.Enabled := False;
  timTopicsLeftCollapse.Enabled := True;
end;

procedure TfrmTopics.QueueHideTopicsLeftHandle;
begin
  timHideTopicsLeftHandle.Enabled := False;
  timHideTopicsLeftHandle.Enabled := True;
end;

procedure TfrmTopics.SetTopicsLeftOpen(Value: Boolean);
begin
  FTopicsLeftOpen := Value;
  if FTopicsLeftOpen then
    pnlTopicsLeft.Width := FTopicsLeftOpenWidth
  else
    pnlTopicsLeft.Width := FTopicsLeftClosedWidth;
  UpdateTopicsLeftHandleGlyph;
  PositionTopicsLeftHandle;
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
  if FTopicsLeftOpen then
    FTopicsLeftOpenWidth := pnlTopicsLeft.Width
  else
    FTopicsLeftClosedWidth := pnlTopicsLeft.Width;
  PositionTopicsLeftHandle;
end;

procedure TfrmTopics.pnlTopicsLeftMouseEnter(Sender: TObject);
begin
  timTopicsLeftCollapse.Enabled := False;
  SetTopicsLeftOpen(True);
end;

procedure TfrmTopics.pnlTopicsLeftMouseLeave(Sender: TObject);
begin
  QueueTopicsLeftCollapse;
end;

procedure TfrmTopics.splTopicsLeftMouseEnter(Sender: TObject);
begin
  timTopicsLeftCollapse.Enabled := False;
  ShowTopicsLeftHandle;
end;

procedure TfrmTopics.splTopicsLeftMouseLeave(Sender: TObject);
begin
  QueueTopicsLeftCollapse;
  QueueHideTopicsLeftHandle;
end;

procedure TfrmTopics.btnTopicsLeftHandleClick(Sender: TObject);
begin
  SetTopicsLeftOpen(not FTopicsLeftOpen);
  ShowTopicsLeftHandle;
end;

procedure TfrmTopics.btnTopicsLeftHandleMouseEnter(Sender: TObject);
begin
  timTopicsLeftCollapse.Enabled := False;
  timHideTopicsLeftHandle.Enabled := False;
  splTopicsLeft.Color := clSkyBlue;
end;

procedure TfrmTopics.btnTopicsLeftHandleMouseLeave(Sender: TObject);
begin
  QueueTopicsLeftCollapse;
  QueueHideTopicsLeftHandle;
end;

procedure TfrmTopics.timTopicsLeftCollapseTimer(Sender: TObject);
begin
  if GetCapture <> 0 then Exit;
  if CursorOverControl(pnlTopicsLeft) or CursorOverControl(splTopicsLeft) or CursorOverControl(btnTopicsLeftHandle) then Exit;
  timTopicsLeftCollapse.Enabled := False;
  SetTopicsLeftOpen(False);
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
  Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(TfrmFrame(Owner).ImageListSplitterHandle.Width, TfrmFrame(Owner).ImageListSplitterHandle.Height);
    TfrmFrame(Owner).ImageListSplitterHandle.GetBitmap(ImageIndex, Bitmap);
    btnTopicsLeftHandle.Glyph.Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

end.
