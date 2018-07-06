unit uParseBlocks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  StrUtils, uEvaluateExpr,
  Controls, Forms, Dialogs, StdCtrls;


(* ------- Syntax notes:  Examples -----------------------------

$if <test> $begin
  <text to use if true>
$end

$if <test> $begin
  <text to use if true>
$end $else $begin
  <text to use if false>
$end

$if <test> $begin
  <text to use if true>
$end $else $if <test#2> $begin
  <text to use if test#2 true>
$end

$if <test> $begin
  <text to use if true>
$end $else $if <test#2> $begin
  <text to use if test#2 true>
  $if <test#3> $begin
     <text if test #3 true>
  $end
$end

---------------------------------------------------------------- *)

procedure ParseIfBlocks(var Str : string);


implementation

const
  IF_TAG            = '$IF';
  BEGIN_TAG         = '$BEGIN';
  END_TAG           = '$END';
  ELSE_TAG          = '$ELSE';

  BOOL_TAGS         : ARRAY[0..3] of string = (IF_TAG, BEGIN_TAG, END_TAG, ELSE_TAG);

function TMGReplaceText(const Str : string; StartP, EndP : integer; NewFrag : string) : string;
var StrA, StrB : string;
begin
  StrA := LeftStr(Str, StartP-1);
  StrB := MidStr(Str, EndP + 1, Length(Str));
  Result := StrA + NewFrag + StrB;
end;

function TMGTrim(const Str : string) : string;
begin
  Result := Trim(Str);
  Result := StringReplace(Result, #$0D, '', [rfReplaceAll]);
  Result := StringReplace(Result, #$0A, '', [rfReplaceAll]);
end;

function NextBlockOrBoolTag(const Str : string; const StartPos : integer; var FoundStartPos, AfterTokenStart : integer; var InterimStr : string) : string;
var MAX : integer;
    p, i : integer;
    UCStr : string;
begin
  Result := '';
  InterimStr := '';
  MAX := Length(Str) + 1;
  FoundStartPos := MAX;
  AfterTokenStart := 0;
  UCStr := UpperCase(Str);
  for i := Low(BOOL_TAGS) to High(BOOL_TAGS) do begin
    p := PosEx(BOOL_TAGS[i], UCStr, StartPos);
    if p = 0 then continue;
    if not (p < FoundStartPos) then continue;
    FoundStartPos := p;
    Result := BOOL_TAGS[i];
  end;
  if FoundStartPos <> MAX then begin
    InterimStr := MidStr(Str, StartPos, FoundStartPos - StartPos);
    AfterTokenStart := FoundStartPos + Length(Result);
  end else begin
    FoundStartPos := 0;
  end;
end;

function NextMatchedEndTag(const Str : string; const StartPos : integer; var AfterTokenStart : integer; var InterimStr, ErrMsg : string) : integer;
//This function is to be called with StartPos occuring right AFTER a BEGIN_TAG.
//Result will be index for the matching END_TAG, skipping over any contained sub BEGIN / END blocks.
var BeginCount, EndCount : integer;
    NextToken : string;
    P0,P1, P2 : integer;
begin
  BeginCount := 1;
  EndCount := 0;
  P0 := StartPos; P1 := P0; AfterTokenStart := 0;
  Result := 0;
  InterimStr := '';
  while (EndCount < BeginCount) and (P1 <> 0) do begin
    repeat
      NextToken := NextBlockOrBoolTag(Str, P0, P1, P2, InterimStr);
      if P1=0 then begin
        ErrMsg := 'No matching ['+END_TAG+'] found after ['+BEGIN_TAG+']';
        break;
      end;
      P0 := P2;
      if (NextToken = END_TAG) or (NextToken = BEGIN_TAG) then break;
    until P1 = 0;
    if NextToken = BEGIN_TAG then inc(BeginCount);
    if NextToken = END_TAG   then inc(EndCount);
  end;
  if P1 > 0 then begin
    Result := P1;
    AfterTokenStart := P1 + Length(NextToken);
    InterimStr := MidStr(Str, StartPos, P1-StartPos);
  end;
end;

function EvaluateTest(Test : string; var ErrMsg : string) : boolean;
begin
  ErrMsg := '';
  Test := TMGTrim(Test);
  Test := EvalExpression (Test, ErrMsg);

  Result := (Test = '1') or (UpperCase(Test) = 'TRUE');
end;

function DataValue(Field : string) : string;
begin
  //If not found return input value.
  Result := Field;
  Field := UpperCase(Field);
  Result := '$'+Field+'$';
end;

function FirstFound(const Str, FragA, FragB: string; StartP : integer; var P : integer) : string;
//Look in Str for FragA and FragB, and return which Frag is found first, or '' if neither found
//  If found, then P is the index of the start of the returned Frag
var P1, P2 : integer;
begin
  Result := '';  P := 0; //default to failure
  P1 := PosEx(FragA, Str, StartP);
  P2 := PosEx(FragB, Str, StartP);
  if (P1 > 0) and ((P1 < P2) or (P2=0)) then begin           //FragA found, FragB may or may not have been found
    Result := FragA;
    P := P1;
  end else if (P2 > 0) and ((P2 < P1) or (P1=0)) then begin  //FragB found, FragA may or may not have been found
    Result := FragB;
    P := P2;
  end;
end;

function NextToken(Const Str : string; var P : integer) : string;
//Find next %__% token and return
//Change P to be beginning of token, or unchanged if not found.
var P1, P2 : integer;
    StrA, StrB, StrC : string;
begin
  Result := '';
  P1 := P;
  while P1 > 0 do begin
    P1 := PosEx('%', Str, P1);  //look for opening %
    if P1 = 0 then break;
    P2 := PosEx('%', Str, P1+1); //look for closing %
    if P2 = 0 then break;
    StrA := MidStr(Str, 1, P1-1);
    StrB := MidStr(Str, P1, P2-P1+1);
    StrC := MidStr(Str, P2+1, Length(Str));
    if (Pos(' ', StrB) = 0) then begin  //Screen out widely spaced %'s by checking for spaces in 'field name'
      Result := Strb;
      break;
    end else begin
      P1 := P1+1;
    end;
  end;
  if Result <> '' then P := P1;
end;



function ParseOneIfBlock(str : string; var PreString, PostString, ErrMsg : string) : string;
var P0, P1,P2, ExciseEndP : integer;
    LogicTest, TrueText : string;
    TestResult : boolean;
    TempStr, StrA,StrB: string;
    NextToken : string;
    InterimStr : string;

begin
  PreString := '';
  PostString := '';
  Result := Str; //default is no change.
  ErrMsg := '';

  NextToken := NextBlockOrBoolTag(Str, 1, P1, P2, InterimStr);  //P1 is start of next token, P2 is right after next token
  if NextToken = '' then exit; //normal exit -- nothing found to evaluate
  if NextToken <> IF_TAG then begin
    ErrMsg := 'Found ['+NextToken+'], but expected ['+IF_TAG+']';
    exit;
  end;
  PreString := InterimStr;
  Str := MidStr(Str, P1, Length(Str));  //string should now start with IF_TAG

  NextToken := NextBlockOrBoolTag(Str, Length(NextToken)+1, P1, P2, InterimStr);
  if NextToken <> BEGIN_TAG then begin
    ErrMsg := 'Expected ['+BEGIN_TAG+'] after ['+IF_TAG+'], but found ['+NextToken+']';
    exit;
  end;
  LogicTest := InterimStr;
  TestResult := EvaluateTest(LogicTest, ErrMsg);
  if ErrMsg <> '' then exit;

  P0 := P2;
  P1 := NextMatchedEndTag(Str, P0, P2, InterimStr, ErrMsg); //P0=search start, P2 returned as right after matching End Tag;
  ExciseEndP := P2;

  P0 := P2;
  NextToken := NextBlockOrBoolTag(InterimStr, P0, P1, P2, Tempstr);
  if NextToken <> '' then begin
    if NextToken <> IF_TAG then begin
      ErrMsg := 'While processing sub-block, found unexpected ['+NextToken+']';
      exit;
    end;
    //call self recursively to handle sub-block
    InterimStr := ParseOneIfBlock(InterimStr, StrA, StrB, ErrMsg);
    if ErrMsg <> '' then Exit;
    InterimStr := StrA + InterimStr + StrB;
  end;

  TrueText := InterimStr;
  if not TestResult then TrueText := '';  //just remove truth text, if logic test was false.
  Result := TrueText;
  PostString := MidStr(Str, ExciseEndP, Length(Str));

  //At this point, in Result, the IF <test> BEGIN <truth_text> END block should be replaced
  //  with either '', or the truth_text
  //PreString  = everything before IF_TAG
  //PostString = everything after END_TAG

  Str := PostString;
  NextToken := NextBlockOrBoolTag(Str, 1, P1, P2, InterimStr);
  if NextToken <> ELSE_TAG then exit; //done, normal exit
  InterimStr := TMGTrim(InterimStr);
  if InterimStr <> '' then begin
    ErrMsg := 'After ['+END_TAG+'] found unexpected text before ['+ELSE_TAG+'] : [' + InterimStr + ']';
    exit;
  end;

  Str := MidStr(Str, P2, Length(Str)); //Trim off ELSE_TAG
  NextToken := NextBlockOrBoolTag(Str, 1, P1, P2, InterimStr);
  InterimStr := TMGTrim(InterimStr);
  if (NextToken <> IF_TAG) and (NextToken <> BEGIN_TAG) then begin
    ErrMsg := '['+ELSE_TAG+'] not followed by ['+IF_TAG+'] or ['+BEGIN_TAG+']';
    exit;
  end;
  if InterimStr <> '' then begin
    ErrMsg := 'After ['+ELSE_TAG+'] found unexpected text before ['+NextToken+'] : [' + InterimStr + ']';
    exit;
  end;
  if NextToken = BEGIN_TAG then begin
    Str := IF_TAG+ ' 1 ' + Str;
    NextToken := IF_TAG;
  end;
  TempStr := ParseOneIfBlock(Str, StrA, PostString, ErrMsg);
  if ErrMsg <> '' then exit;
  TempStr := StrA + TempStr;
  if TestResult <> false then TempStr := '';
  Result := Result + Tempstr;
end;

procedure ParseIfBlocks(var Str : string);
var TempS, PreString, PostString, ErrMsg : string;
    Done : boolean;
begin
  repeat
    TempS := ParseOneIfBlock(Str, PreString, PostString, ErrMsg);
    Done := (TempS = Str);
    Str := PreString;
    if ErrMsg <> '' then Str := Str + ' ERROR: ' + ErrMsg;
    Str := Str + TempS + PostString;
  until Done or (ErrMsg <> '');
end;




end.
