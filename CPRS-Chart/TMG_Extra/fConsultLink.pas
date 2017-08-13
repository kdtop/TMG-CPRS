unit fConsultLink;
//TMG added entire unit
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
  Dialogs, StdCtrls, ORCtrls, Buttons, VAUtils, ORNet;

type
  TfrmConsultLink = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    LBConsultList: TORListBox;
    Label1: TLabel;
    cbShowAll: TCheckBox;
    btnLinkOnlyOK: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure cbShowAllClick(Sender: TObject);
    procedure btnLinkOnlyOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LBConsultListChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    PendingConsultList : TStringList;
    function InternalLinkConsult(IEN8925: integer;CompleteConsult:boolean):string;
    procedure DoComplete(Complete: Boolean);
    procedure UpdateDisplay();
  public
    { Public declarations }
    TIUIEN : integer;
  end;

//var
//  frmConsultLink: TfrmConsultLink;

procedure LinkConsult(IEN8925: integer);  //forward

implementation

{$R *.dfm}

uses fConsults,rConsults;

procedure LinkConsult(IEN8925: integer);
var
   PendingConsultList : TStringList;
   RPCResult : string;
   Response : integer;
   Messagetext: string;
   frmConsultLink: TfrmConsultLink;
begin
  Application.CreateForm(TfrmConsultLink, frmConsultLink);
  frmConsultLink.Caption := 'Link Note To Consult';
  frmConsultLink.TIUIEN := IEN8925;
  frmConsultLink.ShowModal;
  frmConsultLink.Release;
end;

procedure TfrmConsultLink.DoComplete(Complete: Boolean);
var
   ConsultTempText : string;
   MessageText : string;
   Response : integer;
   RPCResult : string;
   ConsultText : string;

begin
  ConsultTempText := LBConsultList.Items[LBConsultList.ItemIndex];
  ConsultText := Piece(ConsultTempText,'^',2)+' - '+Piece(ConsultTempText,'^',4);

  if Complete then
    MessageText := #13#10+'and complete the consult?'
  else
    MessageText := '?';
  Response := MessageDlg('Are you sure you want to link this note with '+ConsultText
                         +MessageText,mtConfirmation,[mbOK,mbCancel],0);
  if Response = mrOk then begin
    RPCResult := InternalLinkConsult(TIUIEN,Complete);
    if Piece(RPCResult,'^',1)='-1' then begin
      ShowMsg(Piece(RPCResult,'^',2));
    end else begin
      frmConsults.UpdateList;
    end;
  end;
end;


procedure TfrmConsultLink.btnLinkOnlyOKClick(Sender: TObject);
begin
  DoComplete(false);
end;

procedure TfrmConsultLink.btnOKClick(Sender: TObject);
begin
  DoComplete(true);
end;

procedure TfrmConsultLink.cbShowAllClick(Sender: TObject);
begin
  UpdateDisplay();
end;

procedure TfrmConsultLink.UpdateDisplay();
const
  SHOW_MODE : array [false..true] of string = ('5','');
begin
  GetConsultsList(PendingConsultList,0,0,'',SHOW_MODE[cbShowAll.Checked], FALSE);  // <- 5 should be set as a constant
  if (PendingConsultList.Count<1) AND (NOT cbShowAll.Checked) then begin
    cbShowAll.Checked := True;
  end else begin
    LBConsultList.Items.Assign(PendingConsultList);
  end;
end;


procedure TfrmConsultLink.FormCreate(Sender: TObject);
begin
  PendingConsultList := TStringList.Create;
end;

procedure TfrmConsultLink.FormDestroy(Sender: TObject);
begin
  PendingConsultList.Free;
end;

procedure TfrmConsultLink.FormShow(Sender: TObject);
begin
  UpdateDisplay();
end;

procedure TfrmConsultLink.LBConsultListChange(Sender: TObject);
var
  Enabled : boolean;
begin
  Enabled := (LBConsultList.ItemIEN > 0);
  btnLinkOnlyOK.Enabled := Enabled;
  btnOK.Enabled := (Enabled AND (pos('(p)',LBConsultList.Items[LBConsultList.ItemIndex])>0));
end;

function TfrmConsultLink.InternalLinkConsult(IEN8925: integer;CompleteConsult:boolean):string;
begin
  if LBConsultList.ItemIEN < 0 then begin
    Result := '-1^No Consult Defined In frmConsultLink';
  end else if IEN8925 < 0 then begin
    Result := '-1^No Note Sent To frmConsultLink';
  end else begin
    Result := sCallV('TMG CPRS CONSULT LINK W TIU',[LBConsultList.ItemIEN,IEN8925,CompleteConsult]);
  end;
end;

end.

