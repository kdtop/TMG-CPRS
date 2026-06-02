object frmConsultants: TfrmConsultants
  Left = 0
  Top = 0
  Caption = 'Consultants'
  ClientHeight = 508
  ClientWidth = 747
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 233
    Width = 747
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 217
    ExplicitWidth = 254
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 747
    Height = 233
    Align = alTop
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 345
      Top = 1
      Height = 231
      ExplicitLeft = 560
      ExplicitTop = 88
      ExplicitHeight = 100
    end
    object lstSpecialties: TORListBox
      Left = 1
      Top = 1
      Width = 344
      Height = 231
      Align = alLeft
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = lstSpecialtiesClick
      ItemTipColor = clWindow
      LongList = False
      LookupPiece = 1
      Pieces = '2'
    end
    object lstOffices: TORListBox
      Left = 348
      Top = 1
      Width = 398
      Height = 231
      Align = alClient
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = lstOfficesClick
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 236
    Width = 747
    Height = 272
    Align = alClient
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 348
      Top = 1
      Height = 270
      ExplicitLeft = 528
      ExplicitTop = 96
      ExplicitHeight = 100
    end
    object pnlBottomLeft: TPanel
      Left = 1
      Top = 1
      Width = 347
      Height = 270
      Align = alLeft
      TabOrder = 0
      DesignSize = (
        347
        270)
      object lstDoctors: TORListBox
        Left = 1
        Top = 1
        Width = 345
        Height = 227
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = lstDoctorsClick
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object btnDoctorAdd: TBitBtn
        Left = 1
        Top = 235
        Width = 75
        Height = 27
        Anchors = [akLeft, akBottom]
        Caption = 'Add'
        Enabled = False
        TabOrder = 1
        OnClick = btnDoctorAddClick
      end
      object btnDoctorDelete: TBitBtn
        Left = 82
        Top = 235
        Width = 75
        Height = 27
        Anchors = [akLeft, akBottom]
        Caption = 'Delete'
        Enabled = False
        TabOrder = 2
        OnClick = btnDoctorDeleteClick
      end
    end
    object pnlBottomRight: TPanel
      Left = 351
      Top = 1
      Width = 395
      Height = 270
      Align = alClient
      TabOrder = 1
      DesignSize = (
        395
        270)
      object Label1: TLabel
        Left = 43
        Top = 67
        Width = 30
        Height = 13
        Caption = 'Phone'
      end
      object Label2: TLabel
        Left = 207
        Top = 67
        Width = 18
        Height = 13
        Caption = 'Fax'
      end
      object Label3: TLabel
        Left = 14
        Top = 32
        Width = 59
        Height = 13
        Caption = 'Office Name'
      end
      object Label4: TLabel
        Left = 46
        Top = 107
        Width = 28
        Height = 13
        Caption = 'Notes'
      end
      object btnClose: TBitBtn
        Left = 280
        Top = 228
        Width = 75
        Height = 27
        Anchors = [akLeft, akBottom]
        Caption = 'Close'
        ModalResult = 1
        TabOrder = 0
      end
      object edtNotes: TEdit
        Left = 80
        Top = 104
        Width = 273
        Height = 21
        TabOrder = 1
        OnChange = edtNotesChange
      end
      object edtOfficeName: TEdit
        Left = 79
        Top = 24
        Width = 274
        Height = 21
        TabOrder = 2
        OnChange = edtOfficeNameChange
      end
      object edtPhone: TEdit
        Left = 79
        Top = 64
        Width = 121
        Height = 21
        TabOrder = 3
        OnChange = edtPhoneChange
      end
      object edtFax: TEdit
        Left = 231
        Top = 64
        Width = 121
        Height = 21
        TabOrder = 4
        OnChange = edtFaxChange
      end
      object btnSave: TBitBtn
        Left = 80
        Top = 228
        Width = 75
        Height = 27
        Anchors = [akLeft, akBottom]
        Caption = 'Save'
        Enabled = False
        TabOrder = 5
        OnClick = btnSaveClick
      end
    end
  end
end
