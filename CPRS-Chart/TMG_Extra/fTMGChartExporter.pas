unit fTMGChartExporter;
//kt added 7/22/18


interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ORNet, uCore,rConsults,
  Dialogs, fAutoSz, StdCtrls, ORCtrls, fConsult513Prt, VA508AccessibilityManager, rReports, ShellAPI,
  CheckLst, ComCtrls, ORDtTm, ORFn, OleCtrls, SHDocVw, ExtCtrls, Buttons, FileCtrl, Math,
  ImgList, uTMGOptions, Clipbrd;

type
  TfrmTMGChartExporter = class(TfrmAutoSz)
    pnlExportLeft: TPanel;
    ExportPageControl: TPageControl;
    Notes: TTabSheet;
    ckbxAll: TCheckBox;
    chkHighlightOnly: TCheckBox;
    dtNotesStart: TORDateBox;
    Label1: TLabel;
    Label2: TLabel;
    dtNotesEnd: TORDateBox;
    cklbTitles: TCheckListBox;
    Splitter1: TSplitter;
    pnlExportRight: TPanel;
    WebBrowser1: TWebBrowser;
    btnCancel: TBitBtn;
    btnExport: TBitBtn;
    tsLabs: TTabSheet;
    tsRadiology: TTabSheet;
    tsCover: TTabSheet;
    lstLabs: TCheckListBox;
    lstRad: TCheckListBox;
    Label3: TLabel;
    edtTo: TEdit;
    Label4: TLabel;
    edtToFax: TEdit;
    Label5: TLabel;
    edtRE: TEdit;
    Label6: TLabel;
    memComments: TMemo;
    dtLabsStartDt: TORDateBox;
    Label7: TLabel;
    Label8: TLabel;
    dtLabsEndDt: TORDateBox;
    btnPrint: TBitBtn;
    btnSave: TBitBtn;
    dtRadStartDt: TORDateBox;
    Label9: TLabel;
    Label10: TLabel;
    dtRadEndDt: TORDateBox;
    btnNext: TBitBtn;
    btnPrev: TBitBtn;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    radCoverGroup: TRadioGroup;
    lblCoverSheetToUse: TLabel;
    edtCoversheetFile: TEdit;
    OpenDialog1: TOpenDialog;
    btnSelectCover: TBitBtn;
    chkScanned: TCheckListBox;
    ViewScan: TWebBrowser;
    lstExtraFiles: TFileListBox;
    lstExtraFileToUpload: TListBox;
    cmbConsultants: TORComboBox;
    lblRefConsultant: TLabel;
    lblTemplateCoverSheet: TLabel;
    cmbTemplateCover: TORComboBox;
    DirectoryListBox1: TDirectoryListBox;
    cmbDrive: TDriveComboBox;
    btnNotesDateApply: TBitBtn;
    btnLabDatesApply: TBitBtn;
    btnRadDatesApply: TBitBtn;
    Splitter2: TSplitter;
    TabImageList: TImageList;
    btnListAdd: TBitBtn;
    btnListRemove: TBitBtn;
    btnListRemoveAll: TBitBtn;
    pnlExtraLeft: TPanel;
    ExtraSplitter: TSplitter;
    pnlExtraRight: TPanel;
    pnlCoverSheet: TPanel;
    pnlRefConsultant: TPanel;
    pnlTemplateCoversheet: TPanel;
    chkIncludeDemo: TCheckBox;
    tsOrders: TTabSheet;
    dtOrderEndDt: TORDateBox;
    dtOrderStartDt: TORDateBox;
    btnOrderDatesApply: TBitBtn;
    lstOrders: TCheckListBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    chkStoreData: TCheckBox;
    chkAllLabs: TCheckBox;
    cmbRecentFaxNumbers: TORComboBox;
    Label16: TLabel;
    chkCopyFaxNumber: TCheckBox;
    chkCheckAllRads: TCheckBox;
    procedure chkCheckAllRadsClick(Sender: TObject);
    procedure chkCopyFaxNumberClick(Sender: TObject);
    procedure cklbTitlesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cmbRecentFaxNumbersChange(Sender: TObject);
    procedure chkAllLabsClick(Sender: TObject);
    procedure edtREChange(Sender: TObject);
    procedure chkStoreDataClick(Sender: TObject);
    procedure edtToFaxChange(Sender: TObject);
    procedure edtToChange(Sender: TObject);
    procedure btnOrderDatesApplyClick(Sender: TObject);
    procedure pnlExportRightResize(Sender: TObject);
    procedure btnListRemoveClick(Sender: TObject);
    procedure btnListRemoveAllClick(Sender: TObject);
    procedure btnListAddClick(Sender: TObject);
    procedure btnPersonalPatientRAClick(Sender: TObject);
    procedure btnPersonalPatientRClick(Sender: TObject);
    procedure lstExtraFileToUploadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstExtraFilesClick(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure chkScannedClick(Sender: TObject);
    procedure btnSelectCoverClick(Sender: TObject);
    procedure radCoverGroupClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure ExportPageControlChange(Sender: TObject);
    procedure btnLoadRadClick(Sender: TObject);
    procedure btnLoadLabsClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure chkHighlightOnlyClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure dtNotesEndChange(Sender: TObject);
    procedure dtNotesStartChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cklbTitlesClick(Sender: TObject);
    procedure ckbxAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    //DATA STRINGLISTS
    DataSL: TStringList; //will be considered to be 1:1 linked to cklbTitles.items.  Format: IEN^DisplayTitle
    LabDataSL: TStringList;
    RadDataSL: TStringList;
    OrderDataSL: TStringList;
    ScannedDataSL: TStringList;
    ConsultsDataSL : TStringList;
    //ARRAYS TO HOLD PRINT LISTS
    NotesToPrint : TStringList;
    LabsToPrint : TStringList;
    RadToPrint : TStringList;
    OrdersToPrint : TStringList;
    ScansToPrint : TStringList;
    OtherDocToPrint : TStringList;
    DirtyForm:boolean;
    DownloadedFile : string;
    clTMGHighlight : TColor;
    //
    procedure LoadPrintLists;
    function AreSomeSelectedInList(ChkLBox:TCheckListBox) : boolean;
    function SomeSelected : boolean;
    //Load listboxes
    procedure LoadNoteListbox;
    procedure LoadLabsListbox;
    procedure LoadOtherLabsListbox;
    procedure LoadRadListbox;
    procedure LoadOrderListbox;
    procedure LoadScannedListbox;
    //
    procedure LoadSelectedIntoList(AList : TStringList; Checkbox: TCheckListBox; Data:TStringList);
    procedure LoadOthersIntoList;
    procedure SetButtonEnableStatus();
    procedure SetCoversheetVisibility();
  public
    { Public declarations }
    ATree: TORTreeView;
    PageID: Integer;
    SelectedNoteIEN: string;
  end;

var
  HLDPageID: Integer;
  PersistBeginDate:TFMDateTime;
  PersistEndDate:TFMDateTime;
  PersistCoverSheet : boolean;
  PersistTo,PersistFax,PersistRE : string;
  PersistCoverIndex : integer;
  AFrmTMGChartExporter: TfrmTMGChartExporter;


procedure ExportOneChart(InitialTab:integer);


implementation

{$R *.dfm}
uses
  uTIU, rTIU, uConst, fNotes, fNotePrt, fConsults, fDCSumm, fFrame, fUploadImages, fImages,
  uImages;

CONST
  COVER_NO_COVERSHEET = 0;
  COVER_DEFAULT_COVERSHEET = 1;
  COVER_UPLOAD_COVERSHEET = 2;
  COVER_CONSULTANT_COVERSHEET = 3;
  COVER_TEMPLATE_COVERSHEET = 4;

procedure ExportOneChart(InitialTab:integer);
  begin
  AFrmTMGChartExporter := TfrmTMGChartExporter.Create(Application);
  try
    if PersistBeginDate<1 then PersistBeginDate := DecFMDTDay(DateTimeToFMDateTime(Now),365);
    if PersistEndDate<1 then PersistEndDate := DateTimeToFMDateTime(Now);
    AFrmTMGChartExporter.dtNotesStart.FMDateTime := PersistBeginDate;
    AFrmTMGChartExporter.dtNotesEnd.FMDateTime := PersistEndDate;
    AFrmTMGChartExporter.dtLabsStartDt.FMDateTime := PersistBeginDate;
    AFrmTMGChartExporter.dtLabsEndDt.FMDateTime := PersistEndDate;
    AFrmTMGChartExporter.dtRadStartDt.FMDateTime := PersistBeginDate;
    AFrmTMGChartExporter.dtRadEndDt.FMDateTime := PersistEndDate;
    AFrmTMGChartExporter.dtOrderStartDt.FMDateTime := PersistBeginDate;
    AFrmTMGChartExporter.dtOrderEndDt.FMDateTime := PersistEndDate;
    if PersistCoverSheet then begin
      AFrmTMGChartExporter.edtTo.Text := PersistTo;
      AFrmTMGChartExporter.edtToFax.Text := PersistFax;
      AFrmTMGChartExporter.edtRE.Text := PersistRE;
      AFrmTMGChartExporter.chkStoreData.checked := PersistCoverSheet;
      AFrmTMGChartExporter.radCoverGroup.ItemIndex := PersistCoverIndex;
    end else begin
      AFrmTMGChartExporter.RadCoverGroup.ItemIndex := 1;
    end;
    //AFrmTMGChartExporter.ATree := ATree;
    AFrmTMGChartExporter.PageID := CT_Notes;
    //AFrmTMGChartExporter.btnApply.Enabled := False;
    AFrmTMGChartExporter.LoadNoteListbox;
    AFrmTMGChartExporter.LoadLabsListbox;
    AFrmTMGChartExporter.LoadRadListbox;
    // dont autoload orders. this speeds up loading AFrmTMGChartExporter.LoadOrderListbox;
    AFrmTMGChartExporter.LoadScannedListbox;
    AFrmTMGChartExporter.ExportPageControl.ActivePageIndex := 0;
    AFrmTMGChartExporter.RadCoverGroupClick(nil);
    AFrmTMGChartExporter.ExportPageControlChange(nil);
    AFrmTMGChartExporter.lstExtraFiles.Drive := 'C';
    AFrmTMGChartExporter.ExportPageControl.ActivePageIndex := InitialTab;
    AFrmTMGChartExporter.ShowModal;
    AFrmTMGChartExporter.Destroy;
  finally
    //
  end;
end;

//---------------------------------

procedure TfrmTMGChartExporter.FormCreate(Sender: TObject);
begin
  inherited;
  DataSL := TStringList.Create;
  LabDataSL := TStringList.Create;
  RadDataSL := TStringList.Create;
  OrderDataSL := TStringList.Create;
  ScannedDataSL := TStringList.Create;
  ConsultsDataSL := TStringList.Create;
  //
  NotesToPrint := TStringList.Create;
  LabsToPrint := TStringList.Create;
  RadToPrint := TStringList.Create;
  OrdersToPrint := TStringList.Create;
  ScansToPrint := TStringList.Create;
  OtherDocToPrint := TStringList.Create;
  SelectedNoteIEN := '';
end;

procedure TfrmTMGChartExporter.FormDestroy(Sender: TObject);
begin
  inherited;
  DataSL.Free;
  LabDataSL.Free;
  RadDataSL.Free;
  OrderDataSL.Free;
  ScannedDataSL.Free;
  ConsultsDataSL.Free;
  //
  NotesToPrint.Free;
  LabsToPrint.Free;
  RadToPrint.Free;
  OrdersToPrint.Free;
  ScansToPrint.Free;
  OtherDocToPrint.Free;
  //
  WebBrowser1.Navigate('about:blank');
  AFrmTMGChartExporter.Release;
end;

procedure TfrmTMGChartExporter.FormShow(Sender: TObject);
var RPCResults:TStringList;
    I : integer;
begin
  inherited;
  //NOT CURRENTLY USED -> tCallV(cmbTemplateCover.Items,'TMG CPRS EXPORT GET TEMPLATES',[]);
  RPCResults := TStringList.Create();
  tCallV(RPCResults,'TMG GET RECENT FAX NUMBERS',[Patient.DFN]);
  for I := 0 to RPCResults.Count - 1 do begin
    cmbRecentFaxNumbers.Items.Add(RPCResults[i]);
  end;
  RPCResults.free;
  cmbRecentFaxNumbers.Enabled := cmbRecentFaxNumbers.Items.Count>0  ;
  DirtyForm := False;
  clTMGHighlight := TColor(StringToColor(uTMGOptions.ReadString('color for TIU highlight','$FFFFB3')));
  chkCopyFaxNumber.checked := uTMGOptions.ReadBool('ChartExport_CopyFaxNum',False);
end;

//---------------FORM CONTROLS

procedure TfrmTMGChartExporter.btnApplyClick(Sender: TObject);
begin
  inherited;
  LoadNoteListbox;
  //btnApply.Enabled := false;
end;

procedure TfrmTMGChartExporter.btnCancelClick(Sender: TObject);
begin
  inherited;
  //AFrmTMGChartExporter.Release;
  if DirtyForm then begin
    if messagedlg('You haven''t printed or saved the current document.'+#13#10+'Are you sure you want to quit?',mtConfirmation,[mbYes,mbNo],0)=mrNo then exit;
  end;           
  Self.Modalresult := mrCancel;
  //self.Destroy;
end;

procedure TfrmTMGChartExporter.btnListAddClick(Sender: TObject);
var FileName:string;
begin
  inherited;
  if lstExtraFiles.FileName = '' then exit; //shouldn't be needed
  //FileName := ExtractFileName(lstExtraFiles.FileName);
  //Moved to the export function frmImages.UploadFile(lstExtraFiles.FileName,'',FileName,1,1);
  //ListBox1.Items.Add(FileName);
  lstExtraFileToUpload.Items.Add(lstExtraFiles.FileName);
  SetButtonEnableStatus();
end;

procedure TfrmTMGChartExporter.btnListRemoveAllClick(Sender: TObject);
begin
  inherited;
  lstExtraFileToUpload.Items.Clear;
  SetButtonEnableStatus();
end;

procedure TfrmTMGChartExporter.btnListRemoveClick(Sender: TObject);
begin
  inherited;
  lstExtraFileToUpload.Items.Delete(lstExtraFileToUpload.ItemIndex);
  SetButtonEnableStatus();
end;

procedure TfrmTMGChartExporter.btnLoadLabsClick(Sender: TObject);
begin
  LoadOtherLabsListbox;
end;

procedure TfrmTMGChartExporter.btnLoadRadClick(Sender: TObject);
begin
  inherited;
  LoadRadListbox;
end;

procedure TfrmTMGChartExporter.btnNextClick(Sender: TObject);
begin
  inherited;
  ExportPageControl.ActivePageIndex :=ExportPageControl.ActivePageIndex+1;
  ExportPageControlChange(nil);
end;

procedure TfrmTMGChartExporter.btnOrderDatesApplyClick(Sender: TObject);
begin
  inherited;
  LoadOrderListBox;
end;

procedure TfrmTMGChartExporter.btnPersonalPatientRAClick(Sender: TObject);
begin
  inherited;
  lstExtraFileToUpload.Items.Clear;
end;

procedure TfrmTMGChartExporter.btnPersonalPatientRClick(Sender: TObject);
begin
  inherited;
  lstExtraFileToUpload.Items.Delete(lstExtraFileToUpload.ItemIndex);
end;

procedure TfrmTMGChartExporter.btnPrevClick(Sender: TObject);
begin
  inherited;
  ExportPageControl.ActivePageIndex :=ExportPageControl.ActivePageIndex-1;
  ExportPageControlChange(nil);
end;

procedure TfrmTMGChartExporter.btnPrintClick(Sender: TObject);
begin
  inherited;
  ShellExecute(0, 'open', 'acrord32', PChar('/p /h ' + DownloadedFile), nil, SW_HIDE);
  //ShellExecute(0, 'printto', PChar(DownloadedFile),PChar('192.168.3.204') ,nil, SW_HIDE);
  DirtyForm := false;
end;

procedure TfrmTMGChartExporter.btnSaveClick(Sender: TObject);
var SaveDialog : TSaveDialog;
    FDir : string;
    CopyResult : boolean;
begin
  inherited;
  if SelectDirectory('Select Directory', ExtractFileDrive(FDir), FDir, [sdNewUI, sdNewFolder]) then begin
    //ShowMessage(FDir);
    CopyResult := CopyFile(PChar(DownloadedFile),PChar(FDir+'/'+piece(Patient.Name,' ',1)+'-ChartExport.pdf'),true);
    if CopyResult=False then
       ShowMessage('File copy failed. Ensure you have writing privileges for the selected folder.')
    else
       DirtyForm := False;
  end;
end;

procedure TfrmTMGChartExporter.btnSelectCoverClick(Sender: TObject);
var FileName:string;
begin
  inherited;
  OpenDialog1.InitialDir := 'C:\';
  OpenDialog1.Filter := 'Pdf|*.pdf';
  if OpenDialog1.Execute then begin
    //FileName := ExtractFileName(OpenDialog1.FileName);
    //Moved to the Export function frmImages.UploadFile(OpenDialog1.FileName,'',FileName,1,1);
    edtCoverSheetFile.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmTMGChartExporter.btnExportClick(Sender: TObject);
var ExportResult:string;
    Consultant:string;
    FileName:string;
    i : integer;
    AlertText : string;
begin
  inherited;
    AlertText := '';
    if edtTo.Text='' then begin
      edtTo.Color := clYellow;
      AlertText := 'Missing entry for Send To';
    end;
    if edtToFax.Text='' then begin
      edtToFax.Color := clYellow;
      if AlertText<>'' then AlertText := AlertText+',';
      AlertText := AlertText+'Missing entry for Fax Number ';
    end;
    if AlertText<>'' then begin
      messagedlg('Cannot export due to: '+#13#10+AlertText,mtError,[mbOk],0);
      ExportPageControl.ActivePageIndex := 0;
      exit;
    end;

    AFrmTMGChartExporter.WebBrowser1.Navigate('about:blank');
    Application.ProcessMessages;
    if radCoverGroup.ItemIndex = COVER_UPLOAD_COVERSHEET then begin
      FileName := ExtractFileName(edtCoversheetFile.text);
      uImages.UploadFile(edtCoversheetFile.text,'',FileName,1,1);
    end;
    for i := 0 to lstExtraFileToUpload.items.count - 1 do begin
      FileName := ExtractFileName(lstExtraFileToUpload.Items[i]);
      uImages.UploadFile(lstExtraFileToUpload.Items[i],'',FileName,1,1);
    end;
    LoadPrintLists;
    if cmbConsultants.ItemIndex>-1 then
      Consultant := ConsultsDataSL[cmbConsultants.ItemIndex]
    else
      Consultant := '';
    ExportResult := ExportChart(NotesToPrint,LabsToPrint,RadToPrint,OrdersToPrint,ScansToPrint,OtherDocToPrint,edtTo.Text,edtToFax.Text,edtRE.text,inttostr(radCoverGroup.ItemIndex),ExtractFileName(edtCoversheetFile.text),Consultant,cmbTemplateCover.ItemID,booltostr(chkIncludeDemo.checked),memComments.Lines);
    if piece(ExportResult,'^',1)='1' then begin
      DownloadedFile := piece(ExportResult,'^',2);
      AFrmTMGChartExporter.WebBrowser1.Navigate(DownloadedFile);
    end;
    if chkCopyFaxNumber.Checked then begin
      ClipBoard.Clear;
      ClipBoard.AsText := edtToFax.Text;
    end;
    
    DirtyForm := True;
end;

procedure TfrmTMGChartExporter.chkAllLabsClick(Sender: TObject);
const
  CKBTN_LABEL : array [false .. true] of string = ('Select','Deselect');
var
  i : integer;
begin
  inherited;
  chkAllLabs.Caption := CKBTN_LABEL[chkAllLabs.Checked] + ' &All';
  for i := 0 to lstLabs.Items.Count - 1 do begin
    lstLabs.Checked[i] := chkAllLabs.Checked;
  end;
end;

procedure TfrmTMGChartExporter.chkCheckAllRadsClick(Sender: TObject);
const
  CKBTN_LABEL : array [false .. true] of string = ('Select','Deselect');
var
  i : integer;
begin
  inherited;
  chkCheckAllRads.Caption := CKBTN_LABEL[chkCheckAllRads.Checked] + ' &All';
  for i := 0 to lstRad.Items.Count - 1 do begin
    lstRad.Checked[i] := chkCheckAllRads.Checked;
  end;
end;

procedure TfrmTMGChartExporter.chkCopyFaxNumberClick(Sender: TObject);
begin
  inherited;
  uTMGOptions.WriteBool('ChartExport_CopyFaxNum',chkCopyFaxNumber.Checked);
end;

procedure TfrmTMGChartExporter.chkHighlightOnlyClick(Sender: TObject);

    function IgnoreTitle(Title:string):boolean;
    //This is a very crud function. It could be fleshed out better, but with the small amount of time it will be used it isn't worth making an RPC
    begin
        result := False;
        if Title='PHONE NOTE' then result := True;
        if Title='RECORDS SENT (IMAGE)' then result := True;
        if Title='CONSULTANT VISIT NOT KEPT' then result := True;
        if Title='INSURANCE NOTE' then result := True;
        if Title='LETTER' then result := True;
        if Title='RECORDS SENT' then result := True;
        if Title='TICKLER' then result := True;
        if Title='CANCELLED APPT' then result := True;
        if Title='INSURANCE CARD (IMAGE)' then result := True;
        if Title='HIPAA AGREEMENT (IMAGE)' then result := True;
        if Title='NOTE' then result := True;
        if Title='NURSE NOTE' then result := True;
        if Title='CPE EXPLANATION' then result := True;
        if Title='ADVANCE DIRECTIVES (IMAGE)' then result := True;
        if Title='NO SHOW' then result := True;
        if Title='CANCELLED APPOINTMENT' then result := True;
        if Title='CANCELLED APPT' then result := True;
        if Title='NURSE ORDER' then result := True;
        if Title='OUTSIDE ORDER (IMAGE)' then result := True;                    
    end;
const
  //HIGHLIGHT_LABEL : array [false .. true] of string = ('Show Highlighted Items Only','Show All Items');
  HIGHLIGHT_LABEL : array [false .. true] of string = ('Select All (Ignoring Admin Notes)','Deselect All');
var
  i : integer;
  Ignore:boolean;
begin
  inherited;
  chkHighlightOnly.Caption := HIGHLIGHT_LABEL[chkHighlightOnly.checked];
  for i := 0 to cklbTitles.Items.Count - 1 do begin
    Ignore := IgnoreTitle(piece(piece(DataSL[i],'^',2),';',1));
    if (Ignore=True)and chkHighlightOnly.Checked then continue;
    cklbTitles.Checked[i] := chkHighlightOnly.Checked;
  end;
  btnExport.Enabled := chkHighlightOnly.Checked;
  //LoadNoteListbox;
end;

procedure TfrmTMGChartExporter.chkScannedClick(Sender: TObject);
  procedure WBLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string) ;
    var
       MyHTML: TStringList;
       TempFile: string;
    begin
       MyHTML := TStringList.create;
       //TempFile := ExtractFilePath(ParamStr(0))+ 'Cache'+'\Temp.html';
       TempFile := GetEnvironmentVariable('USERPROFILE')+'\.CPRS\Cache\Temp.html';
       try
         MyHTML.add(HTMLCode);
         MyHTML.SaveToFile(TempFile);
        finally
         MyHTML.Free;
        end;
       WebBrowser.Navigate(TempFile) ;

       while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
        Application.ProcessMessages;
    end;  {WBLoadHTML}
var HTML:String;
begin
  inherited;
  HTML := '<embed src="http://192.168.3.99:9080'+Piece(ScannedDataSL[chkScanned.ItemIndex], '^', 18)+'" width="800px" height="1200px" />';
  WBLoadHTML(ViewScan,HTML);
end;

procedure TfrmTMGChartExporter.chkStoreDataClick(Sender: TObject);
begin
  inherited;
  PersistCoverSheet := chkStoreData.Checked;
end;

procedure TfrmTMGChartExporter.ckbxAllClick(Sender: TObject);
const
  CKBTN_LABEL : array [false .. true] of string = ('Select','Deselect');
var
  i : integer;
begin
  inherited;
  ckbxAll.Caption := CKBTN_LABEL[ckbxAll.Checked] + ' &All';
  for i := 0 to cklbTitles.Items.Count - 1 do begin
    cklbTitles.Checked[i] := ckbxAll.Checked;
  end;
  btnExport.Enabled := ckbxAll.Checked;
end;


function TfrmTMGChartExporter.AreSomeSelectedInList(ChkLBox:TCheckListBox) : boolean;
var
  i : integer;
begin
  Result := false;
  for i := 0 to ChkLBox.Items.Count - 1 do begin
    if not ChkLBox.Checked[i] then continue;
    //Result := piece(DataSL[i], U, 1);
    Result := True;
    break;
  end;
end;

function TfrmTMGChartExporter.SomeSelected : boolean;
begin
  Result := (AreSomeSelectedInList(cklbTitles)) or (AreSomeSelectedInList(lstLabs)) or (AreSomeSelectedInList(lstRad)) or (AreSomeSelectedInList(lstOrders));
  if (Result=False) and (radCoverGroup.ItemIndex>0) then Result := True;
end;

procedure TfrmTMGChartExporter.cklbTitlesClick(Sender: TObject);
begin
  inherited;
  btnExport.Enabled := SomeSelected;
end;

procedure TfrmTMGChartExporter.cklbTitlesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
//kt added 6/15
  function LeftMatch(SubStr, Str : string) : boolean;
  begin
    Result := (Pos(SubStr, Str) = 1) and (Length (SubStr) <= Length(Str));
  end;

var s, ThisIEN, SelectedIEN, ParentTitle,ItemText : string;
    ThisColor:TColor;
begin
  inherited;
  if not assigned(DataSL) then exit;
  s := DataSL[index];
  ThisColor := clWindow;
  //ELH added to highlight office notes
  if piece(s,'^',16)='1' then begin
     ThisColor := clTMGHighlight;  //server side set
  end;
  if piece(s,'^',17)<>'' then begin
     ThisColor := TColor(StringToColor(piece(s,'^',17)));  //TColor(StringToColor(uTMGOptions.ReadString(piece(TORTreeNode(Node).StringData,'^',17),'$4E9CFF')));
  end;
  cklbTitles.Canvas.Brush.Color := ThisColor;
  cklbTitles.Canvas.FillRect(Rect);
  ItemText := cklbTitles.Items[Index];
  cklbTitles.Canvas.TextOut(Rect.Left + 1,Rect.Top,ItemText);
  //ELH added to highlight other colors
  {if piece(TORTreeNode(Node).StringData,'^',17)<>'' then begin
     clTMGHospitalColor := TColor(StringToColor(piece(TORTreeNode(Node).StringData,'^',17)));//TColor(StringToColor(uTMGOptions.ReadString(piece(TORTreeNode(Node).StringData,'^',17),'$4E9CFF')));
     tvNotes.Canvas.Brush.Color := clTMGHospitalColor;  //server side set
  end;

  if not assigned(tvNotes.Selected) then exit;
  if pos('Loose documents (',piece(TORTreeNode(Node).StringData,'^',2))>0 then begin
       tvNotes.Canvas.Brush.Color := clWebRed;  //server side set
  end;
  if pos('Loose notes (',piece(TORTreeNode(Node).StringData,'^',2))>0 then begin
       tvNotes.Canvas.Brush.Color := clWebRed;  //server side set
  end;
  SelectedIEN := piece(TORTreeNode(tvNotes.Selected).StringData, '^', 1);
  ThisIEN := piece(TORTreeNode(Node).StringData, '^', 1);
  if (ThisIEN = SelectedIEN) and (ThisIEN <> '') then begin
    //tvNotes.Canvas.Brush.Color := clSkyBlue;
    tvNotes.Canvas.Brush.Color := clHighlight;
    tvNotes.Canvas.Font.Color := clMenuText;
  end;       }
end;

procedure TfrmTMGChartExporter.cmbRecentFaxNumbersChange(Sender: TObject);
var FaxTo,FaxNumber:string;
begin
  inherited;
  if cmbRecentFaxNumbers.Text='' then exit;
  edtTo.Text := piece2(cmbRecentFaxNumbers.Text,' = ',1);
  edtToFax.Text := piece2(cmbRecentFaxNumbers.Text,' = ',2);
end;

procedure TfrmTMGChartExporter.DirectoryListBox1Change(Sender: TObject);
begin
  inherited;
  SetButtonEnableStatus();
end;

procedure TfrmTMGChartExporter.dtNotesEndChange(Sender: TObject);
begin
  inherited;
  PersistEndDate := dtNotesEnd.FMDateTime;
  //btnApply.Enabled := true;
end;

procedure TfrmTMGChartExporter.dtNotesStartChange(Sender: TObject);
begin
  inherited;
  PersistBeginDate := dtNotesStart.FMDateTime;
  //btnApply.Enabled := true;
end;

procedure TfrmTMGChartExporter.edtREChange(Sender: TObject);
begin
  inherited;
  PersistRE := edtRe.Text;
end;

procedure TfrmTMGChartExporter.edtToChange(Sender: TObject);
begin
  inherited;
  edtTo.Color := clWindow;
  PersistTo := edtTo.Text;
end;

procedure TfrmTMGChartExporter.edtToFaxChange(Sender: TObject);
begin
  inherited;
  edtToFax.color := clWindow;
  PersistFax := edtToFax.Text;
end;

//----PROCEDURES TO LOAD THE LISTBOXES

procedure TfrmTMGChartExporter.LoadNoteListbox;
var
  i, AnImg: integer;
  x, TitleName: string;
  HighlightedItem : boolean;
  ThisDate:TFMdatetime;
  tmpList:TStringList;
begin
  HLDPageID := PageID;
  ResizeFormToFont(TForm(self));
  DataSL.Clear;
  cklbTitles.Clear;
  cklbTitles.Sorted := FALSE;
  tmpList := TStringList.create();

  ListNotesForTree(tmpList, 1, dtNotesStart.FMDateTime, dtNotesEnd.FMDateTime, 0, 99999, False);
  //FilterTitlesForHidden(tmpList,HiddenCount); //kt added
  //if btnAdminDocs.Down then FilterTitlesForAdmin(tmpList,HiddenCount); //elh added 1/24/17
  //CreateListItemsforDocumentTree(FDocList, tmpList, StrToIntDef(Status, 0), GroupBy, TreeAscending, CT_NOTES);

  for i := 0 to tmpList.Count - 1 do begin
     x := tmpList[i];
     ThisDate := strtofloat(piece(x,'^',3));
     if (ThisDate>dtNotesStart.FMDateTime) AND (ThisDate<dtNotesEnd.FMDateTime) then begin
       TitleName := MakeNoteDisplayText(x);
       if pos('Addendum to',TitleName)>0 then continue;  //don't include addendums as they will be in the parent note         
       DataSL.Add(x);
       cklbTitles.Items.Add(TitleName);
      end;
  end;
  tmplist.free;

end;

procedure TfrmTMGChartExporter.LoadScannedListbox;
var
  i, AnImg: integer;
  x, TitleName: string;
  HighlightedItem : boolean;
  ThisDate:TFMdatetime;
  tmpList:TStringList;
begin
  HLDPageID := PageID;
  ResizeFormToFont(TForm(self));
  ScannedDataSL.Clear;
  chkScanned.Clear;
  chkScanned.Sorted := FALSE;
  tmpList := TStringList.create();

  ListNotesForTree(tmpList, 9, dtNotesStart.FMDateTime, dtNotesEnd.FMDateTime, 0, 99999, False);

  for i := 0 to tmpList.Count - 1 do begin
     x := tmpList[i];
     ThisDate := strtofloat(piece(x,'^',3));
     TitleName := MakeNoteDisplayText(x);
     ScannedDataSL.Add(x);
     chkScanned.Items.Add(TitleName);
  end;
  tmplist.free;

end;


procedure TfrmTMGChartExporter.lstExtraFileToUploadClick(Sender: TObject);
begin
  inherited;
  SetButtonEnableStatus();
end;

procedure TfrmTMGChartExporter.LoadLabsListbox;
var RPCResults:TStringList;
    i : integer;
    x,TitleName : string;
    ThisDate:TFMdatetime;
begin
  inherited;
  LabDataSL.Clear;
  lstLabs.Clear;
  lstLabs.Sorted := FALSE;
  RPCResults := TStringList.Create();
  //tCallV(RPCResults,'TMG CPRS LAB GET DATES',[Patient.DFN,'1']);
  tCallV(RPCResults,'TMG CPRS LAB PDF LIST',[Patient.DFN,dtLabsStartDt.FMDateTime,dtLabsEndDt.FMDateTime,'1']);
  RPCResults.Delete(0);
  for i := 0 to RPCResults.Count - 1 do begin
   x := RPCResults[i];
   //ThisDate := strtofloat(piece(x,'^',1));
   //if (ThisDate>dtNotesStart.FMDateTime) AND (ThisDate<dtNotesEnd.FMDateTime) then begin
     //TitleName := FormatFMDateTime('mm/dd/yy', strtofloat(piece(x,'^',1)))+' '+piece(x,'^',2);
   LabDataSL.Add(piece(x,'^',2)+'^'+piece(x,'^',3));
   TitleName :=FormatFMDateTime('mmm dd, yyyy hh:nn', strtofloat(piece(x,'^',4)));
   if pos('00:00',TitleName)>0 then TitleName:=TitleName+' Outside lab results';
   lstLabs.Items.Add(TitleName);
   //end;
  end;
  RPCResults.free;
end;

procedure TfrmTMGChartExporter.LoadOtherLabsListbox;
var RPCResults:TStringList;
    i : integer;
    x,TitleName : string;
    ThisDate:TFMdatetime;
begin
  inherited;
  LoadLabsListbox;
end;

procedure TfrmTMGChartExporter.LoadRadListbox;
var RadList : TStringList;
    i : integer;
    BDate,EDate,RadDate:TDateTime;
begin
  RadDataSL.Clear;
  lstRad.Clear;
  RadList := TStringList.create();
  ListImagingExams(RadList);
  BDate := FMDateTimeToDateTime(dtRadStartDt.FMDateTime);
  EDate := FMDateTimeToDateTime(dtRadEndDt.FMDateTime);
  for I := 0 to RadList.Count - 1 do begin
    //check data here
     RadDate := strtodatetime(piece(RadList[i],'^',3));
     if (RadDate>BDate)and(RadDate<EDate) then begin
       lstRad.Items.Add(piece(RadList[i],'^',3)+' '+piece(RadList[i],'^',4));
       RadDataSL.Add(piece(piece(RadList[i],'^',2),'i',2)+'#'+piece(RadList[i],'^',7));
     end;
  end;
  RadList.Free;
end;

procedure TfrmTMGChartExporter.LoadOrderListbox;
var OrderList : TStringList;
    i : integer;
    ID,OrderTime:string;
    OrderTextSL:TStringList;
begin
  OrderDataSL.Clear;
  lstOrders.Clear;
  OrderList := TStringList.create();
  OrderTextSL := TStringList.Create();
  // Get Orders Here ListImagingExams(RadList);
  tCallV(OrderList,'ORWORR AGET', [Patient.DFN,'2^0','1','0','0','0']);
  for I := 0 to OrderList.Count - 1 do begin
    //check data here
    if (piece(OrderList[i], '^', 1) = '0') or (Piece(OrderList[i], '^', 1) = '') then Continue;
    if (DelimCount(OrderList[i],'^') = 2) then Continue;
    ID := Piece(OrderList[i], U, 1);
    //OrderTime := MakeFMDateTime(Piece(OrderList[i], U, 3));
    OrderTime := Piece(OrderList[i], U, 3);
    tCallV(OrderTextSL,'ORQOR DETAIL', [ID, Patient.DFN]);
    //lstOrders.Items.Add(piece2(piece2(OrderTextSL.Text),'Order Text;',2),'Nature of Order',1);
    lstOrders.Items.Add(piece2(OrderTextSL.Text,'Activity',1));
    OrderDataSL.Add(ID);
  end;
  OrderList.Free;
  OrderTextSL.Free;
end;
//----PROCEDURES TO POPULATE ARRAYS FOR EXPORTING

procedure TfrmTMGChartExporter.LoadSelectedIntoList(AList : TStringList; Checkbox: TCheckListBox; Data:TStringList);
var
  i : integer;
begin
  AList.Clear;
  for i := 0 to Checkbox.Items.Count - 1 do begin
    if not Checkbox.Checked[i] then continue;
    AList.Add(Data[i]);  // Format: IEN^DisplayTitle
  end;
end;

procedure TfrmTMGChartExporter.lstExtraFilesClick(Sender: TObject);
begin
  inherited;
  SetButtonEnableStatus();
end;

procedure TfrmTMGChartExporter.pnlExportRightResize(Sender: TObject);
var  SpaceWidth, BtnWidth : integer;
const SPACING = 5;
begin
  inherited;
  SpaceWidth := pnlExportRight.Width - SPACING * 4;
  BtnWidth := Floor(SpaceWidth / 3);
  btnPrint.Left := SPACING;
  btnPrint.Width := BtnWidth;
  btnSave.Left := SPACING + btnPrint.Width + SPACING;
  btnSave.Width := BtnWidth;
  btnCancel.Left := SPACING + btnPrint.Width + SPACING + btnSave.Width + SPACING;
  btnCancel.Width := BtnWidth;
end;

procedure TfrmTMGChartExporter.SetButtonEnableStatus();
begin
  btnListAdd.Enabled := (lstExtraFiles.ItemIndex>-1);
  btnListRemoveAll.Enabled := (lstExtraFileToUpload.Items.Count > 0);
  btnListRemove.Enabled  := (lstExtraFileToUpload.ItemIndex>-1);
end;


procedure TfrmTMGChartExporter.ExportPageControlChange(Sender: TObject);
begin
  inherited;
  btnPrev.Enabled := (ExportPageControl.ActivePageIndex>0);
  btnNext.Enabled := (ExportPageControl.ActivePageIndex<ExportPageControl.PageCount-1);
end;

procedure TfrmTMGChartExporter.radCoverGroupClick(Sender: TObject);
var tmpList:TStringList;
    i : integer;
begin
  inherited;
  case radCoverGroup.ItemIndex of
    COVER_NO_COVERSHEET: begin

    end;
    COVER_DEFAULT_COVERSHEET: begin

    end;
    COVER_UPLOAD_COVERSHEET: begin

    end;
    COVER_CONSULTANT_COVERSHEET: begin
      tmpList := TStringList.Create();
      GetConsultsList(tmpList, 0, 0, '', '', False);
      for i := 0 to tmpList.Count - 1 do begin
        ConsultsDataSL.Add(tmpList[i]);
        cmbConsultants.Items.Add(piece(tmpList[i],'^',2)+' '+piece(tmpList[i],'^',3)+' '+piece(tmpList[i],'^',4));
      end;
      tmpList.Free;
    end;
    COVER_TEMPLATE_COVERSHEET: begin
       //Load Template List
    end;
  end;
  SetCoversheetVisibility();
  cklbTitlesClick(Sender);
  PersistCoverIndex := radCoverGroup.ItemIndex;
end;

procedure TfrmTMGChartExporter.SetCoversheetVisibility();
var Top : integer;
const SPACING = 5;
begin
  Top := radCoverGroup.Top + radCoverGroup.Height + SPACING;

  //edtCoverSheetFile.Enabled := (radCoverGroup.ItemIndex=2);
  //btnSelectCover.enabled := (radCoverGroup.ItemIndex=2);
  //cmbConsultants.enabled := (radCoverGroup.ItemIndex=3);
  ////chkIncludeDemo.enabled := (radCoverGroup.ItemIndex=3); Include for all covers
  //cmbTemplateCover.enabled := (radCoverGroup.ItemIndex=4);

  case radCoverGroup.ItemIndex of
    COVER_NO_COVERSHEET: begin
      pnlCoverSheet.Visible := false;
      pnlRefConsultant.Visible := false;
      pnlTemplateCoversheet.Visible := false;
    end;
    COVER_DEFAULT_COVERSHEET: begin
      pnlCoverSheet.Visible := false;
      pnlRefConsultant.Visible := false;
      pnlTemplateCoversheet.Visible := false;
    end;
    COVER_UPLOAD_COVERSHEET: begin
      pnlCoverSheet.Visible := true;
      pnlCoverSheet.Top := Top;
      pnlCoverSheet.Color := clBtnFace;
      pnlCoverSheet.Left := 3;
      //-----------------------------------
      pnlRefConsultant.Visible := false;
      pnlTemplateCoversheet.Visible := false;
    end;
    COVER_CONSULTANT_COVERSHEET: begin
      pnlCoverSheet.Visible := false;
      //-----------------------------------
      pnlRefConsultant.Visible := true;
      pnlRefConsultant.Top := Top;
      pnlRefConsultant.Color := clBtnFace;
      pnlRefConsultant.Left := 3;
      //-----------------------------------
      pnlTemplateCoversheet.Visible := false;
    end;
    COVER_TEMPLATE_COVERSHEET: begin
      pnlCoverSheet.Visible := false;
      pnlRefConsultant.Visible := false;
      //-----------------------------------
      pnlTemplateCoversheet.Visible := True;
      pnlTemplateCoversheet.Top := Top;
      pnlTemplateCoversheet.Color := clBtnFace;
      pnlTemplateCoversheet.Left := 3;
    end;
  end;


end;

procedure TfrmTMGChartExporter.LoadOthersIntoList;
var
  i : integer;
begin
  OtherDocToPrint.Clear;
  for i := 0 to lstExtraFileToUpload.Items.Count - 1 do begin
    OtherDocToPrint.Add(ExtractFileName(lstExtraFileToUpload.Items[i]));
  end;
end;

procedure TfrmTMGChartExporter.LoadPrintLists;
begin
  LoadSelectedIntoList(NotesToPrint,cklbTitles,DataSL);
  LoadSelectedIntoList(LabsToPrint,lstLabs,LabDataSL);
  LoadSelectedIntoList(RadToPrint,lstRad,RadDataSL);
  LoadSelectedIntoList(OrdersToPrint,lstOrders,OrderDataSL);
  LoadSelectedIntoList(ScansToPrint,chkScanned,ScannedDataSL);
  LoadOthersIntoList;
end;

end.


