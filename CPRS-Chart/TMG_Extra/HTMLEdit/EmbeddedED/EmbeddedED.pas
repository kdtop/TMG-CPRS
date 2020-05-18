{       EmbeddedED ver 1.21 (Jan. 19, 2004)      }
{                                               }
{       For Delphi 4, 5, 6 and 7                }
{                                               }
{       Copyright (C) 1999-2004, Kurt Senfer.   }
{       All Rights Reserved.                    }
{                                               }
{       Support@ks.helpware.net                 }
{                                               }
{       Documentation and updated versions:     }
{                                               }
{       http://KS.helpware.net                  }
{                                               }
{ ********************************************* }

{
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

This unit forms the basic core of a MSHTML Edit component witch can be used
as the starting point for a full blown WYSIWYG HTML Editor.

Don't change this unit, but subclass it in order to build your own advanced
HTML Editor on top of it. If you change the unit you'll run into unnecessary
troubles when official updates of this unit is released. If you build a
subclassed editor you can benefit from new versions of the EmbeddedED unit
without the need of changing your own code.

If you find bugs or have ideas / wishes for new features that either should be
incorporated into the EmbeddedED unit or cant be placed in a subclassed unit,
then please let me know and I'll try to keep EmbeddedED updated at any time.

----------------------------------------------------------------------

Once I tried to get an HTML editor written as OSP. When it didn't succeeded
I tried to get different groups of people to share the workload of
writing a good HTML editor around the MSHTML engine - no succeed either.

Then I finally had to do everything myself and finally I decided only to make
parts of my source public.

If you ever need to do more than the basic editing that the EmbeddedED unit
will give you, you need to write some code yourself, or you might chose to acquire
some of the code I wrote - check out my site at http://KS.helpware.net.

The power of all units are compiled into the KsDHTMLEDLib.ocx witch you can use
free of charge. }

(*
NOTE: Modified by K. Toppenberg (marked by //kt)
*)



unit EmbeddedED;          //core VCL HTML edit component
{.$DEFINE EDOCX}          //unit not included
{.$DEFINE EDTABLE}        //unit not included
{.$DEFINE EDUNDO}         //unit not included
{.$DEFINE EDMONIKER}      //unit not included
{.$DEFINE EDGLYPHS}       //unit not included
{.$DEFINE EDLIB}          //unit not included
{.$DEFINE EDPARSER}       //unit not included
{.$DEFINE EDDRAGDROP}     //unit not included
{.$DEFINE EDZINDEX}       //unit not included
{.$DEFINE EDDESIGNER}     //unit not included
{.$DEFINE EDPRINT}        //unit not included


{ $DEFINE DEBUG }  //kt removed.



 {$I KSED.INC} //Compiler version directives

interface

uses
  Windows, Classes, ActiveX, Forms, 
  //ktMSHTML_TLB,
  MSHTML_EWB, //kt
  variants,  //kt 9/11 added
  AXCtrls, menus, Controls, messages, URLMon,
  {$IFDEF D6D7} Variants, {$ENDIF}
  {$IFDEF EDPRINT} EDPrint, {$ENDIF}
  IEConst, EmbedEDconst, KS_Lib, SHDocVw;

type
  TDHTMLEDITAPPEARANCE = (DEAPPEARANCE_FLAT, DEAPPEARANCE_3D);

  TUserInterfaceOption = (NoBorder, NoScrollBar, FlatScrollBar, DivBlockOnReturn);
  TUserInterfaceOptions = set of TUserInterfaceOption;

  TDHTMLEditShowContextMenu = procedure(Sender: TObject; xPos: Integer; yPos: Integer) of object;
  TDHTMLEditContextMenuAction = procedure(Sender: TObject; itemIndex: Integer) of object;
  TQueryServiceEvent = function(const rsid, iid: TGuid; out Obj: IUnknown): HResult of object;
  TShowContextMenuEvent = function(const dwID: DWORD; const ppt: PPOINT; const pcmdtReserved: IUnknown; const pdispReserved: IDispatch): HRESULT of object;
  TShowContextMenuEventEx = procedure(Sender: TObject; xPos, yPos: Integer) of object;
  TTranslateURLEvent = procedure(Sender: TObject; var URL: string; var Changed: Boolean) of object;
  TMessageEventEx = procedure(Sender: TObject; var msg: LongWord; var wParam: SYSINT; var lParam: SYSINT; var Result: SYSINT) of object;
  TEditDesignerEvent = procedure(Sender: TObject; inEvtDispId: Integer; const pIEventObj: IHTMLEventObj; var Result: HResult) of object;
  TNotifyEventEx2 = procedure(Sender: TObject; NewFile: String) of object;
  TNotifyEventEx4 = procedure(Sender: TObject; var S: String) of object;

//kt  TSnapRect = procedure(Sender: TObject; const pIElement: IHTMLElement; var prcNew: tagRECT; eHandle: _ELEMENT_CORNER; var Result: HResult) of object;
  TNotifyEventEx = procedure(Sender: TObject; var Cancel: Boolean) of object;

  TNotifyEventEx8 = procedure(Sender: TObject; var Key: Integer; const pEvtObj: IHTMLEventObj) of object;
  TNotifyProcedureEvent = procedure of object;

  TRefreshEvent = procedure(Sender: TObject; CmdID: Integer; var Cancel: Boolean) of object;
  TMouseEventEx = procedure(Sender: TObject; const pEvtObj: IHTMLEventObj; X, Y: Integer; var Cancel: Boolean) of object;

  {$IFNDEF EDPRINT}
     TPrintSetup = array[0..8] of string;  //Dummy type - if EDPRINT is undefines
  {$ENDIF}


  TEmbeddedED = class(TWebbrowser,
                      IDocHostUIHandler,
                      IDispatch,          //invoke ~ general event sink
                      IServiceProvider,
                      IOleControlSite,
                      IPropertyNotifySink,
                      {$IFDEF EDDRAGDROP}
                         IDropTarget,
                      {$ENDIF}
                      IOleCommandTarget,
                      ISimpleFrameSite
                      )
  private
    FOnQueryService: TQueryServiceEvent;
    FOnDisplayChanged: TNotifyEvent;
    FOnShowContextMenu: TShowcontextmenuEvent;
    FOnShowContextmenuEx:  TShowContextMenuEventEx;
    FOnTranslateURL: TTranslateURLEvent;
    FOnDocumentComplete: TNotifyEvent;
    FWaitMessage: Boolean;
    DWEBbrowserEvents2Cookie: Integer; //event sink stuff
    FReadyState: Integer;
    FShowDetails: Boolean;
    FIEVersion: String;
    FIE6: boolean;
    FMSHTMLDropTarget: IDropTarget;
    FInternalStyles: String;
    FExternalStyles: String;
    FStylesRefreshed: Boolean;
    FStyles: TStringList;
    FFonts: TStringList;
    FHTMLImage: String;   //Source image of the current page as opened / last saved
    FDebug: Boolean;
    DebugBool: Boolean;   //used to test any Boolean value
    DebugString: String;  //used to test any string value
    DebugElement: IHTMLElement;
    DummyString: String;
    FSetInitialFocus: Boolean;
    FEDMessageHandler: TMessageEvent;
    FMessageHandler: TMessageEventEx;
    FUserInterfaceValue: DWORD;
    FDownloadControlValue: Integer;
    FPrintFinished: Boolean;
    // IHTMLEditHost
    FSnapEnabled: Boolean;
    FGridX: Integer;
    FGridY: Integer;
    //ktFExtSnapRect: TSnapRect;
    FOnPreDrag: TNotifyEventEx;
    FPreHandleEvent: TEditDesignerEvent;
    FPostHandleEvent: TEditDesignerEvent;
    FEDTranslateAccelerator: TEditDesignerEvent;
    FPostEditorEventNotify: TEditDesignerEvent;
    FOleInPlaceActiveObject: IOleInPlaceActiveObject;
    //kt .. moved to protected section ..   FmsHTMLwinHandle: Hwnd;
    FLocalUndo: WordBool; //we handle UNDO and REDO ourselves
    FTUndo: Pointer;      //we cant use TUndo heir, it will cause a Circular reference
    FTZindex: pointer;    //we cant use TZindex ........
    FTtable: pointer;     //we cant use TTable ........
    FEdit: pointer;       //we cant use TEditDesigner ........
    FEditHost: pointer;   //we cant use TEditHost ........
    FDestroyng: Boolean;
    FContextMenu: TPopupMenu;
    FCreateBakUp: Boolean;
    FActualTxtRange: IHTMLTxtRange;
    FActualControlRange: IHTMLControlRange;
    FSelectionType: string;
    FActualElement: IHTMLElement;
    FActualRangeIsText: Boolean;
    FSelection: Boolean;    //There is a selection
    FHighlight: IHighlightRenderingServices;
    FHighlightSegment: IHighlightSegment;
    FRenderStyle: IHTMLRenderStyle;
    FDisplayPointerStart: IDisplayPointer;
    FDisplayPointerEnd: IDisplayPointer;
    FLoadFromString: Boolean;
    FParamLoad: Boolean;
    FRefreshing: Boolean;
    FUserInterfaceOptions: TUserInterfaceOptions;
    FBeforeSaveFile: TNotifyEvent;
    FAfterSaveFile: TNotifyEvent;
    FAfterSaveFileAs: TNotifyEvent;
    FAfterLoadFile: TNotifyEventEx2;
    FonAfterPrint: TNotifyEventEx;
    FonBeforePrint: TNotifyEventEx;
    FOnUnloadDoc: TNotifyEventEx;
    FOnRefreshBegin: TRefreshEvent;
    FOnRefreshEnd: TNotifyEvent;
    FBaseURL: String;
    {$IFNDEF EDMONIKER}
       FDummyString: String;
    {$ENDIF}
    FBaseTagInDoc: Boolean;
    FLiveResize: Boolean;
    F2DPosition: Boolean;
    FShowZeroBorderAtDesignTime: Boolean;
    FConstrain : boolean;
    EDMessageHandlerPtr: Pointer;
    FOnMouseUp: TMouseEventEx;
    FOnMouseDown: TMouseEventEx; 
    FOnDblClick: TNotifyEvent;
    FOnClick: TNotifyEvent;
    FOnKeyUp: TNotifyEventEx8;
    FOnKeyDown: TNotifyEventEx8;
    FOnKeyPress: TKeyPressEvent;
    FOnMouseMove: TMouseEventEx;
    FOnmouseout: TNotifyEvent;
    FOnmouseover: TNotifyEvent;
    FOnBlur: TNotifyEvent;
    FAbsoluteDropMode: Boolean;
    FShowBorders: Boolean;
    FCurrentDocumentPath: String;
    FOnReadystatechange: TNotifyEvent;
    KeepLI: boolean;
    FLength: Integer; //number of selected elements
    FFirstElement: Integer;
    FLastElement: Integer;
    FStartElementSourceIndex: Integer;
    FEndElementSourceIndex: Integer;
    FElementCollection: IHTMLElementCollection;
    FTagNumber: Integer;  //actual tagnumber in a GetFirts GetNext sequence
    FMarkUpServices: IMarkupServices;
    FMarkupPointerStart: IMarkupPointer;
    FMarkupPointerEnd: IMarkupPointer;    
    FOnInitialize: TNotifyEventEx4;
    FAXCtrl: Pointer;   //  pointer to TActiveXControl (KsDHTMLEDLib.ocx)
    FGenerator: String;
    FSkipDirtyCheck: Boolean;
    FWarmingUp: Boolean; //true while MSHTML is initialised
    FSettingBaseURL: Boolean;
    FkeepPath: Boolean;
    FOnContextMenuAction: TDHTMLEditContextMenuAction;
    // IDOCHOSTUIHANDLER
    function ShowContextMenu(const dwID: DWORD; const ppt: PPOINT; const pcmdtReserved: IUnknown; const pdispReserved: IDispatch): HRESULT; stdcall;
    function GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT; stdcall;
    function ShowUI(const dwID: DWORD; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
    function HideUI: HRESULT; stdcall;
    function UpdateUI: HRESULT; stdcall;
    function EnableModeless(const fEnable: BOOL): HRESULT; stdcall;
    function OnDocWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function OnFrameWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const FrameWindow: BOOL): HRESULT; stdcall;
    function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT; stdcall;
    function GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD): HRESULT; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HRESULT; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HRESULT; stdcall;
    function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HRESULT; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HRESULT; stdcall;
    // IDOCHOSTUIHANDLER END
    // IDispatch
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
    // IServiceProvider
    function QueryService(const rsid, iid: TGuid; out Obj): HResult; stdcall;
    // IServiceProvider END
    // IOleControlSite
    function OnControlInfoChanged: HResult; stdcall;
    function LockInPlaceActive(fLock: BOOL): HResult; stdcall;
    function GetExtendedControl(out disp: IDispatch): HResult; stdcall;
    function TransformCoords(var ptlHimetric: TPoint; var ptfContainer: TPointF; flags: Longint): HResult; stdcall;
    function IOleControlSite.TranslateAccelerator = OleControlSite_TranslateAccelerator;
    function OleControlSite_TranslateAccelerator(msg: PMsg; grfModifiers: Longint): HResult; stdcall;
    function OnFocus(fGotFocus: BOOL): HResult; stdcall;
    function ShowPropertyFrame: HResult; stdcall;
    // IOleControlSite  END
    {$IFDEF EDDRAGDROP}
       // IDropTarget
       function DragEnter(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
       function IDropTarget.DragOver = _DragOver;
       function _DragOver(grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
       function DragLeave: HResult; stdcall;
       function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint; var dwEffect: Longint): HResult; stdcall;
       // IDropTarget END
    {$ENDIF}
    // IOleCommandTarget
    function IOleCommandTarget.QueryStatus = _QueryStatus;
    function _QueryStatus(CmdGroup: PGUID; cCmds: Cardinal; prgCmds: POleCmd; CmdText: POleCmdText): HResult; stdcall;
    function Exec(CmdGroup: PGUID; nCmdID, nCmdexecopt: DWORD; const vaIn: OleVariant; var vaOut: OleVariant): HResult; stdcall;
    // IOleCommandTarget END
    function GetOleobject: IOleobject;
    function GetBaseURL: String;
    procedure SetBaseURL(const Value: String);
    {$IFNDEF EDMONIKER}
       function LoadFromIStream(aIStream: IStream): HResult;
    {$ENDIF}
    Procedure GetSourceSnapShot;
    function GetCharset: string;
    function EmptyDoc: String;
    procedure SubClassMsHTML;
    procedure UnSubClassMsHTML;
    function GetWebBrowserConnectionPoint(var CP: ICOnnectionPoint): boolean;
    procedure EDOnMouseOver(const pEvtObj: IHTMLEventObj);
    procedure WaitAsyncMessage(var Msg: Tmessage); message WaitAsync_MESSAGE;
    function OpenChangeLog: HResult;
    function LoadFromStrings(aStrings: TStrings): HResult;
    function LoadFromString(aString: String): HResult;
    function Get_Busy: Boolean;
    procedure SetShowDetails(vIn: Boolean);
    Function GetBackup: Boolean;
    function CreateBackUp: Boolean;
    procedure SetDocumentHTML(NewHTML: String);
    procedure EDOnDownloadComplete(Sender: TObject);
    procedure HookEvents;
    function GetActualAppName: string;
    procedure SetActualAppName(const Value: string);
    procedure SetBrowseMode(const Value: WordBool);
    function GetBrowseMode: WordBool;
    procedure SetDirty(_dirty: boolean);
    function GetDirty: boolean;
    function GetDocTitle: String;
    procedure SetDocTitle(NewTitle: string);
    function GetDOC: IHTMLDocument2;
    function GetCmdTarget: IOleCommandTarget;
    function GetPersistStream: IPersistStreamInit;
    function GetPersistFile: IPersistFile;
    procedure SetLiveResize(const Value: Boolean);
    procedure Set2DPosition(const Value: Boolean);
    function GetBaseElement(var aBaseElement: IHTMLBaseElement): boolean;
    function GetActualElement: IHTMLElement;
    function GetActualTxtRange: IHTMLTxtRange;
    function GetActualControlRange: IHTMLControlRange;
    function GetSelLength: Integer;
    Procedure GetSelStartElement;
    Procedure GetSelEndElement;
    function GetElementNr(ElementNumber: Integer): IHTMLElement;
    function _GetNextItem(const aTag: String = ''): IHTMLElement;
    procedure EDBeforePrint(Sender: TObject; const pEvtObj: IHTMLEventObj);
    procedure EDAfterPrint(Sender: TObject; const pEvtObj: IHTMLEventObj);
    procedure EDOnUnloadDoc(Sender: TObject; const pEvtObj: IHTMLEventObj);
    procedure EDOnDocBlur(Sender: TObject; const pEvtObj: IHTMLEventObj);
    procedure EDBeforeDragStart(Sender: TObject; const pEvtObj: IHTMLEventObj);
    function GetLastError: string;
    function KSTEst(var pInVar, pOutVar: OleVariant): HResult;
    function Get_AbsoluteDropMode: Boolean;
    function Get_Scrollbars: WordBool;
    function Get_ShowBorders: WordBool;
    procedure Set_AbsoluteDropMode(const Value: Boolean);
    procedure Set_Appearance(const Value: TDHTMLEDITAPPEARANCE);
    function GetAppearance(aType: TUserInterfaceOption): TDHTMLEDITAPPEARANCE;
    function Get_Appearance: TDHTMLEDITAPPEARANCE;
    procedure Set_ScrollbarAppearance(const Value: TDHTMLEDITAPPEARANCE);
    function Get_ScrollbarAppearance: TDHTMLEDITAPPEARANCE;
    procedure Set_Scrollbars(const Value: WordBool);
    procedure Set_ShowBorders(const Value: WordBool);
    function Get_UseDivOnCarriageReturn: WordBool;
    procedure Set_UseDivOnCarriageReturn(const Value: WordBool);
    procedure FContextMenuClicked(Sender: TObject);
    procedure SetGridX(const Value: integer);
    procedure SetGridY(const Value: integer);
    procedure SetSnapEnabled(const Value: Boolean);
    procedure SetUserInterfaceValue;
    procedure Accept(const URL:String;var Accept:Boolean);
    procedure Set_LocalUndo(const Value: WordBool);
    function GetPrintFileName: String;
    function ISEmptyParam(value: Olevariant): Boolean;
  protected
    KeyPressTime : FILETIME; //kt
    FEditMode: Boolean;
    FmsHTMLwinPtr: Pointer; //saved pointer to a subclassed MSHTML window
    FmsHTMLwinHandle: Hwnd; //kt moved here from private section.
    FMainWinHandle: Hwnd; //the "Shell Embedding" window
    FScrollTop: Integer;  //saved WYSIWYG scroll position
    FBeforeCloseFile: TNotifyEventEx2;
    FCurBackFile: String;
    FCaret: IHTMLCaret;  //kt moved from Private --> protected section
    FTMGDisplayPointer: IDisplayPointer; //kt
    // IPropertyNotifySink
    function OnChanged(dispid: TDispID): HResult; override; stdcall;
    function OnRequestEdit(dispid: TDispID): HResult; override; stdcall;
    // IPropertyNotifySink END
    procedure SubMessageHandler(var Message: TMessage); Virtual;
    function SubFocusHandler(fGotFocus: BOOL): HResult; virtual; //kt
    procedure EDMessageHandler(var Message: TMessage);
    procedure OpenPointers; //kt added
    procedure DocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant; var HandlingComplete: Boolean); virtual;
    function _DoSaveFile: HResult; Virtual;
    function DoSaveFile: HResult;
    function DoSaveFileAs(aFile: String): HResult; Virtual;
    procedure AfterFileSaved; Virtual;
    procedure loaded; override;
    procedure Set_Generator(const Value: String); Virtual;
    procedure _UpdateUI; //back door for derived component
    function GetDocumentHTML: string;
    function ComponentInDesignMode: Boolean; Virtual;
    function EndCurrentDocDialog(var mr: Integer; CancelPosible: Boolean = False; SkipDirtyCheck: Boolean = False): HResult;
    function DocIsPersist: boolean;
    function _LoadFile(aFileName: String): HResult; Virtual;
    function _CurDir: string;
    function _CurFileName: string;
    procedure NotImplemented(S: String);
    procedure _GetBuildInStyles;
    procedure EditInitialize;
    function GetSelStartEnd(Var SelStart, SelEnd: Integer): boolean;
    function SetSelStartEnd(SelStart, SelEnd: Integer): boolean;
  public
    property Onmouseover: TNotifyEvent read FOnmouseover write FOnmouseover;
    property OnReadystatechange: TNotifyEvent read FOnReadystatechange write FOnReadystatechange;
    {$IFDEF EDOCX}
        property AXCtrl: Pointer read FAXCtrl write FAXCtrl;
    {$ENDIF}
    // the folowing is for internal use (but need to be public),
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure ShowHighlight(pIRange: IHTMLTxtRange = nil);
    procedure HideHighlight;
    function GetInPlaceActiveObject: IOleInPlaceActiveObject;
    function DocumentIsAssigned: Boolean;
    procedure ShowCaret;
    procedure _CheckGenerator(MainCheck: Boolean = true); Virtual;
    procedure GetBaseTag(var BaseTagInDoc: Boolean; var BaseUrl: String);
    property Debug: Boolean read FDebug;
    property EDReadyState: Integer read FReadyState write FReadyState;
    property CurrentDocumentPath: string read FCurrentDocumentPath;
    property ExternalStyles: String read FExternalStyles write FExternalStyles;
    property Styles: TStringlist read FStyles;
    property MSHTMLDropTarget: IDropTarget read FMSHTMLDropTarget write FMSHTMLDropTarget;
    property LocalUndo: WordBool read FLocalUndo write FLocalUndo;
    property CmdTarget: IOleCommandTarget read GetCmdTarget;
    property PersistStream: IPersistStreamInit read GetPersistStream;
    property ScrollTop: Integer write FScrollTop;
    property PrintFinished: Boolean read FPrintFinished write FPrintFinished;
    property PersistFile: IPersistFile read GetPersistFile;
    property HTMLImage: String read FHTMLImage;
    function EndUndoBlock(aResult: HResult): HResult;
    function ClearUndoStack: HResult;
    procedure WaitAsync;
    function GetGenerator: string; virtual;
    function CmdSet(cmdID: CMDID; var pInVar: OleVariant): HResult; overload; virtual;
    //VCL versions that isn't exposed by the OCX
    function DoCommand(cmdID: CMDID): HResult; overload;
    function DoCommand(cmdID: CMDID; cmdexecopt: OLECMDEXECOPT): HResult; overload;
    function DoCommand(cmdID: CMDID; cmdexecopt: OLECMDEXECOPT; var pInVar: OleVariant): HResult; overload;
    function DoCommand(cmdID: CMDID; cmdexecopt: OLECMDEXECOPT; var pInVar, pOutVar: OleVariant): HResult; overload;
    function CmdSet(cmdID: CMDID): HResult;  overload; virtual;
    function CmdGet(cmdID: CMDID): OleVariant; overload;
    function GetSaveFileName(var aFile: string): HResult;
    function SaveFile: HResult; virtual;
    function SaveFileAs(aFile: string = ''): HResult; virtual;
    property CurDir: string read _CurDir;
    property CurFileName: string read _CurFileName;
    function WaitForDocComplete: Boolean;
    property DocumentTitle: string read GetDocTitle Write SetDocTitle;
    procedure ScrollDoc(Pos: Integer);
    procedure SetFocusToDoc;
    function GetMSHTMLwinHandle: Hwnd;
    Function CaretIsVisible: Boolean;
    procedure SetMouseElement(P: Tpoint; aWinHandle: Hwnd = 0);
    procedure MakeSelElementVisible(Show: boolean);
    Function RemoveElementID(const TagID: String): Boolean;
    Procedure SetDebug(value: Boolean);
    property CreateBakUp: Boolean read FCreateBakUp write FCreateBakUp;
    property LastError: string read GetLastError;
    property SkipDirtyCheck: Boolean read FSkipDirtyCheck write FSkipDirtyCheck;
    //Old DHTMLEdit stuff
    function ExecCommand(cmdID: CMDID; cmdexecopt: OLECMDEXECOPT; var pInVar: OleVariant): OleVariant;
    procedure SetContextMenu(var menuStrings: OleVariant; var menuStates: OleVariant);
    procedure LoadDocument(var pathIn: OleVariant; var promptUser: OleVariant);
    procedure SaveDocument(var pathIn: OleVariant; var promptUser: OleVariant);
    property ShowBorders: WordBool read Get_ShowBorders write Set_ShowBorders;
    property ActualTextRange: IHTMLTxtRange read  FActualTxtRange;
    //this is the general interface
    function NewDocument: HResult; virtual;
    procedure AssignDocument;
    procedure LoadURL(url: String);
    function Go(Url: String): HResult;
    function LoadFile(var aFileName: String; PromptUser: Boolean): HResult; overload; virtual;
    function LoadFile(var aFileName: String): HResult; overload; virtual;
    function EndCurrentDoc(CancelPosible: Boolean = False; SkipDirtyCheck: Boolean = False): HResult; virtual;
    Function GetPersistedFile: String;
    property IsDirty: Boolean read GetDirty write SetDirty;
    property DOC: IHTMLDocument2 read GetDOC;
    property DOM: IHTMLDocument2 read GetDOC;   //just to enable old coding style
    function CmdGet(cmdID: CMDID; pInVar: OleVariant): OleVariant; overload;
    function CmdSet_B(cmdID: CMDID; pIn: Boolean): HResult; overload; virtual;
    function CmdSet_S(cmdID: CMDID; pIn: String): HResult; overload; virtual;
    function CmdSet_I(cmdID: CMDID; pIn: Integer): HResult; overload; virtual;
    function QueryStatus(cmdID: CMDID): OLECMDF; virtual;
    function QueryEnabled(cmdID: CMDID): Boolean; virtual;
    function QueryLatched(cmdID: CMDID): Boolean;
    function BeginUndoUnit(aTitle: String = 'Default'): HResult;
    function EndUndoUnit: HResult;
    procedure Refresh;
    property DocumentHTML: String read GetDocumentHTML write SetDocumentHTML;
    property Busy: Boolean read Get_Busy;
    function GetStyles: String;
    function GetBuildInStyles: String;
    function GetExternalStyles: String;
    function SetStyle(aStyleName: string): HResult; safecall;
    function GetStylesIndex: Integer; overload; safecall;
    function GetStylesIndex(aList: String): Integer; overload; safecall;
    function GetFonts: String;
    function GetFontSizeIndex(const aList: String; var Changed: String): Integer; safecall;
    function GetFontNameIndex(aList: String): Integer; safecall;
    function GetCurrentFontName: string;
    function SelectedDocumentHTML(var SelStart, SelEnd: Integer): String;
    procedure SyncDOC(HTML: string; SelStart, SelEnd: Integer);
    function Print(value: TPrintSetup; Showdlg: boolean = false): Boolean;
    function PrintEx(value: Olevariant; Showdlg: boolean): HResult; overload;
    function PrintPreview(value: Olevariant): HResult; overload;
    function PrintPreview(value: TPrintSetup): Boolean; overload;
    procedure PrintDocument(var withUI: OleVariant);
    property ActualAppName: string read GetActualAppName write SetActualAppName;
    property ActualTxtRange: IHTMLTxtRange read GetActualTxtRange;
    property ActualControlRange: IHTMLControlRange read GetActualControlRange;
    property ActualElement: IHTMLElement read GetActualElement;
    property ActualRangeIsText: Boolean read FActualRangeIsText;
    function IsSelElementLocked: boolean;
    Function GetFirstSelElement(const aTag: String = ''): IHTMLElement;
    Function GetNextSelElement(const aTag: String = ''): IHTMLElement;
    procedure GetSelParentElement;
    function GetSelParentElementType(const aType: string; aMessage: string = ''): IHTMLElement;
    Function IsSelType(aType: string): boolean;
    Function IsSelElementID(const ID: String): Boolean;
    Function IsSelElementClassName(const ClassName: String): Boolean;
    Function IsSelElementTagName(const TagName: String): Boolean;
    Function IsSelElementInVisible: Boolean;
    function IsSelElementAbsolute: boolean;
    Function GetSelText: String;
    procedure TrimSelection;
    procedure SelectActualTextrange;
    procedure SelectElement(aElement: IhtmlElement);
    function SetCursorAtElement(aElement: IhtmlElement; ADJACENCY:_ELEMENT_ADJACENCY): Boolean;
    procedure CollapseActualTextrange(Start: boolean);
    procedure KeepSelectionVisible;
    procedure GetElementUnderCaret;// Refresh Selection
    function MovePointersToRange(const aRange: IHTMLTxtRange): HResult;
    function MovePointersToSel: HResult;
    function CreateElement(const tagID: _ELEMENT_TAG_ID; var NewElement: IHTMLElement; const aTxtRange: IHTMLTxtRange = nil; const Attributes: string = ''): HResult;
    function InsertElementAtCursor(var aElement: IHTMLElement; const aTxtRange: IHTMLTxtRange = nil): HResult;
    function MoveTextRangeToPointer(aTxtRange: IHTMLTxtRange = nil): IHTMLTxtRange ;
    function CreateMetaTag(var aMetaElement: IHTMLMetaElement): HResult;
    property SelNumberOfElements: Integer read GetSelLength;
    property Selection: Boolean read FSelection;
  published
    // EditDesigner
    property OnPreHandleEvent: TEditDesignerEvent read FPreHandleEvent write FPreHandleEvent;
    property OnPostHandleEvent: TEditDesignerEvent read FPostHandleEvent write FPostHandleEvent;
    property OnPostEditorEventNotify: TEditDesignerEvent read FPostEditorEventNotify write FPostEditorEventNotify;
    property OnTranslateAccelerator: TEditDesignerEvent read FEDTranslateAccelerator write FEDTranslateAccelerator;
    property OnKeyDown: TNotifyEventEx8 read FOnKeyDown write FOnKeyDown;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnKeyUp: TNotifyEventEx8 read FOnKeyUp write FOnKeyUp;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEventEx read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TMouseEventEx read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseEventEx read FOnMouseUp write FOnMouseUp;
    property Onmouseout: TNotifyEvent read FOnmouseout write FOnmouseout;
    property LocalUndoManager: WordBool read FLocalUndo write Set_LocalUndo;
    property Generator: String read GetGenerator write Set_Generator;
    //grid stuff
    property SnapToGridX: Integer read FGridX write SetGridX default 50;
    property SnapToGridY: Integer read FGridY write SetGridY default 50;
    property SnapToGrid: Boolean read FSnapEnabled write SetSnapEnabled Default true;
    //ktproperty OnSnapRect: TSnapRect read FExtSnapRect write FExtSnapRect;
    property BrowseMode: WordBool read GetBrowseMode write SetBrowseMode;
    property ShowDetails: boolean read FShowDetails write SetShowDetails;
    property UseDivOnCarriageReturn: WordBool read Get_UseDivOnCarriageReturn write Set_UseDivOnCarriageReturn;
    property OnContextMenuAction: TDHTMLEditContextMenuAction read FOnContextMenuAction write FOnContextMenuAction;
    property OnDisplayChanged: TNotifyEvent read FOnDisplayChanged write FOnDisplayChanged;
    // IDOCHOSTUIHANDLER
    property OnShowContextMenu: TShowContextMenuEvent read FOnShowContextmenu write FOnShowContextmenu;
    property OnShowContextMenuEx: TShowContextMenuEventEx read FOnShowContextmenuEx write FOnShowContextmenuEx;
    property OnQueryService: TQueryServiceEvent read FOnQueryService write FOnQueryService;
    property OnPreDrag: TNotifyEventEx read FOnPreDrag write FOnPreDrag;
    property OnTranslateURL: TTranslateURLEvent read FOnTranslateURL write FOnTranslateURL;
    property OnBeforeCloseFile: TNotifyEventEx2 read FBeforeCloseFile write FBeforeCloseFile;
    property OnBeforeSaveFile: TNotifyEvent read FBeforeSaveFile write FBeforeSaveFile;
    property OnAfterSaveFile: TNotifyEvent read FAfterSaveFile write FAfterSaveFile;
    property OnAfterSaveFileAs: TNotifyEvent read FAfterSaveFileAs write FAfterSaveFileAs;
    property OnAfterLoadFile: TNotifyEventEx2 read FAfterLoadFile write FAfterLoadFile;
    property OnEDMessageHandler: TMessageEvent read FEDMessageHandler write FEDMessageHandler;
    property OnMessageHandler: TMessageEventEx read FMessageHandler write FMessageHandler;
    property OnBlur: TNotifyEvent read FOnBlur write FOnBlur;
    Property OnInitialize: TNotifyEventEx4 read FOnInitialize write FOnInitialize;
    property OnBeforePrint: TNotifyEventEx read FonBeforePrint write FonBeforePrint;
    property OnAfterPrint: TNotifyEventEx read FonAfterPrint write FonAfterPrint;
    property OnUnloadDoc: TNotifyEventEx read FOnUnloadDoc write FOnUnloadDoc;
    property OnRefreshBegin: TRefreshEvent read FOnRefreshBegin write FOnRefreshBegin;
    property OnRefreshEnd: TNotifyEvent read FOnRefreshEnd write FOnRefreshEnd;
    property OnDocumentComplete: TNotifyEvent read FOnDocumentComplete write FOnDocumentComplete;
    property Appearance: TDHTMLEDITAPPEARANCE read Get_Appearance write Set_Appearance;
    property BaseURL: String read GetBaseURL write SetBaseURL;
    property Scrollbars: WordBool read Get_Scrollbars write Set_Scrollbars default true;
    property ScrollbarAppearance: TDHTMLEDITAPPEARANCE read Get_ScrollbarAppearance write Set_ScrollbarAppearance;
    property AbsoluteDropMode: Boolean read Get_AbsoluteDropMode write Set_AbsoluteDropMode;
    property _2DPosition: Boolean read F2DPosition write Set2DPosition;
    property LiveResize: Boolean read FLiveResize write SetLiveResize;
    //the editor will try to load a file from paramstr(1) - has no meaning inside a OCX 
    property ParamLoad: Boolean read FParamLoad write FParamLoad;
  end;


threadVar
  TheActualAppName: String;


procedure Register;

implementation

uses SysUtils, dialogs, FileCtrl, ComObj,
     {$IFDEF EDUNDO} UUndo, {$ENDIF}
     {$IFDEF EDTABLE} EmbedEDTable, {$ENDIF}
     {$IFDEF EDMONIKER} KS_EDMoniker, {$ENDIF}
     {$IFDEF EDGLYPHS} CustomGlyphs, {$ENDIF}
     {$IFDEF EDLIB} EDLIB, {$ENDIF}
     {$IFDEF EDPARSER} KSIEParser, {$ENDIF}
     {$IFDEF EDDRAGDROP} dragdrop, {$ENDIF}
     {$IFDEF EDZINDEX} UZindex, {$ENDIF}
     math, //kt
     {$IFDEF EDDESIGNER} UEditDesigner, {$ENDIF}

     UEditHost, KS_Procs, KS_Procs2, IEDispConst, RegFuncs;

const
  DLCTL_DLIMAGES                    =      $00000010;
  DLCTL_VIDEOS                      =      $00000020;
  DLCTL_BGSOUNDS                    =      $00000040;
  DLCTL_PRAGMA_NO_CACHE             =      $00004000;

  CancelPosible: Boolean = true;

//------------------------------------------------------------------------------
procedure Register;
begin
  RegisterComponents('KS', [TEmbeddedED]);
end;
//------------------------------------------------------------------------------
constructor TEmbeddedED.Create(Owner: TComponent);
begin
  //asm int 3 end; //trap

  inherited Create(Owner);

  FContextMenu := TPopupMenu.Create(nil);

  FStyles := TStringList.Create;
  FStyles.Sorted := true;
  FStyles.Duplicates := dupIgnore;

  FGridX := 50; //default values on startup
  FGridY := 50;
  FSnapEnabled := true;

  FUserInterfaceOptions := [];
  // default = Border, ScrollBar, 3DScrollBar, NoDivBlockOnReturn

  FGenerator := 'KS MSHTML Edit 1.0'; //set default value

  {$IFDEF DEBUG}
     FDEbug := True;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
destructor TEmbeddedED.Destroy;
var
  CP: ICOnnectionPoint;
begin
  //asm int 3 end; //trap

  FDestroyng := true;
  UnSubClassMsHTML; //just in case
  FOleInPlaceActiveObject := nil;
  

  if (DWEBbrowserEvents2Cookie <> 0) and GetWebBrowserConnectionPoint(CP)
     then CP.UnAdvise(DWEBbrowserEvents2Cookie);

  FContextMenu.free;

  if assigned(FEditHost)
     then TObject(FEditHost).free;

  if FEdit <> nil
     then TObject(FEdit).Free;

  if FTUndo <> nil
     then TObject(FTUndo).Free;

  if FTZindex <> nil
     then TObject(FTZindex).Free;

  if FTtable <> nil
     then TObject(FTtable).Free;

  FStyles.free;
  FFonts.free;

  inherited Destroy;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.ComponentInDesignMode: Boolean;
begin
  //asm int 3 end; //trap

  result := (csDesigning in ComponentState);

  {$IFDEF EDOCX}
     if Assigned(FAXCtrl)
        then begin
           //we are using the component from an OCX
           try
              result := not (TActiveXControl(FAXCtrl).ClientSite as IAmbientDispatch).UserMode;
           except
              //just catch any error - we are NOT in design mode
              result := false;
           end;
        end;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.loaded;
var
  CP: ICOnnectionPoint;
begin
  //asm int 3 end; //trap

  inherited loaded;

  if ComponentInDesignMode
     then exit;

    { TEmbeddedED's OnDocumentComplete override TWebbrowser's OnDocumentComplete
    We sink all DWEBbrowserEvents2 - although we only use OnDocumentComplete }

  if GetWebBrowserConnectionPoint(CP)
     then CP.Advise(self, DWEBbrowserEvents2Cookie) //send events to TEmbeddedED.Invoke
     else KSMessageE('TWebBrowser''s ICOnnectionPoint could not be found');

  //set standard Download Control Values
  FDownloadControlValue := DLCTL_BGSOUNDS +        //download sounds
                           DLCTL_DLIMAGES +        //download images
                           DLCTL_VIDEOS +          //download videos
                           DLCTL_PRAGMA_NO_CACHE;  //don't use the cache

  SetUserInterfaceValue;

  //linking in the EditHost
  FEditHost := TEditHost.Create(self);
  TEditHost(FEditHost).FSnapEnabled := FSnapEnabled;
  TEditHost(FEditHost).FGridX := FGridX;
  TEditHost(FEditHost).FGridY := FGridY;
  //ktTEditHost(FEditHost).FExtSnapRect := FExtSnapRect;
  TEditHost(FEditHost).FOnPreDrag := FOnPreDrag;

  {$IFDEF EDDESIGNER}
     //linking in the EditDesigner
     FEdit := Pointer(TEditDesigner.Create(self));

     TEditDesigner(FEdit).FPreHandleEvent := FPreHandleEvent;
     TEditDesigner(FEdit).FPostHandleEvent := FPostHandleEvent;
     TEditDesigner(FEdit).FPostEditorEventNotify := FPostEditorEventNotify;
     TEditDesigner(FEdit).FOnDblClick := FOnDblClick;
     TEditDesigner(FEdit).FOnClick := FOnClick;
     TEditDesigner(FEdit).FOnKeyPress := FOnKeyPress;
     TEditDesigner(FEdit).FOnReadystatechange := FOnReadystatechange;
     TEditDesigner(FEdit).FEDTranslateAccelerator := FEDTranslateAccelerator;
     TEditDesigner(FEdit).FDebug := FDebug;
     TEditDesigner(FEdit).FOnMouseMove := FOnMouseMove;
     TEditDesigner(FEdit).FOnMouseUp := FOnMouseUp;
     TEditDesigner(FEdit).FOnMouseDown := FOnMouseDown;
     TEditDesigner(FEdit).FOnKeyUp := FOnKeyUp;
     TEditDesigner(FEdit).FOnKeyDown := FOnKeyDown;
     TEditDesigner(FEdit).FOnmouseout := FOnmouseOut;
     TEditDesigner(FEdit).FOnmouseover := EDOnmouseover;
  {$ENDIF}


  {$IFDEF EDZINDEX}
     FTZindex := Pointer(TZindex.Create(self));
  {$ENDIF}
 
  {$IFDEF EDTABLE}
     FTtable := Pointer(TTable.Create(self));
  {$ENDIF}


  FIEVersion := ReadRegString(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Internet Explorer\', 'Version');
  if length(FIEVersion) > 0
     then begin
        FIE6 := FIEVersion[1] >= '6';

        if (not FIE6)
           then begin
              if (FIEVersion[1] < '5') or (FIEVersion[3] < '5')
                 then KSMessageE('This HTML-editor Component '+CrLf+'need IE 5.5 or higher');
           end;
     end;

  FWarmingUp := true;
  AssignDocument;         //basic initialisation of MSHTML
  FWarmingUp := false; 

  GetInPlaceActiveObject; //initialise FOleInPlaceActiveObject

  if FShowBorders
     then CmdSet_B(IDM_SHOWZEROBORDERATDESIGNTIME, true);

  if FEditMode
     then begin
        //initialisation of MSHTML edit mode

        {$IFDEF EDLIB}
           InitializeGenerator(Self);
        {$ENDIF}

        DOC.designMode := 'On';
        //CmdSet(IDM_EDITMODE); //Not currently supported - but it works !!
  end;

  if FAXCtrl = nil   //Only do this in VCL mode, the OCX needs a later initialization
     then EditInitialize;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.EditInitialize;
var
  aFile: String;
begin
  //asm int 3 end; //trap

  if ComponentInDesignMode
     then exit;

  aFile := '';

  //get a file to open at start-up
  if Assigned(FOnInitialize)
     then FOnInitialize(Self, aFile); //get a initial file name

  if FParamLoad and (aFile = '')
     //if no file yet, look for a param - NB will not work inside an OCX
     then aFile := Paramstr(1);

  if aFile <> ''
     then begin
        if S_OK <> LoadFile(aFile)    //load a "command line" / initial file - if any
           then aFile := '';
     end;

  if aFile = ''
     then NewDocument;                //load an empty document

  _GetBuildInStyles;

  FSetInitialFocus := true;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetUserInterfaceValue;
begin
  //asm int 3 end; //trap

  FUserInterfaceValue := 0;

  if NoBorder in FUserInterfaceOptions
     then Inc(FUserInterfaceValue, DOCHOSTUIFLAG_NO3DBORDER);

  if NoScrollBar in FUserInterfaceOptions
     then Inc(FUserInterfaceValue, DOCHOSTUIFLAG_SCROLL_NO);

  if FlatScrollBar in FUserInterfaceOptions
     then Inc(FUserInterfaceValue, DOCHOSTUIFLAG_FLAT_SCROLLBAR);

  if DivBlockOnReturn in FUserInterfaceOptions
     then Inc(FUserInterfaceValue, DOCHOSTUIFLAG_DIV_BLOCKDEFAULT);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SubClassMsHTML;
begin
  //asm int 3 end; //trap

  { We hook into the message chain in front of the MSHTML window
    after the hook is in place all massages send to MSHTML will be passed
    to EDMessageHandler first }

  if (GetInPlaceActiveObject <> nil) and
    (FmsHTMLwinHandle <> 0) then begin
    if EDMessageHandlerPtr <> nil then begin
      UnSubClassMsHTML;
    end;

    //create handle to EDMessageHandler
    EDMessageHandlerPtr := MakeObjectInstance(EDMessageHandler);

    //save pointer to the FmsHTMLwinHandle window
    FmsHTMLwinPtr := Pointer(SetWindowLong(FmsHTMLwinHandle, GWL_WNDPROC, LongInt(EDMessageHandlerPtr)));
  end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.UnSubClassMsHTML;
begin
  //asm int 3 end; //trap

  if (GetInPlaceActiveObject <> nil) and
     (FmsHTMLwinHandle <> 0) and
     (EDMessageHandlerPtr <> nil)
     then begin
        //restore old MSHTML window as target
        SetWindowLong(FmsHTMLwinHandle, GWL_WNDPROC, LongInt(FmsHTMLwinPtr));

        FreeObjectInstance(EDMessageHandlerPtr);
        EDMessageHandlerPtr := nil;
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SubMessageHandler(var Message: TMessage);
begin
  //overridden by derived components
end;

function TEmbeddedED.SubFocusHandler(fGotFocus: BOOL): HResult; 
//kt added
begin
  //overridden by derived components
end;

//------------------------------------------------------------------------------
procedure TEmbeddedED.EDMessageHandler(var Message: TMessage);
var
  WinMsg: TMsg;
  handled: boolean;
  //kt 8/16 Transformed: boolean;

  //----------------------------------------------------------
  function HandlingDone(handled: Boolean): boolean;
  begin
    if handled then begin
      Message.Result := 1;
    end;
    result := handled;
  end;
  //----------------------------------------------------------
  //kt 8/16 original  --> procedure transformMessage;
  Function TransformMessage (AMessage: TMessage) : TMsg;
  begin
    Result.HWnd := Handle;
    Result.Message := Message.Msg ;
    Result.WParam := Message.WParam;
    Result.LParam := Message.LParam;
    Result.Time := GetMessageTime;
    GetCursorPos(Result.Pt);
    {  //kt original block.
    if transformed then exit;
    WinMsg.HWnd := Handle;
    WinMsg.Message := Message.Msg ;
    WinMsg.WParam := Message.WParam;
    WinMsg.LParam := Message.LParam;
    WinMsg.Time := GetMessageTime;
    GetCursorPos(WinMsg.Pt);
    transformed := true;
    }
  end;
  //----------------------------------------------------------
begin
  //asm int 3 end; //trap

  {when key messages arrives here from a
     VCL implementation they they are offset with CN_BASE but can come by
     a second time with no CN_BASE offset.
     OCX implementation they are not offset }

  { all messages to MSHTML comes through here - KEEP IT LEAN.
    if Handled is not set to true then the message is dispatched back to MSHTML. }

  //kt transformed := false;
  Handled := false;

  if assigned(FMessageHandler) then begin  //external assigned message handler
    FMessageHandler(Self, Message.Msg, Message.WParam, Message.LParam, Message.Result);
    if Message.Result = 1 then begin
      exit;
    end;
  end;

  if assigned(FEDMessageHandler) then begin //external assigned message handler
    WinMsg := TransformMessage(Message);
    FEDMessageHandler(WinMsg, handled);
    if HandlingDone(handled) then begin
      exit;
    end;
  end;

  {$IFDEF EDTABLE}
  //let the "table unit" have a look at the message
  if assigned(FTtable) and (Not FDestroyng) and
    (TTable(FTtable).CheckMessage(Message)) then begin
    exit;
   end;
  {$ENDIF}

  {$IFDEF EDZINDEX}
  //let the "UZindex unit" have a look at the message
  if assigned(FTZindex) and (Not FDestroyng) and
    (TZindex(FTZindex).CheckMessage(Message)) then begin
    exit;
  end;
  {$ENDIF}

  SubMessageHandler(Message);
  if Message.Result = 1 then begin
    exit;
  end;

  //send the message back to the subclassed MSHTML window
  Message.Result := CallWindowProc(FmsHTMLwinPtr, FmsHTMLwinHandle, Message.Msg, Message.WParam, Message.LParam);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetWebBrowserConnectionPoint(var CP: ICOnnectionPoint): boolean;
var
  CPC: IConnectionPointContainer;
begin
  //asm int 3 end; //trap

  TwebBrowser(Self).ControlInterface.QueryInterface(IConnectionPointContainer, CPC);
  if assigned(CPC)
     then CPC.FindConnectionPoint(DWEBbrowserEvents2, CP);

  result := Assigned(CP);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
           Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
var
  dps: TDispParams absolute Params;
  pDispIds: PDispIdList;
  iDispIdsSize: integer;
  handled: Boolean;

  //-------------------------------------------
   procedure BuildPositionalDispIds;
   var
     i: integer;
   begin
     pDispIds := nil;
     iDispIdsSize := dps.cArgs * SizeOf(TDispId);
     GetMem(pDispIds, iDispIdsSize);

     // by default, directly arrange in reverse order
     for i := 0 to dps.cArgs - 1 do
       pDispIds^[i] := dps.cArgs - 1 - i;

     if (dps.cNamedArgs > 0) // check for named args
        then begin
           // parse named args
           for i := 0 to dps.cNamedArgs - 1 do
              pDispIds^[dps.rgdispidNamedArgs^[i]] := i;
        end;
   end;
  //-------------------------------------------
begin
  //asm int 3 end; //trap
  Result := S_OK;

  case Dispid of
     DISPID_AMBIENT_DLCONTROL:
        if (Flags and DISPATCH_PROPERTYGET <> 0) and (VarResult <> nil)
           then begin
              PVariant(VarResult)^ := FDownloadControlValue;
              Exit;
           end;

     259: //DWebBrowserEvents2.OnDocumentComplete
        if dps.cArgs > 0
           then begin
              BuildPositionalDispIds;
              //call the our DocumentComplete event handler
              DocumentComplete(self,                           //Sender: TObject
              IDispatch(dps.rgvarg^[pDispIds^[0]].dispval),      //pDisp: IDispatch
              POleVariant(dps.rgvarg^[pDispIds^[1]].pvarval)^,  //URL: OleVariant
              handled);
              FreeMem (pDispIds, iDispIdsSize);
              Exit;
            end;

     104 : //DWebBrowserEvents2.DownloadComplete
        begin
           EDOnDownloadComplete(Self);
           Exit;
        end;

     DISPID_HTMLWINDOWEVENTS2_ONBLUR:
        if dps.cArgs > 0
           then begin
              BuildPositionalDispIds;
              EDOnDocBlur(self,                                  //Sender: TObject
                          IHTMLEventObj(dps.rgvarg^[pDispIds^[0]].dispval)); //pEvtObj: IHTMLEventObj
              FreeMem (pDispIds, iDispIdsSize);
              Exit;
           end;

     DISPID_HTMLWINDOWEVENTS2_ONUNLOAD:
        if dps.cArgs > 0
           then begin
              BuildPositionalDispIds;
              EDOnUnloadDoc(self,                                //Sender: TObject
                            IHTMLEventObj(dps.rgvarg^[pDispIds^[0]].dispval)); //pEvtObj: IHTMLEventObj
              FreeMem (pDispIds, iDispIdsSize);
              Exit;;
           end;

     DISPID_HTMLWINDOWEVENTS2_ONAFTERPRINT:
        if dps.cArgs > 0
           then begin
              BuildPositionalDispIds;
              EDAfterPrint(self,                                 //Sender: TObject
                           IHTMLEventObj(dps.rgvarg^[pDispIds^[0]].dispval)); //pEvtObj: IHTMLEventObj
              FreeMem (pDispIds, iDispIdsSize);
              Exit;
           end;

     DISPID_HTMLWINDOWEVENTS2_ONBEFOREPRINT:
        if dps.cArgs > 0
           then begin
              BuildPositionalDispIds;
              EDBeforePrint(self,                                //Sender: TObject
                            IHTMLEventObj(dps.rgvarg^[pDispIds^[0]].dispval)); //pEvtObj: IHTMLEventObj
              FreeMem (pDispIds, iDispIdsSize);
              Exit;
           end;

     DISPID_HTMLDOCUMENTEVENTS2_ONDRAGSTART:
        if dps.cArgs > 0
           then begin
              BuildPositionalDispIds;
              EDBeforeDragStart(self,                            //Sender: TObject
                                IHTMLEventObj(dps.rgvarg^[pDispIds^[0]].dispval)); //pEvtObj: IHTMLEventObj
              FreeMem (pDispIds, iDispIdsSize);
              Exit;
           end;


     DISPID_HTMLELEMENTEVENTS2_ONMOVESTART:
        Beep;

     (*
     //return S_OK for unhandled members of HTMLWindowEvents2
     1002, 1003, 1014, 1016, 1017, -2147418102, -2147418111: exit;

     //return S_OK for unhandled members of DWebBrowserEvents2
     102, 105, 106, 108, 112, 113, 250, 251, 252, 253, 254, 255, 256,
     257, 258, 260, 262, 236, 234, 265, 266, 267, 268, 269, 270 : exit;
     *)
  end; //case

  //let TOleControl handle the invoke
  Result := inherited Invoke(DispID, IID, LocaleID, Flags, Params, VarResult, ExcepInfo, ArgErr);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetTypeInfoCount(out Count: Integer): HResult;
begin
  //asm int 3 end; //trap
  Result := inherited GetTypeInfoCount(Count);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  //asm int 3 end; //trap
  Result := inherited GetTypeInfo(Index, LocaleID, TypeInfo);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  //asm int 3 end; //trap
  Result := inherited GetIDsOfNames(IID, Names, NameCount, LocaleID, DispIDs);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.OnChanged(dispid: TDispID): HResult;
var
  dp: TDispParams;
  vResult: OleVariant;
begin
  //asm int 3 end; //trap

  { Dispid = Dispatch identifier of the property that changed,
    or DISPID_UNKNOWN if multiple properties have changed. }
  if (TwebBrowser(Self).Document <> nil) and (DISPID_READYSTATE = Dispid)
     then begin
        if SUCCEEDED(Doc.Invoke(DISPID_READYSTATE, GUID_null,
                     LOCALE_SYSTEM_DEFAULT, DISPATCH_PROPERTYGET,
                     dp, @vresult, nil, nil))
        then FReadyState := Integer(vresult);
     end;

  result := inherited OnChanged(dispid);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.OnRequestEdit(dispid: TDispID): HResult;
begin
  //asm int 3 end; //trap
  result := inherited OnRequestEdit(dispid);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.EDBeforeDragStart(Sender: TObject; const pEvtObj: IHTMLEventObj);
var
  Done: Boolean;
begin
  //asm int 3 end; //trap

  beep;

  if assigned(FonBeforePrint)
     then begin
        Done := false;
        beep;
        //FonBeforePrint(self, Done);
        if Done
           then pEvtObj.returnValue := True;
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.EDBeforePrint(Sender: TObject; const pEvtObj: IHTMLEventObj);
var
  Done: Boolean;
begin
  //asm int 3 end; //trap

  if assigned(FonBeforePrint)
     then begin
        Done := false;
        FonBeforePrint(self, Done);
        if Done
           then pEvtObj.returnValue := True;
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.EDAfterPrint(Sender: TObject; const pEvtObj: IHTMLEventObj);
  { MSHTML stores a copy of the HTML source in a cache from where it is printed.

    EDAfterPrint is fired when MSHTML has finished saving the document,
    at the state it vas in, into cache }
var
  Done: Boolean;
begin
  //asm int 3 end; //trap
  FPrintFinished := true;

  if assigned(FonAfterPrint)
     then begin
        Done := false;
        FonAfterPrint(self, Done);
        if Done
           then pEvtObj.returnValue := True;
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.EDOnUnloadDoc(Sender: TObject; const pEvtObj: IHTMLEventObj);
var
  Done: Boolean;
begin
  //asm int 3 end; //trap

  FStylesRefreshed := False; //we need to load a fresh set together with the next document

  if assigned(FOnUnloadDoc)
     then begin
        Done := false;
        FOnUnloadDoc(self, Done);
        if Done
           then pEvtObj.returnValue := True;
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.EDOnDocBlur(Sender: TObject; const pEvtObj: IHTMLEventObj);
begin
  //asm int 3 end; //trap

  if FWarmingUp
     then exit;

  {$IFDEF EDLIB}
     KeepSelection(Self);
  {$ENDIF}

  {$IFDEF EDTABLE}
     if assigned(FTtable) and (Not FDestroyng)
        then TTable(FTtable).TblOnBlur;
  {$ENDIF}

  if Assigned(FOnBlur)
     then FOnBlur(Self);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.EDOnDownloadComplete(Sender: TObject);
var
  aURL: OleVariant;
  handled: Boolean;
begin
  //asm int 3 end; //trap

  if FRefreshing
     //Refresh page and some other things don't result in a Document complete
     then begin
        FRefreshing := False;

        aURL := Doc.URL;
        DocumentComplete(Self, nil, aURL, handled);

        If Assigned(FOnRefreshEnd)
           then FOnRefreshEnd(Self);
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.WaitAsync;
begin
  //asm int 3 end; //trap
  
  FWaitMessage := false;

  PostMessage(FMainWinHandle, WaitAsync_MESSAGE, 0, 0);

  while not FWaitMessage do
     SafeYield;
end;
//------------------------------------------------------------------------------
Procedure TEmbeddedED.GetSourceSnapShot;
{$IFNDEF EDLIB}
  var
     TempStream: TMemoryStream;
{$ENDIF}
begin
  //asm int 3 end; //trap

  {$IFNDEF EDLIB}
     { First we need to force MSHTML to tidy up the source the way it wants.
       MSHTML inserts and updates certain elements in the <HEAD> when it saves
       the file }

     TempStream := TMemoryStream.Create;
     try
        //just a dummy save
        PersistStream.save(TStreamAdapter.Create(TempStream), true);
     finally
        TempStream.free;
     end;
  {$ENDIF}

  FHTMLImage := KS_Lib.GetHTMLtext(DOC); //Get Snapshot of HTML Source
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.ShowCaret;
begin
  //asm int 3 end; //trap
  FCaret.Show(0);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.GetBaseTag(var BaseTagInDoc: Boolean; var BaseUrl: String);
var
  aElement: IHTMLElement;
  aCollection: IHTMLElementCollection;
  aDomNode, HTMLF, HTMLP: IHTMLDomNode;
  i: integer;
  DOC3: IHTMLDocument3;
  S: String;
  I2: Integer;
  DESIGNTIMEBASEURLfound: Boolean;
begin
  //asm int 3 end; //trap
  { if the source have a <BASE...> tag without a </BASE> tag, IE renders
    the source wrongly and we must correct it.

    If <BASE> is followed by other tags in the <HEAD> these may end up as
    children of <BASE> rather than children of <HEAD>

    The problem does not appear if the <BASE...> tag is followed by </BASE>

    Parsing trough IHTMLDomNode MSHTML not only it places the body in the
    wrong place, but it also duplicates it:

    HTML
     |-HEAD
     |  |-TITLE
     |  |-BASE
     |     |-META
     |     |-META
     |     |-BODY
     |-BODY

    Parsed trough IHTMLElement MSHTML produces a tree that looks like this:

    HTML
     |-HEAD
        |-TITLE
        |-BASE
           |-META
           |-META
           |-BODY


    The following code will cleanup a bad example as this:

    <html>
    <head>
    <title>test</title>
    <base target="_self" href="URL">
    <meta name="1" content="1">
    <base target="_self" href="UL">
    <meta name="2" content="2">
    </head>
    <body>
    empty
    </body>
    </html>

    }

  BaseTagInDoc := false;
  DESIGNTIMEBASEURLfound := false;
  BaseURL := '';

  DOC3 := DOC as IHTMLDocument3;

  aCollection := DOC3.getElementsByTagName('BASE') as IHTMLElementCollection;
  if aCollection.length > 0
     then begin
        for i := 0 to aCollection.length - 1 do
           begin
              aElement := aCollection.item(i, 0) as IHTMLElement;

              if not assigned(aElement)
                 then continue;

              // we take the BaseURL from the last found base tag except if
              // its a DESIGNTIMEBASEURL
              if pos('DESIGNTIMEBASEURL', UpperCase(aElement.outerHTML)) = 0
                 then begin
                    BaseURL := (aElement as IHTMLBaseElement).href;
                    BaseTagInDoc := true;
                 end
                 else DESIGNTIMEBASEURLfound := true;

              aDomNode := aElement as IHTMLDomNode;
              if aDomNode.hasChildNodes
                 then begin
                    HTMLP := aDomNode.parentNode;
                    HTMLF := aDomNode.firstChild;
                    aDomNode.removeNode(false); //false = do not remove child nodes
                    HTMLP.insertBefore(aDomNode, HTMLF);
                 end;

        end; //for i := 0 to
     end;

  if DESIGNTIMEBASEURLfound
     then begin
        aCollection := DOC3.getElementsByTagName('BASE') as IHTMLElementCollection;
        if aCollection.length > 0
           then begin
              for i := 0 to aCollection.length - 1 do
                 begin
                    aElement := aCollection.item(i, 0) as IHTMLElement;

                    if assigned(aElement) and
                       (pos('DESIGNTIMEBASEURL', UpperCase(aElement.outerHTML)) > 0)
                       then begin
                          //remove any temporary BASE tag
                          aDomNode := aElement as IHTMLDomNode;
                          aDomNode.removeNode(false);
                       end
                 end;
           end;
     end;
end;
//------------------------------------------------------------------------------

procedure TEmbeddedED.OpenPointers;
//kt moved from inside DocumentComplete()
var
   FDisplayServices: IDisplayServices;
begin
   //asm int 3 end; //trap

   {$IFDEF EDDESIGNER}
      if assigned(FEdit)
         then TEditDesigner(FEdit).Connect(TWebBrowser(self).Document); //Connect EditDesigner
   {$ENDIF}

   {$IFDEF EDTABLE}
     if assigned(FTtable)
         then TTable(FTtable).OpenPointers;
   {$ENDIF}

   FDisplayServices := DOC as IDisplayServices;
   OleCheck(FDisplayServices.GetCaret(IHTMLCaret(FCaret)));

   OleCheck(FDisplayServices.CreateDisplayPointer(FDisplayPointerStart));
   OleCheck(FDisplayServices.CreateDisplayPointer(FDisplayPointerEnd));
   OleCheck(FDisplayServices.CreateDisplayPointer(FTMGDisplayPointer));  //kt added

   //kt FMarkUpServices := Doc as MSHTML_TLB.IMarkupServices;
   FMarkUpServices := Doc as MSHTML_EWB.IMarkupServices;  //kt

   OleCheck(FMarkUpServices.CreateMarkupPointer(FMarkupPointerStart));
   OleCheck(FMarkUpServices.CreateMarkupPointer(FMarkupPointerEnd));

   FHighlight := Doc as IHighlightRenderingServices;

   FRenderStyle := (TwebBrowser(Self).Document as IHTMLDocument4).createRenderStyle('');

   //false turns off (default) black and uses $8A2BE2 as highlight colour
   FRenderStyle.Set_defaultTextSelection('false');
   FRenderStyle.Set_textBackgroundColor($8A2BE2);
end;


procedure TEmbeddedED.DocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant; var HandlingComplete: Boolean);
var
  IW: IwebBrowser2;
  adoc: IhtmlDocument2;
  iDocDisp: IDispatch;

  //-----------------------------------------------------------
  (*
  procedure OpenPointers;
  var
     FDisplayServices: IDisplayServices;
  begin
     //asm int 3 end; //trap

     {$IFDEF EDDESIGNER}
        if assigned(FEdit)
           then TEditDesigner(FEdit).Connect(TWebBrowser(self).Document); //Connect EditDesigner
     {$ENDIF}

     {$IFDEF EDTABLE}
       if assigned(FTtable)
           then TTable(FTtable).OpenPointers;
     {$ENDIF}

     FDisplayServices := DOC as IDisplayServices;
     OleCheck(FDisplayServices.GetCaret(IHTMLCaret(FCaret)));

     OleCheck(FDisplayServices.CreateDisplayPointer(FDisplayPointerStart));
     OleCheck(FDisplayServices.CreateDisplayPointer(FDisplayPointerEnd));
     OleCheck(FDisplayServices.CreateDisplayPointer(FTMGDisplayPointer));  //kt added

     //kt FMarkUpServices := Doc as MSHTML_TLB.IMarkupServices;
     FMarkUpServices := Doc as MSHTML_EWB.IMarkupServices;  //kt

     OleCheck(FMarkUpServices.CreateMarkupPointer(FMarkupPointerStart));
     OleCheck(FMarkUpServices.CreateMarkupPointer(FMarkupPointerEnd));

     FHighlight := Doc as IHighlightRenderingServices;

     FRenderStyle := (TwebBrowser(Self).Document as IHTMLDocument4).createRenderStyle('');

     //false turns off (default) black and uses $8A2BE2 as highlight colour
     FRenderStyle.Set_defaultTextSelection('false');
     FRenderStyle.Set_textBackgroundColor($8A2BE2);
  end;
  *)
  //----------------------------------------------------
begin
  //asm int 3 end; //trap

  { a derived component need a way to know if this DocumentComplete is completely
    handled - i.e. when we sets the BaseUrl - or this is a "real" DocumentComplete.
    If this eventhandler isn't exited then HandlingComplete is set to false at
    the very end }
  HandlingComplete := true;

  if FWarmingUp
     then exit;

  //just a test that newer seems to become true
  if Fdebug and (FReadyState <> READYSTATE_COMPLETE)
     then beep;

  if pDisp = nil then   //kt added
    exit;               //kt added
  iDocDisp := (pDisp as IwebBrowser2).Document;

  // NOTE: iDocDisp may be NIL or may be not an HTML document!!!
  if (iDocDisp = nil) or
     (iDocDisp.QueryInterface(IHTMLDocument2, aDoc) <> S_OK) or
     (aDoc <> DOC)
     then exit;

  ShowCursor(true);

  if not FSettingBaseURL
     then begin
        if not FkeepPath
           then begin
              FCurrentDocumentPath := GetPersistedFile;
              FBaseUrl := _CurDir;
           end;

        { according to DHTMLEdit specs FBaseURL is set to the loaded files base.
          If the loaded file contains a BASE tag then BASEUrl is set accordingly
          in InitializeUndoStack }

        {$IFDEF EDLIB}
           InitializeUndoStack(Self, FBaseTagInDoc, FBaseUrl);
        {$ELSE}
           GetBaseTag(FBaseTagInDoc, FBaseUrl);
           if not BrowseMode
              then _CheckGenerator;
        {$ENDIF}

        {$IFDEF EDUNDO}
           if FLocalUndo
              then OpenChangeLog;
        {$ENDIF}
     end;

  FkeepPath := false;


  //restore WYSIWYG scroll position if needed
  if FScrollTop > 0
     then ScrollDoc(FScrollTop);

  OpenPointers;

  if FEditMode
     then begin
        if FShowDetails
           then begin
              {$IFDEF EDGLYPHS}
                 ShowDefaultGlyphs(Self);
              {$ELSE}
                 CmdSet(IDM_SHOWALLTAGS);
              {$ENDIF}
           end;

        //kt if F2DPosition
        //kt   then CmdSet_B(IDM_2D_POSITION, true);

        //kt if FLiveResize
        //kt   then CmdSet_B(IDM_LIVERESIZE, true);

        //set cursor to beginning of document
        SetCursorAtElement(DOC.elementFromPoint(1,1), ELEM_ADJ_AfterBegin);
     end;

  HookEvents;

  if FSettingBaseURL //nothing more to do
     then begin
        FSettingBaseURL := false;
        exit;
     end;

  if FLoadFromString
     then begin
        FLoadFromString := false;
        FHTMLImage := ''; //a document loaded from a string is always dirty

        if FEditMode
           then ClearUndoStack; //we cant allow old undo's after loading a "new" document
     end
     else begin
        if FEditMode
           then GetSourceSnapShot;
     end;

  //if we have a user created event handler call it
  if assigned(FOnDocumentComplete)
     then FOnDocumentComplete(Self);

  HandlingComplete := false;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.HookEvents;
var
  aCPC: IConnectionPointContainer;
  aCP: IConnectionPoint;
  aCookie: Integer;
begin
  //asm int 3 end; //trap

  Doc.parentWindow.QueryInterface(IConnectionPointContainer, aCPC);

  //this events is automatically released when the document is unloaded
  aCPC.FindConnectionPoint(HTMLWindowEvents2, aCP);
  aCP.Advise(self, aCookie);  //send events to TEmbeddedED.Invoke

  {$IFDEF EDZINDEX}
     if Assigned(FTZindex)
        then TZindex(FTZindex).HookEvents;
  {$ENDIF}

  //IpropertyNotifySink is automatic connected, so we do nothing here
end;
//------------------------------------------------------------------------------
function TEmbeddedED.ShowContextMenu(const dwID: DWORD; const ppt: PPOINT; const pcmdtReserved: IUnknown; const pdispReserved: IDispatch): HRESULT;
begin
  //Called from MSHTML to display a context menu
  //asm int 3 end; //trap

  if Assigned(FOnShowContextmenu)
     then begin
        Result := FOnSHowContextmenu(dwID, ppt, pcmdtreserved, pdispreserved);
        if Result = S_OK
           then exit;
     end
     else Result := S_FALSE;

  if assigned(FOnShowContextmenuEx)
     then FOnShowContextmenuEx(Self, ppt^.X, ppt^.Y);

  if (FContextMenu.Items.count > 0)
     then begin
        Result := S_OK;
        FContextMenu.Popup(ppt^.X, ppt^.Y);
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT;
begin
  //Retrieves the UI capabilities of the MSHTML host
  //asm int 3 end; //trap

  pInfo.cbSize := SizeOf(pInfo);
  pInfo.dwFlags := FUserInterfaceValue;

  pInfo.dwDoubleClick := DOCHOSTUIDBLCLK_DEFAULT;
  Result:=S_OK;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.ShowUI(const dwID: DWORD; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT;
begin
  //Allows the host to replace the MSHTML menus and toolbars
  //asm int 3 end; //trap
  Result := S_FALSE;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.HideUI: HRESULT;
begin
  //Called when MSHTML removes its menus and toolbars
  //asm int 3 end; //trap
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED._UpdateUI;
begin
  //asm int 3 end; //trap
  UpdateUI;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.UpdateUI: HRESULT;
begin
  //Notifies the host that the command state has changed
  //asm int 3 end; //trap

  Result := S_OK;

  if (FReadyState = READYSTATE_COMPLETE) and (not FWarmingUp) and Showing
     then begin
        if FSetInitialFocus
           then begin
              SetFocusToDoc;
              FSetInitialFocus := false;
           end;

        GetElementUnderCaret;

        if Assigned(FOnDisplayChanged)
           then FOnDisplayChanged(self);
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.EnableModeless(const fEnable: BOOL): HRESULT;
begin
  //asm int 3 end; //trap
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.OnDocWindowActivate(const fActivate: BOOL): HRESULT;
begin
  //Called from the MSHTML implementation of IOleInPlaceActiveObject.OnDocWindowActivate
  //asm int 3 end; //trap
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.OnFrameWindowActivate(const fActivate: BOOL): HRESULT;
begin
  //Called from the MSHTML implementation of IOleInPlaceActiveObject.OnFrameWindowActivate
  //asm int 3 end; //trap
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT;
begin
  //Called from the MSHTML implementation of IOleInPlaceActiveObject.ResizeBorder
  //asm int 3 end; //trap
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT;
begin
  //asm int 3 end; //trap
  { Called by MSHTML when IOleInPlaceActiveObject.TranslateAccelerator or
    IOleControlSite.TranslateAccelerator is called }
  //called by VCL
  //called by OCX

  { by OCX this is called from:
    from: if FOleInPlaceActiveObject.TranslateAccelerator(WinMsg) = S_OK
    in:   procedure TOleControl.WndProc(var Message: TMessage);

    after this call comes calls to:
    TEmbeddedED._TranslateAccelerator
    TEditDesigner.TranslateAccelerator
    TEmbeddedED.OleControlSite_TranslateAccelerator
  }

  Result := E_NOTIMPL;
  { if we return S_OK then no further call to other "translate accelerator" occurs
    because TOleControl.WndProc doesn't delegate the message further up the chain}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD): HRESULT;
begin
  //Returns the registry key under which MSHTML stores user preferences
  //asm int 3 end; //trap
  pchKey := nil;
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HRESULT;
begin
  { Called by MSHTML when it is being used as a drop target to allow the host
    to supply an alternative IDropTarget }
  //asm int 3 end; //trap

  {$IFDEF EDDRAGDROP}
     result := InitializeDropTarget(Self, pDropTarget, ppDropTarget);
  {$ELSE}
     Result := E_NOTIMPL;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetExternal(out ppDispatch: IDispatch): HRESULT;
begin
  { Called by MSHTML to obtain the host's IDispatch interface.
    There is a sample on how to use it here:
    http://www.euromind.com/iedelphi/embeddedwb/ongetexternal.htm }
  //asm int 3 end; //trap

  ppDispatch := nil;
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HRESULT;
var
  Changed: boolean;
  URL: string;
begin
  { Called by MSHTML to allow the host an opportunity to modify the URL to be loaded
    NB TranslateUrl is not called when you use Navigate or Navigate2 but only when a
    hyperlink is clicked }
  //asm int 3 end; //trap

  if Assigned(FOnTranslateURL)
     then begin
        Changed := False;
        URL := OleStrToString(pchURLIn);
        FOnTranslateURL(Self, URL, Changed);
        if Changed
           then begin
              ppchURLOut := StringToOleStr(URL);
              Result := S_OK;
           end
           else Result := S_FALSE;
     end
     else begin
        ppchURLOut := nil;
        Result := S_FALSE;
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HRESULT;
begin
  { Called on the host by MSHTML to allow the host to replace MSHTML's data object.
    Returns S_OK if the data object is replaced, or S_FALSE if it's not replaced.

    Although the documentation does not explicitly mention it, it will only be
    called in paste situations }
  //asm int 3 end; //trap

  ppDORet := nil;
  Result := S_FALSE;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.QueryService(const rsid, iid: TGuid; out Obj): HResult;
begin
  //asm int 3 end; //trap
  IUnknown(obj) := nil;

  if IsEqualGUID(rsid, SID_SHTMLEDitHost) and FEditMode
     then result := TEditHost(FEditHost).QueryService(rsid, iid, IUnknown(obj))
     else begin
        if Assigned(FOnQueryService)
           then Result := FOnQueryService(rsid, iid, IUnknown(obj))
           else Result := E_NOINTERFACE;
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.LoadFromStrings(aStrings: TStrings): HResult;
begin
  //asm int 3 end; //trap

  result := LoadFromString(aStrings.Text);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.LoadFromString(aString: String): HResult;
{$IFNDEF EDMONIKER}
var
  aHandle: THandle;
  aStream: IStream;
{$ENDIF}
begin
  //asm int 3 end; //trap

  FLoadFromString := true;

  {$IFDEF EDMONIKER}
     FKeepPath := True;
     result := LoadFromStringMoniker(Self, aString);
  {$ELSE}
     FCurrentDocumentPath := '';
     aHandle := GlobalAlloc(GPTR, Length(aString) + 1);
     try
        if aHandle <> 0
           then begin
              Move(aString[1], PChar(aHandle)^, Length(aString) + 1);
              CreateStreamOnHGlobal(aHandle, FALSE, aStream);
              result := LoadFromIStream(aStream);
           end
           else result := S_false;
     finally
        GlobalFree(aHandle);
     end;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
{$IFNDEF EDMONIKER}
   function TEmbeddedED.LoadFromIStream(aIStream: IStream): HResult;
   begin
     //asm int 3 end; //trap

     if not DocumentIsAssigned
        then AssignDocument;

     FReadyState := 0;
     Result := PersistStream.Load(aIStream);

     WaitForDocComplete;
   end;
{$ENDIF}
//------------------------------------------------------------------------------
procedure TEmbeddedED._CheckGenerator(MainCheck: Boolean = true);
begin
  //asm int 3 end; //trap

  {$IFDEF EDLIB}
     if MainCheck
        then CheckGenerator(Self);
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetDocumentHTML: String;
begin
  //asm int 3 end; //trap

  if ComponentInDesignMode or (TwebBrowser(Self).Document = nil)
     then Result := ''
     else begin
        _CheckGenerator(false);
        result := GetDocHTML(DOC);
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetDocumentHTML(NewHTML: String);
begin
  //asm int 3 end; //trap

  if ComponentInDesignMode
     then exit;

  if DOC = nil then  //kt
    exit;  //kt     

  //this is to avoid a very rear AV error
  if assigned(Doc.selection) then begin   //kt added
    //(Doc.selection as IHTMLSelectionObject).empty;
  end;
  GetElementUnderCaret;

  if S_OK = (DOC as IPersistMoniker).IsDirty
          // avoid, question about save file from MSHTML
     then cmdSet_B(IDM_SETDIRTY, false);

  LoadFromString(NewHTML);

  //now The document must be dirty !
  CmdSet_B(IDM_SETDIRTY, true);
  FHTMLImage := '';
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.AssignDocument;
var
  Ov: OleVariant;
begin
  //asm int 3 end; //trap
  if TwebBrowser(Self).Document = nil
     then begin
        HandleNeeded;    //or a hidden MSHTML wont respond

        Ov := AboutBlank;

        FReadyState := 0;
        //KT NOTE:  For some reason, with IE8, OnDocumentComplete is not getting fired...
        Navigate2(Ov); //this will run asynchronously and call OnDocumentComplete

        WaitForDocComplete;
        if FTMGDisplayPointer = nil then
          OpenPointers;
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Go(Url: String): HResult;
const
  FileSlash = 'file://';
var
  aURLPath: string;

  {$IFNDEF EDMONIKER}  
     FBindCtx: IBindCtx;
     aURLMoniker: IMoniker;
  {$ENDIF}

  //--------------------------------------
  function DropFilePart(S: String): String;
  begin
     result := AnsiLowerCase(S);
     if Pos(FileSlash, result) = 1
        then Delete(result, 1, length(FileSlash));

     result := StringReplace(result, '\', '/', [rfReplaceAll]);

     if Length(result) < 3
        then exit;

     if pos('//', result) = 1
        then result := AfterTokenNr(result, '/', 4)

     else if result[2] = ':'
        then delete(result, 1, 3);
  end;
  //--------------------------------------
begin
  //asm int 3 end; //trap

  result := S_FALSE;
  FBaseURL := '';

  {$IFDEF EDMONIKER}
     LoadFromEDMoniker(self, URL, '');
  {$ELSE}
    //Navigate(Url); //this is a bit unstable here so we use a URLmoniker instead
    OleCheck(CreateBindCtx(0, FBindCtx));
    CreateURLMoniker(nil, StringToOleStr(URL), aURLMoniker);

    FReadyState := 0;  //make sure WaitForDocComplete don't return immediately
    result := (DOC as IPersistMoniker).Load(false, aURLMoniker, FBindCtx, STGM_READ);

    WaitForDocComplete;
  {$ENDIF}

  //se if we got to the target
  aURLPath := GetPersistedFile;

  if pos(DropFilePart(URL), DropFilePart(aURLPath)) = 1
     then begin
        result := S_OK;

        //set BASEUrl according to the DHTMLEdit specs.
        FBaseURL := aURLPath;
        Delete(FBaseURL, LastDelimiter('\/', FBaseURL)+1, Length(FBaseURL));
     end
     else begin //just in case
        if FDebug
           then KSMessageE('Wrong URL reached'+DblCrLf+
                           'Target:'+Crlf+URL+DblCrLf+
                           'Reached:'+Crlf+ DOC.URL, 'Go-error');
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetDirty: boolean;
begin
  //asm int 3 end; //trap

  if (TwebBrowser(Self).Document = nil) or (not FeditMode)
     then begin
        result := false;
        exit;
     end;

  Result := S_OK = (DOC as IPersistMoniker).IsDirty;

  { IPersistStream.IsDirty only reports that the document has been changed since
    it was read / last saved.
    Sometimes it don't know that a change have been changed back
    - if you make some text bold and then undo it back to normal again then
      IPersistStream knows that the document isn't dirty
    - but if you doesn't undo the bold operation but change the text back to normal
      again then IPersistStream reports the document dirty although its really clean }

  if result
     then begin
        { We cant completely trust it if IPersistStream reports the document dirty.
          So we compare the original image with the actual image of HTML source }

        result := (not AnsiSameText(FHTMLImage, KS_Lib.GetHTMLtext(DOC)));

        If not result
           { no need to spend time repeating GetHTMLtext more often than necessary
             so we sync IPersistMoniker.IsDirty with the real world }
           then cmdSet_B(IDM_SETDIRTY, false);
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetDirty(_dirty: boolean);
begin
  //asm int 3 end; //trap
  if TwebBrowser(Self).Document <> nil
     then  begin
        cmdSet_B(IDM_SETDIRTY, _dirty); // Update IPersist**.IsDirty

       if not _dirty //we have just set dirty to clean
           { We really only need to get a new FHTMLImage if the current one is
             dirty - but it doesn't harm to set it again if its clean }
        then FHTMLImage := KS_Lib.GetHTMLtext(DOC);
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.QueryStatus(cmdID: CMDID): OLECMDF;
var
   Cmd: OLECMD;
   Handled: boolean;

   //----------------------------------------------------
   function DoQerry: OLECMDF;
   begin
     //asm int 3 end; //trap
     Cmd.CmdID := cmdID;
     if S_OK = CmdTarget.QueryStatus(@CGID_MSHTML, 1, @Cmd, Nil)
        then Result := Cmd.cmdf
        else result := 0; //not supported
   end;
   //----------------------------------------------------
begin
  //asm int 3 end; //trap
  { 7 = OLECMDF_SUPPORTED or OLECMDF_ENABLED or OLECMDF_LATCHED
    3 = OLECMDF_SUPPORTED or OLECMDF_ENABLED }

  result := 0;
  if TwebBrowser(Self).Document <> nil
     then begin
        //we need to catch a few special commands here
        case cmdID of
           IDM_SHOWZEROBORDERATDESIGNTIME:
              begin //MSHTML don't remember this setting
                 if FShowZeroBorderAtDesignTime
                    then result := 7
                    else result := 3;
              end;

           IDM_CONSTRAIN:
              begin
                 if FConstrain
                    then result := 7
                    else result := 3;
              end;

           IDM_Undo, IDM_Redo, IDM_DROP_UNDO_PACKAGE, IDM_DROP_REDO_PACKAGE, IDM_LocalUndoManager:
              begin
                 {$IFDEF EDUNDO}
                    if FTUndo <> nil
                       then begin
                          result := TUndo(FTUndo).QueryStatus(cmdID);
                          exit;
                       end;
                 {$ENDIF}

                 if (cmdID = IDM_Undo) or (cmdID = IDM_Redo)
                    then result := DoQerry;
                    //else result := 0
              end;

           IDM_NUDGE_ELEMENT, DECMD_LOCK_ELEMENT, DECMD_BRING_ABOVE_TEXT, DECMD_BRING_FORWARD, DECMD_BRING_TO_FRONT, DECMD_SEND_BELOW_TEXT, DECMD_SEND_TO_BACK, DECMD_SEND_BACKWARD:
              begin
                 {$IFDEF EDZINDEX}
                    if FTZindex <> nil
                       then result := TZindex(FTZindex).QueryStatus(cmdID);
                 {$ELSE}
                    //else result := 0
                 {$ENDIF}
              end;

           else begin
              Handled := false;

              {$IFDEF EDTABLE}
                 if assigned(FTtable)
                    then result := TTable(FTtable).TableQeryCommand(cmdID, Handled, self);
              {$ENDIF}

              if not Handled
                 then result := DoQerry;
           end
        end;
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.ExecCommand(cmdID: KS_Lib.CMDID; cmdexecopt: OLECMDEXECOPT; var pInVar: OleVariant): OleVariant;
begin
  //asm int 3 end; //trap
  DoCommand(cmdID, cmdexecopt, pInVar, result);
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.DoCommand(cmdID: KS_Lib.CMDID): HResult;
begin
  //asm int 3 end; //trap
  result := DoCommand(cmdID, OLECMDEXECOPT_DODEFAULT);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.DoCommand(cmdID: KS_Lib.CMDID; cmdexecopt: OLECMDEXECOPT): HResult;
begin
  //asm int 3 end; //trap
  result := DoCommand(cmdID, cmdexecopt, POlevariant(Nil)^);
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.DoCommand(cmdID: KS_Lib.CMDID; cmdexecopt: OLECMDEXECOPT; var pInVar: OleVariant): HResult;
begin
  //asm int 3 end; //trap
  result := DoCommand(cmdID, cmdexecopt, pInVar, POlevariant(Nil)^);
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.DoCommand(cmdID: KS_Lib.CMDID; cmdexecopt: OLECMDEXECOPT; var pInVar, pOutVar: OleVariant): HResult;
const
  SetError: Boolean = true;
var
  BoolInd: Boolean;
  Handled: Boolean;
  //OvParam: OleVariant;

  //------------------------------------------------------------------
  procedure TestResult(aResult: HResult; acceptError: Longint = 0);
  begin
     if FDebug and (aResult <> S_OK) and (aResult <> acceptError)
        then begin
           {$IFNDEF EDTABLE}
              if (cmdID = IDM_RestoreSystemCursor) or (cmdID = IDM_STRIPCELLFORMAT)
                 then exit;
           {$ENDIF}

           KSMessageI('cmdID: '+IntTostr(cmdID), 'MSHTML command failed');
        end;
  end;
  //------------------------------------------------------------------
  function _DoCommand(acceptError: Longint = 0): HResult;
  begin
     Result := CmdTarget.Exec(@CGID_MSHTML, cmdID, cmdexecopt, pInVar, pOutVar);
     // For some reason, IE returns not supported if the user cancels. !!
     // and we cant use OLECMDERR_E_CANCELED to avoid that problem
     TestResult(Result, acceptError);
  end;
  //------------------------------------------------------------------
  function TestBoolInd(DoSetError: Boolean = false): Boolean;
  begin
     result := (@pInVar <> nil) and (TVariantArg(pInVar).VT = VT_BOOL);
     if result
        then BoolInd := pInVar
        else begin
           if DoSetError
              then FLastError := 'pInVar must be of type boolean';
        end;
  end;
  //------------------------------------------------------------------
begin
  //asm int 3 end; //trap
  result := S_FALSE;


  if TwebBrowser(Self).Document = nil
     then begin
        AssignDocument;

        if not DocumentIsAssigned
           then begin
              if FDebug
                 then KSMessageI('DOC not assigned', 'MSHTML command skipped');
              exit;
           end;
     end;



  //we need to catch some commands here
  case cmdID of

     IDM_SHOWZEROBORDERATDESIGNTIME:
        begin //MSHTML don't remember this setting
           if TestBoolInd
              then begin
                 result := _DoCommand;
                 if result = S_OK
                    then FShowZeroBorderAtDesignTime := BoolInd;
              end
              else begin
                 result := _DoCommand;
                 if result = S_OK
                    then FShowZeroBorderAtDesignTime := not FShowZeroBorderAtDesignTime;
              end;
           TestResult(Result);
        end;

     IDM_SAVEAS: // IDM_SAVE is not supported by MSHTML
        begin
           result := _DoCommand(Integer($80040103)); //The dialog was cancelled
           if (result = S_OK) and FEditMode          //we did a save
              then FHTMLImage := KS_Lib.GetHTMLtext(DOC); //get image of original source
        end;

     IDM_CONSTRAIN:
        begin
           FConstrain := not FConstrain;
           result := S_OK;
        end;

     IDM_Undo, IDM_Redo, IDM_DROP_UNDO_PACKAGE, IDM_DROP_REDO_PACKAGE, IDM_LocalUndoManager:
        begin
           {$IFDEF EDUNDO}
              if FTUndo <> nil
                 then begin
                    TestBoolInd;
                    result := TUndo(FTUndo).DoCommand(cmdID, BoolInd, FEdit, Handled);
                    if not Handled
                       then result := _DoCommand;
                 end
                 else result := _DoCommand;
           {$ELSE}
              result := _DoCommand;
           {$ENDIF}

           TestResult(Result);
        end;

     IDM_NUDGE_ELEMENT, DECMD_LOCK_ELEMENT, DECMD_BRING_ABOVE_TEXT, DECMD_BRING_FORWARD, DECMD_BRING_TO_FRONT, DECMD_SEND_BELOW_TEXT, DECMD_SEND_TO_BACK, DECMD_SEND_BACKWARD:
        begin
           {$IFDEF EDZINDEX}
              if FTZindex <> nil
                 then result := TZindex(FTZindex).ZindexCommand(cmdID, pInVar);
           {$ELSE}
              //else result := S_FALSE
           {$ENDIF}
        end;

     KS_TEST: result := KSTest(pInVar, pOutVar);

     else begin
        handled := false;
        {$IFDEF EDTABLE}
           if assigned(FTtable)
              then result := TTable(FTtable).TableCommand(cmdID, pInVar, Handled, self);
        {$ENDIF}

        if handled
           then TestResult(Result)
           else begin
             result := _DoCommand;
             exit;
           end;
     end;
  end;

  if result = S_OK
     then UpdateUI; //or buttons might jump out briefly
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.CmdSet(cmdID: KS_Lib.CMDID): HResult;
begin
  //asm int 3 end; //trap
  result := DoCommand(cmdID, OLECMDEXECOPT_DODEFAULT);
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.CmdSet(cmdID: KS_Lib.CMDID; var pInVar: OleVariant): HResult;
begin
  //asm int 3 end; //trap
  result := DoCommand(cmdID, OLECMDEXECOPT_DODEFAULT, pInVar, POlevariant(Nil)^);
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.CmdSet_B(cmdID: KS_Lib.CMDID; pIn: Boolean): HResult;
var
  Ov: OleVariant;
begin
  //asm int 3 end; //trap
  Ov := pIn;
  result := DoCommand(cmdID, OLECMDEXECOPT_DODEFAULT, Ov, POlevariant(Nil)^);
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.CmdSet_S(cmdID: KS_Lib.CMDID; pIn: String): HResult;
var
  Ov: OleVariant;
begin
  //asm int 3 end; //trap
  Ov := pIn;
  result := DoCommand(cmdID, OLECMDEXECOPT_DODEFAULT, Ov, POlevariant(Nil)^);
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.CmdSet_I(cmdID: KS_Lib.CMDID; pIn: Integer): HResult;
var
  Ov: OleVariant;
begin
  //asm int 3 end; //trap
  Ov := pIn;
  result := DoCommand(cmdID, OLECMDEXECOPT_DODEFAULT, Ov, POlevariant(Nil)^);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.WaitForDocComplete: Boolean;
var
  I: Cardinal;
begin
  //asm int 3 end; //trap

  I := getTickCount + 20000;
  result := true;

  if TwebBrowser(Self).Document = nil   //avoid deadlock
     then exit;

  if FReadyState = READYSTATE_COMPLETE
     then begin
        if FDebug
           then beep;
        exit;
     end;

  While FReadyState <> READYSTATE_COMPLETE do //wait until DHTMLedit is ready
     begin
        if getTickCount > I
           then begin
              result := false;
              if FDebug
                 then KSMessageE('Dead lock break in WaitForDocComplete');

              break; //avoid dead lock - break loop after 20 sec.
           end
           else SafeYield;
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.EndCurrentDocDialog(var mr: Integer; CancelPosible: Boolean = False; SkipDirtyCheck: Boolean = False): HResult;
var
  Buttons: Integer;
  NotDirty: Boolean;
begin
  //asm int 3 end; //trap

  result := S_OK;

  if SkipDirtyCheck
     then begin
        NotDirty := true;
        //avoid complains from MSHTML when loading new file - if DOC is dirty
        cmdSet_B(IDM_SETDIRTY, false);
     end
     else NotDirty := not GetDirty;


  if NotDirty  //current file is clean
     then begin  //just delete backup
        if Length(FCurBackFile) > 0
           then DeleteFile(FCurBackFile); //works only for users with delete right
                                          //other users leave the bak-file behind
        mr := -1;
     end
     else begin        //current file is dirty
        if CancelPosible
           then Buttons := MB_YESNOCANCEL
           else Buttons := MB_YESNO;

        mr := KSQuestion('Document changed.'+DblCrLf+
                         'Save changes ?', '', MB_ICONQUESTION or Buttons);

        if mr = IDCANCEL    //skip the ending document process
           then Result := S_False

        else if mr = IDNO   //skip saving
           then begin         //Don't save - just restore old file from backup
              if DocIsPersist //if file created then get backup
                 then begin
                    if Assigned(FBeforeCloseFile)
                       then FBeforeCloseFile(Self, FCurrentDocumentPath);

                    if GetBackup //restore original file from backup
                       then begin
                          DeleteFile(FCurBackFile);
                          FCurBackFile := '';
                       end;
                 end;

              //avoid complains from MSHTML when loading new file - if DOC is dirty
              cmdSet_B(IDM_SETDIRTY, false)
           end;
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.EndCurrentDoc(CancelPosible: Boolean = False; SkipDirtyCheck: Boolean = False): HResult;
var
  mr: Integer;
begin
  //asm int 3 end; //trap

  Result := EndCurrentDocDialog(mr, CancelPosible, SkipDirtyCheck);
  if mr = IDYES
     then begin
        result := SaveFile;

        if Assigned(FBeforeCloseFile)
           then FBeforeCloseFile(Self, FCurrentDocumentPath);
     end;
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.GetBackup: Boolean;
begin
  //asm int 3 end; //trap
  //restore backup copy to current file (skip any changes)

  if DocIsPersist and (length(FCurBackFile) > 0)
     then result := FileCopy(FCurBackFile, FCurrentDocumentPath)
     else result := True;
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.CreateBackUp: Boolean;
begin
  //asm int 3 end; //trap
  if FCreateBakUp
     then begin
        FCurBackFile := ChangeFileExt(FCurrentDocumentPath, '.bak');
        result := FileCopy(FCurrentDocumentPath, FCurBackFile);
        if not result
           then FCurBackFile := '';
     end
     else result := false;;
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.GetCharset: string;
begin
  //asm int 3 end; //trap

  {$IFDEF EDLIB}
     result := _GetCharset;
  {$ELSE}
     result := 'windows-1252'; //resort to default value
  {$ENDIF}
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.EmptyDoc: String;
var
  BodyContetn: string;
begin
  //asm int 3 end; //trap

  if Get_UseDivOnCarriageReturn
     then BodyContetn := '<DIV>&nbsp;</DIV>'
     else BodyContetn := '<P>&nbsp;</P>';

  result := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'+CrLf+
            '<HTML><HEAD><TITLE>No Title</TITLE>'+
            '<META http-equiv=Content-Type content="text/html; charset='+ GetCharset +'">'+
            '<META content="'+ GetGenerator +'" name=GENERATOR>'+
            '</HEAD>' +
            '<BODY>'+ BodyContetn +'</BODY></HTML>';
end;
//-----------------------------------------------------------------------------
function TEmbeddedED.NewDocument: HResult;
begin
  //asm int 3 end; //trap

  if TwebBrowser(Self).Document = nil
     then AssignDocument
     else begin
        if EndCurrentDoc(CancelPosible, FSkipDirtyCheck) <> S_OK
           then begin
              Result := S_False;
              exit;
           end;
     end;

  Result := LoadFromString(EmptyDoc);

  GetSourceSnapShot;

  FBaseURL := ''; //set to empty string just like DHTMLEdit
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetShowDetails(vIn: Boolean);
begin
  //asm int 3 end; //trap
  FShowDetails := vIn;

  {$IFDEF EDGLYPHS}
     _SetShowDetails(FShowDetails, Self);
  {$ELSE}
     if DocumentIsAssigned
        then begin
           if ShowDetails
              then CmdSet(IDM_SHOWALLTAGS)
              else CmdSet(IDM_EMPTYGLYPHTABLE);
        end;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetDocTitle: string;
begin
  //asm int 3 end; //trap
  if TwebBrowser(Self).Document <> nil
     then result := DOC.Title
     else result := '';
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetDocTitle(NewTitle: String);
begin
  { MSHTML always creates an implicit empty title element, so you can
    safely assign a text to it }
  //asm int 3 end; //trap
  if TwebBrowser(Self).Document <> nil
     then DOC.Set_title(NewTitle);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetDOC: IHTMLDocument2;
begin
  //asm int 3 end; //trap
  if TwebBrowser(Self).Document = nil
     then result := nil
     else result := TwebBrowser(Self).Document as IHTMLDocument2;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.DocumentIsAssigned: Boolean;
begin
  //asm int 3 end; //trap
  result := TwebBrowser(Self).Document <> nil;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetInPlaceActiveObject: IOleInPlaceActiveObject;
var
  aHandle: Windows.Hwnd;
begin
  //asm int 3 end; //trap
  { this function is called from initializeEditor, so FmsHTMLwinHandle is assured
    to be available at the time we got an document to operate on }

  if FOleInPlaceActiveObject <> nil
     then begin
        result := FOleInPlaceActiveObject;
        exit;
     end;

  if ControlInterface <> nil
     then OleCheck(ControlInterface.QueryInterface(IOleInPlaceActiveObject, FOleInPlaceActiveObject))
     else begin
        result := nil;
        exit;
     end;

  //first get the "Shell Embedding" window
  OleCheck(FOleInPlaceActiveObject.GetWindow(FMainWinHandle));

  //then get the "Shell DocObject View" window
  aHandle := FindWindowEx(FMainWinHandle, 0, 'Shell DocObject View', nil);

  //now get the mshtml components main window
  FmsHTMLwinHandle := FindWindowEx(aHandle, 0, 'Internet Explorer_Server', nil);

  result := FOleInPlaceActiveObject;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetCmdTarget: IOleCommandTarget;
begin
  //asm int 3 end; //trap
  if TwebBrowser(Self).Document = nil
     then result := nil
     else result := TwebBrowser(Self).Document as IOleCommandTarget;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetPersistStream: IPersistStreamInit;
begin
  //asm int 3 end; //trap

  { In a Microsoft Visual C++ WebBrowser host or similar application, when you
    call the QueryInterface method for the IPersistStreamInit interface on a
    FRAME in a FRAMESET, it returns E_NOINTERFACE. When you query for other
    standard persistence interfaces (IPersistStream, IPersistFile, IPersistMemory),
    you receive the same error.}

  if TwebBrowser(Self).Document = nil
     then result := nil
     else result := TwebBrowser(Self).Document as IPersistStreamInit;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetPersistFile: IPersistFile;
begin
  //asm int 3 end; //trap
  if TwebBrowser(Self).Document = nil
     then result := nil
     else result := TwebBrowser(Self).Document as IPersistFile;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.PrintDocument(var withUI: OleVariant);
begin
  //asm int 3 end; //trap
  if withUI
     then DoCommand(IDM_PRINT, OLECMDEXECOPT_PROMPTUSER)
     else DoCommand(IDM_PRINT, OLECMDEXECOPT_DONTPROMPTUSER);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.Refresh;
var
  Rect: TRect;
begin
  //asm int 3 end; //trap
  //DoCommand(IDM_REFRESH); //this reloads the document

 {DHTML Edit docs says:
  This method redraws the current document, including the latest changes.
  You can use this method to redisplay a document if a series of edits have left
  the document in a state that is hard to read.

  If you are hosting a DHTML Editing control on a Web page, and if the control is
  hidden, you can also use this method to load a document into a DHTML Editing control.
  By default, the window object's onload event does not load documents into hidden
  controls.

  The Refresh method does not reread information from a file. If the current document
  references an external file, such as an applet or an image, and that file has changed,
  the change is not displayed by the Refresh method. To see changes in external files,
  use the LoadURL or LoadDocument method.

  The Refresh method sets the isDirty property to False. - the later seems not
  to be true ! }

  { NB the undo stack isn't cleared so DHTML Editing doesn't reload the document
    in any way }              

    
  //this is a guess
  Rect := BoundsRect;
  InvalidateRect(FmsHTMLwinHandle, @Rect, true);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Get_Busy: Boolean;
begin
  //asm int 3 end; //trap
  result := TWebBrowser(self).busy;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.CmdGet(cmdID: KS_Lib.CMDID): OleVariant;
begin
  //asm int 3 end; //trap
  if S_OK <> DoCommand(cmdID, OLECMDEXECOPT_DODEFAULT, POlevariant(Nil)^, Result)
     then Result := false;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.CmdGet(cmdID: KS_Lib.CMDID; pInVar: OleVariant): OleVariant;
begin
  //asm int 3 end; //trap
  if S_OK <> DoCommand(cmdID, OLECMDEXECOPT_DODEFAULT, pInVar, Result)
     then Result := false;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetBuildInStyles: String;
begin
  //asm int 3 end; //trap

  { because we need this list each time we load a new document we store it
    in FInternalStyles }
  if Length(FInternalStyles) = 0
     then _GetBuildInStyles;

  result := FInternalStyles;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED._GetBuildInStyles;
var
  ov: OleVariant;
  I: Integer;
  StrCount: Integer;
  Ps: PSafeArray;
  Warr: array of WideString;
begin
  //asm int 3 end; //trap

  FStyles.Clear;

  TVariantArg(ov).VT := VT_ARRAY;
  FInternalStyles := '';

  if (QueryStatus(IDM_GETBLOCKFMTS) and OLECMDF_ENABLED) = 0
     then begin
        TVariantArg(Ov).VT := VT_EMPTY; //D6 throws an error if we don't do this ?
        exit;
     end;

  Ov := CmdGet(IDM_GETBLOCKFMTS);

  { now we can get the returned strings either via API-calls or by
    direct handling of the SafeArray pointed to by VarRange.

    API-calls are a bit slower but easy - the backside is that
    SafeArrays stay a mystery to you

    Direct handling involves much coding but executes faster

    In both cases Delphi destroys the SafeArray fore you when it
    get out of scope. }

  //this is the direct handling of the SafeArray
  //************************************************

     //get a pointer to the SafeArray
  Ps := TVariantArg(ov).pArray;
  if Ps = nil
     then exit;

     //Get number of strings in the SafeArray
  StrCount := TSAFEARRAYBOUND(Ps.rgsabound).cElements;
      //make room fore all the strings in our WideString array
  SetLength(Warr, StrCount);
  try
        //lock the SafeArray = no risk of memory reallocation during copy
     Inc(Ps.cLocks);
        //copy OleStrings to WideString array
        //Ps.pvData points to start of the SafeArrays Data-segment
        //Ps.cbElements = size of each record = a PWideChar
     CopyMemory (@Warr[0], Ps.pvData, StrCount * 4 {Ps.cbElements});
     //result := StrCount > 0;
  finally
     Dec(Ps.cLocks); //unlock the SafeArray
  end;

  for I := 0 to StrCount -1 do
     FStyles.Add(Warr[I]); //get each string from the WideString array

  FInternalStyles := FStyles.Text;

  TVariantArg(Ov).VT := VT_EMPTY; //D6 throws an error if we don't do this ?


  {
  //this is the the API way of doing the same task as above
  //************************************************
     //get a pointer to the SafeArray
  Ps := TVariantArg(ov).pArray;
  sCommands := '';
  for I := VarArrayLowBound(ov, 1) to VarArrayHighBound(ov, 1) do
     begin
           //get each string from the SafeArray
        SafeArrayGetElement(Ps, I, Pw);
        aList.Add(Pw);
     end;
  }
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetStyles: String;
begin
  //asm int 3 end; //trap
  result := '';

  if FStylesRefreshed
     then result := FStyles.Text
     else begin
        FStylesRefreshed := true;

        if Length(FInternalStyles) = 0
           then _GetBuildInStyles;

        {$IFDEF EDLIB}
           MergeExterNalStyles(Self, FInternalStyles);
        {$ELSE}
           FStyles.Text := FInternalStyles;
        {$ENDIF}
     end;

  result := FStyles.Text;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetExternalStyles: String;
begin
  //asm int 3 end; //trap

  {$IFDEF EDLIB}
     if Length(FExternalStyles) = 0
        then _GetExternalStyles(Self);
  {$ENDIF}

  result := FExternalStyles;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.SetStyle(aStyleName: string): HResult;
var
  aElement: IHTMLElement;
  aStyle: String;
  aIndex: Integer;
  I: Integer;
  aTagName: String;
  SelStart, SelEnd: Integer;

  //--------------------------------------------
  procedure ClearAllTags;
  var
     aElement: IHTMLElement;
     TagText: String;
     aTag: string;
     S, S2: String;
     aDomNode: IHTMLDomNode;
     BreakLoop: Boolean;
     BreakTagInserted: Boolean;
   begin

     BreakTagInserted := False;
     aElement := GetFirstSelElement;
      DebugString := aElement.OuterHTML;

     while true do
        begin
           if not Assigned(aElement)
              then break;

//               aElement.ClassName := 'KS_DeleteMe'; // RHR
//kt              aElement._className := 'KS_DeleteMe'; // RHR
              aElement.className := 'KS_DeleteMe'; // kt
              aElement := GetNextSelElement;
        end;


     //now delete marked elements
     aElement := GetFirstSelElement;
     DebugString := aElement.OuterHTML;

     while true do
        begin
           if not Assigned(aElement)
              then break;

           // if aElement.ClassName = 'KS_DeleteMe'  RHR
           //kt if aElement._ClassName = 'KS_DeleteMe'
           if aElement.className = 'KS_DeleteMe'  //kt
              then begin
                 aDomNode := aElement as IHTMLDomNode;
                 aDomNode.removeNode(false); //false = do not remove child nodes
              end
              else break;  //end of element to delete reached

           aElement := GetNextSelElement;
        end;

          //now delete marked elements
     aElement := GetFirstSelElement;
     DebugString := aElement.OuterHTML;
  end;
  //--------------------------------------------
  procedure ClearClassStyles;
  var
     I: Integer;
  begin
     //loop trough all selected elements and remove known "tagName:className"
     aElement := GetFirstSelElement;
     DebugString := aElement.outerHTML;

     while assigned(aElement) do
        begin
           //kt if Length(aElement._className) > 0   // RHR
           if Length(aElement.className) > 0   // kt
              then begin
            //kt if FStyles.Find(aElement.tagName + '.' + aElement._className, I)  // RHR
                 if FStyles.Find(aElement.tagName + '.' + aElement.className, I)  // kt
                    then aElement.removeAttribute('className', 0);
              end;

           aElement := GetNextSelElement;
        end;
  end;
  //--------------------------------------------
begin
  //asm int 3 end; //trap
  result := S_false;

  if not FStyles.Find(aStyleName, aIndex)
     then exit;        //unknown style

  { As we added our style sheet-classes to FStyles we marked the
    FStyles's objet with 1 >> FStyles.AddObject(S, TObject(1))
    Now we can distinguish between build in styles and external styles. }

  if FStyles.Objects[aIndex] = nil //this is an internal style
     then begin
        if (QueryStatus(IDM_BLOCKFMT) and OLECMDF_ENABLED) = 0
           then exit;

        BeginUndoUnit('Set internal Style');
        try
           //First remove any class style as MSHTML doesn't do that
           ClearClassStyles;
           //let MSHTML handle build in styles
           result := CmdSet_S(IDM_BLOCKFMT, aStyleName);

           { Style = Normal has different effect depending on the settings of
             UseDivOnCarriageReturn. If set the selected text will be "packed"
             into DIV tags, and if not set it will be P tags that encapsulates
             the selection }
        finally
           EndUndoBlock(result);
        end;

        exit;
     end;


  //handle our style-sheet classes
  I := pos('.', aStyleName);
  if I > 0
     then begin
        aTagName := copy(aStyleName, 1, I -1);
        aStyle := copy(aStyleName, I+1, Length(aStyleName));

        { loop trough all selected elements with aTagName
          and set className := aStyle }

        aElement := GetFirstSelElement;//(aTagName);

        if assigned(aElement)
           then begin
              BeginUndoUnit('Set external Style');
              try
                 while assigned(aElement) do
                    begin
                       {$IFDEF EDLIB}
                          //substitute old tag with new tag
                          ChangeTag(DOC, aElement, aTagName);
                       {$ENDIF}
                       
                       //kt aElement._className := aStyle;    // RHR
                       aElement.className := aStyle;    // kt
                       aElement := GetNextSelElement(aTagName);
                    end;

                 result := S_OK;
              finally
                 EndUndoBlock(result);
              end;
           end;
     end
     else begin
        //this must be an error
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.QueryEnabled(cmdID: KS_Lib.CMDID): Boolean;
begin
  //asm int 3 end; //trap
  Result := (QueryStatus(cmdID) and OLECMDF_ENABLED)  = OLECMDF_ENABLED;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.QueryLatched(cmdID: KS_Lib.CMDID): Boolean;
var
  dwStatus : OLECMDF;
begin
  //asm int 3 end; //trap
  dwStatus := QueryStatus(cmdID);
  
  Result := (dwStatus and OLECMDF_LATCHED)  = OLECMDF_LATCHED;
end;
//------------------------------------------------------------------------------
function TEmbeddedED._CurFileName: string;
begin
  //asm int 3 end; //trap
  result := FCurrentDocumentPath;
  if Length(result) > 0
     then Delete(result, 1, LastDelimiter('\/', result)); //drop path
end;
//------------------------------------------------------------------------------
function TEmbeddedED._CurDir: string;
begin
  //asm int 3 end; //trap
  result := FCurrentDocumentPath;
  if (Length(result) > 0) and
     (S_OK = IsFilePath(result, result))
     then Delete(result, LastDelimiter('\/', result)+1, length(result)); //drop file
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetOleobject: IOleobject;
begin
  //asm int 3 end; //trap
  {$IFDEF VER120} result := TwebBrowser(Self).Application_ as IOleobject; // Delphi 4.0
  {$ELSE}         result := TwebBrowser(Self).Application as IOleobject;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetFocusToDoc;
begin
  //asm int 3 end; //trap
  if TwebBrowser(Self).Document <> nil
     then GetOleobject.DoVerb(OLEIVERB_UIACTIVATE, nil, self as IOleClientSite, 0, Handle, GetClientRect);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetBaseURL(const Value: String);
  //---------------------------------------
  function ValidFilePath(aPath: string): Boolean;
  var
     I: Integer;
  begin
     I := LastDelimiter('.\:', aPath);

     result := (I > 0) and       //we have a path
               ((aPath[I] = '\') or //it ends with backslash
                (aPath[I] = '.')); //we found a trailing file name
  end;
  //---------------------------------------
begin
  //asm int 3 end; //trap

  if ComponentInDesignMode
     then begin
        FBaseURL := '';
        exit;
     end;

  {$IFDEF EDMONIKER}
     {Setting BASEURL in the middle of an edit session has the side effect that the
      MSHTML UNDO stack is cleared.

      DHTMLEdit behaves even worse. The document is reloaded from disk causing all
      non saved changes to be lost without any warning }

     if AnsiSameText(FBaseURL, Value)//don't waist time setting the same BASEUrl
        then exit;

     if FBaseTagInDoc
        then exit;     { a base tag in the document will override a BASEUrl
                         so don't waist time trying }

     //check for trailing backslash in a file path
     if (pos('\', Value) > 0) and      //this is a file path
        (Not ValidFilePath(Value))
        then KsMessageI('SetBaseURL: Bad value')
        else begin
           FBaseURL := Value;
           FSettingBaseURL := true;
           SetBase_Url(Self);
        end;
 {$ELSE}
     NotImplemented('SetBaseURL');
 {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetBaseURL: String;
begin
  //asm int 3 end; //trap
  if ComponentInDesignMode
     then result := '' //always blank in design mode
     else result := FBaseURL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetBaseElement(var aBaseElement: IHTMLBaseElement): boolean;
var
  aCollection: IHTMLElementCollection;
begin
  //asm int 3 end; //trap
  aCollection := (DOC as IHTMLDocument3).getElementsByTagName('BASE') as IHTMLElementCollection;
  if aCollection.length < 1
     then result := false
     else begin
        aBaseElement := aCollection.item(0, 0) as IHTMLBaseElement;
        result := true;
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetActualAppName: string;
begin
  //asm int 3 end; //trap    - not used
  Result := TheActualAppName;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetActualAppName(const Value: string);
begin
  //asm int 3 end; //trap
  TheActualAppName := Value;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetBrowseMode(const Value: WordBool);
begin
  //asm int 3 end; //trap
  FEditMode := not Value;

  if TwebBrowser(Self).Document <> nil
     then begin
        if FEditMode
           then DOC.designMode := 'On'
           else DOC.designMode := 'Off';
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetBrowseMode: WordBool;
begin
  //asm int 3 end; //trap
  result := not FEditMode;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.GetElementUnderCaret;
var
  aSel: IHTMLSelectionObject;
  aDispatch: IDispatch;

  //------------------------------
  procedure GetSelection;
  begin
     aSel := Doc.selection;
     if assigned(aSel)
        then
           try  //????? 
              aDispatch := aSel.createRange;
           Except
           end;

     if assigned(aDispatch)
        then begin
           if supports(aSel.createRange, IHTMLTxtRange, FActualTxtRange)
              then begin
                 FActualElement := FActualTxtRange.ParentElement;
                 FActualRangeIsText := True;
              end;
        end
        else begin
           //last chance to ensure a valid TextRange
           try
              FActualTxtRange := (DOC.body as IHTMLBodyElement).createTextRange;
              FActualTxtRange.Collapse(true);  //move to start of aTxtRange / document
           except;
              FActualTxtRange := nil;
            end;
        end;
  end;
  //------------------------------
begin
  //asm int 3 end; //trap
  FLength := -1;
  FFirstElement := 0;
  FLastElement := 0;

  if (FReadyState <> READYSTATE_COMPLETE)
     then exit;

  FActualControlRange := nil;
  FActualTxtRange := nil;

  aSel := DOC.Selection;

  FSelectionType := aSel.type_;

  if SameText(FSelectionType, 'None')
     then begin
        GetSelection;
        FSelection := false;
     end

  else if SameText(FSelectionType, 'Text')
     then begin
        GetSelection;
        FSelection := true;
     end

  else if SameText(FSelectionType, 'Control')
     then begin
        FSelection := true;
        FActualElement := nil;

        if assigned(aSel)
           then begin
              if supports(aSel.createRange, IHTMLControlRange, FActualControlRange)
                 then begin
                    FActualElement := FActualControlRange.commonParentElement;
                    FActualRangeIsText := False;
                    FActualTxtRange := (DOC.body as IHTMLBodyElement).createTextRange;

                    OleCheck(FMarkupPointerStart.MoveAdjacentToElement(FActualElement, ELEM_ADJ_BeforeBegin));
                    OleCheck(FMarkupPointerEnd.MoveAdjacentToElement(FActualElement, ELEM_ADJ_AfterEnd));

                    //move rang in place
                    OleCheck(FMarkUpServices.MoveRangeToPointers(FMarkupPointerStart, FMarkupPointerEnd, FActualTxtRange));

                    //FActualTxtRange.MoveToElementText(FActualElement);
                 end;
           end
           else GetSelection;
      end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetActualElement: IHTMLElement;
begin
  //asm int 3 end; //trap
  if (not assigned(FActualElement)) or
     (FActualElement.OuterHTML = '')  // or we might get into troubles after
     then GetElementUnderCaret;    // deletion of a element

  result := FActualElement;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetActualTxtRange: IHTMLTxtRange;
begin
  //asm int 3 end; //trap
  if not assigned(FActualTxtRange) // or we might get into troubles after
     then GetElementUnderCaret;    // deletion of a element

  result := FActualTxtRange;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetActualControlRange: IHTMLControlRange;
begin
  //asm int 3 end; //trap
  result := FActualControlRange;
end;
//------------------------------------------------------------------------------
Procedure TEmbeddedED.GetSelStartElement;
var
  aTxtRange: IHTMLTxtRange;
begin
  //asm int 3 end; //trap
  aTxtRange := FActualTxtRange.duplicate;
  aTxtRange.Collapse(True); //start of selection
  FStartElementSourceIndex := aTxtRange.ParentElement.SourceIndex;
end;
//------------------------------------------------------------------------------
Procedure TEmbeddedED.GetSelEndElement;
var
  aTxtRange: IHTMLTxtRange;
begin
  //asm int 3 end; //trap
  aTxtRange := FActualTxtRange.duplicate;
  aTxtRange.Collapse(False); //end of selection
  FEndElementSourceIndex := aTxtRange.ParentElement.SourceIndex;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetElementNr(ElementNumber: Integer): IHTMLElement;
var
  aItem: Integer;
begin
  //asm int 3 end; //trap
  aItem := FFirstElement + ElementNumber;
  Result := FElementCollection.item(aItem, null) as IHTMLElement;
  DebugString := Result.OuterHTML;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetSelLength: Integer;
var
  aElement: IHTMLElement;
  PrevElement: IHTMLElement;
  I: Integer;
begin
  //asm int 3 end; //trap
  if FLength < 0 //not yet initialised
     then begin
        GetSelStartElement; //get element at start selection
        GetSelEndElement;   //get element at end selection

        FElementCollection := FActualElement.all as IHTMLElementCollection;
        FLength := FElementCollection.length;

        if FLength <  FEndElementSourceIndex - FStartElementSourceIndex
           {sometimes i.e. if all cells in a table is selected only the last
            element is returned in the ElementCollection :-(
            But luckily FStartElementSourceIndex and FEndElementSourceIndex
            is correctly computed }
           then begin
              FElementCollection := DOC.all as IHTMLElementCollection;
              FLength := FElementCollection.length;
           end;

        if FLength = 0 //only one element selected
           then begin
              FFirstElement := 0;//FStartElementSourceIndex;
              FLastElement := 0;//FStartElementSourceIndex;
              Result := FLength;
              exit;
           end;

        { the collection may contain more elements than selected.
          return only elements that are inside the selection }

        //Find first element inside selection
        for I := 0 to FLength -1 do
           begin
              aElement := FElementCollection.item(i, null) as IHTMLElement;
              { the first element sometimes have an sourceindex of one higher
                than  FStartElementSourceIndex ? so break on <= }
              if FStartElementSourceIndex <= aElement.SourceIndex
                 then begin
                    FFirstElement := I;  //first element inside selection
                    break;
                 end;
              PrevElement := aElement;
           end;

        //certain elements must be kept together
        if (FFirstElement > 0) and  (not KeepLI) and
           SameText(PrevElement.tagName, 'LI')
           then Dec(FFirstElement);



        //Find last element inside selection
        for I := FLength -1 downto 0 do
           begin
              aElement := FElementCollection.item(i, null) as IHTMLElement;
              if FEndElementSourceIndex = aElement.SourceIndex
                 then begin
                    FLastElement := I;  //last element inside selection
                    break;
                 end;
           end;

        if FLastElement = FFirstElement
           then FLength := 0 //there is 1 element in the collection
           else FLength := FLastElement - FFirstElement;// +1;

     end;

  Result := FLength;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.GetSelParentElement;
begin
  //asm int 3 end; //trap
  FActualElement := FActualElement.ParentElement;
  FActualTxtRange.MoveToElementText(FActualElement);
  FActualTxtRange.Select;
  FLength := -1;
end;
//------------------------------------------------------------------------------
function TEmbeddedED._GetNextItem(const aTag: String = ''): IHTMLElement;
var
  aElement: IHTMLElement;

  //-----------------------
  Function LastElementsParents: boolean;
  begin
     LastElementsParents := False;
     //we might find the searched element higher up the chain

     while not SameText(aElement.tagName, cBODY) do
        begin
           aElement := aElement.parentElement;
           if SameText(aElement.tagName, aTag)
              then begin  //we  found it :-)
                 _GetNextItem := aElement;
                 LastElementsParents := true;
                 break;
              end;
        end;
  end;
  //-----------------------
begin
  //asm int 3 end; //trap
  if sameText('LI', aTag)
     then KeepLI := True
     else KeepLI := false;

  {FLength = -1 means the GetLength function isn't initialised yet}
  if (FLength > -1) and (FTagNumber >{=} FLength)  //no more tags in collection
     then begin
        Result := Nil;
        exit;
     end;

  if GetSelLength = 0  //if GetLength isn't initialised yet it happens now
     then begin
        //only one element is selected
        if (System.length(aTag) = 0) or
            AnsiSameText(aTag, FActualElement.tagName)
           then Result := FActualElement
           else begin
              Result := Nil;
              aElement := FActualElement;
              LastElementsParents;
           end;
        inc(FTagNumber);
        exit;
     end;

  //get next element from collection
  Result := GetElementNr(FTagNumber);
  inc(FTagNumber);

  if (System.Length(aTag) = 0) or          //no filter
     (AnsiSameText(aTag, Result.tagName))  //tag is filtered - but match tag name
     then exit;


  //the first tag might not fully contain the searched tag

  if FTagNumber = 1 //it is the first tag [ 0 incremented ]
     then begin
        aElement := Result;
        if LastElementsParents
           then exit;
     end;


  //loop tag collection looking fore a matching tag
  while true do
     begin
        if FTagNumber > FLength  //no more tags in collection
           then begin
              Result := Nil;
              Break;
           end;

        //get next element from collection
        Result := GetElementNr(FTagNumber);
        inc(FTagNumber);

        if Assigned(Result) and AnsiSameText(aTag, Result.tagName)
           then Break;
     end;
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.GetFirstSelElement(const aTag: String = ''): IHTMLElement;
begin
  //asm int 3 end; //trap
  FTagNumber := 0;
  FLength := - 1;
  Result := _GetNextItem(aTag);
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.GetNextSelElement(const aTag: String = ''): IHTMLElement;
begin
  //asm int 3 end; //trap
  Result := _GetNextItem(aTag);
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.GetSelText: String;
begin
  //asm int 3 end; //trap
  if FActualRangeIsText
     Then Result := Trim(FActualTxtRange.Text)
     else result := '';
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.IsSelType(aType: string): boolean;
begin
  //asm int 3 end; //trap
  result := SameText(aType, FSelectionType);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.KeepSelectionVisible;
begin
  //asm int 3 end; //trap
 { after pasting text into a textrang the screen selection is cleared. }

  FMarkUpServices.MoveRangeToPointers(FMarkupPointerStart, FMarkupPointerEnd, FActualTxtRange);
  SelectActualTextrange;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetSelParentElementType(const aType: string; aMessage: string = ''): IHTMLElement;
begin
  //asm int 3 end; //trap

  //go up to the aType-tag
  GetParentElemetType(FActualElement, aType, Result);

  if SameText(Result.tagName, cBODY) and (not SameText(cBODY, aType))
     then begin
        result := Nil;
        if System.length(aMessage) > 0
           then KSMessageI(aMessage);
     end;
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.IsSelElementID(const ID: String): Boolean;
begin
  //asm int 3 end; //trap
  Result := assigned(FActualElement) and AnsiSameText(FActualElement.ID, ID)
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.IsSelElementClassName(const ClassName: String): Boolean;
begin
  //asm int 3 end; //trap
  //kt Result := AnsiSameText(FActualElement._ClassName, ClassName)   // RHR
  Result := AnsiSameText(FActualElement.className, ClassName)   // kt
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.IsSelElementTagName(const TagName: String): Boolean;
begin
  //asm int 3 end; //trap
  Result := AnsiSameText(FActualElement.TagName, TagName)
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.IsSelElementInVisible: Boolean;
begin
  //.asm int 3 end; //trap
  result := SameText(FActualElement.Style.display, 'none')
end;
//------------------------------------------------------------------------------
function TEmbeddedED.IsSelElementAbsolute: boolean;
begin
  //.asm int 3 end; //trap    - not used
  result := SameText(FActualElement.Style.Position, 'absolute')
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.MakeSelElementVisible(Show: boolean);
begin
  //asm int 3 end; //trap
  if Show
     then FActualElement.Style.display := ''
     else FActualElement.Style.display := 'none';
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.TrimSelection;
//remove any leading / trailing spaces from the selection.
var
  S: String;
begin
  //asm int 3 end; //trap
  //beware Selection can contain selected elements ie. end wit an IMG tag

  S := FActualTxtRange.htmlText;

  //selection of spaces normaly only ocoures trailing, but just in case
  while (System.length(S) > 0) and (S[1] = #32) do
     begin
        FActualTxtRange.MoveStart('character', 1);
        Delete(S, 1, 1);
     end;

  while (System.length(S) > 0) and (S[System.Length(S)] = #32) do
     begin
        FActualTxtRange.MoveEnd('character', -1);
        Delete(S, System.Length(S), 1);
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SelectActualTextrange;
begin
  //asm int 3 end; //trap
  FActualTxtRange.Select;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SelectElement(aElement: IhtmlElement);
begin
  //asm int 3 end; //trap

  if not assigned(aElement)
     then exit;

  FActualElement := aElement;

  FActualRangeIsText := False;
  if not assigned(FActualTxtRange)
     then FActualTxtRange := (DOC.body as IHTMLBodyElement).createTextRange;
  FActualTxtRange.MoveToElementText(FActualElement);

  FActualTxtRange.Select;

  if length(FActualElement.InnerHTML) = 0
     then begin
        if SetCursorAtElement(aElement, ELEM_ADJ_BeforeBegin)
           then ShowCursor(true);
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.SetCursorAtElement(aElement: IhtmlElement; ADJACENCY:_ELEMENT_ADJACENCY): Boolean;
begin
  //asm int 3 end; //trap

  result := false;
  if not assigned(aElement)
     then exit;

  if S_OK = FMarkupPointerStart.MoveAdjacentToElement(aElement, ADJACENCY)
     then begin
        FDisplayPointerStart.SetDisplayGravity(DISPLAY_GRAVITY_NextLine);
        if S_OK = FDisplayPointerStart.MoveToMarkupPointer(FMarkupPointerStart, nil)
           then result := S_OK = FCaret.MoveCaretToPointer(FDisplayPointerStart, 0, CARET_DIRECTION_SAME);
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.CollapseActualTextrange(Start: boolean);
begin
  //.asm int 3 end; //trap    - not used
  FActualTxtRange.Collapse(Start);
end;
//------------------------------------------------------------------------------
function TEmbeddedED._LoadFile(aFileName: String): HResult;
var
  OldFilePath: String;
begin
  //asm int 3 end; //trap
  if TwebBrowser(Self).Document <> nil
     then begin
        FReadyState := 0;
        OldFilePath := FCurrentDocumentPath;
        FCurrentDocumentPath := aFileName;

        Result := PersistFile.Load(StringToOleStr(aFileName),
                                          STGM_READWRITE or STGM_SHARE_DENY_NONE);

        { PersistStream.Load causes a DocumentComplete event with the last known URL
          Typically this is about:blank }

        WaitForDocComplete;

        if result <> S_OK
           then FCurrentDocumentPath := OldFilePath;
     end
     else result := S_false;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.LoadFile(var aFileName: String): HResult;
begin
  //asm int 3 end; //trap
  result := LoadFile(aFileName, false);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.LoadFile(var aFileName: String; PromptUser: boolean): HResult;
var
  S: String;

  //---------------------------------------------
  function GetFileName(Var aFileName: String): Boolean;
  var
     aOpenDlg: TOpenDialog;
  begin
     aOpenDlg := TOpenDialog.Create(Nil);
     try
        aOpenDlg.Filter := aFilter;
        aOpenDlg.Filename := aFileName;
        aOpenDlg.Options := [ofEnableSizing, ofFileMustExist];

        if aOpenDlg.Execute
           then begin
              aFileName := aOpenDlg.FileName;
              Result := true;
           end
           else result := false;
     finally
        aOpenDlg.free;
     end;
  end;
  //----------------------------------------------
  function DoLocalFile: HResult;
  begin
     if (not PromptUser) and
        FileExists(aFileName)
        then result := _LoadFile(aFileName)
        else begin
           if GetFileName(aFileName)
              then Result := _LoadFile(aFileName)
              else result := S_false;
        end;
  end;
  //----------------------------------------------
begin
  //asm int 3 end; //trap

  result := EndCurrentDoc(CancelPosible, FSkipDirtyCheck);

  if result = S_OK
     then begin
        if pos('file://', LowerCase(aFileName)) = 1
           then begin
              //we have a file protocol path
              if IsFilePath(aFileName, S) = S_OK
                 then begin
                    aFileName := S;
                    if FileExists(aFileName)
                       then result := _LoadFile(aFileName)
                       else result := DoLocalFile;

                    if result = S_OK
                       then Delete(aFileName, LastDelimiter('\/', aFileName)+1, Length(aFileName));
                 end;
           end

        else if (pos('http://', LowerCase(aFileName)) = 1) or (pos('www.', LowerCase(aFileName)) = 1)
           then begin
              //we have a http protocol path
              Result := GO(aFileName);
           end

        else begin
           result := DoLocalFile;
           if result = S_OK
              then Delete(aFileName, LastDelimiter('\/', aFileName)+1, Length(aFileName));
        end;

        if result = S_OK
           then begin
              if Assigned(FAfterLoadFile)
                 then FAfterLoadFile(Self, FCurrentDocumentPath);
           end;
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.DocIsPersist: boolean;
var
  Pw: PWideChar;
begin
  //asm int 3 end; //trap
  if TwebBrowser(Self).Document <> nil
     then result := S_OK = PersistFile.GetCurFile(Pw)
     else result := false;
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.GetPersistedFile: String;
var
  Pw: PWideChar;
begin
  //asm int 3 end; //trap
  // just return the BaseURL if we have a htttp path or a local file path

  if TwebBrowser(Self).Document <> nil
     then begin
        if S_OK = PersistFile.GetCurFile(Pw) //this also tests for persisted file
           then begin
              result := Pw;

              if (length(result) > 0) and
                 (pos('file://', result) = 1) //we have a file protocol path
                 then begin
                    //.asm int 3 end; //trap
                    delete(result, 1, 7);
                 end;

              result := StringReplace(result, '/', '\', [rfReplaceAll]);
           end

        else begin       //the document is not a persisted file
           result := DOC.URL;

           //drop bookmark - just in case
           Delete(result, LastDelimiter('#', result), length(result));


           { this is a special case - normally only in case of a "preview browser where
             the document content is feed in via DocumentHTML - causing the documents
             file path to become about:blank
             If the real document pat is set via SetDocumentPath we can use that in stead
             of about:blank}
           If SameText(result, AboutBlank) //and (Length(FDocumentPath) > 0)
              then result := '';//FDocumentPath;
        end;
  end
  else result := '';


{ LocationName: the name of the resource currently displayed in the Web browser control.
  If the resource is an HTML page from the Web, LocationName is the title of that page.
  If the resource is a folder or file on the local network or on a disk,
  LocationName is the full UNC name of the folder or file.  }
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetSaveFileName(var aFile: string): HResult;
var
  aSaveDlg: TSaveDialog;
begin
  //asm int 3 end; //trap
  aSaveDlg := TSaveDialog.Create(Nil);
  try
     aSaveDlg.DefaultExt := 'htm';
     aSaveDlg.Filter := aFilter;
     aSaveDlg.InitialDir := ExtractFilePath(aFile);
     aSaveDlg.Filename := aFile;
     aSaveDlg.Options := [ofOverwritePrompt, ofPathMustExist, ofNoReadOnlyReturn, ofEnableSizing];

     if aSaveDlg.Execute
        then begin
           aFile := aSaveDlg.Filename;
           result := S_OK;
        end
        else begin
           aFile := '';
           result := S_false;
        end;
  finally
     aSaveDlg.free;
  end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.AfterFileSaved;
begin
  //asm int 3 end; //trap
  if Assigned(FAfterSaveFile)
     then FAfterSaveFile(Self);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.SaveFile: HResult;
begin
  //asm int 3 end; //trap
  result :=  DoSaveFile;

  if result = S_OK
     then AfterFileSaved;
end;
//------------------------------------------------------------------------------
function TEmbeddedED._DoSaveFile: HResult;
Const
  ClearDirtyFlag: boolean = true;
begin
  //asm int 3 end; //trap

  _CheckGenerator(False);

  if DocIsPersist  //DOC is file based
     then Result := PersistFile.Save(Nil, ClearDirtyFlag)
     else Result := PersistFile.Save(StringToOleStr(FCurrentDocumentPath), ClearDirtyFlag);

  if result = S_OK
     then FHTMLImage := KS_Lib.GetHTMLtext(DOC); //Get SnapShot of current HTML Source
end;
//------------------------------------------------------------------------------
function TEmbeddedED.DoSaveFile: HResult;
var
  IsPersist: Boolean;
begin
  //asm int 3 end; //trap

  IsPersist := DocIsPersist;  //DOC is file based

  if (not IsDirty) and IsPersist and (not (GetAsyncKeyState(VK_CONTROL) < 0))
     then begin
        result := S_OK; //no need to save a clean file
        exit;
     end;

  result := S_false;

  if (TwebBrowser(Self).Document = nil) or (not FEditMode)
     then exit;

  if Assigned(FBeforeSaveFile)
     then begin
        FBeforeSaveFile(Self);
        //WaitForDocComplete;  //just in case the document was changed
     end;

  if IsPersist or
     ((Length(FCurrentDocumentPath) > 0) and fileExists(FCurrentDocumentPath))
     then result := _DoSaveFile
     else result := SaveFileAs;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.SaveFileAs(aFile: string = ''): HResult;
begin
  //asm int 3 end; //trap
  result :=  DoSaveFileAs(aFile);

  if result = S_OK
     then AfterFileSaved;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.DoSaveFileAs(aFile: String): HResult;
Const
  ClearDirtyFlag: boolean = true;
var
  DoSave: boolean;
begin
  //asm int 3 end; //trap
  if (TwebBrowser(Self).Document = nil) or (not FEditMode)
     then begin
        result := S_false;
        exit;
     end;

  if length(aFile) > 0
     then begin
        { this wont work because the MSHTML dialog always shows up
          Ov := aFile;
          result := DoCommand(IDM_SAVEAS, OLECMDEXECOPT_DONTPROMPTUSER, Ov); }


        { this gives the user a Delphi save dialog  }
        If FileExists(aFile)
           then DoSave := IDYES = KSQuestion(aFile + ' already exists.' +CrLf+
                                             'Do you want to replace it?', '',
                                             MB_ICONWARNING or MB_YESNO)
           else begin
              ForceDirectories(ExtractFilePath(aFile));
              DoSave := true;
           end;

        if DoSave
           then begin
              _CheckGenerator(false);
              Result := PersistFile.Save(StringToOleStr(aFile), false);
           end
           else Result := E_ABORT;
     end
     else begin
        {this gives the user MSHTML's own save dialog }
        _CheckGenerator(false);
        result := CmdSet(IDM_SAVEAS);
     end;

  if result = S_OK //file was saved successfully
     then begin
        FCurrentDocumentPath := GetPersistedFile;
        { we need to re-parse the DOC from the new path
          this also get us a new FHTMLImage !

          FBASEUrl is set as a result to _LoadFile ! }

        result := _LoadFile(FCurrentDocumentPath);

        if FCurBackFile <> ChangeFileExt(FCurrentDocumentPath, '.bak')
        then begin
           Sysutils.DeleteFile(FCurBackFile);
           CreateBackUp;
        end;
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetLiveResize(const Value: Boolean);
var
  Ov: OleVariant;
begin
  //asm int 3 end; //trap
  FLiveResize := Value;
  if TwebBrowser(Self).Document <> nil
     then begin
        Ov := FLiveResize;
        CmdSet(IDM_LIVERESIZE, Ov);
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.Set2DPosition(const Value: Boolean);
var
  Ov: OleVariant;
begin
  //asm int 3 end; //trap
  F2DPosition := Value;
  if TwebBrowser(Self).Document <> nil
     then begin
        Ov := F2DPosition;
        CmdSet(IDM_2D_POSITION, Ov);
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetMSHTMLwinHandle: Hwnd;
begin
  //asm int 3 end; //trap
  //get the DHTMLedit component's main window handle
  
  if FOleInPlaceActiveObject = nil
     then GetInPlaceActiveObject;

  result := FmsHTMLwinHandle;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.ScrollDoc(Pos: Integer);
begin
  //asm int 3 end; //trap
  if (TwebBrowser(Self).Document <> nil) and (Pos > 0)
     then begin
         //messagedlg('Scrolling',mtinformation,[mbOK],0);
        (Doc.Body as IHTMLElement2).ScrollTop := Pos;
        FScrollTop := 0;
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetMouseElement(P: Tpoint; aWinHandle: Hwnd = 0);
begin
  //asm int 3 end; //trap
  if aWinHandle > 0
  { MouseClickOnElement is in screen coordinate,
       change it to DHTML window coordinate }
     then Windows.ScreenToClient(aWinHandle, P);

  FActualElement := DOC.elementFromPoint(P.x, P.y);

  FActualRangeIsText := False;
  if not assigned(FActualTxtRange)
     then FActualTxtRange := (DOC.body as IHTMLBodyElement).createTextRange;
  FActualTxtRange.MoveToElementText(FActualElement);
end;
//------------------------------------------------------------------------------
Function TEmbeddedED.RemoveElementID(const TagID: String): Boolean;
var
  MarkUp: IMarkupServices;
  aElement: IHTMLElement;
  I: Integer;
begin
  //asm int 3 end; //trap
  MarkUp := Doc as IMarkupServices;
  Result := False;

  for i := 0 to FLength - 1 do
     begin
        aElement := GetElementNr(i);

        if not assigned(aElement)
           then continue;

        if AnsiSameText(TagID, aElement.ID)
           then begin
              Markup.RemoveElement(aElement);
              Result := True;
           end;
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.ShowHighlight(pIRange: IHTMLTxtRange = nil);
var
  aTxtRange: IHTMLTxtRange;
begin
  //asm int 3 end; //trap

  if pIRange = nil
     then begin
        aTxtRange := (DOC.body as IHTMLBodyElement).createTextRange;
        aTxtRange.moveToElementText(FActualElement);
     end
     else aTxtRange := pIRange.duplicate;

  FMarkUpServices.MovePointersToRange(aTxtRange, FMarkupPointerStart, FMarkupPointerEnd);

  //kt FDisplayPointerStart.MoveToMarkupPointer(FMarkupPointerStart as MSHTML_TLB.IMarkupPointer, nil);
  FDisplayPointerStart.MoveToMarkupPointer(FMarkupPointerStart as MSHTML_EWB.IMarkupPointer, nil);  //kt
  //ktFDisplayPointerEnd.MoveToMarkupPointer(FMarkupPointerEnd as MSHTML_TLB.IMarkupPointer, nil);
  FDisplayPointerEnd.MoveToMarkupPointer(FMarkupPointerEnd as MSHTML_EWB.IMarkupPointer, nil); //kt

  if assigned(FHighlightSegment)
     then HideHighlight;

  FHighlight.AddSegment(FDisplayPointerStart, FDisplayPointerEnd, FRenderStyle, FHighlightSegment);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.HideHighlight;
begin
  //asm int 3 end; //trap
  if assigned(FHighlightSegment)
     then FHighlight.RemoveSegment(FHighlightSegment);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.MovePointersToRange(const aRange: IHTMLTxtRange): HResult;
begin
  //.asm int 3 end; //trap
  Result := FMarkUpServices.MovePointersToRange(aRange, FMarkupPointerStart, FMarkupPointerEnd);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.MovePointersToSel: HResult;
begin
  //.asm int 3 end; //trap
  Result := MovePointersToRange(FActualTxtRange);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.CreateElement(const tagID: _ELEMENT_TAG_ID; var NewElement: IHTMLElement; const aTxtRange: IHTMLTxtRange = nil; const Attributes: string = ''): HResult;
begin
  //asm int 3 end; //trap
  //attributes form:

  {$IFDEF EDLIB}
     if aTxtRange = nil
        then result := EDLIB.CreateElement(DOC, tagID, NewElement, FActualTxtRange, Attributes)
        else result := EDLIB.CreateElement(DOC, tagID, NewElement, aTxtRange, Attributes);
  {$ELSE}
     result := S_False;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.InsertElementAtCursor(var aElement: IHTMLElement; const aTxtRange: IHTMLTxtRange = nil): HResult;
begin
  //asm int 3 end; //trap
  { The returned IHTMLTxtRange contains the new tag - if its not a control ??}

  {$IFDEF EDLIB}
     Result := EDLIB.InsertElementAtCursor(DOC, aElement, aTxtRange);
  {$ELSE}
     result := S_False;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.CreateMetaTag(var aMetaElement: IHTMLMetaElement): HResult;
begin
  //asm int 3 end; //trap
  {$IFDEF EDLIB}
     Result := EDLIB.CreateMetaTag(DOC, aMetaElement);
  {$ELSE}
     result := S_False;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.MoveTextRangeToPointer(aTxtRange: IHTMLTxtRange = nil): IHTMLTxtRange;
begin
  //asm int 3 end; //trap
  if assigned(aTxtRange)
     then begin
        FMarkUpServices.MoveRangeToPointers(FMarkupPointerStart, FMarkupPointerEnd, aTxtRange);
        result := aTxtRange;
     end
     else begin
        FMarkUpServices.MoveRangeToPointers(FMarkupPointerStart, FMarkupPointerEnd, FActualTxtRange);
        result := FActualTxtRange;
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetDebug(value: Boolean);
begin
  //asm int 3 end; //trap
  FDebug := value;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetCurrentFontName: string;
var
  FontName: variant;
begin
  //asm int 3 end; //trap
  result := ''; // FontName not found

  if QueryEnabled(IDM_FONTNAME)
     then begin
        FontName := CmdGet(IDM_FONTNAME);
        if VarType(FontName) = varOleStr
           then result := FontName
           else; //multiple element selection
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetFontNameIndex(aList: String): Integer;
var
  FontName: variant;
  //I: Integer;
  list: TStringlist;
begin
  //asm int 3 end; //trap
  result := -1; // FontName not found

  if QueryEnabled(IDM_FONTNAME)
     then begin
        FontName := CmdGet(IDM_FONTNAME);
        if VarType(FontName) = varOleStr
           then begin
              list := TStringlist.Create;
              try
                 list.Text := aList;
                 result := List.IndexOf(FontName);
              finally
                 list.free;
              end;
           end
           else; //multiple element selection
     end;
end;
//------------------------------------------------------------------------------
function EnumFontsProc(var LogFont: TLogFont; var Metric: TTextMetric; FontType: Integer; Data: Pointer): Integer; stdcall;
var
  St: TStrings;
  aFaceName: string;
begin
  //asm int 3 end; //trap
  St := TStrings(Data);
  aFaceName := LogFont.lfFaceName;

  if (St.Count = 0) or
  (AnsiCompareText(St[St.Count-1], aFaceName) <> 0)
     then St.Add(aFaceName);

  Result := 1;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetFonts: String;
var
  DC: HDC;
  LFont: TLogFont;
begin
  //asm int 3 end; //trap

  if FFonts = nil
     then begin
        FFonts := TStringList.Create;
        DC := GetDC(GetMSHTMLwinHandle);
           try
              FFonts.Add('Default');
              FillChar(LFont, sizeof(LFont), 0);
              LFont.lfCharset := DEFAULT_CHARSET;
              //we send the resulting fontlist (FFonts) to EnumFontsProc as a param
              EnumFontFamiliesEx(DC, LFont, @EnumFontsProc, LongInt(FFonts), 0);
              TStringList(FFonts).Sorted := TRUE;
           finally
              ReleaseDC(0, DC);
           end;
     end;

  Result := FFonts.Text;

  //just a test
  if (Screen.Fonts.text <> result) and   //this seem newer to be true !
     FDebug
     then beep;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetFontSizeIndex(const aList: String; var Changed: String): Integer;
var
  vo: OleVariant;
  aCurStyle: IHTMLCurrentStyle;
  s: String;

  //------------------------------------------------
  function GetBaseSize: string;
  begin
     result := '1  (  8 pt)' +CrLf +
               '2  (10 pt)' +CrLf +
               '3  (12 pt)' +CrLf +
               '4  (14 pt)' +CrLf +
               '5  (18 pt)' +CrLf +
               '6  (24 pt)' +CrLf +
               '7  (36 pt)';
  end;
  //------------------------------------------------
begin
  //asm int 3 end; //trap

  result := -1; //no size found

  if Length(aList) = 0
     then Changed := GetBaseSize
     else Changed := '';

  if not QueryEnabled(IDM_FONTSIZE)
     then exit;


  Vo := CmdGet(IDM_FONTSIZE);   //this gets the standard size 1-7 in stead of
  if VarType(vo) = VarInteger   //x-small and the like
     then begin
        result := Vo-1;
        exit;
     end;

  if FActualElement = nil
     then exit;

  aCurStyle := (FActualElement as IHTMLElement2).Get_CurrentStyle;

  S := aCurStyle.Get_fontSize;
  if S <> ''
     then begin
        Changed := GetBaseSize +CrLf + S;
        result := 7;
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetStylesIndex: Integer;
var
  S: String;
begin
  //asm int 3 end; //trap

  if QueryEnabled(IDM_BLOCKFMT)
     then begin
        {$IFDEF EDLIB}
           S := getFontStyle(Self);
        {$ELSE}
           S := CmdGet(IDM_BLOCKFMT);
        {$ENDIF}

        if not FStyles.Find(S, result)
           then result := -1;
     end
     else result := -1;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetStylesIndex(aList: String): Integer;
//this is only to keep compatibility with OCX ver 1.0
var
  S: String;
  List: TStringList;
  //aElement: IhtmlElement;
begin
  //asm int 3 end; //trap
  //Available styles

  if QueryEnabled(IDM_BLOCKFMT)
     then begin
        {$IFDEF EDLIB}
           S := getFontStyle(Self);
        {$ELSE}
           S := CmdGet(IDM_BLOCKFMT);
        {$ENDIF}

        List := TStringList.Create;
        try
           List.Text := aList;
           result := List.IndexOf(S);
        finally
           List.free;
        end
     end
     else result := -1;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SyncDOC(HTML: string; SelStart, SelEnd: Integer);
var
  Generator: Boolean;
begin
  //asm int 3 end; //trap

  {$IFDEF EDPARSER}
     {$IFDEF EDLIB}
        Generator := true;
     {$ENDIF}

     //place the cursor at same pos in WYSIWY as in the string
     KSIEParser.SyncDOC(Self, HTML, SelStart, SelEnd, Generator);
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.SelectedDocumentHTML(var SelStart, SelEnd: Integer): String;
var
  Generator: Boolean;
begin
  //asm int 3 end; //trap
  
  {$IFDEF EDPARSER}
     {$IFDEF EDLIB}
        Generator := true;
     {$ENDIF}

     //place the cursor at same pos in WYSIWY as in the string
     Result := KSIEParser.SelectedDocumentHTML(Self, SelStart, SelEnd, Generator);
  {$ELSE}
      SelStart := -1;
      SelEnd := -1;
      Result := KS_Lib.GetHTMLtext(DOC);
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetSelStartEnd(Var SelStart, SelEnd: Integer): boolean;
begin
  //asm int 3 end; //trap
  result :=
     (S_OK = FMarkUpServices.MovePointersToRange(ActualTextRange, FMarkupPointerStart, FMarkupPointerEnd)) and
     //get selection in a reselectable form
     (S_OK = (FMarkupPointerStart as IMarkupPointer2).GetMarkupPosition(SelStart)) and
     (S_OK = (FMarkupPointerEnd as IMarkupPointer2).GetMarkupPosition(SelEnd));
end;
//------------------------------------------------------------------------------
function TEmbeddedED.SetSelStartEnd(SelStart, SelEnd: Integer): boolean;
var
  aMarkupContainer: IMarkupContainer;
begin
  //asm int 3 end; //trap

  if (SelStart > 0) and (SelEnd > 0)
     then begin
        //Restore selected TextRange
        aMarkupContainer := Doc as IMarkupContainer;
        if (S_OK = (FMarkupPointerStart as IMarkupPointer2).MoveToMarkupPosition(aMarkupContainer, SelStart)) and
           (S_OK = (FMarkupPointerEnd as IMarkupPointer2).MoveToMarkupPosition(aMarkupContainer, SelEnd)) and
           (S_OK = FMarkupServices.MoveRangeToPointers(FMarkupPointerStart, FMarkupPointerEnd, ActualTxtRange))
           then ActualTxtRange.select;
        result := true;
     end
     else result := false;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.ISEmptyParam(value: Olevariant): Boolean;
begin
  //asm int 3 end; //trap
  result := (TVarData(value).VType = varError) and
            (TVarData(value).VError = $80020004);
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetPrintFileName: String;
var
  aFileName: String;

  //---------------------------------------
  function ValidFileName(aPath: string): Boolean;
  var
     I: Integer;
  begin
     I := LastDelimiter('.\:', aPath);

     result := (I > 0) and       //we have a path
               ((aPath[I] = '\') or //it ends with backslash
                (aPath[I] = '.')); //we found a trailing file name
  end;
  //---------------------------------------
begin
  //asm int 3 end; //trap

  if length(CurFileName) > 0
     then result := CurFileName
     else begin
        if ValidFileName(FBaseUrl)
           then result := FBaseUrl
           else result := '';
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetLastError: string;
begin
  //asm int 3 end; //trap
  result := FLastError;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.OpenChangeLog: HResult;
begin
  //asm int 3 end; //trap
  {$IFDEF EDUNDO}
     result := UUndo.OpenChangeLog(self, FTUndo);
  {$ELSE}
     result := S_OK;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.WaitAsyncMessage(var Msg: Tmessage);
begin
  //asm int 3 end; //trap
  FWaitMessage := true;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.BeginUndoUnit(aTitle: String = 'Default'): HResult;
begin
  //asm int 3 end; //trap

  if FLocalUndo
     then begin
        {$IFDEF EDUNDO}
           if FTUndo <> nil
              then result := TUndo(FTUndo).BeginUndoUnit(aTitle)
              else result := S_False;
        {$ENDIF}
     end
     else begin
        {$IFDEF EDLIB}
           result := EDLIB.BeginUndoUnit(Self, aTitle);
        {$ELSE}
           result := S_False;
        {$ENDIF}
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.EndUndoUnit: HResult;
begin
  //asm int 3 end; //trap

  if FLocalUndo
     then begin
        if FTUndo <> nil
           then begin
              {$IFDEF EDUNDO}
                 TUndo(FTUndo).EndUndoBlock;
                 result := S_OK;
              {$ENDIF}
           end
           else result := S_False;
     end
     else begin
        {$IFDEF EDLIB}
           result := EDLIB.EndUndoUnit(Self);
        {$ELSE}
           result := S_False;
        {$ENDIF}
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.LoadURL(url: String);
var
  aFileName: String;
begin
  // just DHTML Compatibility
  //asm int 3 end; //trap

  aFileName := url;
  if Length(aFileName) = 0
     then begin
        if length(ActualAppName) = 0 //only set default one time
           then ActualAppName := LowerCase(ExtractFileName(GetModuleName));

        aFileName := KSInputQuery(ActualAppName, 'URL:', 'http://', 40);
        if (length(aFileName) = 0) or (aFileName = 'http://')
           then exit;
     end;

  LoadFile(aFileName, False);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.LoadDocument(var pathIn, promptUser: OleVariant);
var
  aFileName: String;
  aPrompt: boolean;
begin
  // just DHTML Compatibility
  //asm int 3 end; //trap
  try
     if VarType(pathIn) = varOleStr
        then aFileName := pathIn
        else aFileName := '';

     if VarType(promptUser) = varBoolean
        then aPrompt := promptUser
        else aPrompt := true;

     LoadFile(aFileName, aPrompt);
     pathIn := aFileName;
  except
     //just catch any error
  end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SaveDocument(var pathIn, promptUser: OleVariant);
var
  aFileName: string;
  aPrompt: boolean;
begin
  // just DHTML Compatibility
  //asm int 3 end; //trap
  try
     aFileName := pathIn;
     aPrompt := promptUser;
     if aPrompt
        then begin
           if GetSaveFileName(aFileName) <> S_OK
              then exit;
        end;

     if sameText(aFileName, FCurrentDocumentPath)
        then SaveFile
        else SaveFileAs(aFileName);
     pathIn := aFileName;
  except
     //catch any error
  end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.FContextMenuClicked(Sender: TObject);
begin
  //asm int 3 end; //trap
  if assigned(FOnContextMenuAction)
     then FOnContextMenuAction(Self, (Sender as TMenuItem).Tag);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetContextMenu(var menuStrings, menuStates: OleVariant);
var
  Ps: PSafeArray;
  Pw: PWideChar;
  aState: OLE_TRISTATE;
  I: Integer;
  aCaption: string;
  NewMenuItem: TMenuItem;
begin
  // just DHTML Compatibility
  //asm int 3 end; //trap

  FContextMenu.Items.Clear;

  try
     if (VarArrayLowBound(menuStrings, 1) < 0) or
        (VarArrayLowBound(menuStates, 1) < 0)  or
        (VarArrayHighBound(menuStrings, 1) <> VarArrayHighBound(menuStates, 1))
        then exit;

     Ps := TVariantArg(menuStrings).pArray;
     for I := VarArrayLowBound(menuStrings, 1) to VarArrayHighBound(menuStrings, 1) do
        begin
           //add a new menu item to the popup menu
           NewMenuItem := TMenuItem.Create(nil);
           NewMenuItem.OnClick := FContextMenuClicked;
           NewMenuItem.Tag := I;

           //get each string from the SafeArray
           SafeArrayGetElement(Ps, I, Pw);
           aCaption := OleStrToString(Pw);
                               //blank menu item = separator in Context Menu
           if aCaption = ''    //we need - in a TPopUpmenu as separator
              then NewMenuItem.Caption := '-'
              else NewMenuItem.Caption := aCaption;

           FContextMenu.Items.Add(NewMenuItem);
        end;

     Ps := TVariantArg(menuStates).pArray;
     for I := VarArrayLowBound(menuStates, 1) to VarArrayHighBound(menuStates, 1) do
        begin
           //get each string from the SafeArray
           SafeArrayGetElement(Ps, I, aState);
           case aState of    // 0= Unchecked  1=Checked  2=Grayed
              0: {Nop};
              1: FContextMenu.Items[I].Checked := True;
              2: FContextMenu.Items[I].Enabled := false;
           end;
        end;
  except
     //just catch any error
  end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetGridX(const Value: integer);
begin
  //asm int 3 end; //trap
  FGridX := Value;
  if assigned(FEditHost)
     then TEditHost(FEditHost).FGridX := FGridX;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetGridY(const Value: integer);
begin
  //asm int 3 end; //trap
  FGridY := Value;
    if assigned(FEditHost)
     then TEditHost(FEditHost).FGridY := FGridY;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.SetSnapEnabled(const Value: Boolean);
begin
  //asm int 3 end; //trap
  FSnapEnabled := Value;
    if assigned(FEditHost)
     then TEditHost(FEditHost).FSnapEnabled := FSnapEnabled;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Get_AbsoluteDropMode: Boolean;
begin
  //asm int 3 end; //trap
  result := FAbsoluteDropMode;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Get_ShowBorders: WordBool;
begin
  //asm int 3 end; //trap
  result := FShowBorders;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.Set_AbsoluteDropMode(const Value: Boolean);
begin
  //asm int 3 end; //trap
  FAbsoluteDropMode := value;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetAppearance(aType: TUserInterfaceOption): TDHTMLEDITAPPEARANCE;
begin
  //asm int 3 end; //trap

  if aType in FUserInterfaceOptions
     then result := DEAPPEARANCE_FLAT
     else result := DEAPPEARANCE_3D;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Get_Appearance: TDHTMLEDITAPPEARANCE;
begin
  //asm int 3 end; //trap

  result := GetAppearance(NoBorder);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.Set_Appearance(const Value: TDHTMLEDITAPPEARANCE);
begin
  //asm int 3 end; //trap

  if value <> Get_Appearance
     then begin
        if value = DEAPPEARANCE_FLAT
           then Include(FUserInterfaceOptions, NoBorder)
           else Exclude(FUserInterfaceOptions, NoBorder);
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Get_ScrollbarAppearance: TDHTMLEDITAPPEARANCE;
begin
  //asm int 3 end; //trap

  result := GetAppearance(FlatScrollBar);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.Set_ScrollbarAppearance(const Value: TDHTMLEDITAPPEARANCE);
begin
  //asm int 3 end; //trap

  if value <> Get_ScrollbarAppearance
     then begin
        if value = DEAPPEARANCE_FLAT
           then Include(FUserInterfaceOptions, FlatScrollBar)
           else Exclude(FUserInterfaceOptions, FlatScrollBar);
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Get_Scrollbars: WordBool;
begin
  //asm int 3 end; //trap
  result := not(NoScrollBar in FUserInterfaceOptions);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.Set_Scrollbars(const Value: WordBool);
begin
  //asm int 3 end; //trap

  if value <> Get_Scrollbars
     then begin
        if value
           then Exclude(FUserInterfaceOptions, NoScrollBar)
           else Include(FUserInterfaceOptions, NoScrollBar);
     end;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.Set_ShowBorders(const Value: WordBool);
begin
  //asm int 3 end; //trap

  if value <> FShowBorders
     then begin
        FShowBorders := value;

        if not ComponentInDesignMode
           then CmdSet_B(IDM_SHOWZEROBORDERATDESIGNTIME, FShowBorders);
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Get_UseDivOnCarriageReturn: WordBool;
begin
  //asm int 3 end; //trap
  result := DivBlockOnReturn in FUserInterfaceOptions;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.Set_UseDivOnCarriageReturn(const Value: WordBool);
begin
  //asm int 3 end; //trap

  if value <> Get_UseDivOnCarriageReturn
     then begin
        if value
           then Include(FUserInterfaceOptions, DivBlockOnReturn)
           else Exclude(FUserInterfaceOptions, DivBlockOnReturn);
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.KSTEst(var pInVar, pOutVar: OleVariant): HResult;
        //call edit.CmdGet(KS_TEST, ov);
var
  sFindThis: string;
  //kt FP: MSHTML_TLB.IMarkupPointer; //points to end of searched string - if found
  FP: MSHTML_EWB.IMarkupPointer; //points to end of searched string - if found
  FMarkupContainer: IMarkupContainer;
begin
  //asm int 3 end; //trap

  {$IFDEF EDLIB}
     sFindThis := InputBox('Search', 'Please enter the string to search for...', '');
     if length(sFindThis) = 0
        then exit;

     FMarkupContainer := Doc as IMarkupContainer;

     //Search from start of document
     OleCheck(FMarkupPointerStart.MoveToContainer(FMarkupContainer, Integer(True)));
     //Search to end of document
     OleCheck(FMarkupPointerEnd.MoveToContainer(FMarkupContainer, Integer(False)));

     if S_OK = EDFindText(Self, FMarkupPointerStart, FMarkupPointerEnd, sFindThis, FP)
        then begin
            if S_OK = EDInsertText(Self, FP, '--Found It--')
            then KSMessageI('Did the insert...')
            else KSMessageI('Insert failed...');
         end
         else KSMessageI('Could not locate ' + sFindThis + '.');
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.OnControlInfoChanged: HResult;
begin
  //asm int 3 end; //trap
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.LockInPlaceActive(fLock: BOOL): HResult;
begin
  //asm int 3 end; //trap
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.GetExtendedControl(out disp: IDispatch): HResult;
begin
  //asm int 3 end; //trap
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.TransformCoords(var ptlHimetric: TPoint; var ptfContainer: TPointF; flags: Longint): HResult;
begin
  //asm int 3 end; //trap
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.OleControlSite_TranslateAccelerator(msg: PMsg; grfModifiers: Longint): HResult;
begin
  //asm int 3 end; //trap

  { KEYMOD_SHIFT = 0x00000001,
    KEYMOD_CONTROL = 0x00000002,
    KEYMOD_ALT = 0x00000004

    S_OK, The container processed the message.
    S_FALSE, The container did not process the message.
             This value must also be returned in all other error cases
             besides E_NOTIMPL.

    E_NOTIMPL, The container does not implement accelerator support. }

  { we handle Accelerators in IDOCHOSTUIHANDLER:TranslateAccelerator witch
    is called before this function.

    After the call to IDOCHOSTUIHANDLER:TranslateAccelerator
    IHtmlEditDesigner.TranslateAccelerator is called.

    If MSHTML handle the key we don't come here !  }

  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.OnFocus(fGotFocus: BOOL): HResult;
begin
  //asm int 3 end; //trap

  { Each time the WebBrowser gains focus we hook its window and we unhook
    the window again when the WebBrowser loses focus.
    This makes all messages send to MSHTML flow trough EDMessageHandler before
    MSHTML get a chance to handle them }

  if fGotFocus
     then SubClassMsHTML
  else UnSubClassMsHTML;
  
  //ktResult := S_OK;
  Result := S_OK or SubFocusHandler(fGotFocus); //kt
end;
//------------------------------------------------------------------------------
function TEmbeddedED.ShowPropertyFrame: HResult;
begin
  //asm int 3 end; //trap
  Result := E_NOTIMPL;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.IsSelElementLocked: boolean;
begin
  //asm int 3 end; //trap

  {$IFDEF EDZINDEX}
     result := TZindex(FTZindex).IsSelElementLocked;
  {$ELSE}
     result := false;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.EDOnMouseOver(const pEvtObj: IHTMLEventObj);
begin
  //asm int 3 end; //trap
  {$IFDEF EDTABLE}
     if assigned(FTtable) and FEditMode
        then TTable(FTtable).TblOnmouseover(pEvtObj);
  {$ENDIF}

  if Assigned(FOnmouseover)
     then FOnmouseover(self);
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.NotImplemented(S: String);
begin
  //asm int 3 end; //trap
  KSMessageW(S + DblCrLf + 'is not implemented');
end;
//------------------------------------------------------------------------------
function TEmbeddedED.EndUndoBlock(aResult: HResult): HResult;
begin
  //asm int 3 end; //trap

  result := S_OK;

  if aResult = S_OK
     then EndUndoUnit //no errors in the calling procedure, just close undo block
     else begin
        //the calling procedure had an error, so we need to clean up after it

        {$IFDEF EDUNDO}
           if assigned(FTUndo)
              then begin
                 result := TUndo(FTUndo).CleanUpUndoBlock;
                 exit;
              end;
         {$ENDIF}


        //we are using MSHTMLs UNDO stack

        {$IFDEF EDLIB}
           result := CleanUpMSHTMLUndoBlock(Self);
        {$ELSE}
           result := CmdSet(IDM_Undo);
        {$ENDIF}
     end;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.ClearUndoStack: HResult;
begin
  //asm int 3 end; //trap

  result := S_OK;

  if not FEditMode
     then exit;

  if FLocalUndo
     then begin
        {$IFDEF EDUNDO}
           if FTUndo <> nil
              then result := TUndo(FTUndo).ClearStack;
           exit;
        {$ENDIF}
     end;

  //we are using MSHTMLs UNDO stack

  {$IFDEF EDLIB}
     result := ClearMSHTMLStack(Self);
  {$ELSE}
     result := S_FALSE;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.CaretIsVisible: Boolean;
var
  Visible: Integer;
begin
  //asm int 3 end; //trap
  FCaret.IsVisible(Visible);
  result := Visible <> 0;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.Accept(const URL: String; var Accept: Boolean);
begin
  //asm int 3 end; //trap
  Accept := true;
end;
//------------------------------------------------------------------------------
{$IFDEF EDDRAGDROP}
//------------------------------------------------------------------------------
function TEmbeddedED.DragEnter(const dataObj: IDataObject; grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  //asm int 3 end; //trap
  if FMSHTMLDropTarget <> nil //just re delegate to MSHTML
     then result := FMSHTMLDropTarget.DragEnter(dataObj, grfKeyState, pt, dwEffect)
     else result := E_UNEXPECTED;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.DragLeave: HResult;
begin
  //asm int 3 end; //trap
  if FMSHTMLDropTarget <> nil //just re delegate to MSHTML
     then result := FMSHTMLDropTarget.DragLeave
     else result := E_UNEXPECTED;
end;
//------------------------------------------------------------------------------
function TEmbeddedED._DragOver(grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  //asm int 3 end; //trap
  if FMSHTMLDropTarget <> nil //just re delegate to MSHTML
     then result := FMSHTMLDropTarget.DragOver(grfKeyState, pt, dwEffect)
     else result := E_UNEXPECTED;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Drop(const dataObj: IDataObject; grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  ProxyDataObj: TDataObjectProxy;
begin
  //asm int 3 end; //trap

  result := S_OK;

  if (not FAbsoluteDropMode) or (FMSHTMLDropTarget = nil)
     then begin
        result := E_UNEXPECTED;
        exit;
     end;

  if dataObj <> nil
     then begin
        ProxyDataObj := TDataObjectProxy.Create(dataObj, DOC, FmsHTMLwinHandle, pt);
        try
           //just re delegate to MSHTML
           result := FMSHTMLDropTarget.Drop(ProxyDataObj, grfKeyState, pt, dwEffect);
        finally
           WaitAsync;
           ProxyDataObj.free;
        end;
     end;

end;
//------------------------------------------------------------------------------
{$ENDIF}   //{$IFDEF EDDRAGDROP}
//------------------------------------------------------------------------------
procedure TEmbeddedED.Set_LocalUndo(const Value: WordBool);
begin
  //asm int 3 end; //trap

  {$IFDEF EDUNDO}
     if Value = FLocalUndo
        then exit;

     FLocalUndo := Value;
     if(not ComponentInDesignMode) and DocumentIsAssigned
        then SetLocalUndo(Self, FTUndo, Value);
   {$ELSE}
     if ComponentInDesignMode
        then FLocalUndo := false
        else begin
           if value
              then NotImplemented('Set LocalUndo');
        end;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED._QueryStatus(CmdGroup: PGUID; cCmds: Cardinal; prgCmds: POleCmd; CmdText: POleCmdText): HResult;
begin
  //asm int 3 end; //trap
  result := S_OK;
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Exec(CmdGroup: PGUID; nCmdID, nCmdexecopt: DWORD; const vaIn: OleVariant; var vaOut: OleVariant): HResult;
var
  FCancel: Boolean;
begin
  //asm int 3 end; //trap

  if CmdGroup = nil
     then begin
        Result := OLECMDERR_E_UNKNOWNGROUP;
        exit;
     end
     else Result := OLECMDERR_E_NOTSUPPORTED;


  if IsEqualGuid(cmdGroup^, CGID_DocHostCommandHandler)
     then begin
        case nCmdID of

           6041 {F5}, 6042 {ContextMenu}, 2300 {IDM_REFRESH}:
              begin
                 FCancel := False;
                 If Assigned(FOnRefreshBegin)
                    then FOnRefreshBegin(Self, nCmdID, FCancel);

                 if FCancel
                    then Result := S_OK
                    else FRefreshing := true;
              end;
        end;
     end;
end;
{IOleCommandTarget END}
//------------------------------------------------------------------------------
function TEmbeddedED.GetGenerator: string;
begin
  //asm int 3 end; //trap

  result := FGenerator;
end;
//------------------------------------------------------------------------------
procedure TEmbeddedED.Set_Generator(const Value: String);
begin
  //asm int 3 end; //trap

  if Value = FGenerator
     then exit;

  {$IFDEF EDLIB}
     FGenerator := Value
  {$ELSE}
      NotImplemented('Set Generator');
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.PrintPreview(value: Olevariant): HResult;
var
  aResult: TPrintSetup;
  B: Boolean;
  CmdOpt: Cardinal;
begin
  //asm int 3 end; //trap

  {$IFDEF EDPRINT}
     if ISEmptyParam(value)
        then begin
           aResult[0] := '';
           aResult[1] := '0';
           B := true;
        end
        else B := VariantArrayToPrintSetup(Value, aResult);

     if B and
        PrintPreview(aResult)
        then result := S_OK
        else result := S_FALSE;

  {$ELSE}
     if value
        then result := DoCommand(IDM_PRINTPREVIEW, OLECMDEXECOPT_PROMPTUSER)
        else result := DoCommand(IDM_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER);
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.PrintEx(value: Olevariant; Showdlg: boolean): HResult;
var
  aResult: TPrintSetup;
begin
  //asm int 3 end; //trap
  {$IFDEF EDPRINT}
     if VariantArrayToPrintSetup(Value, aResult) and
        Print(aResult, Showdlg)
        then result := S_OK
        else result := S_FALSE;
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.Print(value: TPrintSetup; Showdlg: boolean = false): Boolean;
const
  NotPreView: Boolean = False;
begin
  //asm int 3 end; //trap
  {$IFDEF EDPRINT}
     result := SetPrintTemplate(value) and
               DoPrint(NotPreView, Doc, Showdlg, GetPrintFileName);
  {$ENDIF}
end;
//------------------------------------------------------------------------------
function TEmbeddedED.PrintPreview(value: TPrintSetup): Boolean;
const
  PreView: Boolean = true;
  NoShowdlg: Boolean = False;
begin
  //asm int 3 end; //trap

  {$IFDEF EDPRINT}
     result := SetPrintTemplate(value) and
            DoPrint(PreView, Doc, NoShowdlg, GetPrintFileName);
  {$ENDIF}
end;
//------------------------------------------------------------------------------

initialization
  OleInitialize(nil);
  TheActualAppName := '';


finalization
  try
  OleUninitialize;
  except
  end;

end.




