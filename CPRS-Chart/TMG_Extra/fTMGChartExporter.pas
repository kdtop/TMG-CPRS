unit fTMGChartExporter;
//kt added 7/22/18


interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ORNet, uCore,
  Dialogs, fAutoSz, StdCtrls, ORCtrls, fConsult513Prt, VA508AccessibilityManager, rReports,
  CheckLst, ComCtrls, ORDtTm, ORFn, OleCtrls, SHDocVw, ExtCtrls, Buttons;

type
  TfrmTMGChartExporter = class(TfrmAutoSz)
    Panel1: TPanel;
    PageControl1: TPageControl;
    Notes: TTabSheet;
    lblListName: TLabel;
    ckbxAll: TCheckBox;
    chkHighlightOnly: TCheckBox;
    dtNotesStart: TORDateBox;
    Label1: TLabel;
    Label2: TLabel;
    dtNotesEnd: TORDateBox;
    btnApply: TButton;
    cklbTitles: TCheckListBox;
    Splitter1: TSplitter;
    Panel2: TPanel;
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
    btnLoadLabs: TButton;
    btnPrint: TBitBtn;
    btnSave: TBitBtn;
    dtRadStartDt: TORDateBox;
    Label9: TLabel;
    Label10: TLabel;
    dtRadEndDt: TORDateBox;
    btnLoadRad: TButton;
    btnNext: TBitBtn;
    btnPrev: TBitBtn;
    TabSheet1: TTabSheet;
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
    procedure LoadLists();
    function FirstSelectedIEN : string;
    function SomeSelected : boolean;
  public
    { Public declarations }
    ATree: TORTreeView;
    PageID: Integer;
    SelectedNoteIEN: string;
    DataSL: TStringList; //will be considered to be 1:1 linked to cklbTitles.items.  Format: IEN^DisplayTitle
    LabDataSL: TStringList;
    RadDataSL: TStringList;
    //procedure Initialize(ATree: TORTreeView; PageID: Integer);
    procedure LoadList();
    procedure LoadLabs;
    procedure LoadRad;
    //procedure LoadLabsIntoList;
    procedure LoadSelectedIntoList(AList : TStringList; Checkbox: TCheckListBox; Data:TStringList);
  end;

var
  //kt frmTMGPrintList: TfrmTMGPrintList;
  HLDPageID: Integer;
  PersistBeginDate:TFMDateTime;
  PersistEndDate:TFMDateTime;
  NotesToPrint : TStringList;
  LabsToPrint : TStringList;
  RadToPrint : TStringList;
  AFrmTMGChartExporter: TfrmTMGChartExporter;

//kt renamed to function below. function SelectParentFromList(ATree: TORTreeView; PageID: Integer): string;
procedure ExportOneChart(ATree: TORTreeView);


implementation

{$R *.dfm}
uses
  uTIU, rTIU, uConst, fNotes, fNotePrt, fConsults, fDCSumm, fFrame;

procedure ExportOneChart(ATree: TORTreeView);
  begin
  NotesToPrint := TStringList.Create;
  LabsToPrint := TStringList.Create;
  RadToPrint := TStringList.Create;
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
    AFrmTMGChartExporter.btnApply.Enabled := False;
    AFrmTMGChartExporter.LoadList;
    AFrmTMGChartExporter.LoadLabs;
    AFrmTMGChartExporter.LoadRad;
    AFrmTMGChartExporter.Show;
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
  SelectedNoteIEN := '';
end;

procedure TfrmTMGChartExporter.FormDestroy(Sender: TObject);
begin
  inherited;
  DataSL.Free;
  LabDataSL.Free;
  RadDataSL.Free;
end;

//---------------FORM CONTROLS

procedure TfrmTMGChartExporter.btnApplyClick(Sender: TObject);
begin
  inherited;
  LoadList;
  btnApply.Enabled := false;
end;

procedure TfrmTMGChartExporter.btnCancelClick(Sender: TObject);
begin
  inherited;
  NotesToPrint.Free;
  LabsToPrint.Free;
  RadToPrint.Free;
  AFrmTMGChartExporter.Release;
end;

procedure TfrmTMGChartExporter.btnLoadLabsClick(Sender: TObject);
begin
   LoadLabs;
end;

procedure TfrmTMGChartExporter.btnLoadRadClick(Sender: TObject);
begin
  inherited;
  LoadRad;
end;

procedure TfrmTMGChartExporter.btnExportClick(Sender: TObject);
var ExportResult:string;
begin
  inherited;
    AFrmTMGChartExporter.WebBrowser1.Navigate('about:blank');
    Application.ProcessMessages;
    LoadLists;
    ExportResult := ExportChart(NotesToPrint,LabsToPrint,RadToPrint,edtTo.Text,edtToFax.Text,edtRE.text,memComments.Lines);
    if piece(ExportResult,'^',1)='1' then begin
      AFrmTMGChartExporter.WebBrowser1.Navigate(piece(ExportResult,'^',2));
    end;
end;

procedure TfrmTMGChartExporter.chkHighlightOnlyClick(Sender: TObject);
const
  HIGHLIGHT_LABEL : array [false .. true] of string = ('Show Highlighted Items Only','Show All Items');
begin
  inherited;
  chkHighlightOnly.Caption := HIGHLIGHT_LABEL[chkHighlightOnly.checked];
  LoadList;
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

procedure TfrmTMGChartExporter.dtNotesEndChange(Sender: TObject);
begin
  inherited;
  PersistEndDate := dtNotesEnd.FMDateTime;
  btnApply.Enabled := true;
end;

procedure TfrmTMGChartExporter.dtNotesStartChange(Sender: TObject);
begin
  inherited;
  PersistBeginDate := dtNotesStart.FMDateTime;
  btnApply.Enabled := true;
end;

//----PROCEDURES TO LOAD THE LISTS

procedure TfrmTMGChartExporter.LoadList;
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
       DataSL.Add(x);
       cklbTitles.Items.Add(TitleName);
      end;
  end;
  tmplist.free;

end;

procedure TfrmTMGChartExporter.LoadLabs;
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

procedure TfrmTMGChartExporter.LoadRad;
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

procedure TfrmTMGChartExporter.LoadLists;
begin
  LoadSelectedIntoList(NotesToPrint,cklbTitles,DataSL);
  LoadSelectedIntoList(LabsToPrint,lstLabs,LabDataSL);
  LoadSelectedIntoList(RadToPrint,lstRad,RadDataSL);
end;

end.
