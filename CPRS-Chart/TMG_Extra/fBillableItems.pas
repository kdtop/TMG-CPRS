unit fBillableItems;
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
  Dialogs, StdCtrls, ComCtrls, ORNet, Printers, Math, ExtCtrls;

type
  TfrmBillableItems = class(TForm)
    btnGetReport: TButton;
    dateBeginning: TDateTimePicker;
    dateEnding: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    btnPrintCPTs: TButton;
    Button2: TButton;
    dlgPrintReport: TPrintDialog;
    radFilter: TRadioGroup;
    btnGetICDs: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    reBillableReport: TRichEdit;
    Panel3: TPanel;
    reICDs: TRichEdit;
    btnPrintICDs: TButton;
    procedure btnPrintICDsClick(Sender: TObject);
    procedure reBillableReportResizeRequest(Sender: TObject; Rect: TRect);
    procedure reICDsResizeRequest(Sender: TObject; Rect: TRect);
    procedure FormResize(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure dateEndingChange(Sender: TObject);
    procedure dateBeginningChange(Sender: TObject);
    procedure btnGetICDsClick(Sender: TObject);
    procedure radFilterClick(Sender: TObject);
    procedure btnPrintCPTsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnGetReportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PrintRichEdit(RichEdit: TRichEdit; const Caption: string; const PrinterMargin: Integer);
    procedure CreateReportHeader(var HeaderList: TStringList; PageTitle: string);
  end;

//var
//  frmBillableItems: TfrmBillableItems;

implementation

{$R *.dfm}
uses uReports,rReports;

procedure TfrmBillableItems.btnGetICDsClick(Sender: TObject);
var //RPCResults: TStrings;
    ReportText: TStringList;
begin
ReportText := TStringList.Create;
TCallV(ReportText,'TMG CPRS GET BILLABLE ITEMS',[datetostr(dateBeginning.Date),datetostr(dateEnding.Date),'3']);
//ReportText.Clear;
//ReportText.Add('{\rtf1\ansi\deff0 {\fonttbl {\f0 Monotype Corsiva;}}');
//ReportText.Add('\qc\f0\fs120\i\b Hello,\line World!}');
reICDs.Lines.Clear;
reICDs.Text := ReportText.text;
ReportText.Free;
end;

procedure TfrmBillableItems.btnGetReportClick(Sender: TObject);
var //RPCResults: TStrings;
    ReportText: TStringList;
begin
ReportText := TStringList.Create;
TCallV(ReportText,'TMG CPRS GET BILLABLE ITEMS',[datetostr(dateBeginning.Date),datetostr(dateEnding.Date),inttostr(radFilter.ItemIndex)]);
//ReportText.Clear;
//ReportText.Add('{\rtf1\ansi\deff0 {\fonttbl {\f0 Monotype Corsiva;}}');
//ReportText.Add('\qc\f0\fs120\i\b Hello,\line World!}');
reBillableReport.Lines.Clear;
reBillableReport.Text := ReportText.text;
ReportText.Free;
end;

procedure TfrmBillableItems.CreateReportHeader(var HeaderList: TStringList; PageTitle: string);
// standard patient header, from HEAD^ORWRPP
var
  tmpStr, tmpItem: string;
begin
  with HeaderList do
    begin
      Add(' ');
      Add(StringOfChar(' ', (74 - Length(PageTitle)) div 2) + PageTitle);
      Add(' ');
      tmpStr := 'REPORT TEXT';
      tmpItem := tmpStr + StringOfChar(' ', 39 - Length(tmpStr));
      //tmpStr := FormatFMDateTime('mmm dd, yyyy', Patient.DOB) + ' (' + IntToStr(Patient.Age) + ')';
      //tmpItem := tmpItem + StringOfChar(' ', 74 - (Length(tmpItem) + Length(tmpStr))) + tmpStr;
      Add(tmpItem);
      Add(StringOfChar('=', 74));
      Add('************' + StringOfChar(' ', 24) + 'Printed: ' + datetostr(NOW));
      Add(' ');
      Add(' ');
    end;
end;

procedure TfrmBillableItems.btnPrintCPTsClick(Sender: TObject);
//var
  //AHeader: TStringList;
  //memPrintReport: TRichEdit;
  //StartLine, MaxLines, LastLine, ThisPage, i: integer;
  //ErrMsg: string;
  //RemoteSiteID: string;    //for Remote site printing
  //RemoteQuery: string;    //for Remote site printing
const
  PAGE_BREAK = '**PAGE BREAK**';
begin
  PrintRichEdit(reBillableReport,'FPG Billing Report',20);
{ The following code is another method of printing but doesn't
  support the rich text edit formatting codes

  RemoteSiteID := '';
  RemoteQuery := '';
  if dlgPrintReport.Execute then
    begin
      AHeader := TStringList.Create;
      CreateReportHeader(AHeader, Self.Caption);
      memPrintReport := CreateReportTextComponent(Self);
      try
        MaxLines := 60 - AHeader.Count;
        LastLine := 0;
        ThisPage := 0;
        with memPrintReport do
          begin
            StartLine := 0;
            repeat
              with Lines do
                begin
                  AddStrings(AHeader);
                  for i := StartLine to MaxLines do
                    //if i < memPtDemo.Lines.Count - 1 then
                    if i < reBillableReport.Lines.Count then
                      Add(reBillableReport.Lines[LastLine + i])
                    else
                      Break;
                  LastLine := LastLine + i;
                  Add(' ');
                  Add(' ');
                  Add(StringOfChar('-', 74));
                  if LastLine >= reBillableReport.Lines.Count - 1 then
                    Add('End of report')
                  else
                    begin
                      ThisPage := ThisPage + 1;
                      Add('Page ' + IntToStr(ThisPage));
                      Add(PAGE_BREAK);
                      StartLine := 0;
                    end;
                end;
              until LastLine >= reBillableReport.Lines.Count - 1;
            PrintWindowsReport(memPrintReport, PAGE_BREAK, Self.Caption, ErrMsg);
          end;
      finally
        memPrintReport.Free;
        AHeader.Free;
      end;
    end;
  reBillableReport.SelStart := 0;
  reBillableReport.Invalidate;
}
end;



procedure TfrmBillableItems.btnPrintICDsClick(Sender: TObject);
const
  PAGE_BREAK = '**PAGE BREAK**';
begin
  PrintRichEdit(reICDs,'FPG ICD Codes',20);
end;

procedure TfrmBillableItems.dateBeginningChange(Sender: TObject);
begin
reBillableReport.Lines.clear;
reICDs.Lines.clear;
btnGetReportClick(sender);
btnGetICDsClick(sender);
end;

procedure TfrmBillableItems.dateEndingChange(Sender: TObject);
begin
reBillableReport.Lines.clear;
reICDS.Lines.Clear;
btnGetReportClick(sender);
btnGetICDsClick(sender);
end;

procedure TfrmBillableItems.FormResize(Sender: TObject);
begin
self.repaint;
end;

procedure TfrmBillableItems.FormShow(Sender: TObject);
begin
dateBeginning.Date := NOW;
dateEnding.Date := Now;
self.repaint;
btnGetReportClick(Sender);
btnGetICDsClick(Sender);
end;

procedure TfrmBillableItems.Panel3Click(Sender: TObject);
begin
self.Repaint;
end;

procedure TfrmBillableItems.PrintRichEdit(RichEdit: TRichEdit; const Caption: string;
  const PrinterMargin: Integer);
//the units of TRichEdit.PageRect are pixels, units of PrinterMargin are mm
var
  PrinterHeight, PrinterWidth: Integer;
  LogPixels, PrinterTopLeft: TPoint;
  PageRect: TRect;
  Handle: HDC;
begin
  Handle := Printer.Handle;
  LogPixels := Point(GetDeviceCaps(Handle, LOGPIXELSX),
    GetDeviceCaps(Handle, LOGPIXELSY));
  PrinterTopLeft := Point(GetDeviceCaps(Handle, PHYSICALOFFSETX),
    GetDeviceCaps(Handle, PHYSICALOFFSETY));
  PrinterWidth := Printer.PageWidth;
  PrinterHeight := Printer.PageHeight;
  PageRect.Left := Max(0, Round(PrinterMargin*LogPixels.X/25.4)
    - PrinterTopLeft.X);
  PageRect.Top := Max(0, Round(PrinterMargin*LogPixels.Y/25.4)
    - PrinterTopLeft.Y);
  PageRect.Right := PrinterWidth-PageRect.Left;
  PageRect.Bottom := PrinterHeight-PageRect.Top;
  if (PageRect.Left>=PageRect.Right) or (PageRect.Top>=PageRect.Bottom) then
    //the margins are too big
    PageRect := Rect(0, 0, 0, 0);
  RichEdit.PageRect := PageRect;
  RichEdit.Print(Caption);
end;

procedure TfrmBillableItems.radFilterClick(Sender: TObject);
begin
  btnGetReportClick(Sender);
end;

procedure TfrmBillableItems.reBillableReportResizeRequest(Sender: TObject; Rect: TRect);
begin
   reBillableReport.repaint;
end;

procedure TfrmBillableItems.reICDsResizeRequest(Sender: TObject; Rect: TRect);
begin
   reICDs.Repaint;
end;

end.

