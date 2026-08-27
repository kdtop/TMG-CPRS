object frmGMV_UserMain: TfrmGMV_UserMain
  Left = 313
  Top = 147
  Width = 918
  Height = 752
  Caption = 'Vitals'
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = mnMain
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 300
    Top = 52
    Width = 4
    Height = 630
    Cursor = crHSplit
    Color = clSilver
    ParentColor = False
  end
  object sb: TStatusBar
    Left = 0
    Top = 682
    Width = 910
    Height = 24
    Panels = <
      item
        Width = 50
      end
      item
        Alignment = taRightJustify
        Style = psOwnerDraw
        Width = 24
      end
      item
        Width = 150
      end>
    SimplePanel = False
    OnDrawPanel = sbDrawPanel
  end
  object pnlPtSelect: TPanel
    Left = 0
    Top = 52
    Width = 300
    Height = 630
    Align = alLeft
    BevelOuter = bvLowered
    Constraints.MaxWidth = 480
    Constraints.MinWidth = 280
    TabOrder = 1
    OnResize = pnlPtSelectResize
    object pnlGroupActions: TPanel
      Left = 1
      Top = 599
      Width = 298
      Height = 30
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      DesignSize = (
        298
        30)
      object SpeedButton1: TSpeedButton
        Left = 5
        Top = 0
        Width = 287
        Height = 29
        Action = acGroupInput
        Anchors = [akLeft, akTop, akRight]
      end
    end
  end
  object pnlGraph: TPanel
    Left = 304
    Top = 52
    Width = 606
    Height = 630
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    inline fraGMV_GridGraph1: TfraGMV_GridGraph
      Left = 0
      Top = 0
      Width = 606
      Height = 630
      Align = alClient
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      Visible = False
      inherited pnlMain: TPanel
        Width = 606
        Height = 630
        inherited pnlGridGraph: TPanel
          Top = 88
          Width = 606
          Height = 542
          inherited splGridGraph: TSplitter
            Top = 372
            Width = 606
            Height = 4
          end
          inherited pnlGraph: TPanel
            Width = 606
            Height = 372
            inherited pnlDateRange: TPanel
              Width = 109
              Height = 370
              inherited pnlGraphOptions: TPanel
                Top = 270
                Width = 109
                inherited pnlZoom: TPanel
                  Width = 109
                  inherited edZoom: TEdit
                    Width = 25
                  end
                end
              end
              inherited Panel5: TPanel
                Width = 109
                Height = 270
                inherited pnlPTop: TPanel
                  Width = 109
                end
                inherited pnlPRight: TPanel
                  Left = 106
                  Height = 264
                end
                inherited pnlPLeft: TPanel
                  Height = 264
                end
                inherited pnlPBot: TPanel
                  Top = 267
                  Width = 109
                end
                inherited pnlDateRangeTop: TPanel
                  Width = 103
                  Height = 264
                  inherited lbDateRange: TListBox
                    Width = 103
                    Height = 239
                  end
                  inherited Panel6: TPanel
                    Width = 103
                  end
                end
              end
            end
            inherited pnlGraphBackground: TPanel
              Left = 110
              Width = 495
              Height = 370
              inherited Bevel1: TBevel
                Width = 439
                Height = 370
              end
              inherited chrtVitals: TChart
                Width = 439
                Height = 370
              end
              inherited pnlRight: TPanel
                Left = 439
                Height = 370
              end
            end
          end
          inherited pnlGrid: TPanel
            Top = 376
            Width = 606
            Height = 166
            inherited grdVitals: TStringGrid
              Top = 30
              Width = 599
              Height = 133
              Font.Height = -9
            end
            inherited pnlGridTop: TPanel
              Width = 604
              Height = 26
              inherited Panel1: TPanel
                Width = 105
                Height = 26
                DesignSize = (
                  105
                  26)
                inherited cbxGraph: TComboBox
                  Left = 2
                  Top = 2
                  Width = 95
                end
              end
              inherited Panel4: TPanel
                Left = 105
                Width = 499
                Height = 26
                DesignSize = (
                  499
                  26)
                inherited trbHGraph: TTrackBar
                  Width = 476
                end
              end
            end
            inherited pnlGBot: TPanel
              Top = 163
              Width = 604
            end
            inherited pnlGTop: TPanel
              Top = 27
              Width = 604
            end
            inherited pnlGLeft: TPanel
              Top = 30
              Height = 133
            end
            inherited pnlGRight: TPanel
              Left = 603
              Top = 30
              Height = 133
            end
          end
        end
        inherited pnlTitle: TPanel
          Width = 606
          Height = 47
          inherited pnlPtInfo: TPanel
            Height = 47
            TabOrder = 1
            inherited Bevel2: TBevel
              Height = 47
            end
          end
          inherited Panel9: TPanel
            Width = 139
            Height = 47
            TabOrder = 0
            inherited Bevel3: TBevel
              Left = 130
              Height = 47
            end
            inherited pnlDateRangeInfo: TPanel
              Top = 24
              Width = 139
              Height = 23
            end
          end
          inherited pnlActions: TPanel
            Left = 372
            Height = 47
          end
        end
        inherited pnlDebug: TPanel
          Top = 47
          Width = 606
          inherited Panel2: TPanel
            Left = 372
          end
          inherited sbTest: TStatusBar
            Width = 371
          end
        end
      end
      inherited ActionList1: TActionList
        inherited acEnterVitals: TAction
          OnExecute = fraGMV_GridGraph1acEnterVitalsExecute
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 910
    Height = 9
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
  end
  object pnlTop: TPanel
    Left = 0
    Top = 9
    Width = 910
    Height = 43
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    object pnlSpeedButtonDown: TPanel
      Left = 293
      Top = 2
      Width = 443
      Height = 39
      Align = alClient
      BevelOuter = bvNone
      Color = clSilver
      TabOrder = 0
      object pnlCCOWControls: TPanel
        Left = 425
        Top = 0
        Width = 18
        Height = 39
        Align = alRight
        BevelOuter = bvNone
        Color = clSilver
        TabOrder = 0
      end
      object pnlPatientDetails: TPanel
        Left = 0
        Top = 0
        Width = 425
        Height = 39
        Align = alClient
        BevelOuter = bvNone
        Color = clSilver
        TabOrder = 1
        DesignSize = (
          425
          39)
        object lblHospital: TLabel
          Left = 124
          Top = 6
          Width = 301
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'Outpatient'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Label6: TLabel
          Left = 7
          Top = 6
          Width = 104
          Height = 13
          Caption = 'Hospital Location:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label11: TLabel
          Left = 8
          Top = 21
          Width = 59
          Height = 13
          Caption = 'From - To:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblDateFromTitle: TLabel
          Left = 84
          Top = 21
          Width = 90
          Height = 13
          Caption = '                              '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
      end
    end
    object pnlPtInfo: TPanel
      Left = 25
      Top = 2
      Width = 268
      Height = 39
      Hint = 'Selected patient demographics.'
      Align = alLeft
      BevelOuter = bvNone
      Color = clSilver
      TabOrder = 1
      TabStop = True
      OnClick = pnlPtInfoClick
      OnEnter = pnlPtInfoEnter
      OnExit = pnlPtInfoExit
      OnMouseDown = pnlPtInfoMouseDown
      OnMouseUp = pnlPtInfoMouseUp
      DesignSize = (
        268
        39)
      object lblPatientName: TLabel
        Left = 7
        Top = 5
        Width = 115
        Height = 13
        Caption = 'No Patient Selected'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = pnlPtInfoClick
        OnMouseDown = pnlPtInfoMouseDown
        OnMouseUp = pnlPtInfoMouseUp
      end
      object lblPatientInfo: TLabel
        Left = 7
        Top = 21
        Width = 60
        Height = 13
        Caption = '000-00-0000'
        OnClick = pnlPtInfoClick
        OnMouseDown = pnlPtInfoMouseDown
        OnMouseUp = pnlPtInfoMouseUp
      end
      object Bevel1: TBevel
        Left = 256
        Top = 5
        Width = 12
        Height = 31
        Anchors = [akTop, akRight]
        Shape = bsRightLine
      end
      object ccrContextorIndicator: TCCRContextorIndicator
        Left = 230
        Top = 10
        Width = 27
        Height = 29
        Constraints.MinHeight = 16
        Constraints.MinWidth = 16
        TabOrder = 0
        Contextor = CCRContextor
      end
    end
    object Panel1: TPanel
      Left = 736
      Top = 2
      Width = 172
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      Color = clSilver
      TabOrder = 2
      object sbtnAllergies: TSpeedButton
        Left = 115
        Top = 1
        Width = 56
        Height = 38
        Action = acPtAllergies
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          08000000000000010000C40E0000C40E00000001000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000000A0A0A0A0A0A
          0F0F0F0F0F0A0A0A0A0A0A0A0A0A0F04040404040F0F0F0A0A0A0A0A0A040404
          0404040404040F0F0A0A0A0A04040404040404040404040F0F0A0A0404040404
          0F0F0F0F040404040F0A0A04040404040F0F0F0F0F0404040F0F040404040404
          0F0F0F0404040404040F040404040F0F0F0F0F0404040404040F04040404040F
          0F0F0F0404040404040F0404040404040F0F0F0F04040404040F040404040404
          0404040404040404040A0A0404040404040F0F04040404040F0A0A0404040404
          0F0F0F0F040404040A0A0A0A04040404040F0F040404040A0A0A0A0A0A040404
          0404040404040A0A0A0A0A0A0A0A0A04040404040A0A0A0A0A0A}
        Layout = blGlyphTop
        Spacing = 1
      end
      object sbEnterVitals: TSpeedButton
        Left = 58
        Top = 1
        Width = 56
        Height = 38
        Action = acInputVitals
        Flat = True
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          08000000000000010000C40E0000C40E00000001000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A6000020400000206000002080000020A0000020C0000020E000004000000040
          20000040400000406000004080000040A0000040C0000040E000006000000060
          20000060400000606000006080000060A0000060C0000060E000008000000080
          20000080400000806000008080000080A0000080C0000080E00000A0000000A0
          200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
          200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
          200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
          20004000400040006000400080004000A0004000C0004000E000402000004020
          20004020400040206000402080004020A0004020C0004020E000404000004040
          20004040400040406000404080004040A0004040C0004040E000406000004060
          20004060400040606000406080004060A0004060C0004060E000408000004080
          20004080400040806000408080004080A0004080C0004080E00040A0000040A0
          200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
          200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
          200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
          20008000400080006000800080008000A0008000C0008000E000802000008020
          20008020400080206000802080008020A0008020C0008020E000804000008040
          20008040400080406000804080008040A0008040C0008040E000806000008060
          20008060400080606000806080008060A0008060C0008060E000808000008080
          20008080400080806000808080008080A0008080C0008080E00080A0000080A0
          200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
          200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
          200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
          2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
          2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
          2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
          2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
          2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
          2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
          2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FAFAFAFAFAFA
          FAFA00FCFAFAFAFAFAFAFAFAFAFAFAFAFC000000FCFAFAFAFAFAFAFAFAFAFC00
          0000FF0000FCFAFAFAFAFAFAFA000000FFFF07FF0000FCFAFAFAFAFAFA00FFFF
          0707FFFFFF0000FCFAFAFAFAFA0000FFFFFFFF0707FF0000FCFA000000000000
          FF0707FFFFFFFF0000FCFC00A4A4A4000000000000A4FFFF0000FC0007FFFFFF
          FFFF0000A4FFFF000000FC00FFFFFFFF0000FB0000A40000FF0000000000FFFF
          00FBFF0000FF00FA00FAFAFAFAFA0000FBFF00FAFA0000FAFAFAFAFAFAFA00FB
          0000FAFAFAFAFAFAFAFAFAFAFA00FBFAFAFAFAFAFAFAFAFAFAFAFAFA00FBFAFA
          FAFAFAFAFAFAFAFAFAFAFAFAFBFAFAFAFAFAFAFAFAFAFAFAFAFA}
        Layout = blGlyphTop
      end
      object sbtnPtLookup: TSpeedButton
        Left = 1
        Top = 1
        Width = 56
        Height = 38
        Action = acPtSelect
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333300000000
          0EEE333377777777777733330FF00FBFB0EE33337F37733F377733330F0BFB0B
          FB0E33337F73FF73337733330FF000BFBFB033337F377733333733330FFF0BFB
          FBF033337FFF733F333733300000BF0FBFB03FF77777F3733F37000FBFB0F0FB
          0BF077733FF7F7FF7337E0FB00000000BF0077F377777777F377E0BFBFBFBFB0
          F0F077F3333FFFF7F737E0FBFB0000000FF077F3337777777337E0BFBFBFBFB0
          FFF077F3333FFFF73FF7E0FBFB00000F000077FF337777737777E00FBFBFB0FF
          0FF07773FFFFF7337F37003000000FFF0F037737777773337F7333330FFFFFFF
          003333337FFFFFFF773333330000000003333333777777777333}
        Layout = blGlyphTop
        NumGlyphs = 2
      end
    end
    object pnlCCOWIndicator: TPanel
      Left = 2
      Top = 2
      Width = 23
      Height = 39
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 3
    end
  end
  object acMainList: TActionList
    Left = 104
    Top = 2
    object acInputVitals: TAction
      Caption = '&Enter Vitals'
      Enabled = False
      Hint = 'Open Input Vitals window'
      OnExecute = acInputVitalsExecute
    end
    object acGroupInput: TAction
      Caption = 'Input Vitals for the Selected Patients'
      Enabled = False
      OnExecute = acGroupInputExecute
    end
    object acPatientInfo: TAction
      Caption = 'Pt In&fo'
      Hint = 'Standart Patient Report'
      ShortCut = 16457
      OnExecute = acPatientInfoExecute
    end
    object acPtSelect: TAction
      Caption = 'Pt &Select'
      Hint = 'Open/Close Patient Selector'
      ShortCut = 16463
      OnExecute = acPtSelectExecute
    end
    object acEditVitals: TAction
      Caption = 'acEditVitals'
      Enabled = False
    end
    object acPtAllergies: TAction
      Caption = 'Alle&rgies'
      Enabled = False
      Hint = 'Display list of patients allergies.'
      ShortCut = 16460
      OnExecute = acPtAllergiesExecute
    end
    object acRunReport: TAction
      Caption = 'acRunReport'
      OnExecute = acRunReportExecute
    end
    object FileExit1: TFileExit
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
      OnHint = FileExit1Hint
    end
    object acPatientSelect: TAction
      OnExecute = acPatientSelectExecute
    end
    object acDevInfo: TAction
      Caption = 'acDevInfo'
      OnExecute = acDevInfoExecute
    end
  end
  object mnMain: TMainMenu
    Left = 136
    object mnFile: TMenuItem
      Caption = '&File'
      object PatientInquiry1: TMenuItem
        Action = fraGMV_GridGraph1.acPatientInfo
      end
      object DataGridReport1: TMenuItem
        Action = fraGMV_GridGraph1.acVitalsReport
      end
      object PtSelect1: TMenuItem
        Action = acPtSelect
      end
      object EnterVitals1: TMenuItem
        Action = acInputVitals
      end
      object mnFilePrinterSetup: TMenuItem
        Caption = '&Printer Setup'
        ShortCut = 16464
        OnClick = mnFilePrinterSetupClick
      end
      object mnFileEnteredInError: TMenuItem
        Caption = '&Entered in Error'
        ShortCut = 16453
        OnClick = mnFileEnteredInErrorClick
      end
      object mnFileEditUserTemplates: TMenuItem
        Caption = 'Edit &User templates'
        ShortCut = 16469
        OnClick = mnFileEditUserTemplatesClick
      end
      object mnFileUserOptions: TMenuItem
        Caption = 'U&ser Options'
        ShortCut = 16467
        OnClick = mnFileUserOptionsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object CCOW1: TMenuItem
        Caption = 'Rejoin Clinical Link'
        object UseApplicationData1: TMenuItem
          Action = acFileRejoinApp
          Caption = 'Use this Application'#39's Data'
        end
        object UseGlobalData1: TMenuItem
          Action = acFileRejoinGlobal
        end
      end
      object BreaktheClinicalLink1: TMenuItem
        Action = acFileBreakLink
      end
      object ShowStatus1: TMenuItem
        Action = acShowStatus
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object ShowHideGraphOptions1: TMenuItem
        Action = fraGMV_GridGraph1.acGraphOptions
      end
      object SelectGraphColor1: TMenuItem
        Action = fraGMV_GridGraph1.ColorSelect1
      end
      object PrintGraph1: TMenuItem
        Action = fraGMV_GridGraph1.acPrintGraph
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnFileExit: TMenuItem
        Action = FileExit1
      end
    end
    object mnReports: TMenuItem
      Caption = 'Re&ports'
      object mnReportsVitalSigns: TMenuItem
        Caption = '&Vitals Signs Record '
        OnClick = acRunReportExecute
      end
      object mnReportsBPPlottingChart: TMenuItem
        Caption = '&B/P Plotting Chart'
        OnClick = acRunReportExecute
      end
      object mnReportsWeightChart: TMenuItem
        Caption = '&Weight Chart '
        OnClick = acRunReportExecute
      end
      object mnReportsPOxRespirationChart: TMenuItem
        Caption = '&POx/Respiration Chart '
        OnClick = acRunReportExecute
      end
      object mnReportsPainChart: TMenuItem
        Caption = 'P&ain Chart '
        OnClick = acRunReportExecute
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnReportsCumaulativeVitalsReport: TMenuItem
        Caption = '&Cumulative Vitals Report '
        OnClick = acRunReportExecute
      end
      object mnReportsLatestVitalsbyLocation: TMenuItem
        Caption = '&Latest Vitals by Location '
        OnClick = acRunReportExecute
      end
      object mnReportsLatestVitalsDisplayPatient: TMenuItem
        Caption = 'Latest Vitals Display for a Patient'
        OnClick = acRunReportExecute
      end
      object mnReportsVitalsEnteredInError: TMenuItem
        Caption = 'P&rint Vitals entered in error for patient '
        OnClick = acRunReportExecute
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object Demographics1: TMenuItem
        Action = acPatientInfo
      end
      object Allergies1: TMenuItem
        Action = acPtAllergies
      end
    end
    object mnHelp: TMenuItem
      Caption = '&Help'
      object mnHelpIndex: TMenuItem
        Caption = '&Index'
        ShortCut = 16456
        OnClick = mnHelpIndexClick
      end
      object mnHelpWeb: TMenuItem
        Caption = 'Vitals &Web site'
        ShortCut = 16471
        OnClick = mnHelpWebClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnHelpAbout: TMenuItem
        Caption = '&About'
        ShortCut = 16449
        OnClick = mnHelpAboutClick
      end
    end
  end
  object CCRContextor: TCCRContextor
    ApplicationName = 'Vitals#'
    NotificationFilter = 'Patient;User'
    OnCommitted = CCRContextorCommitted
    OnPending = CCRContextorPending
    OnResumed = CCRContextorResumed
    OnSuspended = CCRContextorSuspended
    DFNItemName = 'patient.id.mrn.dfn_'
    ICNItemName = 'patient.id.mrn.nationalidnumber'
    OnPatientChanged = CCRContextorPatientChanged
    Left = 208
    Top = 24
  end
  object aclMain: TActionList
    Left = 176
    Top = 16
    object acFileExit: TAction
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Exit application'
      ImageIndex = 20
    end
    object acFileBreakLink: TAction
      Category = 'File'
      Caption = 'Break the Clinical Link'
      OnExecute = acFileBreakLinkExecute
    end
    object acFileRejoinApp: TAction
      Category = 'File'
      Caption = 'Use Application Data'
      Hint = 'Join Context and continue to work with the same Patient '
      OnExecute = acFileRejoinAppExecute
    end
    object acFileRejoinGlobal: TAction
      Category = 'File'
      Caption = 'Use Global Data'
      Hint = 'Join Context and switch to the patient currently in the Context'
      OnExecute = acFileRejoinGlobalExecute
    end
    object acPatientEdit: TAction
      Category = 'Patients'
      Caption = 'Edit Patient Data...'
    end
    object acShowStatus: TAction
      Category = 'File'
      Caption = 'Show Status'
      OnExecute = acShowStatusExecute
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnHelp = ApplicationEventsHelp
    OnMinimize = ApplicationEventsMinimize
    OnRestore = ApplicationEventsRestore
    Left = 8
    Top = 64
  end
end
