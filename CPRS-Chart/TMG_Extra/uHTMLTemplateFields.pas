unit uHTMLTemplateFields;
//kt added entire unit.

{ This unit is still under construction

  This is designed to manage HTML templates that are embedded in HTML documents, with multiple templates possible
  in a single document, and multiple documents tracked.

  It differs from the uHTMLDlg unit in that that unit expects just one HTML template in one HTML document, and
  it was designed to mirror and parallel standard templates.  This unit is a fresh start, albeit patterned after
  uTemplateFields initially.

  THTMLTemplateField = class(TObject)
  THTMLTemplateDialogEntry = class(TObject)
  THTMLTemplateDialogsMgr = class(TObject)
}

 (*

 NOTE: This file was originally copied from uTemplateFields.
 The original version of that file may be obtained freely from the VA.

 This modified version of the file is Copyright 2/23/2016 Kevin S. Toppenberg, MD
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
  {uHTMLDlg, } TMGHTML2, uHTMLTools, MSHTML_EWB,
  uTemplateFields, uHTMLDlgObjs, DateUtils,
  Graphics, ORClasses, ComCtrls, ORDtTm, uDlgComponents, TypInfo, ORFn, StrUtils;

type
  THTMLTemplateDialogEntry = class; //forward
  THTMLTemplateDocument    = class; //forward
  THTMLTemplateDialogsMgr  = class; //forward

  //This class will be the data structure for one field, which is part of one HTML Template.
  //An instance of this class represents one **TYPE** of HTML field, i.e. a check box.
  //  If a template has multiple checkboxes, for example, there will only be ONE
  //  instance of this class to handle all the checkbox instances.
  //NOTE: I wanted, initially, to have this descendent from TTemplateField. But that has substantial
  //    code dealing with creating windows objects (button etc) and putting them into a panel.
  //ADDENDUM: I have extended class TTemplateField such that it can be a DB Control,
  //         such that values written to it will be stored on the server, in the
  //       database.  I will mirror this in THTMLTemplateFieldType.  The consequence
  //     of this is that there should only be ONE instance of each DB-enabled
  //   THTMLTemplateFieldType in a given document.  This is because multiple
  //   instance would overwrite each other's data.  If a control is not DB-enabled,
  //   then multiple instance can be used in a given template.
  //   Example of DB-control would be control for storing patient's smoking status.
  //   So one DB-control would store one type of information for a patient.
  THTMLTemplateFieldType = class(TObject)
  private
    FEntry: THTMLTemplateDialogEntry;
    FMaxLen: integer;
    FFldName: string;
    FNameChanged: boolean;
    FLMText: string;        //List Manager Text-- "...text to insert into a boilerplate when expanded from a list manager interface."
    FEditDefault: string;   //If starts with special tag, then tag specifies data-control modes
    FNotes: string;
    FItems: string;
    FInactive: boolean;
    FItemDefault: string;   //FYI, does NOT contain data-control tag.
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
    FPseudoHTML : string;  //kt added 1/16
    procedure SetEditDefault(const Value: string);
    function  GetItemDefault: string;                         //kt added 5/16
    procedure SetFldName(const Value: string);
    procedure SetFldType(const Value: TTemplateFieldType);
    procedure SetInactive(const Value: boolean);
    procedure SetRequired(const Value: boolean);
    procedure SetSepLines(const Value: boolean);
    procedure SetItemDefault(const Value: string);
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
    function GetHTMLTemplateFieldDefault: string;
    procedure CreateDialogControls(Entry: THTMLTemplateDialogEntry;
                                   HTMLControls : TStringList; HTMLCtrlID: string);
    function SaveError: string;
    function Width: integer;
    function GetRequired: boolean;
    procedure SetDateType(const Value: TTmplFldDateType);
  protected  //THTMLTemplateField
    FDFNOfLastServerRead : string;                            //kt added 5/16
    FDTOfLastServerRead : TDateTime;                          //kt added 5/16
    FLastServerReadValue : String;                            //kt added 5/16
    //function GetIsDBControl : boolean;                      //kt added 5/16
    //procedure SetIsDBControl(Value : boolean);              //kt added 5/16
    procedure SetLastServerReadValue(Value : string);         //kt added 5/16
    function GetEditDefault: string;                          //kt added 5/16
    function GetDataBinding : TDBControlBinding;              //kt added 6/16
    procedure SetDataBinding (Value : TDBControlBinding);     //kt added 6/16
    function GetInnerEditDefaultValue : string;               //kt added 7/16
  public  //THTMLTemplateField
    procedure Assign(AFldType: THTMLTemplateFieldType);
    function NewField: boolean;
    function CanModify: boolean;
    procedure CacheDBValue(DFN, Value : string);              //kt added 5/16
    function IsDBControl_Reader : boolean;                    //kt added 6/16
    function IsDBControl_Writer : boolean;                    //k tadded 6/16
    function IsDBControl : boolean;                           //kt added 6/16
    constructor Create(Entry: THTMLTemplateDialogEntry; AData: TStrings);
    destructor Destroy; override;
    property ID: string read FID write SetID;
    property IEN: string read FID write SetID;  //kt 6/7/16
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
    property TemplateFieldDefault: string read GetHTMLTemplateFieldDefault;
    property DataBinding : TDBControlBinding read GetDataBinding write SetDataBinding; //kt added 6/16
    property LastServerReadValue : String read FLastServerReadValue write SetLastServerReadValue;  //kt added 5/16
  end; //THTMLTemplateField


  tDialogDisplayMode = (tdmEdit, tdmResolved);
  //This class will be the data structure for one HTML dialog (from template) that is embedded in one HTML document.
  //NOTE: I initially wanted this to be descendent from TTemplateDialogEntry, but that code has too
  //      much stuff dealing with creating windows objects, so I have to remake here.
  THTMLTemplateDialogEntry = class(TObject)
  private //THTMLTemplateDialogEntry
    FHTMLTemplateDocument : THTMLTemplateDocument;
    FID: string;
    FTemplateIEN : string;  //IEN in fileman file# 8927
    FTMGDlgID : string;
    FFieldIDCnt : integer;
    //Note: since FListOfTemplateFieldTypes doesn't hold field **instances**, they can be shared between dialog
    //  and this would probably be more effecient to put into the dialog manager  (THTMLTemplateDialogsMgr)
    //CORRECTION: If a template field is a DBControl, the it does act like an instance in
    //    that there should only be one of them(if more, they just overwrite each other's stored
    //    values on the server), and data values are stored in them.  So just leave here.
    FListOfTemplateFieldTypes: TList;  // <-- see comment above
    FFirstBuild: boolean;
    FDefinitionText : string;  //the is the source text for the template, including any scripts
    FDefinitionScriptText : string; //this is source code for javascript that user put into template.
    FDefTextWithHTMLCtrlIDs : string;
    FFieldValues: string;
    FHTML : TStringList;
    FLocalAnswerOpenTag : string;
    FLocalAnswerCloseTag : string;
    FPseudoHTMLSource : TStringList; //kt  FYI: PseudoHTML has simple tags like <NUMBER ...></NUMBER>, that will later be expanded to full HTML
    FHasHandleOnChange : boolean;
    FHasHandleOnInsert : boolean;
    FUsesGetCtrlVal : boolean;
    FUsesSetCtrlVal : boolean;
    FUsesGetDlgHandle : boolean;
    ParsedIDList : TStringList;   //will correlate 1:1 with FResultValues.  Format: Id=StartTag   //kt 6/16
    FResultValues : TStringList;  //will correlate 1:1 with ParsedIDList.   Format: <string with result>  //kt 6/16
    FObjHandlersList : THTMLObjHandlersList;  //owned by FHTMLTemplateDocument

    function GetFieldValues: string;
    procedure SetFieldValues(const Value: string);
  protected  //THTMLTemplateDialogEntry
    function GetHTMLControlText(HTMLCtrlID: string; NoCommas: boolean; var FoundEntry: boolean; var ControlDisabled: boolean): string;
    procedure SetControlText(CtrlID: integer; AText: string);  //not yet implemented....
    function GetHTMLTemplateFieldType(ATemplateField: string; ByIEN: boolean): THTMLTemplateFieldType;
    procedure ClearModifiedTemplateFields;
    procedure ClearTemplateFields;
    procedure ParseToPseudoHTML(DefinitionText: string; PseudoHTMLSource : TStringList);
    procedure ExtractContent(StartTag, EndTag : string; Source, Content: TStringList);
    procedure GetOneSource(Source : TStringList; EndTag: string; var i : integer; Output : TStringList);
    procedure CombineScriptCode(OrigSource : TStringList; SrcB: string);
    function IENOfTemplateFieldType(FldName : string) : string;
  public  //THTMLTemplateDialogEntry
    ParsedSource : TStringList;
    HTMLCtrlIDList : TStringList;
    function SaveTemplateFieldErrors: string;
    function AnyTemplateFieldsModified: boolean;
    procedure ListTemplateFields(const AText: string; AList: TStrings; ListErrors: boolean = FALSE);
    function BoilerplateTemplateFieldsOK(const AText: string; Msg: string = ''): boolean;
    function AreTemplateFieldsRequired(const Text: string; FldValues: TORStringList =  nil): boolean;
    procedure ForgetFieldType(FieldType : THTMLTemplateFieldType);
    function GetNewTemplateFieldID : longint;
    procedure AddFromPseudoHTML(Source: TStringList; CumulativeStyleCodes, CumulativeScriptCode: TStringList; EnableCBName : string='');
    function ParseDefText(DefinitionText: string; CumulativeStyleCodes, CumulativeScriptCode: TStringList) : string;
    function ResolveIntoResultSPAN(DBControlData : TDBControlData) : string;  //puts resolved form of dialog into result SPAN, returns DBControl output to be stored, and ALSO returns a string of text.
    procedure IterateCallBackForMode(Elem : IHTMLElement; Msg : string; Obj : TObject; var Stop : boolean);
    procedure SetDisplayMode(Mode : tDialogDisplayMode);
    procedure LoadResults;
    function HasID(ID : string) : boolean;
    procedure AddToCombinedResultValues(CombinedResultValues : TStringList);
    function GetValueByID(ID : string; var Disabled : boolean; NoCommas : boolean = false) : string;
    constructor Create(AHTMLTemplateDocument : THTMLTemplateDocument; ID : string; TemplateIEN : string);
    destructor Destroy; override;
    property ID: string read FID;
    property TMGDlgID: string read FTMGDlgID;
    property FieldValues: string read GetFieldValues write SetFieldValues;
    property HolderHTMLTemplateDocument : THTMLTemplateDocument read FHTMLTemplateDocument;  //the THTMLTemplateDocument containing this object.
    property HasHandleOnChange : boolean read FHasHandleOnChange;
    property HasHandleOnInsert : boolean read FHasHandleOnInsert;
  end; //THTMLTemplateDialogEntry


  //This class will be the data structure for one HTML document, that can contain multiple HTML dialogs (from templates)
  THTMLTemplateDocument = class(TObject)
  private //THTMLTemplateDocument
    FDialogsManager :THTMLTemplateDialogsMgr;
    FDialogList : TStringList;  //This owns members.  .Strings[i] = InstanceID (e.g.' TMGDlg3'), .Objects[i] is THTMLTemplateDialogEntry
    FWebBrowser: THtmlObj;
    FDialogIDCnt : integer;
    //FNewTemplateFieldIDCnt:  longint;
    FDBControlData : TDBControlData;  //Will hold data to be written to server, in case of DB controls.

    //From THTMLDlg ---------
    FObjHandlersList : THTMLObjHandlersList;
    IDIndex : integer;
    FIntermediateHTML : TStringList;  //HTML + script, but no header/footer
    FCumulativeBodyHTML : TStringList;    // HTML code so far, ultimately to be inserted into some web browser
    FCumulativeScriptCode : TStringList;  //javascript, ultimately to be added to FCumulativeHTML during final compilation.  *Not* wrapped with <script>
    FCumulativeStyleCodes : TStringList;  //style codes, ultimately to be added to FCumulativeHTML during final compilation.  *Not* wrapped with <style>
    Compiled : boolean;
    //kt 6/16 moved to THTMLTemplateDialogEntry --> ParsedIDList : TStringList;   //will correlate 1:1 with FResultValues.  Format: Id=StartTag
    //kt 6/16 moved to THTMLTemplateDialogEntry --> FResultValues : TStringList;  //will correlate 1:1 with ParsedIDList.   Format: <string with result>
    FCombinedResultValues : TStringList;

    procedure AddGlobalStyle(StyleCodes : TStringList);
    //procedure GetOneSource(Source : TStringList; EndTag: string; var i : integer; Output : TStringList);
    //procedure ExtractContent(StartTag, EndTag : string; Source, Content: TStringList);
    procedure LoadResults;
    function GetResultValues : TStringList;
    //End from THTMLDlg ---------
    function AddHTMLTemplateDialog(TemplateIEN : string) : THTMLTemplateDialogEntry;
    function GetAnswerOpenTag : string;
    function GetAnswerCloseTag : string;
  public   //THTMLTemplateDocument
    procedure Clear;
    procedure SyncFromHTMLDocument;  //Scan actual HTML document and modify self if parts have been modified.
    //function  GetNewTemplateFieldID : longint;
    function  HasEmbeddedDialog : boolean;
    procedure InsertTemplateTextAtSelection(DefinitionText : string; TemplateIEN : string);
    property  WebBrowser: THtmlObj read FWebBrowser;
    procedure SetDisplayMode(Mode : tDialogDisplayMode);
    function  GetHTMLTextInSaveMode(IEN8925 : int64) : string;
    procedure EnsureEditViewMode; // Show tmgembeddeddlg SPAN's, and hide tmgembeddeddlg_result SPAN's
    function  GetHTMLControlText(HtmlDlg : TObject; HTMLCtrlID: string; NoCommas: boolean;
                                var FoundEntry: boolean; var ControlDisabled: boolean): string;
    procedure IterateCallBackForDocSync(Elem : IHTMLElement; Msg : string; Obj : TObject; var Stop : boolean);
    constructor Create(ADialogsManager :THTMLTemplateDialogsMgr; WebBrowser: THtmlObj);
    destructor Destroy; override;
    //From THTMLDlg ---------
    procedure RefreshResults;
    //function  GetValue(Index : integer) : string;
    function  GetValueByID(HtmlDlg : TObject; ID : string; var Disabled : boolean; NoCommas : boolean = false) : string;
    function  HasID(ID : string) : boolean;
    property  ResultValues : TStringList read GetResultValues;
    //property  HTML : TStringList read GetCompletedHTML;
    //property  PartialHTML  : TStringList read GetPartialHTML;
    //End from THTMLDlg ---------
    property  ObjHandlersList : THTMLObjHandlersList read FObjHandlersList;
    property HTMLAnswerOpenTag : string read GetAnswerOpenTag;
    property HTMLAnswerCloseTag : string read GetAnswerCloseTag;
  end; //THTMLTemplateDocument

  //This manager will track all the various HTML documents
  //TODO, change class to meet this objective
  THTMLTemplateDialogsMgr = class(TObject)
  private //THTMLTemplateDialogsMgr
    FInit : boolean;
    FHTMLDocList : TList;
    FAnswerOpenTag : string;
    FAnswerCloseTag : string;
    //FEntries: TStringList;
    //FieldIDCount: integer;
    //FFormulaCount: integer;
    //FTxtObjCount : integer;
    //FVarObjCount : integer;
    //function GetNewFieldID: string;
    //procedure FreeEntries(SL: TStrings);
    //procedure AssignFieldIDs(var Txt: string; NameToObjID : TStringList); overload;
    //procedure AssignFieldIDs(SL: TStrings; NameToObjID : TStringList);    overload;
    function AddHTMLDoc(AWebBrowser: THtmlObj) : THTMLTemplateDocument;
    procedure Init;
  public  //THTMLTemplateDialogsMgr
    procedure Clear;
    //function GetDialogEntry(AParent: TWinControl; AID, AText: string): THTMLTemplateDialogEntry;

    //NOTE: I will use the WebBrowser (which holds the HTML document) as the manager of the actual document
    //      If the document is changed in the browser, I will have to handle this...
    function EnsureHTMLDocAdded(AWebBrowser: THtmlObj) : THTMLTemplateDocument;
    function GetHTMLDoc(AWebBrowser: THtmlObj) : THTMLTemplateDocument;  //returns nil if not already added.
    procedure InsertTemplateTextAtSelection(AWebBrowser: THtmlObj; DefinitionText : string; TemplateIEN : string);
    function GetHTMLTextInSaveMode(AWebBrowser: THtmlObj; IEN8925 : int64) : string;
    function HasEmbeddedDialog(AWebBrowser: THtmlObj) : boolean;
    procedure SetHTMLAnswerOpenCloseTags(OpenHTML, CloseHTML : string);
    procedure SyncFromHTMLDocument(AWebBrowser: THtmlObj);  //Scan actual HTML document and modify self if parts have been modified.
    procedure EnsureEditViewMode(AWebBrowser: THtmlObj);
    procedure RemoveWebBrowser(AWebBrowser: THtmlObj);
    procedure ClearWebBrowser(AWebBrowser: THtmlObj);
    constructor Create;
    destructor Destroy;
    property HTMLAnswerOpenTag : string read FAnswerOpenTag;
    property HTMLAnswerCloseTag : string read FAnswerCloseTag;
  end; //THTMLTemplateDialogsMgr


  TInterfaceListAndTStrings = class(TObject)
  private
  public
    InterfaceList : TInterfaceList;
    SL            : TStringList;
    constructor Create;
    destructor Destroy;
  end;

var
  GLOBAL_HTMLTemplateDialogsMgr : THTMLTemplateDialogsMgr;  //Instantiated in Initialize Section below

implementation

uses
  rTemplates, ORCtrls, mTemplateFieldButton, dShared, uConst, uCore, rCore, Windows,
  uCarePlan, uTMGUtil,
  fTemplateDialog,
  HTTPUtil,
  uTemplateMath,
  uEvaluateExpr,
  ORNet,
  VAUtils,
  fTest_RW_HTML   //for debugging.  Can remove later.
  ,fFrame;

{ TTemplateDialogEntry }
const
  EOL_MARKER = #182;
  SR_BREAK   = #186;
  DIALOG_TAG = 'TMGDlg';

  //intrinsic script function
  HANDLE_ON_CHANGE = 'handleOnChange';
  HANDLE_ON_INSERT = 'handleOnInsert';
  GET_DLG_HANDLE   = 'getDlgHandle';
  GET_CTRL_VAL     = 'getCtrlVal';
  SET_CTRL_VAL     = 'setCtrlVal';
  COMMON_FN_PREFIX = 'COMMON_';

//***************************************************************************
{ TInterfaceListAndTStrings }
//***************************************************************************

constructor TInterfaceListAndTStrings.Create;
begin
  Inherited;
  InterfaceList := TInterfaceList.Create;
  SL := TStringList.Create;
end;

destructor TInterfaceListAndTStrings.Destroy;
begin
  InterfaceList.Free;
  SL.Free;
  Inherited;
end;


//***************************************************************************
{ THTMLTemplateField }
//***************************************************************************

constructor THTMLTemplateFieldType.Create(Entry: THTMLTemplateDialogEntry; AData: TStrings);
var
  tmp, p1: string;
  AFID, i,idx,cnt: integer;
  NewTemplateFieldIDCnt : longint;

begin
  FEntry := Entry;
  AFID := 0;
  if(assigned(AData)) then begin
    if AData.Count > 0 then
      AFID := StrToIntDef(AData[0],0);
    if(AFID > 0) and (AData.Count > 1) then begin
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
        if(p1 = 'D') then
          FNotes := FNotes + tmp + CRLF
        else
        if(p1 = 'U') then
          FURL := tmp
        else if(p1 = 'I') then begin
          inc(cnt);
          FItems := FItems + tmp + CRLF;
          if(cnt=idx) then
            FItemDefault := tmp;
        end;
      end;
      FRequired  := (Piece(AData[1],U,8) = '1');
      FSepLines  := (Piece(AData[1],U,9) = '1');
      FTextLen   := StrToIntDef(Piece(AData[1],U,10),100);  //kt changed 0 --> 100
      FIndent    := StrToIntDef(Piece(AData[1],U,11),0);
      FPad       := StrToIntDef(Piece(AData[1],U,12),0);
      FMinVal    := StrToIntDef(Piece(AData[1],U,13),-100); //kt changed 0 --> -100
      FMaxVal    := StrToIntDef(Piece(AData[1],U,14),100);  //kt changed 0 --> 100
      FIncrement := StrToIntDef(Piece(AData[1],U,15),1);    //kt changed 0 --> 1
      FDateType  := TemplateDateCode2DateType(Piece(AData[1],U,16));
      FModified  := FALSE;
      FNameChanged := FALSE;
    end;
  end;
  if(AFID = 0) then begin
    NewTemplateFieldIDCnt := Entry.GetNewTemplateFieldID;
    FID := IntToStr(-NewTemplateFieldIDCnt);
    FFldName := NewTemplateField;  //FYI, NewTemplateField is a constant
    FModified := TRUE;
  end;
  FDTOfLastServerRead := 0;    //kt added 5/16
  FLastServerReadValue := '';  //kt added 5/16
end;

//kt mod 5/16 -------------------------------------------------
//NOTE: In order to avoid changing the server, I will overload the EditDefault field
//     such that if EditDefault = '$DB', then the control will get it's default
//     values from the database via separate RPC call, rather than taking the given
//     value for the field.  This will be true regardless of the control type.
{
function THTMLTemplateFieldType.GetIsDBControl : boolean;
begin
   Result := (FEditDefault = DATABASE_CONTROL_TAG);
end;
procedure THTMLTemplateFieldType.SetIsDBControl(Value : boolean);
//kt added entire function
begin
  SetEditDefault(IfThen(Value, DATABASE_CONTROL_TAG, ''));
end;
}

//NOTE: In order to avoid changing the server, I will overload the EditDefault field
//     such that if EditDefault contains '$DB$_**$', then the control has database binding:
//       '$DB$_RW$'  <-- read and write control value to database
//       '$DB$_W$xxxxxxx'  <-- write only control value to database
//     If there is data binding, then the control will get values from the database
//     via separate RPC call, rather than taking the given value for the field.
//     This will be true regardless of the control type.

function THTMLTemplateFieldType.GetInnerEditDefaultValue : string;
//kt added 7/16
//Strip off tag and return just default value
begin
  Case(GetDataBinding) of
    dbcbReadWrite  : Result := MidStr(FEditDefault, length(DATABASE_CONTROL_RW_TAG)+1, MaxInt);
    dbcbWriteOnly  : Result := MidStr(FEditDefault, length(DATABASE_CONTROL_W_TAG)+1, MaxInt);
    dbcbNone       : Result := FEditDefault;
  end;
end;


function THTMLTemplateFieldType.GetDataBinding : TDBControlBinding;
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

procedure THTMLTemplateFieldType.SetDataBinding(Value : TDBControlBinding);
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

function THTMLTemplateFieldType.IsDBControl_Reader : boolean;
//kt added 6/16
begin
  Result := (DataBinding = dbcbReadWrite);
end;

function THTMLTemplateFieldType.IsDBControl_Writer : boolean;
//kt added 6/16
begin
  Result := (DataBinding in [dbcbReadWrite, dbcbWriteOnly]);
end;

function THTMLTemplateFieldType.IsDBControl : boolean;
//kt added 6/16
begin
  Result := (DataBinding <> dbcbNone);
end;

procedure THTMLTemplateFieldType.SetLastServerReadValue(Value : string);
begin
  FLastServerReadValue := StringReplace(Value, '{{LF}}', #13#10, [rfReplaceAll, rfIgnoreCase]);
end;

function THTMLTemplateFieldType.GetItems: string;
begin
  if IsDBControl and (FFldType in EditTextTypes) then begin
    Result := GetItemDefault
  end else begin
    Result := FItems;
  end;
end;

function THTMLTemplateFieldType.GetItemDefault: string;
//kt added 5/16
var UseLocalValue : boolean;
    DFN : string;
    ErrStr : string;
const
  //Read from server unless already read in past X seconds
  ALLOWED_LOCAL_DECAY_SECONDS = 10;
begin
  if (DataBinding = dbcbReadWrite) then begin     //if IsDBControl then begin
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
    Result := FEditDefault;
  end;
end;

procedure THTMLTemplateFieldType.CacheDBValue(DFN, Value : string);
//kt added funtion 5/16
//This function allows a batch reading of many DB field values to be done elsewhere
//  and then stored here.  These values will expire after ALLOWED_LOCAL_DECAY_SECONDS
begin
  FDFNOfLastServerRead := DFN;
  LastServerReadValue := Value;
  FDTOfLastServerRead := NOW;
end;

//kt end mod -------------------------------------------------


function THTMLTemplateFieldType.GetHTMLTemplateFieldDefault: string;
begin
    case FFldType of
      dftEditBox,
      dftNumber:              Result := EditDefault;  //kt was FEditDefault 

      dftComboBox,
      dftButton,
      dftCheckBoxes,          {Clear out embedded fields}
      dftRadioButtons:        Result := StripEmbedded(ItemDefault);  //kt was FItemDefault

      dftDate:                if EditDefault <> '' then Result := EditDefault;  //kt was FEditDefault

      dftHyperlink, dftText:  if EditDefault <> '' then begin  //kt was FEditDefault
                                Result := StripEmbedded(EditDefault)  //kt was FEditDefault
                              end else begin
                                Result := URL;
                              end;

      dftWP:                  Result := Items;
    end;
end;

procedure THTMLTemplateFieldType.CreateDialogControls(Entry: THTMLTemplateDialogEntry;
                                                      HTMLControls : TStringList; HTMLCtrlID: string);
var
  //i, Aht, w, tmp, AWdth: integer;
  i, j : integer;
  InitDT : string; //kt 1/16
  //HTMLCtrlID : string; //kt 1/16
  DefaultStr : string;
  DefaultStrSL : TStringList;
  STmp: string;
  Caption : string;
  TmpSL: TStringList;
  DefDate: TFMDateTime;
  MaxLength : integer;
const BoolStr : array[false .. true] of string[5] = ('false','true');

begin
  if(not FInactive) and (FFldType <> dftUnknown) then begin
    //HTMLCtrlID := 'ctrl' + IntToStr(CtrlID); //kt 1/16
    DefaultStr := StripEmbedded(ItemDefault);
    DefaultStrSL := TStringList.Create;
    PiecesToList(DefaultStr,',',DefaultStrSL);
    for i := 0 to DefaultStrSL.Count - 1 do DefaultStrSL[i] := Trim(DefaultStrSL[i]);

    TmpSL := TStringList.Create;
    FPseudoHTML := '';
    case FFldType of

      dftEditBox: begin
        if FTextLen > 0 then MaxLength := FTextLen else MaxLength := FMaxLen;
        FPseudoHTML := '<EDITBOX id="'+HTMLCtrlID+'" size=' + IntToStr(MaxLength) + '>' + EditDefault + '</EDITBOX>';  //kt was FEditDefault
      end;

      dftComboBox: begin
        TmpSL.Text := Items;
        FPseudoHTML := '<COMBO id="'+HTMLCtrlID+'" initial="' + DefaultStr + '">^';
        for j := 0 to TmpSL.Count - 1 do begin
          FPseudoHTML := FPseudoHTML + TmpSL.Strings[j];
          if j <> TmpSL.Count - 1 then FPseudoHTML := FPseudoHTML + '^';
        end;
        FPseudoHTML := FPseudoHTML + '</COMBO>';
      end;

      dftButton: begin
        //e.g. <CYCBUTTON initial="opt2">opt1|Apples^opt2|Pears^opt3^opt4</CYCBUTTON>
        TmpSL := TStringList.Create;
        TmpSL.Text := Items;
        FPseudoHTML := '<CYCBUTTON id="'+HTMLCtrlID+'" initial="' + DefaultStr + '">';
        for j := 0 to TmpSL.Count - 1 do begin
          FPseudoHTML := FPseudoHTML + TmpSL.Strings[j];
          if j <> TmpSL.Count - 1 then FPseudoHTML := FPseudoHTML + '^';
        end;
        FPseudoHTML := FPseudoHTML + '</CYCBUTTON>';
      end;

      dftCheckBoxes, dftRadioButtons: begin
        TmpSL.Text := StripEmbedded(Items);
        if FSepLines then FPseudoHTML := FPseudoHTML + '<BR>';
        if FFldType = dftRadioButtons then begin
          //<RADIO inline=false initial="opt2">opt|Apples^opt2|Pears^opt3^opt4</RADIO>
          FPseudoHTML :=  FPseudoHTML + '<RADIO ';
        end else begin  //dftCheckBoxes
          FPseudoHTML := FPseudoHTML + '<CBGROUP count=' + IntToStr(TmpSL.Count) + ' ';
        end;
        FPseudoHTML :=  FPseudoHTML + 'id="'+HTMLCtrlID+'" ';
        if ItemDefault <> '' then FPseudoHTML := FPseudoHTML + 'initial="' + DefaultStr + '" ';
        FPseudoHTML := FPseudoHTML + 'inline='+BoolStr[not FSepLines] + ' ';  //kt
        FPseudoHTML := FPseudoHTML + '>';  //kt
        for i := 0 to TmpSL.Count-1 do begin
          if FFldType = dftRadioButtons then begin
            FPseudoHTML := FPseudoHTML + TmpSL.Strings[i];
            if i = TmpSL.Count - 1 then begin
              FPseudoHTML := FPseudoHTML + '</RADIO>';
              HTMLControls.Add(FPseudoHTML);
              FPseudoHTML := '';
            end else begin
              FPseudoHTML := FPseudoHTML + '^';
              HTMLControls.Add('');
            end;
          end else begin //dftCheckBoxes
            FPseudoHTML := FPseudoHTML + '<CHECKBOX id="'+HTMLCtrlID+'d'+IntToStr(i)+'" ';
            //kt if TmpSL.Strings[i] = DefaultStr then FPseudoHTML := FPseudoHTML + 'checked ';
            if DefaultStrSL.IndexOf(TmpSL.Strings[i]) > -1 then FPseudoHTML := FPseudoHTML + 'checked ';
            FPseudoHTML := FPseudoHTML + '>' + TmpSL.Strings[i] + '</CHECKBOX>';
            if FSepLines then FPseudoHTML := FPseudoHTML + '<BR>';
            if i = TmpSL.Count - 1 then FPseudoHTML := FPseudoHTML +  '</CBGROUP>';
            HTMLControls.Add(FPseudoHTML);
            FPseudoHTML := '';
          end;
        end;
      end;

      dftDate: begin
        if EditDefault <> '' then begin  //kt was FEditDefault
          DefDate := StrToFMDateTime(EditDefault)
        end else begin
          DefDate := 0;
        end;
        FPseudoHTML := '<DATE id="'+HTMLCtrlID+'" ';
        FPseudoHTML := FPseudoHTML + 'DTMode=' + IntToStr(Ord(FDateType)-1) + ' ';
        if DefDate<> 0 then begin
          DateTimeToString(InitDT, 'mm/dd/yyyy', FMDateTimeToDateTime(DefDate));
          FPseudoHTML := FPseudoHTML + 'initial="' + InitDT + '"';
        end;
        FPseudoHTML := FPseudoHTML + '></DATE>';
        //e.g. '<DATE DTMode=0 initial="7/3/1967"></DATE>'
      end;

      dftNumber: begin
        i := Increment;
        FPseudoHTML := '<NUMBER id="'+HTMLCtrlID+'" ';  //kt
        FPseudoHTML := FPseudoHTML + 'min='+inttostr(MinVal)+' max='+inttostr(MaxVal)+' step='+inttostr(i)+'>'+EditDefault+'</NUMBER>';
      end;

      dftHyperlink, dftText: begin
        if (FFldType = dftHyperlink) then begin
          if EditDefault <> '' then  //kt was FEditDefault
            Caption := StripEmbedded(EditDefault)  //kt was FEditDefault
          else
            Caption := URL;
          FPseudoHTML := '<a id="'+HTMLCtrlID+'" href="' + URL + '">' + Caption + '</a>';  //kt added 1/16
        end else begin
          STmp := StripEmbedded(Items);
          if copy(STmp,length(STmp)-1,2) = CRLF then
            delete(STmp,length(STmp)-1,2);
          Caption := STmp;
          FPseudoHTML := HTMLEscape(STmp);
          FPseudoHTML := StringReplace(FPseudoHTML, CRLF, '<BR>', [rfReplaceAll]);
        end;
      end;

      dftWP: begin
        STmp := StripEmbedded(Items);
        if copy(STmp,length(STmp)-1,2) = CRLF then delete(STmp,length(STmp)-1,2);
        STmp := StringReplace(HTMLEscape(STmp), CRLF, '<BR>', [rfReplaceAll]);
        FPseudoHTML := '<WPBOX id="'+HTMLCtrlID+'">' + sTmp + '</WPBOX>';
      end;
    end;  //case
    TmpSL.Free;
    DefaultStrSL.Free;
    if FPseudoHTML <> '' then begin
      HTMLControls.Add(FPseudoHTML);  //kt added 1/16
      Entry.HTMLCtrlIDList.Add(HTMLCtrlID);
    end;
  end;
end;

function THTMLTemplateFieldType.CanModify: boolean;
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

procedure THTMLTemplateFieldType.SetEditDefault(const Value: string);
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

function THTMLTemplateFieldType.GetEditDefault: string;
begin
  case DataBinding of
    dbcbReadWrite:  Result := GetInnerEditDefaultValue;  //kt GetItemDefault;
    dbcbWriteOnly:  Result := GetInnerEditDefaultValue;  //kt GetItemDefault;
    dbcbNone:       Result := FEditDefault;
  end;
end;

procedure THTMLTemplateFieldType.SetFldName(const Value: string);
begin
  if(FFldName <> Value) and CanModify then
  begin
    FFldName := Value;
    FNameChanged := TRUE;
  end;
end;

procedure THTMLTemplateFieldType.SetFldType(const Value: TTemplateFieldType);
begin
  if(FFldType <> Value) and CanModify then begin
    FFldType := Value;
    if(Value = dftEditBox) then begin
      if (FMaxLen < 1) then
        FMaxLen := 1;
      if FTextLen < FMaxLen then
        FTextLen := FMaxLen;
    end     else
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

procedure THTMLTemplateFieldType.SetID(const Value: string);
begin
//  if(FID <> Value) and CanModify then
    FID := Value;
end;

procedure THTMLTemplateFieldType.SetInactive(const Value: boolean);
begin
  if(FInactive <> Value) and CanModify then
    FInactive := Value;
end;

procedure THTMLTemplateFieldType.SetItemDefault(const Value: string);
begin
  //NOTE: FItemDefault doesn't store TAG, it is FEditDefault that does that.
  if(FItemDefault <> Value) and CanModify then
    FItemDefault := Value;
end;

procedure THTMLTemplateFieldType.SetItems(const Value: string);
begin
  if(FItems <> Value) and CanModify then
    FItems := Value;
end;

procedure THTMLTemplateFieldType.SetLMText(const Value: string);
begin
  if(FLMText <> Value) and CanModify then
    FLMText := Value;
end;

procedure THTMLTemplateFieldType.SetMaxLen(const Value: integer);
begin
  if(FMaxLen <> Value) and CanModify then
    FMaxLen := Value;
end;

procedure THTMLTemplateFieldType.SetNotes(const Value: string);
begin
  if(FNotes <> Value) and CanModify then
    FNotes := Value;
end;

function THTMLTemplateFieldType.SaveError: string;
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
  if(FModified or NewRec) then begin
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
        FldSL.Add('.05='+EditDefault);  //kt was FEditDefault
        FldSL.Add('.06='+FLMText);
        idx := -1;
        if(Items <> '') and (ItemDefault <> '') then begin  //kt was FItems and FItemDefault
          TmpSL.Text := Items;  //kt was FItems
          for i := 0 to TmpSL.Count-1 do begin
            if (ItemDefault = TmpSL[i]) then begin  //kt was FItemDefault
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

        if(FNotes <> '') or (not NewRec) then begin
          if(FNotes = '') then
            FldSL.Add('2,1=@')
          else begin
            TmpSL.Text := FNotes;
            for i := 0 to TmpSL.Count-1 do begin
              FldSL.Add('2,'+IntToStr(i+1)+',0='+TmpSL[i]);
            end;
          end;
        end;
        if((Items <> '') or (not NewRec)) then begin  //kt was FItems
          if(Items = '') then begin     //kt was FItems
            FldSL.Add('10,1=@')
          end else begin
            TmpSL.Text := Items;   //kt was FItems
            for i := 0 to TmpSL.Count-1 do begin
              FldSL.Add('10,'+IntToStr(i+1)+',0='+TmpSL[i]);
            end;
          end;
        end;

        Res := UpdateTemplateField(AID, FldSL);
        IEN64 := StrToInt64Def(Piece(Res,U,1),0);
        if(IEN64 > 0) then begin
          if(NewRec) then begin
            FID := IntToStr(IEN64)
          end else begin
            UnlockTemplateField(FID);
          end;
          FModified := FALSE;
          FNameChanged := FALSE;
          FLocked := FALSE;
        end else
          Result := Piece(Res, U, 2);
      finally
        FldSL.Free;
      end;
    finally
      TmpSL.Free;
    end;
  end;
end;

procedure THTMLTemplateFieldType.Assign(AFldType: THTMLTemplateFieldType);
begin
  FMaxLen        := AFldType.FMaxLen;
  FFldName       := AFldType.FFldName;
  FLMText        := AFldType.FLMText;
  EditDefault    := AFldType.EditDefault;   //kt was FEditDefault
  FNotes         := AFldType.FNotes;
  Items          := AFldType.Items; //kt was FItems
  FInactive      := AFldType.FInactive;
  ItemDefault    := AFldType.ItemDefault;  //kt was FItemDefault
  FFldType       := AFldType.FFldType;
  FRequired      := AFldType.FRequired;
  FSepLines      := AFldType.FSepLines;
  FTextLen       := AFldType.FTextLen;
  FIndent        := AFldType.FIndent;
  FPad           := AFldType.FPad;
  FMinVal        := AFldType.FMinVal;
  FMaxVal        := AFldType.FMaxVal;
  FIncrement     := AFldType.FIncrement;
  FDateType      := AFldType.FDateType;
  FURL           := AFldType.FURL;
end;

function THTMLTemplateFieldType.Width: integer;
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
        TmpSL.Text := StripEmbedded(Items);  //kt was FItems
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

destructor THTMLTemplateFieldType.Destroy;
begin
  //removed --> I am concerned about double deletion.... FEntry.ForgetField(Self);
  inherited;
end;

procedure THTMLTemplateFieldType.SetRequired(const Value: boolean);
begin
  if(FRequired <> Value) and CanModify then
    FRequired := Value;
end;

function THTMLTemplateFieldType.NewField: boolean;
begin
  Result := (StrToIntDef(FID,0) <= 0);
end;

procedure THTMLTemplateFieldType.SetSepLines(const Value: boolean);
begin
  if(FSepLines <> Value) and CanModify then
    FSepLines := Value
end;

procedure THTMLTemplateFieldType.SetIncrement(const Value: integer);
begin
  if(FIncrement <> Value) and CanModify then
    FIncrement := Value;
end;

procedure THTMLTemplateFieldType.SetIndent(const Value: integer);
begin
  if(FIndent <> Value) and CanModify then
    FIndent := Value;
end;

procedure THTMLTemplateFieldType.SetMaxVal(const Value: integer);
begin
  if(FMaxVal <> Value) and CanModify then
    FMaxVal := Value;
end;

procedure THTMLTemplateFieldType.SetMinVal(const Value: integer);
begin
  if(FMinVal <> Value) and CanModify then
    FMinVal := Value;
end;

procedure THTMLTemplateFieldType.SetPad(const Value: integer);
begin
  if(FPad <> Value) and CanModify then
    FPad := Value;
end;

procedure THTMLTemplateFieldType.SetTextLen(const Value: integer);
begin
  if(FTextLen <> Value) and CanModify then
    FTextLen := Value;
end;

procedure THTMLTemplateFieldType.SetURL(const Value: string);
begin
  if(FURL <> Value) and CanModify then
    FURL := Value;
end;

function THTMLTemplateFieldType.GetRequired: boolean;
begin
  if FFldType in NoRequired then
    Result := FALSE
  else
    Result := FRequired;
end;

procedure THTMLTemplateFieldType.SetDateType(const Value: TTmplFldDateType);
begin
  if(FDateType <> Value) and CanModify then
    FDateType := Value;
end;

//***************************************************************************
 {THTMLTemplateDialogEntry}
//***************************************************************************

constructor THTMLTemplateDialogEntry.Create(AHTMLTemplateDocument : THTMLTemplateDocument; ID : string; TemplateIEN : string);
begin
  Inherited Create;
  FTMGDlgID := ID;
  FFieldIDCnt := 0;
  FHasHandleOnChange := false;
  FHasHandleOnInsert := false;
  FTemplateIEN := TemplateIEN;
  FHTMLTemplateDocument := AHTMLTemplateDocument;
  if assigned(AHTMLTemplateDocument) then FObjHandlersList :=  AHTMLTemplateDocument.ObjHandlersList;
  FListOfTemplateFieldTypes := TList.Create;
  HTMLCtrlIDList := TStringList.Create;
  FHTML := TStringList.Create;
  ParsedSource := TStringList.Create;
  FPseudoHTMLSource := TStringList.Create;
  ParsedIDList := TStringList.Create;  //kt 6/16
  FResultValues := TStringList.Create;  //kt 6/16
end;

destructor THTMLTemplateDialogEntry.Destroy;
begin
  //FINISH  --- Check DOM and see if the SPAN for this object, and the SPAN for the _result exist.  If so, then delete them.
  ClearTemplateFields;
  FListOfTemplateFieldTypes.Free;
  FPseudoHTMLSource.Free;
  HTMLCtrlIDList.Free;
  FHTML.Free;
  ParsedSource.Free;
  ParsedIDList.Free;  //kt 6/16
  FResultValues.Free;  //kt 6/16
  inherited;
end;

procedure THTMLTemplateDialogEntry.ParseToPseudoHTML(DefinitionText: string; PseudoHTMLSource : TStringList);
//Take template definition text, with {FLD:xxx} tags etc, and turn into PseudoHTML, e.g.
//    <CHECKBOX: checkedvalue="something" uncheckedvalue="something else">Display Text</CHECKBOX>
//    <EDITBOX: width="width value">initial text goes here</EDITBOX>
//    <WPBOX: cols="width value" rows="height value">Initial text goes here</WPBOX>
var
  CtrlID, idx, PosStartTag, PosPastStartTag, PosEndTag, PosPastEndTag, flen: integer;
  FldName, WorkingLine: string;
  HTMLInsertableDefText : string;
  AHTMLTemplateFieldType: THTMLTemplateFieldType;
  TempHTMLSL: TStringList; //Each line contains either text to show, or pseudoHTML
  Attrs, ScriptSL : TStringList;
  FnNames, tempSL, DefTextWithHTMLCtrlIDSL : TStringList;
  HTMLCtrlID : string;
  i : integer;
  OneFnName, Script, s, StrA, StrB : string;

const
  SCRIPT_OPEN_TAG = '{SCRIPT}';
  SCRIPT_CLOSE_TAG = '{/SCRIPT}';

begin
  DefinitionText := StringReplace(DefinitionText, #9, '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', [rfReplaceAll]);
  DefinitionText := StringReplace(DefinitionText, '<SCRIPT>',  SCRIPT_OPEN_TAG,  [rfReplaceAll, rfIgnoreCase]);
  DefinitionText := StringReplace(DefinitionText, '</SCRIPT>', SCRIPT_CLOSE_TAG, [rfReplaceAll, rfIgnoreCase]);

  FDefinitionText := FormatHTMLTags(DefinitionText);
  //DefinitionText := RemoveHTMLTags(DefinitionText);
  DefTextWithHTMLCtrlIDSL := TStringList.Create;
  TempHTMLSL := TStringList.Create;
  //tempSL  := TStringList.Create;
  TempHTMLSL.Text := FDefinitionText;

  FDefinitionScriptText := '';
  s := UpperCase(FDefinitionText);
  PosStartTag := Pos(SCRIPT_OPEN_TAG, s);
  if PosStartTag > 0 then begin  //cut out script code
    PosPastStartTag := PosStartTag + length(SCRIPT_OPEN_TAG);
    PosEndTag := PosEx(SCRIPT_CLOSE_TAG, s, PosPastStartTag);
    if PosEndTag > 0 then begin
      try
        ScriptSL := TStringList.Create;
        FnNames := TStringList.Create;
        PosPastEndTag := PosEndTag + length(SCRIPT_CLOSE_TAG);
        Script := MidStr(FDefinitionText, PosPastStartTag, PosEndTag - PosPastStartTag);
        TempHTMLSL.Text := MidStr(s, 1, PosStartTag-1) + MidStr(s, PosPastEndTag, length(s));
        ScriptSL.Text := Script;
        //FHTMLTemplateDocument.FWebBrowser.SummarizeScript(ScriptSL, FnNames);
        SummarizeScript(ScriptSL, FnNames);
        FHasHandleOnChange := (FnNames.IndexOf(HANDLE_ON_CHANGE) > -1);
        FHasHandleOnInsert := (FnNames.IndexOf(HANDLE_ON_INSERT) > -1);
        FUsesGetCtrlVal := (Pos(GET_CTRL_VAL, Script)>0);
        FUsesSetCtrlVal := (Pos(SET_CTRL_VAL, Script)>0);
        FUsesGetDlgHandle := (Pos(GET_DLG_HANDLE, Script)>0);
        for i := 0 to FnNames.Count - 1 do begin
         OneFnName := FnNames.Strings[i];
         if Pos(COMMON_FN_PREFIX, OneFnName) = 1 then continue;  //don't rename COMMON_* function names.
         Script := StringReplace(Script, OneFnName, OneFnName+'_'+FTMGDlgID, [rfReplaceAll]);
        end;
        FDefinitionScriptText := Script;
      finally
        ScriptSL.Free;
        FnNames.Free;
      end;
    end;
  end;
  //TO-DO -- consider user access control to prevent malicious template creating ... e.g. infinite loop of pop-up alerts.
  //But actually, this would be better controlled at the time of CREATION of the template.
  //If I don't want user scripts, then set FDefinitionScriptText := '';

  FFirstBuild := TRUE;
  PseudoHTMLSource.Clear;
  PseudoHTMLSource.Add('<div contentEditable=false>');
  s := '<DIALOG id="' + FTMGDlgID + '" ' + 'IEN="' + FTemplateIEN + '">';
  PseudoHTMLSource.Add(s);
  idx := 0;
  while (idx < TempHTMLSL.Count) do begin
    WorkingLine := TempHTMLSL[idx];
    PosStartTag := 1;
    StrA := ''; strB := '';
    PosStartTag := PosEx(TemplateFieldBeginSignature, WorkingLine, PosStartTag);
    while PosStartTag > 0 do begin
      PosPastStartTag := PosStartTag + TemplateFieldSignatureLen;  //move i to right after field start sig
      if WorkingLine[PosPastStartTag] = FieldIDDelim then begin
        CtrlID := StrToIntDef( MidStr(WorkingLine, PosPastStartTag+1, FieldIDLen-1), 0);
        delete(WorkingLine, PosPastStartTag, FieldIDLen);
      end else begin
        CtrlID := GetNewTemplateFieldID;
      end;
      HTMLCtrlID := 'ctrl' + IntToStr(CtrlID) + '_' + FTMGDlgID;
      StrA := MidStr(WorkingLine, 1, PosStartTag-1);
      PosEndTag := PosEx(TemplateFieldEndSignature, WorkingLine, PosPastStartTag);
      if(PosEndTag > 0) then begin
        PosPastEndTag := PosEndTag + length(TemplateFieldEndSignature);
        PosStartTag := PosPastEndTag; //needed for next search cycle
        flen := PosEndTag - PosPastStartTag;
        FldName := MidStr(WorkingLine, PosPastStartTag, flen);
        //1 Fld represents 1 type (e.g. edit box)
        //  E.g. Add edit boxes by using same AHTMLTemplateFieldType object to generate actual instances
        StrB := MidStr(WorkingLine, PosPastEndTag, length(WorkingLine));
        AHTMLTemplateFieldType := GetHTMLTemplateFieldType(FldName, FALSE);
        if assigned(AHTMLTemplateFieldType) then begin
          if(AHTMLTemplateFieldType.Required) then StrB := '* ' + StrB;
          PseudoHTMLSource.Add(StrA);
          AHTMLTemplateFieldType.CreateDialogControls(Self, PseudoHTMLSource, HTMLCtrlID);
          DefTextWithHTMLCtrlIDSL.Add(StrA + HTML_CTRL_TAG + HTMLCtrlID + '^' + FldName + HTML_CTRL_END_TAG);
          WorkingLine := StrB;
          PosStartTag := 1; //needed for next search cycle
        end else begin
          WorkingLine := StrA + '[Unknown field: "' + FldName + '"]' + StrB;
        end
      end else begin
        StrB := MidStr(WorkingLine, PosPastStartTag, length(WorkingLine));
        PosStartTag := 1;
        WorkingLine := StrB;
      end;
      PosStartTag := PosEx(TemplateFieldBeginSignature, WorkingLine, PosStartTag);
    end;
    PseudoHTMLSource.Add(WorkingLine + '<BR>');
    DefTextWithHTMLCtrlIDSL.Add(WorkingLine + '<BR>');
    inc(idx);
  end;
  FDefTextWithHTMLCtrlIDs := DefTextWithHTMLCtrlIDSL.Text;
  FDefTextWithHTMLCtrlIDs := StringReplace(FDefTextWithHTMLCtrlIDs, CRLF, '', [rfReplaceAll]);
  PseudoHTMLSource.Add('</DIALOG>');

  Attrs := TStringList.Create;
  Attrs.Add('class="' + EMBEDDED_DLG_SOURCE_CLASS + ' ' + HIDDEN_CLASS + '"');
  Attrs.Add('id="'+ FTMGDlgID + EMBEDDED_SOURCE_SUFFIX+'"');  //NOTE: if [ID]_result below is changed, must also change THTMLTemplateDialogEntry.ResolveIntoResultSPAN
  //TempHTMLSL.Text := EncodeTextToSafeHTMLAttribVal(FDefTextWithHTMLCtrlIDs);
  TempHTMLSL.Text := EncodeTextToSafeHTMLAttribVal(DefinitionText); //kt 6/6/16
  AddElement('SPAN', Attrs, TempHTMLSL, PseudoHTMLSource);
  PseudoHTMLSource.Add('</div>');  //this is closer for entire embedded dialog
  TempHTMLSL.Free;
  DefTextWithHTMLCtrlIDSL.Free;
end;

procedure THTMLTemplateDialogEntry.CombineScriptCode(OrigSource : TStringList; SrcB: string);
begin
  //TO DO!!!  Finish!!  Change this function!!
  //Check OrigSource for functions in SrcB, and don't add them twice.
  if SrcB <> '' then begin
    OrigSource.Add(' ');
    OrigSource.Text := OrigSource.Text + SrcB;
  end;
end;

function THTMLTemplateDialogEntry.IENOfTemplateFieldType(FldName : string) : string;
var Temp : THTMLTemplateFieldType;
begin
  Temp := GetHTMLTemplateFieldType(FldName, False);
  if assigned(Temp) then begin
    Result := Temp.IEN;
  end else begin
    Result := '0';
  end;
end;

function THTMLTemplateDialogEntry.ParseDefText(DefinitionText: string;
                                               CumulativeStyleCodes, CumulativeScriptCode: TStringList) : string;
//Result is a block of HTML code, ready for insertion into FWebBrowser's DOM
//Also, Self.FHTML contains HTML of template
var
  TMGDebugEditLines : boolean;
begin
  if pos(NO_FORMATTED_ANSWERS, DefinitionText)>0 then begin
    FLocalAnswerOpenTag := '';
    FLocalAnswerCloseTag := '';
  end else begin
    FLocalAnswerOpenTag := FHTMLTemplateDocument.HTMLAnswerOpenTag;
    FLocalAnswerCloseTag := FHTMLTemplateDocument.HTMLAnswerCloseTag;
  end;
  ParseToPseudoHTML(DefinitionText, FPseudoHTMLSource);
  TMGDebugEditLines := false;
  if TMGDebugEditLines = true then EditSL(FPseudoHTMLSource);   //kt 4/16
  //The cumulative script code is ADDED to the document, so it should be just code for
  //  this one object, not all objects that have been added so far --> will clear arrays below
  CumulativeStyleCodes.Clear; CumulativeScriptCode.Clear;
  AddFromPseudoHTML(FPseudoHTMLSource, CumulativeStyleCodes, CumulativeScriptCode); //output put into FHTML
  if FUsesGetCtrlVal then AddGetCtrlValCode(CumulativeScriptCode);
  if FUsesSetCtrlVal then AddSetCtrlValCode(CumulativeScriptCode);
  if FUsesGetDlgHandle then AddGetDlgHandleCode(CumulativeScriptCode);
  if FHasHandleOnInsert then CumulativeScriptCode.Add(HANDLE_ON_INSERT+'_'+FTMGDlgID+'("'+FTMGDlgID+'");');  //executed upon insertion into DOM
  if FDefinitionScriptText <> '' then CombineScriptCode(CumulativeScriptCode, FDefinitionScriptText);
  if TMGDebugEditLines = true then EditSL(CumulativeScriptCode);   //kt 4/16
  if TMGDebugEditLines = true then EditSL(FHTML);   //kt 4/16
  Result := uHTMLDlgObjs.SLStr(FHTML);
end;

procedure THTMLTemplateDialogEntry.AddFromPseudoHTML(Source: TStringList;
                                                     CumulativeStyleCodes,
                                                     CumulativeScriptCode: TStringList;
                                                     EnableCBName : string='');
(* Input: Source:  -- Format:
    <CHECKBOX: checkedvalue="something" uncheckedvalue="something else">Display Text</CHECKBOX>
    <EDITBOX: width="width value">initial text goes here</EDITBOX>
    <WPBOX: cols="width value" rows="height value">Initial text goes here</WPBOX>
  Result: 1^OK, or -1^Error Message      *)
var
  OneSource,Content, Attrs : TStringList;
  s, s1, s2, Id            : string;
  StartTag, EndTag         : string;
  i, PosNum                : integer;
  TagFound                 : boolean;
  HTMLObjFactory           : THTMLObjHandler;
begin
  //Result := '1^OK';
  OneSource := TStringList.Create;
  Content := TStringList.Create;
  Attrs := TStringList.Create;
  i := 0;
  while i < Source.Count do begin
    s := Source.Strings[i];
    TagFound := false;
    if FObjHandlersList.HasHTMLObjTag(s, HTMLObjFactory) then begin
      StartTag := HTMLObjFactory.StartTag;
      EndTag := HTMLObjFactory.EndTag;
      PosNum := Pos(StartTag, s);
      if (PosNum > 1) then begin
        s1 := ORFn.piece2(s, StartTag, 1);
        s2 := MidStr(s, Length(s1)+1, Length(s));
        s1 := StringReplace(s1, CRLF, '',  [rfReplaceAll]);
        FHTML.Add(s1);
        ParsedSource.Add(s1);
        s := s2; PosNum := 1; Source.Strings[i] := s;
      end;
      if PosNum > 0 then begin
        TagFound := true;
        OneSource.Clear;
        GetOneSource(Source, EndTag, i, Onesource);
        ExtractContent(StartTag, EndTag, OneSource, Content);
        ExtractAttribs(StartTag, OneSource, Attrs);
        if EnableCBName <> '' then begin  //If control is in container, it is disabled by default.
          EnsureClass(Attrs,EnableCBName);
          EnsureClass(Attrs,'TMGDisabledControl');
          Attrs.Add('disabled');
        end;
        HTMLObjFactory.AddProc(Self, OneSource, Attrs, FHTML, Content, CumulativeScriptCode, CumulativeStyleCodes, Id);
        ParsedSource.Add('<TMGHTMLOBJ id="'+Id+'">');
        //kt 6/16 --> FHTMLTemplateDocument.ParsedIDList.Add(Id+'='+StartTag);
        ParsedIDList.Add(Id+'='+StartTag);  //kt 6/16
      end;
    end;
    if not TagFound then begin
      s := StringReplace(s, CRLF, '',  [rfReplaceAll]);
      FHTML.Add(s);
      ParsedSource.Add(s);
    end;
    inc(i);
  end;
  Content.Free;
  OneSource.Free;
  Attrs.Free;
end;

procedure THTMLTemplateDialogEntry.GetOneSource(Source : TStringList; EndTag: string; var i : integer; Output : TStringList);
var s,s2 : string;
    Done : boolean;
begin
  Done := false;
  while (i < Source.Count) and (Done = false)  do begin
    s := Source.Strings[i];
    if Pos(EndTag, s) > 0 then begin
      s := ORFn.piece2(s, EndTag, 1) + EndTag;  //If s has code after EndTag, s will have that cut off
      s2 := MidStr(Source.Strings[i], Length(s)+1, Length(Source.Strings[i]));
      if s2 <> '' then begin
        Source.Strings[i] := s2;
        dec(i); //counteract later inc
      end;
      done := true;
    end;
    Output.Add(s);
    if not done then inc(i);
  end;
end;

procedure THTMLTemplateDialogEntry.ExtractContent(StartTag, EndTag : string; Source, Content: TStringList);
var strContent:string;
    p : integer;
begin
  Content.Clear;
  strContent := ORFn.piece2(Source.text, EndTag,1);
  //strContent := ORFn.piece2(strContent,StartTag,2);
  p := Pos('>', strContent);
  strContent := MidStr(strContent, p+1, length(strContent));
  Content.add(strContent);
end;



function THTMLTemplateDialogEntry.GetHTMLControlText(HTMLCtrlID: string;
                                                     NoCommas: boolean;
                                                     var FoundEntry: boolean;
                                                     var ControlDisabled: boolean): string;
begin
  //Result := FHTMLTemplateDocument.GetHTMLControlText(Self, HTMLCtrlID, NoCommas, FoundEntry, ControlDisabled);
  FoundEntry := HasID(HTMLCtrlID);
  result := GetValueByID(HTMLCtrlID, ControlDisabled, NoCommas);
end;

function THTMLTemplateDialogEntry.GetFieldValues: string;
var
  i: integer;
  Value, HTMLCtrlID : string;
  //CtrlID : longint;
  TmpSL: TStringList;
  Dummy: boolean;
  ControlBlockDisabled : boolean;

begin
  Result := '';
  TmpSL := TStringList.Create;
  try
    for i := 0 to HTMLCtrlIDList.Count-1 do begin
      HTMLCtrlID := HTMLCtrlIDList.Strings[i];
      //if LeftStr(HTMLCtrlID, 4) = 'ctrl' then HTMLCtrlID := MidStr(HTMLCtrlID, 5, Length(HTMLCtrlID));
      //CtrlID := StrToIntDef(HTMLCtrlID, 0);
      Value := GetHTMLControlText(HTMLCtrlID, TRUE, Dummy, ControlBlockDisabled);
      if ControlBlockDisabled then break;
      TmpSL.Add(HTMLCtrlID + U + Value);
    end;
    Result := TmpSL.CommaText;
  finally
    TmpSL.Free;
  end;
end;

procedure THTMLTemplateDialogEntry.ForgetFieldType(FieldType : THTMLTemplateFieldType);
begin
  FListOfTemplateFieldTypes.Remove(FieldType);
end;

function THTMLTemplateDialogEntry.GetNewTemplateFieldID : longint;
//NOTICE: these ID's are only unique within this one DialogEntry.  But they can be combined
//        with the DialogEntries's own ID, which is unique amoung the entire document.
begin
  inc(FFieldIDCnt);
  Result := FFieldIDCnt;
  //Result := FHTMLTemplateDocument.GetNewTemplateFieldID;
end;

{
function THTMLTemplateDialogEntry.GetHTMLText: string;
//kt added 2/20/16
begin
  Result := ResolveHTMLTemplateFields(FDefinitionText, FALSE);
end;
}

procedure THTMLTemplateDialogEntry.SetControlText(CtrlID: integer; AText: string);
{
var
  cnt, i, j: integer;
  Ctrl: TControl;
  Done: boolean;
}

begin
  //kt note: I don't have a good way to do what this function originally did.
  //I'll have to see if/how it is needed
{
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

  end;
  }
end;

procedure THTMLTemplateDialogEntry.SetFieldValues(const Value: string);
var
  i: integer;
  TmpSL: TStringList;

begin
  FFieldValues := Value;
  TmpSL := TStringList.Create;
  try
    TmpSL.CommaText := Value;
    for i := 0 to TmpSL.Count-1 do
      //kt NOTE: the line below currently just returns without doing anything....
      SetControlText(StrToIntDef(Piece(TmpSL[i], U, 1), 0), Piece(TmpSL[i], U, 2));
  finally
    TmpSL.Free;
  end;
end;

function THTMLTemplateDialogEntry.GetHTMLTemplateFieldType(ATemplateField: string; ByIEN: boolean): THTMLTemplateFieldType;
var
  i, idx: integer;
  AData: TStrings;

begin
  Result := nil;
  idx := -1;
  for i := 0 to FListOfTemplateFieldTypes.Count-1 do begin
    if(ByIEN) then begin
      if(THTMLTemplateFieldType(FListOfTemplateFieldTypes[i]).FID = ATemplateField) then begin
        idx := i;
        break;
      end;
    end else begin
      if(THTMLTemplateFieldType(FListOfTemplateFieldTypes[i]).FFldName = ATemplateField) then begin
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
    if(AData.Count > 1) then begin
      Result := THTMLTemplateFieldType.Create(Self, AData);
      FListOfTemplateFieldTypes.Add(Result);
    end;
  end else begin
    Result := THTMLTemplateFieldType(FListOfTemplateFieldTypes[idx]);
  end;  
end;

procedure THTMLTemplateDialogEntry.ClearModifiedTemplateFields;
var  i: integer;
     Fld: THTMLTemplateFieldType;
begin
  for i := FListOfTemplateFieldTypes.Count-1 downto 0 do begin
    Fld := THTMLTemplateFieldType(FListOfTemplateFieldTypes[i]);
    if(assigned(Fld)) and (Fld.FModified) then begin
      if Fld.FLocked then
        UnlockTemplateField(Fld.FID);
      Fld.Free;
      FListOfTemplateFieldTypes.Delete(i);  //kt added.  Why was this absent before ??
    end;
  end;
end;

procedure THTMLTemplateDialogEntry.ClearTemplateFields;
var  i: integer;
begin
  for i := FListOfTemplateFieldTypes.Count-1 downto 0 do begin
    THTMLTemplateFieldType(FListOfTemplateFieldTypes[i]).Free;
  end;
  FListOfTemplateFieldTypes.clear;
end;

{
function THTMLTemplateDialogEntry.ResolveHTMLTemplateFields(Text: string;
                                                            AutoWrap: boolean;
                                                            Hidden: boolean = FALSE;
                                                            IncludeEmbedded: boolean = FALSE;
                                                            HTMLTargetMode : boolean = FALSE;  //TRUE if template text is to be put into HTML document
                                                            HTMLAnswerOpenTag : string = '';
                                                            HTMLAnswerCloseTag : string = ''
                                                            ): string;
var
  CtrlIDStr : string;
  CtrlID  : integer;
  iField, Fld: string;
  NewHTMLTxt : string;
  p1, p2 : integer;
  FoundEntry: boolean;
  FoundHTMLEntry: boolean;
  TmplFld: THTMLTemplateField;
  ControlBlockDisabled : boolean;

begin
  Result := '';
  ControlBlockDisabled := false;
  while not ControlBlockDisabled and (Length(Text) > 0) do begin
    p1  := pos(TemplateFieldBeginSignature, Text);
    p2  := pos(TemplateFieldEndSignature, Text);
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
    if IncludeEmbedded then iField := Fld else iField := '';
    NewHTMLTxt := GetHTMLControlText(CtrlID, FALSE, FoundHTMLEntry, ControlBlockDisabled, iField);  //kt added 1/16
    if ControlBlockDisabled then begin
      Result := '';
      break;
    end;
    if (HTMLTargetMode=true) and (NewHTMLTxt <> '') then begin
      NewHTMLTxt := HTMLAnswerOpenTag + NewHTMLTxt + HTMLAnswerCloseTag;
    end;
    TmplFld := GetHTMLTemplateField(Fld, FALSE);
    if (FoundEntry) and (assigned(TmplFld)) and (TmplFld.FFldType<>dftText)
      and (TmplFld.FFldType<>dftHyperlink) then uCarePlan.CheckWrapForCPResult(NewHTMLTxt);
    Result := Result + NewHTMLTxt;
    if FoundHTMLEntry then break;
    if Hidden and (not FoundEntry) and (Fld <> '') then begin
      NewHTMLTxt := TemplateFieldBeginSignature + Fld + TemplateFieldEndSignature;
      Result := Result + NewHTMLTxt;
    end;
  end;
//  if Result <> '' then
//restore later -->     Result := ResolveTemplateFieldsMath(Result,FEntries,AutoWrap,IncludeEmbedded); //kt-tm
end;
}

function THTMLTemplateDialogEntry.ResolveIntoResultSPAN(DBControlData : TDBControlData)  : string;
//puts resolved form of dialg into result SPAN and ALSO returns a string of text.
var
  idx, PosStartTag, PosPastStartTag, PosEndTag, PosPastEndTag, flen: integer;
  TempSL: TStringList;
  Str, StrA, StrB, CtrlValue, Info, FldName, HTMLCtrlID : string;
  FoundEntry, NoCommas, ControlBlockDisabled: boolean;
  ResultSPANID : string;
  HTMLTemplateFieldType : THTMLTemplateFieldType;

begin
  TempSL := TStringList.Create;
  TempSL.Text := FDefTextWithHTMLCtrlIDs;
  NoCommas :=  false;  //should be able to pass in... fix later.
  ControlBlockDisabled := false;
  idx := 0;
  while (idx < TempSL.Count) and not ControlBlockDisabled do begin
    Str := TempSL[idx];
    PosStartTag := 1;
    StrA := '';
    repeat
      PosStartTag := PosEx(HTML_CTRL_TAG, Str, PosStartTag);
      if PosStartTag = 0 then break;
      PosPastStartTag := PosStartTag + length(HTML_CTRL_TAG);  //move i to right after field start sig
      StrA := MidStr(Str, 1, PosStartTag-1);
      PosEndTag := PosEx(HTML_CTRL_END_TAG, Str, PosPastStartTag);
      if(PosEndTag > 0) then begin
        PosPastEndTag := PosEndTag + length(HTML_CTRL_END_TAG);
        StrB := MidStr(Str, PosPastEndTag, length(Str));
        flen := PosEndTag - PosPastStartTag;
        Info := MidStr(Str, PosPastStartTag, flen);
        HTMLCtrlID := piece(Info, '^', 1);
        FldName := piece(Info, '^', 2);
        CtrlValue := GetHTMLControlText(HTMLCtrlID, NoCommas, FoundEntry, ControlBlockDisabled);
        if ControlBlockDisabled then begin
          TempSL.clear;
          break;
        end;
        HTMLTemplateFieldType := GetHTMLTemplateFieldType(FldName, False);
        //if HTMLTemplateFieldType.IsDBControl then begin
        if HTMLTemplateFieldType.IsDBControl_Writer then begin
          DBControlData.AddValue(HTMLTemplateFieldType.IEN, CtrlValue); //store DB control's data, to be written out later
        end;
        if CtrlValue <> '' then begin
          CtrlValue := FLocalAnswerOpenTag + CtrlValue + FLocalAnswerCloseTag;    //set up during initial parse of def.
        end;
        Str := StrA + CtrlValue + StrB;
      end else begin
        StrB := MidStr(Str, PosPastStartTag, length(Str));
        PosStartTag := 1;
        Str := StrA + StrB;
      end;
      TempSL[idx] := Str;
    until (PosStartTag=0) or ControlBlockDisabled;
    inc(idx);
  end;
  Result := TempSL.Text;
  Result := FixHTMLCRLF(Result);
  TempSL.Free;
  ResultSPANID := FTMGDlgID+EMBEDDED_RESULT_SUFFIX;  //NOTE: the [ID]_result is setup in uHTMLDlgObjs.AddDialogGrp
  //NOTE: if the _result SPAN has been deleted, then the resuls are NOT stored.
  FHTMLTemplateDocument.WebBrowser.SetInnerHTMLByID(ResultSPANID, Result);
end;


procedure THTMLTemplateDialogEntry.SetDisplayMode(Mode : tDialogDisplayMode);
var ModeMsg : string;
begin
{  e.g.
<SPAN class=tmgembeddeddlg id=TMGDlg1 contentEditable=false IEN="16376">Number 1: <INPUT id=ctrl1_TMGDlg1 onkeydown=checkKey(this) onkeyup=handleNumKeyup(this) tmgvalue="" step="1" max="10" min="0"></INPUT><BUTTON class="" onclick="altNumValue('ctrl1_TMGDlg1', '+')">&#8593;</BUTTON><BUTTON class="" onclick="altNumValue('ctrl1_TMGDlg1', '-')">&#8595;</BUTTON> <BR>Number 2: <INPUT id=ctrl2_TMGDlg1 onkeydown=checkKey(this) onkeyup=handleNumKeyup(this) tmgvalue="" step="1" max="10" min="0"></INPUT><BUTTON class="" onclick="altNumValue('ctrl2_TMGDlg1', '+')">&#8593;</BUTTON><BUTTON class="" onclick="altNumValue('ctrl2_TMGDlg1', '-')">&#8595;</BUTTON> <BR></SPAN>
<SPAN class="tmgembeddeddlg_result tmghidden" id=TMGDlg1_result IEN="16376">Number 1: Number 2: </SPAN>
}
  ModeMsg := IntToStr(Ord(Mode));
  FHTMLTemplateDocument.WebBrowser.IterateElements(IterateCallBackForMode, ModeMsg, Nil);
end;

procedure THTMLTemplateDialogEntry.IterateCallBackForMode(Elem : IHTMLElement; Msg : string; Obj : TObject; var Stop : boolean);
//this function gets called once for every element in the HTML DOM.  Can modify Stop to stop iteration
var ModeOrd : integer;
    Mode : tDialogDisplayMode;
    ElemID, ResultSPANID : string;
begin
  ElemID := Elem.ID;
  ResultSPANID := FTMGDlgID+ '_result';  //NOTE: the [ID]_result is setup in uHTMLDlgObjs.AddDialogGrp
  if (ElemID <> FTMGDlgID) and (ElemID <> ResultSPANID) then exit;
  if HTMLElement_PropertyValue(Elem, 'IEN') <> FTemplateIEN then exit;
  ModeOrd := StrToIntDef(Msg, 0);
  Mode := tDialogDisplayMode(ModeOrd);
  if HTMLElement_HasClassName(Elem, EMBEDDED_DLG_RESULT_CLASS) then begin
    if Mode = tdmEdit then begin
      HTMLElement_EnsureHasClassName(Elem, HIDDEN_CLASS);  //add hidden class
    end else if Mode = tdmResolved then begin
      HTMLElement_RemoveClassName(Elem, HIDDEN_CLASS);  //remove hidden class
    end;
  end else if HTMLElement_HasClassName(Elem, EMBEDDED_DLG_CLASS) then begin
    if Mode = tdmEdit then begin
      HTMLElement_RemoveClassName(Elem, HIDDEN_CLASS);  //remove hidden class
    end else if Mode = tdmResolved then begin
      HTMLElement_EnsureHasClassName(Elem, HIDDEN_CLASS);  //add hidden class
    end;
  end;
end;

function THTMLTemplateDialogEntry.SaveTemplateFieldErrors: string;
var
  i: integer;
  Errors: TStringList;
  Fld: THTMLTemplateFieldType;
  msg: string;

begin
  Result := '';
  Errors := nil;
  try
    for i := 0 to FListOfTemplateFieldTypes.Count-1 do begin
      Fld := THTMLTemplateFieldType(FListOfTemplateFieldTypes[i]);
      if(Fld.FModified) then begin
        msg := Fld.SaveError;
        if(msg <> '') then begin
          if(not assigned(Errors)) then begin
            Errors := TStringList.Create;
            Errors.Add('The following template field save errors have occurred:');
            Errors.Add('');
          end;
          Errors.Add('  ' + Fld.FldName + ': ' + msg);
        end;
      end;
    end;
  finally
    if(assigned(Errors)) then begin
      Result := Errors.Text;
      Errors.Free;
    end;
  end;
end;

function THTMLTemplateDialogEntry.AnyTemplateFieldsModified: boolean;
var
  i: integer;

begin
  Result := FALSE;
  if(assigned(FListOfTemplateFieldTypes)) then begin
    for i := 0 to FListOfTemplateFieldTypes.Count-1 do begin
      if (THTMLTemplateFieldType(FListOfTemplateFieldTypes[i]).FModified) then begin
        Result := TRUE;
        break;
      end;
    end;
  end;
end;

procedure THTMLTemplateDialogEntry.ListTemplateFields(const AText: string; AList: TStrings; ListErrors: boolean = FALSE);
var
  i, j, k, flen, BadCount: integer;
  flddesc, tmp, fld: string;
  TmpList: TStringList;
  InactiveList: TStringList;
  AFldTypeObj: THTMLTemplateFieldType;

begin
  if(AText = '') then exit;
  BadCount := 0;
  InactiveList := TStringList.Create;
  try
    TmpList := TStringList.Create;
    try
      TmpList.Text := AText;
      for k := 0 to TmpList.Count-1 do begin
        tmp := TmpList[k];
        repeat
          i := pos(TemplateFieldBeginSignature, tmp);
          if(i > 0) then begin
            fld := '';
            j := pos(TemplateFieldEndSignature, copy(tmp, i + TemplateFieldSignatureLen, MaxInt));
            if(j > 0) then begin
              inc(j, i + TemplateFieldSignatureLen - 1);
              flen := j - i - TemplateFieldSignatureLen;
              fld := copy(tmp,i + TemplateFieldSignatureLen, flen);
              delete(tmp, i, flen + TemplateFieldSignatureLen + 1);
            end else begin
              delete(tmp,i,TemplateFieldSignatureLen);
              inc(BadCount);
            end;
            if(fld <> '') then begin
              if ListErrors then begin
                AFldTypeObj := GetHTMLTemplateFieldType(fld, FALSE);
                if assigned(AFldTypeObj) then begin
                  if AFldTypeObj.Inactive then
                    InactiveList.Add('  "' + fld + '"');
                  flddesc := '';
                end else
                  flddesc := '  "' + fld + '"';
              end else
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
    if ListErrors then begin
      if(AList.Count > 0) then
        AList.Insert(0, 'The following template fields were not found:');
      if (BadCount > 0) then begin
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
      if(InactiveList.Count > 0) then begin
        if(AList.Count > 0) then
          AList.Add('');
        AList.Add('The following inactive template fields were found:');
        FastAddStrings(InactiveList, AList);
      end;
      if(AList.Count > 0) then begin
        AList.Insert(0, 'Text contains template field errors:');
        AList.Insert(1, '');
      end;
    end;
  finally
    InactiveList.Free;
  end;
end;


function THTMLTemplateDialogEntry.BoilerplateTemplateFieldsOK(const AText: string; Msg: string = ''): boolean;
var
  Errors: TStringList;
  btns: TMsgDlgButtons;

begin
  Result := TRUE;
  Errors := TStringList.Create;
  try
    ListTemplateFields(AText, Errors, TRUE);
    if(Errors.Count > 0) then begin
      if(Msg = 'OK') then btns := [mbOK]
      else begin
        btns := [mbAbort, mbIgnore];
        Errors.Add('');
        if(Msg = '') then Msg := 'text insertion';
        Errors.Add('Do you want to Abort ' + Msg + ', or Ignore the error and continue?');
      end;
      Result := (MessageDlg(Errors.Text, mtError, btns, 0) = mrIgnore);
    end;
  finally
    Errors.Free;
  end;
end;


function THTMLTemplateDialogEntry.AreTemplateFieldsRequired(const Text: string; FldValues: TORStringList =  nil): boolean;
//var
  //flen, CtrlID, i, j: integer;
  //Entry: TTemplateDialogEntry;
  //Fld: THTMLTemplateField;
  //Temp, NewTxt, FldName: string;

begin
  //Temp := Text;
  Result := FALSE;
  //kt -- later consider implementing this if even possible with HTML controls
  {
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
        Fld := GetHTMLTemplateField(FldName, FALSE);
        delete(Temp,i,flen + TemplateFieldSignatureLen + 1);
      end else begin
        delete(Temp,i,TemplateFieldSignatureLen);
        Fld := nil;
      end;
      if(CtrlID > 0) and (assigned(Fld)) and (Fld.Required) then begin
        NewTxt := Entry.GetControlText(CtrlID, TRUE, FoundEntry, FALSE);
        if FoundEntry and (NewTxt = '') then begin //(Trim(NewTxt) = '') then //CODE ADDED BACK IN - ZZZZZZBELLC
          Result := TRUE;
        end;
      end;
    end;
  until ((i = 0) or Result);
  }
end;

procedure THTMLTemplateDialogEntry.LoadResults;
var i : integer;
    id, StartTag, value : string;
    Disabled : boolean;
begin
  FResultValues.Clear;
  for i := 0 to ParsedIDList.Count - 1 do begin
    id := ParsedIDList.Names[i];
    StartTag := ParsedIDList.ValueFromIndex[i];
    value := FObjHandlersList.GetValue(self, id, StartTag, Disabled);
    FResultValues.Add(value);  //If Disabled, then value should be ''
  end;
end;

procedure THTMLTemplateDialogEntry.AddToCombinedResultValues(CombinedResultValues : TStringList);
var i : integer;
begin
  if not assigned(CombinedResultValues) then exit;
  for i := 0 to FResultValues.Count - 1 do begin
    CombinedResultValues.Add(FResultValues.Strings[i]);
  end;
end;

function THTMLTemplateDialogEntry.HasID(ID : string) : boolean;
var i : integer;
begin
  Result := false;
  ID := UpperCase(ID);
  for i := 0 to ParsedIDList.Count - 1 do begin
    if UpperCase(ParsedIDList.Names[i]) <> ID then continue;
    Result := true;
    break;
  end;
end;

function THTMLTemplateDialogEntry.GetValueByID(ID : string; var Disabled : boolean; NoCommas : boolean = false) : string;
//RefreshResults/LoadResults does NOT need to be called first.
var i : integer;
    AnID, StartTag : string;
begin
  Result := '';
  FResultValues.Clear;
  ID := UpperCase(ID);
  Disabled := false;
  for i := 0 to ParsedIDList.Count - 1 do begin
    AnID := UpperCase(ParsedIDList.Names[i]);
    if AnID <> ID then continue;
    StartTag := ParsedIDList.ValueFromIndex[i];
    Result := FObjHandlersList.GetValue(self, id, StartTag, Disabled, NoCommas);
    break;
  end;
end;

//***************************************************************************
{THTMLTemplateDocument}
//***************************************************************************
constructor THTMLTemplateDocument.Create(ADialogsManager: THTMLTemplateDialogsMgr; WebBrowser: THtmlObj);
begin
  Inherited Create;
  //FNewTemplateFieldIDCnt := 0;
  FDialogIDCnt := 0;

  FDialogsManager := ADialogsManager;
  FWebBrowser := WebBrowser;
  FDialogList := TStringList.Create;
  FDBControlData := TDBControlData.Create;

  IDIndex := 0;
  FObjHandlersList := THTMLObjHandlersList.Create(WebBrowser);
  //kt 6/16 ParsedIDList := TStringList.Create;
  //kt 6/16 FResultValues := TStringList.Create;
  FCombinedResultValues := TStringList.Create; //kt 6/16
  FCumulativeBodyHTML := TStringList.Create;
  FCumulativeScriptCode := TStringList.Create;
  FCumulativeStyleCodes := TStringList.Create;
  AddGlobalStyle(FCumulativeStyleCodes);
  FIntermediateHTML := TStringList.Create;
  Compiled := False;
end;

destructor THTMLTemplateDocument.Destroy;
begin
  Clear;
  FDialogList.Free;
  FObjHandlersList.Free;
  //kt 6/16 ParsedIDList.Free;
  //kt 6/16 FResultValues.Free;
  FCombinedResultValues.Free; //kt 6/16
  FCumulativeBodyHTML.Free;
  FCumulativeScriptCode.Free;
  FCumulativeStyleCodes.Free;
  FIntermediateHTML.Free;
  FDBControlData.Free;
  Inherited;
end;

procedure THTMLTemplateDocument.Clear;
var i : integer;
    ADialog : THTMLTemplateDialogEntry;
begin
  for i := 0 to FDialogList.Count - 1 do begin
    ADialog := THTMLTemplateDialogEntry(FDialogList.Objects[i]);
    ADialog.Free;
  end;

  //kt 6/16 ParsedIDList.Clear;
  //kt 6/16 FResultValues.Clear;
  FCumulativeBodyHTML.Clear;
  FCumulativeScriptCode.Clear;
  FCumulativeStyleCodes.Clear;
  AddGlobalStyle(FCumulativeStyleCodes);
  FIntermediateHTML.Clear;
  Compiled := False;
  FDBControlData.Clear;
end;

function THTMLTemplateDocument.AddHTMLTemplateDialog(TemplateIEN : string) : THTMLTemplateDialogEntry;
var InstanceID : string;
begin
  //NOTICE: The user can delete the corresponding part of the HTML document.  So just because this
  //        Delphi wrapper exists doesn't ensure that corresponding HTML parts exist in FWebBrowser.
  Inc(FDialogIDCnt);
  InstanceID := DIALOG_TAG + IntToStr(FDialogIDCnt);
  Result := THTMLTemplateDialogEntry.Create(self, InstanceID, TemplateIEN);
  FDialogList.AddObject(InstanceID, Result);
end;

function THTMLTemplateDocument.GetAnswerOpenTag : string;
begin
  Result := FDialogsManager.HTMLAnswerOpenTag;
end;

function THTMLTemplateDocument.GetAnswerCloseTag : string;
begin
  Result := FDialogsManager.HTMLAnswerCloseTag;
end;

function THTMLTemplateDocument.GetHTMLControlText(HtmlDlg : TObject;
                                                  HTMLCtrlID: string;
                                                  NoCommas: boolean;
                                                  var FoundEntry: boolean;
                                                  var ControlDisabled: boolean): string;
//Note: HtmlDlg should be passed in as type THTMLDlg or THTMLTemplateDialogEntry
begin
  FoundEntry := HasID(HTMLCtrlID);
  result := GetValueByID(HTMlDlg, HTMLCtrlID, ControlDisabled, NoCommas);
end;


{
function THTMLTemplateDocument.GetNewTemplateFieldID : longint;
begin
  inc(FNewTemplateFieldIDCnt);
  Result := FNewTemplateFieldIDCnt;
end;
}

procedure THTMLTemplateDocument.SyncFromHTMLDocument;
//Scan actual HTML document and modify self if parts have been modified.
var InstanceID, InstanceID2, TemplateIEN, s : string;
    DefText, DefTextWithCtrlID : string;
    Elem : IHTMLElement;
    AHTMLTemplateDialogEntry, SourceDlg : THTMLTemplateDialogEntry;
    i, j, k  : integer;
    IDNum : integer;
    DiscardSL1, DiscardSL2 : TStringList;
    FoundDlgsInDOM : TInterfaceListAndTStrings;
begin
  //Scan DOM and look for additions and subtractions.
  try
    FoundDlgsInDOM := TInterfaceListAndTStrings.Create;
    //Get a listing of all the tmgembeddeddlg* elements
    FWebBrowser.IterateElements(IterateCallBackForDocSync, '', FoundDlgsInDOM);  //fills SL.Strings[i] with element id, and .Objects[i] with Elem

    //First look for dialog entries that have been deleted by user from HTML document.
    //    FDialogList : TStringList;  //This owns members.  .Strings[i] = InstanceID (e.g.' TMGDlg3'), .Objects[i] is THTMLTemplateDialogEntry
    for i := FDialogList.Count - 1 downto 0 do begin
      InstanceID := FDialogList.Strings[i];
      if FoundDlgsInDOM.SL.IndexOf(InstanceID) > -1 then continue;
      AHTMLTemplateDialogEntry := THTMLTemplateDialogEntry(FDialogList.Objects[i]);
      FreeAndNil(AHTMLTemplateDialogEntry);  //remove data structure entries that no long exist in the WebBrowser's DOM.
      FDialogList.Delete(i);
    end;

    //Next look for duplicate entries
    //   The user might have copied a dialog, and thus have TWO copies. ...
    for i := 0 to FoundDlgsInDOM.SL.Count - 1 do begin
      InstanceID := FoundDlgsInDOM.SL.Strings[i];
      if Pos(EMBEDDED_RESULT_SUFFIX, InstanceID) > 0 then continue; //skip over e.g. TMGDlg1_result entries.
      if Pos(EMBEDDED_SOURCE_SUFFIX, InstanceID) > 0 then continue; //skip over e.g. TMGDlg1_source entries.
      if Pos(EMBEDDED_STORE_SUFFIX, InstanceID) > 0 then continue; //skip over e.g. TMGDlg1_storage entries.
      for j := i+1 to FoundDlgsInDOM.SL.Count - 1 do begin
        if FoundDlgsInDOM.SL.Strings[i] <> FoundDlgsInDOM.SL.Strings[j] then continue;
        //Here we have two dialogs with duplicate identifiers.
        //Will create a new datastructure (THTMLTemplateDialogEntry) for the 2nd one
        Elem := IHTMLElement(FoundDlgsInDOM.InterfaceList.Items[j]);
        TemplateIEN := HTMLElement_PropertyValue(Elem, 'IEN');
        AHTMLTemplateDialogEntry := AddHTMLTemplateDialog(TemplateIEN);
        InstanceID2 := AHTMLTemplateDialogEntry.TMGDlgID;
        Elem.id := InstanceID2;  //change the id of the 2nd HTML element with duplicate ID to new (unique) id.
        s := Elem.innerHTML;
        s := StringReplace(s, InstanceID, InstanceID2, [rfReplaceAll]);
        Elem.innerHTML := s;
        FoundDlgsInDOM.SL.Strings[j] := InstanceID2;
        k := FDialogList.IndexOf(InstanceID);
        if k > -1  then begin
          SourceDlg := THTMLTemplateDialogEntry(FDialogList.Objects[k]);
          AHTMLTemplateDialogEntry.FDefinitionText := SourceDlg.FDefinitionText;
          s := SourceDlg.FDefTextWithHTMLCtrlIDs;
          s := StringReplace(s, InstanceID, InstanceID2, [rfReplaceAll]);
          AHTMLTemplateDialogEntry.FDefTextWithHTMLCtrlIDs := s
        //FINISH .... need to copy the _source part in the DOM, and change the IDs from ID --> ID2
        end;
        //Now find corresponding _result item, and change the DOM id to match
        for k := j +1 to FoundDlgsInDOM.SL.Count - 1 do begin
          if FoundDlgsInDOM.SL.Strings[k] <> InstanceID + EMBEDDED_RESULT_SUFFIX then continue;
          Elem := IHTMLElement(FoundDlgsInDOM.InterfaceList.Items[k]);
          Elem.id := InstanceID2+EMBEDDED_RESULT_SUFFIX;
          FoundDlgsInDOM.SL.Strings[k] := InstanceID2+EMBEDDED_RESULT_SUFFIX;
          break;
        end;
      end;
    end;

    //Next, look for elements in the DOM for which we have no data structures (THTMLTemplateDialogEntry)
    for i := 0 to FoundDlgsInDOM.SL.Count - 1 do begin
      InstanceID := FoundDlgsInDOM.SL.Strings[i];
      if Pos(EMBEDDED_RESULT_SUFFIX, InstanceID) > 0 then continue; //skip over e.g. TMGDlg1_result entries.
      if Pos(EMBEDDED_SOURCE_SUFFIX, InstanceID) > 0 then continue; //skip over e.g. TMGDlg1_source entries.
      if Pos(EMBEDDED_STORE_SUFFIX, InstanceID) > 0 then continue; //skip over e.g. TMGDlg1_storage entries.
      if FDialogList.IndexOf(InstanceID) > -1  then continue;
      //IDNum := StrToIntDef(MidStr(InstanceID, Length(DIALOG_TAG)+1, length(InstanceID)), 0);
      Elem := IHTMLElement(FoundDlgsInDOM.InterfaceList.Items[i]);
      //Create a new THTMLTemplateDialogEntry entry and add to FDialogList list.
      TemplateIEN := HTMLElement_PropertyValue(Elem, 'IEN');
      AHTMLTemplateDialogEntry := THTMLTemplateDialogEntry.Create(self, InstanceID, TemplateIEN);
      Elem := FWebBrowser.GetElementById(InstanceID+EMBEDDED_SOURCE_SUFFIX);
      if assigned(Elem) then begin
        //DefTextWithCtrlID := Elem.innerHTML;
        //DefTextWithCtrlID := RestoreTextFromEncodedSafeHTMLAttribVal(DefTextWithCtrlID);
        DefText := Elem.innerHTML;
        DefText := RestoreTextFromEncodedSafeHTMLAttribVal(DefText);
        //AHTMLTemplateDialogEntry.FDefTextWithHTMLCtrlIDs := DefTextWithCtrlID;
        if not assigned(DiscardSL1) then DiscardSL1 := TStringList.Create;
        if not assigned(DiscardSL2) then DiscardSL2 := TStringList.Create;
        AHTMLTemplateDialogEntry.ParseDefText(DefText, DiscardSL1, DiscardSL2);
      end;
      FDialogList.AddObject(InstanceID, AHTMLTemplateDialogEntry);
    end;
  finally
    FoundDlgsInDOM.Free;
    DiscardSL1.Free;
    DiscardSL2.Free;
  end;
end;

procedure THTMLTemplateDocument.IterateCallBackForDocSync(Elem : IHTMLElement; Msg : string; Obj : TObject; var Stop : boolean);
//Here Obj is a TInterfaceListAndTStrings
{  e.g.
<SPAN class=tmgembeddeddlg id=TMGDlg1 contentEditable=false IEN="16376">Number 1: <INPUT id=ctrl1_TMGDlg1 onkeydown=checkKey(this) onkeyup=handleNumKeyup(this) tmgvalue="" step="1" max="10" min="0"></INPUT><BUTTON class="" onclick="altNumValue('ctrl1_TMGDlg1', '+')">&#8593;</BUTTON><BUTTON class="" onclick="altNumValue('ctrl1_TMGDlg1', '-')">&#8595;</BUTTON> <BR>Number 2: <INPUT id=ctrl2_TMGDlg1 onkeydown=checkKey(this) onkeyup=handleNumKeyup(this) tmgvalue="" step="1" max="10" min="0"></INPUT><BUTTON class="" onclick="altNumValue('ctrl2_TMGDlg1', '+')">&#8593;</BUTTON><BUTTON class="" onclick="altNumValue('ctrl2_TMGDlg1', '-')">&#8595;</BUTTON> <BR></SPAN>
<SPAN class="tmgembeddeddlg_result tmghidden" id=TMGDlg1_result IEN="16376">Number 1: Number 2: </SPAN>
}
var ElemID, ClassName : string;
    List : TInterfaceListAndTStrings;
begin
  ClassName := Elem.ClassName;
  if Pos(EMBEDDED_DLG_CLASS, ClassName) = 0 then exit;
  ElemID := Elem.ID;
  List := TInterfaceListAndTStrings(Obj);
  List.SL.Add(ElemID);
  List.InterfaceList.Add(Elem)
end;


function THTMLTemplateDocument.HasEmbeddedDialog : boolean;
begin
  SyncFromHTMLDocument;
  Result := (FDialogList.Count > 0);
end;


procedure THTMLTemplateDocument.SetDisplayMode(Mode : tDialogDisplayMode);
//NOTE: SyncFromHTMLDocument() should have been called before calling this.
var i : integer;
    ADialog : THTMLTemplateDialogEntry;
begin
  for i := 0 to FDialogList.Count - 1 do begin
    ADialog := THTMLTemplateDialogEntry(FDialogList.Objects[i]);
    if not Assigned(ADialog) then continue;
    ADialog.SetDisplayMode(Mode);
  end;
end;

function THTMLTemplateDocument.GetHTMLTextInSaveMode(IEN8925 : int64) : string;
//Resolves any embedded dialogs into results SPAN, stores data from any DB Controls
//   to the server, and returns the entire HTMLText with Dialogs Resolved.
//Input: IEN8925 is the IEN of the currently TIU DOCUMENT being edited.
var i : integer;
    ADialog : THTMLTemplateDialogEntry;
    ErrStr, SavedFullHTMLText : string;
    SavedEditable : boolean;
begin
  SyncFromHTMLDocument;
  FDBControlData.Clear;
  for i := 0 to FDialogList.Count - 1 do begin
    ADialog := THTMLTemplateDialogEntry(FDialogList.Objects[i]);
    if not Assigned(ADialog) then continue;
    ADialog.ResolveIntoResultSPAN(FDBControlData);
  end;
  FDBControlData.SaveToServer(IEN8925, ErrStr);
  if ErrStr <> '' then MessageDlg(ErrStr, mtError, [mbOK], 0);
  SavedFullHTMLText := FWebBrowser.GetFullHTMLText;
  SavedEditable := FWebBrowser.Editable;
  SetDisplayMode(tdmResolved);
  FWebBrowser.Editable := false;  //sets ContentEditable=false in <BODY>
  Result := FWebBrowser.GetFullHTMLText;
  FWebBrowser.HTMLText := SavedFullHTMLText;  //restore display modes and ContentEditable to original.
  FWebBrowser.Editable := SavedEditable;
end;

procedure THTMLTemplateDocument.EnsureEditViewMode;
//Show tmgembeddeddlg SPAN's, and hide tmgembeddeddlg_result SPAN's
//NOTE: SyncFromHTMLDocument() should have been called before calling this.
begin
  SetDisplayMode(tdmEdit);
end;

procedure THTMLTemplateDocument.InsertTemplateTextAtSelection(DefinitionText : string; TemplateIEN : string);
var HTMLTemplateDialogEntry :  THTMLTemplateDialogEntry;
    HTMLForInsertion : string;

begin
  HTMLTemplateDialogEntry := AddHTMLTemplateDialog(TemplateIEN);
  HTMLForInsertion := HTMLTemplateDialogEntry.ParseDefText(DefinitionText, FCumulativeStyleCodes, FCumulativeScriptCode);
  FWebBrowser.InsertHTMLAtCaret(HTMLForInsertion);
  FWebBrowser.EnsureStyles(FCumulativeStyleCodes);
  FWebBrowser.EnsureScripts(FCumulativeScriptCode);
  //FWebBrowser.InsertHTMLAtCaret(HTMLForInsertion);  //move up
end;

 //From THTMLDlg -------------

 {
function THTMLTemplateDocument.GetCompletedHTML : TStringList;
begin
  if not Compiled then FinalCompile;
  Result := FFinalHTML;
end;
}

{
function THTMLTemplateDocument.GetPartialHTML : TStringList;
//Returns HTML + script code so far, but no header/footer
begin
  FIntermediateHTML.Clear;
  FIntermediateHTML.Assign(FCumulativeBodyHTML);
  SLAppend(FIntermediateHTML, FCumulativeScriptCode, 'script');
  Result := FIntermediateHTML;
end;

}

procedure THTMLTemplateDocument.AddGlobalStyle(StyleCodes : TStringList);
//Later I could have this style downloaded from server for future modification flexibility.
begin
  (*
  StyleCodes.Add('p.inset {');
  StyleCodes.Add('  border-style: inset;');
  StyleCodes.Add('  border-width: 2px;');
  StyleCodes.Add('  height: 100px;');
  StyleCodes.Add('  background-color: #e5faff;');
  StyleCodes.Add('}');
  *)
  StyleCodes.Add('.selected {');
  StyleCodes.Add('  font-weight : bold;');
  StyleCodes.Add('  //background-color : yellow;');
  StyleCodes.Add('}');
  StyleCodes.Add('.unselected {');
  StyleCodes.Add('  font-weight : normal;');
  StyleCodes.Add('  //background-color : white;');
  StyleCodes.Add('}');
  StyleCodes.Add('');
end;

{
procedure THTMLTemplateDocument.SLAppend(SL, AddOn : TStringList; Tag : string = '');
var i  : integer;
begin
  if AddOn.Count = 0 then exit;
  if Tag <> '' then SL.Add('<'+tag+'>');
  for i := 0 to AddOn.Count - 1 do SL.Add(AddOn.Strings[i]);
  if Tag <> '' then SL.Add('</'+tag+'>');
end;
}


procedure THTMLTemplateDocument.LoadResults;
var i : integer;
    ADialog : THTMLTemplateDialogEntry;
    //id, StartTag, value : string;
    //Disabled : boolean;
begin
  for i := 0 to FDialogList.Count - 1 do begin
    ADialog := THTMLTemplateDialogEntry(FDialogList.Objects[i]);
    if not Assigned(ADialog) then continue;
    ADialog.LoadResults;
  end;
{ //kt 6/16
  FResultValues.Clear;
  for i := 0 to ParsedIDList.Count - 1 do begin
    id := ParsedIDList.Names[i];
    StartTag := ParsedIDList.ValueFromIndex[i];
    value := FObjHandlersList.GetValue(self, id, StartTag, Disabled);
    FResultValues.Add(value);  //If Disabled, then value should be ''
  end;
  }
end;

function THTMLTemplateDocument.HasID(ID : string) : boolean;
var i : integer;
    ADialog : THTMLTemplateDialogEntry;
begin
  Result := false;
  for i := 0 to FDialogList.Count - 1 do begin
    ADialog := THTMLTemplateDialogEntry(FDialogList.Objects[i]);
    if not Assigned(ADialog) then continue;
    Result := Result or ADialog.HasID(ID);
    if Result=true then break;
  end;
{  //kt 6/16
  Result := false;
  ID := UpperCase(ID);
  for i := 0 to ParsedIDList.Count - 1 do begin
    if UpperCase(ParsedIDList.Names[i]) <> ID then continue;
    Result := true;
    break;
  end;
}
end;

function THTMLTemplateDocument.GetValueByID(HtmlDlg : TObject; ID : string; var Disabled : boolean; NoCommas : boolean = false) : string;
//Note: HtmlDlg should be passed in as type THTMLDlg or THTMLTemplateDialogEntry
//RefreshResults/LoadResults does NOT need to be called first.
var i : integer;
    //AnID, StartTag : string;
    ADialog : THTMLTemplateDialogEntry;
begin
  Result := '';
  for i := 0 to FDialogList.Count - 1 do begin
    ADialog := THTMLTemplateDialogEntry(FDialogList.Objects[i]);
    if not Assigned(ADialog) or not ADialog.HasID(ID) then continue;
    Result := ADialog.GetValueByID(ID, Disabled, NoCommas);
    break;
  end;
{ //kt 6/16
  FResultValues.Clear;
  ID := UpperCase(ID);
  Disabled := false;
  for i := 0 to ParsedIDList.Count - 1 do begin
    AnID := UpperCase(ParsedIDList.Names[i]);
    if AnID <> ID then continue;
    StartTag := ParsedIDList.ValueFromIndex[i];
    Result := FObjHandlersList.GetValue(HtmlDlg, id, StartTag, Disabled, NoCommas);
    break;
  end;
}
end;

procedure THTMLTemplateDocument.RefreshResults;
begin
  LoadResults;
end;

{
function THTMLTemplateDocument.GetValue(Index : integer) : string;
begin
  If FResultValues.count = 0 then LoadResults;
  if (Index >=0) and (Index < FResultValues.Count) then begin
    Result := FResultValues.Strings[Index];
  end else begin
    Result := '';
  end;
end;
}

function THTMLTemplateDocument.GetResultValues : TStringList;
var i : integer;
    ADialog : THTMLTemplateDialogEntry;
begin
  RefreshResults;
  FCombinedResultValues.Clear;
  Result := FCombinedResultValues;
  for i := 0 to FDialogList.Count - 1 do begin
    ADialog := THTMLTemplateDialogEntry(FDialogList.Objects[i]);
    if not Assigned(ADialog) then continue;
    ADialog.AddToCombinedResultValues(FCombinedResultValues);
  end;
end;

 //End From THTMLDlg -------------

//***************************************************************************
{THTMLTemplateDialogsMgr}
//***************************************************************************

constructor THTMLTemplateDialogsMgr.Create;
begin
  inherited Create;
  FInit := false;
  FHTMLDocList := TList.Create;
end;

destructor THTMLTemplateDialogsMgr.Destroy;
begin
 Clear;
 FHTMLDocList.Free;
 inherited Destroy;
end;

procedure THTMLTemplateDialogsMgr.Init;
begin
  if AtIntracareLoc() then begin
    SetHTMLAnswerOpenCloseTags('<B><I><font size="+1" face="Arial">', '</B></I></font>');
  end else begin
    SetHTMLAnswerOpenCloseTags('<B><I>', '</B></I>');
  end;
  FInit := true;
end;

procedure THTMLTemplateDialogsMgr.Clear;
var i : integer;
begin
  for i := 0 to FHTMLDocList.Count - 1 do begin
    THTMLTemplateDocument(FHTMLDocList[i]).Free;
  end;
  FHTMLDocList.Clear;
  FAnswerOpenTag := '';
  FAnswerCloseTag :='';
end;


function THTMLTemplateDialogsMgr.AddHTMLDoc(AWebBrowser: THtmlObj) : THTMLTemplateDocument;
var AHTMLDoc : THTMLTemplateDocument;
begin
  AHTMLDoc := THTMLTemplateDocument.Create(self, AWebBrowser);
  FHTMLDocList.Add(AHTMLDoc);
  Result := AHTMLDoc;
end;

function THTMLTemplateDialogsMgr.GetHTMLDoc(AWebBrowser: THtmlObj) : THTMLTemplateDocument;  //returns nil if not already added.
var i : integer;
    AHTMLDoc : THTMLTemplateDocument;
begin
  Result := nil;
  for i := 0 to FHTMLDocList.Count - 1 do begin
    AHTMLDoc := THTMLTemplateDocument(FHTMLDocList[i]);
    if AHTMLDoc.WebBrowser <> AWebBrowser then continue;
    Result := AHTMLDoc;
    break;
  end;
end;

function THTMLTemplateDialogsMgr.EnsureHTMLDocAdded(AWebBrowser: THtmlObj) : THTMLTemplateDocument;
begin
  if not FInit then Init;
  Result := GetHTMLdoc(AWebBrowser);
  if not assigned(Result) then Result := AddHTMLDoc(AWebBrowser);
  Result.SyncFromHTMLDocument;
end;

procedure THTMLTemplateDialogsMgr.InsertTemplateTextAtSelection(AWebBrowser: THtmlObj; DefinitionText : string; TemplateIEN : string);
var  AHTMLDoc : THTMLTemplateDocument;
begin
  AHTMLDoc := EnsureHTMLDocAdded(AWebBrowser);
  AHTMLDoc.InsertTemplateTextAtSelection(DefinitionText, TemplateIEN);
end;

procedure THTMLTemplateDialogsMgr.RemoveWebBrowser(AWebBrowser: THtmlObj);
var  AHTMLDoc : THTMLTemplateDocument;
     i : integer;
begin
  AHTMLDoc := GetHTMLdoc(AWebBrowser);
  if not assigned(AHTMLDoc) then exit;
  for i := FHTMLDocList.Count - 1 downto 0 do begin
    if FHTMLDocList[i] <> AHTMLDoc then continue;
    FHTMLDocList.Delete(i);
  end;
  AHTMLDoc.Free;
end;

procedure THTMLTemplateDialogsMgr.ClearWebBrowser(AWebBrowser: THtmlObj);
begin
  if not assigned(AWebBrowser) then exit;
  AWebBrowser.HTMLText := BlankHTMLDoc;
  SyncFromHTMLDocument(AWebBrowser);
end;

function THTMLTemplateDialogsMgr.HasEmbeddedDialog(AWebBrowser: THtmlObj) : boolean;
var HTMLTemplateDoc : THTMLTemplateDocument;
begin
  Result := false;
  HTMLTemplateDoc := GetHTMLDoc(AWebBrowser);
  if HTMLTemplateDoc = nil then exit;
  Result := HTMLTemplateDoc.HasEmbeddedDialog;
end;

procedure THTMLTemplateDialogsMgr.SyncFromHTMLDocument(AWebBrowser: THtmlObj);
//Scan actual HTML document and modify self if parts have been modified.
var HTMLTemplateDoc : THTMLTemplateDocument;
begin
  HTMLTemplateDoc := EnsureHTMLDocAdded(AWebBrowser); //calls SyncFromHTMLDocument;
end;

procedure THTMLTemplateDialogsMgr.EnsureEditViewMode(AWebBrowser: THtmlObj);
var HTMLTemplateDoc : THTMLTemplateDocument;
begin
  HTMLTemplateDoc := EnsureHTMLDocAdded(AWebBrowser); //calls SyncFromHTMLDocument;
  HTMLTemplateDoc.EnsureEditViewMode;
end;

function THTMLTemplateDialogsMgr.GetHTMLTextInSaveMode(AWebBrowser: THtmlObj; IEN8925 : Int64) : string;
//Resolves any embedded dialogs into results SPAN, returning entire HTMLText with Dialogs Resolved.
//Input: IEN8925 is the IEN of the currently TIU DOCUMENT being edited.
var HTMLTemplateDoc : THTMLTemplateDocument;
begin
  Result := '';
  HTMLTemplateDoc := GetHTMLDoc(AWebBrowser);
  if  HTMLTemplateDoc = nil then exit;
  Result := HTMLTemplateDoc.GetHTMLTextInSaveMode(IEN8925);
end;

procedure THTMLTemplateDialogsMgr.SetHTMLAnswerOpenCloseTags(OpenHTML, CloseHTML : string);
begin
  FAnswerOpenTag := OpenHTML;
  FAnswerCloseTag := CloseHTML;
end;


{
function THTMLTemplateDialogsMgr.GetDialogEntry(AParent: TWinControl; AID, AText: string): THTMLTemplateDialogEntry;
var idx: integer;
begin
  Result := nil;
  if AID = '' then exit;
  idx := FEntries.IndexOf(AID);
  if(idx < 0) then begin
    //Below parses Text into FHTMLControls
    Result := THTMLTemplateDialogEntry.Create(Self, AParent, AID, AText);
    FEntries.AddObject(AID, Result);
  end else begin
    Result := THTMLTemplateDialogEntry(FEntries.Objects[idx]);
  end;
end;

function THTMLTemplateDialogsMgr.GetNewFieldID: string;
begin
  inc(FieldIDCount);
  Result := IntToStr(FieldIDCount);
  Result := FieldIDDelim +
            copy(StringOfChar('0', FieldIDLen-2) + Result, length(Result), FieldIDLen-1);
end;

procedure THTMLTemplateDialogsMgr.FreeEntries(SL: TStrings);
var
  i, idx, cnt: integer;

begin
  for i := SL.Count-1 downto 0 do begin
    idx := FEntries.IndexOf(SL[i]);
    if(idx >= 0) then begin
      cnt := FEntries.Count;
      if(assigned(FEntries.Objects[idx])) then begin
        FEntries.Objects[idx].Free;
      end;
      if cnt = FEntries.Count then begin
        FEntries.Delete(idx);
      end;
    end;
  end;
  if(FEntries.Count = 0) then begin
    FieldIDCount := 0;
    FFormulaCount := 0;  //kt-tm
    FTxtObjCount  := 0;  //kt-tm
    FVarObjCount  := 0;  //kt-tm
  end;
end;

procedure THTMLTemplateDialogsMgr.AssignFieldIDs(var Txt: string; NameToObjID : TStringList);
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
          NameToObjID.AddObject(FldName,Pointer(FieldIDCount)); //kt-tm
        end;                                                             //kt-tm
      end;
    end;
  end;
end;

procedure THTMLTemplateDialogsMgr.AssignFieldIDs(SL: TStrings; NameToObjID : TStringList);
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

}

//***************************************************************************
//***************************************************************************
initialization
  GLOBAL_HTMLTemplateDialogsMgr := THTMLTemplateDialogsMgr.Create;

finalization
  GLOBAL_HTMLTemplateDialogsMgr.Free;
end.

