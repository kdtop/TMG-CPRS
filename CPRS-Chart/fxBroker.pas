unit fxBroker;

//kt 9/11 made changes to **FORM** of this unit

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DateUtils, ORNet, ORFn, rMisc, ComCtrls, Buttons, ExtCtrls,
  ORCtrls, ORSystem, fBase508Form, VA508AccessibilityManager;

type
  TfrmBroker = class(TfrmBase508Form)
    pnlTop: TORAutoPanel;
    lblMaxCalls: TLabel;
    txtMaxCalls: TCaptionEdit;
    cmdPrev: TBitBtn;
    cmdNext: TBitBtn;
    udMax: TUpDown;
    memData: TRichEdit;
    lblCallID: TStaticText;
    btnRLT: TButton;
    cboJumpTo: TComboBox;      //kt 9/11
    btnClear: TBitBtn;         //kt 9/11
    lblStoredCallsNum: TLabel; //kt 9/11
    btnFilter: TBitBtn;        //kt 9/11
    procedure btnFilterClick(Sender: TObject); //kt 9/11
    procedure btnClearClick(Sender: TObject);  //kt 9/11
    procedure cmdPrevClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnRLTClick(Sender: TObject);
    procedure cboJumpToDropDown(Sender: TObject);
    procedure cboJumpToChange(Sender: TObject);
  private
    { Private declarations }
    FRetained: Integer;
    FCurrent: Integer;
    procedure UpdateDisplay; //kt 9/11
  public
    { Public declarations }
  end;

procedure ShowBroker;

implementation

{$R *.DFM}

uses
  fMemoEdit;  //kt 9/11added

procedure ShowBroker;
var
  frmBroker: TfrmBroker;
begin
  frmBroker := TfrmBroker.Create(Application);
  try
    ResizeAnchoredFormToFont(frmBroker);
    with frmBroker do
    begin
      FRetained := RetainedRPCCount - 1;
      FCurrent := FRetained;
      UpdateDisplay; //kt
      { //kt 9/11 moved to UpdateDisplay
      LoadRPCData(memData.Lines, FCurrent);
      memData.SelStart := 0;
      lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
      }
      ShowModal;
    end;
  finally
    frmBroker.Release;
  end;
end;

procedure TfrmBroker.cmdPrevClick(Sender: TObject);
begin
  FCurrent := HigherOf(FCurrent - 1, 0);
  UpdateDisplay; //kt 9/11
  { //kt 9/11 moved to UpdateDisplay
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
  }
end;

procedure TfrmBroker.cmdNextClick(Sender: TObject);
begin
  FCurrent := LowerOf(FCurrent + 1, FRetained);
  UpdateDisplay; //kt 9/11
  { //kt 9/11 moved to UpdateDisplay
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
  }
end;

procedure TfrmBroker.UpdateDisplay; //kt 9/11 added
begin
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
end;

procedure TfrmBroker.cboJumpToDropDown(Sender: TObject);
//kt 9/11 added
var i : integer;
    s : string;
    Info : TStringList;   //Not owned here...
begin
  cboJumpTo.Items.Clear;
  for i := 0 to RetainedRPCCount - 1 do begin
    Info := AccessRPCData(i);
    if Info.Count < 2 then continue;
    s := Info.Strings[1];
    s := piece2(s,'Called at: ',2);
    s := s + ':  ' + Info.Strings[0];
    cboJumpTo.Items.Insert(0,s);
  end;
end;

procedure TfrmBroker.cboJumpToChange(Sender: TObject);
//kt 9/11 added
begin
  if cboJumpTo.Items.count > 0 then begin
    FCurrent := (cboJumpTo.Items.count-1) - cboJumpTo.ItemIndex;
    UpdateDisplay;
  end;
end;
procedure TfrmBroker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetRetainedRPCMax(StrToIntDef(txtMaxCalls.Text, 5))
end;

procedure TfrmBroker.FormResize(Sender: TObject);
begin
  Refresh;
end;

procedure TfrmBroker.FormCreate(Sender: TObject);
begin
  udMax.Position := GetRPCMax;
end;

procedure TfrmBroker.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfrmBroker.btnFilterClick(Sender: TObject);
//kt 9/11 added entire unit
var
  frmMemoEdit: TfrmMemoEdit;

begin
  inherited;
  frmMemoEdit := TfrmMemoEdit.Create(Self);
  frmMemoEdit.lblMessage.Caption := 'Add / Delete / Edit list of FILTERED RPC calls:';
  frmMemoEdit.memEdit.Lines.Assign(ORNet.FilteredRPCCalls);
  frmMemoEdit.ShowModal;
  ORNet.FilteredRPCCalls.Assign(frmMemoEdit.memEdit.Lines);
  frmMemoEdit.Free;
end;

procedure TfrmBroker.btnRLTClick(Sender: TObject);
var
  startTime, endTime: tDateTime;
  clientVer, serverVer, diffDisplay: string;
  theDiff: integer;
const
  TX_OPTION  = 'OR CPRS GUI CHART';
  disclaimer = 'NOTE: Strictly relative indicator:';
begin

clientVer := clientVersion(Application.ExeName); // Obtain before starting.

// Check time lapse between a standard RPC call:
startTime := now;
serverVer :=  serverVersion(TX_OPTION, clientVer);
endTime := now;
theDiff := milliSecondsBetween(endTime, startTime);
diffDisplay := intToStr(theDiff);

// Show the results:
infoBox('Lapsed time (milliseconds) = ' + diffDisplay + '.', disclaimer, MB_OK);
end;

procedure TfrmBroker.btnClearClick(Sender: TObject);
//kt 9/11 added
begin
  ORNet.RPCCallsClear;
  memData.Lines.Clear; //kt 4/15/10
  cboJumpTo.Text := '-- Select a call to jump to --';
  FCurrent := 0;
  FRetained := RetainedRPCCount - 1;
  cmdNextClick(Sender);
end;

end.
