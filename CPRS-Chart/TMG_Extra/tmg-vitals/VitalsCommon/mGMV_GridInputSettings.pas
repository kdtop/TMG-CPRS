unit mGMV_GridInputSettings;

interface

uses
  Windows,
  ImgList,
  ComCtrls,
  ToolWin,
  Controls,
  Forms,
  Menus,
  StdCtrls,
  Grids,
  Buttons,
  Dialogs,
  Graphics,
  Classes;

type
  TfraGMV_GridSettings = class(TFrame)
    procedure tbtnNormalBackgroundClick(Sender: TObject);
  private
    FAbnormalBackGround: Integer;
    FNormalText: Integer;
    FNormalBackGround: Integer;
    FAbnormalText: Integer;
    procedure UpdateDisplay;
    { Private declarations }
  public
    property NormalText: Integer
      read FNormalText write FNormalText
      default 0;
    property NormalBackGround: Integer
      read FNormalBackGround write FNormalBackGround
      default 15;
    property AbnormalText: Integer
      read FAbnormalText write FAbnormalText
      default 9;
    property AbnormalBackGround: Integer
      read FAbnormalBackGround write FAbnormalBackGround
      default 15;
  end;

implementation

uses fGMV_SelectColor;

{$R *.DFM}

procedure TfraGMV_GridSettings.tbtnNormalBackgroundClick(Sender: TObject);
begin
  if SelectColor(tbtnNormalBackGround, FNormalBackground) then
    begin
      tbtnNormalBackGround.ImageIndex := FNormalBackground;
      UpdateDisplay;
    end;
end;

procedure TfraGMV_GridSettings.UpdateDisplay;
begin
  edtNormal.Color := NormalBackGround;
  edtNormal.Font.Color := NormalText;
  edtAbnormal.Color := AbnormalBackGround;
  edtAbnormal.Font.Color := AbnormalText;
end;

end.

