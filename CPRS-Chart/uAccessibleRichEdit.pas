//kt -- Modified with SourceScanner on 8/7/2007
unit uAccessibleRichEdit;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, CPRSChart_TLB, StdVcl, Accessibility_TLB,
  ORCtrls, Variants;

type
  TChildType = (ctInvalid, ctNoChild, ctChild);

  TAccessibleRichEdit = class(TAutoObject, IAccessibleRichEdit, IAccessible)
  private
    FDefaultObject: IAccessible;
    FDefaultObjectLoaded: boolean;
    FControl: TCaptionRichEdit;
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
    property Control: TCaptionRichEdit read FControl write FControl;
    function ChildType( varChild: OleVariant): TChildType;
    class procedure WrapControl( Control: TCaptionRichEdit);
    class procedure UnwrapControl( Control: TCaptionRichEdit);
  public {but it wouldn't be in a perfect world}
    function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HResult; override;
  end;

implementation

uses uComServ, SysUtils, uAccessAPI, Windows, Controls;

var
  UserIsRestricted: boolean = False;

function TAccessibleRichEdit.accHitTest(xLeft,
  yTop: Integer): OleVariant;
begin
  result := Null;
  if Assigned(DefaultObject) then
    result := DefaultObject.accHitTest(xLeft,yTop);
end;

function TAccessibleRichEdit.accNavigate(navDir: Integer;
  varStart: OleVariant): OleVariant;
begin
  result := Null;
  if Assigned(DefaultObject) then
    result := DefaultObject.accNavigate(navDir, varStart);
end;

function TAccessibleRichEdit.Get_accChild(
  varChild: OleVariant): IDispatch;
begin
  result := nil;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accChild(varChild);
end;

function TAccessibleRichEdit.Get_accChildCount: Integer;
begin
  result := 0;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accChildCount;
end;

function TAccessibleRichEdit.Get_accDefaultAction(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accDefaultAction(varChild);
end;

function TAccessibleRichEdit.Get_accDescription(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accDescription(varChild);
end;

function TAccessibleRichEdit.Get_accFocus: OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accFocus;
end;

function TAccessibleRichEdit.Get_accHelp(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accHelp(varChild);
end;

function TAccessibleRichEdit.Get_accHelpTopic(
  out pszHelpFile: WideString; varChild: OleVariant): Integer;
begin
  result := 0;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accHelpTopic(pszHelpFile, varChild);
end;

function TAccessibleRichEdit.Get_accKeyboardShortcut(
  varChild: OleVariant): WideString;
begin
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accKeyboardShortcut(varChild);
end;

function TAccessibleRichEdit.Get_accName(
  varChild: OleVariant): WideString;
begin
  result := '';
  if ChildType(varChild) = ctNoChild then
  begin
    if Assigned(FControl) then
      result := FControl.Caption;
  end
  else if Assigned(DefaultObject) then
    result := DefaultObject.Get_accName(varChild);
end;

function TAccessibleRichEdit.Get_accParent: IDispatch;
begin
  result := nil;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accParent;
end;

function TAccessibleRichEdit.Get_accRole(
  varChild: OleVariant): OleVariant;
begin
  if ChildType(varChild) = ctNoChild then
    result := ROLE_SYSTEM_TEXT
  else
    result := ROLE_SYSTEM_CLIENT;
end;

function TAccessibleRichEdit.Get_accSelection: OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accSelection;
end;

function TAccessibleRichEdit.Get_accState(
  varChild: OleVariant): OleVariant;
begin
  result := NULL;
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accState(varChild);
end;

function TAccessibleRichEdit.Get_accValue(
  varChild: OleVariant): WideString;
begin
  //This is the crux of the issue: RichEdit controls return what should be the
  //Value as the Name.
  result := '';
  if Assigned(DefaultObject) then
    result := DefaultObject.Get_accName(varChild);
end;

procedure TAccessibleRichEdit.accDoDefaultAction(varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accDoDefaultAction(varChild);
end;

procedure TAccessibleRichEdit.accLocation(out pxLeft, pyTop, pcxWidth,
  pcyHeight: Integer; varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accLocation(pxLeft,pyTop,pcxWidth,pcyHeight,VarChild);
end;

procedure TAccessibleRichEdit.accSelect(flagsSelect: Integer;
  varChild: OleVariant);
begin
  if Assigned(DefaultObject) then
    DefaultObject.accSelect(flagsSelect, varChild);
end;

procedure TAccessibleRichEdit.Set_accName(varChild: OleVariant;
  const pszName: WideString);
begin
  if Assigned(DefaultObject) then
    DefaultObject.Set_accName(varChild, pszName);
end;

procedure TAccessibleRichEdit.Set_accValue(varChild: OleVariant;
  const pszValue: WideString);
begin
  if Assigned(DefaultObject) then
    DefaultObject.Set_accValue(varChild, pszValue);
end;

function TAccessibleRichEdit.ChildType(varChild: OleVariant): TChildType;
begin
  if VarType(varChild) <> varInteger then
    result := ctInvalid
  else if varChild = CHILDID_SELF then
    result := ctNoChild
  else
    result := ctChild;
end;

function TAccessibleRichEdit.GetDefaultObject: IAccessible;
begin
  if Assigned(FControl) and not FDefaultObjectLoaded then begin
    FDefaultObject := uAccessAPI.GetDefaultObject(FControl);
    FDefaultObjectLoaded := True;
  end;
  Result := FDefaultObject;
end;

function TAccessibleRichEdit.SafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HResult;
begin
  if (ExceptObject is EOleSysError) then
    result := EOleSysError(ExceptObject).ErrorCode
  else
    result := inherited SafeCallException(ExceptObject, ExceptAddr);
end;

class procedure TAccessibleRichEdit.UnwrapControl(
  Control: TCaptionRichEdit);
begin
  if not UserIsRestricted then
    Control.MakeAccessible(nil);
end;

class procedure TAccessibleRichEdit.WrapControl(
  Control: TCaptionRichEdit);
var
  AccessibleRichEdit: TAccessibleRichEdit;
  {Using Accessible here is probably just interface reference count paranoia}
  Accessible: IAccessible;
begin
  if not UserIsRestricted then
  begin
    AccessibleRichEdit := TAccessibleRichEdit.Create;
    Accessible := AccessibleRichEdit;
    AccessibleRichEdit.Control := Control;
    Control.MakeAccessible(Accessible);
  end;
end;

initialization
  try
    TAutoObjectFactory.Create(ComServer, TAccessibleRichEdit, Class_AccessibleRichEdit,
      ciMultiInstance, tmApartment);
  except
    {Let the poor restricted users pass!}
    UserIsRestricted := True;
  end;
end.

