unit fAbout;

interface
//kt 9/11 -- made changes to **FORM** of this unit -- adding contributors memo

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


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ExtCtrls, VA508AccessibilityManager;

type
  TfrmAbout = class(TfrmAutoSz)
    Image1: TImage;
    lblProductName: TStaticText;
    lblFileVersion: TStaticText;
    lblCompanyName: TStaticText;
    lblComments: TStaticText;
    lblCRC: TStaticText;
    lblFileDescription: TStaticText;
    lblInternalName: TStaticText;
    lblOriginalFileName: TStaticText;
    cmdOK: TButton;
    lblLegalCopyright: TMemo;
    memTMGContributors: TMemo;
    lbl508Notice: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAbout;

implementation

{$R *.DFM}

uses VAUtils, ORFn;

procedure ShowAbout;
var
  frmAbout: TfrmAbout;
begin
  frmAbout := TfrmAbout.Create(Application);
  try
    ResizeFormToFont(TForm(frmAbout));
    frmAbout.lblLegalCopyright.SelStart := 0;
    frmAbout.lblLegalCopyright.SelLength := 0;
    frmAbout.lbl508Notice.SelStart := 0;
    frmAbout.lbl508Notice.SelLength := 0;
    frmAbout.ShowModal;
  finally
    frmAbout.Release;
  end;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  inherited;
//  lblCompanyName.Caption        := 'Developed for ' + 'VOE VWPT Patient Enhanced Lookup Version 1.6b';  //vw
//  lblCompanyName.Caption        := 'Developed by the ' + FileVersionValue(Application.ExeName, FILE_VER_COMPANYNAME);
  lblCompanyName.Caption        := 'Developed by the ' + FileVersionValue(Application.ExeName, FILE_VER_COMPANYNAME);
  lblFileDescription.Caption    := 'Compiled ' + FileVersionValue(Application.ExeName, FILE_VER_FILEDESCRIPTION);  //date
  lblFileVersion.Caption        := FileVersionValue(Application.ExeName, FILE_VER_FILEVERSION);
  lblInternalName.Caption       := FileVersionValue(Application.ExeName, FILE_VER_INTERNALNAME);
  lblLegalCopyright.Text        := FileVersionValue(Application.ExeName, FILE_VER_LEGALCOPYRIGHT);
  lblOriginalFileName.Caption   := FileVersionValue(Application.ExeName, FILE_VER_ORIGINALFILENAME);  //patch
  lblProductName.Caption        := FileVersionValue(Application.ExeName, FILE_VER_PRODUCTNAME);
  lblComments.Caption           := FileVersionValue(Application.ExeName, FILE_VER_COMMENTS);  // version comment
  lblCRC.Caption                := 'CRC: ' + IntToHex(CRCForFile(Application.ExeName), 8);
end;

end.
