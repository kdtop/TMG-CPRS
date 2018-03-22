unit fWebTab;
//kt 9/11 Added entire unit and form.
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
  Dialogs, OleCtrls, SHDocVw, StdCtrls,fPage, VA508AccessibilityManager, ExtCtrls, uCore,
  uTMGAllscriptsDriver, TMGHtml2, Menus, uTMGDiffRecord, uHTMLTools;

type
  TfrmWebTab = class(TfrmPage)
    pnlWBHolder: TPanel;
    mnuMain: TMainMenu;
    Action1: TMenuItem;
    mnuViewHTMLSource: TMenuItem;
    mnuToggleRecordHTML_DOMs: TMenuItem;
    TimerRecordDOM: TTimer;
    procedure mnuToggleRecordHTML_DOMsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerRecordDOMTimer(Sender: TObject);
    procedure mnuViewHTMLSourceClick(Sender: TObject);
    //WebBrowser: TWebBrowser;  //kt 8/5/17
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    DiffRecorder : TDiffRecorder;
  public
    { Public declarations }
    LastURL : string;
    WebBrowser : THtmlObj; //kt 8/5/17
    Procedure RequestPrint; override;
    Procedure NagivateTo(URL: Widestring);
  end;

function AskServerForURLs(URLList : TStringList) : string;

var
  WebTabsList: TList;

  TMG_URL_RPC_Available : boolean;
  TMG_URL_RPC_Checked : boolean;

implementation

{$R *.dfm}
uses ORNet,ORFn,Trpcb,uConst,
     fMemoEdit;


Procedure TfrmWebTab.RequestPrint;
begin
  inherited;
  MessageDlg('Finish code: request printing from web browser...',mtInformation,[mbOK],0);
end;


procedure TfrmWebTab.mnuToggleRecordHTML_DOMsClick(Sender: TObject);
const
  RECORDING_TAG=1;     RECORDING_MENU_TEXT = '&Stop Recording HTML DOM''s';
  NOT_RECORDING_TAG=0; NOT_RECORDING_MENU_TEXT = 'Recording HTML &DOM''s';
begin
  inherited;
  case mnuToggleRecordHTML_DOMs.Tag of
    RECORDING_TAG : begin
      mnuToggleRecordHTML_DOMs.Tag := NOT_RECORDING_TAG;
      mnuToggleRecordHTML_DOMs.Caption := NOT_RECORDING_MENU_TEXT;
      TimerRecordDom.Enabled := False;
    end;
    NOT_RECORDING_TAG : begin
      mnuToggleRecordHTML_DOMs.Tag := RECORDING_TAG;
      mnuToggleRecordHTML_DOMs.Caption := RECORDING_MENU_TEXT;
      TimerRecordDom.Enabled := True;
    end;
  end; //case
end;

procedure TfrmWebTab.TimerRecordDOMTimer(Sender: TObject);
var SL : TStringList;
const SAVE_TO_DISK = true;
begin
  inherited;
  TimerRecordDOM.Enabled := false;
  DiffRecorder.MakeSnapshot(SAVE_TO_DISK);  //handle recording DOM.
  TimerRecordDOM.Enabled := True;
end;

procedure TfrmWebTab.mnuViewHTMLSourceClick(Sender: TObject);
var HTMLText : string;
    frmView : TfrmMemoEdit;
begin
  inherited;
  try
    HTMLText := WebBrowser.GetFullHTMLText;
    frmView := TfrmMemoEdit.Create(self);
    frmView.memEdit.ReadOnly := false;
    frmView.memEdit.ScrollBars := ssBoth;
    frmView.memEdit.Lines.Text := HTMLText;
    frmView.Caption := 'Note Details';
    frmView.lblMessage.Caption := 'Source code of note.';
    frmView.ShowModal;
  finally
    frmView.Free;
  end;
end;

procedure TfrmWebTab.FormCreate(Sender: TObject);
begin
  inherited;
  WebBrowser := THtmlObj.Create(pnlWBHolder,Application);
  TWinControl(WebBrowser).Parent:=pnlWBHolder;
  TWinControl(WebBrowser).Align:=alClient;
  WebBrowser.Silent := false; //should prevent page popups....
  DiffRecorder := TDiffRecorder.Create(WebBrowser, CPRSDir+'\Cache\');
end;

procedure TfrmWebTab.FormDestroy(Sender: TObject);
begin
  DiffRecorder.Free;
  WebBrowser.Free;
  inherited;
end;

Procedure TfrmWebTab.NagivateTo(URL: WideString);
begin
  LastURL := URL;
  //if pos('allscripts',URL)>1 then begin  //Handle AllScripts ERx in special manner.
  //  AllScriptsSyncToPatient(WebBrowser, URL, Patient);
  //end else begin
    WebBrowser.Navigate(URL);
  //end;
end;

//=================================================================
//===== Globally available functions, not part of object ==========
//=================================================================

function AskServerForURLs(URLList : TStringList) : string;
//Get URL list from server.
//URLList is filled with RPCBroker.Results.  Should have this format:
//     URLList(0)='1^Success' pr '0^Failure'
//     URLList(1)="URL#1"  a URL to display in tab 1
//     URLList(2)="URL#2"  a URL to display in tab 2
//     URLList(3)="URL#3"  a URL to display in tab 3
//  Note: if URL='<!HIDE!>' then server is requesting tab to be hidden
//Results of Fn: Returns '1^Success' if success, or '0^ErrorMessage'
var
    RPCResult              : AnsiString;
    i                      : integer;
begin
  if TMG_URL_RPC_Checked = false then begin
    RPCBrokerV.remoteprocedure := 'XWB IS RPC AVAILABLE';
    RPCBrokerV.Param[0].Value := 'TMG CPRS GET URL LIST';
    RPCBrokerV.Param[0].ptype := literal;
    RPCBrokerV.Param[1].Value := 'R';
    RPCBrokerV.Param[1].ptype := literal;
    RPCResult := RPCBrokerV.StrCall;   {returns 1 if available, 0 if not available}
    TMG_URL_RPC_Checked := true;
    TMG_URL_RPC_Available := (RPCResult='1');
  end;

  if TMG_URL_RPC_Available= true then begin
    if (URLList <> nil) then begin
      RPCBrokerV.remoteprocedure := 'TMG CPRS GET URL LIST';
      RPCBrokerV.Param[0].Value := Patient.DFN;
      RPCBrokerV.Param[0].ptype := literal;
      //RPCBrokerV.Call;
      CallBroker;
      URLList.Assign(RPCBrokerV.Results);
      if RPCBrokerV.Results.Count>0 then Result := RPCBrokerV.Results.Strings[0]
      else Result := '-1^Error: No URL''s returned from server.';
    end else begin
      Result := '0^Invalid TStringList URLList passed';
    end;
  end else begin
    Result := '-1^"TMG CPRS GET URL LIST" RPC Not available on server';
  end;
end;


initialization
  TMG_URL_RPC_Available := false;  //default to not avail.
  TMG_URL_RPC_Checked := false;   //default to not checked.
  WebTabsList := TList.Create;
  WebTabsList.Count := CT_LAST_WEBTAB-CT_WEBTAB1+1;   //fill up list with nil pointers
finalization
  WebTabsList.Free;
end.

