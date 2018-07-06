object frmStartAnticoagationManagement: TfrmStartAnticoagationManagement
  Left = 0
  Top = 0
  Caption = 'Start Anticoagulation Management'
  ClientHeight = 495
  ClientWidth = 679
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 460
    Width = 679
    Height = 35
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      679
      35)
    object lblDCSign: TLabel
      Left = 104
      Top = 9
      Width = 30
      Height = 13
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'Sign:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object edtSigDC: TEdit
      Left = 140
      Top = 6
      Width = 375
      Height = 21
      Anchors = [akLeft, akTop, akRight, akBottom]
      PasswordChar = '*'
      TabOrder = 0
      Visible = False
    end
    object btnEditNote: TButton
      Left = 7
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akLeft, akTop, akBottom]
      Caption = '&Edit Note'
      TabOrder = 1
    end
    object btnDCsign: TButton
      Left = 520
      Top = 6
      Width = 75
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Sign Note'
      Enabled = False
      TabOrder = 2
      OnClick = btnDCsignClick
    end
    object btnCancel: TButton
      Left = 599
      Top = 6
      Width = 70
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      TabOrder = 3
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 679
    Height = 89
    Align = alTop
    Alignment = taLeftJustify
    TabOrder = 1
    object lblDCOn: TLabel
      Left = 203
      Top = 47
      Width = 12
      Height = 13
      Caption = 'on'
    end
    object lblDCFor: TLabel
      Left = 322
      Top = 46
      Width = 62
      Height = 13
      Alignment = taCenter
      BiDiMode = bdRightToLeft
      Caption = ' for (specify)'
      ParentBiDiMode = False
    end
    object ckbPMove: TCheckBox
      Left = 11
      Top = 8
      Width = 304
      Height = 17
      Caption = 'Pt moved from service area; transferring management to:'
      TabOrder = 0
    end
    object edtPMove: TEdit
      Left = 321
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object ckbPViol: TCheckBox
      Left = 11
      Top = 26
      Width = 257
      Height = 17
      Caption = 'Pt violated Anticoagulation Treatment Agreement'
      TabOrder = 2
    end
    object ckbPtDC: TCheckBox
      Left = 11
      Top = 45
      Width = 65
      Height = 17
      Caption = 'D/C'#39'd by'
      TabOrder = 3
    end
    object ckbOther: TCheckBox
      Left = 11
      Top = 64
      Width = 178
      Height = 17
      Caption = 'other (Click View/Edit to specify)'
      TabOrder = 4
    end
    object edtPDC: TEdit
      Left = 75
      Top = 43
      Width = 121
      Height = 21
      Color = cl3DLight
      Enabled = False
      TabOrder = 5
    end
    object dtpDC: TDateTimePicker
      Left = 227
      Top = 43
      Width = 89
      Height = 21
      Date = 37908.636825231480000000
      Time = 37908.636825231480000000
      Color = cl3DLight
      Enabled = False
      TabOrder = 6
    end
  end
  object pnlHTMLObjHolder: TPanel
    Left = 0
    Top = 89
    Width = 679
    Height = 371
    Align = alClient
    BevelOuter = bvNone
    Caption = 'HTMl Editor will go here'
    Color = clActiveCaption
    TabOrder = 2
  end
end
