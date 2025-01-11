unit fEncounterReview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  MDMHelper, ORFN,
  Dialogs, fPCEBase, VA508AccessibilityManager, StdCtrls, Buttons, CheckLst,
  ExtCtrls, OleCtrls, SHDocVw,
  uPCE, rPCE,
  ORNet, uCore, uHTMLTools,
  fPCEOther, fPCEBaseGrid, fPCEBaseMain ;


type
  TfrmEncounterReview = class(TfrmPCEBase)
    WebBrowser1: TWebBrowser;
    cbIgnore: TCheckBox;
    btnRefresh: TBitBtn;
    procedure btnRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadReport;
  public
    { Public declarations }
    IsDirty:boolean;
    procedure InitTab(SrcPCEData : TPCEData);
  end;

var
  frmEncounterReview: TfrmEncounterReview;    //not autocreated

implementation

{$R *.dfm}

uses
 fEncounterFrame;


procedure TfrmEncounterReview.btnRefreshClick(Sender: TObject);
begin
  inherited;
  LoadReport;
end;

procedure TfrmEncounterReview.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_TMG_Enc_ReviewNm;    // <-- required!
  btnOK.Height := 32;
  btnOK.Top := Self.Height - BtnOK.Height - 5;
  btnCancel.Height := 32;
  btnCancel.Top := BtnOK.Top;
  IsDirty := False;
end;

procedure TfrmEncounterReview.LoadReport;
var
  MessageStr:string;
begin
  MessageStr := frmEncounterFrame.TestData('1');
  WBLoadHTML(WebBrowser1, piece(MessageStr,'^',2));
end;
{var MessageArr:TStringList;
begin
  //if pnlNoPatientSelected.Visible = False then begin
  //    timUpdateNoPat.enabled := False;
  //    exit;
  //end;
  MessageArr := TStringList.Create();
  tCallV(MessageArr,'TMG CPRS NO PATIENT SELECTED',[User.DUZ]);
  WBLoadHTML(WebBrowser1, MessageArr.TEXT);
  MessageArr.Free;
end;}

procedure TfrmEncounterReview.FormShow(Sender: TObject);
begin
  inherited;
  LoadReport;
  IsDirty := True;
end;

procedure TfrmEncounterReview.InitTab(SrcPCEData : TPCEData);
begin
  //put any code needed here for times when form is initiated.
end;


end.
