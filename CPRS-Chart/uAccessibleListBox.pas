//kt -- Modified with SourceScanner on 8/25/2007
unit uAccessibleListBox;

interface

uses
  ComObj, ActiveX, CPRSChart_TLB, StdVcl, Accessibility_TLB, ORCtrls, Variants;

type
  TChildType = (ctInvalid, ctNoChild, ctChild);

  TAccessibleListBox = class(TAutoObject, IAccessibleListBox, IAccessible)
  private
    FDefaultObject: IAccessible;
    FDefaultObjectLoaded: boolean;
    FControl: TORListBox;
    function GetDefaultObject: IAccessible;
  protected
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
  public
    property Control: TORListBox read FControl write FControl;
    property DefaultObject: IAccessible read GetDefaultObject write FDefaultObject;
    function ChildType( varChild: OleVariant): TChildType;
    class procedure WrapControl( Control: TORComboBox); overload;
    class procedure UnwrapControl( Control: TORComboBox); overload;
    class procedure WrapControl( Control: TORListBox); overload;
    class procedure UnwrapControl( Control: TORListBox); overload;
  end;

implementation

uses uComServ, uAccessAPI, Windows, SysUtils;

var
  UserIsRestricted: boolean = False;

function TAccessibleListBox.accHitTest(xLeft, yTop: Integer): OleVariant;
begin
  result := Null;
  if Assigned(DefaultObject) then
    result := DefaultObject.accHitTest(xLeft,yTop);
end;

function TAccessibleListBox.accNavigate(navDir: Integer;
  varStart: OleVariant): OleVariant;
begin
  result := Null;
  if Assigned(DefaultObject) then
    result := DefaultObject.accNavigate(navDir, varStart);
end;

function TAccessibleListBox.Get_accChild(varChild: OleVariant): IDispatch;
begin
  result := nil;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accChild(varChild);
end;

function TAccessibleListBox.Get_accChildCount: Integer;
begin
  result := 0;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accChildCount;
end;

function TAccessibleListBox.Get_accDefaultAction(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accDefaultAction(varChild);
end;

function TAccessibleListBox.Get_accDescription(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accDescription(varChild);
end;

function TAccessibleListBox.Get_accFocus: OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accFocus;
end;

function TAccessibleListBox.Get_accHelp(varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accHelp(varChild);
end;

function TAccessibleListBox.Get_accHelpTopic(out pszHelpFile: WideString;
  varChild: OleVariant): Integer;
begin
  result := 0;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accHelpTopic(pszHelpFile, varChild);
end;

function TAccessibleListBox.Get_accKeyboardShortcut(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accKeyboardShortcut(varChild);
end;

function TAccessibleListBox.Get_accName(varChild: OleVariant): WideString;
var
  LongName: string;
  Previous: string;
  i: integer;
begin
  if ChildType(varChild) = ctChild then
  begin
    result := '';
    if Assigned(FControl) then
    begin
      i := varChild - 1;
      LongName := FControl.DisplayText[i];
      if i > 0 then
        Previous := FControl.DisplayText[i-1]
      else
        Previous := '';
      result := CalcShortName( LongName, Previous);
    end;
  end
  else if Assigned(DefaultObject) then
    result := DefaultObject.Get_accName(varChild);
end;

function TAccessibleListBox.Get_accParent: IDispatch;
begin
  result := nil;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accParent;
end;

function TAccessibleListBox.Get_accRole(varChild: OleVariant): OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accRole(varChild);
end;

function TAccessibleListBox.Get_accSelection: OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accSelection;
end;

function TAccessibleListBox.Get_accState(varChild: OleVariant): OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accState(varChild);
end;

function TAccessibleListBox.Get_accValue(varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accValue(varChild);
end;

procedure TAccessibleListBox.accDoDefaultAction(varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accDoDefaultAction(varChild);
end;

procedure TAccessibleListBox.accLocation(out pxLeft, pyTop, pcxWidth,
  pcyHeight: Integer; varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accLocation(pxLeft,pyTop,pcxWidth,pcyHeight,VarChild);
end;

procedure TAccessibleListBox.accSelect(flagsSelect: Integer;
  varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accSelect(flagsSelect, varChild);
end;

procedure TAccessibleListBox.Set_accName(varChild: OleVariant;
  const pszName: WideString);
begin
  if Assigned(DefaultObject) then
    DefaultObject.Set_accName(varChild, pszName);
end;

procedure TAccessibleListBox.Set_accValue(varChild: OleVariant;
  const pszValue: WideString);
begin
  if Assigned(DefaultObject) then
    DefaultObject.Set_accValue(varChild, pszValue);
end;

function TAccessibleListBox.GetDefaultObject: IAccessible;
begin
  if Assigned(FControl) and not FDefaultObjectLoaded then begin
    FDefaultObject := uAccessAPI.GetDefaultObject(FControl);
    FDefaultObjectLoaded := True;
  end;
  Result := FDefaultObject;
end;

function TAccessibleListBox.ChildType(varChild: OleVariant): TChildType;
begin
  if VarType(varChild) <> varInteger then
    result := ctInvalid
  else if varChild = CHILDID_SELF then
    result := ctNoChild
  else
    result := ctChild;
end;

class procedure TAccessibleListBox.WrapControl(Control: TORComboBox);
var
  AccessibleListBox: TAccessibleListBox;
  {Using Accessible here is probably just interface reference count paranoia}
  Accessible: IAccessible;
begin
  if not UserIsRestricted then
  begin
    AccessibleListBox := TAccessibleListBox.Create;
    Accessible := AccessibleListBox;
    AccessibleListBox.Control := Control.MakeAccessible(Accessible);
  end;
end;

class procedure TAccessibleListBox.UnwrapControl(Control: TORComboBox);
begin
  if not UserIsRestricted then
    Control.MakeAccessible(nil);
end;

class procedure TAccessibleListBox.UnwrapControl(Control: TORListBox);
begin
  if not UserIsRestricted then
    Control.MakeAccessible(nil);
end;

class procedure TAccessibleListBox.WrapControl(Control: TORListBox);
var
  AccessibleListBox: TAccessibleListBox;
  {Using Accessible here is probably just interface reference count paranoia}
  Accessible: IAccessible;
begin
  if not UserIsRestricted then
  begin
    AccessibleListBox := TAccessibleListBox.Create;
    Accessible := AccessibleListBox;
    AccessibleListBox.Control := Control;
    Control.MakeAccessible(Accessible);
  end;
end;

initialization
  try
    TAutoObjectFactory.Create(ComServer, TAccessibleListBox, Class_AccessibleListBox,
      ciMultiInstance, tmApartment);
  except
    {Let the poor restricted users pass!}
    UserIsRestricted := True;
  end;
end.
