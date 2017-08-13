unit fTMGServerSearch;
//kt 9/11 -- added entire unit
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
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, ImgList;

type
  TfrmTMGServerSearch = class(TForm)
    AnimationImageList: TImageList;
    AnimationImage: TImage;
    lblSearching: TLabel;
    ProgressBar: TProgressBar;
    btnCancel: TBitBtn;
    AnimationTimer: TTimer;
    CheckServerTimer: TTimer;
    lblMessages: TLabel;
    procedure AnimationTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure CheckServerTimerTimer(Sender: TObject);
  private
    { Private declarations }
    ImageIndex : integer;
    Picture : TPicture;
    FJobNumber : string;
    procedure UpdatePicture;
    function JobActive(JobNumber : String; OUT PercentDone : Integer;
                       OUT Comments : string): Boolean;
  public
    { Public declarations }
    FoundRecsCount : string; //Out parameter only.
    function ActivateForm(JobNumber : string) : integer;
  end;

//var
//  frmTMGServerSearch: TfrmTMGServerSearch;

implementation

{$R *.dfm}

  uses ORNet, ORFn, Trpcb, ORCtrls;

  const
    MAX_NUM_IMAGE_INDEX = 15;


  procedure TfrmTMGServerSearch.FormCreate(Sender: TObject);
  begin
    ImageIndex := 0;
    Picture := TPicture.Create;
  end;

  procedure TfrmTMGServerSearch.FormDestroy(Sender: TObject);
  begin
    Picture.Free;
  end;

  procedure TfrmTMGServerSearch.FormShow(Sender: TObject);
  begin
    AnimationTimer.Enabled := true;
    CheckServerTimer.Enabled := true;
  end;

  procedure TfrmTMGServerSearch.FormHide(Sender: TObject);
  begin
    AnimationTimer.Enabled := false;
    CheckServerTimer.Enabled := false;
  end;

  function TfrmTMGServerSearch.ActivateForm(JobNumber : string) : integer;
  begin
    FJobNumber := JobNumber;
    Result := ShowModal;
  end;

  procedure TfrmTMGServerSearch.UpdatePicture;
  begin
    Inc(ImageIndex);
    if ImageIndex > MAX_NUM_IMAGE_INDEX then ImageIndex := 0;
    AnimationImageList.GetBitmap(ImageIndex,Picture.Bitmap);
    AnimationImage.Picture.Assign(Picture);
  end;

  procedure TfrmTMGServerSearch.AnimationTimerTimer(Sender: TObject);
  begin
    AnimationTimer.Enabled := false;
    UpdatePicture;
    AnimationTimer.Enabled := true;
  end;

  procedure TfrmTMGServerSearch.CheckServerTimerTimer(Sender: TObject);
  var PctDone : Integer;
      Comments : string;
  begin
    CheckServerTimer.Enabled := false;
    if JobActive(FJobNumber, PctDone, Comments) = false then begin
      ModalResult := mrOK;
    end;
    ProgressBar.Position := PctDone;
    lblMessages.Caption := Comments;
    CheckServerTimer.Enabled := true;
  end;


  procedure TfrmTMGServerSearch.btnCancelClick(Sender: TObject);
  begin
    //Do anything needed here before closing form.
    //(Hide function is executed next)
    Self.ModalResult := mrCancel;
  end;


  function TfrmTMGServerSearch.JobActive(JobNumber : String;
                                         OUT PercentDone : Integer;
                                         OUT Comments : string): Boolean;
  //Check the job status
  var  cmd, RPCResult  : string;
  begin
    RPCBrokerV.remoteprocedure := 'TMG SEARCH CHANNEL';
    RPCBrokerV.param[0].ptype := list;
    RPCBrokerV.Param[0].Value := '.X';
    cmd := 'STATUS';
    cmd := cmd + '^' + JobNumber;
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    //RPCBrokerV.Call;
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then begin
      RPCResult := RPCBrokerV.Results[0];
      //Check piece 1 for -1 that indicates an error...
      if Piece(RPCResult,'^',1) = '-1' then begin
        result := false;
        exit;
      end;
      PercentDone := StrToIntDef(piece(RPCResult,'^',2),0);
      Comments := piece(RPCResult,'^',3);
      FoundRecsCount := piece(RPCResult,'^',4);
      Result := (Comments <> '#DONE#');
    end else begin
      result := true;
    end;
  end;




end.

