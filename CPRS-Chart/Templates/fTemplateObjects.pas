unit fTemplateObjects;
 (*
 NOTE: The original version of this file may be obtained freely from the VA.

 This modified version of the file is Copyright 6/23/2015 Kevin S. Toppenberg, MD
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORCtrls, StdCtrls, ExtCtrls, ComCtrls, ORFn, dShared, uTemplates, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmTemplateObjects = class(TfrmBase508Form)
    cboObjects: TORComboBox;
    pnlBottom: TPanel;
    btnCancel: TButton;
    btnInsert: TButton;
    btnRefresh: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure cboObjectsDblClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Fre: TRichEdit;
    FAutoLongLines: TNotifyEvent;
    procedure InsertObject;
    procedure Setre(const Value: TRichEdit);
  public
    InsertingIntoCarePlan : boolean;  //kt 9/11  -- Note: is set to FALSE with every Form.OnShow;
    procedure UpdateStatus;
    property re: TRichEdit read Fre write Setre;
    property AutoLongLines: TNotifyEvent read FAutoLongLines write FAutoLongLines;
  end;

implementation

{$R *.DFM}
  uses uCarePlan;  //kt

procedure TfrmTemplateObjects.FormShow(Sender: TObject);
begin
  ResizeAnchoredFormToFont(self);
  //ResizeAnchoredFormToFont doesn't work right on the button positions for some reason.
  btnCancel.Left := pnlBottom.ClientWidth - btnCancel.Width;
  btnInsert.Left := btnCancel.Left - btnInsert.Width - 5;
  btnRefresh.Left := btnInsert.Left - btnRefresh.Width - 5;
  cboObjects.SelectAll;
  cboObjects.SetFocus;
  InsertingIntoCarePlan := false; //kt
end;

procedure TfrmTemplateObjects.btnInsertClick(Sender: TObject);
begin
  InsertObject;
end;

procedure TfrmTemplateObjects.InsertObject;
var
  cnt: integer;
  s : string; //kt 5/6/11
begin
  if(not Fre.ReadOnly) and (cboObjects.ItemIndex >= 0) then
  begin
    cnt := Fre.Lines.Count;
    //kt 9/11 -- begin mod ----
    s := '|' + Piece2(cboObjects.Items[cboObjects.ItemIndex],U,3) + '|';
    if InsertingIntoCarePlan then s := CP_RESULT_TAG_OPEN + s + CP_RESULT_TAG_CLOSE;
    Fre.SelText := s;
    //kt /911 -- end mod ---
    //kt 9/11 original -->  Fre.SelText := '|'+Piece(cboObjects.Items[cboObjects.ItemIndex],U,3)+'|';
    if(assigned(FAutoLongLines) and (cnt <> FRe.Lines.Count)) then
      FAutoLongLines(Self);
  end;
end;

procedure TfrmTemplateObjects.cboObjectsDblClick(Sender: TObject);
begin
  InsertObject;
end;

procedure TfrmTemplateObjects.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTemplateObjects.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TfrmTemplateObjects.Setre(const Value: TRichEdit);
begin
  Fre := Value;
  UpdateStatus;
end;

procedure TfrmTemplateObjects.UpdateStatus;
begin
  btnInsert.Enabled := (not re.ReadOnly);
end;

procedure TfrmTemplateObjects.btnRefreshClick(Sender: TObject);
var
  i: integer;
  DoIt: boolean;
begin
  cboObjects.Clear;
  dmodShared.RefreshObject := true;
  dmodShared.LoadTIUObjects;
  //---------- CQ #8665 - RV ----------------
  DoIt := TRUE;
  UpdatePersonalObjects;
  if uPersonalObjects.Count > 0 then
  begin
    DoIt := FALSE;
    for i := 0 to dmodShared.TIUObjects.Count-1 do
      if uPersonalObjects.IndexOf(Piece(dmodShared.TIUObjects[i],U,2)) >= 0 then
        cboObjects.Items.Add(dmodShared.TIUObjects[i]);
  end;
  if DoIt then
  //---------- end CQ #8665 ------------------
    cboObjects.Items.Assign(dmodShared.TIUObjects);
end;

end.

