unit fDrawers;

 (*
 NOTE: The original version of this file may be obtained freely from the VA.

 This modified version of the file is Copyright 6/23/2015 Kevin S. Toppenberg, MD
 --------------------------------------------------------------------

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 == Alternatively, at user's choice, GPL license below may be used ===

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may view details of the GNU General Public License at this URL:
 http://www.gnu.org/licenses/
 *)


{
bugs noticed:
  if delete only note (currently editing) then drawers and encounter button still enabled
}
//vw mod for template callup. Checks in test  4/15/07
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ORCtrls, ComCtrls, ImgList, uTemplates,
  TMGHTML2, uHTMLTools, StrUtils, uTIU, uNoteComponents, //kt added uses on this line. 9/11
  Menus, ORClasses, ORFn, fBase508Form, VA508AccessibilityManager,
  VA508ImageListLabeler;

type
  THTMLModeSwitcher = procedure(HTMLMode : boolean; Quiet : boolean) of object;  //kt 9/11
  TGetActiveEditIEN = function : int64 of object;  //kt added 5/15
  TReloadNotes = procedure of object; //kt added 5/15

  //kt original --> TDrawer = (odNone, odTemplates, odEncounter, odReminders, odOrders);  //kt 6/15
  TDrawer = (odNone, odTemplates, odEncounter, odReminders, odOrders, odProblems); //kt added odProblems 6/15
  TDrawers = set of TDrawer;

  TfrmDrawers = class(TfrmBase508Form)
    lbOrders: TORListBox;
    sbOrders: TORAlignSpeedButton;
    sbReminders: TORAlignSpeedButton;
    sbEncounter: TORAlignSpeedButton;
    sbTemplates: TORAlignSpeedButton;
    pnlOrdersButton: TKeyClickPanel;
    pnlRemindersButton: TKeyClickPanel;
    pnlEncounterButton: TKeyClickPanel;
    pnlTemplatesButton: TKeyClickPanel;
    lbEncounter: TORListBox;
    popTemplates: TPopupMenu;
    mnuPreviewTemplate: TMenuItem;
    pnlTemplates: TPanel;
    tvTemplates: TORTreeView;
    N1: TMenuItem;
    mnuCollapseTree: TMenuItem;
    N2: TMenuItem;
    mnuEditTemplates: TMenuItem;
    pnlTemplateSearch: TPanel;
    btnFind: TORAlignButton;
    edtSearch: TCaptionEdit;
    mnuFindTemplates: TMenuItem;
    mnuNewTemplate: TMenuItem;
    cbMatchCase: TCheckBox;
    cbWholeWords: TCheckBox;
    mnuInsertTemplate: TMenuItem;
    tvReminders: TORTreeView;
    mnuDefault: TMenuItem;
    N3: TMenuItem;
    mnuGotoDefault: TMenuItem;
    N4: TMenuItem;
    mnuViewNotes: TMenuItem;
    mnuCopyTemplate: TMenuItem;
    N5: TMenuItem;
    mnuViewTemplateIconLegend: TMenuItem;
    fldAccessTemplates: TVA508ComponentAccessibility;
    fldAccessReminders: TVA508ComponentAccessibility;
    imgLblReminders: TVA508ImageListLabeler;
    imgLblTemplates: TVA508ImageListLabeler;
    btnMultiSearch: TBitBtn;
    pnlProblemsButton: TKeyClickPanel;    //kt added 6/15
    sbProblems: TORAlignSpeedButton;      //kt added 6/15
    tvProblems: TORTreeView;              //kt added 6/15
    popProblems: TPopupMenu;              //kt added 6/15
    mnuEditProblem: TMenuItem;            //kt added 6/15
    mnuNewProblem: TMenuItem;             //kt added 6/15
    mnuCopyProbName: TMenuItem;           //kt added 10/15
    mnuInsertProbName: TMenuItem;
    RefreshProblemList1: TMenuItem;
    popAutoAddProblems: TMenuItem;
    N6: TMenuItem;
    mnuTMGInsertIntoHTML: TMenuItem;
    procedure InsertEmbeddedDlgIntoHTML(Sender: TObject);                                                    //kt added 3/16
    procedure popAutoAddProblemsClick(Sender: TObject);                                 //kt added
    procedure RefreshProblemList1Click(Sender: TObject);                                //kt added 10/15
    procedure mnuInsertProbNameClick(Sender: TObject);                                  //kt added 10/15
    procedure mnuCopyProbNameClick(Sender: TObject);                                    //kt added 6/15
    procedure tvProblemsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);  //kt added 5/15
    procedure popProblemsPopup(Sender: TObject);                                        //kt added 6/15
    procedure tvProblemsDblClick(Sender: TObject);                                      //kt added 6/15
    procedure sbProblemsClick(Sender: TObject);                                         //kt added 6/15
    procedure mnuNewProblemClick(Sender: TObject);                                      //kt added 6/15
    procedure mnuEditProblemClick(Sender: TObject);                                     //kt added 6/15
    procedure btnMultiSearchClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormResize(Sender: TObject);
    procedure sbTemplatesClick(Sender: TObject);
    procedure sbEncounterClick(Sender: TObject);
    procedure sbRemindersClick(Sender: TObject);
    procedure sbOrdersClick(Sender: TObject);
    procedure sbResize(Sender: TObject);
    procedure tvTemplatesGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvTemplatesGetSelectedIndex(Sender: TObject;
      Node: TTreeNode);
    procedure tvTemplatesExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvTemplatesClick(Sender: TObject);
    procedure tvTemplatesDblClick(Sender: TObject);
    procedure tvTemplatesCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure tvTemplatesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvTemplatesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure popTemplatesPopup(Sender: TObject);
    procedure mnuPreviewTemplateClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuCollapseTreeClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure ToggleMenuItem(Sender: TObject);
    procedure edtSearchEnter(Sender: TObject);
    procedure edtSearchExit(Sender: TObject);
    procedure mnuFindTemplatesClick(Sender: TObject);
    procedure tvTemplatesDragging(Sender: TObject; Node: TTreeNode;
      var CanDrag: Boolean);
    procedure mnuEditTemplatesClick(Sender: TObject);
    procedure mnuNewTemplateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnlTemplateSearchResize(Sender: TObject);
    procedure cbFindOptionClick(Sender: TObject);
    procedure mnuInsertTemplateClick(Sender: TObject);
    procedure tvRemindersMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvRemindersCurListChanged(Sender: TObject; Node: TTreeNode);
    procedure mnuDefaultClick(Sender: TObject);
    procedure mnuGotoDefaultClick(Sender: TObject);
    procedure mnuViewNotesClick(Sender: TObject);
    procedure mnuCopyTemplateClick(Sender: TObject);
    procedure mnuViewTemplateIconLegendClick(Sender: TObject);
    procedure pnlTemplatesButtonEnter(Sender: TObject);
    procedure pnlTemplatesButtonExit(Sender: TObject);
    procedure tvRemindersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvRemindersNodeCaptioning(Sender: TObject;
      var Caption: String);
    procedure fldAccessTemplatesStateQuery(Sender: TObject; var Text: string);
    procedure fldAccessTemplatesInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure fldAccessRemindersInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure fldAccessRemindersStateQuery(Sender: TObject; var Text: string);
  private
    FHtmlModeSwitcher : THTMLModeSwitcher;     //kt 9/11
    FActiveEditIENGetter: TGetActiveEditIEN;   //kt added 5/15
    FReloadNotes : TReloadNotes;               //kt added 5/15
    FTemplateComponentClusterRoot: TCompNode;  //kt added 5/15
    FProblemNodesLoaded : boolean;             //kt added 6/15
    LastHintNode : TTreeNode;                  //kt added 6/15
    FOpenToNode: string;
    FOldMouseUp: TMouseEvent;
    FEmptyNodeCount: integer;
    FOldDragDrop: TDragDropEvent;
    FOldDragOver: TDragOverEvent;
    FOldFontChanged: TNotifyEvent;
    FTextIconWidth: integer;
    FInternalResize: integer;
    FHoldResize: integer;
    FOpenDrawer: TDrawer;
    FLastOpenSize: integer;
    FButtonHeights: integer;
    FInternalExpand :boolean;
    FInternalHiddenExpand :boolean;
    FAsk :boolean;
    FAskExp :boolean;
    FAskNode :TTreeNode;
    FDragNode :TTreeNode;
    FClickOccurred: boolean;
    FHtmlEditControl: THtmlObj;            //kt 9/11
    FRichEditControl: TRichEdit;
    FFindNext: boolean;
    FLastFoundNode: TTreeNode;
    FSplitter: TSplitter;
    FOldCanResize: TCanResizeEvent;
    FSplitterActive: boolean;
    FHasPersonalTemplates: boolean;
    FRemNotifyList: TORNotifyList;
    FDefTempPiece: integer;
    FNewNoteButton: TButton;
    FCurrentVisibleDrawers: TDrawers;
    FCurrentEnabledDrawers: TDrawers;
    function GetAlign: TAlign;
    procedure SetAlign(const Value: TAlign);
    function MinDrawerControlHeight: integer;
    procedure DisableArrowKeyMove(Sender: TObject);
    procedure HandleProblemDblClick(Node : TORtreeNode);     //kt 5/15
    function NodeHint(ANode: TTreeNode): string;             //kt 6/15
    function GetTemplateText(Template : TTemplate) : string; //kt added 5/16
  protected
    procedure PositionToReminder(Sender: TObject);
    procedure RemindersChanged(Sender: TObject);
    procedure SetFindNext(const Value: boolean);
    procedure ReloadTemplates;
    procedure SetRichEditControl(const Value: TRichEdit);
    procedure SetHTMLEditControl(const Value: THtmlObj);   //kt 9/11
    procedure CheckAsk;
    procedure FontChanged(Sender: TObject);
    procedure InitButtons;
    procedure StartInternalResize;
    procedure EndInternalResize;
    procedure ResizeToVisible;
    function ButtonHeights: integer;
    procedure GetDrawerControls(Drawer: TDrawer;
                                var Btn: TORAlignSpeedButton;
                                var Ctrl: TWinControl);
    procedure AddTemplateNode(const tmpl: TTemplate; const Owner: TTreeNode = nil);
    procedure MoveCaret(X, Y: integer);
    procedure MoveHTMLCaret(X, Y: integer);   //kt 9/11
    procedure NewRECDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure NewRECDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
                             var Accept: Boolean);
    procedure NewRECHTMLDragDrop(Sender, Source: TObject; X, Y: Integer);  //kt 9/11
    procedure NewRECHTMLDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
                             var Accept: Boolean);                         //kt 9/11
    procedure InsertText;
    procedure PutTemplateTextIntoEditControl(txt : string; PrintName : string);  //kt added 6/15
    procedure CheckParseComponentCluster(var txt : string; PrintName : string);  //kt added 6/15
    procedure CheckFinishComponentCluster;                                       //kt added 6/15
    procedure SetSplitter(const Value: TSplitter);
    procedure SplitterCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure SetSplitterActive(Active: boolean);
    function EnableDrawer(Drawer: TDrawer; EnableIt: boolean): boolean;
    function InsertOK(Ask: boolean; TemplateIsHTML : boolean = false): boolean; //kt 9/11 added TemplateIsHTML
    procedure OpenToNode(Path: string = '');
    property FindNext: boolean read FFindNext write SetFindNext;
  public
    DocSelRec : TDocSelRec;   //k tadded 6/15/15
    constructor CreateDrawers(AOwner: TComponent; AParent: TWinControl;
                              VisibleDrawers, EnabledDrawers: TDrawers);
    procedure ExternalReloadTemplates;
    procedure OpenDrawer(Drawer: TDrawer);
    procedure ToggleDrawer(Drawer: TDrawer);
    procedure ShowDrawers(Drawers: TDrawers);
    procedure EnableDrawers(Drawers: TDrawers);
    procedure DisplayDrawers(Show: Boolean); overload;
    procedure DisplayDrawers(Show: Boolean; AEnable, ADisplay: TDrawers); overload;
    function CanEditTemplates: boolean;
    function CanEditShared: boolean;
    procedure UpdatePersonalTemplates;
    procedure NotifyWhenRemTreeChanges(Proc: TNotifyEvent);
    procedure RemoveNotifyWhenRemTreeChanges(Proc: TNotifyEvent);
    procedure ResetTemplates;
    property RichEditControl: TRichEdit read FRichEditControl write SetRichEditControl;
    property HTMLEditControl : THtmlObj read FHtmlEditControl write SetHTMLEditControl; //kt 9/11
    property HTMLModeSwitcher : THTMLModeSwitcher read FHtmlModeSwitcher write FHtmlModeSwitcher; //kt 9/11
    property ActiveEditIEN : TGetActiveEditIEN read FActiveEditIENGetter write FActiveEditIENGetter;  //kt added 5/15
    property ReloadNotes : TReloadNotes read FReloadNotes write FReloadNotes;  //kt added 5/15
    property NewNoteButton: TButton read FNewNoteButton write FNewNoteButton;
    property Splitter: TSplitter read FSplitter write SetSplitter;
    property HasPersonalTemplates: boolean read FHasPersonalTemplates;
    property LastOpenSize: integer read FLastOpenSize write FLastOpenSize;
    property DefTempPiece: integer read FDefTempPiece write FDefTempPiece;
    property TheOpenDrawer: TDrawer read FOpenDrawer;
    function HTMLEditActive : boolean;  //kt 9/11
    procedure HandleLaunchTemplateQuickSearch(Sender: TObject);  //kt 10/2014
    procedure HandleLaunchDialogQuickSearch(Sender: TObject);
    procedure HandleLaunchConsole(Sender: TObject);              //kt 6/2015
    procedure InsertTemplateText(Template : TTemplate);          //kt added 6/15
    function InsertTemplatebyName(TemplateName : string) : boolean;       //kt added 6/16
    procedure TransformInsertionText(var txt : string; PrintName : string);   //kt added 6/15
    function GetTemplateTextForInsertion(Template : TTemplate) : string;  //kt added 6/15
    procedure ClearPtData; //kt added 6/15
    procedure ClearProbs;  //kt added 10/15
    procedure ExpandParentNode(ThisNode:TTreeNode);   //TMG
    procedure ReminderSearch(ReturnData: TStrings; SearchTerm:string);  //TMG 7/16/20
  published
    property Align: TAlign read GetAlign write SetAlign;
  end;

{ There is a different instance of frmDrawers on each tab, so make the
  frmDrawers variable local to each tab, do not use this global var! }
//var
  //frmDrawers: TfrmDrawers;

const
  DrawerSplitters = 'frmDrawersSplitters';

implementation

uses fTemplateView, uCore, rTemplates, fTemplateEditor, dShared, uReminders,
  fReminderDialog, RichEdit, fRptBox, Clipbrd, fTemplateDialog, fIconLegend,
  VA508AccessibilityRouter, uVA508CPRSCompatibility, VAUtils, fFindingTemplates,
  Inifiles, ORNet, fTemplateSearch, fTMGQuickConsole, uCarePlan, fNotes, fFrame,  //kt
  uTemplateFields, //kt
  fProbs, uProbs, uConst, uHTMLTemplateFields  //kt
  ;

{$R *.DFM}

const
  BaseMinDrawerControlHeight = 24;
  FindNextText = 'Find Next';


function TfrmDrawers.MinDrawerControlHeight: integer;
begin
  result := ResizeHeight( BaseFont, MainFont, BaseMinDrawerControlHeight);
end;


procedure TfrmDrawers.ResizeToVisible;
var
  NewHeight: integer;
  od: TDrawer;
  Button: TORAlignSpeedButton;
  WinCtrl: TWinControl;

  procedure AllCtrls(AAlign: TAlign);
  var
    od: TDrawer;

  begin
    Parent.DisableAlign;
    try
      for od := succ(low(TDrawer)) to high(TDrawer) do
      begin
        GetDrawerControls(od, Button, WinCtrl);
        Button.Parent.Align := AAlign;
        WinCtrl.Align := AAlign;
      end;
    finally
      Parent.EnableAlign;
    end;
  end;

begin
  if((FHoldResize = 0) and Visible) then
  begin
    FButtonHeights := -1; //Force re-calculate
    NewHeight := 0;
    AllCtrls(alNone);
    for od := succ(low(TDrawer)) to high(TDrawer) do
    begin
      GetDrawerControls(od, Button, WinCtrl);
      if(Button.Parent.Visible) then
      begin
        Button.Parent.Top := NewHeight;
        inc(NewHeight, Button.Parent.Height);
        WinCtrl.Top := NewHeight;
        if(WinCtrl.Visible) then
        begin
          if(FLastOpenSize < 10) or (FLastOpenSize > (Parent.Height - 20)) then
          begin
            FLastOpenSize := (Parent.Height div 4) * 3;
            dec(FLastOpenSize, ButtonHeights);
            if(FLastOpenSize < MinDrawerControlHeight) then
              FLastOpenSize := MinDrawerControlHeight;
          end;
          inc(NewHeight, FLastOpenSize);
          WinCtrl.Height := FLastOpenSize;
        end
        else
          WinCtrl.Height := 0;
      end;
    end;
    AllCtrls(alTop);
    StartInternalResize;
    try
      ClientHeight := NewHeight
    finally
      EndInternalResize;
    end;
  end;
end;

procedure TfrmDrawers.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
var
  od: TDrawer;
  Btn: TORAlignSpeedButton;
  Ctrl: TWinControl;
  IsVisible: boolean;

begin
  if(FInternalResize = 0) then
  begin
    IsVisible := FALSE;
    for od := succ(low(TDrawer)) to high(TDrawer) do
    begin
      GetDrawerControls(od, Btn, Ctrl);
      if(Ctrl.Visible) then
      begin
        IsVisible := TRUE;
        break;
      end;
    end;
    if(not IsVisible) then
      NewHeight := ButtonHeights;
  end;
end;

function TfrmDrawers.ButtonHeights: integer;
begin
  if(FButtonHeights < 0) then
  begin
    FButtonHeights := 0;
    if(pnlOrdersButton.Visible) then
      inc(FButtonHeights, sbOrders.Height);
    if(pnlRemindersButton.Visible) then
      inc(FButtonHeights, sbReminders.Height);
    if(pnlEncounterButton.Visible) then
      inc(FButtonHeights, sbEncounter.Height);
    if(pnlTemplatesButton.Visible) then
      inc(FButtonHeights, sbTemplates.Height);
    if(pnlProblemsButton.Visible) then          //kt 6/15
      inc(FButtonHeights, sbProblems.Height);   //kt 6/15
  end;
  Result := FButtonHeights;
end;

procedure TfrmDrawers.ShowDrawers(Drawers: TDrawers);
var
  od: TDrawer;
  Btn: TORAlignSpeedButton;
  Ctrl: TWinControl;
  SaveLOS: integer;

begin
  if(FCurrentVisibleDrawers = []) or (Drawers <> FCurrentVisibleDrawers) then
  begin
    FCurrentVisibleDrawers := Drawers;
    SaveLOS := FLastOpenSize;
    OpenDrawer(odNone);
    for od := succ(low(TDrawer)) to high(TDrawer) do
    begin
      GetDrawerControls(od, Btn, Ctrl);
      Btn.Parent.Visible := (od in Drawers);
      Ctrl.Visible := FALSE;
      Ctrl.Height := 0;
    end;
    FButtonHeights := -1;
    FLastOpenSize := SaveLOS;
    ResizeToVisible;
    if(odReminders in Drawers) then
    begin
      NotifyWhenRemindersChange(RemindersChanged);
      NotifyWhenProcessingReminderChanges(PositionToReminder);
    end
    else
    begin
      RemoveNotifyRemindersChange(RemindersChanged);
      RemoveNotifyWhenProcessingReminderChanges(PositionToReminder);
    end;
  end;
end;

procedure TfrmDrawers.OpenDrawer(Drawer: TDrawer);
var
  Btn: TORAlignSpeedButton;
  Ctrl: TWinControl;

begin
  if(FOpenDrawer <> Drawer) then
  begin
    StartInternalResize;
    try
      if(FOpenDrawer <> odNone) then
      begin
        GetDrawerControls(FOpenDrawer, Btn, Ctrl);
        Btn.Down := FALSE;
        with Btn.Parent as TPanel do
          if BevelOuter = bvLowered then
            BevelOuter := bvRaised;
        Ctrl.Visible := FALSE;
        Ctrl.Height := 0;
      end;
      if(Drawer = odNone) then
      begin
        FOpenDrawer := Drawer;
        SetSplitterActive(FALSE);
      end
      else
      begin
        GetDrawerControls(Drawer, Btn, Ctrl);
        if(Btn.Parent.Visible) and (Btn.Enabled) then
        begin
          SetSplitterActive(TRUE);
          Btn.Down := TRUE;
          with Btn.Parent as TPanel do
            if BevelOuter = bvRaised then
              BevelOuter := bvLowered;
          Ctrl.Visible := TRUE;
          FOpenDrawer := Drawer;
        end
        else
          SetSplitterActive(FALSE);
      end;
    finally
      EndInternalResize;
    end;
    ResizeToVisible;
  end;
end;

procedure TfrmDrawers.GetDrawerControls(Drawer: TDrawer;
  var Btn: TORAlignSpeedButton; var Ctrl: TWinControl);
begin
  case Drawer of
    odTemplates:
      begin
        Btn  := sbTemplates;
        Ctrl := pnlTemplates;
      end;

    odEncounter:
      begin
        Btn  := sbEncounter;
        Ctrl := lbEncounter;
      end;

    odReminders:
      begin
        Btn  := sbReminders;
        Ctrl := tvReminders;
      end;

    odOrders:
      begin
        Btn  := sbOrders;
        Ctrl := lbOrders;
      end;

    //kt begin mod --- 6/15
    odProblems:
      begin
        Btn  := sbProblems;
        Ctrl := tvProblems;
      end;
    //kt end mod --- 6/15

    else
      begin
        Btn  := nil;
        Ctrl := nil;
      end;
  end;
end;

constructor TfrmDrawers.CreateDrawers(AOwner: TComponent; AParent: TWinControl;
                VisibleDrawers, EnabledDrawers: TDrawers);
begin
  FInternalResize := 0;
  StartInternalResize;
  try
    Create(AOwner);
    //kt begin mod 6/15/15
    DocSelRec.TreeView := nil;
    DocSelRec.TreeType := edseNone;
    DocSelRec.Drawers := self;
    FTemplateComponentClusterRoot := TCompNode.Create(nil, '');
    FProblemNodesLoaded := false;
    //kt end mod 6/15/15
    FButtonHeights := -1;
    FLastOpenSize := 0;
    FOpenDrawer := odNone;
    Parent := AParent;
    Align := alBottom;
    FOldFontChanged := Font.OnChange;
    Font.OnChange := FontChanged;
    InitButtons;
    ShowDrawers(VisibleDrawers);
    EnableDrawers(EnabledDrawers);
    Show;
  finally
    EndInternalResize;
  end;
end;

function TfrmDrawers.EnableDrawer(Drawer: TDrawer; EnableIt: boolean): boolean;
var
  Btn: TORAlignSpeedButton;
  Ctrl: TWinControl;

begin
  inc(FHoldResize);
  try
    GetDrawerControls(Drawer, Btn, Ctrl);
    Btn.Parent.Enabled := EnableIt;
    if(Drawer = FOpenDrawer) and (not Btn.Parent.Enabled) then
      OpenDrawer(odNone);
  finally
    dec(FHoldResize);
  end;
  ResizeToVisible;
  Result := EnableIt;
end;

procedure TfrmDrawers.EnableDrawers(Drawers: TDrawers);
var
  od: TDrawer;

begin
  if(FCurrentEnabledDrawers = []) or (Drawers <> FCurrentEnabledDrawers) then
  begin
    FCurrentEnabledDrawers := Drawers;
    inc(FHoldResize);
    try
      for od := succ(low(TDrawer)) to high(TDrawer) do
        EnableDrawer(od, (od in Drawers));
    finally
      dec(FHoldResize);
    end;
    ResizeToVisible;
  end;
end;

procedure TfrmDrawers.FormResize(Sender: TObject);
begin
  if(FInternalResize = 0) and (FOpenDrawer <> odNone) then
  begin
    FLastOpenSize := Height;
    dec(FLastOpenSize, ButtonHeights);
    if(FLastOpenSize < MinDrawerControlHeight) then
      FLastOpenSize := MinDrawerControlHeight;
    ResizeToVisible;
  end;
end;

procedure TfrmDrawers.sbTemplatesClick(Sender: TObject);
begin
  if(FOpenDrawer <> odTemplates) then
  begin
    ReloadTemplates;
    btnFind.Enabled := (edtSearch.Text <> '');
    pnlTemplateSearch.Visible := mnuFindTemplates.Checked;
  end;
  ToggleDrawer(odTemplates);
  if ScreenReaderActive then
    pnlTemplatesButton.SetFocus;
end;

procedure TfrmDrawers.sbEncounterClick(Sender: TObject);
begin
  ToggleDrawer(odEncounter);
end;

procedure TfrmDrawers.sbRemindersClick(Sender: TObject);
begin
  if(InitialRemindersLoaded) then
    ToggleDrawer(odReminders)
  else
  begin
    StartupReminders;
    if(GetReminderStatus = rsNone) then
    begin
      EnableDrawer(odReminders, FALSE);
      sbReminders.Down := FALSE;
      with sbReminders.Parent as TPanel do
        if BevelOuter = bvLowered then
          BevelOuter := bvRaised;
    end
    else
      ToggleDrawer(odReminders)
  end;
  if ScreenReaderActive then
    pnlRemindersButton.SetFocus;
end;

procedure TfrmDrawers.sbOrdersClick(Sender: TObject);
begin
  ToggleDrawer(odOrders);
end;

procedure TfrmDrawers.sbProblemsClick(Sender: TObject);
//kt added 6/15
begin
  inherited;
  if not FProblemNodesLoaded then begin
    LoadProblemNodes(tvProblems, false);
    FProblemNodesLoaded := true;
end;
  ToggleDrawer(odProblems);
end;

procedure TfrmDrawers.ToggleDrawer(Drawer: TDrawer);
begin
  if(Drawer = FOpenDrawer) then
    OpenDrawer(odNone)
  else
    OpenDrawer(Drawer);
end;

procedure TfrmDrawers.EndInternalResize;
begin
  if(FInternalResize > 0) then dec(FInternalResize);
end;

procedure TfrmDrawers.StartInternalResize;
begin
  inc(FInternalResize);
end;

procedure TfrmDrawers.sbResize(Sender: TObject);
var
  Button: TORAlignSpeedButton;
  Mar: integer; // Mar Needed because you can't assign Margin a negative value

begin
  Button := (Sender as TORAlignSpeedButton);
  Mar := (Button.Width - FTextIconWidth) div 2;
  if(Mar < 0) then
    Mar := 0;
  Button.Margin := Mar;
end;

procedure TfrmDrawers.InitButtons;
var
  od: TDrawer;
  Btn: TORAlignSpeedButton;
  Ctrl: TWinControl;
  TmpWidth: integer;
  TmpHeight: integer;
  MaxHeight: integer;

begin
  StartInternalResize;
  try
    FTextIconWidth := 0;
    MaxHeight := 0;
    for od := succ(low(TDrawer)) to high(TDrawer) do
    begin
      GetDrawerControls(od, Btn, Ctrl);
      TmpWidth := Canvas.TextWidth(Btn.Caption) + Btn.Spacing +
                  (Btn.Glyph.Width div Btn.NumGlyphs) + 4;
      if(TmpWidth > FTextIconWidth) then
        FTextIconWidth := TmpWidth;
      TmpHeight := Canvas.TextHeight(Btn.Caption) + 9;
      if(TmpHeight > MaxHeight) then
        MaxHeight := TmpHeight;
    end;
    if(MaxHeight > 0) then
    begin
      for od := succ(low(TDrawer)) to high(TDrawer) do
      begin
        GetDrawerControls(od, Btn, Ctrl);
        Btn.Parent.Height := MaxHeight;
      end;
    end;
    Constraints.MinWidth := FTextIconWidth;
  finally
    EndInternalResize;
  end;
  ResizeToVisible;
end;

procedure TfrmDrawers.FontChanged(Sender: TObject);
var
  Ht: integer;

begin
  if(assigned(FOldFontChanged)) then
    FOldFontChanged(Sender);
  if(FInternalResize = 0) then
  begin
    InitButtons;
    ResizeToVisible;
    btnFind.Width := Canvas.TextWidth(FindNextText) + 10;
    btnFind.Height := edtSearch.Height;
    btnFind.Left := pnlTemplateSearch.Width - btnFind.Width;
    edtSearch.Width := pnlTemplateSearch.Width - btnFind.Width;
    cbMatchCase.Width := Canvas.TextWidth(cbMatchCase.Caption)+23;
    cbWholeWords.Width := Canvas.TextWidth(cbWholeWords.Caption)+23;
    Ht := Canvas.TextHeight(cbMatchCase.Caption);
    if(Ht < 17) then Ht := 17;
    pnlTemplateSearch.Height := edtSearch.Height + Ht;
    cbMatchCase.Height := Ht;
    cbWholeWords.Height := Ht;
    cbMatchCase.Top := edtSearch.Height;
    cbWholeWords.Top := edtSearch.Height;
    pnlTemplateSearchResize(Sender);
  end;
end;

procedure TfrmDrawers.AddTemplateNode(const tmpl: TTemplate; const Owner: TTreeNode = nil);
begin
  dmodShared.AddTemplateNode(tvTemplates, FEmptyNodeCount, tmpl, FALSE, Owner);
end;

procedure TfrmDrawers.tvTemplatesGetImageIndex(Sender: TObject;
  Node: TTreeNode);

begin
  if not assigned(Node.Data) and IsProblemListNode(Node) then begin  //kt 5/15 add block
    if Node.Count > 0 then Node.ImageIndex := 5 else Node.ImageIndex := 10;
  end else begin //kt 5/15
    Node.ImageIndex := dmodShared.ImgIdx(Node);
  end;  //kt 5/15
end;

procedure TfrmDrawers.tvTemplatesGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  if not assigned(Node.Data) and IsProblemListNode(Node) then begin  //kt 5/15 add block
    if Node.Count > 0 then Node.SelectedIndex := 5 else Node.SelectedIndex := 10;
  end else begin //kt 5/15
    Node.SelectedIndex := dmodShared.ImgIdx(Node);
  end;  //kt 5/15
end;
  //vw mod for template callup. Checks in test

procedure TfrmDrawers.HandleProblemDblClick(Node : TORtreeNode);
//kt added 5/15
var DataStr, ProbIEN, ProbName, ProbICD : string;
begin
  DataStr := Node.StringData;
  DataStr := Pieces2(DataStr, U, 4, 999);
  ProbIEN := piece(DataStr, U, 1);
  ProbName := piece(DataStr, U, 3);
  ProbICD := piece(DataStr, U, 4);
  if AddComponentForProblem(ProbIEN, ProbName, ProbICD, HTMLEditActive, Self.DocSelRec) then begin
    //Perhaps here tell problem tab, prob edit dialog to reload linked titles ... or not.
  end;
   //Application.MessageBox(PChar('Node='+IntToStr(Node.Index)+' tvtemplates.VertScrollPos='+IntToStr(tvTemplates.VertScrollPos)),PChar(Application.Title),MB_ICONINFORMATION);
   //sbTemplates.Caption := 'Templates '+ 'Node='+IntToStr(Node.Index)+' VertScrollPos='+IntToStr(tvTemplates.VertScrollPos) ;
  //end vw mod
  Node.SelectedIndex := dmodShared.ImgIdx(Node);
end;

procedure TfrmDrawers.tvTemplatesExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  //kt 5/15 original --> if(assigned(Node)) then
  if assigned(Node) and assigned(Node.Data) then  //kt 5/15
  if(assigned(Node)) then
  begin
    if(Dragging) then EndDrag(FALSE);
    if(not FInternalExpand) then
    begin
      if(TTemplate(Node.Data).RealType = ttGroup) then
      begin
        FAsk := TRUE;
        FAskExp := TRUE;
        AllowExpansion := FALSE;
        FAskNode := Node;
      end;
    end;
    if(AllowExpansion) then
    begin
      FClickOccurred := FALSE;
      AllowExpansion := dmodShared.ExpandNode(tvTemplates, Node, FEmptyNodeCount);
      if(FInternalHiddenExpand) then AllowExpansion := FALSE;
    end;
  end;
    //vw mod for template callup. Checks in test

   //Application.MessageBox(PChar('Node='+IntToStr(Node.Index)+' tvtemplates.VertScrollPos='+IntToStr(tvTemplates.VertScrollPos)),PChar(Application.Title),MB_ICONINFORMATION);
   //kt sbTemplates.Caption := 'Templates '+ 'Node='+IntToStr(Node.Index)+' VertScrollPos='+IntToStr(tvTemplates.VertScrollPos) ;
  //end vw mod
end;

procedure TfrmDrawers.CheckAsk;
begin
  if(FAsk) then
  begin
    FAsk := FALSE;
    FInternalExpand := TRUE;
    try
      if(FAskExp) then
        FAskNode.Expand(FALSE)
      else
        FAskNode.Collapse(FALSE);
    finally
      FInternalExpand := FALSE;
    end;
  end;
end;

procedure TfrmDrawers.tvTemplatesClick(Sender: TObject);
begin
  FClickOccurred := TRUE;
  CheckAsk;
end;

procedure TfrmDrawers.tvTemplatesDblClick(Sender: TObject);
var  ATemplate : TTemplate;  //kt
begin
  if(not FClickOccurred) then begin
    CheckAsk
  end else begin
    FAsk := FALSE;
    //kt original --> if((assigned(tvTemplates.Selected)) and
    //kt original -->    (TTemplate(tvTemplates.Selected.Data).RealType in [ttDoc, ttGroup])) then
    //kt original -->   InsertText;
    //kt 6/16 -- mod --------
    ATemplate := TTemplate(tvTemplates.Selected.Data);
    if not assigned(ATemplate) then exit;
    if not (ATemplate.RealType in [ttDoc, ttGroup]) then exit;
    if TestTemplateForLinkedDx(ATemplate) then begin//kt added this 1 line for CarePlans  5/5/11
      if ATemplate.EmbeddedDialog then begin
        InsertEmbeddedDlgIntoHTML(Sender);
      end else begin
        InsertText;
      end;
    end;
    ResolveEmbeddedTemplates(Self);
    //kt end mod ---------------
  end;
end;

procedure TfrmDrawers.tvTemplatesCollapsing(Sender: TObject;
  Node: TTreeNode; var AllowCollapse: Boolean);
begin
  //kt 5/15 original --> if(assigned(Node)) then
  if assigned(Node) and assigned(Node.Data) then  //kt 5/15
  begin
    if(Dragging) then EndDrag(FALSE);
    if(not FInternalExpand) then
    begin
      if(TTemplate(Node.Data).RealType = ttGroup) then
      begin
        FAsk := TRUE;
        FAskExp := FALSE;
        AllowCollapse := FALSE;
        FAskNode := Node;
      end;
    end;
    if(AllowCollapse) then
      FClickOccurred := FALSE;
  end;
    //vw mod for template callup. Checks in test

   //Application.MessageBox(PChar('Node='+IntToStr(Node.Index)+' tvtemplates.VertScrollPos='+IntToStr(tvTemplates.VertScrollPos)),PChar(Application.Title),MB_ICONINFORMATION);
   //kt sbTemplates.Caption := 'Templates '+ 'Node='+IntToStr(Node.Index)+' VertScrollPos='+IntToStr(tvTemplates.VertScrollPos) ;
  //end vw mod
end;

procedure TfrmDrawers.tvTemplatesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CheckAsk;
  case Key of
  VK_SPACE, VK_RETURN:
    begin
      InsertText;
      Key := 0;
    end;
  end;
end;

procedure TfrmDrawers.tvTemplatesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CheckAsk;
end;

procedure TfrmDrawers.SetRichEditControl(const Value: TRichEdit);
begin
  if(FRichEditControl <> Value) then
  begin
    if(assigned(FRichEditControl)) then
    begin
      FRichEditControl.OnDragDrop := FOldDragDrop;
      FRichEditControl.OnDragOver := FOldDragOver;
    end;
    FRichEditControl := Value;
    if(assigned(FRichEditControl)) then
    begin
      FOldDragDrop := FRichEditControl.OnDragDrop;
      FOldDragOver := FRichEditControl.OnDragOver;
      FRichEditControl.OnDragDrop := NewRECDragDrop;
      FRichEditControl.OnDragOver := NewRECDragOver;
    end;
  end;
end;


procedure TfrmDrawers.SetHTMLEditControl(const Value: THtmlObj);
//kt added this function 9/11
begin
  if (FHtmlEditControl <> Value) then begin
    if (assigned(FHtmlEditControl)) then begin
      FHtmlEditControl.OnDragDrop := FOldDragDrop;
      FHtmlEditControl.OnDragOver := FOldDragOver;
    end;
    FHtmlEditControl := Value;
    if (assigned(FHtmlEditControl)) then begin
      FOldDragDrop := FHtmlEditControl.OnDragDrop;
      FOldDragOver := FHtmlEditControl.OnDragOver;
      FHtmlEditControl.OnDragDrop := NewRECHTMLDragDrop;
      FHtmlEditControl.OnDragOver := NewRECHTMLDragOver;
    end;
  end;
end;

function TfrmDrawers.HTMLEditActive : boolean;
//kt added this function 9/11
begin
  if assigned(FHtmlEditControl) then begin
    Result := FHtmlEditControl.Active;
  end else Result := false;
end;


procedure TfrmDrawers.MoveCaret(X, Y: integer);
var
  pt: TPoint;

begin
  FRichEditControl.SetFocus;
  pt := Point(x, y);
  FRichEditControl.SelStart := FRichEditControl.Perform(EM_CHARFROMPOS,0,LParam(@pt));
end;


procedure TfrmDrawers.MoveHTMLCaret(X, Y: integer);
//kt added entire function 9/11
var   pt: TPoint;
begin
  FHtmlEditControl.SetFocus;
  pt := Point(x, y);
  FHTMLEditControl.MoveCaretToPos(pt);
end;


procedure TfrmDrawers.NewRECDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if(Source = tvTemplates) then
  begin
    MoveCaret(X, Y);
    InsertText;
  end
  else
  if(assigned(FOldDragDrop)) then
    FOldDragDrop(Sender, Source, X, Y);
end;

procedure TfrmDrawers.NewRECDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);

begin
  Accept := FALSE;
  if(Source = tvTemplates) then
  begin
    if(assigned(FDragNode)) and (TTemplate(FDragNode.Data).RealType in [ttDoc, ttGroup]) then
    begin
      Accept := TRUE;
      MoveCaret(X, Y);
    end;
  end
  else
  if(assigned(FOldDragOver)) then
    FOldDragOver(Sender, Source, X, Y, State, Accept);
end;


procedure TfrmDrawers.NewRECHTMLDragDrop(Sender, Source: TObject; X, Y: Integer);
//kt added function 9/11
//NOTE: I think this can be combined with NewRECDragDrop, but must fix MoveCaret
begin
  if (Source = tvTemplates) then begin
    MoveHTMLCaret(X, Y);
    InsertText;
  end else if(assigned(FOldDragDrop)) then begin
    FOldDragDrop(Sender, Source, X, Y);
  end;
end;


procedure TfrmDrawers.NewRECHTMLDragOver(Sender, Source: TObject;
                                     X, Y: Integer; State: TDragState;
                                     var Accept: Boolean);
//kt added function 9/11
begin
  Accept := FALSE;
  if (Source = tvTemplates) then begin
    if (assigned(FDragNode))
    and (TTemplate(FDragNode.Data).RealType in [ttDoc, ttGroup]) then begin
      Accept := TRUE;
      MoveHTMLCaret(X, Y);
    end;
  end else if (assigned(FOldDragOver)) then begin
    FOldDragOver(Sender, Source, X, Y, State, Accept);
  end;
end;

{ //kt copy of original InsertText saved here for future reference
procedure TfrmDrawers.InsertText;
var
  BeforeLine, AfterTop: integer;
  txt, DocInfo: string;
  Template: TTemplate;

begin
  DocInfo := '';
  if InsertOK(TRUE) and (dmodShared.TemplateOK(tvTemplates.Selected.Data)) then
  begin
    Template := TTemplate(tvTemplates.Selected.Data);
    if not AvoidDuplicateDataIfCarePlan(FRichEditControl, Template.PrintName) then exit;  //kt   5/6/11
    Template.TemplatePreviewMode := FALSE;
    if Template.IsReminderDialog then
      Template.ExecuteReminderDialog(TForm(Owner))
    else
    begin
      uCarePlan.CurrentDialogIsCarePlan := uCarePlan.TemplateNameIsCP(Template.PrintName,cptemLetter );  //kt  -- will affect if aswers are wrapped in tagged-text markers
      if Template.IsCOMObject then
        txt := Template.COMObjectText('', DocInfo)
      else
        txt := Template.Text;
      if(txt <> '') then
      begin
        CheckBoilerplate4Fields(txt, 'Template: ' + Template.PrintName);
        if txt <> '' then
        begin
          IndentMemoTextIfCarePlan(Template.PrintName, txt, FRichEditControl);   //kt   5/6/11
          BeforeLine := SendMessage(FRichEditControl.Handle, EM_EXLINEFROMCHAR, 0, FRichEditControl.SelStart);
          FRichEditControl.SelText := txt;
          FRichEditControl.SetFocus;
          SendMessage(FRichEditControl.Handle, EM_SCROLLCARET, 0, 0);
          AfterTop := SendMessage(FRichEditControl.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
          SendMessage(FRichEditControl.Handle, EM_LINESCROLL, 0, -1 * (AfterTop - BeforeLine));
          SpeakTextInserted;
        end;
      end;
    end;
  end;
end;
}

procedure TfrmDrawers.ClearPtData;
//kt added 6/15
begin
  ClearProbs;
end;

procedure TfrmDrawers.ClearProbs;
//kt added 10/7/15
begin
  ClearProblemNodes(tvProblems);
  FProblemNodesLoaded := false;
  OpenDrawer(odNone)
end;

procedure TfrmDrawers.InsertText;
//kt Entire function is essentially custom, for allowing customized use.
//kt We have made so many mods to this function we will not mark each change.
//   Instead, a copy of the original InsertText() will be included above.
var Template: TTemplate;
begin
  Template := TTemplate(tvTemplates.Selected.Data);
  InsertTemplateText(Template);
end;

procedure TfrmDrawers.InsertTemplateText(Template : TTemplate);
//kt Added 6/15
//   This is split-up of original InsertText() procedure.
//   We have made so many mods to this InsertText that we will not mark each change.
//   Instead, a copy of the original InsertText() will be included above.
var
  txt: string;
begin
  if not InsertOK(TRUE) then exit;
  if not dmodShared.TemplateOK(Template) then exit;
  txt := GetTemplateTextForInsertion(Template);
  CheckParseComponentCluster(txt, Template.PrintName);  //kt added 2015
  TransformInsertionText(txt, Template.PrintName);
  PutTemplateTextIntoEditControl(txt, Template.PrintName);

  HandleTemplateIfCarePlan(Template);
  uCarePlan.CurrentDialogIsCarePlan := false;

  CheckFinishComponentCluster;
end;

function TfrmDrawers.InsertTemplatebyName(TemplateName : string) : boolean;
//kt added 6/16
begin
  Result := fTemplateSearch.InsertTemplateByName(Self, TemplateName);
end;


function TfrmDrawers.GetTemplateTextForInsertion(Template : TTemplate) : string;
//kt Added 6/15
//   This is split-up of original InsertText() procedure.
//   We have made so many mods to this InsertText that we will not mark each change.
//   Instead, a copy of the original InsertText() will be included above.
var
  txt, DocInfo: string;
  //TemplateIsHTML : boolean;

begin
  Result := '';
  txt := '';
  DocInfo := '';
  if not dmodShared.TemplateOK(Template) then exit;
  //NOTE for line below!!  6/15
  //The line below only considers careplan data in the RichEdit editor.  It doesn't check
  //  in the HTML editor.  VEFA project didn't use HTML.  This is incomplete and should be fixed.
  if not AvoidDuplicateDataIfCarePlan(FRichEditControl, Template.PrintName) then exit;  //VEFA-261   5/6/11
  Template.TemplatePreviewMode := FALSE;
  if Template.IsReminderDialog then begin
    Template.ExecuteReminderDialog(TForm(Owner));
    exit;
  end else begin
    uCarePlan.CurrentDialogIsCarePlan := uCarePlan.TemplateNameIsCP(Template.PrintName);  //kt-cp  -- will affect if aswers are wrapped in tagged-text markers
    if Template.IsCOMObject then begin
      txt := Template.COMObjectText('', DocInfo)
    end else begin
      //kt original --> txt := Template.Text;
      txt := GetTemplateText(Template);
    end;
  end;
  Result := txt;
end;

procedure TfrmDrawers.TransformInsertionText(var txt : string; PrintName : string);
//kt added 6/15
//   This is split-up of original InsertText() procedure.
//   We have made so many mods to this InsertText that we will not mark each change.
//   Instead, a copy of the original InsertText() will be included above.
var
  tempSL : TStringList;
  DlgMode : TDialogModesSet;
  DBControlData : TDBControlData; //kt added
  ErrStr : String; //kt added
begin
  DlgMode := [tHTML];  //TO DO -- LATER MAKE THIS AN INTELLIGENT DECISION REGARDING MODE SELECTION...
  DBControlData := TDBControlData.Create;  //kt 5/16
  //kt original --> CheckBoilerplate4Fields(txt, 'Template: ' + PrintName, DlgMode);
  CheckBoilerplate4Fields(txt, 'Template: ' + PrintName, DlgMode, DBControlData);
  DBControlData.SaveToServer(Self.ActiveEditIEN, ErrStr);  //kt added 5/16
  if ErrStr <> '' then MessageDlg(ErrStr, mtError, [mbOK], 0); //kt added
  DBControlData.Free; //kt added
  if uTemplates.UsingHTMLTargetMode then begin
    if uHTMLTools.TextIsHTML(Txt)  then begin
      txt := uHTMLTools.FixHTMLCRLF(Txt);
      txt := uHTMLTools.ConvertSpaces2HTML(Txt);
      txt := uHTMLTools.UnwrapHTML(Txt);
    end else begin
      txt := uHTMLTools.Text2HTML(Txt);
    end;
  end;
  if (pos(CPRS_DIR_SIGNAL, txt)>0) then begin
    tempSL := TStringList.create;
    tempSL.Text := txt;
    uHTMLTools.IsHTML(tempSL);  //calls ScanForSubs...
    txt := AnsiReplaceStr(txt, CPRS_DIR_SIGNAL, CPRSDir);  //kt  Replaces ALL occurances.  Added in case of image being sent 5/22/14
    FreeAndNil(tempSL);
  end;
  {
  if uNoteComponents.TemplateHasComponents(txt) then begin  //kt added block
    FTemplateComponentClusterRoot.Clear;
    FTemplateComponentClusterRoot.Name := PrintName;
    uNoteComponents.ParseTemplate(txt, FTemplateComponentClusterRoot);
    txt := FTemplateComponentClusterRoot.TextSL.Text;
    if assigned(ActiveEditIEN) then begin
      FTemplateComponentClusterRoot.NoteIEN := self.ActiveEditIEN;
    end else begin
      FTemplateComponentClusterRoot.NoteIEN := -1;
    end;
  end;
  }
end;


procedure TfrmDrawers.CheckParseComponentCluster(var txt : string; PrintName : string);
//kt added 6/15
begin
  if uNoteComponents.TemplateHasComponents(txt) then begin  //kt added block
    FTemplateComponentClusterRoot.Clear;
    FTemplateComponentClusterRoot.Name := PrintName;
    uNoteComponents.ParseTemplate(txt, FTemplateComponentClusterRoot, TransformInsertionText, HTMLEditActive);
    txt := FTemplateComponentClusterRoot.TextSL.Text;
    if assigned(ActiveEditIEN) then begin
      FTemplateComponentClusterRoot.NoteIEN := self.ActiveEditIEN;
    end else begin
      FTemplateComponentClusterRoot.NoteIEN := -1;
    end;
  end;
end;


procedure TfrmDrawers.PutTemplateTextIntoEditControl(txt : string; PrintName : string);
//kt added 6/15
//   This is split-up of original InsertText() procedure.
//   We have made so many mods to this InsertText that we will not mark each change.
//   Instead, a copy of the original InsertText() will be included above.
var
  BeforeLine, AfterTop: integer;
  //tempSL : TStringList;
  //TemplateComponentClusterRoot: TCompNode;

begin
  {
  CheckBoilerplate4Fields(txt, 'Template: ' + PrintName);
  if uTemplates.UsingHTMLMode then begin
    if uHTMLTools.IsHTML(Txt)  then begin
      Txt := uHTMLTools.FixHTMLCRLF(Txt);
      Txt := uHTMLTools.ConvertSpaces2HTML(Txt);
      Txt := uHTMLTools.UnwrapHTML(Txt);
    end else begin
      Txt := uHTMLTools.Text2HTML(Txt);
    end;
  end;
  }
  {
  if uNoteComponents.TemplateHasComponents(txt) then begin  //kt added block
    TemplateComponentClusterRoot := TCompNode.Create(nil, PrintName);
    uNoteComponents.ParseTemplate(txt, TemplateComponentClusterRoot);
    txt := TemplateComponentClusterRoot.TextSL.Text;
    if assigned(ActiveEditIEN) then begin
      TemplateComponentClusterRoot.NoteIEN := self.ActiveEditIEN;
    end else begin
      TemplateComponentClusterRoot.NoteIEN := -1;
    end;
  end;
  }
  if HTMLEditActive then begin
    //elh   resolve later IndentHTMLTextIfCarePlan(Template.PrintName, txt, FHtmlEditControl);   //kt   9/11
    {
    if pos(CPRS_DIR_SIGNAL,txt)>0 then begin
      tempSL := TStringList.create;
      tempSL.Text := txt;
      uHTMLTools.IsHTML(tempSL);
      txt := AnsiReplaceStr(txt,CPRS_DIR_SIGNAL,CPRSDir);  //kt  added in case of image being sent 5/22/14
      FreeAndNil(tempSL);
    end;
    }
    FHtmlEditControl.SelText := txt;
    FHtmlEditControl.SetFocus;
  end else begin
    IndentMemoTextIfCarePlan(PrintName, txt, FRichEditControl);
    BeforeLine := SendMessage(FRichEditControl.Handle, EM_EXLINEFROMCHAR, 0, FRichEditControl.SelStart);
    FRichEditControl.SelText := txt;
    FRichEditControl.SetFocus;
    SendMessage(FRichEditControl.Handle, EM_SCROLLCARET, 0, 0);
    AfterTop := SendMessage(FRichEditControl.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
    SendMessage(FRichEditControl.Handle, EM_LINESCROLL, 0, -1 * (AfterTop - BeforeLine));
  end;
end;

procedure TfrmDrawers.CheckFinishComponentCluster;
begin
  if not FTemplateComponentClusterRoot.HasChildren then exit;
  //Here I will call to create the template cluster,
  //At this point, each node in cluster contains the insertion text to be put into that node
  //   and that text has aleady been put through template transformation engine.
  uNoteComponents.HiddenCreateComponentCluster(FTemplateComponentClusterRoot); //adds notes just server-side.
  if assigned(ReloadNotes) then ReloadNotes;
  FTemplateComponentClusterRoot.Clear;
end;



procedure TfrmDrawers.popAutoAddProblemsClick(Sender: TObject);
//kt added  11/15
begin
  inherited;
  frmFrame.SetActiveTab(CT_PROBLEMS);
  frmProblems.mnuAutoAddProbsClick(Sender);
  ReloadProblemNodes(tvProblems, false);
end;

procedure TfrmDrawers.popProblemsPopup(Sender: TObject);
//kt added 6/15
var Node : TTreeNode;
begin
  inherited;
  Node := tvProblems.Selected;
  mnuEditProblem.Enabled := (ProbNodeCategory(Node) <> '');
  //mnuNewProblem.Enabled := IsProblemListNode(Node);

end;

procedure TfrmDrawers.popTemplatesPopup(Sender: TObject);
var
  Node: TTreeNode;
  ok, ok2, NodeFound: boolean;
  Def: string;

begin
  ok := FALSE;
  ok2 := FALSE;
  if(FOpenDrawer = odTemplates) then
  begin
    Node := tvTemplates.Selected;
    tvTemplates.Selected := Node; // This line prevents selected from changing after menu closes
    NodeFound := (assigned(Node));
    if(NodeFound) then
    begin
      with TTemplate(Node.Data) do
      begin
        ok := (RealType in [ttDoc, ttGroup]);
        ok2 := ok and (not IsReminderDialog) and (not IsCOMObject);
      end;
    end;
    Def := Piece(GetUserTemplateDefaults, '/', FDefTempPiece);
    mnuGotoDefault.Enabled := (Def <> '');
    mnuViewNotes.Enabled := NodeFound and (TTemplate(Node.Data).Description <> '');
    mnuDefault.Enabled := NodeFound;
    mnuDefault.Checked := NodeFound and (tvTemplates.GetNodeID(TORTreeNode(Node), 1, ';') = Def);
  end
  else
  begin
    mnuDefault.Enabled := FALSE;
    mnuGotoDefault.Enabled := FALSE;
    mnuViewNotes.Enabled := FALSE;
  end;
  mnuPreviewTemplate.Enabled := ok2;
  mnuCopyTemplate.Enabled := ok2;
  mnuInsertTemplate.Enabled := ok and InsertOK(FALSE);
  mnuFindTemplates.Enabled := (FOpenDrawer = odTemplates);
  mnuCollapseTree.Enabled := ((FOpenDrawer = odTemplates) and
                              (dmodShared.NeedsCollapsing(tvTemplates)));
  mnuEditTemplates.Enabled := (UserTemplateAccessLevel in [taAll, taEditor]);
  mnuNewTemplate.Enabled := (UserTemplateAccessLevel in [taAll, taEditor]);
end;

function TfrmDrawers.GetTemplateText(Template : TTemplate) : string; //kt added 5/16
//kt added function
var
  DBControlData : TDBControlData; //kt added
  ErrStr : String; //kt added
begin
  //kt 6/16 original --> if Template.IsDialog then begin
  if Template.IsDialog and not Template.EmbeddedDialog then begin
    DBControlData := TDBControlData.Create;  //kt 5/16
    Result := Template.GetText(DBControlData); //kt
    DBControlData.SaveToServer(Self.ActiveEditIEN, ErrStr);  //kt added 5/16
    if ErrStr <> '' then MessageDlg(ErrStr, mtError, [mbOK], 0); //kt added
    DBControlData.Free; //kt added
  end else begin
    Result := Template.GetText(nil); //kt
  end;
end;


procedure TfrmDrawers.mnuPreviewTemplateClick(Sender: TObject);
var
  tmpl: TTemplate;
  txt: String;

begin
  if(assigned(tvTemplates.Selected)) then
  begin
    if(dmodShared.TemplateOK(tvTemplates.Selected.Data,'template preview')) then
    begin
      tmpl := TTemplate(tvTemplates.Selected.Data);
      tmpl.TemplatePreviewMode := TRUE; // Prevents "Are you sure?" dialog when canceling
      //kt original --> txt := tmpl.Text;
      txt := GetTemplateText(tmpl);  //kt
      if(not tmpl.DialogAborted) then
        ShowTemplateData(Self, tmpl.PrintName, txt);
    end;
  end;
end;

procedure TfrmDrawers.FormDestroy(Sender: TObject);
begin
  FTemplateComponentClusterRoot.Free; //kt 6/15
  dmodShared.RemoveDrawerTree(Self);
  KillObj(@FRemNotifyList);
end;

procedure TfrmDrawers.mnuCollapseTreeClick(Sender: TObject);
begin
  tvTemplates.Selected := nil;
  tvTemplates.FullCollapse;
end;

procedure TfrmDrawers.RefreshProblemList1Click(Sender: TObject);
//kt added
begin
  inherited;
  ReloadProblemNodes(tvProblems, false);
end;

procedure TfrmDrawers.ReloadTemplates;
begin
  SetFindNext(FALSE);
  LoadTemplateData;
  if(UserTemplateAccessLevel <> taNone) and (assigned(MyTemplate)) and
    (MyTemplate.Children in [tcActive, tcBoth]) then
  begin
    AddTemplateNode(MyTemplate);
    FHasPersonalTemplates := TRUE;
  end;
  AddTemplateNode(RootTemplate);
  //kt 5/15 begin mod -----------
  //if (assigned(TMGProblemListTmpl)) and (TMGProblemListTmpl.Children in [tcActive]) then begin
  //  AddTemplateNode(TMGProblemListTmpl);
  //end;
  //LoadProblemNodes(tvTemplates);
  //LoadProblemNodes(tvProblems);
  //kt 5/15 end mod -----------
  OpenToNode;
end;

procedure TfrmDrawers.HandleLaunchTemplateQuickSearch(Sender: TObject);
//kt added 10/28/14
begin
  fTemplateSearch.LaunchTemplateSearch(self,TsmTemplate);
end;

procedure TfrmDrawers.HandleLaunchDialogQuickSearch(Sender: TObject);
//kt added 10/28/14
begin
  fTemplateSearch.LaunchTemplateSearch(self,TsmDialog);
end;

procedure TfrmDrawers.HandleLaunchConsole(Sender: TObject);
//kt added 6/2015
begin
  fTMGQuickConsole.LaunchQuickConsole(Self);
end;


procedure TfrmDrawers.btnMultiSearchClick(Sender: TObject);
//kt added 10/26/14
begin
  inherited;
  HandleLaunchTemplateQuickSearch(Sender);
end;

procedure TfrmDrawers.btnFindClick(Sender: TObject);
var
  Found, TmpNode: TTreeNode;
  IsNext: boolean;

begin
  if(edtSearch.text <> '') then
  begin
    IsNext := ((FFindNext) and assigned (FLastFoundNode));
    if IsNext then
      TmpNode := FLastFoundNode
    else
      TmpNode := tvTemplates.Items.GetFirstNode;
    FInternalExpand := TRUE;
    FInternalHiddenExpand := TRUE;
    try
      Found := FindTemplate(edtSearch.Text, tvTemplates, Application.MainForm, TmpNode,
                            IsNext, not cbMatchCase.Checked, cbWholeWords.Checked);
    finally
      FInternalExpand := FALSE;
      FInternalHiddenExpand := FALSE;
    end;

    if assigned(Found) then
    begin
      FLastFoundNode := Found;
      SetFindNext(TRUE);
      FInternalExpand := TRUE;
      try
        tvTemplates.Selected := Found;
      finally
        FInternalExpand := FALSE;
      end;
    end;
  end;
  edtSearch.SetFocus;
end;

procedure TfrmDrawers.SetFindNext(const Value: boolean);
begin
  if(FFindNext <> Value) then
  begin
    FFindNext := Value;
    if(FFindNext) then btnFind.Caption := FindNextText
    else btnFind.Caption := 'Find';
  end;
end;

procedure TfrmDrawers.edtSearchChange(Sender: TObject);
begin
  btnFind.Enabled := (edtSearch.Text <> '');
  SetFindNext(FALSE);
end;

procedure TfrmDrawers.ToggleMenuItem(Sender: TObject);
var
  TmpMI: TMenuItem;

begin
  TmpMI := (Sender as TMenuItem);
  TmpMI.Checked := not TmpMI.Checked;
  SetFindNext(FALSE);
  if(pnlTemplateSearch.Visible) then edtSearch.SetFocus;
end;

procedure TfrmDrawers.edtSearchEnter(Sender: TObject);
begin
  btnFind.Default := TRUE;
end;

procedure TfrmDrawers.edtSearchExit(Sender: TObject);
begin
  btnFind.Default := FALSE;
end;

procedure TfrmDrawers.mnuFindTemplatesClick(Sender: TObject);
var
  FindOn: boolean;

begin
  mnuFindTemplates.Checked := not mnuFindTemplates.Checked;
  FindOn := mnuFindTemplates.Checked;
  pnlTemplateSearch.Visible := FindOn;
  if(FindOn) and (FOpenDrawer = odTemplates) then
    edtSearch.SetFocus;
end;

procedure TfrmDrawers.tvTemplatesDragging(Sender: TObject; Node: TTreeNode;
  var CanDrag: Boolean);

begin
  //kt 5/15 original --> if(TTemplate(Node.Data).RealType in [ttDoc, ttGroup]) then
  if assigned(Node.Data) and (TTemplate(Node.Data).RealType in [ttDoc, ttGroup]) then  //kt 5/15
  begin
    FDragNode := Node;
    CanDrag := TRUE;
  end
  else
  begin
    FDragNode := nil;
    CanDrag := FALSE;
  end;
end;

procedure TfrmDrawers.mnuEditTemplatesClick(Sender: TObject);
begin
  EditTemplates(Self);
end;

procedure TfrmDrawers.mnuEditProblemClick(Sender: TObject);
//kt added 6/15
var Node: TTreeNode;
    x, ProbIEN, ProbCategory : string;
begin
  inherited;
  //MessageDlg('Here I can edit problem', mtInformation, [mbOK], 0);
  Node := tvProblems.Selected;
  if not assigned(Node) then exit;
  ProbCategory := ProbNodeCategory(Node);
  if ProbCategory = '' then exit;
  frmFrame.SetActiveTab(CT_PROBLEMS);
  Application.ProcessMessages;  //allow Problems tab to process all it's OnDisplay events etc.
  if PlUser.usViewAct <> ProbCategory then begin
    if ProbCategory = 'I' then begin
      frmProblems.lstProbActsClick(frmProblems.mnuViewInactive);
    end else if ProbCategory = 'R' then begin
      frmProblems.lstProbActsClick(frmProblems.mnuViewRemoved);
    end else begin
      frmProblems.lstProbActsClick(frmProblems.mnuViewActive);
    end;
  end;
  x := TORTreeNode(Node).StringData;
  ProbIEN := piece(x, '^',4);
  frmProblems.SelectProblem(ProbIEN, true);
  frmProblems.ActionAfterEditClose := 'RELOAD^Notes-Problems;TAB^' + IntToStr(CT_NOTES);
  frmProblems.lstProbActsClick(frmProblems.mnuActChange);
end;

procedure TfrmDrawers.mnuNewProblemClick(Sender: TObject);
//kt added 6/15
begin
  inherited;
  frmFrame.SetActiveTab(CT_PROBLEMS);
  if PlPt = nil then begin
    frmProblems.LoadProblems;
  end;
  frmProblems.lstProbActsClick(frmProblems.mnuActNew);
  //After user closed edit form, an event will fire for additional handling.
end;

procedure TfrmDrawers.mnuNewTemplateClick(Sender: TObject);
begin
  EditTemplates(Self, TRUE);
end;

procedure TfrmDrawers.FormCreate(Sender: TObject);
begin
  dmodShared.AddDrawerTree(Self);
  FHasPersonalTemplates := FALSE;
end;

procedure TfrmDrawers.ExternalReloadTemplates;
begin
  if(FOpenToNode = '') and (assigned(tvTemplates.Selected)) then
    FOpenToNode := tvTemplates.GetNodeID(TORTreeNode(tvTemplates.Selected),1,';');
  tvTemplates.Items.Clear;
  FHasPersonalTemplates := FALSE;
  FEmptyNodeCount := 0;
  ReloadTemplates;
end;

procedure TfrmDrawers.fldAccessRemindersInstructionsQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if FOpenDrawer = odReminders then
    Text := 'to close'
  else
    Text := 'to open';
  Text := Text + ' drawer press space bar';
end;

procedure TfrmDrawers.fldAccessRemindersStateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if FOpenDrawer = odReminders then
    Text := ', Drawer Open'
  else
    Text := ', Drawer Closed';
end;

procedure TfrmDrawers.fldAccessTemplatesInstructionsQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if FOpenDrawer = odTemplates then
    Text := 'to close'
  else
    Text := 'to open';
  Text := Text + ' drawer press space bar';
end;

procedure TfrmDrawers.fldAccessTemplatesStateQuery(Sender: TObject;
  var Text: string);
begin
  if FOpenDrawer = odTemplates then
    Text := ', Drawer Open'
  else
    Text := ', Drawer Closed';
end;

procedure TfrmDrawers.DisplayDrawers(Show: Boolean);
begin
  DisplayDrawers(Show, [], []);
end;

procedure TfrmDrawers.DisplayDrawers(Show: Boolean; AEnable, ADisplay: TDrawers);
begin
  if(not (csLoading in ComponentState)) then
  begin
    if Show then
    begin
      EnableDrawers(AEnable);
      ShowDrawers(ADisplay);
    end
    else
    begin
      ShowDrawers([]);
    end;
    if(assigned(FSplitter)) then
    begin
      if(Show and (FOpenDrawer <> odNone)) then
        SetSplitterActive(TRUE)
      else
        SetSplitterActive(FALSE);
    end;
  end;
end;

function TfrmDrawers.CanEditTemplates: boolean;
begin
  Result := (UserTemplateAccessLevel in [taAll, taEditor]);
end;

function TfrmDrawers.CanEditShared: boolean;
begin
  Result := (UserTemplateAccessLevel = taEditor);
end;

procedure TfrmDrawers.pnlTemplateSearchResize(Sender: TObject);
begin
  if((cbMatchCase.Width + cbWholeWords.Width) > pnlTemplateSearch.Width) then
    cbWholeWords.Left := cbMatchCase.Width
  else
    cbWholeWords.Left := pnlTemplateSearch.Width - cbWholeWords.Width;
end;

procedure TfrmDrawers.cbFindOptionClick(Sender: TObject);
begin
  SetFindNext(FALSE);
  if(pnlTemplateSearch.Visible) then edtSearch.SetFocus;
end;

procedure TfrmDrawers.mnuCopyProbNameClick(Sender: TObject);
//kt added 10/15
var Node: TTreeNode;
    ProbCategory : string;
begin
  inherited;
  Node := tvProblems.Selected;
  if not assigned(Node) then exit;
  ProbCategory := ProbNodeCategory(Node);
  if ProbCategory = '' then begin
    MessageDlg('Please select a problem first.', mtError, [mbOK], 0);
    exit;
  end;
  Clipboard.AsText := Node.Text;
end;

procedure TfrmDrawers.mnuInsertProbNameClick(Sender: TObject);
//kt added 10/15
var Node: TTreeNode;
    ProbCategory : string;
begin
  inherited;
  Node := tvProblems.Selected;
  if not assigned(Node) then exit;
  ProbCategory := ProbNodeCategory(Node);
  if ProbCategory = '' then begin
    MessageDlg('Please select a problem first.', mtError, [mbOK], 0);
    exit;
  end;
  PutTemplateTextIntoEditControl(Node.Text, Node.Text);
end;

procedure TfrmDrawers.mnuInsertTemplateClick(Sender: TObject);
begin
  if((assigned(tvTemplates.Selected)) and
     (TTemplate(tvTemplates.Selected.Data).RealType in [ttDoc, ttGroup])) then
  InsertText;
end;

procedure TfrmDrawers.SetSplitter(const Value: TSplitter);
begin
  if(FSplitter <> Value) then
  begin
    if(assigned(FSplitter)) then
      FSplitter.OnCanResize := FOldCanResize;
    FSplitter := Value;
    if(assigned(FSplitter)) then
    begin
      FOldCanResize := FSplitter.OnCanResize;
      FSplitter.OnCanResize := SplitterCanResize;
      SetSplitterActive(FSplitterActive);
    end;
  end;
end;

procedure TfrmDrawers.SplitterCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
begin
  Accept := FSplitterActive;
end;

procedure TfrmDrawers.SetSplitterActive(Active: boolean);
begin
  FSplitterActive := Active;
  if(Active) then
  begin
    FSplitter.Cursor := crVSplit;
    FSplitter.ResizeStyle := rsPattern;
  end
  else
  begin
    FSplitter.Cursor := crDefault;
    FSplitter.ResizeStyle := ExtCtrls.rsNone;
  end;
end;

procedure TfrmDrawers.UpdatePersonalTemplates;
var
  NeedPersonal: boolean;
  Node: TTreeNode;

  function FindNode: TTreeNode;
  begin
    Result := tvTemplates.Items.GetFirstNode;
    while assigned(Result) do
    begin
      if(Result.Data = MyTemplate) then exit;
      Result := Result.getNextSibling;
    end;
  end;

begin
  NeedPersonal := (UserTemplateAccessLevel <> taNone);
  if(NeedPersonal <> FHasPersonalTemplates) then
  begin
    if(NeedPersonal) then
    begin
      if(assigned(MyTemplate)) and (MyTemplate.Children in [tcActive, tcBoth]) then
      begin
        AddTemplateNode(MyTemplate);
        FHasPersonalTemplates := TRUE;
        if(assigned(MyTemplate)) then
        begin
          Node := FindNode;
          if(assigned(Node)) then
            Node.MoveTo(nil, naAddFirst);
        end;
      end;
    end
    else
    begin
      if(assigned(MyTemplate)) then
      begin
        Node := FindNode;
        if(assigned(Node)) then Node.Delete;
      end;
      FHasPersonalTemplates := FALSE;
    end;
  end;
end;

procedure TfrmDrawers.RemindersChanged(Sender: TObject);
begin
  inc(FHoldResize);
  try
    if(EnableDrawer(odReminders, (GetReminderStatus <> rsNone))) then
    begin
      BuildReminderTree(tvReminders);
      FOldMouseUp := tvReminders.OnMouseUp;
    end
    else
    begin
      FOldMouseUp := nil;
      tvReminders.PopupMenu := nil;
    end;
    tvReminders.OnMouseUp := tvRemindersMouseUp;
  finally
    dec(FHoldResize);
  end;
end;

procedure TfrmDrawers.ReminderSearch(ReturnData: TStrings; SearchTerm:string);
var Node:TORTreeNode;
    FoundIENS : string;
    ThisIEN:string;
    ParentNode:TORTreeNode;
    DataStr,UpSearchTerm:string;
begin
  if TheOpenDrawer <> odReminders then sbRemindersClick(nil);
  ReturnData.Clear;
  Node := TORTreeNode(tvReminders.Items.GetFirstNode);
  UpSearchTerm := Uppercase(SearchTerm);
  FoundIENS := '-';  //Delimiter
  while Assigned(Node) do
  begin
    if (pos(UpSearchTerm,Uppercase(Node.Text))>0)or(SearchTerm='') then begin
      ParentNode := Node.Parent;
      if ParentNode<>nil then begin
        ThisIEN := piece(Node.StringData,'^',1)+'-';
        if pos(ThisIEN,FoundIENS)<1 then begin
          FoundIENS := FoundIENS+ThisIEN;
          DataStr := inttostr(Node.Index)+';'+Node.Text+'^'+inttostr(ParentNode.Index)+';'+ParentNode.Text;    //Node.StringData;
          ReturnData.Add(DataStr);
        end;  
      end;
    end;
    Node := TORTreeNode(Node.GetNext);
  end;
end;

procedure TfrmDrawers.tvRemindersMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if(Button = mbLeft) and (assigned(tvReminders.Selected)) and
    (htOnItem in tvReminders.GetHitTestInfoAt(X, Y)) then
    ViewReminderDialog(ReminderNode(tvReminders.Selected));
end;

procedure TfrmDrawers.PositionToReminder(Sender: TObject);
var
  Rem: TReminder;

begin
  if(assigned(Sender)) then
  begin
    if(Sender is TReminder) then
    begin
      Rem := TReminder(Sender);
      if(Rem.CurrentNodeID <> '') then
        tvReminders.Selected := tvReminders.FindPieceNode(Rem.CurrentNodeID, 1, IncludeParentID)
      else
      begin
        tvReminders.Selected := tvReminders.FindPieceNode(RemCode + (Sender as TReminder).IEN, 1);
        if(assigned(tvReminders.Selected)) then
          TORTreeNode(tvReminders.Selected).EnsureVisible;
      end;
      Rem.CurrentNodeID := '';
    end;
  end
  else
    tvReminders.Selected := nil;
end;

procedure TfrmDrawers.tvProblemsDblClick(Sender: TObject);
//kt added 6/15
var Node : TTreeNode;
begin
  inherited;
  Node := tvProblems.Selected;
  if IsProblemListNode(Node) then begin
    HandleProblemDblClick(TORtreeNode(Node));
  end;
end;

function TfrmDrawers.NodeHint(ANode: TTreeNode): string;
//kt added 6/15
begin
  result := Format('Node absolute index: %d',[ANode.AbsoluteIndex]) ;
  //Change this to some useful information about problem....
end;

procedure TfrmDrawers.tvProblemsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
//kt added 6/15
var  TV: TTreeView;
     HoverNode: TTreeNode;
     HitTest : THitTests;
begin
  inherited;
    if (Sender is TTreeView) then begin
      TV := TTreeView(Sender);
    end else Exit;
    HoverNode := TV.GetNodeAt(X, Y) ;
    HitTest := TV.GetHitTestInfoAt(X, Y) ;
    if (LastHintNode <> HoverNode) then begin
      Application.CancelHint;
      if (HitTest <= [htOnItem, htOnIcon, htOnLabel, htOnStateIcon]) then begin
        LastHintNode := HoverNode;
        TV.Hint := NodeHint(HoverNode) ;
      end;
    end;
end;

procedure TfrmDrawers.tvRemindersCurListChanged(Sender: TObject;
  Node: TTreeNode);
begin
  if(assigned(FRemNotifyList)) then
    FRemNotifyList.Notify(Node);
end;

procedure TfrmDrawers.NotifyWhenRemTreeChanges(Proc: TNotifyEvent);
begin
  if(not assigned(FRemNotifyList)) then
    FRemNotifyList := TORNotifyList.Create;
  FRemNotifyList.Add(Proc);
end;

procedure TfrmDrawers.RemoveNotifyWhenRemTreeChanges(Proc: TNotifyEvent);
begin
  if(assigned(FRemNotifyList)) then
    FRemNotifyList.Remove(Proc);
end;

function TfrmDrawers.GetAlign: TAlign;
begin
  Result := inherited Align;
end;

procedure TfrmDrawers.SetAlign(const Value: TAlign);
begin
  inherited Align := Value;
  ResizeToVisible;
end;

procedure TfrmDrawers.ResetTemplates;
begin
  FOpenToNode := Piece(GetUserTemplateDefaults, '/', FDefTempPiece);
end;

procedure TfrmDrawers.mnuDefaultClick(Sender: TObject);
var
  NodeID: string;
  UserTempDefNode: string;
begin
  NodeID := tvTemplates.GetNodeID(TORTreeNode(tvTemplates.Selected), 1, ';');
  UserTempDefNode := Piece(GetUserTemplateDefaults, '/', FDefTempPiece);
  if NodeID <> UserTempDefNode then
    SetUserTemplateDefaults(tvTemplates.GetNodeID(TORTreeNode(tvTemplates.Selected), 1, ';'),
                          FDefTempPiece)
  else SetUserTemplateDefaults('', FDefTempPiece);                      
end;

procedure TfrmDrawers.OpenToNode(Path: string = '');
var
  OldInternalHE, OldInternalEX: boolean;

begin
  if(Path <> '') then
    FOpenToNode := PATH;
  if(FOpenToNode <> '') then
  begin
    OldInternalHE := FInternalHiddenExpand;
    OldInternalEX := FInternalExpand;
    try
      FInternalExpand := TRUE;
      FInternalHiddenExpand := FALSE;
      dmodShared.SelectNode(tvTemplates, FOpenToNode, FEmptyNodeCount);
    finally
      FInternalHiddenExpand := OldInternalHE;
      FInternalExpand := OldInternalEX;
    end;
    FOpenToNode := '';
  end;
end;

procedure TfrmDrawers.mnuGotoDefaultClick(Sender: TObject);
begin
  OpenToNode(Piece(GetUserTemplateDefaults, '/', FDefTempPiece));
end;

procedure TfrmDrawers.mnuViewNotesClick(Sender: TObject);
var
  tmpl: TTemplate;
  tmpSL: TStringList;

begin
  if(assigned(tvTemplates.Selected)) then
  begin
    tmpl := TTemplate(tvTemplates.Selected.Data);
    if(tmpl.Description = '') then
      ShowMsg('No notes found for ' + tmpl.PrintName)
    else
    begin
      tmpSL := TStringList.Create;
      try
        tmpSL.Text := tmpl.Description;
        ReportBox(tmpSL, tmpl.PrintName + ' Notes:', TRUE);
      finally
        tmpSL.Free;
      end;
    end;
  end;
end;

procedure TfrmDrawers.mnuCopyTemplateClick(Sender: TObject);
var
  txt: string;
  Template: TTemplate;
  DBControlData : TDBControlData;  //kt 5/16 added

begin
  txt := '';
  if((assigned(tvTemplates.Selected)) and
     (TTemplate(tvTemplates.Selected.Data).RealType in [ttDoc, ttGroup])) and
     (dmodShared.TemplateOK(tvTemplates.Selected.Data)) then
  begin
    Template := TTemplate(tvTemplates.Selected.Data);
    //kt original --> txt := Template.Text;
    txt := GetTemplateText(Template); //kt 5/16
    //kt original --> CheckBoilerplate4Fields(txt, 'Template: ' + Template.PrintName);
    DBControlData := TDBControlData.Create; //kt added
    CheckBoilerplate4Fields(txt, 'Template: ' + Template.PrintName, [], DBControlData);  //kt
    DBControlData.MsgNoSave; //kt 5/16 added
    if txt <> '' then begin
      Clipboard.SetTextBuf(PChar(txt));
      GetScreenReader.Speak('Text Copied to Clip board');
    end;
  end;
  if txt <> '' then begin
    StatusText('Templated Text copied to clipboard.');
  end;
  DBControlData.Free;  //kt 5/16 added
end;

{
function TfrmDrawers.InsertOK(Ask: boolean;): boolean;

  function REOK: boolean;
  begin
    Result := assigned(FRichEditControl) and
              FRichEditControl.Visible and
              FRichEditControl.Parent.Visible;
  end;

begin
  Result := REOK;
  if (not ask) and (not Result) and (assigned(FNewNoteButton)) then
    Result := TRUE
  else
  if ask and (not Result) and assigned(FNewNoteButton) and
     FNewNoteButton.Visible and FNewNoteButton.Enabled then
  begin
    FNewNoteButton.Click;
    Result := REOK;
  end;
end;
}

procedure TfrmDrawers.InsertEmbeddedDlgIntoHTML(Sender: TObject);
//kt added function and entry in popup menu 3/16
var Template: TTemplate;
    //SavedType : TTemplateType;
    Text : string;
begin
  inherited;
  if not HTMLEditActive then begin
    MessageDlg('Can not insert embedded dialog because formatted text editing not active.',
               mtError, [mbOK], 0);
    exit;
  end;
  if not assigned(tvTemplates.Selected) then exit;
  Template := TTemplate(tvTemplates.Selected.Data);
  if not assigned(Template) then exit;
  if not InsertOK(TRUE) then exit;
  if not dmodShared.TemplateOK(Template) then exit;
  //SavedType := Template.RealType;
  //Template.RealType := ttNone;  //this will prevent template from being shown as dialog...
  //kt original --> Text := Template.Text;
  Text := GetTemplateText(Template);
  //Template.RealType := SavedType;
  GLOBAL_HTMLTemplateDialogsMgr.InsertTemplateTextAtSelection(FHtmlEditControl, Text, Template.ID);
  FHtmlEditControl.SetFocus;
end;

function TfrmDrawers.InsertOK(Ask: boolean; TemplateIsHTML : boolean=false): boolean;  //kt 9/11
//kt 9/11 -- Made many mods to function.  Original included above.

  function EditControlOK: boolean;   //kt 8/09 renamed.  Was REOK
  var REOK, HEOK : boolean;
  begin
    REOK := assigned(FRichEditControl) and
            FRichEditControl.Visible and
            FRichEditControl.Parent.Visible and
            FRichEditControl.Parent.Parent.Visible;
    HEOK := assigned(FHtmlEditControl) and
            FHtmlEditControl.Visible and
            TWinControl(FHtmlEditControl).Parent.Visible;

    if TemplateIsHTML then begin
      Result := HEOK;
    end else begin
      Result := HEOK or REOK;
    end;
  end;

var NewButtonOK : boolean;

begin
  Result := EditControlOK;  //kt renamed function.
  NewButtonOK := assigned(FNewNoteButton);
  if (ask = false) and NewButtonOK then begin
    Result := true;
  end else begin
    NewButtonOK := NewButtonOK and FNewNoteButton.Visible and FNewNoteButton.Enabled;
    if (ask = true) and (Result = false) and NewButtonOK then begin
      FNewNoteButton.Click;
      NewButtonOK := FNewNoteButton.Visible and FNewNoteButton.Enabled;  //kt 5/15
      if NewButtonOK then begin  //kt added block 5/15 -- If NEW still OK, then user must have cancelled new note
        Result := false;  Exit;
      end;
      if TemplateIsHTML and Assigned(FHtmlModeSwitcher) then begin
        FHtmlModeSwitcher(TemplateIsHTML, true);
        FHtmlEditControl.MoveCaretToEnd;
      end;
      Result := EditControlOK;  //kt 8/09  Renamed function.
    end;
  end;
end;


procedure TfrmDrawers.mnuViewTemplateIconLegendClick(Sender: TObject);
begin
  ShowIconLegend(ilTemplates);
end;

procedure TfrmDrawers.pnlTemplatesButtonEnter(Sender: TObject);
begin
  with Sender as TPanel do
    if (ControlCount > 0) and (Controls[0] is TSpeedButton) and (TSpeedButton(Controls[0]).Down)
    then
      BevelOuter := bvLowered
    else
      BevelOuter := bvRaised;
end;

procedure TfrmDrawers.pnlTemplatesButtonExit(Sender: TObject);
begin
  with Sender as TPanel do
    BevelOuter := bvNone;
  DisableArrowKeyMove(Sender);
end;

procedure TfrmDrawers.tvRemindersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_RETURN, VK_SPACE:
    begin
      ViewReminderDialog(ReminderNode(tvReminders.Selected));
      Key := 0;
    end;
  end;
end;

procedure TfrmDrawers.tvRemindersNodeCaptioning(Sender: TObject;
  var Caption: String);
var
  StringData: string;
begin
  StringData := (Sender as TORTreeNode).StringData;
  if (Length(StringData) > 0) and (StringData[1] = 'R') then  //Only tag reminder statuses
    case StrToIntDef(Piece(StringData,'^',6 {Due}),-1) of
      0: Caption := Caption + ' -- Applicable';
      1: Caption := Caption + ' -- DUE';
      2: Caption := Caption + ' -- Not Applicable';
      else Caption := Caption + ' -- Not Evaluated';
    end;
end;

procedure TfrmDrawers.DisableArrowKeyMove(Sender: TObject);
var
  CurrPanel : TKeyClickPanel;
begin
  if Sender is TKeyClickPanel then
  begin
    CurrPanel := Sender as TKeyClickPanel;
    If Boolean(Hi(GetKeyState(VK_UP)))
       OR Boolean(Hi(GetKeyState(VK_DOWN)))
       OR Boolean(Hi(GetKeyState(VK_LEFT)))
       OR Boolean(Hi(GetKeyState(VK_RIGHT))) then
    begin
      if Assigned(CurrPanel) then
        CurrPanel.SetFocus;
    end;
  end;
end;

procedure TfrmDrawers.ExpandParentNode(ThisNode:TTreeNode);   //TMG  9/12/19
begin
   dmodShared.ExpandNode(tvTemplates, ThisNode, FEmptyNodeCount);
end;

initialization
  SpecifyFormIsNotADialog(TfrmDrawers);

end.

