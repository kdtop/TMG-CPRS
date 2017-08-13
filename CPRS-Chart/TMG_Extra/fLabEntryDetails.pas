unit fLabEntryDetails;
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
  Dialogs, Buttons, StdCtrls, ORCtrls, ExtCtrls, ComCtrls, ORNet, ORFn, rCore;

type
  TfrmLabEntryDetails = class(TForm)
    cboProvider: TORComboBox;
    lblProvider: TLabel;
    cboLocation: TORComboBox;
    lblLocation: TLabel;
    btnCancel: TBitBtn;
    btnApply: TBitBtn;
    lblSpecimen: TLabel;
    cboSpecimen: TORComboBox;
    dtpDTTaken: TDateTimePicker;
    lblDTTaken: TLabel;
    Label1: TLabel;
    procedure dtpControlExit(Sender: TObject);
    procedure cboKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dtpDTPickerKeyPress(Sender: TObject; var Key: Char);
    procedure dtpDTCompletedExit(Sender: TObject);
    procedure cboSpecimenNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure FormCreate(Sender: TObject);
    procedure cboLocationNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboProviderNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GetDetailsNarrative(Lines : TStrings);
    procedure GetDetailsEncoded(Lines : TStrings);
    function SelectedSpecimen : string;
  end;

//var
//  frmLabEntryDetails: TfrmLabEntryDetails;  //not auto-created

function SubSetOfPersons(const StartFrom: string; Direction: Integer): TStrings;
function SubSetOfLocations(const StartFrom: string; Direction: Integer): TStrings;
function SubSetOfSpecimens(const StartFrom: string; Direction: Integer): TStrings;


implementation

{$R *.dfm}

Uses uCore;

function SubSetOfPersons(const StartFrom: string; Direction: Integer): TStrings;
//Copied in from CPRS
begin
  CallV('ORWU NEWPERS', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function SubSetOfLocations(const StartFrom: string; Direction: Integer): TStrings;
//Copied in from CPRS
begin
  CallV('TMG CPRS GET INSTIT LIST', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function SubSetOfSpecimens(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('TMG CPRS GET SPEC LIST', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;


procedure TfrmLabEntryDetails.cboLocationNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfLocations(StartFrom, Direction));
end;

procedure TfrmLabEntryDetails.cboKeyDown(Sender: TObject; var Key: Word;
                                         Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    Key := VK_TAB;
  end;
end;



procedure TfrmLabEntryDetails.cboProviderNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmLabEntryDetails.cboSpecimenNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfSpecimens(StartFrom, Direction));
end;

procedure TfrmLabEntryDetails.dtpDTCompletedExit(Sender: TObject);
begin
  dtpControlExit(Sender);
end;


procedure TfrmLabEntryDetails.dtpControlExit(Sender: TObject);
var OKToContinue : boolean;
begin
  OKToContinue := (cboProvider.ItemIEN > 0) and
                  (cboLocation.ItemIEN > 0) {and
                  (cboSpecimen.ItemIEN > 0)};
  btnApply.Enabled := OKToContinue;
end;



procedure TfrmLabEntryDetails.dtpDTPickerKeyPress(Sender: TObject;
                                                     var Key: Char);
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

procedure TfrmLabEntryDetails.FormCreate(Sender: TObject);
begin
  cboProvider.InitLongList('A');
  cboLocation.InitLongList('A');
  cboSpecimen.InitLongList('SERUM');
end;

procedure TfrmLabEntryDetails.FormShow(Sender: TObject);
begin
  dtpDTTaken.DateTime := Now;
  dtpDTTaken.SetFocus;
end;

function TfrmLabEntryDetails.SelectedSpecimen : string;
var Index : integer;
begin
  Result := '';
  Index := cboSpecimen.ItemIndex;
  if Index >= 0 then begin
    Result := piece(cboSpecimen.Items[Index],'^',3);
  end;
end;

procedure TfrmLabEntryDetails.GetDetailsNarrative(Lines : TStrings);
begin
  Lines.Clear;
  Lines.Add(lblDTTaken.Caption + ': ' + DateToStr(dtpDTTaken.DateTime));
  //Lines.Add(lblDTCompleted.Caption + ': ' + DateToStr(dtpDTCompleted.DateTime));
  Lines.Add(lblProvider.Caption + ': ' + cboProvider.Text);
  Lines.Add(lblLocation.Caption + ': ' + cboLocation.Text);
  //Lines.Add(lblSpecimen.Caption + ': ' + cboSpecimen.Text);
end;

procedure TfrmLabEntryDetails.GetDetailsEncoded(Lines : TStrings);
  function Selected(CBO : TORComboBox) : string;
  //Return 'IEN^Name'
  var Idx : integer;
  begin
    Result := '';
    Idx := CBO.ItemIndex;
    if Idx < 0 then exit;
    Result := CBO.Items.Strings[idx];
  end;

var TempFMDT : TFMDateTime;
begin
  Lines.Add('<METADATA>');
  //TempFMDT := DateTimeToFMDateTime(dtpDTTaken.DateTime);
  //Lines.Add('DT_TAKEN = ' + FloatToStr(TempFMDT));
  TempFMDT := DateTimeToFMDateTime(dtpDTTaken.DateTime);
  Lines.Add('DT_COMPLETED = ' + FloatToStr(TempFMDT));
  Lines.Add('PROVIDER = ' + Selected(cboProvider));
  Lines.Add('LOCATION = ' + Selected(cboLocation));
  //Lines.Add('SPECIMEN = ' + Selected(cboSpecimen));
  Lines.Add('PATIENT = ' + uCore.Patient.DFN);
end;

end.
