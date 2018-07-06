unit fMemoEdit;
//kt 9/11 Added entire unit
//This is a simple TMemo editor
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
  Dialogs, StdCtrls, Buttons, ExtDlgs;

type
  TfrmMemoEdit = class(TForm)
    memEdit: TMemo;
    btnDone: TBitBtn;
    lblMessage: TLabel;
    btnSelectAll: TButton;
    btnSave: TButton;
    SaveTextFileDialog: TSaveTextFileDialog;
    procedure btnSaveClick(Sender: TObject);
    procedure memEditKeyPress(Sender: TObject; var Key: Char);
    procedure btnSelectAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  frmMemoEdit: TfrmMemoEdit;

implementation

{$R *.dfm}

procedure TfrmMemoEdit.btnSaveClick(Sender: TObject);
begin
  if SaveTextFileDialog.Execute then begin
    memEdit.Lines.SaveToFile(SaveTextFileDialog.FileName);
  end;
end;

procedure TfrmMemoEdit.btnSelectAllClick(Sender: TObject);
begin
  memEdit.SelectAll;
end;

procedure TfrmMemoEdit.memEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^A then begin
    (Sender as TMemo).SelectAll;
    Key := #0;
  end;
end;

end.

