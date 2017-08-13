unit SubfilesU;
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


//kt 9/11 Added

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StrUtils, fPtDemoEdit,
  Dialogs, StdCtrls, ExtCtrls, Grids, ComCtrls, Buttons, SortStringGrid, uTMGTypes;

type
  TSubfileForm = class(TForm)
    Panel1: TPanel;
    TreeView: TTreeView;
    //kt SubFileGrid: TSortStringGrid;
    Splitter1: TSplitter;
    SubFileLabel: TLabel;
    RightPanel: TPanel;
    ButtonPanel: TPanel;
    ApplyBtn: TBitBtn;
    RevertBtn: TBitBtn;
    DoneBtn: TBitBtn;
    LeftPanel: TPanel;
    Panel5: TPanel;
    AddBtn: TBitBtn;
    DeleteBtn: TBitBtn;
    pnlSortGridHolder: TPanel;
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SubFileGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure AddBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RevertBtnClick(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure SubFileGridClick(Sender: TObject);
    procedure DoneBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
  private
    { Private declarations }
    SubFileGrid: TSortStringGrid;  //kt 9/11
    Root  : TTreeNode;
    FSubFileNum : string;
    FParentIENS : string;
    IENS_Store : TStringList;
    BlankFileInfo : TStringList;
    //FLastSelectedRow : integer;
    FLastSelectedNode : TTreeNode;
    AllSubRecords : TStringList;
    LastAddNum : integer;
    IgnoreSelections : boolean;
    CurrentSubFileData : TStringList;
    GridInfo : TGridInfo;
    ModifiedForm : boolean;  //Used to see if current record is unsaved
    procedure CompileChanges(Grid : TSortStringGrid; CurrentUser,Changes : TStringList);
    procedure PostChanges(Grid : TSortStringGrid; IENS : string; SilentMode : boolean = false);
    procedure GetAllSubRecords(SubFileNum, ParentIENS : string; SubRecsList : TStringList);
    procedure InitTreeView;
    Procedure LoadTreeView(AllSubRecords : TStringList);
    Procedure ClearTreeView;
//    procedure ClearGrid;
    function GetIENS(Node: TTreeNode) : string;
    function StoreIENS(IENS: string) : integer;
  public
    { Public declarations }
    procedure PrepForm(subFileNum : string; ParentIENS : string);
  end;

const
  MSG_SUB_FILE = 'SubFile';

implementation

uses
  ORNet, ORFn, ORCtrls,
  Trpcb,  //needed for .ptype types
  uTMGGrid,
  ToolWin, SelDateTimeU,  SetSelU, LookupU, PostU, FMErrorU;

{$R *.dfm}

  procedure TSubfileForm.PrepForm(subFileNum : string; ParentIENS : string);
  //Format is: FileNum^IENS^FieldNum^ExternalValue^DDInfo...
  begin
    GridInfo.Grid := SubFileGrid;
    GridInfo.Data := CurrentSubFileData;
    GridInfo.BasicMode := false;
    GridInfo.FileNum := subFileNum;
    GridInfo.IENS := ParentIENS;
    GridInfo.ApplyBtn := ApplyBtn;
    GridInfo.RevertBtn := RevertBtn;
    //fPtDemoEdit.RegisterGridInfo(GridInfo);

    BlankFileInfo.Clear;
    IENS_Store.Clear;
    FSubFileNum := subFileNum;
    FParentIENS := ParentIENS;
    self.caption := 'Edit Sub-File Entries in Subfile #' + subFileNum;
    ClearTreeView;
    InitTreeView;
  end;

  procedure TSubfileForm.InitTreeView;
  begin
    IgnoreSelections := true;
    GetAllSubRecords(FSubFileNum,FParentIENS, AllSubRecords);
    //fPtDemoEdit.ClearGrid(SubFileGrid);
    LoadTreeView(AllSubRecords);
    Root.Expand(true);
    IgnoreSelections := false;
  end;
  
  Procedure TSubfileForm.LoadTreeView(AllSubRecords : TStringList);
  //Format is: FullIENS^.01Value

  var i : integer;
      dataLine : integer;
      oneEntry,value,Name,IENS : string;
  begin
    ClearTreeView;
    for i := 1 to AllSubRecords.Count-1 do begin    //0 is 1^Success
      oneEntry := AllSubRecords.Strings[i];
      IENS := Piece(oneEntry,'^',1);
      value := Piece(oneEntry,'^',2);
      dataLine := StoreIENS(IENS);
      Name := value;
      //Name := value + '^'+ IENS;
      //TreeView.Items.AddChild(Root,Name);
      TreeView.Items.AddChildObject(Root,Name,Pointer(dataLine));
    end;
  End;

  Procedure TSubfileForm.ClearTreeView;
  begin  
    TreeView.Items.Clear;
    IENS_Store.Clear;
    Root := TreeView.Items.Add(nil,'Subrecords');
    //if Root.HasChildren then Root.DeleteChildren;
//    ClearGrid;
    //fPtDemoEdit.ClearGrid(SubFileGrid);
    
  end;
  

  procedure TSubfileForm.TreeViewChanging(Sender: TObject; Node: TTreeNode;
    var AllowChange: Boolean);
  begin
    ApplyBtnClick(self);
  end;

  procedure TSubfileForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
  begin
    FLastSelectedNode := Node;
    GridInfo.IENS := GetIENS(Node);
    //frmPtDemoEdit.GetOneRecord(GridInfo.FileNum, GridInfo.IENS, GridInfo.Data, BlankFileInfo);
    GetOneRecord(GridInfo.FileNum, GridInfo.IENS, GridInfo.Data, BlankFileInfo);
    //frmPtDemoEdit.LoadAnyGridFromInfo(GridInfo);
    //LoadAnyGridFromInfo(GridInfo);
    LoadAnyGrid(GridInfo);
  end;

  function TSubfileForm.GetIENS(Node: TTreeNode) : string;
  var dataLine : integer;
  begin
    if Node= nil then exit;
    dataLine := integer(Node.Data);
    if dataLine < IENS_Store.Count then begin
      result := IENS_Store.Strings[dataLine];
    end else result := '';
  end;

  function TSubfileForm.StoreIENS(IENS: string) : integer;
  begin
    result := IENS_Store.Add(IENS);
  end;
  
  
  procedure TSubfileForm.GetAllSubRecords(SubFileNum, ParentIENS : string; SubRecsList : TStringList);
  var  cmd,RPCResult : string;
       FMErrorForm: TFMErrorForm;

  begin
    SubRecsList.Clear;
    RPCBrokerV.remoteprocedure := 'TMG CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';  // not used
    RPCBrokerV.param[0].ptype := list;
    cmd := 'GET SUB RECS LIST' + '^' + SubFileNum + '^' + ParentIENS;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    //RPCBrokerV.Call;
    CallBroker;
    RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
    if piece(RPCResult,'^',1)='-1' then begin
      FMErrorForm:= TFMErrorForm.Create(self);
      FMErrorForm.Memo.Lines.Assign(RPCBrokerV.Results);
      FMErrorForm.PrepMessage;
      FMErrorForm.ShowModal;
      FMErrorForm.Free;
    end else begin
      SubRecsList.Assign(RPCBrokerV.Results);
    end;
  end;
  
  procedure TSubfileForm.FormCreate(Sender: TObject);
  begin
    SubFileGrid := TSortStringGrid.Create(Self);       //kt 9/11
    SubFileGrid.Parent := pnlSortGridHolder;           //kt 9/11
    SubFileGrid.Align := alClient;                     //kt 9/11
    SubFileGrid.OnClick := SubFileGridClick;           //kt 9/11
    SubFileGrid.OnSelectCell := SubFileGridSelectCell; //kt 9/11
    AllSubRecords := TStringList.Create;
    BlankFileInfo := TStringList.Create;
    IENS_Store := TStringList.Create;
    CurrentSubFileData := TStringList.Create;  
    GridInfo := TGridInfo.Create;

    ModifiedForm := False;   
  end;

  procedure TSubfileForm.FormDestroy(Sender: TObject);
  begin
    AllSubRecords.Free;
    BlankFileInfo.Free;
    IENS_Store.Free;
    CurrentSubFileData.Free;
//    fPtDemoEdit.UnRegisterGridInfo(GridInfo);
    GridInfo.Free;
  end;

  procedure TSubfileForm.SubFileGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean); 
  begin
    GridInfo.MessageStr := MSG_SUB_FILE;
    //frmPtDemoEdit.gridPatientDemoSelectCell(Sender, ACol, ARow, CanSelect);
    //AnyGridPatientDemoSelectCell(Sender, ACol, ARow, CanSelect);
    //AnyGridPatientDemoSelectCell(GridInfo, ACol, ARow, CanSelect);
  end;

  
  procedure TSubfileForm.AddBtnClick(Sender: TObject);
  var Name,IENS : string;
      tempNode : TTreeNode;
      dataLine : integer;
  begin
    RevertBtn.Enabled := True;
    ApplyBtn.Enabled := True;
    ModifiedForm := True;
    Inc(LastAddNum);
    IENS := '+' + IntToStr(LastAddNum) + ',' + FParentIENS;
    Name := '<NEW>';
    dataLine := StoreIENS(IENS);
    tempNode := TreeView.Items.AddChildObject(Root,Name,Pointer(dataLine));
    //frmPtDemoEdit.GetOneRecord(FSubfileNum,IENS,CurrentSubFileData, BlankFileInfo);
    GetOneRecord(FSubfileNum,IENS,CurrentSubFileData, BlankFileInfo);
    Root.expand(true);
    TreeView.Select(tempNode);
  end;

  procedure TSubfileForm.FormShow(Sender: TObject);
  begin
    LastAddNum := 0;
  end;

  procedure TSubfileForm.RevertBtnClick(Sender: TObject);
  begin
    ModifiedForm := False;
    //frmPtDemoEdit.LoadAnyGridFromInfo(GridInfo);
    //LoadAnyGridFromInfo(GridInfo);
    LoadAnyGrid(GridInfo);
  end;

  procedure TSubfileForm.ApplyBtnClick(Sender: TObject);
  var  IENS : string;
  begin
    ModifiedForm := False;
    IENS := GetIENS(FLastSelectedNode);
    PostChanges(SubFileGrid,IENS);
  end;

  procedure TSubfileForm.SubFileGridClick(Sender: TObject);
  //var sel : TGridRect;
  //    temp : boolean;
  begin
    ModifiedForm := True;
    RevertBtn.Enabled := True;
    ApplyBtn.Enabled := True;
    {//kt Eddie, what was the purpose of this?  Causes unexpected click
          when returning from sub-sub file...
    Sel := SubFileGrid.Selection;
    if Sel.Top <> FLastSelectedRow then begin
      SubFileGridSelectCell(SubFileGrid, Sel.Left, Sel.Top, temp);
    end;
    }
  end;

  
  procedure TSubfileForm.PostChanges(Grid : TSortStringGrid; IENS : string; SilentMode : boolean);
  
    function NewIENS(oldIENS : string; PostResults : TStringList) : string;
    //format of PostResults is:  oldIENS^newIENS
    var i : integer;
        oneEntry : string;
        newIENS,
        parentIENS : string;
    begin
      result := '';
      newIENS := piece(oldIENS,',',1);   // +1,123, --> +1
      parentIENS := MidStr(oldIENS,length(newIENS)+1,99);
      newIENS := piece(newIENS,'+',2);   // +1 --> 1
      for i := 1 to PostResults.Count-1 do begin  //0 is 1^Success
        oneEntry := PostResults.Strings[i];
        if piece(oneEntry,'^',1) <> newIENS then continue;
        result := piece(oneEntry,'^',2) + parentIENS;
        break;                
      end;
    end;
    
  var Changes : TStringList;
      PostResult : TModalResult;
      PostForm: TPostForm;

  begin
    Changes := TStringList.Create;
    CompileChanges(Grid,CurrentSubFileData,Changes);
    if Changes.Count>0 then begin
      PostForm := TPostForm.Create(Self);
      if SilentMode = false then begin
        PostForm.PrepForm(Changes);
        PostResult := PostForm.ShowModal;
      end else begin
        PostResult := PostForm.SilentPost(Changes);
      end;
      PostForm.Free;
      if PostResult in [mrOK,mrNone] then begin
        RevertBtn.Enabled := false;
        ApplyBtn.Enabled := false;
        if PostResult = mrOK then InitTreeView;
      end else if PostResult = mrNo then begin  //mrNo is signal of post Error
        // show error...
      end;
    end;
    Changes.Free;
  end;

  procedure TSubfileForm.CompileChanges(Grid : TSortStringGrid; CurrentUser,Changes : TStringList);
  //Output format:
  // FileNum^IENS^FieldNum^FieldName^newValue^oldValue

  var row : integer;
      Entry : tFileEntry;
      oneEntry : string;
  begin
    for row := 1 to Grid.RowCount-1 do begin
      //Entry := frmPtDemoEdit.GetLineInfo(Grid,CurrentSubFileData,row);
      Entry := GetLineInfo(Grid,CurrentSubFileData,row);
      if (Entry.oldValue <> Entry.newValue) then begin
        if (Entry.newValue <> CLICK_FOR_SUBS) and
          (Entry.newValue <> COMPUTED_FIELD) and
          (Entry.newValue <> CLICK_TO_EDIT) then begin   
          oneEntry := Entry.FileNum + '^' + Entry.IENS + '^' + Entry.Field + '^' + Entry.FieldName;
          oneEntry := oneEntry + '^' + Entry.newValue + '^' + Entry.oldValue;
          Changes.Add(oneEntry);
        end;  
      end;
    end;
  end;

  
  procedure TSubfileForm.DoneBtnClick(Sender: TObject);
  var Changes : TStringList;
  begin
    if ModifiedForm = True then begin
      Changes := TStringList.Create;
      CompileChanges(SubFileGrid,CurrentSubFileData,Changes);
      if Changes.Count>0 then begin
        ApplyBtnClick(self);
        ModalResult := mrNo;
      end else begin
        ModalResult := mrNo;    
      end;    
    end else begin
      ModalResult := mrNo;      
    end;   
  end;

  procedure TSubfileForm.DeleteBtnClick(Sender: TObject);
  var  IENS : string;
       row,ARow : integer;
       response: integer;
  begin
    //The rows can be rearranged, so row 1 will not reliably hold
    //the .01 field.  And if there is a .001 field, it might be
    //shown above the .01 field etc.
    response := messagedlg('Are you sure you want to delete ' + TreeView.Selected.Text,mtWarning,[mbYes,mbNo],0);
    if response = mrYes then begin
      ARow := 0;
      for row := 1 to SubFileGrid.RowCount-1 do begin
        if SubFileGrid.Cells[0,row]='.01' then begin
          ARow := row; break;
        end;  
      end;      
      if ARow > 0 then begin
        SubFileGrid.Cells[2,ARow] := '@';   //columns can't be rearranged (for now)
        IENS := GetIENS(FLastSelectedNode);
     //I wonder what Fileman will say if the .01 field has '@'
     //  and there are other fields with changes also.  I might
     //  complain about making changes and a deletion at the same
     //  time.  Perhaps we ought to have a custom delete function
     //  that deletes everything from the CompiledChanges except for
     //  the .01 record.  Let's wait and see if this is a problem or
     //  not first.
        PostChanges(SubfileGrid,IENS,true);  //<-- true = SilentMode
      end else begin
       MessageDlg('Unable to find row containing .01 field',mtError,[mbOK],0);
      end;  
    end;  
  end;

  

end.

