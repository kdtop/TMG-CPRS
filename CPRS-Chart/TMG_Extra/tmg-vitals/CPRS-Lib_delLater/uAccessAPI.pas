unit uAccessAPI;


interface

uses
  Accessibility_TLB,
  Controls,
  ComCtrls,
  Windows;

function GetDefaultObject( Control: TWinControl): IAccessible; overload;
function GetDefaultObject( Control: TTreeNode): IAccessible; overload;
function GetLResult( wParam: integer; MyInterface: IAccessible): integer;

const
  ROLE_SYSTEM_TITLEBAR = $1;
  ROLE_SYSTEM_MENUBAR = $2;
  ROLE_SYSTEM_SCROLLBAR = $3;
  ROLE_SYSTEM_GRIP = $4;
  ROLE_SYSTEM_SOUND = $5;
  ROLE_SYSTEM_CURSOR = $6;
  ROLE_SYSTEM_CARET = $7;
  ROLE_SYSTEM_ALERT = $8;
  ROLE_SYSTEM_WINDOW = $9;
  ROLE_SYSTEM_CLIENT = $a;
  ROLE_SYSTEM_MENUPOPUP = $b;
  ROLE_SYSTEM_MENUITEM = $c;
  ROLE_SYSTEM_TOOLTIP = $d;
  ROLE_SYSTEM_APPLICATION = $e;
  ROLE_SYSTEM_DOCUMENT = $f;
  ROLE_SYSTEM_PANE = $10;
  ROLE_SYSTEM_CHART = $11;
  ROLE_SYSTEM_DIALOG = $12;
  ROLE_SYSTEM_BORDER = $13;
  ROLE_SYSTEM_GROUPING = $14;
  ROLE_SYSTEM_SEPARATOR = $15;
  ROLE_SYSTEM_TOOLBAR = $16;
  ROLE_SYSTEM_STATUSBAR = $17;
  ROLE_SYSTEM_TABLE = $18;
  ROLE_SYSTEM_COLUMNHEADER = $19;
  ROLE_SYSTEM_ROWHEADER = $1a;
  ROLE_SYSTEM_COLUMN = $1b;
  ROLE_SYSTEM_ROW = $1c;
  ROLE_SYSTEM_CELL = $1d;
  ROLE_SYSTEM_LINK = $1e;
  ROLE_SYSTEM_HELPBALLOON = $1f;
  ROLE_SYSTEM_CHARACTER = $20;
  ROLE_SYSTEM_LIST = $21;
  ROLE_SYSTEM_LISTITEM = $22;
  ROLE_SYSTEM_OUTLINE = $23;
  ROLE_SYSTEM_OUTLINEITEM = $24;
  ROLE_SYSTEM_PAGETAB = $25;
  ROLE_SYSTEM_PROPERTYPAGE = $26;
  ROLE_SYSTEM_INDICATOR = $27;
  ROLE_SYSTEM_GRAPHIC = $28;
  ROLE_SYSTEM_STATICTEXT = $29;
  ROLE_SYSTEM_TEXT = $2a;
  ROLE_SYSTEM_PUSHBUTTON = $2b;
  ROLE_SYSTEM_CHECKBUTTON = $2c;
  ROLE_SYSTEM_RADIOBUTTON = $2d;
  ROLE_SYSTEM_COMBOBOX = $2e;
  ROLE_SYSTEM_DROPLIST = $2f;
  ROLE_SYSTEM_PROGRESSBAR = $30;
  ROLE_SYSTEM_DIAL = $31;
  ROLE_SYSTEM_HOTKEYFIELD = $32;
  ROLE_SYSTEM_SLIDER = $33;
  ROLE_SYSTEM_SPINBUTTON = $34;
  ROLE_SYSTEM_DIAGRAM = $35;
  ROLE_SYSTEM_ANIMATION = $36;
  ROLE_SYSTEM_EQUATION = $37;
  ROLE_SYSTEM_BUTTONDROPDOWN = $38;
  ROLE_SYSTEM_BUTTONMENU = $39;
  ROLE_SYSTEM_BUTTONDROPDOWNGRID = $3a;
  ROLE_SYSTEM_WHITESPACE = $3b;
  ROLE_SYSTEM_PAGETABLIST = $3c;
  ROLE_SYSTEM_CLOCK = $3d;


  NAVDIR_MIN = 0;
  NAVDIR_UP = 1;
  NAVDIR_DOWN = 2;
  NAVDIR_LEFT = 3;
  NAVDIR_RIGHT = 4;
  NAVDIR_NEXT = 5;
  NAVDIR_PREVIOUS = 6;
  NAVDIR_FIRSTCHILD = 7;
  NAVDIR_LASTCHILD = 8;
  NAVDIR_MAX = 9;

implementation

uses
  Classes;

type
  TCreateStdAccessibleObject = function(hwnd: HWND; idObject: DWORD; const riid: TGUID; var Accessible: IAccessible): integer; stdcall;
  TLresultFromObject = function( const riid: TGUID; wParam: integer; Accessible: Pointer): integer; stdcall;

  PhysicalInterfaceReference = record
    P1: pointer;
    P2: pointer;
  end;

  PPhysicalInterfaceReference = ^PhysicalInterfaceReference;
  
var
  CreateStdAccessibleObject: TCreateStdAccessibleObject;
  LresultFromObject: TLresultFromObject;
var

  OleAccHandle: THandle;

function GetDefaultObject( Control: TWinControl): IAccessible;
begin
  if Assigned(CreateStdAccessibleObject) then
  begin
    if CreateStdAccessibleObject(Control.Handle, OBJID_CLIENT, IID_IAccessible, Result) <> S_OK then
      result := nil;
  end
  else
    result := nil;
end;

function GetDefaultObject( Control: TTreeNode): IAccessible;
begin
  if Assigned(CreateStdAccessibleObject) then
  begin
    if CreateStdAccessibleObject(Control.Handle, OBJID_CLIENT, IID_IAccessible, Result) <> S_OK then
      result := nil;
  end
  else
    result := nil;
end;

function GetLResult( wParam: integer; MyInterface: IAccessible): integer;
begin
  if Assigned(LresultFromObject) then
  begin
    result := LresultFromObject(IID_IAccessible, wParam, PPhysicalInterfaceReference(@MyInterface)^.P1); // Increments ref count
  end
  else
    result := E_NOINTERFACE;
end;


initialization
  OleAccHandle := LoadLibrary('OLEACC.DLL');
  if OleAccHandle <> 0 then
  begin
    @CreateStdAccessibleObject := GetProcAddress(OleAccHandle, 'CreateStdAccessibleObject');
    @LresultFromObject := GetProcAddress(OleAccHandle, 'LresultFromObject');
  end
  else
  begin
    @CreateStdAccessibleObject := nil;
    @LresultFromObject := nil;
  end;

finalization
  if OleAccHandle <> 0 then
    FreeLibrary(OleAccHandle);

end.

