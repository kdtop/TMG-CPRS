unit TMGInlineHTMLDatePicker;
//kt added entire unit

{
  This unit is a helper for the uHTMLDlgObjs unit.  Code was moved her to debulk that file.  
}

 (*
 NOTE: The original version of this file may be obtained freely from the VA.

 This file is Copyright 3/6/2015 Kevin S. Toppenberg, MD
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
  Classes, Controls, StdCtrls, SysUtils, StrUtils;


  //procedure AddTMGInlineHTMLDatepicker(TargetId : string; InitialDate : string; DateMode : integer; ScriptCode, Styles: TStringList);
  procedure AddTMGInlineHTMLDatepickerCode(TargetId : string; ScriptCode, Styles: TStringList);

implementation

  uses uHTMLDlgObjs;

  procedure AddTMGInlineHTMLDatepickerCSS(Styles: TStringList);
  begin
    //here I can put custom css code for inline date picker....
  end;


  //procedure AddTMGInlineHTMLDatepickerJS(TargetId : string; InitialDate : string; DateMode : integer; ScriptCode : TStringList);
  procedure AddTMGInlineHTMLDatepickerJS(TargetId : string; ScriptCode : TStringList);
  var CodeGuard : string;
  begin
    CodeGuard := '//--- TMG Inline Datepicker JS';
    if ScriptCode.Indexof(CodeGuard) = -1 then begin
      AddNumberHandlerCode(ScriptCode);  //used in code below.  It has it's own code-guard test
      ScriptCode.Add(CodeGuard);
      ScriptCode.Add('function GetDateElems(IDs) {');
      ScriptCode.Add('  IDs.e = {};');
      ScriptCode.Add('  IDs.e.M = document.getElementById(IDs.M);');
      ScriptCode.Add('  IDs.e.D = document.getElementById(IDs.D);');
      ScriptCode.Add('  IDs.e.Y = document.getElementById(IDs.Y);');
      ScriptCode.Add('  IDs.e.Label = document.getElementById(IDs.Label);');
      ScriptCode.Add('  IDs.e.ClrBtn = document.getElementById(IDs.ClrBtn);');
      ScriptCode.Add('  IDs.e.UpBtn = document.getElementById(IDs.UpBtn);');
      ScriptCode.Add('  IDs.e.DnBtn = document.getElementById(IDs.DnBtn);');
      ScriptCode.Add('  IDs.e.Parent = document.getElementById(IDs.Parent);');
      ScriptCode.Add('  IDs.e.Hr = document.getElementById(IDs.Hr);');
      ScriptCode.Add('  IDs.e.Min = document.getElementById(IDs.Min);');
      ScriptCode.Add('  IDs.e.AMPM = document.getElementById(IDs.AMPM);');
      ScriptCode.Add('  IDs.e.Colon = document.getElementById(IDs.Colon);');
      ScriptCode.Add('  IDs.e.At = document.getElementById(IDs.At);');
      ScriptCode.Add('  return IDs;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function GetIDs(AGroupId) {');
      ScriptCode.Add('  var Obj = {};');
      ScriptCode.Add('  var ParentId=AGroupId.split("-")[0];');
      ScriptCode.Add('  Obj.Parent = ParentId;');
      ScriptCode.Add('  Obj.M = ParentId+"-month";');
      ScriptCode.Add('  Obj.D = ParentId+"-day";');
      ScriptCode.Add('  Obj.Y = ParentId+"-yr";');
      ScriptCode.Add('  Obj.Label = ParentId+"-label";');
      ScriptCode.Add('  Obj.ClrBtn = ParentId+"-ClrBtn";');
      ScriptCode.Add('  Obj.UpBtn = ParentId+"-UpBtn";');
      ScriptCode.Add('  Obj.DnBtn = ParentId+"-DnBtn";');
      ScriptCode.Add('  Obj.Hr = ParentId+"-Hr";');
      ScriptCode.Add('  Obj.Min = ParentId+"-Min";');
      ScriptCode.Add('  Obj.AMPM = ParentId+"-AMPM";');
      ScriptCode.Add('  Obj.AMPM = ParentId+"-Colon";');
      ScriptCode.Add('  Obj.At = ParentId+"-At";');
      ScriptCode.Add('  return Obj;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function ValidObj(o) {');
      ScriptCode.Add('  return ((o !== undefined) && (o !== null));');
      ScriptCode.Add('');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function GetNumVal(e) {');
      ScriptCode.Add('  var result = 0;');
      ScriptCode.Add('  if (ValidObj(e)) {');
      ScriptCode.Add('    result = parseInt(e.value) || 0;');
      ScriptCode.Add('  }');
      ScriptCode.Add('  return result;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function DT2Obj(FMDT) {');
      ScriptCode.Add('  //FM date-time str to Obj');
      ScriptCode.Add('  var DateObj;');
      ScriptCode.Add('  DateObj.Y = ensureNum(FMDT.substring(0,2))+1700;');
      ScriptCode.Add('  DateObj.M = ensureNum(FMDT.substring(3,4));');
      ScriptCode.Add('  DateObj.D = ensureNum(FMDT.substring(5,6));');
      ScriptCode.Add('  DateObj.Hr24 = ensureNum(FMDT.substring(8,9));');
      ScriptCode.Add('  DateObj.Min = ensureNum(FMDT.substring(10,11));');
      ScriptCode.Add('  return DateObj;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function Obj2FMDT(DateObj) {');
      ScriptCode.Add('  var DTStr=ZeroPad(DateObj.Y-1700,3) +');
      ScriptCode.Add('    ZeroPad(DateObj.M,2) +');
      ScriptCode.Add('    ZeroPad(DateObj.D,2);');
      ScriptCode.Add('  var TimeStr = "";');
      ScriptCode.Add('  if ((DateObj.Hr24 > 0) || (DateObj.Min > 0)) {');
      ScriptCode.Add('    TimeStr = "." + ZeroPad(DateObj.Hr24, 2) + ZeroPad(DateObj.Min, 2); }');
      ScriptCode.Add('  return DTStr+TimeStr;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function Obj2Ext(DateObj,Format) {');
      ScriptCode.Add('  //NOTE: This code should match uHTMLDlgObjs.FormatFMDT()');
      ScriptCode.Add('  //input: Format = format string.  Each element must be { }s');
      ScriptCode.Add('  //{yy} = last 2 digits of year;   {yyyy} = 4 digit year');
      ScriptCode.Add('  //{m} = month number, no leading zero;  {mm} = month number as 2 digits');
      ScriptCode.Add('  //{mmm} = month as short name;  {mmmm} = month as full length name');
      ScriptCode.Add('  //{d} = day number, no leading zero; {dd} = day numer as 2 digits');
      ScriptCode.Add('  //{h} = hour number, no leading zero; {hh} = 12hr hour number as 2 digits;');
      ScriptCode.Add('  //{h24} = 24hr hour number, no leading zero; {h24} = 24hr hour number as 2 digits');
      ScriptCode.Add('  //{n} = minute number, no leading zero; {nn} minute number as 2 digits');
      ScriptCode.Add('  //{ampm} = "am" or "pm"  NOTE: 12 pm is noon');
      ScriptCode.Add('  //all other characters in Format string are left in place');
      ScriptCode.Add('  var Result = Format;');
      ScriptCode.Add('  var Yr=ensureStr(DateObj.Y), shortYr=Yr.substring(2,3);');
      ScriptCode.Add('  if (Format.indexOf("{yy}")>-1) Result = Result.replace(/{yy}/g, shortYr);');
      ScriptCode.Add('  if (Format.indexOf("{yyyy}")>-1) Result=Result.replace(/{yyyy}/g, ensureStr(DateObj.Y));');
      ScriptCode.Add('  if (Format.indexOf("{m}")>-1) Result=Result.replace(/{m}/g, ensureStr(DateObj.M));');
      ScriptCode.Add('  if (Format.indexOf("{mm}")>-1) Result=Result.replace(/{mm}/g, ZeroPad(DateObj.M,2));');
      ScriptCode.Add('  if (Format.indexOf("{mmm}")>-1) Result=Result.replace(/{mmm}/g, DateObj.MonthsArr[DateObj.M]);');
      ScriptCode.Add('  if (Format.indexOf("{mmmm}")>-1) Result=Result.replace(/{mmmm}/g, DateObj.ShortMonthsArr[DateObj.M]);');
      ScriptCode.Add('  if (Format.indexOf("{d}")>-1) Result=Result.replace(/{d}/g, ensureStr(DateObj.D));');
      ScriptCode.Add('  if (Format.indexOf("{dd}")>-1) Result=Result.replace(/{dd}/g, ZeroPad(DateObj.D,2));');
      ScriptCode.Add('  var Hr24 = DateObj.Hr24, Hr = Hr24;');
      ScriptCode.Add('  if (Hr>12) {Hr=Hr-12} else {Hr = Hr/1};');
      ScriptCode.Add('  var ampm = (Hr24<=12)?"am":"pm"');
      ScriptCode.Add('  if (Format.indexOf("{h}")>-1) Result=Result.replace(/{h}/g, ensureStr(Hr));');
      ScriptCode.Add('  if (Format.indexOf("{hh}")>-1) Result=Result.replace(/{hh}/g, ZeroPad(Hr,2));');
      ScriptCode.Add('  if (Format.indexOf("{h24}")>-1) Result=Result.replace(/{h24}/g, ensureStr(Hr24));');
      ScriptCode.Add('  if (Format.indexOf("{hh24}")>-1) Result=Result.replace(/{hh24}/g, ZeroPad(Hr24,2));');
      ScriptCode.Add('  if (Format.indexOf("{n}")>-1) Result=Result.replace(/{n}/g, ensureStr(DateObj.Min));');
      ScriptCode.Add('  if (Format.indexOf("{nn}")>-1) Result=Result.replace(/{nn}/g, ZeroPad(DateObj.Min,2));');
      ScriptCode.Add('  if (Format.indexOf("{ampm}")>-1) Result=Result.replace(/{ampm}/g, ampm);');
      ScriptCode.Add('  return Result;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function FMDT2Ext(FMDT,Format) {');
      ScriptCode.Add('  //FMDT to external string');
      ScriptCode.Add('  var DateObj = DT2Obj(FMDT);');
      ScriptCode.Add('  return Obj2Ext(DateObj,Format);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function GetDateObj(e) {');
      ScriptCode.Add('  var IDs = GetIDs(e.id);');
      ScriptCode.Add('  var DateObj = GetDateElems(IDs)');
      ScriptCode.Add('  DateObj.M = GetNumVal(DateObj.e.M);');
      ScriptCode.Add('  DateObj.D = GetNumVal(DateObj.e.D);');
      ScriptCode.Add('  DateObj.Y = GetNumVal(DateObj.e.Y);');
      ScriptCode.Add('  DateObj.Hr24 = 0;');
      ScriptCode.Add('  DateObj.Min = 0;');
      ScriptCode.Add('  if ((ElemVisible(DateObj.e.Hr)) && DaySelected(DateObj)) {');
      ScriptCode.Add('    var AMPMAdd = GetNumVal(DateObj.e.AMPM) * 12;');
      ScriptCode.Add('    var Hr = GetNumVal(DateObj.e.Hr);');
      ScriptCode.Add('    if (Hr == 0) AMPMAdd = 0;');
      ScriptCode.Add('    DateObj.Hr24 = ZeroPad(Hr+AMPMAdd,2);');
      ScriptCode.Add('    DateObj.Min = ZeroPad(DateObj.e.Min.value, 2);');
      ScriptCode.Add('  }');
      ScriptCode.Add('  DateObj.FMDT = Obj2FMDT(DateObj);');
      ScriptCode.Add('  DateObj.MonthsArr = MonthsArr();');
      ScriptCode.Add('  DateObj.ShortMonthsArr = ShortMonthsArr();');
      ScriptCode.Add('  return DateObj;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function GetFormatStr(DateObj) {');
      ScriptCode.Add('  var FormatS = getAttrib(DateObj.e.Parent, "dtformat");');
      ScriptCode.Add('  if (FormatS=="") {');
      ScriptCode.Add('    if (DateObj.M > 0) {');
      ScriptCode.Add('      FormatS = "{m}/"');
      ScriptCode.Add('      if (DateObj.D > 0) FormatS = FormatS + "{d}/"');
      ScriptCode.Add('    }');
      ScriptCode.Add('    FormatS = FormatS + "{yyyy}";');
      ScriptCode.Add('    if (DateObj.Hr24>0) {');
      ScriptCode.Add('      FormatS = FormatS + " @ {h}:{n} {ampm}";');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('  var FormatArr = FormatS.split("^");');
      ScriptCode.Add('  while (FormatArr.length < 4) { FormatArr.push(FormatArr[FormatArr.length-1]) };');
      ScriptCode.Add('  var Idx=0;');
      ScriptCode.Add('  if (DateObj.M > 0) {');
      ScriptCode.Add('    Idx = 1;');
      ScriptCode.Add('    if (DateObj.D > 0) {');
      ScriptCode.Add('      Idx = 2;');
      ScriptCode.Add('      if (DateObj.Hr24>0) {');
      ScriptCode.Add('        Idx = 3;');
      ScriptCode.Add('      }');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('  var Result = FormatArr[Idx];');
      ScriptCode.Add('  return Result;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function RefreshDate(e) {');
      ScriptCode.Add('  var DateObj = GetDateObj(e);');
      ScriptCode.Add('  DateObj.ExternalStr = Obj2Ext(DateObj, GetFormatStr(DateObj));');
      ScriptCode.Add('  DateObj.e.Parent.setAttribute("value",DateObj.ExternalStr);');
      ScriptCode.Add('  DateObj.e.Parent.setAttribute("fmdtvalue",DateObj.FMDT);');
      ScriptCode.Add('  DateObj.e.Label.innerHTML = "<B>Date: " + DateObj.ExternalStr + " </b>";');
      ScriptCode.Add('  fireOnChange(DateObj.e.Parent);');
      ScriptCode.Add('  return DateObj;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      (* older code, remove later  5/6/16
      ScriptCode.Add('  //--------------------------');
      ScriptCode.Add('  /*');
      ScriptCode.Add('  var IDs = GetIDs(e.id);');
      ScriptCode.Add('  var DateObj = GetDateElems(IDs)');
      ScriptCode.Add('  DateObj.M = GetNumVal(DateObj.e.M);');
      ScriptCode.Add('  DateObj.D = GetNumVal(DateObj.e.D);');
      ScriptCode.Add('  DateObj.Y = GetNumVal(DateObj.e.Y);');
      ScriptCode.Add('  DateObj.Hr = 0;');
      ScriptCode.Add('  DateObj.Min = 0;');
      ScriptCode.Add('  var DateStr = DateObj.M.toString() + "/" + DateObj.D.toString() + "/" + DateObj.Y.toString();');
      ScriptCode.Add('  var TimeStr = "";');
      ScriptCode.Add('  var InternalTimeStr = "";');
      ScriptCode.Add('  if ((ElemVisible(DateObj.e.Hr)) && DaySelected(DateObj)) {');
      ScriptCode.Add('    var Hr = GetNumVal(DateObj.e.Hr);');
      ScriptCode.Add('    if (Hr > 0) {');
      ScriptCode.Add('      var AMPMAdd = GetNumVal(DateObj.e.AMPM) * 12;;');
      ScriptCode.Add('      var Hr24 = Hr + AMPMAdd;');
      ScriptCode.Add('      var HrStr = ZeroPad(Hr,2);');
      ScriptCode.Add('      var Hr24Str = ZeroPad(Hr24,2);');
      ScriptCode.Add('      var MinStr = ZeroPad(DateObj.e.Min.value, 2);');
      ScriptCode.Add('      InternalTimeStr = "@"+Hr24Str+":"+MinStr;');
      ScriptCode.Add('      TimeStr = " @ " + HrStr + ":" + MinStr + " " + SelectText(DateObj.e.AMPM);');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('  DateObj.e.Parent.setAttribute("value",DateStr+InternalTimeStr);');
      ScriptCode.Add('  DateStr = "";');
      ScriptCode.Add('  if (DateObj.Y > 0) {');
      ScriptCode.Add('    if (DateObj.M > 0) {');
      ScriptCode.Add('      DateStr = DateObj.M.toString() + "/";');
      ScriptCode.Add('      if (DateObj.D > 0) {');
      ScriptCode.Add('        DateStr = DateStr + DateObj.D.toString() + "/";');
      ScriptCode.Add('      }');
      ScriptCode.Add('    }');
      ScriptCode.Add('    DateStr = DateStr + DateObj.Y.toString() + TimeStr;');
      ScriptCode.Add('  }');
      ScriptCode.Add('');
      ScriptCode.Add('  DateObj.e.Label.innerHTML = "<B>Date: " + DateStr + " </b>";');
      ScriptCode.Add('  fireOnChange(DateObj.e.Parent);');
      ScriptCode.Add('  return DateObj;');
      ScriptCode.Add('  */');
      ScriptCode.Add('}');
      *)
      (* original code, remove later.
      ScriptCode.Add('function RefreshDate(e) {');
      ScriptCode.Add('  //returns object with .M, .D, .Y properties (integers)');
      ScriptCode.Add('  var IDs = GetIDs(e.id);');
      ScriptCode.Add('  var DateObj = GetDateElems(IDs)');
      ScriptCode.Add('  DateObj.M = GetNumVal(DateObj.e.M);');
      ScriptCode.Add('  DateObj.D = GetNumVal(DateObj.e.D);');
      ScriptCode.Add('  DateObj.Y = GetNumVal(DateObj.e.Y);');
      ScriptCode.Add('  var DateStr = DateObj.M.toString() + "/" + DateObj.D.toString() + "/" + DateObj.Y.toString();');
      ScriptCode.Add('  var TimeStr = "";');
      ScriptCode.Add('  var InternalTimeStr = "";');
      ScriptCode.Add('  if ((ElemVisible(DateObj.e.Hr)) && DaySelected(DateObj)) {');
      ScriptCode.Add('    var Hr = GetNumVal(DateObj.e.Hr);');
      ScriptCode.Add('    if (Hr > 0) {');
      ScriptCode.Add('      var AMPMAdd = GetNumVal(DateObj.e.AMPM) * 12;;');
      ScriptCode.Add('      var Hr24 = Hr + AMPMAdd;');
      ScriptCode.Add('      var HrStr = ZeroPad(Hr,2);');
      ScriptCode.Add('      var Hr24Str = ZeroPad(Hr24,2);');
      ScriptCode.Add('      var MinStr = ZeroPad(DateObj.e.Min.value, 2);');
      ScriptCode.Add('      InternalTimeStr = "@"+Hr24Str+":"+MinStr;');
      ScriptCode.Add('      TimeStr = " @ " + HrStr + ":" + MinStr + " " + SelectText(DateObj.e.AMPM);');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('  DateObj.e.Parent.setAttribute("value",DateStr+InternalTimeStr);');
      ScriptCode.Add('  DateStr = "";');
      ScriptCode.Add('  if (DateObj.Y > 0) {');
      ScriptCode.Add('    if (DateObj.M > 0) {');
      ScriptCode.Add('      DateStr = DateObj.M.toString() + "/";');
      ScriptCode.Add('      if (DateObj.D > 0) {');
      ScriptCode.Add('        DateStr = DateStr + DateObj.D.toString() + "/";');
      ScriptCode.Add('      }');
      ScriptCode.Add('    }');
      ScriptCode.Add('    DateStr = DateStr + DateObj.Y.toString() + TimeStr;');
      ScriptCode.Add('  }');
      ScriptCode.Add('  DateObj.e.Label.innerHTML = "<B>Date: " + DateStr + " </b>";');
      ScriptCode.Add('  fireOnChange(DateObj.e.Parent);');  //kt
      ScriptCode.Add('  return DateObj;');
      ScriptCode.Add('}');
      *)
      ScriptCode.Add('');
      ScriptCode.Add('function IsLeapYear(year) {');
      ScriptCode.Add('  return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function PopulateDays(Month, IsLeapYr) {');
      ScriptCode.Add('  var LenOfMonth = [31,28,31,30,31,30,31,31,30,31,31,31];');
      ScriptCode.Add('  var Len = 0;');
      ScriptCode.Add('  if ((Month >= 1) && (Month <= 12)) {');
      ScriptCode.Add('    Len = LenOfMonth[Month-1];');
      ScriptCode.Add('    if ((Month == 2) && (IsLeapYr)) Len++;');
      ScriptCode.Add('  }');
      ScriptCode.Add('  var Options = [];');
      ScriptCode.Add('  for (var i=0; i <= Len; i++) {');
      ScriptCode.Add('    if (i==0) {Options.push("-day-"); } else {Options.push(i); }');
      ScriptCode.Add('  }');
      ScriptCode.Add('  return Options;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function SetElemVisibility(e, Visible) {');
      ScriptCode.Add('  if (ValidObj(e)) {');
      ScriptCode.Add('    if (Visible) {');
      ScriptCode.Add('      e.style.visibility = "visible";');
      ScriptCode.Add('    } else {');
      ScriptCode.Add('      e.style.visibility = "hidden";');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function ElemVisible(e) {');
      ScriptCode.Add('  result = false;');
      ScriptCode.Add('  if (ValidObj(e)) result = (e.style.visibility !== "hidden")');
      ScriptCode.Add('  return result;');
      ScriptCode.Add('}');
      ScriptCode.Add('function SetSelIndex(e, Value) {');
      ScriptCode.Add('  if (ValidObj(e)) e.selectedIndex = Value;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function SetTimeVisibility(DateObj, Visible) {');
      ScriptCode.Add('  SetElemVisibility(DateObj.e.At, Visible);');
      ScriptCode.Add('  if (Visible) {SetSelIndex(DateObj.e.Hr, 0); }');
      ScriptCode.Add('  SetElemVisibility(DateObj.e.Hr, Visible);');
      ScriptCode.Add('  if (Visible) {SetSelIndex(DateObj.e.AMPM, 0);}');
      ScriptCode.Add('  SetElemVisibility(DateObj.e.Colon, Visible);');
      ScriptCode.Add('  if (Visible) {SetSelIndex(DateObj.e.Min, 0); }');
      ScriptCode.Add('  SetElemVisibility(DateObj.e.Min, Visible);');
      ScriptCode.Add('  SetElemVisibility(DateObj.e.AMPM, Visible);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function ValidateTimeVisibility(DateObj) {');
      ScriptCode.Add('  var Mode = getNumAttrib(DateObj.e.Parent,"dtmode",0);');
      ScriptCode.Add('  if ((Mode == 1) || (Mode == 2)) {');
      ScriptCode.Add('    SetTimeVisibility(DateObj, DaySelected(DateObj));');
      ScriptCode.Add('  }');
      ScriptCode.Add('}');
      ScriptCode.Add('function SetDayVisibility(DateObj, Visible) {');
      ScriptCode.Add('  //SetElemVisibility(DateObj.e.D, Visible);');
      ScriptCode.Add('  if (Visible) {');
      ScriptCode.Add('    if (DateObj.e.D.disabled) {');
      ScriptCode.Add('      DateObj.e.D.removeAttribute("disabled");');
      ScriptCode.Add('      DateObj.e.D.selectedIndex = 0;');
      ScriptCode.Add('    }');
      ScriptCode.Add('');
      ScriptCode.Add('  } else {');
      ScriptCode.Add('    DateObj.e.D.disabled = true;');
      ScriptCode.Add('    DateObj.e.D.selectedIndex = -1;');
      ScriptCode.Add('  }');
      ScriptCode.Add('}');
      ScriptCode.Add('function ValidateDayVisibility(DateObj) {SetDayVisibility(DateObj, MonthSelected(DateObj));}');
      ScriptCode.Add('');
      ScriptCode.Add('function ValidateVisibility(DateObj) {');
      ScriptCode.Add('  ValidateTimeVisibility(DateObj);');
      ScriptCode.Add('  ValidateDayVisibility(DateObj);');
      ScriptCode.Add('}');
      ScriptCode.Add('');

      ScriptCode.Add('');
      ScriptCode.Add('function ZeroPad(n, digits) {');
      ScriptCode.Add('  var s = n.toString();');
      ScriptCode.Add('  s = ("00000" + s).slice(-digits);');
      ScriptCode.Add('  return s;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function SelectText(Select) {');
      ScriptCode.Add('  var result = "";');
      ScriptCode.Add('  if (ValidObj(Select)) {');
      ScriptCode.Add('    var Item = Select.options[Select.selectedIndex];');
      ScriptCode.Add('    if (ValidObj(Item)) {');
      ScriptCode.Add('      result = Item.text;');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('  return result;');
      ScriptCode.Add('}');
      ScriptCode.Add('function FillSelect(Select,OptionsArr)');
      ScriptCode.Add('{');
      ScriptCode.Add('  Select.innerHTML = "";');
      ScriptCode.Add('  var i;');
      ScriptCode.Add('  for(i=0; i < OptionsArr.length; i++) {');
      ScriptCode.Add('    var newOptionEl = document.createElement("option");');
      ScriptCode.Add('    newOptionEl.value = i;');
      ScriptCode.Add('    var OptionText = OptionsArr[i];');
      ScriptCode.Add('    newOptionEl.text = OptionText;');
      ScriptCode.Add('    Select.add(newOptionEl);');
      ScriptCode.Add('	}');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function DaySelected(DateObj) {');
      ScriptCode.Add('  return (GetNumVal(DateObj.e.D) > 0);');
      ScriptCode.Add('}');
      ScriptCode.Add('function MonthSelected(DateObj) {');
      ScriptCode.Add('  return (GetNumVal(DateObj.e.M) > 0);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('');
      ScriptCode.Add('function SetupDaySel(DateObj) {');
      ScriptCode.Add('  var Month = GetNumVal(DateObj.e.M);');
      ScriptCode.Add('  if ((Month > 0) && ValidObj(DateObj.e.D)) {');
      ScriptCode.Add('    var DaySel = DateObj.e.D;');
      ScriptCode.Add('    var Index = DaySel.selectedIndex;');
      ScriptCode.Add('    var Yr = GetNumVal(DateObj.e.Y);');
      ScriptCode.Add('    var DayOptions = PopulateDays(Month, IsLeapYear(Yr))');
      ScriptCode.Add('    FillSelect(DaySel, DayOptions)');
      ScriptCode.Add('    if (Index == -1) Index = 0;');
      ScriptCode.Add('    if (Index < DayOptions.length) DaySel.selectedIndex = Index;');
      ScriptCode.Add('    DaySel.removeAttribute("disabled");');
      ScriptCode.Add('  }');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function handleMonthChange(e) {');
      ScriptCode.Add('  var DateObj = RefreshDate(e);');
      ScriptCode.Add('  SetupDaySel(DateObj)');
      ScriptCode.Add('  ValidateVisibility(DateObj);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function handleDayChange(e) {');
      ScriptCode.Add('  var DateObj = RefreshDate(e);');
      ScriptCode.Add('  ValidateTimeVisibility(DateObj);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function handleYrChange(e) {');
      ScriptCode.Add('  var IDs = GetIDs(e.id);');
      ScriptCode.Add('  var DateObj = GetDateElems(IDs)');
      ScriptCode.Add('  SetupDaySel(DateObj)');
      ScriptCode.Add('  var DateObj = RefreshDate(e);');
      ScriptCode.Add('  ValidateVisibility(DateObj);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function handleHourChange(e) {');
      ScriptCode.Add('  var DateObj = RefreshDate(e);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function handleAMPMChange(e) {');
      ScriptCode.Add('  var DateObj = RefreshDate(e);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function handleMinChange(e) {');
      ScriptCode.Add('  var DateObj = RefreshDate(e);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('');
      ScriptCode.Add('function ResetDate(e) {');
      ScriptCode.Add('  var IDs = GetIDs(e.id);');
      ScriptCode.Add('  var DateObj = GetDateElems(IDs)');
      ScriptCode.Add('  var d = new Date();');
      ScriptCode.Add('  var YrStr = d.getFullYear();');
      ScriptCode.Add('  DateObj.e.Y.value = YrStr;');
      ScriptCode.Add('  if (ValidObj(DateObj.e.M)) DateObj.e.M.selectedIndex = 0;');
      ScriptCode.Add('  if (ValidObj(DateObj.e.D)) {');
      ScriptCode.Add('    DateObj.e.D.selectedIndex = 0;');
      ScriptCode.Add('    DateObj.e.D.innerHTML = "";');
      ScriptCode.Add('    DateObj.e.D.disabled = true;');
      ScriptCode.Add('  }');
      ScriptCode.Add('  if (ValidObj(DateObj.e.Hr)) DateObj.e.Hr.selectedIndex = -1;');
      ScriptCode.Add('  if (ValidObj(DateObj.e.AMPM)) DateObj.e.AMPM.selectedIndex = -1;');
      ScriptCode.Add('  if (ValidObj(DateObj.e.Min)) DateObj.e.Min.selectedIndex = -1;');
      ScriptCode.Add('  SetTimeVisibility(DateObj, false);');
      ScriptCode.Add('  RefreshDate(e);');
      ScriptCode.Add('}');
      ScriptCode.Add('function SetDateTime(Id, DTString) {');
      ScriptCode.Add(' //   Expected input format: mm/dd/yyyy or mm/dd/yyyy@24:59');
      ScriptCode.Add('  var IDs = GetIDs(Id);');
      ScriptCode.Add('  var DateObj = GetDateElems(IDs);');
      ScriptCode.Add('');
      ScriptCode.Add('  var DTArr = DTString.split("@");');
      ScriptCode.Add('  var TimeStr = "";');
      ScriptCode.Add('  if (DTArr.length >= 2) TimeStr = DTArr[1];');
      ScriptCode.Add('  var Hr = -1;');
      ScriptCode.Add('  var Min = 0;');
      ScriptCode.Add('  var AMPM = 0;  //0=AM, 1=PM');
      ScriptCode.Add('  if (TimeStr !== "") {');
      ScriptCode.Add('    var TimeArr = TimeStr.split(":");');
      ScriptCode.Add('    if (TimeArr.length == 2) {');
      ScriptCode.Add('      Hr = parseInt(TimeArr[0]);');
      ScriptCode.Add('      if (Hr >= 12) AMPM=1;');
      ScriptCode.Add('      if (Hr == 0) {Hr = 12;}');
      ScriptCode.Add('      if (Hr > 12) Hr = Hr - 12;');
      ScriptCode.Add('      Min = parseInt(TimeArr[1]);');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('  DTArr = DTArr[0].split("/");');
      ScriptCode.Add('  var Month = 0;');
      ScriptCode.Add('  var Day = 0;');
      ScriptCode.Add('  var Year = 0;');
      ScriptCode.Add('  if (DTArr.length == 3) {');
      ScriptCode.Add('    Month = parseInt(DTArr[0]);');
      ScriptCode.Add('    Day = parseInt(DTArr[1]);');
      ScriptCode.Add('    Year = parseInt(DTArr[2]);');
      ScriptCode.Add('    if (Year < 1000) Year = 0;  //require 4 digit year');
      ScriptCode.Add('  } else {');
      ScriptCode.Add('    DTString = ensureStr(DTArr[0]);');
      ScriptCode.Add('    Year = ensureNum(DTString.substring(0,3),0) + 1700;');
      ScriptCode.Add('    Month = ensureNum(DTString.substring(3,5),0);');
      ScriptCode.Add('    Day = ensureNum(DTString.substring(5,7),0);');
      ScriptCode.Add('  }');
      ScriptCode.Add('  ');
      ScriptCode.Add('  if (Year > 0) {');
      ScriptCode.Add('    DateObj.e.Y.value = Year.toString();');
      ScriptCode.Add('    if ((Month > 0) && (ValidObj(DateObj.e.M))) {');
      ScriptCode.Add('      DateObj.e.M.selectedIndex = Month;');
      ScriptCode.Add('      SetupDaySel(DateObj)');
      ScriptCode.Add('      if ((Day > 0) && (ValidObj(DateObj.e.D))) {');
      ScriptCode.Add('        DateObj.e.D.selectedIndex = Day;');
      ScriptCode.Add('        ValidateVisibility(DateObj);');
      ScriptCode.Add('        if ((Hr > -1) && (ValidObj(DateObj.e.Hr))) {');
      ScriptCode.Add('          DateObj.e.Hr.selectedIndex = Hr-1;');
      ScriptCode.Add('          DateObj.e.Min.selectedIndex = Min;');
      ScriptCode.Add('          DateObj.e.AMPM.selectedIndex = AMPM;');
      ScriptCode.Add('        }');
      ScriptCode.Add('      }');
      ScriptCode.Add('    }');
      ScriptCode.Add('  }');
      ScriptCode.Add('  RefreshDate(DateObj.e.Y);');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function EnsureDTElem(Parent, ID, Type) {');
      ScriptCode.Add('  var Elem = document.getElementById(ID);');
      ScriptCode.Add('  if (!isObj(Elem)) {');
      ScriptCode.Add('    Elem  = document.createElement(Type);');
      ScriptCode.Add('    Elem.id = ID;');
      ScriptCode.Add('    Parent.appendChild(Elem);');
      ScriptCode.Add('  }');
      ScriptCode.Add('  return Elem;');
      ScriptCode.Add('}');
      ScriptCode.Add('');
      ScriptCode.Add('function MonthsArr() {');
      ScriptCode.Add('  return ["-month-","January","February","March","April","May",');
      ScriptCode.Add('          "June","July","August","September","October",');
      ScriptCode.Add('          "November","December"];');
      ScriptCode.Add('}');
      ScriptCode.Add('function ShortMonthsArr() {');
      ScriptCode.Add('  return ["-month-","Jan","Feb","Mar","Apr","May",');
      ScriptCode.Add('          "June","July","Aug","Sept","Oct",');
      ScriptCode.Add('          "Nov","Dec"];');
      ScriptCode.Add('}');
      //ScriptCode.Add('function AddComboDateBlock(ParentID,Mode,InitialDate)');
      ScriptCode.Add('function AddComboDateBlock(ParentID)');
      ScriptCode.Add(' //MODES: 0 = Date  <-- handled elsewhere');
      ScriptCode.Add(' //       1 = Date & Time');
      ScriptCode.Add(' //       2 = Date & Req Time');
      ScriptCode.Add(' //       3 = Combo Style');
      ScriptCode.Add(' //       4 = Combo Yr Only');
      ScriptCode.Add(' //       5 = Combo Yr & Month');
      ScriptCode.Add(' //Expected date format: mm/dd/yyyy or mm/dd/yyyy@24:59');
      ScriptCode.Add(' //MODES:');
      ScriptCode.Add(' //       0 = Date  <-- handled elsewhere');
      ScriptCode.Add(' //       1 = Date & Time');
      ScriptCode.Add(' //       2 = Date & Req Time');
      ScriptCode.Add(' //       3 = Combo Style');
      ScriptCode.Add(' //       4 = Combo Yr Only');
      ScriptCode.Add(' //       5 = Combo Yr & Month');
      ScriptCode.Add('{');
      ScriptCode.Add('  var Months = MonthsArr();');
      ScriptCode.Add('  var Hours = []; for (var i=0; i <= 12; i++) {');
      ScriptCode.Add('    var s= ZeroPad(i, 2);');
      ScriptCode.Add('    Hours.push(s);');
      ScriptCode.Add('  }');
      ScriptCode.Add('  var Mins = []; for (var i=0; i <= 59; i++) {');
      ScriptCode.Add('    var s= ZeroPad(i, 2);');
      ScriptCode.Add('    Mins.push(s);');
      ScriptCode.Add('  }');
      ScriptCode.Add('  var AMPM = ["AM","PM"];');
      ScriptCode.Add('');
      ScriptCode.Add('  var IDs = GetIDs(ParentID);');
      ScriptCode.Add('  var Parent = document.getElementById(ParentID);');
      ScriptCode.Add('  if (!isObj(Parent)) {alert("Can''t find parent element with id="+ParentID); return;}');
      ScriptCode.Add('  var Mode = getNumAttrib(Parent,"dtmode",0);');
      ScriptCode.Add('');
      ScriptCode.Add('  var LabelSpan = EnsureDTElem(Parent, IDs.Label, "span");');
      ScriptCode.Add('');
      ScriptCode.Add('  if (Mode != 4) {');
      ScriptCode.Add('    var MonthSelect = EnsureDTElem(Parent, IDs.M, "select");');
      ScriptCode.Add('    MonthSelect.onchange=function(){handleMonthChange(MonthSelect);};');
      ScriptCode.Add('    FillSelect(MonthSelect,Months);');
      ScriptCode.Add('  }');
      ScriptCode.Add('');
      ScriptCode.Add('  if (Mode < 4) {');
      ScriptCode.Add('    var DaySelect = EnsureDTElem(Parent, IDs.D, "select");');
      ScriptCode.Add('    DaySelect.disabled = true;');
      ScriptCode.Add('    DaySelect.selectedIndex = -1;');
      ScriptCode.Add('    DaySelect.onchange=function(){handleDayChange(DaySelect);};');
      ScriptCode.Add('  }');
      ScriptCode.Add('');
      ScriptCode.Add('  var YrSelect = EnsureDTElem(Parent, IDs.Y, "input");');
      ScriptCode.Add('  YrSelect.size="5"');
      ScriptCode.Add('  YrSelect.setAttribute("tmgtype","number");');
      ScriptCode.Add('  YrSelect.value="2016"');
      ScriptCode.Add('  YrSelect.id = IDs.Y;');
      ScriptCode.Add('  YrSelect.step = "1";');
      ScriptCode.Add('  YrSelect.onchange=function(){handleYrChange(YrSelect);};');
      ScriptCode.Add('  YrSelect.onkeyup=function(){handleNumKeyup(YrSelect);};');
      ScriptCode.Add('  YrSelect.onkeydown=function(){checkKey(YrSelect);};');
      ScriptCode.Add('');
      ScriptCode.Add('  var UpBtn = EnsureDTElem(Parent, IDs.UpBtn, "button");');
      ScriptCode.Add('  UpBtn.id = IDs.UpBtn;');
      ScriptCode.Add('  UpBtn.innerHTML = "&uarr;";');
      ScriptCode.Add('  UpBtn.onclick=function(){');
      ScriptCode.Add('    altNumValue(IDs.Y, "+");');
      ScriptCode.Add('    handleYrChange(YrSelect);');
      ScriptCode.Add('  };');
      ScriptCode.Add('');
      ScriptCode.Add('  var DnBtn = EnsureDTElem(Parent, IDs.DnBtn, "button");');
      ScriptCode.Add('  DnBtn.id = IDs.DnBtn;');
      ScriptCode.Add('  DnBtn.innerHTML = "&darr;";');
      ScriptCode.Add('  DnBtn.onclick=function(){');
      ScriptCode.Add('    altNumValue(IDs.Y, "-");');
      ScriptCode.Add('    handleYrChange(YrSelect);');
      ScriptCode.Add('  };');
      ScriptCode.Add('');
      ScriptCode.Add('  if ((Mode == 1) || (Mode == 2)) {');
      ScriptCode.Add('    var SpanAt = EnsureDTElem(Parent, IDs.At, "span");');
      ScriptCode.Add('');
      ScriptCode.Add('    var HrSelect = EnsureDTElem(Parent, IDs.Hr, "select");');
      ScriptCode.Add('    HrSelect.onchange=function(){handleHourChange(HrSelect);};');
      ScriptCode.Add('    FillSelect(HrSelect,Hours);');
      ScriptCode.Add('');
      ScriptCode.Add('    var SpanColon = EnsureDTElem(Parent, IDs.Colon, "span");');
      ScriptCode.Add('    SpanColon.innerHTML = ":"');
      ScriptCode.Add('');
      ScriptCode.Add('    var MinSelect = EnsureDTElem(Parent, IDs.Min, "select");');
      ScriptCode.Add('    MinSelect.onchange=function(){handleMinChange(MinSelect);};');
      ScriptCode.Add('    FillSelect(MinSelect,Mins);');
      ScriptCode.Add('');
      ScriptCode.Add('    var AMPMSelect = EnsureDTElem(Parent, IDs.AMPM, "select");');
      ScriptCode.Add('    AMPMSelect.onchange=function(){handleAMPMChange(HrSelect);};');
      ScriptCode.Add('    FillSelect(AMPMSelect,AMPM);');
      ScriptCode.Add('');
      ScriptCode.Add('    var DateObj = GetDateElems(IDs);');
      ScriptCode.Add('    SetTimeVisibility(DateObj, false)');
      ScriptCode.Add('  }');
      ScriptCode.Add('');
      ScriptCode.Add('  var ClearBtn  = EnsureDTElem(Parent, IDs.ClrBtn, "button");');
      ScriptCode.Add('  ClearBtn.innerHTML = "Clear";');
      ScriptCode.Add('  ClearBtn.onclick=function(){ResetDate(ClearBtn);};');
      ScriptCode.Add('');
      ScriptCode.Add('  var InitialDate = getAttrib(Parent,"fmdtvalue");');
      ScriptCode.Add('  if (InitialDate !=="") {');
      ScriptCode.Add('    SetDateTime(ParentID, InitialDate);');
      ScriptCode.Add('  } else {');
      ScriptCode.Add('    RefreshDate(YrSelect);');
      ScriptCode.Add('  }');
      ScriptCode.Add('}');
      ScriptCode.Add('');
    end;
    //NOTE: this is a direct javascript command that is executed as soon as page is loaded by browser.
    //     It is in this function that the date controls are added into the DOM (HTML document)
    //ktScriptCode.Add('AddComboDateBlock("'+TargetId+'",'+IntToStr(DateMode)+', "' + InitialDate + '");');  //inserts inline date into named element
    ScriptCode.Add('AddComboDateBlock("'+TargetId+'");');  //inserts inline date into named element
  end;

  //procedure AddTMGInlineHTMLDatepicker(TargetId : string; InitialDate : string; DateMode : integer; ScriptCode, Styles: TStringList);
  procedure AddTMGInlineHTMLDatepickerCode(TargetId : string; ScriptCode, Styles: TStringList);
  begin
    AddTMGInlineHTMLDatepickerCSS(Styles);
    //AddTMGInlineHTMLDatepickerJS(TargetId, InitialDate, DateMode, ScriptCode);
    AddTMGInlineHTMLDatepickerJS(TargetId, ScriptCode);
  end;


end.

