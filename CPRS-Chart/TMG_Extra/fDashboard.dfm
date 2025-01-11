inherited frmDashboard: TfrmDashboard
  Left = 0
  Top = 0
  Caption = 'Dashboard'
  ClientHeight = 540
  ClientWidth = 713
  Font.Name = 'Tahoma'
  OldCreateOrder = False
  OnHide = FormHide
  OnShow = FormShow
  ExplicitWidth = 721
  ExplicitHeight = 574
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 535
    Width = 713
    ExplicitTop = 535
    ExplicitWidth = 713
  end
  object wbDashboard: TWebBrowser [1]
    Left = 0
    Top = 0
    Width = 713
    Height = 535
    Align = alClient
    TabOrder = 0
    OnBeforeNavigate2 = wbDashboardBeforeNavigate2
    ExplicitHeight = 540
    ControlData = {
      4C000000B14900004B3700000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = wbDashboard'
        'Status = stsDefault')
      (
        'Component = frmDashboard'
        'Status = stsDefault'))
  end
  object timUpdateDashboard: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = timUpdateDashboardTimer
    Left = 112
    Top = 208
  end
end
