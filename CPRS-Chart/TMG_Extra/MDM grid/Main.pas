unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons


  ;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DrawTextRotatedB(ACanvas: TCanvas; Angle, X, Y: Integer;  //temp
                               ATextColor: TColor; AText: String);

  end;

var
  Form1: TForm1;

implementation

uses MDMHelper;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  frmMDMGrid: TfrmMDMGrid;    //not autocreated
  s : string;
  i : integer;
  SL : TStringList;

begin
  frmMDMGrid := TfrmMDMGrid.Create(Self);
  if frmMDMGrid.ShowModal = mrOK then begin
    Memo1.Lines.Add(frmMDMGrid.CPT);
    Memo1.Lines.Add(frmMDMGrid.Narrative);
    SL := frmMDMGrid.TextTable;
    for i := 0 to SL.Count - 1 do begin
      Memo1.Lines.Add(SL[i]);
    end;

  end;
  frmMDMGrid.Free;
end;



//-------------------------------------


procedure TForm1.DrawTextRotatedB(ACanvas: TCanvas; Angle, X, Y: Integer;
  ATextColor: TColor; AText: String);
  //from here: https://stackoverflow.com/questions/52916612/how-to-draw-text-in-a-canvas-vertical-horizontal-with-delphi-10-2/52923681
var
  NewX: Integer;
  NewY: integer;
  Escapement: Integer;
  LogFont: TLogFont;
  NewFontHandle: HFONT;
  OldFontHandle: HFONT;
begin
  if not Assigned(ACanvas) then Exit;

  // Get handle of font and prepare escapement
  GetObject(ACanvas.Font.Handle, SizeOf(LogFont), @LogFont);
  if Angle > 360 then Angle := 0;
  Escapement := Angle * 10;

  // We must initialise all fields of the record structure
  LogFont.lfWidth := 0;
  LogFont.lfHeight := ACanvas.Font.Height;
  LogFont.lfEscapement := Escapement;
  LogFont.lfOrientation := 0;
  if fsBold in ACanvas.Font.Style then
    LogFont.lfWeight := FW_BOLD
  else
    LogFont.lfWeight := FW_NORMAL;
  LogFont.lfItalic := Byte(fsItalic in ACanvas.Font.Style);
  LogFont.lfUnderline := Byte(fsUnderline in ACanvas.Font.Style);
  LogFont.lfStrikeOut := Byte(fsStrikeOut in ACanvas.Font.Style);
  LogFont.lfCharSet := ACanvas.Font.Charset;
  LogFont.lfOutPrecision := OUT_DEFAULT_PRECIS;
  LogFont.lfClipPrecision := CLIP_DEFAULT_PRECIS;
  LogFont.lfQuality := DEFAULT_QUALITY;
  LogFont.lfPitchAndFamily := DEFAULT_PITCH;
  StrPCopy(LogFont.lfFaceName, ACanvas.Font.Name);

  // Create new font with rotation
  NewFontHandle := CreateFontIndirect(LogFont);
  try
    // Set color of text
    ACanvas.Font.Color := ATextColor;

    // Select the new font into the canvas
    OldFontHandle := SelectObject(ACanvas.Handle, NewFontHandle);
    try
      // Output result
      ACanvas.Brush.Style := Graphics.bsClear;
      try
        ACanvas.TextOut(X, Y, AText);
      finally
        ACanvas.Brush.Style := Graphics.bsSolid;
      end;
    finally
      // Restore font handle
      NewFontHandle := SelectObject(ACanvas.Handle, OldFontHandle);
    end;
  finally
    // Delete the deselected font object
    DeleteObject(NewFontHandle);
  end;
end;


end.
