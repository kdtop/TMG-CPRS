inherited frmNotes: TfrmNotes
  Left = 293
  Top = 115
  HelpContext = 5000
  Caption = 'Progress Notes Page'
  ClientHeight = 594
  ClientWidth = 1079
  HelpFile = 'overvw'
  Menu = mnuNotes
  Position = poDesigned
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  ExplicitWidth = 1087
  ExplicitHeight = 648
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 589
    Width = 1079
    ExplicitTop = 358
    ExplicitWidth = 679
  end
  inherited sptHorz: TSplitter
    Left = 260
    Height = 589
    ParentColor = False
    ExplicitLeft = 261
    ExplicitHeight = 989
  end
  inherited pnlLeft: TPanel
    Width = 260
    Height = 589
    ExplicitWidth = 260
    ExplicitHeight = 589
    object lblSpace1: TLabel
      Left = 0
      Top = 544
      Width = 260
      Height = 3
      Align = alBottom
      AutoSize = False
      Caption = ' '
      ExplicitTop = 313
      ExplicitWidth = 64
    end
    object cmdNewNote: TORAlignButton
      Left = 0
      Top = 547
      Width = 260
      Height = 21
      Align = alBottom
      Caption = 'New Note'
      TabOrder = 1
      OnClick = cmdNewNoteClick
      OnExit = cmdNewNoteExit
    end
    object cmdPCE: TORAlignButton
      Left = 0
      Top = 568
      Width = 260
      Height = 21
      Align = alBottom
      Caption = 'Encounter'
      TabOrder = 2
      Visible = False
      OnClick = cmdPCEClick
      OnExit = cmdPCEExit
    end
    object pnlDrawers: TPanel
      Left = 0
      Top = 33
      Width = 260
      Height = 511
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object splDrawers: TSplitter
        Left = 0
        Top = 508
        Width = 260
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 291
        ExplicitWidth = 64
      end
      object lstNotes: TORListBox
        Left = 0
        Top = 0
        Width = 64
        Height = 18
        TabStop = False
        Ctl3D = True
        ItemHeight = 13
        ParentCtl3D = False
        ParentShowHint = False
        PopupMenu = popNoteList
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = lstNotesClick
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPositions = '10'
      end
      object tvNotes: TORTreeView
        Left = 0
        Top = 0
        Width = 260
        Height = 508
        Align = alClient
        Constraints.MinWidth = 30
        HideSelection = False
        Images = dmodShared.imgNotes
        Indent = 19
        PopupMenu = popNoteList
        ReadOnly = True
        StateImages = dmodShared.imgImages
        TabOrder = 1
        OnChange = tvNotesChange
        OnClick = tvNotesClick
        OnCollapsed = tvNotesCollapsed
        OnCustomDraw = tvNotesCustomDraw
        OnCustomDrawItem = tvNotesCustomDrawItem
        OnDblClick = tvNotesDblClick
        OnDragDrop = tvNotesDragDrop
        OnDragOver = tvNotesDragOver
        OnExit = tvNotesExit
        OnExpanded = tvNotesExpanded
        OnStartDrag = tvNotesStartDrag
        Caption = 'Last 100 Notes'
        NodePiece = 0
        ShortNodeCaptions = True
      end
    end
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 260
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object lblNotes: TOROffsetLabel
        Left = 0
        Top = 15
        Width = 260
        Height = 18
        Align = alClient
        Caption = 'Last 100 Notes'
        HorzOffset = 2
        ParentShowHint = False
        ShowHint = True
        Transparent = True
        VertOffset = 4
        WordWrap = False
        OnClick = lblNotesClick
        ExplicitLeft = -6
        ExplicitTop = 9
        ExplicitWidth = 250
      end
      object pnlSort: TPanel
        Left = 0
        Top = 0
        Width = 260
        Height = 15
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object btnSortAuthor: TSpeedButton
          Left = 153
          Top = 3
          Width = 32
          Height = 13
          Hint = 'Sort By Author'
          Margins.Top = 1
          Margins.Bottom = 2
          GroupIndex = 1
          Caption = 'Author'
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = btnSortAuthorClick
        end
        object btnSortLocation: TSpeedButton
          Left = 113
          Top = 3
          Width = 40
          Height = 13
          Hint = 'Sort By Location'
          Margins.Top = 1
          Margins.Bottom = 2
          GroupIndex = 1
          Caption = 'Location'
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = btnSortLocationClick
        end
        object btnSortTitle: TSpeedButton
          Left = 87
          Top = 3
          Width = 26
          Height = 13
          Hint = 'Sort By Title'
          Margins.Top = 1
          Margins.Bottom = 2
          GroupIndex = 1
          Caption = 'Title'
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = btnSortTitleClick
        end
        object btnSortDate: TSpeedButton
          Left = 56
          Top = 3
          Width = 31
          Height = 13
          Hint = 'Sort By Visit Date'
          Margins.Top = 1
          Margins.Bottom = 2
          GroupIndex = 1
          Caption = 'Date'
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = btnSortDateClick
        end
        object btnSortNone: TSpeedButton
          Left = 17
          Top = 3
          Width = 39
          Height = 13
          Hint = 'Normal View'
          Margins.Top = 1
          Margins.Bottom = 2
          GroupIndex = 1
          Down = True
          Caption = 'Normal'
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = btnSortNoneClick
        end
        object btnHideTitle: TSpeedButton
          Left = 290
          Top = 3
          Width = 50
          Height = 13
          Hint = 'Click to Hide Note Title'
          AllowAllUp = True
          GroupIndex = 2
          Caption = '99 Hidden'
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = btnHideTitleClick
        end
        object btnAddHide: TSpeedButton
          Left = 280
          Top = 3
          Width = 10
          Height = 13
          Hint = 'Add Another Title to Hide'
          AllowAllUp = True
          GroupIndex = 3
          Caption = '+'
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Visible = False
          OnClick = btnAddHideClick
        end
        object btnSearchNotes: TSpeedButton
          Left = 2
          Top = 3
          Width = 15
          Height = 13
          Hint = 'Search for text in notes'
          AllowAllUp = True
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Glyph.Data = {
            3E020000424D3E0200000000000036000000280000000D0000000D0000000100
            1800000000000802000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF606060FFFF
            FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBF
            606060A0A0A060606000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFBFBFBF606060A0A0A0606060BFBFBF00FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFBFBFBF606060A0A0A0606060BFBFBFFFFFFF00FFFFFFFFFFFF
            FFBFBFFF7F7FFF7F7FFFBFBFBFBFBF606060A0A0A0606060BFBFBFFFFFFFFFFF
            FF00FFFFFFFF3F3FFF0000FF7F7FFF7F7FFF0000DF2020A0A0A0606060BFBFBF
            FFFFFFFFFFFFFFFFFF00FFBFBFFF3F3FFFFFFFFFFFFFFFFFFFFFFFFFFF3F3F7F
            4040BFBFBFFFFFFFFFFFFFFFFFFFFFFFFF00FF3F3FFFBFBFFFFFFFFFFFFFFFFF
            FFFFFFFFFFBFBFFF3F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FF0000FFFFFF
            7F7F7FBFBFBFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF00FF0000BFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFF00FF7F7FFF7F7FBFBFBFBFBFBF7F7F7FFFFFFFFF7F7FFF
            7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF0000FF7F7FBFBFBFFFFF
            FFFF7F7FFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFBFBF
            FF3F3FFF0000FF0000FF3F3FFFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF00}
          Margin = 0
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = mnuSearchNotesClick
        end
        object btnAdminDocs: TSpeedButton
          Left = 190
          Top = 2
          Width = 95
          Height = 13
          Hint = 'Click to show Admin docs'
          AllowAllUp = True
          GroupIndex = 2
          Down = True
          Caption = 'Hiding Admin Docs'
          Flat = True
          Font.Charset = ARABIC_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = btnAdminDocsClick
        end
      end
    end
  end
  inherited pnlRight: TPanel
    Left = 264
    Width = 815
    Height = 589
    ExplicitLeft = 264
    ExplicitWidth = 815
    ExplicitHeight = 589
    object sptVert: TSplitter
      Left = 0
      Top = 540
      Width = 815
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 309
      ExplicitWidth = 611
    end
    object memPCEShow: TRichEdit
      Left = 0
      Top = 544
      Width = 815
      Height = 45
      Align = alBottom
      Color = clCream
      Lines.Strings = (
        '<No encounter information entered>')
      PlainText = True
      PopupMenu = popEditEncounterElementsMenu
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
      OnDblClick = popEditEncounterElementsClick
      OnExit = memPCEShowExit
    end
    object pnlRead: TPanel
      Left = 0
      Top = 0
      Width = 815
      Height = 540
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      OnExit = pnlReadExit
      object lblTitle: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 815
        Height = 19
        Align = alTop
        Caption = 'No Progress Notes Found'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
        ExplicitWidth = 611
      end
      object sptList: TSplitter
        Left = 0
        Top = 113
        Width = 815
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitWidth = 611
      end
      object memNote: TRichEdit
        Left = 0
        Top = 116
        Width = 815
        Height = 424
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
        PopupMenu = popNoteMemo
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        WordWrap = False
      end
      object lvNotes: TCaptionListView
        Left = 0
        Top = 19
        Width = 815
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
        TabOrder = 0
        ViewStyle = vsReport
        Visible = False
        OnColumnClick = lvNotesColumnClick
        OnCompare = lvNotesCompare
        OnResize = lvNotesResize
        OnSelectItem = lvNotesSelectItem
        Caption = 'No Progress Notes Found'
      end
      object pnlHtmlView: TPanel
        Left = 0
        Top = 116
        Width = 815
        Height = 424
        Align = alClient
        BevelOuter = bvNone
        Color = clBtnShadow
        TabOrder = 2
        object pnlHtmlViewer: TPanel
          Left = 0
          Top = 20
          Width = 815
          Height = 404
          Align = alClient
          BevelOuter = bvNone
          Color = clBtnShadow
          TabOrder = 0
        end
        object pnlVewToolBar: TPanel
          Left = 0
          Top = 0
          Width = 815
          Height = 20
          Align = alTop
          TabOrder = 1
          object btnZoomIn: TSpeedButton
            Left = 39
            Top = 1
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
            OnClick = btnZoomInClick
          end
          object btnZoomNormal: TSpeedButton
            Left = 20
            Top = 1
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
            OnClick = btnZoomNormalClick
          end
          object btnZoomOut: TSpeedButton
            Left = 1
            Top = 1
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
            OnClick = btnZoomOutClick
          end
          object lblZoom: TLabel
            Left = 60
            Top = 3
            Width = 46
            Height = 13
            Caption = 'View Size'
          end
        end
      end
    end
    object pnlWrite: TPanel
      Left = 0
      Top = 0
      Width = 815
      Height = 540
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      OnResize = pnlWriteResize
      object pnlTextWrite: TPanel
        Left = 0
        Top = 67
        Width = 815
        Height = 473
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pnlTextWrite'
        TabOrder = 1
        object memNewNote: TRichEdit
          Left = 0
          Top = 0
          Width = 815
          Height = 473
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          PlainText = True
          PopupMenu = popNoteMemo
          ScrollBars = ssBoth
          TabOrder = 0
          WantTabs = True
          OnChange = memNewNoteChange
          OnKeyDown = memNewNoteKeyDown
          OnKeyPress = memNewNoteKeyPress
          OnKeyUp = memNewNoteKeyUp
        end
      end
      object pnlHTMLWrite: TPanel
        Left = 0
        Top = 67
        Width = 815
        Height = 473
        Align = alClient
        BevelOuter = bvNone
        Color = clInactiveBorder
        TabOrder = 2
        Visible = False
        object pnlHTMLEdit: TPanel
          Left = 0
          Top = 18
          Width = 815
          Height = 455
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
        object ToolBar: TToolBar
          Left = 0
          Top = 0
          Width = 815
          Height = 18
          AutoSize = True
          ButtonHeight = 18
          Caption = 'ToolBar'
          TabOrder = 1
          TabStop = True
          object btnDelete: TSpeedButton
            Left = 0
            Top = 0
            Width = 23
            Height = 18
            Hint = 'Delete Note'
            Glyph.Data = {
              3E020000424D3E0200000000000036000000280000000D0000000D0000000100
              18000000000008020000130B0000130B00000000000000000000D8E9ECD8E9EC
              DBECEDCFE0EB75757D76767F76767F76767F76767F8D8F8ED7E8EAD6E7EAD8E9
              EC00D9EAEDCAD9E39CA9C60708A50000A80000A80000A80000A80000A85D5C77
              605E70A9B0AED6E7EA00CFDFE72F33AF0000C30101D20101D20101D20101D201
              01D20101D20000C90D0DAD605E70D7E8EA00D4E4E80000980101D20101D20101
              D20101D20101D20101D20101D20101D20000C95D5C778D8F8E000000880101D2
              0101D2DEDEFFFEFEFF0101D20101D2CBCBFFFFFFFF0101D20101D20000A87676
              7F0000008A0101D20101D2A5A5FFFFFFFFDCDCFF9898FFFFFFFFCBCBFF0101D2
              0101D20000A876767F0000008A0101D20101D20101D27575FFFFFFFFFFFFFF98
              98FF0101D20101D20101D20000A876767F0000008A0101D20101D20101D2C4C4
              FFFFFFFFFFFFFFDCDCFF0101D20101D20101D20000A876767F0000008A0101D2
              0101D2D5D5FFFFFFFFC4C4FF7575FFFFFFFFFEFEFF0101D20101D20000A87575
              7D001D1F970101D20101D2BBBBFFD5D5FF0101D20101D2A5A5FFDEDEFF0101D2
              0101D20708A5CFE0EB00D5E5E90000960101D20101D20101D20101D20101D201
              01D20101D20101D20000C39CA9C6DBECED00D4E5EA5C64BB0000960101D20101
              D20101D20101D20101D20101D20000982F33AFCAD9E3D8E9EC00D8E9ECD4E5EA
              D5E5E91D1F9700008A00008A00008A00008A000088D4E4E8CFDFE7D9EAEDD8E9
              EC00}
            ParentShowHint = False
            ShowHint = True
            OnClick = mnuActDeleteClick
          end
          object cbFontNames: TComboBox
            Left = 23
            Top = 0
            Width = 145
            Height = 21
            ItemHeight = 13
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = cbFontNamesChange
          end
          object cbFontSize: TComboBox
            Left = 168
            Top = 0
            Width = 75
            Height = 21
            Hint = 'Font Size (Ctrl+(1-6))'
            ItemHeight = 13
            ItemIndex = 2
            TabOrder = 1
            Text = '3 (12 pt)'
            OnClick = cbFontSizeChange
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
            Left = 243
            Top = 0
            Width = 23
            Height = 18
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
            Left = 266
            Top = 0
            Width = 23
            Height = 18
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
            Left = 289
            Top = 0
            Width = 23
            Height = 18
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
            Left = 312
            Top = 0
            Width = 23
            Height = 18
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
            Left = 335
            Top = 0
            Width = 23
            Height = 18
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
            Left = 358
            Top = 0
            Width = 23
            Height = 18
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
            Left = 381
            Top = 0
            Width = 23
            Height = 18
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
            Left = 404
            Top = 0
            Width = 23
            Height = 18
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
            Left = 427
            Top = 0
            Width = 23
            Height = 18
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
            Left = 450
            Top = 0
            Width = 23
            Height = 18
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
            Left = 473
            Top = 0
            Width = 23
            Height = 18
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
          object btnShiftEnter: TSpeedButton
            Left = 496
            Top = 0
            Width = 23
            Height = 18
            Hint = 'Shift Enter'
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000130B0000130B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000
              0000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FF000000000000000000000000000000000000000000FF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00
              0000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00
              0000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FF030303030303030303030303030303030303FF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF03030303030303030303
              0303030303030303FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
            ParentShowHint = False
            ShowHint = True
            OnClick = btnShiftEnterClick
          end
          object btnTextColor: TSpeedButton
            Left = 519
            Top = 0
            Width = 23
            Height = 18
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
            Left = 542
            Top = 0
            Width = 23
            Height = 18
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
            Left = 565
            Top = 0
            Width = 23
            Height = 18
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
          object btnEditZoomOut: TSpeedButton
            Left = 588
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
            OnClick = btnEditZoomOutClick
          end
          object btnEditNormalZoom: TSpeedButton
            Left = 606
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
            OnClick = btnEditZoomNormalClick
          end
          object btnEditZoomIn: TSpeedButton
            Left = 624
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
            OnClick = btnEditZoomInClick
          end
        end
      end
      object pnlFields: TPanel
        Left = 0
        Top = 0
        Width = 815
        Height = 67
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        OnResize = pnlFieldsResize
        DesignSize = (
          815
          67)
        object bvlNewTitle: TBevel
          Left = 5
          Top = 5
          Width = 117
          Height = 15
        end
        object lblRefDate: TStaticText
          Left = 237
          Top = 6
          Width = 101
          Height = 17
          Hint = 'Press "Change..." to change date/time of note.'
          Alignment = taCenter
          Caption = 'Oct 20,1999@15:30'
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 2
        end
        object lblAuthor: TStaticText
          Left = 542
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
          TabOrder = 3
        end
        object lblVisit: TStaticText
          Left = 6
          Top = 21
          Width = 204
          Height = 17
          Caption = 'Vst: 10/20/99 Pulmonary Clinic, Dr. Welby'
          ShowAccelChar = False
          TabOrder = 4
        end
        object lblCosigner: TStaticText
          Left = 450
          Top = 21
          Width = 243
          Height = 13
          Hint = 'Press "Change..." to select a different cosigner.'
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = 'Expected Cosigner: Winchester,Charles Emerson III'
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          TabOrder = 5
        end
        object lblSubject: TStaticText
          Left = 6
          Top = 43
          Width = 43
          Height = 17
          Caption = 'Subject:'
          TabOrder = 6
        end
        object lblNewTitle: TStaticText
          Left = 6
          Top = 6
          Width = 119
          Height = 17
          Hint = 'Press "Change..." to select a different title.'
          Caption = ' General Medicine Note '
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
          TabOrder = 7
        end
        object cmdChange: TButton
          Left = 749
          Top = 6
          Width = 58
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Change...'
          TabOrder = 0
          OnClick = cmdChangeClick
          OnExit = cmdChangeExit
        end
        object txtSubject: TCaptionEdit
          Left = 48
          Top = 40
          Width = 759
          Height = 21
          Hint = 'Subject is limited to a maximum of 80 characters.'
          Anchors = [akLeft, akTop, akRight]
          MaxLength = 80
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = 'txtSubject'
          Caption = 'Subject'
        end
        object btnSave: TBitBtn
          Left = 716
          Top = 6
          Width = 31
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 9
          OnClick = btnSaveClick
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            08000000000000010000D30E0000D30E0000000100000001000000000000E577
            010080808000C0C0C000CECFCE00E7EBE7000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000030303030303
            0303030303030303030303030000000000000000000000000003030001010002
            0202020005050001000303000101000202020200050500010003030001010002
            0202020005050001000303000101000000000000000000010003030001010101
            0101010101010101000303000101020202020202020201010003030001020505
            0505050505050201000303000102050505050505050502010003030001020505
            0505050505050201000303000102050505050505050502010003030001020505
            0505050505050202000303000102050505050505050502040003030000000000
            0000000000000000000303030303030303030303030303030303}
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 96
    Data = (
      (
        'Component = cmdNewNote'
        'Status = stsDefault')
      (
        'Component = cmdPCE'
        'Status = stsDefault')
      (
        'Component = pnlDrawers'
        'Status = stsDefault')
      (
        'Component = lstNotes'
        'Status = stsDefault')
      (
        'Component = tvNotes'
        'Status = stsDefault')
      (
        'Component = memPCEShow'
        'Text = Encounter Information'
        'Status = stsOK')
      (
        'Component = pnlWrite'
        'Status = stsDefault')
      (
        'Component = memNewNote'
        'Status = stsDefault')
      (
        'Component = pnlFields'
        'Status = stsDefault')
      (
        'Component = lblRefDate'
        'Status = stsDefault')
      (
        'Component = lblAuthor'
        'Status = stsDefault')
      (
        'Component = lblVisit'
        'Status = stsDefault')
      (
        'Component = lblCosigner'
        'Status = stsDefault')
      (
        'Component = lblSubject'
        'Status = stsDefault')
      (
        'Component = lblNewTitle'
        'Status = stsDefault')
      (
        'Component = cmdChange'
        'Status = stsDefault')
      (
        'Component = txtSubject'
        'Status = stsDefault')
      (
        'Component = pnlRead'
        'Status = stsDefault')
      (
        'Component = memNote'
        'Status = stsDefault')
      (
        'Component = lvNotes'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmNotes'
        'Status = stsDefault')
      (
        'Component = pnlSort'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlHtmlView'
        'Status = stsDefault')
      (
        'Component = pnlVewToolBar'
        'Status = stsDefault')
      (
        'Component = btnSave'
        'Status = stsDefault'))
  end
  object mnuNotes: TMainMenu
    Left = 617
    Top = 304
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
      object Z3: TMenuItem
        Caption = '-'
      end
      object mnuViewAll: TMenuItem
        Tag = 1
        Caption = '&Signed Notes (All)'
        OnClick = mnuViewClick
      end
      object mnuViewByAuthor: TMenuItem
        Tag = 4
        Caption = 'Signed Notes by &Author'
        OnClick = mnuViewClick
      end
      object mnuViewByDate: TMenuItem
        Tag = 5
        Caption = 'Signed Notes by Date &Range'
        OnClick = mnuViewClick
      end
      object mnuViewUncosigned: TMenuItem
        Tag = 3
        Caption = 'Un&cosigned Notes'
        OnClick = mnuViewClick
      end
      object mnuViewUnsigned: TMenuItem
        Tag = 2
        Caption = '&Unsigned Notes'
        OnClick = mnuViewClick
      end
      object mnuViewCustom: TMenuItem
        Tag = 6
        Caption = 'Custo&m View'
        OnClick = mnuViewClick
      end
      object mnuSearchForText: TMenuItem
        Tag = 7
        Caption = 'Search for Te&xt (Within Current View)'
        OnClick = mnuViewClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuViewSaveAsDefault: TMenuItem
        Caption = 'Sa&ve as Default View'
        OnClick = mnuViewSaveAsDefaultClick
      end
      object ReturntoDefault1: TMenuItem
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
      object N6: TMenuItem
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
      OnClick = mnuActClick
      object mnuActNew: TMenuItem
        Caption = '&New Progress Note...'
        Hint = 'Creates a new progress note'
        ShortCut = 24654
        OnClick = mnuActNewClick
      end
      object mnuActAddend: TMenuItem
        Caption = '&Make Addendum...'
        Hint = 'Makes an addendum for the currently selected note'
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
      object mnuEncounter: TMenuItem
        Caption = 'Encounte&r'
        ShortCut = 24658
        OnClick = cmdPCEClick
      end
      object Z4: TMenuItem
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
      object Z2: TMenuItem
        Caption = '-'
      end
      object mnuActSignList: TMenuItem
        Caption = 'Add to Signature &List'
        Hint = 'Adds the currently displayed note to list of things to be signed'
        OnClick = mnuActSignListClick
      end
      object mnuActDelete: TMenuItem
        Caption = '&Delete Progress Note...'
        ShortCut = 24644
        OnClick = mnuActDeleteClick
      end
      object mnuActEdit: TMenuItem
        Caption = '&Edit Progress Note...'
        ShortCut = 24645
        OnClick = mnuActEditClick
      end
      object mnuActSave: TMenuItem
        Caption = 'S&ave without Signature'
        Hint = 'Saves the note that is being edited'
        ShortCut = 24641
        OnClick = mnuActSaveClick
      end
      object mnuActSign: TMenuItem
        Caption = 'Si&gn Note Now...'
        ShortCut = 24647
        OnClick = mnuActSignClick
      end
      object mnuActIdentifyAddlSigners: TMenuItem
        Caption = '&Identify Additional Signers'
        OnClick = mnuActIdentifyAddlSignersClick
      end
      object mnuSearchNotes: TMenuItem
        Caption = '&Search Notes'
        OnClick = mnuSearchNotesClick
      end
      object mnuQuickSearchTemplates: TMenuItem
        Caption = '&Quick Search Templates'
        OnClick = mnuQuickSearchTemplatesClick
      end
      object mnuLaunchMDM: TMenuItem
        Caption = 'Launch MDM &Helper'
        OnClick = mnuLaunchMDMClick
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
      object N2: TMenuItem
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
      object N3: TMenuItem
        Caption = '-'
        OnClick = cmdChangeClick
      end
      object mnuEditDialgFields: TMenuItem
        Caption = 'Edit Template &Fields'
        OnClick = mnuEditDialgFieldsClick
      end
    end
  end
  object popNoteMemo: TPopupMenu
    OnPopup = popNoteMemoPopup
    Left = 540
    Top = 304
    object popNoteMemoCut: TMenuItem
      Caption = 'Cu&t'
      ShortCut = 16472
      OnClick = popNoteMemoCutClick
    end
    object popNoteMemoCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = popNoteMemoCopyClick
    end
    object popNoteMemoPaste: TMenuItem
      Caption = '&Paste'
      ShortCut = 16470
      OnClick = popNoteMemoPasteClick
    end
    object popNoteMemoPaste2: TMenuItem
      Caption = 'Paste2'
      ShortCut = 8237
      Visible = False
      OnClick = popNoteMemoPasteClick
    end
    object popNotePasteHTML: TMenuItem
      Caption = 'Paste Text As HTML'
      ShortCut = 24660
      OnClick = popNotePasteHTMLClick
    end
    object popNoteMemoProcess: TMenuItem
      Caption = '&Process Note'
      ShortCut = 24656
      OnClick = popNoteMemoProcessClick
    end
    object popNoteMacro: TMenuItem
      Caption = 'Macro'
      Hint = 'Test'
    end
    object popNoteMemoReformat: TMenuItem
      Caption = 'Reformat Paragraph'
      ShortCut = 24658
      OnClick = popNoteMemoReformatClick
    end
    object popNoteMemoViewHTMLSource: TMenuItem
      Caption = 'View &HTML Source'
      ShortCut = 24648
      OnClick = popNoteMemoViewHTMLSourceClick
    end
    object popNoteMemoSaveContinue: TMenuItem
      Caption = 'Save && Continue Editing'
      ShortCut = 24659
      Visible = False
      OnClick = popNoteMemoSaveContinueClick
    end
    object popNoteMemoHTMLFormat: TMenuItem
      Caption = 'Change Edit M&ode to Formatted Text'
      OnClick = popNoteMemoHTMLFormatClick
    end
    object Z11: TMenuItem
      Caption = '-'
    end
    object popNoteMemoFind: TMenuItem
      Caption = '&Find in Selected Note'
      OnClick = popNoteMemoFindClick
    end
    object popNoteMemoReplace: TMenuItem
      Caption = '&Replace Text'
      OnClick = popNoteMemoReplaceClick
    end
    object N7: TMenuItem
      Caption = '-'
      OnClick = cmdChangeClick
    end
    object popNoteMemoGrammar: TMenuItem
      Caption = 'Check &Grammar'
      OnClick = popNoteMemoGrammarClick
    end
    object popNoteMemoSpell: TMenuItem
      Caption = 'C&heck Spelling'
      OnClick = popNoteMemoSpellClick
    end
    object Z12: TMenuItem
      Caption = '-'
    end
    object popNoteMemoTemplate: TMenuItem
      Caption = 'Copy into New &Template'
      OnClick = popNoteMemoTemplateClick
    end
    object Z10: TMenuItem
      Caption = '-'
    end
    object popNoteMemoSignList: TMenuItem
      Caption = 'Add to Signature &List'
      OnClick = mnuActSignListClick
    end
    object popNoteMemoDelete: TMenuItem
      Caption = '&Delete Progress Note...'
      OnClick = mnuActDeleteClick
    end
    object popNoteMemoEdit: TMenuItem
      Caption = '&Edit Progress Note...'
      OnClick = mnuActEditClick
    end
    object popNoteMemoAddend: TMenuItem
      Caption = '&Make Addendum...'
      OnClick = mnuActAddendClick
    end
    object popAddComponent: TMenuItem
      Caption = 'Add Note &Component...'
      OnClick = popAddComponentClick
    end
    object popNoteMemoSave: TMenuItem
      Caption = 'S&ave without Signature'
      OnClick = mnuActSaveClick
    end
    object popNoteMemoSign: TMenuItem
      Caption = '&Sign Note Now...'
      OnClick = mnuActSignClick
    end
    object popNoteMemoAddlSign: TMenuItem
      Caption = '&Identify Additional Signers'
      OnClick = popNoteMemoAddlSignClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object popNoteMemoPreview: TMenuItem
      Caption = 'Previe&w/Print Current Template'
      ShortCut = 16471
      OnClick = popNoteMemoPreviewClick
    end
    object popNoteMemoInsTemplate: TMenuItem
      Caption = 'Insert Current Template'
      ShortCut = 16429
      OnClick = popNoteMemoInsTemplateClick
    end
    object popNoteMemoEncounter: TMenuItem
      Caption = 'Edit Encounter Information'
      ShortCut = 16453
      OnClick = cmdPCEClick
    end
    object popNoteMemoViewCslt: TMenuItem
      Caption = 'View Consult Details'
      ShortCut = 24661
      OnClick = popNoteMemoViewCsltClick
    end
    object popNoteMemoLinkToConsult: TMenuItem
      Caption = '&Link To Consult'
      OnClick = popNoteMemoLinkToConsultClick
    end
    object popNoteViewInBrowser: TMenuItem
      Caption = 'View This Note In Browser'
      OnClick = popNoteViewInBrowserClick
    end
    object popNoteViewInBrowser2: TMenuItem
      Caption = 'View This Scan In Browser'
      OnClick = popNoteViewInBrowser2Click
    end
    object ViewWindowsMessages1: TMenuItem
      Caption = 'View Windows Messages'
      OnClick = ViewWindowsMessages1Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object mnuLooseInChartDelete: TMenuItem
      Caption = 'Delete Loose Doc'
      OnClick = mnuLooseInChartDeleteClick
    end
    object mnuLooseInChartMoveScanned: TMenuItem
      Caption = 'Move Loose Doc To Scanned Records'
      OnClick = mnuLooseInChartMoveScannedClick
    end
    object mnuLooseInChartMoveTIU: TMenuItem
      Caption = 'Move Loose Doc To TIU Note'
      OnClick = mnuLooseInChartMoveTIUClick
    end
    object mnuMoveToLoose: TMenuItem
      Caption = 'Move Note To Loose Document'
      OnClick = mnuMoveToLooseClick
    end
  end
  object popNoteList: TPopupMenu
    OnPopup = popNoteListPopup
    Left = 500
    Top = 305
    object popNoteListAll: TMenuItem
      Tag = 1
      Caption = '&Signed Notes (All)'
      OnClick = mnuViewClick
    end
    object popNoteListByAuthor: TMenuItem
      Tag = 4
      Caption = 'Signed Notes by &Author'
      OnClick = mnuViewClick
    end
    object popNoteListByDate: TMenuItem
      Tag = 5
      Caption = 'Signed Notes by Date &Range'
      OnClick = mnuViewClick
    end
    object popNoteListUncosigned: TMenuItem
      Tag = 3
      Caption = 'Un&cosigned Notes'
      OnClick = mnuViewClick
    end
    object popNoteListUnsigned: TMenuItem
      Tag = 2
      Caption = '&Unsigned Notes'
      OnClick = mnuViewClick
    end
    object popNoteListCustom: TMenuItem
      Tag = 6
      Caption = 'Cus&tom View'
      OnClick = mnuViewClick
    end
    object popSearchForText: TMenuItem
      Tag = 7
      Caption = 'Search for Te&xt (Within Current View)'
      OnClick = mnuViewClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object popNoteListExpandSelected: TMenuItem
      Caption = '&Expand Selected'
      OnClick = popNoteListExpandSelectedClick
    end
    object popNoteListExpandAll: TMenuItem
      Caption = 'E&xpand All'
      OnClick = popNoteListExpandAllClick
    end
    object popNoteListCollapseSelected: TMenuItem
      Caption = 'C&ollapse Selected'
      OnClick = popNoteListCollapseSelectedClick
    end
    object popNoteListCollapseAll: TMenuItem
      Caption = 'Co&llapse All'
      OnClick = popNoteListCollapseAllClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object popNoteListAddIDEntry: TMenuItem
      Caption = 'Add Ne&w Entry to Interdisciplinary Note'
      OnClick = mnuActAddIDEntryClick
    end
    object popNoteListAttachtoIDParent: TMenuItem
      Caption = 'A&ttach to Interdisciplinary Note'
      OnClick = mnuActAttachtoIDParentClick
    end
    object popNoteListDetachFromIDParent: TMenuItem
      Caption = 'Detac&h from Interdisciplinary Note'
      OnClick = mnuActDetachFromIDParentClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object mnuHideTitle: TMenuItem
      Caption = 'Hide Title'
      OnClick = mnuHideTitleClick
    end
    object mnuLooseDelete: TMenuItem
      Caption = 'Delete Loose Doc'
      OnClick = mnuLooseInChartDeleteClick
    end
    object mnuLooseDocToScanned: TMenuItem
      Caption = 'Move Loose Doc To Scanned Records'
      OnClick = mnuLooseInChartMoveScannedClick
    end
    object mnuLooseDocToTIUNote: TMenuItem
      Caption = 'Move Loose Doc To TIU Note'
      OnClick = mnuLooseInChartMoveTIUClick
    end
    object mnuViewThisScanInBrowser: TMenuItem
      Caption = 'View This Scan In Browser'
      OnClick = popNoteViewInBrowser2Click
    end
  end
  object timAutoSave: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = timAutoSaveTimer
    Left = 592
    Top = 27
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
    Left = 413
    Top = 312
  end
  object imgLblNotes: TVA508ImageListLabeler
    Components = <
      item
        Component = lvNotes
      end
      item
        Component = tvNotes
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblNotes
    Left = 16
    Top = 195
  end
  object popupAddImage: TPopupMenu
    Left = 580
    Top = 304
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
    object AddUniversalImage: TMenuItem
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
      Caption = 'Add &Universal Image'
      OnClick = AddUniversalImageClick
    end
  end
  object imgLblImages: TVA508ImageListLabeler
    Components = <
      item
        Component = lvNotes
      end
      item
        Component = tvNotes
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblImages
    Left = 16
    Top = 235
  end
  object popEditEncounterElementsMenu: TPopupMenu
    Left = 440
    Top = 952
    object popEditEncounterElements: TMenuItem
      Caption = '&Edit Encounter Elements'
      OnClick = popEditEncounterElementsClick
    end
  end
end
