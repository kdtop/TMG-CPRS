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
    tabRPCViewMode: TTabControl;  //kt 3/23
    lbRPCList: TListBox;
    tvRPC: TTreeView;
    pnlBanner: TPanel;
    edtSearch: TEdit;
    btnSearch: TBitBtn;
    btnClearSrch: TBitBtn;
    procedure btnClearSrchClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure tvRPCDblClick(Sender: TObject);       //kt 3/23
    procedure tvRPCCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean); //kt 3/23
    procedure tvRPCClick(Sender: TObject);  //kt 3/23
    procedure lbRPCListClick(Sender: TObject);    //kt 3/23
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
    FRetained: Integer;
    FCurrent: Integer;
    FCollapsing : boolean;
    procedure UpdateDisplay; //kt 9/11
    function ExcludeBySearchTerms(SL : TStringList) : boolean;  //kt
  public
    { Public declarations }
  end;

procedure ShowBroker;

implementation

{$R *.DFM}

uses
  fMemoEdit;  //kt 9/11 added

procedure ShowBroker;
var
  frmBroker: TfrmBroker;
begin
  frmBroker := TfrmBroker.Create(Application);
  try
    ResizeAnchoredFormToFont(frmBroker);
    with frmBroker do begin
      FRetained := RetainedRPCCount - 1;
      FCurrent := FRetained;
      UpdateDisplay; //kt
      { //kt 9/11 moved to UpdateDisplay
      LoadRPCData(memData.Lines, FCurrent);
      memData.SelStart := 0;
      lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
      }
      ShowModal;
    end;
  finally
    frmBroker.Release;
  end;
end;

procedure TfrmBroker.cmdPrevClick(Sender: TObject);
begin
  FCurrent := HigherOf(FCurrent - 1, 0);
  UpdateDisplay; //kt 9/11
  { //kt 9/11 moved to UpdateDisplay
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
  }
end;

procedure TfrmBroker.cmdNextClick(Sender: TObject);
begin
  FCurrent := LowerOf(FCurrent + 1, FRetained);
  UpdateDisplay; //kt 9/11
  { //kt 9/11 moved to UpdateDisplay
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
  }
end;

procedure TfrmBroker.UpdateDisplay; //kt 9/11 added
begin
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
end;

procedure TfrmBroker.cboJumpToDropDown(Sender: TObject);
//kt 9/11 added
var i : integer;
    s : string;
    Info : TStringList;   //Not owned here...
begin
  cboJumpTo.Items.Clear;
  for i := 0 to RetainedRPCCount - 1 do begin
    Info := AccessRPCData(i);
    if Info.Count < 2 then continue;
    s := Info.Strings[1];
    s := piece2(s,'Called at: ',2);
    s := s + ':  ' + Info.Strings[0];
    cboJumpTo.Items.Insert(0,s);
  end;
end;

procedure TfrmBroker.cboJumpToChange(Sender: TObject);
//kt 9/11 added
begin
  if cboJumpTo.Items.count > 0 then begin
    FCurrent := (cboJumpTo.Items.count-1) - cboJumpTo.ItemIndex;
    UpdateDisplay;
  end;
end;
procedure TfrmBroker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetRetainedRPCMax(StrToIntDef(txtMaxCalls.Text, 5))
end;

procedure TfrmBroker.FormResize(Sender: TObject);
begin
  Refresh;
end;

procedure TfrmBroker.lbRPCListClick(Sender: TObject);
//kt added
var i : integer;
begin
  inherited;
  i := lbRPCList.ItemIndex;
  if (i<0) or (i>= lbRPCList.Items.Count) then exit;
  FCurrent := integer(lbRPCList.Items.Objects[i]);
  UpdateDisplay;
end;

procedure TfrmBroker.tabRPCViewModeChange(Sender: TObject);
//kt added
type
  tViewModes = (rpcvTime=0, rpcvName=1, rpcvTree=2);
  tTimePos = (tFirst, tLast, tNone, tTagged);

var Mode : tViewModes;
    SL : TStringList;
    i : integer;
    RootNode : TTreeNode;

  procedure LoadRPCs(SL : TStrings; TimePos: tTimePos);
  var
    i : integer;
    TimeStr, s : string;
    Info : TStringList;   //Not owned here...
  begin
    for i := RetainedRPCCount - 1 downto 0 do begin
      Info := AccessRPCData(i);
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
      SL.AddObject(s,TObject(i));  //linked 'object' will really be index into RetainedRPCCount
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

  procedure AddToTV(TV : TTreeView; s : string; Data : pointer);
  var TimeStr : string;
      InsertNode: TTreeNode;
  begin
    TimeStr := piece(s, '^',2);
    s := piece(s,'^',1);
    InsertNode := TV.Items.GetFirstNode;
    if Pos(' ',s) > 0 then begin
      InsertNode := EnsureNode(TV, InsertNode, piece(s,' ', 1), pointer(-1));
    end;
    InsertNode := EnsureNode(TV, InsertNode, s, Data);
    InsertNode := EnsureNode(TV, InsertNode, ' call time: ' + TimeStr, Data);
  end;

begin //tabRPCViewModeChange
  inherited;
  Mode := tViewModes(tabRPCViewMode.TabIndex);
  case Mode of
    rpcvTime: begin
      lbRPCList.Align := alClient;
      lbRPCList.Visible := true;
      tvRPC.Visible := false;
      lbRPCList.Items.Clear;
      LoadRPCs(lbRPCList.Items, tFirst);  //load by sequence (time) order
    end;
    rpcvName: begin
      lbRPCList.Align := alClient;
      lbRPCList.Visible := true;
      tvRPC.Visible := false;
      lbRPCList.Items.Clear;
      SL := TStringList.Create;
      try
        LoadRPCs(SL, tLast);  //load by sequence (time) order
        SL.Sort;  //sort by name
        lbRPCList.Items.Assign(SL);
      finally
        SL.Free;
      end;
    end;
    rpcvTree: begin
      tvRPC.Align := alClient;
      lbRPCList.Visible := false;
      tvRPC.Visible := true;
      tvRPC.Items.BeginUpdate;
      tvRPC.Items.Clear;
      RootNode := tvRPC.Items.Add(nil,'RPC''s by Name');  //a root note
      //load tree by name
      SL := TStringList.Create;
      try
        LoadRPCs(SL, tTagged);  //load by sequence (time) order
        for i := 0 to SL.Count - 1 do begin
          AddToTV(tvRPC, SL.Strings[i], SL.Objects[i]);
        end;
        tvRPC.Items.AlphaSort(true);
      finally
        SL.Free;
      end;
      RootNode.Expand(false);
      tvRPC.Items.EndUpdate;
    end;
  end;
end;

procedure TfrmBroker.tvRPCClick(Sender: TObject);
//kt 3/23
var ANode : TTreeNode;
    value : integer;
begin
  inherited;
  if FCollapsing then exit;
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
  FCurrent := value;
  UpdateDisplay;
end;

procedure TfrmBroker.tvRPCCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
//kt 3/23
begin
  inherited;
  FCollapsing := true;
  tvRPC.Selected := Node;
  Application.ProcessMessages;
  FCollapsing := false;
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
infoBox('Lapsed time (milliseconds) = ' + diffDisplay + '.', disclaimer, MB_OK);
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
  tabRPCViewModeChange(Sender);
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
  FCurrent := 0;
  FRetained := RetainedRPCCount - 1;
  cmdNextClick(Sender);
  tabRPCViewModeChange(Sender);
end;

end.
