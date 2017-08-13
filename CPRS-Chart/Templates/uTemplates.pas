unit uTemplates;
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


{$O-}

interface
uses
  Classes, Controls, SysUtils, Forms, ORFn, ORNet, Dialogs, MSXML_TLB, uTIU, uDCSumm, Variants,
  ComCtrls, ORCtrls, StrUtils  //kt added
  ;

type
  TTemplateType = (ttNone, ttMyRoot, ttRoot, ttTitles, ttConsults, ttProcedures,
                   //ttTMGProbList,   //kt 5/15
                   ttClass, ttDoc, ttGroup, ttDocEx, ttGroupEx
                   );
  TTemplateLinkTypes = ttTitles..ttProcedures;

  TcpteMode = (cptemNormal, cptemLetter, cptemCarePlan);  //kt
var
  VEFATemplateMode : TcpteMode = cptemNormal;  //kt
  VEFAFilteringICDCode : String = '';          //kt

const
  AllTemplateLinkTypes = [ttTitles..ttProcedures];
  AllTemplateRootTypes = [ttMyRoot, ttRoot, ttTitles, ttConsults, ttProcedures];
  AllTemplateTrueTypes = AllTemplateRootTypes + [ttNone, ttClass];
  AllTemplateFolderTypes = AllTemplateRootTypes + [ttGroup, ttClass];

type
  TTemplateChildren = (tcNone, tcActive, tcInactive, tcBoth);
  TTemplateAccess = (taAll, taReadOnly, taNone, taEditor);
  TTemplateLinkType = (ltNone, ltTitle, ltConsult, ltProcedure);

  TTemplateBackup = record
    BPrintName: string;
    BGap: integer;
    BRealType: TTemplateType;
    BActive: boolean;
    BDisplayOnly: boolean;
    BFirstLine: boolean;
    BOneItemOnly: boolean;
    BHideDlgItems: boolean;
    BHideItems: boolean;
    BIndentItems: boolean;
    BExclude: boolean;
    BDialog: boolean;
    BEmbeddedDialog: boolean; //kt added 6/16
    BPersonalOwner: Int64;
    BBoilerPlate: string;
    BItemIENs: string;
    BDescription: string;
    BReminderDialog: string;
    BLock: boolean;
    BCOMObject: integer;
    BCOMParam: string;
    BFileLink: string;
    BLinkedDxs : TStringList;   //kt
    SavedPrintName: boolean;
    SavedGap: boolean;
    SavedRealType: boolean;
    SavedActive: boolean;
    SavedDisplayOnly: boolean;
    SavedFirstLine: boolean;
    SavedOneItemOnly: boolean;
    SavedHideDlgItems: boolean;
    SavedHideItems: boolean;
    SavedIndentItems: boolean;
    SavedExclude: boolean;
    SavedDialog: boolean;
    SavedEmbeddedDialog: boolean;  //kt added 6/16
    SavedPersonalOwner: boolean;
    SavedBoilerPlate: boolean;
    SavedItemIENs: boolean;
    SavedDescription: boolean;
    SavedReminderDialog: boolean;
    SavedLock: boolean;
    SavedCOMObject: boolean;
    SavedCOMParam: boolean;
    SavedFileLink: boolean;
    SavedLinkedDxs : boolean;  //kt
  end;

  TTemplate = class(TObject)
  private
    FDescriptionLoaded: boolean;  // Template Notes Loaded Flag
    FDescription: string;         // Template Notes
    FCreatingChildren: boolean;   // Flag used to prevent infinite recursion
    FExclude: boolean;            // Exclude from group boilerplate
    FActive: boolean;
    FDisplayOnly: boolean;        // Suppresses checkbox in dialog - no PN text
    FFirstLine: boolean;          // Display only the first line in a dialog box
    FOneItemOnly: boolean;        // Allow only one Child Item to be selected in dialog
    FHideDlgItems: boolean;       // Hide Child Items when not checked
    FHideItems: boolean;          // Hide items in Templates Drawer Tree
    FIndentItems: boolean;        // Indent Items in dialog only
    FLock: boolean;               // Locks Shared Templates
    FDialog: boolean;             // Determines if Group is a Dialog  //kt added doc.  If false, then FEmbeddedDialog is also false  //kt 6/16
    FEmbeddedDialog: boolean;     // Determines if Group is a Dialog, but to be embedded in HTML document.  If true, then FDialog also true.  //kt added 6/16
    FBoilerPlateLoaded: boolean;  // Boilerplate Loaded Flag
    FBoilerplate: string;         // Boilerplate
    FUppercaseBoilerplate : string; // copy of Boilerplate (not the master copy), made UpperCase  //kt added 6/16
    FID: string;                  // Template IEN
    FPrintName: string;           // Template Name
    FItems: TList;                // Holds pointers to children templates
    FNodes: TStringList;          // Holds tree nodes that reference the template
                                  // string value is tmp index used for syncing
    FRealType: TTemplateType;     // Real Template Type (from the template file)
    FGap: integer;                // Number of blank lines to insert between items
    FChildren: TTemplateChildren; // flag indicating the active status of children
    FPersonalOwner: Int64;        // owner DUZ
    FExpanded: boolean;           // Indicates children have been read from server
    FTag: longint;                // Used internally for syncing
    FLastTagIndex: longint;       // Used internally for syncing
    FBkup: TTemplateBackup;       // Backup values to determine what needs to be saved
    FLastDlgCnt: longint;
    FLastUniqueID: longint;
    FDialogAborted: boolean;      // Flag indicating Cancel was pressed on the dialog
    FReminderDialog: string;      // Reminder Dialog IEN ^ Reminder Dialog Name
    FIsReminderDialog: boolean;   // Flag used internally for setting Type
    FIsCOMObject: boolean;        // Flag used internally for setting Type
    FLocked: boolean;             // Flag Indicating Template is locked
    FCOMObject: integer;          // COM Object IEN
    FCOMParam: string;            // Param to pass to COM Object
    FFileLink: string;            // Used to link templates to Titles and Reasons for Request
    FLinkName: string;
    FCloning: boolean;            // Flag used to prevent locking during the cloning process
    FPreviewMode:  boolean;       // Flag to prevent "Are you sure you want to cancel?" dialog when previewing
    FLinkedDxs : TStringList;     // If Template is used for CarePlan, then this will hold linked diagnoses (if any) //kt
    //kt FFilteringICDCode : string;   // If Template is used for CarePlan, then this field may hold a filtering ICD code //kt
    FFieldsUsed : TStringList;    // List of fields used, 1 per line. Repeated entries for duplicate fields. //kt
  protected
    function TrueClone: TTemplate;
    function GetItems: TList;
    function GetTemplateType: TTemplateType;
    procedure ExtractFieldUsedListFromBoilerplate;  //kt added 5/16
    function GetBoilerplate: string;
    function GetChildren: TTemplateChildren;
    procedure SetTemplateType(const Value: TTemplateType);
    procedure SetBoilerplate(Value: string);
    //kt original --> function GetText: string;  //kt ALSO moved to public
    procedure SetPersonalOwner(Value: Int64);
    procedure SetActive(const Value: boolean);
    procedure SetDisplayOnly(const Value: boolean);
    procedure SetFirstLine(const Value: boolean);
    procedure SetOneItemOnly(const Value: boolean);
    procedure SetHideDlgItems(const Value: boolean);
    procedure SetHideItems(const Value: boolean);
    procedure SetIndentItems(const Value: boolean);
    procedure SetLock(const Value: boolean);
    procedure SetExclude(const Value: boolean);
    procedure SetDialog(const Value: boolean);
    procedure SetEmbeddedDialog(const Value: boolean); //kt added 6/16
    procedure SetGap(const Value: integer);
    procedure SetPrintName(const Value: string);
    procedure SetRealType(const Value: TTemplateType);
    procedure ClearBackup(ClearItemIENs: boolean = TRUE);
    procedure SetDescription(const Value: string);
    function GetDescription: string;
    function GetDialogAborted: boolean;
    procedure SetReminderDialog(const Value: string);     // Reminder Dialog IEN
    procedure SetCOMObject(const Value: integer);
    procedure SetCOMParam(const Value: string);
    procedure AssignFileLink(const Value: string; Force: boolean);
    procedure SetFileLink(const Value: string);
    function ValidID: boolean;
    function SLDiffers(SL1, SL2 : TStringList) : boolean;  //kt
  public
    constructor Create(DataString: string);
    class function CreateFromXML(Element: IXMLDOMNode; Owner: string): TTemplate;
    destructor Destroy; override;
    function CanModify: boolean;
    procedure Unlock;
    procedure AddNode(Node: Pointer);
    procedure RemoveNode(Node: Pointer);
    procedure AddChild(Child: TTemplate);
    procedure RemoveChild(Child: TTemplate);
    function Clone(Owner: Int64): TTemplate;
    function ItemBoilerplate: string;
    function FullBoilerplate: string;
    function ItemIENs: string;
    procedure BackupItems;
    procedure SortChildren;
    function Changed: boolean;
    function DialogProperties(Parent: TTemplate = nil): string;
    function DlgID: string;
    function IsDialog: boolean;
    function CanExportXML(Data, Fields: TStringList; IndentLevel: integer = 0): boolean;
    function ReminderDialogIEN: string;
    function ReminderDialogName: string;
    function ReminderWipe: string; //AGP Change 24.8
    function IsLocked: boolean;
    procedure UpdateImportedFieldNames(List: TStrings);
    //function COMObjectText(const DefText: string = ''; DocInfo: string = ''): string;
    function COMObjectText(DefText: string; var DocInfo: string): string;
    function AutoLock: boolean;
    function LinkType: TTemplateLinkType;
    function LinkIEN: string;
    function LinkName: string;
    procedure ExecuteReminderDialog(OwningForm: TForm);
    property Nodes: TStringList read FNodes;
    property ID: string read FID;
    property PrintName: string read FPrintName write SetPrintName;
    property RealType: TTemplateType read FRealType write SetRealType;
    property TemplateType: TTemplateType read GetTemplateType write SetTemplateType;
    property Active: boolean read FActive write SetActive;
    property DisplayOnly: boolean read FDisplayOnly write SetDisplayOnly;
    property FirstLine: boolean read FFirstLine write SetFirstLine;
    property OneItemOnly: boolean read FOneItemOnly write SetOneItemOnly;
    property HideDlgItems: boolean read FHideDlgItems write SetHideDlgItems;
    property HideItems: boolean read FHideItems write SetHideItems;
    property IndentItems: boolean read FIndentItems write SetIndentItems;
    property Lock: boolean read FLock write SetLock;
    property Exclude: boolean read FExclude write SetExclude;
    property Dialog: boolean read FDialog write SetDialog;
    property EmbeddedDialog: boolean read FEmbeddedDialog write SetEmbeddedDialog;  //kt 6/16
    property Boilerplate: string read GetBoilerplate write SetBoilerplate;
    property Children: TTemplateChildren read GetChildren;
    property Items: TList read GetItems;
    property Gap: integer read FGap write SetGap;
    property Description: string read GetDescription write SetDescription;
    function GetText(DBControlData : pointer): string;  //kt added 5/16 NOTE: should actually be TDBControlData type
    //kt original --> property Text: string read GetText;
    property PersonalOwner: Int64 read FPersonalOwner write SetPersonalOwner;
    property Expanded: boolean read FExpanded write FExpanded;
    property Tag: longint read FTag write FTag;
    property LastTagIndex: longint read FLastTagIndex write FLastTagIndex;
    property DialogAborted: boolean read GetDialogAborted;
    property ReminderDialog: string read FReminderDialog write SetReminderDialog;
    property IsReminderDialog: boolean read FIsReminderDialog write FIsReminderDialog;
    property IsCOMObject: boolean read FIsCOMObject write FIsCOMObject;
    property Locked: boolean read FLocked;
    property COMObject: integer read FCOMObject write SetCOMObject;
    property COMParam: string read FCOMParam write SetCOMParam;
    property FileLink: string read FFileLink write SetFileLink;
    procedure LinkedDxsAssign(Source : TStringList);                                    //kt
    procedure LinkedDxsGet(Dest : TStringList);                                         //kt
    function LinkedDxsCount : integer;                                                  //kt
    function LinkedDxsAdd(S : String) : integer;                                        //kt
    //kt property FilteringICDCode : string read FFilteringICDCode write FFilteringICDCode;  //kt
    function BoilerplateContainsScript : boolean;                                       //kt added 6/16
    property TemplatePreviewMode: boolean read FPreviewMode write FPreviewMode;
    procedure ClearChildren;  //elh    //kt
    procedure TMGForceSetFullBoilerplate(Value : string);
  end;

function SearchMatch(const SubStr, Str: string; const WholeWordsOnly: boolean): boolean;
function UserTemplateAccessLevel: TTemplateAccess;
function AddTemplate(DataString: string; Owner: TTemplate = nil): TTemplate;
procedure LoadTemplateData;
procedure ExpandTemplate(tmpl: TTemplate);
procedure ReleaseTemplates;
procedure RemoveAllNodes;
function CanEditLinkType(LinkType: TTemplateLinkTypes): boolean;
function GetLinkedTemplate(IEN: string; LType: TTemplateLinkType): TTemplate;
function ConvertFileLink(IEN: string; LType: TTemplateLinkType): string;
function GetLinkName(IEN: string; LType: TTemplateLinkType): string;

function NewTemplateName(Mode : TcpteMode = cptemNormal) : string;           //kt added
function BadNameText(Mode : TcpteMode = cptemNormal) : string;               //kt added
function BackupDiffers: boolean;
procedure SaveTemplate(Template: TTemplate; Idx: integer; ErrorList: TStrings = nil);
function SaveAllTemplates: boolean;
procedure ClearBackup;
procedure MarkDeleted(Template: TTemplate);
function BadTemplateName(Text: string; Mode : TcpteMode = cptemNormal): boolean; //kt added Mode : TcpteMode variable
procedure WordImportError(msg: string);
procedure XMLImportError(Result: HResult);
procedure XMLImportCheck(Result: HResult);
function GetXMLFromWord(const AFileName: string; Data: TStrings): boolean;
function WordImportActive: boolean;
procedure UnlockAllTemplates;
function DisplayGroupToLinkType(DGroup: integer): TTemplateLinkType;

(*procedure ExecuteTemplateOrBoilerPlate(SL: TStrings; IEN: Integer; LType: TTemplateLinkType;
                                       OwningForm: TForm; const CaptionText: string = ''; DocInfo: string = ''); overload;
procedure ExecuteTemplateOrBoilerPlate(var AText: string; IEN: Integer; LType: TTemplateLinkType;
                                       OwningForm: TForm; const CaptionText: string = ''; DocInfo: string = ''); overload;*)
procedure ExecuteTemplateOrBoilerPlate(SL: TStrings; IEN: Integer; LType: TTemplateLinkType;
                                       OwningForm: TForm; CaptionText: string; var DocInfo: string); overload;
procedure ExecuteTemplateOrBoilerPlate(var AText: string; IEN: Integer; LType: TTemplateLinkType;
                                       OwningForm: TForm; CaptionText: string; var DocInfo: string); overload;

procedure ExpandEmbeddedFields(flds: TStringList);
function MakeXMLParamTIU(ANoteID: string; ANoteRec: TEditNoteRec): string;  overload;
function MakeXMLParamTIU(ADCSummID: string; ADCSummRec: TEditDCSummRec): string;  overload;
function GetXMLParamReturnValueTIU(DocInfo, ParamTag: string): string;
procedure UpdatePersonalObjects;
procedure SetTemplateDialogCanceled(value: Boolean);
function WasTemplateDialogCanceled: Boolean;
procedure SetTemplateBPHasObjects(value: Boolean);
function TemplateBPHasObjects: Boolean;

function UsingHTMLTargetMode:boolean;                //kt 12/27/12

const
  EmptyNodeText = '<^Empty Node^>';
  //kt Replaced with function --> NewTemplateName = 'New Template';
  FirstRealTemplateType = ttMyRoot;
  LastRealTemplateType = ttGroup;

  TemplateTypeCodes: array[FirstRealTemplateType..LastRealTemplateType] of string[8] =   //kt 5/15 changed length from 2 --> 8
                                                                  ('P','R','TF','CF','OF',
                                                                  //'TMGPL',  //kt 5/15
                                                                  'C','T','G');
  //kt Replaced constant with a function.
  //kt BadNameText = CRLF + CRLF + 'Valid Template names must start with an alphanumber '+
  //kt               'character, and be at least 3 characters in length.' + CRLF +
  //kt              'In addition, no template can be named "' + NewTemplateName+'".';

  TemplateLockedText = 'Template %s is currently being edited by another user.';

  XMLTemplateTag = 'TEMPLATE';
  XMLTemplateFieldsTag = 'TEMPLATE_FIELDS';
  XMLHeader = 'CPRS_TEMPLATE';

  DYNAMIC_NAMESPACE = '{DYNAMIC}';   //elh added for

var
  Templates: TStringList = nil;
  RootTemplate: TTemplate = nil;
  MyTemplate: TTemplate = nil;
  TitlesTemplate: TTemplate = nil;
  ConsultsTemplate: TTemplate = nil;
  ProceduresTemplate: TTemplate = nil;
  //TMGProblemListTmpl: TTemplate = nil; //kt 5/15 This won't really be a template, but will overload functionality
  //TMGPLData : TStringList = nil;       //kt 5/15
  uPersonalObjects: TStringList = nil;   // -------- CQ #8665 - RV ------------

implementation

uses
  uCareplan,rCarePlans, //kt-cp
  fNotes, uHTMLTools, rProbs, rTIU, fSingleNote, //kt
  Windows, rTemplates, uCore, dShared, fTemplateDialog, ActiveX, ComObj, uTemplateFields,
  XMLUtils, fTemplateImport, uSpell, rCore, uConst, {//kt ORCtrls,} uEventHooks,
  fReminderDialog, rODBase
  {$IFDEF VER140}
  , Word97;
  {$ELSE}
  , WordXP, VAUtils;
  {$ENDIF}

const
  MaxSeq = 999999;
  sLoading = 'Loading Template Information...';

type
  ETemplateError = class(Exception);
  ETemplateImportError = class(Exception);
  ETemplateXMLImportError = class(EOleSysError);

var
  TemplateAccessLevelChecked: boolean = FALSE;
  TemplateAccessLevelValue: TTemplateAccess;
  LastTemplateLocation: integer = 0;
  TempSL: TStringList = nil;
  Deleted: TStringList = nil;
  NodeCount: longint = 0; // Used by FNodes to prevent access violations in a Resync

  GettingDialogText: boolean = FALSE;
  uIndentLevel: integer;
  uDlgCount: longint = 0;  // Used for dialogs on unsaved templates
  uUniqueIDNum: longint = 0; // Used for dialogs on unsaved templates
  uCanEditLinkTypeResults: string = '';
  uTemplateDataLoaded: boolean = FALSE;
  uDGroupConsults: integer = 0;
  uDGroupProcedures: integer = 0;
  uTemplateDialogCanceled: Boolean = FALSE;
  uTemplateBPHasObjects: Boolean = FALSE;

type
  TTemplateExportField = (efName, efBlankLines, efType, efStatus, efExclude, efDialog,
                          efDisplayOnly, efFirstLine, efOneItemOnly, efHideDialogItems,
                          efHideTreeItems, efIndentItems, efBoilerplate, efDescription,
                          efItems, efLock);

const
  TemplateActiveCode: array[boolean] of string[1] = ('I','A');
  TemplateExportTag: array[TTemplateExportField] of string = // From Field Names in File 8927
                {  efName            }  ('NAME',
                {  efBlankLines      }   'BLANK_LINES',
                {  efType            }   'TYPE',
                {  efStatus          }   'STATUS',
                {  efExclude         }   'EXCLUDE_FROM_GROUP_BOILERPLATE',
                {  efDialog          }   'DIALOG',
                {  efDisplayOnly     }   'DISPLAY_ONLY',
                {  efFirstLine       }   'FIRST_LINE',
                {  efOneItemOnly     }   'ONE_ITEM_ONLY',
                {  efHideDialogItems }   'HIDE_DIALOG_ITEMS',
                {  efHideTreeItems   }   'HIDE_TREE_ITEMS',
                {  efIndentItems     }   'INDENT_ITEMS',
                {  efBoilerplate     }   'BOILERPLATE_TEXT',
                {  efDescription     }   'DESCRIPTION',
                {  efItems           }   'ITEMS',
                {  efLock            }   'LOCK');

  ExportPieces:array[TTemplateExportField] of integer =
                {  efName            }  (4,
                {  efBlankLines      }   6,
                {  efType            }   2,
                {  efStatus          }   3,
                {  efExclude         }   5,
                {  efDialog          }   9,
                {  efDisplayOnly     }   10,
                {  efFirstLine       }   11,
                {  efOneItemOnly     }   12,
                {  efHideDialogItems }   13,
                {  efHideTreeItems   }   14,
                {  efIndentItems     }   15,
                {  efBoilerplate     }   0,
                {  efDescription     }   0,
                {  efItems           }   0,
                {  efLock            }   18);

  XMLErrorMessage = 'Error Importing Template.  File does not contain Template ' +
                    'information or may be corrupted.';

  WordErrorMessage = 'Error Importing Word Document.';

type
  TTemplateFieldExportField = (tfName, tfType, tfLength, tfDefault, tfDefIdx, tfDesc,
                               tfItems, tfDateType, tfTextLen, tfMinVal, tfMaxVal);

const
  TemplateFieldExportTag: array[TTemplateFieldExportField] of string = // From Field Names in File 8927.1
                  { tfName     }  ('NAME',
                  { tfType     }   'TYPE',
                  { tfLength   }   'LENGTH',
                  { tfDefault  }   'DEFAULT_TEXT',
                  { tfDefIdx   }   'DEFAULT_INDEX',
                  { tfDesc     }   'DESCRIPTION',
                  { tfItems    }   'ITEMS',
                  { tfDateType }   'DATE_TYPE',
                  { tfTextLen  }   'MAX_LENGTH',
                  { tfMinVal   }   'MIN_VALUE',
                  { tfMaxVal   }   'MAX_VALUE');

  XMLFieldTag = 'FIELD';

  LinkGlobal: array[TTemplateLinkType] of string =
                   { ltNone      } ('',
                   { ltTitle     }  ';TIU(8925.1,',
                   { ltConsult   }  ';GMR(123.5,',
                   { ltProcedure }  ';GMR(123.3,');

  LinkPassCode: array[TTemplateLinkType] of string =
                   { ltNone      } ('',
                   { ltTitle     }  'T',
                   { ltConsult   }  'C',
                   { ltProcedure }  'P');

function DlgText(const txt: string; DlgProps: string): string;
var
  i, j: integer;

begin
  Result := txt;
  if GettingDialogText then
  begin
    if (Result = '') then
      Result := NoTextMarker;
    i := pos(DlgPropMarker, Result);
    j := pos(ObjMarker, Result);
    if(i > 0) and (j > 0) then
      delete(Result, i, j - i + ObjMarkerLen)
    else
      i := length(Result) + 1;
    insert(DlgPropMarker + DlgProps + ObjMarker, Result, i);
  end;
end;

function SearchMatch(const SubStr, Str: string; const WholeWordsOnly: boolean): boolean;
const
  AlphaNumeric = ['A'..'Z','a'..'z','0'..'9'];

var
  i, j: integer;

begin
  i := pos(SubStr,Str);
  if(i > 0) then
  begin
    Result := TRUE;
    if(WholeWordsOnly) then
    begin
      if((i > 1) and (Str[i-1] in AlphaNumeric)) then
        Result := FALSE
      else
      begin
        j := length(SubStr);
        if((i+j) <= length(Str)) then
          Result := (not (Str[i+j] in AlphaNumeric));
      end;
    end;
  end
  else
    Result := FALSE;
end;

function UserTemplateAccessLevel: TTemplateAccess;
var
  i: integer;

begin
  if(TemplateAccessLevelChecked and
    (LastTemplateLocation = Encounter.Location)) then
    Result := TemplateAccessLevelValue
  else
  begin
    TemplateAccessLevelChecked := FALSE;
    LastTemplateLocation := 0;
    if(not assigned(RootTemplate)) then
    begin
      Result := taAll;
      GetTemplateRoots;
      for i := 0 to RPCBrokerV.Results.Count-1 do
      begin
        if(Piece(RPCBrokerV.Results[i],U,2)=TemplateTypeCodes[ttRoot]) then
        begin
          Result := TTemplateAccess(GetTemplateAccess(Piece(RPCBrokerV.Results[i],U,1)));
          LastTemplateLocation := Encounter.Location;
          TemplateAccessLevelChecked := TRUE;
          TemplateAccessLevelValue := Result;
          Break;
        end;
      end;
    end
    else
    begin
      Result := TTemplateAccess(GetTemplateAccess(RootTemplate.ID));
      LastTemplateLocation := Encounter.Location;
      TemplateAccessLevelChecked := TRUE;
      TemplateAccessLevelValue := Result;
    end;
  end;
end;

function AddTemplate(DataString: string; Owner: TTemplate = nil): TTemplate;
var
  idx: integer;
  id: string;
  tmpl: TTemplate;

begin
  id := Piece(DataString, U, 1);
  if(id = '') or (id = '0') then
    idx := -1
  else
    idx := Templates.IndexOf(id);
  if(idx < 0) then
  begin
    tmpl := TTemplate.Create(DataString);
    Templates.AddObject(id, tmpl);
    if(tmpl.Active) then begin
      if (tmpl.RealType = ttRoot) then
        RootTemplate := tmpl
      else if (tmpl.RealType = ttTitles) then
        TitlesTemplate := tmpl
      else if (tmpl.RealType = ttConsults) then
        ConsultsTemplate := tmpl
      else if (tmpl.RealType = ttProcedures) then
        ProceduresTemplate := tmpl
      else if(tmpl.RealType = ttMyRoot) then
        MyTemplate := tmpl
      //kt 5/15 begin mod -----
      //else if(tmpl.RealType = ttTMGProbList) then
      //  TMGProblemListTmpl := tmpl;
      //kt 5/15 end mod -----
    end;
  end
  else
    tmpl := TTemplate(Templates.Objects[idx]);
  if(assigned(Owner)) and (assigned(tmpl)) then
    Owner.AddChild(tmpl);
  Result := tmpl;
end;

procedure LoadTemplateData;
var
  i: integer;
  TmpSL: TStringList;
  NeededDxs : TStringList;  //kt

begin
  if(not uTemplateDataLoaded) then begin
    StatusText(sLoading);
    try
      if(not assigned(Templates)) then
        Templates := TStringList.Create;
      TmpSL := TStringList.Create;
      NeededDxs := TStringList.Create; //kt
      try
        GetTemplateRoots;
        FastAssign(RPCBrokerV.Results, TmpSL);
        for i := 0 to TmpSL.Count-1 do begin
          AddTemplate(TmpSL[i]);
        end;
        uTemplateDataLoaded := TRUE;
      finally
        TmpSL.Free;
        NeededDxs.Free; //kt
      end;
    finally
      StatusText('');
    end;
  end;
end;

procedure ExpandTemplate(tmpl: TTemplate);
var
  i: integer;
  TmpSL: TStringList;
  NeededDxs : TStringList;  //kt
  NewTemplate : TTemplate;  //kt

begin
  if(not tmpl.Expanded) then
  begin
    if(tmpl.Children <> tcNone) then
    begin
      StatusText(sLoading);
      try
        TmpSL := TStringList.Create;
        NeededDxs := TStringList.Create;  //kt
        try
          if VEFATemplateMode = cptemCarePlan then begin          //kt
            GetCarePlanChildren(tmpl.FID, VEFAFilteringICDCode);  //kt
          end else begin                                          //kt
            GetTemplateChildren(tmpl.FID);                        //<-- original line.
          end;                                                    //kt
          FastAssign(RPCBrokerV.Results, TmpSL);
          //kt for i := 0 to TmpSL.Count-1 do
          //kt   AddTemplate(TmpSL[i], tmpl);
          //kt --- start mod ----------
          for i := 0 to TmpSL.Count-1 do begin
            NewTemplate := AddTemplate(TmpSL[i], tmpl);
            //kt NewTemplate.FilteringICDCode := FilteringICDCode;
            NeededDxs.AddObject(piece(TmpSl[i],'^',1),NewTemplate);  //ien list of templates for which linked Dx's are needed.
          end;
          GetLinkedDxs(NeededDxs);
          //kt --- end mod ----------
        finally
          TmpSL.Free;
          NeededDxs.Free;  //kt
        end;
      finally
        StatusText('');
      end;
    end;
    tmpl.Expanded := TRUE;
    with tmpl,tmpl.FBkup do
    begin
      BItemIENs := ItemIENs;
      SavedItemIENs := TRUE;
    end;
  end;
end;

procedure ReleaseTemplates;
var
  i: integer;

begin
  if(assigned(Templates)) then
  begin
    for i := 0 to Templates.Count-1 do
      TTemplate(Templates.Objects[i]).Free;
    Templates.Free;
    Templates := nil;
    uTemplateDataLoaded := FALSE;
  end;
  ClearBackup;
  if(assigned(TempSL)) then
  begin
    TempSL.Free;
    TempSL := nil;
  end;
  // -------- CQ #8665 - RV ------------
  if (assigned(uPersonalObjects)) then
  begin
    KillObj(@uPersonalObjects);
    uPersonalObjects.Free;
    uPersonalObjects := nil;
  end;
  // ------end CQ #8665 ------------
  if(assigned(Deleted)) then
  begin
    Deleted.Clear;
    Deleted := nil;
  end;
  RootTemplate := nil;
  MyTemplate := nil;
  TitlesTemplate := nil;
  ConsultsTemplate := nil;
  ProceduresTemplate := nil;
end;

procedure RemoveAllNodes;
var
  i: integer;

begin
  if(assigned(Templates)) then
  begin
    for i := 0 to Templates.Count-1 do
      TTemplate(Templates.Objects[i]).FNodes.Clear;
  end;
end;

function CanEditLinkType(LinkType: TTemplateLinkTypes): boolean;

  function CanEditType(Template: TTemplate): boolean;
  begin
    if not assigned(Template) then
      Result := FALSE
    else
    if pos(Char(ord(LinkType)+ord('0')), uCanEditLinkTypeResults) > 0 then
      Result := (pos(Char(ord(LinkType)+ord('A')), uCanEditLinkTypeResults) > 0)
    else
    begin
      Result := IsUserTemplateEditor(Template.ID, User.DUZ);
      uCanEditLinkTypeResults := uCanEditLinkTypeResults + Char(ord(LinkType)+ord('0'));
      if Result then
        uCanEditLinkTypeResults := uCanEditLinkTypeResults + Char(ord(LinkType)+ord('A'));
    end;
  end;

begin
  case LinkType of
    ttTitles:     Result := CanEditType(TitlesTemplate);
    ttConsults:   Result := CanEditType(ConsultsTemplate);
    ttProcedures: Result := CanEditType(ProceduresTemplate);
    else          Result := FALSE;
  end;
end;

function GetLinkedTemplate(IEN: string; LType: TTemplateLinkType): TTemplate;
var
  idx: integer;
  Data, ALink: string;

begin
  Result := nil;
  if LType <> ltNone then
  begin
    if(not assigned(Templates)) then
      Templates := TStringList.Create;
    ALink := IEN + LinkGlobal[LType];
    for idx := 0 to Templates.Count-1 do
    begin
      if ALink = TTemplate(Templates.Objects[idx]).FFileLink then
      begin
        Result := TTemplate(Templates.Objects[idx]);
        break;
      end;
    end;
    if not assigned(Result) then
    begin
      Data := GetLinkedTemplateData(ALink);
      if Data <> '' then
        Result := AddTemplate(Data);
    end;
  end;
end;

function ConvertFileLink(IEN: string; LType: TTemplateLinkType): string;
begin
  if(LType = ltNone) or (IEN = '') or (StrToIntDef(IEN,0) = 0) then
    Result := ''
  else
    Result := IEN + LinkGlobal[LType];
end;

function GetLinkName(IEN: string; LType: TTemplateLinkType): string;
var
  IEN64: Int64;

begin
  IEN64 := StrToInt64Def(IEN,0);
  case LType of
    ltTitle:     Result := ExternalName(IEN64,8925.1);
    ltConsult:   Result := ExternalName(IEN64,123.5);
    ltProcedure: Result := ExternalName(IEN64,123.3);
    else         Result := '';
  end;
end;

function BackupDiffers: boolean;
var
  i: integer;

begin
  Result := FALSE;
  if(assigned(Templates)) then
  begin
    for i := 0 to Templates.Count-1 do
    begin
      if(TTemplate(Templates.Objects[i]).Changed) then
      begin
        Result := TRUE;
        exit;
      end;
    end;
  end;
end;

procedure DisplayErrors(Errors: TStringList; SingleError: string = '');
begin
  if(assigned(Errors)) then
    ShowMsg(Errors.text)
  else
    ShowMsg(SingleError);
end;


procedure SaveTemplate(Template: TTemplate; Idx: integer; ErrorList: TStrings = nil);
var
  i: integer;
  ID, Tmp: string;
  val : string;  //kt 6/16
  NoCheck: boolean;
  DescSL: TStringList;

begin
{ Removed because this may be a bug??? - what if it's hidden? -
  better to save and delete than miss it
//Don't save new templates that have been deleted
  if(((Template.ID = '0') or (Template.ID = '')) and
     (Template.Nodes.Count = 0)) then exit;
}
  if(not Template.Changed) then begin
    Template.Unlock;
    exit;
  end;

  if(not assigned(TempSL)) then begin
    TempSL := TStringList.Create;
  end;
  TempSL.Clear;
  ID := Template.ID;

  NoCheck := (ID = '0') or (ID = '');

  //kt begin mod 6/16 ------------------------------
  if (Template.BoilerplateContainsScript)
  and (User.CanMakeTemplatesWithScripts = false) then begin
    Tmp := 'Sorry.  User does not have permission to save templates with "<SCRIPT".  ' + #13#10 +
           'Template Name=['+Template.PrintName+'], ID=['+ID+'].';
    if(Assigned(ErrorList)) then begin
      ErrorList.Add(Tmp)
    end else begin
      DisplayErrors(nil, Tmp);
    end;
    exit;
  end;
  //kt end mod 6/16 ------------------------------

  with Template,Template.FBkup do begin
    if(NoCheck or (SavedBoilerplate and (BBoilerplate <> Boilerplate))) then begin
      TempSL.Text := BoilerPlate;
      if(TempSL.Count > 0) then begin
        for i := 0 to TempSL.Count-1 do begin
          TempSL[i] := '2,'+IntToStr(i+1)+',0='+TempSL[i];
        end;
      end else begin
        TempSL.Add('2,1=@');
      end;
    end;

    if(NoCheck or (SavedPrintName and (BPrintName <> PrintName))) then begin
      TempSL.Add('.01='+PrintName);
    end;

    if(NoCheck or (SavedGap and (BGap <> Gap))) then begin
      if Gap = 0 then begin
        TempSL.Add('.02=@')
      end else begin
        TempSL.Add('.02='+IntToStr(Gap));
      end;
    end;

    if(NoCheck or (SavedRealType and (BRealType <> RealType))) then
      TempSL.Add('.03='+TemplateTypeCodes[RealType]);

    if(NoCheck or (SavedActive and (BActive <> Active))) then
      TempSL.Add('.04='+TemplateActiveCode[Active]);

    if(NoCheck or (SavedExclude and (BExclude <> FExclude))) then
      TempSL.Add('.05='+BOOLCHAR[Exclude]);

    //kt original --> if(NoCheck or (SavedDialog and (BDialog <> FDialog))) then
    //kt original -->   TempSL.Add('.08='+BOOLCHAR[Dialog]);
    if(NoCheck or (SavedDialog and (BDialog <> FDialog))  //kt added this block to replace above.  6/16
      or (SavedEmbeddedDialog and (BEmbeddedDialog <> FEmbeddedDialog))) then begin
      //Truth table for FEmbeddedDialog and FDialog
      //F  F  --> '0'
      //F  T  --> '1'
      //T  F  --> (never.  If FEmbeddedDialg=true, then FDialog is set to true)
      //T  T  --> '2'
      if (FEmbeddedDialog = true) and (FDialog = true) then val := '2'
      else if (FEmbeddedDialog = false) and (FDialog = true) then val := '1'
      else val := '0';
      TempSL.Add('.08='+val);
    end;

    if(NoCheck or (SavedDisplayOnly and (BDisplayOnly <> DisplayOnly))) then
      TempSL.Add('.09='+BOOLCHAR[DisplayOnly]);

    if(NoCheck or (SavedFirstLine and (BFirstLine <> FirstLine))) then
      TempSL.Add('.1='+BOOLCHAR[FirstLine]);

    if(NoCheck or (SavedOneItemOnly and (BOneItemOnly <> OneItemOnly))) then
      TempSL.Add('.11='+BOOLCHAR[OneItemOnly]);

    if(NoCheck or (SavedHideDlgItems and (BHideDlgItems <> HideDlgItems))) then
      TempSL.Add('.12='+BOOLCHAR[HideDlgItems]);

    if(NoCheck or (SavedHideItems and (BHideItems <> HideItems))) then
      TempSL.Add('.13='+BOOLCHAR[HideItems]);

    if(NoCheck or (SavedIndentItems and (BIndentItems <> IndentItems))) then
      TempSL.Add('.14='+BOOLCHAR[IndentItems]);

    if(NoCheck or (SavedReminderDialog and (BReminderDialog <> ReminderDialog))) then begin
      if ReminderDialogIEN = '' then begin
        TempSL.Add('.15=@')
      end else begin
        TempSL.Add('.15='+ReminderDialogIEN);
      end;
    end;

    if(NoCheck or (SavedLock and (BLock <> Lock))) then
      TempSL.Add('.16='+BOOLCHAR[Lock]);

    if(NoCheck or (SavedCOMObject and (BCOMObject <> COMObject))) then begin
      if COMObject = 0 then begin
        TempSL.Add('.17=@')
      end else begin
        TempSL.Add('.17='+IntToStr(COMObject));
      end;
    end;

    if(NoCheck or (SavedCOMParam and (BCOMParam <> COMParam))) then begin
      if COMParam = '' then begin
        TempSL.Add('.18=@')
      end else begin
        TempSL.Add('.18=' + COMParam);
      end;
    end;

    if(NoCheck or (SavedFileLink and (BFileLink <> FileLink))) then begin
      if FileLink = '' then begin
        TempSL.Add('.19=@')
      end else begin
        TempSL.Add('.19=' + FileLink);
      end;
    end;

    if(NoCheck or (SavedPersonalOwner and (BPersonalOwner <> PersonalOwner))) then begin
      if(PersonalOwner = 0) then begin
        Tmp := ''
      end else begin
        Tmp := IntToStr(PersonalOwner);
      end;
      TempSL.Add('.06='+Tmp);
    end;

    if(NoCheck or (SavedDescription and (BDescription <> Description))) then begin
      DescSL := TStringList.Create;
      try
        DescSL.Text := Description;
        if(DescSL.Count > 0) then begin
          for i := 0 to DescSL.Count-1 do begin
            DescSL[i] := '5,'+IntToStr(i+1)+',0='+DescSL[i];
          end;
        end else begin
          DescSL.Add('5,1=@');
        end;
        FastAddStrings(DescSL, TempSL)
      finally
        DescSL.Free;
      end;
    end;

  end;

  if(TempSL.Count > 0) then begin
    Tmp := UpdateTemplate(ID, TempSL);
    if(Piece(Tmp,U,1) = '0') then begin
      Tmp := 'Error Saving ' + Template.PrintName + ' ' + ID + '=' + Tmp;
      if(Assigned(ErrorList)) then begin
        ErrorList.Add(Tmp)
      end else begin
        DisplayErrors(nil, Tmp);
      end;
    end else begin
      if(((ID = '') or (ID = '0')) and (Tmp <> ID)) then begin
        if(idx < 0) then begin
          idx := Templates.IndexOfObject(Template);
        end;
        Template.FID := Tmp;
        Templates[idx] := Tmp;
        if assigned(Template.FNodes) then begin
          for i := 0 to Template.FNodes.Count-1 do begin
            TORTreeNode(Template.FNodes.Objects[i]).StringData := Template.ID + U + Template.PrintName;
          end;
        end;
      end;
      Template.ClearBackup(FALSE);
      if NoCheck then with Template.FBkup do begin
        BItemIENs := '';
        SavedItemIENs := TRUE;
      end;
    end;
  end;

  //kt ------------------------------------------------------------
  if(NoCheck or (Template.FBkup.SavedLinkedDxs and Template.SLDiffers(Template.FBkup.BLinkedDxs, Template.FLinkedDxs))) then begin
    Tmp := UpdateCarePlanTemplateLinkedDxs(Template.ID,Template.FLinkedDxs,'0');   //Call PRC call to do store from here.
    if(Piece(Tmp,U,1) = '-1') then begin
      Tmp := 'Error Saving ' + Template.PrintName + ' ' + ID + '=' + Piece(Tmp,U,2);
      if(Assigned(ErrorList)) then begin
        ErrorList.Add(Tmp)
      end else begin
        DisplayErrors(nil, Tmp);
      end;
    end;
  end;
  //kt end------------------------------------------------------------

end;

function SaveAllTemplates: boolean;
var
  i, k: integer;
  New: TTemplate;
  Errors: TStringList;
  First, ChildErr: boolean;

begin
  Errors := TStringList.Create;
  try
    if(assigned(Templates)) then begin
      if(not assigned(TempSL)) then begin
        TempSL := TStringList.Create;
      end;
      for i := 0 to Templates.Count-1 do begin
        SaveTemplate(TTemplate(Templates.Objects[i]), i, Errors);  //kt doc <--- save occurs here.
      end;
      First := TRUE;
      if(Errors.Count > 0) then begin
        Errors.Insert(0,'Errors Encountered Saving Templates:');
      end;
      for i := 0 to Templates.Count-1 do begin
        New := TTemplate(Templates.Objects[i]);
        with New.FBkup do begin
          if(SavedItemIENs and (BItemIENs <> New.ItemIENs)) then begin
            TempSL.Clear;
            for k := 0 to New.Items.Count-1 do begin
              TempSL.Add(TTemplate(New.Items[k]).FID);
            end;
            UpdateChildren(New.ID, TempSL);
            ChildErr := FALSE;
            for k := 0 to RPCBrokerV.Results.Count-1 do begin
              if(RPCBrokerV.Results[k] <> IntToStr(k+1)) then begin
                if(First) then begin
                  Errors.Add('Errors Encountered Saving Children:');
                  First := FALSE;
                end;
                Errors.Add(New.ID+' Item #'+IntToStr(k+1)+'('+
                       TTemplate(New.Items[k]).FID+')'+'='+RPCBrokerV.Results[k]);
                ChildErr := TRUE;
              end;
            end;
            if(not ChildErr) then begin
              BItemIENs := New.ItemIENs;
            end;
          end;
        end;
        New.Unlock;
      end;
      if(assigned(Deleted)) and (Deleted.Count > 0) then begin
        DeleteTemplates(Deleted);
        Deleted.Clear;
      end;
      if(Errors.Count > 0) then begin
        DisplayErrors(Errors);
      end;
    end;
  finally
    Result := (Errors.Count = 0);
    Errors.Free;
  end;
end;

procedure ClearBackup;
var
  i: integer;

begin
  if(assigned(Templates)) then
  begin
    for i := 0 to Templates.Count-1 do
      TTemplate(Templates.Objects[i]).ClearBackup;
  end;
end;

procedure MarkDeleted(Template: TTemplate);
var
  i, idx: integer;

begin
  if(Template.ValidID) then
  begin
    if(not assigned(Deleted)) then
      Deleted := TStringList.Create;
    idx := Deleted.IndexOf(Template.ID);
    if(idx < 0) then
      Deleted.Add(Template.ID);
  end;
  Template.FileLink := '';
  Template.GetItems;
  for i := 0 to Template.FItems.Count-1 do
    MarkDeleted(TTemplate(Template.FItems[i]));
end;

function BadTemplateName(Text: string; Mode : TcpteMode = cptemNormal): boolean;  //kt added Mode : TcpteMode vairable
var StrippedName : string;  //kt
begin
  Result := FALSE;
  if Mode = cptemNormal then begin  //kt
    if(Text = NewTemplateName) or (length(Text) < 3) then begin
    Result := TRUE
    end else if(not (Text[1] in ['a'..'z','A'..'Z','0'..'9'])) then begin
      Result := TRUE;
    end;
  end else begin   //kt added this block
    StrippedName := StripNamespacePartOfName(Text, Mode);
    if(Text = NewTemplateName(Mode)) or
    (length(StrippedName) < 3) or
    (not (StrippedName[1] in ['a'..'z','A'..'Z','0'..'9'])) then begin
    Result := TRUE;
    end;
  end;
end;

procedure WordImportError(msg: string);
begin
  raise ETemplateImportError.Create(WordErrorMessage + CRLF + msg);
end;

procedure XMLImportError(Result: HResult);
begin
  raise ETemplateXMLImportError.Create(XMLErrorMessage, Result, 0);
end;

procedure XMLImportCheck(Result: HResult);
begin
  if not Succeeded(Result) then
    XMLImportError(Result);
end;

procedure AddXMLData(Data: TStrings; const Pad: string; FldType: TTemplateExportField; const Value, DefValue: string);
begin
  if(Value <> '') and (Value <> DefValue) then
    Data.Add(Pad + '  <' + TemplateExportTag[FldType] + '>' + Text2XML(Value) +
                    '</' + TemplateExportTag[FldType] + '>');
end;

procedure AddXMLBool(Data: TStrings; const Pad: string; FldType: TTemplateExportField; const Value: boolean);
begin
  AddXMLData(Data, Pad, FldType, BOOLCHAR[Value], BOOLCHAR[FALSE]);
end;

procedure AddXMLList(Data, Fields: TStrings; const Pad: string; FldType: TTemplateExportField; Const Txt: string);
var
  i: integer;
  TmpSL: TStrings;

begin
  if(Txt <> '') then
  begin
    TmpSL := TStringList.Create;
    try
      TmpSL.Text := Txt;
      Data.Add(Pad + '  <' + TemplateExportTag[FldType] + '>');
      for i := 0 to TmpSL.Count-1 do
        Data.Add(Pad + '    <p>' + Text2XML(TmpSL[i]) + '</p>');
      Data.Add(Pad + '  </' + TemplateExportTag[FldType] + '>');
    finally
      TmpSL.Free;
    end;
    if assigned(Fields) then
      ListTemplateFields(Txt, Fields);
  end;
end;

function GetXMLFromWord(const AFileName: string; Data: TStrings): boolean;
var
  itmp, itmp2, itmp3, i, j: integer;
  WDoc: TWordDocument;
  WasVis: boolean;
  WApp: TWordApplication;
  Boiler: string;
  FldCache, Fields, PendingAdd: TStringList;
  OldCur: TCursor;
  idx, TmpVar, RangeStart, RangeEnd: oleVariant;
  ddTotal, ffTotal, ffStartCur, ffEndCur, ffEndLast : integer;
  ffRange, textRange: Range;
  tmp, TemplateName, fName: string;
  tmpType, tfIdx: TTemplateFieldType;
  tmpDate: TTmplFldDateType;

  tfCount: array[TTemplateFieldType] of integer;

  procedure AddBoiler(txt: string);
  var
    i: integer;
    c: char;
    tmp: string;

  begin
    tmp := '';
    for i := 1 to length(txt) do
    begin
      c := txt[i];
      if (c > #31) or (c = #13) or (c = #10) then
        tmp := tmp + c;
    end;
    Boiler := Boiler + tmp;
  end;

  procedure AddField(Typ: TTemplateFieldExportField; Value: string; Pending: boolean = FALSE);
  var
    sl: TStringList;

  begin
    if Pending then
      sl := PendingAdd
    else
      sl := Fields;
    sl.Add('<' + TemplateFieldExportTag[Typ] + '>' + Text2XML(Value) +
                    '</' + TemplateFieldExportTag[Typ] + '>');
  end;

  procedure AddFieldHeader(FldType: TTemplateFieldType; First: boolean);
  var
    tmp: string;

  begin
    tmp := '<';
    if not First then
      tmp := tmp + '/';
    tmp := tmp + XMLFieldTag;
    if First then
    begin
      fname := 'WORDFLD_' + FldNames[FldType] + '_';
      tfIdx := FldType;
      tmp := tmp + ' ' + TemplateFieldExportTag[tfName] + '="' + Text2XML(fname);
    end;
    if not First then
      tmp := tmp + '>';
    Fields.Add(tmp);
    if First then
      AddField(tfType, TemplateFieldTypeCodes[FldType]);
  end;

  procedure WordWrap(var Str: string);
  var
    TmpSL: TStringList;
    i: integer;

  begin
    TmpSL := TStringList.Create;
    try
      TmpSL.Text := Str;
      Str := '';
      for i := 0 to TmpSL.Count-1 do
      begin
        if Str <> '' then
          Str := Str + CRLF;
        Str := Str + WrapText(TmpSL[i], #13#10, [' ','-'], MAX_ENTRY_WIDTH);
      end;
    finally
      TmpSL.Free;
    end;
  end;

begin
  for tfIdx := low(TTemplateFieldType) to high(TTemplateFieldType) do
    tfCount[tfIdx] := 1;
  TemplateName := ExtractFileName(AFileName);
  Result := TRUE;
  try
    OldCur := Screen.Cursor;
    Screen.Cursor := crAppStart;
    try
      WApp := TWordApplication.Create(nil);
      try
        WasVis := WApp.Visible;
        WApp.Visible := FALSE;
        try
          WDoc := TWordDocument.Create(nil);
          try
            try
              WApp.Connect;
              TmpVar := AFileName;
              {$IFDEF VER140}
              WDoc.ConnectTo(WApp.Documents.Add(TmpVar, EmptyParam));
              {$ELSE}
              WDoc.ConnectTo(WApp.Documents.Add(TmpVar, EmptyParam, EmptyParam, EmptyParam));
              {$ENDIF}
              ffTotal := WDoc.FormFields.Count;

              if ffTotal > 3 then
                StartImportMessage(TemplateName, ffTotal+1);

              if WDoc.ProtectionType <> wdNoProtection then
                WDoc.Unprotect;

              Data.Add('<'+XMLHeader+'>');

              tmp := ExtractFileExt(TemplateName);
              if tmp <> '' then
              begin
                i := pos(tmp,TemplateName);
                if i > 0 then
                  delete(TemplateName, i, length(tmp));
              end;
              TemplateName := copy(TemplateName, 1, 60);

              if BadTemplateName(TemplateName) then
              begin
                tmp := copy('WordDoc ' + TemplateName, 1, 60);
                if BadTemplateName(TemplateName) then
                  tmp := 'Imported Word Document'
                else
                  tmp := TemplateName;
              end
              else
                tmp := TemplateName;
              Data.Add('<' + XMLTemplateTag + ' ' + TemplateExportTag[efName] + '="' + Text2XML(tmp) + '">');
              AddXMLData(Data, '', efType, TemplateTypeCodes[ttDoc], '');
              AddXMLData(Data, '', efStatus, TemplateActiveCode[TRUE], '');

              Boiler := '';
              Fields := TStringList.Create;
              try
                FldCache := TStringList.Create;
                try
                  PendingAdd := TStringList.Create;
                  try
                    ffEndCur := 0;

                    for i := 1 to ffTotal do
                    begin
                      if UpdateImportMessage(i) then
                      begin
                        Result := FALSE;
                        Data.Clear;
                        break;
                      end;
                      idx := i;
                      ffEndLast := ffEndCur;
                      ffRange := WDoc.FormFields.Item(idx).Range;
                      ffStartCur := ffRange.Start;
                      ffEndCur := ffRange.End_;

                      // Assign working start range for text collection:
                      if i = 1 then
                        rangeStart := 0 // Before first FormField, use start of document.
                      else
                        rangeStart := ffEndLast; // Start of new range is end of the last FormField range.

                      // Assign working end range for text collection:
                      rangeEnd := ffStartCur; // End of new range is start of current FormField range.

                      // Collect text in the range:
                      textRange := WDoc.Range(rangeStart, rangeEnd);
                      textRange.Select;

                      AddBoiler(TextRange.text);
                      tfIdx := dftUnknown;
                      fname := '';
                      case WDoc.FormFields.Item(idx).type_ of
                        wdFieldFormTextInput:
                          begin
                            itmp3 := WDoc.FormFields.Item(idx).TextInput.Type_;
                            case itmp3 of
                              wdNumberText: tmpType := dftNumber;
                              wdDateText, wdCurrentDateText, wdCurrentTimeText: tmpType := dftDate;
                              else tmpType := dftEditBox;
                            end;
                            AddFieldHeader(tmpType, TRUE);
                            tmpDate := dtUnknown;
                            tmp := WDoc.FormFields.Item(idx).TextInput.Default;
                            case itmp3 of
                              wdNumberText:
                                begin
                                  AddField(tfMinVal, IntToStr(-9999), TRUE);
                                  AddField(tfMaxVal, IntToStr(9999), TRUE);
                                end;

                              wdDateText: tmpDate := dtDate;
                              wdCurrentDateText:
                                begin
                                  tmpDate := dtDate;
                                  if tmp = '' then
                                    tmp := 'T';
                                end;
                              wdCurrentTimeText:
                                begin
                                  tmpDate := dtDateTime;
                                  if tmp = '' then
                                    tmp := 'NOW';
                                end;
                              else
                                begin
                                  itmp2 := WDoc.FormFields.Item(idx).TextInput.Width;
                                  itmp := itmp2;
                                  if (itmp < 1) then
                                  begin
                                    itmp := length(tmp);
                                    if itmp < 10 then
                                      itmp := 10
                                    else
                                    if itmp > 70 then
                                      itmp := 70;
                                    itmp2 := 240;
                                  end
                                  else
                                  begin
                                    if (itmp > 70) then
                                      itmp := 70;
                                    if (itmp2 > 240) then
                                      itmp2 := 240;
                                  end;
                                  AddField(tfLength, IntToStr(itmp));
                                  AddField(tfTextLen, IntToStr(itmp2), TRUE);
                                end;
                            end;
                            if tmpDate <> dtUnknown then
                              AddField(tfDateType, TemplateFieldDateCodes[tmpDate], TRUE);
                            if tmp <> '' then
                              AddField(tfDefault, tmp);
                            FastAddStrings(PendingAdd, Fields);
                            PendingAdd.Clear;
                            AddFieldHeader(tmpType, FALSE);
                          end;

                        wdFieldFormCheckBox:
                          begin
                            AddFieldHeader(dftButton, TRUE);
                            itmp := ord(boolean(WDoc.FormFields.Item(idx).CheckBox.Default))+1;
                            AddField(tfDefIdx, IntToStr(itmp));
                            Fields.Add('<' + TemplateFieldExportTag[tfItems] + '>');
                            Fields.Add('<p>' + Text2XML('[ ]') + '</p>');
                            Fields.Add('<p>' + Text2XML('[X]') + '</p>');
                            Fields.Add('</' + TemplateFieldExportTag[tfItems] + '>');
                            AddFieldHeader(dftButton, FALSE);
                          end;

                        wdFieldFormDropDown:
                          begin
                            ddTotal := WDoc.FormFields.Item(Idx).DropDown.ListEntries.Count;
                            if(ddTotal > 0)then
                            begin
                              AddFieldHeader(dftComboBox, TRUE);
                              itmp := WDoc.FormFields.Item(idx).DropDown.Default;
                              if itmp > 0 then
                                AddField(tfDefIdx, IntToStr(itmp));

                              Fields.Add('<' + TemplateFieldExportTag[tfItems] + '>');
                              for j := 1 to ddTotal do
                              begin
                                TmpVar := j;
                                tmp := WDoc.FormFields.Item(Idx).DropDown.ListEntries.Item(TmpVar).Name;
                                Fields.Add('<p>' + Text2XML(tmp) + '</p>');
                              end;
                              Fields.Add('</' + TemplateFieldExportTag[tfItems] + '>');
                              AddFieldHeader(dftComboBox, FALSE);
                            end;
                          end;
                      end;
                      if (Fields.Count > 0) then
                      begin
                        if tfIdx <> dftUnknown then
                        begin
                          tmp := Fields.CommaText;
                          j := FldCache.IndexOf(tmp);
                          if j < 0 then
                          begin
                            FldCache.AddObject(tmp, TObject(tfCount[tfIdx]));
                            j := tfCount[tfIdx];
                            inc(tfCount[tfIdx]);
                          end
                          else
                            j := Integer(FldCache.Objects[j]);
                          Boiler := Boiler + TemplateFieldBeginSignature + fname + IntToStr(j) + TemplateFieldEndSignature;
                        end;
                        Fields.Clear;
                      end;
                    end;
                    if Result then
                    begin
                      rangeStart := ffEndCur; // Start of new range is end of last FormField range.
                      rangeEnd := WDoc.Range.End_; // After last FormField, use end of document.

                      // Collect text in trailing range:
                      textRange := WDoc.Range(rangeStart, rangeEnd);
                      textRange.Select;

                      AddBoiler(TextRange.text);

                      WordWrap(Boiler);

                      AddXMLList(Data, nil, '', efBoilerplate, Boiler);

                      tmp := WrapText('Imported on ' + FormatFMDateTime('mmm dd yyyy hh:nn', FMNow) +
                                      ' from Word Document: ' + AFileName, #13#10, [' '], MAX_ENTRY_WIDTH);

                      AddXMLList(Data, nil, '', efDescription, tmp);

                      Data.Add('</' + XMLTemplateTag + '>');
                      if FldCache.Count > 0 then
                      begin
                        Data.Add('<' + XMLTemplateFieldsTag + '>');
                        for i := 0 to FldCache.Count-1 do
                        begin
                          Fields.Clear;
                          Fields.CommaText := FldCache[i];
                          if Fields.Count > 0 then
                          begin
                            Fields[0] := Fields[0] + IntToStr(Integer(FldCache.Objects[i])) + '">';
                            FastAddStrings(Fields, Data);
                          end;
                        end;
                        Data.Add('</' + XMLTemplateFieldsTag + '>');
                      end;

                      Data.Add('</'+XMLHeader+'>');
                      UpdateImportMessage(ffTotal+1);
                    end;
                  finally
                    PendingAdd.Free;
                  end;
                finally
                  FldCache.Free;
                end;
              finally
                Fields.Free;
              end;

            except
              on E:Exception do
                WordImportError(E.Message);
            end;
          finally
            TmpVar := wdDoNotSaveChanges;
            WDoc.Close(TmpVar);
            WDoc.Free;
          end;
        finally
          WApp.Visible := WasVis;
        end;
      finally
        WApp.Disconnect;
        WApp.Free;
      end;
    finally
      Screen.Cursor := OldCur;
    end;
  finally
    StopImportMessage;
  end;
  if not Result then
    InfoBox('Importing Word Document Canceled.','Import Canceled', MB_OK);
end;

function WordImportActive: boolean;
begin
  Result := True;
  //Result := SpellCheckAvailable;   spell check disabled in v19.16
end;

procedure UnlockAllTemplates;
var
  i: integer;

begin
  if(assigned(Templates)) then
  begin
    for i := 0 to Templates.Count-1 do
      TTemplate(Templates.Objects[i]).Unlock;
  end;
end;

function DisplayGroupToLinkType(DGroup: integer): TTemplateLinkType;
begin
  Result := ltNone;
  if DGroup <> 0 then
  begin
    if uDGroupConsults = 0 then
      uDGroupConsults := DisplayGroupByName('CONSULTS');
    if uDGroupProcedures = 0 then
      uDGroupProcedures := DisplayGroupByName('PROCEDURES');
    if DGroup = uDGroupConsults then
      Result := ltConsult
    else
    if DGroup = uDGroupProcedures then
      Result := ltProcedure;
  end;
end;

(*procedure ExecuteTemplateOrBoilerPlate(SL: TStrings; IEN: Integer; LType: TTemplateLinkType;
                                       OwningForm: TForm; const CaptionText: string = ''; DocInfo: string = '');*)
procedure ExecuteTemplateOrBoilerPlate(SL: TStrings; IEN: Integer; LType: TTemplateLinkType;
                                       OwningForm: TForm; CaptionText: string; var DocInfo: string);
//kt doc.  This procedure is called from many places in CPRS
var
  Template: TTemplate;
  txt: string;
  TempSL : TStringList; //kt added 5/16
  s, ErrStr  : string; //kt added 5/16
  IEN8925, i : integer;  //kt 5/16
  DBControlData : TDBControlData;  //kt added 5/16

begin
  SetTemplateDialogCanceled(FALSE);
  SetTemplateBPHasObjects(FALSE);
  Template := GetLinkedTemplate(IntToStr(IEN), LType);
  DBControlData := TDBControlData.Create ;  //kt added 5/16
  if assigned(Template) then begin
    if Template.IsReminderDialog then begin
      Template.ExecuteReminderDialog(OwningForm);
      DocInfo := '';
    end else begin
      if Template.IsCOMObject then begin
        txt := Template.COMObjectText(SL.Text, DocInfo)
      end else begin
        //kt original --> txt := Template.Text;
        txt := Template.GetText(DBControlData); //kt
        DocInfo := '';
      end;
      if(txt <> '') then begin
        //kt original --> CheckBoilerplate4Fields(txt, CaptionText);
        CheckBoilerplate4Fields(txt, CaptionText, [], DBControlData);
        SL.Text := txt;
      end;
    end;
  end else begin
    txt := SL.Text;
    //kt original --> CheckBoilerplate4Fields(txt, CaptionText);
    CheckBoilerplate4Fields(txt, CaptionText, [], DBControlData);
    DocInfo := '';
    SL.Text := txt;
  end;
  //kt 5/16 begin mod ------------------
  if DBControlData.count > 0 then begin
    IEN8925 := 0;
    TempSL := TStringList.Create;
    TempSL.Text := DocInfo;
    for i := 0 to TempSL.Count - 1 do begin
      s := TempSL.Strings[i];
      if Pos('<DOC_IEN>', s) = 0 then continue;  //'<DOC_IEN>' matches that from MakeXMLParamTIU()
      s := piece2(piece2(s, '<DOC_IEN>', 2),'</',1);
      IEN8925 := StrToIntDef(s, 0);
      break;
    end;
    TempSL.Free;
    DBControlData.SaveToServer(IEN8925, ErrStr);
    if ErrStr <> '' then MessageDlg(ErrStr, mtError, [mbOK], 0);
  end;
  DBControlData.Free; //kt added 5/16
  //kt 5/16 end mod ------------------
end;

(*procedure ExecuteTemplateOrBoilerPlate(var AText: string; IEN: Integer; LType: TTemplateLinkType;
                                       OwningForm: TForm; const CaptionText: string = ''; DocInfo: string = '');*)
procedure ExecuteTemplateOrBoilerPlate(var AText: string; IEN: Integer; LType: TTemplateLinkType;
                                       OwningForm: TForm; CaptionText: string; var DocInfo: string);

var
  tmp: TStringList;

begin
  tmp := TStringList.Create;
  try
    tmp.text := AText;
    ExecuteTemplateOrBoilerPlate(tmp, IEN, LType, OwningForm, CaptionText, DocInfo);
    AText := tmp.text;
  finally
    tmp.free;
  end;
end;

{ TTemplate }

constructor TTemplate.Create(DataString: string);
var
  i: TTemplateType;
  Code: string[8];  //kt 5/15 changed length from 2 --> 8

begin
  FCloning := TRUE;
  try
    FBkup.BLinkedDxs := TStringList.Create;  //kt
    FLinkedDxs := TStringList.Create;        //kt
    FFieldsUsed  := TStringList.Create;        //kt 5/16
    FNodes := TStringList.Create;
    FID := Piece(DataString, U, 1);
    Code := Piece(DataString, U, 2);
    FRealType := ttNone;
    for i := FirstRealTemplateType to LastRealTemplateType do
    begin
      if(TemplateTypeCodes[i] = Code) then
      begin
        FRealType := i;
        break;
      end;
    end;
    if FRealType = ttNone then
      raise ETemplateError.Create('Template has invalid Type Code of "' + Code + '"');
    FActive := (Piece(DataString, U, 3) = TemplateActiveCode[TRUE]);
    FPrintName := Piece(DataString, U, 4);
    FExclude := (Piece(DataString, U, 5) = '1');
    //kt original --> FDialog :=  (Piece(DataString, U, 9) = '1');
    FDialog :=  (Piece(DataString, U, 9) <> '0');  //kt mod 6/16
    FEmbeddedDialog :=  (Piece(DataString, U, 9) = '2'); //kt added 6/16
    FDisplayOnly := (Piece(DataString, U, 10) = '1');
    FFirstLine := (Piece(DataString, U, 11) = '1');
    FOneItemOnly := (Piece(DataString, U, 12) = '1');
    FHideDlgItems := (Piece(DataString, U, 13) = '1');
    FHideItems := (Piece(DataString, U, 14) = '1');
    FIndentItems := (Piece(DataString, U, 15) = '1');
    FLock := (Piece(DataString, U, 18) = '1');
    FReminderDialog := Pieces(DataString, U, 16, 17);
    FReminderDialog := FReminderDialog + U + Piece(DataString, U, 25); //AGP CHANGE 24.8
    FIsReminderDialog := (ReminderDialogIEN <> '');
    FCOMObject := StrToIntDef(Piece(DataString, U, 19), 0);
    FCOMParam := Piece(DataString, U, 20);
    FFileLink := Piece(DataString, U, 21);
    FIsCOMObject := (FCOMObject > 0);
    FGap := StrToIntDef(Piece(DataString, U, 6),0);
    FPersonalOwner := StrToInt64Def(Piece(DataString, U, 7),0);
    case StrToIntDef(Piece(DataString, U, 8),0) of
      1: FChildren := tcActive;
      2: FChildren := tcInactive;
      3: FChildren := tcBoth;
      else FChildren := tcNone;
    end;
    FLocked := FALSE;
  finally
    FCloning := FALSE;
  end;
end;

class function TTemplate.CreateFromXML(Element: IXMLDOMNode; Owner: string): TTemplate;
var
  DataStr: string;
  Children, Items: IXMLDOMNodeList;
  Child, Item: IXMLDOMNode;
  i, j, count, ItemCount: integer;
  fld: TTemplateExportField;
  ETag: string;

begin
  DataStr := '0';
  SetPiece(DataStr, U, 4, FindXMLAttributeValue(Element, TemplateExportTag[efName]));
  SetPiece(DataStr, U, 7, Owner);
  Children := Element.Get_childNodes;
  try
    if assigned(Children) then
    begin
      count := Children.Length;
      for i := 0 to Count - 1 do
      begin
        Child := Children.Item[i];
        ETag := Child.NodeName;
        for fld := low(TTemplateExportField) to high(TTemplateExportField) do
        begin
          if(ExportPieces[fld] > 0) and (CompareText(ETag, TemplateExportTag[fld]) = 0) then
            SetPiece(DataStr, U, ExportPieces[fld], Child.Get_Text);
        end;
      end;
    end
    else
      Count := 0;
    Result := Create(DataStr);
    Result.FCloning := TRUE;
    try
      if assigned(Children) then
      begin
        for i := 0 to Count - 1 do
        begin
          Child := Children.Item[i];
          ETag := Child.NodeName;
          for fld := low(TTemplateExportField) to high(TTemplateExportField) do
          begin
            if(ExportPieces[fld] = 0) and (CompareText(ETag, TemplateExportTag[fld]) = 0) then
            begin
              case fld of
                efBoilerplate: Result.SetBoilerplate(GetXMLWPText(Child));
                efDescription: Result.SetDescription(GetXMLWPText(Child));
                efItems:
                  begin
                    Result.GetItems;
                    Items := Child.Get_childNodes;
                    if assigned(Items) then
                    begin
                      ItemCount := Items.Length;
                      for j := 0 to ItemCount - 1 do
                      begin
                        Item := Items.Item[j];
                        if(CompareText(Item.NodeName, XMLTemplateTag) = 0) then
                          Result.FItems.Add(CreateFromXML(Item, Owner));
                      end;
                    end;
                  end;
              end;
            end;
          end;
        end;
      end;
    finally
      Result.FCloning := FALSE;
    end;
  finally
    Children := nil;
  end;
  Result.BackupItems;
  Templates.AddObject(Result.ID, Result);
end;

destructor TTemplate.Destroy;
begin
  Unlock;
  FNodes.Free;
  FBkup.BLinkedDxs.Free; //kt
  FLinkedDxs.Destroy;    //kt
  FFieldsUsed.Free;      //kt 5/16
  if(assigned(FItems)) then FItems.Free;
  inherited;
end;

procedure TTemplate.AddChild(Child: TTemplate);
begin
  GetItems;
  if(FItems.IndexOf(Child) < 0) then
    FItems.Add(Child);
end;

procedure TTemplate.RemoveChild(Child: TTemplate);
var
  idx: integer;

begin
  GetItems;
  idx := FItems.IndexOf(Child);
  if(idx >= 0) and CanModify then
    FItems.delete(idx);
end;

function TTemplate.GetItems: TList;
begin
  if(not assigned(FItems)) then
  begin
    FItems := TList.Create;
    FCreatingChildren := TRUE;
    try
      ExpandTemplate(Self);
    finally
      FCreatingChildren := FALSE;
    end;
  end;
  Result := FItems;
end;

procedure TTemplate.TMGForceSetFullBoilerplate(Value : string);
//kt added 6/15
begin
  FBoilerplate := Value;
  FUppercaseBoilerplate := Uppercase(FBoilerplate); //kt 6/16
  FBoilerPlateLoaded := TRUE;
end;

procedure TTemplate.ClearChildren;     //elh  //kt
begin
  {if(assigned(TempSL)) then
  begin
    TempSL.Free;
    TempSL := nil;
  end;}
  //self.FNodes.Clear;
  //self.FItems.Clear;
  //self.free;
  if assigned(FNodes) then FNodes.clear;
  if assigned(FItems) then FItems.Clear;
  uTemplateDataLoaded := False;
  FreeAndNil(FItems);
  FBoilerplateLoaded := False;
  Expanded := False;
end;

function TTemplate.GetTemplateType: TTemplateType;
begin
  Result := FRealType;
  if(Result in [ttDoc, ttGroup]) and (FExclude) then
  begin
    case (Result) of
      ttDoc:   Result := ttDocEx;
      ttGroup: Result := ttGroupEx;
    end;
  end;
end;

function TTemplate.GetChildren: TTemplateChildren;
var
  i: integer;

begin
  if((assigned(FItems)) and (not FCreatingChildren)) then
  begin
    Result := tcNone;
    for i := 0 to FItems.Count-1 do
    begin
      if(TTemplate(FItems[i]).Active) then
        Result := TTemplateChildren(ord(Result) or ord(tcActive))
      else
        Result := TTemplateChildren(ord(Result) or ord(tcInactive));
      if(Result = tcBoth) then break;
    end;
  end
  else
    Result := FChildren;
end;

procedure TTemplate.SetTemplateType(const Value: TTemplateType);
begin
  if(GetTemplateType <> Value) and CanModify then
  begin
    if(Value in AllTemplateTrueTypes) then
      SetRealType(Value)
    else
    begin
      case Value of
        ttDoc:     begin SetExclude(FALSE); SetRealType(ttDoc);   end;
        ttGroup:   begin SetExclude(FALSE); SetRealType(ttGroup); end;
        ttDocEx:   begin SetExclude(TRUE);  SetRealType(ttDoc);   end;
        ttGroupEx: begin SetExclude(TRUE);  SetRealType(ttGroup); end;
      end;
    end;
  end;
end;

procedure TTemplate.ExtractFieldUsedListFromBoilerplate;
//kt added entire function 5/16
var p1, p2 : integer;
    FldName : string;
    L : byte;
begin
  FFieldsUsed.Clear;
  p2:= 1;
  L := length(TemplateFieldBeginSignature);
  repeat
    p1 := PosEx(TemplateFieldBeginSignature, FBoilerplate, p2);
    if p1 > 0 then begin
      p1 := p1+L;
      p2 := PosEx(TemplateFieldEndSignature, FBoilerplate, p1);
      if p2 > 0 then begin
        FldName := MidStr(FBoilerplate, p1, p2-p1);
        FFieldsUsed.Add(FldName);
      end else begin
        p2 := p1;
      end;
    end;
  until p1=0;
end;

function TTemplate.BoilerplateContainsScript : boolean;
//kt added entire function 6/16
const SCRIPT_TAG = '<SCRIPT';
  //note: white space between < and tag name not allowed in HTML standard
  //NOTE: white space AFTER SCRIPT is allowed, as are other parameters / properties. So no closing '>' in SCRIPT_TAG
begin
  //NOTE: This function may be called repeatedly as the user types the template,
  //      so I want this function to be quick.
   Result := (Pos(SCRIPT_TAG, FUppercaseBoilerplate) > 0);
end;

function TTemplate.GetBoilerplate: string;
begin
  Result := '';
  if FIsReminderDialog or FIsCOMObject then exit;
  if(RealType in [ttDoc, ttGroup]) then
  begin
    //if Pos(DYNAMIC_NAMESPACE,FPrintName)>0 then FBoilerPlateLoaded := False;   //elh added to refresh dynamic templates
    if(not FBoilerPlateLoaded) then
    begin
      //messagedlg('Updating',mtInformation,[mbOK],0);
      StatusText('Loading Template Boilerplate...');
      try
        GetTemplateBoilerplate(FID);
        FBoilerplate := RPCBrokerV.Results.Text;
        FUppercaseBoilerplate := Uppercase(FBoilerplate); //kt 6/16
        FBoilerPlateLoaded := TRUE;
        ExtractFieldUsedListFromBoilerplate; //kt added
      finally
        StatusText('');
      end;
    end;
    Result := FBoilerplate;
  end;
end;

{ Returns the cumulative boilerplate of a groups items }
function TTemplate.ItemBoilerplate: string;
var
  i, j: integer;
  Template: TTemplate;
  GapStr: string;

begin
  Result := '';
  if FIsReminderDialog or FIsCOMObject then exit;
  if(RealType = ttGroup) then
  begin
    GetItems;
    GapStr := '';
    if(FGap > 0) then
    begin
      for j := 1 to FGap do
        GapStr := GapStr + CRLF;
    end;
    if(IndentItems) then
      inc(uIndentLevel);
    try
      for i := 0 to FItems.Count-1 do
      begin
        Template := TTemplate(FItems[i]);
        if(Template.Active and (Template.TemplateType in [ttDoc, ttGroup])) then
        begin
          if i > 0 then
            Result := Result + GapStr;
          Result := Result + DlgText(TTemplate(FItems[i]).FullBoilerplate,
                                     TTemplate(FItems[i]).DialogProperties(Self));
        end;
      end;
    finally
      if(IndentItems) then
        dec(uIndentLevel);
    end;
  end;
end;

{returns the complete boilerplate, including a group's items }
function TTemplate.FullBoilerplate: string;
var
  Itm: string;
begin
  //if Pos(DYNAMIC_NAMESPACE,FPrintName)>0 then FBoilerPlateLoaded := False;   //elh added to refresh dynamic templates
  Result := GetBoilerplate;
  if FIsReminderDialog or FIsCOMObject then exit;
  Itm := ItemBoilerplate;
  if(Result <> '') and (Itm <> '') and (copy(Result,length(Result)-1,2) <> CRLF) then
    Result := Result + CRLF;
  Result := DlgText(Result, DialogProperties) + Itm;
end;

{Sets the items boilerplate - does not affect children boilerplates of a group }
procedure TTemplate.SetBoilerplate(Value: string);
begin
  if(FBoilerplate <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(FBoilerPlateLoaded and (not SavedBoilerplate) and ValidID) then
      begin
        BBoilerplate := FBoilerplate;
        SavedBoilerplate := TRUE;
      end;
    end;
    FBoilerplate := Value;
    FUppercaseBoilerplate := Uppercase(FBoilerplate); //kt 6/16
    ExtractFieldUsedListFromBoilerplate; //kt added
  end;
  FBoilerPlateLoaded := TRUE;
end;

{Gets the object-expanded boilerplated text}
//kt original --> function TTemplate.GetText: string;
function TTemplate.GetText(DBControlData : pointer): string;  //NOTE: should actually be TDBControlData
var
  OldGettingDialogText: boolean;
  TmpSL: TStringList;
  DlgMode : TDialogModesSet; //kt 1/16

begin
  Result := '';
  if FIsReminderDialog or FIsCOMObject then exit;
  TmpSL := TStringList.Create;
  try
    StatusText('Expanding Boilerplate Text...');
    try
      OldGettingDialogText := GettingDialogText;
      //kt 6/16 original -->  if (IsDialog) then begin
      if (IsDialog and not EmbeddedDialog) then begin  //kt 6/16
        GettingDialogText := TRUE;
        inc(uDlgCount);
        if not OldGettingDialogText then
          uIndentLevel := 0;
      end;
      try
        TmpSL.Text := FullBoilerPlate;
        if Pos('|', TmpSL.Text) > 0 then SetTemplateBPHasObjects(TRUE);
      finally
        //kt 6/16 original -->  if (IsDialog) then begin
        if (IsDialog and not EmbeddedDialog) then begin  //kt 6/16
          GettingDialogText := OldGettingDialogText;
        end;
      end;
      GetTemplateText(TmpSL);
      //kt 6/16 original -->  if (IsDialog) then begin
      if (IsDialog and not EmbeddedDialog) then begin  //kt 6/16
        if TemplatePreviewMode then DlgMode := [tPreview] else DlgMode := []; //kt 1/16 added
        //kt original --> FDialogAborted := DoTemplateDialog(TmpSL, 'Template: ' + FPrintName, TemplatePreviewMode);
        FDialogAborted := DoTemplateDialog(TmpSL, 'Template: ' + FPrintName, DlgMode, TDBControlData(DBControlData));
      end;
      Result := TmpSL.Text;
    finally
      StatusText('');
    end;
  finally
    TmpSL.Free;
  end;
end;

procedure TTemplate.SetPersonalOwner(Value: Int64);
var
  i: integer;
  ok: boolean;

begin
  if(FPersonalOwner <> Value) then
  begin
    ok := CanModify;
    if ok then
    begin
      with FBkup do
      begin
        if(not SavedPersonalOwner) and ValidID then
        begin
          BPersonalOwner := FPersonalOwner;
          SavedPersonalOwner := TRUE;
        end;
      end;
      FPersonalOwner := Value;
    end;
  end
  else
    ok := TRUE;
  if ok and (Value = 0) then // No Shared Template can have personal items within it.
  begin
    GetItems;
    for i := 0 to FItems.Count-1 do
      TTemplate(FItems[i]).SetPersonalOwner(0);
  end;
end;

procedure TTemplate.AddNode(Node: Pointer);
begin
  if(dmodShared.InEditor) and (FNodes.IndexOfObject(Node) < 0) then
  begin
    inc(NodeCount);
    FNodes.AddObject(IntToStr(NodeCount),Node);
  end;
end;

procedure TTemplate.RemoveNode(Node: Pointer);
var
  idx: integer;

begin
  if(dmodShared.InEditor) then
  begin
    idx := FNodes.IndexOfObject(Node);
    if(idx >= 0) then FNodes.Delete(idx);
  end;
end;

{ Creates a new Template that looks like the old one, but with a new Owner  }
{ - an example of where this is needed:  when a shared template in a user's }
{   personal folder is modified, we need to create a copy of the shared     }
{   template, make it a personal template, and make the changes to the copy }
function TTemplate.Clone(Owner: Int64): TTemplate;
var
  i: integer;

begin
  Result := Self;
  if(FPersonalOwner <> Owner) and (RealType in [ttDoc, ttGroup, ttClass]) then
  begin
    Result := TrueClone;
    Result.FCloning := TRUE;
    try
      Result.FID := '0';
      GetItems;
      Result.FPersonalOwner := Owner;
      Result.Expanded := TRUE;
      Result.GetItems;
      for i := 0 to Items.Count-1 do
        Result.Items.Add(Items[i]);
      Result.BackupItems;
      Templates.AddObject(Result.ID, Result);
    finally
      Result.FCloning := FALSE;
    end;
  end;
end;

{ Creates a duplicate Template - used for backups and comparrisons }
function TTemplate.TrueClone: TTemplate;
var
  Code, DataStr: string;

begin
  DataStr := ID+U+TemplateTypeCodes[RealType]+U+TemplateActiveCode[Active]+U+PrintName+U;
  if(Exclude) then
    DataStr := DataStr + '1'
  else
    DataStr := DataStr + '0';
  case GetChildren of
    tcActive:    Code := '1';
    tcInactive:  Code := '2';
    tcBoth:      Code := '3';
    else         Code := '0';
  end;
  DataStr := DataStr + U + IntToStr(Gap) + U + IntToStr(PersonalOwner) + U + Code + U +
             BOOLCHAR[Dialog] + U +
             BOOLCHAR[DisplayOnly] + U +
             BOOLCHAR[FirstLine] + U +
             BOOLCHAR[OneItemOnly] + U +
             BOOLCHAR[HideDlgItems] + U +
             BOOLCHAR[HideItems] + U +
             BOOLCHAR[IndentItems] + U +
             FReminderDialog;
  SetPiece(DataStr,U,18,BOOLCHAR[Lock]);
  SetPiece(DataStr,U,19,IntToStr(COMObject));
  SetPiece(DataStr,U,20,COMParam);
  SetPiece(DataStr,U,21,FileLink);
  Result := TTemplate.Create(DataStr);
  Result.FCloning := TRUE;
  try
    Result.SetBoilerplate(GetBoilerplate);
    Result.SetDescription(GetDescription);
  finally
    Result.FCloning := FALSE;
  end;
end;

function TTemplate.ItemIENs: string;
var
  i: integer;

begin
  GetItems;
  Result := '';
  for i := 0 to FItems.Count-1 do
    Result := Result + TTemplate(FItems[i]).FID+',';
end;

function TemplateChildrenCompare(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(TTemplate(Item1).PrintName,TTemplate(Item2).PrintName);
end;

procedure TTemplate.SortChildren;
begin
  GetItems;
  if (FItems.Count > 1) and CanModify then
    FItems.Sort(TemplateChildrenCompare);
end;

procedure TTemplate.BackupItems;
begin
  with FBkup do
  begin
    if((not SavedItemIENs) and assigned(FItems)) then
    begin
      BItemIENs := ItemIENs;
      SavedItemIENs := TRUE;
    end;
  end;
end;

procedure TTemplate.SetActive(const Value: boolean);
begin
  if(FActive <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedActive) and ValidID then
      begin
        BActive := FActive;
        SavedActive := TRUE;
      end;
    end;
    FActive := Value;
  end;
end;

procedure TTemplate.SetExclude(const Value: boolean);
begin
  if(FExclude <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedExclude) and ValidID then
      begin
        BExclude := FExclude;
        SavedExclude := TRUE;
      end;
    end;
    FExclude := Value;
  end;
end;

procedure TTemplate.SetDialog(const Value: boolean);
begin
  if(FDialog <> Value) and CanModify then begin
    with FBkup do begin
      if(not SavedDialog) and ValidID then begin
        BDialog := FDialog;
        SavedDialog := TRUE;
      end;
    end;
    FDialog := Value;
  end;
  if Value = false then SetEmbeddedDialog(Value);  //kt added 6/16.  If Dialog=false then EmbeddedDialog should also be false;
end;

procedure TTemplate.SetEmbeddedDialog(const Value: boolean);
//kt added entire function 6/16
begin
  if(FEmbeddedDialog <> Value) and CanModify then begin
    with FBkup do begin
      if(not SavedEmbeddedDialog) and ValidID then begin
        BEmbeddedDialog := FEmbeddedDialog;
        SavedEmbeddedDialog := TRUE;
      end;
    end;
    FEmbeddedDialog := Value;
  end;
  if Value = true then SetDialog(Value);  //kt added If EmbeddedDialog=true, then Dialog should also be true;
  //kt NOTE: it is OK to have Dialog=true and EmbeddedDialg=false.
end;

procedure TTemplate.SetGap(const Value: integer);
begin
  if(FGap <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedGap) and ValidID then
      begin
        BGap := FGap;
        SavedGap := TRUE;
      end;
    end;
    FGap := Value;
  end;
end;

procedure TTemplate.SetPrintName(const Value: string);
begin
  if(FPrintName <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedPrintName) and ValidID then
      begin
        BPrintName := FPrintName;
        SavedPrintName := TRUE;
      end;
    end;
    FPrintName := Value;
  end;
end;

procedure TTemplate.SetRealType(const Value: TTemplateType);
begin
  if(FRealType <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedRealType) and ValidID then
      begin
        BRealType := FRealType;
        SavedRealType := TRUE;
      end;
    end;
    FRealType := Value;
    if(FFileLink <> '') and (not (FRealType in [ttDoc, ttGroup])) then
      SetFileLink('');
  end;
end;

procedure TTemplate.ClearBackup(ClearItemIENs: boolean = TRUE);
begin
  with FBkup do
  begin
    SavedPrintName := FALSE;
    SavedGap := FALSE;
    SavedRealType := FALSE;
    SavedActive := FALSE;
    SavedDisplayOnly := FALSE;
    SavedFirstLine := FALSE;
    SavedOneItemOnly := FALSE;
    SavedHideDlgItems := FALSE;
    SavedHideItems := FALSE;
    SavedIndentItems := FALSE;
    SavedLock := FALSE;
    SavedExclude := FALSE;
    SavedDialog := FALSE;
    SavedEmbeddedDialog := FALSE;  //kt added 6/16
    SavedPersonalOwner := FALSE;
    SavedBoilerPlate := FALSE;
    SavedDescription := FALSE;
    SavedReminderDialog := FALSE;
    SavedCOMObject := FALSE;
    SavedCOMParam := FALSE;
    SavedFileLink := FALSE;
    SavedLinkedDxs := FALSE; //kt
    if(ClearItemIENs) then
    begin
      if(FExpanded) then
      begin
        BItemIENs := ItemIENs;
        SavedItemIENs := TRUE;
      end
      else
        SavedItemIENs := FALSE;
    end;
  end;
end;

function TTemplate.Changed: boolean;
begin
  Result := not ValidID;
  with FBkup do
  begin
    if(not Result) and (SavedPrintName)      then Result := (BPrintName      <> FPrintName);
    if(not Result) and (SavedGap)            then Result := (BGap            <> FGap);
    if(not Result) and (SavedRealType)       then Result := (BRealType       <> FRealType);
    if(not Result) and (SavedActive)         then Result := (BActive         <> FActive);
    if(not Result) and (SavedDisplayOnly)    then Result := (BDisplayOnly    <> FDisplayOnly);
    if(not Result) and (SavedFirstLine)      then Result := (BFirstLine      <> FFirstLine);
    if(not Result) and (SavedOneItemOnly)    then Result := (BOneItemOnly    <> FOneItemOnly);
    if(not Result) and (SavedHideDlgItems)   then Result := (BHideDlgItems   <> FHideDlgItems);
    if(not Result) and (SavedHideItems)      then Result := (BHideItems      <> FHideItems);
    if(not Result) and (SavedIndentItems)    then Result := (BIndentItems    <> FIndentItems);
    if(not Result) and (SavedLock)           then Result := (BLock           <> FLock);
    if(not Result) and (SavedExclude)        then Result := (BExclude        <> FExclude);
    if(not Result) and (SavedDialog)         then Result := (BDialog         <> FDialog);
    if(not Result) and (SavedEmbeddedDialog) then Result := (BEmbeddedDialog <> FEmbeddedDialog);  //kt added 6/16
    if(not Result) and (SavedPersonalOwner)  then Result := (BPersonalOwner  <> FPersonalOwner);
    if(not Result) and (SavedReminderDialog) then Result := (BReminderDialog <> FReminderDialog);
    if(not Result) and (SavedCOMObject)      then Result := (BCOMObject      <> FCOMObject);
    if(not Result) and (SavedCOMParam)       then Result := (BCOMParam       <> FCOMParam);
    if(not Result) and (SavedFileLink)       then Result := (BFileLink       <> FFileLink);
    if(not Result) and (SavedBoilerplate)    then Result := (BBoilerplate    <> FBoilerplate);
    if(not Result) and (SavedDescription)    then Result := (BDescription    <> FDescription);
    if(not Result) and (SavedLinkedDxs)      then Result := SLDiffers(BLinkedDxs, FLinkedDxs);  //kt
    if(not Result) and (SavedItemIENs)       then Result := (BItemIENs       <> ItemIENs); // Keep last
  end;
end;

procedure TTemplate.SetDescription(const Value: string);
begin
  if(FDescription <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(FDescriptionLoaded and (not SavedDescription) and ValidID) then
      begin
        BDescription := FDescription;
        SavedDescription := TRUE;
      end;
    end;
    FDescription := Value;
  end;
  FDescriptionLoaded := TRUE;
end;

function TTemplate.GetDescription: string;
begin
  if(not FDescriptionLoaded) then
  begin
    StatusText('Loading Template Boilerplate...');
    try
      LoadTemplateDescription(FID);
      FDescription := RPCBrokerV.Results.Text;
    finally
      StatusText('');
    end;
    FDescriptionLoaded := TRUE;
  end;
  Result := FDescription;
end;

procedure TTemplate.SetDisplayOnly(const Value: boolean);
begin
  if(FDisplayOnly <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedDisplayOnly) and ValidID then
      begin
        BDisplayOnly := FDisplayOnly;
        SavedDisplayOnly := TRUE;
      end;
    end;
    FDisplayOnly := Value;
  end;
end;

procedure TTemplate.SetFirstLine(const Value: boolean);
begin
  if(FFirstLine <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedFirstLine) and ValidID then
      begin
        BFirstLine := FFirstLine;
        SavedFirstLine := TRUE;
      end;
    end;
    FFirstLine := Value;
  end;
end;

procedure TTemplate.SetHideItems(const Value: boolean);
begin
  if(FHideItems <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedHideItems) and ValidID then
      begin
        BHideItems := FHideItems;
        SavedHideItems := TRUE;
      end;
    end;
    FHideItems := Value;
  end;
end;

procedure TTemplate.SetIndentItems(const Value: boolean);
begin
  if(FIndentItems <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedIndentItems) and ValidID then
      begin
        BIndentItems := FIndentItems;
        SavedIndentItems := TRUE;
      end;
    end;
    FIndentItems := Value;
  end;
end;

procedure TTemplate.SetOneItemOnly(const Value: boolean);
begin
  if(FOneItemOnly <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedOneItemOnly) and ValidID then
      begin
        BOneItemOnly := FOneItemOnly;
        SavedOneItemOnly := TRUE;
      end;
    end;
    FOneItemOnly := Value;
  end;
end;

procedure TTemplate.SetHideDlgItems(const Value: boolean);
begin
  if(FHideDlgItems <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedHideDlgItems) and ValidID then
      begin
        BHideDlgItems := FHideDlgItems;
        SavedHideDlgItems := TRUE;
      end;
    end;
    FHideDlgItems := Value;
  end;
end;

function TTemplate.DlgID: string;
begin
  Result := IntToStr(StrToIntDef(FID, 0));
  if(Result = '0') then
  begin
    if(FLastDlgCnt <> uDlgCount) then
    begin
      FLastDlgCnt := uDlgCount;
      inc(uUniqueIDNum);
      FLastUniqueID := uUniqueIDNum;
    end;
    Result := '-' + inttostr(FLastUniqueID);
  end;
end;

function TTemplate.DialogProperties(Parent: TTemplate = nil): string;
var
  Show, ToggleItems: boolean;
  bGap: integer;
  GroupIdx: string;

begin
  GroupIdx := '0';
  bGap := 0;
  if(assigned(parent)) then
  begin
    Show := ((not Parent.HideDlgItems) or (Parent.Boilerplate = ''));
//    if(Parent.Boilerplate <> '') and (Parent.OneItemOnly) then
    if(Parent.OneItemOnly) then
      GroupIdx := Parent.DlgID;
    if(Parent.RealType = ttGroup) then
      bGap := Parent.Gap;
  end
  else
    Show := TRUE;

  ToggleItems := ((HideDlgItems) and (Boilerplate <> ''));

  Result := BOOLCHAR[DisplayOnly] +
            BOOLCHAR[FirstLine] +
            BOOLCHAR[Show] +
            BOOLCHAR[ToggleItems] +
            IntToStr(bGap) +  // Depends on Gap being 1 character in length
            ';' + GroupIdx + ';' + DlgID;
  if(assigned(Parent)) then
    SetPiece(Result, ';', 4, Parent.DlgID);
  SetPiece(Result,';',5, inttostr(uIndentLevel));
end;

function TTemplate.GetDialogAborted: boolean;
begin
  Result := FDialogAborted;
  FDialogAborted := FALSE;
end;

function TTemplate.IsDialog: boolean;
begin
  Result := (FDialog and (FRealType = ttGroup));
end;

function TTemplate.CanExportXML(Data, Fields: TStringList; IndentLevel: integer = 0): boolean;
var
  Pad, Tmp: string;
  i: integer;

begin
  if BadTemplateName(PrintName) then
  begin
    InfoBox('Can not export template.' + CRLF + 'Template has an invalid name: ' +
      PrintName + '.' + BadNameText, 'Error', MB_OK or MB_ICONERROR);
    Result := FALSE;
    exit;
  end;
  Result := TRUE;
  Pad := StringOfChar(' ',IndentLevel);
  Data.Add(Pad + '<' + XMLTemplateTag + ' ' + TemplateExportTag[efName] + '="' + Text2XML(PrintName) + '">');
  AddXMLData(Data, Pad, efBlankLines, IntToStr(Gap), '0');
  if(RealType in AllTemplateRootTypes) then
    Tmp := TemplateTypeCodes[ttClass]
  else
    Tmp := TemplateTypeCodes[RealType];
  AddXMLData(Data, Pad, efType, Tmp, '');
  AddXMLData(Data, Pad, efStatus, TemplateActiveCode[Active], '');
  AddXMLBool(Data, Pad, efExclude, Exclude);
  AddXMLBool(Data, Pad, efDialog, Dialog);
  //kt NOTE: To support exporting EmbeddedDialog, would have to ensure recipient CPRS is TMG-CPRS --> difficult.  Won't implement for now...  6/16
  AddXMLBool(Data, Pad, efDisplayOnly, DisplayOnly);
  AddXMLBool(Data, Pad, efFirstLine, FirstLine);
  AddXMLBool(Data, Pad, efOneItemOnly, OneItemOnly);
  AddXMLBool(Data, Pad, efHideDialogItems, HideDlgItems);
  AddXMLBool(Data, Pad, efHideTreeItems, HideItems);
  AddXMLBool(Data, Pad, efIndentItems, IndentItems);
  AddXMLBool(Data, Pad, efLock, Lock);
  AddXMLList(Data, Fields, Pad, efBoilerplate, GetBoilerplate);
  AddXMLList(Data, Fields, Pad, efDescription, GetDescription);
  GetItems;
  if(FItems.Count > 0) then
  begin
    Data.Add(Pad + '  <' + TemplateExportTag[efItems] + '>');
    for i := 0 to FItems.Count-1 do
    begin
      Result := TTemplate(FItems[i]).CanExportXML(Data, Fields, IndentLevel + 4);
      if(not Result) then exit;
    end;
    Data.Add(Pad + '  </' + TemplateExportTag[efItems] + '>');
  end;
  Data.Add(Pad + '</' + XMLTemplateTag + '>');
end;

procedure TTemplate.UpdateImportedFieldNames(List: TStrings);
const
  SafeCode = #1 + '^@^' + #2;
  SafeCodeLen = length(SafeCode); 

var
  i, p, l1: integer;
  Tag1, Tag2, tmp: string;
  First, ok: boolean;

begin
  GetBoilerplate;
  ok := TRUE;
  First := TRUE;
  for i := 0 to List.Count-1 do
  begin
    if(Piece(List[i],U,2) = '0') then
    begin
      Tag1 := TemplateFieldBeginSignature + Piece(List[i],U,1) + TemplateFieldEndSignature;
      Tag2 := TemplateFieldBeginSignature + SafeCode + Piece(List[i],U,3) + TemplateFieldEndSignature;
      l1 := length(Tag1);
      repeat
        p := pos(Tag1, FBoilerplate);
        if(p > 0) then
        begin
          if First then
          begin
            ok := CanModify;
            First := FALSE;
          end;
          if ok then
          begin
            tmp := copy(FBoilerplate,1,p-1) + Tag2 + copy(FBoilerplate,p+l1, MaxInt);
            FBoilerplate := tmp;
          end
          else
            p := 0;
        end;
      until (p = 0);
    end;
    if not ok then break;
  end;
  if ok then
  begin
    repeat
      p := pos(SafeCode, FBoilerplate);
      if(p > 0) then
        delete(FBoilerplate, p, SafeCodeLen);
    until (p = 0);
    GetItems;
    for i := 0 to FItems.Count-1 do
      TTemplate(FItems[i]).UpdateImportedFieldNames(List);
  end;
  ExtractFieldUsedListFromBoilerplate; //kt added
end;

procedure TTemplate.SetReminderDialog(const Value: string);
begin
  if(FReminderDialog <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedReminderDialog) and ValidID then
      begin
        BReminderDialog := FReminderDialog;
        SavedReminderDialog := TRUE;
      end;
    end;
    FReminderDialog := Value;
    FIsReminderDialog := (ReminderDialogIEN <> '');
    if FIsReminderDialog and (not (LinkType in [ltNone, ltTitle])) then
      SetFileLink('');
  end;
end;

function TTemplate.ReminderDialogIEN: string;
begin
  Result := Piece(FReminderDialog,U,1);
  if Result = '0' then
    Result := '';
end;

function TTemplate.ReminderDialogName: string;
begin
  Result := Piece(FReminderDialog,U,2);
end;

function TTemplate.CanModify: boolean;
begin
  if(not FLocked) and ValidID and (not FCloning) then
  begin
    FLocked := LockTemplate(FID);
    Result := FLocked;
    if(not FLocked) then
    begin
      if(assigned(dmodShared.OnTemplateLock)) then
        dmodShared.OnTemplateLock(Self)
      else
        ShowMsg(Format(TemplateLockedText, [FPrintName]));
    end;
  end
  else
    Result := TRUE;
end;

function TTemplate.ValidID: boolean;
begin
  Result := ((FID <> '0') and (FID <> ''));
end;

function TTemplate.SLDiffers(SL1, SL2 : TStringList) : boolean;
//kt added entire function
//Compare SL1 and SL2 and return if different.
var i : integer;
begin
  Result := true;  //default to them being DIFFERENT
  if SL1.Count <> SL2.Count then exit;
  for i  := 0 to SL1.Count - 1 do begin
    if SL1.Strings[i] <> SL2.Strings[i] then exit;
  end;
  for i  := 0 to SL1.Count - 1 do begin
    if SL1.Objects[i] <> SL2.Objects[i] then exit;
  end;
  result := false;  // if we got this far, then the lists are identical, so NO difference
end;


procedure TTemplate.Unlock;
begin
  if FLocked and ValidID then
  begin
    UnlockTemplate(FID);
    FLocked := FALSE;
  end;
end;

procedure TTemplate.SetLock(const Value: boolean);
begin
  if(FLock <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedLock) and ValidID then
      begin
        BLock := FLock;
        SavedLock := TRUE;
      end;
    end;
    FLock := Value;
  end;
end;

function TTemplate.IsLocked: boolean;
begin
  Result := (FLock and (FPersonalOwner = 0)) or AutoLock;
end;

procedure TTemplate.SetCOMObject(const Value: integer);
begin
  if(FCOMObject <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedCOMObject) and ValidID then
      begin
        BCOMObject := FCOMObject;
        SavedCOMObject := TRUE;
      end;
    end;
    FCOMObject := Value;
    FIsCOMObject := (FCOMObject > 0);
  end;
end;

procedure TTemplate.SetCOMParam(const Value: string);
begin
  if(FCOMParam <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedCOMParam) and ValidID then
      begin
        BCOMParam := FCOMParam;
        SavedCOMParam := TRUE;
      end;
    end;
    FCOMParam := Value;
  end;
end;

procedure TTemplate.AssignFileLink(const Value: string; Force: boolean);
var
  i: integer;
  DoItems: boolean;

begin
  DoItems := Force;
  if(FFileLink <> Value) and CanModify then
  begin
    with FBkup do
    begin
      if(not SavedFileLink) and ValidID then
      begin
        BFileLink := FFileLink;
        SavedFileLink := TRUE;
      end;
    end;
    FFileLink := Value;
    FLinkName := '';
    if (not (LinkType in [ltNone, ltTitle])) then
      SetReminderDialog('');
    if not DoItems then
      DoItems := (FFileLink <> '');
  end;
  if DoItems then
  begin
    GetItems;
    for i := 0 to FItems.Count-1 do
      TTemplate(FItems[i]).AssignFileLink('', TRUE);
  end;
end;

procedure TTemplate.SetFileLink(const Value: string);
begin
  AssignFileLink(Value, FALSE);
end;

//function TTemplate.COMObjectText(const DefText: string = ''; DocInfo: string = ''): string;
function TTemplate.COMObjectText(DefText: string; var DocInfo: string): string;
var
  p2: string;

begin
  Result := '';
  if (FCOMObject > 0) then
  begin
    p2 := '';
    if (LinkType <> ltNone) and (LinkIEN <> '') then
      p2 := LinkPassCode[LinkType] + '=' + LinkIEN;
    Result := DefText;
    GetCOMObjectText(FCOMObject, p2, FCOMParam, Result, DocInfo);
  end;
end;

function TTemplate.AutoLock: boolean;
begin
  Result := FIsCOMObject;
  if (not Result) and (not (RealType in AllTemplateLinkTypes)) and (LinkType <> ltNone) then
      Result := TRUE;
end;

function TTemplate.LinkType: TTemplateLinkType;
var
  idx: TTemplateLinkType;

begin
  Result := ltNone;
  case FRealType of
    ttTitles:     Result := ltTitle;
    ttConsults:   Result := ltConsult;
    ttProcedures: Result := ltProcedure;
    else
      begin
        for idx := succ(low(TTemplateLinkType)) to high(TTemplateLinkType) do
        begin
          if pos(LinkGlobal[idx], FFileLink) > 0 then
          begin
            Result := idx;
            break;
          end;
        end;
      end;
  end;
end;

function TTemplate.LinkIEN: string;
begin
  Result := piece(FFileLink,';',1);
end;

function TTemplate.LinkName: string;
begin
  if FLinkName = '' then
    FLinkName := GetLinkName(LinkIEN, LinkType);
  Result := FLinkName;
end;

procedure TTemplate.ExecuteReminderDialog(OwningForm: TForm);
var
  sts: integer;
  txt: string;

begin
  sts := IsRemDlgAllowed(ReminderDialogIEN);
  txt := '';
  if sts < 0 then
    txt := 'Reminder Dialog has been Deleted or Deactivated.'
  else
  if sts = 0 then
    txt := 'You are not Authorized to use this Reminder Dialog in a Template'
  else
    ViewRemDlgTemplateFromForm(OwningForm, Self, TRUE, TRUE);
  if txt <> '' then
    InfoBox(txt,'Can not use Reminder Dialog', MB_OK or MB_ICONERROR);
end;

procedure TTemplate.LinkedDxsGet(Dest : TStringList);
//kt added
begin
  if not assigned(Dest) then exit;
  Dest.Assign(FLinkedDxs);;
end;

function TTemplate.LinkedDxsCount : integer;
//kt added
begin
  Result := FLinkedDxs.Count;
end;

procedure TTemplate.LinkedDxsAssign(Source : TStringList);
//kt added
begin
  if not assigned(Source) then exit;
  if(not FBkup.SavedLinkedDxs) then begin
    FBkup.BLinkedDxs.Assign(FLinkedDxs);
    FBkup.SavedLinkedDxs := TRUE;
  end;
  FLinkedDxs.Assign(Source);
end;

function TTemplate.LinkedDxsAdd(S : String) : integer;
//kt added
begin
  if(not FBkup.SavedLinkedDxs) then begin
    FBkup.BLinkedDxs.Assign(FLinkedDxs);
    FBkup.SavedLinkedDxs := TRUE;
  end;
  Result := FLinkedDxs.IndexOf(S);
  if Result>=0 then exit;
  Result := FLinkedDxs.Add(S);
end;



procedure ExpandEmbeddedFields(flds: TStringList);
{07/26/01  S Monson    Procedure to take a list of fields and expand it with any
                       embedded fields.  Handles embedded field loops
                       (self referencing loops.)}
var
  i,pos1,pos2: integer;
  ifield: TTemplateField;
  estring,next: string;
begin
  if flds.count < 1 then
    Exit;
  i := 0;
  repeat
    ifield := GetTemplateField(flds[i],False);
    if ifield <> nil then
      begin
        estring := '';
        case ifield.FldType of
          dftText,dftComboBox,dftButton,
          dftCheckBoxes,dftRadioButtons: estring := ifield.items;
          dftHyperlink: estring := ifield.EditDefault;
        end;
        while (estring <> '') do
          begin
            pos1 := pos(TemplateFieldBeginSignature,estring);
            if pos1 > 0 then
              begin
                estring := copy(estring,(pos1 + length(TemplateFieldBeginSignature)),maxint);
                pos2 := pos(TemplateFieldEndSignature,estring);
                if pos2 > 0 then
                  begin
                    next := copy(estring,1,pos2-1);
                    delete(estring,1,pos2-1+length(TemplateFieldEndSignature));
                    if flds.IndexOf(next) < 0 then
                      flds.add(next);
                  end
                else
                  estring := '';
              end
            else
              estring := '';
          end;
        inc(i);
      end
    else
      flds.Delete(i);
  until (i > flds.count-1);
end;

function MakeXMLParamTIU(ANoteID: string; ANoteRec: TEditNoteRec): string;
var
  tmpList: TStringList;
begin
  tmpList := TStringList.Create;
  try
    tmpList.Add('<TIU_DOC>');
    tmpList.Add('  <DOC_IEN>' + ANoteID + '</DOC_IEN>');
    tmpList.Add('  <AUTHOR_IEN>' + IntToStr(ANoteRec.Author) + '</AUTHOR_IEN>');
    tmpList.Add('  <AUTHOR_NAME>' + ExternalName(ANoteRec.Author, 200) + '</AUTHOR_NAME>');
    tmpList.Add('</TIU_DOC>');
  finally
    Result := tmpList.Text;
    tmpList.Free;
  end;
end;

function MakeXMLParamTIU(ADCSummID: string; ADCSummRec: TEditDCSummRec): string;
var
  tmpList: TStringList;
begin
  tmpList := TStringList.Create;
  try
    tmpList.Add('<TIU_DOC>');
    tmpList.Add('  <DOC_IEN>' + ADCSummID + '</DOC_IEN>');
    tmpList.Add('  <AUTHOR_IEN>' + IntToStr(ADCSummRec.Dictator) + '</AUTHOR_IEN>');
    tmpList.Add('  <AUTHOR_NAME>' + ExternalName(ADCSummRec.Dictator, 200) + '</AUTHOR_NAME>');
    tmpList.Add('</TIU_DOC>');
  finally
    Result := tmpList.Text;
    tmpList.Free;
  end;
end;

function GetXMLParamReturnValueTIU(DocInfo, ParamTag: string): string;
var
  XMLDoc: IXMLDOMDocument;
  RootElement: IXMLDOMElement;
  TagElement: IXMLDOMNode;
const
  NoIE5 = 'You must have Internet Explorer 5 or better installed to %s Templates';
  NoIE5Header = 'Need Internet Explorer 5';
  TIUHeader = 'TIU_DOC';
begin
//  After ExecuteTemplateOrBoilerPlate, DocInfo parameter may contain return value of AUTHOR.
//  Call this function at that point to get the value from the XML formatted parameter that's returned.
  Result := '';
  try
    XMLDoc := CoDOMDocument.Create;
  except
    InfoBox(Format(NoIE5, ['use COM']), NoIE5Header, MB_OK);
    exit;
  end;
  try
    if assigned(XMLDoc) then
    begin
      XMLDoc.preserveWhiteSpace := TRUE;
      if DocInfo <> '' then
        XMLDoc.LoadXML(DocInfo);
      RootElement := XMLDoc.DocumentElement;
      if not assigned(RootElement) then exit;
      try
        if(RootElement.tagName <> TIUHeader) then exit
        else
          begin
            TagElement := FindXMLElement(RootElement, ParamTag);
            if assigned(TagElement) then
              Result := TagElement.Text
            else Result := '';
          end;
      finally
        TagElement := nil;
        RootElement := nil;
      end;
    end;
  finally
    XMLDoc := nil;
  end;
end;

function TTemplate.ReminderWipe: string;
begin
   Result := Piece(FReminderDialog,U,3);
end;

// -------- CQ #8665 - RV ------------
procedure UpdatePersonalObjects;
var
  i: integer;
begin
  if not assigned(uPersonalObjects) then
  begin
    uPersonalObjects := TStringList.Create;
    GetAllowedPersonalObjects;
    for i := 0 to RPCBrokerV.Results.Count-1 do
      uPersonalObjects.Add(Piece(RPCBrokerV.Results[i],U,1));
    uPersonalObjects.Sorted := TRUE;
  end;
end;
// -----end CQ #8665 ------------


procedure SetTemplateDialogCanceled(value: Boolean);
begin
  uTemplateDialogCanceled := value;
end;  

function WasTemplateDialogCanceled: Boolean;
begin
  Result := uTemplateDialogCanceled;
end;

procedure SetTemplateBPHasObjects(value: Boolean);
begin
  uTemplateBPHasObjects := value;
end;  

function TemplateBPHasObjects: Boolean;
begin
  Result := uTemplateBPHasObjects;
end;

procedure GetLinkedDxs(NeededDxs : TStringList);
var i : integer;
    DataStr,s2,s : string;
    NewCarePlan : TTemplate;
begin
  GetCarePlanLinkedDx(NeededDxs);  //NeededDxs is altered to include results from RPC call.
  for i := 0 to NeededDxs.Count - 1 do begin
    // DataStr format is: <IEN of careplan>^ICD Code~ICD Name^ICD Code~ICD Name^ICD Code~ICD Name^.. (repeat as many times as needed.
    DataStr := pieces(NeededDxs.Strings[i],'^',2,128) ; //discard first piece.  Limits to 128 linked diagnoses per care plan.
    NewCarePlan := TTemplate(NeededDxs.Objects[i]);
    if not assigned(NewCarePlan) then continue;
    Repeat
      s2 := piece(DataStr,'^',1);  //format: ICD Code~ICD Name
      DataStr := pieces(DataStr,'^',2,128);
      s := StringReplace(s2,'~','^',[rfReplaceAll, rfIgnoreCase]);
      if s2 <> '' then NewCarePlan.LinkedDxsAdd(s);  //Add: ICD Code^ICD Name
    until s2='';
  end;
end;

function BadNameText(Mode : TcpteMode = cptemNormal) : string;
//kt added to replace CONSTANT text
begin
  Result := CRLF + CRLF + 'Valid '+TEMPLATE_MODE_NAME[Mode]+' names must start with ';
  if Mode = cptemNormal then begin
    Result := Result + 'an alphanumber character, and be at least 3 characters in length.';
  end else begin
    Result := Result + ''''+ NAMESPACE_TAG_FOR_MODE[Mode] + '-'' and then an ' + CRLF +
              'alphanumber character, and have at least 3 total additional characters.';
  end;
  Result := Result + CRLF + 'In addition, no template can be named "' + NewTemplateName(Mode)+'".';
end;

function NewTemplateName(Mode : TcpteMode = cptemNormal) : string;
//kt added this function to replact CONSTANT text
begin
  if Mode= cptemNormal then begin
    Result := 'New Template';
  end else begin
    Result:= NAMESPACE_TAG_FOR_MODE[Mode]+'-New Name';
  end;
end;

function UsingHTMLTargetMode : boolean;
begin
  result := (frmNotes.HTMLEditMode = emHTML) or (assigned(frmSingleNote));
end;

initialization

finalization
  ReleaseTemplates;
end.

