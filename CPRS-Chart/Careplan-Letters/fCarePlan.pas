unit fCarePlan;
//VEFA-261 added entire unit and form

 (*
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  fDrawers,fFrame, uTemplates, uConst,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Grids, ORNet, uCarePlan, Menus, OleCtrls, SHDocVw,
  fBase508Form, VA508AccessibilityManager;

type
  TCarePlan = class(TObject)
  private
    FActiveStatus : boolean;
    FCarePlanTemplate : TTemplate;
    function GetCarePlanTemplate : TTemplate;
    function GetPrintName : string;
  public
    TreeNode : TTreeNode;
    Name : string;
    VEFA19008 : string;
    IEN8927 : string;
    property Active : boolean read FActiveStatus;
    property CarePlanTemplate : TTemplate read GetCarePlanTemplate;
    property PrintName : string read GetPrintName;
    function SetActiveStatus(Active : boolean) : boolean;
    constructor Create(ActiveStatus : boolean);
  end;

  TfrmCarePlan = class(TfrmBase508Form)
    tvPatientCarePlans: TTreeView;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    btnNewCP: TBitBtn;
    sgCarePlanProgress: TStringGrid;
    Label1: TLabel;
    btnDone: TBitBtn;
    pnlRight: TPanel;
    Splitter1: TSplitter;
    btnLaunch: TBitBtn;
    cbHideInactive: TCheckBox;
    popmnuCarePlanTV: TPopupMenu;
    mnuDeleteTVItem: TMenuItem;
    mnuInactivateTVItem: TMenuItem;
    mnuReactivateCarePlan: TMenuItem;
    pnlRightTop: TPanel;
    pnlRightMain: TPanel;
    pnlRightBottom: TPanel;
    cboDateRange: TComboBox;
    Splitter2: TSplitter;
    cbShowDetails: TCheckBox;
    cbRecentOnLeft: TCheckBox;
    DetailsRE: TRichEdit;
    btnPrevProb: TBitBtn;
    btnNextProb: TBitBtn;
    dtStartDate: TDateTimePicker;
    dtEndDate: TDateTimePicker;
    lblTo: TLabel;
    cboActiveProb: TComboBox;
    lblCurPatient: TLabel;
    btnFont: TBitBtn;
    FontDialog1: TFontDialog;
    FColWidth: TTrackBar;
    Label2: TLabel;
    procedure FColWidthChange(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure tvPatientCarePlansCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure cboActiveProbChange(Sender: TObject);
    procedure btnNavProbClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtEndDateChange(Sender: TObject);
    procedure dtStartDateChange(Sender: TObject);
    procedure cboDateRangeChange(Sender: TObject);
    procedure sgCarePlanProgressDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure cbRecentOnLeftClick(Sender: TObject);
    procedure cbShowDetailsClick(Sender: TObject);
    procedure sgCarePlanProgressMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvPatientCarePlansEnter(Sender: TObject);
    procedure tvPatientCarePlansExit(Sender: TObject);
    procedure mnuReactivateCarePlanClick(Sender: TObject);
    procedure mnuInactivateTVItemClick(Sender: TObject);
    procedure mnuDeleteTVItemClick(Sender: TObject);
    procedure popmnuCarePlanTVPopup(Sender: TObject);
    procedure cbHideInactiveClick(Sender: TObject);
    procedure btnLaunchClick(Sender: TObject);
    procedure tvPatientCarePlansChange(Sender: TObject; Node: TTreeNode);
    function GetTemplateForSelectedCarePlan : TTemplate;
    procedure UpdateResultGrid(CP : TCarePlan);
    procedure btnNewCPClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FProbData : TCPProblemData;
    FDrawers : TfrmDrawers;  //Only valid after InsertOK returns true
    FTargetDocIEN8925 : string;
    FViewHeight : integer;
    FStoredResultSet: TStringList;
    FLinkedTIUDocs : TStringList;
    FSelectedColumn : integer;
    FCarePlanName : string;
    FRichEditControl : TRichEdit;  //Pointer to the edit window on other tabs.
    FProbInfoSL : TStringList; //owned elsewhere.
    procedure ClearTV;    procedure AddCarePlanToTV(Name, VEFA19008, IEN8927 : string; Active : boolean);
    function GetTVSelCP : TCarePlan;
    function GetNodeCP(Node : TTreeNode) : TCarePlan;
    function InsertOK(Ask: boolean): boolean;
    function CarePlanOK(CP : TTemplate; Msg: string = ''): boolean;
    procedure LoadCarePlansToTV;
    procedure SetActiveStatusOfCarePlan(Active : boolean);
    procedure ClearResultGrid;
    procedure LoadResultSet(ResultSet: TStringList);
    procedure ColumnSelected(ColNum : integer);
    procedure SetDetailView(Show : boolean);
    procedure DrawSGCell(Sender : TObject; ACol, ARow : integer; Rect : TRect; Style : TFontStyles;
                         Wrap : boolean;  Just : TAlignment; CanEdit : boolean);
    procedure ShowDocument(IEN8925 : string; CarePlanName: string);
    procedure InsertText(CP : TCarePlan; CPTemplate : TTemplate);
    procedure SetNavButtons(PrevProb,NextProb : string);
    procedure SetDatePickersVisibility(Visible : boolean);
    procedure SetFormForIdxProb(Index : integer);
    procedure InactivateDetails;
    procedure ResetCellHeight;
  public
    { Public declarations }
    procedure Initialize(Index : integer; ProblemInfo : TStringList);
  end;

//var
//  frmCarePlan: TfrmCarePlan;

const
  CAREPLAN_NAV_BUTTON_MODAL_OFFSET = 1000;

implementation

{$R *.dfm}
  uses ORFn, fCarePlanPicker, dShared, fTemplateDialog, uTemplateFields,
       rCarePlans, fNotes, fConsults, fDCSumm, fSurgery, rTIU, uHTMLTools, StrUtils,
       fCarePlanSignDIalog, Math, TMGHTML2,
       RichEdit, uCore, uVA508CPRSCompatibility;

  const
    ROW_DATE = 0;
    COL_QUESTION = 0;          COL_QUESTION_TEXT = 'Clinical Item';

    ROW_PROVIDER = 1;
    COL_PROVIDER = 0;          COL_PROVIDER_TEXT = 'Provider at Update:';
    COL_DATE = COL_PROVIDER;   COL_DATE_TEXT = 'Date of Update:';

    COL_EMPTY=1;
    ROW_EMPTY=2;
    EMPTY_QUESTION = '(Clinical Item)';
    EMPTY_VALUE = '(Value)';
    DEFAULT_COL_QUESTION_WIDTH = 120;

    NOTE_UNSIGNED = '(Unsigned)';

  const
    DATE_RANGE_ALL    = 0;
    DATE_RANGE_10Y    = 1;
    DATE_RANGE_5Y     = 2;
    DATE_RANGE_2Y     = 3;
    DATE_RANGE_1Y     = 4;
    DATE_RANGE_CUSTOM = 5;


  type tTargetRE = (tgNone,tgtNotes,tgConsults,tgDCSumm,tgSurgery);
  const RE_TARGET_NAME: array[tgNone..tgSurgery] of string = ('<None>','progress notes','consults','discharge summary','surgical report');  //VEFA-261
  var RichEditFound : tTargetRE;  //VEFA-261

  type
    TExposedFrmNotes = class(TFrmNotes)  //Allows access to private members of class
    end;

    TExposedFrmDCSumm = class(TfrmDCSumm)  //Allows access to private members of class
    end;

    TExposedFrmConsults = class(TfrmConsults) //Allows access to private members of class
    end;

    TExposedFrmSurgery = class(TfrmSurgery) //Allows access to private members of class
    end;

  // ------------------------------------------------------------------------------
  // ------------------------------------------------------------------------------
  constructor TCarePlan.Create(ActiveStatus : boolean);
  begin
    inherited Create;
    Self.FActiveStatus := ActiveStatus;
  end;

  function TCarePlan.SetActiveStatus(Active : boolean) : boolean;
  //Returns true if successful
  var RPCResult : string;
  begin
    Result := false;
    if VEFA19008 = '' then exit;
    RPCResult := SetCarePlanActiveStatus(VEFA19008, Active);
    if piece(RPCResult,'^',1) = '-1' then begin
      MessageDlg(piece(RPCResult,'^',2), mtError, [mbOK], 0);
      exit;
    end;
    Result := true;
    if not assigned(TreeNode) then exit;       
    TreeNode.Text := Self.PrintName;
  end;

  function TCarePlan.GetCarePlanTemplate : TTemplate;
  begin
    Result := FCarePlanTemplate;
    if assigned(Result) then exit;
    Result := uCarePlan.GetCarePlanTemplate(IEN8927);
  end;

  function TCarePlan.GetPrintName : string;
  begin
    Result := Self.name;
    if not Active then Result := Result + ' {inactive}';
  end;


  // ------------------------------------------------------------------------------
  // ------------------------------------------------------------------------------


  procedure TfrmCarePlan.FColWidthChange(Sender: TObject);
  begin
    sgCarePlanProgress.ColWidths[COL_QUESTION] := DEFAULT_COL_QUESTION_WIDTH + FColWidth.Position;
  end;

procedure TfrmCarePlan.FormCreate(Sender: TObject);
  begin
    FProbData := TCPProblemData.Create;
    tvPatientCarePlans.Items.Clear;
    FStoredResultSet := TStringList.Create;
    FLinkedTIUDocs := TStringList.Create;
    sgCarePlanProgress.ColWidths[0] := 200;
    FViewHeight := 400;
    pnlRightBottom.Height := FViewHeight;
    cbShowDetails.Checked := false;
    SetDetailView(cbShowDetails.Checked);
    dtStartDate.DateTime := Now - 365;
    dtEndDate.DateTime := Now+7;
    SetDatePickersVisibility(False);
  end;

  procedure TfrmCarePlan.FormDestroy(Sender: TObject);
  begin
    ClearTV;
    FProbData.Free;
    FStoredResultSet.Free;
    FLinkedTIUDocs.Free;
  end;

  procedure TfrmCarePlan.FormShow(Sender: TObject);
  begin
    tvpatientCarePlans.Selected := tvpatientCarePlans.Items.GetFirstNode;
    if not Assigned(tvpatientCarePlans.Selected) then begin
      btnNewCPClick(Sender);
    end;
    lblCurPatient.Caption := Patient.Name + ' (' + FormatFMDateTime('mmm dd, yyyy', Patient.DOB) + ')';
    Top := frmFrame.top;
    Left := frmFrame.Left;
    Height := frmFrame.Height;
    Width := frmFrame.Width;
    cboDateRange.ItemIndex := 4;     //default range
    cboDateRangeChange(self);
  end;

  procedure TfrmCarePlan.btnFontClick(Sender: TObject);
  begin
    FontDialog1.Font := sgCarePlanProgress.Font;
    if FontDialog1.Execute then begin
      ResetCellHeight;
      sgCarePlanProgress.Font := FontDialog1.Font;
    end;
  end;

procedure TfrmCarePlan.btnLaunchClick(Sender: TObject);
  var CPTemplate: TTemplate;
      CP : TCarePlan;
  begin
    CP := GetTVSelCP;
    if assigned(CP) then CPTemplate := CP.CarePlanTemplate else CPTemplate := nil;
    if assigned(CPTemplate) then begin
      if CP.Active then begin
        InsertText(CP, CPTemplate);
        UpdateResultGrid(CP);
      end else begin
        MessageDlg('You may not update this inactivated care plan.',mtInformation,[mbOK],0);
      end;
    end else begin
      MessageDlg('Nothing selected!',mtInformation,[mbOK],0);
    end;
  end;

  procedure TfrmCarePlan.btnNewCPClick(Sender: TObject);
  var frmCarePlanPicker : TfrmCarePlanPicker;
      Goal, IEN8927, VEFA19008 : string;
      RPCResult : string;
  begin
    frmCarePlanPicker := TfrmCarePlanPicker.Create(Self);
    try
      frmCarePlanPicker.Initialize(FProbData);
      if frmCarePlanPicker.ShowModal = mrOK then begin
        //Get back selected care plan: frmCarePlanPicker.SelectedCarePlan  <-- only valid until frmCarePlanPicker object freed!
        Goal := frmCarePlanPicker.SelectedCarePlan.PrintName;
        Goal := uCarePlan.StripNamespacePartOfName(Goal);
        IEN8927 := frmCarePlanPicker.SelectedCarePlan.ID;
        RPCResult := SaveNewCarePlan(Patient.DFN, Goal, IEN8927, FProbData.ICD);
        VEFA19008 := piece(RPCResult,'^',1);
        if VEFA19008='-1' then begin
          MessageDlg(piece(RPCResult,'^',2),mtError,[mbOK],0);
        end else begin
          Goal := piece(RPCResult,'^',2);
          if piece(RPCResult,'^',3)='ALREADY EXISTS' then begin
            LoadCarePlansToTV;      //if already exists, refresh in case it had to be reactivated
          end else begin
            AddCarePlanToTV(Goal, VEFA19008, IEN8927, True);   //if new, add to tv
          end;
        end;
      end;
    finally
      frmCarePlanPicker.Free;
      tvPatientCarePlansExit(Self);
    end;
  end;

  procedure TfrmCarePlan.btnNavProbClick(Sender: TObject);
  var NavIdx : integer;
  begin
    if not (Sender is TBitBtn) then exit;
    NavIdx := TBitBtn(Sender).Tag;
    SetFormForIdxProb(NavIdx);
    InactivateDetails;
  end;

  procedure TfrmCarePlan.cboActiveProbChange(Sender: TObject);
  begin
    SetFormForIdxProb(cboActiveProb.ItemIndex);
    InactivateDetails;
  end;

  procedure TfrmCarePlan.InactivateDetails;
  begin
    cbShowDetails.Checked := False;
    cbShowDetails.enabled := False;
  end;

  procedure TfrmCarePlan.Initialize(Index : integer; ProblemInfo : TStringList);
  //Input: Line data is the result from the RPC call that populates the one line in the problem list.
  //Format: ifn^Status^description^ICD^onset^Last modified^SC^SpExp^Condition^LOC^Loc.type^Prov^Service
  //NOTE: ifn=IEN in file PROBLEM (#900011)
  //PrevProb and NextProb format: Description^Index
  var i : integer;
  begin
    FProbInfoSL := ProblemInfo;
    cboActiveProb.Items.Clear;
    for i := 0 to ProblemInfo.Count - 1 do begin
      cboActiveProb.Items.Add(FilterControlChars(piece(ProblemInfo.Strings[i],'^',3)));
    end;
    SetFormForIdxProb(Index);
  end;

  procedure TfrmCarePlan.SetFormForIdxProb(Index : integer);
  //Input: Line data is the result from the RPC call that populates the one line in the problem list.
  //Format: ifn^Status^description^ICD^onset^Last modified^SC^SpExp^Condition^LOC^Loc.type^Prov^Service
  //NOTE: ifn=IEN in file PROBLEM (#900011)
  //PrevProb and NextProb format: Description^Index
  var LineData,PrevProb,NextProb : string;
      NextIdx, PrevIdx : integer;
  begin
    ClearResultGrid;
    if (Index < 0) or (Index> FProbInfoSL.Count -1) then begin
      btnLaunch.Enabled := false;
      exit;
    end;
    LineData := FProbInfoSL.Strings[Index];
    FProbData.Initialize(LineData);
    cboActiveProb.ItemIndex := Index;
    Self.Caption := 'Care Plan for ' + FProbData.Description + ' (' + FProbData.ICD + ')';
    cbHideInactive.Checked := true;
    LoadCarePlansToTV;

    NextProb := ''; PrevProb := '';
    if Index>0 then PrevIdx := Index - 1
    else PrevIdx := FProbInfoSL.Count-1;  //looping
    PrevProb := FilterControlChars(piece(FProbInfoSL.Strings[PrevIdx],'^',3)) + '^' + IntToStr(PrevIdx);
    if Index < FProbInfoSL.Count-1 then NextIdx := Index + 1
    else NextIdx := 0;
    NextProb := FilterControlChars(piece(FProbInfoSL.Strings[NextIdx],'^',3)) + '^' + IntToStr(NextIdx);
    SetNavButtons(PrevProb,NextProb);
  end;


  procedure TfrmCarePlan.SetNavButtons(PrevProb,NextProb : string);
  //PrevProb and NextProb format: Description^Index
    procedure SetButton(Btn : TBitBtn; Prob : string);
    var i : integer;
    begin
      i := StrToIntDef(piece(Prob,'^',2),-1);
      if i <> -1 then begin
        btn.Hint := 'Change to: ' + piece(Prob,'^',1);
        btn.ShowHint := true;
        btn.Enabled := true;
      end else begin
        btn.ShowHint := false;
        btn.Enabled := false;
      end;
      btn.Tag := i;
    end;
  begin
    SetButton(btnPrevProb, PrevProb);
    SetButton(btnnextProb, NextProb);
  end;

  procedure TfrmCarePlan.tvPatientCarePlansChange(Sender: TObject; Node: TTreeNode);
  var CP : TCarePlan;
  begin
    CP := GetNodeCP(Node);
    btnLaunch.Enabled := (CP <> nil) and (CP.Active);
    UpdateResultGrid(CP);
    InactivateDetails;
  end;


  procedure TfrmCarePlan.tvPatientCarePlansCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
                                                          State: TCustomDrawState; var DefaultDraw: Boolean);
  begin
    if Node = tvPatientCarePlans.Selected then begin
      tvPatientCarePlans.Canvas.Font.Color := clRed;
    end else begin
      tvPatientCarePlans.Canvas.Font.Color := clBlack;
    end;
    if cdsSelected IN State then begin
      tvPatientCarePlans.Canvas.Font.Color := clWhite;
    end;
  end;

procedure TfrmCarePlan.UpdateResultGrid(CP : TCarePlan);
  var CarePlanResults: TStringList;
      StartDateS, EndDateS : string;
      Result : string;

    procedure GetDateRanges(var StartDateS, EndDateS : string);
    begin
      EndDateS := 'NOW';
      case cboDateRange.ItemIndex of
        DATE_RANGE_ALL    : begin StartDateS := ''; EndDateS := ''; end;
        DATE_RANGE_10Y    : StartDateS := 'T-120M';      //10Y';
        DATE_RANGE_5Y     : StartDateS := 'T-60M';      //5Y';
        DATE_RANGE_2Y     : StartDateS := 'T-24M';      //2Y';
        DATE_RANGE_1Y     : StartDateS := 'T-12M';       //1Y';
        DATE_RANGE_CUSTOM : Begin
                              StartDateS := FloatToStr(DateTimeToFMDateTime(Floor(dtStartDate.Date)));
                              EndDateS := FloatToStr(DateTimeToFMDateTime(Floor(dtEndDate.Date)));
                            end;
      end; {case}
    end;

  begin
    FCarePlanName := '';
    ClearResultGrid;
    if (CP=nil) or (CP.IEN8927='') then begin
      exit;
    end;
    FCarePlanName := CP.Name;
    CarePlanResults := TStringList.Create;
    try
      GetDateRanges(StartDateS,EndDateS);
      GetCarePlanResults(Patient.DFN, CP.IEN8927, StartDateS, EndDateS);  //Temp solution for false UNSIGNED message on third response
      CarePlanResults.Assign(GetCarePlanResults(Patient.DFN, CP.IEN8927, StartDateS, EndDateS));
      if CarePlanResults.Count=0 then exit;
      Result := CarePlanResults.Strings[0];
      if piece(Result,'^',1)='-1' then begin
        MessageDlg(piece(Result,'^',2),mtError,[mbOK],0);
      end else begin
        CarePlanResults.Delete(0);
        FStoredResultSet.Assign(CarePlanResults);
        LoadResultSet(CarePlanResults);
      end;
    finally
      CarePlanResults.Free;
    end;
  end;

  procedure TfrmCarePlan.ClearResultGrid;
  var rowNum,colNum : integer;
  begin
    with sgCarePlanProgress do begin
      for rowNum := 0 to RowCount - 1 do begin
        for colNum := 0 to ColCount - 1 do begin
          Cells[colNum,rowNum] := '';
        end;
      end;

      RowCount := ROW_EMPTY+1;
      ColCount := 2;
      FixedRows := 2;
      FixedCols := 1;
      ColWidths[COL_QUESTION] := DEFAULT_COL_QUESTION_WIDTH + FColWidth.Position;  //VEFA-261

      for rowNum := 0 to RowCount - 1 do begin
        for colNum := 0 to ColCount - 1 do begin
          Cells[colNum,rowNum] := '';
        end;
      end;

      Cells[COL_QUESTION,ROW_DATE] := COL_QUESTION_TEXT;   //'Clinical Item';
      Cells[COL_DATE,ROW_DATE] := COL_DATE_TEXT;           //'Date of Update:';
      Cells[COL_EMPTY,ROW_DATE] := '';

      Cells[COL_PROVIDER,ROW_PROVIDER] := COL_PROVIDER_TEXT;  //'Provider at Update:';
      Cells[COL_PROVIDER+1,ROW_PROVIDER] := '';

      Cells[COL_QUESTION,ROW_EMPTY] := EMPTY_QUESTION;
      Cells[COL_PROVIDER,ROW_EMPTY] := EMPTY_VALUE;
    end;
    FLinkedTIUDocs.Clear;
  end;

  procedure TfrmCarePlan.LoadResultSet(ResultSet: TStringList);
  var i,j :integer ;
      OrderNum : integer;
      Row,Column: integer;
      QuestionS: string;
      ColNames,RowNames : TStringList;
      DataLabel,DataDate,DataValue,DataIENS,DataAuthor,DataIEN8925 : String;

    procedure AddRow(OrderNum : integer; QuestionS: string);
    var OrderIndex : integer;
        colNum : integer;
    begin
      OrderIndex := OrderNum-1+ROW_EMPTY;
      with sgCarePlanProgress do begin
        if OrderIndex > RowCount-1 then begin
          RowCount := OrderIndex+1;
        end;
        for colNum := 0 to ColCount - 1 do Cells[colNum,OrderIndex] := ''; //clear any residual data
        Cells[COL_QUESTION,OrderIndex] := StringReplace(QuestionS,'&','&&',[rfReplaceAll]);
      end;
      //server should be ensuring that all names are unique.
      RowNames.Values[QuestionS] := IntToStr(OrderIndex);
    end;

    function AddCol(DateS,ColIENS : string) : integer;
    begin
      with sgCarePlanProgress do begin
        if (ColCount=2) and (Cells[1,ROW_DATE]='') then begin
          // do nothing
        end else begin
          ColCount := ColCount + 1;
          ColWidths[ColCount-1] := ColWidths[ColCount-2];
        end;
        Result := ColCount-1;
        Cells[Result,ROW_DATE]:= DateS;
        ColNames.Values[ColIENS] := IntToStr(Result);
      end;
    end;

    function FMStrToDate(FMDateS : string) : TDateTime;
    var FMDate : TFMDateTime;
    begin
      FMDate := StrToFloatDef(FMDateS,0);
      Result := FMDateTimeToDateTime(FMDate);
    end;

    function FMStrToDateS(FMDateS : string) : string;
    var DT : TDateTime;
    begin
      if FMDateS <> '' then begin
        DT := FMStrToDate(FMDateS);
        Result := DateToStr(DT);
        //Use if time wanted -> Result := FormatDateTime('mm/dd/yy hh:mm:ss',DT);
      end else begin
        Result := '?';
      end;
    end;

  var
    startNum,endNum,Dir : integer;
  const NO_DATA = '(No Data)';
  begin
    ClearResultGrid;
    if ResultSet.Count = 0 then begin
      sgCarePlanPRogress.Cells[1,0] := NO_DATA;
      exit;
    end;
    ColNames := TStringList.Create;
    RowNames := TStringList.Create;
    try
      //First handle the [ORDER] lines
      for i := 0 to ResultSet.Count - 1 do begin
        if Piece(ResultSet.Strings[i],'^',1)='[ORDER]' then begin
          OrderNum := StrToInt(Piece(ResultSet.Strings[i],'^',2));
          QuestionS := Piece(ResultSet.Strings[i],'^',3);
          if QuestionS = 'SCAN NEEDED' then continue;
          AddRow(OrderNum,QuestionS);
        end;
      end;
      //Now delete the [ORDER] lines
      for i := ResultSet.Count - 1 downto 0 do begin
        if Piece(ResultSet.Strings[i],'^',1)='[ORDER]' then ResultSet.Delete(i);
      end;
      //Now handle rest of lines in reverse order (making most recent to be on left
      if ResultSet.Count>0 then begin
        if cbRecentOnLeft.Checked then begin
          startNum := ResultSet.Count - 1;
          endNum := 0;
          Dir := -1;
        end else begin
          startNum := 0;
          endNum := ResultSet.Count - 1;
          Dir := 1;
        end;
        i := startNum;
        while ((((i>=startNum) and (i <= endNum))) or (((i>=endNum) and (i <= startNum)))) do begin
          //String is: DataLabel^FMDate^Value^Value_IENS^Author^IEN8925
          DataLabel := Piece(ResultSet.Strings[i],'^',1);
          DataDate := FMStrToDateS(Piece(ResultSet.Strings[i],'^',2));
          DataValue := Piece(ResultSet.Strings[i],'^',3);
          DataIENS := Piece(ResultSet.Strings[i],'^',4);
          DataIENS := Pieces2(DataIENS,',',2,4);
          DataAuthor := Piece(ResultSet.Strings[i],'^',5);
          DataIEN8925 := Piece(ResultSet.Strings[i],'^',6);
          Column := StrToIntDef(ColNames.Values[DataIENS],-1);
          if Column=-1 then Column := AddCol(DataDate,DataIENS);
          if Column<>-1 then begin
            Row := StrToIntDef(RowNames.Values[DataLabel],-1);
            if Row <> -1 then begin
              sgCarePlanProgress.Cells[Column,Row] := DataValue;
              sgCarePlanProgress.Cells[Column,ROW_PROVIDER] := DataAuthor;
              while FLinkedTIUDocs.Count-1 < Column do FLinkedTIUDocs.Add('');
              FLinkedTIUDocs.Strings[Column] := DataIEN8925;
            end else if DataLabel = 'SCAN NEEDED' then begin
              for j := 1 to sgCarePlanProgress.RowCount-1 do begin
                if sgCarePlanProgress.Cells[Column,j]= '' then begin
                  sgCarePlanProgress.Cells[Column,j] := NOTE_UNSIGNED;
                end;
              end;
            end;
          end;
          i := i + Dir;
        end;
      end else begin
        sgCarePlanPRogress.Cells[1,0] := NO_DATA;
      end;
    finally
      ColNames.Free;
      RowNames.Free;
    end;
  end;

  procedure TfrmCarePlan.tvPatientCarePlansEnter(Sender: TObject);
  begin
    tvPatientCarePlansChange(Sender, tvPatientCarePlans.Selected);
  end;

  procedure TfrmCarePlan.tvPatientCarePlansExit(Sender: TObject);
  begin
    //btnLaunch.Enabled := false;
  end;

  function TfrmCarePlan.GetTemplateForSelectedCarePlan : TTemplate;
  var CP : TCarePlan;
  begin
    Result := nil;
    CP := GetTVSelCP;
    if assigned(CP) then Result := CP.GetCarePlanTemplate;
  end;

  procedure TfrmCarePlan.ClearTV;
  var i : integer;
      CP : TCarePlan;
  begin
    for i := 0 to tvPatientCarePlans.Items.count - 1 do begin
      CP := TCarePlan(tvPatientCarePlans.Items[i].Data);
      if not assigned(CP) then continue;
      CP.Free;
    end;
    for i := tvPatientCarePlans.Items.count - 1 downto 0 do begin
      tvPatientCarePlans.Items[i].Delete;
    end;
  end;

  procedure TfrmCarePlan.AddCarePlanToTV(Name, VEFA19008, IEN8927 : string; Active : boolean);
  var CP : TCarePlan;
  begin
    CP := TCarePlan.Create(Active);
    CP.Name := Name;
    CP.VEFA19008 := VEFA19008;
    CP.IEN8927 := IEN8927;
    CP.TreeNode := tvPatientCarePlans.Items.AddObject(nil,CP.PrintName,CP);  //TV owns TCarePlan objects
  end;

  function TfrmCarePlan.GetTVSelCP : TCarePlan;
  begin
    Result := GetNodeCP(tvPatientCarePlans.Selected);
  end;

  function TfrmCarePlan.GetNodeCP(Node : TTreeNode) : TCarePlan;
  begin
    Result := nil;
    if not assigned(Node) then exit;
    Result := TCarePlan(Node.Data);
  end;

  procedure TfrmCarePlan.InsertText(CP : TCarePlan; CPTemplate : TTemplate);
  //from fDrawers
  var
    BeforeLine, AfterTop: integer;
    txt, DocInfo, RPCResult: string;
    frmCarePlanSignDialog: TfrmCarePlanSignDialog;
    DBControlData : TDBControlData;

  begin
    try
      TMGForcePlainTextEditMode := True;   //kt only works once. Effects TfrmNotes.InsertNewNote
      DocInfo := '';
      if not InsertOK(TRUE) then exit;   //This will set up FRichEditControl.  If true, then FRichEditControl is set up.
      if not CarePlanOK(CPTemplate) then exit;
      if not AvoidDuplicateDataIfCarePlan(FRichEditControl, CPTemplate.PrintName) then exit;
      CPTemplate.TemplatePreviewMode:= FALSE;
      DBControlData := TDBControlData.Create; //kt added 5/16
      if CPTemplate.IsReminderDialog then begin
        CPTemplate.ExecuteReminderDialog(TForm(Owner))
      end else begin
        if CPTemplate.IsCOMObject then begin
          txt := CPTemplate.COMObjectText('', DocInfo)
        end else begin
          //kt original --> txt := CPTemplate.Text;
          txt := CPTemplate.GetText(DBControlData);
        end;
        if(txt <> '') then begin
          CheckBoilerplate4Fields(txt, 'Template: ' + CAREPLAN_TAG + '-' + CP.PrintName, [], DBControlData);
          if txt <> '' then begin
            IndentMemoTextIfCarePlan(CP_TEMPLATE_TAG + CPTemplate.PrintName, txt, FRichEditControl);   //VEFA-261   5/6/11
            BeforeLine := SendMessage(FRichEditControl.Handle, EM_EXLINEFROMCHAR, 0, FRichEditControl.SelStart);
            FRichEditControl.SelText := txt;
            SendMessage(FRichEditControl.Handle, EM_SCROLLCARET, 0, 0);
            AfterTop := SendMessage(FRichEditControl.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
            SendMessage(FRichEditControl.Handle, EM_LINESCROLL, 0, -1 * (AfterTop - BeforeLine));
            SpeakTextInserted;
            RPCResult := UpdateCarePlan(CP.VEFA19008, FTargetDocIEN8925);
            if Piece(RPCResult,'^',1) = '-1' then begin
              MessageDlg('Error saving TIU Document Information to CarePlan:'+#13#10+
                          #13#10+
                          Piece(RPCResult,'^',2),
                          mtError,[mbOK],0);
            end else begin
              frmCarePlanSignDialog := TfrmCarePlanSignDialog.Create(Self);  //kt 10/15
              //MessageDlg('Information has been inserted into active ' + RE_TARGET_NAME[RichEditFound] + ' document.'+#13#10+
              //           'Values will appear in grid after note has been signed.',mtInformation,[mbOK],0);
              frmCarePlanSignDialog.FormLabel.Caption := 'Information has been inserted into active ' + RE_TARGET_NAME[RichEditFound] + ' document.'+#13#10+#13#10+
                                                         'Values will appear in grid after note has been signed.';
              if frmCarePlanSignDialog.ShowModal = mrYes then begin
                 self.hide;
                 frmFrame.SetActiveTab(CT_NOTES);
                 frmNotes.ExternalSign;
                 self.show;
              end;
              frmCarePlanSignDialog.Free;  //kt 10/15
            end;
          end;
        end;
      end;
    finally
      DBControlData.MsgNoSave;
      DBControlData.Free;
    end;
  end;

  function TfrmCarePlan.InsertOK(Ask: boolean): boolean;

    function REOK(ARichEditControl : TRichEdit): boolean;
    begin
      Result := assigned(ARichEditControl) and
                ARichEditControl.Visible and
                ARichEditControl.Parent.Visible;
    end;

    function HTMLOK(AHTMLEditControl : THTMLObj): boolean;
    begin
      Result := assigned(AHTMLEditControl) and
                AHTMLEditControl.Visible;
    end;

  var
    i: tTargetRE;
    NewNoteButton : TButton;
    tempLoc : string;

  begin
    Result := false;  //default
    RichEditFound := tgNone;
    FDrawers := nil;
    FRichEditControl := nil;
    FTargetDocIEN8925 := '0';
    //VEFA-261 First see if there is already a note open.  If so, will insert CarePlan there.
    for i := tgtNotes to tgSurgery do begin
      FDrawers := nil;
      case i of
        tgtNotes   : if assigned(frmNotes)    then begin
                       FDrawers := frmNotes.Drawers;
                       tempLoc := 'progress notes';
                       FTargetDocIEN8925 := IntToStr(frmNotes.ActiveEditIEN);
                     end;
        tgConsults : if assigned(frmConsults) then begin
                       FDrawers := frmConsults.Drawers;
                       tempLoc := 'consults';
                       FTargetDocIEN8925 := IntToStr(frmConsults.ActiveEditIEN);
                     end;
        tgDCSumm   : if assigned(frmDCSumm)   then begin
                       FDrawers := frmDCSumm.Drawers;
                       tempLoc := 'discharge summary';
                       FTargetDocIEN8925 := IntToStr(frmDCSumm.ActiveEditIEN);
                     end;
        tgSurgery  : if assigned(frmSurgery)  then begin
                       FDrawers := frmSurgery.Drawers;
                       tempLoc := 'surgical report';
                       FTargetDocIEN8925 := IntToStr(frmSurgery.ActiveEditIEN);
                     end;
      end; {case}
      if not assigned(FDrawers) then continue;
      if (FTargetDocIEN8925 <> '0') and (REOK(FDrawers.RichEditControl) OR HTMLOK(FDrawers.HTMLEditControl)) then begin
        RichEditFound := i;
        FRichEditControl := FDrawers.RichEditControl;
        Result := true;
        Break;
      end;
    end;
    if RichEditFound = tgNone then begin
      //No open note, so see if can add to Notes tab
      if not assigned(frmNotes) then exit;  //leave result at FALSE
      FDrawers := frmNotes.Drawers;
      if not assigned(FDrawers) then exit;   //leave result at FALSE
      NewNoteButton := FDrawers.NewNoteButton;
      if not assigned(NewNoteButton) then exit;
      FRichEditControl := FDrawers.RichEditControl;
      if (ask <> true) then exit;
      if (not NewNoteButton.Visible) or (not NewNoteButton.Enabled) then exit;
      try
        NewNoteButton.Click;
      except
        on E:EInvalidOperation do begin
          if E.Message <> 'Cannot focus a disabled or invisible window' then raise;
        end;
      end;
      Result := REOK(FDrawers.RichEditControl);
      if Result=True then begin
        RichEditFound := tgtNotes;
        FTargetDocIEN8925 := IntToStr(frmNotes.ActiveEditIEN);
      end;
    end;
  end;


  function TfrmCarePlan.CarePlanOK(CP : TTemplate; Msg: string = ''): boolean;
  //From dShared
  var
    Err: TStringList;
    btns: TMsgDlgButtons;

  begin
    Err := nil;
    try
      Result := dmodShared.BoilerplateOK(CP.FullBoilerplate, #13, nil, Err);
      if(not Result) then begin
        if(Msg = 'OK') then begin
          btns := [mbOK]
        end else begin
          btns := [mbAbort, mbIgnore];
          Err.Add('');
          if(Msg = '') then begin
            Msg := 'care plan insertion';
          end;
          Err.Add('Do you want to Abort '+Msg+', or Ignore the error and continue?');
        end;
        Result := (MessageDlg(Err.Text, mtError, btns, 0) = mrIgnore);
      end;
    finally
      if(assigned(Err)) then
        Err.Free;
    end;
    if Result then begin
      Result := BoilerplateTemplateFieldsOK(CP.FullBoilerplate, Msg);
    end;
  end;

  procedure TfrmCarePlan.cbHideInactiveClick(Sender: TObject);
  begin
    LoadCarePlansToTV;
  end;

  procedure TfrmCarePlan.SetDatePickersVisibility(Visible : boolean);
  begin
    dtStartDate.Visible := Visible;
    dtEndDate.Visible := Visible;
    lblTo.Visible := Visible;
  end;

procedure TfrmCarePlan.cboDateRangeChange(Sender: TObject);
  var Visible : boolean;
      //CPTemplate: TTemplate;
      CP : TCarePlan;
  begin
    Visible := (cboDateRange.ItemIndex = DATE_RANGE_CUSTOM);
    SetDatePickersVisibility(Visible);
    CP := GetTVSelCP;
    if assigned(CP) then begin
      UpdateResultGrid(CP);  //update grid display.
    end;
  end;

  procedure TfrmCarePlan.cbRecentOnLeftClick(Sender: TObject);
  var CarePlanResults : TStringList;
  begin
    CarePlanResults := TStringList.Create;
    try
      CarePlanResults.Assign(FStoredResultSet);
      LoadResultSet(CarePlanResults);
    finally
      CarePlanResults.Free
    end;
  end;

  procedure TfrmCarePlan.cbShowDetailsClick(Sender: TObject);
  begin
    SetDetailView(cbShowDetails.Checked);
  end;

  procedure TfrmCarePlan.LoadCarePlansToTV;
  var TempCarePlans: TStringList;
      VEFA19008, IEN8927, GoalName,InactiveStatus : string;
      i : integer;
  begin
    ClearTV;
    TempCarePlans := TStringList.Create;
    try
      ReadCarePlans(Patient.DFN, FProbData.ICD, not cbHideInactive.Checked, TempCarePlans);
      //User RPC to populate TV;
      for i := 1 to TempCarePlans.Count - 1 do begin
        VEFA19008 := Piece(TempCarePlans[i],'^',1);
        IEN8927 := Piece(TempCarePlans[i],'^',2);
        GoalName := Piece(TempCarePlans[i],'^',3);
        InactiveStatus := Piece(TempCarePlans[i],'^',4);
        AddCarePlanToTV(GoalName, VEFA19008, IEN8927, (InactiveStatus<>'1'));
      end;
      tvpatientCarePlans.Selected := tvpatientCarePlans.Items.GetFirstNode;
    finally
      TempCarePlans.Free;
    end;
  end;

  procedure TfrmCarePlan.mnuDeleteTVItemClick(Sender: TObject);
  var
    CP : TCarePlan;
    DelResult : string;
  begin
    CP  := GetTVSelCP;
    //MessageDlg('Here I will 1)See if care plan has results, and 2) call RPC to delete if none.',mtInformation,[mbOK],0);
    DelResult := DeleteCarePlan(CP.VEFA19008);
    if Piece(DelResult,'^',1)='1' then begin
      LoadCarePlansToTV;
    end else begin
      MessageDlg('Cannot delete careplan:'+#13#10+Piece(DelResult,'^',2),mtError,[mbOK],0);
    end;
  end;

  procedure TfrmCarePlan.mnuInactivateTVItemClick(Sender: TObject);
  begin
    SetActiveStatusOfCarePlan(False);
  end;

  procedure TfrmCarePlan.mnuReactivateCarePlanClick(Sender: TObject);
  begin
    SetActiveStatusOfCarePlan(True);
  end;

  procedure TfrmCarePlan.SetActiveStatusOfCarePlan(Active : boolean);
  var CP : TCarePlan;
  begin
    CP  := GetTVSelCP;
    if not assigned(CP) then exit;
    if CP.Active = Active then exit; //no change needed
    if CP.SetActiveStatus(Active) then begin
      LoadCarePlansToTV;
    end
  end;


  procedure TfrmCarePlan.sgCarePlanProgressMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  //Max columns 2....x all as wide as the largest width.
  var col : integer;
      widthA,widthB : integer;
      countA,countB : integer;
      //colA,colB : integer;
      NewWidth : integer;
      ACol,ARow : integer;
      Resized : boolean;
      recTemp : TGridRect;
  begin
    sgCarePlanProgress.MouseToCell(X,Y,ACol,ARow);
    Resized := false;
    if ARow<2 then begin
      //Look for 1 column that is different.
      widthA:=0; widthB := 0;
      countA := 0; countB := 0;
      for Col := 1 to sgCarePlanProgress.ColCount - 1 do begin
        if countA=0 then begin
          widthA := sgCarePlanProgress.ColWidths[Col];
          inc(countA);
        end else if sgCarePlanProgress.ColWidths[Col] = widthA then begin
          inc(countA);
        end else if countB=0 then begin
          widthB := sgCarePlanProgress.ColWidths[Col];
          inc(countB);
        end else if sgCarePlanProgress.ColWidths[Col] = widthB then begin
          inc(CountB);
        end;
      end;
      if (countB>countA) or (countB=0) then begin
        NewWidth := widthA;
      end else begin
        NewWidth := widthB;
      end;
      for Col := 1 to sgCarePlanProgress.ColCount - 1 do begin
        if sgCarePlanProgress.ColWidths[Col] <> NewWidth then begin
          sgCarePlanProgress.ColWidths[Col] := NewWidth;
          Resized := true;
        end;
      end;
      if not Resized then begin
        if (ACol > 0) then begin
          recTemp.Left := ACol;
          recTemp.Top := 0;
          recTemp.Right := ACol;
          recTemp.Bottom := sgCarePlanProgress.RowCount;
          sgCarePlanProgress.Selection := recTemp;
          ColumnSelected(ACol);
        end else begin
          ColumnSelected(-1);
        end;
      end;
    end else begin
      //Here a row will have been selected.
      ColumnSelected(-1);
      if ACol < sgCarePlanProgress.FixedCols then begin  //have to manually select row with click on fixed portion.
        recTemp.Left := 0;
        recTemp.Top := ARow;
        recTemp.Right := sgCarePlanProgress.ColCount;
        recTemp.Bottom := ARow;
        sgCarePlanProgress.Selection := recTemp;
      end;

    end;
  end;

  procedure TfrmCarePlan.ColumnSelected(ColNum : integer);
  begin
    FSelectedColumn := ColNum;
    cbShowDetails.Enabled := (ColNum >= 0);
    SetDetailView(cbShowDetails.Checked and cbShowDetails.Enabled);
  end;

  procedure TfrmCarePlan.SetDetailView(Show : boolean);
  var IEN8925 : string;
  begin
    if not Show then begin
      if pnlRightBottom.Height > 0 then FViewHeight := pnlRightBottom.Height;
      pnlRightBottom.Height := 0;
      DetailsRE.Clear;
    end else begin // show document
      if FViewHeight<1 then FViewHeight := 400;
      if pnlRightBottom.Height<FViewHeight then pnlRightBottom.Height := FViewHeight;
      if FSelectedColumn > FLinkedTIUDocs.Count-1 then exit;
      IEN8925 := FLinkedTIUDocs.Strings[FSelectedColumn];
      if IEN8925='' then exit;
      ShowDocument(IEN8925, FCarePlanName);
    end;
  end;

  procedure TfrmCarePlan.popmnuCarePlanTVPopup(Sender: TObject);
  var FSelCarePlanTemplate: TTemplate;
      CP : TCarePlan;
  begin
    CP  := GetTVSelCP;
    if assigned(CP) then begin
      FSelCarePlanTemplate := CP.GetCarePlanTemplate;
    end else begin
     FSelCarePlanTemplate := nil;
    end;
    mnuInactivateTVItem.Enabled := (FSelCarePlanTemplate <> nil) and CP.Active;
    mnuDeleteTVItem.Enabled := (FSelCarePlanTemplate <> nil);
    mnuReactivateCarePlan.Enabled := (FSelCarePlanTemplate <> nil) and not CP.Active
  end;


  procedure TfrmCarePlan.DrawSGCell(Sender : TObject;
                                     ACol, ARow : integer;
                                     Rect : TRect;
                                     Style : TFontStyles; //Set of fsBold, fsItalic, fsUnderline and fsStrikeOut;
                                     Wrap : boolean;      //Invokes word wrap for the cell's text;
                                     Just : TAlignment;   //taLeftJustify, taRightJustify or taCenter
                                     CanEdit : boolean);  //if false, cell will be given the background color of fixed cells
    //Draw formatted contents in string grid cell at col ACol, row ARow;
    //Call this routine from grid's DrawCell event

   function JOption(Just : TAlignment) : integer;
   begin
     case Just of
       taLeftJustify  : Result := dt_left;
       taCenter       : Result := dt_center;
       taRightJustify : Result := dt_right;
       else Result := 0;
     end;
   end;

   const
     TOP_SPACING = 4;
     LEFT_SPACING = 4;
     BOTTOM_SPACING = 4;

  var
    S        : string;
    DrawRect : TRect;
  begin
    with (Sender as tStringGrid), Canvas do begin
      FillRect(Rect); //Erase earlier contents from default drawing
      S:= Cells[ACol, ARow]; //  get cell contents }
      if length(S) > 0 then begin
        Font.Style:= Style;
        DrawRect:= Rect;  //copy of cell rectangle for text sizing
        DrawRect.Left := DrawRect.Left + LEFT_SPACING; //Avoid crowding against cell boundries
        DrawRect.Top := DrawRect.Top + TOP_SPACING;
        if Wrap then begin  // Get size of text rectangle in DrawRect, with word wrap
          DrawText(Handle, PChar(S), length(S), DrawRect, dt_calcrect or dt_wordbreak or dt_center);
          if (DrawRect.Bottom - DrawRect.Top) > RowHeights[ARow] then begin
            RowHeights[ARow]:= DrawRect.Bottom - DrawRect.Top + TOP_SPACING + BOTTOM_SPACING;  //Cell word-wraps; increase row height
          end else begin   //cell doesn't word-wrap
            DrawRect.Right:= Rect.Right;
            FillRect(DrawRect);
            DrawText(Handle, PChar(S), length(S), DrawRect, dt_wordbreak or JOption(Just));
          end
        end else begin  //no word wrap
          DrawText(Handle, PChar(S), length(S), DrawRect, dt_singleline or dt_vcenter or JOption(Just));
          Font.Style:= [];  //restore no font styles
        end;
      end;
    end;
  end;


  procedure TfrmCarePlan.dtEndDateChange(Sender: TObject);
  begin
    if dtEndDate.DateTime < dtStartDate.DateTime then begin
      MessageDlg('Ending Date must not be less than Start Date',mtError,[mbOK],0);
      dtEndDate.DateTime := dtStartDate.DateTime + 1;
    end else begin
      cboDateRangeChange(nil);
    end;
  end;

  procedure TfrmCarePlan.dtStartDateChange(Sender: TObject);
  begin
    if dtStartDate.DateTime > dtEndDate.DateTime then begin
      MessageDlg('Starting Date must not be greater than Ending Date',mtError,[mbOK],0);
      dtStartDate.DateTime := dtEndDate.DateTime -1;
    end else begin
      cboDateRangeChange(nil);
    end;
  end;

procedure TfrmCarePlan.sgCarePlanProgressDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
  begin
    DrawSGCell(Sender, ACol, ARow, Rect, [], true, taLeftJustify, false);
  end;

  procedure TfrmCarePlan.ResetCellHeight;
  var RowNum : integer;
  begin
    for RowNum := 0 to sgCarePlanProgress.RowCount - 1 do begin
      sgCarePlanProgress.RowHeights[RowNum] := sgCarePlanProgress.DefaultRowHeight;
    end;
  end;

  procedure TfrmCarePlan.ShowDocument(IEN8925 : string; CarePlanName: string);
  var NoteText : TStringList;
      Format: CHARFORMAT2;
      CPHeader,CPFooter: string;
      BegPos,EndPos : integer;
      Pos: TPoint;
      LineNo : integer;
  begin
    CPHeader := CP_TEMPLATE_TAG+CarePlanName;
    CPFooter := ENDOF_TAG+CP_TEMPLATE_TAG+CarePlanName+CP_BRACKET_CLOSE;

    FillChar(Format, sizeof(Format), 0);
    Format.cbsize := Sizeof(Format);
    Format.dwMask := CFM_BACKCOLOR;

    NoteText := TStringList.Create;

    try
      LoadDocumentText(NoteText,StrToIntDef(IEN8925,-1));
      DetailsRE.Lines.Assign(NoteText);
      BegPos := DetailsRE.FindText(CPHeader,0,strlen(PChar(DetailsRE.Text)),[]);
      EndPos := DetailsRE.FindText(CPFooter,0,strlen(PChar(DetailsRE.Text)),[]);
    finally
      NoteText.Free;
    end;
    if (Begpos = -1)OR(EndPos = -1) then exit;
    //Get lines' beginning and ending points
    LineNo := DetailsRE.Perform(EM_LINEFROMCHAR,BegPos,0);
    BegPos := DetailsRE.Perform(EM_LINEINDEX,LineNo,0);

    LineNo := DetailsRE.Perform(EM_LINEFROMCHAR,EndPos,0);
    EndPos := DetailsRE.Perform(EM_LINEINDEX,LineNo,0);
    EndPos := DetailsRE.FindText(#10,Endpos,$7FFFFFFF,[]);

    //Highlight CarePlan
    DetailsRE.SelStart := BegPos;
    DetailsRE.SelLength := Endpos-BegPos;
    Format.crBackColor := clWebYellow;
    DetailsRE.Perform(EM_SETCHARFORMAT, SCF_SELECTION, LongInt(@Format));

    //Set first line to beginning of CarePlan
    Pos.Y := DetailsRE.Perform(EM_LINEFROMCHAR,DetailsRE.SelStart,0);
    DetailsRE.Perform(EM_LINESCROLL,0,Pos.Y);
    //VEFA-261
  end;

end.

