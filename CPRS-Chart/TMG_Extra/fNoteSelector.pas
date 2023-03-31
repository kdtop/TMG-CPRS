unit fNoteSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StrUtils,
  Dialogs, StdCtrls, ComCtrls, ORCtrls, rTIU, uHTMLTools, OleCtrls, SHDocVw, ExtCtrls;

type
  TnsMode = (nsSelect,nsView);

  TfrmNoteSelector = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    tvnotes: TORListBox;
    Splitter1: TSplitter;
    Panel2: TPanel;
    WebBrowser1: TWebBrowser;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tvnotesClick(Sender: TObject);
    procedure tvnotesDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    Mode : TnsMode;
    IENList : string;
    SelectedNote:string;
  public
    { Public declarations }
  end;

var
  frmNoteSelector: TfrmNoteSelector;
  function SelectNote(IENList:string):string;
  procedure ViewNotes(IENList:string);

implementation

uses
  VAUtils, fNotes, uTIU;

{$R *.dfm}

function SelectNote(IENList:string):string;
var
  frmNoteSelector : TfrmNoteSelector;
begin
  frmNoteSelector := TfrmNoteSelector.create(nil);
  if IENList='' then IENList := 'ALL';  //Will pull all listed in frmNotes
  frmNoteSelector.IENList := IENList;
  frmNoteSelector.Caption := 'Note Selector';
  frmNoteSelector.btnOK.visible := True;
  frmNoteSelector.btnCancel.visible := True;
  //frmNoteSelector.Mode :=
  frmNoteSelector.ShowModal;
  result := frmNoteSelector.SelectedNote;
  frmNoteSelector.free;
end;

procedure ViewNotes(IENList:string);
var
  frmNoteSelector : TfrmNoteSelector;
begin
  frmNoteSelector := TfrmNoteSelector.create(nil);
  frmNoteSelector.IENList := IENList;
  frmNoteSelector.ShowModal;
  frmNoteSelector.free;
end;


procedure TfrmNoteSelector.FormShow(Sender: TObject);
var
  OneIEN: string;
  i,NumOfNotes : integer;
  Node: TORTreeNode;
begin
  if IENList='ALL' then begin
    IENList := '';
    for i := 0 to frmNotes.tvNotes.Items.Count - 1 do begin
      Node := TORTreeNode(frmNotes.tvNotes.Items[i]);
      if (Assigned(Node.Parent))AND(ContainsText(Node.Parent.Text,'All signed')) then begin
        if IENList<>'' then IENList := IENList+',';
        IENList := IENList+piece(Node.StringData,'^',1);
      end;
    end;
  end;
  NumOfNotes := NumPieces(IENList,',');
  for I := 1 to NumOfNotes do begin
     OneIEN :=piece(IENList,',',i);
     //frmNoteSelector.lstNoteTitles.Items.Add(OneIEN);
     Node := frmNotes.GetNodeByIEN(frmNotes.tvNotes,OneIEN);
     if Node <> nil then tvnotes.Items.Add(piece(Node.StringData,'^',1)+'^'+Node.Text);       //frmNoteSelector.tvNotes.Items.Add(Node,MakeNoteDisplayText(Node.Text));
     //frmNoteSelector.Panel1.Height := frmNoteSelector.Panel1.Height+9;
     //frmNoteSelector.tvnotes.
  end;
  if tvnotes.Items.Count<1 then begin
     ShowMessage('Selected notes are not in the Notes tab. Load more notes and try again.');
     exit;
  end;
  if tvnotes.Items.count=1 then Panel1.Height := 0;      
  SelectedNote := '-1';
  tvnotes.ItemIndex := 0;
  tvnotesClick(nil);
end;



procedure TfrmNoteSelector.btnCancelClick(Sender: TObject);
begin
  SelectedNote := '';
end;

procedure TfrmNoteSelector.btnOKClick(Sender: TObject);
var
  SelNode: TORTreeNode;
begin
  //SelectedNote := lstNoteTitles.Items[lstNoteTitles.ItemIndex];
  //SelNode := TORTreeNode(tvNotes.Selected);
  SelectedNote := piece(tvNotes.Items[tvNotes.ItemIndex],'^',1);
  modalresult := mrOK;
end;


procedure TfrmNoteSelector.tvnotesClick(Sender: TObject);
var Lines:TStringList;
    HTMLFile:string;
begin
  Lines := TStringList.Create();
  LoadDocumentText(Lines,strtoint(piece(tvNotes.Items[tvNotes.ItemIndex],'^',1)));
  uHTMLTools.FixHTML(Lines);
  HTMLFile := CPRSCacheDir+piece(tvNotes.Items[tvNotes.ItemIndex],'^',1)+'.html';
  Lines.SaveToFile(HTMLFile);
  WebBrowser1.Navigate(HTMLFile);
  Lines.free;
end;

procedure TfrmNoteSelector.tvnotesDblClick(Sender: TObject);
begin
  //SelectedNote := piece(tvNotes.Items[tvNotes.ItemIndex],'^',1);
  //modalresult := mrOk;
end;

end.

