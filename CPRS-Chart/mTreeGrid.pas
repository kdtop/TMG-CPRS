unit mTreeGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Types, Dialogs, ComCtrls, Themes, UxTheme, ORFn, ExtCtrls, StdCtrls;

type

  TLexTreeNode = class(TTreeNode)
  private
    FVUID: string;
    FCode: string;
    FCodeSys: string;
    FCodeIEN: string;
    FCodeDescription: string;
    FTargetCodeSys: string;
    FTargetCode: string;
    FTargetCodeIEN: string;
    FTargetCodeDescription: string;
    FParentIndex: string;
    FResultLine: string;
    FColor : string;    //TMG added 4/11/24
    FLongDescr : string; //TMG addedd 11/13/24
  public
//    Columns: TStrings;
    property VUID: string read FVUID write FVUID;
    property Code: string read FCode write FCode;
    property CodeSys: string read FCodeSys write FCodeSys;
    property CodeIEN: string read FCodeIEN write FCodeIEN;
    property CodeDescription: string read FCodeDescription write FCodeDescription;
    property TargetCode: string read FTargetCode write FTargetCode;
    property TargetCodeSys: string read FTargetCodeSys write FTargetCodeSys;
    property TargetCodeIEN: string read FTargetCodeIEN write FTargetCodeIEN;
    property TargetCodeDescription: string read FTargetCodeDescription write FTargetCodeDescription;
    property ParentIndex: string read FParentIndex write FParentIndex;
    property ResultLine: string read fResultLine write FResultLine;
    property Color: string read FColor write FColor;   //TMG added 4/11/24
    property LongDescr: string read FLongDescr write FLongDescr;   //TMG added 11/13/24
  end;

  TTreeGridFrame = class(TFrame)
    tv: TTreeView;
    pnlTop: TPanel;
    stTitle: TStaticText;
    pnlSpace: TPanel;
    pnlHint: TPanel;
    pnlTarget: TPanel;
    mmoTargetCode: TMemo;
    pnlTargetCodeSys: TPanel;
    pnlCode: TPanel;
    mmoCode: TMemo;
    pnlCodeSys: TPanel;
    pnlDesc: TPanel;
    mmoDesc: TMemo;
    pnlDescText: TPanel;
    procedure tvCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure tvChange(Sender: TObject; Node: TTreeNode);
    procedure pnlTopResize(Sender: TObject);
  private
    fHorizPanelSpace: integer;
    fVertPanelSpace: integer;
    fShowDesc: boolean;
    fShowCode: boolean;
    fShowTargetCode: boolean;
    function GetSelectedNode: TLexTreeNode;
    procedure SetSelectedNode(const Value: TLexTreeNode);
    procedure SetShowCode(const Value: boolean);
    procedure SetShowDescription(const Value: boolean);
    procedure SetShowTargetCode(const Value: boolean);
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure ResizePanels;
    procedure PopulatePanels;
    procedure SetHorizPanelSpace(const Value: integer);
    function GetShowCode: boolean;
    function GetShowDescription: boolean;
    function GetShowTargetCode: boolean;
    procedure SetVertPanelSpace(const Value: integer);
    procedure SetCodeTitle(const Value: string);
    procedure SetDescTitle(const Value: string);
    procedure SetTargetTitle(const Value: string);
    function GetCodeTitle: string;
    function GetDescTitle: string;
    function GetTargetTitle: string;
    function NumLinesWrapped(mmo: TMemo): integer;
    function GetSeparatorSpace: integer;
    procedure SetSeparatorSpace(const Value: integer);
  protected
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  public
    { Public declarations }
    procedure SetColumnTreeModel(ResultSet: TStrings);
    function FindNode(AValue:String): TLexTreeNode;
    property SelectedNode: TLexTreeNode read GetSelectedNode write SetSelectedNode;
    property ShowDescription: boolean read GetShowDescription write SetShowDescription;
    property ShowCode: boolean read GetShowCode write SetShowCode;
    property ShowTargetCode: boolean read GetShowTargetCode write SetShowTargetCode;
    property Title: string read GetTitle write SetTitle;
    property HorizPanelSpace: integer read fHorizPanelSpace write SetHorizPanelSpace;
    property VertPanelSpace: integer read fVertPanelSpace write SetVertPanelSpace;
    property DescTitle: string read GetDescTitle write SetDescTitle;
    property CodeTitle: string read GetCodeTitle write SetCodeTitle;
    property TargetTitle: string read GetTargetTitle write SetTargetTitle;
    property SeparatorSpace: integer read GetSeparatorSpace write SetSeparatorSpace;
    procedure ClearData;
  end;

implementation

uses Math;

{$R *.dfm}

const
  BUTTON_SIZE = 5;
  TreeExpanderSpacing = 6;

{ TTreeGridFrame }

procedure TTreeGridFrame.ClearData;
begin
  tv.Items.Clear;
  if assigned(pnlHint) then begin
    fShowDesc := False;
    fShowCode := False;
    fShowTargetCode := False;
    SelectedNode := nil;  // fires off populate panels
  end;
end;

procedure TTreeGridFrame.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ResizePanels;
end;

function TTreeGridFrame.FindNode(AValue: string): TLexTreeNode;
var
  Node: TLexTreeNode; // Current search node
  SearchText: string;    // search text
  StarPos: integer;      // position of indicator
begin
  AValue := Uppercase(AValue);
  Result := nil;
  if (tv.Items.Count <> 0) then begin
    Node := TLexTreeNode(tv.Items[0]);
    repeat
      StarPos := Pos(' *', Node.Text);
      if (StarPos > 0) then
        SearchText := UpperCase(Copy(Node.Text, 1, StarPos - 1))
      else
        SearchText := UpperCase(Node.Text);

      if (SearchText = AValue) then begin
        Result := Node;
        Result.MakeVisible;
        Result.Selected := True;
      end;
      Node := TLexTreeNode(Node.GetNext);
    until (assigned(Result) or (Node = nil));
  end;
end;

function TTreeGridFrame.GetCodeTitle: string;
begin
  Result := pnlCodeSys.Caption;
end;

function TTreeGridFrame.GetDescTitle: string;
begin
  Result := pnlDescText.Caption;
end;

function TTreeGridFrame.GetTargetTitle: string;
begin
  Result := pnlTargetCodeSys.Caption;
end;

function TTreeGridFrame.GetSelectedNode: TLexTreeNode;
begin
  Result := TLexTreeNode(tv.Selected);
end;

function TTreeGridFrame.GetSeparatorSpace: integer;
begin
  Result := pnlSpace.Height;
end;

function TTreeGridFrame.GetShowCode: boolean;
begin
  Result := fShowCode;
end;

function TTreeGridFrame.GetShowDescription: boolean;
begin
  Result := fShowDesc;
end;

function TTreeGridFrame.GetShowTargetCode: boolean;
begin
  Result := fShowTargetCode;
end;

function TTreeGridFrame.GetTitle: string;
begin
  Result := stTitle.Caption;
end;

function TTreeGridFrame.NumLinesWrapped(mmo: TMemo): integer;
var
  sl: TStringList;
  c: TCanvas;
begin
  c := TCanvas.Create;
  c.Font.Assign(mmo.Font);
  try
    c.Handle := GetDC(0);
    sl := WrapTextByPixels(mmo.lines.Text, mmo.Width, c, PreSeparatorChars, PostSeparatorChars);
    if assigned(sl) then begin
      Result := sl.Count;
      sl.Free;
    end else begin
      Result := 1;
    end;
  finally
    if assigned(c) then c.Free;
  end;
end;

procedure TTreeGridFrame.pnlTopResize(Sender: TObject);
begin
  ResizePanels;
end;

procedure TTreeGridFrame.PopulatePanels;
begin
  if assigned(SelectedNode) then begin
    if mmoDesc.Visible then begin
      if SelectedNode.LongDescr <> '' then begin  //kt added blocks
        mmoDesc.Lines.Text := SelectedNode.LongDescr;
        mmoDesc.ShowHint := false;
        mmoDesc.Hint := '';
      end else begin
        mmoDesc.Lines.Text := SelectedNode.CodeDescription;
        mmoDesc.ShowHint := true;
        mmoDesc.Hint := mmoDesc.Lines.Text;
      end;
      //kt original --> mmoDesc.Lines.Text := SelectedNode.CodeDescription;
    end;
    if pnlCodeSys.Visible and (SelectedNode.CodeSys <> '') then begin
      CodeTitle := SelectedNode.CodeSys + ':  ';
    end;
    if mmoCode.Visible and (SelectedNode.Code <> '') then begin
      mmoCode.Lines.Text := SelectedNode.Code;
    end;
    if pnlTargetCodeSys.Visible and (SelectedNode.TargetCodeSys <> '') then begin
      TargetTitle := SelectedNode.TargetCodeSys + ':  ';
    end;
    if mmoTargetCode.Visible and (SelectedNode.TargetCode <> '') then begin
      mmoTargetCode.Lines.Text := SelectedNode.TargetCode;
    end;
  end else begin
    if mmoDesc.Visible then begin
      mmoDesc.Lines.Clear;
    end;
    if mmoCode.Visible then begin
      mmoCode.Lines.Clear;
    end;
    if mmoTargetCode.Visible then begin
      mmoTargetCode.Lines.Clear;
    end;
  end;
  ResizePanels;
end;

procedure TTreeGridFrame.ResizePanels;
var
  MinWidth: integer;
  NumLines: integer;
  HintHeight: integer;
begin
  MinWidth := 0;
  HintHeight := 1;
  if assigned(pnlDesc) then begin
    if fShowDesc then begin
      NumLines := NumLinesWrapped(mmoDesc);
      pnlDesc.Height := TextHeightByFont(Font.Handle, mmoDesc.Lines.Text) * NumLines +
                        fVertPanelSpace * (NumLines - 1);
      MinWidth := Max(TextWidthByFont(Font.Handle, pnlDescText.Caption) + fHorizPanelSpace, MinWidth);
    end else begin
      pnlDesc.Height := 1;
    end;
    inc(HintHeight, pnlDesc.Height);
  end;
  if assigned(pnlCode) then begin
    pnlCode.Top := pnlDesc.Height + 1;
    if fShowCode then begin
      NumLines := NumLinesWrapped(mmoCode);
      pnlCode.Height := TextHeightByFont(Font.Handle, mmoCode.Lines.Text) * NumLines +
                        fVertPanelSpace * (NumLines - 1);
      MinWidth := Max(TextWidthByFont(Font.Handle, pnlCodeSys.Caption) + fHorizPanelSpace, MinWidth);
    end else begin
      pnlCode.Height := 1;
    end;
    inc(HintHeight, pnlCode.Height);
  end;
  if assigned(pnlTarget) then begin
    pnlTarget.Top := pnlCode.Top + pnlCode.Height + 1;
    if fShowTargetCode then begin
      NumLines := NumLinesWrapped(mmoTargetCode);
      pnlTarget.Height := TextHeightByFont(Font.Handle, mmoTargetCode.Lines.Text) * NumLines +
                         fVertPanelSpace * (NumLines - 1);
      MinWidth := Max(TextWidthByFont(Font.Handle, pnlTargetCodeSys.Caption) + fHorizPanelSpace, MinWidth);
    end else begin
      pnlTarget.Height := 1;
    end;
    inc(HintHeight, pnlTarget.Height);
  end;
  if assigned(pnlHint) then begin
    pnlHint.Height := HintHeight;
  end;
  if assigned(pnlDesc) then begin
    pnlDescText.Width := MinWidth;
  end;
  if assigned(pnlCode) then begin
    pnlCodeSys.Width := MinWidth;
  end;
  if assigned(pnlTarget) then begin
    pnlTargetCodeSys.Width := MinWidth;
  end;
end;

procedure TTreeGridFrame.SetCodeTitle(const Value: string);
begin
  pnlCodeSys.Caption := Value;
end;

procedure TTreeGridFrame.SetColumnTreeModel(ResultSet: TStrings);
var
  i: integer;
  Node: TLexTreeNode;
  RecStr: string;
begin
  if not assigned(ResultSet) or (ResultSet.Text = '') then begin
    ClearData;
  end else begin
    //  1     2        3      4       5       6         7          8     9     15
    //VUID^SCT TEXT^ICDCODE^ICDIEN^CODE SYS^CONCEPT^DESIGNATION^ICDVER^PARENT^COLOR
    tv.Items.Clear;
    tv.Refresh;

    for i := 0 to ResultSet.Count - 1 do begin
      RecStr := ResultSet[i];
      if Piece(RecStr, '^', 2) <> '' then begin
        if Piece(RecStr, '^', 9) = '' then
          Node := TLexTreeNode(tv.Items.Add(nil, Piece(RecStr, '^', 2)))
        else
          Node := TLexTreeNode(tv.Items.AddChild(tv.Items[(StrToInt(Piece(RecStr, '^', 9))-1)], Piece(RecStr, '^', 2)));
        Node.ResultLine := RecStr;
        Node.VUID := Piece(RecStr, '^', 1);
        Node.Text := Piece(RecStr, '^', 2);
        Node.CodeDescription := Node.Text;
        Node.CodeIEN := Piece(RecStr, '^', 4);
        Node.CodeSys := Piece(RecStr, '^', 5);
        Node.Code := Piece(RecStr, '^', 6);
        Node.TargetCode := Piece(RecStr, '^', 3);
        Node.TargetCodeIEN := Piece(RecStr, '^', 4);
        Node.TargetCodeSys := Piece(RecStr, '^', 8);

        if Piece(RecStr, '^', 9) <> '' then
          Node.ParentIndex := IntToStr(StrToInt(Piece(RecStr, '^', 9)) - 1);
        Node.Color := Piece(RecStr, '^', 15);     //TMG added 4/11/24
      end;
    end;
    //sort tree nodes
    tv.AlphaSort(True);
    tv.Enabled := True;
    tv.SetFocus;
  end;
end;

procedure TTreeGridFrame.SetDescTitle(const Value: string);
begin
  pnlDescText.Caption := Value;
end;

procedure TTreeGridFrame.SetHorizPanelSpace(const Value: integer);
begin
  fHorizPanelSpace := Value;
  ResizePanels;
end;

procedure TTreeGridFrame.SetTargetTitle(const Value: string);
begin
  pnlTargetCodeSys.Caption := Value;
end;

procedure TTreeGridFrame.SetSelectedNode(const Value: TLexTreeNode);
begin
  tv.Selected := Value;
  PopulatePanels;
end;

procedure TTreeGridFrame.SetSeparatorSpace(const Value: integer);
begin
  pnlSpace.Height := Value;
end;

procedure TTreeGridFrame.SetShowCode(const Value: boolean);
begin
  fShowCode := Value;
  ResizePanels;
end;

procedure TTreeGridFrame.SetShowDescription(const Value: boolean);
begin
  fShowDesc := Value;
  ResizePanels;
end;

procedure TTreeGridFrame.SetShowTargetCode(const Value: boolean);
begin
  fShowTargetCode := Value;
  ResizePanels;
end;

procedure TTreeGridFrame.SetTitle(const Value: string);
begin
  stTitle.Caption := Value;
end;

procedure TTreeGridFrame.SetVertPanelSpace(const Value: integer);
begin
  fVertPanelSpace := Value;
  ResizePanels;
end;

procedure TTreeGridFrame.tvChange(Sender: TObject; Node: TTreeNode);
begin
  SelectedNode := TLexTreeNode(Node);
end;

procedure TTreeGridFrame.tvCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TLexTreeNode;
end;

end.
