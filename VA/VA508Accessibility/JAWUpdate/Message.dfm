object frmMessage: TfrmMessage
  Left = 0
  Top = 0
  Caption = 'JAWSUpdate v1.2'
  ClientHeight = 205
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Times New Roman'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 24
  object Label1: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 323
    Height = 148
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alClient
    Alignment = taCenter
    Caption = 'Label1'
    Layout = tlCenter
    WordWrap = True
    ExplicitWidth = 62
    ExplicitHeight = 24
  end
  object Panel1: TPanel
    Left = 0
    Top = 164
    Width = 339
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      339
      41)
    object Button1: TButton
      Left = 240
      Top = 3
      Width = 91
      Height = 31
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Done'
      Default = True
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
