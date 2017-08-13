unit LookupU;
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


//kt 9/11 Added
  
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ORCtrls, Buttons;

type
  TFieldLookupForm = class(TForm)
    ORComboBox: TORComboBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure ORComboBoxNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure FormShow(Sender: TObject);
    procedure ORComboBoxDblClick(Sender: TObject);
  private
    { Private declarations }
    FFileNum : String;

  public
    { Public declarations }
    procedure InitORComboBox(ORComboBox: TORComboBox; initValue : string);
    procedure PrepForm(FileNum,InitValue : string);
    function SubSetOfFile(FileNum: string; const StartFrom: string;
                          Direction: Integer): TStrings;
  end;

var
  FieldLookupForm: TFieldLookupForm;

implementation

uses
ORNet, ORFn,
Trpcb,   //needed for .ptype types
//QControls,
fPtDemoEdit;
{$R *.dfm}

  procedure TFieldLookupForm.ORComboBoxNeedData(Sender: TObject;
                                                const StartFrom: String;
                                                Direction, InsertAt: Integer);
  var
    Result : TStrings;
  begin
    Result := SubSetOfFile(FFileNum, StartFrom, Direction);
    TORComboBox(Sender).ForDataUse(Result);
  end;

  procedure TFieldLookupForm.InitORComboBox(ORComboBox: TORComboBox; initValue : string);
  begin
    ORComboBox.Text := initValue;
    ORComboBox.InitLongList(initValue);
    if ORComboBox.Items.Count > 0 then begin
      ORComboBox.Text := Piece(ORComboBox.Items[0],'^',2);
    end else begin
      ORComboBox.Text := '<Start Typing to Search>';
    end;
  end;

  procedure TFieldLookupForm.PrepForm(FileNum,InitValue : string);
  begin
    FFileNum := FileNum;
    Self.Caption := 'Pick Entry from File # ' + FileNum;
    //if (FileNum='200') and (InitValue='') then begin
    //  InitValue := fPtDemoEdit.CurrentUserName;
    //end;
    InitORComboBox(ORComboBox,InitValue);
  end;

  
  function TFieldLookupForm.SubSetOfFile(FileNum: string; 
                                         const StartFrom: string;
                                         Direction: Integer       ): TStrings;
                                         
  { returns a pointer to a list of file entries (for use in a long list box) -  
    The return value is a pointer to RPCBrokerV.Results, so the data must 
    be used BEFORE the next broker call! }
  var 
    cmd,RPCResult : string;  
  begin
    RPCBrokerV.remoteprocedure := 'TMG CHANNEL';
    RPCBrokerV.Param[0].Value := '.X';  // not used
    RPCBrokerV.param[0].ptype := list;
    cmd := 'FILE ENTRY SUBSET';
    cmd := cmd + '^' + FileNum + '^' + StartFrom + '^' + IntToStr(Direction);
    RPCBrokerV.Param[0].Mult['"REQUEST"'] := cmd;
    //RPCBrokerV.Call;
    CallBroker;
    RPCResult := RPCBrokerV.Results[0];    //returns:  error: -1;  success=1
    if piece(RPCResult,'^',1)='-1' then begin
     // handle error...
    end else begin
      RPCBrokerV.Results.Delete(0);
      if RPCBrokerV.Results.Count=0 then begin
        //RPCBrokerV.Results.Add('0^<NO DATA>');
      end;
    end;
    Result := RPCBrokerV.Results;
  end;
  
  procedure TFieldLookupForm.FormShow(Sender: TObject);
    var mousePos : TPoint;
  begin
    GetCursorPos(mousePos);
    with FieldLookupForm do begin
      Top := mousePos.Y - 39;
      Left := mousePos.X - 15;
      if Left + Width > Screen.DesktopWidth then begin
        Left := Screen.DesktopWidth - Width;
      end;
    end;
//    ORComboBox.DroppedDown := true;
  end;


procedure TFieldLookupForm.ORComboBoxDblClick(Sender: TObject);
begin
  Modalresult := mrOK;  //Close form, item should be selected (?)
end;

end.

