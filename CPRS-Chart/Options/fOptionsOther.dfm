inherited frmOptionsOther: TfrmOptionsOther
  Left = 341
  Top = 96
  Hint = 'Use system default settings'
  HelpContext = 9110
  Align = alCustom
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Other Parameters'
  ClientHeight = 457
  ClientWidth = 409
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 415
  ExplicitHeight = 489
  PixelsPerInch = 96
  TextHeight = 13
  object lblMedsTab: TLabel [0]
    Left = 8
    Top = 188
    Width = 170
    Height = 13
    Hint = 'Set date ranges for displaying medication orders on Meds tab.'
    Caption = 'Set date range for Meds tab display:'
    ParentShowHint = False
    ShowHint = True
    WordWrap = True
  end
  object lblTab: TLabel [1]
    Left = 8
    Top = 27
    Width = 134
    Height = 13
    Caption = 'Initial tab when CPRS starts:'
  end
  object Bevel1: TBevel [2]
    Left = 1
    Top = 180
    Width = 415
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object lblEncAppts: TLabel [3]
    Left = 8
    Top = 277
    Width = 207
    Height = 13
    Hint = 'Set date range for Encounter Appointments.'
    Caption = 'Set date range for Encounter Appointments:'
    ParentShowHint = False
    ShowHint = True
    WordWrap = True
  end
  object Bevel2: TBevel [4]
    Left = 1
    Top = 260
    Width = 415
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object bvlBottom: TBevel [5]
    Left = 0
    Top = 0
    Width = 409
    Height = 2
    Align = alTop
    ExplicitWidth = 329
  end
  object lblTabPos: TLabel [6]
    Left = 232
    Top = 27
    Width = 106
    Height = 13
    Caption = 'Select Tab Positioning'
  end
  object lblTabColors: TLabel [7]
    Left = 8
    Top = 125
    Width = 83
    Height = 13
    Caption = 'Adjust Tab Colors'
  end
  object lblEditTabColor: TLabel [8]
    Left = 232
    Top = 128
    Width = 138
    Height = 13
    Caption = '(Click box below to edit color)'
  end
  object Bevel3: TBevel [9]
    Left = -6
    Top = 409
    Width = 415
    Height = 2
    Anchors = [akLeft, akTop, akRight]
  end
  object stStart: TStaticText [10]
    Left = 200
    Top = 207
    Width = 55
    Height = 17
    Caption = 'Start Date:'
    TabOrder = 1
  end
  object stStop: TStaticText [11]
    Left = 7
    Top = 207
    Width = 55
    Height = 17
    Caption = 'Stop Date:'
    TabOrder = 5
  end
  object pnlBottom: TPanel [12]
    Left = 0
    Top = 424
    Width = 409
    Height = 33
    HelpContext = 9110
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 7
    DesignSize = (
      409
      33)
    object btnOK: TButton
      Left = 243
      Top = 7
      Width = 75
      Height = 22
      HelpContext = 9996
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 324
      Top = 7
      Width = 75
      Height = 22
      HelpContext = 9997
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object lblTabDefault: TStaticText [13]
    Left = 8
    Top = 6
    Width = 52
    Height = 17
    Caption = 'Chart tabs'
    TabOrder = 0
  end
  object cboTab: TORComboBox [14]
    Left = 8
    Top = 46
    Width = 217
    Height = 21
    HelpContext = 9111
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Initial tab when CPRS starts:'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 2
    TabStop = True
    CharsNeedMatch = 1
  end
  object chkLastTab: TCheckBox [15]
    Left = 8
    Top = 75
    Width = 312
    Height = 21
    HelpContext = 9112
    Caption = 'Use last selected tab on patient change'
    TabOrder = 3
  end
  object stStartEncAppts: TStaticText [16]
    Left = 9
    Top = 304
    Width = 55
    Height = 17
    Caption = 'Start Date:'
    TabOrder = 11
  end
  object txtTodayMinus: TStaticText [17]
    Left = 38
    Top = 329
    Width = 64
    Height = 17
    Alignment = taRightJustify
    Caption = 'Today minus'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 13
  end
  object txtEncStart: TCaptionEdit [18]
    Left = 110
    Top = 326
    Width = 50
    Height = 21
    HelpContext = 9015
    MaxLength = 12
    TabOrder = 8
    Text = '0'
    OnChange = txtEncStartChange
    OnExit = txtEncStartExit
    Caption = 'Stop'
  end
  object txtDaysMinus: TStaticText [19]
    Left = 178
    Top = 330
    Width = 26
    Height = 17
    Caption = 'days'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 14
  end
  object spnEncStart: TUpDown [20]
    Tag = 30
    Left = 160
    Top = 326
    Width = 15
    Height = 21
    HelpContext = 9015
    Associate = txtEncStart
    Min = -999
    Max = 999
    TabOrder = 15
    Thousands = False
  end
  object txtDaysPlus: TStaticText [21]
    Left = 180
    Top = 382
    Width = 26
    Height = 17
    Caption = 'days'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 16
  end
  object spnEncStop: TUpDown [22]
    Tag = 30
    Left = 162
    Top = 377
    Width = 15
    Height = 21
    HelpContext = 9015
    Associate = txtEncStop
    Min = -999
    Max = 999
    TabOrder = 18
    Thousands = False
  end
  object txtEncStop: TCaptionEdit [23]
    Left = 112
    Top = 377
    Width = 50
    Height = 21
    HelpContext = 9015
    MaxLength = 12
    TabOrder = 9
    Text = '0'
    OnChange = txtEncStopChange
    OnExit = txtEncStopExit
    Caption = 'Stop'
  end
  object txtTodayPlus: TStaticText [24]
    Left = 46
    Top = 380
    Width = 56
    Height = 17
    Alignment = taRightJustify
    Caption = 'Today plus'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 19
  end
  object stStopEncAppts: TStaticText [25]
    Left = 10
    Top = 356
    Width = 55
    Height = 17
    Caption = 'Stop Date:'
    TabOrder = 22
  end
  object btnEncDefaults: TButton [26]
    Left = 263
    Top = 304
    Width = 75
    Height = 22
    HelpContext = 9011
    Caption = 'Use Defaults'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnClick = btnEncDefaultsClick
  end
  object dtStop: TORDateBox [27]
    Left = 200
    Top = 226
    Width = 186
    Height = 21
    TabOrder = 6
    OnExit = dtStopExit
    DateOnly = True
    RequireTime = False
    Caption = 'Stop Date'
  end
  object dtStart: TORDateBox [28]
    Left = 7
    Top = 226
    Width = 178
    Height = 21
    TabOrder = 4
    OnChange = dtStartChange
    OnExit = dtStartExit
    DateOnly = True
    RequireTime = False
    Caption = 'Start Date'
  end
  object TabPositionComboBox: TComboBox [29]
    Left = 231
    Top = 46
    Width = 145
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 23
    Text = 'Tabs on BOTTOM'
    OnChange = TabPositionComboBoxChange
    Items.Strings = (
      'Tabs on BOTTOM'
      'Tabs on TOP'
      'Tabs on LEFT'
      'Tabs on RIGHT')
  end
  object pnlShowColor: TPanel [30]
    Left = 232
    Top = 144
    Width = 145
    Height = 22
    BevelInner = bvLowered
    TabOrder = 24
    OnClick = pnlShowColorClick
  end
  object cboTabColors: TComboBox [31]
    Left = 8
    Top = 144
    Width = 217
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 25
    Text = ' '
    OnChange = cboTabColorsChange
    Items.Strings = (
      ' ')
  end
  object cbEnableTabColors: TCheckBox [32]
    Left = 8
    Top = 102
    Width = 169
    Height = 17
    Caption = 'Enable Custom Tab Colors'
    Checked = True
    State = cbChecked
    TabOrder = 26
    OnClick = cbEnableTabColorsClick
  end
  object cmbSSN_ID: TComboBox [33]
    Left = 257
    Top = 377
    Width = 113
    Height = 21
    ItemHeight = 13
    TabOrder = 27
    Text = 'SSN'
    Visible = False
    OnChange = cmbSSN_IDChange
    Items.Strings = (
      'SSN'
      'ID')
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 240
    Top = 328
    Data = (
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = stStart'
        'Status = stsDefault')
      (
        'Component = stStop'
        'Status = stsDefault')
      (
        'Component = dtStart'
        'Status = stsDefault')
      (
        'Component = dtStop'
        'Status = stsDefault')
      (
        'Component = lblTabDefault'
        'Status = stsDefault')
      (
        'Component = cboTab'
        'Status = stsDefault')
      (
        'Component = chkLastTab'
        'Status = stsDefault')
      (
        'Component = stStartEncAppts'
        'Status = stsDefault')
      (
        'Component = txtTodayMinus'
        'Status = stsDefault')
      (
        'Component = txtEncStart'
        'Status = stsDefault')
      (
        'Component = txtDaysMinus'
        'Status = stsDefault')
      (
        'Component = spnEncStart'
        'Status = stsDefault')
      (
        'Component = txtDaysPlus'
        'Status = stsDefault')
      (
        'Component = spnEncStop'
        'Status = stsDefault')
      (
        'Component = txtEncStop'
        'Status = stsDefault')
      (
        'Component = txtTodayPlus'
        'Status = stsDefault')
      (
        'Component = stStopEncAppts'
        'Status = stsDefault')
      (
        'Component = btnEncDefaults'
        'Status = stsDefault')
      (
        'Component = frmOptionsOther'
        'Status = stsDefault'))
  end
  object ColorDialog: TColorDialog
    Left = 288
    Top = 96
  end
end
