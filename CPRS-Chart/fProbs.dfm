inherited frmProblems: TfrmProblems
  Left = 303
  Top = 268
  HelpContext = 2000
  Caption = 'Problems List Page'
  ClientHeight = 415
  ClientWidth = 631
  HelpFile = 'overvw'
  Menu = mnuProbs
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnMouseMove = FormMouseMove
  OnShow = FormShow
  ExplicitWidth = 639
  ExplicitHeight = 469
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 410
    Width = 631
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Constraints.MinHeight = 5
    ExplicitTop = 350
    ExplicitWidth = 631
  end
  inherited sptHorz: TSplitter
    Left = 159
    Width = 2
    Height = 410
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    OnMoved = sptHorzMoved
    ExplicitLeft = 159
    ExplicitWidth = 2
    ExplicitHeight = 350
  end
  inherited pnlLeft: TPanel
    Width = 159
    Height = 410
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Constraints.MinWidth = 37
    ExplicitWidth = 159
    ExplicitHeight = 410
    object pnlButtons: TPanel
      Left = 0
      Top = 364
      Width = 159
      Height = 46
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      BevelOuter = bvNone
      Constraints.MinHeight = 46
      TabOrder = 3
      object bbOtherProb: TORAlignButton
        Left = 0
        Top = 2
        Width = 159
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        Caption = 'Other Problem'
        TabOrder = 0
        OnClick = bbOtherProbClick
        OnExit = bbNewProbExit
        OnMouseMove = FormMouseMove
      end
      object bbCancel: TORAlignButton
        Left = 0
        Top = 24
        Width = 159
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = bbCancelClick
        OnExit = bbNewProbExit
        OnMouseMove = FormMouseMove
      end
    end
    object pnlView: TPanel
      Left = 0
      Top = 0
      Width = 159
      Height = 364
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lblView: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 159
        Height = 19
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'View options'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object lstView: TORListBox
        Left = 0
        Top = 19
        Width = 159
        Height = 97
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        ExtendedSelect = False
        ItemHeight = 13
        Items.Strings = (
          'A^Active'
          'I^Inactive'
          'B^Both active and inactive'
          'R^Removed')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = lstViewClick
        OnExit = lstViewExit
        OnMouseMove = FormMouseMove
        Caption = 'View options'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object bbNewProb: TORAlignButton
        Tag = 100
        Left = 0
        Top = 116
        Width = 159
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'New problem'
        TabOrder = 1
        OnClick = lstProbActsClick
        OnExit = bbNewProbExit
        OnMouseMove = FormMouseMove
      end
    end
    object pnlProbEnt: TPanel
      Left = 0
      Top = 0
      Width = 159
      Height = 364
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      OnResize = pnlProbEntResize
      object lblProbEnt: TLabel
        Left = 0
        Top = 330
        Width = 159
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        AutoSize = False
        Caption = 'Enter new problem:'
        ExplicitTop = 270
      end
      object edProbEnt: TCaptionEdit
        Left = 0
        Top = 343
        Width = 159
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        TabOrder = 0
        OnExit = lstViewExit
        OnKeyPress = edProbEntKeyPress
        Caption = 'Enter new problem'
      end
    end
    object pnlProbList: TORAutoPanel
      Left = 0
      Top = 0
      Width = 159
      Height = 364
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinHeight = 90
      TabOrder = 0
      object sptProbPanel: TSplitter
        Left = 0
        Top = 157
        Width = 159
        Height = 3
        Cursor = crVSplit
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
      end
      object pnlProbCats: TPanel
        Left = 0
        Top = 0
        Width = 159
        Height = 157
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblProbCats: TLabel
          Left = 0
          Top = 0
          Width = 159
          Height = 13
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          AutoSize = False
          Caption = 'Problem categories'
        end
        object lstCatPick: TORListBox
          Left = 0
          Top = 13
          Width = 159
          Height = 144
          Hint = 'Select problem category'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          TabStop = False
          Align = alClient
          ExtendedSelect = False
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = lstCatPickClick
          OnExit = lstViewExit
          OnMouseMove = FormMouseMove
          Caption = 'Problem categories'
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
        end
      end
      object pnlProbs: TPanel
        Left = 0
        Top = 160
        Width = 159
        Height = 204
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object lblProblems: TLabel
          Left = 0
          Top = 0
          Width = 159
          Height = 13
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          AutoSize = False
          Caption = 'Problems'
          Constraints.MaxHeight = 16
          Constraints.MinHeight = 13
        end
        object lstProbPick: TORListBox
          Left = 0
          Top = 13
          Width = 159
          Height = 191
          Hint = 'Select problem to add'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          Ctl3D = False
          ExtendedSelect = False
          ItemHeight = 13
          ParentCtl3D = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = lstProbPickClick
          OnDblClick = lstProbPickDblClick
          Caption = 'Problems'
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2,3'
        end
      end
    end
  end
  inherited pnlRight: TPanel
    Left = 161
    Width = 470
    Height = 410
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Constraints.MinWidth = 30
    OnExit = pnlRightExit
    OnResize = pnlRightResize
    ExplicitLeft = 161
    ExplicitWidth = 470
    ExplicitHeight = 410
    object lblProbList: TOROffsetLabel
      Left = 0
      Top = 0
      Width = 470
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Active Problems List'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object pnlProbDlg: TPanel
      Left = 0
      Top = 36
      Width = 470
      Height = 374
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      TabOrder = 0
      Visible = False
      OnMouseMove = FormMouseMove
    end
    object wgProbData: TCaptionListBox
      Left = 0
      Top = 36
      Width = 470
      Height = 374
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawVariable
      Align = alClient
      Color = clCream
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      PopupMenu = popProb
      ShowHint = True
      TabOrder = 1
      OnClick = wgProbDataClick
      OnDblClick = wgProbDataDblClick
      OnDrawItem = wgProbDataDrawItem
      OnMeasureItem = wgProbDataMeasureItem
      OnMouseMove = FormMouseMove
      OnMouseUp = wgProbDataMouseUp
      Caption = 'Active Problems List'
    end
    object HeaderControl: THeaderControl
      Left = 0
      Top = 19
      Width = 470
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Sections = <
        item
          ImageIndex = -1
          Text = 'Column 0'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Stat/Ver'
          Width = 65
        end
        item
          ImageIndex = -1
          MinWidth = 20
          Text = 'Description'
          Width = 65
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Onset Date'
          Width = 65
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Last Updated'
          Width = 80
        end
        item
          ImageIndex = -1
          Text = 'Column 5'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Location'
          Width = 65
        end
        item
          ImageIndex = -1
          Text = 'Provider'
          Width = 65
        end
        item
          ImageIndex = -1
          Text = 'Service'
          Width = 65
        end
        item
          ImageIndex = -1
          Text = 'Column 9'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Column 10'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Column 11'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Column12'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Column 13'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Column 14'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Inactive Flag'
          Width = 0
        end>
      OnSectionClick = HeaderControlSectionClick
      OnSectionResize = HeaderControlSectionResize
      OnMouseDown = HeaderControlMouseDown
      OnMouseUp = HeaderControlMouseUp
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = bbOtherProb'
        'Status = stsDefault')
      (
        'Component = bbCancel'
        'Status = stsDefault')
      (
        'Component = pnlView'
        'Status = stsDefault')
      (
        'Component = lstView'
        'Status = stsDefault')
      (
        'Component = bbNewProb'
        'Status = stsDefault')
      (
        'Component = pnlProbEnt'
        'Status = stsDefault')
      (
        'Component = edProbEnt'
        'Status = stsDefault')
      (
        'Component = pnlProbList'
        'Status = stsDefault')
      (
        'Component = pnlProbCats'
        'Status = stsDefault')
      (
        'Component = lstCatPick'
        'Status = stsDefault')
      (
        'Component = pnlProbs'
        'Status = stsDefault')
      (
        'Component = lstProbPick'
        'Status = stsDefault')
      (
        'Component = pnlProbDlg'
        'Status = stsDefault')
      (
        'Component = wgProbData'
        'Status = stsDefault')
      (
        'Component = HeaderControl'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmProblems'
        'Status = stsDefault'))
  end
  object popProb: TPopupMenu
    Left = 282
    Top = 313
    object popChange: TMenuItem
      Tag = 400
      Caption = '&Change...'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object popInactivate: TMenuItem
      Tag = 200
      Caption = '&Inactivate'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object popVerify: TMenuItem
      Tag = 250
      Caption = '&Verify...'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object N36: TMenuItem
      Caption = '-'
      Enabled = False
    end
    object popAnnotate: TMenuItem
      Tag = 600
      Caption = '&Annotate...'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object N37: TMenuItem
      Caption = '-'
      Enabled = False
      Visible = False
    end
    object popRemove: TMenuItem
      Tag = 500
      Caption = '&Remove...'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object popRestore: TMenuItem
      Tag = 550
      Caption = 'Re&store'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object popViewDetails: TMenuItem
      Tag = 300
      Caption = 'View Details'
      OnClick = lstProbActsClick
    end
    object mnuOptimizeFields: TMenuItem
      Caption = 'Adjust Column Size'
      Visible = False
      OnClick = mnuOptimizeFieldsClick
    end
  end
  object mnuProbs: TMainMenu
    Left = 243
    Top = 313
    object mnuView: TMenuItem
      Caption = '&View'
      GroupIndex = 3
      object mnuViewChart: TMenuItem
        Caption = 'Chart &Tab'
        object mnuChartCover: TMenuItem
          Tag = 1
          Caption = 'Cover &Sheet'
          ShortCut = 16467
          OnClick = mnuChartTabClick
        end
        object mnuChartProbs: TMenuItem
          Tag = 2
          Caption = '&Problem List'
          ShortCut = 16464
          OnClick = mnuChartTabClick
        end
        object mnuChartMeds: TMenuItem
          Tag = 3
          Caption = '&Medications'
          ShortCut = 16461
          OnClick = mnuChartTabClick
        end
        object mnuChartOrders: TMenuItem
          Tag = 4
          Caption = '&Orders'
          ShortCut = 16463
          OnClick = mnuChartTabClick
        end
        object mnuChartNotes: TMenuItem
          Tag = 6
          Caption = 'Progress &Notes'
          ShortCut = 16462
          OnClick = mnuChartTabClick
        end
        object mnuChartCslts: TMenuItem
          Tag = 7
          Caption = 'Consul&ts'
          ShortCut = 16468
          OnClick = mnuChartTabClick
        end
        object mnuChartSurgery: TMenuItem
          Tag = 11
          Caption = 'S&urgery'
          ShortCut = 16469
          OnClick = mnuChartTabClick
        end
        object mnuChartDCSumm: TMenuItem
          Tag = 8
          Caption = '&Discharge Summaries'
          ShortCut = 16452
          OnClick = mnuChartTabClick
        end
        object mnuChartLabs: TMenuItem
          Tag = 9
          Caption = '&Laboratory'
          ShortCut = 16460
          OnClick = mnuChartTabClick
        end
        object mnuChartReports: TMenuItem
          Tag = 10
          Caption = '&Reports'
          ShortCut = 16466
          OnClick = mnuChartTabClick
        end
      end
      object mnuViewInformation: TMenuItem
        Caption = 'Information'
        OnClick = mnuViewInformationClick
        object mnuViewDemo: TMenuItem
          Tag = 1
          Caption = 'De&mographics...'
          OnClick = ViewInfo
        end
        object mnuViewVisits: TMenuItem
          Tag = 2
          Caption = 'Visits/Pr&ovider...'
          OnClick = ViewInfo
        end
        object mnuViewPrimaryCare: TMenuItem
          Tag = 3
          Caption = 'Primary &Care...'
          OnClick = ViewInfo
        end
        object mnuViewMyHealtheVet: TMenuItem
          Tag = 4
          Caption = 'MyHealthe&Vet...'
          OnClick = ViewInfo
        end
        object mnuInsurance: TMenuItem
          Tag = 5
          Caption = '&Insurance...'
          OnClick = ViewInfo
        end
        object mnuViewFlags: TMenuItem
          Tag = 6
          Caption = '&Flags...'
          OnClick = ViewInfo
        end
        object mnuViewRemoteData: TMenuItem
          Tag = 7
          Caption = 'Remote &Data...'
          OnClick = ViewInfo
        end
        object mnuViewReminders: TMenuItem
          Tag = 8
          Caption = '&Reminders...'
          Enabled = False
          OnClick = ViewInfo
        end
        object mnuViewPostings: TMenuItem
          Tag = 9
          Caption = '&Postings...'
          OnClick = ViewInfo
        end
      end
      object Z1: TMenuItem
        Caption = '-'
      end
      object mnuViewActive: TMenuItem
        Tag = 700
        Caption = '&Active Problems'
        OnClick = lstProbActsClick
      end
      object mnuViewInactive: TMenuItem
        Tag = 800
        Caption = '&Inactive Problems'
        OnClick = lstProbActsClick
      end
      object mnuViewBoth: TMenuItem
        Tag = 900
        Caption = '&Both Active/Inactive Problems'
        OnClick = lstProbActsClick
      end
      object mnuViewRemoved: TMenuItem
        Tag = 950
        Caption = '&Removed Problems'
        OnClick = lstProbActsClick
      end
      object mnuViewFilters: TMenuItem
        Tag = 975
        Caption = 'Fi&lters...'
        OnClick = lstProbActsClick
      end
      object mnuViewComments: TMenuItem
        Caption = 'Show &Comments'
        OnClick = mnuViewCommentsClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuViewSave: TMenuItem
        Caption = 'Sa&ve as Default View'
        OnClick = mnuViewSaveClick
      end
      object mnuViewRestoreDefault: TMenuItem
        Caption = 'Return to De&fault View'
        OnClick = mnuViewRestoreDefaultClick
      end
    end
    object mnuAct: TMenuItem
      Caption = '&Action'
      GroupIndex = 4
      object mnuActNew: TMenuItem
        Tag = 100
        Caption = '&New Problem...'
        OnClick = lstProbActsClick
      end
      object Z3: TMenuItem
        Caption = '-'
      end
      object mnuActChange: TMenuItem
        Tag = 400
        Caption = '&Change...'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object mnuActInactivate: TMenuItem
        Tag = 200
        Caption = '&Inactivate'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object mnuActVerify: TMenuItem
        Tag = 250
        Caption = '&Verify...'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuActAnnotate: TMenuItem
        Tag = 600
        Caption = '&Annotate...'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object Z4: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuActRemove: TMenuItem
        Tag = 500
        Caption = '&Remove'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object mnuActRestore: TMenuItem
        Tag = 550
        Caption = 'Re&store'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuActDetails: TMenuItem
        Tag = 300
        Caption = 'View &Details'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object N5: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuAutoAddProbs: TMenuItem
        Caption = '&Link Topics To Problems'
        Visible = False
        OnClick = mnuAutoAddProbsClick
      end
    end
  end
  object CPIconImageList: TImageList
    Left = 80
    Top = 104
    Bitmap = {
      494C010106000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D7D7D7FFC0C0C0FFB4B4B4FFB0B0
      B0FFAFAFAFFFAEAEAEFFAEAEAEFFAEAEAEFFAEAEAEFFAEAEAEFFB0B0B0FFB3B3
      B3FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0B0FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B9B9B9FF949494FF909090FF8D8D
      8DFF878787FF858585FF808080FF7F7F7FFF7D7D7DFF7A7A7AFF787878FF7777
      77FF787878FF7C7C7CFF7D7D7DFFB0B0B0FF00FFFFFF949494FF909090FF8D8D
      8DFF878787FF858585FF808080FF7F7F7FFF7D7D7DFF7A7A7AFF787878FF7777
      77FF787878FF7C7C7CFF7D7D7DFF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7B7B7FFB1B1B1FF808080FF4D4D
      4DFFACACACFF8F8F8FFF535353FF9F9F9FFF323232FF262626FF898989FF7F7F
      7FFF4C4C4CFF8A8A8AFF828282FFB0B0B0FF00FFFFFFB1B1B1FF808080FF4D4D
      4DFFACACACFF8F8F8FFF535353FF9F9F9FFF323232FF262626FF898989FF7F7F
      7FFF4C4C4CFF8A8A8AFF828282FF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7B7B7FFB0B0B0FF808080FF4D4D
      4DFFA8A8A8FF8F8F8FFF535353FF9C9C9CFF323232FF262626FF898989FF7F7F
      7FFF4C4C4CFF8C8C8CFF7F7F7FFFB0B0B0FF00FFFFFFB0B0B0FF808080FF4D4D
      4DFFA8A8A8FF8F8F8FFF535353FF9C9C9CFF323232FF262626FF898989FF7F7F
      7FFF4C4C4CFF8C8C8CFF7F7F7FFF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7B7B7FFACACACFF808080FF4D4D
      4DFFAAAAAAFF8F8F8FFF535353FF9D9D9DFF323232FF262626FF8B8B8BFF7F7F
      7FFF4C4C4CFF7A7A7AFF7A7A7AFFB3B3B3FF00FFFFFFACACACFF808080FF4D4D
      4DFFAAAAAAFF8F8F8FFF535353FF9D9D9DFF323232FF262626FF8B8B8BFF7F7F
      7FFF4C4C4CFF7A7A7AFF7A7A7AFF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6FFA9A9A9FF7F7F7FFF4D4D
      4DFFB0B0B0FF8F8F8FFF535353FF999999FF313131FF262626FF8D8D8DFF7F7F
      7FFF4C4C4CFF777777FF7D7D7DFFB4B4B4FF00FFFFFFA9A9A9FF7F7F7FFF4D4D
      4DFFB0B0B0FF8F8F8FFF535353FF999999FF313131FF262626FF8D8D8DFF7F7F
      7FFF4C4C4CFF777777FF7D7D7DFF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6FFA6A6A6FF808080FF4D4D
      4DFFC5C5C5FF8F8F8FFF535353FFB3B3B3FF323232FF262626FF9C9C9CFF7F7F
      7FFF4C4C4CFF878787FF838383FFB5B5B5FF00FFFFFFA6A6A6FF808080FF4D4D
      4DFFC5C5C5FF8F8F8FFF535353FFB3B3B3FF323232FF262626FF9C9C9CFF7F7F
      7FFF4C4C4CFF878787FF838383FF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6FFA3A3A3FF7F7F7FFF4D4D
      4DFFAEAEAEFF8F8F8FFF545454FFBFBFBFFF323232FF262626FFB7B7B7FF7F7F
      7FFF4C4C4CFF8F8F8FFF848484FFB5B5B5FF00FFFFFFA3A3A3FF7F7F7FFF4D4D
      4DFFAEAEAEFF8F8F8FFF545454FFBFBFBFFF323232FF262626FFB7B7B7FF7F7F
      7FFF4C4C4CFF8F8F8FFF848484FF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6FF9F9F9FFFA0A0A0FFB2B2
      B2FFA2A2A2FF8F8F8FFF535353FFA1A1A1FF323232FF252525FFA7A7A7FF7F7F
      7FFF4D4D4DFF888888FF838383FFB5B5B5FF00FFFFFF9F9F9FFFA0A0A0FFB2B2
      B2FFA2A2A2FF8F8F8FFF535353FFA1A1A1FF323232FF252525FFA7A7A7FF7F7F
      7FFF4D4D4DFF888888FF838383FF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6FF9D9D9DFFA1A1A1FF9F9F
      9FFF929292FF8F8F8FFF535353FF9C9C9CFF9A9A9AFF8B8B8BFFADADADFF7F7F
      7FFF4D4D4DFF8E8E8EFF838383FFB5B5B5FF00FFFFFF9D9D9DFFA1A1A1FF9F9F
      9FFF929292FF8F8F8FFF535353FF9C9C9CFF9A9A9AFF8B8B8BFFADADADFF7F7F
      7FFF4D4D4DFF8E8E8EFF838383FF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6FF9A9A9AFF9B9B9BFF9696
      96FF878787FFBBBBBBFFA3A3A3FF9B9B9BFFB5B5B5FFB0B0B0FFAAAAAAFF7F7F
      7FFF4D4D4DFF8C8C8CFF838383FFB5B5B5FF00FFFFFF9A9A9AFF9B9B9BFF9696
      96FF878787FFBBBBBBFFA3A3A3FF9B9B9BFFB5B5B5FFB0B0B0FFAAAAAAFF7F7F
      7FFF4D4D4DFF8C8C8CFF838383FF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6FF979797FF979797FF9393
      93FF858585FFACACACFFB8B8B8FFB6B6B6FFB6B6B6FFB5B5B5FFBBBBBBFF7F7F
      7FFF4D4D4DFF8B8B8BFF838383FFB5B5B5FF00FFFFFF979797FF979797FF9393
      93FF858585FFACACACFFB8B8B8FFB6B6B6FFB6B6B6FFB5B5B5FFBBBBBBFF7F7F
      7FFF4D4D4DFF8B8B8BFF838383FF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6FF969696FFA1A1A1FFA5A5
      A5FFA4A4A4FFA4A4A4FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA3A3A3FFA2A2
      A2FFC3C3C3FFA7A7A7FF868686FFB5B5B5FF00FFFFFF969696FFA1A1A1FFA5A5
      A5FFA4A4A4FFA4A4A4FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA3A3A3FFA2A2
      A2FFC3C3C3FFA7A7A7FF868686FF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6FF949494FF999999FFA1A1
      A1FF9C9C9CFFA1A1A1FF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFFA1A1A1FF9C9C
      9CFFB9B9B9FF9E9E9EFF858585FFB5B5B5FF00FFFFFF949494FF999999FFA1A1
      A1FF9C9C9CFFA1A1A1FF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFFA1A1A1FF9C9C
      9CFFB9B9B9FF9E9E9EFF858585FF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B9B9B9FF929292FF959595FF9191
      91FF888888FF8B8B8BFF898989FF8A8A8AFF8A8A8AFF898989FF8B8B8BFF8888
      88FF8A8A8AFF848484FF828282FFB8B8B8FF00FFFFFF929292FF959595FF9191
      91FF888888FF8B8B8BFF898989FF8A8A8AFF8A8A8AFF898989FF8B8B8BFF8888
      88FF8A8A8AFF848484FF828282FF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C7C7C7FF838383FF797979FF7A7A
      7AFF747474FF777777FF757575FF767676FF767676FF757575FF777777FF7575
      75FF787878FF737373FF7D7D7DFFC6C6C6FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D7D7D7FFC0C0C0FFB4B4B4FFB0B0
      B0FFAFAFAFFFAEAEAEFFAEAEAEFFAEAEAEFFAEAEAEFFAEAEAEFFB0B0B0FFB3B3
      B3FFB0B0B0FFB0B0B0FFB0B0B0FFB0B0B0FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFFD8D7D7FFC5C0BCFFB8B4B0FFB5B0
      ACFFB3AFABFFB3AEAAFFB2AEAAFFB2AEAAFFB2AEAAFFB2AEAAFFB4B0ACFFB8B4
      AFFFB4B0ACFFB4B0ACFFB4B0ACFFB4B0ACFF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFFB9B9B9FF949494FF909090FF8D8D
      8DFF878787FF858585FF808080FF7F7F7FFF7D7D7DFF7A7A7AFF787878FF7777
      77FF787878FF7C7C7CFF7D7D7DFFB0B0B0FF00FFFFFF949494FF909090FF8D8D
      8DFF878787FF858585FF808080FF7F7F7FFF7D7D7DFF7A7A7AFF787878FF7777
      77FF787878FF7C7C7CFF7D7D7DFF00FFFFFFC4BAAFFFAF9579FFAE9373FFAC8F
      6EFFA98965FFA78863FFA4845DFFA3825BFFA37F57FFA27D52FFA07B51FF9E7A
      50FFA17B4FFFA98050FFAE824CFFB4B0ACFF00FFFFFFAF9579FFAE9373FFAC8F
      6EFFA98965FFA78863FFA4845DFFA3825BFFA37F57FFA27D52FFA07B51FF9E7A
      50FFA17B4FFFA98050FFAE824CFF00FFFFFFB7B7B7FFB1B1B1FFBFBFBFFFB8B8
      B8FFACACACFFAAAAAAFFA3A3A3FF9F9F9FFF999999FF949494FF898989FF8585
      85FF929292FF8A8A8AFF828282FFB0B0B0FF00FFFFFFB1B1B1FFBFBFBFFFB8B8
      B8FFACACACFFAAAAAAFFA3A3A3FF9F9F9FFF999999FF949494FF898989FF8585
      85FF929292FF8A8A8AFF828282FF00FFFFFFC7B7A7FFD2B491FF0403FDFF0403
      95FFDCB37DFFFE2120FF872120FFD7A668FF046101FF044901FFC29150FF0302
      FBFF030395FFBF9256FFBC8849FFB4B0ACFF00FFFFFFD2B491FF0403FDFF0403
      95FFDCB37DFFFE2120FF872120FFD7A668FF046101FF044901FFC29150FF0302
      FBFF030395FFBF9256FFBC8849FF00FFFFFFB7B7B7FFB0B0B0FFBCBCBCFFB5B5
      B5FFA8A8A8FFA7A7A7FFA0A0A0FF9C9C9CFF979797FF959595FF898989FF8787
      87FF8F8F8FFF8C8C8CFF7F7F7FFFB0B0B0FF00FFFFFFB0B0B0FFBCBCBCFFB5B5
      B5FFA8A8A8FFA7A7A7FFA0A0A0FF9C9C9CFF979797FF959595FF898989FF8787
      87FF8F8F8FFF8C8C8CFF7F7F7FFF00FFFFFFC7B7A7FFD2B38EFF0403FCFF0403
      95FFDCB175FFFE2120FF872120FFD7A662FF046101FF044901FFC5924DFF0302
      FBFF030394FFC39456FFB88546FFB4B0ACFF00FFFFFFD2B38EFF0403FCFF0403
      95FFDCB175FFFE2120FF872120FFD7A662FF046101FF044901FFC5924DFF0302
      FBFF030394FFC39456FFB88546FF00FFFFFFB7B7B7FFACACACFFBABABAFFB5B5
      B5FFAAAAAAFFA5A5A5FFA0A0A0FF9D9D9DFF989898FF949494FF8B8B8BFF8080
      80FF808080FF7A7A7AFF7A7A7AFFB3B3B3FF00FFFFFFACACACFFBABABAFFB5B5
      B5FFAAAAAAFFA5A5A5FFA0A0A0FF9D9D9DFF989898FF949494FF8B8B8BFF8080
      80FF808080FF7A7A7AFF7A7A7AFF00FFFFFFC7B7A7FFD0B189FF0403FCFF0403
      95FFDDB377FFFE2120FF872120FFD8A862FF046101FF044901FFC8964FFF0302
      FBFF030294FFAA824AFFB07E44FFC4B4A3FF00FFFFFFD0B189FF0403FCFF0403
      95FFDDB377FFFE2120FF872120FFD8A862FF046101FF044901FFC8964FFF0302
      FBFF030294FFAA824AFFB07E44FF00FFFFFFB6B6B6FFA9A9A9FFB1B1B1FFBCBC
      BCFFB0B0B0FFA1A1A1FF9B9B9BFF999999FF949494FF909090FF8D8D8DFF8181
      81FF808080FF777777FF7D7D7DFFB4B4B4FF00FFFFFFA9A9A9FFB1B1B1FFBCBC
      BCFFB0B0B0FFA1A1A1FF9B9B9BFF999999FF949494FF909090FF8D8D8DFF8181
      81FF808080FF777777FF7D7D7DFF00FFFFFFC7B7A6FFCEAE84FF0403FCFF0403
      95FFE1BA7FFFFE2120FF872120FFD7A45BFF046101FF044901FFD0994AFF0302
      FBFF030294FFBB8033FFB78244FFC5B5A4FF00FFFFFFCEAE84FF0403FCFF0403
      95FFE1BA7FFFFE2120FF872120FFD7A45BFF046101FF044901FFD0994AFF0302
      FBFF030294FFBB8033FFB78244FF00FFFFFFB6B6B6FFA6A6A6FFB6B6B6FFC9C9
      C9FFC5C5C5FFB8B8B8FFB4B4B4FFB3B3B3FFB0B0B0FFAFAFAFFF9C9C9CFF8989
      89FF8C8C8CFF878787FF838383FFB5B5B5FF00FFFFFFA6A6A6FFB6B6B6FFC9C9
      C9FFC5C5C5FFB8B8B8FFB4B4B4FFB3B3B3FFB0B0B0FFAFAFAFFF9C9C9CFF8989
      89FF8C8C8CFF878787FF838383FF00FFFFFFC7B7A6FFCDAB7FFF0403FCFF0404
      96FFECCF9FFFFE2221FF872220FFE4BD82FF046102FF044A02FFD9A860FF0402
      FBFF040294FFCD9141FFBF8948FFC7B6A4FF00FFFFFFCDAB7FFF0403FCFF0404
      96FFECCF9FFFFE2221FF872220FFE4BD82FF046102FF044A02FFD9A860FF0402
      FBFF040294FFCD9141FFBF8948FF00FFFFFFB6B6B6FFA3A3A3FFACACACFFB9B9
      B9FFAEAEAEFFABABABFFC0C0C0FFBFBFBFFFBDBDBDFFBBBBBBFFB7B7B7FF9292
      92FFA7A7A7FF8F8F8FFF848484FFB5B5B5FF00FFFFFFA3A3A3FFACACACFFB9B9
      B9FFAEAEAEFFABABABFFC0C0C0FFBFBFBFFFBDBDBDFFBBBBBBFFB7B7B7FF9292
      92FFA7A7A7FF8F8F8FFF848484FF00FFFFFFC7B7A6FFCCA87BFF0403FCFF0403
      95FFE1B87CFFFE2120FF872221FFEACA94FF046202FF044A02FFE7C288FF0403
      FBFF040395FFD1984DFFC08A48FFC7B6A4FF00FFFFFFCCA87BFF0403FCFF0403
      95FFE1B87CFFFE2120FF872221FFEACA94FF046202FF044A02FFE7C288FF0403
      FBFF040395FFD1984DFFC08A48FF00FFFFFFB6B6B6FF9F9F9FFFA0A0A0FFB2B2
      B2FFA2A2A2FFBDBDBDFF999999FFA1A1A1FF9F9F9FFF898989FFA7A7A7FF9090
      90FFB3B3B3FF888888FF838383FFB5B5B5FF00FFFFFF9F9F9FFFA0A0A0FFB2B2
      B2FFA2A2A2FFBDBDBDFF999999FFA1A1A1FF9F9F9FFF898989FFA7A7A7FF9090
      90FFB3B3B3FF888888FF838383FF00FFFFFFC7B7A6FFCAA475FFD6AB6AFFE1BC
      84FFDCAE69FFFE2221FF872120FFDCAD67FF046101FF044901FFDFB470FF0403
      FBFF040395FFCE9242FFBF8947FFC7B6A4FF00FFFFFFCAA475FFD6AB6AFFE1BC
      84FFDCAE69FFFE2221FF872120FFDCAD67FF046101FF044901FFDFB470FF0403
      FBFF040395FFCE9242FFBF8947FF00FFFFFFB6B6B6FF9D9D9DFFA1A1A1FF9F9F
      9FFF929292FFBDBDBDFF999999FF9C9C9CFF9A9A9AFF8B8B8BFFADADADFF9595
      95FFB6B6B6FF8E8E8EFF838383FFB5B5B5FF00FFFFFF9D9D9DFFA1A1A1FF9F9F
      9FFF929292FFBDBDBDFF999999FF9C9C9CFF9A9A9AFF8B8B8BFFADADADFF9595
      95FFB6B6B6FF8E8E8EFF838383FF00FFFFFFC7B6A6FFC9A271FFD6AC6CFFD8AA
      67FFD49E50FFFE2221FF872120FFD9A960FFD8A65DFFD19846FFE2B878FF0403
      FBFF040395FFD1974BFFBF8A48FFC7B6A4FF00FFFFFFC9A271FFD6AC6CFFD8AA
      67FFD49E50FFFE2221FF872120FFD9A960FFD8A65DFFD19846FFE2B878FF0403
      FBFF040395FFD1974BFFBF8A48FF00FFFFFFB6B6B6FF9A9A9AFF9B9B9BFF9696
      96FF878787FFBBBBBBFFA3A3A3FF9B9B9BFFB5B5B5FFB0B0B0FFAAAAAAFF9393
      93FFB5B5B5FF8C8C8CFF838383FFB5B5B5FF00FFFFFF9A9A9AFF9B9B9BFF9696
      96FF878787FFBBBBBBFFA3A3A3FF9B9B9BFFB5B5B5FFB0B0B0FFAAAAAAFF9393
      93FFB5B5B5FF8C8C8CFF838383FF00FFFFFFC7B6A6FFC89F6CFFD4A663FFD4A1
      58FFCF9440FFE8C58EFFDDAF69FFD9A85EFFE5C085FFE3BB7DFFE1B673FF0403
      FBFF040395FFD09648FFC08947FFC7B6A4FF00FFFFFFC89F6CFFD4A663FFD4A1
      58FFCF9440FFE8C58EFFDDAF69FFD9A85EFFE5C085FFE3BB7DFFE1B673FF0403
      FBFF040395FFD09648FFC08947FF00FFFFFFB6B6B6FF979797FF979797FF9393
      93FF858585FFACACACFFB8B8B8FFB6B6B6FFB6B6B6FFB5B5B5FFBBBBBBFF8E8E
      8EFFB4B4B4FF8B8B8BFF838383FFB5B5B5FF00FFFFFF979797FF979797FF9393
      93FF858585FFACACACFFB8B8B8FFB6B6B6FFB6B6B6FFB5B5B5FFBBBBBBFF8E8E
      8EFFB4B4B4FF8B8B8BFF838383FF00FFFFFFC7B6A5FFC69D69FFD2A35DFFD39E
      53FFCE923CFFE1B877FFE7C48AFFE6C187FFE6C186FFE6C085FFE8C68EFF0403
      FBFF040395FFD09547FFC08947FFC7B6A4FF00FFFFFFC69D69FFD2A35DFFD39E
      53FFCE923CFFE1B877FFE7C48AFFE6C187FFE6C186FFE6C085FFE8C68EFF0403
      FBFF040395FFD09547FFC08947FF00FFFFFFB6B6B6FF969696FFA1A1A1FFA5A5
      A5FFA4A4A4FFA4A4A4FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA3A3A3FFA2A2
      A2FFC3C3C3FFA7A7A7FF868686FFB5B5B5FF00FFFFFF969696FFA1A1A1FFA5A5
      A5FFA4A4A4FFA4A4A4FFA2A2A2FFA2A2A2FFA2A2A2FFA2A2A2FFA3A3A3FFA2A2
      A2FFC3C3C3FFA7A7A7FF868686FF00FFFFFFC7B6A5FFC69C67FFD7AC6BFFDCB0
      6EFFDDAF6BFFDDB06CFFDCAE68FFDCAE69FFDCAE69FFDCAE69FFDDAF6AFFDCAE
      68FFECCD9BFFDDB071FFC18C4CFFC7B6A4FF00FFFFFFC69C67FFD7AC6BFFDCB0
      6EFFDDAF6BFFDDB06CFFDCAE68FFDCAE69FFDCAE69FFDCAE69FFDDAF6AFFDCAE
      68FFECCD9BFFDDB071FFC18C4CFF00FFFFFFB6B6B6FF949494FF999999FFA1A1
      A1FF9C9C9CFFA1A1A1FF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFFA1A1A1FF9C9C
      9CFFB9B9B9FF9E9E9EFF858585FFB5B5B5FF00FFFFFF949494FF999999FFA1A1
      A1FF9C9C9CFFA1A1A1FF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFFA1A1A1FF9C9C
      9CFFB9B9B9FF9E9E9EFF858585FF00FFFFFFC7B6A5FFC49A64FFD3A45FFFDAAC
      68FFD9A960FFDBAC67FFDAAB64FFDAAB65FFDAAB65FFDAAB64FFDBAC67FFD9A8
      5FFFE7C48CFFD8A864FFC08A4BFFC7B6A4FF00FFFFFFC49A64FFD3A45FFFDAAC
      68FFD9A960FFDBAC67FFDAAB64FFDAAB65FFDAAB65FFDAAB64FFDBAC67FFD9A8
      5FFFE7C48CFFD8A864FFC08A4BFF00FFFFFFB9B9B9FF929292FF959595FF9191
      91FF888888FF8B8B8BFF898989FF8A8A8AFF8A8A8AFF898989FF8B8B8BFF8888
      88FF8A8A8AFF848484FF828282FFB8B8B8FF00FFFFFF929292FF959595FF9191
      91FF888888FF8B8B8BFF898989FF8A8A8AFF8A8A8AFF898989FF8B8B8BFF8888
      88FF8A8A8AFF848484FF828282FF00FFFFFFCAB9A8FFC39862FFCF9E5BFFD099
      52FFCD9143FFCF9448FFCE9245FFCE9346FFCE9346FFCE9245FFCF9448FFCE91
      43FFCD9247FFCA8C3FFFBE8647FFC9B8A7FF00FFFFFFC39862FFCF9E5BFFD099
      52FFCD9143FFCF9448FFCE9245FFCE9346FFCE9346FFCE9245FFCF9448FFCE91
      43FFCD9247FFCA8C3FFFBE8647FF00FFFFFFC7C7C7FF838383FF797979FF7A7A
      7AFF747474FF777777FF757575FF767676FF767676FF757575FF777777FF7575
      75FF787878FF737373FF7D7D7DFFC6C6C6FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFFD4C7BAFFB08557FFAF7D44FFB07D
      44FFAE783BFFAF7A3FFFAE793DFFAF7A3EFFAF7A3EFFAE793DFFAF7A3FFFAE78
      3CFFAF7B41FFAD763AFFAE7E4CFFD4C7B9FF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
      FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
