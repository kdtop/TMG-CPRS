inherited frmReports: TfrmReports
  Left = 356
  Top = 69
  HelpContext = 9000
  Caption = 'Reports Page'
  ClientHeight = 614
  ClientWidth = 717
  HelpFile = 'qnoback'
  Menu = mnuMainMenu
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 733
  ExplicitHeight = 673
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 604
    Width = 717
    Height = 10
    ExplicitTop = 617
    ExplicitWidth = 717
    ExplicitHeight = 10
  end
  inherited sptHorz: TSplitter
    Left = 119
    Height = 604
    OnMoved = sptHorzMoved
    ExplicitLeft = 119
    ExplicitHeight = 617
  end
  inherited pnlLeft: TPanel
    Width = 119
    Height = 604
    ExplicitWidth = 119
    ExplicitHeight = 604
    object Splitter1: TSplitter
      Left = 0
      Top = 126
      Width = 119
      Height = 6
      Cursor = crVSplit
      Align = alBottom
      Color = clBtnFace
      ParentColor = False
      OnCanResize = Splitter1CanResize
      ExplicitTop = 259
    end
    object pnlLefTop: TPanel
      Left = 0
      Top = 0
      Width = 119
      Height = 126
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinWidth = 30
      TabOrder = 0
      object lblTypes: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 119
        Height = 19
        Align = alTop
        Caption = 'Available Reports'
        HorzOffset = 3
        Transparent = True
        VertOffset = 6
        WordWrap = False
        ExplicitTop = -176
      end
      object tvReports: TORTreeView
        Left = 0
        Top = 19
        Width = 119
        Height = 107
        Align = alClient
        HideSelection = False
        Indent = 18
        ReadOnly = True
        TabOrder = 0
        OnClick = tvReportsClick
        OnCollapsing = tvReportsCollapsing
        OnExpanding = tvReportsExpanding
        OnKeyDown = tvReportsKeyDown
        Caption = 'Available Reports'
        NodePiece = 0
      end
    end
    object pnlLeftBottom: TPanel
      Left = 0
      Top = 232
      Width = 119
      Height = 372
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object lblQualifier: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 119
        Height = 13
        Align = alTop
        HorzOffset = 3
        Transparent = True
        VertOffset = 4
        WordWrap = False
      end
      object lblHeaders: TLabel
        Left = 0
        Top = 13
        Width = 119
        Height = 13
        Align = alTop
        Caption = 'Headings'
        Transparent = True
        Visible = False
        ExplicitWidth = 45
      end
      object lstHeaders: TORListBox
        Left = 0
        Top = 26
        Width = 119
        Height = 346
        Align = alClient
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = lstHeadersClick
        Caption = 'Headings'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object lstQualifier: TORListBox
        Left = 0
        Top = 26
        Width = 119
        Height = 346
        Style = lbOwnerDrawFixed
        Align = alClient
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = lstQualifierClick
        OnDrawItem = lstQualifierDrawItem
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPositions = '10'
      end
      object pnlViews: TORAutoPanel
        Left = 0
        Top = 26
        Width = 119
        Height = 346
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 3
        Visible = False
        object pnlTopViews: TPanel
          Left = 0
          Top = 0
          Width = 119
          Height = 80
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            119
            80)
          object lblDateRange: TLabel
            Left = 0
            Top = 63
            Width = 58
            Height = 13
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Date Range'
          end
          object chkDualViews: TCheckBox
            Left = 0
            Top = 0
            Width = 121
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Split Views'
            TabOrder = 0
            OnClick = chkDualViewsClick
          end
          object btnGraphSelections: TORAlignButton
            Left = 0
            Top = 20
            Width = 119
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Select/Define...'
            TabOrder = 1
            OnClick = btnGraphSelectionsClick
          end
          object btnChangeView: TORAlignButton
            Left = 0
            Top = 41
            Width = 119
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Settings...'
            TabOrder = 2
            OnClick = btnChangeViewClick
          end
        end
        object lstDateRange: TORListBox
          Left = 0
          Top = 80
          Width = 119
          Height = 266
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
          TabOrder = 1
          OnClick = lstDateRangeClick
          Caption = ''
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
          TabPositions = '10'
        end
      end
    end
    object pnlProcedures: TPanel
      Left = 0
      Top = 132
      Width = 119
      Height = 100
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object lblProcedures: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 119
        Height = 15
        Align = alTop
        Caption = 'Radiology Procedures'
        Color = clBtnFace
        HorzOffset = 2
        ParentColor = False
        Transparent = False
        VertOffset = 2
        WordWrap = False
      end
      object tvProcedures: TORTreeView
        Left = 0
        Top = 15
        Width = 119
        Height = 85
        Align = alClient
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        OnChange = tvProceduresChange
        OnClick = tvProceduresClick
        OnCollapsing = tvProceduresCollapsing
        OnExpanding = tvProceduresExpanding
        OnKeyDown = tvProceduresKeyDown
        Caption = 'tvProcedures'
        NodePiece = 0
      end
    end
  end
  inherited pnlRight: TPanel
    Left = 123
    Width = 594
    Height = 604
    ExplicitLeft = 123
    ExplicitWidth = 594
    ExplicitHeight = 604
    object sptHorzRight: TSplitter
      Left = 0
      Top = 177
      Width = 594
      Height = 4
      Cursor = crVSplit
      Align = alTop
      Visible = False
      OnCanResize = sptHorzRightCanResize
      OnMoved = sptHorzRightMoved
    end
    object pnlRightTop: TPanel
      Left = 0
      Top = 0
      Width = 594
      Height = 57
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblProcTypeMsg: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 594
        Height = 17
        Align = alTop
        HorzOffset = 3
        Transparent = False
        VertOffset = 2
        WordWrap = False
        ExplicitWidth = 529
      end
      object TabControl1: TTabControl
        Left = 0
        Top = 40
        Width = 594
        Height = 20
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HotTrack = True
        ParentFont = False
        Style = tsButtons
        TabHeight = 16
        TabOrder = 0
        TabStop = False
        Visible = False
        OnChange = TabControl1Change
      end
      object pnlTopRtLabel: TPanel
        Left = 0
        Top = 17
        Width = 594
        Height = 23
        Align = alTop
        TabOrder = 1
        object lblTitle: TOROffsetLabel
          Left = 1
          Top = 1
          Width = 495
          Height = 21
          Align = alClient
          HorzOffset = 3
          Transparent = True
          VertOffset = 6
          WordWrap = False
          ExplicitWidth = 312
          ExplicitHeight = 26
        end
        object chkMaxFreq: TCheckBox
          Left = 496
          Top = 1
          Width = 97
          Height = 21
          Align = alRight
          Caption = 'Max/Site OFF'
          TabOrder = 0
          Visible = False
          OnClick = chkMaxFreqClick
        end
      end
    end
    object pnlRightBottom: TPanel
      Left = 0
      Top = 181
      Width = 594
      Height = 423
      Align = alClient
      TabOrder = 2
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 592
        Height = 30
        TabStop = False
        Align = alTop
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        Visible = False
        WantTabs = True
        OnKeyUp = Memo1KeyUp
      end
      object memText: TRichEdit
        Left = 1
        Top = 295
        Width = 592
        Height = 127
        Align = alBottom
        Color = clCream
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 20
        ParentFont = False
        PlainText = True
        PopupMenu = PopupMenu1
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        Visible = False
        WantReturns = False
        WordWrap = False
      end
      object pnlWebHolder: TPanel
        Left = 1
        Top = 31
        Width = 592
        Height = 264
        Align = alClient
        TabOrder = 2
        ExplicitLeft = 24
        ExplicitTop = 77
        ExplicitWidth = 553
        ExplicitHeight = 188
        object WebBrowser1: TWebBrowser
          Left = 1
          Top = 19
          Width = 590
          Height = 244
          TabStop = False
          Align = alClient
          TabOrder = 0
          OnBeforeNavigate2 = WebBrowser1BeforeNavigate2
          OnDocumentComplete = WebBrowser1DocumentComplete
          ExplicitLeft = 72
          ExplicitTop = 40
          ExplicitWidth = 424
          ExplicitHeight = 131
          ControlData = {
            4C000000FA3C0000381900000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object pnlWebTop: TPanel
          Left = 1
          Top = 1
          Width = 590
          Height = 18
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 4
          ExplicitWidth = 551
          object btnWBZoomOut: TSpeedButton
            Left = 40
            Top = 0
            Width = 18
            Height = 18
            Hint = 'Zoom Out'
            Flat = True
            Glyph.Data = {
              42040000424D4204000000000000420000002800000010000000100000000100
              20000300000000040000130B0000130B00000000000000000000000000FF0000
              FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC29B87FFC0A382FFC0A382FFC0A382FFC0
              A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF0DECBFFF0DECBFFF0DECBFFF0
              DECBFFF0DECBFFF0DECBFFF0DECBFFF0DECBFFF0DECBFFF0DECBFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFEAD2B8FFEAD2B8FFEAD2B8FFEA
              D2B8FFEAD2B8FFEAD2B8FFEAD2B8FFEAD2B8FFEAD2B8FFEAD2B8FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE7CAABFFE7CAABFFE7CAABFFE7
              CAABFFE7CAABFFE7CAABFFE7CAABFFE7CAABFFE7CAABFFE7CAABFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFDEBD9AFFD6B189FFD6
              B189FFD6B189FFD6B189FFD6B189FFD6B189FFDCBB96FFE5C6A4FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFD1AE87FFFEFDFCFFFE
              FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFD1AE87FFE5C6A4FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF1DFCDFFDBC2A7FFFEFDFCFFFE
              FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFDDC5ACFFF1DFCDFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF3E5D7FFECDCCBFFE6D2BEFFE5
              D0BAFFE5D0BAFFE5D0BAFFE5D0BAFFE5D0BAFFEAD9C7FFF3E5D8FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF7EEE5FFF7EEE5FFF7EEE5FFF7
              EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFF7EEE5FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFBF6F2FFFAF3EDFFFAF4EEFFFA
              F4EEFFFAF4EEFFFAF4EEFFFAF4EEFFFAF4EEFFFAF4EEFFFBF6F2FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFEFCFBFFFDFBF9FFFDFBF8FFFD
              FAF8FFFDFAF8FFFDFAF8FFFDFAF8FFFDFBF8FFFDFBF9FFFEFCFBFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
              A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FF}
            ParentShowHint = False
            ShowHint = True
            OnClick = btnWBZoomOutClick
          end
          object btnWBNormalZoom: TSpeedButton
            Left = 20
            Top = 0
            Width = 18
            Height = 18
            Hint = 'View Normal Size'
            Flat = True
            Glyph.Data = {
              42040000424D4204000000000000420000002800000010000000100000000100
              20000300000000040000130B0000130B00000000000000000000000000FF0000
              FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
              A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF0DECBFFEAD2B8FFE7CAABFFE5
              C6A4FFE5C6A4FFE5C6A4FFE5C6A4FFE7CAABFFEAD2B8FFF0DECBFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFEAD2B8FFE4C4A2FFE7CCAEFFEA
              D8C4FFE8D6C3FFE8D6C3FFEAD8C4FFE7CCAEFFE4C4A2FFEAD2B8FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE7CAABFFE7CCAEFFF6EBE0FFFE
              FEFEFFFEFEFEFFFEFEFEFFFEFEFEFFF6EBE0FFE7CCAEFFE7CAABFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFEAD8C4FFFEFEFEFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFEAD8C4FFE5C6A4FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFE8D6C3FFFEFEFEFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFE8D6C3FFE5C6A4FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF1DFCDFFEDE0D3FFFEFEFEFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFEDE0D3FFF1DFCDFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF3E5D7FFF2E7DCFFFEFEFEFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFF2E7DCFFF3E5D7FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF7EEE5FFF7EEE5FFFCF8F5FFFE
              FEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFCF8F5FFF7EEE5FFF7EEE5FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFBF6F2FFFAF4EEFFFBF5F0FFF5
              EFE8FFF0E8DFFFF0E8DFFFF5EFE8FFFBF5F0FFFAF4EEFFFBF6F2FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFEFCFBFFFDFBF9FFFDFBF8FFFD
              FAF8FFFDFAF8FFFDFAF8FFFDFAF8FFFDFBF8FFFDFBF9FFFEFCFBFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
              A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FF}
            ParentShowHint = False
            ShowHint = True
            OnClick = btnWBNormalZoomClick
          end
          object btnWBZoomIn: TSpeedButton
            Left = 0
            Top = 0
            Width = 18
            Height = 18
            Hint = 'Zoom In'
            Flat = True
            Glyph.Data = {
              42040000424D4204000000000000420000002800000010000000100000000100
              20000300000000040000130B0000130B00000000000000000000000000FF0000
              FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
              A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF0DECBFFEAD2B8FFE7CAABFFE5
              C6A4FFE5C6A4FFE5C6A4FFE5C6A4FFE7CAABFFEAD2B8FFF0DECBFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFEAD2B8FFE4C4A2FFDFBB93FFD6
              B189FFD1AE87FFD1AE87FFD6B189FFDFBB93FFE4C4A2FFEAD2B8FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE7CAABFFDFBB93FFDBB083FFCE
              A87DFFFEFDFCFFFEFDFCFFCEA87DFFDBB083FFDFBB93FFE7CAABFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFD6B189FFCEA87DFFCD
              A578FFFEFDFCFFFEFDFCFFCDA578FFCEA87DFFD6B189FFE5C6A4FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFE5C6A4FFD1AE87FFFEFDFCFFFE
              FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFD1AE87FFE5C6A4FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF1DFCDFFDBC2A7FFFEFDFCFFFE
              FDFCFFFEFDFCFFFEFDFCFFFEFDFCFFFEFDFCFFDBC2A7FFF1DFCDFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF3E5D7FFE5D0BAFFDCC3AAFFDB
              C2A8FFFEFDFCFFFEFDFCFFDBC2A8FFDCC3AAFFE5D0BAFFF3E5D7FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFF7EEE5FFF5E9DDFFF4E6D8FFDF
              CBB4FFFEFDFCFFFEFDFCFFDFCBB4FFF4E6D8FFF5E9DDFFF7EEE5FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFBF6F2FFFAF4EEFFFAF2EBFFEB
              DFD1FFE2D2C0FFE2D2C0FFEBDFD1FFFAF2EBFFFAF4EEFFFBF6F2FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFFEFCFBFFFDFBF9FFFDFBF8FFFD
              FAF8FFFDFAF8FFFDFAF8FFFDFAF8FFFDFBF8FFFDFBF9FFFEFCFBFFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFC0A382FFC0A382FFC0A382FFC0A382FFC0
              A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFC0A382FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
              00FFFFFF00FF}
            ParentShowHint = False
            ShowHint = True
            OnClick = btnWBZoomInClick
          end
        end
      end
    end
    object pnlRightMiddle: TPanel
      Left = 0
      Top = 57
      Width = 594
      Height = 120
      Align = alTop
      Constraints.MaxHeight = 700
      Constraints.MinHeight = 50
      TabOrder = 1
      Visible = False
      object lvReports: TCaptionListView
        Left = 1
        Top = 1
        Width = 592
        Height = 118
        Hint = 'To sort, click on column headers|'
        Align = alClient
        Columns = <>
        Constraints.MinHeight = 50
        HideSelection = False
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        PopupMenu = PopupMenu2
        ShowHint = True
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = lvReportsColumnClick
        OnCompare = lvReportsCompare
        OnDrawItem = lvReportsDrawItem
        OnKeyUp = lvReportsKeyUp
        OnSelectItem = lvReportsSelectItem
        AutoSize = False
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 280
    Data = (
      (
        'Component = pnlLefTop'
        'Status = stsDefault')
      (
        'Component = tvReports'
        'Status = stsDefault')
      (
        'Component = pnlLeftBottom'
        'Status = stsDefault')
      (
        'Component = lstHeaders'
        'Status = stsDefault')
      (
        'Component = lstQualifier'
        'Status = stsDefault')
      (
        'Component = pnlViews'
        'Status = stsDefault')
      (
        'Component = pnlTopViews'
        'Status = stsDefault')
      (
        'Component = chkDualViews'
        'Status = stsDefault')
      (
        'Component = btnGraphSelections'
        'Status = stsDefault')
      (
        'Component = btnChangeView'
        'Status = stsDefault')
      (
        'Component = lstDateRange'
        'Status = stsDefault')
      (
        'Component = pnlProcedures'
        'Status = stsDefault')
      (
        'Component = tvProcedures'
        'Status = stsDefault')
      (
        'Component = pnlRightTop'
        'Status = stsDefault')
      (
        'Component = TabControl1'
        'Status = stsDefault')
      (
        'Component = pnlRightBottom'
        'Status = stsDefault')
      (
        'Component = WebBrowser1'
        'Status = stsDefault')
      (
        'Component = Memo1'
        'Status = stsDefault')
      (
        'Component = memText'
        'Status = stsDefault')
      (
        'Component = pnlRightMiddle'
        'Status = stsDefault')
      (
        'Component = lvReports'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmReports'
        'Status = stsDefault')
      (
        'Component = pnlTopRtLabel'
        'Status = stsDefault')
      (
        'Component = chkMaxFreq'
        'Status = stsDefault')
      (
        'Component = pnlWebHolder'
        'Status = stsDefault')
      (
        'Component = pnlWebTop'
        'Status = stsDefault'))
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 173
    Top = 168
    object Print2: TMenuItem
      Caption = 'Print'
      ShortCut = 16464
      OnClick = Print2Click
    end
    object Copy2: TMenuItem
      Caption = 'Copy'
      ShortCut = 16451
      OnClick = Copy2Click
    end
    object SelectAll2: TMenuItem
      Caption = 'Select All'
      ShortCut = 16449
      OnClick = SelectAll2Click
    end
    object GotoTop1: TMenuItem
      Caption = 'Go to Top'
      OnClick = GotoTop1Click
    end
    object GotoBottom1: TMenuItem
      Caption = 'Go to Bottom'
      OnClick = GotoBottom1Click
    end
    object FreezeText1: TMenuItem
      Caption = 'Freeze Text'
      Enabled = False
      OnClick = FreezeText1Click
    end
    object UnFreezeText1: TMenuItem
      Caption = 'Un-Freeze Text'
      Enabled = False
      OnClick = UnFreezeText1Click
    end
    object mnuCreateResultNote: TMenuItem
      Caption = 'Create Result Note'
      ShortCut = 16462
      OnClick = mnuCreateResultNoteClick
    end
    object mnuNotifyOk1: TMenuItem
      Caption = 'Notify OK'
      ShortCut = 16463
      OnClick = mnuNotifyOKClick
    end
    object mnuSendAlert: TMenuItem
      Caption = 'Send Imaging Alert'
      ShortCut = 16457
      OnClick = mnuSendAlertClick
    end
    object mnuCopyResultsTable1: TMenuItem
      Caption = 'Copy Results Table'
      ShortCut = 16466
      OnClick = mnuCopyResultsTable1Click
    end
    object mnuViewInBrowser: TMenuItem
      Caption = 'View In Browser'
      ShortCut = 16450
      OnClick = mnuViewInBrowserClick
    end
    object mnuViewHL7: TMenuItem
      Caption = 'View HL7 Messages'
      ShortCut = 16456
      OnClick = mnuViewHL7Click
    end
    object mnuDeleteOneStudy: TMenuItem
      Caption = 'Delete This Study'
      ShortCut = 16452
      OnClick = mnuDeleteOneStudyClick
    end
  end
  object calApptRng: TORDateRangeDlg
    DateOnly = False
    Instruction = 'Enter a date range -'
    LabelStart = 'Begin Date'
    LabelStop = 'End Date'
    RequireTime = False
    Format = 'mmm d,yy@hh:nn'
    Left = 325
    Top = 176
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 389
    Top = 176
  end
  object PopupMenu2: TPopupMenu
    Left = 267
    Top = 158
    object Print1: TMenuItem
      Caption = 'Print'
      ShortCut = 16464
      OnClick = Print1Click
    end
    object Copy1: TMenuItem
      Caption = 'Copy Data From Table'
      ShortCut = 16451
      OnClick = Copy1Click
    end
    object SelectAll1: TMenuItem
      Caption = 'Select All From Table'
      ShortCut = 16449
      OnClick = SelectAll1Click
    end
    object mnuCopyResultsTable: TMenuItem
      Caption = 'Copy Results Table'
      ShortCut = 16468
      OnClick = mnuCopyResultsTableClick
    end
  end
  object imgLblImages: TVA508ImageListLabeler
    Components = <
      item
        Component = lvReports
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblImages
    Left = 344
  end
  object mnuMainMenu: TMainMenu
    Left = 160
    Top = 8
    object mnuAction: TMenuItem
      Caption = 'Action'
      GroupIndex = 4
      object mnuCreateReportNote: TMenuItem
        Caption = 'Create Report Note'
        ShortCut = 16462
        OnClick = mnuCreateResultNoteClick
      end
      object mnuNotifyOK: TMenuItem
        Caption = 'Notify OK'
        ShortCut = 16463
        OnClick = mnuNotifyOKClick
      end
    end
  end
end
