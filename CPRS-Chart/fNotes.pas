unit fNotes;

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


{$O-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fHSplit, StdCtrls, ExtCtrls, Menus, ComCtrls, ORCtrls, ORFn, uConst, ORDtTm,
  uPCE, ORClasses, fDrawers, ImgList, rTIU, uTIU, uDocTree, fRptBox, fPrintList,
  fNoteST, ORNet, fNoteSTStop, fBase508Form, VA508AccessibilityManager,
  SHDocVw,                                            //kt 9/11
  buttons,                                            //kt 9/11
  TMGHTML2,Trpcb,                                     //kt 9/11
  WinMsgLog,                                          //kt 8/16
  uNoteComponents,                                    //kt 4/15
  OleCtrls, ToolWin, VA508ImageListLabeler;

type
  TEditModes = (emNone,emText,emHTML);                //kt 9/11
  TViewModes = (vmEdit,vmView,vmText,vmHTML);         //kt 9/11
  TViewModeSet = Set of TViewModes;                   //kt 9/11
const
  vmHTML_MODE : array [false..true] of TViewModes = (vmText,vmHTML); //kt 9/11
  emHTML_MODE : array [false..true] of TEditModes = (emText,emHTML); //kt 9/11


type
  TfrmNotes = class(TfrmHSplit)
    mnuNotes: TMainMenu;
    mnuView: TMenuItem;
    mnuViewChart: TMenuItem;
    mnuChartReports: TMenuItem;
    mnuChartLabs: TMenuItem;
    mnuChartDCSumm: TMenuItem;
    mnuChartCslts: TMenuItem;
    mnuChartNotes: TMenuItem;
    mnuChartOrders: TMenuItem;
    mnuChartMeds: TMenuItem;
    mnuChartProbs: TMenuItem;
    mnuChartCover: TMenuItem;
    Z1: TMenuItem;
    mnuViewDetail: TMenuItem;
    mnuAct: TMenuItem;
    mnuActNew: TMenuItem;
    Z2: TMenuItem;
    mnuActSave: TMenuItem;
    mnuActDelete: TMenuItem;
    mnuActEdit: TMenuItem;
    mnuActSign: TMenuItem;
    mnuActAddend: TMenuItem;
    lblNotes: TOROffsetLabel;
    pnlRead: TPanel;
    lblTitle: TOROffsetLabel;
    memNote: TRichEdit;
    pnlWrite: TPanel;
    memNewNote: TRichEdit;
    Z3: TMenuItem;
    mnuViewAll: TMenuItem;
    mnuViewByAuthor: TMenuItem;
    mnuViewByDate: TMenuItem;
    mnuViewUncosigned: TMenuItem;
    mnuViewUnsigned: TMenuItem;
    mnuActSignList: TMenuItem;
    cmdNewNote: TORAlignButton;
    cmdPCE: TORAlignButton;
    lblSpace1: TLabel;
    popNoteMemo: TPopupMenu;
    popNoteMemoCut: TMenuItem;
    popNoteMemoCopy: TMenuItem;
    popNoteMemoPaste: TMenuItem;
    Z10: TMenuItem;
    popNoteMemoSignList: TMenuItem;
    popNoteMemoDelete: TMenuItem;
    popNoteMemoEdit: TMenuItem;
    popNoteMemoSave: TMenuItem;
    popNoteMemoSign: TMenuItem;
    popNoteList: TPopupMenu;
    popNoteListAll: TMenuItem;
    popNoteListByAuthor: TMenuItem;
    popNoteListByDate: TMenuItem;
    popNoteListUncosigned: TMenuItem;
    popNoteListUnsigned: TMenuItem;
    sptVert: TSplitter;
    memPCEShow: TRichEdit;
    mnuActIdentifyAddlSigners: TMenuItem;
    popNoteMemoAddlSign: TMenuItem;
    Z11: TMenuItem;
    popNoteMemoSpell: TMenuItem;
    popNoteMemoGrammar: TMenuItem;
    mnuViewCustom: TMenuItem;
    N1: TMenuItem;
    mnuViewSaveAsDefault: TMenuItem;
    ReturntoDefault1: TMenuItem;
    pnlDrawers: TPanel;
    lstNotes: TORListBox;
    splDrawers: TSplitter;
    popNoteMemoTemplate: TMenuItem;
    Z12: TMenuItem;
    mnuOptions: TMenuItem;
    mnuEditTemplates: TMenuItem;
    mnuNewTemplate: TMenuItem;
    N2: TMenuItem;
    mnuEditSharedTemplates: TMenuItem;
    mnuNewSharedTemplate: TMenuItem;
    popNoteMemoAddend: TMenuItem;
    pnlFields: TPanel;
    lblNewTitle: TStaticText;
    lblRefDate: TStaticText;
    lblAuthor: TStaticText;
    lblVisit: TStaticText;
    lblCosigner: TStaticText;
    cmdChange: TButton;
    lblSubject: TStaticText;
    txtSubject: TCaptionEdit;
    timAutoSave: TTimer;
    popNoteMemoPaste2: TMenuItem;
    popNoteMemoReformat: TMenuItem;
    Z4: TMenuItem;
    mnuActChange: TMenuItem;
    mnuActLoadBoiler: TMenuItem;
    bvlNewTitle: TBevel;
    popNoteMemoSaveContinue: TMenuItem;
    N3: TMenuItem;
    mnuEditDialgFields: TMenuItem;
    tvNotes: TORTreeView;
    lvNotes: TCaptionListView;
    sptList: TSplitter;
    N4: TMenuItem;
    popNoteListExpandSelected: TMenuItem;
    popNoteListExpandAll: TMenuItem;
    popNoteListCollapseSelected: TMenuItem;
    popNoteListCollapseAll: TMenuItem;
    popNoteListCustom: TMenuItem;
    mnuActDetachFromIDParent: TMenuItem;
    N5: TMenuItem;
    popNoteListDetachFromIDParent: TMenuItem;
    popNoteListAddIDEntry: TMenuItem;
    mnuActAddIDEntry: TMenuItem;
    mnuIconLegend: TMenuItem;
    N6: TMenuItem;
    popNoteMemoFind: TMenuItem;
    dlgFindText: TFindDialog;
    dlgReplaceText: TReplaceDialog;
    popNoteMemoReplace: TMenuItem;
    N7: TMenuItem;
    mnuChartSurgery: TMenuItem;
    mnuActAttachtoIDParent: TMenuItem;
    popNoteListAttachtoIDParent: TMenuItem;
    N8: TMenuItem;
    popNoteMemoPreview: TMenuItem;
    popNoteMemoInsTemplate: TMenuItem;
    popNoteMemoEncounter: TMenuItem;
    mnuSearchForText: TMenuItem;
    popSearchForText: TMenuItem;
    mnuViewInformation: TMenuItem;
    mnuViewDemo: TMenuItem;
    mnuViewVisits: TMenuItem;
    mnuViewPrimaryCare: TMenuItem;
    mnuViewMyHealtheVet: TMenuItem;
    mnuInsurance: TMenuItem;
    mnuViewFlags: TMenuItem;
    mnuViewReminders: TMenuItem;
    mnuViewRemoteData: TMenuItem;
    mnuViewPostings: TMenuItem;
    popNoteMemoViewCslt: TMenuItem;
    mnuEncounter: TMenuItem;
    imgLblNotes: TVA508ImageListLabeler;
    imgLblImages: TVA508ImageListLabeler;
    mnuSearchNotes: TMenuItem;
    popNoteMemoProcess: TMenuItem;
    pnlTop: TPanel;
    popNoteMemoLinkToConsult: TMenuItem;
    btnHideTitle: TSpeedButton;
    btnAddHide: TSpeedButton;
    AddUniversalImage: TMenuItem;
    btnZoomOut: TSpeedButton;
    btnEditZoomIn: TSpeedButton;
    btnEditNormalZoom: TSpeedButton;
    btnEditZoomOut: TSpeedButton;
    mnuQuickSearchTemplates: TMenuItem;
    N9: TMenuItem;
    mnuHideTitle: TMenuItem;
    popAddComponent: TMenuItem;
    pnlHtmlViewer: TPanel;                           //kt 9/11
    pnlTextWrite: TPanel;                            //kt 9/11
    popNoteMemoHTMLFormat: TMenuItem;                //kt 9/11
    pnlHTMLWrite: TPanel;                            //kt 9/11
    pnlHTMLEdit: TPanel;                             //kt 9/11
    ToolBar: TToolBar;                               //kt 9/11
    cbFontNames: TComboBox;                          //kt 9/11
    cbFontSize: TComboBox;                           //kt 9/11
    btnFonts: TSpeedButton;                          //kt 9/11
    btnItalic: TSpeedButton;                         //kt 9/11
    btnBold: TSpeedButton;                           //kt 9/11
    btnUnderline: TSpeedButton;                      //kt 9/11
    btnBullets: TSpeedButton;                        //kt 9/11
    btnNumbers: TSpeedButton;                        //kt 9/11
    btnLeftAlign: TSpeedButton;                      //kt 9/11
    btnCenterAlign: TSpeedButton;                    //kt 9/11
    btnRightAlign: TSpeedButton;                     //kt 9/11
    btnMoreIndent: TSpeedButton;                     //kt 9/11
    btnLessIndent: TSpeedButton;                     //kt 9/11
    btnTextColor: TSpeedButton;                      //kt 9/11
    btnBackColor: TSpeedButton;                      //kt 9/11
    btnImage: TSpeedButton;                          //kt 9/11
    popupAddImage: TPopupMenu;                       //kt 9/11
    mnuSelectExistingImage: TMenuItem;               //kt 9/11
    mnuAddNewImage: TMenuItem;                       //kt 9/11
    pnlSort: TPanel;	                               //kt 3/14
    btnSortAuthor: TSpeedButton;                     //kt 3/14
    btnSortLocation: TSpeedButton;                   //kt 3/14
    btnSortTitle: TSpeedButton;                      //kt 3/14
    btnSortDate: TSpeedButton;                       //kt 3/14
    btnSortNone: TSpeedButton;                       //kt 3/14
    pnlHtmlView: TPanel;                             //kt 6/14
    lblZoom: TLabel;                                 //kt 6/14
    btnZoomIn: TSpeedButton;                         //kt 6/14
    btnZoomNormal: TSpeedButton;                     //kt 6/14
    pnlVewToolBar: TPanel;                           //kt
    btnDelete: TSpeedButton;                         //kt
    popNoteMemoViewHTMLSource: TMenuItem;            //kt
    popEditEncounterElementsMenu: TPopupMenu;        //kt
    popEditEncounterElements: TMenuItem;
    btnSearchNotes: TSpeedButton;
    ViewWindowsMessages1: TMenuItem;
    btnSave: TBitBtn;
    btnAdminDocs: TSpeedButton;
    procedure btnAdminDocsClick(Sender: TObject);
    procedure chkHideAdminClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure ViewWindowsMessages1Click(Sender: TObject);
    procedure popEditEncounterElementsClick(Sender: TObject);   //kt added 5/16/16
    procedure popNoteMemoViewHTMLSourceClick(Sender: TObject);  //kt added 3/16
    procedure btnEditZoomOutClick(Sender: TObject);
    procedure btnEditZoomNormalClick(Sender: TObject);
    procedure btnEditZoomInClick(Sender: TObject);
    procedure tvNotesCustomDraw(Sender: TCustomTreeView; const ARect: TRect; var DefaultDraw: Boolean);
    procedure tvNotesCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);  //kt 6/15
    procedure popAddComponentClick(Sender: TObject);
    procedure mnuHideTitleClick(Sender: TObject);
    procedure mnuQuickSearchTemplatesClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomNormalClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure AddUniversalImageClick(Sender: TObject);
    procedure btnAddHideClick(Sender: TObject);
    procedure btnHideTitleClick(Sender: TObject);
    procedure popNoteMemoProcessClick(Sender: TObject);
    procedure mnuChartTabClick(Sender: TObject);
    procedure lstNotesClick(Sender: TObject);
    procedure pnlRightResize(Sender: TObject);
    procedure cmdNewNoteClick(Sender: TObject);
    procedure mnuActNewClick(Sender: TObject);
    procedure mnuActAddIDEntryClick(Sender: TObject);
    procedure mnuActSaveClick(Sender: TObject);
    procedure mnuViewClick(Sender: TObject);
    procedure mnuActAddendClick(Sender: TObject);
    procedure mnuActDetachFromIDParentClick(Sender: TObject);
    procedure mnuActSignListClick(Sender: TObject);
    procedure mnuActDeleteClick(Sender: TObject);
    procedure mnuActEditClick(Sender: TObject);
    procedure mnuActSignClick(Sender: TObject);
    procedure cmdPCEClick(Sender: TObject);
    procedure popNoteMemoCutClick(Sender: TObject);
    procedure popNoteMemoCopyClick(Sender: TObject);
    procedure popNoteMemoPasteClick(Sender: TObject);
    procedure popNoteMemoPopup(Sender: TObject);
    procedure pnlWriteResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuViewDetailClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuActIdentifyAddlSignersClick(Sender: TObject);
    procedure popNoteMemoAddlSignClick(Sender: TObject);
    procedure popNoteMemoSpellClick(Sender: TObject);
    procedure popNoteMemoGrammarClick(Sender: TObject);
    procedure mnuViewSaveAsDefaultClick(Sender: TObject);
    procedure mnuViewReturntoDefaultClick(Sender: TObject);
    procedure popNoteMemoTemplateClick(Sender: TObject);
    procedure mnuEditTemplatesClick(Sender: TObject);
    procedure mnuNewTemplateClick(Sender: TObject);
    procedure mnuEditSharedTemplatesClick(Sender: TObject);
    procedure mnuNewSharedTemplateClick(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdChangeClick(Sender: TObject);
    procedure pnlFieldsResize(Sender: TObject);
    procedure timAutoSaveTimer(Sender: TObject);
    procedure memNewNoteChange(Sender: TObject);
    procedure popNoteMemoReformatClick(Sender: TObject);
    procedure mnuActChangeClick(Sender: TObject);
    procedure mnuActLoadBoilerClick(Sender: TObject);
    procedure popNoteMemoSaveContinueClick(Sender: TObject);
    procedure mnuEditDialgFieldsClick(Sender: TObject);
    procedure tvNotesChange(Sender: TObject; Node: TTreeNode);
    procedure tvNotesClick(Sender: TObject);
    procedure tvNotesCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvNotesExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvNotesStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure tvNotesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvNotesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvNotesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvNotesCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lvNotesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure popNoteListExpandAllClick(Sender: TObject);
    procedure popNoteListCollapseAllClick(Sender: TObject);
    procedure popNoteListExpandSelectedClick(Sender: TObject);
    procedure popNoteListCollapseSelectedClick(Sender: TObject);
    procedure popNoteListPopup(Sender: TObject);
    procedure lvNotesResize(Sender: TObject);
    procedure mnuIconLegendClick(Sender: TObject);
    procedure popNoteMemoFindClick(Sender: TObject);
    procedure dlgFindTextFind(Sender: TObject);
    procedure popNoteMemoReplaceClick(Sender: TObject);
    procedure dlgReplaceTextReplace(Sender: TObject);
    procedure dlgReplaceTextFind(Sender: TObject);
    procedure mnuActAttachtoIDParentClick(Sender: TObject);
    procedure memNewNoteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sptHorzCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure popNoteMemoInsTemplateClick(Sender: TObject);
    procedure popNoteMemoPreviewClick(Sender: TObject);
    procedure tvNotesExit(Sender: TObject);
    procedure pnlReadExit(Sender: TObject);
    procedure cmdNewNoteExit(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure memNewNoteKeyPress(Sender: TObject; var Key: Char);
    procedure memNewNoteKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memPCEShowExit(Sender: TObject);
    procedure cmdChangeExit(Sender: TObject);
    procedure cmdPCEExit(Sender: TObject);
    procedure ViewInfo(Sender: TObject);
    procedure mnuViewInformationClick(Sender: TObject);
    procedure popNoteMemoViewCsltClick(Sender: TObject);
    procedure btnBackColorClick(Sender: TObject);                      //kt 9/11
    procedure btnBoldClick(Sender: TObject);                           //kt 9/11
    procedure btnBulletsClick(Sender: TObject);                        //kt 9/11
    procedure btnCenterAlignClick(Sender: TObject);                    //kt 9/11
    procedure btnFontsClick(Sender: TObject);                          //kt 9/11
    procedure btnItalicClick(Sender: TObject);                         //kt 9/11
    procedure btnLeftAlignClick(Sender: TObject);                      //kt 9/11
    procedure btnLessIndentClick(Sender: TObject);                     //kt 9/11
    procedure btnMoreIndentClick(Sender: TObject);                     //kt 9/11
    procedure btnNumbersClick(Sender: TObject);                        //kt 9/11
    procedure btnRightAlignClick(Sender: TObject);                     //kt 9/11
    procedure btnTextColorClick(Sender: TObject);                      //kt 9/11
    procedure btnUnderlineClick(Sender: TObject);                      //kt 9/11
    procedure cbFontNamesChange(Sender: TObject);                      //kt 9/11
    procedure cbFontSizeChange(Sender: TObject);                       //kt 9/11
    procedure btnImageClick(Sender: TObject);                          //kt 9/11
    procedure popNoteMemoHTMLFormatClick(Sender: TObject);             //kt 9/11
    procedure mnuAddNewImageClick(Sender: TObject);                    //kt 9/11
    procedure mnuSelectExistingImageClick(Sender: TObject);            //kt 9/11
    procedure mnuSearchNotesClick(Sender: TObject);                    //kt 9/11
    procedure popNoteMemoLinkToConsultClick(Sender: TObject);          //kt 3/14
    procedure btnSortDateClick(Sender: TObject);                       //kt 3/14
    procedure btnSortNoneClick(Sender: TObject);                       //kt 3/14
    procedure btnSortLocationClick(Sender: TObject);                   //kt 3/14
    procedure btnSortAuthorClick(Sender: TObject);                     //kt 3/14
    procedure btnSortTitleClick(Sender: TObject);                      //kt 3/14
    procedure lblNotesClick(Sender: TObject);                          //kt 5/14
    procedure tvNotesDblClick(Sender: TObject);                        //kt 4/15
    procedure DoDeleteDocument(DataString : string; ItemIndex : integer;
                             NoPrompt : boolean = false);              //kt 5/15
    function DeleteNodeAndDocAndComps(ANode : TORTreeNode) : boolean;  //kt 5/15
  private
    FNavigatingTab : Boolean; //Currently Using tab to navigate
    FEditingIndex: Integer;                      // index of note being currently edited
    FChanged: Boolean;                           // true if any text has changed in the note
    FEditCtrl: TCustomEdit;
    FSilent: Boolean;
    FCurrentContext: TTIUContext;
    FDefaultContext: TTIUContext;
    FOrderID: string;
    FImageFlag: TBitmap;
    FEditNote: TEditNoteRec;
    FVerifyNoteTitle: Integer;
    FDocList: TStringList;
    FConfirmed: boolean;
    FLastNoteID: string;
    FNewIDChild: boolean;
    FEditingNotePCEObj: boolean;
    FDeleted: boolean;
    FOldFramePnlPatientExit: TNotifyEvent;
    FOldDrawerPnlTemplatesButtonExit: TNotifyEvent;
    FOldDrawerPnlEncounterButtonExit: TNotifyEvent;
    FOldDrawerEdtSearchExit: TNotifyEvent;
    FStarting: boolean;
    //9/28/15 frmSearchStop: TfrmSearchStop;                  //kt added 9/25/15
    FViewNote : TStringList;                        //kt 9/11
    FWarmedUp : boolean;                            //kt 9/11
    LastAuthor: Int64;                              //kt 9/11
    LastAuthorName : string;                        //kt 9/11
    FHTMLEditMode : TEditModes;                     //kt 9/11 This is the mode of the note being edited (even if not actively displayed)
    FViewMode : TViewModeSet;                       //kt 9/11 This is the status of the display
    FSortBtnGroupBy : string;                       //kt 3/14
    FSortBtnGroupManualChange : boolean;            //kt 3/14
    FNotesToHide : TStringList;                     //kt 5/14
    FHideTitleBusy : boolean;                       //kt 5/14
    //FHTMLZoomValue : integer;                     //kt 6/14 NOTE: 100 is normal
    TVDblClickPending : boolean;                    //kt 5/15
    TVChangePending : boolean;                      //kt 5/15
    TMGDebugEditLines : boolean;                    //kt 4/16
    FDesiredPCEInitialPageEditIndex : byte;         //kt 5/16
    frmWinMessageLog: TfrmWinMessageLog;            //kt 8/16 -- debugging tool
    clTMGHighlight : TColor;                        //elh   8/4/16
    boolAutosaving : Boolean;                       //elh  11/18/16
    procedure HandleInsertDate(Sender: TObject);    //kt
    procedure HandleHTMLObjPaste(Sender : TObject; var AllowPaste : boolean); //kt 8/16
    function GetClipHTMLText(var szText:string):Boolean;
    function SetClipText(szText:string):Boolean;
    procedure frmFramePnlPatientExit(Sender: TObject);
    procedure frmDrawerPnlTemplatesButtonExit(Sender: TObject);
    procedure frmDrawerPnlEncounterButtonExit(Sender: TObject);
    procedure frmDrawerEdtSearchExit(Sender: TObject);
    procedure ClearEditControls;
    procedure DoAutoSave(Suppress: integer = 1);
    function GetTitleText(AnIndex: Integer): string;
    procedure InsertAddendum;
    procedure InsertNewNote(IsIDChild: boolean; AnIDParent: integer);
    function LacksRequiredForCreate: Boolean;
    procedure LoadForEdit;
    function LockConsultRequest(AConsult: Integer): Boolean;
    function LockConsultRequestAndNote(AnIEN: Int64): Boolean;
    procedure RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
    procedure SaveEditedNote(var Saved: Boolean);
    procedure SaveCurrentNote(var Saved: Boolean);
    procedure SetEditingIndex(const Value: Integer);
    procedure SetSubjectVisible(ShouldShow: Boolean);
    procedure ShowPCEControls(ShouldShow: Boolean);
    function StartNewEdit(NewNoteType: integer): Boolean;
    procedure UnlockConsultRequest(ANote: Int64; AConsult: Integer = 0);
    procedure ProcessNotifications;
    procedure SetViewContext(AContext: TTIUContext);
    property EditingIndex: Integer read FEditingIndex write SetEditingIndex;
    function GetDrawers: TFrmDrawers;
    function CanFinishReminder: boolean;
    procedure DisplayPCE;
    function VerifyNoteTitle: Boolean;
    //  added for treeview
    //moved to public  procedure LoadNotes;
    //moved to public procedure UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
    procedure  EnableDisableIDNotes;
    procedure ShowPCEButtons(Editing: boolean);
    procedure DoAttachIDChild(AChild, AParent: TORTreeNode);
    function SetNoteTreeLabel(AContext: TTIUContext): string;
    procedure UpdateNoteAuthor(DocInfo: string);
    procedure SetHTMLEditMode(HTMLEditMode : boolean; Quiet : Boolean=false);      //kt 9/11
    procedure ToggleHTMLEditMode;                                                  //kt 9/11
    procedure BroadcastImages(Note: TStrings);                                     //kt 9/11
    procedure ProperRepaint(Editing : Boolean);                                    //kt 9/11
    procedure SetEditorFocus;                                                      //kt 9/11
    function  EditorHasText : boolean;                                             //kt 9/11
    procedure InsertNamedImage(FName: string);                                     //kt 9/11
    function HTMLResize(ImageFName:string) : string;                               //kt 9/11
    function ProcessNote(Lines : TStrings;NoteIEN: String): TStrings;              //kt 4/13
    procedure SortBtnGroupClick(GroupBy : string);                                 //kt 3/14
    procedure SetSortBtnGroupDisplay(GroupBy : string);                            //kt 3/14
    procedure DoHideTitle;                                                         //kt 5/14
    procedure FilterTitlesForHidden(TitlesList : TStringList);                     //kt 5/14
    procedure FilterTitlesForAdmin(TitlesList : TStringList);                      //kt 1/24/17
    procedure ResetHideButton;                                                     //kt 5/14
    //procedure SetZoom(Pct : integer);                                            //kt 6/14
    procedure AutoEditCurrent;                                                     //kt 5/15
    function  ChildDepth(AParent, Node : TORTreeNode) : integer;                   //kt 5/15
    function IsChildOfUnsigned(Node : TORTreeNode;                                 //kt 5/15
                      UnsignedDocsNode: TORTreeNode = nil) : boolean; overload;    //kt 5/15
    function IsChildOfUnsigned(IEN: int64;                                         //kt 5/15
                      UnsignedDocsNode: TORTreeNode = nil) : boolean; overload;    //kt 5/15
    function HasComponents(Node : TORTreeNode) : boolean; overload;                //kt 5/15
    function HasComponents(IEN: int64) : boolean; overload;                        //kt 5/15
    procedure TVNotesChangeForEdit(Node : TTreeNode);                              //kt 5/15
    function InsertComponent(ParentData : string; Subject : string;
                             Lines : TStrings = nil) : string;                     //kt 5/15
    function InsertChildDoc(DocumentType : integer;
                            ParentData : string; DocSubject : string =  '';
                            Lines : TStrings = nil) : string;                      //kt 5/15
    function GetEditorHTMLText : string;                                           //kt 3/16
  public
    HtmlEditor : THtmlObj;                                                         //kt 9//11
    HtmlViewer : THtmlObj;                                                         //kt 9/11
    TMGForceSaveSwitchEdit : boolean;                                              //kt 4/17/15
    procedure UpdateTreeView(DocList: TStringList; Tree: TORTreeView);             //kt moved from private 5/15
    procedure ReloadNotes;                                                         //kt added 4/15
    function AllowSignature(): Boolean;                                              //VEFA 2/8/15
    //procedure TMG_CMDialogKey(var AMessage: TMessage); message CM_DIALOGKEY;       //kt 9/2016
    procedure LoadNotes;                                                           //TMG moved from Private  2/17
    function ActiveEditOf(AnIEN: Int64; ARequest: integer): Boolean;
    function AllowContextChange(var WhyNot: string): Boolean; override;
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure RequestPrint; override;
    procedure RequestMultiplePrint(AForm: TfrmPrintList);
    procedure SetFontSize(NewFontSize: Integer); override;
    procedure SaveSignItem(const ItemID, ESCode: string);
    procedure AssignRemForm;
    property  OrderID: string read FOrderID;
    procedure LstNotesToPrint;
    procedure UpdateFormForInput;
    procedure RefreshImages();
    function  ActiveEditIEN : Int64;                                               //kt 9/11
    function  GetCurrentNoteIEN : string;                                          //kt 6/16
    procedure SetDisplayToHTMLvsText(Mode :TViewModeSet; Lines : TStrings; ActivateOnly : boolean=False); //kt 9/11
    property  ViewMode :TViewModeSet read FViewMode;                               //kt 9/11
    constructor Create(AOwner: TComponent); override;                              //kt 9/11
    destructor Destroy; override;                                                  //kt 9/11
    procedure ExternalSign;                                                        //kt 9/11
    function  GetInsertHTMLName(Name: string): string;                             //kt 9/11
    function  GetNamedTemplateImageHTML(Name: string): string;                     //kt 9/11
    procedure ChangeToNote(IEN : String; ADFN : String = '-1');                    //kt 9/11
    function  HandleMacro(MacroName : string) : string;                            //kt 10/14
    function  ResolveMacro(MacroName: string; Lines : TStrings): string;           //kt 10/14
    function  GetNodeByIEN(ATree : TORTreeView; IEN:String): TORTreeNode;          //kt 5/15
    procedure AddAddendum;                                                         //kt 4/15
    function  AddComponent(ParentData : string; Subject : string = '';
                          Lines : TStrings = nil) : string;                        //kt 4/15
    function AddComponentAndSelect(ParentData : string; Subject : string = '';
                                   Lines : TStrings = nil) : string;               //kt 5/15
    procedure ContextChangeCancelled; override;                                    //kt 4/15
    function tvIndexOfIEN(IEN : string) : integer;                                 //kt 4/15
    function tvIndexOfNode(Node : TORTreeNode) : integer;                          //kt 4/15
    procedure IdentifyAddlSigners(NoteIEN : int64; ARefDate: TFMDateTime);         //kt 2/17
  published
    property Drawers: TFrmDrawers read GetDrawers; // Keep Drawers published
    property HTMLEditMode: TEditModes read FHTMLEditMode;
  end;

var
  frmNotes: TfrmNotes;
  SearchTextStopFlag: Boolean;   // Text Search CQ: HDS00002856
  TMGForcePlainTextEditMode: boolean;  //kt 12/27/12



implementation

{$R *.DFM}

uses fFrame, fVisit, fEncnt, rCore, uCore, fNoteBA, fNoteBD, fSignItem, fEncounterFrame,
     rPCE, Clipbrd, fNoteCslt, fNotePrt, rVitals, fAddlSigners, fNoteDR, fConsults, uSpell,
     fTIUView, fTemplateEditor, uReminders, fReminderDialog, uOrders, rConsults, fReminderTree,
     fNoteProps, fNotesBP, fTemplateFieldEditor, dShared, rTemplates,
     FIconLegend, fPCEEdit, fNoteIDParents, rSurgery, uSurgery, uTemplates,
     fOptionsNotes, fImagePickExisting, fImagesMultiUse, StrUtils, uHTMLTools, fMemoEdit, fTMGPrintList , //kt
     fUploadImages, fPtDocSearch, uTMGOptions, fImages, fConsultLink, uTMGUtil, uHTMLTemplateFields,  //kt
     fTemplateDialog, DateUtils, uInit, uVA508CPRSCompatibility, VA508AccessibilityRouter,
  VAUtils;

const

  NT_NEW_NOTE = -10;                             // Holder IEN for a new note
  NT_ADDENDUM = -20;                             // Holder IEN for a new addendum

  NT_ACT_NEW_NOTE  = 2;
  NT_ACT_ADDENDUM  = 3;
  NT_ACT_EDIT_NOTE = 4;
  NT_ACT_ID_ENTRY  = 5;

  //HTML_ZOOM_STEP = 20;  //e.g. 5% change with each button click  //kt 6/2014
  VIEW_ACTIVATE_ONLY = true; //kt 9/11
  DEFAULT_HTML_EDIT_MODE = 'Edit-in-HTML default mode';       //kt 9/11

  {//kt moved to uConst 2/16/17

  TX_NEED_VISIT = 'A visit is required before creating a new progress note.';
  TX_CREATE_ERR = 'Error Creating Note';
  TX_UPDATE_ERR = 'Error Updating Note';
  TX_NO_NOTE    = 'No progress note is currently being edited';
  TX_SAVE_NOTE  = 'Save Progress Note';
  TX_ADDEND_NO  = 'Cannot make an addendum to a note that is being edited';
  TX_DEL_OK     = CRLF + CRLF + 'Delete this progress note?';
  TX_DEL2_OK    = CRLF + CRLF + 'Delete this note component?';  //kt 5/15
  TX_DEL_AND_COMPS_OK = TX_DEL_OK + CRLF + 'AND' + CRLF + 'Delete all attached note components?';  //kt added 5/15
  TX_DEL_ERR    = 'Unable to Delete Note';
  TX_DEL2_ERR   = 'Unable to Delete Attached Note Components';  //kt 5/15
  TX_BAD_IEN    = 'Invalid record number for document';  //kt 5/15

  TX_SIGN       = 'Sign Note';
  TX_COSIGN     = 'Cosign Note';
  TX_SIGN_ERR   = 'Unable to Sign Note';
//  TX_SCREQD     = 'This progress note title requires the service connected questions to be '+
//                  'answered.  The Encounter form will now be opened.  Please answer all '+
//                 'service connected questions.';
//  TX_SCREQD_T   = 'Response required for SC questions.';
  TX_NONOTE     = 'No progress note is currently selected.';
  TX_NONOTE_CAP = 'No Note Selected';
  TX_NOPRT_NEW  = 'This progress note may not be printed until it is saved';
  TX_NOPRT_NEW_CAP = 'Save Progress Note';
  TX_NO_ALERT   = 'There is insufficient information to process this alert.' + CRLF +
                  'Either the alert has already been deleted, or it contained invalid data.' + CRLF + CRLF +
                  'Click the NEXT button if you wish to continue processing more alerts.';
  TX_CAP_NO_ALERT = 'Unable to Process Alert';
  TX_ORDER_LOCKED = 'This record is locked by an action underway on the Consults tab';
  TC_ORDER_LOCKED = 'Unable to access record';
  TX_NO_ORD_CHG   = 'The note is still associated with the previously selected request.' + CRLF +
                    'Finish the pending action on the consults tab, then try again.';
  TC_NO_ORD_CHG   = 'Locked Consult Request';
  TX_NEW_SAVE1    = 'You are currently editing:' + CRLF + CRLF;
  TX_NEW_SAVE2    = CRLF + CRLF + 'Do you wish to save this note and begin a new one?';
  TX_NEW_SAVE3    = CRLF + CRLF + 'Do you wish to save this note and begin a new addendum?';
  TX_NEW_SAVE4    = CRLF + CRLF + 'Do you wish to save this note and edit the one selected?';
  TX_NEW_SAVE5    = CRLF + CRLF + 'Do you wish to save this note and begin a new Interdisciplinary entry?';
  TC_NEW_SAVE2    = 'Create New Note';
  TC_NEW_SAVE3    = 'Create New Addendum';
  TC_NEW_SAVE4    = 'Edit Different Note';
  TC_NEW_SAVE5    = 'Create New Interdisciplinary Entry';
  TX_EMPTY_NOTE   = CRLF + CRLF + 'This note contains no text and will not be saved.' + CRLF +
                    'Do you wish to delete this note?';
  TC_EMPTY_NOTE   = 'Empty Note';
  TX_EMPTY_NOTE1   = 'This note contains no text and can not be signed.';
  TC_NO_LOCK      = 'Unable to Lock Note';
  TX_ABSAVE       = 'It appears the session terminated abnormally when this' + CRLF +
                    'note was last edited. Some text may not have been saved.' + CRLF + CRLF +
                    'Do you wish to continue and sign the note?';
  TC_ABSAVE       = 'Possible Missing Text';
  TX_NO_BOIL      = 'There is no boilerplate text associated with this title.';
  TC_NO_BOIL      = 'Load Boilerplate Text';
  TX_BLR_CLEAR    = 'Do you want to clear the previously loaded boilerplate text?';
  TC_BLR_CLEAR    = 'Clear Previous Boilerplate Text';
  TX_DETACH_CNF     = 'Confirm Detachment';
  TX_DETACH_FAILURE = 'Detach failed';
  TX_RETRACT_CAP    = 'Retraction Notice';
  TX_RETRACT        = 'This document will now be RETRACTED.  As Such, it has been removed' +CRLF +
                      ' from public view, and from typical Releases of Information,' +CRLF +
                      ' but will remain indefinitely discoverable to HIMS.' +CRLF +CRLF;
  TX_AUTH_SIGNED    = 'Author has not signed, are you SURE you want to sign.' +CRLF;
  } //kt End of move to uConst 2/16/17
  
{
type
  //CQ8300
  ClipboardData = record
     Text: array[0..255] of char;
  end;
}
var
  uPCEShow, uPCEEdit:  TPCEData;
  ViewContext: Integer;
  frmDrawers: TfrmDrawers;
  uTIUContext: TTIUContext;
  ColumnToSort: Integer;
  ColumnSortForward: Boolean;
  uChanging: Boolean;
  TMGLoadingForEdit : boolean;  //kt added 11/15
  uIDNotesActive: Boolean;
  NoteTotal: string;

constructor TfrmNotes.Create(AOwner: TComponent);
//kt Added function 9/11
begin
  inherited Create(AOwner);
  FViewNote := TStringList.Create;
  TMGLoadingForEdit := false;
end;

destructor TfrmNotes.Destroy;
//kt Added function 9/11
begin
  FViewNote.Free;
  FEditNote.Lines.Free;
  inherited Destroy;
end;
 //NoteTotal: string;


{ TPage common methods --------------------------------------------------------------------- }
procedure TfrmNotes.ContextChangeCancelled; 
//kt added entire function 4/27/15
begin
  LoadNotes;
end;

function TfrmNotes.AllowContextChange(var WhyNot: string): Boolean;
var AfrmTemplateDialog : TfrmTemplateDialog; //kt 3/16
begin
  dlgFindText.CloseDialog;
  Result := inherited AllowContextChange(WhyNot);  // sets result = true
  //kt 3/16 original --> if Assigned(frmTemplateDialog) then
  //kt 3/16 original -->   if Screen.ActiveForm = frmTemplateDialog then
  if Screen.ActiveForm is TfrmTemplateDialog then begin
    AfrmTemplateDialog := TfrmTemplateDialog(Screen.ActiveForm);
    //if (fsModal in frmTemplateDialog.FormState) then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             WhyNot := 'A template in progress will be aborted.  ';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then
               begin
                 FSilent := True;
                 //kt 3/16 original --> frmTemplateDialog.Silent := True;
                 AfrmTemplateDialog.Silent := True;
                 //kt 3/16 original --> frmTemplateDialog.ModalResult := mrCancel;
                 AfrmTemplateDialog.ModalResult := mrCancel;
               end;
           end;
    end;
  end; //kt
  if Assigned(frmRemDlg) then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             WhyNot := 'All current reminder processing information will be discarded.  ';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then
               begin
                 FSilent := True;
                 frmRemDlg.Silent := True;
                 frmRemDlg.btnCancelClick(Self);
               end;
             //agp fix for a problem with reminders not clearing out when switching patients
             if WhyNot = '' then
                begin
                 frmRemDlg.btnCancelClick(Self);
                 if assigned(frmRemDlg) then
                   begin
                     result := false;
                     exit;
                   end;
                end;
           end;
    end;
  if EditingIndex <> -1 then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             //kt if memNewNote.GetTextLen > 0 then
             if EditorHasText then   //kt 9/11
               WhyNot := WhyNot + 'A note in progress will be saved as unsigned.  '
             else
               WhyNot := WhyNot + 'An empty note in progress will be deleted.  ';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then FSilent := True;
             SaveCurrentNote(Result);
           end;
    end;
  if Assigned(frmEncounterFrame) then
    if Screen.ActiveForm = frmEncounterFrame then
    //if (fsModal in frmEncounterFrame.FormState) then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             WhyNot := WhyNot + 'Encounter information being edited will not be saved';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then
               begin
                 FSilent := True;
                 frmEncounterFrame.Abort := False;
                 frmEncounterFrame.Cancel := True;
               end;
           end;
    end;
end;

procedure TfrmNotes.LstNotesToPrint;       
var
  AParentID: string;
  SavedDocID: string;
  Saved: boolean;
  UseCustomTMGMultiPrinting : boolean;
begin
  inherited;
  if not uIDNotesActive then exit;
  if lstNotes.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    LoadNotes;
    with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if tvNotes.Selected = nil then exit;
  UseCustomTMGMultiPrinting := true;  //kt 7/18  Changed to enable new functionality.
  if UseCustomTMGMultiPrinting then begin
    AParentID := fTMGPrintList.SelectAndPrintFromTV(tvNotes, CT_NOTES)  //kt 7/23/18
  end else begin
    AParentID := frmPrintList.SelectParentFromList(tvNotes,CT_NOTES);
  end;
  if AParentID = '' then exit;
  with tvNotes do Selected := FindPieceNode(AParentID, 1, U, Items.GetFirstNode);
end;

procedure TfrmNotes.ClearPtData;
{ clear all controls that contain patient specific information }
begin
  inherited ClearPtData;
  ClearEditControls;
  uChanging := True;
  tvNotes.Items.BeginUpdate;
  KilldocTreeObjects(tvNotes);
  tvNotes.Items.Clear;
  tvNotes.Items.EndUpdate;
  lvNotes.Items.Clear;
  uChanging := False;
  lstNotes.Clear;
  memNote.Clear;
  HTMLViewer.Clear;   //kt 9/11
  HTMLEditor.Clear;   //kt 9/11
  FWarmedUp := false; //kt 9/11
  SetDisplayToHTMLvsText([vmText,vmView], nil, VIEW_ACTIVATE_ONLY); //kt 9/11
  ResetHideButton;    //kt 5/12/14
  GLOBAL_HTMLTemplateDialogsMgr.Clear;  //kt 4/16
  memPCEShow.Clear;
  uPCEShow.Clear;
  uPCEEdit.Clear;
  frmDrawers.ClearPtData;  //kt added 6/15
  frmDrawers.ResetTemplates;
  NoteTotal := sCallV('ORCNOTE GET TOTAL', [Patient.DFN]);
end;

procedure TfrmNotes.DisplayPage;
{ causes page to be visible and conditionally executes initialization code }
begin
  inherited DisplayPage;
  frmFrame.ShowHideChartTabMenus(mnuViewChart);
  frmFrame.mnuFilePrint.Tag := CT_NOTES;
  frmFrame.mnuFilePrint.Enabled := True;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  frmFrame.mnuFilePrintSelectedItems.Enabled := True;
  if InitPage then
  begin
    EnableDisableIDNotes;
    FDefaultContext := GetCurrentTIUContext;
    FCurrentContext := FDefaultContext;
    popNoteMemoSpell.Visible   := SpellCheckAvailable;
    popNoteMemoGrammar.Visible := popNoteMemoSpell.Visible;
    Z11.Visible                := popNoteMemoSpell.Visible;
    timAutoSave.Interval := User.AutoSave * 1000;  // convert seconds to milliseconds
    SetEqualTabStops(memNewNote);
  end;
  // to indent the right margin need to set Paragraph.RightIndent for each paragraph?
  if InitPatient and not (CallingContext = CC_NOTIFICATION) then
    begin
      SetViewContext(FDefaultContext);
    end;
  case CallingContext of
    CC_INIT_PATIENT: if not InitPatient then
                       begin
                         SetViewContext(FDefaultContext);
                       end;
    CC_NOTIFICATION:  ProcessNotifications;
  end;
end;

procedure TfrmNotes.RequestPrint;
var
  Saved: Boolean;
begin
  with lstNotes do
  begin
    if ItemIndex = EditingIndex then
    //if ItemIEN < 0 then
    begin
      SaveCurrentNote(Saved);
      if not Saved then Exit;
    end;
    if ItemIEN > 0 then PrintNote(ItemIEN, MakeNoteDisplayText(Items[ItemIndex])) else
    begin
      if ItemIEN = 0 then InfoBox(TX_NONOTE, TX_NONOTE_CAP, MB_OK);
      if ItemIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
    end;
  end;
end;

{for printing multiple notes}
procedure TfrmNotes.RequestMultiplePrint(AForm: TfrmPrintList);
var
  NoteIEN: int64;
  i: integer;
begin
  with AForm.lbIDParents do
  begin
    for i := 0 to Items.Count - 1 do
     begin
       if Selected[i] then
        begin
         AForm.lbIDParents.ItemIndex := i;
         NoteIEN := ItemIEN;  //StrToInt64def(Piece(TStringList(Items.Objects[i])[0],U,1),0);
         if NoteIEN > 0 then PrintNote(NoteIEN, DisplayText[i], TRUE) else
         begin
           if NoteIEN = 0 then InfoBox(TX_NONOTE, TX_NONOTE_CAP, MB_OK);
           if NoteIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
         end;
        end; {if selected}
     end; {for}
  end; {with}
end;

procedure TfrmNotes.SetFontSize(NewFontSize: Integer);
{ adjusts the font size of any controls that don't have ParentFont = True }
begin
  inherited SetFontSize(NewFontSize);
  frmDrawers.Font.Size  := NewFontSize;
  SetEqualTabStops(memNewNote);
  pnlWriteResize(Self);
end;

procedure TfrmNotes.mnuChartTabClick(Sender: TObject);
{ reroute to Chart Tab menu of the parent form: frmFrame }
begin
  inherited;
  frmFrame.mnuChartTabClick(Sender);
end;

{ General procedures ----------------------------------------------------------------------- }

procedure TfrmNotes.ClearEditControls;
{ resets controls used for entering a new progress note }
begin
  // clear FEditNote (should FEditNote be an object with a clear method?)
  with FEditNote do
  begin
    DocType      := 0;
    Title        := 0;
    TitleName    := '';
    DateTime     := 0;
    Author       := 0;
    AuthorName   := '';
    Cosigner     := 0;
    CosignerName := '';
    Subject      := '';
    Location     := 0;
    LocationName := '';
    PkgIEN       := 0;
    PkgPtr       := '';
    PkgRef       := '';
    NeedCPT      := False;
    Addend       := 0;
    IsComponent  := false;  //kt added 
    {LastCosigner & LastCosignerName aren't cleared because they're used as default for next note.}
    //kt 9/11  Lines        := nil;
    if Assigned (Lines) then Lines.Clear;  //kt 9/11
    PRF_IEN := 0;
    ActionIEN := '';
  end;
  // clear the editing controls (also clear the new labels?)
  txtSubject.Text := '';
  SearchTextStopFlag := false;
  if memNewNote <> nil then memNewNote.Clear; //CQ7012 Added test for nil
  HTMLEditor.Clear;  //kt 9/11
  HTMLViewer.Clear;  //kt 9/11
  FHTMLEditMode := emNone; //kt 9/11
  timAutoSave.Enabled := False;
  // clear the PCE object for editing
  uPCEEdit.Clear;
  // set the tracking variables to initial state
  EditingIndex := -1;
  FChanged := False;
end;

procedure TfrmNotes.ShowPCEControls(ShouldShow: Boolean);
begin
  sptVert.Visible    := ShouldShow;
  memPCEShow.Visible := ShouldShow;
  if(ShouldShow) then
    sptVert.Top := memPCEShow.Top - sptVert.Height;
  if (vmHTML in FViewMode) then begin              //kt 9/11
    HTMLViewer.Invalidate;                         //kt 9/11
  end else begin                                   //kt 9/11
  memNote.Invalidate;
  end;                                             //kt 9/11
  Application.ProcessMessages;                     //kt 5/15
end;

procedure TfrmNotes.DisplayPCE;
{ displays PCE information if appropriate & enables/disabled editing of PCE data }
var
  EnableList, ShowList: TDrawers;
  VitalStr:   TStringlist;
  NoPCE:      boolean;
  ActionSts: TActionRec;
  AnIEN: integer;
begin
  memPCEShow.Clear;
  with lstNotes do if ItemIndex = EditingIndex then
  begin
    with uPCEEdit do
    begin
      AddStrData(memPCEShow.Lines);
      NoPCE := (memPCEShow.Lines.Count = 0);
      VitalStr  := TStringList.create;
      try
        GetVitalsFromDate(VitalStr, uPCEEdit);
        AddVitalData(VitalStr, memPCEShow.Lines);
      finally
        VitalStr.free;
      end;
      ShowPCEButtons(TRUE);
      ShowPCEControls(cmdPCE.Enabled or (memPCEShow.Lines.Count > 0));
      if(NoPCE and memPCEShow.Visible) then
        memPCEShow.Lines.Insert(0, TX_NOPCE);
      memPCEShow.SelStart := 0;

      if(InteractiveRemindersActive) then
      begin
        if(GetReminderStatus = rsNone) then
          EnableList := [odTemplates]
        else
          if FutureEncounter(uPCEEdit) then
            begin
              EnableList := [odTemplates];
              ShowList := [odTemplates];
            end
          else
            begin
              EnableList := [odTemplates, odReminders];
              ShowList := [odTemplates, odReminders];
            end;
      end
      else
      begin
        EnableList := [odTemplates];
        ShowList := [odTemplates];
      end;

      //kt if uTMGOptions.ReadString('SpecialLocation','')='FPG' then begin  //kt added if block 10/7/15
      if AtFPGLoc() then begin  //kt added if block 10/7/15
        ShowList := ShowList + [odProblems]; EnableList := EnableList + [odProblems]; //kt added 6/15
      end;
      frmDrawers.DisplayDrawers(TRUE, EnableList, ShowList);
    end;
  end else
  begin
    ShowPCEButtons(FALSE);
    frmDrawers.DisplayDrawers(TRUE, [odTemplates], [odTemplates]);
    AnIEN := lstNotes.ItemIEN;
    ActOnDocument(ActionSts, AnIEN, 'VIEW');
    if ActionSts.Success then
    begin
      StatusText('Retrieving encounter information...');
      with uPCEShow do
      begin
        NoteDateTime := MakeFMDateTime(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
        PCEForNote(AnIEN, uPCEEdit);
        AddStrData(memPCEShow.Lines);
        NoPCE := (memPCEShow.Lines.Count = 0);
        VitalStr  := TStringList.create;
        try
          GetVitalsFromNote(VitalStr, uPCEShow, AnIEN);
          AddVitalData(VitalStr, memPCEShow.Lines);
        finally
          VitalStr.free;
        end;
        ShowPCEControls(memPCEShow.Lines.Count > 0);
        if(NoPCE and memPCEShow.Visible) then
          memPCEShow.Lines.Insert(0, TX_NOPCE);
        memPCEShow.SelStart := 0;
      end;
      StatusText('');
    end
    else
      ShowPCEControls(FALSE);
  end; {if ItemIndex}
  mnuEncounter.Enabled := cmdPCE.Visible;
end;

{ supporting calls for writing notes }

function TfrmNotes.GetTitleText(AnIndex: Integer): string;
{ returns non-tabbed text for the title of a note given the ItemIndex in lstNotes }
begin
  with lstNotes do
    Result := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(Piece(Items[AnIndex], U, 3))) +
              '  ' + Piece(Items[AnIndex], U, 2) + ', ' + Piece(Items[AnIndex], U, 6) + ', ' +
              Piece(Piece(Items[AnIndex], U, 5), ';', 2)
end;

function TfrmNotes.LacksRequiredForCreate: Boolean;
{ determines if the fields required to create the note are present }
var
  CurTitle: Integer;
begin
  Result := False;
  with FEditNote do
  begin
    if Title <= 0    then Result := True;
    if Author <= 0   then Result := True;
    if DateTime <= 0 then Result := True;
    if IsConsultTitle(Title) and (PkgIEN = 0) then Result := True;
    if IsSurgeryTitle(Title) and (PkgIEN = 0) then Result := True;
    if IsPRFTitle(Title) and (PRF_IEN = 0) and (not DocType = TYP_ADDENDUM) then Result := True;
    if (DocType = TYP_ADDENDUM) then
    begin
      if AskCosignerForDocument(Addend, Author, DateTime) and (Cosigner <= 0) then Result := True;
    end else
    begin
      if Title > 0 then CurTitle := Title else CurTitle := DocType;
      if AskCosignerForTitle(CurTitle, Author, DateTime) and (Cosigner <= 0) then Result := True;
    end;
  end;
end;

procedure TfrmNotes.lblNotesClick(Sender: TObject);
//kt added
begin
  inherited;
  //MessageDlg('Here I could adjust the number of notes shown', mtInformation, [mbOK],0);
  mnuViewClick(mnuViewCustom);
end;

function TfrmNotes.VerifyNoteTitle: Boolean;
const
  VNT_UNKNOWN = 0;
  VNT_NO      = 1;
  VNT_YES     = 2;
var
  AParam: string;
begin
  if FVerifyNoteTitle = VNT_UNKNOWN then begin
    AParam := GetUserParam('ORWOR VERIFY NOTE TITLE');
    if AParam = '1' then FVerifyNoteTitle := VNT_YES else FVerifyNoteTitle := VNT_NO;
  end;
  Result := FVerifyNoteTitle = VNT_YES;
end;

procedure TfrmNotes.SetSubjectVisible(ShouldShow: Boolean);
{ hide/show subject & resize panel accordingly - leave 6 pixel margin above memNewNote }
begin
  if ShouldShow then
  begin
    lblSubject.Visible := True;
    txtSubject.Visible := True;
    pnlFields.Height   := txtSubject.Top + txtSubject.Height + 6;
  end else
  begin
    lblSubject.Visible := False;
    txtSubject.Visible := False;
    pnlFields.Height   := lblVisit.Top + lblVisit.Height + 6;
  end;
end;

{ consult request and note locking }

function TfrmNotes.LockConsultRequest(AConsult: Integer): Boolean;
{ returns true if consult successfully locked }
begin
  // *** I'm not sure about the FOrderID field - if the user is editing one note and
  //     deletes another, FOrderID will be for editing note, then delete note, then null
  Result := True;
  FOrderID := GetConsultOrderIEN(AConsult);
  if (FOrderID <> '') and (FOrderID = frmConsults.OrderID) then
  begin
    InfoBox(TX_ORDER_LOCKED, TC_ORDER_LOCKED, MB_OK);
    Result := False;
    Exit;
  end;
  if (FOrderId <> '') then
    if not OrderCanBeLocked(FOrderID) then Result := False;
  if not Result then FOrderID := '';
end;

function TfrmNotes.LockConsultRequestAndNote(AnIEN: Int64): Boolean;
{ returns true if note and associated request successfully locked }
var
  AConsult: Integer;
  LockMsg, x: string;
begin
  Result := True;
  AConsult := 0;
  if frmConsults.ActiveEditOf(AnIEN) then
    begin
      InfoBox(TX_ORDER_LOCKED, TC_ORDER_LOCKED, MB_OK);
      Result := False;
      Exit;
    end;
    if Changes.Exist(CH_DOC, IntToStr(AnIEN)) then Exit;  // already locked
  // try to lock the consult request first, if there is one
  if IsConsultTitle(TitleForNote(AnIEN)) then
  begin
    x := GetPackageRefForNote(lstNotes.ItemIEN);
    AConsult := StrToIntDef(Piece(x, ';', 1), 0);
    Result := LockConsultRequest(AConsult);
  end;
  // now try to lock the note
  if Result then
  begin
    LockDocument(AnIEN, LockMsg);
    if LockMsg <> '' then
    begin
      Result := False;
      // if can't lock the note, unlock the consult request that was just locked
      if AConsult > 0 then
      begin
        UnlockOrderIfAble(FOrderID);
        FOrderID := '';
      end;
      InfoBox(LockMsg, TC_NO_LOCK, MB_OK);
    end;
  end;
end;

procedure TfrmNotes.UnlockConsultRequest(ANote: Int64; AConsult: Integer = 0);
(*var
  x: string;*)
begin
(*  if (AConsult = 0) and IsConsultTitle(TitleForNote(ANote)) then
    begin
      x := GetPackageRefForNote(ANote);
      AConsult := StrToIntDef(Piece(x, ';', 1), 0);
    end;
  if AConsult = 0 then Exit;*)
  if AConsult = 0 then AConsult := GetConsultIENForNote(ANote);
  if AConsult <= 0 then exit;
  FOrderID := GetConsultOrderIEN(AConsult);
  UnlockOrderIfAble(FOrderID);
  FOrderID := '';
end;

function TfrmNotes.ActiveEditIEN : Int64;
//kt added entire function
begin
  if EditingIndex >= 0 then Result := lstNotes.GetIEN(EditingIndex)
  else Result := 0;
end;

function TfrmNotes.GetCurrentNoteIEN : string;
//kt added entire function   06/16
var SelNode: TORTreeNode;
begin
  SelNode := TORTreeNode(tvNotes.Selected);
  result := piece(SelNode.StringData,U,1);
end;


function TfrmNotes.ActiveEditOf(AnIEN: Int64; ARequest: integer): Boolean;
begin
  Result := False;
  if EditingIndex < 0 then Exit;
  if lstNotes.GetIEN(EditingIndex) = AnIEN then begin
    Result := True;
    Exit;
  end;
  with FEditNote do if (PkgIEN = ARequest) and (PkgPtr = PKG_CONSULTS) then Result := True;
end;

{ create, edit & save notes }

procedure TfrmNotes.InsertNewNote(IsIDChild: boolean; AnIDParent: integer);
{ creates the editing context for a new progress note & inserts stub into top of view list }
var
  EnableAutosave, HaveRequired: Boolean;
  CreatedNote: TCreatedDoc;
  TmpBoilerPlate: TStringList;
  tmpNode: TTreeNode;
  x, WhyNot, DocInfo: string;
  tempPos : integer;            //kt 9/11
  Mode : TViewModeSet;          //kt 9/11
  BoilerplateIsHTML : boolean;  //kt 9/11

begin
  if frmFrame.Timedout then Exit;

  FNewIDChild := IsIDChild;
  EnableAutosave := FALSE;
  TmpBoilerPlate := nil;
  try
    ClearEditControls;
    FEditNote.Lines.Free; //(done d/t full wipe-out on line below}  //kt 9/11
    FillChar(FEditNote, SizeOf(FEditNote), 0);  //v15.7
    FEditNote.Lines := TStringList.Create; //Freed in Destructor    //kt 9/11
    with FEditNote do begin
      DocType      := TYP_PROGRESS_NOTE;
      IsNewNote    := True;
      Title        := DfltNoteTitle;
      TitleName    := DfltNoteTitleName;
      if IsIDChild and (not CanTitleBeIDChild(Title, WhyNot)) then begin
        Title := 0;
        TitleName := '';
      end;
      if IsSurgeryTitle(Title) then begin   // Don't want surgery title sneaking in unchallenged
        Title := 0;
        TitleName := '';
      end;

      //kt if uTMGOptions.ReadString('SpecialLocation','')='FPG' then begin
      if AtFPGLoc() then begin
        DateTime     := Encounter.DateTime;
      end else begin
        DateTime     := FMNow;
      end;
      { Original Method... Changed because Intracare was having issue with
        ADT date being used as note date. Now this change only affects FPG   //elh  10/7/11
      //kt 9/11 DateTime     := FMNow;
      DateTime     := Encounter.DateTime;
      }
      //kt 9/11 -- Begin addition ------------
      if LastAuthor<>0 then begin
        Author       := LastAuthor;
        AuthorName   := LastAuthorName;
      end else begin
        Author       := User.DUZ;
        AuthorName   := User.Name;
      end;
      //kt 9/11 -- End addition --------------
      //kt 9/11 Author       := User.DUZ;
      //kt 9/11 AuthorName   := User.Name;
      Location     := Encounter.Location;
      LocationName := Encounter.LocationName;
      VisitDate    := Encounter.DateTime;
      if IsIDChild then begin
        IDParent   := AnIDParent
      end else begin
        IDParent   := 0;
      end;
      // Cosigner & PkgRef, if needed, will be set by fNoteProps
    end;
    // check to see if interaction necessary to get required fields
    GetUnresolvedConsultsInfo;
    if LacksRequiredForCreate or VerifyNoteTitle or uUnresolvedConsults.UnresolvedConsultsExist
      then HaveRequired := ExecuteNoteProperties(FEditNote, CT_NOTES, IsIDChild, FNewIDChild, '', 0)
      else HaveRequired := True;
    //kt begin addition 9/11 -----------------
    LastAuthor := FEditNote.Author;
    LastAuthorName := FEditNote.AuthorName;
    tempPos := Pos(' - ',LastAuthorName);
    if tempPos>0 then begin  //trim off title, e.g. "Jones,John - Physician
      LastAuthorName:=UpperCase(Trim(MidStr(LastAuthorName,1,tempPos)));
    end;
    //kt end addition 9/11 -----------------
    // lock the consult request if there is a consult
    with FEditNote do if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then HaveRequired := LockConsultRequest(PkgIEN);
    if HaveRequired then begin
      // set up uPCEEdit for entry of new note
      uPCEEdit.UseEncounter := True;
      uPCEEdit.NoteDateTime := FEditNote.DateTime;
      uPCEEdit.PCEForNote(USE_CURRENT_VISITSTR, uPCEShow);
      FEditNote.NeedCPT  := uPCEEdit.CPTRequired;
       // create the note
      PutNewNote(CreatedNote, FEditNote);
      uPCEEdit.NoteIEN := CreatedNote.IEN;
      if CreatedNote.IEN > 0 then LockDocument(CreatedNote.IEN, CreatedNote.ErrorText);
      if CreatedNote.ErrorText = '' then begin
        //x := $$RESOLVE^TIUSRVLO formatted string
        //7348^Note Title^3000913^NERD, YOURA  (N0165)^1329;Rich Vertigan;VERTIGAN,RICH^8E REHAB MED^complete^Adm: 11/05/98;2981105.095547^        ;^^0^^^2
        with FEditNote do begin
          x := IntToStr(CreatedNote.IEN) + U + TitleName + U + FloatToStr(FEditNote.DateTime) + U +
               Patient.Name + U + IntToStr(Author) + ';' + AuthorName + U + LocationName + U + 'new' + U +
               U + U + U + U + U + U + U;
          //Link Note to PRF Action
          if PRF_IEN <> 0 then begin
            if sCallV('TIU LINK TO FLAG', [CreatedNote.IEN,PRF_IEN,ActionIEN,Patient.DFN]) = '0' then begin
              ShowMsg('TIU LINK TO FLAG: FAILED');
            end;
          end;
        end;

        lstNotes.Items.Insert(0, x);
        uChanging := True;
        tvNotes.Items.BeginUpdate;
        if IsIDChild then begin
          tmpNode := tvNotes.FindPieceNode(IntToStr(AnIDParent), 1, U, tvNotes.Items.GetFirstNode);
          tmpNode.ImageIndex := IMG_IDNOTE_OPEN;
          tmpNode.SelectedIndex := IMG_IDNOTE_OPEN;
          tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeNoteTreeObject(x));
          tmpNode.ImageIndex := IMG_ID_CHILD;
          tmpNode.SelectedIndex := IMG_ID_CHILD;
        end else begin
          tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, 'New Note in Progress',
                                                  MakeNoteTreeObject('NEW^New Note in Progress^^^^^^^^^^^%^0'));
          TORTreeNode(tmpNode).StringData := 'NEW^New Note in Progress^^^^^^^^^^^%^0';
          tmpNode.ImageIndex := IMG_TOP_LEVEL;
          tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeNoteTreeObject(x));
          tmpNode.ImageIndex := IMG_SINGLE;
          tmpNode.SelectedIndex := IMG_SINGLE;
        end;
        tmpNode.StateIndex := IMG_NO_IMAGES;
        TORTreeNode(tmpNode).StringData := x;
        tvNotes.Selected := tmpNode;
        tvNotes.Items.EndUpdate;
        uChanging := False;
        Changes.Add(CH_DOC, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
        lstNotes.ItemIndex := 0;
        EditingIndex := 0;
        SetSubjectVisible(AskSubjectForNotes);
        if not assigned(TmpBoilerPlate) then
          TmpBoilerPlate := TStringList.Create;
        LoadBoilerPlate(TmpBoilerPlate, FEditNote.Title);
        FChanged := False;
        cmdChangeClick(Self); // will set captions, sign state for Changes
        if TMGForcePlainTextEditMode then begin   //kt  added block 12/27/12
          // Set in TfrmCarePlan.InsertText
          Mode := [vmEdit] + [vmHTML_MODE[False]];   //kt 12/27/12
          TMGForcePlainTextEditMode := False;
        end else begin
          Mode := [vmEdit] + [vmHTML_MODE[fOptionsNotes.DefaultEditHTMLMode]];   //kt 9/11
        end;
        SetDisplayToHTMLvsText(Mode, nil, VIEW_ACTIVATE_ONLY);                 //kt 9/11
        lstNotesClick(Self);  // will make pnlWrite visible
        if timAutoSave.Interval <> 0 then EnableAutosave := TRUE;
        //kt 9/11 Original --> if txtSubject.Visible then txtSubject.SetFocus else memNewNote.SetFocus;
        if txtSubject.Visible then begin                          //kt 9/11
          txtSubject.SetFocus;                                    //kt 9/11
        end else begin                                            //kt 9/11
          SetEditorFocus; //kt memNewNote.SetFocus;               //kt 9/11
        end;                                                      //kt 9/11
      end else begin
        // if note creation failed or failed to get note lock (both unlikely), unlock consult
        with FEditNote do if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then UnlockConsultRequest(0, PkgIEN);
        InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
        HaveRequired := False;
      end; {if CreatedNote.IEN}
    end; {if HaveRequired}
    if not HaveRequired then begin
      ClearEditControls;
      ShowPCEButtons(False);
    end;
  finally
    if assigned(TmpBoilerPlate) then begin  //will not be true if HaveRequired=false
      DocInfo := MakeXMLParamTIU(IntToStr(CreatedNote.IEN), FEditNote);
      ExecuteTemplateOrBoilerPlate(TmpBoilerPlate, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
      //kt QuickCopyWith508Msg(TmpBoilerPlate, memNewNote);
      BoilerplateIsHTML := uHTMLTools.IsHTML(TmpBoilerPlate.Text);    //kt 9/11
      FEditNote.Lines.Assign(TmpBoilerPlate);                         //kt 9/11
      if not ((vmHTML in FViewMode)) and BoilerplateIsHTML then begin //kt 9/11
        FViewMode := FViewMode - [vmText] + [vmHTML];                 //kt 9/11
      end;                                                            //kt 9/11
      SetDisplayToHTMLvsText(FViewMode,FEditNote.Lines);              //kt 9/11
      ResolveEmbeddedTemplates(GetDrawers);                           //kt 6/16
      if (vmHTML in FViewMode) then begin                             //kt 9/11
        HtmlEditor.MoveCaretToEnd;                                    //kt 9/11
        Application.ProcessMessages;                                  //kt 9/11
      end;                                                            //kt 9/11
      UpdateNoteAuthor(DocInfo);
      TmpBoilerPlate.Free;
    end;
    if EnableAutosave then begin // Don't enable autosave until after dialog fields have been resolved
      timAutoSave.Enabled := True;
    end;
  end;
  frmNotes.pnlWriteResize(Self);
  if assigned(tvNotes.Selected) then begin   //kt added this block 3/21/16
    tvNotesChange(self, tvNotes.Selected);  //prevents view being left in blank state (nothing shown)
  end;
end;

procedure TfrmNotes.SetEditorFocus;
//kt 9/11 added function
begin
  if frmFrame.ActiveTab <> CT_NOTES then exit;
  try
    if (vmHTML in FViewMode) then begin  //kt 9/11
      HtmlEditor.SetFocus;               //kt 9/11
    end else begin                       //kt 9/11
      memNewNote.SetFocus;
    end;                                 //kt 9/11
  except
    on E: Exception do begin
      // ignore error.  Info in E
    end;
  end;
end;

function TfrmNotes.InsertComponent(ParentData : string; Subject : string; Lines : TStrings = nil) : string;
//kt added
//ParentData: ParentIEN8925^ParentTitle^.... (only first 2 pieces are used)
//Result: returns datastring (IEN is piece#1) of added component.  //kt added
begin
  Result := InsertChildDoc(TYP_COMPONENT, ParentData, Subject, Lines);
end;

procedure TfrmNotes.InsertAddendum;
// sets up fields of pnlWrite to write an addendum for the selected note
{
const
  AS_ADDENDUM = True;
  IS_ID_CHILD = False;
var
  HaveRequired: Boolean;
  CreatedNote: TCreatedDoc;
  tmpNode: TTreeNode;
  x: string;
  Mode : TViewModeSet;          //kt 4/14
}
begin
  InsertChildDoc(TYP_ADDENDUM, lstNotes.Items[lstNotes.ItemIndex]);
  {  //kt moved to InsertChildDoc
  ClearEditControls;
  with FEditNote do
  begin
    DocType      := TYP_ADDENDUM;
    IsNewNote    := False;
    Title        := TitleForNote(lstNotes.ItemIEN);
    TitleName    := Piece(lstNotes.Items[lstNotes.ItemIndex], U, 2);
    Subject      := DocSubject;  //kt added
    if Copy(TitleName,1,1) = '+' then TitleName := Copy(TitleName, 3, 199);
    DateTime     := FMNow;
    Author       := User.DUZ;
    AuthorName   := User.Name;
    x            := GetPackageRefForNote(lstNotes.ItemIEN);
    if Piece(x, U, 1) <> '-1' then
      begin
        PkgRef       := GetPackageRefForNote(lstNotes.ItemIEN);
        PkgIEN       := StrToIntDef(Piece(PkgRef, ';', 1), 0);
        PkgPtr       := Piece(PkgRef, ';', 2);
      end;
    Addend       := lstNotes.ItemIEN;
    //Lines        := memNewNote.Lines;
    // Cosigner, if needed, will be set by fNoteProps
    // Location info will be set after the encounter is loaded
  end;
  // check to see if interaction necessary to get required fields
  if LacksRequiredForCreate
    then HaveRequired := ExecuteNoteProperties(FEditNote, CT_NOTES, IS_ID_CHILD, False, '', 0)
    else HaveRequired := True;
  // lock the consult request if there is a consult
  if HaveRequired then
    with FEditNote do
      if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then HaveRequired := LockConsultRequest(PkgIEN);
  if HaveRequired then
  begin
    uPCEEdit.NoteDateTime := FEditNote.DateTime;
    uPCEEdit.PCEForNote(FEditNote.Addend, uPCEShow);
    FEditNote.Location     := uPCEEdit.Location;
    FEditNote.LocationName := ExternalName(uPCEEdit.Location, 44);
    FEditNote.VisitDate    := uPCEEdit.DateTime;
    PutAddendum(CreatedNote, FEditNote, FEditNote.Addend);
    Result := IntToStr(CreatedNote.IEN); //kt added
    uPCEEdit.NoteIEN := CreatedNote.IEN;
    if CreatedNote.IEN > 0 then LockDocument(CreatedNote.IEN, CreatedNote.ErrorText);
    if CreatedNote.ErrorText = '' then
    begin
      with FEditNote do
        begin
          original in bloc below.
          x := IntToStr(CreatedNote.IEN) + U + 'Addendum to ' + TitleName + U + FloatToStr(DateTime) + U +
               Patient.Name + U + IntToStr(Author) + ';' + AuthorName + U + LocationName + U + 'new' + U +
               U + U + U + U + U + U + U;
        end;

      lstNotes.Items.Insert(0, x);
      uChanging := True;
      tvNotes.Items.BeginUpdate;
      tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, 'New Addendum in Progress',
                                              MakeNoteTreeObject('ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_TOP_LEVEL;
      tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeNoteTreeObject(x));
      TORTreeNode(tmpNode).StringData := x;

      tmpNode.ImageIndex := IMG_ADDENDUM;
      tmpNode.SelectedIndex := IMG_ADDENDUM;
      tvNotes.Selected := tmpNode;
      tvNotes.Items.EndUpdate;
      uChanging := False;
      Changes.Add(CH_DOC, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
      lstNotes.ItemIndex := 0;
      EditingIndex := 0;
      SetSubjectVisible(AskSubjectForNotes);
      cmdChangeClick(Self); // will set captions, sign state for Changes
      if TMGForcePlainTextEditMode then begin   //kt  added block 12/27/12
        // Set in TfrmCarePlan.InsertText
        Mode := [vmEdit] + [vmHTML_MODE[False]];   //kt 4/14
        TMGForcePlainTextEditMode := False;
      end else begin
        Mode := [vmEdit] + [vmHTML_MODE[fOptionsNotes.DefaultEditHTMLMode]];   //kt 4/14
      end;
      SetDisplayToHTMLvsText(Mode, nil, VIEW_ACTIVATE_ONLY);                 //kt 4/14
      lstNotesClick(Self);  // will make pnlWrite visible
      if timAutoSave.Interval <> 0 then timAutoSave.Enabled := True;
      SetEditorFocus;  //kt memNewNote.SetFocus;  //kt 9/11
    end else
    begin
      // if note creation failed or failed to get note lock (both unlikely), unlock consult
      with FEditNote do if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS)  then UnlockConsultRequest(0, PkgIEN);
      InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
      HaveRequired := False;
    end; //if CreatedNote.IEN
  end; //if HaveRequired
  if not HaveRequired then ClearEditControls;
  }
end;

function TfrmNotes.InsertChildDoc(DocumentType : integer;
                                  ParentData : string;
                                  DocSubject : string =  '';
                                  Lines : TStrings = nil) : string;
//kt added function, starting from InsertAddendum() code, to allow calling in from both
//   InsertAddendum and new InsertComponent
//Input: DocumentType: should be TYP_ADDENDUM or TYP_COMPONENT
//       ParentData: ParentIEN8925^ParentTitle^.... (only first 2 pieces are used)
//       DocSubject: Only used when DocumentType = TYP_COMPONENT.  This is subject name for component.
//Result: returns datastring (IEN is piece#1) of added Addendum or component.  //kt added
{ sets up fields of pnlWrite to write an addendum for the selected note }
const
  AS_ADDENDUM = True;
  IS_ID_CHILD = False;
var
  HaveRequired:     Boolean;
  CreatedNote:      TCreatedDoc;
  tmpNode:          TTreeNode;
  x:                string;
  Mode :            TViewModeSet;          //kt 4/14
  Name, UpName:     string;                //kt 4/15
  ChangesMode:      integer;               //kt 4/15
  LinkedLines:      boolean;               //kt 5/15
  ParentIEN :       int64;                 //kt 5/15
  ParentNode:       TORtreeNode;           //kt
  UnsignedDocsNode: TORtreeNode;           //kt
begin
  Result := '';  //kt added
  if not (DocumentType in [TYP_ADDENDUM, TYP_COMPONENT]) then exit;  //kt
  ClearEditControls;
  txtSubject.Text := DocSubject;  //kt added
  ParentIEN := StrToInt64Def(Piece(ParentData, U, 1),0); //kt
  with FEditNote do begin
    DocType      := DocumentType;
    IsNewNote    := False;
    //kt original --> Title        := TitleForNote(lstNotes.ItemIEN);
    Title        := TitleForNote(ParentIEN);
    //kt original --> TitleName    := Piece(lstNotes.Items[lstNotes.ItemIndex], U, 2);
    TitleName    := Piece(ParentData, U, 2);  //kt
    Subject      := DocSubject;  //kt added
    IsComponent  := (DocumentType = TYP_COMPONENT); //kt added
    if DocumentType = TYP_COMPONENT then TitleName := '['+DocSubject+']';  //kt added
    if Copy(TitleName,1,1) = '+' then TitleName := Copy(TitleName, 3, 199);
    DateTime     := FMNow;
    Author       := User.DUZ;
    AuthorName   := User.Name;
    //kt x            := GetPackageRefForNote(lstNotes.ItemIEN);
    x            := GetPackageRefForNote(ParentIEN);     //kt
    if Piece(x, U, 1) <> '-1' then begin
      //kt PkgRef   := GetPackageRefForNote(lstNotes.ItemIEN);
      PkgRef   := GetPackageRefForNote(ParentIEN);  //kt
      PkgIEN   := StrToIntDef(Piece(PkgRef, ';', 1), 0);
      PkgPtr   := Piece(PkgRef, ';', 2);
    end;
    //kt original --> Addend := lstNotes.ItemIEN;
    Addend := ParentIEN;  //kt 5/15
    //Lines        := memNewNote.Lines;
    // Cosigner, if needed, will be set by fNoteProps
    // Location info will be set after the encounter is loaded
  end;
  //kt Add block  5/15
  LinkedLines := false;
  if assigned(Lines) then begin
    if assigned (FEditNote.Lines) then begin
      FEditNote.Lines.Assign(Lines);
    end else begin
      LinkedLines := true;
      FEditNote.Lines := Lines;    //will be unlinked to passed Lines below
    end;
  end;
  //kt end block.
  // check to see if interaction necessary to get required fields
  if LacksRequiredForCreate then begin
    HaveRequired := ExecuteNoteProperties(FEditNote, CT_NOTES, IS_ID_CHILD, False, '', 0)
  end else HaveRequired := True;
  // lock the consult request if there is a consult
  if HaveRequired then with FEditNote do begin
    if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then HaveRequired := LockConsultRequest(PkgIEN);
  end;
  if HaveRequired then begin
    uPCEEdit.NoteDateTime := FEditNote.DateTime;
    uPCEEdit.PCEForNote(FEditNote.Addend, uPCEShow);
    FEditNote.Location     := uPCEEdit.Location;
    FEditNote.LocationName := ExternalName(uPCEEdit.Location, 44);
    FEditNote.VisitDate    := uPCEEdit.DateTime;
    if DocumentType = TYP_ADDENDUM then begin
      PutAddendum(CreatedNote, FEditNote, FEditNote.Addend);
    end else begin
      PutComponent(CreatedNote, FEditNote, FEditNote.Addend);
    end;
    Result := IntToStr(CreatedNote.IEN); //kt added
    uPCEEdit.NoteIEN := CreatedNote.IEN;
    if CreatedNote.IEN > 0 then LockDocument(CreatedNote.IEN, CreatedNote.ErrorText);
    if CreatedNote.ErrorText = '' then begin
      with FEditNote do begin
        //kt original below.
        //kt x := IntToStr(CreatedNote.IEN) + U + 'Addendum to ' + TitleName + U + FloatToStr(DateTime) + U +
        //kt      Patient.Name + U + IntToStr(Author) + ';' + AuthorName + U + LocationName + U + 'new' + U +
        //kt      U + U + U + U + U + U + U;
        //kt begin mod --
        if (DocumentType = TYP_COMPONENT) then begin
          x := '['+DocSubject+']';
        end else begin
          x := 'Addendum to ' + TitleName;
        end;
        x := IntToStr(CreatedNote.IEN) + U + x + U + FloatToStr(DateTime) + U +
              Patient.Name + U + IntToStr(Author) + ';' + AuthorName + U + LocationName + U + 'new' + U +
              U + U + U + U + U + U + U;
        //kt end mod --
      end;
      SetPiece(x, U, 10, DocSubject);  //kt
      lstNotes.Items.Insert(0, x);
      Result := x; //kt added
      uChanging := True;
      tvNotes.Items.BeginUpdate;
      if DocumentType = TYP_ADDENDUM then begin  //kt added this if line, but block below was original (with some additions)
        if (DocumentType = TYP_COMPONENT) then Name := 'Component' else Name := 'Addendum';  //kt
        UpName := UpperCase(Name);  //kt
        tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, 'New '+Name+' in Progress',
                                                MakeNoteTreeObject(UpName+'^New '+Name+' in Progress^^^^^^^^^^^%^0'));  //kt
        TORTreeNode(tmpNode).StringData := UpName+'^New '+Name+' in Progress^^^^^^^^^^^%^0';  //kt
        tmpNode.ImageIndex := IMG_TOP_LEVEL;
        tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeNoteTreeObject(x));
        TORTreeNode(tmpNode).StringData := x;
        tmpNode.ImageIndex := IMG_ADDENDUM;
        tmpNode.SelectedIndex := IMG_ADDENDUM;
      end else begin  //kt added this block
        UnsignedDocsNode := tvNotes.FindPieceNode(IntToStr(NC_UNSIGNED), U);
        ParentNode := tvNotes.FindPieceNode(Piece(ParentData, U,1), 1, U, UnsignedDocsNode);
        tmpNode := frmNotes.tvNotes.Items.AddChildObjectFirst(ParentNode, MakeNoteDisplayText(x), MakeNoteTreeObject(x));
        TORTreeNode(tmpNode).StringData := x;
        tmpNode.ImageIndex := IMG_SINGLE;
        tmpNode.SelectedIndex := IMG_ADDENDUM;
        tmpNode.StateIndex := IMG_NO_IMAGES
      end;
      tvNotes.Selected := tmpNode;
      tvNotes.Items.EndUpdate;
      uChanging := False;
      if (DocumentType = TYP_COMPONENT) then ChangesMode := CH_SIGN_NA else ChangesMode := CH_SIGN_YES;  //kt added
      //kt original --> Changes.Add(CH_DOC, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
      Changes.Add(CH_DOC, IntToStr(CreatedNote.IEN), GetTitleText(0), '', ChangesMode);
      lstNotes.ItemIndex := 0;
      EditingIndex := 0;
      SetSubjectVisible(AskSubjectForNotes);
      cmdChangeClick(Self); // will set captions, sign state for Changes
      if TMGForcePlainTextEditMode then begin   //kt  added block 12/27/12
        // Set in TfrmCarePlan.InsertText
        Mode := [vmEdit] + [vmHTML_MODE[False]];   //kt 4/14
        TMGForcePlainTextEditMode := False;
      end else begin
        Mode := [vmEdit] + [vmHTML_MODE[fOptionsNotes.DefaultEditHTMLMode]];   //kt 4/14
      end;
      SetDisplayToHTMLvsText(Mode, Lines, false);                 //kt 4/14, 5/15  (changed nil to Lines; VIEW_ACTIVATE_ONLY to false)
      lstNotesClick(Self);  // will make pnlWrite visible
      if timAutoSave.Interval <> 0 then timAutoSave.Enabled := True;
      SetEditorFocus;  //kt memNewNote.SetFocus;  //kt 9/11
    end else begin
      // if note creation failed or failed to get note lock (both unlikely), unlock consult
      with FEditNote do if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS)  then UnlockConsultRequest(0, PkgIEN);
      InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
      HaveRequired := False;
    end; {if CreatedNote.IEN}
  end; {if HaveRequired}
  if LinkedLines then FEditNote.Lines := nil;  //kt 5/15
  if not HaveRequired then ClearEditControls;
end;

procedure TfrmNotes.LoadForEdit;
{ retrieves an existing note and places the data in the fields of pnlWrite }
var
  tmpNode: TTreeNode;
  x: string;
  Mode : TViewModeSet; //kt 9/11
  ChangesMode : integer;  //kt 4/15
begin
  ClearEditControls;
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then Exit;
  TMGLoadingForEdit := true;  //kt added 11/15  Signal used in tvNotesDblClick()
  EditingIndex := lstNotes.ItemIndex;
  GetNoteForEdit(FEditNote, lstNotes.ItemIEN);  //kt moved. Was right below Changes.Add() before.
  if FEditNote.IsComponent then ChangesMode := CH_SIGN_NA else ChangesMode := CH_SIGN_YES;  //kt added
  //kt original --> Changes.Add(CH_DOC, lstNotes.ItemID, GetTitleText(EditingIndex), '', CH_SIGN_YES);
  Changes.Add(CH_DOC, lstNotes.ItemID, GetTitleText(EditingIndex), '', ChangesMode);
  Mode := [vmEdit] + [vmHTML_MODE[IsHTML(FEditNote.Lines) or (vmHTML in FViewMode)]]; //kt 9/11
  SetDisplayToHTMLvsText(Mode,FEditNote.Lines);                                       //kt 9/11
  //kt memNewNote.Lines.Assign(FEditNote.Lines);                                      //kt 9/11
  FChanged := False;
  if FEditNote.Title = TYP_ADDENDUM then
  begin
    FEditNote.DocType := TYP_ADDENDUM;
    FEditNote.TitleName := Piece(lstNotes.Items[lstNotes.ItemIndex], U, 2);
    if Copy(FEditNote.TitleName,1,1) = '+' then FEditNote.TitleName := Copy(FEditNote.TitleName, 3, 199);
    if CompareText(Copy(FEditNote.TitleName, 1, 8), 'Addendum') <> 0
      then FEditNote.TitleName := FEditNote.TitleName + 'Addendum to ';
  end;

  uChanging := True;
  tvNotes.Items.BeginUpdate;

  tmpNode := tvNotes.FindPieceNode('EDIT', 1, U, nil);
  if tmpNode = nil then begin
    tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, 'Note being edited',
                                            MakeNoteTreeObject('EDIT^Note being edited^^^^^^^^^^^%^0'));
    TORTreeNode(tmpNode).StringData := 'EDIT^Note being edited^^^^^^^^^^^%^0';
  end else
    tmpNode.DeleteChildren;
  x := lstNotes.Items[lstNotes.ItemIndex];
  tmpNode.ImageIndex := IMG_TOP_LEVEL;
  tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeNoteTreeObject(x));
  TORTreeNode(tmpNode).StringData := x;
  if CompareText(Copy(FEditNote.TitleName, 1, 8), 'Addendum') <> 0 then
    tmpNode.ImageIndex := IMG_SINGLE
  else
    tmpNode.ImageIndex := IMG_ADDENDUM;
  tmpNode.SelectedIndex := tmpNode.ImageIndex;
  tvNotes.Selected := tmpNode;
  tvNotes.Items.EndUpdate;
  uChanging := False;

  uPCEEdit.NoteDateTime := MakeFMDateTime(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
  uPCEEdit.PCEForNote(lstNotes.ItemIEN, uPCEShow);
  FEditNote.NeedCPT := uPCEEdit.CPTRequired;
  txtSubject.Text := FEditNote.Subject;
  SetSubjectVisible(AskSubjectForNotes);
  cmdChangeClick(Self); // will set captions, sign state for Changes
  lstNotesClick(Self);  // will make pnlWrite visible
  if timAutoSave.Interval <> 0 then timAutoSave.Enabled := True;
  SetEditorFocus;    //kt memNewNote.SetFocus;  //kt 9/11
  TMGLoadingForEdit := false;
end;

procedure TfrmNotes.SaveEditedNote(var Saved: Boolean);
{ validates fields and sends the updated note to the server }
var
  UpdatedNote: TCreatedDoc;
  x: string;
  EmptyNote : boolean; //kt 9/11
  EditIsHTML : boolean;  //kt 5/15
  HTMLText : string;

  //kt NOTICE: I was previously using FViewMode to determine how to save edited note.
  //    This doesn't always work.  For example, if one note is being edited, but the user
  //    has clicked to view another note, then FViewMode will reflect what is currently
  //    being **viewed**, not what is being edited.
begin
  Saved := False;
  if FEditNote.Lines = nil then FEditNote.Lines := TStringList.Create; //kt 9/11
  //kt mods below 5/15
  EditIsHTML := (FHTMLEditMode = emHTML);
  if EditIsHTML then begin
    HTMLText := GetEditorHTMLText;
    EmptyNote := (HtmlEditor.GetTextLen = 0) or not HTMLContainsVisibleItems(HTMLText);
  end else begin
    EmptyNote := (memNewNote.GetTextLen = 0) or not ContainsVisibleChar(memNewNote.Text);
  end;
  //kt 9/11 if (memNewNote.GetTextLen = 0) or (not ContainsVisibleChar(memNewNote.Text)) then
  //kt 9/11  begin
  if EmptyNote then begin
    lstNotes.ItemIndex := EditingIndex;
    x := lstNotes.ItemID;
    uChanging := True;
    tvNotes.Selected := tvNotes.FindPieceNode(x, 1, U, tvNotes.Items.GetFirstNode);
    uChanging := False;
    tvNotesChange(Self, tvNotes.Selected);
    if FSilent or
      ((not FSilent) and (InfoBox(GetTitleText(EditingIndex) + TX_EMPTY_NOTE, TC_EMPTY_NOTE, MB_YESNO) = IDYES))
    then begin
      FConfirmed := True;
      mnuActDeleteClick(Self);
      Saved := True;
      FDeleted := True;
    end else
      FConfirmed := False;
      //kt --> causes endless loop --> Saved := true; //kt added 5/15. Allow note change to continue, even if user chooses not to delete note.
    Exit;
  end;
  //ExpandTabsFilter(memNewNote.Lines, TAB_STOP_CHARS);
  //kt 5/15 moved to above --> if FEditNote.Lines = nil then FEditNote.Lines := TStringList.Create; //kt 9/11
  //kt 9/11 FEditNote.Lines    := memNewNote.Lines;

  //kt 5/15 if (vmHTML in FViewMode) then begin                   //kt 9/11
  if EditIsHTML then begin                                        //kt 5/15
    SplitHTMLToArray(WrapHTML(HTMLText), FEditNote.Lines); //kt 9/11
    InsertSubs(FEditNote.Lines);                       //kt 9/11
  end else begin                                                  //kt 9/11
    FEditNote.Lines.Assign(memNewNote.Lines);                     //kt 9/11
  end;                                                            //kt 9/11
  //FEditNote.Lines:= SetLinesTo74ForSave(memNewNote.Lines, Self);
  FEditNote.Subject  := txtSubject.Text;
  FEditNote.NeedCPT  := uPCEEdit.CPTRequired;
  timAutoSave.Enabled := False;
  try
    PutEditedNote(UpdatedNote, FEditNote, lstNotes.GetIEN(EditingIndex));
  finally
    timAutoSave.Enabled := True;
  end;
  // there's no unlocking here since the note is still in Changes after a save
  if UpdatedNote.IEN > 0 then begin
    if lstNotes.ItemIndex = EditingIndex then begin
      EditingIndex := -1;
      lstNotesClick(Self);
    end;
    EditingIndex := -1; // make sure EditingIndex reset even if not viewing edited note
    Saved := True;
    FNewIDChild := False;
    FChanged := False;
    HTMLEditor.KeyStruck := false; //kt
  end else begin
    if not FSilent then
      InfoBox(TX_SAVE_ERROR1 + UpdatedNote.ErrorText + TX_SAVE_ERROR2, TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  end;
end;

procedure TfrmNotes.SaveCurrentNote(var Saved: Boolean);
{ called whenever a note should be saved - uses IEN to call appropriate save logic }
begin
  if EditingIndex < 0 then Exit;
  SaveEditedNote(Saved);
end;

function TfrmNotes.GetEditorHTMLText : string;
//kt added function 3/16
begin
  if GLOBAL_HTMLTemplateDialogsMgr.HasEmbeddedDialog(HtmlEditor) then begin
    //later I can embed this functionality in THtmlObj, i.e. in GetHTMLText function...
    Result := GLOBAL_HTMLTemplateDialogsMgr.GetHTMLTextInSaveMode(HtmlEditor, ActiveEditIEN);
  end else begin
    Result := HtmlEditor.HTMLText;
  end;
end;

{ Form events ------------------------------------------------------------------------------ }

procedure TfrmNotes.FormCreate(Sender: TObject);
var
  CacheDir : AnsiString;  //kt 9/11
const
  DEBUGGING_WIN_MESSAGES = true; //change to false when not in use --> will save memory, speed.
begin
  inherited;
  //kt 9/11 --- Begin Modification -------------
  //9/28/15 frmSearchStop := TfrmSearchStop.Create(Self);  //used to be auto created.  //kt 9/25/15
  fOptionsNotes.Loaded;
  //CacheDir := ExtractFilePath(ParamStr(0))+ 'Cache';
  CacheDir := GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache';
  if not DirectoryExists(CacheDir) then CreateDir(CacheDir);
  LastAuthor :=0;
  LastAuthorName:='';
  DesiredHTMLFontSize := 2;  //Used later to downsize during printing.
  SetRegHTMLFontSize(DesiredHTMLFontSize);   //0=SMALLEST ... 4=LARGEST
  //kt  Note: On creation, THtmlObj will remember Application.OnMessage.  But if
  //          another object (say a prior THtmlObj) has become active and already
  //          changed the handler, then there will be a problem.  So probably best
  //          to create them all at once.
  HtmlViewer := THtmlObj.Create(pnlHTMLViewer,Application);
  HtmlEditor := THtmlObj.Create(pnlHTMLEdit,Application);
  TWinControl(HtmlViewer).Parent:=pnlHTMLViewer;
  TWinControl(HtmlViewer).Align:=alClient;
  HtmlEditor.PrevControl := cmdPCE;
  HtmlEditor.NextControl := cmdChange;
  //Note: A 'loaded' function will initialize the THtmlObj's, but it can't be
  //      done until after this constructor is done, and this TfrmNotes has been
  //      assigned a parent.  So done elsewhere.
  //      The loaded function is called from fFrame.CreateATab, at CT_NOTES part.
  //kt 8/16-------
  //EDDIE  removed the following until fixed   HtmlEditor.OnPasteEvent := HandleHTMLObjPaste;
  if DEBUGGING_WIN_MESSAGES then begin
    frmWinMessageLog := TfrmWinMessageLog.Create(Self);
  end else begin
    frmWinMessageLog := nil;
    ViewWindowsMessages1.visible := false;
  end;
  HtmlEditor.WinMessageLog := frmWinMessageLog;
  //kt end 8/16-------
  HtmlViewer.PopupMenu := popNoteMemo;
  TWinControl(HtmlEditor).Parent:=pnlHTMLEdit;
  TWinControl(HtmlEditor).Align:=alClient;
  HtmlEditor.PopupMenu := popNoteMemo;
  cbFontNames.Items.Assign(Screen.Fonts);
  FViewMode := [vmView,vmText];
  FHTMLEditMode := emNone;
  UpdateReadOnlyColorScheme(HTMLViewer, TRUE);      //kt 9/11
  FNotesToHide := TStringList.Create; //kt 5/12/14
  btnHideTitle.Caption := 'Hide';
  FHideTitleBusy := false; //kt
  //FHTMLZoomValue := 100;  //kt
  TMGForceSaveSwitchEdit := false; //kt
  TVDblClickPending := false; //kt
  TVChangePending := false; //kt
  FDesiredPCEInitialPageEditIndex := 0;
  //kt 9/11 --- End Modification ------

  PageID := CT_NOTES;
  EditingIndex := -1;
  FEditNote.LastCosigner := 0;
  FEditNote.LastCosignerName := '';
  FLastNoteID := '';
  frmDrawers := TfrmDrawers.CreateDrawers(Self, pnlDrawers, [],[]);
  frmDrawers.Align := alBottom;
  frmDrawers.RichEditControl := memNewNote;
  frmDrawers.HTMLEditControl := HtmlEditor;       //kt 9/11
  frmDrawers.HTMLModeSwitcher := SetHTMLEditMode; //kt 9/11
  frmDrawers.ActiveEditIEN := ActiveEditIEN;      //kt 5/15
  frmDrawers.ReloadNotes := ReloadNotes;          //kt 5/15
  frmDrawers.DocSelRec.TreeView := tvNotes;        //kt 6/15
  frmDrawers.DocSelRec.TreeType := edseNotes;      //kt 6/15
  frmDrawers.NewNoteButton := cmdNewNote;
  frmDrawers.Splitter := splDrawers;
  frmDrawers.DefTempPiece := 1;
  HtmlEditor.OnLaunchTemplateSearch := frmDrawers.HandleLaunchTemplateQuickSearch;
  HtmlEditor.OnLaunchConsole := frmDrawers.HandleLaunchConsole;
  HtmlEditor.OnInsertDate := HandleInsertDate;  //kt
  FImageFlag := TBitmap.Create;
  FDocList := TStringList.Create;
  RestoreRegHTMLFontSize;  //kt 9/11
  clTMGHighlight := TColor(StringToColor(uTMGOptions.ReadString('color for TIU highlight','$FFFFB3')));   //elh 8/4/16    //kt
end;

procedure TfrmNotes.HandleInsertDate(Sender: TObject);  //kt
begin
  HTMLEditor.InsertHTMLAtCaret(datetostr(date));
end;

function TfrmNotes.SetClipText(szText:string):Boolean;
//kt added entire function 8/16
//from: http://www.delphibasics.info/home/delphibasicssnippets/operateclipboardwithoutclipboardunit
var pData:  DWORD;
    dwSize: DWORD;
begin
  Result := FALSE;
  if OpenClipBoard(0) then begin
    dwSize := Length(szText) + 1;
    if dwSize <> 0 then begin
      pData := GlobalAlloc(MEM_COMMIT, dwSize);
      if pData <> 0 then begin
        CopyMemory(Pointer(pData), PChar(szText), dwSize);
        if SetClipBoardData(CF_HTML, pData) <> 0 then Result := TRUE;
      end;
    end;
    CloseClipBoard;
  end;
end;

function TfrmNotes.GetClipHTMLText(var szText:string):Boolean;
//kt added entire function 8/16
//from: http://www.delphibasics.info/home/delphibasicssnippets/operateclipboardwithoutclipboardunit
var hData:  DWORD;
    pData:  Pointer;
    dwSize: DWORD;
begin
  Result := FALSE;
  //original if OpenClipBoard(0) <> 0 then begin
  if OpenClipBoard(0) then begin
    try
      hData := GetClipBoardData(CF_HTML);
      if hData <> 0 then begin
        pData := GlobalLock(hData);
        if pData <> nil then begin
          dwSize := GlobalSize(hData);
          if dwSize <> 0 then begin
            SetLength(szText, dwSize);
            CopyMemory(@szText[1], pData, dwSize);
            Result := TRUE;
          end;
          GlobalUnlock(DWORD(pData));
        end;
      end;
    finally
      CloseClipBoard;
    end;
  end else begin
    szText := '';
  end;
end;

procedure TfrmNotes.HandleHTMLObjPaste(Sender : TObject; var AllowPaste : boolean); //kt 8/16
//kt added entire function 8/16
//Handle paste event of one of the THtmlObj objects
//We can modify the clipboard if we want..
{From TClipboard documentation:
  Read TClipboard.Formats to determine what formats encode the information currently on the clipboard.
  Each format can be accessed by its position in the array.
  Usually, when an application copies or cuts something to the clipboard, it places it
  there in multiple formats. An application can place items of a particular format on
  the clipboard and retrieve items with a particular format from the clipboard if the
  format is in the Formats array. To find out if a particular format is available
  on the clipboard, use the HasFormat method.
  When reading information from the clipboard, use the Formats array to choose the best
  possible encoding for information that can be encoded in several ways.
  Before you can write information to the clipboard in a particular format, the
  format must be registered.
  To register a new format, use the RegisterClipboardFormat method of TPicture.
  }

  procedure RemoveWrapping(SL : TStringList);
  var HTMLText: string;
  begin
    HTMLText := SL.text;
    HTMLText := piece2(HTMLText,'<!--StartFragment-->',2);
    HTMLText := piece2(HTMLText,'<!--EndFragment-->',1);
    SL.clear;
    SL.text := HTMLText;
  end;

  procedure AddWrapping(SL : TStringList);
  var HTMLText : string;
  begin
    HTMLText := 'Version:0.9' + CRLF;
    HTMLText := HTMLText + 'StartHTML:-1' + CRLF;
    HTMLText := HTMLText + 'EndHTML:-1' + CRLF;
    HTMLText := HTMLText + 'StartFragment:000081' + CRLF;
    HTMLText := HTMLText + 'EndFragment:°°°°°°' + CRLF;
    HTMLText := HTMLText + SL.Text + CRLF;
    HTMLText := StringReplace(HTMLText, '°°°°°°', Format('%.6d', [Length(HTMLText)]), []);
    SL.Clear;
    SL.Text := HTMLText;
  end;

var
   TempCBText   : TStringList;
   TextModified : boolean;
   ClipText     : string;  //= 49285;
   TestText     : string;
begin
  AllowPaste := true; //default
  if not Clipboard.HasFormat(CF_HTML) then exit; //for now, I am only going to modify HTML pastes.
  try
    TempCBText := TStringList.Create;
    AllowPaste := true;
    if not GetClipHTMLText(ClipText) then exit;
    TestText := Clipboard.AsText;
    TempCBText.Text := ClipText; //FYI, if we just wanted text, then could use: TempCBText.Text := Clipboard.AsText;
    RemoveWrapping(TempCBText);
    //This copied function below blows up and creates an exception error. -->
    StripJavaScript(TempCBText, TextModified);  //modify TempCBText if needed
    //if not TextModified then exit;  <--- NOTE: if text is not put back, then the format is all screwy, I don't understand why.
    AddWrapping(TempCBText);
    if not SetClipText(TempCBText.text) then begin
      AllowPaste := false;
    end;
    //FYI, if we just working with text, then could use: Clipboard.AsText := <my new text>
  finally
    FreeAndNil(TempCBText)
  end;
end;


procedure TfrmNotes.pnlRightResize(Sender: TObject);
{ memNote (TRichEdit) doesn't repaint appropriately unless it's parent panel is refreshed }
begin
  inherited;
  pnlRight.Refresh;
  if (vmHTML in FViewMode) then begin //kt 9/11
    HTMLViewer.Repaint;               //kt 9/11
  end else begin                      //kt 9/11
    memNote.Repaint
  end;                                //kt 9/11
end;

procedure TfrmNotes.pnlWriteResize(Sender: TObject);
const
  LEFT_MARGIN = 4;
begin
  inherited;
  //kt 9/11 NOTE: I don't know how to do the equivalent for HTML.  Actually, I don't think it applies.
  LimitEditWidth(memNewNote, MAX_PROGRESSNOTE_WIDTH - 1);

  //CQ7012 Added test for nil
  if memNewNote <> nil then
     memNewNote.Constraints.MinWidth := TextWidthByFont(memNewNote.Font.Handle, StringOfChar('X', MAX_PROGRESSNOTE_WIDTH)) + (LEFT_MARGIN * 2) + ScrollBarWidth;
  //CQ7012 Added test for nil
   if (Self <> nil) and (pnlLeft <> nil) and (pnlWrite <> nil) and (sptHorz <> nil) then
     pnlLeft.Width := self.ClientWidth - pnlWrite.Width - sptHorz.Width;
  UpdateFormForInput;
end;

{ Left panel (selector) events ------------------------------------------------------------- }

procedure TfrmNotes.lstNotesClick(Sender: TObject);
{ loads the text for the selected note or displays the editing panel for the selected note }
var
  x: string;
  Note      : TStrings;     //kt 9/11  Will be pointer to FViewNote, or FEditNote.Lines
  Editing   : boolean;      //kt 9/11
  Mode      : TViewModeSet; //kt 9/11
  IsHTML    : boolean;      //kt 9/11

begin
  inherited;
  with lstNotes do begin                                                   //kt 9/11
    //kt with lstNotes do if ItemIndex = -1 then Exit
    if ItemIndex = -1 then Exit;                                           //kt 9/11
    Editing := (ItemIndex = EditingIndex);                                 //kt 9/11
    if Editing then begin                                                  //kt 9/11
      //kt else if ItemIndex = EditingIndex then                             //kt 9/11
      //kt begin                                                             //kt 9/11
      pnlWrite.Visible := True;
      pnlRead.Visible := False;
        if FEditNote.Lines = nil then FEditNote.Lines := TStringList.Create; //kt 9/11
        Note := FEditNote.Lines;                                             //kt 9/11
        mnuViewDetail.Enabled    := false; //kt 5/15 <-- documentation.  If set to true, then doc details are put into edit area, i.e. included in note text.
      if (FEditNote.IDParent <> 0) and (not FNewIDChild) then
        mnuActChange.Enabled     := False
      else
        mnuActChange.Enabled     := True;
      mnuActLoadBoiler.Enabled := True;
      UpdateReminderFinish;
      UpdateFormForInput;
      Mode := [vmEdit] + [vmHTML_MODE[(FHTMLEditMode=emHTML)]];            //kt 9/11
      SetDisplayToHTMLvsText(Mode,FEditNote.Lines,VIEW_ACTIVATE_ONLY);     //kt 9/11
      FWarmedUp := true;                                                   //kt 9/11
    end else begin
      StatusText('Retrieving selected progress note...');
      Screen.Cursor := crAppStart;  //kt 9/11 changed from crHourGlass;
      //kt 9/11 pnlRead.Visible := True;
      //kt 9/11 pnlWrite.Visible := False;
      UpdateReminderFinish;
      lblTitle.Caption := Piece(Piece(Items[ItemIndex], U, 8), ';', 1) + #9 + Piece(Items[ItemIndex], U, 2) + ', ' +
                          Piece(Items[ItemIndex], U, 6) + ', ' + Piece(Piece(Items[ItemIndex], U, 5), ';', 2) +
                          '  (' + FormatFMDateTime('mmm dd,yy@hh:nn', MakeFMDateTime(Piece(Items[ItemIndex], U, 3)))
                          + ')';
      lvNotes.Caption := lblTitle.Caption;
      //kt 8/09 LoadDocumentText(memNote.Lines, ItemIEN);
      LoadDocumentText(FViewNote, ItemIEN);  //kt 9/11
      TMGDebugEditLines := false;                           //kt 4/16  -- can change while walking through to edit StringList;
      if TMGDebugEditLines = true then EditSL(FViewNote);   //kt 4/16
      Note := FViewNote;                     //kt 9/11
      memNote.SelStart := 0;
      mnuViewDetail.Enabled    := True;
      mnuViewDetail.Checked    := False;
      mnuActChange.Enabled     := False;
      mnuActLoadBoiler.Enabled := False;
      Screen.Cursor := crDefault;
      StatusText('');
      //frmImages.NewNoteSelected(Editing); //kt 9/05
      IsHTML := uHTMLTools.IsHTML(FViewNote);            //kt 9/11
      Mode := [vmView] + [vmHTML_MODE[IsHTML]];          //kt 9/11
      SetDisplayToHTMLvsText(Mode,FViewNote);            //kt 9/11
      if not FWarmedUp and IsHTML then begin             //kt 9/11
        FWarmedUp := true;                               //kt 9/11
        //First HTML page won't display without this...  //kt 9/11
        SetDisplayToHTMLvsText(Mode,FViewNote);          //kt 9/11
      end;                                               //kt 9/11
    end;
    if(assigned(frmReminderTree)) then
      frmReminderTree.EnableActions;
      //DisplayPCE;    //kt 9/11 (moved down below)
    pnlRight.Refresh;
    ProperRepaint(Editing); //kt 9/11
    //kt 9/11 memNewNote.Repaint;
    //kt 8/09 memNote.Repaint;
    x := 'TIU^' + lstNotes.ItemID;
    SetPiece(x, U, 10, Piece(lstNotes.Items[lstNotes.ItemIndex], U, 11));
    NotifyOtherApps(NAE_REPORT, x);
    fImages.HTMLEditor := frmNotes.HTMLViewer;  //kt
    frmImages.NewNoteSelected(Editing); //kt 9/05
    DisplayPCE;                          //kt 9/11 (move down from above)
    BroadcastImages(Note);               //kt 9/11
  end; //kt 9/11
end;

procedure TfrmNotes.ProperRepaint(Editing : Boolean);
//kt added 9/11
begin
  if Editing then begin
    if (vmHTML in FViewMode) then begin
      HtmlEditor.Repaint;
    end else begin
      memNewNote.Repaint;
    end;
  end else begin
    if (vmHTML in FViewMode) then begin
      HtmlViewer.Repaint;
    end else begin
      memNote.Repaint;
    end;
  end;
  Application.ProcessMessages;
end;

procedure TfrmNotes.BroadcastImages(Note: TStrings);
//kt added 9/11
var
  ImageList : TStringList;
  i         : integer;
begin
  ImageList := TStringList.Create;
  if uHTMLTools.CheckForImageLink(Note, ImageList) then begin
    for i:= 0 to ImageList.Count-1 do begin
      NotifyOtherApps(NAE_REPORT, 'IMAGE^' + ImageList.Strings[i]);
    end;
  end;
  ImageList.Free;
end;

function TfrmNotes.EditorHasText : boolean;
//kt added 9/11
begin
  if (vmHTML in FViewMode) then begin
    Result := (HTMLEditor.Text <> '');
  end else begin
    //kt Result := (memNote.Lines.Count > 0);
    Result := (memNewNote.GetTextLen > 0);
  end;
end;

procedure TfrmNotes.cmdNewNoteClick(Sender: TObject);
{ maps 'New Note' button to the New Progress Note menu item }
begin
  inherited;
  mnuActNewClick(Self);
end;

procedure TfrmNotes.cmdPCEClick(Sender: TObject);
var
  Refresh: boolean;
  ActionSts: TActionRec;
  AnIEN: integer;
  PCEObj, tmpPCEEdit: TPCEData;

  procedure UpdateEncounterInfo;
  begin
    if not FEditingNotePCEObj then begin
      PCEObj := nil;
      AnIEN := lstNotes.ItemIEN;
      //kt 9/11 if (AnIEN <> 0) and (memNote.Lines.Count > 0) then
      if (AnIEN <> 0) and EditorHasText then begin                     //kt 9/11
        ActOnDocument(ActionSts, AnIEN, 'VIEW');
        if ActionSts.Success then begin
          uPCEShow.CopyPCEData(uPCEEdit);
          PCEObj := uPCEEdit;
        end;
      end;
      //kt Refresh := EditPCEData(PCEObj);
      Refresh := EditPCEData(PCEObj, FDesiredPCEInitialPageEditIndex);  //kt
      FDesiredPCEInitialPageEditIndex := 0; //kt This variable is a one-time request, reset to 0 each time.
    end else begin
      //kt original --> UpdatePCE(uPCEEdit);
      UpdatePCE(uPCEEdit, True, FDesiredPCEInitialPageEditIndex);  //kt 5/16
      Refresh := TRUE;
    end;
    if Refresh and (not frmFrame.Closing) then begin
      DisplayPCE;
    end;
  end;

begin
  inherited;
  cmdPCE.Enabled := FALSE;
  if lstNotes.ItemIndex <> EditingIndex then begin
    // save uPCEEdit for note being edited, before updating current note's encounter, then restore  (RV - TAM-0801-31056)
    tmpPCEEdit := TPCEData.Create;
    try
      uPCEEdit.CopyPCEData(tmpPCEEdit);
      UpdateEncounterInfo;
      tmpPCEEdit.CopyPCEData(uPCEEdit);
    finally
      tmpPCEEdit.Free;
    end;
  end else begin
    // no other note being edited, so just proceed as before.
    UpdateEncounterInfo;
  end;
  if cmdPCE <> nil then begin
    cmdPCE.Enabled := TRUE
  end;
end;

{ Right panel (editor) events -------------------------------------------------------------- }

procedure TfrmNotes.mnuActChangeClick(Sender: TObject);
begin
  inherited;
  if (FEditingIndex < 0) or (lstNotes.ItemIndex <> FEditingIndex) then Exit;
  cmdChangeClick(Sender);
end;

procedure TfrmNotes.mnuActLoadBoilerClick(Sender: TObject);
var
  NoteEmpty: Boolean;
  BoilerText: TStringList;
  DocInfo: string;

  procedure AssignBoilerText;
  begin
    ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
    //kt 9/11 QuickCopyWith508Msg(BoilerText, memNewNote);  //kt moved into SetDisplayToHTMLvsText
    SetDisplayToHTMLvsText([vmHTML,vmEdit],BoilerText); //kt 8/09
    UpdateNoteAuthor(DocInfo);
    FChanged := False;
  end;

begin
  inherited;
  if (FEditingIndex < 0) or (lstNotes.ItemIndex <> FEditingIndex) then Exit;
  BoilerText := TStringList.Create;
  try
    if (vmHTML in FViewMode) then begin           //kt 9/11
      NoteEmpty := (HTMLEditor.Text = '');        //kt 9/11
    end else begin                                //kt 9/11
    NoteEmpty := memNewNote.Text = '';
    end;                                          //kt 9/11
    LoadBoilerPlate(BoilerText, FEditNote.Title);
    if (BoilerText.Text <> '') or
       assigned(GetLinkedTemplate(IntToStr(FEditNote.Title), ltTitle)) then
    begin
      DocInfo := MakeXMLParamTIU(IntToStr(lstNotes.ItemIEN), FEditNote);
      if NoteEmpty then AssignBoilerText else
      begin
        case QueryBoilerPlate(BoilerText) of
        0:  { do nothing } ;                         // ignore
        1: begin
             ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
             if (vmHTML in FViewMode) then begin                           //kt 9/11
               HTMLEditor.Text := HTMLEditor.Text + Text2HTML(BoilerText); //kt 9/11
             end else begin                                                //kt 9/11
             QuickAddWith508Msg(BoilerText, memNewNote);  // append
             end;                                                          //kt 9/11
             UpdateNoteAuthor(DocInfo);
           end;
        2: AssignBoilerText;                         // replace
        end;
      end;
    end else
    begin
      if Sender = mnuActLoadBoiler
        then InfoBox(TX_NO_BOIL, TC_NO_BOIL, MB_OK)
        else
        begin
          if not NoteEmpty then
//            if not FChanged and (InfoBox(TX_BLR_CLEAR, TC_BLR_CLEAR, MB_YESNO) = ID_YES)
            if (InfoBox(TX_BLR_CLEAR, TC_BLR_CLEAR, MB_YESNO) = ID_YES) then begin
              if (vmHTML in FViewMode) then begin        //kt 9/11
                HTMLEditor.Clear;                        //kt 9/11
              end else begin                             //kt 9/11
                memNewNote.Lines.Clear;
              end;                                       //kt 9/11
            end;
        end;
    end; {if BoilerText.Text <> ''}
  finally
    BoilerText.Free;
  end;
end;

procedure TfrmNotes.cmdChangeClick(Sender: TObject);
var
  LastTitle, LastConsult: Integer;
  OKPressed, IsIDChild: Boolean;
  x: string;
  DisAssoText : String;
  ChangeMode : integer;  //kt added
begin
  inherited;
  IsIDChild := uIDNotesActive and (FEditNote.IDParent > 0);
  LastTitle   := FEditNote.Title;
  FEditNote.IsNewNote := False;
  DisAssoText := '';
  if (FEditNote.PkgPtr = PKG_CONSULTS) then
    DisAssoText := 'Consults';
  if (FEditNote.PkgPtr = PKG_PRF) then
    DisAssoText := 'Patient Record Flags';
  if (DisAssoText <> '') and (Sender <> Self) then
    if InfoBox('If this title is changed, Any '+DisAssoText+' will be disassociated'+
               ' with this note',
               'Disassociate '+DisAssoText+'?',MB_OKCANCEL) = IDCANCEL	 then
      exit;
  if FEditNote.PkgPtr = PKG_CONSULTS then LastConsult := FEditNote.PkgIEN else LastConsult := 0;;
  if Sender <> Self then OKPressed := ExecuteNoteProperties(FEditNote, CT_NOTES, IsIDChild, FNewIDChild, '', 0)
    else OKPressed := True;
  if not OKPressed then Exit;
  // update display fields & uPCEEdit
  lblNewTitle.Caption := ' ' + FEditNote.TitleName + ' ';
  if (FEditNote.Addend > 0) and (CompareText(Copy(lblNewTitle.Caption, 2, 8), 'Addendum') <> 0)
    and (Pos('[[',lblNewTitle.Caption)<0) and (Pos(']]',lblNewTitle.Caption)<0)  //kt <-- added this middle line
    then lblNewTitle.Caption := ' Addendum to:' + lblNewTitle.Caption;
  with lblNewTitle do bvlNewTitle.SetBounds(Left - 1, Top - 1, Width + 2, Height + 2);
  lblRefDate.Caption := FormatFMDateTime('mmm dd,yyyy@hh:nn', FEditNote.DateTime);
  lblAuthor.Caption  := FEditNote.AuthorName;
  if uPCEEdit.Inpatient then x := 'Adm: ' else x := 'Vst: ';
  x := x + FormatFMDateTime('mm/dd/yy', FEditNote.VisitDate) + '  ' + FEditNote.LocationName;
  lblVisit.Caption   := x;
  if Length(FEditNote.CosignerName) > 0
    then lblCosigner.Caption := 'Expected Cosigner: ' + FEditNote.CosignerName
    else lblCosigner.Caption := '';
  uPCEEdit.NoteTitle  := FEditNote.Title;
  // modify signature requirements if author or cosigner changed
  //kt original --> if (User.DUZ <> FEditNote.Author) and (User.DUZ <> FEditNote.Cosigner)
  //kt original -->   then Changes.ReplaceSignState(CH_DOC, lstNotes.ItemID, CH_SIGN_NA)
  //kt original -->   else Changes.ReplaceSignState(CH_DOC, lstNotes.ItemID, CH_SIGN_YES);
  //kt begin mod --
  if (User.DUZ <> FEditNote.Author) and (User.DUZ <> FEditNote.Cosigner) then ChangeMode := CH_SIGN_NA
  else if FEditNote.IsComponent then ChangeMode := CH_SIGN_NA
  else ChangeMode := CH_SIGN_YES;
  Changes.ReplaceSignState(CH_DOC, lstNotes.ItemID, ChangeMode);
  //kt end mod
  x := lstNotes.Items[EditingIndex];
  SetPiece(x, U, 2, lblNewTitle.Caption);
  SetPiece(x, U, 3, FloatToStr(FEditNote.DateTime));
  tvNotes.Selected.Text := MakeNoteDisplayText(x);
  TORTreeNode(tvNotes.Selected).StringData := x;
  lstNotes.Items[EditingIndex] := x;
  Changes.ReplaceText(CH_DOC, lstNotes.ItemID, GetTitleText(EditingIndex));
  with FEditNote do
  begin
  if (PkgPtr = PKG_CONSULTS) and (LastConsult <> PkgIEN) then
  begin
    // try to lock the new consult, reset to previous if unable
    if (PkgIEN > 0) and not LockConsultRequest(PkgIEN) then
    begin
      Infobox(TX_NO_ORD_CHG, TC_NO_ORD_CHG, MB_OK);
      PkgIEN := LastConsult;
    end else
    begin
      // unlock the previous consult
      if LastConsult > 0 then UnlockOrderIfAble(GetConsultOrderIEN(LastConsult));
      if PkgIEN = 0 then FOrderID := '';
    end;
  end;
  //Link Note to PRF Action
  if PRF_IEN <> 0 then
    if sCallV('TIU LINK TO FLAG', [lstNotes.ItemIEN,PRF_IEN,ActionIEN,Patient.DFN]) = '0' then
      ShowMsg('TIU LINK TO FLAG: FAILED');
  end;

  if LastTitle <> FEditNote.Title then mnuActLoadBoilerClick(Self);
end;

procedure TfrmNotes.memNewNoteChange(Sender: TObject);
begin
  inherited;
  //kt 9/11  NOTE: the equivalent functionality for HTML is HTMLEditor.Keystruck.  Don't have to set here.
  FChanged := True;
end;

procedure TfrmNotes.pnlFieldsResize(Sender: TObject);
{ center the reference date on the panel }
begin
  inherited;
  lblRefDate.Left := (pnlFields.Width - lblRefDate.Width) div 2;
  if lblRefDate.Left < (lblNewTitle.Left + lblNewTitle.Width + 6)
    then lblRefDate.Left := (lblNewTitle.Left + lblNewTitle.Width);
  UpdateFormForInput;
end;

procedure TfrmNotes.DoAutoSave(Suppress: integer = 1);
var
  ErrMsg: string;
  HTMLText : string; //kt 3/16
  Changed : boolean; //kt 9/11
begin
  if fFrame.frmFrame.DLLActive = true then Exit;
  boolAutosaving := True;  //elh 11/18/16
  if (vmHTML in FViewMode) then begin             //kt 9/11
    Changed := HTMLEditor.KeyStruck;              //kt 9/11
  end else begin                                  //kt 9/11
    Changed := FChanged;                          //kt 9/11
  end;                                            //kt 9/11
  //kt 9/11 if (EditingIndex > -1) and FChanged then
  if (EditingIndex > -1) and Changed then begin   //kt  9/11
    StatusText('Autosaving note...');
    //PutTextOnly(ErrMsg, memNewNote.Lines, lstNotes.GetIEN(EditingIndex));
    timAutoSave.Enabled := False;
    try
      if (vmHTML in FViewMode) then begin                                        //kt 9/11
        HTMLText := GetEditorHTMLText;                                           //kt 3/16
        SplitHTMLToArray (HTMLText, FEditNote.Lines);                            //kt 9/11
        SetText(ErrMsg, FEditNote.Lines, lstNotes.GetIEN(EditingIndex),Suppress);//kt 9/11
      end else begin                                                             //kt 9/11
        SetText(ErrMsg, memNewNote.Lines, lstNotes.GetIEN(EditingIndex), Suppress);
      end;                                                                       //kt 9/11
    finally
      timAutoSave.Enabled := True;
    end;
    FChanged := False;
    HTMLEditor.KeyStruck := false; //kt 9/11
    StatusText('');
  end;
  boolAutosaving := False;  //elh 11/18/16
  if ErrMsg <> '' then
    InfoBox(TX_SAVE_ERROR1 + ErrMsg + TX_SAVE_ERROR2, TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  //Assert(ErrMsg = '', 'AutoSave: ' + ErrMsg);
end;

procedure TfrmNotes.timAutoSaveTimer(Sender: TObject);
begin
  inherited;
  DoAutoSave(0);    //kt changed param to 0 (from no param) to force call to save in "TEXT" instead of "TEMP"  9/15/16
end;

{ View menu events ------------------------------------------------------------------------- }

procedure TfrmNotes.mnuViewClick(Sender: TObject);
{ changes the list of notes available for viewing }
var
  AuthCtxt: TAuthorContext;
  SearchCtxt: TSearchContext; // Text Search CQ: HDS00002856
  DateRange: TNoteDateRange;
  Saved: Boolean;
begin
  inherited;
  // save note at EditingIndex?
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  FLastNoteID := lstNotes.ItemID;
  mnuViewDetail.Checked := False;
  StatusText('Retrieving progress note list...');
  if Sender is TMenuItem then ViewContext := TMenuItem(Sender).Tag
    else if FCurrentContext.Status <> '' then ViewContext := NC_CUSTOM
    else ViewContext := NC_RECENT;
  case ViewContext of
  NC_RECENT:     begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblNotes.Caption := 'Last ' + IntToStr(ReturnMaxNotes) + ' Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   FCurrentContext.MaxDocs := ReturnMaxNotes;
                   LoadNotes;
                 end;
  NC_ALL:        begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblNotes.Caption := 'All Signed Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  NC_UNSIGNED:   begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblNotes.Caption := 'Unsigned Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  // Text Search CQ: HDS00002856 --------------------
  NC_SEARCHTEXT: begin;
                   SearchTextStopFlag := False;
                   SelectSearchText(Font.Size, FCurrentContext.SearchString, SearchCtxt, StringReplace(TMenuItem(Sender).Caption, '&', '', [rfReplaceAll]) );
                   with SearchCtxt do if Changed then
                   begin
                     //FCurrentContext.Status := IntToStr(ViewContext);
                     frmSearchStop.Show;
                     lblNotes.Caption := 'Search: '+ SearchString;
                     frmSearchStop.lblSearchStatus.Caption := lblNotes.Caption;
                     FCurrentContext.SearchString := SearchString;
                     LoadNotes;
                   end;
                   // Only do LoadNotes if something changed 
                 end;
  // Text Search CQ: HDS00002856 --------------------
  NC_UNCOSIGNED: begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblNotes.Caption := 'Uncosigned Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  NC_BY_AUTHOR:  begin
                   SelectAuthor(Font.Size, FCurrentContext, AuthCtxt);
                   with AuthCtxt do if Changed then
                   begin
                     FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                     lblNotes.Caption := AuthorName + ': Signed Notes';
                     FCurrentContext.Status := IntToStr(NC_BY_AUTHOR);
                     FCurrentContext.Author := Author;
                     FCurrentContext.TreeAscending := Ascending;
                     LoadNotes;
                   end;
                 end;
  NC_BY_DATE:    begin
                   SelectNoteDateRange(Font.Size, FCurrentContext, DateRange);
                   with DateRange do if Changed then
                   begin
                     FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                     lblNotes.Caption := FormatFMDateTime('mmm dd,yy', FMBeginDate) + ' to ' +
                                         FormatFMDateTime('mmm dd,yy', FMEndDate) + ': Signed Notes';
                     FCurrentContext.BeginDate     := BeginDate;
                     FCurrentContext.EndDate       := EndDate;
                     FCurrentContext.FMBeginDate   := FMBeginDate;
                     FCurrentContext.FMEndDate     := FMEndDate;
                     FCurrentContext.TreeAscending := Ascending;
                     FCurrentContext.Status        := IntToStr(NC_BY_DATE);
                     LoadNotes;
                   end;
                 end;
  NC_CUSTOM:     begin
                   if Sender is TMenuItem then
                     begin
                       SelectTIUView(Font.Size, True, FCurrentContext, uTIUContext);
                       //lblNotes.Caption := 'Custom List';
                     end;
                   with uTIUContext do if Changed then
                   begin
                     //if not (Sender is TMenuItem) then lblNotes.Caption := 'Default List';
                     //if MaxDocs = 0 then MaxDocs   := ReturnMaxNotes;
                     FCurrentContext.BeginDate     := BeginDate;
                     FCurrentContext.EndDate       := EndDate;
                     FCurrentContext.FMBeginDate   := FMBeginDate;
                     FCurrentContext.FMEndDate     := FMEndDate;
                     FCurrentContext.Status        := Status;
                     FCurrentContext.Author        := Author;
                     FCurrentContext.MaxDocs       := MaxDocs;
                     FCurrentContext.ShowSubject   := ShowSubject;
                     // NEW PREFERENCES:
                     FCurrentContext.SortBy        := SortBy;
                     FCurrentContext.ListAscending := ListAscending;
                     FCurrentContext.GroupBy       := GroupBy;
                     SetSortBtnGroupDisplay(GroupBy);  //kt 3/7/14
                     FCurrentContext.TreeAscending := TreeAscending;
                     FCurrentContext.SearchField   := SearchField;
                     FCurrentContext.Keyword       := Keyword;
                     FCurrentContext.Filtered      := Filtered;
                     LoadNotes;
                   end;
                 end;
  end; {case}
  lblNotes.Caption := SetNoteTreeLabel(FCurrentContext);
  // Text Search CQ: HDS00002856 --------------------
  If FCurrentContext.SearchString <> '' then
    lblNotes.Caption := lblNotes.Caption+', containing "'+FCurrentContext.SearchString+'"';
  If SearchTextStopFlag = True then begin;
    lblNotes.Caption := 'Search for "'+FCurrentContext.SearchString+'" was stopped!';
  end;
  //Clear the search text. We are done searching
  FCurrentContext.SearchString := '';
  frmSearchStop.Hide;
  // Text Search CQ: HDS00002856 --------------------
  //kt changed  5/13/14 lblNotes.hint := lblNotes.Caption;
  lblNotes.hint := 'Click for custom options';
  tvNotes.Caption := lblNotes.Caption;
  StatusText('');
end;

{ Action menu events ----------------------------------------------------------------------- }

function TfrmNotes.StartNewEdit(NewNoteType: integer): Boolean;
{ if currently editing a note, returns TRUE if the user wants to start a new one }
var
  Saved: Boolean;
  Msg, CapMsg: string;
  DlgResult : integer; //kt
begin
  FStarting := False;
  Result := True;
  cmdNewNote.Enabled := False;
  if EditingIndex > -1 then
  begin
    FStarting := True;
    case NewNoteType of
      NT_ACT_ADDENDUM:  begin
                          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE3;
                          CapMsg := TC_NEW_SAVE3;
                        end;
      NT_ACT_EDIT_NOTE: begin
                          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE4;
                          CapMsg := TC_NEW_SAVE4;
                        end;
      NT_ACT_ID_ENTRY:  begin
                          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE5;
                          CapMsg := TC_NEW_SAVE5;
                        end;
    else
      begin
        Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE2;
        CapMsg := TC_NEW_SAVE2;
      end;
    end; {case}
    //kt original --> if InfoBox(Msg, CapMsg, MB_YESNO) = IDNO then
    //kt begin mod --
    if TMGForceSaveSwitchEdit then begin
      DlgResult := IDYES;
    end else begin
      DlgResult := InfoBox(Msg, CapMsg, MB_YESNO);
    end;
    if DlgResult = IDNO then
    //kt end mod --
    begin
      Result := False;
      FStarting := False;
    end else begin
        SaveCurrentNote(Saved);
      //kt original --> if not Saved then Result := False else LoadNotes;
      //kt -- begin mod
      if not Saved then begin
        Result := False;
      end else begin
        if not TMGForceSaveSwitchEdit then LoadNotes;
      end;
      //kt end mod ---
        FStarting := False;
      end;
  end;
  //kt mod --
  TMGForceSaveSwitchEdit := false;
  //kt end mod --
  cmdNewNote.Enabled := (Result = False) and (FStarting = False);
end;

procedure TfrmNotes.mnuActNewClick(Sender: TObject);
const
  IS_ID_CHILD = False;
{ switches to current new note or creates a new note if none is being edited already }
begin
  inherited;
  if not StartNewEdit(NT_ACT_NEW_NOTE) then Exit;
  //LoadNotes;
  // make sure a visit (time & location) is available before creating the note
  if Encounter.NeedVisit then
  begin
    UpdateVisit(Font.Size, DfltTIULocation);
    frmFrame.DisplayEncounterText;
  end;
  if Encounter.NeedVisit then
  begin
    InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
    ShowPCEButtons(False);
    Exit;
  end;
  InsertNewNote(IS_ID_CHILD, 0);
end;

procedure TfrmNotes.mnuActAddIDEntryClick(Sender: TObject);
const
  IS_ID_CHILD = True;
var
  AnIDParent: integer;
{ switches to current new note or creates a new note if none is being edited already }
begin
  inherited;
  AnIDParent := lstNotes.ItemIEN;
  if not StartNewEdit(NT_ACT_ID_ENTRY) then Exit;
  //LoadNotes;
  with tvNotes do Selected := FindPieceNode(IntToStr(AnIDParent), U, Items.GetFirstNode);
  // make sure a visit (time & location) is available before creating the note
  if Encounter.NeedVisit then
  begin
    UpdateVisit(Font.Size, DfltTIULocation);
    frmFrame.DisplayEncounterText;
  end;
  if Encounter.NeedVisit then
  begin
    InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  InsertNewNote(IS_ID_CHILD, AnIDParent);
end;

procedure TfrmNotes.popAddComponentClick(Sender: TObject);
//kt added -- remove later.
var  Subject : string;
begin
  inherited;
  Subject := InputBox('Add Component', 'Enter Title', '');
  if Subject = '' then Exit;
  AddComponentAndSelect(lstNotes.Items[lstNotes.ItemIndex], Subject);
  {MessageDlg('Message from fNotes.popAddcomponentclick....' + CRLF +
             'Until fixed, you should right click and select ' + CRLF +
             'SAVE WITHOUT SIGNATURE right away.' + CRLF +
             'Otherwise, edits will be lost with note change...', mtWarning, [mbOK], 0);
  }             
end;

procedure TfrmNotes.popEditEncounterElementsClick(Sender: TObject);
//kt added entire function 5/16/16
begin
  inherited;
  FDesiredPCEInitialPageEditIndex := CT_HEALTHFACTORS; // Set initial tab to be health factors.
  cmdPCEClick(Sender);  //launch encounter form
end;

procedure TfrmNotes.mnuActAddendClick(Sender: TObject);
{ make an addendum to an existing note }
//kt var
//kt   ActionSts: TActionRec;
//kt   ANoteID: string;
begin
  inherited;
  AddAddendum;  //kt added 4/19/15
  {//kt mod -- Moved block below to AddAddendum()
  if lstNotes.ItemIEN <= 0 then Exit;
  ANoteID := lstNotes.ItemID;
  if not StartNewEdit(NT_ACT_ADDENDUM) then Exit;
  //LoadNotes;
  with tvNotes do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
  if lstNotes.ItemIndex = EditingIndex then
  begin
    InfoBox(TX_ADDEND_NO, TX_ADDEND_MK, MB_OK);
    Exit;
  end;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'MAKE ADDENDUM');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  with lstNotes do if TitleForNote(lstNotes.ItemIEN) = TYP_ADDENDUM then
  begin
    InfoBox(TX_ADDEND_AD, TX_ADDEND_MK, MB_OK);
    Exit;
  end;
  InsertAddendum;
  }
end;

procedure TfrmNotes.AddAddendum;
//kt added function, moving native CPRS code in from mnuActAddendClick(), to allow passing in title
var
  ActionSts: TActionRec;
  ANoteID: string;
begin
  if lstNotes.ItemIEN <= 0 then Exit;
  ANoteID := lstNotes.ItemID;
  if not StartNewEdit(NT_ACT_ADDENDUM) then Exit;
  //LoadNotes;
  with tvNotes do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
  if lstNotes.ItemIndex = EditingIndex then begin
    InfoBox(TX_ADDEND_NO, TX_ADDEND_MK, MB_OK);
    Exit;
  end;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'MAKE ADDENDUM');
  if not ActionSts.Success then begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  with lstNotes do if TitleForNote(lstNotes.ItemIEN) = TYP_ADDENDUM then begin
    InfoBox(TX_ADDEND_AD, TX_ADDEND_MK, MB_OK);
    Exit;
  end;
  InsertAddendum;
end;

function TfrmNotes.AddComponent(ParentData : string; Subject : string = ''; Lines : TStrings = nil) : string;
//kt added entire function, patterned after AddAdendum.
//ParentData: ParentIEN8925^ParentTitle^.... (only first 2 pieces are used)
//Result: returns datastring (IEN is piece#1) of added Addendum or component.  //kt added
var
  ActionSts:           TActionRec;
  //ANoteID:             string;
  ParentIEN :          int64;  //kt
begin
  Result := '0';
  //if lstNotes.ItemIEN <= 0 then Exit;
  //ANoteID := lstNotes.ItemID;
  if not StartNewEdit(NT_ACT_ADDENDUM) then Exit;
  //with tvNotes do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
  //ActOnDocument(ActionSts, lstNotes.ItemIEN, 'MAKE COMPONENT');   //kt custom server-side action.
  ParentIEN := StrToInt64Def(Piece(ParentData, U, 1),0); //kt
  ActOnDocument(ActionSts, ParentIEN, 'MAKE COMPONENT');   //kt custom server-side action.
  if not ActionSts.Success then begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  Result := InsertComponent(ParentData, Subject, Lines);
end;

function TfrmNotes.AddComponentAndSelect(ParentData : string; Subject : string = ''; Lines : TStrings = nil) : string;
//kt added entire function, patterned after AddAdendum.
//ParentData: ParentIEN8925^ParentTitle^.... (only first 2 pieces are used)
//Result: returns datastring (IEN is piece#1) of added Addendum or component.  //kt added
var
  AddedData :          string;
  AddedIENString :     string;
  UnsignedDocsNode :   TORTreeNode;
  AddedNode :          TORTreeNode;
begin
  AddedData := AddComponent(ParentData, Subject, Lines);
  AddedIENString := piece(AddedData, U, 1);
  UnsignedDocsNode := frmNotes.tvNotes.FindPieceNode(IntToStr(NC_UNSIGNED), U);
  AddedNode := tvNotes.FindPieceNode(AddedIENString, 1, U, UnsignedDocsNode);
  if assigned(AddedNode) then begin
    tvNotes.Selected := AddedNode;  //switch to added component.
    tvNotesChange(self, AddedNode);
  end;
  Result := AddedData;
end;

procedure TfrmNotes.mnuActDetachFromIDParentClick(Sender: TObject);
var
  DocID, WhyNot: string;
  Saved: boolean;
  SavedDocID: string;
begin
  if lstNotes.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    LoadNotes;
    with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if not CanBeAttached(PDocTreeObject(tvNotes.Selected.Data)^.DocID, WhyNot) then
    begin
      WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
      WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
      InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
      Exit;
    end;
  if (InfoBox('DETACH:   ' + tvNotes.Selected.Text + CRLF +  CRLF +
              '  FROM:   ' + tvNotes.Selected.Parent.Text + CRLF + CRLF +
              'Are you sure?', TX_DETACH_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES)
      then Exit;
  DocID := PDocTreeObject(tvNotes.Selected.Data)^.DocID;
  SavedDocID := PDocTreeObject(tvNotes.Selected.Parent.Data)^.DocID;
  if DetachEntryFromParent(DocID, WhyNot) then
    begin
      LoadNotes;
      with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
      if tvNotes.Selected <> nil then tvNotes.Selected.Expand(False);
    end
  else
    begin
      WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
      WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
      InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
    end;
end;

procedure TfrmNotes.ExternalSign;  //: TActionRec
//kt 9/11 added
begin
   mnuActSignClick(nil);
end;


procedure TfrmNotes.mnuActSignListClick(Sender: TObject);
{ add the note to the Encounter object, see mnuActSignClick - copied}
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  ActionType, SignTitle: string;
  ActionSts: TActionRec;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then Exit;
  if AllowSignature = False then exit;
  if lstNotes.ItemIndex = EditingIndex then Exit;  // already in signature list
  if not NoteHasText(lstNotes.ItemIEN) then
    begin
      InfoBox(TX_EMPTY_NOTE1, TC_EMPTY_NOTE, MB_OK or MB_ICONERROR);
      Exit;
    end;
  if not LastSaveClean(lstNotes.ItemIEN) and
    (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES) then Exit;
  if CosignDocument(lstNotes.ItemIEN) then
  begin
    SignTitle := TX_COSIGN;
    ActionType := SIG_COSIGN;
  end else
  begin
    SignTitle := TX_SIGN;
    ActionType := SIG_SIGN;
  end;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, ActionType);
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  LockConsultRequestAndNote(lstNotes.ItemIEN);
  with lstNotes do Changes.Add(CH_DOC, ItemID, GetTitleText(ItemIndex), '', CH_SIGN_YES);
end;

procedure TfrmNotes.RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
begin
  if IEN = NT_ADDENDUM then Exit;  // no PCE information entered for an addendum
  // do we need to call DeletePCE(AVisitStr), as was done with NT_NEW_NOTE (ien=-10)???
  if AVisitStr = '' then AVisitStr := VisitStrForNote(IEN);
  Changes.Remove(CH_PCE, 'V' + AVisitStr);
  Changes.Remove(CH_PCE, 'P' + AVisitStr);
  Changes.Remove(CH_PCE, 'D' + AVisitStr);
  Changes.Remove(CH_PCE, 'I' + AVisitStr);
  Changes.Remove(CH_PCE, 'S' + AVisitStr);
  Changes.Remove(CH_PCE, 'A' + AVisitStr);
  Changes.Remove(CH_PCE, 'H' + AVisitStr);
  Changes.Remove(CH_PCE, 'E' + AVisitStr);
  Changes.Remove(CH_PCE, 'T' + AVisitStr);
end;

procedure TfrmNotes.mnuActDeleteClick(Sender: TObject);
{ delete the selected progress note & remove from the Encounter object if necessary }
//kt
var
  DeleteSts : TActionRec;
  //ActionSts: TActionRec;
  SaveConsult, SavedDocIEN: Integer;
  ReasonForDelete, AVisitStr, SavedDocID, x: string;
  //Saved: boolean;
  ErrStr : string;  //kt add 5/16

begin
  inherited;
  SavedDocID := lstNotes.ItemID;
  SavedDocIEN := lstNotes.ItemIEN;
  // suppress prompt for deletion when called from SaveEditedNote (Sender = Self)
  DoDeleteDocument(lstNotes.Items[lstNotes.ItemIndex], lstNotes.ItemIndex, (Sender = Self));  //kt 5/15
  if not DeleteSts.Success then exit;  //kt added
  (*  //kt 5/15 original below.  Moved to DeleteDocument()
  if lstNotes.ItemIEN = 0 then Exit;
  if assigned(frmRemDlg) then
    begin
       frmRemDlg.btnCancelClick(Self);
       if assigned(frmRemDlg) then exit;
    end;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'DELETE RECORD');
  if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then ActionSts.Success := true;  //kt 9/11
  if ShowMsgOn(not ActionSts.Success, ActionSts.Reason, TX_IN_AUTH) then Exit;
  ReasonForDelete := SelectDeleteReason(lstNotes.ItemIEN);
  if ReasonForDelete = DR_CANCEL then Exit;
  // suppress prompt for deletion when called from SaveEditedNote (Sender = Self)
  if (Sender <> Self) and (InfoBox(MakeNoteDisplayText(lstNotes.Items[lstNotes.ItemIndex]) + TX_DEL_OK,
    TX_DEL_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then Exit;
  // Delete attached images  //kt 9/11
  if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then frmImages.DeleteAll(idmDelete);  //kt 9/11
  // do the appropriate locking
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then Exit;
  // retraction notification message
  if JustifyDocumentDelete(lstNotes.ItemIEN) then
     InfoBox(TX_RETRACT, TX_RETRACT_CAP, MB_OK);
  SavedDocID := lstNotes.ItemID;
  SavedDocIEN := lstNotes.ItemIEN;
  if (EditingIndex > -1) and (not FConfirmed) and (lstNotes.ItemIndex <> EditingIndex) and (memNewNote.GetTextLen > 0) then
    begin
      SaveCurrentNote(Saved);
      if not Saved then Exit;
    end;
  EditingIndex := -1;
  FConfirmed := False;
  (*  if Saved then
    begin
      EditingIndex := -1;
      mnuViewClick(Self);
      with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
   end;*)
  // remove the note
  DeleteSts.Success := True;
  x := GetPackageRefForNote(SavedDocIEN);
  SaveConsult := StrToIntDef(Piece(x, ';', 1), 0);
  AVisitStr := VisitStrForNote(SavedDocIEN);
  RemovePCEFromChanges(SavedDocIEN, AVisitStr);
  if (SavedDocIEN > 0) and (lstNotes.ItemIEN = SavedDocIEN) then DeleteDocument(DeleteSts, SavedDocIEN, ReasonForDelete);
  if not Changes.Exist(CH_DOC, SavedDocID) then UnlockDocument(SavedDocIEN);
  Changes.Remove(CH_DOC, SavedDocID);  // this will unlock the document if in Changes
  UnlockConsultRequest(0, SaveConsult);     // note has been deleted, so 1st param = 0
  // reset the display now that the note is gone
  if DeleteSts.Success then
  begin
    DeletePCE(AVisitStr);  // removes PCE data if this was the only note pointing to it
    DBDialogFieldValuesDelete(Patient.DFN, IntToStr(SavedDocIEN), AVisitStr, ErrStr);  //kt 5/16
    if ErrStr <> '' then MessageDlg(ErrStr, mtError, [mbOK], 0); //kt added 5/16
    ClearEditControls;
    //ClearPtData;   WRONG - fixed in v15.10 - RV
    LoadNotes;
  end;
(*    with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
    if tvNotes.Selected <> nil then tvNotesChange(Self, tvNotes.Selected) else
    begin}
    if not (vmEdit in FViewMode) then begin  //kt
      FHTMLEditMode := emNone; //kt 9/11
      pnlWrite.Visible := False;
      pnlRead.Visible := True;
      UpdateReminderFinish;
      ShowPCEControls(False);
      frmDrawers.DisplayDrawers(TRUE, [odTemplates], [odTemplates]); //FALSE);
      ShowPCEButtons(FALSE);
    //end; {if ItemIndex}
    end; //kt
  end {if DeleteSts}
  else InfoBox(DeleteSts.Reason, TX_DEL_ERR, MB_OK or MB_ICONWARNING);
  *)
end;

procedure TfrmNotes.DoDeleteDocument(DataString : string; ItemIndex : integer; NoPrompt : boolean = false);
//kt added, taking from mnuActDeleteClick
var
  DeleteSts, ActionSts:                         TActionRec;
  SaveConsult, SavedDocIEN:                     Integer;
  ReasonForDelete, AVisitStr, SavedDocID, x:    string;
  Saved:                                        boolean;
  IEN :                                         integer;         //kt 5/15
  IENString :                                   string;          //kt 5/15
  i :                                           integer;         //kt 5/15
  ANode :                                       TORTreeNode;     //kt 5/15
  UnsignedDocsNode:                             TORTreeNode;     //kt 5/15
  //NodeForDel :                                  TOrTreeNode;     //kt 5/15
  NoteDisplayText, PromptText:                  string;          //kt 5/15
  NoteIsComponent, ChildDelSuccess:             boolean;         //kt 5/15
  ErrStr :                                      string;          //kt add 5/16

begin
  //kt 5/15 begin mod ---------
  IENString := piece(DataString, U, 1);
  IEN := StrToInt64Def(IENString, 0);
  if IEN <= 0 then Exit;
  NoteIsComponent := IsComponent(IEN, tvNotes);
  NoteDisplayText := MakeNoteDisplayText(DataString);
  UnsignedDocsNode := tvNotes.FindPieceNode(IntToStr(NC_UNSIGNED), U);
  if IsChildOfUnsigned(IEN, UnsignedDocsNode) then begin
    ANode := tvNotes.FindPieceNode(IntToStr(IEN), U, UnsignedDocsNode);
    //ChildDelSuccess := true;
    i := 0;
    while i < ANode.Count do begin
      //ask about deleting with children
      if not NoPrompt then begin
        if InfoBox(NoteDisplayText + TX_DEL_AND_COMPS_OK, TX_DEL_CNF,
                   MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES then Exit;
        NoPrompt := true; //at this point, user has been prompted.
      end;
      ChildDelSuccess := DeleteNodeAndDocAndComps(TORTreeNode(ANode.Item[i]));
      if not ChildDelSuccess then inc (i);
    end;
  end;
  //kt 5/15 end mode ----------
  ActOnDocument(ActionSts, IEN, 'DELETE RECORD');
  if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then ActionSts.Success := true;  //kt 9/11
  if ShowMsgOn(not ActionSts.Success, ActionSts.Reason, TX_IN_AUTH) then Exit;
  ReasonForDelete := SelectDeleteReason(IEN);
  if ReasonForDelete = DR_CANCEL then Exit;
  //kt original --> if not NoPrompt and (InfoBox(MakeNoteDisplayText(DataString) + TX_DEL_OK,
  //kt original -->   TX_DEL_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then Exit;
  PromptText := NoteDisplayText + IfThen(NoteIsComponent, TX_DEL2_OK, TX_DEL_OK);  //kt 5/15
  if not NoPrompt and (InfoBox(PromptText, TX_DEL_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then Exit;  //kt 5/15
  // Delete attached images  //kt 9/11
  if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then frmImages.DeleteAll(idmDelete);  //kt 9/11
  // do the appropriate locking
  if not LockConsultRequestAndNote(IEN) then Exit;
  // retraction notification message
  if JustifyDocumentDelete(IEN) then
     InfoBox(TX_RETRACT, TX_RETRACT_CAP, MB_OK);
  //kt SavedDocID := lstNotes.ItemID;   //kt note ItemID is a dynamic property that returns piece #1 of DataString
  SavedDocID := IENString; //kt
  SavedDocIEN := IEN;
  //kt original --> if (EditingIndex > -1) and (not FConfirmed) and (ItemIndex <> EditingIndex) and (memNewNote.GetTextLen > 0) then begin
  if (EditingIndex > -1) and (not FConfirmed) and (ItemIndex <> EditingIndex) and EditorHasText then begin  //kt mod
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  EditingIndex := -1;
  FConfirmed := False;
  DeleteSts.Success := True;
  x := GetPackageRefForNote(SavedDocIEN);
  SaveConsult := StrToIntDef(Piece(x, ';', 1), 0);
  AVisitStr := VisitStrForNote(SavedDocIEN);
  RemovePCEFromChanges(SavedDocIEN, AVisitStr);
  //DBDialogFieldValuesDelete(Patient.DFN, inttostr(SavedDocIEN), AVisitStr,ErrStr);
  if (SavedDocIEN > 0) and (IEN = SavedDocIEN) then
    DeleteDocument(DeleteSts, SavedDocIEN, ReasonForDelete);
  if not Changes.Exist(CH_DOC, SavedDocID) then UnlockDocument(SavedDocIEN);
  Changes.Remove(CH_DOC, SavedDocID);  // this will unlock the document if in Changes
  UnlockConsultRequest(0, SaveConsult);     // note has been deleted, so 1st param = 0
  if DeleteSts.Success then begin
    // reset the display now that the note is gone
    DeletePCE(AVisitStr);  // removes PCE data if this was the only note pointing to it
    DBDialogFieldValuesDelete(Patient.DFN, IntToStr(SavedDocIEN), AVisitStr, ErrStr);  //kt 5/16
    if ErrStr <> '' then MessageDlg(ErrStr, mtError, [mbOK], 0); //kt added 5/16
    ClearEditControls;
    LoadNotes;
    if not (vmEdit in FViewMode) then begin  //kt
      FHTMLEditMode := emNone; //kt 9/11
      pnlWrite.Visible := False;
      pnlRead.Visible := True;
      UpdateReminderFinish;
      ShowPCEControls(False);
      frmDrawers.DisplayDrawers(TRUE, [odTemplates], [odTemplates]); //FALSE);
      ShowPCEButtons(FALSE);
    end; //kt
  end else begin
    InfoBox(DeleteSts.Reason, TX_DEL_ERR, MB_OK or MB_ICONWARNING);
  end;
end;

function TfrmNotes.DeleteNodeAndDocAndComps(ANode : TORTreeNode) : boolean;
//kt added function 5/15 , copying and trimming from DoDeleteDocument()
//Delete all children that are note components, and then delete node and it's
//  accompanying note on server (provided no remaining children)
//Result: True if deleted, or False if unable to delete, or problem encountered.
//NOTE: It is assumed that user has already given consent, as no prompts are asked
//    during deletion.  ALSO, it is expected that passed ANode doesn't represent
//    node currently being edited.  No update to display takes place.
var
  DataString :                  string;
  DeleteSts, ActionSts:         TActionRec;
  SaveConsult:                  Integer;
  AVisitStr, x:                 string;
  //Saved:                        boolean;
  ReasonForDelete :             string;
  IEN :                         integer;
  IENString :                   string;
  i :                           integer;
  ChildDelSuccess :             boolean;
begin
  Result := True;
  DataString := ANode.StringData;
  IENString := piece(DataString, U, 1);
  IEN := StrToInt64Def(IENString, 0);
  i := 0;
  while i < ANode.Count do begin
    ChildDelSuccess := false;
    if IsComponent(TORTreeNode(ANode.Item[i])) then begin
      ChildDelSuccess := DeleteNodeAndDocAndComps(TORTreeNode(ANode.Item[i]));
    end;
    Result := Result and ChildDelSuccess;
    if not ChildDelSuccess then inc (i);
  end;
  if ANode.HasChildren then Result := false; //all children were not deleted.
  if ShowMsgOn(Result = false, TX_DEL2_ERR, TX_IN_AUTH) then Exit;
  Result := false; //change default to failure;
  if ShowMsgOn(IEN <= 0, TX_BAD_IEN, TX_DEL_ERR) then Exit;
  ActOnDocument(ActionSts, IEN, 'DELETE RECORD');
  if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then ActionSts.Success := true;
  if ShowMsgOn(not ActionSts.Success, ActionSts.Reason, TX_IN_AUTH) then Exit;
  ReasonForDelete := SelectDeleteReason(IEN);
  if ReasonForDelete = DR_CANCEL then Exit;
  if Pos(TX_ATTACHED_IMAGES_SERVER_REPLY, ActionSts.Reason) > 0 then frmImages.DeleteAll(idmDelete);
  // do the appropriate locking
  if not LockConsultRequestAndNote(IEN) then Exit;
  // retraction notification message
  if JustifyDocumentDelete(IEN) then
     InfoBox(TX_RETRACT, TX_RETRACT_CAP, MB_OK);
  FConfirmed := False;
  DeleteSts.Success := True;
  x := GetPackageRefForNote(IEN);
  SaveConsult := StrToIntDef(Piece(x, ';', 1), 0);
  AVisitStr := VisitStrForNote(IEN);
  RemovePCEFromChanges(IEN, AVisitStr);
  DeleteDocument(DeleteSts, IEN, ReasonForDelete);
  if not Changes.Exist(CH_DOC, IENString) then UnlockDocument(IEN);
  Changes.Remove(CH_DOC, IENString);  // this will unlock the document if in Changes
  UnlockConsultRequest(0, SaveConsult);     // note has been deleted, so 1st param = 0
  if DeleteSts.Success then begin
    Result := true;
    KillDocTreeNode(ANode);
  end else begin
    InfoBox(DeleteSts.Reason, TX_DEL_ERR, MB_OK or MB_ICONWARNING);
  end;
end;

procedure TfrmNotes.mnuActEditClick(Sender: TObject);
{ load the selected progress note for editing }
var
  ActionSts: TActionRec;
  ANoteID: string;
  ChangingSaved : boolean;  //kt
begin
  inherited;
  if lstNotes.ItemIndex = EditingIndex then Exit;
  ANoteID := lstNotes.ItemID;
  if not StartNewEdit(NT_ACT_EDIT_NOTE) then Exit;
  //LoadNotes;
  ChangingSaved := uChanging;  uChanging := true; //kt Preventing loading for view before loading for edit (causes flicker)
  with tvNotes do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
  uChanging := ChangingSaved; //kt
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'EDIT RECORD');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  LoadForEdit;
  //Application.ProcessMessages; //kt remove later... for debugging.
end;

procedure TfrmNotes.mnuActSaveClick(Sender: TObject);
{ saves the note that is currently being edited }
var
  Saved: Boolean;
  SavedDocID: string;
begin
  inherited;
  if EditingIndex > -1 then
    begin
      SavedDocID := Piece(lstNotes.Items[EditingIndex], U, 1);
      FLastNoteID := SavedDocID;
      SaveCurrentNote(Saved);
      if Saved and (EditingIndex < 0) and (not FDeleted) then   
      //if Saved then
        begin
          LoadNotes;
          with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
       end;
    end
  else InfoBox(TX_NO_NOTE, TX_SAVE_NOTE, MB_OK or MB_ICONWARNING);
end;

procedure TfrmNotes.mnuActSignClick(Sender: TObject);
{ sign the currently selected note, save first if necessary }
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  Saved, NoteUnlocked: Boolean;
  ActionType, ESCode, SignTitle: string;
  ActionSts, SignSts: TActionRec;
  OK: boolean;
  SavedDocID, tmpItem: string;
  EditingID: string;                                         //v22.12 - RV
  tmpNode: TTreeNode;
  ChildNode : TTreeNode; //kt 5/15
  EditingIsChildComp : boolean;   //kt 5/15  Default is FALSE
begin
  inherited;
  if AllowSignature = False then exit;
  EditingIsChildComp := false;  //kt
(*  if lstNotes.ItemIndex = EditingIndex then                //v22.12 - RV
  begin                                                      //v22.12 - RV
    SaveCurrentNote(Saved);                                  //v22.12 - RV
    if (not Saved) or FDeleted then Exit;                    //v22.12 - RV
  end                                                        //v22.12 - RV
  else if EditingIndex > -1 then                             //v22.12 - RV
    tmpItem := lstNotes.Items[EditingIndex];                 //v22.12 - RV
  SavedDocID := lstNotes.ItemID;*)                           //v22.12 - RV
  SavedDocID := lstNotes.ItemID;                             //v22.12 - RV
  FLastNoteID := SavedDocID;                                 //v22.12 - RV
  if lstNotes.ItemIndex = EditingIndex then                  //v22.12 - RV
  begin                                                      //v22.12 - RV
    SaveCurrentNote(Saved);                                  //v22.12 - RV
    if (not Saved) or FDeleted then Exit;                    //v22.12 - RV
  end                                                        //v22.12 - RV
  else if EditingIndex > -1 then                             //v22.12 - RV
  begin                                                      //v22.12 - RV
    tmpItem := lstNotes.Items[EditingIndex];                 //v22.12 - RV
    EditingID := Piece(tmpItem, U, 1);                       //v22.12 - RV
    ChildNode := tvNotes.FindPieceNode(EditingID, U, tvNotes.Selected);   //kt 5/15
    EditingIsChildComp := IsComponent(TORTreeNode(ChildNode));            //kt 5/15
  end;                                                       //v22.12 - RV
  if not NoteHasText(lstNotes.ItemIEN) then
    begin
      InfoBox(TX_EMPTY_NOTE1, TC_EMPTY_NOTE, MB_OK or MB_ICONERROR);
      Exit;
    end;
  if not LastSaveClean(lstNotes.ItemIEN) and
    (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES) then Exit;
  if CosignDocument(lstNotes.ItemIEN) then
  begin
    SignTitle := TX_COSIGN;
    ActionType := SIG_COSIGN;
  end else
  begin
    SignTitle := TX_SIGN;
    ActionType := SIG_SIGN;
  end;
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then Exit;
  // no exits after things are locked
  NoteUnlocked := False;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, ActionType);
  if ActionSts.Success then
  begin
    OK := IsOK2Sign(uPCEShow, lstNotes.ItemIEN);
    if frmFrame.Closing then exit;
    if(uPCEShow.Updated) then
    begin
      uPCEShow.CopyPCEData(uPCEEdit);
      uPCEShow.Updated := FALSE;
      lstNotesClick(Self);
    end;
    if not AuthorSignedDocument(lstNotes.ItemIEN) then
    begin
      if (InfoBox(TX_AUTH_SIGNED +
          GetTitleText(lstNotes.ItemIndex),TX_SIGN ,MB_YESNO)= ID_NO) then exit;
    end;
    if(OK) then
    begin
      with lstNotes do SignatureForItem(Font.Size, MakeNoteDisplayText(Items[ItemIndex]), SignTitle, ESCode);
      if Length(ESCode) > 0 then
      begin
        SignDocument(SignSts, lstNotes.ItemIEN, ESCode);
        RemovePCEFromChanges(lstNotes.ItemIEN);
        NoteUnlocked := Changes.Exist(CH_DOC, lstNotes.ItemID);
        Changes.Remove(CH_DOC, lstNotes.ItemID);  // this will unlock if in Changes
        if EditingIsChildComp then Changes.Remove(CH_DOC, EditingID); //kt 5/15
        if SignSts.Success then
        begin
          SendMessage(frmConsults.Handle, UM_NEWORDER, ORDER_SIGN, 0);      {*REV*}
          lstNotesClick(Self);
          if DisplayCosignerDialog(lstNotes.ItemIEN) then mnuActIdentifyAddlSignersClick(Self);  //elh  1/30/14
          if GetTMGPSCode(lstNotes.ItemIEN) = 'C' then popNoteMemoLinkToConsultClick(Self);
        end
        else InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end  {if Length(ESCode)}
      else
        NoteUnlocked := Changes.Exist(CH_DOC, lstNotes.ItemID);
    end;
  end
  else InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
  if not NoteUnlocked then UnlockDocument(lstNotes.ItemIEN);
  UnlockConsultRequest(lstNotes.ItemIEN);
  if EditingIsChildComp then begin EditingID := ''; EditingIndex := -1; end; //kt 5/15
  //SetViewContext(FCurrentContext);  //v22.12 - RV
  LoadNotes;                          //v22.12 - RV
  //if EditingIndex > -1 then         //v22.12 - RV
  if (EditingID <> '') then           //v22.12 - RV
    begin
      lstNotes.Items.Insert(0, tmpItem);
      tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, 'Note being edited',
                 MakeNoteTreeObject('EDIT^Note being edited^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'EDIT^Note being edited^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_TOP_LEVEL;
      tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(tmpItem), MakeNoteTreeObject(tmpItem));
      TORTreeNode(tmpNode).StringData := tmpItem;
      SetTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentContext, CT_NOTES);
      EditingIndex := lstNotes.SelectByID(EditingID);                 //v22.12 - RV
    end;
  //with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);  //v22.12 - RV
  with tvNotes do                                                                  //v22.12 - RV
  begin                                                                            //v22.12 - RV
    Selected := FindPieceNode(FLastNoteID, U, Items.GetFirstNode);                 //v22.12 - RV
    if Selected <> nil then
      tvNotesChange(Self, Selected)                                 //v22.12 - RV
    else
      tvNotes.Selected := tvNotes.Items[0]; //first Node in treeview
  end;                                                                             //v22.12 - RV
end;

procedure TfrmNotes.SaveSignItem(const ItemID, ESCode: string);
{ saves and optionally signs a progress note or addendum }
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  AnIndex, IEN, i: Integer;
  Saved, ContinueSign: Boolean;  {*RAB* 8/26/99}
  ActionSts, SignSts: TActionRec;
  APCEObject: TPCEData;
  OK: boolean;
  ActionType, SignTitle: string;
begin
  if AllowSignature = False then exit;
  AnIndex := -1;
  IEN := StrToIntDef(ItemID, 0);
  if IEN = 0 then Exit;
  if frmFrame.TimedOut and (EditingIndex <> -1) then FSilent := True;
  with lstNotes do for i := 0 to Items.Count - 1 do if lstNotes.GetIEN(i) = IEN then
  begin
    AnIndex := i;
    break;
  end;
  if (AnIndex > -1) and (AnIndex = EditingIndex) then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    if FDeleted then
      begin
        FDeleted := False;
        Exit;
      end;
    AnIndex := lstNotes.SelectByIEN(IEN);
    //IEN := lstNotes.GetIEN(AnIndex);                    // saving will change IEN
  end;
  if Length(ESCode) > 0 then
  begin
    if CosignDocument(IEN) then
    begin
      SignTitle := TX_COSIGN;
      ActionType := SIG_COSIGN;
    end else
    begin
      SignTitle := TX_SIGN;
      ActionType := SIG_SIGN;
    end;
    ActOnDocument(ActionSts, IEN, ActionType);
    if not ActionSts.Success then
      begin
        InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
        ContinueSign := False;
      end
    else if not NoteHasText(IEN) then
      begin
        InfoBox(TX_EMPTY_NOTE1, TC_EMPTY_NOTE, MB_OK or MB_ICONERROR);
        ContinueSign := False;
      end
    else if not LastSaveClean(IEN) and
      (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES)
       then ContinueSign := False
    else ContinueSign := True;
    if ContinueSign then
    begin
      if (AnIndex >= 0) and (AnIndex = lstNotes.ItemIndex) then
        APCEObject := uPCEShow
      else
        APCEObject := nil;
      OK := IsOK2Sign(APCEObject, IEN);
      if frmFrame.Closing then exit;
      if(assigned(APCEObject)) and (uPCEShow.Updated) then
      begin
        uPCEShow.CopyPCEData(uPCEEdit);
        uPCEShow.Updated := FALSE;
        lstNotesClick(Self);
      end
      else
        uPCEEdit.Clear;
      if(OK) then
      begin
        //if ((not FSilent) and IsSurgeryTitle(TitleForNote(IEN))) then DisplayOpTop(IEN);
        SignDocument(SignSts, IEN, ESCode);
        if not SignSts.Success then InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK)
        else begin
          if DisplayCosignerDialog(lstNotes.ItemIEN) then mnuActIdentifyAddlSignersClick(Self);  //elh  1/30/14
          if GetTMGPSCode(lstNotes.ItemIEN) = 'C' then popNoteMemoLinkToConsultClick(Self);
        end;
        if not SignSts.Success then InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end; {if OK}
    end; {if ContinueSign}
  end; {if Length(ESCode)}

  UnlockConsultRequest(IEN);
  // GE 14926; added if (AnIndex> -1) to by pass LoadNotes when creating on narking Allerg Entered In error.
  if (AnIndex > -1) and (AnIndex = lstNotes.ItemIndex) and (not frmFrame.ContextChanging) then
    begin
      LoadNotes;
        with tvNotes do Selected := FindPieceNode(IntToStr(IEN), U, Items.GetFirstNode);
    end;
end;

procedure TfrmNotes.popNoteMemoPopup(Sender: TObject);
const FORMAT_MODE : array[false..true] of string = ('Formatted Text','Plain Text');  //kt 8/09
var NoteIsComponent:  boolean;         //kt 5/15
    PopupComp : TObject;               //kt 3/16
begin
  inherited;
  {
  if PopupComponent(Sender, popNoteMemo) is TCustomEdit
    then FEditCtrl := TCustomEdit(PopupComponent(Sender, popNoteMemo))
    else FEditCtrl := nil;
  }
  //kt begin mod  3/16
  PopupComp := PopupComponent(Sender, popNoteMemo);
  if PopupComp is TCustomEdit then begin
    FEditCtrl := TCustomEdit(PopupComp)
  end else begin
    FEditCtrl := nil;
  end;
  popNoteMemoViewHTMLSource.Visible := (vmHTML in FViewMode);

  //kt end mod
  if FEditCtrl <> nil then begin
    popNoteMemoCut.Enabled      := FEditCtrl.SelLength > 0;
    popNoteMemoCopy.Enabled     := popNoteMemoCut.Enabled;
    popNoteMemoPaste.Enabled    := (not TORExposedCustomEdit(FEditCtrl).ReadOnly) and
                                   Clipboard.HasFormat(CF_TEXT);
    popNoteMemoTemplate.Enabled := frmDrawers.CanEditTemplates and popNoteMemoCut.Enabled;
    popNoteMemoFind.Enabled     := FEditCtrl.GetTextLen > 0;
  end else begin
    popNoteMemoHTMLFormat.Enabled := False;  //kt 9/11
    popNoteMemoProcess.Enabled    := False;  //kt 5/1/13
    popNoteMemoCut.Enabled        := False;
    popNoteMemoCopy.Enabled       := False;
    popNoteMemoPaste.Enabled      := False;
    popNoteMemoTemplate.Enabled   := False;
  end;
  NoteIsComponent := IsComponent(TORTreeNode(tvNotes.Selected)); //kt 5/15
  popNoteMemoSign.Enabled := not NoteIsComponent;       //kt 5/15
  popNoteMemoHTMLFormat.Caption := 'Change Edit Mode To ' + FORMAT_MODE[(vmHTML in FViewMode)];  //kt 9/11
  popNoteMemoHTMLFormat.Enabled := pnlWrite.Visible;                                             //kt 9/11
  popNoteMemoProcess.Enabled := pnlWrite.Visible;                                             //kt 5/1/13
  if pnlWrite.Visible then begin
    popNoteMemoSpell.Enabled      := not pnlHTMLWrite.Visible; //kt 9/11
    popNoteMemoGrammar.Enabled    := not pnlHTMLWrite.Visible; //kt 9/11
    popNoteMemoReformat.Enabled   := not pnlHTMLWrite.Visible; //kt 9/11
    //kkt 9/11 popNoteMemoSpell.Enabled    := True;
    //kt 9/11 popNoteMemoGrammar.Enabled  := True;
    //kt 9/11 popNoteMemoReformat.Enabled := True;
    popNoteMemoReplace.Enabled  := (FEditCtrl.GetTextLen > 0);
    popNoteMemoPreview.Enabled  := (frmDrawers.TheOpenDrawer = odTemplates) and Assigned(frmDrawers.tvTemplates.Selected);
    popNoteMemoInsTemplate.Enabled  := (frmDrawers.TheOpenDrawer = odTemplates) and Assigned(frmDrawers.tvTemplates.Selected);
    popNoteMemoViewCslt.Enabled := (FEditNote.PkgPtr = PKG_CONSULTS); // if editing consult title
  end else begin
    popNoteMemoSpell.Enabled    := False;
    popNoteMemoGrammar.Enabled  := False;
    popNoteMemoReformat.Enabled := False;
    popNoteMemoReplace.Enabled  := False;
    popNoteMemoPreview.Enabled  := False;
    popNoteMemoInsTemplate.Enabled  := False;
    popNoteMemoViewCslt.Enabled := FALSE;
  end;
end;

(*//kt 9/11 NOTICE:
  On the form, popNoteMenu was edited to add a new item as below
  popNoteMemoHTMLFormat : TMenuItem
  Captions: ~ Edit as Formatted Text
  OnClick -- popNoteMemoHTMLFormatClick
*)

procedure TfrmNotes.popNoteMemoHTMLFormatClick(Sender: TObject);
//kt 9/11 added
begin
  inherited;
  ToggleHTMLEditMode;
end;



procedure TfrmNotes.popNoteMemoCutClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CutToClipboard;
end;

procedure TfrmNotes.popNoteMemoCopyClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmNotes.popNoteMemoPasteClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.SelText := Clipboard.AsText; {*KCM*}
  //Sendmessage(FEditCtrl.Handle,EM_PASTESPECIAL,CF_TEXT,0);
  frmNotes.pnlWriteResize(Self);
  //FEditCtrl.PasteFromClipboard;        // use AsText to prevent formatting
end;

procedure TfrmNotes.popNoteMemoReformatClick(Sender: TObject);
begin
  inherited;
  if Screen.ActiveControl <> memNewNote then Exit;
  ReformatMemoParagraph(memNewNote);
end;

procedure TfrmNotes.popNoteMemoSaveContinueClick(Sender: TObject);
begin
  inherited;
  FChanged := True;
  DoAutoSave;
end;

procedure TfrmNotes.popNoteMemoFindClick(Sender: TObject);
//var
  //hData: THandle;  //CQ8300
  //pData: ^ClipboardData; //CQ8300
begin
  inherited;
  SendMessage(TRichEdit(popNoteMemo.PopupComponent).Handle, WM_VSCROLL, SB_TOP, 0);
  with dlgFindText do
    begin
      Position := Point(Application.MainForm.Left + pnlLeft.Width, Application.MainForm.Top);
      FindText := '';
      Options := [frDown, frHideUpDown];
{
      //CQ8300
      OpenClipboard(dlgFindText.Handle);
      hData := GetClipboardData(CF_TEXT);
      pData := GlobalLock(hData);
      FindText := pData^.Text;
      GlobalUnlock(hData);
      CloseClipboard;
      //end CQ8300
}
      Execute;
    end;
end;

procedure TfrmNotes.dlgFindTextFind(Sender: TObject);
begin
  dmodShared.FindRichEditText(dlgFindText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmNotes.popNoteMemoReplaceClick(Sender: TObject);
begin
  inherited;
  SendMessage(TRichEdit(popNoteMemo.PopupComponent).Handle, WM_VSCROLL, SB_TOP, 0);
  with dlgReplaceText do
    begin
      Position := Point(Application.MainForm.Left + pnlLeft.Width, Application.MainForm.Top);
      FindText := '';
      ReplaceText := '';
      Options := [frDown, frHideUpDown];
      Execute;
    end;
end;

procedure TfrmNotes.dlgReplaceTextFind(Sender: TObject);
begin
  inherited;
  dmodShared.FindRichEditText(dlgFindText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmNotes.dlgReplaceTextReplace(Sender: TObject);
begin
  inherited;
  dmodShared.ReplaceRichEditText(dlgReplaceText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmNotes.popNoteMemoSpellClick(Sender: TObject);
begin
  inherited;
  DoAutoSave(0);
  timAutoSave.Enabled := False;
  try
    SpellCheckForControl(memNewNote);
  finally
    FChanged := True;
    DoAutoSave(0);
    timAutoSave.Enabled := True;
  end;
end;

procedure TfrmNotes.popNoteMemoGrammarClick(Sender: TObject);
begin
  inherited;
  DoAutoSave(0);
  timAutoSave.Enabled := False;
  try
    GrammarCheckForControl(memNewNote);
  finally
    FChanged := True;
    DoAutoSave(0);
    timAutoSave.Enabled := True;
  end;
end;

procedure TfrmNotes.popNoteMemoViewCsltClick(Sender: TObject);
var
  CsltIEN: integer ;
  ConsultDetail: TStringList;
  x: string;
begin
  inherited;
  if (Screen.ActiveControl <> memNewNote) or (FEditNote.PkgPtr <> PKG_CONSULTS) then Exit;
  CsltIEN := FEditNote.PkgIEN;
  x := FindConsult(CsltIEN);
  ConsultDetail := TStringList.Create;
  try
    LoadConsultDetail(ConsultDetail, CsltIEN) ;
    ReportBox(ConsultDetail, 'Consult Details: #' + IntToStr(CsltIEN) + ' - ' + Piece(x, U, 4), TRUE);
  finally
    ConsultDetail.Free;
  end;
end;

procedure TfrmNotes.popNoteMemoViewHTMLSourceClick(Sender: TObject);
//kt added 3/16
var OK : boolean;
    HTMLText : string;
    frmView : TfrmMemoEdit;
begin
  inherited;
  try
    OK := false;
    if (vmHTML in FViewMode) then begin
      if (vmEdit in FViewMode) then begin
        HTMLText := HtmlEditor.GetFullHTMLText;
        OK := true;
      end else if (vmView in FViewMode) then begin
        HTMLText := HtmlViewer.GetFullHTMLText;
        OK := true;
      end;
    end;
    if OK then begin
      frmView := TfrmMemoEdit.Create(self);
      frmView.memEdit.ReadOnly := false;
      frmView.memEdit.ScrollBars := ssBoth;
      frmView.memEdit.Lines.Text := HTMLText;
      frmView.Caption := 'Note Details';
      frmView.lblMessage.Caption := 'Source code of note.';
      frmView.ShowModal;
    end else begin
      MessageDlg('Can''t get source.', mtError, [mbOK], 0);
    end;
  finally
    frmView.Free;
  end;
end;

procedure TfrmNotes.mnuViewDetailClick(Sender: TObject);
begin
  inherited;
  if lstNotes.ItemIEN <= 0 then Exit;
  mnuViewDetail.Checked := not mnuViewDetail.Checked;
  if mnuViewDetail.Checked then
    begin
      StatusText('Retrieving progress note details...');
      Screen.Cursor := crAppStart;  //kt 9/11, was crHourGlass;
      //kt 9/11 LoadDetailText(memNote.Lines, lstNotes.ItemIEN);
      LoadDetailText(FViewNote, lstNotes.ItemIEN);  //kt 9/11
      SetDisplayToHTMLvsText(FViewMode,FViewNote);  //kt 9/11
      Screen.Cursor := crHourGlass;
      LoadDetailText(memNote.Lines, lstNotes.ItemIEN);
      Screen.Cursor := crDefault;
      StatusText('');
      memNote.SelStart := 0;
      if not (vmHTML in FViewMode) then  //kt 9/11
      memNote.Repaint;
    end
  else
    lstNotesClick(Self);
  if (vmHTML in FViewMode) then begin                        //kt 9/11
    SendMessage(HTMLViewer.Handle, WM_VSCROLL, SB_TOP, 0);   //kt 9/11
  end else begin                                             //kt 9/11
  SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
  end;                                                       //kt 9/11
end;

procedure TfrmNotes.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Saved: Boolean;
  IEN: Int64;
  ErrMsg: string;
  DeleteSts: TActionRec;
begin
  inherited;
  if frmFrame.TimedOut and (EditingIndex <> -1) then
  begin
    FSilent := True;
    //kt 9/11 if memNewNote.GetTextLen > 0 then SaveCurrentNote(Saved)
    if EditorHasText then SaveCurrentNote(Saved)  //kt 9/11
    else
    begin
      IEN := lstNotes.GetIEN(EditingIndex);
      if not LastSaveClean(IEN) then             // means note hasn't been committed yet
      begin
        LockDocument(IEN, ErrMsg);
        if ErrMsg = '' then
        begin
          DeleteDocument(DeleteSts, IEN, '');
          UnlockDocument(IEN);
        end; {if ErrMsg}
      end; {if not LastSaveClean}
    end; {else}
  end; {if frmFrame}
end;

procedure TfrmNotes.IdentifyAddlSigners(NoteIEN : int64; ARefDate: TFMDateTime);
//kt added function 2/17 -- moving code from mnuActIdentifyAddlSignersClick
//kt Reason for splitting code was so that fSingleNote could use this
//   function of a separate document, not in this Notes Tab.
var
  Exclusions: TStrings;
  Saved, x, y: boolean;
  SignerList: TSignerList;
  ActionSts: TActionRec;
  DlgResult : integer;
  SigAction: integer;
  SavedDocID: string;
  //ARefDate: TFMDateTime;
begin
  if NoteIEN = 0 then exit;
  x := CanChangeCosigner(NoteIEN);
  ActOnDocument(ActionSts, NoteIEN, 'IDENTIFY SIGNERS');
  y := ActionSts.Success;
  if x and not y then begin
    DlgResult := InfoBox(ActionSts.Reason + CRLF + CRLF +
               'Would you like to change the cosigner?',
               TX_IN_AUTH, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION);
    if DlgResult = ID_YES then begin
      SigAction := SG_COSIGNER
    end else begin
      exit;
    end;
  end else if y and not x then SigAction := SG_ADDITIONAL
  else if x and y then SigAction := SG_BOTH
  else begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  if not LockConsultRequestAndNote(NoteIEN) then Exit;
  Exclusions := GetCurrentSigners(NoteIEN);
  //ARefDate := StrToFloat(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
  SelectAdditionalSigners(Font.Size, NoteIEN, SigAction, Exclusions, SignerList, CT_NOTES, ARefDate);
  with SignerList do begin
    case SigAction of
      SG_ADDITIONAL:  if Changed and (Signers <> nil) and (Signers.Count > 0) then
                          UpdateAdditionalSigners(NoteIEN, Signers);
      SG_COSIGNER:    if Changed then ChangeCosigner(NoteIEN, Cosigner);
      SG_BOTH:        if Changed then
                          begin
                            if (Signers <> nil) and (Signers.Count > 0) then
                              UpdateAdditionalSigners(NoteIEN, Signers);
                            ChangeCosigner(NoteIEN, Cosigner);
                          end;
    end; //case
    lstNotesClick(Self);
  end;
  UnlockDocument(NoteIEN);
  UnlockConsultRequest(NoteIEN);
end;


procedure TfrmNotes.mnuActIdentifyAddlSignersClick(Sender: TObject);
var
  Exclusions: TStrings;
  Saved, x, y: boolean;
  SignerList: TSignerList;
  ActionSts: TActionRec;
  SigAction: integer;
  SavedDocID: string;
  ARefDate: TFMDateTime;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  if lstNotes.ItemIndex = EditingIndex then begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    LoadNotes;
    with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  ARefDate := StrToFloat(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3)); //kt copied from below.
  IdentifyAddlSigners(lstNotes.ItemIEN, ARefDate);
  { //kt moved to IdentifyAddlSigners 2/22/17
  x := CanChangeCosigner(lstNotes.ItemIEN);
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'IDENTIFY SIGNERS');
  y := ActionSts.Success;
  if x and not y then
    begin
      if InfoBox(ActionSts.Reason + CRLF + CRLF +
                 'Would you like to change the cosigner?',
                 TX_IN_AUTH, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_YES then
        SigAction := SG_COSIGNER
      else
        Exit;
    end
  else if y and not x then SigAction := SG_ADDITIONAL
  else if x and y then SigAction := SG_BOTH
  else
    begin
      InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
      Exit;
    end;

  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then Exit;
  Exclusions := GetCurrentSigners(lstNotes.ItemIEN);
  ARefDate := StrToFloat(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
  SelectAdditionalSigners(Font.Size, lstNotes.ItemIEN, SigAction, Exclusions, SignerList, CT_NOTES, ARefDate);
  with SignerList do
    begin
      case SigAction of
        SG_ADDITIONAL:  if Changed and (Signers <> nil) and (Signers.Count > 0) then
                          UpdateAdditionalSigners(lstNotes.ItemIEN, Signers);
        SG_COSIGNER:    if Changed then ChangeCosigner(lstNotes.ItemIEN, Cosigner);
        SG_BOTH:        if Changed then
                          begin
                            if (Signers <> nil) and (Signers.Count > 0) then
                              UpdateAdditionalSigners(lstNotes.ItemIEN, Signers);
                            ChangeCosigner(lstNotes.ItemIEN, Cosigner);
                          end;
      end;
      lstNotesClick(Self);
    end;
  UnlockDocument(lstNotes.ItemIEN);
  UnlockConsultRequest(lstNotes.ItemIEN);
  }
  lstNotesClick(Self);  //kt added from above
end;

procedure TfrmNotes.popNoteMemoAddlSignClick(Sender: TObject);
begin
  inherited;
  mnuActIdentifyAddlSignersClick(Self);
end;

procedure TfrmNotes.ProcessNotifications;
var
  x: string;
  Saved: boolean;
  tmpNode: TTreeNode;
  AnObject: PDocTreeObject;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  lblNotes.Caption := Notifications.Text;
  tvNotes.Caption := Notifications.Text;
  EditingIndex := -1;
  lstNotes.Enabled := True ;
  pnlRead.BringToFront ;
  //  show ALL unsigned/uncosigned for a patient, not just the alerted one
  //  what about cosignature?  How to get correct list?  ORB FOLLOWUP TYPE = OR alerts only
  x := Notifications.AlertData;
  if StrToIntDef(Piece(x, U, 1), 0) = 0 then
    begin
      InfoBox(TX_NO_ALERT, TX_CAP_NO_ALERT, MB_OK);
      Exit;
    end;
  uChanging := True;
  tvNotes.Items.BeginUpdate;
  lstNotes.Clear;
  KillDocTreeObjects(tvNotes);
  tvNotes.Items.Clear;
  lstNotes.Items.Add(x);
  AnObject := MakeNoteTreeObject('ALERT^Alerted Note^^^^^^^^^^^%^0');
  tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, AnObject.NodeText, AnObject);
  TORTreeNode(tmpNode).StringData := 'ALERT^Alerted Note^^^^^^^^^^^%^0';
  tmpNode.ImageIndex := IMG_TOP_LEVEL;
  AnObject := MakeNoteTreeObject(x);
  tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, AnObject.NodeText, AnObject);
  TORTreeNode(tmpNode).StringData := x;
  SetTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentContext, CT_NOTES);
  tvNotes.Selected := tmpNode;
  tvNotes.Items.EndUpdate;
  uChanging := False;
  tvNotesChange(Self, tvNotes.Selected);
  case Notifications.Followup of
    NF_NOTES_UNSIGNED_NOTE:   ;  //Automatically deleted by sig action!!!
  end;
  if Copy(Piece(Notifications.RecordID, U, 2), 1, 6) = 'TIUADD' then Notifications.Delete;
  if Copy(Piece(Notifications.RecordID, U, 2), 1, 5) = 'TIUID' then Notifications.Delete;
end;

procedure TfrmNotes.SetViewContext(AContext: TTIUContext);
var
  Saved: boolean;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  FCurrentContext := AContext;
  EditingIndex := -1;
  tvNotes.Enabled := True ;
  pnlRead.BringToFront ;
  btnSortNone.Down := true; //kt 3/7/14
  if FCurrentContext.Status <> '' then with uTIUContext do
    begin
      BeginDate      := FCurrentContext.BeginDate;
      EndDate        := FCurrentContext.EndDate;
      FMBeginDate    := FCurrentContext.FMBeginDate;
      FMEndDate      := FCurrentContext.FMEndDate;
      Status         := FCurrentContext.Status;
      Author         := FCurrentContext.Author;
      MaxDocs        := FCurrentContext.MaxDocs;
      ShowSubject    := FCurrentContext.ShowSubject;
      GroupBy        := FCurrentContext.GroupBy;
      SortBy         := FCurrentContext.SortBy;
      ListAscending  := FCurrentContext.ListAscending;
      TreeAscending  := FCurrentContext.TreeAscending;
      Keyword        := FCurrentContext.Keyword;
      SearchField    := FCurrentContext.SearchField;
      Filtered       := FCurrentContext.Filtered;
      Changed        := True;
      mnuViewClick(Self);
    end
  else
    begin
      ViewContext := NC_RECENT ;
      mnuViewClick(Self);
    end;
end;

procedure TfrmNotes.mnuViewSaveAsDefaultClick(Sender: TObject);
const
  TX_NO_MAX =  'You have not specified a maximum number of notes to be returned.' + CRLF +
               'If you save this preference, the result will be that ALL notes for every' + CRLF +
               'patient will be saved as your default view.' + CRLF + CRLF +
               'For patients with large numbers of notes, this could result in some lengthy' + CRLF +
               'delays in loading the list of notes.' + CRLF + CRLF +
               'Are you sure you mean to do this?';
  TX_REPLACE = 'Replace current defaults?';
begin
  inherited;
  if FCurrentContext.MaxDocs = 0 then
     if InfoBox(TX_NO_MAX,'Warning', MB_YESNO or MB_ICONWARNING) = IDNO then
       begin
         mnuViewClick(mnuViewCustom);
         Exit;
       end;
  if InfoBox(TX_REPLACE,'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      SaveCurrentTIUContext(FCurrentContext);
      FDefaultContext := FCurrentContext;
      //lblNotes.Caption := 'Default List';
    end;
end;

procedure TfrmNotes.mnuViewReturntoDefaultClick(Sender: TObject);
begin
  inherited;
  SetViewContext(FDefaultContext);
end;

procedure TfrmNotes.popNoteMemoTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE, FEditCtrl.SelText);
end;

procedure TfrmNotes.popNoteListPopup(Sender: TObject);
begin
  inherited;
  N4.Visible                          := (popNoteList.PopupComponent is TORTreeView);
  popNoteListExpandAll.Visible        := N4.Visible;
  popNoteListExpandSelected.Visible   := N4.Visible;
  popNoteListCollapseAll.Visible      := N4.Visible;
  popNoteListCollapseSelected.Visible := N4.Visible;
end;

procedure TfrmNotes.popNoteListExpandAllClick(Sender: TObject);
begin
  inherited;
  tvNotes.FullExpand;
end;

procedure TfrmNotes.popNoteListCollapseAllClick(Sender: TObject);
begin
  inherited;
  tvNotes.Selected := nil;
  lvNotes.Items.Clear;
  memNote.Clear;
  HTMLViewer.Clear; //kt 9/11
  tvNotes.FullCollapse;
  tvNotes.Selected := tvNotes.TopItem;
end;

procedure TfrmNotes.popNoteListExpandSelectedClick(Sender: TObject);
begin
  inherited;
  if tvNotes.Selected = nil then exit;
  with tvNotes.Selected do if HasChildren then Expand(True);
end;

procedure TfrmNotes.popNoteListCollapseSelectedClick(Sender: TObject);
begin
  inherited;
  if tvNotes.Selected = nil then exit;
  with tvNotes.Selected do if HasChildren then Collapse(True);
end;

procedure TfrmNotes.mnuEditTemplatesClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self);
end;

procedure TfrmNotes.mnuHideTitleClick(Sender: TObject);
begin
  inherited;
  if btnHideTitle.Down = True then btnAddHideClick(Sender)
  else begin
    btnHideTitle.Down := True;
    btnHideTitleClick(Sender);
  end;
end;

procedure TfrmNotes.mnuNewTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE);
end;

procedure TfrmNotes.mnuEditSharedTemplatesClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, FALSE, '', TRUE);
end;

procedure TfrmNotes.mnuNewSharedTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE, '', TRUE);
end;

procedure TfrmNotes.mnuOptionsClick(Sender: TObject);
begin
  inherited;
  mnuEditTemplates.Enabled := frmDrawers.CanEditTemplates;
  mnuNewTemplate.Enabled := frmDrawers.CanEditTemplates;
  mnuEditSharedTemplates.Enabled := frmDrawers.CanEditShared;
  mnuNewSharedTemplate.Enabled := frmDrawers.CanEditShared;
  mnuEditDialgFields.Enabled := CanEditTemplateFields;
end;

procedure TfrmNotes.mnuQuickSearchTemplatesClick(Sender: TObject);
begin
  inherited;
  frmDrawers.HandleLaunchTemplateQuickSearch(Sender);
end;

procedure TfrmNotes.SetEditingIndex(const Value: Integer);
begin
  FEditingIndex := Value;
  if(FEditingIndex < 0) then
    KillReminderDialog(Self);
  if(assigned(frmReminderTree)) then
    frmReminderTree.EnableActions;
end;

function TfrmNotes.CanFinishReminder: boolean;
begin
  if(EditingIndex < 0) then
    Result := FALSE
  else
    Result := (lstNotes.ItemIndex = EditingIndex);
end;

procedure TfrmNotes.FormDestroy(Sender: TObject);
begin
  //kt 911  note: The Images tab will delete all files in .\Cache, which
  //         might include HTMLfilename.  No harm if already deleted.
  FDocList.Free;
  FImageFlag.Free;
  KillDocTreeObjects(tvNotes);
  HtmlEditor.Free; //kt 6/7/09
  HtmlViewer.Free; //kt 6/7/09
  FNotesToHide.Free; //kt 5/12/14
  //9/28/15 frmSearchStop.Free; //kt 9/25/15
  frmWinMessageLog.Free; //kt 8/16
  inherited;
end;

function TfrmNotes.GetDrawers: TFrmDrawers;
begin
  Result := frmDrawers;
end;

procedure TfrmNotes.AssignRemForm;
begin
  //kt 9/11 ReminderDialog interaction has not yet been debugged with HTML formatted text.
  with RemForm do
  begin
    Form := Self;
    PCEObj := uPCEEdit;
    RightPanel := pnlRight;
    CanFinishProc := CanFinishReminder;
    DisplayPCEProc := DisplayPCE;
    Drawers := frmDrawers;
    NewNoteRE := memNewNote;
    NewNoteHTMLE := HTMLEditor;  //kt
    NoteList := lstNotes;
  end;
end;

procedure TfrmNotes.mnuEditDialgFieldsClick(Sender: TObject);
begin
  inherited;
  EditDialogFields;
end;

//===================  Added for sort/search enhancements ======================
procedure TfrmNotes.LoadNotes;
const
  INVALID_ID = -1;
  INFO_ID = 1;
var
  tmpList: TStringList;
  ANode: TORTreeNode;
  x,xx,noteId: integer;   // Text Search CQ: HDS00002856
  Dest: TStrings;  // Text Search CQ: HDS00002856
  KeepFlag: Boolean;  // Text Search CQ: HDS00002856
  NoteCount, NoteMatches: integer;  // Text Search CQ: HDS00002856
begin
  tmpList := TStringList.Create;
  try
    FDocList.Clear;
    uChanging := True;
    RedrawSuspend(memNote.Handle);
    //kt 4/16  RedrawSuspend(HTMLViewer.Handle); //kt 9/11  <-- removed because IE was not refreshing screen when present. 
    RedrawSuspend(lvNotes.Handle);
    tvNotes.Items.BeginUpdate;
    lstNotes.Items.Clear;
    KillDocTreeObjects(tvNotes);
    tvNotes.Items.Clear;
    tvNotes.Items.EndUpdate;
    lvNotes.Items.Clear;
    memNote.Clear;
    HTMLViewer.Clear;                 //kt 9/11
    memNote.Invalidate;
    lblTitle.Caption := '';
    lvNotes.Caption := '';
    with FCurrentContext do begin
      if Status <> IntToStr(NC_UNSIGNED) then begin
        ListNotesForTree(tmpList, NC_UNSIGNED, 0, 0, 0, 0, TreeAscending);
        FilterTitlesForHidden(tmpList); //kt added
        if tmpList.Count > 0 then begin
          CreateListItemsforDocumentTree(FDocList, tmpList, NC_UNSIGNED, GroupBy, TreeAscending, CT_NOTES);
          UpdateTreeView(FDocList, tvNotes);
        end;
        tmpList.Clear;
        FDocList.Clear;
      end;
      if Status <> IntToStr(NC_UNCOSIGNED) then begin
        ListNotesForTree(tmpList, NC_UNCOSIGNED, 0, 0, 0, 0, TreeAscending);
        FilterTitlesForHidden(tmpList); //kt added
        if tmpList.Count > 0 then begin
          CreateListItemsforDocumentTree(FDocList, tmpList, NC_UNCOSIGNED, GroupBy, TreeAscending, CT_NOTES);
          UpdateTreeView(FDocList, tvNotes);
        end;
        tmpList.Clear;
        FDocList.Clear;
      end;
      //TMG added this section  4/9/18
      if Status <> IntToStr(NC_OTHER_UNSIGNED) then begin
        ListNotesForTree(tmpList, NC_OTHER_UNSIGNED, 0, 0, 0, 0, TreeAscending);
        FilterTitlesForHidden(tmpList); //kt added
        if tmpList.Count > 0 then begin
          CreateListItemsforDocumentTree(FDocList, tmpList, NC_OTHER_UNSIGNED, GroupBy, TreeAscending, CT_NOTES);
          UpdateTreeView(FDocList, tvNotes);
        end;
        tmpList.Clear;
        FDocList.Clear;
      end;
      //TMG end addition  4/9/18
      ListNotesForTree(tmpList, StrToIntDef(Status, 0), FMBeginDate, FMEndDate, Author, MaxDocs, TreeAscending);
      FilterTitlesForHidden(tmpList); //kt added
      if btnAdminDocs.Down then FilterTitlesForAdmin(tmpList); //elh added 1/24/17
      CreateListItemsforDocumentTree(FDocList, tmpList, StrToIntDef(Status, 0), GroupBy, TreeAscending, CT_NOTES);
      // Text Search CQ: HDS00002856 ---------------------------------------
      if FCurrentContext.SearchString<>''  then begin  // Text Search CQ: HDS00002856
        NoteMatches := 0;
        Dest:=TStringList.Create;
        NoteCount:=FDocList.Count-1;
        if FDocList.Count>0 then begin
          for x := FDocList.Count-1 downto 1 do begin;  // Don't do 0, because it's informational
            KeepFlag:=False;
            lblNotes.Caption:='Scanning '+IntToStr(NoteCount-x+1)+' of '+IntToStr(NoteCount)+', '+IntToStr(NoteMatches);
            if NoteMatches=1 then lblNotes.Caption:=lblNotes.Caption+' match' else
                                  lblNotes.Caption:=lblNotes.Caption+' matches';
            frmSearchStop.lblSearchStatus.Caption := lblNotes.Caption;
            frmSearchStop.lblSearchStatus.Repaint;
            lblNotes.Repaint;
            // Free up some ticks so they can click the "Stop" button
            application.processmessages;
            application.processmessages;
            application.processmessages;
            if SearchTextStopFlag = False then begin
              noteId := StrToIntDef(Piece(FDocList.Strings[x],'^',1),-1);
              if (noteId = INVALID_ID) or (noteId = INFO_ID) then
                Continue;
              CallV('TIU GET RECORD TEXT', [Piece(FDocList.Strings[x],'^',1)]);
              FastAssign(RPCBrokerV.Results, Dest);
              if Dest.Count > 0 then begin
                for xx := 0 to Dest.Count-1 do begin
                  //Dest.Strings[xx] := StringReplace(Dest.Strings[xx],'#13',' ',[rfReplaceAll, rfIgnoreCase]);
                  if Pos(Uppercase(FCurrentContext.SearchString),Uppercase(Dest.Strings[xx]))>0 then
                    keepflag:=true;
                end;
              end;
              if KeepFlag=False then begin;
                if FDocList.Count >= x then
                  FDocList.Delete(x);
                if (tmpList.Count >= x) and (x > 0) then
                  tmpList.Delete(x-1);
              end else begin
                Inc(NoteMatches);
              end;
            end;
          end;
        end;
        Dest.Free;
      end else
          //Reset the caption
          lblNotes.Caption := SetNoteTreeLabel(FCurrentContext);
      NoteTotal := sCallV('ORCNOTE GET TOTAL', [Patient.DFN]);
      lblNotes.Caption := lblNotes.Caption + ' (Total: ' + NoteTotal + ')';
      // Text Search CQ: HDS00002856 ---------------------------------------
      UpdateTreeView(FDocList, tvNotes);
    end;
    with tvNotes do begin
      uChanging := True;
      tvNotes.Items.BeginUpdate;
      RemoveParentsWithNoChildren(tvNotes, FCurrentContext);  // moved here in v15.9 (RV)
      if FLastNoteID <> '' then
        Selected := FindPieceNode(FLastNoteID, 1, U, nil);
      if Selected = nil then begin
        if (FCurrentContext.GroupBy <> '') or (FCurrentContext.Filtered) then begin
          ANode := TORTreeNode(Items.GetFirstNode);
          while ANode <> nil do begin
            ANode.Expand(False);
            Selected := ANode;
            ANode := TORTreeNode(ANode.GetNextSibling);
          end;
        end else begin
          ANode := tvNotes.FindPieceNode(FCurrentContext.Status, 1, U, nil);
          if ANode <> nil then ANode.Expand(False);
          ANode := tvNotes.FindPieceNode(IntToStr(NC_UNSIGNED), 1, U, nil);
          if ANode = nil then
            ANode := tvNotes.FindPieceNode(IntToStr(NC_UNCOSIGNED), 1, U, nil);
          if ANode = nil then
            ANode := tvNotes.FindPieceNode(FCurrentContext.Status, 1, U, nil);
          if ANode <> nil then begin
            if ANode.getFirstChild <> nil then
                Selected := ANode.getFirstChild
            else
              Selected := ANode;
          end;
        end;
      end;
      memNote.Clear;
      HTMLViewer.Clear; //kt 9/11
      with lvNotes do begin
        Selected := nil;
        if FCurrentContext.SortBy <> '' then
          ColumnToSort := Pos(FCurrentContext.SortBy, 'RDSAL') - 1;
        if not FCurrentContext.ShowSubject then begin
          Columns[1].Width := 2 * (Width div 5);
          Columns[2].Width := 0;
        end else begin
          Columns[1].Width := Width div 5;
          Columns[2].Width := Columns[1].Width;
        end;
      end;
      //RemoveParentsWithNoChildren(tvNotes, FCurrentContext);  // moved FROM here in v15.9 (RV)
      tvNotes.Items.EndUpdate;
      uChanging := False;
      SendMessage(tvNotes.Handle, WM_VSCROLL, SB_TOP, 0);
      if Selected <> nil then tvNotesChange(Self, Selected);
    end;
  finally
    if (vmHTML in FViewMode) then begin   //kt 9/11
      RedrawActivate(HtmlViewer.Handle);  //kt 9/11
    end else begin                        //kt 9/11
      RedrawActivate(memNote.Handle);
    end;                                  //kt 9/11
    RedrawActivate(lvNotes.Handle);
    tmpList.Free;
  end;
end;

procedure TfrmNotes.UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
var UnsignedDocsNode : TORTreeNode; //kt 5/15
begin
  with Tree do begin
    uChanging := True;
    Items.BeginUpdate;
    FastAddStrings(DocList, lstNotes.Items);
    BuildDocumentTree(DocList, '0', Tree, nil, FCurrentContext, CT_NOTES);
    Items.EndUpdate;
    UnsignedDocsNode := Tree.FindPieceNode(IntToStr(NC_UNSIGNED), U);  //kt 5/15 added
    if assigned(UnsignedDocsNode) then UnsignedDocsNode.Expand(true); //kt 5/15 added to expand Unsigned Notes node
    uChanging := False;
  end;
end;

function TfrmNotes.ChildDepth(AParent, Node : TORTreeNode) : Integer;
//kt added function.
//Result: 0 if not a child, 1 if node is child, 2 if grandchild etc.
var AChild : TORTreeNode;
    Count : integer;
begin
  Result := 0;
  if not assigned(AParent) or not assigned(Node) then exit;
  AChild := Node;
  Count := 0;
  while Assigned(AChild.Parent) do begin
    AChild := AChild.Parent;
    inc(Count);
    if AChild.StringData = AParent.StringData then begin
      Result := Count;
      break;
    end;
  end;
end;

procedure TfrmNotes.chkHideAdminClick(Sender: TObject);
begin
  inherited;
   LoadNotes;
end;

function TfrmNotes.IsChildOfUnsigned(Node : TORTreeNode; UnsignedDocsNode: TORTreeNode = nil) : boolean;
//kt added 5/15
var DescendentDepth:          integer;
begin
  Result := false;
  if not assigned(Node) then exit;
  if not assigned(UnsignedDocsNode) then begin
    UnsignedDocsNode := tvNotes.FindPieceNode(IntToStr(NC_UNSIGNED), U);
    if not assigned(UnsignedDocsNode) then exit;
  end;
  DescendentDepth := ChildDepth(UnsignedDocsNode, Node);
  Result := (DescendentDepth > 0);
end;

function TfrmNotes.IsChildOfUnsigned(IEN: int64; UnsignedDocsNode: TORTreeNode = nil) : boolean;
//kt added 5/15
var Node: TORTreeNode;
begin
  Result := false;
  if not assigned(UnsignedDocsNode) then begin
    UnsignedDocsNode := tvNotes.FindPieceNode(IntToStr(NC_UNSIGNED), U);
    if not assigned(UnsignedDocsNode) then exit;
  end;
  Node := tvNotes.FindPieceNode(IntToStr(IEN), U, UnsignedDocsNode);
  Result := IsChildOfUnsigned(Node, UnsignedDocsNode);
end;

function TfrmNotes.HasComponents(Node : TORTreeNode) : boolean;
//kt added 5/15/15
begin
  Result := False;
end;

function TfrmNotes.HasComponents(IEN : int64) : boolean;
//kt added 5/15/15
begin
  Result  := False;
end;

procedure TfrmNotes.tvNotesChange(Sender: TObject; Node: TTreeNode);
var
  x, MySearch, MyNodeID:    string;
  i:                        integer;
  WhyNot:                   string;
  Mode :                    TViewModeSet;  //kt 9/11
  AutoEditPlanned :         boolean;       //kt 5/15
  UnsignedDocsNode:         TORTreeNode;   //kt 5/15
  DescendentDepth:          Integer;       //kt 5/15
begin
  fImages.ListBox := frmNotes.lstNotes;
  if uChanging then Exit;
  //This gives the change a chance to occur when keyboarding, so that WindowEyes
  //doesn't use the old value.
  //kt begin mod block 5/15/15-------
  if (lstNotes.ItemIndex <> -1) and (lstNotes.ItemIndex = EditingIndex) then begin
    DoAutoSave(0); // 5/15
  end;
  btnZoomNormalClick(Sender);  //kt 6/14 
  TVChangePending := true;  //May be used in DoubleClick event handler, as below
  Application.ProcessMessages;  // <--If user Double-Clicked, then handler will be called here.
  TVChangePending := false;
  UnsignedDocsNode := tvNotes.FindPieceNode(IntToStr(NC_UNSIGNED), U);
  DescendentDepth := ChildDepth(UnsignedDocsNode, TORTreeNode(tvNotes.Selected));
  AutoEditPlanned := TVDblClickPending or  //-- sometimes DblClick event gets called first.
                     (DescendentDepth > 1);
  TVDblClickPending := false;
  if AutoEditPlanned then begin
    TVNotesChangeForEdit(Node);  //this skips unneeded intermediary steps.
    Exit;
  end;
  //kt end mod block -------
  with tvNotes do begin
    Application.ProcessMessages;
    with tvNotes do begin
      memNote.Clear;
      HTMLViewer.Clear; //kt 9/11
      if Selected = nil then Exit;
      if uIDNotesActive then begin
        mnuActDetachFromIDParent.Enabled := (Selected.ImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD]);
        popNoteListDetachFromIDParent.Enabled := mnuActDetachFromIDParent.Enabled;
        if (Selected.ImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_ID_CHILD, IMG_ID_CHILD_ADD]) then
          mnuActAttachtoIDParent.Enabled := CanBeAttached(PDocTreeObject(Selected.Data)^.DocID, WhyNot)
        else
          mnuActAttachtoIDParent.Enabled := False;
        popNoteListAttachtoIDParent.Enabled := mnuActAttachtoIDParent.Enabled;
        if (Selected.ImageIndex in [IMG_SINGLE, IMG_PARENT,
                                    IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT,
                                    IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT]) then
          mnuActAddIDEntry.Enabled := CanReceiveAttachment(PDocTreeObject(Selected.Data)^.DocID, WhyNot)
        else
          mnuActAddIDEntry.Enabled := False;
        popNoteListAddIDEntry.Enabled := mnuActAddIDEntry.Enabled
      end;
      RedrawSuspend(lvNotes.Handle);
      RedrawSuspend(memNote.Handle);
      //kt 4/3/16 Below caused view to not recover despite reversal later sometimes.
      //kt  RedrawSuspend(HTMLViewer.Handle); //kt 9/11
      popNoteListExpandSelected.Enabled := Selected.HasChildren;
      popNoteListCollapseSelected.Enabled := Selected.HasChildren;
      x := TORTreeNode(Selected).StringData;
      if (Selected.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then begin
        lvNotes.Visible := True;
        lvNotes.Items.Clear;
        lvNotes.Height := (2 * lvNotes.Parent.Height) div 5;
        with lblTitle do begin
          Caption := Trim(Selected.Text);
          if (FCurrentContext.SearchField <> '') and (FCurrentContext.Filtered) then begin
            case FCurrentContext.SearchField[1] of
              'T': MySearch := 'TITLE';
              'S': MySearch := 'SUBJECT';
              'B': MySearch := 'TITLE or SUBJECT';
            end;
            Caption := Caption + ' where ' + MySearch + ' contains "' + UpperCase(FCurrentContext.Keyword) + '"';
          end;
          lvNotes.Caption := Caption;
        end;

        if Selected.ImageIndex = IMG_TOP_LEVEL then
          MyNodeID := Piece(TORTreeNode(Selected).StringData, U, 1)
        else if Selected.Parent.ImageIndex = IMG_TOP_LEVEL then
          MyNodeID := Piece(TORTreeNode(Selected.Parent).StringData, U, 1)
        else if Selected.Parent.Parent.ImageIndex = IMG_TOP_LEVEL then
          MyNodeID := Piece(TORTreeNode(Selected.Parent.Parent).StringData, U, 1);

        uChanging := True;
        TraverseTree(tvNotes, lvNotes, Selected.GetFirstChild, MyNodeID, FCurrentContext);
        with lvNotes do begin
          for i := 0 to Columns.Count - 1 do
            Columns[i].ImageIndex := IMG_NONE;
          ColumnSortForward := FCurrentContext.ListAscending;
          if ColumnToSort = 5 then ColumnToSort := 0;
          if ColumnSortForward then
            Columns[ColumnToSort].ImageIndex := IMG_ASCENDING
          else
            Columns[ColumnToSort].ImageIndex := IMG_DESCENDING;
          if ColumnToSort = 0 then ColumnToSort := 5;
          AlphaSort;
          Columns[5].Width := 0;
          Columns[6].Width := 0;
        end;
        uChanging := False;
        with lvNotes do begin
          if Items.Count > 0 then begin
            Selected := Items[0];
            lvNotesSelectItem(Self, Selected, True);
          end else begin
            Selected := nil;
            lstNotes.ItemIndex := -1;
            memPCEShow.Clear;
            ShowPCEControls(False);
          end;
        end;
        //kt 9/11 NOTE: At this point the list has changed.  But what is the new note-to-view's format?
        //          We can't just use FViewMode.  Because that just states what mode was used on the last note.
        Mode := [vmView] + [vmHTML_MODE[vmHTML in FViewMode]]; //kt 9/11
        SetDisplayToHTMLvsText(Mode,nil,VIEW_ACTIVATE_ONLY);   //kt 9/11
        //kt 9/11 pnlWrite.Visible := False;
        //kt 9/11 pnlRead.Visible := True;

        //  uncommented next 4 lines in v17.5  (RV)
        //-----------------------------
        UpdateReminderFinish;
        ShowPCEControls(False);
        frmDrawers.DisplayDrawers(TRUE, [odTemplates], [odTemplates]); //FALSE);
        ShowPCEButtons(FALSE);
        //-----------------------------
        //memNote.Clear;
      end else if StrToIntDef(Piece(x, U, 1), 0) > 0 then begin
        memNote.Clear;
        HTMLViewer.Clear; //kt 9/11
        lvNotes.Visible := False;
        lstNotes.SelectByID(Piece(x, U, 1));
        lstNotesClick(Self);    //<-- lots of action takes place here...
      end;
      if (vmHTML in FViewMode) then begin                        //kt 9/11
        SendMessage(HTMLViewer.Handle, WM_VSCROLL, SB_TOP, 0);   //kt 9/11
      end else begin                                             //kt 9/11
        SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
      end;                                                       //kt 9/11
      SendMessage(tvNotes.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
      RedrawActivate(lvNotes.Handle);
      if (vmHTML in FViewMode) then begin           //kt 9/11
        RedrawActivate(HtmlViewer.Handle);          //kt 9/11
      end else begin                                //kt 9/11
        RedrawActivate(memNote.Handle);
      end;                                          //kt 9/11
    end;
  end;
end;

procedure TfrmNotes.TVNotesChangeForEdit(Node : TTreeNode);
//kt added 5/15
//Note: This is a stripped-down copy from tvNotesChange and lstNotesClick,
//   with goal of getting rid of slow and flickering changes when trying
//   to directly edit.  Before, there were multiple state changes and
//   intermediate steps that were not needed.
var IEN, data, x: string;
begin
  if tvNotes.Selected = nil then Exit;
  data := TORTreeNode(tvNotes.Selected).StringData;
  IEN := Piece(data, U, 1);
  if StrToIntDef(IEN, 0) <= 0 then exit;
  lstNotes.SelectByID(IEN);
  if lstNotes.ItemIndex = -1 then Exit;
  UpdateReminderFinish;
  x := 'TIU^' + lstNotes.ItemID;
  SetPiece(x, U, 10, Piece(data, U, 11));
  NotifyOtherApps(NAE_REPORT, x);

  AutoEditCurrent;
end;

procedure TfrmNotes.tvNotesCollapsed(Sender: TObject; Node: TTreeNode);
begin
  with Node do
    begin
      if (ImageIndex in [IMG_GROUP_OPEN, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_OPEN]) then
        ImageIndex := ImageIndex - 1;
      if (SelectedIndex in [IMG_GROUP_OPEN, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_OPEN]) then
        SelectedIndex := SelectedIndex - 1;
    end;
end;

procedure TfrmNotes.tvNotesCustomDraw(Sender: TCustomTreeView; const ARect: TRect; var DefaultDraw: Boolean);
//kt added 6/15
begin
  inherited;
  //tvNotes.Canvas.Brush.Color := clRed;   //kt note <-- is this doing anything??
end;

procedure TfrmNotes.tvNotesCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
//kt added 6/15
  function LeftMatch(SubStr, Str : string) : boolean;
  begin
    Result := (Pos(SubStr, Str) = 1) and (Length (SubStr) <= Length(Str));
  end;

var s, ThisIEN, SelectedIEN, ParentTitle : string;
begin
  inherited;
  if not assigned(Node) then exit;
  //kt if (Node = tvNotes.Selected) then exit;
  if assigned(Node.Parent) then begin
    s := TORTreeNode(Node.Parent).StringData;
    ParentTitle := piece(s, '^',2);
    //if LeftMatch('EDIT^Note being edited', s) then begin
    if (ParentTitle= 'Note being edited')   //kt changes 11/13/16
    or (ParentTitle = 'New Note in Progress')
    or (ParentTitle = 'All unsigned notes') then begin
      tvNotes.Canvas.Brush.Color := clSkyBlue;
      exit;
    end;
    //ELH added to highlight office notes
    if piece(TORTreeNode(Node).StringData,'^',16)='1' then begin
       tvNotes.Canvas.Brush.Color := clTMGHighlight;  //server side set
    end;
  end;
  if not assigned(tvNotes.Selected) then exit;
  SelectedIEN := piece(TORTreeNode(tvNotes.Selected).StringData, '^', 1);
  ThisIEN := piece(TORTreeNode(Node).StringData, '^', 1);
  if ThisIEN = SelectedIEN then begin
    //tvNotes.Canvas.Brush.Color := clSkyBlue;
    tvNotes.Canvas.Brush.Color := clHighlight;
    tvNotes.Canvas.Font.Color := clMenuText;
  end;
end;

procedure TfrmNotes.tvNotesExpanded(Sender: TObject; Node: TTreeNode);

  function SortByTitle(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
  begin
    { Within an ID parent node, sorts in ascending order by title
    BUT - addenda to parent document are always at the top of the sort, in date order}
    if (Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum') and
       (Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum') then
      begin
        Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
      end
    else if Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := -1
    else if Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := 1
    else
      begin
        if Data = 0 then
          Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocTitle),
                                  PChar(PDocTreeObject(Node2.Data)^.DocTitle))
        else
          Result := -AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocTitle),
                                  PChar(PDocTreeObject(Node2.Data)^.DocTitle));
      end
  end;

  function SortByDate(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
  begin
    { Within an ID parent node, sorts in ascending order by document date
    BUT - addenda to parent document are always at the top of the sort, in date order}
    if (Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum') and
       (Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum') then
      begin
        Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
      end
    else if Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := -1
    else if Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := 1
    else
      begin
        if Data = 0 then
          Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                  PChar(PDocTreeObject(Node2.Data)^.DocFMDate))
        else
          Result := -AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                  PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
      end;
  end;

begin
  with Node do
    begin
      if Assigned(Data) then
        if (Pos('<', PDocTreeObject(Data)^.DocHasChildren) > 0) then
          begin
            if (PDocTreeObject(Node.Data)^.OrderByTitle) then
              CustomSort(@SortByTitle, 0)
            else
              CustomSort(@SortByDate, 0);
          end;
      if (ImageIndex in [IMG_GROUP_SHUT, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_SHUT]) then
        ImageIndex := ImageIndex + 1;
      if (SelectedIndex in [IMG_GROUP_SHUT, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_SHUT]) then
        SelectedIndex := SelectedIndex + 1;
    end;
end;

procedure TfrmNotes.tvNotesClick(Sender: TObject);
begin
(*  if tvNotes.Selected = nil then exit;
  if (tvNotes.Selected.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then
    begin
      uChanging := True;
      lvNotes.Selected := nil;
      uChanging := False;
      memNote.Clear;
    end;*)
end;

procedure TfrmNotes.tvNotesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  AnItem: TORTreeNode;
begin
  Accept := False;
  if not uIDNotesActive then exit;
  AnItem := TORTreeNode(tvNotes.GetNodeAt(X, Y));
  if (AnItem = nil) or (AnItem.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) then Exit;
  with tvNotes.Selected do
    if (ImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_ID_CHILD, IMG_ID_CHILD_ADD]) then
      Accept := (AnItem.ImageIndex in [IMG_SINGLE, IMG_PARENT,
                                       IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT,
                                       IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT])
    else if (ImageIndex in [IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT]) then
      Accept := (AnItem.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL])
    else if (ImageIndex in [IMG_ADDENDUM, IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) then
      Accept := False;
end;

function TfrmNotes.tvIndexOfIEN(IEN : string) : integer;
//kt 4/17/15
var i : integer;
    IndexIEN : string;
begin
  Result := -1;
  for i := 0 to lstNotes.Items.Count - 1 do begin
    IndexIEN := piece(lstNotes.Items[i],'^',1);
    if IndexIEN <> IEN then continue;
    Result := i;
    break;
  end;
end;

function TfrmNotes.tvIndexOfNode(Node : TORTreeNode) : integer;
//kt 4/17/15
  var IEN : string;
begin
  IEN := '';
  if Node <> nil then IEN := piece(Node.StringData,'^',1);
  Result := tvIndexOfIEN(IEN);
end;

procedure TfrmNotes.tvNotesDblClick(Sender: TObject);
//kt 4/17/15 added entire function
//NOTE: tvNotesChange() is called BEFORE this function.   Then, in that
//     function, application.processmessages is called, which causes
//    this function to be called before tvNotesChange() has finished.
begin
  inherited;
  if TMGLoadingForEdit then exit;
  if TVChangePending then begin  //Called here from a TVChange event.
    TVDblClickPending := true;
    //AutoEditCurrent() will be called form Change event.
  end else begin
    AutoEditCurrent
  end;
end;

procedure TfrmNotes.AutoEditCurrent;
begin
  if tvNotes.Selected = nil then exit;
  //if lstNotes.ItemIndex = EditingIndex then exit;
  TMGForceSaveSwitchEdit := true;
  EditingIndex := -1;
  mnuActEditClick(nil);
end;


procedure TfrmNotes.tvNotesDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  HT: THitTests;
  Saved: boolean;
  ADestNode: TORTreeNode;
begin
  if not uIDNotesActive then
    begin
      CancelDrag;
      exit;
    end;
  if tvNotes.Selected = nil then exit;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  HT := tvNotes.GetHitTestInfoAt(X, Y);
  ADestNode := TORTreeNode(tvNotes.GetNodeAt(X, Y));
  DoAttachIDChild(TORTreeNode(tvNotes.Selected), ADestNode);
end;

procedure TfrmNotes.tvNotesStartDrag(Sender: TObject; var DragObject: TDragObject);
const
  TX_CAP_NO_DRAG = 'Item cannot be moved';
  TX_NO_EDIT_DRAG = 'Items can not be dragged while a note is being edited.';
var
  WhyNot: string;
  //Saved: boolean;
begin
  if EditingIndex <> -1 then
  begin
    InfoBox(TX_NO_EDIT_DRAG, TX_CAP_NO_DRAG, MB_ICONERROR or MB_OK);
    CancelDrag;
    Exit;
  end;
  if (tvNotes.Selected.ImageIndex in [IMG_ADDENDUM, IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) or
     (not uIDNotesActive) or
     (lstNotes.ItemIEN = 0) then
    begin
      CancelDrag;
      Exit;
    end;
(*  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;*)
  if not CanBeAttached(PDocTreeObject(tvNotes.Selected.Data)^.DocID, WhyNot) then
    begin
      InfoBox(WhyNot, TX_CAP_NO_DRAG, MB_OK);
      CancelDrag;
    end;
end;

//=====================  Listview events  =================================

procedure TfrmNotes.lvNotesColumnClick(Sender: TObject; Column: TListColumn);
var
  i, ClickedColumn: Integer;
begin
  if Column.Index = 0 then ClickedColumn := 5 else ClickedColumn := Column.Index;
  if ClickedColumn = ColumnToSort then
    ColumnSortForward := not ColumnSortForward
  else
    ColumnSortForward := True;
  for i := 0 to lvNotes.Columns.Count - 1 do
    lvNotes.Columns[i].ImageIndex := IMG_NONE;
  if ColumnSortForward then lvNotes.Columns[Column.Index].ImageIndex := IMG_ASCENDING
  else lvNotes.Columns[Column.Index].ImageIndex := IMG_DESCENDING;
  ColumnToSort := ClickedColumn;
  case ColumnToSort of
    5:  FCurrentContext.SortBy := 'R';
    1:  FCurrentContext.SortBy := 'D';
    2:  FCurrentContext.SortBy := 'S';
    3:  FCurrentContext.SortBy := 'A';
    4:  FCurrentContext.SortBy := 'L';
  else
    FCurrentContext.SortBy := 'R';
  end;
  FCurrentContext.ListAscending := ColumnSortForward;
  (Sender as TCustomListView).AlphaSort;
  //with lvNotes do if Selected <> nil then Scroll(0,  Selected.Top - TopItem.Top);
end;

procedure TfrmNotes.lvNotesCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else begin
   ix := ColumnToSort - 1;
   Compare := CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
  end;
  if not ColumnSortForward then Compare := -Compare;
end;

procedure TfrmNotes.lvNotesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if uChanging or (not Selected) then Exit;
  with lvNotes do
    begin
      StatusText('Retrieving selected progress note...');
      lstNotes.SelectByID(Item.SubItems[5]);
      lstNotesClick(Self);
      if (vmHTML in FViewMode) then begin                        //kt 9/11
        SendMessage(HTMLViewer.Handle, WM_VSCROLL, SB_TOP, 0);   //kt 9/11
      end else begin                                             //kt 9/11
      SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
      end;                                                       //kt 9/11
    end;
end;

procedure TfrmNotes.lvNotesResize(Sender: TObject);
begin
  inherited;
  with lvNotes do
    begin
      if not FCurrentContext.ShowSubject then
        begin
          Columns[1].Width := 2 * (Width div 5);
          Columns[2].Width := 0;
        end
      else
        begin
          Columns[1].Width := Width div 5;
          Columns[2].Width := Columns[1].Width;
        end;
    end;
end;

procedure TfrmNotes.EnableDisableIDNotes;
begin
  uIDNotesActive := IDNotesInstalled;
  mnuActDetachFromIDParent.Visible := uIDNotesActive;
  popNoteListDetachFromIDParent.Visible := uIDNotesActive;
  mnuActAddIDEntry.Visible := uIDNotesActive;
  popNoteListAddIDEntry.Visible := uIDNotesActive;
  mnuActAttachtoIDParent.Visible := uIDNotesActive;
  popNoteListAttachtoIDParent.Visible := uIDNotesActive;
  if uIDNotesActive then
    tvNotes.DragMode := dmAutomatic
  else
    tvNotes.DragMode := dmManual;
end;

procedure TfrmNotes.ShowPCEButtons(Editing: boolean);
begin
  if frmFrame.Timedout then Exit;

  FEditingNotePCEObj := Editing;
  if Editing or AnytimeEncounters then
  begin
    cmdPCE.Visible := TRUE;
    if Editing then
    begin
      cmdPCE.Enabled := CanEditPCE(uPCEEdit);
      cmdNewNote.Visible := AnytimeEncounters;
      cmdNewNote.Enabled := FALSE;
    end
    else
    begin
      cmdPCE.Enabled     := (GetAskPCE(0) <> apDisable);
      cmdNewNote.Visible := TRUE;
      cmdNewNote.Enabled := (FStarting = False); //TRUE;
    end;
    if cmdNewNote.Visible then
      cmdPCE.Top := cmdNewNote.Top-cmdPCE.Height;
  end
  else
  begin
    cmdPCE.Enabled := FALSE;
    cmdPCE.Visible := FALSE;
    cmdNewNote.Visible := TRUE;
    cmdNewNote.Enabled := (FStarting = False); //TRUE;
  end;
  if cmdPCE.Visible then
    lblSpace1.Top := cmdPCE.Top - lblSpace1.Height
  else
    lblSpace1.Top := cmdNewNote.Top - lblSpace1.Height;
  popNoteMemoEncounter.Enabled := cmdPCE.Enabled;
  popNoteMemoEncounter.Visible := cmdPCE.Visible;
end;

procedure TfrmNotes.mnuIconLegendClick(Sender: TObject);
begin
  inherited;
  ShowIconLegend(ilNotes);
end;

procedure TfrmNotes.mnuActAttachtoIDParentClick(Sender: TObject);
var
  AChildNode: TORTreeNode;
  AParentID: string;
  SavedDocID: string;
  Saved: boolean;
begin
  inherited;
  if not uIDNotesActive then exit;
  if lstNotes.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    LoadNotes;
    with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if tvNotes.Selected = nil then exit;
  AChildNode := TORTreeNode(tvNotes.Selected);
  AParentID := SelectParentNodeFromList(tvNotes);
  if AParentID = '' then exit;
  with tvNotes do Selected := FindPieceNode(AParentID, 1, U, Items.GetFirstNode);
  DoAttachIDChild(AChildNode, TORTreeNode(tvNotes.Selected));
end;

procedure TfrmNotes.DoAttachIDChild(AChild, AParent: TORTreeNode);
const
  TX_ATTACH_CNF     = 'Confirm Attachment';
  TX_ATTACH_FAILURE = 'Attachment failed';
var
  ErrMsg, WhyNot: string;
  SavedDocID: string;
begin
  if (AChild = nil) or (AParent = nil) then exit;
  ErrMsg := '';
  if not CanBeAttached(PDocTreeObject(AChild.Data)^.DocID, WhyNot) then
    ErrMsg := ErrMsg + WhyNot + CRLF + CRLF;
  if not CanReceiveAttachment(PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
    ErrMsg := ErrMsg + WhyNot;
  if ErrMsg <> '' then
    begin
      InfoBox(ErrMsg, TX_ATTACH_FAILURE, MB_OK);
      Exit;
    end
  else
    begin
      WhyNot := '';
      if (InfoBox('ATTACH:   ' + AChild.Text + CRLF + CRLF +
                  '    TO:   ' + AParent.Text + CRLF + CRLF +
                  'Are you sure?', TX_ATTACH_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES)
          then Exit;
      SavedDocID := PDocTreeObject(AParent.Data)^.DocID;
    end;
  if AChild.ImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD] then
    begin
      if DetachEntryFromParent(PDocTreeObject(AChild.Data)^.DocID, WhyNot) then
        begin
          if AttachEntryToParent(PDocTreeObject(AChild.Data)^.DocID, PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
            begin
              LoadNotes;
              with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
              if tvNotes.Selected <> nil then tvNotes.Selected.Expand(False);
            end
          else
            InfoBox(WhyNot, TX_ATTACH_FAILURE, MB_OK);
        end
      else
        begin
          WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
          WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
          InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
          Exit;
        end;
    end
  else
    begin
      if AttachEntryToParent(PDocTreeObject(AChild.Data)^.DocID, PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
        begin
          LoadNotes;
          with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
          if tvNotes.Selected <> nil then tvNotes.Selected.Expand(False);
        end
      else
        InfoBox(WhyNot, TX_ATTACH_FAILURE, MB_OK);
   end;
end;

function TfrmNotes.SetNoteTreeLabel(AContext: TTIUContext): string;
var
  x: string;

  function SetDateRangeText(AContext: TTIUContext): string;
  var
    x1: string;
  begin
    with AContext do
      if BeginDate <> '' then
        begin
          x1 := ' from ' + UpperCase(BeginDate);
          if EndDate <> '' then x1 := x1 + ' to ' + UpperCase(EndDate)
          else x1 := x1 + ' to TODAY';
        end;
    Result := x1;
  end;

begin
  with AContext do
    begin
      if MaxDocs > 0 then x := 'Last ' + IntToStr(MaxDocs) + ' ' else x := 'All ';
      case StrToIntDef(Status, 0) of
        NC_ALL        : x := x + 'Signed Notes';
        NC_UNSIGNED   : begin
                          x := x + 'Unsigned Notes for ';
                          if Author > 0 then x := x + ExternalName(Author, 200)
                          else x := x + User.Name;
                          x := x + SetDateRangeText(AContext);
                        end;
        NC_UNCOSIGNED : begin
                          x := x + 'Uncosigned Notes for ';
                          if Author > 0 then x := x + ExternalName(Author, 200)
                          else x := x + User.Name;
                          x := x + SetDateRangeText(AContext);
                        end;
        NC_BY_AUTHOR  : x := x + 'Signed Notes for ' + ExternalName(Author, 200) + SetDateRangeText(AContext);
        NC_BY_DATE    : x := x + 'Signed Notes ' + SetDateRangeText(AContext);
      else
        x := 'Custom List';
      end;
    end;
  Result := x;
end;

procedure TfrmNotes.memNewNoteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_OEM_2) and (Shift = [ssCtrl]) then begin   //kt added block 10/2014
    //Handle "Ctrl-/"
    Self.GetDrawers.HandleLaunchTemplateQuickSearch(Sender);
    memNewNote.SetFocus;
  end;
  FNavigatingTab := (Key = VK_TAB) and ([ssShift,ssCtrl] * Shift <> []);
  if FNavigatingTab then
    Key := 0;
end;

procedure TfrmNotes.UpdateNoteAuthor(DocInfo: string);
const
  TX_INVALID_AUTHOR1 = 'The author returned by the template (';
  TX_INVALID_AUTHOR2 = ') is not valid.' + #13#10 + 'The note''s author will remain as ';
  TC_INVALID_AUTHOR  = 'Invalid Author';
  TX_COSIGNER_REQD   = ' requires a cosigner for this note.';
  TC_COSIGNER_REQD   = 'Cosigner Required';
var
  NewAuth, NewAuthName, AuthNameCheck, x: string;
  ADummySender: TObject;
begin
  if DocInfo = '' then Exit;
  NewAuth := GetXMLParamReturnValueTIU(DocInfo, 'AUTHOR_IEN');
  if NewAuth = '' then Exit;
  AuthNameCheck := ExternalName(StrToInt64Def(NewAuth, 0), 200);
  if AuthNameCheck = '' then
  begin
    NewAuthName := GetXMLParamReturnValueTIU(DocInfo, 'AUTHOR_NAME');
    InfoBox(TX_INVALID_AUTHOR1 + UpperCase(NewAuthName) +  TX_INVALID_AUTHOR2 + UpperCase(FEditNote.AuthorName),
            TC_INVALID_AUTHOR, MB_OK and MB_ICONERROR);
    Exit;
  end;
  with FEditNote do if StrToInt64Def(NewAuth, 0) <> Author then
  begin
    Author := StrToInt64Def(NewAuth, 0);
    AuthorName := AuthNameCheck;
    x := lstNotes.Items[EditingIndex];
    SetPiece(x, U, 5, NewAuth + ';' + AuthNameCheck);
    lstNotes.Items[EditingIndex] := x;
    if AskCosignerForTitle(Title, Author, DateTime) then
    begin
      InfoBox(UpperCase(AuthNameCheck) + TX_COSIGNER_REQD, TC_COSIGNER_REQD, MB_OK);
      //Cosigner := 0;   CosignerName := '';  // not sure about this yet
      ADummySender := TObject.Create;
      try
        cmdChangeClick(ADummySender);
      finally
        FreeAndNil(ADummySender);
      end;
    end
    else cmdChangeClick(Self);
  end;
end;

procedure TfrmNotes.sptHorzCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if pnlWrite.Visible then
     if NewSize > frmNotes.ClientWidth - memNewNote.Constraints.MinWidth - sptHorz.Width then
        NewSize := frmNotes.ClientWidth - memNewNote.Constraints.MinWidth - sptHorz.Width;
end;

procedure TfrmNotes.popNoteMemoInsTemplateClick(Sender: TObject);
begin
  frmDrawers.mnuInsertTemplateClick(Sender);
end;

procedure TfrmNotes.popNoteMemoLinkToConsultClick(Sender: TObject);
(*
var
   PendingConsultList : TStringList;
   RPCResult : string;
   Response : integer;
   Messagetext: string;
*)
begin
  inherited;
  if lstNotes.ItemIEN = 0 then begin
    ShowMsg('No note selected');
    exit;
  end;
  fConsultLink.LinkConsult(lstNotes.ItemIEN);
end;

procedure TfrmNotes.popNoteMemoPreviewClick(Sender: TObject);
begin
  frmDrawers.mnuPreviewTemplateClick(Sender);
end;

procedure TfrmNotes.popNoteMemoProcessClick(Sender: TObject);
//kt added entire function    5/1/13
var ProcessedNote : TStrings;  //pointer to other objects
    OriginalNote : TStringList;
    ErrMsg:string;
begin
  inherited;
  if not boolAutosaving then DoAutoSave;      //elh added 1/15/18
  //What call will properly save text for Processing Note????
  //PutTextOnly(ErrMsg, memNewNote.Lines, lstNotes.GetIEN(EditingIndex));
  OriginalNote := TStringList.Create;
  if (vmHTML in FViewMode) then begin
    SplitHTMLToArray(WrapHTML(GetEditorHTMLText), OriginalNote);
    //breaks image paths - should not be necessary HTMLTools.InsertSubs(OriginalNote);
    ProcessedNote := ProcessNote(OriginalNote,GetCurrentNoteIEN);
    HtmlEditor.HTMLText := ProcessedNote.Text;
    GLOBAL_HTMLTemplateDialogsMgr.SyncFromHTMLDocument(HtmlEditor); //later I can embed this functionality in THtmlObj
  end else begin
    OriginalNote.Assign(memNewNote.Lines);
    ProcessedNote := ProcessNote(OriginalNote,GetCurrentNoteIEN);
    memNewNote.Lines.Assign(ProcessedNote);
  end;
  OriginalNote.Free;
end;

function TfrmNotes.ProcessNote(Lines : TStrings;NoteIEN: String): TStrings;
//kt added entire function    5/1/13
var
  ErrStr : string;
begin
  Result := nil;
  if MessageDlg('Are you sure you want to process this note?'+#13#10+
                'This cannot be undone.', mtConfirmation,[mbYes,mbNo],0) <> mrYes then exit;
  Result := TMGProcessNote(Lines, NoteIEN, ErrStr);
  if ErrStr <> '' then MessageDlg('Error Processing Note: ' + ErrStr, mtError, [mbOK],0);
end;

function TfrmNotes.HandleMacro(MacroName : string) : string;
//kt added entire function    10/16/14
var NoteText : TStringList;
begin
  NoteText := TStringList.Create;
  if (vmHTML in FViewMode) then begin
    SplitHTMLToArray(WrapHTML(GetEditorHTMLText), NoteText);
    //breaks image paths - should not be necessary HTMLTools.InsertSubs(OriginalNote);
  end else begin
    NoteText.Assign(memNewNote.Lines);
  end;
  Result := ResolveMacro(MacroName, NoteText);
  NoteText.Free;
end;

function TfrmNotes.ResolveMacro(MacroName: string; Lines : TStrings): string;
//kt added entire function    10/16/14
//This will upload current note being edited, and expect back a snippet that comprises macro result
var
  //RPCResult : string;
  //i : integer;
  ErrStr : string;
begin
  Result := TMGResolveMacro(MacroName, Lines, ErrStr);
  if ErrStr <> '' then MessageDlg('Error executing macro : ' + ErrStr, mtError, [mbOK], 0);
  (* //delete later.  moved RPC calls to rTIU
  RPCBrokerV.remoteprocedure := 'TMG CPRS MACRO RESOLVE';
  RPCBrokerV.Param[0].Value := '.X';  // not used
  RPCBrokerV.param[0].ptype := list;
  RPCBrokerV.Param[0].Mult['"NAME"'] := MacroName;
  RPCBrokerV.Param[0].Mult['"DFN"'] := Patient.DFN;
  for i := 0 to Lines.Count-1 do begin
    RPCBrokerV.Param[0].Mult['"TEXT",' + IntToStr(i+1)] := Lines.Strings[i];
  end;
  CallBroker;
  RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
  if piece(RPCResult,'^',1)='-1' then begin
    MessageDlg('Error executing macro : ' + Piece(RPCResult,'^',2),mtError,[mbOK],0);
    Result := '[Error with macro: '+MacroName+']';
  end else begin
    //success - return result
    RPCBrokerV.Results.Delete(0);
    Result := RPCBrokerV.Results.Text;
  end;
  *)
end;

{Tab Order tricks.  Need to change
  tvNotes

  frmDrawers.pnlTemplateButton
  frmDrawers.pnlEncounterButton
  cmdNewNote
  cmdPCE

  lvNotes
  memNote

to
  tvNotes

  lvNotes
  memNote

  frmDrawers.pnlTemplateButton
  frmDrawers.pnlEncounterButton
  cmdNewNote
  cmdPCE
}

procedure TfrmNotes.tvNotesExit(Sender: TObject);
begin
  if TabIsPressed or ShiftTabIsPressed then
  begin
    if (Screen.ActiveControl = frmDrawers.pnlTemplatesButton) or
        (Screen.ActiveControl = frmDrawers.pnlEncounterButton) or
        (Screen.ActiveControl = cmdNewNote) or
        (Screen.ActiveControl = cmdPCE) then
      FindNextControl( cmdPCE, True, True, False).SetFocus;
  end;
end;

procedure TfrmNotes.pnlReadExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed or ShiftTabIsPressed then
  begin
    if (Screen.ActiveControl = frmFrame.pnlPatient) then
      FindNextControl( tvNotes, True, True, False).SetFocus
    else
    if (Screen.ActiveControl = frmDrawers.pnlTemplatesButton) or
        (Screen.ActiveControl = frmDrawers.pnlEncounterButton) or
        (Screen.ActiveControl = cmdNewNote) or
        (Screen.ActiveControl = cmdPCE) then
      FindNextControl( frmDrawers.pnlTemplatesButton, False, True, False).SetFocus;
  end;
end;

procedure TfrmNotes.cmdNewNoteExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed or ShiftTabIsPressed then
  begin
    if (Screen.ActiveControl = lvNotes) or
        (Screen.ActiveControl = memNote) then
      frmFrame.pnlPatient.SetFocus
    else
    if (Screen.ActiveControl = tvNotes) then
      FindNextControl( frmFrame.pnlPatient, False, True, False).SetFocus;
  end;
end;

procedure TfrmNotes.frmFramePnlPatientExit(Sender: TObject);
begin
  FOldFramePnlPatientExit(Sender);
  if TabIsPressed or ShiftTabIsPressed then
  begin
    if (Screen.ActiveControl = lvNotes) or
        (Screen.ActiveControl = memNote) then
      FindNextControl( lvNotes, False, True, False).SetFocus;
    if Screen.ActiveControl = memPCEShow then
      if cmdPCE.CanFocus then
        cmdPCE.SetFocus
      else if cmdNewNote.CanFocus then
        cmdNewNote.SetFocus;
  end;
end;

procedure TfrmNotes.FormHide(Sender: TObject);
begin
  inherited;
  frmFrame.pnlPatient.OnExit := FOldFramePnlPatientExit;
  frmDrawers.pnlTemplatesButton.OnExit := FOldDrawerPnlTemplatesButtonExit;
  frmDrawers.pnlEncounterButton.OnExit := FOldDrawerPnlEncounterButtonExit;
  frmDrawers.edtSearch.OnExit := FOldDrawerEdtSearchExit;
end;

procedure TfrmNotes.FormShow(Sender: TObject);
begin
  inherited;
  boolAutosaving := False;    //elh  11/18/16
  FOldFramePnlPatientExit := frmFrame.pnlPatient.OnExit;
  frmFrame.pnlPatient.OnExit := frmFramePnlPatientExit;
  FOldDrawerPnlTemplatesButtonExit := frmDrawers.pnlTemplatesButton.OnExit;
  frmDrawers.pnlTemplatesButton.OnExit := frmDrawerPnlTemplatesButtonExit;
  FOldDrawerPnlEncounterButtonExit := frmDrawers.pnlEncounterButton.OnExit;
  frmDrawers.pnlEncounterButton.OnExit := frmDrawerPnlEncounterButtonExit;
  FOldDrawerEdtSearchExit := frmDrawers.edtSearch.OnExit;
  frmDrawers.edtSearch.OnExit := frmDrawerEdtSearchExit;

  //kt if uTMGOptions.ReadString('SpecialLocation','')<>'FPG' then
  popNoteMemoProcess.Visible := AtFPGLoc();  //Process Notes is FPG specific
  if sptHorz.Left=0 then sptHorz.Left := pnlLeft.Left + pnlLeft.Width + 1; //kt added block 6/13/15 to fix misplaced splitter...
end;

procedure TfrmNotes.frmDrawerEdtSearchExit(Sender: TObject);
begin
  FOldDrawerEdtSearchExit(Sender);
  cmdNewNoteExit(Sender);
end;

procedure TfrmNotes.frmDrawerPnlTemplatesButtonExit(Sender: TObject);
begin
  FOldDrawerPnlTemplatesButtonExit(Sender);
  if Boolean(Hi(GetKeyState(VK_TAB))) and  (memNewNote.CanFocus) and
     Boolean(Hi(GetKeyState(VK_SHIFT))) then
    memNewNote.SetFocus
  else
    cmdNewNoteExit(Sender);
end;

procedure TfrmNotes.frmDrawerPnlEncounterButtonExit(Sender: TObject);
begin
  FOldDrawerPnlEncounterButtonExit(Sender);
  cmdNewNoteExit(Sender);
end;


procedure TfrmNotes.SetHTMLEditMode(HTMLEditMode : boolean; Quiet : boolean);
//kt 9/11 added function
var   Mode      : TViewModeSet; //kt
const HTML_MODE_S : Array[false..true] of string[16] = ('PLAIN','FORMATTED');
begin
  if FEditNote.Lines = nil then FEditNote.Lines := TStringList.Create; //kt
  if HTMLEditMode then begin
    if (FViewMode = [vmHTML,vmEdit]) then exit; //no change needed.
    FEditNote.Lines.Assign(memNewNote.Lines);
  end else begin
    if (FViewMode = [vmText,vmEdit]) then exit; //no change needed.
    if HtmlEditor.GetTextLen > 0 then begin
      if MessageDlg('Do you want to convert this note to PLAIN TEXT?'+#10#13+
                  '(May cause loss of formatting information.)',mtWarning, mbOKCancel,0) <> mrOK then begin
        exit;
      end;
    end;
    FEditNote.Lines.Text := HTMLEditor.Text;
  end;
  Mode := [vmEdit] + [vmHTML_MODE[HTMLEditMode]]; //kt
  SetDisplayToHTMLvsText(Mode,FEditNote.Lines);
  if not Quiet then begin
    if uTMGOptions.ReadBool(DEFAULT_HTML_EDIT_MODE,FALSE) <> HTMLEditMode then begin
      if MessageDlg('Start new notes in '+HTML_MODE_S[HTMLEditMode]+' TEXT by default?',mtConfirmation,[mbYES,mbNO],0) = mrYES then begin
        fOptionsNotes.SetDefaultEditHTMLMode(HTMLEditMode);
      end;
    end;
  end;
end;

procedure TfrmNotes.ToggleHTMLEditMode;
var NewHTMLMode: boolean;
begin
  if not (vmEdit in FViewMode) then exit;  //quit if not in edit mode
  NewHTMLMode := not (vmHTML in FViewMode);
  SetHTMLEditMode(NewHTMLMode);
end;


procedure TfrmNotes.SetDisplayToHTMLvsText(Mode : TViewModeSet;
                                           Lines : TStrings;
                                           ActivateOnly : boolean {default=False});
//If ActivateOnly=True, then the visibility is set, but the control is not filled with text.
//kt 9/11 added function
type
  TPanelVisibilityMode = (pvmReadMode, pvmWriteMode);  //kt

  procedure SetPanelVisibility(Mode: TPanelVisibilityMode; HTMLMode : boolean);

    procedure SetpnlReadVisibility(Visible : boolean; HTMLMode : boolean);
    begin
      pnlRead.Visible := Visible;
      if Visible then begin
        memNote.Visible := not HTMLMode;
        memNote.TabStop := not HTMLMode;
        pnlHTMLViewer.Visible := HTMLMode;
        pnlHTMLView.Visible := HTMLMode;  //kt 6/27/14
        HTMLViewer.Visible := HTMLMode;
        if HTMLMode then begin
          HtmlViewer.BringToFront;
        end else begin
          MemNote.BringToFront;
        end;
      end else begin
        memNote.Visible := false;
        memNote.TabStop := false;
        pnlHTMLViewer.Visible := false;
        pnlHTMLView.Visible := false;  //kt 6/27/14
        HTMLViewer.Visible := false;
      end;
    end; {SetDisplayToHTMLvsText.SetPanelVisibility.SetpnlReadVisibility}

    procedure SetpnlWriteVisibility(Visible : boolean; HTMLMode : boolean);
    begin
      pnlWrite.Visible := Visible;
      if Visible then begin
        pnlHTMLWrite.Visible := HTMLMode;
        pnlHTMLEdit.Visible := HTMLMode;
        HTMLEditor.Visible := HTMLMode;
        if HTMLMode then Set8087CW($133F);  //This line turns floating point error checking off, due to a bug in IE9
        pnlTextWrite.Visible := not HTMLMode;
        MemNewNote.Visible := not HTMLMode;
        if HTMLMode then begin
          HTMLEditor.BringToFront;
        end else begin
          MemNewNote.BringToFront;
        end;
      end else begin
        pnlHTMLWrite.Visible := false;
        pnlHTMLEdit.Visible := false;
        Set8087CW($1332);  //Turn floating point error checking back on
        HTMLEditor.Visible := false;
        pnlTextWrite.Visible := false;
        memNewNote.Visible := false;
      end;
    end; {SetDisplayToHTMLvsText.SetPanelVisibility.SetpnlWriteVisibility}

  begin {SetDisplayToHTMLvsText.SetPanelVisibility}
    SetpnlReadVisibility ((Mode=pvmReadMode), HTMLMode);
    SetpnlWriteVisibility((Mode=pvmWriteMode),HTMLMode);
    Application.ProcessMessages;
  end; {SetDisplayToHTMLvsText.SetPanelVisibility}

  procedure SetHTMLorTextEditor(HTMLEditMode : boolean;
                                Lines : TStrings;
                                ActivateOnly : boolean {default=False});
    procedure ActivateHtmlEditor(Lines : TStrings);
    var HTMLText : string;
    begin
      //kt moved below... 3/22/16 HtmlEditor.Editable := true;
      if ActivateOnly=false then begin
        if Lines <> nil then begin
          if uHTMLTools.IsHTML(Lines) then begin
            HTMLText := Lines.Text;
          end else begin
            HTMLText := Text2HTML(Lines);
            if HTMLText='' then HTMLText := ' ';
          end;
        end else HTMLText := ' ';
        HtmlEditor.HTMLText := HTMLText;
        HTMLEditor.KeyStruck := false;
        GLOBAL_HTMLTemplateDialogsMgr.EnsureEditViewMode(HtmlEditor);
      end;
      HtmlEditor.Editable := true;  //Sets ContentEditable=true to doc.body, so needs to be done AFTER loading document.
    end; {SetDisplayToHTMLvsText.SetHTMLorTextEditor.ActivateHtmlEditor}

    procedure ActiveMemoEditor(Lines : TStrings);
    begin
      if ActivateOnly=false then begin
        if Lines <> nil then QuickCopyWith508Msg(Lines, memNewNote); //kt 9/11
        //memNewNote.Lines.Assign(Lines); //kt new
      end;
      //kt HtmlEditor.Active := false; //stop intercepting OnMessages
      HtmlEditor.Clear;
    end; {SetDisplayToHTMLvsText.SetHTMLorTextEditor.ActiveMemoEditor}

  begin {SetDisplayToHTMLvsText.SetHTMLorTextEditor}
    FHTMLEditMode := emHTML_MODE[HTMLEditMode];
    CallV('TMG CPRS SET HTML MODE',[HTMLEditMode]);
    FViewMode := [vmEdit] + [vmHTML_MODE[HTMLEditMode]];
    SetPanelVisibility(pvmWriteMode,HTMLEditMode);
    //pnlRight.Repaint; //kt TEMP
    if HTMLEditMode then begin
      //frmFrame.FProccessingNextClick := True;     //kt  8/28/12
      if assigned(Lines) and (IsHTML(Lines)= false) then Text2HTML(Lines);  //3/29/16
      ActivateHtmlEditor(Lines);
    end else begin
      ActiveMemoEditor(Lines);
    end;
    //pnlRight.Repaint; //kt TEMP
  end; {SetDisplayToHTMLvsText.SetHTMLorTextEditor}

  procedure SetHTMLorTextViewer(HTMLViewMode : boolean;
                                Lines : TStrings;
                                ActivateOnly : boolean); //kt
    //Set forms such that either HTML Viewer is visible, or standard edit window.
    procedure ActivateHtmlViewer(Lines : TStrings);
    var TMGDebugEditLines : boolean;
    begin
      TMGDebugEditLines := false;  //kt 4/16  -- can change while walking through to edit StringList;
      with frmNotes do begin
        pnlHtmlViewer.Visible := true;
        pnlHtmlView.Visible := true; //kt 6/27/14
        //memNote.Visible := false;
        //memNote.TabStop := false;
        HtmlViewer.BringToFront;
        if ActivateOnly=False then begin
          if TMGDebugEditLines = true then EditSL(Lines);   //kt 4/16
          FixHTML(Lines);
          if TMGDebugEditLines = true then EditSL(Lines);   //kt 4/16
          HtmlViewer.HTMLText := Lines.Text;
        end;
        HtmlViewer.Editable := false;
        HtmlViewer.BackgroundColor := clCream;
        HtmlViewer.TabStop := true;
        RedrawActivate(HtmlViewer.Handle);
      end;
    end; {SetDisplayToHTMLvsText.SetHTMLorTextViewer.ActivateHtmlViewer}

    procedure ActivateMemoViewer(Lines : TStrings);
    begin
      with frmNotes do begin
        pnlHtmlViewer.Visible := false;
        pnlHtmlView.Visible := false; //kt 6/27/14
        HtmlViewer.Clear;
        //HtmlEditor.Clear;  //don't this here.  Only clear in ClearEditControls...
        HtmlViewer.TabStop := false;
        if ActivateOnly=False then memNote.Lines.Assign(Lines);   //new
        memNote.Visible := true;
        memNote.TabStop := true;
        memNote.BringToFront;
        RedrawActivate(memNote.Handle);
      end;
    end; {SetDisplayToHTMLvsText.SetHTMLorTextViewer.ActivateMemoViewer}

  begin {SetHTMLorTextViewer}
    FViewMode := [vmView] + [vmHTML_MODE[HTMLViewMode]];
    SetPanelVisibility(pvmReadMode,HTMLviewMode);
    //pnlRight.Repaint; //kt TEMP
    if HTMLViewMode then begin
      ActivateHtmlViewer(Lines);
    end else begin
      ActivateMemoViewer(Lines);
      HtmlViewer.Clear;
    end;
    //pnlRight.Repaint; //kt TEMP
  end; {SetDisplayToHTMLvsText.SetHTMLorTextViewer}

begin {SetDisplayToHTMLvsText}
  if vmEdit in Mode then begin
    SetHTMLorTextEditor((vmHTML in Mode), Lines, ActivateOnly);
  end else begin
    SetHTMLorTextViewer((vmHTML in Mode), Lines, ActivateOnly);
  end;
end; {SetDisplayToHTMLvsText}

procedure TfrmNotes.btnBoldClick(Sender: TObject);
//kt 9/11 added function
var temp1,temp2,temp3 : double;
begin
  inherited;
  temp1 := 1; temp2 := 1;
  temp3 := temp1/temp2;
  HtmlEditor.ToggleBold;
end;

procedure TfrmNotes.btnItalicClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.ToggleItalic;
end;

procedure TfrmNotes.btnLessIndentClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.Outdent;
end;

procedure TfrmNotes.btnMoreIndentClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.Indent;
end;

procedure TfrmNotes.btnRightAlignClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.AlignRight;
end;

procedure TfrmNotes.btnSaveClick(Sender: TObject);
begin
  inherited;
  if not boolAutosaving then DoAutoSave;      //elh added 11/18/16
end;

procedure TfrmNotes.btnSortAuthorClick(Sender: TObject);
//kt added function
begin
  inherited;
  if FSortBtnGroupManualChange then exit;
  FSortBtnGroupBy := 'A';
  SortBtnGroupClick(FSortBtnGroupBy);
end;

procedure TfrmNotes.btnSortDateClick(Sender: TObject);
//kt added function
begin
  inherited;
  if FSortBtnGroupManualChange then exit;
  FSortBtnGroupBy := 'D';
  SortBtnGroupClick(FSortBtnGroupBy);
end;

procedure TfrmNotes.btnSortLocationClick(Sender: TObject);
//kt added function
begin
  inherited;
  if FSortBtnGroupManualChange then exit;
  FSortBtnGroupBy := 'L';
  SortBtnGroupClick(FSortBtnGroupBy);
end;

procedure TfrmNotes.btnSortNoneClick(Sender: TObject);
//kt added function
begin
  inherited;
  if FSortBtnGroupManualChange then exit;
  FSortBtnGroupBy := '';
  SortBtnGroupClick(FSortBtnGroupBy);
end;

procedure TfrmNotes.btnSortTitleClick(Sender: TObject);
//kt added function
begin
  inherited;
  if FSortBtnGroupManualChange then exit;
  FSortBtnGroupBy := 'T';
  SortBtnGroupClick(FSortBtnGroupBy);
end;

procedure TfrmNotes.SortBtnGroupClick(GroupBy : string);
//kt added function
var
  SelNode: TORTreeNode;
  NoteIEN : string;
  NoteSelected : boolean;
  Saved: Boolean;
  Editing: Boolean;
begin
  inherited;
  Editing := (EditingIndex <> -1);
  if Editing then begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  SelNode := TORTreeNode(tvNotes.Selected);
  NoteIEN := piece(SelNode.StringData,U,1);
  NoteSelected := not (SelNode.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]);
  if (FCurrentContext.GroupBy <> GroupBy) then begin
    FCurrentContext.GroupBy := GroupBy;
    SetSortBtnGroupDisplay(GroupBy);
    Loadnotes;
    if NoteSelected then begin
      ChangeToNote(NoteIEN);
      if Editing then mnuActEditClick(nil);
    end;
  end;
end;

procedure TfrmNotes.SetSortBtnGroupDisplay(GroupBy : string);
//kt added function
//Purpose: to change the button that is selected, without effecting
//         and the action that would normally occur if the user had
//         clicked the button (i.e. LoadNotes)
begin
  if FSortBtnGroupBy = GroupBy then exit;
  FSortBtnGroupManualChange := true;
  if GroupBy = 'A' then begin
    btnSortAuthor.Down := True;
  end else if GroupBy = 'D' then begin
    btnSortDate.Down := True;
  end else if GroupBy = 'L' then begin
    btnSortLocation.Down := True;
  end else if GroupBy = 'T' then begin
    btnSortTitle.Down := True;
  end else btnSortNone.Down := True;
  FSortBtnGroupBy := GroupBy;
  FSortBtnGroupManualChange := false;
end;

procedure TfrmNotes.btnImageClick(Sender: TObject);
//kt 9/11 added function
begin
  mnuSelectExistingImage.Enabled := (frmImages.ImagesCount > 0);
  popupAddImage.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TfrmNotes.InsertNamedImage(FName: string);
//kt 9/11 added function
var
   ImageFName : string;
begin
  ImageFName := GetInsertHTMLName(FName);
  HTMLEditor.InsertHTMLAtCaret(ImageFName+#13#10);
end;

function TfrmNotes.GetInsertHTMLName(Name: string): string;
//kt 9/11 added function
var  ImageFName : string;
     SizeString : string;
begin
  if Name = '' then exit;
  //Should I test for file existence?
  ImageFName := CPRSDir+'\Cache\' + Name;
  SizeString := HTMLResize(ImageFName);
  Result := '<img src="'+ ImageFName + '" ' + ALT_IMG_TAG_CONVERT + ' ' + SizeString + '>';
end;

procedure TfrmNotes.mnuAddNewImageClick(Sender: TObject);
//kt 9/11 added function
var
   i, AddResult: integer;
   //oneImage: string;
   //ImageFName : string;
  frmImageUpload: TfrmImageUpload;

begin
  inherited;
  frmImageUpload := TfrmImageUpload.Create(Self);
  frmImageUpload.Mode := umImagesOnly;
  AddResult := frmImageUpload.ShowModal;
  frmImageUpload.Mode := umAnyFile;
  if IsAbortResult(AddResult) then exit;
  for i := 0 to frmImageUpload.UploadedImages.Count-1 do begin
    InsertNamedImage(frmImageUpload.UploadedImages.Strings[i]);
  end;
  frmImageUpload.Free;
end;

procedure TfrmNotes.AddUniversalImageClick(Sender: TObject);
//kt 9/11 added function, finished 5/14
var AddResult: integer;
    frmImagesMultiUse: TfrmImagesMultiUse;

begin
  inherited;
  frmImagesMultiUse := TfrmImagesMultiUse.Create(Self);
  frmImagesMultiUse.Mode := imuUseImage;
  AddResult := frmImagesMultiUse.ShowModal;
  if IsAbortResult(AddResult) then exit;
  InsertNamedImage(frmImagesMultiUse.SelectedImage);
  frmImagesMultiUse.Free;
end;



function TfrmNotes.GetNamedTemplateImageHTML(Name: string): string;
//kt 9/11 added function
var Result2: boolean;
    frmImagesMultiUse: TfrmImagesMultiUse;
begin
  Result := '';
  frmImagesMultiUse := TfrmImagesMultiUse.Create(Self);
  Result2 := frmImagesMultiUse.SelectNamedImage(Name);
  if Result2 = False then exit;
  Result := GetInsertHTMLName(frmImagesMultiUse.SelectedImage);
  frmImagesMultiUse.Free;
end;


procedure TfrmNotes.mnuSelectExistingImageClick(Sender: TObject);
//kt 9/11 added function
var
  oneImage: string;
  ImageFName : string;
  SizeString : string;
  frmImagePickExisting: TfrmImagePickExisting;

begin
  inherited;
  frmImagePickExisting := TfrmImagePickExisting.Create(Self);
  if frmImagePickExisting.ShowModal = mrOK then begin
    ImageFName := frmImagePickExisting.SelectedImageFName;
    SizeString := HTMLResize(ImageFName);
    if ImageFName <> '' then begin
      if frmImages.ThumbnailIndexForFName(ImageFName) = IMAGE_INDEX_IMAGE then begin
        oneImage := '<img src="'+ ImageFName + '" ' + ALT_IMG_TAG_CONVERT + ' ' + SizeString + '>';
      end else begin
        oneImage := '<embed src="'+ ImageFName + '" ' + ALT_IMG_TAG_CONVERT + ' ' + SizeString + '>';
      end;
      HTMLEditor.InsertHTMLAtCaret(oneImage+#13#10);
    end;
  end;
  FreeAndNil(frmImagePickExisting);
end;

function TfrmNotes.HTMLResize(ImageFName: string) : string;
var
  NewHeight : real;
  Image: TImage;
const
  MaxWidth : integer = 640;
begin
  Image := TImage.Create(Self);
  Image.Picture.LoadFromFile(ImageFName);
  if Image.Picture.Width > MaxWidth then begin
    NewHeight := (MaxWidth/Image.Picture.Width)*Image.Picture.Height;
    Result := 'WIDTH=' + inttostr(MaxWidth) + ' HEIGHT=' + floattostr(NewHeight) + ' ';
  end else begin
    Result := '';
  end;
  Image.Free;
end;

procedure TfrmNotes.btnCenterAlignClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.AlignCenter;
end;

procedure TfrmNotes.btnLeftAlignClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.AlignLeft;
end;

procedure TfrmNotes.btnNumbersClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.ToggleNumbering;
end;

procedure TfrmNotes.btnBulletsClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.ToggleBullet;
end;

procedure TfrmNotes.btnUnderlineClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.ToggleUnderline;
end;

procedure TfrmNotes.btnZoomInClick(Sender: TObject);
//kt 6/26/14 added function
begin
  inherited;
  HtmlViewer.ZoomIn;
  //SetZoom(FHTMLZoomValue + HTML_ZOOM_STEP);
end;

procedure TfrmNotes.btnEditZoomInClick(Sender: TObject);
begin
  inherited;
  HtmlEditor.ZoomIn;
end;


procedure TfrmNotes.btnEditZoomNormalClick(Sender: TObject);
begin
  inherited;
  HtmlEditor.ZoomReset;
end;

procedure TfrmNotes.btnZoomNormalClick(Sender: TObject);
//kt 6/26/14 added function
begin
  inherited;
  HtmlViewer.ZoomReset;
  //SetZoom(100); //100% = normal size.
end;

procedure TfrmNotes.btnEditZoomOutClick(Sender: TObject);
begin
  inherited;
  HtmlEditor.ZoomReset;
end;

procedure TfrmNotes.btnZoomOutClick(Sender: TObject);
//kt 6/26/14 added function
begin
  inherited;
  HtmlViewer.ZoomOut;
  //SetZoom(FHTMLZoomValue - HTML_ZOOM_STEP);
end;

{
procedure TfrmNotes.SetZoom(Pct : integer);
begin
  FHTMLZoomValue := Pct;
  HtmlViewer.Zoom := Pct;
end;
}

procedure TfrmNotes.btnTextColorClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.TextForeColorDialog;
end;

procedure TfrmNotes.btnBackColorClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.TextBackColorDialog;
end;

procedure TfrmNotes.btnFontsClick(Sender: TObject);
//kt 9/11 added function
begin
  inherited;
  HtmlEditor.FontDialog;
end;

procedure TfrmNotes.btnHideTitleClick(Sender: TObject);
//kt added
begin
  inherited;
  if not btnHideTitle.Down then begin
    if FNotesToHide.Count = 0 then exit;
    if MessageDlg('Stop hiding ' + IntToStr(FNotesToHide.Count) + ' titles?', mtConfirmation , mbYesNo, 0) <> mrYes then begin
      btnHideTitle.Down := not btnHideTitle.Down;
      exit;
    end;
    ResetHideButton;
    //Something to refresh the list.
    Loadnotes;
  end else begin
    DoHideTitle;
  end;
end;

procedure TfrmNotes.ResetHideButton;
//kt added 5/12/14
begin
  FNotesToHide.Clear;
  btnHideTitle.Caption := 'Hide';
  btnHideTitle.Hint := 'Click to Hide Note Title';
  btnAddHide.Visible := false;
  btnAddHide.Down := false;
end;

procedure TfrmNotes.btnAddHideClick(Sender: TObject);
//kt added
begin
  inherited;
  DoHideTitle;
end;

procedure TfrmNotes.btnAdminDocsClick(Sender: TObject);
begin
  inherited;
  if btnAdminDocs.Down then btnAdminDocs.Caption := 'Show Admin Docs'
  else btnAdminDocs.Caption := 'Hide Admin Docs';
  LoadNotes;
end;

procedure TfrmNotes.DoHideTitle;
//kt added
var
  SelNode: TORTreeNode;
  NodeInfo : string;
  NoteTitle: string;
  Saved : boolean;
begin
  if FHideTitleBusy then exit;
  if EditingIndex > -1 then SaveEditedNote(Saved);
  FHideTitleBusy := true;
  btnAddHide.Down := true; //make + button appear to go down with Hide button
  Application.ProcessMessages;
  if tvNotes.Selected = nil then begin
    MessageDlg('Please first select a note to hide.', mtError, [mbCancel], 0);
    btnHideTitle.Down := not btnHideTitle.Down;
  end else begin
    SelNode := TORTreeNode(tvNotes.Selected);
    if (SelNode.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then begin
      MessageDlg('Sorry.  That can not be hidden!', mtError, [mbCancel], 0);
      btnHideTitle.Down := not btnHideTitle.Down;
    end else begin
      NodeInfo := SelNode.StringData;
      NoteTitle := piece(NodeInfo,U,2);
      if (FNotesToHide.IndexOf(NoteTitle)<0) and (MessageDlg('Temporarily hide all "' + NoteTitle + '" notes?', mtConfirmation, mbYesNo, 0) = mrYes) then begin
        FNotesToHide.Add(NoteTitle);
        btnHideTitle.Caption := IntToStr(FNotesToHide.Count) + ' Hidden';
        btnHideTitle.Hint := 'Click to Stop Hiding Titles';
        btnAddHide.Down := true;
        btnAddHide.Visible := true;
        // 12/1/15    When hiding something while a new note is being edited,
        //EditingIndex was being set to 0 and refusing to allow the user to leave the "edited" note
        EditingIndex := -1;
        //Something to refresh list.
        Loadnotes;
      end else begin
        btnHideTitle.Down := not btnHideTitle.Down;
      end;
    end;
  end;
  btnAddHide.Down := False; //Release + button to go back up.
  FHideTitleBusy := false;
end;

procedure TfrmNotes.FilterTitlesForHidden(TitlesList : TStringList);
//kt added
var
  i : integer;
  NoteTitle : string;
begin
  for i := TitlesList.Count - 1 downto 0 do begin
    NoteTitle := piece(TitlesList.Strings[i],U,2);
    if FNotesToHide.IndexOf(NoteTitle)<0 then continue;
    TitlesList.Delete(i);
  end;
end;

procedure TfrmNotes.FilterTitlesForAdmin(TitlesList : TStringList);
//kt added
var
  i : integer;
  NoteTitle : string;
  AdminTitles : TStringList;
begin
  AdminTitles := TStringList.Create();
  tCallV(AdminTitles,'TMG CPRS GET ADMIN TITLES',[]);
  for i := TitlesList.Count - 1 downto 0 do begin
    NoteTitle := piece(TitlesList.Strings[i],U,2);
    if AdminTitles.IndexOf(NoteTitle)<0 then continue;
    //if piece(TitlesList.Strings[i],'^',16)='1' then continue;
    TitlesList.Delete(i);
  end;
  AdminTitles.Free;
end;

procedure TfrmNotes.cbFontSizeChange(Sender: TObject);
//kt 9/11 added function
const
  FontSizes : array [0..6] of byte = (8,10,12,14,18,24,36);
begin
  inherited;
  //HtmlEditor.FontSize := StrToInt(cbFontSize.Text);
  HtmlEditor.FontSize := FontSizes[cbFontSize.ItemIndex];
end;

procedure TfrmNotes.cbFontNamesChange(Sender: TObject);
//kt 9/11 added function
var i :  integer;
    FontName : string;
const
   TEXT_BAR = '---------------';
begin
  inherited;
  if cbFontNames.Text[1]='<' then exit;
  FontName := cbFontNames.Text;
  HtmlEditor.FontName := FontName;
  i := cbFontNames.Items.IndexOf(TEXT_BAR);
  if i < 1 then cbFontNames.Items.Insert(0,TEXT_BAR);
  if i > 5 then cbFontNames.Items.Delete(5);
  if cbFontNames.Items.IndexOf(FontName)> i then begin
    cbFontNames.Items.Insert(0,FontName);
  end;
end;

procedure TfrmNotes.memNewNoteKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if FNavigatingTab then
    Key := #0;  //Disable shift-tab processinend;
end;

procedure TfrmNotes.memNewNoteKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if FNavigatingTab then
  begin
    if ssShift in Shift then
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus //previous control
    else if ssCtrl	in Shift then
      if frmDrawers.pnlTemplatesButton.CanFocus then
        frmDrawers.pnlTemplatesButton.SetFocus
      else
        FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
    FNavigatingTab := False;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

procedure TfrmNotes.memPCEShowExit(Sender: TObject);
begin
  inherited;
  //Fix the Tab Order  Make Drawers Buttons Accessible
  if TabIsPressed then
    if frmDrawers.pnlTemplatesButton.CanFocus then
      frmDrawers.pnlTemplatesButton.SetFocus
end;

procedure TfrmNotes.cmdChangeExit(Sender: TObject);
begin
  inherited;
  //Fix the Tab Order  Make Drawers Buttons Accessible
  if Boolean(Hi(GetKeyState(VK_TAB))) and
     Boolean(Hi(GetKeyState(VK_SHIFT))) then
    tvNotes.SetFocus;
end;

procedure TfrmNotes.cmdPCEExit(Sender: TObject);
begin
  inherited;
  //Fix the Tab Order  Make Drawers Buttons Accessible
  if TabIsPressed then
    if frmFrame.pnlPatient.CanFocus then
      frmFrame.pnlPatient.SetFocus;
end;

procedure TfrmNotes.ViewInfo(Sender: TObject);
begin
  inherited;
  frmFrame.ViewInfo(Sender);
end;

procedure TfrmNotes.ViewWindowsMessages1Click(Sender: TObject);
//kt added 8/16  -- debugging tool
begin
  inherited;
  if not assigned(frmWinMessageLog) then exit;
  frmWinMessageLog.Show;
end;

procedure TfrmNotes.mnuViewInformationClick(Sender: TObject);
begin
  inherited;
  mnuViewDemo.Enabled := frmFrame.pnlPatient.Enabled;
  mnuViewVisits.Enabled := frmFrame.pnlVisit.Enabled;
  mnuViewPrimaryCare.Enabled := frmFrame.pnlPrimaryCare.Enabled;
  mnuViewMyHealtheVet.Enabled := not (Copy(frmFrame.laMHV.Hint, 1, 2) = 'No');
  mnuInsurance.Enabled := not (Copy(frmFrame.laVAA2.Hint, 1, 2) = 'No');
  mnuViewFlags.Enabled := frmFrame.lblFlag.Enabled;
  mnuViewRemoteData.Enabled := frmFrame.lblCirn.Enabled;
  mnuViewReminders.Enabled := frmFrame.pnlReminders.Enabled;
  mnuViewPostings.Enabled := frmFrame.pnlPostings.Enabled;
end;

procedure TfrmNotes.mnuSearchNotesClick(Sender: TObject);
//kt 9/11 added
var   ModalResult: integer;
      frmPtDocSearch: TfrmPtDocSearch;
begin
  inherited;
  frmPtDocSearch := TfrmPtDocSearch.Create(Self);
  //Application.CreateForm(TfrmPtDocSearch, frmPtDocSearch);
  ModalResult := frmPtDocSearch.ShowModal;
  if ModalResult > -1 then begin
    ChangeToNote(inttostr(ModalResult));
  end;
  frmPtDocSearch.Free;
end;

function TfrmNotes.GetNodeByIEN(ATree : TORTreeView; IEN:String): TORTreeNode;
//kt added 5/15
begin
  Result := ATree.FindPieceNode(IEN, U);  //kt 5/15
end;

procedure TfrmNotes.ChangeToNote(IEN : String; ADFN : String = '-1');
//kt 9/11 added
//Effect changing note by simulating a notification click.
var Node: TORTreeNode;
begin
  Node := GetNodeByIEN(tvNotes,IEN);
  if Node <> nil then tvNotes.Selected := Node;
end;

procedure TfrmNotes.ReloadNotes;
//kt added entire function 5/15
var CurrentNoteIEN: integer;
    CurrentNoteIENS : string;
    Node: TORTreeNode;
    Saved : boolean;
begin
  //kt CurrentNote := FEditingIndex;
  CurrentNoteIEN := ActiveEditIEN;  //kt
  CurrentNoteIENS := IntToStr(CurrentNoteIEN);
  if FEditingIndex > -1 then begin
    SaveEditedNote(Saved);
    if Saved = false then exit;
  end;
  LoadNotes;  //This should reload TV etc.
  //ChangeToNote(CurrentNoteIENS);
  Node := GetNodeByIEN(tvNotes,CurrentNoteIENS);
  if Node <> nil then begin
    tvNotes.Selected := Node;
    tvNotesDblClick(self);
  end;
end;

{
procedure TfrmNotes.TMG_CMDialogKey(var AMessage: TMessage);
//kt TEMP DEBUGGING FUNCTION!! REMOVE LATER... //kt
//kt NOTE: this fails to capture TAB key, which was the original hope...
var YouWantToInterceptTab  : boolean;
begin
  YouWantToInterceptTab := true;
  if AMessage.WParam = VK_TAB then begin
    ShowMessage('TAB key has been pressed in ' + ActiveControl.Name);
    if YouWantToInterceptTab then begin
      ShowMessage('TAB key will be eaten');
      AMessage.Result := 1;
    end else begin
      inherited;
    end;
  end else begin
    inherited;
  end;
end;
}

procedure TfrmNotes.UpdateFormForInput;
var
  idx, offset: integer;

begin
  if (not pnlWrite.Visible) or uInit.TimedOut then exit;

  if (frmFrame.WindowState = wsMaximized) then
    idx := GetSystemMetrics(SM_CXFULLSCREEN)
  else
    idx := GetSystemMetrics(SM_CXSCREEN);
  if idx > frmFrame.Width then
    idx := frmFrame.Width;

  offset := 5;
  if(MainFontSize <> 8) then
    offset := ResizeWidth(BaseFont, Font, offset);
  dec(idx, offset + 10);
  dec(idx, pnlLeft.Width);
  dec(idx, sptHorz.Width);
  dec(idx, cmdChange.Width);

  cmdChange.Left := idx;
end;

procedure TfrmNotes.RefreshImages();
var IsHTML: boolean;
begin
   IsHTML := uHTMLTools.IsHTML(FEditNote.Lines);
end;

function TfrmNotes.AllowSignature(): Boolean;    //kt
var
   Saved:boolean;
   RPCExists: boolean;
   RPCResult:string;
begin
  RPCExists := frmFrame.CheckForRPC('TMG TIU NOTE CAN BE SIGNED');
  if RPCExists=False then begin
    Result := True;
    exit;
  end;
  SaveCurrentNote(Saved);
  RPCResult := sCallV('TMG TIU NOTE CAN BE SIGNED',[Patient.DFN,lstNotes.ItemIEN]);
  if piece(RPCResult,'^',1)='1' then begin
    Result := True;
    Exit;
  end;
  Result := False;
  messagedlg(piece(RPCResult,'^',2),mterror,[mbOK],0);
end;



initialization
  SpecifyFormIsNotADialog(TfrmNotes);
  uPCEEdit := TPCEData.Create;
  uPCEShow := TPCEData.Create;
  TMGForcePlainTextEditMode := false;  //kt 12/27/12

finalization
  if (uPCEEdit <> nil) then uPCEEdit.Free; //CQ7012 Added test for nil
  if (uPCEShow <> nil) then uPCEShow.Free; //CQ7012 Added test for nil

end.

