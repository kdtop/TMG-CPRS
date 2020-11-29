unit fTMGChartExporter;
//kt added 7/22/18


interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ORNet, uCore,rConsults,
  Dialogs, fAutoSz, StdCtrls, ORCtrls, fConsult513Prt, VA508AccessibilityManager, rReports, ShellAPI,
  CheckLst, ComCtrls, ORDtTm, ORFn, OleCtrls, SHDocVw, ExtCtrls, Buttons, FileCtrl, Math,
  ImgList;

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
    ScannedDataSL: TStringList;
    ConsultsDataSL : TStringList;
    //ARRAYS TO HOLD PRINT LISTS
    NotesToPrint : TStringList;
    LabsToPrint : TStringList;
    RadToPrint : TStringList;
    ScansToPrint : TStringList;
    OtherDocToPrint : TStringList;
    DirtyForm:boolean;
    DownloadedFile : string;
    //
    procedure LoadPrintLists;
    function FirstSelectedIEN : string;
    function SomeSelected : boolean;
    //Load listboxes
    procedure LoadNoteListbox;
    procedure LoadLabsListbox;
    procedure LoadRadListbox;
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
  AFrmTMGChartExporter: TfrmTMGChartExporter;


procedure ExportOneChart(ATree: TORTreeView);


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

procedure ExportOneChart(ATree: TORTreeView);
  begin
  AFrmTMGChartExporter := TfrmTMGChartExporter.Create(Application);
  try
    if PersistBeginDate<1 then PersistBeginDate := 3190101;
    if PersistEndDate<1 then PersistEndDate := 3201201;
    AFrmTMGChartExporter.dtNotesStart.FMDateTime := PersistBeginDate;
    AFrmTMGChartExporter.dtNotesEnd.FMDateTime := PersistEndDate;
    AFrmTMGChartExporter.dtLabsStartDt.FMDateTime := PersistBeginDate;
    AFrmTMGChartExporter.dtLabsEndDt.FMDateTime := PersistEndDate;
    AFrmTMGChartExporter.dtRadStartDt.FMDateTime := PersistBeginDate;
    AFrmTMGChartExporter.dtRadEndDt.FMDateTime := PersistEndDate;
    AFrmTMGChartExporter.ATree := ATree;
    AFrmTMGChartExporter.PageID := CT_Notes;
    //AFrmTMGChartExporter.btnApply.Enabled := False;
    AFrmTMGChartExporter.LoadNoteListbox;
    AFrmTMGChartExporter.LoadLabsListbox;
    AFrmTMGChartExporter.LoadRadListbox;
    AFrmTMGChartExporter.LoadScannedListbox;
    AFrmTMGChartExporter.ExportPageControl.ActivePageIndex := 0;
    AFrmTMGChartExporter.RadCoverGroup.ItemIndex := 1;
    AFrmTMGChartExporter.RadCoverGroupClick(nil);
    AFrmTMGChartExporter.ExportPageControlChange(nil);
    AFrmTMGChartExporter.lstExtraFiles.Drive := 'C';
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
  ScannedDataSL := TStringList.Create;
  ConsultsDataSL := TStringList.Create;
  //
  NotesToPrint := TStringList.Create;
  LabsToPrint := TStringList.Create;
  RadToPrint := TStringList.Create;
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
  ScannedDataSL.Free;
  ConsultsDataSL.Free;
  //
  NotesToPrint.Free;
  LabsToPrint.Free;
  RadToPrint.Free;
  ScansToPrint.Free;
  OtherDocToPrint.Free;
  //
  WebBrowser1.Navigate('about:blank');
  AFrmTMGChartExporter.Release;
end;

procedure TfrmTMGChartExporter.FormShow(Sender: TObject);
begin
  inherited;
  tCallV(cmbTemplateCover.Items,'TMG CPRS EXPORT GET TEMPLATES',[]);
  DirtyForm := False;
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
  LoadLabsListbox;
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
begin
  inherited;
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
    ExportResult := ExportChart(NotesToPrint,LabsToPrint,RadToPrint,ScansToPrint,OtherDocToPrint,edtTo.Text,edtToFax.Text,edtRE.text,inttostr(radCoverGroup.ItemIndex),ExtractFileName(edtCoversheetFile.text),Consultant,cmbTemplateCover.ItemID,booltostr(chkIncludeDemo.checked),memComments.Lines);
    if piece(ExportResult,'^',1)='1' then begin
      DownloadedFile := piece(ExportResult,'^',2);
      AFrmTMGChartExporter.WebBrowser1.Navigate(DownloadedFile);
    end;
    DirtyForm := True;
end;

procedure TfrmTMGChartExporter.chkHighlightOnlyClick(Sender: TObject);
const
  HIGHLIGHT_LABEL : array [false .. true] of string = ('Show Highlighted Items Only','Show All Items');
begin
  inherited;
  chkHighlightOnly.Caption := HIGHLIGHT_LABEL[chkHighlightOnly.checked];
  LoadNoteListbox;
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


function TfrmTMGChartExporter.FirstSelectedIEN : string;
var
  i : integer;
begin
  Result := '';
  for i := 0 to cklbTitles.Items.Count - 1 do begin
    if not cklbTitles.Selected[i] then continue;
    Result := piece(DataSL[i], U, 1);
    break;
  end;
end;

function TfrmTMGChartExporter.SomeSelected : boolean;
begin
  Result := (FirstSelectedIEN <> '');
end;

procedure TfrmTMGChartExporter.cklbTitlesClick(Sender: TObject);
begin
  inherited;
  btnExport.Enabled := SomeSelected;
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
  tCallV(RPCResults,'TMG CPRS LAB GET DATES',[Patient.DFN,'1']);
  for i := 0 to RPCResults.Count - 1 do begin
   x := RPCResults[i];
   ThisDate := strtofloat(piece(x,'^',1));
   if (ThisDate>dtNotesStart.FMDateTime) AND (ThisDate<dtNotesEnd.FMDateTime) then begin
     TitleName := FormatFMDateTime('mm/dd/yy', strtofloat(piece(x,'^',1)))+' '+piece(x,'^',2);
     LabDataSL.Add(piece(x,'^',1));
     lstLabs.Items.Add(TitleName);
   end;
  end;
  RPCResults.free;
end;

procedure TfrmTMGChartExporter.LoadRadListbox;
var RadList : TStringList;
    i : integer;
begin
  RadDataSL.Clear;
  lstRad.Clear;
  RadList := TStringList.create();
  ListImagingExams(RadList);
  for I := 0 to RadList.Count - 1 do begin
    //check data here
     lstRad.Items.Add(piece(RadList[i],'^',3)+' '+piece(RadList[i],'^',4));
     RadDataSL.Add(piece(piece(RadList[i],'^',2),'i',2)+'#'+piece(RadList[i],'^',7));
  end;
  RadList.Free;
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
  LoadSelectedIntoList(ScansToPrint,chkScanned,ScannedDataSL);
  LoadOthersIntoList;
end;

end.
