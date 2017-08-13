unit SetSelU;
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
  Dialogs, StdCtrls, Buttons,
  ORNet, ORFn, ComCtrls, ToolWin, Grids, ORCtrls;

type
  TSetSelForm = class(TForm)
    ComboBox: TComboBox;
    CancelBtn: TBitBtn;
    OKBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function GetSelValue : string;       
  public
    { Public declarations }
    procedure PrepForm(setDef : string; InitialValue : string);
    property SelectedValue : string read GetSelValue;
  end;

//var
//  SetSelForm: TSetSelForm;

implementation
{$R *.dfm}

const
  DEL_ENTRY = '<none/delete>';

  procedure TSetSelForm.PrepForm(setDef : string; InitialValue : string);
  var  oneOption : string;
  begin
    ComboBox.Items.Clear;
    ComboBox.Items.Add(DEL_ENTRY);
    ComboBox.Text := '';
    oneOption := 'x';
    while (setDef <> '') and (oneOption <> '') do begin
      oneOption := piece(setDef,';',1);
      setDef := pieces(setDef,';',2,32);
      oneOption := piece(oneOption,':',2);
      if oneOption <> '' then begin
        ComboBox.Items.Add(oneOption);
      end;
    end;
    if ComboBox.Items.Count > 0 then begin
//      ComboBox.Text := ComboBox.Items[0];
      if ComboBox.Items.IndexOf(InitialValue) > -1 then begin
        ComboBox.SelText := InitialValue;
      end else begin
        ComboBox.SelText := ComboBox.Items[0];
      end;
    end else begin
      ComboBox.Text := '(none defined)';
    end;
  end;

  function TSetSelForm.GetSelValue : string;
  begin
    Result := Self.ComboBox.Text;
    if Result = DEL_ENTRY then begin
      Result := '';
    end;
  end;

  procedure TSetSelForm.FormShow(Sender: TObject);
    var mousePos : TPoint;
  begin
    GetCursorPos(mousePos);
    Top := mousePos.Y - 39;
    Left := mousePos.X - 15;
    if Left + Width > Screen.DesktopWidth then begin
      Left := Screen.DesktopWidth - Width;
    end;
    ComboBox.SetFocus;
  end;

end.

