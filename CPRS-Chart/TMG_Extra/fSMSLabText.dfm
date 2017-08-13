object frmSMSLabText: TfrmSMSLabText
  Left = 0
  Top = 0
  Caption = 'Send SMS Message For Lab'
  ClientHeight = 181
  ClientWidth = 574
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
    Left = 16
    Top = 16
    Width = 229
    Height = 13
    Caption = 'Sending a text message to the following:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 32
    Top = 35
    Width = 69
    Height = 13
    Caption = 'Phone number'
  end
  object Label3: TLabel
    Left = 32
    Top = 88
    Width = 42
    Height = 13
    Caption = 'Message'
  end
  object editPhone: TEdit
    Left = 48
    Top = 54
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object editMessage: TEdit
    Left = 48
    Top = 107
    Width = 513
    Height = 30
    TabOrder = 1
  end
  object btnSend: TBitBtn
    Left = 368
    Top = 143
    Width = 75
    Height = 25
    Caption = '&Send'
    TabOrder = 2
    OnClick = btnSendClick
  end
  object btnCancel: TBitBtn
    Left = 486
    Top = 143
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
