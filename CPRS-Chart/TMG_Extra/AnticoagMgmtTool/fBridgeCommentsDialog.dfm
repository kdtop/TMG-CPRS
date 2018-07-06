object frmBridgeCommentDlg: TfrmBridgeCommentDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Bridging Comments'
  ClientHeight = 232
  ClientWidth = 297
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 197
    Width = 297
    Height = 35
    Align = alBottom
    TabOrder = 2
    object btnCancel: TButton
      Left = 215
      Top = 5
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 134
      Top = 5
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object pnlMemo: TPanel
    Left = 0
    Top = 25
    Width = 297
    Height = 172
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 1
    object memBridgeComments: TMemo
      Left = 2
      Top = 2
      Width = 293
      Height = 168
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 297
    Height = 25
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Padding.Left = 10
    TabOrder = 0
    object lblEnterComments: TLabel
      Left = 2
      Top = 8
      Width = 79
      Height = 13
      Caption = 'Enter Comments'
    end
  end
end
