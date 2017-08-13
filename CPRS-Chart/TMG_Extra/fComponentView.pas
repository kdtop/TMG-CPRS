unit fComponentView;
//kt added entire unit  5/15
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
  Dialogs, StdCtrls, Buttons, ExtCtrls, uCore, ORFn, rTIU,
  TMGHTML2, uHTMLTools;

type
  TfrmComponentView = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    btnDone: TBitBtn;
    btnPrev: TBitBtn;
    btnNext: TBitBtn;
    pnlMain: TPanel;
    lblPtName: TLabel;
    lblPtSex: TLabel;
    lblPtSSN: TLabel;
    lblDocDate: TLabel;
    lblDocAuthor: TLabel;
    lblDocSubject: TLabel;
    btnCombinedView: TBitBtn;
    procedure btnCombinedViewClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ViewIdx : integer;
    ListComps : TStringList;
    HtmlViewer : THtmlObj; //kt 8/09
    procedure SetButtonEnabledState;
    procedure ShowDocumentInViewer(SL: TStringList);
    procedure ShowDocumentIndex(Index : integer);
    procedure EnsureDocLoaded(Index : integer);
  public
    { Public declarations }
    OnDestroy : TNotifyEvent;
    procedure Initialize(Patient: TPatient; SL : TStringList; Index : integer);
  end;

//var
//  frmComponentView: TfrmComponentView;

implementation

{$R *.dfm}

procedure TfrmComponentView.ShowDocumentInViewer(SL : TStringList);
var HTMLText : String;
begin
  if assigned(SL) then HTMLText := SL.Text else HTMLText := '';
  HtmlViewer.HTMLText := HTMLText;
  HtmlViewer.Editable := false;
  HtmlViewer.BackgroundColor := clCream;
  HtmlViewer.TabStop := true;
  RedrawActivate(HtmlViewer.Handle);
end;

procedure TfrmComponentView.EnsureDocLoaded(Index : integer);
var DataStr : string;
    strIEN  : string;
    IEN     : Int64;
    SL      : TStringList;
    HTMLText : String;
begin
  if (Index < 0) or (Index >= ListComps.Count) then exit;
  DataStr := ListComps.Strings[Index];
  SL := TStringList(ListComps.Objects[Index]);
  if assigned(SL) then exit;
  SL := TStringList.Create;
  ListComps.Objects[Index] := SL;
  strIEN := Piece(DataStr, '^', 2);
  IEN := StrToInt64Def(strIEN, 0);
  if IEN <= 0 then exit;
  LoadDocumentText(SL, IEN);
  if not IsHTML(SL) Then Begin
    SL.Text := Text2HTML(SL);
  end else begin
    FixHTML(SL);
  end;
end;


procedure TfrmComponentView.ShowDocumentIndex(Index : integer);
var DataStr : string;
    strIEN  : string;
    IEN     : Int64;
    SL      : TStringList;
    HTMLText : String;
begin
  if (Index >= 0) and (Index < ListComps.Count) then begin
    DataStr := ListComps.Strings[Index];
    EnsureDocLoaded(Index);
    SL := TStringList(ListComps.Objects[Index]);
  end else begin
    DataStr := '';
    SL := nil;
  end;
  lblDocDate.Caption := Piece(DataStr, '^', 3);
  lblDocAuthor.Caption := Piece(DataStr, '^', 4);
  lblDocSubject.Caption := Piece(DataStr, '^', 5);
  ShowDocumentInViewer(SL);
end;

procedure TfrmComponentView.btnCombinedViewClick(Sender: TObject);
var i : integer;
    CombinedSL : TStringList;
    SL : TStringList;
    Text : string;
begin
  Text := '';
  CombinedSL := TStringList.Create;
  for i := 0 to ListComps.Count - 1 do begin
    if Text  <> '' then Text := Text + '<HR>';
    EnsureDocLoaded(i);
    SL := TStringList(ListComps.Objects[i]);
    Text := Text + SL.Text;
  end;
  CombinedSL.Text := Text;
  FixHTML(CombinedSL);
  ShowDocumentInViewer(CombinedSL);
  lblDocDate.Caption := '';
  lblDocAuthor.Caption := '';
  lblDocSubject.Caption := '';
  CombinedSL.Free;
end;

procedure TfrmComponentView.btnDoneClick(Sender: TObject);
begin
  Self.Release;
end;

procedure TfrmComponentView.btnNextClick(Sender: TObject);
begin
  if ViewIdx >= ListComps.Count - 1 then exit;
  inc(ViewIdx);
  SetButtonEnabledState;
  ShowDocumentIndex(ViewIdx);
end;

procedure TfrmComponentView.btnPrevClick(Sender: TObject);
begin
  if ViewIdx <= 0 then exit;
  dec(ViewIdx);
  SetButtonEnabledState;
  ShowDocumentIndex(ViewIdx);
end;

procedure TfrmComponentView.FormCreate(Sender: TObject);
begin
  HtmlViewer := THtmlObj.Create(pnlMain, Application);
  TWinControl(HtmlViewer).Parent := pnlMain;
  TWinControl(HtmlViewer).Align := alClient;
  //Note: A 'loaded' function will initialize the THtmlObj's, but it can't be
  //      done until after this constructor is done, and this TfrmNotes has been
  //      assigned a parent.  So done elsewhere, in FormShow().
  ListComps := TStringList.Create;
end;

procedure TfrmComponentView.FormDestroy(Sender: TObject);
var i : integer;
    TempSL : TStringList;
begin
  HtmlViewer.Free;
  for i := 0 to ListComps.Count - 1 do begin
    TempSL := TStringList(ListComps.Objects[i]);
    TempSL.Free;
  end;
  ListComps.Free;
  if assigned(OnDestroy) then OnDestroy(Self);
end;

procedure TfrmComponentView.FormHide(Sender: TObject);
begin
  Self.Release;
end;

procedure TfrmComponentView.FormShow(Sender: TObject);
begin
  HTMLViewer.Loaded;
  ShowDocumentIndex(ViewIdx);  //for some reason, the first show is ignored! So must repeat.
  ShowDocumentIndex(ViewIdx);
end;

procedure TfrmComponentView.SetButtonEnabledState;
begin
  btnPrev.Enabled := (ViewIdx > 0);
  btnNext.Enabled := ((ListComps.Count > 0) and (ViewIdx < (ListComps.Count-1)));
end;

procedure TfrmComponentView.Initialize(Patient: TPatient; SL : TStringList; Index : integer);
//Input: Expected format for SL is:
//  SL.strings[i] = 'InternalFMDate^IEN8925^External Date^Author Name^Subject
begin
  ListComps.Assign(SL);
  ViewIdx := Index;
  if ViewIdx > ListComps.Count-1 then ViewIdx := -1;
  SetButtonEnabledState;
  lblPtName.Caption := Patient.Name;
  lblPtSex.Caption := 'Sex: ' + Patient.Sex;
  lblPtSSN.Caption := 'ID: ' + Patient.SSN;
end;


end.

