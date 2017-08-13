unit fNotePrt;
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
  fAutoSz, ORCtrls, StdCtrls, Mask, ORNet, ORFn, ComCtrls,
  VA508AccessibilityManager;

type
  TfrmNotePrint = class(TfrmAutoSz)
    grpChooseCopy: TGroupBox;
    radChartCopy: TRadioButton;
    radWorkCopy: TRadioButton;
    grpDevice: TGroupBox;
    lblMargin: TLabel;
    lblLength: TLabel;
    txtRightMargin: TMaskEdit;
    txtPageLength: TMaskEdit;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblNoteTitle: TMemo;
    cboDevice: TORComboBox;
    lblPrintTo: TLabel;
    dlgWinPrinter: TPrintDialog;
    chkDefault: TCheckBox;
    procedure cboDeviceNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboDeviceChange(Sender: TObject);
    procedure radChartCopyClick(Sender: TObject);
    procedure radWorkCopyClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    { Private declarations }
    FNote: Integer;
    FReportText: TRichEdit;
    procedure DisplaySelectDevice;
  public
    { Public declarations }
  end;

procedure PrintNote(ANote: Longint; const ANoteTitle: string; MultiNotes: boolean = False);
function GetPrinter: string;      //kt added entire function  8/9/11
implementation

{$R *.DFM}

uses
  uHTMLTools,  //kt 9/11
   rCore, rTIU, rReports, uCore, Printers, uReports;

const
  TX_NODEVICE = 'A device must be selected to print, or press ''Cancel'' to not print.';
  TX_NODEVICE_CAP = 'Device Not Selected';
  TX_ERR_CAP = 'Print Error';
  PAGE_BREAK = '**PAGE BREAK**';

procedure PrintNote(ANote: Longint; const ANoteTitle: string; MultiNotes: boolean = False);
{ displays a form that prompts for a device and then prints the progress note }
var
  frmNotePrint: TfrmNotePrint;
  DefPrt: string;
begin
  frmNotePrint := TfrmNotePrint.Create(Application);
  try
    ResizeFormToFont(TForm(frmNotePrint));
    with frmNotePrint do
    begin
      { check to see of Chart Print allowed outside of MAS }
      if AllowChartPrintForNote(ANote) then
        begin
          {This next code begs the question: Why are we even bothering to check
          radWorkCopy if we immediately check the other button?
          Short answer: it seems to wokr better
          Long answer: The checkboxes have to in some way register with the group
          they are in.  If this doesn't happen, both will be initially included
          the tab order.  This means that the first time tabbing through the
          controls, the work copy button would be tabbed to and selected after the
          chart copy.  Tabbing through controls should not change the group
          selection.
          }
          radWorkCopy.Checked := True;
          radChartCopy.Checked := True;
        end
      else
        begin
          radChartCopy.Enabled := False;
          radWorkCopy.Checked := True;
        end;

      lblNoteTitle.Text := ANoteTitle;
      frmNotePrint.Caption := 'Print ' + Piece(Piece(ANoteTitle, #9, 2), ',', 1);
      FNote := ANote;
      DefPrt := GetDefaultPrinter(User.Duz, Encounter.Location);

      if User.CurrentPrinter = '' then User.CurrentPrinter := DefPrt;

      with cboDevice do
        begin
          if Printer.Printers.Count > 0 then
            begin
              Items.Add('WIN;Windows Printer^Windows Printer');
              Items.Add('^--------------------VistA Printers----------------------');
            end;
          if User.CurrentPrinter <> '' then
            begin
              InitLongList(Piece(User.CurrentPrinter, ';', 2));
              SelectByID(User.CurrentPrinter);
            end
          else
            InitLongList('');
        end;

      if ((DefPrt = 'WIN;Windows Printer') and (User.CurrentPrinter = DefPrt)) then
        cmdOKClick(frmNotePrint) //CQ6660
        //Commented out for CQ6660
         //or
         //((User.CurrentPrinter <> '') and
          //(MultiNotes = True)) then
           //frmNotePrint.cmdOKClick(frmNotePrint)
        //end CQ6660
      else
        frmNotePrint.ShowModal;
    end;
  finally
    frmNotePrint.Release;
  end;
end;

procedure TfrmNotePrint.DisplaySelectDevice;
begin
  with cboDevice, lblPrintTo do
  begin
    if radChartCopy.Checked then Caption := 'Print Chart Copy on:  ' + Piece(ItemID, ';', 2);
    if radWorkCopy.Checked then Caption := 'Print Work Copy on:  ' + Piece(ItemID, ';', 2);
  end;
end;

procedure TfrmNotePrint.cboDeviceNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
begin
  inherited;
  cboDevice.ForDataUse(SubsetOfDevices(StartFrom, Direction));
end;

procedure TfrmNotePrint.cboDeviceChange(Sender: TObject);
begin
  inherited;
  with cboDevice do if ItemIndex > -1 then
  begin
    txtRightMargin.Text := Piece(Items[ItemIndex], '^', 4);
    txtPageLength.Text := Piece(Items[ItemIndex], '^', 5);
    DisplaySelectDevice;
  end;
end;

procedure TfrmNotePrint.radChartCopyClick(Sender: TObject);
begin
  inherited;
  DisplaySelectDevice;
end;

procedure TfrmNotePrint.radWorkCopyClick(Sender: TObject);
begin
  inherited;
  DisplaySelectDevice;
end;

procedure TfrmNotePrint.cmdOKClick(Sender: TObject);
var
  ADevice, ErrMsg: string;
  ChartCopy: Boolean;
  RemoteSiteID: string;    //for Remote site printing
  RemoteQuery: string;    //for Remote site printing
  TempLines : TStringList; //kt 9/11

begin
  inherited;
  RemoteSiteID := '';
  RemoteQuery := '';

  if cboDevice.ItemID = '' then
     begin
     InfoBox(TX_NODEVICE, TX_NODEVICE_CAP, MB_OK);
     Exit;
     end;

  if radChartCopy.Checked then
     ChartCopy := True
  else ChartCopy := False;


  if Piece(cboDevice.ItemID, ';', 1) = 'WIN' then
(*
    //begin original block of code from before 9/11
    //----------------------------------------------
    begin
    if dlgWinPrinter.Execute then
       begin
       FReportText := CreateReportTextComponent(Self);
       FastAssign(GetFormattedNote(FNote, ChartCopy), FReportText.Lines);
       PrintWindowsReport(FReportText, PAGE_BREAK, Self.Caption, ErrMsg);
       if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
       end
    end
    //end original unmodified block of code //kt 9/11
    //--------------------------------------------------
*)
    //begin modified block of code //kt 9/11
    //----------------------------------------------
    begin
      TempLines := TStringList.Create;
      TempLines.Assign(GetFormattedNote(FNote, ChartCopy));
      if uHTMLTools.IsHTML(TempLines) = false then begin
        //NOTE: If HTML, then bypass this printer dialog, because it will be
        //      replaced by a printer dialog that internet explorer uses.
        if dlgWinPrinter.Execute then begin
          //FReportText.Lines.Assign(TempLines);
          FReportText := CreateReportTextComponent(Self);
          FastAssign(GetFormattedNote(FNote, ChartCopy), FReportText.Lines);
          PrintWindowsReport(FReportText, PAGE_BREAK, Self.Caption, ErrMsg);
        end;
      end else begin
        LoadDocumentText(TempLines, FNote);  //Get document without headers/footers
        PrintHTMLReport(TempLines, ErrMsg, Patient.Name,
                        FormatFMDateTime('mm/dd/yyyy', Patient.DOB),
                        uHTMLtools.ExtractDateOfNote(TempLines), // date for report.
                        Patient.WardService, Application);
      end;
      TempLines.Free;
      if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
    end
    //end modified block of code //kt 9/11
    //----------------------------------------------
  else
    begin
    ADevice := Piece(cboDevice.ItemID, ';', 2);
    PrintNoteToDevice(FNote, ADevice, ChartCopy, ErrMsg);

    if Length(ErrMsg) > 0 then
        InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
    end;

  if chkDefault.Checked then
     SaveDefaultPrinter(Piece(cboDevice.ItemID, ';', 1));

  User.CurrentPrinter := cboDevice.ItemID;
  Close;
end;

procedure TfrmNotePrint.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

function GetPrinter: string;      //kt added entire function  8/9/11
{ displays a form that prompts for a device and then returns the selected printer }
var
  frmNotePrint: TfrmNotePrint;
  DefPrt: string;
begin
  frmNotePrint := TfrmNotePrint.Create(Application);
  try
    ResizeFormToFont(TForm(frmNotePrint));
    with frmNotePrint do begin
      radChartCopy.Checked := True;
      lblNoteTitle.Text := 'Print Letters'; //ANoteTitle;
      frmNotePrint.Caption := 'Print Letters';// + Piece(Piece(ANoteTitle, #9, 2), ',', 1);
      //FNote := ANote;
      DefPrt := GetDefaultPrinter(User.Duz, Encounter.Location);

      if User.CurrentPrinter = '' then User.CurrentPrinter := DefPrt;

      with cboDevice do begin
        if Printer.Printers.Count > 0 then begin
          Items.Add('WIN;Windows Printer^Windows Printer');
          Items.Add('^--------------------VistA Printers----------------------');
        end;
        if User.CurrentPrinter <> '' then begin
            InitLongList(Piece(User.CurrentPrinter, ';', 2));
            SelectByID(User.CurrentPrinter);
        end else begin
          InitLongList('');
        end;
      end;
      frmNotePrint.ShowModal;
    end;
  finally
    Result := frmNotePrint.cboDevice.ItemID;
    frmNotePrint.Release;
  end;
end;

end.
