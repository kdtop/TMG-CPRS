unit fImagePickPDF;
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
  Dialogs, OleCtrls, SHDocVw, FileCtrl, StdCtrls, Buttons, ExtCtrls;

type
  TfrmImagePickPDF = class(TForm)
    pnlTop: TPanel;
    UDSplitter: TSplitter;
    pnlBottom: TPanel;
    pnlTopLeft: TPanel;
    LRSplitter: TSplitter;
    pnlTopRight: TPanel;
    DriveComboBox: TDriveComboBox;
    DirectoryListBox: TDirectoryListBox;
    FileListBox: TFileListBox;
    pnlButtons: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    FilterComboBox: TFilterComboBox;
    WebBrowser: TWebBrowser;
    procedure FileListBoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Filename : string;
    Files : TStringList;
    function Execute : boolean;
    constructor Create(AOwner : TComponent);  override;
    destructor Destroy;                       override;
  end;

//var
//  frmImagePickPDF: TfrmImagePickPDF;

implementation

{$R *.dfm}

uses fImages, StrUtils;


  function TfrmImagePickPDF.Execute : boolean;
  var i : integer;
      OneFile : string;
  begin
    Files.Clear;
    Result := (self.ShowModal = mrOK);
    if FileListBox.FileName = '' then Result := false;
    for i := 0 to FileListBox.Count-1 do begin
      if not FileListBox.Selected[i] then continue;
      OneFile := DirectoryListBox.Directory;
      if RightStr(OneFile,1) <> '\' then OneFile := OneFile + '\';
      Onefile := OneFile + FileListBox.Items.Strings[i];
      Files.Add(OneFile);
    end;
    if Files.IndexOf(FileListBox.FileName)<0 then begin
      Files.Add(FileListBox.FileName);
    end;
  end;

  procedure TfrmImagePickPDF.FileListBoxChange(Sender: TObject);
  var FName : string;
  begin
    Filename := FileListBox.FileName;
    if FileListBox.FileName <> '' then begin
      FName := FileListBox.FileName;
    end else begin
      FName := frmImages.NullImageName
    end;
    WebBrowser.Navigate(FName);
  end;

  procedure TfrmImagePickPDF.FormShow(Sender: TObject);
  begin
    WebBrowser.Navigate(frmImages.NullImageName);
  end;

  procedure TfrmImagePickPDF.FormHide(Sender: TObject);
  begin
    WebBrowser.Navigate(frmImages.NullImageName);
  end;

  constructor TfrmImagePickPDF.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    Files := TStringList.Create;
  end;

  destructor TfrmImagePickPDF.Destroy;
  begin
    Files.Free;
    inherited Destroy;
  end;

  end.

