unit fConsultantOffices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ORCtrls, StdCtrls, ExtCtrls, ORNet, uCore, ORFn;

type
  TfrmConsultantOffices = class(TForm)
    pnlTop: TPanel;
    btnUse: TButton;
    Button2: TButton;
    TreeView: TORTreeView;
    procedure TreeViewDblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SelectedOffice:string;
  end;

var
  frmConsultantOffices: TfrmConsultantOffices;
  function SearchConsultants:string;

implementation

{$R *.dfm}

function SearchConsultants:string;
var
    frmConsultantOffices: TfrmConsultantOffices;
begin
    frmConsultantOffices := TfrmConsultantOffices.create(nil);
    result := '';
    if frmConsultantOffices.ShowModal = mrOk then result := frmConsultantOffices.SelectedOffice;
    frmConsultantOffices.Free;
end;

procedure TfrmConsultantOffices.Button2Click(Sender: TObject);
begin
  SelectedOffice := '';
end;

procedure TfrmConsultantOffices.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  for I := 0 to TreeView.Items.Count - 1 do begin
    if Assigned(TreeView.Items[i].Data) then
      TStringList(TreeView.Items[i].Data).Free;
  end;
end;

procedure TfrmConsultantOffices.FormShow(Sender: TObject);
var
  ParentNode, ChildNode: TTreeNode;
  RPCResults : TStringList;
  i:integer;
  Entry:string;
  ThisConsultType,LastConsultType:string;
  OneData:TStringList;
begin
  // Clear any existing nodes
  TreeView.Items.Clear;

  RPCResults := TStringList.create;
  LastConsultType := '';
  tCallV(RPCResults,'TMG CHART EXPORTER CONSULTANTS',[Patient.DFN]);
  for I := 0 to RPCResults.Count - 1 do begin
    Entry := RPCResults[i];
    ThisConsultType := piece(Entry,'^',1);
    if ThisConsultType='' then continue;
    if ThisConsultType<>LastConsultType then begin
      ParentNode := TreeView.Items.Add(nil, ThisConsultType);
      LastConsultType := ThisConsultType;
    end;
    OneData := TStringList.create;
    OneData.Add(Entry);
    ChildNode := TreeView.Items.AddChild(ParentNode, piece(Entry,'^',2)+' - '+piece(Entry,'^',4));
    ChildNode.Data := OneData;
  end;
  TreeView.FullExpand;
  if Treeview.Items.Count>2 then begin
    Treeview.Topitem := TreeView.Items[0];
  end;  
  RPCResults.free;
end;

procedure TfrmConsultantOffices.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  SelectedOffice := '';
  if Assigned(Node) and Assigned(Node.Data) then begin
    SelectedOffice := TStringList(Node.Data).Strings[0];
  end;
  btnUse.Enabled := SelectedOffice<>'';
end;

procedure TfrmConsultantOffices.TreeViewChanging(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean);
begin
  AllowChange := Node.Count = 0;
end;

procedure TfrmConsultantOffices.TreeViewDblClick(Sender: TObject);
var ClickedNode:TTreeNode;
    MousePos: TPoint;
begin
  SelectedOffice := '';
  MousePos := TreeView.ScreenToClient(Mouse.CursorPos);

  ClickedNode := TreeView.GetNodeAt(MousePos.X,MousePos.Y);

  if Assigned(ClickedNode) and Assigned(ClickedNode.Data) then begin
    SelectedOffice := TStringList(ClickedNode.Data).Text;
  end;
  if SelectedOffice<>'' then modalresult := mrOk;
end;

end.

