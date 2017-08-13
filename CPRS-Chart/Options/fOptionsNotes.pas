unit fOptionsNotes;

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

(*  //kt 9/11 The following items were added to the **FORM** of this unit.
  object lblHTMLViewSize: TLabel [3]
    Left = 8
    Top = 144
    Width = 159
    Height = 13
    Caption = 'Formatted Text (HTML) View Size'
  end
  object cboHTMLViewSize: TComboBox [10]
    Left = 8
    Top = 162
    Width = 153
    Height = 21
    ItemHeight = 13
    TabOrder = 6
    Text = '<View Size>'
    OnClick = cboHTMLViewSizeClick
    Items.Strings = (
      'Smallest'
      'Small'
      'Medium'
      'Large'
      'Largest')
  end
  object cbDefaultHTMLMode: TCheckBox [11]
    Left = 8
    Top = 121
    Width = 225
    Height = 17
    Caption = 'Start notes in Formatted (HTML) Mode'
    TabOrder = 7
    OnClick = cbDefaultHTMLModeClick
  end
*)

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, ORFn, ComCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOptionsNotes = class(TfrmBase508Form)
    lblAutoSave1: TLabel;
    lblCosigner: TLabel;
    txtAutoSave: TCaptionEdit;
    spnAutoSave: TUpDown;
    chkVerifyNote: TCheckBox;
    chkAskSubject: TCheckBox;
    cboCosigner: TORComboBox;
    pnlBottom: TPanel;
    bvlBottom: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    lblAutoSave2: TLabel;
    cboHTMLViewSize: TComboBox;   //kt 9/11
    lblHTMLViewSize: TLabel;      //kt 9/11
    cbDefaultHTMLMode: TCheckBox; //kt 9/11
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure txtAutoSaveChange(Sender: TObject);
    procedure txtAutoSaveKeyPress(Sender: TObject; var Key: Char);
    procedure txtAutoSaveExit(Sender: TObject);
    procedure spnAutoSaveClick(Sender: TObject; Button: TUDBtnType);
    procedure cboCosignerNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboCosignerExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);              //kt 9/11
    procedure cbDefaultHTMLModeClick(Sender: TObject);  //kt 9/11
    procedure cboHTMLViewSizeChange(Sender: TObject);   //kt 9/11
  private
    FStartingCosigner: Int64;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptionsNotes: TfrmOptionsNotes;
  DefaultEditHTMLMode : boolean;   //kt 9/11
  FHTMLEditTextSize   : integer;   //kt 9/11

procedure DialogOptionsNotes(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
procedure SetDefaultEditHTMLMode(Value : boolean);  //kt 9/11
procedure Loaded;                                   //kt 9/11

implementation

{$R *.DFM}

uses
  uCore,    //kt 9/11
  Registry, //kt 9/11
  uTMGOptions, //kt 9/11
  uTemplates, //kt 9/11
  rOptions, uOptions, rCore, rTIU, rDCSumm;

const
  DEFAULT_HTML_EDIT_MODE = 'Edit-in-HTML default mode';       //kt 9/11
  DEFAULT_HTML_TEXT_SIZE = 'Edit-in-HTML default text size';  //kt 9/11

procedure SetRegHTMLViewSize(Size : integer); forward;        //kt 9/11

procedure DialogOptionsNotes(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsNotes: TfrmOptionsNotes;
begin
  frmOptionsNotes := TfrmOptionsNotes.Create(Application);
  actiontype := 0;
  try
    with frmOptionsNotes do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsNotes);
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsNotes.Release;
  end;
end;

procedure TfrmOptionsNotes.FormShow(Sender: TObject);
// displays defaults
// opening tab^use last tab^autosave seconds^verify note title
var
  autosave, verify: integer;
  cosigner: Int64;
  values, cosignername: string;
begin
  values := rpcGetOther;
  autosave := strtointdef(Piece(values, '^', 3), -1);
  verify := strtointdef(Piece(values, '^', 4), 0);
  chkVerifyNote.Checked := verify = 1;
  chkVerifyNote.Tag := verify;
  spnAutoSave.Position := autosave;
  spnAutoSave.Tag := autosave;

  values := rpcGetDefaultCosigner;
  cosigner := strtoint64def(Piece(values, '^', 1), 0);
  cosignername := Piece(values, '^', 2);
  cboCosigner.Items.Add('0^<none>');
  cboCosigner.InitLongList(cosignername);
  cboCosigner.SelectByIEN(cosigner);
  FStartingCosigner := cosigner;
  chkAskSubject.Checked := rpcGetSubject;
  if chkAskSubject.Checked then chkAskSubject.Tag := 1;
  cbDefaultHTMLMode.Checked := DefaultEditHTMLMode; //kt 9/11
end;

procedure TfrmOptionsNotes.btnOKClick(Sender: TObject);
// only saves values if they have been changed
// opening tab^use last tab^autosave seconds^verify note title
var
  values: string;
begin
  values := '';
  values := values + '^';
  values := values + '^';
  if spnAutoSave.Position <> spnAutoSave.Tag then
    values := values + inttostr(spnAutoSave.Position);
  values := values + '^';
  if chkVerifyNote.Checked then
    if chkVerifyNote.Tag <> 1 then
      values := values + '1';
  if not chkVerifyNote.Checked then
    if chkVerifyNote.Tag <> 0 then
      values := values + '0';
  rpcSetOther(values);
  with chkAskSubject do
  if (Checked and (Tag = 0)) or (not Checked and (Tag = 1)) then
    rpcSetSubject(Checked);
  with cboCosigner do
    if FStartingCosigner <> ItemIEN then
      rpcSetDefaultCosigner(ItemIEN);
  ResetTIUPreferences;
  ResetDCSummPreferences;
end;

procedure TfrmOptionsNotes.txtAutoSaveChange(Sender: TObject);
var
  maxvalue: integer;
begin
  maxvalue := spnAutoSave.Max;
  with txtAutoSave do
  begin
    if strtointdef(Text, maxvalue) > maxvalue then
    begin
      beep;
      InfoBox('Number must be < ' + inttostr(maxvalue), 'Warning', MB_OK or MB_ICONWARNING);
      if strtointdef(Text, 0) > maxvalue then
        Text := inttostr(maxvalue);
    end;
  end;
  spnAutoSaveClick(self, btNext);
end;

procedure TfrmOptionsNotes.txtAutoSaveKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
  if not (Key in ['0'..'9', #8]) then
  begin
    Key := #0;
    beep;
  end;  
end;

procedure TfrmOptionsNotes.txtAutoSaveExit(Sender: TObject);
begin
  with txtAutoSave do
  begin
    if Text = '' then
    begin
      Text := '0';
      spnAutoSaveClick(self, btNext);
    end
    else if (Copy(Text, 1, 1) = '0') and (length(Text) > 1) then
    begin
      Text := inttostr(strtointdef(Text, 0));
      spnAutoSaveClick(self, btNext);
    end;
  end;
end;

procedure TfrmOptionsNotes.spnAutoSaveClick(Sender: TObject;
  Button: TUDBtnType);
begin
  txtAutoSave.SetFocus;
  txtAutoSave.Tag := strtointdef(txtAutoSave.Text, 0);
end;

procedure TfrmOptionsNotes.cboCosignerNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  cboCosigner.ForDataUse(rpcGetCosigners(StartFrom, Direction));
end;

procedure TfrmOptionsNotes.cboCosignerExit(Sender: TObject);
begin
  with cboCosigner do
  if (Text = '') or (ItemIndex = -1) then
  begin
    ItemIndex := 0;
    Text := DisplayText[0];
  end;
end;

procedure SetRegHTMLViewSize(Size : integer);
//kt 9/11 added
//NOTE: The only way to affect the view size of the HTML renderer (IE) is to
//      change a system-wide setting in the registry.  Then CPRS has to be
//      restarted for changes to take effect.
var
  FontSizeData : array[0..3] of byte;
  ZoomReg      : TRegistry;
begin
  if (Size < 0) or (Size > 255) then exit;
  ZoomReg := TRegistry.Create;
  FontSizeData[0] := Lo(Size); FontSizeData[1] := 0; FontSizeData[2] := 0; FontSizeData[3] := 0;
  try
    ZoomReg.Rootkey := HKEY_CURRENT_USER;
    if ZoomReg.OpenKey('\Software\Microsoft\Internet Explorer\International\Scripts\3', False) then begin
      ZoomReg.WriteBinaryData('IEFontSize',FontSizeData,SizeOf(FontSizeData));
  end;
  finally
    ZoomReg.Free;
  end;
end;


procedure SetDefaultEditHTMLMode(Value : boolean);
//kt 9/11 added
begin
  if Value <> DefaultEditHTMLMode then begin
    uTMGOptions.WriteBool(DEFAULT_HTML_EDIT_MODE,Value);
    DefaultEditHTMLMode := Value;
  end;
  //uTemplates.UsingHTMLMode := Value;    //test line  //elh 1/22/10
end;


procedure TfrmOptionsNotes.cbDefaultHTMLModeClick(Sender: TObject);
//kt 9/11 added
begin
  SetDefaultEditHTMLMode(cbDefaultHTMLMode.Checked);
end;


procedure TfrmOptionsNotes.cboHTMLViewSizeChange(Sender: TObject);
//kt 9/11
begin
  SetRegHTMLViewSize(cboHTMLViewSize.ItemIndex);
  uTMGOptions.WriteInteger(DEFAULT_HTML_TEXT_SIZE,cboHTMLViewSize.ItemIndex);
  MessageDlg('Formated text size change will take '+#10+#13+
             'effect next time CPRS is restarted.',mtInformation,[mbOK],0);
end;


procedure TfrmOptionsNotes.FormCreate(Sender: TObject);
//kt 9/11 added
//NOTE: form is not created until first time needed.
begin
  //NOTE: FHTMLEditTextSize is set in Loaded function (has to be called after sign on (so User.Name is available)
  if (FHTMLEditTextSize > -1) and (FHTMLEditTextSize < cboHTMLViewSize.Items.Count) then begin
    cboHTMLViewSize.ItemIndex := FHTMLEditTextSize;
    cboHTMLViewSize.Text := cboHTMLViewSize.Items[FHTMLEditTextSize];
    SetRegHTMLViewSize(cboHTMLViewSize.ItemIndex);
  end;
end;

procedure Loaded;
//kt 9/11 added
begin
  //Code was put in global access space because object is not instantiated until
  //after user shows options (which could be never)
//if Trim(ParamSearch('SpecLoc'))='1' then
//  DefaultEditHTMLMode := True
//else
  DefaultEditHTMLMode := uTMGOptions.ReadBool(DEFAULT_HTML_EDIT_MODE,false);

//{$IFDEF INTRACARE}
//  DefaultEditHTMLMode := True;
//{$ELSE}
//  DefaultEditHTMLMode := uTMGOptions.ReadBool(DEFAULT_HTML_EDIT_MODE,false);
//{$ENDIF}

  //uTemplates.UsingHTMLMode := DefaultEditHTMLMode;
  FHTMLEditTextSize := uTMGOptions.ReadInteger(DEFAULT_HTML_TEXT_SIZE,2);
  SetRegHTMLViewSize(FHTMLEditTextSize);
end;




end.
