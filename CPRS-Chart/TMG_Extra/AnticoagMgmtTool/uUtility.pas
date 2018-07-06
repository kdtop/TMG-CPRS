unit uUtility;

interface

  uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, grids,
    StdCtrls, StrUtils, Math, DateUtils, ORCtrls, ORFn, ORNet, Trpcb,
    uFlowsheet, uTypesACM, uHTMLTools, TMGHTML2;

function  DateCompare(Done1: TDateTime; Done2: TDateTime): tDateCompare;
function  IsPastDate(Date : TDateTime) : boolean;
function  IsFutureDate(Date : TDateTime) : boolean;
function  IsCurrentDate(Date : TDateTime) : boolean;
function  LengthOfTimeNarrToDate(Date : TDateTime) : string;
procedure SLToHTML(SL : TStrings; HTMLObj: THtmlObj; ErasePrior : boolean = true);
function  DecDig(InNum: Single): Integer;
function  TMGFloatToStr(Num : single) : string;
function  TMGStrToDate(FMExternalDateStr : string) : TDateTime;
function  TMGTimeToStr(ATime : TTime) : string;
function  GetControlText(AControl : TObject) : string;
procedure SetControlText(AControl : TObject; S : string);
procedure cboSelectByID(cbo : TComboBox; ID : string); overload;
procedure cboSelectByID(lb : TListBox; ID : string);   overload;
function  cboItemPiece(cbo : TComboBox; PieceNum : integer) : string;
procedure cboLoadFromTagItems(cbo : TComboBox; Pieces : array of integer; delimiter : char = '^');
procedure lbLoadFromTagItems(lb : TListBox; Pieces : array of integer; delimiter : char = '^');
function  TMGDayOfTheWeek(Date : TDateTime) : tDaysOfWeek;
function  IfThenColor(Test : boolean; TrueValue, FalseValue : TColor) : TColor;
function  IfThenCpx(Test : boolean; TrueValue, FalseValue : tPatientComplexity) : tPatientComplexity;
function  IfThenDT(Test : boolean; TrueValue, FalseValue : TDateTime) : TDateTime;
function  IfThenStr(Test : boolean; TrueValue, FalseValue : String) : String;
procedure EnableChildControls(Control: TWinControl; Enable: Boolean);
function  EqualSL(A, B : TStrings) : boolean;

implementation

function DecDig(InNum: Single): Integer;
var
  NumStr: String;
  DecPart: Integer;
begin
  NumStr := FloatToStrF(InNum, ffNumber, 6, 2);
  DecPart := StrToInt(Piece(NumStr, '.', 2));
  case DecPart of
    0:    result := 0;
    1..9: result := 1;
    else  begin
      if (DecPart mod 10 = 0) then begin
        result := 1
      end else begin
        result := 2;
      end;
    end; //else
  end; //case
end;

function TMGFloatToStr(Num : single) : string;
begin
  Result := FloatToStrF(Num, ffNumber, 6, DecDig(Num));
end;

function TMGStrToDate(FMExternalDateStr : string) : TDateTime;
var sDate, sTime : string;
    Date, Time : TDateTime;

begin
  sDate := piece(FMExternalDateStr, '@',1);
  Date := StrToDate(sDate);
  sTime := piece(FMExternalDateStr, '@',2);
  Time := StrToTime(sTime);
  Result := Date + Time;
end;


function TMGTimeToStr(ATime : TTime) : string;
var
  FormattedTime : string;
begin
 //LongTimeFormat := 'h:n';
 //DateTimeToString(formattedDate, 'tt', ATime);
 //FormattedTime := FormatDateTime('hh:nn ampm',ATime);
 Result := FormatDateTime('h:nn ampm',ATime);

end;

function DateCompare(Done1: TDateTime; Done2: TDateTime): tDateCompare;
//NOTE: this ignores time.
var
  Yr1, Month1, Day1, Yr2, Month2, Day2: word;
begin
  result := tdcSame;
  DecodeDate(Done1, Yr1, Month1, Day1);
  DecodeDate(Done2, Yr2, Month2, Day2);
  if Yr1 > Yr2 then result := tdcFirstLater;
  if Yr2 > Yr1 then result := tdcSecondLater;
  if Yr1 = Yr2 then begin
    if Month1 > Month2 then result := tdcFirstLater;
    if Month2 > Month1 then result := tdcSecondLater;
    if Month1 = Month2 then begin
      if Day1 > Day2 then result := tdcFirstLater;
      if Day2 > Day1 then result := tdcSecondLater;
    end;
  end;
end;

function IsPastDate(Date : TDateTime) : boolean;
begin
  Result := (DateCompare(Date, Now) = tdcSecondLater);
end;

function IsFutureDate(Date : TDateTime) : boolean;
begin
  Result := (DateCompare(Date, Now) = tdcFirstLater);
end;

function IsCurrentDate(Date : TDateTime) : boolean;
begin
  Result := (DateCompare(Date, Now) = tdcSame); //ignores time.
end;

function LengthOfTimeNarrToDate(Date : TDateTime) : string;
//e.g. if date is 2 weeks from now, return 'in to weeks'
var
  Yrs, Months, Weeks, Days, TotalDays : integer;
begin
  Result := 'N/A';
  if Now > Date then exit;
  Days := DaysBetween(Date, Now) + 1; //add 1 to make inclusive of today.  Otherwise 1 week ahead returns 6 days.
  TotalDays := Days;
  Yrs := Days div 365;
  Days := Days - (Yrs * 365);
  Months := Days div 30;  //is using 30 for all months going to be a problem?
  Days := Days - (Months * 30);
  Weeks := Days div 7;
  Days := Days - (Weeks * 7);
  Result := '';
  if Yrs > 0 then begin
    Result := IntToStr(Yrs) + ' year';
    if Yrs > 1 then Result := Result + 's';
  end;
  if Months > 0 then begin
    if Result <> '' then Result := Result + ', and ';
    Result := Result + IntToStr(Months) + ' month';
    if Months > 1 then Result := Result + 's';
  end;
  if (TotalDays = 7) or (Weeks >= 2) then begin
    if Result <> '' then Result := Result + ', and ';
    Result := Result + IntToStr(Weeks) + ' week';
    if Weeks > 1 then Result := Result + 's';
  end;
  if (Days > 0) and (TotalDays <> 7) then begin
    if Weeks = 1 then Days := Days + 7;
    if Result <> '' then Result := Result + ', and ';
    Result := Result + IntToStr(Days) + ' day';
    if Days > 1 then Result := Result + 's';
  end;
end;

procedure SLToHTML(SL : TStrings; HTMLObj: THtmlObj; ErasePrior : boolean = true);
var str : AnsiString;  //single byte characters.  If not specified, then default string is Unicodestring
    i   : integer;
begin
  Str := '';
  for i := 0 to SL.Count - 1 do begin
    str := str + SL.Strings[i] + '<br>';
  end;
  if not ErasePrior then str := HTMLObj.HTMLText + '<p>' + str;
  HTMLObj.HTMLText := str;
end;

function GetControlText(AControl : TObject) : string;
begin
  Result := '';
  if not assigned(AControl) then exit;  //not sure if this is needed or not
  if AControl is TEdit then begin
    Result := TEdit(AControl).Text;
  end else if AControl is TLabel then begin
    Result := TLabel(AControl).Caption;
  end;
end;


procedure SetControlText(AControl : TObject; S : string);
begin
  if not assigned(AControl) then exit;  //not sure if this is needed or not
  if AControl is TEdit then begin
    TEdit(AControl).Text := S;
  end else if AControl is TLabel then begin
    TLabel(AControl).Caption := s;;
  end;
end;

procedure cboSelectByID(cbo : TComboBox; ID : string);
var index : integer;
begin
  index := cbo.Items.IndexOf(ID);
  cbo.ItemIndex := index;
end;

procedure cboSelectByID(lb : TListBox; ID : string); overload;
var index : integer;
begin
  index := lb.Items.IndexOf(ID);
  lb.ItemIndex := index;
end;

function cboItemPiece(cbo : TComboBox; PieceNum : integer) : string;
var SL : TStringList;
    Index : integer;
begin
  Result := '';
  SL := TStringList(cbo.Tag); if not Assigned(SL) then exit;
  Index := cbo.ItemIndex; if Index < 0 then exit;
  Result := Piece(SL[Index],'^', PieceNum);
end;

procedure cboLoadFromTagItems(cbo : TComboBox; Pieces : array of integer; delimiter : char = '^');
var i : integer;
    j, pce : integer;
    s : string;
    SL : TStringList;
begin
  cbo.Items.Clear;
  SL := TStringList(cbo.Tag);  if not Assigned(SL) then exit;
  for i := 0 to SL.Count - 1 do begin
    s := '';
    for j := Low(Pieces) to High(Pieces) do begin
      pce := Pieces[j];
      if s <> '' then s := s + ' ';
      s := s + piece(SL[i],'^',pce);
    end;
    s := Trim(s);
    cbo.Items.Add(s);
  end;
end;

procedure lbLoadFromTagItems(lb : TListBox; Pieces : array of integer; delimiter : char = '^');
var i : integer;
    j, pce : integer;
    s : string;
    SL : TStringList;
begin
  lb.Items.Clear;
  SL := TStringList(lb.Tag);  if not Assigned(SL) then exit;
  for i := 0 to SL.Count - 1 do begin
    s := '';
    for j := Low(Pieces) to High(Pieces) do begin
      pce := Pieces[j];
      if s <> '' then s := s + ' ';
      s := s + piece(SL[i],'^',pce);
    end;
    s := Trim(s);
    lb.Items.Add(s);
  end;
end;


function TMGDayOfTheWeek(Date : TDateTime) : tDaysOfWeek;
var dow : integer;
begin
  //DayOfTheWeek returns a value from 1 through 7, where 1 indicates Monday and 7 indicates Sunday
  //... ISO 8601 calls sunday the 7th day of the week.  I strongly disagree!
  dow := DayOfTheWeek(Date);
  if dow = 7 then dow := 0;
  Result := tDaysOfWeek(dow+1);
end;

function IfThenColor(Test : boolean; TrueValue, FalseValue : TColor) : TColor;
begin
  if Test then Result := TrueValue else Result := FalseValue;
end;

function IfThenCpx(Test : boolean; TrueValue, FalseValue : tPatientComplexity) : tPatientComplexity;
begin
  if Test then Result := TrueValue else Result := FalseValue;
end;

function IfThenDT(Test : boolean; TrueValue, FalseValue : TDateTime) : TDateTime;
begin
  if Test then Result := TrueValue else Result := FalseValue;
end;

function  IfThenStr(Test : boolean; TrueValue, FalseValue : String) : String;
begin
  if Test then begin
    Result := TrueValue
  end else begin
    Result := FalseValue
  end;
end;



procedure EnableChildControls(Control: TWinControl; Enable: Boolean);
var i: Integer;
begin
  with Control do begin
    //Enable/Disable Child Controls
    for i := 0 to ControlCount - 1 do begin
      Controls[i].Enabled := Enable;
    end;
    //finally, toggle the Enabled property of Control itself
    Enabled := Enable;
  end;
end;


function EqualSL(A, B : TStrings) : boolean;
//Determine if 2 TStrings are the same.
//NOTE: Could I have just compared A.Text = B.Text ?
var i : integer;
begin
  result := false;
  if not Assigned(A) then exit;
  if not Assigned(B) then exit;
  if A.Count <> B.Count then exit;
  for i := 0 to A.Count-1 do begin
    if A[i] <> B[i] then exit;
  end;
  Result := true;
end;



end.
