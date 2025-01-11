object frmMDMGrid: TfrmMDMGrid
  Left = 8
  Top = 8
  BorderStyle = bsToolWindow
  Caption = 'Medical Decision Making'
  ClientHeight = 876
  ClientWidth = 1198
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object sbMain: TScrollBox
    Left = 0
    Top = 0
    Width = 1198
    Height = 876
    Align = alClient
    Color = clCream
    ParentColor = False
    TabOrder = 0
    object pnlBillingMode: TPanel
      Left = 656
      Top = 5
      Width = 497
      Height = 102
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 0
      Visible = False
      DesignSize = (
        497
        102)
      object rgBillingMode: TRadioGroup
        Left = 10
        Top = 5
        Width = 239
        Height = 92
        Caption = 'Time vs Complexity As Criteria?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Items.Strings = (
          'COMPLEXITY based billing'
          'TIME based billing'
          'TELEPHONE AUDIO ONLY time-based billing'
          'Preventative / CPE billing')
        ParentFont = False
        TabOrder = 0
        OnClick = rgBillingModeClick
      end
      object memBillingModeHint: TMemo
        Left = 255
        Top = 12
        Width = 217
        Height = 85
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clSkyBlue
        ReadOnly = True
        TabOrder = 1
      end
    end
    object pnlNewOrOldPatient: TPanel
      Left = 16
      Top = 13
      Width = 497
      Height = 81
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 1
      object rgNewOrOldPatient: TRadioGroup
        Left = 10
        Top = 5
        Width = 239
        Height = 65
        Caption = 'New vs Established Patient?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Items.Strings = (
          'ESTABLISHED Patient'
          'NEW Patient')
        ParentFont = False
        TabOrder = 0
        OnClick = rgNewOrOldPatientClick
      end
    end
    object pnlNewPtTimeAmount: TPanel
      Left = 527
      Top = 108
      Width = 641
      Height = 155
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 2
      Visible = False
      DesignSize = (
        641
        155)
      object rgNewPtTimeAmount: TRadioGroup
        Left = 10
        Top = 5
        Width = 263
        Height = 140
        Caption = 'NEW PATIENT Time Amount'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Items.Strings = (
          '15  -  29 minutes  (99202)'
          '30  -  44 minutes  (99203)'
          '45  -  59 minutes  (99204)'
          '60  -  74 minutes  (99205)'
          '75  -  89 minutes  (99205 + 99417 x 1)'
          '90  - 104 minutes (99205 + 99417 x 2)'
          '105- 119 minutes (99205 + 99417 x 3)'
          '120- 134 minutes (99205 + 99417 x 4)')
        ParentFont = False
        TabOrder = 0
        OnClick = rgNewPtTimeAmountClick
      end
      object memNewPtTimeInfo: TMemo
        Left = 279
        Top = 8
        Width = 354
        Height = 121
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clSkyBlue
        ReadOnly = True
        TabOrder = 1
      end
      object btnNewPtRefreshTime: TButton
        Left = 558
        Top = 135
        Width = 75
        Height = 16
        Anchors = [akTop, akRight]
        Caption = 'Refresh'
        TabOrder = 2
        OnClick = btnNewPtRefreshTimeClick
      end
    end
    object pnlOldPtTimeAmount: TPanel
      Left = 527
      Top = 269
      Width = 633
      Height = 162
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 3
      Visible = False
      DesignSize = (
        633
        162)
      object rgOldPtTimeAmount: TRadioGroup
        Left = 10
        Top = 5
        Width = 271
        Height = 148
        Caption = 'ESTABLISHED PATIENT Time Amount'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Items.Strings = (
          '10  - 19 minutes  (99212)'
          '20  - 29 minutes  (99213)'
          '30  - 39 minutes  (99214)'
          '40  - 54 minutes  (99215)'
          '55  - 69 minutes  (99215 + 99417x1)'
          '70  - 84 minutes  (99215 + 99417x2)'
          '85  - 99 minutes  (99215 + 99417x3)'
          '100-114 minutes  (99215 + 99417x4)')
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        OnClick = rgOldPtTimeAmountClick
      end
      object memOldPtTimeInfo: TMemo
        Left = 287
        Top = 8
        Width = 338
        Height = 126
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clSkyBlue
        ReadOnly = True
        TabOrder = 1
      end
      object btnOldPtRefresh: TButton
        Left = 550
        Top = 140
        Width = 75
        Height = 16
        Anchors = [akTop, akRight]
        Caption = 'Refresh'
        TabOrder = 2
        OnClick = btnOldPtRefreshClick
      end
    end
    object pnlComplexity: TPanel
      Left = 24
      Top = 100
      Width = 457
      Height = 334
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 4
      Visible = False
      object gpProblems: TGroupBox
        Left = 1
        Top = 1
        Width = 455
        Height = 332
        Align = alClient
        Caption = 'Number / Complexity of Problems Addressed'
        Color = clSkyBlue
        ParentBackground = False
        ParentColor = False
        TabOrder = 0
        object rgMinimal: TRadioGroup
          Left = 5
          Top = 24
          Width = 185
          Height = 41
          Caption = 'MINIMAL'
          Items.Strings = (
            '1 self-limited or minor problem')
          TabOrder = 0
          OnClick = rgComplexityLevelClick
        end
        object rgLow: TRadioGroup
          Left = 3
          Top = 71
          Width = 220
          Height = 70
          Caption = 'LOW'
          Color = clSkyBlue
          Items.Strings = (
            '2+ self-limited or minor problems'
            '1 stable chronic illness'
            '1 acute, uncomplicated illness/injury')
          ParentColor = False
          TabOrder = 1
          OnClick = rgComplexityLevelClick
        end
        object rgModerate: TRadioGroup
          Left = 5
          Top = 151
          Width = 396
          Height = 105
          Caption = 'MODERATE'
          Items.Strings = (
            
              '1+ chronic illness with exacerbation, progress or side effects o' +
              'f treatment'
            '2+ stable chronic illnesses'
            '1 undiagnosed new problem with uncertain prognosis'
            '1 acute illness with systemic symptoms'
            '1 acute complicated injury')
          ParentBackground = False
          TabOrder = 2
          OnClick = rgComplexityLevelClick
        end
        object rgHigh: TRadioGroup
          Left = 5
          Top = 262
          Width = 436
          Height = 59
          Caption = 'HIGH'
          Items.Strings = (
            
              '1+ chronic illness with severe exacerbation, progress, or side e' +
              'ffects of treatment'
            
              '1 acute or chronic illness/injury that poses a threat to life or' +
              ' bodily function')
          TabOrder = 3
          OnClick = rgComplexityLevelClick
        end
      end
    end
    object pnlTestsDocs: TPanel
      Left = 2
      Top = 400
      Width = 417
      Height = 409
      Color = clSkyBlue
      TabOrder = 6
      Visible = False
      object grpTestsDocsIndHx: TGroupBox
        Left = 1
        Top = 1
        Width = 415
        Height = 407
        Align = alClient
        Caption = 'DATA / TESTS / DOCUMENTS / INDEPENDENT HISTORIAN'
        ParentBackground = False
        TabOrder = 0
        object lblDataScoreTitle: TLabel
          Left = 15
          Top = 45
          Width = 130
          Height = 13
          Caption = 'Section Level Reached:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object lblDataScore: TLabel
          Left = 164
          Top = 45
          Width = 7
          Height = 13
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object Label3: TLabel
          Left = 15
          Top = 68
          Width = 58
          Height = 13
          Caption = 'Category 1:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 16
          Top = 245
          Width = 81
          Height = 13
          Caption = 'Category 1 vs 2:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object Label5: TLabel
          Left = 15
          Top = 283
          Width = 58
          Height = 13
          Caption = 'Category 2:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 15
          Top = 320
          Width = 58
          Height = 13
          Caption = 'Category 3:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
        end
        object ckbReview1Test: TCheckBox
          Tag = 1
          Left = 16
          Top = 87
          Width = 241
          Height = 17
          Caption = 'Review the results of 1 unique test / panel'
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 0
          OnClick = HandleReviewTestsChange
        end
        object ckbReview2Tests: TCheckBox
          Tag = 2
          Left = 16
          Top = 101
          Width = 241
          Height = 17
          Caption = 'Review the results of 2 unique tests / panels'
          TabOrder = 1
          OnClick = HandleReviewTestsChange
        end
        object ckbReview3Tests: TCheckBox
          Tag = 3
          Left = 16
          Top = 115
          Width = 241
          Height = 17
          Caption = 'Review the results of 3 unique tests / panels'
          TabOrder = 2
          OnClick = HandleReviewTestsChange
        end
        object ckbReview1ExtDoc: TCheckBox
          Tag = 1
          Left = 16
          Top = 196
          Width = 257
          Height = 17
          Caption = 'Review 1 prior external record / document'
          TabOrder = 3
          OnClick = HandleReviewTestsChange
        end
        object ckbReview2ExtDocs: TCheckBox
          Tag = 2
          Left = 16
          Top = 210
          Width = 257
          Height = 17
          Caption = 'Review 2 prior external records / documents'
          TabOrder = 4
          OnClick = HandleReviewTestsChange
        end
        object ckbReview3ExtDocs: TCheckBox
          Tag = 3
          Left = 16
          Top = 224
          Width = 257
          Height = 17
          Caption = 'Review 3 prior external records / documents'
          TabOrder = 5
          OnClick = HandleReviewTestsChange
        end
        object ckbIndHistorian: TCheckBox
          Tag = 1
          Left = 16
          Top = 260
          Width = 329
          Height = 17
          Caption = 'Assessment requiring interview with independent historian(s)'
          TabOrder = 6
          OnClick = HandleReviewTestsChange
        end
        object ckbOrder1Test: TCheckBox
          Tag = 1
          Left = 16
          Top = 140
          Width = 241
          Height = 17
          Caption = 'Order 1 unique test / panel'
          TabOrder = 7
          OnClick = HandleReviewTestsChange
        end
        object ckbOrder2Tests: TCheckBox
          Tag = 2
          Left = 16
          Top = 154
          Width = 241
          Height = 17
          Caption = 'Order 2 unique tests / panels'
          TabOrder = 8
          OnClick = HandleReviewTestsChange
        end
        object ckbOrder3Tests: TCheckBox
          Tag = 3
          Left = 16
          Top = 168
          Width = 241
          Height = 17
          Caption = 'Order 3 unique tests / panels'
          TabOrder = 9
          OnClick = HandleReviewTestsChange
        end
        object memChargeComments: TMemo
          Left = 16
          Top = 15
          Width = 377
          Height = 32
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clSkyBlue
          Lines.Strings = (
            
              'NOTE: Can'#39't charge separately for ordering and reviewing same te' +
              'st / panel. '
            '           Charge for one OR the other.')
          TabOrder = 10
        end
        object ckbIndInterpret: TCheckBox
          Left = 15
          Top = 298
          Width = 377
          Height = 17
          Caption = 
            'Independent interpretation of test data performed by another pro' +
            'vider'
          TabOrder = 11
          OnClick = HandleReviewTestsChange
        end
        object ckbDiscussExternal: TCheckBox
          Left = 16
          Top = 335
          Width = 360
          Height = 17
          Caption = 
            'Discussion of management or test interpretation with external pr' +
            'ovider'
          TabOrder = 12
          OnClick = HandleReviewTestsChange
        end
        object btnNextSection: TButton
          Left = 16
          Top = 368
          Width = 89
          Height = 17
          Caption = 'Next Section'
          TabOrder = 13
          OnClick = btnNextSectionClick
        end
        object btnReviewTestHelp: TBitBtn
          Left = 384
          Top = 100
          Width = 20
          Height = 20
          Hint = 'Define "Test"'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 14
          OnClick = btnTestsHelpClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF606060404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF3F3F3F404040404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF2020203F3F3FFFFFFF404040404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040606060404040AF
            AFAFFFFFFF404040808080808080404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF2020206F6F6FAFAFAFFFFFFFFFFFFFFFFFFFAFAFAF6F6F6F4040408080
            80606060FFFFFFFFFFFFFFFFFFFFFFFF3F3F3FEFEFEFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFEFEFEF5F5F5F808080606060FFFFFFFFFFFF5F5F5F
            FFFFFFFFFFFFFFFFFFFFBFBFFF7F7FFF7F7FFF7F7FFF7F7FFFFFFFFFFFFFFFFF
            FF5F5F5F808080404040404040EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFEFEFEF404040808080AFAFAFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF6F6F6F808080BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F808080BFBFBFFFFFFF
            FFFFFFFFFFFFFFFFFFFFBFBFFF3F3FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF7F7F7F606060707070FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF505050202020202020CFCFCF
            FFFFFFFFFFFFFFFFFFFFFFFFEF3030FF0000EF3030FFFFFFFFFFFFFFFFFFFFFF
            FFAFAFAF000000FFFFFFFFFFFF202020DFDFDFFFFFFFFFFFFFFFFFFFEF3030FF
            0000EF3030FFFFFFFFFFFFFFFFFFBFBFBF000000FFFFFFFFFFFFFFFFFFFFFFFF
            202020AFAFAFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFAFAFAF2020
            20FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040707070BFBFBFBF
            BFBFBFBFBF707070404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
        object btnOrderTestsHelp: TBitBtn
          Left = 384
          Top = 153
          Width = 20
          Height = 20
          Hint = 'Define "Test"'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 15
          OnClick = btnTestsHelpClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF606060404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF3F3F3F404040404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF2020203F3F3FFFFFFF404040404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040606060404040AF
            AFAFFFFFFF404040808080808080404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF2020206F6F6FAFAFAFFFFFFFFFFFFFFFFFFFAFAFAF6F6F6F4040408080
            80606060FFFFFFFFFFFFFFFFFFFFFFFF3F3F3FEFEFEFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFEFEFEF5F5F5F808080606060FFFFFFFFFFFF5F5F5F
            FFFFFFFFFFFFFFFFFFFFBFBFFF7F7FFF7F7FFF7F7FFF7F7FFFFFFFFFFFFFFFFF
            FF5F5F5F808080404040404040EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFEFEFEF404040808080AFAFAFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF6F6F6F808080BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F808080BFBFBFFFFFFF
            FFFFFFFFFFFFFFFFFFFFBFBFFF3F3FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF7F7F7F606060707070FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF505050202020202020CFCFCF
            FFFFFFFFFFFFFFFFFFFFFFFFEF3030FF0000EF3030FFFFFFFFFFFFFFFFFFFFFF
            FFAFAFAF000000FFFFFFFFFFFF202020DFDFDFFFFFFFFFFFFFFFFFFFEF3030FF
            0000EF3030FFFFFFFFFFFFFFFFFFBFBFBF000000FFFFFFFFFFFFFFFFFFFFFFFF
            202020AFAFAFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFAFAFAF2020
            20FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040707070BFBFBFBF
            BFBFBFBFBF707070404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
        object btnReviewDocsHelp: TBitBtn
          Left = 384
          Top = 204
          Width = 20
          Height = 20
          Hint = 'Define "External"'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 16
          OnClick = btnReviewDocsHelpClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF606060404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF3F3F3F404040404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF2020203F3F3FFFFFFF404040404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040606060404040AF
            AFAFFFFFFF404040808080808080404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF2020206F6F6FAFAFAFFFFFFFFFFFFFFFFFFFAFAFAF6F6F6F4040408080
            80606060FFFFFFFFFFFFFFFFFFFFFFFF3F3F3FEFEFEFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFEFEFEF5F5F5F808080606060FFFFFFFFFFFF5F5F5F
            FFFFFFFFFFFFFFFFFFFFBFBFFF7F7FFF7F7FFF7F7FFF7F7FFFFFFFFFFFFFFFFF
            FF5F5F5F808080404040404040EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFEFEFEF404040808080AFAFAFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF6F6F6F808080BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F808080BFBFBFFFFFFF
            FFFFFFFFFFFFFFFFFFFFBFBFFF3F3FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF7F7F7F606060707070FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF505050202020202020CFCFCF
            FFFFFFFFFFFFFFFFFFFFFFFFEF3030FF0000EF3030FFFFFFFFFFFFFFFFFFFFFF
            FFAFAFAF000000FFFFFFFFFFFF202020DFDFDFFFFFFFFFFFFFFFFFFFEF3030FF
            0000EF3030FFFFFFFFFFFFFFFFFFBFBFBF000000FFFFFFFFFFFFFFFFFFFFFFFF
            202020AFAFAFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFAFAFAF2020
            20FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040707070BFBFBFBF
            BFBFBFBFBF707070404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
        object btnIndependentHxHelp: TBitBtn
          Left = 384
          Top = 260
          Width = 20
          Height = 20
          Hint = 'Define "Independent"'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 17
          OnClick = btnIndependentHxHelpClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF606060404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF3F3F3F404040404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF2020203F3F3FFFFFFF404040404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040606060404040AF
            AFAFFFFFFF404040808080808080404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF2020206F6F6FAFAFAFFFFFFFFFFFFFFFFFFFAFAFAF6F6F6F4040408080
            80606060FFFFFFFFFFFFFFFFFFFFFFFF3F3F3FEFEFEFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFEFEFEF5F5F5F808080606060FFFFFFFFFFFF5F5F5F
            FFFFFFFFFFFFFFFFFFFFBFBFFF7F7FFF7F7FFF7F7FFF7F7FFFFFFFFFFFFFFFFF
            FF5F5F5F808080404040404040EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFEFEFEF404040808080AFAFAFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF6F6F6F808080BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F808080BFBFBFFFFFFF
            FFFFFFFFFFFFFFFFFFFFBFBFFF3F3FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF7F7F7F606060707070FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF505050202020202020CFCFCF
            FFFFFFFFFFFFFFFFFFFFFFFFEF3030FF0000EF3030FFFFFFFFFFFFFFFFFFFFFF
            FFAFAFAF000000FFFFFFFFFFFF202020DFDFDFFFFFFFFFFFFFFFFFFFEF3030FF
            0000EF3030FFFFFFFFFFFFFFFFFFBFBFBF000000FFFFFFFFFFFFFFFFFFFFFFFF
            202020AFAFAFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFAFAFAF2020
            20FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040707070BFBFBFBF
            BFBFBFBFBF707070404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
        object btnInterpretTestHelp: TBitBtn
          Left = 384
          Top = 300
          Width = 20
          Height = 20
          Hint = 'Define "Interpret"'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 18
          OnClick = btnInterpretTestHelpClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF606060404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF3F3F3F404040404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF2020203F3F3FFFFFFF404040404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040606060404040AF
            AFAFFFFFFF404040808080808080404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF2020206F6F6FAFAFAFFFFFFFFFFFFFFFFFFFAFAFAF6F6F6F4040408080
            80606060FFFFFFFFFFFFFFFFFFFFFFFF3F3F3FEFEFEFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFEFEFEF5F5F5F808080606060FFFFFFFFFFFF5F5F5F
            FFFFFFFFFFFFFFFFFFFFBFBFFF7F7FFF7F7FFF7F7FFF7F7FFFFFFFFFFFFFFFFF
            FF5F5F5F808080404040404040EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFEFEFEF404040808080AFAFAFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF6F6F6F808080BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F808080BFBFBFFFFFFF
            FFFFFFFFFFFFFFFFFFFFBFBFFF3F3FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF7F7F7F606060707070FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF505050202020202020CFCFCF
            FFFFFFFFFFFFFFFFFFFFFFFFEF3030FF0000EF3030FFFFFFFFFFFFFFFFFFFFFF
            FFAFAFAF000000FFFFFFFFFFFF202020DFDFDFFFFFFFFFFFFFFFFFFFEF3030FF
            0000EF3030FFFFFFFFFFFFFFFFFFBFBFBF000000FFFFFFFFFFFFFFFFFFFFFFFF
            202020AFAFAFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFAFAFAF2020
            20FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040707070BFBFBFBF
            BFBFBFBFBF707070404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
        object btnDiscussExternalDocHelp: TBitBtn
          Left = 384
          Top = 334
          Width = 20
          Height = 20
          Hint = 'Define "External"'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 19
          OnClick = btnDiscussExternalDocHelpClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF606060404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF3F3F3F404040404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFF2020203F3F3FFFFFFF404040404040FFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040606060404040AF
            AFAFFFFFFF404040808080808080404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFF2020206F6F6FAFAFAFFFFFFFFFFFFFFFFFFFAFAFAF6F6F6F4040408080
            80606060FFFFFFFFFFFFFFFFFFFFFFFF3F3F3FEFEFEFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFEFEFEF5F5F5F808080606060FFFFFFFFFFFF5F5F5F
            FFFFFFFFFFFFFFFFFFFFBFBFFF7F7FFF7F7FFF7F7FFF7F7FFFFFFFFFFFFFFFFF
            FF5F5F5F808080404040404040EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFEFEFEF404040808080AFAFAFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF6F6F6F808080BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
            0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F808080BFBFBFFFFFFF
            FFFFFFFFFFFFFFFFFFFFBFBFFF3F3FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFF7F7F7F606060707070FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF505050202020202020CFCFCF
            FFFFFFFFFFFFFFFFFFFFFFFFEF3030FF0000EF3030FFFFFFFFFFFFFFFFFFFFFF
            FFAFAFAF000000FFFFFFFFFFFF202020DFDFDFFFFFFFFFFFFFFFFFFFEF3030FF
            0000EF3030FFFFFFFFFFFFFFFFFFBFBFBF000000FFFFFFFFFFFFFFFFFFFFFFFF
            202020AFAFAFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFAFAFAF2020
            20FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040707070BFBFBFBF
            BFBFBFBFBF707070404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        end
      end
    end
    object pnlRisk: TPanel
      Left = 10
      Top = 200
      Width = 500
      Height = 315
      Color = clSkyBlue
      TabOrder = 5
      Visible = False
      object grpRisk: TGroupBox
        Left = 1
        Top = 1
        Width = 498
        Height = 313
        Align = alClient
        Caption = 'RISK'
        Color = clSkyBlue
        ParentBackground = False
        ParentColor = False
        TabOrder = 0
        object rgRisk: TRadioGroup
          Left = 5
          Top = 15
          Width = 436
          Height = 90
          Caption = 
            'Risk of mobidity from additional/future diagnostic testing or tr' +
            'eatment'
          Items.Strings = (
            'MINIMAL'
            'LOW'
            'MODERATE'
            'HIGH')
          TabOrder = 0
          OnClick = rgRiskClick
        end
        object memExampleRiskMod: TMemo
          Left = 8
          Top = 127
          Width = 473
          Height = 74
          BevelOuter = bvNone
          Color = clSkyBlue
          Lines.Strings = (
            'Examples of Moderate Risk:'
            ' - Prescription drug management'
            
              ' - Decision regarding minor surgery with identified patient or p' +
              'rocedure risk factors'
            
              ' - Decision regarding elective major surgery without identified ' +
              'patient or procedure risk factors'
            
              ' - Diagnosis or treatment significantly limited by social determ' +
              'inants of health')
          TabOrder = 1
          Visible = False
        end
        object memExampleRiskHigh: TMemo
          Left = 8
          Top = 223
          Width = 473
          Height = 74
          BevelOuter = bvNone
          Color = clSkyBlue
          Lines.Strings = (
            'Examples of High Risk:'
            ' - Drug therapy requiring intensive monitoring for toxicity'
            
              ' - Decision regarding elective major surgery with identified pat' +
              'ient or procedure risk factors'
            ' - Decision regarding emergency major surgery'
            ' - Decision regarding hospitalization'
            
              ' - Decision not to resuscitate or to de-escalate care because of' +
              ' poor prognosis')
          TabOrder = 2
          Visible = False
        end
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 0
      Width = 1194
      Height = 70
      Align = alTop
      ParentBackground = False
      TabOrder = 7
      DesignSize = (
        1194
        70)
      object Label1: TLabel
        Left = 32
        Top = 24
        Width = 59
        Height = 22
        Caption = 'Result:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object lblResult: TLabel
        Left = 104
        Top = 24
        Width = 5
        Height = 22
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object lblResultValue: TLabel
        Left = 97
        Top = 24
        Width = 5
        Height = 22
        Caption = ' '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object lblChargeDetails: TLabel
        Left = 34
        Top = 45
        Width = 3
        Height = 14
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object btnOK: TBitBtn
        Left = 1049
        Top = 8
        Width = 138
        Height = 57
        Anchors = [akTop, akRight]
        Caption = '&OK'
        Enabled = False
        ModalResult = 1
        TabOrder = 0
        OnClick = btnOKClick
        Glyph.Data = {
          42240000424D4224000000000000420000002800000030000000300000000100
          20000300000000240000130B0000130B000000000000000000000000FF0000FF
          0000FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFAFCFAFFE2E8E2FFC0CFC0FF9CB59CFF6D986DFF2E7A2EFF2C79
          2BFF2C7B2EFF2C7B2EFF2C792BFF2E7A2EFF6D986DFF9CB59CFFC0CFC0FFE2E8
          E2FFFAFCFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFE9EE
          E9FFAEC2AFFF5E8E5FFF31813AFF298E48FF28A161FF27AC6CFF25B677FF25BB
          7DFF25BC7EFF25BC7EFF25BB7DFF25B677FF27AC6CFF28A161FF298E48FF3181
          3AFF5E8E5FFFAEC2AFFFE9EEE9FFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3E9E3FF95B095FF357F
          38FF299551FF27AD6EFF25BC7EFF24C183FF24C183FF24C183FF24C183FF24C1
          83FF24C183FF24C183FF24C183FF24C183FF24C183FF24C183FF24C183FF25BC
          7EFF27AD6EFF299451FF357F38FF95B095FFE3E9E3FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F6F3FFA9BEA9FF317F36FF299A58FF25B8
          79FF24C183FF24C183FF25BD7EFF26B475FF27A968FF28A15EFF2A9752FF2A93
          4BFF2A9048FF2A9048FF2A934BFF2A9752FF29A05EFF27A968FF26B475FF25BD
          7EFF24C183FF24C183FF25B879FF299958FF317F36FFA9BEA9FFF3F6F3FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFDCE4DCFF5E8F5FFF298E4AFF26B677FF24C183FF24BF
          81FF26B373FF299F5BFF2A9149FF2B8E45FF2B8E45FF2B8E46FF2B8E46FF2B8E
          46FF2B8E46FF2B8E46FF2B8E46FF2B8E45FF2B8D45FF2B8D44FF2B8D44FF2A90
          49FF299E5AFF26B272FF24BF81FF24C183FF26B677FF298E4AFF5E8E5FFFDCE4
          DCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFEFEFEFFBFCEBFFF38813CFF28A464FF24C081FF24BF81FF27AD6DFF2A97
          52FF2B8E46FF2B8F47FF2B8F47FF2B8F47FF2B9048FF2B9048FF2B9048FF2B90
          48FF2B9048FF2B9048FF2B9048FF2B9048FF2B8F47FF2B8F47FF2B8F47FF2B8E
          46FF2B8E46FF2B8D45FF2A9751FF27AD6CFF24C081FF24C081FF28A464FF3881
          3CFFBFCEBFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFD
          FCFFB0C3B0FF2A8138FF26B171FF24C183FF26B575FF2A9955FF2B8F47FF2B90
          48FF2B9149FF2B9149FF2B924AFF2B924AFF2B934BFF2B934BFF2B934BFF2B93
          4BFF2B934BFF2B934BFF2B934BFF2B934BFF2B924AFF2B924AFF2B9149FF2B91
          49FF2B9048FF2B8F47FF2B8F47FF2B8E46FF2A9954FF26B575FF24C183FF26B1
          71FF2A8138FFB0C3B0FFFCFDFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFAFC3
          AFFF2E843DFF25B677FF24BF81FF28A866FF2B924AFF2B9149FF2B924AFF2B92
          4BFF2B934BFF2B934CFF2B944DFF2B944CFF2B944DFF2B944EFF2B944EFF2B95
          4EFF2B944EFF2B944EFF2B954EFF2B944DFF2B944DFF2B944DFF2B934CFF2B93
          4CFF2B924BFF2B924AFF2B9149FF2B9149FF2B9048FF2B9048FF28A765FF24BF
          81FF25B677FF2E843DFFAFC3AFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFCDBFFF2A81
          38FF25B677FF25BD7FFF299F5BFF2B924AFF2B934BFF2B934CFF2B944DFF2B94
          4DFF2B954EFF2B954EFF2B964FFF2B964FFF2B9650FF2B9750FF2B9750FF2B97
          50FF2B9750FF2B9750FF2B9750FF2B9750FF2B964FFF2B964FFF2B954EFF2B95
          4EFF2B944DFF2B944DFF2B934CFF2B934BFF2B924AFF2B9149FF2B9048FF299D
          5AFF25BD7FFF25B677FF2A8138FFBFCDBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCE4DCFF38813CFF26B1
          72FF25BC7EFF2A9C57FF2B934BFF2B944CFF2B954EFF2B954EFF2B964FFF2B97
          50FF2B9751FF2B9751FF2B9852FF2B9852FF2B9852FF2B9952FF2B9953FF2B96
          4FFF2B9751FF2B9953FF2B9952FF2B9852FF2B9852FF2B9852FF2B9751FF2B97
          51FF2B9750FF2B964FFF2B964FFF2B954EFF2B944DFF2B934CFF2B924AFF2B91
          49FF2A9A55FF25BC7EFF26B172FF38813CFFDCE4DCFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F6F3FF5E8F5FFF28A564FF25BD
          7FFF2A9C58FF2B944DFF2B954EFF2B964FFF2B9750FF2B9751FF2B9852FF2B99
          52FF2B9953FF2B9A54FF2B9A54FF2B9A55FF2B9B55FF2B9B55FF2B9650FF3C84
          41FF2C8C44FF2B9B55FF2B9B55FF2B9B55FF2B9A55FF2B9A54FF2B9A54FF2B99
          53FF2B9852FF2B9852FF2B9751FF2B9750FF2B964FFF2B954EFF2B944DFF2B93
          4CFF2B924AFF2A9B56FF25BD7FFF28A464FF5E8F5FFFF3F6F3FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9BEA9FF298F4AFF24BF80FF29A1
          5EFF2B954EFF2B964FFF2B9750FF2B9751FF2B9852FF2B9953FF2B9A54FF2B9B
          55FF2B9B56FF2B9B56FF2B9C56FF2B9C57FF2B9D57FF2A9852FF528D56FFC2CD
          C3FF679569FF2A9954FF2A9D58FF2B9D58FF2B9C57FF2B9C57FF2B9B56FF2B9B
          56FF2B9B55FF2B9A54FF2B9A53FF2B9952FF2B9851FF2B9751FF2B964FFF2B95
          4EFF2B944DFF2B934CFF29A05CFF24BF80FF298F4AFFA9BEA9FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFE3EAE3FF327F38FF25B677FF28AA69FF2B96
          4FFF2B9750FF2B9851FF2B9952FF2B9A54FF2B9B55FF2B9B56FF2B9C56FF2A9D
          57FF2A9D58FF2A9E59FF2A9E59FF2A9F5AFF2A9953FF558E5AFFC9D1CAFFDFE0
          E0FFB9C7BAFF2D8A43FF2A9F5AFF2A9F5AFF2A9F5AFF2A9F59FF2A9E59FF2A9D
          58FF2A9D57FF2B9C57FF2B9B56FF2B9B55FF2B9A54FF2B9953FF2B9852FF2B97
          50FF2B964FFF2B954EFF2B944CFF28A968FF25B677FF327F38FFE3EAE3FFFFFF
          FFFFFFFFFFFFFFFFFFFFFEFEFEFF96B096FF299A59FF26B878FF2B9851FF2B97
          51FF2B9952FF2B9A54FF2B9B55FF2B9B56FF2B9C57FF2A9D58FF2A9E59FF2A9F
          5AFF2A9F5BFF2AA05BFF2AA05CFF2A9A55FF558E59FFCDD4CEFFE0E1E1FFE0E1
          E1FFDFE0E0FF7BA07CFF2A9B56FF2AA15DFF2AA05CFF2AA05CFF2AA05BFF2A9F
          5BFF2A9F5AFF2A9E59FF2A9D58FF2B9D57FF2B9C56FF2B9B55FF2B9A54FF2B99
          53FF2B9751FF2B9750FF2B964FFF2B954EFF26B778FF299A58FF96B096FFFEFE
          FEFFFFFFFFFFFFFFFFFFE9EEE9FF357F38FF25B777FF2A9F5BFF2B9852FF2B9A
          54FF2B9B55FF2B9B56FF2B9C57FF2A9E59FF2A9F5AFF2A9F5BFF2AA05CFF2AA1
          5CFF2AA15DFF2AA25EFF2A9B56FF5C915FFFD0D6D1FFE1E2E2FFE1E2E2FFE1E2
          E2FFE1E2E2FFC7D1C8FF388A47FF2AA35FFF2AA35FFF2AA35EFF2AA25EFF2AA2
          5DFF2AA15CFF2AA05CFF2A9F5BFF2A9F5AFF2A9E59FF2A9D57FF2B9C56FF2B9B
          55FF2B9A54FF2B9852FF2B9751FF2B964FFF2A9D59FF25B677FF357F38FFE9EE
          E9FFFFFFFFFFFFFFFFFFAEC2AFFF299653FF27B272FF2B9953FF2B9A54FF2B9B
          56FF2B9C57FF2A9E58FF2A9F5AFF2A9F5BFF2AA05CFF2AA15DFF2AA25EFF2AA3
          5FFF2AA35FFF2A9B57FF5F9362FFD2D8D3FFE3E4E4FFE3E4E4FFE3E4E4FFE3E4
          E4FFE3E4E4FFE3E4E4FF8CAA8DFF2A9955FF2AA562FF2AA461FF2AA460FF2AA3
          5FFF2AA35FFF2AA25EFF2AA25DFF2AA05CFF2A9F5BFF2A9F5AFF2A9E59FF2B9C
          57FF2B9B56FF2B9A54FF2B9953FF2B9751FF2B9750FF27B271FF299553FFAFC2
          AFFFFFFFFFFFFAFCFAFF5E8E5FFF27AD6EFF2A9F5BFF2B9B55FF2B9C56FF2A9D
          58FF2A9E59FF2A9F5BFF2AA05CFF2AA15DFF2AA35EFF2AA35FFF2AA460FF2AA5
          61FF2A9C58FF5F9362FFD5DAD5FFE4E5E5FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4
          E4FFE4E4E4FFE4E4E4FFD6DBD6FF438C4DFF2AA663FF2AA764FF2AA663FF2AA6
          62FF2AA561FF2AA460FF2AA35FFF2AA35FFF2AA25DFF2AA05CFF2A9F5BFF2A9F
          5AFF2A9D58FF2B9C57FF2B9B55FF2B9953FF2B9852FF2A9D59FF27AD6DFF5E8E
          5FFFFAFCFAFFE2E8E2FF30823BFF27B171FF2B9B55FF2B9C57FF2A9E58FF2A9F
          5AFF2AA05CFF2AA15DFF2AA35EFF2AA35FFF2AA461FF2AA562FF2AA663FF2A9C
          58FF669668FFD7DCD8FFE5E6E6FFE5E6E6FFE5E6E6FFE5E6E6FFE5E6E6FFE5E6
          E6FFE5E6E6FFE5E6E6FFE5E6E6FFA6BAA7FF2B9551FF2AA966FF2AA866FF2AA7
          65FF2AA764FF2AA663FF2AA562FF2AA461FF2AA35FFF2AA35FFF2AA15DFF2AA0
          5CFF2A9F5AFF2A9E59FF2B9C57FF2B9B56FF2B9A54FF2B9852FF27B070FF3082
          3AFFE2E8E2FFC0CEC0FF298F4AFF29A866FF2B9C57FF2A9E59FF2A9F5AFF2AA0
          5CFF2AA25EFF2AA35FFF2AA460FF2AA562FF2AA663FF2AA764FF2A9C58FF6A98
          6CFFD9DEDAFFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7
          E7FFE7E7E7FFE7E7E7FFE7E7E7FFE2E4E2FF649667FF2AA663FF2AAA68FF2AAA
          67FF2AA966FF2AA865FF2AA764FF2AA763FF2AA562FF2AA461FF2AA35FFF2AA2
          5EFF2AA15DFF2A9F5BFF2A9E59FF2A9D57FF2B9B56FF2B9A54FF29A765FF298F
          4AFFC0CEC0FF9CB59DFF289F5FFF2AA05CFF2A9E59FF2A9F5BFF2AA15DFF2AA2
          5EFF2AA35FFF2AA561FF2AA663FF2AA764FF2AA865FF2A9D59FF6B986DFFDCE0
          DDFFE8E9E9FFE8E9E9FFE8E9E9FFE8E9E9FFE8E9E9FFE8E9E9FFE8E9E9FFE8E9
          E9FFE8E9E9FFE8E9E9FFE8E9E9FFE8E8E8FFC3CFC4FF328F4BFF2AAC6AFF2AAC
          6AFF2AAB69FF2AAA68FF2AA967FF2AA866FF2AA764FF2AA663FF2AA562FF2AA3
          60FF2AA35EFF2AA15DFF2AA05BFF2A9E59FF2A9D58FF2B9B56FF2A9E59FF289F
          5EFF9CB59DFF6D986DFF29A563FF2B9F5AFF2A9F5BFF2AA15DFF2AA35FFF2AA4
          60FF2AA562FF2AA764FF2AA865FF2AA966FF2B9C59FF729C74FFDEE2DFFFE9EA
          EAFFE9EAEAFFE9EAEAFFE9EAEAFFE9EAEAFFE9EAEAFFE9EAEAFFE8E9E9FFE9EA
          EAFFE9EAEAFFE9EAEAFFE9EAEAFFE9EAEAFFE8E9E9FF88A889FF2AA25FFF2AAE
          6CFF2AAD6BFF2AAC6AFF2AAB69FF2AAA68FF2AA967FF2AA865FF2AA764FF2AA5
          62FF2AA460FF2AA35FFF2AA15DFF2AA05BFF2A9F5AFF2A9D58FF2C9B56FF29A4
          62FF6D986DFF2E7A2EFF2EA969FF31A260FF2EA360FF2BA35FFF2AA460FF2AA6
          63FF2AA764FF2AA866FF2AAA67FF2A9C58FF769E78FFE0E4E0FFEAEBEBFFEAEB
          EBFFEAEBEBFFEAEBEBFFEAEBEBFFEAEBEBFFEAEBEBFFC1CEC2FF97B298FFE9EA
          EAFFEAEBEBFFEAEBEBFFEAEBEBFFEAEBEBFFEAEBEBFFD9DFDAFF478F53FF29AE
          6DFF29AF6EFF2AAE6CFF2AAD6BFF2AAC6AFF2AAB69FF2AAA67FF2AA866FF2AA7
          64FF2AA663FF2AA461FF2AA35FFF2AA25DFF2BA05CFF2EA05DFF31A05DFF2EA8
          67FF2E7A2EFF2C792CFF34A969FF36A766FF36A868FF35A969FF2FA866FF2AA7
          64FF2AA966FF2AAA68FF2AAA68FF3D8847FFD7DED8FFECECECFFECECECFFECEC
          ECFFECECECFFECECECFFECECECFFEBEBEBFFB6C7B7FF38904EFF328F4BFFD0D9
          D0FFECECECFFECECECFFECECECFFECECECFFECECECFFEBECECFFADC0ADFF2B99
          55FF29B06FFF29B06FFF29AF6EFF2AAE6CFF2AAD6BFF2AAC6AFF2AAA68FF2AA9
          66FF2AA764FF2AA663FF2AA461FF2FA562FF35A665FF36A564FF36A462FF34A7
          67FF2C792CFF2C7D30FF39A96AFF3BAA6BFF3BAB6DFF3BAD6FFF3BAE70FF37AE
          70FF30AD6CFF2AAC6AFF2AAD6BFF2A9C58FFAEC1AFFFEDEDEDFFEDEDEDFFEDED
          EDFFEDEDEDFFEDEDEDFFECEDEDFFA9BEAAFF31924FFF29B06FFF29A968FF769E
          78FFEAECEBFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFE9EBE9FF77A0
          7AFF29A866FF29B06FFF29B06FFF29B06FFF29AF6DFF2AAD6BFF2AAC6AFF2AAB
          68FF2AA967FF30AA69FF37AC6DFF3BAC6DFF3BAA6BFF3BA96AFF3BA768FF39A6
          67FF2C7C2FFF2C7D30FF3EA96BFF3FAD70FF3FAF72FF3FB074FF3FB275FF3FB3
          77FF3FB579FF3CB478FF34B274FF2CAF6FFF478F52FFE3E7E3FFEEEFEFFFEEEF
          EFFFEEEFEFFFEBEDECFF9DB69EFF2C9552FF28B271FF28B373FF28B373FF2C97
          53FFC0CDC0FFEEEFEFFFEEEFEFFFEEEFEFFFEEEFEFFFEEEFEFFFEEEFEFFFD6DE
          D6FF3F8E4FFF29AF6EFF29B170FF29B06FFF29B06FFF29AF6EFF2DAF6DFF34B0
          71FF3CB275FF3FB276FF3FB074FF3FAF73FF3FAD70FF3FAC6EFF3FAA6DFF3EA6
          68FF2C7C2FFF2C792CFF42AA6EFF45B176FF45B277FF45B479FF45B57AFF45B7
          7DFF44B87EFF44B980FF43BA81FF42BA80FF39A467FFA5BBA6FFEFF0F0FFF0F0
          F0FFEAECEAFF91AE92FF2A9A57FF28B372FF28B473FF28B473FF28B474FF28B0
          6FFF59945FFFE7EAE7FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFAEC2AEFF299A57FF29B170FF2CB272FF34B476FF3CB77CFF42B97FFF44B8
          7EFF45B77DFF45B57BFF45B47AFF45B278FF45B176FF45AF74FF45AE72FF42A7
          6BFF2C792CFF2E7A2EFF45AA6EFF49B47AFF49B57CFF49B77EFF49B87FFF49B9
          81FF48BB83FF48BC84FF48BC85FF48BC85FF47BC84FF4C935AFFE3E7E3FFE7EB
          E8FF85A786FF36A466FF30B678FF2BB576FF28B474FF28B474FF28B474FF28B4
          75FF2AA05FFFA0B8A0FFF0F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
          F1FFEDEEEDFF769F77FF3EB075FF47BD85FF48BC85FF48BC85FF48BC84FF48BB
          83FF49B981FF49B87FFF49B77EFF49B57CFF49B47AFF49B279FF49B176FF45A7
          6BFF2E7A2EFF6D986DFF47A56AFF4EB77FFF4EB881FF4EBA83FF4EBB84FF4EBD
          86FF4DBE88FF4DBE88FF4DBF88FF4DBF88FF4DBF89FF44AC73FF94B195FF77A0
          79FF43AC74FF4CC18CFF4CC18CFF4CC18CFF4AC18BFF47C089FF45BF88FF44BF
          87FF43BE86FF3E9556FFD6DED6FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
          F2FFF2F2F2FFD9E0D9FF439255FF4CBD87FF4DBF89FF4DBF88FF4DBE88FF4DBE
          88FF4EBD87FF4EBB84FF4EBA83FF4EB881FF4EB77FFF4EB67EFF4EB47CFF47A3
          68FF6D986DFF9CB59DFF479F65FF53BA84FF53BB85FF53BC87FF52BE89FF52BF
          8AFF52BF8BFF52C08BFF52C18CFF52C18DFF51C18DFF50C18CFF389252FF49B2
          7BFF51C38FFF51C38FFF51C390FF51C390FF51C490FF51C491FF50C491FF50C4
          91FF50C491FF4BBA85FF719D73FFEEF0EFFFF3F4F4FFF3F4F4FFF3F4F4FFF3F4
          F4FFF3F4F4FFF3F3F3FFB8C9B8FF409E63FF52C18DFF52C18CFF52C08CFF52C0
          8BFF52BF8AFF52BE89FF53BD87FF53BB85FF53BA84FF53B882FF53B781FF479D
          63FF9CB59DFFC0CEC0FF3C8E4EFF5DBF8CFF58BE8AFF57C08CFF57C18DFF57C1
          8EFF57C28FFF57C28FFF57C390FF56C390FF56C491FF56C491FF55C390FF56C5
          93FF56C693FF56C693FF55C693FF55C794FF55C794FF55C794FF55C895FF55C8
          95FF55C895FF55C895FF45A76EFFB4C6B5FFF4F5F5FFF4F5F5FFF4F5F5FFF4F5
          F5FFF4F5F5FFF4F5F5FFF1F3F2FF89AA8AFF4BB079FF57C390FF57C28FFF57C2
          8FFF57C18EFF57C18EFF57C08CFF58BE8AFF58BD88FF58BB87FF5DBC89FF3C8D
          4DFFC0CEC0FFE2E8E2FF36823DFF65C08FFF5CC08EFF5CC290FF5BC391FF5BC3
          91FF5BC492FF5BC493FF5BC593FF5BC694FF5BC694FF5BC695FF5BC796FF5BC8
          96FF5AC897FF5AC997FF5AC997FF5AC997FF5AC998FF5AC998FF5ACA98FF5ACA
          98FF5ACA98FF5ACA98FF59C795FF449559FFDAE2DBFFF6F6F6FFF6F6F6FFF6F6
          F6FFF6F6F6FFF6F6F6FFF6F6F6FFE8EDE8FF5E9563FF56BC89FF5BC493FF5BC4
          92FF5BC392FF5BC391FF5CC290FF5CC18EFF5CBF8DFF5CBE8BFF65BD8CFF3681
          3DFFE2E8E2FFFAFCFAFF5E8E5FFF63B585FF64C494FF60C594FF60C594FF60C6
          95FF60C796FF60C796FF5FC897FF5FC897FF5FC998FF5FC998FF5FC999FF5FCA
          9AFF5FCA9AFF5FCB9AFF5FCB9BFF5FCB9BFF5FCC9BFF5FCC9CFF5FCC9CFF5FCC
          9CFF5FCC9CFF5FCC9CFF5FCC9CFF58C18FFF729E75FFF0F3F1FFF7F8F8FFF7F8
          F8FFF7F8F8FFF7F8F8FFF7F8F8FFF7F8F8FFD4DED5FF45955AFF5EC594FF60C7
          96FF60C695FF60C594FF60C594FF61C392FF61C291FF64C291FF63B383FF5E8E
          5FFFFAFCFAFFFFFFFFFFAEC2AFFF4E9B63FF76CDA2FF65C798FF65C898FF65C8
          99FF65C99AFF65C99AFF65CA9AFF65CA9BFF65CB9CFF65CB9CFF64CC9DFF64CC
          9DFF64CC9EFF64CD9EFF64CD9FFF64CE9FFF64CE9FFF64CE9FFF64CE9FFF64CE
          9FFF64CE9FFF64CE9FFF64CE9FFF64CE9FFF51B17EFFA4BCA4FFF9F9F9FFF8F8
          F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFB7C9B7FF4BA46CFF65C9
          9AFF65C899FF65C898FF65C798FF65C797FF66C495FF77CA9FFF4E9A62FFAFC2
          AFFFFFFFFFFFFFFFFFFFE9EEE9FF378039FF7AC89FFF6FCB9FFF6ACA9BFF6ACA
          9CFF6ACB9DFF69CB9EFF69CC9EFF69CC9EFF69CD9FFF69CDA0FF68CEA0FF68CE
          A0FF68CEA1FF68CFA2FF68CFA2FF68CFA2FF68CFA2FF68D0A2FF68D0A3FF68D0
          A3FF68D0A3FF68D0A3FF68D0A2FF68D0A2FF68CEA1FF4B9D66FFCFDACFFFFAFA
          FAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFF8F9F8FFB3C6B3FF4A9D65FF68C9
          9BFF6ACA9CFF6ACA9BFF6AC99BFF6AC99BFF70C99CFF7BC69CFF377F39FFE9EE
          E9FFFFFFFFFFFFFFFFFFFEFEFEFF96B096FF5DA574FF87D4AFFF70CC9FFF6FCC
          A0FF6FCDA0FF6ECDA1FF6ECEA1FF6ECEA2FF6ECFA3FF6ECFA3FF6ED0A4FF6ED0
          A4FF6ED0A5FF6ED1A5FF6ED1A6FF6DD1A6FF6DD2A6FF6DD2A7FF6DD2A7FF6DD2
          A7FF6DD2A7FF6DD2A7FF6DD2A7FF6DD2A6FF6DD2A6FF6ACC9FFF559761FFE5EB
          E5FFFBFBFBFFFBFBFBFFFBFBFBFFF8F9F8FFA8BFA9FF50A36EFF6DCC9EFF6ECD
          A0FF6FCCA0FF6FCC9FFF6FCB9FFF70CB9FFF88D3AEFF5DA473FF96B096FFFEFE
          FEFFFFFFFFFFFFFFFFFFFFFFFFFFE3EAE3FF37813CFF86CBA6FF84D4ADFF74CE
          A3FF73CEA4FF73CFA4FF73CFA4FF73D0A5FF73D0A6FF72D1A6FF72D1A7FF72D2
          A8FF72D2A8FF72D2A8FF72D3A9FF72D3A9FF72D4AAFF72D4AAFF72D4AAFF72D4
          AAFF72D4AAFF72D4AAFF72D4AAFF72D4AAFF72D3A9FF72D3A9FF68C497FF76A1
          78FFF5F7F5FFFCFCFCFFF6F8F6FF9BB69BFF56AB78FF72CFA4FF73CFA4FF73CF
          A4FF73CEA3FF74CEA2FF74CDA2FF84D3ACFF86CBA5FF37813CFFE3EAE3FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA9BEA9FF539964FF99DBBBFF83D3
          ADFF78D1A7FF78D1A7FF78D1A8FF78D2A9FF77D2A9FF77D3AAFF77D3AAFF77D4
          ABFF77D4ABFF77D4ACFF77D5ACFF77D6ADFF77D6ADFF77D6ADFF77D6AEFF76D6
          AEFF76D6AEFF77D6AEFF77D6ADFF77D6ADFF77D6ADFF77D5ACFF77D4ACFF63B9
          8BFF97B498FFF1F5F1FF8DAE8EFF5FB282FF78D2A9FF78D1A8FF78D1A7FF78D1
          A7FF78D0A7FF79D0A6FF83D3ACFF99DABAFF539864FFA9BEA9FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F6F3FF5E8F5FFF79B991FFA0DE
          C0FF85D5AFFF7DD3AAFF7DD3ABFF7DD4ACFF7CD4ACFF7CD5ADFF7CD5AEFF7CD5
          AEFF7CD6AFFF7CD6AFFF7CD7B0FF7CD7B0FF7BD8B1FF7BD8B1FF7BD8B1FF7BD8
          B1FF7BD8B1FF7BD8B1FF7BD8B1FF7BD8B1FF7CD7B0FF7CD7B0FF7CD6B0FF7BD6
          AEFF5AAA79FF58915BFF67BA8DFF7CD4ACFF7CD4ACFF7DD3ABFF7DD3ABFF7DD2
          ABFF7DD2AAFF85D4AEFFA0DEC0FF79B891FF5F8F5FFFF3F6F3FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCE4DCFF3C8240FF91CD
          ACFFA6E1C5FF89D7B3FF81D5AFFF81D5AFFF81D6B0FF81D6B0FF81D6B1FF81D7
          B1FF80D8B2FF80D8B2FF80D9B3FF80D9B3FF80D9B4FF80DAB4FF80DAB5FF80DA
          B5FF80DAB5FF80DAB5FF80DAB4FF80D9B4FF80D9B3FF80D9B3FF80D8B2FF80D8
          B2FF7FD5AFFF75C89FFF81D6B0FF81D6B0FF81D6AFFF81D5AFFF81D5AEFF81D4
          AEFF8AD6B2FFA6E0C5FF91CCABFF3C823FFFDCE4DCFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFCDBFFF3F87
          49FF9ED6B9FFACE4CBFF92DBB9FF86D7B2FF86D8B3FF86D8B4FF86D8B4FF86D9
          B5FF85D9B5FF85DAB6FF85DBB6FF85DBB7FF85DBB7FF85DCB8FF85DCB8FF85DC
          B8FF85DCB8FF85DCB8FF85DCB8FF85DBB8FF85DBB7FF85DBB6FF85DAB6FF85D9
          B5FF86D9B5FF86D8B4FF86D8B4FF86D8B3FF86D7B3FF87D7B2FF87D6B1FF92DA
          B8FFACE3CAFF9ED5B8FF3F8748FFBFCDBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFAFC3
          AFFF478B50FFA3D8BDFFB4E6D0FFA0DFC3FF8CD9B7FF8BD9B7FF8BDAB7FF8ADA
          B8FF8ADBB8FF8ADBB8FF8ADCB9FF8ADCB9FF8ADDBAFF8ADDBBFF8ADEBBFF8ADE
          BCFF8ADEBCFF8ADEBBFF8ADDBBFF8ADDBAFF8ADCBAFF8ADCB9FF8ADBB8FF8ADB
          B8FF8ADAB8FF8BDAB7FF8BD9B7FF8BD9B6FF8BD9B6FF8CD9B6FFA0DFC2FFB4E6
          CFFFA3D7BCFF478B50FFAFC3AFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFD
          FCFFB0C3B0FF42884BFFA0D3B7FFBBE9D5FFB1E6CEFF99DEBFFF90DCBAFF90DC
          BAFF8FDCBBFF8FDDBBFF8FDDBCFF8FDEBCFF8FDEBDFF8FDEBEFF8FDFBEFF8FE0
          BEFF8FE0BFFF8FDFBEFF8FDFBEFF8FDEBDFF8FDEBCFF8FDDBCFF8FDDBBFF8FDC
          BBFF90DCBAFF90DCBAFF90DBBAFF90DBB9FF99DEBEFFB1E5CEFFBBE9D4FFA0D2
          B6FF42884AFFB0C3B0FFFCFDFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFEFEFEFFBFCEBFFF3E8342FF8EC1A2FFBEEAD6FFBFEBD8FFAFE6CEFF9CE0
          C3FF94DEBEFF94DFBFFF94DFBFFF94DFC0FF93E0C0FF93E0C0FF93E0C0FF93E0
          C1FF93E0C1FF93E0C0FF93E0C0FF93E0C0FF94DFC0FF94DFBFFF94DFBFFF94DE
          BEFF94DEBEFF94DDBDFF9CDFC2FFAFE5CDFFBFEBD8FFBEE9D6FF8FC1A2FF3E83
          42FFBFCEBFFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFDCE4DCFF5F8F60FF66A174FFB2DEC7FFC6EDDDFFC5ED
          DCFFBAE9D5FFA8E4CAFF9CE1C3FF99E1C2FF99E1C2FF98E1C3FF98E1C3FF98E2
          C3FF98E2C3FF98E1C3FF98E1C3FF99E1C2FF99E1C2FF99E0C2FF99E0C1FF9CE0
          C3FFA8E4CAFFBAE9D5FFC5ECDBFFC6ECDCFFB2DDC7FF66A073FF5F8F60FFDCE4
          DCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F6F3FFA9BEA9FF3C8341FF82B491FFBBE3
          CFFFCCEFE0FFCCEFE0FFC8EEDFFFC1ECDAFFB7EAD4FFAFE7CFFFA7E5CCFFA3E4
          CAFFA1E3C9FFA1E3C9FFA3E4C9FFA8E5CBFFB0E7CFFFB7E9D4FFC1ECD9FFC8EE
          DEFFCCEFE0FFCCEFE0FFBBE2CEFF82B391FF3C8341FFA9BEA9FFF3F6F3FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE3E9E3FF95B095FF3A81
          3DFF7AAD88FFACD4BEFFC7EBDAFFD1F2E4FFD1F1E3FFD1F1E4FFD0F1E4FFD0F1
          E4FFD0F1E4FFD0F1E4FFD0F1E4FFD0F1E3FFD1F1E3FFD1F1E3FFD1F1E4FFC7EB
          DAFFACD4BEFF7AAD88FF3A813DFF95B095FFE3E9E3FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFE9EE
          E9FFAEC2AFFF5E8F5FFF48884EFF6CA478FF9AC3A8FFADD6BEFFC1E5D3FFCBEA
          DCFFCDEBDDFFCDEBDDFFCBEADBFFC1E5D3FFADD6BEFF9AC2A8FF6CA478FF4888
          4EFF5E8F5FFFAEC2AFFFE9EEE9FFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFAFCFAFFE2E8E2FFC0CFC0FF9CB59CFF6C986CFF2A7929FF2678
          25FF2F7D2FFF2F7D2FFF267826FF2A7929FF6C986CFF9CB59CFFC0CFC0FFE2E8
          E2FFFAFCFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF}
      end
      object btnCancel: TBitBtn
        Left = 905
        Top = 8
        Width = 138
        Height = 57
        Anchors = [akTop, akRight]
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
        OnClick = btnCancelClick
        Glyph.Data = {
          42240000424D4224000000000000420000002800000030000000300000000100
          20000300000000240000130B0000130B000000000000000000000000FF0000FF
          0000FF000000F0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFEFEFEFFFE2E2E5FFCECED6FFBBBBCAFFB0B0
          C1FFA6A6BCFFA6A6BCFFAEAEC0FFBABAC8FFCCCCD4FFE0E0E3FFEEEEEEFFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFEDEDEDFFCCCCD6FF9B9BB5FF5A5A94FF161683FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF191984FF545490FF9797
          B1FFCACAD4FFECECEDFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFE6E6E9FFAFAF
          C3FF555593FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF555592FFB0B0C3FFE8E8EAFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFEBEBECFFB1B1C3FF40408BFF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF46468DFFB3B3C5FFECECEDFFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFD2D2DAFF626298FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF67679AFFD5D5DCFFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFEFEFEFFFB0B0C3FF232385FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF272785FFB4B4
          C5FFEFEFEFFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFEDEDEEFF9393B1FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF9999B4FFEDEDEEFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFECEC
          EDFF8787AAFF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF8D8DADFFEDEDEEFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFEEEEEFFF9292
          B0FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B83FF0B0B83FF0B0B83FF0B0B83FF0B0B
          83FF0B0B84FF0B0B84FF0B0B84FF0B0B84FF0B0B84FF0B0B83FF0B0B83FF0B0B
          83FF0B0B83FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF9898B4FFEFEFEFFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFADADC1FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B
          82FF0B0B83FF0B0B83FF0C0C84FF0C0C84FF0C0C85FF0C0C85FF0C0C85FF0C0C
          85FF0C0C85FF0C0C85FF0C0C85FF0C0C85FF0C0C85FF0C0C85FF0C0C85FF0C0C
          85FF0C0C85FF0C0C84FF0C0C84FF0B0B83FF0B0B83FF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FFB2B2C4FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFCFCFD8FF1F1F84FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B82FF0B0B83FF0B0B84FF0C0C
          84FF0C0C85FF0C0C85FF0C0C86FF0C0C86FF0C0C86FF0C0C87FF0C0C87FF0C0C
          87FF0C0C87FF0C0C87FF0C0C87FF0C0C87FF0C0C87FF0C0C87FF0C0C87FF0C0C
          87FF0C0C86FF0C0C86FF0C0C86FF0C0C85FF0C0C85FF0C0C84FF0B0B83FF0B0B
          83FF0B0B82FF0B0B82FF0B0B82FF232385FFD3D3DBFFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFEAEAEBFF5B5B95FF0B0B82FF0B0B
          82FF0B0B82FF0B0B82FF0B0B82FF0B0B83FF0C0C84FF0C0C85FF0C0C85FF0C0C
          86FF0D0D8AFF0E0E8FFF0E0E8DFF0D0D89FF0D0D88FF0D0D88FF0D0D88FF0D0D
          89FF0D0D89FF0D0D89FF0D0D89FF0D0D89FF0D0D89FF0D0D89FF0D0D89FF0E0E
          8DFF0E0E90FF0E0E8CFF0D0D88FF0C0C87FF0C0C86FF0C0C86FF0C0C85FF0C0C
          84FF0B0B84FF0B0B83FF0B0B82FF0B0B82FF636398FFEBEBECFFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFABABBFFF0B0B82FF0B0B82FF0B0B
          82FF0B0B82FF0B0B83FF0C0C84FF0C0C85FF0C0C86FF0C0C86FF0C0C87FF1212
          8FFF8F8FB0FFD0D0D9FFBDBDCBFF474797FF0E0E8CFF0D0D8AFF0D0D8AFF0D0D
          8AFF0E0E8BFF0E0E8BFF0E0E8BFF0E0E8BFF0E0E8BFF0E0E8CFF2C2C93FFAEAE
          C2FFD2D2DAFFA6A6BDFF1E1E91FF0D0D89FF0D0D88FF0D0D87FF0C0C87FF0C0C
          86FF0C0C85FF0C0C85FF0C0C84FF0B0B83FF0B0B82FFB0B0C3FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFE4E4E7FF363689FF0B0B82FF0B0B82FF0B0B
          83FF0C0C84FF0C0C85FF0C0C86FF0C0C86FF0C0C87FF0D0D88FF121290FFA1A1
          B9FFFCFCFCFFFFFFFFFFFFFFFFFFE4E4E8FF4E4E9BFF0F0F8EFF0E0E8CFF0E0E
          8CFF0E0E8CFF0E0E8CFF0E0E8CFF0E0E8CFF0E0E8EFF2E2E96FFD0D0D8FFFFFF
          FFFFFFFFFFFFFFFFFFFFBFBFCDFF1F1F93FF0D0D8AFF0D0D89FF0D0D88FF0D0D
          88FF0C0C87FF0C0C86FF0C0C85FF0C0C85FF0B0B84FF40408CFFE7E7E9FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFAAAABFFF0B0B82FF0B0B82FF0B0B83FF0C0C
          84FF0C0C85FF0C0C86FF0C0C87FF0D0D88FF0D0D89FF11118FFFA0A0B9FFFCFC
          FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4E8FF4E4E9BFF0F0F90FF0E0E
          8EFF0F0F8EFF0F0F8EFF0F0F8EFF0F0F8FFF2E2E96FFD0D0D8FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFCCFF1D1D92FF0E0E8BFF0D0D8AFF0D0D
          89FF0D0D88FF0D0D88FF0C0C87FF0C0C86FF0C0C85FF0C0C84FFB0B0C3FFF0F0
          F0FFF0F0F0FFF0F0F0FFECECEDFF4C4C8FFF0B0B83FF0B0B84FF0C0C85FF0C0C
          86FF0C0C87FF0D0D88FF0D0D88FF0D0D89FF0E0E8BFF60609DFFFBFBFBFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4E8FF4E4E9CFF1010
          91FF0F0F90FF0F0F90FF0F0F91FF2E2E97FFD0D0D8FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9090B2FF0F0F8EFF0E0E8BFF0E0E
          8BFF0D0D8AFF0D0D89FF0D0D88FF0D0D88FF0C0C87FF0C0C86FF565695FFEDED
          EEFFF0F0F0FFF0F0F0FFCACAD5FF0B0B83FF0C0C84FF0C0C85FF0C0C86FF0D0D
          87FF0D0D88FF0D0D89FF0D0D8AFF0E0E8BFF0E0E8DFF8787AEFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4E8FF4E4E
          9CFF101093FF101093FF2E2E98FFD0D0D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB1B1C6FF0F0F91FF0E0E8DFF0E0E
          8CFF0E0E8CFF0E0E8BFF0D0D8AFF0D0D89FF0D0D88FF0C0C87FF0C0C86FFCFCF
          D8FFF0F0F0FFF0F0F0FF9999B5FF0C0C84FF0C0C85FF0C0C87FF0D0D88FF0D0D
          88FF0D0D8AFF0E0E8BFF0E0E8BFF0E0E8CFF0E0E8EFF434396FFEFEFF0FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4
          E8FF4E4E9EFF2E2E9AFFD0D0D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9FAFF7171A4FF0F0F91FF0F0F8EFF0E0E
          8EFF0E0E8DFF0E0E8CFF0E0E8BFF0D0D8AFF0D0D89FF0D0D88FF0D0D87FF9F9F
          BAFFF0F0F0FFEFEFEFFF575795FF0C0C86FF0C0C87FF0D0D88FF0D0D89FF0D0D
          8AFF0E0E8BFF0E0E8CFF0E0E8DFF0E0E8EFF0F0F8FFF101092FF7272A6FFF2F2
          F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFE4E4E8FFD2D2DAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFAFAFAFF9494B4FF121295FF0F0F91FF0F0F90FF0F0F
          8FFF0F0F8EFF0E0E8EFF0E0E8DFF0E0E8CFF0E0E8BFF0D0D8AFF0D0D89FF6262
          9CFFEFEFEFFFE2E2E6FF141487FF0C0C87FF0D0D88FF0D0D89FF0D0D8AFF0E0E
          8BFF0E0E8CFF0E0E8DFF0F0F8EFF0F0F8FFF0F0F90FF0F0F91FF111195FF7272
          A6FFF2F2F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFAFAFAFF9494B4FF121297FF101093FF101092FF101092FF0F0F
          91FF0F0F90FF0F0F8FFF0F0F8EFF0E0E8DFF0E0E8CFF0E0E8BFF0D0D8AFF1B1B
          8AFFE6E6E9FFCECED8FF0C0C87FF0D0D88FF0D0D89FF0D0D8AFF0E0E8CFF0E0E
          8DFF0E0E8EFF0F0F8FFF0F0F90FF0F0F91FF101092FF101092FF101093FF1111
          96FF7272A6FFF2F2F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFAFAFAFF9494B4FF131399FF111195FF101094FF101094FF101093FF1010
          92FF101091FF0F0F90FF0F0F8FFF0F0F8EFF0E0E8EFF0E0E8CFF0E0E8BFF0D0D
          8AFFD2D2DBFFBCBCCCFF0D0D88FF0D0D89FF0D0D8AFF0E0E8CFF0E0E8DFF0F0F
          8EFF0F0F8FFF0F0F90FF0F0F91FF101092FF101093FF101094FF111195FF1111
          96FF111198FF7272A7FFF2F2F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFA
          FAFF9494B4FF13139AFF111198FF111197FF111196FF111195FF101094FF1010
          94FF101093FF101092FF0F0F91FF0F0F90FF0F0F8FFF0E0E8EFF0E0E8DFF0E0E
          8BFFC1C1D0FFB0B0C4FF0D0D89FF0D0D8AFF0E0E8CFF0E0E8DFF0F0F8EFF0F0F
          8FFF0F0F90FF101091FF101093FF101094FF101094FF111195FF111196FF1111
          97FF111198FF12129AFF7272A7FFF2F2F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFF9494
          B4FF13139CFF12129AFF121299FF121298FF111198FF111197FF111196FF1111
          95FF101094FF101093FF101092FF0F0F91FF0F0F90FF0F0F8FFF0E0E8EFF0E0E
          8DFFB4B4C8FFA4A4BEFF0D0D8AFF0E0E8CFF0E0E8DFF0F0F8EFF0F0F8FFF0F0F
          90FF101092FF101093FF101094FF111195FF111196FF111197FF111198FF1212
          99FF121299FF12129AFF12129CFF7878A7FFFBFBFBFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA1A1B9FF1414
          9EFF13139CFF12129BFF12129BFF12129AFF121299FF121298FF111198FF1111
          97FF111196FF111195FF101094FF101093FF101091FF0F0F90FF0F0F8FFF0F0F
          8EFFB0B0C6FFA3A3BEFF222295FF0E0E8DFF0F0F8EFF0F0F8FFF0F0F90FF1010
          92FF101093FF101094FF111195FF111196FF111197FF121298FF121299FF1212
          9AFF12129BFF13139CFF2E2E9BFFD0D0D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4E8FF4E4E
          9FFF13139DFF13139DFF13139CFF12129BFF12129BFF12129AFF121299FF1212
          98FF111197FF111196FF111195FF101094FF101093FF101091FF0F0F90FF1A1A
          94FFB0B0C7FFB0B0C5FF2E2E9BFF0E0E8EFF0F0F8FFF0F0F90FF101092FF1010
          93FF101094FF111195FF111196FF111198FF121299FF12129AFF12129BFF1212
          9BFF13139CFF2E2E9BFFD0D0D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4
          E8FF4E4E9FFF13139EFF13139EFF13139DFF13139CFF12129BFF12129AFF1212
          9AFF121298FF111197FF111196FF111195FF101094FF101093FF101092FF2B2B
          9EFFB3B3C9FFBCBCCDFF3333A1FF10108FFF0F0F90FF101091FF101093FF1010
          94FF111195FF111196FF111198FF121299FF12129AFF12129BFF13139CFF1313
          9DFF2F2F9BFFD0D0D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFE4E4E8FF4E4E9FFF14149FFF13139FFF13139EFF13139DFF13139CFF1212
          9BFF12129AFF121299FF111197FF111196FF111195FF101094FF131393FF3838
          A4FFBFBFD0FFCCCCD8FF4040A5FF1D1D95FF0F0F91FF101093FF101094FF1111
          95FF111196FF111198FF121299FF12129AFF12129BFF13139CFF13139DFF2F2F
          9BFFD0D0D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFE4E4E8FF4E4E9FFF14149FFF14149FFF13139EFF13139DFF1313
          9CFF12129BFF12129AFF121299FF111197FF111196FF111195FF2A2A9EFF3636
          A3FFCFCFDBFFE0E0E5FF282897FF4646ABFF101092FF101094FF111195FF1111
          96FF111198FF121299FF12129AFF12129BFF13139DFF13139DFF2F2F9AFFD0D0
          D8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFAFAFBFFF4F4F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFE4E4E8FF4E4E9FFF1414A0FF14149FFF13139FFF1313
          9EFF13139CFF12129BFF12129AFF121299FF111197FF111196FF4C4CB1FF2222
          97FFE3E3E7FFEFEFEFFF53539DFF5555B7FF101093FF101094FF111196FF1111
          97FF121299FF12129AFF12129BFF13139DFF13139EFF1F1F9BFFCCCCD5FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFA
          FAFF9494B5FF7272A8FFF2F2F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFE3E3E6FF3F3F9DFF1414A1FF1414A0FF1313
          9FFF13139EFF13139CFF12129BFF12129AFF121298FF111197FF5656BAFF5858
          A1FFEFEFEFFFF0F0F0FF9595B9FF5D5DBEFF111194FF111195FF111197FF1212
          98FF12129AFF12129BFF13139CFF13139EFF13139FFF7777A7FFFEFEFEFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFF9494
          B5FF1717A6FF1616A7FF7272AAFFF2F2F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA5A5BEFF1414A1FF1414A1FF1414
          A0FF13139FFF13139DFF13139CFF12129BFF121299FF141499FF5E5EC0FF9898
          BCFFF0F0F0FFF0F0F0FFC7C7D5FF5353B4FF4040A9FF111196FF111198FF1212
          99FF12129BFF13139CFF13139DFF13139FFF14149FFF7D7DAAFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFF9494B5FF1717
          A7FF1717AAFF1717ABFF1616A9FF7272AAFFF2F2F3FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAAAAC2FF1515A2FF1515A2FF1414
          A1FF1414A0FF13139FFF13139DFF13139CFF12129AFF4B4BB2FF4848B0FFC9C9
          D7FFF0F0F0FFF0F0F0FFEBEBECFF48489FFF6B6BCAFF111197FF121299FF1212
          9AFF12129BFF13139DFF13139EFF1414A0FF1414A1FF27279CFFD7D7DDFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFF9494B5FF1717A8FF1717
          ACFF1717ACFF1717ACFF1717ADFF1717AAFF7272AAFFF2F2F3FFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFEAEAECFF4D4DA0FF1515A4FF1515A4FF1414
          A2FF1414A1FF14149FFF13139EFF13139DFF12129BFF6B6BCCFF4949A2FFEBEB
          EDFFF0F0F0FFF0F0F0FFF0F0F0FFA4A4C2FF6B6BC9FF3333A4FF121299FF1212
          9BFF13139CFF13139EFF14149FFF1414A1FF1414A2FF1515A3FF3B3B9DFFD9D9
          DFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAFF9494B5FF1717A8FF1818ADFF1818
          AEFF1818AEFF1818AEFF1818AEFF1818AEFF1717ABFF7272AAFFF2F2F3FFFFFF
          FFFFFFFFFFFFFFFFFFFFEBEBEDFF5D5DA3FF1616A6FF1616A6FF1515A4FF1515
          A3FF1414A2FF1414A0FF14149FFF13139EFF3D3DACFF6565C6FFA5A5C4FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFE1E1E7FF4242A4FF7474D2FF12129AFF1313
          9CFF13139DFF13139FFF1414A0FF1414A2FF1515A3FF1515A4FF1515A5FF3B3B
          9EFFD3D3D9FFFBFBFBFFF1F1F2FF9191B3FF1717A8FF1818AEFF1818AEFF1818
          AFFF1818B0FF1818B0FF1919B0FF1818B0FF1818AFFF1717ACFF7272AAFFE8E8
          EAFFFBFBFBFFE3E3E6FF5D5DA4FF1616A7FF1616A8FF1616A7FF1616A6FF1515
          A4FF1515A3FF1414A1FF1414A0FF13139EFF7676D6FF3B3BA5FFE1E1E7FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFA4A4C4FF6C6CCBFF4F4FB6FF1313
          9CFF13139EFF14149FFF1414A1FF1515A2FF1515A4FF1515A5FF1616A7FF1616
          A7FF1B1BA1FF4E4E9FFF3535A0FF1717AAFF1818AEFF1818AFFF1919B0FF1919
          B1FF1919B1FF1919B2FF1919B2FF1919B2FF1919B1FF1919B0FF1818ADFF2929
          A2FF5252A2FF2424A2FF1717AAFF1717ABFF1717A9FF1616A8FF1616A7FF1515
          A5FF1515A4FF1414A2FF1414A1FF5757BEFF6666C8FFA4A4C5FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFE8E8EBFF5757A8FF8282DFFF2A2A
          A4FF13139FFF1414A0FF1414A2FF1515A3FF1515A5FF1616A6FF1616A8FF1717
          A9FF1717AAFF1717ABFF1818ADFF1818AEFF1818AFFF1919B1FF1919B2FF1919
          B2FF1919B3FF1A1AB3FF1A1AB3FF1A1AB3FF1919B3FF1919B2FF1919B1FF1919
          B0FF1818AFFF1818AEFF1818ADFF1717ACFF1717AAFF1616A9FF1616A7FF1616
          A6FF1515A4FF1515A3FF3333ABFF8181DFFF5252A9FFE8E8EBFFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFCACAD9FF4B4BB3FF8080
          DDFF1A1AA1FF1414A1FF1515A2FF1515A4FF1515A5FF1616A7FF1616A9FF1717
          AAFF1717ABFF1818ADFF1818AEFF1818AFFF1919B1FF1919B2FF1919B3FF1A1A
          B4FF1A1AB4FF1A1AB5FF1A1AB5FF1A1AB5FF1A1AB4FF1A1AB4FF1919B3FF1919
          B2FF1919B1FF1818AFFF1818AEFF1818ADFF1717ABFF1717AAFF1616A8FF1616
          A7FF1515A5FF1F1FA6FF8383E1FF4343B1FFC8C8D9FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFA4A4C6FF6363
          C5FF7979D8FF1818A2FF1515A3FF1515A4FF1616A6FF1616A8FF1717A9FF1717
          ABFF1717ACFF1818AEFF1818AFFF1919B1FF1919B2FF1919B3FF1A1AB4FF1A1A
          B5FF1A1AB6FF1B1BB7FF1B1BB7FF1A1AB6FF1A1AB6FF1A1AB5FF1A1AB4FF1919
          B3FF1919B2FF1919B0FF1818AFFF1818AEFF1717ACFF1717AAFF1717A9FF1616
          A7FF1B1BA7FF7E7EDDFF5C5CC3FFA1A1C6FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFEDEDEEFF8888
          BAFF7070D1FF7979D9FF1B1BA5FF1515A5FF1616A7FF1616A8FF1717AAFF1717
          ABFF1818ADFF1818AEFF1919B0FF1919B2FF1919B3FF1A1AB4FF1A1AB6FF1B1B
          B7FF1B1BB8FF1B1BB8FF1B1BB8FF1B1BB8FF1B1BB8FF1B1BB7FF1A1AB5FF1A1A
          B4FF1919B3FF1919B1FF1919B0FF1818AEFF1818ADFF1717ABFF1717A9FF1E1E
          AAFF7E7EDEFF6A6ACEFF8282BAFFEDEDEEFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFEAEA
          ECFF7E7EB7FF7171D2FF8383E1FF2A2AABFF1616A7FF1616A9FF1717AAFF1717
          ACFF1818AEFF1818AFFF1919B1FF1919B2FF1A1AB4FF1A1AB5FF1B1BB7FF1B1B
          B8FF1B1BB9FF1B1BBAFF1C1CBAFF1B1BBAFF1B1BB9FF1B1BB8FF1B1BB7FF1A1A
          B5FF1A1AB3FF1919B2FF1919B0FF1818AFFF1818ADFF1717ACFF3030B1FF8686
          E5FF6B6BCFFF7B7BB9FFE9E9ECFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFEAEAEDFF8989BDFF6464C9FF8F8FEBFF4D4DBDFF1616A9FF1717ABFF1717
          ACFF1818AEFF1818AFFF1919B1FF1919B3FF1A1AB4FF1A1AB6FF1B1BB8FF1B1B
          B9FF1C1CBAFF1C1CBBFF1C1CBCFF1C1CBBFF1C1CBAFF1B1BB9FF1B1BB7FF1A1A
          B6FF1A1AB4FF1919B3FF1919B1FF1818AFFF1818AEFF5252C2FF9090EDFF5E5E
          C8FF8181BDFFE9E9ECFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFEEEEEFFFA5A5C9FF4D4DBBFF9090ECFF7979DBFF3030B2FF1818
          ADFF1818AEFF1919B0FF1919B2FF1A1AB3FF1A1AB5FF1B1BB7FF1B1BB8FF1B1B
          BAFF1C1CBBFF1C1CBDFF1D1DBDFF1C1CBCFF1C1CBBFF1B1BB9FF1B1BB8FF1A1A
          B6FF1A1AB5FF1919B3FF1919B1FF3636B8FF7D7DDFFF8D8DEAFF4747BAFF9E9E
          C9FFEDEDEEFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFCACADCFF5A5AB3FF7171D5FF9595F1FF7575
          D8FF3838B8FF1919B0FF1919B2FF1A1AB3FF1A1AB5FF1B1BB7FF1B1BB8FF1C1C
          BAFF1C1CBCFF1D1DBDFF1D1DBEFF1C1CBDFF1C1CBCFF1B1BBAFF1B1BB8FF1B1B
          B6FF1A1AB5FF3D3DBEFF7777DCFF9595F1FF6D6DD4FF5151B5FFC6C6DBFFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFE8E8ECFFA6A6CCFF4646B6FF7676
          D9FF9696F2FF8787E6FF6565D0FF3B3BBDFF1C1CB5FF1B1BB6FF1B1BB8FF1B1B
          BAFF1C1CBBFF1C1CBCFF1C1CBDFF1C1CBCFF1C1CBBFF1D1DBAFF3E3EC2FF6868
          D4FF8989E9FF9696F2FF7373D9FF3D3DB7FF9E9ECBFFE6E6EBFFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFE2E2E9FFA6A6
          CDFF4E4EB7FF5F5FCCFF8282E3FF9797F3FF9595F2FF8787E8FF7C7CE0FF7171
          DBFF6C6CD8FF6C6CD9FF7272DCFF7D7DE2FF8888E9FF9696F3FF9696F3FF8181
          E3FF5D5DCDFF4444B8FFA0A0CDFFDFDFE7FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFEBEBEDFFC7C7DCFF9696C9FF5555BAFF4444C0FF5D5DCEFF6F6FD8FF7676
          DDFF7C7CE0FF7B7BE1FF7676DEFF6E6ED9FF5C5CCFFF4242C2FF4F4FBCFF9090
          CAFFC4C4DCFFE9E9EDFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFEFEFEFFFE0E0E8FFCCCCE0FFBBBBD9FFACAC
          D4FFA2A2D1FFA1A1D1FFAAAAD4FFBABADAFFC9C9DFFFDEDEE8FFEEEEEFFFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
          F0FFF0F0F0FF}
      end
    end
    object pnlTelemedTimeAmount: TPanel
      Left = 527
      Top = 437
      Width = 641
      Height = 108
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 8
      Visible = False
      DesignSize = (
        641
        108)
      object rgTelemedTimeAmount: TRadioGroup
        Left = 10
        Top = 5
        Width = 263
        Height = 92
        Caption = 'TELEPHONE AUDIO ONLY Time Amount'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Items.Strings = (
          '  5 - 10 minutes (99441)'
          '11 - 20 minutes (99442)'
          '21 - 30 minutes (99443) ')
        ParentFont = False
        TabOrder = 0
        OnClick = rgTelemedTimeAmountClick
      end
      object memTelemedTimeAmount: TMemo
        Left = 279
        Top = 8
        Width = 354
        Height = 73
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clSkyBlue
        ReadOnly = True
        TabOrder = 1
      end
      object btnTeleMedRefresh: TButton
        Left = 558
        Top = 87
        Width = 75
        Height = 16
        Anchors = [akTop, akRight]
        Caption = 'Refresh'
        TabOrder = 2
        OnClick = btnTeleMedRefreshClick
      end
    end
    object pnlNewCPE: TPanel
      Left = 471
      Top = 551
      Width = 641
      Height = 127
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 9
      Visible = False
      DesignSize = (
        641
        127)
      object rgNewCPE: TRadioGroup
        Left = 10
        Top = 5
        Width = 263
        Height = 116
        Caption = 'NEW PATIENT CPE'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Items.Strings = (
          '12 - 17 yrs            - 99384  '
          '18 - 39 yrs            - 99385'
          '40 - 64 yrs            - 99386'
          '65+  yrs                - 99387'
          'Initial Medicare AWV   - G0438'
          'Subq.Medicare AWV   - G0439'
          'Welcome to Medicare -  G0402')
        ParentFont = False
        TabOrder = 0
        OnClick = rgNewCPEClick
      end
      object memNewCPE: TMemo
        Left = 279
        Top = 8
        Width = 354
        Height = 114
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clSkyBlue
        Lines.Strings = (
          'NOTES:'
          ' -- For age 12-17 yrs, use Dx: Z00.129')
        ReadOnly = True
        TabOrder = 1
      end
    end
    object pnlOldCPE: TPanel
      Left = 471
      Top = 625
      Width = 641
      Height = 131
      Color = clSkyBlue
      ParentBackground = False
      TabOrder = 10
      Visible = False
      DesignSize = (
        641
        131)
      object rgOldCPE: TRadioGroup
        Left = 10
        Top = 5
        Width = 263
        Height = 116
        Caption = 'ESTABLISHED PATIENT CPE'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Items.Strings = (
          '12 - 17 yrs                  - 99394  '
          '18 - 39 yrs                  - 99395'
          '40 - 64 yrs                  - 99396'
          '65+  yrs                      - 99397'
          'Initial Medicare AWV   - G0438'
          'Subq.Medicare AWV    - G0439'
          'Welcome to Medicare -  G0402')
        ParentFont = False
        TabOrder = 0
        OnClick = rgOldCPEClick
      end
      object memOldCPE: TMemo
        Left = 279
        Top = 8
        Width = 354
        Height = 114
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clSkyBlue
        Lines.Strings = (
          'NOTES:'
          ' -- For age 12-17 yrs, use Dx: Z00.129')
        ReadOnly = True
        TabOrder = 1
      end
    end
  end
end
