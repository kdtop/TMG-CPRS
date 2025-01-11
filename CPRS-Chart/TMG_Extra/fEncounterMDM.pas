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
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
    IsDirty : boolean;    //11/14/23
    procedure SetDirtyStatus(DirtyStatus:boolean);  //11/14/23
    procedure SendData(var SendErrors,UnpastedHTML:string);  //kt
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
  SetDirtyStatus(False);
end;

procedure TfrmEncounterMDM.btnClearMemoClick(Sender: TObject);
begin
  inherited;
  memOutput.Lines.Clear;
  SavedTextTables.Clear;
  SavedHTMLTables.Clear;
  SetDirtyStatus(False);
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
  AnMDMGrid.FormStyle := fsNormal; //kt 9/21/23
  AnMDMGrid.Parent := pnlLeft;
  AnMDMGrid.OnCloseForm := HandleMDMOK;
  AnMDMGrid.OnFrameSize := HandleFrameSize;
  AnMDMGrid.SetEmbeddedMode(true, frmEncounterFrame);
  HandleFrameSize(nil);
  AnMDMGrid.Show;

  IsDirty := False;
end;

procedure TfrmEncounterMDM.FormDestroy(Sender: TObject);
begin
  AnMDMGrid.Free;

  SavedTextTables.Free;
  SavedHTMLTables.Free;

  inherited;
end;

procedure TfrmEncounterMDM.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  SetDirtyStatus(True);
end;

procedure TfrmEncounterMDM.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  SetDirtyStatus(True);
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

  SetDirtyStatus(True);
end;

procedure TfrmEncounterMDM.SendData(var SendErrors,UnpastedHTML:string);
begin
  if not assigned(frmNotes) then exit;
  if IsDirty=False then exit;   //11/14/23  
  if SavedHTMLTables.Count = 0 then exit;
  frmNotes.InsertMDMGrid(SavedHTMLTables, SendErrors, UnpastedHTML);
end;

procedure TfrmEncounterMDM.SetDirtyStatus(DirtyStatus:boolean);
begin
  IsDirty := DirtyStatus;
  frmEncounterFrame.SetCurrentTabAsDirty(DirtyStatus);
end;


end.
