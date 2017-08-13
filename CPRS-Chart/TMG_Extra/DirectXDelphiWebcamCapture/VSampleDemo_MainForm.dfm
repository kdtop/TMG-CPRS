object Form_Main: TForm_Main
  Left = 392
  Top = 223
  Width = 776
  Height = 600
  Caption = 'VSampleDemo 3.0   [www.grizzlymotion.com]'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 377
    Top = 0
    Width = 7
    Height = 544
    OnMoved = Splitter1Moved
  end
  object Panel_Left: TPanel
    Left = 0
    Top = 0
    Width = 377
    Height = 544
    Align = alLeft
    TabOrder = 0
    inline Frame_Video1: TFrame1
      Left = 1
      Top = 1
      Width = 375
      Height = 542
      Align = alClient
      TabOrder = 0
      inherited Panel_Top: TPanel
        Width = 375
        DesignSize = (
          375
          104)
      end
      inherited Panel_Bottom: TPanel
        Width = 375
        Height = 438
        DesignSize = (
          375
          438)
        inherited PaintBox_Video: TPaintBox
          Width = 367
          Height = 499
        end
      end
    end
  end
  object Panel_Right: TPanel
    Left = 384
    Top = 0
    Width = 376
    Height = 544
    Align = alClient
    TabOrder = 1
    inline Frame_Video2: TFrame1
      Left = 1
      Top = 1
      Width = 374
      Height = 542
      Align = alClient
      TabOrder = 0
      inherited Panel_Top: TPanel
        Width = 374
        DesignSize = (
          374
          104)
      end
      inherited Panel_Bottom: TPanel
        Width = 374
        Height = 438
        DesignSize = (
          374
          438)
        inherited PaintBox_Video: TPaintBox
          Width = 374
          Height = 499
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 368
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
      object Quit1: TMenuItem
        Caption = '&Quit'
        OnClick = Quit1Click
      end
    end
    object About1: TMenuItem
      Caption = '&About'
      OnClick = About1Click
    end
  end
end
