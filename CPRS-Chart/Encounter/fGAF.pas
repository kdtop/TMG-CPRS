unit fGAF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, Buttons, ExtCtrls, Grids, ORFn, ORNet, ORCtrls,
  ORDtTm, ComCtrls, fPCEBaseGrid, Menus, VA508AccessibilityManager;

type
  TfrmGAF = class(TfrmPCEBaseGrid)
    lblGAF: TStaticText;
    edtScore: TCaptionEdit;
    udScore: TUpDown;
    dteGAF: TORDateBox;
    lblEntry: TStaticText;
    lblScore: TLabel;
    lblDate: TLabel;
    lblDeterminedBy: TLabel;
    cboGAFProvider: TORComboBox;
    btnURL: TButton;
    Spacer1: TLabel;
    Spacer2: TLabel;
    procedure cboGAFProviderNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure edtScoreChange(Sender: TObject);
    procedure dteGAFExit(Sender: TObject);
    procedure cboGAFProviderExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnURLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDataLoaded: boolean;
    procedure LoadScores;
    function BADData(ShowMessage: boolean): boolean;
  public
    procedure AllowTabChange(var AllowChange: boolean); override;
    procedure GetGAFScore(var Score: integer; var Date: TFMDateTime; var Staff: Int64);
    procedure InitTab();  //kt added
    procedure SendData(); //kt added
  end;

function ValidGAFData(Score: integer; Date: TFMDateTime; Staff: Int64): boolean;

var
  frmGAF: TfrmGAF;

implementation

uses rPCE, rCore, uCore, uPCE, fEncounterFrame, VA508AccessibilityRouter;

{$R *.DFM}

function ValidGAFData(Score: integer; Date: TFMDateTime; Staff: Int64): boolean;
begin
  if(Score < 1) or (Score > 100) or (Date <= 0) or (Staff = 0) then
    Result := FALSE
  else
    Result := ((Patient.DateDied <= 0) or (Date <= Patient.DateDied));
end;

procedure TfrmGAF.LoadScores;
var
  i: integer;
  tmp: string;

begin
  RecentGafScores(3);
  if(RPCBrokerV.Results.Count > 0) and (RPCBrokerV.Results[0] = '[DATA]') then
  begin
    for i := 1 to RPCBrokerV.Results.Count-1 do
    begin
      tmp := RPCBrokerV.Results[i];
      lbGrid.Items.Add(Piece(tmp,U,5) + U + Piece(Piece(tmp,U,2),NoPCEValue,1) + U +
                                Piece(tmp,U,7) + U + Piece(tmp,U,8));
    end;
  end;
  if(lbGrid.Items.Count > 0) then
    SyncGridData
  else
    lbGrid.Items.Add('No GAF scores found.');
end;

procedure TfrmGAF.cboGAFProviderNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  inherited;
  cboGAFProvider.ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

function TfrmGAF.BADData(ShowMessage: boolean): boolean;
var
  PName, msg: string;
  GAFDate: TFMDateTime;
  UIEN: Int64;

begin
  GAFDate := dteGAF.FMDateTime;
  msg := ValidateGAFDate(GAFDate);
  if(dteGAF.FMDateTime <> GAFDate) then begin
    dteGAF.FMDateTime := GAFDate;
  end;

  if(cboGAFProvider.ItemID = '') then begin
    if(msg <> '') then begin
      msg := msg + CRLF;
    end;
    msg := msg + 'A determining party is required to enter a GAF score.';
    UIEN := FProviders.PCEProvider;  //kt
    //kt UIEN := uProviders.PCEProvider;
    if(UIEN <> 0) then begin
      //kt PName := uProviders.PCEProviderName;
      PName := FProviders.PCEProviderName;  //kt
      msg := msg + '  Determined By changed to ' + PName + '.';
      cboGAFProvider.SelectByIEN(UIEN);
      if(cboGAFProvider.ItemID = '') then begin
        cboGAFProvider.InitLongList(PName);
        cboGAFProvider.SelectByIEN(UIEN);
      end;
    end;
  end;

  if(ShowMessage and (msg <> '')) then
    InfoBox(msg, 'Invalid GAF Data', MB_OK);

  if(udScore.Position > udScore.Min) then
    Result := (msg <> '')
  else
    Result := FALSE;
end;

procedure TfrmGAF.edtScoreChange(Sender: TObject);
var
  i: integer;

begin
  inherited;
  i := StrToIntDef(edtScore.Text,udScore.Min);
  if(i < udScore.Min) or (i > udScore.Max) then
    i := udScore.Min;
  udScore.Position := i;
  edtScore.Text := IntToStr(i);
  edtScore.SelStart := length(edtScore.Text);
end;

procedure TfrmGAF.dteGAFExit(Sender: TObject);
begin
  inherited;
//  BadData(TRUE);
end;

procedure TfrmGAF.cboGAFProviderExit(Sender: TObject);
begin
  inherited;
  BadData(TRUE);
end;

procedure TfrmGAF.AllowTabChange(var AllowChange: boolean);
begin
  AllowChange := (not BadData(TRUE));
end;

procedure TfrmGAF.GetGAFScore(var Score: integer; var Date: TFMDateTime; var Staff: Int64);
begin
  Score := udScore.Position;
  if(Score > 0) then BadData(TRUE);
  Date := dteGAF.FMDateTime;
  Staff := cboGAFProvider.ItemIEN;
  if(not ValidGAFData(Score, Date, Staff)) then
  begin
    Score := 0;
    Date := 0;
    Staff := 0
  end;
end;

procedure TfrmGAF.FormActivate(Sender: TObject);
begin
  inherited;
  if(not FDataLoaded) then
  begin
    FDataLoaded := TRUE;
    LoadScores;
    cboGAFProvider.InitLongList(Encounter.ProviderName);
    BadData(FALSE);
  end;
end;

procedure TfrmGAF.FormShow(Sender: TObject);
begin
  inherited;
  FormActivate(Sender);
end;

procedure TfrmGAF.btnURLClick(Sender: TObject);
begin
  inherited;
  GotoWebPage(GAFURL);
end;

procedure TfrmGAF.SendData(); //kt added
//kt moved code here from fEncounterFrame.SendData
var
  GAFScore: integer;
  GAFDate: TFMDateTime;
  GAFStaff: Int64;

begin
  GetGAFScore(GAFScore, GAFDate, GAFStaff);
  if (GAFScore > 0) then begin
    SaveGAFScore(GAFScore, GAFDate, GAFStaff);
  end;
end;

procedure TfrmGAF.InitTab();  //kt added
begin
  //if needed....
end;

procedure TfrmGAF.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_GAFNm;
  btnURL.Visible := (User.WebAccess and (GAFURL <> ''));
  FormActivate(Sender);
end;

initialization
  SpecifyFormIsNotADialog(TfrmGAF);

end.
