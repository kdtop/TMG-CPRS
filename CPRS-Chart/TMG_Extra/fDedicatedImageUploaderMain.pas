unit fDedicatedImageUploaderMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  fImages, fUploadImages, Loginfrm, ORNet, ORSystem, uTMGOptions, uCore,
  StdCtrls;

type
  TForm1 = class(TForm)
    PolTimer: TTimer;
    memErrorLog: TMemo;
    btnClear: TButton;
    procedure btnClearClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PolTimerTimer(Sender: TObject);
  private
    { Private declarations }
    Connected : boolean;            //kt 9/11
    Initialized : boolean;
    UploadForm : TfrmImageUpload;   //not owned here

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnClearClick(Sender: TObject);
begin
  memErrorLog.Lines.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  RetryConnect : integer;
  //ServerIP : string;
  //ServerPort: string;
const
  TX_OPTION     = 'OR CPRS GUI CHART';

begin
  Initialized := false;
  EnsureBroker;
  TMGGlobalAutoAccessCode := ParamSearch('USER');
  TMGGlobalAutoVerifyCode := ParamSearch('PASSWORD');

  repeat
    Connected := ConnectToServer(TX_OPTION);
    if not Connected then begin
      RetryConnect := mrCancel;
      if Assigned(RPCBrokerV) then begin
        RetryConnect := MessageDlg(RPCBrokerV.RPCBError, mtError, [mbRetry, mbCancel], 0);
      end;
      if RetryConnect <> mrRetry then begin
        Close;
        Application.Terminate;
        Exit;
      end;
    end;
  until Connected;   //Exit command above will also abort loop

  RPCBrokerV.CreateContext(TX_OPTION);
  User := TUser.Create;
  Patient := TPatient.Create;     //NOTE: This patient is used in rTIU TMGLocalBackup. It is different than the patient in the TAutoUpload record.
  frmImages := TfrmImages.Create(Self);  // this will instantiate frmImages.frmImageUpload := TfrmImageUpload.create
  frmImages.AutoScanUpload.Checked := true;
  UploadForm := frmImages.frmImageUpload;
  UploadForm.PolTimer.Enabled := False;
  UploadForm.ChkTimer.Enabled := False;
  Initialized := true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //TO DO...  Need to shut down RPC Broker.
  //RPCBrokerV.Connected := false;  //Is this all that is needed?
  frmImages.Free;
  Patient.free;
end;


procedure TForm1.PolTimerTimer(Sender: TObject);
begin
  if not Initialized then exit;
  PolTimer.Enabled := false;
  UploadForm.DoScanAndUpload(TStringList(memErrorLog.Lines)); //this may take some time...
  PolTimer.Interval := 60000;
  PolTimer.Enabled := true;
end;

end.
