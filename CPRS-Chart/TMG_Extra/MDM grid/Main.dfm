object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 469
  ClientWidth = 918
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    918
    469)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 583
    Top = 53
    Width = 327
    Height = 408
    Anchors = [akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnLaunchEmbedded: TButton
    Left = 8
    Top = 8
    Width = 121
    Height = 25
    Caption = 'Launch MDM Embedded'
    TabOrder = 1
    OnClick = btnLaunchEmbeddedClick
  end
  object btnClear: TButton
    Left = 826
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 2
    OnClick = btnClearClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 48
    Width = 551
    Height = 413
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clGradientInactiveCaption
    TabOrder = 3
  end
  object btnLaunchFloating: TButton
    Left = 152
    Top = 8
    Width = 153
    Height = 25
    Caption = 'Launch MDM Floating'
    TabOrder = 4
    OnClick = btnLaunchFloatingClick
  end
end
