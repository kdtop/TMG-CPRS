unit fNoteSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StrUtils,
  Dialogs, StdCtrls, ComCtrls, ORCtrls, rTIU, uHTMLTools, OleCtrls, SHDocVw, ExtCtrls, Buttons;

type
  TnsMode = (nsSelect,nsView,nsViewMulti);

  TfrmNoteSelector = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    tvnotes: TORListBox;
    Splitter1: TSplitter;
    Panel2: TPanel;
    WebBrowser1: TWebBrowser;
    btnOK: TButton;
    btnCancel: TButton;
    Panel3: TPanel;
    btnMailZoomOut: TBitBtn;
    btnMailZoomIn: TBitBtn;
    procedure btnMailZoomOutClick(Sender: TObject);
    procedure btnMailZoomInClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tvnotesClick(Sender: TObject);
    procedure tvnotesDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FZoom : integer;
    Mode : TnsMode;
    IENList : string;
    SelectedNote:string;
    procedure ApplyZoom(Zoom:integer;WB: TWebBrowser);
  public
    { Public declarations }
    procedure DisplayOneNote(NoteIEN:string);
    procedure DisplayMultiNote(NoteIEN:string);
  end;

var
  frmNoteSelector: TfrmNoteSelector;
  function SelectNote(IENList:string):string;
  procedure ViewNotes(IENList:string);

implementation

uses
  VAUtils, fNotes, uTIU;

{$R *.dfm}

const
  //FaxViewer Zoom Constants
  OLECMDID_OPTICAL_ZOOM = $0000003F;
  MIN_ZOOM = 10;
  MAX_ZOOM = 1000;
  ZOOM_FACTOR = 10;
  DEFAULT_ZOOM = 100;

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
  frmNoteSelector.Mode := nsSelect;
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
  if pos(',',IENList)>0 then begin
    frmNoteSelector.Mode := nsViewMulti;
    //frmNoteSelector.DisplayMultiNote(IENList);
  end else begin
    frmNoteSelector.Mode := nsView;
    frmNoteSelector.DisplayOneNote(IENList);
    frmNoteSelector.Panel1.Height := 0;
  end;
  frmNoteSelector.ShowModal;
  frmNoteSelector.free;
end;

procedure TfrmNoteSelector.FormShow(Sender: TObject);
var
  i, AnImg: integer;
  x, TitleName: string;
  HighlightedItem : boolean;
  //ThisDate:TFMdatetime;
  tmpList:TStringList;
  OneIEN: string;
  NumOfNotes : integer;
  Node: TORTreeNode;
begin
  //if IENList='ALL' then begin
  if Mode=nsSelect then begin
    tmpList := TStringList.create();

    ListNotesForTree(tmpList, 1 ,0 , 0, 0, 99999, False);

    for i := 0 to tmpList.Count - 1 do begin
       x := tmpList[i];
       //ThisDate := strtofloat(piece(x,'^',3));
       TitleName := MakeNoteDisplayText(x);
       x := piece(x,'^',1)+'^'+TitleName;
       tvnotes.Items.Add(x);
    end;
    tmplist.free;
    SelectedNote := '-1';
    tvnotes.ItemIndex := 0;
    tvnotesClick(nil);
   end else if Mode=nsViewMulti then begin
    tmpList := TStringList.create();
    ListNotesForTree(tmpList, 1 ,0 , 0, 0, 99999, False);

    for i := 0 to tmpList.Count - 1 do begin
       x := tmpList[i];
       if pos(piece(x,'^',1),IENList)<1 then continue;          
       //ThisDate := strtofloat(piece(x,'^',3));
       TitleName := MakeNoteDisplayText(x);
       x := piece(x,'^',1)+'^'+TitleName;
       tvnotes.Items.Add(x);
    end;
    tmplist.free;
    SelectedNote := '-1';
    tvnotes.ItemIndex := 0;
    tvnotesClick(nil);
   end;
   FZoom := DEFAULT_ZOOM;
   {
    IENList := '';
    for i := 0 to frmNotes.tvNotes.Items.Count - 1 do begin
      Node := TORTreeNode(frmNotes.tvNotes.Items[i]);
      //if (Assigned(Node.Parent))AND(ContainsText(Node.Parent.Text,'All signed')) then begin
      if (Assigned(Node.Parent)) then begin
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
    // ShowMessage('Selected notes are not in the Notes tab. Load more notes and try again.');
     exit;
  end;                                           }
  //if tvnotes.Items.count<1 then Panel1.Height := 0;
end;



procedure TfrmNoteSelector.btnCancelClick(Sender: TObject);
begin
  SelectedNote := '';
end;

procedure TfrmNoteSelector.btnMailZoomInClick(Sender: TObject);
begin
  System.Inc(FZoom, ZOOM_FACTOR);
  if FZoom > MAX_ZOOM then
    FZoom := MAX_ZOOM;
  ApplyZoom(FZoom,WebBrowser1);
end;


procedure TfrmNoteSelector.btnMailZoomOutClick(Sender: TObject);
begin
  System.Dec(FZoom, ZOOM_FACTOR);
  if FZoom < MIN_ZOOM then
    FZoom := MIN_ZOOM;
  ApplyZoom(FZoom,WebBrowser1);
end;

procedure TfrmNoteSelector.ApplyZoom(Zoom:integer;WB: TWebBrowser);
var
  pvaIn, pvaOut: OleVariant;
begin
  pvaIn := Zoom;
  pvaOut := Null;
  //pnlData.Caption := piece(pnlData.Caption,'@',1)+'@'+inttostr(Zoom)+'%';
  //lblZoom.Caption := 'Zoom: '+inttostr(Zoom)+' %';
  WB.ControlInterface.ExecWB(OLECMDID_OPTICAL_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, pvaIn, pvaOut);
  Application.ProcessMessages;
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
  {Lines := TStringList.Create();
  LoadDocumentText(Lines,strtoint(piece(tvNotes.Items[tvNotes.ItemIndex],'^',1)));
  uHTMLTools.FixHTML(Lines);
  HTMLFile := CPRSCacheDir+piece(tvNotes.Items[tvNotes.ItemIndex],'^',1)+'.html';
  Lines.SaveToFile(HTMLFile);
  WebBrowser1.Navigate(HTMLFile);
  Lines.free;}
  DisplayOneNote(piece(tvNotes.Items[tvNotes.ItemIndex],'^',1));
end;

procedure TfrmNoteSelector.DisplayOneNote(NoteIEN:string);
var Lines:TStringList;
    HTMLFile:string;
begin
  Lines := TStringList.Create();
  LoadDocumentText(Lines,strtoint(NoteIEN));
  uHTMLTools.FixHTML(Lines);
  HTMLFile := CPRSCacheDir+NoteIEN+'.html';
  Lines.SaveToFile(HTMLFile);
  WebBrowser1.Navigate(HTMLFile);
  Lines.free;
end;

procedure TfrmNoteSelector.DisplayMultiNote(NoteIEN:string);
var Lines:TStringList;
    HTMLFile:string;
begin
  Lines := TStringList.Create();
  LoadDocumentText(Lines,strtoint(NoteIEN));
  uHTMLTools.FixHTML(Lines);
  HTMLFile := CPRSCacheDir+NoteIEN+'.html';
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

