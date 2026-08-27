object frmGMV_Qualifiers: TfrmGMV_Qualifiers
  Left = 395
  Top = 220
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 200
  ClientWidth = 201
  Color = clBtnFace
  Constraints.MinWidth = 127
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 201
    Height = 200
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 1
    TabOrder = 0
    object pnlBottom: TPanel
      Left = 3
      Top = 145
      Width = 195
      Height = 52
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      OnResize = pnlBottomResize
      DesignSize = (
        195
        52)
      object btnOK: TButton
        Left = 69
        Top = 28
        Width = 60
        Height = 20
        Anchors = [akTop, akRight]
        Caption = '&OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        Left = 131
        Top = 28
        Width = 60
        Height = 20
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
      object edtQuals: TEdit
        Left = 7
        Top = 0
        Width = 182
        Height = 21
        TabStop = False
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
        Text = 'edtQuals'
      end
    end
  end
end
