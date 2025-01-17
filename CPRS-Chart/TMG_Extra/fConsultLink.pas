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
    function InternalLinkConsult(IEN8925: integer; CompleteConsult: boolean):string;
    procedure DoComplete(Complete: Boolean);
    procedure UpdateDisplay();
  public
    { Public declarations }
    TIUIEN : integer;
    ADFN : string;
    DeferredMode : boolean;
    DeferredConsultItemIEN : integer;
    DeferredConsultCompletionDesired : boolean;
  end;

//var
//  frmConsultLink: TfrmConsultLink;

//forwards
procedure LinkConsult(IEN8925: integer);
function DeferLinkConsult(IEN8925: integer;
                          ADFN : string;
                          var DeferredConsultItemIEN : integer;
                          var DeferredConsultCompletionDesired : boolean) : boolean;
procedure GetConsultsListEx(Dest: TStrings; Early, Late: double;
                            Service, Status: string; SortAscending: Boolean; ADFN : string);
function DoInternalLinkConsult(IEN8925 : integer; ConsultItemIEN : integer; CompleteConsult : boolean) : string;

implementation

{$R *.dfm}

uses fConsults, rConsults, uCore, uConsults, ORFn;

procedure LinkConsult(IEN8925: integer);
var
   //PendingConsultList : TStringList;
   //RPCResult : string;
   //Response : integer;
   //Messagetext: string;
   frmConsultLink: TfrmConsultLink;
begin
  Application.CreateForm(TfrmConsultLink, frmConsultLink);
  frmConsultLink.Caption := 'Link Note To Consult';
  frmConsultLink.TIUIEN := IEN8925;
  frmConsultLink.ADFN := Patient.DFN;
  frmConsultLink.DeferredMode := false;
  frmConsultLink.DeferredConsultItemIEN := 0;
  frmConsultLink.DeferredConsultCompletionDesired := false;
  frmConsultLink.ShowModal;
  frmConsultLink.Release;
end;

function DeferLinkConsult(IEN8925: integer;
                          ADFN : string;
                          var DeferredConsultItemIEN : integer;
                          var DeferredConsultCompletionDesired : boolean) : boolean;
//Result: if TRUE, then later use IEN8925 to complete DeferredConsultItemIEN
//The purpose of this function is for batch processing.  It allows the user to select
//  completion options but not actually complete them.  Then, the completion could
//  be done later if the entire batch is signed off appropriately.
//Initially this is called by fMultiTIUSign.
var
   frmConsultLink: TfrmConsultLink;
begin
  Result := false;
  frmConsultLink := TfrmConsultLink.Create(Application);
  frmConsultLink.Caption := 'Link Note To Consult';
  frmConsultLink.TIUIEN := IEN8925;
  frmConsultLink.ADFN := ADFN;
  frmConsultLink.DeferredMode := true;
  frmConsultLink.DeferredConsultItemIEN := 0;
  frmConsultLink.DeferredConsultCompletionDesired := false;
  Result := (frmConsultLink.ShowModal = mrOK);
  DeferredConsultItemIEN := frmConsultLink.DeferredConsultItemIEN;
  DeferredConsultCompletionDesired := frmConsultLink.DeferredConsultCompletionDesired;
  frmConsultLink.Free;
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
    RPCResult := InternalLinkConsult(TIUIEN, Complete);
    if Piece(RPCResult,'^',1)='-1' then begin
      ShowMsg(Piece(RPCResult,'^',2));
    end else begin
      if not DeferredMode then
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


procedure GetConsultsListEx(Dest: TStrings; Early, Late: double;
                            Service, Status: string; SortAscending: Boolean; ADFN : string);
{ returns a list of consults for a patient, based on selected dates, service, status, or ALL}

//Copied and modified from rConsults.GetConsultsList
var
  i: Integer;
  x, date1, date2: string;
begin
  if Early <= 0 then date1 := '' else date1 := FloatToStr(Early) ;
  if Late  <= 0 then date2 := '' else date2 := FloatToStr(Late)  ;
  //kt original --> CallV('ORQQCN LIST', [Patient.DFN, date1, date2, Service, Status]);
  CallV('ORQQCN LIST', [ADFN, date1, date2, Service, Status]);
  with RPCBrokerV do begin
    if Copy(Results[0],1,1) <> '<' then begin
      SortByPiece(TStringList(Results), U, 2);
      if not SortAscending then InvertStringList(TStringList(Results));
      //SetListFMDateTime('mmm dd,yy', TStringList(Results), U, 2);
      for i := 0 to Results.Count - 1 do begin
        x := MakeConsultListItem(Results[i]);
        Results[i] := x;
      end;
      FastAssign(Results, Dest);
    end else begin
      Dest.Clear ;
      Dest.Add('-1^No Matches') ;
    end ;
  end;
end;


procedure TfrmConsultLink.UpdateDisplay();
const
  SHOW_MODE : array [false..true] of string = ('5','');
begin
  GetConsultsListEx(PendingConsultList,0,0,'',SHOW_MODE[cbShowAll.Checked], FALSE, ADFN);  // <- 5 should be set as a constant
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

function TfrmConsultLink.InternalLinkConsult(IEN8925: integer; CompleteConsult: boolean): string;
begin
  if LBConsultList.ItemIEN < 0 then begin
    Result := '-1^No Consult Defined In frmConsultLink';
  end else if IEN8925 < 0 then begin
    Result := '-1^No Note Sent To frmConsultLink';
  end else begin
    if not Self.DeferredMode then begin
      Result := sCallV('TMG CPRS CONSULT LINK W TIU',[LBConsultList.ItemIEN, IEN8925, CompleteConsult]);
    end else begin
      Self.DeferredConsultItemIEN := LBConsultList.ItemIEN;
      Self.DeferredConsultCompletionDesired := CompleteConsult;
      Result := '1^OK';
    end;
  end;
end;

function DoInternalLinkConsult(IEN8925 : integer; ConsultItemIEN : integer; CompleteConsult : boolean) : string;
begin
  Result := sCallV('TMG CPRS CONSULT LINK W TIU',[ConsultItemIEN, IEN8925, CompleteConsult]);
end;

end.

