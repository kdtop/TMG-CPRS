unit FMErrorU;
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
  Dialogs, StdCtrls;

type
  TFMErrorForm = class(TForm)
    Memo: TMemo;
    OKBtn: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PrepMessage;
  end;

//var
//  FMErrorForm: TFMErrorForm;

implementation

{$R *.dfm}

uses
  ORFn, StrUtils;
  
  procedure TFMErrorForm.PrepMessage;
  var
    s, text : string;
  begin

    if Memo.Lines.Count=1 then begin
      s := Memo.Lines.Strings[0];
      if piece(s,'^',1)='-1' then begin
        Memo.Lines.Strings[0] := MidStr(s, 3,length(s));
      end;
    end else if Memo.Lines.Count>1 then begin
      if piece(Memo.Lines.Strings[0],'^',1)='-1' then begin
        Memo.Lines.Delete(0);
        text := Memo.Lines.Text;
        text := AnsiReplaceStr(text, ' [', #13+'[');
        text := AnsiReplaceStr(text, 'Fileman says:', 'Database error message:'+#13);
        Memo.Lines.Text := text;
      end;
    end;
  end;

end.

