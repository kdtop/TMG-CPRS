unit fActivityDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  StrUtils,
  Forms, Dialogs,   
  StdCtrls, Buttons, Controls, ExtCtrls;

type
  tActivityMode = (tPct, tFind, tLost);

  TfrmActivityDetail = class(TForm)
    pnlTWeek: TPanel;
    memMemo: TMemo;
    lblLine1: TStaticText;
    btnClose: TBitBtn;
    lblLine2: TStaticText;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FMode : tActivityMode;
    FSiteName : string;
    FClinicIEN : string;
    procedure SetMode(AMode : tActivityMode);
  public
    { Public declarations }
    NumDays : string;
    procedure Initialize(ASiteName, AClinicP : string);
    property Mode : tActivityMode read FMode write SetMode;
  end;

//var
//  frmActivityDetail: TfrmActivityDetail;

implementation

{$R *.dfm}

uses
  rRPCsACM, uUtility;

procedure TfrmActivityDetail.FormCreate(Sender: TObject);
begin
  FMode := tPct;
end;

procedure TfrmActivityDetail.Initialize(ASiteName, AClinicP : string);
begin
  FSiteName := ASiteName;
  FClinicIEN := AClinicP;
end;

procedure TfrmActivityDetail.SetMode(AMode : tActivityMode);
var Percent : string;
begin
  FMode := AMode;
  case FMode of
    tPct:   begin
              Percent := GetClinicPercentActivity(memMemo.Lines, NumDays, FClinicIEN);
              lblLine1.Caption := FSiteName + ': ' +
                       IfThenStr(StrToFloatDef(Percent, 0)>0, Percent+'%', 'No Activity') +
                       ' Last ' + NumDays + ' days.';
              lblLine2.Caption := 'Patients not at goal at last visit (or no last INR):';
            end;
    tFind:  begin
              lblLine1.Caption := FSiteName + ': Forty-five (45) Day Clinic Load';
              GetClinicLoad(memMemo.Lines, FClinicIEN);
              lblLine2.Caption :=  '';
            end;
    tLost : begin
              lblLine1.Caption := FSiteName + ': Patients Lost to Follow-Up';
              GetClinicNoActivity(memMemo.Lines, NumDays, FClinicIEN);
              if memMemo.Lines.Count = 0 then begin
                 memMemo.Lines.Add('No patient lost to follow-up noted');
              end;
              lblLine2.Caption :=  '';
            end;
  end;
end;



end.
