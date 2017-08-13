unit uHTMLDlgObjs;
//kt added entire unit

{
  This unit contains classes to act as Delphi wrappers for JavaScript objects, that will exist in an HTML document.
  It will contain code to create the javascript objects, and also code to get the value for the object back out
  of the document.

    THTMLObjHandler = class(TObject)  <-- One for each TYPE of object (e.g. Checkbox, editbox), not one for each instance
    THTMLObjHandlersList = class(TObject) <-- a lost of all the Obj Handlers.
}

 (*
 NOTE: The original version of this file may be obtained freely from the VA.

 This file is Copyright 3/6/2015 Kevin S. Toppenberg, MD
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

uses
  SysUtils, StrUtils, Classes, Controls, TMGHTML2, uHTMLTools, MSHTML_EWB,
  DateUtils, ORFn ;


  type
    //Note: HtmlDlg should be passed in as type THTMLDlg or THTMLTemplateDialogEntry
    TElementAddProc = procedure (HtmlDlg : TObject; Source, Attribs, Output, Content, ScriptCode, StyleCodes : TStringList; var OutID : string);
    TElementGetValueFn = function(HtmlDlg : TObject; Elem : IHTMLElement; NoCommas : boolean = false) : string;

    THTMLObjHandler = class(TObject)
    private
      FStartTag : string;
      FEndTag : string;
      FAddProc : TElementAddProc;
      FGetValFn : TElementGetValueFn;
      //FIsContainer : boolean;  //a container tag will not have any content.  And there will be other controls between start and end tag
    public
      constructor Create(WebBrowser: THtmlObj;
                         AStartTag, AnEndTag : string;
                         AnAddProc : TElementAddProc;
                         AGetValFn : TElementGetValueFn{;
                         IsContainer : boolean});
      property StartTag : string read FStartTag;
      property EndTag : string read FEndTag;
      property AddProc : TElementAddProc read FAddProc;
      //property IsContainer : boolean read FIsContainer;
    end;

    THTMLObjType = (tString, tWP);

    THTMLObjHandlersList = class(TObject)
    private
      FWebBrowser : THtmlObj;
      procedure FindControlGroupProperty(Elem : IHTMLElement; Msg : string; Obj : TObject; var Found : boolean);
      function IsDisabledByControlGroup(HtmlDlg : TObject; Elem : IHTMLElement) : boolean;
    Public
      ObjsList  : TStringList;
      function HasHTMLObjTag(SourceLine : string; var OutHandler : THTMLObjHandler) : boolean;
      function GetValue(HtmlDlg : TObject; id, StartTag : string; var Disabled : boolean; NoCommas : boolean = false) : string;
      procedure Clear;
      constructor Create(AWebBrowser: THtmlObj);
      destructor Destroy;
    end;

  function SLStr(SL : TStringList) : string;
  procedure ExtractAttribs(StartTag : string; Source, Attrs: TStringList); overload;
  procedure ExtractAttribs(StartTag, Source : string; Attrs: TStringList); overload;
  procedure EnsureClass(Attrs : TStringList; ClassName : string);
  procedure AddNumberHandlerCode(ScriptCode : TStringList);
  function AddElement(ElementName : string; Attrs, Content, Output : TStringList; NoCloser : boolean = false) : string;
  procedure AddGetCtrlValCode(ScriptCode : TStringList);
  procedure AddSetCtrlValCode(ScriptCode : TStringList);
  procedure AddGetDlgHandleCode(ScriptCode : TStringList);

const
  EMBEDDED_DLG_CLASS = 'tmgembeddeddlg';
  EMBEDDED_RESULT_SUFFIX = '_result';
  EMBEDDED_SOURCE_SUFFIX = '_source';
  EMBEDDED_STORE_SUFFIX = '_storage';
  EMBEDDED_DLG_RESULT_CLASS = EMBEDDED_DLG_CLASS + EMBEDDED_RESULT_SUFFIX;
  EMBEDDED_DLG_SOURCE_CLASS = EMBEDDED_DLG_CLASS + EMBEDDED_SOURCE_SUFFIX;
  EMBEDDED_DLG_STORE_CLASS = EMBEDDED_DLG_CLASS + EMBEDDED_STORE_SUFFIX;
  HIDDEN_CLASS = 'tmghidden';
  PROP_DEF_TEXT = 'DefText';
  PROP_DEF_TEXT_CTRL_ID = 'DefTextWithCtrlID';

  //----- Constants for style of dialog--------------------
  COLOR_LIGHT_BLUE = '#e5f2ff';
  COLOR_LIGHT_GREEN = '#e6fff7';
  COLOR_DLG_BACKGROUND = COLOR_LIGHT_BLUE;
  FONT_DLG_SIZE = '80%';
  COLOR_WP_BACKGROUND = 'white';
  //-------------------------------------------------------

implementation
  uses uHTMLDlg, uHTMLTemplateFields
       {,Monkey_Datepicker} , TMGInlineHTMLDatePicker
       ;

  var IDMasterIndex : LongWord;  //Will be a master ID counter for all objects

  procedure ExtractAttribs(StartTag, Source : string; Attrs: TStringList);
  var strAttribs    : string;
      i, Len        : integer;
      OneAttrib     : string;
      ch            : char;
      QuoteCh       : char;
      InQuote, Done : boolean;
  begin
    Attrs.Clear;
    strAttribs := ORFn.piece2(Source, StartTag, 2);
    strAttribs := ORFn.piece2(strAttribs,'>',1);
    while strAttribs <> '' do begin
      strAttribs := TrimLeft(strAttribs);
      InQuote := false;
      Done := false;
      Len := Length(strAttribs);
      for i := 1 to Len do begin
        ch := strAttribs[i];
        if ch in ['"',''''] then begin
          if not InQuote then begin
            QuoteCh := ch;
            InQuote := true;
          end else if ch = QuoteCh then begin
            Done := true;
          end;
        end;
        if (ch = ' ') and not InQuote then Done := true;
        if i = Len then Done := true;
        OneAttrib := OneAttrib + ch;
        if Done then begin
          //pull off OneAttrib out of strAtribs, shortening latter....
          strAttribs := MidStr(strAttribs, length(OneAttrib)+1, length(strAttribs));
          Attrs.Add(OneAttrib);
          OneAttrib := '';
          break;
        end;
      end;
    end;
  end;

  procedure ExtractAttribs(StartTag : string; Source, Attrs: TStringList);
  begin
    ExtractAttribs(StartTag, Source.Text, Attrs);
  end;

  procedure EnsureClass(Attrs : TStringList; ClassName : string);
  var s : string;
  begin
    //if class= attrib already found, then add class name to that value
    //otherwise add new attrib of class=ClasName
    s := Attrs.Values['class'];
    s := StringReplace(s, '"', '', [rfReplaceAll]);
    if Pos(ClassName, s) = 0 then begin
      if s <> '' then s := s + ' ';
      s := s + ClassName
    end;
    Attrs.Values['class'] := '"' + s + '"';
  end;

  function SLStr(SL : TStringList) : string;
  //Return TStringList.Text, with terminal CRLF removed.
  var Len, PosNum : integer;
  begin
    if not assigned(SL) then begin Result := ''; exit; end;
    Result := SL.Text;
    Len := Length(Result); PosNum := Len;
    while (PosNum > 0) and (Result[PosNum] in [#10, #13]) do dec(PosNum);
    if PosNum <> Len then Result := MidStr(Result, 1, PosNum);
  end;

  function AddElement(ElementName : string; Attrs, Content, Output : TStringList; NoCloser : boolean = false) : string;
  (* Input: Source:  -- Format:
      ElementName -- example of type would be "P" (without quotes) for paragraph
      Attrs.Strings[i]:  <attribute_name> =<attribute_value>
      Content.Strings[j]: one or more lines of content.  This will appear between open and close tags
    Output: Output: -- HTML code ready to be passed to WebBrowser
    Result: 1^OK, or -1^Error Message      *)
  var HTML : string;
      Attrib : string;
      i : integer;
  begin
    Result := '1^OK';
    HTML := '<' + ElementName + ' ';
    for i := 0 to Attrs.Count - 1 do begin
      Attrib := Attrs.Strings[i];
      HTML := HTML + Attrib + ' ';
    end;
    HTML := HTML + '>' + SLStr(Content);
    if not NoCloser then HTML := HTML + '</'+ElementName+'>';
    Output.add(HTML);
  end;

  function AttribValue(AttribStr : string) : string;
  var Str : string;
      Len, X  : integer;
  begin
    Str := piece(AttribStr,'=',2);
    //Here I need to trim any quote chars.
    if (Str <> '') and (Str[1] in ['"','''']) then begin
      Len := Length(Str);
      if Str[Len] = Str[1] then X := 1 else X := 0;
      Str := MidStr(Str, 2, Len-1-X);
    end;
    Result := Str;
  end;

  function AttribIdx(AttribName : string; Attrs : TStringList) : integer;
  var i,p : integer;
      s, AKey : string;
  begin
    Result := -1;
    AttribName := UpperCase(AttribName);
    for i := 0 to Attrs.Count - 1 do begin
      s := Attrs.Strings[i];
      p := Pos('=', s);
      if p > 0  then begin
        AKey := UpperCase(MidStr(s, 1, p-1));
      end else begin
        AKey := Trim(s);
      end;
      if AKey = AttribName then begin
        Result := i;
        break;
      end;
    end;
  end;

  function GetAndRemoveAttrib(var OutVal : string; AttribName : string; Attrs : TStringList) : boolean;
  var i : integer;
  begin
    OutVal := '';
    Result := false;  //default
    i := AttribIdx(AttribName, Attrs);
    if i > -1 then begin
      OutVal := Trim(AttribValue(Attrs.Strings[i]));
      Attrs.Delete(i);
      Result := True
    end;
  end;

  function GetAttrib(AttribName : string; Attrs : TStringList) : string;
  var i : integer;
  begin
    Result := '';
    i := AttribIdx(AttribName, Attrs);
    if i > -1 then begin
      Result := Trim(AttribValue(Attrs.Strings[i]));
      if (Result <> '') then begin
        if ((Result[1] = '"')  and (Result[Length(Result)] = '"')) or
           ((Result[1] = '''') and (Result[Length(Result)] = '''')) then begin
          Result := MidStr(Result, 2, Length(Result)-2);
        end;
      end;
    end else Result := '';
  end;

  function NextID : string;
  begin
    IDMasterIndex := IDMasterIndex + 1;
    Result := IntTostr(IDMasterIndex);
  end;

  function EnsureID(Attrs : TStringList) : string;
  begin
    Result := GetAttrib('id', Attrs);
    if Result = '' then begin
      Result := 'TMG'+NextID;
      Attrs.Add('id="'+Result+'"');
    end;
  end;

  function SetupOnChangeEvent(HtmlDlg : TObject; Attrs, ScriptCode : TStringList) : string;
  var
    FnName : string;
    DlgEntry : THTMLTemplateDialogEntry;
    OnChangeHandler : string;
  begin
    Result := '';
    if HtmlDlg is THTMLTemplateDialogEntry then begin
      DlgEntry := THTMLTemplateDialogEntry(HtmlDlg);
      //Below will be true if source template has a user-supplied handleOnChange function to handle events.
      //  it will be set up while parsing source template.
      if not DlgEntry.HasHandleOnChange then exit;
      FnName := 'handleOnChange_'+DlgEntry.TMGDlgID+'(this)'; // <-- NOTE: this is a user-supplied function in the template definition
      Result := 'onchange="'+FnName+'"';
      if assigned(Attrs) then Attrs.Add(Result);
    end;
  end;

  //================================================================================
  //Provided "intrinsic" functions
  //================================================================================
  procedure AddCoreFns(ScriptCode : TStringList);
  var FnDeclaration : string;
  begin
    FnDeclaration := 'function isType(obj,typeName) {';
    if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
    ScriptCode.Add(FnDeclaration);
    ScriptCode.Add('  if ((typeName == null) || (typeof(typeName) !== "string")) return false;');
    ScriptCode.Add('  return ((obj !== null) && (typeof(obj) == typeName)); }');
    ScriptCode.Add('function isObj(obj) {return isType(obj,"object");}');
    ScriptCode.Add('function isStr(s) {return isType(s,"string");}');
    ScriptCode.Add('function getCtrlNum(elem) { var id=getAttrib(elem,"id"); if (id.indexOf("_TMGDlg") == -1) return 0;');
    ScriptCode.Add('  return parseInt(id.split("_")[0].split("ctrl")[1]);}');
    ScriptCode.Add('function ensureStr(s) {if (s == null) return ""; return s.toString();}');
    ScriptCode.Add('function ensureNum(n,DefValue) { if (DefValue == null) DefValue=0; if (n == null) return DefValue;');
    ScriptCode.Add('  var result = parseInt(n); if (isNaN(result)) result=DefValue; return result;}');
    ScriptCode.Add('function getAttrib(e,name) {if (e==null) return ""; return ensureStr(e.getAttribute(ensureStr(name)));}');
    ScriptCode.Add('function getNumAttrib(e,name,DefValue) {return ensureNum(e.getAttribute(name),DefValue);}');
    ScriptCode.Add('function fireOnChange(elem,attribName) { if (!isObj(elem)) return;');
    ScriptCode.Add('  attribName = ensureStr(attribName); if (attribName == "") attribName="onchange";');
    ScriptCode.Add('  try {if (!elem.hasAttribute(attribName)) return;} catch(err) {}');
    ScriptCode.Add('  var HandleChange = elem.onchange; if (HandleChange == null) return;');
    ScriptCode.Add('  if (typeof(HandleChange) == "function") { HandleChange = HandleChange.toString();');
    ScriptCode.Add('    if (HandleChange.indexOf("{") > -1) HandleChange = HandleChange.split("{")[1].split("}")[0]; }');
    ScriptCode.Add('  if (HandleChange == "") return;');
    ScriptCode.Add('  if (HandleChange.indexOf("(") > -1) HandleChange = HandleChange.split("(")[0];');
    ScriptCode.Add('  eval(HandleChange+"(elem)");');
    ScriptCode.Add('}');
    ScriptCode.Add('function indexOf(Arr, Match) { var Result = -1;');
    ScriptCode.Add('  for (var i=0; i < Arr.length; i++) {if (Arr[i] != Match) continue; Result = i; break; }');
    ScriptCode.Add('  return Result; }');
    ScriptCode.Add('function trimStr(x) {return x.replace(/^\s+|\s+$/gm,'''');}');
    ScriptCode.Add('function subtractString(S, RemovePartsArr) {var Arr = S.split(" "), Result = "";');
    ScriptCode.Add('  for (var i=0; i < Arr.length; i++) {if (indexOf(RemovePartsArr, Arr[i]) != -1) continue;');
    ScriptCode.Add('    Result = Result + Arr[i] + " "; }');
    ScriptCode.Add('  return trimStr(Result); }');
    ScriptCode.Add('function ensureString(S, AddPart) {if (indexOf(S.split(" "), AddPart) == -1) S = S + " " + AddPart;');
    ScriptCode.Add('  return trimStr(S); }');
    ScriptCode.Add('function hasClass(elem, ClassName) {return (indexOf(elem.className.split(" "), ClassName)!=-1);}');
  end;

  procedure AddGetDlgHandleCode(ScriptCode : TStringList);
  var FnDeclaration : string;
  begin
    AddCoreFns(ScriptCode);
    FnDeclaration := 'function getDlgHandle(elem) {';
    if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
    ScriptCode.Add(FnDeclaration);
    ScriptCode.Add('  var result = "?";');
    ScriptCode.Add('  if (!isObj(elem)) return result;');
    ScriptCode.Add('  var id = elem.id;');
    ScriptCode.Add('  if (id.indexOf("_") == -1) return result;');
    ScriptCode.Add('  var arr=id.split("_");');
    ScriptCode.Add('  if (arr.length < 2) return result;');
    ScriptCode.Add('  result=arr[1];');
    ScriptCode.Add('  return result;');
    ScriptCode.Add('}');
  end;

  procedure AddGetCtrlElem(ScriptCode : TStringList);
  var FnDeclaration : string;
  begin
    AddCoreFns(ScriptCode);
    FnDeclaration := 'function getCtrlElem(dlgHandle, CtrlNum) {';
    if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
    ScriptCode.Add(FnDeclaration);
    ScriptCode.Add('  var result = null;');
    ScriptCode.Add('  if (!isStr(dlgHandle)) return result;');
    ScriptCode.Add('  var id = "ctrl"+ensureStr(CtrlNum)+"_"+dlgHandle;');
    ScriptCode.Add('  result = document.getElementById(id);');
    ScriptCode.Add('  return result;');
    ScriptCode.Add('}');
  end;

  procedure AddGetCtrlValCode(ScriptCode : TStringList);
  var FnDeclaration : string;
  begin
    AddCoreFns(ScriptCode);
    AddGetCtrlElem(ScriptCode);
    FnDeclaration := 'function getCtrlVal(dlgHandle, CtrlNum) {';
    if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
    ScriptCode.Add(FnDeclaration);
    ScriptCode.Add('  var elem = getCtrlElem(dlgHandle, CtrlNum);');
    ScriptCode.Add('  if (!isObj(elem)) return "";');
    ScriptCode.Add('  var valType = getAttrib(elem, "tmgtype");');
    ScriptCode.Add('  if (valType =="") return "";');
    ScriptCode.Add('  var result;');
    ScriptCode.Add('  var expr = "result = ValGet_"+valType+"(elem);"');
    ScriptCode.Add('  eval(expr);');
    ScriptCode.Add('  return ensureStr(result);');
    ScriptCode.Add('}');
  end;

  procedure AddSetCtrlValCode(ScriptCode : TStringList);
  var FnDeclaration : string;
  begin
    AddCoreFns(ScriptCode);
    FnDeclaration := 'function setCtrlVal(dlgHandle, CtrlNum, newValue) {';
    if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
    ScriptCode.Add(FnDeclaration);
    ScriptCode.Add('  if (typeof(newValue) == "undefined") return "";');
    ScriptCode.Add('  var elem = getCtrlElem(dlgHandle, CtrlNum);');
    ScriptCode.Add('  if (!isObj(elem)) return "";');
    ScriptCode.Add('  var valType = getAttrib(elem, "tmgtype");');
    ScriptCode.Add('  if (valType =="") return "";');
    ScriptCode.Add('  var result;');
    ScriptCode.Add('  var expr = "result = ValSet_"+valType+"(elem, newValue);"');
    ScriptCode.Add('  eval(expr);');
    ScriptCode.Add('  return result;');
    ScriptCode.Add('}');
  end;

  //================================================================================
  //CheckBox
  //================================================================================
  //Note: these controls are added recursively from a Checkbox group.
  //  Therefore, they won't have individual onchange handlers.  Instead, when they
  //  change, it bubbles up and is caught by the group span's onchange handler.

  procedure AddCheckBox(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
  //      OR, HtmlDlg is really of type THTMLTemplateDialogEntry, and should be cast as such before use

    procedure AddValGetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValGet_checkbox(elem) {';   //'checkbox' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (!isObj(elem)) return "";');
      ScriptCode.Add('  if (elem.checked == false) return "";');
      ScriptCode.Add('  return getAttrib(elem, "tmgvalue");');
      ScriptCode.Add('}');
    end;

    procedure AddValSetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValSet_checkbox(elem, boolVal) {';    //'checkbox' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (!isObj(elem)) return;');
      ScriptCode.Add('  if (!isType(boolVal,"boolean")) return;');
      ScriptCode.Add('  elem.checked = boolVal;');
      //tmgvalue attrib is the value if .checked is true.  It doesn't need to be set here.
      ScriptCode.Add('  return;');
      ScriptCode.Add('}');
    end;

  var OnChange, Text : string;
  begin
    //OnChange := SetupOnChangeEvent(HtmlDlg, Attrs, ScriptCode);  <-- no handler here means parent onchange will catch event
    AddValGetter(ScriptCode);
    AddValSetter(ScriptCode);
    Attrs.Add('tmgtype="checkbox"');    //tmgtype attrib must match end of getter & setter function names
    //AddHandlerCode(ScriptCode);
    Id := EnsureID(Attrs);
    Text := SLStr(Content);
    Attrs.Add('type="checkbox"');
    Attrs.Add('tmgvalue="'+Text+'"');
    AddElement('input', Attrs, Content, Output, true);  //<input> doesn't use end tag
  end;

  function GetCheckBoxVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  var inner, outer: string;
      Attrs : TStringList;
  begin
    inner := Elem.innerHTML;
    outer := Elem.outerHTML;
    Attrs := TStringList.Create;
    ExtractAttribs('<INPUT', outer, Attrs);
    if AttribIdx('checked', Attrs) >= 0 then begin
      Result := GetAttrib('tmgvalue', Attrs);
    end else begin
      Result := '';
    end;
    Attrs.Free;
  end;

  //================================================================================
  //CheckBox Group
  //================================================================================

  procedure AddCBGroup(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
  //      OR, HtmlDlg is really of type THTMLTemplateDialogEntry, and should be cast as such before use

    procedure AddValGetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValGet_cbgroup(elem) {';   //'cbgroup' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  //Example result: "Apple^Pear^^Grape" if items 0,1,3 are true, 2 is false');
      ScriptCode.Add('  if (!isObj(elem)) return "";');
      ScriptCode.Add('  var result="";');
      ScriptCode.Add('  var id = getAttrib(elem,"id");');
      ScriptCode.Add('  var count=getNumAttrib(elem,"count",0);');
      ScriptCode.Add('  for (var i=0; i < count; i++) {');
      ScriptCode.Add('    var partID = id+"d"+i.toString();');
      ScriptCode.Add('    var subValue = "";');
      ScriptCode.Add('    var subElem = document.getElementById(partID);');
      ScriptCode.Add('    if (isObj(subElem) && (getAttrib(subElem,"tmgtype")=="checkbox")) {');
      ScriptCode.Add('      if (subElem.checked) subValue = getAttrib(subElem,"tmgvalue");');
      ScriptCode.Add('    }');
      ScriptCode.Add('    if (i > 0) result = result+ "^";');
      ScriptCode.Add('    result = result + subValue;');
      ScriptCode.Add('  }');
      ScriptCode.Add('  return result;');
      ScriptCode.Add('}');
    end;   //AddCBGroup : AddValGetter();

    procedure AddValSetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      //finish!!!
      //Let input be either integer (in which case used as index), or string, which then matches against one option
      FnDeclaration := 'function ValSet_cbgroup(elem, textVal) {';  //'cbgroup' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add(' //Sample input textVal: "T^T^F^T" or "TRUE^TRUE^FALSE^TRUE"');
      ScriptCode.Add('  if (!isObj(elem)) return;');
      ScriptCode.Add('  var Arr = ensureStr(textVal).toUpperCase().split("^");');
      ScriptCode.Add('  var id = getAttrib(elem,"id");');
      ScriptCode.Add('  var count=getNumAttrib(elem,"count",0);');
      ScriptCode.Add('  for (var i=0; i < count; i++) {');
      ScriptCode.Add('    var subElem = document.getElementById(id+"d"+i.toString());');
      ScriptCode.Add('    if (!isObj(subElem) || (getAttrib(subElem,"tmgtype") !=="checkbox")) continue;');
      ScriptCode.Add('    if (i < Arr.length) subValue = (ensureStr(Arr[i][0]) == "T"); else subValue = false;');
      ScriptCode.Add('    subElem.checked = subValue;');
      ScriptCode.Add('  }');
      ScriptCode.Add('  return;');
      ScriptCode.Add('}');
    end;  //AddCBGroup : AddValSetter();

  var OnChange : string;
      tempS : string;
      SL : TStringList;

  begin  //AddCBGroup()
    //AddHandlerCode(ScriptCode);
    OnChange := SetupOnChangeEvent(HtmlDlg, Attrs, ScriptCode);
    AddValGetter(ScriptCode);
    AddValSetter(ScriptCode);
    Attrs.Add('tmgtype="cbgroup"');    //tmgtype attrib must match end of getter & setter function names
    Id := EnsureID(Attrs);
    if GetAndRemoveAttrib(tempS, 'inline', Attrs) then begin
      if UpperCase(tempS) = 'TRUE' then begin
        Attrs.Add('style="display: inline;"');
      end;
    end;
    SL := TStringList.Create;  //empty SL
    AddElement('div', Attrs, SL, Output, true);  //true= no close element.
    SL.Free;
    if HtmlDlg is THTMLDlg then begin
      THTMLDlg(HtmlDlg).AddFromSource(Content);  //recursive call.
    end else if HtmlDlg is THTMLTemplateDialogEntry then begin
      THTMLTemplateDialogEntry(HtmlDlg).AddFromPseudoHTML(Content, StyleCodes, ScriptCode);  //recursive call.
    end;
    Output.add('</div>');
  end;   //AddCBGroup()

  function GetCBGroupVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  var {inner,} outer: string;
      Attrs : TStringList;
      i, count : integer;
      ID, SubID : string;
      SubResult : string;
  begin
    Result := '';
    //inner := Elem.innerHTML;
    outer := Elem.outerHTML;
    Attrs := TStringList.Create;
    ExtractAttribs('<DIV', outer, Attrs);
    count := StrToIntDef(GetAttrib('count', Attrs),0);
    ID := GetAttrib('id', Attrs);
    for i := 0 to Count - 1 do begin
      SubID := ID + 'd' + IntToStr(i);
      //SubResult := THTMLDlg(HTMLDlg).GetValueByID(SubID, NoCommas);
      if HtmlDlg is THTMLDlg then begin
        SubResult := THTMLDlg(HTMLDlg).GetValueByID(SubID, NoCommas);
      end else if HtmlDlg is THTMLTemplateDialogEntry then begin
        SubResult := THTMLTemplateDialogEntry(HTMLDlg).GetValueByID(SubID, NoCommas);
      end;
      if SubResult = '' then continue;
      if Result <> '' then begin
        if not NoCommas then Result := Result + ',';
        Result := Result + ' ';
      end;
      Result := Result + SubResult;
    end;
    Attrs.Free;
  end;

  //================================================================================
  //Dialog Group (embedded dialog)
  //================================================================================

  procedure AddDialogGrp(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
  //      OR, HtmlDlg is really of type THTMLTemplateDialogEntry, and should be cast as such before use
  //This grouping is to be a <SPAN> that surrounds an embedded dialog in a HTML document.
  //NOTE: There will not be a way for a user's template JS to get or set this value.

    procedure AddStyleCode(StyleCodes : TStringList);
    begin
      if StyleCodes.IndexOf('.' + EMBEDDED_DLG_CLASS + ' {') >=0 then exit;
      StyleCodes.Add('.' + EMBEDDED_DLG_CLASS + ' {');
      StyleCodes.Add('  display: block;');
      StyleCodes.Add('  background-color: '+COLOR_DLG_BACKGROUND+';');
      StyleCodes.Add('  font-size: '+FONT_DLG_SIZE+';');
      StyleCodes.Add('  font-family: Arial, Helvetica, sans-serif;');
      StyleCodes.Add('  border-style: solid;');
      StyleCodes.Add('  border-color: gray;');
      StyleCodes.Add('  border-width: 1px;');
      //StyleCodes.Add('  display: block;');
      StyleCodes.Add('}');
      StyleCodes.Add('.' + EMBEDDED_DLG_RESULT_CLASS + ' {');
      StyleCodes.Add('  border-style: none;');
      //StyleCodes.Add('  display: none;');
      StyleCodes.Add('}');
      StyleCodes.Add('.' + HIDDEN_CLASS + ' {');
      StyleCodes.Add('  display: none;');
      StyleCodes.Add('}');
    end; //AddDialogGrp : AddStyleCode()
  var
    SL : TStringList;
    //DefText, DefTextWithCtrlID : string;
    IEN : string;
  begin  //AddDialogGrp()
    Attrs.Add('contenteditable="false"');
    Attrs.Add('class="' + EMBEDDED_DLG_CLASS + '"');
    //GetAndRemoveAttrib(DefText, PROP_DEF_TEXT, Attrs);
    //GetAndRemoveAttrib(DefTextWithCtrlID, PROP_DEF_TEXT_CTRL_ID, Attrs);
    AddStyleCode(StyleCodes);
    Id := EnsureID(Attrs);
    IEN := GetAttrib('IEN', Attrs);
    IEN := StringReplace(IEN, '"', '', [rfReplaceAll]);
    SL := TStringList.Create;  //empty SL -- for first SPAN
    //kt 6/21/16 AddElement('SPAN', Attrs, SL, Output, true);  //true= no close element.
    AddElement('DIV', Attrs, SL, Output, true);  //true= no close element.
    if HtmlDlg is THTMLDlg then begin
      THTMLDlg(HtmlDlg).AddFromSource(Content);  //recursive call.
    end else if HtmlDlg is THTMLTemplateDialogEntry then begin
      THTMLTemplateDialogEntry(HtmlDlg).AddFromPseudoHTML(Content, StyleCodes, ScriptCode);  //recursive call.
    end;
    //kt 6/21/16 Output.add('</SPAN>');
    Output.add('</DIV>');
    //Add <SPAN> to store output/result view of dialog
    SL.clear;
    Attrs.Clear;
    Attrs.Add('class="' + EMBEDDED_DLG_RESULT_CLASS + ' ' + HIDDEN_CLASS + '"');
    Attrs.Add('id="'+Id + EMBEDDED_RESULT_SUFFIX+'"');  //NOTE: if [ID]_result below is changed, must also change THTMLTemplateDialogEntry.ResolveIntoResultDIV
    Attrs.Add('IEN="' + IEN + '"');
    AddElement('SPAN', Attrs, SL, Output);
    Attrs.Clear;
    //Add <SPAN> to store data back into server database.
    Attrs.Add('class="' + EMBEDDED_DLG_STORE_CLASS + ' ' + HIDDEN_CLASS + '"');
    Attrs.Add('id="'+Id + EMBEDDED_STORE_SUFFIX+'"');
    AddElement('SPAN', Attrs, SL, Output);
    SL.Free;
  end;  //AddDialogGrp()

  function GetDialogGpVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  begin
    Result := '';
  end;

  //================================================================================
  //EditBox
  //================================================================================

  procedure AddEditBox(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
    //to do: make an on-change handler such that text is not allowed to be longer than SIZE attrib
    //  This is to be consistent with standard edit box control....

    procedure AddValGetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValGet_editbox(elem) {';   //'editbox' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (!isObj(elem)) return "";');
      ScriptCode.Add('  return ensureStr(elem.value);');
      ScriptCode.Add('}');
    end;  //AddEditBox : AddValGetter()

    procedure AddValSetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValSet_editbox(elem, textVal) {';    //'editbox' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (!isObj(elem)) return;');
      ScriptCode.Add('  textVal = ensureStr(textVal);');
      ScriptCode.Add('  elem.value = textVal;');
      ScriptCode.Add('  return;');
      ScriptCode.Add('}');
    end;  //AddEditBox : AddValSetter()

  var SL       : TStringList;
      OnChange, LabelStr : string;
      i        : integer;
  begin  //AddEditBox()
    OnChange := SetupOnChangeEvent(HtmlDlg, Attrs, ScriptCode);
    AddValGetter(ScriptCode);
    AddValSetter(ScriptCode);
    Attrs.Add('tmgtype="editbox"');    //tmgtype attrib must match end of getter & setter function names
    //AddHandlerCode(ScriptCode);
    Id := EnsureID(Attrs);
    GetAndRemoveAttrib(LabelStr, 'Label', Attrs);
    Attrs.Add('type="text"');
    Attrs.Add('value="'+SLStr(Content)+'"');
    Content.clear;
    SL := TStringList.Create;
    AddElement('input', Attrs, Content, SL, true);  //<input> doesn't use end tag
    for i := 0 to SL.Count - 1 do begin
      if i = 0 then begin
        Output.Add(LabelStr + SL.Strings[i]);
      end else begin
        Output.Add(SL.Strings[i]);
      end;
    end;
    SL.Free;
  end;  //AddEditBox()

  function GetEditBoxVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  var HTML : string;
      Attrs : TStringList;
  begin
    Result := '';
    HTML := Elem.outerHTML;
    Attrs := TStringList.Create;
    ExtractAttribs('<INPUT', HTML, Attrs);
    Result := GetAttrib('value', Attrs);
    Attrs.Free;
  end;


  //================================================================================
  //WP Box
  //================================================================================

  procedure AddWPBox(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
  //NOTE: Change.  The standard way to do this is with <textarea> tag...

    procedure AddValGetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValGet_wpbox(elem) {';   //'wpbox' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (!isObj(elem)) return "";');
      ScriptCode.Add('  return ensureStr(elem.innerHTML);');
      ScriptCode.Add('}');
    end;  //AddWPBox : AddValGetter()

    procedure AddValSetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValSet_wpbox(elem, textVal) {';    //'wpbox' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (!isObj(elem)) return;');
      ScriptCode.Add('  textVal = ensureStr(textVal);');
      ScriptCode.Add('  elem.innerHTML = textVal;');
      ScriptCode.Add('  return;');
      ScriptCode.Add('}');
    end;  //AddWPBox : AddValSetter()

    procedure AddStyleCode(StyleCodes : TStringList);
    begin
      if StyleCodes.IndexOf('p.inset {') >=0 then exit;
      StyleCodes.Add('p.inset {');
      StyleCodes.Add('  border-style: inset;');
      StyleCodes.Add('  border-width: 2px;');
      StyleCodes.Add('  height: 100px;');
      StyleCodes.Add('  background-color: '+COLOR_WP_BACKGROUND+';');
      StyleCodes.Add('}');
    end;  //AddWPBox : AddStyleCode(

  var OnChange : string;
  begin //AddWPBox()
    OnChange := SetupOnChangeEvent(HtmlDlg, Attrs, ScriptCode);
    AddValGetter(ScriptCode);
    AddValSetter(ScriptCode);
    Attrs.Add('tmgtype="wpbox"');    //tmgtype attrib must match end of getter & setter function names
    Id := EnsureID(Attrs);
    //Attrs.Add('class="inset"');
    EnsureClass(Attrs, 'inset');
    Attrs.Add('contenteditable="true"');
    AddStyleCode(StyleCodes);
    AddElement('p', Attrs, Content, Output);
  end;  //AddWPBox()

  function ParseItems(Source,Output:TStringList):integer;
  var Text:string;
  begin
    Result := 0;
    Text := SLStr(Source);
    //while Pos('^',Text)>0 do begin
    while Text<>'' do begin
      Output.Add(piece(Text,'^',1));
      Text := midstr(Text,Pos('^',Text)+1,length(Text));
      Result := Result+1;
      if Pos('^',Text)=0 then begin
        Output.add(text);
        Text := '';
        Result := Result+1;
      end;
    end;
  end;

  function GetWPBoxVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  var inner: string;
      //outer: string;
  begin
    Result := '';
    inner := Elem.innerHTML;
    //outer := Elem.outerHTML;
    Result := inner;
  end;

  //================================================================================
  //Combo Box
  //================================================================================

  procedure AddComboBox(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
  //      OR, HtmlDlg is really of type THTMLTemplateDialogEntry, and should be cast as such before use
  //Example of pseudo-html: <COMBO id="7" initial="opt2">^Opt1|display value1^opt2|display value2^opt3^op4</COMBO>
  //NOTICE: The value of this will be stored in attribute "tmgvalue".  This is because we can't
  //        change the attribute "value" at runtime, for some reason.

    procedure AddValGetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValGet_combobox(elem) {';   //'combobox' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (!isObj(elem)) return "";');
      ScriptCode.Add('  return getAttrib(elem, "tmgvalue");');
      ScriptCode.Add('}');
    end;

    procedure AddValSetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValSet_combobox(elem, textVal) {';    //'combobox' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add(' //Expected input: numeric index, or value to select (inner or outer value)');
      ScriptCode.Add(' if (!isObj(elem)) return;');
      ScriptCode.Add(' try {');
      ScriptCode.Add('  if (elem.getAttribute("tmgtype") !== "combobox") return;');
      ScriptCode.Add('  textVal = ensureStr(textVal);');
      ScriptCode.Add('  var index = parseInt(textVal);');
      ScriptCode.Add('  if (!isNaN(index)) {  //handle numeric input');
      ScriptCode.Add('   elem.selectedIndex = index;');
      ScriptCode.Add('  } else {  //text input');
      ScriptCode.Add('   elem.value = textVal;');
      ScriptCode.Add('   if (elem.selectedIndex == -1) {  //match not automatic.');
      ScriptCode.Add('    var upperVal = textVal.toUpperCase();');
      ScriptCode.Add('    for (var i=0; i < elem.childNodes.length; i++) {');
      ScriptCode.Add('     var node = elem.childNodes[i];');
      ScriptCode.Add('     var value = ensureStr(node.innerText).toUpperCase();');
      ScriptCode.Add('     if (value == upperVal) {elem.value = node.value; found = true; break;}');
      ScriptCode.Add('     value = ensureStr(node.value).toUpperCase();');
      ScriptCode.Add('     if (value == upperVal) {elem.value = node.value;  found = true; break;}');
      ScriptCode.Add('    }');
      ScriptCode.Add('   }');
      ScriptCode.Add('  }');
      ScriptCode.Add(' } catch(err) {}');
      ScriptCode.Add(' handleComboBoxChange(elem);');
      ScriptCode.Add(' return;');
      ScriptCode.Add('}');
    end;

    procedure AddComboboxItems(ComboItems,Content:TStringList;InitialValue:string);
    var i :integer;
        item,itemtext:string;
    begin
      for i := 0 to ComboItems.Count - 1 do begin
        item:=piece(Comboitems[i],'|',1);
        itemtext:=piece(Comboitems[i],'|',2);
        if itemtext='' then itemtext:=item;
        if item=InitialValue then
          Content.Add('<OPTION value="'+item+'" selected>'+itemtext+'</OPTION>')
        else
          Content.Add('<OPTION value="'+item+'">'+itemtext+'</OPTION>');
      end;
    end;

    procedure AddHandlerCode(ScriptCode : TStringList; OnChangeAttrib : string);
    var FnDeclaration : string;
    begin
      FnDeclaration := 'function handleComboBoxChange(elem)';
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('{');
      ScriptCode.Add('  if (!isObj(elem)) return;');
      ScriptCode.Add(' if (elem.getAttribute("tmgtype") !== "combobox") return;');
      ScriptCode.Add(' var newIndex = ensureNum(elem.selectedIndex, -1);');
      ScriptCode.Add('  var strSelected = "", Arr = elem.options;');
      ScriptCode.Add('  if ((newIndex > -1) && (newIndex < Arr.length)) strSelected = Arr[newIndex].text;');
      //NOTE: the reason for having internal and external values was so that value displayed to the user
      //      can be more verbose than the final result. 
    //ScriptCode.Add('  elem.setAttribute("tmgvalue", strSelected)');  //<-- this is external (shown) value
      ScriptCode.Add('  elem.setAttribute("tmgvalue", elem.value)');   //<-- this is the internal value
      if OnChangeAttrib <> '' then ScriptCode.Add('  fireOnChange(e,"onchange2");');
      ScriptCode.Add('}');
    end;
  var
    ItemCount : integer;
    ComboItems : TStringList;
    OnChange, InitialValue:string;
  begin
    OnChange := SetupOnChangeEvent(HtmlDlg, nil, ScriptCode);
    OnChange := StringReplace(OnChange, 'onchange=','onchange2=',[rfReplaceAll]);
    Attrs.Add(OnChange);
    ComboItems := TStringList.Create();
    ItemCount := ParseItems(Content,ComboItems);
    Content.clear;
    AddHandlerCode(ScriptCode, OnChange);
    AddValGetter(ScriptCode);
    AddValSetter(ScriptCode);
    Attrs.Add('tmgtype="combobox"');    //tmgtype attrib must match end of getter & setter function names
    Id := EnsureID(Attrs);
    Attrs.Add('onchange="handleComboBoxChange(this)"');
    GetAndRemoveAttrib(InitialValue, 'initial', Attrs);
    Attrs.Add('tmgvalue="'+InitialValue+'"');
    AddComboboxItems(ComboItems,Content,InitialValue);
    AddElement('SELECT', Attrs, Content, Output);
    ComboItems.Free;
  end;

  function GetComboBoxVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  var HTML, outer: string;
      //inner: string;
      Attrs : TStringList;
  begin
    Result := '';
    //inner := Elem.innerHTML;
    outer := Elem.outerHTML;
    HTML := piece2(outer,'<OPTION',1);
    Attrs := TStringList.Create;
    ExtractAttribs('<SELECT', HTML, Attrs);
    Result := GetAttrib('tmgvalue', Attrs);
    Attrs.Free;
  end;

  //================================================================================
  //Radio Group
  //================================================================================

  procedure AddRadioGroup(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
  //      OR, HtmlDlg is really of type THTMLTemplateDialogEntry, and should be cast as such before use
  //Example of pseudo-html: <RADIO id="8" inline=true initial="opt2">^Opt1|display value1^opt2|display value2^opt3^op4</RADIO>
  //Content will hold: (e.g.) ^Opt1|display value1^opt2|display value2^opt3^op4

    procedure AddValGetter(ScriptCode :TStringList);
    //TO-DO: test this functionality
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValGet_radiogroup(elem) {';   //'radiogroup' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  //returns: "Index^Name", or "^" if none');
      ScriptCode.Add('  if (elem == null) return "";');
      ScriptCode.Add('  var Result = getAttrib(elem,"tmgselected") + "^" + getAttrib(elem,"tmgvalue");');
      ScriptCode.Add('  return Result;');
      ScriptCode.Add('}');
    end;

    procedure AddValSetter(ScriptCode :TStringList);
    //TO-DO: finish this functionality
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValSet_radiogroup(elem, textVal) {';    //'radiogroup' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add(' //textVal should be index or name to be selected');
      ScriptCode.Add(' if (!isObj(elem)) return;');
      ScriptCode.Add(' if (getAttrib(elem,"tmgtype") !== "radiogroup") return;');
      ScriptCode.Add(' textVal = ensureStr(textVal).toUpperCase();');
      ScriptCode.Add(' var IndexVal = parseInt(textVal);');
      ScriptCode.Add(' var count = getNumAttrib(elem,"count", 0);');
      ScriptCode.Add(' elem.setAttribute("tmgvalue","");');
      ScriptCode.Add(' elem.setAttribute("tmgselected","");');
      ScriptCode.Add(' for (var Index = 0; Index < count; Index++) {');
      ScriptCode.Add('  var subID = getAttrib(elem,"id")+"_r"+Index.toString();');
      ScriptCode.Add('  var subElem = document.getElementById(subID);');
      ScriptCode.Add('  if (!isObj(subElem)) continue;');
      ScriptCode.Add('  if (!isNaN(IndexVal)) var Found = (Index == IndexVal);');
      ScriptCode.Add('  else var Found = (subElem.value.toUpperCase() == textVal);');
      ScriptCode.Add('  subElem.checked = Found;');
      ScriptCode.Add('  if (Found) {HandleRGChange(subElem); break;}');
      ScriptCode.Add(' }');
      ScriptCode.Add('}');
    end;

    procedure AddHandlerCode(ScriptCode : TStringList);
    var FnDeclaration : string;
    begin
      FnDeclaration := 'function HandleRGChange(e)';
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('{');
      ScriptCode.Add(' var radioGroup = getAttrib(e, "name");');
      ScriptCode.Add(' var Parent=document.getElementById(radioGroup);');
      ScriptCode.Add(' if (!isObj(Parent)) return;');
      ScriptCode.Add(' var selIndex = getAttrib(e, "tmgindex");');
      ScriptCode.Add(' var Value = getAttrib(e, "value");');
      ScriptCode.Add(' Parent.setAttribute("tmgvalue", Value)');
      ScriptCode.Add(' Parent.setAttribute("tmgselected", selIndex)');
      ScriptCode.Add('}');
    end;
    var HTML,s, Value, DisplayValue : string;
        i, ItemCount: integer;
        OnChange, InitialStr, InlineStr : string;
        ShowInline : boolean;
        RadioItems : TStringList;
  begin
    OnChange := SetupOnChangeEvent(HtmlDlg, Attrs, ScriptCode);
    AddHandlerCode(ScriptCode);
    AddValGetter(ScriptCode);
    AddValSetter(ScriptCode);
    Attrs.Add('tmgtype="radiogroup"');    //tmgtype attrib must match end of getter & setter function names
    Id := EnsureID(Attrs);
    RadioItems := TStringList.Create();
    ItemCount := ParseItems(Content,RadioItems); //each item is 'ItemValue|DisplayValue' or just 'ItemValue'
    Content.Clear;
    id := GetAttrib('id', Attrs);
    if id = '' then exit;
    //id := 'rg-' + id;
    GetAndRemoveAttrib(InlineStr, 'inline', Attrs); ShowInline := (Trim(UpperCase(InlineStr)) = 'TRUE');
    GetAndRemoveAttrib(InitialStr, 'initial', Attrs);
    Attrs.Add('tmgvalue='+InitialStr);
    Attrs.Add('count='+IntToStr(RadioItems.Count));
    AddElement('RADIO', Attrs, Content, Output, true);  //KT
    //HTML := '<RADIO id="' + id + '" tmgvalue="' + InitialStr + '">';
    InitialStr := UpperCase(InitialStr);
    Output.Add(HTML);
    for i := 0 to RadioItems.Count - 1 do begin
      s := RadioItems.Strings[i];
      if s = '' then continue;  //don't allow blank entries.
      Value := piece(s,'|',1);  DisplayValue := Trim(piece(s,'|',2));
      if DisplayValue='' then DisplayValue := Value;
      Attrs.clear;
      Attrs.Add('type=radio');
      Attrs.Add('name="'+id+'"');
      Attrs.Add('id="'+id+'_r' + IntToStr(i) + '"');  //e.g. Ctrl2_TMGDlg1_r3
      Attrs.Add('onclick="HandleRGChange(this)"');
      Attrs.Add('value="'+Value+'"');
      Attrs.Add('tmgindex='+IntToStr(i));
      if UpperCase(Value) = InitialStr then Attrs.Add('CHECKED=true ');
      Content.Clear;
      Content.Add(DisplayValue);
      AddElement('INPUT', Attrs, Content, Output, true);  //KT
      if (not ShowInline) and (i < RadioItems.Count - 1) then Output.Add('<BR>');
      {
      HTML := '<INPUT type=radio name="'+id+'" onClick="HandleRGChange(this)" value="'+Value+'" ';
      if UpperCase(Value) = InitialStr then HTML := HTML + 'CHECKED=true ';
      HTML := HTML + 'tmgindex='+IntToStr(i) + '>' + DisplayValue;
      if not ShowInline then HTML := HTML + '<BR>';
      Output.Add(HTML);
      }
    end;
    Output.Add('</RADIO>');
    { /// delete later...
    Attrs.Add('tmgtype="radiogroup"');    //tmgtype attrib must match end of getter & setter function names
    Id := EnsureID(Attrs);
    RadioItems := TStringList.Create();
    ItemCount := ParseItems(Content,RadioItems); //each item is 'ItemValue|DisplayValue' or just 'ItemValue'
    if GetAndRemoveAttrib(id, 'id', Attrs) = false then exit;  //can't add without an id.
    //id := 'rg-' + id;
    GetAndRemoveAttrib(InlineStr, 'inline', Attrs); ShowInline := (Trim(UpperCase(InlineStr)) = 'TRUE');
    GetAndRemoveAttrib(InitialStr, 'initial', Attrs);
    AddElement('RADIO', Attrs, Content, Output, true);  //KT

    HTML := '<RADIO id="' + id + '" tmgvalue="' + InitialStr + '">';
    InitialStr := UpperCase(InitialStr);
    Output.Add(HTML);
    for i := 0 to RadioItems.Count - 1 do begin
      s := RadioItems.Strings[i];
      if s = '' then continue;  //don't allow blank entries.
      Value := piece(s,'|',1);  DisplayValue := piece(s,'|',2);
      if DisplayValue='' then DisplayValue := Value;
      HTML := '  <INPUT type=radio name="'+id+'" onClick="HandleRGChange(this)" value="'+Value+'" ';
      if UpperCase(Value) = InitialStr then begin
        HTML := HTML + 'CHECKED=true ';
      end;
      HTML := HTML + '>' + DisplayValue;
      if not ShowInline then HTML := HTML + '<BR>';
      Output.Add(HTML);
    end;
    Output.Add('</RADIO>');

    }
    RadioItems.Free;
  end;

  function GetRadioGroupVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  var outer: string;
      //inner: string;
      Attrs : TStringList;
  begin
    Result := '';
    //inner := Elem.innerHTML;
    outer := Elem.outerHTML;
    Attrs := TStringList.Create;
    ExtractAttribs('<RADIO', outer, Attrs);
    Result := GetAttrib('tmgvalue', Attrs);
    Attrs.Free;
  end;

  //================================================================================
  //CycButton
  //================================================================================

  procedure AddCycButton(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
  //      OR, HtmlDlg is really of type THTMLTemplateDialogEntry, and should be cast as such before use

    procedure AddValGetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValGet_cycbutton(elem) {';   //'cycbutton' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (!isObj(elem)) return "";');
      ScriptCode.Add('  return ensureStr(elem.innerHTML);');
      ScriptCode.Add('}');
    end;

    procedure AddValSetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      //finish!!!
      FnDeclaration := 'function ValSet_cycbutton(elem, textVal) {';    //'cycbutton' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  //textVal should be index or name of option to set');
      ScriptCode.Add('  if (!isObj(elem)) return;');
      ScriptCode.Add('  textVal = ensureStr(textVal);');
      ScriptCode.Add('  var max= getNumAttrib(elem, "max",0)+1;');
      ScriptCode.Add('  var index = 0;');
      ScriptCode.Add('  var value = "_____";');
      ScriptCode.Add('  var n=parseInt(textVal);');
      ScriptCode.Add('  if (isNaN(n)==false) { ');
      ScriptCode.Add('    if ((textVal < max) && (textVal>0)) {');
      ScriptCode.Add('      var item = getAttrib(elem, "item" + textVal.toString());');
      ScriptCode.Add('      index = textVal; ');
      ScriptCode.Add('      value = item;');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('  else ');
      ScriptCode.Add('  { ');
      ScriptCode.Add('    for (var i=1; i < max; i++) {');
      ScriptCode.Add('      var item = getAttrib(elem, "item" + i.toString());');
      ScriptCode.Add('      if (item.toUpperCase()==textVal.toUpperCase()) {');
      ScriptCode.Add('        index = i;');
      ScriptCode.Add('        value = item;');
      ScriptCode.Add('        break');
      ScriptCode.Add('      }');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('  elem.innerText = value;');
      ScriptCode.Add('  elem.setAttribute("tmgvalue", value);');
      ScriptCode.Add('  elem.setAttribute("index", index.toString());');
      ScriptCode.Add('  return;');
      ScriptCode.Add('}');
    end;

    procedure AddHandlerCode(ScriptCode : TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function HandleButtonClick(e)';
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('{');
      ScriptCode.Add('  if (!isObj(e)) return;');
      ScriptCode.Add('  var index= getAttrib(e, "index");');
      ScriptCode.Add('  var max= getAttrib(e, "max");');
      ScriptCode.Add('  index = Number(index)+1;');
      ScriptCode.Add('  var itemDisplay = "";');
      ScriptCode.Add('  if (index>max) index = 0;');
      ScriptCode.Add('  if (index>0) {');
      ScriptCode.Add('    var item = getAttrib(e, "item" + index.toString());');
      ScriptCode.Add('    var itemArr = item.split("|");');
      ScriptCode.Add('    item = itemArr[0];');
      ScriptCode.Add('    itemDisplay = item');
      ScriptCode.Add('    if (itemArr.length > 1) itemDisplay = itemArr[1];');
      ScriptCode.Add('  } else {');
      ScriptCode.Add('    itemDisplay = "_____";');
      ScriptCode.Add('  }');
      ScriptCode.Add('  e.innerText = itemDisplay;');
      ScriptCode.Add('  e.setAttribute("tmgvalue", itemDisplay);');
      ScriptCode.Add('  e.setAttribute("index", index.toString());');
      ScriptCode.Add('  fireOnChange(e);');
      ScriptCode.Add('}');
    end;
  var
    ButtonItems : TStringList;
    ItemCount,Index,i:integer;
    OnChange, Value,InitialText,InitialStr:string;
  begin
    OnChange := SetupOnChangeEvent(HtmlDlg, Attrs, ScriptCode);
    ButtonItems := TStringList.Create();
    AddHandlerCode(ScriptCode);
    AddValGetter(ScriptCode);
    AddValSetter(ScriptCode);
    Attrs.Add('tmgtype="cycbutton"');    //tmgtype attrib must match end of getter & setter function names
    Id := EnsureID(Attrs);
    ItemCount := ParseItems(Content,ButtonItems);
    Content.clear;
    {
    <BUTTON
      id="10"
      item1="opt1|Apples"
      item2="opt2|Pears"
      item3="opt3"
      item4="opt4"
      index=1
      max=4
      value="opt1"
    >Apples</BUTTON>
    }
      //Source.Add('<CYCBUTTON id="10" initial="opt2">opt1|Apples^opt2|Pears^opt3^opt4</CYCBUTTON>');
    GetAndRemoveAttrib(InitialStr, 'initial', Attrs);
    if InitialStr = '' then InitialStr := '_____';
    InitialText := InitialStr;
    Attrs.Add('onclick="HandleButtonClick(this)"');
    index := 0;
    for i := 0 to ButtonItems.Count - 1 do begin
      Attrs.Add('item'+inttostr(i+1)+'="'+ButtonItems[i]+'"');
      if Uppercase(piece(ButtonItems[i],'|',1))= UpperCase(InitialStr) then begin
        index := i+1;
        Value := piece(ButtonItems[i],'|',1);
        InitialText := piece(ButtonItems[i],'|',2);
      end;
    end;
    Attrs.Add('index='+inttostr(index));
    Attrs.Add('tmgvalue="'+Value+'"');
    Attrs.Add('max='+inttostr(ItemCount));
    Content.Add(InitialText);
    AddElement('BUTTON', Attrs, Content, Output);
    ButtonItems.Free;
  end;

  function GetCycButtonVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  var inner: string;
      //outer: string;
  begin
    //Result := '';
    inner := Elem.innerHTML;
    //outer := Elem.outerHTML;
    Result := inner;
  end;

  //================================================================================
  //Number
  //================================================================================
  procedure AddNumberHandlerCode(ScriptCode : TStringList);
  //NOte: this code will also be used for inline date object.
  var FnDeclaration : string;
  begin
    AddCoreFns(ScriptCode);
    FnDeclaration := 'function altNumValue(id, delta) ';
    if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
    ScriptCode.Add(FnDeclaration);
    ScriptCode.Add('{');
    ScriptCode.Add('  var elem=document.getElementById(id);');
    ScriptCode.Add('  if (!isObj(elem)) return;');
    ScriptCode.Add('  if (elem.getAttribute("tmgtype") !== "number") return;');
    ScriptCode.Add('  var value=ensureNum(elem.value,0);');
    ScriptCode.Add('  var increment = getNumAttrib(elem,"step",1);');
    ScriptCode.Add('  if (ensureStr(delta)=="-") increment = -increment;');
    ScriptCode.Add('  value += increment;');
    ScriptCode.Add('  elem.value = value.toString();');
    ScriptCode.Add('  elem.setAttribute("tmgvalue", value.toString());');
    ScriptCode.Add('  ValidateNumValue(elem);');
    ScriptCode.Add('  fireOnChange(elem);');
    ScriptCode.Add('}');
    ScriptCode.Add('');
    ScriptCode.Add('function ValidateNumValue(elem) {');
    ScriptCode.Add('  if (!isObj(elem)) return;');
    ScriptCode.Add('  var min=getNumAttrib(elem,"min",0);');
    ScriptCode.Add('  var max=getNumAttrib(elem,"max",99999);');
    ScriptCode.Add('  //var value=getAttrib(elem,"value");');
    ScriptCode.Add('  var value=elem.value;');
    ScriptCode.Add('  var newValue=ensureNum(value.replace(/[^\d-]/g,''''),0);');
    ScriptCode.Add('  if (newValue>max) newValue=max;');
    ScriptCode.Add('  if (newValue<min) newValue=min;');
    ScriptCode.Add('  if (newValue == value) return;');
    ScriptCode.Add('  elem.value=newValue.toString();');
    ScriptCode.Add('  //elem.setAttribute("value", newValue.toString());');
    ScriptCode.Add('  elem.setAttribute("tmgvalue", newValue.toString());');
    ScriptCode.Add('}');
    ScriptCode.Add('function handleNumKeyup(elem) {ValidateNumValue(elem);}');
    ScriptCode.Add('function checkKey(elem) {');
    ScriptCode.Add('  if (!isObj(elem)) return;');
    ScriptCode.Add('  var e = elem || window.event;');
    ScriptCode.Add('  if (e.keyCode == "38") {altNumValue(elem.id, "+"); e.keyCode=""; return;}');
    ScriptCode.Add('  if (e.keyCode == "40") {altNumValue(elem.id, "-"); e.keyCode=""; return;}');
    ScriptCode.Add('}');
  end;

  procedure AddNumber(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
  //      OR, HtmlDlg is really of type THTMLTemplateDialogEntry, and should be cast as such before use

    procedure AddValGetter(ScriptCode :TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function ValGet_number(elem) {';   //'number' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (elem == null) return "";');
      ScriptCode.Add('  return getAttrib(elem,"tmgvalue");');
      ScriptCode.Add('}');
    end;

    procedure AddValSetter(ScriptCode :TStringList);
    //TO-DO: test this functionality
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      //finish!!!
      FnDeclaration := 'function ValSet_number(elem, textVal) {';    //'number' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (!isObj(elem)) return;');
      ScriptCode.Add('  textVal = ensureStr(textVal);');
      ScriptCode.Add('  elem.value = textVal;');
      ScriptCode.Add('  elem.setAttribute("tmgvalue",textVal);');
      ScriptCode.Add('  ValidateNumValue(elem);');
      ScriptCode.Add('  return;');
      ScriptCode.Add('}');
    end;

  var
    i:integer;
    OnChange, ClassStr, LabelStr:string;
    SL:TStringList;
    Disabled: boolean;
  begin
    OnChange := SetupOnChangeEvent(HtmlDlg, Attrs, ScriptCode);
    Id := EnsureID(Attrs);
    AddNumberHandlerCode(ScriptCode);
    AddValGetter(ScriptCode);
    AddValSetter(ScriptCode);
    Attrs.Add('tmgtype="number"');    //tmgtype attrib must match end of getter & setter function names
    GetAndRemoveAttrib(LabelStr, 'Label', Attrs);
    Attrs.Add('value="'+SLStr(Content)+'"');
    Attrs.Add('tmgvalue="'+SLStr(Content)+'"');
    Attrs.Add('onkeyup="handleNumKeyup(this)"');
    Attrs.Add('onkeydown="checkKey(this)"');
    Content.clear;

    SL := TStringList.Create;
    AddElement('input', Attrs, Content, SL, true);   //<input> doesn't use end tag
    for i := 0 to SL.Count - 1 do begin
      if i = 0 then begin
        Output.Add(LabelStr + SL.Strings[i]);
      end else begin
        Output.Add(SL.Strings[i]);
      end;
    end;
    SL.Free;

    Disabled := (Attrs.IndexOf('disabled') > -1);
    ClassStr := Attrs.Values['class'];

    Attrs.clear;
    EnsureClass(Attrs,ClassStr);
    Content.Clear;
    if Disabled then begin
      Attrs.Add('disabled');
      EnsureClass(Attrs,'TMGDisabledControl');
    end;
    Attrs.Add('onclick="altNumValue('''+Id+''', ''+'')"');
    //Attrs.Add('ondblclick="alert(''Double Click!'')"');  //kt temp, for debugging
    Content.Add('&uarr;');
    AddElement('button', Attrs, Content, Output);

    Attrs.clear;
    EnsureClass(Attrs,ClassStr);
    Content.Clear;
    if Disabled then begin
      Attrs.Add('disabled');
      EnsureClass(Attrs,'TMGDisabledControl');
    end;
    Attrs.Add('onclick="altNumValue('''+Id+''', ''-'')"');
    //Attrs.Add('ondblclick="alert(''Double Click!'')"');  //kt temp, for debugging
    Content.Add('&darr;');
    AddElement('button', Attrs, Content, Output);
  end;

  function GetNumberVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  var HTML : string;
      Attrs : TStringList;
  begin
    Result := '';
    HTML := Elem.outerHTML;
    Attrs := TStringList.Create;
    ExtractAttribs('<INPUT', HTML, Attrs);
    Result := GetAttrib('tmgvalue', Attrs);
    Attrs.Free;
  end;

  //================================================================================
  //Date
  //================================================================================

  procedure AddDate(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
  //      OR, HtmlDlg is really of type THTMLTemplateDialogEntry, and should be cast as such before use
  //NOTE: For non-US locations, a date format string can be passed in via 'format' element in Attrs.  See format in code below.
  var
    DT : TDateTime;
    UnixTime : Int64;
    DTFormat, InitialValue, FMDTValue : string;
    FormatStr : string;
    DTMode : integer;
    TagName : string;

    procedure AddValGetter(ScriptCode :TStringList);
    //TO-DO: finish this functionality
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      //finish!!
      FnDeclaration := 'function ValGet_date(elem) {';   //'date' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (elem == null) return "";');
      ScriptCode.Add('  return getAttrib(elem, "value");');
      ScriptCode.Add('}');
    end;

    procedure AddValSetter(ScriptCode :TStringList);
    //TO-DO: finish this functionality
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      //finish!!!
      FnDeclaration := 'function ValSet_date(elem, textVal) {';  //'date' must match tmgtype attrib
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  if (!isObj(elem)) return;');
      ScriptCode.Add('  textVal = ensureStr(textVal);');
      ScriptCode.Add('  SetDateTime(elem.id,textVal);');  //this function is in TMGInlineHTMLDat
      ScriptCode.Add('  return;');
      ScriptCode.Add('}');
    end;

  var OnChange : string;
  begin
    //TODO: Implement, using [DTMode=x] attrib....
    {MODES:   Mode = ord(FDateType) - 1;
        0 = Date    //kt <------------ 0 is treated same as 3
        1 = Date & Time
        2 = Date & Req Time
        3 = Combo Style
        4 = Combo Yr Only
        5 = Combo Yr & Month
    }
    OnChange := SetupOnChangeEvent(HtmlDlg, Attrs, ScriptCode);
    AddCoreFns(ScriptCode);
    AddValGetter(ScriptCode);
    AddValSetter(ScriptCode);
    Attrs.Add('tmgtype="date"');    //tmgtype attrib must match end of getter & setter function names
    Id := EnsureID(Attrs);
    DTMode := StrToIntDef(GetAttrib('DTMode', Attrs),0);
    GetAndRemoveAttrib(InitialValue, 'initial', Attrs);
    GetAndRemoveAttrib(FormatStr, 'format', Attrs);
    if FormatStr = '' then begin
      //NOTE: Format should be in 4 pieces, separated by ^
      //      Piece-1 = used if only year specified
      //      Piece-2 = used if only year and month specified
      //      Piece-3 = used if only year, month, and day specified
      //      Piece-4 = used if year, month, day, and time specified
      //Syntax should match that in function TMGInlineHTMLDatePicker.Obj2Ext() and FormatFMDT()
      FormatStr := '{yyyy}^{mmm}, {yyyy}^{mmm} {dd}, {yyyy}^{mmm} {dd}, {yyyy} @ {hh}:{nn} {ampm}';
      //FormatStr := 'mmm d, yyyy';
      //if (DTMode = 1) or (DTMode = 2) then FormatStr := 'mmm dd, yyyy @ hh:nn';
    end;
    Attrs.Add('dtformat="'+FormatStr+'"');

    FMDTValue := InitialValue;
    //TO Do: check to see if IntialValue is in FMDT format.  If not, then consider parsing input based in FormatStr to
    //       turn it into FMDT format
    if InitialValue <> '' then Attrs.Add('fmdtvalue="'+FMDTValue+'"');
    //------------------------------------
    //kt 5/4/16 ... I am having a hard time getting the MonkeyPicker to work correctly in TWebBrowser IE6
    //So for now, will cut out that code... (it was huge anyway...)
    {
    //To do, use ScanDateTime from FreePascal library to allow parsing input date according to DTFormat...
    //Implement later--> DTFormat := GetAttrib('format', Attrs); if DTFormat='' then DTFormat := 'mm/dd/yyyy';
    DT := StrToDateDef(InitialValue, Now);  //Here InitialValue has to be in expected format for StrToDateDef, or defaults to [Now]
    if DTMode = 0 then begin
      AddMonkeyDatePicker(Id, ScriptCode, StyleCodes);  //note, this adds extensive CSS and javascript code, but it won't add duplicate lines.
      if InitialValue <> '' then begin
        UnixTime :=DateTimeToUnix(DT);
        UnixTime := UnixTime + 43200;  //add 12 hrs to get to mid-day
        InitialValue := IntToStr(UnixTime);
        Attrs.Add('value="'+InitialValue+'"');
      end;
      EnsureClass(Attrs, 'date TMG1');
      Attrs.Add('name="date_B"');
      TagName :=  'INPUT';
    end else begin
    }
      //AddTMGInlineHTMLDatepicker(Id, InitialValue, DTMode, ScriptCode, StyleCodes);
      AddTMGInlineHTMLDatepickerCode(Id, ScriptCode, StyleCodes);
      TagName :=  'SPAN';
    {
    end;
    }
    AddElement(TagName, Attrs, Content, Output);
  end;

  function FormatFMDT(Format, FMDTVal: string) : string;
    //NOTICE: This function should mirror code in function TMGInlineHTMLDatePicker.Obj2Ext(DateObj,Format)
    //input:
    //   Format = format string.  Each element must be { }s
    //     {yy} = last 2 digits of year;   {yyyy} = 4 digit year
    //     {m} = month number, no leading zero;  {mm} = month number as 2 digits
    //     {mmm} = month as short name;  {mmmm} = month as full length name
    //     {d} = day number, no leading zero; {dd} = day numer as 2 digits
    //     {h} = hour number, no leading zero; {hh} = 12hr hour number as 2 digits;
    //     {h24} = 24hr hour number, no leading zero; {h24} = 24hr hour number as 2 digits
    //     {n} = minute number, no leading zero; {nn} minute number as 2 digits
    //     {ampm} = "am" or "pm"  NOTE: 12 pm is noon
    //     all other characters in Format string are left in place
    //   FMDTVal : string in format of YYYMMDD.HHMMSS

    function RPad(S : string; Len : integer; Ch : char) : string;
    begin Result := S; while length(Result) < Len do Result := Result + Ch; end;

    function LPad(S : string; Len : integer; Ch : char) : string;
    begin Result := S; while length(Result) < Len do Result := Ch + Result; end;

  const
    MonthsArr : array[0..12] of String = ('-month-','January','February',
      'March','April','May','June','July','August','September','October',
      'November','December');
    ShortMonthsArr : array[0..12] of string = ('-month-','Jan','Feb','Mar',
      'Apr','May','June','July','Aug','Sept','Oct','Nov','Dec');
  var
    Yr, Mo, Day, Hr24, Min, Sec, idx : integer;
    YrStr, ShortYrStr, MoStr, DayStr, Hr24Str, Hr12Str, MinStr, SecStr, ampm : String;
    Date,Time : string;
    FormatArr : TStringList;
  begin
    Date    := RPad(Piece(FMDTVal,'.',1),7,'0');
    Time    := RPad(Piece(FMDTVal,'.',2),6,'0');
    Yr      := StrToIntDef(MidStr(Date,1,3),0)+1700;
    YrStr   := IntToStr(Yr); ShortYrStr := MidStr(YrStr, 3, 2);
    Mo      := StrToIntDef(MidStr(Date,4,2),0);
    Day     := StrToIntDef(MidStr(Date,6,2),0);
    Hr24Str := MidStr(Time,1,2);
    Hr24    := StrToIntDef(Hr24Str,0);
    Hr12Str := Hr24Str; if Hr24>12 then Hr12Str := IntToStr(Hr24-12);
    if Hr24>12 then AMPM := 'pm' else AMPM := 'am';
    Min     := StrToIntDef(MidStr(Time,3,2),0);
    Sec     := StrToIntDef(MidStr(Time,5,2),0);

    FormatArr := TStringList.Create;
    PiecesToList(Format,'^', FormatArr);
    idx := 0;
    if Mo > 0 then begin
      idx := 1;
      if Day > 0 then begin
        idx := 2;
        if Hr24 > 0 then begin
          idx := 3;
        end;
      end;
    end;
    if idx >= FormatArr.Count then idx := FormatArr.Count-1;
    Result := FormatArr[idx];
    FormatArr.Free;

    Result := StringReplace(Result, '{yy}',   ShortYrStr, [rfReplaceAll]);
    Result := StringReplace(Result, '{yyyy}', YrStr, [rfReplaceAll]);
    Result := StringReplace(Result, '{m}',    IntToStr(Mo), [rfReplaceAll]);
    Result := StringReplace(Result, '{mm}',   LPad(IntToStr(Mo), 2, '0'), [rfReplaceAll]);
    Result := StringReplace(Result, '{mmm}',  ShortMonthsArr[Mo], [rfReplaceAll]);
    Result := StringReplace(Result, '{mmmm}', MonthsArr[Mo], [rfReplaceAll]);
    Result := StringReplace(Result, '{d}',    IntToStr(Day), [rfReplaceAll]);
    Result := StringReplace(Result, '{dd}',   LPad(IntToStr(Day), 2, '0'), [rfReplaceAll]);
    Result := StringReplace(Result, '{h}',    Hr12Str, [rfReplaceAll]);
    Result := StringReplace(Result, '{hh}',   LPad(Hr12Str, 2, '0'), [rfReplaceAll]);
    Result := StringReplace(Result, '{h24}',  Hr24Str, [rfReplaceAll]);
    Result := StringReplace(Result, '{hh24}', LPad(Hr24Str, 2, '0'), [rfReplaceAll]);
    Result := StringReplace(Result, '{n}',    IntToStr(Min), [rfReplaceAll]);
    Result := StringReplace(Result, '{nn}',   LPad(IntToStr(Min), 2, '0'), [rfReplaceAll]);
    Result := StringReplace(Result, '{ampm}', AMPM, [rfReplaceAll]);
  end;

  function GetDateVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  var StrVal, HTML, DTFormat : string;
      Attrs : TStringList;
      //NumVal : Int64;
      //DTVal : TDateTime;
      FMDT : TFMDateTime;
      FormatStr : string;
      DTMode : integer;
  begin
    HTML := Elem.outerHTML;
    Attrs := TStringList.Create;
    ExtractAttribs('<SPAN', HTML, Attrs);   //was '<INPUT'
    FormatStr := GetAttrib('dtformat', Attrs);
    Result := GetAttrib('fmdtvalue', Attrs);
    //if FormatStr <> '' then Result := FormatFMDateTimeStr(FormatStr, Result);
    if FormatStr <> '' then Result := FormatFMDT(FormatStr, Result);
    Attrs.Free;
  end;

  //================================================================================
  //Enabler Controller CheckBox
  //================================================================================

  procedure AddEnableCB(HtmlDlg : TObject; Source, Attrs, Output, Content, ScriptCode, StyleCodes : TStringList; var Id : string);
  //Note: HtmlDlg is really of type THTMLDlg, and should be cast as such before use
  //      OR, HtmlDlg is really of type THTMLTemplateDialogEntry, and should be cast as such before use
  //Note: Contents here should contain all HTML/PseudoHTML between beginning and end tags.  This is a container object
  //      so this could be large.  Will call back to HtmlDlg.AddFromSource() to handle contained objects.
  //NOTE: There will not be a way for a user's template JS to get or set this value.

    procedure AddHandlerCode(ScriptCode : TStringList);
    var FnDeclaration : string;
    begin
      AddCoreFns(ScriptCode);
      FnDeclaration := 'function HandleEnableCBClick(cb) {';
      if ScriptCode.IndexOf(FnDeclaration) > -1 then exit;
      ScriptCode.Add(FnDeclaration);
      ScriptCode.Add('  var Enabled = cb.checked;');
      ScriptCode.Add('  var GroupName = getAttrib(cb,"ControlGroup");');
      ScriptCode.Add('  var elList = getElementsByClassName(GroupName);');
      ScriptCode.Add('  var i;');
      ScriptCode.Add('  for (i = 0; i < elList.length; i++) {');
      ScriptCode.Add('    var elem = elList[i];');
      ScriptCode.Add('    if (elem == cb) continue;');
      ScriptCode.Add('    var ClassName = elem.className;');
      ScriptCode.Add('    if (Enabled) {');
      ScriptCode.Add('      elem.className = subtractString(elem.className, ["TMGDisabledControl","TMGDisabledContainer"]);');
      ScriptCode.Add('      elem.removeAttribute("disabled");');
      ScriptCode.Add('      //elList[i].style.backgroundColor = "blue";');
      ScriptCode.Add('    } else {');
      ScriptCode.Add('      if (hasClass(elem, "TMGContainer")) {');
      ScriptCode.Add('        elem.className = ensureString(elem.className, "TMGDisabledContainer");');
      ScriptCode.Add('      } else {');
      ScriptCode.Add('        elem.className = ensureString(elem.className, "TMGDisabledControl");');
      ScriptCode.Add('        elem.disabled = true;');
      ScriptCode.Add('        //elList[i].style.backgroundColor = "red";');
      ScriptCode.Add('      }');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('/*---------------------------------------------------------');
      ScriptCode.Add('  Developed by Robert Nyman, http://www.robertnyman.com');
      ScriptCode.Add('  Code/licensing: http://code.google.com/p/getelementsbyclassname/');
      ScriptCode.Add('-----------------------------------------------------------*/');
      ScriptCode.Add('var getElementsByClassName = function (className, tag, elm){');
      ScriptCode.Add('  if (document.getElementsByClassName) {');
      ScriptCode.Add('    getElementsByClassName = function (className, tag, elm) {');
      ScriptCode.Add('      elm = elm || document;');
      ScriptCode.Add('      var elements = elm.getElementsByClassName(className),');
      ScriptCode.Add('        nodeName = (tag)? new RegExp("\\b" + tag + "\\b", "i") : null,');
      ScriptCode.Add('        returnElements = [],');
      ScriptCode.Add('        current;');
      ScriptCode.Add('      for(var i=0, il=elements.length; i<il; i+=1){');
      ScriptCode.Add('        current = elements[i];');
      ScriptCode.Add('        if(!nodeName || nodeName.test(current.nodeName)) {');
      ScriptCode.Add('          returnElements.push(current);');
      ScriptCode.Add('        }');
      ScriptCode.Add('      }');
      ScriptCode.Add('      return returnElements;');
      ScriptCode.Add('    };');
      ScriptCode.Add('  }');
      ScriptCode.Add('  else if (document.evaluate) {');
      ScriptCode.Add('    getElementsByClassName = function (className, tag, elm) {');
      ScriptCode.Add('      tag = tag || "*";');
      ScriptCode.Add('      elm = elm || document;');
      ScriptCode.Add('      var classes = className.split(" "),');
      ScriptCode.Add('        classesToCheck = "",');
      ScriptCode.Add('        xhtmlNamespace = "http://www.w3.org/1999/xhtml",');
      ScriptCode.Add('        namespaceResolver = (document.documentElement.namespaceURI === xhtmlNamespace)? xhtmlNamespace : null,');
      ScriptCode.Add('        returnElements = [],');
      ScriptCode.Add('        elements,');
      ScriptCode.Add('        node;');
      ScriptCode.Add('      for(var j=0, jl=classes.length; j<jl; j+=1){');
      ScriptCode.Add('        classesToCheck += "[contains(concat('' '', @class, '' ''), '' " + classes[j] + " '')]";');
      ScriptCode.Add('      }');
      ScriptCode.Add('      try  {');
      ScriptCode.Add('        elements = document.evaluate(".//" + tag + classesToCheck, elm, namespaceResolver, 0, null);');
      ScriptCode.Add('      }');
      ScriptCode.Add('      catch (e) {');
      ScriptCode.Add('        elements = document.evaluate(".//" + tag + classesToCheck, elm, null, 0, null);');
      ScriptCode.Add('      }');
      ScriptCode.Add('      while ((node = elements.iterateNext())) {');
      ScriptCode.Add('        returnElements.push(node);');
      ScriptCode.Add('      }');
      ScriptCode.Add('      return returnElements;');
      ScriptCode.Add('    };');
      ScriptCode.Add('  }');
      ScriptCode.Add('  else {');
      ScriptCode.Add('    getElementsByClassName = function (className, tag, elm) {');
      ScriptCode.Add('      tag = tag || "*";');
      ScriptCode.Add('      elm = elm || document;');
      ScriptCode.Add('      var classes = className.split(" "),');
      ScriptCode.Add('        classesToCheck = [],');
      ScriptCode.Add('        elements = (tag === "*" && elm.all)? elm.all : elm.getElementsByTagName(tag),');
      ScriptCode.Add('        current,');
      ScriptCode.Add('        returnElements = [],');
      ScriptCode.Add('        match;');
      ScriptCode.Add('      for(var k=0, kl=classes.length; k<kl; k+=1){');
      ScriptCode.Add('        classesToCheck.push(new RegExp("(^|\\s)" + classes[k] + "(\\s|$)"));');
      ScriptCode.Add('      }');
      ScriptCode.Add('      for(var l=0, ll=elements.length; l<ll; l+=1){');
      ScriptCode.Add('        current = elements[l];');
      ScriptCode.Add('        match = false;');
      ScriptCode.Add('        for(var m=0, ml=classesToCheck.length; m<ml; m+=1){');
      ScriptCode.Add('          match = classesToCheck[m].test(current.className);');
      ScriptCode.Add('          if (!match) {');
      ScriptCode.Add('            break;');
      ScriptCode.Add('          }');
      ScriptCode.Add('        }');
      ScriptCode.Add('        if (match) {');
      ScriptCode.Add('          returnElements.push(current);');
      ScriptCode.Add('        }');
      ScriptCode.Add('      }');
      ScriptCode.Add('      return returnElements;');
      ScriptCode.Add('    };');
      ScriptCode.Add('  }');
      ScriptCode.Add('  return getElementsByClassName(className, tag, elm);');
      ScriptCode.Add('};');
      ScriptCode.Add('/*---------------------------------------------------------');
      ScriptCode.Add('  End of code by Robert Nyman, http://www.robertnyman.com');
      ScriptCode.Add('  Code/licensing: http://code.google.com/p/getelementsbyclassname/');
      ScriptCode.Add('-----------------------------------------------------------*/');
    end;

    procedure AddStyleCode(StyleCodes : TStringList);
    begin
      //use code guard to avoid multiple adds
      if StyleCodes.IndexOf('.TMGContainer {') > -1 then exit;
      StyleCodes.Add('.TMGContainer {');
      StyleCodes.Add('  border-style: none;');
      //StyleCodes.Add('  border-style: solid;');
      //StyleCodes.Add('  border-width: 1px;');
      //StyleCodes.Add('  border-color: lightgrey;');
      StyleCodes.Add('  margin-left: 15px;');
      StyleCodes.Add('}');
      StyleCodes.Add('.TMGDisabledContainer {');
      StyleCodes.Add('  background-color : lightgrey;');
      StyleCodes.Add('  border-style : solid;');
      StyleCodes.Add('  border-width: 1px;');
      StyleCodes.Add('  border-color: black;');
      StyleCodes.Add('  padding: 5px;');
      StyleCodes.Add('  color : grey;');
      StyleCodes.Add('}');
      StyleCodes.Add('.TMGDisabledControl {');
      StyleCodes.Add('  color : grey;');
      StyleCodes.Add('}');
    end;

  var GroupID  : string;
      SL : TStringList;
  begin
    GroupID := 'ControlGroup' + NextID;
    AddHandlerCode(ScriptCode);
    AddStyleCode(StyleCodes);
    Id := EnsureID(Attrs);
    Attrs.Add('type="checkbox"');
    Attrs.Add('ControlGroup="'+GroupID+'"');
    Attrs.Add('onclick="HandleEnableCBClick(this)"');
    SL := TStringList.Create;  //empty SL
    AddElement('input', Attrs, SL, Output, true); // <-- add the control checkbox.  //<input> doesn't use end tag
    SL.Free;
    Output.add('<div class="' + GroupID + ' TMGContainer TMGDisabledContainer">');  //disabled view by default
    if HtmlDlg is THTMLDlg then begin
      THTMLDlg(HtmlDlg).AddFromSource(Content, GroupID);  //recursive call.
    end else if HtmlDlg is THTMLTemplateDialogEntry then begin
      //CHECK LATER.... GroupID is not being passed in below.  Is this going to be a problem??
      THTMLTemplateDialogEntry(HtmlDlg).AddFromPseudoHTML(Content, StyleCodes, ScriptCode);  //recursive call.
    end;
    Output.add('</div>');
  end;

  function GetEnableCBVal(HtmlDlg : TObject; Elem: IHTMLElement; NoCommas : boolean = false) : string;
  var inner, outer: string;
      Attrs : TStringList;
  begin
    inner := Elem.innerHTML;
    outer := Elem.outerHTML;
    Attrs := TStringList.Create;
    ExtractAttribs('<INPUT', outer, Attrs);
    if AttribIdx('checked', Attrs) >= 0 then begin
      Result := GetAttrib('tmgvalue', Attrs);
    end else begin
      Result := '';
    end;
    Attrs.Free;
  end;

  //================================================================================
  //================================================================================
  constructor THTMLObjHandler.Create(WebBrowser: THtmlObj;
                                     AStartTag, AnEndTag : string;
                                     AnAddProc : TElementAddProc;
                                     AGetValFn : TElementGetValueFn{;
                                     IsContainer : boolean});
  begin
    FStartTag := AStartTag;
    FEndTag := AnEndTag;
    FAddProc := AnAddProc;
    FGetValFn := AGetValFn;
    //FIsContainer := IsContainer;
  end;

  //================================================================================
  //================================================================================

  constructor THTMLObjHandlersList.Create(AWebBrowser: THtmlObj);
  begin
    inherited Create;
    ObjsList := TStringList.Create;
    FWebBrowser := AWebBrowser;
    ObjsList.AddObject('<CHECKBOX',  THTMLObjHandler.Create(FWebBrowser, '<CHECKBOX',  '</CHECKBOX>',  AddCheckBox,   GetCheckBoxVal   ));
    ObjsList.AddObject('<EDITBOX',   THTMLObjHandler.Create(FWebBrowser, '<EDITBOX',   '</EDITBOX>',   AddEditBox,    GetEditBoxVal    ));
    ObjsList.AddObject('<WPBOX',     THTMLObjHandler.Create(FWebBrowser, '<WPBOX',     '</WPBOX>',     AddWPBox,      GetWPBoxVal      ));
    ObjsList.AddObject('<COMBO',     THTMLObjHandler.Create(FWebBrowser, '<COMBO',     '</COMBO>',     AddComboBox,   GetComboBoxVal   ));
    ObjsList.AddObject('<RADIO',     THTMLObjHandler.Create(FWebBrowser, '<RADIO',     '</RADIO>',     AddRadioGroup, GetRadioGroupVal ));
    ObjsList.AddObject('<CYCBUTTON', THTMLObjHandler.Create(FWebBrowser, '<CYCBUTTON', '</CYCBUTTON>', AddCycButton,  GetCycButtonVal  ));
    ObjsList.AddObject('<NUMBER',    THTMLObjHandler.Create(FWebBrowser, '<NUMBER',    '</NUMBER>',    AddNumber,     GetNumberVal     ));
    ObjsList.AddObject('<DATE',      THTMLObjHandler.Create(FWebBrowser, '<DATE',      '</DATE>',      AddDate,       GetDateVal       ));
    ObjsList.AddObject('<ENABLECB',  THTMLObjHandler.Create(FWebBrowser, '<ENABLECB',  '</ENABLECB>',  AddEnableCB,   GetEnableCBVal   ));
    ObjsList.AddObject('<CBGROUP',   THTMLObjHandler.Create(FWebBrowser, '<CBGROUP',   '</CBGROUP>',   AddCBGroup,    GetCBGroupVal    ));
    ObjsList.AddObject('<DIALOG',    THTMLObjHandler.Create(FWebBrowser, '<DIALOG',    '</DIALOG>',    AddDialogGrp,  GetDialogGpVal   ));
  end;

  destructor THTMLObjHandlersList.Destroy;
  begin
    Clear;
    ObjsList.free;
    inherited;
  end;

  procedure THTMLObjHandlersList.Clear;
  var i : integer;
      AHTMLObjHandler : THTMLObjHandler;
  begin
    for i := 0 to ObjsList.Count - 1 do begin
      AHTMLObjHandler := THTMLObjHandler(ObjsList.Objects[i]);
      AHTMLObjHandler.Free;
      ObjsList.Objects[i] := nil;
    end;
    ObjsList.Clear;
  end;

  function THTMLObjHandlersList.HasHTMLObjTag(SourceLine : string; var OutHandler : THTMLObjHandler) : boolean;
  var i, P, BestP : integer;
      AHTMLObjHandler : THTMLObjHandler;
      StartTag : string;
      ResultIdx : integer;
  begin
    OutHandler := nil; //default
    Result := false;
    ResultIdx := -1;
    BestP := length(SourceLine) + 1;  //Init to end of line
    //Note: SourceLine may have more than one tag.  So must get FIRST one...
    for i := 0 to ObjsList.Count - 1 do begin
      AHTMLObjHandler := THTMLObjHandler(ObjsList.Objects[i]);
      StartTag := AHTMLObjHandler.StartTag;
      P := Pos(StartTag, SourceLine);
      if P = 0 then continue;
      if (ResultIdx = -1) or (P < BestP) then begin
        ResultIdx := i;
        BestP := P;
      end;
    end;
    if ResultIdx <> -1 then begin
      OutHandler := THTMLObjHandler(ObjsList.Objects[ResultIdx]);
      Result := true;
    end;
  end;

  function THTMLObjHandlersList.GetValue(HtmlDlg : TObject; id, StartTag : string; var Disabled : boolean; NoCommas : boolean = false) : string;
  //Note: HtmlDlg should be passed in as type THTMLDlg or THTMLTemplateDialogEntry
  var i : integer;
      AHTMLObjHandler : THTMLObjHandler;
      Elem : IHTMLElement;
  begin
    Result := '';
    i := ObjsList.IndexOf(StartTag);
    if i = -1 then exit;
    AHTMLObjHandler := THTMLObjHandler(ObjsList.Objects[i]);
    Elem := FWebBrowser.GetElementById(id);
    Disabled := IsDisabledByControlGroup(HTMLDlg, Elem);
    if Assigned(Elem) and not Disabled then begin
      Result := AHTMLObjHandler.FGetValFn(HtmlDlg, Elem, NoCommas);
    end;
  end;

  procedure THTMLObjHandlersList.FindControlGroupProperty(Elem : IHTMLElement; Msg : string; Obj : TObject; var Found : boolean);
  var outer : string;
  begin
    outer := Elem.outerHTML;
    Found := (Pos(Msg, Outer) >0);
  end;

  function THTMLObjHandlersList.IsDisabledByControlGroup(HtmlDlg : TObject; Elem : IHTMLElement) : boolean;
    //finish....
  var ControlBlockElem : IHTMLElement;
      ClassStr, StartTag, Msg, outer {,value} : string;
      ClassList, Attrs : TStringList;
      Idx : integer;
  begin
    Result := false;
    if not assigned(Elem) then exit;    
    outer := Elem.outerHTML;
    Attrs := TStringList.Create;
    StartTag := ORFn.piece2(outer, ' ', 1);
    ExtractAttribs(StartTag, outer, Attrs);
    ClassStr := GetAttrib('class', Attrs);
    if Pos('TMGDisabledControl', ClassStr) > 0 then begin
      Result := true;
    end else begin
      ClassList := TStringList.Create;
      ORFn.PiecesToList(ClassStr, ' ', ClassList);
      for Idx := 0 to ClassList.Count - 1 do begin
        Msg := ClassList.Strings[Idx];
        if Pos('ControlGroup', Msg) = 0 then continue;
        ControlBlockElem := FWebBrowser.SearchElements(FindControlGroupProperty, Msg, Nil);
        if ControlBlockElem = nil then break;
        outer := ControlBlockElem.outerHTML;
        ExtractAttribs('<INPUT', outer, Attrs);
        Result := (AttribIdx('checked', Attrs) = -1);
        break;
      end;
      ClassList.Free;
    end;
    Attrs.Free;
  end;



initialization
  IDMasterIndex := 0;

end.

