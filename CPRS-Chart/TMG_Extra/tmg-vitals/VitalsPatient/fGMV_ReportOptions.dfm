object frmGMV_ReportOptions: TfrmGMV_ReportOptions
  Left = 419
  Top = 170
  HelpContext = 7
  BorderStyle = bsDialog
  Caption = ' Report Options'
  ClientHeight = 475
  ClientWidth = 535
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
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 434
    Width = 535
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      535
      41)
    object OKButton: TButton
      Left = 371
      Top = 9
      Width = 75
      Height = 25
      Action = acPrintReport
      Anchors = [akTop, akRight]
      Caption = '&Print'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 453
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 535
    Height = 434
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 4
      Top = 4
      Width = 527
      Height = 426
      Align = alClient
      Caption = '   Select &Report:  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        527
        426)
      object Bevel1: TBevel
        Left = 13
        Top = 56
        Width = 505
        Height = 9
        Anchors = [akLeft, akTop, akRight]
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
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object RoomLabel: TLabel
        Left = 56
        Top = 136
        Width = 31
        Height = 13
        Caption = 'R&oom:'
        Enabled = False
        FocusControl = RoomCombo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 24
        Top = 49
        Width = 121
        Height = 13
        Caption = '  Include Patient(s):  '
      end
      object ReportCombo: TComboBox
        Left = 16
        Top = 18
        Width = 501
        Height = 21
        Hint = 'Report to Print. '
        DropDownCount = 15
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
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
        Width = 416
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Color = clWindow
        DropDownCount = 8
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        ParentFont = False
        Pieces = '2'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 3
        OnChange = acWardChangedExecute
        CharsNeedMatch = 1
      end
      object RoomCombo: TORComboBox
        Left = 101
        Top = 133
        Width = 416
        Height = 21
        CheckBoxes = True
        Style = orcsDropDown
        AutoSelect = False
        Color = clWindow
        DropDownCount = 8
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        ParentFont = False
        ParentShowHint = False
        Pieces = '2'
        ShowHint = True
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 4
        CheckBoxEditColor = clHighlightText
        CharsNeedMatch = 1
      end
      object rbPatient: TRadioButton
        Left = 32
        Top = 70
        Width = 481
        Height = 17
        Caption = '&Patient'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = acScopeChangedExecute
      end
      object rbAllPatients: TRadioButton
        Left = 32
        Top = 90
        Width = 113
        Height = 17
        Caption = 'Patients &Located at: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = acScopeChangedExecute
      end
      object Panel1: TPanel
        Left = 2
        Top = 245
        Width = 523
        Height = 179
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 6
        DesignSize = (
          523
          179)
        object Bevel3: TBevel
          Left = 13
          Top = 7
          Width = 506
          Height = 9
          Anchors = [akLeft, akTop, akRight]
          Shape = bsTopLine
        end
        object Label5: TLabel
          Left = 24
          Top = 3
          Width = 61
          Height = 13
          Caption = '  &Device:  '
          FocusControl = edTarget
        end
        object SpeedButton1: TSpeedButton
          Left = 447
          Top = 16
          Width = 70
          Height = 22
          Action = acSearch
          Anchors = [akTop, akRight]
          Caption = 'Searc&h'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label3: TLabel
          Left = 32
          Top = 144
          Width = 45
          Height = 13
          Caption = 'Selected:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblDevice: TLabel
          Left = 96
          Top = 144
          Width = 337
          Height = 33
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '    '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object SpeedButton2: TSpeedButton
          Left = 336
          Top = 16
          Width = 65
          Height = 22
          Caption = 'More'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
          OnClick = SpeedButton2Click
        end
        object edTarget: TEdit
          Left = 96
          Top = 16
          Width = 417
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = edTargetChange
          OnKeyUp = edTargetKeyUp
        end
        object lvDevices: TListView
          Left = 96
          Top = 40
          Width = 421
          Height = 97
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              Caption = 'ID'
              Width = 30
            end
            item
              Caption = 'Name'
              Width = 150
            end
            item
              Caption = 'Location'
              Width = 120
            end
            item
              Caption = 'Width'
            end
            item
              Caption = 'Length'
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = lvDevicesChange
        end
      end
      object Panel2: TPanel
        Left = 2
        Top = 154
        Width = 523
        Height = 91
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 5
        DesignSize = (
          523
          91)
        object Bevel4: TBevel
          Left = 13
          Top = 16
          Width = 506
          Height = 9
          Anchors = [akLeft, akTop, akRight]
          Shape = bsTopLine
        end
        object Label6: TLabel
          Left = 312
          Top = 8
          Width = 120
          Height = 13
          Caption = '  &Queue To Run At:  '
          FocusControl = dtpPrintDate
        end
        object Label2: TLabel
          Left = 24
          Top = 9
          Width = 89
          Height = 13
          Caption = '  Date Range:  '
        end
        object lblStart: TLabel
          Left = 32
          Top = 36
          Width = 51
          Height = 13
          Caption = '&Start Date:'
          FocusControl = dtpFromDate
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblEnd: TLabel
          Left = 32
          Top = 59
          Width = 48
          Height = 13
          Caption = '&End Date:'
          FocusControl = dtpToDate
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Bevel2: TBevel
          Left = 304
          Top = 17
          Width = 9
          Height = 65
          Shape = bsLeftLine
        end
        object dtpPrintDate: TDateTimePicker
          Left = 323
          Top = 33
          Width = 97
          Height = 21
          Anchors = [akTop, akRight]
          CalAlignment = dtaLeft
          Date = 37245.480350787
          Time = 37245.480350787
          DateFormat = dfShort
          DateMode = dmComboBox
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Kind = dtkDate
          ParseInput = False
          ParentFont = False
          TabOrder = 4
          OnChange = acPrintDateChangedExecute
        end
        object dtpPrintTime: TDateTimePicker
          Left = 423
          Top = 33
          Width = 96
          Height = 21
          Anchors = [akTop, akRight]
          CalAlignment = dtaLeft
          Date = 37308.578132338
          Time = 37308.578132338
          DateFormat = dfShort
          DateMode = dmComboBox
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Kind = dtkTime
          ParseInput = False
          ParentFont = False
          TabOrder = 5
          OnChange = acPrintDateChangedExecute
        end
        object dtpFromDate: TDateTimePicker
          Left = 98
          Top = 33
          Width = 97
          Height = 21
          CalAlignment = dtaLeft
          Date = 37245.4450408102
          Time = 37245.4450408102
          DateFormat = dfShort
          DateMode = dmComboBox
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Kind = dtkDate
          ParseInput = False
          ParentFont = False
          TabOrder = 0
          OnChange = acStartDateChanged
        end
        object dtpToDate: TDateTimePicker
          Left = 98
          Top = 56
          Width = 97
          Height = 21
          CalAlignment = dtaLeft
          Date = 37245.4457426042
          Time = 37245.4457426042
          DateFormat = dfShort
          DateMode = dmComboBox
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Kind = dtkDate
          ParseInput = False
          ParentFont = False
          TabOrder = 2
          OnChange = acStopDateChangedExecute
        end
        object dtpFromTime: TDateTimePicker
          Left = 198
          Top = 33
          Width = 96
          Height = 21
          CalAlignment = dtaLeft
          Date = 37308.578132338
          Time = 37308.578132338
          DateFormat = dfShort
          DateMode = dmComboBox
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Kind = dtkTime
          ParseInput = False
          ParentFont = False
          TabOrder = 1
          OnChange = acStartTimeChangedExecute
        end
        object dtpToTime: TDateTimePicker
          Left = 198
          Top = 56
          Width = 96
          Height = 21
          CalAlignment = dtaLeft
          Date = 37308.578132338
          Time = 37308.578132338
          DateFormat = dfShort
          DateMode = dmComboBox
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Kind = dtkTime
          ParseInput = False
          ParentFont = False
          TabOrder = 3
          OnChange = acEndTimeChangedExecute
        end
      end
    end
  end
  object ActionList1: TActionList
    Left = 277
    Top = 29
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
    object acSearch: TAction
      Caption = '&Search'
      OnExecute = acSearchExecute
    end
  end
  object tmDevice: TTimer
    Enabled = False
    OnTimer = tmDeviceTimer
    Left = 64
    Top = 288
  end
end
