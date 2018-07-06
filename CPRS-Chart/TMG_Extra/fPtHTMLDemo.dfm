object frmPtHTMLDemo: TfrmPtHTMLDemo
  Left = 0
  Top = 0
  Caption = 'frmPtHTMLDemo'
  ClientHeight = 484
  ClientWidth = 691
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    691
    484)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 691
    Height = 423
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 429
    Width = 689
    Height = 67
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    object cmdPrint: TButton
      Left = 427
      Top = 20
      Width = 75
      Height = 21
      Caption = 'Print'
      TabOrder = 0
      OnClick = cmdPrintClick
    end
    object cmdNewPt: TButton
      Left = 24
      Top = 20
      Width = 121
      Height = 21
      Caption = 'Select New Patient'
      TabOrder = 1
      OnClick = cmdNewPtClick
    end
    object EditaPtButton: TButton
      Left = 160
      Top = 20
      Width = 145
      Height = 21
      BiDiMode = bdRightToLeftNoAlign
      Caption = '&Edit Patient Demographics'
      ParentBiDiMode = False
      TabOrder = 2
      WordWrap = True
      OnClick = EditaPtButtonClick
    end
    object cmdClose: TButton
      Left = 517
      Top = 20
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Close'
      Default = True
      TabOrder = 3
      OnClick = cmdCloseClick
    end
  end
  object dlgPrintReport: TPrintDialog
    Left = 329
    Top = 269
  end
end
