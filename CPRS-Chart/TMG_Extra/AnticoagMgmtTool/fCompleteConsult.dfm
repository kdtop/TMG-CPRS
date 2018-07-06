object frmCompleteConsult: TfrmCompleteConsult
  Left = 0
  Top = 0
  Caption = 'Complete consult'
  ClientHeight = 287
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlConsult: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 287
    Align = alClient
    TabOrder = 0
    Visible = False
    DesignSize = (
      635
      287)
    object lblSelConsult: TLabel
      Left = 9
      Top = 3
      Width = 188
      Height = 13
      Caption = 'Choose the pending consult to resolve:'
    end
    object lbxConsult: TListBox
      Left = 9
      Top = 22
      Width = 613
      Height = 229
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
    end
    object btnConsult: TButton
      Left = 472
      Top = 256
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnConsultClick
    end
    object btnCanCon: TButton
      Left = 553
      Top = 256
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnCanConClick
    end
  end
end
