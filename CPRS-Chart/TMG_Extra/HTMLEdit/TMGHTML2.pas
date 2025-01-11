unit TMGHTML2;

//kt 9/11

(*
NOTES:  By Kevin Toppenberg, MD 5/27/09

Code heavily modified from original code found at www.supermemo.com/source/
Their notes (below) indicate that the code may be freely used.
---------------
This unit encapsulates SHDocVw.dll and MSHTML.dll functionality by subclassing
THtmlEditorBrowser object as THtmlEditor object

THtmlEditor was designed for easy use of HTML display and editing capacity in
SuperMemo 2002 for Windows developed by SuperMemo R&D in Fall 2001.

SuperMemo 2002 implements HTML-based incremental reading in which extensive HTML
support is vital.

Pieces of this units can be used by anyone in other Delphi applications that make
use of HTML WYSIWYG interfaces made open by Microsoft.
*)

(*
NOTICE: Also Derived from EmbeddedED.  See notes in that code block.
*)

interface

uses SysUtils, WinTypes, Dialogs, StdCtrls, Menus,
     EmbeddedED,
     WinMsgLog,  //kt 8/16
     ORNet, TRPCB, //ELH 10/6/22
     ActiveX, MSHTMLEvents, SHDocVw, {MSHTML,} MSHTML_EWB,
     AppEvnts, controls, ExtCtrls,
     IeConst,Messages,Classes,Forms,Graphics;

type
  TSetFontMode = (sfAll,sfSize,sfColor,sfName,sfStyle,sfCharset);
  TLocalTimerAction = (ltFreeCtrl, ltSetFocus);  //kt 10/2014

  THTMLSearchFlags = set of (    //from IHTMLTxtRange.findText flags, not all included here.
    hsPartial,              //Match partial words
    hsReverse,              //Match in reverse
    hsWholeWords,           //Match whole words only
    hsCaseSensitive);      //Match case

  TFindMode = (fmFirst, fmNext, fmExtendSelToNext);  //kt 6/16

  TRGBColor = record
       R : byte;
       G : byte;
       B : byte;
  end; {record}

  TMGColor = record
    case boolean of
      True: (Color : TColor);
      False: (RGBColor : TRGBColor);
  end; {record}

  TRangeInfo = record
    StartPos : longint;
    EndPos   : longint;
  end;

  TIterateCallbackProc = procedure (Elem : IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean) of object;  //kt 2/21/16
  //ktTPasteEventProc = procedure (var ClipboardText : TStringList; var TextModified : boolean; var AllowPaste : boolean; var IsHTML : boolean) of object; //kt 8/16
  TPasteEventProc = procedure (Sender : TObject; var AllowPaste : boolean) of object; //kt 8/16

  // THtmlObj=class(TWebBrowser)
  THtmlObj=class(TEmbeddedED)
  private
    FZoomStep :              integer; //kt 9/4/15
    FZoomValue :             integer; //kt 9/4/15
    SuspendKeyProcessing :   boolean; //kt 10/2014
    FOnPasteEvent :          TPasteEventProc;  //kt 8/16
    CtrlToBeProcessed  :     boolean;
    ShiftToBeProcessed :     boolean;
    CtrlReturnToBeProcessed: boolean;
    Modified:                boolean;
    FOrigAppOnMessage :      TMessageEvent;
    FApplication :           TApplication;
    FActive :                boolean;
    FEditable:               boolean;
    ColorDialog:             TColorDialog;
    AllowNextBlur :          boolean;
    LocalTimer :             TTimer;
    LocalTimerAction:        set of TLocalTimerAction;
    function  GetHTMLText:string;
    procedure SetHTMLText(HTML:String);
    function  GetText:string;
    procedure SetText(HTML:string);
    function  GetEditableState : boolean;
    procedure SetEditableState (EditOn : boolean);
    procedure SetBackgroundColor(Color:TColor);
    function  GetBackgroundColor : TColor;
    function ColorToMSHTMLStr(color : TColor) : string;
    function MSHTMLStrToColor(MSHTMLColor : string) : TColor;
    procedure SetTextForegroundColor(Color:TColor);
    function  GetTextForegroundColor : TColor;
    procedure SetTextBackgroundColor(Color:TColor);
    function  GetTextBackgroundColor : TColor;
    function  GetFontSize : integer;
    procedure SetFontSize (Size : integer);
    function  GetFontName : string;
    procedure SetFontName (Name : string);
    function  GetSelText:string;
    procedure SetSelText (HTMLText : string);
    //procedure ReassignKeyboardHandler(TurnOn : boolean);
    procedure GlobalMsgHandler(var Msg: TMsg; var Handled: Boolean);
    procedure HandleBlur(Sender: TObject);
    procedure SubMessageHandler(var Msg: TMessage); override;
    function SubFocusHandler(fGotFocus: BOOL): HResult; override;
    function GetActive : boolean;
    procedure SetZoom(Pct : integer);  //kt added 9/4/15
    procedure SetZoomStep(Value : integer);  //kt added 9/4/15
    procedure SetAsModified;   //kt 9/4/15
    procedure LaunchDateInsert;
    function RuleStyleToCSSText(Style: IHTMLRuleStyle) : string;
    procedure CSSTextToHumanReadable(SelectorText, CSSText : string; OutSL : TStrings);
    //procedure StripQuotes(SL : TStrings; QtChar: char);
    //procedure StripBetweenChars(SL : TStrings; OpenChar, CloseChar : char; StartPos: integer = 1; NumToDel : integer = MaxInt); overload;
    //procedure StripBetweenChars(var s : string; OpenChar, CloseChar : char; StartPos: integer = 1; NumToDel : integer = MaxInt); overload;
    //procedure StripBraces(SL : TStrings; StartPos: integer = 1; NumToDel : integer = MaxInt); overload;
    //procedure StripBraces(var s : string; StartPos: integer = 1; NumToDel : integer = MaxInt); overload;
    //procedure StripBetweenTags(SL : TStrings; OpenTag, CloseTag : string; StartLineIdx : Word = 0; Count : Word = 9999);
    //procedure TrimFunction(SL : TStrings; FnStr : string);
    function FlagsToWord(Flags : THTMLSearchFlags = [hsPartial]) : word;  //kt 6/16
    procedure HandleGetByClassCallback (Elem : IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean);
    procedure HandleGetOneByClassCallback (Elem : IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean);
    procedure HandleGetByTagNameCallback (Elem : IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean);
    procedure HandleGetOneByTagNameCallback (Elem : IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean);
    procedure PostKeyEx32(key: Word; const shift: TShiftState; specialkey: Boolean);
  public
    {end public}
    PopupMenu:     TPopupMenu;
    KeyStruck : boolean; // A VERY crude determiner as to if Modified.
    NextControl : TWinControl;
    PrevControl : TWinControl;
    OnLaunchTemplateSearch : TNotifyEvent;                          //kt 10/2014
    OnLaunchDialogSearch : TNotifyEvent;                          //kt 10/2014
    OnLaunchConsole : TNotifyEvent;                                 //kt 6/2015
    OnModified : TNotifyEvent;                                      //kt 9/4/15
    OnInsertDate : TNotifyEvent;                                    //kt 12/29/15
    TMGHandle : THandle;                                            //kt 8/16
    WinMessageLog: TfrmWinMessageLog;                               //kt 8/16 -- debug tool
    function  GetFullHTMLText:string; //html text including from <head> </head>
    procedure HandleLocalTimerAction(Sender : TObject);
    procedure SetMsgActive (Active : boolean);
    constructor Create(Owner: TControl; Application : TApplication);
    destructor Destroy; override;
    procedure Clear;
    procedure ToggleBullet;
    procedure ToggleItalic;
    procedure ToggleBold;
    procedure ToggleNumbering;
    procedure ToggleUnderline;
    procedure ToggleSubscript;
    procedure ToggleSuperscript;
    procedure Indent;
    procedure Outdent;
    procedure Paste;
    procedure PasteEvent(Sender : TObject; var AllowPaste : boolean);
    procedure AlignLeft;
    procedure AlignRight;
    procedure AlignCenter;
    procedure TextForeColorDialog;
    procedure TextBackColorDialog;
    procedure FontDialog;
    function  SelStart:integer;
    function  SelEnd:integer;
    function  Selection : IHTMLSelectionObject;  //kt 6/16
    function  SelectionInfo(): TRangeInfo;  //kt 4/8/21
    procedure SetSelectionByPos(StartPos, EndPos : longint); //kt 4/8/21
    procedure SetSelectionByRange(ARange : IHtmlTxtRange); //kt 4/8/21
    procedure SetSelectionByRangeInfo(ARangeInfo : TRangeInfo); //kt 4/8/21
    procedure SelCollapse;
    function  RangeInfo(ARange : IHtmlTxtRange): TRangeInfo;    //kt 4/8/21
    function  SelLength:integer;
    function  CustomRange(RangeInfo : TRangeInfo) : IHtmlTxtRange;  overload; //kt 4/8/21
    function  CustomRange(StartPos, EndPos : longint) : IHtmlTxtRange;  overload; //kt 4/8/21
    function  GetTextRange:IHtmlTxtRange;
    procedure ReplaceSelection(HTML:string);
    function  Find(Text : string; Flags : THTMLSearchFlags = [hsPartial]; Mode : TFindMode = fmFirst) : boolean;  //kt 6/16
    function  FindFirst(Text : string; Flags : THTMLSearchFlags = [hsPartial]) : boolean;  //kt 6/16
    function  FindNext(Text : string; Flags : THTMLSearchFlags = [hsPartial]) : boolean;   //kt 6/16
    function  FindNextExtendingSelection(Text : string; Flags : THTMLSearchFlags = [hsPartial]) : boolean;  //kt 6/16
    procedure Loaded; Override;
    function  GetTextLen : integer;
    function  MoveCaretToEnd : boolean;
    function  MoveCaretToPos(ScreenPos: TPoint) : HRESULT;          //kt added
    procedure ZoomIn;
    procedure ZoomOut;
    procedure ZoomReset;
    procedure InsertHTMLAtCaret(HTMLText : AnsiString);             //kt 4/21/10
    procedure InsertTextAtCaret(Text : AnsiString); //Note: Text is NOT HTMLtext
    function GetCaretLocation() : TPoint;
    function GetScrollLocation: integer;
    property  HTMLText:string read GetHTMLText write SetHTMLText;
    property  Text:string read GetText write SetText;
    //property Active : boolean read FActive write SetMsgActive;
    property  Active : boolean read GetActive;
    property  Editable : boolean read GetEditableState write SetEditableState;
    property  BackgroundColor : TColor read GetBackgroundColor write SetBackgroundColor;
    property  FontSize : integer read GetFontSize write SetFontSize;
    property  FontName : string read GetFontName write SetFontName;
    property  SelText : string read GetSelText write SetSelText;
    property  Zoom : integer read FZoomValue write SetZoom;
    property  ZoomStep : integer read FZoomStep write SetZoomStep;
    property  OnPasteEvent : TPasteEventProc read FOnPasteEvent write FOnPasteEvent;  //kt 8/16
    function GetDocHead: IHTMLElement;
    function GetDocBody: IHTMLElement;
    function GetDocStyleElement: IHTMLElement;
    function GetFirstDocStyleSheet: IHTMLStyleSheet;
    procedure GetDocStyles(HumanReadableSL : TStrings); overload;
    procedure GetDocStyles(SelectorSL, CSSLineSL : TStringList); overload;
    function AddStyles(SelectorSL, CSSLineSL : TStringList) : IHTMLStyleSheet;
    procedure AddStylesToExistingStyleSheet(StyleSheet: IHTMLStyleSheet; SelectorSL, CSSLineSL : TStringList);
    procedure EnsureStyles(HumanReadableStyleCodes : TStringList);
    procedure ConvertHumanReadableStylesToSL(InSL, SelectorSL, CSSLineSL : TStringList);
    function GetDocScriptElement: IHTMLElement;
    procedure GetDocScripts(JavaScriptSL : TStrings);
    procedure SetDocScripts(JavaScriptSL : TStrings; Append : boolean = false);
    procedure GetDocScriptSummary(OutSL : TStrings);
    procedure EnsureScripts(JavaScriptSL : TStrings);
    function GetElementById(const Id: string): IHTMLElement;
    procedure GetElementsArrayById(const Id: string; OutList : TInterfaceList);
    function GetElementByClass(const AClass: string): IHTMLElement;
    procedure GetElementsArrayByClass(const AClass: string; OutList : TInterfaceList);
    function GetElementByTagName(TagName: string): IHTMLElement;
    procedure GetElementsArrayByTagName(TagName: string; OutList : TInterfaceList);
    procedure IterateElements(CallBack : TIterateCallbackProc; Msg : string; Obj : TObject);
    function SearchElements(CheckMatch : TIterateCallbackProc; Msg : string; Obj : TObject) : IHTMLElement;
    function AppendBodyNode(TagName : string; Id : string = ''; InnerHTML : string= '') : IHtmlElement;
    procedure SetInnerHTMLByID(Id : string; Content : string);
    procedure SendKeys(key: Word; const shift: TShiftState; specialkey: Boolean);
  end;

function HTMLElement_PropertyValue(Elem : IHTMLElement; PropertyName : string) : string;
function HTMLElement_HasClassName(Elem : IHTMLElement; AClassName : string) : boolean;
procedure HTMLElement_EnsureHasClassName(Elem : IHTMLElement; AClassName : string);
procedure HTMLElement_RemoveClassName(Elem : IHTMLElement; AClassName : string);

var
  CF_HTML : integer = -1;


implementation


uses
  WinProcs,Variants,Clipbrd, StrUtils, Math, ORFn,
  uHTMLTools, uTMGOptions,
  Windows;

const
  FontScale=3;
  MaxTextLength = 10000000; //was 10000;  //was 100
  nl = #13#10;




procedure EError(EText : string; E : Exception);
begin
  MessageDlg(EText,mtError,[mbOK],0);
end;


constructor THtmlObj.Create(Owner:TControl; Application : TApplication);
var TempWin : IOLEWindow;  //kt 8/16
    TempHandle : Windows.HWND;  //kt 8/16
begin
  inherited Create(Owner);  //Note: Owner should be a descendant of TControl;
  FApplication := Application;
  FOrigAppOnMessage := Application.OnMessage;
  OnBlur := HandleBlur;
  AllowNextBlur := false;
  KeyStruck := false;
  Modified := false;
  NextControl := nil;
  PrevControl := nil;
  OnLaunchTemplateSearch := nil;
  OnLaunchDialogSearch := nil;               
  OnLaunchConsole := nil;
  OnModified := nil; //kt 9/4/15
  OnInsertDate := nil;  //kt 12/29/15
  SuspendKeyProcessing := false;
  LocalTimer := TTimer.Create(Self);
  LocalTimer.Enabled := false;
  LocalTimer.OnTimer := HandleLocalTimerAction;
  LocalTimerAction := [];
  FZoomValue := 100;  //100%
  FZoomStep := 20;  //e.g. 5% change with each zoom in
  //kt mod 7/31/16 ----------
  Self.TMGHandle := 0;
  if Self.ControlInterface.QueryInterface(IOleWindow, TempWin) = 0 then begin
    if TempWin.GetWindow(TempHandle) = 0 then begin
      Self.TMGHandle := TempHandle;
    end;
  end;
  WinMessageLog := nil;
  //FOnPasteEvent := nil; //kt 8/16
  FOnPasteEvent := PasteEvent;  //<-- This one works, just need to figure out how to properly use it when the user needs it    9/15/22
  if (CF_HTML = -1) then begin
    CF_HTML  := RegisterClipboardFormat('HTML Format');
  end;
  //kt --- end mod 7/31/16 ----------
end;

destructor THtmlObj.Destroy;
begin
  SetMsgActive(false); //Turns off local OnMessage handling
  LocalTimer.Free;
  inherited Destroy;
end;

procedure THtmlObj.HandleLocalTimerAction(Sender : TObject);
begin
  if (ltFreeCtrl in LocalTimerAction) then begin
    CtrlToBeProcessed := false;
    LocalTimerAction := LocalTimerAction - [ltFreeCtrl];
  end;
  if (ltSetFocus in LocalTimerAction) then begin
    Self.SetFocus;  //this isn't working either!
    LocalTimerAction := LocalTimerAction - [ltSetFocus];
  end;
  if LocalTimerAction = [] then begin
    LocalTimer.Enabled := false;
  end;
end;


procedure THtmlObj.SetHTMLText(Html : String);
begin
  DocumentHTML := Html;
  SetEditableState(FEditable);
end;

function ConvertedWS(WS : widestring) : string;
var
    ch:WideChar;
    n:integer;
    w:word;
    s:string;
begin
  for n:=1 to length(WS) do begin
    ch := WS[n];
    w := word(ch);
    if w>255 then begin
       s:=IntToStr(w);
       s:='&#'+s+';';
    end else s:=ch;
    Result:=Result+s;
  end;
end;

function THtmlObj.GetFullHTMLText:string;
var WS:WideString;
    RootHTMLElement, body: IHTMLElement;
begin
  Result:='';
  if Doc=nil then exit;
  body := Doc.body;
  if body = nil then exit;
  RootHTMLElement := body.parentElement;
  if RootHTMLElement = nil then exit;
  WS := RootHTMLElement.innerHTML;
  result := ConvertedWS(WS);
end;

function THtmlObj.GetHTMLText:string;
var WS:WideString;
    {ch:WideChar;
    n:integer;
    w:word;
    s:string;}
begin
  //Result:=DocumentHTML;
  Result:='';
  if Doc=nil then exit;
  WS:=Doc.body.innerHTML;
  result := ConvertedWS(WS);
end;

function THtmlObj.GetText:string;
var WS:WideString;
    ch:WideChar;
    n:integer;
    w:word;
    s:string;
begin
  Result:='';
  if DOC=nil then exit;
  WS:=Doc.body.innerText;
  for n:=1 to length(WS) do begin
    ch:=WS[n];
    w:=word(ch);
    if w>255 then begin
      w:=(w mod 256)+48;
      s:=IntToStr(w);  //<-- delete??
      s:=char(w);
    end else s:=ch;
    Result:=Result+s;
  end;
end;

procedure THtmlObj.SetText(HTML:string);
begin
  if (DOC=nil)or(DOC.body=nil) then SetHTMLText(HTML)
  else DOC.body.innerHTML:=HTML;
end;

procedure THtmlObj.Clear;
begin
  //kt if IsDirty then
    NewDocument;
    KeyStruck := false;
    Modified := false;
  //SetHTMLText('');
end;

function THtmlObj.GetEditableState : boolean;
var mode : string;
begin
  {
  mode := Doc.designMode;
  result := (mode = 'On');
  }
  Result := FEditable; //kt 3/16
end;

procedure THtmlObj.SetEditableState(EditOn : boolean);
var LastMode : string;
    count : integer;
begin
  LastMode := 'Inherit';
  FEditable := EditOn;
  try
    count := 0;
    repeat
      inc (count);
      if Doc = nil then begin
        FApplication.ProcessMessages;
        Sleep (100);
        continue;
      end else if Doc.body = nil then begin
        FApplication.ProcessMessages;
        Sleep (100);
        continue;
      end;
      LastMode := 'OK';
      if EditOn then begin
        Doc.body.setAttribute('contentEditable','true',0);
        //kt 3/22/16 Doc.designMode := 'On';  //kt  <--- scripts can not be run with designMode on.
        Doc.execCommand('RespectVisibilityInDesign', false, true); //from here: http://stackoverflow.com/questions/10296853/css-display-none-property-doesnt-work-for-contenteditable-div-on-internet-explo
        //FEditable:=true;
        //LastMode := Doc.designMode;
      end else begin
        Doc.body.setAttribute('contentEditable','false',0);
        //kt 3/22/16 Doc.designMode := 'Off';  //kt
        //FEditable:=false;
        //LastMode := Doc.designMode;
      end;
      //kt 3/16 LastMode := Doc.designMode;
    until (LastMode <> 'Inherit') or (count > 20);
  except
    on E:Exception do EError('Error switching into HTML editing state',E);
  end;
end;

procedure THtmlObj.SetBackgroundColor(Color:TColor);
begin
  if Doc=nil then exit;
  if self.GetEditableState = False then exit;
  //WaitLoad(true); //kt
  WaitForDocComplete;
  if Doc.body=nil then exit;
  Doc.body.style.backgroundColor := ColorToMSHTMLStr(Color);
end;

function  THtmlObj.GetBackgroundColor : TColor;       
begin
  Result := clBlack; //default;
  if Doc=nil then exit;
  if self.GetEditableState = False then exit;
  if Doc.body=nil then exit;
  Result := MSHTMLStrToColor(Doc.body.style.backgroundColor);
end;

function THtmlObj.ColorToMSHTMLStr(color : TColor) : string; 
//Note: TColor stores colors lo-byte --> hi-byte as RGB
//Function returns '#RRGGBB'
var tempColor : TMGColor;        
begin
  tempColor.Color := color;
  Result := '#'+
            IntToHex(tempColor.RGBColor.R,2)+  
            IntToHex(tempColor.RGBColor.G,2)+
            IntToHex(tempColor.RGBColor.B,2);
end;

function THtmlObj.MSHTMLStrToColor(MSHTMLColor : string) : TColor;
//Function converts '#RRGGBB' -- TColor
//Note: TColor stores colors lo-byte --> hi-byte as RGB
var tempColor : TMGColor;            
    strHexRed,strHexGreen,strHexBlue : string[2];
begin
  Result := clBlack;  //FIX!!!! IMPLEMENT LATER...
  if Pos('#',MSHTMLColor)=1 then begin
   // MSHTMLColor := MidStr(MSHTMLColor,2,99);
   strHexRed := MidStr(MSHTMLColor,2,2);
   strHexGreen := MidStr(MSHTMLColor,4,2);
   strHexBlue := MidStr(MSHTMLColor,6,2);
   tempColor.RGBColor.R := StrToIntDef('$'+StrHexRed,0);
   tempColor.RGBColor.G := StrToIntDef('$'+StrHexGreen,0);
   tempColor.RGBColor.B := StrToIntDef('$'+StrHexBlue,0);
   Result := tempColor.Color;
   //NOTE: This function has not yet been tested....
  end;
end;

procedure THtmlObj.ToggleBullet;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  //SpecialCommand(IDM_UnORDERLIST,false,true,false,Null);
  DOC.execCommand('InsertUnorderedList',false,null);  
  //Modified:=true;  //kt 9/4/15
  SetAsModified;   //kt 9/4/15
end;

procedure THtmlObj.ToggleItalic;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.execCommand('Italic',false,null);  
  //Modified:=true;  //kt 9/4/15
  SetAsModified;  //kt 9/4/15
end;

procedure THtmlObj.ToggleBold;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.execCommand('Bold',false,null);
  //Modified:=true;  //kt 9/4/15
  SetAsModified;  //kt 9/4/15
end;

procedure THtmlObj.ToggleNumbering;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.execCommand('InsertOrderedList',false,null);
//  SpecialCommand(IDM_ORDERLIST,false,true,false,Null);
  //Modified:=true;  //kt 9/4/15
  SetAsModified;  //kt 9/4/15
end;

procedure THtmlObj.ToggleUnderline;
begin
   if DOC=nil then exit;
   if self.GetEditableState = False then exit;
   DOC.execCommand('Underline',false,null);
  //Modified:=true;  //kt 9/4/15
  SetAsModified;  //kt 9/4/15
end;

procedure THtmlObj.ToggleSubscript;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.execCommand('Subscript',False,0);
  //Modified:=true;  //kt 9/4/15
  SetAsModified;  //kt 9/4/15
end;

procedure THtmlObj.ToggleSuperscript;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.execCommand('Superscript',False,0);
  //Modified:=true;  //kt 9/4/15
  SetAsModified;  //kt 9/4/15
end;


procedure THtmlObj.Indent;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.ExecCommand('Indent',false,0);
  //Modified:=true;   //kt 9/4/15
  SetAsModified;   //kt 9/4/15
end;

procedure THtmlObj.Outdent;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.ExecCommand('Outdent',false,0);
  //Modified:=true;   //kt 9/4/15
  SetAsModified;   //kt 9/4/15
end;

procedure THtmlObj.Paste;
begin
   Showmessage('test');
end;

procedure THtmlObj.PasteEvent(Sender : TObject; var AllowPaste : boolean);
   //This procedure is triggered when the user pastes something into the
   //    TIU editor. It gets the HTML from the clipboard44. If there isn't
   //    any HTML, it passes back and lets Windows handle it. If there is
   //    it sends the HTML to the server to alter as needed then inserts it
   //    into the note

      procedure TMGLocalBackup(Text : TStrings;FileName : string);
      //kt added entire function 10/12/16
      //Note: TfrmImages.EmptyCache() will delete all these files when CPRS exits normally.
      var SL : TStringList;
          BackupDir, NowStr : string;
          i : integer;
      begin
        NowStr := DateTimeToStr(Now);
        NowStr := StringReplace(NowStr,'/','-', [rfReplaceAll]);
        NowStr := StringReplace(NowStr,':','-', [rfReplaceAll]);
        NowStr := StringReplace(NowStr,' ','_', [rfReplaceAll]);
        SL := TStringList.Create;
        SL.Add('Backup: ' + NowStr);
        SL.Add('== TEXT ===');
        for i := 0 to Text.Count-1 do begin
          SL.Add(Text.Strings[i]);
        end;
        SL.Add('== END TEXT ===');
        BackupDir := GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache';
        if not DirectoryExists(BackupDir) then CreateDir(BackupDir);
        Filename := BackupDir + '\' + FileName + NowStr+'.txt';
        SL.SaveToFile(Filename);
        SL.Free;
      end;

      function StripOutNonAscii(const s: string): string;
      var
        i, Count: Integer;
      begin
        SetLength(Result, Length(s));
        Count := 0;
        for i := 1 to Length(s) do begin
          if ((s[i] >= #32) and (s[i] <= #127)) or (s[i] in [#10, #13]) then begin
            inc(Count);
            Result[Count] := s[i];
          end else begin
            //if s[i]=#194 then begin
              //ShowMessage(inttostr(Ord(s[i])));   //REMOVE THIS. TESTING ONLY
            inc(Count);
            Result[Count] := ' ';
            //end;
          end;
        end;
        SetLength(Result, Count);
      end;

      procedure StrToStringList(const aSource:String;
                                const aList :TStringList;
                                const aFixedLen: integer);
      var idx,srclen:integer;
      begin
         aList.Capacity := (Length(aSource) div aFixedLen) + 1;
         idx := 1;
         srclen := Length(aSource);
         while idx <= srclen do begin
           aList.Add(Copy(aSource,idx,aFixedLen));
           Inc(idx,aFixedLen);
        end;
      end;

var
    TrimmedHTML:TStringList;
    HTML:string;
    TEXT:string;
    HTMLArray :TStringList;
begin
   AllowPaste := True;
   exit;
   HTML := GetClipboardHTML;
   //HTML := GetClipHTMLText;
   if uTMGOptions.ReadBool('AlterPastedHTML',false)=false then exit;
   if Pos('E-Scribe',HTML)>0 then exit; //escribe already formatted
   if HTML='' then begin
     if Clipboard.HasFormat(CF_TEXT) then begin
       TEXT := Clipboard.AsText;
       TEXT := StringReplace(TEXT, #$D#$A,'<BR>', [rfReplaceAll]);
       //TEXT := StringReplace(TEXT,' ','&nbsp;', [rfReplaceAll]);
       InsertHTMLAtCaret(TEXT);
     //  InsertHTMLAtCaret(Clipboard.AsText);
       AllowPaste := False;
     end;
     exit;
   end;
   HTML := StripOutNonAscii(HTML);
   HTMLArray := TStringList.Create;
   StrToStringList(HTML,HTMLArray,100);
   TrimmedHTML := TStringList.create;
   if uTMGOptions.ReadBool('SavePastedHTMLLocal',false)=True then begin
     TMGLocalBackup(HTMLArray,'PASTE BACKUP-');
   end;
   //HTML := sCallV('TMG CPRS HTML PASTE EVENT',[HTMLArray]);
   tCallV(TrimmedHTML,'TMG CPRS HTML PASTE EVENT',[HTMLArray]);
   InsertHTMLAtCaret(TrimmedHTML.text);
   HTMLArray.free;
   TrimmedHTML.free;
   AllowPaste := False;
end;

procedure THtmlObj.AlignLeft;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.ExecCommand('JustifyLeft',false,0);
  //Modified:=true;   //kt 9/4/15
  SetAsModified;   //kt 9/4/15
end;

procedure THtmlObj.AlignRight;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.ExecCommand('JustifyRight',false,0);
  //Modified:=true;   //kt 9/4/15
  SetAsModified;   //kt 9/4/15
end;

procedure THtmlObj.AlignCenter;
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.ExecCommand('JustifyCenter',false,0);
  //Modified:=true;   //kt 9/4/15
  SetAsModified;   //kt 9/4/15
end;

procedure THtmlObj.TextForeColorDialog;
begin
  if ColorDialog = nil then begin
    ColorDialog := TColorDialog.Create(self);
  end;
  if ColorDialog.Execute then begin
    SetTextForegroundColor(ColorDialog.Color);
  end;  
  //Modified:=true;   //kt 9/4/15
  SetAsModified;  //kt 9/4/15
end;

procedure THtmlObj.TextBackColorDialog;
begin
  if ColorDialog = nil then begin
    ColorDialog := TColorDialog.Create(self);
  end;
  if ColorDialog.Execute then begin
    SetTextBackgroundColor(ColorDialog.Color);
  end;  
  //Modified:=true;   //kt 9/4/15
  SetAsModified;   //kt 9/4/15
end;

procedure THtmlObj.SetTextForegroundColor(Color:TColor);
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.ExecCommand('ForeColor',false,Color);
  //Modified:=true;   //kt 9/4/15
  SetAsModified;   //kt 9/4/15
end;

function THtmlObj.GetTextForegroundColor:TColor;
var Background :  OleVariant;
    vt         :  TVarType;
begin
  Result:=clWindow;
  try
    if DOC=nil then exit;
    if self.GetEditableState = False then exit;
    Background:=DOC.queryCommandValue('ForeColor');
    vt:=varType(Background);
    if vt<>varNull then Result:=Background;
  except
    on E:Exception do EError('Error retrieving foreground color',E);
  end;
end;

procedure THtmlObj.SetTextBackgroundColor(Color:TColor);
begin
  if DOC=nil then exit;
  if self.GetEditableState = False then exit;
  DOC.ExecCommand('BackColor',false,Color);
  //Modified:=true;   //kt 9/4/15
  SetAsModified;   //kt 9/4/15
end;

function THtmlObj.GetTextBackgroundColor:TColor;
var Background :  OleVariant;
    vt         :  TVarType;
begin
  Result:=clWindow;
  try
    if DOC=nil then exit;
    if self.GetEditableState = False then exit;
    Background:=DOC.queryCommandValue('BackColor');
    vt:=varType(Background);
    if vt<>varNull then Result:=Background;
  except
    on E:Exception do EError('Error retrieving background color',E);
  end;
end;

procedure THtmlObj.ZoomIn;
begin
  SetZoom(FZoomValue + FZoomStep);
end;

procedure THtmlObj.ZoomOut;
begin
  SetZoom(FZoomValue - FZoomStep);
end;

procedure THtmlObj.ZoomReset;
begin
  SetZoom(100);
end;

procedure THtmlObj.SetZoomStep(Value : integer);
begin
  if (Value > 0) and (Value < 100) then begin
    FZoomStep := Value;
  end;
end;

procedure THtmlObj.SetZoom(Pct : integer);
var
  pvaIn, pvaOut: OleVariant;
const
  OLECMDID_OPTICAL_ZOOM = $0000003F;
  MinZoom = 10;
  MaxZoom = 1000;
begin
  if Pct = FZoomValue then exit;
  FZoomValue := Pct;
  if FZoomValue < MinZoom then FZoomValue := MinZoom;
  if FZoomValue > MaxZoom then FZoomValue := MaxZoom;
  pvaIn := FZoomValue;
  pvaOut := #0;
  //if not (vmEdit in FViewMode) then begin  //quit if not in edit mode
  Self.ControlInterface.ExecWB(OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, pvaIn, pvaOut);
  //end else begin
  Self.ControlInterface.ExecWB(OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, pvaIn, pvaOut);
  //end;
end;

procedure THtmlObj.FontDialog;
begin
  DoCommand(IDM_FONT);
  //Modified:=true;   //kt 9/4/15
  SetAsModified;   //kt 9/4/15
end;

function THtmlObj.GetFontSize : integer;
var FontSize : OleVariant;
    vt       : TVarType;
    
begin
  FontSize:=Doc.queryCommandValue('FontSize');
  vt:=varType(FontSize);
  if vt<>varNull then Result := FontSize*FontScale
  else Result :=12*FontScale; //kt
end;

procedure THtmlObj.SetFontSize (Size : integer);
begin
  if Doc=nil then exit;
  Doc.ExecCommand('FontSize', false, Size div FontScale);
end;

function THtmlObj.GetFontName : string;
var FontName :OleVariant;
    vt : TVarType;
begin
  if DOC=nil then exit;
  FontName:=DOC.queryCommandValue('FontName');
  vt:=varType(FontName);
  if vt<>varNull then Result := FontName
  else Result :='Times New Roman'; //kt
end;

procedure THtmlObj.SetFontName (Name : string);
begin
  if DOC=nil then exit;
  DOC.ExecCommand('FontName', false, Name);
end;

procedure THtmlObj.LaunchDateInsert;
//kt 12/29/15
begin
  if self.GetEditableState = False then exit;
  if assigned(OnInsertDate) then OnInsertDate(self);
end;


function THtmlObj.SelStart:integer;
var TextRange:IHtmlTxtRange;
begin
  Result:=0;
  TextRange:=GetTextRange;
  if TextRange=nil then exit;
  Result:=Abs(Integer(TextRange.move('character',-MaxTextLength)));
end;

function THtmlObj.SelEnd:integer;
var TextRange:IHtmlTxtRange;
begin
  Result:=0;
  TextRange:=GetTextRange;
  if TextRange=nil then exit;
  Result:=Abs(Integer(TextRange.MoveEnd('character',-MaxTextLength)));
end;

procedure THtmlObj.SetSelectionByPos(StartPos, EndPos : longint); //kt 4/8/21
var ARangeInfo : TRangeInfo;
begin
  ARangeInfo.StartPos := StartPos;
  ARangeInfo.EndPos := EndPos;
  SetSelectionByRangeInfo(ARangeInfo);
end;

procedure THtmlObj.SetSelectionByRangeInfo(ARangeInfo : TRangeInfo); //kt 4/8/21
var ARange : IHtmlTxtRange;
begin
  ARange := CustomRange(ARangeInfo);
  SetSelectionByRange(ARange);
end;

procedure THtmlObj.SetSelectionByRange(ARange : IHtmlTxtRange);
//kt added 4/8/21
var SelRange : IHtmlTxtRange;
begin
  //SelRange := GetTextRange;
  //SelRange.setEndPoint('StartToStart',ARange);
  //SelRange.setEndPoint('EndToEnd',ARange);
  ARange.select;
end;

function THtmlObj.Selection : IHTMLSelectionObject;  //kt 6/16
begin
  if assigned(DOC) then begin
    Result := DOC.selection;
  end else begin
    Result := nil;
  end;
end;

function THtmlObj.SelectionInfo(): TRangeInfo;    //kt 4/8/21
begin
  Result := RangeInfo(GetTextRange);
end;

function THtmlObj.RangeInfo(ARange : IHtmlTxtRange): TRangeInfo;    //kt 4/8/21
//NOTICE: ARange that is passed in will be modified.
begin
  if ARange=nil then begin
    Result.StartPos := 0;
    Result.EndPos := 0;
  end else begin
    Result.StartPos := Abs(Integer(ARange.moveStart('character',-MaxTextLength)));
    Result.EndPos   := Abs(Integer(ARange.moveEnd('character',-MaxTextLength)));
  end;
end;

function THtmlObj.CustomRange(RangeInfo : TRangeInfo) : IHtmlTxtRange;   //kt 4/8/21
//kt added 4/8/21
begin
  Result := CustomRange(RangeInfo.StartPos, RangeInfo.EndPos);
end;

function THtmlObj.CustomRange(StartPos, EndPos : longint) : IHtmlTxtRange;   //kt 4/8/21
//kt added 4/8/21
var Len : integer;
    ARange : IHtmlTxtRange;
begin
  Len := EndPos - StartPos;
  if DOC<> nil then begin
    ARange := DOC.Selection.CreateRange as IHtmlTxtRange;
    ARange.move('word',-MaxTextLength); //collapse Range and move to beginning of document
    ARange.moveStart('character',StartPos);
    ARange.moveEnd('character',Len);
    Result := ARange;
  end else begin
    ARange := Nil;
  end;
end;


procedure THtmlObj.SelCollapse;
//kt added 6/16
var  Sel : IHTMLSelectionObject;
begin
  Sel := Selection;
  if assigned (Sel) then Sel.empty();
end;

function THtmlObj.SelLength:integer;
begin
  Result:=SelEnd-SelStart;
end;


function THtmlObj.GetTextRange:IHtmlTxtRange;
begin
  Result:=nil;
  try
    if DOC=nil then exit;
    while DOC.body=nil do begin
      //WaitLoad(true); //kt
      WaitForDocComplete;
      if DOC.body=nil then begin
        if MessageDlg('Wait for document loading?',mtConfirmation,
                      [mbOK,mbCancel],0) <> mrOK then begin
          exit;
        end;
      end;
    end;
    if (DOC.Selection.type_='Text') or (DOC.Selection.type_='None') then begin
      Result:=DOC.Selection.CreateRange as IHtmlTxtRange;
    end;
  except
    on E:Exception do EError('This type of selection cannot be processed',E);
  end;
end;

function THtmlObj.GetSelText:string;
var TextRange:IHtmlTxtRange;
begin
  Result:='';
  TextRange:=GetTextRange;
  if not assigned(TextRange) then exit;
  Result:=TextRange.text;
end;

procedure THtmlObj.SetSelText (HTMLText : string);
begin
  ReplaceSelection(HTMLText);
   //Keystruck := true;   //kt 9/4/15
  SetAsModified;  //kt 9/4/15
end;

procedure THtmlObj.ReplaceSelection(HTML:string);
var TextRange:IHtmlTxtRange;
begin
  try
    TextRange:=GetTextRange;
    if TextRange=nil then exit;
    TextRange.PasteHTML(HTML);
    //Modified:=true;   //kt 9/4/15
    SetAsModified;   //kt 9/4/15
  except
    on E:Exception do begin
      // implement later... ShortenString(HTML,80);
      EError('Error pasting HTML'+nl+
             'Microsoft HTML refuses to paste this string:'+nl+
             HTML+nl,E);
    end;
  end;
end;


function THtmlObj.MoveCaretToEnd : boolean;
//kt added
var //TextRange:IHtmlTxtRange;
    count : integer;
begin
  if not assigned (FTMGDisplayPointer) then begin
    Result := false;
    exit;
  end;
  Result:=(S_OK = FTMGDisplayPointer.MoveUnit(DISPLAY_MOVEUNIT_BottomOfWindow,0));
  count := 0;
  repeat
    Result:=(S_OK = FTMGDisplayPointer.MoveUnit(DISPLAY_MOVEUNIT_NextLine,-1));
    inc (count);
  until (Result = false) or (count > 500);
  Result:=(S_OK = FTMGDisplayPointer.MoveUnit(DISPLAY_MOVEUNIT_CurrentLineEnd,0));
  Result:=(S_OK = FCaret.MoveCaretToPointer(FTMGDisplayPointer,
                                            integer(FALSE),
                                            CARET_DIRECTION_SAME));
  {
  SendMessage(FmsHTMLwinHandle, WM_KEYDOWN, VK_END, 0);
  SendMessage(FmsHTMLwinHandle, WM_KEYUP, VK_END, 0);
  SendMessage(FmsHTMLwinHandle, WM_KEYDOWN, VK_END, 0);
  SendMessage(FmsHTMLwinHandle, WM_KEYUP, VK_END, 0);
  }

    if not assigned (FTMGDisplayPointer) then begin
    Result := false;
    exit;
  end;
  Result:=(S_OK = FTMGDisplayPointer.MoveUnit(DISPLAY_MOVEUNIT_BottomOfWindow,0));
  count := 0;
  repeat
    Result:=(S_OK = FTMGDisplayPointer.MoveUnit(DISPLAY_MOVEUNIT_NextLine,-1));
    inc (count);
  until (Result = false) or (count > 500);
  Result:=(S_OK = FTMGDisplayPointer.MoveUnit(DISPLAY_MOVEUNIT_CurrentLineEnd,0));
  Result:=(S_OK = FCaret.MoveCaretToPointer(FTMGDisplayPointer,
                                            integer(FALSE),
                                            CARET_DIRECTION_SAME));
  {
  SendMessage(FmsHTMLwinHandle, WM_KEYDOWN, VK_END, 0);
  SendMessage(FmsHTMLwinHandle, WM_KEYUP, VK_END, 0);
  SendMessage(FmsHTMLwinHandle, WM_KEYDOWN, VK_END, 0);
  SendMessage(FmsHTMLwinHandle, WM_KEYUP, VK_END, 0);
  }
end;


function THtmlObj.MoveCaretToPos(ScreenPos: TPoint) : HRESULT;
//kt added entire function
var  OutTemp : DWORD;
begin
  Result := 0;
  if not assigned (FTMGDisplayPointer) then exit;
  FTMGDisplayPointer.moveToPoint(ScreenPos, COORD_SYSTEM_GLOBAL, nil, HT_OPT_AllowAfterEOL, OutTemp);
  Result := FCaret.MoveCaretToPointer(FTMGDisplayPointer,Integer(True),CARET_DIRECTION_INDETERMINATE);
  FCaret.Show(Integer(True));
end;

procedure THtmlObj.InsertHTMLAtCaret(HTMLText : AnsiString);
var
   Range: IHTMLTxtRange;
begin
   Range:= GetTextRange;
   Range.pasteHTML(HTMLText);
end;

procedure THtmlObj.InsertTextAtCaret(Text : AnsiString);
//kt added.  Note: inserts external format (not HTML markup)
var P : PWideChar;
begin
  P := StringToOleStr(Text);
  FCaret.InsertText(P,Length(Text))
end;

function THtmlObj.GetCaretLocation() : TPoint;
//added 6/3/19
begin
  FCaret.GetLocation(result,0);
end;

function THtmlObj.GetScrollLocation: integer;
//var
//ewbDocumentContent: TWebBrowser;
begin
    result := ((self.Document as IHTMLDocument2).body as HTMLBody).scrollTop;
end;

function THtmlObj.FlagsToWord(Flags : THTMLSearchFlags = [hsPartial]) : word;
//kt Added 6/26/16
var AFlag : integer;
begin
  AFlag := 1000000000;
  if hsPartial       in Flags then AFlag := AFlag or $00000;   //b0000000
  if hsReverse       in Flags then AFlag := AFlag or $00001;   //b0000001
  if hsWholeWords    in Flags then AFlag := AFlag or $00002;   //b0000010
  if hsCaseSensitive in Flags then AFlag := AFlag or $00004;   //b0000100
  Result := AFlag;
end;

function THtmlObj.Find(Text : string; Flags : THTMLSearchFlags = [hsPartial]; Mode : TFindMode = fmFirst) : boolean;  //kt 6/16
//kt added 6/16
//From here: https://social.msdn.microsoft.com/Forums/vstudio/en-US/308fa3dc-3bbe-4ff0-9d5d-51cd28e5868d/webbrowser-2005-documentselection?forum=csharpgeneral
var  Sel : IHTMLSelectionObject;
     SelP1, SelP2, SelP3 : integer;
     TextRange : IHTMLTxtRange;
     AFlag : word;
begin
  Result := False;
  if not assigned(DOC) then exit;
  Sel := DOC.selection;
  if not assigned(Sel) then exit;
  If Mode = fmFirst then Sel.empty (); // get an empty selection, so we start from the beginning
  TextRange := IHTMLTxtRange(Sel.createRange());
  if Mode = fmNext then TextRange.collapse (false); // collapse the current selection so we start from the end of the previous range
  if Mode = fmExtendSelToNext then begin
    SelP1 := SelStart;
  end;
  AFlag := FlagsToWord(Flags);
  if (TextRange.findText(Text, AFlag, 0)) then begin
    Result := true;
    TextRange.select ();
    if Mode = fmExtendSelToNext then begin
      SelP3 := SelStart;
      TextRange.moveStart('character', SelP1 - SelP3);
      TextRange.select ();
    end;
  end;
end;

function THtmlObj.FindFirst(Text : string; Flags : THTMLSearchFlags = [hsPartial]) : boolean;
//kt added 6/16
var  Sel : IHTMLSelectionObject;
     TextRange : IHTMLTxtRange;
     AFlag : word;
begin
  Result := Find(Text, Flags, fmFirst);
end;

function THtmlObj.FindNext(Text : string; Flags : THTMLSearchFlags = [hsPartial]) : boolean;
//kt added 6/16
begin
  Result := Find(Text, Flags, fmNext);
end;

function THtmlObj.FindNextExtendingSelection(Text : string; Flags : THTMLSearchFlags = [hsPartial]) : boolean;
//kt added 6/16
begin
  Result := Find(Text, Flags, fmExtendSelToNext);
end;

procedure THtmlObj.Loaded;
begin
  inherited Loaded;
end;

function THtmlObj.GetTextLen : integer;
begin
  Result := Length(GetText);
end;    


procedure THtmlObj.SetMsgActive (Active : boolean); //ReassignKeyboardHandler
//NOTE: This object grabs the OnMessage for the entire application, so that
//      it can intercept the right-click.  As a result, the object needs a
//      way that it can turn off this feature when it is covered up by other
//      windows application subwindows etc.  This function provides this.
begin
  FActive := Active;
  //ReassignKeyboardHandler(FActive);
  if Active then begin
    FApplication.OnMessage := GlobalMsgHandler;
  end else begin
    FApplication.OnMessage := FOrigAppOnMessage;
  end;
end;

{
procedure THtmlObj.ReassignKeyboardHandler(TurnOn : boolean);
//assign HTML keyboard handler to HTML component; restore standard if TurnOn=false
begin
  if TurnOn then begin
    FApplication.OnMessage := GlobalMsgHandler;
  end else begin
    FApplication.OnMessage := FOrigAppOnMessage;
  end;
end;
}

//kt start debugging tools =================
function GetWinControlName(Wnd: HWND): string;
var ACtrl : TWinControl;
begin
  Result := '';
  ACtrl := FindControl(Wnd);
  if not assigned(ACtrl) then exit;
  Result := ACtrl.Name;
end;
//kt end debugging tools =================================


procedure THtmlObj.GlobalMsgHandler(var Msg: TMsg; var Handled: Boolean);
{NOTE: This message handler will receive ALL messages directed to CPRS.  I
       have to do this, because something is filtering messages before they
       get to this THTMLObj object.  My goal is to do as little here as possible,
       and let the OnMessage for THTMLObj (found in EmbeddedED) take care of the rest.
 NOTE2:This should get activated by OnFocus for object, and deactivated
       by OnBlur, so it actually should only get messages when focused.
 NOTE3:I suspect that there is still another handler that is inserting itself
       ahead of this one. For example, if CTRL-M is pressed, it will effect
       tab switching to the medication tab, but it doesn't come through this handler (I think).
 NOTE4:I have added a check so that messages not matching window handler for this
       object are ignored.
 NOTE: 9/18/16.  I have spent a fair amount of time here trying to capture the TAB
       key so that I can prevent it from causing a blur.  I learned that the TAB
       key does not cause an event that comes through this handler.  E.g. if I
       were to type 'CAT<tab>', then the C,A,T would call come through this function,
       but not the <tab> part.  THEREFORE, I think this entire function is useless.
       I would have to research it's use more before removing it, but I think
       it was just for capturing the tab key.  Tab key being turned into 5 spaces
       used to work, but now doesn't, and I can't figure out why!
       ALSO, when I would type in C,A,T, the message would come here, but they
       would have a Msg.hwnd that was not TMGHandle.  I don't know why.
       }
var
  NewMsg : TMessage;
  Debugging : boolean;
  s : string;

  function TransformMessage (WinMsg : TMsg) : TMessage;
  begin
    Result.Msg := WinMsg.message;
    Result.WParam := WinMsg.wParam;
    Result.LParam := WinMsg.lParam;
    Result.Result := 0;
  end;

begin
  //---debugging tool-----------------
  Debugging := false;
  if Debugging=true then begin
    s := GetWinControlName(Msg.hwnd);
  end;
  //---end debugging tool -----------------
  Handled:=false; //default to not handled
  if Msg.hwnd <> TMGHandle then exit;  //8/3/16
  if SuspendKeyProcessing then exit;  //kt 10/2014
  if (Msg.Message=WM_KEYDOWN) then begin
    if (Msg.WParam=VK_UP) or (Msg.WParam=VK_DOWN) or (Msg.WParam=VK_TAB) then begin
      NewMsg := TransformMessage(Msg);
      SubMessageHandler(NewMsg);
      Handled := (NewMsg.Result = 1);
    end;
  end;
end;

procedure THtmlObj.SubMessageHandler(var Msg: TMessage);
//Called from parent's TEmbeddedED.EDMessageHandler, or from GlobalMsgHandler

const
  FontSizes : array [0..6] of byte = (8,10,12,14,18,24,36);

var  i : Integer;
     //WinControl : TWinControl;
     TextSize : integer;
     AllowPaste : boolean;

begin
  Msg.Result := 0; //default to not handled
  if assigned(WinMessageLog) then begin  //kt added block 8/16
    WinMessageLog.SaveMsg(Msg);
  end;
  if not ((Msg.Msg=WM_KEYDOWN) or
          (Msg.Msg=WM_KEYUP) or
          (Msg.Msg=WM_COMMAND) or  //kt added 8/16
          (Msg.Msg=WM_LBUTTONUP) or  //tmg 5/23/22
          (Msg.Msg=WM_RBUTTONUP) ) then exit;  //Speedy exit of non-handled messages
  case Msg.Msg of
    WM_RBUTTONUP : begin
                     if CtrlToBeProcessed then begin
                       CtrlToBeProcessed := false;
                       exit; //Ctrl-right click is ignored
                     end;
                     if assigned(PopupMenu) then PopupMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
                     Msg.Result := 1; //Handled
                     exit;
                   end;
    WM_LBUTTONUP : begin
                     if Assigned(OnClick) then OnClick(self);
                   end;
    WM_KEYDOWN :   begin
                     GetSystemTimeAsFileTime(KeyPressTime);
                     //KeyStruck := true;   //kt 9/4/15
                     SetAsModified;   //kt 9/4/15
                     case Msg.WParam of
                       VK_ESCAPE  : begin
                                      if Assigned(PrevControl) then begin
                                        AllowNextBlur := true;
                                        PrevControl.SetFocus;
                                      end;
                                    end;
                       VK_CONTROL : begin
                                      CtrlToBeProcessed:=true;
                                      LocalTimer.Interval := 3000; //after 3 seconds, force off -- somtimes get stuck ON otherwise.
                                      LocalTimer.Enabled := true;
                                      LocalTimerAction := LocalTimerAction + [ltFreeCtrl];
                                      Msg.Result := 1; //Handled
                                      exit;
                                    end;
                       VK_SHIFT :   begin
                                      ShiftToBeProcessed:=true;
                                      Msg.Result := 1; //Handled
                                      exit;
                                    end;
                       VK_TAB :     begin
                                      if (ShiftToBeProcessed and CtrlToBeProcessed) then begin
                                        //This isn't working for some reason...
                                        for i := 0 to 5 do begin
                                          PostMessage(FmsHTMLwinHandle, WM_KEYDOWN, VK_LEFT, 0);
                                        end;
                                        ShiftToBeProcessed := false;
                                        CtrlToBeProcessed := false;
                                      end else if ShiftToBeProcessed then begin
                                        if Assigned(PrevControl) then begin
                                          AllowNextBlur := true;
                                          PrevControl.SetFocus;
                                        end;
                                        ShiftToBeProcessed := false;
                                      end else if CtrlToBeProcessed then begin
                                        if Assigned(NextControl) then begin
                                          AllowNextBlur := true;
                                          NextControl.SetFocus;
                                        end;
                                        CtrltoBeProcessed := false;
                                      end else begin
                                        for i := 0 to 5 do begin
                                          PostMessage(FmsHTMLwinHandle, WM_KEYDOWN, VK_SPACE, 0);
                                        end;
                                      end;
                                      Msg.Result := 1; //Handled
                                    end;
                       else {case} begin
                         if CtrlToBeProcessed = true then begin
                           case Msg.WParam of
                              $31..$38 :      begin
                                                TextSize := Msg.WParam-$31;
                                                if (TextSize >= 0) and (TextSize <=6 ) then begin
                                                  SetFontSize(FontSizes[TextSize]);
                                                  CtrlToBeProcessed := False;
                                                end;
                                              end;
                                   {
                                   VK_RETURN :  if CtrlReturnToBeProcessed then begin
                                                  Msg.Result := 1; //Handled
                                                  CtrlReturnToBeProcessed := false;
                                                end else if CtrlToBeProcessed then begin
                                                  Msg.Result := 1; //Handled
                                                  CtrlToBeProcessed := False;
                                                  CtrlReturnToBeProcessed := true;
                                                  //PostMessage(Msg.hwnd, WM_KEYUP, VK_CONTROL, 0);
                                                end else if ShiftToBeProcessed=false then begin
                                                  //kt if not FEditable then exit;
                                                  keybd_event(VK_SHIFT,0,0,0);
                                                  keybd_event(VK_RETURN,0,0,0);
                                                  keybd_event(VK_SHIFT,0,KEYEVENTF_KEYUP,0);
                                                  Msg.Result := 1; //Handled
                                                end;
                                   }
                                   Ord('B') :  begin
                                                 //kt if not FEditable then exit;
                                                 ToggleBold;
                                                 Msg.Result := 1; //Handled
                                                 CtrlToBeProcessed:=false;  //kt 10/2014
                                                 exit;
                                               end;
                                   Ord('U') :  begin
                                                 //kt if not FEditable then exit;
                                                 ToggleUnderline;
                                                 Msg.Result := 1; //Handled
                                                 CtrlToBeProcessed:=false;  //kt 10/2014
                                                 exit;
                                               end;
                                   Ord('I') :  begin
                                                 //kt if not FEditable then exit;
                                                 ToggleItalic;
                                                 CtrlToBeProcessed:=false;  //kt 10/2014
                                                 Msg.Result := 1; //Handled
                                               end;
                                   Ord('Q') :  begin
                                                 //kt if not FEditable then exit;
                                                 Outdent;
                                                 Msg.Result := 1; //Handled
                                                 CtrlToBeProcessed:=false;  //kt 10/2014
                                                 exit;
                                               end;
                                               {
                                   Ord('V') :  begin
                                                 Paste;
                                                 Msg.Result := 1; //Handled
                                                 CtrlToBeProcessed:=false;  //kt 10/2014
                                                 exit;
                                               end;
                                               }
                                   Ord('W') :  begin
                                                 //kt if not FEditable then exit;
                                                 Indent;
                                                 Msg.Result := 1; //Handled
                                                 CtrlToBeProcessed:=false;  //kt 10/2014
                                                 exit;
                                               end;
                                   Ord('D') :  begin
                                                 //kt if not FEditable then exit;
                                                 FontDialog;
                                                 Msg.Result := 1; //Handled
                                                 exit;
                                               end;
                                   VK_OEM_2 :  begin   //kt 10/2014
                                                  //VK_OEM_2 -- For the US standard keyboard, the '/?' key
                                                  //            Used for miscellaneous characters; it can vary by keyboard.
                                                  //            http://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
                                                 try
                                                   SuspendKeyProcessing := true;
                                                   if ShiftToBeProcessed=true then begin
                                                      if Assigned(OnLaunchDialogSearch) then OnLaunchDialogSearch(self);
                                                      ShiftToBeProcessed := False;
                                                   end else begin
                                                      if Assigned(OnLaunchTemplateSearch) then OnLaunchTemplateSearch(self);
                                                   end;
                                                 finally
                                                   Msg.Result := 1; //Handled
                                                   SuspendKeyProcessing := false;
                                                   CtrlToBeProcessed :=false;
                                                   //self.SetFocus;  //doesn't work... why?
                                                   LocalTimer.Interval := 500; //after 1 second, force off -- somtimes get stuck ON otherwise.
                                                   LocalTimer.Enabled := true;
                                                   LocalTimerAction := LocalTimerAction + [ltSetFocus];
                                                 end;
                                                 exit;
                                               end;
                              VK_OEM_PERIOD :  begin
                                                 try
                                                   SuspendKeyProcessing := true;
                                                   if Assigned(OnLaunchConsole) then OnLaunchConsole(self);
                                                 finally
                                                   Msg.Result := 1; //Handled
                                                   SuspendKeyProcessing := false;
                                                   CtrlToBeProcessed :=false;
                                                   LocalTimer.Interval := 500; //after 1 second, force off -- somtimes get stuck ON otherwise.
                                                   LocalTimer.Enabled := true;
                                                   LocalTimerAction := LocalTimerAction + [ltSetFocus];
                                                 end;
                                                 exit;
                                               end;
                                               {
                                   Ord('N') :  begin
                                                 //kt if not FEditable then exit;
                                                 ToggleNumbering;
                                                 Msg.Result := 1; //Handled
                                                 exit;
                                               end;
                                               }
                                   VK_OEM_3 :  begin  //VK_OEM_3 = 192 = `
                                                 //kt if not FEditable then exit;
                                                 LaunchDateInsert;
                                                 //TextForeColorDialog;
                                                 Msg.Result := 1; //Handled
                                                 exit;
                                               end;
                                               {
                                   Ord('''') :  begin
                                                 //kt if not FEditable then exit;
                                                 TextBackColorDialog;
                                                 Msg.Result := 1; //Handled
                                                 exit;
                                               end;
                                                }
                           end; //case
                         end; //if CtrlToBeProcessed = true
                       end; //else case
                     end; //case
                   end;  //WM_KEYDOWN
    WM_KEYUP :     begin
                     case Msg.WParam of
                       VK_DELETE  : begin
                                      //KeyStruck := true;   //kt 9/4/15
                                      SetAsModified;   //kt 9/4/15
                                      exit;
                                    end;
                       VK_BACK    : begin
                                      //KeyStruck := true;   //kt 9/4/15
                                      SetAsModified;   //kt 9/4/15
                                      exit;
                                    end;
                       VK_CONTROL : begin
                                      CtrlToBeProcessed:=false;
                                      Msg.Result := 1; //Handled
                                      if CtrlReturnToBeProcessed then begin
                                        PostMessage(FmsHTMLwinHandle, WM_KEYDOWN, VK_RETURN, 0);
                                      end;
                                      exit;
                                    end;
                       VK_SHIFT :   begin
                                      ShiftToBeProcessed:=false;
                                      Msg.Result := 1; //Handled
                                      exit;
                                   end;

                     end; //case
                     exit;
                   end; //WM_KEYUP
    WM_COMMAND :   begin
                    if Msg.WParamHi = 1 then begin  //1 means accelerator key
                       if Msg.WParamLo = 26 then begin //26 happens with Ctrl-V / paste
                         AllowPaste := true;
                         Msg.Result := 0;  //0 = default is not handled, so passed to WebBrowser for action
                         if assigned(FOnPasteEvent) then begin
                           FOnPasteEvent(Self, AllowPaste); //subscriber of this even can modify the clipboard if they want
                           if not AllowPaste then Msg.Result := 1; //1 = 'Handled' --> not given to WebBrowser --> so paste is blocked
                         end;
                       end;
                     end;
                   end; //WM_COMMAND
  end;  {case}
end;

procedure THtmlObj.HandleBlur(Sender: TObject);
//kt added function
  function RecentKeyPressed : boolean;
  var NowTime : FILETIME; //kt
      KeyTime,NowTime2 : LARGE_INTEGER;
      Delta : int64;
  begin
    GetSystemTimeAsFileTime(NowTime);
    NowTime2.LowPart := NowTime.dwLowDateTime;
    NowTime2.HighPart := NowTime.dwHighDateTime;
    KeyTime.LowPart := KeyPressTime.dwLowDateTime;
    KeyTime.HighPart := KeyPressTime.dwHighDateTime;
    Delta := floor( (NowTime2.QuadPart - KeyTime.QuadPart) / 100000);
    Result := (Delta < 100) and (Delta > 0);
  end;

begin
  //kt Handle loss of focus when attempting to cursor above top line, or below bottom line.
  if (not AllowNextBlur) and RecentKeyPressed then begin   //kt entire block
    SetFocusToDoc;
    //beep(880,100);
    KeyPressTime.dwLowDateTime := 0;
    KeyPressTime.dwHighDateTime := 0;
    exit;
  end;
  AllowNextBlur := false;
  SetMsgActive(false);
end;

function THtmlObj.SubFocusHandler(fGotFocus: BOOL): HResult;
begin
  SetMsgActive(fGotFocus);
end;

function THtmlObj.GetActive : boolean;
begin
  Result := TWinControl(Owner).Visible;
end;

procedure THtmlObj.SetAsModified;
//kt 9/5/15
begin
  Modified :=true;
  KeyStruck := true;
  if Assigned(OnModified) then OnModified(Self);
end;


function ClassesNameContainsClass(ClassesName : string; AClass : string) : boolean;
begin
  Result := false;
  if Pos(' ', ClassesName)>0 then begin  //ClassName has multiple classes
    if (Pos(' '+AClass+' ', ClassesName)>0) or
       LeftMatches(ClassesName, AClass+' ', false) or
       RightMatches(ClassesName, ' '+AClass, false) then begin
      Result := true;
    end;
  end else begin
    Result := SameText(ClassesName, AClass);  //not case sensitive.
  end;
end;

procedure LocalGetElementsArrayById(const Doc: IDispatch; const Id: string; OutList : TInterfaceList; OneOnly : boolean);
//NOTE: OutList will be filled with IHTMLElement objects.  The list will NOT own them.
//Modified from....
//from Peter Johnson, posted here http://delphidabbler.com/tips/56 as free code
var
  Document:  IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  Body:      IHTMLElement2;          // document body element
  Elements:  IHTMLElementCollection; // all tags in document body
  AElement:  IHTMLElement;           // a tag in document body
  I:         Integer;                // loops thru Elements in document body
begin
  OutList.Clear;
  // Check for valid document: require IHTMLDocument2 interface to it
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  // Check for valid body element: require IHTMLElement2 interface to it
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  Elements := Body.getElementsByTagName('*');    // Get all tags in body element ('*' => any tag name)
  for I := 0 to Elements.length - 1 do begin   // Scan through all Elements in body
    AElement := Elements.item(I, EmptyParam) as IHTMLElement;  // Get reference to a tag
    // Check tag's id and add it to output if id matches
    if AnsiSameText(AElement.id, Id) then begin
      OutList.Add(AElement);
      If OneOnly then Break;
    end;
  end;
end;

function THtmlObj.GetElementById(const Id: string): IHTMLElement;
var
  AList : TInterfaceList;
begin
  Result := nil;
  AList := TInterfaceList.Create;
  try
    LocalGetElementsArrayById(Doc, Id, AList, True);  //true = get first item only
    if AList.Count > 0 then Result := IHTMLElement(AList[0]);
  finally
    AList.Free;
  end;
end;

procedure THtmlObj.GetElementsArrayById(const Id: string; OutList : TInterfaceList);
//NOTE: OutList will be filled with IHTMLElement objects.  The list will NOT own them.
begin
  LocalGetElementsArrayById(DOC, Id, OutList, false); //false means get all objects.
end;

procedure THtmlObj.HandleGetByClassCallback (Elem : IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean);
begin
  //see if element has class matching MSG, if so, add to OutList.
  if ClassesNameContainsClass(Elem.className, Msg) then begin
    TInterfaceList(Obj).Add(Elem);
  end;
end;

procedure THtmlObj.HandleGetOneByClassCallback (Elem : IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean);
begin
  //see if element has class matching MSG, if so, add to OutList.
  if ClassesNameContainsClass(Elem.className, Msg) then begin
    TInterfaceList(Obj).Add(Elem);
    Stop := true; //this will cause search to stop after first match found.
  end;
end;

procedure THtmlObj.GetElementsArrayByClass(const AClass: string; OutList : TInterfaceList);
//NOTE: OutList will be filled with IHTMLElement objects.  The list will NOT own them.
begin
  if not assigned(OutList) then exit;
  IterateElements(HandleGetByClassCallback, AClass, OutList);
end;

function THtmlObj.GetElementByClass(const AClass: string): IHTMLElement;
var AList : TInterfaceList;
begin
  Result := nil;
  AList := TInterfaceList.Create;
  IterateElements(HandleGetOneByClassCallback, AClass, AList);
  if AList.Count > 0 then Result := IHTMLElement(AList[0]);   //get first element only.
  AList.Free;
end;

procedure THtmlObj.HandleGetByTagNameCallback (Elem : IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean);
//Msg is the UPPER CASE of desired tag name
begin
  //see if element has class matching MSG, if so, add to OutList.
  if UpperCase(Elem.tagName) = Msg then begin
    TInterfaceList(Obj).Add(Elem);
    Stop := true; //this will cause search to stop after first match found.
  end;
end;


procedure THtmlObj.HandleGetOneByTagNameCallback (Elem : IHTMLElement; Msg : string; Obj :TObject; var Stop : boolean);
//Msg is the UPPER CASE of desired tag name
begin
  //see if element has TagName matching MSG, if so, add to OutList.
  if UpperCase(Elem.tagName) = Msg then begin
    TInterfaceList(Obj).Add(Elem);
    Stop := true; //this will cause search to stop after first match found.
  end;
end;

procedure THtmlObj.GetElementsArrayByTagName(TagName: string; OutList : TInterfaceList);
//NOTE: OutList will be filled with IHTMLElement objects.  The list will NOT own them.
begin
  TagName := UpperCase(TagName);
  if not assigned(OutList) then exit;
  IterateElements(HandleGetByTagNameCallback, TagName, OutList);
end;

function THtmlObj.GetElementByTagName(TagName: string): IHTMLElement;
var AList : TInterfaceList;
begin
  TagName := UpperCase(TagName);
  Result := nil;
  AList := TInterfaceList.Create;
  IterateElements(HandleGetOneByTagNameCallback, Tagname, AList);
  if AList.Count > 0 then Result := IHTMLElement(AList[0]);   //get first element only.
  AList.Free;
end;


procedure THtmlObj.IterateElements(CallBack : TIterateCallbackProc; Msg : string; Obj : TObject);
//Modified from....
//from Peter Johnson, posted here http://delphidabbler.com/tips/56 as free code
var
  Document:  IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  Body:      IHTMLElement2;          // document body element
  Elements:  IHTMLElementCollection; // all tags in document body
  AElement:  IHTMLElement;           // a tag in document body
  I:         Integer;                // loops thru Elements in document body
  Stop : boolean;
begin
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  if not assigned(Callback) then exit;
  Elements := Body.getElementsByTagName('*');
  Stop := false;
  for I := 0 to Pred(Elements.length) do begin
    AElement := Elements.item(I, EmptyParam) as IHTMLElement;
    CallBack(AElement, Msg, Obj, Stop);
    if Stop then break;
  end;
end;


function THtmlObj.SearchElements(CheckMatch : TIterateCallbackProc; Msg : string; Obj : TObject) : IHTMLElement;
//Modified from....
//from Peter Johnson, posted here http://delphidabbler.com/tips/56 as free code
var
  Document:  IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  Body:      IHTMLElement2;          // document body element
  Elements:  IHTMLElementCollection; // all tags in document body
  AElement:  IHTMLElement;           // a tag in document body
  I:         Integer;                // loops thru Elements in document body
  Match : boolean;
begin
  Result := nil;
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  if not assigned(CheckMatch) then exit;
  Elements := Body.getElementsByTagName('*');
  for I := 0 to Pred(Elements.length) do begin
    AElement := Elements.item(I, EmptyParam) as IHTMLElement;
    CheckMatch(AElement, Msg, Obj, Match);
    if Match then begin
      result := AElement;
      break;
    end;
  end;
end;

function THtmlObj.AppendBodyNode(TagName : string; Id : string; InnerHTML : string) : IHtmlElement;
//From here: http://stackoverflow.com/questions/27091639/adding-a-script-element-to-an-existing-twebbrowser-document
var
  Node:      IHtmlElement;
  Document:  IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  Body:      IHTMLElement2;          // document body element
begin
  Result := nil;
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  Node := Document.createElement(TagName);
  Node.setAttribute('id', Id, 0);  //0= not case sensitive
  Node.innerHTML := InnerHTML;
  (Body as IHtmlDomNode).appendChild(Node as IHtmlDOMNode);
  Result := Node;
end;

procedure THtmlObj.SetInnerHTMLByID(Id : string; Content : string);
var AElement : IHTMLElement;
    TempV : variant;
begin
  AElement := GetElementById(Id);
  if not assigned(AElement) then exit;
  TempV := Content;
  try
    AElement.innerHTML := TempV;
  except
    on E : Exception do begin
      ShowMessage('Exception class name = '+E.ClassName);
      ShowMessage('Exception message = '+E.Message);
    end;
  end;
end;


function THtmlObj.GetDocHead: IHTMLElement;
//Return pointer to <HEAD> block, creating this if it was not already present.
var
  Document:    IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  Elements:    IHTMLElementCollection; // all tags in document body
  AElement:    IHTMLElement;           // a tag in document body
  Body:        IHTMLElement2;          // document body element
  Head:        IHTMLElement;
  I:           Integer;                // loops thru Elements in document body
begin
  Result := nil;
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  Elements := Document.all;
  for I := 0 to Pred(Elements.length) do begin
    AElement := Elements.item(I, EmptyParam) as IHTMLElement;
    if UpperCase(AElement.tagName) <> 'HEAD' then continue;
    Result := AElement;
    break;
  end;
  if not assigned(Result) then begin
    Head := Document.CreateElement('HEAD');
    (Body as IHTMLDOMNode).insertBefore(Head as IHTMLDOMNode, Body as IHTMLDOMNode);
    //now look for it again
    Elements := Document.all;
    for I := 0 to Pred(Elements.length) do begin
      AElement := Elements.item(I, EmptyParam) as IHTMLElement;
      if UpperCase(AElement.tagName) <> 'HEAD' then continue;
      Result := AElement;
      break;
    end;
  end;
end;

function THtmlObj.GetDocBody: IHTMLElement;
var
  Document:  IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  Body:      IHTMLElement;          // document body element
begin
  Result := nil;
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  Result := Body;
end;

function THtmlObj.GetDocStyleElement: IHTMLElement;
//Return pointer to <STYLE> block, returning nil if not found.
var
  Document:    IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  Elements:    IHTMLElementCollection; // all tags in document body
  AElement:    IHTMLElement;           // a tag in document body
  I:           Integer;                // loops thru Elements in document body
begin
  Result := nil;
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  Elements := Document.all;
  for I := 0 to Pred(Elements.length) do begin
    AElement := Elements.item(I, EmptyParam) as IHTMLElement;
    if UpperCase(AElement.tagName) <> 'STYLE' then continue;
    result := AElement;
    break;
  end;
end;

procedure THtmlObj.CSSTextToHumanReadable(SelectorText, CSSText : string; OutSL : TStrings);
var TempSL : TStringList;
    i : integer;
begin
  TempSL := TStringList.Create;
  ORFn.PiecesToList(CSSText, ';', TempSL);
  OutSL.Add(SelectorText + ' {');
  for i := 0 to TempSL.Count - 1 do begin
    OutSL.Add(' ' + TempSL.Strings[i]);
  end;
  OutSL.Add('}');
  OutSL.Add(' ');
  TempSL.Free;
end;


function THtmlObj.RuleStyleToCSSText(Style: IHTMLRuleStyle) : string;

var s : string;
    B : WordBool;
    I : integer;
    F : single;
    CSSText : String;

  procedure AddIfValue(Value, LabelStr : string);
  begin
    if Value = '' then exit;
    CSSText := CSSText + LabelStr + ': ' + Value + '; ';
  end;
  procedure AddIfTrue(Value : WordBool; LabelStr : string);
  begin
    if Value = false then exit;
    CSSText := CSSText + LabelStr + ': ' + BoolToStr(Value) + '; ';
  end;

  procedure AddIfNotZeroInt(Value : integer; LabelStr : string);
  begin
    if Value = 0 then exit;
    CSSText := CSSText + LabelStr + ': ' + IntToStr(Value) + '; ';
  end;

  procedure AddIfNotZeroFloat(Value : Single; LabelStr : string);
  begin
    if Value = 0 then exit;
    CSSText := CSSText + LabelStr + ': ' + FloatToStr(Value) + '; ';
  end;

var
  Style2 : IHTMLRuleStyle2;
  Style3 : IHTMLRuleStyle3;
  Style4 : IHTMLRuleStyle4;

begin
  CSSText := '';
  S := Style.fontFamily;                AddIfValue(s, 'fontFamily');
  S := Style.fontStyle;                 AddIfValue(s, 'fontStyle');
  S := Style.fontVariant;               AddIfValue(s, 'fontVariant');
  S := Style.fontVariant;               AddIfValue(s, 'fontVariant');
  S := Style.fontSize;                  AddIfValue(s, 'fontSize');
  S := Style.font;                      AddIfValue(s, 'font');
  S := Style.color;                     AddIfValue(s, 'color');
  S := Style.background;                AddIfValue(s, 'background');
  S := Style.backgroundColor;           AddIfValue(s, 'backgroundColor');
  S := Style.backgroundImage;           AddIfValue(s, 'backgroundImage');
  S := Style.backgroundRepeat;          AddIfValue(s, 'backgroundRepeat');
  S := Style.backgroundAttachment;      AddIfValue(s, 'backgroundAttachment');
  S := Style.backgroundPosition;        AddIfValue(s, 'backgroundPosition');
  S := Style.backgroundPositionX;       AddIfValue(s, 'backgroundPositionX');
  S := Style.backgroundPositionY;       AddIfValue(s, 'backgroundPositionY');
  S := Style.wordSpacing;               AddIfValue(s, 'wordSpacing');
  S := Style.letterSpacing;             AddIfValue(s, 'letterSpacing');
  S := Style.textDecoration;            AddIfValue(s, 'textDecoration');
  B := Style.textDecorationNone;        AddIfTrue (B, 'textDecorationNone');
  B := Style.textDecorationUnderline;   AddIfTrue (B, 'textDecorationUnderline');
  B := Style.textDecorationOverline;    AddIfTrue (B, 'textDecorationOverline');
  B := Style.textDecorationLineThrough; AddIfTrue (B, 'textDecorationLineThrough');
  B := Style.textDecorationBlink;       AddIfTrue (B, 'textDecorationBlink');
  S := Style.verticalAlign;             AddIfValue(s, 'verticalAlign');
  S := Style.textTransform;             AddIfValue(s, 'textTransform');
  S := Style.textAlign;                 AddIfValue(s, 'textAlign');
  S := Style.textIndent;                AddIfValue(s, 'textIndent');
  S := Style.lineHeight;                AddIfValue(s, 'lineHeight');
  S := Style.marginTop;                 AddIfValue(s, 'marginTop');
  S := Style.marginRight;               AddIfValue(s, 'marginRight');
  S := Style.marginBottom;              AddIfValue(s, 'marginBottom');
  S := Style.marginLeft;                AddIfValue(s, 'marginLeft');
  S := Style.margin;                    AddIfValue(s, 'margin');
  S := Style.paddingTop;                AddIfValue(s, 'paddingTop');
  S := Style.paddingRight;              AddIfValue(s, 'paddingRight');
  S := Style.paddingBottom;             AddIfValue(s, 'paddingBottom');
  S := Style.paddingLeft;               AddIfValue(s, 'paddingLeft');
  S := Style.padding;                   AddIfValue(s, 'padding');
  S := Style.border;                    AddIfValue(s, 'border');
  S := Style.borderTop;                 AddIfValue(s, 'borderTop');
  S := Style.borderRight;               AddIfValue(s, 'borderRight');
  S := Style.borderBottom;              AddIfValue(s, 'borderBottom');
  S := Style.borderLeft;                AddIfValue(s, 'borderLeft');
  S := Style.borderColor;               AddIfValue(s, 'borderColor');
  S := Style.borderTopColor;            AddIfValue(s, 'borderTopColor');
  S := Style.borderRightColor;          AddIfValue(s, 'borderRightColor');
  S := Style.borderBottomColor;         AddIfValue(s, 'borderBottomColor');
  S := Style.borderLeftColor;           AddIfValue(s, 'borderLeftColor');
  S := Style.borderWidth;               AddIfValue(s, 'borderWidth');
  S := Style.borderTopWidth;            AddIfValue(s, 'borderTopWidth');
  S := Style.borderRightWidth;          AddIfValue(s, 'borderRightWidth');
  S := Style.borderBottomWidth;         AddIfValue(s, 'borderBottomWidth');
  S := Style.borderLeftWidth;           AddIfValue(s, 'borderLeftWidth');
  S := Style.borderStyle;               AddIfValue(s, 'borderStyle');
  S := Style.borderTopStyle;            AddIfValue(s, 'borderTopStyle');
  S := Style.borderRightStyle;          AddIfValue(s, 'borderRightStyle');
  S := Style.borderBottomStyle;         AddIfValue(s, 'borderBottomStyle');
  S := Style.borderLeftStyle;           AddIfValue(s, 'borderLeftStyle');
  S := Style.width;                     AddIfValue(s, 'width');
  S := Style.height;                    AddIfValue(s, 'height');
  S := Style.styleFloat;                AddIfValue(s, 'styleFloat');
  S := Style.clear;                     AddIfValue(s, 'clear');
  S := Style.display;                   AddIfValue(s, 'display');
  S := Style.visibility;                AddIfValue(s, 'visibility');
  S := Style.listStyleType;             AddIfValue(s, 'listStyleType');
  S := Style.listStylePosition;         AddIfValue(s, 'listStylePosition');
  S := Style.listStyleImage;            AddIfValue(s, 'listStyleImage');
  S := Style.listStyle;                 AddIfValue(s, 'listStyle');
  S := Style.whiteSpace;                AddIfValue(s, 'whiteSpace');
  S := Style.top;                       AddIfValue(s, 'top');
  S := Style.left;                      AddIfValue(s, 'left');
  S := Style.position;                  AddIfValue(s, 'position');
  //S := Style.zIndex;                    AddIfValue(s, 'zIndex');
  S := Style.overflow;                  AddIfValue(s, 'overflow');
  S := Style.pageBreakBefore;           AddIfValue(s, 'pageBreakBefore');
  S := Style.pageBreakAfter;            AddIfValue(s, 'pageBreakAfter');
  S := Style.cssText;                   AddIfValue(s, 'cssText');
  S := Style.cursor;                    AddIfValue(s, 'cursor');
  S := Style.clip;                      AddIfValue(s, 'clip');
  S := Style.filter;                    AddIfValue(s, 'filter');

  if Supports(Style, IHTMLDocument2, Style2) then begin
    s := Style2.tableLayout;              AddIfValue(s, 'tableLayout');
    s := Style2.borderCollapse;           AddIfValue(s, 'borderCollapse');
    s := Style2.direction;                AddIfValue(s, 'direction');
    s := Style2.behavior;                 AddIfValue(s, 'behavior');
    s := Style2.position;                 AddIfValue(s, 'position');
    s := Style2.unicodeBidi;              AddIfValue(s, 'unicodeBidi');
    //property bottom: OleVariant read Get_bottom write Set_bottom;
   //property right: OleVariant read Get_right write Set_right;
    s := Style2.unicodeBidi;              AddIfValue(s, 'unicodeBidi');
    I := Style2.pixelBottom;              AddIfNotZeroInt(I, 'pixelBottom');
    I := Style2.pixelRight;               AddIfNotZeroInt(I, 'pixelRight');
    F := Style2.posBottom;                AddIfNotZeroFloat(F, 'posBottom');
    F := Style2.posRight;                 AddIfNotZeroFloat(F, 'posRight');
    s := Style2.imeMode;                  AddIfValue(s, 'imeMode');
    s := Style2.rubyAlign;                AddIfValue(s, 'rubyAlign');
    s := Style2.rubyPosition;             AddIfValue(s, 'rubyPosition');
    s := Style2.rubyOverhang;             AddIfValue(s, 'rubyOverhang');
    //property layoutGridChar: OleVariant read Get_layoutGridChar write Set_layoutGridChar;
    //property layoutGridLine: OleVariant read Get_layoutGridLine write Set_layoutGridLine;
    s := Style2.layoutGridMode;           AddIfValue(s, 'layoutGridMode');
    s := Style2.layoutGridType;           AddIfValue(s, 'layoutGridType');
    s := Style2.layoutGrid;               AddIfValue(s, 'layoutGrid');
    s := Style2.textAutospace;            AddIfValue(s, 'textAutospace');
    s := Style2.wordBreak;                AddIfValue(s, 'wordBreak');
    s := Style2.lineBreak;                AddIfValue(s, 'lineBreak');
    s := Style2.textJustify;              AddIfValue(s, 'textJustify');
    s := Style2.textJustifyTrim;          AddIfValue(s, 'textJustifyTrim');
    //property textKashida: OleVariant read Get_textKashida write Set_textKashida;
    s := Style2.overflowX;                AddIfValue(s, 'overflowX');
    s := Style2.overflowY;                AddIfValue(s, 'overflowY');
    s := Style2.accelerator;              AddIfValue(s, 'accelerator');
  end;
  if Supports(Style, IHTMLDocument3, Style3) then begin
    s := Style3.layoutFlow;               AddIfValue(s, 'layoutFlow');
    //property zoom: OleVariant read Get_zoom write Set_zoom;
    s := Style3.wordWrap;                 AddIfValue(s, 'wordWrap');
    s := Style3.textUnderlinePosition;    AddIfValue(s, 'textUnderlinePosition');
    //property scrollbarBaseColor:
    //property scrollbarFaceColor:
    //property scrollbar3dLightColor:
    //property scrollbarShadowColor:
    //property scrollbarHighlightColor:
    //property scrollbarDarkShadowColor:
    //property scrollbarArrowColor:
    //property scrollbarTrackColor:
    s := Style3.writingMode;              AddIfValue(s, 'writingMode');
    s := Style3.textAlignLast;            AddIfValue(s, 'textAlignLast');
    //property textKashidaSpace:
  end;
  if Supports(Style, IHTMLDocument4, Style4) then begin
    s := Style4.textOverflow;             AddIfValue(s, 'textOverflow');
    s := Style4.minHeight;                AddIfValue(s, 'minHeight');
  end;
  Result := CSSText;
end; //RuleStyleToCSSText


procedure THtmlObj.GetDocStyles(SelectorSL, CSSLineSL : TStringList);
//NOTE: This will create output with a 1:1 correlation between SelectorSL and CSSLineSL
//  The first SL will contain the selector text
//  the second SL will contain all the CSS in one line (divided by ";"'s)
//From here: http://delphidabbler.com/tips/58
var SheetIdx:        Integer;                     // loops thru style sheets
    OVSheetIdx:      OleVariant;                  // index of a style sheet
    StyleSheets:     IHTMLStyleSheetsCollection;  // document's style sheets
    StyleSheet:      IHTMLStyleSheet;             // reference to a style sheet
    Rules:           IHTMLStyleSheetRulesCollection;
    Rule:            IHTMLStyleSheetRule;
    Document:        IHTMLDocument2;              // IHTMLDocument2 interface of Doc
    OVStyleSheet:    OleVariant;                  // variant ref to style sheet
    RuleIdx:         Integer;                     // loops thru style sheet rules
    SelectorText, CSSText : string;

begin
  if not Supports(Doc, IHTMLDocument2, Document) then begin
    raise Exception.Create('Invalid HTML document');
  end;
  SelectorSL.Clear; CSSLineSL.Clear;
  StyleSheets := Document.styleSheets;
  if assigned (StyleSheets) then for SheetIdx := 0 to Document.StyleSheets.length - 1 do begin
    OVSheetIdx := SheetIdx; // sheet index as variant required for next call
    //Get reference to style sheet (comes as variant which we convert to interface reference)
    OVStyleSheet := StyleSheets.item(OVSheetIdx);
    if VarSupports(OVStyleSheet, IHTMLStyleSheet, StyleSheet) then begin
      // Loop through all rules within style a sheet
      Rules := StyleSheet.rules;
      for RuleIdx := 0 to Rules.length - 1 do begin
        Rule := Rules.item(RuleIdx);
        SelectorText :=  Rule.SelectorText;
        //Note: Rule.style is IHTMLRuleStyle, not IHTMLStyle, although many attributes are shared between these interfaces
        CSSText := RuleStyleToCSSText(Rule.style);
        SelectorSL.Add(SelectorText);  //added 1:1
        CSSLineSL.Add(CSSText);        //added 1:1
      end;
    end;
  end;
end; //GetDocStyles


procedure THtmlObj.GetDocStyles(HumanReadableSL : TStrings);
var
  SelectorSL, CSSLineSL : TStringList;
  SelectorText, CSSText : string;
  i : integer;
begin
  SelectorSL := TStringList.Create;
  CSSLineSL := TStringList.Create;
  try
    GetDocStyles(SelectorSL, CSSLineSL);
    for i:= 0 to SelectorSL.Count - 1 do begin
      SelectorText := SelectorSL.Strings[i]; //1:1
      CSSText := CSSLineSL.Strings[i];  //1:1
      CSSTextToHumanReadable(SelectorText, CSSText, HumanReadableSL);
    end;
  finally
    SelectorSL.Free;  CSSLineSL.Free;
  end;
end;


procedure THtmlObj.AddStylesToExistingStyleSheet(StyleSheet: IHTMLStyleSheet; SelectorSL, CSSLineSL : TStringList);
//NOTE: There must be a 1:1 correlation between SelectorSL and CSSLineSL
//  The first SL will contain the selector text
//  the second SL will contain all the CSS in one line (divided by ";"'s)
var
  SLIdx, RuleIdx, p: integer;
  SelectorText, CSSText, OneCSSEntry : string;
begin
  if not assigned(StyleSheet) then begin
    raise Exception.Create('Invalid StyleSheet');
  end;
  for SLIdx := 0 to SelectorSL.Count - 1 do begin
    SelectorText := SelectorSL.Strings[SLIdx];
    if SlIdx > (CSSLineSL.Count - 1) then break;
    CSSText := CSSLineSL.Strings[SLIdx];
    {
    while CSSText <> '' do begin
      p := Pos(';', CSSText);
      if p > 0 then begin
        OneCSSEntry := MidStr(CSSText, 1, p);
        CSSText := Trim(MidStr(CSSText, p+1, Length(CSSText)));
      end else begin
        OneCSSEntry := CSSText;
        CSSText := '';
      end;
      RuleIdx := StyleSheet.Rules.length;
      StyleSheet.addRule(SelectorText, OneCSSEntry, RuleIdx);
    end;
    }
    RuleIdx := StyleSheet.Rules.length;
    StyleSheet.addRule(SelectorText, CSSText, RuleIdx);
  end;
end;

function THtmlObj.GetFirstDocStyleSheet: IHTMLStyleSheet;
//Return first stylesheet, creating one if it didn't already exist.
var
  Document:      IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  StyleSheets:   IHTMLStyleSheetsCollection;  // document's style sheets
  StyleSheet:    IHTMLStyleSheet;        // reference to a style sheet
  OVStyleSheet:  OleVariant;                  // variant ref to style sheet
  Idx:           integer;
begin
  Result := nil;
  if not Supports(Doc, IHTMLDocument2, Document) then begin
    raise Exception.Create('Invalid HTML document');
  end;
  StyleSheets := Document.styleSheets;
  if StyleSheets.length > 0 then begin
    OVStyleSheet := StyleSheets.item(0);
  end else begin
    Idx := Document.StyleSheets.length;
    OVStyleSheet := Document.createStyleSheet('', Idx);
  end;
  if not VarSupports(OVStyleSheet, IHTMLStyleSheet, StyleSheet) then begin
    raise Exception.Create('Unable to create valid style sheet');
  end;
  Result := StyleSheet;
end;



function THtmlObj.AddStyles(SelectorSL, CSSLineSL : TStringList) : IHTMLStyleSheet;
//NOTE: There must be a 1:1 correlation between SelectorSL and CSSLineSL
//  The first SL will contain the selector text
//  the second SL will contain all the CSS in one line (divided by ";"'s)
var
  Document:      IHTMLDocument2;              // IHTMLDocument2 interface of Doc
  StyleSheets:   IHTMLStyleSheetsCollection;  // document's style sheets
  StyleSheet:    IHTMLStyleSheet;             // reference to a style sheet
  OVStyleSheet:  OleVariant;                  // variant ref to style sheet
  Idx:           integer;
begin
  Result := nil;
  if not Supports(Doc, IHTMLDocument2, Document) then begin
    raise Exception.Create('Invalid HTML document');
  end;
  StyleSheets := Document.styleSheets;
  Idx := Document.StyleSheets.length;
  OVStyleSheet := Document.createStyleSheet('',Idx);
  if not VarSupports(OVStyleSheet, IHTMLStyleSheet, StyleSheet) then begin
    raise Exception.Create('Unable to create valid style sheet');
  end;
  Result := StyleSheet;
  AddStylesToExistingStyleSheet(StyleSheet, SelectorSL, CSSLineSL);
end; //AddStyles


procedure THtmlObj.ConvertHumanReadableStylesToSL(InSL, SelectorSL, CSSLineSL : TStringList);
var p,i : integer;
    s : string;
    SelectorText, CSSText : string;
begin
  SelectorText := '';
  CSSText := '';
  for i := 0 to InSL.Count - 1 do begin
    s := trim(InSL.Strings[i]);
    s := StringReplace(s, '<style>', '', [rfIgnoreCase]);
    s := StringReplace(s, '</style>', '', [rfIgnoreCase]);
    if (length(s) > 2) and (s[1] = '/') and (s[2] = '/') then s := '';  //ignore comments.
    while s <> '' do begin
      p := Pos('{', s);
      if p > 0 then begin
        s := StringReplace(s, '{', '', [rfIgnoreCase]);
      end;
      if SelectorText = '' then begin
        SelectorText := Trim(s);
        s := '';
      end;
      if s <> '' then begin
        p := Pos('}', s);
        s := StringReplace(s, '}', '', [rfIgnoreCase]);
        CSSText := CSSText + Trim(s) + ' ';
        s := '';
        if p > 0 then begin
          SelectorSL.Add(SelectorText); CSSLineSL.Add(CSSText);
          SelectorText := '';
          CSSText := '';
        end;
      end;
    end;
  end;
end;


procedure THtmlObj.EnsureStyles(HumanReadableStyleCodes : TStringList);
(* Example of expected format of input TStringList;
    .TMGContainer {
      border-style: none;
      border-style: solid;
      border-width: 1px;
      border-color: lightgrey;
      margin-left: 15px;
    }
    .TMGDisabledContainer {
      background-color : lightgrey;
      border-style : solid;
      border-width: 1px;
      border-color: black;
      padding: 5px;
      color : grey;
    }
    .TMGDisabledControl {
      color : grey;
    }                                                 *)
var SelectorSLInBrowser, CSSLineSLInBrowser : TStringList;
    SelectorSL,          CSSLineSL :          TStringList;
    SelectorSLToAdd,     CSSLineSLToAdd :     TStringList;
    StyleSheet:                               IHTMLStyleSheet;
    i:                                        integer;
    SelectorText, CSSText :                   string;
begin //EnsureStyles
  try
    SelectorSL := TStringList.Create;
    CSSLineSL := TStringList.Create;
    SelectorSLInBrowser := TStringList.Create;
    CSSLineSLInBrowser := TStringList.Create;
    SelectorSLToAdd := TStringList.Create;
    CSSLineSLToAdd := TStringList.Create;

    ConvertHumanReadableStylesToSL(HumanReadableStyleCodes,SelectorSL, CSSLineSL);
    GetDocStyles(SelectorSLInBrowser, CSSLineSLInBrowser);
    for i := 0 to SelectorSL.Count - 1 do begin
      SelectorText := SelectorSL.Strings[i];
      if SelectorSLInBrowser.IndexOf(SelectorText) > -1 then continue;
      CSSText := CSSLineSL.Strings[i];  //set up 1:1 with SelectorSL
      SelectorSLToAdd.Add(SelectorText); CSSLineSLToAdd.Add(CSSText);
    end;
    if SelectorSLToAdd.Count > 0 then begin
      StyleSheet := GetFirstDocStyleSheet;
      AddStylesToExistingStyleSheet(StyleSheet, SelectorSLToAdd, CSSLineSLToAdd);
    end;
  finally
    SelectorSL.Free;            CSSLineSL.Free;
    SelectorSLInBrowser.Free;   CSSLineSLInBrowser.Free;
    SelectorSLToAdd.Free;       CSSLineSLToAdd.Free;
  end;
end; //EnsureStyles


function THtmlObj.GetDocScriptElement: IHTMLElement;
//Return pointer to **first instance of** <SCRIPT> block, creating this if it was not already present.
var
  Document:     IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  Body:         IHTMLElement2;          // document body element
  Script:       IHTMLElement;           //
  Elements:     IHTMLElementCollection; // all tags in document body
  AElement:     IHTMLElement;           // a tag in document body
  I:            Integer;                // loops thru Elements in document body
begin
  Result := nil;
  if not Supports(Doc, IHTMLDocument2, Document) then
    raise Exception.Create('Invalid HTML document');
  if not Supports(Document.body, IHTMLElement2, Body) then
    raise Exception.Create('Can''t find <body> element');
  Elements := Body.getElementsByTagName('*');
  for I := 0 to Pred(Elements.length) do begin
    AElement := Elements.item(I, EmptyParam) as IHTMLElement;
    if UpperCase(AElement.tagName) <> 'SCRIPT' then continue;
    Result := AElement;
  end;
  if not assigned(Result) then begin
    Script := Document.CreateElement('SCRIPT');
    (Body as IHTMLDOMNode).AppendChild(Script as IHTMLDOMNode);
    Result := Script;
  end;
end;

procedure THtmlObj.GetDocScripts(JavaScriptSL : TStrings);
var
  Document:     IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  Scripts:      IHTMLElementCollection;
  OVScript:     OleVariant;
  Script:       IHTMLScriptElement;
  p,I:          Integer;
  s, PartA:     string;
begin
  if not Supports(Doc, IHTMLDocument2, Document) then begin
    raise Exception.Create('Invalid HTML document');
  end;
  Scripts := Document.scripts;
  for I := 0 to Scripts.length - 1 do begin
    OVScript := Scripts.item(I, EmptyParam);
    if not VarSupports(OVScript, IHTMLScriptElement, Script) then continue;
    s := Script.text;
    while s <> '' do begin
      p := Pos(CRLF, s);
      if p > 0 then begin
        PartA := MidStr(s, 1, p-1);
        s := MidStr(s, p+2, Length(s));
        JavaScriptSL.Add(PartA);
      end else begin
        JavaScriptSL.Add(s);
        s := '';
      end;
    end;
    JavaScriptSL.Add(' ');
  end;
end;

procedure THtmlObj.SetDocScripts(JavaScriptSL : TStrings; Append : boolean = false);
//Set **FIRST** <SCRIPT> element to have text replaced by JavaScriptSL.Text
var
  Document:     IHTMLDocument2;         // IHTMLDocument2 interface of Doc
  Scripts:      IHTMLElementCollection;
  OVScript:     OleVariant;
  Script:       IHTMLScriptElement;
  ScriptNode:   IHTMLElement;
  I:            Integer;
  Found:        boolean;
  JS:           String;
begin
//function THtmlObj.GetDocScriptElement: IHTMLElement;
  Found := false;
  if not Supports(Doc, IHTMLDocument2, Document) then begin
    raise Exception.Create('Invalid HTML document');
  end;
  JS := JavaScriptSL.Text;
  Scripts := Document.scripts;
  for I := 0 to Scripts.length - 1 do begin
    OVScript := Scripts.item(I, EmptyParam);
    if not VarSupports(OVScript, IHTMLScriptElement, Script) then continue;
    if append then JS := Script.text + JS;
    Script.text := JS;
    Found := true;
    break;
  end;
  if not Found then begin
    ScriptNode := GetDocScriptElement;
    if not Supports(ScriptNode, IHTMLScriptElement, Script) then begin
      raise Exception.Create('Invalid Script Element');
    end;
    Script.text := JS;
  end;
end;

procedure THtmlObj.GetDocScriptSummary(OutSL : TStrings);
var SL : TStringList;
    s : string;
    i : integer;
begin
  SL := TStringList.Create;
  try
    GetDocScripts(SL);
    SummarizeScript(SL, OutSL);
  finally
    SL.Free;
  end;
end;

procedure THtmlObj.EnsureScripts(JavaScriptSL : TStrings);
var JSSummary, CurrentJSSummary, JSToAdd : TStringList;
    s : string;
    i : integer;

  procedure TrimComments(SL : TStrings);
  var i, p : integer;
      s : string;
  begin
    for i := 0 to SL.Count - 1 do begin
      s := SL.Strings[i];
      p := Pos('//', s);  //NOTICE!!  This doesn't check if the "comment" is actually inside a string...
      if p = 0 then continue;
      SL.Strings[i] := Trim(MidStr(s, 1, p-1));
    end;
  end;

begin
  JSSummary := TStringList.Create;
  CurrentJSSummary := TStringList.Create;
  JSToAdd := TStringList.Create;
  try
    GetDocScriptSummary(CurrentJSSummary);
    JSToAdd.Assign(JavaScriptSL);
    TrimComments(JSToAdd);
    SummarizeScript(JavaScriptSL, JSSummary);
    for i := 0 to JSSummary.Count - 1 do begin
      s := JSSummary.Strings[i];
      if CurrentJSSummary.IndexOf(s) = -1 then continue;
      TrimFunction(JSToAdd, 'function ' + s);
    end;
    JSToAdd.Insert(0,' ');
    SetDocScripts(JSToAdd, True);  // append scripts into DOM
  finally
    JSSummary.Free;
    CurrentJSSummary.Free;
    JSToAdd.Free;
  end;
end;

procedure THtmlObj.PostKeyEx32(key: Word; const shift: TShiftState; specialkey: Boolean);
type
  TShiftKeyInfo = record
    shift: Byte;
    vkey: Byte;
  end;
  ByteSet = set of 0..7;
const
  shiftkeys: array [1..3] of TShiftKeyInfo = (
    (shift: Ord(ssCtrl) ; vkey: VK_CONTROL),
    (shift: Ord(ssShift) ; vkey: VK_SHIFT),
    (shift: Ord(ssAlt) ; vkey: VK_MENU)
  );
var
  flag: DWORD;
  bShift: ByteSet absolute shift;
  j: Integer;
begin
  for j := 1 to 3 do
  begin
    if shiftkeys[j].shift in bShift then
      keybd_event(
        shiftkeys[j].vkey, MapVirtualKey(shiftkeys[j].vkey, 0), 0, 0
    );
  end;
  if specialkey then
    flag := KEYEVENTF_EXTENDEDKEY
  else
    flag := 0;

  keybd_event(key, MapvirtualKey(key, 0), flag, 0);
  flag := flag or KEYEVENTF_KEYUP;
  keybd_event(key, MapvirtualKey(key, 0), flag, 0);

  for j := 3 downto 1 do
  begin
    if shiftkeys[j].shift in bShift then
      keybd_event(
        shiftkeys[j].vkey,
        MapVirtualKey(shiftkeys[j].vkey, 0),
        KEYEVENTF_KEYUP,
        0
      );
  end;
end;

procedure THtmlObj.SendKeys(key: Word; const shift: TShiftState; specialkey: Boolean);
begin
  PostKeyEx32(key, shift, specialkey);
end;

//===========================================================================

function HTMLElement_PropertyValue(Elem : IHTMLElement; PropertyName : string) : string;
var OleResult : OleVariant;
begin
  OleResult := Elem.getAttribute(PropertyName, 1); //1 means case-insensitive
  if not VarIsNull(OleResult) then begin
    Result := OleResult;
  end else begin
    Result := '';
  end;
end;

function HTMLElement_HasClassName(Elem : IHTMLElement; AClassName : string) : boolean;
// use Elem.className
var Str : string;
    p : integer;
    SL : TStringList;
begin
  Result := false;
  Str := Elem.className;
  p := Pos(AClassName, Str);
  if p = 0 then exit;
  Result := true;
  if length(AClassName) = length(Str) then exit; //still true
  //Check to ensure that AClassName is not part of a larger or longer classname
  SL := TStringList.Create;
  try
    ORFn.PiecesToList(Str, ' ', SL);
    p := SL.IndexOf(AClassName);
    Result := (p > -1);
  finally
    SL.Free;
  end;
end;

procedure HTMLElement_EnsureHasClassName(Elem : IHTMLElement; AClassName : string);
var Str : string;
    i, p : integer;
    SL : TStringList;
begin
  Str := Elem.className;
  SL := TStringList.Create;
  try
    if Pos(' ', Str) > 0 then begin
      ORFn.PiecesToList(Str, ' ', SL);
    end else begin
      SL.Add(Str);
    end;
    i := SL.IndexOf(AClassName);
    if i <> -1 then exit;  //Classname already present
    SL.Add(AClassname);
    Str := '';
    for i := 0 to SL.Count - 1 do begin
      if Str <> '' then Str := Str + ' ';
      Str := Str + SL[i];
    end;
    Elem.className := Str;
  finally
    SL.Free;
  end;
end;

procedure HTMLElement_RemoveClassName(Elem : IHTMLElement; AClassName : string);
// use Elem.className
var Str : string;
    i, p : integer;
    SL : TStringList;
begin
  Str := Elem.className;
  p := Pos(AClassName, Str);
  if p = 0 then exit;
  SL := TStringList.Create;
  try
    ORFn.PiecesToList(Str, ' ', SL);
    i := SL.IndexOf(AClassName);
    if i = -1 then exit;
    SL.Delete(i);
    Str := '';
    for i := 0 to SL.Count - 1 do begin
      if Str <> '' then Str := Str + ' ';
      Str := Str + SL[i];
    end;
    Elem.className := Str;
  finally
    SL.Free;
  end;
end;


initialization

finalization

end.

