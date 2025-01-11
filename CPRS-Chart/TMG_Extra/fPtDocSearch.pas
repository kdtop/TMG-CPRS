unit fPtDocSearch;
//kt added this entire unit 6/2010
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
  Dialogs, OleCtrls, SHDocVw, ExtCtrls, ORCtrls, StdCtrls, Buttons,
  StrUtils, ORNet, ORFn, Trpcb, uCore, rTIU, TMGHTML2, uHTMLTools;

type
  TfrmPtDocSearch = class(TForm)
    pnlLeft: TPanel;
    LRSplitter: TSplitter;
    pnlRight: TPanel;
    pnlButtons: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    lblSearchTerms: TLabel;
    edtSearchTerms: TEdit;
    cboFoundNotes: TORComboBox;
    Timer: TTimer;
    btnDone: TBitBtn;
    Label1: TLabel;
    FocusTimer: TTimer;
    radSearchType: TRadioGroup;
    procedure radSearchTypeClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cboFoundNotesDblClick(Sender: TObject);
    procedure FocusTimerTimer(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtSearchTermsChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cboFoundNotesNeedData(Sender: TObject;
      const StartFrom: String; Direction, InsertAt: Integer);
    procedure FormHide(Sender: TObject);
    procedure cboFoundNotesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    PriorSearchStr : string;
    SearchInProgress : boolean;
    HtmlViewer : THtmlObj; //kt 8/09
    NoteText : TStringList;
    FirstRun : boolean;
    function GetStatus : string;
    procedure LaunchSearch;
    procedure ShowResults;
    //procedure ShowDocument(noteIEN : Integer; HtmlViewer: THTMLObj; NoteText:TStringList);
    //procedure HighlightTerms(Lines : TStringList; SearchStr : string);
    //procedure SrchToList(CONST SearchStr : String; Lines : TStringList);
  public
    { Public declarations }
    SelectedNoteIEN : Integer;
  end;

//var
//  frmPtDocSearch: TfrmPtDocSearch;

procedure ShowDocument(noteIEN : Integer; HtmlViewer: THTMLObj; NoteText:TStringList; SearchStr:string); forward;

implementation

{$R *.dfm}


const
  TIMER_DELAY = 500; //500 ms = 0.5 seconds

  procedure TfrmPtDocSearch.FocusTimerTimer(Sender: TObject);
begin
   edtSearchTerms.SetFocus;
   focustimer.Enabled := false;
end;

procedure TfrmPtDocSearch.FormCreate(Sender: TObject);
  begin
    FirstRun := True;;
    SelectedNoteIEN := 0;
    NoteText := TStringList.Create;
    HtmlViewer := THtmlObj.Create(pnlRight, Application);
    TWinControl(HtmlViewer).Parent := pnlRight;
    TWinControl(HtmlViewer).Align := alClient;
    //Note: A 'loaded' function will initialize the THtmlObj's, but it can't be
    //      done until after this constructor is done, and this TfrmNotes has been
    //      assigned a parent.  So done elsewhere.
  end;

  procedure TfrmPtDocSearch.FormDestroy(Sender: TObject);
  begin
    NoteText.Free;
    HtmlViewer.Free;
  end;

  procedure TfrmPtDocSearch.FormShow(Sender: TObject);
  begin
    HTMLViewer.Loaded;
    //edtSearchTerms.SetFocus;
  end;


  procedure TfrmPtDocSearch.LaunchSearch;
  var cmd  : string;
  begin
    Timer.Enabled := false;
    cboFoundNotes.Enabled := False;
    PriorSearchStr := edtSearchTerms.Text;
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';
    RPCBrokerV.param[0].ptype := list;
    cmd := 'PT DOCS SEARCH';
    cmd := cmd + '^' + Patient.DFN + '^' + edtSearchTerms.Text + '^' + inttostr(radSearchType.ItemIndex);
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    CallBroker;  //I will ignore results -- it is always 1^Success
    SearchInProgress := true;
    HTMLViewer.Clear;
    SelectedNoteIEN := 0;
    Timer.Enabled := true;
  end;

procedure TfrmPtDocSearch.radSearchTypeClick(Sender: TObject);
var cmd  : string;
  begin
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';
    RPCBrokerV.param[0].ptype := list;
    cmd := 'PT DOCS CLEAR';
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    CallBroker;
    cboFoundNotes.Items.Clear;
    edtSearchTerms.Text := '';
end;

procedure TfrmPtDocSearch.edtSearchTermsChange(Sender: TObject);
  var LastChar : Char;
      Len : integer;
  begin
    Len := Length(edtSearchTerms.Text);
    if Len > 1 then begin   //Added because if Len 0 then program crashed
      LastChar := edtSearchTerms.Text[Len];
      if LastChar=' ' then begin
        LaunchSearch; //Launch search directly after every space
      end else begin
        Timer.Interval := TIMER_DELAY; // I think this starts the countdown again
        Timer.Enabled := true;
        //So as long as user keeps changing search terms, search will not launch
        //until there has been a 0.5 second pause.
      end;
    end;
  end;

  procedure TfrmPtDocSearch.TimerTimer(Sender: TObject);
  //Check if new search should be launched
  var Status : string;
  begin
    Timer.Enabled := false;
    if edtSearchTerms.Text <> PriorSearchStr then begin
      LaunchSearch;
    end else if SearchInProgress then begin
      Status := GetStatus;
      if Status='DONE' then begin
        SearchInProgress := false;
        ShowResults;
      end;
    end;
    Timer.Enabled := true;
  end;


  function TfrmPtDocSearch.GetStatus : string;
  var cmd  : string;
     RPCResult : String;
  begin
    Result := ''; //default
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';
    RPCBrokerV.param[0].ptype := list;
    cmd := 'PT DOCS STATUS';
    cmd := cmd + '^' + Patient.DFN + '^' + edtSearchTerms.Text;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then begin
      RPCResult := RPCBrokerV.Results[0];
    end else RPCResult := '';
    Result := piece(RPCBrokerV.Results[0],'^',2);
    if piece(RPCBrokerV.Results[0],'^',1) = '-1' then begin
      MessageDlg('Error: ' + Result,mtError,[mbOK],0);
    end;
  end;

  procedure TfrmPtDocSearch.ShowResults;
      var cmd  : string;
     RPCResult : String;
  begin
    //Result := ''; //default
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';
    RPCBrokerV.param[0].ptype := list;
    cmd := 'PT DOCS PREP FOR SUBSET';
    //cmd := cmd + '^' + Patient.DFN + '^' + edtSearchTerms.Text;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    CallBroker;
    cboFoundNotes.InitLongList(' ');
    cboFoundNotes.Enabled := True;
    btnOK.Enabled := false;
  end;

  procedure TfrmPtDocSearch.cboFoundNotesNeedData(Sender: TObject;
                                                 const StartFrom: String;
                                                 Direction, InsertAt: Integer);
  var
    cmd,RPCResult : string;
  begin
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';  // not used
    RPCBrokerV.param[0].ptype := list;
    cmd := 'PT DOCS SUBSET OF RESULTS';
    cmd := cmd + '^' + StartFrom + '^' + IntToStr(Direction);
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then begin
      RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
      if piece(RPCResult,'^',1)='-1' then begin
       // handle error...
      end else begin
        RPCBrokerV.Results.Delete(0);
      end;
    end;
    cboFoundNotes.ForDataUse(RPCBrokerV.Results);
  end;

  procedure TfrmPtDocSearch.FormHide(Sender: TObject);
  var cmd  : string;
  begin
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';
    RPCBrokerV.param[0].ptype := list;
    cmd := 'PT DOCS CLEAR';
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    CallBroker;
  end;

  procedure TfrmPtDocSearch.FormResize(Sender: TObject);
  var a:integer;
begin
  a := 1;
  cboFoundnotes.Anchors := [akLeft,akTop,akRight,akBottom];
end;

procedure TfrmPtDocSearch.btnDoneClick(Sender: TObject);
begin
  self.modalresult := -1;
end;

procedure TfrmPtDocSearch.btnOKClick(Sender: TObject);
begin
  self.modalresult := cboFoundNotes.GetIEN(cboFoundNotes.ItemIndex);
end;

procedure TfrmPtDocSearch.cboFoundNotesClick(Sender: TObject);
  begin
    SelectedNoteIEN := cboFoundNotes.GetIEN(cboFoundNotes.ItemIndex);
    btnOK.Enabled := cboFoundNotes.Items.Count>0;
    ShowDocument(SelectedNoteIEN,HtmlViewer,NoteText,PriorSearchStr);
    if FirstRun then begin
      ShowDocument(SelectedNoteIEN,HtmlViewer,NoteText,PriorSearchStr);
      FirstRun := false;
    end;
  end;

  procedure TfrmPtDocSearch.cboFoundNotesDblClick(Sender: TObject);
begin
     btnOKClick(Sender);
end;

procedure SrchToList(CONST SearchStr : String; Lines : TStringList);
  var p1,p2 : integer;
      subStr : string;
      WorkingS : string;
  begin
    if not Assigned(Lines) then exit;
    WorkingS := SearchStr;
    Lines.Clear;
    While Length(WorkingS) > 0 do begin
      WorkingS := Trim(WorkingS);
      if WorkingS[1] = '"' then begin
        p1 := 2;
        p2 := PosEx('"',WorkingS,p1);
      end else begin
        p1 := 1;
        p2 := Pos(' ',WorkingS);
      end;
      if p2>0 then begin
        subStr := MidStr(WorkingS,p1,(p2-1));
        if subStr[Length(subStr)]='"' then begin
          subStr := MidStr(subStr,1,Length(subStr)-1);
        end;
        WorkingS := MidStr(WorkingS,p2+1,Length(WorkingS));
      end else begin
        subStr := WorkingS;
        WorkingS := '';
      end;
      Lines.Add(subStr);
    end;
  end;

  procedure HighlightTerms(Lines : TStringList; SearchStr : string);
  var Terms : TStringList;
      UpperStr : string;
      UpperTerm : string;
      p, i : integer;
  const
    COLOR_START = '<B><FONT style="BACKGROUND-COLOR: #ffff00">';
    COLOR_END   = '</FONT></B>';
    LEN_START   = length(COLOR_START);
    LEN_END     = length(COLOR_END);

    function ColorizeTerm(UpperTerm : string; Str : string; var p1 : integer) : string;
    //will advance p past colorized term.
    var subA,subB,subC : string;
    begin
      subA := MidStr(Str,1,p1-1);
      subB := MidStr(Str,p1,Length(UpperTerm));
      subC := MidStr(Str,p1+Length(UpperTerm),Length(Str));
      Result := subA + COLOR_START + subB + COLOR_END + subC;
      p := p + LEN_START + LEN_END;
    end;

  begin
    UpperStr := UpperCase(Lines.Text);
    Terms := TStringList.Create;
    SrchToList(UpperCase(SearchStr),Terms);
    p := 1;
    for i := 0 to Terms.Count-1 do begin
      UpperTerm := Terms.Strings[i];
      repeat
        p := PosEx(UpperTerm,UpperStr,p);
        if p > 0 then begin
          Lines.Text := ColorizeTerm(UpperTerm,Lines.Text,p);  //will advance p past colorized term.
          UpperStr := UpperCase(Lines.Text);
        end;
      until p = 0;
    end;
   Terms.Free;
  end;

  procedure ShowDocument(noteIEN : Integer; HtmlViewer: THTMLObj; NoteText:TStringList; SearchStr:string);
  begin
    LoadDocumentText(NoteText,noteIEN);
    if not IsHTML(NoteText) Then Begin
      NoteText.Text := Text2HTML(NoteText);
    end else begin
      FixHTML(NoteText);
    end;
    fPtDocSearch.HighlightTerms(NoteText, SearchStr);

    HtmlViewer.HTMLText := NoteText.Text;
    HtmlViewer.Editable := false;
    HtmlViewer.BackgroundColor := clCream;
    HtmlViewer.TabStop := true;
    RedrawActivate(HtmlViewer.Handle);
  end;



end.

