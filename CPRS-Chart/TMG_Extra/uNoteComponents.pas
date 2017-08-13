unit uNoteComponents;
//kt added this entire unit, and all functions in it.
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

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls, Dialogs,
  uTIU,
  ORCtrls, StrUtils, ORFn, ORNet, rTemplates;

  type
    TCompNode = class(TObject)
    private
      FParent : TCompNode;
      function GetChild(Index: integer) : TCompNode;
    public
      NoteIEN : int64;
      Name    : string;
      TextSL : TStringList;
      Children : TStringList;
      HTMLMode : boolean;
      function AddChild(Name : string) : TCompNode;
      function HasChildren : boolean;
      procedure Clear;
      constructor Create(Parent : TCompNode; Name : string = '');
      destructor Destroy; override;
      property Child[Index : integer] : TCompNode read GetChild;
      property Parent : TCompNode read FParent;
    end;

    TTransformProc = procedure (var txt : string; PrintName : string) of object;

  const
   TMG_COMPONENT_TAG       = '{COMPONENT ';
   TMG_COMPONENT_START_TAG = TMG_COMPONENT_TAG + 'START';
   TMG_COMPONENT_END_TAG   = TMG_COMPONENT_TAG + 'END';
   TMG_COMP_BOILERPLATE    = 'TMG COMPONENT PROB BOILERPLATE';
   //TMG_COMP_BPL_TAG  = '&TMG&';
   //TMG_COMP_BPL_START_TAG  = TMG_COMP_BPL_TAG + '[';  //e.g. '&TMG&['
   //TMG_COMP_BPL_END_TAG    = ']' + TMG_COMP_BPL_TAG;  //e.g. ']&TMG&'

  procedure ParseTemplate(var Text : string; AParent : TCompNode; TransformFn : TTransformProc; HTMLTarget : boolean);
  procedure ParseTemplateSL(TemplateSL : TStringList; AParent : TCompNode; TransformFn : TTransformProc; HTMLTarget : boolean);
  function TemplateHasComponents(Text : string) : boolean;
  function TemplateHasComponentsSL(TemplateSL : TStringList) : boolean;
  procedure HiddenCreateComponentCluster(Root : TCompNode);
  function AddComponentForProblem(ProbIEN, ProbTitle, ProbICD : string; HTML : boolean; DocSelRec : TDocSelRec) : boolean;
  function GetInsertionTextForCompProb(ProbIEN, ProbTitle, ProbICD: string; HTML : boolean; SL : TStringList) : boolean;
  function IndexOfPiece(SL : TStringList; Value : String; Delim : string; PieceNum : integer; StartIdx : integer = 0) : integer;


 var
   NoteComponentsRoot : TCompNode;
   //TMGNoteComponentProblemData : string;
   //TMGNoteComponentTemplateIEN : string;



implementation

uses
    fNotes, uCore, rCore, rTIU,
    uHTMLTools, uTemplates,
    fNoteCompParentPick, fDrawers, fFrame
    ;

type
  TCompTagMode = (ctNone, ctStart, ctEnd);


function TCompNode.GetChild(Index: integer) : TCompNode;
begin
  if (Index > -1) and (Index < Children.Count)  then begin
    Result := TCompNode(Children.Objects[Index]);
  end else begin
    Result := nil;
  end;
end;

function TCompNode.AddChild(Name : string) : TCompNode;
var AChild : TCompNode;
begin
  AChild := TCompNode.Create(Self);
  AChild.Name := Name;
  Children.AddObject(Name,AChild);
  Result := AChild;
end;

procedure TCompNode.Clear;
var i : integer;
begin
  for i := 0 to Children.Count - 1 do begin
    TCompNode(Children.Objects[i]).Destroy;
  end;
  Children.Clear;
  Self.Name := '';
  TextSL.Clear;
  NoteIEN := -1;
  HTMLMode := false;
end;

function TCompNode.HasChildren : boolean;
begin
  Result := (Children.Count > 0);
end;


constructor TCompNode.Create(Parent: TCompNode; Name : string = '');
begin
  Inherited Create;
  FParent := Parent;
  Self.Name := Name;
  TextSL := TStringList.Create;
  Children := TStringList.Create;
  NoteIEN := -1;
  HTMLMode := false;
end;


destructor TCompNode.Destroy;
begin
  Clear;
  TextSL.Free;
  Children.Free;
  Inherited;
end;


//=====================================================
function PosNCS(SubStr : string; Str: string) : integer;    //Position Not-Case-Sensitive
begin
  Result := pos(UpperCase(SubStr), UpperCase(Str));
end;

function IndexOfPiece(SL : TStringList; Value : String; Delim : string; PieceNum : integer; StartIdx : integer = 0) : integer;
//Return first index, in SL, of string containing value found at given piece number
var i : integer;
begin
  Result := -1;
  if not assigned(SL) then exit;
  for i := StartIdx to SL.Count - 1 do begin
    if Piece2(SL.Strings[i], Delim, PieceNum) <> Value then continue;
    Result := i;
    break;
  end;
end;


function TemplateHasComponents(Text : string) : boolean;
begin
  Result := (PosNCS(TMG_COMPONENT_TAG, Text) > 0);
end;

function TemplateHasComponentsSL(TemplateSL : TStringList) : boolean;
begin
  Result := TemplateHasComponents(TemplateSL.Text);
end;

function HasCompTag(S : string; var BlockName : string; var Mode : TCompTagMode; var PreStr : string; var PostStr : string) : boolean;
var p : integer;
    sB : string;
    temp : string;
begin
  PreStr := '';
  PostStr := '';
  Result := false;
  Mode := ctNone;
  p := PosNCS(TMG_COMPONENT_TAG, S);
  if p = 0 then exit;  //return false
  PreStr := MidStr(S, 1, p-1);
  sB := MidStr(S, p, length(S));
  p := Pos('}', sB);
  if (p = 0) then exit; //Return false.  Here we have an ERROR STATE, no closing '}' found.
  Result := true;
  temp := MidStr(sB, 1, p-1);  //e.g. '{Component Start: HPI' or '{Component End: HPI'
  PostStr := MidStr(sB, p+1, length(sB));
  BlockName := Trim(piece(temp,':',2));  //e.g. 'HPI'
  if PosNCS(TMG_COMPONENT_START_TAG, temp)>0 then Mode := ctStart
  else if PosNCS(TMG_COMPONENT_END_TAG, temp)>0 then Mode := ctEnd;
end;

procedure ExtractSL(ParentSL : TStringList; Index : integer; ChildSL : TStringList; var ChildBlockName : string);
//NOTE: it is expected that string on line Index will contain TMG_COMPONENT_TAG
(*Possible situations for first line of ParentSL
   [parent text]{COMPONENT START: HTN}[child text]  --> [parent text] is left in ParentSL, and [child text] is put in ChildSL
   {COMPONENT START: HTN}[child text]  --> Line is deleted from ParentSL, and [child text] is put in ChildSL
   [parent text]{COMPONENT START: HTN}    --> [parent text] is left in ParentSL

*)
var i : integer;
    s : string;
    BlockName : string;
    PreStr, PostStr : string;
    Mode : TCompTagMode;
begin
  i := Index;
  s := ParentSL.Strings[i];
  ChildBlockName := '';
  if not HasCompTag(s, BlockName, Mode, PreStr, PostStr) then exit;
  if Mode <> ctStart then exit;
  ChildBlockName := BlockName;
  if PreStr <> '' then begin
    ParentSL.Strings[i] := PreStr;
    Inc(i);
  end else begin
    ParentSL.Delete(i);
  end;
  if PostStr <> '' then ChildSL.Add(PostStr);
  while (i < ParentSL.Count) do begin
    s := ParentSL.Strings[i];
    if HasCompTag(s, BlockName, Mode, PreStr, PostStr) and (BlockName = ChildBlockName) and (Mode = ctEnd) then begin
      if PreStr <> '' then ChildSL.Add(PreStr);
      if PostStr <> '' then begin
        ParentSL.Strings[i] := PostStr;
      end else begin
        ParentSL.Delete(i);
      end;
      break;
    end else begin
      ChildSL.Add(s);
      ParentSL.Delete(i);
    end;
  end;
end;

procedure ParseTemplateSL(TemplateSL : TStringList; AParent : TCompNode; TransformFn : TTransformProc; HTMLTarget : boolean);
//Expected input format:  Each line below is example line passed in TStringList
//NOTE: TemplateSL will be modified such that child components are put into tree nodes,
//      and only NON-component parts are left.
//NOTE: Template text should come BEFORE any children nodes are declared.  If template
//      text is found after children are declared, it will simply be lumped text that
//      was found above.
//NOTE: Block names MUST BE UNIQUE
//
//Template text here for the top level.
//{Component Start: INTRO}
//template text here for intro...
//{Component Start: HPI}
//template text here for HPI...
//{Component Start: HTN}
//template text here for HTN...
//{Component End: HTN}
//{Component Start: DM-2}
//template text here for DM-2...
//{Component End: DM-2}
//{Component End: HPI}
//{Component Start: PMH}
//template text here for PMH...
//{Component End: PMH}
//{Component Start: PE}
//template text here for PE...
//{Component End: PE}
//{Component Start: AP}
//template text here forAP...
// {Component End: AP}
var ChildSL      : TStringList;
    i            : integer;
    BlockName, s : string;
    AChild       : TCompNode;
begin
  if AParent = nil then begin
    NoteComponentsRoot.Clear;
    AParent := NoteComponentsRoot;
  end;
  ChildSL := TStringList.create;
  i := 0;
  while (i < TemplateSL.Count) do begin
    s := TemplateSL.Strings[i];
    if PosNCS(TMG_COMPONENT_START_TAG, s) > 0 then begin
      ExtractSL(TemplateSL, i, ChildSL, BlockName);
      AChild := AParent.AddChild(BlockName);
      AChild.HTMLMode := HTMLTarget;
      ParseTemplateSL(ChildSL, AChild, TransformFn, HTMLTarget);
    end else begin
      AParent.TextSL.Add(s);
      TemplateSL.Delete(i);
    end;
  end;
  if assigned(TransformFn) then begin
    s := AParent.TextSL.Text;
    TransformFn(s, '<component ' + AParent.Name + '>'); //callback function
    AParent.TextSL.Text := s;
  end;
  ChildSL.free;
end;

procedure ParseTemplate(var Text : string; AParent : TCompNode; TransformFn : TTransformProc; HTMLTarget : boolean);
var SL : TStringList;
begin
  SL := TStringList.Create;
  SL.Text := Text;
  ParseTemplateSL(SL, AParent, TransformFn, HTMLTarget);
  Text := SL.Text;
  SL.Free;
end;


procedure HiddenCreateCompNoteAndChildren(ParentNoteIEN : int64; ANode : TCompNode);
//NOTE: The root node must represent the document into which the cluster is being
//      inserted.  Root.NoteIEN must be IEN of the root document.
//
var i : integer;
    NoteRec : TNoteRec;
    CreatedDoc: TCreatedDoc;
    BlankNote : TStringList;
begin
  if ParentNoteIEN < 0 then exit;
  NoteRec.Author := User.DUZ;
  NoteRec.DateTime := FMNow;
  NoteRec.Subject := ANode.Name;
  //NOTE: At this point, text in ANode.TextSL *has* already been transformed by template engine.
  BlankNote := TStringList.Create;
  If ANode.HTMLMode then begin
    MakeBlankHTMLDoc(BlankNote);
    for i := 0 to ANode.TextSL.Count - 1 do begin
      BlankNote.Insert(BlankNote.Count-1, ANode.TextSL.Strings[i]);
    end;
  end else begin
    BlankNote.Assign(ANode.TextSL);
  end;
  NoteRec.Lines := BlankNote;
  PutComponent(CreatedDoc, NoteRec, ParentNoteIEN);  //Create component by RPC
  FreeAndNil(BlankNote);
  ANode.NoteIEN := CreatedDoc.IEN;
  if CreatedDoc.ErrorText <> '' then begin
    MessageDlg(CreatedDoc.ErrorText, mtError, [mbOK], 0);
    exit;
  end;
  //Add children components, if any
  for i := ANode.Children.Count - 1 downto 0 do begin
    HiddenCreateCompNoteAndChildren(ANode.NoteIEN, ANode.GetChild(i));
  end;
end;


procedure HiddenCreateComponentCluster(Root : TCompNode);
//NOTE: The root node must represent the document into which the cluster is being
//      inserted.  Root.NoteIEN must be IEN of the root document.
var i : integer;
begin
  //Add children
  for i := 0 to Root.Children.Count - 1 do begin
    HiddenCreateCompNoteAndChildren(Root.NoteIEN, Root.GetChild(i));
  end;
  //At this point, note components will exist on server, but will not be visible in CPRS
  //fNotes.ReLoadNotes can be called to load them into treeview
end;

function GetInsertionTextForCompProb(ProbIEN, ProbTitle, ProbICD : string; HTML : boolean; SL : TStringList) : boolean;
//Result: True if OK, or false if tutorial text returned.
var TempSL : TStringList;
    s, RPCResult : string;
    HTMLStr : string;
    NoteComponentTemplateIEN : string;

begin
  TempSL := TStringList.Create;
  RPCResult := TMGSearchTemplates(TempSL, TMG_COMP_BOILERPLATE, User.DUZ);
  if (piece(RPCResult, U, 1) = '1') and (TempSL.Count >0) then begin
    s := TempSL.Strings[0];
    NoteComponentTemplateIEN := piece(piece(s,'^',1),';',1);
    GetTemplateBoilerplate(NoteComponentTemplateIEN);
    SL.Assign(RPCBrokerV.Results);
    if HTML then HTMLStr := '1' else HTMLStr := '0';
    
    s := SL.Text;
    s := StringReplace(s,'%PROBNAME%',ProbTitle,[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s,'%PROBICD%',ProbICD,[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s,'%PROBIEN%',ProbIEN,[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s,'%HTML%',HTMLStr,[rfReplaceAll, rfIgnoreCase]);
    SL.Text := s;
    GetTemplateText(SL);
    Result := true;
  end else begin
    SL.Add('Boiler plate text template "'+TMG_COMP_BOILERPLATE+'" not found.');
    SL.Add('Please create this using CPRS Template Editor.');
    SL.Add('');
    SL.Add('Examples of text that this template could hold:');
    SL.Add(' "SECTION %PROBNAME%:" <-- %PROBNAME% will be replaced with ProblemName');
    SL.Add(' "ICD= %PROBICD%:" <-- %PROBICD% will be replaced with ProblemICD');
    SL.Add('');
    SL.Add('-or-');
    SL.Add('');
    SL.Add(' "|MY TEXT OBJECT|');
    SL.Add('');
    SL.Add('-or-');
    SL.Add('');
    SL.Add(' "|MY TEXT OBJECT(%PROBIEN%^%PROBNAME%^%PROBICD%^%HTML%)|    <-- *');
    SL.Add('');
    SL.Add('      * %PROBIEN% will be substituted with the "Problem IEN"');
    SL.Add('      * %PROBNAME% will be substituted with the "Problem Name"');
    SL.Add('      * %PROBICD% will be substituted with the "Problem ICD code"');
    SL.Add('      * %HTML% will be substituted with the "1" if in HTML mode, otherwise "0"');
    SL.Add('      * The combined values will be passed as one string, e.g. "1234^COPD^1"');
    SL.Add('     ** Passing a parameter to a text object makes use of TMG customization.');
    SL.Add('');
    Result := False;
  end;
  TempSL.Free;
end;


function AddComponentForProblem(ProbIEN, ProbTitle, ProbICD: string; HTML : boolean; DocSelRec : TDocSelRec) : boolean; //kt temp
//Adds a note component and links that new component to the problem
//NOTE: Currently this just supports adding components into the Notes tab.  Later, if I want
//      to support adding into consults or DCSummaries, will need to rework code below, probably
//      by passing in reference of where to insert into....
//Result: True if OK, or False if problem
var ParentData :                      string;
    ParentIENString :                 string;
    ParentIEN :                       int64;
    ParentNode :                      TORTreeNode;
    AddedData :                       string;
    AddedIENString :                  string;
    POVIEN :                          string;
    TempSL :                          TStringList;
    frmNoteCompParentPick:            TfrmNoteCompParentPick;
    Template :                        TTemplate;

begin
  TempSL := nil;   //shouldn't be required, but it is...
  Template := nil; //shouldn't be required, but it is...
  Result := false; //default to problem.
  if ProbIEN = '' then exit;
  if DocSelRec.TreeType <> edseNotes then begin
    MessageDlg('Sorry.  Only adding components into NOTES supported at this time.', mtError, [mbOK], 0);
    //Adding into consults just needs to be implemented....  Code specific for notes tab would have to be
    //  generalized below.
    exit;
  end;
  frmNoteCompParentPick := TfrmNoteCompParentPick.Create(nil);
  try
    if not frmNoteCompParentPick.PrepForm(DocSelRec) then begin
      MessageDlg('Sorry.  No unsigned notes to add into.', mtError, [mbOK], 0);
      exit;
    end;
    if frmNoteCompParentPick.showmodal <> mrOK then exit;
    if not assigned(frmNoteCompParentPick.SelectedNode) then exit;
    ParentData := frmNoteCompParentPick.SelectedNode.StringData;  //get data of chosen note.
    ParentIENString := Piece(ParentData, U,1);
    ParentIEN := StrToInt64Def(ParentIENString,0);
    if ParentIEN <=0 then exit;
    ParentNode := frmNotes.tvNotes.FindPieceNode(ParentIENString, 1, U);   //change to DocSelRec.TreeView
    if not assigned(ParentNode) then begin
      MessageDlg('Couldn''t find selected node in notes tab', mtError, [mbOK],0);
      exit;
    end;
    frmFrame.mnuChartTabClick(frmNotes.mnuChartNotes);
    frmNotes.TMGForceSaveSwitchEdit := true;
    TempSL := TStringList.Create;
    If HTML then MakeBlankHTMLDoc(TempSL);
    //NOTE: Text lies in TempSL are directly inserted into note, and are not put through template engine.
    //     So will just pass in codes for blank HTML document, and then insert any wanted text after
    //     component has been created.                q
    AddedData := frmNotes.AddComponentAndSelect(ParentData, ProbTitle, TempSL);
    AddedIENString := piece(AddedData, U, 1);
    TempSL.Clear;
    if assigned(DocSelRec.Drawers) then begin
      GetInsertionTextForCompProb(ProbIEN, ProbTitle, ProbICD, HTML, TempSL);
      Template := TTemplate.Create('0^T');
      Template.TMGForceSetFullBoilerplate(TempSL.Text);
      TfrmDrawers(DocSelRec.Drawers).InsertTemplateText(Template);
    end;
    POVIEN := '';  //later could do something with this, if needed.  POV = Purpose Of Visit.
    //TempSL.Clear;
    AddProblemLink(TempSL, AddedIENString, ProbIEN, POVIEN);
    if (TempSL.Count > 0) and (TempSL.Strings[0] <> '1^OK') then begin
      MessageDlg(piece(TempSL.Strings[0], U,2), mtError, [mbOK],0);
    end else begin
      Result := true;
    end;
  finally
    frmNoteCompParentPick.Free;
    TempSL.Free;
    Template.Free;
  end;
end;


initialization
   NoteComponentsRoot := TCompNode.Create(nil, 'Root');

finalization
  NoteComponentsRoot.Free;

end.

