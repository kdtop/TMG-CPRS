unit fDashboard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, uConst,
  Dialogs, ExtCtrls, OleCtrls, SHDocVw, fPage, VA508AccessibilityManager, uCore, ORNet, uHTMLTools, ORFn;

type
  TfrmDashboard = class(TfrmPage)
    wbDashboard: TWebBrowser;
    timUpdateDashboard: TTimer;
    procedure wbDashboardBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName,
      PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure FormHide(Sender: TObject);
    procedure timUpdateDashboardTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadDashboard();
  public
    { Public declarations }
  end;

var
  frmDashboard: TfrmDashboard;

implementation

{$R *.dfm}

uses fFrame;

procedure TfrmDashboard.LoadDashboard();
var MessageArr:TStringList;
begin
  //if pnlNoPatientSelected.Visible = False then begin
  //    timUpdateNoPat.enabled := False;
  //    exit;
  //end;
  MessageArr := TStringList.Create();
  tCallV(MessageArr,'TMG CPRS NO PATIENT SELECTED',[User.DUZ]);
  WBLoadHTML(wbDashboard, MessageArr.TEXT);
  MessageArr.Free;
end;

procedure TfrmDashboard.timUpdateDashboardTimer(Sender: TObject);
begin
  inherited;
  LoadDashboard();
end;

procedure TfrmDashboard.wbDashboardBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL, Flags,
  TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
var MsgType:string;
    DFN:string;

begin
  //MsgType := piece(piece(URL,'^',1),':',2);  //trim out the about: and the command
  if pos('DFN-',URL)>0 then begin
    DFN := piece2(URL,'DFN-',2);
    //Patient.DFN := '0';
    //ShowEverything;
    //Patient.DFN := DFN;     // The patient object in uCore must have been created already!
    try
      if Patient.DFN=DFN then begin   //Added this IF to navigate to Notes tab
        frmFrame.SelectChartTab(tpsLeft, CT_NOTES);
      end else begin
        frmFrame.OpenAPatient(DFN);
      end;
    finally
      //OrderPrintForm := FALSE;
    end;
    Cancel := True;
  end;
end;

procedure TfrmDashboard.FormHide(Sender: TObject);
begin
  inherited;
  timUpdateDashboard.Enabled := False;
end;

procedure TfrmDashboard.FormShow(Sender: TObject);
begin
  inherited;
  LoadDashboard();
  timUpdateDashboard.Enabled := True;
end;

end.

