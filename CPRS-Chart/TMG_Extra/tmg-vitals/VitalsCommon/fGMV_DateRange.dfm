object frmGMV_DateRange: TfrmGMV_DateRange
  Left = 517
  Top = 293
  Width = 331
  Height = 109
  Caption = 'Date Range Selection'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 230
    Top = 0
    Width = 93
    Height = 82
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 6
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 8
      Top = 14
      Width = 75
      Height = 25
      Caption = '&OK'
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 8
      Top = 46
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 230
    Height = 82
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 230
      Height = 82
      Align = alClient
      TabOrder = 0
      object lblFrom: TLabel
        Left = 16
        Top = 20
        Width = 73
        Height = 13
        Caption = '&Start with Date:'
        FocusControl = dtpFrom
      end
      object lblTo: TLabel
        Left = 16
        Top = 52
        Width = 55
        Height = 13
        Caption = '&Go to Date:'
        FocusControl = dtpTo
      end
      object dtpFrom: TDateTimePicker
        Left = 104
        Top = 16
        Width = 105
        Height = 21
        CalAlignment = dtaLeft
        Date = 37302.4942927778
        Time = 37302.4942927778
        Color = clInfoBk
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
        OnEnter = dtpFromEnter
        OnExit = dtpFromExit
      end
      object dtpTo: TDateTimePicker
        Left = 104
        Top = 48
        Width = 105
        Height = 21
        CalAlignment = dtaLeft
        Date = 37302.4944563194
        Time = 37302.4944563194
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 1
        OnEnter = dtpToEnter
        OnExit = dtpToExit
      end
    end
  end
end
