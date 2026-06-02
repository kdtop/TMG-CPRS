object frmConsultantOffices: TfrmConsultantOffices
  Left = 0
  Top = 0
  Caption = 'Consultant Offices'
  ClientHeight = 395
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    405
    395)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 405
    Height = 340
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TreeView: TORTreeView
      Left = 1
      Top = 1
      Width = 403
      Height = 338
      Align = alClient
      Indent = 19
      TabOrder = 0
      OnChange = TreeViewChange
      OnChanging = TreeViewChanging
      OnDblClick = TreeViewDblClick
      Caption = 'TreeView'
      NodePiece = 0
    end
  end
  object btnUse: TButton
    Left = 214
    Top = 357
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Use'
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 317
    Top = 357
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = Button2Click
  end
end
