inherited frmFrame: TfrmFrame
  Left = 196
  Top = 119
  Caption = 'p'
  ClientHeight = 723
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
  ExplicitHeight = 781
  PixelsPerInch = 96
  TextHeight = 13
  object pnlNoPatientSelected: TPanel [0]
    Left = 0
    Top = 0
    Width = 872
    Height = 723
    Align = alClient
    Caption = 'No patient is currently selected'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Visible = False
  end
  object pnlPatientSelected: TPanel [1]
    Left = 0
    Top = 0
    Width = 872
    Height = 723
    Align = alClient
    TabOrder = 0
    object bvlPageTop: TBevel
      Left = 1
      Top = 41
      Width = 870
      Height = 1
      Align = alTop
      ExplicitWidth = 674
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
    end
    object pnlToolbar: TPanel
      Left = 1
      Top = 1
      Width = 870
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      Caption = 'object pnlRemoteData: TKeyClickPanel'
      TabOrder = 0
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
    object stsArea: TStatusBar
      Left = 1
      Top = 701
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
    object tabPage: TTabControl
      Left = 1
      Top = 679
      Width = 870
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
      OnChange = tabPageChange
      OnDrawTab = tabPageDrawTab
      OnMouseUp = tabPageMouseUp
    end
    object pnlPage: TPanel
      Left = 1
      Top = 42
      Width = 870
      Height = 637
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object sbtnFontSmaller: TSpeedButton
        Tag = -1
        Left = 21
        Top = 96
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
        Left = 41
        Top = 96
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
        Left = 58
        Top = 96
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
        Left = 422
        Top = 5
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
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 48
    Data = (
      (
        'Component = pnlNoPatientSelected'
        'Status = stsDefault')
      (
        'Component = pnlPatientSelected'
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
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = laMHV'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = stsArea'
        'Status = stsDefault')
      (
        'Component = tabPage'
        'Status = stsDefault')
      (
        'Component = pnlPage'
        'Status = stsDefault')
      (
        'Component = lstCIRNLocations'
        'Status = stsDefault')
      (
        'Component = frmFrame'
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
        'Component = lblPtMHTC'
        'Status = stsDefault')
      (
        'Component = pnlSchedule'
        'Status = stsDefault'))
  end
  object mnuFrame: TMainMenu
    OnChange = mnuFrameChange
    Left = 292
    Top = 112
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
    Left = 635
    Top = 60
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
    Left = 260
    Top = 257
  end
  object popAlerts: TPopupMenu
    AutoPopup = False
    Left = 320
    Top = 200
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
    Left = 336
    Top = 256
  end
  object compAccessTabPage: TVA508ComponentAccessibility
    Component = tabPage
    OnCaptionQuery = compAccessTabPageCaptionQuery
    Left = 56
    Top = 48
  end
  object timerStopwatch: TTimer
    Enabled = False
    OnTimer = timerStopwatchTimer
    Left = 440
    Top = 240
  end
  object popTimerMenu: TPopupMenu
    Left = 520
    Top = 224
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
    Left = 424
    Top = 312
  end
  object timCheckSequel: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = timCheckSequelTimer
    Left = 696
    Top = 192
  end
end
