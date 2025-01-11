object frmNoteTOC: TfrmNoteTOC
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'This Note'#39's TOC'
  ClientHeight = 429
  ClientWidth = 372
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 372
    Height = 376
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    ParentColor = True
    TabOrder = 0
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 1
      Width = 370
      Height = 374
      Align = alClient
      TabOrder = 0
      OnBeforeNavigate2 = WebBrowser1BeforeNavigate2
      ExplicitLeft = 320
      ExplicitTop = 112
      ExplicitWidth = 300
      ExplicitHeight = 150
      ControlData = {
        4C0000003E260000A72600000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 376
    Width = 372
    Height = 53
    Align = alClient
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 16
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object chkKeepOpen: TCheckBox
      Left = 16
      Top = 5
      Width = 145
      Height = 17
      Caption = 'Keep open after search'
      TabOrder = 1
      OnClick = chkKeepOpenClick
    end
    object BitBtn2: TBitBtn
      Left = 100
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Refresh'
      TabOrder = 2
      OnClick = BitBtn2Click
    end
    object btnAutoOpenTOC: TCheckBox
      Left = 181
      Top = 6
      Width = 164
      Height = 17
      Caption = 'AutoOpen TOC on note select'
      TabOrder = 3
      OnClick = btnAutoOpenTOCClick
    end
    object cmbLocation: TComboBox
      Left = 181
      Top = 25
      Width = 170
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      OnChange = cmbLocationChange
      Items.Strings = (
        'Show on right of note'
        'Show on outside of CPRS')
    end
  end
  object timerOpen: TTimer
    Enabled = False
    Interval = 2
    OnTimer = timerOpenTimer
    Left = 480
    Top = 384
  end
  object timerClose: TTimer
    Enabled = False
    Interval = 2
    OnTimer = timerCloseTimer
    Left = 232
    Top = 64
  end
end
