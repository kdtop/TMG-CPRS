object frmPtAdd: TfrmPtAdd
  Left = 365
  Top = 160
  Caption = 'Add A Patient'
  ClientHeight = 316
  ClientWidth = 290
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 295
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = OnShow
  DesignSize = (
    290
    316)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 287
    Width = 39
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Label1'
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Visible = False
    ExplicitTop = 295
  end
  object OkButton: TButton
    Left = 106
    Top = 284
    Width = 89
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = '&Add Patient'
    TabOrder = 0
    OnClick = OkButtonClick
  end
  object CloseButton: TButton
    Left = 201
    Top = 284
    Width = 81
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = CancelButtonClick
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 290
    Height = 278
    ActivePage = tsMain
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    TabPosition = tpBottom
    object tsMain: TTabSheet
      Caption = 'C&ore'
      DesignSize = (
        282
        252)
      object LNameLabel: TLabel
        Left = 33
        Top = 20
        Width = 66
        Height = 13
        Caption = 'Family/Last'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object MNameLabel: TLabel
        Left = 64
        Top = 68
        Width = 34
        Height = 13
        Caption = 'Middle:'
      end
      object FNameLabel: TLabel
        Left = 33
        Top = 44
        Width = 64
        Height = 13
        Caption = 'Given/First'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SuffixLabel: TLabel
        Left = 70
        Top = 92
        Width = 26
        Height = 13
        Caption = 'Suffix'
      end
      object DOBLabel: TLabel
        Left = 24
        Top = 117
        Width = 73
        Height = 13
        Caption = 'Date of Birth'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 209
        Top = 117
        Width = 65
        Height = 13
        Anchors = [akTop, akRight]
        Caption = '(mm/dd/yy)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 206
      end
      object SSNumLabel: TLabel
        Left = 8
        Top = 139
        Width = 91
        Height = 13
        Alignment = taRightJustify
        Caption = 'Social Sec Num'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SSNHelpBtn: TSpeedButton
        Left = 248
        Top = 136
        Width = 23
        Height = 22
        Anchors = [akTop, akRight]
        Glyph.Data = {
          36010000424D3601000000000000760000002800000014000000100000000100
          040000000000C000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFF000FFF
          FFFFFFFF0000FFFFF06660FFFFFFFFFF0000FFFFF06660FFFFFFFFFF0000FFFF
          FF000FFFFFFFFFFF0000FFFFF06660FFFFFFFFFF0000FFFFF06660FFFFFFFFFF
          0000FFFFF066660FFFFFFFFF0000FFFFFF066660FFFFFFFF0000FFFFFFF06666
          0FFFFFFF0000FFF000FF06660FFFFFFF0000FF06660006660FFFFFFF0000FF06
          666666660FFFFFFF0000FF06666666660FFFFFFF0000FFF006666600FFFFFFFF
          0000FFFFF00000FFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000}
        OnClick = SSNHelpBtnClick
        ExplicitLeft = 245
      end
      object SexLabel: TLabel
        Left = 74
        Top = 164
        Width = 22
        Height = 13
        Caption = 'Sex'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object PrefixLabel: TLabel
        Left = 24
        Top = 210
        Width = 73
        Height = 13
        Caption = 'Patient Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Label12: TLabel
        Left = 9
        Top = 187
        Width = 94
        Height = 13
        Caption = 'Sequel Acct No.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LNameEdit: TEdit
        Left = 103
        Top = 16
        Width = 170
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = LNameEditChange
        OnKeyPress = LNameEditKeyPress
      end
      object FNameEdit: TEdit
        Left = 103
        Top = 40
        Width = 170
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        OnChange = FNameEditChange
        OnKeyPress = FNameEditKeyPress
      end
      object MNameEdit: TEdit
        Left = 103
        Top = 64
        Width = 170
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        OnChange = MNameEditChange
        OnKeyPress = MNameEditKeyPress
      end
      object SuffixEdit: TEdit
        Left = 103
        Top = 88
        Width = 170
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        OnChange = SuffixEditChange
        OnKeyPress = SuffixEditKeyPress
      end
      object DOBEdit: TEdit
        Left = 103
        Top = 112
        Width = 102
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
        OnChange = DOBEditChange
        OnExit = DOBEditExit
        OnKeyPress = DOBEditKeyPress
      end
      object SSNumEdit: TEdit
        Left = 103
        Top = 136
        Width = 141
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        OnChange = SSNumEditChange
        OnExit = SSNumEditExit
        OnKeyPress = SSNumEditKeyPress
      end
      object SexComboBox: TComboBox
        Left = 103
        Top = 160
        Width = 170
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 6
        Text = '<Sex>'
        OnChange = SexComboBoxChange
        OnKeyPress = SexComboBoxKeyPress
        Items.Strings = (
          'MALE'
          'FEMALE')
      end
      object PtTypeComboBox: TComboBox
        Left = 103
        Top = 205
        Width = 170
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 7
        Text = '<Pt Type>'
        Visible = False
        OnChange = PtTypeComboBoxChange
        OnKeyPress = PtTypeComboBoxKeyPress
        Items.Strings = (
          'ACTIVE DUTY'
          'ALLIED VETERAN'
          'COLLATERAL'
          'EMPLOYEE'
          'MILITARY RETIREE'
          'NON-VETERAN (OTHER)'
          'NSC VETERAN'
          'SC VETERAN'
          'TRICARE')
      end
      object VeteranCheckBox: TCheckBox
        Left = 103
        Top = 232
        Width = 161
        Height = 17
        Caption = 'Patient Is A Veteran'
        TabOrder = 8
        Visible = False
        OnClick = VeteranCheckBoxClick
      end
      object SequelAcctEdit: TEdit
        Left = 103
        Top = 183
        Width = 170
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 9
        OnChange = SequelAcctEditChange
        OnKeyPress = SequelAcctEditKeyPress
      end
    end
    object tsExtra: TTabSheet
      Caption = 'E&xtra'
      ImageIndex = 1
      DesignSize = (
        282
        252)
      object Label3: TLabel
        Left = 20
        Top = 5
        Width = 38
        Height = 13
        Caption = 'Address'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 11
        Top = 29
        Width = 47
        Height = 13
        Caption = 'Address 2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 41
        Top = 54
        Width = 17
        Height = 13
        Caption = 'City'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 33
        Top = 77
        Width = 25
        Height = 13
        Caption = 'State'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 43
        Top = 100
        Width = 15
        Height = 13
        Caption = 'Zip'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 27
        Top = 123
        Width = 31
        Height = 13
        Caption = 'Phone'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 41
        Top = 146
        Width = 17
        Height = 13
        Caption = 'Cell'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 29
        Top = 172
        Width = 29
        Height = 13
        Caption = 'E-Mail'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 14
        Top = 193
        Width = 44
        Height = 13
        Caption = 'Skype ID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object AddressLine1Edit: TEdit
        Left = 66
        Top = 3
        Width = 210
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = AddressLine1EditChange
      end
      object AddressLine2Edit: TEdit
        Left = 66
        Top = 26
        Width = 210
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        OnChange = AddressLine2EditChange
      end
      object CityEdit: TEdit
        Left = 66
        Top = 50
        Width = 210
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        OnChange = CityEditChange
      end
      object StateComboBox: TComboBox
        Left = 66
        Top = 74
        Width = 73
        Height = 21
        ItemHeight = 13
        TabOrder = 3
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
        Left = 66
        Top = 98
        Width = 121
        Height = 21
        TabOrder = 4
        OnChange = Zip4EditChange
      end
      object PhoneEdit: TEdit
        Left = 66
        Top = 121
        Width = 210
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        OnChange = Zip4EditChange
      end
      object CellEdit: TEdit
        Left = 66
        Top = 144
        Width = 210
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 6
        OnChange = Zip4EditChange
      end
      object EMailEdit: TEdit
        Left = 66
        Top = 167
        Width = 210
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 7
        OnChange = Zip4EditChange
      end
      object SkypeEdit: TEdit
        Left = 66
        Top = 190
        Width = 210
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 8
        OnChange = Zip4EditChange
      end
    end
  end
end
