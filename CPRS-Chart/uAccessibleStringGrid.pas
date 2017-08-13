//kt -- Modified with SourceScanner on 8/21/2007
unit uAccessibleStringGrid;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, CPRSChart_TLB, StdVcl, Accessibility_TLB,
  ORCtrls, Variants;

type
  TChildType = (ctInvalid, ctNoChild, ctChild);

  TAccessibleStringGrid = class(TAutoObject, IAccessibleStringGrid, IAccessible)
  private
    FDefaultObject: IAccessible;
    FDefaultObjectLoaded: boolean;
    FControl: TCaptionStringGrid;
    function GetDefaultObject: IAccessible;
  protected {IAccessible}
    function accHitTest(xLeft, yTop: Integer): OleVariant; safecall;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant;
      safecall;
    function Get_accChild(varChild: OleVariant): IDispatch; safecall;
    function Get_accChildCount: Integer; safecall;
    function Get_accDefaultAction(varChild: OleVariant): WideString; safecall;
    function Get_accDescription(varChild: OleVariant): WideString; safecall;
    function Get_accFocus: OleVariant; safecall;
    function Get_accHelp(varChild: OleVariant): WideString; safecall;
    function Get_accHelpTopic(out pszHelpFile: WideString;
      varChild: OleVariant): Integer; safecall;
    function Get_accKeyboardShortcut(varChild: OleVariant): WideString;
      safecall;
    function Get_accName(varChild: OleVariant): WideString; safecall;
    function Get_accParent: IDispatch; safecall;
    function Get_accRole(varChild: OleVariant): OleVariant; safecall;
    function Get_accSelection: OleVariant; safecall;
    function Get_accState(varChild: OleVariant): OleVariant; safecall;
    function Get_accValue(varChild: OleVariant): WideString; safecall;
    procedure accDoDefaultAction(varChild: OleVariant); safecall;
    procedure accLocation(out pxLeft, pyTop, pcxWidth, pcyHeight: Integer;
      varChild: OleVariant); safecall;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); safecall;
    procedure Set_accName(varChild: OleVariant; const pszName: WideString);
      safecall;
    procedure Set_accValue(varChild: OleVariant; const pszValue: WideString);
      safecall;
  protected
    property DefaultObject: IAccessible read GetDefaultObject write FDefaultObject;
  public
    property Control: TCaptionStringGrid read FControl write FControl;
    function ChildType( varChild: OleVariant): TChildType;
    class procedure WrapControl( Control: TCaptionStringGrid);
    class procedure UnwrapControl( Control: TCaptionStringGrid);
  public {but it wouldn't be in a perfect world}
    function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HResult; override;
  end;

implementation

uses uComServ, SysUtils, uAccessAPI, Windows, Controls,
     DKLang  //kt
     ;

var
  UserIsRestricted: boolean = False;

function TAccessibleStringGrid.accHitTest(xLeft,
  yTop: Integer): OleVariant;
var
  ACol: integer;
  ARow: integer;
  P: TPoint;
begin
  result := Null;
  if Assigned(FControl) then
  begin
    P.X := xLeft;
    P.Y := yTop;
    P := FControl.ScreenToClient(P);
    FControl.MouseToCell(P.X, P.Y, ACol, ARow);
    if (ACol = -1) or (ARow = -1) then
      result := NULL
    else
      result := FControl.ColRowToIndex( ACol, ARow);
  end
  else
    result := CHILDID_SELF;
end;

function TAccessibleStringGrid.accNavigate(navDir: Integer;
  varStart: OleVariant): OleVariant;
begin
  result := Null;
  if Assigned(FControl) then
  begin
  case ChildType(varStart) of
    ctNoChild:
      case navDir of
        NAVDIR_FIRSTCHILD:
          result := 1;
        NAVDIR_LASTCHILD:
          result := Get_AccChildCount;
        NAVDIR_DOWN,
        NAVDIR_LEFT,
        NAVDIR_NEXT,
        NAVDIR_PREVIOUS,
        NAVDIR_RIGHT,
        NAVDIR_UP:
          result := varStart;
      end;
    ctChild:
      case NavDir of
        NAVDIR_FIRSTCHILD,
        NAVDIR_LASTCHILD:
          result := varStart;
        NAVDIR_DOWN:
          result := varStart + (FControl.ColCount - FControl.FixedCols);
        NAVDIR_LEFT,
        NAVDIR_NEXT:
          result := varStart + 1;
        NAVDIR_PREVIOUS,
        NAVDIR_RIGHT:
          result := varStart - 1;
        NAVDIR_UP:
          result := varStart - (FControl.ColCount - FControl.FixedCols);
      end;
    end;
    //revert if index is invalid
    if ChildType(result) = ctChild then
    begin
      if (result > Get_AccChildCount) or (result < 1) then
        result := varStart;
    end;
  end;
end;

function TAccessibleStringGrid.Get_accChild(
  varChild: OleVariant): IDispatch;
begin
  result := nil;
  OleError(S_FALSE);
end;

function TAccessibleStringGrid.Get_accChildCount: Integer;
begin
  if Assigned(FControl) then
    result := (FControl.RowCount - FControl.FixedRows) * (FControl.ColCount - FControl.FixedCols)
  else
    result := 0;
end;

function TAccessibleStringGrid.Get_accDefaultAction(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accDefaultAction(varChild);
end;

function TAccessibleStringGrid.Get_accDescription(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accDescription(varChild);
end;

function TAccessibleStringGrid.Get_accFocus: OleVariant;
begin
  if Assigned(FControl) and FControl.Focused then
    result := FControl.ColRowToIndex(FControl.Col, FControl.Row)
  else
    result := NULL;
end;

function TAccessibleStringGrid.Get_accHelp(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accHelp(varChild);
end;

function TAccessibleStringGrid.Get_accHelpTopic(
  out pszHelpFile: WideString; varChild: OleVariant): Integer;
begin
  result := 0;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accHelpTopic(pszHelpFile, varChild);
end;

function TAccessibleStringGrid.Get_accKeyboardShortcut(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accKeyboardShortcut(varChild);
end;

function TAccessibleStringGrid.Get_accName(
  varChild: OleVariant): WideString;
var
  Row,Col: integer;
  ColumnName: string;
  RowName: string;
begin
  case ChildType(varChild) of
    ctNoChild:
      result := FControl.Caption;
    ctChild:
    begin
      if Assigned(FControl) then
      begin
        FControl.IndexToColRow(varChild,Col,Row);
        if (FControl.FixedRows = 1) and (FControl.Cells[Col,0] <> '') then
          ColumnName := FControl.Cells[Col,0]
        else
          ColumnName := IntToStr(Col-FControl.FixedCols+1);
        if (FControl.FixedCols = 1) and ((FControl.Cells[0,Row] <> '')) then
          RowName := FControl.Cells[0,Row]
        else
//        RowName := IntToStr(Row-FControl.FixedRows+1) + ' of ' +  <-- original line.  //kt 8/21/2007
          RowName := IntToStr(Row-FControl.FixedRows+1) + DKLangConstW('uAccessibleStringGrid_of') + //kt added 8/21/2007
            IntToStr(FControl.RowCount - FControl.FixedRows);
//      result := 'Column ' + ColumnName + ', Row ' + RowName;  <-- original line.  //kt 8/21/2007
        result := DKLangConstW('uAccessibleStringGrid_Column')+' ' + ColumnName + DKLangConstW('uAccessibleStringGrid_x_Row') + RowName; //kt added 8/21/2007
      end
      else
//      result := 'Unknown Property';  <-- original line.  //kt 8/21/2007
        result := DKLangConstW('uAccessibleStringGrid_Unknown_Property'); //kt added 8/21/2007
    end;
    else
//    result := 'Unknown Property';  <-- original line.  //kt 8/21/2007
      result := DKLangConstW('uAccessibleStringGrid_Unknown_Property'); //kt added 8/21/2007
  end;
end;

function TAccessibleStringGrid.Get_accParent: IDispatch;
begin
  result := nil;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accParent;
end;

function TAccessibleStringGrid.Get_accRole(
  varChild: OleVariant): OleVariant;
begin
  case ChildType(varChild) of
    ctNoChild:
      result := ROLE_SYSTEM_LIST;
    ctChild:
      result := ROLE_SYSTEM_LISTITEM;
    else
      result := ROLE_SYSTEM_CLIENT;
  end;
end;

function TAccessibleStringGrid.Get_accSelection: OleVariant;
begin
  //We are assuming single-selection for this control
  if Assigned(FControl) then
    result := FControl.ColRowToIndex(FControl.Col, FControl.Row)
  else
    result := NULL;
end;

function TAccessibleStringGrid.Get_accState(
  varChild: OleVariant): OleVariant;
begin
  if Assigned(FControl) then
  begin
    result := STATE_SYSTEM_FOCUSABLE  or STATE_SYSTEM_READONLY or STATE_SYSTEM_SELECTABLE;
    case ChildType(varChild) of
      ctNoChild:
        if FControl.Focused then
          result := result or STATE_SYSTEM_FOCUSED;
      ctChild:
      begin
        if FControl.ColRowToIndex(FControl.Col, FControl.Row) = varChild then
        begin
          result := result or STATE_SYSTEM_SELECTED;
          if FControl.Focused then
            result := result or STATE_SYSTEM_FOCUSED;
        end;
      end;
    end;
    if ([csCreating,csDestroyingHandle] * FControl.ControlState <> []) or
      ([csDestroying,csFreeNotification,csLoading,csWriting] * FControl.ComponentState	<> []) then
      result := result or STATE_SYSTEM_UNAVAILABLE;
  end
  else
    result := STATE_SYSTEM_UNAVAILABLE;
end;

function TAccessibleStringGrid.Get_accValue(
  varChild: OleVariant): WideString;
var
  Row,Col: integer;
begin
  case ChildType(varChild) of
    ctNoChild:
      result := '';
    ctChild:
    begin
      if Assigned(FControl) then
      begin
        FControl.IndexToColRow(varChild,Col,Row);
        result := FControl.Cells[Col,Row];
        if FControl.JustToTab then
          result := Copy(result, 1, pos(#9{Tab},Result) -1);
      end
      else
//      result := 'Unknown Property';  <-- original line.  //kt 8/21/2007
        result := DKLangConstW('uAccessibleStringGrid_Unknown_Property'); //kt added 8/21/2007
    end;
    else
//    result := 'Unknown Property';  <-- original line.  //kt 8/21/2007
      result := DKLangConstW('uAccessibleStringGrid_Unknown_Property'); //kt added 8/21/2007
  end;
end;

procedure TAccessibleStringGrid.accDoDefaultAction(varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accDoDefaultAction(varChild);
end;

procedure TAccessibleStringGrid.accLocation(out pxLeft, pyTop, pcxWidth,
  pcyHeight: Integer; varChild: OleVariant);
var
  P: TPoint;
  R: TRect;
begin
  if Assigned(FControl) then
  begin
    case ChildType(varChild) of
      ctNoChild:
      begin
        P.X := 0;
        P.Y := 0;
        with FControl.ClientToScreen(P) do begin
          pxLeft := X;
          pyTop := Y;
        end;
        pcxWidth := FControl.Width;
        pcyHeight := FControl.Height;
      end;
      ctChild:
      begin
        R := FControl.CellRect(FControl.Col,FControl.Row);
        with FControl.ClientToScreen(R.TopLeft) do begin
          pxLeft := X;
          pyTop := Y;
        end;
        pcxWidth := R.Right - R.Left;
        pcyHeight := R.Bottom - R.Top;
      end;
      else
      begin
        pxLeft := 0;
        pyTop := 0;
        pcxWidth := 0;
        pcyHeight := 0;
      end;
    end;
  end;
end;

procedure TAccessibleStringGrid.accSelect(flagsSelect: Integer;
  varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accSelect(flagsSelect, varChild);
end;

procedure TAccessibleStringGrid.Set_accName(varChild: OleVariant;
  const pszName: WideString);
begin
  if Assigned(DefaultObject) then
    DefaultObject.Set_accName(varChild, pszName);
end;

procedure TAccessibleStringGrid.Set_accValue(varChild: OleVariant;
  const pszValue: WideString);
var
  Row,Col: integer;
begin
  case ChildType(varChild) of
    ctChild:
    begin
      if Assigned(FControl) then
      begin
        FControl.IndexToColRow(varChild,Col,Row);
        FControl.Cells[Col,Row] := pszValue;
      end;
    end;
  end;
end;

function TAccessibleStringGrid.ChildType(varChild: OleVariant): TChildType;
begin
  if VarType(varChild) <> varInteger then
    result := ctInvalid
  else if varChild = CHILDID_SELF then
    result := ctNoChild
  else
    result := ctChild;
end;

function TAccessibleStringGrid.GetDefaultObject: IAccessible;
begin
  if Assigned(FControl) and not FDefaultObjectLoaded then begin
    FDefaultObject := uAccessAPI.GetDefaultObject(FControl);
    FDefaultObjectLoaded := True;
  end;
  Result := FDefaultObject;
end;

function TAccessibleStringGrid.SafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HResult;
begin
  if (ExceptObject is EOleSysError) then
    result := EOleSysError(ExceptObject).ErrorCode
  else
    result := inherited SafeCallException(ExceptObject, ExceptAddr);
end;

class procedure TAccessibleStringGrid.UnwrapControl(
  Control: TCaptionStringGrid);
begin
  if not UserIsRestricted then
    Control.MakeAccessible(nil);
end;

class procedure TAccessibleStringGrid.WrapControl(
  Control: TCaptionStringGrid);
var
  AccessibleStringGrid: TAccessibleStringGrid;
  {Using Accessible here is probably just interface reference count paranoia}
  Accessible: IAccessible;
begin
  if not UserIsRestricted then
  begin
    AccessibleStringGrid := TAccessibleStringGrid.Create;
    Accessible := AccessibleStringGrid;
    AccessibleStringGrid.Control := Control;
    Control.MakeAccessible(Accessible);
  end;
end;

initialization
  try
    TAutoObjectFactory.Create(ComServer, TAccessibleStringGrid, Class_AccessibleStringGrid,
      ciMultiInstance, tmApartment);
  except
    {Let the poor restricted users pass!}
    UserIsRestricted := True;
  end;
end.
