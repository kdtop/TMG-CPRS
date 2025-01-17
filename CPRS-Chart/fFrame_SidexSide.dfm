inherited frmFrame: TfrmFrame
  Left = 196
  Top = 119
  Caption = 'CPRS'
  ClientHeight = 743
  ClientWidth = 872
  FormStyle = fsMDIForm
  Menu = mnuFrame
  OldCreateOrder = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  ExplicitWidth = 888
  ExplicitHeight = 801
  PixelsPerInch = 96
  TextHeight = 13
  object pnlNoPatientSelected: TPanel [0]
    Left = 0
    Top = 0
    Width = 872
    Height = 743
    Align = alClient
    Caption = 'No patient is currently selected'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
  end
  object pnlPatientSelected: TPanel [1]
    Left = 0
    Top = 0
    Width = 872
    Height = 743
    Align = alClient
    TabOrder = 1
    object bvlPageTop: TBevel
      Left = 1
      Top = 41
      Width = 870
      Height = 1
      Align = alTop
      ExplicitWidth = 674
    end
    object stsArea: TStatusBar
      Left = 1
      Top = 721
      Width = 870
      Height = 21
      Panels = <
        item
          Width = 200
        end
        item
          Width = 224
        end
        item
          Style = psOwnerDraw
          Width = 50
        end
        item
          Width = 94
        end
        item
          Width = 38
        end
        item
          Width = 33
        end>
      PopupMenu = popAlerts
      SizeGrip = False
    end
    object pnlMain: TPanel
      Left = 1
      Top = 42
      Width = 870
      Height = 679
      Align = alClient
      BevelOuter = bvNone
      Color = clPurple
      TabOrder = 1
      DesignSize = (
        870
        679)
      object frameLRSplitter: TSplitter
        Left = 700
        Top = 0
        Width = 5
        Height = 679
        Color = clHighlight
        ParentColor = False
        OnMoved = frameLRSplitterMoved
        ExplicitLeft = 441
        ExplicitHeight = 659
      end
      object pnlMainL: TPanel
        Left = 0
        Top = 0
        Width = 700
        Height = 679
        Align = alLeft
        TabOrder = 0
        object pnlPageL: TPanel
          Left = 1
          Top = 1
          Width = 698
          Height = 655
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object sbtnFontSmaller: TSpeedButton
            Tag = -1
            Left = 101
            Top = 216
            Width = 18
            Height = 18
            Hint = 'SMALLER font size'
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
            OnClick = sbtnFontChangeClick
          end
          object sbtnFontNormal: TSpeedButton
            Left = 125
            Top = 216
            Width = 18
            Height = 18
            Hint = 'NORMAL font size'
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
            OnClick = sbtnFontChangeClick
          end
          object sbtnFontLarger: TSpeedButton
            Tag = 1
            Left = 149
            Top = 216
            Width = 18
            Height = 18
            Hint = 'LARGER font size'
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
            OnClick = sbtnFontChangeClick
          end
          object lstCIRNLocations: TORListBox
            Left = 225
            Top = 37
            Width = 209
            Height = 69
            TabStop = False
            Style = lbOwnerDrawFixed
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 18
            ParentFont = False
            ParentShowHint = False
            PopupMenu = popCIRN
            ShowHint = False
            TabOrder = 0
            Visible = False
            OnClick = lstCIRNLocationsClick
            OnExit = lstCIRNLocationsExit
            Caption = 'Remote Data'
            ItemTipColor = clWindow
            LongList = False
            Pieces = '2,3,4'
            TabPositions = '16'
            OnChange = lstCIRNLocationsChange
            RightClickSelect = True
            CheckBoxes = True
            CheckEntireLine = True
          end
        end
        object tabPageL: TTabControl
          Left = 1
          Top = 656
          Width = 698
          Height = 22
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          OwnerDraw = True
          ParentFont = False
          TabOrder = 1
          TabPosition = tpBottom
          OnChange = tabPageLChange
          OnDrawTab = tabPageDrawTab
          OnMouseUp = tabPageLMouseUp
        end
      end
      object pnlMainR: TPanel
        Left = 705
        Top = 0
        Width = 165
        Height = 679
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object pnlPageR: TPanel
          Left = 0
          Top = 0
          Width = 165
          Height = 657
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
        object tabPageR: TTabControl
          Left = 0
          Top = 657
          Width = 165
          Height = 22
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          OwnerDraw = True
          ParentFont = False
          TabOrder = 1
          TabPosition = tpBottom
          OnChange = tabPageRChange
          OnDrawTab = tabPageDrawTab
          OnMouseUp = tabPageRMouseUp
        end
      end
      object btnSplitterHandle: TBitBtn
        Left = 669
        Top = 265
        Width = 30
        Height = 80
        Anchors = [akRight]
        TabOrder = 2
        Visible = False
        OnClick = btnSplitterHandleClick
        OnMouseEnter = btnSplitterHandleMouseEnter
        OnMouseLeave = btnSplitterHandleMouseLeave
        Glyph.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          20000000000000090000130B0000130B00000000000000000000D8E9ECFED7E8
          EBFFD8E9EBFED8E9ECFED6E5E8FFD8E9EBFED8E9ECFED3BFC1FFD17778FED238
          33FFD5241CFFD81B13FFD91D13FFD5261DFFD43D36FFD27B7BFED4C0C3FFD8E9
          EBFED8E9ECFED6E5E8FFD8E9EBFED8E9ECFED7E8EBFFD8E9EBFED8E9ECFFD7E8
          EBFFD8E9EBFFD8E9ECFFD7E8EBFFD4CACBFFCF4544FFD51710FFE03A1FFFE96A
          37FFEF8A47FFF09B50FFF19E52FFEF8E4BFFEC723DFFE44527FFD92217FFD34F
          4CFFD5CBCDFFD7E8EBFFD8E9EBFFD8E9ECFFD7E8EBFFD8E9EBFFD8E9ECFED7E8
          EBFFD8E9ECFED8E9ECFED08C8FFFD01511FFE23B20FFED7F41FFF4AE59FFF6C8
          67FFF8D470FFF9DD75FFF8DA74FFF8D472FFF6CB6CFFF5B361FFEE8D4CFFE650
          2EFFD6231BFFD29193FFD8E9ECFED8E9ECFED7E8EBFFD8E9ECFED8E9ECFED7E8
          EBFFD8E9EBFECE6D6FFED6130CFFE6562DFFF29F51FFF4B660FFF6C269FFF7D0
          74FFFADE7CFFFAE883FFFAE682FFFADC7EFFF9D178FFF7C570FFF4BA69FFF3A9
          5DFFEB6F3EFFDE2618FFD27576FED8E9ECFED7E8EBFFD8E9EBFED7E6E9FFD7E8
          EBFFD08C8EFFD6110BFFE6572EFFEF914CFFF1A85AFFF4B564FFF6C26FFFF0CB
          76FFB19C5CFFB2A265FFD0BE73FFF9DE86FFF9D580FFECBC71FFB18752FFAE7E
          4AFFE79755FFEA7240FFDC2417FFD29294FFD7E8EBFFD7E6E8FFD8E9ECFED2C8
          CAFFCF100DFFE24223FFED8244FFF09550FFF2A75EFFF5B66AFFBF995CFF9F8A
          5EFFD3C9B4FFF0E7D8FFC6B286FFEFD588FFC8AB6CFFA48C62FFD5C9B3FFD9C8
          AEFFA86E3EFFCA7C48FFA74729FFD1211AFFD3CACCFFD8E9ECFED8E9ECFECB3F
          40FFD92112FFEB713AFFEE8748FFEF9554FFBB844DFF9C7D52FFBEB197FFFBF5
          E7FFFFFFFAFFF7F2E9FFA1957FFF958258FFD0C5ABFFFEF7EAFFFFFFF7FFD8D2
          C7FF61452BFF7D6751FFC8B29BFFE9654EFFD14F4DFFD8E9EBFED2BEC1FFCF09
          07FFE24324FFEC7740FFCC7441FF916037FFB29D7FFFF3EAD7FFFFFFFBFFF7F4
          EAFFCAC4B9FFA5A094FFB7B1A3FFF5F0E4FFFFFFFCFFEBE7DFFFB0AA9EFF928D
          80FFB6AFA0FFF8F3E3FFFFFCECFFF5B192FFD92018FFD4C1C3FFCF7274FED614
          0CFFD6512BFF884624FF9C7A58FFE1D4BEFFFFFFF6FFFCF7ECFFD0CABFFFA39D
          90FFB4AFA2FFE9E5DBFFFEFEF9FFF7F4EDFFCBC6BBFFA39C8FFFC1BCAFFFEFEA
          DDFFFFFFF7FFFEF9EBFFFEF6E4FFF9D8BFFFE54937FFD37B7CFECD2A2AFFA21B
          0EFF835034FFD2BDA2FFFFFAE6FFFFFFF1FFDCD3C9FF9F988BFFA1988BFFDFD8
          CDFFFFFCF4FFFEFDF6FFE1DBD3FFBAB3A7FFC9C2B4FFF2EDE4FFFFFEF5FFFEFD
          F2FFFFF8EBFFFEF6E9FFFFF5E6FFFEEAD5FFEB795FFFD53B38FFC6100EFFCA6A
          51FFFDE9D1FFFFFBE8FFFFF7E5FFE2D8CBFF9E9487FFC6BBAFFFFBF4E9FFFFFE
          F6FFFFFEF6FFE7E1D8FFCFC6BAFFF5EFE8FFFFFDF9FFFFFDF6FFFFFAF1FFFFF9
          EEFFFEF8ECFFFEF7E8FFFFF6E4FFFEEFDDFFF0957AFFD5221EFFCF0B09FFF4B1
          98FFFFF7E4FFFEF0DCFFFEF2DEFFC9BDB1FFA5968CFFFFFAF0FFFEFBF2FFFEF9
          EFFFFEFBF4FFD4CABFFFF1EBE6FFFFFFFEFFFEFDF8FFFEFAF2FFFEFAF1FFFEF7
          ECFFFDF5E8FFFEF6E8FFFFF5E3FFFEF0DDFFF2A086FFD61714FFC20504FFAC48
          30FFDABFA2FFFFF9E4FFFEF7E5FFEEE3D4FFAC9F92FFAA9E8FFFE4DACDFFFEFA
          F1FFFFFFF7FFEFEAE1FFCBC0B2FFE3DBD0FFF9F5EEFFFEFDF6FFFFFAF1FFFDF5
          E9FFFDF3E7FFFFF4E5FFFEF2E2FFFEF0DCFFF29B83FFD51613FFCD100FFFBF1B
          10FF833018FFAA7E5DFFF3DEBFFFFFFFEFFFFAF1E3FFC4BAADFFA29787FFC0B6
          A7FFF3EDE3FFFFFFF8FFF7F2ECFFD1C8BCFFBBB1A2FFDAD0C4FFFBF4EBFFFFFC
          F1FFFFF8EAFFFFF4E5FFFEF2E1FFFEECD8FFEE846EFFD5201BFFCC2A2BFFD814
          0DFFDF3A21FFA83A23FF924B2DFFBF9C7BFFFDEEDAFFFFFFF2FFF3EDE3FFD0C7
          BDFFC0B6A7FFDAD1C5FFFDFAF3FFFFFFFAFFEDE8E0FFC0B5A8FFA89C8CFFD3C9
          BBFFFFF8E8FFFFFDECFFFFF5E2FFFBE1CCFFE85E4EFFD33938FFD07576FED109
          06FFDB2D1AFFE34126FFE54C2FFFB1462CFFAE6D45FFE4D0B8FFFFFAF0FFFFFF
          FAFFF4EFEAFFD5CEC4FFD1C7B7FFF7F2E9FFFFFFFBFFFBF7F1FFE1DCD4FF9F94
          87FF88725FFFD3C5B5FFFFF3E3FFF8C7B3FFDE3129FFD47F80FED4C0C3FFCD06
          04FFD9180FFFDE3720FFE34128FFEA5B39FFEF7750FFC66142FFCD9C7CFFF1E8
          DCFFFFFFFBFFFFFFFDFFD6BEAEFFBB805BFFEDDBCCFFFFFBF6FFFFFFFDFFF8F3
          EFFF7A3B25FF793523FF997A6CFFDB7768FFD71B1AFFD6C4C6FFD8E9ECFECE43
          44FFD10906FFDD2617FFE03B23FFF1593AFFF46E49FFF47650FFED7955FFCB71
          4FFFD8B3A0FFEBDCD0FFD8987CFFF18E65FFD6724FFFCF9B82FFEFE3D9FFF1E3
          D8FFC1573BFFDD422BFF9B281AFFBA211AFFD86363FFD8E9ECFED8E9ECFED5CB
          CDFFCE0B0BFFD40F0AFFE12D1DFFF24F31FFF45B3CFFF46644FFF46F4BFFF679
          54FFEB7451FFDF6F4DFFF07C58FFF6835CFFF6815AFFF07453FFD0573DFFD053
          38FFEA5538FFDF3422FFDB1C14FFDB3838FFD7CED0FFD8E9EBFED7E6E9FFD7E8
          EBFFD49394FFCF0403FFDA130CFFF13924FFF54D32FFF45437FFF55F3FFFF767
          47FFF66C4BFFF7704FFFF77150FFF7704FFFF76D4BFFF66949FFF65F44FFF65D
          40FFED452DFFD91C14FFDE2C2AFFDBA5A6FFD7E8EBFFD7E6E8FFD8E9ECFED7E8
          EBFFD8E9ECFED27577FECF0605FFE4120DFFF73523FFF6452EFFF64E33FFF655
          3AFFF7593BFFF75F40FFF75F40FFF75D40FFF75C40FFF7553AFFF85339FFF543
          2FFFDF1B14FFDD2B29FFDB9192FED8E9ECFED7E8EBFFD8E9ECFED8E9ECFED7E8
          EBFFD8E9EBFED8E9ECFED69A9CFFD31D1DFFE51714FFF41D15FFF83423FFF93E
          29FFF8422CFFF8452FFFF94831FFF8462FFFF94330FFF93C2BFFF2251BFFE021
          1DFFDD3B3BFFDAA5A7FFD8E9EBFED8E9ECFED7E8EBFFD8E9EBFED8E9ECFFD7E8
          EBFFD8E9EBFFD8E9ECFFD7E8EBFFD9D0D1FFDA6466FFDD2425FFE72323FFEE17
          13FFF31914FFF51F16FFF52117FFF21C15FFEC1B16FFE52A27FFDB2828FFDD6F
          70FFD8D0D2FFD7E8EBFFD8E9EBFFD8E9ECFFD7E8EBFFD8E9EBFFD8E9ECFED7E8
          EBFFD8E9ECFED8E9ECFED6E5E8FFD8E9ECFED8E9ECFED9C7C9FFD98D8FFEDB53
          54FFDF3B3BFFDF2728FFDF2728FFDE3C3CFFDB5354FFDA9091FED9C6C9FFD8E9
          ECFED8E9ECFED6E5E8FFD8E9ECFED8E9ECFED7E8EBFFD8E9ECFE}
      end
    end
    object pnlToolbar: TPanel
      Left = 1
      Top = 1
      Width = 870
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      Caption = 'object pnlRemoteData: TKeyClickPanel'
      TabOrder = 2
      object bvlToolTop: TBevel
        Left = 0
        Top = 0
        Width = 870
        Height = 1
        Align = alTop
        Style = bsRaised
        ExplicitWidth = 674
      end
      object pnlCCOW: TPanel
        Left = 0
        Top = 1
        Width = 39
        Height = 39
        Align = alLeft
        BevelWidth = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        object imgCCOW: TImage
          Left = 2
          Top = 2
          Width = 35
          Height = 35
          Align = alClient
          Center = True
          Picture.Data = {
            07544269746D617052030000424D520300000000000052020000280000001000
            000010000000010008000000000000010000120B0000120B0000870000008700
            00003F3E3F003A393A007B351600BCB6B30082340900642700008D3F0D00985B
            3400B19A8C00B5A59B008B3700008A3700008936000088360000873500008635
            00008535000083340000813300007D3100007D3200007B3100007A3000007830
            0000772F0000762F0000742E00006F2C00006E2B00006C2B00006A2A00006829
            0000662800006528000061260000602600005C2400005B240000592300005823
            0000562200008B3801008C3902008C3903008C3A04008C3B05008D3B06008D3C
            07008E3E0A008F420F009045130090481900935025009B6440009F6D4C00A275
            5800A6806700AA897300AD917F00B8AEA700053A0D00063B0E000C3F14000E41
            16000A3C17002351360000007F0000007B000101800001017F00040480000707
            820007078100080882000A0A82000D0D7200101085000E0E7200131386001313
            7500171787001919880021218A0025258C0023237B002B2B8E002C2C8E002F2F
            8F002C2C79003535840039398500FFFFFF00DFDFDF00BFBFBF00BEBEBE00BCBC
            BC00BBBBBB00B9B9B900B8B8B800B7B7B700B4B4B400B2B2B200B1B1B100ACAC
            AC00A9A9A900A7A7A700A6A6A600A4A4A400A2A2A2009F9F9F00989898009797
            970094949400929292008F8F8F008C8C8C008B8B8B0089898900858585008484
            840083838300818181007F7F7F007E7E7E007D7D7D007B7B7B007A7A7A007979
            79007777770076767600747474000A0A0A000707070001010100000000005D04
            868686865D868686865D5D5D5D5D5D865B5B5B5B865B5B5B5B865D5D5D5D865B
            8686868686868686865B865D5D5D865B865D865D5D5D865D865B865D5D5D865B
            8686868686868686865B865D5D5D0A865B5B5B5B865B5B5B5B865D5D5D5D0A0A
            868686865D868686865D5D5D5D5D0A0A0A0A0A0A5D5D5D5D5D0C0C5D5D5D0A0A
            0A0A0A0A5D5D5D5D5D0C0C5D5D5D0A0A0A0A0A0A5D5D5D5D5D5D5D5D5D5D5D29
            0A0A0A5D5D5D5D5D5D0C0C5D5D5D5D5D0A0A5D5D5D5D5D5D5D0C0C0C5D5D5D0A
            0A0A2F5D5D5D5D5D5D5D0C0C0C5D5D0A0A0A305D5D5D5D5D5D5D5D0C0C5D5D02
            0A0A025D5D5D5D5D0C0C0C0C0C5D5D5D5D5D5D5D5D5D5D5D0C0C0C0C5D5D}
          ExplicitLeft = 4
          ExplicitTop = -1
        end
      end
      object pnlPatient: TKeyClickPanel
        Left = 78
        Top = 1
        Width = 187
        Height = 39
        Cursor = crHandPoint
        Hint = 'Click for more patient information.'
        Align = alLeft
        BevelWidth = 2
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clInfoBk
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TabStop = True
        OnClick = pnlPatientClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlPatientMouseDown
        OnMouseUp = pnlPatientMouseUp
        object lblPtName: TStaticText
          Left = 6
          Top = 4
          Width = 118
          Height = 17
          Cursor = crHandPoint
          Caption = 'No Patient Selected'
          Font.Charset = ANSI_CHARSET
          Font.Color = clInfoText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlPatientClick
          OnMouseDown = pnlPatientMouseDown
          OnMouseUp = pnlPatientMouseUp
        end
        object lblPtSSN: TStaticText
          Left = 6
          Top = 19
          Width = 64
          Height = 17
          Cursor = crHandPoint
          Caption = '000-00-0000'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = pnlPatientClick
          OnMouseDown = pnlPatientMouseDown
          OnMouseUp = pnlPatientMouseUp
        end
        object lblPtAge: TStaticText
          Left = 175
          Top = 19
          Width = 4
          Height = 4
          Cursor = crHandPoint
          Alignment = taRightJustify
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 2
          OnClick = pnlPatientClick
          OnMouseDown = pnlPatientMouseDown
          OnMouseUp = pnlPatientMouseUp
        end
      end
      object pnlVisit: TKeyClickPanel
        Left = 265
        Top = 1
        Width = 119
        Height = 39
        Cursor = crHandPoint
        Hint = 'Click to change provider/location.'
        Align = alLeft
        BevelWidth = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
        OnClick = pnlVisitClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        object lblPtLocation: TStaticText
          Left = 6
          Top = 4
          Width = 53
          Height = 17
          Cursor = crHandPoint
          Caption = 'Location'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlVisitClick
        end
        object lblPtProvider: TStaticText
          Left = 6
          Top = 17
          Width = 43
          Height = 17
          Cursor = crHandPoint
          Caption = 'Provider'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = pnlVisitClick
        end
      end
      object pnlPrimaryCare: TKeyClickPanel
        Left = 384
        Top = 1
        Width = 50
        Height = 39
        Cursor = crHandPoint
        Hint = 'Primary Care Team / Primary Care Provider'
        Align = alLeft
        BevelWidth = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = True
        OnClick = pnlPrimaryCareClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlPrimaryCareMouseDown
        OnMouseUp = pnlPrimaryCareMouseUp
        object lblPtCare: TStaticText
          Left = 6
          Top = 4
          Width = 4
          Height = 4
          Cursor = crHandPoint
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlPrimaryCareClick
          OnMouseDown = pnlPrimaryCareMouseDown
          OnMouseUp = pnlPrimaryCareMouseUp
        end
        object lblPtAttending: TStaticText
          Left = 6
          Top = 19
          Width = 4
          Height = 4
          Cursor = crHandPoint
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = pnlPrimaryCareClick
          OnMouseDown = pnlPrimaryCareMouseDown
          OnMouseUp = pnlPrimaryCareMouseUp
        end
        object lblPtMHTC: TStaticText
          Left = 6
          Top = 34
          Width = 4
          Height = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = pnlPrimaryCareClick
          OnMouseDown = pnlPrimaryCareMouseDown
          OnMouseUp = pnlPrimaryCareMouseUp
        end
      end
      object pnlReminders: TKeyClickPanel
        Left = 765
        Top = 1
        Width = 35
        Height = 39
        Cursor = crHandPoint
        Align = alRight
        BevelWidth = 2
        Caption = 'Reminders'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        TabStop = True
        OnClick = pnlRemindersClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlRemindersMouseDown
        OnMouseUp = pnlRemindersMouseUp
        object imgReminder: TImage
          Left = 2
          Top = 2
          Width = 31
          Height = 35
          Cursor = crHandPoint
          Align = alClient
          Center = True
          OnMouseDown = pnlRemindersMouseDown
          OnMouseUp = pnlRemindersMouseUp
        end
        object anmtRemSearch: TAnimate
          Left = 2
          Top = 2
          Width = 31
          Height = 35
          Cursor = crHandPoint
          Align = alClient
          Visible = False
        end
      end
      object pnlPostings: TKeyClickPanel
        Left = 800
        Top = 1
        Width = 70
        Height = 39
        Cursor = crHandPoint
        Hint = 'Click to display patient postings.'
        Align = alRight
        BevelWidth = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        TabStop = True
        OnClick = pnlPostingsClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlPostingsMouseDown
        OnMouseUp = pnlPostingsMouseUp
        object lblPtPostings: TStaticText
          Left = 5
          Top = 4
          Width = 57
          Height = 13
          Cursor = crHandPoint
          Alignment = taCenter
          AutoSize = False
          Caption = 'No Postings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = pnlPostingsClick
          OnMouseDown = pnlPostingsMouseDown
          OnMouseUp = pnlPostingsMouseUp
        end
        object lblPtCWAD: TStaticText
          Left = 6
          Top = 19
          Width = 57
          Height = 13
          Cursor = crHandPoint
          Alignment = taCenter
          AutoSize = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = pnlPostingsClick
          OnMouseDown = pnlPostingsMouseDown
          OnMouseUp = pnlPostingsMouseUp
        end
      end
      object paVAA: TKeyClickPanel
        Left = 498
        Top = 1
        Width = 60
        Height = 39
        Cursor = crHandPoint
        Align = alRight
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 3
        Visible = False
        DesignSize = (
          60
          39)
        object laVAA2: TButton
          Left = 0
          Top = 19
          Width = 59
          Height = 20
          Cursor = crHandPoint
          Hint = 'Click to display patient insurance data'
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'laVAA2'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = laVAA2Click
        end
        object laMHV: TButton
          Left = 0
          Top = 0
          Width = 59
          Height = 18
          Cursor = crHandPoint
          Hint = 'Click to display MHV data'
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'laMHV'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = laMHVClick
        end
      end
      object pnlRemoteData: TKeyClickPanel
        Left = 692
        Top = 1
        Width = 73
        Height = 39
        Align = alRight
        BevelWidth = 2
        Caption = 'Remote Data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnFace
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        TabStop = True
        OnClick = pnlCIRNClick
        OnEnter = pnlPrimaryCareEnter
        OnExit = pnlPrimaryCareExit
        OnMouseDown = pnlCIRNMouseDown
        OnMouseUp = pnlCIRNMouseUp
        object pnlVistaWeb: TKeyClickPanel
          Left = 2
          Top = 2
          Width = 69
          Height = 18
          Cursor = crHandPoint
          Hint = 'Click to open VistaWeb'
          Align = alTop
          BevelWidth = 2
          Caption = 'VistaWeb'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = True
          OnClick = pnlVistaWebClick
          OnEnter = pnlPrimaryCareEnter
          OnExit = pnlPrimaryCareExit
          OnMouseDown = pnlVistaWebMouseDown
          OnMouseUp = pnlVistaWebMouseUp
          object lblVistaWeb: TLabel
            Left = 2
            Top = 2
            Width = 65
            Height = 14
            Cursor = crHandPoint
            Align = alClient
            Alignment = taCenter
            Caption = 'VistaWeb'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clInfoText
            Font.Height = -8
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            OnClick = pnlVistaWebClick
            ExplicitWidth = 46
            ExplicitHeight = 13
          end
        end
        object pnlCIRN: TKeyClickPanel
          Left = 2
          Top = 20
          Width = 69
          Height = 17
          Align = alClient
          BevelWidth = 2
          Caption = 'Remote Data'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TabStop = True
          OnClick = pnlCIRNClick
          OnEnter = pnlPrimaryCareEnter
          OnExit = pnlPrimaryCareExit
          OnMouseDown = pnlCIRNMouseDown
          OnMouseUp = pnlCIRNMouseUp
          object lblCIRN: TLabel
            Left = 2
            Top = 2
            Width = 65
            Height = 13
            Align = alClient
            Alignment = taCenter
            Caption = 'Remote Data'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnFace
            Font.Height = -8
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            OnClick = pnlCIRNClick
            ExplicitWidth = 63
          end
          object lblLoadSequelPat: TLabel
            Left = 2
            Top = 2
            Width = 65
            Height = 13
            Hint = 'Load patient who is selected in SequelMed'
            Align = alClient
            Alignment = taCenter
            Caption = 'Sequel Pat'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -8
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            OnClick = lblLoadSequelPatClick
            ExplicitWidth = 52
          end
        end
      end
      object pnlCVnFlag: TPanel
        Left = 558
        Top = 1
        Width = 91
        Height = 39
        Align = alRight
        TabOrder = 4
        object btnCombatVet: TButton
          Left = 1
          Top = 1
          Width = 89
          Height = 37
          Cursor = crHandPoint
          Hint = 'Click to display combat veteran eligibility details.'
          Align = alClient
          Caption = 'CV JAN 30, 2008'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnCombatVetClick
        end
        object pnlFlag: TKeyClickPanel
          Left = 1
          Top = 1
          Width = 89
          Height = 37
          Cursor = crHandPoint
          Hint = 'Click to display patient record flags.'
          Align = alClient
          BevelWidth = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = True
          OnClick = pnlFlagClick
          OnEnter = pnlFlagEnter
          OnExit = pnlFlagExit
          OnMouseDown = pnlFlagMouseDown
          OnMouseUp = pnlFlagMouseUp
          object lblFlag: TLabel
            Left = 2
            Top = 22
            Width = 85
            Height = 13
            Cursor = crHandPoint
            Align = alBottom
            Alignment = taCenter
            Caption = 'Flag'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnFace
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            WordWrap = True
            OnClick = pnlFlagClick
            OnMouseDown = pnlFlagMouseDown
            OnMouseUp = pnlFlagMouseUp
            ExplicitWidth = 25
          end
        end
      end
      object pnlPatientImage: TPanel
        Left = 39
        Top = 1
        Width = 39
        Height = 39
        Cursor = crHandPoint
        Align = alLeft
        BevelWidth = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        object PatientImage: TImage
          Left = 2
          Top = 2
          Width = 35
          Height = 35
          Cursor = crHandPoint
          Hint = 'Patient Photo ID Thumbnail.  Click for more.'
          Align = alClient
          Center = True
          ParentShowHint = False
          Picture.Data = {
            07544269746D617036090000424D360900000000000036000000280000001800
            000018000000010020000000000000090000130B0000130B0000000000000000
            0000FEFEFEFFFEFEFEFFFDFDFDFFFCFCFCFFFAFAFAFFF5F5F5FFECECECFFE1E1
            E1FFD6D6D6FFCCCCCCFFC4C4C4FFC0C0C0FFC2C2C2FFC7C7C7FFD0D0D0FFDBDA
            DAFFE5E5E5FFF0F0F0FFF7F7F7FFFBFBFBFFFCFCFCFFFEFEFEFFFEFEFEFFFEFE
            FEFFFEFEFEFFFDFDFDFFFBFBFBFFDEDEDEFFAEAEADFF8C8B8BFF6F6E6EFF5756
            56FF444242FF343433FF2C2B2AFF292727FF2B2929FF302F2EFF3A3A39FF4C4B
            4BFF616060FF7B7B7AFF9C9B9BFFC3C3C2FFEEEEEEFFFCFCFCFFFDFDFDFFFEFE
            FEFFFFFFFFFFFFFFFFFF9E9E9DFF494848FF474746FF464544FF41403FFF3A39
            39FF333231FF2E2D2CFF2B2A2AFF2A2828FF292828FF2A2929FF2E2C2CFF3534
            34FF3D3C3BFF434241FF4A4949FF4E4E4CFF5A5959FFB8B8B8FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF7E7D7CFF4A4949FF545352FF525150FF4C4C4BFF4545
            43FF3C3B3BFF353434FF2F2E2EFF2D2C2CFF2D2B2BFF2E2E2EFF353434FF3D3C
            3CFF454444FF4C4B4BFF535352FF595958FF504F4FFF8C8B8AFFFFFFFFFFFFFF
            FFFFFEFEFEFFFFFFFFFFB1B1B0FF4B4949FF5B5B5AFF5B5A59FF585857FF5453
            52FF4C4C4BFF424141FF3B3A39FF383737FF383737FF3B3B3AFF434242FF4B4A
            4AFF515050FF555554FF5A5958FF5D5C5BFF4F4E4EFFB2B1B1FFFFFFFFFFFEFE
            FEFFFFFFFFFFFFFFFFFFF9F9F9FF484746FF5C5A5AFF595858FF555453FF504E
            4EFF464544FF3B3A39FF343332FF323030FF313030FF353333FF3D3C3BFF4745
            45FF4E4C4BFF535150FF585757FF5D5C5BFF474645FFF6F6F6FFFFFFFFFFFFFF
            FFFFFFFFFFFFFEFEFEFFFFFFFFFFB1B0B0FF5F5E5DFF666564FF615F5FFF5655
            54FF464544FF363534FF2C2B2BFF292727FF292827FF2D2D2CFF3A3838FF4948
            47FF565454FF5F5E5DFF636262FF5E5B5BFFAAA9A9FFFFFFFFFFFEFEFEFFFFFF
            FFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFFFFFFC0C0C0FF8A8989FF696767FF6664
            63FF545352FF3F3D3DFF312F2FFF2B2A2AFF2C2B2AFF333232FF434241FF5856
            55FF636262FF626161FF848382FFBFBEBEFFFFFFFFFFFEFEFEFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFD9D9D9FF8785
            84FF666464FF535252FF3E3C3CFF343232FF333232FF3E3C3CFF514F4FFF5E5C
            5CFF8C8B8AFFDBDBDBFFF6F6F6FFFFFFFFFFFFFFFFFFFEFEFEFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFFFFFFFFFF
            FFFFC5C4C4FF706E6EFF565454FF3D3B3AFF393837FF444442FF7E7D7CFFDFDE
            DEFFFFFFFFFFFFFFFFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFF
            FFFFFFFFFFFF8C8C8AFF585757FF383635FF373636FF403F3EFFE9E9E9FFFFFF
            FFFFFEFEFEFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFE
            FEFFFFFFFFFF7C7B7AFF4A4847FF464443FF424140FF3D3C3BFFE8E8E8FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF3E3D3CFF393736FF363534FF373534FF32302FFFC8C8C7FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFF
            FFFFCCCCCBFF2E2C2BFF373534FF494847FF373635FF302E2DFF8F8F8FFFFFFF
            FFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF807F7EFF393837FF383635FFC1C0C0FF3A3837FF3D3A3AFF504F4DFFF5F5
            F5FFFFFFFFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA2A2
            A1FF3C3B3AFF474544FF484645FF91908FFF4A4948FF4A4847FF41403FFF5554
            53FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFF7D7D
            7CFF454443FF514F4EFF53504FFFBFBFBEFF908F8FFF52504FFF4C4A4AFF4543
            43FFDCDCDCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA5A4
            A4FF4F4D4CFF5B5A58FF646260FF6D6B6AFFB6B5B5FF898887FF525050FF6565
            64FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEAE
            ADFF565554FF666463FF7F7D7DFF817F7EFFB2B2B2FF9A9998FF585756FF5C5B
            5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB0AF
            AFFF5B5A59FF6E6D6CFFA1A09FFFB9B8B8FFB2B1B0FF737271FF5D5C5BFF5B59
            59FFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCACA
            CAFF626260FF757473FF868584FF8D8C8BFF898887FF787776FF5D5C5BFF7C7B
            7AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF888786FF797878FF908F8EFF999897FF939392FF7B7B7AFF636261FFECEC
            EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFF
            FFFFFFFFFFFFBFBFBFFFA8A7A6FF9F9F9FFF9D9C9CFFA6A5A4FFE8E8E8FFFFFF
            FFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFE
            FEFFFFFFFFFFFFFFFFFFF8F8F8FFF5F5F5FFF5F5F5FFFBFBFBFFFFFFFFFFFEFE
            FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF}
          ShowHint = True
          OnClick = PatientImageClick
          OnMouseEnter = PatientImageMouseEnter
          OnMouseLeave = PatientImageMouseLeave
          ExplicitLeft = 4
          ExplicitTop = 6
        end
      end
      object pnlTimer: TPanel
        Left = 649
        Top = 1
        Width = 43
        Height = 39
        Align = alRight
        BevelEdges = [beLeft, beTop, beRight]
        BevelInner = bvRaised
        BevelKind = bkSoft
        Caption = '00:00'
        PopupMenu = popTimerMenu
        TabOrder = 10
        VerticalAlignment = taAlignTop
        OnClick = btnTimerClick
        OnMouseDown = pnlTimerMouseDown
        object btnTimerReset: TButton
          Left = 2
          Top = 21
          Width = 35
          Height = 14
          Align = alBottom
          Caption = 'Reset'
          TabOrder = 0
          OnClick = btnTimerResetClick
        end
      end
      object pnlSchedule: TKeyClickPanel
        Left = 434
        Top = 1
        Width = 64
        Height = 39
        Cursor = crHandPoint
        Align = alClient
        Alignment = taRightJustify
        BevelEdges = [beLeft]
        BevelWidth = 2
        Caption = 'Schedule'
        Font.Charset = ARABIC_CHARSET
        Font.Color = clBtnFace
        Font.Height = -13
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        TabStop = True
        OnClick = pnlScheduleClick
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 48
    Data = (
      (
        'Component = frmFrame'
        'Status = stsDefault')
      (
        'Component = pnlNoPatientSelected'
        'Status = stsDefault')
      (
        'Component = pnlPatientSelected'
        'Status = stsDefault')
      (
        'Component = stsArea'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = pnlMainL'
        'Status = stsDefault')
      (
        'Component = pnlPageL'
        'Status = stsDefault')
      (
        'Component = lstCIRNLocations'
        'Status = stsDefault')
      (
        'Component = tabPageL'
        'Status = stsDefault')
      (
        'Component = pnlMainR'
        'Status = stsDefault')
      (
        'Component = pnlPageR'
        'Status = stsDefault')
      (
        'Component = tabPageR'
        'Status = stsDefault')
      (
        'Component = btnSplitterHandle'
        'Status = stsDefault')
      (
        'Component = pnlToolbar'
        'Status = stsDefault')
      (
        'Component = pnlCCOW'
        'Status = stsDefault')
      (
        'Component = pnlPatient'
        'Status = stsDefault')
      (
        'Component = lblPtName'
        'Status = stsDefault')
      (
        'Component = lblPtSSN'
        'Status = stsDefault')
      (
        'Component = lblPtAge'
        'Status = stsDefault')
      (
        'Component = pnlVisit'
        'Status = stsDefault')
      (
        'Component = lblPtLocation'
        'Status = stsDefault')
      (
        'Component = lblPtProvider'
        'Status = stsDefault')
      (
        'Component = pnlPrimaryCare'
        'Status = stsDefault')
      (
        'Component = lblPtCare'
        'Status = stsDefault')
      (
        'Component = lblPtAttending'
        'Status = stsDefault')
      (
        'Component = lblPtMHTC'
        'Status = stsDefault')
      (
        'Component = pnlReminders'
        'Status = stsDefault')
      (
        'Component = anmtRemSearch'
        'Status = stsDefault')
      (
        'Component = pnlPostings'
        'Status = stsDefault')
      (
        'Component = lblPtPostings'
        'Status = stsDefault')
      (
        'Component = lblPtCWAD'
        'Status = stsDefault')
      (
        'Component = paVAA'
        'Status = stsDefault')
      (
        'Component = laVAA2'
        'Status = stsDefault')
      (
        'Component = laMHV'
        'Status = stsDefault')
      (
        'Component = pnlRemoteData'
        'Status = stsDefault')
      (
        'Component = pnlVistaWeb'
        'Status = stsDefault')
      (
        'Component = pnlCIRN'
        'Status = stsDefault')
      (
        'Component = pnlCVnFlag'
        'Status = stsDefault')
      (
        'Component = btnCombatVet'
        'Status = stsDefault')
      (
        'Component = pnlFlag'
        'Status = stsDefault')
      (
        'Component = pnlPatientImage'
        'Status = stsDefault')
      (
        'Component = pnlTimer'
        'Status = stsDefault')
      (
        'Component = btnTimerReset'
        'Status = stsDefault')
      (
        'Component = pnlSchedule'
        'Status = stsDefault'))
  end
  object mnuFrame: TMainMenu
    OnChange = mnuFrameChange
    Left = 692
    Top = 56
    object mnuFile: TMenuItem
      Caption = '&File'
      GroupIndex = 1
      object mnuFileOpen: TMenuItem
        Caption = 'Select &New Patient...'
        OnClick = mnuFileOpenClick
      end
      object mnuClosePatient: TMenuItem
        Caption = '&Close Patient'
        OnClick = mnuClosePatientClick
      end
      object mnuFileRefresh: TMenuItem
        Caption = 'Refresh Patient &Information'
        OnClick = mnuFileRefreshClick
      end
      object mnuEditDemographics: TMenuItem
        Caption = 'Edit Patient &Demographics'
        OnClick = mnuEditDemographicsClick
      end
      object mnuFileResumeContext: TMenuItem
        Caption = 'Rejoin patient link'
        object mnuFileResumeContextSet: TMenuItem
          Caption = 'Set new context'
          OnClick = mnuFileResumeContextSetClick
        end
        object Useexistingcontext1: TMenuItem
          Caption = 'Use existing context'
          OnClick = mnuFileResumeContextGetClick
        end
      end
      object mnuFileBreakContext: TMenuItem
        Caption = 'Break patient link'
        OnClick = mnuFileBreakContextClick
      end
      object mnuFileEncounter: TMenuItem
        Caption = '&Update Provider / Location...'
        OnClick = mnuFileEncounterClick
      end
      object mnuFileReview: TMenuItem
        Caption = '&Review/Sign Changes...'
        OnClick = mnuFileReviewClick
      end
      object Z7: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuFileNext: TMenuItem
        Caption = 'Next Noti&fication'
        OnClick = mnuFileNextClick
      end
      object mnuFileNotifRemove: TMenuItem
        Caption = 'Remo&ve Current Notification'
        OnClick = mnuFileNotifRemoveClick
      end
      object Z1: TMenuItem
        Caption = '-'
      end
      object mnuFilePrintSetup: TMenuItem
        Caption = 'Print &Setup...'
        Enabled = False
        OnClick = mnuFilePrintSetupClick
      end
      object mnuFilePrintSelectedItems: TMenuItem
        Caption = 'Print Selected Items'
        Enabled = False
        OnClick = mnuFilePrintSelectedItemsClick
      end
      object mnuFilePrint: TMenuItem
        Caption = '&Print...'
        Enabled = False
        OnClick = mnuFilePrintClick
      end
      object mnuExportChart: TMenuItem
        Caption = 'Export Chart'
        OnClick = mnuExportChartClick
      end
      object mnuPrintLabels: TMenuItem
        Caption = 'Print Labels...'
        OnClick = mnuPrintLabelsClick
      end
      object mnuPrintAdmissionLabel: TMenuItem
        Caption = 'Print Admission Label...'
        OnClick = mnuPrintAdmissionLabelClick
      end
      object mnuFileExit: TMenuItem
        Caption = 'E&xit'
        OnClick = mnuFileExitClick
      end
    end
    object mnuEdit: TMenuItem
      Caption = '&Edit'
      GroupIndex = 2
      OnClick = mnuEditClick
      object mnuEditUndo: TMenuItem
        Caption = '&Undo'
        ShortCut = 16474
        OnClick = mnuEditUndoClick
      end
      object mnuEditRedo: TMenuItem
        Caption = 'Re&do'
        ShortCut = 16473
        OnClick = mnuEditRedoClick
      end
      object Z3: TMenuItem
        Caption = '-'
      end
      object mnuEditCut: TMenuItem
        Caption = 'Cu&t'
        ShortCut = 16472
        OnClick = mnuEditCutClick
      end
      object mnuEditCopy: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = mnuEditCopyClick
      end
      object mnuEditPaste: TMenuItem
        Caption = '&Paste'
        ShortCut = 16470
        OnClick = mnuEditPasteClick
      end
      object Z4: TMenuItem
        Caption = '-'
      end
      object mnuEditPref: TMenuItem
        Caption = 'P&references'
        object Prefs1: TMenuItem
          Caption = '&Fonts'
          object mnu8pt: TMenuItem
            Tag = 8
            Caption = '8 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu10pt1: TMenuItem
            Tag = 10
            Caption = '10 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu12pt1: TMenuItem
            Tag = 12
            Caption = '12 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu14pt1: TMenuItem
            Tag = 14
            Caption = '14 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
          object mnu18pt1: TMenuItem
            Tag = 18
            Caption = '18 pt'
            RadioItem = True
            OnClick = mnuFontSizeClick
          end
        end
      end
    end
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
          OnClick = ViewInfo
        end
        object mnuViewPostings: TMenuItem
          Tag = 9
          Caption = '&Postings...'
          OnClick = ViewInfo
        end
      end
    end
    object mnuTools: TMenuItem
      Caption = '&Tools'
      GroupIndex = 8
      object mnuBillableItems: TMenuItem
        Caption = '&Billable Items'
        OnClick = mnuBillableItemsClick
      end
      object N2: TMenuItem
        Caption = '-'
        Visible = False
      end
      object eprescribing1: TMenuItem
        Caption = 'E-Prescribing...'
        Enabled = False
        ShortCut = 16453
        Visible = False
        OnClick = eprescribing1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuLabText: TMenuItem
        Caption = '&Send text to lab...'
        OnClick = mnuLabTextClick
      end
      object mnuADT: TMenuItem
        Caption = '&ADT'
        OnClick = mnuOpenADTClick
      end
      object mnuAnticoagulationTool: TMenuItem
        Caption = 'Anticoagulation Tool'
        OnClick = mnuAnticoagulationToolClick
      end
      object Z8: TMenuItem
        Caption = '-'
      end
      object mnuChangeES: TMenuItem
        Caption = '&Change  Electronic Signature'
        OnClick = mnuChangeESClick
      end
      object mnuTeams: TMenuItem
        Caption = 'Edit List/Teams'
        OnClick = mnuTeamsClick
      end
      object mnuToolsGraphing: TMenuItem
        Caption = '&Graphing...'
        ShortCut = 16455
        OnClick = mnuToolsGraphingClick
      end
      object LabInfo1: TMenuItem
        Caption = '&Lab Test Information...'
        OnClick = LabInfo1Click
      end
      object mnuToolsOptions: TMenuItem
        Caption = '&Options...'
        OnClick = mnuToolsOptionsClick
      end
      object DigitalSigningSetup1: TMenuItem
        Caption = 'Digital Signing Setup...'
        OnClick = DigitalSigningSetup1Click
      end
      object mnuTMGTemp: TMenuItem
        Caption = 'Test HTML'
        OnClick = mnuTMGTempClick
      end
      object mnuUploadImages: TMenuItem
        Caption = 'Upload Images'
        Visible = False
        OnClick = mnuUploadImagesClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = '&Help'
      GroupIndex = 9
      object mnuHelpContents: TMenuItem
        Caption = '&Contents'
        Hint = 'WinHlp32 cprs.hlp'
        OnClick = ToolClick
      end
      object mnuHelpTutor: TMenuItem
        Caption = '&Brief Tutorial'
        Enabled = False
        Visible = False
      end
      object Z5: TMenuItem
        Caption = '-'
      end
      object mnuHelpBroker: TMenuItem
        Caption = 'Last Broker Call'
        OnClick = mnuHelpBrokerClick
      end
      object mnuHelpLists: TMenuItem
        Caption = 'Show ListBox Data'
        OnClick = mnuHelpListsClick
      end
      object mnuHelpSymbols: TMenuItem
        Caption = 'Symbol Table'
        OnClick = mnuHelpSymbolsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object ViewAuditTrail1: TMenuItem
        Caption = 'View &Audit Trail'
        OnClick = ViewAuditTrail1Click
      end
      object Z6: TMenuItem
        Caption = '-'
      end
      object mnuHelpAbout: TMenuItem
        Caption = '&About CPRS'
        OnClick = mnuHelpAboutClick
      end
    end
  end
  object popCIRN: TPopupMenu
    Left = 739
    Top = 52
    object popCIRNSelectAll: TMenuItem
      Caption = 'Select All'
      OnClick = popCIRNSelectAllClick
    end
    object popCIRNSelectNone: TMenuItem
      Caption = 'Select None'
      OnClick = popCIRNSelectNoneClick
    end
    object popCIRNClose: TMenuItem
      Caption = 'Close List'
      OnClick = popCIRNCloseClick
    end
  end
  object OROpenDlg: TOpenDialog
    Filter = 'Exe file (*.exe)|*.exe'
    Left = 780
    Top = 49
  end
  object popAlerts: TPopupMenu
    AutoPopup = False
    Left = 736
    Top = 120
    object mnuAlertContinue: TMenuItem
      Caption = 'Continue'
      ShortCut = 16451
      OnClick = mnuFileNextClick
    end
    object mnuAlertForward: TMenuItem
      Caption = 'Forward'
      ShortCut = 16454
      OnClick = mnuAlertForwardClick
    end
    object mnuAlertRenew: TMenuItem
      Caption = 'Renew'
      ShortCut = 16466
      OnClick = mnuAlertRenewClick
    end
  end
  object AppEvents: TApplicationEvents
    OnActivate = AppEventsActivate
    OnShortCut = AppEventsShortCut
    Left = 784
    Top = 88
  end
  object compAccessTabPage: TVA508ComponentAccessibility
    Component = tabPageL
    OnCaptionQuery = compAccessTabPageCaptionQuery
    Left = 56
    Top = 48
  end
  object timerStopwatch: TTimer
    Enabled = False
    OnTimer = timerStopwatchTimer
    Left = 824
    Top = 56
  end
  object popTimerMenu: TPopupMenu
    Left = 744
    Top = 88
    object mnuStartCounter: TMenuItem
      Caption = '&Start'
    end
    object mnuPauseCounter: TMenuItem
      Caption = '&Pause'
    end
    object mnuResetCounter: TMenuItem
      Caption = '&Reset'
    end
    object mnuStartOnKP: TMenuItem
      Caption = 'Start on &Keypress'
    end
    object mnuInsertTime: TMenuItem
      Caption = '&Insert Time'
      OnClick = mnuInsertTimeClick
    end
  end
  object timSchedule: TTimer
    Enabled = False
    OnTimer = timScheduleTimer
    Left = 824
    Top = 136
  end
  object timCheckSequel: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = timCheckSequelTimer
    Left = 824
    Top = 96
  end
  object ImageListSplitterHandle: TImageList
    Height = 24
    Width = 24
    Left = 536
    Top = 64
    Bitmap = {
      494C010104000900040018001800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000600000004800000001001800000000000051
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000D7E8EBD8E9EB000000D6E5
      E8D8E9EB000000D3BFC1D17778D23833D5241CD81B13D91D13D5261DD43D36D2
      7B7BD4C0C3D8E9EB000000D6E5E8D8E9EB000000D7E8EBD8E9EB000000D7E8EB
      D8E9EB000000D6E5E8D8E9EB000000D3BFC1D17778D23833D5241CD81B13D91D
      13D5261DD43D36D27B7BD4C0C3D8E9EB000000D6E5E8D8E9EB000000D7E8EBD8
      E9EB000000D7E8EBD8E9EB000000D6E5E8D8E9EB000000D3BFC1D17778D23833
      D5241CD81B13D91D13D5261DD43D36D27B7BD4C0C3D8E9EB000000D6E5E8D8E9
      EB000000D7E8EBD8E9EB000000D7E8EBD8E9EB000000D6E5E8D8E9EB000000D3
      BFC1D17778D23833D5241CD81B13D91D13D5261DD43D36D27B7BD4C0C3D8E9EB
      000000D6E5E8D8E9EB000000D7E8EBD8E9EB000000D7E8EBD8E9EB000000D7E8
      EBD4CACBCF4544D51710E03A1FE96A37EF8A47F09B50F19E52EF8E4BEC723DE4
      4527D92217D34F4CD5CBCDD7E8EBD8E9EB000000D7E8EBD8E9EB000000D7E8EB
      D8E9EB000000D7E8EBD4CACBCF4544D51710E03A1FE96A37EF8A47F09B50F19E
      52EF8E4BEC723DE44527D92217D34F4CD5CBCDD7E8EBD8E9EB000000D7E8EBD8
      E9EB000000D7E8EBD8E9EB000000D7E8EBD4CACBCF4544D51710E03A1FE96A37
      EF8A47F09B50F19E52EF8E4BEC723DE44527D92217D34F4CD5CBCDD7E8EBD8E9
      EB000000D7E8EBD8E9EB000000D7E8EBD8E9EB000000D7E8EBD4CACBCF4544D5
      1710E03A1FE96A37EF8A47F09B50F19E52EF8E4BEC723DE44527D92217D34F4C
      D5CBCDD7E8EBD8E9EB000000D7E8EBD8E9EB000000D7E8EB000000000000D08C
      8FD01511E23B20ED7F41F4AE59F6C867F8D470F9DD75F8DA74F8D472F6CB6CF5
      B361EE8D4CE6502ED6231BD29193000000000000D7E8EB000000000000D7E8EB
      000000000000D08C8FD01511E23B20ED7F41F4AE59F6C867F8D470F9DD75F8DA
      74F8D472F6CB6CF5B361EE8D4CE6502ED6231BD29193000000000000D7E8EB00
      0000000000D7E8EB000000000000D08C8FD01511E23B20ED7F41F4AE59F6C867
      F8D470F9DD75F8DA74F8D472F6CB6CF5B361EE8D4CE6502ED6231BD291930000
      00000000D7E8EB000000000000D7E8EB000000000000D08C8FD01511E23B20ED
      7F41F4AE59F6C867F8D470F9DD75F8DA74F8D472F6CB6CF5B361EE8D4CE6502E
      D6231BD29193000000000000D7E8EB000000000000D7E8EBD8E9EBCE6D6FD613
      0CE6562DF29F51F4B660F6C269F7D074FADE7CFAE883FAE682FADC7EF9D178F7
      C570F4BA69F3A95DEB6F3EDE2618D27576000000D7E8EBD8E9EB000000D7E8EB
      D8E9EBCE6D6FD6130CE6562DF29F51F4B660F6C269F7D074FADE7CFAE883FAE6
      82FADC7EF9D178F7C570F4BA69F3A95DEB6F3EDE2618D27576000000D7E8EBD8
      E9EB000000D7E8EBD8E9EBCE6D6FD6130CE6562DF29F51F4B660F6C269F7D074
      FADE7CFAE883FAE682FADC7EF9D178F7C570F4BA69F3A95DEB6F3EDE2618D275
      76000000D7E8EBD8E9EB000000D7E8EBD8E9EBCE6D6FD6130CE6562DF29F51F4
      B660F6C269F7D074FADE7CFAE883FAE682FADC7EF9D178F7C570F4BA69F3A95D
      EB6F3EDE2618D27576000000D7E8EBD8E9EBD7E6E9D7E8EBD08C8ED6110BE657
      2EEF914CF1A85AF2B363F6C26FF9D27AFAE083FAE88BFCE98CF9DE86F9D580F8
      C677F5B86EF3AE65F19D59EA7240DC2417D29294D7E8EBD7E6E8D7E6E9D7E8EB
      D08C8ED6110BE6572EEF914CF1A85AF4B564F6C26FF9D27AFAE083FAE88BFCE9
      8CF9DE86F9D580F8C677F4B86DF3AE65F19D59EA7240DC2417D29294D7E8EBD7
      E6E8D7E6E9D7E8EBD08C8ED6110BE6572EE48B48A57440A97E48E8B769F9D27A
      FAE083CEBC72B4A366B49F60F1CE7CF8C677F5B86EF3AE65F19D59EA7240DC24
      17D29294D7E8EBD7E6E8D7E6E9D7E8EBD08C8ED6110BE6572EEF914CF1A85AF4
      B564F6C26FF0CB76B19C5CB2A265D0BE73F9DE86F9D580ECBC71B18752AE7E4A
      E79755EA7240DC2417D29294D7E8EBD7E6E8000000D2C8CACF100DE24223ED82
      44F09550F2A75EF5B66AF5C375F8D180FADD8AFAE28EFBE38FF9DE8EF9D587F7
      C97EF6BD75F4B06BF29F5DF09254E85F37D6211AD3CACC000000000000D2C8CA
      CF100DE24223ED8244F09550F2A75EF5B66AF5C375F8D180FADD8AFAE28EFBE3
      8FF9DE8EF9D587F7C97EF6BD75F4B06BF29F5DF09254E85F37D6211AD3CACC00
      0000000000D2C8CAC9100D982E18C26B399C6132D3C0A3CEC1AA9B8358C3A465
      EFD384C5B185F0E7D8D6CCB7A69165C6A165F6BD75F4B06BF29F5DF09254E85F
      37D6211AD3CACC000000000000D2C8CACF100DE24223ED8244F09550F2A75EF5
      B66ABF995C9F8A5ED3C9B4F0E7D8C6B286EFD588C8AB6CA48C62D5C9B3D9C8AE
      A86E3ECA7C48A74729D1211AD3CACC000000000000CB3F40D92112EB713AEE87
      48EF9554F2A962F6B76FF6C37BF8CF84FADA8EF9DC92F9DD95FADB93F8D38DF7
      C983F7BF7BF4B270F2A163F09357EE844DE23D25D14F4DD8E9EB000000CB3F40
      D92112EB713AEE8748EF9554F2A962F6B76FF5C27AF8CF84FADA8EF9DC92F9DD
      95FADB93F8D38DF8CA84F7BF7BF4B270F2A163F09357EE844DE23D25D14F4DD8
      E9EB000000CB3F40E24736BFA48C6C5642513822D1C9BCFFFFF6FEF6E8CBBEA3
      8F7D53A0937CF7F3EAFFFFFAFBF6EAC6BAA1A8895DC6915CF2A163F09357EE84
      4DE23D25D14F4DD8E9EB000000CB3F40D92112EB713AEE8748EF9554BB844D9C
      7D52BEB197FBF5E7FFFFFAF7F2E9A1957F958258D0C5ABFEF7EAFFFFF7D8D2C7
      61452B7D6751C8B29BE9654ED14F4DD8E9EBD2BEC1CF0907E24324EC7740ED85
      4AF09457F4A866F5B672F6C37CF9CE89FAD691FADB97F8D895DFC082F3CE8DF8
      CB8AF7BF7FF5B475F3A367F19259EE8751E85F38D91B14D4C1C3D2BEC1CF0907
      E24324EC7740ED854AF09457F4A866F5B672F6C37CF1C884DCBB7DF7D794FBDC
      98FAD996FAD492F8CB8AF7BF7FF5B475F3A367F19259EE8751E85F38D91B14D4
      C1C3D2BEC1CF0C0AF39D7EFFFCE8F6F0DEA8A090827D70A29C90E7E2D8FFFFFB
      F4EEE0B6AFA0A8A296CFCAC0F9F6EDFFFFFCF6EFDFBDAC8FA17246D58150EE87
      51E85F38D91B14D4C1C3D2BEC1CF0907E24324EC7740CC7441916037B29D7FF3
      EAD7FFFFFBF7F4EACAC4B9A5A094B7B1A3F5F0E4FFFFFCEBE7DFB0AA9E928D80
      B6AFA0F8F3E3FFFCECF5B192D92018D4C1C3CF7274D6140CE6572EEC7540EE81
      4BF19458F2A567F5B473F6C07EF8CB8AFAD493FAD898EBCC94D7CEBFCFC0A7CC
      A16DF8BF83F5B276F3A369F0925CEF8451EA6D42DF2E1DD37B7CCF7274D6140C
      E6572EEC7540EE814BF19458F2A567F5B473C19460C6B59BD1C7B8E9C991FADA
      9CFAD99BF9D495F8CA8CF8BF83F5B276F3A369F0925CEF8451EA6D42DF2E1DD3
      7B7CCF7274DC2C20F8CFB3FDF4DFFEF8E6FFFFF5ECE5D6B3AD9F948D80C1BBB0
      F5F1E9FEFEF8EBE7DDBCB6ABAFA99CD9D4CBFDF9F1FFFFF7E7DDCAAC8B6B9957
      32DD673EDF2E1DD37B7CCF7274D6140CD6512B8846249C7A58E1D4BEFFFFF6FC
      F7ECD0CABFA39D90B4AFA2E9E5DBFEFEF9F7F4EDCBC6BBA39C8FC1BCAFEFEADD
      FFFFF7FEF9EBFEF6E4F9D8BFE54937D37B7CCD2A2ADB2313E55B31EA6F3FED7F
      4AE88B55E79A62ECA96EF0B679F3C386F6CD91FAD79CDAB47EECE7DEFFFFF9E3
      DFD5C0A587CC915FF29F68F1905DED8050EA6F43E33F27D53B38CD2A2ADB2313
      E55B31EA6F3FED7F4AF09058BE8050AF9275D8D4C8FFFFF6E5E0D5D6B07AFBD9
      A0F8D59BF6D095F4C58BF1B980EDAB72EB9B66F1905DED8050EA6F43E33F27D5
      3B38CD2A2AE85C46FDE7CDFFF3E0FEF4E3FFF6E6FEFDEEFFFEF1EDE5DABBB3A5
      AEA79BDED8CFFEFDF7FFFDF7E8E2D9B2AA9DB1A99DE4DDD4FFFFF4FFFBECDBC9
      B2966447B1331ED53B38CD2A2AA21B0E835034D2BDA2FFFAE6FFFFF1DCD3C99F
      988BA1988BDFD8CDFFFCF4FEFDF6E1DBD3BAB3A7C9C2B4F2EDE4FFFEF5FEFDF2
      FFF8EBFEF6E9FFF5E6FEEAD5EB795FD53B38CC100EDD2B18E75830EA693DA864
      45B6947FCCAF99D0B49DD3BA9FD7C0A4DEC8AEE2CDB1DFCEB7F7F3ECFFFFFAFF
      FEF8FCF8EFD3C9BBB48566CE794EED7D4FE96A42E5462BD5211DCC100EDD2B18
      E75830EA693DC3653DA27253C5BAA9FBF4E8FFFEF4FFFEF6F0EBE1D8C7B0E7D3
      B8E9D7BEE4D0B7E1CBB3DDC6AFD9C0ADC5A794B87857ED7D4FE96A42E5462BD5
      211DCC110FED7D63FDEBD6FEF3DEFEF4E2FEF5E4FFF6E7FFF8ECFFFCF2FFFCF3
      ECE5DDC8BFB3EBE6DFFFFEFBFFFEF9FDF8F1D5CCC0B1A89BEAE1D6FFF9EAFFFB
      ECFEEED9D28367CF211DC6100ECA6A51FDE9D1FFFBE8FFF7E5E2D8CB9E9487C6
      BBAFFBF4E9FFFEF6FFFEF6E7E1D8CFC6BAF5EFE8FFFDF9FFFDF6FFFAF1FFF9EE
      FEF8ECFEF7E8FFF6E4FEEFDDF0957AD5221ECF0605DC2C18E5532EE16138A37B
      66F5ECDFFFFCEFFFF8EDFFF8EDFEF9F0FFFBF5FEFCF6FFFEFBFFFFFCFEFCF7FD
      FAF3FEFAF1FFFFF6F7EEE1B39A8AC96742E8653FE4462BD61411CF0605DC2C18
      E5532EBD5431A28675F5EADAFFFFF3FEF6EAFCF7EBFEF9F0FFFCF6FFFDF8FEFD
      FAFFFEFBFEFCF7FFFAF4FFFBF3FFFCF3F7F0E6B48E7BE6744AE8653FE4462BD6
      1411CF0907EF8C71FDEDD6FFF2DCFEF3E1FDF3E1FEF5E6FEF6EAFEF6EAFEFBF1
      FFFFFBEBE4DEDDD4C9FFFEFBFEFCF6FEFCF6FFFCF5B7A89FD4CAC0FEF5E6FEF3
      E3FFF8E8F8C1AAD61C17CF0B09F4B198FFF7E4FEF0DCFEF2DEC9BDB1A5968CFF
      FAF0FEFBF2FEF9EFFEFBF4D4CABFF1EBE6FFFFFEFEFDF8FEFAF2FEFAF1FEF7EC
      FDF5E8FEF6E8FFF5E3FEF0DDF2A086D61714CD0505DA2716E44B2BE15A35A67B
      67F7EDE0FFFBEEFFF7ECFFF7ECFEF8EFFFFBF4FDFBF5FFFDFAFFFEFAFEFBF5FD
      F9F0FEFCF3FFF9EDE5DBCEB28872CD613FE85F3BE43F28D51310CD0505DA2716
      E44B2BC34F2EA0745EDDD1C0FFF8E8FEFBEDFCF5E9FEF8EEFFFCF5FFFCF7FEFD
      F8FFFEFAFEFBF6FFFAF3FFFAF2FFFBF2F8F1E6B7907BE56C45E85F3BE43F28D5
      1310CD0806ED866CFDEDD4FEEFDBFFF0DEFDF1E1FDF2E2FFF7EAFEFDF2F5EDE3
      D6CBBFC3B7AAF3EFE8FFFFFCFEFCF8EDE5DBBDB1A4BCB1A5F2EADCFEF9EAFFFA
      E9E1CAB1BB5F46CC120FC20504AC4830DABFA2FFF9E4FEF7E5EEE3D4AC9F92AA
      9E8FE4DACDFEFAF1FFFFF7EFEAE1CBC0B2E3DBD0F9F5EEFEFDF6FFFAF1FDF5E9
      FDF3E7FFF4E5FEF2E2FEF0DCF29B83D51613CD100FD91F12E24326E85633A559
      41B7907ECBA792CDAC96D1B099D5B69DDBBEA6DDBFA6DBC6B0F5F0E8FFFEF8FF
      FDF4EEE7DBC5A893B76947EA724BEB6642E65535E23623D51E1ACD100FD91F12
      E24326E85633E35F3BA75638B6957FE7DECEFFFBEFFFFEF4F1EAE0D8C1ACE1C4
      AAE4CAB2E0C4ADDEC1ACDABDA9D7B8A5C6A391B66C52EB6642E65535E23623D5
      1E1ACD100FEB6D58FDE8D0FDEED9FFF1DEFFF5E3FFFBEBF9EFE3CDC1B3ACA192
      C6BCB0F5F0E9FFFFF9F7F2EBCFC5B7B4A99AD2CABEFBF5EAFFFFF3F5E5CCB990
      71944125CB3120D51E1ACD100FBF1B10833018AA7E5DF3DEBFFFFFEFFAF1E3C4
      BAADA29787C0B6A7F3EDE3FFFFF8F7F2ECD1C8BCBBB1A2DAD0C4FBF4EBFFFCF1
      FFF8EAFFF4E5FEF2E1FEECD8EE846ED5201BCC2A2BD8140DDF3A21E44C2DE759
      36E2633FE27249E87F55ED9266F1A476F4B07FF8B889E6A87DF0EAE4FCF8F3D3
      C0AEC17F5DE07C55EE774FEC6A46E95E3CE64E31DE281BD33938CC2A2BD8140D
      DF3A21E44C2DE75936E96741D96D46B26F50CBB5A3FBF5EEECE5DFE4A67BF9BB
      8CF7B787F4AF7FF09E70ED8E62E88158E7734CEC6A46E95E3CE64E31DE281BD3
      3938CC2A2BE44537FADAC2FFF3DBFFFCE7FFF6E3C8BDAC988C7CB5AA9CE8E2D9
      FFFEF9FCF9F2DCD4C8C7BDAFD8D1C6F5F0E9FFFFF6FDF2E1CAAB8CA35E3CB74B
      30E64E31DE281BD33938CC2A2BD8140DDF3A21A83A23924B2DBF9C7BFDEEDAFF
      FFF2F3EDE3D0C7BDC0B6A7DAD1C5FDFAF3FFFFFAEDE8E0C0B5A8A89C8CD3C9BB
      FFF8E8FFFDECFFF5E2FBE1CCE85E4ED33938D07576D10906DB2D1AE34126E54C
      2FE75A38EE744CF48C61F59A6CF7A377F8AB7EF8B082F1AD84DDC2B4D7A98FEE
      9B71F5986BEE7D55EC6A47EA5D3EE75235E3412AD91B14D47F80D07576D10906
      DB2D1AE34126E54C2FE75A38EE744CF48C61E98E64D19D84D9BCAEF1AC82F9B2
      84F9B285F8AE80F7A67AF5986BEE7D55EC6A47EA5D3EE75235E3412AD91B14D4
      7F80D07576D71914F6BCA5FFF0DDCABAA777604D978A7DDED6CDFBF5EEFFFFFB
      F7F0E5D0C6B5D7CFC6F6F1ECFFFFFBFFFBF2E8D6C1B5764EBE5639EA5D3EE752
      35E3412AD91B14D47F80D07576D10906DB2D1AE34126E54C2FB1462CAE6D45E4
      D0B8FFFAF0FFFFFAF4EFEAD5CEC4D1C7B7F7F2E9FFFFFBFBF7F1E1DCD49F9487
      88725FD3C5B5FFF3E3F8C7B3DE3129D47F80D4C0C3CD0604D9180FDE3720E341
      28EA5B39F37A52F4845CF58F64F7996CF79D71F7A378F8A67AF7A175F8A176F7
      9A6EF79369F4855DEB6041E75135E4472EE02C1DD71917D6C4C6D4C0C3CD0604
      D9180FDE3720E34128EA5B39F37A52F4845CF58F64F7996CF69C70F7A378F8A6
      7AF8A377F8A176F79A6EF79369F4855DEB6041E75135E4472EE02C1DD71917D6
      C4C6D4C0C3CD0707D5615388685A67271A74331FF7F2EEFFFFFDFFFBF3E9D6C5
      B67A55D5BDACFFFFFDFFFFFCF3ECE1D5A888CF704DF0825BEB6041E75135E447
      2EE02C1DD71917D6C4C6D4C0C3CD0604D9180FDE3720E34128EA5B39EF7750C6
      6142CD9C7CF1E8DCFFFFFBFFFFFDD6BEAEBB805BEDDBCCFFFBF6FFFFFDF8F3EF
      7A3B25793523997A6CDB7768D71B1AD6C4C6000000CE4344D10906DD2617E03B
      23F1593AF46E49F47650F5815BF68A62F78F66F7926AF7956BF7946AF79167F7
      8C64F5835DF57E59F06345E5452DE13724D91F19D86363000000000000CE4344
      D10906DD2617E03B23F1593AF46E49F47650F5815BF68A62F78F66F7926AF795
      6BF7946AF79167F78C64F5835DF57E59F06345E5452DE13724D91F19D8636300
      0000000000CE4344AB0A078F1A10D83822BE4C30EDDCD0ECDED1C79076D26A4B
      F08961D79579EBDDD2DBB7A5CF7954EF855FF5835DF57E59F06345E5452DE137
      24D91F19D86363000000000000CE4344D10906DD2617E03B23F1593AF46E49F4
      7650ED7955CB714FD8B3A0EBDCD0D8987CF18E65D6724FCF9B82EFE3D9F1E3D8
      C1573BDD422B9B281ABA211AD86363000000000000D5CBCDCE0B0BD40F0AE12D
      1DF24F31F35A3BF26442F46F4BF67954F67D58F6815CF6845EF6835CF6815AF6
      7A57F6714FF56C4CF2593DDF3422DB1C14DB3838D7CED0D8E9EB000000D5CBCD
      CE0B0BD40F0AE12D1DF24F31F45B3CF46644F46F4BF67954F67D58F6815CF684
      5EF6835CF6815AF67A57F4704EF56B4AF2593DDF3422DB1C14DB3838D7CED0D8
      E9EB000000D5CBCDCE0B0BD40F0AE12D1DEB492FC7432DC84D33EE6948F67954
      F67D58F07A57E1704EEC7954F6815AF67A57F6714FF56C4CF2593DDF3422DB1C
      14DB3838D7CED0D8E9EB000000D5CBCDCE0B0BD40F0AE12D1DF24F31F45B3CF4
      6644F46F4BF67954EB7451DF6F4DF07C58F6835CF6815AF07453D0573DD05338
      EA5538DF3422DB1C14DB3838D7CED0D8E9EBD7E6E9D7E8EBD49394CF0403DA13
      0CF13924F34C31F25237F55E3EF76747F66C4BF7704FF77150F7704FF76D4BF6
      6949F65F44F65D40ED452DD91C14DE2C2ADBA5A6D7E8EBD7E6E8D7E6E9D7E8EB
      D49394CF0403DA130CF13924F54D32F45437F55F3FF76747F66C4BF7704FF771
      50F7704FF76D4BF66747F35D42F45C3FED452DD91C14DE2C2ADBA5A6D7E8EBD7
      E6E8D7E6E9D7E8EBD49394CF0403DA130CF13924F54D32F45437F55F3FF76747
      F66C4BF7704FF77150F7704FF76D4BF66949F65F44F65D40ED452DD91C14DE2C
      2ADBA5A6D7E8EBD7E6E8D7E6E9D7E8EBD49394CF0403DA130CF13924F54D32F4
      5437F55F3FF76747F66C4BF7704FF77150F7704FF76D4BF66949F65F44F65D40
      ED452DD91C14DE2C2ADBA5A6D7E8EBD7E6E8000000D7E8EB000000D27577CF06
      05E4120DF73523F6452EF64E33F6553AF7593BF75F40F75F40F75D40F75C40F7
      553AF85339F5432FDF1B14DD2B29DB9192000000D7E8EB000000000000D7E8EB
      000000D27577CF0605E4120DF73523F6452EF64E33F6553AF7593BF75F40F75F
      40F75D40F75C40F7553AF85339F5432FDF1B14DD2B29DB9192000000D7E8EB00
      0000000000D7E8EB000000D27577CF0605E4120DF73523F6452EF64E33F6553A
      F7593BF75F40F75F40F75D40F75C40F7553AF85339F5432FDF1B14DD2B29DB91
      92000000D7E8EB000000000000D7E8EB000000D27577CF0605E4120DF73523F6
      452EF64E33F6553AF7593BF75F40F75F40F75D40F75C40F7553AF85339F5432F
      DF1B14DD2B29DB9192000000D7E8EB000000000000D7E8EBD8E9EB000000D69A
      9CD31D1DE51714F41D15F83423F93E29F8422CF8452FF94831F8462FF94330F9
      3C2BF2251BE0211DDD3B3BDAA5A7D8E9EB000000D7E8EBD8E9EB000000D7E8EB
      D8E9EB000000D69A9CD31D1DE51714F41D15F83423F93E29F8422CF8452FF948
      31F8462FF94330F93C2BF2251BE0211DDD3B3BDAA5A7D8E9EB000000D7E8EBD8
      E9EB000000D7E8EBD8E9EB000000D69A9CD31D1DE51714F41D15F83423F93E29
      F8422CF8452FF94831F8462FF94330F93C2BF2251BE0211DDD3B3BDAA5A7D8E9
      EB000000D7E8EBD8E9EB000000D7E8EBD8E9EB000000D69A9CD31D1DE51714F4
      1D15F83423F93E29F8422CF8452FF94831F8462FF94330F93C2BF2251BE0211D
      DD3B3BDAA5A7D8E9EB000000D7E8EBD8E9EB000000D7E8EBD8E9EB000000D7E8
      EBD9D0D1DA6466DD2425E72323EE1713F31914F51F16F52117F21C15EC1B16E5
      2A27DB2828DD6F70D8D0D2D7E8EBD8E9EB000000D7E8EBD8E9EB000000D7E8EB
      D8E9EB000000D7E8EBD9D0D1DA6466DD2425E72323EE1713F31914F51F16F521
      17F21C15EC1B16E52A27DB2828DD6F70D8D0D2D7E8EBD8E9EB000000D7E8EBD8
      E9EB000000D7E8EBD8E9EB000000D7E8EBD9D0D1DA6466DD2425E72323EE1713
      F31914F51F16F52117F21C15EC1B16E52A27DB2828DD6F70D8D0D2D7E8EBD8E9
      EB000000D7E8EBD8E9EB000000D7E8EBD8E9EB000000D7E8EBD9D0D1DA6466DD
      2425E72323EE1713F31914F51F16F52117F21C15EC1B16E52A27DB2828DD6F70
      D8D0D2D7E8EBD8E9EB000000D7E8EBD8E9EB000000D7E8EB000000000000D6E5
      E8000000000000D9C7C9D98D8FDB5354DF3B3BDF2728DF2728DE3C3CDB5354DA
      9091D9C6C9000000000000D6E5E8000000000000D7E8EB000000000000D7E8EB
      000000000000D6E5E8000000000000D9C7C9D98D8FDB5354DF3B3BDF2728DF27
      28DE3C3CDB5354DA9091D9C6C9000000000000D6E5E8000000000000D7E8EB00
      0000000000D7E8EB000000000000D6E5E8000000000000D9C7C9D98D8FDB5354
      DF3B3BDF2728DF2728DE3C3CDB5354DA9091D9C6C9000000000000D6E5E80000
      00000000D7E8EB000000000000D7E8EB000000000000D6E5E8000000000000D9
      C7C9D98D8FDB5354DF3B3BDF2728DF2728DE3C3CDB5354DA9091D9C6C9000000
      000000D6E5E8000000000000D7E8EB000000424D3E000000000000003E000000
      2800000060000000480000000100010000000000600300000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000092002492002492002492002490000490
      0004900004900004B0000DB0000DB0000DB0000D800004800004800004800004
      0000000000000000000000008000018000018000018000018000008000008000
      0080000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000180
      0001800001800001800000800000800000800000000000000000000000000000
      A00005A00005A00005A000059000049000049000049000049000049000049000
      04900004B6006DB6006DB6006DB6006D00000000000000000000000000000000
      000000000000}
  end
  object timHideSplitterHandle: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = timHideSplitterHandleTimer
    Left = 824
    Top = 176
  end
end
