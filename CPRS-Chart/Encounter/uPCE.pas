unit uPCE;

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

uses Windows, SysUtils, Classes, ORFn, uConst, ORCtrls, ORClasses,UBAGlobals
     ,Dialogs, StrUtils  //kt;
     ;

{var
   OtherVisitStr : string;   //TMG added 6/6/22}

type
  //kt moved this definition up from below.  
  TPCEDataCat = (pdcVisit, pdcDiag, pdcProc, pdcImm, pdcSkin, pdcPED, pdcHF,
                 pdcExam, pdcVital, pdcOrder, pdcMH, pdcMST, pdcHNC, pdcWHR, pdcWH);

  TPCEProviderRec = record
    IEN: int64;
    Name: string;
    Primary: boolean;
    Delete: boolean;
  end;

  TPCEProviderList = class(TORStringList)
  private
    FNoUpdate: boolean;
    FOnPrimaryChanged: TNotifyEvent;
    FPendingDefault: string;
    FPendingUser: string;
    FPCEProviderIEN: Int64;
    FPCEProviderName: string;
    function GetProviderData(Index: integer): TPCEProviderRec;
    procedure SetProviderData(Index: integer; const Value: TPCEProviderRec);
    function GetPrimaryIdx: integer;
    procedure SetPrimaryIdx(const Value: integer);
    procedure SetPrimary(index: integer; Primary: boolean);
  public
    function Add(const S: string): Integer; override;
    function AddProvider(AIEN, AName: string; APrimary: boolean): integer;
    procedure Assign(Source: TPersistent); override;
    function PCEProvider: Int64;
    function PCEProviderName: string;
    function IndexOfProvider(AIEN: string): integer;
    procedure Merge(AList: TPCEProviderList);
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    function PrimaryIEN: int64;
    function PrimaryName: string;
    function PendingIEN(ADefault: boolean): Int64;
    function PendingName(ADefault: boolean): string;
    property ProviderData[Index: integer]: TPCEProviderRec read GetProviderData
                                                          write SetProviderData; default;
    property PrimaryIdx: integer read GetPrimaryIdx write SetPrimaryIdx;
    property OnPrimaryChanged: TNotifyEvent read FOnPrimaryChanged
                                           write FOnPrimaryChanged;
  end;

  TPCEItem = class(TObject)
  {base class for PCE items}
  private
    FDelete:   Boolean;                          //flag for deletion
    FSend:     Boolean;                          //flag to send to broker
    FComment:  String;
    FInactive: boolean;  //kt added.  Default value will be FALSE
  protected
    procedure SetComment(const Value: String);
  public
    Provider:  Int64;
    Code:      string;
    Category:  string;
    Narrative: string;
    FGecRem: string;
    TMGData : string; //kt added 12/28/23
    procedure Assign(Src: TPCEItem); virtual;
    procedure Clear; virtual;
    function IsCleared : boolean;
    function DelimitedStr: string; virtual;
    function DelimitedStr2: string; virtual;
    function ItemStr: string; virtual;
    function Match(AnItem: TPCEItem): Boolean;
//    function MatchProvider(AnItem: TPCEItem):Boolean;
    function MatchProvider(AnItem: TPCEItem):Boolean;
    procedure SetFromString(const x: string); virtual;
    function HasCPTStr: string; virtual;
    property Comment: String read FComment write SetComment;
    property GecRem: string read FGecRem write FGecRem;
    property Deleted : boolean read FDelete;  //kt added READ ONLY access to FDelete, but didn't add FDelete
    property Inactive : boolean read FInactive write FInactive;  //kt added entire variable.
    constructor Create; virtual;  //kt added 2/12/23 so that descendent objects can call their own constructors.  TObject.create is empty (doesn't do anything)
  end;

  TPCEItemClass = class of TPCEItem;

  TPCEProc = class(TPCEItem)
  {class for procedures}
  protected
    ModifiersList : TStringList; //kt added.  format: ModifiersList[i] = <ModifierIEN>
    function GetModifiers : string;  //kt added
    procedure SetModifiers(Value : string); //kt added
  public
    FIsOldProcedure: boolean;
    Quantity:  Integer;
    //kt removed to make a property -->Modifiers: string; // Format Modifier1IEN;Modifier2IEN;Modifier3IEN;   NOTE: Trailing ';' needed
    Provider: Int64; {jm 9/8/99}
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function DelimitedStrC: string;
    function Match(AnItem: TPCEProc): Boolean;   //kt removed comments.  Initially this was commented out.
    function ModText: string;
    function ModCodes: string;                   //kt added
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    //procedure CopyProc(Dest: TPCEProc);
    function HasModifierIEN(IEN : string) : boolean; //kt added
    procedure EnsureModifierIEN(IEN : string);       //kt added
    procedure RemoveModifierIEN(IEN : string);       //kt added
    function HasModifier(IEN : string) : boolean;    //kt added
    function Empty: boolean;
    constructor Create; override;                    //kt added
    destructor Destroy; override;                    //kdt added
    property Modifiers : string read GetModifiers write SetModifiers; //kt added
  end;

  TPCEProcList = class(TList) //kt added
  private
    function GetProc(index : integer) : TPCEProc;
  public
    procedure FreeAndClearItems;
    function EnsureProc(Proc : TPCEProc) : TPCEProc;
    function EnsureFromString(x : string) : TPCEProc;
    function MaxQuantity : integer;
    function IndexOfMatch(MatchProc : TPCEProc) : integer;
    function IndexOfCodeUNarr(CodeUNarr : string) : integer;
    function ProcForCodeUNarr(CodeUNarr : string) : TPCEProc;
    function FirstNonEmptyCode : string;
    function ValidIndex(AnIndex : integer) : boolean;
    procedure SetProvider(AProvider : Int64);
    procedure Assign(Src : TPCEProcList);
    function Empty : boolean;
    property Proc[index : integer] : TPCEProc read GetProc;
  end;

  TPCEDiag = class(TPCEItem)
  {class for diagnosis}
  public
    fProvider: Int64;
    Primary:   Boolean;
    AddProb:   Boolean;
    OldComment: string;
    SaveComment: boolean;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
    function DelimitedStr2: string; override;
//    function delimitedStrC: string;
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    procedure Send;
  end;

  TPCEExams = class(TPCEItem)
  {class for Examinations}
  public
//    Provider: Int64;
    Results:   String;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;


  TPCEHealth = class(TPCEItem)
  {class for Health Factors}
  public
//    Provider: Int64; {jm 9/8/99}
    Level:   string;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;        
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;

  TPCEImm = class(TPCEItem)
  {class for immunizations}
  public
//    Provider:        Int64; {jm 9/8/99}
    Series:          String;
    Reaction:        String;
    Refused:         Boolean; //not currently used
    Contraindicated: Boolean;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;        
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;

  TPCEPat = class(TPCEItem)
  {class for patient Education}
  public
//    Provider: Int64; {jm 9/8/99}
    Level:   String;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;

  TPCESkin = class(TPCEItem)
  {class for skin tests}
  public
//    Provider:  Int64; {jm 9/8/99}
    Results:   String;                   //Do not confuse for reserved word "result"
    Reading:   Integer;
    DTRead:    TFMDateTime;
    DTGiven:   TFMDateTime;
    procedure Assign(Src: TPCEItem); override;
    procedure Clear; override;
    function DelimitedStr: string; override;
//    function delimitedStrC: string;
    function ItemStr: string; override;
    procedure SetFromString(const x: string); override;
    function HasCPTStr: string; override;
  end;

//  TPCEData = class;

  tRequiredPCEDataType = (ndDiag, ndProc, ndSC); {jm 9/9/99}
  tRequiredPCEDataTypes = set of tRequiredPCEDataType;

  //modified: 6/9/99
  //By: Robert Bott
  //Location: ISL
  //Purpose: Changed to allow capture of multiple providers.
  TPCEData = class
  {class for data to be passed to and from broker}
  private
    FUpdated:      boolean;
    FEncDateTime:  TFMDateTime;                    //encounter date & time
    FNoteDateTime: TFMDateTime;                    //Note date & time
    FEncLocation:  Integer;                        //encounter location
    FEncSvcCat:    Char;                           //
    FEncInpatient: Boolean;                        //Inpatient flag
    FEncUseCurr:   Boolean;                        //
    FSCChanged:    Boolean;                        //
    FSCRelated:    Integer;                        //service con. related?
    FAORelated:    Integer;                        //
    FIRRelated:    Integer;                        //
    FECRelated:    Integer;                        //
    FMSTRelated:   Integer;                        //
    FHNCRelated:   Integer;                        //
    FCVRelated:    Integer;                        //
    FSHADRelated:   Integer;                       //
    //kt FVisitType:    TPCEProc;                       //
    FProviders:    TPCEProviderList;
    FVisitTypesList: TPCEProcList;                 //list for TPCEProc visits.  //kt added
    FDiagnoses:     TList;                         //pointer list for diagnosis
    FProcedures:    TList;                         //pointer list for Procedures
    FImmunizations: TList;                         //pointer list for Immunizations
    FSkinTests:     TList;                         //pointer list for skin tests
    FPatientEds:    TList;
    FHealthFactors: TList;
    fExams:         TList;
    FNoteTitle:    Integer;
    FNoteIEN:      Integer;
    FParent:       string;                         // Parent Visit for secondary encounters
    FHistoricalLocation: string;                   // Institution IEN^Name (if IEN=0 Piece 4 = outside location)
    FStandAlone: boolean;
    FStandAloneLoaded: boolean;
    FProblemAdded: Boolean;                         // Flag set when one or more Dx are added to PL

    function GetVisitString: string;
    function GetCPTRequired: Boolean;
    function getDocCount: Integer;
    function MatchItem(AList: TList; AnItem: TPCEItem): Integer;
    procedure MarkDeletions(PreList: TList; PostList: TStrings); overload;
    procedure MarkDeletions(PreList: TList; PostList: TList);    overload; //kt added
    procedure SetSCRelated(Value: Integer);
    procedure SetAORelated(Value: Integer);
    procedure SetIRRelated(Value: Integer);
    procedure SetECRelated(Value: Integer);
    procedure SetMSTRelated(Value: Integer);
    procedure SetHNCRelated(Value: Integer);
    procedure SetCVRelated(Value: Integer);
    procedure SetSHADRelated(Value: Integer);
    procedure SetEncUseCurr(Value: Boolean);
    function GetHasData: Boolean;
    procedure GetHasCPTList(AList: TStrings);
    procedure CopyPCEItems(Src: TList; Dest: TObject; ItemClass: TPCEItemClass);
  public
    constructor Create; overload;
    constructor Create(ASrc : TPCEData); overload;  //kt added 5/23
    destructor Destroy; override;
    procedure Clear;
    procedure CopyPCEData(Dest: TPCEData);  //Copies self -> Dest
    procedure Assign(Src: TPCEData);        //copies Src -> self.
    function Empty: boolean;
    procedure PCEForNote(NoteIEN: Integer; PotentialSrcObj: TPCEData);(* overload;
    procedure PCEForNote(NoteIEN: Integer; EditObj: TPCEData; DCSummAdmitString: string); overload;*)
    //kt procedure Save;
    procedure Save(ForceForegroundSave : boolean = false);  //kt added ForceForegroundSave
    procedure CopyVisits(Dest: TPCEProcList);        //kt added
    procedure CopyDiagnoses(Dest: TStrings);     // ICDcode^P|S^Category^Narrative^P|S Text
    procedure CopyProcedures(Dest: TStrings);    // CPTcode^Qty^Category^Narrative^Qty Text
    procedure CopyImmunizations(Dest: TStrings); //
    procedure CopySkinTests(Dest: TStrings);     //
    procedure CopyPatientEds(Dest: TStrings);
    procedure CopyHealthFactors(Dest: TStrings);
    procedure CopyExams(Dest: TStrings);

    procedure SetVisits(Src : TPCEProcList; FromForm: boolean = TRUE);     //kt added
    procedure SetDiagnoses(Src: TStrings; FromForm: boolean = TRUE);       // ICDcode^P|S^Category^Narrative^P|S Text
    procedure SetExams(Src: TStrings; FromForm: boolean = TRUE);
    Procedure SetHealthFactors(Src: TStrings; FromForm: boolean = TRUE);
    procedure SetImmunizations(Src: TStrings; FromForm: boolean = TRUE);   // IMMcode^
    Procedure SetPatientEds(Src: TStrings; FromForm: boolean = TRUE);
    procedure SetSkinTests(Src: TStrings; FromForm: boolean = TRUE);       //
    procedure SetProcedures(Src: TStrings; FromForm: boolean = TRUE);      // CPTcode^Qty^Category^Narrative^Qty Text
    procedure SetVisitType(index : integer; Value: TPCEProc);     // CPTcode^1^Category^Narrative    //kt added index
    function  GetVisitType(index : integer) : TPCEProc; //kt added
    procedure SetExtraVisitTypes(Src: TStrings; FromForm: boolean = TRUE); //kt

    function StrForList(AList : TList; AClass : TPCEItemClass; CatType: TPCEDataCat; NoHeader : boolean = false; CodeOnly : boolean = false) : string;  //kt added
    function StrDiagnoses(NoHeader : boolean = false): string;               // Diagnoses: ...               //kt added NoHeader param
    function StrImmunizations(NoHeader : boolean = false): string;           // Immunizzations: ...          //kt added NoHeader param
    function StrProcedures(NoHeader : boolean = false): string;              // Procedures: ...              //kt added NoHeader param
    function StrSkinTests(NoHeader : boolean = false): string;                                               //kt added NoHeader param
    function StrPatientEds(NoHeader : boolean = false): string;                                              //kt added NoHeader param
    function StrHealthFactors(NoHeader : boolean = false): string;                                           //kt added NoHeader param
    function StrExams(NoHeader : boolean = false): string;                                                   //kt added NoHeader param
    function StrVisitType(const ASCRelated, AAORelated, AIRRelated, AECRelated,
                                AMSTRelated, AHNCRelated, ACVRelated, ASHADRelated: Integer): string; overload;
    //kt function StrVisitType: string; overload;
    function StrVisitType(AVisitType : TPCEProc) : string; overload; //kt added
    function StrVisitTypes(NoHeader : boolean = false) : string; //kt added. NOTE: this is plural form (added 's')
    function StrDiagCodes(): string;   //elh 10/19/23
    function StrCPTCodes(): string;   //elh 10/19/23
    function StandAlone: boolean;
    procedure AddStrData(List: TStrings);
    procedure AddVitalData(Data, List: TStrings);

    function NeededPCEData: tRequiredPCEDataTypes;
    function OK2SignNote: boolean;

    function PersonClassDate: TFMDateTime;
    function VisitDateTime: TFMDateTime;
    function IsSecondaryVisit: boolean;
    function NeedProviderInfo: boolean;

    property HasData:      Boolean  read GetHasData;
    property CPTRequired:  Boolean  read GetCPTRequired;
    property ProblemAdded: Boolean  read FProblemAdded;
    property Inpatient:    Boolean  read FEncInpatient;
    property UseEncounter: Boolean  read FEncUseCurr  write SetEncUseCurr;
    property SCRelated:    Integer  read FSCRelated   write SetSCRelated;
    property AORelated:    Integer  read FAORelated   write SetAORelated;
    property IRRelated:    Integer  read FIRRelated   write SetIRRelated;
    property ECRelated:    Integer  read FECRelated   write SetECRelated;
    property MSTRelated:   Integer  read FMSTRelated  write SetMSTRelated;
    property HNCRelated:   Integer  read FHNCRelated  write SetHNCRelated;
    property CVRelated:    Integer  read FCVRelated   write SetCVRelated;
    property SHADRelated:  Integer  read FSHADRelated write SetSHADRelated;
    //kt property VisitType:    TPCEProc read FVisitType   write SetVisitType;
    property VisitType[index : integer] : TPCEProc read GetVisitType   write SetVisitType;  //kt added
    property VisitTypesList:     TPCEProcList      read FVisitTypesList; //kt added
    property VisitString:        string            read GetVisitString;
    property VisitCategory:      char              read FEncSvcCat   write FEncSvcCat;
    property DateTime:           TFMDateTime       read FEncDateTime write FEncDateTime;
    property NoteDateTime:       TFMDateTime       read FNoteDateTime write FNoteDateTime;
    property Location:           Integer           read FEncLocation;
    property NoteTitle:          Integer           read FNoteTitle write FNoteTitle;
    property NoteIEN:            Integer           read FNoteIEN write FNoteIEN;
    property DocCOunt:           Integer           read GetDocCount;
    property Providers:          TPCEProviderList  read FProviders;
    property Parent:             string            read FParent write FParent;
    property HistoricalLocation: string            read FHistoricalLocation write FHistoricalLocation;
    property Updated:            boolean           read FUpdated write FUpdated;
  end;

type
  TPCEType = (ptEncounter, ptReminder, ptTemplate);

  TNotifyPCEEventList = class;  //kt added
  TNotifyPCEEvent = procedure(PCEData: TPCEData; CallBackProcs : TNotifyPCEEventList);  //kt added
  TNotifyPCEEventList = class(TStringList) //kt added
  private
    function GetProc(index: integer) : TNotifyPCEEvent;
  public
    function IndexIsData(index : integer) : boolean;
    procedure PopAndCall(PCEData: TPCEData);
    function GetAndRemoveData(Name : string) : pointer;
    function GetAndRemoveDataInt(Name : string) : integer;
    function GetAndRemoveDataBool(Name : string) : boolean;
    procedure AddDataObj(Name : string; Data : pointer);
    procedure AddDataInt(Name : string; Data : integer);
    procedure AddDataBool(Name : string; Data : boolean);
    property Proc[index : integer] : TNotifyPCEEvent read GetProc;
  end;



const
  PCETypeText: array[TPCEType] of string = ('encounter', 'reminder', 'template');


function InvalidPCEProviderTxt(AIEN: Int64; ADate: TFMDateTime): string;
function MissingProviderInfo(PCEEdit: TPCEData; PCEType: TPCEType = ptEncounter): boolean;
function IsOK2Sign(const PCEData: TPCEData; const IEN: integer) :boolean;
function FutureEncounter(APCEData: TPCEData): boolean;
function CanEditPCE(APCEData: TPCEData): boolean;
procedure GetPCECodes(List: TStrings; CodeType: integer);
procedure GetComboBoxMinMax(dest: TORComboBox; var Min, Max: integer);
procedure PCELoadORCombo(dest: TORComboBox); overload;
procedure PCELoadORCombo(dest: TORComboBox; var Min, Max: integer); overload;
function GetPCEDisplayText(ID: string; Tag: integer): string;
procedure SetDefaultProvider(ProviderList: TPCEProviderList; APCEData: TPCEData);
function ValidateGAFDate(var GafDate: TFMDateTime): string;
procedure GetVitalsFromDate(VitalStr: TStrings; PCEObj: TPCEData);
procedure GetVitalsFromNote(VitalStr: TStrings; PCEObj: TPCEData; ANoteIEN: Int64);

function GetPCEDataText(Cat: TPCEDataCat; Code, Category, Narrative: string;
                       PrimaryDiag: boolean = FALSE; Qty: integer = 0): string;

const
  PCEDataCatText: array[TPCEDataCat] of string =
                        { pdcVisit } ('Visit E/M',    //kt added Visit E/M.  Was ''  4/23
                        { pdcDiag  }  'Diagnoses: ',
                        { pdcProc  }  'Procedures: ',
                        { pdcImm   }  'Immunizations: ',
                        { pdcSkin  }  'Skin Tests: ',
                        { pdcPED   }  'Patient Educations: ',
                        { pdcHF    }  'Health Factors: ',
                        { pdcExam  }  'Examinations: ',
                        { pdcVital }  '',
                        { pdcOrder }  'Orders: ',
                        { pdcMH    }  'Mental Health: ',
                        { pdcMST   }  'MST History: ',
                        { pdcHNC   }  'Head and/or Neck Cancer: ',
                        { pdcWHR   }  'Women''s Health Procedure: ',
                        { pdcWH    }  'WH Notification: ');

  NoPCEValue = '@';
  TAB_STOP_CHARS = 7;
  TX_NO_VISIT   = 'Insufficient Visit Information';
  TX_NEED_PROV1  = 'The provider responsible for this encounter must be entered before ';
  TX_NEED_PROV2  = ' information may be entered.';
//  TX_NEED_PROV3  = 'you can sign the note.';
  TX_NO_PROV    = 'Missing Provider';
  TX_BAD_PROV   = 'Invalid Provider';
  TX_NOT_ACTIVE = ' does not have an active person class.';
  TX_NOT_PROV   = ' is not a known Provider.';
  TX_MISSING    = 'Required Information Missing';
  TX_REQ1       = 'The following required fields have not been entered:' + CRLF;
  TC_REQ        = 'Required Fields';
  TX_ADDEND_AD  = 'Cannot make an addendum to an addendum' + CRLF +
                  'Please select the parent note or document, and try again.';
  TX_ADDEND_MK  = 'Unable to Make Addendum';
  TX_DEL_CNF    = 'Confirm Deletion';
  TX_IN_AUTH    = 'Insufficient Authorization';
  TX_NOPCE      = '<No encounter information entered>';
  TX_NEED_T     = 'Missing Encounter Information';
  TX_NEED1      = 'This note title is marked to prompt for the following missing' + CRLF +
                  'encounter information:' + CRLF;
  TX_NEED_DIAG  = '  A diagnosis.';
  TX_NEED_PROC  = '  A visit type or procedure.';
  TX_NEED_SC    = '  One or more service connected questions.';
  TX_NEED2      = 'Would you like to enter encounter information now?';
  TX_NEED3      = 'You must enter the encounter information before you can sign the note.';
  TX_NEEDABORT  = 'Document not signed.';
  TX_COS_REQ    = 'A cosigner is required for this document.';
  TX_COS_SELF   = 'You cannot make yourself a cosigner.';
  TX_COS_AUTH   = ' is not authorized to cosign this document.';
  TC_COS        = 'Select Cosigner';

  TAG_IMMSERIES  = 10;
  TAG_IMMREACTION= 20;
  TAG_SKRESULTS  = 30;
  TAG_PEDLEVEL   = 40;
  TAG_HFLEVEL    = 50;
  TAG_XAMRESULTS = 60;
  TAG_HISTLOC    = 70;

{ These piece numbers are used by both the PCE objects and reminders }
  pnumCode           = 2;
  pnumPrvdrIEN       = 2;
  pnumCategory       = 3;
  pnumNarrative      = 4;
  pnumExamResults    = 5;
  pnumSkinResults    = 5;
  pnumHFLevel        = 5;
  pnumImmSeries      = 5;
  pnumProcQty        = 5;
  pnumPEDLevel       = 5;
  pnumDiagPrimary    = 5;
  pnumPrvdrName      = 5;
  pnumProvider       = 6;
  pnumPrvdrPrimary   = 6;
  pnumSkinReading    = 7;
  pnumImmReaction    = 7;
  pnumDiagAdd2PL     = 7;
  pnumSkinDTRead     = 8;
  pnumImmContra      = 8;
  pnumSkinDTGiven    = 9;
  pnumImmRefused     = 9;
  pnumCPTMods        = 9;
  pnumComment        = 10;
  pnumWHPapResult    =11;
  pnumWHNotPurp      =12;

  USE_CURRENT_VISITSTR = -2;
  //USE_OTHER_VISITSTR = -4;    //TMG added  6/6/22

implementation

uses uCore, rPCE, rCore, rTIU, fEncounterFrame, uVitals, fFrame,
     fPCEProvider, rVitals, uReminders, fODTMG1;
     
const
  FN_NEW_PERSON = 200;

function InvalidPCEProviderTxt(AIEN: Int64; ADate: TFMDateTime): string;
begin
  Result := '';
  if(not CheckActivePerson(IntToStr(AIEN), ADate)) then
    Result := TX_NOT_ACTIVE
  else
  if(not IsUserAProvider(AIEN, ADate)) then
    Result := TX_NOT_PROV;
end;

function MissingProviderInfo(PCEEdit: TPCEData; PCEType: TPCEType = ptEncounter): boolean;
begin
  if(PCEEdit.Empty and (PCEEdit.Location <> Encounter.Location) and (not Encounter.NeedVisit)) then
    PCEEdit.UseEncounter := TRUE;
  Result := NoPrimaryPCEProvider(PCEEdit.Providers, PCEEdit);
  if(Result) then
    InfoBox(TX_NEED_PROV1 + PCETypeText[PCEType] + TX_NEED_PROV2,
            TX_NO_PROV, MB_OK or MB_ICONWARNING);
end;

var
  UNxtCommSeqNum: integer;                             

function IsOK2Sign(const PCEData: TPCEData; const IEN: integer) :boolean;
var
  TmpPCEData: TPCEData;

begin
  if(assigned(PCEData)) then
    PCEData.FUpdated := FALSE;
  if(assigned(PCEData) and (PCEData.VisitString <> '') and
     (VisitStrForNote(IEN) = PCEData.VisitString)) then
  begin
    if(PCEData.FNoteIEN <= 0) then
      PCEData.FNoteIEN := IEN;
    Result := PCEData.OK2SignNote
  end
  else
  begin
    TmpPCEData := TPCEData.Create;
    try
      TmpPCEData.PCEForNote(IEN, nil);
      Result := TmpPCEData.OK2SignNote;
    finally
      TmpPCEData.Free;
    end;
  end;
end;

function FutureEncounter(APCEData: TPCEData): boolean;
begin
  Result := (Int(APCEData.FEncDateTime + 0.0000001) > Int(FMToday + 0.0000001));
end;

function CanEditPCE(APCEData: TPCEData): boolean;
begin
  if(GetAskPCE(APCEData.FEncLocation) = apDisable) then
    Result := FALSE
  else
    Result := (not FutureEncounter(APCEData));
end;

procedure GetComboBoxMinMax(dest: TORComboBox; var Min, Max: integer);
var
  DC: HDC;
  SaveFont: HFont;
  TextSize: TSize;
  TLen, i: integer;
  x: string;

begin
  Min := MaxInt;
  Max := 0;
  DC := GetDC(0);
  try
    SaveFont := SelectObject(DC, dest.Font.Handle);
    try
      for i := 0 to dest.Items.Count-1 do
      begin
        x := dest.DisplayText[i];
        GetTextExtentPoint32(DC, PChar(x), Length(x), TextSize);
        TLen := TextSize.cx;
        if(TLen > 0) and (Min > TLen) then
          Min := TLen;
        if(Max < TLen) then
          Max := TLen;
      end;
    finally
      SelectObject(DC, SaveFont);
    end;
  finally
    ReleaseDC(0, DC);
  end;
  if(Min > Max) then Min := Max;

  inc(Min, ScrollBarWidth + 8);
  inc(Max, ScrollBarWidth + 8);
end;

type
  TListMinMax = (mmMin, mmMax, mmFont);

var
  PCESetsOfCodes: TStringList = nil;
  HistLocations: TORStringList = nil;
  WHNotPurpose: TORStringList = nil;
  WHPapResult: TORStringList = nil;
  WHMammResult: TORStringList = nil;
  WHUltraResult: TORStringList = nil;
const
  SetOfCodesHeader = '{^~Codes~^}';
  SOCHeaderLen = length(SetOfCodesHeader);
  ListMinMax: array[1..7, TListMinMax] of integer =
                          ((0,0,-1),  // TAG_IMMSERIES
                           (0,0,-1),  // TAG_IMMREACTION
                           (0,0,-1),  // TAG_SKRESULTS
                           (0,0,-1),  // TAG_PEDLEVEL
                           (0,0,-1),  // TAG_HFLEVEL
                           (0,0,-1),  // TAG_XAMRESULTS
                           (0,0,-1));  // TAG_HISTLOC
                           
function CodeSetIndex(CodeType: integer): integer;
var
  TempSL: TStringList;
  Hdr: string;

begin
  Hdr := SetOfCodesHeader + IntToStr(CodeType);
  Result := PCESetsOfCodes.IndexOf(Hdr);
  if(Result < 0) then
  begin
    TempSL := TStringList.Create;
    try
      case CodeType of
        TAG_IMMSERIES:   LoadImmSeriesItems(TempSL);
        TAG_IMMREACTION: LoadImmReactionItems(TempSL);
        TAG_SKRESULTS:   LoadSkResultsItems(TempSL);
        TAG_PEDLEVEL:    LoadPEDLevelItems(TempSL);
        TAG_HFLEVEL:     LoadHFLevelItems(TempSL);
        TAG_XAMRESULTS:  LoadXAMResultsItems(TempSL);
        else
          KillObj(@TempSL);
      end;
      if(assigned(TempSL)) then
      begin
        Result := PCESetsOfCodes.Add(Hdr);
        FastAddStrings(TempSL, PCESetsOfCodes);
      end;
    finally
      KillObj(@TempSL);
    end;
  end;
end;

procedure GetPCECodes(List: TStrings; CodeType: integer);
var
  idx: integer;

  begin
  if(CodeType = TAG_HISTLOC) then
  begin
    if(not assigned(HistLocations)) then
    begin
      HistLocations := TORStringList.Create;
      LoadHistLocations(HistLocations);
      HistLocations.SortByPiece(2);
      HistLocations.Insert(0,'0');
    end;
    FastAddStrings(HistLocations, List);
  end
  else
  begin
    if(not assigned(PCESetsOfCodes)) then
      PCESetsOfCodes := TStringList.Create;
    idx := CodeSetIndex(CodeType);
    if(idx >= 0) then
    begin
      inc(idx);
      while((idx < PCESetsOfCodes.Count) and
            (copy(PCESetsOfCodes[idx],1,SOCHeaderLen) <> SetOfCodesHeader)) do
      begin
        List.Add(PCESetsOfCodes[idx]);
        inc(idx);
      end;
    end;
  end;
end;

function GetPCECodeString(CodeType: integer; ID: string): string;
var
  idx: integer;

begin
  Result := '';
  if(CodeType <> TAG_HISTLOC) then
  begin
    if(not assigned(PCESetsOfCodes)) then
      PCESetsOfCodes := TStringList.Create;
    idx := CodeSetIndex(CodeType);
    if(idx >= 0) then
    begin
      inc(idx);
      while((idx < PCESetsOfCodes.Count) and
            (copy(PCESetsOfCodes[idx],1,SOCHeaderLen) <> SetOfCodesHeader)) do
      begin
        if(Piece(PCESetsOfCodes[idx], U, 1) = ID) then
        begin
          Result := Piece(PCESetsOfCodes[idx], U, 2);
          break;
        end;
        inc(idx);
      end;
    end;
  end;
end;

procedure PCELoadORComboData(dest: TORComboBox; GetMinMax: boolean; var Min, Max: integer);
var
  idx: integer;

begin
  if(dest.items.count < 1) then
  begin
    dest.Clear;
    GetPCECodes(dest.Items, dest.Tag);
    dest.itemindex := 0;
    if(GetMinMax) and (dest.Items.Count > 0) then
    begin
      idx := dest.Tag div 10;
      if(idx > 0) and (idx < 8) then
      begin
        if(ListMinMax[idx, mmFont] <> integer(dest.Font.Handle)) then
        begin
          GetComboBoxMinMax(dest, Min, Max);
          ListMinMax[idx, mmMin] := Min;
          ListMinMax[idx, mmMax] := Max;
        end
        else
        begin
          Min := ListMinMax[idx, mmMin];
          Max := ListMinMax[idx, mmMax];
        end;
      end;
    end;
  end;
end;

procedure PCELoadORCombo(dest: TORComboBox);
var
  tmp: integer;

begin
  PCELoadORComboData(dest, FALSE, tmp, tmp);
end;

procedure PCELoadORCombo(dest: TORComboBox; var Min, Max: integer);
begin
  PCELoadORComboData(dest, TRUE, Min, Max);
end;

function GetPCEDisplayText(ID: string; Tag: integer): string;
var
  Hdr: string;
  idx: integer;
  TempSL: TStringList;

begin
  Result := '';
  if(Tag = TAG_HISTLOC) then
  begin
    if(not assigned(HistLocations)) then
    begin
      HistLocations := TORStringList.Create;
      LoadHistLocations(HistLocations);
      HistLocations.SortByPiece(2);
      HistLocations.Insert(0,'0');
    end;
    idx := HistLocations.IndexOfPiece(ID);
    if(idx >= 0) then
      Result := Piece(HistLocations[idx], U, 2);
  end
  else
  begin
    if(not assigned(PCESetsOfCodes)) then
      PCESetsOfCodes := TStringList.Create;
    Hdr := SetOfCodesHeader + IntToStr(Tag);
    idx := PCESetsOfCodes.IndexOf(Hdr);
    if(idx < 0) then
    begin
      TempSL := TStringList.Create;
      try
        case Tag of
          TAG_IMMSERIES:   LoadImmSeriesItems(TempSL);
          TAG_IMMREACTION: LoadImmReactionItems(TempSL);
          TAG_SKRESULTS:   LoadSkResultsItems(TempSL);
          TAG_PEDLEVEL:    LoadPEDLevelItems(TempSL);
          TAG_HFLEVEL:     LoadHFLevelItems(TempSL);
          TAG_XAMRESULTS:  LoadXAMResultsItems(TempSL);
          else
            KillObj(@TempSL);
        end;
        if(assigned(TempSL)) then
        begin
          idx := PCESetsOfCodes.Add(Hdr);
          FastAddStrings(TempSL, PCESetsOfCodes);
        end;
      finally
        KillObj(@TempSL);
      end;
    end;
    if(idx >= 0) then
    begin
      inc(idx);
      while((idx < PCESetsOfCodes.Count) and
            (copy(PCESetsOfCodes[idx],1,SOCHeaderLen) <> SetOfCodesHeader)) do
      begin
        if(Piece(PCESetsOfCodes[idx], U, 1) = ID) then
        begin
          Result := Piece(PCESetsOfCodes[idx], U, 2);
          break;
        end;
        inc(idx);
      end;
    end;
  end;
end;

function GetPCEDataText(Cat: TPCEDataCat;
                        Code, Category, Narrative: string;
                        PrimaryDiag: boolean = FALSE;
                        Qty: integer = 0): string;
begin
  Result := '';
  case Cat of
    pdcVisit: begin
                //kt original -> if Code <> '' then Result := Category + ' ' + Narrative;
                if Code <> '' then Result := Code + ' - ' + Narrative;  //kt
              end;
    pdcDiag:  begin
               Result := GetDiagnosisText(Narrative, Code);
               if PrimaryDiag then Result := Result + ' (Primary)';
              end;
    pdcProc:  begin
               Result := Narrative;
               if Code <> '' then Result := Result + ' (CPT ' + Code + ')';  //kt added 4/25/22 
               if Qty > 1 then Result := Result + ' (' + IntToStr(Qty) + ' times)';
              end;
    else      Result := Narrative;
  end; //case
end;

procedure SetDefaultProvider(ProviderList: TPCEProviderList; APCEData: TPCEData);
var
  SIEN, tmp: string;
  DefUser, AUser: Int64;
  UserName: string;

begin
  DefUser := Encounter.Provider;
  if(DefUser <> 0) and (InvalidPCEProviderTxt(DefUser, APCEData.PersonClassDate) <> '') then
    DefUser := 0;
  if(DefUser <> 0) then
  begin
    AUser := DefUser;
    UserName := Encounter.ProviderName;
  end
  else
  if(InvalidPCEProviderTxt(User.DUZ, APCEData.PersonClassDate) = '') then
  begin
    AUser := User.DUZ;
    UserName := User.Name;
  end
  else
  begin
    AUser := 0;
    UserName := '';
  end;
  if(AUser = 0) then
    ProviderList.FPendingUser := ''
  else
    ProviderList.FPendingUser := IntToStr(AUser) + U + UserName;
  ProviderList.FPendingDefault := '';
  tmp := DefaultProvider(APCEData.Location, DefUser, APCEData.PersonClassDate, APCEData.NoteIEN);
  SIEN := IntToStr(StrToIntDef(Piece(tmp,U,1),0));
  if(SIEN <> '0') then
  begin
    if(CheckActivePerson(SIEN, APCEData.PersonClassDate)) then
    begin
      if(piece(TIUSiteParams, U, 8) = '1') and // Check to see if DEFAULT PRIMARY PROVIDER is by Location 
        (SIEN = IntToStr(User.DUZ)) then
        ProviderList.AddProvider(SIEN, Piece(tmp,U,2) ,TRUE)
      else
        ProviderList.FPendingDefault := tmp;
    end;
  end;
end;

function ValidateGAFDate(var GafDate: TFMDateTime): string;
var
  DateMsg: string;
  OKDate: TFMDateTime;

begin
  Result := '';
  if(Patient.DateDied > 0) and (FMToday > Patient.DateDied) then
  begin
    DateMsg := 'Date of Death';
    OKDate := Patient.DateDied;
  end
  else
  begin
    DateMsg := 'Today';
    OKDate := FMToday;
  end;
  if(GafDate <= 0) then
  begin
    Result := 'A date is required to enter a GAF score.  Date Determined changed to ' + DateMsg + '.';
    GafDate := OKDate;
  end
  else
  if(Patient.DateDied > 0) and (GafDate > Patient.DateDied) then
  begin
    Result := 'This patient died ' + FormatFMDateTime('mmm dd, yyyy hh:nn', Patient.DateDied) +
           '.  Date GAF determined can not ' + CRLF +
           'be later than the date of death, and has been changed to ' + DateMsg + '.';
    GafDate := OKDate;
  end;
end;

procedure GetVitalsFromDate(VitalStr: TStrings; PCEObj: TPCEData);
var
  dte: TFMDateTime;
  
begin
  if(PCEObj.IsSecondaryVisit) then
    dte := PCEObj.NoteDateTime
  else
    dte := PCEObj.DateTime;
  GetVitalsFromEncDateTime(VitalStr, Patient.DFN, dte);
end;

procedure GetVitalsFromNote(VitalStr: TStrings; PCEObj: TPCEData; ANoteIEN: Int64);
begin
  if(PCEObj.IsSecondaryVisit) then
    GetVitalsFromEncDateTime(VitalStr, Patient.DFN, PCEObj.NoteDateTime)
  else
    GetVitalFromNoteIEN(VitalStr, Patient.DFN, ANoteIEN);
end;

{ TPCEItem methods ------------------------------------------------------------------------- }

constructor TPCEItem.Create;
//kt added 2/12/23 so that descendent objects can call their own constructors.  
begin
  inherited;  //not really needed at ancestor TObject.Create doesn't do anything.
end;

//function TPCEItem.DelimitedStr2: string;
//added: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Return comment string to be passed in RPC call.
function TPCEItem.DelimitedStr2: string;
{created delimited string to pass to broker}
begin
  If Comment = '' then
  begin
    result := 'COM' + U +  IntToStr(UNxtCommSeqNum) + U + NoPCEValue;
  end
  else
  begin
    Result := 'COM' + U +  IntToStr(UNxtCommSeqNum) + U + Comment;
  end;

  Inc(UNxtCommSeqNum); //set up for next comment
end;

procedure TPCEItem.Assign(Src: TPCEItem);
begin
  FDelete   := Src.FDelete;
  FSend     := Src.FSend;
  Code      := Src.Code;
  Category  := Src.Category;
  Narrative := Src.Narrative;
  Provider  := Src.Provider;
  Comment   := Src.Comment;
  FInactive := Src.FInactive; //kt added
end;

procedure TPCEItem.SetComment(const Value: String);
begin
  FComment := Value;
  while (length(FComment) > 0) and (FComment[1] = '?') do
    delete(FComment,1,1);
end;


//procedure TPCEItem.Clear;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
procedure TPCEItem.Clear;
{clear fields(properties) of class}
begin
  FDelete   := False;
  FSend     := False;
  Code      := '';
  Category  := '';
  Narrative := '';
  Provider  := 0;
  Comment   := '';
  FInactive := false; //kt added
end;


//function TPCEItem.IsCleared : boolean;
//modified: 4/19/23
//By: K. Toppenberg
//Location: TMG
//Purpose: Check if item has been cleared.
function TPCEItem.IsCleared : boolean;
begin
  Result :=
    (FDelete   = False) and
    (FSend     = False) and
    (Code      = '') and
    (Category  = '') and
    (Narrative = '') and
    (Provider  = 0) and
    (Comment   = '') and
    (FInactive = false);
end;


//function TPCEItem.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEItem.DelimitedStr: string;
{created delimited string to pass to broker}
var
  DelFlag: Char;
begin
  if FDelete then DelFlag := '-' else DelFlag := '+';
  Result := DelFlag + U + Code + U + Category + U + Narrative;
end;

function TPCEItem.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  Result := Narrative;
end;

function TPCEItem.Match(AnItem: TPCEItem): Boolean;
{checks for match of Code, Category. and Item}
begin
  Result := False;
  if (Code = AnItem.Code) and
     (Category = AnItem.Category) and
     (Narrative = AnItem.Narrative) then begin
    Result := True;
  end;
end;

function TPCEItem.HasCPTStr: string;
begin
  Result := '';
end;

//procedure TPCEItem.SetFromString(const x: string);
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
procedure TPCEItem.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative }
begin
  Code      := Piece(x, U, pnumCode);      //pnumCode      = 2;
  Category  := Piece(x, U, pnumCategory);  //pnumCategory  = 3;
  Narrative := Piece(x, U, pnumNarrative); //pnumNarrative = 4;
  Provider  := StrToInt64Def(Piece(x, U, pnumProvider), 0);  //pnumProvider = 6;
  Comment   := Piece(x, U, pnumComment);   //pnumComment   = 10;
end;

{ TPCEExams methods ------------------------------------------------------------------------- }

procedure TPCEExams.Assign(Src: TPCEItem);
begin
  inherited Assign(Src);
  Results := TPCEExams(Src).Results;
  if Results = '' then Results := NoPCEValue;
end;

procedure TPCEExams.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Results  := NoPCEValue;
end;

//function TPCEExams.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEExams.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := inherited DelimitedStr;
  //Result := 'XAM' + Result + U + Results + U + IntToStr(Provider) +U + U + U +
  Result := 'XAM' + Result + U + Results + U +U + U + U +
   U + IntToStr(UNxtCommSeqNum);
end;

(*function TPCEExams.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'XAM' + Result + U + Results + U + IntToStr(Provider) +U + U + U +
   U + comment;
end;
*)
function TPCEExams.HasCPTStr: string;
begin
  Result := Code + ';AUTTEXAM(';
end;

function TPCEExams.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Results <> NoPCEValue) then
    Result := GetPCECodeString(TAG_XAMRESULTS, Results)
  else
    Result := '';
  Result := Result + U + inherited ItemStr;
end;

procedure TPCEExams.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Results  := Piece(x, U, pnumExamResults);
  If results = '' then results := NoPCEValue;
end;


{ TPCESkin methods ------------------------------------------------------------------------- }

procedure TPCESkin.Assign(Src: TPCEItem);
var
  SKSrc: TPCESkin;

begin
  inherited Assign(Src);
  SKSrc := TPCESkin(Src);
  Results := SKSrc.Results;
  Reading := SKSrc.Reading;
  DTRead  := SKSrc.DTRead;
  DTGiven := SKSrc.DTGiven;
  if Results = '' then Results := NoPCEValue;
end;

procedure TPCESkin.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Results := NoPCEValue;
  Reading   := 0;
  DTRead    := 0.0;        //What should dates be ititialized to?
  DTGiven   := 0.0;
end;

//function TPCESkin.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCESkin.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := inherited DelimitedStr;
  //Result := 'SK' + Result + U + results + U + IntToStr(Provider) + U +
  Result := 'SK' + Result + U + results + U + U +
   IntToStr(Reading) + U + U + U + IntToStr(UNxtCommSeqNum);
    //+ FloatToStr(DTRead) + U + FloatToStr(DTGiven);
end;

(*function TPCESkin.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'SK' + Result + U + results + U + IntToStr(Provider) + U +
   IntToStr(Reading) + U + U + U + comment;
end;
*)
function TPCESkin.HasCPTStr: string;
begin
  Result := Code + ';AUTTSK(';
end;

function TPCESkin.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Results <> NoPCEValue) then
    Result := GetPCECodeString(TAG_SKRESULTS, Results)
  else
    Result := '';
  Result := Result + U;
  if(Reading <> 0) then
    Result := Result + IntToStr(Reading);
  Result := Result + U + inherited ItemStr;
end;

procedure TPCESkin.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
var
  sRead, sDTRead, sDTGiven: String;
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Results  := Piece(x, U, pnumSkinResults);
  sRead    := Piece(x, U, pnumSkinReading);
  sDTRead  := Piece(x, U, pnumSkinDTRead);
  sDtGiven := Piece(x, U, pnumSkinDTGiven);
  If results = '' then results := NoPCEValue;

  if sRead <> '' then
    Reading  := StrToInt(sRead);
  if sDTRead <> '' then
    DTRead   := StrToFMDateTime(sDTRead);
  if sDTGiven <> '' then
    DTGiven  := StrToFMDateTime(sDTGiven);

end;


{ TPCEHealth methods ------------------------------------------------------------------------- }

procedure TPCEHealth.Assign(Src: TPCEItem);
begin
  inherited Assign(Src);
  Level := TPCEHealth(Src).Level;
  if Level = '' then Level := NoPCEValue;
end;

procedure TPCEHealth.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Level    := NoPCEValue;
end;

//function TPCEHealth.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEHealth.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := inherited DelimitedStr;
//  Result := 'HF' + Result + U + Level + U + IntToStr(Provider) + U + U + U +
  Result := 'HF' + Result + U + Level + U + U + U + U +
   U + IntToStr(UNxtCommSeqNum)+ U + GecRem; 
end;

(*function TPCEHealth.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'HF' + Result + U + Level + U + IntToStr(Provider) + U + U + U +
   U + comment;
end;
*)
function TPCEHealth.HasCPTStr: string;
begin
  Result := Code + ';AUTTHF(';
end;

function TPCEHealth.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Level <> NoPCEValue) then
    Result := GetPCECodeString(TAG_HFLEVEL, Level)
  else
    Result := '';
  Result := Result + U + inherited ItemStr;
end;

procedure TPCEHealth.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Level    := Piece(x, U, pnumHFLevel);
  if level = '' then level := NoPCEValue;
end;


{ TPCEImm methods ------------------------------------------------------------------------- }

procedure TPCEImm.Assign(Src: TPCEItem);
var
  IMMSrc: TPCEImm;
  
begin
  inherited Assign(Src);
  IMMSrc := TPCEImm(Src);
  Series          := IMMSrc.Series;
  Reaction        := IMMSrc.Reaction;
  Refused         := IMMSrc.Refused;
  Contraindicated := IMMSrc.Contraindicated;
  if Series = '' then Series := NoPCEValue;
  if Reaction ='' then Reaction := NoPCEValue;
end;

procedure TPCEImm.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Series   := NoPCEValue;
  Reaction := NoPCEValue;
  Refused  := False; //not currently used
  Contraindicated := false;
end;

//function TPCEImm.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEImm.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := inherited DelimitedStr;
  //Result := 'IMM' + Result + U + Series + U + IntToStr(Provider) + U + Reaction;
  Result := 'IMM' + Result + U + Series + U + U + Reaction;
  if Contraindicated then Result := Result + U + '1'
  else Result := Result + U + '0';
  Result := Result + U + U + IntToStr(UNxtCommSeqNum); 
  {the following two lines are not yet implemented in PCE side}
  //if Refused then Result := Result + U + '1'
  //else Result := Result + U + '0';
end;

(*function TPCEImm.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'IMM' + Result + U + Series + U + IntToStr(Provider) + U + Reaction;
  if Contraindicated then Result := Result + U + '1'
  else Result := Result + U + '0';
  Result := Result + U + U + comment;
    {the following two lines are not yet implemented in PCE side}
  //if Refused then Result := Result + U + '1'
  //else Result := Result + U + '0';
end;
*)
function TPCEImm.HasCPTStr: string;
begin
  Result := Code + ';AUTTIMM(';
end;

function TPCEImm.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Series <> NoPCEValue) then
    Result := GetPCECodeString(TAG_IMMSERIES, Series)
  else
    Result := '';
  Result := Result + U;
  if(Reaction <> NoPCEValue) then
    Result := Result + GetPCECodeString(TAG_IMMREACTION, Reaction);
  Result := Result + U;
  if(Contraindicated) then
    Result := Result + 'X';
  Result := Result + U + inherited ItemStr;
end;

procedure TPCEImm.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
var
  temp: String;
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Series   := Piece(x, U, pnumImmSeries);
  Reaction := Piece(x, U, pnumImmReaction);
  temp     := Piece(x, U, pnumImmRefused);
  if temp = '1' then refused  := true else refused := false;
  temp     := Piece(x, U, pnumImmContra);
  if temp = '1' then Contraindicated := true else Contraindicated := false;
  if Series = '' then series := NoPCEValue;
  if Reaction ='' then reaction := NoPCEValue;
end;



{ TPCEProc methods ------------------------------------------------------------------------- }

constructor TPCEProc.Create;    //kt added
begin
  inherited;
  ModifiersList := TStringList.Create;
  FIsOldProcedure:= false;  //kt wasn't initialized before
  Quantity := 0;            //kt wasn't initialized before
end;

destructor TPCEProc.Destroy;  //kt added
begin
  ModifiersList.Free;
  inherited;
end;

function TPCEProc.GetModifiers : string;  //kt added
var i : integer;
begin
  Result:= '';
  for i := 0 to ModifiersList.Count - 1 do begin
    Result := Result  + ModifiersList.Strings[i] + ';'
  end;
end;

procedure TPCEProc.SetModifiers(Value : string); //kt added
begin
  PiecesToList(Value,';', ModifiersList);
end;


procedure TPCEProc.Assign(Src: TPCEItem);
var ProcSrc : TPCEProc; //kt
begin
  inherited Assign(Src);
  ProcSrc   := TPCEProc(Src); //kt
  Quantity  := ProcSrc.Quantity;
  Modifiers := ProcSrc.Modifiers;
  Provider  := ProcSrc.Provider;
end;

procedure TPCEProc.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
  Quantity := 0;
  Modifiers := '';
//  Provider := 0;
  Provider := 0;
end;

{
procedure TPCEProc.CopyProc(Dest: TPCEProc);
begin
  Dest.FDelete    := FDelete;
  Dest.FSend      := Fsend;                          //flag to send to broker
  Dest.Provider   := Provider;
  Dest.Code       := Code;
  Dest.Category   := Category;
  Dest.Narrative  := Narrative;
  Dest.Comment    := Comment;
  Dest.Modifiers  := Modifiers;
end;
}

//function TPCEProc.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEProc.DelimitedStr: string;
var
  i, cnt: integer;
  Mods, ModIEN, tmpProv: string;

{created delimited string to pass to broker}
begin
  i := 1;
  cnt := 0;
  Mods := '';
  repeat
    ModIEN := piece(Modifiers, ';', i);
    if(ModIEN <> '') then
    begin
      inc(cnt);
      Mods := Mods + ';' + ModifierCode(ModIEN) + '/' + ModIEN;
      inc(i);
    end;
  until (ModIEN = '');

  Result := inherited DelimitedStr;
  if Provider > 0 then tmpProv := IntToStr(Provider) else tmpProv := '';
  Result := 'CPT' + Result + U + IntToStr(Quantity) + U + tmpProv
             + U + U + U + IntToStr(cnt) + Mods + U + IntToStr(UNxtCommSeqNum) + U;
  if Length(Result) > 250 then SetPiece(Result, U, 4, '');
end;

function TPCEProc.HasModifierIEN(IEN : string) : boolean; //kt added
var p : integer;
begin
  p := Pos(';', IEN); if p>0 then IEN := Piece(IEN,';',1);    // e.g. '16;'
  Result := (ModifiersList.IndexOf(IEN) > -1);
end;

procedure TPCEProc.EnsureModifierIEN(IEN : string); //kt added
begin
  if HasModifierIEN(IEN) then exit;
  ModifiersList.Add(IEN);
end;

procedure TPCEProc.RemoveModifierIEN(IEN : string); //kt added
var i : integer;
begin
  i := ModifiersList.IndexOf(IEN);
  if i > -1 then ModifiersList.Delete(i);
end;

function TPCEProc.HasModifier(IEN : string) : boolean;  //kt added
begin
  Result := (ModifiersList.IndexOf(IEN) > -1 );
end;

(*function TPCEProc.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'CPT' + Result + U + IntToStr(Quantity) + U + IntToStr(Provider) +
  U + U + U + U + comment;
end;
*)

function TPCEProc.Empty: boolean;
begin
  Result := (Code = '') and (Category = '') and (Narrative = '') and
            (Comment = '') and (Quantity = 0) and (Provider = 0) and (Modifiers = '');
end;

//kt removed comments.  Previously this function was commented out.
function TPCEProc.Match(AnItem: TPCEProc): Boolean;        {NEW CODE - v20 testing only - RV}
begin
  Result := inherited Match(AnItem) and (Modifiers = AnItem.Modifiers);
end;

function TPCEProc.ModText: string;
var
  i: integer;
  tmp: string;

begin
  Result := '';
  if(Modifiers <> '') then begin
    i := 1;
    repeat
      tmp := Piece(Modifiers,';',i);
      if(tmp <> '') then begin
        tmp := ModifierName(tmp);
        Result := Result + ' - ' + tmp;
      end;
      inc(i);
    until (tmp = '');
  end;
end;

function TPCEProc.ModCodes: string;  //kt added
var i: integer;
    tmp: string;
begin
  Result := '';
  for i := 1 to NumPieces(Modifiers,';') do begin
    tmp := Piece(Modifiers,';',i);
    if tmp = '' then continue;
    if Result <> '' then Result := Result + ',';
    Result := Result + ModifierCode(tmp);
  end;
end;


function TPCEProc.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
var Mods : string;
begin
  //kt mod ---
  Result := Ifthen(Quantity > 1, IntToStr(Quantity)+' times', '');
  Mods := ModCodes;
  if Mods <> '' then Mods := ' -- Mod: ' + Mods;
  Result := Result + U + inherited ItemStr + Mods;
  //kt end mod ---
  {  //kt original below
  if(Quantity > 1) then
    Result := IntToStr(Quantity) + ' times'
  else
    Result := '';
  Result := Result + U + inherited ItemStr + ModText;
  }
end;

procedure TPCEProc.SetFromString(const x: string);
//x format:
//  piece  2  -> Code
//         3  -> Category
//         4  -> Narrative
//         5  -> Quantity
//         6  -> Provider
//         9  -> Modifiers
//         10 -> Comment
var
  i, cnt: integer;
  Mods: string;

begin
  inherited SetFromString(x);
  Quantity := StrToIntDef(Piece(x, U, pnumProcQty), 1);
  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Modifiers := '';
  Mods := Piece(x, U, pnumCPTMods);
  cnt := StrToIntDef(Piece(Mods, ';', 1), 0);
  //kt old --> if(cnt > 0) then for i := 1 to cnt do begin   //kt no need for if test
  for i := 1 to cnt do begin  //kt
     Modifiers := Modifiers + Piece(Piece(Mods, ';' , i+1), '/', 2) + ';';
  end;
end;

{ TNotifyPCEEventList methods ------------------------------------------------------------------------- }
//kt added section

function TNotifyPCEEventList.GetProc(index: integer) : TNotifyPCEEvent;
begin
  Result := nil;
  if (index > -1) and (index < Self.count) then begin
    Result := TNotifyPCEEvent(Self.Objects[index]);
  end;
end;

function TNotifyPCEEventList.IndexIsData(index : integer) : boolean;
begin
  Result := false;
  if (index < 0) or (index >= Count) then exit;
  Result := (Pos('DATA=', Self.Strings[index])>0) ;
end;

function TNotifyPCEEventList.GetAndRemoveData(Name : string) : pointer;
var i : integer;
    s : string;
begin
  Result := nil;
  Name := 'DATA='+Name;
  for i := Count - 1 downto 0 do begin
    s := Self.Strings[i];
    if s <> Name then continue;
    Result := Self.Objects[i];
    Delete(i);
    break;
  end;
end;

function TNotifyPCEEventList.GetAndRemoveDataInt(Name : string) : integer;
begin
  Result := Integer(GetAndRemoveData(Name));
end;

function TNotifyPCEEventList.GetAndRemoveDataBool(Name : string) : boolean;
begin
  Result := (GetAndRemoveDataInt(Name) = 1);
end;

procedure TNotifyPCEEventList.AddDataObj(Name : string; Data : pointer);
begin
  AddObject('DATA='+Name, Data);
end;

procedure TNotifyPCEEventList.AddDataInt(Name : string; Data : integer);
begin
  AddDataObj(name, pointer(Data));
end;

procedure TNotifyPCEEventList.AddDataBool(Name : string; Data : boolean);
const BOOL_TO_INT : array[false..true] of integer = (0,1);
begin
  AddDataInt(name, BOOL_TO_INT[Data]);
end;


procedure TNotifyPCEEventList.PopAndCall(PCEData: TPCEData);
var AProc : TNotifyPCEEvent;
    i : integer;
    ID : string;
begin
  for i := Count - 1 downto 0 do begin
    if IndexIsData(i) then continue;
    AProc := GetProc(i);
    ID := Self.Strings[i];
    Delete(i);
    AProc(PCEData, Self);
    break;
  end;
end;


{ TPCEProcList methods ------------------------------------------------------------------------- }

  function TPCEProcList.GetProc(index : integer) : TPCEProc;
  //kt added
  begin
    if ValidIndex(index) then begin
      Result := TPCEProc(Self.Items[index]);
    end else begin
      Result := nil;
    end;
  end;

  procedure TPCEProcList.FreeAndClearItems;
  //kt added
  var i : integer;
  begin
    for i := 0 to Self.Count - 1 do begin
      Self.GetProc(i).Free;
    end;
    Self.Clear;
  end;

  function TPCEProcList.ValidIndex(AnIndex : integer) : boolean;
  //kt added
  begin
    Result := ((AnIndex > -1) and (AnIndex < self.count));
  end;

  function TPCEProcList.IndexOfMatch(MatchProc : TPCEProc) : integer;
  //kt added
  var i : integer;
      AProc : TPCEProc;
  begin
    Result := -1;
    for i := 0 to Self.Count - 1 do begin
      AProc := Self.GetProc(i);
      if AProc.Deleted then continue;
      if not AProc.Match(MatchProc) then continue;
      Result := i;
      break;
    end;
  end;

  function TPCEProcList.MaxQuantity : integer;     //kt added
  var i,Q : integer;
      AProc : TPCEProc;
  begin
    Result := 0;
    for i := 0 to Self.Count - 1 do begin
      AProc := Self.GetProc(i);
      if AProc.Deleted then continue;
      Q := AProc.Quantity;
      if Q > Result then Result := Q;
    end;
  end;


  function TPCEProcList.IndexOfCodeUNarr(CodeUNarr : string) : integer;   //kt added
  //Look for matching AProc.Code + U + AProc.Narrative
  var i : integer;
      AProc : TPCEProc;
  begin
    Result := -1;
    for i := 0 to Self.Count - 1 do begin
      AProc := Self.GetProc(i);
      if AProc.Deleted then continue;
      if AProc.Code + U + AProc.Narrative <> CodeUNarr then continue;
      Result := i;
      break;
    end;
  end;

  function TPCEProcList.ProcForCodeUNarr(CodeUNarr : string) : TPCEProc;
  var i : integer;
  begin
    i := IndexOfCodeUNarr(CodeUNarr);
    if i > -1 then Result := Self.Proc[i] else Result := nil;
  end;


  function TPCEProcList.Empty : boolean;  //kt added
  var i : integer;
      AProc : TPCEProc;
  begin
    Result := true;
    for i := 0 to Self.Count - 1 do begin
      AProc := Self.GetProc(i);
      if AProc.Deleted then continue;
      Result := AProc.Empty;
      if Result = false then break;
    end;
  end;

  function TPCEProcList.FirstNonEmptyCode : string; //kt added
  var i : integer;
      AProc : TPCEProc;
  begin
    Result := '';
    for i := 0 to Self.Count - 1 do begin
      AProc := Self.GetProc(i);
      if AProc.Deleted then continue;
      Result := AProc.Code;
      if Result <> '' then break;
    end;
  end;

  function TPCEProcList.EnsureProc(Proc : TPCEProc) : TPCEProc;
  //kt added
  var
    i     : integer;
    AProc : TPCEProc;
  begin
    i := IndexOfMatch(Proc);
    if i > -1 then begin
      Result := Self.Proc[i];
    end else begin
      AProc := TPCEProc.Create;
      AProc.Assign(Proc);
      Self.Add(AProc);
      Result := AProc;
    end;
  end;

  function TPCEProcList.EnsureFromString(x : string) : TPCEProc;   //kt added
  //x format: TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov   (TYP is not used)
  //x format detail:
  //  piece  2  -> Code
  //         3  -> Category
  //         4  -> Narrative
  //         5  -> Quantity
  //         6  -> Provider
  //         9  -> Modifiers
  //         10 -> Comment

  var
    AProc : TPCEProc;
  begin
    AProc := TPCEProc.Create;
    try
      AProc.SetFromString(x);
      Result := EnsureProc(AProc); //might return a different object than AProc, if match already present
    finally
      AProc.Free;
    end;
  end;


  procedure TPCEProcList.Assign(Src : TPCEProcList);
  //kt added
  var i : integer;
      SrcProc, AProc : TPCEProc;
  begin
    Self.FreeAndClearItems;
    for i := 0 to Src.Count - 1 do begin
      SrcProc := Src.Proc[i];
      AProc := TPCEProc.Create;
      AProc.Assign(SrcProc);
      Self.Add(AProc);
    end;

  end;

  procedure TPCEProcList.SetProvider(AProvider : Int64);   //kt added
  //Set provider for all Procs that have not been deleted.
  var i : integer;
      AProc : TPCEProc;
  begin
    for i := 0 to Self.Count - 1 do begin
      AProc := Self.Proc[i];
      if AProc.Deleted then continue;
      AProc.Provider := AProvider;
    end;
  end;


{ TPCEPat methods ------------------------------------------------------------------------- }

procedure TPCEPat.Assign(Src: TPCEItem);
begin
  inherited Assign(Src);
  Level := TPCEPat(Src).Level;
  if Level = '' then Level := NoPCEValue;
end;

procedure TPCEPat.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
//  Provider := 0;
  Level    := NoPCEValue;
end;

//function TPCEPat.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
function TPCEPat.DelimitedStr: string;
{created delimited string to pass to broker}
begin
  Result := inherited DelimitedStr;
  //Result := 'PED' + Result + U + Level + U + IntToStr(Provider) + U + U + U +
  Result := 'PED' + Result + U + Level + U+ U + U + U +
   U + IntToStr(UNxtCommSeqNum);
end;

(*function TPCEPat.delimitedStrC: string;
begin
  Result := inherited DelimitedStr;
  Result := 'PED' + Result + U + Level + U + IntToStr(Provider) + U + U + U +
   U + comment;
end;
*)
function TPCEPat.HasCPTStr: string;
begin
  Result := Code + ';AUTTEDT(';
end;

function TPCEPat.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if(Level <> NoPCEValue) then
    Result := GetPCECodeString(TAG_PEDLEVEL, Level)
  else
    Result := '';
  Result := Result + U + inherited ItemStr;
end;

procedure TPCEPat.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Qty ^ Prov }
begin
  inherited SetFromString(x);
//  Provider := StrToInt64Def(Piece(x, U, pnumProvider), 0);
  Level    := Piece(x, U, pnumPEDLevel);
  if level = '' then level := NoPCEValue;
end;

{ TPCEDiag methods ------------------------------------------------------------------------- }

procedure TPCEDiag.Assign(Src: TPCEItem);
begin
  inherited Assign(Src);
  Primary    := TPCEDiag(Src).Primary;
  AddProb    := TPCEDiag(Src).AddProb;
end;

//procedure TPCEDiag.Clear;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Clear a diagnosis object.
procedure TPCEDiag.Clear;
{clear fields(properties) of class}
begin
  inherited Clear;
  Primary := False;
  //Provider := 0;
  AddProb  := False;
end;

//function TPCEDiag.DelimitedStr: string;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Create delimited string to pass to Broker.
function TPCEDiag.DelimitedStr: string;
{created delimited string to pass to broker}
var
  ProviderStr: string; {jm 9/8/99}
begin
  Result := inherited DelimitedStr;
  if(AddProb) then
    ProviderStr := IntToStr(fProvider)
  else
    ProviderStr := '';
  Result := 'POV' + Result + U + BOOLCHAR[Primary] + U + ProviderStr + U +
    BOOLCHAR[AddProb] + U + U + U;
  if(SaveComment) then Result := Result + IntToStr(UNxtCommSeqNum);
  if Length(Result) > 250 then SetPiece(Result, U, 4, '');
end;

function TPCEDiag.DelimitedStr2: string;
begin
  If Comment = '' then
  begin
    SaveComment := (OldComment <> '') or (not AddProb);
    if(SaveComment) then
      result := 'COM' + U +  IntToStr(UNxtCommSeqNum) + U + NoPCEValue
    else
      result := '';
  end
  else
  begin
    Result := 'COM' + U +  IntToStr(UNxtCommSeqNum) + U + Comment;
    SaveComment := TRUE;
  end;
  Inc(UNxtCommSeqNum);
end;

(*function TPCEDiag.DelimitedStrC: string;
{created delimited string for internal use - keep comment in same string.}
begin
  Result := inherited DelimitedStr;
  Result := 'POV' + Result + U + BOOLCHAR[Primary] + U + IntToStr(Provider)+
  U + BOOLCHAR[AddProb] + U + U + U + comment;
end;
*)
function TPCEDiag.ItemStr: string;
{returns string to be assigned to Tlist in PCEData object}
begin
  if Primary then
    Result := 'Primary'
  else
    Result := 'Secondary';
// This may change in the future if we add a check box to the grid    
  if(AddProb) then
    Result := 'Add' + U + Result
  else
    Result := U + Result;

  Result := Result + U + GetDiagnosisText((inherited ItemStr), Code);
end;

procedure TPCEDiag.Send;
//marks diagnosis to be sent;
begin
  Fsend := True;
end;

//procedure TPCEDiag.SetFromString(const x: string);
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Sets fields to pieces passed from server.
procedure TPCEDiag.SetFromString(const x: string);
{ sets fields to pieces passed from server:  TYP ^ Code ^ Category ^ Narrative ^ Primary ^ ^ ^ Comment }
begin
  inherited SetFromString(x);
  OldComment := Comment;
  Primary := (Piece(x, U, pnumDiagPrimary) = '1');
  //Provider := StrToInt64Def(Piece(x, U, pnumProvider),0);
  AddProb := (Piece(x, U, pnumDiagAdd2PL) = '1');
end;

{ TPCEData methods ------------------------------------------------------------------------- }

constructor TPCEData.Create;
begin
  FVisitTypesList   := TPCEProcList.Create;  //kt added
  FVisitTypesList.Add(TPCEProc.Create); //ensure a [0] entry
  FDiagnoses        := TList.Create;
  FProcedures       := TList.Create;
  FImmunizations    := TList.Create;
  FSkinTests        := TList.Create;
  //FVisitType      := TPCEProc.Create;
  FPatientEds       := TList.Create;
  FHealthFactors    := TList.Create;
  fExams            := TList.Create;
  FProviders        := TPCEProviderList.Create;
  FSCRelated        := SCC_NA;
  FAORelated        := SCC_NA;
  FIRRelated        := SCC_NA;
  FECRelated        := SCC_NA;
  FMSTRelated       := SCC_NA;
  FHNCRelated       := SCC_NA;
  FCVRelated        := SCC_NA;
  FSHADRelated      := SCC_NA;
  FSCChanged        := False;
end;

constructor TPCEData.Create(ASrc : TPCEData);
//kt added 5/23
begin
  Create;
  Self.Assign(ASrc);
end;

destructor TPCEData.Destroy;
var
  i: Integer;
begin
  with FDiagnoses        do for i := 0 to Count - 1 do TPCEDiag(Items[i]).Free;
  with FProcedures       do for i := 0 to Count - 1 do TPCEProc(Items[i]).Free;
  with FImmunizations    do for i := 0 to Count - 1 do TPCEImm(Items[i]).Free;
  with FSkinTests        do for i := 0 to Count - 1 do TPCESkin(Items[i]).Free;
  with FPatientEds       do for i := 0 to Count - 1 do TPCEPat(Items[i]).Free;
  with FHealthFactors    do for i := 0 to Count - 1 do TPCEHealth(Items[i]).Free;
  with FExams            do for i := 0 to Count - 1 do TPCEExams(Items[i]).Free;
  //kt FVisitType.Free;
  FVisitTypesList.FreeAndClearItems;
  FVisitTypesList.Free; //kt added
  FDiagnoses.Free;
  FProcedures.Free;
  FImmunizations.Free;  
  FSkinTests.free;      
  FPatientEds.Free;
  FHealthFactors.Free;
  FExams.Free;
  FProviders.Free;
  inherited Destroy;
end;

procedure TPCEData.Clear;

  procedure ClearList(AList: TList);
  var i: Integer;
  begin
    for i := 0 to AList.Count - 1 do
      TObject(AList[i]).Free;
    AList.Clear;
  end;

begin
  FEncDateTime := 0;
  FNoteDateTime := 0;
  FEncLocation := 0;
  FEncSvcCat   := 'A';
  FEncInpatient := FALSE;
  FProblemAdded := False;
  FEncUseCurr   := FALSE;
  FStandAlone := FALSE;
  FStandAloneLoaded := FALSE;
  FParent       := '';
  FHistoricalLocation := '';
  FSCRelated  := SCC_NA;
  FAORelated  := SCC_NA;
  FIRRelated  := SCC_NA;
  FECRelated  := SCC_NA;
  FMSTRelated := SCC_NA;
  FHNCRelated := SCC_NA;
  FCVRelated  := SCC_NA;
  FSHADRelated := SCC_NA;

  ClearList(FDiagnoses);
  ClearList(FProcedures);
  ClearList(FImmunizations);
  ClearList(FSkinTests);
  ClearList(FPatientEds);
  ClearList(FHealthFactors);
  ClearList(FExams);

  //kt FVisitType.Clear;
  FVisitTypesList.FreeAndClearItems;
  FProviders.Clear;
  FSCChanged := False;
  FNoteIEN := 0;
  FNoteTitle := 0;
end;


procedure TPCEData.CopyDiagnoses(Dest: TStrings);
begin
  CopyPCEItems(FDiagnoses, Dest, TPCEDiag);
end;

procedure TPCEData.CopyProcedures(Dest: TStrings);
begin
  CopyPCEItems(FProcedures, Dest, TPCEProc);
end;

procedure TPCEData.CopyVisits(Dest: TPCEProcList);  //kt added
begin
  CopyPCEItems(FVisitTypesList, Dest, TPCEProc);
end;

procedure TPCEData.CopyImmunizations(Dest: TStrings);
begin
  CopyPCEItems(FImmunizations, Dest, TPCEImm);
end;

procedure TPCEData.CopySkinTests(Dest: TStrings);
begin
  CopyPCEItems(FSkinTests, Dest, TPCESkin);
end;

procedure TPCEData.CopyPatientEds(Dest: TStrings);
begin
  CopyPCEItems(FPatientEds, Dest, TPCEPat);
end;

procedure TPCEData.CopyHealthFactors(Dest: TStrings);
begin
  CopyPCEItems(FHealthFactors, Dest, TPCEHealth);
end;

procedure TPCEData.CopyExams(Dest: TStrings);
begin
  CopyPCEItems(FExams, Dest, TPCEExams);
end;

function TPCEData.GetVisitString: string;
begin
  Result :=  IntToStr(FEncLocation) + ';' + FloatToStr(VisitDateTime) + ';' + FEncSvcCat;
end;

function TPCEData.GetCPTRequired: Boolean;
begin
  Result := (([ndDiag, ndProc] * NeededPCEData) <> []);
end;

procedure TPCEData.PCEForNote(NoteIEN: Integer; PotentialSrcObj: TPCEData);
//kt notes:
//   NoteIEN         -- IEN of current notew
//   PotentialSrcObj -- this is sometimes used as a source to copy from, under certain circumstances.
//                      If PotentialSrcObj matches VisitStr for NoteIEN (or current Encounter), and copied, then not loaded from server again.
//                      Was renamed from EditObj -> PotentialSrcObj:

var
  i, j: Integer;
  TmpCat, TmpVStr: string;
  x: string;
  DoCopy, IsVisit: Boolean;
  PCEList:       TStringList;
  ListOfPotentialVisitCodes: TPieceStringList; //kt Fmt:  <CPT Code>^<Section Name>^<Narrative>   This is a list of all visit-type CPT's that could be chosen between  RENAMED.  Was VisitTypeList  //kt was TStringList
  ADiagnosis:    TPCEDiag;
  AProcedure:    TPCEProc;
  AImmunization: TPCEImm;
  ASkinTest:     TPCESkin;
  APatientEd:    TPCEPat;
  AHealthFactor: TPCEHealth;
  AExam:         TPCEExams;
  FileVStr: string;
  FileIEN: integer;
  GetCat, DoRestore: boolean;
  FRestDate: TFMDateTime;
//  AProvider:     TPCEProvider;  {6/9/99}
  tempCPTInfo : string; //kt
  CPTStr : string; //kt
  MsgType,MsgOpt1 : string; //kt

  function SCCValue(x: string): Integer;
  begin
    Result := SCC_NA;
    if Piece(x, U, 3) = '1' then Result := SCC_YES;
    if Piece(x, U, 3) = '0' then Result := SCC_NO;
  end;

  function AppendComment(x: string): String;
  begin
    //check for comment append string if a comment exists
    If (((i+1) <= (PCEList.Count - 1)) and (Copy(PCEList[(i+1)], 1, 3) = 'COM')) then
    begin
      //remove last piece (comment sequence number) from x.
      While x[length(x)] <> U do
        x := Copy(X,0,(length(x)-1));
      //add last piece of comment to x
      x := X + Piece (PCEList[(i+1)],U,3);
    end;
    result := x;
  end;

begin //TPCEData.PCEForNote
  Clear;  //kt moved up from below. This may be a mistake...  4/8/23
          //kt NOTE: Clear sets self.FEncSvcCat to 'A', so it will never be #0 in test below.
          
  //Setup TmpVStr.  Either get from passed in NoteIEN or current Encounter data
  if(NoteIEN < 1) then begin
    TmpVStr := Encounter.VisitStr  //kt note: Encounter is a globally scoped var, ucore.Encounter
  end else begin
    TmpVStr := VisitStrForNote(NoteIEN);
    if(FEncSvcCat = #0) then begin
      GetCat :=TRUE
    end else if(GetVisitString = '0;0;A') then begin
      FEncLocation := StrToIntDef(Piece(TmpVStr, ';', 1), 0);
      FEncDateTime := StrToFloatDef(Piece(TmpVStr, ';', 2),0);
      GetCat :=TRUE
    end else begin
      GetCat := FALSE;
    end;
    if (GetCat) then begin
      TmpCat := Piece(TmpVStr, ';', 3);
      if(TmpCat <> '') then begin
        FEncSvcCat := TmpCat[1];
      end;
    end;
  end;

  //If passed PotentialSrcObj matches TmpVStr, then copy PotentialSrcObj to self
  if(assigned(PotentialSrcObj)) then begin
    if(copy(TmpVStr,1,2) <> '0;') and   // has location
      (pos(';0;',TmpVStr) = 0) and      // has time
      (PotentialSrcObj.GetVisitString = TmpVStr) then
    begin
      if(FEncSvcCat = 'H') and (FEncInpatient) then begin
        DoCopy := (FNoteDateTime = PotentialSrcObj.FNoteDateTime)
      end else begin
        DoCopy := TRUE;
      end;
      if(DoCopy) then begin
        if(PotentialSrcObj <> Self) then begin
          PotentialSrcObj.CopyPCEData(Self); //Copy PotentialSrcObj -> self
          FNoteTitle := 0;
          //kt removing.  Why was this here ?? --> FNoteIEN := 0;   //kt 4/8/23
        end;
        exit;
      end;
    end;
  end;

  TmpCat := Piece(TmpVStr, ';', 3);
  if(TmpCat <> '') then begin
    FEncSvcCat := TmpCat[1]
  end else begin
    FEncSvcCat := ' ';
  end;
  //TMG changed below because in certain instances #0 was being sent to a
  //health factor save, causing a crash. This is an attempt to keep the value from being
  //null.
  //FEncSvcCat := #0;
  FEncLocation := StrToIntDef(Piece(TmpVStr,';',1),0);
  FEncDateTime := StrToFloatDef(Piece(TmpVStr, ';', 2),0);

  if(IsSecondaryVisit and (FEncLocation > 0)) then begin
    FileIEN := USE_CURRENT_VISITSTR;
    FileVStr := IntToStr(FEncLocation) + ';' + FloatToStr(FNoteDateTime) + ';' +
                                               GetLocSecondaryVisitCode(FEncLocation);
    DoRestore := TRUE;
    FRestDate := FEncDateTime;
  end else begin
    DoRestore := FALSE;
    FRestDate := 0;
    FileIEN := NoteIEN;
    if(FileIEN < 0) then begin
      FileVStr := Encounter.VisitStr
    end else begin
      FileVStr := '';
    end;
  end;

  //kt note: What is the point of this?? The code above loads up self.  Why then just clear it??
  //kt moving to above 4/8/23 --> Clear;
  PCEList                   := TStringList.Create;
  ListOfPotentialVisitCodes := TPieceStringList.Create;
  try
    LoadPCEDataForNote(PCEList, FileIEN, FileVStr);        // calls broker RPC to load data
    FNoteIEN := NoteIEN;
    for i := 0 to PCEList.Count - 1 do begin
      x := PCEList[i];
      MsgType := piece(x, U ,1); //kt added

      {header information-------------------------------------------------------------}
      //kt if Copy(x, 1, 4) = 'HDR^' then begin          // HDR ^ Inpatient ^ ProcReq ^ VStr ^ Provider
      if MsgType = 'HDR' then begin          // HDR ^ Inpatient ^ ProcReq ^ VStr ^ Provider
        FEncInpatient := Piece(x, U, 2) = '1';
        //FCPTRequired  := Piece(x, U, 3) = '1';
        //FNoteHasCPT   := Piece(x, U, 6) = '1';    //4/21/99 error! PIECE 3 = cptRequired, not HasCPT!
        FEncLocation  := StrToIntDef(Piece(Piece(x, U, 4), ';', 1), 0);
        if DoRestore then begin
          FEncSvcCat := 'H';
          FEncDateTime := FRestDate;
          FNoteDateTime := MakeFMDateTime(Piece(Piece(x, U, 4), ';', 2));
        end else begin
          FEncDateTime  := MakeFMDateTime(Piece(Piece(x, U, 4), ';', 2));
          FEncSvcCat    := CharAt(Piece(Piece(x, U, 4), ';', 3), 1);
        end;
        //FEncProvider  := StrToInt64Def(Piece(x, U, 5), 0);
        ListVisitTypeByLoc(ListOfPotentialVisitCodes, FEncLocation, FEncDateTime);
        //set the values needed fot the RPCs
        SetRPCEncLocation(FEncLocation);
//        SetRPCEncDateTime(FEncDateTime);
        continue; //kt
      end;

      {visit information--------------------------------------------------------------}
      if MsgType = 'VST' then begin
        MsgOpt1 := piece(x, U, 2); //kt
        if MsgOpt1 = 'DT' then begin
          if DoRestore then begin
            FEncDateTime := FRestDate;
            FNoteDateTime := MakeFMDateTime(Piece(x, U, 3));
          end else begin
            FEncDateTime := MakeFMDateTime(Piece(x, U, 3));
          end;
        end
        else if MsgOpt1 = 'HL'  then FEncLocation := StrToIntDef(Piece(x, U, 3), 0)
        else if MsgOpt1 = 'VC'  then begin
          if DoRestore then begin
            FEncSvcCat := 'H'
          end else begin
            FEncSvcCat := CharAt(x, 8);
          end;
        end
        else if MsgOpt1 = 'PS'  then FEncInpatient := CharAt(x, 8) = '1'
        else if MsgOpt1 = 'SC'  then FSCRelated := SCCValue(x)
        else if MsgOpt1 = 'AO'  then FAORelated := SCCValue(x)
        else if MsgOpt1 = 'IR'  then FIRRelated := SCCValue(x)
        else if MsgOpt1 = 'EC'  then FECRelated := SCCValue(x)
        else if MsgOpt1 = 'MST' then FMSTRelated := SCCValue(x)
        else if MsgOpt1 = 'HNC' then FHNCRelated := SCCValue(x)
        else if MsgOpt1 = 'CV'  then FCVRelated := SCCValue(x);
        continue; //kt
      end;

      { //kt orginal code below
      if Copy(x, 1, 7) = 'VST^DT^' then begin
        if DoRestore then begin
          FEncDateTime := FRestDate;
          FNoteDateTime := MakeFMDateTime(Piece(x, U, 3));
        end else begin
          FEncDateTime := MakeFMDateTime(Piece(x, U, 3));
        end;
      end;
      if Copy(x, 1, 7) = 'VST^HL^' then FEncLocation := StrToIntDef(Piece(x, U, 3), 0);
      if Copy(x, 1, 7) = 'VST^VC^' then begin
        if DoRestore then begin
          FEncSvcCat := 'H'
        end else begin
          FEncSvcCat := CharAt(x, 8);
        end;
      end;
      if Copy(x, 1, 7) = 'VST^PS^'  then FEncInpatient := CharAt(x, 8) = '1';
      if Copy(x, 1, 7) = 'VST^SC^'  then FSCRelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^AO^'  then FAORelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^IR^'  then FIRRelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^EC^'  then FECRelated := SCCValue(x);
      if Copy(x, 1, 8) = 'VST^MST^' then FMSTRelated := SCCValue(x);
      if Copy(x, 1, 8) = 'VST^HNC^' then FHNCRelated := SCCValue(x);
      if Copy(x, 1, 7) = 'VST^CV^'  then FCVRelated := SCCValue(x);
      }
      {Providers---------------------------------------------------------------------}
      if (Copy(x, 1, 3) = 'PRV') and (CharAt(x, 4) <> '-') then begin
        FProviders.Add(x);
        continue; //kt
      end;

      {'POV'=Diagnosis--------------------------------------------------------------}
      if (Copy(x, 1, 3) = 'POV') and (CharAt(x, 4) <> '-') then begin
        //check for comment append string if a comment exists
        x := AppendComment(x);
        ADiagnosis := TPCEDiag.Create;
        ADiagnosis.SetFromString(x);
        FDiagnoses.Add(ADiagnosis);
        continue; //kt
      end;

      {CPT (procedure) information--------------------------------------------------}
      if (Copy(x, 1, 3) = 'CPT') and (CharAt(x, 4) <> '-') then begin
        x := AppendComment(x);

        tempCPTInfo := Pieces(x, U, 2, 4);
        CPTStr := piece(x, U, 2);
        IsVisit := (ListOfPotentialVisitCodes.IndexOfPiece(1, CPTStr) >= 0); //kt replacement
        //IsVisit := False;
        //with VisitTypeList do for j := 0 to Count - 1 do begin
        //  if Pieces(x, U, 2, 4) = Strings[j] then IsVisit := True;
        //end;
        //kt end mod ---

        //kt original --> if IsVisit and (FVisitType.Code = '') then begin
        //kt original -->   FVisitType.SetFromString(x)
        if IsVisit then begin
          FVisitTypesList.EnsureFromString(x); //kt added
        end else begin
          AProcedure := TPCEProc.Create;
          AProcedure.SetFromString(x);
          AProcedure.fIsOldProcedure := TRUE;
          FProcedures.Add(AProcedure);
        end; {if IsVisit}
        continue; //kt
      end; {if Copy .. 'CPT'}

      {Immunizations ---------------------------------------------------------------}
      if (Copy(x, 1, 3) = 'IMM') and (CharAt(x, 4) <> '-') then begin
        x := AppendComment(x);
        AImmunization := TPCEImm.Create;
        AImmunization.SetFromString(x);
        FImmunizations.Add(AImmunization);
        continue; //kt
      end;

      {Skin Tests-------------------------------------------------------------------}
      if (Copy(x, 1, 2) = 'SK') and (CharAt(x, 3) <> '-') then begin
        x := AppendComment(x);
        ASkinTest := TPCESkin.Create;
        ASkinTest.SetFromString(x);
        FSkinTests.Add(ASkinTest);
        continue; //kt
      end;

      {Patient Educations------------------------------------------------------------}
      if (Copy(x, 1, 3) = 'PED') and (CharAt(x, 4) <> '-') then begin
        x := AppendComment(x);
        APatientEd := TPCEpat.Create;
        APatientEd.SetFromString(x);
        FpatientEds.Add(APatientEd);
        continue; //kt
      end;

      {Health Factors----------------------------------------------------------------}
      if (Copy(x, 1, 2) = 'HF') and (CharAt(x, 3) <> '-') then begin
        x := AppendComment(x);
        AHealthFactor := TPCEHealth.Create;
        AHealthFactor.SetFromString(x);
        FHealthFactors.Add(AHealthFactor);
        continue; //kt
      end;

      {Exams ------------------------------------------------------------------------}
      if (Copy(x, 1, 3) = 'XAM') and (CharAt(x, 3) <> '-') then begin
        x := AppendComment(x);
        AExam := TPCEExams.Create;
        AExam.SetFromString(x);
        FExams.Add(AExam);
        continue; //kt
      end;

    end;
  finally
    PCEList.Free;
    ListOfPotentialVisitCodes.Free;
  end;
end;

//procedure TPCEData.Save;
//modified: 6/17/98
//By: Robert Bott
//Location: ISL
//Purpose: Add Comments to PCE Items.
//kt original --> procedure TPCEData.Save;
procedure TPCEData.Save(ForceForegroundSave : boolean = false);  //kt added ForceForegroundSave
{ pass the changes to the encounter to DATA2PCE,
  Pieces: Subscript^Code^Qualifier^Category^Narrative^Delete }
var
  i: Integer;
  x, AVisitStr, EncName, Temp2: string;
  PCEList: TStringList;
  FileCat: char;
  FileDate: TFMDateTime;
  FileNoteIEN: integer;
  dstring1,dstring2: pchar; //used to separate former DelimitedStr variable
                             // into two strings, the second being for the comment.
  APCEDx: TPCEDiag; //kt
  AVisitType : TPCEProc; //kt
begin
  PCEList := TStringList.Create;
  UNxtCommSeqNum := 1;
  try
    with PCEList do begin
      if(IsSecondaryVisit) then begin
        FileCat := GetLocSecondaryVisitCode(FEncLocation);
        FileDate := FNoteDateTime;
        FileNoteIEN := NoteIEN;
        if((NoteIEN > 0) and ((FParent = '') or (FParent = '0'))) then begin
          FParent := GetVisitIEN(NoteIEN);
        end;
      end else begin
        FileCat := FEncSvcCat;
        FileDate := FEncDateTime;
        FileNoteIEN := 0;
        if FileCat = #0 then FileCat := GetLocSecondaryVisitCode(FEncLocation); //TMG added for historical HFs in note addendums
      end;
      if FileCat = #0 then begin  //TMG added if, to ensure null value not sent in RPC
        messagedlg('Category is null. Can not save health factor. Contact IT',mtError,[mbOK],0);
        exit;
      end;
      AVisitStr :=  IntToStr(FEncLocation) + ';' + FloatToStr(FileDate) + ';' + FileCat;
      Add('HDR^' + BOOLCHAR[FEncInpatient] + U + U + AVisitStr);
//      Add('HDR^' + BOOLCHAR[FEncInpatient] + U + BOOLCHAR[FNoteHasCPT] + U + AVisitStr);
      // set up list that can be passed via broker to set up array for DATA2PCE
      Add('VST^DT^' + FloatToStr(FileDate));  // Encounter Date/Time
      Add('VST^PT^' + Patient.DFN);               // Encounter Patient    //*DFN*
      if(FEncLocation > 0) then
        Add('VST^HL^' + IntToStr(FEncLocation));    // Encounter Location
      Add('VST^VC^' + FileCat);                // Encounter Service Category
      if(StrToIntDef(FParent,0) > 0) then
        Add('VST^PR^' + FParent);                 // Parent for secondary visit
      if(FileCat = 'E') and (FHistoricalLocation <> '') then
        Add('VST^OL^' + FHistoricalLocation);     // Outside Location
      FastAddStrings(FProviders, PCEList);

      if FSCChanged then begin
        if FSCRelated   <> SCC_NA then Add('VST^SC^'  + IntToStr(FSCRelated));
        if FAORelated   <> SCC_NA then Add('VST^AO^'  + IntToStr(FAORelated));
        if FIRRelated   <> SCC_NA then Add('VST^IR^'  + IntToStr(FIRRelated));
        if FECRelated   <> SCC_NA then Add('VST^EC^'  + IntToStr(FECRelated));
        if FMSTRelated  <> SCC_NA then Add('VST^MST^' + IntToStr(FMSTRelated));
        if FHNCRelated  <> SCC_NA then Add('VST^HNC^' + IntToStr(FHNCRelated));
        if FCVRelated   <> SCC_NA then Add('VST^CV^'  + IntToStr(FCVRelated));
        if FSHADRelated <> SCC_NA then Add('VST^SHD^' + IntToStr(FSHADRelated));
      end;
{
      with FDiagnoses  do for i := 0 to Count - 1 do with TPCEDiag(Items[i]) do begin
        if FSend then begin
          Temp2 := DelimitedStr2; // Call first to make sure SaveComment is set.
          if SaveComment then begin
            dec(UNxtCommSeqNum);
          end;
          fProvider := FProviders.PCEProvider;
          // Provides user with list of dx when signing orders - Billing Aware
          PCEList.Add(DelimitedStr);
          if SaveComment then begin
            inc(UNxtCommSeqNum);
            if Temp2 <> '' then begin
              PCEList.Add(Temp2);
            end;
          end;
        end;
      end;
}
      for i := 0 to FDiagnoses.Count - 1 do begin
        APCEDx := TPCEDiag(FDiagnoses.Items[i]);
        with APCEDx do begin
          if FSend then begin
            Temp2 := DelimitedStr2; // Call first to make sure SaveComment is set.
            if SaveComment then begin
              dec(UNxtCommSeqNum);
            end;
            fProvider := FProviders.PCEProvider;
            // Provides user with list of dx when signing orders - Billing Aware
            PCEList.Add(DelimitedStr);
            if SaveComment then begin
              inc(UNxtCommSeqNum);
              if Temp2 <> '' then begin
                PCEList.Add(Temp2);
              end;
            end;
          end;
        end;
      end;

      with FProcedures do for i := 0 to Count - 1 do with TPCEProc(Items[i]) do begin
        if FSend then begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      end;
      with FImmunizations do for i := 0 to Count - 1 do with TPCEImm(Items[i]) do begin
        if FSend then begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      end;
      with FSkinTests do for i := 0 to Count - 1 do with TPCESkin(Items[i]) do begin
        if FSend then begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      end;
      with FPatientEds do for i := 0 to Count - 1 do with TPCEPat(Items[i]) do begin
        if FSend then begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      end;
      with FHealthFactors do for i := 0 to Count - 1 do with TPCEHealth(Items[i]) do begin
        if FSend then begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      end;
      with FExams do for i := 0 to Count - 1 do with TPCEExams(Items[i]) do begin
        if FSend then begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      end;
      //kt added this block
      for i := 0 to FVisitTypesList.Count-1 do begin
        AVisitType := FVisitTypesList.Proc[i];
        with AVisitType do begin
          if Code = '' then FSend := false;
          if FSend then begin
            PCEList.Add(DelimitedStr);
            PCEList.Add(DelimitedStr2);
          end;
        end;
      end;
      {//kt original code
      with FVisitType  do begin
        if Code = '' then Fsend := false;
        if FSend then begin
          PCEList.Add(DelimitedStr);
          PCEList.Add(DelimitedStr2);
        end;
      end;
      }

      // call DATA2PCE (in background)
      SavePCEData(PCEList, FileNoteIEN, FEncLocation);
      //kt moved to fEncounterLabs.SendData -->  TMGLabOrderAutoPopulateIfActive; //kt added

      // turn off 'Send' flags and remove items that were deleted
      with FDiagnoses  do for i := Count - 1 downto 0 do with TPCEDiag(Items[i]) do begin
        FSend := False;
        // for diags, toggle off AddProb flag as well
        AddProb := False;
        if FDelete then begin
          TPCEDiag(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FProcedures do for i := Count - 1 downto 0 do with TPCEProc(Items[i]) do begin
        FSend := False;
        if FDelete then begin
          TPCEProc(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FImmunizations do for i := Count - 1 downto 0 do with TPCEImm(Items[i]) do begin
        FSend := False;
        if FDelete then begin
          TPCEImm(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FSkinTests do for i := Count - 1 downto 0 do with TPCESkin(Items[i]) do begin
        FSend := False;
        if FDelete then begin
          TPCESkin(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FPatientEds do for i := Count - 1 downto 0 do with TPCEPat(Items[i]) do begin
        FSend := False;
        if FDelete then begin
          TPCEPat(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FHealthFactors do for i := Count - 1 downto 0 do with TPCEHealth(Items[i]) do begin
        FSend := False;
        if FDelete then begin
          TPCEHealth(Items[i]).Free;
          Delete(i);
        end;
      end;
      with FExams do for i := Count - 1 downto 0 do with TPCEExams(Items[i]) do begin
        FSend := False;
        if FDelete then begin
          TPCEExams(Items[i]).Free;
          Delete(i);
        end;
      end;
      for i := FProviders.Count - 1 downto 0 do begin
        if(FProviders.ProviderData[i].Delete) then begin
          FProviders.Delete(i);
        end;
      end;

      //kt added block below
      for i := FVisitTypesList.Count-1 downto 0 do begin
        AVisitType := FVisitTypesList.Proc[i];
        AVisitType.FSend := False;
        if AVisitType.FDelete then begin
          AVisitType.Free;
          FVisitTypesList.Delete(i);
        end;
      end;
      //kt original --> if FVisitType.FDelete then FVisitType.Clear else FVisitType.FSend := False;

    end; {with PCEList}
    //if (FProcedures.Count > 0) or (FVisitType.Code <> '') then FCPTRequired := False;

    // update the Changes object
    EncName := FormatFMDateTime('mmm dd,yy hh:nn', FileDate);

    //kt added block
    for i := 0 to FVisitTypesList.Count - 1 do begin
      AVisitType := FVisitTypesList.Proc[i];
      x := StrVisitType(AVisitType);
      if Length(x) > 0 then Changes.Add(CH_PCE, 'V' + AVisitStr, x, EncName, CH_SIGN_NA);
    end;
    {//kt original code
    x := StrVisitType;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'V' + AVisitStr, x, EncName, CH_SIGN_NA);
    }

    x := StrProcedures;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'P' + AVisitStr, x, EncName, CH_SIGN_NA);

    x := StrDiagnoses;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'D' + AVisitStr, x, EncName, CH_SIGN_NA,
       Parent, User.DUZ, '', False, False, ProblemAdded);

    x := StrImmunizations;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'I' + AVisitStr, x, EncName, CH_SIGN_NA);

    x := StrSkinTests;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'S' + AVisitStr, x, EncName, CH_SIGN_NA);

    x := StrPatientEds;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'A' + AVisitStr, x, EncName, CH_SIGN_NA);

    x := StrHealthFactors;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'H' + AVisitStr, x, EncName, CH_SIGN_NA);

    x := StrExams;
    if Length(x) > 0 then Changes.Add(CH_PCE, 'E' + AVisitStr, x, EncName, CH_SIGN_NA);

  finally
    PCEList.Free;
  end;
end;

function TPCEData.MatchItem(AList: TList; AnItem: TPCEItem): Integer;
{ return index in AList of matching item }
var
  i: Integer;
begin
  Result := -1;
  with AList do for i := 0 to Count - 1 do with TPCEItem(Items[i]) do if Match(AnItem) and MatchProvider(AnItem)then
  begin
    Result := i;
    break;
  end;
end;

procedure TPCEData.MarkDeletions(PreList: TList; PostList: TStrings);
{mark items that need deleted}
var
  i, j: Integer;
  MatchFound: Boolean;
  PreItem, PostItem: TPCEItem;
begin
  with PreList do for i := 0 to Count - 1 do begin
    PreItem := TPCEItem(Items[i]);
    MatchFound := False;
    with PostList do for j := 0 to Count - 1 do begin
      PostItem := TPCEItem(Objects[j]);
      if (PreItem.Match(PostItem) and (PreItem.MatchProvider(PostItem))) then MatchFound := True;
    end;
    if not MatchFound then begin
      PreItem.FDelete := True;
      PreItem.FSend   := True;
    end;
  end;
end;

procedure TPCEData.MarkDeletions(PreList: TList; PostList: TList);  //kt added
{mark items that need deleted}
var
  i, j: Integer;
  MatchFound: Boolean;
  PreItem, PostItem: TPCEItem;
begin
  with PreList do for i := 0 to Count - 1 do begin
    PreItem := TPCEItem(Items[i]);
    MatchFound := False;
    with PostList do for j := 0 to Count - 1 do begin
      PostItem := TPCEItem(Items[j]);
      if (PreItem.Match(PostItem) and (PreItem.MatchProvider(PostItem))) then MatchFound := True;
    end;
    if not MatchFound then begin
      PreItem.FDelete := True;
      PreItem.FSend   := True;
    end;
  end;
end;


procedure TPCEData.SetDiagnoses(Src: TStrings; FromForm: boolean = TRUE);
{ load diagnoses for this encounter into TPCEDiag records, assumes all diagnoses for the
  encounter will be listed in Src and marks those that are not in Src for deletion -- if FromForm}
var
  i, MatchIndex: Integer;
  SrcDiagnosis, CurDiagnosis, PrimaryDiag: TPCEDiag;
begin
  if FromForm then MarkDeletions(FDiagnoses, Src);
  PrimaryDiag := nil;
  for i := 0 to Src.Count - 1 do begin
    SrcDiagnosis := TPCEDiag(Src.Objects[i]);
    MatchIndex := MatchItem(FDiagnoses, SrcDiagnosis);
    if MatchIndex > -1 then begin   //found in fdiagnoses
      CurDiagnosis := TPCEDiag(FDiagnoses.Items[MatchIndex]);
      if ((SrcDiagnosis.Primary <> CurDiagnosis.Primary) or
       (SrcDiagnosis.Comment <> CurDiagnosis.Comment) or
       (SrcDiagnosis.AddProb <> CurDiagnosis.Addprob)) then
      begin
        CurDiagnosis.Primary    := SrcDiagnosis.Primary;
        CurDiagnosis.Comment    := SrcDiagnosis.Comment;
        CurDiagnosis.AddProb    := SrcDiagnosis.AddProb;
        CurDiagnosis.FSend := True;
      end;
    end else begin
      CurDiagnosis := TPCEDiag.Create;
      CurDiagnosis.Assign(SrcDiagnosis);
      CurDiagnosis.FSend := True;
      FDiagnoses.Add(CurDiagnosis);
    end; {if MatchIndex}
    if(CurDiagnosis.Primary and (not assigned(PrimaryDiag))) then
      PrimaryDiag := CurDiagnosis;
    if (CurDiagnosis.AddProb) then
      FProblemAdded := True;
  end; {for}
  if(assigned(PrimaryDiag)) then begin
    for i := 0 to FDiagnoses.Count - 1 do begin
      CurDiagnosis := TPCEDiag(FDiagnoses[i]);
      if(CurDiagnosis.Primary) and (CurDiagnosis <> PrimaryDiag) then begin
        CurDiagnosis.Primary := FALSE;
        CurDiagnosis.FSend := True;
      end;
    end;
  end;
end;

procedure TPCEData.SetProcedures(Src: TStrings; FromForm: boolean = TRUE);
{ load Procedures for this encounter into TPCEProc records, assumes all Procedures for the
  encounter will be listed in Src and marks those that are not in Src for deletion  -- if FromForm}
var
  i, MatchIndex: Integer;
  SrcProcedure, CurProcedure, OldProcedure: TPCEProc;
begin
  if FromForm then MarkDeletions(FProcedures, Src);
  for i := 0 to Src.Count - 1 do begin
    SrcProcedure := TPCEProc(Src.Objects[i]);
    MatchIndex := MatchItem(FProcedures, SrcProcedure);
    if MatchIndex > -1 then begin
      CurProcedure := TPCEProc(FProcedures.Items[MatchIndex]);
(*      if (SrcProcedure.Provider <> CurProcedure.Provider) then
      begin
        OldProcedure := TPCEProc.Create;
        OldProcedure.Assign(CurProcedure);
        OldProcedure.FDelete := TRUE;
        OldProcedure.FSend := TRUE;
        FProcedures.Add(OldProcedure);
      end;*)
      if (SrcProcedure.Quantity <> CurProcedure.Quantity) or
         (SrcProcedure.Provider <> CurProcedure.Provider) or
         (Curprocedure.Comment <> SrcProcedure.Comment) or
         (Curprocedure.Modifiers <> SrcProcedure.Modifiers)then
      begin
        OldProcedure := TPCEProc.Create;
        OldProcedure.Assign(CurProcedure);
        OldProcedure.FDelete := TRUE;
        OldProcedure.FSend := TRUE;
        FProcedures.Add(OldProcedure);
        CurProcedure.Quantity := SrcProcedure.Quantity;
        CurProcedure.Provider := SrcProcedure.Provider;
        CurProcedure.Comment := SrcProcedure.Comment;
        CurProcedure.Modifiers := SrcProcedure.Modifiers;
        CurProcedure.FSend := True;
      end;
    end else begin
      CurProcedure := TPCEProc.Create;
      CurProcedure.Assign(SrcProcedure);
      CurProcedure.FSend := True;
      FProcedures.Add(CurProcedure);
    end; {if MatchIndex}
  end; {for}
end;


procedure TPCEData.SetVisits(Src : TPCEProcList; FromForm: boolean = TRUE); //kt added
var
  i, MatchIndex: Integer;
  SrcVisit, CurVisit, OldVisit: TPCEProc;
begin
  //Code copied and modified from SetProcedures
  if FromForm then MarkDeletions(FVisitTypesList, Src);
  for i := 0 to Src.Count - 1 do begin
    SrcVisit := Src.Proc[i];
    MatchIndex := MatchItem(FVisitTypesList, SrcVisit);
    if MatchIndex > -1 then begin
      CurVisit := FVisitTypesList.Proc[MatchIndex];
      if (SrcVisit.Quantity <> CurVisit.Quantity) or
         (SrcVisit.Provider <> CurVisit.Provider) or
         (CurVisit.Comment <> SrcVisit.Comment) or
         (CurVisit.Modifiers <> SrcVisit.Modifiers)then
      begin
        OldVisit := TPCEProc.Create;
        OldVisit.Assign(CurVisit);
        OldVisit.FDelete := TRUE;
        OldVisit.FSend := TRUE;
        FVisitTypesList.Add(OldVisit);
        CurVisit.Quantity := SrcVisit.Quantity;
        CurVisit.Provider := SrcVisit.Provider;
        CurVisit.Comment := SrcVisit.Comment;
        CurVisit.Modifiers := SrcVisit.Modifiers;
        CurVisit.FSend := True;
      end;
    end else begin
      CurVisit := TPCEProc.Create;
      CurVisit.Assign(SrcVisit);
      CurVisit.FSend := True;
      FVisitTypesList.Add(CurVisit);
    end; {if MatchIndex}
  end; {for}
end;

procedure TPCEData.SetImmunizations(Src: TStrings; FromForm: boolean = TRUE);
{ load Immunizations for this encounter into TPCEImm records, assumes all Immunizations for the
  encounter will be listed in Src and marks those that are not in Src for deletion  -- if FromForm}
var
  i, MatchIndex: Integer;
  SrcImmunization, CurImmunization: TPCEImm;
begin
  if FromForm then MarkDeletions(FImmunizations, Src);
  for i := 0 to Src.Count - 1 do begin
    SrcImmunization := TPCEImm(Src.Objects[i]);
    MatchIndex := MatchItem(FImmunizations, SrcImmunization);
    if MatchIndex > -1 then begin
      CurImmunization := TPCEImm(FImmunizations.Items[MatchIndex]);

      //set null strings to NoPCEValue
      if SrcImmunization.Series = '' then SrcImmunization.Series := NoPCEValue;
      if SrcImmunization.Reaction = '' then SrcImmunization.Reaction := NoPCEValue;
      if CurImmunization.Series = '' then CurImmunization.Series := NoPCEValue;
      if CurImmunization.Reaction = '' then CurImmunization.Reaction := NoPCEValue;

      if(SrcImmunization.Series <> CurImmunization.Series) or
        (SrcImmunization.Reaction <> CurImmunization.Reaction) or
        (SrcImmunization.Refused <> CurImmunization.Refused) or
        (SrcImmunization.Contraindicated <> CurImmunization.Contraindicated) or
        (CurImmunization.Comment <> SrcImmunization.Comment)then
      begin
        CurImmunization.Series          := SrcImmunization.Series;
        CurImmunization.Reaction        := SrcImmunization.Reaction;
        CurImmunization.Refused         := SrcImmunization.Refused;
        CurImmunization.Contraindicated := SrcImmunization.Contraindicated;
        CurImmunization.Comment         := SrcImmunization.Comment;
        CurImmunization.FSend := True;
      end;
    end else begin
      CurImmunization := TPCEImm.Create;
      CurImmunization.Assign(SrcImmunization);
      CurImmunization.FSend := True;
      FImmunizations.Add(CurImmunization);
    end; {if MatchIndex}
  end; {for}
end;

procedure TPCEData.SetSkinTests(Src: TStrings; FromForm: boolean = TRUE);
{ load SkinTests for this encounter into TPCESkin records, assumes all SkinTests for the
  encounter will be listed in Src and marks those that are not in Src for deletion  -- if FromForm}
var
  i, MatchIndex: Integer;
  SrcSkinTest, CurSkinTest: TPCESkin;
begin
  if FromForm then MarkDeletions(FSKinTests, Src);
  for i := 0 to Src.Count - 1 do begin
    SrcSkinTest := TPCESkin(Src.Objects[i]);
    MatchIndex := MatchItem(FSKinTests, SrcSkinTest);
    if MatchIndex > -1 then begin
      CurSkinTest := TPCESKin(FSkinTests.Items[MatchIndex]);
      if CurSkinTest.Results = '' then CurSkinTest.Results := NoPCEValue;
      if SrcSkinTest.Results = '' then SrcSkinTest.Results := NoPCEValue;

      if(SrcSkinTest.Results <> CurSkinTest.Results) or
        (SrcSkinTest.Reading <> CurSkinTest.Reading) or
        (CurSkinTest.Comment <> SrcSkinTest.Comment) then
      begin

        CurSkinTest.Results := SrcSkinTest.Results;
        CurSkinTest.Reading := SrcSkinTest.Reading;
        CurSkinTest.Comment := SrcSkinTest.Comment;
        CurSkinTest.FSend := True;
      end;
    end else begin
      CurSKinTest := TPCESkin.Create;
      CurSkinTest.Assign(SrcSkinTest);
      CurSkinTest.FSend := True;
      FSkinTests.Add(CurSkinTest);
    end; {if MatchIndex}
  end; {for}
end;

procedure TPCEData.SetPatientEds(Src: TStrings; FromForm: boolean = TRUE);
{ load PatientEds for this encounter into TPCEDiag records, assumes all PatientEds for the
  encounter will be listed in Src and marks those that are not in Src for deletion  -- if FromForm}
var
  i, MatchIndex: Integer;
  SrcPatientEd, CurPatientEd: TPCEPat;
begin
  if FromForm then MarkDeletions(FPatientEds, Src);
  for i := 0 to Src.Count - 1 do begin
    SrcPatientEd := TPCEPat(Src.Objects[i]);
    MatchIndex := MatchItem(FPatientEds, SrcPatientEd);
    if MatchIndex > -1 then begin
      CurPatientEd := TPCEPat(FPatientEds.Items[MatchIndex]);

      if CurPatientEd.level = '' then CurPatientEd.level := NoPCEValue;
      if SrcPatientEd.level = '' then SrcPatientEd.level := NoPCEValue;
      if(SrcPatientEd.Level <> CurPatientEd.Level) or
        (CurPatientEd.Comment <> SrcPatientEd.Comment) then
      begin
        CurPatientEd.Level  := SrcPatientEd.Level;
        CurPatientEd.Comment := SrcPatientEd.Comment;
        CurPatientEd.FSend := True;
      end;
    end else begin
      CurPatientEd := TPCEPat.Create;
      CurPatientEd.Assign(SrcPatientEd);
      CurPatientEd.FSend := True;
      FPatientEds.Add(CurPatientEd);
    end; {if MatchIndex}
  end; {for}
end;


procedure TPCEData.SetHealthFactors(Src: TStrings; FromForm: boolean = TRUE);
{ load HealthFactors for this encounter into TPCEDiag records, assumes all HealthFactors for the
  encounter will be listed in Src and marks those that are not in Src for deletion  -- if FromForm}
var
  i, MatchIndex: Integer;
  SrcHealthFactor, CurHealthFactor: TPCEHealth;
begin
  if FromForm then MarkDeletions(FHealthFactors, Src);
  for i := 0 to Src.Count - 1 do begin
    SrcHealthFactor := TPCEHealth(Src.Objects[i]);
    MatchIndex := MatchItem(FHealthFactors, SrcHealthFactor);
    if MatchIndex > -1 then begin
      CurHealthFactor := TPCEHealth(FHealthFactors.Items[MatchIndex]);
      if CurHealthFactor.level = '' then CurHealthFactor.level := NoPCEValue;
      if SrcHealthFactor.level = '' then SrcHealthFactor.level := NoPCEValue;
      if(SrcHealthFactor.Level <> CurHealthFactor.Level) or
        (CurHealthFactor.Comment <> SrcHealthFactor.Comment) then
      begin
        CurHealthFactor.Level  := SrcHealthFactor.Level;
        CurHealthFactor.Comment := SrcHealthFactor.Comment;
        CurHealthFactor.FSend := True;
      end;
      if(SrcHealthFactor.GecRem <> CurHealthFactor.GecRem) then begin
        CurHealthFactor.GecRem := SrcHealthFactor.GecRem;
      end;
    end else begin
      CurHealthFactor := TPCEHealth.Create;
      CurHealthFactor.Assign(SrcHealthFactor);
      CurHealthFactor.FSend := True;
      CurHealthFactor.GecRem := SrcHealthFactor.GecRem;
      FHealthFactors.Add(CurHealthFactor);
    end; {if MatchIndex}
  end; {for}
end;


procedure TPCEData.SetExams(Src: TStrings; FromForm: boolean = TRUE);
{ load Exams for this encounter into TPCEDiag records, assumes all Exams for the
  encounter will be listed in Src and marks those that are not in Src for deletion  -- if FromForm}
var
  i, MatchIndex: Integer;
  SrcExam, CurExam: TPCEExams;
begin
  if FromForm then MarkDeletions(FExams, Src);
  for i := 0 to Src.Count - 1 do begin
    SrcExam := TPCEExams(Src.Objects[i]);
    MatchIndex := MatchItem(FExams, SrcExam);
    if MatchIndex > -1 then begin
      CurExam := TPCEExams(FExams.Items[MatchIndex]);
      if CurExam.Results = '' then CurExam.Results := NoPCEValue;
      if SrcExam.Results = '' then SrcExam.Results := NoPCEValue;
      if(SrcExam.Results <> CurExam.Results) or
        (CurExam.Comment <> SrcExam.Comment) then
      begin
        CurExam.Results  := SrcExam.Results;
        CurExam.Comment := SrcExam.Comment;
        CurExam.Fsend := True;
      end;
    end else begin
      CurExam := TPCEExams.Create;
      CurExam.Assign(SrcExam);
      CurExam.FSend := True;
      FExams.Add(CurExam);
    end; {if MatchIndex}
  end; {for}
end;


function  TPCEData.GetVisitType(index : integer) : TPCEProc; //kt added
begin
  if (index > -1) and (index < FVisitTypesList.count) then begin
    Result := FVisitTypesList.Proc[index];
  end else begin
    Result := nil;
  end;
end;

//kt original --> procedure TPCEData.SetVisitType(Value: TPCEProc);
procedure TPCEData.SetVisitType(index : integer; Value: TPCEProc);

{//kt NOTES:

  This system seems to be set up such that there is only ONE allowed visit-type CPT.
  It is stored in FVisitType.  All other CPT's are stored in FProcedures.  I
  believe on the server these will all be stored together as CPT's.

  I need to modify the system such that MULTIPLE visit-type CPT's can be tracked.
  This is because sometimes an office visit (medical recheck) and a CPE are done
  at the same time.

  When a new value is sent here to store in FVisitType, previously the code creates
  a new entry to be added into FProcedures to store the prior value.  But this
  entry is a DELETE message.

  I will change this system to be as follows:
  1) Setting a particult VisitType[index] will cause creation of a new entry
     which is a copy of the old, and marked for deletion.  Then the prior value
     will be overwritten with passed Value.
  2) If index is outside bounds of existing VisitTypes, it will be IGNORED.
}
var
  VisitDelete: TPCEProc;
  PriorValue : TPCEProc; //kt added
begin
  //kt rewrote code below
  if (index < 0) or (index >= FVisitTypesList.count) then exit;
  PriorValue := TPCEProc(FVisitTypesList[index]);
  if PriorValue.Match(Value) then exit;
  if PriorValue.Code <> '' then begin
    VisitDelete := TPCEProc.Create;
    VisitDelete.Assign(PriorValue);
    VisitDelete.FDelete := true;  //<-- signal for deletion
    VisitDelete.FSend   := True;
    FVisitTypesList.Add(VisitDelete);
  end;
  PriorValue.Assign(Value);
  PriorValue.Quantity := 1;
  PriorValue.FSend := True;
  { //kt -- original below
  if (not FVisitType.Match(Value)) or
  (FVisitType.Modifiers <> Value.Modifiers) then begin //causes CPT delete/re-add
    if FVisitType.Code <> '' then begin
      // add old visit to procedures for deletion
      VisitDelete := TPCEProc.Create;
      VisitDelete.Assign(FVisitType);
      VisitDelete.FDelete := True;
      VisitDelete.FSend   := True;
      FProcedures.Add(VisitDelete);
    end;
    FVisitType.Assign(Value);
    FVisitType.Quantity := 1;
    FVisitType.FSend := True;
  end;
  }
end;

procedure TPCEData.SetExtraVisitTypes(Src: TStrings; FromForm: boolean = TRUE); //kt
{ load ExtraVisitTypes for this encounter into TPCEDiag records, assumes all ExtraVisitTypes for the
  encounter will be listed in Src and marks those that are not in Src for deletion  -- if FromForm}
begin
  //kt NOTE: This function will actually not be needed.  See comments in SetVisitType(Value: TPCEProc);
end;


procedure TPCEData.SetSCRelated(Value: Integer);
begin
  if Value <> FSCRelated then
  begin
    FSCRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetAORelated(Value: Integer);
begin
  if Value <> FAORelated then
  begin
    FAORelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetIRRelated(Value: Integer);
begin
  if Value <> FIRRelated then
  begin
    FIRRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetECRelated(Value: Integer);
begin
  if Value <> FECRelated then
  begin
    FECRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetMSTRelated(Value: Integer);
begin
  if Value <> FMSTRelated then
  begin
    FMSTRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetHNCRelated(Value: Integer);
begin
//  if HNCOK and (Value <> FHNCRelated) then
  if Value <> FHNCRelated then
  begin
    FHNCRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetCVRelated(Value: Integer);
begin
  if (Value <> FCVRelated) then
  begin
    FCVRelated := Value;
    FSCChanged := True;
  end;
end;

procedure TPCEData.SetSHADRelated(Value: Integer);
begin
  if (Value <> FSHADRelated) then
  begin
    FSHADRelated := Value;
    FSCChanged   := True;
  end;
end;

procedure TPCEData.SetEncUseCurr(Value: Boolean);
begin
  FEncUseCurr := Value;
  if FEncUseCurr then
  begin
    FEncDateTime  := Encounter.DateTime;
    FEncLocation  := Encounter.Location;
    //need to add to full list of providers
    FEncSvcCat    := Encounter.VisitCategory;
    FStandAlone   := Encounter.StandAlone;
    FStandAloneLoaded := TRUE;
    FEncInpatient := Encounter.Inpatient;

  end else
  begin
    FEncDateTime  := 0;
    FEncLocation  := 0;
    FStandAlone := FALSE;
    FStandAloneLoaded := FALSE;
    FProviders.PrimaryIdx := -1;
    FEncSvcCat    := 'A';
    FEncInpatient := False;
  end;
  //
  SetRPCEncLocation(FEncLocation);
end;

function SectionHeading(CatType: TPCEDataCat) : string;
begin
  Result := '--- ' + PCEDataCatText[CatType] + ' ---';
end;

function TPCEData.StrForList(AList : TList;
                             AClass : TPCEItemClass;
                             CatType: TPCEDataCat;
                             NoHeader : boolean = false;
                             CodeOnly : boolean = false) : string;  //ELH added 10/19/23
//kt added to unify functionality.
var i : integer;
    AnItem : TPCEItem;
    Quant : integer;
    PrimeDx : boolean;
    ModText : string;
begin
  Result := '';
  Quant := 0;
  PrimeDx := false;
  ModText := '';
  with AList do begin
    for i := 0 to AList.Count - 1 do begin
      AnItem := TPCEItem(AList.Items[i]);
      if AnItem.FDelete then continue;
      if AnItem is TPCEDiag then begin
        PrimeDx := TPCEDiag(AnItem).Primary;
      end;
      if AnItem is TPCEProc then begin
        ModText := TPCEProc(AnItem).ModText;
        Quant := TPCEProc(AnItem).Quantity;
        PrimeDx := false;
      end;
      if CodeOnly then begin  // ELH added if
        if Result<>'' then Result := Result + '^';
        Result := Result + AnItem.Code;
      end else begin
        Result := Result + GetPCEDataText(CatType, AnItem.Code, AnItem.Category, AnItem.Narrative, PrimeDx, Quant) + ModText + CRLF;
      end;
    end;
    if (Length(Result)>0) and (NoHeader=false) then Result := SectionHeading(CatType) + CRLF + Result;
  end;
end;

function TPCEData.StrDiagCodes(): string;
begin
  Result := StrForList(FDiagnoses, TPCEDiag, pdcDiag, true,true);  //kt
end;

function TPCEData.StrCPTCodes(): string;
var i : integer;
    AVisit : TPCEProc;
    ProcStr : string;
begin
  Result := '';
  for i := 0 to FVisitTypesList.Count - 1 do begin
    AVisit := FVisitTypesList.Proc[i];
    if Result <> '' then Result := Result + '^';
    Result := Result + AVisit.Code;
  end;
  ProcStr := StrForList(FProcedures, TPCEProc, pdcProc, true,true);
  if ProcStr<>'' then begin
    if Result <> '' then Result := Result+'^';    
    Result := Result + ProcStr;  //kt
  end;
end;

function TPCEData.StrDiagnoses(NoHeader : boolean = false): string;
{ returns the list of diagnoses for this encounter as a single comma delimited string }
//kt var  i: Integer;
begin
  Result := StrForList(FDiagnoses, TPCEDiag, pdcDiag, NoHeader);  //kt
  {//kt
  Result := '';
  with FDiagnoses do begin
    for i := 0 to Count - 1 do with TPCEDiag(Items[i]) do begin
      if not FDelete then begin
        Result := Result + GetPCEDataText(pdcDiag, Code, Category, Narrative, Primary) + CRLF;
      end;
    end;
    if Length(Result) > 0 then begin
      Result := PCEDataCatText[pdcDiag] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
    end;
  end;
  }
end;

function TPCEData.StrProcedures(NoHeader : boolean = false): string;
{ returns the list of procedures for this encounter as a single comma delimited string }
//kt var i: Integer;
begin
  Result := StrForList(FProcedures, TPCEProc, pdcProc, NoHeader);  //kt
  {//kt
  Result := '';
  with FProcedures do for i := 0 to Count - 1 do with TPCEProc(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcProc, Code, Category, Narrative, FALSE, Quantity) +
                         ModText + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcProc] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
  }
end;

function TPCEData.StrImmunizations(NoHeader : boolean = false): string;
{ returns the list of Immunizations for this encounter as a single comma delimited string }
//kt var i: Integer;
begin
  Result := StrForList(FImmunizations, TPCEImm, pdcImm, NoHeader);  //kt
  {/kt
  Result := '';
  with FImmunizations do for i := 0 to Count - 1 do with TPCEImm(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcImm, Code, Category, Narrative) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcImm] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
  }
end;


function TPCEData.StrSkinTests(NoHeader : boolean = false): string;
{ returns the list of Immunizations for this encounter as a single comma delimited string }
//kt var i: Integer;
begin
  Result := StrForList(FSkinTests, TPCESkin, pdcSkin, NoHeader);  //kt
  {//kt
  Result := '';
  with FSkinTests do for i := 0 to Count - 1 do with TPCESkin(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcSkin, Code, Category, Narrative) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcSkin] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
  }
end;

function TPCEData.StrPatientEds(NoHeader : boolean = false): string;
//kt var i: Integer;
begin
  Result := StrForList(FPatientEds, TPCEPat, pdcPED, NoHeader);  //kt
  {//kt
  Result := '';
  with FPatientEds do for i := 0 to Count - 1 do with TPCEPat(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcPED, Code, Category, Narrative) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcPED] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
  }
end;

function TPCEData.StrHealthFactors(NoHeader : boolean = false): string;
//kt var i: Integer;
begin
  Result := StrForList(FHealthFactors, TPCEHealth, pdcHF);  //kt
  {//kt
  Result := '';
  with FHealthFactors do for i := 0 to Count - 1 do with TPCEHealth(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcHF, Code, Category, Narrative) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcHF] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
  }
end;

function TPCEData.StrExams(NoHeader : boolean = false): string;
//kt var i: Integer;
begin
  Result := StrForList(FExams, TPCEExams, pdcExam, NoHeader);  //kt
  {//kt
  Result := '';
  with FExams do for i := 0 to Count - 1 do with TPCEExams(Items[i]) do
    if not FDelete then
      Result := Result + GetPCEDataText(pdcExam, Code, Category, Narrative) + CRLF;
  if Length(Result) > 0 then Result := PCEDataCatText[pdcExam] + CRLF + Copy(Result, 1, Length(Result) - 2) + CRLF;
  }
end;

function TPCEData.StrVisitTypes(NoHeader : boolean = false): string; //kt added. NOTE: this is plural form (added 's')
var i : integer;
    AVisit : TPCEProc;
begin
  Result := '';
  for i := 0 to FVisitTypesList.Count - 1 do begin
    AVisit := FVisitTypesList.Proc[i];
    Result := Result + StrVisitType(AVisit);
    if Result<>'' then Result := Result + CRLF;
  end;
  if (Length(Result)>0) and (NoHeader=false) then begin
    Result := SectionHeading(pdcVisit) + CRLF + Result;
  end;
end;


function TPCEData.StrVisitType(const ASCRelated, AAORelated, AIRRelated,
  AECRelated, AMSTRelated, AHNCRelated, ACVRelated, ASHADRelated: Integer): string;
{ returns as a string the type of encounter (according to CPT) & related contitions treated }

  procedure AddTxt(txt: string);
  begin
    if(Result <> '') then
      Result := Result + ',';
    Result := Result + ' ' + txt;
  end;

begin
  Result := '';
  if ASCRelated = SCC_YES  then AddTxt('Service Connected Condition');
  if AAORelated = SCC_YES  then AddTxt('Agent Orange Exposure');
  if AIRRelated = SCC_YES  then AddTxt('Ionizing Radiation Exposure');
  if AECRelated = SCC_YES  then AddTxt('Environmental Contaminants');
  if AMSTRelated = SCC_YES then AddTxt('MST');//'Military Sexual Trauma';
//  if HNCOK and (AHNCRelated = SCC_YES) then AddTxt('Head and/or Neck Cancer');
  if AHNCRelated = SCC_YES then AddTxt('Head and/or Neck Cancer');
  if ACVRelated = SCC_YES  then AddTxt('Combat Veteran Related');
  if Length(Result) > 0 then Result := ' related to: ' + Result;
//  Result := Trim(Result);
end;

{
function TPCEData.StrVisitType: string;
// returns as a string the type of encounter (according to CPT) & related contitions treated
begin
  result := StrVisitType(FVisitType);
  //kt moved to separate function StrVisitType(AVisitType) below

  //Result := '';
  //with FVisitType do begin
  //  Result := GetPCEDataText(pdcVisit, Code, Category, Narrative);
  //  if Length(ModText) > 0 then Result := Result + ModText + ', ';
  //end;
  //Result := Trim(Result + StrVisitType(FSCRelated, FAORelated, FIRRelated,
  //                                     FECRelated, FMSTRelated, FHNCRelated, FCVRelated, FSHADRelated));
end;
}

function TPCEData.StrVisitType(AVisitType : TPCEProc) : string;
{ returns as a string the type of encounter (according to CPT) & related contitions treated }
//kt added, splitting from above.
var
  ModTextStr : string;
begin
  Result := '';
  with AVisitType do begin
    Result := GetPCEDataText(pdcVisit, Code, Category, Narrative);
    ModTextStr := AVisitType.ModText; //kt added
    if Length(ModTextStr) > 0 then Result := Result + ModTextStr + ', ';
    //kt original --> if Length(ModText) > 0 then Result := Result + ModText + ', ';
  end;
  Result := Trim(Result + StrVisitType(FSCRelated, FAORelated, FIRRelated,
                                       FECRelated, FMSTRelated, FHNCRelated, FCVRelated, FSHADRelated));
end;

function TPCEData.StandAlone: boolean;
var
  Sts: integer;

begin
  if(not FStandAloneLoaded) and ((FNoteIEN > 0) or ((FEncLocation > 0) and (FEncDateTime > 0))) then
  begin
    Sts := HasVisit(FNoteIEN, FEncLocation, FEncDateTime);
    FStandAlone := (Sts <> 1);
    if(Sts >= 0) then
      FStandAloneLoaded := TRUE;
  end;
  Result := FStandAlone;
end;

function TPCEData.getDocCount: Integer;
begin
  Result := 1;
//  result := DocCount(vISIT);
end;

function TPCEItem.MatchProvider(AnItem: TPCEItem): Boolean;
begin
  Result := False;
  if (Provider = AnItem.Provider) then Result := True;
end;

function TPCEData.GetHasData: Boolean;
begin
  result := True;
  if ((FDiagnoses.count = 0)
     and (FProcedures.count = 0)
     and (FImmunizations.count = 0)
     and (FSkinTests.count = 0)
     and (FPatientEds.count = 0)
     and (FHealthFactors.count = 0)
     and (fExams.count = 0) and
     (FVisitTypesList.MaxQuantity = 0)) then  //kt
     //kt original --> (FvisitType.Quantity = 0))then
      result := False;
end;

procedure TPCEData.Assign(Src: TPCEData);        //copies Src -> self.   //kt 4/23
//kt added because A.CopyPCEData(B) is not immediately obvious which direction copy is occurring, whereas B.Assign(A) is clear.
begin
  Src.CopyPCEData(Self);
end;

procedure TPCEData.CopyPCEData(Dest: TPCEData);  //copies self --> Dest
begin
  Dest.Clear;
  Dest.FEncDateTime  := FEncDateTime;
  Dest.FNoteDateTime := FNoteDateTime;
  Dest.FEncLocation  := FEncLocation;
  Dest.FEncSvcCat    := FEncSvcCat;
  Dest.FEncInpatient := FEncInpatient;
  Dest.FStandAlone   := FStandAlone;
  Dest.FStandAloneLoaded := FStandAloneLoaded;
  Dest.FEncUseCurr   := FEncUseCurr;
  Dest.FSCChanged    := FSCChanged;
  Dest.FSCRelated    := FSCRelated;
  Dest.FAORelated    := FAORelated;
  Dest.FIRRelated    := FIRRelated;
  Dest.FECRelated    := FECRelated;
  Dest.FMSTRelated   := FMSTRelated;
  Dest.FHNCRelated   := FHNCRelated;
  Dest.FCVRelated    := FCVRelated;
  Dest.FSHADRelated  := FSHADRelated;
  Dest.FProviders.Assign(FProviders);
  //kt  FVisitType.CopyProc(Dest.VisitType);
  Dest.FVisitTypesList.Assign(FVisitTypesList); //kt  Don't copy again via CopyPCEItems below.

  CopyPCEItems(FDiagnoses,       Dest.FDiagnoses,       TPCEDiag);
  CopyPCEItems(FProcedures,      Dest.FProcedures,      TPCEProc);
  CopyPCEItems(FImmunizations,   Dest.FImmunizations,   TPCEImm);
  CopyPCEItems(FSkinTests,       Dest.FSkinTests,       TPCESkin);
  CopyPCEItems(FPatientEds,      Dest.FPatientEds,      TPCEPat);
  CopyPCEItems(FHealthFactors,   Dest.FHealthFactors,   TPCEHealth);
  CopyPCEItems(FExams,           Dest.FExams,           TPCEExams);

  Dest.FNoteTitle := FNoteTitle;
  Dest.FNoteIEN := FNoteIEN;
  Dest.FParent := FParent;
  Dest.FHistoricalLocation := FHistoricalLocation;
end;

function TPCEData.NeededPCEData: tRequiredPCEDataTypes;
var
  EC: TSCConditions;
  NeedSC: boolean;
  TmpLst: TStringList;

begin
  Result := [];
  if(not FutureEncounter(Self)) then begin
    if(PromptForWorkload(FNoteIEN, FNoteTitle, FEncSvcCat, StandAlone)) then begin
      if(fdiagnoses.count <= 0) then begin
        Include(Result, ndDiag);
      end;
      //kt if((fprocedures.count <= 0) and (fVisitType.Code = '')) then begin
      if((fprocedures.count <= 0) and (FVisitTypesList.FirstNonEmptyCode = '')) then begin
        TmpLst := TStringList.Create;
        try
          GetHasCPTList(TmpLst);
          if(not DataHasCPTCodes(TmpLst)) then
            Include(Result, ndProc);
        finally
          TmpLst.Free;
        end;
      end;
      if(RequireExposures(FNoteIEN, FNoteTitle)) then begin
        NeedSC := FALSE;
        EC :=  EligbleConditions;
        if (EC.SCAllow and (SCRelated = SCC_NA)) then begin
          NeedSC := TRUE
        end else if(SCRelated <> SCC_YES) then  begin //if screlated = yes, the others are not asked.
               if(EC.AOAllow and (AORelated = SCC_NA)) then NeedSC := TRUE
          else if(EC.IRAllow and (IRRelated = SCC_NA)) then NeedSC := TRUE
          else if(EC.ECAllow and (ECRelated = SCC_NA)) then NeedSC := TRUE
        end;
        if(EC.MSTAllow and (MSTRelated = SCC_NA)) then NeedSC := TRUE;
//        if HNCOK and (EC.HNCAllow and (HNCRelated = SCC_NA)) then NeedSC := TRUE;
        if(EC.HNCAllow and (HNCRelated = SCC_NA)) then NeedSC := TRUE;
        if(EC.CVAllow and (CVRelated = SCC_NA) and (SHADRelated = SCC_NA)) then NeedSC := TRUE;
        if(NeedSC) then begin
          Include(Result, ndSC);
        end;
      end;
(*      if(Result = []) and (FNoteIEN > 0) then   //  **** block removed in v19.1  {RV} ****
        ClearCPTRequired(FNoteIEN);*)
    end;
  end;
end;


function TPCEData.OK2SignNote: boolean;
var
  Req: tRequiredPCEDataTypes;
  msg: string;
  Asked, DoAsk, Primary, Needed: boolean;
  Outpatient, First, DoSave, NeedSave, Done: boolean;
  Ans: integer;
  Flags: word;
  Ask: TAskPCE;

  procedure Add(Typ: tRequiredPCEDataType; txt: string);
  begin
    if(Typ in Req) then
      msg := msg + txt + CRLF;
  end;

begin
  if not CanEditPCE(Self) then begin
    Result := TRUE;
    exit;
  end;
  if IsNonCountClinic(FEncLocation) then begin
    Result := TRUE;
    exit;
  end;
  if IsCancelOrNoShow(NoteIEN) then begin
    Result := TRUE;
    exit;
  end;
  Ask := GetAskPCE(FEncLocation);
  if(Ask = apNever) or (Ask = apDisable) then
    Result := TRUE
  else begin
    DoSave := FALSE;
    try
      Asked := FALSE;
      First := TRUE;
      Outpatient := ((FEncSvcCat = 'A') or (FEncSvcCat = 'I') or (FEncSvcCat = 'T'));
      repeat
        Result := TRUE;
        Done := TRUE;
        Req := NeededPCEData;
        Needed := (Req <> []);
        if(First) then begin
          if Needed and (not Outpatient) then
            OutPatient := TRUE;
          if((Ask = apPrimaryAlways) or Needed
          or ((Ask = apPrimaryOutpatient) and Outpatient)) then begin
            if(Providers.PrimaryIdx < 0) then begin
              NoPrimaryPCEProvider(FProviders, Self);
              if(not DoSave) then
                DoSave := (Providers.PrimaryIdx >= 0);
              if(DoSave and (FProviders.PendingIEN(FALSE) <> 0) and
                (FProviders.IndexOfProvider(IntToStr(FProviders.PendingIEN(FALSE))) < 0)) then
                FProviders.AddProvider(IntToStr(FProviders.PendingIEN(FALSE)), FProviders.PendingName(FALSE), FALSE);
            end;
          end;
          First := FALSE;
        end;
        Primary := (Providers.PrimaryIEN = User.DUZ);
        case Ask of
          apPrimaryOutpatient: DoAsk := (Primary and Outpatient);
          apPrimaryAlways:     DoAsk := Primary;
          apNeeded:            DoAsk := Needed;
          apOutpatient:        DoAsk := Outpatient;
          apAlways:            DoAsk := TRUE;
          else
        { apPrimaryNeeded }    DoAsk := (Primary and Needed);
        end;
        if(DoAsk) then begin
          if(Asked and ((not Needed) or (not Primary))) then
            exit;
          if(Needed) then begin
            msg := TX_NEED1;
            Add(ndDiag, TX_NEED_DIAG);
            Add(ndProc, TX_NEED_PROC);
            Add(ndSC,   TX_NEED_SC);
            if(Primary and ForcePCEEntry(FEncLocation)) then begin
              Flags := MB_OKCANCEL;
              msg :=  msg + CRLF + TX_NEED3;
            end else begin
              if(Primary) then
                Flags := MB_YESNOCANCEL
              else
                Flags := MB_YESNO;
              msg :=  msg + CRLF + TX_NEED2;
            end;
            Flags := Flags + MB_ICONWARNING;
          end else begin
            Flags := MB_YESNO + MB_ICONQUESTION;
            msg :=  TX_NEED2;
          end;
          Ans := InfoBox(msg, TX_NEED_T, Flags);
          if(Ans = ID_CANCEL) then begin
            Result := FALSE;
            InfoBox(TX_NEEDABORT, TX_NEED_T, MB_OK);
            exit;
          end;
          Result := (Ans = ID_NO);
          if(not Result) then begin
            if(not MissingProviderInfo(Self)) then begin
              NeedSave := UpdatePCE(Self, FALSE);
              if(not DoSave) then
                DoSave := NeedSave;
              FUpdated := TRUE;
            end;
            Done := frmFrame.Closing;
            Asked := TRUE;
          end;
        end;
      until(Done);
    finally
      if(DoSave) then
        Save;
    end;
  end;
end;

procedure TPCEData.AddStrData(List: TStrings);

  procedure Add(Txt: string);
  begin
    if(length(Txt) > 0) then List.Add(Txt);
  end;

var i : integer;
begin
  //kt for i := 0 to FVisitTypesList.Count - 1 do Add(StrVisitType(FVisitTypesList.Proc[i])); //kt
  //kt Add(StrVisitType);
  Add(StrVisitTypes);
  Add(StrDiagnoses);
  Add(StrProcedures);
  Add(StrImmunizations);
  Add(StrSkinTests);
  Add(StrPatientEds);
  Add(StrHealthFactors);
  Add(StrExams);
end;

procedure TPCEData.AddVitalData(Data, List: TStrings);
var
  i: integer;

begin
  for i := 0 to Data.Count-1 do
    List.Add(FormatVitalForNote(Data[i]));
end;

function TPCEData.PersonClassDate: TFMDateTime;
begin
  if(FEncSvcCat = 'H') then
    Result := FMToday
  else
    Result := FEncDateTime; //Encounter.DateTime;
end;

function TPCEData.VisitDateTime: TFMDateTime;
begin
  if(IsSecondaryVisit) then
    Result := FNoteDateTime
  else
    Result := FEncDateTime;
end;

function TPCEData.IsSecondaryVisit: boolean;
begin
  Result := ((FEncSvcCat = 'H') and (FNoteDateTime > 0) and (FEncInpatient));
end;

function TPCEData.NeedProviderInfo: boolean;
var
  i: integer;
  TmpLst: TStringList;

begin
  if(FProviders.PrimaryIdx < 0) then
  begin
    Result := AutoCheckout(FEncLocation);
    if not Result then
    begin
      for i := 0 to FDiagnoses.Count - 1 do
      begin
        if not TPCEDiag(FDiagnoses[i]).FDelete then
        begin
          Result := TRUE;
          break;
        end;
      end;
    end;
    if not Result then
    begin
      for i := 0 to FProcedures.Count - 1 do
      begin
        if not TPCEProc(FProcedures[i]).FDelete then
        begin
          Result := TRUE;
          break;
        end;
      end;
    end;
    if not Result then
    begin
      for i := 0 to FProviders.Count - 1 do
      begin
        if not FProviders[i].Delete then
        begin
          Result := TRUE;
          break;
        end;
      end;
    end;
    if not Result then
    begin
      TmpLst := TStringList.Create;
      try
        GetHasCPTList(TmpLst);
        if(DataHasCPTCodes(TmpLst)) then
          Result := TRUE;
      finally
        TmpLst.Free;
      end;
    end;
  end
  else
    Result := FALSE;
end;

procedure TPCEData.GetHasCPTList(AList: TStrings);

  procedure AddList(List: TList);
  var
    i: integer;
    tmp: string;

  begin
    for i := 0 to List.Count-1 do
    begin
      tmp := TPCEItem(List[i]).HasCPTStr;
      if(tmp <> '') then
        AList.Add(tmp);
    end;
  end;

begin
  AddList(FImmunizations);
  AddList(FSkinTests);
  AddList(FPatientEds);
  AddList(FHealthFactors);
  AddList(FExams);
end;

procedure TPCEData.CopyPCEItems(Src: TList; Dest: TObject; ItemClass: TPCEItemClass);
var
  AItem: TPCEItem;
  i: Integer;
  IsStrings: boolean;
  Obj : TObject;
  SrcPCEItem : TPCEItem; //kt added, replacing TPCEItem(Src[i]) -> SrcPCEItem

begin
  if (Dest is TStrings) then begin
    IsStrings := TRUE
  end else if (Dest is TList) then begin
    IsStrings := FALSE
  end else begin
    exit;
  end;
  for i := 0 to Src.Count - 1 do begin
    //kt  Obj := TObject(Src[i]);
    SrcPCEItem := TPCEItem(Src[i]); //kt
    if SrcPCEItem.IsCleared then continue; //kt added
    if not SrcPCEItem.FDelete then begin
      AItem := ItemClass.Create;
      AItem.Assign(SrcPCEItem);
      if (IsStrings) then begin
        TStrings(Dest).AddObject(AItem.ItemStr, AItem)
      end else begin
        TList(Dest).Add(AItem);
      end;
    end;
  end;
end;

function TPCEData.Empty: boolean;
begin
  Result := (FProviders.Count = 0);
  if(Result) then Result := (FSCRelated  = SCC_NA);
  if(Result) then Result := (FAORelated  = SCC_NA);
  if(Result) then Result := (FIRRelated  = SCC_NA);
  if(Result) then Result := (FECRelated  = SCC_NA);
  if(Result) then Result := (FMSTRelated = SCC_NA);
//  if(Result) and HNCOK then Result := (FHNCRelated = SCC_NA);
  if(Result) then Result := (FHNCRelated = SCC_NA);
  if(Result) then Result := (FCVRelated = SCC_NA);
  if(Result) then Result := (FSHADRelated = SCC_NA);
  if(Result) then Result := (FDiagnoses.Count = 0);
  if(Result) then Result := (FProcedures.Count = 0);
  if(Result) then Result := (FImmunizations.Count = 0);
  if(Result) then Result := (FSkinTests.Count = 0);
  if(Result) then Result := (FPatientEds.Count = 0);
  if(Result) then Result := (FHealthFactors.Count = 0);
  if(Result) then Result := (fExams.Count = 0);
  //kt  if(Result) then Result := (FVisitType.Empty);
  if(Result) then Result := (FVisitTypesList.Empty);  //kt

end;

{ TPCEProviderList }

function TPCEProviderList.Add(const S: string): Integer;
var
  SIEN: string;
  LastPrimary: integer;

begin
  SIEN := IntToStr(StrToInt64Def(Piece(S, U, pnumPrvdrIEN), 0));
  if(SIEN = '0') then
    Result := -1
  else
  begin
    LastPrimary := PrimaryIdx;
    Result := IndexOfProvider(SIEN);
    if(Result < 0) then
      Result := inherited Add(S)
    else
      Strings[Result] := S;
    if(Piece(S, U, pnumPrvdrPrimary) = '1') then
    begin
      FNoUpdate := TRUE;
      try
        SetPrimaryIdx(Result);
      finally
        FNoUpdate := FALSE;
      end;
      if(assigned(FOnPrimaryChanged) and (LastPrimary <> PrimaryIdx)) then
        FOnPrimaryChanged(Self);
    end;
  end;
end;

function TPCEProviderList.AddProvider(AIEN, AName: string; APrimary: boolean): integer;
var
  tmp: string;

begin
  tmp := 'PRV' + U + AIEN + U + U + U + AName + U;
  if(APrimary) then tmp := tmp + '1';
  Result := Add(tmp);
end;

procedure TPCEProviderList.Clear;
var
  DoNotify: boolean;

begin
  DoNotify := (assigned(FOnPrimaryChanged) and (GetPrimaryIdx >= 0));
  FPendingDefault := '';
  FPendingUser := '';
  FPCEProviderIEN := 0;
  FPCEProviderName := '';
  inherited;
  if(DoNotify) then
    FOnPrimaryChanged(Self);
end;

procedure TPCEProviderList.Delete(Index: Integer);
var
  DoNotify: boolean;

begin
  DoNotify := (assigned(FOnPrimaryChanged) and (Piece(Strings[Index], U, pnumPrvdrPrimary) = '1'));
  inherited Delete(Index);
  if(DoNotify) then
    FOnPrimaryChanged(Self);
end;

function TPCEProviderList.PCEProvider: Int64;

  function Check(AIEN: Int64): Int64;
  begin
    if(AIEN = 0) or (IndexOfProvider(IntToStr(AIEN)) < 0) then
      Result := 0
    else
      Result := AIEN;
  end;

begin
  Result := Check(Encounter.Provider);
  if(Result = 0) then Result := Check(User.DUZ);
  if(Result = 0) then Result := PrimaryIEN;
end;

function TPCEProviderList.PCEProviderName: string;
var
  NewProv: Int64;

begin
  NewProv := PCEProvider;
  if(FPCEProviderIEN <> NewProv) then
  begin
    FPCEProviderIEN := NewProv;
    FPCEProviderName := ExternalName(PCEProvider, FN_NEW_PERSON);
  end;
  Result := FPCEProviderName;
end;

function TPCEProviderList.GetPrimaryIdx: integer;
begin
  Result := IndexOfPiece('1', U, pnumPrvdrPrimary);
end;

function TPCEProviderList.GetProviderData(Index: integer): TPCEProviderRec;
var
  X: string;

begin
  X := Strings[Index];
  Result.IEN     := StrToInt64Def(Piece(X, U, pnumPrvdrIEN), 0);
  Result.Name    := Piece(X, U, pnumPrvdrName);
  Result.Primary := (Piece(X, U, pnumPrvdrPrimary) = '1');
  Result.Delete  := (Piece(X, U, 1) = 'PRV-');
end;

function TPCEProviderList.IndexOfProvider(AIEN: string): integer;
begin
  Result := IndexOfPiece(AIEN, U, pnumPrvdrIEN);
end;

procedure TPCEProviderList.Merge(AList: TPCEProviderList);
var
  i, idx: integer;
  tmp: string;

begin
  for i := 0 to Count-1 do
  begin
    tmp := Strings[i];
    idx := AList.IndexOfProvider(Piece(tmp, U, pnumPrvdrIEN));
    if(idx < 0) then
    begin
      SetPiece(tmp, U, 1, 'PRV-');
      Strings[i] := tmp;
    end;
  end;
  for i := 0 to AList.Count-1 do
    Add(AList.Strings[i]); // Add already filters out duplicates
end;

function TPCEProviderList.PendingIEN(ADefault: boolean): Int64;
begin
  if(ADefault) then
    Result := StrToInt64Def(Piece(FPendingDefault, U, 1), 0)
  else
    Result := StrToInt64Def(Piece(FPendingUser, U, 1), 0);
end;

function TPCEProviderList.PendingName(ADefault: boolean): string;
begin
  if(ADefault) then
    Result := Piece(FPendingDefault, U, 2)
  else
    Result := Piece(FPendingUser, U, 2);
end;

function TPCEProviderList.PrimaryIEN: int64;
var
  idx: integer;

begin
  idx := GetPrimaryIdx;
  if(idx < 0) then
    Result := 0
  else
    Result := StrToInt64Def(Piece(Strings[idx], U, pnumPrvdrIEN), 0);
end;

function TPCEProviderList.PrimaryName: string;
var
  idx: integer;

begin
  idx := GetPrimaryIdx;
  if(idx < 0) then
    Result := ''
  else
    Result := Piece(Strings[idx], U, pnumPrvdrName);
end;

procedure TPCEProviderList.SetPrimary(index: integer; Primary: boolean);
var
  tmp, x: string;

begin
  tmp := Strings[index];
  if(Primary) then
    x := '1'
  else
    x := '';
  SetPiece(tmp, U, pnumPrvdrPrimary, x);
  Strings[Index] := tmp;
end;

procedure TPCEProviderList.SetPrimaryIdx(const Value: integer);
var
  LastPrimary, idx: integer;
  Found: boolean;

begin
  LastPrimary := GetPrimaryIdx;
  idx := -1;
  Found := FALSE;
  repeat
    idx := IndexOfPiece('1', U, pnumPrvdrPrimary, idx);
    if(idx >= 0) then
    begin
      if(idx = Value) then
        Found := TRUE
      else
        SetPrimary(idx, FALSE);
    end;
  until(idx < 0);
  if(not Found) and (Value >= 0) and (Value < Count) then
    SetPrimary(Value, TRUE);
  if((not FNoUpdate) and assigned(FOnPrimaryChanged) and (LastPrimary <> Value)) then
    FOnPrimaryChanged(Self);
end;

procedure TPCEProviderList.SetProviderData(Index: integer;
  const Value: TPCEProviderRec);
var
  tmp, SIEN: string;

begin
  if(Value.IEN = 0) or (index < 0) or (index >= Count) then exit;
  SIEN := IntToStr(Value.IEN);
  if(IndexOfPiece(SIEN, U, pnumPrvdrIEN) = index) then
  begin
    tmp := 'PRV';
    if(Value.Delete) then tmp := tmp + '-';
    tmp := tmp + U + SIEN + U + U + U + Value.Name + U;
    Strings[index] := tmp;
    if Value.Primary then
      SetPrimaryIdx(Index);
  end;
end;

procedure TPCEProviderList.Assign(Source: TPersistent);
var
  Src: TPCEProviderList;

begin
  inherited Assign(Source);
  if(Source is TPCEProviderList) then
  begin
    Src := TPCEProviderList(Source);
    Src.FOnPrimaryChanged := FOnPrimaryChanged;
    Src.FPendingDefault := FPendingDefault;
    Src.FPendingUser := FPendingUser;
    Src.FPCEProviderIEN := FPCEProviderIEN;
    Src.FPCEProviderName := FPCEProviderName;
  end;
end;

initialization

finalization
  KillObj(@PCESetsOfCodes);
  KillObj(@HistLocations);

end.
