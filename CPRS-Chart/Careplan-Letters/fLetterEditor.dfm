inherited frmLetterEditor: TfrmLetterEditor
  Left = 0
  Top = 0
  Caption = 'frmLetterEditor'
  ClientHeight = 554
  ClientWidth = 704
  Font.Name = 'Tahoma'
  Menu = MainMenu1
  ExplicitWidth = 712
  ExplicitHeight = 608
  DesignSize = (
    704
    554)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 24
    Top = 16
    Width = 148
    Height = 16
    Caption = 'Letter Template Name:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object editLetterName: TEdit [1]
    Left = 178
    Top = 8
    Width = 487
    Height = 21
    TabOrder = 0
    OnChange = editLetterNameChange
  end
  object memoLetterText: TMemo [2]
    Left = 8
    Top = 38
    Width = 688
    Height = 465
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'memoLetterText')
    TabOrder = 1
  end
  object btnCancel: TBitBtn [3]
    Left = 608
    Top = 521
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnSave: TBitBtn [4]
    Left = 504
    Top = 521
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Save'
    ModalResult = 1
    TabOrder = 3
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = editLetterName'
        'Status = stsDefault')
      (
        'Component = memoLetterText'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnSave'
        'Status = stsDefault')
      (
        'Component = frmLetterEditor'
        'Status = stsDefault'))
  end
  object MainMenu1: TMainMenu
    Left = 304
    Top = 384
    object Insert1: TMenuItem
      Caption = '&Insert'
      object Field1: TMenuItem
        Caption = '&Field'
      end
      object Formatting1: TMenuItem
        Caption = 'For&matting'
        OnClick = Formatting1Click
      end
    end
    object Exit1: TMenuItem
      Caption = 'E&xit'
      OnClick = Exit1Click
    end
  end
end
