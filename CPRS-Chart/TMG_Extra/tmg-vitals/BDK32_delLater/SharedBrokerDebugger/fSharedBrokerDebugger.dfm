object frmSharedBrokerDebugger: TfrmSharedBrokerDebugger
  Left = 146
  Top = 0
  Width = 639
  Height = 571
  Caption = 'SharedRPCBroker Debugger'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 139
    Height = 13
    Caption = 'Current Shared Broker Clients'
  end
  object Label2: TLabel
    Left = 16
    Top = 200
    Width = 126
    Height = 13
    Caption = 'Actual Broker Connections'
  end
  object Label3: TLabel
    Left = 16
    Top = 328
    Width = 109
    Height = 13
    Caption = 'Client Connections Log'
  end
  object lblMaxRPCEntries: TLabel
    Left = 328
    Top = 16
    Width = 80
    Height = 13
    Caption = '&Max RPC Entries'
  end
  object Label4: TLabel
    Left = 160
    Top = 16
    Width = 152
    Height = 13
    Caption = 'Check a box to view RPCs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 176
    Top = 200
    Width = 235
    Height = 13
    Caption = 'Check a box to view RPCs and their data'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnExit: TButton
    Left = 278
    Top = 492
    Width = 75
    Height = 25
    Caption = 'E&xit'
    TabOrder = 6
    OnClick = btnExitClick
  end
  object EnableRpcCallLogForAllClientsCheckBox: TCheckBox
    Left = 480
    Top = 16
    Width = 129
    Height = 17
    Alignment = taLeftJustify
    Caption = '&Enable RPC Call Log'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object CurrentClientsCheckedListBox: TCheckListBox
    Left = 16
    Top = 32
    Width = 593
    Height = 161
    OnClickCheck = CurrentClientsCheckedListBoxClickCheck
    ItemHeight = 13
    TabOrder = 3
  end
  object actualBrokerConnectionsCheckedListBox: TCheckListBox
    Left = 16
    Top = 216
    Width = 593
    Height = 105
    OnClickCheck = actualBrokerConnectionsCheckedListBoxClickCheck
    ItemHeight = 13
    TabOrder = 4
  end
  object RpcCallLogListBox: TListBox
    Left = 520
    Top = 456
    Width = 65
    Height = 57
    TabStop = False
    ItemHeight = 13
    TabOrder = 0
    Visible = False
  end
  object maxAllClientRpcLogEntriesNumericUpDown: TEdit
    Left = 416
    Top = 8
    Width = 41
    Height = 21
    TabOrder = 1
    Text = '100'
  end
  object UpDown1: TUpDown
    Left = 457
    Top = 8
    Width = 15
    Height = 21
    Associate = maxAllClientRpcLogEntriesNumericUpDown
    Min = 0
    Position = 100
    TabOrder = 7
    Wrap = False
  end
  object clientConnectionsLogRichTextBox: TRichEdit
    Left = 16
    Top = 344
    Width = 593
    Height = 137
    Lines.Strings = (
      '')
    TabOrder = 5
  end
  object mVistaSession: TSharedBroker
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 56
    Top = 488
  end
  object MainMenu1: TMainMenu
    Left = 120
    Top = 496
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object CopyConnectionsLogToClipboard1: TMenuItem
        Caption = '&Copy Connections Log To Clipboard'
        OnClick = CopyConnectionsLogToClipboard1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
    end
  end
end
