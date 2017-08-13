unit fSearchResults;
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
  Dialogs, ORCtrls, StdCtrls, ORNet, ORFn, ComCtrls, Trpcb, Buttons,
  ExtCtrls, OleCtrls, SHDocVw, TMGHTML2, SortStringGrid, Grids;

type
  TDisplayMode = (tdmMemo, tdmGrid, tdmHTML);

  TfrmSrchResults = class(TForm)
    lblCaption: TLabel;
    pnlLeft: TPanel;
    cboResultList: TORComboBox;
    pnlDetails: TPanel;
    btnCancel: TBitBtn;
    Splitter1: TSplitter;
    pnlMiddle: TPanel;
    Label1: TLabel;
    lstFoundRecs: TListBox;
    Memo: TMemo;
    pnlBottom: TPanel;
    btnSelectRecord: TBitBtn;
    pnlTop: TPanel;
    Splitter2: TSplitter;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstFoundRecsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboResultListNeedData(Sender: TObject;
      const StartFrom: String; Direction, InsertAt: Integer);
    procedure cboResultListChange(Sender: TObject);
    procedure btnSelectRecordClick(Sender: TObject);
  private
    { Private declarations }
    HtmlViewer : THTMLObj;
    GridRecDetail      : TSortStringGrid;
    //GridRecDetail : TStringGrid;
    FJobNum : string;
    FTargetFName : string;
    //FTargetFNumber : string;
    FLastDFN : string;
    FDisplayMode : TDisplayMode;
    FSearchTerms : string;
    FFoundRecsInfo : TStringList; //will have 1:1 relationship to order of lstFoundRecs.items
    procedure SetDisplayMode(Mode : TDisplayMode);
    procedure SetDisplayModeForFile(FileNumber : string);
    function SubSetOfResults(JobNum: string; const StartFrom: string; Direction: Integer): TStrings;
    procedure ShowDemog(OneDFN: string);
    procedure InitORComboBox(ORComboBox: TORComboBox; initValue : string; boxtype : string);
    function GetIENDetails(IEN:string) : TStrings;
  public
    { Public declarations }
    SelectedIEN : string;   //used only as OUT parameters
    SelectedName : string; //used only as OUT parameters
    NoteText : TStringList;
    function PrepForm(JobNum, TargetFName, NumMatches, Fields, SearchStr: string) : Boolean;
    procedure AssignRecordToStringGrid(Grid: TSortStringGrid;FileNum,IENS:string);
  end;

var
  //frmSrchResults: TfrmSrchResults;
  TMGSearchResultsLastSelectedTIUIEN : String;

implementation

{$R *.dfm}

  uses rcore,fPtDocSearch,fPtDemoEdit,uCarePlan;


  procedure TfrmSrchResults.FormCreate(Sender: TObject);
  begin
    NoteText := TStringList.Create;
    FFoundRecsInfo := TStringList.Create;
    HtmlViewer := THtmlObj.Create(pnlDetails, Application);
    TWinControl(HtmlViewer).Parent := pnlDetails;
    TWinControl(HTMLViewer).Align := alClient;
    GridRecDetail := TSortStringGrid.Create(Self);
    //GridRecDetail := TStringGrid.create(self);
    GridRecDetail.Parent := pnlDetails;
    GridRecDetail.Anchors := [akLeft,akTop,akRight,akBottom];
    GridRecDetail.Left := 0;
    GridRecDetail.Top := 0;
    GridRecDetail.Width := pnlDetails.Width;
    GridRecDetail.Height := cboResultList.Height;
    GridRecDetail.Options := [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing];
    GridRecDetail.ColCount := 3;
    GridRecDetail.Cells[0,0] := 'Field No.';
    GridRecDetail.Cells[1,0] := 'Field Name';
    GridRecDetail.Cells[2,0] := 'Value';
    TMGSearchResultsLastSelectedTIUIEN := '';
  end;


  procedure TfrmSrchResults.FormDestroy(Sender: TObject);
  begin
    HTMLViewer.Free;
    GridRecDetail.Free;
    NoteText.free;
    FFoundRecsInfo.Free;
  end;


  procedure TfrmSrchResults.FormShow(Sender: TObject);
  begin
    HTMLViewer.Loaded;
  end;

  function ExtractStrings(SearchTerms : string) : string;
  var InQt : boolean;
      i : integer;
      lastCh, ch : char;
  begin
    Result := '';
    lastCh := 'x';
    InQt := false;
    for i := 1 to length(SearchTerms) do begin
      ch := SearchTerms[i];
      if ch = '"' then begin
        InQt := not InQt;
        if lastCh = '"' then Result := Result + ch
        else if not InQt then Result := Result + ' ';
      end else begin
        if InQt then Result := Result + ch;
      end;
      lastCh := ch;
    end;
  end;


  function TfrmSrchResults.PrepForm(JobNum, TargetFName, NumMatches, Fields, SearchStr: string) : Boolean;
  //Returns TRUE if OK, and FALSE if error
  var
    cmd,RPCResult : string;
    tempIEN : integer;
  begin
    FJobNum := JobNum;
    FTargetFName := TargetFName;
    FSearchTerms := ExtractStrings(SearchStr);
    //FTargetFNumber := piece(SearchStr,':',1);  //<-- CHECK this!!  Does this work with multiple terms??

    lblCaption.Caption := 'Select Desired Record from File '+ TargetFName + '   '
                          + NumMatches + ' found.';

    Result := TRUE; //default
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';  // not used
    RPCBrokerV.param[0].ptype := list;
    cmd := 'PREP SUBSET';
    cmd := cmd + '^' + JobNum + '^' + Fields;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then begin
      RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
      if piece(RPCResult,'^',1)='-1' then begin
        MessageDlg(piece(RPCResult,'^',2),mtInformation,[mbOK],0);
        Result := false;
      end;
    end;
    if Result=false then exit;
    InitORComboBox(cboResultList,'A','record');
    //Autoselect first entry
    if cboResultList.Items.Count > 0 then begin
      tempIEN := StrToIntDef(piece(cboResultList.Items.Strings[0],'^',1),0);
      cboResultList.SelectByIEN(tempIEN);
      cboResultListChange(cboResultList);  //trigger change event
    end;
  end;


  procedure TfrmSrchResults.InitORComboBox(ORComboBox: TORComboBox; initValue : string; boxtype : string);
  begin
    ORComboBox.Items.Clear;
    ORComboBox.Text := '';  //initValue;
    ORComboBox.InitLongList(initValue);
    if ORComboBox.Items.Count > 0 then begin
      ORComboBox.Text := Piece(ORComboBox.Items[0],'^',2);
    end else begin
      ORComboBox.Text := '<Begin by selecting ' + boxtype + '>';
    end;
  end;


procedure TfrmSrchResults.lstFoundRecsClick(Sender: TObject);
var IEN: string;
    index : integer;
    FileNumber, info : string;
begin
  index := lstFoundRecs.ItemIndex;
  info := FFoundRecsInfo.Strings[index]; //will have 1:1 relationship to order of lstFoundRecs.items
  FileNumber := piece(info, '^',1);
  IEN := piece(info, '^',2);
  SetDisplayModeForFile(FileNumber);
  TMGSearchResultsLastSelectedTIUIEN := '';
  If FileNumber = '2' then begin
    ShowDemog(IEN);
  end else if FileNumber = '8925' then begin
    fPtDocSearch.ShowDocument(StrToInt(IEN), HtmlViewer, NoteText, FSearchTerms);
    TMGSearchResultsLastSelectedTIUIEN := IEN;
  end else begin
    AssignRecordToStringGrid(GridRecDetail,FileNumber,IEN+',');
  end;
end;

function TfrmSrchResults.SubSetOfResults(JobNum: string;
                                         const StartFrom: string;
                                         Direction: Integer       ): TStrings;

  { returns a pointer to a list of file entries (for use in a long list box) -
    The return value is a pointer to RPCBrokerV.Results, so the data must
    be used BEFORE the next broker call! }
  var
    cmd,RPCResult : string;
  begin
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';  // not used
    RPCBrokerV.param[0].ptype := list;
    cmd := 'RESULTS LIST SUBSET';
    cmd := cmd + '^' + JobNum + '^' + StartFrom + '^' + IntToStr(Direction);
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    //RPCBrokerV.Call;
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then begin
      RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
      if piece(RPCResult,'^',1)='-1' then begin
       // handle error...
      end else begin
        RPCBrokerV.Results.Delete(0);
        if RPCBrokerV.Results.Count=0 then begin
          //RPCBrokerV.Results.Add('0^<NO DATA>');
        end;
      end;
    end;
    Result := RPCBrokerV.Results;
  end;


  procedure TfrmSrchResults.cboResultListNeedData(Sender: TObject;
                        const StartFrom: String; Direction, InsertAt: Integer);
  var  Result : TStrings;
       ORComboBox : TORComboBox;
  begin
    ORComboBox := TORComboBox(Sender);
    Result := SubSetOfResults(FJobNum, StartFrom, Direction);
    ORComboBox.ForDataUse(Result);
  end;


  function TfrmSrchResults.GetIENDetails(IEN : string) : TStrings;
  var  cmd  : string;
  begin
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.param[0].ptype := list;
    RPCBrokerV.Param[0].Value := '.X';
    cmd := 'IEN DETAILS';
    cmd := cmd + '^' + FJobNum + '^' + IEN;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    CallBroker;
    Result := RPCBrokerV.Results;
  end;


  procedure TfrmSrchResults.cboResultListChange(Sender: TObject);
  var SelEntry : string;
      DetailSet : TStringList;
      FileNumber : String;
      IEN : String;
      ItemStr, DispStr : string;
      i : integer;
  begin
    lstFoundRecs.clear;   FFoundRecsInfo.Clear;
    if cboResultList.ItemIndex >=0 then begin
      SelEntry := cboResultList.Items[cboResultList.ItemIndex];
      SelectedIEN := piece(SelEntry,'^',1);
      SelectedName := piece(SelEntry,'^',2);
    end else begin
      SelectedIEN := '';
      SelectedName := ''
    end;
    DetailSet := TStringList.Create;
    try
      DetailSet.Assign(GetIENDetails(SelectedIEN));
      //showmessage('Details are: '+DetailSet.Text);
      if Piece(DetailSet[0],'^',1)<>'1' then exit;
      for i := 1 to DetailSet.Count - 1 do begin
        ItemStr := DetailSet[i];
        FileNumber := Piece(ItemStr,'^',1);
        IEN := piece(ItemStr,'^',2);
        if FileNumber = '2' then begin
          DispStr := piece(ItemStr,'^',3) + ' (' + piece(ItemStr,'^',4) + ')';
        end else if FileNumber = '8925' then begin
          DispStr := piece(ItemStr,'^',3) + ' -- ' + piece(ItemStr,'^',4);
        end else begin
          DispStr := piece(ItemStr,'^',3);
        end;
        //lstFoundRecs.additem(DispStr);
        lstFoundRecs.Items.add(DispStr);
        FFoundRecsInfo.Add(FileNumber + '^' + IEN);  //will have 1:1 relationship to order of lstFoundRecs.items
      end;
    finally
      DetailSet.Free;
    end;
    if lstFoundRecs.Items.Count > 0 then begin
      lstFoundRecs.ItemIndex := 0;
      LstFoundRecsClick(lstFoundRecs);
    end;
  end;

  procedure TfrmSrchResults.btnCancelClick(Sender: TObject);
begin
  TMGSearchResultsLastSelectedTIUIEN := '';
end;

procedure TfrmSrchResults.btnSelectRecordClick(Sender: TObject);
  begin
   //Check that something is selected, etc.
    if SelectedName = '' then begin
      MessageDlg('Please Select a Record First.',mtInformation,[mbOK],0);
    end else begin
      ModalResult := mrOK;
      //Self.Close;
    end;
  end;


  procedure TfrmSrchResults.ShowDemog(OneDFN: string);
  var   PtRec: TPtIDInfo;
  begin
    if OneDFN = '' then begin
      Memo.Lines.Clear;
      FLastDFN := '';
      Exit;
    end;
    if OneDFN = FLastDFN then Exit;
    Memo.Lines.Clear;
    FLastDFN := OneDFN;
    PtRec := rCore.GetPtIDInfo(OneDFN);
    with PtRec do begin
      Memo.Lines.Add(Name);
      Memo.Lines.Add('SSN: ' + SSN + '.');
      Memo.Lines.Add('DOB:' + DOB + '.');
      if Sex <> '' then Memo.Lines.Add(Sex + '.');
      if Location <> '' then
        Memo.Lines.Add('Location: ' + Location + '.');
      if RoomBed <> '' then
        Memo.Lines.Add('Room: ' + RoomBed + '.');
      if HRN <> '' then Memo.Lines.Add('HRN: ' + HRN + '.');
    end;
  end;

  procedure TfrmSrchResults.SetDisplayModeForFile(FileNumber : string);
  begin
    If FileNumber = '2' then begin
      SetDisplayMode(tdmMemo);
    end else If FileNumber = '8925' then begin
      SetDisplayMode(tdmHTML);
    end else begin
      SetDisplayMode(tdmGrid);
    end;
  end;

  procedure TfrmSrchResults.SetDisplayMode(Mode : TDisplayMode);
  begin
    FDisplayMode := Mode;
    case Mode of
      tdmMemo: begin
                 Memo.Lines.Clear;
                 Memo.BringToFront;
               end;
      tdmGrid: begin
                 //Do something to clear prior grid entries
                 GridRecDetail.BringToFront;
               end;
      tdmHTML: begin
                 HTMLViewer.Text :=' ';
                 HTMLViewer.BringToFront;
               end;
    end;
  end;

procedure TfrmSrchResults.AssignRecordToStringGrid(Grid: TSortStringGrid;FileNum,IENS:string);
var RPCResult: string;
  cmd : string;
  i : integer;
begin
  if (IENS='') then exit;
  RPCBrokerV.remoteprocedure := 'TMG CHANNEL';
  RPCBrokerV.Param[0].Value := '.X';  // not used
  RPCBrokerV.param[0].ptype := list;
  cmd := 'GET ONE RECORD^' + FileNum + '^' + IENS;
  RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
  //RPCBrokerV.Call;
  CallBroker;
  RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
  if piece(RPCResult,'^',1)='-1' then begin
    ShowMessage('Error returning results: '+Piece(RPCResult,'^',2));
  end else begin
    showmessage(RPCBrokerV.Results.Text);
    // Store the row data
    for i := 1 to Grid.RowCount - 1 do
       Grid.Rows[i].Clear;
    Grid.RowCount := RPCBrokerV.Results.Count;
    With Grid do Begin
      for i:=1 to RPCBrokerV.Results.Count-1 do begin
        //Rows[i].Delimiter := '^';
        //Rows[i].DelimitedText:=RPCBrokerV.Results[i];
        Cells[0,i] := piece(RPCBrokerV.Results[i],'^',3);
        Cells[1,i] := piece(RPCBrokerV.Results[i],'^',5);
        Cells[2,i] := piece(RPCBrokerV.Results[i],'^',4);
      end;
    end;
  end;
  SetDisplayMode(tdmGrid);
end;

end.

