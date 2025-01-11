unit fPtDemoEdit;
//kt 9/11 -- Added this entire unit for demographics editing at runtime.

//kt 12/18/13 NOTE -- Now that additional editing functionality has been added,
//                    much of this code could be merge with the others, e.g. uTMGGrid etc.
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ORFn,
  rTMGRPCs, uTMGPtInfo,  TMGHTML2,
  ClipBrd,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Grids, SortStringGrid, UTMGTypes, ORCtrls, Buttons, ToolWin;

type
  //kt 12/18/13   Moved to uTMGPtInfo
  //BoolUC = (bucFalse, bucTrue, bucUnchanged);


  TfrmPtDemoEdit = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    ApplyBtn: TButton;
    PageControl: TPageControl;
    tsDemographics: TTabSheet;
    LNameLabel: TLabel;
    FNameLabel: TLabel;
    MNameLabel: TLabel;
    CombinedNameLabel: TLabel;
    PrefixLabel: TLabel;
    SuffixLabel: TLabel;
    DOBLabel: TLabel;
    SSNumLabel: TLabel;
    CombinedNameEdit: TEdit;
    LNameEdit: TEdit;
    FNameEdit: TEdit;
    MNameEdit: TEdit;
    PrefixEdit: TEdit;
    SuffixEdit: TEdit;
    DOBEdit: TEdit;
    SSNumEdit: TEdit;
    AliasGroupBox: TGroupBox;
    AliasComboBox: TComboBox;
    AliasNameLabel: TLabel;
    AliasSSNumLabel: TLabel;
    AliasNameEdit: TEdit;
    AliasSSNEdit: TEdit;
    AddressGroupBox: TGroupBox;
    AddressRGrp: TRadioGroup;
    AddressLine1Edit: TEdit;
    AddressLine2Edit: TEdit;
    AddressLine3Edit: TEdit;
    CityLabel: TLabel;
    CityEdit: TEdit;
    StateComboBox: TComboBox;
    Zip4Edit: TEdit;
    Zip4Label: TLabel;
    BadAddressCB: TCheckBox;
    TempActiveCB: TCheckBox;
    SexLabel: TLabel;
    SexComboBox: TComboBox;
    DelAliasBtn: TButton;
    StartingDateEdit: TEdit;
    StartingDateLabel: TLabel;
    EndingDateLabel: TLabel;
    EndingDateEdit: TEdit;
    ConfActiveCB: TCheckBox;
    DegreeEdit: TEdit;
    DegreeLabel: TLabel;
    AddAliasBtn: TButton;
    GroupBox1: TGroupBox;
    PhoneNumGrp: TRadioGroup;
    PhoneNumEdit: TEdit;
    Label3: TLabel;
    EMailEdit: TEdit;
    tsAdvanced: TTabSheet;
    gridPatientDemo: TSortStringGrid;
    tsBasic: TTabSheet;
    gridBasicPatientDemo: TSortStringGrid;
    tsNotes: TTabSheet;
    pnlHTMLEdit: TPanel;
    ToolBar: TToolBar;
    cbFontNames: TComboBox;
    cbFontSize: TComboBox;
    btnFonts: TSpeedButton;
    btnItalic: TSpeedButton;
    btnBold: TSpeedButton;
    btnUnderline: TSpeedButton;
    btnBullets: TSpeedButton;
    btnNumbers: TSpeedButton;
    btnLeftAlign: TSpeedButton;
    btnCenterAlign: TSpeedButton;
    btnRightAlign: TSpeedButton;
    btnMoreIndent: TSpeedButton;
    btnLessIndent: TSpeedButton;
    btnTextColor: TSpeedButton;
    btnBackColor: TSpeedButton;
    btnEditZoomOut: TSpeedButton;
    btnEditNormalZoom: TSpeedButton;
    btnEditZoomIn: TSpeedButton;
    SkypeEdit: TEdit;
    Label1: TLabel;
    btnSkypeCopy: TBitBtn;
    procedure btnSkypeCopyClick(Sender: TObject);
    procedure SkypeEditChange(Sender: TObject);
    procedure cbFontSizeChange(Sender: TObject);
    procedure cbFontNamesChange(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure btnTextColorClick(Sender: TObject);
    procedure btnRightAlignClick(Sender: TObject);
    procedure btnNumbersClick(Sender: TObject);
    procedure btnMoreIndentClick(Sender: TObject);
    procedure btnLessIndentClick(Sender: TObject);
    procedure btnLeftAlignClick(Sender: TObject);
    procedure btnEditZoomOutClick(Sender: TObject);
    procedure btnEditZoomInClick(Sender: TObject);
    procedure btnEditNormalZoomClick(Sender: TObject);
    procedure btnCenterAlignClick(Sender: TObject);
    procedure btnBulletsClick(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnBackColorClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnFontsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AliasComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddressRGrpClick(Sender: TObject);
    procedure PhoneNumGrpClick(Sender: TObject);
    procedure DelAliasBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CombinedNameEditChange(Sender: TObject);
    procedure LNameEditChange(Sender: TObject);
    procedure FNameEditChange(Sender: TObject);
    procedure MNameEditChange(Sender: TObject);
    procedure PrefixEditChange(Sender: TObject);
    procedure SuffixEditChange(Sender: TObject);
    procedure SexComboBoxChange(Sender: TObject);
    procedure EMailEditChange(Sender: TObject);
    procedure AddressLine1EditChange(Sender: TObject);
    procedure AddressLine2EditChange(Sender: TObject);
    procedure AddressLine3EditChange(Sender: TObject);
    procedure CityEditChange(Sender: TObject);
    procedure Zip4EditChange(Sender: TObject);
    procedure StateComboBoxChange(Sender: TObject);
    procedure TempActiveCBClick(Sender: TObject);
    procedure ConfActiveCBClick(Sender: TObject);
    procedure BadAddressCBClick(Sender: TObject);
    procedure DegreeEditChange(Sender: TObject);
    procedure PhoneNumEditChange(Sender: TObject);
    procedure StartingDateEditChange(Sender: TObject);
    procedure EndingDateEditChange(Sender: TObject);
    procedure AliasNameEditChange(Sender: TObject);
    procedure AliasSSNEditChange(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure AddAliasBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DOBEditChange(Sender: TObject);
    procedure SSNumEditChange(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure gridPatientDemoSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure gridPatientDemoSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: String);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure tsKeeneShow(Sender: TObject);
    procedure tsKeeneHide(Sender: TObject);
    procedure KeeneAcctNoChange(Sender: TObject);
    procedure KeeneAdmissionNumberChange(Sender: TObject);
    procedure KeeneAdmissionDateChange(Sender: TObject);
  private
    { Private declarations }
    //gridPatientDemo: TSortStringGrid; //kt 9/11
    FCurPatientInfo : TPatientInfo;
    FServerPatientInfo : TPatientInfo;
    FCurAliasEdit : integer;
    //CurrentAnyFileData : TStringList;
    ProgAliasChangeOccuring : boolean;
    CurrentPatientData : TStringList;
    ProgNameChangeOccuring : boolean;
    ProgPhoneChangeOccuring : boolean;
    FLastSelectedRow,FLastSelectedCol : integer;
    ProgAddressChangeOccuring : boolean;
    DataForGrid : TStringList;
    //MaxAliasIEN : integer;
    //Data : TStringList;
    ChangesMade : boolean;
    BasicTemplate : TStringList;
    //FLoadingGrid: boolean;
    //CachedWPField : TStringList;
    HTMLEditor : THtmlObj;     //kt 9/4/15
    boolKeeneDirty : Boolean;    //For Intracare   elh  11-17-10
    boolKeeneLoading : Boolean;  //For Intracare   elh  11-17-10
    procedure ApplyKeene;        //For Intracare   elh  11-17-10
    procedure MakeKeeneDirty;    //For Intracare   elh  11-17-10
    procedure SyncActivePatient;
    //procedure GetPtInfo(PatientInfo : TPatientInfo);
    //procedure PostChangedInfo(PatientInfo : TPatientInfo);
    procedure ShowAliasInfo(Patient : TPatientInfo);
    procedure GetPatientInfo(GridInfo: TGridInfo);
    procedure ShowPtInfo(Patient : TPatientInfo);
    function CombinedName : string;
    procedure AddGridInfoBASIC(Grid: TSortStringGrid;
                                  Data : TStringList;
                                  BasicMode : boolean;
                                  DataLoader : TGridDataLoader;
                                  FileNum : string);
    procedure AddGridInfoADV(Grid: TSortStringGrid;
                                  Data : TStringList;
                                  BasicMode : boolean;
                                  DataLoader : TGridDataLoader;
                                  FileNum : string);
    procedure NameParts(CombinedName: string; var LName, FName, MName : string);
    //function ExtractNum (S : String; StartPos : integer) : string;
    procedure SetModified(value : boolean);
    procedure SetAliasEnabled(value : boolean);
    function PostChanges(Grid : TSortStringGrid) : TModalResult;
    procedure CompileChanges(Grid : TSortStringGrid; CurrentUserData,Changes : TStringList);
    procedure RegisterGridInfo(GridInfo : TGridInfo);
    procedure LoadPatientNotes;
    procedure SavePatientNotes;
    procedure HandleHTMLEditorModified(Sender : TObject);
  public
    { Public declarations }
    procedure Initialize();
    function GetInfoForGrid(Grid : TSortStringGrid) : TGridInfo;
    {procedure LoadAnyGrid(Grid : TSortStringGrid; BasicMode: boolean; FileNum : string;
                                  IENS : string;
                                  CurrentData : TStringList);     }
    //procedure LoadAnyGridFromInfo(GridInfo : TGridInfo);
    function IsSubFile(FieldDef: string ; var SubFileNum : string) : boolean;
    function GetInfoIndexForGrid(Grid : TSortStringGrid) : integer;
    function PostVisibleGrid(Grid: TSortStringGrid): TModalResult;
    //function GetLineInfo(Grid : TSortStringGrid; CurrentUserData : TStringList; ARow: integer) : tFileEntry;
    //procedure GetOneRecord(FileNum, IENS : string; Data, BlankFileInfo: TStringList);
    //procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    function GetUserLine(CurrentUserData : TStringList; Grid : TSortStringGrid; ARow: integer) : integer;
    //function FindInStrings(fieldNum : string; Strings : TStringList; var fileNum : string) : integer;
  end;

//var
//  frmPtDemoEdit: TfrmPtDemoEdit;

Const
  DEF_GRID_ROW_HEIGHT = 17;
  //CLICK_FOR_SUBS = '<CLICK for Sub-Entries>';
  CLICK_FOR_SUBS = '<CLICK to Add Sub-Entries>';
  COMPUTED_FIELD = '<Computed Field --> CAN''T EDIT>';
  CLICK_TO_EDIT = '<CLICK to Edit Text>';
  HIDDEN_FIELD = '<Hidden>';

//function IsWPField(CachedWPField:TStringList; FileNum,FieldNum : string) : boolean; forward;
function EditPatientDemographics : integer;
procedure GetOneRecord(FileNum, IENS : string; Data, BlankFileInfo: TStringList);
//procedure AnyGridPatientDemoSelectCell(GridInfo : TGridInfo; ACol, ARow: Integer; var CanSelect: Boolean);
//procedure LoadAnyGridFromInfo(GridInfo : TGridInfo);
//function GetLineInfo(Grid : TSortStringGrid; CurrentUserData : TStringList; ARow: integer) : tFileEntry;


implementation

{$R *.dfm}

uses
  IniFiles,Trpcb,ORNet, uCore, mfunstr, subfilesU, strutils, LookupU, SetSelU,
  uTMGGlobals, uTMGUtil, fGUIEditFMFile, fFrame, uHTMLTools,
  SelDateTimeU, PostU, EditTextU, FMErrorU, ORSystem, uTMGOptions, uTMGGrid;

const
  ADD_NEW_ALIAS = '<Add New Alias>';


function EditPatientDemographics : integer;
//kt 9/11 added
var frmPtDemoEdit: TfrmPtDemoEdit;
begin
  frmPtDemoEdit := TfrmPtDemoEdit.Create(nil);
  frmPtDemoEdit.Initialize;
  Result := frmPtDemoEdit.ShowModal;
  frmPtDemoEdit.Free;
end;


//=========================================================
//=========================================================
procedure TfrmPtDemoEdit.SyncActivePatient;
begin
  FServerPatientInfo.LoadFromServer(Patient.DFN);
  FCurPatientInfo.Assign(FServerPatientInfo);
  ShowPtInfo(FCurPatientInfo);
end;


procedure TfrmPtDemoEdit.ShowPtInfo(Patient : TPatientInfo);
var i : integer;
    pAlias : tAlias;
begin
  ProgNameChangeOccuring := true;
  With Patient do begin
    LNameEdit.Text := LName;
    FNameEdit.Text := FName;
    MNameEdit.Text := MName;
    CombinedNameEdit.Text := CombinedName;
    PrefixEdit.Text := Prefix;
    SuffixEdit.Text := Suffix;
    DegreeEdit.Text := Degree;
    DOBEdit.Text := DOB;
    SSNumEdit.Text := SSNum;
    EMailEdit.Text := EMail;
    SkypeEdit.Text := Skype;
    if Sex='MALE' then SexComboBox.ItemIndex := 0 else SexComboBox.ItemIndex := 1;
    AliasComboBox.Items.Clear;
    for i := 0 to AliasInfo.Count-1 do begin
      pAlias := tAlias(AliasInfo.Objects[i]);
      if pAlias<>nil then begin
        AliasComboBox.Items.AddObject(pAlias.Name,pAlias);
      end;
    end;
    if AliasComboBox.Items.count>0 then begin
      AliasComboBox.ItemIndex := 0;
      SetAliasEnabled(true);
    end;
    ShowAliasInfo(Patient);
    
    PhoneNumGrp.ItemIndex := 0;
    PhoneNumGrpClick(self);
  end;  

  BadAddressCB.Visible := false;
  TempActiveCB.Visible := false;
  AddressRGrpClick(self);       //elh 1/15/14 Address wasn't being updated on show
  ProgNameChangeOccuring := false;
end;

procedure TfrmPtDemoEdit.SkypeEditChange(Sender: TObject);
begin
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.Skype := SkypeEdit.Text;
    SetModified(true);
  end;
end;

procedure TfrmPtDemoEdit.ShowAliasInfo(Patient : TPatientInfo);
var i : integer;
    pAlias : tAlias;
begin
  i := AliasComboBox.ItemIndex;
  if i > -1 then begin
    if i < Patient.AliasInfo.Count then begin
      pAlias := tAlias(Patient.AliasInfo.Objects[i]);
    end else pAlias := nil;
    ProgAliasChangeOccuring := true;
    if pAlias<>nil then begin
      AliasNameEdit.Text := pAlias.Name;
      AliasSSNEdit.Text := pAlias.SSN;    
    end else begin
      AliasNameEdit.Text := '';
      AliasSSNEdit.Text := '';    
    end;
    ProgAliasChangeOccuring := false;
  end;  
end;


procedure TfrmPtDemoEdit.AliasComboBoxChange(Sender: TObject);
var s : string;
    i : integer;
begin
  if ProgAliasChangeOccuring=false then begin
    i := AliasCombobox.ItemIndex;
    if i>-1 then begin
      s := AliasCombobox.Items.Strings[i];
      SetAliasEnabled(true);
    end else begin
      SetAliasEnabled(false);
    end;  
    ShowAliasInfo(FCurPatientInfo);
  end;
end;

procedure TfrmPtDemoEdit.FormCreate(Sender: TObject);

  Procedure SetupBasicTemplate(Template: TStringList);
  var fields: string;
      i :integer;
  begin
    fields := uTMGOptions.ReadString('Patient Demographic Edit Fields','.01');
    Template.Clear;
    for i := 1 to NumPieces(fields,',') do begin
      Template.Add('2^'+piece(fields,',',i));
    end;
  end;

  Procedure MakeDummyTemplate(T: TStringList);
  begin
    T.Clear;
    T.Add('.01^');
    T.Add('.02^');
    T.Add('.09^');
  end;
begin
  //gridPatientDemo := TSortStringGrid.Create(Self);             //kt 9/11
  //gridPatientDemo.Parent := tsAdvanced;                        //kt 9/11
  //gridPatientDemo.Align := alClient;                           //kt 9/11
  //gridPatientDemo.OnSelectCell := gridPatientDemoSelectCell;   //kt 9/11
  //gridPatientDemo.OnSetEditText := gridPatientDemoSetEditText; //kt 9/11
  FCurAliasEdit := -1;
  FCurPatientInfo := TPatientInfo.Create;
  FServerPatientInfo := TPatientInfo.Create;
  DataForGrid := TStringList.Create;  //will own GridInfo objects.
  ProgAliasChangeOccuring  := false;
  ProgNameChangeOccuring := false;
  ProgPhoneChangeOccuring := false;
  ProgAddressChangeOccuring := false;
  //MaxAliasIEN := 0;
  ChangesMade := false;
  CurrentPatientData := TStringList.Create;
  BasicTemplate := TStringList.Create;
  SetupBasicTemplate(BasicTemplate);
  AddGridInfoADV(GridPatientDemo,CurrentPatientData,false,GetPatientInfo,'2');
  AddGridInfoBASIC(GridBasicPatientDemo,CurrentPatientData,false,GetPatientInfo,'2');

  //kt if uTMGOptions.ReadString('SpecialLocation','')<>'FPG' then PageControl.Pages[4].Free;
  if not AtFPGLoc() then PageControl.Pages[4].Free;
  //kt if uTMGOptions.ReadString('SpecialLocation','')<>'INTRACARE' then PageControl.Pages[3].Free;
  if not AtIntracareLoc() then PageControl.Pages[3].Free;

  MakeDummyTemplate(uTMGGlobals.AdvancedDemographicsTemplate);

  cbFontNames.Items.Assign(Screen.Fonts);
  HTMLEditor := THtmlObj.Create(pnlHTMLEdit, Application);
  TWinControl(HTMLEditor).Parent:=pnlHTMLEdit;
  TWinControl(HTMLEditor).Align:=alClient;
  //Note: A 'loaded' function will initialize the THtmlObj's, but it can't be
  //      done until after this constructor is done, and this TfrmNotes has been
  //      assigned a parent.  So done elsewhere (in Initialize() below)
  HTMLEditor.OnModified:= HandleHTMLEditorModified;
end;

procedure TfrmPtDemoEdit.Initialize();
//kt 9/4/15
begin
  HTMLEditor.Loaded();
  HtmlEditor.Editable := true;
end;


procedure TfrmPtDemoEdit.FormDestroy(Sender: TObject);
begin
  DataForGrid.Free;
  FCurPatientInfo.Destroy;
  FServerPatientInfo.Destroy;
  CurrentPatientData.Free;
  BasicTemplate.Free;
  //gridPatientDemo.Free;  //kt 9/11
end;


procedure TfrmPtDemoEdit.AddressRGrpClick(Sender: TObject);
begin
  {fill in data for newly selected fields}
  ProgAddressChangeOccuring := true;
  TempActiveCB.Visible := false;
  BadAddressCB.Visible := false;
  ConfActiveCB.Visible := false;
  StartingDateLabel.Visible := false;
  StartingDateEdit.Visible := false;
  EndingDateLabel.Visible := false;
  EndingDateEdit.Visible := false;
  case AddressRGrp.ItemIndex of
    0 : begin //Permanant
          AddressLine1Edit.Text := FCurPatientInfo.AddressLine1;
          AddressLine2Edit.Text := FCurPatientInfo.AddressLine2;
          AddressLine3Edit.text := FCurPatientInfo.AddressLine3;
          CityEdit.text := FCurPatientInfo.City;
          StateComboBox.text := FCurPatientInfo.State;
          Zip4Edit.text := FCurPatientInfo.Zip4;
          BadAddressCB.Visible := true;
          BadAddressCB.Checked := (FCurPatientInfo.BadAddress=bucTrue);
        end;
    1 : begin //temp
          AddressLine1Edit.Text := FCurPatientInfo.TempAddressLine1;
          AddressLine2Edit.Text := FCurPatientInfo.TempAddressLine2;
          AddressLine3Edit.Text := FCurPatientInfo.TempAddressLine3;
          CityEdit.Text := FCurPatientInfo.TempCity;
          StateComboBox.Text := FCurPatientInfo.TempState;
          Zip4Edit.Text := FCurPatientInfo.TempZip4;
          StartingDateEdit.Text := FCurPatientInfo.TempStartingDate ;
          EndingDateEdit.Text := FCurPatientInfo.TempEndingDate ;
          StartingDateLabel.Visible := true;
          StartingDateEdit.Visible := true;
          EndingDateLabel.Visible := true;
          EndingDateEdit.Visible := true;
          TempActiveCB.Visible := true;
          TempActiveCB.Checked := (FCurPatientInfo.TempAddressActive=bucTrue);
        end;
    2 : begin //confidental
          AddressLine1Edit.Text := FCurPatientInfo.ConfidentalAddressLine1;
          AddressLine2Edit.Text := FCurPatientInfo.ConfidentalAddressLine2;
          AddressLine3Edit.Text := FCurPatientInfo.ConfidentalAddressLine3;
          CityEdit.Text := FCurPatientInfo.ConfidentalCity;
          StateComboBox.Text := FCurPatientInfo.ConfidentalState;
          Zip4Edit.Text := FCurPatientInfo.ConfidentalZip;
          StartingDateEdit.Text := FCurPatientInfo.ConfidentalStartingDate ;
          EndingDateEdit.Text := FCurPatientInfo.ConfidentalEndingDate ;
          StartingDateLabel.Visible := true;
          StartingDateEdit.Visible := true;
          EndingDateLabel.Visible := true;
          EndingDateEdit.Visible := true;
          ConfActiveCB.Visible := true;
          ConfActiveCB.Checked := (FCurPatientInfo.ConfAddressActive=bucTrue);
        end;
  end; {case}
  ProgAddressChangeOccuring := false;
end;

procedure TfrmPtDemoEdit.PhoneNumGrpClick(Sender: TObject);
begin
  ProgPhoneChangeOccuring := true;
  case PhoneNumGrp.ItemIndex of
    0 : begin //Residence
          PhoneNumEdit.Text := FCurPatientInfo.PhoneNumResidence;
        end;
    1 : begin //work
          PhoneNumEdit.Text := FCurPatientInfo.PhoneNumWork;
        end;
    2 : begin //cell
          PhoneNumEdit.Text := FCurPatientInfo.PhoneNumCell;
        end;
    3 : begin //temp
          PhoneNumEdit.Text := FCurPatientInfo.PhoneNumTemp;
        end;
   else begin
          PhoneNumEdit.Text := '';
        end;
  end; {case}
  ProgPhoneChangeOccuring := false;
end;

procedure TfrmPtDemoEdit.DelAliasBtnClick(Sender: TObject);
var i, j : integer;
    pAlias : tAlias;
begin
  i := AliasComboBox.ItemIndex;
  if i > -1 then begin
    pAlias := tAlias(AliasComboBox.Items.Objects[i]);
    if pAlias<>nil then begin
      for j := 0 to FCurPatientInfo.AliasInfo.Count-1 do begin
        if FCurPatientInfo.AliasInfo.Objects[j] = pAlias then begin
          FCurPatientInfo.AliasInfo.Delete(j);
          SetModified(true);
          pAlias.Free;
          AliasComboBox.Items.Delete(i);
          //AliasComboBox.ItemIndex := 0;
          //ShowAliasInfo(FCurPatientInfo);
          ProgAliasChangeOccuring:= true;
          AliasNameEdit.Text:='';
          AliasSSNEdit.Text:='';
          ProgAliasChangeOccuring:= false;
          break;
        end;
      end;
    end;
  end;
  if AliasCombobox.Items.Count=0 then begin
    AliasNameEdit.Text:='';
    AliasSSNEdit.Text:='';
    SetAliasEnabled(false);
    AliasCombobox.Text := '';
  end;
end;

procedure TfrmPtDemoEdit.FormShow(Sender: TObject);
begin
  PageControl.ActivePage := tsDemographics;
  SyncActivePatient;  //<-- I think this is redundant.  Change handler also syncs patient.
end;

procedure TfrmPtDemoEdit.CombinedNameEditChange(Sender: TObject);
var LName,FName,MName : string;
begin 
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.CombinedName := CombinedNameEdit.Text; 
    SetModified(true);
    if CombinedNameEdit.Text <> CombinedName then begin
      ProgNameChangeOccuring := true;
      NameParts(CombinedNameEdit.Text, LName, FName, MName);
      LNameEdit.Text := LName;
      FNameEdit.Text := FName;
      MNameEdit.Text := MName;
      ProgNameChangeOccuring := false;
    end;
  end;    
end;

procedure TfrmPtDemoEdit.LNameEditChange(Sender: TObject);
begin 
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.LName := LNameEdit.Text;
    SetModified(true);
    CombinedNameEdit.Text := CombinedName;
  end;
end;

procedure TfrmPtDemoEdit.FNameEditChange(Sender: TObject);
begin 
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.FName := FNameEdit.Text; 
    SetModified(true);
    CombinedNameEdit.Text := CombinedName;
  end  
end;

procedure TfrmPtDemoEdit.MNameEditChange(Sender: TObject);
begin 
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.MName := MNameEdit.Text;
    SetModified(true);
    CombinedNameEdit.Text := CombinedName;
  end;
end;

procedure TfrmPtDemoEdit.PrefixEditChange(Sender: TObject);
begin
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.Prefix := PrefixEdit.Text;
    SetModified(true);
  end;
end;

procedure TfrmPtDemoEdit.SuffixEditChange(Sender: TObject);
begin
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.Suffix := SuffixEdit.Text;
    SetModified(true);
    CombinedNameEdit.Text := CombinedName;
  end;
end;

procedure TfrmPtDemoEdit.DOBEditChange(Sender: TObject);
begin
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.DOB := DOBEdit.Text;
    SetModified(true);
  end;
end;

procedure TfrmPtDemoEdit.SSNumEditChange(Sender: TObject);
begin
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.SSNum := SSNumEdit.Text;
    SetModified(true);
  end;
end;

procedure TfrmPtDemoEdit.EMailEditChange(Sender: TObject);
begin
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.EMail := EMailEdit.Text;
    SetModified(true);
  end;
end;

procedure TfrmPtDemoEdit.SexComboBoxChange(Sender: TObject);
begin
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.Sex := SexComboBox.Text;
    SetModified(true);
  end;
end;

procedure TfrmPtDemoEdit.DegreeEditChange(Sender: TObject);
begin  
  if ProgNameChangeOccuring = false then begin
    FCurPatientInfo.Degree := DegreeEdit.Text;
    SetModified(true);
  end;  
end;

procedure TfrmPtDemoEdit.AddressLine1EditChange(Sender: TObject);
begin
  if ProgAddressChangeOccuring = false then SetModified(true);
  Case AddressRGrp.ItemIndex of
    0 : FCurPatientInfo.AddressLine1 := AddressLine1Edit.Text;
    1 : FCurPatientInfo.TempAddressLine1 := AddressLine1Edit.Text;
    2 : FCurPatientInfo.ConfidentalAddressLine1 := AddressLine1Edit.Text;
  end;  {case}
end;

procedure TfrmPtDemoEdit.AddressLine2EditChange(Sender: TObject);
begin
  if ProgAddressChangeOccuring = false then SetModified(true);
  Case AddressRGrp.ItemIndex of
    0 : FCurPatientInfo.AddressLine2 := AddressLine2Edit.Text;
    1 : FCurPatientInfo.TempAddressLine2 := AddressLine2Edit.Text;
    2 : FCurPatientInfo.ConfidentalAddressLine2 := AddressLine2Edit.Text;
  end;  {case}
end;

procedure TfrmPtDemoEdit.AddressLine3EditChange(Sender: TObject);
begin
  if ProgAddressChangeOccuring = false then SetModified(true);
  Case AddressRGrp.ItemIndex of
    0 : FCurPatientInfo.AddressLine3 := AddressLine3Edit.Text;
    1 : FCurPatientInfo.TempAddressLine3 := AddressLine3Edit.Text;
    2 : FCurPatientInfo.ConfidentalAddressLine3 := AddressLine3Edit.Text;
  end;  {case}
end;

procedure TfrmPtDemoEdit.CityEditChange(Sender: TObject);
begin
  if ProgAddressChangeOccuring = false then SetModified(true);
  Case AddressRGrp.ItemIndex of
    0 : FCurPatientInfo.City  := CityEdit.Text;
    1 : FCurPatientInfo.TempCity := CityEdit.Text;
    2 : FCurPatientInfo.ConfidentalCity := CityEdit.Text;
  end;  {case}
end;

procedure TfrmPtDemoEdit.Zip4EditChange(Sender: TObject);
begin
  if ProgAddressChangeOccuring = false then SetModified(true);
  Case AddressRGrp.ItemIndex of
    0 : FCurPatientInfo.Zip4   := Zip4Edit.Text;
    1 : FCurPatientInfo.TempZip4 := Zip4Edit.Text;
    2 : FCurPatientInfo.ConfidentalZip := leftstr(Zip4Edit.Text,5);
  end;  {case}
end;

procedure TfrmPtDemoEdit.StateComboBoxChange(Sender: TObject);
begin
  if ProgAddressChangeOccuring = false then SetModified(true);
  Case AddressRGrp.ItemIndex of
    0 : FCurPatientInfo.State := StateComboBox.Text;
    1 : FCurPatientInfo.TempState := StateComboBox.Text;
    2 : FCurPatientInfo.ConfidentalState := StateComboBox.Text;
  end;  {case}
end;

procedure TfrmPtDemoEdit.TempActiveCBClick(Sender: TObject);
begin
  FCurPatientInfo.TempAddressActive := BoolUC(TempActiveCB.Checked);
  if ProgAddressChangeOccuring = false then SetModified(true);
end;

procedure TfrmPtDemoEdit.ConfActiveCBClick(Sender: TObject);
begin
  FCurPatientInfo.ConfAddressActive := BoolUC(ConfActiveCB.Checked);
  if ProgAddressChangeOccuring = false then SetModified(true);
end;

procedure TfrmPtDemoEdit.BadAddressCBClick(Sender: TObject);
begin
  FCurPatientInfo.BadAddress := BoolUC(BadAddressCB.Checked);
  if ProgAddressChangeOccuring = false then SetModified(true);
end;

procedure TfrmPtDemoEdit.btnBackColorClick(Sender: TObject);
begin
  HtmlEditor.TextBackColorDialog;
end;

procedure TfrmPtDemoEdit.btnBoldClick(Sender: TObject);
begin
  HtmlEditor.ToggleBold;
end;

procedure TfrmPtDemoEdit.btnBulletsClick(Sender: TObject);
begin
  HtmlEditor.ToggleBullet;
end;

procedure TfrmPtDemoEdit.btnCenterAlignClick(Sender: TObject);
begin
  HtmlEditor.AlignCenter;
end;

procedure TfrmPtDemoEdit.btnEditNormalZoomClick(Sender: TObject);
begin
  HtmlEditor.ZoomReset;
end;

procedure TfrmPtDemoEdit.btnEditZoomInClick(Sender: TObject);
begin
  HtmlEditor.ZoomIn;
end;

procedure TfrmPtDemoEdit.btnEditZoomOutClick(Sender: TObject);
begin
  HtmlEditor.ZoomReset;
end;

procedure TfrmPtDemoEdit.btnFontsClick(Sender: TObject);
begin
  HtmlEditor.FontDialog;
end;

procedure TfrmPtDemoEdit.btnItalicClick(Sender: TObject);
begin
  HtmlEditor.ToggleItalic;
end;

procedure TfrmPtDemoEdit.btnLeftAlignClick(Sender: TObject);
begin
  HtmlEditor.AlignLeft;
end;

procedure TfrmPtDemoEdit.btnLessIndentClick(Sender: TObject);
begin
  HtmlEditor.Outdent;
end;

procedure TfrmPtDemoEdit.btnMoreIndentClick(Sender: TObject);
begin
  HtmlEditor.Indent;
end;

procedure TfrmPtDemoEdit.btnNumbersClick(Sender: TObject);
begin
  HtmlEditor.ToggleNumbering;
end;

procedure TfrmPtDemoEdit.btnRightAlignClick(Sender: TObject);
begin
  HtmlEditor.AlignRight;
end;

procedure TfrmPtDemoEdit.btnSkypeCopyClick(Sender: TObject);
begin
  Clipboard.AsText := SkypeEdit.Text;
end;

procedure TfrmPtDemoEdit.btnTextColorClick(Sender: TObject);
begin
  HtmlEditor.TextForeColorDialog;
end;

procedure TfrmPtDemoEdit.btnUnderlineClick(Sender: TObject);
begin
  HtmlEditor.ToggleUnderline;
end;

procedure TfrmPtDemoEdit.Button1Click(Sender: TObject);
var
  frmGUIEditFMFile: TfrmGUIEditFMFile;
begin
  //temp function!  Delete later.
  frmGUIEditFMFile := TfrmGUIEditFMFile.Create(Self);
  frmGUIEditFMFile.PrepForm('2', Patient.DFN + ',', IntToStr(User.DUZ));
  frmGUIEditFMFile.ShowModal;
  //
  frmGUIEditFMFile.Free;
end;

procedure TfrmPtDemoEdit.PhoneNumEditChange(Sender: TObject);
begin
  if ProgPhoneChangeOccuring = false then SetModified(true);
  Case PhoneNumGrp.ItemIndex of
    0 : FCurPatientInfo.PhoneNumResidence  := PhoneNumEdit.Text;
    1 : FCurPatientInfo.PhoneNumWork := PhoneNumEdit.Text;
    2 : FCurPatientInfo.PhoneNumCell := PhoneNumEdit.Text;
    3 : FCurPatientInfo.PhoneNumTemp := PhoneNumEdit.Text;
  end;  {case}
end;

procedure TfrmPtDemoEdit.StartingDateEditChange(Sender: TObject);
begin
  if ProgAddressChangeOccuring = false then SetModified(true);
  Case AddressRGrp.ItemIndex of
    1 : FCurPatientInfo.TempStartingDate := StartingDateEdit.Text;
    2 : FCurPatientInfo.ConfidentalStartingDate := StartingDateEdit.Text;
  end;  {case}
end;

procedure TfrmPtDemoEdit.EndingDateEditChange(Sender: TObject);
begin
  if ProgAddressChangeOccuring = false then SetModified(true);
  Case AddressRGrp.ItemIndex of
    1 : FCurPatientInfo.TempEndingDate := EndingDateEdit.Text;
    2 : FCurPatientInfo.ConfidentalEndingDate := EndingDateEdit.Text;
  end;  {case}
end;

procedure TfrmPtDemoEdit.AliasNameEditChange(Sender: TObject);
var i : integer;
    pAlias : tAlias;
    tempB : boolean;
begin
  if ProgAliasChangeOccuring=false then begin
    i := AliasComboBox.ItemIndex;
    if i > -1 then begin
      pAlias := tAlias(AliasComboBox.Items.Objects[i]);
      if pAlias<>nil then begin
        pAlias.Name := AliasNameEdit.Text;
        AliasComboBox.Items.Strings[i]:= AliasNameEdit.Text;
        AliasComboBox.Text := AliasNameEdit.Text;
        tempB := ProgAliasChangeOccuring;
        ProgAliasChangeOccuring:=true;
        AliasComboBox.ItemIndex := i;
        ProgAliasChangeOccuring:=tempB;
        SetModified(true);
      end;
    end;
  end;
end;


procedure TfrmPtDemoEdit.AliasSSNEditChange(Sender: TObject);
var i : integer;
    pAlias : tAlias;
begin
  if ProgAliasChangeOccuring=false then begin
    i := AliasComboBox.ItemIndex;
    if i > -1 then begin
      pAlias := tAlias(AliasComboBox.Items.Objects[i]);
      if pAlias<>nil then begin
        pAlias.SSN := AliasSSNEdit.Text;
        SetModified(true);
      end;
    end;
  end;
end;

procedure TfrmPtDemoEdit.SetAliasEnabled(value : boolean);
begin
  AliasNameEdit.Enabled := value;
  AliasSSNEdit.Enabled := value;
  if value=true then begin
    AliasNameEdit.Color := clWindow;
    AliasSSNEdit.Color := clWindow;
  end else begin
    AliasNameEdit.Color := clInactiveBorder;
    AliasSSNEdit.Color := clInactiveBorder;
  end;
end;


function TfrmPtDemoEdit.CombinedName : string;
begin
  Result := '';
  Result := FNameEdit.Text;
  if MNameEdit.Text <> '' then Result := Result + ' ' + MNameEdit.Text;
  if SuffixEdit.Text <> '' then Result := Result + ' ' + SuffixEdit.Text;
  if Result <> '' then Result := ',' + Result;
  Result := LNameEdit.Text + Result;
end;

procedure TfrmPtDemoEdit.NameParts(CombinedName: string; var LName, FName, MName : string);
var tempS : string;
begin
  LName := piece(CombinedName,',',1);
  tempS := piece(CombinedName,',',2);
  FName := piece(tempS,' ',1);
  MName := piece(tempS,' ',2,16);
end;

procedure TfrmPtDemoEdit.ApplyBtnClick(Sender: TObject);
var TempPatientInfo : tPatientInfo;
begin
  if pagecontrol.ActivePage = tsDemographics then begin
    TempPatientInfo := tPatientInfo.Create;
    TempPatientInfo.Assign(FCurPatientInfo);
    TempPatientInfo.RemoveUnchanged(FServerPatientInfo);
    //kt 12/18/13 PostChangedInfo(TempPatientInfo);
    ChangesMade := TempPatientInfo.PostChangedInfo;  //kt 12/18/13
    TempPatientInfo.Destroy;
    SetModified(false);

  //kt end else if (uTMGOptions.ReadString('SpecialLocation','')='INTRACARE') and (pagecontrol.ActivePage = tsAdvanced) then begin
  end else if AtIntracareLoc() and (pagecontrol.ActivePage = tsAdvanced) then begin
    ApplyKeene;   //For Intracare   elh  11-17-10
  end else if pagecontrol.ActivePage = tsBasic then begin
    PostVisibleGrid(gridBasicPatientDemo);
    SetModified(false);
  end else if pagecontrol.ActivePage = tsNotes then begin
    SavePatientNotes;
    SetModified(false);
  end else if pagecontrol.ActivePage = tsAdvanced then begin
    PostVisibleGrid(gridPatientDemo);
    SetModified(false);
  end;
end;

function TfrmPtDemoEdit.PostVisibleGrid(Grid: TSortStringGrid): TModalResult;
begin
  result := PostChanges(Grid);
end;

function TfrmPtDemoEdit.PostChanges(Grid : TSortStringGrid) : TModalResult;
//Results:  mrNone -- no post done (not needed)
//          mrCancel -- user pressed cancel on confirmation screen.
//          mrNo -- signals posting error.
var Changes : TStringList;
    PostResult : TModalResult;
    CurrentData : TStringList;
    GridInfo : TGridInfo;
    IENS : string;
    PostForm    : TPostForm;

begin
  Result := mrNone;  //default to No changes
  GridInfo := GetInfoForGrid(Grid);
  if GridInfo=nil then exit;
  CurrentData := GridInfo.Data;
  if CurrentData=nil then exit;
  if CurrentData.Count = 0 then exit;
  IENS := Patient.DFN;
  if IENS='' then exit;
  PostForm:= TPostForm.Create(nil);
  Changes := TStringList.Create;
  CompileChanges(Grid,CurrentData,Changes);
  if Changes.Count>0 then begin
    PostForm.PrepForm(Changes);
    PostResult := PostForm.ShowModal;
    if PostResult = mrOK then begin
      //if DisuserChanged(Changes) then begin  //looks for change in file 200, field 4
      //  InitializeUsersTreeView;
      //end else begin
        if Pos('+',IENS)>0 then begin
          GridInfo.IENS := PostForm.GetNewIENS(IENS);
        end;
        if assigned(GridInfo.DataLoadProc) then begin
          GridInfo.DataLoadProc(GridInfo);
        end;
        {
        if CurrentData = CurrentUserData then begin
          LoadUserData(IENS,CurrentData);  //reload record from server.
        end else if CurrentData = CurrentSettingsData then begin
          GetSettingsInfo(GridInfo.FileNum, GridInfo.IENS, CurrentData);
        end else if CurrentData = CurrentPatientData then begin
          GetPatientInfo(GridInfo.IENS, CurrentData);
        end else if CurrentData = CurrentAnyFileData then begin
          GetAnyFileInfo(GridInfo.FileNum, GridInfo.IENS, CurrentData);
        end;
        }
      //end;
    end else if PostResult = mrNo then begin  //mrNo is signal of post Error
      // show error...
    end;
    Result := PostResult;
  end else begin
    Result := mrNone;
  end;
  Changes.Free;
  PostForm.Free;
end;

procedure TfrmPtDemoEdit.CompileChanges(Grid : TSortStringGrid; CurrentUserData,Changes : TStringList);
//Output format:
// FileNum^IENS^FieldNum^FieldName^newValue^oldValue

var row : integer;
    Entry : tFileEntry;
    oneEntry : string;
begin
  for row := 1 to Grid.RowCount-1 do begin
    Entry := GetLineInfo(Grid,CurrentUserData, row);
          {if Entry.oldValue <> Entry.newValue then begin
      if (Entry.newValue <> CLICK_FOR_SUBS) and
        (Entry.newValue <> COMPUTED_FIELD) and
        (Entry.newValue <> CLICK_TO_EDIT) and
        (Entry.newValue <> 'CLICK to Edit Sub-Entries') and
        (Entry.newValue <> 'CLICK to Add Text') then begin
        oneEntry := Entry.FileNum + '^' + Entry.IENS + '^' + Entry.Field + '^' + Entry.FieldName;
        oneEntry := oneEntry + '^' + Entry.newValue + '^' + Entry.oldValue;}
    if (Trim(Entry.oldValue) <> Trim(Entry.newValue)) then begin
      if (Entry.newValue <> COMPUTED_FIELD) and
        (Entry.newValue <> CLICK_TO_ADD_TEXT) and
        (Pos(CLICK_TO, Entry.newValue)=0) then begin
        oneEntry := Entry.FileNum + '^' + Entry.IENS + '^' + Entry.Field + '^' + Entry.FieldName;
        oneEntry := oneEntry + '^' + Entry.newValue + '^' + Entry.oldValue;
        Changes.Add(oneEntry);
      end;
    end;
  end;
end;

procedure TfrmPtDemoEdit.SetModified(value : boolean);
begin
  FCurPatientInfo.Modified := value;
  ApplyBtn.Enabled := FCurPatientInfo.Modified;
end;

procedure TfrmPtDemoEdit.AddAliasBtnClick(Sender: TObject);
var pAlias : tAlias;
    IEN : string;
begin
  pAlias := tAlias.Create;
  if FCurPatientInfo.AliasInfo.count>0 then begin
    IEN := FCurPatientInfo.AliasInfo.Strings[FCurPatientInfo.AliasInfo.count-1];
  end else begin
    IEN := IntToStr(FCurPatientInfo.MaxAliasIEN);
  end;
  FCurPatientInfo.MaxAliasIEN := StrToInt(IEN)+1;
  IEN := IntToStr(FCurPatientInfo.MaxAliasIEN);
  FCurPatientInfo.AliasInfo.AddObject(IEN,pAlias);
  SetModified(true);
  AliasCombobox.Items.AddObject('<Edit New Alias>',pAlias);
  //pAlias.Name := '<Edit New Alias>';
  //AliasCombobox.Items.Add(ADD_NEW_ALIAS);
  AliasCombobox.ItemIndex := AliasCombobox.Items.Count-1;
  SetAliasEnabled(true);
  ShowAliasInfo(FCurPatientInfo);
end;

procedure TfrmPtDemoEdit.OKBtnClick(Sender: TObject);
begin
  if FCurPatientInfo.Modified = true then begin
    case MessageDlg('Apply Changes?',mtConfirmation,mbYesNoCancel,0) of
      mrYes : begin
                ApplyBtnClick(Sender);
                Self.ModalResult := mrOK;  //closes form
              end;
      mrNo : begin
               if ChangesMade = false then Self.ModalResult := mrCancel // closes form, signal no need for refresh
               else Self.ModalResult := mrOK; // closes form.
             end;
      mrCancel :  Self.ModalResult := mrNone; //do nothing
    end; {case}
  end else begin
    if ChangesMade = false then Self.ModalResult := mrCancel // closes form, signal no need for refresh
    else Self.ModalResult := mrOK; // closes form.
  end;
  //kt if uTMGOptions.ReadString('SpecialLocation','')='INTRACARE' then begin
  if AtIntracareLoc() then begin
    if boolKeeneDirty then tsKeeneHide(self);  //Intracare  elh 11/17/10
  end;
end;

procedure TfrmPtDemoEdit.CancelBtnClick(Sender: TObject);
begin
  //kt if uTMGOptions.ReadString('SpecialLocation','')='INTRACARE' then begin
  if AtIntracareLoc() then begin
    if boolKeeneDirty then tsKeeneHide(self);  //Intracare  elh 11/17/10
  end;
  if FCurPatientInfo.Modified = true then begin
    case MessageDlg('Cancel Changes?',mtConfirmation,mbYesNoCancel,0) of
      mrYes : ModalResult := mrCancel;  //closes form
      mrNo : ModalResult := mrNone;  //do nothing
      mrCancel :  ModalResult := mrNone; //do nothing
    end; {case}
  end else begin
    ModalResult := mrCancel; // closes form.
  end;
end;


procedure TfrmPtDemoEdit.cbFontNamesChange(Sender: TObject);
var i :  integer;
    FontName : string;
const
   TEXT_BAR = '---------------';
begin
  inherited;
  if cbFontNames.Text[1]='<' then exit;
  FontName := cbFontNames.Text;
  HtmlEditor.FontName := FontName;
  i := cbFontNames.Items.IndexOf(TEXT_BAR);
  if i < 1 then cbFontNames.Items.Insert(0,TEXT_BAR);
  if i > 5 then cbFontNames.Items.Delete(5);
  if cbFontNames.Items.IndexOf(FontName)> i then begin
    cbFontNames.Items.Insert(0,FontName);
  end;
end;

procedure TfrmPtDemoEdit.cbFontSizeChange(Sender: TObject);
const
  FontSizes : array [0..6] of byte = (8,10,12,14,18,24,36);
begin
  inherited;
  HtmlEditor.FontSize := FontSizes[cbFontSize.ItemIndex];
end;

procedure TfrmPtDemoEdit.PageControlChange(Sender: TObject);
var
   GridInfo : TGridInfo;
   IEN : longInt;
begin
  if pagecontrol.ActivePage = tsDemographics then begin
   SyncActivePatient;
  end else if pagecontrol.ActivePage = tsNotes then begin
   LoadPatientNotes;
  end else if pagecontrol.ActivePage = tsBasic then begin
   IEN := strtoint(patient.dfn);  //get info from selected patient
   if IEN = 0 then exit;
   GridInfo := GetInfoForGrid(gridBasicPatientDemo);
   if GridInfo = nil then exit;
   GridInfo.IENS := IntToStr(IEN)+',';
   GetPatientInfo(GridInfo);
  end else if pagecontrol.ActivePage = tsAdvanced then begin
   IEN := strtoint(patient.dfn);  //get info from selected patient
   if IEN = 0 then exit;
   GridInfo := GetInfoForGrid(gridPatientDemo);
   if GridInfo = nil then exit;
   GridInfo.IENS := IntToStr(IEN)+',';
   GetPatientInfo(GridInfo);
  end;
end;

procedure TfrmPtDemoEdit.LoadPatientNotes;
var NotesSL : TStringList;
    IENS : string;
begin
  NotesSL := TStringList.Create;
  IENS := Patient.DFN+',';
  GetWPField('2', '22706', IENS, NotesSL);
  if not IsHTML(NotesSL) then begin
    Text2HTML(NotesSL)
  end;
  HtmlEditor.HTMLText := NotesSL.Text;
  NotesSL.Free;
end;

procedure TfrmPtDemoEdit.SavePatientNotes;
  //function  PostWPField(Lines: TStrings; FileNum,FieldNum,IENS : string) : boolean;
var NotesSL : TStringList;
    IENS : string;
begin
  NotesSL := TStringList.Create;
  NotesSL.Text := HtmlEditor.HTMLText;
  IENS := Patient.DFN+',';
  if PostWPField(NotesSL, '2', '22706', IENS) = false then begin
    MessageDlg('There was a problem saving notes.', mtInformation, [mbOK], 0);
  end;
  NotesSL.Free;
end;

procedure TfrmPtDemoEdit.HandleHTMLEditorModified(Sender : TObject);
begin
  if pagecontrol.ActivePage = tsNotes then SetModified(true);
end;

procedure TfrmPtDemoEdit.GetPatientInfo(GridInfo: TGridInfo);
var cmd,RPCResult : string;
    IENS : String;
    grid : TSortStringGrid;
begin
//  IENS := Patient.DFN;
  IENS := GridInfo.IENS;
//  Data := GridInfo.Data;
  grid := GridInfo.Grid;
  grid.Cells[0,1] := '';
  grid.Cells[1,1] := '';
  grid.Cells[2,1] := '';
  grid.RowCount :=2;
  grid.Cursor := crHourGlass;
  if IENS <> '0,' then begin
    RPCBrokerV.remoteprocedure := 'TMG CHANNEL';
    RPCBrokerV.param[0].ptype := list;
    cmd := 'GET ONE RECORD^2^' + IENS;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    //RPCBrokerV.Call;
    CallBroker;
    RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
    //Results[1]='FileNum^IENS^FieldNum^ExtValue^FieldName^DDInfo...
    //Results[2]='FileNum^IENS^FieldNum^ExtValue^FieldName^DDInfo...
    if piece(RPCResult,'^',1)='-1' then begin
      messagedlg(RPCBrokerV.Results[1],mtError,mbOKCancel,0);
      //FMErrorForm.Memo.Lines.Assign(RPCBrokerV.Results);
    end else begin
      GridInfo.Data.Assign(RPCBrokerV.results);
      //LoadAnyGrid(grid,false,'2',IENS,Data);
      //LoadAnyGridFromInfo(GridInfo);
      LoadAnyGrid(GridInfo);
    end;
  end;
  grid.Cursor := crDefault;
end;


  {
  //procedure TfrmPtDemoEdit.LoadAnyGridFromInfo(GridInfo : TGridInfo);
  procedure LoadAnyGridFromInfo(GridInfo : TGridInfo);
  //This assumes that GridInfo already has loaded info.
  var
    Grid : TSortStringGrid;  //the TSortStringGrid to load
    BasicMode: boolean;
    FileNum : string;
    IENS : string;
    CurrentData : TStringList;

    procedure LoadOneLine (Grid : TSortStringGrid; oneEntry : string; GridRow : integer);
    var
      tempFile,IENS : string;
      fieldNum,fieldName,fieldDef : string;
      subFileNum : string;
      value : string;
    begin
      tempFile := Piece(oneEntry,'^',1);
      if tempFile = FileNum then begin //handle subfiles later...
        IENS := Piece(oneEntry,'^',2);
        fieldNum := Piece(oneEntry,'^',3);
        value := Piece(oneEntry,'^',4);
        fieldName := Piece(oneEntry,'^',5);
        fieldDef := Piece(oneEntry,'^',6);
        Grid.RowCount := GridRow + 1;
        Grid.Cells[0,GridRow] := fieldNum;
        Grid.Cells[1,GridRow] := fieldName;
        if Pos('W',fieldDef)>0 then begin
          Grid.Cells[2,GridRow] := CLICK_TO_EDIT;
        end else if IsSubFile(fieldDef, subFileNum) then begin
          if IsWPField(CachedWPField,FileNum,fieldNum) then begin
            Grid.Cells[2,GridRow] := CLICK_TO_EDIT;
          end else begin
            Grid.Cells[2,GridRow] := CLICK_FOR_SUBS;
          end;
        end else if Pos('C',fieldDef)>0 then begin
          Grid.Cells[2,GridRow] := COMPUTED_FIELD;
        end else begin
          Grid.Cells[2,GridRow] := value;
        end;
        Grid.RowHeights[GridRow] := DEF_GRID_ROW_HEIGHT;
      end;
    end;

    function getOneLine(CurrentData : TStringList; oneFileNum,oneFieldNum : string) : string;
    var i : integer;
        FileNum,FieldNum : string;
    begin
      result := '';
      // FileNum^IENS^FieldNum^FieldName^newValue^oldValue
      for i := 1 to CurrentData.Count - 1 do begin
        FileNum := piece(CurrentData.Strings[i],'^',1);
        if FileNum <> oneFileNum then continue;
        FieldNum := piece(CurrentData.Strings[i],'^',3);
        if FieldNum <> oneFieldNum then continue;
        result := CurrentData.Strings[i];
        break;
      end;
    end;

  var i, j : integer;
      oneEntry  : string;
      oneFileNum,oneFieldNum : string;
      gridRow : integer;

  begin
    if GridInfo=nil then exit;
    GridInfo.LoadingGrid := true;
    Grid := GridInfo.Grid;
    BasicMode := GridInfo.BasicMode;
    FileNum := GridInfo.FileNum;
    IENS := GridInfo.IENS;
    CurrentData := GridInfo.Data;

    Grid.Cells[0,1] := '';
    Grid.Cells[1,1] := '';
    Grid.Cells[2,1] := '';
    Grid.RowCount :=2;
    Grid.ColWidths[0] := 50;
    Grid.ColWidths[1] := 200;
    Grid.ColWidths[2] := 300;
    Grid.Cells[0,0] := '#';
    Grid.Cells[1,0] := 'Name';
    Grid.Cells[2,0] := 'Value';

    if BasicMode=false then begin
      for i := 1 to CurrentData.Count-1 do begin  //start at 1 because [0] = 1^Success
        j := i;  //for some reason, if I don't do this, then line below modifies i !!
        //And as soon as I put in this work around, i stopped being modified.  Perhaps my change
        //  just forced the compiler to recompile this??  Borland!
        oneEntry := CurrentData.Strings[j];
        LoadOneLine (Grid,oneEntry,j);
      end;
    end else if (BasicMode=true) and (Assigned(GridInfo.BasicTemplate)) then begin
      gridRow := 1;
      for i := 0 to GridInfo.BasicTemplate.Count-1 do begin
        oneFileNum := Piece(GridInfo.BasicTemplate.Strings[i],'^',1);
        if oneFileNum <> fileNum then continue;
        oneFieldNum := Piece(GridInfo.BasicTemplate.Strings[i],'^',2);
        oneEntry := getOneLine(CurrentData,oneFileNum,oneFieldNum);
        LoadOneLine (Grid,oneEntry,gridRow);
        Inc(GridRow);
      end;
    end;
    GridInfo.LoadingGrid := false;
  end;
  }

  function TfrmPtDemoEdit.GetInfoForGrid(Grid : TSortStringGrid) : TGridInfo;
  var i : integer;
  begin
    i := GetInfoIndexForGrid(Grid);
    if i > -1 then begin
      result := TGridInfo(DataForGrid.Objects[i]);
    end else begin
      result := nil;
    end;
  end;


  function TfrmPtDemoEdit.GetInfoIndexForGrid(Grid : TSortStringGrid) : integer;
  var s : string;
  begin
    s := IntToStr(integer(Grid));
    result := DataForGrid.indexof(s);
  end;

  function TfrmPtDemoEdit.IsSubFile(FieldDef: string ; var SubFileNum : string) : boolean;
  //SubFileNum is OUT parameter
  begin
    SubFileNum := ExtractNum(FieldDef,1);
    result := (SubFileNum <> '');
  end;

  procedure TfrmPtDemoEdit.gridPatientDemoSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  var
    Grid : TSortStringGrid;
    GridInfo : TGridInfo;
    //AutoPressEditButtonInDetailDialog : boolean;

  begin
    Grid := (Sender as TSortStringGrid);
    GridInfo := GetInfoForGrid(Grid);
    if GridInfo=nil then exit;
    //AutoPressEditButtonInDetailDialog := false;
    //AnyGridPatientDemoSelectCell(GridInfo, ACol, ARow, CanSelect);
    //GridSelectCellFromInfo(GridInfo, ACol, ARow, CanSelect, nil, AutoPressEditButtonInDetailDialog);
    ExternalGridSelectCell(GridInfo, ACol, ARow, CanSelect);
    if CanSelect then begin
      FLastSelectedRow := ARow;
      FLastSelectedCol := ACol;
      SetModified(True);
    end;
  end;

  {
  procedure AnyGridPatientDemoSelectCell(GridInfo : TGridInfo; ACol, ARow: Integer; var CanSelect: Boolean);
    (*
    For Field def, here is the legend
    character     meaning

    BC 	          The data is Boolean Computed (true or false).
    C 	          The data is Computed.
    Cm 	          The data is multiline Computed.
    DC 	          The data is Date-valued, Computed.
    D 	          The data is Date-valued.
    F 	          The data is Free text.
    I 	          The data is uneditable.
    Pn 	          The data is a Pointer reference to file "n".
    S 	          The data is from a discrete Set of codes.

    N 	          The data is Numeric-valued.

    Jn 	          To specify a print length of n characters.
    Jn,d 	        To specify printing n characters with decimals.

    V 	          The data is a Variable pointer.
    W 	          The data is Word processing.
    WL 	          The Word processing data is normally printed in Line mode (i.e., without word wrap).
      *)
  var oneEntry,FieldDef : string;
      date,time: string;
      FileNum,FieldNum,SubFileNum : string;
      GridFileNum : string;
      UserLine : integer;
      Grid : TSortStringGrid;
      IEN : int64;
      IENS : string;
      CurrentData : TStringList;
      //GridInfo : TGridInfo;
      SubFileForm : TSubFileForm;
      SelDateTimeForm: TSelDateTimeForm;
      EditTextForm: TEditTextForm;
      SetSelForm: TSetSelForm;
      FieldLookupForm : TFieldLookupForm;

  begin
    //Grid := (Sender as TSortStringGrid);
    //GridInfo := GetInfoForGrid(Grid);
    if GridInfo=nil then exit;
    if GridInfo.LoadingGrid then exit;  //prevent pseudo-clicks during loading...
    GridFileNum := GridInfo.FileNum;
    CanSelect := false;  //default to NOT selectable.
    CurrentData := GridInfo.Data;
    if CurrentData=nil then exit;
    if CurrentData.Count = 0 then exit;
    Grid := GridInfo.Grid; if Grid=nil then exit;
    UserLine := GetUserLine(CurrentData, Grid, ARow);
    if UserLine = -1 then exit;
    oneEntry := CurrentData.Strings[UserLine];
    FieldDef := Piece(oneEntry,'^',6);
    if Pos('F',FieldDef)>0 then begin  //Free text
      CanSelect := true;
    end else if IsSubFile(FieldDef,SubFileNum) then begin  //Subfiles.
      FileNum :=  Piece(oneEntry,'^',1);
      FieldNum :=  Piece(oneEntry,'^',3);
      if IsWPField(CachedWPField,FileNum,FieldNum) then begin
        IENS :=  Piece(oneEntry,'^',2);
        EditTextForm := TEditTextForm.Create(nil);
        EditTextForm.PrepForm(FileNum,FieldNum,IENS);
        EditTextForm.ShowModal;
        FreeAndNil(EditTextForm);
      end else begin
        //handle subfiles here
        IENS := '';
        if GridInfo.MessageStr = MSG_SUB_FILE then begin  //used message from subfile Grid
          IENS := GridInfo.IENS;
        end; // else if LastSelTreeNode <> nil then begin  //this is one of the selction trees.
          IEN := strtoint(Patient.DFN); //longInt(LastSelTreeNode.Data);
          if IEN > 0 then IENS := InttoStr(IEN) + ',';
        if GridInfo.Data = CurrentAnyFileData then begin
          IEN := strtoint(patient.dfn);  //get info from selected record
          if IEN > 0 then IENS := InttoStr(IEN) + ',';
        end;
        if IENS <> '' then begin
          SubFileForm := TSubFileForm.Create(nil);
          SubFileForm.PrepForm(SubFileNum,IENS);
          SubfileForm.ShowModal;  // note: may call this function again recursively for sub-sub-files etc.
          SubFileForm.Free;
        end else begin
          MessageDlg('IENS for File="".  Can''t process.',mtInformation,[MBOK],0);
        end;
      end;
    end else if Pos('C',FieldDef)>0 then begin  //computed fields.
      CanSelect := false;
    end else if Pos('D',FieldDef)>0 then begin  //date field
      date := piece(Grid.Cells[ACol,ARow],'@',1);
      time := piece(Grid.Cells[ACol,ARow],'@',2);
      SelDateTimeForm := TSelDateTimeForm.Create(nil);
      if date <> '' then begin
        SelDateTimeForm.DateTimePicker.Date := StrToDate(date);
      end else begin
        SelDateTimeForm.DateTimePicker.Date := SysUtils.Date;
      end;
      if SelDateTimeForm.ShowModal = mrOK then begin
        date := DateToStr(SelDateTimeForm.DateTimePicker.Date);
        time := TimeToStr(SelDateTimeForm.DateTimePicker.Time);
        if time <> '' then date := date; // + '@' + time;    elh 8/15/08
        Grid.Cells[ACol,ARow] := date;
      end;
      CanSelect := true;
      FreeAndNil(SelDateTimeForm);
    end else if Pos('S',FieldDef)>0 then begin  //Set of Codes
      SetSelForm := TSetSelForm.Create(nil);
      SetSelForm.PrepForm('<MISSING FIELD DEF STR. FIX!',Piece(oneEntry,'^',7));
      if SetSelForm.ShowModal = mrOK then begin
        Grid.Cells[ACol,ARow] := SetSelForm.ComboBox.Text;
        CanSelect := true;
      end;
      FreeAndNil(SetSelForm);
    end else if Pos('I',FieldDef)>0 then begin  //uneditable
      ShowMessage('Sorry. Flagged as UNEDITABLE.');
    end else if Pos('P',FieldDef)>0 then begin  //Pointer to file.
      FileNum := ExtractNum (FieldDef,Pos('P',FieldDef)+1);
      //check for validity here...
      FieldLookupForm:= TFieldLookupForm.Create(nil);

      //fix!!! below needs to be restored and parameters corrected

      //fix --> FieldLookupForm.PrepForm(FileNum,Grid.Cells[ACol,ARow]);
      if FieldLookupForm.ShowModal = mrOK then begin
        Grid.Cells[ACol,ARow] := FieldLookupForm.ORComboBox.Text;
        CanSelect := true;
      end;
      FreeAndNil(FieldLookupForm);
    end;
    //if CanSelect then begin
      //FLastSelectedRow := ARow;
      //FLastSelectedCol := ACol;
      //SetModified(True);
    //end;
    //GridInfo.ApplyBtn.Enabled := true;
    //GridInfo.RevertBtn.Enabled := true;
  end;
  }

  {
  //function TfrmPtDemoEdit.GetLineInfo(Grid : TSortStringGrid; CurrentUserData : TStringList; ARow: integer) : tFileEntry;
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
  }

  //procedure TfrmPtDemoEdit.GetOneRecord(FileNum, IENS : string; Data, BlankFileInfo: TStringList);
  procedure GetOneRecord(FileNum, IENS : string; Data, BlankFileInfo: TStringList);
  //kt 12/18/13.  This function differs only SLIGHTLY from the once in rTMGRPCs
  var cmd,RPCResult : string;
      i : integer;
      oneEntry : string;
      FMErrorForm: TFMErrorForm;
  begin
    FMErrorForm := nil;
    Data.Clear;
    if (IENS='') then exit;
    if Pos('+',IENS)=0 then begin //don't ask server to load +1 records.
      RPCBrokerV.remoteprocedure := 'TMG CHANNEL';
      RPCBrokerV.Param[0].Value := '.X';  // not used
      RPCBrokerV.param[0].ptype := list;
      cmd := 'GET ONE RECORD^' + FileNum + '^' + IENS;
      RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
      //RPCBrokerV.Call;
      CallBroker;
      RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
      if piece(RPCResult,'^',1)='-1' then begin
      FMErrorForm:= TFMErrorForm.Create(nil);
      FMErrorForm.Memo.Lines.Assign(RPCBrokerV.Results);
      FMErrorForm.PrepMessage;
      FMErrorForm.ShowModal;
      end else begin
        Data.Assign(RPCBrokerV.Results);
      end;
    end else begin
      Data.Add('1^Success');  //to keep same as call to server
      if BlankFileInfo.Count = 0 then begin
        //Format is: FileNum^^FieldNum^^DDInfo...
        //  elh GetBlankFileInfo(FileNum,BlankFileInfo);
      end;
      for i := 1 to BlankFileInfo.Count-1 do begin  //0 is 1^success
        oneEntry := BlankFileInfo.Strings[i];
        //  elh SetPiece(oneEntry,'^',2,IENS);
        Data.Add(oneEntry);
      end;
    end;
    if assigned(FMErrorForm) then FMErrorForm.Free;
  end;

  function TfrmPtDemoEdit.GetUserLine(CurrentUserData : TStringList; Grid : TSortStringGrid; ARow: integer) : integer;
  var fieldNum: string;
      tempFileNum : string;
  begin
    fieldNum := Grid.Cells[0,ARow];
    Result := FindInStrings(fieldNum,CurrentUserData,tempFileNum);
  end;

  {
  function TfrmPtDemoEdit.FindInStrings(fieldNum : string; Strings : TStringList; var fileNum : string) : integer;
  //kt 12/18/13.  This function differs only SLIGHTLY from the once in rTMGRPCs
  //Note: if fileNum is passed blank, then first matching file will be placed in it (i.e. OUT parameter)
  var tempFieldNum : string;
      oneEntry,tempFile : string;
      i : integer;
  begin
    result := -1;
    fileNum := '';
    for i := 0 to Strings.Count-1 do begin   //0 --> 1^success
      oneEntry := Strings.Strings[i];
      tempFile := Piece(oneEntry,'^',1);
      if (tempFile='1') and (UpperCase(Piece(oneEntry,'^',2))='SUCCESS') then continue;
      if fileNum='' then fileNum := tempFile;
      if tempFile <> fileNum then continue; //ignore subfiles
      tempFieldNum := Piece(oneEntry,'^',3);
      if tempFieldNum <> fieldNum then continue;
      Result := i;
      break;
    end;
  end;
  }
  procedure TfrmPtDemoEdit.AddGridInfoADV(Grid: TSortStringGrid;
                                  Data : TStringList;
                                  BasicMode : boolean;
                                  DataLoader : TGridDataLoader;
                                  FileNum : string);
  var tempGridInfo : TGridInfo;
  begin
    tempGridInfo := TGridInfo.Create;
    tempGridInfo.Grid := Grid;
    tempGridInfo.Data := Data;
    tempGridInfo.BasicMode := BasicMode;
    tempGridInfo.FileNum := FileNum;
    tempGridInfo.DataLoadProc := DataLoader;
    //tempGridInfo.ApplyBtn := ApplyBtn;
    //tempGridInfo.RevertBtn := RevertBtn;
    RegisterGridInfo(tempGridInfo);
  end;

  procedure TfrmPtDemoEdit.AddGridInfoBASIC(Grid: TSortStringGrid;
                                  Data : TStringList;
                                  BasicMode : boolean;
                                  DataLoader : TGridDataLoader;
                                  FileNum : string);
  var tempGridInfo : TGridInfo;
  begin
    tempGridInfo := TGridInfo.Create;
    tempGridInfo.Grid := Grid;
    tempGridInfo.Data := Data;
    tempGridInfo.BasicTemplate := BasicTemplate;
    tempGridInfo.BasicMode := BasicMode;
    tempGridInfo.FileNum := FileNum;
    tempGridInfo.DataLoadProc := DataLoader;
    //tempGridInfo.ApplyBtn := ApplyBtn;
    //tempGridInfo.RevertBtn := RevertBtn;
    RegisterGridInfo(tempGridInfo);
  end;

  procedure TfrmPtDemoEdit.RegisterGridInfo(GridInfo : TGridInfo);
  var s : string;
  begin
    if GridInfo = nil then exit;
    s := IntToStr(integer(GridInfo.Grid));
    DataForGrid.AddObject(s,GridInfo);
  end;

  procedure TfrmPtDemoEdit.gridPatientDemoSetEditText(Sender: TObject; ACol,
                                              ARow: Integer; const Value: String);
  begin
    SetModified(True);
  end;

  procedure TfrmPtDemoEdit.PageControlChanging(Sender: TObject;
    var AllowChange: Boolean);
  var
     intAnswer : Integer;
  begin
  //Before changing the form, find out if changes need to be applied and prompt user.  //elh
      if ApplyBtn.enabled = True then begin
         intAnswer := messagedlg('Do you want to apply your changes?', mtWarning,mbYesNoCancel,0);
         if intAnswer = mrYes then begin  //Yes
            ApplyBtnClick(Sender);
            //messagedlg('Changes Saved.', mtWarning,[mbOK],0);
            SetModified(False);
          end else if intAnswer = mrNo then begin    //No
            SetModified(False);
          end else if intAnswer = mrCancel then begin    //Cancel
            AllowChange := False;
          end;
      end;
  end;

//====================================================================
//====================================================================
//  Everything below is for Intracare   elh  11-17-10
//====================================================================
//====================================================================

procedure TfrmPtDemoEdit.tsKeeneShow(Sender: TObject);
var
   RPCResult: string;
   strDate: string;
begin
  //kt if uTMGOptions.ReadString('SpecialLocation','')<>'INTRACARE' then exit;
  {
  if not AtIntracareLoc() then exit;
  boolKeeneDirty := False;
  boolKeeneLoading := True;
  RPCResult := sCallV('TMG KEENE GET ACCOUNT NUMBERS', [Patient.DFN]);
  KeeneAcctNo.Text := Piece(RPCResult,'^',1);
  KeeneAdmissionNumber.Text := Piece(RPCResult,'^',2);
  if Piece(RPCResult,'^',3) <> '' then begin
    strDate := FormatFMDateTimeStr('mm/dd/yy', Piece(RPCResult,'^',3));
    //Date := FormatDateTime('mm/dd/yyyy',StrToDate(Piece(RPCResult,'^',3)));
    KeeneAdmissionDate.Date := StrToDate(strDate);
  end else begin
    KeeneAdmissionDate.Date := Date;
  end;
  boolKeeneLoading := False;     }
end;

procedure TfrmPtDemoEdit.tsKeeneHide(Sender: TObject);
begin
  //kt if uTMGOptions.ReadString('SpecialLocation','')<>'INTRACARE' then exit;
  if not AtIntracareLoc() then exit;
  if boolKeeneDirty then begin
    if messagedlg('Do you want to save the account number changes?',mtWarning,[mbYes,mbNo],0) = mrYes then begin
      ApplyKeene;
    end else begin
      boolKeeneDirty := False;
      ApplyBtn.enabled := False;
    end;
  end;
end;

procedure TfrmPtDemoEdit.KeeneAcctNoChange(Sender: TObject);
begin
  MakeKeeneDirty;
end;

procedure TfrmPtDemoEdit.KeeneAdmissionNumberChange(Sender: TObject);
begin
  MakeKeeneDirty;
end;

procedure TfrmPtDemoEdit.KeeneAdmissionDateChange(Sender: TObject);
begin
  MakeKeeneDirty;
end;

procedure TfrmPtDemoEdit.MakeKeeneDirty;
begin
  //kt if uTMGOptions.ReadString('SpecialLocation','')<>'INTRACARE' then exit;
  if not AtIntracareLoc() then exit;
  if boolKeeneLoading then exit;
  boolKeeneDirty := True;
  ApplyBtn.enabled := True;
end;

procedure TfrmPtDemoEdit.ApplyKeene;
var
   RPCResult : string;
begin
{
  //kt if uTMGOptions.ReadString('SpecialLocation','')<>'INTRACARE' then exit;
  if not AtIntracareLoc() then exit;
  if KeeneAcctNo.text <> '' then begin
    RPCResult := sCallV('TMG KEENE SET ACCOUNT NUMBER', [Patient.DFN,KeeneAcctNo.text]);
    if Piece(RPCResult,'^',1)= '-1' then begin
      messagedlg('Error saving Keene account number.' + #10#13 + 'Error: '+Piece(RPCResult,'^',2),mtError,[mbOK],0);
    end;
  end;}
  {    //REMOVING KEENE ADMISSION NUMBER
  if (KeeneAdmissionNumber.text <> '') AND (DateToStr(KeeneAdmissionDate.Date) <> '') then begin
    RPCResult := sCallV('TMG KEENE SET ADMISSION NUMBER', [Patient.DFN,KeeneAdmissionNumber.text,DateToStr(KeeneAdmissionDate.Date)]);
    if Piece(RPCResult,'^',1)= '-1' then begin
      messagedlg('Error saving Keene admission number.' + #10#13 + 'Error: '+Piece(RPCResult,'^',2),mtError,[mbOK],0);
    end;
  end;                            }
{
  boolKeeneDirty := False;
  ApplyBtn.enabled := False;}
end;


end.
