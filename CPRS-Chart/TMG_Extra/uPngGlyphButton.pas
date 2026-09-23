unit uPngGlyphButton;

interface

uses
  System.Classes, System.SysUtils, Winapi.Windows, Winapi.Messages,
  Vcl.Controls, Vcl.Graphics, Vcl.Imaging.pngimage, Vcl.ImageCollection;

type
  TPngGlyphButton = class(TCustomControl) //kt //codex 9/21/26
  private
    FGlyph: TPngImage;
    FHoverGlyph: TPngImage;
    FIsHovered: Boolean;
    FIsPressed: Boolean;
    FHoverLightenPercent: Integer;
    procedure SetGlyph(const Value: TPngImage);
    procedure SetHoverLightenPercent(const Value: Integer);
    procedure GlyphChanged(Sender: TObject);
    procedure GenerateHoverGlyph;
    procedure UpdateWindowRegion; //kt //codex 9/21/26
    function IsPixelTransparent(X, Y: Integer): Boolean;
    procedure CMHitTest(var Message: TCMHitTest); message CM_HITTEST;
  protected
    procedure Paint; override;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function LoadGlyph(AImageCollection: TImageCollection; const AGlyphName: string): Boolean; overload;
    function LoadGlyph(AImageCollection: TImageCollection; AGlyphIndex: Integer): Boolean; overload;
  published
    property Glyph: TPngImage read FGlyph write SetGlyph;
    property HoverLightenPercent: Integer read FHoverLightenPercent write SetHoverLightenPercent default 25;
    property OnClick;
    property OnMouseDown;
    property OnMouseEnter; //kt //codex 9/21/26
    property OnMouseLeave; //kt //codex 9/21/26
    property OnMouseUp;
  end;

implementation

type
  TRGBTripleArray = array [0 .. 4095] of TRGBTriple;
  PRGBTripleArray = ^TRGBTripleArray;

constructor TPngGlyphButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGlyph := TPngImage.Create;
  FGlyph.OnChange := GlyphChanged;
  FHoverGlyph := TPngImage.Create;
  ParentBackground := True; //kt //codex 9/21/26
  Width := 64;
  Height := 64;
  FIsHovered := False;
  FIsPressed := False;
  FHoverLightenPercent := 25; // Lighten by 25% by default
end;

destructor TPngGlyphButton.Destroy;
begin
  FGlyph.Free;
  FHoverGlyph.Free;
  inherited Destroy;
end;

procedure TPngGlyphButton.SetGlyph(const Value: TPngImage);
begin
  FGlyph.Assign(Value);
end;

function TPngGlyphButton.LoadGlyph(AImageCollection: TImageCollection; const AGlyphName: string): Boolean;
begin
  Result := False;
  if AImageCollection = nil then Exit;
  Result := LoadGlyph(AImageCollection, AImageCollection.GetIndexByName(AGlyphName));
end;

function TPngGlyphButton.LoadGlyph(AImageCollection: TImageCollection; AGlyphIndex: Integer): Boolean;
var
  GlyphStream: TMemoryStream;
begin
  Result := False;
  if (AImageCollection = nil) or
     (AGlyphIndex < 0) or
     (AGlyphIndex >= AImageCollection.Images.Count) or
     (AImageCollection.Images[AGlyphIndex].SourceImages.Count = 0) then
    Exit;

  GlyphStream := TMemoryStream.Create;
  try
    AImageCollection.Images[AGlyphIndex].SourceImages[0].Image.SaveToStream(GlyphStream);
    GlyphStream.Position := 0;
    FGlyph.LoadFromStream(GlyphStream);
    Result := True;
  finally
    GlyphStream.Free;
  end;
end;

procedure TPngGlyphButton.SetHoverLightenPercent(const Value: Integer);
begin
  if FHoverLightenPercent <> Value then
  begin
    // Clamp value between 0 and 100
    if Value < 0 then
      FHoverLightenPercent := 0
    else if Value > 100 then
      FHoverLightenPercent := 100
    else
      FHoverLightenPercent := Value;

    GenerateHoverGlyph;
    Invalidate;
  end;
end;

procedure TPngGlyphButton.GlyphChanged(Sender: TObject);
begin
  if (FGlyph <> nil) and not FGlyph.Empty then
  begin
    Width := FGlyph.Width;
    Height := FGlyph.Height;
    GenerateHoverGlyph;
    UpdateWindowRegion; //kt //codex 9/21/26
  end;
  Invalidate;
end;

procedure TPngGlyphButton.UpdateWindowRegion;
//kt //codex added entire procedure 9/21/26
var
  X, Y, RunStart: Integer;
  AlphaRow: PByteArray;
  Region, RunRegion: HRGN;
begin
  if not HandleAllocated then Exit;
  if (FGlyph = nil) or FGlyph.Empty then
  begin
    SetWindowRgn(Handle, 0, True);
    Exit;
  end;
  Region := CreateRectRgn(0, 0, 0, 0);
  try
    if FGlyph.TransparencyMode = ptmPartial then
    begin
      for Y := 0 to FGlyph.Height - 1 do
      begin
        AlphaRow := FGlyph.AlphaScanline[Y];
        X := 0;
        while X < FGlyph.Width do
        begin
          while (X < FGlyph.Width) and (AlphaRow^[X] < 10) do Inc(X);
          RunStart := X;
          while (X < FGlyph.Width) and (AlphaRow^[X] >= 10) do Inc(X);
          if RunStart < X then
          begin
            RunRegion := CreateRectRgn(RunStart, Y, X, Y + 1);
            try
              CombineRgn(Region, Region, RunRegion, RGN_OR);
            finally
              DeleteObject(RunRegion);
            end;
          end;
        end;
      end;
    end
    else
      SetRectRgn(Region, 0, 0, FGlyph.Width, FGlyph.Height);
    if SetWindowRgn(Handle, Region, True) <> 0 then Region := 0;
  finally
    if Region <> 0 then DeleteObject(Region);
  end;
end;

{ Pre-calculates a cached lighter version of the PNG image for fast hover rendering }
procedure TPngGlyphButton.GenerateHoverGlyph;
var
  Y, X: Integer;
  SrcRow, DstRow: PRGBTripleArray;
  SrcAlpha, DstAlpha: PByteArray;
  Factor: Double;
begin
  if (FGlyph = nil) or FGlyph.Empty then
  begin
    FHoverGlyph.Empty;
    Exit;
  end;

  // Clone original properties and alpha tables
  FHoverGlyph.Assign(FGlyph);

  if FHoverLightenPercent = 0 then
    Exit;

  Factor := FHoverLightenPercent / 100.0;

  // Mix RGB pixel data with white (255)
  for Y := 0 to FGlyph.Height - 1 do
  begin
    SrcRow := FGlyph.Scanline[Y];
    DstRow := FHoverGlyph.Scanline[Y];

    for X := 0 to FGlyph.Width - 1 do
    begin
      DstRow^[X].rgbtRed :=
        Round(SrcRow^[X].rgbtRed + (255 - SrcRow^[X].rgbtRed) * Factor);
      DstRow^[X].rgbtGreen :=
        Round(SrcRow^[X].rgbtGreen + (255 - SrcRow^[X].rgbtGreen) * Factor);
      DstRow^[X].rgbtBlue :=
        Round(SrcRow^[X].rgbtBlue + (255 - SrcRow^[X].rgbtBlue) * Factor);
    end;
  end;

  // Perfectly preserve the original alpha transparency mapping
  if FGlyph.TransparencyMode = ptmPartial then
  begin
    for Y := 0 to FGlyph.Height - 1 do
    begin
      SrcAlpha := FGlyph.AlphaScanline[Y];
      DstAlpha := FHoverGlyph.AlphaScanline[Y];
      Move(SrcAlpha^[0], DstAlpha^[0], FGlyph.Width);
    end;
  end;
end;

function TPngGlyphButton.IsPixelTransparent(X, Y: Integer): Boolean;
var
  AlphaRow: PByteArray;
begin
  Result := True;

  if (FGlyph = nil) or FGlyph.Empty then
    Exit;

  if (X < 0) or (X >= FGlyph.Width) or (Y < 0) or (Y >= FGlyph.Height) then
    Exit;

  case FGlyph.TransparencyMode of
    ptmPartial:
      begin
        AlphaRow := FGlyph.AlphaScanline[Y];
        Result := (AlphaRow^[X] < 10);
      end;
    ptmBit:
      begin
        Result := (FGlyph.Canvas.Pixels[X, Y] = FGlyph.TransparentColor);
      end;
    ptmNone:
      Result := False;
  end;
end;

procedure TPngGlyphButton.CMHitTest(var Message: TCMHitTest);
begin
  inherited;
  if (Message.Result = HTCLIENT) then
  begin
    if IsPixelTransparent(Message.XPos, Message.YPos) then
      Message.Result := HTNOWHERE;
  end;
end;

procedure TPngGlyphButton.CMMouseEnter(var Message: TMessage);
begin
  inherited; //kt //codex 9/21/26
  if not FIsHovered then
  begin
    FIsHovered := True;
    Invalidate;
  end;
end;

procedure TPngGlyphButton.CMMouseLeave(var Message: TMessage);
begin
  inherited; //kt //codex 9/21/26
  if FIsHovered then
  begin
    FIsHovered := False;
    FIsPressed := False;
    Invalidate;
  end;
end;

procedure TPngGlyphButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FIsPressed := True;
    Invalidate;
  end;
  inherited;
end;

procedure TPngGlyphButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if FIsPressed then
  begin
    FIsPressed := False;
    Invalidate;
  end;
  inherited;
end;

procedure TPngGlyphButton.Paint;
begin
  if (FGlyph = nil) or FGlyph.Empty then
    Exit;

  if FIsPressed then
    Canvas.Draw(1, 1, FHoverGlyph) // Pressed uses hover graphic shifted by 1px
  else if FIsHovered then
    Canvas.Draw(0, 0, FHoverGlyph) // Draws the white-blended overlay image
  else
    Canvas.Draw(0, 0, FGlyph); // Draws standard raw PNG
end;

//kt //codex original --> initialization
//kt //codex original -->   RegisterClass(TPngGlyphButton);

end.
