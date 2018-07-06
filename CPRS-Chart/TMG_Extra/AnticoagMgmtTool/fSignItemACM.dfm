object frmSignItemACM: TfrmSignItemACM
  Left = 320
  Top = 440
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Electronic Signature'
  ClientHeight = 147
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblESCode: TLabel
    Left = 8
    Top = 81
    Width = 74
    Height = 13
    Caption = 'Signature Code'
  end
  object lblText: TMemo
    Left = 8
    Top = 8
    Width = 389
    Height = 65
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')
    ReadOnly = True
    TabOrder = 0
  end
  object txtESCode: TEdit
    Left = 8
    Top = 95
    Width = 141
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object cmdOK: TButton
    Left = 250
    Top = 118
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton
    Left = 328
    Top = 118
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = cmdCancelClick
  end
  object ckbAddCosigner: TCheckBox
    Left = 8
    Top = 122
    Width = 137
    Height = 17
    Caption = 'Add Cosigner(s) to note'
    TabOrder = 2
  end
end
