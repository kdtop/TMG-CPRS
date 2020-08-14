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
  fDrawers,fNotes,fReminderDialog,uReminders,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons;

type
  TSearchMode = (TsmTemplate, TsmDialog);

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
    procedure DoTemplateSearch;
    procedure DoDialogSearch;
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
  begin
    fTemplateSearch.SearchMode := Mode;
    frmTemplateSearch := TfrmTemplateSearch.Create(frmFrame);
    if Mode=TsmDialog then
      frmTemplateSearch.PageControl1.ActivePage := frmTemplateSearch.tsReminders
    else
      frmTemplateSearch.PageControl1.ActivePage := frmTemplateSearch.tsTemplates;
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
  begin
    Self.ModalResult := mrOK;
  end;

  procedure TfrmTemplateSearch.DoDialogSearch;
  var OneLine:string;
      i : integer;
  begin
    Timer.Enabled := false;
    lbTemMatches.Items.Clear;
    frmNotes.Drawers.ReminderSearch(SavedResults,edtTemSearchTerms.Text);
    for i := 0 to SavedResults.Count - 1 do begin
      OneLine := SavedResults.Strings[i];
      OneLine := piece(OneLine,'^',1);
      OneLine := piece(OneLine,';',2);
      lbTemMatches.Items.Add(OneLine);
    end;
  end;

  procedure TfrmTemplateSearch.DoTemplateSearch;
  var cmd  : string;
      RPCSuccess : string;
      i : integer;
      OneLine : string;
  begin
    Timer.Enabled := false;
    lbTemMatches.Items.Clear;
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
    for i := 0 to SavedResults.Count - 1 do begin
      OneLine := SavedResults.Strings[i];
      OneLine := piece(OneLine,'^',1);
      OneLine := piece(OneLine,';',2);
      lbTemMatches.Items.Add(OneLine);
    end;
    if SavedResults.Count = 1 then begin  //autoselect if only 1 option
      lbTemMatchesEnter(nil);
    end;
  end;

  procedure TfrmTemplateSearch.lbTemMatchesClick(Sender: TObject);
  var SourceLine, Part: string;
      i : integer;
  begin
    StatusBar.Panels[0].Text := '';
    SourceLine := SavedResults.Strings[lbTemMatches.ItemIndex];
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
    end;

  end;

procedure TfrmTemplateSearch.TimerTimer(Sender: TObject);
  begin
  if SearchMode=TsmDialog then
    DoDialogSearch
  else
    DoTemplateSearch;
  end;

  end.

