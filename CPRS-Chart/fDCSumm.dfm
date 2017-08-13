inherited frmDCSumm: TfrmDCSumm
  Left = 1291
  Top = 197
  HelpContext = 7000
  Caption = 'Discharge Summary Page'
  ClientHeight = 382
  ClientWidth = 679
  HelpFile = 'overvw'
  Menu = mnuSumms
  OnDestroy = FormDestroy
  ExplicitWidth = 687
  ExplicitHeight = 436
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 377
    Width = 679
    ExplicitTop = 358
    ExplicitWidth = 679
  end
  inherited sptHorz: TSplitter
    Left = 64
    Width = 3
    Height = 377
    OnCanResize = sptHorzCanResize
    ExplicitLeft = 64
    ExplicitWidth = 3
    ExplicitHeight = 358
  end
  inherited pnlLeft: TPanel
    Width = 64
    Height = 377
    ExplicitWidth = 64
    ExplicitHeight = 377
    object lblSumms: TOROffsetLabel
      Left = 0
      Top = 0
      Width = 64
      Height = 19
      Align = alTop
      Caption = 'Last 100 Summaries'
      HorzOffset = 2
      ParentShowHint = False
      ShowHint = True
      Transparent = True
      VertOffset = 6
      WordWrap = False
    end
    object lblSpace1: TLabel
      Left = 0
      Top = 353
      Width = 64
      Height = 3
      Align = alBottom
      AutoSize = False
      Caption = ' '
      ExplicitTop = 334
    end
    object cmdNewSumm: TORAlignButton
      Left = 0
      Top = 332
      Width = 64
      Height = 21
      Align = alBottom
      Caption = 'New Summary'
      TabOrder = 1
      OnClick = cmdNewSummClick
    end
    object cmdPCE: TORAlignButton
      Left = 0
      Top = 356
      Width = 64
      Height = 21
      Align = alBottom
      Caption = 'Encounter'
      TabOrder = 2
      Visible = False
      OnClick = cmdPCEClick
    end
    object pnlDrawers: TPanel
      Left = 0
      Top = 19
      Width = 64
      Height = 313
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object splDrawers: TSplitter
        Left = 0
        Top = 310
        Width = 64
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 291
      end
      object lstSumms: TORListBox
        Left = 0
        Top = 0
        Width = 64
        Height = 33
        TabStop = False
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        ParentShowHint = False
        PopupMenu = popSummList
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = lstSummsClick
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPositions = '10,20'
      end
      object tvSumms: TORTreeView
        Left = 0
        Top = 0
        Width = 64
        Height = 310
        Align = alClient
        Constraints.MinWidth = 30
        HideSelection = False
        Images = dmodShared.imgNotes
        Indent = 19
        PopupMenu = popSummList
        ReadOnly = True
        StateImages = dmodShared.imgImages
        TabOrder = 1
        OnChange = tvSummsChange
        OnClick = tvSummsClick
        OnCollapsed = tvSummsCollapsed
        OnDragDrop = tvSummsDragDrop
        OnDragOver = tvSummsDragOver
        OnExpanded = tvSummsExpanded
        OnStartDrag = tvSummsStartDrag
        Caption = 'Last 100 Summaries'
        NodePiece = 0
        ShortNodeCaptions = True
      end
    end
  end
  inherited pnlRight: TPanel
    Left = 67
    Width = 612
    Height = 377
    ExplicitLeft = 67
    ExplicitWidth = 612
    ExplicitHeight = 377
    object sptVert: TSplitter
      Left = 0
      Top = 328
      Width = 612
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 309
    end
    object memPCEShow: TRichEdit
      Left = 0
      Top = 332
      Width = 612
      Height = 45
      Align = alBottom
      Color = clCream
      Lines.Strings = (
        '<No encounter information entered>')
      PlainText = True
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 3
      WantReturns = False
      WordWrap = False
    end
    object pnlWrite: TPanel
      Left = 0
      Top = 0
      Width = 612
      Height = 328
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      OnResize = pnlWriteResize
      object memNewSumm: TRichEdit
        Left = 0
        Top = 52
        Width = 612
        Height = 276
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        MaxLength = 2147483645
        ParentFont = False
        PlainText = True
        PopupMenu = popSummMemo
        ScrollBars = ssVertical
        TabOrder = 1
        WantTabs = True
        OnChange = memNewSummChange
        OnKeyUp = memNewSummKeyUp
      end
      object pnlFields: TORAutoPanel
        Left = 0
        Top = 0
        Width = 612
        Height = 52
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          612
          52)
        object bvlNewTitle: TBevel
          Left = 5
          Top = 5
          Width = 102
          Height = 15
        end
        object lblNewTitle: TStaticText
          Left = 6
          Top = 6
          Width = 104
          Height = 17
          Hint = 'Press "Change..." to select a different title.'
          Caption = ' Discharge Summary '
          Color = clCream
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 1
        end
        object lblVisit: TStaticText
          Left = 6
          Top = 21
          Width = 123
          Height = 17
          Caption = 'Adm: 10/20/99   2BMED'
          ShowAccelChar = False
          TabOrder = 2
        end
        object lblRefDate: TStaticText
          Left = 237
          Top = 6
          Width = 101
          Height = 17
          Hint = 'Press "Change..." to change date/time of summary.'
          Alignment = taCenter
          Caption = 'Oct 20,1999@15:30'
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 3
        end
        object lblCosigner: TStaticText
          Left = 307
          Top = 21
          Width = 199
          Height = 13
          Hint = 'Press "Change..." to select a different attending.'
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = 'Attending: Winchester,Charles Emerson III'
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 4
        end
        object lblDictator: TStaticText
          Left = 402
          Top = 6
          Width = 152
          Height = 17
          Hint = 'Press "Change..." to select a different author.'
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'Winchester,Charles Emerson III'
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 5
        end
        object lblDischarge: TStaticText
          Left = 6
          Top = 34
          Width = 71
          Height = 17
          Caption = 'Dis: 03/20/00'
          ShowAccelChar = False
          TabOrder = 6
        end
        object cmdChange: TButton
          Left = 554
          Top = 10
          Width = 58
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Change...'
          TabOrder = 0
          OnClick = cmdChangeClick
        end
      end
    end
    object pnlHTMLWrite: TPanel
      Left = 0
      Top = 0
      Width = 612
      Height = 328
      Align = alClient
      BevelOuter = bvNone
      Color = clInactiveBorder
      TabOrder = 2
      Visible = False
      ExplicitHeight = 348
      object pnlHTMLEdit: TPanel
        Left = 0
        Top = 21
        Width = 612
        Height = 307
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitHeight = 327
      end
      object ToolBar: TToolBar
        Left = 0
        Top = 0
        Width = 612
        Height = 21
        AutoSize = True
        ButtonHeight = 21
        Caption = 'ToolBar'
        TabOrder = 1
        TabStop = True
        object cbFontNames: TComboBox
          Left = 0
          Top = 0
          Width = 145
          Height = 21
          ItemHeight = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = cbFontNamesChange
        end
        object cbFontSize: TComboBox
          Left = 145
          Top = 0
          Width = 75
          Height = 21
          Hint = 'Font Size (Ctrl+(1-6))'
          ItemHeight = 13
          ItemIndex = 2
          TabOrder = 1
          Text = '3 (12 pt)'
          OnChange = cbFontSizeChange
          Items.Strings = (
            '1 (8   pt)'
            '2 (10 pt)'
            '3 (12 pt)'
            '4 (14 pt)'
            '5 (18 pt)'
            '6 (24 pt)'
            '7 (36 pt)')
        end
        object btnFonts: TSpeedButton
          Left = 220
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Text Font (Ctrl+D)'
          Glyph.Data = {
            82020000424D8202000000000000420000002800000012000000100000000100
            10000300000040020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF100010005AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF100010005AEF7BEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF100010005AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF53AD008053AD5AEF5AEF5AEF5AEF1000100010005AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF00805AEF5AEF5AEF5AEF5AEF10001000
            5AEF5AEF7BEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF00805AEF53AD5AEF5AEF5AEF
            100010005AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF0080008000805AEF
            5AEF5AEF10001000100010005AEF5AEF108010805AEF5AEF5AEF5AEF00805AEF
            53AD5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF53AD10805AEF5AEF5AEF
            00805AEF5AEF53AD5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF10805AEF
            5AEF53AD00800080008000805AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            10805AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF1080108010805AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF10805AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF108053AD5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF108010805AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnFontsClick
        end
        object btnItalic: TSpeedButton
          Left = 243
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Italics (Ctrl+I)'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000001084FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF108400000000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000001084FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF108400000000FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000001084FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF108400000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000001084FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnItalicClick
        end
        object btnBold: TSpeedButton
          Left = 266
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Bold (Ctrl+B)'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B00000000000000000000007C0000E003
            00001F000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7F000000000000FF7FFF7F000000000000FF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7F000000000000FF7FFF7F000000000000FF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7F000000000000FF7FFF7F000000000000FF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7F0000000000000000000000000000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7F000000000000FF7FFF7F000000000000FF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7F000000000000FF7FFF7F000000000000FF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7F000000000000FF7FFF7F000000000000FF7F
            FF7FFF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000FF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7FFF7F}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnBoldClick
        end
        object btnUnderline: TSpeedButton
          Left = 289
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Underline (Ctrl+U)'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000001084FFFF108400000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFF00000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFF00000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFF00000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFF00000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFF00000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFF00000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFF0000000000000000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnUnderlineClick
        end
        object btnBullets: TSpeedButton
          Left = 312
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Bullets'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF100010001000FFFFFFFF00000000000000000000000000000000
            0000FFFFFFFF100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF100010001000FFFFFFFF00000000000000000000000000000000
            0000FFFFFFFF100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF100010001000FFFFFFFF00000000000000000000000000000000
            0000FFFFFFFF100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnBulletsClick
        end
        object btnNumbers: TSpeedButton
          Left = 335
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Numbering'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF10001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF1000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF1000FFFFFFFFFFFF00000000000000000000000000000000
            0000FFFFFFFF100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF1000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF1000FFFFFFFF00000000000000000000000000000000
            0000FFFFFFFF10001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF1000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF10001000FFFFFFFFFFFF00000000000000000000000000000000
            0000FFFFFFFFFFFF1000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnNumbersClick
        end
        object btnLeftAlign: TSpeedButton
          Left = 358
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Align Left'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnLeftAlignClick
        end
        object btnCenterAlign: TSpeedButton
          Left = 381
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Align Center'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnCenterAlignClick
        end
        object btnRightAlign: TSpeedButton
          Left = 404
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Align Right'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000
            0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnRightAlignClick
        end
        object btnMoreIndent: TSpeedButton
          Left = 427
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Indent (Ctrl+W)'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF0000000000000000FFFF00000000FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF0000000000000000FFFF000000000000000000000000
            000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF1000FFFFFFFFFFFFFFFF000000000000000000000000
            FFFFFFFFFFFFFFFFFFFF10001000FFFFFFFFFFFF000000000000000000000000
            FFFFFFFFFFFF10001000100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF10001000FFFFFFFFFFFF000000000000000000000000
            000000000000FFFFFFFF1000FFFFFFFFFFFFFFFF000000000000000000000000
            000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF0000000000000000FFFF000000000000000000000000
            000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnMoreIndentClick
        end
        object btnLessIndent: TSpeedButton
          Left = 450
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Outdent (Ctrl+Q)'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF0000000000000000FFFF00000000FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF0000000000000000FFFF000000000000000000000000
            000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF1000FFFFFFFFFFFFFFFF000000000000000000000000
            FFFFFFFFFFFFFFFF10001000FFFFFFFFFFFFFFFF000000000000000000000000
            FFFFFFFFFFFF10001000100010001000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF10001000FFFFFFFFFFFFFFFF000000000000000000000000
            000000000000FFFFFFFF1000FFFFFFFFFFFFFFFF000000000000000000000000
            000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF0000000000000000FFFF000000000000000000000000
            000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnLessIndentClick
        end
        object btnTextColor: TSpeedButton
          Left = 473
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Text Color'
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            10000300000000020000130B0000130B0000000000000000000000F80000E007
            00001F000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFF
            FFFFFFFFFFFF10001000FFFF0000000010841084108410841084108400000000
            FFFFFFFFFFFF10001000100010841084E0FFF7BDE0FF1F001F00F7BD10841084
            0000FFFFFFFFF7BD1000FFFFF7BDE0FFF7BDE0FF1F001F001F001F00F7BDE0FF
            10840000FFFFF7BD1084FFFFE0FF00F800F8F7BDE0FF1F001F00F7BDE0FFF7BD
            10840000FFFF1084FFFFE0FF00F800F800F800F8F7BDE0FFFFFFFFFFF7BDE0FF
            10840000FFFF1084FFFFF7BDE0FF00F800F8F7BDE0FF108410001000FFFFF7BD
            10840000FFFF1084FFFFE0FFF7BDE0FFF7BDE0FF10841000FF07100010001084
            00000000FFFF1084FFFFF7BD00040004E0FFF7BDE0FF10841000FF0710001000
            0000FFFFFFFF1084FFFF0004000400040004E0FFF7BDE0FF10841000E0FF0084
            0084FFFFFFFF1084FFFFF7BD00040004E0FF1FF81FF8F7BDE0FF10840084E0FF
            00840000FFFF1084FFFFE0FFF7BDE0FF1FF81FF81FF8E0FFFFFF1084FFFF0084
            000000000000FFFF1084FFFFE0FFF7BD1FF81FF81FF8FFFF1084FFFFFFFFFFFF
            0000F7BD0000FFFFFFFF1084FFFFFFFFFFFFFFFFFFFF10841084FFFFFFFFFFFF
            FFFF00000000FFFFFFFFFFFF10841084108410841084FFFFFFFFFFFFFFFFFFFF
            FFFFFFFF0000}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnTextColorClick
        end
        object btnBackColor: TSpeedButton
          Left = 496
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Background Color'
          Glyph.Data = {
            12030000424D1203000000000000420000002800000014000000120000000100
            100003000000D0020000130B0000130B0000000000000000000000F80000E007
            00001F0000005AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF0000
            0000000000000000000000000000000000000000000000005AEF5AEF5AEF5AEF
            5AEF5AEF5AEF0000E007E007E0070000FF07FF07FF0700001FF81FF81FF80000
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF0000E007E007E0070000FF07FF07FF070000
            1FF81FF81FF800005AEF5AEF5AEF5AEF5AEF5AEF5AEF0000E007E007E0070000
            FF07FF07FF0700001FF81FF81FF800005AEF5AEF5AEF5AEF5AEF5AEF5AEF0000
            0000000000000000000000000000000000000000000000005AEF5AEF5AEF5AEF
            5AEF5AEF5AEF000053AD53AD53AD0000FFFFFFFFFFFF00000000000000000000
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF000053AD53AD53AD0000FFFFFFFFFFFF0000
            00000000000000005AEF5AEF5AEF5AEF5AEF5AEF5AEF000053AD53AD53AD0000
            FFFFFFFFFFFF000000000000000000005AEF5AEF5AEF5AEF5AEF5AEF5AEF0000
            0000000000000000000000000000000000000000000000005AEF5AEF5AEF5AEF
            5AEF5AEF5AEF000000F800F800F80000E0FFE0FFE0FF00001F001F001F000000
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF000000F800F800F80000E0FFE0FFE0FF0000
            1F001F001F0000005AEF5AEF5AEF5AEF5AEF5AEF5AEF000000F800F800F80000
            E0FFE0FFE0FF00001F001F001F0000005AEF5AEF5AEF5AEF5AEF5AEF5AEF0000
            0000000000000000000000000000000000000000000000005AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF
            5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF5AEF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnBackColorClick
        end
        object btnImage: TSpeedButton
          Left = 519
          Top = 0
          Width = 23
          Height = 21
          Hint = 'Add Image'
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFF7000000000FFFFFF7CCCCCCCC0FFFFFF7CCCCCCCC
            0FFFFFF7CCCCCC220FFFFFF7EFEF22220FFFFFF7FEFEFE220FFFFFF7E88FEFEF
            0FFFFFF78FB8FEFE0FFFFFF78BF8EFEF0FFFFFF7F88EFEFE0FFFFFF7EFEFEFEF
            0FFFFFF7777777777FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
          ParentShowHint = False
          ShowHint = True
          OnClick = btnImageClick
        end
      end
    end
    object pnlRead: TPanel
      Left = 0
      Top = 0
      Width = 612
      Height = 328
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblTitle: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 612
        Height = 19
        Hint = 'No Discharge Summaries Found'
        Align = alTop
        Caption = 'No Discharge Summaries Found'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HorzOffset = 2
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object sptList: TSplitter
        Left = 0
        Top = 113
        Width = 612
        Height = 3
        Cursor = crVSplit
        Align = alTop
      end
      object memSumm: TRichEdit
        Left = 0
        Top = 116
        Width = 612
        Height = 212
        Align = alClient
        Color = clCream
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          
            'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRUSTVWXYZabcdefghijkl' +
            'mnopqrstuvwxyz12')
        ParentCtl3D = False
        ParentFont = False
        PlainText = True
        PopupMenu = popSummMemo
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WantReturns = False
        WordWrap = False
      end
      object lvSumms: TCaptionListView
        Left = 0
        Top = 19
        Width = 612
        Height = 94
        Align = alTop
        Columns = <
          item
            Caption = 'Date'
            Width = 100
          end
          item
            AutoSize = True
            Caption = 'Title'
          end
          item
            AutoSize = True
            Caption = 'Subject'
          end
          item
            AutoSize = True
            Caption = 'Author'
          end
          item
            AutoSize = True
            Caption = 'Location'
          end
          item
            Caption = 'fmdate'
            Width = 0
          end
          item
            Caption = 'TIUDA'
            Width = 0
          end>
        Constraints.MinHeight = 50
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        SmallImages = dmodShared.imgNotes
        StateImages = dmodShared.imgImages
        TabOrder = 1
        ViewStyle = vsReport
        Visible = False
        OnColumnClick = lvSummsColumnClick
        OnCompare = lvSummsCompare
        OnResize = lvSummsResize
        OnSelectItem = lvSummsSelectItem
        Caption = 'No Discharge Summaries Found'
      end
      object pnlHtmlViewer: TPanel
        Left = 0
        Top = 116
        Width = 612
        Height = 212
        Align = alClient
        BevelOuter = bvNone
        Color = clBtnShadow
        TabOrder = 2
        ExplicitHeight = 232
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdNewSumm'
        'Status = stsDefault')
      (
        'Component = cmdPCE'
        'Status = stsDefault')
      (
        'Component = pnlDrawers'
        'Status = stsDefault')
      (
        'Component = lstSumms'
        'Status = stsDefault')
      (
        'Component = tvSumms'
        'Status = stsDefault')
      (
        'Component = memPCEShow'
        'Status = stsDefault')
      (
        'Component = pnlWrite'
        'Status = stsDefault')
      (
        'Component = memNewSumm'
        'Status = stsDefault')
      (
        'Component = pnlFields'
        'Status = stsDefault')
      (
        'Component = lblNewTitle'
        'Status = stsDefault')
      (
        'Component = lblVisit'
        'Status = stsDefault')
      (
        'Component = lblRefDate'
        'Status = stsDefault')
      (
        'Component = lblCosigner'
        'Status = stsDefault')
      (
        'Component = lblDictator'
        'Status = stsDefault')
      (
        'Component = lblDischarge'
        'Status = stsDefault')
      (
        'Component = cmdChange'
        'Status = stsDefault')
      (
        'Component = pnlRead'
        'Status = stsDefault')
      (
        'Component = memSumm'
        'Status = stsDefault')
      (
        'Component = lvSumms'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmDCSumm'
        'Status = stsDefault'))
  end
  object mnuSumms: TMainMenu
    Left = 596
    Top = 305
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
        object mnuChartSumms: TMenuItem
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
      object Z3: TMenuItem
        Caption = '-'
      end
      object mnuViewAll: TMenuItem
        Tag = 1
        Caption = '&Signed Summaries (All)'
        OnClick = mnuViewClick
      end
      object mnuViewByAuthor: TMenuItem
        Tag = 4
        Caption = 'Signed Summaries by &Author'
        OnClick = mnuViewClick
      end
      object mnuViewByDate: TMenuItem
        Tag = 5
        Caption = 'Signed Summaries by Date &Range'
        OnClick = mnuViewClick
      end
      object mnuViewUncosigned: TMenuItem
        Tag = 3
        Caption = 'Un&cosigned Summaries'
        OnClick = mnuViewClick
      end
      object mnuViewUnsigned: TMenuItem
        Tag = 2
        Caption = '&Unsigned Summaries'
        OnClick = mnuViewClick
      end
      object mnuViewCustom: TMenuItem
        Tag = 6
        Caption = 'Custo&m View'
        OnClick = mnuViewClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuViewSaveAsDefault: TMenuItem
        Caption = 'Sa&ve as Default View'
        OnClick = mnuViewSaveAsDefaultClick
      end
      object mnuViewReturnToDefault: TMenuItem
        Caption = 'Return to De&fault View'
        OnClick = mnuViewReturntoDefaultClick
      end
      object Z1: TMenuItem
        Caption = '-'
      end
      object mnuViewDetail: TMenuItem
        Caption = '&Details'
        OnClick = mnuViewDetailClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object mnuIconLegend: TMenuItem
        Caption = 'Icon Legend'
        OnClick = mnuIconLegendClick
      end
    end
    object mnuAct: TMenuItem
      Caption = '&Action'
      GroupIndex = 4
      object mnuActNew: TMenuItem
        Caption = '&New Discharge Summary...'
        Hint = 'Creates a new Discharge Summary'
        ShortCut = 24654
        OnClick = mnuActNewClick
      end
      object mnuActAddend: TMenuItem
        Caption = '&Make Addendum...'
        Hint = 'Makes an addendum for the currently selected Discharge Summary'
        ShortCut = 24653
        OnClick = mnuActAddendClick
      end
      object mnuActAddIDEntry: TMenuItem
        Caption = 'Add Ne&w Entry to Interdisciplinary Note'
        OnClick = mnuActAddIDEntryClick
      end
      object mnuActAttachtoIDParent: TMenuItem
        Caption = 'A&ttach to Interdisciplinary Note'
        OnClick = mnuActAttachtoIDParentClick
      end
      object mnuActDetachFromIDParent: TMenuItem
        Caption = 'Detac&h from Interdisciplinary Note'
        OnClick = mnuActDetachFromIDParentClick
      end
      object Z2: TMenuItem
        Caption = '-'
      end
      object mnuActChange: TMenuItem
        Caption = '&Change Title...'
        ShortCut = 24643
        OnClick = mnuActChangeClick
      end
      object mnuActLoadBoiler: TMenuItem
        Caption = 'Reload &Boilerplate Text'
        OnClick = mnuActLoadBoilerClick
      end
      object Z4: TMenuItem
        Caption = '-'
      end
      object mnuActSignList: TMenuItem
        Caption = 'Add to Signature &List'
        Hint = 
          'Adds the currently displayed Discharge Summary to list of things' +
          ' to be signed'
        OnClick = mnuActSignListClick
      end
      object mnuActDelete: TMenuItem
        Caption = '&Delete Discharge Summary...'
        ShortCut = 24644
        OnClick = mnuActDeleteClick
      end
      object mnuActEdit: TMenuItem
        Caption = '&Edit Discharge Summary...'
        ShortCut = 24645
        OnClick = mnuActEditClick
      end
      object mnuActSave: TMenuItem
        Caption = 'S&ave without Signature'
        Hint = 'Saves the Discharge Summary that is being edited'
        ShortCut = 24641
        OnClick = mnuActSaveClick
      end
      object mnuActSign: TMenuItem
        Caption = 'Si&gn Discharge Summary Now...'
        ShortCut = 24647
        OnClick = mnuActSignClick
      end
      object mnuActIdentifyAddlSigners: TMenuItem
        Caption = '&Identify Additional Signers'
        OnClick = mnuActIdentifyAddlSignersClick
      end
    end
    object mnuOptions: TMenuItem
      Caption = '&Options'
      GroupIndex = 4
      OnClick = mnuOptionsClick
      object mnuEditTemplates: TMenuItem
        Caption = 'Edit &Templates...'
        OnClick = mnuEditTemplatesClick
      end
      object mnuNewTemplate: TMenuItem
        Caption = 'Create &New Template...'
        OnClick = mnuNewTemplateClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuEditSharedTemplates: TMenuItem
        Caption = 'Edit &Shared Templates...'
        OnClick = mnuEditSharedTemplatesClick
      end
      object mnuNewSharedTemplate: TMenuItem
        Caption = '&Create New Shared Template...'
        OnClick = mnuNewSharedTemplateClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuEditDialgFields: TMenuItem
        Caption = 'Edit Template &Fields'
        OnClick = mnuEditDialgFieldsClick
      end
    end
  end
  object popSummMemo: TPopupMenu
    OnPopup = popSummMemoPopup
    Left = 539
    Top = 304
    object popSummMemoCut: TMenuItem
      Caption = 'Cu&t'
      ShortCut = 16472
      OnClick = popSummMemoCutClick
    end
    object popSummMemoCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = popSummMemoCopyClick
    end
    object popSummMemoPaste: TMenuItem
      Caption = '&Paste'
      ShortCut = 16470
      OnClick = popSummMemoPasteClick
    end
    object popSummMemoPaste2: TMenuItem
      Caption = 'Paste2'
      ShortCut = 8237
      Visible = False
      OnClick = popSummMemoPasteClick
    end
    object popSummMemoReformat: TMenuItem
      Caption = 'Re&format Paragraph'
      ShortCut = 24658
      OnClick = popSummMemoReformatClick
    end
    object popSummMemoSaveContinue: TMenuItem
      Caption = 'Save && Continue Editing'
      ShortCut = 24659
      Visible = False
      OnClick = popSummMemoSaveContinueClick
    end
    object popNoteMemoHTMLFormat: TMenuItem
      OnClick = popNoteMemoHTMLFormatClick
    end
    object Z11: TMenuItem
      Caption = '-'
    end
    object popSummMemoFind: TMenuItem
      Caption = '&Find in Selected Summary'
      OnClick = popSummMemoFindClick
    end
    object popSummMemoReplace: TMenuItem
      Caption = '&Replace Text'
      OnClick = popSummMemoReplaceClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object popSummMemoGrammar: TMenuItem
      Caption = 'Check &Grammar'
      OnClick = popSummMemoGrammarClick
    end
    object popSummMemoSpell: TMenuItem
      Caption = 'C&heck Spelling'
      OnClick = popSummMemoSpellClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object popSummMemoTemplate: TMenuItem
      Caption = 'Copy Into New &Template'
      OnClick = popSummMemoTemplateClick
    end
    object Z10: TMenuItem
      Caption = '-'
    end
    object popSummMemoSignList: TMenuItem
      Caption = 'Add to Signature &List'
      OnClick = mnuActSignListClick
    end
    object popSummMemoDelete: TMenuItem
      Caption = '&Delete Discharge Summary...'
      OnClick = mnuActDeleteClick
    end
    object popSummMemoEdit: TMenuItem
      Caption = '&Edit Discharge Summary...'
      OnClick = mnuActEditClick
    end
    object popSummMemoAddend: TMenuItem
      Caption = '&Make Addendum...'
      OnClick = mnuActAddendClick
    end
    object popSummMemoSave: TMenuItem
      Caption = 'S&ave without Signature'
      OnClick = mnuActSaveClick
    end
    object popSummMemoSign: TMenuItem
      Caption = '&Sign Discharge Summary Now...'
      OnClick = mnuActSignClick
    end
    object popSummMemoAddlSign: TMenuItem
      Caption = '&Identify Additional Signers'
      OnClick = popSummMemoAddlSignClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object popSummMemoPreview: TMenuItem
      Caption = 'Previe&w/Print Current Template'
      ShortCut = 16471
      OnClick = popSummMemoPreviewClick
    end
    object popSummMemoInsTemplate: TMenuItem
      Caption = 'Insert Current Template'
      ShortCut = 16429
      OnClick = popSummMemoInsTemplateClick
    end
    object popSummMemoEncounter: TMenuItem
      Caption = 'Edit Encounter Information'
      ShortCut = 16453
      OnClick = cmdPCEClick
    end
  end
  object popSummList: TPopupMenu
    OnPopup = popSummListPopup
    Left = 500
    Top = 304
    object popSummListAll: TMenuItem
      Tag = 1
      Caption = '&Signed Discharge Summaries (All)'
      OnClick = mnuViewClick
    end
    object popSummListByAuthor: TMenuItem
      Tag = 4
      Caption = 'Signed Discharge Summaries by &Author'
      OnClick = mnuViewClick
    end
    object popSummListByDate: TMenuItem
      Tag = 5
      Caption = 'Signed Discharge Summaries by Date &Range'
      OnClick = mnuViewClick
    end
    object popSummListUncosigned: TMenuItem
      Tag = 3
      Caption = 'Un&cosigned Discharge Summaries'
      OnClick = mnuViewClick
    end
    object popSummListUnsigned: TMenuItem
      Tag = 2
      Caption = '&Unsigned Discharge Summaries'
      OnClick = mnuViewClick
    end
    object popSummListCustom: TMenuItem
      Tag = 6
      Caption = 'Cus&tom View'
      OnClick = mnuViewClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object popSummListExpandSelected: TMenuItem
      Caption = '&Expand Selected'
      OnClick = popSummListExpandSelectedClick
    end
    object popSummListExpandAll: TMenuItem
      Caption = 'E&xpand All'
      OnClick = popSummListExpandAllClick
    end
    object popSummListCollapseSelected: TMenuItem
      Caption = 'C&ollapse Selected'
      OnClick = popSummListCollapseSelectedClick
    end
    object popSummListCollapseAll: TMenuItem
      Caption = 'Co&llapse All'
      OnClick = popSummListCollapseAllClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object popSummListAddIDEntry: TMenuItem
      Caption = 'Add Ne&w Entry to Interdisciplinary Note'
      OnClick = mnuActAddIDEntryClick
    end
    object popSummListAttachtoIDParent: TMenuItem
      Caption = 'A&ttach to Interdisciplinary Note'
      OnClick = mnuActAttachtoIDParentClick
    end
    object popSummListDetachFromIDParent: TMenuItem
      Caption = 'Detac&h from Interdisciplinary Note'
      OnClick = mnuActDetachFromIDParentClick
    end
  end
  object timAutoSave: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = timAutoSaveTimer
    Left = 560
    Top = 61
  end
  object dlgFindText: TFindDialog
    Options = [frDown, frHideUpDown]
    OnFind = dlgFindTextFind
    Left = 452
    Top = 312
  end
  object dlgReplaceText: TReplaceDialog
    OnFind = dlgReplaceTextFind
    OnReplace = dlgReplaceTextReplace
    Left = 409
    Top = 313
  end
  object imgLblNotes: TVA508ImageListLabeler
    Components = <
      item
        Component = lvSumms
      end
      item
        Component = tvSumms
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblNotes
    Left = 16
    Top = 171
  end
  object imgLblImages: TVA508ImageListLabeler
    Components = <
      item
        Component = lvSumms
      end
      item
        Component = tvSumms
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblImages
    Left = 16
    Top = 203
  end
  object popupAddImage: TPopupMenu
    Left = 364
    Top = 312
    object mnuSelectExistingImage: TMenuItem
      Bitmap.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFF7000000000FFFFFF7CCCCCCCC0FFFFFF7CCCCCCCC
        0FFFFFF7CCCCCC220FFFFFF7EFEF22220FFFFFF7FEFEFE220FFFFFF7E88FEFEF
        0FFFFFF78FB8FEFE0FFFFFF78BF8EFEF0FFFFFF7F88EFEFE0FFFFFF7EFEFEFEF
        0FFFFFF7777777777FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      Caption = 'Select &Existing Image'
      OnClick = mnuSelectExistingImageClick
    end
    object mnuAddNewImage: TMenuItem
      Bitmap.Data = {
        36010000424D3601000000000000760000002800000014000000100000000100
        040000000000C000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFF0
        000000000FFFFFFF0000FF00B8B8B8B8B0FFFFFF0000FF0F0B8B8B8B8B0FFFFF
        0000FF0BF0B8B8B8B8B0FFFF0000FF0FBF0000000000FFFF0000FF0BFBFBFBFB
        0FFFFFFF0000FF0FBFBFBFBF0FFFFFFF0000FF0BFBFBF000FFFFFFFF0000FFF0
        BFBF0FFFFFFFFFFF0000FFF700007FFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000}
      Caption = 'Add &New Image'
      OnClick = mnuAddNewImageClick
    end
  end
end
