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
  ExplicitWidth = 647
  ExplicitHeight = 473
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
      000000000000000000000000000000000000D7D7D700C0C0C000B4B4B400B0B0
      B000AFAFAF00AEAEAE00AEAEAE00AEAEAE00AEAEAE00AEAEAE00B0B0B000B3B3
      B300B0B0B000B0B0B000B0B0B000B0B0B00000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B9B9B90094949400909090008D8D
      8D008787870085858500808080007F7F7F007D7D7D007A7A7A00787878007777
      7700787878007C7C7C007D7D7D00B0B0B00000FFFF0094949400909090008D8D
      8D008787870085858500808080007F7F7F007D7D7D007A7A7A00787878007777
      7700787878007C7C7C007D7D7D0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7B7B700B1B1B100808080004D4D
      4D00ACACAC008F8F8F00535353009F9F9F003232320026262600898989007F7F
      7F004C4C4C008A8A8A0082828200B0B0B00000FFFF00B1B1B100808080004D4D
      4D00ACACAC008F8F8F00535353009F9F9F003232320026262600898989007F7F
      7F004C4C4C008A8A8A008282820000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7B7B700B0B0B000808080004D4D
      4D00A8A8A8008F8F8F00535353009C9C9C003232320026262600898989007F7F
      7F004C4C4C008C8C8C007F7F7F00B0B0B00000FFFF00B0B0B000808080004D4D
      4D00A8A8A8008F8F8F00535353009C9C9C003232320026262600898989007F7F
      7F004C4C4C008C8C8C007F7F7F0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7B7B700ACACAC00808080004D4D
      4D00AAAAAA008F8F8F00535353009D9D9D0032323200262626008B8B8B007F7F
      7F004C4C4C007A7A7A007A7A7A00B3B3B30000FFFF00ACACAC00808080004D4D
      4D00AAAAAA008F8F8F00535353009D9D9D0032323200262626008B8B8B007F7F
      7F004C4C4C007A7A7A007A7A7A0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B600A9A9A9007F7F7F004D4D
      4D00B0B0B0008F8F8F00535353009999990031313100262626008D8D8D007F7F
      7F004C4C4C00777777007D7D7D00B4B4B40000FFFF00A9A9A9007F7F7F004D4D
      4D00B0B0B0008F8F8F00535353009999990031313100262626008D8D8D007F7F
      7F004C4C4C00777777007D7D7D0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B600A6A6A600808080004D4D
      4D00C5C5C5008F8F8F0053535300B3B3B30032323200262626009C9C9C007F7F
      7F004C4C4C008787870083838300B5B5B50000FFFF00A6A6A600808080004D4D
      4D00C5C5C5008F8F8F0053535300B3B3B30032323200262626009C9C9C007F7F
      7F004C4C4C00878787008383830000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B600A3A3A3007F7F7F004D4D
      4D00AEAEAE008F8F8F0054545400BFBFBF003232320026262600B7B7B7007F7F
      7F004C4C4C008F8F8F0084848400B5B5B50000FFFF00A3A3A3007F7F7F004D4D
      4D00AEAEAE008F8F8F0054545400BFBFBF003232320026262600B7B7B7007F7F
      7F004C4C4C008F8F8F008484840000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6009F9F9F00A0A0A000B2B2
      B200A2A2A2008F8F8F0053535300A1A1A1003232320025252500A7A7A7007F7F
      7F004D4D4D008888880083838300B5B5B50000FFFF009F9F9F00A0A0A000B2B2
      B200A2A2A2008F8F8F0053535300A1A1A1003232320025252500A7A7A7007F7F
      7F004D4D4D00888888008383830000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6009D9D9D00A1A1A1009F9F
      9F00929292008F8F8F00535353009C9C9C009A9A9A008B8B8B00ADADAD007F7F
      7F004D4D4D008E8E8E0083838300B5B5B50000FFFF009D9D9D00A1A1A1009F9F
      9F00929292008F8F8F00535353009C9C9C009A9A9A008B8B8B00ADADAD007F7F
      7F004D4D4D008E8E8E008383830000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6009A9A9A009B9B9B009696
      960087878700BBBBBB00A3A3A3009B9B9B00B5B5B500B0B0B000AAAAAA007F7F
      7F004D4D4D008C8C8C0083838300B5B5B50000FFFF009A9A9A009B9B9B009696
      960087878700BBBBBB00A3A3A3009B9B9B00B5B5B500B0B0B000AAAAAA007F7F
      7F004D4D4D008C8C8C008383830000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B60097979700979797009393
      930085858500ACACAC00B8B8B800B6B6B600B6B6B600B5B5B500BBBBBB007F7F
      7F004D4D4D008B8B8B0083838300B5B5B50000FFFF0097979700979797009393
      930085858500ACACAC00B8B8B800B6B6B600B6B6B600B5B5B500BBBBBB007F7F
      7F004D4D4D008B8B8B008383830000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B60096969600A1A1A100A5A5
      A500A4A4A400A4A4A400A2A2A200A2A2A200A2A2A200A2A2A200A3A3A300A2A2
      A200C3C3C300A7A7A70086868600B5B5B50000FFFF0096969600A1A1A100A5A5
      A500A4A4A400A4A4A400A2A2A200A2A2A200A2A2A200A2A2A200A3A3A300A2A2
      A200C3C3C300A7A7A7008686860000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6009494940099999900A1A1
      A1009C9C9C00A1A1A1009F9F9F009F9F9F009F9F9F009F9F9F00A1A1A1009C9C
      9C00B9B9B9009E9E9E0085858500B5B5B50000FFFF009494940099999900A1A1
      A1009C9C9C00A1A1A1009F9F9F009F9F9F009F9F9F009F9F9F00A1A1A1009C9C
      9C00B9B9B9009E9E9E008585850000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B9B9B90092929200959595009191
      9100888888008B8B8B00898989008A8A8A008A8A8A00898989008B8B8B008888
      88008A8A8A008484840082828200B8B8B80000FFFF0092929200959595009191
      9100888888008B8B8B00898989008A8A8A008A8A8A00898989008B8B8B008888
      88008A8A8A00848484008282820000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C7C7C70083838300797979007A7A
      7A00747474007777770075757500767676007676760075757500777777007575
      750078787800737373007D7D7D00C6C6C60000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D7D7D700C0C0C000B4B4B400B0B0
      B000AFAFAF00AEAEAE00AEAEAE00AEAEAE00AEAEAE00AEAEAE00B0B0B000B3B3
      B300B0B0B000B0B0B000B0B0B000B0B0B00000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00D8D7D700C5C0BC00B8B4B000B5B0
      AC00B3AFAB00B3AEAA00B2AEAA00B2AEAA00B2AEAA00B2AEAA00B4B0AC00B8B4
      AF00B4B0AC00B4B0AC00B4B0AC00B4B0AC0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00B9B9B90094949400909090008D8D
      8D008787870085858500808080007F7F7F007D7D7D007A7A7A00787878007777
      7700787878007C7C7C007D7D7D00B0B0B00000FFFF0094949400909090008D8D
      8D008787870085858500808080007F7F7F007D7D7D007A7A7A00787878007777
      7700787878007C7C7C007D7D7D0000FFFF00C4BAAF00AF957900AE937300AC8F
      6E00A9896500A7886300A4845D00A3825B00A37F5700A27D5200A07B51009E7A
      5000A17B4F00A9805000AE824C00B4B0AC0000FFFF00AF957900AE937300AC8F
      6E00A9896500A7886300A4845D00A3825B00A37F5700A27D5200A07B51009E7A
      5000A17B4F00A9805000AE824C0000FFFF00B7B7B700B1B1B100BFBFBF00B8B8
      B800ACACAC00AAAAAA00A3A3A3009F9F9F009999990094949400898989008585
      8500929292008A8A8A0082828200B0B0B00000FFFF00B1B1B100BFBFBF00B8B8
      B800ACACAC00AAAAAA00A3A3A3009F9F9F009999990094949400898989008585
      8500929292008A8A8A008282820000FFFF00C7B7A700D2B491000403FD000403
      9500DCB37D00FE21200087212000D7A668000461010004490100C29150000302
      FB0003039500BF925600BC884900B4B0AC0000FFFF00D2B491000403FD000403
      9500DCB37D00FE21200087212000D7A668000461010004490100C29150000302
      FB0003039500BF925600BC88490000FFFF00B7B7B700B0B0B000BCBCBC00B5B5
      B500A8A8A800A7A7A700A0A0A0009C9C9C009797970095959500898989008787
      87008F8F8F008C8C8C007F7F7F00B0B0B00000FFFF00B0B0B000BCBCBC00B5B5
      B500A8A8A800A7A7A700A0A0A0009C9C9C009797970095959500898989008787
      87008F8F8F008C8C8C007F7F7F0000FFFF00C7B7A700D2B38E000403FC000403
      9500DCB17500FE21200087212000D7A662000461010004490100C5924D000302
      FB0003039400C3945600B8854600B4B0AC0000FFFF00D2B38E000403FC000403
      9500DCB17500FE21200087212000D7A662000461010004490100C5924D000302
      FB0003039400C3945600B885460000FFFF00B7B7B700ACACAC00BABABA00B5B5
      B500AAAAAA00A5A5A500A0A0A0009D9D9D0098989800949494008B8B8B008080
      8000808080007A7A7A007A7A7A00B3B3B30000FFFF00ACACAC00BABABA00B5B5
      B500AAAAAA00A5A5A500A0A0A0009D9D9D0098989800949494008B8B8B008080
      8000808080007A7A7A007A7A7A0000FFFF00C7B7A700D0B189000403FC000403
      9500DDB37700FE21200087212000D8A862000461010004490100C8964F000302
      FB0003029400AA824A00B07E4400C4B4A30000FFFF00D0B189000403FC000403
      9500DDB37700FE21200087212000D8A862000461010004490100C8964F000302
      FB0003029400AA824A00B07E440000FFFF00B6B6B600A9A9A900B1B1B100BCBC
      BC00B0B0B000A1A1A1009B9B9B009999990094949400909090008D8D8D008181
      810080808000777777007D7D7D00B4B4B40000FFFF00A9A9A900B1B1B100BCBC
      BC00B0B0B000A1A1A1009B9B9B009999990094949400909090008D8D8D008181
      810080808000777777007D7D7D0000FFFF00C7B7A600CEAE84000403FC000403
      9500E1BA7F00FE21200087212000D7A45B000461010004490100D0994A000302
      FB0003029400BB803300B7824400C5B5A40000FFFF00CEAE84000403FC000403
      9500E1BA7F00FE21200087212000D7A45B000461010004490100D0994A000302
      FB0003029400BB803300B782440000FFFF00B6B6B600A6A6A600B6B6B600C9C9
      C900C5C5C500B8B8B800B4B4B400B3B3B300B0B0B000AFAFAF009C9C9C008989
      89008C8C8C008787870083838300B5B5B50000FFFF00A6A6A600B6B6B600C9C9
      C900C5C5C500B8B8B800B4B4B400B3B3B300B0B0B000AFAFAF009C9C9C008989
      89008C8C8C00878787008383830000FFFF00C7B7A600CDAB7F000403FC000404
      9600ECCF9F00FE22210087222000E4BD820004610200044A0200D9A860000402
      FB0004029400CD914100BF894800C7B6A40000FFFF00CDAB7F000403FC000404
      9600ECCF9F00FE22210087222000E4BD820004610200044A0200D9A860000402
      FB0004029400CD914100BF89480000FFFF00B6B6B600A3A3A300ACACAC00B9B9
      B900AEAEAE00ABABAB00C0C0C000BFBFBF00BDBDBD00BBBBBB00B7B7B7009292
      9200A7A7A7008F8F8F0084848400B5B5B50000FFFF00A3A3A300ACACAC00B9B9
      B900AEAEAE00ABABAB00C0C0C000BFBFBF00BDBDBD00BBBBBB00B7B7B7009292
      9200A7A7A7008F8F8F008484840000FFFF00C7B7A600CCA87B000403FC000403
      9500E1B87C00FE21200087222100EACA940004620200044A0200E7C288000403
      FB0004039500D1984D00C08A4800C7B6A40000FFFF00CCA87B000403FC000403
      9500E1B87C00FE21200087222100EACA940004620200044A0200E7C288000403
      FB0004039500D1984D00C08A480000FFFF00B6B6B6009F9F9F00A0A0A000B2B2
      B200A2A2A200BDBDBD0099999900A1A1A1009F9F9F0089898900A7A7A7009090
      9000B3B3B3008888880083838300B5B5B50000FFFF009F9F9F00A0A0A000B2B2
      B200A2A2A200BDBDBD0099999900A1A1A1009F9F9F0089898900A7A7A7009090
      9000B3B3B300888888008383830000FFFF00C7B7A600CAA47500D6AB6A00E1BC
      8400DCAE6900FE22210087212000DCAD67000461010004490100DFB470000403
      FB0004039500CE924200BF894700C7B6A40000FFFF00CAA47500D6AB6A00E1BC
      8400DCAE6900FE22210087212000DCAD67000461010004490100DFB470000403
      FB0004039500CE924200BF89470000FFFF00B6B6B6009D9D9D00A1A1A1009F9F
      9F0092929200BDBDBD00999999009C9C9C009A9A9A008B8B8B00ADADAD009595
      9500B6B6B6008E8E8E0083838300B5B5B50000FFFF009D9D9D00A1A1A1009F9F
      9F0092929200BDBDBD00999999009C9C9C009A9A9A008B8B8B00ADADAD009595
      9500B6B6B6008E8E8E008383830000FFFF00C7B6A600C9A27100D6AC6C00D8AA
      6700D49E5000FE22210087212000D9A96000D8A65D00D1984600E2B878000403
      FB0004039500D1974B00BF8A4800C7B6A40000FFFF00C9A27100D6AC6C00D8AA
      6700D49E5000FE22210087212000D9A96000D8A65D00D1984600E2B878000403
      FB0004039500D1974B00BF8A480000FFFF00B6B6B6009A9A9A009B9B9B009696
      960087878700BBBBBB00A3A3A3009B9B9B00B5B5B500B0B0B000AAAAAA009393
      9300B5B5B5008C8C8C0083838300B5B5B50000FFFF009A9A9A009B9B9B009696
      960087878700BBBBBB00A3A3A3009B9B9B00B5B5B500B0B0B000AAAAAA009393
      9300B5B5B5008C8C8C008383830000FFFF00C7B6A600C89F6C00D4A66300D4A1
      5800CF944000E8C58E00DDAF6900D9A85E00E5C08500E3BB7D00E1B673000403
      FB0004039500D0964800C0894700C7B6A40000FFFF00C89F6C00D4A66300D4A1
      5800CF944000E8C58E00DDAF6900D9A85E00E5C08500E3BB7D00E1B673000403
      FB0004039500D0964800C089470000FFFF00B6B6B60097979700979797009393
      930085858500ACACAC00B8B8B800B6B6B600B6B6B600B5B5B500BBBBBB008E8E
      8E00B4B4B4008B8B8B0083838300B5B5B50000FFFF0097979700979797009393
      930085858500ACACAC00B8B8B800B6B6B600B6B6B600B5B5B500BBBBBB008E8E
      8E00B4B4B4008B8B8B008383830000FFFF00C7B6A500C69D6900D2A35D00D39E
      5300CE923C00E1B87700E7C48A00E6C18700E6C18600E6C08500E8C68E000403
      FB0004039500D0954700C0894700C7B6A40000FFFF00C69D6900D2A35D00D39E
      5300CE923C00E1B87700E7C48A00E6C18700E6C18600E6C08500E8C68E000403
      FB0004039500D0954700C089470000FFFF00B6B6B60096969600A1A1A100A5A5
      A500A4A4A400A4A4A400A2A2A200A2A2A200A2A2A200A2A2A200A3A3A300A2A2
      A200C3C3C300A7A7A70086868600B5B5B50000FFFF0096969600A1A1A100A5A5
      A500A4A4A400A4A4A400A2A2A200A2A2A200A2A2A200A2A2A200A3A3A300A2A2
      A200C3C3C300A7A7A7008686860000FFFF00C7B6A500C69C6700D7AC6B00DCB0
      6E00DDAF6B00DDB06C00DCAE6800DCAE6900DCAE6900DCAE6900DDAF6A00DCAE
      6800ECCD9B00DDB07100C18C4C00C7B6A40000FFFF00C69C6700D7AC6B00DCB0
      6E00DDAF6B00DDB06C00DCAE6800DCAE6900DCAE6900DCAE6900DDAF6A00DCAE
      6800ECCD9B00DDB07100C18C4C0000FFFF00B6B6B6009494940099999900A1A1
      A1009C9C9C00A1A1A1009F9F9F009F9F9F009F9F9F009F9F9F00A1A1A1009C9C
      9C00B9B9B9009E9E9E0085858500B5B5B50000FFFF009494940099999900A1A1
      A1009C9C9C00A1A1A1009F9F9F009F9F9F009F9F9F009F9F9F00A1A1A1009C9C
      9C00B9B9B9009E9E9E008585850000FFFF00C7B6A500C49A6400D3A45F00DAAC
      6800D9A96000DBAC6700DAAB6400DAAB6500DAAB6500DAAB6400DBAC6700D9A8
      5F00E7C48C00D8A86400C08A4B00C7B6A40000FFFF00C49A6400D3A45F00DAAC
      6800D9A96000DBAC6700DAAB6400DAAB6500DAAB6500DAAB6400DBAC6700D9A8
      5F00E7C48C00D8A86400C08A4B0000FFFF00B9B9B90092929200959595009191
      9100888888008B8B8B00898989008A8A8A008A8A8A00898989008B8B8B008888
      88008A8A8A008484840082828200B8B8B80000FFFF0092929200959595009191
      9100888888008B8B8B00898989008A8A8A008A8A8A00898989008B8B8B008888
      88008A8A8A00848484008282820000FFFF00CAB9A800C3986200CF9E5B00D099
      5200CD914300CF944800CE924500CE934600CE934600CE924500CF944800CE91
      4300CD924700CA8C3F00BE864700C9B8A70000FFFF00C3986200CF9E5B00D099
      5200CD914300CF944800CE924500CE934600CE934600CE924500CF944800CE91
      4300CD924700CA8C3F00BE86470000FFFF00C7C7C70083838300797979007A7A
      7A00747474007777770075757500767676007676760075757500777777007575
      750078787800737373007D7D7D00C6C6C60000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00D4C7BA00B0855700AF7D4400B07D
      4400AE783B00AF7A3F00AE793D00AF7A3E00AF7A3E00AE793D00AF7A3F00AE78
      3C00AF7B4100AD763A00AE7E4C00D4C7B90000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF00424D3E000000000000003E000000
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
