unit fMailbox;

interface

uses
  Windows, fPage, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,ORFn,OrNet,uCore,pngimage,
  Dialogs, StdCtrls, Printers, VA508AccessibilityManager, ExtCtrls, Buttons, OleCtrls, SHDocVw;

type
  tMailboxActionType=(mailNone,mailDelete,mailImport,mailPrint,mailRotate,mailToMailbox);

  TfrmMailbox = class(TfrmPage)
    pnlMailBottom: TPanel;
    btnMailZoomIn: TBitBtn;
    btnMailZoomOut: TBitBtn;
    btnMailImport: TBitBtn;
    btnMailPrint: TBitBtn;
    btnMailDelete: TBitBtn;
    btnToMailbox: TBitBtn;
    btnMailRotate: TBitBtn;
    pnlMailLeft: TPanel;
    lbMailItems: TListBox;
    Splitter1: TSplitter;
    pnlMailMiddle: TPanel;
    MailboxViewer: TWebBrowser;
    lblAlert: TLabel;
    ImageToPrint: TImage;
    procedure btnMailDeleteClick(Sender: TObject);
    procedure btnMailRotateClick(Sender: TObject);
    procedure btnMailPrintClick(Sender: TObject);
    procedure btnMailImportClick(Sender: TObject);
    procedure btnMailZoomOutClick(Sender: TObject);
    procedure btnMailZoomInClick(Sender: TObject);
    procedure lbMailItemsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FZoom : integer;
    Fax_Location : string;
    Completed_Loc: string;
    User_Mailbox_Location : string;
    Trash_Bin: string;
    MailboxAction : tMailboxActionType;
    Pend_Consult_Loc: string;
    procedure ApplyZoom(Zoom:integer;WB: TWebBrowser);
    procedure RefreshMailboxList(Path: string; FaxListBox:TListBox);
    procedure MailboxGroupAction();
    procedure LoadFaxGroup(WB: TWebBrowser; Path: string; GroupName: string; var Data: string);
    procedure DelDocument(const Path,DocToDelete : string) ;
    procedure MoveDocument(const Path,DocToMove,DestLoc : string) ;
    procedure PrintDocument(const Path,DocToPrint : string) ;
    procedure RotatePNGFile(FileName: string;LabelName:TLabel) ;
  public
    { Public declarations }
  end;

var
  frmMailbox: TfrmMailbox;



implementation

{$R *.dfm}

uses uTMGOptions;

const
  //FaxViewer Zoom Constants
  OLECMDID_OPTICAL_ZOOM = $0000003F;
  MIN_ZOOM = 10;
  MAX_ZOOM = 1000;
  ZOOM_FACTOR = 10;
  DEFAULT_ZOOM = 100;



procedure TfrmMailbox.btnMailDeleteClick(Sender: TObject);
var Response: integer;
begin
  Response := Messagedlg('Are you sure you want to delete this entire fax?',mtConfirmation,[mbYes,mbNo],0);
  if Response<>mrYes then exit;
  MailboxAction := mailDelete;
  MailboxGroupAction;
end;

procedure TfrmMailbox.btnMailImportClick(Sender: TObject);
begin
  inherited;
  MailboxAction := mailImport;
  MailboxGroupAction;
end;

procedure TfrmMailbox.btnMailPrintClick(Sender: TObject);
begin
  inherited;
  MailboxAction := mailPrint;
  MailboxGroupAction;
end;

procedure TfrmMailbox.btnMailRotateClick(Sender: TObject);
begin
  inherited;
  MailboxAction := mailRotate;
  MailboxGroupAction;
end;

procedure TfrmMailbox.btnMailZoomInClick(Sender: TObject);
begin
  System.Inc(FZoom, ZOOM_FACTOR);
  if FZoom > MAX_ZOOM then
    FZoom := MAX_ZOOM;
  ApplyZoom(FZoom,MailboxViewer);
end;

procedure TfrmMailbox.btnMailZoomOutClick(Sender: TObject);
begin
  System.Dec(FZoom, ZOOM_FACTOR);
  if FZoom < MIN_ZOOM then
    FZoom := MIN_ZOOM;
  ApplyZoom(FZoom,MailboxViewer);
end;

procedure TfrmMailbox.FormShow(Sender: TObject);
begin
  inherited;
  FZoom := DEFAULT_ZOOM;
  Fax_Location := uTMGOptions.ReadString('Fax Location','??');
  User_Mailbox_Location := uTMGOptions.ReadString('Fax Mailbox Location','??')+inttostr(User.DUZ)+'/';;
  Completed_Loc := uTMGOptions.ReadString('New Loc For Faxes','??');
  Trash_Bin := uTMGOptions.ReadString('Fax Location Trash','??');
  Pend_Consult_Loc := Completed_Loc + 'Pending\';
  RefreshMailboxList(User_Mailbox_Location,lbMailItems);
  lbMailItemsClick(Sender);
end;

procedure TfrmMailbox.lbMailItemsClick(Sender: TObject);
var GroupName,GroupData:string;
begin
  MailboxViewer.Navigate('about:blank');
  if lbMailItems.Items.count>0 then begin
    GroupName := lbMailItems.Items[lbMailItems.ItemIndex];
    if GroupName='' then begin
      exit;
    end;
    LoadFaxGroup(MailboxViewer,USER_MAILBOX_LOCATION,GroupName,GroupData);
    //pnlData.Caption := GroupData;
  end;
end;

procedure TfrmMailbox.RefreshMailboxList(Path: string; FaxListBox:TListBox);
var
  Group: string;
  SR: TSearchRec;
  GroupList : TStringList;
  i : integer;
  ItemIndex: integer;
begin
  ItemIndex := FaxListBox.ItemIndex;
  FaxListBox.Items.Clear;
  GroupList := TStringList.Create();
  if FindFirst(Path+'*.png', faAnyFile, SR) = 0 then
  repeat
    GroupList.Add(Piece(SR.Name,'_',1));
  until FindNext(SR) <> 0;
  FindClose(SR);
  GroupList.Sort;
  Group := '';
  for i := 0 to GroupList.Count - 1 do begin
    if pos(Group,GroupList[i])=0 then begin
      Group := GroupList[i];
      FaxListBox.Items.Add(GroupList[i]);
    end;
  end;
  GroupList.Free;
  if ItemIndex < 0 then FaxListBox.ItemIndex := 0
  else if ItemIndex>FaxListBox.Count-1 then FaxListBox.ItemIndex := FaxListBox.Count-1
  else FaxListBox.ItemIndex := ItemIndex;
end;

procedure TfrmMailbox.LoadFaxGroup(WB: TWebBrowser; Path: string; GroupName: string; var Data: string);
var   HTMLFile: textfile;
      HTMLText: string;
      SR: TSearchRec;
      FileList:TStringList;
      i : integer;
begin
  FileList := TStringList.Create();
  HTMLText := '<html><head><title>'+GroupName+'</title></head><body>';
  //PageCount:=0;
  //FaxBarcodeFileName := '';
  if FindFirst(Path+GroupName+'*.png', faAnyFile, SR) = 0 then
  repeat
    if pos(GroupName,SR.Name)<>0 then begin
      FileList.Add(Path+SR.Name);
      //PageCount := PageCount + 1;
    end;
  until FindNext(SR) <> 0;
  FileList.Sort;
  for i := 0 to FileList.Count - 1 do begin
    HTMLText := HTMLText+'<img width=800 height=1200 src="'+FileList[i]+'">';
  end;
  FileList.Free;
  FindClose(SR);
  HTMLText := HTMLText+'</body></html>';

  AssignFile(HTMLFile,GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache\temp.html');
  Rewrite(HTMLFile);
  Write(HTMLFile,HTMLText);
  CloseFile(HTMLFile);

  if FZoom <> DEFAULT_ZOOM then begin
    FZoom := DEFAULT_ZOOM;
    ApplyZoom(FZoom,WB);
  end;

  WB.Navigate(GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache\temp.html');

  //Data := 'Location: '+Path+'     GroupName: '+GroupName+'     Number of pages: '+inttostr(PageCount)+'          Zoom @'+inttostr(FZoom)+'%';   //Not used anymore
  //lblLocation.Caption := 'Location: '+Path;
  //lblGroup.Caption := 'GroupName: '+GroupName;
  //lblNum.Caption := 'Number of pages: '+inttostr(PageCount);
  //lblZoom.Caption := 'Zoom: '+inttostr(FZoom)+' %';
end;

procedure TfrmMailbox.ApplyZoom(Zoom:integer;WB: TWebBrowser);
var
  pvaIn, pvaOut: OleVariant;
begin
  pvaIn := Zoom;
  pvaOut := Null;
  //pnlData.Caption := piece(pnlData.Caption,'@',1)+'@'+inttostr(Zoom)+'%';
  //lblZoom.Caption := 'Zoom: '+inttostr(Zoom)+' %';
  WB.ControlInterface.ExecWB(OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, pvaIn, pvaOut);
  Application.ProcessMessages;
end;

procedure TfrmMailbox.MailboxGroupAction();
var GroupName: string;
    SR: TSearchRec;
    MailBoxLoc: string;
    FileList: TStringList;
    i : integer;
begin
//mailDelete,mailImport,mailPrint,mailRotate,mailToMailbox
  {if MailboxAction=mailToMailbox then begin
      MailboxLoc := GetMailbox;
      if MailboxLoc = '' then exit;
      SendMessage(fMailboxPicker.FirstName,MailboxLoc);
      MailboxLoc := Fax_Location+MailboxLoc+'\';
      if not DirectoryExists(MailboxLoc) then begin
        if not CreateDir(MailboxLoc) then begin
          ShowMessage('Mailbox could not be accessed. Please contact IT');
          exit;
        end;
      end;
  end;}
  lblalert.Caption := '';
  lblAlert.Visible := True;
  GroupName := lbMailItems.Items[lbMailItems.ItemIndex];
  if GroupName='' then exit;
  FileList := TStringList.Create();
  FileList.Sorted := True;
  if FindFirst(USER_MAILBOX_LOCATION+GroupName+'*.png', faAnyFile, SR) = 0 then
  repeat
    FileList.Add(SR.Name);
  until FindNext(SR) <> 0;
  FindClose(SR);
  for i := 0 to FileList.Count - 1 do begin
    if pos(GroupName,FileList[i])<>0 then begin
      if MailboxAction=mailImport then
        MoveDocument(USER_MAILBOX_LOCATION,FileList[i],Pend_Consult_Loc)
      else if MailboxAction=mailPrint then
        PrintDocument(USER_MAILBOX_LOCATION,FileList[i])
      else if MailboxAction=mailDelete then
        DelDocument(USER_MAILBOX_LOCATION,FileList[i])
      else if MailboxAction=mailRotate then
        RotatePNGFile(USER_MAILBOX_LOCATION+FileList[i],lblAlert)
      else if MailboxAction=mailToMailbox then
        MoveDocument(USER_MAILBOX_LOCATION,FileList[i],MailboxLoc);
    end;
  end;
  if MailboxAction<>mailRotate then RefreshMailboxList(USER_MAILBOX_LOCATION,lbMailItems);
  lbMailItemsClick(self);
  //ShowMessage(inttostr(FileList.count));
  FileList.Free;
  lblalert.Visible := false;
  //CheckTIFs;
end;

procedure TfrmMailbox.DelDocument(const Path,DocToDelete : string) ;
begin
   lblAlert.Caption := 'Deleting: '+DocToDelete;
   Application.ProcessMessages;
   //DeleteFile(DocToDelete);  This will be used later when the trash is dumped
   MoveFile(PChar(Path+DocToDelete),PChar(TRASH_BIN+DocToDelete));
end;

procedure TfrmMailbox.MoveDocument(const Path,DocToMove,DestLoc : string) ;
begin
   lblAlert.Caption := 'Moving: '+DocToMove+' To: '+Path;
   Application.ProcessMessages;
   MoveFile(PChar(Path+DocToMove),PChar(DestLoc+DocToMove));
end;

procedure TfrmMailbox.PrintDocument(const Path,DocToPrint : string) ;
var
  printCommand : string;
  printerInfo : string;
  Device, Driver, Port: array[0..255] of Char;
  hDeviceMode: THandle;
  ScaleX, ScaleY: Integer;
  RR: TRect;
begin
  ImageToPrint.Picture.LoadFromFile(Path+DocToPrint);
  with Printer do begin
    BeginDoc;
    try
      lblAlert.Caption := 'Printing: '+DocToPrint;
      Application.ProcessMessages;
      ScaleX := GetDeviceCaps(Handle, logPixelsX) div PixelsPerInch;
      ScaleY := GetDeviceCaps(Handle, logPixelsY) div PixelsPerInch;
      //RR := Rect(0, 0, ImageToPrint.picture.Width * scaleX, ImageToPrint.Picture.Height * ScaleY);
      RR := Rect(0, 0, PageWidth, PageHeight);
      Canvas.StretchDraw(RR, ImageToPrint.Picture.Graphic);
    finally
      EndDoc;
    end;
  end;
  {Old Code Below
  printCommand := 'print';
  //Printer.GetPrinter(Device,Driver,Port,hDeviceMode);
  //printerInfo := Format('"%s" "%s" "%s"', [Device, Driver, Port]) ;
  printerInfo := '';
  lblAlert.Caption := 'Printing: '+DocToPrint;
  Application.ProcessMessages;
  ShellExecute(Application.Handle, PChar(printCommand), PChar(Path+DocToPrint), PChar(printerInfo), nil, SW_HIDE) ;
  //MoveFile(PChar(Path+DocToPrint),PChar(TRASH_BIN+DocToPrint));}
end;


procedure TfrmMailbox.RotatePNGFile(FileName: string;LabelName:TLabel) ;
    procedure Rot90(VAR BMPOrig,BMPMod:TBitMap);
    VAR i,j  : INTEGER;
        rowIn: pRGBLine;
    begin
       BMPOrig.PixelFormat:= pf24Bit;
       BMPMod.Width:= BMPOrig.Height;
       BMPMod.Height:= BMPOrig.Width;
       BMPMod.PixelFormat:= pf24Bit;
       // Out[Bottom - j - 1, i] = In[i, j]
       FOR j:= 0 TO BMPOrig.Height - 1 DO
       BEGIN
          rowIn:= BMPOrig.ScanLine[j];
          FOR i:= 0 TO BMPOrig.Width - 1 DO
            pRGBLine(BMPMod.Scanline[i])[BMPOrig.Height - j - 1] := rowIn[i];
       END;
    end;
VAR BMPIm,BMPMod:TBitMap;
    PNGIm:TPNGObject;  //Or maybe PNGImage?
begin
   // Create and load PNG image
   LabelName.Caption := 'Rotating: '+Filename;
   Application.ProcessMessages;
   PNGIm:= TPNGObject.Create;
   PNGIm.LoadFromFile(FileName);


   // Create and 'copy' PNG image to Bitmap
   BMPIm:= TBitMap.Create;
   BMPIm.Assign(PNGIm);
   BMPIm.PixelFormat:= pf24Bit;


   // Rotate to new image
   BMPMod:= TBitMap.Create;
   Rot90(BMPIm,BMPMod);


   // Copy Back modified BMP to PNG
   PNGIm.Assign(BMPMod);
   PNGIm.SaveToFile(FileName);


   //Image.Picture.Assign(BMPMod);
   // Free them
   BMPIm.Free;
   PNGIm.Free;
   LabelName.Caption := '';
end;



end.

