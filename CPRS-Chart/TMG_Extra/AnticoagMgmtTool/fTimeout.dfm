object frmTimeout: TfrmTimeout
  Left = 418
  Top = 200
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'ACM Timeout'
  ClientHeight = 102
  ClientWidth = 247
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblCount: TStaticText
    Left = 8
    Top = 60
    Width = 30
    Height = 33
    Alignment = taRightJustify
    Caption = '10'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object Label1: TStaticText
    Left = 8
    Top = 8
    Width = 227
    Height = 17
    Caption = 'Vista ACM has been idle and will close!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Label2: TStaticText
    Left = 8
    Top = 32
    Width = 233
    Height = 17
    Caption = 'Press the button to continue working with ACM.'
    TabOrder = 2
  end
  object cmdContinue: TButton
    Left = 134
    Top = 64
    Width = 105
    Height = 25
    Cancel = True
    Caption = 'Don'#39't Close ACM'
    TabOrder = 0
    OnClick = cmdContinueClick
  end
  object timCountDown: TTimer
    Interval = 5000
    OnTimer = timCountDownTimer
    Left = 68
    Top = 60
  end
end
