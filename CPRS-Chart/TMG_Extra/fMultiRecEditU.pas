unit fMultiRecEditU;
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
  StrUtils, {MainU,} uTMGTypes, rTMGRPCs, uTMGGrid, uTMGGlobals,
  Dialogs, StdCtrls, ExtCtrls, Grids, ComCtrls, Buttons, SortStringGrid;

type

  TfrmMultiRecEdit = class(TForm)
    Panel1: TPanel;
    TreeView: TTreeView;
    SubFileGrid: TSortStringGrid;
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
    lblSubRecIENSLabel: TLabel;
    lblSubredIENS: TLabel;
    btnSpecialInfo: TBitBtn;
    TimerDelayedViewBtnAction: TTimer;
    btnSpecialInfoAll: TBitBtn;
    btnCancelIcon: TBitBtn;
    btnOKIcon: TBitBtn;
    procedure btnSpecialInfoAllClick(Sender: TObject);
    procedure TimerDelayedViewBtnActionTimer(Sender: TObject);
    procedure btnSpecialInfoClick(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure SubFileGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure AddBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RevertBtnClick(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure SubFileGridClick(Sender: TObject);
    procedure DoneBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Root  : TTreeNode;
    FSubFileNum : string;
    FParentIENS : string;
    FFields     : string;
    FIdentifier : string;
    IENS_Store : TStringList;
    BlankFileInfo : TStringList;
    //FLastSelectedRow : integer;
    FLastSelectedNode : TTreeNode;
    AllSubRecords : TStringList;
    LastAddNum : integer;
    IgnoreSelections : boolean;
    ModifiedForm : boolean;  //Used to see if current record is unsaved
    FPosted : boolean;
    FGridInfo : TCompleteGridInfo; //Owned by GlobalsU.DataForGrid
    FAddingNewRecord : boolean;
    FIgnoreOneApplyBtnCycle : boolean;
    FChangesMade : boolean;
    //procedure CompileChanges(Grid : TSortStringGrid; CurrentUser,Changes : TStringList);
    function  PostChanges(Grid : TSortStringGrid; IENS : string; SilentMode : boolean = true) : boolean;
    procedure InitTreeView;
    Procedure LoadTreeView(AllSubRecords : TStringList);
    Procedure ClearTreeView;
//    procedure ClearGrid;
    function GetIENS(Node: TTreeNode) : string;
    function StoreIENS(IENS: string) : integer;
    procedure CheckSetSpecialInfoBtnVisibility;
    procedure SetModifiedStatus(IsModified :Boolean);
    function GetGridInfo : TGridInfo;
    function GridHasChanges : boolean;
    function GetChangesMade : boolean;
  public
    { Public declarations }
    ActionOnShowMode : integer;
    ParentEditForm : TVariantPopupEdit;
    procedure PrepForm(subFileNum, ParentIENS : string; Fields : String='';
                       Identifier : String=''; CustomPtrFieldEditors : TStringList = nil);
    function TransferSubfileRecord(subFileNum : string; CurrentIENS, NewIENS : string) : boolean;
    procedure GetAllSubRecords(SubRecsList : TStringList; Fields : string = ''; Identifier : string = '');
    property GridInfo : TGridInfo read GetGridInfo;
    property Posted : boolean read FPosted;
    property ChangesMade : boolean read GetChangesMade;  //Signal that data was changed somehow.
  end;

function GetSubRecCount(SubFileNum, ParentIENS : string) : Integer;  forward;
function GetPreviewText(SubFileNum, ParentIENS : string) : String;  forward;

const
  MSG_SUB_FILE = 'SubFile';
  ACTION_ON_SHOW_NONE = 0;
  ACTION_ON_SHOW_ADD = 1;
  NEW_RECORD_TAG = '<NEW>';  //note: If this is changed, also change GETEFLD^TMGRPC3E

implementation

uses
  ORNet, ORFn, ORCtrls,
  Trpcb,  //needed for .ptype types
  ToolWin, SelDateTimeU, SetSelU, LookupU, PostU, FMErrorU,
  {fFindingDetail, }uTMGUtil
  {,AgeFreqU, Rem2VennU};

{$R *.dfm}

  procedure TfrmMultiRecEdit.FormCreate(Sender: TObject);
  begin
    AllSubRecords := TStringList.Create;
    BlankFileInfo := TStringList.Create;
    IENS_Store := TStringList.Create;
    FGridInfo := TCompleteGridInfo.Create; //ownership will be transferred to GlobalsU.DataForGrid
    //ModifiedForm := False;
    SetModifiedStatus(False);
    ParentEditForm.RecType := vpefNone;
    ParentEditForm.EditForm := nil;
    ActionOnShowMode := ACTION_ON_SHOW_NONE;
  end;

  procedure TfrmMultiRecEdit.FormDestroy(Sender: TObject);
  begin
    AllSubRecords.Free;
    BlankFileInfo.Free;
    IENS_Store.Free;
    UnRegisterGridInfo(FGridInfo);
    //FGridInfo.Free;  <-- done in UnRegisterGridInfo
  end;

  procedure TfrmMultiRecEdit.PrepForm(subFileNum, ParentIENS : string;
                                      Fields : String='';
                                      Identifier : String='';
                                      CustomPtrFieldEditors : TStringList = nil
                                      );
  //Format is: FileNum^IENS^FieldNum^ExternalValue^DDInfo...
  var DispIENS, ExpandedFileName : string;
  begin
    {
    AddGridInfo('SubfileForm', SubFileGrid, CurrentSubFileData, nil,
                nil, subFileNum, ApplyBtn, RevertBtn);
    FGridInfo := GetInfoObjectForGrid(SubFileGrid);
    }

    FGridInfo.Grid := SubFileGrid;
    FGridInfo.FileNum := subFileNum;
    FGridInfo.IENS := ParentIENS;
    FGridInfo.Fields := Fields;
    FGridInfo.IdentifierCode := Identifier;
    FGridInfo.ApplyBtn := ApplyBtn;
    FGridInfo.RevertBtn := RevertBtn;
    FGridInfo.CustomPtrFieldEditors.Assign(CustomPtrFieldEditors); //no ownership

    RegisterGridInfo(FGridInfo);  //FGridInfo becomes owned by GlobalsU.DataForGrid

    BlankFileInfo.Clear;
    IENS_Store.Clear;
    FAddingNewRecord := false;
    FIgnoreOneApplyBtnCycle := false ;
    FSubFileNum := subFileNum;
    FChangesMade := true;

    FParentIENS := ParentIENS;
    FFields     := Fields;
    FIdentifier := Identifier;
    DispIENS := ParentIENS;
    if (DispIENS <> '') and (DispIENS[Length(DispIENS)] = ',') then begin
      DispIENS := StrUtils.LeftStr(DispIENS, Length(DispIENS)-1);
    end;
    ExpandedFileName := rTMGRPCs.ExpandFileNumber(subFileNum);
    self.caption := 'Edit Sub-File Entries in Subfile ' + ExpandedFileName + ' (#' + subFileNum + '); Parent Record=' + DispIENS;
    ClearTreeView;
    InitTreeView;
  end;

  procedure TfrmMultiRecEdit.InitTreeView;
  var tempMap : string;
  begin
    IgnoreSelections := true;
    GetAllSubRecordsRPC(FSubFileNum,FParentIENS, AllSubRecords, tempMap, FFields, FIdentifier);
    ClearGrid(SubFileGrid);
    LoadTreeView(AllSubRecords);
    Root.Expand(true);
    IgnoreSelections := false;
    if Root.HasChildren then begin
      Root.getFirstChild.Selected := true; //select first child
    end;
  end;

  Procedure TfrmMultiRecEdit.LoadTreeView(AllSubRecords : TStringList);
  //Format is: FullIENS^.01Value

  var i : integer;
      dataLine : integer;
      oneEntry,value,Name,IENS : string;
  begin
    ClearTreeView;
    for i := 0 to AllSubRecords.Count-1 do begin
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

  Procedure TfrmMultiRecEdit.ClearTreeView;
  begin  
    TreeView.Items.Clear;
    IENS_Store.Clear;
    Root := TreeView.Items.Add(nil,'Subrecords');
    //if Root.HasChildren then Root.DeleteChildren;
//    ClearGrid;
    ClearGrid(SubFileGrid);
  end;
  

  procedure TfrmMultiRecEdit.TreeViewChanging(Sender: TObject; Node: TTreeNode;
    var AllowChange: Boolean);
  begin
    ApplyBtnClick(self);
  end;

  procedure TfrmMultiRecEdit.TreeViewChange(Sender: TObject; Node: TTreeNode);
  begin
    FLastSelectedNode := Node;
    if FAddingNewRecord then begin
      if FGridInfo.Data.Count=0 then exit;
      FGridInfo.IENS := piece(FGridInfo.Data.Strings[0],'^',2);
    end else begin
      FGridInfo.IENS := GetIENS(Node);
      GetOneRecord(FGridInfo.FileNum, FGridInfo.IENS, FGridInfo.Data, BlankFileInfo);
    end;
    lblSubredIENS.Caption := FGridInfo.IENS;
    LoadAnyGrid(FGridInfo);
  end;

  function TfrmMultiRecEdit.GetIENS(Node: TTreeNode) : string;
  var dataLine : integer;
  begin
    if Node= nil then exit;
    dataLine := integer(Node.Data);
    if dataLine < IENS_Store.Count then begin
      result := IENS_Store.Strings[dataLine];
    end else result := '';
  end;

  function TfrmMultiRecEdit.StoreIENS(IENS: string) : integer;
  begin
    result := IENS_Store.Add(IENS);
  end;

  procedure TfrmMultiRecEdit.GetAllSubRecords(SubRecsList : TStringList; Fields : string = ''; Identifier : string = '');
  begin
    GetAllSubRecordsRPC(FSubFileNum,FParentIENS, SubRecsList, Fields, Identifier);
  end;

  function GetSubRecCount(SubFileNum, ParentIENS : string) : integer;
  var
    SL : TStringList;
    tempMap : string;
  begin
    SL := TStringList.Create;
    if Pos('+', ParentIENS)=0 then begin
      GetAllSubRecordsRPC(SubFileNum, ParentIENS, SL, tempMap);
    end;
    //if SL.Count > 0 then SL.Delete(0);
    Result := SL.Count;
  end;

  function GetPreviewText(SubFileNum, ParentIENS : string) : String;
    var NumSubs : integer;
  begin
    NumSubs := GetSubRecCount(SubFileNum, ParentIENS);
    if NumSubs > 0 then begin
      Result := CLICK_TO_EDIT_SUBS + ' [' + IntToStr(NumSubs) + ' exist';
      if NumSubs=1 then Result := Result + 's';
      Result := Result + ']';
    end else begin
      Result := CLICK_TO_ADD_SUBS;
    end;
  end;

  function TfrmMultiRecEdit.GetGridInfo : TGridInfo;
  begin
    Result := TGridInfo(FGridInfo);
  end;


  procedure TfrmMultiRecEdit.SubFileGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  var AutoPress: boolean;
  begin
    AutoPress := False;
    FGridInfo.MessageStr := MSG_SUB_FILE;
    uTMGGrid.GridSelectCell(Sender, ACol, ARow, CanSelect,nil,AutoPress);
    {(Sender: TObject; ACol, ARow: Integer;
                           var CanSelect: Boolean;
                           LastSelTreeNode : TTreeNode;
                           var AutoPressEditButtonInDetailDialog : boolean);}
    SetModifiedStatus(GridHasChanges);
  end;


  procedure TfrmMultiRecEdit.AddBtnClick(Sender: TObject);
  var Name,IENS : string;
      tempNode : TTreeNode;
      dataLine : integer;
  begin
    ApplyBtnClick(self);  //post changes.
    RevertBtn.Enabled := True;
    ApplyBtn.Enabled := True;
    //ModifiedForm := True;
    SetModifiedStatus(True);
    Inc(LastAddNum);
    IENS := '+' + IntToStr(LastAddNum) + ',' + FParentIENS;
    Name := NEW_RECORD_TAG;
    dataLine := StoreIENS(IENS);
    tempNode := TreeView.Items.AddChildObject(Root,Name,Pointer(dataLine));
    GetOneRecord(FSubfileNum,IENS, FGridInfo.Data, BlankFileInfo);
    //NewSubFileData Format --> FileNum^IENS^FieldNum^Value^FieldName^... dd info
    //Changes Format --> FileNum^IENS^FieldNum^FieldName^newValue^oldValue
    FAddingNewRecord := true;
    TreeView.OnChanging := nil;

    Root.expand(true);
    TreeView.Select(tempNode);

    //TreeView.OnChange := TreeViewChange;
    TreeView.OnChanging := TreeViewChanging;
  end;

  procedure TfrmMultiRecEdit.FormShow(Sender: TObject);
  begin
    FPosted := false;
    LastAddNum := 0;
    if ActionOnShowMode = ACTION_ON_SHOW_ADD then begin
      AddBtnClick(Sender);
      ActionOnShowMode := ACTION_ON_SHOW_NONE; //turn it off for next time.
    end;
    CheckSetSpecialInfoBtnVisibility;
    if btnSpecialInfo.Visible then begin
      TimerDelayedViewBtnAction.Interval := 100;
      TimerDelayedViewBtnAction.Enabled := true;
    end;
  end;

  procedure TfrmMultiRecEdit.RevertBtnClick(Sender: TObject);
  begin
    //ModifiedForm := False;
    SetModifiedStatus(False);
    //if assigned(FLastSelectedNode) and (FLastSelectedNode.Text = NEW_RECORD_TAG) then begin
    if FAddingNewRecord then begin
      FIgnoreOneApplyBtnCycle := true;
      FAddingNewRecord := false;
      InitTreeView;
    end else begin
      LoadAnyGrid(FGridInfo);
    end;
  end;

  procedure TfrmMultiRecEdit.ApplyBtnClick(Sender: TObject);
  var  IENS : string;

  begin
    if FIgnoreOneApplyBtnCycle then begin
      FIgnoreOneApplyBtnCycle := false;
      exit;
    end;
    if FAddingNewRecord then begin
      if FGridInfo.Data.Count=0 then exit;
      IENS := piece(FGridInfo.Data.Strings[0],'^',2);
      //FileNum^IENS^FieldNum^Value^FieldName^... dd info
    end else begin
      IENS := GetIENS(FLastSelectedNode);
    end;
    //ModifiedForm := False;
    if PostChanges(SubFileGrid,IENS) = true then begin
      SetModifiedStatus(False);
    end;
  end;

  procedure TfrmMultiRecEdit.SubFileGridClick(Sender: TObject);
  begin
    //ModifiedForm := True;
    //RevertBtn.Enabled := True;
    //ApplyBtn.Enabled := True;
  end;


  function TfrmMultiRecEdit.PostChanges(Grid : TSortStringGrid; IENS : string; SilentMode : boolean) : boolean;
  //Returns TRUE if successful
  var //Changes : TStringList;
      PostResult : TModalResult;
      Posted : boolean;
      //CurrentData : TStringList;
      //GridInfo : TGridInfo;
      //Name     : string;
  begin
    Result := false; //Default to problem.
    PostResult := uTMGGrid.PostChanges(Grid, SilentMode, FAddingNewRecord, Posted);
    if PostResult in [mrOK,mrNone] then begin
      Result := true;
      if PostResult = mrOK then begin
        FChangesMade := true;
        //Result := true;
        FAddingNewRecord := false;
        FIgnoreOneApplyBtnCycle := true;
        InitTreeView;
      end;
      if assigned(GridInfo.OnAfterPost) and Posted then begin
        GridInfo.OnAfterPost(GridInfo, uTMGGrid.Changes);
      end;
    end;
    {  commented out prior to 5/15/13
    Changes := TStringList.Create;
    GridInfo := GetInfoObjectForGrid(Grid);
    if GridInfo=nil then exit;
    CurrentData := GridInfo.Data;
    if CurrentData=nil then exit;
    if CurrentData.Count = 0 then exit;
    //CompileChanges(Grid,CurrentSubFileData,Changes, FAddingNewRecord);
    CompileChanges(Grid,CurrentData,Changes, FAddingNewRecord);
    if Changes.Count>0 then begin
      if FAddingNewRecord then begin
        //Changes Format --> FileNum^IENS^FieldNum^FieldName^newValue^oldValue
        Name := UtilU.GetOneFldValue(Changes, FGridInfo.FileNum, '.01', 5);
        if (Name = NEW_RECORD_TAG) or (Name = '') then begin
          MessageDlg('Can''t use ' + NEW_RECORD_TAG + ' for .01 field. ' + #10#13 +
                     'Please edit and retry.', mtError, [mbOK], 0);
          Result := false;
          exit;
        end;
      end;
      if SilentMode = false then begin
        PostForm.PrepForm(Changes);
        PostResult := PostForm.ShowModal;
      end else begin
        PostResult := PostForm.SilentPost(Changes);
      end;
      FPosted := PostForm.Posted;
      if PostResult in [mrOK,mrNone] then begin
        RevertBtn.Enabled := false;
        ApplyBtn.Enabled := false;
        if PostResult = mrOK then begin
          Result := true;
          FAddingNewRecord := false;
          InitTreeView;
        end;
        if assigned(GridInfo.OnAfterPost) and PostForm.Posted then begin
          GridInfo.OnAfterPost(GridInfo, Changes);
        end;
      end else if PostResult = mrNo then begin  //mrNo is signal of post Error
        Result := false;
      end;

    end;
    Changes.Free;
    }
  end;


  procedure TfrmMultiRecEdit.TimerDelayedViewBtnActionTimer(Sender: TObject);
  begin
    TimerDelayedViewBtnAction.Enabled := false;
    if btnSpecialInfoAll.Visible then btnSpecialInfoAllClick(Sender)
    else btnSpecialInfoClick(Sender);
  end;

  function TfrmMultiRecEdit.TransferSubfileRecord(subFileNum : string; CurrentIENS, NewIENS : string) : boolean;
  //Purpose: to transfer a subfile record from one parent record to another
  //Input: subFileNum -- the file number of the SUB-fle
  //       CurrentIENS -- the IENS for the record to be changed
  //       NewIENS -- NOTE: should be in format of '+1,<ParentIEN>,<GrandParentIEN>, ... etc'  +1 is required
  //Result: returns true if performed.  False if there was an error.
  //        Any error message will also be displayed, if encountered, prior to return.
  begin
    //Get current record
    //Setup for post to new IENS
    //perform post
    //Check for errors
    //If errors, display error log.
    Result := false;
  end;

  procedure TfrmMultiRecEdit.SetModifiedStatus(IsModified :Boolean);
  begin
    ModifiedForm := IsModified;
    RevertBtn.Enabled := IsModified;
    ApplyBtn.Enabled := IsModified;
    if IsModified then begin
      DoneBtn.Glyph.Assign(btnCancelIcon.Glyph);
      DoneBtn.Caption := '&Cancel';
    end else begin
      DoneBtn.Glyph.Assign(btnOKIcon.Glyph);
      DoneBtn.Caption := '&Done';
    end;
  end;

  function TfrmMultiRecEdit.GetChangesMade : boolean;
  begin
    Result := FChangesMade or GridInfo.DisplayRefreshIndicated;
  end;


  function TfrmMultiRecEdit.GridHasChanges : boolean;
  var Changes : TStringList;
  begin
    Changes := TStringList.Create;
    CompileChangesEx(SubFileGrid, FGridInfo.Data, Changes);
    Result := (Changes.Count>0);
    Changes.Free;
  end;

  procedure TfrmMultiRecEdit.DoneBtnClick(Sender: TObject);
  var Result : integer;
  begin
    Result := mrOK;  //was mrNo
    if ModifiedForm = True then begin
      if GridHasChanges then begin
        Result :=MessageDlg('Save changes before exiting?', mtWarning, mbYesNoCancel, 0);
        if Result = mrCancel then exit;
        if Result = mrYes then begin
          ApplyBtnClick(self);
        end;
      end;
    end;
    ModalResult := Result;
  end;

  procedure TfrmMultiRecEdit.DeleteBtnClick(Sender: TObject);
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

  procedure TfrmMultiRecEdit.CheckSetSpecialInfoBtnVisibility;
  begin
    //Optionally add more later
    btnSpecialInfo.Visible := (FGridInfo.FileNum = '811.97')      //Reminder Definition file
                           or (FGridInfo.FileNum = '811.52') ;    //REMINDER TERM:FINDINGS
    btnSpecialInfoAll.Visible := (FGridInfo.FileNum = '811.52');  //REMINDER TERM:FINDINGS
  end;


  procedure TfrmMultiRecEdit.btnSpecialInfoAllClick(Sender: TObject);
  //Var
    //FindingDetailForm : TFindingDetailForm;
  begin
  {
    FindingDetailForm := TFindingDetailForm.Create(Self);
    //NOTE: If edits are made to the edit form, and applied,
    //   they are not being updated in GridInfo.Data.  So old
    //   data is showed.  FIX LATER...
    if FindingDetailForm.Initialize(FGridInfo) then begin
      FindingDetailForm.ShowModal;
    end;
    //MessageDlg('Here I can show all terms...',mtInformation, [mbOK],0);
    FindingDetailForm.Free;     }
  end;

  procedure TfrmMultiRecEdit.btnSpecialInfoClick(Sender: TObject);
  {var ChildNode,ParentNode: TTreeNode;
      IENS : string;
      SummationData, tempData : TStringList;
      Freq,Min,Max : string;
      Value : String;
      CanSelect : Boolean;
      frmAgeFreq: TfrmAgeFreq;   }

  begin
   // handle special
  { if FGridInfo.FileNum = '811.97' then begin  //Reminder Definition file
     if not Assigned(FLastSelectedNode) then exit;
     SummationData := TStringList.Create;
     tempData := TStringList.Create;
     ParentNode := FLastSelectedNode.Parent;
     ChildNode := ParentNode.getFirstChild;
     while (ChildNode <> nil) do begin
       IENS := GetIENS(ChildNode);
       ChildNode := ParentNode.GetNextChild(ChildNode);
       GetOneRecord(FGridInfo.FileNum, IENS, tempData, BlankFileInfo);
       if tempData.Count < 1 then continue;
       //if piece(tempData.Strings[0],'^',1) <> '1' then continue;
       Freq := Rem2VennU.FieldValue(tempData,'.01');
       Min := Rem2VennU.FieldValue(tempData,'1');
       Max := Rem2VennU.FieldValue(tempData,'2');
       SummationData.Add(Freq+'^'+Min+'^'+Max);
     end;
     frmAgeFreq := TfrmAgeFreq.Create(Self);
     frmAgeFreq.Initialize(SummationData);
     frmAgeFreq.InitializeExtra(FGridInfo.IENS);
     frmAgeFreq.ShowModal;
     frmAgeFreq.Free;
     SummationData.Free;
     tempData.Free;
   end else if (FGridInfo.FileNum = '811.52') then begin  //Reminder taxonomy
     Value := SubFileGrid.Cells[2,1];
     if Value <> '' then begin  //Don't auto click if no entry.
       TMG_Auto_Press_Edit_Button_In_Detail_Dialog := true;
       MainForm.GridSelectCell(SubFileGrid, 2, 1, CanSelect);  //Row 1 = field .01 (FINDING ITEM), Col 2 = cell with data.
     end;
   end;
        }
  end;


end.

