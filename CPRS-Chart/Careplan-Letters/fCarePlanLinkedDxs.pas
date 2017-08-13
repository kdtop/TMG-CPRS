unit fCarePlanLinkedDxs;

interface             

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons,fBase508Form, VA508AccessibilityManager;

type
  TfrmCarePlanLinkedDxs = class(TfrmBase508Form)
    sgDxList: TStringGrid;
    btnOK: TBitBtn;
    btnAdd: TBitBtn;
    btnDelete: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure sgDxListSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FSelRow : integer;
    procedure ClearGrid;
    procedure IncRowIfNeeded;
  public
    { Public declarations }
    procedure Initialize(DxList : TStringList);
    procedure GetFinalDxList(DxList : TStringList);
  end;

var
  frmCarePlanLinkedDxs: TfrmCarePlanLinkedDxs;

implementation

{$R *.dfm}

  uses ORFn, uProbs, fCarePlanProbLex;
  const COL_DESCR = 0;
        COL_ICD   = 1;

  procedure TfrmCarePlanLinkedDxs.FormCreate(Sender: TObject);
  begin
    sgDxList.Cells[COL_DESCR,0] := 'Diagnosis Name';
    sgDxList.Cells[COL_ICD,0] := 'ICD Code';
  end;

  procedure TfrmCarePlanLinkedDxs.FormResize(Sender: TObject);
  begin
    //Fix the column widths so they are centered left-right
  end;

  procedure TfrmCarePlanLinkedDxs.FormShow(Sender: TObject);
  begin
    if sgDxList.RowCount < 2 then btnAddClick(Self);
  end;

  procedure TfrmCarePlanLinkedDxs.ClearGrid;
  begin
    sgDxList.RowCount := 2;
    sgDxList.Cells[COL_DESCR,1] := '';
    sgDxList.Cells[COL_ICD,1] := '';
    sgDxList.ColCount := 2;
  end;


  procedure TfrmCarePlanLinkedDxs.Initialize(DxList : TStringList);
  //DxList format:  <ICD code>^<ICD name>
  const NUM_PIECES = 2;
  var Row,i : integer;
  begin
    ClearGrid;
    for i := 0 to DxList.Count - 1 do begin
      IncRowIfNeeded;
      Row := sgDxList.RowCount -1;
      sgDxList.Cells[COL_DESCR,Row] := piece(DxList.Strings[i],'^',2);
      sgDxList.Cells[COL_ICD,Row] := piece(DxList.Strings[i],'^',1);
    end;
  end;

  procedure TfrmCarePlanLinkedDxs.GetFinalDxList(DxList : TStringList);
  //DxList output format:  <ICD code>^<ICD name>
  var Row : integer;
      s : string;
  begin
    DxList.Clear;
    for Row := 1 to sgDxList.RowCount - 1 do begin
      s := sgDxList.Cells[COL_ICD,Row] + '^' + sgDxList.Cells[COL_DESCR,Row];
      if Trim(s) <> '^' then DxList.Add(s);
    end;
  end;


  procedure TfrmCarePlanLinkedDxs.sgDxListSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  begin
    FSelRow := ARow;
  end;


  procedure TfrmCarePlanLinkedDxs.btnAddClick(Sender: TObject);
  var
    frmCPLinkedDx: TfrmCarePlanProbLex;
    OneDx,ICDName,ICDCode : string;
    i,j : integer;
  begin
    if not PLUser.usUseLexicon then begin
      Messagedlg('Sorry.  You are not authorized to use lexicon.',mtInformation,[mbOK],0);
      exit; {don't allow lookup}
    end;
    frmCPLinkedDx := TfrmCarePlanProbLex.create(Application);
    try
      if frmCPLinkedDx.ShowModal = mrOK then begin
        for j := 0 to frmCPLinkedDx.ProblemResult.Count - 1 do begin
          OneDx := frmCPLinkedDx.ProblemResult[j];
          ICDName := piece(OneDx,'^',2);
          ICDCode := piece(OneDx,'^',3);
          for i := 1 to sgDxList.RowCount - 1 do begin  //check for duplicate entries
            if (sgDxList.Cells[COL_DESCR,i]=ICDName) or (sgDxList.Cells[COL_ICD,i]=ICDCode) then begin
              OneDx := '';
              break;
            end;
          end;
          if OneDx<>'' then begin
            IncRowIfNeeded;
            sgDxList.FixedRows := 1;
            sgDxList.Cells[COL_DESCR,sgDxList.RowCount-1] := ICDName;
            sgDxList.Cells[COL_ICD,sgDxList.RowCount-1] := ICDCode;
          end;
        end;
      end;
    finally
      frmCPLinkedDx.Free;
    end;
  end;

  procedure TfrmCarePlanLinkedDxs.IncRowIfNeeded;
  begin
    if (sgDxList.RowCount <> 2) or (sgDxList.Cells[0,1] <> '') then begin
      sgDxList.RowCount := sgDxList.RowCount + 1;
    end;
  end;


  procedure TfrmCarePlanLinkedDxs.btnDeleteClick(Sender: TObject);
  var i : integer;
  begin
    if sgDxList.RowCount=2 then begin
      sgDxList.Cells[COL_DESCR,1] := '';
      sgDxList.Cells[COL_ICD,1] := '';
    end else begin
      for i := FSelRow+1 to sgDxList.RowCount - 1 do begin
        sgDxList.Cells[COL_DESCR,i-1] := sgDxList.Cells[COL_DESCR,i];
        sgDxList.Cells[COL_ICD,i-1] := sgDxList.Cells[COL_ICD,i];
      end;
      sgDxList.RowCount := sgDxList.RowCount - 1;
    end;
    sgDxList.FixedRows := 1;
  end;



end.

