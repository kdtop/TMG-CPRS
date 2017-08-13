object frmRPCResults: TfrmRPCResults
  Left = 203
  Top = 152
  Caption = 'Results of Server Call'
  ClientHeight = 437
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    562
    437)
  PixelsPerInch = 96
  TextHeight = 13
  object listRPCResults: TListBox
    Left = 8
    Top = 8
    Width = 546
    Height = 376
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
  end
  object Close: TButton
    Left = 457
    Top = 396
    Width = 97
    Height = 33
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 1
    OnClick = CloseClick
    ExplicitLeft = 472
    ExplicitTop = 405
  end
end
