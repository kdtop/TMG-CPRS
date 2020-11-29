unit fPtLabelPrint;
//kt added this entire unit and form 12/2007
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
  Printers, uCore,ORFn;

type
  TfrmPtLabelPrint = class(TForm)
    NameLabel: TLabel;
    AuthorLabel: TLabel;
    NoteTypeLabel: TLabel;
    PrinterComboBox: TComboBox;
    PrinterLabel: TLabel;
    DateLabel: TLabel;
    LocationLabel: TLabel;
    PrintButton: TBitBtn;
    DoneButton: TBitBtn;
    Image1: TImage;
    cboAuthor: TORComboBox;
    calDOS: TORDateBox;
    cboLocation: TORComboBox;
    cboNoteTitle: TORComboBox;
    cboPatient: TORComboBox;
    PrinterSetupDialog: TPrinterSetupDialog;
    SpeedButton1: TSpeedButton;
    PtNameLabel: TLabel;
    PtDOBLabel: TLabel;
    PtSSNLabel: TLabel;
    PtName: TLabel;
    PtDOB: TLabel;
    PtSSN: TLabel;
    Label1: TLabel;
    BarcodeLabel: TLabel;
    BatchNumComboBox: TComboBox;
    Label2: TLabel;
    procedure DoneButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cboLocationNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboAuthorNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboNoteTitleNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure cboPatientNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure calDOSChange(Sender: TObject);
    procedure calDOSExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure cboPatientChange(Sender: TObject);
    procedure cboAuthorChange(Sender: TObject);
    procedure cboNoteTitleChange(Sender: TObject);
    procedure cboLocationChange(Sender: TObject);
    procedure PrinterComboBoxChange(Sender: TObject);
    procedure BatchNumComboBoxChange(Sender: TObject);
  private
    { Private declarations }
    FInitPtIEN : int64;
    FPrinter : TPrinter;
    initPatientName : string;
    //FDateTime: TFMDateTime;
    //FDateTimeText : string ;
    function CompileBarcodeNumber: String;
    procedure BarcodeChange(Sender: TObject);
  public
    { Public declarations }
    procedure PrepDialog(Patient : TPatient);
  end;

//var
//  frmPtLabelPrint: TfrmPtLabelPrint;

implementation

{$R *.dfm}

uses rCore,rTIU,uConst,
      IniFiles, // for IniFile
      uImages, fImages;

const
  ANY_NUM_PAGES = '<ANY>';

procedure TfrmPtLabelPrint.PrepDialog(Patient : TPatient);
begin
  initPatientName := Patient.Name;
  FInitPtIEN := StrToInt(Patient.DFN);
end;

procedure TfrmPtLabelPrint.DoneButtonClick(Sender: TObject);
begin
  ModalResult := mrOK;  //to close form.
end;


function TfrmPtLabelPrint.CompileBarcodeNumber: String;
var
  DateOfService: string;
  PtIEN, AuthorIEN, NoteTypeIEN, LocIEN : int64;
  BCLine,BatchFlag: string;
  PtIDInfo : TPtIDInfo;
begin
  PtIEN := cboPatient.ItemIEN;  //check this
  PtIDInfo := rCore.GetPtIDInfo(IntToStr(PtIEN));
  DateOfService := FormatFMDateTime('mm"-"dd"-"yyyy', calDOS.FMDateTime);
  AuthorIEN := cboAuthor.ItemIEN;
  LocIEN := cboLocation.ItemIEN;
  NoteTypeIEN :=  cboNoteTitle.ItemIEN;
  BatchFlag := BatchNumComboBox.Text;
  if BatchFlag = ANY_NUM_PAGES then BatchFlag := '*';
  
  // 70685-12-31-2008-73-6-1302-0
  //Note: *** If this changes, then change format in UploadImages.ScanAndHandleImages
  BCLine := IntToStr(PtIEN) + '-' + DateOfService + '-' +
            IntToStr(AuthorIEN) + '-' + 
            IntToStr(LocIEN) + '-' + IntToStr(NoteTypeIEN) + '-' +
            BatchFlag;

  Result := BCLine;            
end;

procedure TfrmPtLabelPrint.PrintButtonClick(Sender: TObject);
var
  //DateOfService: string;
  //NoteTypeIEN, AuthorIEN, LocIEN : int64;
  PtIEN : int64;
  BCLine : string;
  NameLine,DOBLine,ProvLine,LocLine,TitleLine : string;
  //BatchFlag: string;
  YPos,XPos : integer;    
  PtIDInfo : TPtIDInfo;
  FNamePath : AnsiString;
  pic : TPicture;
  SrcRec,DestRec :TRect; 
  DestPos : TPoint;
  //barcodeWidth,barcodeHeight : integer;

Const
   BarCodeSize=310;
   LMargin = 1;
   TMargin = 1;
     
begin
  PtIEN := cboPatient.ItemIEN;  //check this
  PtIDInfo := rCore.GetPtIDInfo(IntToStr(PtIEN));
  //DateOfService := FormatFMDateTime('mm"-"dd"-"yyyy', calDOS.FMDateTime);
  
  //AuthorIEN := cboAuthor.ItemIEN;
  //LocIEN := cboLocation.ItemIEN;
  //NoteTypeIEN :=  cboNoteTitle.ItemIEN;
  //if BatchCB.Checked = true then begin
  //  BatchFlag := '1'; 
  //end else begin
  //  BatchFlag := '0'; 
  //end;  
  
  YPos := TMargin+25;
  XPos := LMargin+BarCodeSize+10;
  BCLine := CompileBarcodeNumber;

  //TEST,KILLME
  //DOB: 04-02-1956
  NameLine := PtIDInfo.Name;
  DOBLine :=  'DOB: ' + PtIDInfo.DOB;
  //DOBLine := DOBLine + BatchNumComboBox.Text;
  ProvLine := Trim(piece(cboAuthor.Text,'-',1));
  LocLine :=  cboLocation.Text;
  if Pos('<',cboNoteTitle.Text)>0 then begin
    TitleLine := piece(cboNoteTitle.Text,'<',2);
    TitleLine := piece(TitleLine,'>',1)
  end else begin
    TitleLine := cboNoteTitle.Text;
  end;

  FPrinter.PrinterIndex := PrinterComboBox.ItemIndex;
  FPrinter.Orientation := poLandscape;
  FPrinter.Title := 'Patient Label -- ' + PtIDInfo.Name;
  //FPrinter.Copies := StrToInt(QuantitySpinEdit.Text);

  try
    pic := TPicture.Create;
    FNamePath := DoCreateBarcode(BCLine,'png');
    pic.LoadFromFile(FNamePath);  
    //barcodeWidth := pic.Bitmap.Width;
    //barcodeHeight := pic.Bitmap.Height;
    SrcRec.Top := 0;
    SrcRec.Left := 0;
    SrcRec.Right := 32;
    SrcRec.Bottom := 32;

    DestPos.X := LMargin;
    DestPos.Y := TMargin;
    DestRec.TopLeft := DestPos;
    DestRec.Right := DestPos.X+BarCodeSize;
    DestRec.Bottom := DestPos.Y+BarCodeSize;
           
    FPrinter.BeginDoc; //start print job.

    //copy barcode bitmap to printer canvas.
    FPrinter.Canvas.CopyMode := cmSrcCopy;
    FPrinter.Canvas.StretchDraw(DestRec,pic.Graphic);
    
    FPrinter.Canvas.Font.Name := 'Arial';
    FPrinter.Canvas.Font.Size := 10;  //# point
      
    //Print out Name line      
    FPrinter.Canvas.TextOut(XPos,YPos,NameLine);
    YPos := YPos + FPrinter.Canvas.TextHeight(NameLine)+5;
  
    FPrinter.Canvas.Font.Size := 8;  //# point
    //Print out DOB line      
    FPrinter.Canvas.TextOut(XPos,YPos,DOBLine);
    YPos := YPos + FPrinter.Canvas.TextHeight(DOBLine)+5;

    //Print out Provider/Author line      
    FPrinter.Canvas.TextOut(XPos,YPos,ProvLine);
    YPos := YPos + FPrinter.Canvas.TextHeight(ProvLine)+5;

    //Print out Location line      
    FPrinter.Canvas.TextOut(XPos,YPos,LocLine);
    YPos := YPos + FPrinter.Canvas.TextHeight(LocLine)+5;

    //Print out Note Title line      
    FPrinter.Canvas.TextOut(XPos,YPos,TitleLine);
    YPos := YPos + FPrinter.Canvas.TextHeight(TitleLine)+5;
  
    //Print out clear-text of barcode data line 
    FPrinter.Canvas.Font.Size := 8;  //x point
    FPrinter.Canvas.TextOut(XPos,YPos,BCLine);
    YPos := YPos + FPrinter.Canvas.TextHeight(BCLine)+5;
    
  finally
    FPrinter.EndDoc;  //close and launch print job
    pic.Free;
    DeleteFile(FNamePath);
  end;  

end;


procedure TfrmPtLabelPrint.FormCreate(Sender: TObject);
//var  IniFile : TIniFile;
//     defPrinter : string;
begin
  FPrinter := TPrinter.Create;
end;


procedure TfrmPtLabelPrint.FormShow(Sender: TObject);
var
  uTIULocationName: string;
  uTIULocation: integer;
  //temp : string;
  
  IniFile : TIniFile;
  defPrinter : string;

begin
  cboAuthor.InitLongList(User.Name);
  cboAuthor.SelectByIEN(User.DUZ);

  uTIULocation := DfltTIULocation;
  if uTIULocation <> 0 then uTIULocationName := ExternalName(uTIULocation, FN_HOSPITAL_LOCATION);
  
  cboLocation.InitLongList(uTIULocationName);
  cboLocation.SelectByIEN(uTIULocation);
  
  cboNoteTitle.InitLongList('');
  if cboNoteTitle.Items.Count>0 then cboNoteTitle.ItemIndex := 0;

  // Assign list box TabPosition, Pieces properties according to type of list to be displayed.
  // (Always use Piece "2" as the first in the list to assure display of patient's name.)
  cboPatient.pieces := '2,3'; // This line and next: defaults set - exceptions modifield next.
  cboPatient.tabPositions := '20,28';
  cboPatient.InitLongList(initPatientName);
  cboPatient.SelectByIEN(FInitPtIEN);
 // temp := cboPatient.Text;
  cboPatientChange(self);


  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    defPrinter := IniFile.ReadString('Label Printing','Default Printer','');
  finally
    IniFile.Free;
  end;

  PrinterComboBox.Items.Clear  ;
  PrinterComboBox.Items.Assign(FPrinter.Printers);
  if PrinterComboBox.Items.IndexOf(defPrinter) > -1 then begin
    PrinterComboBox.ItemIndex := PrinterComboBox.Items.IndexOf(defPrinter);
  end else if PrinterComboBox.Items.Count > 0 then begin
    PrinterComboBox.ItemIndex := 0;
  end;  
  
end;



procedure TfrmPtLabelPrint.cboLocationNeedData(Sender: TObject;
                                               const StartFrom: String; 
                                               Direction, InsertAt: Integer);
begin
  inherited;
  cboLocation.ForDataUse(SubSetOfNewLocs(StartFrom, Direction));
end;


procedure TfrmPtLabelPrint.cboAuthorNeedData(Sender: TObject;
                                             const StartFrom: String; 
                                             Direction, InsertAt: Integer);
begin
  (Sender as TORComboBox).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;


procedure TfrmPtLabelPrint.cboNoteTitleNeedData(Sender: TObject;
                                               const StartFrom: String;
                                               Direction, InsertAt: Integer);
var  FIDNoteTitlesOnly : boolean;  
begin
  FIDNoteTitlesOnly := false;
  cboNoteTitle.ForDataUse(SubSetOfNoteTitles(StartFrom, Direction, FIDNoteTitlesOnly));
end;


procedure TfrmPtLabelPrint.FormDestroy(Sender: TObject);
begin
  FPrinter.free;
end;

procedure TfrmPtLabelPrint.cboPatientNeedData(Sender: TObject;
                                              const StartFrom: String; 
                                              Direction, InsertAt: Integer);
var
  i: Integer;
  NoAlias, Patient: String;
  PatientList: TStringList;
const
  AliasString = ' -- ALIAS';
  
begin
  //NOTICE: for now I am taking out restrictions regarding restricted
  //        patient lists.  User will be able to *print a label* for
  //        any patient (but not open their chart)


  NoAlias := StartFrom;
  with Sender as TORComboBox do begin
    if Items.Count > ShortCount then begin
      NoAlias := Piece(Items[Items.Count-1], U, 1) + U + NoAlias;
    end;  
  end;  
  if pos(AliasString, NoAlias)> 0 then begin
    NoAlias := Copy(NoAlias, 1, pos(AliasString, NoAlias)-1);
  end;  
  PatientList := TStringList.Create;
  try
    begin
      PatientList.Assign(SubSetOfPatients(NoAlias, Direction));
      for i := 0 to PatientList.Count-1 do begin  // Add " - Alias" to alias names:
        Patient := PatientList[i];
        // Piece 6 avoids display problems when mixed with "RPL" lists:
        if (Uppercase(Piece(Patient, U, 2)) <> Uppercase(Piece(Patient, U, 6))) then begin
          SetPiece(Patient, U, 2, Piece(Patient, U, 2) + AliasString);
          PatientList[i] := Patient;
        end;
      end;
      cboPatient.ForDataUse(PatientList);
    end;
  finally
    PatientList.Free;
  end;  
end;



procedure TfrmPtLabelPrint.calDOSChange(Sender: TObject);
begin
  //FDateTime := calDOS.FMDateTime;
  BarcodeChange(self);
end;

procedure TfrmPtLabelPrint.calDOSExit(Sender: TObject);
begin
//  FDateTimeText := FormatFMDateTime('mmm dd,yyyy', FDateTime);
end;

procedure TfrmPtLabelPrint.FormResize(Sender: TObject);
begin
  //if Width < 375 then Width := 375;
  //if Width > 500 then Width := 500;
  //if Height <> 345 then Height := 345;
end;

procedure TfrmPtLabelPrint.SpeedButton1Click(Sender: TObject);
begin
  PrinterSetupDialog.Execute;
end;

procedure TfrmPtLabelPrint.cboPatientChange(Sender: TObject);
var
  PtIDInfo : TPtIDInfo;
  PtIEN : int64;
begin
  PtIEN := cboPatient.ItemIEN;  
  PtIDInfo := rCore.GetPtIDInfo(IntToStr(PtIEN));
  PtName.Caption := PtIDInfo.Name;
  PtDOB.Caption :=  PtIDInfo.DOB;
  PtSSN.Caption := PtIDInfo.SSN;
  PtName.Color := PtIDInfo.DueColor; //kt 12/19/14
  PtName.ShowHint := True;           //kt 12/19/14
  PtName.ParentShowHint := False;    //kt 12/19/14
  PtName.Hint := PtIDInfo.DueHint;   //kt 12/19/14
  BarcodeChange(self);
end;

procedure TfrmPtLabelPrint.BarcodeChange(Sender: TObject);
begin
  BarcodeLabel.Caption := CompileBarcodeNumber;
end;


procedure TfrmPtLabelPrint.cboAuthorChange(Sender: TObject);
begin
  BarcodeChange(self);
end;

procedure TfrmPtLabelPrint.cboNoteTitleChange(Sender: TObject);
begin
  BarcodeChange(self);
end;

procedure TfrmPtLabelPrint.cboLocationChange(Sender: TObject);
begin
  BarcodeChange(self);
end;

procedure TfrmPtLabelPrint.PrinterComboBoxChange(Sender: TObject);
var  IniFile : TIniFile;
     defPrinter : string;
begin
  FPrinter := TPrinter.Create;
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  defPrinter := PrinterComboBox.Items.Strings[PrinterComboBox.ItemIndex];
  try
    IniFile.WriteString('Label Printing','Default Printer',defPrinter);
  finally
    IniFile.Free;
  end;
end;

procedure TfrmPtLabelPrint.BatchNumComboBoxChange(Sender: TObject);
var temp : integer;
begin
  if BatchNumComboBox.Text <> ANY_NUM_PAGES then begin
    try
      temp := StrToInt(BatchNumComboBox.Text);
    except
      on E:EConvertError do begin
        temp := 0;
      end;
    end;
    if temp < 1 then begin
      MessageDlg('Invalid Number.',mtError,[mbOK],0);
      BatchNumComboBox.Text := '1';
    end;
  end;
  BarcodeChange(self);
end;


end.


