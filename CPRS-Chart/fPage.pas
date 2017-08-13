unit fPage;

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

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

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, uConst,
  rOrders, fBase508Form, VA508AccessibilityManager;

type
  TfrmPage = class(TfrmBase508Form)
    shpPageBottom: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDisplayCount: Integer;                      // number of times page displayed
    FPatientCount: Integer;                      // number of times page displayed for given pt
    FCallingContext: Integer;
    FOldEnter: TNotifyEvent;
    FPageID: integer;
    function GetInitPage: Boolean;
    function GetInitPatient: Boolean;
    function GetPatientViewed: Boolean;
  protected
    procedure Loaded; override;
    procedure frmPageEnter(Sender: TObject);
  public
    function AllowContextChange(var WhyNot: string): Boolean; virtual;
    procedure ContextChangeCancelled; virtual; //kt added
    procedure ClearPtData; virtual;
    procedure DisplayPage; virtual;
    procedure NotifyOrder(OrderAction: Integer; AnOrder: TOrder); virtual;
    procedure RequestPrint; virtual;
    procedure SetFontSize(NewFontSize: Integer); virtual;
    procedure FocusFirstControl;
    property CallingContext: Integer read FCallingContext;
    property InitPage: Boolean read GetInitPage;
    property InitPatient: Boolean read GetInitPatient;
    property PatientViewed: Boolean read GetPatientViewed;
    property PageID: integer read FPageID write FPageID default CT_UNKNOWN;
  end;

var
  frmPage: TfrmPage;

implementation

uses ORFn, fFrame, uInit, VA508AccessibilityRouter;

{$R *.DFM}

procedure TfrmPage.FormCreate(Sender: TObject);
{ set counters to 0 }
begin
  HelpFile := Application.HelpFile + '>' + HelpFile;
  FDisplayCount := 0;
  FPatientCount := 0;
  FOldEnter := OnEnter;
  OnEnter := frmPageEnter;
end;

procedure TfrmPage.Loaded;
{ make the form borderless to allow it to be a child window }
begin
  inherited Loaded;
  Visible := False;
  Position := poDefault;
  BorderIcons := [];
  BorderStyle := bsNone;
  HandleNeeded;
  SetBounds(0, 0, Width, Height);
end;

function TfrmPage.AllowContextChange(var WhyNot: string): Boolean;
begin
  Result := True;
end;

procedure TfrmPage.ContextChangeCancelled; //kt added 4/27/15
begin
  //to be overridded in decendents, to perform remedial action if needed.
end;

procedure TfrmPage.ClearPtData;
{ clear all patient related data on a page }
begin
  FPatientCount := 0;
end;

procedure TfrmPage.DisplayPage;
{ cause the page to be displayed and update the display counters }
begin
  BringToFront;
  if ActiveControl <> nil then
    FocusControl(ActiveControl);
 //CQ12232 else
//CQ12232   FocusFirstControl;
  //SetFocus;
  Inc(FDisplayCount);
  Inc(FPatientCount);
  FCallingContext := frmFrame.ChangeSource;
  if (FCallingContext = CC_CLICK) and (FPatientCount = 1)
    then FCallingContext := CC_INIT_PATIENT;
end;

procedure TfrmPage.NotifyOrder(OrderAction: Integer; AnOrder: TOrder);
begin
end;

procedure TfrmPage.RequestPrint;
begin
end;

procedure TfrmPage.SetFontSize(NewFontSize: Integer);
begin
  ResizeAnchoredFormToFont( self );
  if Assigned(Parent) then begin
    Width := Parent.ClientWidth;
    Height := Parent.ClientHeight;
  end;
  Resize;
end;

function TfrmPage.GetInitPage: Boolean;
{ if the count is one, this is the first time the page is being displayed }
begin
  Result := FDisplayCount = 1;
end;

function TfrmPage.GetInitPatient: Boolean;
{ if the count is one, this is the first time the page is being displayed for a given patient }
begin
  Result := FPatientCount = 1;
end;

function TfrmPage.GetPatientViewed: Boolean;
{ returns false if the tab has never been clicked for this patient }
begin
  Result := FPatientCount > 0;
end;

procedure TfrmPage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmPage.frmPageEnter(Sender: TObject);
begin
  if Assigned(frmFrame) then
    FrmFrame.tabPage.TabIndex := FrmFrame.PageIDToTab(PageID);
  if Assigned(FOldEnter) then
    FOldEnter(Sender);
end;

procedure TfrmPage.FocusFirstControl;
var
  NextControl: TWinControl;
begin
  if Assigned(frmFrame) and frmFrame.Enabled and frmFrame.Visible and not uInit.Timedout then begin
    NextControl := FindNextControl(nil, True, True, False);
    if NextControl <> nil then
      NextControl.SetFocus;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmPage);

end.
