object frmGMV_ReportOptions: TfrmGMV_ReportOptions
  Left = 561
  Top = 293
  HelpContext = 7
  BorderStyle = bsDialog
  Caption = ' Report Options'
  ClientHeight = 401
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    77000770007700077000770007700000F7000F7000F7000F7000F7000F700000
    0000000000000000000000000000000000000000000000000000000000007708
    F8F8F8F8F8F8F8F8F8F8F8F8F8F8F70000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000770899F8F8F8F899F8F448F8F8F8F448F700
    99000000009900044F0000000440000000900000090090400400000040000000
    0009000090000400004000040000000000009009000040900004004000007708
    44F8F998F844F8F998F844F8F8F8F70044000990004400099000440000000000
    0040000004000000090000000000000000040000400000000090000000000000
    00004004000000000009000000007708F8F8F448F8F8F8F8F8F899F8F8F8F700
    0000044000000000000099000000000000000000000000000000009000000000
    0000000000000000000000090000000000000000000000000000000090007708
    F8F8F8F8F8F8F8F8F8F8F8F8F998F70000000000000000000000000009900000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000007708F8F8F8F8F8F8F8F8F8F8F8F8F8F8F700
    0000000000000000000000000000FFFFFFFFF39CE739F39CE739FFFFFFFFFFFF
    FFFF200000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2000000033FCE3F9FDFB
    5BF7FEF7BDEFFF6F5EDF20000000339CE73FFDFBFBFFFEF7FDFFFF6FFEFF2000
    00003F9FFF3FFFFFFFDFFFFFFFEFFFFFFFF7200000003FFFFFF9FFFFFFFFFFFF
    FFFFFFFFFFFF200000003FFFFFFF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000007707707707707000F
    70F70F70F70F7700000000000000F70998F8F998F8F800099000099000047700
    090090090440F708F899F8F8944800000099000049007700000000440090F704
    48F8F844F8F900044000040000097700040040000000F708F844F8F8F8F80000
    0044000000007700000000000000F708F8F8F8F8F8F8E4920000E49200003FFF
    000020000000E79E00003B69000020000000FCF300003FCD000020000000E7BE
    00003B7F000020000000FCFF00003FFF000020000000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 360
    Width = 325
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object OKButton: TButton
      Left = 163
      Top = 9
      Width = 75
      Height = 25
      Action = acPrintReport
      Caption = '&Print'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 245
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 325
    Height = 360
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object GroupBox2: TGroupBox
      Left = 4
      Top = 4
      Width = 317
      Height = 352
      Align = alClient
      Caption = '   Select &Report:  '
      TabOrder = 0
      object Bevel1: TBevel
        Left = 13
        Top = 56
        Width = 289
        Height = 9
        Shape = bsTopLine
      end
      object Bevel2: TBevel
        Left = 13
        Top = 168
        Width = 289
        Height = 9
        Shape = bsTopLine
      end
      object WardLabel: TLabel
        Left = 56
        Top = 113
        Width = 29
        Height = 13
        Caption = '&Ward:'
        Enabled = False
        FocusControl = WardCombo
      end
      object RoomLabel: TLabel
        Left = 56
        Top = 136
        Width = 31
        Height = 13
        Caption = 'R&oom:'
        Enabled = False
        FocusControl = RoomCombo
      end
      object lblStart: TLabel
        Left = 40
        Top = 188
        Width = 51
        Height = 13
        Caption = '&Start Date:'
        FocusControl = dtpFromDate
      end
      object lblEnd: TLabel
        Left = 40
        Top = 211
        Width = 48
        Height = 13
        Caption = '&End Date:'
        FocusControl = dtpToDate
      end
      object Label1: TLabel
        Left = 24
        Top = 49
        Width = 97
        Height = 13
        Caption = '  Include Patient(s):  '
      end
      object Label2: TLabel
        Left = 24
        Top = 161
        Width = 73
        Height = 13
        Caption = '  Date Range:  '
      end
      object Bevel3: TBevel
        Left = 13
        Top = 248
        Width = 289
        Height = 9
        Shape = bsTopLine
      end
      object Label5: TLabel
        Left = 24
        Top = 241
        Width = 49
        Height = 13
        Caption = '  &Device:  '
        FocusControl = fraDevLookup
      end
      object Bevel4: TBevel
        Left = 13
        Top = 296
        Width = 289
        Height = 9
        Shape = bsTopLine
      end
      object Label6: TLabel
        Left = 24
        Top = 288
        Width = 99
        Height = 13
        Caption = '  &Queue To Run At:  '
        FocusControl = dtpPrintDate
      end
      object ReportCombo: TComboBox
        Left = 16
        Top = 18
        Width = 281
        Height = 21
        Hint = 'Report to Print. '
        DropDownCount = 15
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = acReportChanged
        Items.Strings = (
          'Vitals Signs Record'
          'B/P Plotting Chart '
          'Weight Chart'
          'POx/Respirations Chart'
          'Pain Chart'
          'Cumulative Vitals Report'
          'Latest Vitals by location'
          'Latest Vitals for Patient'
          'Entered in Error Patient')
      end
      object WardCombo: TORComboBox
        Left = 101
        Top = 109
        Width = 196
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
        TabOrder = 3
        OnChange = acWardChangedExecute
      end
      object RoomCombo: TORComboBox
        Left = 101
        Top = 133
        Width = 196
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
        TabOrder = 4
        CheckBoxEditColor = clHighlightText
      end
      object dtpFromDate: TDateTimePicker
        Left = 101
        Top = 185
        Width = 97
        Height = 21
        CalAlignment = dtaLeft
        Date = 37245.4450408102
        Time = 37245.4450408102
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 5
        OnChange = acStartDateChanged
      end
      object dtpFromTime: TDateTimePicker
        Left = 201
        Top = 185
        Width = 96
        Height = 21
        CalAlignment = dtaLeft
        Date = 37308.578132338
        Time = 37308.578132338
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkTime
        ParseInput = False
        TabOrder = 6
        OnChange = acStartTimeChangedExecute
      end
      object dtpToTime: TDateTimePicker
        Left = 201
        Top = 208
        Width = 96
        Height = 21
        CalAlignment = dtaLeft
        Date = 37308.578132338
        Time = 37308.578132338
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkTime
        ParseInput = False
        TabOrder = 8
        OnChange = acEndTimeChangedExecute
      end
      object dtpToDate: TDateTimePicker
        Left = 101
        Top = 208
        Width = 97
        Height = 21
        CalAlignment = dtaLeft
        Date = 37245.4457426042
        Time = 37245.4457426042
        DateFormat = dfShort
        DateMode = dmComboBox
        Enabled = False
        Kind = dtkDate
        ParseInput = False
        TabOrder = 7
        OnChange = acStopDateChangedExecute
      end
      inline fraDevLookup: TfraGMV_Lookup
        Left = 101
        Top = 259
        Width = 196
        Height = 30
        TabOrder = 9
        inherited cbxValues: TComboBox
          Width = 196
          TabOrder = 0
        end
        inherited edtValue: TComboBox
          Width = 196
          Hint = 'Select Printer Connected to M-System'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        inherited tmrLookup: TTimer
          OnTimer = fraDevLookuptmrLookupTimer
        end
      end
      object dtpPrintDate: TDateTimePicker
        Left = 101
        Top = 314
        Width = 97
        Height = 21
        CalAlignment = dtaLeft
        Date = 37245.480350787
        Time = 37245.480350787
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 10
        OnChange = acPrintDateChangedExecute
      end
      object dtpPrintTime: TDateTimePicker
        Left = 201
        Top = 314
        Width = 96
        Height = 21
        CalAlignment = dtaLeft
        Date = 37308.578132338
        Time = 37308.578132338
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkTime
        ParseInput = False
        TabOrder = 11
        OnChange = acPrintDateChangedExecute
      end
      object rbPatient: TRadioButton
        Left = 40
        Top = 70
        Width = 249
        Height = 17
        Caption = '&Patient'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = acScopeChangedExecute
      end
      object rbAllPatients: TRadioButton
        Left = 40
        Top = 90
        Width = 113
        Height = 17
        Caption = 'Patients &Located at: '
        TabOrder = 2
        OnClick = acScopeChangedExecute
      end
    end
  end
  object ActionList1: TActionList
    Left = 269
    Top = 69
    object acReportCh: TAction
      Caption = 'acReportCh'
      OnExecute = acReportChanged
    end
    object acScopeChanged: TAction
      Caption = 'acScopeChanged'
      OnExecute = acScopeChangedExecute
    end
    object acWardChanged: TAction
      Caption = 'acWardChanged'
      OnExecute = acWardChangedExecute
    end
    object acPrintReport: TAction
      Caption = 'Print'
      Enabled = False
      OnExecute = acPrintReportExecute
    end
    object acStartDate: TAction
      Caption = 'acStartDate'
      OnExecute = acStartDateChanged
    end
    object acStopDateChanged: TAction
      Caption = 'acStopDateChanged'
      OnExecute = acStopDateChangedExecute
    end
    object acUPdateDTPColors: TAction
      Caption = 'acUPdateDTPColors'
      OnExecute = acUPdateDTPColorsExecute
    end
    object acStartTimeChanged: TAction
      Caption = 'acStartTimeChanged'
      OnExecute = acStartTimeChangedExecute
    end
    object acEndTimeChanged: TAction
      Caption = 'acEndTimeChanged'
      OnExecute = acEndTimeChangedExecute
    end
    object acPrinTimeChanged: TAction
      Caption = 'acPrinTimeChanged'
    end
    object acPrintDateChanged: TAction
      Caption = 'acPrintDateChanged'
      OnExecute = acPrintDateChangedExecute
    end
  end
end
