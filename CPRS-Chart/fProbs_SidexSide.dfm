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
      0000000000003600000028000000400000003000000001001800000000000024
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
      000000000000000000000000000000000000D7D7D7C0C0C0B4B4B4B0B0B0AFAF
      AFAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEB0B0B0B3B3B3B0B0B0B0B0B0B0B0B0B0
      B0B000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B9B9B99494949090908D8D8D8787
      878585858080807F7F7F7D7D7D7A7A7A7878787777777878787C7C7C7D7D7DB0
      B0B000FFFF9494949090908D8D8D8787878585858080807F7F7F7D7D7D7A7A7A
      7878787777777878787C7C7C7D7D7D00FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7B7B7B1B1B18080804D4D4DACAC
      AC8F8F8F5353539F9F9F3232322626268989897F7F7F4C4C4C8A8A8A828282B0
      B0B000FFFFB1B1B18080804D4D4DACACAC8F8F8F5353539F9F9F323232262626
      8989897F7F7F4C4C4C8A8A8A82828200FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7B7B7B0B0B08080804D4D4DA8A8
      A88F8F8F5353539C9C9C3232322626268989897F7F7F4C4C4C8C8C8C7F7F7FB0
      B0B000FFFFB0B0B08080804D4D4DA8A8A88F8F8F5353539C9C9C323232262626
      8989897F7F7F4C4C4C8C8C8C7F7F7F00FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7B7B7ACACAC8080804D4D4DAAAA
      AA8F8F8F5353539D9D9D3232322626268B8B8B7F7F7F4C4C4C7A7A7A7A7A7AB3
      B3B300FFFFACACAC8080804D4D4DAAAAAA8F8F8F5353539D9D9D323232262626
      8B8B8B7F7F7F4C4C4C7A7A7A7A7A7A00FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6A9A9A97F7F7F4D4D4DB0B0
      B08F8F8F5353539999993131312626268D8D8D7F7F7F4C4C4C7777777D7D7DB4
      B4B400FFFFA9A9A97F7F7F4D4D4DB0B0B08F8F8F535353999999313131262626
      8D8D8D7F7F7F4C4C4C7777777D7D7D00FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6A6A6A68080804D4D4DC5C5
      C58F8F8F535353B3B3B33232322626269C9C9C7F7F7F4C4C4C878787838383B5
      B5B500FFFFA6A6A68080804D4D4DC5C5C58F8F8F535353B3B3B3323232262626
      9C9C9C7F7F7F4C4C4C87878783838300FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6A3A3A37F7F7F4D4D4DAEAE
      AE8F8F8F545454BFBFBF323232262626B7B7B77F7F7F4C4C4C8F8F8F848484B5
      B5B500FFFFA3A3A37F7F7F4D4D4DAEAEAE8F8F8F545454BFBFBF323232262626
      B7B7B77F7F7F4C4C4C8F8F8F84848400FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B69F9F9FA0A0A0B2B2B2A2A2
      A28F8F8F535353A1A1A1323232252525A7A7A77F7F7F4D4D4D888888838383B5
      B5B500FFFF9F9F9FA0A0A0B2B2B2A2A2A28F8F8F535353A1A1A1323232252525
      A7A7A77F7F7F4D4D4D88888883838300FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B69D9D9DA1A1A19F9F9F9292
      928F8F8F5353539C9C9C9A9A9A8B8B8BADADAD7F7F7F4D4D4D8E8E8E838383B5
      B5B500FFFF9D9D9DA1A1A19F9F9F9292928F8F8F5353539C9C9C9A9A9A8B8B8B
      ADADAD7F7F7F4D4D4D8E8E8E83838300FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B69A9A9A9B9B9B9696968787
      87BBBBBBA3A3A39B9B9BB5B5B5B0B0B0AAAAAA7F7F7F4D4D4D8C8C8C838383B5
      B5B500FFFF9A9A9A9B9B9B969696878787BBBBBBA3A3A39B9B9BB5B5B5B0B0B0
      AAAAAA7F7F7F4D4D4D8C8C8C83838300FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B69797979797979393938585
      85ACACACB8B8B8B6B6B6B6B6B6B5B5B5BBBBBB7F7F7F4D4D4D8B8B8B838383B5
      B5B500FFFF979797979797939393858585ACACACB8B8B8B6B6B6B6B6B6B5B5B5
      BBBBBB7F7F7F4D4D4D8B8B8B83838300FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6969696A1A1A1A5A5A5A4A4
      A4A4A4A4A2A2A2A2A2A2A2A2A2A2A2A2A3A3A3A2A2A2C3C3C3A7A7A7868686B5
      B5B500FFFF969696A1A1A1A5A5A5A4A4A4A4A4A4A2A2A2A2A2A2A2A2A2A2A2A2
      A3A3A3A2A2A2C3C3C3A7A7A786868600FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6B6B6949494999999A1A1A19C9C
      9CA1A1A19F9F9F9F9F9F9F9F9F9F9F9FA1A1A19C9C9CB9B9B99E9E9E858585B5
      B5B500FFFF949494999999A1A1A19C9C9CA1A1A19F9F9F9F9F9F9F9F9F9F9F9F
      A1A1A19C9C9CB9B9B99E9E9E85858500FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B9B9B99292929595959191918888
      888B8B8B8989898A8A8A8A8A8A8989898B8B8B8888888A8A8A848484828282B8
      B8B800FFFF9292929595959191918888888B8B8B8989898A8A8A8A8A8A898989
      8B8B8B8888888A8A8A84848482828200FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C7C7C78383837979797A7A7A7474
      747777777575757676767676767575757777777575757878787373737D7D7DC6
      C6C600FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D7D7D7C0C0C0B4B4B4B0B0B0AFAF
      AFAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEB0B0B0B3B3B3B0B0B0B0B0B0B0B0B0B0
      B0B000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFFD8D7D7C5C0BCB8B4B0B5B0ACB3AF
      ABB3AEAAB2AEAAB2AEAAB2AEAAB2AEAAB4B0ACB8B4AFB4B0ACB4B0ACB4B0ACB4
      B0AC00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFFB9B9B99494949090908D8D8D8787
      878585858080807F7F7F7D7D7D7A7A7A7878787777777878787C7C7C7D7D7DB0
      B0B000FFFF9494949090908D8D8D8787878585858080807F7F7F7D7D7D7A7A7A
      7878787777777878787C7C7C7D7D7D00FFFFC4BAAFAF9579AE9373AC8F6EA989
      65A78863A4845DA3825BA37F57A27D52A07B519E7A50A17B4FA98050AE824CB4
      B0AC00FFFFAF9579AE9373AC8F6EA98965A78863A4845DA3825BA37F57A27D52
      A07B519E7A50A17B4FA98050AE824C00FFFFB7B7B7B1B1B1BFBFBFB8B8B8ACAC
      ACAAAAAAA3A3A39F9F9F9999999494948989898585859292928A8A8A828282B0
      B0B000FFFFB1B1B1BFBFBFB8B8B8ACACACAAAAAAA3A3A39F9F9F999999949494
      8989898585859292928A8A8A82828200FFFFC7B7A7D2B4910403FD040395DCB3
      7DFE2120872120D7A668046101044901C291500302FB030395BF9256BC8849B4
      B0AC00FFFFD2B4910403FD040395DCB37DFE2120872120D7A668046101044901
      C291500302FB030395BF9256BC884900FFFFB7B7B7B0B0B0BCBCBCB5B5B5A8A8
      A8A7A7A7A0A0A09C9C9C9797979595958989898787878F8F8F8C8C8C7F7F7FB0
      B0B000FFFFB0B0B0BCBCBCB5B5B5A8A8A8A7A7A7A0A0A09C9C9C979797959595
      8989898787878F8F8F8C8C8C7F7F7F00FFFFC7B7A7D2B38E0403FC040395DCB1
      75FE2120872120D7A662046101044901C5924D0302FB030394C39456B88546B4
      B0AC00FFFFD2B38E0403FC040395DCB175FE2120872120D7A662046101044901
      C5924D0302FB030394C39456B8854600FFFFB7B7B7ACACACBABABAB5B5B5AAAA
      AAA5A5A5A0A0A09D9D9D9898989494948B8B8B8080808080807A7A7A7A7A7AB3
      B3B300FFFFACACACBABABAB5B5B5AAAAAAA5A5A5A0A0A09D9D9D989898949494
      8B8B8B8080808080807A7A7A7A7A7A00FFFFC7B7A7D0B1890403FC040395DDB3
      77FE2120872120D8A862046101044901C8964F0302FB030294AA824AB07E44C4
      B4A300FFFFD0B1890403FC040395DDB377FE2120872120D8A862046101044901
      C8964F0302FB030294AA824AB07E4400FFFFB6B6B6A9A9A9B1B1B1BCBCBCB0B0
      B0A1A1A19B9B9B9999999494949090908D8D8D8181818080807777777D7D7DB4
      B4B400FFFFA9A9A9B1B1B1BCBCBCB0B0B0A1A1A19B9B9B999999949494909090
      8D8D8D8181818080807777777D7D7D00FFFFC7B7A6CEAE840403FC040395E1BA
      7FFE2120872120D7A45B046101044901D0994A0302FB030294BB8033B78244C5
      B5A400FFFFCEAE840403FC040395E1BA7FFE2120872120D7A45B046101044901
      D0994A0302FB030294BB8033B7824400FFFFB6B6B6A6A6A6B6B6B6C9C9C9C5C5
      C5B8B8B8B4B4B4B3B3B3B0B0B0AFAFAF9C9C9C8989898C8C8C878787838383B5
      B5B500FFFFA6A6A6B6B6B6C9C9C9C5C5C5B8B8B8B4B4B4B3B3B3B0B0B0AFAFAF
      9C9C9C8989898C8C8C87878783838300FFFFC7B7A6CDAB7F0403FC040496ECCF
      9FFE2221872220E4BD82046102044A02D9A8600402FB040294CD9141BF8948C7
      B6A400FFFFCDAB7F0403FC040496ECCF9FFE2221872220E4BD82046102044A02
      D9A8600402FB040294CD9141BF894800FFFFB6B6B6A3A3A3ACACACB9B9B9AEAE
      AEABABABC0C0C0BFBFBFBDBDBDBBBBBBB7B7B7929292A7A7A78F8F8F848484B5
      B5B500FFFFA3A3A3ACACACB9B9B9AEAEAEABABABC0C0C0BFBFBFBDBDBDBBBBBB
      B7B7B7929292A7A7A78F8F8F84848400FFFFC7B7A6CCA87B0403FC040395E1B8
      7CFE2120872221EACA94046202044A02E7C2880403FB040395D1984DC08A48C7
      B6A400FFFFCCA87B0403FC040395E1B87CFE2120872221EACA94046202044A02
      E7C2880403FB040395D1984DC08A4800FFFFB6B6B69F9F9FA0A0A0B2B2B2A2A2
      A2BDBDBD999999A1A1A19F9F9F898989A7A7A7909090B3B3B3888888838383B5
      B5B500FFFF9F9F9FA0A0A0B2B2B2A2A2A2BDBDBD999999A1A1A19F9F9F898989
      A7A7A7909090B3B3B388888883838300FFFFC7B7A6CAA475D6AB6AE1BC84DCAE
      69FE2221872120DCAD67046101044901DFB4700403FB040395CE9242BF8947C7
      B6A400FFFFCAA475D6AB6AE1BC84DCAE69FE2221872120DCAD67046101044901
      DFB4700403FB040395CE9242BF894700FFFFB6B6B69D9D9DA1A1A19F9F9F9292
      92BDBDBD9999999C9C9C9A9A9A8B8B8BADADAD959595B6B6B68E8E8E838383B5
      B5B500FFFF9D9D9DA1A1A19F9F9F929292BDBDBD9999999C9C9C9A9A9A8B8B8B
      ADADAD959595B6B6B68E8E8E83838300FFFFC7B6A6C9A271D6AC6CD8AA67D49E
      50FE2221872120D9A960D8A65DD19846E2B8780403FB040395D1974BBF8A48C7
      B6A400FFFFC9A271D6AC6CD8AA67D49E50FE2221872120D9A960D8A65DD19846
      E2B8780403FB040395D1974BBF8A4800FFFFB6B6B69A9A9A9B9B9B9696968787
      87BBBBBBA3A3A39B9B9BB5B5B5B0B0B0AAAAAA939393B5B5B58C8C8C838383B5
      B5B500FFFF9A9A9A9B9B9B969696878787BBBBBBA3A3A39B9B9BB5B5B5B0B0B0
      AAAAAA939393B5B5B58C8C8C83838300FFFFC7B6A6C89F6CD4A663D4A158CF94
      40E8C58EDDAF69D9A85EE5C085E3BB7DE1B6730403FB040395D09648C08947C7
      B6A400FFFFC89F6CD4A663D4A158CF9440E8C58EDDAF69D9A85EE5C085E3BB7D
      E1B6730403FB040395D09648C0894700FFFFB6B6B69797979797979393938585
      85ACACACB8B8B8B6B6B6B6B6B6B5B5B5BBBBBB8E8E8EB4B4B48B8B8B838383B5
      B5B500FFFF979797979797939393858585ACACACB8B8B8B6B6B6B6B6B6B5B5B5
      BBBBBB8E8E8EB4B4B48B8B8B83838300FFFFC7B6A5C69D69D2A35DD39E53CE92
      3CE1B877E7C48AE6C187E6C186E6C085E8C68E0403FB040395D09547C08947C7
      B6A400FFFFC69D69D2A35DD39E53CE923CE1B877E7C48AE6C187E6C186E6C085
      E8C68E0403FB040395D09547C0894700FFFFB6B6B6969696A1A1A1A5A5A5A4A4
      A4A4A4A4A2A2A2A2A2A2A2A2A2A2A2A2A3A3A3A2A2A2C3C3C3A7A7A7868686B5
      B5B500FFFF969696A1A1A1A5A5A5A4A4A4A4A4A4A2A2A2A2A2A2A2A2A2A2A2A2
      A3A3A3A2A2A2C3C3C3A7A7A786868600FFFFC7B6A5C69C67D7AC6BDCB06EDDAF
      6BDDB06CDCAE68DCAE69DCAE69DCAE69DDAF6ADCAE68ECCD9BDDB071C18C4CC7
      B6A400FFFFC69C67D7AC6BDCB06EDDAF6BDDB06CDCAE68DCAE69DCAE69DCAE69
      DDAF6ADCAE68ECCD9BDDB071C18C4C00FFFFB6B6B6949494999999A1A1A19C9C
      9CA1A1A19F9F9F9F9F9F9F9F9F9F9F9FA1A1A19C9C9CB9B9B99E9E9E858585B5
      B5B500FFFF949494999999A1A1A19C9C9CA1A1A19F9F9F9F9F9F9F9F9F9F9F9F
      A1A1A19C9C9CB9B9B99E9E9E85858500FFFFC7B6A5C49A64D3A45FDAAC68D9A9
      60DBAC67DAAB64DAAB65DAAB65DAAB64DBAC67D9A85FE7C48CD8A864C08A4BC7
      B6A400FFFFC49A64D3A45FDAAC68D9A960DBAC67DAAB64DAAB65DAAB65DAAB64
      DBAC67D9A85FE7C48CD8A864C08A4B00FFFFB9B9B99292929595959191918888
      888B8B8B8989898A8A8A8A8A8A8989898B8B8B8888888A8A8A848484828282B8
      B8B800FFFF9292929595959191918888888B8B8B8989898A8A8A8A8A8A898989
      8B8B8B8888888A8A8A84848482828200FFFFCAB9A8C39862CF9E5BD09952CD91
      43CF9448CE9245CE9346CE9346CE9245CF9448CE9143CD9247CA8C3FBE8647C9
      B8A700FFFFC39862CF9E5BD09952CD9143CF9448CE9245CE9346CE9346CE9245
      CF9448CE9143CD9247CA8C3FBE864700FFFFC7C7C78383837979797A7A7A7474
      747777777575757676767676767575757777777575757878787373737D7D7DC6
      C6C600FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFFD4C7BAB08557AF7D44B07D44AE78
      3BAF7A3FAE793DAF7A3EAF7A3EAE793DAF7A3FAE783CAF7B41AD763AAE7E4CD4
      C7B900FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF424D3E000000000000003E000000
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
