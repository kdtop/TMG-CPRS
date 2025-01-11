unit uTMGGrid;
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
  Dialogs, StdCtrls, StrUtils,
  ORNet, ORFn, ComCtrls, Grids, ORCtrls, ExtCtrls, Buttons,
  uTMGTypes, uTMGGlobals, SortStringGrid;


//Globally scoped var  //kt 12/18/13
var
  LastSelTreeNode : TTreeNode;
  LastSelTreeView : TTreeView;

function  GetInfoObjectForGrid(Grid : TSortStringGrid) : TGridInfo;
function  GetInfoIndexForGrid(Grid : TSortStringGrid) : integer;
procedure RegisterGridInfo(GridInfo : TGridInfo);
procedure UnRegisterGridInfo(GridInfo : TGridInfo); //overload;
//procedure UnRegisterGridInfo(Name : string); overload;
procedure AddGridInfo(Name : string; Grid: TSortStringGrid;
                      Data : TStringList; BasicTemplate : TStringList;
                      DataLoader : TGridDataLoader; FileNum : string;
                      ApplyBtn,RevertBtn : TButton; RecSelector : TIENSSelector = nil);
procedure ClearGrid(Grid : TSortStringGrid);
procedure ClearGridList(GridList : TList);
procedure LoadAnyGrid(Grid : TSortStringGrid; BasicTemplate : TStringList;
                      FileNum,IENS : string; CurrentData : TStringList); overload;
procedure LoadAnyGrid(GridInfo : TGridInfo); overload;
procedure LoadAnyGrid(Grid: TSortStringGrid); overload;
procedure LoadAnyGrid(Grid: TSortStringGrid; GridInfo : TGridInfo); overload;
function  GetLineInfo(Grid : TSortStringGrid; CurrentUserData : TStringList; ARow: integer) : tFileEntry;
procedure CompileChanges  (Grid : TSortStringGrid; CurrentData, Changes : TStringList; NewRecMode : boolean = false);
procedure CompileChangesEx(Grid : TSortStringGrid; CurrentData, Changes : TStringList);
function  GetGridHint(Grid : TSortStringGrid; FileNum : string; ACol, ARow : integer) : string;
//function  PostChanges(Grid : TSortStringGrid; SilentMode : boolean=true;
//                      AddingNewRecord : boolean = false) : TModalResult;
function  PostChanges(Grid : TSortStringGrid; SilentMode : boolean;
                      AddingNewRecord : boolean; var Posted : boolean) : TModalResult;
function  GetVisibleGridInfo : TGridInfo;
function  GetVisibleGrid: TSortStringGrid;
procedure SetVisibleGridIdx(Grid : TSortStringGrid);
function  PostVisibleGrid: TModalResult;
procedure DoRevert(BasicGrid, AdvancedGrid : TSortStringGrid); overload;
procedure DoRevert(GridList : TList; AdvancedGrid : TSortStringGrid; Dummy : byte); overload;
procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
                         var CanSelect: Boolean; LastSelTreeNode : TTreeNode;
                         var AutoPressEditButtonInDetailDialog : boolean);
procedure GridSelectCellFromInfo(GridInfo : TGridInfo; ACol, ARow: Integer;
                         var CanSelect: Boolean;
                         LastSelTreeNode : TTreeNode;
                         var AutoPressEditButtonInDetailDialog : boolean);
procedure ExternalSelectGridCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean); overload;
procedure ExternalGridSelectCell(GridInfo : TGridInfo; ACol, ARow: Integer; var CanSelect: Boolean); overload;
procedure GetRecordsInfoAndLoadIntoGrids(GridInfo : TGridInfo; GridList : TList; CmdName : string='');

procedure InitUsersTemplateStuff(BasicTemplate : TStringList);
procedure InitSettingsFilesTemplateStuff(BasicTemplate : TStringList);
procedure InitRemDlgTemplate(DlgTemplate : TStringList);
procedure InitDlgElementTemplate(DlgElementTemplate : TStringList);
procedure InitDlgPromptTemplate(DlgPromptTemplate : TStringList);
procedure InitDlgForcedVTemplate(DlgForcedVTemplate : TStringList);
procedure InitDlgGroupTemplate(DlgGroupTemplate : TStringList);
procedure InitDlgRsltGroupTemplate(DlgRsltGroupTemplate : TStringList);
procedure InitDlgRsltElementTemplate(DlgRsltElementTemplate : TStringList);
procedure InitRemFindingsTemplateList(ListOfTemplates : TStringList);
procedure InitReminderFunctionFindingTemplate(BasicTemplate : TStringList);

function GetCursorImage : TCursor;
procedure SetCursorImage(Cursor : TCursor);


function HandleDateEdit(InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string=''; ExtraInfoSL : TStringList=nil;
                        Fields : string = '';
                        Identifier : string = '') : string;
function HandleTextEdit(InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string=''; ExtraInfoSL : TStringList=nil;
                        Fields : string = ''; Identifier : string = '') : string;
function HandlePtrEdit (InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string=''; ExtraInfoSL : TStringList=nil;
                        Fields : string = ''; Identifier : string = '') : string;
function HandleVarPtrEdit(InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string=''; ExtraInfoSL : TStringList=nil;
                        Fields : string = ''; Identifier : string = '') : string;
function HandleSetEdit (InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string=''; ExtraInfoSL : TStringList=nil;
                        Fields : string = ''; Identifier : string = '') : string;
function HandleNumEdit (InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string=''; ExtraInfoSL : TStringList=nil;
                        Fields : string = ''; Identifier : string = '') : string;
function HandleWPEdit  (InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string=''; ExtraInfoSL : TStringList=nil;
                        Fields : string = ''; Identifier : string = '') : string;
function HandleSubFileEdit(InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string=''; ExtraInfoSL : TStringList=nil;
                        Fields : string = ''; Identifier : string = '') : string;

const
  GRID_FILTER = 'GRID_FILTER';
  EXTRA_INFO_PIECE_DIV = '&&#&&';

var
  Changes : TStringList;  //contents only defined directly after a PostChanges call.

implementation

  uses  uTMGUtil, rTMGRPCs, EditTextU, fMultiRecEditU, PostU, IniFiles,
        LookupU, EditFreeText, EditNumberU, EditDateTimeU, SetSelU;

  function GetInfoObjectForGrid(Grid : TSortStringGrid) : TGridInfo;
  var i : integer;
  begin
    i := GetInfoIndexForGrid(Grid);
    if i > -1 then begin
      result := TGridInfo(DataForGrid.Objects[i]);
    end else begin
      result := nil;
    end;
  end;

  function GetInfoIndexForGrid(Grid : TSortStringGrid) : integer;
  var s : string;
  begin
    s := IntToStr(integer(Grid));
    result := DataForGrid.IndexOf(s);
  end;


  procedure RegisterGridInfo(GridInfo : TGridInfo);
  var s : string;
      i :integer;
  begin
    if GridInfo = nil then exit;
    s := IntToStr(integer(GridInfo.Grid));
    i := DataForGrid.IndexOf(s);
    if i >= 0 then begin
      DataForGrid.Objects[i] := GridInfo;
    end else begin
      DataForGrid.AddObject(s,GridInfo);
    end;
  end;

  {
  procedure UnRegisterGridInfo(Name : string);
  //kt 5/15/13
  //NOTE: After I created this, I realized that it is unsafe.  If edit form is
  //  called recursively, then all instances will have same text name, and thus
  //  there could be multiple entries for 'SubfileForm', for example.
  var i : integer;
      AGridInfo : TGridInfo;
  begin
    for i := 0 to DataForGrid.Count - 1 do begin
      AGridInfo := TGridInfo(DataForGrid.Objects[i]);
      if AGridInfo.Name <> Name then continue;
      UnRegisterGridInfo(AGridInfo);
      break;
    end;
  end;
  }

  procedure UnRegisterGridInfo(GridInfo : TGridInfo);
  var s : string;
      i : integer;
  begin
    if GridInfo = nil then exit;
    s := IntToStr(integer(GridInfo.Grid));
    i := DataForGrid.IndexOf(s);
    if i = -1 then exit;
    FreeAndDeleteDataForGridListItem(i);
  end;

  procedure AddGridInfo(Name : string;
                        Grid: TSortStringGrid;
                        Data : TStringList;
                        BasicTemplate : TStringList;
                        DataLoader : TGridDataLoader;
                        FileNum : string;
                        ApplyBtn,RevertBtn : TButton;
                        RecSelector : TIENSSelector = nil);
  var GridInfo : TGridInfo;
  begin
    GridInfo := TGridInfo.Create;  //kt 5/15/13 DataForGrid will own object
    GridInfo.Name := Name;
    GridInfo.Grid := Grid;
    GridInfo.Data := Data;
    GridInfo.BasicTemplate := BasicTemplate;
    GridInfo.FileNum := FileNum;
    GridInfo.DataLoadProc := DataLoader;
    GridInfo.ApplyBtn := ApplyBtn;
    GridInfo.RevertBtn := RevertBtn;
    GridInfo.RecordSelector := RecSelector;
    RegisterGridInfo(GridInfo);
  end;

  procedure ClearGrid(Grid : TSortStringGrid);
  var i:integer;
  begin
    for i := 1 to 23 do begin    //elh added to clear all data as some residual remained
       Grid.Cells[0,i] := '';
       Grid.Cells[1,i] := '';
       Grid.Cells[2,i] := '';
    end;
    Grid.RowCount :=2;
  end;

  procedure ClearGridList(GridList : TList);
  var i : integer;
      AGrid : TSortStringGrid;
      AGridInfo : TGridInfo;
  begin
    for i := 0 to GridList.Count - 1 do begin
      AGrid := TSortStringGrid(GridList.Items[i]);
      ClearGrid(AGrid);
      AGridInfo := GetInfoObjectForGrid(AGrid);
      if AGridInfo = nil then continue;
      if AGridInfo.Data = nil then continue;
      AGridInfo.Data.Clear;
      AGridInfo.IENS := '';
    end;
  end;

  //var FLoadingGrid: boolean;

  procedure LoadAnyGrid(GridInfo : TGridInfo);
  //Format of CurrentData:
  //Data[0]=1^Success
  //Data[1]='FileNum^IENS^FieldNum^ExtValue^FieldName^DDInfo...
  //Data[2]='FileNum^IENS^FieldNum^ExtValue^FieldName^DDInfo...
  //...
  //Data[3]='INFO^DD^FileNum^FieldNum^"V" nodes...  (see ExtractVarPtrInfo for more documentation)

  //This assumes that GridInfo already has loaded info.
  var
    Grid : TSortStringGrid;  //the TSortStringGrid to load
    BasicMode: boolean;
    FileNum : string;
    IENS : string;
    CurrentData : TStringList;

    function LoadOneLine (Grid : TSortStringGrid; oneEntry : string; GridRow : integer) : boolean;
    //Result = false if line skipped (nothing added to grid)
    //         true if line added normally
    var
      tempFile,IENS : string;
      fieldNum,fieldName,fieldDef : string;
      subFileNum : string;
      value : string;
      EditWPTextForm: TEditTextForm;
    begin
      tempFile := Piece(oneEntry,'^',1);
      if tempFile = FileNum then begin //handle subfiles later...
        Result := true;
        IENS := Piece(oneEntry,'^',2);
        fieldNum := Piece(oneEntry,'^',3);
        value := Piece(oneEntry,'^',4);
        fieldName := Piece(oneEntry,'^',5);
        fieldDef := Piece(oneEntry,'^',6);
        Grid.RowCount := GridRow + 1;
        Grid.Cells[0,GridRow] := fieldNum;
        Grid.Cells[1,GridRow] := fieldName;
        if Pos('W',fieldDef)>0 then begin
          Grid.Cells[2,GridRow] := CLICK_TO_EDIT_TEXT;
        end else if IsSubFile(fieldDef, subFileNum) then begin
          if IsWPField(CachedWPField, FileNum,fieldNum) then begin
            IENS :=  Piece(oneEntry,'^',2);  //kt
            EditWPTextForm := TEditTextForm.Create(nil);
            EditWPTextForm.PrepForm(FileNum,FieldNum,IENS);  //kt
            Grid.Cells[2,GridRow] := EditWPTextForm.GetPreviewText;
            FreeAndNil(EditWPTextForm);
          end else begin
            Grid.Cells[2,GridRow] := fMultiRecEditU.GetPreviewText(subFileNum, IENS);
          end;
        end else if Pos('C',fieldDef)>0 then begin
          Grid.Cells[1,GridRow] := fieldName + ' ' + COMPUTED_FIELD;
          Grid.ColWidths[1] := 250;
          //kt Grid.Cells[2,GridRow] := COMPUTED_FIELD;
          Grid.Cells[2,GridRow] := value;
        end else begin
          Grid.Cells[2,GridRow] := value;
        end;
        Grid.RowHeights[GridRow] := DEF_GRID_ROW_HEIGHT;
      end else begin
        Result := false;
      end;
    end;

  var i : integer;
      oneEntry  : string;
      oneFileNum,oneFieldNum : string;
      gridRow : integer;
      //GridInfo : TGridInfo;

  begin
    if GridInfo=nil then exit;
    GridInfo.LoadingGrid := true;

    Grid := GridInfo.Grid;
    BasicMode := (Assigned(GridInfo.BasicTemplate) and (GridInfo.BasicTemplate.Count>0));
    //BasicMode := (GridInfo.BasicTemplate <> nil);
    FileNum := GridInfo.FileNum;
    IENS := GridInfo.IENS;
    CurrentData := GridInfo.Data;

    ClearGrid(Grid);
    Grid.ColWidths[0] := 50;
    Grid.ColWidths[1] := 200;
    Grid.ColWidths[2] := 300;
    Grid.Cells[0,0] := '#';
    Grid.Cells[1,0] := 'Name';
    Grid.Cells[2,0] := 'Value';

    if BasicMode=false then begin
      gridRow := 1;
      for i := 0 to CurrentData.Count-1 do begin
        oneEntry := CurrentData.Strings[i];
        //LoadOneLine (Grid,oneEntry,i);
        if LoadOneLine (Grid,oneEntry,gridRow) then begin
          Inc(GridRow);
        end;
        if LastRPCHadError then break;
      end;
    end else if BasicMode=true then begin
      gridRow := 1;
      for i := 0 to GridInfo.BasicTemplate.Count-1 do begin
        oneFileNum := Piece(GridInfo.BasicTemplate.Strings[i],'^',1);
        if oneFileNum <> fileNum then continue;
        oneFieldNum := Piece(GridInfo.BasicTemplate.Strings[i],'^',2);
        oneEntry := getOneLine(CurrentData,oneFileNum,oneFieldNum);
        if LoadOneLine (Grid,oneEntry,gridRow) then begin
          Inc(GridRow);
        end;
        if LastRPCHadError then break;
      end;
    end;
    GridInfo.LoadingGrid := false;
  end;

  procedure LoadAnyGrid(Grid : TSortStringGrid;  //the TSortStringGrid to load
                        //BasicMode: boolean;
                        BasicTemplate : TStringList;
                        FileNum : string;
                        IENS : string;
                        CurrentData : TStringList);
  var
    GridInfo : TGridInfo;
  begin
    //This stores load information into GridInfo.
    GridInfo := GetInfoObjectForGrid(Grid);
    if GridInfo = nil then exit;
    GridInfo.Grid := Grid;
    GridInfo.BasicTemplate := BasicTemplate;
    GridInfo.FileNum := FileNum;
    GridInfo.IENS := IENS;
    GridInfo.Data := CurrentData;
    LoadAnyGrid(GridInfo);
  end;

  procedure LoadAnyGrid(Grid: TSortStringGrid);
  begin
    LoadAnyGrid(GetInfoObjectForGrid(Grid));
  end;

  procedure LoadAnyGrid(Grid: TSortStringGrid; GridInfo : TGridInfo);
  var tempGridInfo : TGridInfo;
  begin
    if GridInfo.Grid = Grid then begin
      LoadAnyGrid(GridInfo);
    end else begin
      tempGridInfo := TGridInfo.Create;
      tempGridInfo.Assign(GridInfo);
      tempGridInfo.Grid := Grid;
      LoadAnyGrid(tempGridInfo);
      tempGridInfo.Free;
    end;
  end;


  function GetLineInfo(Grid : TSortStringGrid; CurrentUserData : TStringList; ARow: integer) : tFileEntry;
  var fieldNum : string;
      oneEntry : string;
      fileNum : string;
      gridRow : integer;
  begin
    fieldNum := Grid.Cells[0,ARow];
    gridRow := FindInStrings(fieldNum, CurrentUserData, fileNum);
    if gridRow > -1 then begin
      oneEntry := CurrentUserData.Strings[gridRow];
      Result.Field := fieldNum;
      Result.FieldName := Grid.Cells[1,ARow];
      Result.FileNum := fileNum;
      Result.IENS := Piece(oneEntry,'^',2);
      Result.oldValue := Piece(oneEntry,'^',4);
      Result.newValue := Grid.Cells[2,ARow];
    end else begin
      Result.Field := '';
      Result.FieldName := '';
      Result.FileNum := '';
      Result.IENS := '';
      Result.oldValue := '';
      Result.newValue := '';
    end;
  end;


  procedure CompileChanges(Grid : TSortStringGrid;
                           CurrentData : TStringList;
                           Changes : TStringList;   //This is out parameter
                           NewRecMode : boolean = false);
  //Output format:
  // FileNum^IENS^FieldNum^FieldName^newValue^oldValue
  //If NewRecMod = true, then ALL fields with values are returned as "changes"

  var row : integer;
      Entry : tFileEntry;
      oneEntry : string;
  begin
    Changes.Clear;
    for row := 1 to Grid.RowCount-1 do begin
      Entry := GetLineInfo(Grid,CurrentData, row);
      if (Trim(Entry.oldValue) <> Trim(Entry.newValue)) or NewRecMode then begin
        if (Entry.newValue <> COMPUTED_FIELD) and
          (Entry.newValue <> CLICK_TO_ADD_TEXT) and
          (Pos(CLICK_TO, Entry.newValue)=0) and
          (Pos(COMPUTED_FIELD, Entry.FieldName)=0)
        then begin
          oneEntry := Entry.FileNum + '^' + Entry.IENS + '^' + Entry.Field + '^' + Entry.FieldName;
          oneEntry := oneEntry + '^' + Entry.newValue + '^' + Entry.oldValue;
          Changes.Add(oneEntry);
        end;
      end;
    end;
  end;

  procedure CompileChangesEx(Grid : TSortStringGrid; CurrentData, Changes : TStringList);
  //Output format:
  // FileNum^IENS^FieldNum^FieldName^newValue^oldValue

  var row : integer;
      Entry : tFileEntry;
      oneEntry : string;
      iniFile : TIniFile; // 8-12-09   elh
      UCaseOnly : boolean;
      FINIFileName : string;  // 8-12-09   elh

  begin
    FINIFileName := ExtractFilePath(ParamStr(0)) + 'GUI_Config.ini';
    iniFile := TIniFile.Create(FINIFileName);            //8-12-09  elh
    UCaseOnly := inifile.ReadBool('Settings','UCaseOnly',true);
    iniFile.Free;
    for row := 1 to Grid.RowCount-1 do begin
      Entry := GetLineInfo(Grid, CurrentData, row);
      //Reject any value containing a "^"
      //Do we need an @ here as well?
      if AnsiPos('^',Entry.newvalue) > 0 then begin  //or (AnsiPos(':',Entry.newvalue) > 0) or  (AnsiPos(';',Entry.newvalue) > 0) //elh Taken out because : used in time
         messagedlg('Invalid value entered for ' + Entry.Fieldname + #13 + #10
                     + #13 + #10 + 'Invalid Entry:   ' + Entry.newvalue + #13 + #10 +
                     'Ignoring Value.',mtError,[mbOK],0);
      end else begin
        //if Entry.newValue = ' ' then Entry.newValue := '';
        Entry.newValue := Trim(Entry.newvalue);
        if Trim(Entry.oldValue) <> Entry.newValue then begin
          if (Entry.newValue <> COMPUTED_FIELD) and
            (Entry.newValue <> CLICK_TO_ADD_TEXT) and
            (Pos(CLICK_TO, Entry.newValue)=0)
          then begin
           oneEntry := Entry.FileNum + '^' + Entry.IENS + '^' + Entry.Field + '^' + Entry.FieldName;
           //Test to see if change is an AV Code (2 or 11) or ES Code (20.4) in User File (200)
           //If so, make it uppercase.       8/12/09   elh
           if Entry.FileNum = '200' then begin
              if ((Entry.Field = '2') and (UCaseOnly = true)) or
                 ((Entry.Field = '11') and (UCaseOnly = true)) or
                 ((Entry.Field = '20.4') and (UCaseOnly = true)) then begin
                 messagedlg('Converting ' + Entry.Fieldname + ' to uppercase for VistA interactivity.' +#13 +#10 +
                            #13 +#10 +
                            'Old Value: ' + Entry.newvalue + '  ' + 'New Value: ' + Uppercase(Entry.newvalue),
                            mtinformation,[mbOK],0);
                 Entry.newValue := Uppercase(Entry.newValue);
              end;
           end;
           oneEntry := oneEntry + '^' + Entry.newValue + '^' + Entry.oldValue;
           Changes.Add(oneEntry);
          end;
        end;
      end;
    end;
  end;


  function GetGridHint(Grid : TSortStringGrid; FileNum : string; ACol, ARow : integer) : string;
  var fieldNum : string;
      GridInfo : TGridInfo;
  begin
    Result := '';
    if ARow > Grid.RowCount-1 then exit;
    if (ARow < 1) or (ACol < 0) then exit;
    if ACol=0 then begin
      Result := 'This is the database field NUMBER';
    end else if ACol=1 then begin
      Result := 'This is the database field NAME';
    end else begin
      fieldNum := Grid.Cells[0,ARow];
      //if Grid.Cells[ACol,ARow]=CLICK_FOR_SUBS then begin
      //  result := 'Clicking will open new window...';
      //end else
      if Grid.Cells[ACol,ARow]=COMPUTED_FIELD then begin
        result := 'This field can''t be edited';
      end else if Grid.Cells[ACol,ARow]=HIDDEN_FIELD then begin
        result := 'Original value hidden.  Click to edit new value.';
    //end else if Grid.Cells[ACol,ARow]=CLICK_TO_EDIT_TEXT then begin
      end else if (Pos(CLICK_TO, Grid.Cells[ACol,ARow]) > 0) then begin
        result := 'Clicking will open new window...';
      end else begin
        GridInfo := GetInfoObjectForGrid(Grid);
        Result := FieldHelp(CachedHelp, CachedHelpIdx, FileNum,  GridInfo.IENS, fieldNum, '?');
      end;
    end;
  end;


  function PostChanges(Grid : TSortStringGrid; SilentMode : boolean; AddingNewRecord : boolean; var Posted : boolean) : TModalResult;
  //Results:  mrNone -- no post done (not needed)
  //          mrCancel -- user pressed cancel on confirmation screen.
  //          mrNo -- signals posting error.
  //Will trigger OnAfterPost event if GridInfo associated with Grid has assigned event handler.

  var PostResult  : TModalResult;
      CurrentData : TStringList;
      GridInfo    : TGridInfo;
      IENS        : string;
      Name        : string;
      PostForm    : TPostForm;

  begin
    Result := mrNone;  //default to No changes
    Posted := false;
    GridInfo := GetInfoObjectForGrid(Grid);
    if GridInfo=nil then exit;
    CurrentData := GridInfo.Data;
    if CurrentData=nil then exit;
    if CurrentData.Count = 0 then exit;
    IENS := GridInfo.IENS;
    if IENS='' then exit;
    PostForm:= TPostForm.Create(nil);
    try
      CompileChanges(Grid,CurrentData, Changes, AddingNewRecord);
      if Changes.Count>0 then begin
        if AddingNewRecord then begin
          //Changes Format --> FileNum^IENS^FieldNum^FieldName^newValue^oldValue
          Name := uTMGUtil.GetOneFldValue(Changes, GridInfo.FileNum, '.01', 5);
          if (Name = NEW_RECORD_TAG) or (Name = '') then begin
            MessageDlg('Can''t use ' + NEW_RECORD_TAG + ' for .01 field. ' + #10#13 +
                       'Please edit and retry.', mtError, [mbOK], 0);
            Result := mrCancel;
            exit;  //will still execute Finally block.
          end;
        end;
        if GridInfo.ReadOnly then begin
          MessageDlg('Sorry.  This record is marked as READ ONLY.' {+#13#10+
                     'Abandoning all changes'}, mtWarning, [mbOK],0);
          Result := mrCancel;
          exit;  //will still execute Finally block.
        end;
        if SilentMode then begin
          PostResult := PostForm.SilentPost(Changes);
        end else begin
          PostForm.PrepForm(Changes);
          PostResult := PostForm.ShowModal;
        end;
        if assigned(GridInfo.OnAfterPost) and PostForm.Posted then begin
          GridInfo.OnAfterPost(GridInfo, Changes);  //was Self.  I don't think Sender is used.
        end;
        if PostResult = mrOK then begin
          if Pos('+',IENS)>0 then begin
            GridInfo.IENS := PostForm.GetNewIENS(IENS);
          end;
          if assigned(GridInfo.DataLoadProc) then begin
            GridInfo.DataLoadProc(GridInfo);
          end;
        end;
        Result := PostResult;
      end else begin
        Result := mrNone;
      end;
    finally
      Posted := PostForm.Posted;
      PostForm.Free;
    end;
  end;

  function GetVisibleGridInfo : TGridInfo;
  begin
    result := GetInfoObjectForGrid(GetVisibleGrid);
  end;

  function GetVisibleGrid: TSortStringGrid;
  begin
    if VisibleGridIdx > -1 then begin
      result := TGridInfo(DataForGrid.Objects[VisibleGridIdx]).Grid;
    end else begin
      result := nil;
    end;
  end;

  procedure SetVisibleGridIdx(Grid : TSortStringGrid);
  begin
    VisibleGridIdx := GetInfoIndexForGrid(Grid);
  end;

  function PostVisibleGrid: TModalResult;
  var Posted: boolean;
  begin
    result := PostChanges(GetVisibleGrid, true, false, Posted);
  end;


  procedure DoRevert(BasicGrid, AdvancedGrid : TSortStringGrid);
  //BasicGrid doesn't have to be supplied.  Can be nil value.
  //AdvancedGrid is required.
  var tempInfo : TGridInfo;
  begin
    tempInfo := GetInfoObjectForGrid(AdvancedGrid);
    LoadAnyGrid(tempInfo);
    tempInfo.ApplyBtn.Enabled := false;
    tempInfo.RevertBtn.Enabled := false;

    if BasicGrid <> nil then begin
      tempInfo := GetInfoObjectForGrid(BasicGrid);
      LoadAnyGrid(tempInfo);
    end;
  end;

  procedure DoRevert(GridList : TList; AdvancedGrid : TSortStringGrid; Dummy : byte);
  //GridList doesn't have to be supplied.  Can be nil value.
  //AdvancedGrid is required, even if also included in GridList.
  //Dummy parameter to prevent ambigious overload.
  var i : integer;
      AGrid : TSortStringGrid;
      tempInfo : TGridInfo;
  begin
    DoRevert(nil, AdvancedGrid);
    if not assigned(GridList) then exit;
    for i := 0 to GridList.Count - 1 do begin
      AGrid := TSortStringGrid(GridList.Items[i]);
      if AGrid = AdvancedGrid then continue;
      tempInfo := GetInfoObjectForGrid(AGrid);
      LoadAnyGrid(tempInfo);
    end;
  end;


  function GetFieldEditHandler(FieldType : TFieldType; GridInfo : TGridInfo): THandleTableCellEdit;
  begin
    Result := nil;
    case FieldType of
      fmftDate:      begin
                       if assigned(GridInfo.DateFieldEditor) then Result := GridInfo.DateFieldEditor
                       else Result := HandleDateEdit;
                     end;
      fmftFreeText:  begin
                       if assigned(GridInfo.FreeTextFieldEditor) then begin
                         Result := GridInfo.FreeTextFieldEditor
                       end else begin
                         Result := HandleTextEdit;
                       end;
                     end;
      fmftPtr:       begin
                       if assigned(GridInfo.PtrFieldEditor) then begin
                         Result := GridInfo.PtrFieldEditor;
                       end else begin
                         Result := HandlePtrEdit;
                       end;
                     end;
      fmftVarPtr:    begin
                       if assigned(GridInfo.VarPtrFieldEditor) then Result := GridInfo.VarPtrFieldEditor
                       else Result := HandleVarPtrEdit;
                     end;
      fmftSet:       begin
                       if assigned(GridInfo.SetFieldEditor) then Result := GridInfo.SetFieldEditor
                       else Result := HandleSetEdit;
                     end;
      fmftNumber:    begin
                       if assigned(GridInfo.NumFieldEditor) then Result := GridInfo.NumFieldEditor
                       else Result := HandleNumEdit;
                     end;
      fmftWP:        begin
                       if assigned(GridInfo.WPFieldEditor) then Result := GridInfo.WPFieldEditor
                       else Result := HandleWPEdit;
                     end;
      fmftSubfile:   begin
                       if assigned(GridInfo.SubfileFieldEditor) then Result := GridInfo.SubfileFieldEditor
                       else Result := HandleSubFileEdit;
                     end;
    end; //case
  end;

  procedure GridSelectCellFromInfo(GridInfo : TGridInfo; ACol, ARow: Integer;
                           var CanSelect: Boolean;
                           LastSelTreeNode : TTreeNode;
                           var AutoPressEditButtonInDetailDialog : boolean);
    (*
    For Field def, here is the legend
    character     meaning

    + = supported

    +BC 	        The data is Boolean Computed (true or false).
    +C 	          The data is Computed.
    +Cm 	        The data is multiline Computed.
    +DC 	        The data is Date-valued, Computed.
    +D 	          The data is Date-valued.
    +F 	          The data is Free text.
    +I 	          The data is uneditable.
    +Pn 	        The data is a Pointer reference to file "n".
    +S 	          The data is from a discrete Set of codes.

    N 	          The data is Numeric-valued.

    Jn 	          To specify a print length of n characters.
    Jn,d 	        To specify printing n characters with decimals.

    V 	          The data is a Variable pointer.
    +W 	          The data is Word processing.
    WL 	          The Word processing data is normally printed in Line mode (i.e., without word wrap).
      *)
  var oneEntry,FieldDef : string;
      FileNum,TargetFileNum, FieldNum,SubFileNum : string;
      Grid : TSortStringGrid;
      IEN : int64;
      IENS : string;
      CurrentData : TStringList;
      //GridInfo : TGridInfo;
      VarPtrInfo : TStringList;
      FieldType : TFieldType;
      Changed : boolean;
      NewValue, InitValue : string;
      ExtraInfo : string;
      Index : integer;
      Fields, Identifier : string;
      FieldEditHandler : THandleTableCellEdit;

  begin
    //Grid := (Sender as TSortStringGrid);
    //GridInfo := GetInfoObjectForGrid(Grid);
    if GridInfo=nil then exit;
    if GridInfo.LoadingGrid then exit;  //prevent pseudo-clicks during loading...
    Grid := GridInfo.Grid;  //kt
    FileNum := GridInfo.FileNum;
    CanSelect := false;  //default to NOT selectable.
    CurrentData := GridInfo.Data;
    if CurrentData=nil then exit;
    if CurrentData.Count = 0 then exit;
    CanSelect := True;
    FieldNum := Grid.Cells[0,ARow];
    FieldType := GridInfo.FieldType(FieldNum);
    oneEntry := GridInfo.DDInfo(FieldNum);
    FieldDef := GridInfo.FldInfo(FieldNum);
    InitValue := Grid.Cells[ACol,ARow];
    NewVAlue := InitValue;
    IENS := GridInfo.IENS;
    FieldEditHandler := GetFieldEditHandler(FieldType, GridInfo);

    case FieldType of
      //----------------------------------------------
      fmftNone, fmftComputed:
        begin
          CanSelect := false;  //redundant
        end;
      //----------------------------------------------
      fmftDate:  //Date
        begin
          NewValue := FieldEditHandler(InitValue, FileNum, IENS, FieldNum, GridInfo, Changed, CanSelect);
        end;
      //----------------------------------------------
      fmftFreeText:   //Free Text
        begin
          NewValue := FieldEditHandler(InitValue, FileNum, IENS, FieldNum,
                                     GridInfo, Changed, CanSelect,
                                     Grid.Cells[ACol-1,ARow]);
        end;
      //----------------------------------------------
      fmftUneditable:  //Uneditable
        begin
          MessageDlg('Sorry. Flagged as UNEDITABLE.',mtInformation ,[mbOK],0);
        end;
      //----------------------------------------------
      fmftPtr:   //Pointer to file.
        begin
          ExtraInfo := ExtractNum (FieldDef,Pos('P',FieldDef)+1) + EXTRA_INFO_PIECE_DIV +
                       BoolToStr(AutoPressEditButtonInDetailDialog);
          TargetFileNum := piece2(ExtraInfo, EXTRA_INFO_PIECE_DIV, 1);
          Index := GridInfo.CustomPtrFieldEditors.IndexOf(TargetFileNum);
          if Index >= 0 then begin
            FieldEditHandler := THandleTableCellEdit(GridInfo.CustomPtrFieldEditors.Objects[Index]);
          end;
          NewValue := FieldEditHandler(InitValue, FileNum, IENS, FieldNum,
                                    GridInfo, Changed, CanSelect, ExtraInfo);
          AutoPressEditButtonInDetailDialog := false;
        end;
      //----------------------------------------------
      fmftVarPtr:  //Variable Pointer to file.
        begin
          ExtraInfo := ExtractNum (FieldDef,Pos('P',FieldDef)+1) + EXTRA_INFO_PIECE_DIV +
                       BoolToStr(AutoPressEditButtonInDetailDialog);
          VarPtrInfo := TStringList.Create;
          GridInfo.ExtractVarPtrInfo(FieldNum, VarPtrInfo);
          NewValue := FieldEditHandler(InitValue, FileNum, IENS, FieldNum,
                                       GridInfo, Changed, CanSelect,
                                       BoolToStr(AutoPressEditButtonInDetailDialog),
                                       VarPtrInfo);
          VarPtrInfo.Free;
          AutoPressEditButtonInDetailDialog := false;
        end;
      //----------------------------------------------
      fmftSet:  //Set of Codes
        begin
          ExtraInfo := Piece(oneEntry,'^',7);
          NewValue := FieldEditHandler(InitValue, FileNum, IENS, FieldNum,
                                       GridInfo, Changed, CanSelect, ExtraInfo);
        end;
      //----------------------------------------------
      fmftNumber:  //Numeric value
        begin
          ExtraInfo := FieldDef + EXTRA_INFO_PIECE_DIV + Grid.Cells[ACol-1,ARow];
          NewValue := FieldEditHandler(InitValue, FileNum, IENS, FieldNum,
                                       GridInfo, Changed, CanSelect, ExtraInfo);
        end;
      //----------------------------------------------
      fmftWP:  //Word Processor field
        begin
          NewValue := FieldEditHandler(InitValue, FileNum, IENS, FieldNum, GridInfo, Changed, CanSelect);
        end;
      //----------------------------------------------
      fmftSubfile: //Subfiles.
        begin
          SubFileNum := GridInfo.SubfileNum(FieldNum);
          // IENS := '';
          if GridInfo.MessageStr = MSG_SUB_FILE then begin  //used message from subfile Grid
            IENS := GridInfo.IENS;
          end else if LastSelTreeNode <> nil then begin  //this is one of the selection trees.
            IEN := longInt(LastSelTreeNode.Data);
            if IEN > 0 then IENS := InttoStr(IEN) + ',';
          end else if Assigned(GridInfo.RecordSelector) then begin
            IENS := GridInfo.RecordSelector; //get info from selected record
          end;
          if IENS <> '' then begin
            Fields := GridInfo.Fields;
            Identifier := GridInfo.IdentifierCode;
            NewValue := FieldEditHandler(InitValue, SubFileNum, IENS, FieldNum,
                                          GridInfo, Changed, CanSelect,
                                          '',nil, Fields, Identifier);
          end else begin
            MessageDlg('IENS for File="".  Can''t process.',mtInformation,[MBOK],0);
          end;
        end;
      //----------------------------------------------
    end; //case
    if NewValue <> InitValue then begin
      Grid.Cells[ACol,ARow] := NewValue;
    end;
    if Assigned(GridInfo.ApplyBtn) then GridInfo.ApplyBtn.Enabled := true;
    if Assigned(GridInfo.RevertBtn) then GridInfo.RevertBtn.Enabled := true;
  end;

  procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
                           var CanSelect: Boolean;
                           LastSelTreeNode : TTreeNode;
                           var AutoPressEditButtonInDetailDialog : boolean);
  var
    GridInfo : TGridInfo;
    Grid : TSortStringGrid;
  begin
    Grid := (Sender as TSortStringGrid);
    GridInfo := GetInfoObjectForGrid(Grid);
    GridSelectCellFromInfo(GridInfo, ACol, ARow, CanSelect, LastSelTreeNode, AutoPressEditButtonInDetailDialog);
  end;

  //kt 12/18/13
  procedure GridSelectCell2(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  begin
    GridSelectCell(Sender,  ACol, ARow, CanSelect, LastSelTreeNode,
                   TMG_Auto_Press_Edit_Button_In_Detail_Dialog);
  end;

  //kt 12/18/13
  procedure ExternalSelectGridCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  begin
     GridSelectCell2(Sender, ACol, ARow, CanSelect);
  end;

  procedure ExternalGridSelectCell(GridInfo : TGridInfo; ACol, ARow: Integer; var CanSelect: Boolean);
  var AutoPressEditButtonInDetailDialog : boolean;
  begin
    AutoPressEditButtonInDetailDialog := false;
    GridSelectCellFromInfo(GridInfo, ACol, ARow, CanSelect, nil, AutoPressEditButtonInDetailDialog);
  end;


  //-----------------
  //-----------------


  function HandleDateEdit(InitValue, FileNum, IENS, FieldNum : string;
                          GridInfo : TGridInfo;
                          var Changed, CanSelect : boolean;
                          ExtraInfo : string;
                          ExtraInfoSL : TStringList;
                          Fields : string;
                          Identifier : string) : string;
  var date,time : string;
      FormResult : integer;
      EditDateTimeForm: TEditDateTimeForm;

  begin
    Result := InitValue;
    EditDateTimeForm := TEditDateTimeForm.Create(nil);
    date := piece(InitValue,'@',1);
    time := piece(InitValue,'@',2);
    if date <> '' then begin
      EditDateTimeForm.DateTimePicker.Date := StrToDate(date);
    end else begin
      EditDateTimeForm.DateTimePicker.Date := SysUtils.Date;
    end;
    FormResult := EditDateTimeForm.ShowModal;
    if FormResult = mrOK then begin
      date := DateToStr(EditDateTimeForm.DateTimePicker.Date);
      time := TimeToStr(EditDateTimeForm.DateTimePicker.Time);
      if time <> '' then date := date; // + '@' + time;    elh 8/15/08
      Result := date;
    end else if FormResult = mrNo then begin  //Signal for None
      Result := '';   //redundant
    end;
    CanSelect := true;
    EditDateTimeForm.Free;
  end;

  function HandleTextEdit(InitValue, FileNum, IENS, FieldNum : string;
                          GridInfo : TGridInfo;
                          var Changed, CanSelect : boolean;
                          ExtraInfo : string; ExtraInfoSL : TStringList;
                          Fields : string;
                          Identifier : string) : string;
  var
    EditFreeTextForm: TEditFreeTextForm;

  begin
    Result := InitValue;
    EditFreeTextForm := TEditFreeTextForm.Create(nil);
    EditFreeTextForm.TextToEdit.Text := InitValue;
    EditFreeTextForm.Caption := 'Edit: ' + ExtraInfo;
    if EditFreeTextForm.ShowModal = mrOK then begin
      Result := EditFreeTextForm.TextToEdit.Text;
      CanSelect := true;
    end;
    EditFreeTextForm.Free;
  end;

  function HandlePtrEdit(InitValue, FileNum, IENS, FieldNum : string;
                          GridInfo : TGridInfo;
                          var Changed, CanSelect : boolean;
                          ExtraInfo : string; ExtraInfoSL : TStringList;
                          Fields : string;
                          Identifier : string) : string;
  var
    TargetFileNum, tempS : string;
    FieldLookupForm: TFieldLookupForm;

  begin
    Result := InitValue;
    TargetFileNum := piece2(ExtraInfo, EXTRA_INFO_PIECE_DIV, 1);
    tempS := piece2(ExtraInfo, EXTRA_INFO_PIECE_DIV, 2);  //boolean
    FieldLookupForm:= TFieldLookupForm.Create(Nil);
    FieldLookupForm.PrepForm(TargetFileNum, InitValue, FileNum, FieldNum);
    FieldLookupForm.Auto_Press_Edit_Button := StrToBoolDef(tempS, false);
    if FieldLookupForm.ShowModal = mrOK then begin
      Result := FieldLookupForm.SelectedValue;
      CanSelect := true;
    end;
    GridInfo.DisplayRefreshIndicated := FieldLookupForm.ChangesMade;
    Changed := FieldLookupForm.ChangesMade;
    FreeAndNil(FieldLookupForm);
  end;

  function HandleVarPtrEdit(InitValue, FileNum, IENS, FieldNum : string;
                            GridInfo : TGridInfo;
                            var Changed, CanSelect : boolean;
                            ExtraInfo : string; ExtraInfoSL : TStringList;
                            Fields : string;
                            Identifier : string) : string;
  var
    FieldLookupForm: TFieldLookupForm;
    VarPtrInfo : TStringList;

  begin
    Result := InitValue;
    VarPtrInfo := ExtraInfoSL;
    FieldLookupForm:= TFieldLookupForm.Create(Nil);
    FieldLookupForm.PrepFormAsMultFile(VarPtrInfo, InitValue , FileNum, FieldNum);
    FieldLookupForm.Auto_Press_Edit_Button := StrToBoolDef(ExtraInfo, False);
    if FieldLookupForm.ShowModal = mrOK then begin
      Result := FieldLookupForm.SelectedValue;
      CanSelect := true;
    end;
    GridInfo.DisplayRefreshIndicated := FieldLookupForm.ChangesMade;
    Changed := FieldLookupForm.ChangesMade;
    FreeAndNil(FieldLookupForm);
  end;


  function HandleSetEdit(InitValue, FileNum, IENS, FieldNum : string;
                         GridInfo : TGridInfo;
                         var Changed, CanSelect : boolean;
                         ExtraInfo : string; ExtraInfoSL : TStringList;
                         Fields : string;
                         Identifier : string) : string;
  var
    SetSelForm: TSetSelForm;
  begin
    Result := InitValue;
    SetSelForm := TSetSelForm.Create(nil);
    SetSelForm.PrepForm(ExtraInfo, InitValue);
    if SetSelForm.ShowModal = mrOK then begin
      Result := SetSelForm.SelectedValue;
      CanSelect := true;
    end;
    SetSelForm.Free;
  end;

  function HandleNumEdit(InitValue, FileNum, IENS, FieldNum : string;
                         GridInfo : TGridInfo;
                         var Changed, CanSelect : boolean;
                         ExtraInfo : string; ExtraInfoSL : TStringList;
                         Fields : string;
                         Identifier : string) : string;

  var FieldDef, FldName : string;
      EditNumber: TEditNumber;

  begin
    Result := InitValue;
    EditNumber := TEditNumber.Create(nil);
    FieldDef := piece2(ExtraInfo, EXTRA_INFO_PIECE_DIV, 1);
    FldName :=piece2(ExtraInfo, EXTRA_INFO_PIECE_DIV, 2);
    EditNumber.Initialize(FieldDef);
    EditNumber.NumToEdit.Text := InitValue;
    EditNumber.Caption := 'Edit: ' + FldName;
    if EditNumber.ShowModal = mrOK then begin
      Result := EditNumber.NumToEdit.Text;
    end;
    EditNumber.Free;
  end;

  function HandleWPEdit(InitValue, FileNum, IENS, FieldNum : string;
                        GridInfo : TGridInfo;
                        var Changed, CanSelect : boolean;
                        ExtraInfo : string; ExtraInfoSL : TStringList;
                        Fields : string;
                        Identifier : string) : string;
  var
    EditWPTextForm: TEditTextForm;
  begin
    Result := InitValue;
    EditWPTextForm := TEditTextForm.Create(nil);
    EditWPTextForm.PrepForm(FileNum, FieldNum, IENS);
    EditWPTextForm.ShowModal;
    Result := EditWPTextForm.GetPreviewText;
    if assigned(GridInfo.OnAfterPost) and EditWPTextForm.Posted then begin
      GridInfo.OnAfterPost(GridInfo, Nil);
    end;
    GridInfo.DisplayRefreshIndicated := EditWPTextForm.ChangesMade;
    EditWPTextForm.Free;

  end;

  function HandleSubFileEdit(InitValue, FileNum, IENS, FieldNum : string;
                             GridInfo : TGridInfo;
                             var Changed, CanSelect : boolean;
                             ExtraInfo : string; ExtraInfoSL : TStringList;
                             Fields : string;
                             Identifier : string) : string;
  var
    SubFileForm : TfrmMultiRecEdit;
  begin
    Result := InitValue;
    SubFileForm := TfrmMultiRecEdit.Create(nil);
    SubFileForm.PrepForm(FileNum,IENS,Fields, Identifier, GridInfo.CustomPtrFieldEditors);
    SubFileForm.ParentEditForm.RecType := ActivePopupEditForm.RecType;
    SubFileForm.ParentEditForm.EditForm := ActivePopupEditForm.EditForm;
    ActivePopupEditForm.RecType := vpefSubFile;
    ActivePopupEditForm.EditForm := SubFileForm;
    SubfileForm.ShowModal;  // note: may call this function again recursively for sub-sub-files etc.
    GridInfo.DisplayRefreshIndicated := GridInfo.DisplayRefreshIndicated or SubfileForm.ChangesMade;
    Result := fMultiRecEditU.GetPreviewText(FileNum, IENS);
    if assigned(GridInfo.OnAfterPost) and SubFileForm.Posted then begin
      GridInfo.OnAfterPost(GridInfo, Nil);
    end;
    ActivePopupEditForm.RecType := vpef(SubFileForm.ParentEditForm.RecType);
    ActivePopupEditForm.EditForm := SubFileForm.ParentEditForm.EditForm;
    FreeAndNil(SubFileForm);
  end;

  //-----------------
  //-----------------

  procedure GetRecordsInfoAndLoadIntoGrids(GridInfo : TGridInfo; GridList : TList; CmdName : string='');
  //Purpose: Get all fields from server for one record.
  //Data is an OUT parameter.
  var RPCStringsResult : TStrings;
      temp : boolean;
      i : integer;
      IENS : string;
      AGrid : TSortStringGrid;
      AGridInfo : TGridInfo;
      AllowedGridIndexes : set of byte;
      GridFilter : string;
      FilteringList : boolean;

      procedure ParseGridFilter(s : string);
      //format GRID_FILTER^<AllowedIndexFromGridList>^<AllowedIndexFromGridList>^<AllowedIndexFromGridList>...
      var i, Val : integer;
          OneIndex : string;
      begin
        for i := 2 to NumPieces(s, '^') do begin
          OneIndex := piece(s,'^',i);       if OneIndex = '' then continue;
          Val := StrToIntDef(OneIndex,-1);  if Val = -1 then continue;
          AllowedGridIndexes := AllowedGridIndexes + [Val];
        end;
      end;

  var PriorCursor : TCursor;
  begin
    PriorCursor := GetCursorImage;
    SetCursorImage(crHourGlass);
    IENS := GridInfo.IENS;
    GridFilter := ''; FilteringList := false;
    if Pos(GRID_FILTER, CmdName)>0 then begin
      GridFilter := CmdName;
      CmdName := '';
      ParseGridFilter(GridFilter);
      FilteringList := true;
    end;
    //if CmdName = '' then CmdName := 'GET ONE RECORD';
    for i := 0 to GridList.Count - 1 do begin
      AGrid := TSortStringGrid(GridList.Items[i]);
      ClearGrid(AGrid);
      AGridInfo := GetInfoObjectForGrid(AGrid);
      if AGridInfo = nil then continue;
      if AGridInfo.Data = nil then continue;
      AGridInfo.Data.Clear;
      AGridInfo.IENS := IENS;
      AGridInfo.ReadOnly := GridInfo.ReadOnly;
    end;
    if GridInfo.IENS <> '0,' then begin
      temp := RPCGetRecordInfo(RPCStringsResult, GridInfo.FileNum, GridInfo.IENS, CmdName);
      if temp = true then begin
        //NOTE: must save RPCStringsResult to each GridInfo before any other server calls.
        for i := 0 to GridList.Count - 1 do begin
          if FilteringList and not (i in AllowedGridIndexes) then continue;
          AGrid := TSortStringGrid(GridList.Items[i]);
          AGridInfo := GetInfoObjectForGrid(AGrid);
          if AGridInfo = nil then continue;
          if AGridInfo.Data = nil then continue;
          AGridInfo.Data.Assign(RPCStringsResult);
        end;
        for i := 0 to GridList.Count - 1 do begin
          if FilteringList and not (i in AllowedGridIndexes) then continue;
          AGrid := TSortStringGrid(GridList.Items[i]);
          AGridInfo := GetInfoObjectForGrid(AGrid);
          if AGridInfo = nil then continue;
          LoadAnyGrid(AGrid,AGridInfo);
          AGridInfo.ApplyBtn.Enabled := false;
          AGridInfo.RevertBtn.Enabled := false;
        end;
      end;
    end;
    SetCursorImage(PriorCursor);
  end;


  procedure InitUsersTemplateStuff(BasicTemplate : TStringList);
  begin
    BasicTemplate.Add('200^.01');  //Name
    BasicTemplate.Add('200^1');    //initials
    BasicTemplate.Add('200^13');   //Nickname
    BasicTemplate.Add('200^10.6'); //Degree
    BasicTemplate.Add('200^53.2'); //DEA#
    BasicTemplate.Add('200^2');    //Access Code
    BasicTemplate.Add('200^11');   //Verify Code
    BasicTemplate.Add('200^7');    //DISUSER
    BasicTemplate.Add('200^20.2'); //Signature block printed name
    BasicTemplate.Add('200^20.3'); //Signature block title
    BasicTemplate.Add('200^20.4'); //Electronic signature code
    BasicTemplate.Add('200^51');   //Keys
    BasicTemplate.Add('200^8932.1');//Person class
    BasicTemplate.Add('200^53.5'); //Provider class
    BasicTemplate.Add('200^53.7'); //Requires cosigner
    BasicTemplate.Add('200^53.8'); //Usually cosigner
    BasicTemplate.Add('200^101.13'); //CPRS TAb
    BasicTemplate.Add('200^200.1');//Timed read #sec
    BasicTemplate.Add('200^201');  //Primary menu option
  end;

  procedure InitSettingsFilesTemplateStuff(BasicTemplate : TStringList);
  begin
    // -- KERNEL SYSTEM PARAMETERS
    BasicTemplate.Add('8989.3^.01');  // DOMAIN NAME
    BasicTemplate.Add('8989.3^202');  // DEFAULT # OF ATTEMPTS
    BasicTemplate.Add('8989.3^203');  // DEFAULT LOCK-OUT TIME
    BasicTemplate.Add('8989.3^204');  // DEFAULT MULTIPLE SIGN-ON
    BasicTemplate.Add('8989.3^205');  // ASK DEVICE TYPE AT SIGN-ON
    BasicTemplate.Add('8989.3^206');  // DEFAULT AUTO-MENU
    BasicTemplate.Add('8989.3^207');  // DEFAULT LANGUAGE
    BasicTemplate.Add('8989.3^209');  // DEFAULT TYPE-AHEAD
    BasicTemplate.Add('8989.3^210');  // DEFAULT TIMED-READ (SECONDS)
    BasicTemplate.Add('8989.3^214');  // LIFETIME OF VERIFY CODE
    BasicTemplate.Add('8989.3^217');  // DEFAULT INSTITUTION
    BasicTemplate.Add('8989.3^218');  // DEFAULT AUTO SIGN-ON
    BasicTemplate.Add('8989.3^219');  // DEFAULT MULTIPLE SIGN-ON LIMIT
    BasicTemplate.Add('8989.3^230');  // BROKER ACTIVITY TIMEOUT
    BasicTemplate.Add('8989.3^240');  // INTRO MESSAGE
    BasicTemplate.Add('8989.3^245');  // POST SIGN-IN MESSAGE
    BasicTemplate.Add('8989.3^320');  // DEFAULT DIRECTORY FOR HFS
    BasicTemplate.Add('8989.3^501');  // PRODUCTION account

    // -- HOSPITAL LOCATION
    BasicTemplate.Add('44^.01');   //  NAME
    BasicTemplate.Add('44^1');     //  ABBREVIATION
    BasicTemplate.Add('44^2');     //  TYPE
    BasicTemplate.Add('44^2.1');   //  TYPE EXTENSION
    BasicTemplate.Add('44^3');     //  INSTITUTION
    BasicTemplate.Add('44^3.5');   //  DIVISION
    BasicTemplate.Add('44^5');     //  DEFAULT DEVICE
    BasicTemplate.Add('44^9');     //  SERVICE
    BasicTemplate.Add('44^9.5');   //  TREATING SPECIALTY
    BasicTemplate.Add('44^10');    //  PHYSICAL LOCATION
    BasicTemplate.Add('44^15');    //  CATEGORY OF VISIT
    BasicTemplate.Add('44^16');    //  DEFAULT PROVIDER
    BasicTemplate.Add('44^23');    //  AGENCY
    BasicTemplate.Add('44^29');    //  CLINIC SERVICES RESOURCE
    BasicTemplate.Add('44^99');    //  TELEPHONE
    BasicTemplate.Add('44^101');   //  ASSOCIATED LOCATION TYPES
    BasicTemplate.Add('44^1916');  //  PRINCIPAL CLINIC
    BasicTemplate.Add('44^2505');  //  INACTIVATE DATE
    BasicTemplate.Add('44^2506');  //  REACTIVATE DATE
    BasicTemplate.Add('44^2507');  //  DEFAULT APPOINTMENT TYPE
    BasicTemplate.Add('44^2508');  //  NO SHOW LETTER
    BasicTemplate.Add('44^2509');  //  PRE-APPOINTMENT LETTER
    BasicTemplate.Add('44^2510');  //  CLINIC CANCELLATION LETTER
    BasicTemplate.Add('44^2511');  //  APPT. CANCELLATION LETTER
    BasicTemplate.Add('44^2600');  //  PROVIDER
    BasicTemplate.Add('44^2700');  //  DIAGNOSIS
    BasicTemplate.Add('44^2801');  //  DEFAULT TO PC PRACTITIONER?

    // --  RPC BROKER SITE PARAMETERS
    BasicTemplate.Add('8994.1^.01');  //  DOMAIN NAME
    BasicTemplate.Add('8994.1^2');    //  MAIL GROUP FOR ALERTS
    BasicTemplate.Add('8994.1^7');    //  LISTENER

    // -- DEVICE file
    BasicTemplate.Add('3.5^.01');     //  NAME
    BasicTemplate.Add('3.5^.02');     //  LOCATION OF TERMINAL
    BasicTemplate.Add('3.5^.03');     //  MNEMONIC
    BasicTemplate.Add('3.5^.04');     //  LOCAL SYNONYM
    BasicTemplate.Add('3.5^1');       //  $I
    BasicTemplate.Add('3.5^1.95');    //  SIGN-ON/SYSTEM DEVICE
    BasicTemplate.Add('3.5^2');       //  TYPE
    BasicTemplate.Add('3.5^3');       //  SUBTYPE
    BasicTemplate.Add('3.5^5.5');     //  QUEUING
    BasicTemplate.Add('3.5^6');       //  OUT-OF-SERVICE DATE
    BasicTemplate.Add('3.5^7');       //  NEAREST PHONE
    BasicTemplate.Add('3.5^8');       //  KEY OPERATOR
    BasicTemplate.Add('3.5^9');       //  MARGIN WIDTH
    BasicTemplate.Add('3.5^11');      //  PAGE LENGTH
    BasicTemplate.Add('3.5^16');      //  CLOSEST PRINTER
    BasicTemplate.Add('3.5^19');      //  OPEN PARAMETERS
    BasicTemplate.Add('3.5^19.3');    //  CLOSE PARAMETERS
    BasicTemplate.Add('3.5^19.5');    //  USE PARAMETERS
    BasicTemplate.Add('3.5^19.7');    //  PRE-OPEN EXECUTE
    BasicTemplate.Add('3.5^19.8');    //  POST-CLOSE EXECUTE
    BasicTemplate.Add('3.5^27');      //  PASSWORD
    BasicTemplate.Add('3.5^51.5');    //  ASK DEVICE TYPE AT SIGN-ON
    BasicTemplate.Add('3.5^51.6');    //  AUTO MENU
    BasicTemplate.Add('3.5^51.9');    //  TYPE-AHEAD

    // -- PATIENT file
    BasicTemplate.Add('2^.01');       //  NAME
    BasicTemplate.Add('2^.02');       //  SEX
    BasicTemplate.Add('2^.03');       //  DATE OF BIRTH
    BasicTemplate.Add('2^.05');       //  MARITAL STATUS
    BasicTemplate.Add('2^.06');       //  RACE
    BasicTemplate.Add('2^.07');       //  OCCUPATION
    BasicTemplate.Add('2^.08');       //  RELIGIOUS PREFERENCE
    BasicTemplate.Add('2^.09');       //  SOCIAL SECURITY NUMBER
    BasicTemplate.Add('2^.091');      //  REMARKS
    BasicTemplate.Add('2^.092');      //  PLACE OF BIRTH [CITY]
    BasicTemplate.Add('2^.093');      //  PLACE OF BIRTH [STATE]
    BasicTemplate.Add('2^.096');      //  WHO ENTERED PATIENT
    BasicTemplate.Add('2^.097');      //  DATE ENTERED INTO FILE
    BasicTemplate.Add('2^.098');      //  HOW WAS PATIENT ENTERED?
    BasicTemplate.Add('2^.103');      //  TREATING SPECIALTY
    BasicTemplate.Add('2^.104');      //  PROVIDER
    BasicTemplate.Add('2^.1041');     //  ATTENDING PHYSICIAN
    BasicTemplate.Add('2^.111');      //  STREET ADDRESS [LINE 1]
    BasicTemplate.Add('2^.1112');     //  ZIP+4
    BasicTemplate.Add('2^.112');      //  STREET ADDRESS [LINE 2]
    BasicTemplate.Add('2^.113');      //  STREET ADDRESS [LINE 3]
    BasicTemplate.Add('2^.114');      //  CITY
    BasicTemplate.Add('2^.115');      //  STATE
    BasicTemplate.Add('2^.116');      //  ZIP CODE
    BasicTemplate.Add('2^.117');      //  COUNTY
    BasicTemplate.Add('2^.131');      //  PHONE NUMBER [RESIDENCE]
    BasicTemplate.Add('2^.132');      //  PHONE NUMBER [WORK]
    BasicTemplate.Add('2^.133');      //  PHONE [CELL}
    BasicTemplate.Add('2^.2401');     //  FATHER'S NAME
    BasicTemplate.Add('2^.2402');     //  MOTHER'S NAME
    BasicTemplate.Add('2^.2403');     //  MOTHER'S MAIDEN NAME
    BasicTemplate.Add('2^994');       //  MULTIPLE BIRTH INDICATOR
    BasicTemplate.Add('2^1901');      //  VETERAN (Y/N)?
  end;


  procedure InitRemDlgTemplate(DlgTemplate : TStringList);
  begin
    DlgTemplate.Add('801.41^.01');
    DlgTemplate.Add('801.41^3');
    DlgTemplate.Add('801.41^100');     //class
    DlgTemplate.Add('801.41^101');     //sponsor
    DlgTemplate.Add('801.41^102');     //review date
    DlgTemplate.Add('801.41^2');
    DlgTemplate.Add('801.41^112');
    DlgTemplate.Add('801.41^10');      //Components
  end;

  procedure InitDlgElementTemplate(DlgElementTemplate : TStringList);
  begin
    DlgElementTemplate.Add('801.41^.01'); //Name
    DlgElementTemplate.Add('801.41^3');   //Disable
    DlgElementTemplate.Add('801.41^100'); //Class
    DlgElementTemplate.Add('801.41^101'); //Sponsor
    DlgElementTemplate.Add('801.41^102'); //Review Date
    DlgElementTemplate.Add('801.41^13');  //resolution type
    DlgElementTemplate.Add('801.41^15');  //Finding item
    DlgElementTemplate.Add('801.41^17');  //orderable item
    DlgElementTemplate.Add('801.41^14');  //finding item
    DlgElementTemplate.Add('801.41^18');  //additional finding
    DlgElementTemplate.Add('801.41^25');  //dialog progress note text
    DlgElementTemplate.Add('801.41^35');  //alternative progress note text
    DlgElementTemplate.Add('801.41^23');  //Exclude from progress note
    DlgElementTemplate.Add('801.41^51');  //Suppress checkboxx
    DlgElementTemplate.Add('801.41^10');  //Components
    DlgElementTemplate.Add('801.41^116'); //Reminder term
  end;

  procedure InitDlgPromptTemplate(DlgPromptTemplate : TStringList);
  begin
    DlgPromptTemplate.Add('801.41^.01');  //Name
    DlgPromptTemplate.Add('801.41^3');    //Disable
    DlgPromptTemplate.Add('801.41^100');  //Class
    DlgPromptTemplate.Add('801.41^101');  //Sponsor
    DlgPromptTemplate.Add('801.41^102');  //Review Date
    DlgPromptTemplate.Add('801.41^24');   //Prompt Caption
    DlgPromptTemplate.Add('801.41^23');  //Exclude from progress note
    DlgPromptTemplate.Add('801.41^21');  //Default Value
    DlgPromptTemplate.Add('801.41^45');  //Checkbox Sequence
    DlgPromptTemplate.Add('801.41^10');  //Edit History
  end;

  procedure InitDlgForcedVTemplate(DlgForcedVTemplate : TStringList);
  begin
    DlgForcedVTemplate.Add('801.41^.01'); //Name
    DlgForcedVTemplate.Add('801.41^3');   //Disable
    DlgForcedVTemplate.Add('801.41^100'); //Class
    DlgForcedVTemplate.Add('801.41^101'); //Sponsor
    DlgForcedVTemplate.Add('801.41^102'); //Review Date
    DlgForcedVTemplate.Add('801.41^22'); //Forced Value
    //Can't find entry for: RESTRICTED TO FINDING TYPE
  end;

  procedure InitDlgGroupTemplate(DlgGroupTemplate : TStringList);
  begin
    DlgGroupTemplate.Add('801.41^.01');   //Name
    DlgGroupTemplate.Add('801.41^3');     //Disable
    DlgGroupTemplate.Add('801.41^100');   //Class
    DlgGroupTemplate.Add('801.41^101');   //Sponsor
    DlgGroupTemplate.Add('801.41^102');   //Review Date
    DlgGroupTemplate.Add('801.41^13');  //Resolution type
    DlgGroupTemplate.Add('801.41^17');  //orderable item
    DlgGroupTemplate.Add('801.41^15');  //Finding item
    DlgGroupTemplate.Add('801.41^18');  //Additional finding
    DlgGroupTemplate.Add('801.41^5');   //Caption
    DlgGroupTemplate.Add('801.41^6');   //Box -- put a box around the group
    DlgGroupTemplate.Add('801.41^8');   //Share Common Prompts
    DlgGroupTemplate.Add('801.41^9');   //group entry -- 'MULTIPLE SELECTION'
    DlgGroupTemplate.Add('801.41^50');  //Hide show group
    DlgGroupTemplate.Add('801.41^25');  //Dialog/Progress Note Text -- 'GROUP HEADER DIALOG TEXT'
    DlgGroupTemplate.Add('801.41^35');  //Alternative PN text -- 'GROUP HEADER ALTERNATIVE P/N TEXT'
    DlgGroupTemplate.Add('801.41^23');  //Exclude from PN
    DlgGroupTemplate.Add('801.41^51');  //Suppress checkbox
    DlgGroupTemplate.Add('801.41^7');   //Number of indents
    DlgGroupTemplate.Add('801.41^52');  //Indent progress note text
    DlgGroupTemplate.Add('801.41^10');  //Components
    DlgGroupTemplate.Add('801.41^116'); //Reminder term
  end;

  procedure InitDlgRsltGroupTemplate(DlgRsltGroupTemplate : TStringList);
  begin
    DlgRsltGroupTemplate.Add('801.41^.01');  //Name
    DlgRsltGroupTemplate.Add('801.41^3');    //Disable
    DlgRsltGroupTemplate.Add('801.41^100');  //Class
    DlgRsltGroupTemplate.Add('801.41^101');  //Sponsor
    DlgRsltGroupTemplate.Add('801.41^102');  //Review Date
    DlgRsltGroupTemplate.Add('801.41^119');  //MH Test
    DlgRsltGroupTemplate.Add('801.41^120');  //MH Scale
    DlgRsltGroupTemplate.Add('801.41^23');   //Exclude from progress note
    DlgRsltGroupTemplate.Add('801.41^10');   //Components
    DlgRsltGroupTemplate.Add('801.41^110');  //Edit history
  end;

  procedure InitDlgRsltElementTemplate(DlgRsltElementTemplate : TStringList);
  begin
    DlgRsltElementTemplate.Add('801.41^.01');  //Name
    DlgRsltElementTemplate.Add('801.41^3');    //Disable
    DlgRsltElementTemplate.Add('801.41^100');  //Class
    DlgRsltElementTemplate.Add('801.41^101');  //Sponsor
    DlgRsltElementTemplate.Add('801.41^102');  //Review Date
    DlgRsltElementTemplate.Add('801.41^53');   //Result condition
    DlgRsltElementTemplate.Add('801.41^25');   //Dialog/Progress Note Text -- 'PROGRESS NOTE TEXT'
    DlgRsltElementTemplate.Add('801.41^35');   //Alternative PN text -- 'INFORMATIONAL MESSAGE TEXT'
    DlgRsltElementTemplate.Add('801.41^10');   //Components
  end;

  procedure InitRemFindingsTemplate(FIType : string; Template : TStringList);
  begin
    Template.Add('811.902^.01');  //Finding Item
    Template.Add('811.902^3');    //Reminder Frequency
    Template.Add('811.902^1');    //Minimum Age
    Template.Add('811.902^2');    //Maximum Age
    Template.Add('811.902^6');    //Rank Frequency
    Template.Add('811.902^7');    //Use in Resolution Logic
    Template.Add('811.902^8');    //Use in Patient Cohort Logic
    Template.Add('811.902^9');    //Beginning Date/Time
    Template.Add('811.902^12');   //Ending Date/Time
    Template.Add('811.902^17');   //Occurrence Count
    Template.Add('811.902^14');   //Condition
    Template.Add('811.902^15');   //Condition Case Sensitive
    Template.Add('811.902^18');   //Use Status/Cond in Search
    if (FIType='DR') or (FIType='DC') or (FIType='DG') then begin
      Template.Add('811.902^16');  //RXTYPE
      Template.Add('811.902^27');  //Use Start Date
      Template.Add('811.902^21');  //Status List
    end;
    if (FIType='ED') or (FIType='EX') or (FIType='HF')
    or (FIType='IM') or (FIType='TX') then begin
      Template.Add('811.902^28');  //Include Visit Data
      if FIType='HF' then Template.Add('811.902^11');  //Within Category Rank
      if FIType='TX' then Template.Add('811.902^10');  //Use Inactive Problems
    end;
    if FIType='MH' then Template.Add('811.902^13');  //MH Scale
    if FIType='OI' then begin
      Template.Add('811.902^27');  //Use Start Date
      Template.Add('811.902^21');  //Status List
    end;
    if FIType='RP' then Template.Add('811.902^21');  //Status List
    if FIType='CF' then Template.Add('811.902^26');  //Computed Finding Parameter
    Template.Add('811.902^4');     //Found Text
    Template.Add('811.902^5');     //Not Found Text
  end;

  procedure InitRemFindingsTemplateList(ListOfTemplates : TStringList);
  //Input is assumed to be blank.
  //Objects will be loaded into ListOfTemplates.  Caller will own
  //    the objects, and will be responsible for deleting them.
  //Format  List.Strings[i] = Finding type (e.g. 'HF')
  //        List.Object[i] = TStringList containing template for type

  var i : integer;
      OneTemplate: TStringList;
      FIType : string;
  begin
    for i := 1 to NUM_FINDING_TYPE_NAMES do begin
      OneTemplate := TStringList.Create;
      FIType := FINDING_TYPES_NAMES[i].Prefix;
      InitRemFindingsTemplate(FIType, OneTemplate);
      ListOfTemplates.AddObject(FIType, OneTemplate);
    end;
  end;

  procedure InitReminderFunctionFindingTemplate(BasicTemplate : TStringList);
  begin
    BasicTemplate.Add('811.925^.01'); //FUNCTION FINDING NUMBER : 8
    BasicTemplate.Add('811.925^1');   //FOUND TEXT :
    BasicTemplate.Add('811.925^2');   //NOT FOUND TEXT :
    BasicTemplate.Add('811.925^3');   //FUNCTION STRING : DIFF_DATE(8,14)>21914
    //BasicTemplate.Add('811.925^5');   //FUNCTION LIST
    //BasicTemplate.Add('811.925^10');  //LOGIC : FN(1)>21914
    BasicTemplate.Add('811.925^11');  //USE IN RESOLUTION LOGIC :
    BasicTemplate.Add('811.925^12');  //USE IN PATIENT COHORT LOGIC :
    //BasicTemplate.Add('811.925^13');  //MINIMUM AGE :
    //BasicTemplate.Add('811.925^14');  //MAXIMUM AGE :
    //BasicTemplate.Add('811.925^15');  //REMINDER FREQUENCY :
    //BasicTemplate.Add('811.925^16');  //RANK FREQUENCY :
    BasicTemplate.Add('811.925^40');  //NAME :
    //BasicTemplate.Add('811.925^41');  //NO. FOUND TEXT LINES : 0
    //BasicTemplate.Add('811.925^42');  //NO. NOT FOUND TEXT LINES : 0
  end;

  function GetCursorImage : TCursor;
  begin
    //All should be the same, so just return first from list (See SetCursorImage)
    {
    Result := BasicUsersGrid.Cursor;
    }
  end;


  procedure SetCursorImage(Cursor : TCursor);
  begin
    {
    BasicUsersGrid.Cursor := Cursor;
    AdvancedUsersGrid.Cursor := Cursor;
    UsersTreeView.Cursor := Cursor;

    BasicSettingsGrid.Cursor := Cursor;
    AdvancedSettingsGrid.Cursor := Cursor;
    SettingsTreeView.Cursor := Cursor;

    PatientORComboBox.Cursor := Cursor;
    BasicPatientGrid.Cursor := Cursor;
    AdvancedPatientGrid.Cursor := Cursor;
    }
  end;




//--------------------------------------------
//--------------------------------------------

initialization
  //FLoadingGrid := false;
  Changes := TStringList.Create;

  //kt 12/18/13
  LastSelTreeNode := nil;
  LastSelTreeView := nil;


finalization
  Changes.Free;

end.
