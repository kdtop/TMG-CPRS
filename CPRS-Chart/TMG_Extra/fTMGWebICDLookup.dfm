object frmWebICDLookup: TfrmWebICDLookup
  Left = 0
  Top = 0
  Caption = 'frmWebICDLookup'
  ClientHeight = 438
  ClientWidth = 685
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 685
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 384
    Width = 685
    Height = 54
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 4
      Height = 13
      Caption = #39#39
    end
  end
  object WebBrowser: TWebBrowser
    Left = 0
    Top = 41
    Width = 685
    Height = 343
    Align = alClient
    TabOrder = 2
    OnDownloadComplete = WebBrowserDownloadComplete
    ExplicitTop = 35
    ControlData = {
      4C000000CC460000732300000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
