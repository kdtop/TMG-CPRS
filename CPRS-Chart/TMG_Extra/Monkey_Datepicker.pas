unit Monkey_Datepicker;
//kt added entire unit  1/2016

{WRAPPER FOR MONKEYPHYSICS CODE...

Downloaded from http://www.monkeyphysics.com/mootools/script/2/datepicker
on Jan 6, 2016 by Kevin Toppenberg, MD.
Stated license is Creative Commons Attribution-ShareAlike 3.0
http://creativecommons.org/licenses/by-sa/3.0/

Formatting changes made to code below to include in Delphi, e.g. wrapping lines and converting ' to "
}

(*
 * datepicker.js - MooTools Datepicker class
 * @version 1.17
 *
 * by MonkeyPhysics.com
 *
 * Source/Documentation available at:
 * http://www.monkeyphysics.com/mootools/script/2/datepicker
 *
 * --
 *
 * Smoothly animating, very configurable and easy to install.
 * No Ajax, pure Javascript. 4 skins available out of the box.
 *
 * --
 *
 * Some Rights Reserved
 * http://creativecommons.org/licenses/by-sa/3.0/
 *
 *)



interface

uses
  Classes, Controls, StdCtrls, SysUtils, StrUtils;

procedure AddMonkeyDatePicker(Id : string; Script, Styles : TStringList);

implementation

uses
  Monkey_Bundle_JS_U, Monkey_Datepicker_JS, Monkey_Datepicker_CSS;

  procedure AddMonkeyDatePicker(Id : string; Script, Styles : TStringList);
  var OptionsVar : string;
  begin
    AddMonkeyDatepickerCSS(Styles);
    AddMonkeyBundleScript(Script);
    AddMonkeyDatepickerJS(Script);
    //NOTE: Options for display of date picker can be varied below.
    //  See options here: http://www.monkeyphysics.com/mootools/script/2/datepicker
    OptionsVar := Id + 'Options';
    Script.Add('  var '+OptionsVar+' = {                    ');
    Script.Add('    positionOffset: {                       ');
    Script.Add('      x: 0,                                 ');
    Script.Add('      y: 5 },                               ');
    Script.Add('    format: "m/d/Y",                        ');
    //Script.Add('    inputOutputFormat: "m/d/Y",           ');
    Script.Add('    startDay: 0                             ');
    Script.Add('  };                                        ');
    Script.Add('  var HandleOnLoad = function() {           ');
    Script.Add('    new DatePicker(".TMG1", '+OptionsVar+');');
    Script.Add('  };                                        ');
    Script.Add('  window.addEvent("load", HandleOnLoad);    ');
  end;

end.

