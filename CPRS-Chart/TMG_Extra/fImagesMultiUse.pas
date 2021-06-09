unit fImagesMultiUse;
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
  Dialogs, OleCtrls, SHDocVw, ExtCtrls, StdCtrls, Buttons, ImgList,
  fImages, ORNet, uImages,
  ComCtrls;

type
  timuMode = (imuAddImage, imuUseImage);
  TfrmImagesMultiUse = class(TForm)
    tvImages: TTreeView;
    TVImageList: TImageList;
    btnAddImage: TBitBtn;
    pnlIEHolder: TPanel;
    WebBrowser: TWebBrowser;
    btnUseImage: TBitBtn;
    btnCancel: TBitBtn;
    pnlHolder: TPanel;
    Splitter1: TSplitter;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvImagesChange(Sender: TObject; Node: TTreeNode);
    procedure btnUseImageClick(Sender: TObject);
    procedure btnAddImageClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    FSharedImagesNode : TTreeNode;
    FPrivateImagesNode : TTreeNode;
    FSelectedImage : string;
    FSelectedImageName : string;
    FImageInfoList : TStringList;
    FMode : timuMode;
    boolContinue : boolean;
    strFailReason : string;
    procedure PopulateTVImages;
    procedure GetImagesListFromServer(List : TStringList);
    procedure ClearTV;
    procedure AddListToTV(List : TStringList);
    procedure SetNodePointers;
    function StoreMultiUseRecord(Name: string; MagIEN: string; Shared: boolean) : boolean;
    procedure DisplayImage(MagIEN, Name : string);
    function GetImage(MagIEN : string) : TImageInfo;
    function GetImageByName(Name : string) : TImageInfo;
    procedure SetMode(Value : timuMode);
  public
    { Public declarations }
    function SelectNamedImage(Name: string): boolean;
    property SelectedImage : string read FSelectedImage;        //Server FName
    property SelectedImageName : string read FSelectedImageName;//Image friendly name
    property Mode : timuMode read FMode write SetMode;
  end;

//var
//  frmImagesMultiUse: TfrmImagesMultiUse;

implementation

{$R *.dfm}

  uses
    fImagesMultAddDlg,
    ORFn,
    fUploadImages, rFileTransferU;

  procedure TfrmImagesMultiUse.FormCreate(Sender: TObject);
  begin
    //NOTE: this is called before RPC Broker is running, so don't put any
    //      server-dependant code here.
    FSharedImagesNode := nil;
    FPrivateImagesNode := nil;
    FImageInfoList := TStringList.Create;
    FMode := imuAddImage;
  end;

  procedure TfrmImagesMultiUse.FormDestroy(Sender: TObject);
  var i : integer;
  begin
    for i := 0 to FImageInfoList.Count - 1 do begin
      TImageInfo(FImageInfoList.Objects[i]).Free;
    end;
    FImageInfoList.Free;
  end;

  procedure TfrmImagesMultiUse.FormShow(Sender: TObject);
  begin
    FSelectedImage := '';
    FSelectedImageName := '';
    PopulateTVImages;
    btnUseImage.Enabled := false;
    WebBrowser.Navigate(frmImages.NullImageName);
    sleep(500); //Give Webbrowser time to release any browsed document.
    if FMode = imuAddImage then begin
      //btnAddImageClick(self);
    end;
  end;

  procedure TfrmImagesMultiUse.SetMode(Value : timuMode);
  begin
    FMode := Value;
    Case FMode of
      imuAddImage : begin
                       btnUseImage.Caption := '&OK';
                     end;
      imuUseImage : begin
                       btnUseImage.Caption := '&Use Image';
                     end;
    end; {case}
  end;

  procedure TfrmImagesMultiUse.PopulateTVImages;
  var List : TStringList;
  begin
    List := TStringList.Create;
    ClearTV;
    GetImagesListFromServer(List);
    AddListToTV(List);
    if Assigned(FSharedImagesNode) then FSharedImagesNode.Expand(false);
    if Assigned(FPrivateImagesNode) then FPrivateImagesNode.Expand(false);
    List.Free;
  end;

  procedure TfrmImagesMultiUse.SetNodePointers;
  var
     temp : string;
  begin
    tvImages.FullCollapse;
    FPrivateImagesNode := tvImages.Items.Item[0];
    temp := FPrivateImagesNode.Text;
    FSharedImagesNode := FPrivateImagesNode.getNextSibling;
    temp := FSharedImagesNode.Text;
    temp := '';
  end;

  function TfrmImagesMultiUse.SelectNamedImage(Name: string): boolean;  
  var
    Rec : TImageInfo;  //owned here
    DLResult : TDownloadResult;
  begin
    Rec := GetImageByName(Name); //instantiates new Rec
    if Assigned(Rec) then begin
      DLResult := EnsureRecDownloaded(Rec);
      FSelectedImage := Rec.ServerFName;
      FSelectedImageName := Name;
      Result := (DLResult = drSuccess);
    end else begin
      Result := False;
    end;
    FreeAndNil(Rec);
  end;

  procedure TfrmImagesMultiUse.ClearTV;
  begin
    SetNodePointers;
    if Assigned(FPrivateImagesNode) then FPrivateImagesNode.DeleteChildren;
    if Assigned(FSharedImagesNode) then FSharedImagesNode.DeleteChildren;
    Application.ProcessMessages;
  end;

  procedure TfrmImagesMultiUse.GetImagesListFromServer(List : TStringList);
  var
     retList : TStringList;
     i : integer;
     s : string;
  //Expected format of results:
  //  A^B^C    A: 0 if shared, 1 if private;  B = DisplayName;  C= MagIEN of entry
  begin
    retList := TStringList.Create;
    try
      tCallV(retList, 'TMG MULTI IMAGE GET', [nil]);
      List.Clear;
      if retList.count = 0 then exit;
      s := retList.strings[0];
      if piece(s,'^',1) = '-1' then begin
        messagedlg('Error: ' + piece(s,'^',2),mtError,[mbOK],0);
        exit;
      end;
      For i:=1 to (retlist.Count-1) do begin
        List.Add(retList.Strings[i]);
      end;
    finally
      retList.Free;
    end;
  end;

  procedure TfrmImagesMultiUse.AddListToTV(List : TStringList);
  var i : integer;
      s : string;
      Parent, OneNode : TTreeNode;
      NodeName : string;
  const OWNED_BY = ' [OWNED BY] ';
  begin
    SetNodePointers;
    for i := 0 to List.Count-1 do begin
      s := List.Strings[i];
      if Piece(s,'^',1)= '0' then begin
        Parent := FSharedImagesNode;
      end else begin
        Parent := FPrivateImagesNode;;
      end;
      if Parent = nil then continue;
      NodeName := Piece(s,'^',2);
      if Pos(OWNED_BY, NodeName) >0 then NodeName := piece2(NodeName, OWNED_BY, 1);
      OneNode := tvImages.Items.AddChild(Parent, NodeName);
      OneNode.Data := Pointer(StrToIntDef(Piece(s,'^',3),0));
      OneNode.ImageIndex := 0;
    end;
  end;

  procedure TfrmImagesMultiUse.tvImagesChange(Sender: TObject; Node: TTreeNode);
  begin
    If not Assigned (Node.Data) then exit;
    DisplayImage(IntToStr(Integer(Node.data)), Node.Text);
    btnUseImage.Enabled := true;
  end;

  function TfrmImagesMultiUse.GetImage(MagIEN : string) : TImageInfo;
  var s : string ;
      i : integer;
  begin
    //If MagIEN requested previously, return stored results
    i := FImageInfoList.IndexOf(MagIEN);
    if i > -1 then begin
      Result := TImageInfo(FImageInfoList.Objects[i]);
      exit;
    end;
    //RPC returns info from MagIEN (file 2005)
    //Format is same as returned by MAG3 CPRS TIU NOTE (see TfrmImages.FillImageList)
    s := sCallV('TMG MULTI IMAGE INFO', [MagIEN]);
    if strtoint(Piece(s,'^',1)) < 1 then begin
      MessageDlg('Error: ' + Piece(s,'^',2),mtError,[mbOK],0);
      Result := nil;
      exit;
    end;
    Result := ParseOneImageListLine(s); //instantiates new Rec
    if Result = nil then exit;
    FImageInfoList.AddObject(MagIEN,Result);  //FImageInfoList owns objects
  end;

  function TfrmImagesMultiUse.GetImageByName(Name : string) : TImageInfo;
  var s : string ;
  begin
    s := sCallV('TMG MULTI IMAGE BY NAME', [Name]);
    if strtoint(Piece(s,'^',1)) < 1 then begin
      MessageDlg('Error Finding Image: "' + Name + '" : ' + Piece(s,'^',2),mtError,[mbOK],0);
      Result := nil;
      exit;
    end;
    Result := ParseOneImageListLine(s);
  end;

  procedure TfrmImagesMultiUse.DisplayImage(MagIEN, Name : string);
  var Rec : TImageInfo; //NOT owned here
      Success : boolean;
  begin
    Rec := GetImage(MagIEN);
    Success := false; //default
    if Assigned(Rec) then begin
      Success := (EnsureRecDownloaded(Rec) = drSuccess);
    end;
    if Success then begin
      WebBrowser.Navigate(Rec.CacheFName);
      FSelectedImage := Rec.ServerFName;
      FSelectedImageName := Name;
    end else begin
      WebBrowser.Navigate(frmImages.NullImageName);
      FSelectedImage := '';
      FSelectedImageName := '';
    end;
  end;

  procedure TfrmImagesMultiUse.btnUseImageClick(Sender: TObject);
  begin
    //Nothing needs to be done here; FSelectedImage. FSelectedImageName
    //should already be set.
    //NOTE: This Button has .ModalResult = mrOK, so form is closed after this.
  end;

  function TfrmImagesMultiUse.StoreMultiUseRecord(Name : string; MagIEN : string;
                                                   Shared : boolean) : boolean;
  var  strPrivate : string;
     RPCResult : string;
  //Returns TRUE if success, FALSE if failure;
  begin
    if Shared then strPrivate := '' else strPrivate := 'Y';
    //RPC to send passed info to Server and add new record to file as below
    //Note: on server side DUZ will be defined, and should be set if PRIVATE
    // is Y/YES (i.e. Shared=false)
    RPCResult := sCallV('TMG MULTI IMAGE ADD', [Name, MagIEN, strPrivate]);
    boolContinue := true;
    if Piece(RPCResult,'^',1) = '-1' then begin
      Result := false;
      strFailReason := Piece(RPCResult,'^',2);
      if strFailReason = 'NAME IN USE' then boolContinue := false;
    end else begin
      Result := true ; //default to success
    end;
  end;

  procedure TfrmImagesMultiUse.btnAddImageClick(Sender: TObject);
  var Name,MagIEN : string;
      Result : integer;
      Shared : boolean;
      frmImagesMultAddDlg: TfrmImagesMultAddDlg;
      frmImageUpload: TfrmImageUpload;

  begin
    if MessageDlg('REMEMBER: Don''t upload patient-specific images here.',
                  mtWarning,[mbOK,mbCancel],0) <> mrOK then exit;
    frmImageUpload := TfrmImageUpload.Create(Self);
    frmImageUpload.Mode := umUniversal;
    if frmImageUpload.ShowModal <> mrOK then exit;
    frmImagesMultAddDlg := TfrmImagesMultAddDlg.Create(Self);
    boolContinue := false;
    While boolContinue = false do begin
      Result := frmImagesMultAddDlg.ShowModal;
      if Result = mrOK then begin
        if frmImageUpload.UploadedImageIENs.Count > 0 then begin
          MagIEN := frmImageUpload.UploadedImageIENs.Strings[0];
          //Shared := (frmImagesMultAddDlg.AddGroup = agShared);
          Shared := (frmImagesMultAddDlg.rgAddToWhich.ItemIndex = 1);
          Name := frmImagesMultAddDlg.ImageName;
          if StoreMultiUseRecord(Name, MagIEN, Shared) then begin
            PopulateTVImages;
          end else begin
            MessageDlg(strFailReason,mtError,[mbOK],0);
          end;
        end else begin
          MessageDlg('Uploaded Image Could Not Be Located.',mtError,[mbOK],0);
        end;
      end else begin
        boolContinue := True;
      end;
    end;
    frmImagesMultAddDlg.Free;
    frmImageUpload.Free;
  end;

  procedure TfrmImagesMultiUse.FormHide(Sender: TObject);
  begin
    Self.Mode := imuUseImage;
  end;

end.

