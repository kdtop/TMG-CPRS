unit uTMGUtil;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils,
  ORNet, ORFn, ComCtrls, Grids, ORCtrls, ExtCtrls, Buttons,
  uTMGTypes, SortStringGrid;


//Forward declarations
function  ExtractNum (S : String; StartPos : integer=1) : string;
function  IsSubFile(FieldDef: string ; var SubFileNum : string) : boolean;
function  FindInStrings(fieldNum : string; Strings : TStringList; var fileNum : string) : integer;
function  FindInSL(SL : TStringList; PieceNum : integer; Value : String) : integer;  //returns index or -1
function  GetOneLine(CurrentData : TStrings; oneFileNum, oneFieldNum : string) : string;
function  GetOneFldValue(CurrentData : TStrings; oneFileNum, oneFieldNum : string; PieceNum : integer) : string;
//function  GetFieldLine(FieldNum : string; Data : TStringList) : string;
function  GetUserLine(Data : TStringList; Grid : TSortStringGrid; ARow: integer) : integer;
procedure ExtractVarPtrInfo(VarPtrInfo,Data : TStringList; FileNum,FieldNum : string);
function  GetAClassName(Handle : HWND) : string;
function  FindParam(Param : string) : string;
procedure InitORComboBox(ORComboBox: TORComboBox; initValue : string);
function TMGSpecialLocation : string;
function AtFPGLoc : boolean;
function AtIntracareLoc : boolean;
function HexToTColor(sColor : string) : TColor;

implementation

  uses
    uTMGOptions;

  var
    TMG_Special_Location : string;

  function GetOneLine(CurrentData : TStrings; oneFileNum,oneFieldNum : string) : string;
  var i : integer;
      FileNum,FieldNum : string;
  begin
    result := '';
    // FileNum^IENS^FieldNum^FieldName^newValue^oldValue
    //for i := 1 to CurrentData.Count - 1 do begin
    for i := 0 to CurrentData.Count - 1 do begin
      FileNum := piece(CurrentData.Strings[i],'^',1);
      if FileNum <> oneFileNum then continue;
      FieldNum := piece(CurrentData.Strings[i],'^',3);
      if FieldNum <> oneFieldNum then continue;
      result := CurrentData.Strings[i];
      break;
    end;
  end;

  function GetOneFldValue(CurrentData : TStrings; oneFileNum, oneFieldNum : string; PieceNum : integer) : string;
  var s : string;
  begin
    s := GetOneLine(CurrentData, oneFileNum, oneFieldNum);
    Result := piece(s,'^', PieceNum);
  end;

  function ExtractNum (S : String; StartPos : integer=1) : string;
  var i : integer;
      ch : char;
  begin
    result := '';
    if (S = '') or (StartPos < 0) then exit;
    i := StartPos;
    repeat
      ch := S[i];
      i := i + 1;
      if ch in ['0'..'9','.'] then begin
        Result := Result + ch;
      end;
    until (i > length(S)) or not  (ch in ['0'..'9','.'])
  end;

  function IsSubFile(FieldDef: string ; var SubFileNum : string) : boolean;
  //SubFileNum is OUT parameter
  begin
    SubFileNum := ExtractNum(FieldDef,1);
    result := (SubFileNum <> '');
  end;

  function FindInStrings(fieldNum : string; Strings : TStringList; var fileNum : string) : integer;
  //Note: if fileNum is passed blank, then first matching file will be placed in it (i.e. OUT parameter)
  var tempFieldNum : string;
      oneEntry,tempFile : string;
      i : integer;
  begin
    result := -1;
    fileNum := '';
    for i := 0 to Strings.Count-1 do begin
      oneEntry := Strings.Strings[i];
      tempFile := Piece(oneEntry,'^',1);
      //Sometimes, index 0 --> 1^success, and should be skipped
      if (tempFile='1') and (UpperCase(Piece(oneEntry,'^',2))='SUCCESS') then continue;  //kt 12/18/13
      if (fileNum='') and (tempFile<>'INFO') then fileNum := tempFile;
      if tempFile <> fileNum then continue; //ignore subfiles
      tempFieldNum := Piece(oneEntry,'^',3);
      if tempFieldNum <> fieldNum then continue;
      Result := i;
      break;
    end;
  end;

  function  FindInSL(SL : TStringList; PieceNum : integer; Value : String) : integer;
  //returns index or -1
  //Case-specific matches only
  var i : integer;
  begin
    Result := -1;
    for i := 0 to SL.Count - 1 do begin
      if piece(SL[i], '^', PieceNum) = Value then begin
        Result := i;
        break;
      end;
    end;
  end;


  function GetUserLine(Data : TStringList; Grid : TSortStringGrid; ARow: integer) : integer;
  var fieldNum: string;
      tempFileNum : string;
  begin
    fieldNum := Grid.Cells[0,ARow];
    Result := FindInStrings(fieldNum, Data, tempFileNum);
  end;

  procedure ExtractVarPtrInfo(VarPtrInfo,Data : TStringList; FileNum,FieldNum : string);
  //Format of Data:
  //Data[1]='FileNum^IENS^FieldNum^ExtValue^FieldName^DDInfo...
  //Data[2]='FileNum^IENS^FieldNum^ExtValue^FieldName^DDInfo...
  //...
  //Data[3]='INFO^DD^FileNum^FieldNum^V ...
  //       this provides all the V nodes for a variable pointer.  See Fileman documentation for details.
  //Example:
  //Data[x]='INFO^DD^801.41,15,"V",0)&=&"^.12P^12^12"
  //Data[x]='INFO^DD^801.41,15,"V",1,0)&=&"9999999.09^EDUCATION TOPICS^5^ED^n^n"
  //Data[x]='INFO^DD^801.41,15,"V",2,0)&=&"9999999.14^IMMUNIZATION^10^IM^n^n"
  //Data[x]='INFO^DD^801.41,15,"V",3,0)&=&"9999999.28^SKIN TEST^15^ST^n^n"
  //Data[x]='INFO^DD^801.41,15,"V",4,0)&=&"9999999.15^EXAM^20^EX^n^n"
  //Data[x]='INFO^DD^801.41,15,"V",5,0)&=&"9999999.64^HEALTH FACTOR^25^HF^y^n"
  //Data[x]='INFO^DD^801.41,15,"V",5,1)&=&"S DIC(""S"")=""I $P(^(0),U,10)'=""""C"""""""
  //Data[x]='INFO^DD^801.41,15,"V",5,2)&=&"IGNORE CATEGORIES"
  //Data[x]='INFO^DD^801.41,15,"V",6,0)&=&"81^PROCEDURE^30^CPT^n^n"
  //Data[x]='INFO^DD^801.41,15,"V",7,0)&=&"80^ICD9 DIAGNOSIS^35^ICD9^n^n"
  //Data[x]='INFO^DD^801.41,15,"V",8,0)&=&"120.51^VITAL TYPE^40^VM^n^n"
  //Data[x]='INFO^DD^801.41,15,"V",9,0)&=&"811.2^TAXONOMY^45^TX^n^n"
  //Data[x]='INFO^DD^801.41,15,"V",10,0)&=&"101.41^ORDER DIALOG^50^Q^n^n"
  //Data[x]='INFO^DD^801.41,15,"V",11,0)&=&"601.71^MENTAL HEALTH^55^MH^y^n"
  //Data[x]='INFO^DD^801.41,15,"V",11,1)&=&"S DIC(""S"")=""I $$MH^PXRMDLG5(Y)=1"""
  //Data[x]='INFO^DD^801.41,15,"V",11,2)&=&"Check to see if the MH test exceeds the maxinum numbers of questions defined in file 800"
  //Data[x]='INFO^DD^801.41,15,"V",12,0)&=&"790.404^WH NOTIFICATION PURPOSE^60^WH^n^n"

  //Format of output VarPtrInfo
  //VarPtrInfo[1]=ShowOrder^Filenum^FileName^Abbreviation

  var i : integer;
      temp, oneEntry : string;
      Order,P2FileNum,P2FileName,Abbrev : string;
      Nodes,DDVal : string;
  begin
    VarPtrInfo.Clear;
    for i := 0 to Data.Count-1 do begin
      oneEntry := Data.Strings[i];
      if piece(oneEntry,'^',1) <> 'INFO' then continue;
      if piece(oneEntry,'^',3) <> FileNum then continue;
      if piece(oneEntry,'^',4) <> FieldNum then continue;
      temp := pieces(oneEntry,'^',1,4)+'^';
      oneEntry := MidStr(oneEntry,length(temp)+1,length(oneEntry));
      Nodes := piece2(oneEntry,'&=&',1);
      Nodes := piece(Nodes,')',1);
      DDVal := piece2(oneEntry,'&=&',2);
      if StrToIntDef(piece(Nodes,',',2),-1) = -1 then continue;
      if StrToIntDef(piece(Nodes,',',3),-1) <> 0 then continue;
      P2FileNum := Piece(DDVal,'^',1);
      P2FileName := Piece(DDVal,'^',2);
      Order := Piece(DDVal,'^',3);
      Abbrev := Piece(DDVal,'^',4);
      VarPtrInfo.Add(Order+'^'+P2FileNum+'^'+P2FileName+'^'+Abbrev);
    end;
  end;

  function GetAClassName(Handle : HWND) : string;
  var
    ItemBuffer  : array[0..256] of Char;
  begin
    GetClassName(Handle, ItemBuffer, SizeOf(ItemBuffer));
    Result := ItemBuffer;
  end;

  function FindParam(Param : string) : string;
  //Searches command line parameters for Param.  If found, then value returned.
  //Case insensitive
  //Must be in 'param=value' format, i.e. must have '='
  var  i : integer;
       tempS : string;
  begin
    Result := '';
    Param := LowerCase(Param);
    for i := 1 to ParamCount do begin
      tempS := LowerCase (ParamStr(i));
      if Pos(Param,tempS)>0 then Result := Piece(tempS,'=',2);
    end;
  end;

  //kt moved from MainU 12/18/13
  procedure InitORComboBox(ORComboBox: TORComboBox; initValue : string);
  var IENStr : string;
      IEN : LongInt;
  begin
    ORComboBox.Items.Clear;
    ORComboBox.Text := initValue;
    ORComboBox.InitLongList(initValue);
    if ORComboBox.Items.Count > 0 then begin
      ORComboBox.Text := Piece(ORComboBox.Items[0],'^',2);
      IENStr := Piece(ORComboBox.Items[0],'^',1);
      if (IENStr <> '') and (Pos('.', IENStr)=0) then begin
        IEN := StrToInt(IENStr);
        ORComboBox.SelectByIEN(IEN);
      end;
    end else begin
      ORComboBox.Text := '<Start Typing to Search>';
    end;
  end;

  function TMGSpecialLocation : string;
  //Function so RPC for read only has to be done once per session
  const CHECKED_AND_EMPTY = '<checked and empty>';
  begin
    if TMG_Special_Location = '' then begin
      Result := uTMGOptions.ReadString('SpecialLocation','');
      TMG_Special_Location := Result;
      if TMG_Special_Location = '' then TMG_Special_Location := CHECKED_AND_EMPTY;
    end else begin
      Result := TMG_Special_Location;
      if Result = CHECKED_AND_EMPTY then Result := '';
    end;
  end;

  function AtFPGLoc : boolean;
  begin
    Result := TMGSpecialLocation = 'FPG';
  end;

  function AtIntracareLoc : boolean;
  begin
    Result := TMGSpecialLocation = 'INTRACARE';
  end;


  function HexToTColor(sColor : string) : TColor;
  begin
   Result := RGB( StrToInt('$'+Copy(sColor, 1, 2)),
                  StrToInt('$'+Copy(sColor, 3, 2)),
                  StrToInt('$'+Copy(sColor, 5, 2))  ) ;
  end;

initialization
  TMG_Special_Location := '';

end.
