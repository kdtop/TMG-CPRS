object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 116
  ClientWidth = 195
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 140
    Height = 15
    Caption = 'test.  this is a modal dialog'
  end
  object Button1: TButton
    Left = 56
    Top = 56
    Width = 75
    Height = 25
    Caption = 'close'
    ModalResult = 1
    TabOrder = 0
  end
end
