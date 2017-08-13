unit fIntracarePtLbl;
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
  Dialogs, Spin, StdCtrls, Buttons, jpeg, ExtCtrls, ORCtrls, ORDtTm, StrUtils,
  Printers, uCore,ORFn, ComCtrls,ORNet;

type
  TfrmIntracarePtAdmLbl = class(TForm)
    Label1: TLabel;
    cmbPrinter: TComboBox;
    Edit1: TEdit;
    Label2: TLabel;
    UpDown1: TUpDown;
    btnOK: TButton;
    btnCancel: TButton;
    Label3: TLabel;
    cmbPhysicians: TComboBox;
    btnPreview: TButton;
    CLOSE: TTimer;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure btnPreviewClick(Sender: TObject);
    procedure CLOSETimer(Sender: TObject);
  private
    { Private declarations }
    FPrinter : TPrinter;
    KeeneRPCResult: string;
    CloseForm : boolean;
    procedure SetupPreview(ACanvas : TCanvas);
  public
    { Public declarations }
    function FormatHeight(Height: string): string;
  end;

//var
//  frmIntracarePtAdmLbl: TfrmIntracarePtAdmLbl;

implementation

{$R *.dfm}

  uses rCore,rTIU,uConst,
        IniFiles // for IniFile
        , fImages, fIntracarePrintPreview;


  function TfrmIntracarePtAdmLbl.FormatHeight(Height: string): string;
  var
     intHeight: integer;
     intTemp : variant;
  begin
     intHeight := strtoint(Height);
     intTemp := intHeight Mod 12;
     if intTemp < 10 then Result := '-0' + inttostr(intTemp)
     else Result := '-' + inttostr(intHeight Mod 12);
     intTemp := intHeight / 12;
     intTemp := Piece(intTemp,'.',1);
     Result := inttostr(intTemp) + Result;
  end;


  procedure TfrmIntracarePtAdmLbl.btnOKClick(Sender: TObject);
  var
    YPos,XPos : integer;
    ICNChecksum : string;
    i,j,k,p : integer;
    Line1,Line2,Line3,Line4 : string;
    //barcodeWidth,barcodeHeight : integer;
    VitalRPCResult : TStringList;
    l : integer;
    Height,Weight,HeightTag,WeightTag,Race: string;
    AdmDate: string;
    //tempWidth: integer;

  begin
    HeightTag := ' HT ';
    WeightTag := ' WT ';
    VitalRPCResult := TStringList.Create;
    p := Printer.Printers.IndexOf(cmbPrinter.Text);
    FPrinter := TPrinter.Create;
    //FPrinter.PrinterIndex := cmbPrinter.ItemIndex;
    FPrinter.PrinterIndex := p;
    FPrinter.Orientation := poPortrait;
    FPrinter.Title := 'Patient Label -- ' + Patient.DFN;

    //Make RPC Calls
    ICNChecksum := sCallV('TMG KEENE ICN CHECKSUM', [Patient.DFN]);
    KeeneRPCResult := sCallV('TMG KEENE GET ACCOUNT NUMBERS', [Patient.DFN]);
    tCallV(VitalRPCResult, 'ORQQVI VITALS', [Patient.DFN]);

    //Extract height and weight
    for l := 0 to VitalRPCResult.Count-1 do begin
      if Piece(VitalRPCResult[l],'^',2) = 'HT' then Height := ' ' + FormatHeight(Piece(Piece(VitalRPCResult[l],'^',5),' ',1)) + ' ';
      if Piece(VitalRPCResult[l],'^',2) = 'WT' then Weight := ' ' + inttostr(Round(strtofloat(Piece(Piece(VitalRPCResult[l],'^',5),' ',1)))) + ' ';
    end;

    //Extract admission date if exists, or tag with current date
    if Piece(KeeneRPCResult,'^',3) <> '' then begin
     AdmDate := FormatFMDateTimeStr('mm/dd/yy', Piece(KeeneRPCResult,'^',3));
    end else begin
     AdmDate := DateToStr(Date);
    end;

    Race := sCallV('TMG GET RACE ABBREVIATION', [Patient.DFN]);

    //Create line texts
    //Line1 := 'K'+ Piece(KeeneRPCResult,'^',2) + '-' + Piece(KeeneRPCResult,'^',1)+'  '+FormatFMDateTime('mm"-"dd"-"yyyy', Patient.DOB)+'   '+IntToStr(Patient.Age)+'   '+Patient.Sex;
    {ORIGINAL LAYOUT FOR INTRACARELine1 := Piece(KeeneRPCResult,'^',1) + '  '+FormatFMDateTime('mm"-"dd"-"yyyy', Patient.DOB)+'   '+IntToStr(Patient.Age)+'   '+Patient.Sex;
    Line2 := Piece(Patient.Name,',',2) + ' ' + Piece(Patient.Name,',',1);
    if LeftStr(Patient.ICN,5) = '50000' then Line3 := Piece2(Patient.ICN,'50000',2)+'V'+ICNChecksum+ ' '
    else Line3 := Patient.ICN+'V'+ICNChecksum+ ' ';
    Line4 := Piece(cmbPhysicians.Text,',',1); // + '   ' + AdmDate;}
    //AdmDate to be added later

    Line1 := Piece(Patient.Name,',',1) + ',' + Piece(Patient.Name,',',2);
    Line2 := Race + ' ' + Patient.Sex + ' ' + FormatFMDateTime('mm"-"dd"-"yyyy', Patient.DOB) + ' ' + Patient.DFN + '-' + Patient.ICN+ICNChecksum;
    Line3 := 'ACCT# ' + Piece(KeeneRPCResult,'^',1);
    Line4 := 'Dr ' + Piece(cmbPhysicians.Text,',',1) + ' Admit ' + AdmDate;

    for i:=1 to strtoint(edit1.text) do begin
      YPos := 320;
      XPos := 50;
      try
        FPrinter.BeginDoc;
        for j:=1 to 3 do begin
          for k:=1 to 10 do begin
            FPrinter.Canvas.Font.Name := 'Arial';
            FPrinter.Canvas.Font.Size := 11;  //# point
            FPrinter.Canvas.TextOut(XPos,YPos,Line1);
            YPos := YPos+8+FPrinter.Canvas.TextHeight(Line1);

            FPrinter.Canvas.Font.Name := 'Arial';
            FPrinter.Canvas.Font.Size := 10;  //# point
            FPrinter.Canvas.TextOut(XPos,YPos,Line2);
            YPos := YPos+8+FPrinter.Canvas.TextHeight(Line2);

            FPrinter.Canvas.Font.Name := 'Arial';
            FPrinter.Canvas.Font.Size := 10;  //# point
            FPrinter.Canvas.TextOut(XPos,YPos,Line3);

            {INTRACARE HEIGHT/WEIGHT
            //Height&Weight Grid
            FPrinter.Canvas.Pen.Style := psSolid;
            //Height Label
            tempXPos := XPos+8+FPrinter.Canvas.TextWidth(Line3);
            FPrinter.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+FPrinter.Canvas.TextWidth(HeightTag),YPos+8+FPrinter.Canvas.TextHeight(HeightTag));
            FPrinter.Canvas.TextOut(tempXPos,YPos,HeightTag);
            //Height
            tempXPos := tempXPos+8+FPrinter.Canvas.TextWidth(HeightTag);
            FPrinter.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+FPrinter.Canvas.TextWidth(Height),YPos+8+FPrinter.Canvas.TextHeight(Height));
            FPrinter.Canvas.TextOut(tempXPos,YPos,Height);
            //Weight Label
            tempXPos := tempXPos+8+FPrinter.Canvas.TextWidth(Height);
            FPrinter.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+FPrinter.Canvas.TextWidth(WeightTag),YPos+8+FPrinter.Canvas.TextHeight(WeightTag));
            FPrinter.Canvas.TextOut(tempXPos,YPos,WeightTag);
            //Weight
            tempXPos := tempXPos+8+FPrinter.Canvas.TextWidth(WeightTag);
            FPrinter.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+FPrinter.Canvas.TextWidth(Weight),YPos+8+FPrinter.Canvas.TextHeight(Weight));
            FPrinter.Canvas.TextOut(tempXPos,YPos,Weight);
            }

            YPos := YPos+8+FPrinter.Canvas.TextHeight(Line3);

            FPrinter.Canvas.Font.Name := 'Arial';
            FPrinter.Canvas.Font.Size := 10;  //# point
            FPrinter.Canvas.TextOut(XPos,YPos,Line4);
            //Used for IntracareFPrinter.Canvas.TextOut(XPos+1650-FPrinter.Canvas.TextWidth(AdmDate)-240,YPos,AdmDate);  //Right Justify AdmDate
            YPos := YPos+190+FPrinter.Canvas.TextHeight(Line4);

            //FPrinter.Canvas.Font.Name := 'Arial';
            //FPrinter.Canvas.Font.Size := 10;  //# point
            //FPrinter.Canvas.TextOut(XPos,YPos,Line5);
            //YPos := YPos+100+FPrinter.Canvas.TextHeight(Line5);
          end;
          YPos := 320;
          XPos := XPos + 1650;
        end;
        //FPrinter.Canvas.Font.Name := 'Arial';
        //AdmPrinter.Canvas.Font.Size := 10;  //# point
      finally
      FPrinter.EndDoc;  //close and launch print job
      end;
    end;
    FPrinter.Free;
    VitalRPCResult.Free;
  end;


  procedure TfrmIntracarePtAdmLbl.FormShow(Sender: TObject);
  var
     i : integer;
     IniFile : TIniFile;
     UserList : TStringList;
     defPrinter : string;
     FPrinter : TPrinter;
     AdmissionTime : string;
     Attending : string;
     Response : integer;
     MessageText : string;
  begin
    UserList := TStringList.Create;
    IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
    MessageText := '';
    try
      defPrinter := IniFile.ReadString('Label Printing','Default Printer','');
    finally
      IniFile.Free;
    end;

    FPrinter := TPrinter.Create;
    cmbPrinter.Items.Clear  ;
    cmbPrinter.Items.Assign(FPrinter.Printers);
    FPrinter.Free;
    if cmbPrinter.Items.IndexOf(defPrinter) > -1 then begin
      cmbPrinter.ItemIndex := cmbPrinter.Items.IndexOf(defPrinter);
    end else if cmbPrinter.Items.Count > 0 then begin
      cmbPrinter.ItemIndex := 0;
    end;

    //RPC Calls
    AdmissionTime := Piece(sCallV('DGWPT SELECT', [Patient.DFN]),'^',10);
    Attending := Piece(sCallV('DGWPT1 PRCARE', [Patient.DFN]),'^',3);
    tCallV(UserList,'TMG KEENE PROVIDERS', ['', '1', 'PROVIDER']);
    KeeneRPCResult := sCallV('TMG KEENE GET ACCOUNT NUMBERS', [Patient.DFN]);

    for i:=0 to UserList.Count-1 do begin
      UserList.Strings[i] := Piece(UserList.Strings[i],'^',2);
    end;

    cmbPhysicians.Items.Assign(UserList);
    CloseForm := False;

    {
    if Piece(KeeneRPCResult,'^',1) = '' then MessageText := 'Missing Keane Account Number'+#13#10;
    if Piece(KeeneRPCResult,'^',2) = '' then MessageText := MessageText + 'Missing Keane Admission Number'+#13#10;

    if MessageText <> '' then begin
      MessageText := MessageText+#13#10+#13#10+'Labels cannot be printed until resolved.';
      messagedlg(MessageText,mtError,[mbOK],0);
      CloseForm := True;
    end;
    }

    if (AdmissionTime = '') and (CloseForm = False) then begin
      //Response := MessageDlg('WARNING! Patient: ' +Patient.Name + ' is not currently admitted.'+#13#10#13#10+'Go to Console-->Admit and admit the patient'+#13#10#13#10+'Proceed?',mtWarning,[mbYes,mbNo],0);
      Response := MessageDlg('WARNING! Patient: ' +Patient.Name + ' is not currently admitted.'+#13#10#13#10+'Proceed?',mtWarning,[mbYes,mbNo],0);
      if Response = mrNo then begin
        CloseForm := True;
        //frmIntracarePtAdmLbl.ModalResult := mrCancel;
      end;
    end;

    if Attending = '' then cmbPhysicians.ItemIndex := 0
    else cmbPhysicians.Text := Attending;

    UserList.Free;
    Close.Enabled := True;
  end;

  procedure TfrmIntracarePtAdmLbl.SetupPreview(ACanvas : TCanvas);
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
    HeightTag := ' HT ';
    WeightTag := ' WT ';
    VitalRPCResult := TStringList.Create;

    //Make RPC Calls
    KeeneRPCResult := sCallV('TMG KEENE GET ACCOUNT NUMBERS', [Patient.DFN]);
    tCallV(VitalRPCResult, 'ORQQVI VITALS', [Patient.DFN]);

    //Extract height and weight
    for l := 0 to VitalRPCResult.Count-1 do begin
      if Piece(VitalRPCResult[l],'^',2) = 'HT' then Height := ' ' + FormatHeight(Piece(Piece(VitalRPCResult[l],'^',5),' ',1)) + ' ';
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
    //Line3 := 'K'+ Piece(KeeneRPCResult,'^',2) + '-' + Piece(KeeneRPCResult,'^',1) + ' ';
    Line3 := Piece(KeeneRPCResult,'^',1) + ' ';  // + Piece(KeeneRPCResult,'^',1) + ' ';
    Line4 := Piece(cmbPhysicians.Text,',',1); // + '   ' + AdmDate;
    //AdmDate to be added later

    YPos := 220;
    XPos := 50;

    {
    frmIntracarePtAdmLbl.Canvas.FillRect(frmIntracarePtAdmLbl.Canvas.ClipRect);

    frmIntracarePtAdmLbl.Canvas.Font.Name := 'Arial';
    frmIntracarePtAdmLbl.Canvas.Font.Size := 12;  //# point
    frmIntracarePtAdmLbl.Canvas.TextOut(XPos,YPos,Line1);
    YPos := YPos+8+frmIntracarePtAdmLbl.Canvas.TextHeight(Line1);

    frmIntracarePtAdmLbl.Canvas.Font.Name := 'Arial';
    frmIntracarePtAdmLbl.Canvas.Font.Size := 10;  //# point
    frmIntracarePtAdmLbl.Canvas.TextOut(XPos,YPos,Line2);
    YPos := YPos+8+frmIntracarePtAdmLbl.Canvas.TextHeight(Line2);

    frmIntracarePtAdmLbl.Canvas.Font.Name := 'Arial';
    frmIntracarePtAdmLbl.Canvas.Font.Size := 10;  //# point
    frmIntracarePtAdmLbl.Canvas.TextOut(XPos,YPos,Line3);
    //Height&Weight Grid
    frmIntracarePtAdmLbl.Canvas.Pen.Style := psSolid;
    //Height Label
    tempXPos := XPos+8+frmIntracarePtAdmLbl.Canvas.TextWidth(Line3);
    frmIntracarePtAdmLbl.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+frmIntracarePtAdmLbl.Canvas.TextWidth(HeightTag),YPos+8+frmIntracarePtAdmLbl.Canvas.TextHeight(HeightTag));
    frmIntracarePtAdmLbl.Canvas.TextOut(tempXPos,YPos,HeightTag);
    //Height
    tempXPos := tempXPos+8+frmIntracarePtAdmLbl.Canvas.TextWidth(HeightTag);
    frmIntracarePtAdmLbl.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+frmIntracarePtAdmLbl.Canvas.TextWidth(Height),YPos+8+frmIntracarePtAdmLbl.Canvas.TextHeight(Height));
    frmIntracarePtAdmLbl.Canvas.TextOut(tempXPos,YPos,Height);
    //Weight Label
    tempXPos := tempXPos+8+frmIntracarePtAdmLbl.Canvas.TextWidth(Height);
    frmIntracarePtAdmLbl.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+frmIntracarePtAdmLbl.Canvas.TextWidth(WeightTag),YPos+8+frmIntracarePtAdmLbl.Canvas.TextHeight(WeightTag));
    frmIntracarePtAdmLbl.Canvas.TextOut(tempXPos,YPos,WeightTag);
    //Weight
    tempXPos := tempXPos+8+frmIntracarePtAdmLbl.Canvas.TextWidth(WeightTag);
    frmIntracarePtAdmLbl.Canvas.Rectangle(tempXPos,YPos,tempXPos+8+frmIntracarePtAdmLbl.Canvas.TextWidth(Weight),YPos+8+frmIntracarePtAdmLbl.Canvas.TextHeight(Weight));
    frmIntracarePtAdmLbl.Canvas.TextOut(tempXPos,YPos,Weight);
    YPos := YPos+8+frmIntracarePtAdmLbl.Canvas.TextHeight(Line3);

    frmIntracarePtAdmLbl.Canvas.Font.Name := 'Arial';
    frmIntracarePtAdmLbl.Canvas.Font.Size := 12;  //# point
    frmIntracarePtAdmLbl.Canvas.TextOut(XPos,YPos,Line4);
    frmIntracarePtAdmLbl.Canvas.TextOut(XPos+1750-frmIntracarePtAdmLbl.Canvas.TextWidth(AdmDate),YPos,AdmDate);  //Right Justify AdmDate
    YPos := YPos+170+frmIntracarePtAdmLbl.Canvas.TextHeight(Line4);
    }

    ACanvas.FillRect(ACanvas.ClipRect);

    ACanvas.Font.Name := 'Arial';
    ACanvas.Font.Size := 12;  //# point
    ACanvas.TextOut(XPos,YPos,Line1);
    YPos := YPos+8+ACanvas.TextHeight(Line1);

    ACanvas.Font.Name := 'Arial';
    ACanvas.Font.Size := 10;  //# point
    ACanvas.TextOut(XPos,YPos,Line2);
    YPos := YPos+8+ACanvas.TextHeight(Line2);

    ACanvas.Font.Name := 'Arial';
    ACanvas.Font.Size := 10;  //# point
    ACanvas.TextOut(XPos,YPos,Line3);
    //Height&Weight Grid
    ACanvas.Pen.Style := psSolid;
    //Height Label
    tempXPos := XPos+8+ACanvas.TextWidth(Line3);
    ACanvas.Rectangle(tempXPos,YPos,tempXPos+8+ACanvas.TextWidth(HeightTag),YPos+8+ACanvas.TextHeight(HeightTag));
    ACanvas.TextOut(tempXPos,YPos,HeightTag);
    //Height
    tempXPos := tempXPos+8+ACanvas.TextWidth(HeightTag);
    ACanvas.Rectangle(tempXPos,YPos,tempXPos+8+ACanvas.TextWidth(Height),YPos+8+ACanvas.TextHeight(Height));
    ACanvas.TextOut(tempXPos,YPos,Height);
    //Weight Label
    tempXPos := tempXPos+8+ACanvas.TextWidth(Height);
    ACanvas.Rectangle(tempXPos,YPos,tempXPos+8+ACanvas.TextWidth(WeightTag),YPos+8+ACanvas.TextHeight(WeightTag));
    ACanvas.TextOut(tempXPos,YPos,WeightTag);
    //Weight
    tempXPos := tempXPos+8+ACanvas.TextWidth(WeightTag);
    ACanvas.Rectangle(tempXPos,YPos,tempXPos+8+ACanvas.TextWidth(Weight),YPos+8+ACanvas.TextHeight(Weight));
    ACanvas.TextOut(tempXPos,YPos,Weight);
    YPos := YPos+8+ACanvas.TextHeight(Line3);

    ACanvas.Font.Name := 'Arial';
    ACanvas.Font.Size := 12;  //# point
    ACanvas.TextOut(XPos,YPos,Line4);
    ACanvas.TextOut(XPos+1750-ACanvas.TextWidth(AdmDate),YPos,AdmDate);  //Right Justify AdmDate
    YPos := YPos+170+ACanvas.TextHeight(Line4);


    //FPrinter.Canvas.Font.Name := 'Arial';
    //FPrinter.Canvas.Font.Size := 10;  //# point
    //FPrinter.Canvas.TextOut(XPos,YPos,Line5);
    //YPos := YPos+100+FPrinter.Canvas.TextHeight(Line5);

    VitalRPCResult.Free;
  end;

  procedure TfrmIntracarePtAdmLbl.FormCreate(Sender: TObject);
  begin
    //FPrinter := TPrinter.Create;
  end;

  procedure TfrmIntracarePtAdmLbl.FormDestroy(Sender: TObject);
  begin
    //FPrinter.Free;
  end;

  procedure TfrmIntracarePtAdmLbl.UpDown1Click(Sender: TObject;
    Button: TUDBtnType);
  begin
  //btNext, btPrev
    if Button = btNext then begin
      edit1.Text := inttostr(strtoint(Edit1.text) + 1);
    end else if strtoint(edit1.text) > 1 then begin
      edit1.text := inttostr(strtoint(Edit1.text) - 1);
    end;
  end;

  procedure TfrmIntracarePtAdmLbl.Edit1KeyPress(Sender: TObject; var Key: Char);
  begin
   { if not (Key in [#8, '0'..'9']) then begin
      Key := #0;
    end;  }
  end;

  procedure TfrmIntracarePtAdmLbl.btnPreviewClick(Sender: TObject);
  var
    frmIntracarePrintPreview: TfrmIntracarePrintPreview;

  begin
    frmIntracarePrintPreview := TfrmIntracarePrintPreview.Create(Self);
    SetupPreview(frmIntracarePrintPreview.Canvas);
    frmIntracarePrintPreview.ShowModal;
    frmIntracarePrintPreview.Free;
  end;

  procedure TfrmIntracarePtAdmLbl.CLOSETimer(Sender: TObject);
  begin
    if CloseForm = True then ModalResult := mrCancel;
    Close.Enabled := false;
  end;

end.

