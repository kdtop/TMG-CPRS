unit fxBroker;

//kt 9/11 made changes to this unit

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DateUtils, ORNet, ORFn, rMisc, ComCtrls, Buttons, ExtCtrls,
  ORCtrls, ORSystem, fBase508Form, VA508AccessibilityManager;

type
  tViewModes = (rpcvTime=0, rpcvName=1, rpcvTree=2, rpcvOther);  //kt added

  TfrmBroker = class(TfrmBase508Form)
    pnlTop: TORAutoPanel;
    lblMaxCalls: TLabel;
    txtMaxCalls: TCaptionEdit;
    cmdPrev: TBitBtn;
    cmdNext: TBitBtn;
    udMax: TUpDown;
    memData: TRichEdit;
    lblCallID: TStaticText;
    btnRLT: TButton;
    cboJumpTo: TComboBox;      //kt 9/11
    btnClear: TBitBtn;         //kt 9/11
    lblStoredCallsNum: TLabel; //kt 9/11
    btnFilter: TBitBtn;        //kt
    pnlBottom: TPanel;         //kt 3/23
    PanelBottomLeft: TPanel;   //kt 3/23
    Splitter1: TSplitter;      //kt 3/23
    pnlbottomRight: TPanel;    //kt 3/23
    tabRPCViewMode: TTabControl;
    lbTimeRPCList: TListBox;
    tvRPC: TTreeView;
    pnlBanner: TPanel;
    edtSearch: TEdit;
    btnSearch: TBitBtn;
    btnClearSrch: TBitBtn;
    RefreshTimer: TTimer;
    lbNameRPCList: TListBox;
    procedure lbNameRPCListClick(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure btnClearSrchClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure tvRPCDblClick(Sender: TObject);       //kt 3/23
    procedure tvRPCCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean); //kt 3/23
    procedure tvRPCClick(Sender: TObject);  //kt 3/23
    procedure lbTimeRPCListClick(Sender: TObject);    //kt 3/23
    procedure tabRPCViewModeChange(Sender: TObject);        //kt 9/11
    procedure btnFilterClick(Sender: TObject); //kt 9/11
    procedure btnClearClick(Sender: TObject);  //kt 9/11
    procedure cmdPrevClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnRLTClick(Sender: TObject);
    procedure cboJumpToDropDown(Sender: TObject);
    procedure cboJumpToChange(Sender: TObject);
  private
    { Private declarations }
    FSearchTerms : TStringList;
    FSelectedTVNode : TTreeNode;
    FTVRootNode : TTreeNode;
    //kt FRetained: Integer;
    //kt  FCurrent: Integer;
    FCurrentID : integer;
    FCollapsing : boolean;
    procedure SetCurrentID(ID : integer); //kt 9/23
    procedure DisplayIDRPCData(ID : integer); //kt 9/11
    function ExcludeBySearchTerms(SL : TStringList) : boolean;  //kt
    procedure LoadRPCDataIntoControls();  //kt added
    procedure SyncSelectedID(ID : integer; CalledFrom : tViewModes);
    procedure lbNameRPCListSelectByID(ID : integer);  //kt added
    procedure lbTimeRPCListSelectByID(ID : integer);  //kt added
    procedure tvRPCSelectByID(ID : integer);          //kt added
    procedure DoTVSelectNode(Node : TTreeNode);       //kt added
  public
    { Public declarations }
  end;

procedure ShowBroker;

implementation

{$R *.DFM}

uses
  fMemoEdit;  //kt 9/11 added

var
  frmBroker: TfrmBroker;  //kt added here



procedure ShowBroker;
//kt var
//kt   frmBroker: TfrmBroker;
begin
  frmBroker := TfrmBroker.Create(Application);
  try
    ResizeAnchoredFormToFont(frmBroker);
    with frmBroker do begin
      //kt FRetained := RetainedRPCCount - 1;
      //kt FCurrent := FRetained;
      LoadRPCDataIntoControls();  //kt
      tabRPCViewModeChange(nil); //kt
      SetCurrentID(IDOfRPCIndex(RetainedRPCCount - 1)); //kt 9/23
      { //kt 9/11 moved to UpdateDisplay
      LoadRPCData(memData.Lines, FCurrent);
      memData.SelStart := 0;
      lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
      }
      //kt 9/9/23  ShowModal;
      Show;  //note: will be released in the OnClose event
    end;
  finally
    //kt 9/9/23 frmBroker.Release;
  end;
end;

procedure TfrmBroker.cmdPrevClick(Sender: TObject);
begin
  SetCurrentID(PrevRPCDataID(FCurrentID)); //kt 9/23
  //kt FCurrent := HigherOf(FCurrent - 1, 0);
  { //kt 9/11 moved to UpdateDisplay
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
  }
end;

procedure TfrmBroker.cmdNextClick(Sender: TObject);
begin
  SetCurrentID(NextRPCDataID(FCurrentID)); //kt 9/23
  //kt FCurrent := LowerOf(FCurrent + 1, FRetained);
  { //kt 9/11 moved to UpdateDisplay
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
  }
end;

procedure TfrmBroker.SetCurrentID(ID : integer); //kt 9/23
var CurrentIndex, LastIndex, Delta : integer;
begin
  FCurrentID := ID;
  SyncSelectedID(FCurrentID, rpcvOther);  //kt added
  DisplayIDRPCData(FCurrentID); //kt 9/11
  CurrentIndex := IndexOfRPCID(FCurrentID);
  LastIndex := RetainedRPCCount - 1;
  Delta := LastIndex - CurrentIndex;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(Delta);
  cmdNext.Enabled := (CurrentIndex <> LastIndex);
  cmdPrev.Enabled := (CurrentIndex <> 0);
end;

procedure TfrmBroker.DisplayIDRPCData(ID : integer); //kt 9/11 added
begin
  LoadRPCData(memData.Lines, ID);
  memData.SelStart := 0;
end;

procedure TfrmBroker.cboJumpToDropDown(Sender: TObject);
//kt 9/11 added
var i : integer;
    ID : integer;   //kt
    s : string;
    Info : TStringList;   //Not owned here...
begin
  cboJumpTo.Items.Clear;
  for i := 0 to RetainedRPCCount - 1 do begin
    //kt Info := AccessRPCData(i);
    Info := AccessRPCDataByIndex(i, ID);  //kt 9/9/23  ID is an OUT parameter
    if Info.Count < 2 then continue;
    s := Info.Strings[1];
    s := piece2(s,'Called at: ',2);
    s := s + ':  ' + Info.Strings[0];
    //kt 9/9/23 -- cboJumpTo.Items.Insert(0,s);
    cboJumpTo.Items.InsertObject(0, s, TObject(ID)); //kt 9/9/23
  end;
end;

procedure TfrmBroker.cboJumpToChange(Sender: TObject);
//kt 9/11 added
var ID : integer;
begin
  if cboJumpTo.Items.count > 0 then begin
    ID := integer(cboJumpTo.Items.Objects[cboJumpTo.ItemIndex]);  //kt 9/9/23
    SetCurrentID(ID); //kt 9/23
  end;
end;

procedure TfrmBroker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetRetainedRPCMax(StrToIntDef(txtMaxCalls.Text, 5));
  frmBroker := nil; //kt 9/9/23 NOTE: This is just modifying the pointer.  The object still exists in memory
  Self.Release;     //kt 9/9/23 NOTE: This posts message to object, which will then free itself.
end;

procedure TfrmBroker.FormResize(Sender: TObject);
begin
  Refresh;
end;

procedure TfrmBroker.lbNameRPCListClick(Sender: TObject);
//kt added
var i : integer;
begin
  inherited;
  if not lbNameRPCList.Visible then exit;
  i := lbNameRPCList.ItemIndex;
  if (i<0) or (i>= lbNameRPCList.Items.Count) then exit;
  SetCurrentID(integer(lbNameRPCList.Items.Objects[i])); //kt 9/23
end;

procedure TfrmBroker.lbTimeRPCListClick(Sender: TObject);
//kt added
var i : integer;
begin
  inherited;
  if not lbTimeRPCList.Visible then exit;
  i := lbTimeRPCList.ItemIndex;
  if (i<0) or (i>= lbTimeRPCList.Items.Count) then exit;
  SetCurrentID(integer(lbTimeRPCList.Items.Objects[i])); //kt 9/23
end;

procedure TfrmBroker.tvRPCClick(Sender: TObject);
//kt 3/23
var ANode : TTreeNode;
    value : integer;
begin
  inherited;
  if FCollapsing then exit;
  if not tvRPC.Visible then exit;
  ANode := tvRPC.Selected;
  if not Assigned(ANode) then begin
    memData.Lines.Clear;
    exit;
  end;
  value := integer(ANode.Data);
  if value < 0 then begin
    memData.Lines.Clear;
    exit;
  end;
  SetCurrentID(value); //kt 9/23
end;

procedure TfrmBroker.RefreshTimerTimer(Sender: TObject);   //kt added
begin
  inherited;
  if not RPCDataChanged then exit;
  LoadRPCDataIntoControls();
  SyncSelectedID(FCurrentID, rpcvOther);
  DisplayIDRPCData(FCurrentID);
end;


procedure TfrmBroker.SyncSelectedID(ID : integer; CalledFrom : tViewModes);   //kt added
//  tViewModes = (rpcvTime=0, rpcvName=1, rpcvTree=2);  //kt added
begin
  if CalledFrom <> rpcvTime then lbTimeRPCListSelectByID(ID);
  if CalledFrom <> rpcvName then lbNameRPCListSelectByID(ID);
  if CalledFrom <> rpcvTree then tvRPCSelectByID(ID);
end;

procedure TfrmBroker.lbNameRPCListSelectByID(ID : integer); //kt added
var i : integer;
    OneID : integer;
begin
  for i := 0 to lbNameRPCList.Items.Count-1 do begin
    oneID := Integer(lbNameRPCList.Items.Objects[i]);
    if oneID <> ID then continue;
    lbNameRPCList.ItemIndex := i;
    break;
  end;
end;

procedure TfrmBroker.lbTimeRPCListSelectByID(ID : integer); //kt added
var i : integer;
    OneID : integer;
begin
  for i := 0 to lbTimeRPCList.Items.Count-1 do begin
    oneID := Integer(lbTimeRPCList.Items.Objects[i]);
    if oneID <> ID then continue;
    lbTimeRPCList.ItemIndex := i;
    break;
  end;
end;

procedure TfrmBroker.DoTVSelectNode(Node : TTreeNode); //kt added
var ANode : TTreeNode;
begin
  tvRPC.FullCollapse;
  //FTVRootNode.Collapse(false); //collapse all
  ANode := Node;
  while (ANode <> nil) do begin
    ANode.Expand(false);
    ANode := ANode.Parent;
  end;
  tvRPC.Select(Node);
  FSelectedTVNode := Node;
end;

procedure TfrmBroker.tvRPCSelectByID(ID : integer); //kt added
var i : integer;
    ANode : TTreeNode;
    OneID : integer;
begin
  for i := 0 to tvRPC.Items.Count-1 do begin
    ANode := tvRPC.Items[i];
    oneID := Integer(ANode.Data);
    if oneID <> ID then continue;
    DoTVSelectNode(ANode);
    break;
  end;
end;


procedure TfrmBroker.LoadRPCDataIntoControls();
//kt added
type
  tTimePos = (tFirst, tLast, tNone, tTagged);

var SL : TStringList;
    i, index : integer;
    ANode, CurrentNode : TTreeNode;

  function LoadRPCs(SL : TStrings; TimePos: tTimePos; CurrentID : integer) : integer;
  var
    i : integer;
    index : integer;
    ID : integer;   //kt
    TimeStr, s : string;
    Info : TStringList;   //Not owned here...
  begin
    result := -1;
    for i := RetainedRPCCount - 1 downto 0 do begin
      Info := AccessRPCDataByIndex(i, ID);  //kt 9/9/23  ID is an OUT parameter
      if ExcludeBySearchTerms(Info) then continue;
      if Info.Count < 2 then continue;
      s := Info.Strings[1];
      TimeStr := piece2(s,'Called at: ',2);
      s := Info.Strings[0];
      case TimePos of
        tFirst:    s := TimeStr + ': ' + s;
        tLast:     s := s + ' - ' + TimeStr;
        tTagged :  s := s + '^' + TimeStr;
        tNone:     s := s;
      end;
      index := SL.AddObject(s,TObject(ID));  //linked 'object' will really be ID of RPC data
      if CurrentID = ID then result := index;
    end;
  end;

  function GetNamedChild(Parent : TTreeNode; Name : string) : TTreeNode;
  var AChild : TTreeNode;
  begin
    Result := nil;
    if not Assigned(Parent) then exit;
    AChild := Parent.getFirstChild;
    while Assigned(AChild) and (Result = nil) do begin
      if AChild.Text = Name then begin
        Result := AChild;
        break;
      end;
      AChild := AChild.getNextSibling;
    end;
  end;

  function EnsureNode(TV : TTreeView; Parent : TTreeNode; Name : string; Data : pointer)  : TTreeNode;
  begin
    Result := GetNamedChild(Parent, Name);
    if not Assigned(Result) then begin
      Result := tvRPC.Items.AddChild(Parent, Name);
    end;
    Result.Data := Data;
  end;

  function AddToTV(TV : TTreeView; s : string; Data : pointer) : TTreeNode;
  var TimeStr : string;
      InsertNode: TTreeNode;
  begin
    TimeStr := piece(s, '^',2);
    s := piece(s,'^',1);
    InsertNode := TV.Items.GetFirstNode;
    if Pos(' ',s) > 0 then begin
      InsertNode := EnsureNode(TV, InsertNode, piece(s,' ', 1), pointer(-1));
    end;
    InsertNode := EnsureNode(TV, InsertNode, s, nil);  //data
    InsertNode := EnsureNode(TV, InsertNode, ' call time: ' + TimeStr, Data);
    result := InsertNode;
  end;

begin //LoadRPCDataIntoControls
  inherited;
  SL := TStringList.Create;
  try
    //Load Time listbox
    index := LoadRPCs(SL, tFirst, FCurrentID);  //load with name set for time sequence order
    lbTimeRPCList.Items.Assign(SL);
    lbTimeRPCList.ItemIndex := index;
    SL.Clear;

    //Load Name listbox
    index := LoadRPCs(SL, tLast, FCurrentID);  //load by name set for RPC Name order
    SL.Sort;  //sort by name
    lbNameRPCList.Items.Assign(SL);
    lbNameRPCList.ItemIndex := index;
    SL.Clear;

    //Load treeview
    tvRPC.Items.BeginUpdate;
    tvRPC.Items.Clear;
    CurrentNode := nil;
    FTVRootNode := tvRPC.Items.Add(nil,'RPC''s by Name');  //a root note
    index := LoadRPCs(SL, tTagged, FCurrentID);  //load with formatted name
    for i := 0 to SL.Count - 1 do begin
      ANode := AddToTV(tvRPC, SL.Strings[i], SL.Objects[i]);
      if i = index then begin
        CurrentNode := ANode;
      end;
    end;
    tvRPC.Items.AlphaSort(true);
    //DoTVSelectNode(CurrentNode);
    tvRPC.Items.EndUpdate;

    //Mark as reviewed (loaded)
    SetRPCDataAsReviewed;
  finally
    SL.Free;
  end;
  lblStoredCallsNum.Caption := 'Stored Calls: ' + IntToStr(RetainedRPCCount);
end;

procedure TfrmBroker.tabRPCViewModeChange(Sender: TObject);
//kt added
var Mode : tViewModes;

begin //tabRPCViewModeChange
  inherited;
  Mode := tViewModes(tabRPCViewMode.TabIndex);
  case Mode of
    rpcvTime: begin
      lbTimeRPCList.Align := alClient;
      lbTimeRPCList.Visible := true;
      tvRPC.Visible := false;
      lbNameRPCList.Visible := false;
    end;
    rpcvName: begin
      lbNameRPCList.Align := alClient;
      lbNameRPCList.Visible := true;
      tvRPC.Visible := false;
      lbTimeRPCList.Visible := false;
    end;
    rpcvTree: begin
      tvRPC.Align := alClient;
      tvRPC.Visible := true;
      lbNameRPCList.Visible := false;
      lbTimeRPCList.Visible := false;
      DoTVSelectNode(FSelectedTVNode);
    end;
  end;
end;

procedure TfrmBroker.tvRPCCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
//kt 3/23
begin
  inherited;
  {
  FCollapsing := true;
  tvRPC.Selected := Node;
  Application.ProcessMessages;
  FCollapsing := false;
  }
end;

procedure TfrmBroker.tvRPCDblClick(Sender: TObject);
begin
  inherited;
  tvRPCClick(Sender);
  if not Assigned(tvRPC.Selected) then exit;
  tvRPC.Selected.Expand(false);
end;

procedure TfrmBroker.FormCreate(Sender: TObject);
begin
  FCollapsing := false;     //kt 3/23
  udMax.Max := GetRPCMax;   //kt 3/23
  FSelectedTVNode := nil;   //kt 9/23
  udMax.Position := GetRPCMax;
  txtMaxCalls.Text := IntToStr(GetRPCMax);
  FSearchTerms := TStringList.Create; //kt
  tabRPCViewModeChange(Sender); //kt 3/23
end;

procedure TfrmBroker.FormDestroy(Sender: TObject);
//kt added
begin
  FSearchTerms.Free; //kt
  inherited;
end;

procedure TfrmBroker.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfrmBroker.btnFilterClick(Sender: TObject);
//kt 9/11 added entire unit
//kt note: 3/23/24 -- this filter is different from search filter
var
  frmMemoEdit: TfrmMemoEdit;

begin
  inherited;
  frmMemoEdit := TfrmMemoEdit.Create(Self);
  frmMemoEdit.lblMessage.Caption := 'Add/Del/Edit list of FILTERED RPC calls (No ''*'' matching):';
  frmMemoEdit.memEdit.Lines.Assign(ORNet.FilteredRPCCalls);
  frmMemoEdit.ShowModal;
  ORNet.FilteredRPCCalls.Assign(frmMemoEdit.memEdit.Lines);
  frmMemoEdit.Free;
end;

procedure TfrmBroker.btnRLTClick(Sender: TObject);
var
  startTime, endTime: tDateTime;
  clientVer, serverVer, diffDisplay: string;
  theDiff: integer;
const
  TX_OPTION  = 'OR CPRS GUI CHART';
  disclaimer = 'NOTE: Strictly relative indicator:';
begin
  clientVer := clientVersion(Application.ExeName); // Obtain before starting.

  // Check time lapse between a standard RPC call:
  startTime := now;
  serverVer :=  serverVersion(TX_OPTION, clientVer);
  endTime := now;
  theDiff := milliSecondsBetween(endTime, startTime);
  diffDisplay := intToStr(theDiff);

  // Show the results:
  infoBox('Lapsed time (milliseconds) for sample RPC = ' + diffDisplay + '.', disclaimer, MB_OK);
end;

procedure TfrmBroker.btnClearSrchClick(Sender: TObject);
begin
  inherited;
  edtSearch.Text := '';
  btnSearchClick(Sender);
end;

procedure TfrmBroker.btnSearchClick(Sender: TObject);  //kt added
var SearchText : string;
begin
  inherited;
  SearchText := UpperCase(edtSearch.Text);
  PiecesToList(SearchText, ' ', FSearchTerms);
  LoadRPCDataIntoControls();  //this will filter based in FSearchTerms
  DisplayIDRPCData(FCurrentID);
end;

function TfrmBroker.ExcludeBySearchTerms(SL : TStringList) : boolean;
var i : integer;
    ATerm : string;

  function ContainsTerm(SL : TStringList; ATerm : string) : boolean;
  //Does SL contain ATerm on ANY of its lines?
  var i : integer;
  begin
    Result := false;
    for i := 0 to SL.Count - 1 do begin
      if Pos(ATerm, SL[i]) = 0  then continue;  //not found on this 1 line
      Result := true;
      break;
    end;
  end;

begin
  Result := false;
  for i := 0 to FSearchTerms.Count - 1 do begin
    ATerm := FSearchTerms[i];
    if ContainsTerm(SL, ATerm) then continue;
    Result := true;
    break;
  end;
end;


procedure TfrmBroker.btnClearClick(Sender: TObject);
//kt 9/11 added
begin
  ORNet.RPCCallsClear;
  memData.Lines.Clear; //kt 4/15/10
  cboJumpTo.Text := '-- Select a call to jump to --';
  LoadRPCDataIntoControls();
  //kt FCurrent := 0;
  FCurrentID := 0;  //kt
  //kt FRetained := RetainedRPCCount - 1;
  cmdNextClick(Sender);
  tabRPCViewModeChange(Sender);
end;

end.
