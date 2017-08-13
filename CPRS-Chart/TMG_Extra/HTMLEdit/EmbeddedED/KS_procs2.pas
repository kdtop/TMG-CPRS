{ ******************************************** }
{       KS_Procs2 ver 1.0 (Oct. 10, 2003)      }
{                                              }
{       For Delphi 4, 5 and 6                  }
{                                              }
{       Copyright (C) 1999-2003, Kurt Senfer.  }
{       All Rights Reserved.                   }
{                                              }
{       Support@ks.helpware.net                }
{                                              }
{       Documentation and updated versions:    }
{                                              }
{       http://KS.helpware.net                 }
{                                              }
{ ******************************************** }
{
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit KS_Procs2;
                                                                          

interface

uses
  Windows;

function KSInputQuery(const ACaption, APrompt: string; aDefault: string; NumChars: Integer = 0): String;



implementation

uses Forms, stdctrls, graphics, Consts, Controls;



function KSInputQuery(const ACaption, APrompt: string; aDefault: string; NumChars: Integer = 0): String;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  aWidth: Integer;

  //------------------------------------------------
  function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;
  //------------------------------------------------
begin
  Result := '';

  Form := TForm.Create(Application);
  try
     DialogUnits := GetAveCharSize(Form.Canvas);

     if (NumChars < 20) or (NumChars > 80)
        then aWidth := 180  //default 30 * w
        else aWidth := NumChars * DialogUnits.X;

     Form.Canvas.Font := Form.Font;

     Form.BorderStyle := bsDialog;
     Form.Caption := ACaption;
     Form.ClientWidth := MulDiv(aWidth, DialogUnits.X, 4);
     Form.ClientHeight := MulDiv(63, DialogUnits.Y, 8);
     Form.Position := poScreenCenter;

     Prompt := TLabel.Create(Form);
     Prompt.Parent := Form;
     Prompt.AutoSize := True;
     Prompt.Left := MulDiv(8, DialogUnits.X, 4);
     Prompt.Top := MulDiv(8, DialogUnits.Y, 8);
     Prompt.Caption := APrompt;


     Edit := TEdit.Create(Form);
     Edit.Parent := Form;
     Edit.Left := Prompt.Left;
     Edit.Top := MulDiv(19, DialogUnits.Y, 8);
     Edit.Width := MulDiv(aWidth - 16{164}, DialogUnits.X, 4);
     Edit.MaxLength := 255;
     Edit.Text := aDefault;
     Edit.SelectAll;


     ButtonTop := MulDiv(41, DialogUnits.Y, 8);
     ButtonWidth := MulDiv(50, DialogUnits.X, 4);
     ButtonHeight := MulDiv(14, DialogUnits.Y, 8);

     with TButton.Create(Form) do
        begin
           Parent := Form;
           Caption := SMsgDlgOK;
           ModalResult := mrOk;
           Default := True;
           SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth, ButtonHeight);
        end;

     with TButton.Create(Form) do
        begin
           Parent := Form;
           Caption := SMsgDlgCancel;
           ModalResult := mrCancel;
           Cancel := True;
           SetBounds(MulDiv(92, DialogUnits.X, 4), ButtonTop, ButtonWidth, ButtonHeight);
        end;

     if Form.ShowModal = mrOk
        then result := Edit.Text;
  finally
     Form.Free;
  end;
end;
//------------------------------------------------------------------------------

end.