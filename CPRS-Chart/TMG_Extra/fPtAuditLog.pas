unit fPtAuditLog;
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
  Dialogs, StdCtrls, Buttons, ExtCtrls, ORDtTm, SortStringGrid, ORNet, uCore, Math, ORFn,
  Grids, Printers;

type
  //TAuditMode = (tamPerPatient, tamPerProvider);
  TfrmPtAuditLog = class(TForm)
    dbStartDate: TORDateBox;
    dbEndDate: TORDateBox;
    lblStartDT: TLabel;
    Label1: TLabel;
    btnDone: TBitBtn;
    Panel1: TPanel;
    btnGetDetails: TBitBtn;
    btnPrint: TBitBtn;
    procedure btnPrintClick(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure btnGetDetailsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dbEndDateChange(Sender: TObject);
    procedure dbStartDateChange(Sender: TObject);
  private
    { Private declarations }
   AuditResults: TStringList;
   GridAuditDetail      : TSortStringGrid;
   LastRowSelected : integer;
   procedure UpdateAuditLog;
   procedure GridAuditDetailSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  public
    { Public declarations }
    //Mode : TAuditMode;
  end;


implementation

uses fPtAuditDetail;
{$R *.dfm}

procedure TfrmPtAuditLog.dbStartDateChange;
begin
  UpdateAuditLog;
end;

procedure TfrmPtAuditLog.FormCreate(Sender: TObject);
begin
  AuditResults := TStringList.Create;
  //Mode :=  tamPerPatient; //Default mode is Per Patient
  GridAuditDetail := TSortStringGrid.Create(Self);
  GridAuditDetail.Parent := Panel1;
  GridAuditDetail.Anchors := [akLeft,akTop,akRight,akBottom];
  GridAuditDetail.Left := 0;
  GridAuditDetail.Top := 0;
  GridAuditDetail.Width := Panel1.width;
  GridAuditDetail.Height := Panel1.Height;
  GridAuditDetail.Options := [goRowSelect,goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing];
  GridAuditDetail.ColCount := 3;
  GridAuditDetail.FixedCols := 0;
  GridAuditDetail.FixedRows := 1;
  Panel1Resize(Self);
  GridAuditDetail.Cells[0,0] := 'Date Time';
  GridAuditDetail.Cells[1,0] := 'User';
  GridAuditDetail.Cells[2,0] := 'Action';
  GridAuditDetail.OnSelectCell := GridAuditDetailSelectCell;
end;

procedure TfrmPtAuditLog.FormDestroy(Sender: TObject);
begin
  GridAuditDetail.Free;
  AuditResults.Free;
end;

procedure TfrmPtAuditLog.FormShow(Sender: TObject);
begin
  dbStartDate.Text := DateToStr(Date)+'@00:00:00';
  //dbEndDate.Text := 'NOW';
end;

procedure TfrmPtAuditLog.GridAuditDetailSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  btnGetDetails.enabled := True;
  LastRowSelected := ARow;
end;

procedure TfrmPtAuditLog.Panel1Resize(Sender: TObject);
const  COL_1_W = 150;
begin
  GridAuditDetail.ColWidths[0] := COL_1_W;
  GridAuditDetail.ColWidths[1] := Floor((Panel1.Width-COL_1_W)/2);
  GridAuditDetail.ColWidths[2] := Floor((Panel1.Width-COL_1_W)/2);
end;

procedure TfrmPtAuditLog.btnGetDetailsClick(Sender: TObject);
var Index: integer;
    value: string;
    frmPtAuditDetail: TfrmPtAuditDetail;
begin
  Index := integer(GridAuditDetail.Objects[0,LastRowSelected]);
  //ShowMessage('Last row selected: '+inttostr(LastRowSelected)+#10#13 +'Data is :'+AuditResults[Index]);
  value := Piece(AuditResults[index],'^',1);
  frmPtAuditDetail := TfrmPtAuditDetail.Create(self);
  if frmPtAuditDetail.Initialize(value) then begin
    frmPtAuditDetail.ShowModal;
  end;
  FreeAndNil(frmPtAuditDetail);
end;

procedure TfrmPtAuditLog.btnPrintClick(Sender: TObject);
var  printDialog: TPrintDialog;
     i,page,startPage,endPage : integer;
     xpos,ypos: integer;
begin
     printDialog := TPrintDialog.Create(self);
     if printDialog.Execute then begin
       Printer.Orientation := poPortrait;
       Printer.Title := self.Caption;
       Printer.BeginDoc;
       page := 1;   //start page
       Printer.Canvas.Textout(200,160,Printer.Title);
       xpos := 50;
       ypos := 320;

       //while (not Printer.Aborted) and Printer.Printing do begin
         for i := 0 to GridAuditDetail.RowCount-1 do begin
           Printer.Canvas.Textout(xpos,ypos,GridAuditDetail.cells[0,i]);
           Printer.Canvas.Textout(xpos+1600,ypos,GridAuditDetail.cells[1,i]);
           Printer.Canvas.Textout(xpos+2800,ypos,GridAuditDetail.cells[2,i]);
           YPos := YPos+8+Printer.Canvas.TextHeight(GridAuditDetail.cells[0,i]);
         end;
       //end;
       Printer.EndDoc; //Begin the actual print
     end;
end;

procedure TfrmPtAuditLog.dbEndDateChange(Sender: TObject);
begin
  UpdateAuditLog;
end;

procedure TfrmPtAuditLog.UpdateAuditLog;
var i:integer;
begin
  if not dbStartDate.IsValid then begin
    ShowMessage('Begin date is invalid');
    exit;
  end;
    if not dbEndDate.IsValid then begin
    ShowMessage('End date is invalid');
    exit;
  end;
  AuditResults.Clear;
  btnGetDetails.enabled := False;
  LastRowSelected := 0;
  for i := 1 to GridAuditDetail.RowCount - 1 do
     GridAuditDetail.Rows[i].Clear;
  tCallV(AuditResults, 'TMG CPRS GET AUDIT PER PATIENT', [Patient.DFN,'1',dbStartDate.FMDateTime ,dbEndDate.FMDatetime]);
  if Piece(AuditResults[0],'^',1)='-1' then begin
     ShowMessage('Error getting audit log:'+#10#13+Piece(AuditResults[0],'^',2));
     exit;
  end;
  GridAuditDetail.RowCount := AuditResults.Count;
  for i := 1 to AuditResults.Count - 1 do begin
    GridAuditDetail.Objects[0,i] :=pointer(i);
    GridAuditDetail.Cells[0,i] := Piece(AuditResults[i],'^',3);
    GridAuditDetail.Cells[1,i] := Piece(AuditResults[i],'^',2);
    GridAuditDetail.Cells[2,i] := Piece(AuditResults[i],'^',4);
  end;


end;

end.

