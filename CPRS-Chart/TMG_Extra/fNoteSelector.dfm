object frmNoteSelector: TfrmNoteSelector
  Left = 0
  Top = 0
  Caption = 'Note Viewer'
  ClientHeight = 540
  ClientWidth = 1139
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 150
    Width = 1139
    Height = 0
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 121
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1139
    Height = 150
    Align = alTop
    TabOrder = 0
    DesignSize = (
      1139
      150)
    object Label1: TLabel
      Left = 1
      Top = 14
      Width = 132
      Height = 13
      Caption = 'Select the note title to view'
    end
    object tvnotes: TORListBox
      Left = 0
      Top = 40
      Width = 1139
      Height = 104
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = tvnotesClick
      OnDblClick = tvnotesDblClick
      ItemTipColor = clWindow
      LongList = False
      LookupPiece = 1
      Pieces = '2'
    end
    object btnOK: TButton
      Left = 967
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 1
      Visible = False
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 1048
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 2
      Visible = False
      OnClick = btnCancelClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 150
    Width = 1139
    Height = 390
    Align = alClient
    TabOrder = 1
    ExplicitTop = 103
    ExplicitHeight = 437
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 1
      Width = 1137
      Height = 388
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 1101
      ExplicitHeight = 329
      ControlData = {
        4C000000837500001A2800000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
