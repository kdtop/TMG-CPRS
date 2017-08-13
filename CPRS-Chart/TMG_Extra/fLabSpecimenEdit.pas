unit fLabSpecimenEdit;
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
  Dialogs, StdCtrls, Buttons, ORCtrls, ORFn;

type
  TfrmSpecimenEdit = class(TForm)
    lblSpecimen: TLabel;
    cboSpecimen: TORComboBox;
    btnCancel: TBitBtn;
    btnApply: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure cboSpecimenNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Initialize(Str : string; IEN : int64);
    function SelectedSpecimen : string;
    function SelectedIEN : int64;
  end;

//var
//  frmSpecimenEdit: TfrmSpecimenEdit;  //not auto-created

implementation

{$R *.dfm}

uses
  fLabEntryDetails;

procedure TfrmSpecimenEdit.Initialize(Str : string; IEN : int64);
begin
  cboSpecimen.InitLongList(Str);
  cboSpecimen.SelectByIEN(IEN);
end;

function TfrmSpecimenEdit.SelectedSpecimen : string;
var Index : integer;
begin
  Result := '';
  Index := cboSpecimen.ItemIndex;
  if Index >= 0 then begin
    Result := piece(cboSpecimen.Items[Index],'^',3);
  end;
end;

function TfrmSpecimenEdit.SelectedIEN : int64;
begin
  Result := 0;
  if cboSpecimen.ItemIEN > 0 then begin
    Result := cboSpecimen.ItemIEN;
  end;
end;

procedure TfrmSpecimenEdit.cboSpecimenNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfSpecimens(StartFrom, Direction));
end;

procedure TfrmSpecimenEdit.FormShow(Sender: TObject);
var mousePos : TPoint;
begin
  GetCursorPos(mousePos);
  Top := mousePos.Y - Self.Height div 2;
  Left := mousePos.X - Self.Width div 2;
  if Left + Width > Screen.DesktopWidth then begin
    Left := Screen.DesktopWidth - Width;
  end;
  cboSpecimen.SetFocus;
end;

end.
