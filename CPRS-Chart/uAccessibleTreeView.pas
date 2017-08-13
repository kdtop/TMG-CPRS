unit uaccessibleTreeView;

interface

uses
  ComObj, ActiveX, CPRSChart_TLB, StdVcl, ORCtrls, Accessibility_TLB, Variants;

type
  TChildType = (ctInvalid, ctNoChild, ctChild);

  TAccessibleTreeView = class(TAutoObject, IaccessibleTreeView, IAccessible)
  private
    FDefaultObject: IAccessible;
    FDefaultObjectLoaded: boolean;
    FControl: TORTreeView;
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
    property Control: TORtreeView read FControl write FControl;
    property DefaultObject: IAccessible read GetDefaultObject write FDefaultObject;
    function ChildType( varChild: OleVariant): TChildType;
    class procedure WrapControl( Control: TORTreeView);
    class procedure UnwrapControl( Control: TORTreeView);
  end;

implementation

uses uComServ, uAccessAPI, Windows, CommCtrl
     //, DKLang  //kt
     ;

var
  UserIsRestricted: boolean = False;

function TAccessibleTreeView.accHitTest(xLeft, yTop: Integer): OleVariant;
begin
  result := Null;
  if Assigned(DefaultObject) then
    result := DefaultObject.accHitTest(xLeft,yTop);
end;

function TAccessibleTreeView.accNavigate(navDir: Integer;
  varStart: OleVariant): OleVariant;
begin
  result := Null;
  if Assigned(DefaultObject) then
    result := DefaultObject.accNavigate(navDir, varStart);
end;

function TAccessibleTreeView.Get_accChild(varChild: OleVariant): IDispatch;
begin
  result := nil;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accChild(varChild);
end;

function TAccessibleTreeView.Get_accChildCount: Integer;
begin
  result := 0;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accChildCount;
end;

function TAccessibleTreeView.Get_accDefaultAction(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accDefaultAction(varChild);
end;

function TAccessibleTreeView.Get_accDescription(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accDescription(varChild);
end;

function TAccessibleTreeView.Get_accFocus: OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accFocus;
end;

function TAccessibleTreeView.Get_accHelp(varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accHelp(varChild);
end;

function TAccessibleTreeView.Get_accHelpTopic(out pszHelpFile: WideString;
  varChild: OleVariant): Integer;
begin
  result := 0;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accHelpTopic(pszHelpFile, varChild);
end;

function TAccessibleTreeView.Get_accKeyboardShortcut(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accKeyboardShortcut(varChild);
end;

function TAccessibleTreeView.Get_accName(varChild: OleVariant): WideString;
var
  TheNode:TORTreeNode;
begin
  if ChildType(varChild) = ctChild then
  begin
    if Assigned(FControl) then
    begin
      TheNode := FControl.Items.GetNode(HTREEITEM(integer(varChild))) as TORTreeNode;
      result := TheNode.Accessible.Get_accName(CHILDID_SELF);
    end
    else
    result := '[No Data]';  
  end
  else if Assigned(DefaultObject) then
    result := DefaultObject.Get_accName(varChild);
end;

function TAccessibleTreeView.Get_accParent: IDispatch;
begin
  result := nil;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accParent;
end;

function TAccessibleTreeView.Get_accRole(varChild: OleVariant): OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accRole(varChild);
end;

function TAccessibleTreeView.Get_accSelection: OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accSelection;
end;

function TAccessibleTreeView.Get_accState(varChild: OleVariant): OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accState(varChild);
end;

function TAccessibleTreeView.Get_accValue(varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accValue(varChild);
end;

procedure TAccessibleTreeView.accDoDefaultAction(varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accDoDefaultAction(varChild);
end;

procedure TAccessibleTreeView.accLocation(out pxLeft, pyTop, pcxWidth,
  pcyHeight: Integer; varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accLocation(pxLeft,pyTop,pcxWidth,pcyHeight,VarChild);
end;

procedure TAccessibleTreeView.accSelect(flagsSelect: Integer;
  varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accSelect(flagsSelect, varChild);
end;

procedure TAccessibleTreeView.Set_accName(varChild: OleVariant;
  const pszName: WideString);
begin
  if Assigned(DefaultObject) then
    DefaultObject.Set_accName(varChild, pszName);
end;

procedure TAccessibleTreeView.Set_accValue(varChild: OleVariant;
  const pszValue: WideString);
begin
  if Assigned(DefaultObject) then
    DefaultObject.Set_accValue(varChild, pszValue);
end;

function TAccessibleTreeView.GetDefaultObject: IAccessible;
begin
  if Assigned(FControl) and not FDefaultObjectLoaded then begin
    FDefaultObject := uAccessAPI.GetDefaultObject(FControl);
    FDefaultObjectLoaded := True;
  end;
  Result := FDefaultObject;
end;

function TAccessibleTreeView.ChildType(varChild: OleVariant): TChildType;
begin
  if (VarType(varChild) <> varInteger) then
    result := ctInvalid
  else if varChild = CHILDID_SELF then
    result := ctNoChild
  else
    result := ctChild;
end;

class procedure TAccessibleTreeView.WrapControl(Control: TORTreeView);
var
  AccessibleTreeView: TAccessibleTreeView;
  {Using Accessible here is probably just interface reference count paranoia}
  Accessible: IAccessible;
begin
  if not UserIsRestricted then
  begin
    AccessibleTreeView := TAccessibleTreeView.Create;
    Accessible := AccessibleTreeView;
    AccessibleTreeView.Control := Control;
    Control.MakeAccessible(Accessible);
  end;
end;

class procedure TAccessibleTreeView.UnwrapControl(Control: TORTreeView);
begin
  if not UserIsRestricted then
    Control.MakeAccessible(nil);
end;

initialization
  try
    TAutoObjectFactory.Create(ComServer, TAccessibleTreeView, Class_accessibleTreeView,
      ciMultiInstance, tmApartment);
  except
    {Let the poor restricted users pass!}
    UserIsRestricted := True;
  end;

end.
