unit fImagePickExisting;
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
  uImages,
  Dialogs, fImages, StdCtrls, Buttons, ExtCtrls;

type
  TfrmImagePickExisting = class(TForm)
    pnlButtons: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    ScrollBox: TScrollBox;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImageClick(Sender: TObject);
    procedure ImageDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure ScrollBoxClick(Sender: TObject);
  private
    { Private declarations }
    ShownImagesList : TList; //owns objects
    Row, Col : integer;
    NextInsert : TPoint;
    CurRowHeight : integer;
    SelectedIndex : integer;
    function GetImageFName : string;
    function GetSelectedImageInfo : TImageInfo;
    procedure InitImagePlacement;
    procedure BoxImage(Index: integer; Selected : boolean);
    procedure ImagesListClear;
    procedure ShowImages;
    procedure ShowSelected;
  public
    { Public declarations }
    property SelectedImageInfo : TImageInfo read GetSelectedImageInfo;
    property SelectedImageFName : string read GetImageFName;
  end;

const
  IMAGE_SPACING = 5;
  COLS_PER_ROW = 3;

//var
//  frmImagePickExisting: TfrmImagePickExisting;

implementation

{$R *.dfm}

procedure TfrmImagePickExisting.FormShow(Sender: TObject);
begin
   ShowImages;
end;

procedure TfrmImagePickExisting.FormCreate(Sender: TObject);
begin
  ShownImagesList := TList.Create; //owns objects
  InitImagePlacement;
end;

procedure TfrmImagePickExisting.FormDestroy(Sender: TObject);
begin
  ImagesListClear;
  ShownImagesList.Free;
end;

//------------------------------------------------------------
//Event handlers
//------------------------------------------------------------
procedure TfrmImagePickExisting.ImageClick(Sender: TObject);
begin
  SelectedIndex := TImage(Sender).Tag;
  ShowSelected;
end;

procedure TfrmImagePickExisting.ImageDblClick(Sender: TObject);
begin
  SelectedIndex := TImage(Sender).Tag;
  ShowSelected;
  btnOK.Click;
end;

procedure TfrmImagePickExisting.btnOKClick(Sender: TObject);
begin
  //kt
end;

procedure TfrmImagePickExisting.ScrollBoxClick(Sender: TObject);
begin
  SelectedIndex := -1;
  ShowSelected;
end;

//------------------------------------------------------------
//-----------------------------------------------------------

procedure TfrmImagePickExisting.ShowSelected;
var i : integer;
begin
  for i := 0 to ShownImagesList.Count-1 do begin
    BoxImage(i, (i=SelectedIndex));
  end;
end;

procedure TfrmImagePickExisting.ImagesListClear;
var i : integer;
    Image : TImage;
begin
  for i := 0 to ShownImagesList.Count-1 do begin
    Image := TImage(ShownImagesList.Items[i]);
    Image.Free;
  end;
  InitImagePlacement;
end;

procedure TfrmImagePickExisting.InitImagePlacement;
begin
  Row := 0;
  Col := 0;
  NextInsert.X := IMAGE_SPACING;
  NextInsert.Y := IMAGE_SPACING;
  CurRowHeight := 0;
  SelectedIndex := -1;
end;


procedure TfrmImagePickExisting.ShowImages;
var i : integer;
    Image : TImage;
    Rec  : TImageInfo;

begin
  EnsureLinkedImagesDownloadedForced;
  ImagesListClear;
  for i := 0 to uImages.GetImagesCount - 1 do begin
    Rec := uImages.GetImageInfo(i);
    if Rec=nil then begin
      ShowMessage('Image index '+inttostr(i)+' was blank.');
      continue;
    end;
    Image := TImage.Create(Self);
    ShownImagesList.Add(Image);  //index will match Image.Tag below
    Image.Visible := false;
    Image.Parent := ScrollBox;
    if FileExists(Rec.CacheThumbFName) then begin
      Image.Picture.Bitmap.LoadFromFile(Rec.CacheThumbFName);
    end else begin
      frmImages.GetThumbnailBitmapForFName(Rec.CacheFName,
                                           Image.Picture.Bitmap);
    end;
    Image.Top := NextInsert.Y;
    Image.Left := NextInsert.X;
    Image.Tag := i;
    Image.OnClick := ImageClick;
    Image.OnDblclick := ImageDblClick;
    Image.Visible := true;
    If Image.Picture.Bitmap.Height > CurRowHeight then begin
      CurRowHeight := Image.Picture.Bitmap.Height;
    end;
    Inc (Col);
    if Col > COLS_PER_ROW then begin
      Col := 0;
      Inc (Row);
      NextInsert.X := IMAGE_SPACING;
      NextInsert.Y := NextInsert.Y + CurRowHeight + IMAGE_SPACING;
    end else begin
      NextInsert.X := NextInsert.X + Image.Picture.Bitmap.Width + IMAGE_SPACING;
    end;
  end;
end;

function TfrmImagePickExisting.GetSelectedImageInfo : TImageInfo;
//Returns nil if not selcted.
begin
  if SelectedIndex> -1 then begin
    Result := uImages.GetImageInfo(SelectedIndex);
  end else begin
    Result := nil;
  end;
end;

function TfrmImagePickExisting.GetImageFName : string;
var
  Rec  : TImageInfo;
begin
  Rec := GetSelectedImageInfo;
  if Assigned(Rec) then begin
    Result := Rec.CacheFName;
  end else begin
    Result := '';
  end;
end;

procedure TfrmImagePickExisting.BoxImage(Index: integer; Selected : boolean);
var
  Image : TImage;
  Rect : TRect;
begin
  if (Index < 0) or (Index >= ShownImagesList.Count) then exit;
  Image := TImage(ShownImagesList.Items[Index]);
  if Image = nil then exit;
  Rect.Top := 0; Rect.Left := 0;
  Rect.Right := Image.Picture.Bitmap.Width-1;
  Rect.Bottom := Image.Picture.Bitmap.Height-1;
  if Selected then begin
    Image.Canvas.Pen.Color := clRed;
  end else begin
    Image.Canvas.Pen.Color := clBtnFace;
  end;
  Image.Canvas.PenPos := Rect.TopLeft;
  Image.Canvas.LineTo(Rect.Left,Rect.Bottom);
  Image.Canvas.LineTo(Rect.Right,Rect.Bottom);
  Image.Canvas.LineTo(Rect.Right,Rect.Top);
  Image.Canvas.LineTo(Rect.Left,Rect.Top);
  //Image.Canvas.Rectangle(Rect); //This fills in center with brush.
end;


end.

