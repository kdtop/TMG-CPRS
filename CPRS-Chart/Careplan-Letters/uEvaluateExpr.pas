unit uEvaluateExpr;
//VEFA-261-tm
//Kevin Toppenberg, MD, created and added entire unit 5/2011
//Debugging and optimization by Eddie Hagood 2/2012

(**************************************************************************
Unit will take a string containing a mathematic function an return value.

  E.g. '14 + 5 * 6 + 5 / 4'   = 45.25

The allowed operators are: () ^ * / + -  (evaluated in order left-to-right).

  E.g. '(14 + 5) * (6 + 5) / 4'    = 52.24

Nested parentheses are allowed.

  E.g. '14 + (5 * (6+3)) + 5 / 4' = 60.25

^ is the power operator.  E.g. 5^3 is 5 cubed

  E.g. '25^3' = 15625

Logic expressions are allowed

  E.g. '12<100' = 1  (1=TRUE)
  E.g. '(12*12)<100' = 0  (0=FALSE)
  Note: this can also be done with BOOL() function (see below)

A limited number of functions are also available:

    ROUND(X) -- Rounds the value X to the nearest whole number using 'Banker's
                Rounding', meaning that if X is exactly halfway between two whole
                numbers, then the result will chosen that is even.
    FLOOR(X) -- Returns the greatest whole number that is <= X.
                E.g. Floor(-7.7) = -8
                     Floor(7.8) = 7
    CEIL(X)  -- Returns the lowest whole number that is >= X.
                E.g. Ceil(-7.8) = -7
                     Ceil(7.8) = 8
    EXP(X)   -- Returns the value of e raised to the X power.  e is the base
                of natural logarithms.
    POWER(X,Y) -- Returns the value of X raised to the Y power (X^Y).   This is alternative syntax.  X^Y is also allowed directly
    LOG(X,BASE) -- Returns log of value, in specified base.  Base defaults to 10
    LN(X)    -- Returns natural log of value
    SQRT(X)  -- Returns the square root of X.
    ABS(X)   -- Returns the aboslute value of X
                E.g. ABS(-7.8) = 7.8
    AVG(X1,X2,X3,X4...) -- Returns average of parameters. Any number of parameters
                may be provided.
                E.g. AVG(7.6, 5.8, 9.4, 5, 2, 7.3, 22) =  8.44285714285714
    MAX(X1,X2,X3,X4...) -- Returns greatest number in set of parameters.
                Any number of parameters may be provided.
                E.g. MAX(7.6, 5.8, 9.4, 5, 2, 7.3, 22) = 22
    MIN(X1,X2,X3,X4...) -- Returns smallest number in set of parameters.
                Any number of parameters may be provided.
                E.g. MIN(7.6, 5.8, 9.4, 5, 2, 7.3, 22) = 2
    MOD(X1,X2)--Returns X1 mod X2, which gives REMAINDER after integer division
                X1/X2  .
                E.g. MOD(10,4) = 2
                     MOD(10,5) = 5
                     MOD(10,6) = 4
                If input parameters are not whole numbers, then they are rounded
                first to make integers
    DIV(X1,X2)--Returns integer division of X1/X2
                E.g. DIV(17, 2) =2
                If input parameters are not whole numbers, then they are rounded
                first to make integers
    DIGITS(X,N)--Trims off more than N digits. Trailing 0's are removed.
                E.g. DIGITS(7.234212312,4) = 7.2342
                     DIGITS(14.0000000001,3) = 14,  not 14.000
    TEXT(X)    -- Just returns X as text.  Used to specify text that should not be treated as math expressions
    BOOL(X1,Oper,X2) -- Does boolean comparison.
or  BOOL(X1 Oper X2) -- Alternative syntax.  Does boolean comparison. (Space not needed)
                 Resolves to "1" for TRUE, "0" for FALSE
                 Allowed Oper values:
                "&", or "AND"  //X1 and X2 are converted to boolean (see below)
                "!", or "OR"   //X1 and X2 are converted to boolean (see below)
                "'", or "NOT"  //X1 and X2 are converted to boolean (see below)
                ">"
                ">=" or "'<"
                "'=", or "<>"
                "<"
                "<=" or "'>"
                "="

                When X1 and X2 are converted to boolean:
                  0 = FALSE
                  All other numbers are TRUE

                Note: A logic expression in parentheses is same as BOOL()
                      E.g. (5<6) will evaluate same as BOOL(5<6)

    CASE(<test>, <Result_if_BOOL()_is_true>,
         <test>, <Result_if_BOOL()_is_true>,
         <test>, <Result_if_BOOL()_is_true>,
         ...
         <test>, <Result_if_BOOL()_is_true> )  --  Case Function.  Returns result if <test> = 1
               --Result may be a numeric OR a string value.
               --Test may be an expression.
                      0 is FALSE
                      all other numbers are interpreted as TRUE
                 Use (<logic_expr>) or BOOL(<logic_expr>) for more complex boolean tests
               --if this function returns a string value to a function that expects a numeric
                 value, an error message will be returned
               --As soon as <test> is found TRUE, the corresponding <result> is returned.  Further <tests> are not checked
               --If no tests are true, the result is ''
               --To have result return simple use, TEXT() or just supply text,
                 otherwise result is treated as math expression.
               --If result is to be the result of a formula, it should be enclosed in parentheses/()'s

               Examples:
                 CASE( BOOL(12*4,>,3*8), TEXT(Found result #1),
                       (177<>155), TEXT(Found a different result (#2)),
                       1, TEXT(Here is a default result))

                 CASE( 12*4>3*8, (1+2+3+4),
                       1, TEXT(Here is a default result)) --> '10'

                 CASE( 12*4<3*8, (1+2+3+4),
                       1, Here is a default result)  --> 'Here is a default result'

    NUM(<Text>) -- Convert string with numbers and letters into one with JUST numbers
               Examples:
                   NUM(1 -- Hardly at all) = 1.
                    (Note: Same as "+" command in Mumps language)
                   NUM(ABC) = 0
                   NUM(ABC 123) = 0
                   NUM(123 ABC) = 123

    PIECE(String,Delim,Position,[EndPos]) -- Returns the piece(s) in the string, with string separated by deliminator.
               Examples:
                  PIECE(Sun^Mon^Tue^Wed^Thurs^Fri^Sat,^,5)=Thurs
                  PIECE(Sun^Mon^Tue^Wed^Thurs^Fri^Sat,^,2,3)=Mon^Tue
                  Note: To use comma (,) as a deliminator, place in quotes: ","
                        To use space as deliminator, place in quotes: " "

    SETPIECE(String,Delim,Position,NewVal) -- Sets specified piece to new value
               Examples:
                  PIECE(Apple^Pear^Orange^Grape,^,3,Strawberry)=Apple^Pear^Strawberry^Grape
                  Note: To use comma (,) as a deliminator, place in quotes: ","
                        To use space as deliminator, place in quotes: " "

    IN(X,low,hi) -- Returns 1 if X is in range [low..hi]  More explicitly: (X>=low)&(X<=hi)
               Examples:
                  IN(10,1,10) = 1    (10 is in range 1..10)
                  IN(12,1,10) = 0    (12 is not in range 1..10)

The values for X, x1, x2 etc. in the functions above may themselves be expressions, including
other functions.

E.g.
  digits( sqrt(10 + 7), 4 ) = 4.1231

Notes:
--Case is not important. ROUND() is same as Round() and round().
--Spacing in expressions is not significant.  It is trimmed out automatically.
--Numbers are significant to 15-16 digits (8 bytes).
  Range: 5.0 x 10^-324 .. 1.7 x 10^308
--Text may optionally be put in quotes using ' or " character.
  e.g. "Hello" or 'Hello' or Hello <-- should all be the same
--Space will be evaluated as 0 if a number is expected.
  e.g. ">5" is same as 0>5 = false
--If a numeric parameter is expected, a parameter that starts with a
  number will be interpreted as a number.
  e.g. "1 -- happy"+3 = 4  because string will be interpreted as 1

***************************************************************************)

interface

uses
  SysUtils, Classes, StdCtrls, StrUtils, Math;

  function EvalRealExpression (var Expr : string; var ErrStr : string) : real; forward;
  function NumPieces(S : string; Delim : string) : integer; forward;
  function FunctionNameOK(FnName : string) : boolean; forward;  ////Checks if name is function.
  function NumberOfFunctionNames : integer;
  function GetFunctionName(Index : integer) : string;
  function EvalExpression     (var Expr : string; var ErrStr : string)        : String; overload;  forward;
  function EvalExpression     (var Expr : string; var ProblemFound : boolean) : String; overload;  forward;

implementation

  function FnAVG       (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnMAX       (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnMIN       (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnMOD       (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnDIV       (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnPower     (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnLog       (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnDigits    (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnBOOL      (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnCASE      (ParamSL : TStringList; var ErrStr : string) : string; forward;
  //function FnTEXT      (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnNUM       (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnPiece     (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnSetPiece  (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnNumPieces (ParamSL : TStringList; var ErrStr : string) : string; forward;
  function FnInRange   (ParamSL : TStringList; var ErrStr : string) : string; forward;

  function  Piece    (const S: string; Delim: char;   PieceNum: Integer): string;                 overload; forward;
  function  Piece    (const S: string; Delim: string; PieceNum: Integer): string;                 overload; forward;
  function  PieceNCS (const S: string; Delim: string; PieceNum: Integer): string;                 overload; forward;
  function  Pieces   (const S: string; Delim: char;   FirstNum, LastNum: Integer): string;        overload; forward;
  function  Pieces   (const S: string; Delim: string; PieceStart,PieceEnd: Integer): string;      overload; forward;
  function  PiecesNCS(const S: string; Delim: string; PieceStart,PieceEnd: Integer): string;      overload; forward;
  procedure SetPiece (var   s: string; Delim: string; PieceNum: Integer; const NewPiece: string); forward;
//function NumPieces(S : string; Delim : Char) : integer; forward; <-- moved to interface section

  function FindPairedChars(Expr: string; var ErrStr : string; var P1,P2 : integer;
                           OpenChar : char = '(') : string;                                          forward;
  function TrimPairedChars(OpenChar : char; Expr: string) : string;                                  forward;
  function GetPairedParentheses(var Expr: string; var ErrStr : string; OpenChar : char = '(') : string; forward;
  procedure PieceToSL(S : string; Delim : Char; SL : TStringList; var ErrStr : string); overload;    forward;
  procedure PieceToSL(S : string; Delim : String; SL : TStringList; var ErrStr : string); overload;  forward;
  function EvalForText(Expr : string; Var ErrStr : string) : string;                                 forward;

  type
    SingleArgFn = function(X: Real) : Real;
    SLArgFn = function(SL : TStringList; var ErrStr : string) : real;
    SLArgStrFn = function(SL : TStringList; var ErrStr : string) : string;
    tFnOutputType = (tfoNumeric, tfoString, tfoNumOrString);
    FnRec = record
      Name : string;
      Result : tFnOutputType;
      case integer of
        0 : (Fn : SingleArgFn);
        1 : (SLFn : SlArgFn);
        2 : (SLStrFn : SLArgStrFn);
    end;
  const
    NUM_FNS = 23;
    MAX_SINGLE_VAL_FNS = 8;   //elh  was 7
    FUNCTIONS : array [1..NUM_FNS] of FnRec = (
      //-- Single parameter functions ----
      (Name:'ROUND';     Result: tfoNumeric ; Fn:nil),
      (Name:'FLOOR';     Result: tfoNumeric ; Fn:nil),
      (Name:'CEIL';      Result: tfoNumeric ; Fn:nil),
      (Name:'EXP';       Result: tfoNumeric ; Fn:nil),   // EXP(x) == e^x
      (Name:'LN';        Result: tfoNumeric ; Fn:nil),   // Ln(x) == natural log of X
      (Name:'SQRT';      Result: tfoNumeric ; Fn:nil),
      (Name:'ABS';       Result: tfoNumeric ; Fn:nil),
      (Name:'TEXT';      Result: tfoString  ; Fn:nil),          //Return simple text of parameter
      //-- single-valued SL parameter functions --
      //elh (Name:'TEXT';      Result: tfoString ;  SLStrFn:FnTEXT),          //Return simple text of parameter
      (Name:'NUM';       Result: tfoNumeric ; SLStrFn:FnNUM),           //Return conversion of text --> number.  E.g. "1 YES" --> "1"
            //-- multi-value parameter functions --
      (Name:'AVG';       Result: tfoNumeric ; SLStrFn:FnAVG),           //Finds average of set.
      (Name:'MAX';       Result: tfoNumeric ; SLStrFn:FnMAX),           //Finds minimum of set
      (Name:'MIN';       Result: tfoNumeric ; SLStrFn:FnMIN),           //Finds maximum of set
      (Name:'MOD';       Result: tfoNumeric ; SLStrFn:FnMOD),           //Finds modulus: MOD(16, 4) == 16 mod 4.  If parameters are not integers, then rounded first to make integers
      (Name:'DIV';       Result: tfoNumeric ; SLStrFn:FnDIV),           //integer divide: DIV(17, 2) == 17 div 2.  If parameters are not integers, then rounded first to make integers
      (Name:'DIGITS';    Result: tfoNumeric ; SLStrFn:FnDigits),        //Truncate to given number of digits.
      (Name:'BOOL';      Result: tfoNumeric ; SLStrFn:FnBOOL),          //Boolean logic
      (Name:'PIECE';     Result: tfoString  ; SLStrFn:FnPiece),         //A get $PIECE() function
      (Name:'SETPIECE';  Result: tfoString  ; SLStrFn:FnSetPiece),      //A set $PIECE() function
      (Name:'IN';        Result: tfoNumeric ; SlStrFn:FnInRange),       //If number in range
      (Name:'CASE';      Result: tfoString  ; SLStrFn:FnCASE),          //A case statement
      (Name:'POWER';     Result: tfoNumeric ; SLStrFn:FnPower),         //A Power statement (x^y)
      (Name:'LOG';       Result: tfoNumeric ; SLStrFn:FnLog),           //A Log(baseY) of X
      (Name:'NUMPIECES'; Result: tfoString  ; SLStrFn:FnNumPieces)      //Number of pieces function
    );

    NUM_OPERATORS = 5;
    //Note: the operators are in order of evaluation.
    ALLOWED_OPERATORS : array[1..NUM_OPERATORS] of char = (
      '^',
      '*',
      '/',
      '+',
      '-'
    );

  function IsOperator(c : char) : boolean;
  var i : integer;
  begin
    Result := false;
    for i := 1 to NUM_OPERATORS do begin
      if ALLOWED_OPERATORS[i] <> c then continue;
      Result := true;
      break;
    end;
  end;

  function IsFunction(var Name : string) : boolean;
  //checks if is function.  Also converts name to upper case
  var i : integer;
  begin
    Name := UpperCase(Name);
    Result := false;
    for i := 1 to NUM_FNS do begin
      if FUNCTIONS[i].Name <> Name then continue;
      Result := true;
      break;
    end;
  end;

  function NumberOfFunctionNames : integer;
  begin Result := NUM_FNS; end;

  function GetFunctionName(Index : integer) : string;
  begin
    if (Index>0) and (Index<= NUM_FNS) then begin
      Result := FUNCTIONS[Index].Name;
    end else Result := '???';
  end;


  function FunctionNameOK(FnName : string) : boolean;
  //Checks if name is function.
  begin
    Result := IsFunction(FnName);
  end;

  function JustNumbers(S : string) : string;
  //Returns just initial numeric part of string.
  //If result would be '', then '0' returned
  var i : integer;
      DecimalFound : boolean;
      tempS : string;
  begin
    Result := '';
    tempS := TrimPairedChars('"', S);
    if Length(tempS) = Length(S)-2 then S := tempS;
    DecimalFound := false;
    s := trim(s);
    for i := 1 to length(S) do begin
      if S[i] = '.' then begin
        if DecimalFound then break;
        Result := Result + '.';
        DecimalFound := true;
      end else if S[i] in ['0'..'9'] then begin
        Result := Result + S[i];
      end else break;
    end;
    if (Result='') or (Result='.') then Result := '0';
  end;


  function StrToReal(Num : string; var ErrStr : string) : real;
  //Will force non-numeric strings into numeric, or 0 if completely alpha
  begin
    Result := 0;
    Try
      Result := StrToFloat(Num);
    except
      Num := JustNumbers(Num);
      try
        Result := StrToFloat(Num);
      except
        ErrStr := 'Error converting ''' + Num + ''' to a number.';
      end;
    end;
  end;


  function FunctionIndex(FnName : string) : integer;
  var i : integer;
  begin
    Result := -1;
    for i := 1 to NUM_FNS do begin
      if FnName <> FUNCTIONS[i].Name then continue;
      Result := i;
      break;
    end;
  end;

  //---------- Improved/Overloaded/Extended functions from ORFn ------------------------
  function Piece(const S: string; Delim: char; PieceNum: Integer): string;
  { returns the Nth piece (PieceNum) of a string delimited by Delim }
  var
    i: Integer;
    Strt, Next: PChar;
  begin
    i := 1;
    Strt := PChar(S);
    Next := StrScan(Strt, Delim);
    while (i < PieceNum) and (Next <> nil) do
    begin
      Inc(i);
      Strt := Next + 1;
      Next := StrScan(Strt, Delim);
    end;
    if Next = nil then Next := StrEnd(Strt);
    if i < PieceNum then Result := '' else SetString(Result, Strt, Next - Strt);
  end;

  function Piece(const S: string; Delim: string; PieceNum: Integer): string; overload;
  var Remainder : String;
      PieceLen,p : integer;
  begin
    Remainder := S;
    Result := '';
    PieceLen := Length(Delim);
    while (PieceNum > 0) and (Length(Remainder) > 0) do begin
      p := Pos(Delim,Remainder);
      if p=0 then p := length(Remainder)+1;
      Result := MidStr(Remainder,1,p-1);
      Remainder := MidStr(Remainder,p+PieceLen,9999);
      Dec(PieceNum);
    end;
  end;

  function Pieces(const S: string; Delim: string; PieceStart,PieceEnd: Integer): string; overload;
  var Remainder : String;
      PieceNum : integer;
      PieceLen,p : integer;
  begin
    Remainder := S;
    Result := '';
    PieceLen := Length(Delim);
    PieceNum := PieceStart;
    while (PieceNum > 1) and (Length(Remainder) > 0) do begin
      p := Pos(Delim,Remainder);
      if p=0 then p := length(Remainder)+1;
      Result := MidStr(Remainder,1,p-1);
      Remainder := MidStr(Remainder,p+PieceLen,9999);
      Dec(PieceNum);
    end;
    PieceNum := PieceEnd-PieceStart+1;
    Result := '';
    while (PieceNum > 0) and (Length(Remainder) > 0) do begin
      p := Pos(Delim,Remainder);
      if p=0 then p := length(Remainder)+1;
      if Result <> '' then Result := Result + Delim;
      Result := Result + MidStr(Remainder,1,p-1);
      Remainder := MidStr(Remainder,p+PieceLen,9999);
      Dec(PieceNum);
    end;
  end;

  function Pieces(const S: string; Delim: char; FirstNum, LastNum: Integer): string;
  { returns several contiguous pieces }
  var
    PieceNum: Integer;
  begin
    Result := '';
    for PieceNum := FirstNum to LastNum do Result := Result + Piece(S, Delim, PieceNum) + Delim;
    if Length(Result) > 0 then Delete(Result, Length(Result), 1);
  end;

  function PieceNCS(const S: string; Delim: string; PieceNum: Integer): string; overload;
  // 8/09  Name means Piece-Not-Case-Sensitive, meaning match for Delim is not case sensitive.
  // 8/09 Added entire function
  var tempS : string;
  begin
    tempS := AnsiReplaceText(S,Delim,UpperCase(Delim));
    Result := Piece(tempS,UpperCase(Delim),PieceNum);
  end;

  function PiecesNCS(const S: string; Delim: string; PieceStart,PieceEnd: Integer): string;
  // 8/09  Name means Pieces-Not-Case-Sensitive, meaning match for Delim is not case sensitive.
  // 8/09 Added entire function
  var tempS : string;
  begin
    tempS := AnsiReplaceText(S,Delim,UpperCase(Delim));
    Result := Pieces(tempS,UpperCase(Delim),PieceStart,PieceEnd);
  end;


  function NumPieces(S : string; Delim : string) : integer;
  var p, Offset : integer;
  begin
    Result := 1;
    Offset := 1;
    repeat
      p := PosEx(Delim,S,Offset);
      if p > 0 then begin
        Offset := p + length(Delim);
        inc(Result);
      end;
    until (p=0);
  end;

  procedure SetPiece (var s: string; Delim: string; PieceNum: Integer; const NewPiece: string);
  { sets the Nth piece (PieceNum) of a string to NewPiece, adding delimiters as necessary }
  var
    StrB : string;
    p : integer;
  begin
    p := 1;
    Dec(PieceNum);
    while (PieceNum > 0) and (p > 0) do begin
      p := PosEx(Delim, S, p);
      if p > 0 then begin
        p := p + length(Delim);
        Dec(PieceNum);
      end;
    end;
    while PieceNum>0 do begin
      s := s + Delim;
      Dec(PieceNum);
      p := 0;
    end;
    if p = 0 then p := Length(s)+1;
    StrB := MidStr(s, p, Length(s));
    s := LeftStr(s, p-1) + NewPiece;
    p := Pos(Delim,StrB);
    if p > 0 then s := s + MidStr(StrB, p, Length(StrB));
  end;


  //---------- End Improved/Overloaded/Extended functions from ORFn ------------------------

  function FindPairedChars(Expr: string; var ErrStr : string; var P1,P2 : integer;
                           OpenChar : char = '(') : string;
  //Note: changed function such that search starts at P1
  var NestLevel : integer;
      i         : integer;
      EndIndex  : integer;
      CloseChar : char;
  begin
    if OpenChar = '(' then CloseChar := ')'
    else if OpenChar = '[' then CloseChar := ']'
    else if OpenChar = '{' then CloseChar := '}'
    else if OpenChar = '''' then CloseChar := ''''
    else if OpenChar = '"' then CloseChar := '"'
    else begin
      ErrStr := '"'+OpenChar+'" not supported.';
      exit;
    end;
    P1 := PosEx(OpenChar,Expr,P1);
    if P1 < 1 then begin
      ErrStr := '"'+OpenChar+'" not found.';
      exit;
    end;
    NestLevel := 1;  //0
    EndIndex := 0;
    Result := '';
    //for i := P1 to length(Expr) do begin
    for i := P1+1 to length(Expr) do begin
      if Expr[i] = CloseChar then begin
        Dec(NestLevel);
        if NestLevel > 0 then continue;
        EndIndex := i;
        break;
      end;
      if Expr[i] = OpenChar then begin
        inc(NestLevel);
        continue;
      end;
    end;
    if (NestLevel > 0) or (EndIndex = 0) then begin
      ErrStr := 'Unmatched parentheses or other paired characters';
      exit;
    end;
    P2 := EndIndex;
  end;


  function TrimPairedChars(OpenChar : char; Expr: string) : string;
  //Expr must begin with OpenChar
  //Result is the text in the matching parentheses (or other paired characters.) -- doesn't include OpenChar or CloseChar
  var P1, P2 : integer;
      DiscardErr : string;
  begin
    P1 := 1;
    FindPairedChars(Expr, DiscardErr, P1,P2, OpenChar);
    Result := MidStr(Expr,P1+1, P2-P1-1);
  end;

  function GetPairedParentheses(var Expr: string; var ErrStr : string; OpenChar : char = '(') : string;
  //Expr must begin with '('
  //Result is the text in the matching parentheses.
  //Expr is modified to leave behind the rest of the string, following after removed result
  var P1, P2 : integer;
  begin
    P1 := 1;
    FindPairedChars(Expr, ErrStr, P1,P2, OpenChar);
    Result := MidStr(Expr,P1, P2);
    Expr := Trim(MidStr(Expr, P2+1,length(Expr)));
  end;

  procedure PieceToSL(S : string; Delim : String; SL : TStringList; var ErrStr : string);
  //Assumption: 1st character is not "("
  //Will not divide using Delim if they are inside matched parentheses "()"

    const
      SUB_STR = '[#^^&asdf^^@#]';  //arbitrary string sequence

    procedure GuardDelimInParen(var s : string; Delim : String);
    var p : integer;
        ParenS,
        GuardedS,
        tempS : string;
    begin
      p := 0;
      repeat
        p := PosEx('(',s, p+1);
        if p > 0 then begin
          tempS := MidStr(S,p,length(s));
          ParenS := GetPairedParentheses(tempS, ErrStr); if ErrStr<>'' then exit;
          GuardedS := AnsiReplaceStr(ParenS,Delim, SUB_STR);
          s := AnsiReplaceStr(s,ParenS,GuardedS)
        end;
      until (p=0);
    end;

    function UnGuardStr(s : string; Delim : String) : string;
    begin
      Result := AnsiReplaceStr(s, SUB_STR, Delim);
    end;

  var i : integer;
      OnePiece : string;
  begin
    if not Assigned(SL) then exit;
    GuardDelimInParen(s,Delim);
    SL.Clear;
    for i := 1 to NumPieces(S, Delim) do begin
      OnePiece := Trim(Piece(S, Delim, i));
      OnePiece := UnGuardStr(OnePiece,Delim);
      SL.Add(OnePiece);
    end;
  end;

  procedure PieceToSL(S : string; Delim : Char; SL : TStringList; var ErrStr : string);
  var DelimStr : String;
  begin
    DelimStr := Delim;
    PieceToSL(S, DelimStr, SL, ErrStr);
  end;


  function GetNextFunction(var Expr, ErrStr : string) : string;
  //Purpose: separate ABCD(....)xxxxxxx -->  ABCD(....)  + xxxxxxx
  var i : integer;
      SavedExpr, tempExpr : string;
      FnName : string;
  begin
    Result := '';
    SavedExpr := Expr;
    tempExpr := UpperCase(Expr);
    for i := 1 to length(Expr) do begin
      if tempExpr[i] in ['A'..'Z','0'..'9','_','.','-'] then begin
        Result := Result + tempExpr[i];
      end else if Expr[i] = '(' then begin
        Expr := MidStr(Expr,i,999999);
        Result := Result + GetPairedParentheses(Expr, ErrStr);
        break;
      end else begin
        ErrStr := 'While looking for function name, found unexpected character '''
                  +Expr[i]+''' in ''' + SavedExpr + '''';
        break;
      end;
    end;
    if Pos('(',Result)<1 then begin
      ErrStr := 'Error looking for Function_Name(...).  Found: ''' + SavedExpr + '''';
      exit;
    end;
    FnName := UpperCase(piece(Result,'(',1));
    if FunctionIndex(FnName) = -1 then begin
      ErrStr := 'Invalid function name: ''' + FnName + '''';
    end;
  end;


  function GetNextNumber(var Expr, ErrStr : string) : string;
  //Purpose: separate [-]###xxxxxxxx --> ### + xxxxxxxxx
  var i : integer;
      EndIndex : integer;
  begin
    EndIndex := 0;
    Result := '';
    for i := 1 to length(Expr) do begin
      if (Expr[i] in ['0'..'9','.']) or ((Expr[i] = '-') and (i = 1)) then begin
        Result := Result + Expr[i];
        EndIndex := i;
      end else begin
        EndIndex := i-1;
        break;
      end;
    end;
    if (Result = '') or (EndIndex = 0) then begin
      ErrStr := 'Unable to find numeric term in ''' + Expr + '''';
    end else begin
      Expr := MidStr(Expr,EndIndex+1,99999);
    end;
  end;

  function GetNextString(QtChar : char; var Expr, ErrStr : string) : string;
  //Purpose: separate "abcdefg"xxxxxxxx --> abcdefg + xxxxxxxxx
  //Assumption: first character is quote char
  var p : integer;
  begin
    p := PosEx(QtChar,Expr,2);
    if p>0 then begin
      Result := MidStr(Expr,2,p-2);
      Expr := MidStr(Expr,p+1,length(Expr));
    end else begin
      ErrStr := 'String with unmatched quote characters found: ' + Expr;
    end;
  end;

  procedure GetNextTermAndOperator(var Expr, Term, Operator, ErrStr : string);
  var i,P2 : integer;
      OperIdx : integer;
      OperatorOK : boolean;
  begin
    Expr := Trim(Expr);
    if Expr = '' then begin
      ErrStr := 'Expression term is empty';
      exit;
    end;
    Term := '';
    if (Expr[1]='+') then begin
      Expr := '0' + Expr;
      //Expr := Midstr(Expr,2,99999);
    end;
    OperIdx := 0;
    i := 1;
    while i <= length(Expr) do begin
      if Expr[i]='(' then begin
        //FindPairedParen(Expr, ErrStr, i, P2);
        FindPairedChars(Expr, ErrStr, i, P2);
        if P2<= i then begin
          ErrStr := 'Unmatched parentheses';
          exit;
        end;
        i := P2;
      end else if IsOperator(Expr[i]) then begin
        if (i <> 1) or (Length(Expr)<2) or (Expr[2]=' ') then begin  //e.g. if '-25' don't take '-' as operator
          OperIdx := i;
          break;
        end;
      end;
      inc (i);
    end;
    if OperIdx > 0 then begin
      Term := Trim(MidStr(Expr,1,OperIdx-1));
      Expr := MidStr(Expr,OperIdx,length(Expr));
    end else begin
      Term := Expr;
      Expr := '';
    end;

    if ErrStr <> '' then exit;
    //Expr should have first term trimmed off now.
    //--- Now get operator ---
    Expr := Trim(Expr);
    if length(Expr)>0 then begin
      OperatorOK := IsOperator(Expr[1]);
      if not OperatorOK then begin
        ErrStr := 'Invalid operator ''' + Operator + '''';
        exit;
      end;
      Operator := Expr[1];
      Expr := Trim(MidStr(Expr,2,99999));
    end else begin
      Operator := '';
    end;
  end;


  procedure ExpressionToSL(var Expr : string; ExprSL : TStringList; var ErrStr : string; StartIndex : integer = 0);
  //Returns StringList with format:
  //   term  -- e.g. 5, or (12 * 25 + 17)  (Any such compound term with start with '('
  //   operator
  //   term
  //   operator
  //   term ...
  var Term, Operator : string;
      SavedExpr : string;
  begin
    SavedExpr := Expr;
    while Expr <> '' do begin
      GetNextTermAndOperator(Expr, Term, Operator, ErrStr);
      if ErrStr <> '' then exit;
      ExprSL.Add(Term);
      if (Expr = '') and (Operator <> '') then begin
        //ErrStr := 'Invalid trailing operator in ''' + SavedExpr + '''';
        //exit;
        Expr := '0';
      end;
      if Operator <> '' then ExprSL.Add(Operator);
      Expr := Trim(Expr);
    end;
  end;

  procedure SplitBoolExpr(Expr : string; var BExpr1, BExpr2, Oper, ErrStr : string);

    function GetWordOper(Name : string; var Expr : string;
                         var i : integer;
                         var OperDone : boolean;
                         var ErrStr : string) : string;
    begin
      Result := MidStr(Expr,i,length(Name));  i := i + length(Name);
      if Result <> Name then begin
        ErrStr := 'Invalid boolean operator: "' + Oper + '". Expected "'+Name+'".';
      end;
      OperDone := true;
    end;

  var i : integer;
      SubExpr : string;
      SaveExpr : string;
      OperDone : boolean;
  begin
    if Expr = '' then exit;
    SaveExpr := Expr;
    Expr := Trim(Expr);
    BExpr1 := '';
    BExpr2 := '';
    Oper := '';
    i := 1;
    while (i <= length(Expr)) do begin  //find first part of boolean expression
      if Expr[i] = '(' then begin
        SubExpr := GetPairedParentheses(Expr, ErrStr);   if ErrStr <> '' then exit;
        SubExpr := MidStr(SubExpr,2,length(SubExpr)-2);
        BExpr1 := BExpr1 + EvalExpression (SubExpr, ErrStr);if ErrStr <> '' then exit;
      end else if Expr[i] in ['&','!','''','>','<','=','A','O','N'] then begin
        break;
      end else begin
        BExpr1 := BExpr1 + Expr[i];
        inc(i);
      end;
    end;
    if BExpr1 = Expr then begin
      ErrStr := '"' + Expr + '" is not a logical expression';
      exit;
    end;
    if Trim(BExpr1) = '' then BExpr1 := '0';
    if Pos('(',BExpr1)=0 then BExpr1 := JustNumbers(BExpr1);
    BExpr1 := EvalExpression (BExpr1, ErrStr);if ErrStr <> '' then exit;
    OperDone := false;
    while (i <= length(Expr)) and not OperDone do begin  //find boolean operator
      if Expr[i]='A' then begin
        Oper := GetWordOper('AND', Expr, i, OperDone, ErrStr);if ErrStr <> '' then exit;
      end else if Expr[i]='O' then begin
        Oper := GetWordOper('OR', Expr, i, OperDone, ErrStr); if ErrStr <> '' then exit;
      end else if Expr[i]='N' then begin
        Oper := GetWordOper('NOT', Expr, i, OperDone, ErrStr);if ErrStr <> '' then exit;
      end else if Expr[i] in ['&','!','''','>','<','='] then begin
        Oper := Oper + Expr[i];
      end else OperDone := true;
      if not OperDone then inc(i);
    end;
    if (OperDone = false) and (Oper = '') then begin
      ErrStr := 'Incomplete boolean expression: ' + SaveExpr;
      exit;
    end;
    //Now get second comparator of boolean expression
    SubExpr := Trim(MidStr(Expr,i,length(Expr)));
    if SubExpr = '' then SubExpr := '0';
    if SubExpr[1] = '(' then begin
      SubExpr := GetPairedParentheses(SubExpr, ErrStr);   if ErrStr <> '' then exit;
      SubExpr := MidStr(SubExpr,2,length(SubExpr)-2);
    end else if Pos('(',SubExpr)=0 then begin
      SubExpr := JustNumbers(SubExpr);
    end;
    BExpr2 := EvalExpression (SubExpr, ErrStr);if ErrStr <> '' then exit;
  end;


  //---------- Function handlers -------------------
  function MissingExpectedParams(Name : string; ParamSL : TStringList;
                               Var ErrStr : string;
                               Min : integer; Max : integer=-1) : boolean;
  //Returns if ErrStr set
  //Set Max to -1 to have it be ignored
  //Assumptions: ParamSL defined
  begin
    Result := false;
    if ParamSL.Count < Min then begin
      Result := true;
      ErrStr := 'PIECE() has ' + IntToStr(ParamSL.Count) + ' parameters.  ' +
                'Expected at least ' + IntToStr(Min);
      if Max <> -1 then ErrStr := ErrStr + 'to ' + IntToStr(Max);
      ErrStr := ErrStr + '.'
    end;
  end;

  procedure Get1Param(Expr: string; var Val1 : real; var ErrStr : string);
  var Val1S  : string;
      tempExpr  : string;
  begin
    tempExpr := Expr;
    Val1S := EvalExpression (tempExpr, ErrStr);
    if ErrStr <> '' then begin
      tempExpr := 'NUM('+Expr+')';
      Val1S := EvalExpression (tempExpr, ErrStr);
    end;
    if ErrStr <> '' then exit;
    Val1 := StrToReal(Val1S, ErrStr);         if ErrStr <> '' then exit;
  end;

  procedure Get2Params(Name: string; ParamSL : TStringList; var Val1, Val2 : real; var ErrStr : string);
  begin
    if MissingExpectedParams(Name, ParamSL, ErrStr, 2) then exit;
    Get1Param(ParamSL.Strings[0], Val1, ErrStr); if ErrStr <> '' then exit;
    Get1Param(ParamSL.Strings[1], Val2, ErrStr); if ErrStr <> '' then exit;
  end;

  procedure Get3Params(Name: string; ParamSL : TStringList; var Val1, Val2, Val3 : real; var ErrStr : string);
  begin
    if MissingExpectedParams(Name, ParamSL, ErrStr, 3) then exit;
    Get1Param(ParamSL.Strings[0], Val1, ErrStr); if ErrStr <> '' then exit;
    Get1Param(ParamSL.Strings[1], Val2, ErrStr); if ErrStr <> '' then exit;
    Get1Param(ParamSL.Strings[2], Val3, ErrStr); if ErrStr <> '' then exit;
  end;

  function FnMAX(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //Returns numeric string;
  var i : integer;
      OneVal : real;
      ResultN : real;
  begin
    ResultN := 0;
    if MissingExpectedParams('MAX', ParamSL, ErrStr, 1) then exit;
    for i := 0 to ParamSL.Count-1 do begin
      Get1Param(ParamSL.Strings[i], OneVal, ErrStr); if ErrStr <> '' then exit;
      if i = 0 then ResultN := OneVal
      else begin
        if (OneVal > ResultN) then ResultN := OneVal;
      end;
    end;
    Result := FloatToStr(ResultN);
  end;


  function FnMIN(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //Returns numeric string;
  var i : integer;
      OneVal : real;
      ResultN : real;
  begin
    ResultN := 0;
    if MissingExpectedParams('MIN', ParamSL, ErrStr, 1) then exit;
    for i := 0 to ParamSL.Count-1 do begin
      Get1Param(ParamSL.Strings[i], OneVal, ErrStr); if ErrStr <> '' then exit;
      if i = 0 then ResultN := OneVal
      else begin
        if (OneVal < ResultN) then ResultN := OneVal;
      end;
    end;
    Result := FloatToStr(ResultN);
  end;

  function FnMOD(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //E.g. MOD(8,2) == 8 mod 2
  //Returns numeric string;
  var Val1, Val2 : real;
      ResultN : real;
  begin
    Get2Params('MOD', ParamSL, Val1, Val2, ErrStr);
    if ErrStr <> '' then exit;
    ResultN := Round(Val1) mod round(Val2);
    Result := FloatToStr(ResultN);
  end;


  function FnDIV(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //E.g. DIV(8,2) == 8 div 2
  //Returns numeric string;
  var Val1, Val2 : real;
      ResultN : real;
  begin
    Get2Params('DIV', ParamSL, Val1, Val2, ErrStr);
    if ErrStr <> '' then exit;
    ResultN := Round(Val1) div Round(Val2);
    Result := FloatToStr(ResultN);
  end;

  function FnPower(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //E.g. POWER(8,2) == 8^2   (e.g. POWER(BASE,EXPONENT)
  //Returns numeric string;
  var Val1, Val2 : real;
      ResultN : extended;
  begin
    Get2Params('POWER', ParamSL, Val1, Val2, ErrStr);
    if ErrStr <> '' then exit;
    ResultN := Power(Val1, Val2);
    Result := FloatToStr(ResultN);
  end;

  function FnLog (ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //E.g. LOG(100,10) == 2   (e.g. log (base 10) of 100 = 2   (because 10^2 = 100)
  //Base parameter is optional.  Default is 10
  //Returns numeric string;
  var Val1, Base : real;
      ResultN : extended;
  begin
    if MissingExpectedParams('LOG', ParamSL, ErrStr, 1) then exit;
    Get1Param(ParamSL.Strings[0], Val1, ErrStr); if ErrStr <> '' then exit;
    if ParamSL.Count>1 then begin
      Get1Param(ParamSL.Strings[1], Base, ErrStr); if ErrStr <> '' then exit;
    end else begin
      Base := 10;  //default to base 10
    end;
    ResultN := LogN(Base, Val1);
    Result := FloatToStr(ResultN);
  end;

  function FnDigits(ParamSL : TStringList; var ErrStr : string) : string;
  //Returns numeric string;
  //Assumptions: ParamSL defined
  //Truncates number to set number of digits.
  //E.g. DIGITS(7.234212312,4) = 7.2342
  //Trailing 0's are removed.
  //E.g. DIGITS(14.0000000001,3) = 14,  not 14.000
  var Val1, Val2, Pwr : real;
      ResultN : real;
  begin
    Get2Params('DIGITS', ParamSL, Val1, Val2, ErrStr);
    if ErrStr <> '' then exit;
    if Val2 < 0 then ErrStr := 'Can not truncate number to ' + FloatToStr(Val2) + ' digits.';
    if ErrStr <> '' then exit;
    Pwr := Power(10, Val2);
    ResultN := (Trunc(Val1 * Pwr)) / Pwr;
    Result := FloatToStr(ResultN);
  end;


  function FnAVG(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //E.g. AVG(4.5, 5.7, 111.22, (4*12), SQRT(8 + 8))
  //Returns numeric string;
  var i : integer;
      OneVal : real;
      ResultN : real;
  begin
    ResultN := 0;
    if MissingExpectedParams('AVG', ParamSL, ErrStr, 2) then exit;
    for i := 0 to ParamSL.Count-1 do begin
      Get1Param(ParamSL.Strings[i], OneVal, ErrStr); if ErrStr <> '' then exit;
      if i = 0 then ResultN := OneVal
      else  ResultN := ResultN + OneVal;
    end;
    ResultN := ResultN / ParamSL.Count;
    Result := FloatToStr(ResultN);
  end;

  {*
  function FnTEXT(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //Returns only 1st string in list
  begin
    if MissingExpectedParams('TEXT', ParamSL, ErrStr, 1) then exit;
    //Result := ParamSL.Strings[0];  //VEFA-261
    Result := ParamSL.Text;  // .Text property appends CRLF to end of result, which causes problems
    Result := AnsiReplaceStr(Result,#10,'');
    Result := AnsiReplaceStr(Result,#13,'');
  end;
  *}

  function FnNUM(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //works on only 1st string in list
  begin
    if MissingExpectedParams('NUM', ParamSL, ErrStr, 1) then exit;
    Result := JustNumbers(ParamSL.Strings[0]);
  end;

  function FnNumPieces (ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //E.g. NUMPIECES('A;B;C;D',';') == 4  e.g. there are 4 pieces
  //Returns numeric string;
  var Val1, Val2 : String;
      ResultN : integer;
 begin
    if MissingExpectedParams('NUMPIECES', ParamSL, ErrStr, 2) then exit;
    Val1 := EvalForText(ParamSL.Strings[0], ErrStr); if ErrStr <> '' then exit;
    Val2 := EvalForText(ParamSL.Strings[1], ErrStr); if ErrStr <> '' then exit;
    ResultN := NumPieces(Val1, Val2);
    Result := IntToStr(ResultN);
  end;

  function FnPiece(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined, and has at least 1 parameter.
  //PIECE(String,Delim,Position,[EndPos]) -- Returns the piece in the string, with string separated by deliminator.
  var Str, Delim, Idx,Idx2 : string;
      IdxN,Idx2N  : real;
      P1,P2 : integer;
      Expr : string;
  begin
    Result := '';
    if (ParamSL.Count < 3) or (ParamSL.Count > 4) then begin
      ErrStr := 'PIECE() has ' + IntToStr(ParamSL.Count) + ' parameters.  Expected 3 or 4.';
      exit;
    end;
    Str := EvalForText(ParamSL.Strings[0], ErrStr); if ErrStr <> '' then exit;
    Delim := EvalForText(ParamSL.Strings[1], ErrStr); if ErrStr <> '' then exit;
    if Delim='' then Delim:= ' ';  //Trim would have removed space

    Expr := ParamSL.Strings[2];
    Idx := EvalExpression (Expr, ErrStr);   if ErrStr <> '' then exit;
    IdxN := StrToReal(Idx, ErrStr);         if ErrStr <> '' then exit;
    P1 := round(IdxN);
    if ParamSl.Count=4 then begin
      Expr := ParamSL.Strings[3];
      Idx2 := EvalExpression (Expr, ErrStr);if ErrStr <> '' then exit;
      Idx2N := StrToReal(Idx, ErrStr);      if ErrStr <> '' then exit;
      P2 := Round(Idx2N);
      Result := Pieces(Str,Delim,P1,P2);
    end else begin
      Result := Piece(Str,Delim,P1);
    end;
  end;

  function FnSetPiece(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined, and has at least 1 parameter.
  //SETPIECE(String,Delim,Position,NEW_VALUE) -- Returns original string, with specified piece changed.
  var Delim, Idx, StrP, NewVal : string;
      IdxN  : real;
      P1 : integer;
      Expr : string;
  begin
    Result := '';
    if MissingExpectedParams('SETPIECE', ParamSL, ErrStr, 4) then exit;
    Expr := EvalForText(ParamSL.Strings[0], ErrStr);      if ErrStr <> '' then exit;
    Delim := EvalForText(ParamSL.Strings[1], ErrStr);     if ErrStr <> '' then exit;
    if Delim='' then Delim:= ' ';  //Trim would have removed space
    StrP := ParamSL.Strings[2];
    Idx := EvalExpression (StrP, ErrStr);   if ErrStr <> '' then exit;
    IdxN := StrToReal(Idx, ErrStr);                       if ErrStr <> '' then exit;
    P1 := round(IdxN);
    NewVal := EvalForText(ParamSL.Strings[3], ErrStr);    if ErrStr <> '' then exit;
    SetPiece(Expr, Delim, P1, NewVal);
    Result := Expr;
  end;


  function FnBOOL(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined, and has at least 1 parameter.
  //Returns numeric string (0 or 1)

  var Val1S, Val2S : string;
      Val1, Val2 : real;
      Expr : string;
      Oper : string;
      B1,B2, ResultB : boolean;
  begin
    ResultB := false;
    if ParamSL.Count=1 then begin
      Expr := ParamSL.Strings[0];
      SplitBoolExpr(Expr, Val1S, Val2S, Oper, ErrStr); if ErrStr <> '' then exit;
    end else begin
      if ParamSL.Count <> 3 then begin
        ErrStr := 'BOOL() has ' + IntToStr(ParamSL.Count) + ' parameters.  Expected 3.';
        exit;
      end;
      Expr := ParamSL.Strings[0];
      Val1S := EvalExpression (Expr, ErrStr);   if ErrStr <> '' then exit;
      Oper := ParamSL.Strings[1];
      Expr := ParamSL.Strings[2];
      Val2S := EvalExpression (Expr, ErrStr);   if ErrStr <> '' then exit;
    end;
    Val1 := StrToReal(Val1S, ErrStr);         if ErrStr <> '' then exit;
    Val2 := StrToReal(Val2S, ErrStr);         if ErrStr <> '' then exit;
    B1 := (Val1 <> 0);
    B2 := (val2 <> 0);

    if (Oper='&') or (Oper='AND') then       ResultB := B1 and B2
    else if (Oper='!') or (Oper='OR') then   ResultB := B1 or B2
    else if (Oper='''') or (Oper='NOT') then ResultB := B1 and not B2
    else if (Oper='''=') or (Oper='<>') then ResultB := Val1 <> Val2
    else if Oper='>' then                    ResultB := Val1 > Val2
    else if (Oper='>=') or (Oper='''<') then ResultB := Val1 >= Val2
    else if Oper='<' then                    ResultB := Val1 < Val2
    else if (Oper='<=') or (Oper='''>') then ResultB := Val1 <= Val2
    else if Oper='=' then                    ResultB := Val1 = Val2
    else begin
      ErrStr := 'Invalid boolean operator: ' + Oper;
    end;
    if ResultB then Result := '1'
    else            Result := '0';
  end;


  function FnCASE(ParamSL : TStringList; var ErrStr : string) : string;
  //Assumptions: ParamSL defined
  //E.g. AVG(4.5, 5.7, 111.22, (4*12), SQRT(8 + 8))
  //Returns numeric string;
  var Val1S : string;
      Expr : string;
      tempErrStr : string;
      MatchFound : Boolean;

  begin
    Result := '';
    MatchFound := false;
    while (ParamSL.Count>0) and (not MatchFound) do begin
      if ParamSL.Count < 2 then begin
        ErrStr := 'CASE() has and odd number of parameters.  Must have matching TEST and RESULT parameters.';
        exit;
      end;
      Expr := ParamSL.Strings[0];
      Val1S := JustNumbers(EvalExpression (Expr, ErrStr));   if ErrStr <> '' then exit;
      MatchFound := (Val1S <> '0');
      Expr := Trim(ParamSL.Strings[1]);
      ParamSL.Delete(1);  //keep order of deletion intact.  First 1 then 0.
      ParamSL.Delete(0);
      if not MatchFound then continue;
      //Examples of possible expressions:
      // 'This is a test (and it should be good), OK?'
      // 'TEXT( this is more of the same)'
      // '<naname>(A,B,C)'
      if Pos('(',Expr)>0 then begin
        Result := EvalExpression (Expr, tempErrStr);
        if tempErrStr <> '' then begin
          Result := Expr;  //if error evaluating, ignore, and use Expr
        end;
        if Result = '0' then begin
          //Here we have the issue that a string of text will return at 0, and so can a function.
          //So how to determine if expression or result is wanted??
          //Will default to treating as text.
          //User can put function (e.g. 1+2+3) in parentheses -- (1+2+3)
          if (Expr <> '') and (Expr[1]='(') then begin
            //do nothing, leave result as evaluated result.
          end else begin
            Result := Expr;
          end;
        end;
      end else begin
        Result := Expr;
      end;
    end;
  end;

  function FnInRange(ParamSL : TStringList; var ErrStr : string) : string;
  // IN(X,low,hi) -- Returns 1 if X is in range [low..hi]  More explicitly: (X>=low)&(X<=hi)
  var Val,Lo,Hi : real;
  begin
    Get3Params('IN',ParamSL, Val,Lo,Hi, ErrStr); if ErrStr <> '' then exit;
    if (Val>=Lo) and (Val <= Hi) then Result := '1'
    else Result := '0';
  end;


  function EvalSimple(Term1, Operator, Term2: string; var ErrStr : string) : string;
  //Returns numeric string;
  var N1, N2 : real;
      ResultN : real;
  begin
    ResultN := -1;
    N1 := StrToReal(Term1, ErrStr); if ErrStr <> '' then exit;
    N2 := StrToReal(Term2, ErrStr); if ErrStr <> '' then exit;
    if Operator = '^' then      ResultN := Power(N1, N2)
    else if Operator = '*' then ResultN := N1 * N2
    else if Operator = '/' then begin
      if (N1 = 0) OR (N2 = 0) then ResultN := 0 else ResultN := N1 / N2;  //  to avoid zero division errors
    end else if Operator = '+' then ResultN := N1 + N2
    else if Operator = '-' then ResultN := N1 - N2;
    Result := FloatToStr(ResultN);
  end;

  //---------- End Function handlers -------------------

  procedure EvalForBool(var Expr : string);
  var ParamSL : TStringList;
      ResultS : string;
      ErrStr : string;
  begin
    ParamSL := TStringList.Create;
    try
      ParamSL.Add(Expr);
      ResultS := FnBOOL(ParamSL,ErrStr);
      if ErrStr = '' then begin
        Expr := ResultS;
      end;
    finally
      ParamSL.Free;
    end;
  end;

  function EvalForText(Expr : string; Var ErrStr : string) : string;
  //Evaluate Expression ONLY if the expression is a string-result type function
  //NOTE: The output of the expression will be wrapped as TEXT()
  const  TEXT_FN = 'TEXT(';
         CASE_FN = 'CASE(';
  var //IsCaseFn : boolean;
      FnIndex : integer;
      FnName : string;
  begin
    result := Expr;
    FnName := Piece(Expr,'(',1);
    FnIndex := FunctionIndex(FnName);
    if FnIndex = -1 then exit;
    if FUNCTIONS[FnIndex].Result = tfoNumeric then exit;
    //IsCaseFn := (LeftStr(Uppercase(Expr),Length(CASE_FN)) = CASE_FN);
    //if (LeftStr(Uppercase(Expr),Length(TEXT_FN)) <> TEXT_FN) and (not IsCaseFn) then exit;
    if FUNCTIONS[FnIndex].Name <> 'TEXT' then Expr := 'TEXT(' + Expr + ')';
    //if IsCaseFn then Expr := 'TEXT(' + Expr + ')';
    result := EvalExpression (Expr, ErrStr);
  end;


  function EvalFn(Expr : string; Var ErrStr : string) : string;
  //E.g. ROUND(14.76 * 15.34 + 7.3)
  //E.g. AVG(5.6, 7.9, 3.5, 9.4)
  //Returns either numeric string OR non-numeric string.
  var FnName,InnerFnName : string;
      SubExpr : String;
      ValS : string;
      Val : real;
      FnIndex : integer;
      ParamSL : TStringList;
      ResultN : real;
  begin
    Result := '??';
    FnName := Trim(piece(Expr,'(',1));
    if not IsFunction(FnName) then begin
      ErrStr := FnName + ' is not a valid function name.';
      Exit;
    end;
    SubExpr := MidStr(Expr,Length(FnName)+1, Length(Expr));
    SubExpr := Trim(SubExpr); //Handle potential space between fn name and ()
    SubExpr := MidStr(SubExpr,2, Length(SubExpr)-2);
    try
      FnIndex := FunctionIndex(FnName);
      if FnIndex > MAX_SINGLE_VAL_FNS then begin
        ParamSL := TStringList.Create;
        try
          PieceToSL(SubExpr, ',', ParamSL,ErrStr);
          if ErrStr <> '' then exit;
          if ParamSL.Count = 0 then begin
            ErrStr := 'No parameters provided for '+FnName+'() function';
          end else begin
            Result := FUNCTIONS[FnIndex].SLStrFn(ParamSL, ErrStr);
          end;
        finally
          ParamSL.Free;
        end;
      end else begin
        if (FnName = 'TEXT') then begin
          InnerFnName := Trim(piece(SubExpr,'(',1));
          If IsFunction(InnerFnName) then begin
            ValS := EvalExpression (SubExpr, ErrStr);   if ErrStr <> '' then exit;
            Result := ValS;
          end else begin
            Result := SubExpr;
          end;
        end else begin
          ValS := EvalExpression (SubExpr, ErrStr);   if ErrStr <> '' then exit;
          Val :=  StrToReal(ValS, ErrStr);            if ErrStr <> '' then exit;
          //I can't seem to get FUNCTIONS[FnIndex].Fn(Val) working
          ResultN := 0;
          if FnName = 'ROUND' then ResultN := Round(Val)
          else if FnName = 'FLOOR' then ResultN := Floor(Val)
          else if FnName = 'CEIL'  then ResultN := Ceil(Val)
          else if FnName = 'SQRT'  then ResultN := Sqrt(Val)
          else if FnName = 'ABS'   then ResultN := Abs(Val)
          else if FnName = 'EXP'   then ResultN := Exp(Val)
          else if FnName = 'LN'    then ResultN := Ln(Val);
          Result := FloatToStr(ResultN);
        end;
      end;
    except
      ErrStr := 'Error evaluating: ' + Expr;
    end;
  end;


  function EvalExpression (var Expr : string; var ErrStr : string) : string;
  var ExprSL : TStringList;
      SubExpr : string;
      OperatorOrder, i : integer;
      Operator : char;
      Val, Term1,Term2 : string;
  begin
    ErrStr := '';
    Result := '';
    Expr := AnsiReplaceStr(Expr,#10,'');
    Expr := AnsiReplaceStr(Expr,#13,'');
    if (Length(Expr)>1) then EvalForBool(Expr);
    if Expr = JustNumbers(Expr) then begin
      Result := Expr;
      exit;
    end;
    ExprSL := TStringList.Create;
    try
      ExpressionToSL(Expr, ExprSL, ErrStr);
      if ErrStr <> '' then begin
        exit;
      end;
      //First handle any lines that are ()'s or functions.
      for i := 0 to ExprSl.Count-1 do begin
        if Pos('(',ExprSL.Strings[i])<1 then continue;
        SubExpr := ExprSL.Strings[i];
        if SubExpr[1] = '(' then begin
          SubExpr := MidStr(SubExpr,2,Length(SubExpr)-2); //trim leading and trailing parentheses -- syntax already inforced.
          Val := EvalExpression(SubExpr, ErrStr);
        end else begin
          Val := EvalFn(SubExpr, ErrStr);
        end;
        if ErrStr <> '' then exit;
        ExprSL.Strings[i] := Val;
      end;
      for OperatorOrder := 1 to NUM_OPERATORS do begin
        Operator := ALLOWED_OPERATORS[OperatorOrder];
        i := 0;
        while i < ExprSL.Count do begin
          if (i mod 2)=1 then begin
            if ExprSL.Strings[i] = Operator then begin
              if (i+1) > (ExprSL.Count-1) then begin
                ErrStr := 'Invalid trailing operator';
                break;
              end;
              Term1 := ExprSL.Strings[i-1];
              Term2 := ExprSL.Strings[i+1];
              Val := EvalSimple(Term1, Operator, Term2, ErrStr);
              if ErrStr <> '' then break;
              ExprSL.Delete(i-1);
              ExprSL.Delete(i-1);  Dec(i);
              ExprSL.Strings[i] := Val;
            end;
          end;
          inc (i);
        end;
      end;
      if ExprSL.Count = 1 then begin
        //Result := JustNumbers(ExprSL.Strings[0]);
        Result := ExprSL.Strings[0];
      end else begin
        ErrStr := 'Unable to simplify to single answer.';
      end;
    finally
      ExprSL.Free;
    end;
  end;

  function EvalExpression (var Expr : string; var ProblemFound : boolean) : String;   overload;
  var ErrStr : string;
  begin
    Result := EvalExpression(Expr, ErrStr);
    ProblemFound := (ErrStr <> '');
  end;

  function EvalRealExpression (var Expr : string; var ErrStr : string) : real;
  var ResultS : string;
  begin
    ResultS := EvalExpression (Expr, ErrStr);
    Result := StrToReal(ResultS, ErrStr);
  end;

begin
end.


