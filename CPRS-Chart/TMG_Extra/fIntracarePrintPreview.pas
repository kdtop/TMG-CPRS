unit fIntracarePrintPreview;
//kt 9/11 added
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
  Dialogs, Spin, StdCtrls, Buttons, jpeg, ExtCtrls, ORCtrls, ORDtTm,
  Printers, uCore,ORFn, ComCtrls,ORNet;

type
  TfrmIntracarePrintPreview = class(TForm)
    Close: TButton;
    PaintBox1: TPaintBox;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  frmIntracarePrintPreview: TfrmIntracarePrintPreview;

implementation

uses rCore,rTIU,uConst,
      IniFiles // for IniFile
      , fImages, fIntracarePtLbl;

{$R *.dfm}

procedure TfrmIntracarePrintPreview.FormShow(Sender: TObject);
var
  YPos,XPos,tempXPos : integer;
  i,j,k,p : integer;
  Line1,Line2,Line3,Line4 : string;
  //barcodeWidth,barcodeHeight : integer;
  KeeneRPCResult: string;
  VitalRPCResult : TStringList;
  l : integer;
  Height,Weight,HeightTag,WeightTag: string;
  AdmDate: string;
  tempWidth: integer;

begin
  with PaintBox1 do begin
      canvas.brush.color := clRed;
      canvas.pen.color := clBlue;
      canvas.ellipse(20,20,120,120);
  end;
end;
{
   HeightTag := ' HT ';
   WeightTag := ' WT ';
   VitalRPCResult := TStringList.Create;



   //Make RPC Calls
   KeeneRPCResult := sCallV('TMG KEENE GET ACCOUNT NUMBERS', [Patient.DFN]);
   tCallV(VitalRPCResult, 'ORQQVI VITALS', [Patient.DFN]);

   //Extract height and weight
   for l := 0 to VitalRPCResult.Count-1 do begin
      if Piece(VitalRPCResult[l],'^',2) = 'HT' then Height := ' ' + frmIntracarePtAdmLbl.FormatHeight(Piece(Piece(VitalRPCResult[l],'^',5),' ',1)) + ' ';
      if Piece(VitalRPCResult[l],'^',2) = 'WT' then Weight := ' ' + inttostr(Round(strtofloat(Piece(Piece(VitalRPCResult[l],'^',5),' ',1)))) + ' ';
   end;

   //Extract admission date if exists, or tag with current date
   if Piece(KeeneRPCResult,'^',3) <> '' then begin
     AdmDate := FormatFMDateTimeStr('mm/dd/yy', Piece(KeeneRPCResult,'^',3));
   end else begin
     AdmDate := DateToStr(Date);
   end;

   //Create line texts
   Line1 := 'V'+Patient.ICN + '    ' +FormatFMDateTime('mm"-"dd"-"yyyy', Patient.DOB)+'   '+IntToStr(Patient.Age)+'   '+Patient.Sex;
   Line2 := Piece(Patient.Name,',',2) + ' ' + Piece(Patient.Name,',',1);
   Line3 := 'K'+ Piece(KeeneRPCResult,'^',2) + '-' + Piece(KeeneRPCResult,'^',1) + ' ';
   Line4 := Piece(frmIntracarePtAdmLbl.cmbPhysicians.Text,',',1); // + '   ' + AdmDate;
   //AdmDate to be added later


      YPos := 10;
      XPos := 10;

     //PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
           PaintBox1.canvas.Pen.Color := clBlack;
           PaintBox1.Canvas.Font.Name := 'Arial';

           PaintBox1.Canvas.Font.Size := 12;  //# point
           Canvas.TextOut(300,300,'Frigging Test Line');
           YPos := YPos+8+PaintBox1.Canvas.TextHeight(Line1);

           PaintBox1.Canvas.Font.Name := 'Arial';
           PaintBox1.Canvas.Font.Size := 10;  //# point
           PaintBox1.Canvas.TextOut(XPos,YPos,Line2);
           YPos := YPos+8+PaintBox1.Canvas.TextHeight(Line2);

           PaintBox1.Canvas.Font.Name := 'Arial';
           PaintBox1.Canvas.Font.Size := 10;  //# point
           PaintBox1.Canvas.TextOut(XPos,YPos,Line3);
           //Height&Weight Grid
           PaintBox1.Canvas.Pen.Style := psSolid;
           //Height Label
           tempXPos := XPos+8+PaintBox1.Canvas.TextWidth(Line3);
           PaintBox1.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+PaintBox1.Canvas.TextWidth(HeightTag),YPos+8+PaintBox1.Canvas.TextHeight(HeightTag));
           PaintBox1.Canvas.TextOut(tempXPos,YPos,HeightTag);
           //Height
           tempXPos := tempXPos+8+PaintBox1.Canvas.TextWidth(HeightTag);
           PaintBox1.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+PaintBox1.Canvas.TextWidth(Height),YPos+8+PaintBox1.Canvas.TextHeight(Height));
           PaintBox1.Canvas.TextOut(tempXPos,YPos,Height);
           //Weight Label
           tempXPos := tempXPos+8+PaintBox1.Canvas.TextWidth(Height);
           PaintBox1.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+PaintBox1.Canvas.TextWidth(WeightTag),YPos+8+PaintBox1.Canvas.TextHeight(WeightTag));
           PaintBox1.Canvas.TextOut(tempXPos,YPos,WeightTag);
           //Weight
           tempXPos := tempXPos+8+PaintBox1.Canvas.TextWidth(WeightTag);
           PaintBox1.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+PaintBox1.Canvas.TextWidth(Weight),YPos+8+PaintBox1.Canvas.TextHeight(Weight));
           PaintBox1.Canvas.TextOut(tempXPos,YPos,Weight);
           YPos := YPos+8+PaintBox1.Canvas.TextHeight(Line3);

           PaintBox1.Canvas.Font.Name := 'Arial';
           PaintBox1.Canvas.Font.Size := 12;  //# point
           PaintBox1.Canvas.TextOut(XPos,YPos,Line4);
           PaintBox1.Canvas.TextOut(XPos+1650-PaintBox1.Canvas.TextWidth(AdmDate)-380,YPos,AdmDate);  //Right Justify AdmDate
           YPos := YPos+170+PaintBox1.Canvas.TextHeight(Line4);

           //FPrinter.Canvas.Font.Name := 'Arial';
           //FPrinter.Canvas.Font.Size := 10;  //# point
           //FPrinter.Canvas.TextOut(XPos,YPos,Line5);
           //YPos := YPos+100+FPrinter.Canvas.TextHeight(Line5);

    VitalRPCResult.Free;

end;
  }
end.
