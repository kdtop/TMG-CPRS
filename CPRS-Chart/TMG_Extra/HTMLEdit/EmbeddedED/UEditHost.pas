{ ******************************************** }
{       UEditHost ver 1.0 (Oct. 10, 2003)      }
{                                              }
{       For Delphi 4, 5 and 6                  }
{                                              }
{       Copyright (C) 1999-2003, Kurt Senfer.  }
{       All Rights Reserved.                   }
{                                              }
{       Support@ks.helpware.net                }
{                                              }
{       Documentation and updated versions:    }
{                                              }
{       http://KS.helpware.net                 }
{                                              }
{ ******************************************** }
{
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}


unit UEditHost;

//this unit implements a combined IHTMLEditHost & IHTMLEditHost2 interface.

interface

uses
  windows, Classes, 
  //kt mshtml_tlb, 
  MSHTML_EWB,
  EmbeddedED;

type
  tagRECT = TRect;  //kt
  
  //this is only declared if IE 6 is imported to mshtml_tlb
  IHTMLEditHost2 = interface(IHTMLEditHost)
    ['{3050F848-98B5-11CF-BB82-00AA00BDCE0D}']
    function  PreDrag: HResult; stdcall;
  end;

  TEditHost = class(TInterfacedObject, IHTMLEditHost, IHTMLEditHost2)
  private
    function SnapRect(const pIElement: IHTMLElement; var prcNew: tagRECT; eHandle: _ELEMENT_CORNER): HResult; stdcall;
    function PreDrag: HResult; stdcall;

  public
    FSnapEnabled: Boolean;
    FGridX: Integer;
    FGridY: Integer;
    //kt FExtSnapRect: TSnapRect;
    FOnPreDrag: TNotifyEventEx;
    constructor Create(Ovner: TEmbeddedED);
    procedure BeforeDestruction; override;
    function QueryService(const rsid, iid: TGuid; out Obj): HResult;
  end;

implementation
  uses ActiveX, ComObj, IeConst;

const
  SID_SHTMLEditHost: TGUID = '{3050F6A0-98B5-11CF-BB82-00AA00BDCE0B}';

//------------------------------------------------------------------------------
function TEditHost.QueryService(const rsid, iid: TGuid; out Obj): HResult;
const
  IID_IHTMLEditHost2: TGUID = '{3050F848-98B5-11CF-BB82-00AA00BDCE0D}';
begin
  //asm int 3 end; //trap
  //we only come heir if TEmbeddedED is queryed for SID_SHTMLEDitHost

  //MSHTML asks either for a IHTMLEditHost or a IHTMLEditHost2
  if IsEqualGUID(iid, IID_IHTMLEditHost2)
     then IUnknown(obj) := self as IHTMLEditHost2  //new in IE 6
     else IUnknown(obj) := self as IHTMLEditHost;

  Result := S_OK;
end;
//------------------------------------------------------------------------------
function TEditHost.PreDrag: HResult; stdcall;
var
  Cancel: Boolean;
begin
  //asm int 3 end; //trap

  result := S_OK;

  if assigned(FOnPreDrag)
     then begin
        FOnPreDrag(Self, Cancel);
        if not Cancel
           then result := S_FALSE;
     end;
end;

//------------------------------------------------------------------------------
function TEditHost.SnapRect(const pIElement: IHTMLElement; var prcNew: tagRECT; eHandle: _ELEMENT_CORNER): HResult; stdcall;

  //-------------------------------------------------------------
  function GetNextAviablePoint(aPoint, GridSpacing, Offset: integer): Integer;
  begin
     result := ((aPoint + (GridSpacing div 2)) div GridSpacing) * GridSpacing + Offset;
  end;
  //-------------------------------------------------------------
var
  Width : Integer;
  Height: Integer;
  aElement: IHTMLElement2;

  P: tagPOINT;
  Pr: tagRECT;
  aDisplays: IDisplayServices;
  aevent: IHTMLEventObj;
begin
  //asm int 3 end; //trap

  { //kt
  If assigned(FExtSnapRect)
     then begin
        FExtSnapRect(Self, pIElement, prcNew, eHandle, Result);
        exit;
     end;
  }

  //dont snap if not enabled or the Control key is down
  if (not FSnapEnabled) or (GetAsyncKeyState(VK_CONTROL) < 0)
     then begin
        result := S_FALSE; //do default handling
        exit;
     end;

  result := S_OK;

  case eHandle of
     ELEMENT_CORNER_NONE:          // Code for moving the element
        begin
           Width := prcNew.right - prcNew.left;
           Height := prcNew.bottom - prcNew.top;

           prcNew.top := GetNextAviablePoint(prcNew.top, FGridY, -2);
           prcNew.left := GetNextAviablePoint(prcNew.left, FGridX, -2);
           prcNew.bottom := prcNew.top + Height;
           prcNew.right := prcNew.left + Width;
        end;

     ELEMENT_CORNER_TOP:           // Code for resizing the element
           prcNew.top := GetNextAviablePoint(prcNew.top, FGridY, -2);

     ELEMENT_CORNER_LEFT:          // Code for resizing the element
           prcNew.left := GetNextAviablePoint(prcNew.left, FGridX, -2);

     ELEMENT_CORNER_BOTTOM:        // Code for resizing the element
           prcNew.bottom := GetNextAviablePoint(prcNew.bottom, FGridY, 1);

     ELEMENT_CORNER_RIGHT:         // Code for resizing the element
           prcNew.right := GetNextAviablePoint(prcNew.right, FGridX, 1);

     ELEMENT_CORNER_TOPLEFT:       // Code for resizing the element
        begin
           prcNew.top := GetNextAviablePoint(prcNew.top, FGridY, -2);
           prcNew.left := GetNextAviablePoint(prcNew.left, FGridX, -2);
        end;

     ELEMENT_CORNER_TOPRIGHT:      // Code for resizing the element
        begin
           prcNew.top := GetNextAviablePoint(prcNew.top, FGridY, -2);
           prcNew.right := GetNextAviablePoint(prcNew.right, FGridX, 1);
        end;

     ELEMENT_CORNER_BOTTOMLEFT:    // Code for resizing the element
        begin
           prcNew.left := GetNextAviablePoint(prcNew.left, FGridX, -2);
           prcNew.bottom := GetNextAviablePoint(prcNew.bottom, FGridY, 1);
        end;

     ELEMENT_CORNER_BOTTOMRIGHT:   // Code for resizing the element
        begin
           prcNew.bottom := GetNextAviablePoint(prcNew.bottom, FGridY, 1);
           prcNew.right := GetNextAviablePoint(prcNew.right, FGridX, 1);
        end;
   end;
end;


//------------------------------------------------------------------------------
constructor TEditHost.Create(Ovner: TEmbeddedED);
begin
  Inherited Create;
  _AddRef;  //dont die automatically
end;
//------------------------------------------------------------------------------
procedure TEditHost.BeforeDestruction;
begin
  FRefCount := 0;
end;
//------------------------------------------------------------------------------
end.
 
