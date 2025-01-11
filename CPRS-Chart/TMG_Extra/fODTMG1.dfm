inherited frmODTMG1: TfrmODTMG1
  Width = 1081
  Height = 700
  BorderIcons = []
  Caption = 'TMG Lab / Procedure Orders'
  Constraints.MinHeight = 700
  Constraints.MinWidth = 520
  ExplicitWidth = 1081
  ExplicitHeight = 700
  PixelsPerInch = 96
  TextHeight = 13
  inherited lblOrderSig: TLabel
    Top = 562
    Anchors = [akLeft, akBottom]
    ExplicitTop = 568
  end
  inherited memOrder: TCaptionMemo
    Left = 8
    Top = 581
    Width = 948
    Height = 73
    Anchors = [akLeft, akRight, akBottom]
    ExplicitLeft = 8
    ExplicitTop = 581
    ExplicitWidth = 948
    ExplicitHeight = 73
  end
  object btnClear: TButton [2]
    Left = 962
    Top = 633
    Width = 95
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 7
    OnClick = btnClearClick
  end
  inherited sbxMain: TScrollBox
    Top = -1
    Width = 1073
    Height = 541
    Align = alNone
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    ExplicitTop = -1
    ExplicitWidth = 1073
    ExplicitHeight = 541
    object lblWhen: TLabel
      Left = 878
      Top = 161
      Width = 32
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'When:'
      Enabled = False
      ExplicitLeft = 618
    end
    object rgGetLabsTiming: TRadioGroup
      Left = 876
      Top = 67
      Width = 178
      Height = 88
      Anchors = [akTop, akRight]
      Caption = 'Get Labs ...'
      Items.Strings = (
        'Entries will go here...')
      TabOrder = 0
      OnClick = rgClick
    end
    object cklbOther: TCheckListBox
      Left = 892
      Top = 201
      Width = 176
      Height = 59
      Anchors = [akRight, akBottom]
      BevelEdges = []
      BorderStyle = bsNone
      Color = clBtnFace
      ItemHeight = 13
      Items.Strings = (
        'Entries will go here...')
      TabOrder = 1
      OnClick = cklbCommonClick
    end
    object pnlFlags: TPanel
      Left = 876
      Top = 180
      Width = 176
      Height = 151
      Anchors = [akTop, akRight, akBottom]
      BevelInner = bvLowered
      TabOrder = 2
      object cklbFlags: TCheckListBox
        Left = 5
        Top = 5
        Width = 124
        Height = 41
        BevelOuter = bvRaised
        BorderStyle = bsNone
        Color = clBtnFace
        ItemHeight = 13
        Items.Strings = (
          'Entries will go here...')
        TabOrder = 0
        OnClick = cklbCommonClick
      end
    end
    object rgProvider: TRadioGroup
      Left = 876
      Top = 5
      Width = 176
      Height = 56
      Anchors = [akTop, akRight]
      Caption = 'Set Provider...'
      Items.Strings = (
        'Enteries will go here...')
      TabOrder = 3
      OnClick = rgClick
    end
    object edtOtherTime: TEdit
      Left = 913
      Top = 157
      Width = 138
      Height = 21
      Anchors = [akTop, akRight]
      Enabled = False
      TabOrder = 4
      Text = '<date/time>'
      Visible = False
      OnChange = edtEditChange
    end
    object pnlOrderAreaMain: TPanel
      Left = 7
      Top = 5
      Width = 863
      Height = 526
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 5
      object splitterleft: TSplitter
        Left = 321
        Top = 1
        Width = 5
        Height = 524
        ExplicitLeft = 481
        ExplicitHeight = 275
      end
      object pnlOrderAreaLeft: TPanel
        Left = 1
        Top = 1
        Width = 320
        Height = 524
        Align = alLeft
        TabOrder = 0
        object splitterLeftPanel: TSplitter
          Left = 1
          Top = 491
          Width = 318
          Height = 5
          Cursor = crVSplit
          Align = alTop
          ExplicitTop = 374
        end
        object btnToggleSpecialProc: TSpeedButton
          Left = 1
          Top = 503
          Width = 318
          Height = 20
          Align = alBottom
          Caption = 'CLOSE  Custom Lab / Procedure'
          Glyph.Data = {
            3E010000424D3E010000000000007600000028000000280000000A0000000100
            040000000000C800000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            888888888888888888888888888888887788888888FF88888888FF88888888FF
            88888888F7888888887F888888887F888888880F8888888F877888888778F888
            888788F888888078F888888F887888888788F888888788F888888078F88888F8
            8877888877888F888878888F888807888F8888F88887888878888F888878888F
            888807888F888F8888877887788888F887888888F880788888F88FFFFFFF7887
            777777F887777777F880000000F8888888888888888888888888888888888888
            8888}
          NumGlyphs = 4
          OnClick = btnToggleSpecialProcClick
          ExplicitTop = 1
          ExplicitWidth = 316
        end
        object pnlLeftTop: TPanel
          Left = 1
          Top = 1
          Width = 318
          Height = 490
          Align = alTop
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          object gbBundles: TGroupBox
            Left = 1
            Top = 1
            Width = 316
            Height = 46
            Align = alTop
            Caption = 'Lab / Procedure Order Bundles'
            TabOrder = 0
            DesignSize = (
              316
              46)
            object cboBundles: TComboBox
              Left = 3
              Top = 22
              Width = 308
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              ItemHeight = 13
              TabOrder = 0
              OnChange = cboBundlesChange
              Items.Strings = (
                'Annual Diabetes'
                'Screening'
                'Screening w/Vitamins'
                'Screening w/Vit, UA'
                'Diabetes')
            end
          end
          object tcProcTabs: TTabControl
            Left = 1
            Top = 47
            Width = 316
            Height = 442
            Align = alTop
            Anchors = [akLeft, akTop, akRight, akBottom]
            TabOrder = 1
            OnChange = tcProcTabsChange
            object pnlProcedures: TPanel
              Left = 4
              Top = 6
              Width = 308
              Height = 432
              Align = alClient
              BevelOuter = bvSpace
              BorderStyle = bsSingle
              TabOrder = 0
              object pnlProcCaption: TPanel
                Left = 1
                Top = 1
                Width = 302
                Height = 25
                Align = alTop
                BevelOuter = bvNone
                Caption = 'Lab / Procedure '
                Color = clGradientActiveCaption
                TabOrder = 0
              end
              object cklbProcedures: TCheckListBox
                Left = 1
                Top = 26
                Width = 302
                Height = 401
                Align = alClient
                BevelInner = bvNone
                BevelOuter = bvNone
                BorderStyle = bsNone
                ItemHeight = 13
                Items.Strings = (
                  'Lab test'
                  'Lab test'
                  'Lab test'
                  'Lab test'
                  'Lab test'
                  'Lab test'
                  'Lab test')
                TabOrder = 1
                OnClick = cklbCommonClick
              end
            end
          end
        end
        object pnlBottom: TPanel
          Left = 1
          Top = 496
          Width = 318
          Height = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          DesignSize = (
            318
            0)
          object lblOtherProc: TLabel
            Left = 26
            Top = 2
            Width = 86
            Height = 13
            Caption = 'Other Procedures:'
          end
          object Label1: TLabel
            Left = 5
            Top = 15
            Width = 107
            Height = 13
            Caption = 'Separate with commas'
          end
          object lblComments: TLabel
            Left = 34
            Top = 56
            Width = 78
            Height = 13
            Caption = 'Order Comments'
          end
          object memOrderComment: TMemo
            Left = 118
            Top = 35
            Width = 192
            Height = 60
            Anchors = [akLeft, akTop, akRight, akBottom]
            ScrollBars = ssVertical
            TabOrder = 0
            OnChange = memChange
          end
          object edtOtherOrder: TEdit
            Left = 118
            Top = 5
            Width = 182
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
            OnChange = edtEditChange
          end
        end
      end
      object pnlOrderAreaRight: TPanel
        Left = 326
        Top = 1
        Width = 536
        Height = 524
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 1
        object splitterRight: TSplitter
          Left = 1
          Top = 370
          Width = 534
          Height = 5
          Cursor = crVSplit
          Align = alTop
          ExplicitTop = 369
          ExplicitWidth = 274
        end
        object btnToggleSpecialDx: TSpeedButton
          Left = 1
          Top = 503
          Width = 534
          Height = 20
          Align = alBottom
          Caption = 'CLOSE  Custom Dx'
          Glyph.Data = {
            3E010000424D3E010000000000007600000028000000280000000A0000000100
            040000000000C800000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            888888888888888888888888888888887788888888FF88888888FF88888888FF
            88888888F7888888887F888888887F888888880F8888888F877888888778F888
            888788F888888078F888888F887888888788F888888788F888888078F88888F8
            8877888877888F888878888F888807888F8888F88887888878888F888878888F
            888807888F888F8888877887788888F887888888F880788888F88FFFFFFF7887
            777777F887777777F880000000F8888888888888888888888888888888888888
            8888}
          NumGlyphs = 4
          OnClick = btnToggleSpecialProcClick
          ExplicitLeft = 6
          ExplicitTop = 363
          ExplicitWidth = 250
        end
        object pnlRightTop: TPanel
          Left = 1
          Top = 1
          Width = 534
          Height = 369
          Align = alTop
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelOuter = bvNone
          TabOrder = 0
          object pnlRightTopHeading: TPanel
            Left = 0
            Top = 0
            Width = 534
            Height = 50
            Align = alTop
            TabOrder = 2
            DesignSize = (
              534
              50)
            object memDxInstructions: TMemo
              Left = 5
              Top = 5
              Width = 525
              Height = 40
              Anchors = [akLeft, akTop, akRight, akBottom]
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              Color = clBtnFace
              Lines.Strings = (
                'Select Diagnosis')
              TabOrder = 0
            end
          end
          object tcDxSelect: TTabControl
            Left = 0
            Top = 50
            Width = 534
            Height = 25
            Align = alTop
            TabOrder = 0
            Tabs.Strings = (
              'All'
              'Specific'
              'Prev Dx'#39's')
            TabIndex = 0
            OnChange = tcDxSelectChange
          end
          object cklbDisplayedDxs: TCheckListBox
            Left = 0
            Top = 75
            Width = 534
            Height = 294
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            ItemHeight = 13
            TabOrder = 1
            OnClick = cklbCommonClick
          end
        end
        object pnlRightBottom: TPanel
          Left = 1
          Top = 375
          Width = 534
          Height = 128
          Align = alClient
          TabOrder = 1
          DesignSize = (
            534
            128)
          object pnlCustomDx: TPanel
            Left = 0
            Top = 5
            Width = 533
            Height = 121
            Anchors = [akLeft, akTop, akRight, akBottom]
            BevelOuter = bvNone
            TabOrder = 0
            DesignSize = (
              533
              121)
            object edtDx0: TEdit
              Left = 5
              Top = 1
              Width = 518
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              OnChange = edtEditChange
            end
            object edtDx1: TEdit
              Tag = 1
              Left = 5
              Top = 28
              Width = 518
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnChange = edtEditChange
            end
            object edtDx2: TEdit
              Tag = 2
              Left = 5
              Top = 55
              Width = 518
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 2
              OnChange = edtEditChange
            end
            object edtDx3: TEdit
              Tag = 3
              Left = 5
              Top = 82
              Width = 518
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 3
              Visible = False
              OnChange = edtEditChange
            end
            object btnSrchICD: TBitBtn
              Tag = 12
              Left = 5
              Top = 79
              Width = 518
              Height = 38
              Hint = 'Search for Custom Diagnosis'
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'Select Encounter ICD'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = btnSrchICDClick
              Glyph.Data = {
                42100000424D4210000000000000420000002800000020000000200000000100
                20000300000000100000130B0000130B000000000000000000000000FF0000FF
                0000FF000000DF9360FFCD8E68FFC59377FFDF9361FFDF9360FFDF9360FFD78D
                5CFFCA8556FFCA8456FFCA8456FFCA8456FFCA8456FFCA8456FFCA8456FFCA84
                56FFCA8456FFCA8456FFCA8456FFCA8456FFCA8456FFCA8456FFCA8456FFCA84
                56FFCA8456FFCA8556FFD78D5CFFDF9360FFDF9360FFDF9360FFDF9360FFDF93
                60FFDF9360FFD59167FF665E5CFF858687FFC39E8DFFDA905FFF94603DFF3E30
                29FF5B5856FF5E5B59FF5E5B59FF5E5B59FF5E5B59FF5E5B59FF5E5B59FF5E5B
                59FF5E5B59FF5E5B59FF5E5B59FF5E5B59FF5E5B59FF5E5B59FF5E5B59FF5E5B
                59FF5E5B59FF5B5856FF3E3029FF94603DFFDA905EFFDF9360FFDF9360FFDF93
                60FFDF9360FFD99367FF8F827DFF56585AFF8C8D8FFF9D8E88FF827F7DFFD7D4
                D0FFE3E0DCFFE4E1DDFFE4E1DDFFE4E1DDFFE4E1DDFFE4E1DDFFE4E1DDFFE4E1
                DDFFE4E1DDFFE4E1DDFFE4E1DDFFE4E1DDFFE4E1DDFFE4E1DDFFE4E1DDFFE4E1
                DDFFE4E1DDFFE3E0DCFFD7D4D0FF827F7DFF885838FFDE9260FFDF9360FFDF93
                60FFDF9360FFDF9360FFD6946CFF91847FFF585A5CFF929394FFC6C4C2FFF4F3
                F1FFFEFEFDFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
                FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
                FEFFFEFEFEFFFEFEFDFFF4F3F1FFDEDBD7FF504C49FFCA8456FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFD7946CFF88807DFF595B5DFF98999BFFDADA
                DBFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFEFEFEFFEDEAE8FF898684FFB1744BFFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAB795CFF838384FF5C5D60FF9E9F
                A0FFDADBDBFFD0D0D0FFC4C4C4FFCFCFCFFFD2D2D2FFD4D4D4FFC3C3C3FFD3D3
                D3FFC4C4C4FFFBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1EFEDFF8F8D8BFFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF928F8EFF969697FF5C5E
                61FFA5A6A7FFD2D3D3FFEAEAE9FFE6E6E5FFEAEAEAFFE9E8E8FFE8E7E7FFEDED
                EDFFE7E7E7FFEAEAE9FFEAEAEAFFE7E7E6FFEFEFEEFFEAE9E9FFE7E6E6FFEDED
                ECFFFEFEFEFFFEFEFEFFFEFEFEFFF1EFEEFF908E8CFFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF908E8DFFE8E7E5FF9A9B
                9CFF5E6062FFA8A9AAFFD2D3D3FFE2E2E2FFE7E7E7FFE3E3E3FFE3E3E3FFEBEB
                EBFFE3E3E3FFEAEAEAFFEEEEEEFFE2E2E2FFEAEAEAFFE6E6E6FFDEDEDEFFE8E8
                E8FFFDFDFDFFFEFEFEFFFEFEFEFFF2F0EFFF918F8DFFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF918F8DFFF2F1EFFFF4F3
                F3FF9A9B9BFF5F6264FFACADAEFFC3C2C2FFC3C3C3FFD6D6D6FFB2B1B1FF8F8E
                8EFF8A8989FF888888FF818181FFB6B6B6FFC3C3C3FFCBCBCBFFD0CFCFFFFBFB
                FBFFFEFDFDFFFEFDFDFFFEFDFDFFF2F1EFFF918F8EFFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF92908EFFF2F1F0FFFDFD
                FDFFF4F4F4FFA2A2A3FF636567FFA9AAABFFBDBDBEFF6E6E6EFF6F7070FFB3B4
                B4FFE6E6E6FFE9E9E9FFCBCBCAFF909191FF6B6B6BFFD7D7D7FFFDFDFDFFFDFD
                FDFFFDFDFDFFFDFDFDFFFDFDFDFFF2F1F0FF92908FFFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF92918FFFF3F1F0FFFCFC
                FCFFFCFCFBFFEEEEEEFFCECDCEFF545658FF444545FFB6B6B6FFEBEBEBFFEFEF
                EEFFF4F4F4FFF4F3F3FFF3F3F2FFF2F2F2FFCECECDFF5E5E5EFFC6C5C5FFF5F5
                F5FFF6F5F5FFFCFCFBFFFCFCFCFFF3F1F0FF93918FFFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF939290FFF3F2F0FFFCFB
                FBFFFBFBFAFFDEDDDDFFC7C7C6FF474646FFAFAFAFFFCDCCCCFFC2C1C1FFBCBC
                BCFFA8A8D9FF8E8EEBFFBCBBBCFFC2C1C1FFC8C7C7FFBDBDBCFF555555FFB8B8
                B8FFCFCFCEFFFBFBFAFFFCFBFBFFF3F2F0FF949290FFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF949391FFF4F2F1FFFBFA
                FAFFFAFAF9FFCDCDCDFF8C8C8BFF8B8A8AFFC3C3C3FFB6B6B5FFB0B0B0FFBCBC
                BBFF8585DDFF5050F9FFB1B2B4FFB6B6B6FFB4B4B4FFC1C1C1FFA4A5A4FF6C6B
                6BFFC4C4C4FFF0EFEFFFFBFAFAFFF4F2F1FF949391FFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF959392FFF4F2F1FFFAF9
                F9FFF9F9F8FFE3E3E2FF5C5C5DFFCFCECEFFD7D6D6FFBFBFBFFFC1C1C1FFC1C1
                C0FF9292E2FF5959F9FFC2C2C4FFBEBFBEFFBFBFBFFFD1D1D0FFE1E1E0FF6C6C
                6CFFEAE9E9FFFAF9F9FFFAF9F9FFF4F2F1FF959392FFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF959493FFF4F3F1FFF9F8
                F7FFF9F8F7FFD4D4D3FF626262FFDFDFDFFFDEDDDEFFB1B1CFFFAFAED2FFB0B0
                D2FF8787E9FF5757FAFFAFAFD3FFADADD0FFAEAFD2FFCFCFDAFFE8E7E6FFA1A1
                A0FFCDCCCCFFF9F8F7FFF9F8F7FFF4F2F1FF959392FFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF969594FFF4F3F1FFF8F7
                F6FFF7F6F5FFB9B8B7FF807F7FFFC3C3C2FFC5C4DDFF4C4DFCFF4C4CFCFF4E4E
                FCFF4B4CFCFF4A4AFEFF4E4FFCFF4F4FFCFF4B4BFDFFA1A1EAFFCACAC9FFAAA9
                A9FFC8C7C7FFF8F7F6FFF7F6F5FFF2F1EFFF949391FFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF979695FFF4F3F2FFF7F6
                F5FFF6F5F4FFC1C0C0FF707070FFC8C7C6FFD3D2D5FFA5A5C7FFA5A5C8FFA7A7
                C9FF8180E6FF5858FAFFA6A5C9FFA5A4C7FFA7A7CBFFBFBEC9FFCBCACAFFA5A4
                A4FFB7B7B6FFF6F5F4FFF5F4F2FFF0EEECFF93918FFFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF979696FFF5F3F2FFF6F4
                F3FFF5F4F3FFDCDBDAFF515151FFE2E0DFFFDFDEDDFFC4C4C3FFC5C4C4FFC6C6
                C4FF9696E4FF6060FBFFC3C3C5FFC6C5C5FFC7C5C5FFD7D5D5FFE1E0DFFF8483
                83FFCCCBC9FFF4F2F1FFF1EFEDFFECE9E6FF908D8BFFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF989796FFF5F3F2FFF4F3
                F2FFF4F2F1FFD4D3D2FF717171FFB1B0AFFFDADAD9FFBABAB9FFBBBABAFFBDBC
                BCFF8F8FE1FF5D5DFBFFBBBBBDFFBCBBBBFFBBBABAFFCAC9C8FFCACAC9FF5958
                58FFC9C8C6FFF0EDECFFECE9E6FFE6E1DDFF8A8784FFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF999897FFF5F3F2FFF3F1
                F0FFF2F1EFFFC9C7C6FFADABABFF4C4C4BFFBAB8B7FFC3C2C1FFB5B4B4FFB3B2
                B2FF9594E0FF6666F5FFAFAEB0FFB4B3B2FFC3C2C1FFC2C2C1FF7A7979FF8887
                86FFE4E2DFFFEBE8E5FFE4E0DBFFDAD4CEFF817C77FFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF999998FFF5F3F2FFF2F0
                EEFFF1F0EEFFD8D6D5FFCFCECCFF868584FF666665FFD1CFCDFFCECCCCFFD2D2
                D0FFCFCECEFFD3D2D3FFDDDCDBFFD5D3D3FFDAD9D7FF929190FF696867FFD1CF
                CCFFCBC8C5FFE2DED9FFD8D1CBFFC9C0B6FF746C65FFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF9A9999FFF4F3F2FFF0EE
                ECFFF0EEECFFDEDCDAFFE0DEDCFFDAD8D6FF91908FFF565655FFB7B5B5FFDAD9
                D8FFE0DEDDFFE2E1DFFFE1DFDDFFC6C5C4FF767675FF787675FFD6D3D0FFDBD7
                D3FFD3CEC8FFD4CDC6FFC4BAB0FFB0A396FF61584EFFAE7249FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF9B9A9AFFF4F3F1FFEEEC
                EAFFEEECE9FFC9C7C5FFC2C0BEFFCAC8C6FFC2C1BFFFAAA8A7FF6A6968FF4848
                48FF767574FF767575FF5B5A5AFF787776FFB7B5B3FFD8D4CDFFDFD9D4FFE8E4
                E0FFE6E2DEFFE3DEDAFFDDD9D4FFCEC8C3FF524B46FFB1744BFFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF9B9B9AFFF4F3F1FFCAC7
                EFFFA4A2F5FFEBE7E9FFE6E3EAFFB4B3F3FFA19FF6FFC1BFF1FFEBE8E8FFC2C0
                E5FF9593E5FF9694E6FFA9A7E6FFE4E1E8FFDBD5CFFFECE8E5FFF0EEECFFE7E3
                E0FFE6E3E0FFE8E5E2FFF2F1F0FF898988FF825435FFDB905EFFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF9C9C9BFFF4F3F1FFAAA8
                F3FF3C3CFEFFE6E3E8FF8785F8FF4746FDFF8C8AF8FF1E1EFFFFBBB9F1FFADAB
                F3FF1E1EFFFF908EF7FF4140FEFF8785F7FFD9D3CCFFF3F1F0FFE2DEDAFFE2DE
                DAFFE4E0DCFFF2F0F0FF8D8D8CFF825435FFDB905EFFDF9360FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF9C9C9CFFF4F2F1FFA9A7
                F2FF3C3BFEFFDCD8E8FF3534FEFFADAAF2FFE9E6E3FFBCB8EEFFD4D0E9FFABA8
                F2FF3736FEFFE2DFE4FFA09EF2FF4241FDFFDAD5D5FFEDEBE8FFE2DEDAFFE4E0
                DCFFF2F1F0FF8E8E8EFF835435FFDB905EFFDF9360FFDF9360FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFAE7249FF9D9D9DFFF4F2F1FFA7A5
                F1FF3B3AFDFFDCD9E4FF3F3EFDFF9997F3FFE4E1E1FFC4C2EAFFD7D4E5FFA8A6
                F0FF3635FEFFDCD8DEFF8987F2FF4B49FAFFD8D2D0FFEDEAE8FFE4E0DCFFF2F1
                F0FF8E8E8EFF865637FFDB915EFFDF9360FFDF9360FFDF9360FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFB1744BFF979797FFF6F5F4FFA6A4
                F0FF3A39FDFFDFDBE0FFA5A2F0FF1818FFFF3F3DFDFF2E2DFEFFC7C3E8FFA7A4
                EEFF0A09FFFF3E3CFCFF1010FFFF938DE2FFD5CFC9FFEFECEAFFF1F0EFFF8989
                89FF865637FFDC915FFFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFCA8456FF595756FFF7F6F6FFDDDB
                EDFFC4C0E8FFE1DDDDFFE3DFDCFFD1CDE2FFC3C0E7FFD6D3E1FFE2DEDAFFD0CB
                DEFFBBB7E1FFB5B0DBFFB7B0CBFFB9AFA6FFCEC8C2FFF7F6F6FF898989FF8656
                37FFDB915EFFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFDE9260FF885838FF919191FFF2F2
                F2FFFCFCFBFFFBFBFAFFFBFBFAFFFBFBFAFFFBFAFAFFF9F9F8FFF7F6F5FFF3F1
                EFFFEBE8E5FFE0DBD5FFCEC6BDFFB5A99CFFC4BDB7FF898989FF865637FFDB91
                5EFFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDA905EFF94603DFF4236
                30FF676565FF6A6868FF6A6868FF6A6868FF6A6868FF696767FF676564FF6563
                61FF615E5BFF5B5753FF524B46FF453D35FF38322CFF865637FFDB915EFFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFD78D
                5CFFCA8556FFCA8456FFCA8456FFCA8456FFCA8456FFCA8456FFCA8456FFCA84
                56FFCA8456FFCA8456FFCA8456FFCA8456FFCA8556FFDC915FFFDF9360FFDF93
                60FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF9360FFDF93
                60FFDF9360FF}
            end
          end
        end
      end
    end
    object memProcInfo: TMemo
      Left = 875
      Top = 337
      Width = 185
      Height = 184
      Anchors = [akTop, akRight, akBottom]
      Color = clCream
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 6
    end
  end
  inherited cmdAccept: TButton
    Left = 962
    Top = 554
    Width = 95
    Anchors = [akRight, akBottom]
    ExplicitLeft = 962
    ExplicitTop = 554
    ExplicitWidth = 95
  end
  inherited cmdQuit: TButton
    Left = 962
    Top = 581
    Width = 95
    Anchors = [akRight, akBottom]
    ExplicitLeft = 962
    ExplicitTop = 581
    ExplicitWidth = 95
  end
  inherited pnlMessage: TPanel
    Left = 50
    Top = 590
    Width = 383
    ExplicitLeft = 50
    ExplicitTop = 590
    ExplicitWidth = 383
  end
  inherited chkCopyWhenAccepted: TCheckBox
    Left = 88
    Top = 562
    ExplicitLeft = 88
    ExplicitTop = 562
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 112
    Top = 144
    Data = (
      (
        'Component = sbxMain'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Label = lblOrderSig'
        'Status = stsOK')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODTMG1'
        'Status = stsDefault')
      (
        'Component = gbBundles'
        'Status = stsDefault')
      (
        'Component = cboBundles'
        'Status = stsDefault')
      (
        'Component = rgGetLabsTiming'
        'Status = stsDefault')
      (
        'Component = btnClear'
        'Status = stsDefault')
      (
        'Component = cklbOther'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = memOrderComment'
        'Status = stsDefault')
      (
        'Component = pnlFlags'
        'Status = stsDefault')
      (
        'Component = cklbFlags'
        'Status = stsDefault')
      (
        'Component = tcProcTabs'
        'Status = stsDefault')
      (
        'Component = pnlProcedures'
        'Status = stsDefault')
      (
        'Component = pnlProcCaption'
        'Status = stsDefault')
      (
        'Component = cklbProcedures'
        'Status = stsDefault')
      (
        'Component = edtOtherOrder'
        'Status = stsDefault')
      (
        'Component = rgProvider'
        'Status = stsDefault')
      (
        'Component = edtOtherTime'
        'Status = stsDefault')
      (
        'Component = pnlOrderAreaMain'
        'Status = stsDefault')
      (
        'Component = pnlOrderAreaLeft'
        'Status = stsDefault')
      (
        'Component = pnlOrderAreaRight'
        'Status = stsDefault')
      (
        'Component = pnlRightTop'
        'Status = stsDefault')
      (
        'Component = tcDxSelect'
        'Status = stsDefault')
      (
        'Component = cklbDisplayedDxs'
        'Status = stsDefault')
      (
        'Component = pnlRightBottom'
        'Status = stsDefault')
      (
        'Component = pnlCustomDx'
        'Status = stsDefault')
      (
        'Component = edtDx0'
        'Status = stsDefault')
      (
        'Component = edtDx1'
        'Status = stsDefault')
      (
        'Component = edtDx2'
        'Status = stsDefault')
      (
        'Component = edtDx3'
        'Status = stsDefault')
      (
        'Component = pnlLeftTop'
        'Status = stsDefault')
      (
        'Component = pnlRightTopHeading'
        'Status = stsDefault')
      (
        'Component = memDxInstructions'
        'Status = stsDefault')
      (
        'Component = btnSrchICD'
        'Status = stsDefault')
      (
        'Component = memProcInfo'
        'Status = stsDefault'))
  end
  inherited VA508CompMemOrder: TVA508ComponentAccessibility
    Left = 72
    Top = 144
  end
  object tmrDelayProcInfo: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrDelayProcInfoTimer
    Left = 920
    Top = 392
  end
end
