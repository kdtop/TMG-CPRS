object frmMissedAppt: TfrmMissedAppt
  Left = 0
  Top = 0
  Caption = 'frmMissedAppt'
  ClientHeight = 455
  ClientWidth = 592
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 360
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
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 57
    Align = alTop
    TabOrder = 0
    object lblNewAppt: TLabel
      Left = 45
      Top = 5
      Width = 89
      Height = 13
      Caption = 'New Appointment:'
    end
    object lblNAppt: TLabel
      Left = 141
      Top = 5
      Width = 40
      Height = 13
      Caption = 'lblNAppt'
    end
    object lblMADt: TLabel
      Left = 8
      Top = 27
      Width = 126
      Height = 13
      Caption = 'Missed Appointment Date:'
    end
    object dtpMA: TDateTimePicker
      Left = 141
      Top = 23
      Width = 101
      Height = 21
      Date = 37820.584724004600000000
      Time = 37820.584724004600000000
      TabOrder = 0
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 415
    Width = 592
    Height = 40
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      592
      40)
    object ckbMAInclInst: TCheckBox
      Left = 8
      Top = 6
      Width = 156
      Height = 17
      Hint = 'Click to include patient instructions in your no-show note.'
      Anchors = [akLeft, akBottom]
      Caption = 'Include Instructions in Note?'
      Enabled = False
      TabOrder = 0
    end
    object btnCloseGbxMA: TButton
      Left = 413
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Close'
      TabOrder = 1
    end
    object btnMAPreview: TButton
      Left = 494
      Top = 6
      Width = 90
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Preview/Print'
      TabOrder = 2
      OnClick = btnMAPreviewClick
    end
  end
  object pnlHTMLObjHolder: TPanel
    Left = 0
    Top = 57
    Width = 592
    Height = 358
    Align = alClient
    BevelOuter = bvNone
    Caption = 'HTML Editor will go here'
    Color = clActiveCaption
    TabOrder = 2
  end
end
