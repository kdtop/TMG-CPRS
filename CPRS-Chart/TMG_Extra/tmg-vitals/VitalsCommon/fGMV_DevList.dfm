object frmGMV_DevList: TfrmGMV_DevList
  Left = 294
  Top = 189
  Width = 508
  Height = 265
  HelpContext = 7
  Caption = 'Report options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 197
    Width = 500
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object OKButton: TButton
      Left = 338
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Print'
      TabOrder = 0
      OnClick = OKButtonClick
    end
    object Button2: TButton
      Left = 418
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 274
    Height = 197
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object GroupBox2: TGroupBox
      Left = 4
      Top = 4
      Width = 266
      Height = 50
      Align = alTop
      Caption = 'Select Report:'
      TabOrder = 0
      object ReportCombo: TComboBox
        Left = 8
        Top = 18
        Width = 252
        Height = 21
        Hint = 'Report to Print. '
        DropDownCount = 15
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = ReportComboChange
        Items.Strings = (
          'Vitals Signs Record (ASP)'
          'B/P Plotting Chart (ASP)'
          'Weight Chart (ASP)'
          'POx/Respirations Chart (ASP)'
          'Pain Chart (ASP)'
          'Cumulative Vitals Report (ASP)'
          'Latest Vitals by location (A)'
          'Latest Vitals for Patient (P)'
          'Entered in Error Patient (P)')
      end
    end
    object GroupBox3: TGroupBox
      Left = 4
      Top = 144
      Width = 266
      Height = 49
      Align = alBottom
      Caption = 'Select Device:'
      TabOrder = 1
      inline fraDevLookup: TfraGMV_Lookup
        Left = 8
        Top = 19
        Width = 249
        Height = 22
        inherited cbxValues: TComboBox
          Width = 249
        end
        inherited edtValue: TComboBox
          Width = 249
          Hint = 'Select Printer Connected to M-System'
          ParentShowHint = False
          ShowHint = True
        end
      end
    end
    object GroupBox1: TGroupBox
      Left = 4
      Top = 54
      Width = 266
      Height = 90
      Align = alClient
      Caption = 'Select Start/End Date:'
      TabOrder = 2
      object Label3: TLabel
        Left = 8
        Top = 28
        Width = 51
        Height = 13
        Caption = 'Start Date:'
      end
      object Label4: TLabel
        Left = 8
        Top = 63
        Width = 48
        Height = 13
        Caption = 'End Date:'
      end
      object dtpToDate: TDateTimePicker
        Left = 63
        Top = 60
        Width = 97
        Height = 21
        CalAlignment = dtaLeft
        Date = 37245.4457426042
        Time = 37245.4457426042
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
      end
      object dtpFromDate: TDateTimePicker
        Left = 63
        Top = 25
        Width = 97
        Height = 21
        CalAlignment = dtaLeft
        Date = 37245.4450408102
        Time = 37245.4450408102
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = True
        TabOrder = 1
      end
      object dtpFromTime: TDateTimePicker
        Left = 163
        Top = 25
        Width = 96
        Height = 21
        CalAlignment = dtaLeft
        Date = 37308.578132338
        Time = 37308.578132338
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkTime
        ParseInput = False
        TabOrder = 2
      end
      object dtpToTime: TDateTimePicker
        Left = 163
        Top = 60
        Width = 96
        Height = 21
        CalAlignment = dtaLeft
        Date = 37308.578132338
        Time = 37308.578132338
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkTime
        ParseInput = False
        TabOrder = 3
      end
    end
  end
  object pnlRight: TPanel
    Left = 274
    Top = 0
    Width = 226
    Height = 197
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 2
    object GroupBox5: TGroupBox
      Left = 4
      Top = 54
      Width = 218
      Height = 139
      Align = alClient
      Caption = 'Select location information (optional):'
      TabOrder = 0
      object WardLabel: TLabel
        Left = 8
        Top = 28
        Width = 29
        Height = 13
        Caption = 'Ward:'
        Enabled = False
      end
      object RoomLabel: TLabel
        Left = 8
        Top = 63
        Width = 31
        Height = 13
        Caption = 'Room:'
        Enabled = False
      end
      object RoomCombo: TORComboBox
        Left = 45
        Top = 60
        Width = 165
        Height = 21
        CheckBoxes = True
        Style = orcsDropDown
        AutoSelect = False
        Color = clWindow
        DropDownCount = 8
        Enabled = False
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = False
        MaxLength = 0
        ParentShowHint = False
        Pieces = '2'
        ShowHint = True
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        CheckBoxEditColor = clHighlightText
      end
      object WardCombo: TORComboBox
        Left = 45
        Top = 25
        Width = 165
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Color = clWindow
        DropDownCount = 8
        Enabled = False
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        MaxLength = 0
        Pieces = '2'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 1
        OnChange = WardComboChange
      end
    end
    object GroupBox4: TGroupBox
      Left = 4
      Top = 4
      Width = 218
      Height = 50
      Align = alTop
      Caption = 'Select time and date to print report:'
      TabOrder = 1
      object dtpPrintDate: TDateTimePicker
        Left = 8
        Top = 18
        Width = 97
        Height = 21
        CalAlignment = dtaLeft
        Date = 37245.480350787
        Time = 37245.480350787
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
      end
      object dtpPrintTime: TDateTimePicker
        Left = 110
        Top = 17
        Width = 96
        Height = 21
        CalAlignment = dtaLeft
        Date = 37308.578132338
        Time = 37308.578132338
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkTime
        ParseInput = False
        TabOrder = 1
      end
    end
  end
end
