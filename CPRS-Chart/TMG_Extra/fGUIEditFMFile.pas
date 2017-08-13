unit fGUIEditFMFile;
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
  Dialogs, StdCtrls, Grids, ExtCtrls, ComCtrls, Buttons,
  uTMGGrid, uTMGGlobals,
  SortStringGrid, ORFn, rTMGRPCs, uTMGPtInfo, UTMGTypes, ORCtrls;

type
  TfrmGUIEditFMFile = class(TForm)
    PageControl: TPageControl;
    CancelBtn: TButton;
    tsBasic: TTabSheet;
    tsAdvanced: TTabSheet;
    pnlTop: TPanel;
    sgBasic: TSortStringGrid;
    ORComboBox1: TORComboBox;
    lblTemplate: TLabel;
    sgAdvanced: TSortStringGrid;
    btnApply: TBitBtn;
    btnRevert: TBitBtn;
    btnEdit: TBitBtn;
    btnAdd: TBitBtn;
    procedure PageControlChanging(Sender: TObject; var AllowChange: Boolean);
    procedure PageControlChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure GridSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure btnApplyClick(Sender: TObject);
    procedure btnRevertClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDUZ : string;  //local copy of current user DUZ, for security checks.
    FileData : TStringList;
    BasicTemplate : TStringList;
    GridList : TList;
    procedure GetFileDataAndLoadIntoGrids(GridInfo : TGridInfo);
    procedure HandleOnAfterPost(GridInfo: TGridInfo; Changes : TStringList);
    procedure InitBasicTemplate(BasicTemplate : TStringList);
    procedure Clear;
  public
    { Public declarations }
    procedure PrepForm(FileNumber, IENS, DUZ : string);
  end;

//var
//  frmGUIEditFMFile: TfrmGUIEditFMFile;

implementation

{$R *.dfm}

  procedure TfrmGUIEditFMFile.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    //Finish: do something to ensure changes aer not being lost without user verification first.
  end;

  procedure TfrmGUIEditFMFile.FormCreate(Sender: TObject);
  begin
    FileData := TStringList.Create;
    BasicTemplate := TStringList.Create;
    GridList := TList.Create;
  end;

  procedure TfrmGUIEditFMFile.FormDestroy(Sender: TObject);
  begin
    Clear;
    FileData.Free;
    BasicTemplate.Free;
    GridList.Free;
  end;

  procedure TfrmGUIEditFMFile.Clear;
  begin
    BasicTemplate.Clear;
    ClearDataForGridList;
  end;


  procedure TfrmGUIEditFMFile.PageControlChange(Sender: TObject);
  begin
    if PageControl.ActivePage = tsBasic then begin
      SetVisibleGridIdx(sgBasic);
    end else begin
      SetVisibleGridIdx(sgAdvanced);
    end;
  end;

  procedure TfrmGUIEditFMFile.PageControlChanging(Sender: TObject; var AllowChange: Boolean);
  var result : TModalResult;
  begin
    result := PostVisibleGrid;
    AllowChange := (result <> mrNO);
  end;

  procedure TfrmGUIEditFMFile.PrepForm(FileNumber, IENS, DUZ : string);
  //Input: FileNumber -- the FM file number (not name)
  //       IENS -- IEN + ',' of record to show
  //       DUZ -- current user record number, for permission checking.

    procedure SetupAfterPostHandler(Grid : TSortStringGrid; Handler : TAfterPostHandler);
    var GridInfo : TGridInfo;
    begin
      GridInfo := GetInfoObjectForGrid(Grid);
      if not assigned(GridInfo) then exit;
      GridInfo.OnAfterPost := Handler;
    end;

  var  GridInfo : TGridInfo;

  begin
    Clear;
    FDUZ := DUZ;

    {           Name,           Grid        Data       BasicTemplate    DataLoader                    FileNum      ApplyBtn   RevertBtn          RecSelector       }
    AddGridInfo('BasicGrid',    sgBasic,    FileData,  BasicTemplate,   GetFileDataAndLoadIntoGrids,  FileNumber,  btnApply,  btnRevert);
    AddGridInfo('AdvancedGrid', sgAdvanced, FileData,  nil,             GetFileDataAndLoadIntoGrids,  FileNumber,  btnApply,  btnRevert);

    GridList.Add(sgBasic);
    GridList.Add(sgAdvanced);
    SetupAfterPostHandler(sgBasic,    HandleOnAfterPost);
    SetupAfterPostHandler(sgAdvanced, HandleOnAfterPost);
    InitBasicTemplate(BasicTemplate);

    GridInfo := GetInfoObjectForGrid(sgBasic);
    GridInfo.IENS := IENS;
    GetFileDataAndLoadIntoGrids(GridInfo);
  end;

  procedure TfrmGUIEditFMFile.GridSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
  begin
    btnRevert.Enabled := true;
    btnApply.Enabled := true;
  end;

  procedure TfrmGUIEditFMFile.GridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  begin
    uTMGGrid.GridSelectCell(Sender,  ACol, ARow, CanSelect, LastSelTreeNode,
                            TMG_Auto_Press_Edit_Button_In_Detail_Dialog);
  end;

  procedure TfrmGUIEditFMFile.GetFileDataAndLoadIntoGrids(GridInfo : TGridInfo);
  //Purpose: Get all fields from server for one record.
  begin
    GetRecordsInfoAndLoadIntoGrids(GridInfo, GridList);
  end;

  procedure TfrmGUIEditFMFile.HandleOnAfterPost(GridInfo: TGridInfo; Changes : TStringList);
  begin
    if not Assigned(Changes) then exit;
    //Do something here if wanted/needed
  end;

  procedure TfrmGUIEditFMFile.btnAddClick(Sender: TObject);
  begin
  //Here I can add a new template
  end;

procedure TfrmGUIEditFMFile.btnApplyClick(Sender: TObject);
  var result : TModalResult;
  begin
    result:= PostVisibleGrid;
    if result <> mrNone then begin
      //Do something here if wanted/needed
    end;
  end;

  procedure TfrmGUIEditFMFile.btnEditClick(Sender: TObject);
  begin
    //Here I can edit templates
  End;

procedure TfrmGUIEditFMFile.btnRevertClick(Sender: TObject);
  begin
    DoRevert(sgBasic, sgAdvanced);
  end;

  procedure TfrmGUIEditFMFile.InitBasicTemplate(BasicTemplate : TStringList);
  //NOTICE!: This sets some default fields for the basic template.  But eventually
  //         this will be gotten from the server, and this function can be deleted.
  //         This assumes file #2, but, again, this will be abstracted when calling
  //         the server.
  begin
    BasicTemplate.Add('2^.01');  //Name
    BasicTemplate.Add('2^.02');  //Sex
    BasicTemplate.Add('2^.03');  //DOB
  end;




end.

