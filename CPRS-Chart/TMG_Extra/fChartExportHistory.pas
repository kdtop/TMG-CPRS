unit fChartExportHistory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, ComCtrls, ORCtrls, ExtCtrls, ORNet, uCore, VAUtils, Grids, uDocTree, rTIU, rFileTransferU,
  Buttons, uTMGOptions;

type
  TExportRecord = class(TObject)   //Holds all data for one export
  private
    FDate:            string;                     // Date sent
    FSentTo:          string;                     // Person/Office sent to
    FFaxTo:           string;                     // Method of sending
    FUser:            string;                     // User sending
    FRE:              string;                     // regarding
    FMemo:            string;                     // memo
    FConsult:         string;                     // linked consult
    FExpIEN:             string;                     // Export IEN
    FNoteIENs:        string;                      // Notes
    FLabPDFs:         string;                       // Lab results
    FRadReports:      string;                 // Rad reports
  public
    constructor Create(const Data,ANotes,ALabs,ARadReports:string);  //Constructor
    property Date: string read FDate write FDate;
    property SentTo: string read FSentTo write FSentTo;
    property FaxTo: string read FFaxTo write FFaxTo;
    property User: string read FUser write FUser;
    property RE: string read FRE write FRE;
    property Memo: string read FMemo write FMemo;
    property Consult: string read FConsult write FConsult;
    property ExpIEN: string read FExpIEN write FExpIEN;
    property NoteIENs: string read FNoteIENs write FNoteIENs;
    property LabPDFs: string read FLabPDFs write FLabPDFs;
    property RadReports: string read FRadReports write FRadReports;

    //destructor Destroy();
  end;

  TExportArray = array of TExportRecord;     //An array containing all exported records

  TNodeData = record  //Record to hold each data item
    FullText: string;
  end;
  PNodeData = ^TNodeData;

  TfrmChartExportHistory = class(TForm)
    pnlUpper: TPanel;
    Splitter1: TSplitter;
    pnlLower: TPanel;
    pnlLowerMiddleLeft: TPanel;
    Splitter2: TSplitter;
    pnlLowerMiddleRight: TPanel;
    lstExportParents: TORListView;
    wbOneSentItem: TWebBrowser;
    grdExportParents: TCaptionStringGrid;
    tvOneExport: TORTreeView;
    pnlLowerTop: TPanel;
    pnlLowerBottom: TPanel;
    btnExport: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormResize(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure tvOneExportChange(Sender: TObject; Node: TTreeNode);
    procedure grdExportParentsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ParentExportGridWidths:string;
    TotalExport:TExportArray;
    procedure LoadEntireHistory(ExportHistory:TStringList);
    procedure DestroyExportArray;
    procedure LoadParentList;
    procedure LoadOneExport();
    procedure FreeNodeData;
    procedure DisplayPDF(PDFFullPath:string);
    procedure DisplayRadReport(RadString:string);
    procedure UpdateParentGridWidths;
  public
    { Public declarations }
  end;

var
  frmChartExportHistory: TfrmChartExportHistory;
  procedure ViewChartExportHistory;

  //Using uTMGOptions now const ParentExportGridWidths:string = '15^10^10^10^20^30^10';   //Each piece is the percentage width for each column

implementation

uses uHTMLTools;
{$R *.dfm}

procedure ViewChartExportHistory;
var frmChartExportHistory: TfrmChartExportHistory;
begin
  frmChartExportHistory := TfrmChartExportHistory.Create(nil);
  frmChartExportHistory.ParentExportGridWidths := uTMGOptions.ReadString('ExportHistoryColWidth','15-10-10-10-20-30-10');
  frmChartExportHistory.ShowModal;
  frmChartExportHistory.Free;
end;

//======================EXPORT RECORD ROUTINES==================================

constructor TExportRecord.Create(const Data,ANotes,ALabs,ARadReports:string);  //Constructor
var i:integer;
begin
  inherited Create;
  FDate := piece(Data,'^',1);
  FSentTo := piece(Data,'^',2);
  FFaxTo := piece(Data,'^',3);
  FUser := piece(Data,'^',4);
  FRE := piece(Data,'^',5);
  FMemo := piece(Data,'^',6);
  FConsult := piece(Data,'^',7);
  FExpIEN := piece(Data,'^',8);
  FNoteIENs := ANotes;
  FLabPDFs := ALabs;
  FRadReports := ARadReports;
end;


//======================END EXPORT RECORD ROUTINES==================================

procedure TfrmChartExportHistory.LoadEntireHistory(ExportHistory:TStringList);
var i,j,k :integer;
    DataStr,NotesStr,LabStr,RadStr:string;
    ExportItem:TExportRecord;
begin
  i := 0;
  while i <= ExportHistory.count-1 do begin
     DataStr := ExportHistory[i];
     Inc(i);
     NotesStr := ExportHistory[i];
     Inc(i);
     LabStr := ExportHistory[i];
     Inc(i);
     RadStr := ExportHistory[i];
     Inc(i);
     ExportItem := TExportRecord.create(DataStr,NotesStr,LabStr,RadStr);
     SetLength(TotalExport,Length(TotalExport)+1);
     TotalExport[High(TotalExport)] := ExportItem;
  end; //while 
end;

procedure TfrmChartExportHistory.btnExportClick(Sender: TObject);
var ExportResult,DownloadedFile,IENToExport:string;
begin
  IENToExport := grdExportParents.Cells[7,grdExportParents.Row];
  if IENToExport='' then begin
    ShowMessage('No export is selected to re-export.');
    exit;
  end;
  ExportResult := ReExportChart(IENToExport);
  if piece(ExportResult,'^',1)='1' then begin
     DownloadedFile := piece(ExportResult,'^',2);
     wbOneSentItem.Navigate(DownloadedFile);
   end;
end;

procedure TfrmChartExportHistory.DestroyExportArray;
var
  i : integer;
begin
  for i := Low(TotalExport) to High(TotalExport) do begin
    TotalExport[i].Free;
    TotalExport[i] := nil;
  end;
  SetLength(TotalExport,0);
end;

procedure TfrmChartExportHistory.FormCreate(Sender: TObject);
var arrExportHistory:TStringList;
begin
  arrExportHistory := TStringList.create;
  tCallV(arrExportHistory,'TMG GET EXPORT HISTORY',[Patient.DFN]);
  LoadEntireHistory(arrExportHistory);
  arrExportHistory.free;
  LoadParentList;
  LoadOneExport;
end;

procedure TfrmChartExportHistory.LoadParentList();
    procedure AddColumn(Labelstr:string);
    begin
      with lstExportParents.Columns.Add do begin
        Caption := LabelStr;
        Width := 100;
      end;
    end;

var i:integer;
    ListItem:TListItem;
begin
  grdExportParents.Cells[0,0] := 'Date';
  grdExportParents.Cells[1,0] := 'Sent To';
  grdExportParents.Cells[2,0] := 'Fax No.';
  grdExportParents.Cells[3,0] := 'User';
  grdExportParents.Cells[4,0] := 'Subject';
  grdExportParents.Cells[5,0] := 'Comments';
  grdExportParents.Cells[6,0] := 'Linked Consult';
  grdExportParents.Cells[7,0] := 'Export IEN';
  grdExportParents.RowCount := High(TotalExport)+2;
  for I := Low(TotalExport) to High(TotalExport) do begin
    grdExportParents.Cells[0,i+1] := TotalExport[i].FDate;
    grdExportParents.Cells[1,i+1] := TotalExport[i].FSentTo;
    grdExportParents.Cells[2,i+1] := TotalExport[i].FFaxTo;
    grdExportParents.Cells[3,i+1] := TotalExport[i].FUser;
    grdExportParents.Cells[4,i+1] := TotalExport[i].FRE;
    grdExportParents.Cells[5,i+1] := TotalExport[i].FMemo;
    grdExportParents.Cells[6,i+1] := TotalExport[i].FConsult;
    grdExportParents.Cells[7,i+1] := TotalExport[i].FExpIEN;
  end;
end;

procedure TfrmChartExportHistory.tvOneExportChange(Sender: TObject; Node: TTreeNode);
var
    Lines:TStringList;
    HTMLFile:string;
    NodeData:PNodeData;
begin
   if Assigned(Node) and Assigned(Node.Data) then begin
      NodeData := PNodeData(Node.Data);
      if Node.Parent.Text='Office Notes' then begin
        Lines := TStringList.Create();
        LoadDocumentText(Lines,strtoint(piece(NodeData^.FullText,'?',1)));
        uHTMLTools.FixHTML(Lines);
        HTMLFile := CPRSCacheDir+piece(NodeData^.FullText,'?',1)+'.html';
        Lines.SaveToFile(HTMLFile);
        wbOneSentItem.Navigate(HTMLFile);
        Lines.free;
      end else if Node.Parent.Text='Lab Results' then begin
         DisplayPDF(piece(NodeData^.FullText,'?',1));
      end else if Node.Parent.Text='Rad Reports' then begin
         DisplayRadReport(piece(NodeData^.FullText,'?',1));
      end else begin
        ShowMessage('Unknown '+piece(NodeData^.FullText,'?',1));
      end;
   end;
end;

procedure TfrmChartExportHistory.DisplayRadReport(RadString:string);
var ReportText:TStringList;
    FileName:string;
begin
   ReportText := TStringList.create;
   tCallV(ReportText,'ORWRP REPORT TEXT',[Patient.DFN,'18:IMAGING (LOCAL ONLY)','','',RadString,'0','0']);
   ReportText.Text := uHTMLTools.Text2HTML(ReportText,True);
   FileName := CPRSCacheDir+'RadReport.html';
   ReportText.SaveToFile(FileName);
   wbOneSentItem.Navigate(FileName);
   ReportText.free;
end;

procedure TfrmChartExportHistory.DisplayPDF(PDFFullPath:string);
  function ExtractUnixFilePath(const Filename:string):string;
  var I:integer;
  begin
    Result := '';
    for I := Length(Filename) downto 1 do begin
      if FileName[i] = '/'  then begin
        Result := Copy(Filename, 1, i);
        Break
      end;
    end;
  end;

  function ExtractUnixFileName(const Filename:string):string;
  var I:integer;
  begin
    Result := Filename;
    for I := Length(Filename) downto 1 do begin
      if FileName[i] = '/'  then begin
        Result := Copy(Filename, I+1, MaxInt);
        Break
      end;
    end;
  end;

var
  ErrMsg  : string;
  DLResult: TDownloadResult;
  PDFPath,PDFFileName:string;
  TargetPDFFilename : string;
  TargetHTMLFilename : string;
begin
  PDFPath := ExtractUnixFilePath(PDFFullPath);
  PDFFileName := ExtractUnixFileName(PDFFullPath);
  TargetPDFFilename := CacheDir + '\' + PDFFileName;
  if FileExists(TargetPDFFilename)=False then begin
    DLResult :=rFileTransferU.DownloadLabPDF(PDFPath, PDFFileName, TargetPDFFilename, 0, 0, ErrMsg);
    if DLResult = drFailure then begin
      Showmsg('Could not download PDF');
      exit;
    end;
  end;
  TargetHTMLFilename := TargetPDFFilename + '.html';
  MakeWrapperHTMLFile(TargetPDFFilename, TargetHTMLFilename, wbOneSentItem, tftPDF);
  wbOneSentItem.Navigate(TargetHTMLFilename);
end;

procedure TfrmChartExportHistory.FormDestroy(Sender: TObject);
begin
  wbOneSentItem.Navigate('about:blank');
  Application.Processmessages;   //make sure all acrobat objects are released before destroying form
  DestroyExportArray;
  FreeNodeData;
end;

procedure TfrmChartExportHistory.FormResize(Sender: TObject);
begin
  UpdateParentGridWidths;
end;

procedure TfrmChartExportHistory.UpdateParentGridWidths;
var TotalGridWidth:integer;
    i: integer;
begin
    TotalGridWidth := grdExportParents.ClientWidth - (grdExportParents.ColCount * grdExportParents.GridLineWidth) - 10;
    for I := 0 to grdExportParents.ColCount - 1 do begin
      grdExportParents.ColWidths[i] := Round(TotalGridWidth * (strtoint(piece(ParentExportGridWidths,'-',i+1))*0.01));
    end;
end;

procedure TfrmChartExportHistory.grdExportParentsClick(Sender: TObject);
begin
  LoadOneExport;
end;

procedure TfrmChartExportHistory.LoadOneExport();
var RootNote,ChildNode: TTreeNode;
    NoteStr,LabStr,RadStr:string;
    OneStr:string;
    i : integer;
    NodeData:PNodeData;
begin
   wbOneSentItem.Navigate('about:blank');
   tvOneExport.Items.BeginUpdate;
   FreeNodeData;
   KillDocTreeObjects(tvOneExport);
   tvOneExport.Items.Clear;
   tvOneExport.Items.EndUpdate;
   //Load Data
   NoteStr := TotalExport[grdExportParents.Row-1].FNoteIENs;
   LabStr := TotalExport[grdExportParents.Row-1].FLabPDFs;
   RadStr := TotalExport[grdExportParents.Row-1].FRadReports;
   tvOneExport.Items.BeginUpdate;
   if NoteStr<>'' then begin
     RootNote := tvOneExport.Items.Add(nil,'Office Notes');
     for I := 1 to NumPieces(NoteStr,'^') do begin
       New(NodeData);
       NodeData^.FullText := piece(NoteStr,'^',I);
       ChildNode := tvOneExport.Items.AddChild(RootNote,piece(piece(NoteStr,'^',I),'?',2));
       ChildNode.Data := NodeData;
     end;
     RootNote.Expanded := True;
   end;
   if LabStr<>'' then begin
     RootNote := tvOneExport.Items.Add(nil,'Lab Results');
     for I := 1 to NumPieces(LabStr,'^') do begin
       New(NodeData);
       NodeData^.FullText := piece(LabStr,'^',I);
       ChildNode := tvOneExport.Items.AddChild(RootNote,piece(piece(LabStr,'^',I),'?',2));
       ChildNode.Data := NodeData;
     end;
     RootNote.Expanded := True;
   end;
   if RadStr<>'' then begin
     RootNote := tvOneExport.Items.Add(nil,'Rad Reports');
     for I := 1 to NumPieces(RadStr,'^') do begin
       New(NodeData);
       NodeData^.FullText := piece(RadStr,'^',I);
       ChildNode := tvOneExport.Items.AddChild(RootNote,piece(piece(RadStr,'^',I),'?',2));
       ChildNode.Data := NodeData;
     end;
     RootNote.Expanded := True;
   end;
   tvOneExport.Items.EndUpdate;
   btnExport.Enabled := True;
end;

procedure TfrmChartExportHistory.FreeNodeData;
var
   i: integer;
   NodeData:PNodeData;
begin
   for I := 0 to tvOneExport.items.Count - 1 do begin
     if Assigned(tvOneExport.Items[i].Data) then begin
       NodeData := PNodeData(tvOneExport.Items[i].data);
       Dispose(nodedata);
       tvOneExport.Items[i].Data := nil;
     end;
    end; 
end;

end.

