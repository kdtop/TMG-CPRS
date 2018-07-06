unit fCompleteConsult;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ORFn, uTypesACM,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmCompleteConsult = class(TForm)
    pnlConsult: TPanel;
    lblSelConsult: TLabel;
    lbxConsult: TListBox;
    btnConsult: TButton;
    btnCanCon: TButton;
    procedure btnCanConClick(Sender: TObject);
    procedure btnConsultClick(Sender: TObject);
  private
    { Private declarations }
    FParameters : TParameters;
    FNoteNumber : string;
    FDUZ : string;
    FDFN : string;
  public
    { Public declarations }
    procedure Initialize(Parameters : TParameters; NoteNumber, DUZ, DFN : string);
    property NoteNumber : string read FNoteNumber;
  end;

//var
//  frmCompleteConsult: TfrmCompleteConsult;

function CompleteConsult(Parameters : TParameters; var NoteNumber : string; DUZ, DFN : string): String;

implementation

{$R *.dfm}

uses
  rRPCsACM;

function CompleteConsult(Parameters : TParameters; var NoteNumber : string; DUZ, DFN : string): String;
var
  frmCompleteConsult: TfrmCompleteConsult;

begin
  //if ConsultCtrl = 0 then exit;
  frmCompleteConsult := TfrmCompleteConsult.Create(Application);
  try
    frmCompleteConsult.Initialize(Parameters, NoteNumber, DUZ, DFN);
    if frmCompleteConsult.lbxConsult.Count > 0 then begin
      if InfoBox('There are pending anticoagulation consults.' + CRLF +
                 'Do you want to resolve with the same note?',
                 'Pending Consult(s)', MB_YESNO or MB_ICONQUESTION) <> mrYes then exit;
      frmCompleteConsult.ShowModal;
      NoteNumber := frmCompleteConsult.NoteNumber;
    end;
  finally
    frmCompleteConsult.Free;
  end;
end;

//=======================================================================

procedure TfrmCompleteConsult.Initialize(Parameters : TParameters; NoteNumber, DUZ, DFN : string);
begin
  FParameters := Parameters;
  FNoteNumber := NoteNumber;
  FDUZ := DUZ;
  FDFN := DFN;
  GetConsultList(DFN, FParameters.ConsultService, lbxConsult.Items);
end;

procedure TfrmCompleteConsult.btnCanConClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;  //closes form
end;

procedure TfrmCompleteConsult.btnConsultClick(Sender: TObject);
var  ConNum, GOOD: string;
begin
  if lbxConsult.ItemIndex = -1 then begin
    InfoBox('Please highlight consult to complete', 'Choose Consult', MB_OK or MB_ICONEXCLAMATION);
    exit;
  end;
  ConNum := Piece(lbxConsult.Items[lbxConsult.ItemIndex], '^', 2);
  GOOD := CompleteConsultRPC(ConNum, FNoteNumber, FDUZ);
  if GOOD <> '1' then begin
    InfoBox('Unable to complete consult.', 'Consult Incomplete', MB_OK or MB_ICONEXCLAMATION)
  end else begin
    InfoBox('Consult completed; alert sent.', 'Consult Complete', MB_OK or MB_ICONEXCLAMATION);
    FNoteNumber := '';
  end;
  Self.ModalResult := mrOK;   //closes form
end;

end.
