unit fMissedAppt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uHTMLTools, TMGHTML2,
  uTypesACM,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmMissedAppt = class(TForm)
    pnlTop: TPanel;
    lblNewAppt: TLabel;
    lblNAppt: TLabel;
    lblMADt: TLabel;
    dtpMA: TDateTimePicker;
    pnlBottom: TPanel;
    ckbMAInclInst: TCheckBox;
    btnCloseGbxMA: TButton;
    btnMAPreview: TButton;
    pnlHTMLObjHolder: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMAPreviewClick(Sender: TObject);
  private
    { Private declarations }
    FAppState : TAppState;
  public
    { Public declarations }
    HtmlEditor : THtmlObj;
    function ShowModal(AppState : TAppState) : integer; overload;

  end;

//var
//  frmMissedAppt: TfrmMissedAppt;

implementation

{$R *.dfm}

function TfrmMissedAppt.ShowModal(AppState : TAppState) : integer;
begin
  FAppState := AppState;
  Result := Self.ShowModal;
end;


procedure TfrmMissedAppt.btnMAPreviewClick(Sender: TObject);
//var
//  T: Integer;
//  AddText, NextAppStr: String;
begin
  {
  noshow := 3;
  for T := 0 to (memMA.Lines.Count - 1) do begin
    if T = 0 then AddText := memMA.Lines[0]
    else
      AddText := AddText+ #13#10 + memMA.Lines[T];
  end;
  NextAppStr := FormatDateTime('dddddd', dtpNextApp.DateTime);
  if dtpAppTime.Visible then
    NextAppStr := NextAppStr + ' at ' + FormatDateTime('hh:nn ampm', dtpAppTime.Time);
  case StrToInt(LetterINRTime) of
    0, 1:
      NextAppStr := NextAppStr + '.';
    2:
      NextAppStr := NextAppStr + ' in the morning.';
    3:
      NextAppStr := NextAppStr + ' in the afternoon.';
    4:
      NextAppStr := NextAppStr + ' per Lab procedures as directed.';
  end;
  PatientInstructions.Clear;
  PatientInstructions.Add(memMA.Text);
  RvProject.ClearParams;
  RvProject.ProjectFile := NetworkPath + 'MAppt.rav';
  With RvProject do
  begin
    open;
    SetParam('Heading1',SiteHead);
    SetParam('siteadr1',SiteAddA);
    SetParam('FAX','FAX:      ' + ClinicFAX);    //    SetParam('FAX',FAX);
    if SiteAddB <> '' then
    begin
      SetParam('siteadr2',SiteAddB);
      SetParam('siteadr3',SiteAddC);
    end
    else
      SetParam('siteadr2',SiteAddC);
    SetParam('X',GName);
    SetParam('Date', lblINRdt.Caption);
    SetParam('adr1', lblSadr1.Caption);
    SetParam('adr2', lblSadr2.Caption);
    SetParam('adr3', lblSadr3.Caption);
    SetParam('adr4', lblCSZ.Caption);
    SetParam('MAppt', FormatDateTime('dddddd', dtpMA.DateTime));
    SetParam('TDate', FormatDateTime('mmmm dd, yyyy', Today));
    SetParam('NextAppt', NextAppStr);
    SetParam('addinfo', AddText);
    SetParam('clinic', ClinicName);
    SetParam('phone', ClinicPhone);
    if (TollFreePhone <> '') then
      SetParam('TollFreeTag', 'or call Toll-free:')
    else
      SetParam('TollFreeTag', '');
    SetParam('TollFree', TollFreePhone);
    SetParam('sig', SigName);
    SetParam('title', SigTitle);
    ExecuteReport('rptNoShow');
    Close;
    FreeOnRelease;
  end;
  gbxMA.Visible := false;
  ToggleExitVisible(btnMA);
  btnMA.SetFocus;
  }
end;

//  TMGGenerateMissedApptNote(HtmlMANote); //kt added


procedure TfrmMissedAppt.FormCreate(Sender: TObject);
begin
  HtmlEditor := THtmlObj.Create(pnlHTMLObjHolder, Application);
  TWinControl(HtmlEditor).Parent:= pnlHTMLObjHolder;
  TWinControl(HtmlEditor).Align:=alClient;
  HtmlEditor.Loaded();
  HtmlEditor.HTMLText := '<p>';
  HtmlEditor.Editable := False;
end;


procedure TfrmMissedAppt.FormDestroy(Sender: TObject);
begin
  HtmlEditor.Free;
end;

end.
