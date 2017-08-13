unit fPtSelDemog;
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
  StdCtrls, ExtCtrls, ORCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmPtSelDemog = class(TfrmBase508Form)
    orapnlMain: TORAutoPanel;
    lblSSN: TStaticText;
    lblPtSSN: TStaticText;
    lblDOB: TStaticText;
    lblPtDOB: TStaticText;
    lblPtSex: TStaticText;
    lblPtVet: TStaticText;
    lblPtSC: TStaticText;
    lblLocation: TStaticText;
    lblPtRoomBed: TStaticText;
    lblPtLocation: TStaticText;
    lblRoomBed: TStaticText;
    lblPtName: TStaticText;
    lblPtHRN: TStaticText;
    Memo: TCaptionMemo;
    lblCombatVet: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FLastDFN: string;
    FOldWinProc :TWndMethod;
    procedure NewWinProc(var Message: TMessage);
  public
    procedure ClearIDInfo;
    procedure ShowDemog(ItemID: string);
    procedure ToggleMemo;
  end;

var
  frmPtSelDemog: TfrmPtSelDemog;

implementation

uses rCore, VA508AccessibilityRouter, uCombatVet
     , uCore  //agp wv add uCore for Hide Patient SSN
     ;

{$R *.DFM}

const
{ constants referencing the value of the tag property in components }
  TAG_HIDE     =  1;                             // labels to be hidden
  TAG_CLEAR    =  2;                             // labels to be cleared

procedure TfrmPtSelDemog.ClearIDInfo;
{ clears controls with patient ID info (controls have '2' in their Tag property }
var
  i: Integer;
begin
  FLastDFN := '';
  with orapnlMain do
  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i].Tag = TAG_HIDE then Controls[i].Visible := False;
    if Controls[i].Tag = TAG_CLEAR then with Controls[i] as TStaticText do Caption := '';
  end;
  Memo.Clear;
end;

procedure TfrmPtSelDemog.ShowDemog(ItemID: string);
{ gets a record of patient indentifying information from the server and displays it }
var
  PtRec: TPtIDInfo;
  i: Integer;
  CV : TCombatVet;
begin
  if ItemID = FLastDFN then Exit;
  Memo.Clear;
  FLastDFN := ItemID;
  PtRec := GetPtIDInfo(ItemID);
  with PtRec do
  begin
    Memo.Lines.Add(Name);
    //agp //kt prior --> Memo.Lines.Add(lblSSN.Caption + ' ' + SSN + '.');
    //agp wv begin change  //kt
    if hidePtSSN = true then Memo.Lines.Add(lblSSN.Caption + ' ' + '**HIDDEN**' + '.')
    else Memo.Lines.Add(lblSSN.Caption + ' ' + SSN + '.');
    //agp wb end change
    Memo.Lines.Add(lblDOB.Caption + ' ' + DOB + '.');
    if Sex <> '' then
      Memo.Lines.Add(Sex + '.');
    if Vet <> '' then
      Memo.Lines.Add(Vet + '.');
    if SCsts <> '' then
      Memo.Lines.Add(SCsts + '.');
    if Location <> '' then
      Memo.Lines.Add(lblLocation.Caption + ' ' + Location + '.');
    if RoomBed <> '' then
      Memo.Lines.Add(lblRoomBed.Caption + ' ' + RoomBed + '.');

    lblPtName.Caption     := Name;
    //agp //kt prior --> lblPtSSN.Caption      := SSN;
    //agp wv begin change
    if hidePtSSN = true then lblPtSSN.Caption := '**HIDDEN**'
    else lblPtSSN.Caption := SSN;
    //agp wb end change
    //kt 9/11 original --> lblPtDOB.Caption      := DOB;
    lblPtDOB.Caption      := DOB + ' (' + Age + ')';  //kt 9/11
    lblPtSex.Caption      := Sex {+ ', age ' + Age};
    lblPtSC.Caption       := SCSts;
    lblPtVet.Caption      := Vet;
    lblPtLocation.Caption := Location;
    lblPtRoomBed.Caption  := RoomBed;
    lblPtName.Color := DueColor;        //kt 10/23/14
    lblPtName.ShowHint := True;         //kt 10/23/14
    lblPtName.ParentShowHint := False;  //kt 10/23/14
    lblPtName.Hint := DueHint;          //kt 10/23/14
    //VWPT
    if HRN <> '' then lblPtHRN.Caption      := 'HRN: '+HRN
    else    lblPtHRN.Caption :=''  ;
  end;
  with orapnlMain do for i := 0 to ControlCount - 1 do
    if Controls[i].Tag = TAG_HIDE then Controls[i].Visible := True;
  if lblPtLocation.Caption = '' then
    lblLocation.Hide
  else
    lblLocation.Show;
  if lblPtRoomBed.Caption = ''  then
    lblRoomBed.Hide
  else
    lblRoomBed.Show;
  CV := TCombatVet.Create(ItemID);
  if CV.IsEligible then begin
    lblCombatVet.Caption := 'CV ' + CV.ExpirationDate + ' ' + CV.OEF_OIF;
    Memo.Lines.Add(lblCombatVet.Caption);
  end else
    lblCombatVet.Caption := '';
  CV.Free;
  Memo.SelectAll;
end;

procedure TfrmPtSelDemog.ToggleMemo;
begin
  if Memo.Visible then
  begin
    Memo.Hide;
  end
  else
  begin
    Memo.Show;
    Memo.BringToFront;
  end;
end;

procedure TfrmPtSelDemog.FormCreate(Sender: TObject);
begin
  FOldWinProc := orapnlMain.WindowProc;
  orapnlMain.WindowProc := NewWinProc;
end;

procedure TfrmPtSelDemog.NewWinProc(var Message: TMessage);
const
  Gap = 4;
  MaxFont = 10;
  var uHeight:integer;


begin
  if(assigned(FOldWinProc)) then FOldWinProc(Message);
  if(Message.Msg = WM_Size) then
  begin
    if(lblPtSSN.Left < (lblSSN.Left+lblSSN.Width+Gap)) then
      lblPtSSN.Left := (lblSSN.Left+lblSSN.Width+Gap);
    if(lblPtDOB.Left < (lblDOB.Left+lblDOB.Width+Gap)) then
      lblPtDOB.Left := (lblDOB.Left+lblDOB.Width+Gap);
    if(lblPtSSN.Left < lblPtDOB.Left) then
      lblPtSSN.Left := lblPtDOB.Left
    else
      lblPtDOB.Left := lblPtSSN.Left;

    if(lblPtLocation.Left < (lblLocation.Left+lblLocation.Width+Gap)) then
      lblPtLocation.Left := (lblLocation.Left+lblLocation.Width+Gap);
    if(lblPtRoomBed.Left < (lblRoomBed.Left+lblRoomBed.Width+Gap)) then
      lblPtRoomBed.Left := (lblRoomBed.Left+lblRoomBed.Width+Gap);
    if(lblPtLocation.Left < lblPtRoomBed.Left) then
      lblPtLocation.Left := lblPtRoomBed.Left
    else
      lblPtRoomBed.Left := lblPtLocation.Left;
  end;
  if frmPtSelDemog.Canvas.Font.Size > MaxFont then
  begin
    uHeight         := frmPtSelDemog.Canvas.TextHeight(lblPtSSN.Caption)-2;
    lblPtSSN.Top    := (lblPtName.Top + uHeight);
    lblSSN.Top      := lblPtSSN.Top;
    lblPtDOB.Height := uHeight;
    lblPtDOB.Top    := (lblPtSSn.Top + uHeight);
    lblDOB.Top      := lblPtDOB.Top;
    lblPtSex.Height :=  uHeight;
    lblPtSex.Top    := (lblPtDOB.Top + uHeight);
    lblPtVet.Height :=  uHeight;
    lblPtVet.Top    := (lblPtSex.Top + uHeight);
    lblPtSC.Height  := uHeight;
    lblPtSC.Top     :=  lblPtVet.Top;
    lblLocation.Height := uHeight;
    lblLocation.Top := ( lblPtVet.Top + uHeight);
    lblPtLocation.Top := lblLocation.Top;
    lblRoomBed.Height := uHeight;
    lblRoomBed.Top    :=(lblLocation.Top + uHeight)+ 2;
    lblPtRoomBed.Height := uHeight;
    lblPtRoomBed.Top  := lblRoomBed.Top ;
    lblCombatVet.Top := (lblRoomBed.Top + uHeight) + 2;
  end;
end;

procedure TfrmPtSelDemog.FormDestroy(Sender: TObject);
begin
  orapnlMain.WindowProc := FOldWinProc;
end;

procedure TfrmPtSelDemog.FormShow(Sender: TObject);
begin
  inherited;
  lblCombatVet.Caption := '';
end;

initialization
  SpecifyFormIsNotADialog(TfrmPtSelDemog);

end.
