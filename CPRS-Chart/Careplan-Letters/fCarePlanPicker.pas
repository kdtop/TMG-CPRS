unit fCarePlanPicker;
//VEFA-261 added entire unit and form.
//VEFA-261 copied unit from fTemplateEditor and modified heavily...

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  dShared, uTemplates, ORFn, uCore, Clipbrd, rMisc, VAUtils, uConst, rTemplates, ORNet,
  fFindingTemplates, uTemplateFields,
  fTemplateEditor,
  uCarePlan, Dialogs, StdCtrls, ORCtrls, Buttons, ComCtrls, ExtCtrls, Menus, VA508ImageListLabeler,
  fBase508Form, VA508AccessibilityManager;

type
  TCarePlanTreeControl = (tcDel, tcUp, tcDown, tcLbl, tcCopy);
  TCarePlanTreeType = (ttShared, ttPersonal);

  TfrmCarePlanPicker = class(TfrmBase508Form)
    pnlBottom: TPanel;
    pnlMiddle: TPanel;
    Splitter1: TSplitter;
    pnlTop: TPanel;
    pnlShared: TPanel;
    lblShared: TLabel;
    tvShared: TORTreeView;
    tvPersonal: TORTreeView;
    pnlSharedBottom: TPanel;
    cbShHide: TCheckBox;
    pnlSharedGap: TPanel;
    pnlShSearch: TPanel;
    btnShFind: TORAlignButton;
    edtShSearch: TCaptionEdit;
    cbShMatchCase: TCheckBox;
    cbShWholeWords: TCheckBox;
    Splitter2: TSplitter;
    popCarePlans: TPopupMenu;
    mnuNodeSort: TMenuItem;
    mnuFindCarePlans: TMenuItem;
    mnuCollapseTree: TMenuItem;
    pnlPersonal: TPanel;
    lblPersonal: TLabel;
    pnlPersonalBottom: TPanel;
    cbPerHide: TCheckBox;
    pnlPersonalGap: TPanel;
    pnlPerSearch: TPanel;
    btnPerFind: TORAlignButton;
    edtPerSearch: TCaptionEdit;
    cbPerMatchCase: TCheckBox;
    cbPerWholeWords: TCheckBox;
    reBoil: TRichEdit;
    imgLblCarePlans: TVA508ImageListLabeler;
    mnuMain: TMainMenu;
    mnuEdit: TMenuItem;
    mnuCopy: TMenuItem;
    mnuSelectAll: TMenuItem;
    N11: TMenuItem;
    mnuTry: TMenuItem;
    mnuCarePlan: TMenuItem;
    mnuSort: TMenuItem;
    N14: TMenuItem;
    mnuFindShared: TMenuItem;
    mnuFindPersonal: TMenuItem;
    N3: TMenuItem;
    mnuShCollapse: TMenuItem;
    mnuPerCollapse: TMenuItem;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnEdit: TBitBtn;
    cbHideUnlinked: TCheckBox;
    procedure FormDestroy(Sender: TObject);
    procedure tvSharedChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure tvSharedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure FormShow(Sender: TObject);
    procedure cbHideUnlinkedClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnEditCarePlansClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure mnuPerCollapseClick(Sender: TObject);
    procedure mnuShCollapseClick(Sender: TObject);
    procedure mnuFindPersonalClick(Sender: TObject);
    procedure mnuFindSharedClick(Sender: TObject);
    procedure mnuSortClick(Sender: TObject);
    procedure mnuTryClick(Sender: TObject);
    procedure mnuSelectAllClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure popCarePlansPopup(Sender: TObject);
    procedure mnuFindCarePlansClick(Sender: TObject);
    procedure mnuNodeSortClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure tvGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvSharedExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
    procedure tvEnter(Sender: TObject);
    procedure tvTreeChange(Sender: TObject; Node: TTreeNode);
    procedure tvKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FPersonalEmptyNodeCount: integer;
    FInternalHiddenExpand :boolean;
    FCanEditPersonal: boolean;
    FCurTree: TORTreeView;
    FUpdating: boolean;
    FShowingCarePlan: TTemplate;
    FCanDoCOMObjects: boolean;
    FForceContainer: boolean;
    FSharedEmptyNodeCount: integer;
    FCopyNode: TTreeNode;
    FSavePause: integer;
    FFirstShow: boolean;
    FCurrentPersonalUser: Int64;
    FProbData : TCPProblemData;
    FFindShOn: boolean;
    FFindPerOn: boolean;
    FFromMainMenu: boolean;
    FMainMenuTree: TTreeView;
    FBPOK: boolean;
    FFindShNext: boolean;
    FLastFoundShNode: TTreeNode;
    FLastFoundPerNode: TTreeNode;
    FFindPerNext: boolean;
    FSelectedCarePlan : TTemplate;
    FLastExpandStr, FLastSelectStr : string;  //VEFA-261
  protected
    function ChangeTree(NewTree: TORTreeView): boolean;
    procedure EnableControls(ok, Root: boolean);
    procedure ShowInfo(Node: TTreeNode);
    function GetLinkType(const ANode: TTreeNode): TTemplateLinkType;
    procedure Resync(const CarePlans: array of TTemplate);
    function IsCarePlanLocked(Node: TTreeNode): boolean;
    procedure CarePlanLocked(Sender: TObject);
    procedure InitTrees;
    procedure NewPersonalUser(UsrIEN: Int64);
    procedure DisplayBoilerplate(Node: TTreeNode);
    function GetTree: TTreeView;
    procedure SetFindNext(const Tree: TTreeView; const Value: boolean);
    procedure mnuCollapseTreeClick(Sender: TObject);
    procedure mnuBPErrorCheckClick(Sender: TObject);
    procedure ClearTV(TV : TORTreeView);
    procedure SetForHideUnlinkedValue(Checked : boolean);
    function GetSelectedCarePlan : TTemplate;  //VEFA-261
    function GetSelectedCarePlanID : string;  //VEFA-261

 public
    { Public declarations }
    procedure Initialize(ProbData : TCPProblemData);
    property  SelectedCarePlan : TTemplate read FSelectedCarePlan;  //can be nil
  end;

var
  frmCarePlanPicker: TfrmCarePlanPicker;

implementation

{$R *.dfm}

  uses fTemplateView, {fCarePlanEditor,} fNotes;

  var LaunchingEditor : boolean;


  type
    TTypeIndex = (tiCarePlan, tiFolder, tiGroup, tiDialog, tiRemDlg, tiCOMObj);

  const
    tiNone = TTypeIndex(-1);
    VK_A              = Ord('A');
    VK_C              = Ord('C');
    VK_E              = Ord('E');
    VK_F              = Ord('F');
    VK_G              = Ord('G');
    VK_I              = Ord('I');
    VK_S              = Ord('S');
    VK_T              = Ord('T');
    VK_V              = Ord('V');
    VK_X              = Ord('X');
    VK_Z              = Ord('Z');

  procedure TfrmCarePlanPicker.FormCreate(Sender: TObject);
  begin
    ResizeAnchoredFormToFont(self);
    btnPerFind.Left := pnlPerSearch.ClientWidth - btnPerFind.Width;

    FSavePause := Application.HintHidePause;
    Application.HintHidePause := FSavePause*2;

    FCanDoCOMObjects := false;

    FUpdating := TRUE;
    FFirstShow := TRUE;

    dmodShared.InEditor := TRUE;
    dmodShared.OnTemplateLock := CarePlanLocked;

    pnlShSearch.Visible := FALSE;
    pnlPerSearch.Visible := FALSE;
    FCanEditPersonal := TRUE;

    VEFATemplateMode := cptemCarePlan;  //VEFA-261

  { Don't mess with the order of the following commands! }
    InitTrees;
    tvPersonal.Selected := tvPersonal.Items.GetFirstNode;
    ClearBackup;

    tvPersonal.Selected.Expand(false);

    NewPersonalUser(User.DUZ);

    //HideControls;
    cbShHide.Checked := TRUE;
    cbPerHide.Checked := TRUE;

    SetFormPosition(Self);

    LaunchingEditor := false; //VEFA-261

  end;

  procedure TfrmCarePlanPicker.FormDestroy(Sender: TObject);
  begin
    VEFATemplateMode := cptemNormal;  //VEFA-261
    VEFAFilteringICDCode := '';  //VEFA-261
    dmodshared.Reload;
  end;

  procedure TfrmCarePlanPicker.FormShow(Sender: TObject);
  begin
    if VEFAFilteringICDCode <> '' then begin
      SetForHideUnlinkedValue(true);
    end;
  end;

  procedure TfrmCarePlanPicker.Initialize(ProbData : TCPProblemData);
  begin
    FProbData := ProbData;
    Self.Caption := 'Pick Care Plan Template for ' + ProbData.Description + ' (' + ProbData.ICD + ')';
    VEFAFilteringICDCode := FProbData.ICD;  //VEFA-261
  end;

  procedure TfrmCarePlanPicker.InitTrees;
  begin
    LoadTemplateData;
    if(not assigned(RootTemplate)) then
      SaveTemplate(AddTemplate('0^R^A^Shared Templates'),-1);
    if(not assigned(MyTemplate)) then
      AddTemplate('0^P^A^My Templates^^^'+IntToStr(User.DUZ));
    dmodShared.AddTemplateNode(tvPersonal, FPersonalEmptyNodeCount, MyTemplate);
    dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, RootTemplate);
    if (UserTemplateAccessLevel = taEditor) then
    begin
      if CanEditLinkType(ttTitles) then
        dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, TitlesTemplate);
      if CanEditLinkType(ttConsults) then
        dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, ConsultsTemplate);
      if CanEditLinkType(ttProcedures) then
        dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, ProceduresTemplate);
    end;
  end;

  procedure TfrmCarePlanPicker.NewPersonalUser(UsrIEN: Int64);
  var
    NewEdit: boolean;

  begin
    FCurrentPersonalUser := UsrIEN;
    NewEdit := (FCurrentPersonalUser = User.DUZ);
    if(FCanEditPersonal <> NewEdit) then begin
      FCanEditPersonal := NewEdit;
    end;
  end;


  procedure TfrmCarePlanPicker.popCarePlansPopup(Sender: TObject);
  var
    Tree: TTreeView;
    Node: TTreeNode;
    FindOn: boolean;
    Txt: string;

  begin
    FFromMainMenu := FALSE;
    Tree := GetTree;
    Node := Tree.Selected;
    Tree.Selected := Node; // This line prevents selected from changing after menu closes
    mnuCollapseTree.Enabled := dmodShared.NeedsCollapsing(Tree);
    if(Tree = tvShared) then
    begin
      Txt := 'Shared';
      FindOn := FFindShOn;
    end
    else
    begin
      Txt := 'Personal';
      FindOn := FFindPerOn;
    end;
    mnuFindCarePlans.Checked := FindOn;
    mnuCollapseTree.Caption := 'Collapse '+Txt+' &Tree';
    mnuFindCarePlans.Caption := '&Find '+Txt+' CarePlans';

    if(assigned(Tree) and assigned(Tree.Selected) and assigned(Tree.Selected.Data)) then
    begin
      mnuNodeSort.Enabled := (TTemplate(Tree.Selected.Data).RealType in AllTemplateFolderTypes) and
                             (Tree.Selected.HasChildren) and
                             (Tree.Selected.GetFirstChild.GetNextSibling <> nil);
    end
    else
    begin
      mnuNodeSort.Enabled := FALSE;
    end;
  end;

  procedure TfrmCarePlanPicker.mnuCopyClick(Sender: TObject);
  begin
    reBoil.CopyToClipboard;
  end;

  procedure TfrmCarePlanPicker.mnuFindPersonalClick(Sender: TObject);
  begin
    FMainMenuTree := tvPersonal;
    mnuFindCarePlansClick(tvPersonal);
  end;

  procedure TfrmCarePlanPicker.mnuFindSharedClick(Sender: TObject);
  begin
    FMainMenuTree := tvShared;
    mnuFindCarePlansClick(tvShared);
  end;

  procedure TfrmCarePlanPicker.mnuCollapseTreeClick(Sender: TObject);
  begin
    if(GetTree = tvShared) then
    begin
      tvShared.Selected := tvShared.Items.GetFirstNode;
      tvShared.FullCollapse;
    end
    else
    begin
      tvPersonal.Selected := tvShared.Items.GetFirstNode;
      tvPersonal.FullCollapse;
    end;
  end;

  procedure TfrmCarePlanPicker.mnuFindCarePlansClick(Sender: TObject);
  var
    Tree: TTreeView;

  begin
    Tree := GetTree;
    if(Tree = tvShared) then
    begin
      FFindShOn := not FFindShOn;
      pnlShSearch.Visible := FFindShOn;
      if(FFindShOn) then
      begin
        edtShSearch.SetFocus;
        btnShFind.Enabled := (edtShSearch.Text <> '');
      end;
    end
    else
    begin
      FFindPerOn := not FFindPerOn;
      pnlPerSearch.Visible := FFindPerOn;
      if(FFindPerOn) then
      begin
        edtPerSearch.SetFocus;
        btnPerFind.Enabled := (edtPerSearch.Text <> '');
      end;
    end;
    SetFindNext(Tree, FALSE);
  end;

  procedure TfrmCarePlanPicker.mnuNodeSortClick(Sender: TObject);
  var Tree: TTreeView;
  begin
    Tree := FCurTree;
    if(assigned(Tree) and assigned(Tree.Selected) and Tree.Selected.HasChildren) then
    begin
      TTemplate(Tree.Selected.Data).SortChildren;
      Resync([TTemplate(Tree.Selected.Data)]);
    end;
  end;

  procedure TfrmCarePlanPicker.mnuSelectAllClick(Sender: TObject);
  begin
    reBoil.SelectAll;
  end;

  procedure TfrmCarePlanPicker.mnuPerCollapseClick(Sender: TObject);
  begin
    FMainMenuTree := tvPersonal;
    mnuCollapseTreeClick(tvPersonal);
  end;

  procedure TfrmCarePlanPicker.mnuShCollapseClick(Sender: TObject);
  begin
    FMainMenuTree := tvShared;
    mnuCollapseTreeClick(tvShared);
  end;

  procedure TfrmCarePlanPicker.mnuSortClick(Sender: TObject);
  var
    Tree: TTreeView;

  begin
    Tree := FCurTree;
    if(assigned(Tree) and assigned(Tree.Selected) and Tree.Selected.HasChildren) then
    begin
      TTemplate(Tree.Selected.Data).SortChildren;
      Resync([TTemplate(Tree.Selected.Data)]);
    end;
  end;


  procedure TfrmCarePlanPicker.mnuBPErrorCheckClick(Sender: TObject);
  begin
    FBPOK := FALSE;
    if(reBoil.Lines.Count > 0) then
    begin
      if(dmodShared.TemplateOK(FCurTree.Selected.Data,'OK')) then
      begin
        TestBoilerplate(reBoil.Lines);
        if(RPCBrokerV.Results.Count > 0) then
          InfoBox('Boilerplate Contains Errors:'+CRLF+CRLF+
            RPCBrokerV.Results.Text, 'Error', MB_OK or MB_ICONERROR)
        else
        begin
          FBPOK := TRUE;
          if(assigned(Sender)) then
            InfoBox('No Errors Found in Boilerplate.', 'Information', MB_OK or MB_ICONINFORMATION);
        end;
      end;
    end;
  end;

  procedure TfrmCarePlanPicker.mnuTryClick(Sender: TObject);
  var
    R: TRect;
    Move: boolean;
    tmpl: TTemplate;
    txt: String;
    DBControlData : TDBControlData;

  begin
    mnuBPErrorCheckClick(nil);
    if(FBPOK) or (reBoil.Lines.Count = 0) then
    begin
      Move := assigned(frmTemplateView);
      if(Move) then
      begin
        R := frmTemplateView.BoundsRect;
        frmTemplateView.Free;
        frmTemplateView := nil;
      end;
      tmpl := TTemplate(FCurTree.Selected.Data);
      tmpl.TemplatePreviewMode := TRUE; // Prevents "Are you sure?" dialog when canceling
      DBControlData := TDBControlData.Create;
      //kt txt := tmpl.Text;
      txt := tmpl.GetText(DBControlData);
      if(not tmpl.DialogAborted) then begin
        ShowTemplateData(Self, tmpl.PrintName ,txt);
        DBControlData.MsgNoSave;
      end;
      DBControlData.Free;
      if(Move) then
        frmTemplateView.BoundsRect := R;
      tmpl.TemplatePreviewMode := FALSE;
    end;
  end;

  procedure TfrmCarePlanPicker.tvSharedChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
  begin
    inherited;
    AllowChange := false;
    if assigned(Node) then begin
      AllowChange := uCarePlan.NodeMatchesMode(Node, true, cptemCarePlan)
        or (Node.Text = 'My Templates')
        or (Node.Text = 'Shared Templates');
    end;
  end;

  procedure TfrmCarePlanPicker.tvSharedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
                                                        var DefaultDraw: Boolean);
  //VEFA-261 added
  begin
    inherited;
    if not Assigned(Node.Parent) or NodeMatchesMode(Node, false, cptemCarePlan) then begin
      Sender.Canvas.Font.Color := clBlack;
    end else if NodeMatchesMode(Node, true, cptemCarePlan) then begin
      Sender.Canvas.Font.Color := clBlue;
    end else begin
      Sender.Canvas.Font.Color := clSilver;
    end;
  end;


  procedure TfrmCarePlanPicker.tvSharedExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
  var HideCPPartOfName : boolean;
  begin
    HideCPPartOfName := cbHideUnlinked.Checked;  //VEFA-261 why not used??
    AllowExpansion := dmodShared.ExpandNode(tvShared, Node, FSharedEmptyNodeCount, not cbShHide.Checked, true); //HideCPPartOfName);
    if(AllowExpansion and FInternalHiddenExpand) then
      AllowExpansion := FALSE;
  end;


  procedure TfrmCarePlanPicker.tvTreeChange(Sender: TObject; Node: TTreeNode);
  var
    ok, Something: boolean;
    CarePlan: TTemplate;

  begin
    ChangeTree(TORTreeView(Sender));
    Something := assigned(Node);
    if Something then begin
      CarePlan := TTemplate(Node.Data);
      Something := assigned(CarePlan);
      if Something then begin
        if not LaunchingEditor then begin  //VEFA-261
          try
            FLastExpandStr := TORTreeView(Sender).GetExpandedIDStr(1, ';');
            FLastSelectStr := TORTreeView(Sender).GetNodeID(TORTreeNode(Node),1,';');
          except
            FLastExpandStr := '';
            FLastSelectStr := '';
          end;
        end;
        if(Sender = tvPersonal) then begin
          ok := FCanEditPersonal;
          if ok and (CarePlan.PersonalOwner = 0) {and IsCarePlanLocked(Node)} then begin
            ok := FALSE;
          end;
        end else begin
          ok := FALSE;
        end;
        EnableControls(ok, (CarePlan.RealType in AllTemplateRootTypes));
        ShowInfo(Node);
      end;
    end;
    if not Something then begin
      EnableControls(FALSE, FALSE);
      ShowInfo(nil);
    end;
  end;

  procedure TfrmCarePlanPicker.btnEditCarePlansClick(Sender: TObject);
  var HideSettingStore: boolean;
      SelNodeID : string;
      SelNode : TORTreeNode;
  begin
    HideSettingStore := cbHideUnlinked.Checked;
    LaunchingEditor := true; //VEFA-261
    SetForHideUnlinkedValue(false); //sets shared template data structures show hidden nodes when in editor.
    SelNodeID := GetSelectedCarePlanID;  //VEFA-261
    EditTemplates(Self, false, '', false, FLastExpandStr,FLastSelectStr, cptemCarePlan, nil);
    VEFATemplateMode := cptemCarePlan;

    //Don't mess with the order of these   
    ClearTV(tvShared);
    ClearTV(tvPersonal);
    ReleaseTemplates;
    InitTrees;
    ClearBackup;

    LaunchingEditor := false; //VEFA-261

    //VEFA-261 SetForHideUnlinkedValue(HideSettingStore); //will reset trees.
    //Try to find original node again.

    //VEFA-261 Expand treeviews
    tvShared.Selected := tvShared.Items.GetFirstNode;
    if assigned(tvShared.Selected) and tvShared.Selected.HasChildren  then begin
      tvShared.Selected.Expand(false);
    end;

    tvPersonal.Selected := tvPersonal.Items.GetFirstNode;
    if assigned(tvPersonal.Selected) and tvPersonal.Selected.HasChildren then begin
      tvPersonal.Selected.Expand(false);
    end;

    SelNode := tvPersonal.FindPieceNode(SelNodeID,1,';');
    if assigned(SelNode) then begin
      tvPersonal.Selected := Selnode;
    end else begin
      SelNode := tvShared.FindPieceNode(SelNodeID,1,';');
      if assigned(SelNode) then begin
        tvShared.Selected := Selnode;
      end;
    end;
  end;

  procedure TfrmCarePlanPicker.ClearTV(TV : TORTreeView);
  begin
    while TV.Items.Count > 0 do TV.Items[0].Delete;
  end;

  procedure TfrmCarePlanPicker.btnFindClick(Sender: TObject);
  var
    Found: TTreeNode;
    edtSearch: TEdit;
    IsNext: boolean;
    FindNext: boolean;
    FindWholeWords: boolean;
    FindCase: boolean;
    Tree: TTreeView;
    LastFoundNode, TmpNode: TTreeNode;

  begin
    if(TCarePlanTreeType(TButton(Sender).Tag) = ttShared) then
    begin
      Tree := tvShared;
      edtSearch := edtShSearch;
      FindNext := FFindShNext;
      FindWholeWords := cbShWholeWords.Checked;
      FindCase := cbShMatchCase.Checked;
      LastFoundNode := FLastFoundShNode;
    end
    else
    begin
      Tree := tvPersonal;
      edtSearch := edtPerSearch;
      FindNext := FFindPerNext;
      FindWholeWords := cbPerWholeWords.Checked;
      FindCase := cbPerMatchCase.Checked;
      LastFoundNode := FLastFoundPerNode;
    end;
    if(edtSearch.text <> '') then
    begin
      IsNext := ((FindNext) and assigned (LastFoundNode));
      if IsNext then

        TmpNode := LastFoundNode
      else
        TmpNode := Tree.Items.GetFirstNode;
      FInternalHiddenExpand := TRUE;
      try
        Found := FindTemplate(edtSearch.Text, Tree, Self, TmpNode,
                              IsNext, not FindCase, FindWholeWords);
      finally
        FInternalHiddenExpand := FALSE;
      end;
      if Assigned(Found) then
      begin
        Tree.Selected := Found;
        if(Tree = tvShared) then
          FLastFoundShNode := Found
        else
          FLastFoundPerNode := Found;
        SetFindNext(Tree, TRUE);
      end;
    end;
    edtSearch.SetFocus;
  end;

  function TfrmCarePlanPicker.GetSelectedCarePlan : TTemplate;
  begin
    if assigned(FCurTree) and assigned(FCurTree.Selected) then begin
      FSelectedCarePlan := TTemplate(FCurTree.Selected.Data)
    end else begin
      FSelectedCarePlan := nil
    end;
    Result := FSelectedCarePlan;
  end;

  function TfrmCarePlanPicker.GetSelectedCarePlanID : string;
  begin
    if (FCurTree <> nil) and (FCurTree.Selected <> nil) then begin
      Result :=FCurTree.GetNodeID(TORTreeNode(FCurTree.Selected),1,';');
    end else begin
      Result := '';
    end;
  end;


  procedure TfrmCarePlanPicker.btnOKClick(Sender: TObject);
  begin
    GetSelectedCarePlan; //will store value in FSelectedCarePlan
  end;

  function TfrmCarePlanPicker.ChangeTree(NewTree: TORTreeView): boolean;

  begin
    Result := FALSE;
    tvShared.HideSelection := TRUE;
    tvPersonal.HideSelection := TRUE;
    if(NewTree <> FCurTree) then begin
      Result := TRUE;
      FCurTree := NewTree;
    end;
    if(assigned(FCurTree)) then begin
      FCurTree.HideSelection := FALSE;
      if(FCurTree = tvPersonal) and (Screen.ActiveControl = tvShared) then
        tvPersonal.SetFocus
      else
      if(FCurTree = tvShared) and (Screen.ActiveControl = tvPersonal) then
        tvShared.SetFocus;
    end;
  end;

  procedure TfrmCarePlanPicker.EnableControls(ok, Root: boolean);
  begin
    if(ok and Root) then begin
      ok := FALSE;
    end else begin
      //
    end;
    reBoil.ReadOnly := true;
    UpdateReadOnlyColorScheme(reBoil, reBoil.ReadOnly); //VEFA-261
  end;

  procedure TfrmCarePlanPicker.ShowInfo(Node: TTreeNode);
  var
    OldUpdating, ClearName, ClearRB, ClearAll: boolean;
    Idx: TTypeIndex;
    CanDoCOM: boolean;
    lt: TTemplateLinkType;
    lts: string;

  begin
    btnOK.Enabled := false;  //will be re-enabled if RichEdit populated, and is CarePlan.
    OldUpdating := FUpdating;
    FUpdating := TRUE;
    try
      if(assigned(Node)) then begin
        FShowingCarePlan := TTemplate(Node.Data);
        with FShowingCarePlan do begin
          ClearName := FALSE;
          ClearRB := FALSE;
          ClearAll := FALSE;
          lt := GetLinkType(Node);
          if(lt = ltNone) or (IsReminderDialog and (not (lt in [ltNone, ltTitle]))) then begin
            //
          end else begin
            //
            case lt of
              ltTitle:     lts := 'Title';
              ltConsult:   lts := 'Consult Service';
              ltProcedure: lts := 'Procedure';
              else         lts := '';
            end;
            //cbxLink.Clear;
            if lt = ltConsult then begin
              //cbxLink.LongList := FALSE;
              //if not assigned(FConsultServices) then begin
              //  FConsultServices := TStringList.Create;
              //  FastAssign(LoadServiceListWithSynonyms(1), FConsultServices);
              //  SortByPiece(FConsultServices, U, 2);
              //end;
              //FastAssign(FConsultServices, cbxLink.Items);
            end else begin
              //cbxLink.LongList := TRUE;
              //cbxLink.HideSynonyms := TRUE;
              //cbxLink.InitLongList(LinkName);
            end;
            //cbxLink.SelectByID(LinkIEN);
            //lblLink.Caption := ' Associated ' + lts + ': ';
            //cbxLink.Caption := lblLink.Caption;
          end;

          //edtName.Text := PrintName;
          //reNotes.Lines.Text := Description;
          if(PersonalOwner = 0) and (FCurTree = tvShared) {and (cbEditShared.Checked)} then begin
            //cbLock.Checked := IsLocked;
            if AutoLock then
              //cbLock.Enabled := FALSE;
          end else begin
            //cbLock.Checked := IsCarePlanLocked(Node);
            //cbLock.Enabled := FALSE;
          end;
          CanDoCom := FCanDoCOMObjects and (PersonalOwner = 0);
          if(RealType in AllTemplateRootTypes) then begin
            ClearRB := TRUE;
            ClearAll := TRUE;
          end else begin
            case RealType of
              ttDoc: begin
                       if IsReminderDialog then
                         Idx := tiRemDlg
                       else
                       if IsCOMObject then
                         Idx := tiCOMObj
                       else
                         Idx := tiCarePlan;
                     end;
              ttGroup: begin
                         if(Dialog) then
                           Idx := tiDialog
                         else
                           Idx := tiGroup;
                       end;
              ttClass: Idx := tiFolder;
              else Idx := tiNone;
            end;
            FForceContainer := ((RealType in [ttGroup, ttClass]) and (Children <> tcNone));
            //if not FForceContainer then
            //  cbxType.Items.Add('CarePlan');
            //cbxType.Items.Add('Folder');
            //cbxType.Items.Add('Group CarePlan');
            //cbxType.Items.Add('Dialog');
            //cbxType.ItemIndex := ForcedIdx[FForceContainer, Idx];
            if (Idx = tiCOMObj) and CanDoCOM then begin
              //pnlCOM.Visible := TRUE;
              //cbxCOMObj.SelectByIEN(COMObject);
              //edtCOMParam.Text := COMParam;
            end else begin
              //pnlCOM.Visible := FALSE;
              //cbxCOMObj.ItemIndex := -1;
              //edtCOMParam.Text := '';
            end;
            //cbActive.Checked := Active;
            if(RealType in [ttClass, ttGroup]) then
              //cbHideItems.Checked := HideItems
            else begin
              //cbHideItems.Checked := FALSE;
              //cbHideItems.Enabled := FALSE;
            end;
            if((RealType in [ttDoc, ttGroup]) and (assigned(Node.Parent)) and
               (TTemplate(Node.Parent.Data).RealType = ttGroup) and
               (not IsReminderDialog) and (not IsCOMObject)) then
              //cbExclude.Checked := Exclude
            else begin
              //cbExclude.Checked := FALSE;
              //cbExclude.Enabled := FALSE;
            end;
            if dmodShared.InDialog(Node) and (not IsReminderDialog) and (not IsCOMObject) then begin
              //cbDisplayOnly.Checked := DisplayOnly;
              //cbFirstLine.Checked := FirstLine;
            end else begin
              //cbDisplayOnly.Checked := FALSE;
              //cbDisplayOnly.Enabled := FALSE;
              //cbFirstLine.Checked := FALSE;
              //cbFirstLine.Enabled := FALSE;
            end;
            if(RealType in [ttGroup, ttClass]) and (Children <> tcNone) and (dmodShared.InDialog(Node)) then begin
              //cbOneItemOnly.Checked := OneItemOnly;
              //cbIndent.Checked := IndentItems;
              if(RealType = ttGroup) and (Boilerplate <> '') then begin
                //cbHideDlgItems.Checked := HideDlgItems;
              end else begin
                //cbHideDlgItems.Checked := FALSE;
                //cbHideDlgItems.Enabled := FALSE;
              end;
            end else begin
              //cbOneItemOnly.Checked := FALSE;
              //cbOneItemOnly.Enabled := FALSE;
              //cbHideDlgItems.Checked := FALSE;
              //cbHideDlgItems.Enabled := FALSE;
              //cbIndent.Checked := FALSE;
              //cbIndent.Enabled := FALSE;
            end;
            if(RealType = ttGroup) then
              //edtGap.Text := IntToStr(Gap)
            else begin
              //edtGap.Text := '0';
              //edtGap.Enabled := FALSE;
              //udGap.Enabled := FALSE;
              //udGap.Invalidate;
              //lblLines.Enabled := FALSE;
            end;
            DisplayBoilerPlate(Node);
          end;
        end;
      end else begin
        ClearAll := TRUE;
        ClearRB := TRUE;
        ClearName := TRUE;
      end;
      if(ClearAll) then begin
        reBoil.Clear;
      end;
    finally
      FUpdating := OldUpdating;
    end;
  end;


  procedure TfrmCarePlanPicker.tvEnter(Sender: TObject);
  begin
    if((Sender is TORTreeView) and (ChangeTree(TORTreeView(Sender)))) then
      tvTreeChange(Sender, TORTreeNode(TTreeView(Sender).Selected));
  end;

  procedure TfrmCarePlanPicker.tvGetImageIndex(Sender: TObject; Node: TTreeNode);
  begin
    Node.ImageIndex := dmodShared.ImgIdx(Node);
  end;

  procedure TfrmCarePlanPicker.tvGetSelectedIndex(Sender: TObject; Node: TTreeNode);
  begin
    Node.SelectedIndex := dmodShared.ImgIdx(Node);
  end;

  procedure TfrmCarePlanPicker.tvKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  begin

    if(Key = VK_DELETE) then
    begin
      if(Sender = tvShared) then
      begin
        //if(sbShDelete.Visible and sbShDelete.Enabled) then
        //  sbDeleteClick(sbShDelete);
      end else begin
        //if(sbPerDelete.Visible and sbPerDelete.Enabled) then
        //  sbDeleteClick(sbPerDelete);
      end;
    end;
     //Code Added to provide CTRL Key access for 508 compliance  GRE 3/03
    if (ssCtrl in Shift) and (Key = VK_A) then
        reBoil.SelectAll
    else
    if (ssCtrl in Shift) and (Key = VK_C) then
        reBoil.CopyToClipboard
    else
    if (ssCtrl in Shift) and (Key = VK_E) then
        //mnuBPErrorCheckClick(Self)
    else
    if (ssCtrl in Shift) and (Key = VK_F) then
        //mnuBPInsertFieldClick(Self)
    else
    if (ssCtrl in Shift) and (Key = VK_G) then
        //GrammarCheckForControl(reBoil)
    else
    if (ssCtrl in Shift) and (Key = VK_I) then
        //mnuBPInsertObjectClick(Self)
    else
    if (ssCtrl in Shift) and (Key = VK_S) then
        //SpellCheckForControl(reBoil)
    else
    if (ssCtrl in Shift) and (Key = VK_T) then
        //mnuBPTryClick(Self)
    else
    if (ssCtrl in Shift) and (Key = VK_V) then
        reBoil.SelText := Clipboard.AsText
    else
    if (ssCtrl in Shift) and (Key = VK_X) then
        reBoil.CutToClipboard
    else
    if (ssCtrl in Shift) and (Key = VK_Z) then
        reBoil.Perform(EM_UNDO, 0, 0);
    //End of ---- Code Added to provide CTRL Key access for 508 compliance  GRE 3/03
  end;


  {procedure TfrmCarePlanEditor.ShowCarePlanType(CarePlan: TCarePlan);
  begin
    if(CarePlan.PersonalOwner > 0) then
      //gbProperties.Caption := 'Personal'
    else
      //gbProperties.Caption := 'Shared';
    //gbProperties.Caption := gbProperties.Caption + PropText;
  end;
  }

  function TfrmCarePlanPicker.GetLinkType(const ANode: TTreeNode): TTemplateLinkType;
  var
    Node: TTreeNode;

  begin
    Result := ltNone;
    if assigned(ANode) then
    begin
      if(not assigned(ANode.Data)) or (TTemplate(ANode.Data).RealType <> ttClass) then
      begin
        Node := ANode.Parent;
        repeat
          if assigned(Node) and assigned(Node.Data) then
          begin
            if (TTemplate(Node.Data).FileLink <> '') then
              Node := nil
            else
            if (TTemplate(Node.Data).RealType in AllTemplateLinkTypes) then
            begin
              case TTemplate(Node.Data).RealType of
                ttTitles:     Result := ltTitle;
                ttConsults:   Result := ltConsult;
                ttProcedures: Result := ltProcedure;
              end;
            end
            else
              Node := Node.Parent;
          end
          else
            Node := nil;
        until(Result <> ltNone) or (not assigned(Node));
      end;
    end;
  end;

  procedure TfrmCarePlanPicker.Resync(const CarePlans: array of TTemplate);
  var
    i, j: integer;
    NodeList: TStringList;
    CarePlanList: TStringList;
    Node: TTreeNode;
    tmpl: TTemplate;
    NodeID: string;

  begin
    NodeList := TStringList.Create;
    try
      CarePlanList := TStringList.Create;
      try
        for i := low(CarePlans) to high(CarePlans) do
        begin
          tmpl := CarePlans[i];
          if(assigned(tmpl)) then
          begin
            for j := 0 to tmpl.Nodes.Count-1 do
            begin
              Node := TTreeNode(tmpl.Nodes.Objects[j]);
              if(NodeList.IndexOfObject(Node) < 0) then
              begin
                NodeID := IntToStr(Node.Level);
                NodeID := copy('000',1,4-length(NodeID))+NodeID+U+tmpl.Nodes[j];
                CarePlanList.AddObject(NodeID,tmpl);
                NodeList.AddObject(NodeId,Node);
              end;
            end;
          end;
        end;

      { By Sorting by Node Level, we prevent a Resync
        of nodes deeper within the heirchary }

        NodeList.Sort;

        for i := 0 to NodeList.Count-1 do
        begin
          NodeID := NodeList[i];
          Node := TTreeNode(NodeList.Objects[i]);
          j := CarePlanList.IndexOf(NodeID);
          if(j >= 0) then
          begin
            tmpl := TTemplate(CarePlanList.Objects[j]);
            NodeID := Piece(NodeID,U,2);
            if(tmpl.Nodes.IndexOf(NodeID) >= 0) then
            begin
              if(Node.TreeView = tvShared) then
                dmodShared.Resync(Node, not cbShHide.Checked, FSharedEmptyNodeCount)
              else
              if(Node.TreeView = tvPersonal) then
                dmodShared.Resync(Node, not cbPerHide.Checked, FPersonalEmptyNodeCount);
            end;
          end;
        end;
      finally
        CarePlanList.Free;
      end;
    finally
      NodeList.Free;
    end;
    //EnableNavControls;
    if((assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
      tvTreeChange(FCurTree, TORTreeNode(FCurTree.Selected))
    else
      tvPersonal.Selected := tvPersonal.Items.GetFirstNode;
    FCopyNode := nil;
  end;


  procedure TfrmCarePlanPicker.CarePlanLocked(Sender: TObject);
  begin
    Resync([TTemplate(Sender)]);
    ShowMsg(Format(TemplateLockedText, [TTemplate(Sender).PrintName]));
  end;

  procedure TfrmCarePlanPicker.cbHideUnlinkedClick(Sender: TObject);
  begin
    SetForHideUnlinkedValue(cbHideUnlinked.Checked);
  end;

  procedure TfrmCarePlanPicker.SetForHideUnlinkedValue(Checked : boolean);
  begin
    cbHideUnlinked.Checked := Checked;  //in case function called directly.
    if Checked then begin
      //VEFA-261 FFilteringICDCode := FProbData.ICD;  //VEFA-261
      VEFAFilteringICDCode := FProbData.ICD;  //VEFA-261
      cbHideUnlinked.Font.Style := cbHideUnlinked.Font.Style + [fsBold];
    end else begin
      //VEFA-261 FFilteringICDCode := '';
      VEFAFilteringICDCode := '';  //VEFA-261
      cbHideUnlinked.Font.Style := cbHideUnlinked.Font.Style - [fsBold];
    end;
   { Don't mess with the order of the following commands! }
    ClearTV(tvShared);
    ClearTV(tvPersonal);
    ReleaseTemplates;
    InitTrees;
    ClearBackup;

    //VEFA-261 Expand treeviews
    tvShared.Selected := tvShared.Items.GetFirstNode;
    if assigned(tvShared.Selected) and tvShared.Selected.HasChildren  then begin
      tvShared.Selected.Expand(false);
    end;

    tvPersonal.Selected := tvPersonal.Items.GetFirstNode;
    if assigned(tvPersonal.Selected) and tvPersonal.Selected.HasChildren then begin
      tvPersonal.Selected.Expand(false);
    end;

  end;

  function TfrmCarePlanPicker.IsCarePlanLocked(Node: TTreeNode): boolean;
  var
    CarePlan: TTemplate;

  begin
    Result := FALSE;
    if assigned(Node) then
    begin
      CarePlan := TTemplate(Node.Data);
      if CarePlan.AutoLock then
        Result := TRUE
      else
      if (CarePlan.PersonalOwner = 0) then
      begin
        if RootTemplate.IsLocked then
          Result := TRUE
        else
        begin
          Result := TTemplate(Node.Data).IsLocked;
          if (not Result) and assigned(Node.Parent) and
             (TTemplate(Node.Parent).PersonalOwner = 0) then
            Result := IsCarePlanLocked(Node.Parent);
        end;
      end;
    end;
  end;


  procedure TfrmCarePlanPicker.DisplayBoilerplate(Node: TTreeNode);
  var
    OldUpdating, ItemOK, BPOK, LongLines: boolean;
    i: integer;
    TmpSL: TStringList;

  begin
    OldUpdating := FUpdating;
    FUpdating := TRUE;
    try
      //pnlBoilerplateResize(pnlBoilerplate);
      reBoil.Clear;
      ItemOK := FALSE;
      BPOK := TRUE;
      with Node, TTemplate(Node.Data) do begin
        if(RealType in [ttDoc, ttGroup]) then begin
          TmpSL := TStringList.Create;
          try
            if(RealType = ttGroup) and (not reBoil.ReadOnly) then begin
              ItemOK := TRUE;
              TmpSL.Text := Boilerplate;
              //reGroupBP.Clear;
              //reGroupBP.SelText := FullBoilerplate;
            end else
              TmpSL.Text := FullBoilerplate;
            LongLines := FALSE;
            for i := 0 to TmpSL.Count-1 do begin
              if length(TmpSL[i]) > MAX_ENTRY_WIDTH then begin
                LongLines := TRUE;
                break;
              end;
            end;
            //cbLongLines.Checked := LongLines;
            reBoil.SelText := TmpSL.Text;
            btnOK.Enabled := (TmpSL.Text <> '') and (uCarePlan.NodeMatchesMode(Node,false));
          finally
            TmpSL.Free;
          end;
        end else begin
          reBoil.ReadOnly := TRUE;
          UpdateReadOnlyColorScheme(reBoil, reBoil.ReadOnly);
          //UpdateInsertsDialogs;
        end;
        //ShowGroupBoilerplate(ItemOK);
        if(not ItemOK) and (IsReminderDialog or IsCOMObject) then
          BPOK := FALSE;
        //pnlBoilerplateResize(Self);
        //pnlBoilerplate.Visible := BPOK;
        //lblBoilerplate.Visible := BPOK;
        //pnlCOM.Visible := (not BPOK) and IsCOMObject;
      end;
    finally
      FUpdating := OldUpdating;
    end;
  end;

  function TfrmCarePlanPicker.GetTree: TTreeView;
  begin
    if(FFromMainMenu) then
      Result := FMainMenuTree
    else
    begin
      if(TCarePlanTreeType(PopupComponent(popCarePlans, popCarePlans).Tag) = ttShared) then
        Result := tvShared
      else
        Result := tvPersonal;
    end;
  end;

  procedure TfrmCarePlanPicker.SetFindNext(const Tree: TTreeView; const Value: boolean);
  begin
    if(Tree = tvShared) then
    begin
      if(FFindShNext <> Value) then
      begin
        FFindShNext := Value;
        if(FFindShNext) then btnShFind.Caption := 'Find Next'
        else btnShFind.Caption := 'Find';
      end;
    end
    else
    begin
      if(FFindPerNext <> Value) then
      begin
        FFindPerNext := Value;
        if(FFindPerNext) then btnPerFind.Caption := 'Find Next'
        else btnPerFind.Caption := 'Find';
      end;
    end;
  end;


end.

