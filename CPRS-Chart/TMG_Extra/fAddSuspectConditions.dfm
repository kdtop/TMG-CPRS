object frmAddSuspectConditions: TfrmAddSuspectConditions
  Left = 0
  Top = 0
  Caption = 'Add Suspect Medical Conditions'
  ClientHeight = 330
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    400
    330)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 27
    Width = 50
    Height = 13
    Caption = 'ICD Code:'
  end
  object btnClose: TBitBtn
    Left = 304
    Top = 295
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 0
  end
  object ORListBox1: TORListBox
    Left = 16
    Top = 160
    Width = 363
    Height = 126
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    ItemTipColor = clWindow
    LongList = False
  end
  object btnAddThisCondition: TBitBtn
    Tag = 12
    Left = 266
    Top = 106
    Width = 113
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Add this condition'
    TabOrder = 2
    OnClick = btnAddThisConditionClick
  end
  object RadioGroup1: TRadioGroup
    Left = 16
    Top = 60
    Width = 201
    Height = 65
    Caption = 'Set this suspect medical condition for:'
    Items.Strings = (
      'This year'
      'Every year')
    TabOrder = 3
  end
  object edtCodeToAdd: TEdit
    Left = 72
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object chkAlreadyReviewed: TCheckBox
    Left = 16
    Top = 137
    Width = 363
    Height = 17
    Caption = 'Code has been doctor reviewed and ready for coding'
    TabOrder = 5
  end
end
