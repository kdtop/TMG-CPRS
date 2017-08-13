object frmADT: TfrmADT
  Left = 0
  Top = 0
  Caption = 'ADT (Admit, Discharge, Transfer)'
  ClientHeight = 515
  ClientWidth = 721
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 721
    Height = 455
    ActivePage = Admit
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object Admit: TTabSheet
      Caption = 'Admit'
      object Label1: TLabel
        Left = 16
        Top = 5
        Width = 73
        Height = 13
        Caption = 'Admission Date'
      end
      object Label2: TLabel
        Left = 16
        Top = 255
        Width = 94
        Height = 13
        Caption = 'Attending Physician'
      end
      object Label3: TLabel
        Left = 16
        Top = 205
        Width = 122
        Height = 13
        Caption = 'Facility Treating Specialty'
      end
      object Label4: TLabel
        Left = 16
        Top = 55
        Width = 26
        Height = 13
        Caption = 'Ward'
      end
      object Label5: TLabel
        Left = 16
        Top = 105
        Width = 55
        Height = 13
        Caption = 'Room / Bed'
      end
      object Label6: TLabel
        Left = 16
        Top = 305
        Width = 114
        Height = 13
        Caption = 'Description of Diagnosis'
      end
      object Label7: TLabel
        Left = 16
        Top = 155
        Width = 77
        Height = 13
        Caption = 'Movement Type'
      end
      object Label9: TLabel
        Left = 16
        Top = 355
        Width = 75
        Height = 13
        Caption = 'Referral Source'
      end
      object rgrpAdmitType: TRadioGroup
        Left = 16
        Top = 150
        Width = 161
        Height = 52
        Caption = 'Admission Type'
        Items.Strings = (
          'Direct Admission'
          'Transfer In')
        TabOrder = 0
      end
      object cmbPhysicians: TORComboBox
        Left = 48
        Top = 275
        Width = 186
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '1'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 7
        CharsNeedMatch = 1
      end
      object cmbFTSPEC: TORComboBox
        Left = 48
        Top = 225
        Width = 186
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '1'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 6
        CharsNeedMatch = 1
      end
      object cmbWard: TORComboBox
        Left = 48
        Top = 75
        Width = 186
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '1'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 2
        OnChange = cmbWardChange
        CharsNeedMatch = 1
      end
      object cmbRoomBed: TORComboBox
        Left = 48
        Top = 125
        Width = 186
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '1'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 3
        CharsNeedMatch = 1
      end
      object edtDiag: TEdit
        Left = 48
        Top = 325
        Width = 186
        Height = 21
        MaxLength = 30
        TabOrder = 8
      end
      object dtAdmit: TORDateBox
        Left = 48
        Top = 25
        Width = 186
        Height = 21
        TabOrder = 1
        Text = 'NOW'
        DateOnly = False
        RequireTime = True
      end
      object ADTType: TRadioGroup
        Left = 358
        Top = 3
        Width = 249
        Height = 105
        Items.Strings = (
          'Admit'
          'Transfer'
          'Discharge')
        TabOrder = 4
        OnClick = ADTTypeClick
      end
      object cmbMovement: TORComboBox
        Left = 48
        Top = 175
        Width = 186
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '1'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 5
        CharsNeedMatch = 1
      end
      object edtReferral: TEdit
        Left = 48
        Top = 375
        Width = 186
        Height = 21
        MaxLength = 30
        TabOrder = 9
      end
    end
    object Census: TTabSheet
      Caption = 'Census Report'
      ImageIndex = 1
      DesignSize = (
        713
        427)
      object Label8: TLabel
        Left = 200
        Top = 23
        Width = 26
        Height = 13
        Caption = 'Ward'
      end
      object cmbWardForCensus: TORComboBox
        Left = 248
        Top = 15
        Width = 186
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '1'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        OnChange = cmbWardForCensusChange
        CharsNeedMatch = 1
      end
      object Memo1: TMemo
        Left = 32
        Top = 56
        Width = 569
        Height = 329
        Lines.Strings = (
          'Memo1')
        TabOrder = 1
        Visible = False
      end
      object btnPrint: TButton
        Left = 620
        Top = 399
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&Print'
        TabOrder = 2
        OnClick = btnPrintClick
      end
      object WebBrowser1: TWebBrowser
        Left = 16
        Top = 56
        Width = 673
        Height = 329
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 3
        ControlData = {
          4C0000008E450000012200000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object btnExport: TButton
        Left = 532
        Top = 400
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&Export'
        TabOrder = 4
        OnClick = btnExportClick
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 455
    Width = 721
    Height = 60
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      721
      60)
    object Button1: TButton
      Left = 536
      Top = 22
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Ok'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 617
      Top = 22
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
