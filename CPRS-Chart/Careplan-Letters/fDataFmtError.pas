unit fDataFmtError;
//VEFA-261  added entire unit

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, rTIU, uTIU, strutils;

type
  TfrmDataFmtError = class(TForm)
    lblErrors: TLabel;
    btnAccSign: TBitBtn;
    btnCancel: TBitBtn;
    richFixedNote: TRichEdit;
    btnAccEdit: TBitBtn;
    procedure btnAccEditClick(Sender: TObject);
    procedure btnAccSignClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    CheckLinkedCPs : TStringList;
    TIU8925: string;
    NoteText : TStringList;
    boolShowMe: boolean;
    //procedure ShowDocument(IEN8925 : string; CarePlanName: string);
    procedure LoadDocumentToRichEdit(IEN8925:string);
    procedure CorrectError(CarePlan,InvalidFlds,MissingFlds: string);
    procedure HighlightAllPhrases(phrase:string;color: tcolor);
    procedure HighlightOnePhrase(phrase:string; begpos:integer ;color: tcolor);
    procedure StripTags;
    procedure PrepForm;
  public
    { Public declarations }
    //ReplacementText : TStringList;
    function CheckLinkedCPsForTIU(TIU8925IEN:string) : integer;
  end;

var
  frmDataFmtError: TfrmDataFmtError;

const
  MISSING_FIELD_COMMENT_TAG = '   <<=== Missing field fixed';
  MISSING_RESPONSE_COMMENT_TAG = '   <<=== Missing response fixed';

implementation

{$R *.dfm}
  uses rCarePlans, VAUtils, RichEdit, uCarePlan;

  procedure TfrmDataFmtError.btnAccEditClick(Sender: TObject);
  begin
    stripTags;
  end;

  procedure TfrmDataFmtError.btnAccSignClick(Sender: TObject);
  begin
    StripTags;
  end;

  procedure TfrmDataFmtError.StripTags;
  var i:integer;
  begin
    for i := 0 to richFixedNote.Lines.Count - 1 do begin
      richFixedNote.Lines[i] := AnsiReplaceStr(richFixedNote.Lines[i],MISSING_FIELD_COMMENT_TAG,'');
      richFixedNote.Lines[i] := AnsiReplaceStr(richFixedNote.Lines[i],MISSING_RESPONSE_COMMENT_TAG,'');
    end;
  end;

  function TfrmDataFmtError.CheckLinkedCPsForTIU(TIU8925IEN : string) : integer;
  begin
    boolShowMe := False;
    Result := mrNo;
    CheckLinkedCPs := TStringList.Create;
    rCarePlans.CheckLinkedCPsForTIU(TIU8925IEN,CheckLinkedCPs);
    if Piece(CheckLinkedCPs[0],'^',1) = '-1' then begin
      TIU8925 := TIU8925IEN;
      PrepForm;
      if boolShowMe then Result := frmDataFmtError.ShowModal;
      //ReplacementText.Assign(richFixedNote.Lines);
    end;
    CheckLinkedCPs.Free;
  end;

  procedure TfrmDataFmtError.LoadDocumentToRichEdit(IEN8925:string);
  var
     //FEditNote: TEditNoteRec;
     i : integer;
  begin
     NoteText := TStringList.Create;
     try
       LoadDocumentText(NoteText,StrToIntDef(IEN8925,-1));
       //Remove Headers
       for i:= 0 to 5 do
         NoteText.Delete(0);
       richFixedNote.Lines.Assign(NoteText);
       //GetNoteForEdit(FEditNote, StrToIntDef(IEN8925,-1));
       //richFixedNote.Lines.Assign(FEditNote.Lines);
     finally
       NoteText.Free;
     end;
  end;


  procedure TfrmDataFmtError.CorrectError(CarePlan,InvalidFlds,MissingFlds: string);
  var InvalidField,MissingField: string;
      i : integer;
      Format: CHARFORMAT2;
      CPHeader,CPFooter: string;
      HeaderPos,FootPos,StartPos,EndPos : integer;
      Pos: TPoint;
      LineNo,FootLineNo : integer;
      PossibleAnswer,ReplacementText : string;
      FoundField : string;
      FoundPos,FoundLine: integer;
  begin
    //Find location of CarePlan, header and footer
    CPHeader := CP_TEMPLATE_TAG+CarePlan;
    CPFooter := ENDOF_TAG+CP_TEMPLATE_TAG+CarePlan+CP_BRACKET_CLOSE;
    HeaderPos := richFixedNote.FindText(CPHeader,0,strlen(PChar(richFixedNote.Text)),[]);
    FootPos := richFixedNote.FindText(CPFooter,0,strlen(PChar(richFixedNote.Text)),[]);
    Pos.Y := richFixedNote.Perform(EM_LINEFROMCHAR,richFixedNote.SelStart,LineNo);
    FootLineNo := richFixedNote.Perform(EM_LINEFROMCHAR,FootPos,0);

    FillChar(Format, sizeof(Format), 0);
    Format.cbsize := Sizeof(Format);
    Format.dwMask := CFM_BACKCOLOR;

    //Insert missing fields at last line prior to CP footer
    for i := 1 to NumPieces(MissingFlds,',') do begin
      MissingField := Piece(MissingFlds,',',i);

      FoundPos := richFixedNote.FindText(MissingField,HeaderPos,strlen(PChar(richFixedNote.Text)),[]);
      FoundLine := richFixedNote.Perform(EM_LINEFROMCHAR,FoundPos,0);
      if (FoundPos > 0) AND (FoundLine < FootLineNo) then continue;

      StartPos := richFixedNote.Perform(EM_LINEINDEX,FootLineNo,0);
      ReplacementText := MissingField + ' -=[]=-' ;
      boolShowMe := True;
      richFixedNote.Lines.Insert(FootLineNo,ReplacementText + MISSING_FIELD_COMMENT_TAG);

      HighlightOnePhrase(ReplacementText,StartPos,clWebYellow);
    end;
    HighlightAllPhrases(MISSING_FIELD_COMMENT_TAG,clLime);

    //Insert answer tags
    for i := 1 to NumPieces(InvalidFlds,',') do begin
      InvalidField := Piece(InvalidFlds,',',i);
      StartPos := richFixedNote.FindText(InvalidField,HeaderPos,strlen(PChar(richFixedNote.Text)),[]);
      LineNo := richFixedNote.Perform(EM_LINEFROMCHAR,StartPos,0);
      StartPos := richFixedNote.Perform(EM_LINEINDEX,LineNo,0);

      //try to determine if a partial answer exists and insert it
      PossibleAnswer := Piece(richFixedNote.Lines[LineNo],InvalidField,2);
      PossibleAnswer := AnsiReplaceStr(PossibleAnswer,'-','');
      PossibleAnswer := AnsiReplaceStr(PossibleAnswer,'=','');
      PossibleAnswer := AnsiReplaceStr(PossibleAnswer,'[','');
      PossibleAnswer := AnsiReplaceStr(PossibleAnswer,']','');

      ReplacementText := InvalidField + '  -=[' + PossibleAnswer + ']=-';
      boolShowMe := True;
      richFixedNote.Lines[LineNo] := ReplacementText + MISSING_RESPONSE_COMMENT_TAG;

      HighlightOnePhrase(ReplacementText,StartPos,clWebYellow);
    end;
    HighlightAllPhrases(MISSING_RESPONSE_COMMENT_TAG,clLime);

    //Set first line to beginning of richFixedNote
    richFixedNote.SelStart := 0;
  end;

  procedure TfrmDataFmtError.HighlightOnePhrase(phrase:string; begpos:integer ;color: tcolor);
  var
      Format: CHARFORMAT2;
  begin
    FillChar(Format, sizeof(Format), 0);
    Format.cbsize := Sizeof(Format);
    Format.dwMask := CFM_BACKCOLOR;

    richFixedNote.SelStart := BegPos;
    richFixedNote.SelLength := strlen(PChar(phrase));
    Format.crBackColor := color;
    richFixedNote.Perform(EM_SETCHARFORMAT, SCF_SELECTION, LongInt(@Format));
  end;

  procedure TfrmDataFmtError.HighlightAllPhrases(phrase:string;color: tcolor);
  var
      Format: CHARFORMAT2;
      BegPos, EndPos : integer;
      Pos: TPoint;
      LineNo : integer;
  begin
    FillChar(Format, sizeof(Format), 0);
    Format.cbsize := Sizeof(Format);
    Format.dwMask := CFM_BACKCOLOR;
    BegPos := richFixedNote.FindText(phrase,0,strlen(PChar(richFixedNote.Text)),[]);

    while BegPos <> -1 do begin
      EndPos := BegPos + strlen(PChar(phrase));
      LineNo := richFixedNote.Perform(EM_LINEFROMCHAR,BegPos,0);

      //Highlight Phrase
      richFixedNote.SelStart := BegPos;
      richFixedNote.SelLength := Endpos-BegPos;
      Format.crBackColor := color;
      richFixedNote.Perform(EM_SETCHARFORMAT, SCF_SELECTION, LongInt(@Format));
      BegPos := richFixedNote.FindText(phrase,EndPos,strlen(PChar(richFixedNote.Text)),[]);
    end;
  end;

  procedure TfrmDataFmtError.FormCreate(Sender: TObject);
  begin
    //ReplacementText := TStringList.Create;
  end;

procedure TfrmDataFmtError.FormDestroy(Sender: TObject);
  begin
    //ReplacementText.Free;
  end;

procedure TfrmDataFmtError.PrepForm;
  var
    MessageText,CarePlanName,Invalid,Missing: string;
    i :integer;
  begin
    LoadDocumentToRichEdit(TIU8925);
    //LoadDocumentText(richFixedNote.Lines,StrToIntDef(TIU8925,-1));
    MessageText := '';
    for i := 1 to CheckLinkedCPs.Count - 1 do begin
      CarePlanName := Piece(CheckLinkedCPs[i],'^',1);
      Invalid := Piece(CheckLinkedCPs[i],'^',2);
      Missing := Piece(CheckLinkedCPs[i],'^',3);
      if Piece(CheckLinkedCPs[i],'^',4)='MISSING HEADER' then begin
        MessageText := MessageText + #13#10 + CarePlanName + ' is missing header information.'
      end else begin
        CorrectError(CarePlanName,Invalid,Missing);
      end;
    end;
    if MessageText <> '' then begin
      MessageText := 'The following errors cannot be resolved:'+#13#10+MessageText+#13#10+#13#10+'To keep this careplan from being deleted, update again and reenter the information.';
      messagedlg(MessageText,mtInformation,[mbOK],0);
    end;
  end;

end.

