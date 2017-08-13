unit fLabDateEdit;
//kt
 (*
 Copyright 6/23/2015 Kevin S. Toppenberg, MD
 --------------------------------------------------------------------

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 == Alternatively, at user's choice, GPL license below may be used ===

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may view details of the GNU General Public License at this URL:
 http://www.gnu.org/licenses/
 *)



interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TfrmLabDateEdit = class(TForm)
    lblDTCompleted: TLabel;
    dtpDate: TDateTimePicker;
    btnCancel: TBitBtn;
    btnApply: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure dtpDTPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitDate(DateStr : string);
  end;

//var
//  frmLabDateEdit: TfrmLabDateEdit;  //not-autocreated

implementation

{$R *.dfm}

procedure TfrmLabDateEdit.dtpDTPress(Sender: TObject;var Key: Char);
  //method to call dropdown
  procedure SimClick(Obj : TWinControl);
  var x,y,lparam : integer;
  begin
    x := Obj.Width - 10;
    y := Obj.Height div 2;
    lParam := y*$10000 + x;
    PostMessage(Obj.Handle, WM_LBUTTONDOWN, 1, lParam);
    PostMessage(Obj.Handle, WM_LBUTTONUP, 1, lParam);
  end;

begin
  if Key = char(VK_SPACE) then begin
    SimClick(Sender as TWinControl);
    Key := char(0);
  end else if Key = char(VK_RETURN) then begin
     Key := char(VK_TAB);
  end;
end;

procedure TfrmLabDateEdit.FormShow(Sender: TObject);
var mousePos : TPoint;
begin
  GetCursorPos(mousePos);
  Top := mousePos.Y - Self.Height div 2;
  Left := mousePos.X - Self.Width div 2;
  if Left + Width > Screen.DesktopWidth then begin
    Left := Screen.DesktopWidth - Width;
  end;
  dtpDate.SetFocus;
end;

procedure TfrmLabDateEdit.InitDate(DateStr : string);
begin
  if DateStr ='' then DateStr := '1/1/2010';
  dtpDate.Date := StrToDate(DateStr);
end;


end.
