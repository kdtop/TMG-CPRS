unit uHTMLNoteAnalysis;
//kt //codex added entire unit 10/20/26


(*
  Produces a non-mutating JSON map of a CPRS HTML note.  All offsets refer to
  the exact input string: they are zero-based UTF-16 code-unit offsets, and
  end offsets are exclusive.  This matches Delphi string indexing after adding
  one, and avoids offsets based on rendered DOM text.

  HPI topics are recognized in the two current local note formats:
    * <LI><U>Topic</U> ...       (Kevin)
    * <P>... * <U>Topic</U> ... (Dee)

  Tables are recognized everywhere in the note from their canonical
  -- [Table Name] --------- header.  A table range includes the header and its
  body; HeaderEndOffset is supplied for code that wants to replace only the
  body.

  AnalyzeHTMLNote(HTML) uses the current date.  Supply AsOfDate when editing a
  note whose clinical date differs from the current date.

  Representative result (offset values are examples only):

  {
    "offsetUnit": "zero-based UTF-16 code units; end offsets are exclusive",
    "sourceLength": 18420,
    "asOfDate": "2026-10-20",
    "hpi": {
      "found": true,
      "startOffset": 3820,
      "contentStartOffset": 3864,
      "endOffset": 11970
    },
    "topics": [
      {
        "name": "Hypertension",
        "bulletStyle": "html-li",
        "startOffset": 5150,
        "titleStartOffset": 5157,
        "titleEndOffset": 5169,
        "narrativeStartOffset": 5173,
        "textEndOffset": 6250,
        "endOffset": 7115,
        "insertionOffset": 6250,
        "asOfDateOffset": -1,
        "requiresAsOfDate": true,
        "asOfDateText": "10/20/26",
        "datePrefixWhenMissing": "10/20/26: ",
        "insertionRule": "Append after topic narrative and before its first table or next topic.",
        "htmlSuffixAfterInsertedText": "<BR>"
      }
    ],
    "tables": [
      {
        "name": "HYPERTENSION",
        "startOffset": 6250,
        "headerEndOffset": 6272,
        "bodyStartOffset": 6272,
        "bodyEndOffset": 7040,
        "endOffset": 7040,
        "inHPI": true,
        "topicName": "Hypertension"
      }
    ],
    "warnings": []
  }

  insertionOffset is where future code inserts HTML for a topic.  If
  requiresAsOfDate is true, datePrefixWhenMissing should precede the inserted
  text.  A table's body replacement range is [bodyStartOffset, bodyEndOffset).
*)

interface

uses
  System.SysUtils, System.JSON;

function AnalyzeHTMLNote(const AHTML: string): TJSONObject; overload;
function AnalyzeHTMLNote(const AHTML: string; const AsOfDate: TDateTime): TJSONObject; overload;

implementation

uses
  System.StrUtils;

type
  THTMLTableRange = record
    Name: string;
    StartOffset: Integer;
    HeaderEndOffset: Integer;
    EndOffset: Integer;
  end;

  THTMLTableRanges = array of THTMLTableRange;

  THTMLTopicRange = record
    Name: string;
    BulletStyle: string;
    StartOffset: Integer;
    TitleStartOffset: Integer;
    TitleEndOffset: Integer;
    NarrativeStartOffset: Integer;
    EndOffset: Integer;
    TextEndOffset: Integer;
    InsertionOffset: Integer;
    AsOfDateOffset: Integer;
  end;

  THTMLTopicRanges = array of THTMLTopicRange;

procedure AddInteger(AObject: TJSONObject; const AName: string; const AValue: Integer);
begin
  AObject.AddPair(AName, TJSONNumber.Create(IntToStr(AValue)));
end;

procedure AddBoolean(AObject: TJSONObject; const AName: string; const AValue: Boolean);
begin
  AObject.AddPair(AName, TJSONBool.Create(AValue));
end;

function IsTagDelimiter(const ACharacter: Char): Boolean;
begin
  Result := (ACharacter = '>') or (ACharacter = ' ') or
    (ACharacter = #9) or (ACharacter = #10) or (ACharacter = #13) or
    (ACharacter = '/');
end;

function FindTag(const AUpperHTML, ATag: string; const AStart, ALimit: Integer): Integer;

var
  Candidate: Integer;
  AfterTag: Integer;
  SearchText: string;
begin
  Result := 0;
  SearchText := '<' + ATag;
  Candidate := PosEx(SearchText, AUpperHTML, AStart);
  while (Candidate > 0) and (Candidate <= ALimit) do begin
    AfterTag := Candidate + Length(SearchText);
    if (AfterTag > Length(AUpperHTML)) or
       IsTagDelimiter(AUpperHTML[AfterTag]) then begin
      Result := Candidate;
      Exit;
    end;
    Candidate := PosEx(SearchText, AUpperHTML, Candidate + 1);
  end;
end;

function FindTagEnd(const AHTML: string; const ATagStart, ALimit: Integer): Integer;

begin
  Result := PosEx('>', AHTML, ATagStart);
  if (Result = 0) or (Result > ALimit) then begin
    Result := 0;
  end;
end;

function SkipVisualWhitespace(const AHTML, AUpperHTML: string; APosition, ALimit: Integer): Integer;

begin
  Result := APosition;
  while Result <= ALimit do begin
    if CharInSet(AHTML[Result], [' ', #9, #10, #13, #160]) then begin
      Inc(Result);
    end else if Copy(AUpperHTML, Result, 6) = '&NBSP;' then begin
      Inc(Result, 6);
    end else begin
      Exit;
    end;
  end;
end;

function FindBlankLine(const AHTML, AUpperHTML: string; const AStart, ALimit: Integer): Integer;
var
  FirstBreak: Integer;
  FirstBreakEnd: Integer;
  NextPosition: Integer;
  SecondBreak: Integer;
begin
  Result := 0;
  FirstBreak := FindTag(AUpperHTML, 'BR', AStart, ALimit);
  while FirstBreak > 0 do begin
    FirstBreakEnd := FindTagEnd(AHTML, FirstBreak, ALimit);
    if FirstBreakEnd = 0 then begin
      Exit;
    end;
    NextPosition := SkipVisualWhitespace(AHTML, AUpperHTML,
      FirstBreakEnd + 1, ALimit);
    SecondBreak := FindTag(AUpperHTML, 'BR', NextPosition, ALimit);
    if SecondBreak = NextPosition then begin
      Result := FirstBreak;
      Exit;
    end;
    FirstBreak := FindTag(AUpperHTML, 'BR', FirstBreakEnd + 1, ALimit);
  end;
end;

procedure ConsiderBoundary(const ACandidate: Integer; var ABest: Integer);
begin
  if (ACandidate > 0) and ((ABest = 0) or (ACandidate < ABest)) then begin
    ABest := ACandidate;
  end;
end;

function FindTableBoundary(const AHTML, AUpperHTML: string; const AStart, ALimit: Integer): Integer;
begin
  Result := 0;
  ConsiderBoundary(FindBlankLine(AHTML, AUpperHTML, AStart, ALimit), Result);
  ConsiderBoundary(FindTag(AUpperHTML, 'LI', AStart, ALimit), Result);
  ConsiderBoundary(FindTag(AUpperHTML, '/LI', AStart, ALimit), Result);
  ConsiderBoundary(FindTag(AUpperHTML, 'P', AStart, ALimit), Result);
  ConsiderBoundary(FindTag(AUpperHTML, '/P', AStart, ALimit), Result);
  ConsiderBoundary(FindTag(AUpperHTML, '/UL', AStart, ALimit), Result);
  ConsiderBoundary(FindTag(AUpperHTML, '/BODY', AStart, ALimit), Result);
end;

function DecodeBasicHTMLEntities(const AValue: string): string;
begin
  Result := StringReplace(AValue, '&nbsp;', ' ', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '&amp;', '&', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '&lt;', '<', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '&gt;', '>', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '&quot;', '"', [rfReplaceAll, rfIgnoreCase]);
end;

function TextBetweenTags(const AHTML: string; const AStart, AEnd: Integer): string;
var
  Position: Integer;
  TagEnd: Integer;
begin
  Result := '';
  Position := AStart;
  while Position <= AEnd do begin
    if AHTML[Position] = '<' then begin
      TagEnd := PosEx('>', AHTML, Position);
      if (TagEnd = 0) or (TagEnd > AEnd) then begin
        Break;
      end;
      Position := TagEnd + 1;
    end else begin
      Result := Result + AHTML[Position];
      Inc(Position);
    end;
  end;
  Result := DecodeBasicHTMLEntities(Result);
end;

procedure AddTableRange(var ATables: THTMLTableRanges;
  const AName: string; const AStartOffset, AHeaderEndOffset: Integer);

var
  Index: Integer;
begin
  Index := Length(ATables);
  SetLength(ATables, Index + 1);
  ATables[Index].Name := AName;
  ATables[Index].StartOffset := AStartOffset;
  ATables[Index].HeaderEndOffset := AHeaderEndOffset;
  ATables[Index].EndOffset := AHeaderEndOffset;
end;

procedure FindTables(const AHTML, AUpperHTML: string;
  out ATables: THTMLTableRanges);

var
  SearchPosition: Integer;
  HeaderStart: Integer;
  CloseBracket: Integer;
  Cursor: Integer;
  DashCount: Integer;
  Index: Integer;
  Limit: Integer;
  Boundary: Integer;
begin
  SetLength(ATables, 0);
  SearchPosition := 1;
  while SearchPosition <= Length(AHTML) do begin
    HeaderStart := PosEx('-- [', AUpperHTML, SearchPosition);
    if HeaderStart = 0 then begin
      Break;
    end;
    CloseBracket := PosEx(']', AHTML, HeaderStart + 4);
    if CloseBracket = 0 then begin
      Break;
    end;
    Cursor := CloseBracket + 1;
    while (Cursor <= Length(AHTML)) and
          CharInSet(AHTML[Cursor], [' ', #9, #10, #13]) do begin
      Inc(Cursor);
    end;
    DashCount := 0;
    while (Cursor <= Length(AHTML)) and (AHTML[Cursor] = '-') do begin
      Inc(DashCount);
      Inc(Cursor);
    end;
    if DashCount >= 5 then begin
      AddTableRange(ATables,
        DecodeBasicHTMLEntities(Copy(AHTML, HeaderStart + 4,
          CloseBracket - HeaderStart - 4)), HeaderStart - 1, Cursor - 1);
      SearchPosition := Cursor;
    end else begin
      SearchPosition := HeaderStart + 4;
    end;
  end;

  for Index := Low(ATables) to High(ATables) do begin
    Limit := Length(AHTML);
    if Index < High(ATables) then begin
      Limit := ATables[Index + 1].StartOffset;
    end;
    Boundary := FindTableBoundary(AHTML, AUpperHTML,
      ATables[Index].HeaderEndOffset + 1, Limit);
    if Boundary = 0 then begin
      ATables[Index].EndOffset := Limit;
    end else begin
      ATables[Index].EndOffset := Boundary - 1;
    end;
  end;
end;

function IsAsteriskBullet(const AHTML, AUpperHTML: string;
  const AStart, AEnd: Integer): Boolean;

var
  VisibleText: string;
begin
  VisibleText := Trim(TextBetweenTags(AHTML, AStart, AEnd));
  Result := VisibleText = '*';
end;

function TryFindTopicTitle(const AHTML, AUpperHTML: string;
  const ATagStart, ATagEnd, ALimit: Integer; const ARequireAsterisk: Boolean;
  out ATitle: string; out ATitleStart, ATitleEnd, ANarrativeStart: Integer): Boolean;

var
  UStart: Integer;
  UStartEnd: Integer;
  UEnd: Integer;
  UEndEnd: Integer;
begin
  Result := False;
  ATitle := '';
  ATitleStart := 0;
  ATitleEnd := 0;
  ANarrativeStart := 0;
  UStart := FindTag(AUpperHTML, 'U', ATagEnd + 1, ALimit);
  if UStart = 0 then begin
    Exit;
  end;
  if ARequireAsterisk and not IsAsteriskBullet(AHTML, AUpperHTML,
    ATagEnd + 1, UStart - 1) then begin
    Exit;
  end;
  UStartEnd := FindTagEnd(AHTML, UStart, ALimit);
  UEnd := FindTag(AUpperHTML, '/U', UStartEnd + 1, ALimit);
  if UEnd = 0 then begin
    Exit;
  end;
  UEndEnd := FindTagEnd(AHTML, UEnd, ALimit);
  if (UStartEnd = 0) or (UEndEnd = 0) then begin
    Exit;
  end;
  ATitle := Trim(StringReplace(DecodeBasicHTMLEntities(Copy(AHTML,
    UStartEnd + 1, UEnd - UStartEnd - 1)), #160, ' ', [rfReplaceAll]));
  if ATitle = '' then begin
    Exit;
  end;
  ATitleStart := UStartEnd;
  ATitleEnd := UEnd - 1;
  ANarrativeStart := UEndEnd;
  Result := True;
end;

procedure AddTopicRange(var ATopics: THTMLTopicRanges; const AName,
  ABulletStyle: string; const AStartOffset, ATitleStartOffset,
  ATitleEndOffset, ANarrativeStartOffset: Integer);
var
  Index: Integer;
begin
  Index := Length(ATopics);
  SetLength(ATopics, Index + 1);
  ATopics[Index].Name := AName;
  ATopics[Index].BulletStyle := ABulletStyle;
  ATopics[Index].StartOffset := AStartOffset;
  ATopics[Index].TitleStartOffset := ATitleStartOffset;
  ATopics[Index].TitleEndOffset := ATitleEndOffset;
  ATopics[Index].NarrativeStartOffset := ANarrativeStartOffset;
  ATopics[Index].EndOffset := ANarrativeStartOffset;
  ATopics[Index].TextEndOffset := ANarrativeStartOffset;
  ATopics[Index].InsertionOffset := ANarrativeStartOffset;
  ATopics[Index].AsOfDateOffset := -1;
end;

procedure FindTopics(const AHTML, AUpperHTML: string; const AHPIContentStart, AHPIEnd: Integer; out ATopics: THTMLTopicRanges);
var
  SearchPosition: Integer;
  LIStart: Integer;
  PStart: Integer;
  TagStart: Integer;
  TagEnd: Integer;
  TitleStart: Integer;
  TitleEnd: Integer;
  NarrativeStart: Integer;
  Title: string;
  IsParagraph: Boolean;
  NextLI: Integer;
  NextP: Integer;
  TitleLimit: Integer;
  Index: Integer;
begin
  SetLength(ATopics, 0);
  SearchPosition := AHPIContentStart + 1;
  while SearchPosition <= AHPIEnd do begin
    LIStart := FindTag(AUpperHTML, 'LI', SearchPosition, AHPIEnd);
    PStart := FindTag(AUpperHTML, 'P', SearchPosition, AHPIEnd);
    if (LIStart = 0) and (PStart = 0) then begin
      Break;
    end;
    IsParagraph := (PStart > 0) and ((LIStart = 0) or (PStart < LIStart));
    if IsParagraph then begin
      TagStart := PStart;
    end else begin
      TagStart := LIStart;
    end;
    TagEnd := FindTagEnd(AHTML, TagStart, AHPIEnd);
    if TagEnd = 0 then begin
      Break;
    end;
    NextLI := FindTag(AUpperHTML, 'LI', TagEnd + 1, AHPIEnd);
    NextP := FindTag(AUpperHTML, 'P', TagEnd + 1, AHPIEnd);
    TitleLimit := AHPIEnd;
    if NextLI > 0 then begin
      TitleLimit := NextLI - 1;
    end;
    if (NextP > 0) and (NextP - 1 < TitleLimit) then begin
      TitleLimit := NextP - 1;
    end;
    if TryFindTopicTitle(AHTML, AUpperHTML, TagStart, TagEnd, TitleLimit,
      IsParagraph, Title, TitleStart, TitleEnd, NarrativeStart) then begin
      if IsParagraph then begin
        AddTopicRange(ATopics, Title, 'asterisk-paragraph', TagStart - 1,
          TitleStart, TitleEnd, NarrativeStart);
      end else begin
        AddTopicRange(ATopics, Title, 'html-li', TagStart - 1,
          TitleStart, TitleEnd, NarrativeStart);
      end;
    end;
    SearchPosition := TagEnd + 1;
  end;

  for Index := Low(ATopics) to High(ATopics) do begin
    if Index < High(ATopics) then begin
      ATopics[Index].EndOffset := ATopics[Index + 1].StartOffset;
    end else begin
      ATopics[Index].EndOffset := AHPIEnd;
    end;
  end;
end;

function FindAsOfDate(const AHTML, AUpperHTML: string; const AStartOffset,
  AEndOffset: Integer; const AsOfDate: TDateTime): Integer;

var
  Variants: array[0..3] of string;
  Index: Integer;
  Candidate: Integer;
  Best: Integer;
  AfterDate: Integer;
begin
  Variants[0] := FormatDateTime('m/d/yy', AsOfDate);
  Variants[1] := FormatDateTime('mm/dd/yy', AsOfDate);
  Variants[2] := FormatDateTime('m/d/yyyy', AsOfDate);
  Variants[3] := FormatDateTime('mm/dd/yyyy', AsOfDate);
  Best := 0;
  for Index := Low(Variants) to High(Variants) do begin
    Candidate := PosEx(UpperCase(Variants[Index]), AUpperHTML,
      AStartOffset + 1);
    while (Candidate > 0) and (Candidate <= AEndOffset) do begin
      AfterDate := Candidate + Length(Variants[Index]);
      if (AfterDate <= Length(AHTML)) and (AfterDate <= AEndOffset + 1) and
         (AHTML[AfterDate] = ':') then begin
        if (Best = 0) or (Candidate > Best) then begin
          Best := Candidate;
        end;
        Break;
      end;
      Candidate := PosEx(UpperCase(Variants[Index]), AUpperHTML,
        Candidate + 1);
    end;
  end;
  if Best = 0 then begin
    Result := -1;
  end else begin
    Result := Best - 1;
  end;
end;

function FindVisibleAsOfDate(const AHTML: string; const AStartOffset,
  AEndOffset: Integer; const AsOfDate: TDateTime): Integer;
//kt //codex added entire function 11/1/26
var
  VisibleText: string;
  SourceOffsets: array of Integer;
  Position: Integer;
  TagEnd: Integer;
  EntityEnd: Integer;
  Candidate: Integer;
  AfterDate: Integer;
  VariantIndex: Integer;
  VisibleLength: Integer;
  Variants: array[0..7] of string;
  Token: string;
  Value: Char;
begin
  Result := -1;
  SetLength(VisibleText, Length(AHTML));
  SetLength(SourceOffsets, Length(AHTML));
  VisibleLength := 0;
  Position := AStartOffset + 1;
  while (Position <= AEndOffset) and (Position <= Length(AHTML)) do begin
    if AHTML[Position] = '<' then begin
      TagEnd := PosEx('>', AHTML, Position + 1);
      if (TagEnd = 0) or (TagEnd > AEndOffset) then begin
        Break;
      end;
      Position := TagEnd + 1;
      Continue;
    end;
    Value := AHTML[Position];
    if Value = '&' then begin
      EntityEnd := PosEx(';', AHTML, Position + 1);
      if (EntityEnd > 0) and (EntityEnd <= AEndOffset) and
         (EntityEnd - Position <= 10) then begin
        Token := Copy(AHTML, Position, EntityEnd - Position + 1);
        if SameText(Token, '&nbsp;') or SameText(Token, '&#160;') or
           SameText(Token, '&#xA0;') then begin
          Value := ' ';
        end else begin
          Value := #1;
        end;
        Inc(VisibleLength);
        SourceOffsets[VisibleLength - 1] := Position - 1;
        VisibleText[VisibleLength] := Value;
        Position := EntityEnd + 1;
        Continue;
      end;
    end;
    Inc(VisibleLength);
    SourceOffsets[VisibleLength - 1] := Position - 1;
    VisibleText[VisibleLength] := Value;
    Inc(Position);
  end;
  SetLength(VisibleText, VisibleLength);
  Variants[0] := FormatDateTime('m/d/yy', AsOfDate);
  Variants[1] := FormatDateTime('mm/d/yy', AsOfDate);
  Variants[2] := FormatDateTime('m/dd/yy', AsOfDate);
  Variants[3] := FormatDateTime('mm/dd/yy', AsOfDate);
  Variants[4] := FormatDateTime('m/d/yyyy', AsOfDate);
  Variants[5] := FormatDateTime('mm/d/yyyy', AsOfDate);
  Variants[6] := FormatDateTime('m/dd/yyyy', AsOfDate);
  Variants[7] := FormatDateTime('mm/dd/yyyy', AsOfDate);
  for VariantIndex := Low(Variants) to High(Variants) do begin
    Candidate := PosEx(Variants[VariantIndex], VisibleText, 1);
    while Candidate > 0 do begin
      AfterDate := Candidate + Length(Variants[VariantIndex]);
      if ((Candidate = 1) or not CharInSet(VisibleText[Candidate - 1], ['0'..'9', '/'])) and
         (AfterDate <= Length(VisibleText)) and (VisibleText[AfterDate] = ':') then begin
        Result := SourceOffsets[Candidate - 1];
        Exit;
      end;
      Candidate := PosEx(Variants[VariantIndex], VisibleText, Candidate + 1);
    end;
  end;
end;

procedure CompleteTopicRanges(const AHTML, AUpperHTML: string; const AsOfDate: TDateTime; const ATables: THTMLTableRanges; var ATopics: THTMLTopicRanges);
var
  TopicIndex: Integer;
  TableIndex: Integer;
begin
  for TopicIndex := Low(ATopics) to High(ATopics) do begin
    ATopics[TopicIndex].TextEndOffset := ATopics[TopicIndex].EndOffset;
    for TableIndex := Low(ATables) to High(ATables) do begin
      if (ATables[TableIndex].StartOffset >=
          ATopics[TopicIndex].NarrativeStartOffset) and
         (ATables[TableIndex].StartOffset < ATopics[TopicIndex].EndOffset) then begin
        ATopics[TopicIndex].TextEndOffset := ATables[TableIndex].StartOffset;
        Break;
      end;
    end;
    ATopics[TopicIndex].InsertionOffset :=
      ATopics[TopicIndex].TextEndOffset;
    //kt //codex original --> ATopics[TopicIndex].AsOfDateOffset := FindAsOfDate(AHTML, AUpperHTML,
    ATopics[TopicIndex].AsOfDateOffset := FindVisibleAsOfDate(AHTML, //kt //codex 11/1/26
      ATopics[TopicIndex].NarrativeStartOffset,
      ATopics[TopicIndex].TextEndOffset, AsOfDate);
  end;
end;

function IsOffsetInHPI(const AOffset, AHPIContentStart, AHPIEnd: Integer): Boolean;
begin
  Result := (AHPIContentStart >= 0) and (AOffset >= AHPIContentStart) and
    (AOffset < AHPIEnd);
end;

function TopicNameForOffset(const AOffset: Integer;
  const ATopics: THTMLTopicRanges): string;

var
  Index: Integer;
begin
  Result := '';
  for Index := Low(ATopics) to High(ATopics) do begin
    if (AOffset >= ATopics[Index].StartOffset) and
       (AOffset < ATopics[Index].EndOffset) then begin
      Result := ATopics[Index].Name;
      Exit;
    end;
  end;
end;

procedure AddTopicJSON(AArray: TJSONArray; const ATopic: THTMLTopicRange;
  const AsOfDate: TDateTime);

var
  Item: TJSONObject;
begin
  Item := TJSONObject.Create;
  Item.AddPair('name', ATopic.Name);
  Item.AddPair('bulletStyle', ATopic.BulletStyle);
  AddInteger(Item, 'startOffset', ATopic.StartOffset);
  AddInteger(Item, 'titleStartOffset', ATopic.TitleStartOffset);
  AddInteger(Item, 'titleEndOffset', ATopic.TitleEndOffset);
  AddInteger(Item, 'narrativeStartOffset', ATopic.NarrativeStartOffset);
  AddInteger(Item, 'textEndOffset', ATopic.TextEndOffset);
  AddInteger(Item, 'endOffset', ATopic.EndOffset);
  AddInteger(Item, 'insertionOffset', ATopic.InsertionOffset);
  AddInteger(Item, 'asOfDateOffset', ATopic.AsOfDateOffset);
  AddBoolean(Item, 'requiresAsOfDate', ATopic.AsOfDateOffset < 0);
  Item.AddPair('asOfDateText', FormatDateTime('m/d/yy', AsOfDate));
  if ATopic.AsOfDateOffset < 0 then begin
    Item.AddPair('datePrefixWhenMissing',
      FormatDateTime('m/d/yy', AsOfDate) + ': '); //kt //codex 10/20/26
  end else begin
    Item.AddPair('datePrefixWhenMissing', ''); //kt //codex 10/20/26
  end;
  Item.AddPair('insertionRule',
    'Append after topic narrative and before its first table or next topic.'); //kt //codex 10/20/26
  Item.AddPair('htmlSuffixAfterInsertedText', '<BR>');
  AArray.AddElement(Item);
end;

procedure AddTableJSON(AArray: TJSONArray; const ATable: THTMLTableRange;
  const AHPIContentStart, AHPIEnd: Integer; const ATopics: THTMLTopicRanges);

var
  Item: TJSONObject;
begin
  Item := TJSONObject.Create;
  Item.AddPair('name', ATable.Name);
  AddInteger(Item, 'startOffset', ATable.StartOffset);
  AddInteger(Item, 'headerEndOffset', ATable.HeaderEndOffset);
  AddInteger(Item, 'bodyStartOffset', ATable.HeaderEndOffset);
  AddInteger(Item, 'bodyEndOffset', ATable.EndOffset);
  AddInteger(Item, 'endOffset', ATable.EndOffset);
  AddBoolean(Item, 'inHPI', IsOffsetInHPI(ATable.StartOffset,
    AHPIContentStart, AHPIEnd));
  Item.AddPair('topicName', TopicNameForOffset(ATable.StartOffset, ATopics));
  AArray.AddElement(Item);
end;

function AnalyzeHTMLNote(const AHTML: string): TJSONObject;

begin
  Result := AnalyzeHTMLNote(AHTML, Date);
end;

function AnalyzeHTMLNote(const AHTML: string;
  const AsOfDate: TDateTime): TJSONObject;

const
  HPI_MARKER = 'HISTORY OF PRESENT ILLNESS (HPI):';
  PMH_MARKER = 'PAST MEDICAL HISTORY (PMH)';
var
  UpperHTML: string;
  HPIStart: Integer;
  HPIContentStart: Integer;
  HPIEnd: Integer;
  MarkerTagEnd: Integer;
  Tables: THTMLTableRanges;
  Topics: THTMLTopicRanges;
  TopicsJSON: TJSONArray;
  TablesJSON: TJSONArray;
  WarningsJSON: TJSONArray;
  HPIJSON: TJSONObject;
  Index: Integer;
begin
  Result := TJSONObject.Create;
  try
    UpperHTML := UpperCase(AHTML);
    FindTables(AHTML, UpperHTML, Tables);
    HPIStart := Pos(HPI_MARKER, UpperHTML);
    HPIContentStart := -1;
    HPIEnd := -1;
    SetLength(Topics, 0);
    if HPIStart > 0 then begin
      MarkerTagEnd := PosEx('>', AHTML, HPIStart + Length(HPI_MARKER) - 1);
      if MarkerTagEnd = 0 then begin
        HPIContentStart := HPIStart + Length(HPI_MARKER) - 1;
      end else begin
        HPIContentStart := MarkerTagEnd;
      end;
      HPIEnd := PosEx(PMH_MARKER, UpperHTML, HPIContentStart + 1);
      if HPIEnd = 0 then begin
        HPIEnd := Length(AHTML) + 1;
      end;
      Dec(HPIEnd);
      FindTopics(AHTML, UpperHTML, HPIContentStart, HPIEnd, Topics);
      CompleteTopicRanges(AHTML, UpperHTML, AsOfDate, Tables, Topics);
    end;

    Result.AddPair('offsetUnit', 'zero-based UTF-16 code units; end offsets are exclusive');
    AddInteger(Result, 'sourceLength', Length(AHTML));
    Result.AddPair('asOfDate', FormatDateTime('yyyy-mm-dd', AsOfDate));

    HPIJSON := TJSONObject.Create;
    AddBoolean(HPIJSON, 'found', HPIStart > 0);
    AddInteger(HPIJSON, 'startOffset', HPIStart - 1);
    AddInteger(HPIJSON, 'contentStartOffset', HPIContentStart);
    AddInteger(HPIJSON, 'endOffset', HPIEnd);
    Result.AddPair('hpi', HPIJSON);

    TopicsJSON := TJSONArray.Create;
    for Index := Low(Topics) to High(Topics) do begin
      AddTopicJSON(TopicsJSON, Topics[Index], AsOfDate);
    end;
    Result.AddPair('topics', TopicsJSON);

    TablesJSON := TJSONArray.Create;
    for Index := Low(Tables) to High(Tables) do begin
      AddTableJSON(TablesJSON, Tables[Index], HPIContentStart, HPIEnd, Topics);
    end;
    Result.AddPair('tables', TablesJSON);

    WarningsJSON := TJSONArray.Create;
    if HPIStart = 0 then begin
      WarningsJSON.AddElement(TJSONString.Create('HPI start marker was not found.'));
    end else if PosEx(PMH_MARKER, UpperHTML, HPIContentStart + 1) = 0 then begin
      WarningsJSON.AddElement(TJSONString.Create('PMH start marker was not found; HPI extends to the end of the source.'));
    end;
    Result.AddPair('warnings', WarningsJSON);
  except
    Result.Free;
    raise;
  end;
end;

end.
