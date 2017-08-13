unit uLogic;
//kt 9/11 Added unit
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
  Dialogs, StdCtrls, Buttons, ExtCtrls, ORNet, ORFn,ComCtrls,Trpcb, ORCtrls;


const
   INT_COMPONENT_SPACING = 4;
   INT_CBO_CONDITIONLEFT = 3;
   INT_CBO_CONDITIONWIDTH = 50;

   INT_CBO_FILELEFT = INT_CBO_CONDITIONLEFT + INT_CBO_CONDITIONWIDTH + INT_COMPONENT_SPACING;
   INT_CBO_FILEWIDTH = 177;

   INT_CBO_FIELDLEFT = INT_CBO_FILELEFT + INT_CBO_FILEWIDTH + INT_COMPONENT_SPACING;
   INT_CBO_FIELDWIDTH = 177;

   INT_CBO_OPERATORLEFT = INT_CBO_FIELDLEFT + INT_CBO_FIELDWIDTH + INT_COMPONENT_SPACING;
   INT_CBO_OPERATORWIDTH = 113;

   INT_EDIT_VALUELEFT = INT_CBO_OPERATORLEFT + INT_CBO_OPERATORWIDTH + INT_COMPONENT_SPACING;
   INT_EDIT_VALUEWIDTH = 169;

   INT_EDIT_LOWERLEFT = INT_CBO_OPERATORLEFT + INT_CBO_OPERATORWIDTH + INT_COMPONENT_SPACING;
   INT_EDIT_LOWERWIDTH = 100;

   INT_EDIT_UPPERLEFT = INT_EDIT_LOWERLEFT + INT_EDIT_LOWERWIDTH + INT_COMPONENT_SPACING;
   INT_EDIT_UPPERWIDTH = 100;

   INT_BUTTON_LEFT = INT_EDIT_VALUELEFT + INT_EDIT_VALUEWIDTH + INT_COMPONENT_SPACING;
   INT_BUTTON_SIZE = 23;

   INT_ADD_QUERYROW_BTN_LEFT = INT_CBO_CONDITIONLEFT;
   INT_ADD_QUERYROW_LABEL_LEFT = INT_ADD_QUERYROW_BTN_LEFT + 30;
   INT_ADD_QUERYROW_LABEL_CAPTION = 'Add another term to query';

   TAG_FILE_BOX = 0;
   TAG_FIELD_BOX = 1;
   TAG_RECORD_BOX = 2;

   LABEL_LEFT_OFFSET = 2;
   FIELDS_TOP_OFFSET = 30;
   INDENT_OFFSET = 30;
   OPEN_BOX_HEIGHT = 120;
   OPERATOR_BOX_HEIGHT = 150;
   CLOSE_BOX_HEIGHT = 21;
   ROW_HEIGHT = 30;
   ADD_QUERY_OFFSET = OPEN_BOX_HEIGHT + INT_COMPONENT_SPACING;

   CL_LT_RED = $6C6CBA;
   Colors : Array[false..true] of TColor = (clWindow, CL_LT_RED);
   SearchCaption : Array[false..true,false..true] of String[30] = (
     ('Search Value', 'Enter Lower ... Upper Value'),     //Advanced Mode
     ('Enter Value to Search For', 'Enter Lower && Upper Values')   //Simple Mode
   );

   COMB_EQUALS                   =  '=^= EQUALS';
   COMB_NOT_EQUAL                =  '''=^<>, DOES NOT EQUAL';
   COMB_LESS_THAN                =  '<^<, LESS THAN';
   COMB_LESS_THAN_OR_EQUALS      =  '<=^<=, LESS THAN OR EQUAL TO';
   COMB_GREATER_THAN             =  '>^>, GREATER THAN';
   COMB_GREATER_THAN_OR_EQUALS   =  '>=^>=, GREATER OR EQUAL TO';
   COMB_IN_RANGE                 =  '{^IN RANGE';
   COMB_NOT_IN_RANGE             =  '''{^NOT IN RANGE';
   COMB_CONTAINS                 =  '[^CONTAINS';
   COMB_NOT_CONTAINS             =  '''[^DOES NOT CONTAIN';


type
  TValueMode = (vmUnknown,vmString,vmDate,vmNumeric,vmRange,vmSet,vmPointer);
  TFieldDataType = (fdtUnknown,fdtText,fdtSet,fdtDate,fdtWP,fdtPointer);

  TLogicSet = class;  //a forward
  TLogicRow = class(TObject)
  private
    { Private declarations }
    FIndentLevel : integer;
    FSearchValueMode : TValueMode;
    FSearchFileNumber : string;
    FSearchFileName : string;
    FParentSet : TLogicSet;
    FRowNum : integer;  //starts numbering at 0
    FCurFieldDef : string;
    FInfoPiece3 : string;
    FVisible : boolean;
    FTop : integer;
    FSimpleMode : boolean;
    FNewGroupStarter : boolean;
    ValueEdit: TEdit;   //Will double as Lower value if entering a range.
    UpperValueEdit: TEdit;
    DatePicker : TDateTimePicker;
    UpperDatePicker : TDateTimePicker;
    SetPicker : TComboBox;
    RecordPickerBox : TORComboBox;
    DelButton : TSpeedButton;
    FRowOpen : boolean;
    procedure SetIndentLevel(Value : integer);
    procedure LoadOperator(CmbBox: TORComboBox);
    procedure LoadCondition(CmbBox: TORComboBox);
    procedure ConditionChange(Sender: TObject);
    procedure DelButtonClick(Sender : TObject);
    procedure ORBoxNeedData(Sender: TObject; const StartFrom: String;
                            Direction, InsertAt: Integer);
    procedure FileBoxChange(Sender: TObject);
    function SubSetOfAllowedFiles(SimpleMode : boolean;
                                  FileNum: string; const StartFrom: string;
                                  Direction: Integer       ): TStrings;
    function SubSetOfFile(FileNum: string; const StartFrom: string;
                          Direction: Integer       ): TStrings;
    procedure FieldBoxChange(Sender: TObject);
    procedure RecordPickerBoxChange(Sender: TObject);
    procedure DatePickerChange(Sender: TObject);
    procedure OperatorBoxChange(Sender: TObject);
    procedure EditBoxChange(Sender: TObject);
    procedure SetPickerChange(Sender: TObject);
    function SubSetOfFields(SimpleMode : boolean; FileNum: string;
                            const StartFrom: string; Direction: Integer): TStrings;
    function ExtractNum (S : String; StartPos : integer) : string;
    procedure EnsureProperValueFieldVisible;
    function IsWPField(FileNum,FieldNum : string) : boolean;
    procedure InitORComboBox(ORComboBox: TORComboBox; initValue : string; boxtype : string);
    function GetSearchValue() : string;
    procedure SetVisible(Value : Boolean);
    procedure PrepSetPicker(setDef : string);
    procedure SetNewGroupStarter(value : boolean);
    procedure SetRowNum(value : integer);  //This won't change position in parent LogicSet
    procedure CheckVisibilityIsCorrect;
    procedure SetSimpleMode(Value : boolean);
    procedure SetRowColor(Color : TColor);
    procedure SetSearchLabelCaption;
    procedure SelectOperator(OperatorLine : string);
  public
    { Public declarations }
    ConditionBox: TORComboBox;
    FileBox: TORComboBox;
    FieldBox: TORComboBox;
    OperatorBox: TORComboBox;
    OnSearchStringChange : TNotifyEvent;
    OnRangeModeChange : TNotifyEvent;
    constructor Create(SearchFileNumber,SearchFileName : string;
                       SimpleMode : Boolean;
                       AParent : TWinControl; AParentSet : TLogicSet; Row : integer);
    Destructor Destroy;
    procedure CloseRow;
    procedure OpenRow;
    function GetFieldDataType : TFieldDataType;
    function GetFileNum : string;
    function GetFieldNum : string;
    function IsValid : boolean;
    function GetSearchString(var LastFileNum : string) : string;
    procedure IndentMore;
    procedure IndentLess;
    procedure Clear;
    procedure SetFile(FileNumber,FileName : string);
    property IndentLevel : integer read FIndentLevel write SetIndentLevel;
    property SearchValueMode : TValueMode read FSearchValueMode;
    property SearchValue : string read GetSearchValue;
    property Visible : boolean read FVisible write SetVisible;
    property NewGroupStarter : boolean read FNewGroupStarter write SetNewGroupStarter;
    property Top : integer read FTop;
    property RowNum : integer read FRowNum write SetRowNum;
    Property SimpleMode : boolean read FSimpleMode write SetSimpleMode;
    property RowOpen : boolean read FRowOpen;
  end;

  TLogicSet = class (TObject)
  private
    { Private declarations }
    Rows : TList;
    FSearchFileNumber : string;
    FSearchFileName : string;
    FSearchString : string;
    FParent : TWinControl;
    FOwner : TComponent;
    FSimpleMode : boolean;
    FFileNumsStack : TStringList;  //Will act as stack of filenumbers, based on indent level
    lblAddAnother: TLabel;
    btnIndentLess: TButton;
    btnIndentMore: TButton;
    function GetRow(Index : integer): TLogicRow;
    procedure Handle1RowChange(Sender : TObject);
    function GetSearchString : string;
    function GetRowCount : integer;
    procedure HandleIndentMore(Sender : TObject);
    procedure HandleIndentLess(Sender : TObject);
    procedure HandleAddQuery(Sender : TObject);
    procedure UpdateButtonPlacement;
    procedure SetSimpleMode(Value : boolean);
  public
    { Public declarations }
    OnSearchStringChange : TNotifyEvent;
    SearchStringEdit : TEdit;  //not owned by this object;
    lblFile          : TLabel;  //not owned by this object;
    lblField         : TLabel;  //not owned by this object;
    lblOperator      : TLabel;  //not owned by this object;
    lblValue         : TLabel;  //not owned by this object;
    DelBitmap        : TBitmap; //IS  owned by this object;
    btnAddSrchField  : TBitBtn;
    constructor Create(SearchFileNumber,SearchFileName : string;
                       AParent : TWinControl; AOwner : TComponent);
    Destructor Destroy;
    function RowBefore (ARow : TLogicRow) : TLogicRow;
    function PriorRow : TLogicRow;  //Next to last row.
    function LastRow : TLogicRow;
    procedure IndentMore;
    procedure IndentLess;
    function AddRow : TLogicRow;
    function IndexOf(ARow : TLogicRow) : integer;
    procedure DeleteRow(Index : integer);  overload;
    procedure DeleteRow(ARow : TLogicRow); overload;
    procedure SetFile(FileNumber,FileName : string);
    procedure Clear;
    property Row[Index : integer] : TLogicRow read GetRow;
    property SearchString : string read FSearchString;
    Property RowCount : integer read GetRowCount;
    Property SimpleMode : boolean read FSimpleMode write SetSimpleMode;
  end;


implementation

  uses FMErrorU;
//-----------------------------------------------------------------------
//TLogicRow
//-----------------------------------------------------------------------

  constructor TLogicRow.Create(SearchFileNumber,SearchFileName : string;
                               SimpleMode : Boolean;
                               AParent : TWinControl;
                               AParentSet : TLogicSet; Row : integer);
     procedure InitBox(Box : TORComboBox; Row : integer; DropDown : boolean);
     begin
       with Box do begin
         Visible := false;
         Parent := AParent;
         Top := FTop;
         Delimiter := '^';
         Pieces := '2';
         if DropDown then begin
           Style := orcsDropDown;  //orcsSimple;
         end else begin
           Style := orcsSimple;
         end;
         Height := OPEN_BOX_HEIGHT;
         AutoSelect := False;
         CheckEntireLine := True;
         LongList := True;
         LookupPiece := 2;
       end;
     end;

  begin {constructor}
    Inherited Create;
    FRowNum := Row;
    FSearchFileNumber := SearchFileNumber;
    FSearchFileName := SearchFileName;
    FParentSet := AParentSet;
    FVisible := false;
    FSimpleMode := SimpleMode;
    FRowOpen := true;
    FTop := FIELDS_TOP_OFFSET + ROW_HEIGHT * Row;
    FNewGroupStarter := false;
    OnSearchStringChange := nil;
    OnRangeModeChange := nil;
    ConditionBox := TORComboBox.Create(AParent);  //Create condition box (e.g. AND, OR, NOT)
    InitBox(ConditionBox,Row,true);
    with ConditionBox do begin
      Left := INT_CBO_CONDITIONLEFT;
      Width := INT_CBO_CONDITIONWIDTH;
      OnChange := ConditionChange;
    end;
    LoadCondition(ConditionBox);

    FileBox := TORComboBox.Create(AParent);  //create the file box
    InitBox(FileBox,Row,true);
    with FileBox do begin
      Left := INT_CBO_FILELEFT;
      Width := INT_CBO_FILEWIDTH;
      OnNeedData := ORBoxNeedData;
      OnClick := FileBoxChange;
      OnChange := FileBoxChange;
      Tag := TAG_FILE_BOX;
    end;

    FieldBox := TORComboBox.Create(AParent);     //create the field box
    InitBox(FieldBox,Row,false);
    with FieldBox do begin
      Left := INT_CBO_FIELDLEFT;
      Width := INT_CBO_FIELDWIDTH;
      OnNeedData := ORBoxNeedData;
      OnChange := FieldBoxChange;
      Tag := TAG_FIELD_BOX;
    end;

    OperatorBox := TORComboBox.Create(AParent);  //create the operator box (e.g. >, <, =, [ etc)
    InitBox(OperatorBox,Row,true);
    with OperatorBox do begin
      Left := INT_CBO_OPERATORLEFT;
      Width := INT_CBO_OPERATORWIDTH;
      Height := OPERATOR_BOX_HEIGHT;
      OnClick := OperatorBoxChange;
      OnChange := OperatorBoxChange;
    end;
    LoadOperator(OperatorBox);

    ValueEdit := TEdit.Create(AParent);      //create the Value edit box (also Lower limit box)
    with ValueEdit do begin
      Visible := false;
      Parent := AParent;
      Left := INT_EDIT_VALUELEFT;
      Width := INT_EDIT_VALUEWIDTH;
      Top := FTop;
      OnChange := EditBoxChange;
    end;

    UpperValueEdit := TEdit.Create(AParent);      //create the lower limit box
    with UpperValueEdit do begin
      Visible := false;
      Parent := AParent;
      Left := INT_EDIT_LOWERLEFT;
      Width := INT_EDIT_UPPERWIDTH;
      Top := FTop;
      OnChange := EditBoxChange;
    end;

    DatePicker := TDateTimePicker.Create(AParent);
    with DatePicker do begin
      Visible := False;
      Parent := AParent;
      DateTime := Now;
      Format := 'MM/dd/yyyy';
      Width := INT_EDIT_VALUEWIDTH;
      Top := FTop;
      OnChange := DatePickerChange;
    end;

    UpperDatePicker := TDateTimePicker.Create(AParent);
    with UpperDatePicker do begin
      Visible := False;
      Parent := AParent;
      DateTime := Now;
      Format := 'MM/dd/yyyy';
      Width := INT_EDIT_UPPERWIDTH;
      Top := FTop;
      OnChange := DatePickerChange;
    end;

    RecordPickerBox := TORComboBox.Create(AParent);
    InitBox(RecordPickerBox,Row,true);
    with RecordPickerBox do begin
      Width := INT_EDIT_VALUEWIDTH;
      OnNeedData := ORBoxNeedData;
      OnChange := RecordPickerBoxChange;
      Tag := TAG_RECORD_BOX;
    end;

    SetPicker := TComboBox.Create(AParent);
    With SetPicker do begin
      Visible := false;
      Parent := AParent;
      Width := INT_EDIT_VALUEWIDTH;
      Top := FTop;
      OnChange := SetPickerChange;
    end;

    DelButton := TSpeedButton.Create(AParent);
    with DelButton do begin
      Visible := false;
      Parent := AParent;
      Height := INT_BUTTON_SIZE;
      Width := INT_BUTTON_SIZE;
      //Caption := '(x)'; //Will be assigned a bitmap by parentset
      Top := FTop;
      OnClick := DelButtonClick;
      Hint := 'Delete row';
      ShowHint := true;
      ParentShowHint := False;
      Visible := true;
    end;

    SetIndentLevel(0);
    InitORComboBox(FileBox,FSearchFileName,'file');
    FileBoxChange(FileBox);
    FieldBoxChange(FieldBox);
    SetVisible(true);
    SetSimpleMode(FSimpleMode);
  end;  {constructor}

  Destructor TLogicRow.Destroy;
  begin
    ConditionBox.Free;
    FileBox.Free;
    FieldBox.Free;
    OperatorBox.Free;
    ValueEdit.Free;
    UpperValueEdit.Free;
    DatePicker.Free;
    UpperDatePicker.Free;
    RecordPickerBox.Free;
    SetPicker.Free;
    DelButton.Free;
    Inherited Destroy;
  end;

  procedure TLogicRow.SetIndentLevel(Value : integer);
  begin
    FIndentLevel := Value;
    ConditionBox.Left   := INT_CBO_CONDITIONLEFT + INDENT_OFFSET * Value;
    FileBox.Left        := INT_CBO_FILELEFT +      INDENT_OFFSET * Value;
    FieldBox.Left       := INT_CBO_FIELDLEFT +     INDENT_OFFSET * Value;
    OperatorBox.Left    := INT_CBO_OPERATORLEFT +  INDENT_OFFSET * Value;
    ValueEdit.Left      := INT_EDIT_VALUELEFT +    INDENT_OFFSET * Value;
    UpperValueEdit.Left := INT_EDIT_UPPERLEFT +    INDENT_OFFSET * Value;
    DatePicker.Left     := INT_EDIT_VALUELEFT +    INDENT_OFFSET * Value;
    UpperDatePicker.Left:= INT_EDIT_UPPERLEFT +    INDENT_OFFSET * Value;
    RecordPickerBox.Left:= INT_EDIT_VALUELEFT +    INDENT_OFFSET * Value;
    SetPicker.Left      := INT_EDIT_VALUELEFT +    INDENT_OFFSET * Value;
    DelButton.Left      := INT_BUTTON_LEFT    +    INDENT_OFFSET * Value;
    if FParentSet<> nil then begin
      If FParentSet.lblFile <> nil then FParentSet.lblFile.Left := INT_CBO_FILELEFT
         + LABEL_LEFT_OFFSET + INDENT_OFFSET * Value;
      If FParentSet.lblField <> nil then FParentSet.lblField.Left := INT_CBO_FIELDLEFT
         + LABEL_LEFT_OFFSET + INDENT_OFFSET * Value;
      If FParentSet.lblOperator <> nil then FParentSet.lblOperator.Left := INT_CBO_OPERATORLEFT
         + LABEL_LEFT_OFFSET + INDENT_OFFSET * Value;
      If FParentSet.lblValue <> nil then FParentSet.lblValue.Left := INT_EDIT_VALUELEFT
         + LABEL_LEFT_OFFSET + INDENT_OFFSET * Value;
    end;
  end;

  procedure TLogicRow.Clear;
  //This just resets the row for use.  It doesn't delete it.
  begin
    SetIndentLevel(0);
    FileBox.ItemIndex := 0;
    FileBox.Text := piece(FileBox.Items[0],'^',2);
    FileBoxChange(FileBox);
    FieldBox.ItemIndex := 0;
    FieldBox.Text := piece(FieldBox.Items[0],'^',2);
    FieldBoxChange(FieldBox);
    ValueEdit.Text := '';
    UpperValueEdit.Text := '';
    DatePicker.DateTime := Now;
    UpperDatePicker.DateTime := Now;
    RecordPickerBox.Text := '';
    RecordPickerBox.ItemIndex := 0;
    SetPicker.Text := '';
    ConditionBox.ItemIndex := 0;
    ConditionBox.Text := piece(ConditionBox.Items[0],'^',2);
  end;

  procedure TLogicRow.SetFile(FileNumber,FileName : string);
  begin
    if (FSearchFileNumber=FileNumber) and (FSearchFileName=FileName) then exit;
    FSearchFileNumber := FileNumber;
    FSearchFileName := FileName;
    InitORComboBox(FileBox,FSearchFileName,'file');
    FileBoxChange(FileBox);
    FieldBoxChange(FieldBox);
  end;

  procedure TLogicRow.SetRowColor(Color : TColor);
  begin
    ConditionBox.Color := Color;
    FileBox.Color := Color;
    FieldBox.Color := Color;
    OperatorBox.Color := Color;
    ValueEdit.Color := Color;
    UpperValueEdit.Color := Color;
    DatePicker.Color := Color;
    UpperDatePicker.Color := Color;
    SetPicker.Color := Color;
    RecordPickerBox.Color := Color;
  end;

  procedure TLogicRow.CloseRow;
    procedure CloseORBox(Box : TORComboBox);
    begin
      Box.Style := orcsDropDown;
      Box.Height := CLOSE_BOX_HEIGHT;
      //Box.Color := clInactiveBorder;
    end;

  begin
    FRowOpen := false;
    if FNewGroupStarter and (FVisible=false) then exit;
    CloseORBox(ConditionBox);
    CloseORBox(FileBox);
    CloseORBox(FieldBox);
    CloseORBox(RecordPickerBox);
    SetRowColor(clInactiveBorder);
    SetVisible(true);
  end;

  procedure TLogicRow.OpenRow;
  begin
    FRowOpen := true;
    SetRowColor(Colors[FSimpleMode]);
    SetVisible(true);
  end;

  procedure TLogicRow.SetRowNum(value : integer);
  //This won't change position in parent LogicSet
  var Top : integer;
  begin
    if value <> FRowNum then begin
      FRowNum := Value;
      Top := FIELDS_TOP_OFFSET + ROW_HEIGHT * FRowNum;
      ConditionBox.Top := Top;
      FileBox.Top := Top;
      FieldBox.Top := Top;
      OperatorBox.Top := Top;
      ValueEdit.Top := Top;
      UpperValueEdit.Top := Top;
      DatePicker.Top := Top;
      UpperDatePicker.Top := Top;
      RecordPickerBox.Top := Top;
      SetPicker.Top := Top;
      DelButton.Top := Top;
    end;
  end;

  procedure TLogicRow.SetSearchLabelCaption;
  begin
    If FParentSet.lblValue <> nil then begin
      FParentSet.lblValue.Caption := SearchCaption[FSimpleMode,(FSearchValueMode = vmRange)];
    end;
  end;

  procedure TLogicRow.SetSimpleMode(Value : boolean);
  begin
    if Value <> FSimpleMode then begin
      SetRowColor(Colors[FSimpleMode]);
      FSimpleMode := Value;
      if FSimpleMode=true then begin
        InitORComboBox(FileBox,'A','file');  //Populate File box
        if FileBox.Items.Count > 0 then begin
          FileBox.ItemIndex := 0;
          FileBox.Text := piece(FileBox.Items[FileBox.ItemIndex],'^',2)
        end;
      end else begin
        InitORComboBox(FileBox,FSearchFileName,'file');  //Populate File box
      end;
      SetSearchLabelCaption;
      InitORComboBox(FieldBox,'A','field');  //Populate Field box
      if Assigned(OnSearchStringChange) then OnSearchStringChange(self);
    end;
  end;


  procedure TLogicRow.SetNewGroupStarter(Value : boolean);
  begin
    if Value = FNewGroupStarter then exit;
    FNewGroupStarter := Value;
    SetVisible(not FNewGroupStarter);
    ConditionBox.Color := clWindow;
    ConditionBox.Visible := true;
  end;


  procedure TLogicRow.SelectOperator(OperatorLine : string);
  var index,i : integer;
  begin
    if OperatorBox.Items.Count = 0 then exit;
    //not working, why?  --> index := OperatorBox.Items.IndexOf(OperatorLine);
    index := -1;
    for i:= 0 to OperatorBox.Items.Count-1 do begin
      if OperatorBox.Items[i] = OperatorLine then begin
        index := i; break;
      end;
    end;
    //if index = OperatorBox.ItemIndex then exit; //no change.
    if index < 0 then index := 0;
    OperatorBox.Text := piece(OperatorBox.Items[index],'^',2);
    OperatorBox.ItemIndex := index;
    OperatorBoxChange(Self);
  end;


  procedure TLogicRow.LoadOperator(CmbBox: TORComboBox);
  //Load the operators, with the first piece being the mumps operator and
  //the second piece the text in the operator box
  begin
    CmbBox.Items.Add(COMB_EQUALS);
    CmbBox.Items.Add(COMB_NOT_EQUAL);
    CmbBox.Items.Add(COMB_LESS_THAN);
    CmbBox.Items.Add(COMB_LESS_THAN_OR_EQUALS);
    CmbBox.Items.Add(COMB_GREATER_THAN);
    CmbBox.Items.Add(COMB_GREATER_THAN_OR_EQUALS);
    CmbBox.Items.Add(COMB_IN_RANGE);
    CmbBox.Items.Add(COMB_NOT_IN_RANGE);
    CmbBox.Items.Add(COMB_CONTAINS);
    CmbBox.Items.Add(COMB_NOT_CONTAINS);
    CmbBox.ItemIndex := 0;
    CmbBox.Text := piece(CmbBox.Items[0],'^',2);
  end;

  procedure TLogicRow.LoadCondition(CmbBox: TORComboBox);
  //Load the conditions, with the first piece being the mumps conditional and
  //the second piece the text in the conditions box
  begin
     CmbBox.Items.Add('&^AND');
     CmbBox.Items.Add('!^OR');
     CmbBox.Items.Add('NOT^NOT');
     CmbBox.ItemIndex := 0;
     CmbBox.Text := 'AND';
  end;

  procedure TLogicRow.ORBoxNeedData(Sender: TObject; const StartFrom: String;
                                      Direction, InsertAt: Integer);
  var  Result : TStrings;
       FileNum : string;
       ORComboBox : TORComboBox;
  begin
    ORComboBox := TORComboBox(Sender);
    Case ORComboBox.Tag of
      TAG_FILE_BOX  : begin
                        FileNum := FSearchFileNumber;
                        Result := SubSetOfAllowedFiles(FSimpleMode,FileNum,
                                                       StartFrom, Direction);
                      end;
      TAG_FIELD_BOX : begin
                        if FileBox.Items.count = 0 then exit;
                        if FileBox.ItemIndex = -1 then FileBox.ItemIndex := 0;
                        FileNum := piece(FileBox.Items[FileBox.ItemIndex],'^',1);
                        Result := SubSetOfFields(FSimpleMode, FileNum, StartFrom, Direction);
                      end;
      TAG_RECORD_BOX: begin
                        FileNum := ExtractNum (FCurFieldDef,Pos('P',FCurFieldDef)+1);
                        Result := SubSetOfFile(FileNum, StartFrom, Direction);
                      end;
      else            Exit;
    end; {case}
    ORComboBox.ForDataUse(Result);
  end;

  procedure TLogicRow.FileBoxChange(Sender: TObject);
  begin
    InitORComboBox(FieldBox,'A','field');  //Populate Field box
    if Assigned(OnSearchStringChange) then OnSearchStringChange(self);
  end;

  procedure TLogicRow.PrepSetPicker(setDef : string);
  var  oneOption : string;
  begin
    SetPicker.Items.Clear;
    SetPicker.Text := '';
    oneOption := 'x';
    while (setDef <> '') and (oneOption <> '') do begin
      oneOption := piece(setDef,';',1);
      setDef := pieces(setDef,';',2,32);
      oneOption := piece(oneOption,':',2);
      if oneOption <> '' then begin
        SetPicker.Items.Add(oneOption);
      end;
    end;
    if SetPicker.Items.Count > 0 then begin
      SetPicker.SelText := SetPicker.Items[0];
    end else begin
      SetPicker.Text := '(none defined)';
    end;
  end;


  procedure TLogicRow.EnsureProperValueFieldVisible;
  var
    NewSearchValueMode : TValueMode;
    CurDataType : TFieldDataType;
    Operator : string;

    procedure ShowOnly(Control : TWinControl);
    begin
      ValueEdit.Visible := false;
      UpperValueEdit.Visible := false;
      DatePicker.Visible := false;
      UpperDatePicker.visible := false;
      RecordPickerBox.Visible := false;
      SetPicker.Visible := false;
      Control.Visible := true;
    end;

  begin
    CurDataType := GetFieldDataType;
    Operator := OperatorBox.Text;
    if Pos('IN RANGE',Operator) > 0 then begin
      NewSearchValueMode := vmRange;
      if CurDataType in [fdtPointer,fdtSet] then begin
        MessageDlg('A RANGE can''t be used with this type of field.',mtError,[MBOK],0);
        OperatorBox.Text := piece(OperatorBox.Items[0],'^',2); //should be EQUALS
        OperatorBox.ItemIndex := 0;
        exit;
      end;
    end else begin
      Case CurDataType of
        fdtUnknown    : NewSearchValueMode := vmString;
        fdtText       : NewSearchValueMode := vmString;
        fdtSet        : NewSearchValueMode := vmSet;
        fdtDate       : NewSearchValueMode := vmDate;
        fdtWP         : NewSearchValueMode := vmString;
        fdtPointer    : NewSearchValueMode := vmPointer;
        else            NewSearchValueMode := vmString;
      end; {case}
    end;
    if (NewSearchValueMode = FSearchValueMode)
      and not (NewSearchValueMode in [vmPointer,vmSet]) then exit;  //nothing to be done.
    if (FSearchValueMode = vmRange) or (NewSearchValueMode = vmRange) then begin
      if Assigned(OnRangeModeChange) then OnRangeModeChange(Self);  //can be used to change labels.
    end;
    FSearchValueMode := NewSearchValueMode;
    Case NewSearchValueMode of
      vmRange:     begin
                     if curDataType = fdtDate then begin
                       DatePicker.Width := INT_EDIT_LOWERWIDTH;
                       ShowOnly(DatePicker);
                       UpperDatePicker.Visible := true;
                     end else begin
                       ValueEdit.Width := INT_EDIT_LOWERWIDTH;
                       ShowOnly(ValueEdit);
                       UpperValueEdit.Visible := true;
                     end;
                   end;
      vmString:    Begin
                     ValueEdit.Width := INT_EDIT_VALUEWIDTH;
                     ShowOnly(ValueEdit);
                   end;
      vmSet:       begin
                     PrepSetPicker(FInfoPiece3);
                     ShowOnly(SetPicker);
                   end;
      vmDate:      begin
                     DatePicker.Width := INT_EDIT_VALUEWIDTH;
                     ShowOnly(DatePicker);
                   end;
      vmPointer:   begin
                     ShowOnly(RecordPickerBox);
                     InitORComboBox(RecordPickerBox,'A','record');  //Populate Field box
                   end;
    end; {case}
    SetSearchLabelCaption;
  end;

  procedure TLogicRow.CheckVisibilityIsCorrect;
  var RowPrior : TLogicRow;
  begin
    ConditionBox.Visible := (FRowNum>0);
    RowPrior :=FParentSet.RowBefore(Self);
    if (RowPrior <> nil) then if RowPrior.NewGroupStarter=true then begin
      ConditionBox.Visible := false;
    end;
    DelButton.Visible := (FParentSet.RowCount>1);
  end;

  procedure TLogicRow.SetVisible(Value : Boolean);
  begin
    FVisible := Value;
    FileBox.Visible := Value;
    FieldBox.Visible := Value;
    OperatorBox.Visible := Value;
    if Value = true then begin
      EnsureProperValueFieldVisible;
      CheckVisibilityIsCorrect;
    end else begin
      ConditionBox.Visible := False;
      ValueEdit.Visible := false;
      UpperValueEdit.Visible := false;
      DatePicker.Visible := false;
      UpperDatePicker.visible := false;
      RecordPickerBox.Visible := false;
      SetPicker.Visible := false;
    end;
  end;


  function TLogicRow.GetSearchValue() : string;
  var
    CurDataType : TFieldDataType;

  begin
    CurDataType := GetFieldDataType;
    case FSearchValueMode of
      vmRange:     begin
                     if curDataType = fdtDate then begin
                       Result := DateToStr(DatePicker.DateTime) + '..' +
                                 DateToStr(UpperDatePicker.DateTime);
                     end else begin
                       Result := ValueEdit.Text + '..' + UpperValueEdit.Text;
                     end;
                   end;
      vmString:    Begin
                     Result := ValueEdit.Text;
                   end;
      vmSet:       begin
                     Result := SetPicker.Text;
                   end;
      vmDate:      begin
                     Result := DateToStr(DatePicker.DateTime);
                   end;
      vmPointer:   begin
                     Result := RecordPickerBox.Text;
                   end;
      else         Result := '';
    end; {case}
  end;

  function TLogicRow.GetSearchString(var LastFileNum : string) : string;
  var ThisFileNum : string;
      NewFileNum : boolean;
      Fld        : string;
  begin
    Result := '';
    NewFileNum := true; //default
    if (IsValid=false)and(FNewGroupStarter=false) then exit;
    ThisFileNum := piece(FileBox.Items[FileBox.ItemIndex],'^',1);
    if LastFileNum <> ThisFileNum then begin
      NewFileNum := true;
      LastFileNum := ThisFileNum;
    end;
    if ConditionBox.Visible then begin
      if (NewFileNum=false) and (ConditionBox.ItemIndex>-1) then begin
        Result := Result + Piece(ConditionBox.Items[ConditionBox.ItemIndex],'^',1);
      end else begin
        Result := Result + ' ' + ConditionBox.Text + ' ';
      end;
    end;
    if FNewGroupStarter then begin
      Result := Result + '(';
    end else begin
      if FileBox.Items.Count = 0 then exit;
      if FileBox.ItemIndex < 0 then FileBox.ItemIndex := 0;
      if NewFileNum then Result := Result + ThisFileNum + ':';
      if FSimpleMode then begin
        if FieldBox.ItemIndex < 0 then exit;
        Fld := FieldBox.Items[FieldBox.ItemIndex];
        Result := Result + '(' + Piece(Fld,'^',1);
      end else begin
        Result := Result + '("' + FieldBox.Text + '"';
      end;
      Result := Result + Piece(OperatorBox.Items[OperatorBox.ItemIndex],'^',1);
      Result := Result + '"' + GetSearchValue + '")';
    end;
  end;


  procedure TLogicRow.OperatorBoxChange(Sender: TObject);
  begin
    EnsureProperValueFieldVisible;  //If RANGE picked, then this will change edit fields.
    if (OperatorBox.ItemIndex < 0) and (OperatorBox.Items.Count>0) then begin
      OperatorBox.ItemIndex := 0;
      OperatorBox.Text := piece(OperatorBox.Items[0],'^',2);
    end;
//    ParentSet.
  end;

  function TLogicRow.GetFileNum : string;
  begin
    Result := IntToStr(FileBox.ItemIEN);
  end;

  function TLogicRow.GetFieldNum : string;
  begin
    Result := IntToStr(FieldBox.ItemIEN);
  end;

  function TLogicRow.GetFieldDataType : TFieldDataType;
    var SubFileNum : string;
        FileNum,FieldNum : string;
    function IsSubFile(FieldDef: string) : boolean;
    begin
      SubFileNum := ExtractNum(FieldDef,1);
      result := (SubFileNum <> '');
    end;
  begin
    Result := fdtUnknown;
    if Pos('F',FCurFieldDef)>0 then begin  //Free text
      Result := fdtText;
    end else if Pos('D',FCurFieldDef)>0 then begin  //date field
      Result := fdtDate;
    end else if Pos('S',FCurFieldDef)>0 then begin  //Set of Codes
      Result := fdtSet;
    end else if Pos('P',FCurFieldDef)>0 then begin  //Pointer to file.
      Result := fdtPointer;
    end else if IsSubFile(FCurFieldDef) then begin  //Subfiles.
      FileNum := GetFileNum;  FieldNum := GetFieldNum;
      if (FileNum <> '') and (FieldNum <> '') then begin
        if IsWPField(FileNum,FieldNum) then Result := fdtWP;
      end;
    end;
  end;

  procedure TLogicRow.FieldBoxChange(Sender: TObject);
  var Info : string;
      CurDataType : TFieldDataType;
  begin
    if FieldBox.ItemIndex >=0 then begin
      Info := FieldBox.Items[FieldBox.ItemIndex];
    end else Info := '';
    FCurFieldDef := piece(Info,'^',3);
    FInfoPiece3 := piece(Info,'^',4);
    EnsureProperValueFieldVisible;
    CurDataType := GetFieldDataType;
    Case CurDataType of
      fdtUnknown,
      fdtPointer,
      fdtSet        : SelectOperator(COMB_EQUALS);
      fdtText,
      fdtWP         : SelectOperator(COMB_CONTAINS);
      fdtDate       : SelectOperator(COMB_IN_RANGE);
    end;
    //OperatorBoxChange(Self);
    if Assigned(OnSearchStringChange) then OnSearchStringChange(self);
  end;

  procedure TLogicRow.EditBoxChange(Sender: TObject);
  begin
    if Assigned(OnSearchStringChange) then OnSearchStringChange(self);
  end;

  procedure TLogicRow.SetPickerChange(Sender: TObject);
  begin
    if Assigned(OnSearchStringChange) then OnSearchStringChange(self);
  end;

  procedure TLogicRow.ConditionChange(Sender: TObject);
  begin
    if Assigned(OnSearchStringChange) then OnSearchStringChange(self);
  end;

  procedure TLogicRow.RecordPickerBoxChange(Sender: TObject);
  begin
    if Assigned(OnSearchStringChange) then OnSearchStringChange(self);
  end;

  procedure TLogicRow.DatePickerChange(Sender: TObject);
  begin
    if Assigned(OnSearchStringChange) then OnSearchStringChange(self);
  end;

  function TLogicRow.ExtractNum (S : String; StartPos : integer) : string;
  var i : integer;
      ch : char;
  begin
    result := '';
    if (S = '') or (StartPos < 0) then exit;
    i := StartPos;
    repeat
      ch := S[i];
      i := i + 1;
      if ch in ['0'..'9','.'] then begin
        Result := Result + ch;
      end;
    until (i > length(S)) or not  (ch in ['0'..'9','.'])
  end;


  function TLogicRow.SubSetOfFields(SimpleMode : Boolean; FileNum: string;
                                    const StartFrom: string; Direction: Integer): TStrings;

  { returns a pointer to a list of file entries (for use in a long list box) -
    The return value is a pointer to RPCBrokerV.Results, so the data must
    be used BEFORE the next broker call! }
  var
    cmd,RPCResult,GetSimple : string;
  begin
    Result := nil; //default
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';  // not used
    RPCBrokerV.param[0].ptype := list;
    cmd := 'FIELD LIST SUBSET';
    if SimpleMode then GetSimple :='1' else GetSimple :='0';
    cmd := cmd + '^' + FileNum + '^' + StartFrom + '^' + IntToStr(Direction) + '^^' + GetSimple;
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
      Result := RPCBrokerV.Results;
    end;
  end;

  procedure TLogicRow.DelButtonClick(Sender : TObject);
  begin
    FParentSet.DeleteRow(Self);
  end;

  function TLogicRow.IsWPField(FileNum,FieldNum : string) : boolean;
  var RPCResult : string;
      SrchStr : string;
      //Idx: integer;
      FMErrorForm: TFMErrorForm;
  begin
    SrchStr := FileNum + '^' +  FieldNum + '^';
    //Idx := CachedWPField.IndexOf(SrchStr + 'YES');
    //if Idx > -1 then begin Result := true; exit; end;
    //Idx := CachedWPField.IndexOf(SrchStr + 'NO');
    //if Idx > -1 then begin Result := false; exit; end;

    result := false;
    RPCBrokerV.remoteprocedure := 'TMG CHANNEL';
    RPCBrokerV.param[0].ptype := list;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := 'IS WP FIELD^' + FileNum + '^' + FieldNum;
    //RPCBrokerV.Call;
    CallBroker;
    RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
    if piece(RPCResult,'^',1)='-1' then begin
      FMErrorForm:= TFMErrorForm.Create(nil);
      FMErrorForm.Memo.Lines.Assign(RPCBrokerV.Results);
      FMErrorForm.PrepMessage;
      FMErrorForm.ShowModal;
      FMErrorForm.Free;
    end else begin
      RPCResult := piece(RPCResult,'^',3);
      result := (RPCResult = 'YES');
      //CachedWPField.Add(SrchStr + RPCResult);
    end;
  end;

  function TLogicRow.IsValid() : boolean;
  var
    CurDataType : TFieldDataType;

  begin
    Result := false; //default to failure
    if (FRowNum>0) and (ConditionBox.Text = '') then exit;
    if FileBox.Text = '' then exit;
    if FieldBox.Text = '' then exit;
    if OperatorBox.Text = '' then exit;
    Case FSearchValueMode of
      vmUnknown          : exit;
      vmRange            : begin
                             CurDataType := GetFieldDataType;
                             if CurDataType <> fdtDate then begin
                               if (ValueEdit.Text = '') or (UpperValueEdit.Text = '') then exit;
                             end;
                           end;
      vmString,vmNumeric : begin
                             if (ValueEdit.Text = '') then exit;
                           end;
      vmDate             : begin
                             //Date is always present...
                             //if (DatePickerBox.Text = '') then exit;
                           end;
      vmSet              : begin
                             if (SetPicker.Text = '') then exit;
                           end;
      vmPointer          : begin
                             if (RecordPickerBox.Text = '') then exit;
                           end;
    end; {case}
    Result := true;
  end;


  function TLogicRow.SubSetOfAllowedFiles(SimpleMode : boolean; FileNum: string;
                                         const StartFrom: string;
                                         Direction: Integer       ): TStrings;

  { returns a pointer to a list of file entries (for use in a long list box) -
    The return value is a pointer to RPCBrokerV.Results, so the data must
    be used BEFORE the next broker call! }
  var
    cmd,RPCResult,GetSimple : string;

  begin
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';  // not used
    RPCBrokerV.param[0].ptype := list;
    cmd := 'ALLOWED FILES ENTRY SUBSET';
    if SimpleMode then GetSimple :='1' else GetSimple :='0';
    cmd := cmd + '^' + FileNum + '^' + StartFrom + '^' + IntToStr(Direction) + '^^' + GetSimple;
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

  function TLogicRow.SubSetOfFile(FileNum: string;
                                  const StartFrom: string;
                                  Direction: Integer       ): TStrings;

  { returns a pointer to a list of file entries (for use in a long list box) -
    The return value is a pointer to RPCBrokerV.Results, so the data must
    be used BEFORE the next broker call! }
  var
    cmd,RPCResult : string;
  begin
    RPCBrokerV.remoteprocedure := 'TMG CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';  // not used
    RPCBrokerV.param[0].ptype := list;
    cmd := 'FILE ENTRY SUBSET';
    cmd := cmd + '^' + FileNum + '^' + StartFrom + '^' + IntToStr(Direction);
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    //RPCBrokerV.Call;
    CallBroker;
    RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
    if piece(RPCResult,'^',1)='-1' then begin
     // handle error...
    end else begin
      RPCBrokerV.Results.Delete(0);
      if RPCBrokerV.Results.Count=0 then begin
        //RPCBrokerV.Results.Add('0^<NO DATA>');
      end;
    end;
    Result := RPCBrokerV.Results;
  end;


  procedure TLogicRow.InitORComboBox(ORComboBox: TORComboBox; initValue : string; boxtype : string);
  begin
    ORComboBox.Items.Clear;
    ORComboBox.Text := '';  //initValue;
    ORComboBox.InitLongList(initValue);
    if ORComboBox.Items.Count > 0 then begin
      ORComboBox.ItemIndex := 0;
      ORComboBox.Text := Piece(ORComboBox.Items[0],'^',2);
    end else begin
      ORComboBox.Text := '<Begin by selecting ' + boxtype + '>';
    end;
  end;

  procedure TLogicRow.IndentMore;
  begin
    SetIndentLevel(FIndentLevel+1);
  end;

  procedure TLogicRow.IndentLess;
  begin
    if FIndentLevel>0 then SetIndentLevel(FIndentLevel-1);
    CheckVisibilityIsCorrect;
  end;

//-----------------------------------------------------------------------
// TLogicSet
//-----------------------------------------------------------------------

  constructor TLogicSet.Create(SearchFileNumber,SearchFileName : string;
                               AParent : TWinControl; AOwner : TComponent);
  begin
    Inherited Create;
    OnSearchStringChange := nil;
    SearchStringEdit := nil;
    DelBitmap := nil;
    Rows := TList.Create;
    FSimpleMode := True;
    FSearchFileNumber := SearchFileNumber;
    FSearchFileName := SearchFileName;
    FParent := AParent;
    FOwner := AOwner;
    FFileNumsStack := TStringList.Create;
    DelBitmap := TBitmap.Create;

    btnAddSrchField := TBitBtn.Create(AOwner);
    with btnAddSrchField do begin
      Visible := false;
      Parent := AParent;
      Height := 25;
      Width := 25;
      OnClick := HandleAddQuery;
    end;

    lblAddAnother := TLabel.Create(AOwner);
    with lblAddAnother do begin
      Visible := false;
      Parent := AParent;
      Caption := INT_ADD_QUERYROW_LABEL_CAPTION;
      Height := 15;
      Hint := 'Add More Search Terms';
      ShowHint := true;
      ParentShowHint := False;
    end;

    btnIndentMore := TButton.Create(AOwner);
    with btnIndentMore do begin
      Visible := false;
      Parent := AParent;
      Caption := '(';
      Height := 15;
      Width := 15;
      OnClick :=  HandleIndentMore;
      Hint := 'Start New Grouping';
      ShowHint := true;
      ParentShowHint := False;
    end;

    btnIndentLess := TButton.Create(AOwner);
    with btnIndentLess do begin
      Visible := false;
      Parent := AParent;
      Caption := ')';
      Height := 15;
      Width := 15;
      OnClick :=  HandleIndentLess;
      Hint := 'Close Grouping';
      ShowHint := true;
      ParentShowHint := False;
    end;
    //UpdateButtonPlacement;  //Done in SetSimpleMode
    SetSimpleMode(FSimpleMode);
  end;

  Destructor TLogicSet.Destroy;
  var i : integer;
      ARow : TLogicRow;
  begin
    for i := 0 to Rows.Count-1 do begin
      ARow := GetRow(i); if ARow= nil then continue;
      ARow.Destroy;
    end;
    Rows.Free;
    FFileNumsStack.Free;
    btnAddSrchField.Free;
    lblAddAnother.Free;
    btnIndentMore.Free;
    btnIndentLess.Free;
    DelBitmap.Free;
    Inherited Destroy;
  end;

  function TLogicSet.GetRow(Index : integer): TLogicRow;
  begin
    if (Index > -1) and (Index < Rows.Count) then begin
      Result := TLogicRow(Rows.Items[Index]);
    end else Result := nil;
  end;

  function TLogicSet.GetRowCount : integer;
  begin
    Result := Rows.Count;
  end;

  function TLogicSet.IndexOf(ARow : TLogicRow) : integer;
  begin
    Result := Rows.IndexOf(ARow);
  end;

  function TLogicSet.AddRow : TLogicRow;
  var ALogicRow : TLogicRow;
  begin
    ALogicRow := TLogicRow.Create(FSearchFileNumber,FSearchFileName,FSimpleMode,
                                  FParent,Self,Rows.Count);
    ALogicRow.OnSearchStringChange := Handle1RowChange;
    if DelBitmap <> nil then ALogicRow.DelButton.Glyph.Assign(DelBitmap);
    Rows.Add(ALogicRow);
    Result := ALogicRow;
    if PriorRow <> nil then begin
      ALogicRow.IndentLevel := PriorRow.IndentLevel;
      PriorRow.CloseRow;
    end;
    UpdateButtonPlacement;
  end;

  procedure TLogicSet.DeleteRow(Index : integer);
  var ALogicRow, NextLogicRow : TLogicRow;
      i : integer;
      IndentLevel : integer;
      DeletingLastRow : boolean;
      GroupEmpty : boolean;

  begin
    If Rows.Count=1 then exit;  //always leave at least one row present.
    if (Index < 0) or (Index > Rows.Count-1) then exit;
    DeletingLastRow := (Index = Rows.Count-1);
    ALogicRow := GetRow(Index);
    if ALogicRow <> nil then begin
      IndentLevel := ALogicRow.IndentLevel;
      ALogicRow.Destroy;
    end else begin
      IndentLevel := 0;
    end;
    Rows.Delete(Index);
    for i := 0 to Rows.Count-1 do begin
      ALogicRow := GetRow(i);
      if ALogicRow = nil then continue;
      ALogicRow.SetRowNum(i);
      ALogicRow.CheckVisibilityIsCorrect;
    end;

    //FIX!!! If row is a group starter, then all dependant rows should be
    //       shifted leftward.

    //Check if row prior to that deleted was a group opener
    GroupEmpty := false; //default
    ALogicRow := GetRow(Index-1);
    NextLogicRow := GetRow(Index); //Next in list, that has pulled up into Index's position
    if (ALogicRow <> nil) and ALogicRow.NewGroupStarter then begin
      //Now see if group is now empty.
      if NextLogicRow=nil then begin
        GroupEmpty := true;
      end else if NextLogicRow.IndentLevel < IndentLevel then begin
        GroupEmpty := true;
      end;
    end;
    if GroupEmpty then begin
      if Rows.Count > 1 then begin
        DeleteRow(ALogicRow);
      end else begin
        ALogicRow.NewGroupStarter := false;
      end;
    end;

    if DeletingLastRow then begin
      ALogicRow := LastRow;
      if ALogicRow <> nil then begin
        ALogicRow.OpenRow;
        ALogicRow.CheckVisibilityIsCorrect;
      end;
    end;
    Handle1RowChange(self);
    UpdateButtonPlacement;
  end;

  procedure TLogicSet.DeleteRow(ARow : TLogicRow);
  //NOTE: Don't put details here.  Put in OTHER DeleteRow above.
  var index : integer;
  begin
    index := IndexOf(ARow);
    DeleteRow(index);
  end;

  function TLogicSet.PriorRow : TLogicRow;
  begin
    if Rows.Count>1 then begin
      Result := TLogicRow(Rows.Items[Rows.Count-2]);
    end else Result := nil;
  end;

  function TLogicSet.LastRow : TLogicRow;
  begin
    if Rows.Count>0 then begin
      Result := TLogicRow(Rows.Items[Rows.Count-1]);
    end else Result := nil;
  end;

  function TLogicSet.RowBefore (ARow : TLogicRow) : TLogicRow;
  var index : integer;
  begin
    Result := nil;
    index := Rows.IndexOf(ARow);
    if index > 0 then Result := GetRow(Index-1);
  end;

  procedure TLogicSet.UpdateButtonPlacement;
  var ARow : TLogicRow;
      Left, Top : integer;
  begin
    ARow := LastRow;
    if ARow = nil then Top := 50 else Top := ARow.Top;
    If LastRow <> nil then Left := LastRow.FileBox.Left else Left := INT_ADD_QUERYROW_BTN_LEFT;
    btnAddSrchField.Top := Top + ADD_QUERY_OFFSET;
    btnAddSrchField.Left := Left;
    btnAddSrchField.Visible := true;

    lblAddAnother.Top := Top + ADD_QUERY_OFFSET + INT_COMPONENT_SPACING;
    lblAddAnother.Left := btnAddSrchField.Left + btnAddSrchField.Width + INT_COMPONENT_SPACING;
    lblAddAnother.Visible := true;

    btnIndentMore.Top := btnAddSrchField.Top + btnAddSrchField.Height + INT_COMPONENT_SPACING;
    btnIndentMore.Left := lblAddAnother.Left;
    btnIndentMore.Visible := not FSimpleMode;

    btnIndentLess.Top := btnIndentMore.Top;
    btnIndentLess.Left := btnIndentMore.Left + btnIndentMore.Width + + INT_COMPONENT_SPACING;
    btnIndentLess.Visible := not FSimpleMode;
  end;


  procedure TLogicSet.Handle1RowChange(Sender : TObject);
  begin
    FSearchString := GetSearchString;
    if Assigned(OnSearchStringChange) then OnSearchStringChange(Sender);
    if Assigned(SearchStringEdit) then SearchStringEdit.Text := FSearchString;
  end;

  procedure TLogicSet.HandleIndentMore(Sender : TObject);
  begin
    IndentMore;
  end;

  procedure TLogicSet.HandleIndentLess(Sender : TObject);
  begin
    IndentLess;
  end;

  procedure TLogicSet.HandleAddQuery(Sender : TObject);
  var ARow : TLogicRow;
  begin
    if RowCount > 0 then begin
      ARow := LastRow;
      if (ARow <> nil) and (ARow.IsValid=false) then begin
        MessageDlg('Please complete current row before adding a new one.',mtInformation,[mbOK],0);
        exit;
      end;
    end;
    AddRow;
    LastRow.Visible := true;
    UpdateButtonPlacement;
  end;

  procedure TLogicSet.IndentMore;
  var NewRow : TLogicRow;
  begin
    if LastRow.IsValid then begin
      NewRow := AddRow;
    end;
    LastRow.NewGroupStarter := true;
    NewRow := AddRow;
    NewRow.IndentMore;
    NewRow.Visible := true;
  end;

  procedure TLogicSet.IndentLess;
  var PriorRow, ARow : TLogicRow;
  begin
    ARow := LastRow;
    if ARow.IndentLevel = 0 then exit;
    if ARow.IsValid = true then begin
      ARow := AddRow;
    end;
    ARow.IndentLess;
    ARow.Visible := true;
    PriorRow := RowBefore(ARow);
    if PriorRow = nil then exit;
    if PriorRow.NewGroupStarter then begin
      DeleteRow(PriorRow);
    end;
  end;

  function TLogicSet.GetSearchString : string;
  var
    CurFile : string;
    ARow : TLogicRow;
    CurIndentLevel : integer;
    i : integer;
  begin
    FFileNumsStack.Clear;
    FFileNumsStack.Add('');
    Result := '';
    CurFile := '';
    CurIndentLevel := 0;
    for i := 0 to Rows.Count-1 do begin
      ARow := GetRow(i); if ARow = nil then continue;
      if ARow.IndentLevel > CurIndentLevel then begin
        Inc(CurIndentLevel);
        CurFile := '';
        FFileNumsStack.Add('');
      end else while (ARow.IndentLevel < CurIndentLevel) do begin
        Dec(CurIndentLevel);
        FFileNumsStack.Delete(FFileNumsStack.Count-1);
        CurFile := FFileNumsStack.Strings[FFileNumsStack.Count-1];
        Result := Result + ')';
      end;
      Result := Result + ARow.GetSearchString(CurFile);
      FFileNumsStack.Strings[FFileNumsStack.Count-1] := CurFile;
    end;
    while CurIndentLevel > 0 do begin
      Result := Result + ')';
      Dec(CurIndentLevel);
    end;
  end;

  procedure TLogicSet.SetSimpleMode(Value : boolean);
  begin
    FSimpleMode := Value;
    if Value = true then begin
      if Assigned(lblFile) then lblFile.Caption := 'Category';
      if Assigned(lblField) then lblField.Caption := 'Detail';
      if Assigned(lblOperator) then lblOperator.Visible := false;
      //if Assigned(lblValue) then lblValue.Caption := 'Value to Search For:';
    end else begin
      if Assigned(lblFile) then lblFile.Caption := 'Associated File';
      if Assigned(lblField) then lblField.Caption := 'Field';
      if Assigned(lblOperator) then lblOperator.Visible := True;
      //if Assigned(lblValue) then lblValue.Caption := 'Search Value';
    end;
    if Assigned(SearchStringEdit) then begin
      //SearchStringEdit.Visible := not Value;
      SearchStringEdit.ReadOnly := Value;
      SearchStringEdit.Enabled := not Value;
      SearchStringEdit.Color := Colors[not FSimpleMode];
    end;
    UpdateButtonPlacement;
    if LastRow <> nil then LastRow.SimpleMode := Value;
  end;

  procedure TLogicSet.SetFile(FileNumber,FileName : string);
  var i : integer;
  begin
    if (FSearchFileNumber=FileNumber) and (FSearchFileName=FileName) then exit;
    FSearchFileNumber := FileNumber;
    FSearchFileName := FileName;
    for i := 0 to Rows.Count - 1 do begin
      Self.Row[i].SetFile(FileNumber,FileName);
    end;
  end;

  procedure TLogicSet.Clear;
  begin
    while RowCount > 1 do begin
      DeleteRow(LastRow);
    end;
    if LastRow <> nil then LastRow.Clear;
    if Assigned(SearchStringEdit) then SearchStringEdit.Text := FSearchString;
  end;


end.

