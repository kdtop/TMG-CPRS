unit uSavedSignature;
//kt added entire unit.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils,
  ORNet, ORFn, ComCtrls, Grids, ORCtrls, ExtCtrls, Buttons,
  uTMGTypes, SortStringGrid;

type
  tSaveUnits = (min, sec, msec);

const
  DEFAULT_SAVE_DURATION = 2;  //2 minutes

type
  TSavedSignature = class (TObject)
  private
    FValue : string;
    FTimer : TTimer;
    FRememberedDT : TDateTime;  //implement later perhaps....
    procedure HandleOnTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy;
    procedure Clear;
    procedure Remember(Value : string;
                       Duration : integer = DEFAULT_SAVE_DURATION;
                       Units : tSaveUnits = min);
    property Value : string read FValue;
  end;

var
  SavedSignature : TSavedSignature;

implementation

  constructor TSavedSignature.Create;
  begin
    Inherited Create;
    FTimer := TTimer.Create(nil);
    FTimer.Enabled := false;
    FTimer.OnTimer := HandleOnTimer;
  end;

  destructor TSavedSignature.Destroy;
  begin
    FTimer.Free;
    Inherited Destroy;
  end;

  procedure TSavedSignature.Clear;
  begin
    FTimer.Enabled := false;
    FValue := '';
  end;

  procedure TSavedSignature.Remember(Value : string; Duration : integer; Units : tSaveUnits);
  var Interval : integer;
  begin
    Clear;
    case Units of
      min: Interval := Duration * 60 * 1000;
      sec: Interval := Duration * 1000;
      msec: Interval := Duration;
    end;
    FValue := Value;
    FTimer.Interval := Interval;
    FTimer.Enabled := True;
  end;

  procedure TSavedSignature.HandleOnTimer(Sender: TObject);
  begin
    Clear;
  end;

initialization
  SavedSignature := TSavedSignature.Create;

finalization
  SavedSignature.Free;

end.

