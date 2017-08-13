inherited frmLetterFormatting: TfrmLetterFormatting
  Left = 0
  Top = 0
  Caption = 'Insert Formatting Commands'
  ClientHeight = 329
  ClientWidth = 273
  Font.Name = 'Tahoma'
  OnShow = FormShow
  ExplicitWidth = 281
  ExplicitHeight = 363
  PixelsPerInch = 96
  TextHeight = 13
  object lbCommands: TListBox [0]
    Left = 8
    Top = 8
    Width = 257
    Height = 265
    ItemHeight = 13
    Items.Strings = (
      '|RIGHT-JUSTIFY|'
      '|DOUBLE-SPACE|'
      '|SINGLE-SPACE|'
      '|TOP|'
      '|NOBLANKLINE|'
      '|PAGEFEED(arg)|'
      '|PAGESTART(arg)|'
      '|SETPAGE(arg)|'
      '|BLANK(arg)|'
      '|INDENT(arg)|'
      '|SETTAB(arg#)|'
      '|CENTER(arg)|'
      '|TAB|'
      '|TAB arg|'
      '|WIDTH(arg)|'
      '|NOWRAP|'
      '|WRAP|'
      '|UNDERLINE(arg)|'
      '|_|'
      '')
    TabOrder = 0
    OnDblClick = lbCommandsDblClick
  end
  object btnOK: TBitBtn [1]
    Left = 96
    Top = 288
    Width = 75
    Height = 25
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn [2]
    Left = 190
    Top = 288
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lbCommands'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmLetterFormatting'
        'Status = stsDefault'))
  end
end
