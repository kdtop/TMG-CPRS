unit fProbAutoAdd;
//kt added entire unit and form 5/15
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
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ORCtrls, ORFn, ORDtTm, Math, Menus;

type
  TfrmProbAutoAdd = class(TForm)
    lbTopics: TListBox;
    ProbsTV: TORTreeView;
    pnlTop: TPanel;
    SplitterTopHoriz: TSplitter;
    pnlBottom: TPanel;
    SplitterMidVert: TSplitter;
    memSumNote: TMemo;
    btnDone: TBitBtn;
    pnlTopleft: TPanel;
    ORDateBoxSDT: TORDateBox;
    ORDateBoxEDT: TORDateBox;
    lblFilterSDT: TLabel;
    lblFilterEDT: TLabel;
    pnlTopRight: TPanel;
    pnlTopRightBottom: TPanel;
    btnLink: TSpeedButton;
    btnUnLink: TSpeedButton;
    btnClear: TBitBtn;
    btnAddProblem: TBitBtn;
    btnReloadProbs: TSpeedButton;
    btnShowNotes: TBitBtn;
    TVPopup: TPopupMenu;
    popActivateProblem: TMenuItem;
    popInactivateProblem: TMenuItem;
    popRemoveProblem: TMenuItem;
    lblTopics: TLabel;
    Label1: TLabel;
    btnInactivate: TBitBtn;
    btnRemove: TBitBtn;
    btnActivate: TBitBtn;
    btnHideTopic: TBitBtn;
    cbLimitNoteDateRange: TCheckBox;
    DelayTimer: TTimer;
    procedure DelayTimerTimer(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure ProbsTVDblClick(Sender: TObject);
    procedure btnHideTopicClick(Sender: TObject);
    procedure popRemoveProblemClick(Sender: TObject);
    procedure popActivateProblemClick(Sender: TObject);
    procedure popInactivateProblemClick(Sender: TObject);
    procedure TVPopupPopup(Sender: TObject);
    procedure btnUnLinkClick(Sender: TObject);
    procedure ProbsTVCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lbTopicsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure btnAddProblemClick(Sender: TObject);
    procedure btnShowNotesClick(Sender: TObject);
    procedure btnLinkClick(Sender: TObject);
    procedure ProbsTVClick(Sender: TObject);
    procedure btnClearSelectedClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ProbsTVChange(Sender: TObject; Node: TTreeNode);
    procedure ORDateBoxEDTChange(Sender: TObject);
    procedure ORDateBoxSDTChange(Sender: TObject);
    procedure btnDelProbInListClick(Sender: TObject);
    procedure btnReloadProbsClick(Sender: TObject);
    procedure lbTopicsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    slTopicsIENS : TStringList;
    Colors : TStringList;
    ProblemColors : TStringList;
    LinkedProbs : TStringList;  //format:  <ProblemIEN>  or -1^Topic name.
    TopicProblemLinkCache : TStringList;    //Format: TopicName^ProblemIEN
    NumUniqueLinkedProbs : integer;
    SelectedTopicsCount : integer;
    UniqueLinkedProbIEN : string;
    LinkedTopics : TStringList;
    IntSelectedProblemIEN : Int64;
    FShownTopicText : string;
    procedure popActionProblemClick(Mode : char);
    procedure LoadTopicLB;
    procedure LoadProblemTV;
    procedure ShowTextForSelected;
    procedure SetTopicsLBSelectedByName(TopicNamesSL : TStringList);
    procedure SetTopicsLBSelectedByIEN(IEN : string);
    procedure SyncSelected;
    procedure SyncSelectedFromProblemsToTopics;
    procedure SyncSelectedFromTopicsToProblems;
    procedure SetButtonsState;
    procedure GetLinkedProblems(LinkedProbs : TStringList);
    procedure GetLinkedTopics;
    function LBHasUnlinkedTopic : boolean;
    procedure LoadTopicProblemLinkCache;
    function GetColor(i : integer) : TColor;
    function GetColorForProbIEN(ProbIEN : string; Default : TColor) : TColor;
    procedure LinkOne(TopicName, ProbIEN : string);
  public
    { Public declarations }
    ResultMessage : string;
    function AskCodesForProblem(ProbName : string) : string;
  end;

//var
//  frmProbAutoAdd: TfrmProbAutoAdd;   //NOTE:  This form is NOT auto-created...

implementation

{$R *.dfm}

uses
  rTIU, uTemplates, rCore, uCore, uNoteComponents, uxtheme, uProbs, fProbLex, fProbs;


procedure TfrmProbAutoAdd.FormCreate(Sender: TObject);
begin
  LinkedProbs := TStringList.Create;
  LinkedTopics  := TStringList.Create;
  TopicProblemLinkCache := TStringList.Create;
  ProblemColors := TStringList.Create;
  slTopicsIENS := TStringList.Create();
  NumUniqueLinkedProbs := 0;
  SelectedTopicsCount := 0;
  IntSelectedProblemIEN := 0;
  UniqueLinkedProbIEN := '';
  ResultMessage := '';
  FShownTopicText := '';

  Colors := TStringList.Create;
  Colors.Add('$33CCCC');
  Colors.Add('$0099FF');
  Colors.Add('$339966');
  Colors.Add('$66FFFF');
  Colors.Add('$99CCFF');
  Colors.Add('$99FFCC');
  Colors.Add('$CCCCFF');
  Colors.Add('$CC66FF');
  Colors.Add('$33CC33');
  Colors.Add('$CCFF99');
  Colors.Add('$FFCCCC');
  Colors.Add('$FF66CC');
  Colors.Add('$FF9999');
  Colors.Add('$666633');
  Colors.Add('$FFCC66');
  Colors.Add('$FF6666');
  Colors.Add('$CC6699');
  Colors.Add('$999966');
  Colors.Add('$FFFF00');
  Colors.Add('$FF5050');
  Colors.Add('$FF9900');
end;

procedure TfrmProbAutoAdd.FormDestroy(Sender: TObject);
begin
  LinkedProbs.Free;
  LinkedTopics.Free;
  TopicProblemLinkCache.Free;
  ProblemColors.Free;
  slTopicsIENS.free();
  Colors.Free;
end;

procedure TfrmProbAutoAdd.FormShow(Sender: TObject);
begin
  ORDateBoxEDT.FMDateTime := Floor(FMNow);
  ORDateBoxSDT.FMDateTime := ORDateBoxEDT.FMDateTime - 10000;  //1 yr
  LoadTopicLB;
  LoadProblemTV;
end;

function TfrmProbAutoAdd.GetColor(i : integer) : TColor;
var s : string;
    R,G,B : byte;
begin
  if i < Colors.Count then begin
    s := Colors.Strings[i];
  end else begin
    s := '$FF0000';
  end;
  R := StrToInt('$' + s[2]+s[3]);
  G := StrToInt('$' + s[4]+s[5]);
  B := StrToInt('$' + s[6]+s[7]);
  Result := RGB(R, G, B);
end;

function TfrmProbAutoAdd.GetColorForProbIEN(ProbIEN : string; Default : TColor) : TColor;
var ColorIdx : integer;
begin
  ColorIdx := LinkedProbs.IndexOf(ProbIEN);
  if ColorIdx > -1 then begin
    Result := GetColor(ColorIdx);
  end else begin
    Result := Default
  end;
end;

procedure TfrmProbAutoAdd.LoadTopicProblemLinkCache;
var i: integer;
    line, ProbIEN : string;
    Input,Results : TStringList;
begin
  Results := TStringList.Create();
  Input := TStringList.Create();
  TopicProblemLinkCache.Clear;
  for i := 0 to lbTopics.Count - 1 do begin
    Input.Add('GET^'+Patient.DFN+'^TOPIC='+lbTopics.Items[i]);
  end;
  ProblemTopicLink(Results, Input);
  if Results.Count > 0 then Results.Delete(0);
  for i := 0 to Results.Count - 1 do begin
    line := Results.Strings[i];
    if Piece(line,'^',1)='-1' then begin
      TopicProblemLinkCache.Add(lbTopics.Items[i]+'^-1')
    end else begin
      Line := piece(Line, '^',5);
      ProbIEN := Piece2(Line,'PROB=',2);
      TopicProblemLinkCache.Add(lbTopics.Items[i]+'^'+ProbIEN);
    end;
  end;
  Results.Free;
  Input.Free;
end;


procedure TfrmProbAutoAdd.LoadTopicLB;
var
  i : integer;
  tempString: string;
  slTopics : TStringList;
  SDT,EDT : string;
begin
  memSumNote.Lines.Clear;
  slTopics := TStringList.Create();
  slTopicsIENs.clear;
  lbTopics.Clear;
  SDT := FloatToStr(ORDateBoxSDT.FMDateTime);
  EDT := FloatToStr(ORDateBoxEDT.FMDateTime);
  ProblemTopics(slTopics,'LIST','HPI', '', SDT, EDT);
  if piece(slTopics.Strings[0],'^',1)='-1' then begin
     ShowMessage(piece(slTopics.Strings[0],'^',2));
     exit;
  end;
  RedrawSuspend(lbTopics.Handle);
  slTopics.Delete(0);
  for i:=0 to slTopics.Count -1 do begin
    //tempString := piece(slTopics.Strings[i],'^',1)+' - '+FormatFMDateTime('mmm dd yyyy',StrToFloat(piece(slTopics.Strings[i],'^',3)));
    tempString := piece(slTopics.Strings[i],'^',1);
    if lbTopics.Items.IndexOf(tempString) > -1 then continue; //only add to list once.
    lbTopics.Items.Add(tempString);
    slTopicsIENs.add(piece(slTopics.Strings[i],'^',2));
  end;
  slTopics.free();
  LoadTopicProblemLinkCache;
  RedrawActivate(lbTopics.Handle);
end;

procedure TfrmProbAutoAdd.ORDateBoxEDTChange(Sender: TObject);
begin
  btnReloadProbsClick(Sender);
end;

procedure TfrmProbAutoAdd.ORDateBoxSDTChange(Sender: TObject);
begin
  btnReloadProbsClick(Sender);
end;

procedure TfrmProbAutoAdd.popInactivateProblemClick(Sender: TObject);
begin
  popActionProblemClick('I');
end;

procedure TfrmProbAutoAdd.popActivateProblemClick(Sender: TObject);
begin
  popActionProblemClick('E');
end;

procedure TfrmProbAutoAdd.popRemoveProblemClick(Sender: TObject);
begin
  popActionProblemClick('R');
end;

procedure TfrmProbAutoAdd.popActionProblemClick(Mode : char);
var IEN, Name, ICD : string;
    Line, DataStr : string;
begin
  if not EncounterPresent then exit;
  if not assigned(ProbsTV.Selected) then exit;
  DataStr := TORTreeNode(ProbsTV.Selected).StringData;
  Name := piece(DataStr, '^', 2);
  IEN := piece(DataStr, '^', 4);
  ICD := piece(DataStr, '^', 7);
  if Mode = 'I' then begin
    Line := IEN + '^' + Mode + '^' + Name;
    frmProblems.UpdateProblem('I', Line, -1);
  end else begin
    //NOTE: this function is used for inactivating, reactivating, or removing.
    //So SCT codes are not relevent.  Can just pass '' in function below.
    frmProblems.ProblemActionAuto(Mode,IEN, Name, ICD, '', '');
  end;
  LoadProblemTV;
end;

procedure TfrmProbAutoAdd.SetTopicsLBSelectedByName(TopicNamesSL : TStringList);
var i : integer;
    Topic : String;
begin
  for i := 0 to lbTopics.Items.Count-1 do begin
    Topic := lbTopics.Items.Strings[i];
    lbTopics.Selected[i] := (TopicNamesSL.IndexOf(Topic) > -1);
  end;
end;

procedure TfrmProbAutoAdd.SetTopicsLBSelectedByIEN(IEN : string);
var i : integer;
    Link,LinkedIEN : string;
begin
  for i := 0 to lbTopics.Items.Count-1 do begin
    Link := TopicProblemLinkCache[i];  //Format: TopicName^ProblemIEN
    LinkedIEN := Piece(Link,'^',2);
    lbTopics.Selected[i] := (LinkedIEN = IEN);
  end;
end;


procedure TfrmProbAutoAdd.GetLinkedTopics;
var DataStr : string;
    Input, Results : TStringList;
    SelectedProblemIEN : string;
    i : integer;

begin
  Results := TStringList.Create;
  Input := TStringList.Create;
  LinkedTopics.Clear;
  IntSelectedProblemIEN := 0;
  SelectedProblemIEN := '';
  if assigned(ProbsTV.Selected) then begin
    DataStr := TORTreeNode(ProbsTV.Selected).StringData;
    SelectedProblemIEN := piece(DataStr, '^', 4);
    IntSelectedProblemIEN := StrToInt64Def(SelectedProblemIEN, 0);
    if IntSelectedProblemIEN > 0 then begin
      i := 0;
      while (i >= 0) and (i < TopicProblemLinkCache.Count) do begin
        i := IndexOfPiece(TopicProblemLinkCache, SelectedProblemIEN, '^', 2, i);
        if i > -1 then begin
          LinkedTopics.Add(piece(TopicProblemLinkCache.Strings[i],'^',2));
          inc(i);
        end;
      end;
    end;
  end;
  Results.Free;
  Input.Free;
end;


procedure TfrmProbAutoAdd.btnAddProblemClick(Sender: TObject);
var Name, ErrMsg, ResultStr : string;
    //frmPLLex: TfrmPLLex;
    i : integer;
    MultiAdd: boolean;
    TempSL : TStringList;
    ProbIEN : string;
    ICDName,ICDCode,SCTConceptCode,SCTDesignationCode : string;
    ICDIEN : string;
begin
  TempSL := TStringList.Create;
  try
    if (IntSelectedProblemIEN > 0) then begin
      ErrMSg := 'This topic name is already linked to a problem.' + #13#10 +
                'Please select an unlinked topic.';
    end else if (SelectedTopicsCount = 0) then begin
      ErrMsg := 'Please first select an unlinked topic.';
    {end else if (SelectedTopicsCount > 1) then begin
      ErrMsg := 'Please select on ONE unlinked topic.';}
    end;
    if ErrMsg <> '' then begin
      MessageDlg(ErrMsg, mtError, [mbOK], 0);
      exit;
    end;
    MultiAdd := (SelectedTopicsCount > 1);
    for i := 0 to lbTopics.Items.Count - 1 do begin
      if lbTopics.Selected[i] = false then continue;
      Name := lbTopics.Items[i];
      PLProblem := ''; //if this is not done then frmProbs will try act on data when it gets windows message
      if MultiAdd then begin
        ResultStr :=  '^' + Name + '^R69';  //'^799.9^';
      end else begin
        //TO-DO.  Extend this to that SCT codes are used
        ResultStr := AskCodesForProblem(Name);  //e.g.  '7001949^Benign essential hypertension^I10.^508014^SNOMED CT^1201005^3135013^ICD-10-CM|Essential (Primary) Hypertension'

        if ResultStr='' then exit;
      end;
      //TO-DO.  Extend this to that SCT codes are used

      ICDName := piece(ResultStr,'^',2);
      ICDCode := piece(ResultStr,'^',3);
      ICDIEN := piece(ResultStr,'^',4);
      if piece(ResultStr,'^',5) = 'SNOMED CT' then begin
        SCTConceptCode := piece(ResultStr,'^',6);
        SCTDesignationCode := piece(ResultStr,'^',7);
      end else begin
        SCTConceptCode := '';
        SCTDesignationCode := '';
      end;
      frmProblems.ProblemActionAuto('A','', ICDName, ICDCode, SCTConceptCode, SCTDesignationCode, ICDIEN);
      TempSL.Assign(TMGPLData);
      LoadDataForProblems;  //this will get NEW values for TMGPLData
      ProbIEN := Piece(TMGPLData.Strings[TMGPLData.Count-1], '^', 1);  //the newly added problem is always the LAST in the list
      LinkOne(Name, ProbIEN);
    end;
    LoadProblemTV;
    btnClearSelectedClick(self);
  finally
    //frmPLLex.Free; -- frmPLLex calls Self.Release upon form close, so it doesn't need to be free'd
    TempSL.Free;
  end;
end;

function TfrmProbAutoAdd.AskCodesForProblem(ProbName : string) : string;
var frmPLLex: TfrmPLLex;
begin
  Result := '';
  if not PLUser.usUseLexicon then exit;
  try
    frmPLLex := TFrmPLLex.create(Application);
    frmPLLex.AutoSearchTerm := ProbName;
    frmPLLex.showmodal;
    //NOTE: frmPLLex calls Self.Release upon form close, so it doesn't need to be free'd
    //NOTE: the form will put its output into uProbs.PLProblem
    //Format of PLProblem = <IEN757.01>^<.01Name>^<ICD Code>^<ICD IEN (in 80)>^<Coding System name>^<SCT concept Code>^<SCT designation code> ...
    //e.g. '7001949^Benign essential hypertension^I10.^508014^SNOMED CT^1201005^3135013^ICD-10-CM|Essential (Primary) Hypertension'
    Result := PLProblem;
    PLProblem := ''; //if this is not done then frmProbs will try act on data when it gets windows message
    Application.ProcessMessages; //frmPLLex sent some messages to form frmProbs
  finally
    //frmPLLex.Free; -- frmPLLex calls Self.Release upon form close, so it doesn't need to be free'd
  end;
end;

procedure TfrmProbAutoAdd.btnClearSelectedClick(Sender: TObject);
var i : integer;
begin
  for i := 0 to lbTopics.Items.Count-1 do lbTopics.Selected[i] := false;
  ProbsTV.Selected := nil;
  memSumNote.Lines.Clear;
  //LinkedProbs.Clear;
  NumUniqueLinkedProbs := 0;
  SelectedTopicsCount := 0;
  UniqueLinkedProbIEN := '';
  SetButtonsState;
end;

procedure TfrmProbAutoAdd.btnDelProbInListClick(Sender: TObject);
var i : integer;
begin
  for i := lbTopics.Items.Count-1 downto 0 do begin
    if lbTopics.Selected[i] then begin
      lbTopics.Items.Delete(i);
    end;
  end;
  memSumNote.Lines.Clear;
  GetLinkedProblems(LinkedProbs);
  SetButtonsState;
end;

procedure TfrmProbAutoAdd.btnDoneClick(Sender: TObject);
begin
  Self.ModalResult := mrOK;
end;

procedure TfrmProbAutoAdd.btnHideTopicClick(Sender: TObject);
var i : integer;
begin
  //Here I hide topic(s).
  for i := lbTopics.Items.count-1 downto 0 do begin
    if not lbTopics.Selected[i] then continue;
    lbTopics.Items.Delete(i);
    TopicProblemLinkCache.Delete(i);    
  end;
  lbTopicsClick(Self);
end;

procedure TfrmProbAutoAdd.btnLinkClick(Sender: TObject);
var i : integer;
    Results, Req : TStringList;
    DispText : string;
begin
  Req := TStringList.Create;
  Results := TStringList.Create;
  try
    if not assigned(ProbsTV.Selected) then exit;
    DispText := 'Do you want to link:' + #13#10;
    for i := 0 to lbTopics.Items.Count-1 do begin
      if not lbTopics.Selected[i] then continue;
      Req.Add('SET^' + Patient.DFN + '^' + lbTopics.Items.Strings[i] + '^' + IntToStr(IntSelectedProblemIEN));
      DispText := DispText + '"' + lbTopics.Items.Strings[i] + '" --> ' + ProbsTV.Selected.Text + #13#10;
    end;
    if Req.Count <= 0 then exit;
    if MessageDlg(DispText, mtConfirmation, [mbOK, mbCancel],0) <> mrOK then exit;
    ProblemTopicLink(Results, Req);
    LoadTopicProblemLinkCache;
    if Results.Count = 0 then Exit;
    if piece(Results.Strings[0],'^',1) = '-1' then begin
      MessageDlg(Results.Text, mtInformation, [mbOK],0);
    end;
    //LoadTopicLB;
    //LoadTopicProblemLinkCache;
    GetLinkedProblems(LinkedProbs);
    btnClearSelectedClick(Self);
    lbTopics.Invalidate; //force repaint
    ProbsTV.Invalidate;  //force repaint
  finally
    Results.Free;
    Req.Free;
  end;
end;

procedure TfrmProbAutoAdd.LinkOne(TopicName, ProbIEN : string);
var //i : integer;
    Results, Req : TStringList;
    //DispText : string;
begin
  Req := TStringList.Create;
  Results := TStringList.Create;
  try
    Req.Add('SET^' + Patient.DFN + '^' + TopicName + '^' + ProbIEN);
    ProblemTopicLink(Results, Req);
    LoadTopicProblemLinkCache;
    if Results.Count = 0 then Exit;
    if piece(Results.Strings[0],'^',1) = '-1' then begin
      MessageDlg(Results.Text, mtInformation, [mbOK],0);
    end;
    GetLinkedProblems(LinkedProbs);
    lbTopics.Invalidate; //force repaint
    ProbsTV.Invalidate;  //force repaint
  finally
    Results.Free;
    Req.Free;
  end;
end;



procedure TfrmProbAutoAdd.btnReloadProbsClick(Sender: TObject);
begin
  LoadTopicLB;
  GetLinkedProblems(LinkedProbs);
  SetButtonsState;
  //Finish -- should flush cash and perhaps reload problemTV
end;

procedure TfrmProbAutoAdd.btnShowNotesClick(Sender: TObject);
begin
  ShowTextForSelected;
end;

procedure TfrmProbAutoAdd.btnUnLinkClick(Sender: TObject);
var Input,Results : TStringList;
    i : integer;
begin
  //here I need to unlink
  Results := TStringList.Create();
  Input := TStringList.Create();
  try
    for i := 0 to lbTopics.Count - 1 do begin
      if not lbTopics.Selected[i] then continue;
      Input.Add('KILL^'+Patient.DFN+'^TOPIC='+lbTopics.Items[i]);
    end;
    if Input.count = 0 then exit;
    ProblemTopicLink(Results, Input);
    if Results.Count = 0 then Exit;
    if piece(Results.Strings[0],'^',1) = '-1' then begin
      Results.Delete(0);
      MessageDlg(Results.Text, mtError, [mbOK],0);
      exit;
    end;
    LoadTopicLB;
    GetLinkedProblems(LinkedProbs);
    ProbsTV.Selected := nil;
  finally
    Results.Free;
    Input.Free;
  end;
end;

procedure TfrmProbAutoAdd.DelayTimerTimer(Sender: TObject);
begin
  DelayTimer.Enabled := false;
  ShowTextForSelected;
end;

procedure TfrmProbAutoAdd.LoadProblemTV;
var Node : TTreeNode;
    i : integer;
begin
  LoadDataForProblems;
  LoadProblemNodes(ProbsTV);
  Node := ProbsTV.items.GetFirstNode;
  if Node.Text = 'Problems' then begin
    Node.Expand(False);
    for i := 0 to Node.Count - 1 do begin
      if Node.Item[i].Text = 'Active Problems' then begin
        Node.Item[i].Expand(True);  //why doesn't this work?
        break;
      end;
    end;
  end;
end;


procedure TfrmProbAutoAdd.ProbsTVChange(Sender: TObject; Node: TTreeNode);
begin
  //SyncSelected;
  //ShowTextForSelected;
end;

procedure TfrmProbAutoAdd.ProbsTVClick(Sender: TObject);
begin
  //SyncSelected;
  SyncSelectedFromProblemsToTopics;
  //ShowTextForSelected;
end;

procedure TfrmProbAutoAdd.ProbsTVCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
                                                State: TCustomDrawState; var DefaultDraw: Boolean);
var
  NodeRect: TRect;
  DataStr : string;

  function GetRect : TRect;
  begin
    Result := Node.DisplayRect(False);
    Result.Left := Result.Left + (Node.Level * ProbsTV.Indent);
    // NodeRect.Left now represents the left-most portion of the expand button
    Result.Left := Result.Left + ProbsTV.Indent + 10;  // + FButtonSize;
    //NodeRect.Left is now the leftmost portion of the image.
    Result.Left := Result.Left + 20; //ImageList.Width;
    //Now we are finally in a position to draw the text.
    Result.Right := Result.Left + ProbsTV.Canvas.TextWidth(Node.Text) - 5;
  end;

  function ColorForNode : TColor;
  var ProbIEN : string;
  begin
    //Result := ProbsTV.Color;
    ProbIEN := Piece(DataStr,'^',4);
    Result := GetColorForProbIEN(ProbIEN, ProbsTV.Color);
  end;


begin
  DataStr := TORTreeNode(Node).StringData;
  //ProbsTV.Canvas.Font.Style := [fsBold];

  with ProbsTV.Canvas do begin
    NodeRect := GetRect;
    Brush.Style := bsSolid;
    if cdsSelected in State then begin
      Brush.Color := clBlack; //clNavy;
      Font.Color := clWhite;
    end else begin
      Brush.Color := ColorForNode;
      Font.Color := clBlack;
    end;
    FillRect(NodeRect);

    DefaultDraw := true;
  end;
end;

procedure TfrmProbAutoAdd.ProbsTVDblClick(Sender: TObject);
var IEN, Name, ICD, Category : string;
    DataStr : string;
begin
  if not assigned(ProbsTV.Selected) then exit;
  //if not EncounterPresent then exit;
  DataStr := TORTreeNode(ProbsTV.Selected).StringData;
  Name := piece(DataStr, '^', 2);
  Name := Trim(piece(Name, '{', 1));
  IEN := piece(DataStr, '^', 4);
  Category := piece(DataStr, '^', 5);
  ICD := piece(DataStr, '^', 7);
  // doesn't work --> frmProblems.EditProblemInSeparateForm('E', IEN, Name, ICD, Self);
  Self.ResultMessage := 'EDIT^'+IEN+'^'+Name+'^'+ICD+'^'+Category;
  btnDoneClick(Self);  //close form and open editing from problems tab...
end;

procedure TfrmProbAutoAdd.lbTopicsClick(Sender: TObject);
begin
  SyncSelectedFromTopicsToProblems;
  memSumNote.Lines.Clear;
  DelayTimer.Enabled := true;
end;

procedure TfrmProbAutoAdd.lbTopicsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var  LB : TListBox;
     Link, LinkedIEN : string;
     //ColorIdx : integer;
begin
  LB := TListBox(Control);
  with LB.Canvas do begin
    Link := TopicProblemLinkCache[index];  //Format: TopicName^ProblemIEN
    LinkedIEN := Piece(Link,'^',2);
    if LinkedIEN <>'-1' then begin
      Font.Style := [fsBold];
      Brush.Color := GetColorForProbIEN(LinkedIEN, lbTopics.Color);
    end else begin
      Font.Style := [];
    end;
    if odSelected in State then begin
      Brush.Color := clBlack; //$00FFD2A6;
    end;
    FillRect(Rect);
    TextOut(Rect.Left+5, Rect.Top, lbTopics.Items[Index]);
    if odFocused In State then begin
      Brush.Color := lbTopics.Color;
      DrawFocusRect(Rect);
    end;
  end;

end;

function TfrmProbAutoAdd.LBHasUnlinkedTopic : boolean;
var i : integer;
begin
  Result := false;
  for i := 0 to LinkedProbs.Count - 1 do begin
    if Pos('-1^', LinkedProbs.Strings[i]) < 1 then continue;
    Result := true;
    break;
  end;
end;


procedure TfrmProbAutoAdd.SyncSelectedFromTopicsToProblems;
//var Node: TTreeNode;
begin
  GetLinkedProblems(LinkedProbs);   //Selected LB Topics --> TV Problems
  GetLinkedTopics;     //Selected TV Problems --> LB Topics

  //if (LinkedProbs.Count = 0) and (LinkedTopics.Count > 0) then begin
  //  SetTopicsLBSelected(LinkedTopics);
  //end else if (NumUniqueLinkedProbs = 1) and (IntSelectedProblemIEN <= 0) then begin
  if (NumUniqueLinkedProbs = 1) then begin
    ProbsTV.Selected := ProbsTV.FindPieceNode(UniqueLinkedProbIEN,4);
  end else begin
    ProbsTV.Selected := nil;
  end;
  GetLinkedProblems(LinkedProbs);
  SetButtonsState;
  ProbsTV.Invalidate;  //force repaint
end;

procedure TfrmProbAutoAdd.TVPopupPopup(Sender: TObject);
var ProbMode, DataStr : string;
begin
  if assigned(ProbsTV.Selected) then begin
    DataStr := TORTreeNode(ProbsTV.Selected).StringData;
  end else begin
    DataStr := '';
  end;
  ProbMode := UpperCase(piece(DataStr, '^',5));
  //here determine which popup items to show.
  popActivateProblem.Enabled := (ProbMode = 'I');
  popInactivateProblem.Enabled := (ProbMode = 'A');
  popRemoveProblem.Enabled := (ProbMode <> 'R') and (ProbMode <> '');
end;

procedure TfrmProbAutoAdd.SyncSelected;
//var Node: TTreeNode;
begin
  GetLinkedProblems(LinkedProbs);   //Selected LB Topics --> TV Problems
  GetLinkedTopics;     //Selected TV Problems --> LB Topics

  {Rules:
  If LinkedTopics has data and actual LB doesn't have anything selected,
     then use LinkedTopics to change selections in LB
  If LinkedProblems has one linked problem, or one linked and some unlinked,
     AND TV doesn't have a valid node selected,
     then set TV selected node to match
  }

  if (LinkedProbs.Count = 0) and (LinkedTopics.Count > 0) then begin
    SetTopicsLBSelectedByName(LinkedTopics);
    GetLinkedProblems(LinkedProbs);
  end else if (NumUniqueLinkedProbs = 1) and (IntSelectedProblemIEN <= 0) then begin
    ProbsTV.Selected := ProbsTV.FindPieceNode(UniqueLinkedProbIEN,4);
  end;
  SetButtonsState;
  ProbsTV.Invalidate;  //force repaint
end;


procedure TfrmProbAutoAdd.SyncSelectedFromProblemsToTopics;
//var Node: TTreeNode;
begin
  GetLinkedProblems(LinkedProbs);   //Selected LB Topics --> TV Problems
  GetLinkedTopics;     //Selected TV Problems --> LB Topics

  if SelectedTopicsCount = 0 then begin
    SetTopicsLBSelectedByIEN(IntToStr(IntSelectedProblemIEN));
    GetLinkedProblems(LinkedProbs);
  end;
  SetButtonsState;
  ProbsTV.Invalidate;  //force repaint
end;

procedure TfrmProbAutoAdd.SetButtonsState;
var LinkAndOnlyLink : boolean;
    //DataStr : string;
begin
  LinkAndOnlyLink := (NumUniqueLinkedProbs = 1);
  btnLink.Enabled := (SelectedTopicsCount > 0) and (IntSelectedProblemIEN > 0) and not LinkAndOnlyLink;
  btnUnLink.Enabled := LinkAndOnlyLink;
  //btnAddProblem.Enabled := (SelectedTopicsCount > 0) and (btnUnLink.Enabled = false);
  btnAddProblem.Enabled := (SelectedTopicsCount > 0) and (IntSelectedProblemIEN = 0);
  btnHideTopic.Enabled := (SelectedTopicsCount > 0);
  btnShowNotes.Enabled := (SelectedTopicsCount > 0);

  TVPopupPopup(Self);
  btnActivate.Enabled := popActivateProblem.Enabled;
  btnInactivate.Enabled := popInactivateProblem.Enabled;
  btnRemove.Enabled := popRemoveProblem.Enabled;
end;


procedure TfrmProbAutoAdd.GetLinkedProblems(LinkedProbs : TStringList);
var i, idx : integer;
    //s : string;
    Req : TStringList;
    ATopic, AnIEN : string;
begin
  Req := TStringList.Create;
  LinkedProbs.Clear;
  NumUniqueLinkedProbs := 0;
  UniqueLinkedProbIEN := '';
  SelectedTopicsCount := 0;
  try
    for i := 0 to lbTopics.Items.Count-1 do begin
      ATopic := lbTopics.Items.Strings[i];
      if lbTopics.Selected[i] then inc(SelectedTopicsCount);
      idx := IndexOfPiece(TopicProblemLinkCache, ATopic, '^', 1);
      if idx > -1 then begin
        AnIEN := Piece(TopicProblemLinkCache.Strings[idx], '^', 2);
        if (AnIEN <> '-1') and (LinkedProbs.IndexOf(AnIEN) < 0) then begin
          LinkedProbs.Add(AnIEN);
          if not lbTopics.Selected[i] then continue;
          Inc(NumUniqueLinkedProbs);
          if NumUniqueLinkedProbs = 1 then begin
            UniqueLinkedProbIEN := AnIEN;
          end else begin
            UniqueLinkedProbIEN := '';
          end;
        end;
      end else begin
        LinkedProbs.Add('-1^'+ATopic);
      end;
    end;
  finally
    Req.Free;
  end;
end;

procedure TfrmProbAutoAdd.ShowTextForSelected;
var
  slTopicText: TStringList;
  TopicText:String;
  i : Integer;
  s,ADate,CurDate, ExternDate : string;
  SDT, EDT : string;
begin
  slTopicText := TStringList.Create();
  for i := 0 to lbTopics.Items.Count-1 do begin
    if lbTopics.Selected[i] then begin
      if TopicText <> '' then TopicText := TopicText + ',';
      TopicText := TopicText + piece2(lbTopics.Items[i],' - ',1);;
    end;
  end;
  SDT := FloatToStr(ORDateBoxSDT.FMDateTime);
  if not cbLimitNoteDateRange.Checked then SDT := '0';
  EDT := FloatToStr(ORDateBoxEDT.FMDateTime);
  if TopicText <> '' then begin
    ProblemTopics(slTopicText,'SUM1','HPI',TopicText, SDT, EDT);
    if piece(slTopicText.Strings[0],'^',1)='-1' then begin
       ShowMessage(piece(slTopicText.Strings[0],'^',2));
       exit;
    end;
    if slTopicText.Count > 0 then slTopicText.Delete(0);
  end;
  memSumNote.Lines.Clear;
  CurDate := '';
  RedrawSuspend(memSumNote.Handle);
  for i := 0 to slTopicText.Count-1 do begin
    s := slTopicText.strings[i];
    ADate := piece(s,'^',1);
    s := piece(s,'^',3);
    if ADate <> CurDate then begin
      ExternDate := FormatFMDateTime('mmm dd yyyy',StrToFloat(ADate));
      if Trim(memSumNote.Lines.Strings[memSumNote.Lines.Count-1])<>'' then begin
        memSumNote.Lines.Add('');
      end;
      memSumNote.Lines.Add(ExternDate);
      memSumNote.Lines.Add('--------------------');
      CurDate := ADate;
    end;
    memSumNote.Lines.Add('   ' +s);
  end;
  SendMessage(memSumNote.Handle, WM_VSCROLL, SB_BOTTOM, 0);
  RedrawActivate(memSumNote.Handle);
  slTopicText.free;
end;



end.

