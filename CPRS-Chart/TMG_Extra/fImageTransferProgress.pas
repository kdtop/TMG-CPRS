unit fImageTransferProgress;
//kt 9/11 Added this entire form.
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
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  TfrmImageTransfer = class(TForm)
    ProgressBar: TProgressBar;
    Label1: TLabel;
    Image1: TImage;
    ProgressMsg: TLabel;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure Abort;
  public
    { Public declarations }
    UserCanceled : boolean;
    procedure setMax(Max : integer);
    procedure UpdateProgress(CurrentValue: integer); overload;
    procedure UpdateProgress(CurrentValue, TotalValue : integer; Msg : string=''); overload;

  end;

var
  frmImageTransfer: TfrmImageTransfer;  //not auto-instantiaged.  

implementation

{$R *.dfm}

  procedure TfrmImageTransfer.btnCancelClick(Sender: TObject);
  begin
    Abort;
  end;

  procedure TfrmImageTransfer.FormCreate(Sender: TObject);
  begin
    UserCanceled := false;
  end;

  procedure TfrmImageTransfer.FormHide(Sender: TObject);
  //This will be if user clicks (x) in top right corner.
  begin
    Abort;
  end;

  procedure TfrmImageTransfer.FormShow(Sender: TObject);
  begin
    btnCancel.Enabled := true;
  end;

procedure TfrmImageTransfer.Abort;
  begin
    UserCanceled := true;
    btnCancel.Enabled := false;
    Application.ProcessMessages;
  end;

  procedure TfrmImageTransfer.setMax(Max : integer);
  begin
    ProgressBar.Max := Max;
    Application.ProcessMessages;
  end;

  procedure TfrmImageTransfer.updateProgress(CurrentValue: integer);
  begin
    ProgressBar.Position := CurrentValue;
    Application.ProcessMessages;
  end;

  procedure TfrmImageTransfer.UpdateProgress(CurrentValue, TotalValue : integer; Msg : string='');
  begin
    if Msg <> '' then ProgressMsg.Caption := Msg;
    ProgressBar.Position := CurrentValue;
    ProgressBar.Max := TotalValue;
    Application.ProcessMessages;
  end;

end.
