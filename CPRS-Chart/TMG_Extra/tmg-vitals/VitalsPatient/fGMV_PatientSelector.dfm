object frmGMV_PatientSelector: TfrmGMV_PatientSelector
  Left = 386
  Top = 128
  Width = 407
  Height = 768
  Caption = 'PatientSelector'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlStatus: TPanel
    Left = 0
    Top = 702
    Width = 399
    Height = 39
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      399
      39)
    object lblSelected: TLabel
      Left = 16
      Top = 16
      Width = 42
      Height = 13
      Caption = 'Selected'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Button1: TButton
      Left = 231
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Select'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 311
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pcMain: TPageControl
    Left = 0
    Top = 55
    Width = 399
    Height = 377
    ActivePage = tsAll
    Align = alClient
    Constraints.MinHeight = 100
    Style = tsButtons
    TabIndex = 4
    TabOrder = 1
    TabStop = False
    OnChange = pcMainChange
    OnEnter = cmbUnitEnter
    OnExit = cmbUnitExit
    object tsUnit: TTabSheet
      Caption = '   &Unit     '
      object Splitter1: TSplitter
        Left = 0
        Top = 165
        Width = 391
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clSilver
        ParentColor = False
      end
      object Panel3: TPanel
        Left = 0
        Top = 169
        Width = 391
        Height = 177
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 1
        object lvUnitPatients: TListView
          Left = 2
          Top = 25
          Width = 387
          Height = 90
          Hint = 
            'To select a Patient, highlight the name and press "Enter" or  do' +
            'uble click the patient name.'
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 100
            end
            item
              Caption = 'SSN'
              MinWidth = 40
              Width = 80
            end
            item
              Caption = 'DOB'
              MinWidth = 40
              Width = 65
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          SortType = stText
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvUnitPatientsChange
          OnClick = lvUnitPatientsClick
          OnDblClick = lvUnitPatientsDblClick
          OnEnter = lvUnitPatientsEnter
          OnExit = lvUnitPatientsExit
          OnKeyPress = lvUnitPatientsKeyPress
        end
        object Panel16: TPanel
          Left = 2
          Top = 115
          Width = 387
          Height = 60
          Align = alBottom
          BevelOuter = bvLowered
          Color = clInfoBk
          TabOrder = 1
          Visible = False
        end
        object Panel11: TPanel
          Left = 2
          Top = 2
          Width = 387
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Bevel2: TBevel
            Left = 0
            Top = 11
            Width = 387
            Height = 12
            Align = alBottom
            Shape = bsTopLine
          end
          object Label14: TLabel
            Left = 8
            Top = 4
            Width = 52
            Height = 13
            Caption = 'Patient L&ist'
            FocusControl = lvUnitPatients
          end
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 391
        Height = 165
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel17: TPanel
          Left = 0
          Top = 23
          Width = 391
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            391
            23)
          object cmbUnit: TComboBox
            Left = 1
            Top = 1
            Width = 390
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            TabOrder = 0
            OnChange = cmbUnitChange
            OnEnter = cmbUnitEnter
            OnExit = cmbUnitExit
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = lvUnitPatientsKeyPress
          end
        end
        object lbUnits: TListBox
          Left = 0
          Top = 46
          Width = 391
          Height = 119
          Align = alClient
          ItemHeight = 13
          TabOrder = 1
          OnClick = lbUnitsClick
          OnDblClick = lbUnitsDblClick
          OnEnter = lbUnitsEnter
          OnExit = lbUnitsExit
          OnKeyDown = lbUnitsKeyDown
        end
        object Panel18: TPanel
          Left = 0
          Top = 0
          Width = 391
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Bevel7: TBevel
            Left = 0
            Top = 11
            Width = 391
            Height = 12
            Align = alBottom
            Shape = bsTopLine
          end
          object Label15: TLabel
            Left = 8
            Top = 4
            Width = 91
            Height = 13
            Caption = 'Select Nursing &Unit'
          end
        end
      end
    end
    object tsWard: TTabSheet
      Caption = '  &Ward  '
      ImageIndex = 3
      object Splitter2: TSplitter
        Left = 0
        Top = 165
        Width = 391
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clSilver
        ParentColor = False
      end
      object Panel1: TPanel
        Left = 0
        Top = 169
        Width = 391
        Height = 177
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 2
        Caption = 'Panel1'
        TabOrder = 1
        object lvWardPatients: TListView
          Left = 2
          Top = 25
          Width = 387
          Height = 106
          Hint = 
            'To select a Patient, highlight the name and press "Enter" or  do' +
            'uble click the patient name.'
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 100
            end
            item
              Caption = 'SSN'
              MinWidth = 40
              Width = 80
            end
            item
              Caption = 'DOB'
              MinWidth = 40
              Width = 65
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          SortType = stText
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvUnitPatientsChange
          OnClick = lvUnitPatientsClick
          OnDblClick = lvUnitPatientsDblClick
          OnEnter = lvUnitPatientsEnter
          OnExit = lvUnitPatientsExit
          OnKeyPress = lvUnitPatientsKeyPress
        end
        object Panel15: TPanel
          Left = 2
          Top = 131
          Width = 387
          Height = 44
          Align = alBottom
          BevelOuter = bvLowered
          Color = clInfoBk
          TabOrder = 1
          Visible = False
        end
        object Panel19: TPanel
          Left = 2
          Top = 2
          Width = 387
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Bevel8: TBevel
            Left = 0
            Top = 11
            Width = 387
            Height = 12
            Align = alBottom
            Shape = bsTopLine
          end
          object Label16: TLabel
            Left = 8
            Top = 4
            Width = 52
            Height = 13
            Caption = 'Patient L&ist'
            FocusControl = lvWardPatients
          end
        end
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 391
        Height = 165
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel20: TPanel
          Left = 0
          Top = 23
          Width = 391
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            391
            23)
          object cmbWard: TComboBox
            Left = 1
            Top = 1
            Width = 390
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            TabOrder = 0
            OnChange = cmbUnitChange
            OnEnter = cmbUnitEnter
            OnExit = cmbUnitExit
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = lvUnitPatientsKeyPress
          end
        end
        object lbWards: TListBox
          Left = 0
          Top = 46
          Width = 391
          Height = 119
          Align = alClient
          ItemHeight = 13
          TabOrder = 1
          OnClick = lbUnitsClick
          OnDblClick = lbUnitsDblClick
          OnEnter = lbUnitsEnter
          OnExit = lbUnitsExit
          OnKeyDown = lbUnitsKeyDown
        end
        object Panel21: TPanel
          Left = 0
          Top = 0
          Width = 391
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Bevel9: TBevel
            Left = 0
            Top = 11
            Width = 391
            Height = 12
            Align = alBottom
            Shape = bsTopLine
          end
          object Label17: TLabel
            Left = 8
            Top = 4
            Width = 59
            Height = 13
            Caption = 'Select Ward'
          end
        end
      end
    end
    object tsTeam: TTabSheet
      Caption = '&Team'
      ImageIndex = 1
      object Splitter3: TSplitter
        Left = 0
        Top = 101
        Width = 391
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clSilver
        ParentColor = False
      end
      object Panel2: TPanel
        Left = 0
        Top = 105
        Width = 391
        Height = 241
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 2
        Caption = 'Panel1'
        TabOrder = 1
        object lvTeampatients: TListView
          Left = 2
          Top = 25
          Width = 387
          Height = 154
          Hint = 
            'To select a Patient, highlight the name and press "Enter" or  do' +
            'uble click the patient name.'
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 100
            end
            item
              Caption = 'SSN'
              MinWidth = 40
              Width = 80
            end
            item
              Caption = 'DOB'
              MinWidth = 40
              Width = 65
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          SortType = stText
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvUnitPatientsChange
          OnClick = lvUnitPatientsClick
          OnDblClick = lvUnitPatientsDblClick
          OnEnter = lvUnitPatientsEnter
          OnExit = lvUnitPatientsExit
          OnKeyPress = lvUnitPatientsKeyPress
        end
        object Panel14: TPanel
          Left = 2
          Top = 179
          Width = 387
          Height = 60
          Align = alBottom
          BevelOuter = bvLowered
          Color = clInfoBk
          TabOrder = 1
          Visible = False
        end
        object Panel23: TPanel
          Left = 2
          Top = 2
          Width = 387
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Bevel11: TBevel
            Left = 0
            Top = 11
            Width = 387
            Height = 12
            Align = alBottom
            Shape = bsTopLine
          end
          object Label19: TLabel
            Left = 8
            Top = 4
            Width = 52
            Height = 13
            Caption = 'Patient L&ist'
            FocusControl = lvTeampatients
          end
        end
      end
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 391
        Height = 101
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel24: TPanel
          Left = 0
          Top = 23
          Width = 391
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            391
            23)
          object cmbTeam: TComboBox
            Left = 1
            Top = 1
            Width = 390
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            TabOrder = 0
            OnChange = cmbUnitChange
            OnEnter = cmbUnitEnter
            OnExit = cmbUnitExit
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = lvUnitPatientsKeyPress
          end
        end
        object lbTeams: TListBox
          Left = 0
          Top = 46
          Width = 391
          Height = 55
          Align = alClient
          ItemHeight = 13
          TabOrder = 1
          OnClick = lbUnitsClick
          OnDblClick = lbUnitsDblClick
          OnEnter = lbUnitsEnter
          OnExit = lbUnitsExit
          OnKeyDown = cmbUnitKeyDown
        end
        object Panel25: TPanel
          Left = 0
          Top = 0
          Width = 391
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Bevel12: TBevel
            Left = 0
            Top = 11
            Width = 391
            Height = 12
            Align = alBottom
            Shape = bsTopLine
          end
          object Label20: TLabel
            Left = 8
            Top = 4
            Width = 60
            Height = 13
            Caption = 'Select Team'
          end
        end
      end
    end
    object tsClinic: TTabSheet
      Caption = '&Clinic'
      ImageIndex = 2
      object Splitter4: TSplitter
        Left = 0
        Top = 121
        Width = 391
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clSilver
        ParentColor = False
      end
      object Panel4: TPanel
        Left = 0
        Top = 125
        Width = 391
        Height = 221
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 2
        Caption = 'Panel1'
        TabOrder = 1
        object lvClinicPatients: TListView
          Left = 2
          Top = 25
          Width = 387
          Height = 142
          Hint = 
            'To select a Patient, highlight the name and press "Enter" or  do' +
            'uble click the patient name.'
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 100
            end
            item
              Caption = 'SSN'
              MinWidth = 40
              Width = 80
            end
            item
              Caption = 'DOB'
              MinWidth = 40
              Width = 65
            end
            item
              Caption = 'Appt Dt'
              Width = 85
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          SortType = stText
          TabOrder = 0
          ViewStyle = vsReport
          OnChange = lvUnitPatientsChange
          OnClick = lvUnitPatientsClick
          OnDblClick = lvUnitPatientsDblClick
          OnEnter = lvUnitPatientsEnter
          OnExit = lvUnitPatientsExit
          OnKeyPress = lvUnitPatientsKeyPress
        end
        object Panel13: TPanel
          Left = 2
          Top = 167
          Width = 387
          Height = 52
          Align = alBottom
          BevelOuter = bvLowered
          Color = clInfoBk
          TabOrder = 1
          Visible = False
          OnClick = lvUnitPatientsClick
        end
        object Panel26: TPanel
          Left = 2
          Top = 2
          Width = 387
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object Bevel13: TBevel
            Left = 0
            Top = 11
            Width = 387
            Height = 12
            Align = alBottom
            Shape = bsTopLine
          end
          object Label21: TLabel
            Left = 8
            Top = 4
            Width = 52
            Height = 13
            Caption = 'Patient L&ist'
            FocusControl = lvClinicPatients
          end
        end
      end
      object Panel10: TPanel
        Left = 0
        Top = 0
        Width = 391
        Height = 121
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel27: TPanel
          Left = 0
          Top = 23
          Width = 391
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            391
            23)
          object cmbClinic: TComboBox
            Left = 1
            Top = 1
            Width = 213
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            TabOrder = 0
            OnChange = cmbUnitChange
            OnEnter = cmbUnitEnter
            OnExit = cmbUnitExit
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = lvUnitPatientsKeyPress
          end
          object cmbPeriod: TComboBox
            Left = 221
            Top = 1
            Width = 170
            Height = 21
            Anchors = [akTop, akRight]
            ItemHeight = 13
            TabOrder = 1
            OnEnter = cmbPeriodEnter
            OnExit = cmbPeriodExit
            OnKeyDown = lbUnitsKeyDown
            Items.Strings = (
              'Today'
              'Tomorrow'
              'Yesterday'
              'Past Week'
              'Past Month')
          end
        end
        object lbClinics: TListBox
          Left = 0
          Top = 46
          Width = 391
          Height = 75
          Align = alClient
          ItemHeight = 13
          TabOrder = 1
          OnClick = lbUnitsClick
          OnDblClick = lbUnitsDblClick
          OnEnter = lbUnitsEnter
          OnExit = lbUnitsExit
          OnKeyDown = lbUnitsKeyDown
        end
        object Panel28: TPanel
          Left = 0
          Top = 0
          Width = 391
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          DesignSize = (
            391
            23)
          object Bevel14: TBevel
            Left = 0
            Top = 11
            Width = 391
            Height = 12
            Align = alBottom
            Shape = bsTopLine
          end
          object Label22: TLabel
            Left = 8
            Top = 4
            Width = 58
            Height = 13
            Caption = 'Select Clinic'
          end
          object Label23: TLabel
            Left = 226
            Top = 4
            Width = 62
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Clinic Date(s)'
          end
        end
      end
    end
    object tsAll: TTabSheet
      Caption = '   &All  '
      ImageIndex = 4
      object Panel5: TPanel
        Left = 0
        Top = 45
        Width = 391
        Height = 301
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 1
        Caption = 'Panel1'
        TabOrder = 1
        object lvAllPatients: TListView
          Left = 1
          Top = 1
          Width = 389
          Height = 200
          Hint = 
            'To select a Patient, highlight the name and press "Enter" or  do' +
            'uble click the patient name.'
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 100
            end
            item
              Caption = 'SSN'
              MinWidth = 40
              Width = 80
            end
            item
              Caption = 'DOB'
              MinWidth = 40
              Width = 65
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          SortType = stText
          TabOrder = 0
          TabStop = False
          ViewStyle = vsReport
          OnChange = lvUnitPatientsChange
          OnClick = lvUnitPatientsClick
          OnDblClick = lvUnitPatientsDblClick
          OnEnter = lvUnitPatientsEnter
          OnExit = lvUnitPatientsExit
          OnKeyPress = lvAllPatientsKeyPress
        end
        object Panel12: TPanel
          Left = 1
          Top = 201
          Width = 389
          Height = 99
          Align = alBottom
          BevelOuter = bvLowered
          Color = clInfoBk
          TabOrder = 1
          Visible = False
        end
      end
      object Panel22: TPanel
        Left = 0
        Top = 0
        Width = 391
        Height = 23
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object Bevel10: TBevel
          Left = 0
          Top = 11
          Width = 391
          Height = 12
          Align = alBottom
          Shape = bsTopLine
        end
        object Label18: TLabel
          Left = 8
          Top = 4
          Width = 187
          Height = 13
          Caption = 'Patient Name (Last, First or Last 4 SSN)'
        end
      end
      object Panel9: TPanel
        Left = 0
        Top = 23
        Width = 391
        Height = 22
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          391
          22)
        object cmbAll: TComboBox
          Left = 1
          Top = 1
          Width = 390
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
          OnChange = cmbAllChange
          OnEnter = cmbUnitEnter
          OnExit = cmbUnitExit
          OnKeyPress = cmbAllKeyPress
        end
      end
    end
  end
  object pnlTitle: TPanel
    Left = 0
    Top = 49
    Width = 399
    Height = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      399
      6)
    object Bevel1: TBevel
      Left = 4
      Top = 5
      Width = 388
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      Visible = False
    end
    object Label2: TLabel
      Left = 12
      Top = -1
      Width = 89
      Height = 13
      Caption = 'Patient Groups List'
      Visible = False
    end
  end
  object pnlInfo: TPanel
    Left = 0
    Top = 432
    Width = 399
    Height = 270
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    DesignSize = (
      399
      270)
    object Label3: TLabel
      Left = 16
      Top = 8
      Width = 68
      Height = 13
      Caption = 'Search Target'
    end
    object Label4: TLabel
      Left = 32
      Top = 42
      Width = 50
      Height = 13
      Caption = 'Name / ID'
    end
    object lblTarget: TLabel
      Left = 120
      Top = 8
      Width = 41
      Height = 13
      Caption = 'lblTarget'
    end
    object lblPatientName: TLabel
      Left = 120
      Top = 42
      Width = 45
      Height = 13
      Caption = 'lblPName'
    end
    object Label6: TLabel
      Left = 32
      Top = 90
      Width = 50
      Height = 13
      Caption = 'Name / ID'
    end
    object lblLocationName: TLabel
      Left = 120
      Top = 90
      Width = 44
      Height = 13
      Caption = 'lblLName'
    end
    object Label10: TLabel
      Left = 16
      Top = 26
      Width = 67
      Height = 13
      Caption = 'Current Paient'
    end
    object Bevel3: TBevel
      Left = 104
      Top = 34
      Width = 282
      Height = 9
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label11: TLabel
      Left = 16
      Top = 74
      Width = 78
      Height = 13
      Caption = 'Current Location'
    end
    object Bevel4: TBevel
      Left = 104
      Top = 82
      Width = 282
      Height = 9
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label5: TLabel
      Left = 16
      Top = 106
      Width = 75
      Height = 13
      Caption = 'Selected Paient'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 32
      Top = 122
      Width = 50
      Height = 13
      Caption = 'Name / ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 32
      Top = 138
      Width = 63
      Height = 13
      Caption = 'Location / ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Bevel5: TBevel
      Left = 104
      Top = 114
      Width = 282
      Height = 9
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object lblSelectedPatientNameID: TLabel
      Left = 120
      Top = 122
      Width = 54
      Height = 13
      Caption = 'lblPName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSelectedPatientLocationNameID: TLabel
      Left = 120
      Top = 138
      Width = 61
      Height = 13
      Caption = 'lblPLName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 32
      Top = 58
      Width = 63
      Height = 13
      Caption = 'Location / ID'
    end
    object lblPatientLocationID: TLabel
      Left = 120
      Top = 58
      Width = 45
      Height = 13
      Caption = 'lblPName'
    end
    object Label12: TLabel
      Left = 16
      Top = 154
      Width = 52
      Height = 13
      Caption = 'Patient List'
    end
    object Bevel6: TBevel
      Left = 104
      Top = 162
      Width = 282
      Height = 9
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object Label13: TLabel
      Left = 16
      Top = 248
      Width = 77
      Height = 13
      Caption = 'Selection Status'
    end
    object lblSelectStatus: TLabel
      Left = 120
      Top = 248
      Width = 70
      Height = 13
      Caption = 'lblSelectStatus'
    end
    object mmList: TMemo
      Left = 8
      Top = 176
      Width = 378
      Height = 65
      TabStop = False
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clBtnFace
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object pnlSelection: TPanel
    Left = 0
    Top = 0
    Width = 399
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    Visible = False
    DesignSize = (
      399
      49)
    object pnlPtInfo: TPanel
      Left = 2
      Top = 0
      Width = 394
      Height = 45
      Hint = 'Selected patient demographics.'
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = 13365758
      TabOrder = 0
      OnMouseDown = pnlPtInfoMouseDown
      OnMouseUp = pnlPtInfoMouseUp
      object lblSelectedName: TLabel
        Left = 7
        Top = 5
        Width = 115
        Height = 13
        Caption = 'No Patient Selected'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblPatientInfo: TLabel
        Left = 7
        Top = 21
        Width = 60
        Height = 13
        Caption = '000-00-0000'
      end
    end
  end
  object tmSearch: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmSearchTimer
    Left = 152
    Top = 8
  end
end
