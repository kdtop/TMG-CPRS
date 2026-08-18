unit uDocTree;
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


interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, ORCtrls, ComCtrls, uTIU
     ,Forms;  //tmg  5/6/22

const
  // Keep this in sync with the highest piece number accessed during tree-load preparse.
  // Increase it if later code begins using higher-numbered RPC pieces in this path. //kt //codex 8/18/26
  MAX_TREE_SPAN_PIECE = 18; //kt //codex 8/18/26
  TREE_PROGRESS_UPDATE_INTERVAL = 100; //kt //codex 8/18/26

type
  PDocTreeObject = ^TDocTreeObject;
  TDocTreeObject = record
    DocID          : string ;                 //Document IEN
    DocDate        : string;                  //Formatted date of document
    DocTitle       : string;                  //Document Title Text
    NodeText       : string;                  //Title, Location, Author  (depends on tab)
    ImageCount     : integer;                 //Number of images
    VisitDate      : string;                  //ADM/VIS: date;FMDate
    DocFMDate      : string;                  //FM date of document
    DocHasChildren : string;                  //Has children  (+,>,<)
    DocParent      : string;                  //Parent document, or context
    Author         : string;                  //DUZ;Author name
    PkgRef         : string;                  //IEN;Package    (consults only, for now)
    Location       : string;                  //Location name
    Status         : string;                  //Status
    Subject        : string;                  //Subject
    OrderID        : string;                  //Order file IEN (consults only, for now)
    OrderByTitle   : boolean;                 //Within ID Parents, order children by title, not date
  end;
  TPieceSpan = record //kt //codex 8/18/26
    StartPos: Integer; //kt //codex 8/18/26
    Len: Integer; //kt //codex 8/18/26
  end; //kt //codex 8/18/26
  TDocPieceSpanArray = array[1..MAX_TREE_SPAN_PIECE] of TPieceSpan; //kt //codex 8/18/26
  TDocTreeIndex = class(TStringList) //kt //codex 8/18/26
  public
    destructor Destroy; override; //kt //codex 8/18/26
  end; //kt //codex 8/18/26

// Procedures for document treeviews/listviews
function IsComponent(Title, Subject : string) : boolean;       overload; //kt 5/15
function IsComponent(Node : TORTreeNode) : boolean;            overload; //kt 5/15
function IsComponent(IEN : int64; TV : TORTreeview;
                  StartingNode : TORTreeNode = nil) : boolean; overload; //kt 5/15
procedure CreateListItemsForDocumentTree(Dest, Source: TStrings; Context: integer; GroupBy: string;
          Ascending: boolean; TabIndex: integer);
procedure BuildDocumentTree(DocList: TStrings; const Parent: string; Tree: TORTreeView; Node: TORTreeNode;
          TIUContext: TTIUContext; TabIndex: integer);
procedure SetTreeNodeImagesAndFormatting(Node: TORTreeNode; CurrentContext: TTIUContext; TabIndex: integer);
procedure ResetDocTreeObjectStrings(AnObject: PDocTreeObject);
procedure KillDocTreeObjects(TreeView: TORTreeView);
procedure KillDocTreeNode(ANode: TTreeNode);
procedure KillDocTreeChildrenOfNode(ANode: TORTreeNode);  //kt //tmg added 6/7/26
procedure KillDocTreeNodeAndChildren(ANode: TORTreeNode); //kt //tmg added 6/7/26
function  ContextMatch(ANode: TORTreeNode; AParentID: string; AContext: TTIUContext): Boolean;
function  TextFound(ANode: TORTreeNode; CurrentContext: TTIUContext): Boolean;
procedure RemoveParentsWithNoChildren(Tree: TTreeView; Context: TTIUContext);
procedure TraverseTree(ATree: TTreeView; AListView: TListView; ANode: TTreeNode; MyNodeID: string;
          AContext: TTIUContext);
procedure AddListViewItem(ANode: TTreeNode; AListView: TListView);
function  MakeNoteTreeObject(x: string): PDocTreeObject;
function  MakeDCSummTreeObject(x: string): PDocTreeObject;
function  MakeConsultsNoteTreeObject(x: string): PDocTreeObject;
function  DocTreeData(ANode: TTreeNode): PDocTreeObject; //kt //codex 8/18/26

implementation

uses
  StrUtils, //kt added
  fNotes,fNotesLoading, uTMGOptions,     //tmg  5/6/22
  rConsults, uDCSumm, uConsults;

function VisitDateLabel(const [Ref] VisitInfo: string): string; //kt //codex 8/18/26
begin
  Result := Piece(VisitInfo, ';', 1); //kt //codex 8/18/26
end;

function VisitDateFMDate(const [Ref] VisitInfo: string): string; //kt //codex 8/18/26
begin
  Result := Piece(Piece(VisitInfo, ';', 2), '.', 1); //kt //codex 8/18/26
end;

function NoteAuthorDisplay(const [Ref] NoteText: string): string; //kt //codex 8/18/26
var
  AuthorInfo: string; //kt //codex 8/18/26
begin
  AuthorInfo := Piece(NoteText, U, 5); //kt //codex 8/18/26
  Result := Piece(AuthorInfo, ';', 1) + ';' + Piece(AuthorInfo, ';', 3); //kt //codex 8/18/26
end;

function NoteAuthorName(const [Ref] NoteText: string): string; //kt //codex 8/18/26
begin
  Result := Piece(Piece(NoteText, U, 5), ';', 3); //kt //codex 8/18/26
end;

function SpanText(const [Ref] S: string; const Span: TPieceSpan): string; forward; //kt //codex 8/18/26

function SpanTextDef(const [Ref] S: string; const Span: TPieceSpan; const DefaultValue: string): string; //kt //codex 8/18/26
begin
  Result := SpanText(S, Span); //kt //codex 8/18/26
  if Result = '' then Result := DefaultValue; //kt //codex 8/18/26
end;

function SpanStartsWithAny(const SpanValue: string; const Prefixes: array of Char): Boolean; //kt //codex 8/18/26
var
  i: Integer; //kt //codex 8/18/26
begin
  Result := False; //kt //codex 8/18/26
  if SpanValue = '' then Exit; //kt //codex 8/18/26
  for i := Low(Prefixes) to High(Prefixes) do //kt //codex 8/18/26
    if SpanValue[1] = Prefixes[i] then begin Result := True; Exit; end; //kt //codex 8/18/26
end;

function SemicolonPiece(const [Ref] S: string; PieceNum: Integer): string; //kt //codex 8/18/26
begin
  Result := Piece(S, ';', PieceNum); //kt //codex 8/18/26
end;

function NoteAuthorNameFromInfo(const [Ref] AuthorInfo: string): string; //kt //codex 8/18/26
begin
  Result := SemicolonPiece(AuthorInfo, 2); //kt //codex 8/18/26
end;

function NoteAuthorDisplayFromInfo(const [Ref] AuthorInfo: string): string; //kt //codex 8/18/26
begin
  Result := SemicolonPiece(AuthorInfo, 1) + ';' + SemicolonPiece(AuthorInfo, 3); //kt //codex 8/18/26
end;

function NoteTitleDateFormat: string; //kt //codex 8/18/26
const
  DEFAULT_NOTE_TITLE_DATE_FORMAT = 'mmm dd,yy'; //kt //codex 8/18/26
var
  CachedValue: string; //kt //codex 8/18/26
begin
  if CachedValue = '' then CachedValue := uTMGOptions.ReadString('TMG CPRS NOTE DATE FORMAT', DEFAULT_NOTE_TITLE_DATE_FORMAT); //kt //codex 8/18/26
  Result := CachedValue; //kt //codex 8/18/26
end;

function NormalizeDocHasChildren(const [Ref] RawValue: string): string; //kt //codex 8/18/26
begin
  Result := RawValue; //kt //codex 8/18/26
  if (Result <> '') and (Result[1] = '*') then Result := Copy(Result, 2, 5); //kt //codex 8/18/26
end;

function NoteDisplayTextFromSpans(const [Ref] RawText: string; const Spans: TDocPieceSpanArray): string; //kt //codex 8/18/26
var
  DocID, DocTitle, Location, AuthorInfo, DocDate: string; //kt //codex 8/18/26
begin
  DocID := SpanText(RawText, Spans[1]); //kt //codex 8/18/26
  DocTitle := SpanTextDef(RawText, Spans[2], '** No Title **'); //kt //codex 8/18/26
  if SpanStartsWithAny(DocID, ['A', 'N', 'E']) then begin //kt //codex 8/18/26
    Result := DocTitle; //kt //codex 8/18/26
    Exit; //kt //codex 8/18/26
  end; //kt //codex 8/18/26
  Location := SpanTextDef(RawText, Spans[6], '** No Location **'); //kt //codex 8/18/26
  AuthorInfo := SpanText(RawText, Spans[5]); //kt //codex 8/18/26
  DocDate := FormatFMDateTime(NoteTitleDateFormat, MakeFMDateTime(SpanText(RawText, Spans[3]))); //kt //codex 8/18/26
  Result := DocDate + '  ' + DocTitle + ', ' + Location + ', ' + NoteAuthorNameFromInfo(AuthorInfo); //kt //codex 8/18/26
end;

function DCSummDisplayTextFromSpans(const [Ref] RawText: string; const Spans: TDocPieceSpanArray): string; //kt //codex 8/18/26
var
  DocID, Piece9Text: string; //kt //codex 8/18/26
begin
  DocID := SpanText(RawText, Spans[1]); //kt //codex 8/18/26
  if SpanStartsWithAny(DocID, ['A', 'N', 'E']) then begin //kt //codex 8/18/26
    Result := SpanTextDef(RawText, Spans[2], '** No Title **'); //kt //codex 8/18/26
    Exit; //kt //codex 8/18/26
  end; //kt //codex 8/18/26
  Piece9Text := SpanText(RawText, Spans[9]); //kt //codex 8/18/26
  if Copy(Piece9Text, 1, 4) = '    ' then Piece9Text := 'Dis: '; //kt //codex 8/18/26
  Result := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(SpanText(RawText, Spans[3]))) + '  ' + //kt //codex 8/18/26
            SpanTextDef(RawText, Spans[2], '** No Title **') + ', ' + //kt //codex 8/18/26
            SpanTextDef(RawText, Spans[6], '** No Location **') + ', ' + //kt //codex 8/18/26
            NoteAuthorNameFromInfo(SpanText(RawText, Spans[5])) + '  (' + SpanText(RawText, Spans[7]) + '), ' + //kt //codex 8/18/26
            VisitDateLabel(SpanText(RawText, Spans[8])) + ', ' + VisitDateLabel(Piece9Text); //kt //codex 8/18/26
end;

function ConsultIENTextFromID(const [Ref] DocID: string): string; //kt //codex 8/18/26
begin
  Result := SemicolonPiece(DocID, 1); //kt //codex 8/18/26
end;

function ConsultPackageFromID(const [Ref] DocID: string): string; //kt //codex 8/18/26
begin
  Result := SemicolonPiece(DocID, 2); //kt //codex 8/18/26
end;

function ConsultDisplayTextFromSpans(const [Ref] RawText: string; const Spans: TDocPieceSpanArray): string; //kt //codex 8/18/26
var
  DocID: string; //kt //codex 8/18/26
begin
  DocID := SpanText(RawText, Spans[1]); //kt //codex 8/18/26
  if SpanStartsWithAny(DocID, ['A', 'N', 'E']) then begin //kt //codex 8/18/26
    Result := SpanTextDef(RawText, Spans[2], '** No Title **'); //kt //codex 8/18/26
    Exit; //kt //codex 8/18/26
  end; //kt //codex 8/18/26
  Result := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(SpanText(RawText, Spans[3]))) + '  ' + //kt //codex 8/18/26
            SpanTextDef(RawText, Spans[2], '** No Title **') + ' (#' + ConsultIENTextFromID(DocID) + ')'; //kt //codex 8/18/26
  if not (Copy(ConsultPackageFromID(SpanText(RawText, Spans[10])), 1, 4) = 'MCAR') then //kt //codex 8/18/26
    Result := Result + ', ' + SpanTextDef(RawText, Spans[6], '** No Location **') + ', ' + NoteAuthorNameFromInfo(SpanText(RawText, Spans[5])); //kt //codex 8/18/26
end;

function MakeNodeDisplayTextFast(const [Ref] RawText: string; const Spans: TDocPieceSpanArray; TabIndex: Integer): string; //kt //codex 8/18/26
begin
  case TabIndex of //kt //codex 8/18/26
    CT_NOTES: Result := NoteDisplayTextFromSpans(RawText, Spans); //kt //codex 8/18/26
    CT_CONSULTS: Result := ConsultDisplayTextFromSpans(RawText, Spans); //kt //codex 8/18/26
    CT_DCSUMM: Result := DCSummDisplayTextFromSpans(RawText, Spans); //kt //codex 8/18/26
    else Result := SpanTextDef(RawText, Spans[2], '** No Title **'); //kt //codex 8/18/26
  end; //kt //codex 8/18/26
end;

procedure UpdateTreeLoadProgress(MaxValue, PositionValue: Integer; const LabelText: string = ''); //kt //codex 8/18/26
begin
  if frmNotes.frmNotesLoading = nil then Exit; //kt //codex 8/18/26
  if MaxValue > 0 then frmNotes.frmNotesLoading.ProgressBar1.Max := MaxValue; //kt //codex 8/18/26
  frmNotes.frmNotesLoading.ProgressBar1.Position := PositionValue; //kt //codex 8/18/26
  if LabelText <> '' then frmNotes.frmNotesLoading.Label2.Caption := LabelText; //kt //codex 8/18/26
  Application.ProcessMessages; //kt //codex 8/18/26
end;

procedure ParsePieceSpansMax(const [Ref] S: string; Delim: Char; MaxPiece: Integer; var Spans: TDocPieceSpanArray); forward; //kt //codex 8/18/26

destructor TDocTreeIndex.Destroy; //kt //codex 8/18/26
var
  i: Integer; //kt //codex 8/18/26
begin
  for i := 0 to Count - 1 do TObject(Objects[i]).Free; //kt //codex 8/18/26
  inherited Destroy; //kt //codex 8/18/26
end;

function GetChildIndexList(ParentIndex: TDocTreeIndex; const ParentID: string; CreateIfMissing: Boolean): TList; //kt //codex 8/18/26
var
  Idx: Integer; //kt //codex 8/18/26
begin
  Result := nil; //kt //codex 8/18/26
  Idx := ParentIndex.IndexOf(ParentID); //kt //codex 8/18/26
  if Idx < 0 then begin //kt //codex 8/18/26
    if not CreateIfMissing then Exit; //kt //codex 8/18/26
    Result := TList.Create; //kt //codex 8/18/26
    ParentIndex.AddObject(ParentID, Result); //kt //codex 8/18/26
    Exit; //kt //codex 8/18/26
  end; //kt //codex 8/18/26
  Result := TList(ParentIndex.Objects[Idx]); //kt //codex 8/18/26
end;

function DocTreeTabIndex(ANode: TTreeNode): Integer; //kt //codex 8/18/26
var
  TreeName: string; //kt //codex 8/18/26
begin
  Result := CT_NOTES; //kt //codex 8/18/26
  if (ANode = nil) or (ANode.TreeView = nil) then Exit; //kt //codex 8/18/26
  TreeName := UpperCase(ANode.TreeView.Name); //kt //codex 8/18/26
  if TreeName = 'TVCSLTNOTES' then Result := CT_CONSULTS //kt //codex 8/18/26
  else if TreeName = 'TVSUMMS' then Result := CT_DCSUMM; //kt //codex 8/18/26
end;

function MakeTreeObjectForNode(ANode: TTreeNode): PDocTreeObject; //kt //codex 8/18/26
var
  RawText: string; //kt //codex 8/18/26
begin
  Result := nil; //kt //codex 8/18/26
  if not (ANode is TORTreeNode) then Exit; //kt //codex 8/18/26
  RawText := TORTreeNode(ANode).StringData; //kt //codex 8/18/26
  if RawText = '' then Exit; //kt //codex 8/18/26
  case DocTreeTabIndex(ANode) of //kt //codex 8/18/26
    CT_NOTES: Result := MakeNoteTreeObject(RawText); //kt //codex 8/18/26
    CT_CONSULTS: Result := MakeConsultsNoteTreeObject(RawText); //kt //codex 8/18/26
    CT_DCSUMM: Result := MakeDCSummTreeObject(RawText); //kt //codex 8/18/26
  end; //kt //codex 8/18/26
end;

function DocTreeData(ANode: TTreeNode): PDocTreeObject; //kt //codex 8/18/26
begin
  Result := nil; //kt //codex 8/18/26
  if ANode = nil then Exit; //kt //codex 8/18/26
  if Assigned(ANode.Data) then begin Result := PDocTreeObject(ANode.Data); Exit; end; //kt //codex 8/18/26
  Result := MakeTreeObjectForNode(ANode); //kt //codex 8/18/26
  if Assigned(Result) then ANode.Data := Result; //kt //codex 8/18/26
end;

procedure BuildDocumentParentIndex(DocList: TStrings; ParentIndex: TDocTreeIndex); //kt //codex 8/18/26
var
  i: Integer; //kt //codex 8/18/26
  ParentID, RawText: string; //kt //codex 8/18/26
  Spans: TDocPieceSpanArray; //kt //codex 8/18/26
  ChildList: TList; //kt //codex 8/18/26
begin
  ParentIndex.Sorted := True; //kt //codex 8/18/26
  ParentIndex.Duplicates := dupError; //kt //codex 8/18/26
  ParentIndex.CaseSensitive := True; //kt //codex 8/18/26
  for i := 0 to DocList.Count - 1 do begin //kt //codex 8/18/26
    if (frmNotes.frmNotesLoading <> nil) and ((i and (TREE_PROGRESS_UPDATE_INTERVAL - 1)) = 0) then //kt //codex 8/18/26
      UpdateTreeLoadProgress(0, i); //kt //codex 8/18/26
    RawText := DocList[i]; //kt //codex 8/18/26
    ParsePieceSpansMax(RawText, U, MAX_TREE_SPAN_PIECE, Spans); //kt //codex 8/18/26
    ParentID := SpanText(RawText, Spans[14]); //kt //codex 8/18/26
    ChildList := GetChildIndexList(ParentIndex, ParentID, True); //kt //codex 8/18/26
    ChildList.Add(Pointer(i)); //kt //codex 8/18/26
  end; //kt //codex 8/18/26
end;

procedure BuildDocumentTreeIndexed(DocList: TStrings; ParentIndex: TDocTreeIndex; const Parent: string; Tree: TORTreeView; Node: TORTreeNode;
          TIUContext: TTIUContext; TabIndex: integer); forward; //kt //codex 8/18/26

procedure ParsePieceSpansMax(const [Ref] S: string; Delim: Char; MaxPiece: Integer; var Spans: TDocPieceSpanArray); //kt //codex 8/18/26
var
  PieceNum: Integer; //kt //codex 8/18/26
  StartPos, NextPos, TextLen: Integer; //kt //codex 8/18/26
begin
  for PieceNum := Low(Spans) to High(Spans) do //kt //codex 8/18/26
  begin
    Spans[PieceNum].StartPos := 0; //kt //codex 8/18/26
    Spans[PieceNum].Len := 0; //kt //codex 8/18/26
  end; //kt //codex 8/18/26
  if MaxPiece < 1 then Exit; //kt //codex 8/18/26
  TextLen := Length(S); //kt //codex 8/18/26
  StartPos := 1; //kt //codex 8/18/26
  for PieceNum := 1 to MaxPiece do //kt //codex 8/18/26
  begin
    if StartPos > TextLen + 1 then Exit; //kt //codex 8/18/26
    NextPos := StartPos; //kt //codex 8/18/26
    while (NextPos <= TextLen) and (S[NextPos] <> Delim) do Inc(NextPos); //kt //codex 8/18/26
    Spans[PieceNum].StartPos := StartPos; //kt //codex 8/18/26
    Spans[PieceNum].Len := NextPos - StartPos; //kt //codex 8/18/26
    StartPos := NextPos + 1; //kt //codex 8/18/26
  end; //kt //codex 8/18/26
end;

function SpanText(const [Ref] S: string; const Span: TPieceSpan): string; //kt //codex 8/18/26
begin
  if Span.StartPos <= 0 then Result := '' else Result := Copy(S, Span.StartPos, Span.Len); //kt //codex 8/18/26
end;

{==============================================================
RPC [TIU DOCUMENTS BY CONTEXT] returns
the following string '^' pieces:
===============================================================
      1 -  Document IEN
      2 -  Document Title
      3 -  FM date of document
      4 -  Patient Name
      5 -  DUZ;Author name
      6 -  Location
      7 -  Status
      8 -  ADM/VIS: date;FMDate
      9 -  Discharge Date;FMDate
      10 - Package variable pointer
      11 - Number of images
      12 - Subject
      13 - Has children
      14 - Parent document
      15 - Order children of ID Note by title rather than date
===============================================================}

function IsComponent(Title, Subject : string) : boolean;
//kt 5/15
begin
  //kt //codex original --> Result := (MidStr(Trim(Title),1,length(Subject)+2) = '['+Subject+']');
  Result := (Copy(Trim(Title),1,length(Subject)+2) = '['+Subject+']'); //kt //codex 8/3/26
end;

function IsComponent(Node : TORTreeNode) : boolean;
//kt added 5/15
var  AnObject: PDocTreeObject;
     Subject : string;
begin
  Result := false;
  if not assigned(Node) then exit;
  AnObject := DocTreeData(Node); if not assigned(AnObject) then exit; //kt //codex 8/18/26
  Subject := AnObject^.Subject;
  if (Subject = '') and (AnObject^.Status = 'new') then Subject := AnObject^.PkgRef;  //node position changes in different states...
  Result := IsComponent(AnObject^.DocTitle, Subject);
end;

function IsComponent(IEN : int64; TV : TORTreeview; StartingNode : TORTreeNode = nil) : boolean;
//kt added 5/15
var ANode : TORTreeNode;
begin
  ANode := TV.FindPieceNode(IntToStr(IEN), U, StartingNode);
  Result := IsComponent(ANode);
end;

procedure CreateListItemsForDocumentTree(Dest, Source: TStrings; Context: integer; GroupBy: string;
          Ascending: Boolean; TabIndex: integer);
const
  NO_MATCHES = '^No Matching Documents Found^^^^^^^^^^^%^0';
var
  i: Integer;
  x, x1, x2, x3, MyParent, MyTitle, MyLocation, MySubject: string;
  AList, SrcList: TStringList;
  Spans: TDocPieceSpanArray; //kt //codex 8/18/26
begin
  AList := TStringList.Create;
  SrcList := TStringList.Create;
  try
    FastAssign(Source, SrcList);
    with SrcList do begin  //kt reformatted block indents  :-)
      if (Count = 0) then begin
        Dest.Insert(0, IntToStr(Context) + NO_MATCHES);
        Exit;
      end;
      if Count>frmNotes.MinDocsForProgressBar then begin
        if frmNotes.frmNotesLoading=nil then begin
          frmNotes.frmNotesLoading := TfrmNotesLoading.create(frmNotes);
          frmNotes.frmNotesLoading.show;
          application.processmessages;
        end;
      end;
      for i := 0 to Count - 1 do begin
        if (frmNotes.frmNotesLoading <> nil) and ((i and (TREE_PROGRESS_UPDATE_INTERVAL - 1)) = 0) then
          UpdateTreeLoadProgress(SrcList.Count, i);
        x := Strings[i];
        ParsePieceSpansMax(x, U, MAX_TREE_SPAN_PIECE, Spans); //kt //codex 8/18/26
        MyParent   := SpanText(x, Spans[14]); //kt //codex 8/18/26
        MyTitle    := SpanText(x, Spans[2]); //kt //codex 8/18/26
        if Length(Trim(MyTitle)) = 0 then begin
          MyTitle := '** No Title **';
          SetPiece(x, U, 2, MyTitle);
        end;
        MyLocation := SpanText(x, Spans[6]); //kt //codex 8/18/26
        if Length(Trim(MyLocation)) = 0 then begin
          MyLocation := '** No Location **';
          SetPiece(x, U, 6, MyLocation);
        end;
        MySubject  := SpanText(x, Spans[12]); //kt //codex 8/18/26
        if IsComponent(MyTitle, MySubject) then Ascending := true; //kt 5/15 Force order of display of components in tree to match sequence order in note.
(*      case TIUContext.SearchField[1] of
          'T': if ((TextFound(MyTitle)) then continue;
          'S': if (not TextFound(MySubject)) then continue;
          'B': if not ((TextFound(MyTitle)) or (TextFound(MySubject))) then continue;
        end;*)
        if GroupBy <> '' then case GroupBy[1] of
          'D':  begin
                  x1 := VisitDateLabel(SpanText(x, Spans[8])); //kt //codex 8/18/26
                  x2 := VisitDateFMDate(SpanText(x, Spans[8])); //kt //codex 8/18/26
                  if x2 = '' then begin
                    x2 := 'No Visit';
                    x1 := Piece(x1, ':', 1) + ':  No Visit';
                  end;
                  (*else
                      x1 := Piece(x1, ':', 1) + ':  ' + FormatFMDateTimeStr('mmm dd,yy@hh:nn',x2)*) //removed v15.4
                  if MyParent = IntToStr(Context) then
                    SetPiece(x, U, 14, MyParent + x2 + Copy(x1, 1, 3));    // '2980324Adm'
                  x3 := x2 + Copy(x1, 1, 3) + U + MixedCase(x1) + U + IntToStr(Context) + MixedCase(Copy(x1, 1, 3));
                  if (Copy(MyTitle, 1, 8) <> 'Addendum') and (AList.IndexOf(x3) = -1) then
                    AList.Add(x3);   // '2980324Adm^Mar 24,98'
                  //TMG ADDITION  1/28/25
                  Dest.Add(x);
                  x1 := VisitDateLabel(SpanText(x, Spans[18])); //kt //codex 8/18/26
                  x2 := VisitDateFMDate(SpanText(x, Spans[18])); //kt //codex 8/18/26
                  if x2 = '' then begin
                    x2 := 'No Creation Date';
                    x1 := Piece(x1, ':', 1) + ':  No Creation Date';
                  end;
                  if MyParent = IntToStr(Context) then
                    SetPiece(x, U, 14, MyParent + x2 + Copy(x1, 1, 3));    // '2980324Adm'
                  x3 := x2 + Copy(x1, 1, 3) + U + MixedCase(x1) + U + IntToStr(Context) + MixedCase(Copy(x1, 1, 3));
                  if (Copy(MyTitle, 1, 8) <> 'Addendum') and (AList.IndexOf(x3) = -1) then
                    AList.Add(x3);   // '2980324Adm^Mar 24,98'
                  //END TMG ADDITION
                end;
          'L':  begin
                  if MyParent = IntToStr(Context) then                  // keep ID notes together, or
                    SetPiece(x, U, 14, MyParent + MyLocation);
(*                if (Copy(MyTitle, 1, 8) <> 'Addendum') then       // split ID Notes by location?
                    SetPiece(x, U, 14, IntToStr(Context) + MyLocation);*)
                  x3 := MyLocation + U + MixedCase(MyLocation) + U + IntToStr(Context);
                  if (Copy(MyTitle, 1, 8) <> 'Addendum') and (AList.IndexOf(x3) = -1) then
                    AList.Add(x3);
                end;
          'T':  begin
                  if MyParent = IntToStr(Context) then                  // keep ID notes together, or
                    SetPiece(x, U, 14, MyParent + MyTitle);
(*                if (Copy(MyTitle, 1, 8) <> 'Addendum') then       // split ID Notes by title?
                    SetPiece(x, U, 14, IntToStr(Context) + MyTitle);*)
                  x3 := MyTitle + U + MixedCase(MyTitle) + U + IntToStr(Context);
                  if (Copy(MyTitle, 1, 8) <> 'Addendum') and (AList.IndexOf(x3) = -1) then
                    AList.Add(x3);
                end;
          'A':  begin
                  x1 := NoteAuthorName(x); //kt //codex 8/18/26
                  if x1 = '' then x1 := '** No Author **';
                  if MyParent = IntToStr(Context) then                  // keep ID notes together, or
                    SetPiece(x, U, 14, MyParent + x1);
                  //if (Copy(MyTitle, 1, 8) <> 'Addendum') then         // split ID Notes by author?
                      //  SetPiece(x, U, 14, IntToStr(Context) + x1);
                  x3 := x1 + U + MixedCase(x1) + U + IntToStr(Context);
                  if (Copy(MyTitle, 1, 8) <> 'Addendum') and(AList.IndexOf(x3) = -1) then
                    AList.Add(x3);
                end;
(*        'A':  begin                                                 // Makes note appear both places in tree,
                  x1 := NoteAuthorName(x);                  // but also appears TWICE in lstNotes. //kt //codex 8/18/26
                  if x1 = '' then x1 := '** No Author **';              // IS THIS REALLY A PROBLEM??
                  if MyParent = IntToStr(Context) then                  // Impact on EditingIndex?
                    SetPiece(x, U, 14, MyParent + x1);                  // Careful when deleting note being edited!!!
                  Dest.Add(x);                                          // Need to find and delete ALL occurrences!
                  SetPiece(x, U, 14, IntToStr(Context) + x1);
                  x3 := x1 + U + MixedCase(x1) + U + IntToStr(Context);
                  if (AList.IndexOf(x3) = -1) then AList.Add(x3);
                end;*)
     {      'C':  begin
                             // TMG ADDING THIS PART   1/28/25
                  x1 := VisitDateLabel(Piece(x, U, 18)); //kt //codex 8/18/26
                  x2 := VisitDateFMDate(Piece(x, U, 18)); //kt //codex 8/18/26
                  if x2 = '' then begin
                    x2 := 'No Creation Date';
                    x1 := Piece(x1, ':', 1) + ':  No Creation Date';
                  end;
                  if MyParent = IntToStr(Context) then
                    SetPiece(x, U, 14, MyParent + x2 + Copy(x1, 1, 3));    // '2980324Adm'
                  x3 := x2 + Copy(x1, 1, 3) + U + MixedCase(x1) + U + IntToStr(Context) + MixedCase(Copy(x1, 1, 3));
                  if (Copy(MyTitle, 1, 8) <> 'Addendum') and (AList.IndexOf(x3) = -1) then
                    AList.Add(x3);   // '2980324Adm^Mar 24,98'
                  //END TMG ADDITION
                end;    }
        end; {case}
        Dest.Add(x);
      end; {for}
      SortByPiece(TStringList(Dest), U, 3);
      if not Ascending then InvertStringList(TStringList(Dest));
      if GroupBy <> '' then if GroupBy[1] ='D' then begin
        AList.Add('Adm^Inpatient Notes' + U + IntToStr(Context));
        AList.Add('Vis^Outpatient Notes' + U + IntToStr(Context));
        AList.Add('Cre^Outpatient Notes By Creation Date' + U + IntToStr(Context));  //1/25/25
      end;
      if (Context=9) or (Context=10) or (Context=11) then
        Dest.Insert(0, IntToStr(Context) + '^' + NC_TV_TEXT[TabIndex, Context]+' ('+inttostr(SrcList.Count)+')' + '^^^^^^^^^^^%^0')
      else
        Dest.Insert(0, IntToStr(Context) + '^' + NC_TV_TEXT[TabIndex, Context] + '^^^^^^^^^^^%^0');
      Alist.Sort;
      InvertStringList(AList);
      if GroupBy <> '' then if GroupBy[1] ='D' then
        if (not Ascending) then InvertStringList(AList);
      for i := 0 to AList.Count-1 do begin
        Dest.Insert(0, IntToStr(Context) + Piece(AList[i], U, 1) + '^' + Piece(AList[i], U, 2) + '^^^^^^^^^^^%^' + Piece(AList[i], U, 3));
        if (frmNotes.frmNotesLoading <> nil) and ((i and (TREE_PROGRESS_UPDATE_INTERVAL - 1)) = 0) then
          UpdateTreeLoadProgress(AList.Count, i);
      end;
    end; {with}
  finally
    AList.Free;
    SrcList.Free;
  end;
end;

procedure BuildDocumentTreeIndexed(DocList: TStrings; ParentIndex: TDocTreeIndex; const Parent: string; Tree: TORTreeView; Node: TORTreeNode;
          TIUContext: TTIUContext; TabIndex: integer);
var
  MyID, MyParent, Name, RawText: string;
  i, ChildIdx: Integer;
  ChildList: TList;
  ChildNode: TORTreeNode;
  DocHasChildren: Boolean;
  Spans: TDocPieceSpanArray; //kt //codex 8/18/26
begin
  ChildList := GetChildIndexList(ParentIndex, Parent, False); //kt //codex 8/18/26
  if ChildList = nil then Exit; //kt //codex 8/18/26
  for i := 0 to ChildList.Count - 1 do begin //kt //codex 8/18/26
    ChildIdx := NativeInt(ChildList[i]); //kt //codex 8/18/26
    RawText := DocList[ChildIdx]; //kt //codex 8/18/26
    ParsePieceSpansMax(RawText, U, MAX_TREE_SPAN_PIECE, Spans); //kt //codex 8/18/26
    MyParent := SpanText(RawText, Spans[14]); //kt //codex 8/18/26
    if (MyParent = Parent) then begin
      if (frmNotes.frmNotesLoading <> nil) and ((i and (TREE_PROGRESS_UPDATE_INTERVAL - 1)) = 0) then
        UpdateTreeLoadProgress(0, frmNotes.frmNotesLoading.ProgressBar1.Position + TREE_PROGRESS_UPDATE_INTERVAL, SpanTextDef(RawText, Spans[2], '** No Title **'));
      MyID := SpanText(RawText, Spans[1]); //kt //codex 8/18/26
      if SpanText(RawText, Spans[13]) <> '%' then //kt //codex 8/18/26
        Name := MakeNodeDisplayTextFast(RawText, Spans, TabIndex) //kt //codex 8/18/26
      else
        Name := SpanTextDef(RawText, Spans[2], '** No Title **'); //kt //codex 8/18/26
      DocHasChildren := SpanText(RawText, Spans[13]) <> ''; //kt //codex 8/18/26
      ChildNode := TORTreeNode(Tree.Items.AddChildObject(TORTreeNode(Node), Name, nil)); //kt //codex 8/18/26
      ChildNode.StringData := RawText;
      SetTreeNodeImagesAndFormatting(ChildNode, TIUContext, TabIndex);
      if DocHasChildren then begin
         BuildDocumentTreeIndexed(DocList, ParentIndex, MyID, Tree, ChildNode, TIUContext, TabIndex);
         if (frmNotes.frmNotesLoading <> nil) and ((i and (TREE_PROGRESS_UPDATE_INTERVAL - 1)) = 0) then
           UpdateTreeLoadProgress(0, frmNotes.frmNotesLoading.ProgressBar1.Position, SpanTextDef(RawText, Spans[2], '** No Title **'));
      end;
    end;
  end;
end;

procedure BuildDocumentTree(DocList: TStrings; const Parent: string; Tree: TORTreeView; Node: TORTreeNode;
          TIUContext: TTIUContext; TabIndex: integer);
var
  ParentIndex: TDocTreeIndex; //kt //codex 8/18/26
begin
  ParentIndex := TDocTreeIndex.Create; //kt //codex 8/18/26
  try
    BuildDocumentParentIndex(DocList, ParentIndex); //kt //codex 8/18/26
    BuildDocumentTreeIndexed(DocList, ParentIndex, Parent, Tree, Node, TIUContext, TabIndex); //kt //codex 8/18/26
  finally
    ParentIndex.Free; //kt //codex 8/18/26
  end; //kt //codex 8/18/26
end;

procedure SetTreeNodeImagesAndFormatting(Node: TORTreeNode; CurrentContext: TTIUContext; TabIndex: integer);
var
  tmpAuthor: int64;
  i: integer;
  RawText, DocID, DocTitle, DocHasChildren, DocParent, Status, AuthorInfo: string; //kt //codex 8/18/26
  ImageCount: Integer; //kt //codex 8/18/26
  Spans: TDocPieceSpanArray; //kt //codex 8/18/26

  procedure MakeBold(ANode: TORTreeNode);
  var
    LookingForAddenda: boolean;
  begin
    if not assigned(Node) then exit;
    LookingForAddenda := (Pos('ADDENDUM', UpperCase(CurrentContext.Keyword)) > 0);
    with ANode do begin
      Bold := True;
      if assigned(Parent) then begin
        if (ImageIndex <> IMG_ADDENDUM) or ((ImageIndex = IMG_ADDENDUM) and LookingForAddenda) then
          Parent.Expand(False);
        if assigned(Parent.Parent) then begin
          if (Parent.ImageIndex <> IMG_ADDENDUM) or ((Parent.ImageIndex = IMG_ADDENDUM) and LookingForAddenda) then
            Parent.Parent.Expand(False);
          if assigned(Parent.Parent.Parent) then begin
            if (Parent.Parent.ImageIndex <> IMG_ADDENDUM) or ((Parent.Parent.ImageIndex = IMG_ADDENDUM) and LookingForAddenda) then begin
              Parent.Parent.Parent.Expand(False);
            end;
          end;
        end;
      end;
    end;
  end;

begin
  RawText := Node.StringData; //kt //codex 8/18/26
  ParsePieceSpansMax(RawText, U, MAX_TREE_SPAN_PIECE, Spans); //kt //codex 8/18/26
  DocID := SpanText(RawText, Spans[1]); //kt //codex 8/18/26
  DocTitle := SpanTextDef(RawText, Spans[2], '** No Title **'); //kt //codex 8/18/26
  DocHasChildren := NormalizeDocHasChildren(SpanText(RawText, Spans[13])); //kt //codex 8/18/26
  DocParent := SpanText(RawText, Spans[14]); //kt //codex 8/18/26
  Status := SpanText(RawText, Spans[7]); //kt //codex 8/18/26
  AuthorInfo := SpanText(RawText, Spans[5]); //kt //codex 8/18/26
  ImageCount := StrToIntDef(SpanText(RawText, Spans[11]), 0); //kt //codex 8/18/26
  with Node do begin
    i := Pos('*', DocTitle);
    if i > 0 then i := i + 1 else i := 0;
    if (Copy(DocTitle, i + 1, 8) = 'Addendum') then
      ImageIndex := IMG_ADDENDUM
    else if (DocHasChildren = '') then
      ImageIndex := IMG_SINGLE
    else if Pos('+>', DocHasChildren) > 0 then
       ImageIndex := IMG_ID_CHILD_ADD
    else if (DocHasChildren = '>') then
      ImageIndex := IMG_ID_CHILD
    else if Pos('+<', DocHasChildren) > 0 then
      ImageIndex := IMG_IDPAR_ADDENDA_SHUT
    else if DocParent = '0' then begin
      ImageIndex    := IMG_TOP_LEVEL;
      SelectedIndex := IMG_TOP_LEVEL;
      StateIndex := -1;
      with CurrentContext, Node do begin
        if  Node.HasChildren and (GroupBy <> '') then case GroupBy[1] of
          'T': Text := NC_TV_TEXT[TabIndex, StrToInt(DocID)] + ' by title';
          'D': Text := NC_TV_TEXT[TabIndex, StrToInt(DocID)] + ' by visit date';
          'L': Text := NC_TV_TEXT[TabIndex, StrToInt(DocID)] + ' by location';
          'A': Text := NC_TV_TEXT[TabIndex, StrToInt(DocID)] + ' by author';
        end; {case}
        if TabIndex <> CT_CONSULTS then begin
          if (DocID = '2') or (DocID ='3') then begin
            if StrToIntDef(Status, 0) in [NC_UNSIGNED, NC_UNCOSIGNED] then begin
              tmpAuthor := StrToInt64Def(SemicolonPiece(AuthorInfo, 1), 0); //kt //codex 8/18/26
              if tmpAuthor = 0 then tmpAuthor := User.DUZ; //kt //codex 8/18/26
              Text := Text + ' for ' + ExternalName(tmpAuthor, 200);
            end else begin
              Text := Text + ' for ' + User.Name;
            end;
          end;
          if DocID = '4' then begin
            tmpAuthor := StrToInt64Def(SemicolonPiece(AuthorInfo, 1), 0); //kt //codex 8/18/26
            Text := Text + ' for ' + ExternalName(tmpAuthor, 200);
          end;
        end;
      end;
    end else begin
      case DocHasChildren[1] of
        '<': ImageIndex := IMG_IDNOTE_SHUT;
        '+': ImageIndex := IMG_PARENT;
        '%': begin
               StateIndex := -1;
               ImageIndex    := IMG_GROUP_SHUT;
               SelectedIndex := IMG_GROUP_OPEN;
             end;
      end; {case}
    end;
    SelectedIndex := ImageIndex;
    if (ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then
      StateIndex := IMG_NONE
    else begin
      if ImageCount > 0 then begin  //kt 9/11 note: Here is where image icon is turned on.
        //kt 9/11 --original line --> StateIndex := IMG_1_IMAGE
        if ImageCount = 2 then StateIndex := IMG_2_IMAGES  //kt 9/11 added
        else if ImageCount > 2 then StateIndex := IMG_MANY_IMAGES //kt 9/11 added
        else StateIndex := IMG_1_IMAGE;  //kt 9/11 added
      end else if ImageCount = 0 then
        StateIndex := IMG_NO_IMAGES
      else if ImageCount = -1 then
        StateIndex := IMG_IMAGES_HIDDEN;
    end;
    if (Parent <> nil) and
      (Parent.ImageIndex in [IMG_PARENT, IMG_IDNOTE_SHUT, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_SHUT, IMG_IDPAR_ADDENDA_OPEN]) and
      (StateIndex in [IMG_1_IMAGE, IMG_IMAGES_HIDDEN]) then begin
      Parent.StateIndex := IMG_CHILD_HAS_IMAGES;
    end;
(*  case ImageCount of
      0: StateIndex := IMG_NO_IMAGES;
      1: StateIndex := IMG_1_IMAGE;
      2: StateIndex := IMG_2_IMAGES;
      else
        StateIndex := IMG_MANY_IMAGES;
    end;*)
    if Node.Parent <> nil then begin
      if not CurrentContext.Filtered then begin
        //don't bother to BOLD every entry
      end else begin
        if (*ContextMatch(Node) then if (CurrentContext.KeyWord = '') or *)TextFound(Node, CurrentContext) then begin
          MakeBold(Node);
        end;
      end;
    end;
  end;
end;

procedure TraverseTree(ATree: TTreeView; AListView: TListView; ANode: TTreeNode; MyNodeID: string; AContext: TTIUContext);
var
  IncludeIt: Boolean;
  x: string;
begin
  if ANode = nil then Exit;
  IncludeIt := False;
  if (ContextMatch(TORTreeNode(ANode), MyNodeID, AContext) and TextFound(TORTreeNode(ANode), AContext)) then begin
    with DocTreeData(ANode)^ do begin //kt //codex 8/18/26
      if (AContext.GroupBy <> '') and
        (ATree.Selected.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then begin
        case AContext.GroupBy[1] of
          'T': if (UpperCase(DocTitle) = UpperCase(DocTreeData(ATree.Selected)^.DocTitle)) or
                 (UpperCase(DocTitle) = UpperCase('Addendum to ' + DocTreeData(ATree.Selected)^.DocTitle)) or
                 (AContext.Filtered and TextFound(TORTreeNode(ANode), AContext)) then
                 IncludeIt := True;
          'D': begin
                 x := DocTreeData(ATree.Selected)^.DocID; //kt //codex 8/18/26
                 if (Copy(x, 2, 3) = 'Vis') or (Copy(x, 2, 3) = 'Adm') then begin
                   if Copy(VisitDate, 1, 3) = Copy(x, 2, 3) then
                     IncludeIt := True;
                 end else if VisitDateFMDate(VisitDate) = Copy(x, 2, Length(x) - 4) then //kt //codex 8/18/26
                   IncludeIt := True;
               end;
          'L': if MyNodeID + Location = DocTreeData(ATree.Selected)^.DocID then
                 IncludeIt := True;
          'A': if MyNodeID + Piece(Author, ';', 2) = DocTreeData(ATree.Selected)^.DocID then
                 IncludeIt := True;
        end; {case}
      end else begin
        IncludeIt := True;
      end;
    end;
  end;
  if IncludeIt then AddListViewItem(ANode, AListView);
  if ANode.HasChildren then TraverseTree(ATree, AListView, ANode.GetFirstChild, MyNodeID, AContext);
  TraverseTree(ATree, AListView, ANode.GetNextSibling, MyNodeID, AContext);
end;

function ContextMatch(ANode: TORTreeNode; AParentID: string; AContext: TTIUContext): Boolean;
var
  Status: string;
  Author: int64;
  AuthorID: string; //kt //codex 8/18/26
begin
  Result := True;
  if not Assigned(DocTreeData(ANode)) then Exit; //kt //codex 8/18/26
  Status := DocTreeData(ANode)^.Status; //kt //codex 8/18/26

  if (AContext.Status <> AParentID[1]) or (AContext.Author = 0) then
    Author := User.DUZ
  else
    Author := AContext.Author;
  AuthorID := IntToStr(Author); //kt //codex 8/18/26

  if Length(Trim(Status)) = 0 then exit;
  (*if DocTreeData(ANode)^.DocHasChildren = '%' then Result := False else Result := True;
  Result := False;*)
  case AParentID[1] of
    '1':  Result := (Status = 'completed') or
                    (Status = 'deleted')   or
                    (Status = 'amended')   or
                    (Status = 'uncosigned') or
                    (Status = 'retracted');
    '2':  Result := ((Status = 'unsigned')   or
                    (Status = 'unreleased') or
                    (Status = 'deleted')   or
                    (Status = 'retracted') or
                    (Status = 'unverified')) and
                    PieceEquals(DocTreeData(ANode)^.Author, ';', 1, AuthorID); //kt //codex 8/18/26
    '3':  Result := ((Status = 'uncosigned') or
                    (Status = 'unsigned')   or
                    (Status = 'unreleased') or
                    (Status = 'deleted')   or
                    (Status = 'retracted') or
                    (Status = 'unverified')) ;//and
 { TODO -oRich V. -cSort/Search : Uncosigned notes - need to check cosigner, not author, but don't have it }
                    //(Piece(DocTreeData(ANode)^.Author, ';', 1) = IntToStr(Author));
    '4':  Result := PieceEquals(DocTreeData(ANode)^.Author, ';', 1, AuthorID); //kt //codex 8/18/26
    '5':  if DocTreeData(ANode)^.DocHasChildren = '%' then Result := False
          else Result := (StrToFloat(DocTreeData(ANode)^.DocFMDate) >= AContext.FMBeginDate) and
                         (Trunc(StrToFloat(DocTreeData(ANode)^.DocFMDate)) <= AContext.FMEndDate);
    'N':  Result := True;     // NEW NOTE
    'E':  Result := True;     // EDITING NOTE
    'A':  Result := True;     // NEW ADDENDUM or processing alert
  end;
end;

function TextFound(ANode: TORTreeNode; CurrentContext: TTIUContext): Boolean;
var
  MySearch: string;
begin
  Result := False;
  if not Assigned(DocTreeData(ANode)) then Exit; //kt //codex 8/18/26
  if CurrentContext.SearchField <> '' then
    case CurrentContext.SearchField[1] of
      'T': MySearch := DocTreeData(ANode)^.DocTitle;
      'S': MySearch := DocTreeData(ANode)^.Subject;
      'B': MySearch := DocTreeData(ANode)^.DocTitle + ' ' + DocTreeData(ANode)^.Subject;
    end;
  Result := (not CurrentContext.Filtered) or
            ((CurrentContext.Filtered) and (Pos(UpperCase(CurrentContext.KeyWord), UpperCase(MySearch)) > 0));
end;

procedure ResetDocTreeObjectStrings(AnObject: PDocTreeObject);
begin
  with AnObject^ do
    begin
      DocID          := '';
      DocDate        := '';
      DocTitle       := '';
      NodeText       := '';
      VisitDate      := '';
      DocFMDate      := '';
      DocHasChildren := '';
      DocParent      := '';
      Author         := '';
      PkgRef         := '';
      Location       := '';
      Status         := '';
      Subject        := '';
      OrderID        := '';
    end;
end;

procedure KillDocTreeObjects(TreeView: TORTreeView);
var
  i: integer;
begin
  with TreeView do begin
    for i := 0 to Items.Count-1 do begin
      if(Assigned(Items[i].Data)) then begin
        ResetDocTreeObjectStrings(PDocTreeObject(Items[i].Data));
        Dispose(PDocTreeObject(Items[i].Data));
        Items[i].Data := nil;
      end;
    end;
  end;
end;

procedure KillDocTreeNode(ANode: TTreeNode);
begin
  if(Assigned(ANode.Data)) then begin
    ResetDocTreeObjectStrings(PDocTreeObject(ANode.Data));
    Dispose(PDocTreeObject(ANode.Data));
    ANode.Data := nil;
  end;
  ANode.Owner.Delete(ANode);
end;

procedure KillDocTreeChildrenOfNode(ANode: TORTreeNode);
//kt //tmg added 6/7/26
var i : integer;
    ChildNode : TORTreeNode;
    MaxIdx : integer;
begin
  if not Assigned(ANode) then exit;
  if not ANode.HasChildren then exit;
  MaxIdx := ANode.Count-1;
  for i := MaxIdx downto 0 do begin
    ChildNode := TORTreeNode(ANode.Item[i]);
    KillDocTreeNodeAndChildren(ChildNode);
  end;
end;


procedure KillDocTreeNodeAndChildren(ANode: TORTreeNode);
//kt //tmg added 6/7/26
(* i : integer; *)
    (* ChildNode : TORTreeNode; *)
begin
  if not Assigned(ANode) then exit;
  if ANode.HasChildren then begin
    KillDocTreeChildrenOfNode(ANode);
  end;
  KillDocTreeNode(ANode);
end;

procedure RemoveParentsWithNoChildren(Tree: TTreeView; Context: TTIUContext);
var
  n: integer;
begin
  with Tree do begin
    for n := Items.Count - 1 downto 0 do begin
      if ((Items[n].ImageIndex = IMG_GROUP_SHUT)) then begin
        if (not Items[n].HasChildren) then
          KillDocTreeNode(Items[n])
        else if Context.Filtered then   // if any hits, would be IMG_GROUP_OPEN
          KillDocTreeNode(Items[n]);
      end;
    end;
  end;
end;

procedure AddListViewItem(ANode: TTreeNode; AListView: TListView);
var
  ListItem: TListItem;
begin
  if not Assigned(DocTreeData(ANode)) then Exit; //kt //codex 8/18/26
  with Anode, DocTreeData(ANode)^, AListView do begin //kt //codex 8/18/26
(*      if (FCurrentContext.Status = '1') and
           (Copy(DocTitle, 1 , 8) = 'Addendum') then Exit;*)
    if ANode.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT] then Exit;
    ListItem := Items.Add;
    ListItem.Caption := DocDate;                     // date
    ListItem.StateIndex := ANode.StateIndex;
    ListItem.ImageIndex := ANode.ImageIndex;
    with ListItem.SubItems do begin
      Add(DocTitle);                               //  title
      Add(Subject);                                //  subject
      Add(MixedCase(Piece(Author, ';', 2)));       //  author
      Add(Location);                               //  location
      Add(DocFMDate);                              //  reference date (FM)
      Add(DocID);                                  //  TIUDA
    end;
  end;
end;

function MakeNoteTreeObject(x: string): PDocTreeObject;
var
  AnObject: PDocTreeObject;
  Spans: TDocPieceSpanArray; //kt //codex 8/18/26
  AuthorInfo: string; //kt //codex 8/18/26
begin
  New(AnObject);
  ParsePieceSpansMax(x, U, MAX_TREE_SPAN_PIECE, Spans); //kt //codex 8/18/26
  AuthorInfo := SpanText(x, Spans[5]); //kt //codex 8/18/26
  with AnObject^ do
    begin
      DocID           := SpanText(x, Spans[1]); //kt //codex 8/18/26
      DocDate         := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(SpanText(x, Spans[3]))); //kt //codex 8/18/26
      DocTitle        := SpanTextDef(x, Spans[2], '** No Title **'); //kt //codex 8/18/26
      Location        := SpanTextDef(x, Spans[6], '** No Location **'); //kt //codex 8/18/26
      NodeText        := NoteDisplayTextFromSpans(x, Spans); //kt //codex 8/18/26
      ImageCount      := StrToIntDef(SpanText(x, Spans[11]), 0); //kt //codex 8/18/26
      VisitDate       := SpanText(x, Spans[8]); //kt //codex 8/18/26
      DocFMDate       := SpanText(x, Spans[3]); //kt //codex 8/18/26
      DocHasChildren  := NormalizeDocHasChildren(SpanText(x, Spans[13])); //kt //codex 8/18/26
      DocParent       := SpanText(x, Spans[14]); //kt //codex 8/18/26
      Author          := NoteAuthorDisplayFromInfo(AuthorInfo); //kt //codex 8/18/26
      PkgRef          := SpanText(x, Spans[10]); //kt //codex 8/18/26
      Status          := SpanText(x, Spans[7]); //kt //codex 8/18/26
      Subject         := SpanText(x, Spans[12]); //kt //codex 8/18/26
      OrderByTitle    := SpanText(x, Spans[15]) = '1'; //kt //codex 8/18/26
    end;
  Result := AnObject;
end;

function MakeDCSummTreeObject(x: string): PDocTreeObject;
var
  AnObject: PDocTreeObject;
  Spans: TDocPieceSpanArray; //kt //codex 8/18/26
  AuthorInfo: string; //kt //codex 8/18/26
begin
  New(AnObject);
  ParsePieceSpansMax(x, U, MAX_TREE_SPAN_PIECE, Spans); //kt //codex 8/18/26
  AuthorInfo := SpanText(x, Spans[5]); //kt //codex 8/18/26
  with AnObject^ do
    begin
      DocID            := SpanText(x, Spans[1]); //kt //codex 8/18/26
      DocDate          := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(SpanText(x, Spans[3]))); //kt //codex 8/18/26
      DocTitle         := SpanTextDef(x, Spans[2], '** No Title **'); //kt //codex 8/18/26
      Location         := SpanTextDef(x, Spans[6], '** No Location **'); //kt //codex 8/18/26
      NodeText         := DCSummDisplayTextFromSpans(x, Spans); //kt //codex 8/18/26
      DocFMDate        := SpanText(x, Spans[3]); //kt //codex 8/18/26
      ImageCount       := StrToIntDef(SpanText(x, Spans[11]), 0); //kt //codex 8/18/26
      DocHasChildren   := NormalizeDocHasChildren(SpanText(x, Spans[13])); //kt //codex 8/18/26
      DocParent        := SpanText(x, Spans[14]); //kt //codex 8/18/26
      Author           := NoteAuthorDisplayFromInfo(AuthorInfo); //kt //codex 8/18/26
      PkgRef           := SpanText(x, Spans[10]); //kt //codex 8/18/26
      Status           := SpanText(x, Spans[7]); //kt //codex 8/18/26
      Subject          := SpanText(x, Spans[12]); //kt //codex 8/18/26
      VisitDate        := SpanText(x, Spans[8]); //kt //codex 8/18/26
      OrderByTitle     := SpanText(x, Spans[15]) = '1'; //kt //codex 8/18/26
    end;
  Result := AnObject;
end;

function MakeConsultsNoteTreeObject(x: string): PDocTreeObject;
var
  AnObject: PDocTreeObject;
  Spans: TDocPieceSpanArray; //kt //codex 8/18/26
  DocIDText, PkgRefText: string; //kt //codex 8/18/26
begin
  New(AnObject);
  ParsePieceSpansMax(x, U, MAX_TREE_SPAN_PIECE, Spans); //kt //codex 8/18/26
  DocIDText := SpanText(x, Spans[1]); //kt //codex 8/18/26
  PkgRefText := SpanText(x, Spans[10]); //kt //codex 8/18/26
  with AnObject^ do
    begin
      DocID           := DocIDText; //kt //codex 8/18/26
      DocDate         := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(SpanText(x, Spans[3]))); //kt //codex 8/18/26
      DocTitle        := SpanTextDef(x, Spans[2], '** No Title **'); //kt //codex 8/18/26
      Location        := SpanTextDef(x, Spans[6], '** No Location **'); //kt //codex 8/18/26
      NodeText        := ConsultDisplayTextFromSpans(x, Spans); //kt //codex 8/18/26
      DocFMDate       := SpanText(x, Spans[3]); //kt //codex 8/18/26
      Status          := SpanText(x, Spans[7]); //kt //codex 8/18/26
      Author          := NoteAuthorDisplayFromInfo(SpanText(x, Spans[5])); //kt //codex 8/18/26
      PkgRef          := PkgRefText; //kt //codex 8/18/26
      if SemicolonPiece(PkgRefText, 2) = PKG_CONSULTS then //kt //codex 8/18/26
        OrderID       := GetConsultOrderIEN(StrToIntDef(SemicolonPiece(PkgRefText, 1), 0)); //kt //codex 8/18/26
      ImageCount      := StrToIntDef(SpanText(x, Spans[11]), 0); //kt //codex 8/18/26
      VisitDate       := SpanText(x, Spans[8]); //kt //codex 8/18/26
      DocHasChildren  := NormalizeDocHasChildren(SpanText(x, Spans[13])); //kt //codex 8/18/26
      DocParent       := SpanText(x, Spans[14]); //kt //codex 8/18/26
      OrderByTitle    := SpanText(x, Spans[15]) = '1'; //kt //codex 8/18/26
    end;
  Result := AnObject;
end;


end.
