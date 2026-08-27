object frmRpcClientLogger: TfrmRpcClientLogger
  Left = 173
  Top = 0
  Width = 665
  Height = 578
  Caption = 'frmRpcClientLogger'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblMaxRPCEntries: TLabel
    Left = 232
    Top = 16
    Width = 104
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '&Maximum RPC Entries'
  end
  object cbxEnableRPCLogging: TCheckBox
    Left = 528
    Top = 16
    Width = 121
    Height = 17
    Alignment = taLeftJustify
    Anchors = [akTop, akRight]
    Caption = '&Enable RPC Logging'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object UpDown1: TUpDown
    Left = 425
    Top = 8
    Width = 15
    Height = 21
    Anchors = [akTop, akRight]
    Associate = maxRpcLogEntriesNumericUpDown
    Min = 0
    Position = 100
    TabOrder = 0
    Wrap = False
    OnClick = UpDown1Click
  end
  object maxRpcLogEntriesNumericUpDown: TEdit
    Left = 360
    Top = 8
    Width = 65
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 6
    Text = '100'
  end
  object rpcLogListBox: TListBox
    Left = 8
    Top = 32
    Width = 641
    Height = 143
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 1
    OnClick = rpcLogListBoxClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 165
    Width = 641
    Height = 153
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object lblRPCName: TLabel
      Left = 16
      Top = 16
      Width = 53
      Height = 13
      Caption = 'RPC Name'
    end
    object lblRPCDebugID: TLabel
      Left = 240
      Top = 120
      Width = 71
      Height = 13
      Caption = 'RPC Debug ID'
    end
    object lblClientName: TLabel
      Left = 16
      Top = 88
      Width = 57
      Height = 13
      Caption = 'Client Name'
    end
    object lblClientDebugID: TLabel
      Left = 16
      Top = 120
      Width = 75
      Height = 13
      Caption = 'Client Debug ID'
    end
    object lblContext: TLabel
      Left = 16
      Top = 56
      Width = 36
      Height = 13
      Caption = 'Context'
    end
    object lblDuration: TLabel
      Left = 440
      Top = 120
      Width = 40
      Height = 13
      Caption = 'Duration'
    end
    object lblParams: TLabel
      Left = 8
      Top = 136
      Width = 35
      Height = 13
      Caption = 'Params'
    end
    object lblResults: TLabel
      Left = 336
      Top = 136
      Width = 35
      Height = 13
      Caption = 'Results'
    end
    object edtRPCName: TEdit
      Left = 96
      Top = 16
      Width = 521
      Height = 13
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 1
    end
    object edtRPCDebugID: TEdit
      Left = 320
      Top = 120
      Width = 73
      Height = 13
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 5
    end
    object edtClientName: TEdit
      Left = 96
      Top = 88
      Width = 521
      Height = 13
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 3
    end
    object edtClientDebugID: TEdit
      Left = 96
      Top = 120
      Width = 89
      Height = 13
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 4
    end
    object edtContext: TEdit
      Left = 96
      Top = 56
      Width = 521
      Height = 13
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 2
    end
    object edtDuration1: TEdit
      Left = 496
      Top = 120
      Width = 121
      Height = 13
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 6
    end
    object Edit2: TEdit
      Left = 512
      Top = 136
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Edit2'
      Visible = False
    end
  end
  object ParamsMemoBox: TRichEdit
    Left = 8
    Top = 320
    Width = 313
    Height = 161
    Anchors = [akLeft, akBottom]
    Lines.Strings = (
      '')
    TabOrder = 3
  end
  object ResultsMemoBox: TRichEdit
    Left = 336
    Top = 320
    Width = 313
    Height = 161
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 4
  end
  object btnClose: TButton
    Left = 291
    Top = 496
    Width = 75
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
  object MainMenu1: TMainMenu
    Left = 152
    object File1: TMenuItem
      Caption = '&File'
      object mnuFileClose: TMenuItem
        Caption = '&Close'
        OnClick = mnuFileCloseClick
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object mnuEditCopyToClipboard: TMenuItem
        Caption = '&Copy Current RPC To ClipBoard'
        Enabled = False
        OnClick = mnuEditCopyToClipboardClick
      end
    end
    object HGelp1: TMenuItem
      Caption = '&Help'
      object mnuHelpAbout: TMenuItem
        Caption = '&About'
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 232
    Top = 80
    object mnuPopupCopyToClipboard: TMenuItem
      Caption = '&Copy To Clipboard'
      OnClick = mnuPopupCopyToClipboardClick
    end
  end
end
