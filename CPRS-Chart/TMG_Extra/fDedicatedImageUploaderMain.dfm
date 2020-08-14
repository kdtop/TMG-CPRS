object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'VistA Image Uploader'
  ClientHeight = 287
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    635
    287)
  PixelsPerInch = 96
  TextHeight = 13
  object memErrorLog: TMemo
    Left = 0
    Top = 0
    Width = 635
    Height = 248
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnClear: TButton
    Left = 552
    Top = 254
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Clear'
    TabOrder = 1
    OnClick = btnClearClick
  end
  object PolTimer: TTimer
    Interval = 3000
    OnTimer = PolTimerTimer
    Left = 16
    Top = 248
  end
end
