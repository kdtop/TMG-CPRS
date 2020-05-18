object frmAnticoagulate: TfrmAnticoagulate
  Left = 136
  Top = 240
  BorderStyle = bsSingle
  Caption = 'Anticoagulation Flow Sheet'
  ClientHeight = 602
  ClientWidth = 734
  Color = clCream
  Constraints.MinHeight = 650
  Constraints.MinWidth = 740
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mnuMain
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 734
    Height = 207
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      734
      207)
    object lblIndication: TLabel
      Left = 244
      Top = 178
      Width = 86
      Height = 13
      Anchors = [akRight, akBottom]
      Caption = 'Primary Indication:'
    end
    object lblINRGoal: TLabel
      Left = 585
      Top = 183
      Width = 57
      Height = 13
      Anchors = [akRight, akBottom]
      Caption = 'INR Goal:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 465
      ExplicitTop = 163
    end
    object lblSiteName: TLabel
      Left = 9
      Top = 56
      Width = 59
      Height = 13
      Caption = 'Clinic Name:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblComplex: TLabel
      Left = 564
      Top = 41
      Width = 131
      Height = 20
      Anchors = [akTop, akRight]
      Caption = 'Complex Patient'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
      ExplicitLeft = 444
    end
    object lblPname: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 7
      Width = 66
      Height = 20
      Caption = 'pt name'
      Constraints.MaxHeight = 22
      Constraints.MaxWidth = 400
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMSG: TLabel
      Left = 10
      Top = 78
      Width = 379
      Height = 17
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Caption = 
        'Pt has not given permission to leave anticoag messages on answer' +
        'ing machine. '
      Constraints.MinHeight = 17
    end
    object lblSign: TLabel
      Left = 10
      Top = 138
      Width = 180
      Height = 17
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Caption = 'Pt does not have a signed agreement.'
      Constraints.MinHeight = 17
    end
    object lblTemp: TLabel
      Left = 271
      Top = 137
      Width = 116
      Height = 20
      Alignment = taCenter
      Caption = 'Incomplete Entry'
      Constraints.MinHeight = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object lblAutoPrimIndicCap: TLabel
      Left = 9
      Top = 156
      Width = 106
      Height = 13
      Caption = 'Primary Indication:'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAutoPrimIndic: TLabel
      Left = 120
      Top = 156
      Width = 245
      Height = 13
      Caption = 'Encounter for Therapeutic Drug Monitoring (V58.83)'
      Constraints.MaxWidth = 295
      Enabled = False
    end
    object lblPtInfo: TLabel
      Left = 9
      Top = 33
      Width = 38
      Height = 13
      Caption = 'lblPtInfo'
    end
    object cbxINRGoal: TComboBox
      Left = 645
      Top = 178
      Width = 73
      Height = 21
      Hint = 'Choose the INR range you'#39'd like the patient to achieve'
      AutoDropDown = True
      AutoCloseUp = True
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
      OnClick = cbxINRGoalClick
      OnExit = cbxINRGoalExit
      Items.Strings = (
        '1.5-2.5'
        '2.0-3.0'
        '2.5-3.5'
        'Other')
    end
    object gbxContactInfo: TGroupBox
      Left = 406
      Top = 73
      Width = 313
      Height = 102
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Official Contact Information'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object lblCSZ: TLabel
        Left = 7
        Top = 56
        Width = 37
        Height = 17
        Caption = 'lblCSZ  '
        Constraints.MinHeight = 17
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
      object lblHfone: TLabel
        Left = 7
        Top = 70
        Width = 65
        Height = 13
        Caption = 'Home Phone:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
      object lblSadr1: TLabel
        Left = 7
        Top = 13
        Width = 41
        Height = 17
        Caption = 'lblSadr1 '
        Constraints.MinHeight = 17
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
      object lblSadr2: TLabel
        Left = 7
        Top = 28
        Width = 44
        Height = 17
        Caption = 'lblSadr2  '
        Constraints.MinHeight = 17
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
      object lblSadr3: TLabel
        Left = 7
        Top = 42
        Width = 44
        Height = 17
        Caption = 'lblSadr3  '
        Constraints.MinHeight = 17
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
      object lblWfone: TLabel
        Left = 9
        Top = 83
        Width = 63
        Height = 13
        Caption = 'Work Phone:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlINR: TPanel
      Left = 9
      Top = 175
      Width = 225
      Height = 24
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      Color = clMoneyGreen
      ParentBackground = False
      TabOrder = 2
      DesignSize = (
        225
        24)
      object lblLastINR: TLabel
        Left = 6
        Top = 2
        Width = 77
        Height = 20
        Anchors = [akLeft, akBottom]
        Caption = 'Last INR:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblINRval: TLabel
        Left = 89
        Top = 2
        Width = 46
        Height = 20
        Anchors = [akLeft, akBottom]
        Caption = '2.999'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblINRdt: TLabel
        Left = 144
        Top = 2
        Width = 79
        Height = 20
        Hint = 'last INR date'
        Alignment = taRightJustify
        Anchors = [akLeft, akBottom]
        AutoSize = False
        Caption = '09/09/09'
        Constraints.MinWidth = 79
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object sbxPMsg: TScrollBox
      Left = 10
      Top = 94
      Width = 390
      Height = 40
      VertScrollBar.Smooth = True
      VertScrollBar.Style = ssHotTrack
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Constraints.MaxHeight = 49
      Constraints.MaxWidth = 480
      Constraints.MinHeight = 40
      Constraints.MinWidth = 390
      TabOrder = 3
      object lblPMsg: TStaticText
        Left = 0
        Top = 0
        Width = 390
        Height = 40
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Caption = 'OK to leave message with _______'
        Constraints.MaxHeight = 340
        Constraints.MaxWidth = 468
        Constraints.MinHeight = 34
        Constraints.MinWidth = 380
        TabOrder = 0
        Visible = False
      end
    end
    object cboIndication: TComboBox
      Left = 336
      Top = 178
      Width = 243
      Height = 21
      Hint = 'Choose the indication for treatment'
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnChange = cboIndicationChange
      OnExit = cboIndicationExit
    end
    object cboSite: TComboBox
      Left = 74
      Top = 52
      Width = 194
      Height = 21
      Hint = 'Choose the Clinic which is following the patient'
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnChange = cboSiteSelect
      OnExit = cboSiteExit
    end
    object pnlHighlightEditPref: TPanel
      Left = 512
      Top = 5
      Width = 210
      Height = 35
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 6
      DesignSize = (
        210
        35)
      object btnEditPatient: TBitBtn
        Left = 3
        Top = 3
        Width = 204
        Height = 30
        Hint = 'Click To Edit Patient Information'
        Anchors = [akTop, akRight]
        Caption = 'View / Edit Patient Information'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        WordWrap = True
        OnClick = btnEditPatientClick
        Glyph.Data = {
          F6060000424DF606000000000000360000002800000018000000180000000100
          180000000000C0060000130B0000130B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFCCB190CEB393CAB79EFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFE2AA70F0AE6CF9B775FCBF80FCC488FAC68CF6C38DEFC28E
          E4BC8FD6CCBED0CFC5FF00FFFF00FFFF00FFCCAC97D9B49DE2C7B6E6D8D1FF00
          FFFF00FFFF00FFFF00FFBE9C77F2BC80FFBC76FFBE7CFEC387FFC98FFFCD97FF
          D09DFFD3A1FFD5A4FFD5A3E8DED3D3BCA3D6BE9FC19E85D68546E3AA86FAEEE6
          F7EDE6ECD2C7F6EEEBFF00FFFF00FFFF00FFC59A6EFEC98CFFBE7CFFC183FFC8
          8FFFCD98FFD1A0FFD5A6FFD8ABFFD9ADFCDAB1EEE9E4CCBDADC6A48AD26E26DF
          7B2DE49B60FAF3EDFBF6F4F6E2D3FAEDE4F0DBCCFF00FFFF00FFC5A988FBC68A
          FFC283FFC68AFFCD97FFD2A0FFD6A9FFDAAFFFDDB5FEDEB7F9E3C7F4F4F2B8B5
          B3CCA78DDE731EDC721EE3904DFAF1EAFAF4F0F2D0B5F4D5BAF4CFAFD6B29AFF
          00FFFF00FFF6C084FFC689FFC88FFFCF9BFFD4A5FFD9AEFFDDB5FFE0BDFEE2BF
          F8EDDDF9F9F8C4C0BEE4CAB9E89F65DA670FE48E41F7E6DAF9F3EDEDB991EEBB
          91EDB689E0A57AFF00FFFF00FFEAB880FFCA8FFFCA92FFD19EFFD6A9FFDCB3FE
          E0BAFEE4C2FDE9CDF9F6F0FDFEFEC7C2BFEBD0BFF5D5B9E49252D98346FAF0EC
          F9EEE8E5995FE69D62E6995BDF8F51FF00FFFF00FFD9B489FDCA8FFECC94FFD2
          A0FFD7ABFFDDB5FEE2BDFFE6C6FEF1DFFDFCFBFFFFFFB9B5B3E8CCBBF6D8BEF1
          C8A6E7A97CE4A477E1A681DD7A2BDF7D2FDF7A29D7782FFF00FFFF00FFFF00FF
          EDBE88FDCC95FED1A0FFD7AAFEDDB4FDE1BCEAD6BBB4BDC68DA1B9D1D9E2A7A2
          9ADAC5B7F5D4B9F0C7A4EDB88EEAB68DE49C66E18942DE7C2DDE711AC8814EFF
          00FFFF00FFFF00FFFF00FFEEC28DFED19CFFD8A9FFDBB0E3C9A77A8EA5426D9D
          3B6899547BAAD0BCA1D3C0B1EBCAB1F0C4A1EBB48AFAF3EEF9EFEBE39453DF7D
          2DD77426FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE0C098E6BE91C6A78377
          85963A66933A6084385F8544698FCEBCA1FF00FFD8CAC1EABF9FEBB081E9B48C
          E7AA7BE3893FD87D37FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFBEBAAD868179456B94385C7D355978375B7C375B7A506F86FF00FFFF00FFFF
          00FFE6C5B0E1AA84D89A6EC89673FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FF4266853659794165854165833C617F3F63
          81577994FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4E6F894065844D7191
          4A6F9051769853789B51769AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF49
          6781567A9C567B9E5E83A86488B0668CB26288B080A1BEFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FF62717B476A8A5F84A86389AF6D93BB7399C2769CC6749AC4799FC4FF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF42586E54799C658AB07197BF7BA1CC81A7D384AB
          D886ACD78AAED5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF38434E4355676485A67AA1CD
          83AAD78EB3DF9EC0E6A9C9E8AAC8E6FF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF31303029
          24206786A780A8D593B7E0A9C8E9B3CFEBB1CEEBAECBE9FF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FF3A393932302E5F77928AB1DDA9C8E8B1CEECB4D0EAB4D0EBB1CEEAFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF4544443F404056595A758BA4819EC083A0C386A1
          BE86A1C2AEC8DDFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6364645A5A5A626161646262
          6A6869706F6F7574737D7D7DFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6E
          6E6E6565656C6C6C7978798786879EA0A0FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF707070858686FF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      end
    end
  end
  object pcMain: TPageControl
    Left = 0
    Top = 208
    Width = 734
    Height = 394
    ActivePage = tsExit
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    HotTrack = True
    MultiLine = True
    ParentFont = False
    TabOrder = 1
    TabPosition = tpBottom
    TabWidth = 100
    OnChange = pcMainChange
    object tsOverview: TTabSheet
      HelpType = htKeyword
      HelpKeyword = 'Overview'
      HelpContext = 1000
      Caption = 'Overview'
      object pnlTabDemographics: TPanel
        Left = 0
        Top = 0
        Width = 726
        Height = 368
        Align = alClient
        Color = clCream
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          726
          368)
        object gbxPctInGoal: TGroupBox
          Left = 8
          Top = 303
          Width = 178
          Height = 60
          Hint = 'Excludes visits in which the patient was considered COMPLEX'
          Caption = 'Percent in Goal (non-complex):'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Small Fonts'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          object btnSwitch: TButton
            Left = 101
            Top = 29
            Width = 45
            Height = 25
            Hint = 
              'This button toggles Percent in Goal to include or exclude visits' +
              ' in which the patient was considered Complex'
            Caption = '&Switch'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = btnSwitchClick
          end
          object lblGoalDenominator: TStaticText
            Left = 15
            Top = 12
            Width = 89
            Height = 15
            Caption = 'of X INR values:'
            TabOrder = 0
            Transparent = False
          end
          object lblPCgoal: TStaticText
            Left = 16
            Top = 32
            Width = 78
            Height = 22
            Caption = 'lblPCgoal'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            Transparent = False
          end
        end
        object btnDemoNext: TBitBtn
          Left = 553
          Top = 334
          Width = 160
          Height = 30
          Hint = 'Click to continue'
          Anchors = [akRight, akBottom]
          Caption = '&Next  '
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnDemoNextClick
          Glyph.Data = {
            F6060000424DF606000000000000360000002800000018000000180000000100
            180000000000C0060000130B0000130B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD17778D23833D5241CD81B13D91D
            13D5261DD43D36D27B7BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCF4544D51710E03A1FE96A37
            EF8A47F09B50F19E52EF8E4BEC723DE44527D92217D34F4CFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD08C8FD01511E23B20ED
            7F41F4AE59F6C867F8D470F9DD75F8DA74F8D472F6CB6CF5B361EE8D4CE6502E
            D6231BD29193FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCE6D6FD613
            0CE6562DF29F51F4B660F6C269F7D074FADE7CFAE883FAE682FADC7EF9D178F7
            C570F4BA69F3A95DEB6F3EDE2618D27576FF00FFFF00FFFF00FFFF00FFFF00FF
            D08C8ED6110BE6572EEF914CF1A85AF2B363F6C26FF9D27AFAE083FAE88BFCE9
            8CF9DE86F9D580F8C677F5B86EF3AE65F19D59EA7240DC2417D29294FF00FFFF
            00FFFF00FFFF00FFCF100DE24223ED8244F09550F2A75EF5B66AF5C375F8D180
            FADD8AFAE28EFBE38FF9DE8EF9D587F7C97EF6BD75F4B06BF29F5DF09254E85F
            37D6211AFF00FFFF00FFFF00FFCB3F40D92112EB713AEE8748EF9554F2A962F6
            B76FF6C37BF8CF84FADA8EF9DC92F9DD95FADB93F8D38DF7C983F7BF7BF4B270
            F2A163F09357EE844DE23D25D14F4DFF00FFFF00FFCF0907E24324EC7740ED85
            4AF09457F4A866F5B672F6C37CF9CE89FAD691FADB97F8D895DFC082F3CE8DF8
            CB8AF7BF7FF5B475F3A367F19259EE8751E85F38D91B14FF00FFCF7274D6140C
            E6572EEC7540EE814BF19458F2A567F5B473F6C07EF8CB8AFAD493FAD898EBCC
            94D7CEBFCFC0A7CCA16DF8BF83F5B276F3A369F0925CEF8451EA6D42DF2E1DD3
            7B7CCD2A2ADB2313E55B31EA6F3FED7F4AE88B55E79A62ECA96EF0B679F3C386
            F6CD91FAD79CDAB47EECE7DEFFFFF9E3DFD5C0A587CC915FF29F68F1905DED80
            50EA6F43E33F27D53B38CC100EDD2B18E75830EA693DA86445B6947FCCAF99D0
            B49DD3BA9FD7C0A4DEC8AEE2CDB1DFCEB7F7F3ECFFFFFAFFFEF8FCF8EFD3C9BB
            B48566CE794EED7D4FE96A42E5462BD5211DCF0605DC2C18E5532EE16138A37B
            66F5ECDFFFFCEFFFF8EDFFF8EDFEF9F0FFFBF5FEFCF6FFFEFBFFFFFCFEFCF7FD
            FAF3FEFAF1FFFFF6F7EEE1B39A8AC96742E8653FE4462BD61411CD0505DA2716
            E44B2BE15A35A67B67F7EDE0FFFBEEFFF7ECFFF7ECFEF8EFFFFBF4FDFBF5FFFD
            FAFFFEFAFEFBF5FDF9F0FEFCF3FFF9EDE5DBCEB28872CD613FE85F3BE43F28D5
            1310CD100FD91F12E24326E85633A55941B7907ECBA792CDAC96D1B099D5B69D
            DBBEA6DDBFA6DBC6B0F5F0E8FFFEF8FFFDF4EEE7DBC5A893B76947EA724BEB66
            42E65535E23623D51E1ACC2A2BD8140DDF3A21E44C2DE75936E2633FE27249E8
            7F55ED9266F1A476F4B07FF8B889E6A87DF0EAE4FCF8F3D3C0AEC17F5DE07C55
            EE774FEC6A46E95E3CE64E31DE281BD33938D07576D10906DB2D1AE34126E54C
            2FE75A38EE744CF48C61F59A6CF7A377F8AB7EF8B082F1AD84DDC2B4D7A98FEE
            9B71F5986BEE7D55EC6A47EA5D3EE75235E3412AD91B14D47F80FF00FFCD0604
            D9180FDE3720E34128EA5B39F37A52F4845CF58F64F7996CF79D71F7A378F8A6
            7AF7A175F8A176F79A6EF79369F4855DEB6041E75135E4472EE02C1DD71917FF
            00FFFF00FFCE4344D10906DD2617E03B23F1593AF46E49F47650F5815BF68A62
            F78F66F7926AF7956BF7946AF79167F78C64F5835DF57E59F06345E5452DE137
            24D91F19D86363FF00FFFF00FFFF00FFCE0B0BD40F0AE12D1DF24F31F35A3BF2
            6442F46F4BF67954F67D58F6815CF6845EF6835CF6815AF67A57F6714FF56C4C
            F2593DDF3422DB1C14DB3838FF00FFFF00FFFF00FFFF00FFD49394CF0403DA13
            0CF13924F34C31F25237F55E3EF76747F66C4BF7704FF77150F7704FF76D4BF6
            6949F65F44F65D40ED452DD91C14DE2C2ADBA5A6FF00FFFF00FFFF00FFFF00FF
            FF00FFD27577CF0605E4120DF73523F6452EF64E33F6553AF7593BF75F40F75F
            40F75D40F75C40F7553AF85339F5432FDF1B14DD2B29DB9192FF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFD69A9CD31D1DE51714F41D15F83423F93E29
            F8422CF8452FF94831F8462FF94330F93C2BF2251BE0211DDD3B3BDAA5A7FF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFDA6466DD
            2425E72323EE1713F31914F51F16F52117F21C15EC1B16E52A27DB2828DD6F70
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFD98D8FDB5354DF3B3BDF2728DF2728DE3C3CDB5354DA
            9091FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          Layout = blGlyphRight
        end
        object chrtINR: TChart
          Left = 5
          Top = 6
          Width = 708
          Height = 286
          BackWall.Brush.Color = clWhite
          BackWall.Brush.Style = bsClear
          Gradient.Direction = gdBottomTop
          Gradient.EndColor = clCream
          Gradient.StartColor = clMoneyGreen
          Gradient.Visible = True
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clBlue
          Title.Font.Height = -16
          Title.Font.Name = 'Arial'
          Title.Font.Style = [fsBold]
          Title.Text.Strings = (
            'INR')
          OnZoom = chrtINRZoom
          BottomAxis.DateTimeFormat = 'M/d/yyyy'
          BottomAxis.Increment = 7.000000000000000000
          BottomAxis.TickLength = 0
          ClipPoints = False
          LeftAxis.Automatic = False
          LeftAxis.AutomaticMaximum = False
          LeftAxis.AutomaticMinimum = False
          LeftAxis.ExactDateTime = False
          LeftAxis.Increment = 1.000000000000000000
          LeftAxis.Maximum = 7.000000000000000000
          Legend.LegendStyle = lsLastValues
          Legend.Visible = False
          View3D = False
          BevelWidth = 3
          BorderWidth = 14
          Color = clMoneyGreen
          TabOrder = 2
          Anchors = [akLeft, akTop, akRight, akBottom]
          OnEnter = chrtINREnter
          OnMouseWheel = chrtINRMouseWheel
          object btnUnzoomGraph: TBitBtn
            Left = 19
            Top = 12
            Width = 116
            Height = 25
            Caption = 'Unzoom Graph'
            TabOrder = 0
            Visible = False
            OnClick = btnUnzoomGraphClick
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000C40E0000C40E00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF800000800000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FF800000800000800000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FF800000800000800000FF00FFFF00FFFF00FF
              FF00FFFF00FF808080000000000000000000000000808080FF00FF8000008000
              00800000FF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF
              00FFFF00FF000000000000800000800000FF00FFFF00FFFF00FFFF00FFFF00FF
              000000808080FF00FFFF00FFFF00FFFF00FFFFFF00FF00FF808080000000FF00
              FFFF00FFFF00FFFF00FFFF00FF808080000000FF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFFFF00FF00FF000000808080FF00FFFF00FFFF00FFFF00FF000000
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFFFF00FF00FF0000
              00FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF00000000000000000000
              0000000000000000FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF000000
              FF00FFFFFF00000000000000000000000000000000000000FF00FFFF00FF0000
              00FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF808080
              000000FFFF00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000008080
              80FF00FFFF00FFFF00FFFF00FFFF00FF000000808080FFFF00FF00FFFFFF00FF
              00FFFF00FFFF00FF808080000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FF000000000000FF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF80808000000000000000
              0000000000808080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          end
          object serINR: TLineSeries
            Marks.ArrowLength = 8
            Marks.Style = smsValue
            Marks.Visible = True
            SeriesColor = clBlack
            ShowInLegend = False
            Dark3D = False
            LineBrush = bsCross
            Pointer.HorizSize = 2
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
            Pointer.Visible = True
            XValues.DateTime = False
            XValues.Name = 'X'
            XValues.Multiplier = 1.000000000000000000
            XValues.Order = loAscending
            YValues.DateTime = False
            YValues.Name = 'Y'
            YValues.Multiplier = 1.000000000000000000
            YValues.Order = loNone
          end
          object serUpperGoal: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clMaroon
            Title = 'Upper Goal'
            LinePen.Color = clYellow
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
          object serLowerGoal: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clMaroon
            Title = 'Lower Goal'
            LinePen.Color = -1
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
        end
        object gbxLastHctOrHgb: TGroupBox
          Left = 192
          Top = 303
          Width = 106
          Height = 60
          Caption = 'Last HCT'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          object lblHctOrHgbValue: TStaticText
            Left = 8
            Top = 16
            Width = 35
            Height = 17
            Caption = 'value'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            Transparent = False
          end
          object lblHctOrHgbDate: TStaticText
            Left = 8
            Top = 34
            Width = 29
            Height = 17
            Caption = 'date'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            Transparent = False
          end
        end
        object gbxShow: TGroupBox
          Left = 304
          Top = 303
          Width = 121
          Height = 60
          Caption = 'Show Rate'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Small Fonts'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          object lblPctNoShowDenominator: TStaticText
            Left = 14
            Top = 12
            Width = 105
            Height = 15
            Caption = 'of x visits available'
            TabOrder = 0
            Transparent = False
          end
          object lblPctNoShow: TStaticText
            Left = 35
            Top = 33
            Width = 109
            Height = 22
            Caption = 'lblPctNoShow'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            Transparent = False
          end
        end
        object btnViewFlowsheetGrid: TBitBtn
          Left = 553
          Top = 18
          Width = 138
          Height = 25
          Caption = '  &View / Edit Details'
          TabOrder = 5
          OnClick = btnViewFlowsheetGridClick
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B0040000130B0000130B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FF50616C6192B1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FF78ADD49DD8F55BA4DA4C89B9FF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFAC7F22AC790EAC7910AC7910AC7910B479098E
            7121B9D3D571C5FF068EF958849DC7860FAC7A11AC7910AC7910AC780EAE8B3D
            FF00FFFF00FFFF00FFE3D0A0FAFFFFF7FFFFF7FFFFF7FFFFF8FFFFFFFFFF5BA8
            E2C4ECFA67C0FF038AF079AEE1FFFFFFF9FFFFF7FFFFFCFFFFDABB7FFF00FFFF
            00FFFF00FFDCC392ECEEF3F0EEEEEBE8E8F0EEEEEEECECEEEAE8F2E8E660A7DD
            96D7F175CBFF0384E775A0C5F5EFECECEAEAEFF1F5D4BA7DFF00FFFF00FFFF00
            FFDCC392EBEDF2B6B5B4ECEBEABDBCBCC8C7C6E7E6E6F8F7F6FFFFFF72ABDD86
            CFF175C9FF0384E7709CC3FFFFFFF3F6F8D3B97CFF00FFFF00FFFF00FFDBC392
            E7EAF0A3A2A2C1C1C1B2B1B1C9C8C8E2E1E2E9E9E8FEFEFEFDFDFE80B6E286CE
            F175CBFF0185E66197C4F9EEE8D8BB7EFF00FFFF00FFFF00FFDBC291E5E6ECD8
            D5D5D9D7D7DBD9D9DFDDDEE0DEDFE2E1DFFFFFFFFFFFFFFFFFFF7AB4E799D9F4
            67C0FF038BF75AA0DBE4C583FF00FFFF00FFFF00FFDAC290E0E3E8DFDFDDDFDE
            DDDFDEDDDFDEDDE0DFDDBDBDBDB0B1B1B0B0B0B2B2B1C8BCB4569CD0C5EEFB67
            BFF75B7E998F723CFF00FFFF00FFFF00FFDAC190DEE0E5E1E0DFE1E0DFDCDBDA
            E0DFDEDBDAD9E4E4E3E7E6E4E7E6E4E6E6E4EAE8E5E5DCDA55A8E4D6C7B7C8BE
            B47E818A9989B5FF00FFFF00FFDAC090DCDDE1B1AFAEB2B0AFDDDBDAB7B6B4D9
            D7D5F2F1F1FEFEFEFEFEFFFEFEFFFEFEFFFFFFFFFFFFFFC5C1BEB9B6B6C399BD
            B371C2FF00FFFF00FFD9C18FD9DAE09C9A9AA3A1A1B6B4B4ABA9A9D5D4D3E3E2
            E2FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F9F9BDA4C1CE91E7FF00FFFF
            00FFFF00FFD8C18ED5D7DDC9C8C7CCCBCACACBCACCCCCAD1D0CFDBD9D8FFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFAFACBCCD1D4B58FFF00FFFF00FFFF00
            FFD8C08FD1D4DAD2D0D0D1D0D0D1CFCFD1CFD0D2D0D0AEAEAFA0A1A2A0A0A1A0
            A0A1A0A0A1A0A0A1A0A1A2A4A3A4CDD1D6D7BE7FFF00FFFF00FFFF00FFDCC18A
            E5E0DBE3DBD1E3DCD1E3DCD1E3DCD1E3DCD2E8E2D6EAE3D8EAE4D8EAE4D8EAE4
            D8EAE4D8EAE4D8E9E2D7EBE7E1D5B979FF00FFFF00FFFF00FFDCAC58E1A94CDF
            A647DFA648DFA648DFA648DFA648DFA648DEA548DEA548DEA548DEA548DEA548
            DEA548DEA546E6B361D6AF66FF00FFFF00FFFF00FFDCAB56E4B15EE2AF59E2AF
            59E2AF59E2AF59E2AF59E2AF59E2AF59E2AF59E2AF59E2AF59E2AF59E2AF59E1
            AE58E8BA6ED6AD61FF00FFFF00FFFF00FFBE8B26C08E2BC08E2BC08E2BC08E2B
            C08E2BC08E2BC08E2BC08E2BC08E2BC08E2BC08E2BC08E2BC08E2BC08E2BC18D
            29C0963DFF00FFFF00FF}
        end
      end
    end
    object tsEnterInfo: TTabSheet
      HelpKeyword = 'Enter Information'
      HelpContext = 1300
      Caption = 'Enter Information'
      ImageIndex = 2
      object pnlTabEnter: TPanel
        Left = 0
        Top = 0
        Width = 726
        Height = 368
        Align = alClient
        Color = clCream
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          726
          368)
        object lblFSVDt: TLabel
          Left = 12
          Top = 6
          Width = 77
          Height = 13
          Caption = 'Flowsheet Date:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblPtNotice: TLabel
          Left = 227
          Top = 12
          Width = 47
          Height = 13
          Caption = 'Pt Notice:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblComments: TLabel
          Left = 222
          Top = 33
          Width = 52
          Height = 13
          Caption = 'Comments:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblAM: TLabel
          Left = 11
          Top = 48
          Width = 91
          Height = 15
          Caption = 'Takes AM meds'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Roman'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object lblRecommendedChange: TLabel
          Left = 99
          Top = 263
          Width = 480
          Height = 32
          AutoSize = False
          Caption = 'Based on INR, consider 5% increase in weekly dose'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label1: TLabel
          Left = 3
          Top = 263
          Width = 86
          Height = 13
          Caption = 'Recommendation:'
        end
        object lblFSDate: TLabel
          Left = 97
          Top = 6
          Width = 56
          Height = 13
          Caption = 'lblFSDate'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblMissedAppt: TLabel
          Left = 11
          Top = 25
          Width = 158
          Height = 13
          Caption = 'Status: Missed Appointment'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object lblMissedApptDate: TLabel
          Left = 181
          Top = 299
          Width = 124
          Height = 13
          Caption = 'Missed Appointment Date:'
          Visible = False
        end
        object gbxDailyDosing: TGroupBox
          Left = 2
          Top = 91
          Width = 704
          Height = 166
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Current Daily Dosing'
          Color = cl3DLight
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Small Fonts'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          DesignSize = (
            704
            166)
          object lblSun: TLabel
            Left = 150
            Top = 13
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = 'Sun'
          end
          object lblThu: TLabel
            Left = 312
            Top = 13
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = 'Thur'
          end
          object lblWed: TLabel
            Left = 271
            Top = 13
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = 'Wed'
          end
          object lblMon: TLabel
            Left = 189
            Top = 13
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = 'Mon'
          end
          object lblSat: TLabel
            Left = 396
            Top = 13
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = 'Sat'
          end
          object lblFri: TLabel
            Left = 354
            Top = 13
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = 'Fri'
          end
          object lblTue: TLabel
            Left = 230
            Top = 13
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = 'Tue'
          end
          object lblTotals: TLabel
            Left = 446
            Top = 13
            Width = 36
            Height = 11
            Caption = 'Weekly'
            WordWrap = True
          end
          object lblTablets2: TLabel
            Left = 114
            Top = 107
            Width = 30
            Height = 11
            Anchors = [akLeft, akBottom]
            Caption = 'tablets:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
            ExplicitTop = 92
          end
          object lblMilligrams: TLabel
            Left = 100
            Top = 141
            Width = 45
            Height = 11
            Anchors = [akLeft, akBottom]
            Caption = 'Total mgs:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
          end
          object lblStrength2: TLabel
            Left = 107
            Top = 89
            Width = 37
            Height = 11
            Anchors = [akLeft, akBottom]
            Caption = 'Strength:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
            ExplicitTop = 74
          end
          object lblPillStrength: TLabel
            Left = 10
            Top = 28
            Width = 59
            Height = 13
            Caption = 'Pill Strength:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblMg: TLabel
            Left = 62
            Top = 46
            Width = 13
            Height = 11
            Caption = 'mg'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
          end
          object lblPillStrength2: TLabel
            Left = 10
            Top = 125
            Width = 80
            Height = 13
            Anchors = [akLeft, akBottom]
            Caption = '2nd Pill Strength:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ExplicitTop = 110
          end
          object lblMg2: TLabel
            Left = 62
            Top = 107
            Width = 13
            Height = 11
            Anchors = [akLeft, akBottom]
            Caption = 'mg'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
            ExplicitTop = 92
          end
          object lblPriorTotalName: TLabel
            Left = 495
            Top = 113
            Width = 28
            Height = 22
            Anchors = [akLeft, akBottom]
            Caption = 'Prior Total'
            Visible = False
            WordWrap = True
          end
          object lblPctChangeName: TLabel
            Left = 536
            Top = 113
            Width = 39
            Height = 22
            Anchors = [akLeft, akBottom]
            Caption = 'Change     %'
            Visible = False
            WordWrap = True
            ExplicitTop = 98
          end
          object lblStrength1: TLabel
            Left = 107
            Top = 28
            Width = 37
            Height = 11
            Caption = 'Strength:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
          end
          object lblTablets1: TLabel
            Left = 114
            Top = 46
            Width = 30
            Height = 11
            Caption = 'tablets:'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
          end
          object lblCM1Sun: TLabel
            Left = 150
            Top = 28
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = '5 mg'
            Color = clSkyBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object lblCM1Mon: TLabel
            Left = 191
            Top = 28
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = '5 mg'
            Color = clSkyBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object lblCM1Tue: TLabel
            Left = 230
            Top = 28
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = '5 mg'
            Color = clSkyBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object lblCM1Wed: TLabel
            Left = 271
            Top = 28
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = '5 mg'
            Color = clSkyBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object lblCM1Thur: TLabel
            Left = 312
            Top = 28
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = '5 mg'
            Color = clSkyBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object lblCM1Fri: TLabel
            Left = 354
            Top = 28
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = '5 mg'
            Color = clSkyBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object lblCM1Sat: TLabel
            Left = 396
            Top = 28
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = '5 mg'
            Color = clSkyBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object lblCM2Sun: TLabel
            Left = 150
            Top = 89
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '5 mg'
            Color = clMoneyGreen
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ExplicitTop = 74
          end
          object lblCM2Mon: TLabel
            Left = 191
            Top = 89
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '5 mg'
            Color = clMoneyGreen
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ExplicitTop = 74
          end
          object lblCM2Tue: TLabel
            Left = 230
            Top = 89
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '5 mg'
            Color = clMoneyGreen
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ExplicitTop = 74
          end
          object lblCM2Wed: TLabel
            Left = 271
            Top = 89
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '5 mg'
            Color = clMoneyGreen
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ExplicitTop = 74
          end
          object lblCM2Thur: TLabel
            Left = 312
            Top = 89
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '5 mg'
            Color = clMoneyGreen
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ExplicitTop = 74
          end
          object lblCM2Fri: TLabel
            Left = 354
            Top = 89
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '5 mg'
            Color = clMoneyGreen
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ExplicitTop = 74
          end
          object lblCM2Sat: TLabel
            Left = 396
            Top = 89
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '5 mg'
            Color = clMoneyGreen
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ExplicitTop = 74
          end
          object lblCMSun: TLabel
            Left = 153
            Top = 141
            Width = 42
            Height = 11
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '0'
            Color = clBtnFace
            ParentColor = False
            Transparent = False
          end
          object lblCMMon: TLabel
            Left = 194
            Top = 141
            Width = 42
            Height = 11
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '0'
            Color = clBtnFace
            ParentColor = False
            Transparent = False
          end
          object lblCMTue: TLabel
            Left = 233
            Top = 141
            Width = 42
            Height = 11
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '0'
            Color = clBtnFace
            ParentColor = False
            Transparent = False
          end
          object lblCMWed: TLabel
            Left = 274
            Top = 141
            Width = 42
            Height = 11
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '0'
            Color = clBtnFace
            ParentColor = False
            Transparent = False
          end
          object lblCMThur: TLabel
            Left = 314
            Top = 141
            Width = 42
            Height = 11
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '0'
            Color = clBtnFace
            ParentColor = False
            Transparent = False
          end
          object lblCMFri: TLabel
            Left = 356
            Top = 141
            Width = 42
            Height = 11
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '0'
            Color = clBtnFace
            ParentColor = False
            Transparent = False
          end
          object lblCMSat: TLabel
            Left = 398
            Top = 141
            Width = 42
            Height = 11
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '0'
            Color = clBtnFace
            ParentColor = False
            Transparent = False
          end
          object lblTotM: TLabel
            Left = 442
            Top = 141
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '0'
            Color = clBtnFace
            ParentColor = False
            Transparent = False
            ExplicitTop = 126
          end
          object lblTotT1: TLabel
            Left = 444
            Top = 46
            Width = 42
            Height = 11
            Alignment = taCenter
            AutoSize = False
            Caption = '5 mg'
            Color = clSkyBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object lblTotT2: TLabel
            Left = 444
            Top = 107
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '5 mg'
            Color = clMoneyGreen
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ExplicitTop = 92
          end
          object lblPriorTotal: TLabel
            Left = 488
            Top = 141
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '0'
            Color = clBtnFace
            ParentColor = False
            Transparent = False
            ExplicitTop = 126
          end
          object lblChangePct: TLabel
            Left = 535
            Top = 141
            Width = 42
            Height = 11
            Alignment = taCenter
            Anchors = [akLeft, akBottom]
            AutoSize = False
            Caption = '0'
            Color = clBtnFace
            ParentColor = False
            Transparent = False
            ExplicitTop = 126
          end
          object edtCT2Sat: TEdit
            Left = 396
            Top = 104
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Saturday'
            Anchors = [akLeft, akBottom]
            Color = clMoneyGreen
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 13
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT2Fri: TEdit
            Left = 354
            Top = 104
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Friday'
            Anchors = [akLeft, akBottom]
            Color = clMoneyGreen
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 12
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT2Sun: TEdit
            Tag = 1
            Left = 150
            Top = 104
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Sunday'
            Anchors = [akLeft, akBottom]
            Color = clMoneyGreen
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT2Mon: TEdit
            Left = 191
            Top = 104
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Monday'
            Anchors = [akLeft, akBottom]
            Color = clMoneyGreen
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT2Tue: TEdit
            Left = 230
            Top = 104
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Tuesday'
            Anchors = [akLeft, akBottom]
            Color = clMoneyGreen
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 9
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT2Wed: TEdit
            Left = 271
            Top = 104
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Wednesday'
            Anchors = [akLeft, akBottom]
            Color = clMoneyGreen
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 10
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT2Thur: TEdit
            Left = 312
            Top = 104
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Thursday'
            Anchors = [akLeft, akBottom]
            Color = clMoneyGreen
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 11
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object cbUse2Pills: TCheckBox
            Left = 13
            Top = 83
            Width = 78
            Height = 17
            Hint = 'Check this box to use two different pill strengths'
            Anchors = [akLeft, akBottom]
            Caption = '&Use Two Pills'
            Checked = True
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 14
            OnClick = cbUse2PillsClick
          end
          object edtCT1Sun: TEdit
            Tag = 1
            Left = 150
            Top = 43
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Sunday'
            Color = clSkyBlue
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT1Mon: TEdit
            Left = 191
            Top = 43
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Monday'
            Color = clSkyBlue
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT1Tue: TEdit
            Left = 230
            Top = 43
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Tuesday'
            Color = clSkyBlue
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT1Wed: TEdit
            Left = 271
            Top = 43
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Wednesday'
            Color = clSkyBlue
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT1Thur: TEdit
            Left = 312
            Top = 43
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Thursday'
            Color = clSkyBlue
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT1Fri: TEdit
            Left = 354
            Top = 43
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Friday'
            Color = clSkyBlue
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 5
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object edtCT1Sat: TEdit
            Left = 396
            Top = 43
            Width = 42
            Height = 19
            Hint = 'Enter number of tablets to be taken Saturday'
            Color = clSkyBlue
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            Text = '0'
            OnChange = HandleDosingGridEditChange
            OnExit = DosingGridEditExit
            OnKeyPress = edtDosingGridKeyPress
          end
          object cboPS: TComboBox
            Left = 10
            Top = 43
            Width = 44
            Height = 19
            Hint = 'Enter pill strength in milligrams'
            Color = clSkyBlue
            ItemHeight = 11
            ParentShowHint = False
            ShowHint = True
            TabOrder = 15
            OnChange = cboPSChange
            OnExit = cboPSExit
            Items.Strings = (
              '1'
              '2'
              '2.5'
              '3'
              '4'
              '5'
              '6'
              '7.5'
              '10')
          end
          object cboPS2: TComboBox
            Left = 10
            Top = 104
            Width = 44
            Height = 19
            Hint = 'Enter pill strength in milligrams'
            Anchors = [akLeft, akBottom]
            Color = clMoneyGreen
            ItemHeight = 11
            ParentShowHint = False
            ShowHint = True
            TabOrder = 16
            OnChange = cboPS2Change
            OnExit = cboPS2Exit
            Items.Strings = (
              '1'
              '2'
              '2.5'
              '3'
              '4'
              '5'
              '6'
              '7.5'
              '10')
          end
          object btnSwapSun: TBitBtn
            Left = 161
            Top = 66
            Width = 16
            Height = 18
            Hint = 'Click to Swap Number of Tablets'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 17
            OnClick = btnSwapClick
            Glyph.Data = {
              32010000424D32010000000000004200000028000000060000000A0000000100
              200003000000F0000000130B0000130B00000000000000000000000000FF0000
              FF0000FF0000FFFF00FFFFFF00FFFF030303FF030303FFFF00FFFFFF00FFFFFF
              00FFFF030303FF000000FF000000FF030303FFFF00FFFF030303FF030303FF30
              3030FF303030FF030303FF030303FFFF00FFFFFF00FFFF303030FF303030FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF40
              4040FF404040FFFF00FFFFFF00FFFF4F4F4FFF4F4F4FFF404040FF404040FF4F
              4F4FFF4F4F4FFFFF00FFFF4F4F4FFF404040FF404040FF4F4F4FFFFF00FFFFFF
              00FFFFFF00FFFF4F4F4FFF4F4F4FFFFF00FFFFFF00FF}
          end
          object btnSwapMon: TBitBtn
            Left = 204
            Top = 66
            Width = 16
            Height = 18
            Hint = 'Click to Swap Number of Tablets'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 18
            OnClick = btnSwapClick
            Glyph.Data = {
              32010000424D32010000000000004200000028000000060000000A0000000100
              200003000000F0000000130B0000130B00000000000000000000000000FF0000
              FF0000FF0000FFFF00FFFFFF00FFFF030303FF030303FFFF00FFFFFF00FFFFFF
              00FFFF030303FF000000FF000000FF030303FFFF00FFFF030303FF030303FF30
              3030FF303030FF030303FF030303FFFF00FFFFFF00FFFF303030FF303030FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF40
              4040FF404040FFFF00FFFFFF00FFFF4F4F4FFF4F4F4FFF404040FF404040FF4F
              4F4FFF4F4F4FFFFF00FFFF4F4F4FFF404040FF404040FF4F4F4FFFFF00FFFFFF
              00FFFFFF00FFFF4F4F4FFF4F4F4FFFFF00FFFFFF00FF}
          end
          object btnSwapTue: TBitBtn
            Left = 243
            Top = 66
            Width = 16
            Height = 18
            Hint = 'Click to Swap Number of Tablets'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 19
            OnClick = btnSwapClick
            Glyph.Data = {
              32010000424D32010000000000004200000028000000060000000A0000000100
              200003000000F0000000130B0000130B00000000000000000000000000FF0000
              FF0000FF0000FFFF00FFFFFF00FFFF030303FF030303FFFF00FFFFFF00FFFFFF
              00FFFF030303FF000000FF000000FF030303FFFF00FFFF030303FF030303FF30
              3030FF303030FF030303FF030303FFFF00FFFFFF00FFFF303030FF303030FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF40
              4040FF404040FFFF00FFFFFF00FFFF4F4F4FFF4F4F4FFF404040FF404040FF4F
              4F4FFF4F4F4FFFFF00FFFF4F4F4FFF404040FF404040FF4F4F4FFFFF00FFFFFF
              00FFFFFF00FFFF4F4F4FFF4F4F4FFFFF00FFFFFF00FF}
          end
          object btnSwapWed: TBitBtn
            Left = 285
            Top = 66
            Width = 16
            Height = 18
            Hint = 'Click to Swap Number of Tablets'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 20
            OnClick = btnSwapClick
            Glyph.Data = {
              32010000424D32010000000000004200000028000000060000000A0000000100
              200003000000F0000000130B0000130B00000000000000000000000000FF0000
              FF0000FF0000FFFF00FFFFFF00FFFF030303FF030303FFFF00FFFFFF00FFFFFF
              00FFFF030303FF000000FF000000FF030303FFFF00FFFF030303FF030303FF30
              3030FF303030FF030303FF030303FFFF00FFFFFF00FFFF303030FF303030FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF40
              4040FF404040FFFF00FFFFFF00FFFF4F4F4FFF4F4F4FFF404040FF404040FF4F
              4F4FFF4F4F4FFFFF00FFFF4F4F4FFF404040FF404040FF4F4F4FFFFF00FFFFFF
              00FFFFFF00FFFF4F4F4FFF4F4F4FFFFF00FFFFFF00FF}
          end
          object btnSwapThur: TBitBtn
            Left = 324
            Top = 66
            Width = 16
            Height = 18
            Hint = 'Click to Swap Number of Tablets'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 21
            OnClick = btnSwapClick
            Glyph.Data = {
              32010000424D32010000000000004200000028000000060000000A0000000100
              200003000000F0000000130B0000130B00000000000000000000000000FF0000
              FF0000FF0000FFFF00FFFFFF00FFFF030303FF030303FFFF00FFFFFF00FFFFFF
              00FFFF030303FF000000FF000000FF030303FFFF00FFFF030303FF030303FF30
              3030FF303030FF030303FF030303FFFF00FFFFFF00FFFF303030FF303030FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF40
              4040FF404040FFFF00FFFFFF00FFFF4F4F4FFF4F4F4FFF404040FF404040FF4F
              4F4FFF4F4F4FFFFF00FFFF4F4F4FFF404040FF404040FF4F4F4FFFFF00FFFFFF
              00FFFFFF00FFFF4F4F4FFF4F4F4FFFFF00FFFFFF00FF}
          end
          object btnSwapFri: TBitBtn
            Left = 365
            Top = 66
            Width = 16
            Height = 18
            Hint = 'Click to Swap Number of Tablets'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 22
            OnClick = btnSwapClick
            Glyph.Data = {
              32010000424D32010000000000004200000028000000060000000A0000000100
              200003000000F0000000130B0000130B00000000000000000000000000FF0000
              FF0000FF0000FFFF00FFFFFF00FFFF030303FF030303FFFF00FFFFFF00FFFFFF
              00FFFF030303FF000000FF000000FF030303FFFF00FFFF030303FF030303FF30
              3030FF303030FF030303FF030303FFFF00FFFFFF00FFFF303030FF303030FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF40
              4040FF404040FFFF00FFFFFF00FFFF4F4F4FFF4F4F4FFF404040FF404040FF4F
              4F4FFF4F4F4FFFFF00FFFF4F4F4FFF404040FF404040FF4F4F4FFFFF00FFFFFF
              00FFFFFF00FFFF4F4F4FFF4F4F4FFFFF00FFFFFF00FF}
          end
          object btnSwapSat: TBitBtn
            Left = 407
            Top = 66
            Width = 16
            Height = 18
            Hint = 'Click to Swap Number of Tablets'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 23
            OnClick = btnSwapClick
            Glyph.Data = {
              32010000424D32010000000000004200000028000000060000000A0000000100
              200003000000F0000000130B0000130B00000000000000000000000000FF0000
              FF0000FF0000FFFF00FFFFFF00FFFF030303FF030303FFFF00FFFFFF00FFFFFF
              00FFFF030303FF000000FF000000FF030303FFFF00FFFF030303FF030303FF30
              3030FF303030FF030303FF030303FFFF00FFFFFF00FFFF303030FF303030FFFF
              00FFFFFF00FFFFFF00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF
              00FFFFFF00FFFF404040FF404040FFFF00FFFFFF00FFFFFF00FFFFFF00FFFF40
              4040FF404040FFFF00FFFFFF00FFFF4F4F4FFF4F4F4FFF404040FF404040FF4F
              4F4FFF4F4F4FFFFF00FFFF4F4F4FFF404040FF404040FF4F4F4FFFFF00FFFFFF
              00FFFFFF00FFFF4F4F4FFF4F4F4FFFFF00FFFFFF00FF}
          end
          object gbxInstructions: TGroupBox
            Left = 504
            Top = 10
            Width = 185
            Height = 97
            Anchors = [akTop, akRight]
            Caption = 'Extra Instructions'
            TabOrder = 24
            object lblHoldDays: TLabel
              Left = 129
              Top = 17
              Width = 24
              Height = 11
              Caption = 'days'
              Enabled = False
            end
            object lblExtraMgsToday: TLabel
              Left = 87
              Top = 43
              Width = 48
              Height = 11
              Caption = 'mg today'
              Enabled = False
            end
            object ckbHold: TCheckBox
              Left = 3
              Top = 18
              Width = 85
              Height = 17
              Caption = '&Hold dose for'
              TabOrder = 0
              OnClick = ckbHoldClick
            end
            object edtNumHoldDays: TEdit
              Left = 94
              Top = 16
              Width = 29
              Height = 19
              Hint = 'Number of days'
              Enabled = False
              MaxLength = 1
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnChange = edtNumHoldDaysChange
            end
            object ckbTake: TCheckBox
              Left = 3
              Top = 41
              Width = 45
              Height = 17
              Caption = '&Take'
              TabOrder = 2
              OnClick = ckbTakeClick
            end
            object edtTakeNumMgToday: TEdit
              Left = 52
              Top = 41
              Width = 29
              Height = 19
              Hint = 'Number of days'
              MaxLength = 3
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnChange = edtTakeNumMgTodayChange
            end
            object memPatientInstructions: TMemo
              Left = 5
              Top = 66
              Width = 175
              Height = 26
              TabOrder = 4
              WordWrap = False
              OnChange = memPatientInstructionsChange
              OnClick = memPatientInstructionsClick
              OnEnter = memPatientInstructionsEnter
            end
          end
        end
        object edtPtNote: TEdit
          Left = 283
          Top = 9
          Width = 423
          Height = 21
          Hint = 'Enter text of Patient Notice'
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnChange = edtPtNoteChange
          OnKeyPress = edtPtNoteKeyPress
        end
        object memComments: TMemo
          Left = 283
          Top = 33
          Width = 424
          Height = 50
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Pitch = fpFixed
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnExit = memCommentsExit
        end
        object btnEditDoseNext: TBitBtn
          Left = 553
          Top = 334
          Width = 160
          Height = 30
          Hint = 'Click to accept dosing and continue'
          Anchors = [akRight, akBottom]
          Caption = '&Next  '
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = btnEditDoseNextClick
          Glyph.Data = {
            F6060000424DF606000000000000360000002800000018000000180000000100
            180000000000C0060000130B0000130B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD17778D23833D5241CD81B13D91D
            13D5261DD43D36D27B7BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCF4544D51710E03A1FE96A37
            EF8A47F09B50F19E52EF8E4BEC723DE44527D92217D34F4CFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD08C8FD01511E23B20ED
            7F41F4AE59F6C867F8D470F9DD75F8DA74F8D472F6CB6CF5B361EE8D4CE6502E
            D6231BD29193FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCE6D6FD613
            0CE6562DF29F51F4B660F6C269F7D074FADE7CFAE883FAE682FADC7EF9D178F7
            C570F4BA69F3A95DEB6F3EDE2618D27576FF00FFFF00FFFF00FFFF00FFFF00FF
            D08C8ED6110BE6572EEF914CF1A85AF2B363F6C26FF9D27AFAE083FAE88BFCE9
            8CF9DE86F9D580F8C677F5B86EF3AE65F19D59EA7240DC2417D29294FF00FFFF
            00FFFF00FFFF00FFCF100DE24223ED8244F09550F2A75EF5B66AF5C375F8D180
            FADD8AFAE28EFBE38FF9DE8EF9D587F7C97EF6BD75F4B06BF29F5DF09254E85F
            37D6211AFF00FFFF00FFFF00FFCB3F40D92112EB713AEE8748EF9554F2A962F6
            B76FF6C37BF8CF84FADA8EF9DC92F9DD95FADB93F8D38DF7C983F7BF7BF4B270
            F2A163F09357EE844DE23D25D14F4DFF00FFFF00FFCF0907E24324EC7740ED85
            4AF09457F4A866F5B672F6C37CF9CE89FAD691FADB97F8D895DFC082F3CE8DF8
            CB8AF7BF7FF5B475F3A367F19259EE8751E85F38D91B14FF00FFCF7274D6140C
            E6572EEC7540EE814BF19458F2A567F5B473F6C07EF8CB8AFAD493FAD898EBCC
            94D7CEBFCFC0A7CCA16DF8BF83F5B276F3A369F0925CEF8451EA6D42DF2E1DD3
            7B7CCD2A2ADB2313E55B31EA6F3FED7F4AE88B55E79A62ECA96EF0B679F3C386
            F6CD91FAD79CDAB47EECE7DEFFFFF9E3DFD5C0A587CC915FF29F68F1905DED80
            50EA6F43E33F27D53B38CC100EDD2B18E75830EA693DA86445B6947FCCAF99D0
            B49DD3BA9FD7C0A4DEC8AEE2CDB1DFCEB7F7F3ECFFFFFAFFFEF8FCF8EFD3C9BB
            B48566CE794EED7D4FE96A42E5462BD5211DCF0605DC2C18E5532EE16138A37B
            66F5ECDFFFFCEFFFF8EDFFF8EDFEF9F0FFFBF5FEFCF6FFFEFBFFFFFCFEFCF7FD
            FAF3FEFAF1FFFFF6F7EEE1B39A8AC96742E8653FE4462BD61411CD0505DA2716
            E44B2BE15A35A67B67F7EDE0FFFBEEFFF7ECFFF7ECFEF8EFFFFBF4FDFBF5FFFD
            FAFFFEFAFEFBF5FDF9F0FEFCF3FFF9EDE5DBCEB28872CD613FE85F3BE43F28D5
            1310CD100FD91F12E24326E85633A55941B7907ECBA792CDAC96D1B099D5B69D
            DBBEA6DDBFA6DBC6B0F5F0E8FFFEF8FFFDF4EEE7DBC5A893B76947EA724BEB66
            42E65535E23623D51E1ACC2A2BD8140DDF3A21E44C2DE75936E2633FE27249E8
            7F55ED9266F1A476F4B07FF8B889E6A87DF0EAE4FCF8F3D3C0AEC17F5DE07C55
            EE774FEC6A46E95E3CE64E31DE281BD33938D07576D10906DB2D1AE34126E54C
            2FE75A38EE744CF48C61F59A6CF7A377F8AB7EF8B082F1AD84DDC2B4D7A98FEE
            9B71F5986BEE7D55EC6A47EA5D3EE75235E3412AD91B14D47F80FF00FFCD0604
            D9180FDE3720E34128EA5B39F37A52F4845CF58F64F7996CF79D71F7A378F8A6
            7AF7A175F8A176F79A6EF79369F4855DEB6041E75135E4472EE02C1DD71917FF
            00FFFF00FFCE4344D10906DD2617E03B23F1593AF46E49F47650F5815BF68A62
            F78F66F7926AF7956BF7946AF79167F78C64F5835DF57E59F06345E5452DE137
            24D91F19D86363FF00FFFF00FFFF00FFCE0B0BD40F0AE12D1DF24F31F35A3BF2
            6442F46F4BF67954F67D58F6815CF6845EF6835CF6815AF67A57F6714FF56C4C
            F2593DDF3422DB1C14DB3838FF00FFFF00FFFF00FFFF00FFD49394CF0403DA13
            0CF13924F34C31F25237F55E3EF76747F66C4BF7704FF77150F7704FF76D4BF6
            6949F65F44F65D40ED452DD91C14DE2C2ADBA5A6FF00FFFF00FFFF00FFFF00FF
            FF00FFD27577CF0605E4120DF73523F6452EF64E33F6553AF7593BF75F40F75F
            40F75D40F75C40F7553AF85339F5432FDF1B14DD2B29DB9192FF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFD69A9CD31D1DE51714F41D15F83423F93E29
            F8422CF8452FF94831F8462FF94330F93C2BF2251BE0211DDD3B3BDAA5A7FF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFDA6466DD
            2425E72323EE1713F31914F51F16F52117F21C15EC1B16E52A27DB2828DD6F70
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFD98D8FDB5354DF3B3BDF2728DF2728DE3C3CDB5354DA
            9091FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          Layout = blGlyphRight
        end
        object btnCancelDose: TBitBtn
          Left = 298
          Top = 334
          Width = 161
          Height = 30
          Hint = 'Click to cancel changes to daily dosing pattern'
          Anchors = [akRight, akBottom]
          Caption = '  &Reset Dosing To Prior'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          Visible = False
          OnClick = btnCancelDoseClick
          Glyph.Data = {
            42090000424D4209000000000000420000002800000018000000180000000100
            20000300000000090000130B0000130B00000000000000000000000000FF0000
            FF0000FF00000000000002000000020000000200000002000000020000000200
            0000020000000200000002000000020000000200000002000000020000000200
            0000020000000200000002000000020000000200000002000000020000000200
            000000000000090000001A000000220000002200000022000000220000002200
            0000220000002200000022000000220000002200000022000000220000002200
            0000220000002200000022000000220000002200000022000000220000001A00
            00000900000026543D0DD5A8730AE9AC7100E9AB7000E9AB7000E9AB7000E9AB
            7000E9AB7000E9AB7000E9AB7000E9AB7000E9AB7000E9AB7000E9AB7000E9AB
            7000E9AB7000E9AB7000E9AB7000E9AB7000E9AB7000E9AB7000E9AC7100D5A8
            730A26543D0D336D4600FFD8BF86FFF7FFFFFFF5FDFFFFF5FDFFFFF5FDFFFFF5
            FDFFFFF5FDFFFFF5FDFFFFF5FDFFFFF5FDFFFFF5FDFFFFF5FDFFFFF5FDFFFFF5
            FDFFFFF5FDFFFFF5FDFFFFF5FDFFFFF5FDFFFFF5FDFFFFF5FDFFFFF7FFFFFFD8
            BF86336D4600326C4500FFD5B97FFFEEEFF2FFEBEAEAFFEBEAEAFFEBEAEAFFEB
            EAEAFFEBEAEAFFEBEAEAFFEBEAEAFFE9E8E7FFE9E7E7FFE9E7E7FFE9E7E7FFE9
            E7E7FFE9E7E7FFE9E7E7FFE9E7E7FFE9E7E7FFE9E8E7FFE9E8E7FFEEEFF3FFD5
            B97F326C4500326C4500FFD5B97FFFEAECF0FFE8E7E7FFE9E8E8FFE8E7E8FFE9
            E8E8FFE9E8E8FFE8E7E7FFEAE9E9FFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFC
            FCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFBFFE9EAEEFFD5
            B97F326C4500326C4500FFD5B97FFFEAEAEDFFE8E7E6FFDBDAD8FFEBEAE8FFDF
            DEDDFFE0DFDEFFE8E7E6FFE6E5E5FFF7F7F6FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFCFCFFFFFEFEFFFFFFFFFFFFFFFFFFFFF0EFEFFFE8E9EBFFD5
            B97F326C4500326C4500FFD5BA7FFFE8E8ECFFE2DFE0FFA8A7A7FFF1EFF0FFBA
            B8B9FFB8B7B7FFE3E1E1FFE4E2E2FFEEEEEDFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFD4D4FFFFADADFFFFFFFFFFFFFFFFFFFFE1E1DFFFE7E7ECFFD5
            BA7F326C4500326C4500FFD5BA7FFFE5E6E9FFD6D5D4FF717070FF979594FFA0
            9F9EFFBEBDBCFFDAD9D8FFA3A3CCFFA6A7D0FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFE4E4FFFF1E1EFDFF7272FEFFFFFFFFFFFFFFFFFFD3D3D1FFE6E8EBFFD6
            BA7F326C4500326C4500FFD6BA7FFFE3E3E7FFE3E2E3FFEEECECFFEAE9E9FFE9
            E7E7FFE4E3E4FF8484DBFF1E1CBAFF7D7ECCFFF6F6F6FFF5F5F5FFF5F5F5FFE7
            E7F5FF3030F9FF0A0AE9FFABABF5FFF5F5F5FFF8F9F9FFC5C3C1FFE6E7EBFFD6
            BA7F326C4500326C4500FFD6BB7FFFE1E2E5FFDEDCDCFFDEDDDCFFDEDDDCFFDE
            DDDCFF9190D0FF2A18EAFF3710FFFF4C4CC4FF7878BFFF7473C0FF6766CBFF0D
            0DF3FF0E0DF5FF1312E8FFB3B2C3FFC3C3C2FFC3C3C3FFC6C6C5FFE3E4E7FFD6
            BA7F326C4500326C4500FFD6BB80FFDFE0E2FFDCDAD9FFDCDAD9FFDCDAD9FF9E
            9DD5FF372AE4FF310CFFFF3815FEFF3E22F9FF3F24F9FF4125F8FF442BFBFF31
            2BFDFF423AFCFF6563D6FFD2D0D3FFD8D6D4FFD8D6D4FFD9D6D5FFDFDFE1FFD6
            BB80326C4500326C4500FFD7BB80FFDDDEE0FFDAD9D8FFDDDCDBFFDCDBDAFF42
            3CDFFF594AF9FF4136ECFF3F33E8FF4236EAFF493DF0FF594DFCFF7368FFFF7F
            72FEFF605BEDFFD4D4F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9D9DCFFD7
            BB80326C4500326C4500FFD7BB80FFDBDCDEFFD1D0CFFF979796FFAAA9A8FFBA
            B7D9FF524BDDFF8374FFFF7A6EFEFF635AF7FF6459F8FF645BF7FF6F63F9FF84
            7FF4FFD5D4FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E8E9FFD8D8DAFFD7
            BB81326C4500326C4500FFD7BC80FFD9D9DCFFDAD8D8FFD8D7D7FFD9D6D7FFE3
            E0E0FFB7B3D9FF4E49EFFFA490FEFF8987ECFFEAE9FDFFE8E8FDFFEDECFDFFF9
            F9FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD9D8D7FFD7D8DBFFD7
            BC81326C4500326C4500FFD7BC81FFD7D8DAFFC8C6C5FF676665FF8C8B8AFF8B
            8A89FF848382FFB4B0D2FF4C43F3FF9994EBFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC8C7C5FFD8D9DAFFD7
            BC81326C4500326C4500FFD8BC81FFD4D5D7FFD4D2D1FFDCDBDAFFD9D8D7FFD9
            D8D7FFD9D7D6FFD3D1D0FFB8B4D3FFA4A2C3FFCDCECEFFCDCDCDFFCDCDCDFFCD
            CDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCFD0D0FFACABAAFFD8D9DBFFD8
            BC81326C4500326C4500FFD8BD81FFCECFD2FFCAC8C7FFCAC8C7FFCAC8C7FFCA
            C8C7FFCAC8C7FFCAC8C7FFCBC9C8FFC6C4C4FFC5C4C4FFC5C4C4FFC5C4C4FFC5
            C4C4FFC5C4C4FFC5C4C4FFC5C4C4FFC5C4C4FFC5C4C4FFC5C4C4FFD0D0D3FFD8
            BD81326C4500326C4500FFD5B97CFFF4F3F1FFF3F2EEFFF3F2EEFFF3F2EEFFF3
            F2EEFFF3F2EEFFF3F2EEFFF3F2EEFFF3F3EEFFF3F3EEFFF3F3EEFFF3F3EEFFF3
            F3EEFFF3F3EEFFF3F3EEFFF3F3EEFFF3F3EEFFF3F3EEFFF3F2EEFFF3F3F1FFD5
            B97C326C4500326C4900FFD8B168FFE1A94EFFDEA342FFDEA443FFDEA443FFDE
            A443FFDEA443FFDEA443FFDEA343FFDEA343FFDEA343FFDEA343FFDEA343FFDE
            A343FFDEA343FFDEA343FFDEA343FFDEA343FFDEA343FFDEA342FFE1A94EFFD8
            B168326C4900326D4A03FFD5AF65FFD59427FFD18D18FFD18C19FFD18C19FFD1
            8C19FFD18C19FFD18C19FFD18C19FFD18C19FFD18C19FFD18C19FFD18C19FFD1
            8C19FFD18C19FFD18C19FFD18C19FFD18C19FFD18C19FFD18D18FFD59427FFD5
            AF65326D4A0328865C09FFCFA24EFFE7C78FFFE7C890FFE7C890FFE7C890FFE7
            C890FFE7C890FFE7C890FFE7C890FFE7C890FFE7C890FFE7C890FFE7C890FFE7
            C890FFE7C890FFE7C890FFE7C890FFE7C890FFE7C890FFE7C890FFE7C78FFFCF
            A24E28865C090BA1741B70B37D1080B0790680B0770580B0770680B0770680B0
            770680B0770680B0770680B0770680B0770680B0770680B0770680B0770680B0
            770680B0770680B0770680B0770680B0770680B0770680B0770580B0790670B3
            7D100BA1741B0000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000}
        end
        object btnComplications: TBitBtn
          Left = 5
          Top = 334
          Width = 161
          Height = 30
          Anchors = [akLeft, akBottom]
          Caption = 'Enter/Edit &Complications'
          TabOrder = 6
          OnClick = btnComplicationsClick
          Glyph.Data = {
            F6060000424DF606000000000000360000002800000018000000180000000100
            180000000000C0060000120B0000120B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFE1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1
            E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1
            E1E1E1E1FF00FFFF00FFFF00FF4C8DD62B6DC32C6DC32C6DC32C6DC32C6DC32C
            6DC32C6DC32C6DC32C6DC32C6DC32C6DC32C6DC32C6DC32C6DC32C6DC32C6DC3
            2C6DC32C6DC32C6DC32B6DC34B8CD5FF00FFFF00FF199DEF25C2FB24BEFA24BF
            FA24BFFA24BFFA24BFFA24BFFA24BFFA24BFFA24BFFA24BFFA24BFFA24BFFA24
            BFFA24BFFA24BFFA24BFFA24BFFA24BEFA25C2FA27A4F0FF00FFFF00FF49A3ED
            0DABF4079FF20497F00497F00497F00497F00497F00497F00397F00096F00096
            F00297F00497F00497F00497F00497F00497F0069CF107A0F20EACF44AA3EDFF
            00FFFF00FF46C6F81A9BEE0FB0F50DABF40FAEF40FAEF40FAEF40FAEF40EAEF4
            26B5F564D0FF66D1FF2FB8F50EAEF40FAEF40FAEF40FAEF40FAEF40EACF40FB0
            F5179DEE0EACF4FF00FFFF00FFFF00FF4697E812ACF411B1F612B2F612B2F612
            B2F612B2F612B2F628C2FF1D26281D262827C2FF12B2F612B2F612B2F612B2F6
            12B2F611B1F612AEF54195E8FF00FFFF00FFFF00FFFF00FFFF00FF1089E916B4
            F613B2F614B2F614B2F614B2F614B2F610B6FD15749915749910B6FD14B2F614
            B2F614B2F614B2F613B2F616B5F60F8DE9FF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FF1AA2F01AA2F016B5F615B4F615B4F615B4F614B4F62BBAF565D4FF65D4
            FF2ABAF514B4F615B4F615B4F615B4F616B5F61DA6F11DA6F1FF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FF36A1ED21B6F517B5F617B5F617B5F617B5F6
            33C6FF323B38343C393BC9FF16B5F617B5F617B5F616B5F626B8F62EA0EEFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF33AFF233AFF21EB9F819
            B6F719B6F719B6F71FC1FF3547473547471FC1FF19B6F719B7F718B6F722BAF8
            33B2F333B2F3FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FF2D96EB46C6F817B7F71BB8F71BB8F718C0FF384B4A384B4A18C0FF1BB8F71B
            B8F719B7F74AC9F92D9AECFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FF46C6F8239EEE34C1F81DB8F71DB8F71BBFFF3E514D3E51
            4D1BBFFF1DB8F71DB8F73AC3F925A3EFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF67B7F240BBF522BBF71FBAF7
            1DC1FF4356504356501CC1FF1FBAF723BBF748BFF65CB4F1FF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF41
            AFF234C0F920BBF81EC2FF485B54485B541EC2FF1FBAF840C4F939AFF2FF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FF84C6F46ECDF822BCF820C2FF4D60584D605820C2FF26BDF877
            D3F97EC5F5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF35A9F06CD6FB1BBAFF434C44434C
            441CBBFF79DAFC31AAF1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF45B8F345B8F3
            46C9FA249FD9239ED850CCFA48BCF448BCF4FF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FF42B0F166CFF92BC1FA2CC2FA70D4FA38ADF0FF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF58C0F53CC6F949CAFA5DC2F5FF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF70C5F5CFEEFCD9F1
            FD67C3F5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FF4ABBF448BCF4FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FF80CBF676C7F6FF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        end
        object btnNewINR: TBitBtn
          Left = 387
          Top = 298
          Width = 161
          Height = 30
          Anchors = [akRight, akBottom]
          Caption = '&New INR'
          TabOrder = 7
          OnClick = btnNewINRClick
          Glyph.Data = {
            F6060000424DF606000000000000360000002800000018000000180000000100
            180000000000C0060000130B0000130B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FF13007C13007C13007C13007C13007C13007C13007C13
            007CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FF1B099113008D13008D13008D13008D1300
            8D13008D13008D13008C2F1E9BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF13009D13009C13009C13009C
            13009C13009C13009C13009C13009C13009C13009C1A08A1FF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1400A61400A614
            00A61400A61400A61400A61200A61300A61400A61400A61400A61400A61400A6
            1400A6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FF1500AF1500AF1500AE1500AE1500AE1907AE574CB74A3DB61100AE1500AF15
            00AE1500AE1500AF1B07B1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FF1600B71600B71600B71600B71600B71400B76054C3D4D4D7C9C7
            D63C2CBE1500B71600B71600B71600B71600B71600B7FF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FF1700BF1700BF1700BF1700BF1701BF1C06C0
            7A6ED1E5E5E4DCDBE35344CA1C06C01600BF1700BF1700BF1700BF1700BFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1700C71700C71700C817
            01C57A71D1A8A3DDC8C5E6EEEDEDEAE9ECBBB7E3A6A1DD594DCF1200C71700C8
            1700C71700C7FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1900
            D11900D01800D03524CBDFDEE8F1F1F0F3F3F2F3F3F3F3F3F3F3F3F2F0F0EECF
            CEE40F00CA1900D01900D01A01D6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FF1A01D61A01D61A01D61600D1ACA6E0E1E0F2EBEAF5F8F8F8F6F6
            F7E7E5F3E3E1F1786FD81300D51A01D61A01D61A01D6FF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FF1A01D61D06D81D06D71D06D81500D5210AD5
            8479E5FBFBFAF0EFF85B4CDF1E08D61600D71E06D81D06D81E07D81D06D7FF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF2813DA210BD921
            0BD9210BD91F08D9766AE1FDFDFBF4F3F94A39D9200AD9210BD9210BD9210BD9
            301ADCFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FF1D06D72712DB2712DB2712DB2712DB2613D67E77D6665BD2200AD92712DB27
            12DB2712DB2712DB2712DBFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FF311DDF2C19DD2C18DE2C18DD2C18DE2511DE2713
            DE2C19DE2C18DD2C18DE2C18DE2C18DEFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF3827E23120E03120E03120E0
            3120E03120E03120E03120E03120E03120E03B2AE13B2AE1FF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF38
            27E23827E23827E23827E23827E23827E23827E23827E23A2AE23827E2FF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FF3827E23E30E53D2FE53D30E53D30E53D30E53E2FE53E
            2FE5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF3827E24438E84438E84438
            E84438E84438E8FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            3827E24B41EA4B41EB4B41EBFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FF615AF0615AF0FF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        end
        object btnEditDailyDose: TBitBtn
          Left = 386
          Top = 334
          Width = 161
          Height = 30
          Hint = 'Click to change daily dosing pattern'
          Anchors = [akRight, akBottom]
          Caption = 'Change &Daily Dosing'
          TabOrder = 2
          OnClick = btnEditDailyDoseClick
          Glyph.Data = {
            F6060000424DF606000000000000360000002800000018000000180000000100
            180000000000C0060000130B0000130B00000000000000000000D8E9EDD8E9ED
            D8E9EDD8E9EDD8E9EDD8E9EDD7E8ECCEDFE3CDDDE1D5E6EAD8E9EDD8E9EDD8E9
            EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8
            E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD7E8ECAFBBBE99ADB5BCC9CB
            CBDADDD5E5E9D8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9
            EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDB5
            CBD469605C4D677A96A9B2BCC8CACCDBDFD7E8ECD8E9EDD8E9EDD8E9EDD8E9ED
            D8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD8E9EDD7E7EBD6E7EBD6E7EBD6E7
            EBD6E7EBD6E7EBDCEBEE5E7C916A8C9D51A2D65A829F9FAFB5C8D7DAD6E6EAD6
            E7EBD6E7EBD6E7EBD6E7EBD6E7EBD6E7EBD7E8ECD8E9EDD8E9EDCEDFE3B7CAD3
            AFC1CCAFC1CCAFC1CCAFC1CCAFC1CCB1C2CC97B2C479C1F0C3F0FF59AEEE277E
            C595A2A9AFC0CBAFC1CCAFC1CCAFC1CCAFC1CCAFC1CCB1C3CDC2D4DBD5E6EAD8
            E9EDC4CFCBAF862FAF7B0FAF7A0EAF7A0EAF7A0EAF7A0EB27A0CBD7B03737750
            C6EAFD6CC3FF0B94FF2581D1C3891DB47D0FAF7B0FAF7A0EAF7A0EAF7A0EB07B
            10B3A06CD1E3EBD8E9EDC3C8BCD8BD7FF7FFFFF5FDFFF5FDFFF5FDFFF5FDFFF5
            FDFFF7FDFFEBF0FC3397DCD1F5FF66BEFF0F9CFF1168BBF8FDFFFEFFFFF6FDFF
            F5FDFFF5FDFFFEFFFFB58015CFE4EFD8E9EDC2C8BCD5B778ECEEF2EBE9E9EBEA
            EAEBE9EAEBEAEAEBEAEAEBE9E9F2EDEACBD0DC3493D8C0F6FF71C2FE0F9BFF1D
            74BED8D6D6F2EDEAE8E7E7E9E7E8F6FFFFB47F14CFE4EFD8E9EDC2C8BCD5B678
            EBEDEFEDEBEAF6F5F4ECEBE9F3F2F1F3F2F1EBEAE9EAE8E8FFFFFDF2F5FA1575
            C8C0F6FF66BEFF0A93FF1C73BBF3F4F5FCFBFCF0EFEFF6FEFFB47F13CFE4EFD8
            E9EDC2C8BCD5B779E9EAEDDAD9D96B6A6AEBEAEA919091919090DFDEDEE6E5E5
            F5F4F4FEFFFFF2F6FB3393D8D2F5FF66BEFF0F9BFF08599EF4F4F5EFEAE8F6FF
            FFB47F13CFE4EFD8E9EDC2C8BCD5B779E6E8EBDFDEDEADACACBAB9B9C4C3C3D6
            D5D5E0DFDFE1E0E1EAEAE8FFFFFFFFFFFFCFDDEF3394D9C0F6FF71C2FE0F9BFF
            1B73BBD0CDCDFEFFFFB48014CFE4EFD8E9EDC2C8BCD6B879E4E4E8E3E0E0D7D5
            D5DCDADADCDADADEDCDDE2E0E0DFDDDDE4E3E1FFFFFFFFFFFFFFFFFFF6FAFF1C
            7DD0C1F6FF66BEFF0993FF1476C6F2FDFFB78216D0E4F0D8E9EDC2C8BCD6B879
            E1E3E6DFDEDDDFDFDDDFDEDDDFDEDDDFDEDDDFDEDCDCDBDAB2B2B3B1B2B2B1B1
            B1B2B2B1B7B5B3BFB9B83A9ADED2F6FF60C1FF528AB069686EBE8F26C3D7E1D7
            E8ECC2C8BCD6B879DFE0E3DCDBDADCDBDADCDBDADCDBDADCDBDADCDBDADCDBDA
            DCDBDADCDBD9DCDBD9DCDBD9DCDBD9E3DED9BBC1CD2E96DDD9D7CEC6B9B08D8B
            8C6F7A7EA9A7C5CADBDEC2C8BCD7B87ADDDEE1DDDCDAE7E5E4E4E2E1DDDBDAE4
            E2E1DDDBD9DCDAD9FBFBFCFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFFFCFAE9F3FE
            9E9791ECEBEA8D9788C389C2A772C0C2CCDAC2C8BCD7B87ADCDBDECCCAC96B6A
            698A8988DBD9D8828280D1D0CFD7D5D4F4F3F3FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFF9F9F991918CD9A2D9D09ACDB17EC6CDD8E5C2C8BCD7BA7A
            D8DADDD2D0D0A2A0A0B5B3B4AEACACB0AEAFD4D2D2D3D2D1E7E6E6FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFBFACFC2D4CC93D9C697E7C6CBDFD9
            EBEDC2C8BCD7BA7AD5D7DAD3D2D1C9C8C7CECDCCCDCDCCCBCBC9D3D2D1D0CFCE
            DFDDDCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFBFBC1C2BDF1F3
            FFB68324D0E4EED8E9EDC2C8BCD8BA7BD2D3D6D0CECDD1CECDD0CECDD0CDCCD0
            CDCDD0CECDCDCAC9A1A1A2A0A0A0A09F9FA09F9FA09F9FA09F9FA09F9FA0A0A0
            A2A1A1B8B7B7F6FFFFB48013CFE4EFD8E9EDC2C8BCD6BA7BE2E9F5E0E5EFE0E5
            EFE0E5EFE0E5EFE0E5EFE0E5EFE1E6F0E4EBF3E4EAF3E4EBF3E4EBF3E4EBF3E4
            EBF3E4EBF3E4EBF3E4EAF3E0E5F0F6FFFFB48015CFE4EFD8E9EDC2C9BED8B066
            E9BC77E6B66CE6B76CE6B76CE6B76CE6B76CE6B76CE6B76CE6B76CE6B76CE6B7
            6CE6B76CE6B76CE6B76CE6B76CE6B76CE6B76CE5B364FBE7C9B4831CCFE4EFD8
            E9EDC3C9BED6AD60DBA343D89E38D89D39D89D39D89D39D89D39D89D39D89D39
            D89D39D89D39D89D39D89D39D89D39D89D39D89D39D89D39D89D39D6982DF4D9
            AFB48520CFE4EFD8E9EDC6CDC2D5A856E4B568E2B261E2B261E2B261E2B261E2
            B261E2B261E2B261E2B261E2B261E2B261E2B261E2B261E2B261E2B261E2B261
            E2B261E0AE5AF4D7A9B58521D1E6F1D8E9EDD1DCD6BE9032BE8C27BE8B27BE8B
            27BE8B27BE8B27BE8B27BE8B27BE8B27BE8B27BE8B27BE8B27BE8B27BE8B27BE
            8B27BE8B27BE8B27BE8B27BE8B27BE8B24C1A665D7EBF4D8E9ED}
        end
        object btnMissedAppt: TBitBtn
          Left = 5
          Top = 298
          Width = 161
          Height = 30
          Hint = 'Click to record missed appointment'
          Caption = 'Flag as &Missed Appt'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 8
          OnClick = btnMissedApptClick
          Glyph.Data = {
            42090000424D4209000000000000420000002800000018000000180000000100
            20000300000000090000130B0000130B00000000000000000000000000FF0000
            FF0000FF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
            00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
            00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
            00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF
            00FFFFFF00FFFFFF00FFFFFF00FFFFAC5EE6FF88A7D4FF88A7D4FF88A7D4FF88
            A7D4FF88A7D4FF88A7D4FF88A7D4FF88A7D4FF88A7D4FF88A7D4FF88A7D4FFAC
            5EE6FFFF00FFFF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF89
            89D5FF8989D5FF8989D5FF8989D5FF1A4D71FF126894FF0D4D6FFF0D4D6FFF0D
            4D6FFF0D4D6FFF0D4D6FFF0D4D6FFF0D4D6FFF0D4D6FFF0D4D6FFF0E4E6FFF1B
            4B6DFF8989D5FF8989D5FFF0F0F0FFECECECFFEBEBEBFFE9E9E9FFE8E7E8FFE6
            E6E6FFE5E5E5FFE4E4E3FFE2E2E2FF316888FF0B94D8FF0BA5F2FF0BA6F2FF0B
            A6F2FF1BADF4FF237FADFF1CADF4FF0BA6F2FF0BA6F2FF0BA6F2FF0C9AE0FF21
            516DFF8989D5FF8989D5FFF1F1F2FFEEEDEDFFC6C6CAFFC6C6CAFFC6C6CAFFC6
            C6CAFFC6C6CAFFC6C6CAFFC6C6CAFF97B9D4FF124E6FFF11B0F5FF12B1F5FF12
            B1F5FF19A4DEFF07171DFF19A4DEFF12B1F5FF12B1F5FF11B0F5FF176A96FF98
            BED8FF8989D5FF8989D5FFF3F2F2FFEEEEEEFFC6C6CAFFEBEBECFFEAEAEAFFC6
            C6CAFFE8E7E8FFE6E5E6FFC6C6CAFFDBE0E4FF70B9E7FF0C5171FF15B3F5FF14
            B3F6FF19A4DEFF3D92B2FF19A4DEFF14B3F6FF14B3F6FF0C5272FF69B4DFFFC8
            CED1FF8989D5FF8989D5FFF4F4F3FFEFEFEFFFC6C6CAFFEDEDECFFEBEBEBFFC6
            C6CAFFE8E9E8FFE7E7E7FFC6C6CAFFE4E4E3FFB6D5E5FF195270FF1FB6F5FF18
            B5F6FF3D92B2FF091113FF3D92B2FF17B5F6FF1FB7F6FF195371FFADCBDCFFD1
            D1D1FF8989D5FF8989D5FFF5F4F5FFF0F1F0FFC6C6CAFFC6C6CAFFC6C6CAFFC6
            C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFF73B8E0FF155573FF1D
            B8F7FF3D92B2FF0A1314FF3D92B2FF1EB8F7FF1A5572FF89B9D9FFC6C6CAFFD2
            D3D2FF8989D5FF8989D5FFF6F5F6FFF1F1F1FFC6C6CAFFEEEEEFFFEDEDEDFFC6
            C6CAFFEBEBEAFFE9E9E9FFC6C6CAFFE6E6E6FFE5E5E5FFABC4D4FF345B70FF29
            BAF6FF3D92B2FF0A1314FF3D92B2FF2DBBF6FF315A6FFFC9D3DBFFC6C6CAFFD3
            D3D3FF8989D5FF8989D5FFF7F7F7FFF3F3F3FFC6C6CAFFF0F0F0FFEFEEEEFFC6
            C6CAFFEBECECFFEAEAEAFFC6C6CAFFE8E7E7FFE6E6E6FFC6C6CAFFB4D5E9FF20
            5974FF3D92B2FF040808FF3D92B2FF215A74FFACD0E3FFD9D9D9FFC6C6CAFFD4
            D4D4FF8989D5FF8989D5FFF8F8F8FFF4F4F4FFC6C6CAFFC6C6CAFFC6C6CAFF27
            07B3FF2707B3FF2707B3FF2707B3FFC6C6CAFFC6C6CAFFC6C6CAFFBAC4CCFF32
            596DFF19A4DEFF040E11FF19A4DEFF335A6DFFBAC4CDFFC6C6CAFFC6C6CAFFD5
            D6D5FF8989D5FF8989D5FFF9F9F9FFF4F4F5FFC6C6CAFFF2F2F2FFF1F1F0FF27
            07B3FF0000FFFF0000FFFF2707B3FFE9E9EAFFE8E8E8FFC6C6CAFFE5E5E6FFAE
            D3E8FF2A5B71FF3FC0F4FF2C5D72FF98BFD6FFDDDDDCFFDBDCDBFFC6C6CAFFD7
            D6D7FF8989D5FF8989D5FFFAFAFAFFF6F6F5FFC6C6CAFFF3F3F3FFF2F2F2FF27
            07B3FF0000FFFF0000FFFF2707B3FFEAEBEBFFE9E9E9FFC6C6CAFFE6E6E6FFE5
            E5E5FF4E5F69FF82D3F7FF55666FFFC6C6CAFFDEDDDDFFDDDCDDFFC6C6CAFFD8
            D7D8FF8989D5FF8989D5FFFCFBFBFFF7F7F7FFC6C6CAFFC6C6CAFFC6C6CAFF27
            07B3FF2707B3FF2707B3FF2707B3FFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6
            C6CAFFB3C5D2FF3F5D6EFFB2C5D2FFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFD9
            D9D9FF8989D5FF8989D5FFFDFCFDFFF8F7F8FFF5F6F6FFF5F5F5FFF4F4F4FFC6
            C6CAFFF0F1F1FFF0F0F0FFC6C6CAFFECECEDFFEBEBEBFFC6C6CAFFE9E8E9FFE7
            E7E7FFC6C6CAFFE5E4E4FFE3E3E2FFC6C6CAFFE0E0E0FFDFDFDFFFC6C6CAFFDA
            DADAFF8989D5FF8989D5FFFEFDFDFFF9F9F9FFF9F9F9FFF7F6F6FFF4F5F5FFC6
            C6CAFFF2F2F2FFF0F0F1FFC6C6CAFFEEEEEDFFECEDEDFFC6C6CAFFE9EAEAFFE8
            E8E9FFC6C6CAFFE5E6E5FFE4E4E4FFC6C6CAFFE2E1E1FFE0E0E0FFC6C6CAFFDC
            DBDCFF8989D5FF8989D5FFFFFFFFFFFAFAFAFFFBFBFBFFF9F9F9FFF5F6F6FFC6
            C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6
            C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFC6C6CAFFDC
            DDDCFF8989D5FF8989D5FFFFFFFFFFFBFBFBFFFAFAFAFFF8F8F8FFF7F7F7FFF5
            F6F6FFF4F5F4FFF3F3F3FFF2F1F2FFF0F0F0FFEEEFEFFFEEEDEEFFECECECFFEA
            EAEAFFE9E9E9FFE7E8E8FFE6E6E6FFE5E5E5FFE4E3E4FFE2E2E2FFE0E0E0FFDD
            DEDDFF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF89
            89D5FF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF89
            89D5FF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF8989D5FF89
            89D5FF8989D5FF8989D5FF2D1296FF2D1296FF2D1296FF2D1296FF2D1296FF2D
            1296FF2D1296FF2D1296FF2D1296FF2D1296FF2D1296FF2D1296FF2D1296FF2D
            1296FF2D1296FF2D1296FF2D1296FF2D1296FF2D1296FF4F38A7FF311698FF2D
            1296FF8989D5FF2D1296FF2D1296FFA094CFFF705EB7FF2D1296FF2D1296FF2D
            1296FF2D1296FF2D1296FF2D1296FF2D1296FF2D1296FF2D1296FF2D1296FF2D
            1296FF2D1296FF2D1296FF2D1296FF2D1296FF4F38A7FFCAC3E4FF7765BAFF31
            1698FF2D1296FF2D1296FF9E90DDFFF9F8FDFFE9E5F7FF6C57CBFF2707B3FF27
            07B3FF2707B3FF2707B3FF2707B3FF2707B3FF2707B3FF2707B3FF2707B3FF27
            07B3FF2707B3FF2707B3FF2707B3FF2707B3FF9A8BDBFFF6F5FCFFC9C1ECFF4A
            2FBFFF2D1296FF2D1296FF2707B3FFA79ADDFF7A67CBFF3B20B3FF3B20B3FF3B
            20B3FF3B20B3FF3B20B3FF3B20B3FF3B20B3FF3B20B3FF3B20B3FF3B20B3FF3B
            20B3FF3B20B3FF3B20B3FF3B20B3FF3B20B3FF3B20B3FFA396DBFF5A44BFFF3B
            20B3FF2D1296FFFF00FFFF452CB3FF452CB3FF452CB3FF452CB3FF452CB3FF45
            2CB3FF452CB3FF452CB3FF452CB3FF452CB3FF452CB3FF452CB3FF452CB3FF45
            2CB3FF452CB3FF452CB3FF452CB3FF452CB3FF452CB3FF452CB3FF452CB3FF45
            2CB3FFFF00FF}
        end
        object dtpMissedAppt: TDateTimePicker
          Left = 191
          Top = 318
          Width = 101
          Height = 21
          Date = 37820.584724004600000000
          Time = 37820.584724004600000000
          TabOrder = 9
          Visible = False
          OnChange = dtpMissedApptChange
        end
      end
    end
    object tsExit: TTabSheet
      HelpKeyword = 'Exit'
      HelpContext = 1400
      Caption = 'Exit'
      ImageIndex = 3
      OnShow = tsExitShow
      object pnlNoDraw: TPanel
        Left = 384
        Top = 2
        Width = 185
        Height = 41
        BevelOuter = bvNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clPurple
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        Visible = False
        object lblNoDraw: TLabel
          Left = 16
          Top = 22
          Width = 5
          Height = 13
        end
      end
      object pnlTabExit: TPanel
        Left = 0
        Top = 0
        Width = 726
        Height = 368
        Align = alClient
        Color = clCream
        ParentBackground = False
        TabOrder = 1
        DesignSize = (
          726
          368)
        object lblDrawRestr: TLabel
          Left = 316
          Top = 32
          Width = 84
          Height = 13
          Caption = 'Do NOT draw on:'
        end
        object gbxReturnForINR: TGroupBox
          Left = 11
          Top = 24
          Width = 287
          Height = 64
          Caption = 'Return for INR Draw'
          Color = clBtnFace
          Constraints.MaxHeight = 79
          Constraints.MinHeight = 64
          Constraints.MinWidth = 220
          ParentBackground = False
          ParentColor = False
          TabOrder = 0
          object lblPlus14: TLabel
            Left = 6
            Top = 18
            Width = 46
            Height = 13
            Caption = '+ &14 days'
          end
          object lblPlus28: TLabel
            Left = 6
            Top = 42
            Width = 46
            Height = 13
            Caption = '+ &28 days'
          end
          object dtpNextApp: TDateTimePicker
            Left = 107
            Top = 13
            Width = 100
            Height = 21
            Hint = 'Enter next appointment date'
            Date = 0.549411851898185000
            Time = 0.549411851898185000
            TabOrder = 2
            OnChange = dtpNextApptChange
            OnExit = dtpNextAppExit
          end
          object ckbPlusDay: TCheckBox
            Left = 110
            Top = 40
            Width = 103
            Height = 17
            Hint = 
              'Patient will be on the team list for the day following the draw ' +
              'date.'
            Alignment = taLeftJustify
            Caption = 'Next day callback'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnClick = ckbPlusDayClick
          end
          object btnPlus14: TButton
            Tag = 14
            Left = 64
            Top = 17
            Width = 14
            Height = 14
            TabOrder = 0
            OnClick = btnPlusXClick
          end
          object btnPlus28: TButton
            Tag = 28
            Left = 64
            Top = 41
            Width = 14
            Height = 14
            TabOrder = 1
            OnClick = btnPlusXClick
          end
          object dtpAppTime: TDateTimePicker
            Left = 213
            Top = 13
            Width = 60
            Height = 21
            Date = 39945.333333333340000000
            Format = 'HH:mm '
            Time = 39945.333333333340000000
            DateMode = dmUpDown
            Enabled = False
            Kind = dtkTime
            TabOrder = 3
            Visible = False
            OnChange = dtpAppTimeChange
          end
        end
        object gbxLabs: TGroupBox
          Left = 11
          Top = 193
          Width = 185
          Height = 134
          Caption = 'Labs'
          Color = clBtnFace
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          object ckbINROrder: TCheckBox
            Left = 8
            Top = 28
            Width = 169
            Height = 17
            Caption = 'Order Local &INR draw'
            TabOrder = 0
            OnClick = ckbINROrderClick
          end
          object ckbCBCOrder: TCheckBox
            Left = 8
            Top = 52
            Width = 161
            Height = 17
            Caption = 'Order Local C&BC'
            TabOrder = 1
            OnClick = ckbCBCOrderClick
          end
        end
        object gbxPCE: TGroupBox
          Left = 202
          Top = 193
          Width = 341
          Height = 134
          Caption = 'PCE Data'
          Color = clBtnFace
          ParentBackground = False
          ParentColor = False
          TabOrder = 2
          object lblPhoneVisit: TLabel
            Left = 33
            Top = 34
            Width = 34
            Height = 13
            Caption = 'Phone:'
          end
          object lblLettVisit: TLabel
            Left = 37
            Top = 93
            Width = 30
            Height = 13
            Caption = 'Letter:'
          end
          object lblICDPrim: TLabel
            Left = 75
            Top = 13
            Width = 86
            Height = 13
            Caption = 'Primary ICD-Code:'
          end
          object lblVisit: TLabel
            Left = 45
            Top = 56
            Width = 22
            Height = 13
            Caption = 'Visit:'
          end
          object ckbPCENone: TCheckBox
            Left = 12
            Top = 112
            Width = 165
            Height = 17
            Caption = 'Do not file data for this visit'
            TabOrder = 10
            OnClick = ckbPCENoneClick
          end
          object ckbCBOC: TCheckBox
            Left = 201
            Top = 92
            Width = 125
            Height = 17
            Caption = 'CBOC lab scheduled'
            TabOrder = 9
            Visible = False
          end
          object edtICDCode: TEdit
            Left = 171
            Top = 10
            Width = 93
            Height = 21
            TabOrder = 0
            OnChange = edtICDCodeChange
          end
          object rbPhoneS: TRadioButton
            Left = 74
            Top = 33
            Width = 53
            Height = 17
            Caption = '&simple'
            TabOrder = 1
            TabStop = True
            OnClick = rbPhoneSClick
          end
          object rbPhoneC: TRadioButton
            Left = 201
            Top = 33
            Width = 65
            Height = 17
            Caption = 'co&mplex'
            TabOrder = 2
            OnClick = rbPhoneCClick
          end
          object rbOVisit: TRadioButton
            Left = 74
            Top = 55
            Width = 73
            Height = 17
            Caption = 'i&nitial office'
            TabOrder = 3
            OnClick = rbOVisitClick
          end
          object rbPharm: TRadioButton
            Left = 74
            Top = 92
            Width = 113
            Height = 17
            BiDiMode = bdLeftToRight
            Caption = 'inpatient p&harmacy'
            ParentBiDiMode = False
            TabOrder = 8
            Visible = False
          end
          object rbOclass: TRadioButton
            Left = 74
            Top = 73
            Width = 103
            Height = 17
            Caption = '&orientation class'
            TabOrder = 5
            OnClick = rbOclassClick
          end
          object rbSoffice: TRadioButton
            Left = 201
            Top = 55
            Width = 113
            Height = 17
            Caption = 'subse&quent office'
            TabOrder = 4
            OnClick = rbSofficeClick
          end
          object ckbAddt: TCheckBox
            Left = 201
            Top = 73
            Width = 125
            Height = 17
            Caption = 'additional time'
            TabOrder = 6
            Visible = False
          end
          object rbLetter: TRadioButton
            Left = 74
            Top = 92
            Width = 71
            Height = 17
            Caption = '&letter sent'
            TabOrder = 7
            OnClick = rbLetterClick
          end
        end
        object btnTempSave: TButton
          Left = 233
          Top = 333
          Width = 143
          Height = 30
          Hint = 
            'Temporarily saves patient information.  Can be updated, amended,' +
            ' or permanently saved (completed) next time it is accessed'
          Caption = '&Temp Save and Exit'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = btnTempSaveClick
        end
        object btnCompleteVisit: TBitBtn
          Left = 554
          Top = 333
          Width = 160
          Height = 30
          Hint = 'Click to complete the current visit'
          Anchors = [akRight, akBottom]
          Caption = '  &Complete Visit and Exit'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = btnCompleteVisitClick
          Glyph.Data = {
            F6060000424DF606000000000000360000002800000018000000180000000100
            180000000000C0060000130B0000130B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FF39B13A71BD75FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FF9A5029884E258F5E1D95641F836C4C7E78757F7A76
            857D7D6E776A279D2423F40522DD0E4497468C847D9E745EA16F55A16F55A16F
            55FF00FFFF00FFFF00FFFF00FFFF00FFC4805BB5511AAA5615C67B0ACF830BA8
            8C609E9FA29F9FA289978F30A83122F60322FE0022FD0122DD0E458F3BA45023
            B04E19B04E18B36842DCA886FF00FFFF00FFFF00FFFF00FFC7835EB9551CAA55
            15BD7504C77D03AF9261B2B2B59FABA238A93920EE0621F80321F80321F80321
            F7041BD6125D7A25B2521BB35019BC6333DCA886FF00FFFF00FFFF00FFFF00FF
            CC8862BD591FAA5516B56C01BF7300B8996DABBAB13AAD3D1AE0091EF1071EF1
            071BD6131CDF0F1EF4061FEF0818D0165B6D2CB2551CC06634DCA886FF00FFFF
            00FFFF00FFFF00FFD08D65C25D23AC5618AF6101B86800C6A17A67A47216B914
            1BEC0A1BEA0A1DC21A597D1F4285251BC5171BEC0A1BE70B1EBE1C5F6D2AC169
            35DCA886FF00FFFF00FFFF00FFFF00FFD4916AC66226AD561BA65401AF5900C1
            9D76F7F3F873B17B1CC01B19BE194D9050A66B28A5580B4C9F5A1AC41819DF0F
            19DF1016B021717A33DCA886FF00FFFF00FFFF00FFFF00FFD7956CCC6629BA5E
            249D4C109C4B0BB68D6DE2DDD9E5DDDC7FBA8462A870E4E6E1C8B2A0C2A993DC
            DCD65AAA6518BF1C15D91316D61516AA2370955FFF00FFFF00FFFF00FFFF00FF
            DB976ED06B2CD06C2FCC6A2DCA682DC56B34C1703FBE6F3FBA6F3EB77040BD72
            45BD7345BC7246BC7144B96D3942822E16B72113D01713CD181BAA2586B98EFE
            FFFEFF00FFFF00FFDE9B71D57031D47132D67538D67A40D6793FD6793ED6783E
            D5763CD57438D47438D37338D37337D27237D27136D3703644883613B32111C5
            1C11C51C1BA028A1CCA7FF00FFFF00FFE09E75D97535D8702EEBB898FAEBE2F9
            E9DEF9E9DEF8E8DEF6E1D3F3D8C7F4D8C7F4D8C6F4D8C6F3D8C6F3D8C7F3D8C7
            E6CCB552934313AF230FC11E11BB20218C2FFF00FFFF00FFE09D75DE7A38DC72
            2EF3D5C2FDFFFFFDFDFDFDFDFDFDFDFDFDFDFEFDFEFEFDFEFEFDFEFEFDFEFEFD
            FEFEFDFEFEFDFEFEFCF7F5D7986940853113A9251A9C2AA3CEA9FF00FFFF00FF
            E1A075E17C3BDF7630F2D5C2F9FAFBF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9
            F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F3F1E4996ADC7D40428C418DC195FF
            00FFFF00FFFF00FFE2A177E4803DE37933F2D5C2F8F9FAF8F8F8F8F8F8F8F8F8
            F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F7F4F1E69F71E27F
            40DCA886FF00FFFF00FFFF00FFFF00FFE4A278E6813EE57B34F2D5C3F6F7F7F6
            F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
            F5F1EFE8A173E38240E1A886FF00FFFF00FFFF00FFFF00FFE4A278E6813EE57B
            34EDD6C7EFF0F0EFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
            EFEFEFEFEFEFEFEFEFECEAE8A476E58341E3A986FF00FFFF00FFFF00FFFF00FF
            E4A278E6813EE67B34E7D0C0E7E8E8E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7
            E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E4E2E7A376E78341E4AA85FF00FFFF
            00FFFF00FFFF00FFE4A177E6803CE67B34E0C8B9DEDFDFDEDEDEDEDEDEDEDEDE
            DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDCDAE3A074E781
            3EE6AB84FF00FFFF00FFFF00FFFF00FFE7AC84EC9962E98645DAC7BAD7D8D8D7
            D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7
            D7D5D4E2A781EB955CE8B08CFF00FFFF00FFFF00FFFF00FFE9AE87C18D6CE07E
            40D5C3B7D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1
            D1D1D1D1D1D1D1D1D1CFCEDDAA88CA875FEBB38EFF00FFFF00FFFF00FFFF00FF
            E9B290E19360EA8F54D0C1B7CBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCB
            CBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCAC9DAA784D27D4BEDB593FF00FFFF
            00FFFF00FFFF00FFEED0C0F3D4BEF2CFB9F4EBE5F5F0EDF5F0EEF6F1EFF6F1EF
            F6F1EFF6F1EFF4EEECF4EFECF5EFECF6F1EFF6F1EFF6F1EFF6F1EEF3D6C4F2C8
            ABF3D8C7FF00FFFF00FFFF00FFFF00FFEBDCD4E9D4C9E9D4CAE9D2C6E9D2C6EA
            D3C7ECDAD0EDDAD1EDDAD1ECD8CFE5CEC2E5CDC2E7D0C4EEDACEEED9CDEED9CD
            EED9CDECD5C9EAD3C6F3E6DFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        end
        object btnRemind: TBitBtn
          Left = 8
          Top = 333
          Width = 219
          Height = 30
          Caption = 'Set Popup &Reminder for Next Time'
          TabOrder = 5
          OnClick = btnRemindClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3830EFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEAE9FDF2F1FEFFFFFFFFFFFFFE
            FFFF3830EFFFFFFFFFFFFFFFFFFFEFEEFEF3F2FEFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFF1F0FE4E48F17DBDF743FAF513F9F13830EF19F9F255FBF68FBDF75750
            F2FCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCFEFD3A5FF03830EF2F79F020
            EDF31EFAF320EDF32E7AF03830EF4678F2F2FFFEFFFFFFFFFFFFFFFFFFFFFFFF
            E9FEFE46FAF53599F23830EF3830EF3745F0359FF23745F03830EF3830EF33B2
            F264FBF7FBFFFF473FF03830EFFFFFFF81FCF847FBF544D4F43830EF3830EF38
            30EF3830EF3830EF3830EF3832EF44ECF53830EF3830EFACA8F8C6C4FA615FF2
            3830EF5CFBF65BFAF63C45F03830EF3830EF3830EF3830EF3830EF405EF15AFB
            F63830EF70FCF7FFFFFFFFFFFFCEFEFC70FCF770FCF759A8F43934EF3830EF38
            30EF3830EF3830EF3830EF3A38EF5CB8F46EFCF76DFCF7F0FFFEFFFFFFCEFEFC
            83F8F85482F23830EF3830EF3830EF3830EF3830EF3830EF3830EF3830EF3932
            EF5897F381FBF8ECFFFEFFFFFFD2EDFC4B61F13830EF3830EF3830EF3830EF38
            30EF3830EF3830EF3830EF3830EF3830EF3830EF5977F2F3F9FFFFFFFFBCBCFA
            5E7AF3474FF04048F0424EF04046F03830EF3830EF3830EF4147F0444FF0434A
            F04857F181A1F6CFCDFBFFFFFFFFFFFFDDFEFDADFDFA88FCF87FFBF765B3F438
            30EF3830EF3831EF77DBF575CFF4A1FCF9B2FCFAECFEFEFFFFFFFFFFFFFFFFFF
            FEFFFFDEFEFE3830EF3830EF97F6F74041F03830EF4E61F096FAF7BCFDFA3830
            EFE6FEFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3830EF3830EFDFFDFDDFFDFD6C
            6DF33830EF888EF6E7FEFEE8FEFEF3FFFE3830EFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF3830EFFFFFFFFEFFFFFBFFFFE5E7FD524CF1F7FCFFFBFFFFFEFFFFFFFF
            FFFFFFFF3830EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFD7D6FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
        object gbxNoteGiven: TGroupBox
          Left = 11
          Top = 105
          Width = 287
          Height = 72
          Caption = 'Note Given'
          Color = clBtnFace
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentBackground = False
          ParentColor = False
          ParentFont = False
          TabOrder = 6
          object radNoCopyGiven: TRadioButton
            Left = 16
            Top = 16
            Width = 197
            Height = 17
            Caption = 'No copy of note given.'
            TabOrder = 0
            OnClick = radNoCopyGivenClick
          end
          object radCopyGiven: TRadioButton
            Left = 16
            Top = 39
            Width = 197
            Height = 17
            Caption = 'Copy of note given to patient.'
            TabOrder = 1
            OnClick = radCopyGivenClick
          end
        end
      end
    end
    object tsSTAT: TTabSheet
      HelpKeyword = 'Utilities'
      HelpContext = 1500
      Caption = 'Utilities'
      ImageIndex = 5
      object pnlTabUtilities: TPanel
        Left = 0
        Top = 0
        Width = 726
        Height = 368
        Align = alClient
        Color = clCream
        ParentBackground = False
        TabOrder = 0
        object lblDays: TLabel
          Left = 143
          Top = 8
          Width = 22
          Height = 13
          Caption = 'days'
        end
        object lbl45DayLoad: TLabel
          Left = 20
          Top = 40
          Width = 88
          Height = 13
          Caption = '45 day clinic load: '
        end
        object lblPercentInGoal: TLabel
          Left = 16
          Top = 8
          Width = 92
          Height = 13
          Caption = 'Percent in Goal last'
          OnMouseEnter = lblPercentInGoalMouseEnter
          OnMouseLeave = lblPercentInGoalMouseLeave
        end
        object lblLTFDays: TLabel
          Left = 143
          Top = 72
          Width = 22
          Height = 13
          Caption = 'days'
        end
        object lblLTFQuery: TLabel
          Left = 17
          Top = 72
          Width = 91
          Height = 13
          Caption = 'Pts lost to follow up'
          OnMouseEnter = lblLTFQueryMouseEnter
          OnMouseLeave = lblLTFQueryMouseLeave
        end
        object lblUnlock: TLabel
          Left = 33
          Top = 104
          Width = 75
          Height = 13
          Caption = 'Unlock Record:'
        end
        object btnPctInGoalReport: TButton
          Left = 171
          Top = 3
          Width = 25
          Height = 25
          Caption = '&%'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnPctInGoalReportClick
          OnMouseEnter = btnPctInGoalReportMouseEnter
          OnMouseLeave = btnPctInGoalReportMouseLeave
        end
        object edtXDays: TEdit
          Left = 115
          Top = 5
          Width = 25
          Height = 21
          MaxLength = 3
          TabOrder = 1
          Text = '30'
        end
        object edtLTF: TEdit
          Left = 115
          Top = 69
          Width = 25
          Height = 21
          MaxLength = 3
          TabOrder = 2
          Text = '30'
        end
        object btnTWeek: TButton
          Left = 115
          Top = 35
          Width = 41
          Height = 25
          Caption = '&Find'
          TabOrder = 3
          OnClick = btnTWeekClick
          OnMouseEnter = btnTWeekMouseEnter
          OnMouseLeave = btnTWeekMouseLeave
        end
        object pnlLTF: TPanel
          Left = 212
          Top = 66
          Width = 217
          Height = 57
          Color = clMoneyGreen
          ParentBackground = False
          TabOrder = 4
          Visible = False
          object lblLTF: TLabel
            Left = 20
            Top = 9
            Width = 164
            Height = 39
            Caption = 
              'Displays '#39'active'#39' patients with no flow sheet activity over last' +
              ' n days (defaults to 30).'
            WordWrap = True
          end
        end
        object pnlXPC: TPanel
          Left = 212
          Top = 3
          Width = 217
          Height = 97
          Color = clMoneyGreen
          ParentBackground = False
          TabOrder = 5
          Visible = False
          object lblXPct: TLabel
            Left = 10
            Top = 5
            Width = 204
            Height = 78
            Caption = 
              'This looks for the last patient visit within the specified numbe' +
              'r of DAYS and returns the percentage of patients who were within' +
              ' the goal range on their last visit, as well as the names of the' +
              ' patients who were NOT in the goal, or had no INR at their last ' +
              'visit.'
            Color = clMoneyGreen
            ParentColor = False
            WordWrap = True
          end
        end
        object pnlCount: TPanel
          Left = 212
          Top = 35
          Width = 217
          Height = 65
          Color = clMoneyGreen
          ParentBackground = False
          TabOrder = 6
          Visible = False
          object lblCount: TLabel
            Left = 10
            Top = 6
            Width = 169
            Height = 52
            Caption = 
              'Displays date and number of patients scheduled over the next 45 ' +
              'days.  Missing days have no scheduled patients'
            WordWrap = True
          end
        end
        object btnUnlock: TButton
          Left = 115
          Top = 98
          Width = 50
          Height = 25
          Hint = 'Pick Anticoagulation patient to unlock'
          Caption = 'U&nlock'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnClick = btnUnlockClick
        end
        object btnLost: TButton
          Left = 171
          Top = 67
          Width = 35
          Height = 25
          Caption = '&Lost'
          TabOrder = 8
          OnClick = btnLostClick
          OnMouseEnter = btnLostMouseEnter
          OnMouseLeave = btnLostMouseLeave
        end
      end
    end
  end
  object mnuMain: TMainMenu
    Left = 583
    Top = 60
    object mnuFile: TMenuItem
      Caption = '&File'
      object mnuExit: TMenuItem
        Caption = 'E&xit'
        ShortCut = 32883
        OnClick = mnuExitClick
      end
    end
    object mnuEdit: TMenuItem
      Caption = '&Edit'
      OnClick = mnuEditClick
      object mnuUndo: TMenuItem
        Caption = '&Undo'
        ShortCut = 16474
        OnClick = mnuUndoClick
      end
      object splEdit: TMenuItem
        Caption = '-'
      end
      object mnuCut: TMenuItem
        Caption = 'Cu&t'
        ShortCut = 16472
        OnClick = mnuCutClick
      end
      object mnuCopy: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = mnuCopyClick
      end
      object mnuPaste: TMenuItem
        Caption = '&Paste'
        ShortCut = 16470
        OnClick = mnuPasteClick
      end
    end
    object mnuView: TMenuItem
      Caption = '&View'
      object mnuDemographics: TMenuItem
        Caption = '&Overview'
        ShortCut = 16452
        OnClick = mnuDemographicsClick
      end
      object mnuEnterInformation: TMenuItem
        Caption = '&Enter Information'
        ShortCut = 16453
        OnClick = mnuEnterInformationClick
        object mnuEnterOutsideLab: TMenuItem
          Caption = 'Enter Outside Lab Data'
          ShortCut = 16460
          OnClick = mnuEnterOutsideLabClick
        end
        object Complications1: TMenuItem
          Caption = 'Complications'
          ShortCut = 16463
          OnClick = Complications1Click
        end
      end
      object mnuExitTab: TMenuItem
        Caption = 'Ex&it Tab'
        ShortCut = 16457
        OnClick = mnuExitTabClick
      end
      object mnuUtilities: TMenuItem
        Caption = '&Utilities'
        ShortCut = 16469
        OnClick = mnuUtilitiesClick
      end
      object mnuPtPreferences: TMenuItem
        Caption = '&Pt Preferences'
        ShortCut = 16464
        OnClick = mnuPtPreferencesClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = '&Help'
      object mnuAnticoagulationManagementHelp: TMenuItem
        Caption = '&Contents'
        OnClick = mnuAnticoagulationManagementHelpClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuHelpBroker: TMenuItem
        Caption = '&Last Broker Call'
        Enabled = False
        Visible = False
        OnClick = mnuHelpBrokerClick
      end
      object mnuAbout: TMenuItem
        Caption = '&About Anticoagulation Flowsheet'
        OnClick = mnuAboutClick
      end
    end
  end
  object RPCBrokerV: TRPCBroker
    ClearParameters = True
    ClearResults = True
    Connected = False
    ListenerPort = 9200
    RpcVersion = '0'
    Server = 'BROKERSERVER'
    KernelLogIn = True
    LogIn.Mode = lmAVCodes
    LogIn.PromptDivision = False
    OldConnectionOnly = False
    UseSecureConnection = secureNone
    SSHHide = False
    Left = 585
    Top = 108
  end
end
