unit fProbLex;

 //kt NOTE: this is a dialog to search for ICD codes.
 //kt       And it may also be used for SNOMED codes.

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
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ORFn, uProbs, StdCtrls, Buttons, ExtCtrls, ORctrls, uConst,
  fAutoSz, uInit, fBase508Form, VA508AccessibilityManager, Grids, fProbFreetext,
  ComCtrls, Windows, rPCE, mTreeGrid;

type
  TfrmPLLex = class(TfrmBase508Form)
    {Label1: TLabel;}
    bbCan: TBitBtn;
    bbOK: TBitBtn;
    pnlStatus: TPanel;
    lblStatus: TVA508StaticText;
    ebLex: TCaptionEdit;
    bbSearch: TBitBtn;
    bbExtendedSearch: TBitBtn;
    pnlDialog: TPanel;
    pnlSearch: TPanel;
    pnlButtons: TPanel;
    pnlList: TPanel;
    lblSelect: TLabel;
    lblSearch: Tlabel;
    bbFreetext: TBitBtn;
    tgfLex: TTreeGridFrame;
    procedure EnableExtend;
    procedure DisableExtend;
    procedure EnableFreeText;
    procedure DisableFreeText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbOKClick(Sender: TObject);
    procedure bbCanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ebLexKeyPress(Sender: TObject; var Key: Char);
    procedure bbSearchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbExtendedSearchClick(Sender: TObject);
    procedure ebLexChange(Sender: TObject);
    procedure setClientWidth(tgf: TTreeGridFrame);
    procedure CenterForm(tgf: TTreeGridFrame; w: Integer);
    procedure bbFreetextClick(Sender: TObject);
    procedure tgfLextvChange(Sender: TObject; Node: TTreeNode);
    procedure tgfLextvEnter(Sender: TObject);
    procedure tgfLextvExit(Sender: TObject);
    procedure tgfLextvDblClick(Sender: TObject);
  private
    FExtendOffered: Boolean;
    FSuppressCodes: Boolean;
    FICDLookup: Boolean;
    FBuildingList: Boolean;
    FCenteringForm: Boolean;
    FICDVersion: String;
    FProblemNOS: String;
    FContinueNOS: String;
    FI10Active: Boolean;
    procedure SetICDVersion(ADate: TFMDateTime = 0);
    procedure updateStatus(status: String);
    procedure processSearch(Extend: Boolean);
    procedure SetColumnTreeModel(ResultSet: TStrings);
    function SaveFreetext: Boolean;
    { Private declarations }
  public
    { Public declarations }
    AutoSearchTerm : string;  //kt added 6/15
    procedure SetSearchString(sstring: String);
    function SetFreetextProblem: String;
  end;


implementation

uses
 fProbs, rProbs, fProbEdt, uCore, rCore
 , fPCELex  //kt 10/15
 ;

{$R *.DFM}

var
 ProblemNOSs: TStringList;
 TriedExtend: Boolean = false;

const
  TX799 = '799.9';
  TX_CONTINUE_799 = 'The term you selected is not yet mapped to an ICD-9-CM code. ' +
                    'If you select this term, an ICD-9-CM code of 799.9 will be entered into ' +
                    'the system and your selected term will be sent for review to be mapped ' +
                    'to an ICD-9-CM code. Until that process is completed, you will not be able ' +
                    'to choose your selected term from the Encounter Form pick list.' + CRLF + CRLF +
                    'Use ';
  TXR69 = 'R69.';
  TX_CONTINUE_R69 = 'The term you selected is not yet mapped to an ICD-10-CM code. ' +
                    'If you select this term, an ICD-10-CM code of R69. will be entered into ' +
                    'the system and your selected term will be sent for review to be mapped ' +
                    'to an ICD-10-CM code. Until that process is completed, you will not be able ' +
                    'to choose your selected term from the Encounter Form pick list.' + CRLF + CRLF +
                    'Use ';
  TX_FREETEXT_799  = 'A suitable term was not found based on user input and current defaults. ' +
                     'If you proceed with this nonspecific term, an ICD code of "799.9 - OTHER ' +
                     'UNKNOWN AND UNSPECIFIED CAUSE OF MORBIDITY OR MORTALITY" will ' +
                     'be filed.' + CRLF + CRLF + 'Use ';
  TX_EXTEND_SEARCH = 'A suitable term was not found in the Problem List subset of SNOMED CT. ' +
                     'If you''d like to extend your search to include the entire Clinical ' +
                     'Findings Hierarchy of SNOMED CT, click the Extend Search button. ';
  TX_CHOOSE        = 'You must select a valid term to identify your patient''s problem. Either click ' +
                     'on a term from the list, or click on the Extend Search button, to extend your ' +
                     'search to include the entire Clinical Findings Hierarchy of SNOMED CT.';
  SUPPRESS_CODES = False;

procedure TfrmPLLex.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ProblemNOSs.Free;
  Release;
end;

procedure TfrmPLLex.bbExtendedSearchClick(Sender: TObject);
begin
  TriedExtend := true;
  processSearch(true);
  DisableExtend;
  if (ebLex.Text <> '') and (lblstatus.Caption <> 'Code search failed by Extended Search.') then
    EnableFreeText;
end;

procedure TfrmPLLex.bbFreetextClick(Sender: TObject);
begin
  inherited;
  if not SaveFreetext then
    Exit;

  //save freetext problem
  PLProblem := SetFreetextProblem;
  {prevents GPF if system close box is clicked while frmDlgProbs is visible}
  if (not Application.Terminated) and (not uInit.TimedOut) then
    if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_PLLex, 0, 0);
  Close;
end;

procedure TfrmPLLex.updateStatus(status: String);
begin
  lblStatus.caption := status;
  lblStatus.Invalidate;
  lblStatus.Update;
end;

procedure TfrmPLLex.SetICDVersion(ADate: TFMDateTime = 0);
begin
  FICDVersion := Encounter.GetICDVersion;
  tgfLex.TargetTitle := Piece(FICDVersion, '^', 2) + ':  ';
  if Piece(FICDVersion, '^', 1) = 'ICD' then
  begin
    FProblemNOS := TX799;
    FContinueNOS := TX_CONTINUE_799;
    FI10Active := False;
    tgfLex.ShowTargetCode := True;
  end
  else
  begin
    FProblemNOS := TXR69;
    FContinueNOS := TX_CONTINUE_R69;
    FI10Active := True;
    tgfLex.ShowTargetCode := False;
  end;
end;

procedure TfrmPLLex.bbOKClick(Sender: TObject);

function setProblem: String;
var
  x, y: String;
  i: integer;
begin
  //kt e.g. '7298173^Plantar fasciitis^R69.^521774^SNOMED CT^202882003^311385019^ICD-10-CM|plantar fasciitis'
  //kt format of data: LEXIEN^PREFTEXT^ICDCODE(S)^ICDIEN^CODESYS^CONCEPTID^DESIGID^ICDVER^PARENTSUBSCRIPT
  //kt LEXIEN = IEN in 757.01 (EXPRESSIONS file)
  //kt ICDIEN = IEN in 80 (ICD DIAGNOSIS FILE)
  x := String(tgfLex.SelectedNode.Data);
  y := Piece(x, U, 2);
  i := Pos(' *', y);
  if i > 0 then y := Copy(y, 1, i - 1);
  SetPiece(x, U, 2, y);
  // e.g., Result = 7030665^Atrial arrhythmia^427.9^2566^SNOMED CT^17366009^29361012^ICD-9-CM|arrhyth
  Result := x + '|' + ebLex.Text;
end;
var ICDStr,ICDCode,ICDName,ICDIEN,ICDSys,Str,SCTName : string;  //kt added
begin
  {nothing entered, nothing selected - bail out}
  if (ebLex.Text = '') and (tgfLex.SelectedNode = nil) and (tgfLex.tv.Items.Count = 0) then
    Exit
  {nothing selected, or search returned void - suggest extended search}
  else if ((tgfLex.SelectedNode = nil) or (tgfLex.tv.Items.Count = 0)) then begin
    if TriedExtend then begin
      if not SaveFreetext then
        Exit;

      //save freetext problem
      PLProblem := SetFreetextProblem;
      Exit;
    end else begin
      if not FExtendOffered then begin
        if (tgfLex.tv.Items.Count = 0) then
          InfoBox(TX_EXTEND_SEARCH, 'Term not found', MB_OK or MB_ICONINFORMATION)
        else
          InfoBox(TX_CHOOSE, 'Term not selected', MB_OK or MB_ICONINFORMATION);
      end else begin
        if not SaveFreetext then
          Exit;
        PLProblem := SetFreetextProblem;
        if (not Application.Terminated) and (not uInit.TimedOut) then
          if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_PLLex, 0, 0);
        Close;
      end;
      EnableExtend;
      FExtendOffered := true;
    end;
    Exit;
  end
  else if TriedExtend and ((tgfLex.SelectedNode.Code = '')
    or ((tgfLex.SelectedNode.Code = FProblemNOS)
    and (ProblemNOSs.IndexOf(tgfLex.SelectedNode.Code) < 0))) then
  begin
    if (not FI10Active) and (InfoBox(FContinueNOS + UpperCase(tgfLex.SelectedNode.Text) + '?', 'Unmapped Problem Selected',
      MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then Exit;
    PLProblem := setProblem;
  end else
    PLProblem := setProblem;
  //kt begin mod ----------------------
  ICDStr := piece(PLProblem,'^',3);
  if ((Pos(TX799,ICDStr)>0) or (Pos(TXR69, ICDStr)>0)) and PLUser.usUseLexicon then begin
    Str := 'Select a linked ICD code';
    SCTName := Piece(PLProblem,'^',2);
    if SCTName <> '' then Str :=Str + ' to match: "' + SCTName + '"';
    LexiconLookup(ICDStr, LX_ICD, 0, True, PLProblem, Str);
    if ICDStr <> '' then begin
      //ICDStr output format = ICDCode^ICDName^ICDIEN^ICD-10-CM
      ICDCode := piece(ICDStr,'^',1);
      ICDName := piece(ICDStr,'^',2);
      ICDIEN := piece(ICDStr,'^',3);
      ICDSys := piece(ICDStr,'^',4);
      //PLProblem format:
      //kt e.g. '7298173^Plantar fasciitis^R69.^521774^SNOMED CT^202882003^311385019^ICD-10-CM|plantar fasciitis'
      //kt format of data: LEXIEN^PREFTEXT^ICDCODE(S)^ICDIEN^CODESYS^CONCEPTID^DESIGID^ICDVER^PARENTSUBSCRIPT
      SetPiece(PLProblem, '^',3,ICDCode);
      SetPiece(PLProblem, '^',3,ICDCode);
      SetPiece(PLProblem, '^',4,ICDIEN);
      SetPiece(PLProblem, '^',8,ICDSys+'|'+ICDName);
    end;
    //MessageDlg('Result = ' + ICDStr, mtConfirmation, [mbOK],0);
  end;
  //kt End mod ----------------------

  {prevents GPF if system close box is clicked while frmDlgProbs is visible}
  if (not Application.Terminated) and (not uInit.TimedOut) then
     if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_PLLex, 0, 0);
  Close;
end;

procedure TfrmPLLex.bbCanClick(Sender: TObject);
begin
 PLProblem:='';
 close;
end;

procedure TfrmPLLex.FormCreate(Sender: TObject);
var
  ADate: TFMDateTime;
begin
  ADate := 0;
  FExtendOffered := False;
  FBuildingList := False;
  FCenteringForm := False;
  FICDLookup := False;
  FSuppressCodes := PLUser.usSuppressCodes;
  AutoSearchTerm := '';  //kt added 6/15
  PLProblem := '';
  ProblemNOSs := TStringList.Create;
  ResizeAnchoredFormToFont(self);
  if not ((Encounter.VisitCategory = 'E') or (Encounter.VisitCategory = 'H')
    or (Encounter.VisitCategory = 'D')) then
      ADate := Encounter.DateTime;
  SetICDVersion(ADate);
  tgfLex.HorizPanelSpace := 8;
  tgfLex.VertPanelSpace := 4;
end;

procedure TfrmPLLex.ebLexKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    bbSearchClick(Sender);
    Key:=#0;
  end
  else
  begin
    lblStatus.caption:='';
  end;
end;

procedure TfrmPLLex.ebLexChange(Sender: TObject);
begin
  inherited;
  bbSearch.Default := True;
  bbOK.Default := False;
  DisableExtend;
  DisableFreeText;
  if tgfLex.tv.Items.Count > 0 then
  begin
    tgfLex.tv.Selected := nil;
    tgfLex.tv.Items.Clear;
    updateStatus('');
    CenterForm(tgfLex, Constraints.MinWidth);
  end;
end;

procedure TfrmPLLex.setClientWidth(tgf: TTreeGridFrame);
var
  i, maxw, tl, maxtl: integer;
  ctn: TLexTreeNode;
begin
  maxtl := 0;
  for i := 0 to pred(tgf.tv.Items.Count) do
  begin
    ctn := tgf.tv.Items[i] as TLexTreeNode;
    tl := TextWidthByFont(Font.Handle, ctn.Text);
    if (tl > maxtl) then
      maxtl := tl;
  end;

  maxw := maxtl + 30;

  if maxw < Constraints.MinWidth then
    maxw := Constraints.MinWidth;

  self.Width := maxw;

  //resize tv to maximum pixel width of its elements
  if (maxw > 0) and (self.ClientWidth <> maxw) then
  begin
    CenterForm(tgf, maxw);
  end;
end;

procedure TfrmPLLex.SetSearchString(sstring: String);
begin
  ebLex.Text := sstring;
  Invalidate;
end;

procedure TfrmPLLex.CenterForm(tgf: TTreeGridFrame; w: Integer);
var
  wdiff, mainw: Integer;
begin
  FCenteringForm := True;
  mainw := Application.MainForm.Width;

  if w > mainw then
  begin
    w := mainw;
  end;

  self.ClientWidth := w + (tgf.Width - tgf.ClientWidth) + (pnlList.Padding.Left + pnlList.Padding.Right);

  wdiff := ((mainw - self.Width) div 2);
  self.Left := Application.MainForm.Left + wdiff;

  invalidate;
  FCenteringForm := False;
end;

procedure TfrmPLLex.tgfLextvChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  tgfLex.tvChange(Sender, Node);
  if (tgfLex.SelectedNode = nil) then
  begin
    bbOK.Enabled := false;
    bbOK.Default := false;
  end
  else
  begin
    bbOK.Enabled := true;
    bbOK.Default := true;
    bbSearch.Default := false;
  end;
end;

procedure TfrmPLLex.tgfLextvDblClick(Sender: TObject);
begin
  inherited;
  bbOK.Enabled := true;
  bbOKClick(sender);
end;

procedure TfrmPLLex.tgfLextvEnter(Sender: TObject);
begin
  inherited;
  if (tgfLex.SelectedNode = nil) then
    bbOK.Enabled := false
  else
    bbOK.Enabled := true;
end;

procedure TfrmPLLex.tgfLextvExit(Sender: TObject);
begin
  inherited;
  if (tgfLex.SelectedNode = nil) then
    bbOK.Enabled := false
  else
    bbOK.Enabled := true;
end;

procedure TfrmPLLex.bbSearchClick(Sender: TObject);
begin
  TriedExtend := false;
  ProblemNOSs.Clear;
  DisableFreeText;
  processSearch(false);
end;

procedure TfrmPLLex.SetColumnTreeModel(ResultSet: TStrings);
var
  i: Integer;
  Node: TLexTreeNode;
  RecStr: String;
begin
  //  1     2        3      4       5       6         7          8     9
  //VUID^SCT TEXT^ICDCODE^ICDIEN^CODE SYS^CONCEPT^DESIGNATION^ICDVER^PARENT
  tgfLex.tv.Items.Clear;
  tgfLex.tv.Refresh;

  for i := 0 to ResultSet.Count - 1 do
  begin
    RecStr := ResultSet[i];
    if Piece(RecStr, '^', 9) = '' then
      Node := (tgfLex.tv.Items.Add(nil, Piece(RecStr, '^', 2))) as TLexTreeNode
    else
      Node := (tgfLex.tv.Items.AddChild(tgfLex.tv.Items[(StrToInt(Piece(RecStr, '^', 9))-1)], Piece(RecStr, '^', 2))) as TLexTreeNode;

    Node.ResultLine := RecStr;
    Node.VUID := Piece(RecStr, '^', 1);
    Node.Text := Piece(RecStr, '^', 2);
    Node.CodeDescription := Node.Text;
    Node.CodeIEN := Piece(RecStr, '^', 4);
    Node.CodeSys := Piece(RecStr, '^', 5);
    Node.Code := Piece(RecStr, '^', 6);
    Node.TargetCode := Piece(RecStr, '^', 3);
    Node.TargetCodeIEN := Piece(RecStr, '^', 4);
    Node.TargetCodeSys := Piece(RecStr, '^', 8);

    if Piece(RecStr, '^', 9) <> '' then
      Node.ParentIndex := IntToStr(StrToInt(Piece(RecStr, '^', 9)) - 1);

    //Data = pointer to RecStr
    Node.Data := Pointer(RecStr);

    if Piece(RecStr, '^', 1) = 'icd' then
    begin
      ebLex.SelectAll;
      ebLex.SetFocus;
      tgfLex.tv.Enabled := false;
      FICDLookup := True;
    end
    else
    begin
      tgfLex.tv.Enabled := True;
    end;
  end;
  //sort treenodes
  tgfLex.tv.AlphaSort(True);
end;

procedure TfrmPLLex.processSearch(Extend: Boolean);
const
  TX_SRCH_REFINE1 = 'Your search ';
  TX_SRCH_REFINE2 = ' matched ';
  TX_SRCH_REFINE3 = ' records, too many to display.' + CRLF + CRLF + 'Suggestions:' + CRLF +
                    #32#32#32#32#42 + '   Refine your search by adding more words' + CRLF + #32#32#32#32#42 + '   Try different keywords';
  MaxRec = 5000;
var
  ProblemList: TStringList;
  v, Max, subset: string;
  Match: TLexTreeNode;
  SvcCat: Char;
  DateOfInterest: TFMDateTime;
  FreqOfText: integer;
begin  {processSearch body}

  FICDLookup := False;

  if ebLex.text = '' then begin
   InfoBox('Enter a term to search for, then click "SEARCH"', 'Information', MB_OK or MB_ICONINFORMATION);
   exit; {don't bother to drop if no text entered}
  end;

  if Extend then begin
    subset := ' by Extended Search'
  end else begin
    subset := '';
  end;

  FBuildingList := True;

  ProblemList := TStringList.Create;
  try
    Screen.Cursor := crHourglass;
    updateStatus('Searching ' + subset + '...');

    v := uppercase(ebLex.text);
    FreqOfText := GetFreqOfText(v);
    if FreqOfText > MaxRec then begin
      InfoBox(TX_SRCH_REFINE1 + #39 + v + #39 + TX_SRCH_REFINE2 + IntToStr(FreqOfText) + TX_SRCH_REFINE3,'Refine Search', MB_OK or MB_ICONINFORMATION);
      lblStatus.Caption := '';
      Exit;
    end;

    SvcCat := Encounter.VisitCategory;
    if (SvcCat = 'E') or (SvcCat = 'H') then begin
      DateOfInterest := FMNow
    end else begin
      DateOfInterest := Encounter.DateTime;
    end;

    if (v <> '') then begin
      if Extend then begin
        ProblemList.Assign(ProblemLexiconSearch(v, DateOfInterest, True))
      end else begin
        ProblemList.Assign(ProblemLexiconSearch(v, DateOfInterest));
      end;
    end;
    if ProblemList.count > 0 then begin
      Max := ProblemList[pred(ProblemList.count)]; {get max number found}
      ProblemList.delete(pred(ProblemList.count)); {shed max# found}
      SetColumnTreeModel(ProblemList);
      SetClientWidth(tgfLex);
      UpdateStatus(Max + subset + '.');

      EnableExtend;
      ActiveControl := bbCan;

      if Max = 'Code search failed' then begin
       bbOk.Enabled := False;
       Exit;
      end;
      Match := tgfLex.FindNode(v);

      if Match <> nil then begin
        bbOk.Enabled := True;
      end else begin
        tgfLex.tv.Items[0].MakeVisible;
      end;
      if Piece(ProblemList.Strings[0],U,1) = 'icd' then begin
        bbOK.Enabled := False;
        bbExtendedSearch.Enabled := False;
      end else begin
        ActiveControl := tgfLex.tv;
        tgfLex.tv.Items[0].Selected := False;
      end;
    end else begin {search results are empty}
      updateStatus('No Entries Found ' + subset + ' for "' + ebLex.text + '"');
      if TriedExtend then begin
        if not SaveFreetext then
          Exit;
        PLProblem := SetFreetextProblem;
        if (not Application.Terminated) and (not uInit.TimedOut) then begin
          if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_PLLex, 0, 0);
        end;
        Close;
      end else begin
        EnableExtend;
        FExtendOffered := true;
      end;
    end;
  finally
    ProblemList.free;
    FBuildingList := False;
    Screen.Cursor := crDefault;
  end;
end;

function TfrmPLLex.SaveFreetext: Boolean;
var
  FTMsgDialog: TForm;
  SaveFT: Boolean;
begin
  SaveFT := False;
  FTMsgDialog := CreateFreetextMessage(UpperCase(ebLex.Text), FICDVersion);

  with FTMsgDialog do
  try
    Position := poOwnerFormCenter;

    if (ShowModal = ID_YES) then
    begin
      SaveFT := True;
    end;
    finally
      Free;

    Result := SaveFT;
  end;
end;

function TFrmPLLex.SetFreetextProblem: String;
var
  ICDCode: String;
begin
  if FI10Active then ICDCode := 'R69.' else ICDCode := '799.9';
  Result := '1^' + ebLex.Text + '^' + ICDCode + '^^^^|' + ebLex.Text;
end;

procedure TfrmPLLex.EnableExtend;
begin
  bbSearch.Enabled := false;
  bbExtendedSearch.Visible := true;
  bbExtendedSearch.Enabled := true;
  bbExtendedSearch.setFocus;
end;

procedure TfrmPLLex.DisableExtend;
begin
  bbSearch.Enabled := true;
  bbExtendedSearch.Enabled := false;
end;

procedure TfrmPLLex.EnableFreeText;
begin
  bbFreetext.Visible := true;
  bbFreetext.Enabled := true;
end;

procedure TfrmPLLex.DisableFreeText;
begin
  bbFreetext.Enabled := false;
  bbFreetext.Visible := false;
end;

procedure TfrmPLLex.FormShow(Sender: TObject);
begin
  ebLex.setfocus;
  RequestNTRT := False;
  if FSuppressCodes then
  begin
    tgfLex.ShowCode := False;
    tgfLex.ShowTargetCode := False;
  end
  else
  begin
    tgfLex.ShowCode := True;
    tgfLex.ShowTargetCode := not FI10Active;
  end;
 //kt begin mod 6/15
 if AutoSearchTerm <> '' then begin
   ebLex.Text := AutoSearchTerm;
   bbSearchClick(Sender);
 end;
 //kt end mod
  tgfLex.ShowDescription := True;

  CenterForm(tgfLex, tgfLex.ClientWidth);
end;

end.
