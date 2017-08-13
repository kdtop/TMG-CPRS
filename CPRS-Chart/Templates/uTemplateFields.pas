unit uTemplateFields;

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
  Forms, SysUtils, Classes, Dialogs, StdCtrls, ExtCtrls, Controls, Contnrs,
  uHTMLDlg, //kt added 1/16
  Graphics, ORClasses, ComCtrls, ORDtTm, uDlgComponents, TypInfo, ORFn, StrUtils;

type
  TTemplateFieldType = (dftUnknown, dftEditBox, dftComboBox, dftButton, dftCheckBoxes,
    dftRadioButtons, dftDate, dftNumber, dftHyperlink, dftWP, dftText,
// keep dftScreenReader as last entry - users can not create this type of field
    dftScreenReader);

  TDBControlBinding = (  //kt added 6/16
    dbcbInvalid = -1,
    dbcbNone=0,       //traditional VanillaCPRS behavior
    dbcbReadWrite,    //control reads default from database, and writes new user values back to database
    dbcbWriteOnly     //control uses traditional default (not ready from database), and writes new user values back to database
  );
const
  DB_CONTROL_BINDING_LABELS : array[dbcbNone .. dbcbWriteOnly] of string = (
    'None', 'Read & Write', 'Write Only'
  );

type
  TTmplFldDateType = (dtUnknown, dtDate, dtDateTime, dtDateReqTime,
                                 dtCombo, dtYear, dtYearMonth);

const
  FldItemTypes  = [dftComboBox, dftButton, dftCheckBoxes, dftRadioButtons, dftWP, dftText];
  SepLinesTypes = [dftCheckBoxes, dftRadioButtons];
  EditLenTypes  = [dftEditBox, dftComboBox, dftWP];
  EditTextTypes = [dftText, dftWP];  //kt added
  EditDfltTypes = [dftEditBox, dftHyperlink];
  EditDfltType2 = [dftEditBox, dftHyperlink, dftDate];
  ItemDfltTypes = [dftComboBox, dftButton, dftCheckBoxes, dftRadioButtons];
  NoRequired    = [dftHyperlink, dftText];
  ExcludeText   = [dftHyperlink, dftText];
  DateComboTypes = [dtCombo, dtYear, dtYearMonth];

type
  //kt ----- mod 5/16 Added code. ---------------
  TDBControlData = class(TStringList)
  //NOTE: Value is stored in the .Strings[i] and IEN is stored in .Objects[i]
  private
    function GetVal(i : integer) : string;
    procedure SetVal(i : integer; Val : string);
    function GetIENVal(i : integer) : string;
    procedure SetIENVal(i : integer; Val : string);
  public
    procedure MsgIfNotEmpty(S : string; MsgDlgType : TMsgDlgType = mtInformation);
    procedure MsgNoSave;
    procedure MsgShouldSave;  //temp
    function SaveToServer(IEN8925 : int64; var ErrStr : string) : boolean;
    function AddValue(IEN, Value : string) : integer;
    property Value[i : integer] : string read GetVal write SetVal;
    property IEN[i : integer] : string read GetIENVal write SetIENVal;
  end;

  //kt TNotifyWriteDBControlData = procedure(Data : TDBControlData) of object;
  //kt ----- end mod 5/16 ---------------


  TTemplateDialogEntry = class(TObject)
  private
    FID: string;
    FFont: TFont;
    FPanel: TDlgFieldPanel;
    FControls: TStringList; //kt doc. Each line contains either text to show, or .Object = Wincontrol to add to form
    FHTMLControls: TStringList; //kt added 1/16.  Each line contains either text to show, or pseudoHTML
    FIndents: TStringList;
    FFirstBuild: boolean;
    FOnChange: TNotifyEvent;
    FText: string;
    FInternalID: string;
    FObj: TObject;
    FFieldValues: string;
    FUpdating: boolean;
    FAutoDestroyOnPanelFree: boolean;
    FPanelDying: boolean;
    FOnDestroy: TNotifyEvent;
    procedure KillLabels;
    function GetFieldValues: string;
    procedure SetFieldValues(const Value: string);
    procedure SetAutoDestroyOnPanelFree(const Value: boolean);
    //kt function StripCode(var txt: string; code: char): boolean;  //kt moved to function not in object
  protected
    FHTMLText : string;                                 //kt added 1/16
    FPseudoHTMLSource : TStringList;                    //kt added
    FHTMLDlg : THTMLDlg;                                //kt added 1/16
    procedure UpDownChange(Sender: TObject);
    procedure DoChange(Sender: TObject);
    function GetControlText(CtrlID: integer; NoCommas: boolean;
                            var FoundEntry: boolean; AutoWrap: boolean;
                            emField: string = ''): string;
    function GetHTMLControlText(CtrlID: integer; NoCommas: boolean;
                            var FoundEntry: boolean; var ControlDisabled: boolean;
                            emField: string = ''): string;  //kt added 1/6
    procedure SetControlText(CtrlID: integer; AText: string);
  public
    DBControlData : TDBControlData; //kt added 5/16    Not owned here..
    constructor Create(AParent: TWinControl; AID, Text: string);
    destructor Destroy; override;
    function GetPanel(MaxLen: integer; AParent: TWinControl;
                      OwningCheckBox: TCPRSDialogParentCheckBox): TDlgFieldPanel;
    procedure AddToCumulativeHTML(HTMLDlg : THTMLDlg);
    function GetText: string;
    function GetHTMLText: string;  //kt 2/20/16 added
    property Text: string read FText write FText;
    property InternalID: string read FInternalID write FInternalID;
    property ID: string read FID;
    property Obj: TObject read FObj write FObj;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property FieldValues: string read GetFieldValues write SetFieldValues;
    property AutoDestroyOnPanelFree: boolean read FAutoDestroyOnPanelFree
                                             write SetAutoDestroyOnPanelFree;
  end;

  TTemplateField = class(TObject)
  private
  protected  //kt <-- changed this section from private to protected, so allow descendant to operate on these...
    FMaxLen: integer;
    FFldName: string;
    FNameChanged: boolean;
    FLMText: string;  //List Manager Text-- "...text to insert into a boilerplate when expanded from a list manager interface."
    FEditDefault: string;  //kt Changed such that if starts with special tag, then tag specifies data-control modes
    FNotes: string;
    FItems: string;
    FInactive: boolean;
    FItemDefault: string;  //kt FYI, does NOT contain data-control tag.
    FFldType: TTemplateFieldType;
    FRequired: boolean;
    FSepLines: boolean;
    FTextLen: integer;
    FIndent: integer;
    FPad: integer;
    FMinVal: integer;
    FMaxVal: integer;
    FIncrement: integer;
    FURL: string;
    FDateType: TTmplFldDateType;
    FModified: boolean;
    FID: string;
    FLocked: boolean;
    FPseudoHTML : string;                                     //kt added 1/16
    FDFNOfLastServerRead : string;                            //kt added 5/16
    FDTOfLastServerRead : TDateTime;                          //kt added 5/16
    FLastServerReadValue : String;                            //kt added 5/16
    function GetEditDefault: string;                          //kt added 5/16
    procedure SetEditDefault(const Value: string);
    procedure SetFldName(const Value: string);
    procedure SetFldType(const Value: TTemplateFieldType);
    procedure SetInactive(const Value: boolean);
    procedure SetRequired(const Value: boolean);
    procedure SetSepLines(const Value: boolean);
    procedure SetItemDefault(const Value: string);
    function  GetItemDefault: string;                         //kt added 5/16
    procedure SetItems(const Value: string);
    function  GetItems: string;                               //kt added 5/16
    procedure SetLMText(const Value: string);
    procedure SetMaxLen(const Value: integer);
    procedure SetNotes(const Value: string);
    procedure SetID(const Value: string);
    procedure SetIncrement(const Value: integer);
    procedure SetIndent(const Value: integer);
    procedure SetMaxVal(const Value: integer);
    procedure SetMinVal(const Value: integer);
    procedure SetPad(const Value: integer);
    procedure SetTextLen(const Value: integer);
    procedure SetURL(const Value: string);
    function GetTemplateFieldDefault: string;
    function SaveError: string;
    function Width: integer;
    function GetRequired: boolean;
    procedure SetDateType(const Value: TTmplFldDateType);
    function GetDataBinding : TDBControlBinding;                //kt added 6/16
    procedure SetDataBinding (Value : TDBControlBinding);       //kt added 6/16
    procedure SetLastServerReadValue(Value : string);           //kt added 5/16
    function  GetInnerEditDefaultValue : string;                //kt added 7/16
  public
    constructor Create(AData: TStrings);
    destructor Destroy; override;
    procedure CreateDialogControls(Entry: TTemplateDialogEntry; var Index: Integer; CtrlID: integer); //kt moved from private to public
    procedure CacheDBValue(DFN, Value : string);              //kt added 5/16
    function IsDBControl_Reader : boolean;                    //kt added 6/16
    function IsDBControl_Writer : boolean;                    //kt added 6/16
    function IsDBControl : boolean;                           //kt added 6/16
    procedure Assign(AFld: TTemplateField);
    function NewField: boolean;
    function CanModify: boolean;
    property ID: string read FID write SetID;
    property FldName: string read FFldName write SetFldName;
    property NameChanged: boolean read FNameChanged;
    property FldType: TTemplateFieldType read FFldType write SetFldType;
    property MaxLen: integer read FMaxLen write SetMaxLen;
    //kt original --> property EditDefault: string read FEditDefault write SetEditDefault;
    property EditDefault: string read GetEditDefault write SetEditDefault;  //kt mod  5/16
    //kt original --> property Items: string read FItems write SetItems;
    property Items: string read GetItems write SetItems;                    //kt mod  5/16
    //kt original --> property ItemDefault: string read FItemDefault write SetItemDefault;
    property ItemDefault: string read GetItemDefault write SetItemDefault; //kt mod  5/16
    property LMText: string read FLMText write SetLMText;
    property Inactive: boolean read FInactive write SetInactive;
    property Required: boolean read GetRequired write SetRequired;
    property SepLines: boolean read FSepLines write SetSepLines;
    property TextLen: integer read FTextLen write SetTextLen;
    property Indent: integer read FIndent write SetIndent;
    property Pad: integer read FPad write SetPad;
    property MinVal: integer read FMinVal write SetMinVal;
    property MaxVal: integer read FMaxVal write SetMaxVal;
    property Increment: integer read FIncrement write SetIncrement;
    property URL: string read FURL write SetURL;
    property DateType: TTmplFldDateType read FDateType write SetDateType;
    property Notes: string read FNotes write SetNotes;
    property TemplateFieldDefault: string read GetTemplateFieldDefault;
    property DataBinding : TDBControlBinding read GetDataBinding write SetDataBinding; //kt added 6/16
    property LastServerReadValue : String read FLastServerReadValue write SetLastServerReadValue;  //kt added 5/16

  end;

  TIntStruc = class(TObject)
  public
    x: integer;
  end;

//kt original 5/16 --> function GetDialogEntry(AParent: TWinControl; AID, AText: string): TTemplateDialogEntry;
function GetDialogEntry(AParent: TWinControl; AID, AText: string; DBControlData : TDBControlData): TTemplateDialogEntry;
procedure FreeEntries(SL: TStrings);
procedure AssignFieldIDs(var Txt: string; NameToObjID : TStringList=nil); overload;  //kt-tm modified
procedure AssignFieldIDs(SL: TStrings; NameToObjID : TStringList=nil); overload; //kt-tm modified
//kt 9/11 original --> function ResolveTemplateFields(Text: string; AutoWrap: boolean; Hidden: boolean = FALSE; IncludeEmbedded: boolean = FALSE): string;
function ResolveTemplateFields(Text: string;
                               AutoWrap: boolean;
                               Hidden: boolean = FALSE;
                               IncludeEmbedded: boolean = FALSE;
                               HTMLTargetMode : boolean = FALSE;     //kt 9/11
                               HTMLAnswerOpenTag : string = '';      //kt 9/11
                               HTMLAnswerCloseTag : string = '';     //kt 9/11
                               DBControlData : TDBControlData = nil //kt 5/16
                               ): string;
function ResolveHTMLTemplateFields(Text: string;                   //kt added 2/20
                               AutoWrap: boolean;
                               Hidden: boolean = FALSE;
                               IncludeEmbedded: boolean = FALSE;
                               HTMLTargetMode : boolean = FALSE;
                               HTMLAnswerOpenTag : string = '';
                               HTMLAnswerCloseTag : string = ''
                               ): string;

function AreTemplateFieldsRequired(const Text: string; FldValues: TORStringList =  nil): boolean;
function HasTemplateField(txt: string): boolean;

function GetTemplateField(ATemplateField: string; ByIEN: boolean): TTemplateField;
function TemplateFieldNameProblem(Fld: TTemplateField): boolean;
function SaveTemplateFieldErrors: string;
procedure ClearModifiedTemplateFields;
function AnyTemplateFieldsModified: boolean;
procedure ListTemplateFields(const AText: string; AList: TStrings; ListErrors: boolean = FALSE);
function BoilerplateTemplateFieldsOK(const AText: string; Msg: string = ''): boolean;
procedure EnsureText(edt: TEdit; ud: TUpDown);
procedure ConvertCodes2Text(sl: TStrings; Short: boolean);
function StripEmbedded(iItems: string): string;
procedure StripScreenReaderCodes(var Text: string); overload;
procedure StripScreenReaderCodes(SL: TStrings); overload;
function HasScreenReaderBreakCodes(SL: TStrings): boolean;
function GetRPCTIUObj(TIUObjName : string) : string;  //kt added
function TemplateFieldCode2Field(const Code: string): TTemplateFieldType;  //kt added to interface
function TemplateDateCode2DateType(const Code: string): TTmplFldDateType;   //kt added to interface

type                                                     //kt 9/11
  TMGExtension = (tmgeFN,tmgeOBJ);                       //kt 9/11
  TMGExtMatch = record                                   //kt 9/11
    Signature : string;                                  //kt 9/11
    SigLen : integer;                                    //kt 9/11
    EndTag : char;                                       //kt 9/11
  end;                                                   //kt 9/11
  TMGExtArray = array[tmgeFN..tmgeOBJ] of TMGExtMatch;   //kt 9/11

const
  TemplateFieldSignature = '{FLD';
  TemplateFieldBeginSignature = TemplateFieldSignature + ':';
  TemplateFieldEndSignature = '}';

  MACRO_BEGIN_TAG = '{MACRO:';                    //elh  10/14/14
  MACRO_END_TAG = '}';                            //elh  10/14/14
  MACRO_BEGIN_TAGLEN = length(MACRO_BEGIN_TAG);   //elh  10/14/14
  MACRO_END_TAGLEN = length(MACRO_END_TAG);       //elh  10/14/14
  HTML_BEGIN_TAG = '{HTML:';                      //kt 9/11
  HTML_ENDING_TAG = '}';                          //kt 9/11
  HTML_BEGIN_TAGLEN = length(HTML_BEGIN_TAG);     //kt 9/11
  HTML_ENDING_TAGLEN = length(HTML_ENDING_TAG);   //kt 9/11
  FN_BEGIN_SIGNATURE = '{FN:';                    //kt 9/11
  FN_BEGIN_TAG = '{';                             //kt 9/11
  FN_END_TAG = '}';                               //kt 9/11
  IMG_BEGIN_TAG = '{IMAGE:';                      //kt 9/11
  IMG_END_TAG = '}';                              //kt 9/11
  IMG_BEGIN_TAGLEN = length(IMG_BEGIN_TAG);       //kt 9/11
  IMG_END_TAGLEN = length(IMG_END_TAG);           //kt 9/11
  HTML_CTRL_TAG = '{HTML_CTRL:';                  //kt 3/16
  HTML_CTRL_END_TAG = '}';                        //kt 3/16
  NO_FORMATTED_ANSWERS = '{HTML:<NO_FORMATTED_ANSWERS>}';  //kt
  DATABASE_CONTROL = '$DB$';                       //kt 6/16
  DATABASE_CONTROL_RW_TAG = DATABASE_CONTROL+'_RW$';//kt 6/16
  DATABASE_CONTROL_W_TAG = DATABASE_CONTROL+'_W$';  //KT 6/16

  ScreenReaderCodeSignature = '{SR-';
  ScreenReaderCodeType = '  Screen Reader Code';
  ScreenReaderCodeCount = 2;
  ScreenReaderShownCount = 1;
  ScreenReaderStopCode = ScreenReaderCodeSignature + 'STOP' + TemplateFieldEndSignature;
  ScreenReaderStopCodeLen = Length(ScreenReaderStopCode);
  ScreenReaderStopCodeID = '-43';
  ScreenReaderStopName = 'SCREEN READER STOP CODE **';
  ScreenReaderStopCodeLine = ScreenReaderStopCodeID + U + ScreenReaderStopName + U + ScreenReaderCodeType;
  ScreenReaderContinueCode = ScreenReaderCodeSignature + 'CONT' + TemplateFieldEndSignature;
  ScreenReaderContinueCodeLen = Length(ScreenReaderContinueCode);
  ScreenReaderContinueCodeOld = ScreenReaderCodeSignature + 'CONTINUE' + TemplateFieldEndSignature;
  ScreenReaderContinueCodeOldLen = Length(ScreenReaderContinueCodeOld);
  ScreenReaderContinueCodeID = '-44';
  ScreenReaderContinueCodeName = 'SCREEN READER CONTINUE CODE ***';
  ScreenReaderContinueCodeLine = ScreenReaderContinueCodeID + U + ScreenReaderContinueCodeName + U + ScreenReaderCodeType;
  MissingFieldsTxt = 'One or more required fields must still be entered.';

  ScreenReaderCodes:     array[0..ScreenReaderCodeCount] of string  =
      (ScreenReaderStopCode, ScreenReaderContinueCode, ScreenReaderContinueCodeOld);
  ScreenReaderCodeLens:  array[0..ScreenReaderCodeCount] of integer =
      (ScreenReaderStopCodeLen, ScreenReaderContinueCodeLen, ScreenReaderContinueCodeOldLen);
  ScreenReaderCodeIDs:   array[0..ScreenReaderShownCount] of string  =
      (ScreenReaderStopCodeID, ScreenReaderContinueCodeID);
  ScreenReaderCodeLines: array[0..ScreenReaderShownCount] of string  =
      (ScreenReaderStopCodeLine, ScreenReaderContinueCodeLine); 

  TemplateFieldTypeCodes: array[TTemplateFieldType] of string[1] =
                         {  dftUnknown      } ('',
                         {  dftEditBox      }  'E',
                         {  dftComboBox     }  'C',
                         {  dftButton       }  'B',
                         {  dftCheckBoxes   }  'X',
                         {  dftRadioButtons }  'R',
                         {  dftDate         }  'D',
                         {  dftNumber       }  'N',
                         {  dftHyperlink    }  'H',
                         {  dftWP           }  'W',
                         {  dftText         }  'T',
                         {  dftScreenReader }  'S');

  TemplateFieldTypeDesc: array[TTemplateFieldType, boolean] of string =
                         {  dftUnknown      } (('',''),
                         {  dftEditBox      }  ('Edit Box',           'Edit'),
                         {  dftComboBox     }  ('Combo Box',          'Combo'),
                         {  dftButton       }  ('Button',             'Button'),
                         {  dftCheckBoxes   }  ('Check Boxes',        'Check'),
                         {  dftRadioButtons }  ('Radio Buttons',      'Radio'),
                         {  dftDate         }  ('Date',               'Date'),
                         {  dftNumber       }  ('Number',             'Num'),
                         {  dftHyperlink    }  ('Hyperlink',          'Link'),
                         {  dftWP           }  ('Word Processing',    'WP'),
                         {  dftText         }  ('Display Text',       'Text'),
                         {  dftScreenReader }  ('Screen Reader Stop', 'SRStop'));

  TemplateDateTypeDesc: array[TTmplFldDateType, boolean] of string =
                         { dtUnknown        } (('',''),
                         { dtDate           }  ('Date',           'Date'),
                         { dtDateTime       }  ('Date & Time',    'Time'),
                         { dtDateReqTime    }  ('Date & Req Time','R.Time'),
                         { dtCombo          }  ('Date Combo',     'C.Date'),
                         { dtYear           }  ('Year',           'Year'),
                         { dtYearMonth      }  ('Year & Month',   'Month'));

  FldNames: array[TTemplateFieldType] of string =
                   { dftUnknown      }  ('',
                   { dftEditBox      }  'EDIT',
                   { dftComboBox     }  'LIST',
                   { dftButton       }  'BTTN',
                   { dftCheckBoxes   }  'CBOX',
                   { dftRadioButtons }  'RBTN',
                   { dftDate         }  'DATE',
                   { dftNumber       }  'NUMB',
                   { dftHyperlink    }  'LINK',
                   { dftWP           }  'WRDP',
                   { dftTExt         }  'TEXT',
                   { dftScreenReader }  'SRST');

  TemplateFieldDateCodes: array[TTmplFldDateType] of string[1] =
                         { dtUnknown        } ('',
                         { dtDate           }  'D',
                         { dtDateTime       }  'T',
                         { dtDateReqTime    }  'R',
                         { dtCombo          }  'C',
                         { dtYear           }  'Y',
                         { dtYearMonth      }  'M');

  MaxTFWPLines = 20;
  MaxTFEdtLen = 70;

  //kt --- start mod ----
  //  moved from implementation to interface
  const
    NewTemplateField = 'NEW TEMPLATE FIELD';
    TemplateFieldSignatureLen = length(TemplateFieldBeginSignature);
    TemplateFieldSignatureEndLen = length(TemplateFieldEndSignature);
    FieldIDDelim = '`';
    FieldIDLen = 6;
    NewLine = 'NL';
  //kt --- end mod ----

implementation

uses
  rTemplates, ORCtrls, mTemplateFieldButton, dShared, uConst, uCore, rCore, Windows,
  ORNet, uCarePlan, fTemplateDialog, HTTPUtil, DateUtils,  //kt added this line
  rTIU, uTemplateMath, uEvaluateExpr, //kt //kt-tm
  VAUtils, VA508AccessibilityManager, VA508AccessibilityRouter
  ,fFrame;

{ //kt moved to interface
const
  NewTemplateField = 'NEW TEMPLATE FIELD';
  TemplateFieldSignatureLen = length(TemplateFieldBeginSignature);
  TemplateFieldSignatureEndLen = length(TemplateFieldEndSignature);
}
var
  uTmplFlds: TList = nil;
  uEntries: TStringList = nil; //kt doc.  .String[i]=FID  .Object[i]=TTemplateDialogEntry

  uNewTemplateFieldIDCnt: longint = 0;
  uRadioGroupIndex: integer = 0;

  uInternalFieldIDCount: integer = 0;

{  //kt moved to interface
const
  FieldIDDelim = '`';
  FieldIDLen = 6;
  NewLine = 'NL';
}

function StripCode(var txt: string; code: char): boolean;  forward;  //kt added line

function GetNewFieldID: string;
begin
  inc(uInternalFieldIDCount);
  Result := IntToStr(uInternalFieldIDCount);
  Result := FieldIDDelim +
            copy(StringOfChar('0', FieldIDLen-2) + Result, length(Result), FieldIDLen-1);
end;

//kt original --> function GetDialogEntry(AParent: TWinControl; AID, AText: string): TTemplateDialogEntry;
function GetDialogEntry(AParent: TWinControl; AID, AText: string;
                        DBControlData : TDBControlData): TTemplateDialogEntry; //kt 5/16
var
  idx: integer;

begin
  Result := nil;
  if AID = '' then exit;
  if(not assigned(uEntries)) then
    uEntries := TStringList.Create;
  idx := uEntries.IndexOf(AID);
  if(idx < 0) then begin
    Result := TTemplateDialogEntry.Create(AParent, AID, AText); //kt 1/16 doc: Parses Text into FControls (and FHTMLControls)
    Result.DBControlData := DBControlData;  //kt added 5/16
    uEntries.AddObject(AID, Result);
  end else
    Result := TTemplateDialogEntry(uEntries.Objects[idx]);
end;

procedure Delete1Entry(idx: integer);
//kt added 5/16
var Obj : TTemplateDialogEntry;
begin
  if not assigned(uEntries) then exit;
  Obj := TTemplateDialogEntry(uEntries.Objects[idx]);
  if not assigned(Obj) then exit;
  Obj.AutoDestroyOnPanelFree := FALSE;  //kt doc <-- property setter alters event handlers.
  Obj.Free;
  uEntries.Delete(idx);
end;

procedure FreeEntries(SL: TStrings);
var i, idx, cnt: integer;
begin
  {//kt mod ---------------------
  //NOTE: this was an attempt to streamline code, but it seemed
          to induce bugs.
  if not assigned(uEntries) then exit;
  for i := SL.Count-1 downto 0 do begin
    idx := uEntries.IndexOf(SL[i]);
    if(idx = -1) then continue;
    Delete1Entry(idx);
    cnt := uEntries.Count;
  end;
  if uEntries.Count = 0 then uInternalFieldIDCount := 0;
  }

  if(assigned(uEntries)) then begin
    for i := SL.Count-1 downto 0 do begin
      idx := uEntries.IndexOf(SL[i]);
      if(idx >= 0) then begin
        cnt := uEntries.Count;
        if(assigned(uEntries.Objects[idx])) then begin
          TTemplateDialogEntry(uEntries.Objects[idx]).AutoDestroyOnPanelFree := FALSE;
          uEntries.Objects[idx].Free;
        end;
        if cnt = uEntries.Count then begin
          uEntries.Delete(idx);
        end;
      end;
    end;
    if(uEntries.Count = 0) then begin
      uInternalFieldIDCount := 0;
      //kt uInternalFormulaCount := 0;  //kt-tm
      //kt uInternalTxtObjCount  := 0;  //kt-tm
      //kt uInternalVarObjCount  := 0;  //kt-tm
    end;
  end;
end;

procedure AssignFieldIDs(var Txt: string; NameToObjID : TStringList);
//kt-tm modified
//procedure AssignFieldIDs(var Txt: string);
var
  i: integer;
  p2 : integer; //kt-tm
  FldName : string; //kt-tm

begin
  i := 0;
  while (i < length(Txt)) do begin
    inc(i);
    if(copy(Txt,i,TemplateFieldSignatureLen) = TemplateFieldBeginSignature) then begin
      inc(i,TemplateFieldSignatureLen);
      if(i < length(Txt)) and (copy(Txt,i,1) <> FieldIDDelim) then begin
        p2 := PosEx(TemplateFieldEndSignature,Txt,i);           //kt-tm
        FldName := '';                                          //kt-tm
        if p2 > 0 then FldName := Trim(copy(Txt,i,(p2-i)));     //kt-tm
        insert(GetNewFieldID, Txt, i);
        inc(i, FieldIDLen);
        if (FldName <> '') and Assigned(NameToObjID) then begin          //kt-tm
          NameToObjID.AddObject(FldName,Pointer(uInternalFieldIDCount)); //kt-tm
        end;                                                             //kt-tm
      end;
    end;
  end;
end;

procedure AssignFieldIDs(SL: TStrings; NameToObjID : TStringList);
//kt-tm modified
var
  i: integer;
  txt: string;

begin
  for i := 0 to SL.Count-1 do begin
    txt := SL[i];
    AssignFieldIDs(txt, NameToObjID); //kt-tm modified to add NameToObjID
    SL[i] := txt;
  end;
end;


function InsideMarkers(var S : string; MarkerCh : char; P : integer) : boolean;
//Function returns if position P is inside characters MarkerCh.
//e.g. S =  'xxx|xxxxx|xxxxx'  MarkerCh='|'
//     P = 2  ==> result is false
//     P = 5  ==> result is true
//     P = 12 ==> result is false

var p1,p2 : integer;
    Inside : boolean;
begin
  Inside := false;
  p1 := Pos(MarkerCh,S);
  while (p1 > 0) do begin
    if (p1 >= P) then break;
    p1 := PosEx(MarkerCh,S,p1+1);
    if (p1 > 0) and (p1 > P) then Inside := not Inside;
  end;
  Result := Inside;
end;

function SubstuteIDs(Txt : string; NameToObjID : TStringList) : string;
//kt 9/11 added function
//Prefix any field names with their FldID's, in format of FieldIDDelim+FldID
// E.g. [FLD:1:NUM1-16] --> `00001NUM1-16`
//Note: Field ID's are started with character FieldIDDelim, and are of a fixed length (FieldIDLen)

(*  Syntax examples:

 {FN:[FLD:1:NUMB1-16]-[FLD:2:NUMB1-16]-[FLD:3:NUMB1-16]}, or
 {FN:[OBJ:TABLE1]-[FLD:2:NUMB1-16]-[FLD:3:NUMB1-16]}, or
 {FN:[OBJ:TABLE2("POTASSIUM")]-[FLD:2:NUMB1-16]-[FLD:3:NUMB1-16]}, or
 {FN:[OBJ:TABLE2([FLD:1:NUMB1-16])]-[FLD:2:NUMB1-16]-[FLD:3:NUMB1-16]}
 {FN:[OBJ:TABLE2((5+3)/2)]-[FLD:2:NUMB1-16]-[FLD:3:NUMB1-16]}
 (arbitrary deep nesting)
 Note: arguments should be found by matching [ ]'s
       An argument will start with a TYPE (so far, FLD or OBJ) and ':'

       If TYPE is FLD, there will be :number:, with number being same
       as number in old format (i.e. ...]#2).
       If number not provided, then default value is 1

       If TYPE is OBJ, then this indicates that the parameter name (e.g. TABLE) is
       the name of a TIU TEXT object, that will be processed on the server.
       Parameters should be resolved before passing to the server.
*)

  Function FldIDNumFn(FldName,FldIndexStr : string) : integer;
  var i,Index,MatchCt : integer;
      AFldName : string;
  begin
    Result := -1;
    Index := StrToIntDef(FldIndexStr,-1);
    if Index = -1 then exit;
    MatchCt := 0;
    for i := 0 to NameToObjID.Count-1 do begin
      if NameToObjID.Strings[i] <> FldName then continue;
      Inc(MatchCt);
      if MatchCt = Index then begin
        Result := Integer(NameToObjID.Objects[i]);
        exit;
      end;
    end;
  end;

var i,j,p1,p2 : integer;
    SubStrA,SubStrB, NumStr : string;
    FldIDNum : integer;
    SubstStr,FldIDNumStr : string;
    CountOfSimStr : string;
    Temp,FldName,FldInfo : string;
    Skip : boolean;
begin
  p1 := PosEx(FN_FIELD_TAG,Txt,1);
  while p1 > 0 do begin
    SubStrA := MidStr(Txt,1,p1-1);
    p1 := p1 + Length(FN_FIELD_TAG);
    p2 := PosEx(']',Txt,p1);   //NOTE: This assumes no '[' in field name.
    FldInfo := MidStr(Txt,p1,(p2-p1));
    SubStrB := MidStr(Txt, p2+1, 999);

    NumStr := piece(FldInfo,':',1);
    FldName := piece(FldInfo,':',2);

    FldIDNum := FldIDNumFn(FldName,NumStr);
    if FldIDNum > -1 then begin
      FldIDNumStr := IntToStr(FldIDNum);
      FldIDNumStr := StringOfChar('0', FieldIDLen-Length(FldIDNumStr)) + FldIDNumStr;
      SubstStr := FieldIDDelim + FldIDNumStr + FldName + FieldIDDelim;
    end else begin
      SubstStr := '???';
    end;
    Txt := SubStrA + SubstStr + SubStrB;
    p1 := PosEx(FN_FIELD_TAG,Txt,p1);
  end;
  Result := Txt;
end;


function GetRPCTIUObj(TIUObjName : string) : string;
//kt 9/11 added function
var SL : TStringList;
begin
  TIUObjName := AnsiReplaceText(TIUObjName,'|','');
  SL := TStringList.Create;
  SL.Text := TIUObjName;
  rTemplates.GetTemplateText(SL);
  Result := SL.Text;
  SL.Free;
end;


Procedure EvalTIUObjects(var Formula : string);
//kt 9/11 added function
var p1,p2 : integer;
    OP1,OP2 : integer;
    Problem : boolean;
    SubStrA, SubStrB : string;
    TIUObj,Argument,s : string;
begin
  p1 := Pos(FN_OBJ_TAG, Formula);
  while (p1 > 0) do begin
    p2 := CloseCharPos('[',']',Formula, p1+1);
    if p2=0 then begin
      Formula := 'ERROR.  Matching "]" not found after ' + FN_OBJ_TAG + '.';
      Exit;
    end;
    SubStrA := MidStr(Formula,1,p1-1);
    p1 := p1+FN_OBJ_TAG_LEN;
    TIUObj := Trim(MidStr(Formula, p1, (p2-p1)));
    SubStrB := MidStr(Formula,p2+1,999);
    OP1 := Pos('{',TIUObj);
    if (OP1 > 0) then begin
      OP2 := CloseCharPos('{','}', TIUObj, OP1+1);
      if OP2=0 then begin
        Formula := 'ERROR.  Matching ")" not found after "(".';
        Exit;
      end;
      Argument := MidStr(TIUObj,OP1+1,(OP2-(OP1+1)));
      if Pos(FN_OBJ_TAG,Argument)>0 then begin
        EvalTIUObjects(Argument)
      end;
      Problem := false;
      //kt 9/11 s := FloatToStr(StringEval(Argument,Problem));
      s := EvalExpression (Argument, Problem);  //kt 9/11
      if Problem then begin
        Formula := 'ERROR evaluating argument: [' + s + '].';
        Exit;
      end else begin
        Argument := s;
      end;
      TIUObj := MidStr(TIUObj,1,OP1-1) + '{' + Argument + '}';
    end;
    TIUObj := GetRPCTIUObj(TIUObj);
    Formula := SubStrA + TIUObj + SubStrB;
    p1 := Pos(FN_OBJ_TAG, Formula);
  end;
end;


procedure WordWrapText(var Txt: string; HTMLTargetMode : boolean); //kt 9/11 added HTML Mode
var
  TmpSL: TStringList;
  i: integer;

  function WrappedText(const Str: string; HTMLTargetMode : boolean): string;
  var
    i, i2, j, k, m: integer;
    HTMLStrLen : integer;
    Temp, Temp1, Temp2: string;

  begin
    Temp := Str;
    Result := '';
    i2 := 0;

    repeat
      i := pos(TemplateFieldBeginSignature, Temp);

      if i>0 then
        j := pos(TemplateFieldEndSignature, copy(Temp, i, MaxInt))
      else
        j := 0;

      if (j > 0) then
        begin
        i2 := pos(TemplateFieldBeginSignature, copy(Temp, i+TemplateFieldSignatureLen, MaxInt));
        if (i2 = 0) then
          i2 := MaxInt
        else
          i2 := i + TemplateFieldSignatureLen + i2 - 1;
        end;

      if (i>0) and (j=0) then
        i := 0;

      if (i>0) and (j>0) then
        if (j > i2) then
          begin
          Result := Result + copy(Temp, 1, i2-1);
          delete(Temp, 1, i2-1);
          end
        else
          begin
          for k := (i+TemplateFieldSignatureLen) to (i+j-2) do
            if Temp[k]=' ' then
              Temp[k]:= #1;
          i := i + j - 1;
          Result := Result + copy(Temp,1,i);
          delete(Temp,1,i);
          end;

    until (i = 0);

    Result := Result + Temp;

    //kt 9/11 -- start mod ---
    //Count the HTML tag length and add to MAX_ENTRY WIDTH
    HTMLStrLen := 0;
    if HTMLTargetMode = True then begin
      temp1 := Result;
      while (pos('<',temp1)>0) and (pos('>',temp1)>0) do begin
        temp2 := MidStr(temp1,pos('<',temp1),pos('>',temp1)-pos('<',temp1)+1);
        HTMLStrLen := HTMLStrLen + strlen(PChar(temp2));
        temp1 := Rightstr(temp1,strlen(PChar(temp1))-pos('>',temp1));
      end;
    end else begin
    Result := WrapText(Result, #13#10, [' '], MAX_ENTRY_WIDTH);
    end;
    //kt 9/11 -- end mod --
    //Result := WrapText(Result, #13#10, [' '], MAX_ENTRY_WIDTH+HTMLStrLen);  //kt 9/11 added +HTMLStrLen
    //Result := WrapText(Result, #13#10, [' '], MAX_ENTRY_WIDTH);
    repeat
      i := pos(#1, Result);
      if i > 0 then
        Result[i] := ' ';
    until i = 0;
  end;

begin
  if length(Txt) > MAX_ENTRY_WIDTH then
  begin
    TmpSL := TStringList.Create;
    try
      TmpSL.Text := Txt;
      Txt := '';
      for i := 0 to TmpSL.Count-1 do
      begin
        if Txt <> '' then
          Txt := Txt + CRLF;
        Txt := Txt + WrappedText(TmpSL[i], HTMLTargetMode); //kt 9/11 added HTMLTargetMode
      end;
    finally
      TmpSL.Free;
    end;
  end;
end;

function ResolveTemplateFields(Text: string;
                               AutoWrap: boolean;
                               Hidden: boolean = FALSE;
                               IncludeEmbedded: boolean = FALSE;
                               HTMLTargetMode : boolean = FALSE;    //kt 9/11  TRUE if plain-text template is to be put into HTML document
                               HTMLAnswerOpenTag : string = '';     //kt 9/11
                               HTMLAnswerCloseTag : string = '';    //kt 9/11
                               DBControlData : TDBControlData = nil //kt 5/16
                               ): string;

  //uses uEntries in global scope
  //indirectly uses uTmplFlds in global scope.
var
  flen, CtrlID, i, j: integer;
  Entry: TTemplateDialogEntry;
  iField, Temp, NewTxt, Fld: string;
  FoundEntry: boolean;
  TmplFld: TTemplateField;
  tempSL : TStringList;

  procedure AddNewTxt(var Result, Temp, NewTxt : string; var i : integer);
  begin
    if(NewTxt <> '') then begin
      insert(StringOfChar('x',length(NewTxt)), Temp, i);  //put 'xxx' into Temp at i
      insert(NewTxt, Result, i);                          //put NewTxt into Result at i
      inc(i, length(NewTxt));
    end;
  end;

  function GetFldInfo(var Txt1, Txt2 : string; i : integer; var CtrlID : integer; var Fld : string) : boolean;
  //kt broke this code out into this separate function.  Originaly was inline below.
  //Result is if OK
  var flen, j : integer;
  begin
    CtrlID := 0;
    if(copy(Txt1, i + TemplateFieldSignatureLen, 1) = FieldIDDelim) then begin
      CtrlID := StrToIntDef(copy(Txt1, i + TemplateFieldSignatureLen + 1, FieldIDLen-1), 0);
      delete(Txt1,i + TemplateFieldSignatureLen, FieldIDLen);
      delete(Txt2,i + TemplateFieldSignatureLen, FieldIDLen);
    end;
    j := pos(TemplateFieldEndSignature, copy(Txt1, i + TemplateFieldSignatureLen, MaxInt));
    Fld := '';
    if(j > 0) then begin
      inc(j, i + TemplateFieldSignatureLen - 1);
      flen := j - i - TemplateFieldSignatureLen;
      Fld := copy(Txt1,i + TemplateFieldSignatureLen, flen);
      delete(Txt1,i,flen + TemplateFieldSignatureLen + 1);
      delete(Txt2,i,flen + TemplateFieldSignatureLen + 1);
    end else begin
      delete(Txt1,i,TemplateFieldSignatureLen);
      delete(Txt2,i,TemplateFieldSignatureLen);
    end;
    Result := (CtrlID > 0);
  end;

//e.g. of Text passed in...
//  'Intensity? {FLD:`00001NUM 0-10}'#$D#$A' Episodes each day? {FLD:`00002NUM 0-10}'#$D#$A    <-- wrapped
//  '{FN:SCORE^H:`000001NUM 0-10` + `000002NUM 0-10`}{{NO-BR}}'#$D#$A   <-- wrapped
//  'Final score = {FN:[FN:SCORE]}'#$D#$A  <-- wrapped
//  'Impression: <b>{FN:CASE([FN:SCORE]<3,TEXT(Mild))}{FN:CASE([FN:SCORE]>7,TEXT(Severe)}{{NO-BR}}'#$D#$A  <-- wrapped
//  '{FN:CASE(IN([FN:SCORE],3,7),TEXT(Moderate))}</b>'
begin
  if frmFrame.tabPage.TabIndex=5 then HTMLTargetMode := False;  //kt Suppress HTML if Consults
  if(not assigned(uEntries)) then
    uEntries := TStringList.Create;
  Result := Text;
  Temp := Text; // Use Temp to allow template fields to contain other template field references
  repeat //cycle through each {FLD:...} entry in input Text;
    i := pos(TemplateFieldBeginSignature, Temp);
    if i = 0 then continue;
    if not GetFldInfo(Temp, Result, i, CtrlID, Fld) then continue;
    FoundEntry := FALSE;
    for j := 0 to uEntries.Count-1 do begin
      if FoundEntry then break;
      Entry := TTemplateDialogEntry(uEntries.Objects[j]);
      if not assigned(Entry) then continue;
      if IncludeEmbedded then iField := Fld else iField := '';
      NewTxt := Entry.GetControlText(CtrlID, FALSE, FoundEntry, AutoWrap, iField);
      TmplFld := GetTemplateField(Fld, FALSE); // TmplFld is TTemplateField.  Uses uTmplFlds in global scope.
      if not assigned(TmplFld) then continue;
      if TmplFld.DateType in DateComboTypes then NewTxt := Piece(NewTxt,':',1);
      //if TmplFld.IsDBControl and assigned(DBControlData) then begin //kt 5/16
      if TmplFld.IsDBControl_Writer and assigned(DBControlData) then begin //kt 5/16
        DBControlData.AddValue(TmplFld.ID, NewTxt); //store DB control's data, to be written out later
      end;
      if NewTxt = '' then continue;
      if HTMLTargetMode then NewTxt := HTMLAnswerOpenTag + NewTxt + HTMLAnswerCloseTag;          //kt 9/11
      if FoundEntry and (TmplFld.FFldType<>dftText) and (TmplFld.FFldType<>dftHyperlink) then begin
        uCarePlan.CheckWrapForCPResult(NewTxt);  //kt 9/11
      end;
      AddNewTxt(Result, Temp, NewTxt, i);
    end;
    if Hidden and (not FoundEntry) and (Fld <> '') then begin
      NewTxt := TemplateFieldBeginSignature + Fld + TemplateFieldEndSignature;
      AddNewTxt(Result, Temp, NewTxt, i);
    end;
    (*  original ... Delete later
    if(i > 0) then begin
      CtrlID := 0;
      if(copy(Temp, i + TemplateFieldSignatureLen, 1) = FieldIDDelim) then begin
        CtrlID := StrToIntDef(copy(Temp, i + TemplateFieldSignatureLen + 1, FieldIDLen-1), 0);
        delete(Temp,i + TemplateFieldSignatureLen, FieldIDLen);
        delete(Result,i + TemplateFieldSignatureLen, FieldIDLen);
      end;
      j := pos(TemplateFieldEndSignature, copy(Temp, i + TemplateFieldSignatureLen, MaxInt));
      Fld := '';
      if(j > 0) then begin
        inc(j, i + TemplateFieldSignatureLen - 1);
        flen := j - i - TemplateFieldSignatureLen;
        Fld := copy(Temp,i + TemplateFieldSignatureLen, flen);
        delete(Temp,i,flen + TemplateFieldSignatureLen + 1);
        delete(Result,i,flen + TemplateFieldSignatureLen + 1);
      end else begin
        delete(Temp,i,TemplateFieldSignatureLen);
        delete(Result,i,TemplateFieldSignatureLen);
      end;
      if(CtrlID > 0) then begin
        FoundEntry := FALSE;
        for j := 0 to uEntries.Count-1 do begin
          Entry := TTemplateDialogEntry(uEntries.Objects[j]);
          if(assigned(Entry)) then begin
            if IncludeEmbedded then
              iField := Fld
            else
              iField := '';
            NewTxt := Entry.GetControlText(CtrlID, FALSE, FoundEntry, AutoWrap, iField);
            TmplFld := GetTemplateField(Fld, FALSE);
            if (assigned(TmplFld)) and (TmplFld.DateType in DateComboTypes) then {if this is a TORDateBox}
               NewTxt := Piece(NewTxt,':',1);          {we only want the first piece of NewTxt}
            if (HTMLTargetMode=true) and (NewTxt <> '') then begin                //kt 9/11
              NewTxt := HTMLAnswerOpenTag + NewTxt + HTMLAnswerCloseTag;          //kt 9/11
            end;                                                                  //kt 9/11
            //kt ASSIGNED WAS ADDED BELOW BECAUSE EXPECTION ERRORS WERE BEING GENERATED
            if (FoundEntry) and (assigned(TmplFld)) and (TmplFld.FFldType<>dftText) and (TmplFld.FFldType<>dftHyperlink) then uCarePlan.CheckWrapForCPResult(NewTxt);  //kt 9/11
            AddNewTxt;
          end;
          if FoundEntry then break;
        end;
        if Hidden and (not FoundEntry) and (Fld <> '') then begin
          NewTxt := TemplateFieldBeginSignature + Fld + TemplateFieldEndSignature;
          //NewHTMLTxt := NewTxt;  //kt 1/16
          AddNewTxt;
          //AddHTMLNewTxt;  //kt 1/16
        end;
      end;
    end;
    *)
  until(i = 0);
  Result := ResolveTemplateFieldsMath(Result,uEntries,AutoWrap,IncludeEmbedded); //kt-tm
  if not AutoWrap then begin
    WordWrapText(Result, HTMLTargetMode);  //kt 9/11 added HTMLTargetMode
  end;
end;

function ResolveHTMLTemplateFields(Text: string;
                                   AutoWrap: boolean;
                                   Hidden: boolean = FALSE;
                                   IncludeEmbedded: boolean = FALSE;
                                   HTMLTargetMode : boolean = FALSE;  //TRUE if template text is to be put into HTML document
                                   HTMLAnswerOpenTag : string = '';
                                   HTMLAnswerCloseTag : string = ''
                                   ): string;
                                   //IncludeEmbedded: boolean = FALSE): string;
//Uses globally-scoped uEntries, which is list of all TTemplate entries....
//   I would rather this was passed in explicitly.  Maybe later...
//kt added entire function 2/20/16
//kt this was copied and modified from ResolveTemplateFields() -- with substantial revisions.
var
  CtrlIDStr : string;
  {flen,} CtrlID  : integer;
  Entry: TTemplateDialogEntry;
  iField, Fld: string;
  {HTMLTemp, } NewHTMLTxt : string;
  i : integer;
  //i2, j2 : integer;
  p1, p2 : integer;
  FoundEntry: boolean;
  FoundHTMLEntry: boolean;
  TmplFld: TTemplateField;
  tempSL : TStringList;
  ControlBlockDisabled : boolean;

begin
  if frmFrame.tabPage.TabIndex=5 then HTMLTargetMode := False;  //kt Suppress HTML if Consults
  Result := '';
  if not assigned(uEntries) then exit;
  ControlBlockDisabled := false;  //kt
  while not ControlBlockDisabled and (Length(Text) > 0) do begin
    p1  := pos(TemplateFieldBeginSignature, Text);
    p2  := PosEx(TemplateFieldEndSignature, Text, p1);
    if (P1 <= 0) or (p2 <= 0) or (p2 < p1) then begin
      Result := Result + text;
      break;
    end;
    Result := Result + MidStr(Text, 1, p1-1);
    Fld := MidStr(Text, p1, (p2 - p1));
    Text := MidStr(Text, p2 + length(TemplateFieldEndSignature), length(Text));  //up to, but excluding closing part.
    Fld := MidStr(Fld, Length(TemplateFieldBeginSignature) + 1, length(Fld));  //trim opening part
    CtrlID := 0;
    if (length(Fld) > 0) and (LeftStr(Fld, Length(FieldIDDelim)) = FieldIDDelim) then begin
      CtrlIDStr := MidStr(Fld, length(FieldIDDelim)+1, FieldIDLen - length(FieldIDDelim));
      CtrlID := StrToIntDef(CtrlIDStr, 0);
    end;
    if CtrlID = 0 then continue;
    Fld := MidStr(Fld, FieldIDLen + 1, length(Fld));
    FoundEntry := FALSE;
    for i := 0 to uEntries.Count-1 do begin
      Entry := TTemplateDialogEntry(uEntries.Objects[i]);
      if not assigned(Entry) then continue;
      if IncludeEmbedded then
        iField := Fld
      else
        iField := '';

      NewHTMLTxt := Entry.GetHTMLControlText(CtrlID, FALSE, FoundHTMLEntry, ControlBlockDisabled, iField);  //kt added 1/16
      if ControlBlockDisabled then begin
        Result := '';
        break;
      end;
      if (HTMLTargetMode=true) and (NewHTMLTxt <> '') then begin
        NewHTMLTxt := HTMLAnswerOpenTag + NewHTMLTxt + HTMLAnswerCloseTag;
      end;
      TmplFld := GetTemplateField(Fld, FALSE);
      if (FoundEntry) and (assigned(TmplFld)) and (TmplFld.FFldType<>dftText)
        and (TmplFld.FFldType<>dftHyperlink) then uCarePlan.CheckWrapForCPResult(NewHTMLTxt);
      Result := Result + NewHTMLTxt;
      if FoundHTMLEntry then break;
      if Hidden and (not FoundEntry) and (Fld <> '') then begin
        NewHTMLTxt := TemplateFieldBeginSignature + Fld + TemplateFieldEndSignature;
        Result := Result + NewHTMLTxt;
      end;
    end;
  end;
  if Result <> '' then
    Result := ResolveTemplateFieldsMath(Result,uEntries,AutoWrap,IncludeEmbedded, true); //kt-tm
end;


function AreTemplateFieldsRequired(const Text: string; FldValues: TORStringList =  nil): boolean;
var
  flen, CtrlID, i, j: integer;
  Entry: TTemplateDialogEntry;
  Fld: TTemplateField;
  Temp, NewTxt, FldName: string;
  FoundEntry: boolean;

begin
  if(not assigned(uEntries)) then
    uEntries := TStringList.Create;
  Temp := Text;
  Result := FALSE;
  repeat
    i := pos(TemplateFieldBeginSignature, Temp);
    if(i > 0) then begin
      CtrlID := 0;
      if(copy(Temp, i + TemplateFieldSignatureLen, 1) = FieldIDDelim) then begin
        CtrlID := StrToIntDef(copy(Temp, i + TemplateFieldSignatureLen + 1, FieldIDLen-1), 0);
        delete(Temp,i + TemplateFieldSignatureLen, FieldIDLen);
      end;
      j := pos(TemplateFieldEndSignature, copy(Temp, i + TemplateFieldSignatureLen, MaxInt));
      if(j > 0) then begin
        inc(j, i + TemplateFieldSignatureLen - 1);
        flen := j - i - TemplateFieldSignatureLen;
        FldName := copy(Temp, i + TemplateFieldSignatureLen, flen);
        Fld := GetTemplateField(FldName, FALSE);
        delete(Temp,i,flen + TemplateFieldSignatureLen + 1);
      end else begin
        delete(Temp,i,TemplateFieldSignatureLen);
        Fld := nil;
      end;
      if(CtrlID > 0) and (assigned(Fld)) and (Fld.Required) then begin
        FoundEntry := FALSE;
        for j := 0 to uEntries.Count-1 do begin
          Entry := TTemplateDialogEntry(uEntries.Objects[j]);
          if(assigned(Entry)) then begin
            NewTxt := Entry.GetControlText(CtrlID, TRUE, FoundEntry, FALSE);
            if FoundEntry and (NewTxt = '') then{(Trim(NewTxt) = '') then //CODE ADDED BACK IN - ZZZZZZBELLC}
              Result := TRUE;
          end;
          if FoundEntry then break;
        end;
        if (not FoundEntry) and assigned(FldValues) then begin
          j := FldValues.IndexOfPiece(IntToStr(CtrlID));
          if(j < 0) or (Piece(FldValues[j],U,2) = '') then begin
            Result := TRUE;
          end;
        end;
      end;
    end;
  until((i = 0) or Result);
end;

function HasTemplateField(txt: string): boolean;
begin
  Result := (pos(TemplateFieldBeginSignature, txt) > 0);
end;

function GetTemplateField(ATemplateField: string; ByIEN: boolean): TTemplateField;
var
  i, idx: integer;
  AData: TStrings;

begin
  Result := nil;
  if(not assigned(uTmplFlds)) then
    uTmplFlds := TList.Create;
  idx := -1;
  for i := 0 to uTmplFlds.Count-1 do begin
    if(ByIEN) then begin
      if(TTemplateField(uTmplFlds[i]).FID = ATemplateField) then begin
        idx := i;
        break;
      end;
    end else begin
      if(TTemplateField(uTmplFlds[i]).FFldName = ATemplateField) then begin
        idx := i;
        break;
      end;
    end;
  end;
  if(idx < 0) then begin
    if(ByIEN) then
      AData := LoadTemplateFieldByIEN(ATemplateField)
    else
      AData := LoadTemplateField(ATemplateField);
    if(AData.Count > 1) then
      Result := TTemplateField.Create(AData);
  end else
    Result := TTemplateField(uTmplFlds[idx]);
end;

function TemplateFieldNameProblem(Fld: TTemplateField): boolean;
const
  DUPFLD = 'Field Name is not unique';

var
  i: integer;
  msg: string;

begin
  msg := '';
  if(Fld.FldName = NewTemplateField) then
    msg := 'Field Name can not be ' + NewTemplateField
  else
  if(length(Fld.FldName) < 3) then
    msg := 'Field Name must be at least three characters in length'
  else
  if(not (Fld.FldName[1] in ['A'..'Z','0'..'9'])) then
    msg := 'First Field Name character must be "A" - "Z", or "0" - "9"'
  else
  if(assigned(uTmplFlds)) then
  begin
    for i := 0 to uTmplFlds.Count-1 do
    begin
      if(Fld <> uTmplFlds[i]) and
        (CompareText(TTemplateField(uTmplFlds[i]).FFldName, Fld.FFldName) = 0) then
      begin
        msg := DUPFLD;
        break;
      end;
    end;
  end;
  if(msg = '') and (not IsTemplateFieldNameUnique(Fld.FFldName, Fld.ID)) then
    msg := DUPFLD;
  Result := (msg <> '');
  if(Result) then
    ShowMsg(msg);
end;

function SaveTemplateFieldErrors: string;
var
  i: integer;
  Errors: TStringList;
  Fld: TTemplateField;
  msg: string;

begin
  Result := '';
  if(assigned(uTmplFlds)) then
  begin
    Errors := nil;
    try
      for i := 0 to uTmplFlds.Count-1 do
      begin
        Fld := TTemplateField(uTmplFlds[i]);
        if(Fld.FModified) then
        begin
          msg := Fld.SaveError;
          if(msg <> '') then
          begin
            if(not assigned(Errors)) then
            begin
              Errors := TStringList.Create;
              Errors.Add('The following template field save errors have occurred:');
              Errors.Add('');
            end;
            Errors.Add('  ' + Fld.FldName + ': ' + msg);
          end;
        end;
      end;
    finally
      if(assigned(Errors)) then
      begin
        Result := Errors.Text;
        Errors.Free;
      end;
    end;
  end;
end;

procedure ClearModifiedTemplateFields;
var
  i: integer;
  Fld: TTemplateField;

begin
  if(assigned(uTmplFlds)) then
  begin
    for i := uTmplFlds.Count-1 downto 0 do
    begin
      Fld := TTemplateField(uTmplFlds[i]);
      if(assigned(Fld)) and (Fld.FModified) then
      begin
        if Fld.FLocked then
          UnlockTemplateField(Fld.FID);
        Fld.Free;
      end;
    end;
  end;
end;

function AnyTemplateFieldsModified: boolean;
var
  i: integer;

begin
  Result := FALSE;
  if(assigned(uTmplFlds)) then
  begin
    for i := 0 to uTmplFlds.Count-1 do
    begin
      if(TTemplateField(uTmplFlds[i]).FModified) then
      begin
        Result := TRUE;
        break;
      end;
    end;
  end;
end;

procedure ListTemplateFields(const AText: string; AList: TStrings; ListErrors: boolean = FALSE);
var
  i, j, k, flen, BadCount: integer;
  flddesc, tmp, fld: string;
  TmpList: TStringList;
  InactiveList: TStringList;
  FldObj: TTemplateField;

begin
  if(AText = '') then exit;
  BadCount := 0;
  InactiveList := TStringList.Create;
  try
    TmpList := TStringList.Create;
    try
      TmpList.Text := AText;
      for k := 0 to TmpList.Count-1 do
      begin
        tmp := TmpList[k];
        repeat
          i := pos(TemplateFieldBeginSignature, tmp);
          if(i > 0) then
          begin
            fld := '';
            j := pos(TemplateFieldEndSignature, copy(tmp, i + TemplateFieldSignatureLen, MaxInt));
            if(j > 0) then
            begin
              inc(j, i + TemplateFieldSignatureLen - 1);
              flen := j - i - TemplateFieldSignatureLen;
              fld := copy(tmp,i + TemplateFieldSignatureLen, flen);
              delete(tmp, i, flen + TemplateFieldSignatureLen + 1);
            end
            else
            begin
              delete(tmp,i,TemplateFieldSignatureLen);
              inc(BadCount);
            end;
            if(fld <> '') then
            begin
              if ListErrors then
              begin
                FldObj := GetTemplateField(fld, FALSE);
                if assigned(FldObj) then
                begin
                  if FldObj.Inactive then
                    InactiveList.Add('  "' + fld + '"');
                  flddesc := '';
                end
                else
                  flddesc := '  "' + fld + '"';
              end
              else
                flddesc := fld;
              if(flddesc <> '') and (AList.IndexOf(flddesc) < 0) then
                AList.Add(flddesc)
            end;
          end;
        until (i = 0);
      end;
    finally
      TmpList.Free;
    end;
    if ListErrors then
    begin
      if(AList.Count > 0) then
        AList.Insert(0, 'The following template fields were not found:');
      if (BadCount > 0) then
      begin
        if(BadCount = 1) then
          tmp := 'A template field marker "' + TemplateFieldBeginSignature +
                 '" was found without a'
        else
          tmp := IntToStr(BadCount) + ' template field markers "' + TemplateFieldBeginSignature +
                 '" were found without';
        if(AList.Count > 0) then
          AList.Add('');
        AList.Add(tmp + ' matching "' + TemplateFieldEndSignature + '"');
      end;
      if(InactiveList.Count > 0) then
      begin
        if(AList.Count > 0) then
          AList.Add('');
        AList.Add('The following inactive template fields were found:');
        FastAddStrings(InactiveList, AList);
      end;
      if(AList.Count > 0) then
      begin
        AList.Insert(0, 'Text contains template field errors:');
        AList.Insert(1, '');
      end;
    end;
  finally
    InactiveList.Free;
  end;
end;

function BoilerplateTemplateFieldsOK(const AText: string; Msg: string = ''): boolean;
var
  Errors: TStringList;
  btns: TMsgDlgButtons;

begin
  Result := TRUE;
  Errors := TStringList.Create;
  try
    ListTemplateFields(AText, Errors, TRUE);
    if(Errors.Count > 0) then
    begin
      if(Msg = 'OK') then
        btns := [mbOK]
      else
      begin
        btns := [mbAbort, mbIgnore];
        Errors.Add('');
        if(Msg = '') then
          Msg := 'text insertion';
        Errors.Add('Do you want to Abort ' + Msg + ', or Ignore the error and continue?');
      end;
      Result := (MessageDlg(Errors.Text, mtError, btns, 0) = mrIgnore);
    end;
  finally
    Errors.Free;
  end;
end;

procedure EnsureText(edt: TEdit; ud: TUpDown);
var
  v: integer;
  s: string;

begin
  if assigned(ud.Associate) then
  begin
    v := StrToIntDef(edt.Text, ud.Position);
    if (v < ud.Min) or (v > ud.Max) then
      v := ud.Position;
    s := IntToStr(v);
    if edt.Text <> s then
      edt.Text := s;
  end;
  edt.SelStart := edt.GetTextLen;    
end;

function TemplateFieldCode2Field(const Code: string): TTemplateFieldType;
var
  typ: TTemplateFieldType;

begin
  Result := dftUnknown;
  for typ := low(TTemplateFieldType) to high(TTemplateFieldType) do begin
    if Code = TemplateFieldTypeCodes[typ] then begin
      Result := typ;
      break;
    end;
  end;
end;

function TemplateDateCode2DateType(const Code: string): TTmplFldDateType;
var
  typ: TTmplFldDateType;

begin
  Result := dtUnknown;
  for typ := low(TTmplFldDateType) to high(TTmplFldDateType) do begin
    if Code = TemplateFieldDateCodes[typ] then begin
      Result := typ;
      break;
    end;
  end;
end;

procedure ConvertCodes2Text(sl: TStrings; Short: boolean);
var
  i: integer;
  tmp, output: string;
  ftype: TTemplateFieldType;
  dtype: TTmplFldDateType;

begin
  for i := 0 to sl.Count-1 do
  begin
    tmp := sl[i];
    if piece(tmp,U,4) = BOOLCHAR[TRUE] then
      output := '* '
    else
      output := '  ';
    ftype := TemplateFieldCode2Field(Piece(tmp, U, 3));
    if ftype = dftDate then
    begin
      dtype := TemplateDateCode2DateType(Piece(tmp, U, 5));
      output := output + TemplateDateTypeDesc[dtype, short];
    end
    else
      output := output + TemplateFieldTypeDesc[ftype, short];
    SetPiece(tmp, U, 3, output);
    sl[i] := tmp;
  end;
end;

{ TTemplateField }

constructor TTemplateField.Create(AData: TStrings);
var
  tmp, p1: string;
  AFID, i,idx,cnt: integer;

begin
  AFID := 0;
  if(assigned(AData)) then
  begin
    if AData.Count > 0 then
      AFID := StrToIntDef(AData[0],0);
    if(AFID > 0) and (AData.Count > 1) then
    begin
      FID := IntToStr(AFID);
      FFldName := Piece(AData[1],U,1);
      FFldType := TemplateFieldCode2Field(Piece(AData[1],U,2));
      FInactive := (Piece(AData[1],U,3) = '1');
      FMaxLen := StrToIntDef(Piece(AData[1],U,4),0);
      FEditDefault := Piece(AData[1],U,5);
      FLMText := Piece(AData[1],U,6);
      idx := StrToIntDef(Piece(AData[1],U,7),0);
      cnt := 0;
      for i := 2 to AData.Count-1 do begin
        tmp := AData[i];
        p1 := Piece(tmp,U,1);
        tmp := Piece(tmp,U,2);
        if(p1 = 'D') then begin
          FNotes := FNotes + tmp + CRLF
        end else if(p1 = 'U') then begin
          FURL := tmp
        end else if(p1 = 'I') then begin
          inc(cnt);
          FItems := FItems + tmp + CRLF;
          if(cnt=idx) then begin
            FItemDefault := tmp;
          end;
        end;
      end;
      FRequired  := (Piece(AData[1],U,8) = '1');
      FSepLines  := (Piece(AData[1],U,9) = '1');
      FTextLen   := StrToIntDef(Piece(AData[1],U,10),0);
      FIndent    := StrToIntDef(Piece(AData[1],U,11),0);
      FPad       := StrToIntDef(Piece(AData[1],U,12),0);
      FMinVal    := StrToIntDef(Piece(AData[1],U,13),0);
      FMaxVal    := StrToIntDef(Piece(AData[1],U,14),0);
      FIncrement := StrToIntDef(Piece(AData[1],U,15),0);
      FDateType  := TemplateDateCode2DateType(Piece(AData[1],U,16));
      FModified  := FALSE;
      FNameChanged := FALSE;
    end;
  end;
  if(AFID = 0) then begin
    inc(uNewTemplateFieldIDCnt);
    FID := IntToStr(-uNewTemplateFieldIDCnt);
    FFldName := NewTemplateField;
    FModified := TRUE;
  end;
  if(not assigned(uTmplFlds)) then
    uTmplFlds := TList.Create;
  uTmplFlds.Add(Self);
  FDTOfLastServerRead := 0;    //kt added 5/16
  FLastServerReadValue := '';  //kt added 5/16
end;

function TTemplateField.GetTemplateFieldDefault: string;
begin
  //NOTE //kt 5/16  Changed all instances of FEditDefault --> EditDefault.
  //     There were no pre-existing instances of EditDefault
  //     Same with FItemDefault -> ItemDefault
  case FFldType of
    dftEditBox, dftNumber:  Result := EditDefault;

    dftComboBox,
    dftButton,
    dftCheckBoxes,          {Clear out embedded fields}
    dftRadioButtons:        Result := StripEmbedded(ItemDefault);

    dftDate:                if EditDefault <> '' then Result := EditDefault;  //kt 5/16

    dftHyperlink, dftText:  if EditDefault <> '' then
                               Result := StripEmbedded(EditDefault)
                            else
                               Result := URL;

    dftWP:                  Result := Items;
  end;
end;

procedure TTemplateField.CreateDialogControls(Entry: TTemplateDialogEntry;
                                     var Index: Integer; CtrlID: integer);

var
  i, Aht, w, tmp, AWdth: integer;
  j : integer; //kt added 1/16
  InitDT : string; //kt 1/16
  HTMLCtrlID : string; //kt 1/16
  DefaultStr : string;  //kt 2/20/16
  STmp: string;
  TmpSL: TStringList;
  edt: TEdit;
  cbo: TORComboBox;
  cb: TORCheckBox;
  btn: TfraTemplateFieldButton;
  dbox: TORDateBox;
  dcbo: TORDateCombo;
  lbl: TCPRSTemplateFieldLabel;
  re: TRichEdit;
  pnl: TCPRSDialogNumber;
  DefDate: TFMDateTime;
  ctrl: TControl;

  function wdth: integer;
  begin
    if(Awdth < 0) then
      Awdth := FontWidthPixel(Entry.FFont.Handle);
    Result := Awdth;
  end;

  function ht: integer;
  begin
    if(Aht < 0) then
      Aht := FontHeightPixel(Entry.FFont.Handle);
    Result := Aht;
  end;

  procedure UpdateIndents(AControl: TControl);
  var
    idx: integer;

  begin
    if (FIndent > 0) or (FPad > 0) then begin
      idx := Entry.FIndents.IndexOfObject(AControl);
      if idx < 0 then
        Entry.FIndents.AddObject(IntToStr(FIndent * wdth) + U + IntToStr(FPad), AControl);
    end;
  end;

begin
  if(not FInactive) and (FFldType <> dftUnknown) then begin
    AWdth := -1;
    Aht := -1;
    ctrl := nil;
    HTMLCtrlID := 'ctrl' + IntToStr(CtrlID); //kt 1/16
    DefaultStr := StripEmbedded(ItemDefault); //kt 2/20/16 added

    case FFldType of
      dftEditBox:
        begin
          edt := TCPRSDialogFieldEdit.Create(nil);
          (edt as ICPRSDialogComponent).RequiredField := Required;
          edt.Parent := Entry.FPanel;
          edt.BorderStyle := bsNone;
          edt.Height := ht;
          edt.Width := (wdth * Width + 4);
          if FTextLen > 0 then
            edt.MaxLength := FTextLen
          else
            edt.MaxLength := FMaxLen;
          //kt 5/16 edt.Text := FEditDefault;
          edt.Text := EditDefault;  //kt
          edt.Tag := CtrlID;
          edt.OnChange := Entry.DoChange;
          UpdateColorsFor508Compliance(edt, TRUE);
          ctrl := edt;
          FPseudoHTML := '<EDITBOX id="'+HTMLCtrlID+'" size=' + IntToStr(edt.MaxLength) + '>' + edt.Text + '</EDITBOX>'; //kt 1/16
        end;

      dftComboBox:
        begin
          cbo := TCPRSDialogComboBox.Create(nil);
          (cbo as ICPRSDialogComponent).RequiredField := Required;
          cbo.Parent := Entry.FPanel;
          cbo.TemplateField := TRUE;
          w := Width;
          cbo.MaxLength := w;
          if FTextLen > 0 then
            cbo.MaxLength := FTextLen
          else
            cbo.ListItemsOnly := TRUE;
          {Clear out embedded fields}
          cbo.Items.Text := StripEmbedded(Items);
          //kt original --> cbo.SelectByID(StripEmbedded(FItemDefault));
          cbo.SelectByID(DefaultStr);  //kt mod
          cbo.Tag := CtrlID;
          cbo.OnChange := Entry.DoChange;

          if cbo.Items.Count > 12 then
          begin
            cbo.Width := (wdth * w) + ScrollBarWidth + 8;
            cbo.DropDownCount := 12;
          end
          else
          begin
            cbo.Width := (wdth * w) + 18;
            cbo.DropDownCount := cbo.Items.Count;
          end;
          UpdateColorsFor508Compliance(cbo, TRUE);
          ctrl := cbo;
          //kt begin mod ----  1/16
          TmpSL := TStringList.Create;
          TmpSL.Text := Items;
          FPseudoHTML := '<COMBO id="'+HTMLCtrlID+'" initial="' + DefaultStr + '">^';
          for j := 0 to TmpSL.Count - 1 do begin
            FPseudoHTML := FPseudoHTML + TmpSL.Strings[j];
            if j <> TmpSL.Count - 1 then FPseudoHTML := FPseudoHTML + '^';
          end;
          FPseudoHTML := FPseudoHTML + '</COMBO>';
          TmpSL.Free
          //kt end mod ----
        end;

      dftButton:
        begin
          btn := TfraTemplateFieldButton.Create(nil);
          (btn as ICPRSDialogComponent).RequiredField := Required;
          btn.Parent := Entry.FPanel;
          {Clear out embedded fields}
          btn.Items.Text := StripEmbedded(Items);
          //kt original --> btn.ButtonText := StripEmbedded(FItemDefault);
          btn.ButtonText := DefaultStr; //kt mod
          btn.Height := ht;
          btn.Width := (wdth * Width) + 6;
          btn.Tag := CtrlID;
          btn.OnChange := Entry.DoChange;
          UpdateColorsFor508Compliance(btn);
          ctrl := btn;
          //kt begin mod ----  1/16
          //e.g. <CYCBUTTON initial="opt2">opt1|Apples^opt2|Pears^opt3^opt4</CYCBUTTON>
          TmpSL := TStringList.Create;
          TmpSL.Text := Items;
          FPseudoHTML := '<CYCBUTTON id="'+HTMLCtrlID+'" initial="' + DefaultStr + '">';
          for j := 0 to TmpSL.Count - 1 do begin
            FPseudoHTML := FPseudoHTML + TmpSL.Strings[j];
            if j <> TmpSL.Count - 1 then FPseudoHTML := FPseudoHTML + '^';
          end;
          FPseudoHTML := FPseudoHTML + '</CYCBUTTON>';
          TmpSL.Free
          //kt end mod ----
        end;

      dftCheckBoxes, dftRadioButtons:
        begin
          if FFldType = dftRadioButtons then
            inc(uRadioGroupIndex);
          TmpSL := TStringList.Create;
          try
            {Clear out embedded fields}
            TmpSL.Text := StripEmbedded(Items);
            //kt mod 1/16 -------------------
            if FFldType = dftRadioButtons then begin
              //<RADIO inline=false initial="opt2">opt|Apples^opt2|Pears^opt3^opt4</RADIO>
              FPseudoHTML :=  '<RADIO id="'+HTMLCtrlID+'" ';
              if FSepLines then begin
                FPseudoHTML := FPseudoHTML + 'inline=false ';
              end else begin
                FPseudoHTML := FPseudoHTML + 'inline=true ';
              end;
              if ItemDefault <> '' then FPseudoHTML := FPseudoHTML + 'initial=' + DefaultStr;
              FPseudoHTML := FPseudoHTML + '>';
            end else begin  //dftCheckBoxes
              FPseudoHTML :=  '<CBGROUP id="'+HTMLCtrlID+'" count=' + IntToStr(TmpSL.Count) + '>';
            end;
            //kt end mod ---------------------
            for i := 0 to TmpSL.Count-1 do begin
              cb := TCPRSDialogCheckBox.Create(nil);
              if i = 0 then
                (cb as ICPRSDialogComponent).RequiredField := Required;
              cb.Parent := Entry.FPanel;
              cb.Caption := TmpSL[i];
              cb.AutoSize := TRUE;
              cb.AutoAdjustSize;
  //              cb.AutoSize := FALSE;
  //              cb.Height := ht;
              if FFldType = dftRadioButtons then
              begin
                cb.GroupIndex := uRadioGroupIndex;
                cb.RadioStyle := TRUE;
              end;
              //kt original --> if(TmpSL[i] = StripEmbedded(FItemDefault)) then
              if(TmpSL[i] = DefaultStr) then  //kt mod
                cb.Checked := TRUE;
              cb.Tag := CtrlID;
              if FSepLines and (FFldType in SepLinesTypes) then
                cb.StringData := NewLine;
              cb.OnClick := Entry.DoChange;
              UpdateColorsFor508Compliance(cb);
              inc(Index);
              Entry.FControls.InsertObject(Index, '', cb);
              //kt begin mod 1/16 ------------------------------
              if FFldType = dftRadioButtons then begin
                FPseudoHTML := FPseudoHTML + TmpSL.Strings[i];
                if i = TmpSL.Count - 1 then begin
                  FPseudoHTML := FPseudoHTML + '</RADIO>';
                  Entry.FHTMLControls.Insert(Index,FPseudoHTML);
                  FPseudoHTML := '';
                end else begin
                  FPseudoHTML := FPseudoHTML + '^';
                  Entry.FHTMLControls.Insert(Index,'');
                end;
              end else begin //dftCheckBoxes
                FPseudoHTML := FPseudoHTML + '<CHECKBOX id="'+HTMLCtrlID+'d'+IntToStr(i)+'" ';
                if TmpSL.Strings[i] = DefaultStr then FPseudoHTML := FPseudoHTML + 'checked ';
                FPseudoHTML := FPseudoHTML + '>' + TmpSL.Strings[i] + '</CHECKBOX>';
                if FSepLines then FPseudoHTML := FPseudoHTML + '<BR>';
                if i = TmpSL.Count - 1 then FPseudoHTML := FPseudoHTML +  '</CBGROUP>';
                Entry.FHTMLControls.Insert(Index,FPseudoHTML);
                FPseudoHTML := '';
              end;
              //kt end mod 1/16 -----------------------------
              if (i=0) or FSepLines then
                UpdateIndents(cb);
            end;
          finally
            TmpSL.Free;
          end;
        end;

      dftDate:
        begin
          if EditDefault <> '' then  //kt 5/16 changed FEditDefault -> EditDefault
            DefDate := StrToFMDateTime(EditDefault) //kt 5/16 changed FEditDefault -> EditDefault
          else
            DefDate := 0;
          if FDateType in DateComboTypes then begin
            dcbo := TCPRSDialogDateCombo.Create(nil);
            (dcbo as ICPRSDialogComponent).RequiredField := Required;
            dcbo.Parent := Entry.FPanel;
            dcbo.Tag := CtrlID;
            dcbo.IncludeBtn := (FDateType = dtCombo);
            dcbo.IncludeDay := (FDateType = dtCombo);
            dcbo.IncludeMonth := (FDateType <> dtYear);
            dcbo.FMDate := DefDate;
            dcbo.TemplateField := TRUE;
            dcbo.OnChange := Entry.DoChange;
            UpdateColorsFor508Compliance(dcbo, TRUE);
            ctrl := dcbo;
          end else begin
            dbox := TCPRSDialogDateBox.Create(nil);
            (dbox as ICPRSDialogComponent).RequiredField := Required;
            dbox.Parent := Entry.FPanel;
            dbox.Tag := CtrlID;
            dbox.DateOnly := (FDateType = dtDate);
            dbox.RequireTime := (FDateType = dtDateReqTime);
            dbox.TemplateField := TRUE;
            dbox.FMDateTime := DefDate;
            if (FDateType = dtDate) then
              tmp := 11
            else
              tmp := 17;
            dbox.Width := (wdth * tmp) + 18;
            dbox.OnChange := Entry.DoChange;
            UpdateColorsFor508Compliance(dbox, TRUE);
            ctrl := dbox;
          end;
          //kt start mod 1/16 ----
          FPseudoHTML := '<DATE id="'+HTMLCtrlID+'" ';
          FPseudoHTML := FPseudoHTML + 'DTMode=' + IntToStr(Ord(FDateType)-1) + ' ';
          if DefDate<> 0 then begin
            DateTimeToString(InitDT, 'mm/dd/yyyy', FMDateTimeToDateTime(DefDate));
            FPseudoHTML := FPseudoHTML + 'initial="' + InitDT + '"';
          end;
          FPseudoHTML := FPseudoHTML + '></DATE>';
          //e.g. '<DATE DTMode=0 initial="7/3/1967"></DATE>'
          //kt end mod
        end;

      dftNumber:
        begin
          pnl := TCPRSDialogNumber.CreatePanel(nil);
          (pnl as ICPRSDialogComponent).RequiredField := Required;
          pnl.Parent := Entry.FPanel;
          pnl.BevelOuter := bvNone;
          pnl.Tag := CtrlID;
          pnl.Edit.Height := ht;
          pnl.Edit.Width := (wdth * 5 + 4);
          pnl.UpDown.Min := MinVal;
          pnl.UpDown.Max := MaxVal;
          pnl.UpDown.Min := MinVal; // Both ud.Min settings are needeed!
          i := Increment;
          if i < 1 then i := 1;
          pnl.UpDown.Increment := i;
          pnl.UpDown.Position := StrToIntDef(EditDefault, 0);
          pnl.Edit.OnChange := Entry.UpDownChange;
          pnl.Height := pnl.Edit.Height;
          pnl.Width := pnl.Edit.Width + pnl.UpDown.Width;
          UpdateColorsFor508Compliance(pnl, TRUE);
          //CQ 17597 wat
          pnl.Edit.Align := alLeft;
          pnl.UpDown.Align := alLeft;
          //end 17597
          ctrl := pnl;
          FPseudoHTML := '<NUMBER id="'+HTMLCtrlID+'" ';  //kt
          FPseudoHTML := FPseudoHTML + 'min='+inttostr(MinVal)+' max='+inttostr(MaxVal)+' step='+inttostr(i)+'>'+EditDefault+'</NUMBER>';  //kt
        end;

      dftHyperlink, dftText:
        begin
          if (FFldType = dftHyperlink) and User.WebAccess then
            lbl := TCPRSDialogHyperlinkLabel.Create(nil)
          else
            lbl := TCPRSTemplateFieldLabel.Create(nil);
          lbl.Parent := Entry.FPanel;
          lbl.ShowAccelChar := FALSE;
          lbl.Exclude := FSepLines;
          if (FFldType = dftHyperlink) then
          begin
            if EditDefault <> '' then  //kt 5/16 changed FEditDefault -> EditDefault
              lbl.Caption := StripEmbedded(EditDefault)
            else
              lbl.Caption := URL;
            FPseudoHTML := '<a id="'+HTMLCtrlID+'" href="' + URL + '">' + lbl.Caption + '</a>';  //kt added 1/16
          end
          else
          begin
            STmp := StripEmbedded(Items);
            if copy(STmp,length(STmp)-1,2) = CRLF then
              delete(STmp,length(STmp)-1,2);
            lbl.Caption := STmp;
            FPseudoHTML := HTMLEscape(STmp);   //kt added 1/16
            FPseudoHTML := StringReplace(FPseudoHTML, CRLF, '<BR>', [rfReplaceAll]);   //kt added 1/16
          end;
          if lbl is TCPRSDialogHyperlinkLabel then
            TCPRSDialogHyperlinkLabel(lbl).Init(FURL);
          lbl.Tag := CtrlID;
          UpdateColorsFor508Compliance(lbl);
          ctrl := lbl;
        end;

      dftWP:
        begin
          re := TCPRSDialogRichEdit.Create(nil);
          (re as ICPRSDialogComponent).RequiredField := Required;
          re.Parent := Entry.FPanel;
          re.Tag := CtrlID;
          tmp := FMaxLen;
          if tmp < 5 then
            tmp := 5;
          re.Width := wdth * tmp;
          tmp := FTextLen;
          if tmp < 2 then
            tmp := 2
          else
          if tmp > MaxTFWPLines then
            tmp := MaxTFWPLines;
          re.Height := ht * tmp;
          re.BorderStyle := bsNone;
          re.ScrollBars := ssVertical;
          re.Lines.Text := Items;
          re.OnChange := Entry.DoChange;
          UpdateColorsFor508Compliance(re, TRUE);
          ctrl := re;
          //kt begin mod 1/16
          STmp := StripEmbedded(Items);
          if copy(STmp,length(STmp)-1,2) = CRLF then delete(STmp,length(STmp)-1,2);
          STmp := StringReplace(HTMLEscape(STmp), CRLF, '<BR>', [rfReplaceAll]);  
          FPseudoHTML := '<WPBOX id="'+HTMLCtrlID+'">' + sTmp + '</WPBOX>';
          //kt end mode 1/16
        end;
    end;
    if assigned(ctrl) then begin
      inc(Index);
      Entry.FControls.InsertObject(Index, '', ctrl);
      Entry.FHTMLControls.Insert(Index, FPseudoHTML);  //kt added 1/16
      UpdateIndents(ctrl);
    end;
  end;
end;

function TTemplateField.CanModify: boolean;
begin
  if((not FModified) and (not FLocked) and (StrToIntDef(FID,0) > 0)) then
  begin
    FLocked := LockTemplateField(FID);
    Result := FLocked;
    if(not FLocked) then
      ShowMsg('Template Field ' + FFldName + ' is currently being edited by another user.');
  end
  else
    Result := TRUE;
  if(Result) then FModified := TRUE;
end;

procedure TTemplateField.SetEditDefault(const Value: string);
begin
  if(FEditDefault <> Value) and CanModify then begin
    //kt FEditDefault := Value;
    case GetDataBinding of  //kt added block 7/16
      dbcbNone :      FEditDefault := Value;
      dbcbReadWrite:  FEditDefault := DATABASE_CONTROL_RW_TAG+Value;
      dbcbWriteOnly:  FEditDefault := DATABASE_CONTROL_W_TAG+Value;
    end; {case}
  end;
end;

function TTemplateField.GetEditDefault: string;
//kt added funtion 5/16
begin
  case DataBinding of
    dbcbReadWrite:  Result := GetInnerEditDefaultValue;  //kt GetItemDefault;
    dbcbWriteOnly:  Result := GetInnerEditDefaultValue;  //kt GetItemDefault;
    dbcbNone:       Result := FEditDefault;
  end;
end;

procedure TTemplateField.CacheDBValue(DFN, Value : string);
//kt added funtion 5/16
//This function allows a batch reading of many DB field values to be done elsewhere
//  and then stored here.  These values will expire after ALLOWED_LOCAL_DECAY_SECONDS
begin
  FDFNOfLastServerRead := DFN;
  LastServerReadValue := Value;
  FDTOfLastServerRead := NOW;
end;

procedure TTemplateField.SetFldName(const Value: string);
begin
  if(FFldName <> Value) and CanModify then
  begin
    FFldName := Value;
    FNameChanged := TRUE;
  end;
end;

procedure TTemplateField.SetFldType(const Value: TTemplateFieldType);
begin
  if(FFldType <> Value) and CanModify then
  begin
    FFldType := Value;
    if(Value = dftEditBox) then
    begin
      if (FMaxLen < 1) then
        FMaxLen := 1;
      if FTextLen < FMaxLen then
        FTextLen := FMaxLen;
    end
    else
    if(Value = dftHyperlink) and (FURL = '') then
      FURL := 'http://'
    else
    if(Value = dftComboBox) and (FMaxLen < 1) then
    begin
      FMaxLen := Width;
      if FMaxLen < 1 then
        FMaxLen := 1;
    end
    else
    if(Value = dftWP) then
    begin
      if (FMaxLen = 0) then
        FMaxLen := MAX_ENTRY_WIDTH
      else
      if (FMaxLen < 5) then
          FMaxLen := 5;
      if FTextLen < 2 then
        FTextLen := 2;
    end
    else
    if(Value = dftDate) and (FDateType = dtUnknown) then
      FDateType := dtDate;
  end;
end;

procedure TTemplateField.SetID(const Value: string);
begin
//  if(FID <> Value) and CanModify then
    FID := Value;
end;

procedure TTemplateField.SetInactive(const Value: boolean);
begin
  if(FInactive <> Value) and CanModify then
    FInactive := Value;
end;

procedure TTemplateField.SetItemDefault(const Value: string);
var temp : string;
begin
  if(FItemDefault <> Value) and CanModify then begin
    //kt NOTE: Remember, FItemDefault doesn't store TAG, it is FEditDefault that does that.
    FItemDefault := Value;
  end;
end;

function TTemplateField.GetItemDefault: string;
//kt added 5/16
var UseLocalValue : boolean;
    DFN : string;
    ErrStr : string;
const
  //Read from server unless already read in past X seconds
  ALLOWED_LOCAL_DECAY_SECONDS = 10;
begin
  if (DataBinding = dbcbReadWrite) then begin
    DFN := Patient.DFN;
    if (SecondsBetween(Now, FDTOfLastServerRead) < ALLOWED_LOCAL_DECAY_SECONDS)
    and (DFN = FDFNOfLastServerRead) then begin
      Result := LastServerReadValue;
    end else begin
      LastServerReadValue := Get1DBFldValue(DFN, FID, ErrStr);  //call RPC for value...
      if ErrStr = '' then begin
        FDFNOfLastServerRead := DFN;
        FDTOfLastServerRead := NOW;
        Result := LastServerReadValue;
      end else begin
        MessageDlg(ErrStr, mtError, [mbOK], 0);
        Result := '';
      end;
    end;
  end else if DataBinding = dbcbWriteOnly then begin
    Result := '';
  end else begin
    Result := FItemDefault;
  end;
end;

procedure TTemplateField.SetItems(const Value: string);
begin
  if(FItems <> Value) and CanModify then
    FItems := Value;
end;

function TTemplateField.GetItems: string;
//kt added 5/16
begin
  if IsDBControl_Reader and (FFldType in EditTextTypes) then begin
    Result := GetItemDefault
  end else begin
    Result := FItems;
  end;
end;


procedure TTemplateField.SetLMText(const Value: string);
begin
  if(FLMText <> Value) and CanModify then
    FLMText := Value;
end;

procedure TTemplateField.SetMaxLen(const Value: integer);
begin
  if(FMaxLen <> Value) and CanModify then
    FMaxLen := Value;
end;

procedure TTemplateField.SetNotes(const Value: string);
begin
  if(FNotes <> Value) and CanModify then
    FNotes := Value;
end;

function TTemplateField.SaveError: string;
var
  TmpSL, FldSL: TStringList;
  AID,Res: string;
  idx, i: integer;
  IEN64: Int64;
  NewRec: boolean;

begin
  if(FFldName = NewTemplateField) then
  begin
    Result := 'Template Field can not be named "' + NewTemplateField + '"';
    exit;
  end;
  Result := '';
  NewRec := (StrToIntDef(FID,0) < 0);
  if(FModified or NewRec) then
  begin
    TmpSL := TStringList.Create;
    try
      FldSL := TStringList.Create;
      try
        if(StrToIntDef(FID,0) > 0) then
          AID := FID
        else
          AID := '0';
        FldSL.Add('.01='+FFldName);
        FldSL.Add('.02='+TemplateFieldTypeCodes[FFldType]);
        FldSL.Add('.03='+BOOLCHAR[FInactive]);
        FldSL.Add('.04='+IntToStr(FMaxLen));
        FldSL.Add('.05='+FEditDefault);
        FldSL.Add('.06='+FLMText);
        idx := -1;
        //kt if(FItems <> '') and (FItemDefault <> '') then begin
        if(FItems <> '') and (ItemDefault <> '') then begin  //kt 7/16
          TmpSL.Text := FItems;
          for i := 0 to TmpSL.Count-1 do begin
            //kt if (FItemDefault = TmpSL[i]) then begin
            if (ItemDefault = TmpSL[i]) then begin  //kt
              idx := i;
              break;
            end;
          end;
        end;
        FldSL.Add('.07='+IntToStr(Idx+1));
        FldSL.Add('.08='+BOOLCHAR[fRequired]);
        FldSL.Add('.09='+BOOLCHAR[fSepLines]);
        FldSL.Add('.1=' +IntToStr(FTextLen));
        FldSL.Add('.11='+IntToStr(FIndent));
        FldSL.Add('.12='+IntToStr(FPad));
        FldSL.Add('.13='+IntToStr(FMinVal));
        FldSL.Add('.14='+IntToStr(FMaxVal));
        FldSL.Add('.15='+IntToStr(FIncrement));
        if FDateType = dtUnknown then
          FldSL.Add('.16=@')
        else
          FldSL.Add('.16='+TemplateFieldDateCodes[FDateType]);

        if FURL='' then
          FldSL.Add('3=@')
        else
          FldSL.Add('3='+FURL);

        if(FNotes <> '') or (not NewRec) then
        begin
          if(FNotes = '') then
            FldSL.Add('2,1=@')
          else
          begin
            TmpSL.Text := FNotes;
            for i := 0 to TmpSL.Count-1 do
              FldSL.Add('2,'+IntToStr(i+1)+',0='+TmpSL[i]);
          end;
        end;
        if((FItems <> '') or (not NewRec)) then
        begin
          if(FItems = '') then
            FldSL.Add('10,1=@')
          else
          begin
            TmpSL.Text := FItems;
            for i := 0 to TmpSL.Count-1 do
              FldSL.Add('10,'+IntToStr(i+1)+',0='+TmpSL[i]);
          end;
        end;

        Res := UpdateTemplateField(AID, FldSL);
        IEN64 := StrToInt64Def(Piece(Res,U,1),0);
        if(IEN64 > 0) then
        begin
          if(NewRec) then
            FID := IntToStr(IEN64)
          else
            UnlockTemplateField(FID);
          FModified := FALSE;
          FNameChanged := FALSE;
          FLocked := FALSE;
        end
        else
          Result := Piece(Res, U, 2);
      finally
        FldSL.Free;
      end;
    finally
      TmpSL.Free;
    end;
  end;
end;

procedure TTemplateField.Assign(AFld: TTemplateField);
begin
  FMaxLen        := AFld.FMaxLen;
  FFldName       := AFld.FFldName;
  FLMText        := AFld.FLMText;
  FEditDefault   := AFld.FEditDefault;
  FNotes         := AFld.FNotes;
  FItems         := AFld.FItems;
  FInactive      := AFld.FInactive;
  FItemDefault   := AFld.FItemDefault;
  FFldType       := AFld.FFldType;
  FRequired      := AFld.FRequired;
  FSepLines      := AFld.FSepLines;
  FTextLen       := AFld.FTextLen;
  FIndent        := AFld.FIndent;
  FPad           := AFld.FPad;
  FMinVal        := AFld.FMinVal;
  FMaxVal        := AFld.FMaxVal;
  FIncrement     := AFld.FIncrement;
  FDateType      := AFld.FDateType;
  FURL           := AFld.FURL;
end;

function TTemplateField.Width: integer;
var
  i, ilen: integer;
  TmpSL: TStringList;

begin
  if(FFldType = dftEditBox) then
    Result := FMaxLen
  else
  begin
    if FMaxLen > 0 then
      Result := FMaxLen
    else
    begin
      Result := -1;
      TmpSL := TStringList.Create;
      try
        TmpSL.Text := StripEmbedded(FItems);
        for i := 0 to TmpSL.Count-1 do
        begin
          ilen := length(TmpSL[i]);
          if(Result < ilen) then
            Result := ilen;
        end;
      finally
        TmpSL.Free;
      end;
    end;
  end;
  if Result > MaxTFEdtLen then
    Result := MaxTFEdtLen;
end;

destructor TTemplateField.Destroy;
begin
  uTmplFlds.Remove(Self);
  inherited;
end;

procedure TTemplateField.SetRequired(const Value: boolean);
begin
  if(FRequired <> Value) and CanModify then
    FRequired := Value;
end;

function TTemplateField.NewField: boolean;
begin
  Result := (StrToIntDef(FID,0) <= 0);
end;

procedure TTemplateField.SetSepLines(const Value: boolean);
begin
  if(FSepLines <> Value) and CanModify then
    FSepLines := Value
end;

procedure TTemplateField.SetIncrement(const Value: integer);
begin
  if(FIncrement <> Value) and CanModify then
    FIncrement := Value;
end;

procedure TTemplateField.SetIndent(const Value: integer);
begin
  if(FIndent <> Value) and CanModify then
    FIndent := Value;
end;

procedure TTemplateField.SetMaxVal(const Value: integer);
begin
  if(FMaxVal <> Value) and CanModify then
    FMaxVal := Value;
end;

procedure TTemplateField.SetMinVal(const Value: integer);
begin
  if(FMinVal <> Value) and CanModify then
    FMinVal := Value;
end;

procedure TTemplateField.SetPad(const Value: integer);
begin
  if(FPad <> Value) and CanModify then
    FPad := Value;
end;

procedure TTemplateField.SetTextLen(const Value: integer);
begin
  if(FTextLen <> Value) and CanModify then
    FTextLen := Value;
end;

procedure TTemplateField.SetURL(const Value: string);
begin
  if(FURL <> Value) and CanModify then
    FURL := Value;
end;

function TTemplateField.GetRequired: boolean;
begin
  if FFldType in NoRequired then
    Result := FALSE
  else
    Result := FRequired;
end;

procedure TTemplateField.SetDateType(const Value: TTmplFldDateType);
begin
  if(FDateType <> Value) and CanModify then
    FDateType := Value;
end;


//kt mod 5/16 -------------------------------------------------
//NOTE: In order to avoid changing the server, I will overload the EditDefault field
//     such that if EditDefault contains '$DB$_**$', then the control has database binding:
//       '$DB$_RW$'  <-- read and write control value to database
//       '$DB$_W$xxxxxxx'  <-- write only control value to database
//     If there is data binding, then the control will get values from the database
//     via separate RPC call, rather than taking the given value for the field.
//     This will be true regardless of the control type.

function TTemplateField.GetInnerEditDefaultValue : string;
//kt added 7/16
//Strip off tag and return just default value
begin
  Case(GetDataBinding) of
    dbcbReadWrite  : Result := MidStr(FEditDefault, length(DATABASE_CONTROL_RW_TAG)+1, MaxInt);
    dbcbWriteOnly  : Result := MidStr(FEditDefault, length(DATABASE_CONTROL_W_TAG)+1, MaxInt);
    dbcbNone       : Result := FEditDefault;
  end;
end;

function TTemplateField.GetDataBinding : TDBControlBinding;
//kt added 6/16
begin
  if LeftMatches(FEditDefault, DATABASE_CONTROL_RW_TAG) then begin
    Result := dbcbReadWrite;
  end else if LeftMatches(FEditDefault, DATABASE_CONTROL_W_TAG) then begin
    Result := dbcbWriteOnly;
  end else begin
    Result := dbcbNone;
  end;
end;

procedure TTemplateField.SetDataBinding(Value : TDBControlBinding);
//kt added 6/16
var InnerDefault : string;
begin
  if not CanModify then exit;
  InnerDefault := GetInnerEditDefaultValue;
  case Value of
    //NOTE: Don't use call to SedEditDefault because that will protect the current databinding value.
    dbcbNone :      FEditDefault := InnerDefault;
    dbcbReadWrite:  FEditDefault := DATABASE_CONTROL_RW_TAG+InnerDefault;
    dbcbWriteOnly:  FEditDefault := DATABASE_CONTROL_W_TAG+InnerDefault;
  end; {case}
end;

function TTemplateField.IsDBControl_Reader : boolean;
//kt added 6/16
begin
  Result := (DataBinding = dbcbReadWrite);
end;

function TTemplateField.IsDBControl_Writer : boolean;
//kt added 6/16
begin
  Result := (DataBinding in [dbcbReadWrite, dbcbWriteOnly]);
end;

function TTemplateField.IsDBControl : boolean;
//kt added 6/16
begin
  Result := (DataBinding <> dbcbNone);
end;

//
procedure TTemplateField.SetLastServerReadValue(Value : string);
//kt added entire function
begin
  FLastServerReadValue := StringReplace(Value, '{{LF}}', #13#10, [rfReplaceAll, rfIgnoreCase]);
end;
//kt end mod -------------------------------------------------

{ TTemplateDialogEntry }
const
  EOL_MARKER = #182;
  SR_BREAK   = #186;

procedure PanelDestroy(AData: Pointer; Sender: TObject);
var idx: integer;
    dlg: TTemplateDialogEntry;

begin
  dlg := TTemplateDialogEntry(AData);
  idx := uEntries.IndexOf(dlg.FID);
  if(idx >= 0) then begin
    //kt Delete1Entry(idx); <-- attempted improvement for line below, caused bugs //kt added 5/16
    uEntries.Delete(idx);
  end;
  dlg.FPanelDying := TRUE;
  dlg.Free;
end;

constructor TTemplateDialogEntry.Create(AParent: TWinControl; AID, Text: string);
var
  CtrlID, idx, i, j, flen: integer;
  txt, FldName: string;
  txtHTML : string; //kt added 1/16
  i2 : integer; //kt added 1/16
  Fld: TTemplateField;

begin
  FID := AID;
  FHTMLText := FormatHTMLTags(Text);  //kt added 1/16
  Text := RemoveHTMLTags(Text);       //kt added 1/16
  FHTMLDlg := nil;                    //kt added 1/16
  FText := Text;
  FControls := TStringList.Create;
  FIndents := TStringList.Create;
  FFont := TFont.Create;
  FFont.Assign(TORExposedControl(AParent).Font);
  FHTMLControls := TStringList.Create;     //kt added 1/16
  FPseudoHTMLSource := TStringList.Create; //kt added 1/16
  FHTMLControls.Text := FHTMLText;         //kt added 1/16
  for i := 1 to FHTMLControls.Count-1 do FHTMLControls[i] := EOL_MARKER + FHTMLControls[i];  //kt added 1/16
  FControls.Text := Text;
  if(FControls.Count > 1) then begin
    for i := 1 to FControls.Count-1 do begin
      FControls[i] := EOL_MARKER + FControls[i];
    end;
    if not ScreenReaderSystemActive then
      StripScreenReaderCodes(FControls);
  end;
  FFirstBuild := TRUE;
  FPanel := TDlgFieldPanel.Create(AParent.Owner);
  FPanel.Parent := AParent;
  FPanel.BevelOuter := bvNone;
  FPanel.Caption := '';
  FPanel.Font.Assign(FFont);
  //kt NOTE: Here I could set background color of FPanel.  Must also change color of parent panel
  UpdateColorsFor508Compliance(FPanel, TRUE);
  idx := 0;
  while (idx < FControls.Count) do begin
    txt := FControls[idx];
    txtHTML := FHTMLControls[idx];  //kt added 1/16 NOTE: FControls and FHTMLControls should correspond 1:1
    i := pos(TemplateFieldBeginSignature, txt);
    i2 := pos(TemplateFieldBeginSignature, txtHTML);  //kt added 1/16
    if(i > 0) then begin
      if(copy(txt, i + TemplateFieldSignatureLen, 1) = FieldIDDelim) then begin
        CtrlID := StrToIntDef(copy(txt, i + TemplateFieldSignatureLen + 1, FieldIDLen-1), 0);
        delete(txt,i + TemplateFieldSignatureLen, FieldIDLen);
        delete(txtHTML,i2 + TemplateFieldSignatureLen, FieldIDLen);  //kt added 1/16
      end else
        CtrlID := 0;
      j := pos(TemplateFieldEndSignature, copy(txt, i + TemplateFieldSignatureLen, MaxInt));
      if(j > 0) then begin
        inc(j, i + TemplateFieldSignatureLen - 1);
        flen := j - i - TemplateFieldSignatureLen;
        FldName := copy(txt, i + TemplateFieldSignatureLen, flen);
        Fld := GetTemplateField(FldName, FALSE); //kt doc.  1 Fld represents 1 type (e.g. edit box)  Add edit boxes use same Fld to generate actual control instance
        delete(txt,i,flen + TemplateFieldSignatureLen + 1);
        delete(txtHTML,i2, flen + TemplateFieldSignatureLen + 1);  //kt added 1/16
        if(assigned(Fld)) then begin
          FControls[idx] := copy(txt,1,i-1);
          FHTMLControls[idx] := copy(txtHTML, 1, i2-1);  //kt added 1/16
          if(Fld.Required) then begin
            if ScreenReaderSystemActive then begin
              if Fld.FFldType in [dftCheckBoxes, dftRadioButtons] then
                FControls[idx] := FControls[idx] + ScreenReaderStopCode;
            end;
            FControls[idx] := FControls[idx] + '*';
            FHTMLControls[idx] := FHTMLControls[idx] + '*';  //kt added 1/16
          end;
          Fld.CreateDialogControls(Self, idx, CtrlID);  //kt doc -- procedure inserts into Self.FControls at idx+1  (also into Self.FHTMLControls);
          FControls.Insert(idx+1,copy(txt,i,MaxInt));
          FHTMLControls.Insert(idx+1, copy(txtHTML, i2, MaxInt));  //kt added 1/16
        end else begin
          FControls[idx] := txt;
          FHTMLControls[idx] := txtHTML;  //kt added 1/16
          dec(idx);
        end;
      end else begin
        delete(txt,i,TemplateFieldSignatureLen);
        FControls[idx] := txt;
        delete(txtHTML, i2, TemplateFieldSignatureLen);  //kt added 1/16
        FHTMLControls[idx] := txtHTML;  //kt added 1/16
        dec(idx);
      end;
    end;
    inc(idx);
  end;
  if ScreenReaderSystemActive then begin
    idx := 0;
    while (idx < FControls.Count) do begin
      txt := FControls[idx];
      i := pos(ScreenReaderStopCode, txt);
      if i > 0 then begin
        FControls[idx] := copy(txt, 1, i-1);
        txt := copy(txt, i + ScreenReaderStopCodeLen, MaxInt);
        FControls.Insert(idx+1, SR_BREAK + txt);
      end;
      inc(idx);
    end;
  end;
end;

destructor TTemplateDialogEntry.Destroy;
begin
  if assigned(FOnDestroy) then begin
    FOnDestroy(Self);
  end;
  KillLabels;
  KillObj(@FControls, TRUE);
  if FPanelDying then begin
    FPanel := nil
  end else begin
    FreeAndNil(FPanel);
  end;
  FreeAndNil(FFont);
  FreeAndNil(FIndents);
  FreeAndNil(FHTMLControls);  //kt 7/16
  FreeandNil(FPseudoHTMLSource); //kt added 1/16
  //FHTMLControls.Free;  //kt added 1/16
  //FPseudoHTMLSource.Free; //kt added 1/16
  inherited;
end;

procedure TTemplateDialogEntry.DoChange(Sender: TObject);
begin
  if (not FUpdating) and assigned(FOnChange) then
    FOnChange(Self);
end;

function TTemplateDialogEntry.GetHTMLControlText(CtrlID: integer; NoCommas: boolean;
                            var FoundEntry: boolean; var ControlDisabled: boolean;
                            emField: string = ''): string;
//kt added function 1/16
var id : string;
begin
  result := '';
  id := 'ctrl' + IntToStr(CtrlID);
  FoundEntry :=FHTMLDlg.HasID(id);
  result := FHTMLDlg.GetValueByID(id, ControlDisabled, NoCommas);
end;

function TTemplateDialogEntry.GetControlText(CtrlID: integer; NoCommas: boolean;
                            var FoundEntry: boolean; AutoWrap: boolean;
                            emField: string = ''): string;
var
  x, i, j, ind, idx: integer;
  Ctrl: TControl;
  Done: boolean;
  iString: string;
  iField: TTemplateField;
  iTemp: TStringList;

  function GetOriginalItem(istr: string): string;
  begin
    Result := '';
    if emField <> '' then begin
      iField := GetTemplateField(emField,FALSE);
      iTemp := nil;
      if ifield <> nil then
      try
        iTemp := TStringList.Create;
        iTemp.Text := StripEmbedded(iField.Items);
        x := iTemp.IndexOf(istr);
        if x >= 0 then begin
          iTemp.Text := iField.Items;
          Result := iTemp.Strings[x];
        end;
      finally
        iTemp.Free;
      end;
    end;
  end;


begin
  Result := '';
  Done := FALSE;
  ind := -1;
  for i := 0 to FControls.Count-1 do begin
    Ctrl := TControl(FControls.Objects[i]);
    if(assigned(Ctrl)) and (Ctrl.Tag = CtrlID) then begin
      FoundEntry := TRUE;
      Done := TRUE;
      if ind < 0 then begin
        idx := FIndents.IndexOfObject(Ctrl);
        if idx >= 0 then
          ind := StrToIntDef(Piece(FIndents[idx], U, 2), 0)
        else
          ind := 0;
      end;
      if(Ctrl is TCPRSTemplateFieldLabel) then begin
        if not TCPRSTemplateFieldLabel(Ctrl).Exclude then begin
          if emField <> '' then begin
            iField := GetTemplateField(emField,FALSE);
            case iField.FldType of
              dftHyperlink: if iField.EditDefault <> '' then
                              Result := iField.EditDefault
                            else
                              Result := iField.URL;
              dftText:      begin
                              iString := iField.Items;
                              if copy(iString,length(iString)-1,2) = CRLF then
                                delete(iString,length(iString)-1,2);
                              Result := iString;
                            end;
            else {case}
              Result := TCPRSTemplateFieldLabel(Ctrl).Caption
            end; {case iField.FldType}
          end {if emField}
          else
            Result := TCPRSTemplateFieldLabel(Ctrl).Caption;
        end;
      end
      else
      //!!!!!! CODE ADDED BACK IN - ZZZZZZBELLC !!!!!!
      if(Ctrl is TEdit) then begin
        Result := TEdit(Ctrl).Text
      end else if(Ctrl is TORComboBox) then begin
        Result := TORComboBox(Ctrl).Text;
        iString := GetOriginalItem(Result);
        if iString <> '' then
          Result := iString;
      end else if(Ctrl is TORDateCombo) then begin
        Result := TORDateCombo(Ctrl).Text + ':' + FloatToStr(TORDateCombo(Ctrl).FMDate)
      end else
     {!!!!!! THIS HAS BEEN REMOVED AS IT CAUSED PROBLEMS WITH REMINDER DIALOGS - ZZZZZZBELLC !!!!!!
      if(Ctrl is TORDateBox) then begin
        if TORDateBox(Ctrl).IsValid then
         Result := TORDateBox(Ctrl).Text
        else
         Result := '';
      end else
      }
      //!!!!!! CODE ADDED BACK IN - ZZZZZZBELLC !!!!!!
      if(Ctrl is TORDateBox) then begin
        Result := TORDateBox(Ctrl).Text
      end else if(Ctrl is TRichEdit) then begin
        if((ind = 0) and (not AutoWrap)) then begin
          Result := TRichEdit(Ctrl).Lines.Text;
          if RightMatches(Result, CRLF) then begin  //kt added block 7/16
            //Note: this is done to remove an annoying extra line
            //      at the end of a block.  But if it causes other problems,
            //      then can remove this mod.
            Result := LeftStr(Result, Length(Result)-2);  //trim off trailing CRLF      
          end;
        end else begin
          for j := 0 to TRichEdit(Ctrl).Lines.Count-1 do begin
            if AutoWrap then begin
              if(Result <> '') then
                Result := Result + ' ';
              Result := Result + TRichEdit(Ctrl).Lines[j];
            end else begin
              if(Result <> '') then
                Result := Result + CRLF;
              Result := Result + StringOfChar(' ', ind) + TRichEdit(Ctrl).Lines[j];
            end;
          end;
          ind := 0;
        end;
      end else
     {!!!!!! THIS HAS BEEN REMOVED AS IT CAUSED PROBLEMS WITH REMINDER DIALOGS - ZZZZZZBELLC !!!!!!
      if(Ctrl is TEdit) then
        Result := TEdit(Ctrl).Text
      else }
      if(Ctrl is TORCheckBox) then begin
        Done := FALSE;
        if(TORCheckBox(Ctrl).Checked) then begin
          if(Result <> '') then begin
            if NoCommas then
              Result := Result + '|'
            else
              Result := Result + ', ';
          end;
          iString := GetOriginalItem(TORCheckBox(Ctrl).Caption);
          if iString <> '' then
            Result := Result + iString
          else
            Result := Result + TORCheckBox(Ctrl).Caption;
        end;
      end else if(Ctrl is TfraTemplateFieldButton) then begin
        Result := TfraTemplateFieldButton(Ctrl).ButtonText;
        iString := GetOriginalItem(Result);
        if iString <> '' then
          Result := iString;
      end else if(Ctrl is TPanel) then begin
        for j := 0 to Ctrl.ComponentCount-1 do begin
          if Ctrl.Components[j] is TUpDown then begin
            Result := IntToStr(TUpDown(Ctrl.Components[j]).Position);
            break;
          end;
        end;
      end;
    end;
    if Done then break;
  end;
  if (ind > 0) and (not NoCommas) then
    Result := StringOfChar(' ', ind) + Result;
end;

function TTemplateDialogEntry.GetFieldValues: string;
var
  i: integer;
  Ctrl: TControl;
  CtrlID: integer;
  TmpIDs: TList;
  TmpSL: TStringList;
  Dummy: boolean;

begin
  Result := '';
  TmpIDs := TList.Create;
  try
    TmpSL := TStringList.Create;
    try
      for i := 0 to FControls.Count-1 do
      begin
        Ctrl := TControl(FControls.Objects[i]);
        if(assigned(Ctrl)) then
        begin
          CtrlID := Ctrl.Tag;
          if(TmpIDs.IndexOf(Pointer(CtrlID)) < 0) then
          begin
            TmpSL.Add(IntToStr(CtrlID) + U + GetControlText(CtrlID, TRUE, Dummy, FALSE));
            TmpIDs.Add(Pointer(CtrlID));
          end;
        end;
      end;
      Result := TmpSL.CommaText;
    finally
      TmpSL.Free;
    end;
  finally
    TmpIDs.Free;
  end;
end;

function TTemplateDialogEntry.GetPanel(MaxLen: integer; AParent: TWinControl;
                                       OwningCheckBox: TCPRSDialogParentCheckBox): TDlgFieldPanel;
var
  i, x, y, cnt, idx, ind, yinc, ybase, MaxX: integer;
  MaxTextLen: integer;  {Max num of chars per line in pixels}
  MaxChars: integer;    {Max num of chars per line}
  txt: string;
  ctrl: TControl;
  LastLineBlank: boolean;
  sLbl: TCPRSDialogStaticLabel;
  nLbl: TVA508ChainedLabel;
  sLblHeight: integer;
  TabOrdr: integer;

const
  FOCUS_RECT_MARGIN = 2; {The margin around the panel so the label won't
                        overlay the focus rect on its parent panel.}

  procedure Add2TabOrder(ctrl: TWinControl);
  begin
    ctrl.TabOrder := TabOrdr;
    inc(TabOrdr);
  end;

  function StripSRCode(var txt: string; code: string; len: integer): integer;
  begin
    Result := pos(code, txt);
    if Result > 0 then
    begin
      delete(txt,Result,len);
      dec(Result);
    end
    else
      Result := -1;
  end;

  procedure DoLabel(Atxt: string);
  var
    ctrl: TControl;
    tempLbl: TVA508ChainedLabel;

  begin
    if ScreenReaderSystemActive then
    begin
      if assigned(sLbl) then
      begin
        tempLbl := TVA508ChainedLabel.Create(nil);
        if assigned(nLbl) then
          nLbl.NextLabel := tempLbl
        else
          sLbl.NextLabel := tempLbl;
        nLbl := tempLbl;
        ctrl := nLbl;
      end
      else
      begin
        sLbl := TCPRSDialogStaticLabel.Create(nil);
        ctrl := sLbl;
      end;
    end
    else
      ctrl := TLabel.Create(nil);
    SetOrdProp(ctrl, ShowAccelCharProperty, ord(FALSE));
    SetStrProp(ctrl, CaptionProperty, Atxt);
    ctrl.Parent := FPanel;
    ctrl.Left := x;
    ctrl.Top := y;
    if ctrl = sLbl then
    begin
      Add2TabOrder(sLbl);
      sLbl.Height := sLblHeight;
      ScreenReaderSystem_CurrentLabel(sLbl);
    end;
    if ScreenReaderSystemActive then
      ScreenReaderSystem_AddText(Atxt);
    UpdateColorsFor508Compliance(ctrl);
    inc(x, ctrl.Width);
  end;

  procedure Init;
  var
    lbl : TLabel;
  begin
    if(FFirstBuild) then
      FFirstBuild := FALSE
    else
      KillLabels;
    y := FOCUS_RECT_MARGIN; {placement of labels on panel so they don't cover the}
    x := FOCUS_RECT_MARGIN; {focus rectangle}
    MaxX := 0;
    //ybase := FontHeightPixel(FFont.Handle) + 1 + (FOCUS_RECT_MARGIN * 2);  AGP commentout line for
                                                                           //reminder spacing
    ybase := FontHeightPixel(FFont.Handle) + 2;
    yinc := ybase;
    LastLineBlank := FALSE;
    sLbl := nil;
    nLbl := nil;
    TabOrdr := 0;
    if ScreenReaderSystemActive then
    begin
      ScreenReaderSystem_CurrentCheckBox(OwningCheckBox);
      lbl := TLabel.Create(nil);
      try
        lbl.Parent := FPanel;
        sLblHeight := lbl.Height + 2;
      finally
        lbl.Free;
      end;

    end;
  end;

  procedure Text508Work;
  var
    ContinueCode: boolean;
  begin
    if StripCode(txt, SR_BREAK) then
    begin
      ScreenReaderSystem_Stop;
      nLbl := nil;
      sLbl := nil;
    end;

    ContinueCode := FALSE;
    while StripSRCode(txt, ScreenReaderContinueCode, ScreenReaderContinueCodeLen) >= 0 do
      ContinueCode := TRUE;
    while StripSRCode(txt, ScreenReaderContinueCodeOld, ScreenReaderContinueCodeOldLen) >= 0 do
      ContinueCode := TRUE;
    if ContinueCode then
      ScreenReaderSystem_Continue;
  end;

  procedure Ctrl508Work(ctrl: TControl);
  var
    lbl: TCPRSTemplateFieldLabel;
  begin
    if (Ctrl is TCPRSTemplateFieldLabel) and (not (Ctrl is TCPRSDialogHyperlinkLabel)) then
    begin
      lbl := Ctrl as TCPRSTemplateFieldLabel;
      if trim(lbl.Caption) <> '' then
      begin
        ScreenReaderSystem_CurrentLabel(lbl);
        ScreenReaderSystem_AddText(lbl.Caption);
      end
      else
      begin
        lbl.TabStop := FALSE;
        ScreenReaderSystem_Stop;
      end;
    end
    else
    begin
      if ctrl is TWinControl then
        Add2TabOrder(TWinControl(ctrl));
      if Supports(ctrl, ICPRSDialogComponent) then
        ScreenReaderSystem_CurrentComponent(ctrl as ICPRSDialogComponent);
    end;
    sLbl := nil;
    nLbl := nil;
  end;

  procedure NextLine;
  begin
    if(MaxX < x) then
      MaxX := x;
    x := FOCUS_RECT_MARGIN;  {leave two pixels on the left for the Focus Rect}
    inc(y, yinc);
    yinc := ybase;
  end;

begin {TTemplateDialogEntry.GetPanel}
  MaxTextLen := MaxLen - (FOCUS_RECT_MARGIN * 2);{save room for the focus rectangle on the panel}
  if(FFirstBuild or (FPanel.Width <> MaxLen)) then begin
    Init;
    for i := 0 to FControls.Count-1 do begin
      txt := FControls[i];
      if ScreenReaderSystemActive then
        Text508Work;
      if StripCode(txt,EOL_MARKER) then begin
        if((x <> 0) or LastLineBlank) then
          NextLine;
        LastLineBlank := (txt = '');
      end;
      if(txt <> '') then begin
        while(txt <> '') do begin
          cnt := NumCharsFitInWidth(FFont.Handle, txt, MaxTextLen-x);
          MaxChars := cnt;
          if(cnt >= length(txt)) then begin
            DoLabel(txt);
            txt := '';
          end else
          if(cnt < 1) then
            NextLine
          else begin
            repeat
              if(txt[cnt+1] = ' ') then begin
                DoLabel(copy(txt,1,cnt));
                NextLine;
                txt := copy(txt, cnt + 1, MaxInt);
                break;
              end else
                dec(cnt);
            until(cnt = 0);
            if(cnt = 0) then begin
              if(x = FOCUS_RECT_MARGIN) then begin {If x is at the far left margin...}
                DoLabel(Copy(txt,1,MaxChars));
                NextLine;
                txt := copy(txt, MaxChars + 1, MaxInt);
              end else
                NextLine;
            end;
          end;
        end;
      end else begin
        ctrl := TControl(FControls.Objects[i]);
        if(assigned(ctrl)) then begin
          if ScreenReaderSystemActive then
            Ctrl508Work(ctrl);
          idx := FIndents.IndexOfObject(Ctrl);
          if idx >= 0 then
            ind := StrToIntDef(Piece(FIndents[idx], U, 1), 0)
          else
            ind := 0;
          if(x > 0) then begin
            if (x < MaxLen) and (Ctrl is TORCheckBox) and (TORCheckBox(Ctrl).StringData = NewLine) then
              x := MaxLen;
            if((ctrl.Width + x + ind) > MaxLen) then
              NextLine;
          end;
          inc(x,ind);
          Ctrl.Left := x;
          Ctrl.Top := y;
          inc(x, Ctrl.Width + 4);
          if yinc <= Ctrl.Height then
            yinc := Ctrl.Height + 2;
          if (x < MaxLen) and ((Ctrl is TRichEdit) or
             ((Ctrl is TLabel) and (pos(CRLF, TLabel(Ctrl).Caption) > 0))) then
            x := MaxLen;
        end;
      end;
    end;
    NextLine;
    FPanel.Height := (y-1) + (FOCUS_RECT_MARGIN * 2); //AGP added Focus_rect_margin for Reminder spacing
    FPanel.Width := MaxX + FOCUS_RECT_MARGIN;
  end;
  if(FFieldValues <> '') then
    SetFieldValues(FFieldValues);
  if ScreenReaderSystemActive then
    ScreenReaderSystem_Stop;
  Result := FPanel;
end;

procedure TTemplateDialogEntry.AddToCumulativeHTML(HTMLDlg : THTMLDlg);
//kt added entire function 1/16
//Adds information from Entry into cumulative HTML, stored in HTMLDlg
var i : integer;
    HTMLtxt : string;
begin
  FHTMLDlg := HTMLDlg;
  FPseudoHTMLSource.Clear;
  for i := 0 to FHTMLControls.Count-1 do begin
    HTMLtxt := FHTMLControls[i]; //kt 1/16
    HTMLtxt := StringReplace(HTMLtxt, EOL_MARKER, '<BR>', [rfReplaceAll]);  //kt added 1/16
    FPseudoHTMLSource.Add(HTMLtxt);
  end;
  FPseudoHTMLSource.Add('<p>');  //kt 2/20/16
  HTMLDlg.AddFromSource(FPseudoHTMLSource);
end;


function TTemplateDialogEntry.GetText: string;
begin
  //kt original --> Result := ResolveTemplateFields(FText, FALSE);
  Result := ResolveTemplateFields(FText, FALSE, false, false, false, '', '', DBControlData);
end;

function TTemplateDialogEntry.GetHTMLText: string;
//kt added 2/20/16
begin
  Result := ResolveHTMLTemplateFields(FText, FALSE);
end;

procedure TTemplateDialogEntry.KillLabels;
var
  i, idx: integer;
  obj: TObject;
  max: integer;

begin
  if(assigned(FPanel)) then
  begin
    max := FPanel.ControlCount-1;
    for i := max downto 0 do
    begin
// deleting TVA508StaticText can delete several TVA508ChainedLabel components
      if i < FPanel.ControlCount then
      begin
        obj := FPanel.Controls[i];
        if (not (obj is TVA508ChainedLabel)) and
           ((obj is TLabel) or (obj is TVA508StaticText)) then
        begin
          idx := FControls.IndexOfObject(obj);
          if idx < 0 then
            obj.Free;
        end;
      end;
    end;
  end;
end;

procedure TTemplateDialogEntry.SetAutoDestroyOnPanelFree(const Value: boolean);
var M: TMethod;
begin
  FAutoDestroyOnPanelFree := Value;
  if(Value) then begin
    M.Data := Self;
    M.Code := @PanelDestroy;
    FPanel.OnDestroy := TNotifyEvent(M);
  end else begin
    FPanel.OnDestroy := nil;
  end;
end;

procedure TTemplateDialogEntry.SetControlText(CtrlID: integer; AText: string);
var
  cnt, i, j: integer;
  Ctrl: TControl;
  Done: boolean;

begin
  FUpdating := TRUE;
  try
    Done := FALSE;
    cnt := 0;
    for i := 0 to FControls.Count-1 do
    begin
      Ctrl := TControl(FControls.Objects[i]);
      if(assigned(Ctrl)) and (Ctrl.Tag = CtrlID) then
      begin
        Done := TRUE;
        if(Ctrl is TLabel) then
          TLabel(Ctrl).Caption := AText
        else
        if(Ctrl is TEdit) then
          TEdit(Ctrl).Text := AText
        else
        if(Ctrl is TORComboBox) then
          TORComboBox(Ctrl).SelectByID(AText)
        else
        if(Ctrl is TRichEdit) then
          TRichEdit(Ctrl).Lines.Text := AText
        else
        if(Ctrl is TORDateCombo) then
          TORDateCombo(Ctrl).FMDate := MakeFMDateTime(piece(AText,':',2))
        else
        if(Ctrl is TORDateBox) then
          TORDateBox(Ctrl).Text := AText
        else
        if(Ctrl is TORCheckBox) then
        begin
          Done := FALSE;
          TORCheckBox(Ctrl).Checked := FALSE;        //<-PSI-06-170-ADDED THIS LINE - v27.23 - RV
          if(cnt = 0) then
            cnt := DelimCount(AText, '|') + 1;
          for j := 1 to cnt do
          begin
            if(TORCheckBox(Ctrl).Caption = piece(AText,'|',j)) then
              TORCheckBox(Ctrl).Checked := TRUE;
          end;
        end
        else
        if(Ctrl is TfraTemplateFieldButton) then
          TfraTemplateFieldButton(Ctrl).ButtonText := AText
        else
        if(Ctrl is TPanel) then
        begin
          for j := 0 to Ctrl.ComponentCount-1 do
            if Ctrl.Components[j] is TUpDown then
            begin
              TUpDown(Ctrl.Components[j]).Position := StrToIntDef(AText,0);
              break;
            end;
        end;
      end;
      if Done then break;
    end;
  finally
    FUpdating := FALSE;
  end;
end;

procedure TTemplateDialogEntry.SetFieldValues(const Value: string);
var
  i: integer;
  TmpSL: TStringList;

begin
  FFieldValues := Value;
  TmpSL := TStringList.Create;
  try
    TmpSL.CommaText := Value;
    for i := 0 to TmpSL.Count-1 do
      SetControlText(StrToIntDef(Piece(TmpSL[i], U, 1), 0), Piece(TmpSL[i], U, 2));
  finally
    TmpSL.Free;
  end;
end;

//kt original --> function TTemplateDialogEntry.StripCode(var txt: string; code: char): boolean;
function StripCode(var txt: string; code: char): boolean;
var
  p: integer;
begin
  p := pos(code, txt);
  Result := (p > 0);
  if Result then
  begin
    while p > 0 do
    begin
      delete(txt, p, 1);
      p := pos(code, txt);
    end;
  end;
end;

procedure TTemplateDialogEntry.UpDownChange(Sender: TObject);
begin
  EnsureText(TEdit(Sender), TUpDown(TEdit(Sender).Tag));
  DoChange(Sender);
end;

function StripEmbedded(iItems: string): string;
{7/26/01    S Monson
            Returns the field will all embedded fields removed}
var
  p1, p2, icur: integer;
Begin
  p1 := pos(TemplateFieldBeginSignature,iItems);
  icur := 0;
  while p1 > 0 do
    begin
      p2 := pos(TemplateFieldEndSignature,copy(iItems,icur+p1+TemplateFieldSignatureLen,maxint));
      if  p2 > 0 then
        begin
          delete(iItems,p1+icur,TemplateFieldSignatureLen+p2+TemplateFieldSignatureEndLen-1);
          icur := icur + p1 - 1;
          p1 := pos(TemplateFieldBeginSignature,copy(iItems,icur+1,maxint));
        end
      else
        p1 := 0;
    end;
  Result := iItems;
end;

procedure StripScreenReaderCodes(var Text: string);
var
  p, j: integer;
begin
  for j := low(ScreenReaderCodes) to high(ScreenReaderCodes) do
  begin
    p := 1;
    while (p > 0) do
    begin
      p := posex(ScreenReaderCodes[j], Text, p);
      if p > 0 then
        delete(Text, p, ScreenReaderCodeLens[j]);
    end;
  end;
end;

procedure StripScreenReaderCodes(SL: TStrings);
var
  temp: string;
  i: integer;

begin
  for i := 0 to SL.Count - 1 do
  begin
    temp := SL[i];
    StripScreenReaderCodes(temp);
    SL[i] := temp;
  end;
end;

function HasScreenReaderBreakCodes(SL: TStrings): boolean;
var
  i: integer;

begin
  Result := TRUE;
  for i := 0 to SL.Count - 1 do
  begin
    if pos(ScreenReaderCodeSignature, SL[i]) > 0 then
      exit;
  end;
  Result := FALSE;
end;

//kt ----- mod 5/16  Added functions. ---------------
function TDBControlData.GetVal(i : integer) : string;
  begin Result := Self.Strings[i]; end;
procedure TDBControlData.SetVal(i : integer; Val : string);
  begin Self.Strings[i] := Val; end;
function TDBControlData.GetIENVal(i : integer) : string;
  begin Result := IntToStr(Integer(Self.Objects[i])); end;
procedure TDBControlData.SetIENVal(i : integer; Val : string);
  begin Self.Objects[i] := Pointer(StrToIntDef(Val, 0)); end;
function TDBControlData.AddValue(IEN, Value : string) : integer;
  begin Result := Self.AddObject(Value, Pointer(StrToIntDef(IEN,0))); end;
procedure TDBControlData.MsgIfNotEmpty(S : string; MsgDlgType : TMsgDlgType = mtInformation);
  begin if Self.Count > 0 then MessageDlg(S, MsgDlgType, [mbOK], 0); end;
procedure TDBControlData.MsgNoSave;
  begin MsgIfNotEmpty('Can''t save control values to database, so discarding them.'); end;
procedure TDBControlData.MsgShouldSave;  //can remove later, after all saves are done properly.
  begin MsgIfNotEmpty('TO DO.  Implement saving db control values.'); end;
function TDBControlData.SaveToServer(IEN8925 : int64; var ErrStr : string) : boolean;
//Function result: TRUE if success, FALSE if error.
var
  SL : TStringList;
  i : integer;
  IEN, s, AVisitStr, Value : string;
begin
  ErrStr := '';  Result := true;  //default to success (no problems)
  if Self.Count = 0 then exit;
  AVisitStr := VisitStrForNote(IEN8925);
  SL := TStringList.Create;
  try
    for i := 0 to Self.Count-1 do begin
      Value := AnsiReplaceStr(Self.Value[i], '^', '%%/\%%');
      SL.Add('SET^'+Self.IEN[i]+'^'+Self.Value[i]);
    end;
    Result := DBDialogFieldValuesSet(Patient.DFN, IntToStr(IEN8925), AVisitStr, SL, ErrStr);
  finally
    SL.Free;
    Self.Clear;
  end;
end;
//kt ----- mod 5/16 ---------------


initialization

finalization
  KillObj(@uTmplFlds, TRUE);
  KillObj(@uEntries, TRUE);

end.

