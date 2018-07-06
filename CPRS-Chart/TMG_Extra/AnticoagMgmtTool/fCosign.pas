unit fCosign;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ORCtrls, ExtCtrls, ORNet, ORFn, Trpcb,
  uTypesACM, StrUtils,
  {VA508AccessibilityManager,} Buttons;

type
  TfrmCosign = class(TForm)
    pnlCoSign: TPanel;
    pnlButtons: TPanel;
    pnlTop: TPanel;
    pnlList: TPanel;
    edtCoSign: TEdit;
    lbCoSign: TListBox;
    Timer: TTimer;
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    procedure btnOKClick(Sender: TObject);
    procedure lbCoSignClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtCoSignChange(Sender: TObject);
    procedure edtCoSignKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    FCosignerDUZ : string;  //cosigner user IEN.  To be selected in this form.
    FCofactorMode: tCofactor;
    FAppState : TAppState; //owned elsewhere
    CoSignDataSL : TStringList;
    function NullDUZ(ADUZ : string) : boolean;
    procedure CheckEnableForOKToExit;
  public
    { Public declarations }
    function CoSignNeeded(CofactorMode: tCofactor; AppState : TAppState; ATitle: String): boolean; //kt added
    property CoSignerDUZ : string read FCosignerDUZ;
  end;

//var
//  frmCosign: TfrmCosign;

function CosignerNeeded(CoFactorToCheck : tCofactor;
                        AppState : TAppState;
                        var CosignerDUZ : string;
                        ATitle: String = '';
                        ForceAsk: boolean = false     ): boolean;

implementation
uses
  rRPCsACM, uUtility;


{$R *.dfm}

function CosignerNeeded(CoFactorToCheck: tCofactor;
                        AppState: TAppState;
                        var CosignerDUZ : string;
                        ATitle: String = '';
                        ForceAsk : boolean = false): boolean;
var  frmCosign: TfrmCosign;
begin
  frmCosign := TfrmCosign.Create(Application);
  try
    Result := frmCosign.CoSignNeeded(CoFactorToCheck, AppState, ATitle);
    CosignerDUZ := '';
    if (Result=True) or ForceAsk then begin
      if frmCosign.ShowModal = mrOK then begin
        CosignerDUZ := frmCosign.CoSignerDUZ;
      end;
    end;
  finally
    frmCosign.Free;
  end;
end;

//=============================================================

function TfrmCosign.CoSignNeeded(CofactorMode: tCofactor; AppState : TAppstate;  ATitle: String): boolean;
//This initializes form and return true if cosignature needed.
var
  Default : String;
  Provider : TProvider; //temp, for easier code reading.

const
  ACTION_FOR_MODE  : array[tcfUndef .. tcfOrder] of string = ('', 'signing document.', 'placing order(s).');
  BUTTON_FOR_MODE  : array[tcfUndef .. tcfOrder] of string = ('', 'Note', 'Order');
  CAPTION_FOR_MODE : array[tcfUndef .. tcfOrder] of string = ('', 'Co-signer:', 'Provider for the Order(s).');

begin
  Result := false; //default
  FAppState := AppState;
  FCosignerDUZ := '';  //to be changed by user through selection.
  FCofactorMode := CofactorMode;
  Provider := AppState.Provider;

  if (CofactorMode = tcfNote) and (ATitle <> '') then begin
    Result := NoteTitleRequiresCoSignature(ATitle, Provider);
  end else if (CofactorMode = tcfOrder) then begin
    Result := Provider.CosignNeeded;
  end else begin
    Result := false; //kt default
  end;
  if Result then begin
    if Provider.DefaultCosigner <> '' then begin
      Default := piece(Provider.DefaultCosigner, '^', 2);
    end else begin
      Default := '@';
    end;
    GetEligibleCosignersList(Default, CoSignDataSL);
    lbLoadFromTagItems(lbCoSign, [2,3]);
    edtCoSign.Text := Default;
    if (Default <> '@') then cboSelectByID(lbCoSign, Default);
    pnlTop.Caption := 'You must choose a Provider before ' + ACTION_FOR_MODE[CofactorMode];
    btnCancel.Caption := '&Cancel ' + BUTTON_FOR_MODE[CofactorMode];
    Caption := 'Choose a ' + CAPTION_FOR_MODE[CofactorMode];
  end;
end;

procedure TfrmCosign.CheckEnableForOKToExit;
var OK : boolean;
begin
  OK := not NullDUZ(FCosignerDUZ);
  btnOK.Enabled := OK;
end;

procedure TfrmCosign.btnOKClick(Sender: TObject);
var
  RPCResult : string;
begin
  if FCofactorMode = tcfNote then begin
    with FAppState do begin
      if NoteInfo.NoteIEN <> '' then begin
        RPCResult := AddTIUCosigner(NoteInfo.NoteIEN,FCosignerDUZ);
        if StrToIntDef(piece(RPCResult,'^',1),0) < 1 then begin
          InfoBox('Unrecognized co-signer.' + CRLF +
                  'Please check in CPRS for the status of this note.',
                  'Problem Identifying Cosigner', MB_OK or MB_ICONEXCLAMATION);
        end;
      end;
    end;
  end else if FCofactorMode = tcfOrder then begin       //lab order
    if FAppState.INROrderSelected then OrderIt(FAppState, 'INR');
    if FAppState.CBCOrderSelected then OrderIt(FAppState, 'CBC');
  end;
  //Close;
end;

procedure TfrmCosign.lbCoSignClick(Sender: TObject);
var csitem : string;
begin
  csitem := CoSignDataSL[lbCoSign.ItemIndex];
  //csitem := lbCoSign.Items[lbCoSign.ItemIndex];
  //edtCoSign.Text := PIECE(csitem, '^', 2);
  FCosignerDUZ := PIECE(csitem,'^',1);
  CheckEnableForOKToExit;
end;

procedure TfrmCosign.btnCancelClick(Sender: TObject);
var RPCResult: string;
begin
  if FCofactorMode = tcfNote then begin
    with FAppState do begin
      if NoteInfo.NoteIEN <> '' then begin
        if MessageDlg('Are you sure you want to cancel?' + CRLF +
          'This will result in note being deleted.', mtConfirmation, [mbOK, mbCancel], 0) <> mrOk then exit;

        RPCResult := DeleteTIUNote(NoteInfo.NoteIEN);
        if StrToIntDef(piece(RPCResult, '^',1),0) = 1 then
          InfoBox('Unable to delete note: ' + PIECE(RPCResult, '^', 2),
                  'Deletion not Permitted', MB_OK or MB_ICONEXCLAMATION);
        NoteInfo.NoteIEN := '';
        close;
      end;
    end;
  end else if FCofactorMode = tcfOrder then begin
    close;
  end;
end;

procedure TfrmCosign.TimerTimer(Sender: TObject);
//delayed timer for updating after user typing
var StartStr: string;
begin
  StartStr := LeftStr(UpperCase(edtCoSign.Text), Length(edtCoSign.Text)-1);
  GetEligibleCosignersList(StartStr, CoSignDataSL);
  lbLoadFromTagItems(lbCoSign, [2,3]);
  Timer.Enabled := false;
end;

procedure TfrmCosign.edtCoSignChange(Sender: TObject);
var csitem : string;
begin
  if Timer.Enabled then Timer.Enabled := false;  //set for reset.
  Timer.Interval := 300;
  Timer.Enabled := true;  //reset timer

  if CoSignDataSL.Count > 0 then begin
    csitem := CoSignDataSL[0];
  end else begin
    csitem := '';
  end;
  edtCoSign.Text := PIECE(csitem,'^',2);
  FCosignerDUZ := PIECE(csitem,'^',1);
  btnOK.Enabled := (FCosignerDUZ <> '');
end;

procedure TfrmCosign.edtCoSignKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = Chr(13)) and btnOK.Enabled then begin
    btnOK.Click;
    close;
  end;
end;

procedure TfrmCosign.FormCreate(Sender: TObject);
begin
  CoSignDataSL := TStringList.Create;
  lbCoSign.Tag := integer(Pointer(CoSignDataSL));
end;

procedure TfrmCosign.FormDestroy(Sender: TObject);
begin
  CoSignDataSL.Free;
end;

procedure TfrmCosign.FormShow(Sender: TObject);
begin
  edtCoSign.SetFocus;
  CheckEnableForOKToExit;
end;

function TfrmCosign.NullDUZ(ADUZ : string) : boolean;
begin
  Result := ((ADUZ = '') or (ADUZ = '0') or (ADUZ = '-1'));
end;


end.
