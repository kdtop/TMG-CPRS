unit uHTMLTools;
//kt 9/11 Added entire unit.
//kt 9/11 NAME CHANGED rHTMLTools --> uHTMLTools

 (*
 Copyright 6/23/2015 Kevin S. Toppenberg, MD
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

interface

  uses Windows, SysUtils, Classes, Printers, ComCtrls, ExtCtrls,
       Controls, StdCtrls, StrUtils, MSHTML, ActiveX, Variants,
       ShDocVw, {//kt added ShDocVw 5-2-05 for TWebBrowser access}
       Dialogs,
       Forms,
       Clipbrd, //10/7/22
       Registry, {elh   6/19/09}
       ORFn;    {//kt for RedrawActivate}

  var
    DesiredHTMLFontSize : byte;
    CPRSDir : string;
    CPRSCacheDir : string;
    URL_CPRSDir : string;  //This is CPRSDir, but all '\'s are converted to '/'s

  CONST
    CPRS_DIR_SIGNAL = '$CPRSDIR$';
    CPRS_GRAPH_REFRESH_ATTR = 'tmg_needs_refresh';
    CPRS_GRAPH_REFRESH_SIGNAL = CPRS_GRAPH_REFRESH_ATTR+'="1"';
    CACHE_DIR = '\Cache\';
    CACHE_DIR_ALT = '/Cache/';
    CPRS_CACHE_DIR_SIGNAL = CPRS_DIR_SIGNAL+CACHE_DIR;
    //NOTE: ALT_IMG_TAG_CONVERT is a signal that the <IMG > tag contains an local filesystem path, that needs to be converted before saving to server.
    ALT_IMG_TAG_CONVERT = 'tmg_alt="convert to ' + CPRS_DIR_SIGNAL +'"';
    //kt ALT_IMG_TAG_PLACEHOLDER = 'tmg_alt="holder"';  //kt 8/19/21
    NO_BR_TAG = '<NO-BR>';     //was '{{NO-BR}}'  //
    NO_BR_TAG2 = '{{NO-BR}}';
    NOBR_TAG = '<NOBR>';     //was '{{NOBR}}'   // <-- Allow user to enter alternate spellings.
    NOBR_TAG2 = '{{NOBR}}';
    NO_SPC_BR_TAG = '<NO BR>'; //was '{{NO BR}}'//
    NO_SPC_BR_TAG2 = '{{NO BR}}'; //was '{{NO BR}}'//
    EMBEDDED_TEMPLATE_START_TAG = '{TMPL:';
    EMBEDDED_TEMPLATE_END_TAG = '}';

  type
    TFileType = (tftPDF, tftImage);

  procedure PrintHTMLReport(Lines: TStringList; var ErrMsg: string;
                            PtName, DOB, VisitDate, Location:string; Application : TApplication);  //kt added 5-2-05
  function  IsHTML(Lines : TStrings): boolean;
  function  TextIsHTML(Line : String): boolean;
  function  HasHTMLTags(Text: string) : boolean;
  procedure EditSL(Lines : TStrings);
  procedure FixHTML(Lines : TStrings);
  function  FixHTMLCRLF(Text : String) : string;
  function  FixNoBRs(Text : string) : string;
  procedure SplitHTMLToArray (HTMLText: string; Lines : TStrings; MaxLineLen: integer = 80);
  procedure WrapLongHTMLLines(Lines : TStrings; MaxLineLen: integer = 255; LineBreakStr : string = NO_BR_TAG);
  procedure StripBeforeAfterHTML(Lines,OutBefore,OutAfter : TStrings);
  procedure MakeBlankHTMLDoc(Lines : TStrings);
  function  BlankHTMLDoc : string;
  function  UnwrapHTML(HTMLText : string) : string;
  function  WrapHTML(HTMLText : string) : string;
//  function  WaitForBrowserOK(MaxSecDelay: integer; Application : TApplication) : boolean;
  function  CheckForImageLink(Lines: TStrings; ImageList : TStringList) : boolean;
  function  ConvertSpacesAndChars2HTML(Text : String) : string;
  function  ConvertSpaces2HTML(Text : String) : string;
  function  Text2HTML(Lines : TStrings; EnsureDoc : boolean = true) : String; overload;
  function  Text2HTML(text : string; EnsureDoc : boolean = true) : String;    overload;
  procedure EnsureHTMLStructure(Lines : TStrings);
  function  ProtectTag(text, TagName : string) : string;
  function  UnProtectTag(text, TagName : string) : string;
  function  HTMLContainsVisibleItems(const x: string): Boolean;
  function  HTMLContainsImages(const x: string): Boolean;  //kt 5/15
  procedure SetRegHTMLFontSize(Size: byte);
  procedure RestoreRegHTMLFontSize;
  procedure SetupHTMLPrinting(Name,DOB,VisitDate,Location,Institution : string);
  procedure RestoreIEPrinting;
  function  ExtractDateOfNote(Lines : TStringList) : string;
  Procedure ScanForSubs(Lines : TStrings); overload;
  procedure ScanForSubs(var Text : string); overload;
  Procedure InsertSubs(Lines : TStrings);
  function  HTTPEncode(const AStr: string): string;
  function  EncodeTextToSafeHTMLAttribVal(Text : string) : string;
  function  RestoreTextFromEncodedSafeHTMLAttribVal(Text : string) : string;
  procedure ResolveEmbeddedTemplates(Drawers : TObject);  //must by of type TfrmDrawers
  function  HTMLEncode(const Data: string; var Modified : boolean): string; overload;
  procedure HTMLEncode(const SL : TStringList); overload;
  function  HTMLDecode(const AStr: String): String;
  procedure MakeWrapperHTMLFile(FullFilePathName, TargetSaveFilePathName : string; Parent:TControl; FileType: TFileType);
  function  UniqueCacheFName(FName : string) : AnsiString;
  function GetClipboardHTML:string;
  function GetClipHTMLText:string;

  procedure StripTags(var S : string);
  procedure StripQuotes(SL : TStrings; QtChar: char);
  procedure StripBetweenChars(SL : TStrings; OpenChar, CloseChar : char; StartPos: integer = 1; NumToDel : integer = MaxInt); overload;
  procedure StripBetweenChars(var s : string; OpenChar, CloseChar : char; StartPos: integer = 1; NumToDel : integer = MaxInt); overload;
  procedure StripBraces(SL : TStrings; StartPos: integer = 1; NumToDel : integer = MaxInt); overload;
  procedure StripBraces(var s : string; StartPos: integer = 1; NumToDel : integer = MaxInt); overload;
  procedure StripBetweenTags(SL : TStrings; OpenTag, CloseTag : string; StartLineIdx : Word = 0; Count : Word = 9999);
  procedure TrimFunction(SL : TStrings; FnStr : string);
  procedure SummarizeScript(InSL, OutSL : TStrings);
  procedure StripJavaScript(SL: TStrings; var Modified : boolean);
  function GetWebBrowserHTML(const WebBrowser: TWebBrowser): String;
  procedure WBLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string);
  function GetTag(HTMLText : string; TagName : string; var PartA, PartB : string; AttributesSL : TStringList) : string;

  function FormatHTMLClipboardHeader(HTMLText: string): string;
  procedure CopyHTMLToClipBoard(const str: AnsiString; const htmlStr: AnsiString = '');

  function StripHTMLTags(strHTML: string): string;
  function HTMLResize(ImageFName: string) : string;
  function GetInsertImgHTMLName(Name: string; PropSL : TStringList = nil): string;
  function SelectExistingImageClick() : string;
  function Make2ColHTMLTable(SourceSL : TStringList; Options : TStringList=nil) : string;


implementation

  uses fNotes,
       fImages,
       Messages,
       TMGHTML2,  //kt moved from interface 8/16
       Graphics, //For color constants
       fGraphs,  //for RefreshGraph
       fImagePickExisting,
       fTMGPrintingAnimation,
       fMemoEdit,
       fDrawers,
       uTemplateFields,
       uImages,
       fTemplateDialog;

  type
    TPrinterEvents = class
    public
      SavedDefaultPrinter : string;
      LastChosenPrinterName : string;
      RestorePrinterTimer : TTimer;
      PrintingNow : boolean;
      procedure HandleRestorePrinting (Sender: TObject);
      Constructor Create;
      Destructor Destroy; override;
    end;


  var
    PrinterEvents : TPrinterEvents;
    SubsFoundList : TStringList;

  const CRLF = #$0D#$0A;
        ProtectionMarkerOpen = '{@{';
        ProtectionMarkerClose = '}@}';


  function GetCurrentPrinterName : string;
   //var ResStr: array[0..255] of Char;
  begin
  //GetProfileString('Windows', 'device', '', ResStr, 255);
  //Result := StrPas(ResStr);
    if (Printer.PrinterIndex > 0)then begin
      Result := Printer.Printers[Printer.PrinterIndex];
    end else begin
      Result := '';
    end;
  end;

  procedure SetDefaultPrinter(PrinterName: String) ;
  var
      j                    : Integer;
      Device, Driver, Port : PChar;
      HdeviceMode          : THandle;
      aPrinter             : TPrinter;
  begin    
     Printer.PrinterIndex := -1;
     getmem(Device, 255) ;
     getmem(Driver, 255) ;
     getmem(Port, 255) ;
     aPrinter := TPrinter.create;
     j := Printer.Printers.IndexOf(PrinterName);
     if j >= 0 then begin
       aprinter.printerindex := j;
       aPrinter.getprinter(device, driver, port, HdeviceMode) ;
       StrCat(Device, ',') ;
       StrCat(Device, Driver ) ;
       StrCat(Device, Port ) ;
       WriteProfileString('windows', 'device', Device) ;
       StrCopy( Device, 'windows' ) ;
       //SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, Longint(@Device)) ;
     end;
     Freemem(Device, 255) ;
     Freemem(Driver, 255) ;
     Freemem(Port, 255) ;
     aPrinter.Free;
  end;


  procedure Wait(Sec : byte; Application : TApplication);
  var   StartTime : TDateTime; 
  const OneSec = 0.000012;
  begin
    StartTime := GetTime; 
    repeat
      Application.ProcessMessages;
    until (GetTime-StartTime) > (OneSec*Sec);
  end;

  
  procedure PrintHTMLReport(Lines: TStringList; var ErrMsg: string;
                            PtName, DOB, VisitDate, Location:string;
                            Application : TApplication);
  //      Web browser printing options:
  //        OLECMDEXECOPT_DODEFAULT       Use the default behavior, whether prompting the user for input or not.
  //        OLECMDEXECOPT_PROMPTUSER      Execute the command after obtaining user input.
  //        OLECMDEXECOPT_DONTPROMPTUSER  Execute the command without prompting the user.

  {Notice:  When IE is asked to print, it immediately returns from the function,
           but the printing has not yet occured.  If UI is requested, then the
          printing will not start until after the user selects a printer and
         presses [OK].  I could not find any reliable way to determine when the
        print job had been created.  I had to know this event because I need to
       restore some IE settings AFTER the printing has finished.  I even tried to
      get the active windows and see if it was a print dialog.  But IE print dlg
     apparently is owned by another thread than CPRS, because GetActiveWindow would
     not bring back a handle to the printer dialog window.  I therefore told IE
     to print WITHOUT asking which printer via UI.  In that case it prints to the
     system wide default printer.  So I have to set the default printer to the
     user's choice, and then change it back again.  This is bit of a kludge,
     but I couldn't figure out any other way after hours of trial and error.
     NOTE: I tried to query IE to see if it was able to print, thinking that it
     would return NO if in the process of currently printing.  It didn't work, 
     and would return OK immediately.      
     
     ADDENDUM:  I was getting errors and inconsistent behavior with this, so I
       have decided to try to let the user click a button when the printer has
       been selected.                                         }    

  var
    UseUI          : OleVariant;
    //NewPrinterName : string;
    //dlgWinPrinter  : TPrintDialog;
  begin
    //if PrinterEvents.RestorePrinterTimer.Enabled = false then begin
    //  PrinterEvents.SavedDefaultPrinter := GetCurrentPrinterName;
    //end;
    if PrinterEvents.PrintingNow then exit; // prevent double printing (it has happened)
    try
      frmTMGPrinting := TfrmTMGPrinting.Create(nil);
      ScanForSubs(Lines);    //Added to correct Printing issue  elh
      frmNotes.SetDisplayToHTMLvsText([vmView,vmHTML],Lines);  //ActivateHtmlViewer(Lines);
      if frmNotes.HtmlViewer.WaitForDocComplete = false then begin
        ErrMsg := 'The web browser timed out trying to set up document.';
        exit;
      end;
      PrinterEvents.PrintingNow := true;
      SetupHTMLPrinting(PtName,DOB,VisitDate,Location,' ');  {elh 6/19/09} //kt
      frmNotes.HtmlViewer.PrintFinished := false;
      UseUI := true;
      frmNotes.HtmlViewer.PrintDocument(UseUI);   //Returns immediately, not after printing done.
      frmTMGPrinting.ShowModal;    // Let user show when print job has been launched.
      PrinterEvents.RestorePrinterTimer.Enabled := true; //launch a restore event in 30 seconds
      //RestoreIEPrinting;  //elh - This was omitted from below. Not sure why.  11/10/09
    finally
      PrinterEvents.PrintingNow := false;
      FreeAndNil(frmTMGPrinting);
    end;
  end;

  function GetClipboardHTML:string;
  var
    CF_HTML: Word;
    Data: THandle;
    Ptr: Pointer;
    Error: DWord;
    Size: NativeUInt;
    utf8: UTF8String;
  begin
     result := '';
     CF_HTML := RegisterClipboardFormat('HTML Format');
     Clipboard.Open;
     try
       Data := Clipboard.GetAsHandle(CF_HTML);
       if Data=0 then begin
         //something here
         Exit;
       end;

       Ptr := GlobalLock(Data);
       if not Assigned(Ptr) then begin
         Error := GetLastError;
         Writeln('GlobalLock failed: '+SysErrorMessage(Error));
         Exit;
       end;
       try
          Size := GlobalSize(Data);
          if Size=0 then begin
            Error := GetLastError;
            Writeln('GlobalLock failed: '+SysErrorMessage(Error));
            Exit;
          end;
          SetString(utf8, PAnsiChar(Ptr), Size-1);
          result := string(utf8);
          //HTMLArray := TStringList.Create;
          //HTMLArray.Text := HTML;
         // StrToStringList(HTML,HTMLArray,100);
       finally
         GlobalUnlock(Data);
       end;
     finally
       Clipboard.Close;
     end;
  end;

  function GetClipHTMLText:string;
  //kt added entire function 8/16
  //from: http://www.delphibasics.info/home/delphibasicssnippets/operateclipboardwithoutclipboardunit
  var hData:  DWORD;
      pData:  Pointer;
      dwSize: DWORD;
  begin
    Result := '';
    //original if OpenClipBoard(0) <> 0 then begin
    if OpenClipBoard(0) then begin
      try
        hData := GetClipBoardData(CF_HTML);
        if hData <> 0 then begin
          pData := GlobalLock(hData);
          if pData <> nil then begin
            dwSize := GlobalSize(hData);
            if dwSize <> 0 then begin
              SetLength(result, dwSize);
              CopyMemory(@result[1], pData, dwSize);
            end;
            GlobalUnlock(DWORD(pData));
          end;
        end;
      finally
        CloseClipBoard;
      end;
    end else begin
      result:='';
    end;
  end;


  (*
  function WaitForBrowserOK(MaxSecDelay: integer; Application : TApplication) : boolean;
  //Returns TRUE if can print
  var
    StartTime : TDateTime;
    Status: OLECMDF;
    MaxDelay,ElapsedTime : Double;
    CanPrint : boolean;
  const
    OneMin = 0.0007;  //note: 0.0007 is about 1 minute
  begin
    StartTime := GetTime;
    MaxDelay := OneMin * MaxSecDelay;
    repeat
      Status := frmNotes.HtmlViewer.QueryStatusWB(OLECMDID_PRINT);  //"can you print?" -- get print command status
      CanPrint := (Status and OLECMDF_ENABLED) > 0;
      ElapsedTime := GetTime-StartTime;
      Application.ProcessMessages;
    until (ElapsedTime > MaxDelay) or CanPrint or frmNotes.HtmlViewer.PrintFinished;
    Result := CanPrint;
  end;
  *)

  procedure ScanForSubs(var Text : string); overload;
  var  Lines : TStringList;
  begin
    Lines := TStringList.Create;
    Lines.Text := Text;
    ScanForSubs(Lines);
    Text := Lines.Text;
    Lines.Free;
  end;


  Procedure ScanForSubs(Lines : TStrings);  overload; //Scan for substitutions
  //Purpose: To scan note for constant $CPRS$ and replace with CPRS's actual directory
  var i,p,p2 : integer;
      tempS : String;
      RefreshSuccess : boolean;
      RefreshGraphCount : integer;
  begin
    RefreshGraphCount := 0;
    SubsFoundList.Clear;
    for i := 0 to Lines.Count-1 do begin
      if Pos(CPRS_GRAPH_REFRESH_SIGNAL,Lines[i])>0 then begin
         Lines[i] := RefreshGraph(Lines[i], RefreshSuccess);
         if RefreshSuccess then inc(RefreshGraphCount);
      end;
      if (Pos('src="file:',Lines[i])>0) AND (Pos('file:///',Lines[i])=0) then begin
        Lines[i] := AnsiReplaceStr(Lines[i],'file:','file:///');
      end;
      p := Pos(CPRS_DIR_SIGNAL, Lines[i]);
      if p>0 then begin
        p := p + Length(CPRS_DIR_SIGNAL);  //kt 8/19/21
        p2 := PosEx('"',Lines[i],p);
        tempS := MidStr(Lines[i],p,(p2-p));
        p := Pos(CACHE_DIR, tempS);
        if p>0 then begin
          tempS := MidStr(tempS, Length(CACHE_DIR)+1, Length(tempS));
        end else begin
          p := Pos(CACHE_DIR_ALT, tempS);
          if p>0 then begin
            tempS := MidStr(tempS, Length(CACHE_DIR_ALT)+1, Length(tempS));
          end;
        end;
        SubsFoundList.Add(tempS);
        Lines[i] := AnsiReplaceStr(Lines[i],CPRS_DIR_SIGNAL, CPRSDir);  //kt 8/19/21
      end;
    end;
    //Ensure images are downloaded before passing page to web browser
    uImages.EnsureSLImagesDownloaded(SubsFoundList);
    if RefreshGraphCount > 0 then begin
      MessageDlg('Updated '+IntToStr(RefreshGraphCount)+' Auto-Refresh Graph(s)',mtInformation, [mbOK],0);
    end;
  end;


  Procedure InsertSubs(Lines : TStrings);
  //Purpose: To scan a edited note images, and replace references to CPRS's
  //         actual local directory with CPRS_DIR_SIGNAL ('$CPRSDIR$')
  var i,p,endpos : integer;
     TempS: string;
     //TempURL: string;
     MidStr: string;
     //NewStr: string;
  const
     FILEPREFIX: string = 'src="file:///';
  begin
    for i := 0 to Lines.Count-1 do begin
      //p := pos(ALT_IMG_TAG_CONVERT,Lines.Strings[i]);
      if (Pos('src="file:',Lines.Strings[i])>0) AND (Pos('file:///',Lines.Strings[i])=0) then begin
        Lines.Strings[i] := AnsiReplaceStr(Lines.Strings[i],'file:','file:///');
      end;
      p := pos(FILEPREFIX,Lines.Strings[i]);
      if p=0 then p := pos(CPRSDir, Lines.Strings[i]);
      if p = 0 then continue;
      TempS := Lines.Strings[i];
      Lines.Strings[i] := AnsiReplaceStr(Lines.Strings[i],URL_CPRSDir, CPRS_DIR_SIGNAL);  //kt 8/19/21  Reinstating.  Had been commented out prior.  Why?
      Lines.Strings[i] := AnsiReplaceStr(Lines.Strings[i],CPRSDir,     CPRS_DIR_SIGNAL);
      if Lines.Strings[i] = TempS then begin  //There is a problem. Replacement failed.
         endPos := pos('Cache/',Lines.Strings[i]);
         //MidStr := AnsiMidStr(Lines.Strings[i],p+13,Length(Lines.Strings[i])-endPos);
         p := p + Length(FILEPREFIX);
         MidStr := AnsiMidStr(Lines.Strings[i],p,endPos-p-1);
         Lines.Strings[i] := AnsiReplaceStr(Lines.Strings[i],MidStr,CPRS_DIR_SIGNAL);
      end;
      //kt 8/19/21 Lines.Strings[i] := AnsiReplaceStr(Lines.Strings[i],ALT_IMG_TAG_CONVERT,'IMAGE'); //Remove signal
      Lines.Strings[i] := AnsiReplaceStr(Lines.Strings[i],ALT_IMG_TAG_CONVERT, ''); //Remove signal
      //if Pos(URL_CPRSDir,Lines.Strings[i])>0 then begin
      if Lines.Strings[i] = TempS then begin  //There is a problem. Replacement failed.
        MessageDlg('Problem converting image path to $CPRSDIR$',mtWarning,[mbOK],0);
        exit;
      end;

    end;
  end;


  function TextIsHTML(Line : String): boolean;
  {Purpose: To look at the Text and determine if it is an HTML document.
   Test used: if document contains <!DOCTYPE HTML" or <HTML> or </BODY> or other tags
        This is not a fool-proof test...
   NOTE: **This does NOT call ScanForSubs as the other IsHTML(TStrings) function does. UPDATE: changed so that it does...    }

  begin
    Result := false;  //default of false
    Line := UpperCase(Line);
    if (Pos('<!DOCTYPE HTML',Line) > 0)
      or (Pos('<HTML>',Line) > 0)
      or (Pos('<BR>',Line) > 0)
      or (Pos(HTML_BEGIN_TAG,Line) > 0)
      or (Pos('<P>',Line) > 0)
      or (Pos('&NBSP',Line) > 0)
      or (Pos('</BODY>',Line) > 0)then begin
      Result := true;
    end;
    //if Result = true then ScanForSubs(Line);  //kt NOTE: can't do here because changes won't be passed out...
  end;


  function IsHTML(Lines : TStrings): boolean;
  //Purpose: To look at the note loaded into Lines and determine if it is
  //          an HTML document.  See other IsHTML(String) function for test used.
  begin
    Result := false;
    if Lines = nil then exit;
    Result := TextIsHTML(Lines.Text);
    //Moving the ScanForSubs upstream into LoadDocumentText, so it is done just once, upon loading document.
    //if Result = true then ScanForSubs(Lines);
  end;

  
  function HasHTMLTags(Text: string) : boolean;
    function GetTag(p1,p2 : integer; var Text : string) : string;
    var i : integer;
    begin
      Result := MidStr(Text,p1, p2-p1);
      if Result[1] = '/' then Result := MidStr(Result,2,999);
      i := Pos(' ',Result);
      if i >0 then Result := MidStr(Result,1,i-1);
    end;
    
  var p1,p2: integer;
      Tag : string;
  begin
    Result := False; //default to ignore
    Text := UpperCase(Text);
    if (Pos('&NBSP;',Text)>0) then Result := true
    else if (Pos('<P>',Text)>0) then Result := true
    else if (Pos('<BR>',Text)>0) then Result := true
    else if (Pos('<HTML>',Text)>0) then Result := true
    else begin
      p1 := Pos('<',Text); if p1 = 0 then exit;
      p2 := Pos('>',Text); if p2 = 0 then exit;
      Tag := GetTag(p1,p2,Text);
      if Tag='' then exit;
      if Pos('/'+Tag+'>',Text)>0 then result := true;      
    end;
    {
    if (Pos('<BR>',Text)>0) or
       (Pos('</P>',Text)>0) or
       (Pos('<UL>',Text)>0) or
       (Pos('</UL>',Text)>0) or
       (Pos('<LI>',Text)>0) or
       (Pos('</LI>',Text)>0) or
       (Pos('<OL>',Text)>0) or
       (Pos('</OL>',Text)>0) or
       (Pos('&NBSP;',Text)>0) or
       (Pos('<P>',Text)>0) then begin
      Result := true;
    end;            
    }
  end;
    
  
  function LineAfterTag(Lines : TStrings; Tag : string) : integer;
  //returns index of line directly after tag (-1 if not found)
  //Note: only 1st tag is found (stops looking after that)
  var p,i : integer;
      s,s1,s2 : string;
  begin
    result := -1;
    Tag := UpperCase(Tag);
    for i := 0 to Lines.Count-1 do begin
      s := UpperCase(Lines.Strings[i]);
      p := Pos(Tag,s);
      if p=0 then continue;
      if (p+length(Tag)-1) < length(s) then begin  //extra stuff after tag on line --> split line
        s1 := MidStr(Lines.Strings[i],1,p+length(Tag)-1);
        s2 := MidStr(Lines.Strings[i],p+length(Tag),Length(Lines.Strings[i]));
        Lines.Strings[i] := s1;
        Lines.Insert(i+1,s2);            
      end;
      //Lines.Insert(i+1,'');    
      result := i+1;
      break;
    end;
  end;

  function LineBeforeTag(Lines : TStrings; Tag : string) : integer;
  //returns index of newly added blank line, directly before tag (-1 if not found)
  //Note: only 1st tag is found (stops looking after that)
  var p,i,idx : integer;
      s,s1,s2 : string;
  begin
    result := -1;  
    idx := -1;
    Tag := UpperCase(Tag);
    for i := 0 to Lines.Count-1 do begin
      s := UpperCase(Lines.Strings[i]);
      p := Pos(Tag,s);
      if p>0 then begin
        idx := i;
        break;
      end;  
    end;  
    if idx <> -1 then begin
      p := Pos(Tag,UpperCase(Lines.Strings[idx]));
      if p>1 then begin  //extra stuff after tag on line --> split line
        s1 := MidStr(Lines.Strings[idx],1,p-1);
        s2 := MidStr(Lines.Strings[idx],p,Length(Lines.Strings[idx]));
        Lines.Strings[idx] := s1;
        Lines.Insert(idx+1,s2);
        inc(idx);
      end;
      //Lines.Insert(idx-1,'');
      result := idx;
    end;
  end;

  function SplitLineAfterTag(Lines : TStrings; Tag : string) : integer;
  //Purpose: To ensure that text that occurs after Tag is split and wrapped
  //         to the next line.
  //Note: It is assumed that tag is in form of <TAGName> or <SomeReallyLongText...
  //      if a closing '>' is not provided in the tag name, then the part provided
  //      is used for matching, and then a search for the closing '>' is made, and
  //      the split will occur after that.
  //Note: Only the first instance of Tag will be found, stops searching after that.
  //Note: Tag beginning and ending MUST occur on same line (wrapping of a long tag NOT supported)
  //Result: returns index of line containing tag when done, or -1
  var i,p1,p2 : integer;
      s,s1,s2 : string;
  begin
    Result := -1;
    Tag := UpperCase(Tag);
    for i := 0 to Lines.Count-1 do begin
      s := UpperCase(Lines.Strings[i]);
      p1 := Pos(Tag,s);    
      if p1=0 then continue;
      p2 := PosEx('>',s,p1);
      if p2=0 then continue;  //this is a problem, no closing '>' found... ignore for now.
      if p2 = length(s) then break;
      s1 := MidStr(Lines.Strings[i],1,p2);
      S2 := MidStr(Lines.Strings[i],p2+1,999);
      Lines.Strings[i] := s1;
      Lines.Insert(i+1,s2);
      Result := i;
      break;
    end;
  end;

  procedure SplitLineBeforeTag(Lines : TStrings; Tag : string);
  //Purpose: To ensure that text that occurs before Tag is split and Tag
  //         is wrapped to the next line.
  //Note: It is assumed that tag is in form of <TAGName> or <SomeReallyLongText...
  //Note: Only the first instance of Tag will be found, stops searching after that.
  var i,p1 : integer;
      s1,s2 : string;
  begin
    Tag := UpperCase(Tag);
    for i := 0 to Lines.Count-1 do begin
      p1 := Pos(Tag,UpperCase(Lines.Strings[i]));
      if p1=0 then continue;
      s1 := MidStr(Lines.Strings[i],1,p1-1);
      S2 := MidStr(Lines.Strings[i],p1,999);
      Lines.Strings[i] := s1;
      Lines.Insert(i+1,s2);
      break;
    end;
  end;

  function IndexOfHoldingLine(Lines : TStrings; Tag : string; ReverseSearch : boolean = false; ExcludeFirstLastLine : boolean = false) : integer;
  var i : integer;
      LoopMin, LoopMax : integer;
      s : string;
      SrchDone : boolean;
  begin
    result := -1;
    Tag := UpperCase(Tag);
    SrchDone := false;
    if not ExcludeFirstLastLine then begin
      LoopMin := 0;
      LoopMax := Lines.Count-1;
    end else begin
      LoopMin := 1;
      LoopMax := Lines.Count-2;
    end;
    if ReverseSearch then i := LoopMax else i := LoopMin;
    while not SrchDone do begin
      s := UpperCase(Lines.Strings[i]);
      if Pos (Tag,s)>0 then begin
        result := i;
        SrchDone := true;
        break;
      end;
      if ReverseSearch then begin
        dec(i); SrchDone := (i < LoopMin);
      end else begin
        inc(i); SrchDone := (i > LoopMax);
      end;
    end;
  end;

  procedure EnsureTrailingBR(Lines : TStrings);
  var  p,i : integer;
  begin
    for i := 0 to Lines.Count-1 do begin   //Ensure each line ends with <BR>
      p := Pos('<BR>',Lines.Strings[i]);
      if p+3=length(Lines.Strings[i]) then continue;
      Lines.Strings[i] := Lines.Strings[i] + '<BR>';
    end;
  end;

  procedure MergeLines(Lines,BeforeLines,AfterLines : TStrings);
  var  i : integer;
       Result : TStringList;
  begin
    Result := TStringList.Create;
    SplitLineAfterTag(Lines,'<!DOCTYPE HTML');
    SplitLineBeforeTag(Lines,'</BODY>');
    Result.Add(Lines.Strings[0]);  //Should be line with <!DOCTYPE HTML...
    for i := 0 to BeforeLines.Count-1 do begin  //Add Before-Lines text
      Result.Add(BeforeLines.Strings[i]);
    end;
    for i := 1 to Lines.Count-2 do begin  //Add back regular lines text
      Result.Add(Lines.Strings[i]);
    end;
    for i := 1 to AfterLines.Count-1 do begin //Add After-Lines text
      Result.Add(AfterLines.Strings[i]);
    end;
    Result.Add(Lines.Strings[Lines.count-1]); //Should be '</BODY></HTML>' line

    Lines.Assign(Result);
  end;

  procedure StripBeforeAfterHTML(Lines,OutBefore,OutAfter: TStrings);
  //Purpose: Strip all text that comes before <!DOCTYPE ... line and store in OutBefore;
  //         Strip all text that comes after </HTML> ... line and store in OutAfter;
  var i : integer;
      DocTypeLine,EndHTMLLine: integer;
  begin
    OutBefore.Clear;
    OutAfter.Clear;
    DocTypeLine := IndexOfHoldingLine(Lines,'<!DOCTYPE HTML');
    if DocTypeLine>1 then begin  //don't combine steps below into 1 loop
      for i := 0 to DocTypeLine-1 do OutBefore.Add(Lines.Strings[i]);
      for i := 0 to DocTypeLine-1 do Lines.Delete(0);
    end;
    EndHTMLLine := IndexOfHoldingLine(Lines,'</HTML>',true);
    if (EndHTMLLine>0) and (EndHTMLLine < (Lines.Count-1)) then begin  //don't combine steps below into 1 loop
      for i := EndHTMLLine+1 to Lines.Count-1 do OutAfter.Add(Lines.Strings[i]);
      for i := EndHTMLLine+1 to Lines.Count-1 do Lines.Delete(EndHTMLLine+1);
    end;
  end;


  function SplitHTMLBeforeMidleAfter(Lines,OutBefore,OutMiddle, OutAfter: TStrings) : boolean;
  //Purpose: Slit all text that comes before (and includes) </HTM> line and store in OutBefore;
  //         Split all text that comes after (and includes) <!DOCTYPE ... line and store in OutAfter;
  //         Split all text that comes between lines of Before and After, and store in OutMiddle;
  //Goal: when text contains HTML-note-A, then plain text, then HTML-note-B, this will separate them
  //Lines is not modified.
  //NOTE: This only splits out the FIRST grouping.  Call this function repeatedly until result is false

  var i : integer;
      DocTypeLine,EndHTMLLine: integer;
  begin
    Result := false;
    OutBefore.Clear;
    OutAfter.Clear;
    OutMiddle.Clear;
    EndHTMLLine := IndexOfHoldingLine(Lines,'</HTML>',false, false);   //last param was TRUE originally   7/25/22
    for i := 0 to EndHTMLLine do OutBefore.Add(Lines.Strings[i]);
    DocTypeLine := IndexOfHoldingLine(Lines,'<!DOCTYPE HTML', false, true);
    if (DocTypeLine>-1) then for i := DocTypeLine to Lines.count-1 do OutAfter.Add(Lines.Strings[i]);
    if (EndHTMLLine>-1) and (DocTypeLine>-1) then begin
      for i := EndHTMLLine+1 to DocTypeLine - 1 do OutMiddle.Add(Lines.Strings[i]);
      Result := true;
    end;
  end;


  procedure ChangeTags(Lines : TStrings; OldTag, NewTag : string; ExcludeFirstLastLine : boolean = false);
  var i : integer;
      s : string;
  begin
    repeat
      i := IndexOfHoldingLine(Lines, OldTag, false, ExcludeFirstLastLine);
      if i > -1 then begin
        s := AnsiReplaceText(Lines.Strings[i], OldTag, NewTag);
        Lines.Strings[i] := s;
      end;
    until (i=-1);
  end;

  procedure DelTags(Lines : TStrings; Tag : string; ExcludeFirstLastLine : boolean = false);
  begin
    ChangeTags(Lines, Tag, '', ExcludeFirstLastLine);
  end;

  function DelTagEx(Lines : TStrings; Tag : string; ExcludeFirstLastLine : boolean = false) : integer;
  //Designed for ability to remove <!DOCTYPE ... >' but should be multi-purpose
  //Note: It is assumed that tag is in form of '<TAGName', and a closing '>' should
    //    not be provided in the tag name, so a search for the closing '>' will be made
  //Note: Only the first instance of Tag will be found, stops searching after that.
  //Note: Tag beginning and ending MUST occur on same line (wrapping of a long tag NOT supported)
  //Result: returns index of line containing tag when done, or -1
  var i, p1 : integer;
      s,s1,s2 : string;
  begin
    Result := -1;
    i := IndexOfHoldingLine(Lines, Tag, false, ExcludeFirstLastLine);
    if i = -1 then exit;
    s := Lines.Strings[i];
    p1 := Pos(Tag,UpperCase(s));
    if p1=0 then exit;
    s1 := MidStr(s, 1, p1-1);
    s2 := MidStr(s, p1, length(s));
    p1 := Pos('>', s2);
    if p1 > 0 then begin
      s2 := MidStr(s2, p1+1, length(s2));
    end else begin
      s2 := '';
    end;
    s := s1 + s2;
    Lines.Strings[i] := s;
    Result := i;
  end;

  procedure WrapLinesWithCodeTag(Lines : TStrings);
  var i : integer;
  begin
    //EnsureTrailingBR(Lines);  //kt removed when <CODE> --> <PRE>, which doesn't need <BR>'s
    if Lines.Count = 0 then exit;
    //Wrap Before-Lines with formatting
    Lines.Insert(0,'<PRE>');  //kt 7/1 was '<CODE>'
    //<---Existing text remains in between --->
    i := 0;
    //Insert a horizontal like before start of next addendum (if any)
    while (i < Lines.Count) do begin
      if (Pos('ADDENDUM',Lines.Strings[i])>0) and
      (Pos('STATUS:',Lines.Strings[i])>0) then begin
        Lines.Insert(i, '<HR><P>');  //horizontal line
        inc(i);
      end;
      inc(i);
    end;
    Lines.Add('</PRE>');   //kt 7/1 was '</CODE>'
  end;

  procedure FixMiddleLines(Lines : TStrings);
  (*Sometimes if a note has multiple addendedums, then there will be multiple beginnings and
  endings of HTML notes.  These have to be stripped out.
  ...
  '  <P>&nbsp;</P>'
  '  <P><BR>'
  '  <P><BR>'
  '  <P>  <P>&nbsp;</P>'
  '</BODY></HTML>'
  ''
  '/es/ MARCIA DEE TOPPENBERG, MD'
  'Family Physician'
  'Signed: 06/23/2014 18:20'
  "
  'Receipt Acknowledged By:'
  '06/24/2014 15:30        /es/ EDDIE L HAGOOD                                    '
  '                                                                               '
  "
  '06/24/2014 ADDENDUM                      STATUS: COMPLETED'
  '<!DOCTYPE HTML PUBLIC "-//WC3//DTD HTML 3.2//EN">  <HTML><BODY><P>I spoke with '
  'xxx and explained the decrease in kidney function. She said that she would '
  'come in Thursday morning for the bloodwork and to leave the urine sample (she '
  ...

  should become:
  ...
  '  <P>&nbsp;</P>'
  '  <P><BR>'
  '  <P><BR>'
  '  <P>  <P>&nbsp;</P>'
  '<CODE>'
  ''
  '/es/ MARCIA DEE TOPPENBERG, MD'
  'Family Physician'
  'Signed: 06/23/2014 18:20'
  "
  'Receipt Acknowledged By:'
  '06/24/2014 15:30        /es/ EDDIE L HAGOOD                                    '
  '                                                                               '
  "
  '06/24/2014 ADDENDUM                      STATUS: COMPLETED'
  '</CODE><BR><P>I spoke with '
  'xxx and explained the decrease in kidney function. She said that she would '
  'come in Thursday morning for the bloodwork and to leave the urine sample (she '
  ...
  *)
  var found : boolean;
      BeforeLines,MiddleLines, AfterLines : TStringList;
      TMGDebugEditLines : boolean;
  begin
    BeforeLines := TStringList.Create;
    AfterLines := TStringList.Create;
    MiddleLines := TStringList.Create;
    TMGDebugEditLines := false;                       //kt 4/16  -- can change while walking through to edit StringList;
    if TMGDebugEditLines = true then EditSL(Lines);   //kt 4/16
    repeat
      found := SplitHTMLBeforeMidleAfter(Lines,BeforeLines, MiddleLines, AfterLines);
      if found then begin
        DelTags(BeforeLines, '</BODY>', false);
        DelTags(BeforeLines, '</HTML>', false);

        EnsureTrailingBR(MiddleLines);  //6/15
        //WrapLinesWithCodeTag(MiddleLines);   //  6/15
        //MiddleLines.Add('<HR><P>');  //horizontal line

        DelTagEx(AfterLines, '<!DOCTYPE'); //gets just the first one
        DelTagEx(AfterLines, '<HTML');  //gets just the first one
        DelTagEx(AfterLines, '<BODY');  //gets just the first one

        Lines.Text := BeforeLines.Text + MiddleLines.Text + AfterLines.text;
        //MergeLines(Lines,BeforeLines,AfterLines);
      end;
    until not found;
    BeforeLines.free;
    AfterLines.free;
    MiddleLines.free;
    if TMGDebugEditLines = true then EditSL(Lines);   //kt 4/16
  end;

  procedure EditSL(Lines : TStrings);
  //kt added block 4/16
  var HTMLText : string;
      frmView : TfrmMemoEdit;
  begin
    try
      frmView := TfrmMemoEdit.Create(Application);
      frmView.memEdit.ReadOnly := false;
      frmView.memEdit.ScrollBars := ssBoth;
      frmView.memEdit.Lines.Assign(Lines);
      frmView.Caption := 'Edit Text';
      frmView.lblMessage.Caption := 'Edit source code of note.';
      if frmView.ShowModal = mrOK then begin
        Lines.Assign(frmView.memEdit.Lines);
      end;
    finally
      frmView.Free;
    end;
  end;


  procedure FixHTML(Lines : TStrings); //kt 6/20/09
  //Purpose: to put header info that VistA adds to note into proper formatting.
  var  BeforeLines,AfterLines : TStringList;
       TMGDebugEditLines : boolean;
  begin
    TMGDebugEditLines := false;                       //kt 4/16  -- can change while walking through to edit StringList;
    if TMGDebugEditLines = true then EditSL(Lines);   //kt 4/16
    BeforeLines := TStringList.Create;
    AfterLines := TStringList.Create;
    StripBeforeAfterHTML(Lines,BeforeLines,AfterLines);
    FixMiddleLines(Lines);
    if BeforeLines.Text <> '' then WrapLinesWithCodeTag(BeforeLines);
    if AfterLines.Text <> '' then begin
      BeforeLines.Add('<HR><P>');  //horizontal line
      WrapLinesWithCodeTag(AfterLines);
      AfterLines.Insert(0,'<P>');
    end;
    MergeLines(Lines,BeforeLines,AfterLines);
    BeforeLines.Free;
    AfterLines.Free;
    if TMGDebugEditLines = true then EditSL(Lines);   //kt 4/16
  end;

  function FixNoBRs(Text : string) : string;  //Remove unwanted <BR>'s or line feeds
  begin
    Result := Text;
    Result := AnsiReplaceText(Result, NO_BR_TAG+'<BR>','');
    Result := AnsiReplaceText(Result, NOBR_TAG+'<BR>','');
    Result := AnsiReplaceText(Result, NO_SPC_BR_TAG+'<BR>','');
    Result := AnsiReplaceText(Result, NO_BR_TAG2+'<BR>','');
    Result := AnsiReplaceText(Result, NOBR_TAG2+'<BR>','');
    Result := AnsiReplaceText(Result, NO_SPC_BR_TAG2+'<BR>','');

    //Next, end of line NO-BR's
    Result := AnsiReplaceText(Result, NO_BR_TAG+CRLF,'');
    Result := AnsiReplaceText(Result, NOBR_TAG+CRLF,'');
    Result := AnsiReplaceText(Result, NO_SPC_BR_TAG+CRLF,'');
    Result := AnsiReplaceText(Result, NO_BR_TAG2+CRLF,'');
    Result := AnsiReplaceText(Result, NOBR_TAG2+CRLF,'');
    Result := AnsiReplaceText(Result, NO_SPC_BR_TAG2+CRLF,'');

    //Next, if isolated NO-BR found, remove it.
    Result := AnsiReplaceText(Result, NO_BR_TAG,'');
    Result := AnsiReplaceText(Result, NOBR_TAG,'');
    Result := AnsiReplaceText(Result, NO_SPC_BR_TAG,'');
    Result := AnsiReplaceText(Result, NO_BR_TAG2,'');
    Result := AnsiReplaceText(Result, NOBR_TAG2,'');
    Result := AnsiReplaceText(Result, NO_SPC_BR_TAG2,'');
  end;

  Function FixHTMLCRLF(Text : String) : string;
  var SL : TStringList;
      i : integer;
      s, tag : string;
  begin
    SL := TStringList.Create;
    SL.Text := Text;
    //For any lines that end in <BR>, remove it to prevent *double* <BR>'s from be added
    for i := 0 to SL.Count - 1 do begin
      s := TrimRight(SL.Strings[i]);
      tag := MidStr(s, Length(s)-3, Length(s));
      if UpperCase(tag) = '<BR>' then begin
        s := MidStr(s, 1, Length(s)-4);
        SL.Strings[i] := s;
      end;
    end;
    Result := SL.Text;
    SL.Free;
    //FYI AnsiReplaceText match is case-insensitive
    Result := FixNoBRs(Result);
    Result := AnsiReplaceText(Result,'<NO DATA>',#$1E); //protect sequences we want
    Result := AnsiReplaceText(Result,'LI>'+CRLF,#$1D); //protect sequences we want   //elh
    Result := AnsiReplaceText(Result,CRLF +'<P>','<P>'); //protect sequences we want   //elh
    Result := AnsiReplaceText(Result,'<P>'+CRLF,'<P>'); //protect sequences we want
    Result := AnsiReplaceText(Result,'>'+CRLF,'>'#$1F); //protect sequences we want
    Result := AnsiReplaceText(Result,CRLF,'<BR>'+CRLF); //Add <BR>'s to CrLf's
    Result := AnsiReplaceText(Result,'>'#$1F,'><BR>'); //Removed +CRLF  //Restore sequences we wanted  //elh Added <BR> to replacement text
    //Result := AnsiReplaceText(Result,'>'#$1F,'>'+CRLF); //Restore sequences we wanted
    Result := AnsiReplaceText(Result,#$1D,'LI>'+CRLF); //protect sequences we want   //elh
    Result := AnsiReplaceText(Result,#$1E,'<NO DATA>'); //Restore sequences we wanted
  end;


  procedure SplitHTMLToArray (HTMLText: string; Lines : TStrings; MaxLineLen: integer = 80);
  var tempS                 : string;
    InEscapeCode, InTagCode : boolean;
    InScript,InDblQt,InSingleQt : boolean;
    i,j, k, LastGoodBreakI  : integer;
    TagStart,TagEnd         : integer;
    TagText, TestTag        : string;
    TextLen                 : integer;
    ch                      : char;

    function InQuote : boolean; begin Result := InDblQt or InSingleQt; end;
    function SafeToBreak : boolean; begin Result := (not InTagCode) and (not InEscapeCode) and (not InQuote); end;
    function NextChar(Offset : byte=1) : char;
    var idx : integer;
    begin
      idx := i + Offset;
      if idx <= length(HTMLText) then Result := HTMLText[idx] else Result := #0;
    end;

  begin
    Lines.Clear;
    InEscapeCode := False;
    InTagCode := False;
    InScript := false;
    InDblQt := false;
    InSingleQt := false;
    Repeat
      LastGoodBreakI := 0;
      TextLen := length(HTMLText);
      TagText := '';
      TagStart := 0; TagEnd := 0;
      //kt 4/22/16 if TextLen > MaxLineLen then TextLen := MaxLineLen;
      i := 1;
      j := 1;
      while i <= TextLen do begin
        ch := HTMLText[i];
        if InScript and (ch = '''') and not InDblQt then InSingleQt := not InSingleQt;    //NOTE: this gets messed up with things like: Can't, Sync'd, etc
        if InScript and (ch = '"') and not InSingleQt then InDblQt := not InDblQt;
        if not InQuote then begin
          if InScript then begin
            if ch =';' then begin
              if (NextChar(1) = #$D) and (NextChar(2) = #$A) then inc(i, 2);
              LastGoodBreakI := i;
              break;
            end;
            if ch = #$D then begin
              if (NextChar(1) = #$A) then inc(i);
              LastGoodBreakI := i;
              break;
            end;
            if (ch = '<') then begin
              k := PosEx('>', HTMLText, i);
              if k > 0 then begin
                TestTag := MidStr(HTMLText, i+1, k-i-1);
                //When in javascript, the only HTML tag that should be recognized is '</script>'
                if UpperCase(Trim(Piece(TestTag,' ',1))) = '/SCRIPT' then begin
                  InTagCode := True;
                  TagStart := i;
                  TagText := '';
                  LastGoodBreakI := i-1;
                end;
              end;
            end;
          end else begin  //not in javascript
            if (ch = '&') then begin
              InEscapeCode := True;
              LastGoodBreakI := i-1;
            end;
            if (ch = '<') then begin
              InTagCode := True;
              TagStart := i;
              TagText := '';
              LastGoodBreakI := i-1;
            end;
          end;
          if InEscapeCode and (ch = ';') then begin
            InEscapeCode := False;
            LastGoodBreakI := i;
          end;
          if InTagCode and (ch = '>') then begin
            InTagCode := False;
            TagEnd := i;
            TagText := UpperCase(MidStr(HTMLText,TagStart+1,(TagEnd-TagStart-1)));
            LastGoodBreakI := i;
            if Pos('SCRIPT', TagText) > 0 then begin
              InScript := (Trim(TagText[1]) <> '/');
              InDblQt := false;
              InSingleQt := false;
            end;
            if (TagText='BR') or (TagText='/P') then begin
              LastGoodBreakI := TagEnd;
              break;
            end;
          end;
          if (ch in [' ', ',', ')']) and SafeToBreak then begin
            LastGoodBreakI  := i;
          end;
          if (i > MaxLineLen)  and (LastGoodBreakI > 0) then begin
            break;
          end;
        end else begin   //elh
          if (NextChar(1) = #$D) then begin
            if (NextChar(2) = #$A) then inc(i, 2) else inc(i);
            LastGoodBreakI := i;
          end;
          if i > (MaxLineLen *2) then begin  //emergency mode...
            //force off quotes after line is too long.
            InSingleQt := false;  InDblQt := false;
            break;
          end;
        end;
        inc(i);
        TagText := '';
      end;
      if LastGoodBreakI > 0 then begin
        tempS := MidStr(HTMLText,1,LastGoodBreakI);
        if InScript then tempS := StringReplace(tempS, #$D#$A, '', [rfReplaceAll]);
        HTMLText := Rightstr(HTMLText, length(HTMLText)- LastGoodBreakI);
        if pos('function ', tempS) > 0 then begin
          inc(j);  //debug stopping point
        end;
        if (InScript = false) or (tempS <> '') then Lines.Add(tempS);
      end else begin  //couldn't find good break, so cut off arbitrarily ... may introduce HTML errors
        tempS := MidStr(HTMLText,1,80);
        HTMLText := Rightstr(HTMLText, length(HTMLText)- 80);    //characters 81 ... the end
        if (InScript = false) or (tempS <> '') then Lines.Add(tempS);
      end;
    until length(HTMLText)=0;
    if j>0 then inc(i);  //debug line, can delete later...

    if (not IsHTML(Lines)) and (Lines.Count > 0) then begin
      //If text was *just text*, then the fact that this is actually HTML gets lost, so add
      //something HTML specific, namely an invisible space character at the very end.
      tempS := Lines.Strings[Lines.Count-1] + '&nbsp;';
      Lines.Strings[Lines.Count-1] := tempS;
    end;
  end;

  procedure WrapLongHTMLLines(Lines : TStrings; MaxLineLen: integer = 255; LineBreakStr : string = NO_BR_TAG);
  //kt added 11/24/15
  var  i, j: integer;
       s: string;
       TempSL : TStringList;

  begin
    i := 0;
    TempSL := TStringList.Create;
    while i < Lines.Count do begin  //kt added block 11/24/15
      s := Lines.Strings[i];
      if length(s) >= MaxLineLen then begin
        TempSL.Clear;
        SplitHTMLToArray(S, TempSL, MaxLineLen);
        Lines.Delete(i);
        for j := TempSL.Count - 1 downto 0 do begin
          Lines.Insert(i, TempSL.Strings[j]+LineBreakStr);
        end;
      end;
      inc(i);
    end;
    TempSL.Free;
  end;


const
  DOC_TYPE = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">';
  HEAD_MAX_STRS_IDX = 3;
  HEAD_STRS : array [0..HEAD_MAX_STRS_IDX] of string = (
    '<HEAD>',
    '<META http-equiv=Content-Type content="text/html; charset=windows-1256">',
    '<META content="MSHTML 6.00.6000.17107" name=GENERATOR>',
    '</HEAD>'
  );

  procedure AddDocType(Lines : TStrings; InsertMode : boolean = false);
  begin
    if InsertMode and (Lines.Count > 0) then begin
      Lines.Insert(0, DOC_TYPE);
    end else begin
      Lines.Add(DOC_TYPE);
    end;
  end;

  procedure AddHead(Lines : TStrings; InsertMode : boolean = false);
  var i : integer;
  begin
    if InsertMode and (Lines.Count > 0) then begin
      for i := 0 to HEAD_MAX_STRS_IDX do Lines.Insert(i, HEAD_STRS[i]);
    end else begin
      for i := 0 to HEAD_MAX_STRS_IDX do Lines.Add(HEAD_STRS[i]);
    end;
  end;

  procedure MakeBlankHTMLDoc(Lines : TStrings);
  begin
    AddDocType(Lines);  //<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
    Lines.Add('<HTML>');
    AddHead(Lines);
    Lines.Add('<BODY>');
    //NOTE: <--- Note this is designed such that text can be inserted here
    Lines.Add('</BODY></HTML>');
  end;

  function BlankHTMLDoc : string;
  var SL : TStringList;
  begin
    SL := TStringList.Create;
    MakeBlankHTMLDoc(SL);
    Result := SL.Text;
  end;


  procedure EnsureHTMLStructure(Lines : TStrings);
  {Purpose: To ensure that document is in standard HTML format:
     <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
     <html>
       <head>
       </head>
       <body>
          //original content of Lines will go here
       </body>
     </html>
  }
  //NOTICE: Won't convert notes already with some elements of HTML
  //  ... a better converter could be done later...
  var UpperText : string;
      HasDocType,HasBody,HasHead,HasHTML : boolean;
  begin
    if not assigned(Lines) then exit;
    UpperText := UpperCase(Lines.Text);
    HasDocType := (Pos('<!DOCTYPE HTML', UpperText) > 0);
    HasBody := (Pos('<BODY>', UpperText) > 0);
    HasHead := (Pos('<HEAD>', UpperText) > 0);
    HasHTML := (Pos('<HTML>', UpperText) > 0);
    if HasDocType or HasBody or HasHead or HasHTML then exit;  //raise exception??
    if Lines.Count = 0 then Lines.Add(' ');
    Lines.Insert(0,'<BODY>');
    Lines.Add('</BODY>');
    AddHead(Lines, true);
    Lines.Insert(0,'<HTML>');
    Lines.Add('</HTML>');
    AddDocType(Lines, true);
  end;


  function WrapHTML(HTMLText : string) : string; //kt 6/3/09
  //Purpose: take HTML formatted text and sure it has proper headers and footers etc.
  //         i.e. 'wrap' partial HTML into formal format.
  begin
    if Pos('<BODY>',HTMLText)=0 then HTMLText := '<BODY>' + HTMLText;
    if Pos('</BODY>',HTMLText)=0 then HTMLText :=  HTMLText + '</BODY>';
    if Pos('<HTML>',HTMLText)=0 then HTMLText := '<HTML>' + HTMLText;
    if Pos('</HTML>',HTMLText)=0 then HTMLText :=  HTMLText + '</HTML>';
    if Pos('<!DOCTYPE HTML',HTMLText)=0 then begin
      HTMLText := '<!DOCTYPE HTML PUBLIC "-//WC3//DTD HTML 3.2//EN">'+ #10#13 + HTMLText;
    end;
    result := HTMLText;
  end;

  function UnwrapHTML(HTMLText : string) : string;
  //Purpose: take HTML formatted text and remove proper headers and footers etc.
  //         i.e. 'unwrap' formal HTML into partial HTML format.
  begin
    if pos('<HTML>',HTMLText)>0 then begin  //elh   2/12/16
      HTMLText := ORFn.piece2(HTMLText,'<HTML>',2);
      HTMLText := ORFn.piece2(HTMLText,'</HTML>',1);
    end;
    if pos('<BODY>',HTMLText)>0 then begin  //elh 2/12/16
      HTMLText := ORFn.piece2(HTMLText,'<BODY>',2);
      HTMLText := ORFn.piece2(HTMLText,'</BODY>',1);
    end;
    result := HTMLText;
  end;

  function CheckForImageLink(Lines: TStrings; ImageList : TStringList) : boolean;
  {Purpose:  To scan memNote memo for a link to an image.  If found, return link(s)
   input:  none:
   output:  Will return a string list holding 1 or more links
   Notes:  Here will be the <img ..  > format scanned for:

        Here is some opening text...
          <img src="http://www.geocities.com/kdtop3/OpenVistA.jpg" alt="Image Title 1">
        And here is some more text
          <img src="http://www.geocities.com/kdtop3/OpenVistA_small.jpg" alt="Image Title 2">
        And the saga continues...
          <img src="http://www.geocities.com/kdtop3/pics/Image100.gif" alt="Image Title 3">
           As with html, end-of-lines and white space is not preserved or significant
  }

    function GetBetween (var Text : AnsiString; OpenTag,CloseTag : string;
                         KeepTags : Boolean) : string;
    {Purpose: Gets text between Open and Close tags.  Removes any CR's or LF's
     Input: Text - the text to work on.  It IS changed as code is removed
            KeepTags - true if want tag return in result
                       false if tag not in result (still is removed from Text)
     Output: Text is changed.
             Result=the code between the opening and closing tags
     Note: Both OpenTag and CloseTag MUST be present for anything to happen.
    }

      procedure CutInThree(var Text : AnsiString; p1, p2 : Integer; var s1,s2,s3 : AnsiString);
      {Purpose: Cut input string Text into 3 parts, with cut points given by p1 & p2.
                p1 points to first character to be in s2
                p2 points to last character to be in s2        }
      begin
        s1 := ''; s2 := '';  s3 := '';
        if p1 > 1 then s1 := MidStr(Text, 1, p1-1);
        s2 := MidStr(Text, p1, p2-p1+1);
        s3 := MidStr(Text, p2+1, Length(Text)-p2);
      end;

    var
      p1,p2 : integer;
      s1,s2,s3 : AnsiString;

    begin
      Result := ''; //default of no result.

      p1 := Pos(UpperCase(OpenTag), UpperCase(Text));
      if (p1 > 0) then begin
        p2 := Pos(UpperCase(CloseTag),UpperCase(Text)) + Length(CloseTag) -1;
        if ((p2 > 0) and (p2 > p1)) then begin
          CutInThree (Text, p1,p2, s1,Result,s3);
          Text := s1+s3;
          //Now, remove any CR's or LF's
          repeat
            p1 := Pos (Chr(13),Result);
            if p1= 0 then p1 := Pos (Chr(10),Result);
            if (p1 > 0) then begin
              CutInThree (Result, p1,p1, s1,s2,s3);
              Result := s1+s3;
  //            Text := MidStr(Text,1,p1-1) + MidStr(Text,p1+1,Length(Text)-p1);
            end;
          until (p1=0);
          //Now cut off boundry tags if requested.
          if not KeepTags then begin
            p1 := Length(OpenTag) + 1;
            p2 := Length (Result) - Length (CloseTag);
            CutInThree (Result, p1,p2, s1,s2,s3);
            Result := s2;
          end;
        end;
      end;
    end;

  var
    Text : AnsiString;
    LineStr : string;

  begin
    Result := false;  //set default
    if (ImageList = nil) or (Lines = nil) then exit;
    ImageList.Clear;  //set default
    Text := Lines.Text;  //Get entire note into one long string
    repeat
      LineStr := GetBetween (Text, '<img', '>', true);
      if LineStr <> '' then begin
        ImageList.Add(LineStr);
        Result := true;
      end;
    until LineStr = '';
    //Note: The following works, but need to replace removed links
    // with "[Title]"   Work on later...
    //memNote.Lines.Text := Text;
  end;

  function ConvertSpacesAndChars2HTML(Text : String) : string;
  begin
    Text := AnsiReplaceStr(Text, '&', '&amp;');
    Text := AnsiReplaceStr(Text, '<', '&lt;');
    Text := AnsiReplaceStr(Text, '>', '&gt;');
    Text := AnsiReplaceStr(Text, '"', '&quot;');
    Text := ConvertSpaces2HTML(Text);
  end;

  function ConvertSpaces2HTML(Text : String) : string;
  begin
    Result := AnsiReplaceStr(Text, #9, '&nbsp;&nbsp;&nbsp;&nbsp; ');
    while Pos('  ',Result)>0 do begin //preserve whitespace
        Result := AnsiReplaceStr(Result, '  ', '&nbsp;&nbsp;');
    end;
  end;

  function  Text2HTML(Lines : TStrings; EnsureDoc : boolean = true) : String;
  //Purpose: Take plain text, and prep for viewing in HTML viewer.
  //i.e. convert TABs into &nbsp's and add <br> at end of line etc.
  //NOTE: Resulting text will be wrapped with <HTML> tags, etc. to make FULL HTML document
  var i : integer;
      tempS : string;
      TempSL : TStringList;
  begin
    TempSL := TStringList.Create;
    TempSL.Assign(Lines);
    TempSL.Text := ConvertSpaces2HTML(TempSL.Text);
    for i := 0 to TempSL.Count-1 do begin
      tempS := TrimRight(TempSL.Strings[i]);
      if i = TempSL.Count-1 then tempS := tempS + '<P>'
      else tempS := tempS + '<BR>';
      TempSL.Strings[i] := tempS;
    end;
    if EnsureDoc then EnsureHTMLStructure(TempSL);  //kt 3/22/16, 4/8/21
    Result := TempSL.Text;
    TempSL.Free;
  end;

  function Text2HTML(text : string; EnsureDoc : boolean = true) : String;    overload;
  //NOTE: Resulting text will be wrapped with <HTML> tags, etc. to make FULL HTML document
  var Lines : TStringList;
  begin
    Lines := TStringList.create;
    Lines.Text := text;
    Result := Text2HTML(Lines, EnsureDoc);
    Lines.Free;
  end;

  function ProtectTag(text, TagName : string) : string;
  var Tag, ProtectedTag : string;
  begin
    Tag := '<'+TagName+'>';
    ProtectedTag := ProtectionMarkerOpen + TagName + ProtectionMarkerClose;
    Result := AnsiReplaceStr(text, Tag, ProtectedTag);
    Tag := '</'+TagName+'>';
    ProtectedTag := ProtectionMarkerOpen + '/' + TagName + ProtectionMarkerClose;
    Result := AnsiReplaceStr(Result, Tag, ProtectedTag);
  end;

  function UnProtectTag(text, TagName : string) : string;
  var Tag, ProtectedTag : string;
  begin
    Tag := '<'+TagName+'>';
    ProtectedTag := ProtectionMarkerOpen + TagName + ProtectionMarkerClose;
    Result := AnsiReplaceStr(text, ProtectedTag, Tag);
    Tag := '</'+TagName+'>';
    ProtectedTag := ProtectionMarkerOpen + '/' + TagName + ProtectionMarkerClose;
    Result := AnsiReplaceStr(Result, ProtectedTag, Tag);
  end;

  const
    ENCODE_CHART_OPEN_TAG = '{CHAR:';  //'&#'
    ENCODE_CHART_OPEN_TAG_LEN = length(ENCODE_CHART_OPEN_TAG);
    ENCODE_CHART_CLOSE_TAG = '}';   //';'

  function EncodeTextToSafeHTMLAttribVal(Text : string) : string;
  //Text should be made safe so that is can be stored as HTML:
  var i : integer;
      ch : char;
      c : word;
      s : string[12];
      NeedsConvert : boolean;
  begin
    NeedsConvert := false;
    for i :=1 to length(Text) do begin
      ch := Text[i];
      //if (ord(ch) >= 32) and (ord(ch) < 127) and (ch <> '"') then continue;
      if (ord(ch) >= 32) and (ord(ch) < 127) then continue;
      NeedsConvert := true;
      break;
    end;
    if NeedsConvert then begin
      Result := '';
      for i :=1 to length(Text) do begin
        ch := Text[i];
        c := ord(ch);
        //if (c < 32) or (c >= 127) or (ch = '"') then begin
        if (c < 32) or (c >= 127) then begin
          s := ENCODE_CHART_OPEN_TAG + IntToStr(c) + ENCODE_CHART_CLOSE_TAG;
          Result := Result + s;
        end else begin
          Result := Result + Text[i];
        end;
      end;
    end else begin
      Result := Text;
    end;
  end;

  function RestoreTextFromEncodedSafeHTMLAttribVal(Text : string) : string;
  var p,p2, Num : integer;
      strA, strB, numStr : string;
  begin
    p := Pos(ENCODE_CHART_OPEN_TAG, Text);
    if p > 0 then begin
      p := 1;
      while p <= length(Text) do begin
        p := PosEx(ENCODE_CHART_OPEN_TAG, Text, p);
        p2 := PosEx(ENCODE_CHART_CLOSE_TAG, Text,p);
        if (p = 0) or (p2 = 0) then begin
          p := Length(Text) + 1;
          break;
        end;
        strA := MidStr(Text, 1, p-1);
        numStr := MidStr(Text, p + ENCODE_CHART_OPEN_TAG_LEN, (p2-p-ENCODE_CHART_OPEN_TAG_LEN));
        strB := MidStr(Text, p2+1, length(Text));
        Num := StrToIntDef(numStr, 63); //63 = "?"
        Text := strA + char(Num) + strB;
      end;
      Result := Text;
    end;
    Result := Text;
  end;


  function HTMLEncode(const Data: string; var Modified : boolean): string;
  //downloaded from here: https://stackoverflow.com/questions/2968082/is-there-a-delphi-standard-function-for-escaping-html
  var i: Integer;
  begin
    result := ''; Modified := false;
    for i := 1 to length(Data) do begin
      case Data[i] of
        '<': begin result := result + '&lt;'; modified := true; end;
        '>': begin result := result + '&gt;'; modified := true; end;
        '&': begin result := result + '&amp;'; modified := true; end;
        '"': begin result := result + '&quot;'; modified := true; end;
        else result := result + Data[i];
      end; //case
    end;
  end;

  procedure HTMLEncode(const SL : TStringList); overload;
  var i: Integer;
      Temp : string;
      Modified : boolean;
  begin
    for i := 0 to SL.Count - 1 do begin
      Temp := HTMLEncode(SL.Strings[i], Modified);
      if Modified then SL.Strings[i] := Temp;
    end;
  end;


  function HTMLDecode(const AStr: String): String;
  //downloaded from here: https://stackoverflow.com/questions/1657105/delphi-html-decode
  var
    Sp, Rp, Cp, Tp: PChar;
    S: String;
    I, Code: Integer;
  begin
    SetLength(Result, Length(AStr));
    Sp := PChar(AStr);
    Rp := PChar(Result);
    Cp := Sp;
    try
      while Sp^ <> #0 do begin
        case Sp^ of
          '&': begin
                 Cp := Sp;
                 Inc(Sp);
                 case Sp^ of
                   'a': if AnsiStrPos(Sp, 'amp;') = Sp then  { do not localize }
                        begin
                          Inc(Sp, 3);
                          Rp^ := '&';
                        end;
                   'l',
                   'g': if (AnsiStrPos(Sp, 'lt;') = Sp) or (AnsiStrPos(Sp, 'gt;') = Sp) then { do not localize }
                        begin
                          Cp := Sp;
                          Inc(Sp, 2);
                          while (Sp^ <> ';') and (Sp^ <> #0) do
                            Inc(Sp);
                          if Cp^ = 'l' then
                            Rp^ := '<'
                          else
                            Rp^ := '>';
                        end;
                   'n': if AnsiStrPos(Sp, 'nbsp;') = Sp then  { do not localize }
                        begin
                          Inc(Sp, 4);
                          Rp^ := ' ';
                        end;
                   'q': if AnsiStrPos(Sp, 'quot;') = Sp then  { do not localize }
                        begin
                          Inc(Sp,4);
                          Rp^ := '"';
                        end;
                   '#': begin
                          Tp := Sp;
                          Inc(Tp);
                          while (Sp^ <> ';') and (Sp^ <> #0) do
                            Inc(Sp);
                          SetString(S, Tp, Sp - Tp);
                          Val(S, I, Code);
                          Rp^ := Chr((I));
                        end;
                   else Exit;
                 end;//case
               end;  //'&' case
          else Rp^ := Sp^;
        end; //case
        Inc(Rp);
        Inc(Sp);
      end;  //while
    except
    end;
    SetLength(Result, Rp - PChar(Result));
  end;


  type
    TFontSizeData = record
      case byte of 1: (Data : array[0..3] of byte);
                   2: (Size : byte; Filler : array[1..3] of byte);
    end;

  var
    StoredFontSize : TFontSizeData;
    FontSizeReg:     TRegistry;

  procedure SetRegHTMLFontSize(Size: byte);
  //Purpose: To set the internet explorer Font Size value via the registry.
  //Expected input: HTML_SMALLEST, HTML_SMALL, HTML_MEDIUM,HTML_LARGE, HTML_LARGEST
  //         Value should be 0 (smallest) - 4 (largest)
  const  HTML_BLANK : TFontSizeData =(Data: (0,0,0,0));
  var  Value : TFontSizeData;

  begin
    if Size > 4 then Size := 4;
    Value := HTML_BLANK; Value.Size := Size;
    FontSizeReg := TRegistry.Create;  //To be freed in RestoreRegHTMLFontSize
    try
      FontSizeReg.Rootkey := HKEY_CURRENT_USER;
      if FontSizeReg.OpenKey('\Software\Microsoft\Internet Explorer\International\Scripts\3', False) then begin
        FontSizeReg.ReadBinaryData('IEFontSize',StoredFontSize,Sizeof(StoredFontSize));
        FontSizeReg.WriteBinaryData('IEFontSize',Value,SizeOf(Value));
      end;
    finally
    end;
  end;

  procedure RestoreRegHTMLFontSize;
  //Purpose: To restore the Internet Explorer zoom value to a stored value..
  //elh 6/19/09
  begin
    if not assigned(FontSizeReg) then FontSizeReg := TRegistry.Create;
    try
      FontSizeReg.WriteBinaryData('IEFontSize',StoredFontSize,SizeOf(StoredFontSize));
    finally
      FontSizeReg.Free;
    end;
  end;

  var
    StoredIEHeader, StoredIEFooters : string;
    Reg : TRegistry;
   
  procedure SetupHTMLPrinting(Name,DOB,VisitDate,Location,Institution : string);
  //Purpose: To open the IE header and footer registry keys, save the
  //current value and then replace with passed patient data.   elh 6/19/09
  //NOTE: There does not seem to be any other way to do this programatically.
  var NewHeader,NewFooter : string;
  begin
    if DesiredHTMLFontSize > 0 then begin
      SetRegHTMLFontSize(DesiredHTMLFontSize-1);   //Downsize by 1 step
    end;
    NewHeader := Location + ' &b ' + Institution + ' &b Printed: &d &t';
    NewFooter := Name + ' (' + DOB + ') &b Note: ' + VisitDate + ' &b &p of &P';
    Reg := TRegistry.Create;  //to be freed in RestoreIEPrinting
    try
      Reg.Rootkey := HKEY_CURRENT_USER;
      if Reg.OpenKey('\Software\Microsoft\Internet Explorer\PageSetup', False) then begin
        StoredIEFooters := Reg.ReadString('footer');
        StoredIEHeader := Reg.ReadString('header');
        Reg.WriteString('header',NewHeader);
        Reg.WriteString('footer',NewFooter);
      end;
    finally 
    end;
  end;

  procedure RestoreIEPrinting;
  //Purpose: To restore the IE header and footer registry with the initial value
  //NOTE: The below function was used to restore the previous value to the registry
  //       but got commented above, so the registry retained the patient's data
  //       to resolve this, we are now setting this to a default value.
  //elh 6/19/09
  begin
    if not assigned(Reg) then begin
       Reg := TRegistry.Create;
       Reg.Rootkey := HKEY_CURRENT_USER;
       Reg.OpenKey('\Software\Microsoft\Internet Explorer\PageSetup', False)
    end;   
    try
      StoredIEFooters := '&u&b&d';          //Comment this line to restore previous value
      StoredIEHeader := '&d&b&t&bPage &p of &P';  //Comment this line to restore previous value
      Reg.WriteString('footer',StoredIEFooters);
      Reg.WriteString('header',StoredIEHeader);
      RestoreRegHTMLFontSize; 
    finally
      Reg.Free;
    end;
  end;

  function ExtractDateOfNote(Lines : TStringList) : string;
  //Scan note and return date found after 'DATE OF NOTE:', if present.
  var i,p : integer;
      s : string;
  begin
    Result := '';
    if Lines = nil then exit;
    for i := 0 to Lines.Count-1 do begin
      p := Pos('DATE OF NOTE:',Lines.Strings[i]);
      if p<1 then continue;
      s := Piece2(Lines.Strings[i],'DATE OF NOTE:',2);
      s := Piece(s,'@',1);
      Result := Trim(s);
    end;
  end;

  function HTTPEncode(const AStr: string): string;
  //NOTE: routine from here:
  //   http://www.delphitricks.com/source-code/internet/encode_a_http_url.html
  //NOTE: I modified this to my purposes.  I removed conversion of '/',':'
  const
    //kt original --> NoConversion = ['A'..'Z', 'a'..'z', '*', '@', '.', '_', '-'];
    //kt original#2 --> NoConversion = ['A'..'Z', 'a'..'z', '*', '@', '.', '_', '-', '/', ':'];  //kt
    NoConversion = ['0'..'9', 'A'..'Z', 'a'..'z', '*', '@', '.', '_', '-', '/', ':'];  //kt
  var
    Sp, Rp: PChar;
  begin
    SetLength(Result, Length(AStr) * 3);
    Sp := PChar(AStr);
    Rp := PChar(Result);
    while Sp^ <> #0 do begin
      if Sp^ in NoConversion then
        Rp^ := Sp^
      //kt else if Sp^ = ' ' then
      //kt   Rp^ := '+'
      else begin
        FormatBuf(Rp^, 3, '%%%.2x', 6, [Ord(Sp^)]);
        Inc(Rp, 2);
      end;
      Inc(Rp);
      Inc(Sp);
    end;
    SetLength(Result, Rp - PChar(Result));
  end;

  function HTMLContainsVisibleItems(const x: string): Boolean;
  { returns true if the string contains visible items }
  //This is an analog of function ORFn.ContainsVisibleChar
  //For now, I am only going to check for  <img and <embed
  //This is not a complete check, by far, but I am only checking
  //   then when HTMLEditor.GetText = '';
  var Text : string;
  begin
    Text := x;
    //Result := (Pos('<img src=',x)>0) or (Pos('<embed src=',x)>0);
    Text := AnsiReplaceStr(x, '&nbsp;','');
    //NOTE: the function below strips ALL tags from a text to see if what
    //      is left has something.  But it would be more effectient to just
    //      remove tags until a tag is not the first thing found in the string.
    //      Will consider this in the future if this function turns out to slow program
    StripTags(Text);
    Text := Trim(Text);
    Result := (Text <> '');
  end;

  function HTMLContainsImages(const x: string): Boolean;
  //kt 5/15.  Moved from HTMLContainsVisibleItems.
  begin
    Result := (Pos('<img src=',x)>0) or (Pos('<embed src=',x)>0);
  end;

  procedure ResolveEmbeddedTemplates(Drawers : TObject);  //Drawers must actually be of type TfrmDrawers

  var Found       : boolean;
      Temp        : string;
      HtmlEditor : THtmlObj;
      TypedDrawers : TfrmDrawers;
      SavedSelRange : TRangeInfo; //kt 4/8/21
  begin
    if not (Drawers is TfrmDrawers) then exit;
    TypedDrawers := TfrmDrawers(Drawers);
    HtmlEditor := TypedDrawers.HTMLEditControl;
    SavedSelRange := HtmlEditor.SelectionInfo; //kt 4/8/21
    repeat
      Found := HtmlEditor.FindFirst(EMBEDDED_TEMPLATE_START_TAG);
      if not Found then break;
      Found := HtmlEditor.FindNextExtendingSelection(EMBEDDED_TEMPLATE_END_TAG);
      if not Found then break;
      Temp := HtmlEditor.SelText;
      HtmlEditor.SelText := '';
      //HtmlEditor.Selection.clear();
      Temp := piece2(Temp, EMBEDDED_TEMPLATE_START_TAG, 2);
      Temp := piece2(Temp, EMBEDDED_TEMPLATE_END_TAG, 1);
      //Messagedlg('Here I can insert: '+Temp, mtInformation, [mbOK],0);
      TypedDrawers.InsertTemplatebyName(Temp);
    until false;
    HtmlEditor.SetSelectionByRangeInfo(SavedSelRange); //kt 4/8/21
  end;

  procedure StripTags(var S : string);
  //Purpose: remove all tags from S.  e.g. '<b>Cat</>' --> 'Cat'
  //This does NOT account for open or end tags inside quotes.  It treats all the same.
  var p1,p2 : integer;
  begin
    repeat
      p1 := Pos('<',S);
      if p1 > 0 then begin
        p2 := PosEx('>', S, p1);
        if p2 > 0 then begin
          S := LeftStr(S, p1-1) + MidStr(S, p2+1, length(S));
        end;
      end;
    until (p1 = 0);
  end;

  procedure StripQuotes(SL : TStrings; QtChar: char);
  var S : string;
      p1, p2 : integer;
  begin
    S := SL.Text;
    p1 := Pos(QtChar, S);
    while p1 > 0 do begin
      p2 := PosEx(QtChar, S, p1+1);
      if p2 = 0 then begin p1 := 0; break; end;
      if S[p2+1] = QtChar then begin  // look for "asdfasdf""sadfasdf" pattern  (double Qt as escaped char)
        p2 := PosEx(QtChar, S, p2+2);
        if p2 = 0 then begin p1 := 0; break; end;
      end;
      s := LeftStr(S, p1-1) + MidStr(S,P2+1, MaxInt);
      p1 := Pos(QtChar, S);
    end;
  end;

  procedure StripBetweenChars(var s : string; OpenChar, CloseChar : char; StartPos: integer = 1; NumToDel : integer = MaxInt);
  //NOTE: don't use with OpenChar = CloseChar, or with OpenChar or CloseChar being ' or "
  var i, depth, p1, p2 : integer;
      InSingleQt, InDoubleQt : boolean;
  begin
    InSingleQt := false;
    InDoubleQt := false;
    p1 := PosEx(OpenChar, S, StartPos);
    while (p1 > 0) and (NumToDel > 0) do begin
      depth := 0;
      i := p1;
      while i < length(S) do begin
        if s[i] = '''' then begin
          if not InDoubleQt then InSingleQt := Not InSingleQt;
        end else if s[i] = '"' then begin
          if not InSingleQt then InDoubleQt := Not InDoubleQt;
        end else if ((not InSingleQt) and (not InDoubleQt)) then begin  //ignore braces in quotes
          if S[i] = OpenChar then begin
            inc(depth);
          end else if S[i] = CloseChar then begin
            dec(depth);
            if depth<1 then begin
              p2 := i;
              S := LeftStr(S, p1-1) + MidStr(S, p2+1, MaxInt);
              Dec(NumToDel);
              break;
            end;
          end;
        end;
        inc(i);
      end;
      if depth > 0 then begin  //unmatched braces
        S := LeftStr(S, p1-1); //trim to end of string.
      end;
      p1 := Pos(OpenChar, S);
    end;
  end;

  procedure StripBetweenChars(SL : TStrings;  OpenChar, CloseChar : char; StartPos: integer = 1; NumToDel : integer = MaxInt);
  var s : string;
  begin
    s := SL.Text;
    StripBetweenChars(s, OpenChar, CloseChar, StartPos, NumToDel);
    SL.Text := s;
  end;

  procedure StripBraces(var s : string; StartPos: integer = 1; NumToDel : integer = MaxInt);
  begin
    StripBetweenChars(s, '{', '}', StartPos, NumToDel);
  end;

  procedure StripBraces(SL : TStrings; StartPos: integer = 1; NumToDel : integer = MaxInt);
  begin
    StripBetweenChars(SL, '{', '}', StartPos, NumToDel);
  end;


  procedure StripBetweenTags(SL : TStrings; OpenTag, CloseTag : string;
                                      StartLineIdx : Word = 0; Count : Word = 9999);
  type SLPos = record LineIdx, LinePos : integer; end;
  var Pos : SLPos;
      StartPos, EndPos : SLPos;
      pOpen, pClose : integer;
      s : string;
      BracketLevel : integer;

    procedure TrimSL(SL : TStrings; StartPos, EndPos : SLPos);
    var s, PartB : string;
        i : integer;
    begin
      s := SL.Strings[StartPos.LineIdx];
      s := MidStr(s, 1, StartPos.LinePos - 1);
      SL.Strings[StartPos.LineIdx] := s;   //trim the first line of range
      s := SL.Strings[EndPos.LineIdx];
      PartB := MidStr(s, EndPos.LinePos + 1, Length(s));
      SL.Strings[EndPos.LineIdx] := PartB;  // trim the last list of range
      for i := EndPos.LineIdx - 1 downto StartPos.LineIdx + 1 do begin
        SL.Delete(i);  //trim all intervening lines
      end;
    end;

  begin
    Pos.LineIdx := StartLineIdx;  Pos.LinePos := 0;
    BracketLevel := 0;
    while (Pos.LineIdx < SL.Count) and (Count > 0) do begin
      s := SL.Strings[Pos.LineIdx];
      while (Pos.LinePos < Length(s)) and (Count > 0) do begin
        pOpen := PosEx(OpenTag, s, Pos.LinePos + 1);
        if (OpenTag = CloseTag) and (pOpen > 0) then begin
          pClose := PosEx(CloseTag, s, pOpen+1);
        end else begin
          pClose := PosEx(CloseTag, s, Pos.LinePos + 1);
        end;
        if (CloseTag = CRLF) and (pClose = 0) then pClose := length(s);
        if (pOpen > 0) and ((pClose = 0) or (pOpen < pClose)) then begin
          Pos.LinePos := pOpen;
          if BracketLevel = 0 then begin
            StartPos := Pos;
          end;
          inc(BracketLevel);
        end else if (pClose > 0) and ((pOpen = 0) or (pClose < pOpen)) then begin
          Pos.LinePos := pClose + length(CloseTag)-1;
          if BracketLevel > 0 then begin
            Dec(BracketLevel);
            if BracketLevel = 0 then begin
              EndPos := Pos;
              TrimSL(SL, StartPos, EndPos);
              Pos.LineIdx := StartPos.LineIdx-1;
              Pos.LinePos := 0;
              Dec(Count);
              break;
            end;
          end;
        end else begin
          Pos.LinePos := Length(s) + 1;  //signal to go to next line.
        end;
      end;
      Inc(Pos.LineIdx);
      Pos.LinePos := 0;
    end;
  end;

  procedure TrimFunction(SL : TStrings; FnStr : string);
  var  p,p2 : integer;
       s : string;
  begin
    s := SL.Text;
    p := Pos(FnStr, s);
    if p = 0 then exit;
    p2 := PosEx('(', s, p);
    if p2=0 then exit;
    s := LeftStr(s, p-1) + MidStr(s, p2, MaxInt);
    StripBetweenChars(s, '(', ')', p, 1);
    StripBraces(s, p, 1);
    SL.Text := s;
  end;

  procedure SummarizeScript(InSL, OutSL : TStrings);
  //Return in OutSL a list of names of all defined function.
  var s : string;
      p, p2, i : integer;
      TempSL : TStringList;
      lcText, Text : string;
  const FN = 'function';
  begin
    TempSL := TStringList.Create;
    try
      TempSL.Assign(InSL);
      StripBetweenTags(TempSL,'/*', '*/');  //remove multi-line comments
      StripBetweenTags(TempSL,'//', CRLF);  //remove single-line comments
      StripBraces(TempSL);
      //StripQuotes(TempSL, '"');
      //StripQuotes(TempSL, '''');
      Text := TempSL.Text;
      lcText := LowerCase(TempSL.Text);
      p := Pos(FN, lcText);
      while p > 0 do begin
        p := p + length(FN);
        p2 := PosEx('(', lcText, p);  //Get
        if p2 > 0 then begin
          s := Trim(MidStr(Text, p, p2-p));
          s := StringReplace(s, #$0D, '', [rfReplaceAll]); s := StringReplace(s, #$0A, '', [rfReplaceAll]);
          if s <> '' then OutSL.Add(s);
        end;
        p := PosEx(FN, lcText, p);
      end;
      (*
      StripBetweenTags(TempSL,'{', '}');
      for i:= 0 to TempSL.Count - 1 do begin
        s := Trim(TempSL.Strings[i]);
        if (s = '') or (s=';') then continue;
        OutSL.Add(s);
      end;
      *)
    finally
      TempSL.Free;
    end;
  end;

  function EvalFixHTMLElement(Element: IHTMLElement) : boolean;
  //Result: true ==> abort / stop   (i.e. result is Error state)
  //        false ==> OK to continue
  //this function strips:
  //   all event handlers
  //   <Script> blocks
  //   <a> blocks with href containing 'javascript'
  var
    //Element2 :       IHTMLElement2;
    ChildList:       IHTMLElementCollection; // all elements in parent element
    ChildElement:    IHTMLElement;
    GenElement:      DispHTMLGenericElement;
    AttributeList:   IHTMLAttributeCollection;
    Attribute:       IHTMLDOMAttribute;
    AttribName:      string;
    Tagname:         string;
    AttribValue:     OleVariant;
    AttribStrValue:  string;
    i:               integer;
  begin
    Result := false;
    try
      if Supports(Element, DispHTMLGenericElement, GenElement) then begin
        if Supports(GenElement.attributes, IHTMLAttributeCollection, AttributeList) then begin
          //for i := 0 to AttributeList.length - 1 do begin
          for i := AttributeList.length - 1 downto 0 do begin
            if not Supports(AttributeList.item(i), IHTMLDOMAttribute, Attribute) then continue;
            AttribName := Attribute.NodeName;
            if UpperCase(LeftStr(AttribName, 2)) <> 'ON' then continue;   //looking only for event handlers
            AttribValue := Attribute.nodeValue;
            if (AttribValue = Null) or (AttribValue = '') then continue;
            Element.removeAttribute(AttribName, 0);   //0 -> case-insensitive
          end;
        end;
      end;
      TagName := UpperCase(Element.tagName);
      if TagName = 'A' then begin  //<A>  </A> blocks
        AttribValue := Element.GetAttribute('href',0);
        if (AttribValue <> Null) and (AttribValue <> '') then begin
          AttribStrValue := UpperCase(AttribValue);
          if Pos('JAVASCRIPT', AttribStrValue) > 0 then begin
            Element.outerHTML := '';  //this should cause it to be deleted
            exit;
          end;
        end;
      end;
      if TagName = 'INPUT' then begin
        AttribValue := Element.GetAttribute('type',0);
        if (AttribValue <> Null) and (AttribValue <> '') then begin
          AttribStrValue := UpperCase(AttribValue);
          if Pos('SUBMIT', AttribStrValue) > 0 then begin
            Element.outerHTML := '';  //this should cause it to be deleted
            exit;
          end;
        end;
      end;
      if not Supports(Element.Children, IHTMLElementCollection, ChildList) then exit;
      for i := 0 to ChildList.length-1 do begin
        ChildElement := ChildList.item(i, EmptyParam) as IHTMLElement;
        if ChildElement.tagName = 'SCRIPT' then begin
          ChildElement.outerHTML := '';  //this should cause it to be deleted
          continue;
        end;
        //do something here to look at this element
        Result := EvalFixHTMLElement(ChildElement);
        if Result = true then break;
      end;
    finally
      //
    end;
  end;

  procedure StripJavaScript(SL: TStrings; var Modified : boolean);
  //http://stackoverflow.com/questions/14348346
  //http://stackoverflow.com/questions/11915903
  var
    ADoc:      IHTMLDocument2; //OleVariant;
    V,el:      OleVariant;
    i:         Integer;
    Temp :     HRESULT;
    Body:      IHTMLElement;          // document body element
    Elements:  IHTMLElementCollection; // all tags in document body
    AElement:  IHTMLElement;          // a tag in document body
    HTML:      String;
    Abort:     boolean;

  begin
    Modified := false;
    try
      ADoc := coHTMLDocument.Create as IHTMLDocument2;
      V := VarArrayCreate([0,0], varVariant);
      V[0] := SL.Text;
      ADoc.Write(PSafeArray(TVarData(V).VArray)); // write data from input
      ADoc.close;
      if not Supports(ADoc.body, IHTMLElement, Body) then exit;
      Abort := EvalFixHTMLElement(Body);
      if Abort then exit;
      //PULL HTML BACK OUT OF DOCUMENT AND PASS BACK IN SL
      HTML := Body.OuterHTML;
      SL.Text := HTML;
    finally
      ADoc := nil;
      Finalize(V);
    end;
  end;


  function GetWebBrowserHTML(const WebBrowser: TWebBrowser): String;
  //from here: http://www.cryer.co.uk/brian/delphi/twebbrowser/get_HTML.htm
  var document : IHTMLDocument2;
  begin
    result := '';
    document := webBrowser.Document as IHTMLDocument2;
    if not assigned(document) then exit;
    result := document.body.innerHTML;
  end;

  procedure WBLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string);
  var
     MyHTML: TStringList;
     TempFile: string;
  begin
     MyHTML := TStringList.create;
     TempFile := UniqueCacheFName('Temp.html');
     try
       MyHTML.add(HTMLCode);
       MyHTML.SaveToFile(TempFile);
      finally
       MyHTML.Free;
      end;
     WebBrowser.Navigate(TempFile) ;

     while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
      Application.ProcessMessages;
  end;  {WBLoadHTML}


  //===============================================================

  Constructor TPrinterEvents.Create;
  begin
    RestorePrinterTimer := TTimer.Create(frmNotes);
    RestorePrinterTimer.Enabled := false;
    RestorePrinterTimer.Interval := 30000; //30 seconds to complete print job.
    RestorePrinterTimer.OnTimer := HandleRestorePrinting;
    PrintingNow := false;
  end;

  Destructor TPrinterEvents.Destroy;
  begin
    RestorePrinterTimer.Free;
    inherited Destroy;
  end;


  procedure TPrinterEvents.HandleRestorePrinting (Sender: TObject);
  begin
    if PrinterEvents.PrintingNow then begin
      RestorePrinterTimer.Enabled := true; // reset timer for later.
      exit;
    end;
    RestorePrinterTimer.Enabled := false;
    RestoreIEPrinting;   {elh 6/19/09}  //kt
    //kt SetDefaultPrinter(SavedDefaultPrinter);
    //beep;
  end;

  //===============================================================

  function EncodePath(var Path : string) : string;
  begin
    Result := AnsiReplaceStr(Path,'\','/');
    Result := HTTPEncode(Result);
  end;

function FormatHTMLClipboardHeader(HTMLText: string): string;
const
  CrLf = #13#10;
begin
  Result := 'Version:0.9' + CrLf;
  Result := Result + 'StartHTML:-1' + CrLf;
  Result := Result + 'EndHTML:-1' + CrLf;
  Result := Result + 'StartFragment:000081' + CrLf;
  Result := Result + 'EndFragment:같같같' + CrLf;
  Result := Result + HTMLText + CrLf;
  Result := StringReplace(Result, '같같같', Format('%.6d', [Length(Result)]), []);
end;

//The second parameter is optional and is put into the clipboard as CF_HTML.
//Function can be used standalone or in conjunction with the VCL clipboard so long as
//you use the USEVCLCLIPBOARD conditional define
//($define USEVCLCLIPBOARD}
//(and clipboard.open, clipboard.close).
//Code from http://www.lorriman.com
procedure CopyHTMLToClipBoard(const str: AnsiString; const htmlStr: AnsiString = '');
var
  gMem: HGLOBAL;
  lp: PChar;
  Strings: array[0..1] of AnsiString;
  Formats: array[0..1] of UINT;
  i: Integer;
begin
  gMem := 0;
  {$IFNDEF USEVCLCLIPBOARD}
  Win32Check(OpenClipBoard(0));
  {$ENDIF}
  try
    //most descriptive first as per api docs
    Strings[0] := FormatHTMLClipboardHeader(htmlStr);
    //Strings[1] := str;
    Formats[0] := RegisterClipboardFormat('HTML Format');
    //Formats[1] := CF_TEXT;
    {$IFNDEF USEVCLCLIPBOARD}
    Win32Check(EmptyClipBoard);
    {$ENDIF}
    for i := 0 to High(Strings) do
    begin
      if Strings[i] = '' then Continue;
      //an extra "1" for the null terminator
      gMem := GlobalAlloc(GMEM_DDESHARE + GMEM_MOVEABLE, Length(Strings[i]) + 1);
      {Succeeded, now read the stream contents into the memory the pointer points at}
      try
        Win32Check(gmem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, PChar(Strings[i]), Length(Strings[i]) + 1);
      finally
        GlobalUnlock(gMem);
      end;
      Win32Check(gmem <> 0);
      SetClipboardData(Formats[i], gMEm);
      Win32Check(gmem <> 0);
      gmem := 0;
    end;
  finally
    {$IFNDEF USEVCLCLIPBOARD}
    Win32Check(CloseClipBoard);
    {$ENDIF}
  end;
end;


procedure MakeWrapperHTMLFile(FullFilePathName, TargetSaveFilePathName : string; Parent:TControl; FileType: TFileType);
var
   MyHTML: TStringList;
   HTML : string;
   TempFile: string;
begin
  //HTML := '<embed src="file://'+PDFFullFilePathName+'" width="800px" height="1200px" />';
  case FileType of
  tftPDF:
    HTML := '<BODY contentEditable=false><EMBED height='+inttostr(Parent.height-40)+' width='+inttostr(Parent.width-40)+' src="'+FullFilePathName+'"></BODY>';
  tftImage:
    HTML := '<img height='+inttostr(Parent.height-40)+' width='+inttostr(Parent.width-40)+' src="'+FullFilePathName+'">';
  end;
  MyHTML := TStringList.create;
  try
    MyHTML.add(HTML);
    MyHTML.SaveToFile(TargetSaveFilePathName);
  finally
    MyHTML.Free;
  end;
end;


function UniqueCacheFName(FName : string) : AnsiString;
//NOTE: FName should not include path.

var  Ext, PartA, TempFName : AnsiString;
     Num, count : integer;
begin
  //Num := NumPieces(CPRSCacheDir + FName, '.');
  //if Num < 2 then Num := 2;
  Ext := ExtractFileExt(FName);
  PartA := CPRSCacheDir + piece(extractfilename(FName),'.',1); //the piece function should be replace with a more robust one that handles a file with multiple periods
  count := 0;
  TempFName := PartA + Ext;
  While fileExists(tempFName) do begin
    inc(count);
    tempFName := PartA + IntToStr(count) + '.' + Ext;
  end;
  result := tempFName;
end;

function StripHTMLTags(strHTML: string): string;
var
  P: PChar;
  InTag: Boolean;
  i, intResultLength: Integer;
begin
  strHTML := StringReplace(strHTML, '<BR>', '@@BR@@',  [rfReplaceAll]);
  P := PChar(strHTML);
  Result := '';

  InTag := False;
  repeat
    case P^ of
      '<': InTag := True;
      '>': InTag := False;
      #13, #10: ; {do nothing}
      else
        if not InTag then
        begin
          if (P^ in [#9, #32]) and ((P+1)^ in [#10, #13, #32, #9, '<']) then
          else
            Result := Result + P^;
        end;
    end;
    Inc(P);
  until (P^ = #0);

  {convert system characters}
  Result := StringReplace(Result, '&quot;', '"',  [rfReplaceAll]);
  Result := StringReplace(Result, '&apos;', '''', [rfReplaceAll]);
  Result := StringReplace(Result, '&gt;',   '>',  [rfReplaceAll]);
  Result := StringReplace(Result, '&lt;',   '<',  [rfReplaceAll]);
  Result := StringReplace(Result, '&amp;',  '&',  [rfReplaceAll]);
  Result := StringReplace(Result, '&nbsp;', ' ',  [rfReplaceAll]);
  Result := StringReplace(Result, '@@BR@@', #13#10,  [rfReplaceAll]);
  {here you may add another symbols from RFC if you need}
end;

function GetTag(HTMLText : string; TagName : string; var PartA, PartB : string; AttributesSL : TStringList) : string;
//Input: HTMLText: the HTML formated input string
//       TagName: the tag name to search for, e.g. 'img' to search for '<img ... >' tag.  NOT case sensitive.
//       PartA: an OUT parameter.  Returns all text BEFORE (e.g.) '<img ... >'
//       PartBA: an OUT parameter.  Returns all text AFTER  (e.g.) '<img ... >'
//       AttributeSL: an OUT parameter.  Optional.  If provided, then will be filled with attributes.
//             syntax:  <AttributeName>=<value>  Value will not be quotes, ' or "
//Result:  Result will be the text of the tag, e.g. '<img ... >', including < and >
begin
 //finish.
end;


function HTMLResize(ImageFName: string) : string;
var
  NewHeight : real;
  Image: TImage;
const
  MaxWidth : integer = 640;
begin
  Image := TImage.Create(Application);
  Image.Picture.LoadFromFile(ImageFName);
  if Image.Picture.Width > MaxWidth then begin
    NewHeight := (MaxWidth/Image.Picture.Width)*Image.Picture.Height;
    Result := 'WIDTH=' + inttostr(MaxWidth) + ' HEIGHT=' + floattostr(NewHeight) + ' ';
  end else begin
    Result := '';
  end;
  Image.Free;
end;

function GetInsertImgHTMLName(Name: string; PropSL : TStringList = nil): string;
//kt 9/11 added function
//Format of PropSL is '<AttributeName>^<AttributeValue>'  Should not contain " char
var  ImageFName : string;
     SizeString : string;
     i : integer;
     AttrName, AttrValue : string;

begin
  if Name = '' then exit;
  //Should I test for file existence?
  ImageFName := CPRSCacheDir + Name;
  SizeString := HTMLResize(ImageFName);
  Result := '<img src="'+ ImageFName + '" ' + SizeString + ' '; //kt 8/19/21 //+ ALT_IMG_TAG_CONVERT + ' '
  if assigned(PropSL) then begin
    for i := 0 to PropSL.Count - 1 do begin
      AttrName := PropSL.Names[i];  if AttrName='' then continue;
      AttrValue := PropSL.ValueFromIndex[i];  if AttrValue='' then continue;
      Result := Result + AttrName+'="'+AttrValue+'" ';
    end;
  end;
  Result := Result + '>';
end;


function SelectExistingImageClick() : string;
//kt 9/11 added function
var
  ImageFName : string;
  frmImagePickExisting: TfrmImagePickExisting;

begin
  Result := '';
  frmImagePickExisting := TfrmImagePickExisting.Create(Application);
  try
    if frmImagePickExisting.ShowModal = mrOK then begin
      ImageFName := frmImagePickExisting.SelectedImageFName;
      if ImageFName <> '' then Result := GetInsertImgHTMLName(ImageFName);
    end;
  finally
    FreeAndNil(frmImagePickExisting);
  end;
end;

function Make2ColHTMLTable(SourceSL : TStringList; Options : TStringList=nil) : string;
//Input: SourceSL is source input.  Format: every other line will be right vs left column.
//       Options.  OPTIONAL.  This is TStringList in Key-Value mode.  E.g. Title=My Title.  Supported key names
//             l-title
//             r-title
//             border

//Output is string with HTML for table.
var
  i : integer;
  StrL, StrR : string;
  s : string;
  Output : TStringList;
  LTableTitle, RTableTitle, BorderSize : string;

  function ItemDef(Items : TStrings; i : integer; default : string = '') : string;
  begin
    Result := default;
    if not assigned(Items) then exit;
    if (i < 0) or (i >= Items.Count) then exit;
    Result := Items[i];
  end;

begin
  if Assigned(Options) then begin
    s := Options.Values['l-title'];
    LTableTitle := IfThen(s<>'', s, 'Table');

    s := Options.Values['r-title'];
    RTableTitle := IfThen(s<>'', s, 'VALUE');

    s := Options.Values['border'];
    BorderSize := IfThen(s<>'', s, '1');
  end else begin
    LTableTitle := 'Table';
    RTableTitle := 'VALUE';
    BorderSize := '1';
  end;

  Output := TStringList.Create;
  try
    i := 0;
    while i< SourceSL.count do begin
      StrL := ItemDef(SourceSL, i);
      StrR := ItemDef(SourceSL, i+1);
      inc(i, 2);
    end;

    Output.Add('<table border='+BorderSize+'>');
    Output.Add('<TR><th>'+LTableTitle+'</th> <th>'+RTableTitle+'</th></TR>');

    i := 0;
    while i< SourceSL.count do begin
      StrL := ItemDef(SourceSL, i);
      StrR := ItemDef(SourceSL, i+1);
      s := '<tr><td>' + strL + '</td><td>' + strR + '</td></tr>';
      Output.Add(s);
      inc(i, 2);
    end;

    Output.Add('</table>');
  finally
    Result := Output.Text;
    Output.Free;
  end;
end;




initialization
  DesiredHTMLFontSize := 2; //probably overwritten in fNotes initialization
  PrinterEvents := TPrinterEvents.Create;
  //CPRSDir := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  CPRSDir := ExcludeTrailingPathDelimiter(GetEnvironmentVariable('USERPROFILE')+'\.CPRS');
  URL_CPRSDir := EncodePath(CPRSDir);
  CPRSCacheDir := CPRSDir +'\Cache\';
  SubsFoundList := TStringList.Create;

finalization
  //kt causing crash -->  Reg.WriteString('footer',StoredIEFooters);
  //RestoreIEPrinting;
  PrinterEvents.Free;
  SubsFoundList.Free;

end.
