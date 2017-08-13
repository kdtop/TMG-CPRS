unit fOneRecEditU;

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
  StrUtils, {MainU,} rTMGRPCs, uTMGGrid, uTMGGlobals,
  Dialogs, StdCtrls, ExtCtrls, Grids, ComCtrls, Buttons, uTMGTypes,
  SortStringGrid, PostU;

type
  TfrmOneRecEdit = class(TForm)
    pnlTop: TPanel;
    OneRecLabel: TLabel;
    pnlBottom: TPanel;
    OneRecGrid: TSortStringGrid;
    ButtonPanel: TPanel;
    ApplyBtn: TBitBtn;
    RevertBtn: TBitBtn;
    DoneBtn: TBitBtn;
    btnSpecialInfo: TBitBtn;
    TimerDelayedViewBtnAction: TTimer;
    btnCancelIcon: TBitBtn;
    btnOKIcon: TBitBtn;
    RecEditPageControl: TTabControl;
    procedure RecEditPageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure RecEditPageControlChange(Sender: TObject);
    procedure TimerDelayedViewBtnActionTimer(Sender: TObject);
    procedure btnSpecialInfoClick(Sender: TObject);
    procedure DoneBtnClick(Sender: TObject);
    procedure OneRecGridClick(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure RevertBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OneRecGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  private
    { Private declarations }
    FFileNum : string;
    FIENS : string;
    BlankFileInfo : TStringList;
    LastAddNum : integer;
    IgnoreSelections : boolean;
    //CurrentRecData : TStringList; //source for GridInfo.Data
    ModifiedForm : boolean;  //Used to see if current record is unsaved
    FPosted : boolean;
    AGridList : TList; //doesn't own objects.
    FGridInfo : TCompleteGridInfo;  //owned by GlobalsU.DataForGrid
    SavedBasicTemplate : TStringList;  //doesn't own object
    FChangesMade : boolean;
    procedure CheckSetSpecialInfoBtnVisibility;
    function SupportedSpecialFindingsFile(FileNum : string) : boolean;
    function SupportedSpecialAutoSubFile(FileNum : string) : boolean;
    procedure SetModifiedStatus(IsModified :Boolean);
    function GridHasChanges : boolean;
    function GetChangesMade : boolean;
    function GetGridInfo : TGridInfo;
  public
    { Public declarations }
    SuppressAutoViewPress : boolean;
    ParentEditForm : TVariantPopupEdit; //TempVariantPopupEdit;
    procedure GetOneRecInfo(GridInfo : TGridInfo);
    function RecordSelector : string;
    procedure PrepForm(FileNum : string; IENS : string; FilterTemplate : TStringList = nil); overload;
    procedure PrepForm(AGridInfo : TGridInfo); overload;
    property Posted : boolean read FPosted;
    property ChangesMade : boolean read GetChangesMade;  //Signal that data was changed somehow.
    property GridInfo : TGridInfo read GetGridInfo;
    constructor Create(AOwner : TComponent);
    Destructor Destroy;
  end;

const
  MSG_FILE = 'File';


function EditOneRecordModal(AOwner : TComponent; FileNum, IENS : string;
                            SuppressAutoViewPress : boolean = false;
                            OnAfterPost : TAfterPostHandler = nil) : boolean;  overload; //forward
function EditOneRecordModal(AOwner : TComponent; AGridInfo : TGridInfo;
                            SuppressAutoViewPress : boolean = false) : boolean;  overload; //forward

implementation

{$R *.dfm}

  uses ORFn, fMultiRecEditU,
       //frmVennU, Rem2VennU,
       {frmFuncFinding,}
       //fFindingDetail,  <-- Venn diagram stuff
       //fMumpsCodeU,  <-- reminder stuff
       uTMGUtil
       //fRemFnFindingEdit,
       //fTaxonomyDisplay
       ;

  function EditOneRecordModal(AOwner : TComponent; AGridInfo : TGridInfo; SuppressAutoViewPress : boolean = false) : boolean;  overload;
  //Result is TRUE if changes were made, else FALSE
  //Will cause trigger OnAfterPost event if GridInfo associated with OneRecGrid has assigned event handler.
  //no, I think --> If GridInfo.Grid <> OneRecGrid, and GridInfo has an OnAfterPost handler, it will ALSO fire that event.
  var
    OneRecEditForm : TfrmOneRecEdit;
  begin
    OneRecEditForm := TfrmOneRecEdit.Create(AOwner);
    OneRecEditForm.PrepForm(AGridInfo);
    OneRecEditForm.ParentEditForm.RecType := ActivePopupEditForm.RecType;
    OneRecEditForm.ParentEditForm.EditForm:= ActivePopupEditForm.EditForm;
    ActivePopupEditForm.RecType := vpefOneRec;
    ActivePopupEditForm.EditForm := OneRecEditForm;
    OneRecEditForm.SuppressAutoViewPress := SuppressAutoViewPress;
    OneRecEditForm.ShowModal;
    Result := OneRecEditForm.ChangesMade;
    ActivePopupEditForm.RecType := vpef(OneRecEditForm.ParentEditForm.RecType);
    ActivePopupEditForm.EditForm := OneRecEditForm.ParentEditForm.EditForm;
    FreeAndNil(OneRecEditForm);

    {
    if Assigned(GridInfo.BasicTemplate) and (GridInfo.BasicTemplate.Count > 0) then begin
      OneRecTemplate := GridInfo.BasicTemplate;
    end else begin
      OneRecTemplate := nil;
    end;
    Result := EditOneRecordModal(GridInfo.FileNum, GridInfo.IENS, SuppressAutoViewPress);
    //If (GridInfo.Grid <> OneRecGrid) and Assigned(GridInfo.OnAfterPost)
    }
  end;

  function EditOneRecordModal(AOwner : TComponent; FileNum, IENS : string;
                              SuppressAutoViewPress : boolean = false;
                              OnAfterPost : TAfterPostHandler = nil) : boolean;
  //Result is TRUE if changes were made, else FALSE
  //Will cause trigger OnAfterPost event if GridInfo associated with OneRecGrid
  //has assigned event handler.
  var
    TempGridInfo : TGridInfo;
  begin
    TempGridInfo := TGridInfo.Create;
    TempGridInfo.FileNum := FileNum;
    TempGridInfo.IENS := IENS;
    EditOneRecordModal(AOwner, TempGridInfo, SuppressAutoViewPress);

    TempGridInfo.Free;
  end;


  //----------------------------------
  //----------------------------------

  constructor TfrmOneRecEdit.Create(AOwner : TComponent);
  begin
    Inherited Create(AOwner);
    BlankFileInfo := TStringList.Create;
    FGridInfo := TCompleteGridInfo.Create; //ownership will be transferred to GlobalsU.DataForGrid
    //ModifiedForm := False;
    SetModifiedStatus(False);
    ParentEditForm.RecType := vpefNone;
    ParentEditForm.EditForm := nil;
    AGridList := TList.Create;
    AGridList.Add(OneRecGrid);
    SuppressAutoViewPress := false;
  end;


  Destructor TfrmOneRecEdit.Destroy;
  begin
    BlankFileInfo.Free;
    //CurrentRecData.Free;
    UnRegisterGridInfo(FGridInfo);
    //FGridInfo.Free;  <-- done in UnRegisterGridInfo
    AGridList.Free;
    inherited Destroy;
  end;


  procedure TfrmOneRecEdit.PrepForm(AGridInfo : TGridInfo);
  var DispIENS, ExpandedFileName : string;
  begin
    FGridInfo.Clear;
    FGridInfo.Assign(AGridInfo);

    FGridInfo.Grid := OneRecGrid;
    FGridInfo.ApplyBtn := ApplyBtn;
    FGridInfo.RevertBtn := RevertBtn;
    FGridInfo.RecordSelector := RecordSelector;
    FGridInfo.DataLoadProc := GetOneRecInfo;

    RegisterGridInfo(FGridInfo); //Unregestered in FormDestroy.
    //NOTE: if PrepForm called more than once, then a GridInfo won't be unregistered.
    //NOTE2: By calling RegisterGridInfo, DataForGrid will own FGridInfo

    SavedBasicTemplate := FGridInfo.BasicTemplate;
    RecEditPageControl.Tabs.Clear;
    if assigned(FGridInfo.BasicTemplate) and (FGridInfo.BasicTemplate.Count > 0) then begin
      RecEditPageControl.Tabs.Add('&Basic');
      RecEditPageControl.Tabs.Add('&Advanced');
    end else begin
      RecEditPageControl.Tabs.Add('Edit');
    end;
    RecEditPageControl.TabIndex := 0;

    BlankFileInfo.Clear;
    FFileNum := FGridInfo.FileNum;
    FIENS := FGridInfo.IENS;
    DispIENS := FGridInfo.IENS;
    if (DispIENS <> '') and (DispIENS[Length(DispIENS)] = ',') then begin
      DispIENS := StrUtils.LeftStr(DispIENS, Length(DispIENS)-1);
    end;
    ExpandedFileName := rTMGRPCs.ExpandFileNumber(FFileNum);
    OneRecLabel.Caption := 'Edit Entry in File ' + ExpandedFileName + ' (#' + FFileNum + '); Record=' + DispIENS;
    //Something to trigger filling grid here.
    ClearGrid(OneRecGrid);
    GetOneRecord(FGridInfo.FileNum, FGridInfo.IENS, FGridInfo.Data, BlankFileInfo);
    //LoadAnyGrid(GridInfo);
    RecEditPageControlChange(RecEditPageControl);
  end;


  procedure TfrmOneRecEdit.GetOneRecInfo(GridInfo : TGridInfo);
  //Purpose: Get all fields from server for one record.
  begin
    uTMGGrid.GetRecordsInfoAndLoadIntoGrids(GridInfo, AGridList);
  end;

  procedure TfrmOneRecEdit.ApplyBtnClick(Sender: TObject);
  //Will trigger OnAfterPost event if GridInfo associated with OneRecGrid has assigned event handler.
  begin
    FChangesMade := (PostChanges(OneRecGrid, true, false, FPosted) = mrOK);
    //FPosted := PostForm.Posted;
    if FPosted then begin
      SetModifiedStatus(False);
    end;
  end;

  procedure TfrmOneRecEdit.DoneBtnClick(Sender: TObject);
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

  function TfrmOneRecEdit.GridHasChanges : boolean;
  var Changes : TStringList;
  begin
    Changes := TStringList.Create;
    CompileChangesEx(OneRecGrid, FGridInfo.Data {CurrentRecData},Changes);
    Result := (Changes.Count>0);
    Changes.Free;
  end;

  procedure TfrmOneRecEdit.FormShow(Sender: TObject);
  begin
    FPosted := false;
    LastAddNum := 0;
    CheckSetSpecialInfoBtnVisibility;
    if btnSpecialInfo.Visible and not SuppressAutoViewPress then begin
      TimerDelayedViewBtnAction.Interval := 100;
      TimerDelayedViewBtnAction.Enabled := true;
    end;
  end;

  function TfrmOneRecEdit.RecordSelector : string;
  begin
    Result := FGridInfo.IENS;
  end;

  procedure TfrmOneRecEdit.PrepForm(FileNum : string; IENS : string; FilterTemplate : TStringList = nil);
  //Format is: FileNum^IENS^FieldNum^ExternalValue^DDInfo...
  var DispIENS, ExpandedFileName : string;
      TempGridInfo : TGridInfo;
  begin
    TempGridInfo := TGridInfo.Create;
    TempGridInfo.FileNum := FileNum;
    TempGridInfo.IENS := IENS;
    TempGridInfo.BasicTemplate := FilterTemplate;
    PrepForm(TempGridInfo);
    TempGridInfo.Free;
  end;

  procedure TfrmOneRecEdit.RevertBtnClick(Sender: TObject);
  begin
    //ModifiedForm := False;
    SetModifiedStatus(False);
    LoadAnyGrid(FGridInfo);
  end;

  procedure TfrmOneRecEdit.RecEditPageControlChange(Sender: TObject);
  var Modified : boolean;
      Response : integer;
  begin
    if TTabControl(Sender).TabIndex = 0 then begin
      FGridInfo.BasicTemplate := SavedBasicTemplate;
    end else begin
      FGridInfo.BasicTemplate := nil;
    end;
    LoadAnyGrid(FGridInfo);
  end;

procedure TfrmOneRecEdit.RecEditPageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
  var
      Response : integer;
  begin
    if ModifiedForm then begin
      Response := MessageDlg('Post changes so far?', mtConfirmation, mbYesNoCancel, 0);
      if Response = mrYes then begin
        ApplyBtnClick(Sender);
      end else if Response = mrCancel then begin
        AllowChange := False;
        exit;
      end;
    end;
end;

procedure TfrmOneRecEdit.TimerDelayedViewBtnActionTimer(Sender: TObject);
  begin
    TimerDelayedViewBtnAction.Enabled := false;
    btnSpecialInfoClick(Sender);
  end;

  procedure TfrmOneRecEdit.OneRecGridClick(Sender: TObject);
  begin
    //SetModifiedStatus(True);
  end;

  function TfrmOneRecEdit.GetChangesMade : boolean;
  begin
    Result := FChangesMade or FGridInfo.DisplayRefreshIndicated;
  end;


  procedure TfrmOneRecEdit.SetModifiedStatus(IsModified :Boolean);
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

  procedure TfrmOneRecEdit.OneRecGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  begin
    FGridInfo.MessageStr := MSG_SUB_FILE;  //kt 3/22/13 MSG_FILE;
    //MainForm.GridSelectCell(Sender, ACol, ARow, CanSelect);
    uTMGGrid.GridSelectCell(Sender,  ACol, ARow, CanSelect, LastSelTreeNode,
                            TMG_Auto_Press_Edit_Button_In_Detail_Dialog);
    SetModifiedStatus(GridHasChanges);
  end;

  function TfrmOneRecEdit.SupportedSpecialFindingsFile(FileNum : string) : boolean;
  begin
    Result := (FileNum = '811.925')   //Reminder Definition:FUNCTION FINDINGS
           or (FileNum = '811.902');  //Reminder Definition:FINDINGS
  end;

  function TfrmOneRecEdit.SupportedSpecialAutoSubFile(FileNum : string) : boolean;
  begin
    Result := (FileNum = '811.5');      //REMINDER TERM
  end;



  procedure TfrmOneRecEdit.CheckSetSpecialInfoBtnVisibility;
  var FNum : string;
  begin
    //Optionally add more later
    FNum := FGridInfo.FileNum;
    btnSpecialInfo.Visible := SupportedSpecialFindingsFile(FNum)
                              or SupportedSpecialAutoSubFile(FNum)
                              or (FNum = '811.2')    //REMINDER TAXONOMY
                              or (FNum = '811.4')    //REMINDER COMPUTED FINDINGS
                              or (FNum = '811.52');  //Taxonomy
    //btnWizard.Visible := (FNum = '811.925');
  end;

  procedure TfrmOneRecEdit.btnSpecialInfoClick(Sender: TObject);
  {//kt 12/18/13
  var
    FuncFindingForm: TFindingDetailForm;
    CanSelect : boolean;
    Value : string;
    frmMumpsCode: TfrmMumpsCode;
    tempS, Routine,EntryPoint : string;
  }

  begin
    {//kt 12/18/13
    // handle special
    if SupportedSpecialFindingsFile(FGridInfo.FileNum) then begin
      FuncFindingForm := TFindingDetailForm.Create(self);
      //NOTE: If edits are made to the edit form, and applied,
      //   they are not being updated in GridInfo.Data.  So old
      //   data is showed.  FIX LATER...
      if FuncFindingForm.Initialize(FGridInfo) then begin
        FuncFindingForm.ShowModal;
      end else begin
        //MessageDlg('Unable to prepare function for display.', mtInformation, [mbOK], 0);
      end;
      FuncFindingForm.Free;
    end else if SupportedSpecialAutoSubFile(FGridInfo.FileNum) then begin
      Value := OneRecGrid.Cells[2,4];
      if Value <> CLICK_TO_ADD_SUBS then begin  //Don't auto zoom-in if no subfile entries.
        MainForm.GridSelectCell(OneRecGrid, 2, 4, CanSelect);  //Row 4 = field 20 (FINDINGS), Col 2 = cell with data.
      end else begin
        MessageDlg('No FINDINGS to view.', mtInformation, [mbOK], 0);
      end;
    end else if (FGridInfo.FileNum = '811.4') then begin  //REMINDER COMPUTED FINDINGS
      frmMumpsCode := TfrmMumpsCode.Create(Self);
      tempS := UtilU.GetOneLine(FGridInfo.Data,'811.4','.02');
      Routine := Piece(tempS,'^',4);
      tempS := UtilU.GetOneLine(FGridInfo.Data,'811.4','.03');
      EntryPoint := Piece(tempS,'^',4);
      frmMumpsCode.Initialize(Routine, EntryPoint);
      frmMumpsCode.ShowModal;
      FreeAndNil(frmMumpsCode);
    end else if (FGridInfo.FileNum = '811.2') then begin  //REMINDER TAXONOMY
      frmTaxonomyDisplay := TfrmTaxonomyDisplay.Create(Self);
      frmTaxonomyDisplay.Initialize(FGridInfo.IENS);
      frmTaxonomyDisplay.ShowModal;
      FreeAndNil(frmTaxonomyDisplay)
    end else begin
      Value := OneRecGrid.Cells[2,1];
      if Value <> '' then begin  //Don't auto click if no entry.
        TMG_Auto_Press_Edit_Button_In_Detail_Dialog := true;
        MainForm.GridSelectCell(OneRecGrid, 2, 1, CanSelect);  //Row 1 = field .01 (FINDING ITEM), Col 2 = cell with data.
      end else begin
        MessageDlg('Nothing to view.', mtInformation, [mbOK], 0);
      end;
    end;
    }
  end;

  function TfrmOneRecEdit.GetGridInfo : TGridInfo;
  begin
    Result := TGridInfo(FGridInfo);
  end;


initialization
end.
