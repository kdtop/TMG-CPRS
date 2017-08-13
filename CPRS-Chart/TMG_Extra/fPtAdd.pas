unit fPtAdd;
//kt 9/11  This entire module and form was added.
//Coded by Eddie Hagood 10/2007
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
  Dialogs, StdCtrls, Trpcb, mfunstr, ORNet, uCore, ExtCtrls, StrUtils,
  Buttons, ComCtrls;

const
  SSNUM_REQUIRED = true;  //set to true to force entry of ssnum

type
  TPatientInfo = class(TObject)
  public
    LName: String;
    FName: String;
    MName: String;
    CombinedName: String;
    Suffix: String;
    DOB: String;
    Sex: String;
    SSNum: String;
    PtType: String;
    Veteran: String;
    Address1: string;
    Address2: string;
    City: string;
    State: string;
    Zip: string;
    Phone: string;
    Cell: string;
    EMail: string;
    Skype: string;
    procedure ClearArray;
  end;
  
  TfrmPtAdd = class(TForm)
    OkButton: TButton;
    CloseButton: TButton;
    Label1: TLabel;
    PageControl: TPageControl;
    tsMain: TTabSheet;
    LNameLabel: TLabel;
    LNameEdit: TEdit;
    FNameEdit: TEdit;
    MNameLabel: TLabel;
    FNameLabel: TLabel;
    MNameEdit: TEdit;
    SuffixLabel: TLabel;
    SuffixEdit: TEdit;
    DOBLabel: TLabel;
    DOBEdit: TEdit;
    Label2: TLabel;
    SSNumLabel: TLabel;
    SSNumEdit: TEdit;
    SSNHelpBtn: TSpeedButton;
    SexLabel: TLabel;
    SexComboBox: TComboBox;
    PrefixLabel: TLabel;
    PtTypeComboBox: TComboBox;
    VeteranCheckBox: TCheckBox;
    tsExtra: TTabSheet;
    Label3: TLabel;
    AddressLine1Edit: TEdit;
    Label7: TLabel;
    AddressLine2Edit: TEdit;
    Label4: TLabel;
    CityEdit: TEdit;
    Label5: TLabel;
    StateComboBox: TComboBox;
    Label6: TLabel;
    Zip4Edit: TEdit;
    Label8: TLabel;
    PhoneEdit: TEdit;
    Label11: TLabel;
    CellEdit: TEdit;
    Label9: TLabel;
    EMailEdit: TEdit;
    Label10: TLabel;
    SkypeEdit: TEdit;
    procedure Zip4EditChange(Sender: TObject);
    procedure StateComboBoxChange(Sender: TObject);
    procedure CityEditChange(Sender: TObject);
    procedure AddressLine2EditChange(Sender: TObject);
    procedure AddressLine1EditChange(Sender: TObject);
    procedure OnShow(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure LNameEditChange(Sender: TObject);
    procedure FNameEditChange(Sender: TObject);
    procedure DOBEditChange(Sender: TObject);
    procedure SSNumEditChange(Sender: TObject);
    procedure SexComboBoxChange(Sender: TObject);
    procedure MNameEditChange(Sender: TObject);
    procedure SuffixEditChange(Sender: TObject);
    procedure PtTypeComboBoxChange(Sender: TObject);
    procedure VeteranCheckBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SSNumEditExit(Sender: TObject);
    procedure SSNumEditKeyPress(Sender: TObject; var Key: Char);
    procedure DOBEditKeyPress(Sender: TObject; var Key: Char);
    procedure LNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure FNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure MNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure SuffixEditKeyPress(Sender: TObject; var Key: Char);
    procedure SexComboBoxKeyPress(Sender: TObject; var Key: Char);
    procedure PtTypeComboBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure DOBEditExit(Sender: TObject);
    procedure SSNHelpBtnClick(Sender: TObject);
  private
    { Private declarations }
    ThisPatientInfo: TPatientInfo;
    ProgModSSNum : boolean;
    procedure ResetColors();
    procedure ResetFields();
    procedure TestUserInput();
    procedure DataToArray();
    procedure CreatePSSN();
    procedure PostInfo(ThisPatientInfo : TPatientInfo);
    function FrmtSSNum(SSNumStr : string) : string;
    function UnFrmtSSNum(SSNumStr : string) : string;
    function SSNumInvalid(SSNumStr: string) : boolean;
  public
    { Public declarations }
    SSNChecking : boolean; //kt
    DFN: Int64;
  end;

//var
//  frmPtAdd: TfrmPtAdd;

implementation

uses fPtSel, uTMGOptions, uTMGUtil;

{$R *.dfm}

var
  boolErrorFound: boolean; 
  boolDirtyForm: boolean;

procedure TfrmPtAdd.OnShow(Sender: TObject);
begin
  PageControl.ActivePage := tsMain;
  LNameEdit.SetFocus;
  PtTypeComboBox.Text := 'NON-VETERAN (OTHER)';
  ResetColors;
  ResetFields;
  ThisPatientInfo.ClearArray;
  boolDirtyForm := False;
  DFN := -1;
  SSNChecking := uTMGOptions.ReadBool('Validate SSN',True);
  if SSNChecking then SSNumLabel.Caption := 'Social Sec Num'
  else SSNumLabel.Caption := 'ID';
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.AddressLine1EditChange(Sender: TObject);
begin
  ResetColors;
  ThisPatientInfo.Address1  := AddressLine1Edit.Text;
  boolDirtyForm := True;
  label1.Visible := False;
end;

procedure TfrmPtAdd.AddressLine2EditChange(Sender: TObject);
begin
  ResetColors;
  ThisPatientInfo.Address2  := AddressLine2Edit.Text;
  boolDirtyForm := True;
  label1.Visible := False;
end;

procedure TfrmPtAdd.CancelButtonClick(Sender: TObject);
begin
  if (boolDirtyForm = True) then begin
    if MessageDlg('** Patient Not Yet Added **'+#10+#13+
                  'ADD this patient before exiting?',
                   mtWarning, [mbYes, mbNo],0) = mrYes then begin
      OkButtonClick(self);
    end else begin
      modalresult:=1;
    end;       
  end else begin
    modalresult:=1;
  end;
end;
procedure TfrmPtAdd.CityEditChange(Sender: TObject);
begin
  ResetColors;
  ThisPatientInfo.City  := CityEdit.Text;
  boolDirtyForm := True;
  label1.Visible := False;
end;

//------------------------------------------------------------------------
procedure TfrmPtAdd.ResetColors();
begin
  LNameEdit.Color := clWindow;
  FNameEdit.Color := clWindow;
  DOBEdit.Color := clWindow;
  SSNumEdit.Color := clWindow;
  SexComboBox.Color := clWindow;
  AddressLine1Edit.Color := clWindow;
  CityEdit.Color := clWindow;
  StateComboBox.Color := clWindow;
  Zip4Edit.Color := clWindow;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.ResetFields();
begin
  LNameEdit.text := '';
  FNameEdit.text := '';
  MNameEdit.text := '';
  SuffixEdit.Text := '';
  PtTypeComboBox.Text := 'NON-VETERAN (OTHER)';
  DOBEdit.text := '';
  SSNumEdit.text := '';
  SexComboBox.text := '<Sex>';
  Label1.Visible := False;
  Label1.Caption := '';
  VeteranCheckbox.Checked := False;
  AddressLine1Edit.Text := '';
  AddressLine2Edit.Text := '';
  CityEdit.Text  := '';
  StateComBoBox.Text := '';
  Zip4Edit.Text := '';
  PhoneEdit.Text := '';
  CellEdit.Text := '';
  EMailEdit.Text := '';
  SkypeEdit.Text := '';
end;
//------------------------------------------------------------------------

procedure TfrmPtAdd.OkButtonClick(Sender: TObject);

begin
  TestUserInput;
  if boolErrorFound = False then begin
    DataToArray;
    PostInfo(ThisPatientInfo);
    boolDirtyForm := False;
    ThisPatientInfo.ClearArray;
    modalresult:=1;
  end else begin
    label1.Caption := 'Needs: ' + label1.caption;
    label1.Visible := True;
  end;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.LNameEditChange(Sender: TObject);
begin
  ResetColors;
  ThisPatientInfo.LName := LNameEdit.Text;
  boolDirtyForm := True;
  label1.Visible := False;
  if Pos('P',SSNumEdit.Text) > 0 then begin
    CreatePSSN();
  end;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.FNameEditChange(Sender: TObject);
begin
  ResetColors;
  ThisPatientInfo.FName := FNameEdit.Text;
  boolDirtyForm := True;
  label1.Visible := False;
  if Pos('P',SSNumEdit.Text) > 0 then begin
    CreatePSSN();
  end;
end;
//------------------------------------------------------------------------    
procedure TfrmPtAdd.MNameEditChange(Sender: TObject);
begin
  ThisPatientInfo.MName := MNameEdit.Text;
  boolDirtyForm := True;
  label1.Visible := False;
  if Pos('P',SSNumEdit.Text) > 0 then begin
    CreatePSSN();
  end;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.DOBEditChange(Sender: TObject);
begin
  ResetColors;
  label1.Visible := False;
  ThisPatientInfo.DOB := DOBEdit.Text;
  if Pos('P',SSNumEdit.Text) > 0 then begin
    CreatePSSN();
  end;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.SSNumEditChange(Sender: TObject);
begin
  if ProgModSSNum = false then begin
    ResetColors;
    ThisPatientInfo.SSNum := UnFrmtSSNum(SSNumEdit.Text);
    //ProgModSSNum := true;
    //SSNumEdit.Text := FrmtSSNum(ThisPatientInfo.SSNum);
    //ProgModSSNum := false;
    boolDirtyForm := True;
    label1.Visible := False;
  end;  
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.SexComboBoxChange(Sender: TObject);
begin
  ResetColors;
  ThisPatientInfo.Sex  := SexComboBox.Text;
  boolDirtyForm := True;
  label1.Visible := False;
end;
//------------------------------------------------------------------------

procedure TfrmPtAdd.TestUserInput();
begin
  boolErrorFound := False;
  label1.caption := '';
  label1.Visible := False;
  ResetColors;

  if SSNumInvalid(ThisPatientInfo.SSNum) then begin
    if MessageDlg('Invalid SSN. Would you like to use a pseudo-SSN?', mtConfirmation, [mbYes, mbNo],0) = mrYes then begin
       SSNumEdit.Text := 'p';
    end else begin
       label1.Caption := label1.Caption + 'SSN,';
       boolErrorFound := True;
       SSNumEdit.Color := clYellow;
    end;
  end;

  if LNameEdit.Text = '' then begin
    label1.Caption := 'Last Name,';
    boolErrorFound := True;
    LNameEdit.Color := clYellow;
  end;
  if FNameEdit.Text = '' then begin
    label1.Caption := label1.Caption + 'First Name,';
    boolErrorFound := True;
    FNameEdit.Color := clYellow;
  end;
  if DOBEdit.Text = '' then begin
    label1.Caption := label1.Caption + 'DOB,';
    boolErrorFound := True;
    DOBEdit.Color := clYellow;
  end;

  if SexComboBox.Text = '<Sex>' then begin
    label1.Caption := label1.Caption + 'Gender';
    boolErrorFound := True;
    SexComboBox.Color := clYellow;
  end;

  //kt if uTMGOptions.ReadString('SpecialLocation','')<>'INTRACARE' then exit;
  if AtIntracareLoc() then begin
    if AddressLine1Edit.Text = '' then begin
      label1.Caption := label1.Caption + 'Address,';
      boolErrorFound := True;
      AddressLine1Edit.Color := clYellow;
    end;

    if CityEdit.Text = '' then begin
      label1.Caption := label1.Caption + 'City,';
      boolErrorFound := True;
      CityEdit.Color := clYellow;
    end;

    if StateComboBox.Text = '' then begin
      label1.Caption := label1.Caption + 'State,';
      boolErrorFound := True;
      StateComboBox.Color := clYellow;
    end;

    if Zip4Edit.Text = '' then begin
      label1.Caption := label1.Caption + 'Zip';
      boolErrorFound := True;
      Zip4Edit.Color := clYellow;
    end;
  end;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.DataToArray();

begin
  ThisPatientInfo.ClearArray;
  ThisPatientInfo.LName := LNameEdit.Text;
  ThisPatientInfo.FName := FNameEdit.Text;
  ThisPatientInfo.MName := MNameEdit.Text;
  ThisPatientInfo.Suffix  := SuffixEdit.Text;
  ThisPatientInfo.DOB := DOBEdit.Text;
  ThisPatientInfo.Sex := SexComboBox.Text;
  ThisPatientInfo.Address1 := AddressLine1Edit.Text;
  ThisPatientInfo.Address2 := AddressLine2Edit.Text;
  ThisPatientInfo.City := CityEdit.Text;
  ThisPatientInfo.State :=  StateComBoBox.Text;
  ThisPatientInfo.Zip := Zip4Edit.Text;
  ThisPatientInfo.Phone := PhoneEdit.Text;
  ThisPatientInfo.Cell := CellEdit.Text;
  ThisPatientInfo.EMail := EMailEdit.Text;
  ThisPatientInfo.Skype := SkypeEdit.Text;

  if Uppercase(SSNumEdit.Text) = 'P' then begin
    CreatePSSN;
  end else begin
    ThisPatientInfo.SSNum := UnFrmtSSNum(SSNumEdit.Text);
  end;

  ThisPatientInfo.PtType := PtTypeComboBox.Text;
  if VeteranCheckBox.Checked = True then ThisPatientInfo.Veteran := 'True' else ThisPatientInfo.Veteran := 'False';

end;
//------------------------------------------------------------------------
procedure TPatientInfo.ClearArray;
begin
  LName := '';
  FName := '';
  MName := '';
  Suffix := '';
  DOB := '';
  Sex := '';
  SSNum := '';
  PtType := '';
  Veteran := '';
  Address1 := '';
  Address2 := '';
  City := '';
  State := '';
  Zip := '';
  Phone := '';
  Cell := '';
  EMail := '';
  Skype := '';
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.SuffixEditChange(Sender: TObject);
begin
  ThisPatientInfo.Suffix := SuffixEdit.Text;
  boolDirtyForm := True;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.PtTypeComboBoxChange(Sender: TObject);
begin
  ThisPatientInfo.PtType := PtTypeComboBox.Text;
  boolDirtyForm := True;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.VeteranCheckBoxClick(Sender: TObject);
begin
  if VeteranCheckBox.Checked = True then ThisPatientInfo.Veteran := 'True' else ThisPatientInfo.Veteran := 'False';
  boolDirtyForm := True;
end;
procedure TfrmPtAdd.Zip4EditChange(Sender: TObject);
begin
  ResetColors;
  ThisPatientInfo.Zip  := Zip4Edit.Text;
  boolDirtyForm := True;
  label1.Visible := False;
end;

//------------------------------------------------------------------------
procedure TfrmPtAdd.FormCreate(Sender: TObject);
begin
  ThisPatientInfo := TPatientInfo.Create;
  DFN := -1;
  ProgModSSNum := false;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.SSNumEditExit(Sender: TObject);
begin
  ProgModSSNum := true;
  SSNumEdit.Text := FrmtSSNum(ThisPatientInfo.SSNum);
  ProgModSSNum := false;

  if (SSNumInvalid(ThisPatientInfo.SSNum)) and (SSNumEdit.Text <>'') then begin
    label1.Caption := 'SSN not correct length';
    label1.Visible := True;
    SSNumEdit.Color := clYellow;
  end;  
end;
//------------------------------------------------------------------------
function TfrmPtAdd.SSNumInvalid(SSNumStr: string) : boolean;
//kt 6/18/08 change.  Made null entry to be VALID optionally
var targetLen : byte;
begin
  if SSNChecking = false then begin
    Result := false;
    exit;
  end;
  if (SSNumStr<>'') or SSNUM_REQUIRED then begin
    if Pos('P',SSNumStr)>0 then targetLen := 10 else targetLen := 9;
    Result := (length(SSNumStr) <> targetLen);
  end else begin
    Result := false;  //'' is valid entry now for SS (not required)
  end;
end;

procedure TfrmPtAdd.StateComboBoxChange(Sender: TObject);
begin
  ResetColors;
  if StateComboBox.Text<>'' then ThisPatientInfo.State  := StateComboBox.Text;
  boolDirtyForm := True;
  label1.Visible := False;
end;

//------------------------------------------------------------------------
procedure TfrmPtAdd.SSNumEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = 'p' then Key := 'P';
  if Key=#8 then begin
    if Pos('P',SSNumEdit.Text)>0 then begin
      SSNumEdit.Text := '';
      Key := #0;
    end;  
  end else if Key='P' then begin  
    CreatePSSN;
    Key := #0;
  end else if not (Key in ['0'..'9','-']) then Key := #0;
end;
//------------------------------------------------------------------------
function TfrmPtAdd.FrmtSSNum(SSNumStr : string) : string;
var partA,partB,partC : string;
begin
  partA := MidStr(SSNumStr,1,3);
  partB := MidStr(SSNumStr,4,2);
  partC := MidStr(SSNumStr,6,5);
  Result := partA;
  if length(partA)=3 then begin
    Result := Result + '-' + partB;  
    if partC<>'' then begin
      Result := Result + '-' + partC;
    end;  
  end else begin
    Result := SSNumStr;
  end;
end;
//------------------------------------------------------------------------
function TfrmPtAdd.UnFrmtSSNum(SSNumStr : string) : string;
begin
  Result := AnsiReplaceText(SSNumStr,'-','');  
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.DOBEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['-', '\'] then Key := '/';
  if Key in ['0'..'9'] + ['/'] then Key := Key 
  else if Key <> #8 then Key := #0;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.LNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  Key := Uppercase(Key)[1];
  if Key in ['0'..'9',','] then Key := #0
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.FNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  Key := Uppercase(Key)[1];
  if Key in ['0'..'9'] then Key := #0
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.MNameEditKeyPress(Sender: TObject; var Key: Char);
begin
  Key := Uppercase(Key)[1];
  if Key in ['0'..'9'] then Key := #0
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.SuffixEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0'..'9'] then Key := #0
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.SexComboBoxKeyPress(Sender: TObject; var Key: Char);
begin
  Key := Uppercase(Key)[1];
  if Key = 'M' then begin
    SexComboBox.Text := 'MALE';
    Key := #0;
  end else if Key = 'F' then begin
    SexComboBox.Text := 'FEMALE';
    Key := #0;
  end else if Key = #8 then begin
    SexComboBox.Text := '';
    Key := #0;
  end else Key := #0;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.PtTypeComboBoxKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.PostInfo(ThisPatientInfo : TPatientInfo);
var tempResult: integer;
    tempS,s2 : string;

  procedure CheckPost(Title, Value : string);
  begin
    if Value <> '' then RPCBrokerV.Param[0].Mult['"'+Title+'"'] := Value;
  end;

begin
  if MessageDlg('Add New Patient?  (Can Not Be Undone)',
                mtConfirmation, [mbYes, mbNo],0) = mrNo then exit;

  RPCBrokerV.remoteprocedure := 'TMG ADD PATIENT';

  RPCBrokerV.Param[0].PType := list;
  with ThisPatientInfo do begin
    CombinedName := LName + ',' + FName;
    If MName <> '' then CombinedName := CombinedName + ' ' + MName;
    If Suffix <> '' then CombinedName := CombinedName + ' ' + Suffix;
    CheckPost('COMBINED_NAME',CombinedName);
    CheckPost('DOB',DOB);
    CheckPost('SEX',Sex);
    CheckPost('SS_NUM',SSNum);
    CheckPost('ADDRESS1',Address1);
    CheckPost('ADDRESS2',Address2);
    CheckPost('CITY',City);
    CheckPost('STATE',State);
    CheckPost('ZIP',Zip);
    CheckPost('PHONE',Phone);
    CheckPost('CELL',Cell);
    CheckPost('EMAIL',EMail);
    CheckPost('SKYPE',Skype);
    //CheckPost('Veteran',Veteran);
    //CheckPost('PtType',PtType);

    //RPCBrokerV.Call;
    CallBroker;
    tempS := RPCBrokerV.Results.Strings[0];
    tempResult := strtoint(piece(tempS,'^',1));
    DFN := tempResult;
    if DFN > 0 then begin
       //MessageDlg('Patient successfully added',mtInformation,[mbOK],0);
    end else begin
      s2 := piece(tempS,'^',2);
      if (tempResult = 0) and (s2 <> '') then begin
        DFN := strtoint(s2);
        MessageDlg('Patient already exists.',mtError,[mbOK],0);
      end else begin
        MessageDlg('Error Adding: "'+tempS+'"',mtError,[mbOK],0);
      end;
    end;
  end;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.FormDestroy(Sender: TObject);
begin
  ThisPatientInfo.Destroy;
end;
//------------------------------------------------------------------------
procedure TfrmPtAdd.CreatePSSN();
var 
  i: integer; 
  tempPseudo: string; 
  Init : array [1..3] of char;
  code : char;
  Month,Day,Year: string;
  
begin
  for i := 1 to 3 do Init[i]:=' ';
  if ThisPatientInfo.FName<>'' then Init[1] := UpperCase(ThisPatientInfo.FName)[1];
  if ThisPatientInfo.MName<>'' then Init[2] := UpperCase(ThisPatientInfo.MName)[1];
  if ThisPatientInfo.LName<>'' then Init[3] := UpperCase(ThisPatientInfo.LName)[1];

  tempPseudo := '';
  for i := 1 to 3 do begin
    if      Init[i] in ['A','B','C'] then code := '1'
    else if Init[i] in ['D','E','F'] then code := '2'
    else if Init[i] in ['G','H','I'] then code := '3'
    else if Init[i] in ['J','K','L'] then code := '4'
    else if Init[i] in ['M','N','O'] then code := '5'
    else if Init[i] in ['P','Q','R'] then code := '6'
    else if Init[i] in ['S','T','U'] then code := '7'
    else if Init[i] in ['V','W','X'] then code := '8'
    else if Init[i] in ['Y','Z']     then code := '9'
    else if Init[i] in [' ']         then code := '0'
    else code := '0';
    tempPseudo := tempPseudo + code;
  end;  
  
  Month := piece(ThisPatientInfo.DOB,'/',1);
  Day := piece(ThisPatientInfo.DOB,'/',2);     
  Year := piece(ThisPatientInfo.DOB,'/',3);
  tempPseudo := tempPseudo + Month + Day + Year + 'P';
  ThisPatientInfo.SSNum := tempPseudo;
  SSNumEdit.Text := ThisPatientInfo.SSNum;
  SSNumEditExit(nil);
end;

procedure TfrmPtAdd.DOBEditExit(Sender: TObject);
var
  s,s2: string;
  i:integer; boolInvalid: boolean;
begin
  boolInvalid := False;
  s2 := '';
  For i:=1 to 3 do begin
   s := piece(DobEdit.Text,'/',i);
   if ((i = 3) and (length(s) = 4)) then s := rightstr(s,2);      
   if length(s) = 1 then s := '0' + s;
   if s2 <> '' then s2 := s2 + '/';
   s2 := s2 + s;
   if length(s) <> 2 then boolInvalid := True;
  end;               

  if (boolInvalid = True) and (DOBEdit.Text<>'') then begin
    messagedlg('DOB format is invalid. Please enter it in mm/dd/yy format.',mtError,[mbOK],0);
    DOBEdit.text := '';
  end else begin
    DOBEdit.text := s2;  
  end;
end;

procedure TfrmPtAdd.SSNHelpBtnClick(Sender: TObject);
begin
  if MessageDlg('If Soc. Sec. Number (SSN) is unknown, a "Pseudo" SSN may be used.'+#10+#13+
                 'Create a Pseudo-SSN For this Patient?', 
                  mtConfirmation, [mbYes, mbNo],0) = mrYes then begin
    CreatePSSN;
  end else begin
    SSNumEdit.Text := '';
  end;
end;

end.

