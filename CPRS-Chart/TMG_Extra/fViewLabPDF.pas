unit fViewLabPDF;

//kt Entire unit and form added 10/2020
 (*
 Copyright 10/27/20 Kevin S. Toppenberg, MD
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
  Dialogs, StdCtrls, Buttons, OleCtrls, SHDocVw, ExtCtrls, ComCtrls, ORCtrls,
  ORFn, uCore, DateUtils,
  rFileTransferU, uHTMLTools, ORDtTm, ORDtTmRng
  ;

type
  TfrmViewLabPDF = class(TForm)
    pnlTopLeft: TPanel;
    pnlTopRight: TPanel;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    Splitter1: TSplitter;
    WebBrowser: TWebBrowser;
    btnDone: TBitBtn;
    ListBox: TListBox;
    cboDispDates: TComboBox;
    lblLabsToShow: TLabel;
    lblStartDate: TLabel;
    lblEndDate: TLabel;
    ORDateRangeDlg: TORDateRangeDlg;
    ORDateBoxSD: TORDateBox;
    ORDateBoxED: TORDateBox;
    ORDateTimeDlg: TORDateTimeDlg;
    btnPrev: TBitBtn;
    btnNext: TBitBtn;
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure ORDateBoxEDChange(Sender: TObject);
    procedure ORDateBoxSDChange(Sender: TObject);
    procedure cboDispDatesChange(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
  private
    { Private declarations }
    StartDate, EndDate : TFMDateTime;
    ChangingORDateBox : boolean;
    ChangingDispDates : boolean;
    function EarliestDate : TFMDateTime;
    function LatestDate : TFMDateTime;
    function BeginningOfDay(FMDateTime : TFMDateTime) : TFMDateTime;
    function EndOfDay(FMDateTime : TFMDateTime) : TFMDateTime;
    procedure SelectByDate(FMDateTime : TFMDateTime);
    procedure Initialize(InitFMDateTime : TFMDateTime = 0);
    procedure SetDate(ADate : TFMDateTime);
    procedure SetDateRange(AStartDate, AEndDate : TFMDateTime);
    procedure LoadLB(InfoList : TStringList);
    procedure ClearLB();
    procedure DisplayPDF(InfoObj : TPDFInfo);
    procedure ClearPDFDisplay;
    function EnsurePDFLocal(InfoObj : TPDFInfo) : TDownloadResult;
    procedure SetNextPrevBtnEnable();
  public
    { Public declarations }
  end;

 //var
 // frmViewLabPDF: TfrmViewLabPDF;  //not auto-intantiated.

procedure ShowLabReport(InitFMDateTime : TFMDateTime);

implementation
  uses fFrame;

type
tDatePick = (tdpOneDate=0,   //NOTE: These MUST match sequence if ITEMS of cboDispDates
             tdpDateRange=1,
             tdpOneWk=2,
             tdpOneMonth=3,
             tdpSixMonth=4,
             tdpOneYr=5,
             tdpTwoYrs=6,
             tdpAll=7
            );

{$R *.dfm}

procedure ShowLabReport(InitFMDateTime : TFMDateTime);
var
  frmViewLabPDF: TfrmViewLabPDF;
begin
  frmViewLabPDF := TfrmViewLabPDF.Create(Application);
  frmViewLabPDF.Initialize(InitFMDateTime);
  frmViewLabPDF.ShowModal;
  frmViewLabPDF.Free;
end;

//=====================================================================

procedure TfrmViewLabPDF.SelectByDate(FMDateTime : TFMDateTime);
var
  i : integer;
  InfoObj : TPDFInfo;
begin
  ListBox.ItemIndex := -1;
  for i := 0 to ListBox.Items.Count - 1 do begin
    InfoObj := TPDFInfo(ListBox.Items.Objects[i]);
    if not assigned(InfoObj) then continue;
    if InfoObj.LabDate <> FMDateTime then continue;
    ListBox.ItemIndex := i;
    ListBoxClick(nil);
    break;
  end;
  if ListBox.ItemIndex = -1 then begin
    ListBox.ItemIndex := 0;
    ListBoxClick(nil);
  end;
  
end;

procedure TfrmViewLabPDF.Initialize(InitFMDateTime : TFMDateTime = 0);
//var InfoList : TStringList;
    //TempStartDate,TempEndDate : TDateTime;
    //StartTime,EndTime : TDateTime;
    //ResultStr : string;
begin
  ChangingORDateBox := false;
  ChangingDispDates := false;
  SetDate(InitFMDateTime);
  self.Top := frmFrame.Top;
  self.Height := frmFrame.Height;
end;

function TfrmViewLabPDF.BeginningOfDay(FMDateTime : TFMDateTime) : TFMDateTime;
var TempStartDate : TDateTime;
begin
  TempStartDate := FMDateTimeToDateTime(FMDateTime);
  ReplaceTime(TempStartDate,EncodeTime(00,00,01,0));
  Result := DateTimeToFMDateTime(TempStartDate);
end;

function TfrmViewLabPDF.EndOfDay(FMDateTime : TFMDateTime) : TFMDateTime;
var TempEndDate : TDateTime;
begin
  TempEndDate := FMDateTimeToDateTime(FMDateTime);
  ReplaceTime(TempEndDate,EncodeTime(23,59,59,0));
  Result := DateTimeToFMDateTime(TempEndDate);
end;

procedure TfrmViewLabPDF.SetDate(ADate : TFMDateTime);
var AStartDate, AEndDate : TFMDateTime;
begin
  if ADate=0 then begin
    AStartDate:= EarliestDate;
    AEndDate := LatestDate;
    ChangingDispDates := true;
      cboDispDates.ItemIndex := ord(tdpDateRange);
    ChangingDispDates := false;
  end else begin
    AStartDate := BeginningOfDay(ADate);
    AEndDate := EndOfDay(ADate);
  end;
  SetDateRange(AStartDate, AEndDate);
end;


procedure TfrmViewLabPDF.SetDateRange(AStartDate, AEndDate : TFMDateTime);
var SameDay : boolean;
    InfoList : TStringList;
    TempStartDate,TempEndDate : TDateTime;
    StartTime,EndTime : TDateTime;
    ResultStr : string;

begin
  InfoList := TStringList.Create;
  try
    AStartDate := BeginningOfDay(AStartDate);
    AEndDate := EndOfDay(AEndDate);
    SameDay := (DateOf(FMDateTimeToDateTime(AStartDate)) = DateOf(FMDateTimeToDateTime(AEndDate)));
    lblStartDate.Visible := not SameDay;
    lblEndDate.Visible := not SameDay;
    ORDateBoxED.Visible := not SameDay;
    StartDate := AStartDate;
    EndDate := AEndDate;

    ChangingORDateBox := true; //short-circuit change event for ORDateBoxes
      ORDateBoxSD.FMDateTime := StartDate;
      ORDateBoxED.FMDateTime := EndDate;
    ChangingORDateBox := false;

    GetAvailLabPDFs(InfoList, Patient.DFN, StartDate, EndDate);
    if InfoList.Count > 0 then begin
      ResultStr := InfoList.Strings[0];
      if piece(ResultStr,'^',1) = '-1' then begin
        MessageDlg('Error: ' + Pieces(ResultStr, '^', 2, 99),mtError,[mbOK],0);
        exit;
      end;
    end;
    LoadLB(InfoList); //load results into listbox  -- OK if list is empty.
    SelectByDate(StartDate);
  finally
    InfoList.Free;
  end;
end;

function TfrmViewLabPDF.EarliestDate : TFMDateTime;
begin
  Result := DateTimeToFMDateTime(EncodeDate(1980, 1, 1));
end;

function TfrmViewLabPDF.LatestDate : TFMDateTime;
begin
  Result := DateTimeToFMDateTime(EncodeDate(2200, 12, 30));
end;

procedure TfrmViewLabPDF.btnNextClick(Sender: TObject);
begin
  if ListBox.ItemIndex < ListBox.Items.Count then ListBox.ItemIndex := ListBox.ItemIndex + 1;
  ListBoxClick(Sender);
  SetNextPrevBtnEnable();
end;


procedure TfrmViewLabPDF.btnPrevClick(Sender: TObject);
begin
  if ListBox.ItemIndex > 0 then ListBox.ItemIndex := ListBox.ItemIndex - 1;
  ListBoxClick(Sender);
  SetNextPrevBtnEnable();
end;

procedure TfrmViewLabPDF.SetNextPrevBtnEnable();
begin
  btnNext.Enabled := (ListBox.Items.Count > 0) and (ListBox.ItemIndex < ListBox.Items.Count-1);
  btnPrev.Enabled := (ListBox.ItemIndex > 0);
end;


procedure TfrmViewLabPDF.cboDispDatesChange(Sender: TObject);
begin
  if ChangingDispDates then exit;
  
  case tDatePick(cboDispDates.ItemIndex) of
    tdpOneDate:  begin
      if ORDateTimeDlg.Execute then begin
        SetDate(ORDateTimeDlg.FMDateTime);
      end;
    end;
    tdpDateRange: begin
      if ORDateRangeDlg.Execute then begin
        SetDateRange(OrDateRangeDlg.FMDateStart, OrDateRangeDlg.FMDateStop);
      end;
    end;
    tdpOneWk:    SetDateRange(DecFMDTDay(FMDTNow, 7),     FMDTNow);
    tdpOneMonth: SetDateRange(DecFMDTDay(FMDTNow, 30),    FMDTNow);
    tdpSixMonth: SetDateRange(DecFMDTDay(FMDTNow, 30*6),  FMDTNow);
    tdpOneYr:    SetDateRange(DecFMDTDay(FMDTNow, 365),   FMDTNow);
    tdpTwoYrs:   SetDateRange(DecFMDTDay(FMDTNow, 365*2), FMDTNow);
    tdpAll:      SetDateRange(EarliestDate, LatestDate);
  end;
end;


procedure TfrmViewLabPDF.ListBoxClick(Sender: TObject);
var
  InfoObj : TPDFInfo;
  i : integer;
begin
  i := ListBox.ItemIndex;
  if i = -1 then exit;
  InfoObj := TPDFInfo(ListBox.Items.Objects[i]);
  if EnsurePDFLocal(InfoObj) = drSuccess then begin
    DisplayPDF(InfoObj);
  end else begin
    //Clear PDF from browser.
    WebBrowser.Navigate('about:blank');
  end;
end;

procedure TfrmViewLabPDF.LoadLB(InfoList : TStringList);
var i : integer;
    InfoObj : TPDFInfo;
    s : string;
    DispText : string;

begin
  ClearLB();
  ClearPDFDisplay;
  for i := 1 to InfoList.Count - 1 do begin
    InfoObj := TPDFInfo.Create;
    s := InfoList.Strings[i];  //format SUBIEN^<RELATIVE PATH>^<FILE NAME>^FMDATE
    InfoObj.IEN := piece(s, '^',1);
    InfoObj.RelPath := piece(s, '^',2);
    InfoObj.FName := piece(s, '^',3);
    InfoObj.LabDate := StrToFloatDef(piece(s, '^',4),0);
    DispText := FormatFMDateTime('mmm dd, yyyy hh:nn', InfoObj.LabDate);
    ListBox.Items.AddObject(DispText,InfoObj);
  end;
  SetNextPrevBtnEnable();
end;

procedure TfrmViewLabPDF.ORDateBoxEDChange(Sender: TObject);
begin
  //handle change.
  if ChangingORDateBox then exit;
  SetDateRange(OrDateBoxSD.FMDateTime, OrDateBoxED.FMDateTime);
end;

procedure TfrmViewLabPDF.ORDateBoxSDChange(Sender: TObject);
begin
  if ChangingORDateBox then exit;
 //handle change.
  SetDateRange(OrDateBoxSD.FMDateTime, OrDateBoxED.FMDateTime);
end;

procedure TfrmViewLabPDF.ClearLB();
var i : integer;
begin
  //Before clearing, must free up TPDFInfo objects owned by Listbox.
  for i := 0 to ListBox.Items.Count-1 do begin
    TPDFInfo(ListBox.Items.Objects[i]).Free;
  end;
  ListBox.Items.Clear;
end;

procedure TfrmViewLabPDF.DisplayPDF(InfoObj : TPDFInfo);
begin
  if assigned(InfoObj) then begin
    WebBrowser.Navigate('file://'+InfoObj.LocalSaveFNamePath);
  end else begin
    ClearPDFDisplay;
  end;
end;

procedure TfrmViewLabPDF.ClearPDFDisplay;
begin
  WebBrowser.Navigate('about:blank');
end;


function TfrmViewLabPDF.EnsurePDFLocal(InfoObj : TPDFInfo) : TDownloadResult;
var
  ErrMsg  : string;
  TargetPDFFilename : string;
  TargetHTMLFilename : string;
begin
  result := drFailure; //default
  if not assigned(InfoObj) then exit;

  if InfoObj.LocalSaveFNamePath <> '' then begin
    if FileExists(InfoObj.LocalSaveFNamePath) then begin
      Result := drSuccess;
      exit;
    end;
  end;
  TargetPDFFilename := CacheDir + '\' + InfoObj.FName;
  TargetHTMLFilename := TargetPDFFilename + '.html';
  Result :=rFileTransferU.DownloadLabPDF(InfoObj.RelPath, InfoObj.FName, TargetPDFFilename, 0, 0, ErrMsg);
  if Result = drSuccess then begin
    MakePDFWrapperHTMLFile(TargetPDFFilename, TargetHTMLFilename);
    InfoObj.LocalSaveFNamePath := TargetHTMLFilename;
  end;
end;


end.
