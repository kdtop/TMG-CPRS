unit fTMGQuickConsole;
//kt added entire unit 10/26/14
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
  //fDrawers,
  StrUtils, Math, uTIU, fDrawers,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, ORCtrls, ORDtTm;

type
  TfrmTMGQuickConsole = class(TForm)
    StatusBar: TStatusBar;
    edtAction: TEdit;
    btnAccept: TBitBtn;
    btnCancel: TBitBtn;
    Timer: TTimer;
    lbOptions: TORListBox;
    pnlTop: TPanel;
    pnlOptions: TPanel;
    pnlBottom: TPanel;
    lblFilterSDT: TLabel;
    ORDateBoxSDT: TORDateBox;
    lblFilterEDT: TLabel;
    ORDateBoxEDT: TORDateBox;
    procedure ORDateBoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbOptionsChange(Sender: TObject);
    procedure edtActionKeyPress(Sender: TObject; var Key: Char);
    procedure edtActionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnAcceptClick(Sender: TObject);
    procedure lbMatchesEnter(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure lbOptionsDblClick(Sender: TObject);
    procedure lbOptionsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtActionChange(Sender: TObject);
  private
    { Private declarations }
    UserInput : string;
    InputSuggestion : string;
    CaseSensitiveStr : string;  //should be "0" or "1"
    IgnoreEditInputChanges : boolean;
    lbOptionsData : TStringList;    // this will be a datastring to match 1:1 with lbOptions.Items
    SavedProblemList : TStringList;
    ProblemListDownloaded : boolean;
    SavedTopicList : TStringList;
    TopicListDownloaded : boolean;
    SavedTagList : TStringList;
    TagListPrepaired : boolean;
    TopicProblemLink : TStringList;
    TopicProblemLinkDownloaded : boolean;
    //IsFPGSite : boolean;
    procedure GetProblemList(OutSL : TStringList);
    procedure GetTopicList(OutSL : TStringList);
    procedure GetTagList(OutSL : TStringList);
    procedure GetTopicProblemLink(TopicList, OutSL : TStringList);
    procedure UpdateEditBox;
    procedure ProcessAction;
    procedure ProcessHelp(Params : string; TargetSL : TStrings; DataSL : TStringList);
    procedure ProcessTemplate(Params : string; TargetSL : TStrings; DataSL : TStringList);
    procedure ProcessAdd(Params : string; TargetSL : TStrings; DataSL : TStringList);
    procedure ProcessAddComp(Params : string; TargetSL : TStrings; DataSL : TStringList);
    procedure ProcessAddProblemComp(Params : string; TargetSL : TStrings; DataSL : TStringList);
    procedure ProcessAddTopicComp(Params : string; TargetSL : TStrings; DataSL : TStringList; ForceShow : boolean);
    procedure ProcessAddTagComp(Params : string; TargetSL : TStrings; DataSL : TStringList; ForceShow : boolean);
    procedure ShowOptionPanel;
    procedure HideOptionPanel;
    procedure SetDateGroupVisability(Visible : boolean);
  public
    { Public declarations }
    ActionString : string;  //
    ActionDataString : string;
  end;

  procedure LaunchQuickConsole(Drawers : TfrmDrawers);  forward;

//var
//  frmTemplateSearch: TfrmTemplateSearch;


implementation

{$R *.dfm}
uses
  ORNet,   ORFn,
  //fFrame,
  fNotes,
  uTemplates, rTIU, rProbs, uTMGUtil,
  uTMGOptions, uNoteComponents,
  uCore, rCore;

const
  TIMER_DELAY       = 200; //500 ms = 0.5 seconds
  COMPONENT         = 'COMPONENT';
  COMP_PROBLEM      = 'PROBLEM';
  COMP_TOPIC        = 'TOPIC';
  COMP_TAG          = 'TAG';
  HINT_TAG          = 'HINT';
  TAG_DATA_TAG      = 'TAG_DATA';
  TEMPLATE_DATA_TAG = 'TEMPLATE_DATA';
  PROBLEM_DATA_TAG  = 'PROBLEM_DATA';
  TOPIC_DATA_TAG    = 'TOPIC_DATA';

type
  eCmd = (cmdHelp=0,
          cmdTemplate=1,
          cmdAdd);
const
  cmdLASTCMD = cmdAdd;
  COMMANDS : array[cmdHelp .. cmdLASTCMD] of string = ('HELP',
                                                       'TEMPLATE',
                                                       'ADD'
                                                      );
 // --------------------------------------------------------------------------------------------------
  {//moved to ORFn
  function LeftMatch(SubStr, Str : string) : boolean;
  begin
    Result := (Pos(SubStr, Str) = 1) and (Length (SubStr) <= Length(Str));
  end;
  }

  procedure AddComp(DataStr : string; Drawers : TfrmDrawers);
  var DataType : string;
      ProbName, ProbIEN, ProbICD : string;
      HTML : boolean;
      AddOK : boolean;
  begin
    //MessageDlg('Here I can add component. ' + #10#13 + 'Data=' + DataStr, mtInformation, [mbOK], 0);
    DataType := piece(DataStr, '^', 1);
    if DataType = PROBLEM_DATA_TAG then begin
      ProbName := piece(DataStr,'^', 4);
      ProbICD := piece(DataStr,'^', 5);
      ProbIEN := piece(DataStr,'^', 2);
      HTML := (frmNotes.HTMLEditMode = emHTML);
      AddOK := AddComponentForProblem(ProbIEN, ProbName, ProbICD, HTML, Drawers.DocSelRec);
    end;
  end;

  procedure InsertTemplate(DataStr : string; Drawers : TfrmDrawers);
  begin
    MessageDlg('Here I can insert component. ' + #10#13 + 'Data=' + DataStr, mtInformation, [mbOK], 0);
  end;

  procedure LaunchQuickConsole(Drawers : TfrmDrawers);
  var frmQuickConsole: TfrmTMGQuickConsole;
      ActionDataStr, ActionStr : string;
      ModalResult : integer;
  begin
    frmQuickConsole := TfrmTMGQuickConsole.Create(Drawers);
    ModalResult := frmQuickConsole.ShowModal;
    ActionStr := frmQuickConsole.ActionString;
    ActionDataStr := frmQuickConsole.ActionDataString;
    frmQuickConsole.Free;
    if ModalResult <> mrOK then exit;
    //finish here later...
    //MessageDlg('Action=' + ActionStr +  #13#10 + 'Data=' + ActionDataStr, mtInformation, [mbOK], 0);
    if LeftMatch(COMMANDS[cmdAdd] + ' ' + COMPONENT, ActionStr) then begin
      AddComp(ActionDataStr, Drawers);
    end else if LeftMatch(COMMANDS[cmdTemplate], ActionStr) then begin
      InsertTemplate(ActionStr, Drawers);
    end;
  end;

 // --------------------------------------------------------------------------------------------------

  procedure TfrmTMGQuickConsole.FormCreate(Sender: TObject);
  var Pos : TPoint;
  begin
    lbOptionsData := TStringList.Create;
    SavedProblemList := TStringList.Create;
    ProblemListDownloaded := false;
    SavedTopicList := TStringList.Create;
    TopicListDownloaded := false;
    SavedTagList := TStringList.Create;
    TagListPrepaired := false;
    TopicProblemLink := TStringList.Create;
    TopicProblemLinkDownloaded := false;
    CaseSensitiveStr := '0';  //later hook into checkbox.
    ProcessAction();  //fill box initially with ALL templates
    Pos := Mouse.CursorPos;
    self.Top := Pos.Y; self.Left := Pos.X;
    IgnoreEditInputChanges := false;
    lbOptions.ItemIndex := -1;
    //kt IsFPGSite := (uTMGOptions.ReadString('SpecialLocation','') = 'FPG');
    //IsFPGSite := AtFPGLoc();
  end;

  procedure TfrmTMGQuickConsole.FormDestroy(Sender: TObject);
  begin
    lbOptionsData.Free;
    SavedProblemList.Free;
    SavedTopicList.Free;
    SavedTagList.Free;
    TopicProblemLink.Free;
  end;

  procedure TfrmTMGQuickConsole.FormShow(Sender: TObject);
  begin
    ORDateBoxEDT.FMDateTime := Floor(FMNow);
    ORDateBoxSDT.FMDateTime := ORDateBoxEDT.FMDateTime - 10000;  //1 yr
    HideOptionPanel;
  end;

  procedure TfrmTMGQuickConsole.GetTopicProblemLink(TopicList, OutSL : TStringList);
  var i: integer;
      line, ProbIEN : string;
      Input,Results : TStringList;
  begin
    try
      if not TopicProblemLinkDownloaded then begin
        Results := TStringList.Create();
        Input := TStringList.Create();
        TopicProblemLink.Clear;
        for i := 0 to TopicList.Count - 1 do begin
          Input.Add('GET^'+Patient.DFN+'^TOPIC='+piece(TopicList.Strings[i],'^',1));
        end;
        ProblemTopicLink(Results, Input);
        if Results.Count > 0 then Results.Delete(0);
        for i := 0 to Results.Count - 1 do begin
          line := Results.Strings[i];
          if Piece(line,'^',1)<>'-1' then begin
            Line := piece(Line, '^',5);
            ProbIEN := Piece2(Line,'PROB=',2);
            TopicProblemLink.Add(TopicList.Strings[i]+'^'+ProbIEN);
          end;
        end;
        TopicProblemLinkDownloaded := True;
      end;
      OutSL.Assign(TopicProblemLink);
    finally
      Results.Free;
      Input.Free;
    end;
  end;

  procedure TfrmTMGQuickConsole.edtActionChange(Sender: TObject);
  var LastChar : Char;
      Len : integer;
      Sel1, Sel2 : integer;
  begin
    if IgnoreEditInputChanges then begin IgnoreEditInputChanges := false; exit; end;
    Sel1 := edtAction.SelStart;
    Sel2 := edtAction.SelStart + edtAction.SelLength;
    if Sel2 > Sel1 then begin
      UserInput := MidStr(edtAction.Text, 1, Sel1);
    end else begin
      UserInput := edtAction.Text;
    end;
    Len := Length(edtAction.Text);
    if Len > 0 then LastChar := edtAction.Text[Len] else LastChar := ' ';
    if LastChar=' ' then begin
      ProcessAction; //Launch search directly after every space
    end else begin
      Timer.Interval := TIMER_DELAY; // I think this starts the countdown again
      Timer.Enabled := true;
      //So as long as user keeps changing search terms, search will not launch
      //until there has been a 0.5 second pause.
    end;
  end;


  procedure TfrmTMGQuickConsole.edtActionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ChangeSelected(Delta : integer);
    //var i : integer;
    begin
      lbOptions.ItemIndex := lbOptions.ItemIndex + Delta;
      if lbOptions.ItemIndex < 0 then lbOptions.ItemIndex := 0;
      if lbOptions.ItemIndex > lbOptions.Items.Count - 1 then lbOptions.ItemIndex := lbOptions.Items.Count - 1;
      if lbOptions.ItemIndex > -1  then begin
        //IgnoreEditInputChanges := true;
        InputSuggestion := lbOptions.Items.Strings[lbOptions.ItemIndex];
        UpdateEditBox;
      end;
    end;

  begin
    case Key  of
      VK_UP   : begin
                  ChangeSelected(-1);
                  Key := 0; //handled
                end;
      VK_DOWN : begin
                  ChangeSelected(1);
                  Key := 0; //handled
                end;
      VK_NEXT : begin  //VK_NEXT = pg down
                  ChangeSelected(10);
                  Key := 0; //handled
                end;
      VK_PRIOR : begin  //VK_PRIOR = pg up
                  ChangeSelected(-10);
                  Key := 0; //handled
                end;
      VK_RIGHT : begin
                  UserInput := edtAction.Text;
                  Key := 0; //handled
                  UpdateEditBox;
                end;
      VK_BACK : begin
                  if length(UserInput) > length(InputSuggestion) then InputSuggestion := '';
                  if InputSuggestion <> '' then begin
                    InputSuggestion := '';
                    UserInput := MidStr(UserInput, 1, Length(UserInput)-1);
                    Key := 0; //handled
                    UpdateEditBox;
                  end;
                  exit;
                end;
    end; {case}
  end;

  procedure TfrmTMGQuickConsole.edtActionKeyPress(Sender: TObject; var Key: Char);
  begin
    case Key of
      ' ' : begin
              if InputSuggestion <> '' then begin
                UserInput := InputSuggestion + ' ';
                InputSuggestion := '';
                Key := #0; //handled
                UpdateEditBox;
                ProcessAction;
              end;
              exit;
            end;
    end; {case}
  end;

  procedure TfrmTMGQuickConsole.btnAcceptClick(Sender: TObject);
  begin
    Self.ModalResult := mrOK;
  end;

  procedure TfrmTMGQuickConsole.ORDateBoxChange(Sender: TObject);
  begin
    TopicListDownloaded := false;
    //FINISH... trigger refresh...
  end;

  procedure TfrmTMGQuickConsole.UpdateEditBox;
  var HiText : string;
  begin
    IgnoreEditInputChanges := true;
    if LeftMatch(UpperCase(UserInput), UpperCase(InputSuggestion)) then begin
      HiText := MidStr(InputSuggestion, Length(UserInput)+1, 999);
    end else HiText := '';
    edtAction.Text := UserInput + HiText;
    Application.ProcessMessages;  //Process first change event for edtAction
    IgnoreEditInputChanges := true;  //Ignore next change event for edtAction also
    edtAction.SelStart := Length(UserInput);
    edtAction.SelLength := 999;
    Application.ProcessMessages;  //Process next change event for edtAction (if any)
    IgnoreEditInputChanges := false;
    if HiText <> '' then begin
      StatusBar.Panels[0].Text := 'Hint: Press <Space> to accept suggested input.';
    end else begin
      StatusBar.Panels[0].Text := '';
    end;
  end;

  procedure TfrmTMGQuickConsole.GetTopicList(OutSL : TStringList);
  var  //RPCSuccess : string;
       SDT, EDT : string;
  begin
    if not TopicListDownloaded then begin
      SDT := FloatToStr(ORDateBoxSDT.FMDateTime);
      EDT := FloatToStr(ORDateBoxEDT.FMDateTime);
      ProblemTopics(SavedTopicList,'LIST','HPI', '', SDT, EDT);
      if piece(SavedTopicList.Strings[0],'^',1)='-1' then begin
        ShowMessage(piece(SavedTopicList.Strings[0],'^',2));
        SavedTopicList.Clear;
      end else begin
        SavedTopicList.Delete(0);
        TopicListDownloaded := true;
      end;
    end;
    OutSL.Assign(SavedTopicList);
  end;

  procedure TfrmTMGQuickConsole.GetTagList(OutSL : TStringList);
  //Output format: 'TagName^ProblemName^ICD^ProblemIEN'
  var i : integer;
      ProbName,ICD,IEN,Tags, tempTag : string;
      x : string;
  begin
    GetProblemList(nil); //ensure that SavedProblemList is populated
    if not TagListPrepaired then begin
      SavedTagList.Clear;
      for i := 0 to SavedProblemList.Count - 1 do begin
        x := SavedProblemList.Strings[i];
        Tags := Piece(x, '^', 28);
        if Tags='' then continue;
        IEN  := Piece(x, '^',  1);
        ProbName := Piece(x, '^',  3);
        ICD  := Piece(x, '^',  4);
        repeat
          if Pos(',', Tags )> 0 then begin
            tempTag := piece(Tags, ',', 1);
            Tags := MidStr(Tags, Length(tempTag)+1,999);
            while (Length(Tags)>0) and (Tags[1] in [' ', ',']) do Tags := MidStr(Tags,2, 999);
          end else begin
            tempTag := Tags;
            Tags := '';
          end;
          SavedTagList.Add(tempTag+'^'+ProbName+'^'+ICD+'^'+IEN);
        until Tags = '';
      end;
      SavedTagList.Sort;
      TagListPrepaired := true;
    end;
    OutSL.Assign(SavedTagList);
  end;

  procedure TfrmTMGQuickConsole.GetProblemList(OutSL : TStringList);
  var i : integer;
  begin
    if not ProblemListDownloaded then begin
      FastAssign(ProblemList(Patient.DFN, 'B',FMNow), SavedProblemList) ;
      ProblemListDownloaded := true;
      for i := SavedProblemList.Count - 1 downto 0 do begin
        if piece(SavedProblemList.Strings[i], '^',2) <> 'A' then SavedProblemList.Delete(i); //only keep active problems.
      end;
    end;
    if assigned(OutSL) then OutSL.Assign(SavedProblemList);
  end;


  procedure TfrmTMGQuickConsole.ProcessAction;
  var CmdStr         : string;
      Cmd            : eCmd;
      //RPCSuccess     : string;
      i              : integer;
      //OneLine        : string;
      CmdFound       : boolean;
      s, Input       : string;
      //ch             : char;
  begin
    Timer.Enabled := false;
    lbOptions.Items.Clear;
    lbOptionsData.Clear;
    ActionString := '';
    ActionDataString := '';
    Input := UpperCase(UserInput);
    CmdStr := UpperCase(piece(Input, ' ', 1));
    s := Trim(pieces(Input, ' ', 2, 99));
    CmdFound := false;
    Cmd := cmdHelp;  //default
    for i := ord(cmdTemplate) to ord(cmdLASTCMD) do begin
      if not LeftMatch(CmdStr, COMMANDS[eCmd(i)]) then continue;
      CmdFound := true;
      Cmd := eCmd(i);  break;
    end;
    if not CmdFound then Cmd := cmdHelp;
    InputSuggestion := COMMANDS[Cmd];
    case Cmd of
      cmdHelp     : begin
                      ProcessHelp(s, lbOptions.Items, lbOptionsData);
                      HideOptionPanel;
                    end;
      cmdTemplate : begin
                      ProcessTemplate(s, lbOptions.Items, lbOptionsData);
                      HideOptionPanel;
                    end;
      cmdAdd      : begin
                      ProcessAdd(s, lbOptions.Items, lbOptionsData);
                    end;
    end; {case}
    UpdateEditBox;
    if lbOptions.Items.Count = 1 then begin
      lbOptions.ItemIndex := 0;
      if UpperCase(Trim(edtAction.Text)) <> UpperCase(lbOptions.Items.Strings[lbOptions.ItemIndex]) then begin
        InputSuggestion := lbOptions.Items.Strings[lbOptions.ItemIndex];
        UpdateEditBox;
      end;
    end;
  end;

  procedure TfrmTMGQuickConsole.ProcessHelp(Params : string; TargetSL : TStrings; DataSL : TStringList);
  var i : integer;
  begin
    for i := 1 to ord(cmdLASTCMD) do begin
      TargetSL.Add(COMMANDS[eCmd(i)]);
      DataSL.Add(HINT_TAG + '^'+COMMANDS[eCmd(i)]);
    end;
  end;

  procedure TfrmTMGQuickConsole.ProcessTemplate(Params : string; TargetSL : TStrings; DataSL : TStringList);
  var
    RPCSuccess : string;
    i : integer;
    OneLine : string;
    SavedResults : TStringList;
  begin
    SavedResults := TStringList.Create;
    try
      GetTopicList(SavedResults);  //<-- check this.  Is this needed?
      RPCSuccess := TMGSearchTemplates(SavedResults, Params, User.DUZ, CaseSensitiveStr);
      if piece(RPCSuccess,'^',1) <> '1' then exit;
      for i := 0 to SavedResults.Count - 1 do begin
        OneLine := SavedResults.Strings[i];
        DataSL.Add(TEMPLATE_DATA_TAG + '^'+OneLine);
        OneLine := piece(OneLine,'^',1);
        OneLine := piece(OneLine,';',2);
        OneLine :=  COMMANDS[cmdTemplate] + ' ' + OneLine;
        TargetSL.Add(OneLine);
      end;
    finally
      SavedResults.Free;
    end;
  end;

  procedure TfrmTMGQuickConsole.ProcessAdd(Params : string; TargetSL : TStrings; DataSL : TStringList);
  var
    temp, s : string;

  begin
    s := piece(Params, ' ' , 1);
    InputSuggestion := COMMANDS[cmdAdd];
    if LeftMatch(s, COMPONENT) then begin
      Params := Trim(pieces(Params, ' ', 2, 99));
      ProcessAddComp(Params, TargetSL, DataSL);
    end else begin
      temp := COMMANDS[cmdAdd] + ' ' + COMPONENT;
      TargetSL.Add(temp);
      DataSL.Add(HINT_TAG + '^' + temp);
      InputSuggestion := temp;
      HideOptionPanel;
    end;
  end;

  procedure TfrmTMGQuickConsole.ProcessAddComp(Params : string; TargetSL : TStrings; DataSL : TStringList);
  var
    temp, s : string;
  begin
    InputSuggestion := COMMANDS[cmdAdd] + ' ' + COMPONENT;
    s := piece(Params, ' ' , 1);
    Params := Trim(pieces(Params, ' ', 2, 99));
    if LeftMatch(s, COMP_PROBLEM) then begin
      ProcessAddProblemComp(Params, TargetSL, DataSL);
    end;
    if AtFPGLoc() and LeftMatch(s, COMP_TOPIC) then begin
      ProcessAddTopicComp(Params, TargetSL, DataSL, (UpperCase(s) = COMP_TOPIC));
    end;
    if LeftMatch(s, COMP_TAG) then begin
      ProcessAddTagComp(Params, TargetSL, DataSL, (UpperCase(s) = COMP_TAG));
    end;
    if TargetSL.Count = 0 then begin
      temp := COMMANDS[cmdAdd] + ' ' + COMPONENT + ' ' + COMP_PROBLEM;
      TargetSL.Add(temp);
      DataSL.Add(HINT_TAG + '^' + temp);
      if AtFPGLoc() then begin
        temp := COMMANDS[cmdAdd] + ' ' + COMPONENT + ' ' + COMP_TOPIC;
        TargetSL.Add(temp);
        DataSL.Add(HINT_TAG + '^' + temp);
      end;
      temp := COMMANDS[cmdAdd] + ' ' + COMPONENT + ' ' + COMP_TAG;
      DataSL.Add(HINT_TAG + '^' + temp);
      TargetSL.Add(temp);
      HideOptionPanel;
    end;
  end;

  procedure TfrmTMGQuickConsole.ProcessAddProblemComp(Params : string; TargetSL : TStrings; DataSL : TStringList);
  var
    //RPCSuccess : string;
    i : integer;
    //OneLine : string;
    slProblems : TStringList;
    ProblemName, ProblemICD, Entry, s : string;
    ADD_COMPONENT_PROBLEM : string;
  begin
    ADD_COMPONENT_PROBLEM := COMMANDS[cmdAdd] + ' ' + COMPONENT + ' ' + COMP_PROBLEM;
    s := piece(Params, ' ' , 1);
    InputSuggestion := ADD_COMPONENT_PROBLEM;
    slProblems := TStringList.Create;
    try
      GetProblemList(slProblems);
      for i := 0 to slProblems.Count - 1 do begin
        ProblemName := piece(slProblems.Strings[i], '^',3);
        if (s <> '') and (LeftMatch(s, UpperCase(ProblemName)) = false) then continue;
        Entry := Trim(ProblemName);
        ProblemICD := Trim(piece(slProblems.Strings[i], '^',4));
        if ProblemICD <> '' then Entry := Entry + ' ('+ProblemICD+')';
        Entry := Trim(Entry);
        if Entry = '' then continue;
        Entry := ADD_COMPONENT_PROBLEM + ' ' + Entry;
        TargetSL.Add(Entry);
        DataSL.Add(PROBLEM_DATA_TAG + '^'+slProblems.Strings[i]);
      end;
      HideOptionPanel;

    finally
      slProblems.Free;
    end;
  end;

  procedure TfrmTMGQuickConsole.ProcessAddTopicComp(Params : string; TargetSL : TStrings; DataSL : TStringList; ForceShow : boolean);
  var
    //RPCSuccess : string;
    i, Added : integer;
    //OneLine : string;
    ProbIEN, ProbName, ProbData : string;
    ProbIndex : integer;
    slTopics : TStringList;
    slTopicProbLink : TStringList;
    slProbData : TStringList;
    ATopic, s : string;
    //SDT, EDT : string;
    AddStr, AddData : string;
    ADD_COMPONENT_TOPIC : string;

  begin
    ADD_COMPONENT_TOPIC := COMMANDS[cmdAdd] + ' ' + COMPONENT + ' ' + COMP_TOPIC;
    slTopics := TStringList.Create;
    slTopicProbLink := TStringList.Create;
    slProbData := TStringList.Create;
    try
      s := piece(Params, ' ' , 1);
      InputSuggestion := ADD_COMPONENT_TOPIC;
      GetProblemList(slProbData);
      GetTopicList(slTopics);
      GetTopicProblemLink(slTopics, slTopicProbLink);
      Added := 0;
      for i := 0 to slTopics.Count - 1 do begin
        ProbName := ''; ProbData := '';
        ATopic := piece(slTopics.Strings[i], '^',1);
        if not ForceShow and (s = '') then continue;
        if (s <> '') and (LeftMatch(s, UpperCase(ATopic)) = false) then continue;
        ProbIndex := FindPiece(slTopicProbLink,'^', 1, ATopic);  //FindPiecesNodes(slTopicProbLink,'^', ATopic);
        if ProbIndex > -1 then begin
          ProbIEN := Piece(slTopicProbLink[ProbIndex],'^',4);
          if ProbIEN <> '' then begin
            ProbIndex := FindPiece(slProbData, '^', 1, ProbIEN);
            //ProbIndex := FindPiecesNodes(slProbData, '^', ProbIEN);
            if ProbIndex>-1 then begin
              ProbData := slProbData.Strings[ProbIndex];
              ProbName := Piece(ProbData,'^',3);
            end;
          end;
        end;
        if ProbName <> '' then begin
          AddStr := ADD_COMPONENT_TOPIC + ' ' + ATopic + ' <--> Problem: ' + ProbName;
          AddData := PROBLEM_DATA_TAG + '^' + ProbData;
        end else begin
          AddStr := ADD_COMPONENT_TOPIC + ' ' + ATopic;
          AddData := TOPIC_DATA_TAG + '^' + slTopics.Strings[i];
        end;
        if TargetSL.IndexOf(AddStr) > -1 then continue;
        TargetSL.Add(AddStr);
        DataSL.Add(AddData);
        Inc(Added);
      end;
      if Added = 0 then begin
        TargetSL.Add(ADD_COMPONENT_TOPIC);
        DataSL.Add(HINT_TAG + '^' +ADD_COMPONENT_TOPIC);
      end;
      ShowOptionPanel;
    finally
      slTopics.Free;
      slTopicProbLink.Free;
      slProbData.Free
    end;
  end;

  procedure TfrmTMGQuickConsole.ProcessAddTagComp(Params : string; TargetSL : TStrings; DataSL : TStringList; ForceShow : boolean);
  var
    i, Added : integer;
    slTags, TagsShown : TStringList;
    ATag, s, ProbName, ICD, temp: string;
    ADD_COMPONENT_TAG : string;

  begin
    ADD_COMPONENT_TAG := COMMANDS[cmdAdd] + ' ' + COMPONENT + ' ' + COMP_TAG;
    slTags := TStringList.Create;
    TagsShown := TStringList.Create;
    try
      //s := piece(Params, ' ' , 1);
      InputSuggestion := ADD_COMPONENT_TAG;
      GetTagList(slTags);  //format: 'TagName^ProblemName^ICD^ProblemIEN';
      Added := 0;
      for i := 0 to slTags.Count - 1 do begin
        ATag := UpperCase(piece(slTags.Strings[i], '^',1));
        ProbName := piece(slTags.Strings[i], '^',2);
        ICD := piece(slTags.Strings[i], '^',3);
        temp := ATag + ' -- ' + ProbName;
        if ICD <> '' then temp := temp + ' (' + ICD + ')';
        if not ForceShow and (Params = '') then continue;
        if (Params <> '') and (LeftMatch(Params, UpperCase(temp)) = false) then continue;
        TargetSL.Add(ADD_COMPONENT_TAG + ' ' + temp);
        DataSL.Add(TAG_DATA_TAG + '^'+slTags.Strings[i]);
        if TagsShown.IndexOf(ATag) = -1 then TagsShown.Add(ATag);
        Inc(Added);
      end;
      if TagsShown.Count = 1 then begin
        InputSuggestion := ADD_COMPONENT_TAG + ' ' + TagsShown.Strings[0] + ' --';
      end;
      if Added = 0 then begin
        TargetSL.Add(ADD_COMPONENT_TAG);
        DataSL.Add(HINT_TAG + '^' +ADD_COMPONENT_TAG);
      end;
      HideOptionPanel;
    finally
      slTags.Free;
      TagsShown.Free;
    end;
  end;

  procedure TfrmTMGQuickConsole.lbOptionsChange(Sender: TObject);
  begin
    ActionString := '';
    ActionDataString := '';
    if lbOptions.ItemIndex > -1 then begin
      ActionString := lbOptions.Items.Strings[lbOptions.ItemIndex];
      ActionDataString := lbOptionsData.Strings[lbOptions.ItemIndex];
    end;
  end;

procedure TfrmTMGQuickConsole.lbOptionsClick(Sender: TObject);
  //var SourceLine, Part: string;
  //    i : integer;
  begin
    //StatusBar.Panels[0].Text := '';
    //if edtAction.Text = '' then begin
    IgnoreEditInputChanges := true;
    UserInput := lbOptions.Items.Strings[lbOptions.ItemIndex];
    edtAction.Text := UserInput + ' ';
    ProcessAction;
    //end;
  end;

  procedure TfrmTMGQuickConsole.lbOptionsDblClick(Sender: TObject);
  begin
    lbOptionsClick(Sender);
    btnAcceptClick(Sender);
  end;

  procedure TfrmTMGQuickConsole.lbMatchesEnter(Sender: TObject);
  begin
    lbOptions.ItemIndex := 0;
    lbOptionsClick(Sender);
  end;

  procedure TfrmTMGQuickConsole.TimerTimer(Sender: TObject);
  begin
    if IgnoreEditInputChanges then begin IgnoreEditInputChanges := false; exit; end;
    ProcessAction;
  end;

  procedure TfrmTMGQuickConsole.ShowOptionPanel;
  begin
    RedrawSuspend(pnlBottom.Handle);
    SetDateGroupVisability(true);
    pnlBottom.Height := StatusBar.Height + pnlOptions.Height + 1 ;
    RedrawActivate(pnlBottom.Handle);
  end;

  procedure TfrmTMGQuickConsole.HideOptionPanel;
  begin
    RedrawSuspend(pnlBottom.Handle);
    SetDateGroupVisability(false);
    pnlBottom.Height := StatusBar.Height + 1;
    RedrawActivate(pnlBottom.Handle);
  end;

  procedure TfrmTMGQuickConsole.SetDateGroupVisability(Visible : boolean);
  begin
    pnlOptions.Visible := Visible;
    lblFilterSDT.Visible := Visible;
    lblFilterEDT.Visible := Visible;
    ORDateBoxSDT.Visible := Visible;
    ORDateBoxEDT.Visible := Visible;
  end;

end.

