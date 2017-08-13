unit Monkey_Bundle_JS_U;
//kt added entire unit  1/2016
(*
Downloaded from http://www.monkeyphysics.com/mootools/script/2/datepicker
on Jan 6, 2016 by Kevin Toppenberg, MD.
Stated license is Creative Commons Attribution-ShareAlike 3.0
http://creativecommons.org/licenses/by-sa/3.0/

Some modifications made below (parts removed), marked with "//kt"
Also changes made to formating.  Original was MINIFIED.
*)

interface

uses
  Classes, Controls, StdCtrls, SysUtils, StrUtils;

procedure AddMonkeyBundleScript(SL : TStringList);

implementation
uses
  Monkey_Bundle_a_JS_U, Monkey_Bundle_b_JS_U, Monkey_Bundle_c_JS_U;

  procedure AddMonkeyBundleScript(SL : TStringList);
  var i : integer;
  CONST TITLE_COMMENT = '//Javascript Bundle for MonkeyPhysics';
  begin
    if SL.IndexOf(TITLE_COMMENT) <> -1 then exit;  //don't add duplicate
    SL.Add(TITLE_COMMENT);
    //NOTE: I had to break this up into 3 parts to achieve compilation.
    AddMonkeyBundleScriptA(SL); AddMonkeyBundleScriptB(SL); AddMonkeyBundleScriptC(SL);
    //too slow! --> for i := 0 to SL.Count - 1 do SL.Strings[i] := Trim(SL.Strings[i]);  //Remove space to minify code (at least somewhat) for browser
  end;

end.

