unit uTemplateMath;
//kt-tm added entire unit

 (*
 NOTE: The original version of this file may be obtained freely from the VA.

 This modified version of the file is Copyright 6/23/2015 Kevin S. Toppenberg, MD
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
  Forms, SysUtils, Classes, Dialogs, StdCtrls, ExtCtrls, Controls,
  VAUtils,
  ComCtrls, TypInfo, StrUtils;


procedure HideFormulas(SL : TStrings; Formulas : TStringList);
procedure HideTxtObjects(SL : TStrings; TxtObjects : TStringList);
function RestoreTransformFormulas(SL : TStrings) : boolean;
function RestoreTransformTxtObjects(SL : TStrings) : boolean;
function CloseCharPos(OpenChar, CloseChar : char; var Txt : string; StartingPos : integer=1) : integer;
function ResolveTemplateFieldsMath(Text: string; Entries: TStringList; AutoWrap: boolean; IncludeEmbedded: boolean = FALSE): string;

type
  VEFAExtension = (vefaFN,vefaOBJ);
  VEFAExtMatch = record
    Signature : string;
    SigLen : integer;
    EndTag : char;
  end;
  VEFAExtArray = array[vefaFN..vefaOBJ] of VEFAExtMatch;

const
  FN_BEGIN_SIGNATURE = '{FN:';
  FN_BEGIN_TAG = '{';
  FN_END_TAG = '}';
  FN_BEGIN_SIGNATURE_LEN = length(FN_BEGIN_SIGNATURE);
  FN_END_TAGLEN = length(FN_END_TAG);
  FN_SHOW_TEXT = '{%_____%-#';
  FN_SHOW_TEXT_END = '}';
  FN_SHOW_TEXT_LEN = length(FN_SHOW_TEXT);
  FN_SHOW_TEXT_END_LEN = length(FN_SHOW_TEXT_END);
  FN_FIELD_TAG = '[FLD:';
  FN_FIELD_TAG_LEN = length(FN_FIELD_TAG);
  FN_OBJ_TAG = '[OBJ:';
  FN_OBJ_TAG_LEN = length(FN_OBJ_TAG);
  FN_VAR_SIGNATURE = '[FN:';
  FN_VAR_END_TAG = ']';
  FN_VAR_SIG_LEN = length(FN_VAR_SIGNATURE);
  FLD_OBJ_SIGNATURE = '{OBJ:';
  FLD_OBJ_END_TAG = '}';
  FLD_OBJ_SIG_LEN = length(FLD_OBJ_SIGNATURE);
  OBJ_SHOW_TEXT = '{OBJ%_____%-#';
  OBJ_SHOW_TEXT_END = '}';
  OBJ_SHOW_TEXT_LEN = length(OBJ_SHOW_TEXT);
  VEFA_MATCH : VEFAExtArray =
   (  (Signature : FN_BEGIN_SIGNATURE;
       SigLen    : FN_BEGIN_SIGNATURE_LEN;
       EndTag    : FN_END_TAG),

      (Signature : FLD_OBJ_SIGNATURE;
       SigLen    : FLD_OBJ_SIG_LEN;
       EndTag    : FLD_OBJ_END_TAG)
   );


var
  uInternalFormulaCount: integer = 0;
  uInternalTxtObjCount : integer = 0;
  uInternalVarObjCount : integer = 0;

  VEFANameToObjID : TStringList;
  VEFAFormulas    : TStringList;
  VEFATxtObjects  : TStringList;
  VEFAVars  : TStringList;


implementation

uses
  rCarePlans,
  ORNet,
  ORFn,
  TRPCB, 
  uTemplateFields,
  uEvaluateExpr;

const
  FieldIDDelim = '`';  //<-- also defined in uTemplateFields implementation
  FieldIDLen = 6;      //<-- also defined in uTemplateFields implementation

type
  TExposedTemplateDialogEntry = class(TTemplateDialogEntry)    //done to allow access to protected methods
  end;

function SubstuteIDs(Txt : string; NameToObjID : TStringList) : string; forward;


function RestoreTransformTxtObjects(SL : TStrings) : boolean;

//Returns if any changes made
//Replace formula text back in, and change field names into FldID's

  function GetTxtObjects(NumStr : string) : string;
  //Return TxtObject text based on provided index number of formula
  var num, i : integer;
      PtrNum : Pointer;
  begin
    Result := '';
    try
      Num := StrToInt(NumStr);
      PtrNum := Pointer(Num);
      for i := 0 to VEFATxtObjects.Count-1 do begin
        if VEFATxtObjects.Objects[i] = PtrNum then begin
          Result := VEFATxtObjects.Strings[i];
          break;
        end;
      end;
    except
      on EConvertError do Result := '??';
    end;
  end;

var p1,p2 : integer;
    ObjStr : string;
    SubStrA,SubStrB : string;
    Txt : string;
begin
  Txt := SL.Text;
  Result := false;
  p1 := Pos(OBJ_SHOW_TEXT,Txt);
  while (p1>0) do begin
    SubStrA := MidStr(Txt,1,p1-1);
    p1 := p1 + OBJ_SHOW_TEXT_LEN;
    p2 := PosEx(OBJ_SHOW_TEXT_END,Txt,p1);
    SubStrB := MidStr(Txt,p2+1,length(Txt)+1);
    ObjStr := MidStr(Txt,p1, (p2-p1));
    ObjStr := GetTxtObjects(ObjStr);
    ObjStr := SubstuteIDs(ObjStr,VEFANameToObjID);
    Txt := SubStrA + FLD_OBJ_SIGNATURE + ObjStr + FLD_OBJ_END_TAG + SubStrB;
    Result := true;
    p1 := PosEx(OBJ_SHOW_TEXT,Txt,p1);
  end;
  SL.Text := Txt;
end;


Procedure EvalTIUObjects(var Formula : string);

var p1,p2 : integer;
    OP1,OP2 : integer;
    Problem : string;
    SubStrA, SubStrB : string;
    TIUObj,Argument,s : string;
begin
  p1 := Pos(FN_OBJ_TAG, Formula);
  while (p1 > 0) do begin
    p2 := CloseCharPos('[',']',Formula, p1+1);
    if p2=0 then begin
      Formula := 'ERROR.  Matching "]" not found after ' + FN_OBJ_TAG + '.';
      Exit;
    end;
    SubStrA := MidStr(Formula,1,p1-1);
    p1 := p1+FN_OBJ_TAG_LEN;
    TIUObj := Trim(MidStr(Formula, p1, (p2-p1)));
    SubStrB := MidStr(Formula,p2+1,999);
    OP1 := Pos('{',TIUObj);
    if (OP1 > 0) then begin
      OP2 := CloseCharPos('{','}', TIUObj, OP1+1);
      if OP2=0 then begin
        Formula := 'ERROR.  Matching ")" not found after "(".';
        Exit;
      end;
      Argument := MidStr(TIUObj,OP1+1,(OP2-(OP1+1)));
      if Pos(FN_OBJ_TAG,Argument)>0 then begin
        EvalTIUObjects(Argument)
      end;
      Problem := '';
      s := EvalExpression(Argument,Problem);
      if Problem <> '' then begin
        Formula := 'ERROR evaluating argument: [' + Problem + '].';
        Exit;
      end else begin
        Argument := s;
      end;
      TIUObj := MidStr(TIUObj,1,OP1-1) + '{' + Argument + '}';
    end;
    TIUObj := GetRPCTIUObj(TIUObj);
    Formula := SubStrA + TIUObj + SubStrB;
    p1 := Pos(FN_OBJ_TAG, Formula);
  end;
end;

function SubstuteIDs(Txt : string; NameToObjID : TStringList) : string;

//Prefix any field names with their FldID's, in format of FieldIDDelim+FldID
// E.g. [FLD:1:NUM1-16] --> `00001NUM1-16`
//Note: Field ID's are started with character FieldIDDelim, and are of a fixed length (FieldIDLen)
//Syntax examples:
//
// {FN:[FLD:1:NUMB1-16]-[FLD:2:NUMB1-16]-[FLD:3:NUMB1-16]}, or
// {FN:[OBJ:TABLE1]-[FLD:2:NUMB1-16]-[FLD:3:NUMB1-16]}, or
// {FN:[OBJ:TABLE2("POTASSIUM")]-[FLD:2:NUMB1-16]-[FLD:3:NUMB1-16]}, or
// {FN:[OBJ:TABLE2([FLD:1:NUMB1-16])]-[FLD:2:NUMB1-16]-[FLD:3:NUMB1-16]}
// {FN:[OBJ:TABLE2((5+3)/2)]-[FLD:2:NUMB1-16]-[FLD:3:NUMB1-16]}
// (arbitrary deep nesting)
// Note: arguments should be found by matching [ ]'s
//       An argument will start with a TYPE (so far, FLD or OBJ) and ':'
//
//       If TYPE is FLD, there will be :number:, with number being same
//       as number in old format (i.e. ...]#2).
//       If number not provided, then default value is 1
//
//       If TYPE is OBJ, then this indicates that the parameter name (e.g. TABLE) is
//       the name of a TIU TEXT object, that will be processed on the server.
//       Parameters should be resolved before passing to the server.

  Function FldIDNumFn(FldName,FldIndexStr : string) : integer;
  var i,Index,MatchCt : integer;
  begin
    Result := -1;
    Index := StrToIntDef(FldIndexStr,-1);
    if Index = -1 then exit;
    MatchCt := 0;
    for i := 0 to NameToObjID.Count-1 do begin
      if NameToObjID.Strings[i] <> FldName then continue;
      Inc(MatchCt);
      if MatchCt = Index then begin
        Result := Integer(NameToObjID.Objects[i]);
        exit;
      end;
    end;
  end;

var p1,p2 : integer;
    SubStrA,SubStrB, NumStr : string;
    FldIDNum : integer;
    SubstStr,FldIDNumStr : string;
    FldName,FldInfo : string;
begin
  p1 := PosEx(FN_FIELD_TAG,Txt,1);
  while p1 > 0 do begin
    SubStrA := MidStr(Txt,1,p1-1);
    p1 := p1 + Length(FN_FIELD_TAG);
    p2 := PosEx(']',Txt,p1);   //NOTE: This assumes no '[' in field name.
    FldInfo := MidStr(Txt,p1,(p2-p1));
    SubStrB := MidStr(Txt, p2+1, 999);

    NumStr := piece(FldInfo,':',1);
    FldName := Trim(piece(FldInfo,':',2));  //kt 8/23/12

    FldIDNum := FldIDNumFn(FldName,NumStr);
    if FldIDNum > -1 then begin
      FldIDNumStr := IntToStr(FldIDNum);
      FldIDNumStr := StringOfChar('0', FieldIDLen-Length(FldIDNumStr)) + FldIDNumStr;
      SubstStr := FieldIDDelim + FldIDNumStr + FldName + FieldIDDelim;
    end else begin
      SubstStr := '???';
    end;

    Txt := SubStrA + SubstStr + SubStrB;

    p1 := PosEx(FN_FIELD_TAG,Txt,p1);
  end;
  Result := Txt;
end;


function GetStoredInfo(SL : TStringList; NumStr : string) : string;
//Return formula text based on provided index number of formula or var etc.
var num, i : integer;
    PtrNum : Pointer;
begin
  Result := '';
  try
    Num := StrToInt(NumStr);
    PtrNum := Pointer(Num);
    for i := 0 to SL.Count-1 do begin
      if SL.Objects[i] = PtrNum then begin
        Result := SL.Strings[i];
        break;
      end;
    end;
  except
    on EConvertError do Result := '??';
  end;
end;


function RestoreTransformFormulas(SL : TStrings) : boolean;
//Returns if any changes made
//Replace formula text back in, and change field names into FldID's

var p1,p2 : integer;
    FnStr : string;
    Txt : string;
    SubStrA,SubStrB : string;
begin
  Txt := SL.Text;
  Result := false;
  p1 := Pos(FN_SHOW_TEXT,Txt);
  while (p1>0) do begin
    SubStrA := MidStr(Txt,1,p1-1);
    p1 := p1 + FN_SHOW_TEXT_LEN;
    p2 := PosEx(FN_SHOW_TEXT_END,Txt,p1);
    SubStrB := MidStr(Txt,p2+1,length(Txt)+1);
    FnStr := MidStr(Txt,p1, (p2-p1));
    FnStr := GetStoredInfo(VEFAFormulas, FnStr);
    FnStr := SubstuteIDs(FnStr,VEFANameToObjID);
    Txt := SubStrA + FN_BEGIN_SIGNATURE + FnStr + FN_END_TAG + SubStrB;
    Result := true;
    p1 := PosEx(FN_SHOW_TEXT,Txt,p1);
  end;
  SL.Text := Txt;
end;

{
function RestoreTransformVar(SL : TStrings) : boolean;
//Returns if any changes made
//Replace var text (and it's formulas) back in, and change field names into FldID's
var p1,p2 : integer;
    VarFnStr : string;
    Txt : string;
    SubStrA,SubStrB : string;
begin
  Txt := SL.Text;
  Result := false;
  p1 := Pos(FN_VAR_SHOW_TEXT,Txt);
  while (p1>0) do begin
    SubStrA := MidStr(Txt,1,p1-1);
    p1 := p1 + FN_VAR_SHOW_TEXT_LEN;
    p2 := PosEx(FN_VAR_SHOW_TEXT_END,Txt,p1);
    SubStrB := MidStr(Txt,p2+1,length(Txt)+1);
    VarFnStr := MidStr(Txt,p1, (p2-p1));
    VarFnStr := GetStoredInfo(VEFAVars, VarFnStr);
    VarFnStr := SubstuteIDs(VarFnStr,VEFANameToObjID);
    Txt := SubStrA + FN_VAR_SIGNATURE + VarFnStr + FN_VAR_END_TAG + SubStrB;
    Result := true;
    p1 := PosEx(FN_VAR_SHOW_TEXT,Txt,p1);
  end;
  SL.Text := Txt;
end;
}


function CloseCharPos(OpenChar, CloseChar : char; var Txt : string; StartingPos : integer=1) : integer;

//Return the position of a closing character, ignoring all intervening nested open and close chars
//NOTE: It is expected that StartingPos is pointing to the first opening character.
var i : integer;
    CloseMatchesNeeded : integer;
begin
  Result := 0;
  CloseMatchesNeeded := 1;
  for i := StartingPos to Length(Txt) do begin
    if (Txt[i] = OpenChar) and (i <> StartingPos) then Inc(CloseMatchesNeeded);
    if Txt[i] = CloseChar then Dec(CloseMatchesNeeded);
    if CloseMatchesNeeded = 0 then begin
      Result := i;
      break;
    end;
  end;
end;


procedure HideFormulas(SL : TStrings; Formulas : TStringList);

//NOTE: formulas will not be allowed to use the '}' character
var p1,p2 : integer;
    FnStr : string;
    SubStrA,SubStrB : string;
    Txt : String;
begin
  Txt := SL.Text;
  Formulas.Clear;  uInternalFormulaCount := 0;  //kt changed
  p1 := Pos(FN_BEGIN_SIGNATURE,Txt);
  while (p1>0) do begin
    SubStrA := MidStr(Txt,1,p1-1);
    p1 := p1 + FN_BEGIN_SIGNATURE_LEN;
    //p2 := PosEx(FN_END_TAG,Txt,p1);
    p2 := CloseCharPos(FN_BEGIN_TAG, FN_END_TAG, Txt, p1);
    SubStrB := MidStr(Txt,p2+1,length(Txt)+1);
    FnStr := MidStr(Txt,p1, (p2-p1));
    FnStr := AnsiReplaceText(FnStr,#9,'');
    FnStr := AnsiReplaceText(FnStr,#10,'');
    FnStr := AnsiReplaceText(FnStr,#13,'');
    //FnStr := AnsiReplaceText(FnStr,' ','');
    inc(uInternalFormulaCount);
    Formulas.AddObject(FnStr,Pointer(uInternalFormulaCount));
    Txt := SubStrA + FN_SHOW_TEXT + IntToStr(uInternalFormulaCount) + FN_SHOW_TEXT_END + SubStrB;
    p1 := PosEx(FN_BEGIN_SIGNATURE,Txt,p1);
  end;
  SL.Text := Txt;
end;

procedure HideTxtObjects(SL : TStrings; TxtObjects : TStringList);

var p1,p2 : integer;
    FnStr : string;
    SubStrA,SubStrB : string;
    Txt : String;
begin
  Txt := SL.Text;
  TxtObjects.Clear;  uInternalTxtObjCount := 0;  //kt changed.
  p1 := Pos(FLD_OBJ_SIGNATURE,Txt);
  while (p1>0) do begin
    SubStrA := MidStr(Txt,1,p1-1);
    p1 := p1 + FN_OBJ_TAG_LEN;
    p2 := CloseCharPos(FN_BEGIN_TAG, FN_END_TAG, Txt, p1);
    SubStrB := MidStr(Txt,p2+1,length(Txt)+1);
    FnStr := MidStr(Txt,p1, (p2-p1));
    FnStr := AnsiReplaceText(FnStr,#9,'');
    FnStr := AnsiReplaceText(FnStr,#10,'');
    FnStr := AnsiReplaceText(FnStr,#13,'');
    inc(uInternalTxtObjCount);
    TxtObjects.AddObject(FnStr,Pointer(uInternalTxtObjCount));
    Txt := SubStrA + OBJ_SHOW_TEXT + IntToStr(uInternalTxtObjCount) + OBJ_SHOW_TEXT_END + SubStrB;
    p1 := PosEx(FLD_OBJ_SIGNATURE,Txt,p1);
  end;
  SL.Text := Txt;
end;

{
procedure HideVars(SL : TStrings; VarObjects : TStringList);

var p1,p2 : integer;
    VarStr : string;
    SubStrA,SubStrB : string;
    Txt : String;
begin
  Txt := SL.Text;
  p1 := Pos(FN_VAR_SIGNATURE,Txt);
  while (p1>0) do begin
    SubStrA := MidStr(Txt,1,p1-1);
    p1 := p1 + FN_VAR_SIG_LEN;
    p2 := CloseCharPos(FN_BEGIN_TAG, FN_END_TAG, Txt, p1);
    SubStrB := MidStr(Txt,p2+1,length(Txt)+1);
    VarStr := MidStr(Txt,p1, (p2-p1));
    VarStr := AnsiReplaceText(VarStr,#9,'');
    VarStr := AnsiReplaceText(VarStr,#10,'');
    VarStr := AnsiReplaceText(VarStr,#13,'');
    inc(uInternalVarObjCount);
    VarObjects.AddObject(VarStr,Pointer(uInternalVarObjCount));
    Txt := SubStrA + FN_VAR_SHOW_TEXT + IntToStr(uInternalVarObjCount) + FN_VAR_SHOW_TEXT_END + SubStrB;
    p1 := PosEx(FN_VAR_SIGNATURE,Txt,p1);
  end;
  SL.Text := Txt;
end;
}

function InsideMarkers(var S : string; MarkerCh : char; P : integer) : boolean;

//Function returns if position P is inside characters MarkerCh.
//e.g. S =  'xxx|xxxxx|xxxxx'  MarkerCh='|'
//     P = 2  ==> result is false
//     P = 5  ==> result is true
//     P = 12 ==> result is false

var p1     : integer;
    Inside : boolean;
begin
  Inside := false;
  p1 := Pos(MarkerCh,S);
  while (p1 > 0) do begin
    if (p1 >= P) then break;
    p1 := PosEx(MarkerCh,S,p1+1);
    if (p1 > 0) and (p1 > P) then Inside := not Inside;
  end;
  Result := Inside;
end;


function FormatFormula(test: string): string;
var
   test2: string;
   i: integer;
begin
   for i := 1 to length(test) do begin
      if test[i] in ['0'..'9','+','-','*','/','(',')','^'] then begin
         test2 := test2 + test[i];
      end;
   end;
   Result := test2;
end;


function ResolveTemplateFieldsMath(Text: string;
                                   Entries : TStringList;
                                   AutoWrap: boolean;
                                   IncludeEmbedded: boolean = FALSE): string;
var
  flen, CtrlID, i, j: integer;
  Entry: TExposedTemplateDialogEntry;
  iField, Temp, NewTxt, Fld: string;
  FoundEntry: boolean;
  TmplFld: TTemplateField;
  tempSL : TStringList;
  Problem : string;
  SubStrA, SubStrB : string;
  ExtMode : VEFAExtension;
  TempStr, FnObjStr,Argument : string;
  FnP1,FnP2,p1,p2 : integer;
  VarName, LookupVarName, FNFlags : string;

  //NOTE: allowed syntax
  //{FN:AStorageVariableName^Flags: ..... (rest of formula   }
  //The value of this can later be accessed via  '[FN:AStorageVariableName]  <-- note this is '[', not '{'
  //     NOTE also, this is "[FN:", not "[FLD:"

  //Flags: HV  (case sensitive)
  //  H -- hide output.  I.e. function just for doing math, not displaying anything in the note
  //            i.e. could be used for an intermediate step, assigning one variable calculation to another etc.
  //  V -- Verbose : show the expression that is sent for evaluation.

begin
  Temp := Text;
  VEFAVars.Clear;
  for ExtMode := vefaFN to vefaOBJ do begin
    repeat
      i := pos(VEFA_MATCH[ExtMode].Signature, Temp);
      if(i > 0) then begin
        FnP1 := i;
        FnP2 := CloseCharPos('{', VEFA_MATCH[ExtMode].EndTag, Temp, i);
        p1 := FnP1 + VEFA_MATCH[ExtMode].SigLen;
        FnObjStr := MidStr(Temp, p1, FnP2-p1);
        FNFlags := '';
        if Pos(':',FnObjStr)>0 then begin
          VarName := Trim(piece(FnObjStr,':',1));  //Var names may not contain '[' or '{'
          if (Pos('[',VarName)>0) or (Pos('{',VarName)>0) or (Pos('(',VarName)>0) or (Pos(' ',VarName)>0) then VarName := '';
          if VarName<>'' then begin
            FnObjStr := pieces(FnObjStr,':',2,NumPieces(FnObjStr,':'));
            FNFlags := UpperCase(piece(VarName,'^',2));
            VarName := piece(VarName,'^',1);
          end;
        end else VarName := '';
        p1 := Pos(FN_VAR_SIGNATURE,FnObjStr);
        while (p1 > 0) do begin
          SubStrA := MidStr(FnObjStr,1,p1-1);
          p1 := p1 + FN_VAR_SIG_LEN;
          p2 := PosEx(FN_VAR_END_TAG,FnObjStr,p1);
          LookupVarName := Trim(MidStr(FnObjStr,p1,(p2-p1)));
          SubStrB := MidStr(FnObjStr,p2+1,length(FnObjStr)+1);
          FnObjStr := SubStrA + VEFAVars.Values[LookupVarName] + SubStrB;
          p1 := Pos(FN_VAR_SIGNATURE,FnObjStr);
        end;
        p1 := Pos(FieldIDDelim,FnObjStr);
        while (p1 > 0) do begin
          SubStrA := MidStr(FnObjStr,1,p1-1);
          p2 := PosEx(FieldIDDelim,FnObjStr,p1+1);
          Argument := MidStr(FnObjStr,p1+1,(p2-p1)-1);
          SubStrB := MidStr(FnObjStr,p2+1,length(FnObjStr)+1);
          CtrlID := StrToIntDef(MidStr(Argument,1,FieldIDLen), 0);
          //Fld := MidStr(Argument,FieldIDLen,StrLen(PChar(Argument))+1);
          Fld := MidStr(Argument,FieldIDLen+1,Length(Argument)+1);  //kt  8/23/12
          if(CtrlID > 0) then begin
            FoundEntry := FALSE;
            for j := 0 to Entries.Count-1 do begin
              Entry := TExposedTemplateDialogEntry(Entries.Objects[j]);
              if(assigned(Entry)) then begin
                if IncludeEmbedded then
                  iField := Fld
                else
                  iField := '';
                NewTxt := Entry.GetControlText(CtrlID, FALSE, FoundEntry, AutoWrap, iField);
                TmplFld := GetTemplateField(Fld, FALSE);
                if (assigned(TmplFld)) and (TmplFld.DateType in DateComboTypes) then {if this is a TORDateBox}
                   NewTxt := Piece(NewTxt,':',1);          {we only want the first piece of NewTxt}
                Argument := Trim(NewTxt);
              end;
            end;
          end else Argument := '??';
          FnObjStr := SubStrA + Argument + SubStrB;
          p1 := Pos(FieldIDDelim,FnObjStr);
        end;
        if (ExtMode = vefaOBJ) then begin
          FnObjStr := FN_OBJ_TAG + FnObjStr + ']';
        end;
        //kt what was purpose? --> FnObjStr := FormatFormula(FnObjStr);
        if (Pos(FN_OBJ_TAG,FnObjStr)>0) then begin
          EvalTIUObjects(FnObjStr);
        end;
        if ExtMode = vefaFN then begin
          Problem := '';
          TempStr := FnObjStr;
          TempStr := EvalExpression(TempStr,Problem);
          if Problem <> '' then begin
            TempStr := '<ERROR evaluating "' + FnObjStr + '" : ' + Problem + '>'
          end;
          FnObjStr := TempStr;
          if VarName <> '' then VEFAVars.Values[VarName] := FnObjStr;
          if (Pos('H',FNFlags)>0) and (Problem='') then FnObjStr := '';  //hide output
        end;
        SubStrA := MidStr(Temp,1,FnP1-1);
        SubStrB := MidStr(Temp,FnP2+1,StrLen(PChar(Temp))+1);
        Temp := SubStrA + FnObjStr + SubStrB;
      end;
    until(i = 0);
  end;
  Result := Temp;
end;


initialization
  VEFANameToObjID := TStringList.Create ; 
  VEFAFormulas  := TStringList.Create ; 
  VEFATxtObjects  := TStringList.Create; 
  VEFAVars  := TStringList.Create;


finalization
  VEFANameToObjID.Free;
  VEFAFormulas.Free; 
  VEFATxtObjects.Free; 
  VEFAVars.Free;

end.

