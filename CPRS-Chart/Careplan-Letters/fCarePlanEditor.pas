unit fCarePlanEditor;
//kt added entire unit and form.  Derived from fTemplateEditor.
//
//kt NOTE: After creating this form as a CarePlan editor, it was extended to also be
//         a Form Letter Template editor.  Thus there will be many references to
//         'CarePlans' that will actually be letter templates when the mode is set
//         to working with letters.

{The OwnerScan conditional compile variable was created because there were too
 many things that needed to be done to incorporate the viewing of other user's
 personal templates by clinical coordinators.  These include:
   Changing the Personal tree.
   expanding entirely new personal list when personal list changes
   when click on stop editing shared button, and personal is for someone else,
     need to resync to personal list.

HOT HEYS NOT YET ASSIGNED:
JFKQRUVZ
}
{$DEFINE OwnerScan}
{$UNDEF OwnerScan}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, ORCtrls, Buttons, Mask, ORFn, ORNet,
  uCarePlan,
  uTemplates, Menus, ImgList, Clipbrd, ToolWin, MenuBar, TypInfo, MSXML_TLB, fBase508Form,
  VA508AccessibilityManager, VA508ImageListLabeler;

type
  TCarePlanTreeControl = (tcDel, tcUp, tcDown, tcLbl, tcCopy);
  TCarePlanTreeType = (ttShared, ttPersonal);

  TfrmCarePlanEditor = class(TfrmBase508Form)
    splMain: TSplitter;
    pnlBottom: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    pnlBoilerplate: TPanel;
    reBoil: TRichEdit;
    pnlTop: TPanel;
    pnlRightTop: TPanel;
    splProperties: TSplitter;
    pnlCopyBtns: TPanel;
    sbCopyLeft: TBitBtn;
    sbCopyRight: TBitBtn;
    lblCopy: TLabel;
    splMiddle: TSplitter;
    pnlShared: TPanel;
    lblShared: TLabel;
    tvShared: TORTreeView;
    pnlSharedBottom: TPanel;
    sbShUp: TBitBtn;
    sbShDown: TBitBtn;
    sbShDelete: TBitBtn;
    cbShHide: TCheckBox;
    pnlSharedGap: TPanel;
    pnlPersonal: TPanel;
    lblPersonal: TLabel;
    tvPersonal: TORTreeView;
    pnlPersonalBottom: TPanel;
    sbPerUp: TBitBtn;
    sbPerDown: TBitBtn;
    sbPerDelete: TBitBtn;
    cbPerHide: TCheckBox;
    pnlPersonalGap: TPanel;
    popCarePlans: TPopupMenu;
    mnuCollapseTree: TMenuItem;
    mnuFindCarePlans: TMenuItem;
    popBoilerplate: TPopupMenu;
    mnuBPInsertObject: TMenuItem;
    mnuBPErrorCheck: TMenuItem;
    mnuBPSpellCheck: TMenuItem;
    pnlGroupBP: TPanel;
    reGroupBP: TRichEdit;
    lblGroupBP: TLabel;
    splBoil: TSplitter;
    pnlGroupBPGap: TPanel;
    tmrAutoScroll: TTimer;
    popGroup: TPopupMenu;
    mnuGroupBPCopy: TMenuItem;
    mnuBPCut: TMenuItem;
    N2: TMenuItem;
    mnuBPCopy: TMenuItem;
    mnuBPPaste: TMenuItem;
    N4: TMenuItem;
    mnuGroupBPSelectAll: TMenuItem;
    mnuBPSelectAll: TMenuItem;
    N6: TMenuItem;
    mnuNodeCopy: TMenuItem;
    mnuNodePaste: TMenuItem;
    mnuNodeDelete: TMenuItem;
    N8: TMenuItem;
    mnuBPUndo: TMenuItem;
    cbEditShared: TCheckBox;
    pnlProperties: TPanel;
    gbProperties: TGroupBox;
    lblName: TLabel;
    lblLines: TLabel;
    cbExclude: TORCheckBox;
    cbActive: TCheckBox;
    edtGap: TCaptionEdit;
    udGap: TUpDown;
    edtName: TCaptionEdit;
    mnuMain: TMainMenu;
    mnuEdit: TMenuItem;
    mnuUndo: TMenuItem;
    N9: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuSelectAll: TMenuItem;
    N11: TMenuItem;
    mnuInsertObject: TMenuItem;
    mnuErrorCheck: TMenuItem;
    mnuSpellCheck: TMenuItem;
    N13: TMenuItem;
    mnuGroupBoilerplate: TMenuItem;
    mnuGroupCopy: TMenuItem;
    mnuGroupSelectAll: TMenuItem;
    mnuCarePlan: TMenuItem;
    mnuTCopy: TMenuItem;
    mnuTPaste: TMenuItem;
    mnuTDelete: TMenuItem;
    N12: TMenuItem;
    pnlShSearch: TPanel;
    btnShFind: TORAlignButton;
    edtShSearch: TCaptionEdit;
    cbShMatchCase: TCheckBox;
    cbShWholeWords: TCheckBox;
    pnlPerSearch: TPanel;
    btnPerFind: TORAlignButton;
    edtPerSearch: TCaptionEdit;
    cbPerMatchCase: TCheckBox;
    cbPerWholeWords: TCheckBox;
    mnuFindShared: TMenuItem;
    mnuFindPersonal: TMenuItem;
    N3: TMenuItem;
    mnuShCollapse: TMenuItem;
    mnuPerCollapse: TMenuItem;
    pnlMenuBar: TPanel;
    lblPerOwner: TLabel;
    cboOwner: TORComboBox;
    btnNew: TORAlignButton;
    pnlMenu: TPanel;
    mbMain: TMenuBar;
    mnuNewCarePlanTemplate: TMenuItem;
    Bevel1: TBevel;
    mnuNodeNew: TMenuItem;
    mnuBPCheckGrammar: TMenuItem;
    mnuCheckGrammar: TMenuItem;
    N1: TMenuItem;
    N7: TMenuItem;
    N14: TMenuItem;
    mnuSort: TMenuItem;
    N15: TMenuItem;
    mnuNodeSort: TMenuItem;
    mnuTry: TMenuItem;
    mnuBPTry: TMenuItem;
    mnuAutoGen: TMenuItem;
    mnuNodeAutoGen: TMenuItem;
    pnlNotes: TPanel;
    reNotes: TRichEdit;
    splNotes: TSplitter;
    lblNotes: TLabel;
    popNotes: TPopupMenu;
    mnuNotesUndo: TMenuItem;
    MenuItem2: TMenuItem;
    mnuNotesCut: TMenuItem;
    mnuNotesCopy: TMenuItem;
    mnuNotesPaste: TMenuItem;
    MenuItem6: TMenuItem;
    mnuNotesSelectAll: TMenuItem;
    MenuItem8: TMenuItem;
    mnuNotesGrammar: TMenuItem;
    mnuNotesSpelling: TMenuItem;
    cbNotes: TCheckBox;
    gbDialogProps: TGroupBox;
    cbDisplayOnly: TCheckBox;
    cbOneItemOnly: TCheckBox;
    cbHideItems: TORCheckBox;
    cbFirstLine: TCheckBox;
    cbHideDlgItems: TCheckBox;
    cbIndent: TCheckBox;
    mnuTools: TMenuItem;
    mnuEditCarePlanTemplateFields: TMenuItem;
    N16: TMenuItem;
    mnuImportCarePlanTemplate: TMenuItem;
    mnuExportCarePlanTemplate: TMenuItem;
    mnuBPInsertField: TMenuItem;
    mnuInsertField: TMenuItem;
    cbEditUser: TCheckBox;
    dlgImport: TOpenDialog;
    dlgExport: TSaveDialog;
    cbxType: TCaptionComboBox;
    lblType: TLabel;
    cbxRemDlgs: TORComboBox;
    lblRemDlg: TLabel;
    N17: TMenuItem;
    mnuCarePlanIconLegend: TMenuItem;
    pnlBP: TPanel;
    lblBoilerplate: TLabel;
    cbLongLines: TCheckBox;
    cbLock: TORCheckBox;
    mnuRefresh: TMenuItem;
    lblBoilRow: TLabel;
    lblGroupRow: TLabel;
    lblBoilCol: TLabel;
    lblGroupCol: TLabel;
    pnlCOM: TPanel;
    lblCOMParam: TLabel;
    edtCOMParam: TCaptionEdit;
    cbxCOMObj: TORComboBox;
    lblCOMObj: TLabel;
    pnlLink: TPanel;
    cbxLink: TORComboBox;
    lblLink: TLabel;
    imgLblCarePlans: TVA508ImageListLabeler;
    lblLinkedProbs: TLabel;  //kt
    btnAddProblem: TBitBtn;  //kt
    procedure tvSharedChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure tvSharedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure btnAddProblemClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboOwnerNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
    procedure cboOwnerChange(Sender: TObject);
    procedure tvPersonalExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
    procedure tvSharedExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
    procedure tvTreeGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvTreeGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure tvTreeChange(Sender: TObject; Node: TTreeNode);
    procedure splMainMoved(Sender: TObject);
    procedure pnlBoilerplateResize(Sender: TObject);
    procedure edtNameOldChange(Sender: TObject);
    procedure cbActiveClick(Sender: TObject);
    procedure cbExcludeClick(Sender: TObject);
    procedure edtGapChange(Sender: TObject);
    procedure tvTreeEnter(Sender: TObject);
    procedure tvTreeNodeEdited(Sender: TObject; Node: TTreeNode; var S: String);
    procedure cbShHideClick(Sender: TObject);
    procedure cbPerHideClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbMoveUpClick(Sender: TObject);
    procedure sbMoveDownClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure tvTreeDragging(Sender: TObject; Node: TTreeNode; var CanDrag: Boolean);
    procedure tvTreeDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure tvTreeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure sbCopyLeftClick(Sender: TObject);
    procedure sbCopyRightClick(Sender: TObject);
    procedure reBoilChange(Sender: TObject);
    procedure cbEditSharedClick(Sender: TObject);
    procedure popCarePlansPopup(Sender: TObject);
    procedure mnuCollapseTreeClick(Sender: TObject);
    procedure mnuFindCarePlansClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure edtShSearchEnter(Sender: TObject);
    procedure edtShSearchExit(Sender: TObject);
    procedure edtPerSearchEnter(Sender: TObject);
    procedure edtPerSearchExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuBPInsertObjectClick(Sender: TObject);
    procedure mnuBPErrorCheckClick(Sender: TObject);
    procedure popBoilerplatePopup(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuBPSpellCheckClick(Sender: TObject);
    procedure splBoilMoved(Sender: TObject);
    procedure edtGapKeyPress(Sender: TObject; var Key: Char);
    procedure edtNameExit(Sender: TObject);
    procedure tmrAutoScrollTimer(Sender: TObject);
    procedure tvTreeStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure tvTreeEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure mnuGroupBPCopyClick(Sender: TObject);
    procedure popGroupPopup(Sender: TObject);
    procedure mnuBPCutClick(Sender: TObject);
    procedure mnuBPCopyClick(Sender: TObject);
    procedure mnuBPPasteClick(Sender: TObject);
    procedure mnuGroupBPSelectAllClick(Sender: TObject);
    procedure mnuBPSelectAllClick(Sender: TObject);
    procedure mnuNodeDeleteClick(Sender: TObject);
    procedure mnuNodeCopyClick(Sender: TObject);
    procedure mnuNodePasteClick(Sender: TObject);
    procedure mnuBPUndoClick(Sender: TObject);
    procedure tvTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mnuEditClick(Sender: TObject);
    procedure mnuGroupBoilerplateClick(Sender: TObject);
    procedure cbShFindOptionClick(Sender: TObject);
    procedure cbPerFindOptionClick(Sender: TObject);
    procedure mnuCarePlanClick(Sender: TObject);
    procedure mnuFindSharedClick(Sender: TObject);
    procedure mnuFindPersonalClick(Sender: TObject);
    procedure mnuShCollapseClick(Sender: TObject);
    procedure mnuPerCollapseClick(Sender: TObject);
    procedure pnlShSearchResize(Sender: TObject);
    procedure pnlPerSearchResize(Sender: TObject);
    procedure pnlPropertiesResize(Sender: TObject);
    procedure mbMainResize(Sender: TObject);
    procedure mnuBPCheckGrammarClick(Sender: TObject);
    procedure mnuSortClick(Sender: TObject);
    procedure pnlBoilerplateCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure mnuBPTryClick(Sender: TObject);
    procedure mnuAutoGenClick(Sender: TObject);
    procedure reNotesChange(Sender: TObject);
    procedure mnuNotesUndoClick(Sender: TObject);
    procedure mnuNotesCutClick(Sender: TObject);
    procedure mnuNotesCopyClick(Sender: TObject);
    procedure mnuNotesPasteClick(Sender: TObject);
    procedure mnuNotesSelectAllClick(Sender: TObject);
    procedure mnuNotesGrammarClick(Sender: TObject);
    procedure mnuNotesSpellingClick(Sender: TObject);
    procedure popNotesPopup(Sender: TObject);
    procedure cbNotesClick(Sender: TObject);
    procedure cbDisplayOnlyClick(Sender: TObject);
    procedure cbFirstLineClick(Sender: TObject);
    procedure cbOneItemOnlyClick(Sender: TObject);
    procedure cbHideDlgItemsClick(Sender: TObject);
    procedure cbHideItemsClick(Sender: TObject);
    procedure cbIndentClick(Sender: TObject);
    procedure mnuToolsClick(Sender: TObject);
    procedure mnuEditCarePlanTemplateFieldsClick(Sender: TObject);
    procedure mnuBPInsertFieldClick(Sender: TObject);
    procedure mnuExportCarePlanTemplateClick(Sender: TObject);
    procedure mnuImportCarePlanTemplateClick(Sender: TObject);
    procedure cbxTypeDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cbxTypeChange(Sender: TObject);
    procedure cbxRemDlgsChange(Sender: TObject);
    procedure mnuCarePlanIconLegendClick(Sender: TObject);
    procedure cbLongLinesClick(Sender: TObject);
    procedure cbLockClick(Sender: TObject);
    procedure mnuRefreshClick(Sender: TObject);
    procedure reResizeRequest(Sender: TObject; Rect: TRect);
    procedure reBoilSelectionChange(Sender: TObject);
    procedure reGroupBPSelectionChange(Sender: TObject);
    procedure cbxCOMObjChange(Sender: TObject);
    procedure edtCOMParamChange(Sender: TObject);
    procedure cbxLinkNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
    procedure cbxLinkExit(Sender: TObject);
    procedure reBoilKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure reBoilKeyPress(Sender: TObject; var Key: Char);
    procedure reBoilKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FLastRect: TRect;
    FForceContainer: boolean;
    FSavePause: integer;
    FCopyNode: TTreeNode;
    FPasteNode: TTreeNode;
    FCopying: boolean;
    FDropNode: TTreeNode;
    FDropInto: boolean;
    FDragNode: TTreeNode;
    FPersonalEmptyNodeCount: integer;
    FSharedEmptyNodeCount: integer;
//    FOldPersonalCarePlan: TCarePlan;
    FCurrentPersonalUser: Int64;
    FCanEditPersonal: boolean;
    FCanEditShared: boolean;
    FUpdating: boolean;
    FCurTree: TTreeView;
    FTreeControl: array[TCarePlanTreeType, TCarePlanTreeControl] of TControl;
    FInternalHiddenExpand :boolean;
    FFindShOn: boolean;
    FFindShNext: boolean;
    FLastFoundShNode: TTreeNode;
    FFindPerOn: boolean;
    FFindPerNext: boolean;
    FLastFoundPerNode: TTreeNode;
    FFirstShow: boolean;
    FFocusName: boolean;
    FOK2Close: boolean;
    FBtnNewNode: TTreeNode;
    FLastDropNode: TTreeNode;
    FFromMainMenu: boolean;
    FMainMenuTree: TTreeView;
    FDragOverCount: integer;
    FBPOK: boolean;
    FImportingFromXML: boolean;
    FXMLTemplateElement: IXMLDOMNode;
    FXMLFieldElement: IXMLDOMNode;
    FCanDoReminders: boolean;
    FCanDoCOMObjects: boolean;
    //FPersonalObjects: TStringList;
    FShowingCarePlan: TTemplate;
    FConsultServices: TStringList;
    FNavigatingTab: boolean;
    FVEFAMode : TcpteMode;  //kt
    boolNewTemplate: boolean; //kt
  protected
    procedure UpdateXY(re: TRichEdit; lblX, lblY: TLabel);
    function IsCarePlanLocked(Node: TTreeNode): boolean;
    procedure RefreshData;
    procedure ShowCarePlanType(CarePlan: TTemplate);
    procedure DisplayBoilerplate(Node: TTreeNode);
    procedure NewPersonalUser(UsrIEN: Int64);
    procedure HideControls;
    procedure EnableControls(ok, Root: boolean);
    procedure EnableNavControls;
    procedure MoveCopyButtons;
    procedure ShowInfo(Node: TTreeNode);
    function ChangeTree(NewTree: TTreeView): boolean;
    procedure Resync(const CarePlans: array of TTemplate);
    function AllowMove(ADropNode, ADragNode: TTreeNode): boolean;
    function CanClone(const Node: TTreeNode): boolean;
    function Clone(Node: TTreeNode): boolean;
    procedure SharedEditing;
    function GetTree: TTreeView;
    procedure SetFindNext(const Tree: TTreeView; const Value: boolean);
    function ScanNames: boolean;
    function PasteOK: boolean;
    function AutoDel(CarePlan: TTemplate): boolean;
    procedure cbClick(Sender: TCheckBox; Index: integer);
    procedure UpdateInsertsDialogs;
    procedure AutoLongLines(Sender: TObject);
    //procedure UpdatePersonalObjects;
    procedure UpdateApply(CarePlan: TTemplate);
    procedure CarePlanLocked(Sender: TObject);
    procedure InitTrees;
    procedure AdjustControls4FontChange;
    procedure ShowGroupBoilerplate(Visible: boolean);
    function GetLinkType(const ANode: TTreeNode): TTemplateLinkType;
    procedure UpdateNumLinkedDx(Count : integer); //kt
    procedure SetEditMode(Mode : TcpteMode);  //kt
    function PropText : string; //kt
  public
    //property EditMode : TcpteMode read FVEFAMode write SetEditMode; //kt
  end;


procedure EditCarePlans(Form: TForm;
                        ExpandStr,SelectStr : string;  //kt
                        NewEditMode : TcpteMode;
                        NewCarePlan: boolean = FALSE;
                        NewTemplateName: string = '';
                        Shared: boolean = FALSE;
                        ProbData : TCPProblemData = nil);

const
  TemplateEditorSplitters = 'frmTempEditSplitters';
  TemplateEditorSplitters2 = 'frmTempEditSplitters2';

var
  tmplEditorSplitterMiddle: integer = 0;
  tmplEditorSplitterProperties: integer = 0;
  tmplEditorSplitterMain: integer = 0;
  tmplEditorSplitterBoil: integer = 0;
  tmplEditorSplitterNotes: integer = 0;

implementation

{$R *.DFM}

uses dShared, uCore, rCarePlans, rTemplates, fTemplateObjects, uSpell, fTemplateView,
  fTemplateAutoGen, fDrawers, fTemplateFieldEditor, fTemplateFields, XMLUtils,
  fIconLegend, uReminders, uConst, rCore, rEventHooks, rConsults, VAUtils,
  fCarePlanLinkedDxs, fCarePlanPicker,//kt
  rMisc, fFindingTemplates;

const
  //kt PropText = ' CarePlan Properties ';  //converted to function
//  GroupTag = 5;
  BPDisplayOnlyFld  = 0;
  BPFirstLineFld    = 1;
  BPOneItemOnlyFld  = 2;
  BPHideDlgItemsFld = 3;
  BPHideItemsFld    = 4;
  BPIndentFld       = 5;
  BPLockFld         = 6;
  NoIE5 = 'You must have Internet Explorer 5 or better installed to %s Templates';
  NoIE5Header = 'Need Internet Explorer 5';
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

type
  TTypeIndex = (tiCarePlan, tiFolder, tiGroup, tiDialog, tiRemDlg, tiCOMObj);

const
  tiNone = TTypeIndex(-1);
//  TypeTag: array[TTypeIndex] of integer = (7, 6, 8, -8, 7, 7);
  ttDialog = TTemplateType(-ord(ttGroup));

  TypeTag: array[TTypeIndex] of TTemplateType = (ttDoc, ttClass, ttGroup, ttDialog, ttDoc, ttDoc);
  ForcedIdx: array[boolean, TTypeIndex] of integer = ((0,1,2,3,4,5),(-1,0,1,2,-1,-1));
  IdxForced: array[boolean, 0..5] of TTypeIndex = ((tiCarePlan, tiFolder, tiGroup, tiDialog, tiRemDlg, tiCOMObj),
                                                   (tiFolder, tiGroup, tiDialog, tiNone, tiNone, tiNone));
  iMessage = 'This template has one or more new fields, and you are not authorized to create new fields.  ' +
             'If you continue, the program will import the new template without the new fields.  Do you wish ' +
             'to do this?';
  iMessage2 = 'The imported template fields had XML errors.  ';
  iMessage3 = 'No Fields were imported.';

var
  frmTemplateObjects: TfrmTemplateObjects = nil;
  frmTemplateFields: TfrmTemplateFields = nil;

procedure EditCarePlans(Form: TForm;
                        ExpandStr,SelectStr : string;  //kt
                        NewEditMode : TcpteMode;
                        NewCarePlan: boolean = FALSE;
                        NewTemplateName: string = '';
                        Shared: boolean = FALSE;
                        ProbData : TCPProblemData = nil);
var
  frmCarePlanEditor: TfrmCarePlanEditor;
  Drawers: TFrmDrawers;
  SelNode: TTreeNode;
  SelShared: boolean;

begin
  if(UserTemplateAccessLevel in [taReadOnly, taNone]) then exit;

  //kt ExpandStr := '';
  //kt SelectStr := '';
  Drawers := nil;
  {//kt removed original code
  if(not NewCarePlan) and (CopiedText = '') then begin
    if Form is TfrmDrawers then begin
      Drawers := TFrmDrawers(Form)
    end else begin
      if IsPublishedProp(Form, DrawersProperty) then
        Drawers := TFrmDrawers(GetOrdProp(Form, DrawersProperty));
    end;
  end;

  if assigned(Drawers) then begin
    ExpandStr := Drawers.tvTemplates.GetExpandedIDStr(1, ';');
    SelectStr := Drawers.tvTemplates.GetNodeID(TORTreeNode(Drawers.tvTemplates.Selected),1,';');
  end;
  }

  frmCarePlanEditor := TfrmCarePlanEditor.Create(Application);
  try
    with frmCarePlanEditor do begin
      if Form is TfrmCarePlanPicker then begin    //kt
        Top := Form.Top;
        Left := Form.Left;
        Height := Form.Height;
        Width := Form.Width;
      end;
      SetEditMode(NewEditMode);  //kt
      Font := Form.Font;
      reBoil.Font.Size := Form.Font.Size;
      reGroupBP.Font.Size := Form.Font.Size;
      reNotes.Font.Size := Form.Font.Size;
      dmodShared.ExpandTree(tvShared, ExpandStr, FSharedEmptyNodeCount, false, NewEditMode);
      SelNode := tvShared.FindPieceNode(SelectStr,1,';');
      SelShared := assigned(SelNode);
      dmodShared.ExpandTree(tvPersonal, ExpandStr, FPersonalEmptyNodeCount, false, NewEditMode);
      if not SelShared then
        SelNode := tvPersonal.FindPieceNode(SelectStr,1,';');

      if(SelShared and (not Shared)) then
        Shared := TRUE;

      if(Shared and (UserTemplateAccessLevel = taEditor)) then begin
        cbEditShared.Checked := TRUE;
        ActiveControl := tvShared;
        if SelShared then begin
          tvShared.Selected := SelNode;
          if assigned(tvShared.Selected) then tvShared.Selected.Expand(false);
        end else begin
          tvShared.Selected := tvShared.Items.GetFirstNode;
        end;
      end else begin
        if(not SelShared) and (assigned(SelNode)) then begin
          tvPersonal.Selected := SelNode;
          if assigned(tvPersonal.Selected) then tvPersonal.Selected.Expand(false);
        end;
      end;
      if(NewCarePlan) then begin
        btnNewClick(frmCarePlanEditor);
        if(NewTemplateName <> '') and assigned (FBtnNewNode) then begin
          edtName.Text := CheckNamespaceName(NewTemplateName, FVEFAMode);  //kt added
          boolNewTemplate := true;
        end;
      end;
      ShowModal;
    end;
  finally
    frmCarePlanEditor.Free;


  end;
end;

procedure TfrmCarePlanEditor.btnNewClick(Sender: TObject);
var
  idx: integer;
  Tmp, Owner: TTemplate;
  Node, PNode: TTreeNode;
  ownr: string;
  ok: boolean;
  ACheckBox: TCheckBox;

begin
  if((assigned(FCurTree)) and (assigned(FCurTree.Selected))) then begin
    if(FCurTree = tvShared) and (FCanEditShared) then begin
      ok := TRUE
    end else if(FCurTree = tvPersonal) and (FCanEditPersonal) then begin
      ok := TRUE
    end else begin
      ok := FALSE;
    end;
    if ok then begin
      Node := FCurTree.Selected;
      PNode := Node;
      if(TTemplate(Node.Data).RealType = ttDoc) then begin
        PNode := Node.Parent;
      end;
      if CanClone(PNode) then begin
        Clone(PNode);
        Owner := TTemplate(PNode.Data);
        if assigned(Owner) and Owner.CanModify then begin
          if Node = PNode then begin
            idx := 0
          end else begin
            idx := Owner.Items.IndexOf(Node.Data) + 1;
          end;
          if(FCurTree = tvShared) then begin
            ownr := '';
            ACheckBox := cbShHide;
          end else begin
            ownr := IntToStr(User.DUZ);
            ACheckBox := cbPerHide;
          end;
          if FImportingFromXML then begin
            Tmp := TTemplate.CreateFromXML(FXMLTemplateElement, ownr);
            ACheckBox.Checked := ACheckBox.Checked and Tmp.Active;
          end else begin
            Tmp := TTemplate.Create('0^T^A^'+NewTemplateName(FVEFAMode)+'^^^'+ownr);
            Tmp.BackupItems;
            Templates.AddObject(Tmp.ID, Tmp);
          end;
          btnApply.Enabled := TRUE;
          if(idx >= Owner.Items.Count) then begin
            Owner.Items.Add(Tmp)
          end else begin
            Owner.Items.Insert(idx, Tmp);
          end;
          Resync([Owner]);
          Node := FCurTree.Selected;
          if(Node.Data <> Tmp) then begin
            if(TTemplate(Node.Data).RealType = ttDoc) then begin
              Node := Node.GetNextSibling
            end else begin
              Node.Expand(FALSE);
              Node := Node.GetFirstChild;
            end;
            FCurTree.Selected := Node;
          end;
          FBtnNewNode := Node;
          if(FFirstShow) then  begin
            FFocusName := TRUE
          end else begin
            edtName.SetFocus;
            edtName.SelectAll;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.btnAddProblemClick(Sender: TObject);
var
  frmCarePlanLinkedDxs: TfrmCarePlanLinkedDxs;
  CarePlan:             TTemplate;
  TempSL:               TStringList;

begin
  inherited;
  if FUpdating then exit;
  if not assigned(FCurTree) then exit;
  if not assigned(FCurTree.Selected) then exit;
  if not CanClone(FCurTree.Selected) then exit;
  Clone(FCurTree.Selected);
  CarePlan := TTemplate(FCurTree.Selected.Data);
  if not assigned(CarePlan) then exit;
  if not CarePlan.CanModify then exit;
  TempSL := TStringList.Create;
  frmCarePlanLinkedDxs := TfrmCarePlanLinkedDxs.Create(Self);
  try
    CarePlan.LinkedDxsGet(TempSL);
    frmCarePlanLinkedDxs.Initialize(TempSL);
    if frmCarePlanLinkedDxs.ShowModal = mrOK then begin
      frmCarePlanLinkedDxs.GetFinalDxList(TempSL);
      UpdateNumLinkedDx(TempSL.Count);
      CarePlan.LinkedDxsAssign(TempSL);
    end;
  finally
    frmCarePlanLinkedDxs.Free;
    TempSL.Free;
  end;
  UpdateApply(CarePlan);
end;

procedure TfrmCarePlanEditor.UpdateNumLinkedDx(Count : Integer);
var s : string;
begin
  s := IntToStr(Count) + ' Linked Problem';
  if Count <> 1 then s := s + 's';
  lblLinkedProbs.Caption := s
end;

procedure TfrmCarePlanEditor.btnApplyClick(Sender: TObject);
begin
  if(ScanNames) then
  begin
    SaveAllTemplates;
    BtnApply.Enabled := BackupDiffers;
    if not BtnApply.Enabled then
      UnlockAllTemplates;
  end;
end;

procedure TfrmCarePlanEditor.FormCreate(Sender: TObject);
begin
  FVEFAMode := cptemCarePlan; //kt default to careplans
  ResizeAnchoredFormToFont(self);
  //Now fix everything the resize messed up
  lblLines.Width := cbLock.Left - lblLines.Left - 15;
  sbPerDelete.Left := pnlPersonalBottom.ClientWidth - sbPerDelete.Width - 1;
  sbPerDown.Left := sbPerDelete.Left - sbPerDown.Width - 2;
  sbPerUp.Left := sbPerDown.Left - sbPerUp.Width - 2;
  cbPerHide.Width := sbPerUp.Left - 3;
  btnPerFind.Left := pnlPerSearch.ClientWidth - btnPerFind.Width;

  FSavePause := Application.HintHidePause;
  Application.HintHidePause := FSavePause*2;
  if InteractiveRemindersActive then begin
    QuickCopy(GetTemplateAllowedReminderDialogs, cbxRemDlgs.Items);
    FCanDoReminders := (cbxRemDlgs.Items.Count > 0);
  end
  else
    FCanDoReminders := FALSE;

  QuickCopy(GetAllActiveCOMObjects, cbxCOMObj.Items);
  FCanDoCOMObjects := (cbxCOMObj.Items.Count > 0);

  FUpdating := TRUE;
  FFirstShow := TRUE;

  FTreeControl[ttShared,   tcDel]  := sbShDelete;
  FTreeControl[ttShared,   tcUp]   := sbShUp;
  FTreeControl[ttShared,   tcDown] := sbShDown;
  FTreeControl[ttShared,   tcLbl]  := lblCopy;
  FTreeControl[ttShared,   tcCopy] := sbCopyRight;
  FTreeControl[ttPersonal, tcDel]  := sbPerDelete;
  FTreeControl[ttPersonal, tcUp]   := sbPerUp;
  FTreeControl[ttPersonal, tcDown] := sbPerDown;
  FTreeControl[ttPersonal, tcLbl]  := lblCopy;
  FTreeControl[ttPersonal, tcCopy] := sbCopyLeft;
  dmodShared.InEditor := TRUE;
  dmodShared.OnTemplateLock := CarePlanLocked;

  gbProperties.Caption := PropText;
  pnlShSearch.Visible := FALSE;
  pnlPerSearch.Visible := FALSE;
  FCanEditPersonal := TRUE;

{ Don't mess with the order of the following commands! }
  InitTrees;

  tvPersonal.Selected := tvPersonal.Items.GetFirstNode;

  ClearBackup;

  cboOwner.SelText := MixedCase(User.Name);
  NewPersonalUser(User.DUZ);

  cbEditShared.Visible := (UserTemplateAccessLevel = taEditor);
  FCanEditShared := FALSE;
  SharedEditing;

  HideControls;

  lblCopy.AutoSize := TRUE;
  lblCopy.AutoSize := FALSE; // resets height based on font
  lblCopy.Width := pnlCopyBtns.Width + splMiddle.Width;
  MoveCopyButtons;

  cbShHide.Checked := TRUE;
  cbPerHide.Checked := TRUE;

  BtnApply.Enabled := BackupDiffers;
  SetFormPosition(Self);

  boolNewTemplate := false;  //kt
end;

procedure TfrmCarePlanEditor.HideControls;
begin
  sbCopyRight.Visible := FCanEditPersonal;
  if(not FCanEditPersonal) then
    cbPerHide.Checked := TRUE;
  cbPerHide.Visible := FCanEditPersonal;
  sbPerDelete.Visible := FCanEditPersonal;
  sbPerUp.Visible := FCanEditPersonal;
  sbPerDown.Visible := FCanEditPersonal;
  tvPersonal.ReadOnly := not FCanEditPersonal;
  MoveCopyButtons;
end;

procedure TfrmCarePlanEditor.cboOwnerNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
//  cboOwner.ForDataUse(SubSetOfCarePlanOwners(StartFrom, Direction));
end;

procedure TfrmCarePlanEditor.cboOwnerChange(Sender: TObject);
begin
  NewPersonalUser(cboOwner.ItemIEN);
end;

procedure TfrmCarePlanEditor.NewPersonalUser(UsrIEN: Int64);
var
  NewEdit: boolean;

begin
  FCurrentPersonalUser := UsrIEN;
  NewEdit := (FCurrentPersonalUser = User.DUZ);
  if(FCanEditPersonal <> NewEdit) then
  begin
    FCanEditPersonal := NewEdit;
    HideControls;
  end;
end;

procedure TfrmCarePlanEditor.tvPersonalExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  AllowExpansion := dmodShared.ExpandNode(tvPersonal, Node, FPersonalEmptyNodeCount, not cbPerHide.Checked,'',false, FVEFAMode);
  if(AllowExpansion and FInternalHiddenExpand) then AllowExpansion := FALSE;
end;

procedure TfrmCarePlanEditor.tvSharedChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
//kt added
begin
  inherited;
  AllowChange := true; //kt TEMP!!!
  exit;
  AllowChange := false;
  if assigned(Node) then begin
    AllowChange := uCarePlan.NodeMatchesMode(Node, true, FVEFAMode)
      or (Node.Text = 'My Templates')
      or (Node.Text = 'Shared Templates');
  end;
end;


procedure TfrmCarePlanEditor.tvSharedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
                                                    State: TCustomDrawState; var DefaultDraw: Boolean);
//kt added
begin
  inherited;
  if not Assigned(Node.Parent) or NodeMatchesMode(Node, false, FVEFAMode) then begin
    Sender.Canvas.Font.Color := clBlack;
  end else if NodeMatchesMode(Node, true, FVEFAMode) then begin
    Sender.Canvas.Font.Color := clBlue;
  end else begin
    Sender.Canvas.Font.Color := clSilver;
  end;
end;

procedure TfrmCarePlanEditor.tvSharedExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  AllowExpansion := dmodShared.ExpandNode(tvShared, Node, FSharedEmptyNodeCount, not cbShHide.Checked,'',false, FVEFAMode);
  if(AllowExpansion and FInternalHiddenExpand) then AllowExpansion := FALSE;
end;

procedure TfrmCarePlanEditor.tvTreeGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.ImageIndex := dmodShared.ImgIdx(Node);
end;

procedure TfrmCarePlanEditor.tvTreeGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex := dmodShared.ImgIdx(Node);
end;

function TfrmCarePlanEditor.IsCarePlanLocked(Node: TTreeNode): boolean;
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

procedure TfrmCarePlanEditor.tvTreeChange(Sender: TObject; Node: TTreeNode);
var
  ok, Something: boolean;
  CarePlan: TTemplate;
  EnableOK : boolean; //kt

begin
  ChangeTree(TTreeView(Sender));
  Something := assigned(Node);
  EnableOK  := false;
  if Something then begin
    CarePlan := TTemplate(Node.Data);
    //kt EnableOK  := CarePlan.RealType in [ttDoc, ttGroup];
    EnableOK  := uCarePlan.NodeMatchesMode(Node,False,FVEFAMode);
    Something := assigned(CarePlan);
    if Something then begin
      if(Sender = tvPersonal) then begin
        ok := FCanEditPersonal;
        if ok and (CarePlan.PersonalOwner = 0) and IsCarePlanLocked(Node) then begin
          ok := FALSE;
        end;
      end else begin
        ok := FCanEditShared;
      end;
      EnableControls(ok, (CarePlan.RealType in AllTemplateRootTypes));
      ShowInfo(Node);
    end;
  end;
  if not Something then begin
    gbProperties.Caption := PropText;
    EnableControls(FALSE, FALSE);
    ShowInfo(nil);
  end;
  btnOK.Enabled := EnableOK; //kt
  btnAddProblem.Enabled := EnableOK; //kt
end;

procedure TfrmCarePlanEditor.EnableControls(ok, Root: boolean);
begin
  cbLock.Enabled := ok and (FCurTree = tvShared);
  if(ok and Root) then
  begin
    ok := FALSE;
    lblName.Enabled := TRUE;
    edtName.Enabled := TRUE;
    reNotes.ReadOnly := FALSE;
  end
  else
  begin
    lblName.Enabled := ok;
    edtName.Enabled := ok;
    reNotes.ReadOnly := not ok;
  end;
  btnAddProblem.Enabled := ok;
  lblNotes.Enabled := (not reNotes.ReadOnly);
  UpdateReadOnlyColorScheme(reNotes, reNotes.ReadOnly);
  cbxType.Enabled := ok;
  lblType.Enabled := ok;
  lblRemDlg.Enabled := ok;
  cbxRemDlgs.Enabled := ok and FCanDoReminders;
  cbActive.Enabled := ok;
  cbExclude.Enabled := ok;
  cbDisplayOnly.Enabled := ok;
  cbFirstLine.Enabled := ok;
  cbOneItemOnly.Enabled := ok;
  cbHideDlgItems.Enabled := ok;
  cbHideItems.Enabled := ok;
  cbIndent.Enabled := ok;
  edtGap.Enabled := ok;
  udGap.Enabled := ok;
  udGap.Invalidate;
  lblLines.Enabled := ok;
  reBoil.ReadOnly := not ok;
  UpdateReadOnlyColorScheme(reBoil, not ok);
  lblLink.Enabled := ok;
  cbxLink.Enabled := ok;
  ok := ok and FCanDoCOMObjects;
  cbxCOMObj.Enabled := ok;
  lblCOMObj.Enabled := ok;
  edtCOMParam.Enabled := ok;
  lblCOMParam.Enabled := ok;
  UpdateInsertsDialogs;
  EnableNavControls;
end;

procedure TfrmCarePlanEditor.MoveCopyButtons;
var
  tmpHeight: integer;

begin
  tmpHeight := tvShared.Height;
  dec(tmpHeight,lblCopy.Height);
  if(sbCopyLeft.Visible) then
    dec(tmpHeight, sbCopyLeft.Height+5);
  if(sbCopyRight.Visible) then
    dec(tmpHeight, sbCopyRight.Height+5);
  tmpHeight := (tmpHeight div 2) + tvShared.Top;
  lblCopy.Top := tmpHeight;
  inc(tmpHeight,lblCopy.height+5);
  if(sbCopyLeft.Visible) then
  begin
    sbCopyLeft.Top := tmpHeight;
    inc(tmpHeight, sbCopyLeft.Height+5);
  end;
  if(sbCopyRight.Visible) then
    sbCopyRight.Top := tmpHeight;
end;

procedure TfrmCarePlanEditor.splMainMoved(Sender: TObject);
begin
  MoveCopyButtons;
end;

procedure TfrmCarePlanEditor.ShowGroupBoilerplate(Visible: boolean);
begin
  pnlGroupBP.Visible := Visible;
  splBoil.Visible := Visible;
  if Visible then
  begin
    reBoil.Align := alTop;
    pnlGroupBP.Align := alClient;
    reBoil.Height := tmplEditorSplitterBoil;
    splBoil.Top := pnlGroupBP.Top - splBoil.Height;
  end
  else
  begin
    pnlGroupBP.Align := alBottom;
    reBoil.Align := alClient;
  end;
end;

procedure TfrmCarePlanEditor.ShowInfo(Node: TTreeNode);
var
  OldUpdating, ClearName, ClearRB, ClearAll: boolean;
  Idx: TTypeIndex;
  CanDoCOM: boolean;
  lt: TTemplateLinkType;
  lts: string;

begin
  OldUpdating := FUpdating;
  FUpdating := TRUE;
  try
    if(assigned(Node)) then begin
      FShowingCarePlan := TTemplate(Node.Data);
      UpdateNumLinkedDx(FShowingCarePlan.LinkedDxsCount);
      with FShowingCarePlan do begin
        ClearName := FALSE;
        ClearRB := FALSE;
        ClearAll := FALSE;
        ShowCarePlanType(TTemplate(Node.Data));
        lt := GetLinkType(Node);
        if(lt = ltNone) or (IsReminderDialog and (not (lt in [ltNone, ltTitle]))) then begin
          pnlLink.Visible := FALSE
        end else begin
          pnlLink.Visible := TRUE;
          pnlLink.Tag := ord(lt);
          case lt of
            ltTitle:     lts := 'Title';
            ltConsult:   lts := 'Consult Service';
            ltProcedure: lts := 'Procedure';
            else          lts := '';
          end;
          cbxLink.Clear;
          if lt = ltConsult then begin
            cbxLink.LongList := FALSE;
            if not assigned(FConsultServices) then begin
              FConsultServices := TStringList.Create;
              FastAssign(LoadServiceListWithSynonyms(1), FConsultServices);
              SortByPiece(FConsultServices, U, 2);
            end;
            FastAssign(FConsultServices, cbxLink.Items);
          end else begin
            cbxLink.LongList := TRUE;
            cbxLink.HideSynonyms := TRUE;
            cbxLink.InitLongList(LinkName);
          end;
          cbxLink.SelectByID(LinkIEN);
          lblLink.Caption := ' Associated ' + lts + ': ';
          cbxLink.Caption := lblLink.Caption;
        end;

        edtName.Text := PrintName;
        reNotes.Lines.Text := Description;
        if(PersonalOwner = 0) and (FCurTree = tvShared) and (cbEditShared.Checked) then begin
          cbLock.Checked := IsLocked;
          if AutoLock then begin
            cbLock.Enabled := FALSE;
          end;
        end else begin
          cbLock.Checked := IsCarePlanLocked(Node);
          cbLock.Enabled := FALSE;
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
          end; {case}
          FForceContainer := ((RealType in [ttGroup, ttClass]) and (Children <> tcNone));
          cbxType.Items.Clear;
          if not FForceContainer then
            cbxType.Items.Add(TEMPLATE_MODE_NAME[FVEFAMode]);
          cbxType.Items.Add('Folder');
          cbxType.Items.Add('Group ' + TEMPLATE_MODE_NAME[FVEFAMode]);
          cbxType.Items.Add(TEMPLATE_MODE_NAME[FVEFAMode] + ' Dialog');
          if (not FForceContainer) then begin
            if(FCanDoReminders or CanDoCOM) then
              cbxType.Items.Add('Reminder Dialog');
            if(CanDoCOM) then
              cbxType.Items.Add('COM Object');
          end;
          cbxType.ItemIndex := ForcedIdx[FForceContainer, Idx];
          if(Idx = tiRemDlg) and FCanDoReminders then begin
            cbxRemDlgs.SelectByID(ReminderDialogIEN)
          end else begin
            lblRemDlg.Enabled := FALSE;
            cbxRemDlgs.Enabled := FALSE;
            cbxRemDlgs.ItemIndex := -1;
          end;
          if (Idx = tiCOMObj) and CanDoCOM then begin
            pnlCOM.Visible := TRUE;
            cbxCOMObj.SelectByIEN(COMObject);
            edtCOMParam.Text := COMParam;
          end else begin
            pnlCOM.Visible := FALSE;
            cbxCOMObj.ItemIndex := -1;
            edtCOMParam.Text := '';
          end;
          cbActive.Checked := Active;
          if(RealType in [ttClass, ttGroup]) then begin
            cbHideItems.Checked := HideItems
          end else begin
            cbHideItems.Checked := FALSE;
            cbHideItems.Enabled := FALSE;
          end;
          if((RealType in [ttDoc, ttGroup]) and (assigned(Node.Parent)) and
             (TTemplate(Node.Parent.Data).RealType = ttGroup) and
             (not IsReminderDialog) and (not IsCOMObject)) then begin
            cbExclude.Checked := Exclude
          end else begin
            cbExclude.Checked := FALSE;
            cbExclude.Enabled := FALSE;
          end;
          if dmodShared.InDialog(Node) and (not IsReminderDialog) and (not IsCOMObject) then begin
            cbDisplayOnly.Checked := DisplayOnly;
            cbFirstLine.Checked := FirstLine;
          end else begin
            cbDisplayOnly.Checked := FALSE;
            cbDisplayOnly.Enabled := FALSE;
            cbFirstLine.Checked := FALSE;
            cbFirstLine.Enabled := FALSE;
          end;
          if(RealType in [ttGroup, ttClass]) and (Children <> tcNone) and (dmodShared.InDialog(Node)) then begin
            cbOneItemOnly.Checked := OneItemOnly;
            cbIndent.Checked := IndentItems;
            if(RealType = ttGroup) and (Boilerplate <> '') then begin
              cbHideDlgItems.Checked := HideDlgItems;
            end else begin
              cbHideDlgItems.Checked := FALSE;
              cbHideDlgItems.Enabled := FALSE;
            end;
          end else begin
            cbOneItemOnly.Checked := FALSE;
            cbOneItemOnly.Enabled := FALSE;
            cbHideDlgItems.Checked := FALSE;
            cbHideDlgItems.Enabled := FALSE;
            cbIndent.Checked := FALSE;
            cbIndent.Enabled := FALSE;
          end;
          if(RealType = ttGroup) then begin
            edtGap.Text := IntToStr(Gap)
          end else begin
            edtGap.Text := '0';
            edtGap.Enabled := FALSE;
            udGap.Enabled := FALSE;
            udGap.Invalidate;
            lblLines.Enabled := FALSE;
          end;
          DisplayBoilerPlate(Node);
        end;
      end;
    end else begin
      ClearAll := TRUE;
      ClearRB := TRUE;
      ClearName := TRUE;
      gbProperties.Caption := PropText;
    end;
    if(ClearName) then begin
      edtName.Text := '';
      reNotes.Clear;
    end;
    if(ClearRB) then begin
      cbxType.ItemIndex := Ord(tiNone);
    end;
    if(ClearAll) then begin
      cbActive.Checked := FALSE;
      cbExclude.Checked := FALSE;
      cbDisplayOnly.Checked := FALSE;
      cbFirstLine.Checked := FALSE;
      cbOneItemOnly.Checked := FALSE;
      cbHideDlgItems.Checked := FALSE;
      cbHideItems.Checked := FALSE;
      cbIndent.Checked := FALSE;
      edtGap.Text := '0';
      reBoil.Clear;
      ShowGroupBoilerplate(False);
      pnlBoilerplateResize(Self);
      pnlCOM.Visible := FALSE;
      pnlLink.Visible := FALSE;
    end;
    if cbDisplayOnly.Enabled  or
       cbFirstLine.Enabled    or
       cbIndent.Enabled       or
       cbOneItemOnly.Enabled  or
       cbHideDlgItems.Enabled then begin
      gbDialogProps.Font.Color := clWindowText
    end else
      gbDialogProps.Font.Color := clInactiveCaption;
  finally
    FUpdating := OldUpdating;
  end;
end;

procedure TfrmCarePlanEditor.pnlBoilerplateResize(Sender: TObject);
var
  Max: integer;

begin
  if(pnlGroupBP.Visible) and (pnlGroupBP.Height > (pnlBoilerplate.Height-29)) then
  begin
    pnlGroupBP.Height := pnlBoilerplate.Height-29;
  end;
  if cbLongLines.checked then
    Max := 240
  else
    Max := MAX_ENTRY_WIDTH;
  LimitEditWidth(reBoil, Max);
  LimitEditWidth(reNotes, MAX_ENTRY_WIDTH);
end;

procedure TfrmCarePlanEditor.edtNameOldChange(Sender: TObject);
var
  i: integer;
  CarePlan: TTemplate;
  DoRefresh: boolean;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      DoRefresh := Clone(FCurTree.Selected);
      CarePlan := TTemplate(FCurTree.Selected.Data);
      if assigned(CarePlan) and CarePlan.CanModify then
      begin
        CarePlan.PrintName := edtName.Text;
        UpdateApply(CarePlan);
        for i := 0 to CarePlan.Nodes.Count-1 do
          TTreeNode(CarePlan.Nodes.Objects[i]).Text := CarePlan.PrintName;
        if(DoRefresh) then
        begin
          tvShared.Invalidate;
          tvPersonal.Invalidate;
        end;
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.cbActiveClick(Sender: TObject);
var
  i: integer;
  CarePlan: TTemplate;
  Node: TTreeNode;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      Clone(FCurTree.Selected);
      CarePlan := TTemplate(FCurTree.Selected.Data);
      if assigned(CarePlan) and CarePlan.CanModify then
      begin
        CarePlan.Active := cbActive.Checked;
        UpdateApply(CarePlan);
        for i := 0 to CarePlan.Nodes.Count-1 do
        begin
          Node := TTreeNode(CarePlan.Nodes.Objects[i]);
          Node.Cut := not CarePlan.Active;
        end;
        if(FCurTree = tvShared) then
        begin
          cbPerHideClick(Sender);
          cbShHideClick(Sender);
        end
        else
        begin
          cbShHideClick(Sender);
          cbPerHideClick(Sender);
        end;
        tvTreeChange(FCurTree, FCurTree.Selected);
        EnableNavControls;
        if cbActive.CanFocus then
          cbActive.SetFocus;
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.cbExcludeClick(Sender: TObject);
var
  i: integer;
  CarePlan: TTemplate;
  Node: TTreeNode;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      Clone(FCurTree.Selected);
      CarePlan := TTemplate(FCurTree.Selected.Data);
      if assigned(CarePlan) and CarePlan.CanModify then
      begin
        CarePlan.Exclude := cbExclude.Checked;
        UpdateApply(CarePlan);
        for i := 0 to CarePlan.Nodes.Count-1 do
        begin
          Node := TTreeNode(CarePlan.Nodes.Objects[i]);
          Node.ImageIndex := dmodShared.ImgIdx(Node);
          Node.SelectedIndex := dmodShared.ImgIdx(Node);
        end;
        tvShared.Invalidate;
        tvPersonal.Invalidate;
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.edtGapChange(Sender: TObject);
var
  DoRefresh: boolean;
  CarePlan: TTemplate;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      DoRefresh := Clone(FCurTree.Selected);
      CarePlan := TTemplate(FCurTree.Selected.Data);
      if assigned(CarePlan) and CarePlan.CanModify then
      begin
        CarePlan.Gap := StrToIntDef(edtGap.Text, 0);
        UpdateApply(CarePlan);
        DisplayBoilerPlate(FCurTree.Selected);
        if(DoRefresh) then
        begin
          tvShared.Invalidate;
          tvPersonal.Invalidate;
        end;
      end;
    end;
  end;
end;

function TfrmCarePlanEditor.ChangeTree(NewTree: TTreeView): boolean;
var
  i: TCarePlanTreeControl;

begin
  Result := FALSE;
  tvShared.HideSelection := TRUE;
  tvPersonal.HideSelection := TRUE;
  if(NewTree <> FCurTree) then
  begin
    Result := TRUE;
    if(assigned(FCurTree)) then
    begin
      for i := low(TCarePlanTreeControl) to high(TCarePlanTreeControl) do
        FTreeControl[TCarePlanTreeType(FCurTree.Tag), i].Enabled := FALSE;
    end;
    FCurTree := NewTree;
  end;
  if(assigned(FCurTree)) then
  begin
    FCurTree.HideSelection := FALSE;
    if(FCurTree = tvPersonal) and (Screen.ActiveControl = tvShared) then
      tvPersonal.SetFocus
    else
    if(FCurTree = tvShared) and (Screen.ActiveControl = tvPersonal) then
      tvShared.SetFocus;
  end;
end;

procedure TfrmCarePlanEditor.tvTreeEnter(Sender: TObject);
begin
  if((Sender is TTreeView) and (ChangeTree(TTreeView(Sender)))) then
    tvTreeChange(Sender, TTreeView(Sender).Selected);
end;

procedure TfrmCarePlanEditor.tvTreeNodeEdited(Sender: TObject;
  Node: TTreeNode; var S: String);
begin
  FUpdating := TRUE;
  try
    edtName.Text := S;
  finally
    FUpdating := FALSE;
  end;
  edtNameOldChange(edtName);
end;

procedure TfrmCarePlanEditor.cbShHideClick(Sender: TObject);
var
  Node: TTreeNode;

begin
  Node := tvShared.Items.GetFirstNode;
  while assigned(Node) do
  begin
    dmodShared.Resync(Node, not cbShHide.Checked, FSharedEmptyNodeCount);
    Node := Node.getNextSibling;
  end;
  tvTreeChange(tvShared, tvShared.Selected);
  EnableNavControls;
end;

procedure TfrmCarePlanEditor.cbPerHideClick(Sender: TObject);
begin
  dmodShared.Resync(tvPersonal.Items.GetFirstNode, not cbPerHide.Checked, FPersonalEmptyNodeCount);
  tvTreeChange(tvPersonal, tvPersonal.Selected);
  EnableNavControls;
end;

procedure TfrmCarePlanEditor.DisplayBoilerplate(Node: TTreeNode);
var
  OldUpdating, ItemOK, BPOK, LongLines: boolean;
  i: integer;
  TmpSL: TStringList;

begin
  OldUpdating := FUpdating;
  FUpdating := TRUE;
  try
    pnlBoilerplateResize(pnlBoilerplate);
    reBoil.Clear;
    ItemOK := FALSE;
    BPOK := TRUE;
    with Node, TTemplate(Node.Data) do
    begin
      if(RealType in [ttDoc, ttGroup]) then
      begin
        TmpSL := TStringList.Create;
        try
          if(RealType = ttGroup) and (not reBoil.ReadOnly) then
          begin
            ItemOK := TRUE;
            TmpSL.Text := Boilerplate;
            reGroupBP.Clear;
            reGroupBP.SelText := FullBoilerplate;
          end
          else
            TmpSL.Text := FullBoilerplate;
          LongLines := FALSE;
          for i := 0 to TmpSL.Count-1 do
          begin
            if length(TmpSL[i]) > MAX_ENTRY_WIDTH then
            begin
              LongLines := TRUE;
              break;
            end;
          end;
          cbLongLines.Checked := LongLines;
          reBoil.SelText := TmpSL.Text;
        finally
          TmpSL.Free;
        end;
      end
      else
      begin
        reBoil.ReadOnly := TRUE;
        UpdateReadOnlyColorScheme(reBoil, TRUE);
        UpdateInsertsDialogs;
      end;
      ShowGroupBoilerplate(ItemOK);
      if(not ItemOK) and (IsReminderDialog or IsCOMObject) then
        BPOK := FALSE;
      pnlBoilerplateResize(Self);
      pnlBoilerplate.Visible := BPOK;
      lblBoilerplate.Visible := BPOK;
      pnlCOM.Visible := (not BPOK) and IsCOMObject;
    end;
  finally
    FUpdating := OldUpdating;
  end;
end;

procedure TfrmCarePlanEditor.FormDestroy(Sender: TObject);
begin
  KillObj(@FConsultServices);
  Application.HintHidePause := FSavePause;
  if(assigned(frmTemplateObjects)) then
  begin
    frmTemplateObjects.Free;
    frmTemplateObjects := nil;
  end;
  if(assigned(frmTemplateFields)) then
  begin
    frmTemplateFields.Free;
    frmTemplateFields := nil;
  end;
  //---------- CQ #8665 - RV --------
  //KillObj(@FPersonalObjects);
  if (assigned(uPersonalObjects)) then
  begin
    KillObj(@uPersonalObjects);
    uPersonalObjects.Free;
    uPersonalObjects := nil;
  end;
  // ----  end CQ #8665 -------------
  dmodShared.OnTemplateLock := nil;
  dmodShared.InEditor := FALSE;
  RemoveAllNodes;
  ClearBackup;
  UnlockAllTemplates;
  dmodShared.Reload;
end;

procedure TfrmCarePlanEditor.sbMoveUpClick(Sender: TObject);
var
  idx: integer;
  ChangeLevel: boolean;
  ParentsParent, ParentNode, Node: TTreeNode;
  NodeCarePlan, ParentCarePlan, CarePlan: TTemplate;
  Hide, First, ok: boolean;

begin
  if((assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
                              (assigned(FCurTree.Selected.Parent))) then
  begin
    Node := FCurTree.Selected;
    NodeCarePlan := TTemplate(Node.Data);
    ParentNode := Node.Parent;
    CarePlan := TTemplate(ParentNode.Data);
    idx := CarePlan.Items.IndexOf(NodeCarePlan);
    ChangeLevel := (idx < 1);
    if(not ChangeLevel) then
    begin
      if(TCarePlanTreeType(TBitBtn(Sender).Tag) = ttShared) then
        Hide := cbShHide.Checked
      else
        Hide := cbPerHide.Checked;
      First := TRUE;
      while(idx > 0) do
      begin
        if First then
        begin
          ok := FALSE;
          First := FALSE;
          if CanClone(ParentNode) then
          begin
            if(Clone(ParentNode)) then
              CarePlan := TTemplate(ParentNode.Data);
            if CarePlan.CanModify then
              ok := TRUE;
          end;
        end
        else
          ok := TRUE;
        if ok then
        begin
          CarePlan.Items.Exchange(idx-1, idx);
          if(Hide and (not TTemplate(CarePlan.Items[idx]).Active)) then
          begin
            dec(idx);
            ChangeLevel := (idx < 1);
          end
          else
            idx := 0;
        end
        else
          idx := 0;
      end;
    end;
    if(ChangeLevel) then
    begin
      ParentsParent := ParentNode.Parent;
      if(assigned(ParentsParent)) then
      begin
        ParentCarePlan := TTemplate(ParentsParent.Data);
        if(ParentCarePlan.Items.IndexOf(NodeCarePlan) >= 0) then
          InfoBox(ParentsParent.Text + ' already contains the ' +
            NodeCarePlan.PrintName + ' ' + TEMPLATE_MODE_NAME[FVEFAMode] + '.',
            'Error', MB_OK or MB_ICONERROR)
        else
        begin
          if CanClone(ParentNode) then
          begin
            if(Clone(ParentNode)) then
              CarePlan := TTemplate(ParentNode.Data);
            if CarePlan.CanModify and CanClone(ParentsParent) then
            begin
              if(Clone(ParentsParent)) then
                ParentCarePlan := TTemplate(ParentsParent.Data);
              if ParentCarePlan.CanModify then
              begin
                CarePlan.Items.Delete(idx);
                idx := ParentCarePlan.Items.IndexOf(CarePlan);
                if(idx >= 0) then
                begin
                  ParentCarePlan.Items.Insert(idx, NodeCarePlan);
                  Resync([ParentCarePlan, CarePlan]);
                  btnApply.Enabled := TRUE;
                end;
              end;
            end;
          end;
        end;
      end;
    end
    else
    begin
      Resync([CarePlan]);
      btnApply.Enabled := TRUE;
    end;
  end;
end;

procedure TfrmCarePlanEditor.sbMoveDownClick(Sender: TObject);
var
  max, idx: integer;
  ChangeLevel: boolean;
  ParentsParent, ParentNode, Node: TTreeNode;
  NodeCarePlan, ParentCarePlan, CarePlan: TTemplate;
  Hide, First, ok: boolean;

begin
  if((assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
                              (assigned(FCurTree.Selected.Parent))) then
  begin
    Node := FCurTree.Selected;
    NodeCarePlan := TTemplate(Node.Data);
    ParentNode := Node.Parent;
    CarePlan := TTemplate(ParentNode.Data);
    idx := CarePlan.Items.IndexOf(NodeCarePlan);
    max := CarePlan.Items.Count-1;
    ChangeLevel := (idx >= max);
    if(not ChangeLevel) then
    begin
      if(TCarePlanTreeType(TBitBtn(Sender).Tag) = ttShared) then
        Hide := cbShHide.Checked
      else
        Hide := cbPerHide.Checked;
      First := TRUE;
      while(idx < max) do
      begin
        if First then
        begin
          ok := FALSE;
          First := FALSE;
          if CanClone(ParentNode) then
          begin
            if(Clone(ParentNode)) then
              CarePlan := TTemplate(ParentNode.Data);
            if CarePlan.CanModify then
              ok := TRUE;
          end;
        end
        else
          ok := TRUE;
        if ok then
        begin
          CarePlan.Items.Exchange(idx, idx+1);
          if(Hide and (not TTemplate(CarePlan.Items[idx]).Active)) then
          begin
            inc(idx);
            ChangeLevel := (idx >= max);
          end
          else
            idx := max;
        end
        else
          idx := max;
      end;
    end;
    if(ChangeLevel) then
    begin
      ParentsParent := ParentNode.Parent;
      if(assigned(ParentsParent)) then
      begin
        ParentCarePlan := TTemplate(ParentsParent.Data);
        if(ParentCarePlan.Items.IndexOf(NodeCarePlan) >= 0) then
          InfoBox(ParentsParent.Text + ' already contains the ' +
            NodeCarePlan.PrintName + ' ' + TEMPLATE_MODE_NAME[FVEFAMode] + '.',
            'Error', MB_OK or MB_ICONERROR)
        else
        begin
          if CanClone(ParentNode) then
          begin
            if(Clone(ParentNode)) then
              CarePlan := TTemplate(ParentNode.Data);
            if CarePlan.CanModify and CanClone(ParentsParent) then
            begin
              if(Clone(ParentsParent)) then
                ParentCarePlan := TTemplate(ParentsParent.Data);
              if ParentCarePlan.CanModify then
              begin
                CarePlan.Items.Delete(idx);
                idx := ParentCarePlan.Items.IndexOf(CarePlan);
                if(idx >= 0) then
                begin
                  if(idx = (ParentCarePlan.Items.Count-1)) then
                    ParentCarePlan.Items.Add(NodeCarePlan)
                  else
                    ParentCarePlan.Items.Insert(idx+1, NodeCarePlan);
                  Resync([ParentCarePlan, CarePlan]);
                  btnApply.Enabled := TRUE;
                end;
              end;
            end;
          end;
        end;
      end;
    end
    else
    begin
      Resync([CarePlan]);
      btnApply.Enabled := TRUE;
    end;
  end;
end;

procedure TfrmCarePlanEditor.sbDeleteClick(Sender: TObject);
var
  PNode, Node: TTreeNode;
  CarePlan, Parent: TTemplate;
  DoIt: boolean;
  Answer: Word;

begin
  if((assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
                              (assigned(FCurTree.Selected.Parent))) then
  begin
    Node := FCurTree.Selected;
    CarePlan := TTemplate(Node.Data);
    PNode := Node.Parent;
    Parent := TTemplate(PNode.Data);
    if(AutoDel(CarePlan)) then
      DoIt := TRUE
    else
    if(CarePlan.Active) and (cbActive.Checked) then
    begin
      DoIt := FALSE;
      Answer := MessageDlg('Once you delete a '+TEMPLATE_MODE_NAME[FVEFAMode]+' you may not be able to retrieve it.' + CRLF +
                           'Rather than deleting, you may want to inactivate a '+TEMPLATE_MODE_NAME[FVEFAMode]+' instead.' + CRLF +
                           'You may inactivate this '+TEMPLATE_MODE_NAME[FVEFAMode]+' by pressing the Ignore button now.' + CRLF +
                           'Are you sure you want to delete the "' + Node.Text + '" '+TEMPLATE_MODE_NAME[FVEFAMode]+'?',
                           mtConfirmation, [mbYes, mbNo, mbIgnore], 0);
      if(Answer = mrYes) then
        DoIt := TRUE
      else
      if(Answer = mrIgnore) then
        cbActive.Checked := FALSE;
    end
    else
      DoIt := InfoBox('Are you sure you want to delete the "' + Node.Text +
              '" '+TEMPLATE_MODE_NAME[FVEFAMode]+'?', 'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES;
    if(DoIt and CanClone(PNode)) then
    begin
      if(Clone(PNode)) then
        Parent := TTemplate(PNode.Data);
      if assigned(Parent) and Parent.CanModify then
      begin
        btnApply.Enabled := TRUE;
        Parent.RemoveChild(CarePlan);
        MarkDeleted(CarePlan);
        Resync([Parent]);
        tvTreeChange(FCurTree, FCurTree.Selected);
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.EnableNavControls;
var
  i: TCarePlanTreeControl;
  AllowUp, AllowDown, AllowSet: boolean;
  Node: TTreeNode;
  Tree: TCarePlanTreeType;
  Curok: boolean;
  OldActiveControl: TControl;
begin
  if(Assigned(FCurTree)) then
  begin
    Tree := TCarePlanTreeType(FCurTree.Tag);
    Node := FCurTree.Selected;
    if(Assigned(Node)) then
      Curok := (TTemplate(Node.Data).RealType in [ttDoc, ttGroup, ttClass])
    else
      Curok := FALSE;
    if(Curok) then
    begin
      OldActiveControl := ActiveControl;
      FTreeControl[Tree, tcDel].Enabled := TRUE;
      AllowSet := FALSE;
      if(Node.Index > 0) then
        AllowUp := TRUE
      else
      begin
        AllowUp := AllowMove(Node.Parent.Parent, Node);
        AllowSet := TRUE;
      end;
      FTreeControl[Tree, tcUp].Enabled := AllowUp;
      AllowDown := AllowUp;
      if(Node.Index < (Node.Parent.Count-1)) then
        AllowDown := TRUE
      else
      begin
        if(not AllowSet) then
          AllowDown := AllowMove(Node.Parent.Parent, Node);
      end;
      FTreeControl[Tree, tcDown].Enabled := AllowDown;
      if not AllowUp and (OldActiveControl = FTreeControl[Tree, tcUp]) then
        (FTreeControl[Tree, tcDown] as TWinControl).SetFocus;
      if not AllowDown and (OldActiveControl = FTreeControl[Tree, tcDown]) then
        (FTreeControl[Tree, tcUp] as TWinControl).SetFocus;
      FTreeControl[Tree, tcCopy].Enabled := FTreeControl[TCarePlanTreeType(1-ord(Tree)), tcDel].Visible;
      if(FTreeControl[Tree, tcCopy].Enabled) then
      begin
        if(Tree = ttShared) then
          Node := tvPersonal.Selected
        else
          Node := tvShared.Selected;
        if(assigned(Node)) then
        begin
          if(TTemplate(Node.Data).RealType = ttDoc) then
            Node := Node.Parent;
          FTreeControl[Tree, tcCopy].Enabled := AllowMove(Node, FCurTree.Selected);
        end
        else
          FTreeControl[Tree, tcCopy].Enabled := FALSE;
      end;
      FTreeControl[Tree, tcLbl].Enabled := FTreeControl[Tree, tcCopy].Enabled;
    end
    else
    begin
      for i := low(TCarePlanTreeControl) to high(TCarePlanTreeControl) do
        FTreeControl[Tree, i].Enabled := FALSE;
    end;
    if(FCurTree = tvShared) and (FCanEditShared) then
      btnNew.Enabled := TRUE
    else
    if(FCurTree = tvPersonal) and (FCanEditPersonal) then
      btnNew.Enabled := TRUE
    else
      btnNew.Enabled := FALSE;
  end
  else
    btnNew.Enabled := FALSE;
end;

procedure TfrmCarePlanEditor.tvTreeDragging(Sender: TObject;
  Node: TTreeNode; var CanDrag: Boolean);

begin
  CanDrag := (TTemplate(Node.Data).RealType in [ttDoc, ttGroup, ttClass]);
  if(CanDrag) then
    FDragNode := Node
  else
    FDragNode := nil;
end;

procedure TfrmCarePlanEditor.tvTreeDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  TmpNode: TTreeNode;
  Tree: TTreeView;

begin
  FDropNode := nil;
  Accept := FALSE;
  if(Source is TTreeView) and (assigned(FDragNode)) then
  begin
    Tree := TTreeView(Sender);
    FDropNode := Tree.GetNodeAt(X,Y);
    if(((Tree = tvShared)   and (FCanEditShared)) or
       ((Tree = tvPersonal) and (FCanEditPersonal))) then
    begin
      if(assigned(FDropNode)) then
      begin
        FDropInto := (TTemplate(FDropNode.Data).RealType in AllTemplateFolderTypes);
        if(FDropInto) then
          TmpNode := FDropNode
        else
          TmpNode := FDropNode.Parent;
        Accept := AllowMove(TmpNode, FDragNode);
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.tvTreeDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Src, CarePlan, Item: TTemplate;
  SIdx, idx: integer;
  TmpNode: TTreeNode;

begin
  if(assigned(FDragNode)) and (assigned(FDropNode)) and (FDragNode <> FDropNode) then
  begin
    Item := TTemplate(FDragNode.Data);
    if(FDropInto) then
    begin
      TmpNode := FDropNode;
      idx := 0;
    end
    else
    begin
      TmpNode := FDropNode.Parent;
      idx := TTemplate(FDropNode.Parent.Data).Items.IndexOf(FDropNode.Data);
    end;
    if(AllowMove(TmpNode, FDragNode) and (idx >= 0)) then
    begin
      CarePlan := TTemplate(TmpNode.Data);
      if(CarePlan <> FDragNode.Parent.Data) and
        (CarePlan.Items.IndexOf(Item) >= 0) then
        InfoBox(CarePlan.PrintName + ' already contains the ' +
          Item.PrintName + ' '+TEMPLATE_MODE_NAME[FVEFAMode]+'.',
          'Error', MB_OK or MB_ICONERROR)
      else
      begin
        Src := TTemplate(FDragNode.Parent.Data);
        Sidx := Src.Items.IndexOf(Item);
        if CanClone(TmpNode) then
        begin
          if(Clone(TmpNode)) then
            CarePlan := TTemplate(TmpNode.Data);
          if assigned(CarePlan) and CarePlan.CanModify then
          begin
            if(Sidx >= 0) and (FDragNode.TreeView = FDropNode.TreeView) and
              (not FCopying) then // if same tree delete source
            begin
              if CanClone(FDragNode.Parent) then
              begin
                if(Clone(FDragNode.Parent)) then
                  Src := TTemplate(FDragNode.Parent.Data);
                if assigned(Src) and Src.CanModify then
                begin
                  Src.Items.Delete(Sidx);
                  if(CarePlan = Src) then
                    Src := nil;
                end
                else
                  Src := nil;
              end
              else
                Src := nil;
            end
            else
              Src := nil;
            if(idx > 0) then
              idx := TTemplate(FDropNode.Parent.Data).Items.IndexOf(FDropNode.Data);
            CarePlan.Items.Insert(idx, Item);
            if(TTreeView(FDropNode.TreeView) = tvShared) then
            begin
              Item.PersonalOwner := 0;
              tvPersonal.Invalidate;
            end;
            TTreeView(FDragNode.TreeView).Selected := FDragNode;
            TTreeView(FDragNode.TreeView).SetFocus;
            Resync([Src, CarePlan]);
            btnApply.Enabled := TRUE;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.Resync(const CarePlans: array of TTemplate);
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
  EnableNavControls;
  if((assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
    tvTreeChange(FCurTree, FCurTree.Selected)
  else
    tvPersonal.Selected := tvPersonal.Items.GetFirstNode;
  FCopyNode := nil;
end;

procedure TfrmCarePlanEditor.sbCopyLeftClick(Sender: TObject);
begin
  if(assigned(tvPersonal.Selected)) then
  begin
    if(not assigned(tvShared.Selected)) then
      tvShared.Selected := tvShared.Items.GetFirstNode;
    FDragNode := tvPersonal.Selected;
    FDropNode := tvShared.Selected;
    FDropInto := (TTemplate(FDropNode.Data).RealType in AllTemplateFolderTypes);
    tvTreeDragDrop(tvPersonal, tvShared, 0,0);
  end;
end;

procedure TfrmCarePlanEditor.sbCopyRightClick(Sender: TObject);
begin
  if(assigned(tvShared.Selected)) then
  begin
    if(not assigned(tvPersonal.Selected)) then
      tvPersonal.Selected := tvPersonal.Items.GetFirstNode;
    FDragNode := tvShared.Selected;
    FDropNode := tvPersonal.Selected;
    FDropInto := (TTemplate(FDropNode.Data).RealType in AllTemplateFolderTypes);
    tvTreeDragDrop(tvShared, tvPersonal, 0,0);
  end;
end;

procedure TfrmCarePlanEditor.AdjustControls4FontChange;
var
  x: integer;

  procedure Adjust(Control: TWinControl);
  begin
    x := x - Control.Width - 2;
    Control.Left := x;
  end;

begin
  if FCanEditShared then
  begin
    x := pnlSharedBottom.Width;
    Adjust(sbSHDelete);
    Adjust(sbSHDown);
    Adjust(sbSHUp);
    cbSHHide.Width := x;
  end;
  x := pnlBottom.Width;
  Adjust(btnApply);
  Adjust(btnCancel);
  Adjust(btnOK);
  cbEditShared.Width := TextWidthByFont(cbEditShared.Font.Handle, cbEditShared.Caption) + 25;
  cbNotes.Left := cbEditShared.Left + cbEditShared.Width + 60;
  cbNotes.Width := TextWidthByFont(cbNotes.Font.Handle, cbNotes.Caption) + 25;
end;

function TfrmCarePlanEditor.AllowMove(ADropNode, ADragNode: TTreeNode): boolean;
var
  i: integer;
  TmpNode: TTreeNode;
  DragCarePlan, DropCarePlan: TTemplate;

begin
  if(assigned(ADropNode) and assigned(ADragNode)) then begin
    DropCarePlan := TTemplate(ADropNode.Data);
    DragCarePlan := TTemplate(ADragNode.Data);
    if IsCarePlanLocked(ADropNode) then begin
      Result := FALSE
    end else begin
      Result := (DragCarePlan.RealType in [ttDoc, ttGroup, ttClass]);
    end;
    if(Result) then begin
      if(FCopying) then begin
        if(DropCarePlan.Items.IndexOf(DragCarePlan) >= 0) then begin
          Result := FALSE;
        end;
      end else if((assigned(ADragNode.Parent)) and (ADropNode <> ADragNode.Parent) and
        (DropCarePlan.Items.IndexOf(DragCarePlan) >= 0)) then begin
        Result := FALSE;
      end;
    end;
    if(Result) then begin
      //kt  Added Try-Except block due to I kept getting error with TmpNode being an invalid object.
      //kt  Will trap until I can find the real problem.
      try
        for i := 0 to DropCarePlan.Nodes.Count-1 do begin
          TmpNode := TTreeNode(DropCarePlan.Nodes.Objects[i]);
          while (Result and (assigned(TmpNode.Parent))) do begin
            if(TmpNode.Data = DragCarePlan) then begin
              Result := FALSE
            end else begin
              TmpNode := TmpNode.Parent;
            end;
          end;
          if(not Result) then break;
        end;
      except
        Result := FALSE; //kt
      end;
    end;
  end else begin
    Result := FALSE;
  end;
end;

function TfrmCarePlanEditor.Clone(Node: TTreeNode): boolean;
var
  idx: integer;
  Prnt, OldT, NewT: TTemplate;
  PNode: TTreeNode;
  ok: boolean;

begin
  Result := FALSE;
  if((assigned(Node)) and (TTreeView(Node.TreeView) = tvPersonal)) then
  begin
    OldT := TTemplate(Node.Data);
    if(OldT.PersonalOwner <> User.DUZ) then
    begin
      PNode := Node.Parent;
      Prnt := nil;
      if (assigned(PNode)) then
      begin
        ok := CanClone(PNode);
        if ok then
        begin
          Clone(PNode);
          Prnt := TTemplate(PNode.Data);
          ok := Prnt.CanModify;
        end;
      end
      else
        ok := TRUE;
      if ok then
      begin
        BtnApply.Enabled := TRUE;
        Result := TRUE;
        NewT := OldT.Clone(User.DUZ);
        OldT.RemoveNode(Node);
        MarkDeleted(OldT);
        Node.Data := NewT;
        NewT.AddNode(Node);
        if(assigned(Prnt)) then
        begin
          idx := Prnt.Items.IndexOf(OldT);
          if(idx >= 0) then
            Prnt.Items[idx] := NewT;
        end;
        tvPersonal.Invalidate;
        ShowCarePlanType(NewT);
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.reBoilChange(Sender: TObject);
var
  DoInfo, DoRefresh: boolean;
  TmpBPlate: string;
  CarePlan: TTemplate;
  x: integer;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then begin
    CarePlan := TTemplate(FCurTree.Selected.Data);
    TmpBPlate := reBoil.Lines.Text;
    if(CarePlan.Boilerplate <> TmpBPlate) then begin
      if CanClone(FCurTree.Selected) then begin
        DoRefresh := Clone(FCurTree.Selected);
        if(DoRefresh) then
          CarePlan := TTemplate(FCurTree.Selected.Data);
        if assigned(CarePlan) and CarePlan.CanModify then begin
          DoInfo := FALSE;
          if(CarePlan.Boilerplate = '') or (TmpBPlate = '') then
            DoInfo := TRUE;
          CarePlan.Boilerplate := TmpBPlate;
          TTemplate(FCurTree.Selected.Data).Gap := StrToIntDef(edtGap.Text, 0);
          if(CarePlan.RealType = ttGroup) then begin
            reGroupBP.Text := CarePlan.FullBoilerplate;
          end;
          if(DoRefresh) then begin
            tvShared.Invalidate;
            tvPersonal.Invalidate;
          end;
          if(DoInfo) then begin
            x := reBoil.SelStart;
            ShowInfo(FCurTree.Selected);
            reBoil.SelStart := x;
          end;
        end;
      end;
      btnApply.Enabled := TRUE;
//        reBoil.Lines.Text := CarePlan.Boilerplate;
    end;
  end;
end;

procedure TfrmCarePlanEditor.SharedEditing;
begin
{$IFDEF OwnerScan}
  lblPerOwner.Visible := FCanEditShared;
  cboOwner.Visible := FCanEditShared;
{$ELSE}
  lblPerOwner.Visible := FALSE;
  cboOwner.Visible := FALSE;
{$ENDIF}
  sbCopyLeft.Visible := FCanEditShared;
  if(not FCanEditShared) then
    cbShHide.Checked := TRUE;
  cbShHide.Visible := FCanEditShared;
  sbShDelete.Visible := FCanEditShared;
  sbShUp.Visible := FCanEditShared;
  sbShDown.Visible := FCanEditShared;
  tvShared.ReadOnly := not FCanEditShared;
  MoveCopyButtons;
  tvTreeChange(FCurTree, FCurTree.Selected);
  if FCanEditShared then
    AdjustControls4FontChange;
end;

procedure TfrmCarePlanEditor.cbEditSharedClick(Sender: TObject);
begin
  FCanEditShared := cbEditShared.Checked;
  SharedEditing;
end;

procedure TfrmCarePlanEditor.popCarePlansPopup(Sender: TObject);
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
    mnuNodeDelete.Enabled := ((sbShDelete.Visible) and (sbShDelete.Enabled));
  end
  else
  begin
    Txt := 'Personal';
    FindOn := FFindPerOn;
    mnuNodeDelete.Enabled := ((sbPerDelete.Visible) and (sbPerDelete.Enabled));
  end;
  mnuFindCarePlans.Checked := FindOn;
  mnuCollapseTree.Caption := 'Collapse '+Txt+' &Tree';
  mnuFindCarePlans.Caption := '&Find '+Txt+' '+TEMPLATE_MODE_NAME[FVEFAMode];

  if(assigned(Tree) and assigned(Tree.Selected) and assigned(Tree.Selected.Data)) then
  begin
    mnuNodeCopy.Enabled := (TTemplate(Tree.Selected.Data).RealType in [ttDoc, ttGroup, ttClass]);
    mnuNodeSort.Enabled := (TTemplate(Tree.Selected.Data).RealType in AllTemplateFolderTypes) and
                           (Tree.Selected.HasChildren) and
                           (Tree.Selected.GetFirstChild.GetNextSibling <> nil);
  end
  else
  begin
    mnuNodeCopy.Enabled := FALSE;
    mnuNodeSort.Enabled := FALSE;
  end;
  FPasteNode := Tree.Selected;
  mnuNodePaste.Enabled := PasteOK;
  mnuNodeNew.Enabled := btnNew.Enabled;
  mnuNodeAutoGen.Enabled := btnNew.Enabled;
end;

procedure TfrmCarePlanEditor.mnuCollapseTreeClick(Sender: TObject);
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

procedure TfrmCarePlanEditor.mnuFindCarePlansClick(Sender: TObject);
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

procedure TfrmCarePlanEditor.ShowCarePlanType(CarePlan: TTemplate);
begin
  if(CarePlan.PersonalOwner > 0) then
    gbProperties.Caption := 'Personal'
  else
    gbProperties.Caption := 'Shared';
  gbProperties.Caption := gbProperties.Caption + PropText;
end;

function TfrmCarePlanEditor.GetTree: TTreeView;
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

procedure TfrmCarePlanEditor.btnFindClick(Sender: TObject);
var
  Found: TTreeNode;
  edtSearch: TEdit;
  IsNext: boolean;
  FindNext: boolean;
  FindWholeWords: boolean;
  FindCase: boolean;
  Tree: TTreeView;
  LastFoundNode, TmpNode: TTreeNode;
//  S1,S2: string;

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

procedure TfrmCarePlanEditor.edtSearchChange(Sender: TObject);
begin
  if(TCarePlanTreeType(TEdit(Sender).Tag) = ttShared) then
  begin
    btnShFind.Enabled := (edtShSearch.Text <> '');
    SetFindNext(tvShared, FALSE);
  end
  else
  begin
    btnPerFind.Enabled := (edtPerSearch.Text <> '');
    SetFindNext(tvPersonal, FALSE);
  end;
end;

procedure TfrmCarePlanEditor.SetFindNext(const Tree: TTreeView; const Value: boolean);
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

procedure TfrmCarePlanEditor.edtShSearchEnter(Sender: TObject);
begin
  btnShFind.Default := TRUE;
end;

procedure TfrmCarePlanEditor.edtShSearchExit(Sender: TObject);
begin
  btnShFind.Default := FALSE;
end;

procedure TfrmCarePlanEditor.edtPerSearchEnter(Sender: TObject);
begin
  btnPerFind.Default := TRUE;
end;

procedure TfrmCarePlanEditor.edtPerSearchExit(Sender: TObject);
begin
  btnPerFind.Default := FALSE;
end;

procedure TfrmCarePlanEditor.btnOKClick(Sender: TObject);
begin
  if(ScanNames) then
  begin
    if(SaveAllTemplates) then
    begin
      FOK2Close := TRUE;
      ModalResult := mrOK;
    end
    else
      BtnApply.Enabled := BackupDiffers;
  end;
end;

procedure TfrmCarePlanEditor.FormShow(Sender: TObject);
begin
  if(FFirstShow) then
  begin
    FUpdating := FALSE;
    FFirstShow := FALSE;
    if(FFocusName) then
    begin
      edtName.SetFocus;
      edtName.SelectAll;
    end;
    pnlBoilerplateResize(Self);
    AdjustControls4FontChange;
    MoveCopyButtons;

    if boolNewTemplate then edtNameOldChange(nil); //kt added
    boolNewTemplate := false;  //kt
  end;
end;

procedure TfrmCarePlanEditor.mnuBPInsertObjectClick(Sender: TObject);
var
  i: integer;
  DoIt: boolean;

begin
  if(not assigned(frmTemplateObjects)) then
  begin
    dmodShared.LoadTIUObjects;
    frmTemplateObjects := TfrmTemplateObjects.Create(Self);
    DoIt := TRUE;
    if (UserTemplateAccessLevel <> taEditor) then
    begin
      UpdatePersonalObjects;
      if uPersonalObjects.Count > 0 then                                                  // -------- CQ #8665 - RV ------------
      begin
        DoIt := FALSE;
        for i := 0 to dmodShared.TIUObjects.Count-1 do
          if uPersonalObjects.IndexOf(Piece(dmodShared.TIUObjects[i],U,2)) >= 0 then      // -------- CQ #8665 - RV ------------
            frmTemplateObjects.cboObjects.Items.Add(dmodShared.TIUObjects[i]);
      end;
    end;
    if DoIt then
      FastAssign(dmodShared.TIUObjects, frmTemplateObjects.cboObjects.Items);
    frmTemplateObjects.Font := Font;
    frmTemplateObjects.re := reBoil;
    frmTemplateObjects.AutoLongLines := AutoLongLines;
  end;
  frmTemplateObjects.Show;
  frmTemplateObjects.InsertingIntoCarePlan := true;  //kt
end;

procedure TfrmCarePlanEditor.mnuBPErrorCheckClick(Sender: TObject);
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

procedure TfrmCarePlanEditor.popBoilerplatePopup(Sender: TObject);
var
  tryOK, ok: boolean;

begin
  ok := not reBoil.ReadOnly;
  mnuBPInsertObject.Enabled := ok;
  mnuBPInsertField.Enabled := ok;

  mnuBPPaste.Enabled := (ok and Clipboard.HasFormat(CF_TEXT));
  if(ok) then
    ok := (reBoil.Lines.Count > 0);
  tryOK := (reBoil.Lines.Count > 0) or ((pnlGroupBP.Visible) and (reGroupBP.Lines.Count > 0));
  mnuBPErrorCheck.Enabled := tryOK;
  mnuBPTry.Enabled := tryOK;
  mnuBPSpellCheck.Enabled := ok and SpellCheckAvailable;
  mnuBPCheckGrammar.Enabled := ok and SpellCheckAvailable;

  mnuBPCopy.Enabled := (reBoil.SelLength > 0);
  mnuBPCut.Enabled := (ok and (reBoil.SelLength > 0));
  mnuBPSelectAll.Enabled := (reBoil.Lines.Count > 0);
  mnuBPUndo.Enabled := (reBoil.Perform(EM_CANUNDO, 0, 0) <> 0);
end;

function TfrmCarePlanEditor.ScanNames: boolean;
var
  Errors: TList;
  msg: string;
  i: integer;
  Node: TTreeNode;

  procedure ScanTree(Tree: TTreeView);
  begin
    Node := Tree.Items.GetFirstNode;
    while (assigned(Node)) do begin
      if(Node.Text <> EmptyNodeText) and (assigned(Node.Data)) then begin
        if(BadTemplateName(Node.Text,FVEFAMode)) then begin
          Errors.Add(Node);
        end
      end;
      Node := Node.GetNext;
    end;
  end;

begin
  Errors := TList.Create;
  try
    ScanTree(tvShared);
    ScanTree(tvPersonal);
    if(Errors.Count > 0) then begin
      if(Errors.Count > 1) then begin
        msg := IntToStr(Errors.Count) + ' ' + TEMPLATE_MODE_NAME[FVEFAMode] + ' have invalid names'
      end else begin
        msg := TEMPLATE_MODE_NAME[FVEFAMode] + ' has an invalid goal name';
      end;
      msg := msg + ': ';
      for i := 0 to Errors.Count-1 do begin
        if(i > 0) then msg := msg + ', ';
        Node := TTreeNode(Errors[i]);
        msg := msg + Node.Text;
        Node.MakeVisible;
      end;
      msg := msg + '.' + BadNameText;
      InfoBox(msg, 'Error', MB_OK or MB_ICONERROR);
      TTreeView(Node.TreeView).Selected := TTreeNode(Errors[0]);
    end;
  finally
    Result := (Errors.Count = 0);
    Errors.Free;
  end;
end;

procedure TfrmCarePlanEditor.btnCancelClick(Sender: TObject);
begin
  FOK2Close := TRUE;
end;

procedure TfrmCarePlanEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveUserBounds(Self);
end;

procedure TfrmCarePlanEditor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  ans: word;

begin
  if(not FOK2Close) and (BackupDiffers) then begin
    ans := InfoBox('Save Changes?', 'Confirmation', MB_YESNOCANCEL or MB_ICONQUESTION);
    if(ans = IDCANCEL) then
      CanClose := FALSE
    else
    if(ans = IDYES) then begin
      CanClose := FALSE;
      if(ScanNames) then begin
        if(SaveAllTemplates) then begin
          CanClose := TRUE
        end else begin
          BtnApply.Enabled := BackupDiffers;
        end;
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.mnuBPSpellCheckClick(Sender: TObject);
begin
  SpellCheckForControl(reBoil);
end;

procedure TfrmCarePlanEditor.splBoilMoved(Sender: TObject);
begin
  if pnlBoilerplate.Visible and pnlGroupBP.Visible then
    tmplEditorSplitterBoil := reBoil.Height;
  if pnlNotes.Visible then
    tmplEditorSplitterNotes := pnlNotes.Height;
  pnlBoilerplateResize(Self);
end;

procedure TfrmCarePlanEditor.edtGapKeyPress(Sender: TObject;
  var Key: Char);
begin
  if(not (Key in ['0','1','2','3'])) then Key := #0;
end;

procedure TfrmCarePlanEditor.edtNameExit(Sender: TObject);
var
  Warn: boolean;

begin
  edtName.Text := CheckNamespaceName(edtName.Text, FVEFAMode);
  Warn := (ActiveControl <> btnCancel) and (BadTemplateName(edtName.Text,FVEFAMode));
  if(Warn and ((ActiveControl = sbShDelete) or (ActiveControl = sbPerDelete))) then begin
    if((assigned(FCurTree)) and (assigned(FCurTree.Selected))) then begin
      Warn := not AutoDel(TTemplate(FCurTree.Selected.Data));
    end;
  end;
  if(Warn) then begin
    InfoBox(TEMPLATE_MODE_NAME[FVEFAMode] + ' has an invalid name: ' + edtName.Text + '.' + BadNameText(FVEFAMode),
            'Error', MB_OK or MB_ICONERROR);
    edtName.SetFocus;
  end;
end;

procedure TfrmCarePlanEditor.tmrAutoScrollTimer(Sender: TObject);
const
  EdgeScroll = 16;

var
  TopNode: TTreeNode;
  Redraw: boolean;
  TmpPt: TPoint;
  ht: THitTests;
  HPos, RMax: integer;

begin
  if(assigned(FDropNode)) then
  begin
    TopNode := FDropNode.TreeView.TopItem;
    Redraw := FALSE;
    TmpPt := FDropNode.TreeView.ScreenToClient(Mouse.CursorPos);
    if(TopNode = FDropNode) and (TopNode <> TTreeView(FDropNode.TreeView).Items.GetFirstNode) then
    begin
      FDropNode.TreeView.TopItem := TopNode.GetPrevVisible;
      Redraw := TRUE;
    end
    else
    begin
      RMax := FDropNode.TreeView.ClientHeight - EdgeScroll;
      if((TmpPt.Y > RMax) and (FDropNode.GetNextVisible <> nil)) then
      begin
        TORTreeView(FDropNode.TreeView).VertScrollPos :=
        TORTreeView(FDropNode.TreeView).VertScrollPos + 1;
        Redraw := TRUE;
      end;
    end;
    if(FLastDropNode <> FDropNode) then
    begin
      if((assigned(FDropNode)) and (FDropNode.GetNext = nil)) then
        Redraw := TRUE
      else
      if((assigned(FLastDropNode)) and (FLastDropNode.GetNext = nil)) then
        Redraw := TRUE;
      FLastDropNode := FDropNode;
      FDragOverCount := 0;
    end
    else
    begin
      if(FDropNode.HasChildren) and (not FDropNode.Expanded) then
      begin
        ht := FDropNode.TreeView.GetHitTestInfoAt(TmpPt.X, TmpPt.Y);
        if(htOnButton in ht) then
        begin
          inc(FDragOverCount);
          if(FDragOverCount > 4) then
          begin
            TopNode := FDropNode.TreeView.TopItem;
            FDropNode.Expand(FALSE);
            FDropNode.TreeView.TopItem := TopNode;
            FDragOverCount := 0;
            Redraw := TRUE;
          end;
        end
        else
          FDragOverCount := 0;
      end;
      if(not Redraw) then
      begin
        HPos := TORTreeView(FDropNode.TreeView).HorzScrollPos;
        if(HPos > 0) and (TmpPt.X < EdgeScroll) then
        begin
          TORTreeView(FDropNode.TreeView).HorzScrollPos :=
          TORTreeView(FDropNode.TreeView).HorzScrollPos - EdgeScroll;
          Redraw := TRUE;
        end
        else
        begin
          RMax := FDropNode.TreeView.ClientWidth - EdgeScroll;
          if(TmpPt.X > RMax) then
          begin
            TORTreeView(FDropNode.TreeView).HorzScrollPos :=
            TORTreeView(FDropNode.TreeView).HorzScrollPos + EdgeScroll;
            Redraw := TRUE;
          end;
        end;
      end;
    end;
    if(Redraw) then
    begin
      TmpPt := Mouse.CursorPos; // Wiggling the mouse causes needed windows messages to fire
      inc(TmpPt.X);
      Mouse.CursorPos := TmpPt;
      dec(TmpPt.X);
      Mouse.CursorPos := TmpPt;
      FDropNode.TreeView.Invalidate;
    end;
  end;
end;

procedure TfrmCarePlanEditor.tvTreeStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FDropNode := nil;
  FLastDropNode := nil;
  FDragOverCount := 0;
  tmrAutoScroll.Enabled := TRUE;
end;

procedure TfrmCarePlanEditor.tvTreeEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  tmrAutoScroll.Enabled := FALSE;
end;

procedure TfrmCarePlanEditor.mnuGroupBPCopyClick(Sender: TObject);
begin
  reGroupBP.CopyToClipboard;
end;

procedure TfrmCarePlanEditor.popGroupPopup(Sender: TObject);
begin
  mnuGroupBPCopy.Enabled := (pnlGroupBP.Visible and (reGroupBP.SelLength > 0));
  mnuGroupBPSelectAll.Enabled := (pnlGroupBP.Visible and (reGroupBP.Lines.Count > 0));
end;

procedure TfrmCarePlanEditor.mnuBPCutClick(Sender: TObject);
begin
  reBoil.CutToClipboard;
end;

procedure TfrmCarePlanEditor.mnuBPCopyClick(Sender: TObject);
begin
  reBoil.CopyToClipboard;
end;

procedure TfrmCarePlanEditor.mnuBPPasteClick(Sender: TObject);
begin
  reBoil.SelText := Clipboard.AsText;
end;

procedure TfrmCarePlanEditor.mnuGroupBPSelectAllClick(Sender: TObject);
begin
  reGroupBP.SelectAll;
end;

procedure TfrmCarePlanEditor.mnuBPSelectAllClick(Sender: TObject);
begin
  reBoil.SelectAll;
end;

procedure TfrmCarePlanEditor.mnuNodeDeleteClick(Sender: TObject);
begin
  if(FCurTree = tvShared) and (sbShDelete.Visible) and (sbShDelete.Enabled) then
    sbDeleteClick(sbShDelete)
  else
  if(FCurTree = tvPersonal) and (sbPerDelete.Visible) and (sbPerDelete.Enabled) then
    sbDeleteClick(sbPerDelete);
end;

procedure TfrmCarePlanEditor.mnuNodeCopyClick(Sender: TObject);
begin
  if(assigned(FCurTree)) then
    FCopyNode := FCurTree.Selected
  else
    FCopyNode := nil;
end;

procedure TfrmCarePlanEditor.mnuNodePasteClick(Sender: TObject);
begin
  if(PasteOK) then
  begin
    FDragNode := FCopyNode;
    FDropNode := FPasteNode;
    FDropInto := (TTemplate(FDropNode.Data).RealType in AllTemplateFolderTypes);
    FCopying := TRUE;
    try
      tvTreeDragDrop(tvShared, tvPersonal, 0, 0);
    finally
      FCopying := FALSE;
    end;
  end;
  FCopyNode := nil;
end;

function TfrmCarePlanEditor.PasteOK: boolean;
var
  OldCopying: boolean;
  Node: TTreeNode;

begin
  Result := assigned(FCopyNode) and assigned(FPasteNode);
  if(Result) then
    Result := (FTreeControl[TCarePlanTreeType(FPasteNode.TreeView.Tag), tcDel].Visible);
  if(Result) then
  begin
    OldCopying := FCopying;
    FCopying := TRUE;
    try
      Node := FPasteNode;
      if(TTemplate(Node.Data).RealType = ttDoc) then
        Node := Node.Parent;
      Result := AllowMove(Node, FCopyNode);
    finally
      FCopying := OldCopying;
    end;
  end;
end;

procedure TfrmCarePlanEditor.mnuBPUndoClick(Sender: TObject);
begin
  reBoil.Perform(EM_UNDO, 0, 0);
end;

procedure TfrmCarePlanEditor.tvTreeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin

  if(Key = VK_DELETE) then
  begin
    if(Sender = tvShared) then
    begin
      if(sbShDelete.Visible and sbShDelete.Enabled) then
        sbDeleteClick(sbShDelete);
    end
    else
    begin
      if(sbPerDelete.Visible and sbPerDelete.Enabled) then
        sbDeleteClick(sbPerDelete);
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
      mnuBPErrorCheckClick(Self)
  else
  if (ssCtrl in Shift) and (Key = VK_F) then
      mnuBPInsertFieldClick(Self)
  else
  if (ssCtrl in Shift) and (Key = VK_G) then
      GrammarCheckForControl(reBoil)
  else
  if (ssCtrl in Shift) and (Key = VK_I) then
      mnuBPInsertObjectClick(Self)
  else
  if (ssCtrl in Shift) and (Key = VK_S) then
      SpellCheckForControl(reBoil)
  else
  if (ssCtrl in Shift) and (Key = VK_T) then
      mnuBPTryClick(Self)
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

procedure TfrmCarePlanEditor.mnuEditClick(Sender: TObject);
var
  tryOK, ok: boolean;

begin
  if pnlBoilerplate.Visible then
  begin
    ok := (not reBoil.ReadOnly);
    mnuInsertObject.Enabled := ok;
    mnuInsertField.Enabled := ok;
    mnuPaste.Enabled := (ok and Clipboard.HasFormat(CF_TEXT));
    if(ok) then
      ok := (reBoil.Lines.Count > 0);
    tryOK := (reBoil.Lines.Count > 0) or ((pnlGroupBP.Visible) and (reGroupBP.Lines.Count > 0));
    mnuErrorCheck.Enabled := tryOK;
    mnuTry.Enabled := tryOK;
    mnuSpellCheck.Enabled := ok and SpellCheckAvailable;
    mnuCheckGrammar.Enabled := ok and SpellCheckAvailable;

    mnuCopy.Enabled := (reBoil.SelLength > 0);
    mnuCut.Enabled := (ok and (reBoil.SelLength > 0));
    mnuSelectAll.Enabled := (reBoil.Lines.Count > 0);
    mnuUndo.Enabled := (reBoil.Perform(EM_CANUNDO, 0, 0) <> 0);
    mnuGroupBoilerplate.Enabled := pnlGroupBP.Visible;
  end
  else
  begin
    mnuInsertObject.Enabled     := FALSE; 
    mnuInsertField.Enabled      := FALSE;
    mnuPaste.Enabled            := FALSE;
    mnuErrorCheck.Enabled       := FALSE;
    mnuTry.Enabled              := FALSE;
    mnuSpellCheck.Enabled       := FALSE;
    mnuCheckGrammar.Enabled     := FALSE;
    mnuCopy.Enabled             := FALSE;
    mnuCut.Enabled              := FALSE;
    mnuSelectAll.Enabled        := FALSE;
    mnuUndo.Enabled             := FALSE;
    mnuGroupBoilerplate.Enabled := FALSE;
  end;
end;

procedure TfrmCarePlanEditor.mnuGroupBoilerplateClick(Sender: TObject);
begin
  mnuGroupCopy.Enabled := (pnlGroupBP.Visible and (reGroupBP.SelLength > 0));
  mnuGroupSelectAll.Enabled := (pnlGroupBP.Visible and (reGroupBP.Lines.Count > 0));
end;

procedure TfrmCarePlanEditor.cbShFindOptionClick(Sender: TObject);
begin
  SetFindNext(tvShared, FALSE);
  if(pnlShSearch.Visible) then edtShSearch.SetFocus;
end;

procedure TfrmCarePlanEditor.cbPerFindOptionClick(Sender: TObject);
begin
  SetFindNext(tvPersonal, FALSE);
  if(pnlPerSearch.Visible) then edtPerSearch.SetFocus;
end;

procedure TfrmCarePlanEditor.mnuCarePlanClick(Sender: TObject);
var
  Tree: TTreeView;

begin
  FFromMainMenu := TRUE;
  Tree := FCurTree;
  if(assigned(Tree) and assigned(Tree.Selected)) then
  begin
    if(Tree = tvShared) then
      mnuTDelete.Enabled := ((sbShDelete.Visible) and (sbShDelete.Enabled))
    else
      mnuTDelete.Enabled := ((sbPerDelete.Visible) and (sbPerDelete.Enabled));
    if(assigned(Tree) and assigned(Tree.Selected) and assigned(Tree.Selected.Data)) then
    begin
      mnuTCopy.Enabled := (TTemplate(Tree.Selected.Data).RealType in [ttDoc, ttGroup, ttClass]);
      mnuSort.Enabled := (TTemplate(Tree.Selected.Data).RealType in AllTemplateFolderTypes) and
                         (Tree.Selected.HasChildren) and
                         (Tree.Selected.GetFirstChild.GetNextSibling <> nil);
    end
    else
    begin
      mnuTCopy.Enabled := FALSE;
      mnuSort.Enabled := FALSE;
    end;
    FPasteNode := Tree.Selected;
    mnuTPaste.Enabled := PasteOK;
  end
  else
  begin
    mnuTCopy.Enabled := FALSE;
    mnuTPaste.Enabled := FALSE;
    mnuTDelete.Enabled := FALSE;
    mnuSort.Enabled := FALSE;
  end;
  mnuNewCarePlanTemplate.Enabled := btnNew.Enabled;
  mnuAutoGen.Enabled := btnNew.Enabled;
  mnuFindShared.Checked := FFindShOn;
  mnuFindPersonal.Checked := FFindPerOn;
  mnuShCollapse.Enabled := dmodShared.NeedsCollapsing(tvShared);
  mnuPerCollapse.Enabled := dmodShared.NeedsCollapsing(tvPersonal);
end;

procedure TfrmCarePlanEditor.mnuFindSharedClick(Sender: TObject);
begin
  FMainMenuTree := tvShared;
  mnuFindCarePlansClick(tvShared);
end;

procedure TfrmCarePlanEditor.mnuFindPersonalClick(Sender: TObject);
begin
  FMainMenuTree := tvPersonal;
  mnuFindCarePlansClick(tvPersonal);
end;

procedure TfrmCarePlanEditor.mnuShCollapseClick(Sender: TObject);
begin
  FMainMenuTree := tvShared;
  mnuCollapseTreeClick(tvShared);
end;

procedure TfrmCarePlanEditor.mnuPerCollapseClick(Sender: TObject);
begin
  FMainMenuTree := tvPersonal;
  mnuCollapseTreeClick(tvPersonal);
end;

procedure TfrmCarePlanEditor.pnlShSearchResize(Sender: TObject);
begin
  if((cbShMatchCase.Width + cbShWholeWords.Width) > pnlShSearch.Width) then
    cbShWholeWords.Left := cbShMatchCase.Width
  else
    cbShWholeWords.Left := pnlShSearch.Width - cbShWholeWords.Width;
end;

procedure TfrmCarePlanEditor.pnlPerSearchResize(Sender: TObject);
begin
  if((cbPerMatchCase.Width + cbPerWholeWords.Width) > pnlPerSearch.Width) then
    cbPerWholeWords.Left := cbPerMatchCase.Width
  else
    cbPerWholeWords.Left := pnlPerSearch.Width - cbPerWholeWords.Width;
end;

procedure TfrmCarePlanEditor.pnlPropertiesResize(Sender: TObject);
begin
  btnNew.Width := pnlProperties.Width;
end;

procedure TfrmCarePlanEditor.mbMainResize(Sender: TObject);
begin
  pnlMenu.Width := mbMain.Width + 4;
  mbMain.Width := pnlMenu.Width - 3;
end;

procedure TfrmCarePlanEditor.mnuBPCheckGrammarClick(Sender: TObject);
begin
  GrammarCheckForControl(reBoil);
end;

procedure TfrmCarePlanEditor.mnuSortClick(Sender: TObject);
var
  Tree: TTreeView;

begin
  Tree := FCurTree;
  if(assigned(Tree) and assigned(Tree.Selected) and Tree.Selected.HasChildren) then
  begin
    TTemplate(Tree.Selected.Data).SortChildren;
    Resync([TTemplate(Tree.Selected.Data)]);
    btnApply.Enabled := TRUE;
  end;
end;

procedure TfrmCarePlanEditor.pnlBoilerplateCanResize(Sender: TObject;
  var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  if(NewHeight < 40) then Resize := FALSE;
end;

function TfrmCarePlanEditor.AutoDel(CarePlan: TTemplate): boolean;
begin
  if(assigned(CarePlan)) then
    Result := (((CarePlan.ID = '0') or (CarePlan.ID = '')) and
                (CarePlan.PrintName = NewTemplateName(FVEFAMode)) and
                (CarePlan.Boilerplate = ''))
  else
    Result := FALSE;
end;

procedure TfrmCarePlanEditor.mnuBPTryClick(Sender: TObject);
var
  R: TRect;
  Move: boolean;
  tmpl: TTemplate;
  txt: String;

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
    txt := tmpl.Text;
    if(not tmpl.DialogAborted) then
      ShowTemplateData(Self, tmpl.PrintName ,txt);
    if(Move) then
      frmTemplateView.BoundsRect := R;
    tmpl.TemplatePreviewMode := FALSE;
  end;
end;

procedure TfrmCarePlanEditor.mnuAutoGenClick(Sender: TObject);
var
  AName, AText: string;

begin
  dmodShared.LoadTIUObjects;
  UpdatePersonalObjects;
  GetAutoGenText(AName, AText, uPersonalObjects);   // -------- CQ #8665 - RV ------------
  if(AName <> '') and (AText <> '') then
  begin
    btnNewClick(Self);
    TTemplate(FBtnNewNode.Data).PrintName := AName;
    TTemplate(FBtnNewNode.Data).Boilerplate := AText;
    ShowInfo(FBtnNewNode);
    edtNameOldChange(Self);
  end;
end;

procedure TfrmCarePlanEditor.reNotesChange(Sender: TObject);
var
  CarePlan: TTemplate;
  DoRefresh: boolean;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      DoRefresh := Clone(FCurTree.Selected);
      CarePlan := TTemplate(FCurTree.Selected.Data);
      if assigned(CarePlan) and CarePlan.CanModify then
      begin
        CarePlan.Description := reNotes.Lines.Text;
        UpdateApply(CarePlan);
        if(DoRefresh) then
        begin
          tvShared.Invalidate;
          tvPersonal.Invalidate;
        end;
      end;
    end;
    btnApply.Enabled := TRUE;
//      reNotes.Lines.Text := CarePlan.Description;
  end;
end;

procedure TfrmCarePlanEditor.mnuNotesUndoClick(Sender: TObject);
begin
  reNotes.Perform(EM_UNDO, 0, 0);
end;

procedure TfrmCarePlanEditor.mnuNotesCutClick(Sender: TObject);
begin
  reNotes.CutToClipboard;
end;

procedure TfrmCarePlanEditor.mnuNotesCopyClick(Sender: TObject);
begin
  reNotes.CopyToClipboard;
end;

procedure TfrmCarePlanEditor.mnuNotesPasteClick(Sender: TObject);
begin
  reNotes.SelText := Clipboard.AsText;
end;

procedure TfrmCarePlanEditor.mnuNotesSelectAllClick(Sender: TObject);
begin
  reNotes.SelectAll;
end;

procedure TfrmCarePlanEditor.mnuNotesGrammarClick(Sender: TObject);
begin
  GrammarCheckForControl(reNotes);
end;

procedure TfrmCarePlanEditor.mnuNotesSpellingClick(Sender: TObject);
begin
  SpellCheckForControl(reNotes);
end;

procedure TfrmCarePlanEditor.popNotesPopup(Sender: TObject);
var
  ok: boolean;

begin
  ok := not reNotes.ReadOnly;
  mnuNotesPaste.Enabled := (ok and Clipboard.HasFormat(CF_TEXT));
  if(ok) then
    ok := (reNotes.Lines.Count > 0);
  mnuNotesSpelling.Enabled := ok and SpellCheckAvailable;
  mnuNotesGrammar.Enabled := ok and SpellCheckAvailable;
  mnuNotesCopy.Enabled := (reNotes.SelLength > 0);
  mnuNotesCut.Enabled := (ok and (reNotes.SelLength > 0));
  mnuNotesSelectAll.Enabled := (reNotes.Lines.Count > 0);
  mnuNotesUndo.Enabled := (reNotes.Perform(EM_CANUNDO, 0, 0) <> 0);
end;

procedure TfrmCarePlanEditor.cbNotesClick(Sender: TObject);
begin
  pnlNotes.Visible := cbNotes.Checked;
  splNotes.Visible := cbNotes.Checked;
  if cbNotes.Checked then
  begin
    pnlNotes.Height := tmplEditorSplitterNotes;
    pnlNotes.Top := pnlBottom.Top - pnlNotes.Height;
    splNotes.Top := pnlNotes.Top-3;
  end;
  pnlBoilerplateResize(Self);
end;

procedure TfrmCarePlanEditor.cbDisplayOnlyClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPDisplayOnlyFld);
end;

procedure TfrmCarePlanEditor.cbFirstLineClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPFirstLineFld);
end;

procedure TfrmCarePlanEditor.cbOneItemOnlyClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPOneItemOnlyFld);
end;

procedure TfrmCarePlanEditor.cbHideDlgItemsClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPHideDlgItemsFld);
end;

procedure TfrmCarePlanEditor.cbHideItemsClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPHideItemsFld);
end;

procedure TfrmCarePlanEditor.cbClick(Sender: TCheckBox; Index: integer);
var
  CarePlan: TTemplate;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      Clone(FCurTree.Selected);
      CarePlan := TTemplate(FCurTree.Selected.Data);
      if assigned(CarePlan) and CarePlan.CanModify then
      begin
        case Index of
          BPDisplayOnlyFld:   CarePlan.DisplayOnly   := Sender.Checked;
          BPFirstLineFld:     CarePlan.FirstLine     := Sender.Checked;
          BPOneItemOnlyFld:   CarePlan.OneItemOnly   := Sender.Checked;
          BPHideDlgItemsFld:  CarePlan.HideDlgItems  := Sender.Checked;
          BPHideItemsFld:     CarePlan.HideItems     := Sender.Checked;
          BPIndentFld:        CarePlan.IndentItems   := Sender.Checked;
          BPLockFld:          CarePlan.Lock          := Sender.Checked;
        end;
        UpdateApply(CarePlan);
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.cbIndentClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPIndentFld);
end;

procedure TfrmCarePlanEditor.mnuToolsClick(Sender: TObject);
begin
  mnuEditCarePlanTemplateFields.Enabled := CanEditTemplateFields;
  mnuImportCarePlanTemplate.Enabled := btnNew.Enabled;
  mnuExportCarePlanTemplate.Enabled := (assigned(FCurTree) and assigned(FCurTree.Selected) and
                                assigned(FCurTree.Selected.Data));
end;

procedure TfrmCarePlanEditor.mnuEditCarePlanTemplateFieldsClick(Sender: TObject);
begin
  if assigned(frmTemplateObjects) then
    frmTemplateObjects.Hide;
  if assigned(frmTemplateFields) then
    frmTemplateFields.Hide;
  if EditDialogFields and assigned(frmTemplateFields) then
    FreeAndNil(frmTemplateFields);
end;

procedure TfrmCarePlanEditor.mnuBPInsertFieldClick(Sender: TObject);
begin
  if(not assigned(frmTemplateFields)) then
  begin
    frmTemplateFields := TfrmTemplateFields.Create(Self);
    frmTemplateFields.Font := Font;
    frmTemplateFields.re := reBoil;
    frmTemplateFields.AutoLongLines := AutoLongLines;
  end;
  frmTemplateFields.Show;
end;

procedure TfrmCarePlanEditor.UpdateInsertsDialogs;
begin
  if assigned(frmTemplateObjects) then
    frmTemplateObjects.UpdateStatus;
  if assigned(frmTemplateFields) then
    frmTemplateFields.UpdateStatus;
end;

procedure TfrmCarePlanEditor.mnuExportCarePlanTemplateClick(Sender: TObject);
var
  Tmpl, Flds: TStringList;
  i: integer;
  XMLDoc: IXMLDOMDocument;
  err: boolean;

begin
  err := FALSE;
  if(assigned(FCurTree) and assigned(FCurTree.Selected) and assigned(FCurTree.Selected.Data)) then
  begin
    dlgExport.FileName := ValidFileName(TTemplate(FCurTree.Selected.Data).PrintName);
    if dlgExport.Execute then
    begin
      Tmpl := TStringList.Create;
      try
        Flds := TStringList.Create;
        try
          Tmpl.Add('<'+XMLHeader+'>');
          if TTemplate(FCurTree.Selected.Data).CanExportXML(Tmpl, Flds, 2) then
          begin
            if (Flds.Count > 0) then begin
              ExpandEmbeddedFields(Flds);
              FastAssign(ExportTemplateFields(Flds), Flds);
              for i := 0 to Flds.Count-1 do
                Flds[i] := '  ' + Flds[i];
              FastAddStrings(Flds, Tmpl);
            end; {if}
            Tmpl.Add('</'+XMLHeader+'>');
            try
              XMLDoc := CoDOMDocument.Create;
              try
                XMLDoc.preserveWhiteSpace := TRUE;
                XMLDoc.LoadXML(Tmpl.Text);
                XMLDoc.Save(dlgExport.FileName);
              finally
                XMLDoc := nil;
              end;
            except
              InfoBox(Format(NoIE5, ['Export']), NoIE5Header, MB_OK);
              err := TRUE;
            end;
            if not err then
              InfoBox(TEMPLATE_MODE_NAME[FVEFAMode] + ' ' + TTemplate(FCurTree.Selected.Data).PrintName +
                      ' Exported.', TEMPLATE_MODE_NAME[FVEFAMode] + ' Exported', MB_OK);
          end;
        finally
          Flds.Free;
        end;
      finally
        Tmpl.Free;
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.mnuImportCarePlanTemplateClick(Sender: TObject);
const
  Filter1 = 'Template Files|*.txml';
  WordFilter = '|Word Documents|*.doc;*.dot';
  Filter2 = '|XML Files|*.xml|All Files|*.*';

var
  XMLDoc: IXMLDOMDocument;
  RootElement: IXMLDOMElement;
  ImportedCarePlan: TTemplate;
  AppData, Flds, ResultSet: TStringList;
  tmp,j,p3: string;
  err, ok, changes, xmlerr: boolean;
  i: integer;
  choice: word;

  procedure ClearFields;
  begin
    Flds.Text := '';
    ResultSet.Text := '';
  end;

begin
  tmp := Filter1;
  err := FALSE;
  if WordImportActive then
    tmp := tmp + WordFilter;
  tmp := tmp + Filter2;
  dlgImport.Filter := tmp;
  if btnNew.Enabled and dlgImport.Execute then
  begin
    tmp := ExtractFileExt(dlgImport.FileName);
    if(WordImportActive and ((CompareText(tmp,'.doc') = 0) or
                             (CompareText(tmp,'.dot') = 0))) then
      AppData := TStringList.Create
    else
      AppData := nil;
    try
      try
        XMLDoc := CoDOMDocument.Create;
      except
        InfoBox(Format(NoIE5, ['Import']), NoIE5Header, MB_OK);
        exit;
      end;
      try
        if assigned(AppData) then
        begin
          try
            ok := GetXMLFromWord(dlgImport.FileName, AppData);
          except
            ok := FALSE;
            err := TRUE;
          end;
        end
        else
          ok := TRUE;
        if ok and assigned(XMLDoc) then
        begin
          XMLDoc.preserveWhiteSpace := TRUE;
          if assigned(AppData) then
            XMLDoc.LoadXML(AppData.Text)
          else
            XMLDoc.Load(dlgImport.FileName);
          RootElement := XMLDoc.DocumentElement;
          if not assigned(RootElement) then
            XMLImportError(0);
          try
            if(RootElement.tagName <> XMLHeader)then
              XMLImportError(0)
            else
            begin
              ImportedCarePlan := nil;
              FXMLTemplateElement := FindXMLElement(RootElement, XMLTemplateTag);
              if assigned(FXMLTemplateElement) then
              begin
                FXMLFieldElement := FindXMLElement(RootElement, XMLTemplateFieldsTag);
                if(assigned(FXMLFieldElement)) then
                begin
                  Flds := TStringList.Create;
                  ResultSet := TStringList.Create;
                  try
                    Flds.Text := FXMLFieldElement.Get_XML;
                    choice := IDOK;
                    changes := FALSE;
                    Application.ProcessMessages;
                    if not BuildTemplateFields(Flds) then  //Calls RPC to transfer all field XML
                      choice := IDCANCEL;                  //for processing
                    Flds.Text := '';
                    Application.ProcessMessages;
                    if choice = IDOK then
                      CheckTemplateFields(Flds);
                    if Flds.Count > 0 then
                      begin
                        for i := 1 to Flds.Count do
                          begin
                          j := piece(Flds[i-1],U,2);
                          if (j = '0') or (j = '2') then
                            begin
                              p3 := piece(Flds[i-1],U,3);
                              if p3 = 'XML FORMAT ERROR' then
                                choice := IDCANCEL;
                              changes := TRUE;
                              if j = '2' then begin
                                j := Flds[i-1];
                                SetPiece(j,U,2,'1');
                                Flds[i-1] := j
                              end;
                            end;
                          end;
                      end
                    else
                      choice := IDCANCEL;
                    if choice <> IDOK then
                      InfoBox(iMessage2+iMessage3, 'Error', MB_OK or MB_ICONERROR)
                    else
                      if (not CanEditTemplateFields) AND
                         changes {(there is at least one new field)} then
                        begin
                          choice := InfoBox(iMessage, 'Warning', MB_OKCANCEL or MB_ICONWARNING);
                          Flds.Text := '';
                        end;
                    if choice <> IDCANCEL then
                      begin
                      FImportingFromXML := TRUE;
                      try
                        btnNewClick(Self);
                        ImportedCarePlan := TTemplate(FBtnNewNode.Data);
                      finally
                        FImportingFromXML := FALSE;
                      end; {try}
                      Application.ProcessMessages;
                      if assigned(ImportedCarePlan) and (Flds.Count > 0) then
                        if not ImportLoadedFields(ResultSet) then begin
                          InfoBox(iMessage2+iMessage3, 'Error', MB_OK or MB_ICONERROR);
                          ClearFields;
                          choice := IDCANCEL;
                        end;//if
                      if Flds.Count = 0 then
                        choice := IDCANCEL;
                      end {if choice <> mrCancel}
                    else
                      ClearFields;

                    xmlerr := FALSE;
                    if (Flds.Count > 0) and
                       (ResultSet.Count > 0) and
                       (Flds.Count = ResultSet.Count) then
                      for i := 0 to Flds.Count-1 do begin
                        if piece(ResultSet[i],U,2) = '0' then begin
                          j := piece(Flds[i],U,1) + U + '0' + U + piece(ResultSet[i],U,3);
                          Flds[i] := j;
                        end
                      end
                    else
                      xmlerr := TRUE;

                    if xmlerr and (choice <> IDCANCEL) then begin
                      InfoBox(iMessage2, 'Warning', MB_OK or MB_ICONWARNING);
                      ClearFields;
                    end;

                    i := 0;
                    while (i < Flds.Count) do begin
                      if Piece(Flds[i], U, 2) <> '0' then
                        Flds.Delete(i)
                      else
                        inc(i);
                    end;//while
                    if(Flds.Count > 0) then
                    begin
                      if assigned(frmTemplateFields) then
                        FreeAndNil(frmTemplateFields);
                      ImportedCarePlan.UpdateImportedFieldNames(Flds);
                      if not assigned(AppData) then
                      begin
                        for i := 0 to Flds.Count-1 do
                          Flds[i] := '  Field "' + Piece(Flds[i],U,1) + '" has been renamed to "'+
                                                   Piece(Flds[i],U,3) + '"';
                        if Flds.Count = 1 then
                          tmp := 'A '+TEMPLATE_MODE_NAME[FVEFAMode]+' field has'
                        else
                          tmp := IntToStr(Flds.Count) + ' '+TEMPLATE_MODE_NAME[FVEFAMode]+' fields have';
                        Flds.Insert(0,tmp + ' been imported with the same name as');
                        Flds.Insert(1,'existing '+TEMPLATE_MODE_NAME[FVEFAMode]+', but with different field definitions.');
                        Flds.Insert(2,'These '+TEMPLATE_MODE_NAME[FVEFAMode]+' template fields have been renamed as follows:');
                        Flds.Insert(3,'');
                        InfoBox(Flds.Text, 'Information', MB_OK or MB_ICONINFORMATION);
                      end;
                    end;
                  finally
                    Flds.Free;
                    ResultSet.Free;
                  end;
                end
                else {There are no fields to consider...}
                begin
                  FImportingFromXML := TRUE;
                  try
                    btnNewClick(Self);
                    ImportedCarePlan := TTemplate(FBtnNewNode.Data);
                  finally
                    FImportingFromXML := FALSE;
                  end; {try}
                end;
              end;
              if assigned(ImportedCarePlan) then
                ShowInfo(FBtnNewNode);
            end;
          finally
            RootElement := nil;
          end;
        end;
      finally
        XMLDoc := nil;
      end;
    finally
      if assigned(AppData) then
      begin
        AppData.Free;
        if err then
          InfoBox('An error occured while Importing Word Document.  Make sure Word is closed and try again.','Import Error', MB_OK);
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.cbxTypeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ImgIdx: integer;

begin
  cbxType.Canvas.FillRect(Rect);
  case IdxForced[FForceContainer, Index] of
    tiCarePlan: ImgIdx := 4;
    tiFolder:   ImgIdx := 3;
    tiGroup:    ImgIdx := 5;
    tiDialog:   ImgIdx := 23;
    tiRemDlg:   ImgIdx := 27;
    tiCOMObj:   ImgIdx := 28;
    else
      ImgIdx := ord(tiNone);
  end;
  if ImgIdx >= 0 then
    dmodShared.imgTemplates.Draw(cbxType.Canvas, Rect.Left+1, Rect.Top+1, ImgIdx);
  if Index >= 0 then
    cbxType.Canvas.TextOut(Rect.Left+21, Rect.Top+2, cbxType.Items[Index]);
end;

procedure TfrmCarePlanEditor.cbxTypeChange(Sender: TObject);
var
  i,tg: integer;
  CarePlan: TTemplate;
  ttyp: TTemplateType;
  Node: TTreeNode;
  idx: TTypeIndex;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected))) then begin
    tg := cbxType.ItemIndex;
    if tg >= 0 then begin
      if CanClone(FCurTree.Selected) then begin
        idx := IdxForced[FForceContainer, tg];
        if(idx = tiRemDlg) and (not (GetLinkType(FCurTree.Selected) in [ltNone, ltTitle])) then begin
          FUpdating := TRUE;
          try
            cbxType.ItemIndex := ord(tiCarePlan);
          finally
            FUpdating := FALSE;
          end;
          ShowMsg('Can not assign a Reminder Dialog to a Reason for Request');
        end else begin
          Clone(FCurTree.Selected);
          CarePlan := TTemplate(FCurTree.Selected.Data);
          if assigned(CarePlan) and CarePlan.CanModify then begin
            ttyp := TypeTag[idx];
            if(not FForceContainer) or (not (idx in [tiCarePlan, tiRemDlg])) then begin
              if(ttyp = ttDialog) then begin
                CarePlan.Dialog := TRUE;
                ttyp := ttGroup;
              end else begin
                CarePlan.Dialog := FALSE;
              end;
              CarePlan.RealType := ttyp;
              if(CarePlan.RealType = ttDoc) and (idx = tiRemDlg) then begin
                CarePlan.IsReminderDialog := TRUE
              end else begin
                CarePlan.IsReminderDialog := FALSE;
              end;
              if(CarePlan.RealType = ttDoc) and (idx = tiCOMObj) then begin
                CarePlan.IsCOMObject := TRUE
              end else begin
                CarePlan.IsCOMObject := FALSE;
              end;
              UpdateApply(CarePlan);
            end;
            for i := 0 to CarePlan.Nodes.Count-1 do begin
              Node := TTreeNode(CarePlan.Nodes.Objects[i]);
              Node.ImageIndex := dmodShared.ImgIdx(Node);
              Node.SelectedIndex := dmodShared.ImgIdx(Node);
            end;
            tvShared.Invalidate;
            tvPersonal.Invalidate;
            Node := FCurTree.Selected;
            tvTreeChange(TTreeView(Node.TreeView), Node);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.cbxRemDlgsChange(Sender: TObject);
var
  CarePlan: TTemplate;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
     FCanDoReminders) then
  begin
    if CanClone(FCurTree.Selected) then
    begin
      Clone(FCurTree.Selected);
      CarePlan := TTemplate(FCurTree.Selected.Data);
      if assigned(CarePlan) and CarePlan.CanModify then
      begin
        if cbxRemDlgs.ItemIndex < 0 then
          CarePlan.ReminderDialog := ''
        else
          CarePlan.ReminderDialog := cbxRemDlgs.Items[cbxRemDlgs.ItemIndex];
        UpdateApply(CarePlan);
      end;
    end;
  end;
end;

procedure TfrmCarePlanEditor.mnuCarePlanIconLegendClick(Sender: TObject);
begin
  ShowIconLegend(ilTemplates, TRUE);
end;

procedure TfrmCarePlanEditor.cbLongLinesClick(Sender: TObject);
begin
  pnlBoilerplateResize(Self);
  pnlBoilerplateResize(Self); // Second Call is Needed!
end;

procedure TfrmCarePlanEditor.AutoLongLines(Sender: TObject);
begin
  cbLongLines.Checked := TRUE;
end;

(*procedure TfrmCarePlanEditor.UpdatePersonalObjects;
var
  i: integer;

begin
  if not assigned(FPersonalObjects) then
  begin
    FPersonalObjects := TStringList.Create;
    GetAllowedPersonalObjects;
    for i := 0 to RPCBrokerV.Results.Count-1 do
      FPersonalObjects.Add(Piece(RPCBrokerV.Results[i],U,1));
    FPersonalObjects.Sorted := TRUE;
  end;
end;*)

(*function TfrmCarePlanEditor.ModifyAllowed(const Node: TTreeNode): boolean;
var
  tmpl: TCarePlan;

  function GetFirstPersonalNode(Node: TTreeNode): TTreeNode;
  begin
    Result := Node;
    if assigned(Node.Parent) and (TCarePlan(Node.Data).PersonalOwner <> User.DUZ) then
      Result := GetFirstPersonalNode(Node.Parent);
  end;

begin
  if(assigned(Node)) then
  begin
    if (TTreeView(Node.TreeView) = tvPersonal) then
      Result := TCarePlan(GetFirstPersonalNode(Node).Data).CanModify
    else
      Result := TRUE;
  end
  else
    Result := FALSE;
  if Result then
  begin
    tmpl := TCarePlan(Node.Data);
    if (tmpl.PersonalOwner = 0) or (tmpl.PersonalOwner = User.DUZ) then
      Result := tmpl.CanModify;
  end;
end;
*)

{ Returns TRUE if Cloning is not needed or if Cloning is needed and
  the top personal Node in the tree is locked. }
function TfrmCarePlanEditor.CanClone(const Node: TTreeNode): boolean;
var
  CarePlan: TTemplate;

  function GetFirstPersonalNode(Node: TTreeNode): TTreeNode;
  begin
    Result := Node;
    if assigned(Node.Parent) and (TTemplate(Node.Data).PersonalOwner <> User.DUZ) then
      Result := GetFirstPersonalNode(Node.Parent);
  end;

begin
  if(assigned(Node)) and assigned(Node.Data) then
  begin
    if (TTreeView(Node.TreeView) = tvPersonal) then
    begin
      CarePlan := TTemplate(Node.Data);
      if CarePlan.IsCOMObject or (CarePlan.FileLink <> '') then
        Result := FALSE
      else
        Result := TTemplate(GetFirstPersonalNode(Node).Data).CanModify
    end
    else
      Result := TRUE;
  end
  else
    Result := FALSE;
end;

procedure TfrmCarePlanEditor.UpdateApply(CarePlan: TTemplate);
begin
  if(not btnApply.Enabled) then
    btnApply.Enabled := CarePlan.Changed;
end;

procedure TfrmCarePlanEditor.CarePlanLocked(Sender: TObject);
begin
  Resync([TTemplate(Sender)]);
  ShowMsg(Format(TemplateLockedText, [TTemplate(Sender).PrintName]));
end;

procedure TfrmCarePlanEditor.cbLockClick(Sender: TObject);
begin
  cbClick(TCheckBox(Sender), BPLockFLD);
end;

procedure TfrmCarePlanEditor.mnuRefreshClick(Sender: TObject);
begin
  if btnApply.Enabled then
  begin
    if InfoBox('All changes must be saved before you can Refresh.  Save Changes?',
        'Confirmation', MB_YESNO or MB_ICONQUESTION) <> IDYES then
      exit;
  end;
  btnApplyClick(Sender);
  if BtnApply.Enabled then
    InfoBox('Save not completed - unable to refresh.', 'Error', MB_OK or MB_ICONERROR)
  else
    RefreshData;
end;

procedure TfrmCarePlanEditor.RefreshData;
var
  exp1, exp2, s1, s2, t1, t2: string;
  focus: TWinControl;

begin
  focus := FCurTree;
  exp1 := tvShared.GetExpandedIDStr(1, ';');
  exp2 := tvPersonal.GetExpandedIDStr(1, ';');
  s1 := tvShared.GetNodeID(TORTreeNode(tvShared.Selected),1,';');
  s2 := tvPersonal.GetNodeID(TORTreeNode(tvPersonal.Selected),1,';');
  t1 := tvShared.GetNodeID(TORTreeNode(tvShared.TopItem),1,';');
  t2 := tvPersonal.GetNodeID(TORTreeNode(tvPersonal.TopItem),1,';');
  tvPersonal.Items.BeginUpdate;
  try
    tvShared.Items.BeginUpdate;
    try
      ReleaseTemplates;
      tvPersonal.Items.Clear;
      tvShared.Items.Clear;
      InitTrees;
      tvShared.SetExpandedIDStr(1, ';', exp1);
      tvShared.TopItem := tvShared.FindPieceNode(t1,1,';');
      tvShared.Selected := tvShared.FindPieceNode(s1,1,';');
      tvPersonal.SetExpandedIDStr(1, ';', exp2);
      tvPersonal.TopItem := tvPersonal.FindPieceNode(t2,1,';');
      tvPersonal.Selected := tvPersonal.FindPieceNode(s2,1,';');
    finally
      tvShared.Items.EndUpdate;
    end;
  finally
    tvPersonal.Items.EndUpdate;
  end;
  ActiveControl := focus;
end;

procedure TfrmCarePlanEditor.InitTrees;
begin
  LoadTemplateData('');
  if(not assigned(RootTemplate)) then
    SaveTemplate(AddTemplate('0^R^A^Shared Templates'),-1);
  if(not assigned(MyTemplate)) then
    AddTemplate('0^P^A^My Templates^^^'+IntToStr(User.DUZ));
  dmodShared.AddTemplateNode(tvPersonal, FPersonalEmptyNodeCount, MyTemplate, false, nil, false, FVEFAMode);
  dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, RootTemplate, false, nil, false, FVEFAMode);
  if (UserTemplateAccessLevel = taEditor) then
  begin
    if CanEditLinkType(ttTitles) then
      dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, TitlesTemplate, false, nil, false, FVEFAMode);
    if CanEditLinkType(ttConsults) then
      dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, ConsultsTemplate, false, nil, false, FVEFAMode);
    if CanEditLinkType(ttProcedures) then
      dmodShared.AddTemplateNode(tvShared, FSharedEmptyNodeCount, ProceduresTemplate, false, nil, false, FVEFAMode);
  end;
end;

procedure TfrmCarePlanEditor.reResizeRequest(Sender: TObject;
  Rect: TRect);
var
  R: TRect;

begin
  R := TRichEdit(Sender).ClientRect;
  if (FLastRect.Right <> R.Right) or
     (FLastRect.Bottom <> R.Bottom) or
     (FLastRect.Left <> R.Left) or
     (FLastRect.Top <> R.Top) then
  begin
    FLastRect := R;
    pnlBoilerplateResize(Self);
  end;
end;

procedure TfrmCarePlanEditor.reBoilSelectionChange(Sender: TObject);
begin
  UpdateXY(reBoil, lblBoilCol, lblBoilRow);
end;

procedure TfrmCarePlanEditor.reGroupBPSelectionChange(Sender: TObject);
begin
  UpdateXY(reGroupBP, lblGroupCol, lblGroupRow);
end;

procedure TfrmCarePlanEditor.UpdateXY(re: TRichEdit; lblX, lblY: TLabel);
var
  p: TPoint;

begin
  p := re.CaretPos;
  lblY.Caption := 'Line: ' + inttostr(p.y + 1);
  lblX.Caption := 'Column: ' + inttostr(p.x + 1);
end;

procedure TfrmCarePlanEditor.cbxCOMObjChange(Sender: TObject);
var
  CarePlan: TTemplate;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
     FCanDoCOMObjects and (FCurTree = tvShared)) then
  begin
    CarePlan := TTemplate(FCurTree.Selected.Data);
    if assigned(CarePlan) and CarePlan.CanModify then
    begin
      if cbxCOMObj.ItemIndex < 0 then
        CarePlan.COMObject := 0
      else
        CarePlan.COMObject := cbxCOMObj.ItemID;
      UpdateApply(CarePlan);
    end;
  end;
end;

procedure TfrmCarePlanEditor.edtCOMParamChange(Sender: TObject);
var
  CarePlan: TTemplate;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
     FCanDoCOMObjects and (FCurTree = tvShared)) then
  begin
    CarePlan := TTemplate(FCurTree.Selected.Data);
    if assigned(CarePlan) and CarePlan.CanModify then
    begin
      CarePlan.COMParam := edtCOMParam.Text;
      UpdateApply(CarePlan);
    end;
  end;
end;

function TfrmCarePlanEditor.GetLinkType(const ANode: TTreeNode): TTemplateLinkType;
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

procedure TfrmCarePlanEditor.cbxLinkNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  tmpSL: TStringList;
  i: integer;
  tmp: string;

begin
  tmpSL := TStringList.Create;
  try
    case TTemplateLinkType(pnlLink.Tag) of
      ltTitle:     FastAssign(SubSetOfAllTitles(StartFrom, Direction), tmpSL);
//      ltConsult:
      ltProcedure:
        begin
          FastAssign(SubSetOfProcedures(StartFrom, Direction), tmpSL);
          for i := 0 to tmpSL.Count-1 do
          begin
            tmp := tmpSL[i];
            setpiece(tmp,U,1,piece(piece(tmp,U,4),';',1));
            tmpSL[i] := tmp;
          end;
        end;
    end;
    cbxLink.ForDataUse(tmpSL);
  finally
    tmpSL.Free;
  end;
end;

procedure TfrmCarePlanEditor.cbxLinkExit(Sender: TObject);
var
  CarePlan,LinkCarePlan: TTemplate;
  update: boolean;

begin
  if((not FUpdating) and (assigned(FCurTree)) and (assigned(FCurTree.Selected)) and
     (FCurTree = tvShared)) then
  begin
    CarePlan := TTemplate(FCurTree.Selected.Data);
    if assigned(CarePlan) and CarePlan.CanModify then
    begin
      update := true;
      if cbxLink.ItemIEN > 0 then
      begin
        LinkCarePlan := GetLinkedTemplate(cbxLink.ItemID, TTemplateLinkType(pnlLink.tag));
        if (assigned(LinkCarePlan) and (LinkCarePlan <> CarePlan)) then
        begin
          ShowMsg(GetLinkName(cbxLink.ItemID, TTemplateLinkType(pnlLink.tag)) +
                      ' is already assigned to another '+TEMPLATE_MODE_NAME[FVEFAMode]+'.');
          cbxLink.SetFocus;
          cbxLink.SelectByID(CarePlan.LinkIEN);
          update := False;
        end
        else
        begin
          CarePlan.FileLink := ConvertFileLink(cbxLink.ItemID, TTemplateLinkType(pnlLink.tag));
          if CarePlan.LinkName <> '' then
            edtName.Text := copy(CarePlan.LinkName,1,edtName.MaxLength);
        end;
      end
      else
        CarePlan.FileLink := '';
      if update then
        UpdateApply(CarePlan);
    end;
  end;
end;

procedure TfrmCarePlanEditor.reBoilKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FNavigatingTab then
  begin
    if ssShift in Shift then
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus //previous control
    else if ssCtrl	in Shift then
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
    FNavigatingTab := False;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

procedure TfrmCarePlanEditor.reBoilKeyPress(Sender: TObject;
  var Key: Char);
begin
  if FNavigatingTab then
    Key := #0;  //Disable shift-tab processinend;
end;

procedure TfrmCarePlanEditor.reBoilKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //The navigating tab controls were inadvertantently adding tab characters
  //This should fix it
  FNavigatingTab := (Key = VK_TAB) and ([ssShift,ssCtrl] * Shift <> []);
  if FNavigatingTab then
    Key := 0;
end;

procedure TfrmCarePlanEditor.SetEditMode(Mode : TcpteMode);  //kt
var Name : string;
begin
  FVEFAMode := Mode;
  Name := TEMPLATE_MODE_NAME[FVEFAMode];
  lblShared.Caption := '&Shared ' + Name + 's';
  lblPersonal.Caption := '&Personal ' + Name + 's';
  lblBoilerplate.Caption := Name + ' &Boilerplate';
  lblGroupBP.Caption := Name + ' &Group Boilerplate';
  lblNotes.Caption := Name + ' &Notes';
  cbEditShared.Caption := 'E&dit Shared ' + Name + 's';
  cbEditUser.Caption := 'E&dit User''s ' + Name + 's';
  cbNotes.Caption := 'Sh&ow ' + Name + ' notes';
  btnNew.Caption := '&New ' + Name;
  lblType.Caption := Name + ' type';
  lblLinkedProbs.Visible := (FVEFAMode = cptemCarePlan);
  btnAddProblem.Visible := (FVEFAMode = cptemCarePlan);
  Self.Caption := Name + ' Template Editor';
  gbProperties.Caption := Name + ' properties';
  if FVEFAMode = cptemCarePlan then begin
    lblName.Caption := 'Goal Na&me';
  end else begin
    lblName.Caption := Name + ' Na&me';
  end;

  mnuNewCarePlanTemplate.Caption := '&New ' + Name + ' Template';
  mnuAutoGen.Caption := '&Generate ' + Name + ' Template';
  mnuTCopy.Caption := '&Copy ' + Name + ' Template';
  mnuTPaste.Caption := '&Paste ' + Name + ' Template';
  mnuTDelete.Caption := '&Delete ' + Name + ' Template';
  mnuFindShared.Caption := 'Find &Shared ' + Name + ' Templates';
  mnuFindPersonal.Caption := '&Find Personal ' + Name + ' Templates';
  mnuEditCarePlanTemplateFields.Caption := 'Edit ' + Name + ' Template Fields';
  mnuImportCarePlanTemplate.Caption := '&Import ' + Name + ' Template';
  mnuExportCarePlanTemplate.Caption := '&Export ' + Name + ' Template';
  mnuRefresh.Caption := '&Refresh ' + Name + ' Templates';
  mnuCarePlanIconLegend.Caption := Name + ' Template Icon Legend';
  mnuInsertField.Caption := 'Insert ' + Name + ' Template &Field';
  mnuGroupBoilerplate.Caption := 'Group ' + Name + ' Template & Boilerplate';

end;

function TfrmCarePlanEditor.PropText : string;
begin
  Result := ' ' + TEMPLATE_MODE_NAME[FVEFAMode] + ' Properties ';
end;


end.

