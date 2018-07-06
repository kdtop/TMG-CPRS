unit fPtHTMLDemo;
//TMG added entire form
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, ORFn, ComCtrls, fBase508Form,
  VA508AccessibilityManager, uReports, uHTMLTools,
  TMGHTML2;

type
  TfrmPtHTMLDemo = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    cmdPrint: TButton;
    cmdNewPt: TButton;
    EditaPtButton: TButton;
    cmdClose: TButton;
    dlgPrintReport: TPrintDialog;
    procedure FormShow(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdNewPtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdPrintClick(Sender: TObject);
    procedure EditaPtButtonClick(Sender: TObject);  //kt 9/11
  private
    { Private declarations }
    FNewPt: Boolean;
  public
    { Public declarations }
    HTMLDemoViewer: THTMLObj;   //TMG
  end;

var
  frmPtHTMLDemo: TfrmPtHTMLDemo;


procedure PatientHTMLInquiry(var NewPt: Boolean);

implementation

{$R *.DFM}

uses
  fPtDemoEdit,  //kt 9/11
  fFrame,       //kt 9/11
  rCover, rReports, Printers, uCore;

procedure PatientHTMLInquiry(var NewPt: Boolean);
{ displays patient demographics, returns true in NewPt if the user pressed 'Select New' btn }
var
  frmPtHTMLDemo: TfrmPtHTMLDemo;
begin
  if StrToInt64Def(Patient.DFN, 0) <= 0 then exit;
  frmPtHTMLDemo := TfrmPtHTMLDemo.Create(Application);
  try
    with frmPtHTMLDemo do
    begin
      frmPtHTMLDemo.ShowModal;
      NewPt := FNewPt;
    end; {with frmPtHTMLDemo}
  finally
    frmPtHTMLDemo.Release;
  end;
end;

procedure TfrmPtHTMLDemo.FormCreate(Sender: TObject);
var
  MaxWidth, AHeight: Integer;
  Rect: TRect;
  rtDemographics: TStringList;  //added to assign richtext  elh 4/23/14
begin
  FNewPt := False;
  //Previous Line elh LoadDemographics(memPtDemo.Lines);
  //elh change begin
  MaxWidth := 350;  //tmg  moved from below
  rtDemographics := TStringList.Create;
  HTMLDemoViewer := THtmlObj.Create(pnlTop,Application);
  //HTMLDemoViewer.Anchors := [akLeft,akTop,akRight,akBottom];
  //HTMLDemoViewer.Left := 0;
  //HTMLDemoViewer.Top := 0;
  //HTMLDemoViewer.Width := pnlTop.Width;
  //HTMLDemoViewer.Height := pnlTop.Height;
  //HTMLDemoViewer.BringToFront;
  TWinControl(HtmlDemoViewer).Parent:=pnlTop;
  TWinControl(HtmlDemoViewer).Align:=alClient;
  LoadHTMLDemographics(rtDemographics);
  HTMLDemoViewer.BringToFront;
  FixHTML(rtDemographics);
  HTMLDemoViewer.Text := rtDemographics.Text;
  HTMLDemoViewer.Editable := false;
  HTMLDemoViewer.BackgroundColor := clCream;
  HTMLDemoViewer.Repaint;
  {for i := 0 to HTMLDemoViewer.Lines.Count - 1 do begin
    AWidth := lblFontTest.Canvas.TextWidth(memPtDemo.Lines[i]);
    if AWidth > MaxWidth then MaxWidth := AWidth;
  end;}
  //test only rtDemographics.Clear;
  //test only rtDemographics.Add('{\rtf1\ansi\deff0 {\fonttbl {\f0 Monotype Corsiva;}}');
  //test only rtDemographics.Add('\qc\f0\fs120\i\b Hello,\line World!}');
  rtDemographics.Free;
  ResizeAnchoredFormToFont(self);
                              // make sure at least 350 wide

  { width = borders + inset of memo box (left=8) }
  MaxWidth := MaxWidth + (GetSystemMetrics(SM_CXFRAME) * 2)
                       + GetSystemMetrics(SM_CXVSCROLL) + 16;
  { height = height of lines + title bar + borders + 4 lines (room for buttons) }


  //AHeight := ((memPtDemo.Lines.Count + 4) * (lblFontTest.Height + 1))
  //           + (GetSystemMetrics(SM_CYFRAME) * 3) + GetSystemMetrics(SM_CYCAPTION);


  AHeight := HigherOf(AHeight, 250);              // make sure at least 250 high
  if AHeight > (Screen.Height - 120) then AHeight := Screen.Height - 120;
  if MaxWidth > Screen.Width then MaxWidth := Screen.Width;
  Width := MaxWidth;
  Height := AHeight;
  Rect := BoundsRect;
  EditaPtButton.Visible := frmFrame.CheckForRPC(TMG_ADD_PATIENT_RPC);   //kt 9/11
  ForceInsideWorkArea(Rect);
  BoundsRect := Rect;
end;

procedure TfrmPtHTMLDemo.FormShow(Sender: TObject);
begin
  HTMLDemoViewer.Repaint;
end;

procedure TfrmPtHTMLDemo.cmdNewPtClick(Sender: TObject);
begin
  FNewPt := True;
  Close;
end;

procedure TfrmPtHTMLDemo.cmdCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPtHTMLDemo.cmdPrintClick(Sender: TObject);
var
  AHeader: TStringList;
  memPrintReport: TRichEdit;
  StartLine, MaxLines, LastLine, ThisPage, i: integer;
  ErrMsg: string;
  RemoteSiteID: string;    //for Remote site printing
  RemoteQuery: string;    //for Remote site printing
const
  PAGE_BREAK = '**PAGE BREAK**';
begin
  RemoteSiteID := '';
  RemoteQuery := '';
{  if dlgPrintReport.Execute then
    begin
      AHeader := TStringList.Create;
      CreatePatientHeader(AHeader, Self.Caption);
      memPrintReport := CreateReportTextComponent(Self);
      try
        MaxLines := 60 - AHeader.Count;
        LastLine := 0;
        ThisPage := 0;
        with memPrintReport do
          begin
            StartLine := 4;
            repeat
              with Lines do
                begin
                  AddStrings(AHeader);
                  for i := StartLine to MaxLines do
                    //if i < memPtDemo.Lines.Count - 1 then


                    if i < memPtDemo.Lines.Count then
                      Add(memPtDemo.Lines[LastLine + i])
                    else
                      Break;


                  LastLine := LastLine + i;
                  Add(' ');
                  Add(' ');
                  Add(StringOfChar('-', 74));
                  if LastLine >= memPtDemo.Lines.Count - 1 then
                    Add('End of report')
                  else
                    begin
                      ThisPage := ThisPage + 1;
                      Add('Page ' + IntToStr(ThisPage));
                      Add(PAGE_BREAK);
                      StartLine := 0;
                    end;
                end;
              until LastLine >= memPtDemo.Lines.Count - 1;
            PrintWindowsReport(memPrintReport, PAGE_BREAK, Self.Caption, ErrMsg);
          end;
      finally
        memPrintReport.Free;
        AHeader.Free;
      end;
    end;      }
  //memPtDemo.SelStart := 0;
  //memPtDemo.Invalidate;
end;

procedure TfrmPtHTMLDemo.EditaPtButtonClick(Sender: TObject);
//kt 9/11 added
var EditResult : integer;
begin
  //EditResult := frmPtHTMLDemoEdit.ShowModal;
  EditResult := EditPatientDemographics;
  Close;  //close this form
  if EditResult <> mrCancel then frmFrame.mnuFileRefreshClick(Sender);
end;


end.

end.

