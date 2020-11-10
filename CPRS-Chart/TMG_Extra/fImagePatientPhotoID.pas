unit fImagePatientPhotoID;
//kt added entire form 4/14/14
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
  ORNet, ORFn,
  rFileTransferU,  //10/27/20
  Dialogs, ExtCtrls, StdCtrls, OleCtrls, SHDocVw, Buttons;

const
     UM_ACTIVATED = WM_USER+1;

type
  TPatientIDPhotoInfoRec = class (TObject)
  public
    IEN : string;   //piece 1
    ImageFPath : string;  //piece 2
    ThumbnailFPath : string;  //piece 3
    LocalFPath : string;
    LocalThumbPath : string;
    ShortDescr : string;  //piece 4
    DateTime : TDateTime;  //piece 5  //may store as Delphi DateTime
    DisplayDate : string; //piece 6
  end;

  TDownloadType = (dlBoth, dlThumb, dlFull);
  TLocationType = (ltLeft,ltRight);

  TfrmPatientPhotoID = class(TForm)
    btnOK: TBitBtn;
    pnlIEHolder: TPanel;
    WebBrowser: TWebBrowser;
    cboDateOfPhoto: TComboBox;
    lblDateOfPhoto: TLabel;
    PatientImage: TImage;
    btnAddPhotoID: TBitBtn;
    btnLeft: TBitBtn;
    btnRight: TBitBtn;
    lblInfo: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure cboDateOfPhotoChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddPhotoIDClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FChangesMade : boolean;
    FDFN : string;
    IDPhotosInfo : TStringList;
    InfoList : TList;
    FUploadMode : Boolean;
    FDragAndDropFile : string;
    UserCancelledUpload : boolean;
    procedure SetUploadMode(value: Boolean);
    procedure SyncToCurrentPhotos;
    procedure LoadComboBox(InfoList : TList);
    procedure ShowPhotoSet(InfoRec : TPatientIDPhotoInfoRec);
    procedure SetArrowButtonEnabled;
    procedure AddPhotoID(FName : string = '');
    procedure UMActivated(var Msg: TMessage); message UM_ACTIVATED;
    procedure SetPreviewDisplay(RelativeTo:TControl;Location:TLocationType);
  public
    { Public declarations }
    MostRecentThumbBitmap: TBitmap;
    procedure ShowPreviewMode(DFN : string;RelativeTo:TControl;Location:TLocationType) overload;
    function ShowModal(DFN : string; UploadMode: boolean = True) : integer; overload;
    function ShowModalUploadFName(DFN : string; FName : string) : integer; overload;
    property UploadMode: boolean read FUploadMode write SetUploadMode;
  end;


  procedure LoadMostRecentPhotoIDThumbNail(DFN: string; BM: TBitmap);
//var
//  frmPatientPhotoID: TfrmPatientPhotoID; <-- not auto created



implementation

{$R *.dfm}

uses
  fUploadImages,fImages,fFrame;

  procedure EnsureDownloaded(InfoRec : TPatientIDPhotoInfoRec; DLType : TDownloadType); forward;
  procedure LoadPhotoIDRPC(DFN: string; SL: TStringList); forward;
  procedure ParsePhotoInfo(InfoList: TList; Info : TStringList); forward;
  procedure ClearInfoList(InfoList: TList); forward;

  procedure TfrmPatientPhotoID.SetUploadMode(value: boolean);
  begin
    FUploadMode := value;
    btnAddPhotoID.visible := FUploadMode;
    lblInfo.Visible := not FUploadMode;
  end;

  procedure TfrmPatientPhotoID.AddPhotoID(FName : string = '');
  var
    frmImageUpload: TfrmImageUpload;
  begin
    frmImageUpload := TfrmImageUpload.Create(Self);
    frmImageUpload.Mode := umPatientID;
    If FName <> '' then frmImageUpload.DragAndDropFNames.Add(FName);
    if frmImageUpload.ShowModal = mrOK then begin
      FChangesMade := true;
      SyncToCurrentPhotos;
    end else begin
      UserCancelledUpload := True;
    end;
    //frmImageUpload.Mode := umAnyFile;
    frmImageUpload.Free;
  end;

  procedure TfrmPatientPhotoID.btnAddPhotoIDClick(Sender: TObject);
  begin
    //here I can launch dialog to add photo.
    AddPhotoID;
  end;

  procedure TfrmPatientPhotoID.btnOKClick(Sender: TObject);
  begin
    if FChangesMade then begin
      Self.ModalResult := mrOK;
    end else begin
      Self.ModalResult := mrCancel;
    end;
  end;

procedure EnsureDownloaded(InfoRec : TPatientIDPhotoInfoRec; DLType : TDownloadType);
  var
     Result : TDownloadResult;
     FName: string;
     FPath: string;
  begin
    if DLType in [dlBoth,dlThumb]  then begin
      if not FileExists(InfoRec.LocalThumbPath) then begin
        frmImages.SplitLinuxFilePath(InfoRec.ThumbnailFPath,FPath,FName);
        Result := frmImages.DownloadFile(FPath,FName,InfoRec.LocalThumbPath,-1,1);
      end;
    end;
    if DLType in [dlBoth,dlFull]  then begin
      if not FileExists(InfoRec.LocalFPath) then begin
        frmImages.SplitLinuxFilePath(InfoRec.ImageFPath,FPath,FName);
        Result := frmImages.DownloadFile(FPath,FName,InfoRec.LocalFPath,-1,1);
      end;
    end;
  end;

  procedure TfrmPatientPhotoID.ShowPhotoSet(InfoRec : TPatientIDPhotoInfoRec);
  begin
    EnsureDownloaded(InfoRec,dlBoth);
    if FileExists(InfoRec.LocalFPath) then
      WebBrowser.Navigate(InfoRec.LocalFPath)
    else begin
      //WebBrowser.Navigate(frmImages.NullImageName);
    end;  
    if FileExists(InfoRec.LocalThumbPath) then begin
      PatientImage.Picture.LoadFromFile(InfoRec.LocalThumbPath);
      MostRecentThumbBitmap.Assign(PatientImage.Picture.Bitmap);
    end else begin
      PatientImage.Picture.Bitmap.Assign(fFrame.NoPatientIDPhotoIcon);
      MostRecentThumbBitmap.Assign(fFrame.NoPatientIDPhotoIcon);
    end;
  end;

  procedure TfrmPatientPhotoID.cboDateOfPhotoChange(Sender: TObject);
  var
    OneRec : TPatientIDPhotoInfoRec;
    i : integer;
  begin
    //Get photo info rec based on selecte entry in combo box.
    //ShowPhotoSet(InfoRec)
    i := cboDateOfPhoto.ItemIndex;
    if i < 0 then exit;
    OneRec := TPatientIDPhotoInfoRec(cboDateOfPhoto.Items.Objects[i]);
    if OneRec = nil then exit;
    ShowPhotoSet(OneRec);
    SetArrowButtonEnabled;
  end;

 function TfrmPatientPhotoID.ShowModal(DFN : string; UploadMode: boolean = True) : integer;
  begin
    FDFN := DFN;
    SetUploadMode(UploadMode);
    result := Self.ShowModal;
  end;

  function TfrmPatientPhotoID.ShowModalUploadFName(DFN : string; FName : string) : integer;
  begin
    FDFN := DFN;
    FDragAndDropFile := FName;
    SetUploadMode(UploadMode);
    result := Self.ShowModal;
  end;

  procedure TfrmPatientPhotoID.ShowPreviewMode(DFN : string; RelativeTo:TControl;Location:TLocationType) overload;
  begin
    FDFN := DFN;
    SetPreviewDisplay(RelativeTo,Location);
    Self.Show;
  end;

  procedure TfrmPatientPhotoID.SetPreviewDisplay(RelativeTo:TControl;Location:TLocationType);
  var SetTop,SetLeft:integer;
      lPoint:TPoint;
  begin
    lblDateOfPhoto.Visible := false;
    btnLeft.Visible := false;
    btnRight.Visible := false;
    cboDateofPhoto.Visible := false;
    PatientImage.Visible := false;
    btnAddPhotoID.Visible := false;
    btnOK.Visible := false;
    pnlIEHolder.top := 0;
    pnlIEHolder.Anchors := [akLeft,akTop,akRight];
    self.BorderStyle := bsNone;
    pnlIEHolder.Height := self.Height-4;
    Self.position:= poDesigned;
    //Get screen position of control "RelativeTo"
    lPoint := RelativeTo.ClientToScreen(Point(0,0));
    self.Top := lPoint.Y+relativeto.height+2;
    if Location=ltLeft then self.Left := lPoint.X-self.width-2
    else if Location=ltRight then self.Left := lPoint.X+relativeto.width+2;
         
  end;


  procedure ParsePhotoInfo(InfoList: TList; Info : TStringList);
{ e.g.
  1^1   --- Success^Count
  B2^42315^/TMG0\00\00\04\23\TMG00000042315.jpeg^/TMG0\00\00\04\23\TMG00000042315.ABS^ ^3140415.0727^1^PHOTO ID^04/15/2014 07:27^^M^A^^^1^2^TMG^^^74592^ZZTEST,BABY^CLIN^04/15/2014 07:27^^^'#$D#$A

  xx- B2^
  01- 42315^
  *02- /TMG0\00\00\04\23\TMG00000042315.jpeg^
  03- /TMG0\00\00\04\23\TMG00000042315.ABS^
  04-  ^  -- SHORT DESCRIPTION
  05- 3140415.0727^
  06- 1^   -- OBJECT TYPE
  07- PHOTO ID^  -- PROCEDURE FIELD
  08- 04/15/2014 07:27^  -- DISPLAY DATE
  09- ^
  10- M^
  11- A^
  12- ^
  13- ^
  14- 1^
  15- 2^
  16- TMG^
  17- ^
  18- ^
  19- 74592^
  20- ZZTEST,BABY^
  21- CLIN^
  22- 04/15/2014 07:27^
  23- ^
  24- ^


    IEN : string;   //piece 1
    ImageFPath : string;  //piece 2
    ThumbnailFPath : string;  //piece 3
    ShortDescr : string;  //piece 4
    DateTime : string;  //piece 5  //may store as Delphi DateTime
    DisplayDate : string; //piece 6

  }

    procedure ParseOneRec(s : string; OneRec : TPatientIDPhotoInfoRec);
    var DT: string;
        FMDT : double;
        FPath,FName: string;
    begin
      OneRec.IEN := piece(s,'^',2);
      OneRec.ImageFPath := piece(s,'^',3);
      OneRec.ThumbnailFPath := piece(s,'^',4);
      OneRec.ShortDescr := piece(s,'^',5);
      DT := piece(s,'^',6);
      FMDT := StrToFloatDef(DT,0);
      OneRec.DateTime := FMDateTimeToDateTime(FMDT);
      OneRec.DisplayDate := piece(s,'^',9);
      frmImages.SplitLinuxFilePath(OneRec.ThumbnailFPath,FPath,FName);
      OneRec.LocalThumbPath := CacheDir+'\'+ChangeFileExt(FName,'.bmp');
      frmImages.SplitLinuxFilePath(OneRec.ImageFPath,FPath,FName);
      OneRec.LocalFPath := CacheDir+'\'+FName;
    end;

  var s : string;
      i : integer;
      OneRec : TPatientIDPhotoInfoRec;
  begin
    ClearInfoList(InfoList);
    if not assigned (Info) then exit;
    if Info.count = 0 then exit;
    s := Info.Strings[0];
    if piece(s,'^',1) <> '1' then exit;
    for i := 1 to Info.Count - 1 do begin
      s := Info.Strings[i];
      OneRec := TPatientIDPhotoInfoRec.Create;  //Will be owned by InfoList
      ParseOneRec(s, OneRec);
      InfoList.Add(OneRec);
    end;
  end;

  procedure ClearInfoList(InfoList: TList);
  var i : integer;
  begin
    //free each held item
    for i := 0 to InfoList.Count - 1 do begin
      TPatientIDPhotoInfoRec(InfoList[i]).Free;
    end;
    InfoList.Clear;
  end;

  procedure TfrmPatientPhotoID.btnLeftClick(Sender: TObject);
  var count, i : integer;
  begin
    i := cboDateOfPhoto.ItemIndex;
    count := cboDateOfPhoto.Items.Count;
    if i < count-2 then cboDateOfPhoto.ItemIndex := i+1;
    cboDateOfPhotoChange(Self);
  end;

  procedure TfrmPatientPhotoID.btnRightClick(Sender: TObject);
  var i : integer;
  begin
    i := cboDateOfPhoto.ItemIndex;
    if i > 0 then cboDateOfPhoto.ItemIndex := i-1;
    cboDateOfPhotoChange(Self);
  end;

  

  procedure TfrmPatientPhotoID.SetArrowButtonEnabled;
  var i : integer;
  begin
    if cboDateOfPhoto.Items.Count = 0 then begin
      btnLeft.Enabled := false;
      btnRight.Enabled := false;
      exit;
    end;
    i := cboDateOfPhoto.ItemIndex;
    btnRight.Enabled := (i > 0);
    btnLeft.Enabled := (i < cboDateOfPhoto.Items.Count-2);
  end;


  procedure TfrmPatientPhotoID.LoadComboBox(InfoList: TList);
  var i : integer;
      OneRec:TPatientIDPhotoInfoRec;
  begin
    cboDateOfPhoto.Items.Clear;
    //use InfoList (list of info records) to populate combo box.
    for i := 0 to InfoList.Count - 1 do begin
      OneRec := TPatientIDPhotoInfoRec(InfoList[i]);
      cboDateOfPhoto.Items.AddObject(OneRec.DisplayDate, OneRec);
    end;
    if cboDateOfPhoto.Items.Count = 0 then begin
      cboDateOfPhoto.Items.Add('<none>');
    end;
    SetArrowButtonEnabled;
  end;

  procedure LoadPhotoIDRPC(DFN: string; SL: TStringList);
  begin
    CallV('MAGG PAT PHOTOS',[DFN]);
    SL.Assign(RPCBrokerV.Results);
  end;

  procedure LoadMostRecentPhotoIDThumbNail(DFN: string; BM: TBitmap);
  var
    SL: TStringList;
    InfoList: TList;
    OneRec : TPatientIDPhotoInfoRec;
  begin
    SL := TStringList.Create();
    InfoList := TList.Create();
    LoadPhotoIDRPC(DFN,SL);
    ParsePhotoInfo(InfoList,SL);

    if InfoList.count>0 then begin
      OneRec := TPatientIDPhotoInfoRec(InfoList[0]);
    end else OneRec := nil;
    if OneRec = nil then begin
      BM.Assign(fFrame.NoPatientIDPhotoIcon);
      exit;
    end;
    EnsureDownloaded(OneRec,dlThumb);
    if FileExists(OneRec.LocalThumbPath) then
      BM.LoadFromFile(OneRec.LocalThumbPath)
    else
      BM.Assign(fFrame.NoPatientIDPhotoIcon);

    ClearInfoList(InfoList);
    SL.Free;
    InfoList.Free;
  end;

  procedure TfrmPatientPhotoID.SyncToCurrentPhotos;
  begin
    if FDFN = '' then exit;
    LoadPhotoIDRPC(FDFN,IDPhotosInfo);
    ParsePhotoInfo(InfoList,IDPhotosInfo);
    LoadComboBox(InfoList);
    cboDateOfPhoto.ItemIndex := 0;  //does this trigger onchange event??
    cboDateOfPhoto.OnChange(self);
  end;


  procedure TfrmPatientPhotoID.FormActivate(Sender: TObject);
  begin
    PostMessage(Handle,UM_ACTIVATED,0,0);
  end;

procedure TfrmPatientPhotoID.FormCreate(Sender: TObject);
  begin
    FChangesMade := false;
    FDFN := '';
    IDPhotosInfo := TStringList.Create;
    InfoList := TList.create;
    MostRecentThumbBitmap := TBitmap.Create;
    FUploadMode := True;
    FDragAndDropFile := '';
  end;

  procedure TfrmPatientPhotoID.FormDestroy(Sender: TObject);
  begin
    IDPhotosInfo.Free;
    ClearInfoList(InfoList);
    InfoList.free;
    MostRecentThumbBitmap.Free;
  end;

procedure TfrmPatientPhotoID.FormShow(Sender: TObject);
  begin
    UserCancelledUpload := False;
    if FDFN = '' then begin
      MessageDlg('Which patient is selected??', mtError, [mbOK],0);
      Self.ModalResult := mrCancel;
    end;
    if (FDragAndDropFile <> '') then begin
      AddPhotoID(FDragAndDropFile);
      FDragAndDropFile := '';
    end else begin
      SyncToCurrentPhotos;
    end;
  end;

  procedure TfrmPatientPhotoID.UMActivated(var Msg: TMessage);
  begin
    if UserCancelledUpload then modalresult := mrCancel;

  end;

end.

