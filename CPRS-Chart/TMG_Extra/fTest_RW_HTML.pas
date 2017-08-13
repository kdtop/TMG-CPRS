unit fTest_RW_HTML;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uHTMLDlg, ORFn,
  TMGHTML2, StdCtrls, Buttons, ExtCtrls, uHTMLTools
  ;

type
  TfrmTMGTestHTML = class(TForm)
    pnlBottom: TPanel;
    memSource: TMemo;
    Splitter1: TSplitter;
    pnlCenter: TPanel;
    pnlHoldWebBrowser: TPanel;
    btnFromSource: TBitBtn;
    btnToSource: TBitBtn;
    btnClear: TBitBtn;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    btnTestStyles: TButton;
    procedure btnTestStylesClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnToSourceClick(Sender: TObject);
    procedure btnFromSourceClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    HTMLDlg : THTMLDlg;
    procedure SLAppend(SL, AddOnSL : TStrings);
  public
    HtmlEditor : THtmlObj;
    { Public declarations }
  end;

//var
//  TMGTestHTML: TTMGTestHTML;

implementation

{$R *.dfm}

uses
  FMErrorU,
  fNotes,
  MSHTML_EWB, Monkey_Datepicker;


procedure TfrmTMGTestHTML.SLAppend(SL, AddOnSL : TStrings);
var i : integer;
begin
  for i := 0 to AddOnSL.Count - 1 do SL.Add(AddOnSL.Strings[i]);
end;

procedure TfrmTMGTestHTML.btnClearClick(Sender: TObject);
begin
  MemSource.Lines.Clear;
end;

procedure TfrmTMGTestHTML.btnFromSourceClick(Sender: TObject);
begin
  HTMLEditor.HTMLText := MemSource.Lines.Text;
  {
  if MessageDlg('Insert into Editor in NOTES tab?  This will erase any prior content!', mtWarning, [mbOK, mbCancel],0) = mrOK then begin
    frmNotes.HtmlEditor.HTMLText := MemSource.Lines.Text;
  end;
  }
  HTMLEditor.SetFocus;
end;


procedure TfrmTMGTestHTML.btnTestStylesClick(Sender: TObject);
var MsgForm:         TFMErrorForm;
begin
  try
    MsgForm := TFMErrorForm.Create(Self);
    MsgForm.Caption := '';
    HTMLEditor.GetDocStyles(MsgForm.Memo.Lines);
    HTMLEditor.GetDocScripts(MsgForm.Memo.Lines);
    MsgForm.Memo.Lines.Add('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    HTMLEditor.GetDocScriptSummary(MsgForm.Memo.Lines);
    MsgForm.ShowModal;
  finally
    MsgForm.Free;
  end;
end;

{
procedure HandleStyleSheets(const Document: IDispatch);
var
begin
  // Loop through all style sheets
    OVStyleSheet := StyleSheets.item(OVSheetIdx);
    if VarSupports(OVStyleSheet, IHTMLStyleSheet, StyleSheet) then
    begin
      // Loop through all rules within style a sheet
      for RuleIdx := 0 to Pred(StyleSheet.rules.length) do
      begin
        // Get style from a rule and reset required attributes.
        // Note: style is IHTMLRuleStyle, not IHTMLStyle, although many
        // attributes are shared between these interfaces
        Style := StyleSheet.rules.item(RuleIdx).style;
        Style.backgroundImage := '';  // removes any background image
        Style.backgroundColor := '';  // resets background colour to default
      end;
    end;
  end;
end;
}

procedure TfrmTMGTestHTML.btnToSourceClick(Sender: TObject);
var Str : string;
begin
  Str := '<!DOCTYPE html><html><body>';
  Str := Str + HTMLEditor.HTMLText;
  Str := Str + '</body></html>';
  MemSource.Lines.Text := Str;
  WrapLongHTMLLines(MemSource.Lines, 255, '');
  memSource.SetFocus;
end;

procedure TfrmTMGTestHTML.Button1Click(Sender: TObject);
var Source : TStringList;
begin
  Source := TStringList.Create;
  Source.Assign(memSource.Lines);
  HTMLDlg.Clear;
  HTMLDlg.AddFromSource(Source);
  Source.Free;
  memSource.Lines.Assign(HTMLDlg.HTML);
end;

procedure TfrmTMGTestHTML.Button2Click(Sender: TObject);
var id : string;
    Elem : IHTMLElement;
    value : string;
    Disabled : boolean;
begin
  id := edit1.Text;
  Elem := HtmlEditor.GetElementById(id);
  if Assigned(Elem) then
    ShowMessage(
      'Tag name = <' + Elem.tagName + '>'#10 +
      'Tag id = ' + Elem.id + #10 +
      'Tag innerHTML = "' + Elem.innerHTML + '"'  + #10 +
      'Tag outerHTML = "' + Elem.outerHTML + '"'
    );
    value := HTMLDlg.GetValueByID(Id, Disabled);
    if Disabled then value := value + ' (disabled)';
    ShowMessage('Value = ' + value );
end;

procedure TfrmTMGTestHTML.Button3Click(Sender: TObject);
begin
  if MessageDlg('Clear Memo and show data?', mtConfirmation, [mbOK, mbCancel], 0) <> mrOK then exit;
  memSource.Lines.Clear;
  memSource.Lines.Add('-----Parsed Source------------ ');
  SLAppend(memSource.Lines, HTMLDlg.ParsedSource);
  memSource.Lines.Add('-----Id List ------------ ');
  SLAppend(memSource.Lines, HTMLDlg.ParsedIDList);
  memSource.Lines.Add('-----Results ------------ ');
  SLAppend(memSource.Lines, HTMLDlg.ResultValues);
end;

procedure TfrmTMGTestHTML.Button4Click(Sender: TObject);
begin
  memSource.Lines.Add('<ENABLECB>');
  memSource.Lines.Add('<p><CHECKBOX >Do you like Apples?</CHECKBOX><BR>');
  memSource.Lines.Add('<CHECKBOX checked>Do you like Grapes?</CHECKBOX><BR>');
  memSource.Lines.Add('<CHECKBOX>Do you like Strawberries?</CHECKBOX><BR>');
  memSource.Lines.Add('<CHECKBOX>Do you like Grapes?</CHECKBOX><BR>');
  {
  memSource.Lines.Add('<EDITBOX size="15" label="First Name: ">Initial Text</EDITBOX><BR>');
  memSource.Lines.Add('<EDITBOX size="35" label="Last Name: ">Initial Text</EDITBOX><BR>');
  memSource.Lines.Add('<WPBOX>Bunch of text here</WPBOX>');
  memSource.Lines.Add('<COMBO initial="">^Opt1|display value1^opt2|display value2^opt3^op4</COMBO><BR>');
  memSource.Lines.Add('<RADIO inline=false initial="opt2">opt|Apples^opt2|Pears^opt3^opt4</RADIO><BR>');
  }
  memSource.Lines.Add('<NUMBER min=-20 max=20 step=2 Label="Number: ">2</NUMBER><BR>');
  memSource.Lines.Add('<CYCBUTTON initial="opt2">opt1|Apples^opt2|Pears^opt3^opt4</CYCBUTTON><BR>');
  memSource.Lines.Add('</ENABLECB>');
  //memSource.Lines.Add('DOB <DATE initial="7/3/1967"></DATE><BR>');
  memSource.Lines.Add('<CHECKBOX>Do you like Grapes?</CHECKBOX><BR>');
  memSource.Lines.Add('</p>');
end;

procedure TfrmTMGTestHTML.FormCreate(Sender: TObject);
begin
  //
  //kt  Note: On creation, THtmlObj will remember Application.OnMessage.  But if
  //          another object (say a prior THtmlObj) has become active and already
  //          changed the handler, then there will be a problem.  So probably best
  //          to create them all at once.
  HtmlEditor := THtmlObj.Create(pnlHoldWebBrowser,Application);
  //Note: A 'loaded' function will initialize the THtmlObj's, but it can't be
  //      done until after this constructor is done, and this TfrmTMGTestHTML has been
  //      assigned a parent.  So done elsewhere.
  TWinControl(HtmlEditor).Parent := pnlHoldWebBrowser;
  TWinControl(HtmlEditor).Align:=alClient;
  HTMLDlg := THTMLDlg.Create(HtmlEditor);
end;

procedure TfrmTMGTestHTML.FormDestroy(Sender: TObject);
begin
  HTMLDlg.Free;
  HtmlEditor.Free;
end;

procedure TfrmTMGTestHTML.FormShow(Sender: TObject);
begin
  HtmlEditor.Loaded;
  HtmlEditor.Editable := true;
end;

end.

