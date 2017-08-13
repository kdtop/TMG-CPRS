object frmPtDemoEdit: TfrmPtDemoEdit
  Left = 2
  Top = 2
  Caption = 'Edit Patient Demographics'
  ClientHeight = 467
  ClientWidth = 634
  Color = clBtnFace
  Constraints.MinHeight = 501
  Constraints.MinWidth = 642
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    634
    467)
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 344
    Top = 434
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 536
    Top = 434
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object ApplyBtn: TButton
    Left = 424
    Top = 434
    Width = 107
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Apply Changes'
    Enabled = False
    TabOrder = 1
    OnClick = ApplyBtnClick
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 634
    Height = 427
    ActivePage = tsDemographics
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    OnChange = PageControlChange
    OnChanging = PageControlChanging
    object tsDemographics: TTabSheet
      Caption = 'Demographics'
      DesignSize = (
        626
        399)
      object LNameLabel: TLabel
        Left = 27
        Top = 32
        Width = 57
        Height = 13
        Caption = 'Family/Last:'
      end
      object FNameLabel: TLabel
        Left = 29
        Top = 56
        Width = 55
        Height = 13
        Caption = 'Given/First:'
      end
      object MNameLabel: TLabel
        Left = 50
        Top = 80
        Width = 34
        Height = 13
        Caption = 'Middle:'
      end
      object CombinedNameLabel: TLabel
        Left = 56
        Top = 8
        Width = 28
        Height = 13
        Caption = 'Name'
      end
      object PrefixLabel: TLabel
        Left = 337
        Top = 136
        Width = 26
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Prefix'
      end
      object SuffixLabel: TLabel
        Left = 106
        Top = 104
        Width = 26
        Height = 13
        Caption = 'Suffix'
      end
      object DOBLabel: TLabel
        Left = 73
        Top = 128
        Width = 59
        Height = 13
        Caption = 'Date of Birth'
      end
      object SSNumLabel: TLabel
        Left = 21
        Top = 152
        Width = 79
        Height = 13
        Caption = 'Social Sec Num.'
      end
      object SexLabel: TLabel
        Left = 62
        Top = 176
        Width = 21
        Height = 13
        Caption = 'Sex:'
        Constraints.MinHeight = 13
        Constraints.MinWidth = 21
      end
      object DegreeLabel: TLabel
        Left = 463
        Top = 137
        Width = 35
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Degree'
      end
      object Label3: TLabel
        Left = 336
        Top = 160
        Width = 29
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'EMail:'
      end
      object Label1: TLabel
        Left = 336
        Top = 185
        Width = 33
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Skype:'
      end
      object CombinedNameEdit: TEdit
        Left = 95
        Top = 8
        Width = 213
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = CombinedNameEditChange
      end
      object LNameEdit: TEdit
        Left = 95
        Top = 32
        Width = 213
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        OnChange = LNameEditChange
      end
      object FNameEdit: TEdit
        Left = 95
        Top = 56
        Width = 213
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        OnChange = FNameEditChange
      end
      object MNameEdit: TEdit
        Left = 95
        Top = 80
        Width = 213
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        OnChange = MNameEditChange
      end
      object PrefixEdit: TEdit
        Left = 373
        Top = 136
        Width = 66
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 8
        OnChange = PrefixEditChange
      end
      object SuffixEdit: TEdit
        Left = 143
        Top = 104
        Width = 165
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 4
        OnChange = SuffixEditChange
      end
      object DOBEdit: TEdit
        Left = 143
        Top = 128
        Width = 166
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        OnChange = DOBEditChange
      end
      object SSNumEdit: TEdit
        Left = 103
        Top = 152
        Width = 206
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 6
        OnChange = SSNumEditChange
      end
      object AliasGroupBox: TGroupBox
        Left = 320
        Top = 8
        Width = 297
        Height = 121
        Anchors = [akTop, akRight]
        Caption = 'Alias'
        TabOrder = 10
        TabStop = True
        object AliasNameLabel: TLabel
          Left = 16
          Top = 48
          Width = 53
          Height = 13
          Caption = 'Alias Name'
        end
        object AliasSSNumLabel: TLabel
          Left = 8
          Top = 80
          Width = 64
          Height = 13
          Caption = 'Alias SS Num'
        end
        object AliasComboBox: TComboBox
          Left = 8
          Top = 16
          Width = 161
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = AliasComboBoxChange
          Items.Strings = (
            'Stuff here...'
            '<Add New Alias>')
        end
        object AliasNameEdit: TEdit
          Left = 80
          Top = 48
          Width = 201
          Height = 21
          Color = clInactiveBorder
          Enabled = False
          TabOrder = 1
          OnChange = AliasNameEditChange
        end
        object AliasSSNEdit: TEdit
          Left = 80
          Top = 80
          Width = 201
          Height = 21
          Color = clInactiveBorder
          Enabled = False
          TabOrder = 2
          OnChange = AliasSSNEditChange
        end
        object DelAliasBtn: TButton
          Left = 227
          Top = 16
          Width = 54
          Height = 22
          Caption = 'Delete'
          TabOrder = 3
          OnClick = DelAliasBtnClick
        end
        object AddAliasBtn: TButton
          Left = 176
          Top = 16
          Width = 41
          Height = 22
          Caption = 'Add'
          TabOrder = 4
          OnClick = AddAliasBtnClick
        end
      end
      object AddressGroupBox: TGroupBox
        Left = 8
        Top = 207
        Width = 440
        Height = 185
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Address'
        TabOrder = 11
        DesignSize = (
          440
          185)
        object CityLabel: TLabel
          Left = 172
          Top = 96
          Width = 17
          Height = 13
          Caption = 'City'
        end
        object Zip4Label: TLabel
          Left = 162
          Top = 120
          Width = 27
          Height = 13
          Caption = 'Zip+4'
        end
        object StartingDateLabel: TLabel
          Left = 104
          Top = 152
          Width = 62
          Height = 13
          Caption = 'Starting Date'
          Visible = False
        end
        object EndingDateLabel: TLabel
          Left = 312
          Top = 152
          Width = 33
          Height = 26
          Caption = 'Ending Date'
          Visible = False
          WordWrap = True
        end
        object AddressRGrp: TRadioGroup
          Left = 8
          Top = 24
          Width = 153
          Height = 81
          Caption = 'Address to Edit'
          ItemIndex = 0
          Items.Strings = (
            'Permanent Address'
            'Temporary Address'
            'Confidential Address')
          TabOrder = 0
          OnClick = AddressRGrpClick
        end
        object AddressLine1Edit: TEdit
          Left = 176
          Top = 16
          Width = 225
          Height = 21
          TabOrder = 1
          OnChange = AddressLine1EditChange
        end
        object AddressLine2Edit: TEdit
          Left = 176
          Top = 38
          Width = 225
          Height = 21
          TabOrder = 2
          OnChange = AddressLine2EditChange
        end
        object AddressLine3Edit: TEdit
          Left = 176
          Top = 60
          Width = 225
          Height = 21
          TabOrder = 3
          OnChange = AddressLine3EditChange
        end
        object CityEdit: TEdit
          Left = 200
          Top = 96
          Width = 121
          Height = 21
          TabOrder = 4
          OnChange = CityEditChange
        end
        object StateComboBox: TComboBox
          Left = 328
          Top = 96
          Width = 73
          Height = 21
          ItemHeight = 13
          TabOrder = 5
          Text = '<State>'
          OnChange = StateComboBoxChange
          Items.Strings = (
            'AK'
            'AL'
            'AR'
            'AZ'
            'CA'
            'CO'
            'CT'
            'DC'
            'DE'
            'FL'
            'GA'
            'HI'
            'IA'
            'ID'
            'IL'
            'IN'
            'KS'
            'KY'
            'LA'
            'MA'
            'MD'
            'ME'
            'MI'
            'MN'
            'MO'
            'MS'
            'MT'
            'NC'
            'ND'
            'NE'
            'NH'
            'NJ'
            'NM'
            'NV'
            'NY'
            'OH'
            'OK'
            'OR'
            'PA'
            'RI'
            'SC'
            'SD'
            'TN'
            'TX'
            'UT'
            'VA'
            'VT'
            'WA'
            'WI'
            'WV'
            'WY')
        end
        object Zip4Edit: TEdit
          Left = 200
          Top = 120
          Width = 121
          Height = 21
          TabOrder = 6
          OnChange = Zip4EditChange
        end
        object BadAddressCB: TCheckBox
          Left = 16
          Top = 151
          Width = 89
          Height = 17
          Caption = 'Bad Address'
          TabOrder = 7
          OnClick = BadAddressCBClick
        end
        object TempActiveCB: TCheckBox
          Left = 16
          Top = 106
          Width = 129
          Height = 17
          Caption = 'Temp Address Active'
          TabOrder = 8
          OnClick = TempActiveCBClick
        end
        object StartingDateEdit: TEdit
          Left = 176
          Top = 152
          Width = 121
          Height = 21
          TabOrder = 9
          Visible = False
          OnChange = StartingDateEditChange
        end
        object EndingDateEdit: TEdit
          Left = 352
          Top = 152
          Width = 80
          Height = 21
          Anchors = [akLeft, akRight]
          TabOrder = 10
          Visible = False
          OnChange = EndingDateEditChange
        end
        object ConfActiveCB: TCheckBox
          Left = 16
          Top = 129
          Width = 129
          Height = 17
          Caption = 'Confidential Active'
          TabOrder = 11
          Visible = False
          OnClick = ConfActiveCBClick
        end
      end
      object SexComboBox: TComboBox
        Left = 104
        Top = 176
        Width = 206
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 7
        Text = '<Sex>'
        OnChange = SexComboBoxChange
        Items.Strings = (
          'MALE'
          'FEMALE')
      end
      object DegreeEdit: TEdit
        Left = 500
        Top = 137
        Width = 67
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 9
        OnChange = DegreeEditChange
      end
      object GroupBox1: TGroupBox
        Left = 453
        Top = 207
        Width = 170
        Height = 185
        Anchors = [akRight, akBottom]
        Caption = 'Phone Numbers'
        TabOrder = 12
        object PhoneNumGrp: TRadioGroup
          Left = 8
          Top = 16
          Width = 137
          Height = 89
          ItemIndex = 0
          Items.Strings = (
            'Residence'
            'Work'
            'Cell'
            'Temporary')
          TabOrder = 0
          OnClick = PhoneNumGrpClick
        end
        object PhoneNumEdit: TEdit
          Left = 8
          Top = 120
          Width = 137
          Height = 21
          TabOrder = 1
          Text = '<Phone Number>'
          OnChange = PhoneNumEditChange
        end
      end
      object EMailEdit: TEdit
        Left = 372
        Top = 160
        Width = 200
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 13
        OnChange = EMailEditChange
      end
      object SkypeEdit: TEdit
        Left = 372
        Top = 185
        Width = 200
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 14
        OnChange = SkypeEditChange
      end
      object btnSkypeCopy: TBitBtn
        Left = 578
        Top = 185
        Width = 27
        Height = 21
        TabOrder = 15
        OnClick = btnSkypeCopyClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFA56F6FA56F6FA56F6FA56F6FA56F6FA56F6FA56F6FA56F
          6FA56F6FA56F6FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA56F6FFEFEFCFE
          FEFEFEFEFCFEFEFCFEFEFCFEFEFCFEFEFCFEFEFCA56F6FFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFA56F6FFEFAF69E64589E64589E64589E64589E64589E64
          58FEFAF6A56F6FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA56F6FFEF6EFFE
          F8F3FEF6EFFEF6EFFEF6EFFEF6EFFEF6EFFEF6EFA56F6FFF00FFA56F6FA56F6F
          A56F6FA56F6FA56F6FA56F6FFEF3E79E64589E64589E64589E64589E64589E64
          58FEF3E7A56F6FFF00FFA56F6FFEFEFCFEFEFEFEFEFCFEFEFCA56F6FFEEFE1FF
          F0E3FEEFE1FEEFE1FEEFE1FEEFE1FEEFE1FEEFE1A56F6FFF00FFA56F6FFEFAF6
          9E64589E64589E6458A56F6FFFEBDA9E64589E64589E64589E64589E64589E64
          58FFEBDAA56F6FFF00FFA56F6FFEF6EFFEF8F3FEF6EFFEF6EFA56F6FFFE7D3FF
          E7D3FFE7D3FFE7D3FFE7D3E2C9BAE0CABACBB5A7A56F6FFF00FFA56F6FFEF3E7
          9E64589E64589E6458A56F6FFFE5CCFFE3CBFFE5CCFFE5CCFFE5CCB49591B596
          92BFA19CBF8181FF00FFA56F6FFEEFE1FFF0E3FEEFE1FEEFE1A56F6FFFE1C5FF
          E1C5FFE1C5FFE1C5FADCC1B69793FEFEFEBF8181FF00FFFF00FFA56F6FFFEBDA
          9E64589E64589E6458A56F6FFFDEC1FFDEC1FFDEC1FFDEC1E2C1ADC5A7A0BF81
          81FF00FFFF00FFFF00FFA56F6FFFE7D3FFE7D3FFE7D3FFE7D3A56F6FA56F6FA5
          6F6FA56F6FA56F6FA56F6FBF8181FF00FFFF00FFFF00FFFF00FFA56F6FFFE5CC
          FFE3CBFFE5CCFFE5CCFFE5CCB49591B59692BFA19CBF8181FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFA56F6FFFE1C5FFE1C5FFE1C5FFE1C5FADCC1B69793FE
          FEFEBF8181FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA56F6FFFDEC1
          FFDEC1FFDEC1FFDEC1E2C1ADC5A7A0BF8181FF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFA56F6FA56F6FA56F6FA56F6FA56F6FA56F6FBF8181FF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      end
    end
    object tsNotes: TTabSheet
      Caption = 'Notes'
      ImageIndex = 5
      object pnlHTMLEdit: TPanel
        Left = 0
        Top = 18
        Width = 626
        Height = 381
        Align = alClient
        BevelOuter = bvNone
        Color = clSkyBlue
        TabOrder = 0
      end
      object ToolBar: TToolBar
        Left = 0
        Top = 0
        Width = 626
        Height = 18
        AutoSize = True
        ButtonHeight = 18
        Caption = 'ToolBar'
        TabOrder = 1
        TabStop = True
        object cbFontNames: TComboBox
          Left = 0
          Top = 0
          Width = 145
          Height = 21
          ItemHeight = 13
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
          Left = 243
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
          Left = 266
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
          Left = 289
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
          Left = 312
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
          Left = 335
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
          Left = 358
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
          Left = 381
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
          Left = 404
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
          Left = 427
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
          Left = 450
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
        object btnTextColor: TSpeedButton
          Left = 473
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
          Left = 496
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
        object btnEditZoomOut: TSpeedButton
          Left = 519
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
          Left = 537
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
          OnClick = btnEditNormalZoomClick
        end
        object btnEditZoomIn: TSpeedButton
          Left = 555
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
    object tsBasic: TTabSheet
      Caption = 'Basic'
      ImageIndex = 4
      object gridBasicPatientDemo: TSortStringGrid
        Left = 0
        Top = 0
        Width = 626
        Height = 399
        Align = alClient
        TabOrder = 0
        OnSelectCell = gridPatientDemoSelectCell
        OnSetEditText = gridPatientDemoSetEditText
      end
    end
    object tsAdvanced: TTabSheet
      Caption = 'Advanced'
      ImageIndex = 1
      object gridPatientDemo: TSortStringGrid
        Left = 0
        Top = 0
        Width = 626
        Height = 399
        Align = alClient
        TabOrder = 0
        OnSelectCell = gridPatientDemoSelectCell
        OnSetEditText = gridPatientDemoSetEditText
      end
    end
    object tsKeene: TTabSheet
      Caption = 'Account'
      ImageIndex = 2
      OnHide = tsKeeneHide
      OnShow = tsKeeneShow
      object Label4: TLabel
        Left = 84
        Top = 43
        Width = 78
        Height = 13
        Caption = ' Record Number'
      end
      object Label5: TLabel
        Left = 50
        Top = 115
        Width = 114
        Height = 13
        Caption = 'Keane Account Number'
        Visible = False
      end
      object Label6: TLabel
        Left = 89
        Top = 147
        Width = 73
        Height = 13
        Caption = 'Admission Date'
      end
      object KeeneAcctNo: TEdit
        Left = 168
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 0
        Text = ' '
        OnChange = KeeneAcctNoChange
      end
      object KeeneAdmissionNumber: TEdit
        Left = 168
        Top = 112
        Width = 121
        Height = 21
        TabOrder = 1
        Text = 'KeeneAdmissionNumber'
        Visible = False
        OnChange = KeeneAdmissionNumberChange
      end
      object KeeneAdmissionDate: TDateTimePicker
        Left = 168
        Top = 144
        Width = 121
        Height = 21
        Date = 40499.575817662040000000
        Time = 40499.575817662040000000
        TabOrder = 2
        OnChange = KeeneAdmissionDateChange
      end
    end
    object tsExtra: TTabSheet
      Caption = 'Advanced 2'
      ImageIndex = 3
      object Button1: TButton
        Left = 80
        Top = 72
        Width = 169
        Height = 25
        Caption = 'Test FM Edit'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
  end
end
