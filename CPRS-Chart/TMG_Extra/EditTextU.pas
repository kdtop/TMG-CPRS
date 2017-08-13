unit EditTextU;
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


//kt 9/11 added  

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, StrUtils, ExtCtrls;

type
  TEditTextForm = class(TForm)
    Panel1: TPanel;
    Memo: TMemo;
    RevertBtn: TBitBtn;
    ApplyBtn: TBitBtn;
    DoneBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RevertBtnClick(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure DoneBtnClick(Sender: TObject);
    procedure MemoChange(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FCachedText : TStringList;
    FPosted : boolean;
    FChangesMade : boolean;
    FFileNum,FFieldNum,FIENS : String;
    function GetWPField(FileNum,FieldNum,IENS : string) : TStringList;
    procedure PostWPField(Lines: TStrings; FileNum,FieldNum,IENS : string);
  public
    { Public declarations }
    procedure PrepForm(FileNum,FieldNum,IENS : string);
    function GetPreviewText : string;
    property Posted : boolean read FPosted;
    property ChangesMade : boolean read FChangesMade;

  end;

//var
//  EditTextForm: TEditTextForm;

implementation

uses FMErrorU, ORNet, ORFn,
     rTMGRPCs, uTMGTypes,
     Trpcb ;  //needed for .ptype types

{$R *.dfm}

  procedure TEditTextForm.PrepForm(FileNum,FieldNum,IENS : string);
  begin
    FFileNum := FileNum;
    FFieldNum := FieldNum;
    FIENS := IENS;
    Memo.Lines.Clear;
    if Pos('+',IENS)=0 then begin
      Memo.Lines.Assign(GetWPField(FileNum,FieldNum,IENS));
    end;
    ApplyBtn.Enabled := false;
    RevertBtn.Enabled := false;
    FChangesMade := False;
  end;

  procedure TEditTextForm.FormCreate(Sender: TObject);
  begin
    FCachedText := TStringList.Create;

  end;

  procedure TEditTextForm.FormDestroy(Sender: TObject);
  begin
    FCachedText.Free;
  end;


  function TEditTextForm.GetWPField(FileNum,FieldNum,IENS : string) : TStringList;
  var   RPCResult: string;
        cmd : string;
        lastLine : string;
  begin
    FCachedText.clear;
    rTMGRPCs.GetWPField(FileNum, FieldNum, IENS, FCachedText);
    result := FCachedText;
  end;

  function TEditTextForm.GetPreviewText : string;
  begin
    PrepForm(FFileNum,FFieldNum,FIENS);
    Result := Memo.Lines.Text;
    Result := Trim(Result);
    Result := AnsiReplaceStr(Result, #10, '');
    Result := AnsiReplaceStr(Result, #13, '');
    if Result <> '' then begin
      Result := CLICK_TO_EDIT_TEXT + ':  ' + LeftStr(Result,20) + '...'
    end else begin
      Result := CLICK_TO_ADD_TEXT;
    end;
  end;




  procedure TEditTextForm.PostWPField(Lines: TStrings; FileNum,FieldNum,IENS : string);
  var   RPCResult: string;
        cmd : string;
        lastLine : string;
        i : integer;
  begin
    if rTMGRPCs.PostWPField(Lines, FileNum,FieldNum,IENS) then begin
      FCachedText.Assign(Lines);
      FPosted := true;
      FChangesMade := True;
    end;
  end;


  procedure TEditTextForm.RevertBtnClick(Sender: TObject);
  begin
    if MessageDlg('Abort editing changes and revert to original?',mtWarning,mbOKCancel,0) = mrOK then begin
      Memo.Lines.Assign(FCachedText);
    end;
  end;

  procedure TEditTextForm.ApplyBtnClick(Sender: TObject);
  begin
    if FCachedText.Text <> Memo.Lines.Text then begin
      //MessageDlg('Here I will post changes',mtInformation,[mbOK],0);
      PostWPField(Memo.Lines,FFileNum,FFieldNum,FIENS);     
    end;
    ApplyBtn.Enabled := false;
    RevertBtn.Enabled := false;
  end;

  procedure TEditTextForm.DoneBtnClick(Sender: TObject);
  begin
    ApplyBtnClick(self);
    ModalResult := mrOK;
  end;

  procedure TEditTextForm.MemoChange(Sender: TObject);
  begin
    ApplyBtn.Enabled := true;
    RevertBtn.Enabled := true;
  end;

  procedure TEditTextForm.FormHide(Sender: TObject);
  begin
    ApplyBtnClick(self);
  end;

  procedure TEditTextForm.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    ApplyBtnClick(self);
  end;

end.

