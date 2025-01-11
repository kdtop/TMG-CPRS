unit fNoteTOC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, Buttons, ExtCtrls, ORFn, MSHTML, ComObj, ActiveX;

type
  TfrmNoteTOC = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    BitBtn1: TBitBtn;
    WebBrowser1: TWebBrowser;
    chkKeepOpen: TCheckBox;
    timerOpen: TTimer;
    timerClose: TTimer;
    BitBtn2: TBitBtn;
    btnAutoOpenTOC: TCheckBox;
    cmbLocation: TComboBox;
    procedure cmbLocationChange(Sender: TObject);
    procedure btnAutoOpenTOCClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure timerCloseTimer(Sender: TObject);
    procedure timerOpenTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkKeepOpenClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure WebBrowser1BeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName,
      PostData, Headers: OleVariant; var Cancel: WordBool);
  private
    { Private declarations }
    FTargetHeight: Integer;
  public
    { Public declarations }
    FilePath : string;
    AnimateClose : boolean;
  end;

var
  //frmNoteTOC: TfrmNoteTOC;
  LineToSearchFor:string;
  procedure OpenThisTOC(FilePath:string;frmNoteTOC:TfrmNoteTOC);

implementation

uses uTMGOptions,fNotes;

{$R *.dfm}

  procedure OpenThisTOC(FilePath:string;frmNoteTOC:TfrmNoteTOC);
  //var
    //frmNoteTOC:TfrmNoteTOC;
  begin
    LineToSearchFor := '';
    frmNoteTOC.AnimateClose := True;
    frmNoteTOC.Show;
  end;

procedure TfrmNoteTOC.BitBtn1Click(Sender: TObject);
begin
   //self.free;
   //timerClose.Enabled := true;
   frmNotes.SetTOCButtonStatus(1);
end;

procedure TfrmNoteTOC.BitBtn2Click(Sender: TObject);
begin
  WebBrowser1.Navigate('about:blank');
  Application.ProcessMessages;
  WebBrowser1.Navigate(frmNotes.RefreshTOC);
end;

procedure TfrmNoteTOC.btnAutoOpenTOCClick(Sender: TObject);
begin
  //fNotes.PrefetchTOC := btnPrefetchTOC.checked;
  fNotes.AutoOpenTOC := btnAutoOpenTOC.Checked;
  uTMGOptions.WriteBool('AutoOpen TOC',fNotes.AutoOpenTOC);
  //uTMGOptions.WriteBool('Prefetch TOC',fNotes.PrefetchTOC);
end;

procedure TfrmNoteTOC.chkKeepOpenClick(Sender: TObject);
begin
  uTMGOptions.WriteBool('TOC Keep Open',chkKeepOpen.Checked);
end;

procedure TfrmNoteTOC.cmbLocationChange(Sender: TObject);
begin
  frmNotes.TOCLocation := TTOCLocation(cmbLocation.ItemIndex);
  uTMGOptions.WriteInteger('TOC Location',cmbLocation.ItemIndex);
  frmNotes.formresize(Sender);
end;

procedure TfrmNoteTOC.FormShow(Sender: TObject);
begin
  AnimateClose := True;
  FTargetHeight := frmNotes.pnlHtmlViewer.height;
  Height := -Height;
  //chkKeepOpen.Checked := uTMGOptions.ReadBool('TOC Keep Open',false);
  WebBrowser1.Navigate(FilePath);
  TimerOpen.Enabled := True;
end;

procedure TfrmNoteTOC.timerCloseTimer(Sender: TObject);
begin
  if AnimateClose = False then begin
    TimerClose.enabled := False;
    self.release;    //<-- This is the only place where fNoteTOC should be destroyed
  end else begin
    Height := Height - 40;
    //application.processmessages;
    Self.Repaint;
    if Height <= 40 then begin
      Height := 0;
      //Application.ProcessMessages;
      repaint;
      TimerClose.enabled := False;
      self.release;    //<-- This is the only place where fNoteTOC should be destroyed
    end;
  end;
end;

procedure TfrmNoteTOC.timerOpenTimer(Sender: TObject);
begin
  //Top := Top + 10;
  //if Top >= FTargetTop then begin
  //  Top := FTargetTop;
  //  TimerOpen.enabled := False;
  //end;
  Height := Height + 80;
  if Height >= FTargetHeight then begin
    Height := FTargetHeight;
    TimerOpen.enabled := False;
    //btnPrefetchTOC.Checked := fNotes.PrefetchTOC;
    btnAutoOpenTOC.Checked := fNotes.AutoOpenTOC;
    chkKeepOpen.Checked := uTMGOptions.ReadBool('TOC Keep Open',false);
    cmbLocation.ItemIndex := Ord(frmNotes.TOCLocation);
    //chkKeepOpen.Checked := uTMGOptions.ReadBool('TOC Keep Open',false);
  end;
end;

procedure TfrmNoteTOC.WebBrowser1BeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL, Flags,
  TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);

  function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
  var
    I, X: Integer;
    Len, LenSubStr: Integer;
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    Result := 0;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if X = LenSubStr then
          Result := I;
          Break;
      end;
      Inc(I);
    end;
end;

var
  s: String;
  iValue, iCode: Integer;
  NumOfPieces:integer;
  Document: IHTMLDocument2;
  Links: IHTMLElementCollection;
  Link: IHTMLAnchorElement;
  Element: IHTMLElement;
  I: Integer;
  OuterHTML, HrefValue, LowerHref :WideString;
  HrefPos, StartPos,EndPos : Integer;
  OriginalHref: WideString;
begin
  //Messagedlg(url,mtinformation,[mbOk],0);
  //Cancel := True;
  LineToSearchFor := URL;
  if pos(':',LineToSearchFor)=2 then begin
    NumOfPieces := NumPieces(LineToSearchFor,'\');
    LineToSearchFor := piece(LineToSearchFor,'\',NumOfPieces);
  end;

  if (pos('.html',LineToSearchFor)=0) and (pos('about:blank',LineToSearchFor)=0) then begin
    Document := WebBrowser1.Document as IHTMLDocument2;
    if Assigned(Document) then
    begin
      Links := Document.links as IHTMLElementCollection;
      for I := 0 to Links.length - 1 do
      begin
        Element := Links.item(I, EmptyParam) as IHTMLElement;
        //Link := Links.item(I, EmptyParam) as IHTMLAnchorElement;
        if Assigned(Element) then
        begin
          OuterHTML := Element.outerHTML;
          HrefPos := Pos('href',LowerCase(OuterHTML));

          if HrefPos>0 then begin
            StartPos := PosEx('"', OuterHTML, HrefPos + 4);
            if StartPos = 0 then
                StartPos := PosEx('''',OuterHTML, HrefPos + 4);
            if StartPos > 0 then begin
              Inc(StartPos);
               EndPos := PosEx('"', OuterHTML, StartPos);
              if EndPos = 0 then
                EndPos := PosEx('''', OuterHTML, StartPos);
              if EndPos >0  then begin
                HrefValue := Copy(OuterHTML, StartPos, EndPos - StartPos);
                LowerHref := LowerCase(HrefValue);
                if LowerHref = LineToSearchFor then begin
                  LineToSearchFor := HrefValue;
                //OriginalHref := Element.getAttribute('href',0);  //Link.href; // Get the full URL in its original case
                // Found the matching link with original case

                  Break;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    frmNotes.JumpToText(LineToSearchFor);
    Cancel := True;   //TEST
  end;
  //val(s, iValue, iCode);
  //ShowMessage('I am going to check the note for the line '+s);
    //Cancel := True;

  //ModalResult := mrOK;
    //frmNewBilling.CloseModal;
  //end else begin
    //ShowMessage('s has not a number');
  //end;
end;

end.

