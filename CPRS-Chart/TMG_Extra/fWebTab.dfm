inherited frmWebTab: TfrmWebTab
  Left = 266
  Top = 184
  Caption = 'Web Browser'
  ClientHeight = 321
  ClientWidth = 465
  Menu = mnuMain
  Position = poScreenCenter
  ExplicitWidth = 481
  ExplicitHeight = 379
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 316
    Width = 465
    ExplicitTop = 336
    ExplicitWidth = 465
  end
  object pnlWBHolder: TPanel [1]
    Left = 0
    Top = 0
    Width = 465
    Height = 316
    Align = alClient
    Color = clSkyBlue
    TabOrder = 0
    ExplicitLeft = 112
    ExplicitTop = 64
    ExplicitWidth = 353
    ExplicitHeight = 252
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
    end
  end
end
