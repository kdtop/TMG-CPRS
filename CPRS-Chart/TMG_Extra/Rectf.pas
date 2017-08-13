unit Rectf;
 (*
 Copyright 6/23/2015 Kevin S. Toppenberg, MD
 --------------------------------------------------------------------

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 == Alternatively, at user's choice, GPL license below may be used ===

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may view details of the GNU General Public License at this URL:
 http://www.gnu.org/licenses/
 *)


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Pointf,
  math;

type
  TCorner =         (cNone,
                     cTopLeft,
                     cBottomLeft,
                     cBottomRight,
                     cTopRight);

  TRectSpot =       (rsTopLeft,
                     rsMidLeft,
                     rsBottomLeft,
                     rsMidBottom,
                     rsBottomRight,
                     rsMidRight,
                     rsTopRight,
                     rsMidTop,
                     rsCenter        );


  TRectf = record //class(TPersistent)
    private
      FLeft : single;
      FTop : single;
      FBottom : single;
      FRight : single;
      function GetIntRect : TRect;
      procedure SetIntRect(Value : TRect);
      function GetWidth : single;
      procedure SetWidth(Value : single);
      function GetIntWidth : Integer;
      procedure SetIntWidth(Value : Integer);
      function GetHeight : single;
      procedure SetHeight(Value : single);
      function GetIntHeight : integer;
      procedure SetIntHeight(Value : Integer);
      function GetTopRight: TPointf;
      procedure SetTopRight(Value : TPointf);
      function GetBottomRight: TPointf;
      procedure SetBottomRight(Value : TPointf);
      function GetTopLeft: TPointf;
      procedure SetTopLeft(Value : TPointf);
      function GetBottomLeft: TPointf;
      procedure SetBottomLeft(Value : TPointf);
      function GetIntTop : integer;
      function GetIntLeft : integer;
      function GetIntBottom : integer;
      function GetIntRight : integer;
      function GetCenter : TPointf;
      procedure SetCenter (Value : TPointf);
      function GetDiagonalLen : single;
    public
      //Left : single;
      //Top : single;
      //Bottom : single;
      //Right : single;
      class operator Add(A : TRectf; B : TPointf) : TRectf; overload;
      class operator Add(A : TRectf; B : TPoint) : TRectf; overload;
      class operator Equal(A, B : TRectf) : boolean;
      function ContainsPoint(Pt : TPointf) : boolean; overload;
      function ContainsPoint(Pt : TPoint) : boolean; overload;
      function ContainsPtXDir(Pt : TPointf) : boolean;
      function ContainsPtYDir(Pt : TPointf) : boolean;
      function MidLeft : TPointf;
      function MidBottom : TPointf;
      function MidRight : TPointf;
      function MidTop : TPointf;
      function CornerPt(Corner : TCorner) : TPointf;
      function Spot(Spot : TRectSpot) : TPointf;
      procedure FlipUpDown;
      procedure FlipLeftRight;
      procedure Grow(Size : single);
      procedure Shrink(Size : single);
      function Overlaps(OtherRect : TRectf) : boolean;
      property IntRect : TRect read GetIntRect write SetIntRect;
      property Width : single read GetWidth write SetWidth;
      property Height : single read GetHeight write SetHeight;
      property IntWidth : Integer read GetIntWidth write SetIntWidth;
      property IntHeight : Integer read GetIntHeight write SetIntHeight;
      property TopRight : TPointf read GetTopRight write SetTopRight;
      property BottomRight : TPointf read GetBottomRight write SetBottomRight;
      property BottomLeft : TPointf read GetBottomLeft write SetBottomLeft;
      property TopLeft : TPointf read GetTopLeft write SetTopLeft;
      property Center : TPointf read GetCenter write SetCenter;
      property IntTop : integer read GetIntTop;
      property IntLeft : integer read GetIntLeft;
      property IntBottom : integer read GetIntBottom;
      property IntRight : integer read GetIntRight;
    //published
      property Left : single read FLeft write FLeft;
      property Top : single read FTop write FTop;
      property Bottom : single read FBottom write FBottom;
      property Right : single read FRight write FRight;
      property DiagonalLen : single read GetDiagonalLen;
  end;

function OppositeCorner(Corner : tCorner) : tCorner;

//Some support functions for plain TRects
function EqualRects(R1, R2 : TRect) : boolean;
function InRect(P1 : TPoint; Rect : TRect) : boolean;
function RectOverlapV(ExistRect,MovingRect: TRectf):TPointf;


const
  NULL_RECTf : TRect = (Left: 0; Top : 0; Right: 0; Bottom: 0);
  NULL_RECT : TRect = (Left: 0; Top : 0; Right: 0; Bottom: 0);


implementation

  function RectOverlapV(ExistRect,MovingRect: TRectf):TPointf;
  var Corner : tCorner;
  begin
    Result := ZERO_VECT;
    Corner := cNone;
    if ExistRect.ContainsPtXDir(MovingRect.TopLeft) then begin
      if ExistRect.ContainsPtYDir(MovingRect.TopLeft) then begin
        Corner := cTopLeft;
      end else if ExistRect.ContainsPtYDir(MovingRect.BottomLeft) then begin
        Corner := cBottomLeft;
      end;
    end else if ExistRect.ContainsPtXDir(MovingRect.TopRight) then begin
      if ExistRect.ContainsPtYDir(MovingRect.TopRight) then begin
        Corner := cTopRight;
      end else if ExistRect.ContainsPtYDir(MovingRect.BottomRight) then begin
        Corner := cBottomRight;
      end;
    end;
    if Corner <> cNone then begin
      //Result := CornerPt(OppositeCorner(Corner), ExistRect) - CornerPt(Corner, MovingRect);
      Result := ExistRect.CornerPt(OppositeCorner(Corner)) - MovingRect.CornerPt(Corner);
    end;
  end;




  function InRect(P1 : TPoint; Rect : TRect) : boolean;
  begin
    result := false;
    if P1.X < Rect.Left   then exit;
    if P1.X > Rect.Right  then exit;
    if P1.Y < Rect.Top    then exit;
    if P1.Y > Rect.Bottom then exit;
    result := true;
  end;

  function EqualRects(R1, R2 : TRect) : boolean;
  begin
    Result := (R1.Top  = R2.Top) and
              (R1.Left = R2.Left) and
              (R1.Right = R2.Right) and
              (R1.Bottom = R2.Bottom);
  end;

  function OppositeCorner(Corner : tCorner) : tCorner;
  begin
    case Corner of
      cTopLeft:    Result := cBottomRight;
      cBottomLeft: Result := cTopRight;
      cBottomRight:Result := cTopLeft;
      cTopRight:   Result := cBottomLeft;
    end;
  end;

  //============================================================
  //============================================================

  class operator TRectf.Add(A : TRectf; B : TPointf) : TRectf;
  begin
    Result.TopLeft := A.TopLeft + B;
    Result.BottomRight := A.BottomRight + B;
  end;

  class operator TRectf.Add(A : TRectf; B : TPoint) : TRectf;
  begin
    Result.TopLeft := A.TopLeft + B;
    Result.BottomRight := A.BottomRight + B;
  end;


  class operator TRectf.Equal(A, B : TRectf) : boolean;
  begin
    Result := (A.TopLeft = B.TopLeft) and (A.BottomRight = B.BottomRight);
  end;


  function TRectf.CornerPt(Corner : tCorner) : TPointf;
  begin
    case Corner of
      cTopLeft:    Result := TopLeft;
      cBottomLeft: Result := BottomLeft;
      cBottomRight:Result := BottomRight ;
      cTopRight:   Result := TopRight
    end;
  end;

  function TRectf.Spot(Spot : TRectSpot) : TPointf;
  begin
    case Spot of
      rsTopLeft:     Result := Self.TopLeft;
      rsMidLeft:     Result := Self.MidLeft;
      rsBottomLeft:  Result := Self.BottomLeft;
      rsMidBottom:   Result := Self.MidBottom;
      rsBottomRight: Result := Self.BottomRight;
      rsMidRight:    Result := Self.MidRight;
      rsTopRight:    Result := Self.TopRight;
      rsMidTop:      Result := Self.MidTop;
      rsCenter:      Result := Self.Center;
    end;

  end;

  function TRectf.GetIntRect : TRect;
  begin
    Result.Top := round(Top);
    Result.Left := round(Left);
    Result.Bottom := round(Bottom);
    Result.Right := round(Right);
  end;

  procedure TRectf.SetIntRect(Value : TRect);
  begin
    Top := Value.Top;
    Left := Value.Left;
    Bottom := Value.Bottom;
    Right := Value.Right;
  end;


  function TRectf.GetWidth : single;
  begin
    Result := Right - Left;

  end;

  procedure TRectf.SetWidth(Value : single);
  begin
    Right := Left + Value;
  end;

  function TRectf.GetIntWidth : Integer;
  begin
    Result := Round(GetWidth);
  end;

  procedure TRectf.SetIntWidth(Value : Integer);
  begin
    SetWidth(Value);
  end;


  function TRectf.GetHeight : single;
  begin
    Result := Bottom - Top;
  end;

  procedure TRectf.SetHeight(Value : single);
  begin
    Bottom := Top + Value;
  end;

  function TRectf.GetIntHeight : integer;
  begin
    Result := Round(GetHeight);
  end;

  procedure TRectf.SetIntHeight(Value : Integer);
  begin
    SetHeight(Value)
  end;


  function TRectf.GetTopRight: TPointf;
  begin
    Result.x := Right;
    Result.y := Top;
  end;

  procedure TRectf.SetTopRight(Value : TPointf);
  begin
    Right:= Value.x;
    Top:= Value.y;
  end;

  function TRectf.GetBottomRight: TPointf;
  begin
    Result.x := Right;
    Result.y := Bottom;
  end;

  procedure TRectf.SetBottomRight(Value : TPointf);
  begin
    Right := Value.x;
    Bottom := Value.y;
  end;

  function TRectf.GetTopLeft: TPointf;
  begin
    Result.x := Left;
    Result.y := Top;
  end;

  procedure TRectf.SetTopLeft(Value : TPointf);
  begin
    Left := Value.x;
    Top := Value.y;
  end;

  function TRectf.GetBottomLeft: TPointf;
  begin
    Result.x := Left;
    Result.y := Bottom;
  end;

  procedure TRectf.SetBottomLeft(Value : TPointf);
  begin
    Left := Value.x;
    Bottom := Value.y;
  end;

  function TRectf.GetIntTop : integer;
  begin
    Result := round(Top);
  end;

  function TRectf.GetIntLeft : integer;
  begin
    Result := Round(Left);
  end;

  function TRectf.GetIntBottom : integer;
  begin
    Result := Round(Bottom);
  end;

  function TRectf.GetIntRight : integer;
  begin
    Result := Round(Right);
  end;


  function TRectf.ContainsPtXDir(Pt : TPointf) : boolean;
  begin
    Result := (Pt.x >= Left) and (Pt.x <= Right);
  end;

  function TRectf.ContainsPtYDir(Pt : TPointf) : boolean;
  begin
    Result := (Pt.y >= Top) and (Pt.y <= Bottom);
  end;

  function  TRectf.MidLeft : TPointf;
  begin
    Result.x := Left;
    Result.y := ((Bottom - Top) / 2) + Top;
  end;

  function  TRectf.MidBottom : TPointf;
  begin
    Result.x := ((Right - Left) / 2) + Left;
    Result.y := Bottom;
  end;

  function  TRectf.MidRight : TPointf;
  begin
    Result.x := Right;
    Result.y := ((Bottom - Top) / 2) + Top;
  end;

  function  TRectf.MidTop : TPointf;
  begin
    Result.x := ((Right - Left) / 2) + Left;
    Result.y := Top;
  end;

  function TRectf.ContainsPoint(Pt : TPointf) : boolean;
  begin
    Result := ContainsPtYDir(Pt) and ContainsPtXDir(Pt);
  end;

  function TRectf.ContainsPoint(Pt : TPoint) : boolean;
  var Ptf : TPointf;
  begin
    Ptf.IntPoint := Pt;
    Result := ContainsPoint(Ptf);
  end;

  procedure TRectf.Grow(Size : single);
  begin
    Top := Top - Size;
    Left := Left - Size;
    Right := Right + Size;
    Bottom := Bottom + Size;
  end;

  procedure TRectf.Shrink(Size : single);
  begin
    Top := Top  + Size;
    Left := Left + Size;
    Right := Right - Size;
    Bottom := Bottom - Size;
  end;

  function TRectf.GetCenter : TPointf;
  begin
    Result.x := Self.MidTop.x;
    Result.y := Self.MidLeft.y;
  end;

  procedure TRectf.SetCenter (Value : TPointf);
  var W, H : single;
  begin
    W := Self.Width;
    H := Self.Height;
    Self.Left   := Value.x - (W / 2);
    Self.Right  := Value.x + (W / 2);
    Self.Top    := Value.y - (H / 2);
    Self.Bottom := Value.y + (H / 2);
  end;

  procedure TRectf.FlipUpDown;
  var OldTop : single;
  begin
    OldTop := Top;
    Top := Bottom;
    Bottom := OldTop;
  end;

  procedure TRectf.FlipLeftRight;
  var OldLeft : single;
  begin
    OldLeft := Left;
    Left := Right;
    Right := OldLeft;
  end;


  function TRectf.Overlaps(OtherRect : TRectf) : boolean;
  var Corner : tCorner;
  begin
    Result := (
      Self.ContainsPoint(OtherRect.TopLeft) or
      Self.ContainsPoint(OtherRect.BottomLeft) or
      Self.ContainsPoint(OtherRect.BottomRight) or
      Self.ContainsPoint(OtherRect.TopRight)
    );
  end;

  function TRectf.GetDiagonalLen : single;
  //Return length from top-left to bottom-right (like how TV's are measured)
  var V : TPointf;
  begin
    V := Self.BottomRight - Self.TopLeft;
    Result := V.Length;
  end;

end.
