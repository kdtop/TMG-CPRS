unit uInit;

interface

uses
  Forms, Windows, Messages, SysUtils, ExtCtrls, ORSystem;

type
  TACTimeoutTimerCondition = function: boolean of object;
  TACTimeoutTimerAction = procedure of object;

procedure InitTimeOut(AUserCondition: TACTimeoutTimerCondition;
                      AUserAction: TACTimeoutTimerAction);
procedure UpdateTimeOutInterval(NewTime: Cardinal);
function TimedOut: boolean;
procedure ShutDownTimeOut;

implementation

uses
  fTimeout;
  
type
  TACTimeoutTimer = class(TTimer)
  private
    FHooked: boolean;
    FUserCondition: TACTimeoutTimerCondition;
    FUserAction: TACTimeoutTimerAction;
    uTimeoutInterval: Cardinal;
    uTimeoutKeyHandle, uTimeoutMouseHandle: HHOOK;
  protected
    procedure ResetTimeout;
    procedure timTimeoutTimer(Sender: TObject);
  end;

var
  timTimeout: TACTimeoutTimer = nil;
  FTimedOut: boolean = FALSE;

function TimeoutKeyHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall; forward;
function TimeoutMouseHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall; forward;
  
{** Timeout Functions **}

function TimeoutKeyHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
{ this is called for every keyboard event that occurs while running CPRS }
begin
  if lParam shr 31 = 1 then timTimeout.ResetTimeout;                          // on KeyUp only
  Result := CallNextHookEx(timTimeout.uTimeoutKeyHandle, Code, wParam, lParam);
end;

function TimeoutMouseHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
{ this is called for every mouse event that occurs while running CPRS }
begin
  if (Code >= 0) and (wParam > WM_MOUSEFIRST) and (wParam <= WM_MOUSELAST)
    then timTimeout.ResetTimeout;                                             // all click events
  Result := CallNextHookEx(timTimeout.uTimeoutMouseHandle, Code, wParam, lParam);
end;

procedure InitTimeOut(AUserCondition: TACTimeoutTimerCondition;
                      AUserAction: TACTimeoutTimerAction);
begin
  if(not assigned(timTimeout)) then begin
    timTimeOut := TACTimeoutTimer.Create(Application);
    with timTimeOut do begin
      OnTimer := timTimeoutTimer;
      FUserCondition := AUserCondition;
      FUserAction := AUserAction;
      uTimeoutInterval    := 120000;  // initially 2 minutes, will get DTIME (TimeoutSeconds) after signon
      uTimeoutKeyHandle   := SetWindowsHookEx(WH_KEYBOARD, TimeoutKeyHook,   0, GetCurrentThreadID);
      uTimeoutMouseHandle := SetWindowsHookEx(WH_MOUSE,    TimeoutMouseHook, 0, GetCurrentThreadID);
      FHooked := TRUE;
      Interval := uTimeoutInterval;
      Enabled  := True;
    end;
  end;
end;

procedure UpdateTimeOutInterval(NewTime: Cardinal);
begin
  if(assigned(timTimeout)) then
  begin
    with timTimeout do
    begin
      uTimeoutInterval := NewTime;
      Interval := uTimeoutInterval;
      Enabled  := True;
    end;
  end;
end;

function TimedOut: boolean;
begin
  Result := FTimedOut;
end;

procedure ShutDownTimeOut;
begin
  if(assigned(timTimeout)) then
  begin
    with timTimeout do
    begin
      Enabled := False;
      if(FHooked) then
      begin
        UnhookWindowsHookEx(uTimeoutKeyHandle);
        UnhookWindowsHookEx(uTimeoutMouseHandle);
        FHooked := FALSE;
      end;
    end;
//    timTimeout.Free;
    timTimeout := nil;
  end;
end;

{ TACTimeoutTime }

procedure TACTimeoutTimer.ResetTimeout;
{ this restarts the timer whenever there is a keyboard or mouse event }
begin
  Enabled  := False;
  Interval := uTimeoutInterval;
  Enabled  := True;
end;

procedure TACTimeoutTimer.timTimeoutTimer(Sender: TObject);
{ when the timer expires, the application is closed after warning the user }
begin
  Enabled := False;
  if(assigned(FUserCondition)) then
    FTimedOut := FUserCondition or AllowTimeout
  else
    FTimedOut := AllowTimeout;
  if FTimedOut then
  begin
    if(assigned(FUserAction)) then FUserAction;
  end
  else
    Enabled := True;
end;

initialization

finalization
  ShutDownTimeOut;

end.
