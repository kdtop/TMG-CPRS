unit SortStringGrid;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs, Grids;

type
  TSortDirection = (sdNoSort,sdAscending,sdDescending);

  TSortStringGrid = class(TStringGrid)
  private
    FNumbers : TList;
    FLastSortDirection : TSortDirection;
    FLastSortedColumn : LongInt;
    function GetPreSortRowNum(CurRowNum : LongInt) : LongInt;
    procedure SetNumber(RowNum : LongInt; Value : integer);
    function GetNumber(RowNum : LongInt) : Integer;
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    property ANumber[RowNum : LongInt] : Integer read GetNumber write SetNumber;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SortCol(ColNum : integer; SortDirection : TSortDirection);
    property SortedColumn : LongInt read FLastSortedColumn;
    property PreSortRowNum[CurRowNum : LongInt] : LongInt read GetPreSortRowNum;
  end;

implementation

  constructor TSortStringGrid.Create(AOwner: TComponent);
  begin
    inherited Create(AOwner);
    FNumbers := TList.Create;
    FLastSortedColumn := -1;
    FLastSortDirection := sdNoSort;
  end;

  destructor TSortStringGrid.Destroy;
  begin
    FNumbers.Free;
    inherited Destroy;
  end;

  procedure TSortStringGrid.SetNumber(RowNum : Integer; Value : integer);
  begin
    if RowNum < 0 then exit;
    while RowNum > (FNumbers.Count-1) do begin
      FNumbers.Add(TObject(0));
    end;
    FNumbers.Items[RowNum] := TObject(Value);
  end;

  function TSortStringGrid.GetNumber(RowNum : integer) : Integer;
  begin
    Result := 0; //default value
    if (RowNum < 0) or (RowNum > (FNumbers.Count-1)) then exit;
    Result := Integer(FNumbers.Items[RowNum]);
  end;

  procedure TSortStringGrid.MouseUp(Button: TMouseButton;
                                    Shift: TShiftState;
                                    X, Y: Integer);
  var  ACol,ARow : LongInt;
       SortDir : TSortDirection;
       temp : integer;
  begin
    MouseToCell(X, Y, ACol, ARow);
    if ARow=0 then begin
      case FLastSortDirection of
        sdNoSort    : SortDir := sdAscending;
        sdAscending : SortDir := sdDescending;
        sdDescending: SortDir := sdNoSort;
        else          SortDir := sdNoSort;
      end; {case}
      SortCol(ACol,SortDir);
    end else begin
      temp := Self.PreSortRowNum[ARow];
      MessageDlg('Original Row# '+ IntToStr(temp),mtInformation,[mbOK],0);
      inherited MouseUp(Button,Shift,X,Y);
    end;
  end;

  procedure TSortStringGrid.SortCol(ColNum : integer; SortDirection : TSortDirection);
  //Sort routine heavily modified from code found here
  //http://www.delphitricks.com/source-code/components/sort_a_stringgrid.html
  const
    DivS = '/\@/\'; //some arbitrary but unique character sequence
  var
    RowNum                : integer;
    OrigRowNum            : integer;
    SourceRow             : LongInt;
    MyList                : TStringList;
    MyString, TempString  : string;
    DivPos                : integer;
    FirstSort             : boolean;

  begin
    FLastSortedColumn := ColNum;
    FLastSortDirection := SortDirection;
    MyList        := TStringList.Create;
    MyList.Sorted := False;
    try
      FirstSort := (Self.FNumbers.Count=0);
      MyList.Add('--');  //placeholder for header row-
      if SortDirection = sdNoSort then begin
        if FirstSort then exit;  //will jump to Finally part.
        //MyList.Capacity := RowCount;
        for RowNum := 1 to RowCount-1 do MyList.Add(''); //fill to allow random access
        for RowNum := 1 to RowCount-1 do begin
          OrigRowNum := PreSortRowNum[RowNum];
          MyList.Strings[OrigRowNum] := Rows[RowNum].Text;
          MyList.Objects[OrigRowNum] := TObject(OrigRowNum);
        end;
      end else begin
        for RowNum := 1 to RowCount - 1 do begin
          if FirstSort then OrigRowNum := RowNum
          else OrigRowNum := Self.PreSortRowNum[RowNum];
          MyList.AddObject(Rows[RowNum].Strings[ColNum] + DivS + Rows[RowNum].Text,
                           TObject(OrigRowNum));
        end;
        Mylist.Sort;
        for RowNum := 1 to Mylist.Count do begin
          MyString := MyList.Strings[(RowNum - 1)];
          DivPos := Pos(DivS, MyString);
          {Eliminate the Text of the column on which we have sorted the StringGrid}
          TempString := Copy(MyString, DivPos+Length(DivS), Length(MyString));
          MyList.Strings[(RowNum - 1)] := TempString;
        end;
      end;

      for RowNum := 1 to RowCount - 1 do begin
        if SortDirection = sdDescending then SourceRow := RowCount-RowNum
        else SourceRow := RowNum;
        Rows[RowNum].Text := MyList.Strings[SourceRow];
        Self.ANumber[RowNum] := Integer(MyList.Objects[SourceRow]); //Set PreSortNumber
      end;

    finally
      MyList.Free;
    end;
  end;


  procedure TSortStringGrid.DrawCell(ACol, ARow: Longint;
                                     ARect: TRect;
                                     AState: TGridDrawState);
  var P,P2 : TPoint;
      OrigRect : TRect;
      OrigPen : TPen;
      i : integer;
      Dir : integer;
  begin
    //custom code here
    OrigRect := ARect;
    if (ARow=0) and (ACol = FLastSortedColumn)
    and (FLastSortDirection <> sdNoSort) then begin
      ARect.Left := ARect.Left+10; //create space for sort indicator
    end;
    inherited DrawCell(ACol,ARow,ARect,AState);
    if (ARow=0) and (ACol = FLastSortedColumn)
    and (FLastSortDirection <> sdNoSort) then begin
      OrigPen := Canvas.Pen;
      Canvas.Pen.Width := 1;
      Canvas.Pen.Color := clRed;
      P := OrigRect.TopLeft;
      P.X := OrigRect.Left+3;
      P.Y := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
      if FLastSortDirection= sdAscending then Dir := 1
      else Dir := -1;
      for i := 0 to 4 do begin
        P2.X := P.X + i;
        P2.Y := P.Y + i*Dir;
        Canvas.PenPos := P2;
        Canvas.LineTo(P.X+8-i, P.Y+i*Dir);
      end;
      Canvas.Pen := OrigPen;
    end;
  end;

  function TSortStringGrid.GetPreSortRowNum(CurRowNum : LongInt) : LongInt;
  var i :integer;
  begin
    if Self.FNumbers.Count=0 then begin
      for i := 0 to RowCount-1 do begin
        SetNumber(i,i);
      end;
    end;
    Result := GetNumber(CurRowNum);
  end;

end.

