unit CollapsablePanelU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StrUtils,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Math;

type
  TOpenState = (OpenPanel, ClosedPanel);
  TOpenMode = (OpensLeftRight, OpensUpDown);
  TCollapsablePanel = class(TPanel)
  private
    { Private declarations }
    FUnitBefore : TCollapsablePanel;
    FUnitAfter : TCollapsablePanel;
    FOpenState : TOpenState;
    FPanelOwnedHere : boolean;
    FOpenCaption : string;
    FClosedCaption : string;
    FOnStartOpenStateClick : TNotifyEvent;
    FOnEndOpenStateClick : TNotifyEvent;
    procedure SetUnitBefore(AUnit : TCollapsablePanel);
    procedure SetUnitAfter(AUnit : TCollapsablePanel);
    procedure HandleHeaderBtnClick(Sender: TObject);
    procedure SetOpenClosedState(AState : TOpenState);
    procedure PropagateResizing;
  public
    { Public declarations }
    Name : string;
    CommonLog : TStrings;
    OpenSize : Integer;
    DisplayPanelOriginalSize : TPoint;
    HeaderBtn : TBitBtn;
    DisplayPanel : TPanel;
    RefreshHandler : TNotifyEvent;
    OpenMode : TOpenMode;
    constructor Create(AName : string;
                       ParentPanel : TWinControl;
                       AUnitBefore: TCollapsablePanel;
                       AOpenMode : TOpenMode;
                       ADisplayPanel : TPanel = nil;
                       ACommonLog : TStrings = nil); overload;
    constructor Create(AName : string;
                       ParentPanel : TWinControl;
                       Location : TPoint;
                       AOpenMode : TOpenMode;
                       ADisplayPanel : TPanel = nil;
                       ACommonLog : TStrings = nil); overload;
    destructor Destroy(); override;
    procedure Initialize(InitState : TOpenState = OpenPanel);
    procedure HandleUnitBeforeResized(Sender: TCollapsablePanel; NewTop, NewLeft : integer);
    procedure ToggleOpenState;
    procedure SetClosedCaption(s : string);
    procedure SetOpenCaption(S : string);
    procedure Refresh;
    function CurrentRect : TRect;
    procedure LogEvent(S : string);
  published
    property UnitBefore : TCollapsablePanel read FUnitBefore write SetUnitBefore;
    property UnitAfter : TCollapsablePanel read FUnitAfter write SetUnitAfter;
    property OpenState : TOpenState read FOpenState write SetOpenClosedState;
    property OpenCaption : string read FOpenCaption write SetOpenCaption;
    property ClosedCaption : string read FClosedCaption write SetClosedCaption;
    property OwnsPanel : boolean read FPanelOwnedHere;
    property OnStartOpenStateClick : TNotifyEvent read FOnStartOpenStateClick write FOnStartOpenStateClick;
    property OnEndOpenStateClick : TNotifyEvent read FOnEndOpenStateClick write FOnEndOpenStateClick;
  end;

  procedure RedrawSuspend(AHandle: HWnd);
  procedure RedrawActivate(AHandle: HWnd);


implementation

const
  BUTTON_THICKNESS = 30;  //height, or width if vertical button

  procedure RedrawSuspend(AHandle: HWnd);
  begin
    SendMessage(AHandle, WM_SETREDRAW, 0, 0);
  end;

  procedure RedrawActivate(AHandle: HWnd);
  begin
    SendMessage(AHandle, WM_SETREDRAW, 1, 0);
    InvalidateRect(AHandle, nil, True);
  end;

  function TCollapsablePanel.CurrentRect : TRect;
  begin
    Result.Top := Self.Top;
    Result.Left := Self.Left;
    Result.Right := Self.Left + Self.Width;
    Result.Bottom := Self.Top + Self.Height;
  end;

  procedure TCollapsablePanel.Initialize(InitState : TOpenState = OpenPanel);
  begin
    SetOpenClosedState(ClosedPanel);
    SetOpenClosedState(InitState);
  end;

  constructor TCollapsablePanel.Create(AName : string;
                                       ParentPanel : TWinControl;
                                       Location : TPoint;
                                       AOpenMode : TOpenMode;
                                       ADisplayPanel : TPanel = nil;
                                       ACommonLog : TStrings = nil);
  begin
    Create(AName, ParentPanel, nil, AOpenMode, ADisplayPanel, ACommonLog);
    Self.Top := Location.Y;
    Self.Left := Location.X;
  end;

  constructor TCollapsablePanel.Create(AName : string;
                                       ParentPanel : TWinControl;
                                       AUnitBefore: TCollapsablePanel;
                                       AOpenMode : TOpenMode;
                                       ADisplayPanel : TPanel = nil;
                                       ACommonLog : TStrings = nil);
  begin
    inherited Create(ParentPanel);
    Self.Parent := ParentPanel;
    FUnitBefore := nil;
    FUnitAfter := nil;
    RefreshHandler := nil;
    FOnStartOpenStateClick := nil;
    FOnEndOpenStateClick := nil;
    OpenMode := AOpenMode;
    CommonLog := ACommonLog;
    Name := AName;

    Self.UnitBefore := AUnitBefore;  //This triggers setter, which sets .top, .left, .width, .height
    if not assigned(FUnitBefore) then begin
      Self.Top := 0;
      Self.Left := 0;
      if Assigned(ParentPanel) and (ParentPanel is TPanel) then begin
        Self.Width := ParentPanel.Width;
        Self.Height := ParentPanel.Height;
      end else begin
        Self.Width := 300;
        Self.Height := 300;
      end;
    end;

    HeaderBtn := TBitBtn.Create(Self);
    HeaderBtn.Parent := Self;
    HeaderBtn.Top := 0;
    HeaderBtn.Left := 0;
    HeaderBtn.Caption := '';
    HeaderBtn.OnClick := HandleHeaderBtnClick;

    FPanelOwnedHere := not Assigned(ADisplayPanel);
    if Assigned(ADisplayPanel) then begin
      DisplayPanel := ADisplayPanel;
    end else begin
      DisplayPanel := TPanel.Create(Self);
      DisplayPanel.Height := 400;
      DisplayPanel.Width := 300;
      DisplayPanel.Color := clSkyBlue;
      //DisplayPanel.Name := 'PanelCreatedIn'+Self.Name;
    end;
    DisplayPanelOriginalSize.X := DisplayPanel.Width;
    DisplayPanelOriginalSize.Y := DisplayPanel.Height;
    DisplayPanel.Parent := self;
    DisplayPanel.Visible := true;
    DisplayPanel.Align := alNone; //ensure at "original" size, not elarged to alClient.
    if DisplayPanel.Height < 30 then DisplayPanel.Height := 30;
    if DisplayPanel.Width < 30 then begin
      LogEvent('Provided display panel Width= '+IntToStr(DisplayPanel.Width)+', so widening to 30');
      DisplayPanel.Width := 30;
    end;

    if OpenMode = OpensUpDown then begin
      HeaderBtn.Width := Self.Width;
      HeaderBtn.Align := alTop;
      HeaderBtn.Height := BUTTON_THICKNESS;
      DisplayPanel.Top := HeaderBtn.Top + HeaderBtn.Height;
      DisplayPanel.Left := 0;
      DisplayPanel.Width := Self.Width;
      Self.Height := HeaderBtn.Height + DisplayPanel.Height;
      LogEvent('Provided display panel height= '+IntToStr(DisplayPanel.Height));
      OpenSize := DisplayPanel.Height + HeaderBtn.Height+ 18;
      OpenCaption := '<Click To Close>';
      ClosedCaption := '<Click To Open>';
    end else begin  //OpensLeftRight
      HeaderBtn.Width := BUTTON_THICKNESS;
      HeaderBtn.Align := alLeft;
      HeaderBtn.Height := Self.Height;
      DisplayPanel.Top := HeaderBtn.Top;
      DisplayPanel.Left := HeaderBtn.Left + HeaderBtn.Width;
      Self.Width := HeaderBtn.Width + DisplayPanel.Width;
      LogEvent('Provided display panel ('+DisplayPanel.Name+') width= '+IntToStr(DisplayPanel.Width));
      OpenSize := DisplayPanel.Width + HeaderBtn.Width + 18;
      OpenCaption := '>';
      ClosedCaption := 'V';
    end;
    LogEvent('OpenSize for ' + Self.Name + ' set to:  '+IntToStr(OpenSize));
    DisplayPanel.Align := alClient;  //now allow to resize to fill client.
  end;

  destructor TCollapsablePanel.Destroy();
  begin
    HeaderBtn.Free;
    if FPanelOwnedHere then begin
      DisplayPanel.Free;
    end else begin
      DisplayPanel.Width := DisplayPanelOriginalSize.X;
      DisplayPanel.Height := DisplayPanelOriginalSize.Y;
    end;
    //cut self out of pointer chain.
    if assigned(FUnitBefore) then begin
      if assigned(FUnitAfter) then begin
        FUnitBefore.UnitAfter := FUnitAfter;
        FUnitAfter.UnitBefore := FUnitBefore;
      end else begin
        FUnitBefore.UnitAfter := nil;
      end;
      FUnitBefore.UnitAfter := nil;
    end else if assigned(FUnitAfter) then begin
      FUnitAfter.UnitBefore := nil;
    end;
    inherited;
  end;

  procedure TCollapsablePanel.SetClosedCaption(s : string);
  begin
    if FClosedCaption = s then exit;
    FClosedCaption := s;
    if FOpenState = ClosedPanel then begin
      HeaderBtn.Caption := s;
    end;
  end;

  procedure TCollapsablePanel.SetOpenCaption(S : string);
  begin
    if FOpenCaption = s then exit;
    FOpenCaption := s;
    if FOpenState = OpenPanel then begin
      HeaderBtn.Caption := s;
    end;
  end;


  procedure TCollapsablePanel.SetUnitBefore(AUnit : TCollapsablePanel);
  begin
    FUnitBefore := AUnit;
    if not assigned(FUnitBefore) then exit;
    FUnitBefore.UnitAfter := self;
    if OpenMode = OpensUpDown then begin
      Self.Top := FUnitBefore.Top + FUnitBefore.Height;
      Self.Left := FUnitBefore.Left;
      Self.Width := FUnitBefore.Width;
    end else begin
      Self.Top := FUnitBefore.Top;
      Self.Left := FUnitBefore.Left + FUnitBefore.Width;
      Self.Height := FUnitBefore.Height;
    end;
  end;


  procedure TCollapsablePanel.SetUnitAfter(AUnit : TCollapsablePanel);
  begin
    FUnitAfter := AUnit;
  end;

  procedure TCollapsablePanel.ToggleOpenState;
  begin
    if FOpenState = OpenPanel then begin
      SetOpenClosedState(ClosedPanel);
    end else begin
      SetOpenClosedState(OpenPanel);
    end;
  end;

  procedure TCollapsablePanel.HandleHeaderBtnClick(Sender: TObject);
  begin
    ToggleOpenState;
  end;

  procedure TCollapsablePanel.HandleUnitBeforeResized(Sender : TCollapsablePanel; NewTop, NewLeft : integer);
  begin
    if OpenMode = OpensUpDown then begin
      Self.Top := NewTop;
    end else begin
      Self.Left := NewLeft;
    end;
    PropagateResizing
  end;

  procedure TCollapsablePanel.SetOpenClosedState(AState : TOpenState);
  begin
    if AState = FOpenState then exit;
    if assigned(FOnStartOpenStateClick) then FOnStartOpenStateClick(self);
    FOpenState := AState;
    LogEvent('Setting State to: ' + IfThen(AState = OpenPanel, 'OpenPanel', 'ClosedPanel'));
    if FOpenState = OpenPanel then begin
      LogEvent('  While setting status to OPEN, using OpenSize: ' + IntToStr(OpenSize));
      HeaderBtn.Caption := OpenCaption;
      if OpenMode = OpensUpDown then begin
        Self.Height := OpenSize;
      end else begin
        Self.Width := OpenSize;
        LogEvent('Setting width to: ' + IntToStr(OpenSize));
      end;
    end else begin  //Closed
      LogEvent('Closing panel: ' +Self.Name);
      HeaderBtn.Caption := ClosedCaption;
      if OpenMode = OpensUpDown then begin
        Self.Height := HeaderBtn.Height + 5;
        LogEvent('Setting Height to: ' + IntToStr(Self.Height));
      end else begin
        Self.Width := HeaderBtn.Width + 5;
        LogEvent('Setting width to: ' + IntToStr(Self.Width));
      end;
    end;
    PropagateResizing;
    if assigned(FOnEndOpenStateClick) then FOnEndOpenStateClick(self);
  end;

  procedure TCollapsablePanel.PropagateResizing;
  begin
    if assigned(FUnitAfter) then FUnitAfter.HandleUnitBeforeResized(Self, Self.Top + Self.Height, Self.Left + Self.Width);
  end;

  procedure TCollapsablePanel.Refresh;
  begin
    if assigned(RefreshHandler) then RefreshHandler(self);
    if assigned(FUnitAfter) then FUnitAfter.Refresh;
  end;

  procedure TCollapsablePanel.LogEvent(s : string);
  begin
    if Assigned(CommonLog) then begin
      CommonLog.Add(Self.Name +': ' + s);
    end;
  end;

end.
