unit Pointf;
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
  Windows, Messages, SysUtils, Variants, Classes, math;
type
  TPointf = record //class(TPersistent)
    private
      //Fx : single;
      //Fy : single;
      function GetPoint : TPoint;
      procedure SetIntPoint(Value : TPoint);
      function GetIntX : integer;
      function GetIntY : integer;
      function GetAngle : single;
    public
      x : single;
      y : single;
      class operator Add(A, B : TPointf) : TPointF; overload;
      class operator Add(A : TPoint; B : TPointf) : TPointF; overload;
      class operator Add(A : TPointf; B : TPoint) : TPointF; overload;
      class operator Add(A : TPointf; B : single) : TPointF; overload;
      class operator Subtract(A, B : TPointf) : TPointF;
      class operator Subtract(A : TPoint; B : TPointf) : TPointF; overload;
      class operator Subtract(A : TPointf; B : TPoint) : TPointF; overload;
      class operator Subtract(A : TPointf; B : single) : TPointF; overload;
      class operator Divide(A : TPointf; B : Single) : TPointF;
      class operator Multiply(A : TPointf; B : Single) : TPointF;
      class operator Equal(A, B : TPointf) : boolean;
      function Length : single;
      procedure Zero;
      procedure SetUnity;
      procedure ScaleBy(Value : single);
      procedure ScaleToLen(Len : single);
      property IntPoint : TPoint read GetPoint write SetIntPoint;
      property IntX : integer read GetIntX;
      property IntY : integer read GetIntY;
      property Angle : single read GetAngle;
  //  published
  //    property x : single read Fx write Fx;
  //    property y : single read Fy write Fy;
  end;

const
  NUM_AVG_BUFFER_MAX = 16;

type
  TNumAverager = record
    private
      Buffer : array[0..NUM_AVG_BUFFER_MAX] of single;
    public
      InsertPt : byte;
      procedure AddNum(Value : single);
      function Avg : single;
      procedure Clear;
  end;

  TPointfAvg = record
    private
      Buffer : array[0..NUM_AVG_BUFFER_MAX] of TPointf;
    public
      InsertPt : byte;
      procedure Add(Value : TPointf);
      function Avg : TPointf;
      procedure Clear;
  end;


function RotatePoint(P : TPointf; Alpha : single) : TPointf;

//Some support functions for plain TRects
function AddPoint(P1, P2 : TPoint) : TPoint;
function SubtractPoint(P1, P2 : TPoint) : TPoint; //Return P1 - P2

const
  ZERO_VECT  : TPointf = (x:0; y:0);
  NULL_VECT  : TPointf = (x:0; y:0);
  ZERO_POINT : TPoint  = (X:0; Y: 0);
  UNIT_VECT  : TPointf = (x:1; y:1);

  N_VECT  : TPointf = (x:0;  y:-1);
  NW_VECT : TPointf = (x:-1; y:-1);
  W_VECT  : TPointf = (x:-1; y:0);
  SW_VECT : TPointf = (x:-1; y:1);
  S_VECT  : TPointf = (x:0;  y:1);
  SE_VECT : TPointf = (x:1;  y:1);
  E_VECT  : TPointf = (x:1;  y:0);
  NE_VECT : TPointf = (x:1;  y:-1);

implementation

  //=================================================

  procedure TNumAverager.AddNum(Value : single);
  begin
    Buffer[InsertPt] := Value;
    Inc(InsertPt);
    if InsertPt > NUM_AVG_BUFFER_MAX then InsertPt :=0;
  end;

  function TNumAverager.Avg : single;
  var i : byte;
      sum : single;
  begin
    sum := 0;
    for i := 0 to NUM_AVG_BUFFER_MAX do begin
      sum := sum + Buffer[i];
    end;
    Result := sum / NUM_AVG_BUFFER_MAX;
  end;

  procedure TNumAverager.Clear;
  var i : byte;
  begin
    for i := 0 to NUM_AVG_BUFFER_MAX do Buffer[i] := 0;
  end;

  //=================================================

  procedure TPointfAvg.Add(Value : TPointf);
  begin
    Buffer[InsertPt] := Value;
    Inc(InsertPt);
    if InsertPt > NUM_AVG_BUFFER_MAX then InsertPt :=0;
  end;

  function TPointfAvg.Avg : TPointf;
  var i : byte;
      sumX, sumY : single;
  begin
    sumX := 0; sumY := 0;
    for i := 0 to NUM_AVG_BUFFER_MAX do begin
      sumX := sumX + Buffer[i].x;
      sumY := sumY + Buffer[i].y;
    end;
    Result.x := sumX / NUM_AVG_BUFFER_MAX;
    Result.y := sumY / NUM_AVG_BUFFER_MAX;
  end;

  procedure TPointfAvg.Clear;
  var i : byte;
  begin
    for i := 0 to NUM_AVG_BUFFER_MAX do Buffer[i].Zero;
  end;

  //=============================================================
  //=============================================================


  function AddPoint(P1, P2 : TPoint) : TPoint;
  begin
    Result.X := P1.X + P2.X;
    Result.Y := P1.Y + P2.Y;
  end;

  function SubtractPoint(P1, P2 : TPoint) : TPoint;
  //Return P1 - P2
  begin
    Result.X := P1.X - P2.X;
    Result.Y := P1.Y - P2.Y;
  end;

  function RotatePoint(P : TPointf; Alpha : single) : TPointf;
  var Cos, Sin : extended;
  begin
    SinCos(Alpha, Sin, Cos);
    Result.X := Round((P.X * Cos) - (P.Y * Sin));
    Result.Y := Round((P.X * Sin) + (P.Y * Cos));
  end;

  //=============================================================
  //=============================================================

  class operator TPointf.Add(A, B : TPointf) : TPointf;
  begin
    Result.x := A.x + B.x;
    Result.y := A.y + b.y;
  end;

  class operator TPointf.Add(A : TPoint; B : TPointf) : TPointF;
  begin
    Result.x := A.x + B.x;
    Result.y := A.y + b.y;
  end;

  class operator TPointf.Add(A : TPointf; B : TPoint) : TPointF;
  begin
    Result.x := A.x + B.x;
    Result.y := A.y + b.y;
  end;

  class operator TPointf.Add(A : TPointf; B : single) : TPointF;
  begin
    Result.x := A.x + B;
    Result.y := A.y + B;
  end;


  class operator TPointf.Subtract(A, B : TPointf) : TPointF;
  begin
    Result.x := A.x - B.x;
    Result.y := A.y - b.y;
  end;

  class operator TPointf.Subtract(A : TPoint; B : TPointf) : TPointF;
  begin
    Result.x := A.x - B.x;
    Result.y := A.y - b.y;
  end;

  class operator TPointf.Subtract(A : TPointf; B : TPoint) : TPointF;
  begin
    Result.x := A.x - B.x;
    Result.y := A.y - b.y;
  end;

  class operator TPointf.Subtract(A : TPointf; B : single) : TPointF;
  begin
    Result.x := A.x - B;
    Result.y := A.y - B;
  end;



  class operator TPointf.Divide(A : TPointf; B : Single) : TPointF;
  begin
    Result.x := A.x / B;
    Result.y := A.y / B;
  end;

  class operator TPointf.Multiply(A : TPointf; B : Single) : TPointF;
  begin
    Result.x := A.x * B;
    Result.y := A.y * B;
  end;

  class operator TPointf.Equal(A, B : TPointf) : boolean;
  begin
    Result := (A.x = B.x) and (A.y = B.y);
  end;

  function TPointf.Length : single;
  begin
    Result := Sqrt(Sqr(x) + Sqr(y));
  end;

  function TPointf.GetPoint : TPoint;
  begin
    if x < 0.00001 then x := 0;  //needed to prevent a floating point error with very small x values
    if y < 0.00001 then y := 0;
    Result.X := Round(x);
    Result.Y := round(y);
  end;


  procedure TPointf.SetIntPoint(Value : TPoint);
  begin
    x := Value.X;
    y := Value.Y;
  end;

  function TPointf.GetIntX : integer;
  begin
    Result := round(x);
  end;

  function TPointf.GetIntY : integer;
  begin
    Result := round(y);
  end;

  procedure TPointf.ScaleBy(Value : single);
  begin
    x := x * Value;
    y := y * Value;
  end;


  procedure TPointf.ScaleToLen(Len : single);
  var OldLen, Ratio : Extended;

  begin
    OldLen := Self.Length;
    if OldLen <> 0 then begin
      Ratio := Len / OldLen;   //New / old
    end else begin
      Ratio := 0; //really undefined....
    end;
    x := x * Ratio;
    y := y * Ratio;
  end;

  procedure TPointf.SetUnity;
  begin
    x := 1;
    y := 1;
  end;

  procedure TPointf.Zero;
  begin
    x := 0;
    y := 0;
  end;

  function TPointf.GetAngle : single;
  //Return the angle represented by the vector
  begin
    if x = 0 then begin
      if y > 0 then begin
        Result := PI / 2;
      end else if y < 0 then begin
        Result := 3 * PI / 2;
      end else begin
        Result := 0;  //really undefined....
      end;
    end else begin
      Result := ArcTan2(y, x);
    end;
  end;



end.
