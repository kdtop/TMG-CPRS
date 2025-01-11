unit UTMGTypes;
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
  Dialogs, StdCtrls, StrUtils, ComCtrls,
  SortStringGrid;

Type
  tFileEntry = record
    Field     : string;
    FileNum   : string;
    FieldName : String;
    IENS      : string;
    oldValue,newValue : string;
  end;

  //TIENSelector = function : longint of object;
  TIENSSelector = function : string of object;

  TFieldType = (fmftNone, fmftComputed, fmftDate, fmftFreeText,
                fmftUneditable, fmftPtr, fmftVarPtr, fmftSet,
                fmftNumber, fmftWP, fmftSubfile);
const
  FIELD_TYPE_NAMES : array[fmftNone .. fmftSubfile] of string[16] =
                    ('None',        //fmftNone
                     'Computed',    //fmftComputed  <-- really shouldn't be separate type....
                     'Date',        //fmftDate
                     'Free Text',   //fmftFreeText,
                     'Uneditable',  //fmftUneditable
                     'Pointer',     //fmftPtr
                     'Var Pointer', //fmftVarPtr
                     'Set',         //fmftSet,
                     'Number',      //fmftNumber
                     'WP',          //fmftWP
                     'Subfile');    //fmftSubfile);


 type
   TFindingTypeRec = record
     FileNum : string;
     FileName : string;
     Prefix : string[8];
   end;

 const
  NUM_FINDING_TYPE_NAMES = 17;
  FINDING_TYPES_NAMES : array [1..NUM_FINDING_TYPE_NAMES] of TFindingTypeRec = (
    (FileNum: '50'; FileName: 'DRUG'; Prefix: 'DR'),
    (FileNum: '9999999.09'; FileName: 'EDUCATION TOPICS';          Prefix: 'ED'),
    (FileNum: '9999999.15'; FileName: 'EXAM';                      Prefix: 'EX'),
    (FileNum: '9999999.64'; FileName: 'HEALTH FACTOR';             Prefix: 'HF'),
    (FileNum: '9999999.14'; FileName: 'IMMUNIZATION';              Prefix: 'IM'),
    (FileNum: '60';         FileName: 'LABORATORY';                Prefix: 'LT'),
    (FileNum: '601.71';     FileName: 'MH TESTS AND SURVEYS';      Prefix: 'MH'),
    (FileNum: '101.43';     FileName: 'ORDERABLE ITEM';            Prefix: 'OI'),
    (FileNum: '71';         FileName: 'RADIOLOGY PROCEDURE';       Prefix: 'RP'),
    (FileNum: '811.4';      FileName: 'REMINDER COMPUTED FINDING'; Prefix: 'CF'),
    (FileNum: '811.2';      FileName: 'REMINDER TAXONOMY';         Prefix: 'TX'),
    (FileNum: '811.5';      FileName: 'REMINDER TERM';             Prefix: 'RT'),
    (FileNum: '9999999.28'; FileName: 'SKIN TEST';                 Prefix: 'ST'),
    (FileNum: '50.605';     FileName: 'VA DRUG CLASS';             Prefix: 'DC'),
    (FileNum: '50.6';       FileName: 'VA GENERIC';                Prefix: 'DG'),
    (FileNum: '120.51';     FileName: 'VITAL MEASUREMENT';         Prefix: 'VM'),
    (FileNum: '810.9';      FileName: 'REMINDER LOCATION LIST';    Prefix: 'RL')
  );
type
  TGridInfo = class;  //forward declaration
  TGridDataLoader = procedure (GridInfo: TGridInfo) of object;
  TAfterPostHandler = procedure (GridInfo: TGridInfo; Changes : TStringList) of object;
  THandleTableCellEdit = function(InitValue, FileNum, IENS, FieldNum : string;
                                  GridInfo : TGridInfo;
                                  var Changed, CanSelect : boolean;
                                  ExtraInfo : string = '';
                                  ExtraInfoSL : TStringList = nil;
                                  Fields : string = '';
                                  Identifier : string = '') : string;

  TGridInfo = class (TObject)
  public
    Name         : string;            //used in debugging.
    Grid         : TSortStringGrid;   //doesn't own object
    FileNum      : string;
    IENS         : string;
    Fields       : string;            //Optional. To be ultimately passed as Fields parameter to LIST^DIC in server RPC. '' --> default
    IdentifierCode : string;          //Optional. Valid mumps code. To be ultimately passed as Idenfier parameter to LIST^DIC in server RPC.
    BasicMode    : Boolean;
    BasicTemplate: TStringList;       //doesn't own object
    Data         : TStringList;       //doesn't own object
    MessageStr   : string;            //optional text.
    DataLoadProc : TGridDataLoader;   //doesn't own object
    ApplyBtn     : TButton;           //doesn't own object
    RevertBtn    : TButton;           //doesn't own object
    OnAfterPost  : TAfterPostHandler;
    RecordSelector : TIENSSelector;    //doesn't own object
    ReadOnly     : boolean;
    LoadingGrid  : boolean;
    DisplayRefreshIndicated : boolean;
    DateFieldEditor : THandleTableCellEdit;
    FreeTextFieldEditor : THandleTableCellEdit;
    PtrFieldEditor : THandleTableCellEdit;
    VarPtrFieldEditor : THandleTableCellEdit;
    SetFieldEditor : THandleTableCellEdit;
    NumFieldEditor : THandleTableCellEdit;
    WPFieldEditor : THandleTableCellEdit;
    SubfileFieldEditor : THandleTableCellEdit;
    CustomPtrFieldEditors : TStringList;  //Format:  .Strings=<PointedToFile#>, e.g. '80'  .Object must be pointer of type THandleTableCellEdit.  No Ownership.
    procedure Clear; dynamic;
    procedure Assign(Source : TGridInfo); dynamic;
    function DDInfo(FieldNum : string) : string;
    function FldInfo(FieldNum : string) : string;
    function FieldType(FieldNum : string) : TFieldType;
    procedure ExtractVarPtrInfo(FieldNum : string; VarPtrInfo : TStringList);
    function SubfileNum(FieldNum : string) : string;
    constructor Create;
    destructor Destroy;
  end;

  TCompleteGridInfo = class (TGridInfo)
  public
    //NOTE: I can't redeclare as below, because it ends up that
    //TCompleteGridInfo.Data is different from TGridInfo.Data
    //Regardless, this object WILL own BasicTemplate and Data objects.
    //----------------------------
    //BasicTemplate: TStringList;       //DOES own object
    //Data         : TStringList;       //DOES own object
    procedure Clear; override;
    procedure Assign(Source : TGridInfo); overload; override;
    procedure Assign(Source : TCompleteGridInfo); overload;
    constructor Create;
    destructor Destroy;
  end;


Const
  DEF_GRID_ROW_HEIGHT = 17;
  COMPUTED_FIELD     = '<Computed Field --> CAN''T EDIT>';
  CLICK_TO           = '<CLICK to ';
  //CLICK_FOR_SUBS     = CLICK_ + 'for Sub-Entries>';
  CLICK_TO_EDIT_SUBS = CLICK_TO + 'Edit Sub-Entries>';
  CLICK_TO_ADD_SUBS  = CLICK_TO + 'Add Sub-Entries>';
  CLICK_TO_EDIT_TEXT = CLICK_TO + 'Edit Text>';
  CLICK_TO_ADD_TEXT  = CLICK_TO + 'Add Text>';
  HIDDEN_FIELD       = '<Hidden>';
  crCustDrag         = 1;
  crCustNodrop       = 2;

  TF_TXT : ARRAY[false..true] of char = ('N', 'Y');

Type
  TfnnName = (fnnNone, fnnCount, fnnDiffDate, fnnDur, fnnFI, fnnMaxDate,
              fnnMinDate, fnnMRD, fnnNumeric, fnnValue,
              fnnScript, fnnDayOfYear, fnnMonthOfYear, fnnYear);
  TfnResult = (fnrOther, fnrDate, fnrDateDuration, fnrString, fnrNumber, fnrBoolean);
  TFnNames = record
    Name : string[16];
    DispName : string[16];
    ResultType : TfnResult;
  end;
  TFindingType =(ftNone, ftFinding, ftFnFinding, ftAge, ftSex);

const
  NUM_FN_NAMES = 9;
  LAST_FN_NAME : TfnnName = fnnYear;
  //NOTE: REM_FUNCT_INFO should later be changed to a dynamic function that
  //      gets information from VistA file #802.4
  REM_FUNCT_INFO : array[fnnCount..fnnYear] of TFnNames = (
    (Name: 'COUNT';         DispName : 'Count';            ResultType: fnrNumber),
    (Name: 'DIFF_DATE';     DispName : 'Date Difference';  ResultType: fnrDateDuration),
    (Name: 'DUR';           DispName : 'Duration';         ResultType: fnrDateDuration),
    (Name: 'FI';            DispName : 'Finding Truth';    ResultType: fnrBoolean),
    (Name: 'MAX_DATE';      DispName : 'Most Recent Date'; ResultType: fnrDate),
    (Name: 'MIN_DATE';      DispName : 'Oldest Date';      ResultType: fnrDate),
    (Name: 'MRD';           DispName : 'Most Recent Date'; ResultType: fnrDate),
    (Name: 'NUMERIC';       DispName : 'Numeric Value';    ResultType: fnrNumber),
    (Name: 'VALUE';         DispName : 'Value';            ResultType: fnrString),
    (Name: 'SCRIPT';        DispName : 'Script';           ResultType: fnrBoolean),
    (Name: 'DAY_OF_YEAR';   DispName : 'Day Of Year';      ResultType: fnrNumber),  //added functions
    (Name: 'MONTH_OF_YEAR'; DispName : 'Month of Year';    ResultType: fnrNumber),  //added functions
    (Name: 'YEAR';          DispName : 'Year';             ResultType: fnrNumber)   //added functions
   );

  VALUE_PREFIX = 'VALUE_';
  SUBLOGIC = 'SUBLOGIC';
  SUBLOGIC_GROUP = 'Sublogic group';
  NULL_CONVERT_DEF = -12235; //random unlikely number

type
  vpef = (vpefNone, vpefSubFile, vpefOneRec);
  TVariantPopupEdit = record
    RecType : vpef;
    EditForm : pointer;  //doesn't own object.
    //case integer of
    // 0: (P : Pointer);                             //doesn't own object
    // 1: (ActiveSubfileEditForm : TfrmMultiRecEdit);    //doesn't own object
    // 2: (ActiveOneRecEditForm  : TOneRecEditForm); //doesn't own object
  end;

  //The order of this must be same as order of tcVinViewControl tabs on MainForm
  TDisplayVMode = (dvmCohort, dvmResolution, dvmUtility);

  TRemDlgElementType = (detNone=-1, detPrompt=0, detDialogElement,
                        detReminderdialog, detForcedValue, detDialogGroup,
                        detResultGroup, detResultElement);
  TRemDlgElementInfo = record
    Initial : char;
    Name : string;
  end;
const
  LAST_REMINDER_DIALOG_ELEMENT_TYPE = detResultElement;
  REMINDER_DIALOG_ELEMENT_TYPE : array[detPrompt..LAST_REMINDER_DIALOG_ELEMENT_TYPE] of TRemDlgElementInfo = (
    (Initial:'P'; Name:'Prompt'),
    (Initial:'E'; Name:'Dialog Element'),
    (Initial:'R'; Name:'Reminder Dialog'),
    (Initial:'F'; Name:'Forced Value'),
    (Initial:'G'; Name:'Dialog Group'),
    (Initial:'S'; Name:'Result Group'),
    (Initial:'T'; Name:'Result Element')
  );


//----Forward declarations----//
function ConvertRemDlgItemTypeTag(TagOrName : string) : TRemDlgElementType;
function ConvertRemDlgItemTypeName(Name : string) : char;
function GetRemDelItemTypeName(Tag : char) : string;

implementation
  uses
    uTMGUtil, OrFn, fPtDemoEdit{, rRPCsU}, uTMGGlobals, rTMGRPCs;

  //---------------------------------------------------
  //---------------------------------------------------

  constructor TGridInfo.Create;
  begin
    inherited;
    CustomPtrFieldEditors := TStringList.Create;
  end;

  destructor TGridInfo.Destroy;
  begin
    CustomPtrFieldEditors.Free;
    inherited;
  end;

  procedure TGridInfo.Clear;
  begin
    Grid                           := nil;
    FileNum                        := '';
    IENS                           := '';
    Fields                         := '';
    IdentifierCode                 := '';
    BasicTemplate                  := nil;
    Data                           := nil;
    MessageStr                     := '';
    DataLoadProc                   := nil;
    ApplyBtn                       := nil;
    RevertBtn                      := nil;
    RecordSelector                 := nil;
    ReadOnly                       := false;
    LoadingGrid                    := false;
    DisplayRefreshIndicated        := false;
    DateFieldEditor                := nil;
    FreeTextFieldEditor            := nil;
    PtrFieldEditor                 := nil;
    VarPtrFieldEditor              := nil;
    SetFieldEditor                 := nil;
    NumFieldEditor                 := nil;
    WPFieldEditor                  := nil;
    SubfileFieldEditor             := nil;
    CustomPtrFieldEditors.Clear;
  end;

  procedure TGridInfo.Assign(Source : TGridInfo);
  begin
    Name                    := Source.Name;
    Grid                    := Source.Grid;
    filenum                 := Source.filenum;
    IENS                    := Source.IENS;
    MessageStr              := Source.MessageStr;
    DataLoadProc            := Source.DataLoadProc;
    ApplyBtn                := Source.ApplyBtn;
    RevertBtn               := Source.RevertBtn;
    RecordSelector          := Source.RecordSelector;
    BasicTemplate           := Source.BasicTemplate;  //not owned by TGridInfo
    Data                    := Source.Data;           //not owned by TGridInfo
    OnAfterPost             := Source.OnAfterPost;
    ReadOnly                := Source.ReadOnly;
    DisplayRefreshIndicated := Source.DisplayRefreshIndicated;
    DateFieldEditor         := Source.DateFieldEditor;
    FreeTextFieldEditor     := Source.FreeTextFieldEditor;
    PtrFieldEditor          := Source.PtrFieldEditor;
    VarPtrFieldEditor       := Source.VarPtrFieldEditor;
    SetFieldEditor          := Source.SetFieldEditor;
    NumFieldEditor          := Source.NumFieldEditor;
    WPFieldEditor           := Source.WPFieldEditor;
    SubfileFieldEditor      := Source.SubfileFieldEditor;
  end;

  function TGridInfo.DDInfo(FieldNum : string) : string;
  //Returns information stored in cashed DATA
  begin
    Result := GetOneLine(Data, FileNum, FieldNum);
  end;

  function TGridInfo.FldInfo(FieldNum : string) : string;
  //Returns information stored in cashed DATA
  begin
    Result := DDInfo(FieldNum);
    Result := Piece(Result,'^',6);
  end;

  function TGridInfo.FieldType(FieldNum : string) : TFieldType;
  var FieldDef : string;
      discardSubFileNum : string;
  begin
    Result := fmftNone;
    FieldDef := FldInfo(FieldNum);
    if Pos('F',FieldDef)>0 then begin  //Free text
      Result := fmftFreeText;
    end else if Pos('N',FieldDef)>0 then begin  //Numeric value
      Result := fmftNumber;
    end else if IsSubFile(FieldDef, discardSubFileNum) then begin  //Subfiles.
      if rTMGRPCs.IsWPField(CachedWPField, FileNum,FieldNum) then begin
        Result := fmftWP;
      end else begin
        Result := fmftSubfile;
      end;
    end else if Pos('C',FieldDef)>0 then begin  //computed fields.
      Result := fmftComputed;
    end else if Pos('D',FieldDef)>0 then begin  //date field
      Result := fmftDate;
    end else if Pos('S',FieldDef)>0 then begin  //Set of Codes
      Result := fmftSet;
    end else if Pos('I',FieldDef)>0 then begin  //uneditable
      Result := fmftUneditable;
    end else if Pos('V',FieldDef)>0 then begin  //Variable Pointer to file.
      Result := fmftVarPtr;
    end else if Pos('P',FieldDef)>0 then begin  //Pointer to file.
      Result := fmftPtr;
    end;
  end;

  function TGridInfo.SubfileNum(FieldNum : string) : string;
  begin
    Result := '';
    if FieldType(FieldNum) <> fmftSubfile then exit;
    Result := ExtractNum(FldInfo(FieldNum), 1);
  end;


  procedure TGridInfo.ExtractVarPtrInfo(FieldNum : string; VarPtrInfo : TStringList);
  begin
    VarPtrInfo.Clear;
    if FieldType(FieldNum) <> fmftVarPtr then exit;
    uTMGUtil.ExtractVarPtrInfo(VarPtrInfo, Data, FileNum, FieldNum);
  end;

  //---------------------------------------------------
  //---------------------------------------------------

  constructor TCompleteGridInfo.Create;
  begin
    inherited Create;
    BasicTemplate := TStringList.Create;  //DOES own object
    Data := TStringList.Create;           //DOES own object
  end;

  destructor TCompleteGridInfo.Destroy;
  begin
    BasicTemplate.Free;
    Data.Free;
    inherited Destroy;
  end;

  procedure TCompleteGridInfo.Assign(Source : TGridInfo);
  var tempData : TStringList;
      tempBasicTemplate : TStringList;
  begin
    tempData := Self.Data;
    tempBasicTemplate := Self.BasicTemplate;
    Inherited Assign(Source);
    Self.Data := tempData;
    Self.BasicTemplate := tempBasicTemplate;
    if Assigned(Source.BasicTemplate) then begin
      Self.BasicTemplate.Assign(Source.BasicTemplate);
    end else begin
      Self.BasicTemplate.Clear;
    end;
    if assigned(Source.Data) then begin
      Self.Data.Assign(Source.Data);
    end else begin
      Self.Data.Clear;
    end;
  end;

  procedure TCompleteGridInfo.Assign(Source : TCompleteGridInfo);
  begin
    Self.Assign(TGridInfo(Source));
  end;


  procedure TCompleteGridInfo.Clear;
  var tempData : TStringList;
      tempBasicTemplate : TStringList;
  begin
    tempData := Self.Data;
    tempBasicTemplate := Self.BasicTemplate;
    Inherited Clear;
    Self.Data := tempData;
    Self.Data.Clear;
    Self.BasicTemplate := tempBasicTemplate;
    Self.BasicTemplate.Clear;
  end;

  //---------------------------------------------------
  //---------------------------------------------------


  function ConvertRemDlgItemTypeName(Name : string) : char;
  var i : TRemDlgElementType;
  begin
    result := ' ';
    for i := TRemDlgElementType(0) to LAST_REMINDER_DIALOG_ELEMENT_TYPE do begin
      if UpperCase(REMINDER_DIALOG_ELEMENT_TYPE[i].Name) <> UpperCase(Name) then continue;
      Result := REMINDER_DIALOG_ELEMENT_TYPE[i].Initial;
      break;
    end;
  end;


  function ConvertRemDlgItemTypeTag(TagOrName : string) : TRemDlgElementType;
  var i : TRemDlgElementType;
  begin
    result := detNone;
    for i := TRemDlgElementType(0) to LAST_REMINDER_DIALOG_ELEMENT_TYPE do begin
      if (REMINDER_DIALOG_ELEMENT_TYPE[i].Initial = TagOrName)
      or (UpperCase(REMINDER_DIALOG_ELEMENT_TYPE[i].Name) = UpperCase(TagOrName)) then begin
        Result := i;
        break;
      end;
    end;
  end;

  function GetRemDelItemTypeName(Tag : char) : string;
  var i : TRemDlgElementType;
  begin
    Result := '';
    for i := TRemDlgElementType(0) to LAST_REMINDER_DIALOG_ELEMENT_TYPE do begin
      if REMINDER_DIALOG_ELEMENT_TYPE[i].Initial <> Tag then continue;
      Result := REMINDER_DIALOG_ELEMENT_TYPE[i].Name;
      break;
    end;
  end;

end.
