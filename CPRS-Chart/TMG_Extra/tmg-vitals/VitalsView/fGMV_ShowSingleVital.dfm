object frmGMV_ShowSingleVital: TfrmGMV_ShowSingleVital
  Left = 460
  Top = 226
  BorderStyle = bsNone
  Caption = 'frmGMV_ShowSingleVital'
  ClientHeight = 208
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  PixelsPerInch = 120
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 213
    Height = 208
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 1
    TabOrder = 0
    object lblInstructionsToClose: TLabel
      Left = 3
      Top = 166
      Width = 207
      Height = 39
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = 'Press any key or click on this window to close.'
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
      OnMouseDown = FormMouseDown
    end
    object memDisplay: TMemo
      Left = 3
      Top = 3
      Width = 207
      Height = 163
      Cursor = crArrow
      TabStop = False
      Align = alClient
      BorderStyle = bsNone
      Lines.Strings = (
        'memDisplay')
      ReadOnly = True
      TabOrder = 0
      WantTabs = True
      OnKeyDown = FormKeyDown
      OnMouseDown = FormMouseDown
    end
  end
  object tmrSingleView: TTimer
    Enabled = False
    Interval = 15000
    OnTimer = tmrSingleViewTimer
    Left = 72
    Top = 64
  end
end
