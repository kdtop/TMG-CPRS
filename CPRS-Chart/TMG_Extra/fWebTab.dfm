inherited frmWebTab: TfrmWebTab
  Left = 266
  Top = 184
  Caption = 'Web Browser'
  ClientHeight = 341
  ClientWidth = 465
  Menu = mnuMain
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 473
  ExplicitHeight = 395
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 336
    Width = 465
    ExplicitTop = 336
    ExplicitWidth = 465
  end
  object pnlWBHolder: TPanel [1]
    Left = 0
    Top = 0
    Width = 465
    Height = 336
    Align = alClient
    Color = clSkyBlue
    TabOrder = 0
    object WebBrowser: TWebBrowser
      Left = 104
      Top = 72
      Width = 300
      Height = 150
      TabOrder = 0
      ControlData = {
        4C000000021F0000810F00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 192
    Top = 120
    Data = (
      (
        'Component = frmWebTab'
        'Status = stsDefault')
      (
        'Component = pnlWBHolder'
        'Status = stsDefault')
      (
        'Component = WebBrowser'
        'Status = stsDefault'))
  end
  object mnuMain: TMainMenu
    Left = 152
    Top = 104
    object Action1: TMenuItem
      Caption = 'Action'
      object mnuViewHTMLSource: TMenuItem
        Caption = 'View &HTML Source'
        OnClick = mnuViewHTMLSourceClick
      end
      object mnuToggleRecordHTML_DOMs: TMenuItem
        Caption = 'Record HTML &DOM'#39's'
        OnClick = mnuToggleRecordHTML_DOMsClick
      end
    end
  end
  object TimerRecordDOM: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerRecordDOMTimer
    Left = 64
    Top = 80
  end
end
