unit uHTMLDlg;
//kt added entire unit

{
  This unit is designed to support a Template Dialog in a HTML document, similar
  to traditional CPRS, except a web browser.  The original setup was such that
  one dialog would utilize the entire HTML document.

  It differs from the uHTMLTemplateFields unit in that that unit is designed to
  manage HTML templates that are embedded in HTML documents, with multiple templates
  possible in a single document, and multiple documents tracked.

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
  SysUtils, StrUtils, Classes, Controls, TMGHTML2, uHTMLDlgObjs;

  type
    THTMLDlg = class(TObject)
    private
      FWebBrowser: THtmlObj;  //NOTE: not required for assembly or parsing of source.
      FObjHandlersList : THTMLObjHandlersList;
      IDIndex : integer;
      FFinalHTML : TStringList;
      FIntermediateHTML : TStringList;  //HTML + script, but no header/footer
      FCumulativeBodyHTML : TStringList;    // HTML code so far, ultimately to be passed to some web browser
      FCumulativeScriptCode : TStringList;  //javascript, ultimately to be added to FCumulativeHTML during final compilation.  *Not* wrapped with <script>
      FCumulativeStyleCodes : TStringList;  //style codes, ultimately to be added to FCumulativeHTML during final compilation.  *Not* wrapped with <style>
      Compiled : boolean;
      procedure SLAppend(SL, AddOn : TStringList; Tag : string = '');
      procedure AddGlobalStyle(StyleCodes : TStringList);
      procedure GetOneSource(Source : TStringList; EndTag: string; var i : integer; Output : TStringList);
      procedure ExtractContent(StartTag, EndTag : string; Source, Content: TStringList);
      //procedure ExtractAttribs(StartTag : string; Source, Attrs: TStringList);
      procedure LoadResults;
      function ParsedIDListIndex(Id: string) : integer;
      function GetResultValues : TStringList;
      function GetCompletedHTML : TStringList;
      function GetPartialHTML : TStringList;
      procedure FinalCompile;
    public
      ParsedSource : TStringList;
      ParsedIDList : TStringList;   //will correlate 1:1 with FResultValues.  Format: Id=StartTag
      FResultValues : TStringList;   //will correlate 1:1 with ParsedIDList.  Format: <string with result>
      procedure Clear;
      procedure RefreshResults;
      procedure AddFromSource(Source: TStringList; EnableCBName : string='');  //used with recursive calls
      //procedure AssemblePart(Source : TStringList); overload;  //Get HTML for just part of web page
      procedure AssemblePart(Source, Script, Styles : TStringList); {overload;}  //Get HTML for just part of web page
      function GetValue(Index : integer) : string;
      function GetValueByID(ID : string; var Disabled : boolean; NoCommas : boolean = false) : string;
      function HasID(ID : string) : boolean;
      constructor Create(AWebBrowser: THtmlObj);
      destructor Destroy;
      property ResultValues : TStringList read GetResultValues;
      property HTML : TStringList read GetCompletedHTML;
      property PartialHTML  : TStringList read GetPartialHTML;
    end;

implementation

uses
  uHTMLTools, ORFn ;

  function THTMLDlg.GetCompletedHTML : TStringList;
  begin
    if not Compiled then FinalCompile;
    Result := FFinalHTML;
  end;

  function THTMLDlg.GetPartialHTML : TStringList;
  //Returns HTML + script code so far, but no header/footer
  begin
    FIntermediateHTML.Clear;
    FIntermediateHTML.Assign(FCumulativeBodyHTML);
    SLAppend(FIntermediateHTML, FCumulativeScriptCode, 'script');
    Result := FIntermediateHTML;
  end;

  procedure THTMLDlg.AddGlobalStyle(StyleCodes : TStringList);
  //Later I could have this style downloaded from server for future modification flexibility.
  begin
    (*
    StyleCodes.Add('p.inset {');
    StyleCodes.Add('  border-style: inset;');
    StyleCodes.Add('  border-width: 2px;');
    StyleCodes.Add('  height: 100px;');
    StyleCodes.Add('  background-color: #e5faff;');
    StyleCodes.Add('}');
    *)
    StyleCodes.Add('.selected {');
    StyleCodes.Add('  font-weight : bold;');
    StyleCodes.Add('  //background-color : yellow;');
    StyleCodes.Add('}');
    StyleCodes.Add('.unselected {');
    StyleCodes.Add('  font-weight : normal;');
    StyleCodes.Add('  //background-color : white;');
    StyleCodes.Add('}');
    StyleCodes.Add('');
  end;

  procedure THTMLDlg.SLAppend(SL, AddOn : TStringList; Tag : string = '');
  var i  : integer;
  begin
    if AddOn.Count = 0 then exit;
    if Tag <> '' then SL.Add('<'+tag+'>');
    for i := 0 to AddOn.Count - 1 do SL.Add(AddOn.Strings[i]);
    if Tag <> '' then SL.Add('</'+tag+'>');
  end;

  procedure THTMLDlg.GetOneSource(Source : TStringList; EndTag: string; var i : integer; Output : TStringList);
  var s,s2 : string;
      Done : boolean;
  begin
    Done := false;
    while (i < Source.Count) and (Done = false)  do begin
      s := Source.Strings[i];
      if Pos(EndTag, s) > 0 then begin
        s := ORFn.piece2(s, EndTag, 1) + EndTag;  //If s has code after EndTag, s will have that cut off
        s2 := MidStr(Source.Strings[i], Length(s)+1, Length(Source.Strings[i]));
        if s2 <> '' then begin
          Source.Strings[i] := s2;
          dec(i); //counteract later inc
        end;
        done := true;
      end;
      Output.Add(s);
      if not done then inc(i);
    end;
  end;

  procedure THTMLDlg.ExtractContent(StartTag, EndTag : string; Source, Content: TStringList);
  var strContent:string;
      p : integer;
  begin
    Content.Clear;
    strContent := ORFn.piece2(Source.text, EndTag,1);
    //strContent := ORFn.piece2(strContent,StartTag,2);
    p := Pos('>', strContent);
    strContent := MidStr(strContent, p+1, length(strContent));
    Content.add(strContent);
  end;

  procedure THTMLDlg.AddFromSource(Source: TStringList; EnableCBName : string='');
  (* Input: Source:  -- Format:
      <CHECKBOX: checkedvalue="something" uncheckedvalue="something else">Display Text</CHECKBOX>
      <EDITBOX: width="width value"}initial text goes here{/EDITBOX>
      <WPBOX: cols="width value" rows="height value"}Initial text goes here</WPBOX>
    Result: 1^OK, or -1^Error Message      *)
    //NOTE: this function is called recursively, back from controls that are wrapper or content-holding tags.
  var
    OneSource,Content, Attrs : TStringList;
    s, s1, s2, Id            : string;
    StartTag, EndTag         : string;
    i,TagNum, PosNum         : integer;
    TagFound                 : boolean;
    HTMLObjFactory           : THTMLObjHandler;
  begin
    //Result := '1^OK';
    OneSource := TStringList.Create;
    Content := TStringList.Create;
    Attrs := TStringList.Create;
    i := 0;
    while i < Source.Count do begin
      s := Source.Strings[i];
      TagFound := false;
      if FObjHandlersList.HasHTMLObjTag(s, HTMLObjFactory) then begin
        StartTag := HTMLObjFactory.StartTag;
        EndTag := HTMLObjFactory.EndTag;
        PosNum := Pos(StartTag, s);
        if (PosNum > 1) then begin
          s1 := ORFn.piece2(s, StartTag, 1);
          s2 := MidStr(s, Length(s1)+1, Length(s));
          s1 := StringReplace(s1, CRLF, '',  [rfReplaceAll]);
          FCumulativeBodyHTML.Add(s1);
          ParsedSource.Add(s1);
          s := s2; PosNum := 1; Source.Strings[i] := s;
        end;
        if PosNum > 0 then begin
          TagFound := true;
          OneSource.Clear;
          GetOneSource(Source, EndTag, i, Onesource);
          ExtractContent(StartTag, EndTag, OneSource, Content);
          ExtractAttribs(StartTag, OneSource, Attrs);
          if EnableCBName <> '' then begin  //If control is in container, it is disabled by default.
            EnsureClass(Attrs,EnableCBName);
            EnsureClass(Attrs,'TMGDisabledControl');
            Attrs.Add('disabled');
          end;
          HTMLObjFactory.AddProc(Self, OneSource, Attrs, FCumulativeBodyHTML, Content, FCumulativeScriptCode, FCumulativeStyleCodes, Id);
          ParsedSource.Add('<TMGHTMLOBJ id="'+Id+'">');
          ParsedIDList.Add(Id+'='+StartTag);
        end;
      end;
      if not TagFound then begin
        s := StringReplace(s, CRLF, '',  [rfReplaceAll]);
        FCumulativeBodyHTML.Add(s);
        ParsedSource.Add(s);
      end;
      inc(i);
    end;
    Content.Free;
    OneSource.Free;
    Attrs.Free;
  end;

  procedure THTMLDlg.FinalCompile;
  var i : integer;
  begin
    FFinalHTML.Clear;
    FFinalHTML.Add('<!DOCTYPE html>');
    FFinalHTML.Add('<html>');
    FFinalHTML.Add('<head>');
    FFinalHTML.Add('  <META http-equiv=Content-Type content="text/html; charset=utf-8">');
    FFinalHTML.Add('  <META http-equiv=Pragma content=no-cache>');
    FFinalHTML.Add('  <META http-equiv=Cache-Control content=no-cache>');
    SLAppend(FFinalHTML, FCumulativeStyleCodes, 'style');
    FFinalHTML.Add('</head>');
    FFinalHTML.Add('<body>');
    SLAppend(FFinalHTML, FCumulativeBodyHTML);
    FFinalHTML.Add('</body>');
    //Some script elements immediately run on load, and HTML <TAG>'s must exist, so script
    //has to be appear AFTER FCumulativeBodyHTML in the HTML document.
    SLAppend(FFinalHTML, FCumulativeScriptCode, 'script');
    FFinalHTML.Add('</html>');
    Compiled := true;
  end;

  procedure THTMLDlg.AssemblePart(Source, Script, Styles : TStringList);
  begin
    SLAppend(FCumulativeScriptCode, Script);
    SLAppend(FCumulativeStyleCodes, Styles);
    //AssemblePart(Source);
    AddFromSource(Source, '');
  end;

  {
  procedure THTMLDlg.AssemblePart(Source : TStringList);
 //Get HTML for just part of web page
  //Input: Source:  -- Format: see AddFromSource documentation
  //Output: local HTML is loaded.
  begin
    AddFromSource(Source, '');
  end;
  }

  function THTMLDlg.ParsedIDListIndex(Id: string) : integer;
  //ParsedIDList  --Format Id=StartTag
  var i : integer;
      UpperID : string;
  begin
    Result := -1;
    UpperID := UpperCase(Id);
    for i := 0 to ParsedIDList.Count - 1 do begin
      if UpperCase(ParsedIDList.Names[i]) <> UpperID then continue;
      Result := i;
      break;
    end;
  end;

  procedure THTMLDlg.LoadResults;
  var i : integer;
      //s  : string;
      id, StartTag, value : string;
      Disabled : boolean;
  begin
    FResultValues.Clear;
    for i := 0 to ParsedIDList.Count - 1 do begin
      //s := ParsedIDList.Strings[i];
      id := ParsedIDList.Names[i];
      StartTag := ParsedIDList.ValueFromIndex[i];
      //id := piece(s, '=', 1);
      //StartTag := piece(s, '=',2);
      value := FObjHandlersList.GetValue(self, id, StartTag, Disabled);
      //If Disabled, then value should be ''
      FResultValues.Add(value);
    end;
  end;

  function THTMLDlg.HasID(ID : string) : boolean;
  var i : integer;
  begin
    Result := false;
    ID := UpperCase(ID);
    for i := 0 to ParsedIDList.Count - 1 do begin
      if UpperCase(ParsedIDList.Names[i]) <> ID then continue;
      Result := true;
      break;
    end;
  end;

  function THTMLDlg.GetValueByID(ID : string; var Disabled : boolean; NoCommas : boolean = false) : string;
  //RefreshResults/LoadResults does NOT need to be called first.
  var i : integer;
      AnID, StartTag, value : string;
  begin
    Result := '';
    FResultValues.Clear;
    ID := UpperCase(ID);
    Disabled := false;
    for i := 0 to ParsedIDList.Count - 1 do begin
      AnID := UpperCase(ParsedIDList.Names[i]);
      if AnID <> ID then continue;
      StartTag := ParsedIDList.ValueFromIndex[i];
      Result := FObjHandlersList.GetValue(self, id, StartTag, Disabled, NoCommas);
      break;
    end;
  end;

  procedure THTMLDlg.RefreshResults;
  begin
    LoadResults;
  end;

  function THTMLDlg.GetValue(Index : integer) : string;
  begin
    If FResultValues.count = 0 then LoadResults;
    if (Index >=0) and (Index < FResultValues.Count) then begin
      Result := FResultValues.Strings[Index];
    end else begin
      Result := '';
    end;
  end;

  function THTMLDlg.GetResultValues : TStringList;
  begin
    RefreshResults;
    Result := FResultValues;
  end;

  procedure THTMLDlg.Clear;
  begin
    ParsedIDList.Clear;
    ParsedSource.Clear;
    FResultValues.Clear;
    FCumulativeBodyHTML.Clear;
    FCumulativeScriptCode.Clear;
    FCumulativeStyleCodes.Clear;
    AddGlobalStyle(FCumulativeStyleCodes);
    FFinalHTML.Clear;
    FIntermediateHTML.Clear;
    Compiled := False;
  end;

  constructor THTMLDlg.Create(AWebBrowser: THtmlObj);
  begin
    inherited Create;
    IDIndex := 0;
    FWebBrowser := AWebBrowser;
    FObjHandlersList := THTMLObjHandlersList.Create(AWebBrowser);
    ParsedSource := TStringList.Create;
    ParsedIDList := TStringList.Create;
    FResultValues := TStringList.Create;
    FCumulativeBodyHTML := TStringList.Create;
    FFinalHTML := TStringList.Create;
    FCumulativeScriptCode := TStringList.Create;
    FCumulativeStyleCodes := TStringList.Create;
    AddGlobalStyle(FCumulativeStyleCodes);
    FIntermediateHTML := TStringList.Create;
    Compiled := False;
  end;

  destructor THTMLDlg.Destroy;
  begin
    //
    FObjHandlersList.Free;
    ParsedSource.Free;
    ParsedIDList.Free;
    FResultValues.Free;
    FCumulativeBodyHTML.Free;
    FCumulativeScriptCode.Free;
    FCumulativeStyleCodes.Free;
    FFinalHTML.Free;
    FIntermediateHTML.Free;
    inherited;
  end;

end.

