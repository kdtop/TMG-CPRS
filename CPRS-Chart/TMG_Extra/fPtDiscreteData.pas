unit fPtDiscreteData;
//kt added entire form 6/16

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uTemplateFields, ORFn, StrUtils, TMGHTML2,
  Dialogs, ExtCtrls, StdCtrls, ORCtrls, ComCtrls,
  Buttons;

type
  TDBDataRec = class(TObject)
  private
  //VALUE^<Template FIELD IEN>^<value of db control>^<any tag value>^<DT of value>^FieldName^<TypeSymbol>
    FIEN : string;
    FDT : string;
    FFldName : string;
    FFldType : Char;
    FValue : string;
    FDirty : boolean;
  public
    constructor Create(DataStr : string);
    procedure SetValue(Source : TStrings); overload;
    procedure SetValue(Source : string); overload;
    property FldType : char read FFldType;
    property Value : string read FValue;
    property IEN : string read FIEN;
    property Name : string read FFldName;
    property Modified : boolean read FDirty;
  end;

  TfrmPtDiscreteData = class(TForm)
    btnDone: TBitBtn;
    lbDBFields: TListBox;
    pnlMain: TPanel;
    pnlLeft: TPanel;
    Splitter1: TSplitter;
    pnlRight: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    pnlHoldWebBrowser: TPanel;
    procedure FormShow(Sender: TObject);
    procedure lbDBFieldsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
  private
    { Private declarations }
    FDataRecs : TStringList; //owns objects, each of type TDBDataRec
    FDFN : string;
    FVisitStr : string;
    FIEN8925 : string;
    FDBControlData: TDBControlData;
    FDataRecBeingEdited : TDBDataRec;  //not owned here.
    procedure DisplayForEdit(DataRec : TDBDataRec);
    procedure SaveEdits(DataRec : TDBDataRec);
  public
    { Public declarations }
    HtmlEditor : THtmlObj;
    procedure Initialize(DFN, AVisitStr, IEN8925 : string);
  end;

//var
  //frmPtDiscreteData: TfrmPtDiscreteData;  //not to be auto-created

implementation

uses
  uHTMLTemplateFields, uHTMLTools,
  rTemplates;
{$R *.dfm}


constructor TDBDataRec.Create(DataStr : string);
var s : string;
begin
  //  1          2                      3                   4             5           6           7
  //VALUE^<Template FIELD IEN>^<value of db control>^<any tag value>^<DT of value>^FieldName^<TypeSymbol>
  inherited Create;
  if piece(DataStr,'^',1) <> 'VALUE' then exit;
  FIEN     := piece(DataStr,'^',2);
  FValue   := piece(DataStr,'^',3);
  FDT      := piece(DataStr,'^',5);
  FFldName := piece(DataStr,'^',6);
  s := piece(DataStr,'^',7);
  FFldType := s[1];
  FDirty := false;
end;


procedure TDBDataRec.SetValue(Source : TStrings);
begin
  FValue := Source.Text;
  FDirty := true;
end;

procedure TDBDataRec.SetValue(Source : string);
begin
  FValue := Source;
  FDirty := true;
end;

//=============================================================

procedure TfrmPtDiscreteData.btnDoneClick(Sender: TObject);
var ErrStr : string;
begin
  FDBControlData.SaveToServer(StrToIntDef(FIEN8925,0), ErrStr);
  if ErrStr <> '' then MessageDlg('Error during saving: ' + #13#10 + ErrStr, mtError, [mbOK], 0);
  Self.ModalResult := mrOK; //will close form...
end;

procedure TfrmPtDiscreteData.FormCreate(Sender: TObject);
begin
  FDBControlData := TDBControlData.Create;
  FDataRecs := TStringList.Create;
  FDataRecBeingEdited := nil;
  //
  //kt  Note: On creation, THtmlObj will remember Application.OnMessage.  But if
  //          another object (say a prior THtmlObj) has become active and already
  //          changed the handler, then there will be a problem.  So probably best
  //          to create them all at once.
  HtmlEditor := THtmlObj.Create(pnlHoldWebBrowser,Application);
  //Note: A 'loaded' function will initialize the THtmlObj's, but it can't be
  //      done until after this constructor is done, and this TfrmPtDiscreteData has been
  //      assigned a parent.  So done elsewhere.
  TWinControl(HtmlEditor).Parent := pnlHoldWebBrowser;
  TWinControl(HtmlEditor).Align:=alClient;
end;

procedure TfrmPtDiscreteData.FormShow(Sender: TObject);
begin
  HtmlEditor.Loaded;
  HtmlEditor.Editable := true;
  if lbDBFields.Items.Count>0 then begin
    lbDBFields.Selected[0] := true;
    lbDBFieldsClick(self);
  end;
end;

procedure TfrmPtDiscreteData.FormDestroy(Sender: TObject);
var i : integer;
    DataRec : TDBDataRec;
begin
  SaveEdits(FDataRecBeingEdited);
  FDBControlData.Free;
  for i:= 0 to FDataRecs.Count - 1 do begin
    TDBDataRec(FDataRecs.Objects[i]).Free;
  end;
  FDataRecs.Free;
  GLOBAL_HTMLTemplateDialogsMgr.RemoveWebBrowser(HtmlEditor);
  HtmlEditor.Free;
end;

procedure TfrmPtDiscreteData.Initialize(DFN, AVisitStr, IEN8925 : string);
var  SL : TStringList;
     s : string;
     i : integer;
     DataRec : TDBDataRec;
begin
  FDFN := DFN;
  FVisitStr := AVisitStr;
  FIEN8925 := IEN8925;
  SL := TStringList.Create;
  rTemplates.GetDBFieldsList(DFN, AVisitStr, SL);
  //Cycle through each, making record for each, storing each in FDataRecs
  for i := 0 to SL.Count - 1 do begin
    s := SL.Strings[i];
    DataRec := TDBDataRec.Create(s);
    FDataRecs.AddObject(DataRec.FFldName,DataRec);
  end;
  SL.Free;
  lbDBFields.Items.Assign(FDataRecs);
end;

procedure TfrmPtDiscreteData.DisplayForEdit(DataRec : TDBDataRec);
//Put imbedded template into HTMLEditor....
var s : string;
begin
  FDataRecBeingEdited := DataRec;
  s := '{FLD:'+DataRec.Name+'}';
  GLOBAL_HTMLTemplateDialogsMgr.InsertTemplateTextAtSelection(HtmlEditor, s, DataRec.IEN);
  HtmlEditor.SetFocus;
end;

procedure TfrmPtDiscreteData.SaveEdits(DataRec : TDBDataRec);
begin
  if not assigned(DataRec) then exit;
  //Below will cause values to be saved to server.  Drop result text.
  GLOBAL_HTMLTemplateDialogsMgr.GetHTMLTextInSaveMode(HtmlEditor, StrToIntDef(FIEN8925,0));
  GLOBAL_HTMLTemplateDialogsMgr.SyncFromHTMLDocument(HtmlEditor);
end;


procedure TfrmPtDiscreteData.lbDBFieldsClick(Sender: TObject);
var i : integer;
    NewDataRec : TDBDataRec;
begin
  SaveEdits(FDataRecBeingEdited);
  GLOBAL_HTMLTemplateDialogsMgr.ClearWebBrowser(HtmlEditor);
  for i := 0 to lbDBFields.Items.Count - 1 do begin
    if not lbDBFields.Selected[i] then continue;
    NewDataRec := TDBDataRec(lbDBFields.Items.Objects[i]);
    DisplayForEdit(NewDataRec);
    break;
  end;
end;


end.
