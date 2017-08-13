//kt -- Modified with SourceScanner on 8/7/2007
unit uAccessibleTreeNode;

interface

uses
  ComObj, ActiveX, CPRSChart_TLB, StdVcl, ORCtrls, Accessibility_TLB;

type
  TChildType = (ctInvalid, ctNoChild, ctChild);

  TAccessibleTreeNode = class(TAutoObject, IAccessibleTreeNode, IAccessible)
  private
    FDefaultObject: IAccessible;
    FDefaultObjectLoaded: boolean;
    FControl: TORTreeNode;
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
    property Control: TORTreeNode read FControl write FControl;
    property DefaultObject: IAccessible read GetDefaultObject write FDefaultObject;
    function ChildType( varChild: OleVariant): TChildType;
    class procedure WrapControl( Control: TORTreeNode);
    class procedure UnwrapControl( Control: TORTreeNode);
  end;

implementation

uses uComServ, uAccessAPI, Windows, SysUtils, Variants;

var
  UserIsRestricted: boolean = False;

function TAccessibleTreeNode.accHitTest(xLeft, yTop: Integer): OleVariant;
begin
  result := Null;
  if Assigned(DefaultObject) then
    result := DefaultObject.accHitTest(xLeft,yTop);
end;

function TAccessibleTreeNode.accNavigate(navDir: Integer;
  varStart: OleVariant): OleVariant;
begin
  result := Null;
  if Assigned(DefaultObject) then
    result := DefaultObject.accNavigate(navDir, varStart);
end;

function TAccessibleTreeNode.Get_accChild(varChild: OleVariant): IDispatch;
begin
  result := nil;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accChild(varChild);
end;

function TAccessibleTreeNode.Get_accChildCount: Integer;
begin
  result := 0;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accChildCount;
end;

function TAccessibleTreeNode.Get_accDefaultAction(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accDefaultAction(varChild);
end;

function TAccessibleTreeNode.Get_accDescription(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accDescription(varChild);
end;

function TAccessibleTreeNode.Get_accFocus: OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accFocus;
end;

function TAccessibleTreeNode.Get_accHelp(varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accHelp(varChild);
end;

function TAccessibleTreeNode.Get_accHelpTopic(out pszHelpFile: WideString;
  varChild: OleVariant): Integer;
begin
  result := 0;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accHelpTopic(pszHelpFile, varChild);
end;

function TAccessibleTreeNode.Get_accKeyboardShortcut(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accKeyboardShortcut(varChild);
end;

function TAccessibleTreeNode.Get_accName(varChild: OleVariant): WideString;
begin
  if ChildType(varChild) = ctNoChild then
  begin
    result := '';
    if Assigned(FControl) then
      result := FControl.Caption;
  end
  else if Assigned(DefaultObject) then
    result := DefaultObject.Get_accName(varChild);
end;

function TAccessibleTreeNode.Get_accParent: IDispatch;
begin
  result := nil;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accParent;
end;

function TAccessibleTreeNode.Get_accRole(varChild: OleVariant): OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accRole(varChild);
end;

function TAccessibleTreeNode.Get_accSelection: OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accSelection;
end;

function TAccessibleTreeNode.Get_accState(varChild: OleVariant): OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accState(varChild);
end;

function TAccessibleTreeNode.Get_accValue(varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accValue(varChild);
end;

procedure TAccessibleTreeNode.accDoDefaultAction(varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accDoDefaultAction(varChild);
end;

procedure TAccessibleTreeNode.accLocation(out pxLeft, pyTop, pcxWidth,
  pcyHeight: Integer; varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accLocation(pxLeft,pyTop,pcxWidth,pcyHeight,VarChild);
end;

procedure TAccessibleTreeNode.accSelect(flagsSelect: Integer;
  varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accSelect(flagsSelect, varChild);
end;

procedure TAccessibleTreeNode.Set_accName(varChild: OleVariant;
  const pszName: WideString);
begin
  if Assigned(DefaultObject) then
    DefaultObject.Set_accName(varChild, pszName);
end;

procedure TAccessibleTreeNode.Set_accValue(varChild: OleVariant;
  const pszValue: WideString);
begin
  if Assigned(DefaultObject) then
    DefaultObject.Set_accValue(varChild, pszValue);
end;

function TAccessibleTreeNode.GetDefaultObject: IAccessible;
begin
  if Assigned(FControl) and not FDefaultObjectLoaded then begin
    FDefaultObject := uAccessAPI.GetDefaultObject(FControl);
    FDefaultObjectLoaded := True;
  end;
  Result := FDefaultObject;
end;

function TAccessibleTreeNode.ChildType(varChild: OleVariant): TChildType;
begin
  if (VarType(varChild) <> varInteger) then
    result := ctInvalid
  else if varChild = CHILDID_SELF then
    result := ctNoChild
  else
    result := ctChild;
end;

class procedure TAccessibleTreeNode.WrapControl(Control: TORTreeNode);
var
  AccessibleTreeNode: TAccessibleTreeNode;
  {Using Accessible here is probably just interface reference count paranoia}
  Accessible: IAccessible;
begin
  if not UserIsRestricted then
  begin
    AccessibleTreeNode := TAccessibleTreeNode.Create;
    Accessible := AccessibleTreeNode;
    AccessibleTreeNode.Control := Control;
    Control.MakeAccessible(Accessible);
  end;
end;

class procedure TAccessibleTreeNode.UnwrapControl(Control: TORTreeNode);
begin
  if not UserIsRestricted then
    Control.MakeAccessible(nil);
end;

initialization
  try
    TAutoObjectFactory.Create(ComServer, TAccessibleTreeNode, Class_AccessibleTreeNode,
      ciMultiInstance, tmApartment);
  except
    {Let the poor restricted users pass!}
    UserIsRestricted := True;
  end;
      
end.
