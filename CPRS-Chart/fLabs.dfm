inherited frmLabs: TfrmLabs
  Left = 628
  Top = 237
  HelpContext = 8000
  Caption = 'Laboratory Results Page'
  ClientHeight = 794
  ClientWidth = 876
  HelpFile = 'qnoback'
  Menu = mnuLabs
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 892
  ExplicitHeight = 852
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 789
    Width = 876
    ExplicitTop = 748
    ExplicitWidth = 714
  end
  inherited sptHorz: TSplitter
    Height = 789
    ExplicitHeight = 748
  end
  object Label1: TLabel [2]
    Left = 144
    Top = 88
    Width = 3
    Height = 13
    Visible = False
  end
  object Label2: TLabel [3]
    Left = 128
    Top = 88
    Width = 3
    Height = 13
    Visible = False
  end
  inherited pnlLeft: TPanel
    Height = 789
    Constraints.MinWidth = 37
    ExplicitHeight = 789
    object Splitter1: TSplitter
      Left = 0
      Top = 529
      Width = 97
      Height = 10
      Cursor = crVSplit
      Align = alBottom
      Color = clBtnFace
      ParentColor = False
      OnCanResize = Splitter1CanResize
      ExplicitTop = 488
      ExplicitWidth = 79
    end
    object pnlLefTop: TPanel
      Left = 0
      Top = 0
      Width = 97
      Height = 529
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinWidth = 30
      TabOrder = 0
      object lblReports: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 97
        Height = 19
        Align = alTop
        Caption = 'Lab Results'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
        ExplicitWidth = 79
      end
      object tvReports: TORTreeView
        Left = 0
        Top = 19
        Width = 97
        Height = 510
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
      Top = 539
      Width = 97
      Height = 250
      Align = alBottom
      TabOrder = 1
      object lblQualifier: TOROffsetLabel
        Left = 1
        Top = 1
        Width = 95
        Height = 21
        Align = alTop
        HorzOffset = 3
        Transparent = True
        VertOffset = 4
        Visible = False
        WordWrap = False
        ExplicitWidth = 77
      end
      object lblHeaders: TOROffsetLabel
        Left = 1
        Top = 120
        Width = 95
        Height = 17
        Align = alTop
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
        ExplicitWidth = 77
      end
      object lblDates: TOROffsetLabel
        Left = 1
        Top = 105
        Width = 95
        Height = 15
        Align = alTop
        Caption = 'Date Range'
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
        ExplicitWidth = 77
      end
      object lstQualifier: TORListBox
        Left = 1
        Top = 137
        Width = 95
        Height = 112
        Align = alClient
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = lstQualifierClick
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPositions = '10'
      end
      object lstHeaders: TORListBox
        Left = 1
        Top = 55
        Width = 95
        Height = 50
        Align = alTop
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Visible = False
        OnClick = lstHeadersClick
        Caption = 'Headings'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object lstDates: TORListBox
        Left = 1
        Top = 137
        Width = 95
        Height = 112
        Align = alClient
        ItemHeight = 13
        Items.Strings = (
          'S^Date Range...'
          '1^Today'
          '8^One Week'
          '15^Two Weeks'
          '31^One Month'
          '183^Six Months'
          '366^One Year'
          '732^Two Years'
          '50000^All Results')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Visible = False
        OnClick = lstDatesClick
        Caption = 'Date Range'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object pnlOtherTests: TORAutoPanel
        Left = 1
        Top = 22
        Width = 95
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 5
        object bvlOtherTests: TBevel
          Left = 3
          Top = 31
          Width = 90
          Height = 2
        end
        object cmdOtherTests: TButton
          Left = 11
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Other Tests'
          TabOrder = 0
          OnClick = cmdOtherTestsClick
        end
      end
    end
  end
  inherited pnlRight: TPanel
    Width = 775
    Height = 789
    Constraints.MinWidth = 30
    OnResize = pnlRightResize
    ExplicitWidth = 775
    ExplicitHeight = 789
    object sptHorzRight: TSplitter
      Left = 0
      Top = 296
      Width = 775
      Height = 4
      Cursor = crVSplit
      Align = alTop
      Visible = False
      OnCanResize = sptHorzRightCanResize
      OnMoved = sptHorzRightMoved
      ExplicitWidth = 613
    end
    object pnlRightBottom: TPanel
      Left = 0
      Top = 300
      Width = 775
      Height = 469
      Align = alClient
      TabOrder = 0
      object Memo1: TMemo
        Left = 1
        Top = 1
        Width = 773
        Height = 19
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          '')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        Visible = False
        WantTabs = True
        WordWrap = False
        OnKeyUp = Memo1KeyUp
      end
      object memLab: TRichEdit
        Left = 1
        Top = 20
        Width = 773
        Height = 448
        Align = alClient
        Color = clCream
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        PopupMenu = PopupMenu3
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        Visible = False
        WantReturns = False
        WordWrap = False
      end
      object WebBrowser1: TWebBrowser
        Left = 1
        Top = 20
        Width = 773
        Height = 448
        TabStop = False
        Align = alClient
        TabOrder = 2
        OnDocumentComplete = WebBrowser1DocumentComplete
        ExplicitWidth = 618
        ExplicitHeight = 412
        ControlData = {
          4C000000E44F00004D2E00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object pnlRightTop: TPanel
      Left = 0
      Top = 45
      Width = 775
      Height = 251
      Align = alTop
      TabOrder = 1
      object bvlHeader: TBevel
        Left = 1
        Top = 61
        Width = 773
        Height = 1
        Align = alTop
        ExplicitWidth = 612
      end
      object pnlHeader: TORAutoPanel
        Left = 1
        Top = 1
        Width = 773
        Height = 60
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblDateFloat: TLabel
          Left = 396
          Top = 4
          Width = 56
          Height = 13
          Caption = 'lblDateFloat'
          Visible = False
        end
        object pnlWorksheet: TORAutoPanel
          Left = 0
          Top = 0
          Width = 773
          Height = 60
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object chkValues: TCheckBox
            Left = 404
            Top = 39
            Width = 93
            Height = 17
            Caption = 'Values'
            Enabled = False
            TabOrder = 5
            OnClick = chkValuesClick
          end
          object chk3D: TCheckBox
            Left = 329
            Top = 39
            Width = 56
            Height = 17
            Caption = '3D'
            Enabled = False
            TabOrder = 4
            OnClick = chk3DClick
          end
          object ragHorV: TRadioGroup
            Left = 12
            Top = 0
            Width = 213
            Height = 36
            Caption = 'Table Format '
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              '&Horizontal'
              '&Vertical')
            TabOrder = 0
            OnClick = ragHorVClick
          end
          object chkAbnormals: TCheckBox
            Left = 12
            Top = 39
            Width = 221
            Height = 17
            Caption = 'Abnormal Results Only'
            TabOrder = 2
            OnClick = ragHorVClick
          end
          object ragCorG: TRadioGroup
            Left = 252
            Top = 0
            Width = 213
            Height = 36
            Caption = 'Other Formats '
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              '&Comments'
              '&Graph')
            TabOrder = 1
            OnClick = ragCorGClick
          end
          object chkZoom: TCheckBox
            Left = 253
            Top = 39
            Width = 68
            Height = 17
            Caption = 'Zoom'
            Enabled = False
            TabOrder = 3
            OnClick = chkZoomClick
          end
        end
        object pnlGraph: TORAutoPanel
          Left = 0
          Top = 0
          Width = 773
          Height = 60
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          object lblGraphInfo: TLabel
            Left = 0
            Top = 47
            Width = 773
            Height = 13
            Align = alBottom
            Caption = 
              'To Zoom, hold down the mouse button while dragging an area to be' +
              ' enlarged.'
            ExplicitWidth = 367
          end
          object chkGraph3D: TCheckBox
            Left = 162
            Top = 13
            Width = 61
            Height = 17
            Caption = '3D'
            TabOrder = 1
            OnClick = chkGraph3DClick
          end
          object chkGraphValues: TCheckBox
            Left = 276
            Top = 13
            Width = 101
            Height = 17
            Caption = 'Values'
            TabOrder = 2
            OnClick = chkGraphValuesClick
          end
          object chkGraphZoom: TCheckBox
            Left = 48
            Top = 13
            Width = 97
            Height = 17
            Caption = 'Zoom'
            TabOrder = 0
            OnClick = chkGraphZoomClick
          end
        end
        object pnlButtons: TORAutoPanel
          Left = 0
          Top = 0
          Width = 773
          Height = 60
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            773
            60)
          object lblOld: TOROffsetLabel
            Left = 4
            Top = 6
            Width = 41
            Height = 15
            Caption = 'Oldest'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            WordWrap = False
          end
          object lblPrev: TOROffsetLabel
            Left = 48
            Top = 6
            Width = 49
            Height = 15
            Caption = 'Previous'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            Visible = False
            WordWrap = False
          end
          object lblNext: TOROffsetLabel
            Left = 246
            Top = 6
            Width = 31
            Height = 15
            Caption = 'Next'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            Visible = False
            WordWrap = False
          end
          object lblRecent: TOROffsetLabel
            Left = 287
            Top = 6
            Width = 46
            Height = 15
            Caption = 'Newest'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            WordWrap = False
          end
          object lblMostRecent: TLabel
            Left = 361
            Top = 16
            Width = 144
            Height = 13
            Caption = 'Most Recent Lab Results'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblSample: TLabel
            Left = 1
            Top = 42
            Width = 64
            Height = 13
            Caption = 'Specimen: '
            Color = clWindow
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
          end
          object lblFirstSeen: TLabel
            Left = 516
            Top = 42
            Width = 3
            Height = 13
            Anchors = [akTop, akRight]
            ExplicitLeft = 361
          end
          object lblDate: TVA508StaticText
            Name = 'lblDate'
            Left = 150
            Top = 2
            Width = 7
            Height = 15
            Alignment = taCenter
            AutoSize = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            Visible = False
            OnEnter = lblDateEnter
            ShowAccelChar = True
          end
          object cmdNext: TButton
            Left = 191
            Top = 10
            Width = 82
            Height = 25
            Caption = 'Next >'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            OnClick = cmdNextClick
          end
          object cmdPrev: TButton
            Left = 87
            Top = 10
            Width = 82
            Height = 25
            Caption = '< Previous'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = cmdPrevClick
          end
          object cmdRecent: TButton
            Left = 279
            Top = 10
            Width = 76
            Height = 25
            Caption = 'Newest >>'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
            OnClick = cmdRecentClick
          end
          object cmdOld: TButton
            Left = 5
            Top = 10
            Width = 76
            Height = 25
            Caption = '<< Oldest'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            OnClick = cmdOldClick
          end
          object btnViewReport: TBitBtn
            Left = 541
            Top = 10
            Width = 116
            Height = 30
            Caption = 'View Report'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
            OnClick = btnViewReportClick
            Glyph.Data = {
              E6050000424DE605000000000000A60300002800000018000000180000000100
              08000000000040020000130B0000130B0000DC000000DC00000000000000FFFF
              FF002E1EBF00EAE9F9002718BD003C2EC4007268D400B5B0E800B7B2E900C2BE
              EC00C4C0ED00BDBADD00E0DEF600EDECFA00EFEEFA00F1F0FB00F0EFFA001807
              B800200FBB002110BB002211BB002312BC002413BC002313BB002615BD002515
              BC002716C1002817C2002717BD002A19C7002918BD002A19BE002919BE002A19
              BD002D1CC6002C1BBE002B1BBE002C1CBF002F1FBF003020C0002C1EA5002016
              73003727C2003728C2003124AA00392AC2004031C4004133C5004334C5004335
              C7004638C700483AC7004A3CC8004D3FC8004E40C8004C3FC6004F42CA005043
              CA004F42C9003A308D005649CB005A4DCC005B4FCD005E51CD006155CF006D62
              D3006F63D3007165D3007166D300756AD500766CD500776DD6007B71D7007D73
              D7008379D900837AD900867DDA008A81DD008980DB008C83DE008C83DD008B82
              DB008D84DE008F86E0008D84DC00928ADE00978EDF009C94E200A099E200A29B
              E300ACA5E500B0AAE700B3ADE800B2ACE700B5AFE800B7B1E900B9B3E900BCB7
              EB00BFBAEC00CAC6EF00D0CCF000DDDAF500DCD9F400E4E2F700E7E5F800E8E6
              F800F4F3FD00F5F4FC00EEECFA00EDEBF9004140460007060B0008070C000C0B
              10000D0C110019181D0008070B000B0A0E000E0D110014131700151418001615
              190017161A0018171B001A191D001C1B1F001E1D21001F1E2200201F23002120
              240022212500242327002524280028272B002A292D002D2C3000302F33002E2D
              31003433370039383C003B3A3E003A393D0036353800353437003D3C3F004241
              440041404300403F42003F3E41004443460052515400504F52004F4E51004B4A
              4D0059585B006766690066656800646366009796990083828500131116003937
              3B0023222400A6A5A700A2A1A3009B9A9C009A999B00939294008B8A8C008180
              8200B4B3B500AFAEB000AAA9AB009593960042414200FCFBFC00E3E2E300D4D3
              D400CCCBCC0023231E002B2B2500FAFAF900DADBD200F3F4EE00FEFFFC002222
              2800222226002F2F3200414144005151540057575A00565659005E5E6100E1E1
              E500FBFBFE00F7F7FA00A5A5A700FEFEFF00FDFDFE00CCCCCD00CBCBCC00C7C7
              C800C3C3C400B5B5B600ADADAE00ABABAC00AAAAAB00A4A4A50096969700FCFC
              FC00FBFBFB00F8F8F800F7F7F700F5F5F500F3F3F300F1F1F100EFEFEF00EBEB
              EB00E5E5E500D4D4D40054020202020202020202020202020202020224310BB7
              01012323261C190202021C161515022415230202021D29B4A7C502021C4B5927
              23044C600848163E08341E0202223BB375A60202165F6921181962016D014A42
              013D1702021453B681900202160710403012096C2E686345013F1F2602135201
              948A0202165B01016D2F610F25636548010E0C331E135001938E02021607033D
              6B51070D026664460156432A23134F01938E0202165E0E49C64E5CC207015841
              015506321F134F01938E0202165A01010E325D0101672F420101014415134F01
              938E2402252F36362F203036352B1C2D3535352B25134D01938E05131C161B1A
              151C151313160419131313191C115701938E0A3C3837282C3A39393939393939
              3939393935476AB8938E01C601C1B96EC301C5C5C5C5C5C2C2C2C2C2C20101D2
              938E010101DAA2AEAF01B5B5B5B5B5C501010101010101D2938E010101DABA91
              01A6979A9A9A96C90101C5D6D8D8D7D9908E010101DABA9101C9ADA6A6A69EB0
              01B0C086BA8384897E8C010101DABA9101A598BEBEBFBDC7019870959C9D9B86
              778B010101DABABCD201010101010101CA7699D30101CB7A7DCC010101DABABC
              D201010101010101AC6FA90101A57987C801010101DA8291D201010101010101
              CE6F9F01D07185B10101010101DA8092D201010101010101CD74A8C4727CAA01
              0101010101D4A173ABD1D5D5D5D5D501CFA08C7389B20101010101010101A472
              7B8C8D8D8D8D8D8C887F78BBDB01010101010101010101A38F7A7C7C7C7C7C7C
              7D7EBAC9010101010101}
          end
        end
      end
      object grdLab: TCaptionStringGrid
        Left = 1
        Top = 62
        Width = 773
        Height = 33
        Align = alTop
        Color = clCream
        DefaultRowHeight = 15
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
        ParentFont = False
        PopupMenu = popTMGGridPopup
        TabOrder = 1
        Visible = False
        OnClick = grdLabClick
        OnDrawCell = grdLabDrawCell
        OnMouseDown = grdLabMouseDown
        OnMouseUp = grdLabMouseUp
        OnMouseWheelDown = grdLabMouseWheelDown
        OnTopLeftChanged = grdLabTopLeftChanged
        Caption = 'Laboratory Results'
        ColWidths = (
          64
          64
          64
          64
          64)
        RowHeights = (
          15
          15)
      end
      object pnlChart: TPanel
        Left = 1
        Top = 95
        Width = 773
        Height = 85
        Align = alTop
        BevelOuter = bvNone
        Caption = 'no results to graph'
        TabOrder = 2
        Visible = False
        object lblGraph: TLabel
          Left = 0
          Top = 72
          Width = 370
          Height = 13
          Alignment = taCenter
          Caption = 
            'Results may be available, but cannot be graphed. Please try an a' +
            'lternate view.'
        end
        object lstTestGraph: TORListBox
          Left = 0
          Top = 0
          Width = 97
          Height = 85
          Align = alLeft
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = lstTestGraphClick
          Caption = 'Tests Graphed'
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
        end
        object chtChart: TChart
          Left = 97
          Top = 0
          Width = 676
          Height = 85
          AllowPanning = pmNone
          AllowZoom = False
          BackWall.Brush.Color = clWhite
          BackWall.Brush.Style = bsClear
          Title.Text.Strings = (
            'test name')
          Title.Visible = False
          OnClickLegend = chtChartClickLegend
          OnClickSeries = chtChartClickSeries
          OnUndoZoom = chtChartUndoZoom
          LeftAxis.Title.Caption = 'units'
          Legend.Alignment = laTop
          Legend.Inverted = True
          Legend.ShadowSize = 2
          View3D = False
          Align = alClient
          BevelOuter = bvNone
          Color = clSilver
          PopupMenu = popChart
          TabOrder = 1
          OnMouseDown = chtChartMouseDown
          object serHigh: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clRed
            Title = 'Ref High'
            LinePen.Style = psDash
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Multiplier = 1.000000000000000000
            XValues.Order = loAscending
            YValues.DateTime = False
            YValues.Name = 'Y'
            YValues.Multiplier = 1.000000000000000000
            YValues.Order = loNone
          end
          object serLow: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clRed
            Title = 'Ref Low'
            LinePen.Style = psDash
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.DateTime = False
            XValues.Name = 'X'
            XValues.Multiplier = 1.000000000000000000
            XValues.Order = loAscending
            YValues.DateTime = False
            YValues.Name = 'Y'
            YValues.Multiplier = 1.000000000000000000
            YValues.Order = loNone
          end
          object serTest: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clBlue
            Title = 'Lab Test'
            Pointer.InflateMargins = True
            Pointer.Style = psCircle
            Pointer.Visible = True
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Multiplier = 1.000000000000000000
            XValues.Order = loAscending
            YValues.DateTime = False
            YValues.Name = 'Y'
            YValues.Multiplier = 1.000000000000000000
            YValues.Order = loNone
          end
        end
      end
      object lvReports: TCaptionListView
        Left = 1
        Top = 180
        Width = 773
        Height = 70
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
        TabOrder = 3
        ViewStyle = vsReport
        OnColumnClick = lvReportsColumnClick
        OnCompare = lvReportsCompare
        OnKeyUp = lvReportsKeyUp
        OnSelectItem = lvReportsSelectItem
      end
    end
    object pnlRightTopHeader: TPanel
      Left = 0
      Top = 0
      Width = 775
      Height = 45
      Align = alTop
      TabOrder = 2
      object TabControl1: TTabControl
        Left = 1
        Top = 22
        Width = 773
        Height = 22
        Align = alClient
        HotTrack = True
        Style = tsButtons
        TabHeight = 16
        TabOrder = 1
        Visible = False
        OnChange = TabControl1Change
      end
      object pnlRightTopHeaderTop: TPanel
        Left = 1
        Top = 1
        Width = 773
        Height = 21
        Align = alTop
        TabOrder = 0
        object lblHeading: TOROffsetLabel
          Left = 137
          Top = 1
          Width = 538
          Height = 19
          Align = alClient
          Caption = 'Laboratory Results'
          HorzOffset = 2
          Transparent = False
          VertOffset = 6
          WordWrap = False
          ExplicitWidth = 377
        end
        object lblTitle: TOROffsetLabel
          Left = 1
          Top = 1
          Width = 136
          Height = 19
          Align = alLeft
          HorzOffset = 3
          Transparent = True
          VertOffset = 6
          WordWrap = False
        end
        object chkMaxFreq: TCheckBox
          Left = 675
          Top = 1
          Width = 97
          Height = 19
          Align = alRight
          Caption = 'Max/Site OFF'
          TabOrder = 0
          Visible = False
          OnClick = chkMaxFreqClick
        end
      end
    end
    object pnlFooter: TORAutoPanel
      Left = 0
      Top = 769
      Width = 775
      Height = 20
      Align = alBottom
      TabOrder = 3
      object lblSpecimen: TLabel
        Left = 4
        Top = 28
        Width = 57
        Height = 13
        Caption = 'lblSpecimen'
        Visible = False
      end
      object lblSingleTest: TLabel
        Left = 88
        Top = 28
        Width = 60
        Height = 13
        Caption = 'lblSingleTest'
        Visible = False
      end
      object lblFooter: TOROffsetLabel
        Left = 1
        Top = 1
        Width = 773
        Height = 25
        Align = alTop
        Caption = 
          '  KEY: "L" = Abnormal Low, "H" = Abnormal High, "*" = Critical V' +
          'alue'
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
        ExplicitWidth = 612
      end
      object lstTests: TORListBox
        Left = 1
        Top = 26
        Width = 773
        Height = 17
        Align = alTop
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        ItemTipColor = clWindow
        LongList = False
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmLabs'
        'Status = stsDefault')
      (
        'Component = pnlRightBottom'
        'Status = stsDefault')
      (
        'Component = Memo1'
        'Status = stsDefault')
      (
        'Component = memLab'
        'Status = stsDefault')
      (
        'Component = pnlRightTop'
        'Status = stsDefault')
      (
        'Component = pnlHeader'
        'Status = stsDefault')
      (
        'Component = pnlWorksheet'
        'Status = stsDefault')
      (
        'Component = chkValues'
        'Status = stsDefault')
      (
        'Component = chk3D'
        'Status = stsDefault')
      (
        'Component = ragHorV'
        'Status = stsDefault')
      (
        'Component = chkAbnormals'
        'Status = stsDefault')
      (
        'Component = ragCorG'
        'Status = stsDefault')
      (
        'Component = chkZoom'
        'Status = stsDefault')
      (
        'Component = pnlGraph'
        'Status = stsDefault')
      (
        'Component = chkGraph3D'
        'Status = stsDefault')
      (
        'Component = chkGraphValues'
        'Status = stsDefault')
      (
        'Component = chkGraphZoom'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = lblDate'
        'Text = Date Collected'
        'Status = stsOK')
      (
        'Component = cmdNext'
        'Text = Next'
        'Status = stsOK')
      (
        'Component = cmdPrev'
        'Text = Previous'
        'Status = stsOK')
      (
        'Component = cmdRecent'
        'Text = Newest'
        'Status = stsOK')
      (
        'Component = cmdOld'
        'Text = Oldest'
        'Status = stsOK')
      (
        'Component = grdLab'
        'Status = stsDefault')
      (
        'Component = pnlChart'
        'Status = stsDefault')
      (
        'Component = lstTestGraph'
        'Status = stsDefault')
      (
        'Component = chtChart'
        'Status = stsDefault')
      (
        'Component = pnlRightTopHeader'
        'Status = stsDefault')
      (
        'Component = pnlFooter'
        'Status = stsDefault')
      (
        'Component = lstTests'
        'Status = stsDefault')
      (
        'Component = lvReports'
        'Status = stsDefault')
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
        'Component = lstQualifier'
        'Status = stsDefault')
      (
        'Component = lstHeaders'
        'Status = stsDefault')
      (
        'Component = lstDates'
        'Status = stsDefault')
      (
        'Component = pnlOtherTests'
        'Status = stsDefault')
      (
        'Component = cmdOtherTests'
        'Status = stsDefault')
      (
        'Component = pnlRightTopHeaderTop'
        'Status = stsDefault')
      (
        'Component = chkMaxFreq'
        'Status = stsDefault')
      (
        'Component = TabControl1'
        'Status = stsDefault')
      (
        'Component = WebBrowser1'
        'Status = stsDefault')
      (
        'Component = btnViewReport'
        'Status = stsDefault'))
  end
  object popChart: TPopupMenu
    OnPopup = popChartPopup
    Left = 37
    Top = 277
    object popValues: TMenuItem
      Caption = 'Values'
      OnClick = popValuesClick
    end
    object pop3D: TMenuItem
      Caption = '3D'
      OnClick = pop3DClick
    end
    object popZoom: TMenuItem
      Caption = 'Zoom Enabled'
      OnClick = popZoomClick
    end
    object popZoomBack: TMenuItem
      Caption = 'Zoom Back'
      OnClick = popZoomBackClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popCopy: TMenuItem
      Caption = 'Copy'
      OnClick = popCopyClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object popDetails: TMenuItem
      Caption = 'Details'
      OnClick = popDetailsClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object popPrint: TMenuItem
      Caption = 'Print'
      OnClick = popPrintClick
    end
  end
  object calLabRange: TORDateRangeDlg
    DateOnly = True
    Instruction = 'Enter a date range -'
    LabelStart = 'Begin Date'
    LabelStop = 'End Date'
    RequireTime = False
    Format = 'mmm d,yy'
    Left = 66
    Top = 280
  end
  object dlgWinPrint: TPrintDialog
    Left = 522
    Top = 79
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 557
    Top = 77
  end
  object PopupMenu2: TPopupMenu
    Left = 603
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
  end
  object PopupMenu3: TPopupMenu
    OnPopup = PopupMenu3Popup
    Left = 285
    Top = 368
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
    object GoToTop1: TMenuItem
      Caption = 'Go to Top'
      OnClick = GotoTop1Click
    end
    object GoToBottom1: TMenuItem
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
      OnClick = UnfreezeText1Click
    end
    object mnuCreateLabNote: TMenuItem
      Caption = 'Create Lab Note'
      ShortCut = 16462
      OnClick = CreateNewNoteClick
    end
    object mnuNotifyOk: TMenuItem
      Caption = 'Notify OK'
      ShortCut = 16463
      OnClick = NotifyOKClick
    end
    object mnuSendLabAlert2: TMenuItem
      Caption = 'Send Lab Alert'
      ShortCut = 16460
      OnClick = mnuSendLabAlertClick
    end
    object mnuCopyResultsTable: TMenuItem
      Caption = 'Copy Results Table'
      ShortCut = 16468
      OnClick = mnuCopyResultsTableClick
    end
  end
  object mnuLabs: TMainMenu
    Left = 248
    Top = 368
    object Action1: TMenuItem
      Caption = 'Action'
      GroupIndex = 4
      OnClick = Action1Click
      object ManLabs: TMenuItem
        Caption = '&Manual Lab Entry'
        OnClick = ManLabsClick
      end
      object CreateNewNote: TMenuItem
        Caption = '&Create New Note...'
        ShortCut = 16462
        OnClick = CreateNewNoteClick
      end
      object NotifyOK: TMenuItem
        Caption = 'Notify &OK...'
        ShortCut = 16463
        OnClick = NotifyOKClick
      end
      object AddToImportIgnore: TMenuItem
        Caption = '&Ignore HL7 imports for patient'
        ShortCut = 16457
        OnClick = AddToImportIgnoreClick
      end
      object mnuViewLabReports: TMenuItem
        Caption = 'View Lab &Reports'
        ShortCut = 16466
        OnClick = mnuViewLabReportsClick
      end
      object mnuUploadLabPDF: TMenuItem
        Caption = 'Upload Lab Result PDF'
        OnClick = mnuUploadLabPDFClick
      end
    end
  end
  object popTMGGridPopup: TPopupMenu
    Left = 120
    Top = 112
    object popGrdCreateLabNote: TMenuItem
      Caption = 'Create Lab Note'
      ShortCut = 16462
      OnClick = CreateNewNoteClick
    end
    object popNotifyOK: TMenuItem
      Caption = 'Notify OK'
      ShortCut = 16463
      OnClick = NotifyOKClick
    end
    object mnuSendLabAlert: TMenuItem
      Caption = 'Send Lab Alert'
      ShortCut = 16460
      OnClick = mnuSendLabAlertClick
    end
    object mnuCopyResultsTable1: TMenuItem
      Caption = 'Copy Results Table'
      ShortCut = 16468
      OnClick = mnuCopyResultsTableClick
    end
  end
end
