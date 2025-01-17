object frmTemplateSearch: TfrmTemplateSearch
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Search Templates'
  ClientHeight = 317
  ClientWidth = 540
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    540
    317)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 540
    Height = 25
    ActivePage = tsAll
    Align = alTop
    TabOrder = 0
    OnChange = PageControl1Change
    object tsTemplates: TTabSheet
      Caption = '&Templates'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
    end
    object tsReminders: TTabSheet
      Caption = '&Reminders'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
    end
    object tsTopics: TTabSheet
      Caption = 'To&pics'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
    end
    object tsAll: TTabSheet
      Caption = '&All'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
    end
  end
  object edtTemSearchTerms: TEdit
    Left = 4
    Top = 31
    Width = 348
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    BevelEdges = []
    TabOrder = 1
    OnChange = edtTemSearchTermsChange
  end
  object btnTemAccept: TBitBtn
    Left = 355
    Top = 31
    Width = 65
    Height = 24
    Anchors = [akTop, akRight]
    Caption = '&Use'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnTemAcceptClick
    Glyph.Data = {
      9E050000424D9E05000000000000360400002800000012000000120000000100
      08000000000068010000130B0000130B00000001000000010000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F6F6F6F6F6F6
      F6F6F6F6F6F6F6F6F6F6F6F60000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
      0000F6F6F6F6F60404F6F6F6F6F6F6F6F6F6F6F60000F6F6F6F604020204F6F6
      F6F6F6F6F6F6F6F60000F6F6F6040202020204F6F6F6F6F6F6F6F6F60000F6F6
      0402020202020204F6F6F6F6F6F6F6F60000F604020202FA0202020204F6F6F6
      F6F6F6F60000F6020202FAF6FA02020204F6F6F6F6F6F6F60000F6FA02FAF6F6
      F6FA02020204F6F6F6F6F6F60000F6F6FAF6F6F6F6F6FA02020204F6F6F6F6F6
      0000F6F6F6F6F6F6F6F6F6FA02020204F6F6F6F60000F6F6F6F6F6F6F6F6F6F6
      FA02020204F6F6F60000F6F6F6F6F6F6F6F6F6F6F6FA02020204F6F60000F6F6
      F6F6F6F6F6F6F6F6F6F6FA02020204F60000F6F6F6F6F6F6F6F6F6F6F6F6F6FA
      020204F60000F6F6F6F6F6F6F6F6F6F6F6F6F6F6FA0202F60000F6F6F6F6F6F6
      F6F6F6F6F6F6F6F6F6FAF6F60000F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
      0000}
  end
  object btnTemCancel: TBitBtn
    Left = 423
    Top = 31
    Width = 65
    Height = 24
    Anchors = [akTop, akRight]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      20000000000000040000130B0000130B00000000000000000000D8E9ECFFD8E9
      ECFFD8E9ECFFD8E9ECFFD8E9ECFF808080FF808080FF808080FF808080FF8080
      80FF808080FF808080FFD8E9ECFFD8E9ECFFD8E9ECFFD8E9ECFFD8E9ECFFD8E9
      ECFFD8E9ECFFD8E9ECFF000080FF000080FF000080FF000080FF000080FF0000
      80FF000080FF808080FF808080FF808080FFD8E9ECFFD8E9ECFFD8E9ECFFD8E9
      ECFF000080FF000080FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF000080FF000080FF808080FF808080FFD8E9ECFFD8E9ECFF0000
      80FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF000080FF808080FFD8E9ECFFD8E9ECFF0000
      80FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF000080FF808080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFF0000FFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF
      FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF000080FF808080FF000080FF0000
      FFFF0000FFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFF0000FFFF0000FFFFFFFF
      FFFFFFFFFFFF0000FFFF0000FFFF0000FFFF000080FFD8E9ECFFD8E9ECFF0000
      80FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF000080FFD8E9ECFFD8E9ECFFD8E9ECFF0000
      80FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF000080FFD8E9ECFFD8E9ECFFD8E9ECFFD8E9
      ECFF000080FF000080FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF000080FF000080FFD8E9ECFFD8E9ECFFD8E9ECFFD8E9ECFFD8E9
      ECFFD8E9ECFFD8E9ECFF000080FF000080FF000080FF000080FF000080FF0000
      80FF000080FFD8E9ECFFD8E9ECFFD8E9ECFFD8E9ECFFD8E9ECFF}
  end
  object lbTemMatches: TListBox
    Left = 4
    Top = 61
    Width = 532
    Height = 233
    Align = alCustom
    ItemHeight = 13
    TabOrder = 4
    OnClick = lbTemMatchesClick
    OnDblClick = lbTemMatchesDblClick
    OnEnter = lbTemMatchesEnter
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 298
    Width = 540
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 40
    Top = 64
  end
end
