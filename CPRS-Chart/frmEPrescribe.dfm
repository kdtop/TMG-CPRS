object EPrescribeForm: TEPrescribeForm
  Left = 201
  Top = 107
  Width = 800
  Height = 600
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'E-Prescribing'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  DesignSize = (
    792
    566)
  PixelsPerInch = 96
  TextHeight = 13
  object btnClose: TButton
    Left = 703
    Top = 529
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 0
    OnClick = btnCloseClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 768
    Height = 514
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    object browser: TWebBrowser
      Left = 0
      Top = 0
      Width = 768
      Height = 514
      Align = alClient
      TabOrder = 0
      OnNewWindow2 = browserNewWindow2
      ControlData = {
        4C000000604F0000203500000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
