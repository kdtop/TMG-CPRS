object frmGMV_ScreenRPT: TfrmGMV_ScreenRPT
  Left = 194
  Top = 364
  Width = 650
  Height = 519
  Anchors = [akTop, akRight]
  Caption = 'Screen reports'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    Left = -2
    Top = 455
    Width = 642
    Height = 3
    Anchors = [akLeft, akRight, akBottom]
  end
  object Font: TLabel
    Left = 16
    Top = 14
    Width = 21
    Height = 13
    Caption = 'Font'
  end
  object Label3: TLabel
    Left = 224
    Top = 14
    Width = 45
    Height = 13
    Caption = 'Font size:'
  end
  object Button1: TButton
    Left = 559
    Top = 463
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 473
    Top = 463
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Print'
    TabOrder = 1
  end
  object RichEdit1: TRichEdit
    Left = 8
    Top = 40
    Width = 624
    Height = 407
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderWidth = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Pitch = fpFixed
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
    WantTabs = True
  end
end
