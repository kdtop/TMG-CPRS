unit fTMGPrintList;
//kt added 7/22/18
//Initially copied, then modified, from fPrinList.pas

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fAutoSz, StdCtrls, ORCtrls, fConsult513Prt, VA508AccessibilityManager,
  Buttons, CheckLst;

type
  TfrmTMGPrintList = class(TfrmAutoSz)
    lblListName: TLabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    ckbxAll: TCheckBox;
    cklbTitles: TCheckListBox;
    procedure FormDestroy(Sender: TObject);
    procedure cklbTitlesClick(Sender: TObject);
    procedure ckbxAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
    procedure LoadSelectedIntoList(AList : TStringList);
    function FirstSelectedIEN : string;
    function SomeSelected : boolean;
  public
    { Public declarations }
    SelectedNoteIEN: string;
    DataSL: TStringList; //will be considered to be 1:1 linked to cklbTitles.items.  Format: IEN^DisplayTitle
    procedure Initialize(ATree: TORTreeView; PageID: Integer);
  end;

var
  //kt frmTMGPrintList: TfrmTMGPrintList;
  HLDPageID: Integer;

//kt renamed to function below. function SelectParentFromList(ATree: TORTreeView; PageID: Integer): string;
function SelectAndPrintFromTV(ATree: TORTreeView; PageID: Integer): string;


implementation

{$R *.dfm}
uses
  uTIU, rTIU, uConst, fNotes, fNotePrt, ORFn, fConsults, fDCSumm, fFrame;


//kt renamed to function below. function SelectParentFromList(ATree: TORTreeView; PageID: Integer): string;
function SelectAndPrintFromTV(ATree: TORTreeView; PageID: Integer): string;
var
  AFrmTMGPrintList: TfrmTMGPrintList;
  NotesToPrint : TStringList;

  begin
  Result := '';
  NotesToPrint := TStringList.Create;
  AFrmTMGPrintList := TfrmTMGPrintList.Create(Application);
  try
    AFrmTMGPrintList.Initialize(ATree, PageID);
    if AFrmTMGPrintList.ShowModal <> mrOK then exit;
    AFrmTMGPrintList.LoadSelectedIntoList(NotesToPrint);
    fNotePrt.TMGPrintMultiNotes(NotesToPrint);
    Result := AFrmTMGPrintList.FirstSelectedIEN;
  finally
    NotesToPrint.Free;
    AFrmTMGPrintList.Release;
  end;
end;

//---------------------------------

procedure TfrmTMGPrintList.FormCreate(Sender: TObject);
begin
  inherited;
  DataSL := TStringList.Create;
  SelectedNoteIEN := '';
end;

procedure TfrmTMGPrintList.FormDestroy(Sender: TObject);
begin
  inherited;
  DataSL.Free;
end;


procedure TfrmTMGPrintList.ckbxAllClick(Sender: TObject);
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
end;

procedure TfrmTMGPrintList.LoadSelectedIntoList(AList : TStringList);
var
  i : integer;
begin
  AList.Clear;
  for i := 0 to cklbTitles.Items.Count - 1 do begin
    //elh  if not cklbTitles.Selected[i] then continue;
    if not cklbTitles.Checked[i] then continue;
    AList.Add(DataSL[i]);  // Format: IEN^DisplayTitle
  end;
end;

function TfrmTMGPrintList.FirstSelectedIEN : string;
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

function TfrmTMGPrintList.SomeSelected : boolean;
begin
  Result := (FirstSelectedIEN <> '');
end;

procedure TfrmTMGPrintList.cklbTitlesClick(Sender: TObject);
begin
  inherited;
  btnOK.Enabled := SomeSelected;
end;

procedure TfrmTMGPrintList.Initialize(ATree: TORTreeView; PageID: Integer);
var
  i, AnImg: integer;
  x, TitleName: string;
begin
  HLDPageID := PageID;
  ResizeFormToFont(TForm(self));
  DataSL.Clear;
  cklbTitles.Clear;
  cklbTitles.Sorted := FALSE;

  for i := 0 to ATree.Items.Count - 1 do begin
    AnImg := TORTreeNode(ATree.Items.Item[i]).ImageIndex;
    if AnImg in [IMG_SINGLE, IMG_PARENT,IMG_IDNOTE_SHUT, IMG_IDNOTE_OPEN,
                     IMG_IDPAR_ADDENDA_SHUT, IMG_IDPAR_ADDENDA_OPEN] then begin
      x := TORTreeNode(ATree.Items.Item[i]).Stringdata;
      DataSL.Add(x);
    end; {if}
  end; {for}

  case PageID of
  CT_NOTES:
     begin
       SortByPiece(DataSL, U, 3);
       InvertStringList(DataSL);
       for i := 0 to DataSL.Count - 1 do begin
         x := DataSL[i];
         TitleName := MakeNoteDisplayText(x);
         DataSL[i] := Piece(x, U, 1) + U + TitleName;
         cklbTitles.Items.Add(TitleName);
       end;
       lblListName.Caption := 'Select Notes to be printed.';
     end;
  CT_CONSULTS:
     begin
       SortByPiece(DataSL, U, 11);
       InvertStringList(DataSL);
       for i := 0 to DataSL.Count - 1 do begin
         x := DataSL[i];
         TitleName := MakeConsultDisplayText(x);
         DataSL[i] := Piece(x, U, 1) + U + TitleName;
         cklbTitles.Items.Add(TitleName);
       end;
       lblListName.Caption := 'Select Consults to be printed.';
     end;
  CT_DCSUMM:
     begin
       SortByPiece(DataSL, U, 3);
       InvertStringList(DataSL);
       for i := 0 to DataSL.Count - 1 do begin
         x := DataSL[i];
         TitleName := MakeNoteDisplayText(x);
         DataSL[i] := Piece(x, U, 1) + U + TitleName;
         cklbTitles.Items.Add(TitleName);
       end;
       lblListName.Caption := 'Select Discharge Summaries to be printed.';
     end;
  ELSE  DataSL.Clear;
  end; //case

end;

end.