unit fTemplateSearch;
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
  fDrawers,fNotes,fReminderDialog,uReminders,uTMGOptions,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, TMGHTML2;

type
  TSearchMode = (TsmTemplate, TsmDialog, TsmAll, TsmTempOnly, TsmTopic);

  TfrmTemplateSearch = class(TForm)
    Timer: TTimer;
    PageControl1: TPageControl;
    tsTemplates: TTabSheet;
    tsReminders: TTabSheet;
    edtTemSearchTerms: TEdit;
    btnTemAccept: TBitBtn;
    btnTemCancel: TBitBtn;
    lbTemMatches: TListBox;
    StatusBar: TStatusBar;
    tsTopics: TTabSheet;
    tsAll: TTabSheet;
    procedure FormShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnTemAcceptClick(Sender: TObject);
    procedure lbTemMatchesEnter(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure lbTemMatchesDblClick(Sender: TObject);
    procedure lbTemMatchesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtTemSearchTermsChange(Sender: TObject);
  private
    { Private declarations }
    SavedResults : TStringList;
    CaseSensitiveStr : string;  //should be "0" or "1"
    procedure DoTemplateSearch(AllSearch:Boolean = False);
    procedure DoDialogSearch(AllSearch:Boolean = False);
    procedure DoAllSearch;
    procedure DoTopicSearch;
    procedure GetSearchResults();
  public
    { Public declarations }
    SelectedInfo : string;  //  topIEN^childIEN^grandchildIEN^... etc
  end;

  procedure LaunchTemplateSearch(Drawers : TfrmDrawers; Mode : TSearchMode);  forward;
  function InsertTemplateByName(Drawers : TfrmDrawers; AName : String) : boolean;   //not interactive

var
//  frmTemplateSearch: TfrmTemplateSearch;
  SearchMode: TSearchMode;


implementation

{$R *.dfm}
uses
  ORNet,   ORFn, fFrame,
  uTemplates, rTIU,
  uCore, dShared;

const
  TIMER_DELAY = 200; //500 ms = 0.5 seconds

  function SelectTemplateNodePath(Drawers : TfrmDrawers; IENPath : string) : TTreeNode;

    function FindMatchingChild(ParentNode : TTreeNode; IENStr : String) : TTreeNode;

      function IsMatch(ANode : TTreeNode; IEN : string) : boolean;
      var Template : TTemplate;
      begin
        Result := false;
        Template := TTemplate(ANode.Data);
        Result := Template.ID = IEN;
      end;

    var Sibling : TTreeNode;
        Matched : boolean;
    begin
      if ParentNode = nil then begin
        //There isn't a true 'root'.  Just top level children of the tvTemplates.Items property
        Sibling := Drawers.tvTemplates.Items.GetFirstNode;
      end else begin
        Sibling := ParentNode.getFirstChild;
      end;
      Result := nil;
      repeat
        if Sibling = nil then break;
        Matched := IsMatch(Sibling, IENStr);
        if Matched then break;
        Sibling := Sibling.getNextSibling;
      until Matched=true;
      if Matched then Result := Sibling;
    end;

  var CurNode : TTreeNode;
      i, MaxNode : integer;
      OneIENStr : string;
  begin
    CurNode := nil;
    MaxNode := NumPieces(IENPath,'^');
    for i := 1 to MaxNode do begin
       OneIENStr := piece(IENPath,'^',i);
       CurNode := FindMatchingChild(CurNode, OneIENStr);
       if CurNode = nil then break;
       if i <> MaxNode then begin
         Drawers.ExpandParentNode(CurNode);  //ELH replaced below call with this one
         //CurNode.Expand(false);  //false = no recurse
         //Drawers.tvTemplates.Expand(CurNode);
       end
    end;
    Result := CurNode;
  end;

  function InsertTemplateByName(Drawers : TfrmDrawers; AName : String) : boolean;
  //not interactive
  //finds the **first** exact match (case sensitive) to AName
  var cmd  : string;
      RPCSuccess : string;
      i,j : integer;
      OneName, OneLine, Part : string;
      SearchResults : TStringList;
      SelectedInfo : string;  //  topIEN^childIEN^grandchildIEN^... etc
      SelNode: TTreeNode;
  begin
    Result := False;
    SearchResults := TStringList.Create;
    try
      RPCSuccess := TMGSearchTemplates(SearchResults, AName, User.DUZ, '1');  //'1' = case sensitive
      if piece(RPCSuccess,'^',1) <> '1' then exit;
      for i := 0 to SearchResults.Count - 1 do begin
        OneLine := SearchResults.Strings[i];
        OneName := piece(OneLine,'^',1);
        OneName := piece(OneName,';',2);
        if OneName <> AName then continue;
        SelectedInfo := '';
        for j := NumPieces(OneLine,'^') downto 1 do begin
          if SelectedInfo <> '' then SelectedInfo := SelectedInfo + '^';
          Part := piece(OneLine,'^',j);
          SelectedInfo := SelectedInfo +piece(Part,';',1);
        end;
        break;
      end;
      if SelectedInfo = '' then exit;
      SelNode := SelectTemplateNodePath(Drawers, SelectedInfo);
      if not assigned(SelNode) then exit;
      Drawers.tvTemplates.Selected := SelNode;
      Drawers.tvTemplatesClick(nil);  //must first have a click before a doubleclick.
      Drawers.tvTemplatesDblClick(nil);
      Result := true;
    finally
      SearchResults.Free;
    end;
  end;

  procedure LaunchTemplateSearch(Drawers : TfrmDrawers; Mode : TSearchMode);
  var frmTemplateSearch: TfrmTemplateSearch;
      SelNode : TTreeNode;
      SelectedInfo : string;
      ModalResult : integer;
      i,node_index,ParentNode : integer;
      TopicText : TStringList;
      Topic,TIUIEN : string;
      HTMLEditor : THTMLObj;
  begin
    fTemplateSearch.SearchMode := Mode;
    frmTemplateSearch := TfrmTemplateSearch.Create(frmFrame);
    if Mode=TsmTempOnly then begin
      frmTemplateSearch.tsAll.TabVisible := false;
      frmTemplateSearch.tsReminders.TabVisible := false;
      frmTemplateSearch.PageControl1.ActivePage := frmTemplateSearch.tsTemplates;
    end else begin
      if uTMGOptions.ReadBool('TemplateReminder Search Begins With All',False) then begin
        frmTemplateSearch.PageControl1.ActivePage := frmTemplateSearch.tsAll;
      end else begin
        if Mode=TsmDialog then
          frmTemplateSearch.PageControl1.ActivePage := frmTemplateSearch.tsReminders
        else if Mode=TsmDialog then
          frmTemplateSearch.PageControl1.ActivePage := frmTemplateSearch.tsTopics
        else
          frmTemplateSearch.PageControl1.ActivePage := frmTemplateSearch.tsTemplates;
      end;
    end;
    frmTemplateSearch.PageControl1Change(nil);
    ModalResult := frmTemplateSearch.ShowModal;
    //Check mode here and add functionality for dialogs
    SelectedInfo := frmTemplateSearch.SelectedInfo;
    frmTemplateSearch.Free;
    if ModalResult = mrOK then begin
      if fTemplateSearch.SearchMode = TsmTemplate then begin
        if (Drawers.TheOpenDrawer <> odTemplates) then Drawers.sbTemplatesClick(nil); //Ensure Templates drawer is open
        SelNode := SelectTemplateNodePath(Drawers, SelectedInfo);
        if SelNode <> nil then begin
          Drawers.tvTemplates.Selected := SelNode;
          Drawers.tvTemplatesClick(nil);  //must first have a click before a doubleclick.
          Drawers.tvTemplatesDblClick(nil);
        end;
      end else if fTemplateSearch.SearchMode = TsmDialog then begin
        if Drawers.TheOpenDrawer <> odReminders then Drawers.sbRemindersClick(nil);
        ParentNode := strtoint(piece(SelectedInfo,'^',1));
        node_index := strtoint(piece(SelectedInfo,'^',2));
        //SelNode := SelectTemplateNodePath(Drawers,SelectedInfo);
        //if SelNode <> nil then begin
         // Drawers.tvReminders.Selected := SelNode;
          //Drawers.tvRemindersMouseUp(nil,mbLeft);  //must first have a click before a doubleclick.
         // ViewReminderDialog(ReminderNode(Drawers.tvReminders.Selected));
          //Drawers.tvRemindersDblClick(nil);
        //end;
        for i:=0 to Drawers.tvReminders.Items.count-1 do begin   //TreeView1.Items.Count - 1 do begin
          if (Drawers.tvReminders.Items[i].Parent.Index = ParentNode) and (Drawers.tvReminders.Items[i].Index = node_index) then begin
            Drawers.tvReminders.Select(Drawers.tvReminders.Items[i]);
            Drawers.tvReminders.SetFocus;
            ViewReminderDialog(ReminderNode(Drawers.tvReminders.Selected));
            break;
          end;

        end;
      end else if fTemplateSearch.SearchMode = TsmTopic then begin
        TopicText := TStringList.create;
        TIUIEN := piece(SelectedInfo,'^',2);
        Topic := piece(SelectedInfo,'^',3);
        tCallV(TopicText,'TMG CPRS GET ONE PATIENT TOPIC',[TIUIEN,Topic,inttostr(User.DUZ)]);
        //ShowMessage(TopicText.Text);
        HTMLEditor := Drawers.HTMLEditControl;
        HTMLEditor.InsertHTMLAtCaret(TopicText.Text);
        //frmNotes.InsertText(TopicText.Text);
        TopicText.free;
      end;
    end;
  end;

  procedure TfrmTemplateSearch.edtTemSearchTermsChange(Sender: TObject);
  var LastChar : Char;
      Len : integer;
      i : integer;
      OneLine:string;
  begin
    StatusBar.Panels[0].Text := '';
    Len := Length(edtTemSearchTerms.Text);
    if Len > 1 then begin   //Added because if Len 0 then program crashed
      LastChar := edtTemSearchTerms.Text[Len];
      if fTemplateSearch.SearchMode = TsmTemplate then begin
        if LastChar=' ' then begin
          DoTemplateSearch; //Launch search directly after every space
        end else begin
          Timer.Interval := TIMER_DELAY; // I think this starts the countdown again
          Timer.Enabled := true;
          //So as long as user keeps changing search terms, search will not launch
          //until there has been a 0.5 second pause.
        end;
      end else if fTemplateSearch.SearchMode = TsmDialog then begin
        if LastChar=' ' then begin
          DoDialogSearch; //Launch search directly after every space
        end else begin
          Timer.Interval := TIMER_DELAY; // I think this starts the countdown again
          Timer.Enabled := true;
          //So as long as user keeps changing search terms, search will not launch
          //until there has been a 0.5 second pause.
        end;
     end else if fTemplateSearch.SearchMode = TsmTempOnly then begin
        if LastChar=' ' then begin
          DoTemplateSearch; //Launch search directly after every space
        end else begin
          Timer.Interval := TIMER_DELAY; // I think this starts the countdown again
          Timer.Enabled := true;
          //So as long as user keeps changing search terms, search will not launch
          //until there has been a 0.5 second pause.
        end;
      {end else if fTemplateSearch.SearchMode = TsmTopic then begin
        if LastChar=' ' then begin
          DoTopicSearch; //Launch search directly after every space
        end else begin
          Timer.Interval := TIMER_DELAY; // I think this starts the countdown again
          Timer.Enabled := true;
          //So as long as user keeps changing search terms, search will not launch
          //until there has been a 0.5 second pause.
        end;}
      end else if fTemplateSearch.SearchMode = TsmAll then begin
        if LastChar=' ' then begin
          DoAllSearch; //Launch search directly after every space
        end else begin
          Timer.Interval := TIMER_DELAY; // I think this starts the countdown again
          Timer.Enabled := true;
          //So as long as user keeps changing search terms, search will not launch
          //until there has been a 0.5 second pause.
        end;
      end;
    end else if fTemplateSearch.SearchMode = TsmTopic then begin
        if LastChar=' ' then begin
          DoTopicSearch; //Launch search directly after every space
        end else begin
          Timer.Interval := TIMER_DELAY; // I think this starts the countdown again
          Timer.Enabled := true;
          //So as long as user keeps changing search terms, search will not launch
          //until there has been a 0.5 second pause.
        end;
      end;
  end;


  procedure TfrmTemplateSearch.FormCreate(Sender: TObject);
  var Pos : TPoint;
  begin
    SavedResults := TStringList.Create();
    CaseSensitiveStr := '0';  //later hook into checkbox.
    if fTemplateSearch.SearchMode=TsmTemplate then
      DoTemplateSearch()  //fill box initially with ALL templates
    else
      DoDialogSearch;
    Pos := Mouse.CursorPos;
    self.Top := Pos.Y; self.Left := Pos.X;
  end;

  procedure TfrmTemplateSearch.FormDestroy(Sender: TObject);
  begin
    SavedResults.Free
  end;

procedure TfrmTemplateSearch.FormShow(Sender: TObject);
begin
  edtTemSearchTerms.SetFocus;
end;

procedure TfrmTemplateSearch.btnTemAcceptClick(Sender: TObject);
  var SelType:string;
  begin
    if SearchMode=TsmAll then begin
      SelType := piece2(SavedResults.Strings[lbTemMatches.ItemIndex],'#@@#',3);
      if SelType='DIALOG' then SearchMode := TsmDialog;
      if SelType='TEMPLATE' then SearchMode := TsmTemplate;
      if SelType='TOPIC' then SearchMode := TsmTopic;
    end;
    if SearchMode=TsmAll then begin  //Shouldn't be needed but just in case
      messagedlg('There was an unknown error determining the type of selection.'+#13#10+'Try changing to the appropriate tab and select from there.',mtError,[mbOk],0);
      exit;
    end;
    Self.ModalResult := mrOK;
  end;

  procedure TfrmTemplateSearch.GetSearchResults();
  //This will run the appropriate searchs and load results
      procedure GetTemplateResults(SearchString:string;User:Int64;var SavedResults:TStringList);
      var cmd,OneLine  : string;
        RPCSuccess : string;
        i : integer;
        TempResults:TStringList;
      begin
        TempResults := TStringList.create();
        RPCSuccess := TMGSearchTemplates(TempResults, SearchString, User, '0');
        if piece(RPCSuccess,'^',1) <> '1' then exit;

        for i := 0 to TempResults.Count - 1 do begin
          OneLine := TempResults.Strings[i];
          OneLine := piece(OneLine,'^',1);
          OneLine := piece(OneLine,';',2);
          SavedResults.Add(OneLine+'#@@#'+TempResults.Strings[i]+'#@@#TEMPLATE');
        end;
        TempResults.Free;
        //if SavedResults.Count = 1 then begin  //autoselect if only 1 option
        //  lbTemMatchesEnter(nil);
        //end;
      end;

      procedure GetDialogResults(SearchString:string;var SavedResults:TStringList);
        var i : integer;
            TempResults:TStringList;
            OneLine:string;
        begin
          TempResults := TStringList.create();
          frmNotes.Drawers.ReminderSearch(TempResults,SearchString);
          for i := 0 to TempResults.Count - 1 do begin
            OneLine := TempResults.Strings[i];
            OneLine := piece(OneLine,'^',1);
            OneLine := piece(OneLine,';',2);
            SavedResults.Add(OneLine+'#@@#'+TempResults.Strings[i]+'#@@#DIALOG');
          end;
          TempResults.free;
      end;

      procedure GetTopicResults(SearchString:string;User:Int64; DFN:string; var SavedResults:TStringList);
      var
         TempResults:TStringList;
         i : integer;
         Topic:string;
      begin
         TempResults := TStringList.create();
         tCallV(TempResults,'TMG CPRS PATIENT TOPIC SEARCH',[DFN,SearchString]);
         for I := 0 to TempResults.Count - 1 do begin
           Topic := piece(TempResults[i],'^',1);
           SavedResults.Add(Topic+'#@@#'+TempResults[i]+'#@@#TOPIC');
         end;
         TempResults.free;
      end;
  var
    OneLine:string;
    i:integer;
  begin
    Timer.Enabled := false;
    SavedResults.Clear;
    lbTemMatches.Items.Clear;
    case SearchMode of
      TsmTemplate: begin
        GetTemplateResults(edtTemSearchTerms.Text,User.DUZ,SavedResults);
      end;
      TsmDialog: begin
        GetDialogResults(edtTemSearchTerms.Text,SavedResults);
      end;
      TsmTempOnly: begin
        GetTemplateResults(edtTemSearchTerms.Text,User.DUZ,SavedResults);
      end;
      TsmTopic: begin
        GetTopicResults(edtTemSearchTerms.Text,User.DUZ,Patient.DFN,SavedResults);
      end;
      TsmAll: begin
        GetTemplateResults(edtTemSearchTerms.Text,User.DUZ,SavedResults);
        GetDialogResults(edtTemSearchTerms.Text,SavedResults);
        GetTopicResults(edtTemSearchTerms.Text,User.DUZ,Patient.DFN,SavedResults);
      end;
    end;
    //NowLoadTheResultsHere
    SavedResults.Sort;
    for I := 0 to SavedResults.Count - 1 do begin
      OneLine := piece2(SavedResults.Strings[i],'#@@#',1);
      //OneLine := piece(OneLine,'^',1);
      //OneLine := piece(OneLine,';',2);
      if SearchMode=TsmAll then OneLine:=OneLine+' ('+piece2(SavedResults.Strings[i],'#@@#',3)+')';
      lbTemMatches.Items.Add(OneLine);
    end;
    if SavedResults.Count = 1 then begin  //autoselect if only 1 option
        lbTemMatchesEnter(nil);
    end;
  end;

  procedure TfrmTemplateSearch.DoDialogSearch(AllSearch:Boolean = False);
  var OneLine:string;
      i : integer;
  begin
    GetSearchResults;
    {
    Timer.Enabled := false;
    if AllSearch=False then lbTemMatches.Items.Clear;
    frmNotes.Drawers.ReminderSearch(SavedResults,edtTemSearchTerms.Text);
    for i := 0 to SavedResults.Count - 1 do begin
      OneLine := SavedResults.Strings[i];
      OneLine := piece(OneLine,'^',1);
      OneLine := piece(OneLine,';',2);
      lbTemMatches.Items.Add(OneLine);
    end;
    }
  end;

  procedure TfrmTemplateSearch.DoTemplateSearch(AllSearch:Boolean = False);
  var cmd  : string;
      RPCSuccess : string;
      i : integer;
      OneLine : string;
  begin
    GetSearchResults;
    {
    Timer.Enabled := false;
    if AllSearch = False then lbTemMatches.Items.Clear;
    RPCSuccess := TMGSearchTemplates(SavedResults, edtTemSearchTerms.Text, User.DUZ, CaseSensitiveStr);
    if piece(RPCSuccess,'^',1) <> '1' then exit;
    {
    CallV('TMG CPRS SEARCH TEMPLATE', [edtSearchTerms.Text, User.DUZ, CaseSensitiveStr]);
    SavedResults.Assign(RPCBrokerV.Results);
    if SavedResults.Count > 0 then begin
      RPCSuccess := SavedResults.Strings[0];
      SavedResults.Delete(0);
      if piece(RPCSuccess,'^',1) <> '1' then exit;
    end;
    }
    {
    for i := 0 to SavedResults.Count - 1 do begin
      OneLine := SavedResults.Strings[i];
      OneLine := piece(OneLine,'^',1);
      OneLine := piece(OneLine,';',2);
      lbTemMatches.Items.Add(OneLine);
    end;
    if SavedResults.Count = 1 then begin  //autoselect if only 1 option
      lbTemMatchesEnter(nil);
    end;
    }
  end;

  procedure TfrmTemplateSearch.DoAllSearch;
  var OneLine:string;
      i : integer;
  begin
    GetSearchResults;
  {
    lbTemMatches.Items.Clear;
    DoTemplateSearch(True);
    DoDialogSearch(True);
    }
  end;

  procedure TfrmTemplateSearch.DoTopicSearch;
  var OneLine:string;
      i : integer;
  begin
    GetSearchResults;
  end;

  procedure TfrmTemplateSearch.lbTemMatchesClick(Sender: TObject);
  var SourceLine, Part: string;
      i : integer;
  begin
    StatusBar.Panels[0].Text := '';
    SourceLine := piece2(SavedResults.Strings[lbTemMatches.ItemIndex],'#@@#',2);
    SelectedInfo := '';
    if lbTemMatches.ItemIndex > -1 then begin
      for i := NumPieces(SourceLine,'^') downto 1 do begin
        if StatusBar.Panels[0].Text <> '' then StatusBar.Panels[0].Text := StatusBar.Panels[0].Text + '/';
        if SelectedInfo <> '' then SelectedInfo := SelectedInfo + '^';
        Part := piece(SourceLine,'^',i);
        StatusBar.Panels[0].Text := StatusBar.Panels[0].Text +piece(Part,';',2);
        SelectedInfo := SelectedInfo +piece(Part,';',1);
      end;
    end;
  end;

  procedure TfrmTemplateSearch.lbTemMatchesDblClick(Sender: TObject);
  begin
    lbTemMatchesClick(Sender);
    btnTemAcceptClick(Sender);
  end;

  procedure TfrmTemplateSearch.lbTemMatchesEnter(Sender: TObject);
  begin
    lbTemMatches.ItemIndex := 0;
    lbTemMatchesClick(Sender);
  end;

  procedure TfrmTemplateSearch.PageControl1Change(Sender: TObject);
  begin
    SavedResults.Clear;
    lbTemMatches.clear;
    StatusBar.Panels[0].Text := '';
    case PageControl1.ActivePageIndex of
    0: begin
      fTemplateSearch.SearchMode := TsmTemplate;
      Caption := 'Search Templates';
      DoTemplateSearch;
      end;
    1: begin
      fTemplateSearch.SearchMode := TsmDialog;
      Caption := 'Search Reminder Dialogs';
      DoDialogSearch;
      end;
    2: begin
      fTemplateSearch.SearchMode := TsmTopic;
      Caption := 'Search Patient''s Topics';
      DoTopicSearch;
      end;
    3: begin
      fTemplateSearch.SearchMode := TsmAll;
      Caption := 'Search Both Reminder Dialogs and Templates';
      DoAllSearch;
      end;
    end;

  end;

procedure TfrmTemplateSearch.TimerTimer(Sender: TObject);
  begin
    if SearchMode=TsmDialog then begin
      DoDialogSearch;
    end else if SearchMode=TsmTemplate then begin
      DoTemplateSearch;
    end else if SearchMode=TsmTempOnly then begin
      DoTemplateSearch;
    end else if SearchMode=TsmTopic then begin
      DoTopicSearch;
    end else begin
      DoAllSearch;
    end;
  end;

  end.

