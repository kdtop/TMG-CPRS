unit fPtQuery;
//kt 9/11 added entire unit.
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
  Dialogs, StdCtrls, Buttons, ExtCtrls,ORNet, ORFn,ComCtrls,Trpcb, ORCtrls,
  uLogic, ImgList
  ;

type
  TfrmPtQuery = class(TForm)
    sbContainer: TScrollBox;
    lblField: TLabel;
    lblOperator: TLabel;
    lblValue: TLabel;
    pnlBottom: TPanel;
    lblFile: TLabel;
    edtSearchString: TEdit;
    pnlTop: TPanel;
    lblSearchForEntryInFile: TLabel;
    lblFileName: TLabel;
    btnCancel: TBitBtn;
    btnLaunchSearch: TBitBtn;
    imgSearch: TImage;
    GlyphImageList: TImageList;
    TabControl: TTabControl;
    lblAdvancedMode: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnLaunchSearchClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    LogicSet : TLogicSet;
    FLastJobNumber : string;
    SearchFileName : string;
    SearchFileNumber: String;
    FSelectedIEN, FSelectedName : String;
    procedure RetrieveResults(JobNumber: string; FldNum : string='');
    function LaunchSearch(SearchString : string) : string;
    function ClearLastSearch(JobNumber : string) : boolean;
  public
    { Public declarations }
    Function ConnectToRPCBroker : boolean;
    procedure InitializeForm(FileName : string; FileNumber: integer);
    property SelectedIEN : String read FSelectedIEN;
    property SelectedName : String read FSelectedName;
  end;

//var
//  frmPtQuery: TfrmPtQuery;

implementation

{$R *.dfm}

uses
   fRPCResult, fTMGServerSearch, fSearchResults;

const
   RPC_CONTEXT = 'TMG RPC CONTEXT TEMP';

(***********************************************************************)
(***********************************************************************)

  function TfrmPtQuery.ConnectToRPCBroker : boolean;
  //Returns if login succeeded.
  //Used for stand-alone application
  begin
    Result := true;
    if not ORNet.ConnectToServer(RPC_CONTEXT) then begin
      Messagedlg('Login Failed.',mtError,[mbOK],0);
      Result := false;
    end;
  end;

  procedure TfrmPtQuery.InitializeForm(FileName : string; FileNumber: integer);
  begin
    SearchFileName := FileName;
    SearchFileNumber := IntToStr(FileNumber);
    lblFileName.Caption := SearchFileName;
  end;

  procedure TfrmPtQuery.FormShow(Sender: TObject);
  begin
    LogicSet.Clear;
    LogicSet.SetFile(SearchFileNumber, SearchFileName);
    TabControl.TabIndex := 0;
    TabControlChange(Self);
  end;

  function TfrmPtQuery.ClearLastSearch(JobNumber : string) : boolean;
  //Returns TRUE if OK, or FALSE if problem.
  var
    cmd, RPCResult : string;
  begin
    Result := True;
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';
    RPCBrokerV.param[0].ptype := list;
    cmd := 'CLEAR';
    cmd := cmd + '^' + JobNumber;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    //RPCBrokerV.Call;
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then begin
      RPCResult := RPCBrokerV.Results[0]
    end else RPCResult := '';
    if piece(RPCBrokerV.Results[0],'^',1) = '-1' then begin
      MessageDlg('Error: ' + piece(RPCBrokerV.Results[0],'^',2),mtError,[mbOK],0);
      Result := false;
    end;
  end;


  function TfrmPtQuery.LaunchSearch(SearchString : string) : string;
  var
    cmd, RPCResult : string;
  begin
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';
    RPCBrokerV.param[0].ptype := list;
    cmd := 'LAUNCH';
    cmd := cmd + '^' + SearchFileNumber + '^' + SearchString;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then begin
      RPCResult := RPCBrokerV.Results[0]
    end else RPCResult := '';
    if piece(RPCBrokerV.Results[0],'^',1) = '1' then begin
      Result := piece(RPCBrokerV.Results[0],'^',2);
    end else begin
      MessageDlg('Search failed.',mtError,[mbOK],0);
      Result := '';
    end;
  end;

  procedure TfrmPtQuery.RetrieveResults(JobNumber, FldNum : string);
  //Get job results
  var
   tempStr, cmd : string;
   i : integer;
  begin
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.param[0].ptype := list;
    RPCBrokerV.Param[0].Value := '.X';
    cmd := 'RESULTS';
    cmd := cmd + '^' + JobNumber + '^' + FldNum;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    CallBroker;

    frmRPCResults.listRPCResults.Clear;
    for i := 1 to RPCBrokerV.Results.Count-1 do begin
        tempStr := RPCBrokerV.Results[i];
        frmRPCResults.listRPCResults.Items.Add(tempStr);
    end;

    frmRPCResults.ShowModal;
  end;


  {***************EVENT PROCEDURES*******************}
  procedure TfrmPtQuery.btnLaunchSearchClick(Sender: TObject);
  var JobNumber,Count, Fields : string;
      frmSrchResults: TfrmSrchResults;
      frmTMGServerSearch: TfrmTMGServerSearch;

  begin
    if FLastJobNumber <> '' then begin
      if ClearLastSearch(FLastJobNumber) = false then exit;
    end;
    JobNumber := LaunchSearch(edtSearchString.Text);
    FLastJobNumber := JobNumber;
    if JobNumber = '' then exit;

    frmSrchResults := TfrmSrchResults.Create(Self);
    frmTMGServerSearch := TfrmTMGServerSearch.Create(Self);
    if frmTMGServerSearch.ActivateForm(JobNumber) <> mrCancel then begin;
      Count := frmTMGServerSearch.FoundRecsCount;
      if (Count = '0') or (Count = '-1') then begin
        MessageDlg('Sorry, no matches found.' + #13#10 +
                   'This could be due to a search that is too narrow,' + #13#10 +
                   'or a technical limitation of this function.' +#10#13 +
                   'Please try a different search.'+ #13#10 +
                   'NOTE: Search is CASE SENSITIVE.  ' + #13#10 +
                   '      E.g. "Patient" vs "PATIENT" vs "patient" '+ #13#10 +
                   '      all require DIFFERENT searches.', mtInformation, [mbOK],0);
        exit;
      end;
      Fields := '.01';  //do something different if 8925...
      if frmSrchResults.PrepForm(JobNumber, SearchFileName, Count, Fields, edtSearchString.Text) = false then begin
        Exit;
      end;
      if frmSrchResults.ShowModal = mrOK then begin
        FSelectedIEN := frmSrchResults.SelectedIEN;
        FSelectedName := frmSrchResults.SelectedName;
        ModalResult := mrOK; //should result in form being closed.

        {MessageDlg('User Selected ' + frmSrchResults.SelectedName
                   + ' (' + frmSrchResults.SelectedIEN + ')',
                   mtInformation,[mbOK],0); }
      end;
    end;
    FreeAndNil(frmTMGServerSearch);
    FreeAndNil(frmSrchResults);
  end;

  procedure TfrmPtQuery.btnCancelClick(Sender: TObject);
  begin
    if FLastJobNumber <> '' then begin
      if ClearLastSearch(FLastJobNumber) = false then exit;
    end;
    ModalResult := mrCancel;
    //Close;
  end;

  procedure TfrmPtQuery.TabControlChange(Sender: TObject);
  var IsSimpleMode : boolean;
  begin
    IsSimpleMode := (TabControl.TabIndex <> 1);
    LogicSet.SimpleMode := IsSimpleMode;
    lblAdvancedMode.Visible := not IsSimpleMode;
  end;

  procedure TfrmPtQuery.FormCreate(Sender: TObject);
  begin
    LogicSet := TLogicSet.Create(SearchFileNumber,SearchFileName,sbContainer,Self);
    LogicSet.SearchStringEdit := edtSearchString;
    //Give LogicSet the column labels, so it can move them when indenting.
    LogicSet.lblFile := lblFile;
    LogicSet.lblField := lblField;
    LogicSet.lblOperator := lblOperator;
    LogicSet.lblValue := lblValue;
    GlyphImageList.GetBitmap(0, LogicSet.DelBitmap);
    GlyphImageList.GetBitmap(1, LogicSet.btnAddSrchField.Glyph);
    LogicSet.AddRow;
    TabControlChange(Self);
  end;

  procedure TfrmPtQuery.FormDestroy(Sender: TObject);
  //Free all runtime created objects
  begin
    LogicSet.Free;
  end;

end.

