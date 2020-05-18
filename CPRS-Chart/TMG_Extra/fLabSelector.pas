unit fLabSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst,ORNet, ComCtrls;

type
  TfrmLabSelector = class(TForm)
    lblListName: TLabel;
    ckbxAll: TCheckBox;
    cklbTitles: TCheckListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    ListView1: TListView;
    procedure ListView1Click(Sender: TObject);
    procedure ckbxAllClick(Sender: TObject);
    procedure cklbTitlesClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function FirstSelectedIEN : string;
  public
    { Public declarations }
  end;

var
  frmLabSelector: TfrmLabSelector;

procedure SelectLabsForReport(FontSize: Integer);

implementation


uses fLabs, ORFn, rLabs, uCore, VAUtils, VA508AccessibilityRouter;

{$R *.DFM}

procedure SelectLabsForReport(FontSize: Integer);
var
  frmLabSelector: TfrmLabSelector;
  LabsToReturn : TStringList;
begin
  frmLabSelector := TfrmLabSelector.Create(Application);
  LabsToReturn := TStringList.Create;
  try
    //AFrmTMGPrintList.Initialize(ATree, PageID);
    if frmLabSelector.ShowModal <> mrOK then exit;
    //frmLabSelector.LoadSelectedIntoList(NotesToPrint);
  finally
    LabsToReturn.Free;
    frmLabSelector.Release;
  end;
end;


procedure TfrmLabSelector.btnOKClick(Sender: TObject);
var
  i : integer;

begin
  frmLabs.lstTests.Items.Clear;
  //for i := 0 to cklbTitles.Items.Count - 1 do begin
    //elh  if not cklbTitles.Selected[i] then continue;
  //  if not cklbTitles.Checked[i] then continue;

  //  frmLabs.lstTests.Items.Add(cklbTitles.Items[i]);  // Format: IEN^DisplayTitle
  //end;
  for i := 0 to ListView1.Items.Count - 1 do begin
    //elh  if not cklbTitles.Selected[i] then continue;
    if not ListView1.Items[i].Checked then continue;

    frmLabs.lstTests.Items.Add(ListView1.Items[i].SubItems[0]);  // Format: IEN^DisplayTitle
  end;
end;

function TfrmLabSelector.FirstSelectedIEN : string;
var
  i : integer;
begin
  Result := '';
  {for i := 0 to cklbTitles.Items.Count - 1 do begin
    if not cklbTitles.Checked[i] then continue;
    Result := piece(cklbTitles.Items[i], U, 1);
    break;
  end;}
  for i := 0 to ListView1.Items.Count - 1 do begin
    if not ListView1.Items[i].Checked then continue;
    Result := piece(ListView1.Items[i].SubItems[0], U, 1);
    break;
  end;
end;

procedure TfrmLabSelector.ckbxAllClick(Sender: TObject);
const
  CKBTN_LABEL : array [false .. true] of string = ('Select','Deselect');
var
  i : integer;
begin
  inherited;
  ckbxAll.Caption := CKBTN_LABEL[ckbxAll.Checked] + ' &All';
  //for i := 0 to cklbTitles.Items.Count - 1 do begin
  //  cklbTitles.Checked[i] := ckbxAll.Checked;
  //end;
  for i := 0 to ListView1.Items.Count - 1 do begin
    ListView1.Items[i].Checked := ckbxAll.Checked;
  end;
    
  btnOK.Enabled := ckbxAll.Checked;
end;

procedure TfrmLabSelector.cklbTitlesClick(Sender: TObject);
  function SomeSelected : boolean;
  begin
    Result := (FirstSelectedIEN <> '');
  end;
begin
  btnOK.Enabled := SomeSelected;
end;

procedure TfrmLabSelector.FormShow(Sender: TObject);
var RPCResults:TStringList;
    i :integer;
    Item1: TListItem;
begin
   RPCResults := TStringList.Create();
   tCallV(RPCResults,'TMG CPRS LAB GET DATES',[Patient.DFN]);
   for i := 0 to RPCResults.Count - 1 do begin
     cklbTitles.Items.Add(RPCResults[i]);
     Item1 := ListView1.Items.Add;
     Item1.SubItems.Add(piece(RPCResults[i],'-',1));
     Item1.SubItems.Add(piece(RPCResults[i],'-',2));
  end;
   RPCResults.Free;
end;

procedure TfrmLabSelector.ListView1Click(Sender: TObject);
  function SomeSelected : boolean;
  begin
    Result := (FirstSelectedIEN <> '');
  end;
begin
  btnOK.Enabled := SomeSelected;
end;

end.

