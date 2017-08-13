unit fCarePlanProbLex;
//VEFA-261 added entire unit and form.  Derived from fProbLex;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ORFn, {uProbs,} StdCtrls, Buttons, ExtCtrls, ORctrls, uConst,
  fAutoSz, uInit, fBase508Form, VA508AccessibilityManager;

type
  TfrmCarePlanProbLex = class(TfrmBase508Form)
    Label1: TLabel;
    bbCan: TBitBtn;
    bbOK: TBitBtn;
    Panel1: TPanel;
    Bevel1: TBevel;
    lblstatus: TLabel;
    ebLex: TCaptionEdit;
    lbLex: TORListBox;
    bbSearch: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
    procedure bbCanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ebLexKeyPress(Sender: TObject; var Key: Char);
    procedure bbSearchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ProblemResult : TStringList;  //Changed to handle multiple ICD-9s      format: ^Description^ICD-Code
  end;



implementation

uses
 {fprobs,} rProbs  {,fProbEdt};

{$R *.DFM}

var
 ProblemList:TstringList;

const
  TX_CONTINUE_799 = 'A suitable term was not found based on user input and current defaults.'#13#10 +
                    'If you proceed with this nonspecific term, an ICD code of "799.9 - OTHER'#13#10 +
                    'UNKNOWN AND UNSPECIFIED CAUSE OF MORBIDITY OR MORTALITY" will be filed.'#13#10#13#10 +
                    'Use ';

  procedure TfrmCarePlanProbLex.bbOKClick(Sender: TObject);
  const
    TX799 = '799.9';
  var
    x, y: string;
    i,j: integer;
  begin
    ProblemResult.Clear;
    if (ebLex.Text = '') and ((lbLex.itemindex < 0) or (lbLex.Items.Count = 0)) then begin
      exit {bail out - nothing selected}
    end else if ((lbLex.itemindex < 0) or (lbLex.Items.Count = 0)) then begin
      if InfoBox(TX_CONTINUE_799 + UpperCase(ebLex.Text) + '?', 'Unresolved Entry',
                 MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES then Exit;
      ProblemResult.Add(u + ebLex.Text + u + TX799 + u);
    end else if (Piece(ProblemList[lbLex.ItemIndex], U, 3) = '') then begin
      if InfoBox(TX_CONTINUE_799 + UpperCase(lbLex.DisplayText[lbLex.ItemIndex]) + '?', 'Unresolved Entry',
                 MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES then Exit;
      ProblemResult.Add(u + lbLex.DisplayText[lbLex.ItemIndex] + u + TX799 + u);
    end else begin
      for j := 0 to lbLex.Items.Count - 1 do begin
         if not lbLex.Selected[j] then continue;
         x := ProblemList[j];
         y := Piece(x, U, 2);
         i := Pos(' *', y);
         if i > 0 then y := Copy(y, 1, i - 1);
         SetPiece(x, U, 2, y);
         ProblemResult.Add(x);
      end;
    end;
    Self.ModalResult := mrOK;
  end;

  procedure TfrmCarePlanProbLex.bbCanClick(Sender: TObject);
  begin
    ProblemResult.Clear;
    Self.ModalResult := mrCancel;
  end;

  procedure TfrmCarePlanProbLex.FormCreate(Sender: TObject);
  begin
    ProblemResult := TStringList.Create;
    ProblemList:=TStringList.create;
    ResizeAnchoredFormToFont(self);
    //Resize bevel to center horizontally
    Bevel1.Width := Panel1.ClientWidth - Bevel1.Left- Bevel1.Left;
  end;

  procedure TfrmCarePlanProbLex.FormDestroy(Sender: TObject);
  begin
    inherited;
    ProblemList.free;
    ProblemResult.free;
  end;

  procedure TfrmCarePlanProbLex.ebLexKeyPress(Sender: TObject; var Key: Char);
  begin
    if key=#13 then begin
      bbSearchClick(Sender);
      Key:=#0;
    end else begin
      lblStatus.caption:='';
      lbLex.Items.clear;
    end;
  end;

  procedure TfrmCarePlanProbLex.bbSearchClick(Sender: TObject);
  var
    ALIST:Tstringlist;
    v,Max, Found:string;
    onlist: integer;

    procedure SetLexList(v: string);
    var   {too bad ORCombo only allows 1 piece to be shown}
      i, j: integer;
      txt, term, code, sys, lin, x: String;
    begin
      lbLex.Clear;
      onlist:=-1;
      for i:=0 to pred(ProblemList.count) do begin
        txt:=ProblemList[i];
        Term:=Piece(txt,u,2);
         code:=Piece(txt,u,3);
        sys:=Piece(txt,u,5);
        lin:=Piece(txt,u,1) + u + term + '   ' + sys ;
        if code<>'' then lin:=lin + ':(' + code + ')';
        j := Pos(' *', Term);
        if j > 0 then
          x := UpperCase(Copy(Term, 1, j-1))
        else
          x := UpperCase(Term);
        if (x=V) or (code=V) then onlist:=i;
        lbLex.Items.add(lin);
      end;
      if onlist < 0 then begin  {Search term not in return list, so add it}
        lbLex.Items.insert(0,(u + V) );
        ProblemList.insert(0,(u + V + u + u));
        lbLex.itemIndex:=0;
      end else begin  {search term is on return list, so highlight it}
        lbLex.itemIndex:=onlist;
        ActiveControl := bbOK;
      end;
      lbLex.SetFocus;
    end;

  begin  {body}
    if ebLex.text='' then begin
       InfoBox('Enter a term to search for, then click "SEARCH"', 'Information', MB_OK or MB_ICONINFORMATION);
       exit; {don't bother to drop if no text entered}
    end ;
    Alist:=TStringList.create;
    try
      if lblStatus.caption = '' then begin
        lblStatus.caption := 'Searching Lexicon...';
        lblStatus.refresh;
      end;
      v:=uppercase(ebLex.text);
      if (v<>'') and (lbLex.itemindex<1) then begin
        ProblemList.clear;
        {FastAssign(ProblemLexiconSearch(v), Alist) ;}
        FastAssign(OldProblemLexiconSearch(v, 100), Alist) ;
      end;
      if Alist.count > 0 then begin
        FastAssign(Alist, lbLex.Items);
        FastAssign(Alist, ProblemList);
        Max:=ProblemList[pred(ProblemList.count)]; {get max number found}
        ProblemList.delete(pred(ProblemList.count)); {shed max# found}
        SetLexList(V);
        if onlist < 0 then
          Found := inttostr(ProblemList.Count -1)
        else
          Found := inttostr(ProblemList.Count);
        lblStatus.caption:='Search returned ' + Found + ' items.' +  ' out of a possible ' + Max;
        lbLex.Itemindex := 0 ;
      end else begin
        lblStatus.caption:='No Entries Found for "' + ebLex.text + '"';
      end ;
    finally
      Alist.free;
    end;
  end;

  procedure TfrmCarePlanProbLex.FormShow(Sender: TObject);
  begin
    ebLex.setfocus;
  end;

end.
