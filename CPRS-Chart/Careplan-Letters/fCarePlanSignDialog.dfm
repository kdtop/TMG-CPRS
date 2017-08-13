object frmCarePlanSignDialog: TfrmCarePlanSignDialog
  Left = 0
  Top = 0
  Caption = 'Care Plan Saved'
  ClientHeight = 107
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    360
    107)
  PixelsPerInch = 96
  TextHeight = 13
  object FormLabel: TLabel
    Left = 40
    Top = 16
    Width = 274
    Height = 32
    Caption = 'Information has been inserted into active  document.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object btnSigned: TBitBtn
    Left = 40
    Top = 69
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Sign Note Now'
    ModalResult = 6
    TabOrder = 0
    ExplicitTop = 122
  end
  object btnOK: TBitBtn
    Left = 224
    Top = 69
    Width = 91
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    ExplicitTop = 122
  end
end
