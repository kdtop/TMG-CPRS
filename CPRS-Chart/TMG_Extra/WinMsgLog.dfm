object frmWinMessageLog: TfrmWinMessageLog
  Left = 0
  Top = 0
  Caption = 'Message Log'
  ClientHeight = 361
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    466
    361)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 145
    Height = 13
    Caption = 'Number of Messages Logged: '
  end
  object lblNumLogged: TLabel
    Left = 159
    Top = 8
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label2: TLabel
    Left = 8
    Top = 27
    Width = 154
    Height = 13
    Caption = 'Last Message Stored at Index:  '
  end
  object lblLastIndex: TLabel
    Left = 168
    Top = 27
    Width = 58
    Height = 13
    Caption = 'lblLastIndex'
  end
  object Label3: TLabel
    Left = 8
    Top = 46
    Width = 97
    Height = 13
    Caption = 'Current View Index:'
  end
  object edtViewIndex: TEdit
    Left = 111
    Top = 46
    Width = 121
    Height = 25
    TabOrder = 0
    Text = '0'
  end
  object UpDown: TUpDown
    Left = 232
    Top = 46
    Width = 17
    Height = 25
    TabOrder = 1
    OnChangingEx = UpDownChangingEx
    OnClick = UpDownClick
  end
  object Memo: TMemo
    Left = 8
    Top = 77
    Width = 450
    Height = 245
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      '')
    TabOrder = 2
  end
  object btnDone: TButton
    Left = 362
    Top = 328
    Width = 96
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Done'
    ModalResult = 1
    TabOrder = 3
    OnClick = btnDoneClick
    ExplicitLeft = 384
    ExplicitTop = 321
  end
  object btnClear: TButton
    Left = 8
    Top = 328
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Clear'
    TabOrder = 4
    OnClick = btnClearClick
  end
end
