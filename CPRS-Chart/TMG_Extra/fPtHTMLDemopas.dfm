object frmPtHTMLDemo: TfrmPtHTMLDemo
  Left = 0
  Top = 0
  Caption = 'frmPtHTMLDemo'
  ClientHeight = 271
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object EditaPtButton: TButton
    Left = 160
    Top = 216
    Width = 145
    Height = 21
    BiDiMode = bdRightToLeftNoAlign
    Caption = '&Edit Patient Demographics'
    ParentBiDiMode = False
    TabOrder = 0
    WordWrap = True
  end
  object cmdNewPt: TButton
    Left = 24
    Top = 216
    Width = 121
    Height = 21
    Caption = 'Select New Patient'
    TabOrder = 1
  end
  object cmdPrint: TButton
    Left = 427
    Top = 216
    Width = 75
    Height = 21
    Caption = 'Print'
    TabOrder = 2
  end
  object cmdClose: TButton
    Left = 517
    Top = 216
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 3
  end
end
