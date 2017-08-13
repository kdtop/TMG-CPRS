unit fPtAuditDetail;
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
  Dialogs, ExtCtrls, StdCtrls, SortStringGrid, ORFn, math, ORNet, Grids;

type
  TfrmPtAuditDetail = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    procedure Panel1Resize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    GridAuditItemDetail: TSortStringGrid;
  public
    { Public declarations }
    function Initialize(LookupDetail: string): boolean;
  end;


implementation

{$R *.dfm}

procedure TfrmPtAuditDetail.FormCreate(Sender: TObject);

begin
  GridAuditItemDetail := TSortStringGrid.Create(Self);
  GridAuditItemDetail.Parent := Panel1;
  GridAuditItemDetail.Anchors := [akLeft,akTop,akRight,akBottom];
  GridAuditItemDetail.Left := 0;
  GridAuditItemDetail.Top := 0;
  GridAuditItemDetail.Width := Panel1.width;
  GridAuditItemDetail.Height := Panel1.Height;
  GridAuditItemDetail.Options := [goRowSelect,goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing];
  GridAuditItemDetail.ColCount := 3;
  GridAuditItemDetail.FixedCols := 0;
  GridAuditItemDetail.FixedRows := 1;
  Panel1Resize(self);
  GridAuditItemDetail.Cells[0,0] := 'Field #';
  GridAuditItemDetail.Cells[1,0] := 'Field Name';
  GridAuditItemDetail.Cells[2,0] := 'Value';
end;

procedure TfrmPtAuditDetail.FormDestroy(Sender: TObject);
begin
  GridAuditItemDetail.free;
end;

procedure TfrmPtAuditDetail.Panel1Resize(Sender: TObject);
const  COL_1_W = 70;
begin
  GridAuditItemDetail.ColWidths[0] := COL_1_W;
  GridAuditItemDetail.ColWidths[1] := Floor((Panel1.Width-COL_1_W)/2);
  GridAuditItemDetail.ColWidths[2] := Floor((Panel1.Width-COL_1_W)/2);
end;

function TfrmPtAuditDetail.Initialize(LookupDetail: string): boolean;
var
   i : integer;
   DetailResults: TStringList;
begin
  DetailResults := TStringList.Create;
  tCallV(DetailResults, 'TMG CPRS GET AUDIT DETAIL', [LookupDetail]);
  if piece(DetailResults[0],'^',1)='-1' then begin
    ShowMessage('Error getting details: '+piece(DetailResults[0],'^',2));
    Result := false;
    exit;
  end else begin
    GridAuditItemDetail.RowCount := DetailResults.Count;
    for i := 1 to DetailResults.Count - 1 do begin
      GridAuditItemDetail.Cells[0,i] := Piece(DetailResults[i],'^',1);
      GridAuditItemDetail.Cells[1,i] := Piece(DetailResults[i],'^',2);
      GridAuditItemDetail.Cells[2,i] := Piece(DetailResults[i],'^',3);
    end;
    Result := True;
  end;
  DetailResults.Free;
end;

end.

