object frmIntracarePtAdmLbl: TfrmIntracarePtAdmLbl
  Left = 606
  Top = 362
  Caption = 'Intracare Label Print'
  ClientHeight = 188
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 72
    Top = 72
    Width = 81
    Height = 13
    Caption = 'Number of pages'
  end
  object Label2: TLabel
    Left = 48
    Top = 24
    Width = 108
    Height = 13
    Caption = 'Please Select A Printer'
  end
  object Label3: TLabel
    Left = 24
    Top = 120
    Width = 132
    Height = 13
    Caption = 'Choose Attending Physician'
  end
  object cmbPrinter: TComboBox
    Left = 168
    Top = 16
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'cmbPrinter'
  end
  object Edit1: TEdit
    Left = 168
    Top = 64
    Width = 41
    Height = 21
    TabOrder = 1
    Text = '1'
    OnKeyPress = Edit1KeyPress
  end
  object UpDown1: TUpDown
    Left = 208
    Top = 64
    Width = 17
    Height = 21
    TabOrder = 2
    OnClick = UpDown1Click
  end
  object btnOK: TButton
    Left = 152
    Top = 152
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 240
    Top = 152
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object cmbPhysicians: TComboBox
    Left = 168
    Top = 112
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    Text = 'cmbPhysicians'
  end
  object btnPreview: TButton
    Left = 16
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Preview'
    TabOrder = 6
    Visible = False
    OnClick = btnPreviewClick
  end
  object CLOSE: TTimer
    Interval = 10
    OnTimer = CLOSETimer
    Left = 32
    Top = 48
  end
end
