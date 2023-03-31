object frmNetworkMessager: TfrmNetworkMessager
  Left = 0
  Top = 0
  Caption = 'Send message through messager'
  ClientHeight = 280
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 35
    Width = 22
    Height = 13
    Caption = 'User'
  end
  object Label2: TLabel
    Left = 8
    Top = 80
    Width = 42
    Height = 13
    Caption = 'Message'
  end
  object Memo1: TMemo
    Left = 68
    Top = 80
    Width = 345
    Height = 137
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 68
    Top = 32
    Width = 345
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'ComboBox1'
  end
  object Button1: TButton
    Left = 338
    Top = 247
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 2
    OnClick = Button1Click
  end
end
