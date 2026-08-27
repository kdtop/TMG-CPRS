object fraGMV_PtLookup: TfraGMV_PtLookup
  Left = 0
  Top = 0
  Width = 448
  Height = 714
  Color = clBtnFace
  ParentColor = False
  TabOrder = 0
  object Panel1: TPanel
    Left = 443
    Top = 0
    Width = 5
    Height = 714
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 714
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object rgPtList: TRadioGroup
      Left = 0
      Top = 0
      Width = 443
      Height = 50
      Align = alTop
      Caption = 'Patient Group List:'
      Columns = 5
      Items.Strings = (
        '&Unit'
        '&Ward'
        '&Team'
        '&Clinic'
        '&All')
      TabOrder = 0
      OnClick = SelectListType
    end
    object gbxListBox: TGroupBox
      Left = 0
      Top = 50
      Width = 443
      Height = 55
      Align = alTop
      TabOrder = 1
      DesignSize = (
        443
        55)
      object lblApptDate: TLabel
        Left = 212
        Top = 16
        Width = 37
        Height = 26
        Caption = 'Clinic &Date(s):'
        Visible = False
        WordWrap = True
      end
      object cbxApptDate: TComboBox
        Left = 256
        Top = 20
        Width = 182
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 1
        Visible = False
        Items.Strings = (
          'Today'
          'Tomorrow'
          'Yesterday'
          'Past Week'
          'Past Month')
      end
      object edPattern: TEdit
        Left = 16
        Top = 20
        Width = 185
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 30
        ParentFont = False
        TabOrder = 0
        OnChange = edPatternChange
        OnClick = edPatternDblClick
        OnDblClick = edPatternDblClick
        OnEnter = edPatternEnter
        OnExit = edPatternExit
        OnKeyDown = edPatternKeyDown
      end
    end
    object gbxPtList: TGroupBox
      Left = 0
      Top = 248
      Width = 443
      Height = 466
      Align = alClient
      Caption = 'Patient &List:'
      TabOrder = 2
      object Panel3: TPanel
        Left = 2
        Top = 15
        Width = 439
        Height = 449
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 6
        Caption = 'Panel1'
        TabOrder = 0
        object lvPatients: TListView
          Left = 6
          Top = 6
          Width = 427
          Height = 437
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
          OnChange = lvPatientsChange
          OnClick = lvPatientsClick
          OnDblClick = lvPatientsDblClick
          OnEnter = lvPatientsEnter
          OnExit = lvPatientsExit
          OnKeyPress = lvPatientsKeyPress
          OnKeyUp = lvPatientsKeyUp
        end
      end
    end
    object pnDropList: TPanel
      Left = 0
      Top = 105
      Width = 443
      Height = 143
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      Visible = False
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 443
        Height = 143
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel6'
        TabOrder = 0
        object lbDropDown: TListBox
          Left = 8
          Top = 0
          Width = 427
          Height = 136
          Hint = 'To select entry double click it or press <Enter> '
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Sorted = True
          TabOrder = 0
          OnClick = lbDropDownClick
          OnDblClick = acSearchPatient2Execute
          OnEnter = lbDropDownEnter
          OnExit = lbDropDownExit
          OnKeyDown = edPatternKeyDown
        end
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 8
          Height = 136
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object Bevel1: TBevel
            Left = 0
            Top = 0
            Width = 50
            Height = 136
            Align = alLeft
            Shape = bsLeftLine
          end
        end
        object Panel8: TPanel
          Left = 435
          Top = 0
          Width = 8
          Height = 136
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 2
          object Bevel2: TBevel
            Left = -42
            Top = 0
            Width = 50
            Height = 136
            Align = alRight
            Shape = bsRightLine
          end
        end
        object Panel9: TPanel
          Left = 0
          Top = 136
          Width = 443
          Height = 7
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 3
        end
      end
    end
  end
  object tmrLookup: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrLookupTimer
    Left = 320
  end
  object ActionList1: TActionList
    Left = 16
    Top = 185
    object acSearchPatient2: TAction
      Caption = 'acSearchPatient2'
      OnExecute = acSearchPatient2Execute
    end
    object acPatientsListChanged: TAction
      Caption = 'acPatientsListChanged'
    end
  end
end
