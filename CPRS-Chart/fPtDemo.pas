unit fPtDemo;

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

(*  //kt 9/11 The following was edited in the **FORM** of this unit.

  object pnlTop: TORAutoPanel  <--- into this object (originally present)
    object EditaPtButton: TButton  <-- added this object.
      Left = 144
      Top = 8
      Width = 145
      Height = 21
      BiDiMode = bdRightToLeftNoAlign
      Caption = '&Edit Patient Demographics'
      ParentBiDiMode = False
      TabOrder = 3
      WordWrap = True
      OnClick = EditaPtButtonClick
    end
  end
  object pnlHTMLView: TPanel [1]  <-- added 9/4/15
    Left = 0
    Top = 0
    Width = 580
    Height = 234
    Align = alClient
    TabOrder = 2
  end

*)


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, ORFn, ComCtrls, fBase508Form,
  TMGHTML2, Buttons,    //tmg
  VA508AccessibilityManager, uReports;

type
  TDGViewModes = (vmText,vmHTML);         //kt 9/4/15

  TfrmPtDemo = class(TfrmBase508Form)
    lblFontTest: TLabel;
    memPtDemo: TRichEdit;
    pnlTop: TORAutoPanel;
    cmdNewPt: TButton;
    cmdClose: TButton;
    cmdPrint: TButton;
    dlgPrintReport: TPrintDialog;
    EditaPtButton: TButton;
    btnShowDueInfo: TKeyClickPanel;
    pnlHTMLView: TPanel;
    procedure FormDestroy(Sender: TObject);   //kt 9/4/15 <-- 10/24/2014
    procedure btnShowDueInfoClick(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdNewPtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdPrintClick(Sender: TObject);
    procedure EditaPtButtonClick(Sender: TObject);  //kt 9/11
  private
    { Private declarations }
    FViewMode : TDGViewModes;  //kt 9/4/15
    HTMLViewer : THtmlObj;     //kt 9/4/15
    FNewPt: Boolean;
    procedure SetDueColor;
    procedure SetViewModeAndLines(Mode : TDGViewModes; Lines : TStringList);  //kt 9/4/15
    procedure Initialize(); //kt 9/4/15
  public
    { Public declarations }
  end;

procedure PatientInquiry(var NewPt: Boolean);

implementation

{$R *.DFM}

uses
  fPtDemoEdit,  //kt 9/11
  fFrame,       //kt 9/11
  fMemoEdit,    //kt 10/2014
  uHTMLTools,   //kt 9/4/15
  rCover, rReports, Printers, uCore;

const
  vmHTML_MODE : array [false..true] of TDGViewModes = (vmText,vmHTML); //kt 9/15


procedure PatientInquiry(var NewPt: Boolean);
{ displays patient demographics, returns true in NewPt if the user pressed 'Select New' btn }
var
  frmPtDemo: TfrmPtDemo;
begin
  if StrToInt64Def(Patient.DFN, 0) <= 0 then exit;
  frmPtDemo := TfrmPtDemo.Create(Application);
  frmPtDemo.Initialize; //kt 9/4/15
  try
    with frmPtDemo do
    begin
      frmPtDemo.ShowModal;
      NewPt := FNewPt;
    end; {with frmPtDemo}
  finally
    frmPtDemo.Release;
  end;
end;

(* //kt 9/4/15 -- copy of Create function
procedure TfrmPtDemo.FormCreate(Sender: TObject);
var
  i, MaxWidth, AWidth, AHeight: Integer;
  Rect: TRect;
  DemographicsSL: TStringList;  //added to assign richtext  elh 4/23/14
begin
  FNewPt := False;
  //Previous Line elh LoadDemographics(memPtDemo.Lines);
  //elh change begin
  DemographicsSL := TStringList.Create;
  LoadDemographics(DemographicsSL);
  //test only DemographicsSL.Clear;
  //test only DemographicsSL.Add('{\rtf1\ansi\deff0 {\fonttbl {\f0 Monotype Corsiva;}}');
  //test only DemographicsSL.Add('\qc\f0\fs120\i\b Hello,\line World!}');

  memPtDemo.Lines.Clear;
  memPtDemo.text :=DemographicsSL.text;
  DemographicsSL.Free;
  memPtDemo.SelStart := 0;
  ResizeAnchoredFormToFont(self);
  MaxWidth := 350;                                // make sure at least 350 wide
  for i := 0 to memPtDemo.Lines.Count - 1 do
  begin
    AWidth := lblFontTest.Canvas.TextWidth(memPtDemo.Lines[i]);
    if AWidth > MaxWidth then MaxWidth := AWidth;
  end;
  { width = borders + inset of memo box (left=8) }
  MaxWidth := MaxWidth + (GetSystemMetrics(SM_CXFRAME) * 2)
                       + GetSystemMetrics(SM_CXVSCROLL) + 16;
  { height = height of lines + title bar + borders + 4 lines (room for buttons) }
  AHeight := ((memPtDemo.Lines.Count + 4) * (lblFontTest.Height + 1))
             + (GetSystemMetrics(SM_CYFRAME) * 3) + GetSystemMetrics(SM_CYCAPTION);
  AHeight := HigherOf(AHeight, 250);              // make sure at least 250 high
  if AHeight > (Screen.Height - 120) then AHeight := Screen.Height - 120;
  if MaxWidth > Screen.Width then MaxWidth := Screen.Width;
  Width := MaxWidth;
  Height := AHeight;
  Rect := BoundsRect;
  EditaPtButton.Visible := frmFrame.CheckForRPC(TMG_ADD_PATIENT_RPC);   //kt 9/11
  ForceInsideWorkArea(Rect);
  BoundsRect := Rect;
  SetDueColor; //kt 10/24/14
end;

*)

procedure TfrmPtDemo.FormCreate(Sender: TObject);
//kt -- major modifications to this procedure on 9/4/15.  Copy made above of prior content.
begin
  FNewPt := False;
  HtmlViewer := THtmlObj.Create(pnlHTMLView, Application);
  TWinControl(HtmlViewer).Parent:=pnlHTMLView;
  TWinControl(HtmlViewer).Align:=alClient;
  //Note: A 'loaded' function will initialize the THtmlObj's, but it can't be
  //      done until after this constructor is done, and this TfrmNotes has been
  //      assigned a parent.  So done elsewhere (in Initialize() below)
  UpdateReadOnlyColorScheme(HTMLViewer, TRUE);
end;

procedure TfrmPtDemo.FormDestroy(Sender: TObject);
//kt added 9/4/15
begin
  inherited;
  HtmlViewer.Free;
end;

procedure TfrmPtDemo.Initialize();
//kt added 9/4/15 to separate the creating of the form from the loading of text.
//  Moved code original found in the OnCreate function here...
var
  i, MaxWidth, AWidth, AHeight: Integer;
  Rect: TRect;
  DemographicsSL: TStringList;  //added to assign richtext  elh 4/23/14
begin
  HtmlViewer.Loaded;  //<-- if not done, object won't display HTML
  DemographicsSL := TStringList.Create;
  LoadDemographics(DemographicsSL);
  SetViewModeAndLines(vmHTML_MODE[IsHTML(DemographicsSL)], DemographicsSL); //kt 9/4/15
  DemographicsSL.Free;  //kt 9/4/15
  Constraints.MinHeight := pnlTop.Height + GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYHSCROLL) + 7;
  Rect := BoundsRect;
  EditaPtButton.Visible := frmFrame.CheckForRPC(TMG_ADD_PATIENT_RPC);   //kt 9/11
  ForceInsideWorkArea(Rect);
  BoundsRect := Rect;
  SetDueColor; //kt 10/24/14
end;

procedure TfrmPtDemo.SetViewModeAndLines(Mode : TDGViewModes; Lines : TStringList);
//kt addded function 9/4/15, moving prior code here and modifying.
var
  i, MaxWidth, AWidth, AHeight: Integer;
  Rect: TRect;
begin
  FViewMode := Mode;
  if Mode = vmHTML then begin
    memPtDemo.Visible := false;
    pnlHTMLView.Visible := True;
    HtmlViewer.Visible := true;
    HtmlViewer.BringToFront;
    FixHTML(Lines);
    HtmlViewer.HTMLText := Lines.Text;
    //HtmlViewer.Editable := false;
    //HtmlViewer.BackgroundColor := clCream;
    HtmlViewer.TabStop := true;
    RedrawActivate(HtmlViewer.Handle);
    //Later I can set this form's size to convenient height and width.
    Self.Height := frmFrame.Height-100;
    Self.Top := frmFrame.Top+50;
  end else begin
    pnlHTMLView.Visible := false;
    memPtDemo.Visible := true;
    memPtDemo.BringToFront;
    memPtDemo.Lines.Assign(Lines);
    memPtDemo.SelStart := 0;
    ResizeAnchoredFormToFont(self);
    MaxWidth := 350;                                // make sure at least 350 wide
    for i := 0 to memPtDemo.Lines.Count - 1 do begin
      AWidth := lblFontTest.Canvas.TextWidth(memPtDemo.Lines[i]);
      if AWidth > MaxWidth then MaxWidth := AWidth;
    end;
    // width = borders + inset of memo box (left=8)
    MaxWidth := MaxWidth + (GetSystemMetrics(SM_CXFRAME) * 2)
                         + GetSystemMetrics(SM_CXVSCROLL) + 16;
    // height = height of lines + title bar + borders + 4 lines (room for buttons)
    AHeight := ((memPtDemo.Lines.Count + 4) * (lblFontTest.Height + 1))
               + (GetSystemMetrics(SM_CYFRAME) * 3) + GetSystemMetrics(SM_CYCAPTION);
    AHeight := HigherOf(AHeight, 250);              // make sure at least 250 high
    if AHeight > (Screen.Height - 120) then AHeight := Screen.Height - 120;
    if MaxWidth > Screen.Width then MaxWidth := Screen.Width;
    Width := MaxWidth;
    Height := AHeight;
  end;
end;

procedure TfrmPtDemo.cmdNewPtClick(Sender: TObject);
begin
  FNewPt := True;
  Close;
end;

procedure TfrmPtDemo.btnShowDueInfoClick(Sender: TObject);
//kt added function  10/14

  procedure ParseOneLine(s : string; Lines : TStrings);
  var FMStr : string;
      TempS : string;
  begin
    FMStr := piece(s,'^',1);
    TempS := 'Note on ' + FormatFMDateTime('MM/DD/YY', MakeFMDateTime(FMStr));
    TempS := TempS + ' --> ';
    FMStr := piece(s,'^',2);
    if FMStr = '1' then FMStr := 'Inexact '
    else if FMStr = '-1' then FMStr := '??/??/??'
    else FMStr := FormatFMDateTime('MM/DD/YY', MakeFMDateTime(FMStr));
    TempS := TempS + 'followup due: ' + FMStr;
    //Lines.Add(TempS);
    TempS := TempS + '  "' + piece(s,'^',3) + '"';
    Lines.Add(TempS);
  end;

var i : integer;
    OneLine : String;
    frmMemoEdit: TfrmMemoEdit;

begin
  inherited;
  //MessageDlg('Here I can display info',mtInformation,[mbOK],0);
  frmMemoEdit := TfrmMemoEdit.Create(Self);
  frmMemoEdit.lblMessage.Caption := 'Follow up detail below.';
  frmMemoEdit.Caption := 'Follow up details.';
  for i := Patient.DueInfo.Count - 1 downto 2 do begin
    OneLine := Patient.DueInfo.Strings[i];
    ParseOneLine(OneLine, frmMemoEdit.memEdit.Lines);
  end;
  if frmMemoEdit.memEdit.Lines.Count = 0 then begin
    frmMemoEdit.memEdit.Lines.Add('(No information to display)');
end;
  frmMemoEdit.memEdit.ScrollBars := ssBoth;
  frmMemoEdit.memEdit.WordWrap := False;
  frmMemoEdit.ShowModal;
  FreeAndNil(frmMemoEdit);
end;

procedure TfrmPtDemo.SetDueColor;
//kt added function  10/14
begin
  btnShowDueInfo.Color := Patient.DueColorCode;
end;


procedure TfrmPtDemo.cmdCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPtDemo.cmdPrintClick(Sender: TObject);
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
  if FViewMode = vmHTML then begin
    MessageDlg('TO DO: Implement printing of HTMl demographics in fPtDemo''s TfrmPtDemo..cmdPrintClick', mtError, [mbOK], 0);
    exit;
  end;
  RemoteSiteID := '';
  RemoteQuery := '';
  if dlgPrintReport.Execute then
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
            PrintWindowsReport(memPrintReport, PAGE_BREAK, Self.Caption, ErrMsg, True);
          end;
      finally
        memPrintReport.Free;
        AHeader.Free;
      end;
    end;
  memPtDemo.SelStart := 0;
  memPtDemo.Invalidate;
end;

procedure TfrmPtDemo.EditaPtButtonClick(Sender: TObject);
//kt 9/11 added
var EditResult : integer;
begin
  //EditResult := frmPtDemoEdit.ShowModal;
  EditResult := EditPatientDemographics;
  Close;  //close this form
  if EditResult <> mrCancel then frmFrame.mnuFileRefreshClick(Sender);
end;

end.
