unit fSplash;

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


//kt 9/11 made changes to **FORM** of this unit

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, fBase508Form, VA508AccessibilityManager, jpeg;

type
  TfrmSplash = class(TfrmBase508Form)
    pnlMain: TPanel;
    lblVersion: TStaticText;
    lblCopyright: TStaticText;
    pnlImage: TPanel;
    Image1: TImage;
    lblSplash: TStaticText;
    lblTMGCustVer: TLabel;
    pnlBottom: TPanel;
    //pnl508Disclaimer: TPanel;  //kt <-- missing for some reason...
    //Memo1: TMemo;              //kt <-- missing for some reason...
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.DFM}

uses
  ORSystem,  //kt 9/11
  VAUtils;

procedure TfrmSplash.FormCreate(Sender: TObject);
//kt 9/11 added entire function
var SplashFile : string;
    CompileDate : string;  //kt
    //  lblFileDescription.Caption

begin
  //NOTE: the value below can be changed in PROJECT OPTIONS->VERSION INFO->FileDescription
  CompileDate := FileVersionValue(Application.ExeName, FILE_VER_FILEDESCRIPTION);
  lblTMGCustVer.Caption := 'TMG Customization Version -- ' + CompileDate;
  lblVersion.Caption := 'version ' + FileVersionValue(Application.ExeName, FILE_VER_FILEVERSION);
  SplashFile := Trim(ParamSearch('SPLASH'));
  if SplashFile <> '' then begin
    if ExtractFilePath(SplashFile) = '' then begin
      SplashFile := ExtractFilePath(ParamStr(0)) + SplashFile;
    end;
  end else begin
    SplashFile := ExtractFilePath(ParamStr(0)) + 'splash.jpg';
  end;
  if FileExists(SplashFile) then begin
    Image1.Picture.LoadFromFile(SplashFile);
  end;
end;

end.
