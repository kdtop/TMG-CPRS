unit fLetterShowPatientList;
//VEFA-261 added unit.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ORFn,fBase508Form, VA508AccessibilityManager;

type
  TfrmLetterShowPatientList = class(TfrmBase508Form)
    btnDone: TBitBtn;
    StringGrid: TStringGrid;
    procedure StringGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure StringGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure StringGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    SaveFont : TFont;
    ButtonFont : TFont;
    MouseDownPos : TPoint;
    FPatientListPtr : TStringList;  //owned elsewhere
    procedure ShowCurPatientList;
    function DrawButtonFace(Canvas: TCanvas; ALabel : String; AFont : TFont; TextBackgroundColor : TColor;  const Client: TRect;
                            BevelWidth: Integer; IsRounded, IsDown, IsFocused: Boolean): TRect;

  public
    { Public declarations }
    procedure ClearGrid;
    procedure Initialize(PatientList : TStringList);
  end;

var
  frmLetterShowPatientList: TfrmLetterShowPatientList;

implementation

{$R *.dfm}

  const
    BUTTON_COL_WIDTH = 90;

  procedure TfrmLetterShowPatientList.ClearGrid;
  var Row,Col : integer;
  begin
    for Row := 0 to StringGrid.RowCount-1 do begin
      for Col := 0 to StringGrid.ColCount-1 do begin
        StringGrid.Cells[Col,Row] := '';
      end;
    end;
    StringGrid.ColCount := 3;
    StringGrid.RowCount := 2;
    StringGrid.Cells[0,0] := 'Name';
    StringGrid.Cells[1,0] := 'Additional Info';
  end;


  procedure TfrmLetterShowPatientList.FormCreate(Sender: TObject);
  begin
    SaveFont := TFont.Create;
    ButtonFont := TFont.Create;
    ButtonFont.Assign(StringGrid.Canvas.Font);
    ButtonFont.Color := clBlue;
  end;

  procedure TfrmLetterShowPatientList.FormDestroy(Sender: TObject);
  begin
    SaveFont.Free;
    ButtonFont.Free;
  end;

procedure TfrmLetterShowPatientList.FormResize(Sender: TObject);

  begin
    StringGrid.ColWidths[0] := (Self.Width - BUTTON_COL_WIDTH) div 3;
    StringGrid.ColWidths[1] := Self.Width - BUTTON_COL_WIDTH - StringGrid.ColWidths[0] - 30;
    StringGrid.ColWidths[2] := BUTTON_COL_WIDTH;
  end;

  procedure TfrmLetterShowPatientList.FormShow(Sender: TObject);
  begin
    FormResize(Sender);
  end;

  procedure TfrmLetterShowPatientList.Initialize(PatientList : TStringList);
  begin
    FPatientListPtr := PatientList;  //owned elsewhere
    ShowCurPatientList;
  end;

  procedure TfrmLetterShowPatientList.ShowCurPatientList;
  var i : integer;
      Name, Info : string;
      AddToRow : integer;
      FirstRowEmpty : boolean;
  begin
    ClearGrid;
    FirstRowEmpty := true;
    if not assigned(FPatientListPtr) then exit;
    for i := 0 to FPatientListPtr.Count - 1 do begin
      Name := piece(FPatientListPtr.Strings[i],'^',2);
      Info := piece(FPatientListPtr.Strings[i],'^',3);
      if FirstRowEmpty = false then begin
        StringGrid.RowCount := StringGrid.RowCount + 1
      end else begin
         FirstRowEmpty := false;
      end;
      AddToRow := StringGrid.RowCount -1;
      StringGrid.Cells[0,AddToRow] := Name;
      StringGrid.Cells[1,AddToRow] := Info;
    end;
  end;



  { DrawButtonFace -- modified from Buttons.DrawButtonFace
    - returns the remaining usable area inside the Client rect.}
  function TfrmLetterShowPatientList.DrawButtonFace(Canvas: TCanvas;
                                                    ALabel : String;
                                                    AFont : TFont;
                                                    TextBackgroundColor : TColor;
                                                    const Client: TRect;
                                                    BevelWidth: Integer; IsRounded, IsDown, IsFocused: Boolean): TRect;
  var
    R: TRect;
    DC: THandle;
    XYSize : Windows.TSize;
    TextXYPos : TPoint;

  begin
    R := Client;
    with Canvas do begin
      Brush.Color := TextBackgroundColor;  //<-- doesn't seem to do anything.
      Brush.Style := bsSolid;
      DC := Canvas.Handle;    { Reduce calls to GetHandle }

      if IsDown then begin    { DrawEdge is faster than Polyline }
        DrawEdge(DC, R, BDR_SUNKENINNER, BF_TOPLEFT);              { black     }
        DrawEdge(DC, R, BDR_SUNKENOUTER, BF_BOTTOMRIGHT);          { btnhilite }
        Dec(R.Bottom);
        Dec(R.Right);
        Inc(R.Top);
        Inc(R.Left);
        DrawEdge(DC, R, BDR_SUNKENOUTER, BF_TOPLEFT or BF_MIDDLE); { btnshadow }
      end else begin
        DrawEdge(DC, R, BDR_RAISEDOUTER, BF_BOTTOMRIGHT);          { black }
        Dec(R.Bottom);
        Dec(R.Right);
        DrawEdge(DC, R, BDR_RAISEDINNER, BF_TOPLEFT);              { btnhilite }
        Inc(R.Top);
        Inc(R.Left);
        DrawEdge(DC, R, BDR_RAISEDINNER, BF_BOTTOMRIGHT or BF_MIDDLE); { btnshadow }
      end;
    end;
    Application.ProcessMessages;

    Result := Rect(Client.Left + 1, Client.Top + 1, Client.Right - 2, Client.Bottom - 2);
    if IsDown then OffsetRect(Result, 1, 1);

    XYSize := Canvas.TextExtent(ALabel);
    TextXYPos.X := ((Result.Right - Result.Left) - XYSize.cx) div 2;
    if TextXYPos.X < 1 then TextXYPos.X := 1;
    TextXYPos.Y := ((Result.Bottom - Result.Top) - XYSize.cy) div 2;
    if TextXYPos.Y < 1 then TextXYPos.Y := 1;
    TextXYPos.X := TextXYPos.X + Result.Left;
    TextXYPos.Y := TextXYPos.Y + Result.Top;

    Canvas.Brush.Color := TextBackgroundColor;
    SaveFont.Assign(Canvas.Font);
    Canvas.Font.Assign(AFont);
    Canvas.TextOut(TextXYPos.X, TextXYPos.Y, ALabel);
    Canvas.Font.Assign(SaveFont);
  end;


  procedure TfrmLetterShowPatientList.StringGridDrawCell(Sender: TObject;
                                                         ACol, ARow: Integer; Rect: TRect;
                                                         State: TGridDrawState);
  var IsDown : boolean;
  const BUTTON_TEXT = '  Exclude  ';
        clLightRed = $006255FF;
        clLightYellow = $00BFFFFF;
  begin
    if (ACol <> 2) or (ARow = 0) then exit;
    IsDown := (ACol = MouseDownPos.X) and (ARow = MouseDownPos.Y);
    ButtonFont.Color := clBlack;
    DrawButtonFace(StringGrid.Canvas, BUTTON_TEXT, ButtonFont, clLightYellow, Rect, 1, True, IsDown, false);
    //Application.ProcessMessages;
  end;

  procedure TfrmLetterShowPatientList.StringGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,  Y: Integer);
  var ACol, ARow : integer;
  begin
    StringGrid.MouseToCell(X,Y, ACol, ARow);
    if (ACol = 2) and (ARow > 0) then begin
      MouseDownPos.X := ACol;
      MouseDownPos.Y := ARow;
    end;
  end;

  procedure TfrmLetterShowPatientList.StringGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var ACol, ARow : integer;
  begin
    if (MouseDownPos.X = -1) and (MouseDownPos.Y = -1) then exit;
    StringGrid.MouseToCell(X,Y, ACol, ARow);
    if (ACol=MouseDownPos.X) and (ARow = MouseDownPos.Y) then begin
      if MessageDlg('Remove patient from printing list?' +#10#13 +
                 '(Note: doesn''t remove from original source list)' , mtConfirmation ,mbOKCancel,0) = mrOK then begin
        FPatientListPtr.Delete(ARow-1);
        ShowCurPatientList;
      end;
    end;
    MouseDownPos.X := -1;
    MouseDownPos.Y := -1;
    StringGrid.Invalidate;
  end;

  procedure TfrmLetterShowPatientList.StringGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  var ACol, ARow : integer;
  begin
    if (MouseDownPos.X = -1) and (MouseDownPos.Y = -1) then exit;
    StringGrid.MouseToCell(X,Y, ACol, ARow);
    if (ACol <> MouseDownPos.X) or (ARow <> MouseDownPos.Y) then begin
      MouseDownPos.X := -1;
      MouseDownPos.Y := -1;
      StringGrid.Invalidate;
    end;
  end;



end.

