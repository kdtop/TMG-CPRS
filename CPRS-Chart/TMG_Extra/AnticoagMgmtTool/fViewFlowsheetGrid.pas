unit fViewFlowsheetGrid;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons, 
  ExtCtrls, StrUtils, uUtility,
  uTypesACM, uFlowsheet, rRPCsACM, Grids,
  Classes;

type
  TfrmViewFlowsheetGrid = class(TForm)
    pnlTabFlow: TPanel;
    pnlFlowsheet: TPanel;
    Splitter1: TSplitter;
    sgFlowsheets: TStringGrid;
    memFlowsheetDisplay: TMemo;
    lblACAct: TStaticText;
    btnEditFlowsheet: TBitBtn;
    ckbShowRetractedFlowsheets: TCheckBox;
    btnDone: TBitBtn;
    procedure btnEditFlowsheetClick(Sender: TObject);
    procedure LoadPastFlowsheetACGrid();
    procedure SetFlowsheetGridColSizes();
    procedure pnlFlowsheetResize(Sender: TObject);
    procedure sgFlowsheetsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgFlowsheetsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ckbShowRetractedFlowsheetsClick(Sender: TObject);
  private
    { Private declarations }
    FAppState : TAppState; //not owned here
    FPatient : TPatient; //not owned here
  public
    { Public declarations }
    function ShowModal(AppState : TAppState) : integer; overload;
  end;

//var
//  frmViewFlowsheetGrid: TfrmViewFlowsheetGrid;

implementation

{$R *.dfm}

uses
  fEditFlowsheet, ORFn;

procedure TfrmViewFlowsheetGrid.ckbShowRetractedFlowsheetsClick(
  Sender: TObject);
begin
  FAppState.ShowRetractedFlowsheets := ckbShowRetractedFlowsheets.Checked;
  LoadPastFlowsheetACGrid();
end;

procedure TfrmViewFlowsheetGrid.LoadPastFlowsheetACGrid();
var GridRow, i, j         : integer;
    AFlowsheet            : TOneFlowsheet;
    tempS                 : string;

begin
  //sgFlowsheets.RowCount := Patient.FlowsheetData.Count + 1;   //max # of rows, provided none are retracted
  sgFlowsheets.RowCount := 1;
  sgFlowsheets.Cells[FLOWSHEET_GRID_DATE_COL,0]          := 'INR date';
  sgFlowsheets.Cells[FLOWSHEET_GRID_INR_COL,0]           := 'INR';
  sgFlowsheets.Cells[FLOWSHEET_GRID_TWD_COL,0]           := 'TWD';
  sgFlowsheets.Cells[FLOWSHEET_GRID_COMPLICATIONS_COL,0] := 'Cmpl';
  sgFlowsheets.Cells[FLOWSHEET_GRID_NOTICE_COL,0]        := 'Pt Notice';
  sgFlowsheets.Cells[FLOWSHEET_GRID_COMMENTS_COL,0]      := 'Comments';

  GridRow := 1;
  for i := 0 to FPatient.FlowsheetData.Count - 1 do begin
    AFlowsheet := FPatient.FlowsheetData[i];
    if not assigned(AFlowsheet) then continue;
    if AFlowsheet.Retracted and not FAppState.ShowRetractedFlowsheets then continue; //hide retracted flowsheets.
    sgFlowsheets.RowCount := sgFlowsheets.RowCount + 1;
    sgFlowsheets.Objects[FLOWSHEET_HOLDER_COL,   GridRow] := AFlowsheet; //not owned by grid.
    sgFlowsheets.Cells[FLOWSHEET_GRID_DATE_COL,  GridRow] := AFlowsheet.DateStr;  //note, this is flowsheet date, not INR date.
    sgFlowsheets.Cells[FLOWSHEET_GRID_INR_COL,   GridRow] := AFlowsheet.INR;
    sgFlowsheets.Cells[FLOWSHEET_GRID_TWD_COL,   GridRow] := AFlowsheet.TotalWeeklyDose;
    sgFlowsheets.Cells[FLOWSHEET_GRID_NOTICE_COL,GridRow] := AFlowsheet.PatientNotice;
    tempS := '';
    for j := 0 to AFlowsheet.Comments.Count-1 do begin
      if tempS <> '' then tempS := tempS + ' / ';
      tempS := tempS + AFlowsheet.Comments[j];
      if length(tempS)>255 then begin
        tempS := LeftStr(tempS, 255) + '...';
        break;
      end;
    end;
    sgFlowsheets.Cells[FLOWSHEET_GRID_COMMENTS_COL,GridRow] := tempS;
    tempS := IfThenStr(AFlowsheet.Complications.Count > 0, '(+)', '');
    sgFlowsheets.Cells[FLOWSHEET_GRID_COMPLICATIONS_COL,GridRow] := tempS;
    inc(GridRow);
  end;
  sgFlowsheets.RowCount := GridRow;
  SetFlowsheetGridColSizes();
  if sgFlowsheets.RowCount > 8 then sgFlowsheets.TopRow := sgFlowsheets.RowCount - 6;  //scroll to bottom of list.
  //LoadGraphData;
end;

procedure TfrmViewFlowsheetGrid.pnlFlowsheetResize(Sender: TObject);
begin
  SetFlowsheetGridColSizes();
end;

procedure TfrmViewFlowsheetGrid.SetFlowsheetGridColSizes();
var Avail_Width : integer;

  procedure SetWidth(col, width : integer);
  begin
    sgFlowsheets.ColWidths[col] := width;
    Avail_Width := Avail_Width - width;
  end;

begin
  Avail_Width := sgFlowsheets.width-25;
  SetWidth(FLOWSHEET_GRID_DATE_COL,          FLOWSHEET_GRID_DATE_COL_WIDTH);
  SetWidth(FLOWSHEET_GRID_INR_COL,           FLOWSHEET_GRID_INR_COL_WIDTH);
  SetWidth(FLOWSHEET_GRID_TWD_COL,           FLOWSHEET_GRID_TWD_COL_WIDTH);
  SetWidth(FLOWSHEET_GRID_COMPLICATIONS_COL, FLOWSHEET_GRID_COMPLICATIONS_COL_WIDTH);
  SetWidth(FLOWSHEET_GRID_NOTICE_COL,        FLOWSHEET_GRID_NOTICE_COL_WIDTH);
  SetWidth(FLOWSHEET_GRID_COMMENTS_COL,      Avail_Width);
end;


procedure TfrmViewFlowsheetGrid.sgFlowsheetsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  AFlowsheet : TOneFlowsheet;
  BackgroundColor : TColor;
  SavedBrush : TBrush;

begin
  AFlowsheet := TOneFlowsheet(sgFlowsheets.Objects[FLOWSHEET_HOLDER_COL,ARow]);
  if not Assigned(AFlowsheet) then exit;
  if AFlowsheet.Retracted then begin
    SavedBrush := TBrush.Create;
    try
      BackgroundColor := clBtnShadow; //clRed;
      SavedBrush.Assign(sgFlowsheets.Canvas.Brush);
      sgFlowsheets.Canvas.Brush.Color := BackgroundColor;
      sgFlowsheets.Canvas.FillRect(Rect);
      sgFlowsheets.Canvas.TextRect(Rect,Rect.Left,Rect.top, sgFlowsheets.Cells[ACol,ARow]);
      sgFlowsheets.Canvas.Brush.Assign(SavedBrush);
    finally
      SavedBrush.Free;
    end;
  end else begin
    //I can't figure out how, but if nothing done here, then standard Delphi drawing is done.
  end;
end;

procedure TfrmViewFlowsheetGrid.sgFlowsheetsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var OneFlowsheet : TOneFlowsheet;
begin
  memFlowsheetDisplay.Lines.Clear;
  OneFlowsheet := TOneFlowsheet(sgFlowsheets.Objects[FLOWSHEET_HOLDER_COL, ARow]);
  btnEditFlowsheet.Enabled := Assigned(OneFlowsheet);
  if assigned(OneFlowsheet) then OneFlowsheet.OutputInfo(memFlowsheetDisplay.Lines);
end;

procedure TfrmViewFlowsheetGrid.btnEditFlowsheetClick(Sender: TObject);
var
  FlowsheetToEdit : TOneFlowsheet;
  frmEditFlowsheetEntry: TfrmEditFlowsheetEntry;
  tempBool: boolean;
  SelectedRow : integer;

begin
  SelectedRow := sgFlowsheets.Row;
  if SelectedRow < 0 then begin
    InfoBox('Please first select row to edit.',
            'Select Row', MB_OK or MB_ICONEXCLAMATION);
    exit;
  end;

  FlowsheetToEdit := TOneFlowsheet(sgFlowsheets.Objects[FLOWSHEET_HOLDER_COL, SelectedRow]);
  if not Assigned(FlowsheetToEdit) then begin
    btnEditFlowsheet.Enabled := false;
    exit;
  end;
  memFlowsheetDisplay.Lines.Clear;

  frmEditFlowsheetEntry := TfrmEditFlowsheetEntry.Create(Self);
  try
    if frmEditFlowsheetEntry.ShowModal(FlowsheetToEdit, FAppState) = mrOK then begin
      //NOTE: I problably don't need to do EqualTo test, as OK but only gets enabled when changes are made.
      if not FlowsheetToEdit.EqualTo(frmEditFlowsheetEntry.EditedFlowSheet) then begin
        FlowsheetToEdit.Assign(frmEditFlowsheetEntry.EditedFlowSheet);
        FlowsheetToEdit.SaveToServer(FAppState);
        FAppState.PastINRValues.UpdateLinkedData(FlowsheetToEdit);
        LoadPastFlowsheetACGrid();
        if SelectedRow <= sgFlowsheets.RowCount then begin
          sgFlowsheets.Row := SelectedRow; //Doesn't seem to trigger selection event.
          sgFlowsheetsSelectCell(self, 0, SelectedRow, tempBool);
        end;
      end;
    end;
  finally
    frmEditFlowsheetEntry.Free;
  end;
end;

function TfrmViewFlowsheetGrid.ShowModal(AppState : TAppState) : integer;
begin
  FAppState := AppState;
  FPatient := AppState.Patient;
  ckbShowRetractedFlowsheets.checked := FAppState.ShowRetractedFlowsheets;
  LoadPastFlowsheetACGrid();

  result := ShowModal;
end;


end.
