unit fEncounterMDM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  MDMHelper, ORFN,
  Dialogs, fPCEBase, VA508AccessibilityManager, StdCtrls, Buttons, CheckLst,
  ExtCtrls;

type
  TfrmEncounterMDM = class(TfrmPCEBase)
    pnlMain: TPanel;
    pnlRight: TPanel;
    pnlRightTop: TPanel;
    spltRUpDown: TSplitter;
    pnlRightBottom: TPanel;
    memOutput: TMemo;
    cklbCodes: TCheckListBox;
    lblCodes: TLabel;
    lblOutput: TLabel;
    pnlLeft: TPanel;
    btnClearCPT: TButton;
    btnNext: TBitBtn;
    btnClearMemo: TButton;
    procedure btnClearMemoClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnClearCPTClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    AnMDMGrid : TfrmMDMGrid;
    SavedTextTables : TStringList;
    SavedHTMLTables : TStringList;
    procedure HandleMDMOK(Sender: TObject);
    procedure HandleFrameSize(Sender: TObject);
  public
    { Public declarations }
    procedure SendData;  //kt
    constructor CreateLinked(AParent: TWinControl);
  end;

var
  frmEncounterMDM: TfrmEncounterMDM;   //not autocreated

implementation

{$R *.dfm}

uses fEncounterFrame, fTMGVisitType, fNotes;  //fVisitType;


procedure TfrmEncounterMDM.btnClearCPTClick(Sender: TObject);
begin
  inherited;
  //TO DO, confirm that clear is desired.
  cklbCodes.Items.Clear;
end;

procedure TfrmEncounterMDM.btnClearMemoClick(Sender: TObject);
begin
  inherited;
  memOutput.Lines.Clear;
  SavedTextTables.Clear;
  SavedHTMLTables.Clear;
end;

procedure TfrmEncounterMDM.btnNextClick(Sender: TObject);
var SL : TStringList;
    i : integer;
begin
  inherited;
  SL := TStringList.Create;
  try
    for i := 0 to cklbCodes.Items.Count - 1 do begin
      if not cklbCodes.Checked[i] then continue;
      SL.Add(cklbCodes.Items.Strings[i]);
    end;
    frmTMGVisitType.EnsureCPTs(SL);
  finally
    SL.Free;
  end;
  frmEncounterFrame.SelectNextTab;
end;

constructor TfrmEncounterMDM.CreateLinked(AParent: TWinControl);
begin
  AutoSizeDisabled := true;  //<--- this turns off crazy form resizing from parent forms.
  inherited;
end;


procedure TfrmEncounterMDM.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_TMG_EnctrMDMNm;    // <-- required!
  btnOK.Height := 32;
  btnOK.Top := Self.Height - BtnOK.Height - 5;
  btnCancel.Height := 32;
  btnCancel.Top := BtnOK.Top;
  btnNext.Top := Self.Height - BtnNext.Height - 5;

  SavedTextTables := TStringList.Create;
  SavedHTMLTables := TStringList.Create;

  AnMDMGrid := TfrmMDMGrid.Create(Self);
  AnMDMGrid.Parent := pnlLeft;
  AnMDMGrid.OnCloseForm := HandleMDMOK;
  AnMDMGrid.OnFrameSize := HandleFrameSize;
  AnMDMGrid.EmbeddedMode := true;
  HandleFrameSize(nil);
  AnMDMGrid.Show;
end;

procedure TfrmEncounterMDM.FormDestroy(Sender: TObject);
begin
  AnMDMGrid.Free;

  SavedTextTables.Free;
  SavedHTMLTables.Free;

  inherited;
end;

procedure TfrmEncounterMDM.HandleFrameSize(Sender: TObject);
begin
  pnlLeft.Width := AnMDMGrid.Width;
  AnMDMGrid.btnOK.Left := AnMDMGrid.Width - AnMDMGrid.btnOK.Width - 15;
end;


procedure TfrmEncounterMDM.HandleMDMOK(Sender: TObject);
var
  i, np, idx : integer;
  CPTs, oneCPT : string;

  procedure Append(Source, Dest : TStrings);
  var i : integer;
  begin
    for i := 0 to Source.Count - 1 do begin
      Dest.Add(Source[i]);
    end;
    Dest.Add('');
    Dest.Add('');
  end;

begin
  CPTs := AnMDMGrid.CPT;
  repeat
    np := NumPieces(CPTs,'+');
    if np > 0 then begin
      oneCPT := Trim(piece(CPTs,'+',1));
      CPTs := pieces(CPTs, '+', 2, np);
    end else begin
      oneCPT := CPTs;
      CPTs := '';
    end;
    idx := cklbCodes.Items.Add(oneCPT);
    cklbCodes.Checked[idx] := true;
  until CPTs = '';

  memOutput.Lines.Add(AnMDMGrid.Narrative);
  memOutput.Lines.Add('');
  memOutput.Lines.Add('');

  Append(AnMDMGrid.TextTable, memOutput.Lines);

  Append(AnMDMGrid.TextTable, SavedTextTables);
  Append(AnMDMGrid.HTMLTable, SavedHTMLTables);

  AnMDMGrid.Reset;
end;

procedure TfrmEncounterMDM.SendData;
begin
  if not assigned(frmNotes) then exit;
  frmNotes.InsertMDMGrid(SavedHTMLTables);
end;


end.
