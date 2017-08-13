object AddOneFileEntry: TAddOneFileEntry
  Left = 217
  Top = 175
  Caption = 'AddOneFileEntry'
  ClientHeight = 331
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    467
    331)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 464
    Height = 274
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 0
    object AddFileEntryGrid: TSortStringGrid
      Left = 1
      Top = 1
      Width = 462
      Height = 272
      Align = alClient
      TabOrder = 0
    end
  end
  object btnCancel: TBitBtn
    Left = 293
    Top = 291
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnOk: TBitBtn
    Left = 374
    Top = 291
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Save'
    TabOrder = 2
    OnClick = btnOkClick
  end
end
