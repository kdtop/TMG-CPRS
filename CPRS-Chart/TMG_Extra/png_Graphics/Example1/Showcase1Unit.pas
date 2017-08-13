unit Showcase1Unit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pngimage, ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Explanation: TImage;
    Image3: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    GoChangeColor: TImage;
    moveball: TImage;
    TimeCount: TTimer;
    procedure GoChangeColorClick(Sender: TObject);
    procedure TimeCountTimer(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

constructor TForm1.Create(AOwner: TComponent);
begin
  inherited;
  Randomize;
  DoubleBuffered := TRUE;
end;

procedure TForm1.GoChangeColorClick(Sender: TObject);
begin
  {Don't map double-clicks}
  TImage(Sender).ControlStyle := TImage(Sender).controlstyle - [csDoubleClicks];
  {Change background color}
  color := rgb(random(255), random(255), random(255));
end;

{Avaliable directions to the ball}
const
  LEFTTOP = 0;
  LEFTBOTTOM = 1;
  RIGHTTOP = 2;
  RIGHTBOTTOM = 3;
var
  Direction: Integer = LEFTTOP;

procedure TForm1.TimeCountTimer(Sender: TObject);
const
  MovePieces = 9;
var
  OldDirection, i: Integer;

begin
  {Move the ball this times}
  FOR i := 1 TO MovePieces DO
  with MoveBall do
  begin
    {Move according to the direction}
    case Direction of
      LEFTTOP: SetBounds(Left - 1, Top - 1, Width, Height);
      LEFTBOTTOM: SetBounds(Left - 1, Top + 1, Width, Height);
      RIGHTTOP: SetBounds(Left + 1, Top - 1, Width, Height);
      RIGHTBOTTOM: SetBounds(Left + 1, Top + 1, Width, Height);
    end {case Direction};

    {Test for collision and if it happens, change direction}
    OldDirection := Direction;
    if Left <= 0 then
      case Direction of
        LEFTTOP: Direction := RIGHTTOP;
        LEFTBOTTOM: Direction := RIGHTBOTTOM;
      end
    else if Top <= 0 then
      case Direction of
        LEFTTOP: Direction := LEFTBOTTOM;
        RIGHTTOP: Direction := RIGHTBOTTOM;
      end
    else if Top + Height >= Self.ClientHeight then
      case Direction of
        LEFTBOTTOM: Direction := LEFTTOP;
        RIGHTBOTTOM: Direction := RIGHTTOP;
      end
    else if Left + Width >= Self.ClientWidth then
      case Direction of
        RIGHTTOP: Direction := LEFTTOP;
        RIGHTBOTTOM: Direction := LEFTBOTTOM;
      end;
    if OldDirection <> Direction then break;
  end;

end;

end.
