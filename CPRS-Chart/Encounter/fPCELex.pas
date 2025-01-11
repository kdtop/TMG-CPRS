unit fPCELex;

 //kt NOTE: this is a dialog to search for SNOMED CT codes. ?? and also ICD??

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, uCore,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, Buttons, VA508AccessibilityManager,
  StrUtils, //kt
  ComCtrls, fBase508Form, CommCtrl, mTreeGrid;

type
  TfrmPCELex = class;
  TPCELexFormTweaker = procedure(PCELexForm : TfrmPCELex) of object; //kt added
  TPCELexFormCBClick = procedure(PCELexForm : TfrmPCELex; value : boolean) of object; //kt added

  TfrmPCELex = class(TfrmBase508Form)
    txtSearch: TCaptionEdit;
    cmdSearch: TButton;
    pnlStatus: TPanel;
    pnlDialog: TPanel;
    pnlButtons: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    cmdExtendedSearch: TBitBtn;
    pnlSearch: TPanel;
    pnlList: TPanel;
    lblStatus: TVA508StaticText;
    lblSelect: TVA508StaticText;
    lblSearch: TLabel;
    tgfLex: TTreeGridFrame;
    cbShowCodes: TCheckBox;
    cbAddToTMGEncounter: TCheckBox;
    timerAutoSearch: TTimer;
    procedure timerAutoSearchTimer(Sender: TObject);  //kt added
    procedure tgfLextvCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure cbAddToTMGEncounterClick(Sender: TObject);   //kt added
    procedure cbShowCodesClick(Sender: TObject);
    procedure cmdSearchClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure txtSearchChange(Sender: TObject);
    procedure cmdExtendedSearchClick(Sender: TObject);
    function isNumeric(inStr: String): Boolean;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tgfLextvChange(Sender: TObject; Node: TTreeNode);
    procedure tgfLextvClick(Sender: TObject);
    procedure tgfLextvDblClick(Sender: TObject);
    procedure tgfLextvEnter(Sender: TObject);
    procedure tgfLextvExit(Sender: TObject);
    procedure tgfLextvHint(Sender: TObject; const Node: TTreeNode; var Hint: string);
    procedure tgfLextvExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
  private
    FLexApp: Integer;
    FSuppressCodes: Boolean;
    FCode:   string;
    FDate:   TFMDateTime;
    FICDVersion: String;
    FI10Active: Boolean;
    FExtend: Boolean;
    FMessage: String;
    FSingleCodeSys: Boolean;
    FCodeSys: String;
    FShowCodes : boolean; //kt
    FDisplayPieces : string; //kt
    FLexResults : TStringList; //kt
    FAutoSearchLastTime : TDateTime;  //kt
    FAutoSearchLastText : string;  //kt
    FEncounterCBChangeHandler : TPCELexFormCBClick; //kt added
    procedure SetNodeData(Node : TLexTreeNode; DataStr : string);
    procedure SearchClickAction();  //kt added
    function NodeDisplayText(Data : string) : string;  //kt added
    function ParseNarrCode(ANarrCode: String): String;
    procedure SetApp(LexApp: Integer);
    procedure SetDate(ADate: TFMDateTime);
    procedure SetICDVersion;
    procedure enableExtend;
    procedure disableExtend;
    procedure updateStatus(status: String);
    procedure SetColumnTreeModel(ResultSet: TStrings);
    procedure ProcessSearch;
    procedure DisplayLexResults(LexResults : TStringList); //kt
    procedure setClientWidth;
    procedure CenterForm(w: Integer);
    procedure SetOKEnable(Value : boolean);  //kt added
  public
    procedure SetupforTMGEncounter(OnChangeHandler : TPCELexFormCBClick); //kt added
  end;

procedure LexiconLookup(var Code: string;
                        ALexApp: Integer;
                        ADate: TFMDateTime = 0;
                        AExtend: Boolean = False;
                        AInputString: String = '';
                        AMessage: String = '';
                        ADefaultToInput: Boolean = False;
                        FormTweaker : TPCELexFormTweaker = nil //kt added
                       );

implementation

{$R *.DFM}

uses rPCE, uProbs, rProbs, UBAGlobals,
   DateUtils  //kt
   ;

var
  TriedExtend: Boolean = false;

procedure LexiconLookup(var Code: string;
                        ALexApp: Integer; //  This will be LX_ICD (12), LX_CPT(13), or LX_SCT(14);
                        ADate: TFMDateTime = 0;
                        AExtend: Boolean = False;
                        AInputString: String = '';
                        AMessage: String = '';
                        ADefaultToInput: Boolean = False;
                        FormTweaker : TPCELexFormTweaker = nil //kt added
                        );
var
  frmPCELex: TfrmPCELex;
begin
  frmPCELex := TfrmPCELex.Create(Application);
  try
    ResizeFormToFont(TForm(frmPCELex));
    if (ADate = 0) and not ((Encounter.VisitCategory = 'E') or (Encounter.VisitCategory = 'H')
      or (Encounter.VisitCategory = 'D')) then
        ADate := Encounter.DateTime;
    if ADefaultToInput and (AInputString <> '') then
      frmPCELex.txtSearch.Text := Piece(frmPCELex.ParseNarrCode(AInputString), U, 2);
    frmPCELex.SetApp(ALexApp);
    frmPCELex.SetDate(ADate);
    frmPCELex.SetICDVersion;
    frmPCELex.FMessage := AMessage;
    frmPCELex.FExtend := AExtend;
    if (ALexApp = LX_ICD) then
      frmPCELex.FExtend := True;
    if assigned(FormTweaker) then begin  //kt added this block.
      FormTweaker(frmPCELex);
    end;
    frmPCELex.ShowModal;
    Code := frmPCELex.FCode;
    if (AInputString <> '') and (Pos('(SCT', AInputString) > 0) and (ALexApp <> LX_SCT) then
      SetPiece(Code, U, 2, AInputString);
  finally
    frmPCELex.Free;
  end;
end;

//======================================================================
procedure TfrmPCELex.SetupforTMGEncounter(OnChangeHandler : TPCELexFormCBClick);
//kt added
//NOTE: This will be called by one of the forms that uses this form.
begin
  cbAddToTMGEncounter.Visible := true;
  cbAddToTMGEncounter.Enabled := false;
  FEncounterCBChangeHandler := OnChangeHandler;
end;

procedure TfrmPCELex.cbAddToTMGEncounterClick(Sender: TObject);
//kt added
begin
  inherited;
  if assigned(FEncounterCBChangeHandler) then begin
    FEncounterCBChangeHandler(self, cbAddToTMGEncounter.checked);
  end;
end;

procedure TfrmPCELex.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FLexResults.Free; //kt
  Release;
end;

procedure TfrmPCELex.FormCreate(Sender: TObject);
var
  UserProps: TStringList;
begin
  inherited;
  FCode := '';
  FCodeSys := '';
  FI10Active := False;
  FSingleCodeSys := True;
  FExtend := False;
  FShowCodes := false; //kt
  FDisplayPieces := '2'; //kt
  FLexResults := TStringList.Create; //kt
  FEncounterCBChangeHandler := nil; //kt
  UserProps := TStringList.Create;
  FastAssign(InitUser(User.DUZ), UserProps);
  PLUser := TPLUserParams.create(UserProps);
  FSuppressCodes := PLUser.usSuppressCodes;
  ResizeAnchoredFormToFont(self);
end;

procedure TfrmPCELex.FormShow(Sender: TObject);
var
  lt: String;
  dh, lh: Integer;
begin
  inherited;

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

  tgfLex.ShowDescription := True;
  tgfLex.HorizPanelSpace := 8;
  tgfLex.VertPanelSpace := 4;

  if FMessage <> '' then
  begin
    lt := lblSearch.Caption;
    lh := lblSearch.Height;
    lblSearch.AutoSize := True;
    lblSearch.Caption := FMessage + CRLF + CRLF + lt;
    lblSearch.AutoSize := False;
    dh := (lblSearch.Height - lh);
    pnlSearch.Height := pnlSearch.Height + dh;
    Height := Height + dh;
  end;
  CenterForm(tgfLex.ClientWidth);
  if FExtend and (txtSearch.Text <> '') then
  begin
    if FExtend then
      cmdExtendedSearch.Click
    else
      cmdSearch.Click;
  end;
end;

procedure TfrmPCELex.SetApp(LexApp: Integer);
var w : integer;
begin
  FLexApp := LexApp;
  case LexApp of
  LX_ICD: begin
            Caption := 'Lookup Diagnosis';
            lblSearch.Caption := 'Search for Diagnosis:';
          end;
  LX_CPT: begin
            Caption := 'Lookup Procedure';
            lblSearch.Caption := 'Search for Procedure:';
          end;
  end;
end;

procedure TfrmPCELex.SetDate(ADate: TFMDateTime);
begin
  FDate := ADate;
end;

procedure TfrmPCELex.SetICDVersion;
begin
  FICDVersion := Encounter.GetICDVersion;
  if (Piece(FICDVersion, '^', 1) = '10D') then
    FI10Active := True;
  cmdExtendedSearch.Hint := 'Search ' + Piece(FICDVersion, '^', 2) + ' Diagnoses...';
  tgfLex.pnlTargetCodeSys.Caption := Piece(FICDVersion, '^', 2) + ':  ';
end;

procedure TfrmPCELex.enableExtend;
begin
  cmdExtendedSearch.Visible := true;
  cmdExtendedSearch.Enabled := true;
end;

procedure TfrmPCELex.disableExtend;
begin
  cmdExtendedSearch.Enabled := false;
  cmdExtendedSearch.Visible := false;
  if not FI10Active then
    FExtend := False;
end;

procedure TfrmPCELex.txtSearchChange(Sender: TObject);
begin
  inherited;
  cmdSearch.Default := True;
  cmdOK.Default := False;
  cmdCancel.Default := False;
  disableExtend;
  //kt begin mod
  if not timerAutoSearch.Enabled then begin
    //Only turn on autosearch with CPT's.  Other searches are not fast enough to return results dynamically
    if false and (FLexApp = LX_CPT) then begin
      timerAutoSearch.Enabled := true;
      timerAutoSearch.Interval := 500;
      FAutoSearchLastTime := Now;
      FAutoSearchLastText := txtSearch.Text;
    end;
    //original block
    if tgfLex.tv.Items.Count > 0 then begin
      tgfLex.tv.Selected := nil;
      tgfLex.tv.Items.Clear;
      CenterForm(Constraints.MinWidth);
    end;
    //end original block
  end;
  //kt end mod
end;

procedure TfrmPCELex.timerAutoSearchTimer(Sender: TObject);
//kt added
begin
  inherited;
  if FAutoSearchLastText = txtSearch.Text then begin
    FAutoSearchLastTime := now;
    exit;
  end;
  if (MilliSecondsBetween(now, FAutoSearchLastTime) >1000) then begin
    FAutoSearchLastTime := now;
    FAutoSearchLastText := txtSearch.Text;
    SearchClickAction();
    txtSearch.SetFocus;
  end;
end;

procedure TfrmPCELex.cmdSearchClick(Sender: TObject);
begin
  //kt timerAutoSearch.Enabled := true;  //kt
  SearchClickAction();
  {//kt split to SearchClickAction below.
  TriedExtend := false;
  FCodeSys := '';
  FSingleCodeSys := True;
  if not FI10Active and (FLexApp = LX_ICD) then
    FExtend := False;
  if not tgfLex.pnlTarget.Visible then tgfLex.pnlTarget.Visible := True;
  processSearch;
  }
end;

procedure TfrmPCELex.SearchClickAction();
//kt added, splitting out from cmdSearchClick()
begin
  TriedExtend := false;
  FCodeSys := '';
  FSingleCodeSys := True;
  if not FI10Active and (FLexApp = LX_ICD) then
    FExtend := False;
  if not tgfLex.pnlTarget.Visible then tgfLex.pnlTarget.Visible := True;
  processSearch;
end;

procedure TfrmPCELex.setClientWidth;
var
  i, maxw, tl, maxtl: integer;
  ctn: TLexTreeNode;
begin
  maxtl := 0;
  for i := 0 to pred(tgfLex.tv.Items.Count) do
  begin
    ctn := tgfLex.tv.Items[i] as TLexTreeNode;
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
    CenterForm(maxw);
  end;
end;

procedure TfrmPCELex.cbShowCodesClick(Sender: TObject);
//kt added
begin
  inherited;
  FShowCodes := cbShowCodes.Checked;
  //  1       2         3     4       5            6            7           8
  //VUID^Description^CodeSys^Code^TargetCodeSys^TargetCode^DesignationID^Parent
  if FShowCodes then begin
    FDisplayPieces := '2,4';
  end else begin
    FDisplayPieces := '2';
  end;
  DisplayLexResults(FLexResults);
end;

procedure TfrmPCELex.CenterForm(w: Integer);
var
  wdiff, mainw: Integer;
begin
  mainw := Application.MainForm.Width;

  if w > mainw then
  begin
    w := mainw;
  end;

  self.ClientWidth := w + (tgfLex.Width - tgfLex.ClientWidth) + (pnlList.Padding.Left + pnlList.Padding.Right);

  wdiff := ((mainw - self.Width) div 2);
  self.Left := Application.MainForm.Left + wdiff;

  invalidate;
end;

function TfrmPCELex.NodeDisplayText(Data : string) : string;  //kt added
var i : integer;
    PceStr : string;
    Pce : integer;
begin
  Result := '';
  for i := 1 to NumPieces(FDisplayPieces,',') do begin
    if Result <> '' then Result := Result + ' - ';
    PceStr := Piece(FDisplayPieces, ',', i);
    Pce := StrToIntDef(PceStr,-1);
    if Pce = -1 then continue;
    Result := Result + Piece(Data,'^',Pce);
  end;
end;


procedure TfrmPCELex.SetColumnTreeModel(ResultSet: TStrings);
//kt added DisplayPieces.  Example: '6,2,3'
var
  i: Integer;
  Node, StubNode: TLexTreeNode;
  RecStr: string;
  NodeText : string; //kt

begin
  tgfLex.tv.Items.Clear;
  for i := 0 to ResultSet.Count - 1 do begin
    //RecStr = VUID^Description^CodeSys^Code^TargetCodeSys^TargetCode^DesignationID^Parent
    RecStr := ResultSet[i];
    NodeText := NodeDisplayText(RecStr);  //kt added
    if Piece(RecStr, '^', 8) = '' then begin
      //kt Node := (tgfLex.tv.Items.Add(nil, Piece(RecStr, '^', 2))) as TLexTreeNode
      Node := (tgfLex.tv.Items.Add(nil, NodeText)) as TLexTreeNode;  //kt
    end else begin
      //kt Node := (tgfLex.tv.Items.AddChild(tgfLex.tv.Items[(StrToInt(Piece(RecStr, '^', 8))-1)], Piece(RecStr, '^', 2))) as TLexTreeNode;
      Node := (tgfLex.tv.Items.AddChild(tgfLex.tv.Items[(StrToInt(Piece(RecStr, '^', 8))-1)], NodeText)) as TLexTreeNode;
    end;

    SetNodeData(Node, RecStr); //kt

    {
    with Node do begin
      VUID := Piece(RecStr, '^', 1);
      //kt Text := Piece(RecStr, '^', 2);
      Text := NodeText;   //kt
      //kt CodeDescription := Text;
      CodeDescription := Piece(RecStr, '^', 2);  //kt
      CodeSys := Piece(RecStr, '^', 3);

      if ((FCodeSys <> '') and (CodeSys <> FCodeSys)) then
        FSingleCodeSys := False;

      FCodeSys := CodeSys;

      Code := Piece(RecStr, '^', 4);

      if Piece(RecStr, '^', 8) <> '' then
        ParentIndex := IntToStr(StrToInt(Piece(RecStr, '^', 8)) - 1);

      //TODO: Need to accommodate Designation Code in ColumnTreeNode...
      if CodeSys = 'SNOMED CT' then begin
        CodeIEN := Code
      end else begin
        CodeIEN := Piece(RecStr, '^', 9);
      end;

      TargetCode := Piece(RecStr, '^', 6);
    end;
    }

    if (Node.VUID = '+') then begin
      StubNode := (tgfLex.tv.Items.AddChild(Node, 'Searching...')) as TLexTreeNode;
      with StubNode do begin
        VUID := '';
        Text := 'Searching...';
        CodeDescription := Text;
        CodeSys := 'ICD-10-CM';

        if ((FCodeSys <> '') and (CodeSys <> FCodeSys)) then
          FSingleCodeSys := False;

        FCodeSys := CodeSys;

        Code := '';
        CodeIEN := '';

        ParentIndex := IntToStr(Node.Index);
      end;
    end;
  end;
  //sort treenodes
  tgfLex.tv.AlphaSort(True);
end;

procedure TfrmPCELex.SetOKEnable(Value : boolean);  //kt added
begin
  cmdOK.Default := Value;
  cmdOK.Enabled := Value;
  cbAddToTMGEncounter.Enabled := Value;
end;

procedure TfrmPCELex.ProcessSearch;
const
  TX_SRCH_REFINE1 = 'Your search ';
  TX_SRCH_REFINE2 = ' matched ';
  TX_SRCH_REFINE3 = ' records, too many to display.' + CRLF + CRLF + 'Suggestions:' + CRLF +
                    #32#32#32#32#42 + '   Refine your search by adding more words' + CRLF + #32#32#32#32#42 + '   Try different keywords';
  MaxRec = 5000;

var
  //kt LexResults: TStringList;
  //found : string;
  subset, SearchStr: String;
  FreqOfText: integer;
  //Match: TLexTreeNode;

begin
  if Length(txtSearch.Text) = 0 then begin
   InfoBox('Enter a term to search for, then click "SEARCH"', 'Information', MB_OK or MB_ICONINFORMATION);
   exit; {don't bother to drop if no text entered}
  end;

  if (FLexApp = LX_ICD) or (FLexApp = LX_SCT) then begin
    if FExtend and (FLexApp = LX_ICD) then begin
      subset := Piece(FICDVersion, '^', 2) + ' Diagnoses'
    end else begin
      subset := 'SNOMED CT Concepts';
    end;
  end else if FLexApp = LX_CPT then begin
    subset := 'Current Procedural Terminology (CPT)'
  end else begin
    subset := 'Clinical Lexicon';
  end;

  //kt LexResults := TStringList.Create;

  //try
    Screen.Cursor := crHourGlass;
    updateStatus('Searching ' + subset + '...');
    SearchStr := Uppercase(txtSearch.Text);
    FreqOfText := GetFreqOfText(SearchStr);
    if (FreqOfText > MaxRec) and (FLexApp <> LX_CPT) then begin  //kst added  'and (FLexApp <> LX_CPT)'
      InfoBox(TX_SRCH_REFINE1 + #39 + SearchStr + #39 + TX_SRCH_REFINE2 + IntToStr(FreqOfText) + TX_SRCH_REFINE3,'Refine Search', MB_OK or MB_ICONINFORMATION);
      lblStatus.Caption := '';
      Screen.Cursor := crDefault;
      Exit;
    end;
    //kt ListLexicon(LexResults, SearchStr, FLexApp, FDate, FExtend, FI10Active);
    ListLexicon(FLexResults, SearchStr, FLexApp, FDate, FExtend, FI10Active);  //kt

    DisplayLexResults(FLexResults); //kt
    { //kt split out to below.
    if (Piece(LexResults[0], u, 1) = '-1') then begin
      found := '0 matches found';
      if FExtend then begin
        found := found + ' by ' + subset + ' Search.'
      end else begin
        found := found + '.';
      end;
      lblSelect.Visible := False;
      txtSearch.SetFocus;
      txtSearch.SelectAll;
      cmdOK.Default := False;
      cmdOK.Enabled := False;
      tgfLex.tv.Enabled := False;
      tgfLex.tv.Items.Clear;
      cmdCancel.Default := False;
      cmdSearch.Default := True;
      if not FExtend and (FLexApp = LX_ICD) then begin
        cmdExtendedSearch.Click;
        Exit;
      end;
    end else begin
      found := inttostr(LexResults.Count) + ' matches found';
      if FExtend then begin
        found := found + ' by ' + subset + ' Search.'
      end else begin
        found := found + '.';
      end;

      SetColumnTreeModel(LexResults);

      setClientWidth;
      lblSelect.Visible := True;
      tgfLex.tv.Enabled := True;
      tgfLex.tv.SetFocus;

      Match := tgfLex.FindNode(SearchStr);

      if Match <> nil then begin  //search term is on return list, so highlight it
        cmdOk.Enabled := True;
        ActiveControl := tgfLex.tv;
      end else begin
        tgfLex.tv.Items[0].Selected := False;
      end;

      if (not FExtend) and (FLexApp = LX_ICD) and (not isNumeric(txtSearch.Text)) then begin
        enableExtend;
      end;
      cmdSearch.Default := False;
    end;
    updateStatus(found);
    if FExtend then tgfLex.pnlTarget.Visible := False;
  finally
    LexResults.Free;
    Screen.Cursor := crDefault;
  end;
  }
  Screen.Cursor := crDefault;
end;

procedure TfrmPCELex.DisplayLexResults(LexResults : TStringList);
//kt added, splitting out of processSearch

var
  found, subset, SearchStr: String;
  //FreqOfText: integer;
  Match: TLexTreeNode;
  SrchResults : string;

begin
  SrchResults := IfThen(LexResults.Count>0, LexResults[0], '-1'); //kt
  if (Piece(SrchResults, u, 1) = '-1') then begin
    found := '0 matches found';
    if FExtend then begin
      found := found + ' by ' + subset + ' Search.'
    end else begin
      found := found + '.';
    end;
    lblSelect.Visible := False;
    txtSearch.SetFocus;
    txtSearch.SelectAll;
    //kt cmdOK.Default := False;
    //kt cmdOK.Enabled := False;
    SetOKEnable(False) ;//kt
    tgfLex.tv.Enabled := False;
    tgfLex.tv.Items.Clear;
    cmdCancel.Default := False;
    cmdSearch.Default := True;
    if not FExtend and (FLexApp = LX_ICD) then begin
      cmdExtendedSearch.Click;
      Exit;
    end;
  end else begin
    found := inttostr(LexResults.Count) + ' matches found';
    if FExtend then begin
      found := found + ' by ' + subset + ' Search.'
    end else begin
      found := found + '.';
    end;

    SetColumnTreeModel(LexResults);

    setClientWidth;
    lblSelect.Visible := True;
    tgfLex.tv.Enabled := True;
    tgfLex.tv.SetFocus;

    Match := tgfLex.FindNode(SearchStr);

    if Match <> nil then begin  {search term is on return list, so highlight it}
      //kt cmdOk.Enabled := True;
      SetOKEnable(True) ;//kt
      ActiveControl := tgfLex.tv;
    end else begin
      tgfLex.tv.Items[0].Selected := False;
    end;

    if (not FExtend) and (FLexApp = LX_ICD) and (not isNumeric(txtSearch.Text)) then begin
      enableExtend;
    end;
    cmdSearch.Default := False;
  end;
  updateStatus(found);
  if FExtend then tgfLex.pnlTarget.Visible := False;
end;

procedure TfrmPCELex.cmdExtendedSearchClick(Sender: TObject);
begin
  inherited;
  FExtend := True;
  FCodeSys := '';
  FSingleCodeSys := True;
  processSearch;
  disableExtend;
end;

procedure TfrmPCELex.cmdOKClick(Sender: TObject);
var
  Node: TLexTreeNode;
begin
  inherited;
  if(tgfLex.SelectedNode = nil) then
    Exit;
  Node := tgfLex.SelectedNode;
  if ((FLexApp = LX_ICD) or (FLexApp = LX_SCT)) and (Node.Code <> '') then
  begin
    if (Copy(Node.CodeSys, 0, 3) = 'ICD') then
      FCode := Node.Code + U + Node.Text
    else if (Copy(Node.CodeSys, 0, 3) = 'SNO')  then
      FCode := Node.TargetCode + U + Node.Text + ' (SNOMED CT ' + Node.Code + ')';

    FCode := FCode + U + Node.CodeIEN + U + Node.CodeSys;
  end
  else if BAPersonalDX then
    FCode := LexiconToCode(StrToInt(Node.VUID), FLexApp, FDate) + U + Node.Text + U + Node.VUID
  else
    FCode := LexiconToCode(StrToInt(Node.VUID), FLexApp, FDate) + U + Node.Text;
  Close;
end;

procedure TfrmPCELex.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FCode := '';
  Close;
end;

procedure TfrmPCELex.tgfLextvChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  tgfLex.tvChange(Sender, Node);
  if (tgfLex.SelectedNode = nil) or (tgfLex.SelectedNode.VUID = '+')  then
  begin
    //kt cmdOK.Enabled := false;
    //kt cmdOk.Default := false;
    SetOKEnable(False) ;//kt

  end
  else  // valid Node selected
  begin
    //kt cmdOK.Enabled := true;
    //kt cmdOK.Default := true;
    SetOKEnable(True) ;//kt
    cmdSearch.Default := false;
  end;
end;

procedure TfrmPCELex.tgfLextvClick(Sender: TObject);
begin
  inherited;
  if(tgfLex.SelectedNode <> nil) and (tgfLex.SelectedNode.VUID <> '+') then
  begin
    //kt cmdOK.Enabled := true;
    //kt cmdOK.Default := True;
    SetOKEnable(True) ;//kt
    cmdSearch.Default := False;
  end;
end;

procedure TfrmPCELex.tgfLextvCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);

  function HTMLToColor(const HTMLColor:string):TColor;
  var
    Red,Green,Blue: Byte;
    HexColor:string;
  begin
    if HTMLColor[1] = '#' then
      HexColor := Copy(HTMLColor, 2, Length(HTMLColor) - 1)
    else
      HexColor := HTMLColor;

    Red := StrToInt('$' + Copy(HexColor,1,2));
    Green := StrToInt('$' + Copy(HexColor,3,2));
    Blue := StrToInt('$' + Copy(HexColor,5,2));

    Result := (Blue shl 16) or (Green shl 8) or Red;
  end;

var
  ctn: TLexTreeNode;
begin
  inherited;
  ctn := Node as TLexTreeNode;
  if ctn.color<>'' then begin
    Sender.Canvas.Brush.Color := HTMLToColor(ctn.color);
  end;
  DefaultDraw := True;
end;

procedure TfrmPCELex.tgfLextvDblClick(Sender: TObject);
begin
  inherited;
  tgfLextvClick(Sender);
  if tgfLex.SelectedNode.VUID <> '+' then
    cmdOKClick(Sender);
end;

procedure TfrmPCELex.tgfLextvEnter(Sender: TObject);
begin
  inherited;
  SetOKEnable(tgfLex.SelectedNode <> nil) ;//kt
  {//kt
  if (tgfLex.SelectedNode = nil) then
    cmdOK.Enabled := false
  else
    cmdOK.Enabled := true;
  } //kt
end;

procedure TfrmPCELex.tgfLextvExit(Sender: TObject);
begin
  inherited;
  SetOKEnable(tgfLex.SelectedNode <> nil) ;//kt
  {  //kt
  if (tgfLex.SelectedNode = nil) then
    cmdOK.Enabled := false
  else
    cmdOK.Enabled := true;
  }
end;

procedure TfrmPCELex.SetNodeData(Node : TLexTreeNode; DataStr : string);
//kt added, combining common code for nodes and child nodes.
var
  NodeText : string;
begin
  NodeText := NodeDisplayText(DataStr);  //kt added
  with Node do begin
    VUID := Piece(DataStr, '^', 1);
    //kt Text := Piece(DataStr, '^', 2);
    Text := NodeText;   //kt
    //kt CodeDescription := Text;
    CodeDescription := Piece(DataStr, '^', 2);  //kt
    CodeSys := Piece(DataStr, '^', 3);

    if ((FCodeSys <> '') and (CodeSys <> FCodeSys)) then
      FSingleCodeSys := False;

    FCodeSys := CodeSys;

    Code := Piece(DataStr, '^', 4);

    Color := Piece(DataStr, '^', 15);     //TMG added 4/11/24
    LongDescr := AnsiReplaceStr(Piece(DataStr, '^', 16),'\n',#13#10); //TMG added 11/13/24

    if Piece(DataStr, '^', 8) <> '' then
      ParentIndex := IntToStr(StrToInt(Piece(DataStr, '^', 8)) - 1);

    //TODO: Need to accommodate Designation Code in ColumnTreeNode...
    if CodeSys = 'SNOMED CT' then
      CodeIEN := Code
    else
      CodeIEN := Piece(DataStr, '^', 9);

    TargetCode := Piece(DataStr, '^', 6);
  end;
end;


procedure TfrmPCELex.tgfLextvExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  ctNode, ChildNode, StubNode: TLexTreeNode;
  ChildRecs: TStringList;
  RecStr: String;
  i: integer;
begin
  inherited;
  ctNode := Node as TLexTreeNode;

  if ctNode.VUID = '+' then
  begin
    ChildRecs := TStringList.Create;
    ListLexicon(ChildRecs, ctNode.Code, FLexApp, FDate, True, FI10Active);

    //clear node's placeholder child
    ctNode.DeleteChildren;

    //create children
    for i := 0 to ChildRecs.Count - 1 do begin
      RecStr := ChildRecs[i];
      ChildNode := (tgfLex.tv.Items.AddChild(ctNode, Piece(RecStr, '^', 2))) as TLexTreeNode;

      SetNodeData(ChildNode, RecStr); //kt
      {
      with ChildNode do begin
        VUID := Piece(RecStr, '^', 1);
        Text := Piece(RecStr, '^', 2);
        CodeDescription := Text;
        CodeSys := Piece(RecStr, '^', 3);

        if ((FCodeSys <> '') and (CodeSys <> FCodeSys)) then
          FSingleCodeSys := False;

        FCodeSys := CodeSys;

        Code := Piece(RecStr, '^', 4);

        if Piece(RecStr, '^', 8) <> '' then
          ParentIndex := IntToStr(StrToInt(Piece(RecStr, '^', 8)) - 1);

        //TODO: Need to accommodate Designation Code in ColumnTreeNode...
        if CodeSys = 'SNOMED CT' then
          CodeIEN := Code
        else
          CodeIEN := Piece(RecStr, '^', 9);

        TargetCode := Piece(RecStr, '^', 6);
      end;
      }

      if (ChildNode.VUID = '+') then
      begin
        StubNode := (tgfLex.tv.Items.AddChild(ChildNode, 'Searching...')) as TLexTreeNode;
        with StubNode do
        begin
          VUID := '';
          Text := 'Searching...';
          CodeDescription := Text;
          CodeSys := 'ICD-10-CM';

          if ((FCodeSys <> '') and (CodeSys <> FCodeSys)) then
            FSingleCodeSys := False;

          FCodeSys := CodeSys;

          Code := '';
          CodeIEN := '';

          ParentIndex := IntToStr(Node.Index);
        end;
      end;
    end;
  end;
  AllowExpansion := True;
  //sort treenodes
  tgfLex.tv.AlphaSort(True);
  tgfLex.tv.Invalidate;
end;

procedure TfrmPCELex.tgfLextvHint(Sender: TObject; const Node: TTreeNode;
  var Hint: string);
begin
  inherited;
  // Only show hint if caption is less than width of Column[0]
  if TextWidthByFont(Font.Handle, Node.Text) < tgfLex.tv.Width then
    Hint := ''
  else
    Hint := Node.Text;
end;

procedure TfrmPCELex.updateStatus(status: String);
begin
  lblStatus.caption := status;
  lblStatus.Invalidate;
  lblStatus.Update;
end;

function TfrmPCELex.isNumeric(inStr: String): Boolean;
var
  dbl: Double;
  error, intDecimal: Integer;
begin
  Result := False;
  if (DecimalSeparator <> '.') then
    intDecimal := Pos(DecimalSeparator, inStr)
  else
    intDecimal := 0;
  if (intDecimal > 0) then
    inStr[intDecimal] := '.';
  Val(inStr, dbl, error);
  if (dbl = 0.0) then
    ; //do nothing
  if (intDecimal > 0) then
    inStr[intDecimal] := DecimalSeparator;
  if (error = 0) then
    Result := True;
end;

function TfrmPCELex.ParseNarrCode(ANarrCode: String): String;
var
  narr, code: String;
  ps: Integer;
begin
  narr := ANarrCode;
  ps := Pos('(SCT', narr);
  if not (ps > 0) then
    ps := Pos('(SNOMED', narr);
  if not (ps > 0) then
    ps := Pos('(ICD', narr);
  if (ps > 0) then
  begin
    narr := TrimRight(Copy(ANarrCode, 0, ps - 1));
    code := Copy(ANarrCode, ps, Length(ANarrCode));
    code := Piece(Piece(Piece(code, ')', 1), '(', 2), ' ', 2);
  end
  else
    code := '';
  Result := code + U + narr;
end;

end.

