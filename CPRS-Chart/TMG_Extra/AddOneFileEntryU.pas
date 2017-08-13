unit AddOneFileEntryU;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Orfn, Ornet,
  uTMGGrid,
  Trpcb, Dialogs, StdCtrls, Buttons, Grids, SortStringGrid, ExtCtrls, uTMGTypes, rTMGRPCs;

type
  TAddOneFileEntry = class(TForm)
    Panel1: TPanel;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    AddFileEntryGrid: TSortStringGrid;
    procedure AddFileEntryGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure AddFileEntryGridClick(Sender: TObject);
    procedure AddFileEntryGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    //FFileNum : string;
    FGridInfo : TCompleteGridInfo; //Owned by GlobalsU.DataForGrid
    FChangesMade : boolean;
    PreviousGrid : TSortStringGrid;
    //GridInfo : TGridInfo;
    function GetChangesMade : boolean;
    function GetNameField : string;
  public
    { Public declarations }
    NewRecordName : string;
    procedure PrepForm(FileNum: string);
    property ChangesMade : boolean read GetChangesMade;
    constructor Create(AOwner: TComponent);
    destructor Destroy;
  end;

//var
//  AddOneFileEntry: TAddOneFileEntry;

implementation

uses FMErrorU {,MainU};

{$R *.dfm}


constructor TAddOneFileEntry.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  FGridInfo := TCompleteGridInfo.Create; //ownership will be transferred to GlobalsU.DataForGrid

end;

destructor TAddOneFileEntry.Destroy;
begin
  UnRegisterGridInfo(FGridInfo);
  //FGridInfo.Free;  <-- done in UnRegisterGridInfo

  Inherited Destroy;
end;

procedure TAddOneFileEntry.PrepForm(FileNum: string);
var
  //IENS  : string;
  BlankFileInfo : TStringList;

begin
  {
  AddGridInfo('AddFileEntry', AddFileEntryGrid, MainForm.CurrentFileEntry,
              nil, MainForm.GetRemDlgFilesInfoAndLoadIntoGrids, '',
              MainForm.btnRDlgApply, MainForm.btnRDlgRevert, MainForm.RemDlgIENSSelector);
  }
  //The following were derived from moving the AddGridInfo line here.
  //I am not sure why ApplyBtn,RevertBtn, and RecordSelector have the values they do...
  FGridInfo.Name := 'AddOneFileEntry';
  FGridInfo.Grid := AddFileEntryGrid;
  FGridInfo.FileNum := FileNum;
  FGridInfo.IENS := '+1,';
  //kt 12/18/13 commenting out 3 lines below.  See comment above
  {
  FGridInfo.RecordSelector := MainForm.RemDlgIENSSelector;
  FGridInfo.ApplyBtn := MainForm.btnRDlgApply;
  FGridInfo.RevertBtn := MainForm.btnRDlgRevert;
  }
  RegisterGridInfo(FGridInfo);  //FGridInfo becomes owned by GlobalsU.DataForGrid

  NewRecordName := '';
  //FFileNum := FileNum;
  Self.Caption := 'Add Entry to File # ' + FileNum;
  BlankFileInfo := TStringList.Create;
  //GridInfo := GetInfoObjectForGrid(AddFileEntryGrid);
  //IENS := '+1,';
  GetOneRecord(FileNum, FGridInfo.IENS, FGridInfo.Data, BlankFileInfo);
  //FGridInfo.IENS := IENS;
  //GridInfo.FileNum := FileNum;
  LoadAnyGrid(FGridInfo);  //load Basic or Advanced Grid
  //GridInfo.IENS := IENS;
  BlankFileInfo.Free;
end;


procedure TAddOneFileEntry.AddFileEntryGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  uTMGGrid.ExternalSelectGridCell(Sender,ACol,ARow,CanSelect);
end;

procedure TAddOneFileEntry.FormShow(Sender: TObject);
begin
  btnOk.Enabled := False;
  PreviousGrid := GetVisibleGrid;
  uTMGGrid.SetVisibleGridIdx(AddFileEntryGrid);
  FChangesMade := False;
end;

procedure TAddOneFileEntry.btnOkClick(Sender: TObject);
var
   ModalResult : TModalResult;
begin
   ModalResult := PostVisibleGrid;
   if ModalResult = mrOk then begin
     SetVisibleGridIdx(PreviousGrid);
     Self.ModalResult := mrOk;
     NewRecordName := GetNameField;
     FChangesMade := True;
   end;
end;

function TAddOneFileEntry.GetNameField : string;
var i :integer;
begin
  for i := 0 to AddFileEntryGrid.RowCount do begin
    if AddFileEntryGrid.Cells[0,i] = '.01' then begin
      Result := AddFileEntryGrid.Cells[2,i];
      break;
    end;
  end;
end;

procedure TAddOneFileEntry.AddFileEntryGridClick(Sender: TObject);
begin
  btnOk.Enabled := True;
end;

procedure TAddOneFileEntry.AddFileEntryGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  btnOk.Enabled := true;
end;

procedure TAddOneFileEntry.btnCancelClick(Sender: TObject);
var
  ModalResult : TModalResult;
begin
  if btnOk.enabled = True then begin
    ModalResult := PostVisibleGrid;
    if ModalResult = mrOK then begin
      SetVisibleGridIdx(PreviousGrid);
      NewRecordName := GetNameField;
    end;
  end;  
  exit;
end;

function TAddOneFileEntry.GetChangesMade : boolean;
begin
  Result := FChangesMade or FGridInfo.DisplayRefreshIndicated;
end;

end.
